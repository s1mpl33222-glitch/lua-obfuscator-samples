-- Why do i love gpt 5.6 sol high the reason is below.
-- dsc.gg/oxyenv 

if getgenv().__BF_LOADED then
	return getgenv().__BF_RESULT
end

Settings = {}
HttpService = game:GetService("HttpService")
FolderName = "Banana Cat Hub"
SaveFileNameGame = "-BloxFruitBNNC.json"
SaveFileName = game.Players.LocalPlayer.Name .. SaveFileNameGame

do
	local tbl = {
		["Start Farm"] = true,
		["Farm Mastery"] = true,
		["Farm Material"] = true,
		["Auto Farm Material"] = true,
		["Auto Farm Mastery"] = true,
		["Auto Farm Mastery 600 Melees"] = true,
		["Auto Farm Mastery 600 Sword In Inventory"] = true,
		["Auto Farm Gun Mastery"] = true,
		["Auto Farm Fruit Mastery"] = true,
		["Auto Farm Sword Mastery"] = true,
		["Auto Kill All Mob"] = true,
		["Auto Kill Boss"] = true,
		["Kill Boss"] = true,
		["Kill Mob"] = true,
		["Kill All Boss"] = true,
		["Auto Attack All Mob and Boss"] = true,
		["Auto Bartilo Quest"] = true,
		["Auto Sea Event"] = true,
		["Auto Sea Event With Friend"] = true,
		["Auto Attack Leviathan"] = true,
		["Auto Find Leviathan"] = true,
		["Multi Find Leviathan"] = true,
		["Auto Start Leviathan"] = true,
		["Drive Boat To Hydra"] = true,
		["Drive Boat To Tiki"] = true,
		["Tween Boat To Frozen Dimension"] = true,
		["Auto Tween To Event Fishing Spot"] = true,
		["Auto Raid"] = true,
		["Auto Multi Raid"] = true,
		["Auto Pirate Raid"] = true,
		["Auto Factory"] = true,
		["Auto Attack Dungeon"] = true,
		["Auto Join Dungeon"] = true,
		["Attack Rip Indra"] = true,
		["Auto Summon Rip Indra"] = true,
		["Attack Soul Reaper"] = true,
		["Summon Soul Reaper"] = true,
		["Attack Dough King"] = true,
		["Summon Dough King"] = true,
		["Attack Darkbeard"] = true,
		["Summon Darkbeard"] = true,
		["Auto Buy Chip and Attack Law"] = true,
		["Auto Rip Commander"] = true,
		["Auto Celestial Soldier"] = true,
		["Auto Elite Hunter"] = true,
		["Hop Server Elite Hunter"] = true,
		["Auto Chest"] = true,
		["Auto Chest Hop"] = true,
		["Auto Open Chest"] = true,
		["Auto Fishing"] = true,
		["Teleport To Fruit"] = true,
		["Teleport To Fruit [ Hop Server ]"] = true,
		["Teleport Mirage"] = true,
		["Teleport To Island"] = true,
		["Teleport To Npc"] = true,
		["Teleport Prehistoric Island"] = true,
		["Teleport Player"] = true,
		["Teleport Frozen Dimension"] = true,
		["Teleport To Kitsune Island"] = true,
		["Auto World"] = true,
		["Auto New World"] = true,
		["Auto Third World"] = true,
		["Auto CDK"] = true,
		["Auto Trial"] = true,
		["Auto Trial Draco"] = true,
		["Fully Trial Draco"] = true,
		["Auto Saber"] = true,
		["Auto Pole"] = true,
		["Auto Yama"] = true,
		["Auto Tushita"] = true,
		["Auto Rainbow Haki"] = true,
		["Auto Get Rainbow Haki"] = true,
		["Auto UP Observation V2"] = true,
		["Auto Observation V2"] = true,
		["Auto Get Ghoul"] = true,
		["Auto Get Cyborg"] = true,
		["Auto Get Fully Cyborg"] = true,
		["Auto Pull Lever"] = true,
		["Auto Soul Guitar"] = true,
		["Auto TTK"] = true,
		["Auto Yoru Mini"] = true,
		["Auto Yoru Mini (Hop Server)"] = true,
		["Auto Finish Train Quest"] = true,
		["Auto Finish Train Draco Quest"] = true,
		["Auto Upgrade Race V2-V3"] = true,
		["Auto Upgrade Race V2-V3 Draco"] = true,
		["Auto Spawn Kitsune Island"] = true,
		["Auto Touch Pad Haki"] = true,
		["Auto Event Halloween"] = true,
		["Auto Present Event"] = true,
		["Auto Find Mirage"] = true,
		["Auto Find Prehistoric Island"] = true,
		["Auto Event Prehistoric Island"] = true,
		["Fully Event Prehistoric Island"] = true,
		["Collect Chest When Server Spawn God's Chalice or Fist of Darkness"] = true,
		["Auto Collect Bone"] = true,
		["Auto Collect Soul Ember"] = true,
		["Auto Collect Berry"] = true,
		["Auto Collect Egg"] = true,
		["Auto Collect Egg Easter"] = true,
		["Auto Slap Battle"] = true,
		["Farm Observation"] = true,
		["Farm Observation [ Hop Server ]"] = true,
		["Auto Crafting Volcanic Magnet"] = true,
	}

	local tbl2 = {
		["Ignore Attack Katakuri"] = true,
		["Hop Find Katakuri"] = true,
		["Auto Quest [Katakuri/Bone/Tyrant]"] = true,
		["Auto Click"] = true,
		["Auto Click Fast"] = true,
		["Bring Mob"] = true,
		["Fast Attack"] = true,
		["Use skill fast dont hold"] = true,
		["Use M1 Fruit"] = true,
		["Auto Turn On Buso"] = true,
		["Auto Turn On Ken"] = true,
		["Auto Dodge Skill Mobs"] = true,
		["Auto Rejoin Disconnect"] = true,
		["Auto rejoin Disconnect"] = true,
		["Anti Report"] = true,
		["Auto Rejoin If Kick"] = true,
		["Auto Rejoin Kick"] = true,
		["Safe Mode"] = true,
		["Auto Teleport Bypass"] = true,
		["Hold Skill"] = true,
		["Auto Mastery Fruit If Max Level"] = true,
		["Farm Mastery [Gun/Fruit] Near Mob"] = true,
		["Fast Attack Material"] = true,
		["Auto Attack Bone"] = true,
		["Hop Server Katakuri [Mirror Fractal]"] = true,
		["Auto Turn On V3"] = true,
		["Auto Turn On V4"] = true,
		["Hop Server Rip Indra [Valkyrie Helm]"] = true,
		["Auto Attack Frozen Dimension"] = true,
		["Dodge Mobs Sea"] = true,
		["Auto Equip Weapon Sea Event"] = true,
		["Auto Turn On Ken Sea Event"] = true,
		["Auto Turn On Buso Sea Event"] = true,
		["Auto Use Skill V4 Sea Event"] = true,
		["Auto Use Skill Race V3 Sea Event"] = true,
		["Auto Dodge Skill Sea Event"] = true,
		["Auto Rejoin If Admin Join"] = true,
		["Ignore Leviathan"] = true,
		["Ignore Shark"] = true,
		["Ignore Terror Shark"] = true,
		["Ignore Piranha"] = true,
		["Ignore Fish Crew Member"] = true,
		["Ignore Ghost Ship"] = true,
		["Ignore Sea Beast"] = true,
		["Ignore Ship"] = true,
		["Auto Hop Server [Low Player]"] = true,
		["White Screen"] = true,
		["Black Screen"] = true,
		["Boost Fps"] = true,
		["Show Health Mob"] = true,
		["Show Distance Mob"] = true,
		["Show Distance Player"] = true,
		["Show Health Player"] = true,
		["Webhook Setting"] = true,
		["Notify Player Join"] = true,
		["Notify Player Left"] = true,
		["Auto Send Message In Server"] = true,
		["Auto Chat When Admin Join"] = true,
		["Show Canvas"] = true,
		["Show Target Name"] = true,
		["Show Weapon Target"] = true,
		["Show Distance Target"] = true,
		["Show Target Health"] = true,
		["Show Target Box"] = true,
		["Show Target Tracer"] = true,
		["Lock Camera"] = true,
		["Show Aim Point"] = true,
		["Look At Target"] = true,
		["Auto Turn On Ken PVP"] = true,
		["Auto Turn On Buso PVP"] = true,
		["Auto Turn On V3 PVP"] = true,
		["Auto Turn On V4 PVP"] = true,
		["Auto Translate"] = true,
		["Auto Stats"] = true,
		["Ignore Defense"] = true,
		["Anti AFK"] = true,
		Noclip = true,
	}

	SaveSettings = function(lastCancelledSetting, arg, arg2)
		if arg2 ~= nil then
			Settings[lastCancelledSetting] = Settings[lastCancelledSetting] or {}
			Settings[lastCancelledSetting][arg] = arg2
		elseif lastCancelledSetting ~= nil then
			Settings[lastCancelledSetting] = arg
		end

		if not isfolder(FolderName) then
			makefolder(FolderName)
		end

		writefile(FolderName .. "/" .. SaveFileName, HttpService:JSONEncode(Settings))

		if arg2 == nil and arg == false and type(lastCancelledSetting) == "string" then
			if tbl[lastCancelledSetting] and not tbl2[lastCancelledSetting] then
				getgenv().LastToggleCancelTime = tick()
				getgenv().LastCancelledSetting = lastCancelledSetting
				local tweenManager = getgenv().TweenManager or TweenManager

				if tweenManager and tweenManager.CancelCurrent then
					tweenManager.CancelCurrent()
				end

				if getgenv().TweenBoat then
					pcall(function()
						getgenv().TweenBoat:Cancel()
					end)

					getgenv().TweenBoat = nil
				end

				if getgenv().TweenBoatToFrozen then
					pcall(function()
						getgenv().TweenBoatToFrozen:Cancel()
					end)

					getgenv().TweenBoatToFrozen = nil
				end

				if getgenv().TweenBoatBack then
					pcall(function()
						getgenv().TweenBoatBack:Cancel()
					end)

					getgenv().TweenBoatBack = nil
				end

				if type(CancelTweenBoat) == "function" then
					pcall(CancelTweenBoat)
				end
			end
		end
	end
end

if getgenv().Config then
	Settings = getgenv().Config
	SaveSettings()
end

ReadSetting = function()
	local ok, result = pcall(function()
		if not isfolder(FolderName) then
			makefolder(FolderName)
		end

		return HttpService:JSONDecode(readfile(FolderName .. "/" .. SaveFileName))
	end)

	if ok then
		return result
	end
	SaveSettings()
	return ReadSetting()
end

Settings = ReadSetting()
local v_ = Settings
getgenv().Settings = v_

PrepareMultiSelectList = function(arg, arg2, arg3)
	local tbl = {}

	for k in pairs(arg) do
		local v_2 = arg2 and arg2[k]

		if v_2 == nil then
			tbl[k] = arg3 and true or false
		else
			tbl[k] = v_2
		end
	end

	return tbl
end

EnsureAllTrueDefaults = function(arg, arg2)
	if type(Settings[arg]) ~= "table" then
		Settings[arg] = {}
	end

	local flag = false

	for _, v_2 in ipairs(arg2) do
		if Settings[arg][v_2] == nil then
			Settings[arg][v_2] = true
			flag = true
		end
	end

	if flag then
		for k, v_2 in pairs(Settings[arg]) do
			SaveSettings(arg, k, v_2)
		end
	end
end

repeat
	wait()
until game:FindFirstChild("CoreGui")

repeat
	wait()
until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen")

while true do
	wait()
	if not (game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")) then
		continue
	end
	break
end

FireButton = function(selectedObject)
	selectedObject.Selectable = true
	game:GetService("GuiService").SelectedObject = selectedObject
	game:GetService("VirtualInputManager"):SendKeyEvent(true, "Return", false, selectedObject)
	game:GetService("VirtualInputManager"):SendKeyEvent(false, "Return", false, selectedObject)

	selectedObject.Activated:Connect(function()
		game:GetService("GuiService").SelectedObject = nil
	end)
end

while true do
	wait()
	if not (game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main")) then
		continue
	end
	break
end

local mainMinimal = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main")

repeat
	wait()
until mainMinimal:FindFirstChild("ChooseTeam")

while true do
	task.wait()

	pcall(function()
		if Settings["Select Team"] == "Pirate" then
			FireButton(game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam.Container.Pirates.Frame.TextButton)
			wait(1)
		else
			FireButton(game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"].ChooseTeam.Container.Marines.Frame.TextButton)
			wait(1)
		end
	end)

	if not (game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") and game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"]:FindFirstChild("ChooseTeam") and not game:GetService("Players").LocalPlayer.PlayerGui["Main (minimal)"]:WaitForChild("ChooseTeam").Visible or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main") and game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam") and not game:GetService("Players").LocalPlayer.PlayerGui.Main:WaitForChild("ChooseTeam").Visible) then
		continue
	end
	break
end

game:GetService("GuiService").SelectedObject = nil

while true do
	wait()
	if not (game:IsLoaded() and game.Players.LocalPlayer) then
		continue
	end
	break
end

while true do
	wait()
	if not (game:FindFirstChild("CoreGui") or game:GetService("Players").LocalPlayer) then
		continue
	end
	break
end

if not getgenv().getnilinstances then
	getgenv().getnilinstances = function()
		return {}
	end
end

if not getgenv().firetouchinterest then
	getgenv().firetouchinterest = function(arg, arg2, arg3)
		if arg and arg2 and arg3 == 0 then
			pcall(function()
				arg.CFrame = arg2.CFrame
			end)
		end
	end
end

if not getgenv().fireclickdetector then
	getgenv().fireclickdetector = function(arg)
		if arg and arg:IsA("ClickDetector") then
			pcall(function()
				arg.MaxActivationDistance = math.huge
			end)
		end
	end
end

if not getgenv().getconnections then
	getgenv().getconnections = function()
		return {}
	end
end

if not getgenv().fireproximityprompt then
	getgenv().fireproximityprompt = function(arg)
		if arg and arg:IsA("ProximityPrompt") then
			pcall(function()
				arg.HoldDuration = 0
				arg:InputHoldBegin()
				task.wait(0.05)
				arg:InputHoldEnd()
			end)
		end
	end
end

if not getgenv().setclipboard then
	getgenv().setclipboard = function(arg)
		pcall(function()
			toclipboard(arg)
		end)
	end
end

if not getgenv().sethiddenproperty then
	getgenv().sethiddenproperty = function(arg, arg2, arg3)
		pcall(function()
			arg[arg2] = arg3
		end)
	end
end

if not getgenv().getupvalues then
	getgenv().getupvalues = debug and debug.getupvalues or function()
		return {}
	end
end

if not getgenv().getupvalue then
	getgenv().getupvalue = debug and debug.getupvalue or function()
		return nil
	end
end

local v_2

do
	local v_3 = require
	local require_ = type(getrenv) == "function" and getrenv().require or nil
	local v_4 = setthreadidentity or setidentity or set_thread_identity or set_thread_context
	local v_5 = getthreadidentity or getidentity or get_thread_identity or get_thread_context
	local obj = nil

	obj = setmetatable({}, {
		__index = function()
			return obj
		end,
		__call = function()
			return nil
		end,
		__tostring = function()
			return ""
		end,
	})

	local function require_2(arg)
		if not arg then
			return obj
		end

		if require_ and require_ ~= v_3 then
			local ok, result = pcall(require_, arg)
			if ok and result ~= nil then
				return result
			end
		end

		if v_4 and v_5 then
			local v_6 = nil

			pcall(function()
				v_6 = v_5()
			end)

			pcall(function()
				v_4(2)
			end)

			local ok, result = pcall(v_3, arg)

			if not ok and require_ then
				ok, result = pcall(require_, arg)
			end

			if v_6 then
				pcall(function()
					v_4(v_6)
				end)
			end

			if ok and result ~= nil then
				return result
			end
		end

		local ok, result = pcall(v_3, arg)
		if ok and result ~= nil then
			return result
		end
		return obj
	end

	v_2 = require_2

	pcall(function()
		getgenv().require = require_2
	end)
end

local request_ = syn and syn.request or type(request) == "function" and request or type(http_request) == "function" and http_request or http and type(http.request) == "function" and http.request or fluxus and type(fluxus.request) == "function" and fluxus.request or type(requests) == "function" and requests
getgenv().ExploitReq = request_

if getgenv().LoadScript then
	return print("Double UI")
end

getgenv().CheckPlaceId = game.PlaceId == 100117331123089 and 100117331123089 or 7449423635
getgenv().CheckPlaceId2 = game.PlaceId == 4442272183 and 4442272183 or 79091703265657
getgenv().CheckPlaceId3 = game.PlaceId == 2753915549 and 2753915549 or 85211729168715
getgenv().LoadScript = true
local localPlayer
localPlayer = game.Players.LocalPlayer
local getupvalue = debug.getupvalue
getgenv().getupvalue = getupvalue
local getupvalues_ = debug.getupvalues
getgenv().getupvalues = getupvalues_
wOrigin = game.workspace._WorldOrigin

do
	local commF = nil

	local function fn()
		if commF and commF.Parent then
			return commF
		end

		pcall(function()
			local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
			commF = remotes and remotes:FindFirstChild("CommF_")
		end)

		return commF
	end

	CommF = setmetatable({}, { __index = function(arg, arg2)
		local v_3 = fn()

		if v_3 then
			local v_4 = v_3[arg2]
			if type(v_4) == "function" then
				return function(...)
					return v_4(v_3, select(2, ...))
				end
			end
			return v_4
		end

		return function()
		end
	end })
end

vu = game:GetService("VirtualUser")

game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local lib
lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/zzz"))()
Main = lib.CreateMain({ Title = "Blox Fruit", Desc = " - Blox Fruit" })
PageShop = Main.CreatePage({ Page_Name = "Shop", Page_Title = "Shop" })
local options = lib.Options
getgenv().Options = options
SectionShopMisc = PageShop.CreateSection("Misc Shop")

Remote = function(arg, arg2, arg3)
	if not arg and arg3 then
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer(arg2, true)
	else
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer(arg, arg2, arg3)
	end
end

getgenv().tablefruitausea3 = {}
whitelistedfruit = {}
TableDevilFruit = {}
local tbl
tbl = next
local tbl2
tbl2 = {}
local humanoidRootPart
humanoidRootPart = nil

pcall(function()
	local v_3 = next
	local response, v_4 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", false)
	tbl = v_3
	tbl2 = response
	humanoidRootPart = v_4
end)

if type(tbl2) ~= "table" then
	tbl2 = {}
end

for _, v_3 in tbl, tbl2, humanoidRootPart do
	if v_3.Price >= 1000000 then
		table.insert(whitelistedfruit, string.split(v_3.Name, "-")[1] .. " Fruit")
		local name = v_3.Name
		local price = v_3.Price
		getgenv().tablefruitausea3[name] = price
	end

	TableDevilFruit[v_3.Name] = false
end

getgenv().tablefruitausea3["Dragon (East)-Dragon (East)"] = 15000000
getgenv().tablefruitausea3["Dragon (West)-Dragon (West)"] = 15000000

pcall(function()
	ItemId = v_2(game.ReplicatedStorage.Economy.ItemId)
end)

CheckFruitReal = function(arg)
	local v_3 = next
	local response, v_4 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", false)

	for _, v_5 in v_3, response, v_4 do
		if v_5.Name == arg then
			return v_5
		end
	end
end

SkinFruit = {}

NameWorldMaterials = {
	Ectoplasm = { [getgenv().CheckPlaceId2] = "TravelDressrosa" },
	["Magma Ore"] = { [getgenv().CheckPlaceId2] = "TravelDressrosa" },
	Leather = { [getgenv().CheckPlaceId] = "TravelZou" },
	["Scrap Metal"] = { [getgenv().CheckPlaceId] = "TravelZou" },
	["Angel Wings"] = { [getgenv().CheckPlaceId3] = "TravelMain" },
	["Fish Tail"] = { [getgenv().CheckPlaceId] = "TravelZou" },
	["Radioactive Material"] = { [getgenv().CheckPlaceId2] = "TravelDressrosa" },
	["Vampire Fang"] = { [getgenv().CheckPlaceId2] = "TravelDressrosa" },
	["Mystic Droplet"] = { [getgenv().CheckPlaceId2] = "TravelDressrosa" },
	["Mini Tusk"] = { [getgenv().CheckPlaceId] = "TravelZou" },
	Gunpowder = { [getgenv().CheckPlaceId] = "TravelZou" },
	["Demonic Wisp"] = { [getgenv().CheckPlaceId] = "TravelZou" },
	["Dragon Scale"] = { [getgenv().CheckPlaceId] = "TravelZou" },
	["Conjured Cocoa"] = { [getgenv().CheckPlaceId] = "TravelZou" },
	Bones = { [getgenv().CheckPlaceId] = "TravelZou" },
}

NameMaterials = {
	Ectoplasm = { "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer", "Cursed Captain" },
	["Magma Ore"] = { "Lava Pirate", "Magma Ninja" },
	Leather = { "Jungle Pirate", "Musketeer Pirate" },
	["Scrap Metal"] = { "Jungle Pirate" },
	["Angel Wings"] = { "God's Guard", "Shanda", "Royal Squad", "Royal Soldier" },
	["Fish Tail"] = { "Fishman Raider", "Fishman Captain" },
	["Radioactive Material"] = { "Factory Staff" },
	["Vampire Fang"] = { "Vampire" },
	["Mystic Droplet"] = { "Sea Soldier", "Water Fighter" },
	["Mini Tusk"] = { "Mythological Pirate" },
	Gunpowder = { "Pistol Billionaire" },
	["Demonic Wisp"] = { "Demonic Soul" },
	["Dragon Scale"] = { "Dragon Crew Archer", "Dragon Crew Warrior" },
	["Conjured Cocoa"] = { "Cocoa Warrior", "Chocolate Bar Battler" },
	Bones = { "Reborn Skeleton", "Demonic Soul", "Living Zombie", "Posessed Mummy" },
}

TableMaterials = {}

for k in next, NameMaterials, nil do
	table.insert(TableMaterials, k)
end

REDEEM_CODES = {
	"EASTEREXP",
	"BANEXPLOIT",
	"NOMOREHACKS",
	"WildDares",
	"BossBuild",
	"GetPranked",
	"EARN_FRUITS",
	"Sub2UncleKizaru",
	"FIGHT4FRUIT",
	"kittgaming",
	"TRIPLEABUSE",
	"Sub2CaptainMaui",
	"Sub2Fer999",
	"Enyu_is_Pro",
	"Magicbus",
	"JCWK",
	"Starcodeheo",
	"Bluxxy",
	"SUB2GAMERROBOT_EXP1",
	"Sub2NoobMaster123",
	"Sub2Daigrock",
	"Axiore",
	"TantaiGaming",
	"StrawHatMaine",
	"Sub2OfficialNoobie",
	"TheGreatAce",
	"SEATROLLIN",
	"24NOADMIN",
	"ADMIN_TROLL",
	"NEWTROLL",
	"SECRET_ADMIN",
	"staffbattle",
	"NOEXPLOIT",
	"NOOB2ADMIN",
	"CODESLIDE",
	"fruitconcepts",
}

SectionShopMisc.CreateButton({ Title = "Redeem Code" }, function()
	for _, v_3 in REDEEM_CODES, nil, nil do
		game.ReplicatedStorage.Remotes.Redeem:InvokeServer(v_3)
	end
end)

SectionShopMisc.CreateButton({ Title = "Teleport Old World" }, function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "TravelMain" }))
end)

SectionShopMisc.CreateButton({ Title = "Teleport New World" }, function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "TravelDressrosa" }))
end)

SectionShopMisc.CreateButton({ Title = "Teleport Thid Sea" }, function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "TravelZou" }))
end)

SectionShopMisc.CreateButton({ Title = "Buy Dual Flintlock" }, function()
	game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
end)

SectionShopMisc.CreateButton({ Title = "Reroll Race" }, function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
end)

SectionShopMisc.CreateButton({ Title = "Reset Stats" }, function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
end)

SectionShopMisc.CreateButton({ Title = "Buy Race Cyborg" }, function()
	game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
end)

SectionShopMisc.CreateButton({ Title = "Buy Race Ghoul" }, function()
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "BuyCheck", 4)
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "Change", 4)
end)

SectionShopFighting = PageShop.CreateSection("Fighting Shop")
local chunk, v_3, v_4, n, n2, imageLabel, Players, ReplicatedStorage, RunService, tbl3

do
	local notsave = {}
	getgenv().notsave = notsave

	local tbl4 = {
		BuyBlackLeg = "Dark Step Teacher",
		BuySuperhuman = "Martial Arts Master",
		BuySharkmanKarate = "Sharkman Teacher",
		DragonClaw = "Sabi",
		BuyDragonTalon = "Uzoth",
		BuyElectro = "Mad Scientist",
		BuyFishmanKarate = "Water Kung-fu Teacher",
		BuyDeathStep = "Phoeyu, the Reformed",
		BuyGodhuman = "Ancient Monk",
		BuyElectricClaw = "Previous Hero",
		BuySanguineArt = "Shafi",
	}

	NPCManager = nil

	pcall(function()
		NPCManager = v_2(game:GetService("ReplicatedStorage").NPCManager)
	end)

	DetectNpc = function(arg)
		local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end
		local v_5 = next
		local tbl5 = {}
		local npCs = workspace:FindFirstChild("NPCs")
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local findFirstChild = ReplicatedStorage2.FindFirstChild
		tbl5[1] = npCs

		do
			local values = table.pack(findFirstChild(ReplicatedStorage2, "NPCs"))
			table.move(values, 1, values.n, 2, tbl5)
		end

		local huge = math.huge
		local v_6 = nil

		for _, v_7 in v_5, tbl5, nil do
			if v_7 then
				local v_8 = next
				local children, v_9 = v_7:GetChildren()

				for _, v_10 in v_8, children, v_9 do
					if v_10:GetAttribute("NPCLoaded") and v_10:GetAttribute("NPCReady") and v_10.Name == arg and v_10:FindFirstChild("HumanoidRootPart") then
						local magnitude = (humanoidRootPart2.Position - v_10.HumanoidRootPart.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v_6 = v_10
						end
					end
				end
			end
		end

		if not v_6 and NPCManager and NPCManager.getNPCsByName then
			local ok, result = pcall(function()
				local v_7 = NPCManager.getNPCsByName(arg)
				v_7 = v_7 and v_7[1]
				if v_7 and v_7._modelState then
					return v_7._modelState._instance
				end
			end)

			if ok then
				v_6 = result
			end
		end

		return v_6, huge
	end

	SectionShopFighting.CreateToggle({ Title = "Black Leg", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Black Leg"] and task.wait() do
					local ok, result = pcall(function()
						local v_5 = DetectNpc(tbl4.BuyBlackLeg)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBlackLeg")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		notsave["Black Leg"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Fishman Karate", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Fishman Karate"] and task.wait() do
					local ok, result = pcall(function()
						local v_5 = DetectNpc(tbl4.BuyFishmanKarate)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		notsave["Fishman Karate"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Electro", Desc = nil, Default = false }, function(electro)
		if electro then
			spawn(function()
				while notsave.Electro and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuyElectro)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectro")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave.Electro = electro

		if not electro then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Dragon Breath", Desc = nil, Default = false }, function(dragonClaw)
		if dragonClaw then
			spawn(function()
				while notsave.DragonClaw and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.DragonClaw)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave.DragonClaw = dragonClaw

		if not dragonClaw then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "SuperHuman", Desc = nil, Default = false }, function(superHuman)
		if superHuman then
			spawn(function()
				while notsave.SuperHuman and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuySuperhuman)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuySuperhuman")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave.SuperHuman = superHuman

		if not superHuman then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Death Step", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Death Step"] and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuyDeathStep)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuyDeathStep")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave["Death Step"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Sharkman Karate", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Sharkman Karate"] and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuySharkmanKarate)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuySharkmanKarate")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave["Sharkman Karate"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Electric Claw", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Electric Claw"] and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuyElectricClaw)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuyElectricClaw")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave["Electric Claw"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Dragon Talon", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Dragon Talon"] and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuyDragonTalon)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuyDragonTalon")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave["Dragon Talon"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "God Human", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["God Human"] and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuyGodhuman)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuyGodhuman")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave["God Human"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopFighting.CreateToggle({ Title = "Sanguine Art", Desc = nil, Default = false }, function(arg)
		if arg then
			spawn(function()
				while notsave["Sanguine Art"] and task.wait() do
					pcall(function()
						local v_5 = DetectNpc(tbl4.BuySanguineArt)
						if not v_5 or not v_5:FindFirstChild("HumanoidRootPart") then
							return
						end

						if localPlayer:DistanceFromCharacter(v_5.HumanoidRootPart.Position) < 8 then
							Remote("BuySanguineArt")
						end

						local cFrame = v_5.HumanoidRootPart.CFrame
						getgenv().BackupTween(cFrame * CFrame.new(0, 4, 4))
					end)
				end
			end)
		end

		notsave["Sanguine Art"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionShopAbilities = PageShop.CreateSection("Abilities Shop")

	SectionShopAbilities.CreateButton({ Title = "Skyjump [ $10,000 Beli ]" }, function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
	end)

	SectionShopAbilities.CreateButton({ Title = "Buso Haki [ $25,000 Beli ]" }, function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
	end)

	SectionShopAbilities.CreateButton({ Title = "Observation haki [ $750,000 Beli ]" }, function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Buy")
	end)

	SectionShopAbilities.CreateButton({ Title = "Soru [ $100,000 Beli ]" }, function()
		game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
	end)

	PageStatusAndServer = Main.CreatePage({ Page_Name = "Status And Server", Page_Title = "Status And Server" })
	SectionStatus = PageStatusAndServer.CreateSection("Status")
	TimerLabel = SectionStatus.CreateLabel({ Title = "Timer" })
	TimerServerLabel = SectionStatus.CreateLabel({ Title = "Timer Server" })
	NextTimerServerLabel = SectionStatus.CreateLabel({ Title = "Next Time Spawn Fist of Darkness or God's Chalice" })
	StatusEliteHunter = SectionStatus.CreateLabel({ Title = "Elite" })
	StatusTyrant = SectionStatus.CreateLabel({ Title = "Eyes Summon Tyrant" })
	StatusKatakuri = SectionStatus.CreateLabel({ Title = "Summon Katakuri" })
	Statusspy = SectionStatus.CreateLabel({ Title = "Status SPY" })
	StatusMirage = SectionStatus.CreateLabel({ Title = "Mirage" })
	StatusPrehistoricIsland = SectionStatus.CreateLabel({ Title = "Prehistoric Island" })
	StatusFrozenDimension = SectionStatus.CreateLabel({ Title = "Frozen Dimension" })
	StatusMoon = SectionStatus.CreateLabel({ Title = "Moon" })
	StatusGear = SectionStatus.CreateLabel({ Title = "Acient One Status" })
	SectionServer = PageStatusAndServer.CreateSection("Server")

	SectionServer.CreateButton({ Title = "Open Gui Server Browser (Low Player and Ping)" }, function()
		local HttpService_ = game:GetService("HttpService")
		game:GetService("TeleportService")
		local Players2 = game:GetService("Players")
		local TweenService = game:GetService("TweenService")
		local placeId = game.PlaceId
		local request_2 = syn and syn.request or http_request or request
		if not request_2 then
			warn("[ServerBrowser] Executor does not support http_request")
			return
		end

		if game.CoreGui:FindFirstChild("SB_UI") then
			game.CoreGui.SB_UI:Destroy()
		end

		local tbl5 = { servers = {}, cursor = nil, finished = false, lastUpdate = 0, pages = 0 }

		local tbl6 = {
			CACHE_TIME = 60,
			MAX_SHOW = 50,
			PAGE_DELAY = 5,
			RETRY_MAX = 4,
			RETRY_BASE = 2,
			RETRY_JITTER = 5,
			RATE_COOLDOWN = 30,
		}

		local tbl7 = {
			BG = Color3.fromRGB(10, 11, 16),
			SURFACE = Color3.fromRGB(13, 14, 20),
			ROW = Color3.fromRGB(16, 17, 26),
			ROW_HOVER = Color3.fromRGB(20, 22, 35),
			ROW_TOP = Color3.fromRGB(10, 22, 34),
			BORDER = Color3.fromRGB(28, 31, 48),
			BORDER_HOV = Color3.fromRGB(0, 80, 120),
			CYAN = Color3.fromRGB(0, 212, 255),
			CYAN_DIM = Color3.fromRGB(0, 80, 120),
			GREEN = Color3.fromRGB(0, 204, 102),
			GREEN_GLOW = Color3.fromRGB(0, 255, 136),
			AMBER = Color3.fromRGB(255, 170, 0),
			RED = Color3.fromRGB(255, 68, 85),
			TEXT_PRI = Color3.fromRGB(232, 234, 240),
			TEXT_SEC = Color3.fromRGB(80, 90, 120),
			TEXT_DIM = Color3.fromRGB(45, 52, 82),
		}

		local function fn(arg, arg2, parent)
			local instance = Instance.new(arg)
			local v_5 = pairs
			local tbl8 = arg2 or {}

			for k, v_6 in v_5(tbl8) do
				instance[k] = v_6
			end

			if parent then
				instance.Parent = parent
			end

			return instance
		end

		local function fn2(arg, arg2)
			return fn("UICorner", { CornerRadius = UDim.new(0, arg) }, arg2)
		end

		local function fn3(arg, arg2, arg3, arg4)
			return fn("UIStroke", { Thickness = arg, Color = arg2, Transparency = arg3 or 0 }, arg4)
		end

		local function fn4(arg, arg2, arg3, arg4, arg5)
			TweenService:Create(arg, TweenInfo.new(arg3 or 0.15, arg4 or Enum.EasingStyle.Quad, arg5 or Enum.EasingDirection.Out), arg2):Play()
		end

		local function fn5(arg, arg2, arg3)
			arg.MouseEnter:Connect(function()
				fn4(arg, { BackgroundColor3 = arg3 })
			end)

			arg.MouseLeave:Connect(function()
				fn4(arg, { BackgroundColor3 = arg2 })
			end)
		end

		local function fn6()
			local retryJitter = tbl6.RETRY_JITTER
			return math.random() * retryJitter
		end

		local ScreenGui = fn("ScreenGui", {
			Name = "SB_UI",
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true,
		}, game.CoreGui)

		local Frame = fn("Frame", {
			Name = "Window",
			Size = UDim2.new(0, 580, 0, 500),
			Position = UDim2.new(0.5, -290, 0.5, -250),
			BackgroundColor3 = tbl7.SURFACE,
			BorderSizePixel = 0,
			ClipsDescendants = true,
		}, ScreenGui)

		fn2(4, Frame)
		fn3(1, tbl7.BORDER, 0, Frame)
		local flag = nil
		local position = nil
		local position2 = nil

		Frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				flag = true
				position = input.Position
				position2 = Frame.Position
			end
		end)

		Frame.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				flag = false
			end
		end)

		game:GetService("UserInputService").InputChanged:Connect(function(input)
			if flag and input.UserInputType == Enum.UserInputType.MouseMovement then
				local n3 = input.Position - position
				Frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n3.X, position2.Y.Scale, position2.Y.Offset + n3.Y)
			end
		end)

		local Frame2 = fn("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = tbl7.BG, BorderSizePixel = 0 }, Frame)

		fn("TextLabel", {
			Size = UDim2.new(0, 300, 0, 18),
			Position = UDim2.new(0, 18, 0, 9),
			BackgroundTransparency = 1,
			Text = "SERVER BROWSER",
			TextColor3 = tbl7.TEXT_PRI,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, Frame2)

		fn("TextLabel", {
			Size = UDim2.new(0, 360, 0, 14),
			Position = UDim2.new(0, 18, 0, 30),
			BackgroundTransparency = 1,
			Text = "CACHE PAGE · LOAD MORE · LOWEST PLAYER / PING",
			TextColor3 = tbl7.TEXT_DIM,
			Font = Enum.Font.Gotham,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, Frame2)

		local TextButton = fn("TextButton", {
			Size = UDim2.new(0, 28, 0, 28),
			Position = UDim2.new(1, -42, 0, 12),
			BackgroundColor3 = Color3.fromRGB(26, 13, 13),
			BorderSizePixel = 0,
			Text = "X",
			TextColor3 = tbl7.RED,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
		}, Frame2)

		fn2(3, TextButton)
		local color = Color3.fromRGB
		fn5(TextButton, Color3.fromRGB(26, 13, 13), color(60, 20, 20))

		TextButton.MouseButton1Click:Connect(function()
			ScreenGui:Destroy()
		end)

		local Frame3 = fn("Frame", {
			Size = UDim2.new(1, 0, 0, 42),
			Position = UDim2.new(0, 0, 0, 52),
			BackgroundColor3 = Color3.fromRGB(11, 12, 17),
			BorderSizePixel = 0,
		}, Frame)

		local Frame4 = fn("Frame", {
			Size = UDim2.new(0, 6, 0, 6),
			Position = UDim2.new(0, 14, 0.5, -3),
			BackgroundColor3 = tbl7.TEXT_DIM,
			BorderSizePixel = 0,
		}, Frame3)

		fn2(99, Frame4)

		local TextLabel = fn("TextLabel", {
			Size = UDim2.new(1, -300, 1, 0),
			Position = UDim2.new(0, 26, 0, 0),
			BackgroundTransparency = 1,
			Text = "READY",
			TextColor3 = tbl7.TEXT_SEC,
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, Frame3)

		local TextButton2 = fn("TextButton", {
			Size = UDim2.new(0, 82, 0, 26),
			Position = UDim2.new(1, -270, 0.5, -13),
			BackgroundColor3 = Color3.fromRGB(14, 22, 40),
			BorderSizePixel = 0,
			Text = "REFRESH",
			TextColor3 = Color3.fromRGB(100, 140, 200),
			Font = Enum.Font.GothamBold,
			TextSize = 10,
		}, Frame3)

		fn2(3, TextButton2)
		local color2 = Color3.fromRGB
		fn5(TextButton2, Color3.fromRGB(14, 22, 40), color2(10, 30, 55))

		local TextButton3 = fn("TextButton", {
			Size = UDim2.new(0, 82, 0, 26),
			Position = UDim2.new(1, -182, 0.5, -13),
			BackgroundColor3 = Color3.fromRGB(16, 32, 24),
			BorderSizePixel = 0,
			Text = "LOAD MORE",
			TextColor3 = tbl7.GREEN,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
		}, Frame3)

		fn2(3, TextButton3)
		local color3 = Color3.fromRGB
		fn5(TextButton3, Color3.fromRGB(16, 32, 24), color3(10, 48, 28))

		local TextButton4 = fn("TextButton", {
			Size = UDim2.new(0, 82, 0, 26),
			Position = UDim2.new(1, -94, 0.5, -13),
			BackgroundColor3 = Color3.fromRGB(38, 18, 18),
			BorderSizePixel = 0,
			Text = "RESET",
			TextColor3 = tbl7.RED,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
		}, Frame3)

		fn2(3, TextButton4)
		local color4 = Color3.fromRGB
		fn5(TextButton4, Color3.fromRGB(38, 18, 18), color4(60, 20, 20))

		local Frame5 = fn("Frame", {
			Size = UDim2.new(1, 0, 0, 24),
			Position = UDim2.new(0, 0, 0, 94),
			BackgroundColor3 = Color3.fromRGB(11, 12, 17),
			BorderSizePixel = 0,
		}, Frame)

		local function fn7(arg, arg2, arg3)
			fn("TextLabel", {
				Size = UDim2.new(0, arg3, 1, 0),
				Position = UDim2.new(0, arg2, 0, 0),
				BackgroundTransparency = 1,
				Text = arg,
				TextColor3 = tbl7.TEXT_DIM,
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, Frame5)
		end

		fn7("#", 14, 28)
		fn7("JOB ID", 42, 170)
		fn7("PLAYERS", 220, 80)
		fn7("PING", 310, 60)

		local ScrollingFrame = fn("ScrollingFrame", {
			Size = UDim2.new(1, -8, 1, -172),
			Position = UDim2.new(0, 4, 0, 118),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = tbl7.CYAN_DIM,
			CanvasSize = UDim2.new(0, 0, 0, 0),
		}, Frame)

		local UIListLayout = fn("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, ScrollingFrame)

		fn("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 4),
			PaddingRight = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 6),
		}, ScrollingFrame)

		local Frame6 = fn("Frame", {
			Size = UDim2.new(1, 0, 0, 30),
			Position = UDim2.new(0, 0, 1, -30),
			BackgroundColor3 = Color3.fromRGB(10, 11, 15),
			BorderSizePixel = 0,
		}, Frame)

		local TextLabel2 = fn("TextLabel", {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 14, 0, 0),
			BackgroundTransparency = 1,
			Text = "PLACE · " .. tostring(placeId),
			TextColor3 = tbl7.TEXT_DIM,
			Font = Enum.Font.Gotham,
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, Frame6)

		local TextLabel3 = fn("TextLabel", {
			Size = UDim2.new(0.5, -14, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = 1,
			Text = "SHOWING 0 / 0",
			TextColor3 = tbl7.TEXT_DIM,
			Font = Enum.Font.Gotham,
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Right,
		}, Frame6)

		local Frame7 = fn("Frame", {
			Size = UDim2.new(1, 0, 1, -52),
			Position = UDim2.new(0, 0, 0, 52),
			BackgroundColor3 = tbl7.SURFACE,
			BackgroundTransparency = 0.05,
			ZIndex = 20,
			Visible = false,
		}, Frame)

		local TextLabel4 = fn("TextLabel", {
			Size = UDim2.new(1, -20, 0, 36),
			Position = UDim2.new(0, 10, 0.5, 10),
			BackgroundTransparency = 1,
			Text = "SCANNING SERVERS...",
			TextColor3 = tbl7.CYAN,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextWrapped = true,
			ZIndex = 21,
		}, Frame7)

		local Frame8 = fn("Frame", {
			Size = UDim2.new(1, -8, 0, 28),
			Position = UDim2.new(0, 4, 0, 118),
			BackgroundColor3 = Color3.fromRGB(38, 24, 6),
			BorderSizePixel = 0,
			ZIndex = 15,
			Visible = false,
		}, Frame)

		fn2(3, Frame8)
		fn3(1, tbl7.AMBER, 0.4, Frame8)

		local TextLabel5 = fn("TextLabel", {
			Size = UDim2.new(1, -12, 1, 0),
			Position = UDim2.new(0, 6, 0, 0),
			BackgroundTransparency = 1,
			Text = "⏳ 429 RATE LIMITED — WAITING...",
			TextColor3 = tbl7.AMBER,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Center,
			ZIndex = 16,
		}, Frame8)

		local function fn8(text)
			TextLabel5.Text = text
			Frame8.Visible = true
			ScrollingFrame.Position = UDim2.new(0, 4, 0, 150)
			ScrollingFrame.Size = UDim2.new(1, -8, 1, -204)
		end

		local function fn9()
			Frame8.Visible = false
			ScrollingFrame.Position = UDim2.new(0, 4, 0, 118)
			ScrollingFrame.Size = UDim2.new(1, -8, 1, -172)
		end

		local Frame9 = fn("Frame", {
			Size = UDim2.new(0, 360, 0, 36),
			Position = UDim2.new(0.5, -180, 1, -50),
			BackgroundColor3 = Color3.fromRGB(10, 26, 40),
			BorderSizePixel = 0,
			ZIndex = 30,
			Visible = false,
		}, Frame)

		fn2(3, Frame9)

		local TextLabel6 = fn("TextLabel", {
			Size = UDim2.new(1, -12, 1, 0),
			Position = UDim2.new(0, 6, 0, 0),
			BackgroundTransparency = 1,
			Text = "READY",
			TextColor3 = tbl7.CYAN,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextWrapped = true,
			ZIndex = 31,
		}, Frame9)

		local thread = nil

		local function fn10(text, textColor3)
			if thread then
				task.cancel(thread)
			end

			TextLabel6.Text = text
			TextLabel6.TextColor3 = textColor3 or tbl7.CYAN
			Frame9.Visible = true

			thread = task.delay(3.5, function()
				Frame9.Visible = false
			end)
		end

		local function fn11(text, backgroundColor3)
			TextLabel.Text = text
			Frame4.BackgroundColor3 = backgroundColor3 or tbl7.TEXT_DIM
		end

		local function fn12(arg)
			return ({
				RATE_LIMIT = "429 RATE LIMITED — TOO MANY REQUESTS",
				FORBIDDEN = "403 FORBIDDEN — ACCESS BLOCKED",
				UNAUTHORIZED = "401 UNAUTHORIZED",
				SERVER_ERROR = "5xx ROBLOX SERVER ERROR",
				NETWORK_ERROR = "NETWORK / EXECUTOR ERROR",
				INVALID_JSON = "INVALID JSON RESPONSE",
				EMPTY_BODY = "EMPTY RESPONSE BODY",
			})[arg] or "REQUEST FAILED: " .. tostring(arg)
		end

		local function fn13(arg, arg2)
			local n3 = 0

			for i = 0, tbl6.RETRY_MAX do
				local ok, result = pcall(function()
					return request_2({
						Url = arg,
						Method = "GET",
						Headers = { ["User-Agent"] = "Mozilla/5.0", Accept = "application/json" },
					})
				end)

				if not ok or not result then
					return nil, "NETWORK_ERROR"
				end
				local statusCode = result.StatusCode or result.Status or 0

				if statusCode == 429 then
					n3 += 1
					if i >= tbl6.RETRY_MAX then
						return nil, "RATE_LIMIT"
					end
					local n4

					if n3 >= 2 then
						n4 = tbl6.RATE_COOLDOWN + fn6()
					else
						n4 = math.pow(tbl6.RETRY_BASE, i + 1) + fn6()
					end

					local text = string.format("⏳ 429 RATE LIMITED — WAITING %.0fs THEN RETRYING (%d/%d)", n4, i + 1, tbl6.RETRY_MAX)

					if arg2 then
						fn8(text)
						Frame7.Visible = false
					else
						Frame7.Visible = true
						TextLabel4.Text = text
					end

					local amber = tbl7.AMBER
					fn11("RATE LIMITED — WAITING " .. math.floor(n4) .. "s", amber)
					local amber2 = tbl7.AMBER
					fn10(string.format("⏳ 429 — RETRYING IN %.0fs", n4), amber2)
					warn(string.format("[ServerBrowser] 429 — waiting %.1fs (attempt %d/%d)", n4, i + 1, tbl6.RETRY_MAX))
					local n5 = math.floor(n4)

					task.spawn(function()
						while n5 > 0 do
							task.wait(1)
							n5 -= 1
							local text2 = string.format("⏳ 429 RATE LIMITED — %.0fs REMAINING (%d/%d)", n5, i + 1, tbl6.RETRY_MAX)

							if arg2 then
								if Frame8.Visible then
									TextLabel5.Text = text2
								end
							elseif Frame7.Visible then
								TextLabel4.Text = text2
							end
						end
					end)

					task.wait(n4)

					if arg2 then
						fn9()
					end

					continue
				end

				if statusCode == 403 then
					return nil, "FORBIDDEN"
				end

				if statusCode == 401 then
					return nil, "UNAUTHORIZED"
				end

				if statusCode >= 500 then
					return nil, "SERVER_ERROR"
				end

				if statusCode ~= 200 and statusCode ~= 0 then
					return nil, "HTTP_" .. tostring(statusCode)
				end

				if not result.Body or result.Body == "" then
					return nil, "EMPTY_BODY"
				end
				local ok2, result2 = pcall(HttpService_.JSONDecode, HttpService_, result.Body)
				if not ok2 or not result2 then
					return nil, "INVALID_JSON"
				end
				return result2, nil
			end

			return nil, "RATE_LIMIT"
		end

		local function fn14()
			for _, child in ipairs(ScrollingFrame:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end
		end

		local function fn15()
			table.sort(tbl5.servers, function(arg, arg2)
				local playing = arg.playing or 999
				local playing2 = arg2.playing or 999
				if playing ~= playing2 then
					return playing < playing2
				end
				return (arg.ping or 999) < (arg2.ping or 999)
			end)
		end

		local function fn16(arg)
			if arg < 100 then
				return tbl7.GREEN_GLOW
			end

			if arg < 200 then
				return tbl7.AMBER
			end
			return tbl7.RED
		end

		local function fn17(arg)
			if arg > 0.8 then
				return tbl7.RED
			end

			if arg > 0.5 then
				return tbl7.AMBER
			end
			return tbl7.CYAN
		end

		local function fn18(arg, arg2)
			local flag2 = arg2 == 1
			local rowTop = flag2 and tbl7.ROW_TOP or tbl7.ROW
			local Frame10 = fn("Frame", { Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = rowTop, BorderSizePixel = 0, LayoutOrder = arg2 }, ScrollingFrame)
			fn2(3, Frame10)
			local v_5 = fn3(1, flag2 and tbl7.CYAN_DIM or tbl7.BORDER, 0, Frame10)

			Frame10.MouseEnter:Connect(function()
				fn4(Frame10, { BackgroundColor3 = tbl7.ROW_HOVER })
				fn4(v_5, { Color = tbl7.BORDER_HOV })
			end)

			Frame10.MouseLeave:Connect(function()
				fn4(Frame10, { BackgroundColor3 = rowTop })
				fn4(v_5, { Color = flag2 and tbl7.CYAN_DIM or tbl7.BORDER })
			end)

			fn("TextLabel", {
				Size = UDim2.new(0, 28, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				Text = string.format("%02d", arg2),
				TextColor3 = flag2 and tbl7.CYAN or tbl7.TEXT_DIM,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, Frame10)

			fn("TextLabel", {
				Size = UDim2.new(0, 160, 0, 14),
				Position = UDim2.new(0, 44, 0, 8),
				BackgroundTransparency = 1,
				Text = tostring(arg.id):sub(1, 18) .. "...",
				TextColor3 = Color3.fromRGB(60, 75, 110),
				Font = Enum.Font.Code,
				TextSize = 10,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, Frame10)

			local playing = arg.playing or 0
			local maxPlayers = arg.maxPlayers or 20
			local n3 = playing / math.max(maxPlayers, 1)

			fn("TextLabel", {
				Size = UDim2.new(0, 80, 0, 14),
				Position = UDim2.new(0, 44, 0, 26),
				BackgroundTransparency = 1,
				Text = playing .. "/" .. maxPlayers .. " players",
				TextColor3 = tbl7.TEXT_DIM,
				Font = Enum.Font.Gotham,
				TextSize = 9,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, Frame10)

			fn("TextLabel", {
				Size = UDim2.new(0, 50, 0, 20),
				Position = UDim2.new(0, 210, 0, 4),
				BackgroundTransparency = 1,
				Text = tostring(playing),
				TextColor3 = tbl7.TEXT_PRI,
				Font = Enum.Font.GothamBold,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, Frame10)

			local Frame11 = fn("Frame", {
				Size = UDim2.new(0, 50, 0, 2),
				Position = UDim2.new(0, 210, 0, 28),
				BackgroundColor3 = Color3.fromRGB(22, 24, 36),
				BorderSizePixel = 0,
			}, Frame10)

			fn2(1, Frame11)

			fn2(1, fn("Frame", {
				Size = UDim2.new(math.clamp(n3, 0, 1), 0, 1, 0),
				BackgroundColor3 = fn17(n3),
				BorderSizePixel = 0,
			}, Frame11))

			local ping = arg.ping or 999

			fn("TextLabel", {
				Size = UDim2.new(0, 55, 1, 0),
				Position = UDim2.new(0, 278, 0, 0),
				BackgroundTransparency = 1,
				Text = ping .. "ms",
				TextColor3 = fn16(ping),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
			}, Frame10)

			local TextButton5 = fn("TextButton", {
				Size = UDim2.new(0, 72, 0, 28),
				Position = UDim2.new(1, -82, 0.5, -14),
				BackgroundColor3 = Color3.fromRGB(10, 30, 18),
				BorderSizePixel = 0,
				Text = "JOIN",
				TextColor3 = tbl7.GREEN,
				Font = Enum.Font.GothamBold,
				TextSize = 10,
			}, Frame10)

			fn2(3, TextButton5)
			local color5 = Color3.fromRGB
			fn5(TextButton5, Color3.fromRGB(10, 30, 18), color5(8, 44, 24))

			TextButton5.MouseButton1Click:Connect(function()
				fn10("TELEPORTING TO " .. tostring(arg.id):sub(1, 16) .. "...", tbl7.CYAN)

				local ok, result = pcall(function()
					game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", arg.id)
				end)

				if not ok then
					fn10("TELEPORT FAILED: " .. tostring(result), tbl7.RED)
					fn11("TELEPORT FAILED", tbl7.RED)
				end
			end)
		end

		local function fn19()
			fn14()
			fn15()
			local n3 = #tbl5.servers
			local n4 = math.min(n3, tbl6.MAX_SHOW)

			for i = 1, n4 do
				fn18(tbl5.servers[i], i)
			end

			ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 16)
			TextLabel3.Text = "SHOWING " .. n4 .. " / " .. n3
			TextLabel2.Text = "PLACE · " .. tostring(placeId) .. " · PAGE " .. tostring(tbl5.pages)

			if tbl5.finished then
				fn11("CACHE DONE — " .. n3 .. " SERVERS", tbl7.GREEN_GLOW)
			else
				fn11("CACHE SAVED — " .. n3 .. " SERVERS — PAGE " .. tbl5.pages, tbl7.CYAN)
			end
		end

		local function fn20()
			tbl5.servers = {}
			tbl5.cursor = nil
			tbl5.finished = false
			tbl5.lastUpdate = 0
			tbl5.pages = 0
			fn9()
			fn14()
			TextLabel3.Text = "SHOWING 0 / 0"
			TextLabel2.Text = "PLACE · " .. tostring(placeId)
			fn11("CACHE RESET", tbl7.RED)
			fn10("CACHE RESET", tbl7.RED)
		end

		local flag2 = false

		local function fn21(arg, arg2)
			if flag2 then
				return
			end
			flag2 = true

			if arg2 then
				fn20()
			end

			TextButton2.Active = false
			TextButton3.Active = false
			TextButton4.Active = false
			TextButton2.Text = "LOADING"
			TextButton3.Text = "WAIT"
			local n3 = 0
			local v_5

			while true do
				v_5 = nil

				if tbl5.finished then
					break
				else
					n3 += 1
					tbl5.pages = tbl5.pages + 1
					local flag3 = #tbl5.servers > 0

					if flag3 then
						Frame7.Visible = false
					else
						Frame7.Visible = true
						TextLabel4.Text = "SCANNING PAGE " .. tbl5.pages .. "…"
					end

					fn11("PAGE " .. tbl5.pages .. " — " .. #tbl5.servers .. " FOUND", tbl7.AMBER)
					local str = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
					local v_6 = fn13
					local str2

					if tbl5.cursor then
						str2 = str .. "&cursor=" .. HttpService_:UrlEncode(tbl5.cursor)
					else
						str2 = str
					end

					local v_7
					v_7, v_5 = v_6(str2, flag3)

					if not v_7 then
						local v_8 = fn12(v_5)

						if not flag3 then
							TextLabel4.Text = v_8
						end

						fn11(v_8, tbl7.RED)
						fn10(v_8, tbl7.RED)
						warn("[ServerBrowser] " .. v_8 .. " | Page: " .. tbl5.pages)
						break
					else
						local v_8 = ipairs
						local data = v_7.data or {}

						for _, v_9 in v_8(data) do
							if v_9.id and v_9.id ~= game.JobId then
								local playing = v_9.playing or 0
								local maxPlayers = v_9.maxPlayers or 0

								if maxPlayers == 0 or playing < maxPlayers then
									table.insert(tbl5.servers, v_9)
								end
							end
						end

						tbl5.cursor = v_7.nextPageCursor
						tbl5.lastUpdate = tick()

						if not tbl5.cursor or tbl5.cursor == "" then
							tbl5.finished = true
							tbl5.cursor = nil
						end

						if not tbl5.finished and n3 < arg then
							local text = string.format("PAGE %d DONE — WAITING %.1fs…", tbl5.pages, tbl6.PAGE_DELAY)

							if #tbl5.servers > 0 then
								fn19()
								fn8(text)
							else
								TextLabel4.Text = text
							end

							fn11(text, tbl7.CYAN)
							task.wait(tbl6.PAGE_DELAY)
							fn9()
						end

						v_5 = nil
						if not (arg <= n3) then
							continue
						end
					end

					break
				end
			end

			Frame7.Visible = false
			fn9()
			fn19()

			if v_5 then
				if #tbl5.servers > 0 then
					local str = " — SHOWING " .. #tbl5.servers .. " CACHED"
					fn10(fn12(v_5) .. str, tbl7.AMBER)
					local str2 = " | PARTIAL " .. #tbl5.servers
					fn11(fn12(v_5) .. str2, tbl7.AMBER)
				else
					local red = tbl7.RED
					fn11(fn12(v_5), red)
				end
			elseif tbl5.finished then
				fn11("FULL SCAN DONE — " .. #tbl5.servers .. " SERVERS", tbl7.GREEN_GLOW)
				fn10("SCAN COMPLETE — " .. #tbl5.servers .. " SERVERS", tbl7.GREEN_GLOW)
			else
				fn11("PAGE SAVED — CLICK LOAD MORE TO CONTINUE", tbl7.CYAN)
			end

			TextButton2.Active = true
			TextButton3.Active = true
			TextButton4.Active = true
			TextButton2.Text = "REFRESH"
			TextButton3.Text = "LOAD MORE"
			flag2 = false
		end

		TextButton2.MouseButton1Click:Connect(function()
			task.spawn(function()
				local lastUpdate = tbl5.lastUpdate
				local n3 = tick() - lastUpdate

				if #tbl5.servers > 0 and n3 <= tbl6.CACHE_TIME then
					fn19()
					local cyan = tbl7.CYAN
					fn10("CACHE STILL FRESH (" .. math.floor(tbl6.CACHE_TIME - n3) .. "s) — RESET TO RELOAD", cyan)
					return
				end

				fn21(2, true)
			end)
		end)

		TextButton3.MouseButton1Click:Connect(function()
			task.spawn(function()
				if tbl5.finished then
					fn10("ALL PAGES LOADED — NO MORE SERVERS", tbl7.AMBER)
					fn11("NO MORE PAGES", tbl7.AMBER)
					return
				end

				fn21(2, false)
			end)
		end)

		TextButton4.MouseButton1Click:Connect(function()
			if not flag2 then
				fn20()
			end
		end)

		task.spawn(function()
			fn21(2, true)
		end)
	end)

	StatusPlaceId = SectionServer.CreateLabel({ Title = "PlaceId: " .. game.PlaceId })
	local str = ""

	SectionServer.CreateBox({
		Title = "Input JobId Normal And JobId BananaCat",
		Placeholder = "Type here",
		Number = false,
		Default = nil,
	}, function(arg)
		str = arg
	end)

	SectionServer.CreateToggle({ Title = "Spam Join", Desc = nil, Default = Settings["Spam Join"] or false }, function(arg)
		SaveSettings("Spam Join", arg)
	end)

	if not (bit32 or bit) then
		local tbl5 = { bxor = function(arg, arg2)
			local n3 = 0
			local n4 = 1

			while arg > 0 or arg2 > 0 do
				local n5 = arg % 2
				local n6 = arg2 % 2
				arg = (arg - n5) / 2
				arg2 = (arg2 - n6) / 2

				if n5 ~= n6 then
					n3 += n4
				end

				n4 *= 2
			end

			return n3
		end }
	end

	chunk = loadstring([[local function EQ(a, r)
 local b, c = nil, nil
 local success = pcall(function()
 b, c = a, r
 end)

 if not success or b == nil or c == nil then
 return false
 end

 if type(b) ~= type(c) then
 return false
 end

 local d = { c, b, c, b }
 if d[1] ~= d[1] then
 return false
 end
 if d[1] ~= d[2] then
 return false
 end
 if d[2] ~= d[1] then
 return false
 end

 local e, f, g = 1 and 2, 2 and nil, true == not not true

 if type(b) == "number" and type(c) == "number" then
 if e and g and not f then
 return b == c
 end
 elseif type(b) == "string" and type(c) == "string" then
 if e and g then
 return b == c
 end
 else
 return b == c
 end

 return false
end

local function _vrf()
 local x = os.time and os.time() or 12345
 if tostring(print):find("function") == nil then
 while true do
 end
 end
 if tostring(type):find("function") == nil then
 while true do
 end
 end
 if (x * x + x) % 2 ~= 0 then
 while true do
 end
 end
 if not EQ(x, x) then
 while true do
 end
 end
end

local function _gct()
 _vrf()
 local s, p1, p2, p3 = 17, {}, {}, {}
 local _m = { [17] = 23, [23] = 41, [41] = 999 }

 while true do
 if s == 17 then
 for i = 0, 255 do
 local c = ("%c"):format(i)
 p1[i] = c
 p2[c] = i
 end
 s = _m[17]
 elseif s == 23 then
 for i = 0, 255 do
 p3[i] = p1[i]
 end
 s = _m[23]
 elseif s == 41 then
 if EQ(s, 41) then
 return p3, p2
 else
 while true do
 end
 end
 else
 while true do
 end
 end
 end
end

local _CT, _BT = _gct()

local _sp = (function()
 local _xk = { 0x61, 0x9A, 0x43, 0xF1, 0x27, 0xBC, 0x58, 0x0D, 0xE7, 0x33 }

 local _enc = {
 { 0x9A, 0x71, 0x24, 0xEF, 0x38, 0x4C },
 { 0x7D, 0xA1, 0x55, 0x92, 0xB7, 0x44, 0x18 },
 { 0x2F, 0xC3, 0x89, 0x11, 0xD4, 0x67 },
 { 0xA8, 0x3E, 0xD1, 0x5B },
 { 0x44, 0xE2, 0x71, 0x9C, 0x0A, 0xD8, 0x61, 0xF4 },
 { 0x1E, 0x7B, 0xC0, 0x35, 0x92, 0xAF, 0x4D, 0x28 },
 { 0xF3, 0x60, 0x1A, 0x87, 0xCE, 0x39, 0x54 },
 { 0x88, 0x2D, 0xB6, 0x41, 0xFA, 0x73, 0x19, 0xCC, 0x05 },
 }

 local function _dec(data, seed)
 local result = ""
 local state = seed or 0x53

 for i = 1, #data do
 local byte = data[i]
 local keyIdx = ((i - 1) % #_xk) + 1
 local key = _xk[keyIdx]

 byte = bit32.bxor(byte, key)
 byte = (byte - state + 256) % 256
 byte = bit32.bxor(byte, (i * 23) % 256)
 state = (state + i + key + 17) % 256

 result = result .. _CT[byte]
 end

 return result
 end

 local _d = {}
 for i = 1, #_enc do
 _d[i] = _dec(_enc[i], (i * 0x29) % 256)
 end

 return _d
end)()

local function _gb(str, pos)
 _vrf()
 local c, s = 0, 5
 local _states = { [5] = 7, [7] = 11, [11] = 999 }

 while true do
 if s == 5 then
 for ch in str:gmatch(".") do
 c = c + 1
 if c == pos then
 s = _states[5]
 break
 end
 end
 if s ~= 7 then
 s = _states[11]
 end
 elseif s == 7 then
 local ch = ""
 local cnt = 0
 for c2 in str:gmatch(".") do
 cnt = cnt + 1
 if cnt == pos then
 ch = c2
 break
 end
 end
 if EQ(_BT[ch] or 0, _BT[ch] or 0) then
 return _BT[ch] or 0
 end
 elseif s == 11 then
 return 0
 end
 end
end

local function _tc(num)
 if EQ(num, num) then
 return _CT[num % 256]
 end
 while true do
 end
end

local function _js(tbl)
 local r, s = "", 3
 local _sm = { [3] = 8, [8] = 999 }

 while true do
 if s == 3 then
 for i = 1, #tbl do
 r = r .. tbl[i]
 end
 s = _sm[3]
 elseif s == 8 then
 if EQ(r, r) then
 return r
 end
 end
 end
end

local function _gl(str)
 _vrf()
 local c = 0
 for _ in str:gmatch(".") do
 c = c + 1
 end
 if EQ(c, c) then
 return c
 end
 return 0
end

local function _rp(str, pat, rep)
 _vrf()
 local r, pl, m = "", _gl(pat), true

 for i = 1, pl do
 if _gb(str, i) ~= _gb(pat, i) then
 m = false
 break
 end
 end

 if m and EQ(m, true) then
 r = rep
 for i = pl + 1, _gl(str) do
 local ch = ""
 local cnt = 0
 for c in str:gmatch(".") do
 cnt = cnt + 1
 if cnt == i then
 ch = c
 break
 end
 end
 r = r .. ch
 end
 return r
 end

 return str
end

local function _cs(...)
 local args, r = { ... }, ""
 for i = 1, #args do
 r = r .. args[i]
 end
 if EQ(r, r) then
 return r
 end
 return ""
end

local function _gks(key, len)
 _vrf()
 local ks, kl, st = {}, _gl(key), 0

 for i = 1, len do
 local kp = ((i - 1) % kl) + 1
 local kb = _gb(key, kp)
 st = (st + kb + i + ((i * 11) % 256)) % 256
 ks[i] = (kb + st + (i * 17) + ((kb * 3) % 256)) % 256
 end

 if EQ(#ks, len) then
 return ks
 end
 return {}
end

local function _mix_key_material(key, salt)
 _vrf()
 local rev = key:reverse()
 local out = {}
 local src = _cs(key, salt, rev, _tc(_gl(key) % 256), _tc(_gl(salt) % 256))

 for i = 1, _gl(src) do
 local b = _gb(src, i)
 b = bit32.bxor(b, (i * 29) % 256)
 b = (b + ((i * 7) % 256)) % 256
 out[i] = _tc(b)
 end

 return _js(out)
end

local function _derive_stream(key, salt, len)
 _vrf()
 local km = _mix_key_material(key, salt)
 return _gks(km, len)
end

local function _randb()
 return math.random(0, 255)
end

local function _gensalt128()
 _vrf()
 local t = {}
 for i = 1, 16 do
 t[i] = _tc(_randb())
 end
 return _js(t)
end

local function _secure_round_enc(key, data, salt, round_idx)
 _vrf()
 local dl = _gl(data)
 local ks = _derive_stream(_cs(key, _tc(48 + round_idx)), salt, dl)
 local r = {}
 local st = (_gl(key) + _gl(salt) + round_idx * 37 + 91) % 256

 for i = 1, dl do
 local db = _gb(data, i)
 local sb = _gb(salt, ((i + round_idx - 2) % 16) + 1)
 local kk = ks[i]

 st = (st + kk + sb + i + round_idx) % 256

 local enc = db
 enc = bit32.bxor(enc, kk)
 enc = (enc + st + sb) % 256
 enc = bit32.bxor(enc, ((i * 31) + sb + round_idx * 9) % 256)
 enc = (enc + ((kk * 5) % 256)) % 256

 r[i] = _tc(enc)
 end

 return _js(r)
end

local function _secure_round_dec(key, data, salt, round_idx)
 _vrf()
 local dl = _gl(data)
 local ks = _derive_stream(_cs(key, _tc(48 + round_idx)), salt, dl)
 local r = {}
 local st = (_gl(key) + _gl(salt) + round_idx * 37 + 91) % 256

 for i = 1, dl do
 local sb = _gb(salt, ((i + round_idx - 2) % 16) + 1)
 local kk = ks[i]

 st = (st + kk + sb + i + round_idx) % 256

 local eb = _gb(data, i)

 local db = eb
 db = (db - ((kk * 5) % 256) + 256) % 256
 db = bit32.bxor(db, ((i * 31) + sb + round_idx * 9) % 256)
 db = (db - st - sb + 512) % 256
 db = bit32.bxor(db, kk)

 r[i] = _tc(db)
 end

 return _js(r)
end

local function _ae(key, data, salt, rnd)
 _vrf()
 rnd = rnd or 3
 local r = data

 for rd = 1, rnd do
 r = _secure_round_enc(key, r, salt, rd)
 if not EQ(r, r) then
 while true do
 end
 end
 end

 return r
end

local function _ad(key, data, salt, rnd)
 _vrf()
 rnd = rnd or 3
 local r = data

 for rd = rnd, 1, -1 do
 r = _secure_round_dec(key, r, salt, rd)
 if not EQ(r, r) then
 while true do
 end
 end
 end

 return r
end

local _b64 = (function()
 local chs = string.char(
 65,
 66,
 67,
 68,
 69,
 70,
 71,
 72,
 73,
 74,
 75,
 76,
 77,
 78,
 79,
 80,
 81,
 82,
 83,
 84,
 85,
 86,
 87,
 88,
 89,
 90,
 97,
 98,
 99,
 100,
 101,
 102,
 103,
 104,
 105,
 106,
 107,
 108,
 109,
 110,
 111,
 112,
 113,
 114,
 115,
 116,
 117,
 118,
 119,
 120,
 121,
 122,
 48,
 49,
 50,
 51,
 52,
 53,
 54,
 55,
 56,
 57,
 43,
 47
 )

 local function enc(data)
 _vrf()
 local r, dl = {}, _gl(data)
 local i = 1

 while i <= dl do
 local b1 = _gb(data, i)
 local b2 = i + 1 <= dl and _gb(data, i + 1) or 0
 local b3 = i + 2 <= dl and _gb(data, i + 2) or 0

 local n = b1 * 65536 + b2 * 256 + b3

 local c1 = (n // 262144) % 64 + 1
 local c2 = (n // 4096) % 64 + 1
 local c3 = (n // 64) % 64 + 1
 local c4 = n % 64 + 1

 r[#r + 1] = _gb(chs, c1)
 r[#r + 1] = _gb(chs, c2)
 r[#r + 1] = i + 1 <= dl and _gb(chs, c3) or 61
 r[#r + 1] = i + 2 <= dl and _gb(chs, c4) or 61

 i = i + 3
 end

 local out = {}
 for idx = 1, #r do
 out[idx] = _tc(r[idx])
 end

 if EQ(_js(out), _js(out)) then
 return _js(out)
 end
 return ""
 end

 local function dec(data)
 _vrf()
 local r, dl = {}, _gl(data)
 local i = 1

 while i <= dl do
 local c1 = _gb(data, i)
 local c2 = _gb(data, i + 1)
 local c3 = _gb(data, i + 2)
 local c4 = _gb(data, i + 3)

 local function fp(byte)
 if byte == 61 then
 return 0
 end
 for p = 1, 64 do
 if _gb(chs, p) == byte then
 return p - 1
 end
 end
 return 0
 end

 local n1, n2, n3, n4 = fp(c1), fp(c2), fp(c3), fp(c4)
 local n = n1 * 262144 + n2 * 4096 + n3 * 64 + n4

 r[#r + 1] = _tc((n // 65536) % 256)
 if c3 ~= 61 then
 r[#r + 1] = _tc((n // 256) % 256)
 end
 if c4 ~= 61 then
 r[#r + 1] = _tc(n % 256)
 end

 i = i + 4
 end

 if EQ(_js(r), _js(r)) then
 return _js(r)
 end
 return ""
 end

 return { encode = enc, decode = dec }
end)()

local function _seed_rng()
 local seed = (os.time and os.time() or 12345)
 + math.floor((os.clock and os.clock() or 0) * 100000)
 + math.random(1, 999999)

 math.randomseed(seed)
 math.random()
 math.random()
 math.random()
end

_seed_rng()

local function ebgzqifrwa(plaintext)
 _vrf()
 local k = _cs(_sp[5], _sp[6], _sp[7], _sp[8])
 if not EQ(k, k) then
 while true do
 end
 end

 local salt = _gensalt128()
 local enc = _ae(k, plaintext, salt, 3)
 local payload = _cs(salt, enc)
 local b64 = _b64.encode(payload)

 if EQ(b64, b64) then
 return _cs("BananaCat-", b64)
 end
 return ""
end

local function lebidlyjyf(encrypted)
 _vrf()
 local k = _cs(_sp[5], _sp[6], _sp[7], _sp[8])
 if not EQ(k, k) then
 while true do
 end
 end

 local ed = _rp(encrypted, "BananaCat-", "")
 local dc = _b64.decode(ed)

 if _gl(dc) < 16 then
 return ""
 end

 local salt_tbl = {}
 local data_tbl = {}

 for i = 1, 16 do
 salt_tbl[#salt_tbl + 1] = _tc(_gb(dc, i))
 end

 for i = 17, _gl(dc) do
 data_tbl[#data_tbl + 1] = _tc(_gb(dc, i))
 end

 local salt = _js(salt_tbl)
 local data = _js(data_tbl)

 if EQ(data, data) then
 return _ad(k, data, salt, 3)
 end
 return ""
end
return ebgzqifrwa, lebidlyjyf
]])

	Realm = nil

	pcall(function()
		Realm = v_2(game:GetService("ReplicatedStorage").Util.Realm)
	end)

	tryTeleport = function(arg, arg2, arg3)
		local ok, result = pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(arg, arg2, localPlayer)
		end)

		if ok then
			arg3.done = true
		else
			warn("Teleport thất bại:", arg, result)
		end
	end

	teleportSmart = function(arg)
		local v_5 = Realm.safeGetCurrentSeaAsync()
		local tbl5 = {}
		local tbl6 = { done = false }
		local v_6 = ipairs

		if v_5 == "Sea1" then
			tbl5 = { 2753915549, 85211729168715 }
		elseif v_5 == "Sea2" then
			tbl5 = { 4442272183, 79091703265657 }
		elseif v_5 == "Sea3" then
			tbl5 = { 7449423635, 100117331123089 }
		end

		for _, v_7 in v_6(tbl5) do
			task.spawn(function()
				if not tbl6.done then
					tryTeleport(v_7, arg, tbl6)
				end
			end)
		end
	end

	SectionServer.CreateButton({ Title = "Join JobId" }, function()
		if Settings["Spam Join"] then
			while task.wait() do
				local v_5 = str
				local v_6, v_7 = chunk()
				local find = string.find
				local serverBrowser = game:GetService("ReplicatedStorage").__ServerBrowser
				local invokeServer = serverBrowser.InvokeServer

				if find(str, "BananaCat-") then
					v_5 = v_7(str)
				end

				invokeServer(serverBrowser, "teleport", v_5)
			end
		else
			local v_5 = str
			local v_6, v_7 = chunk()
			local find = string.find
			local serverBrowser = game:GetService("ReplicatedStorage").__ServerBrowser
			local invokeServer = serverBrowser.InvokeServer

			if find(str, "BananaCat-") then
				v_5 = v_7(str)
			end

			invokeServer(serverBrowser, "teleport", v_5)
		end
	end)

	SectionServer.CreateButton({ Title = "Copy JobId" }, function()
		setclipboard(tostring(game.JobId))
	end)

	local tbl5 = {}

	if not pcall(function()
		readfile("Banana Cat Hub/Jobid.json")
	end) then
		writefile("Banana Cat Hub/Jobid.json", game:GetService("HttpService"):JSONEncode(tbl5))
	end

	if not pcall(function()
		readfile("Banana Cat Hub/NotSameServers.json")
	end) then
		writefile("Banana Cat Hub/NotSameServers.json", game:GetService("HttpService"):JSONEncode(tbl5))
	end

	CheckJobIdServer = function()
		local tbl6 = {}

		pcall(function()
			if not isfolder("Banana Cat Hub") then
				makefolder("Banana Cat Hub")
			end

			if isfile("Banana Cat Hub/Jobid.json") then
				local json = readfile("Banana Cat Hub/Jobid.json")
				local data = game:GetService("HttpService"):JSONDecode(json)

				if data and type(data) == "table" then
					for k in pairs(data) do
						table.insert(tbl6, k)
					end
				end
			end
		end)

		return tbl6
	end

	HopServer = function(arg)
		local timeHopServer = arg or Settings["Time Hop Server"] or 5

		pcall(function()
			v_2(game:GetService("ReplicatedStorage").Notification).new("<Color=Red>Banana Cat Hub : Wait " .. timeHopServer .. "s [Hop Server]<Color=/>"):Display()
		end)

		local function fn()
			local flag = false

			pcall(function()
				local v_5 = CheckJobIdServer()

				for i = 1, 100 do
					local response = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)

					if response and type(response) == "table" then
						for k in pairs(response) do
							if k ~= game.JobId and not table.find(v_5, k) then
								game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", k)

								pcall(function()
									local tbl6 = {}

									for _, v_6 in ipairs(v_5) do
										tbl6[v_6] = true
									end

									tbl6[k] = true
									writefile("Banana Cat Hub/Jobid.json", game:GetService("HttpService"):JSONEncode(tbl6))
								end)

								if getgenv().limit_type then
									getgenv().limit_type("clearAll")
								end

								flag = true
								return
							end
						end
					end
				end
			end)

			if not flag then
				pcall(function()
					local HttpService_ = game:GetService("HttpService")
					local TeleportService = game:GetService("TeleportService")
					local placeId = game.PlaceId
					local response = game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100")

					if response then
						local data = HttpService_:JSONDecode(response)

						if data and data.data then
							for _, v_5 in pairs(data.data) do
								if v_5.playing and v_5.maxPlayers and v_5.playing < v_5.maxPlayers and v_5.id ~= game.JobId then
									TeleportService:TeleportToPlaceInstance(placeId, v_5.id, game.Players.LocalPlayer)
									return
								end
							end
						end
					end
				end)
			end
		end

		while wait(timeHopServer) do
			pcall(function()
				v_2(game:GetService("ReplicatedStorage").Notification).new("<Color=Red>Banana Cat Hub : Hop Server<Color=/>"):Display()
			end)

			fn()
		end
	end

	SectionServer.CreateButton({ Title = "Hop Server" }, function()
		HopServer()
	end)

	HopLessAll = function()
		v_2(game:GetService("ReplicatedStorage").Notification).new("<Color=Red>Banana Hub : Hop Server<Color=/>"):Display()
		local placeId = game.PlaceId
		local tbl6 = {}
		local str2 = ""
		local hour = os.date("!*t").hour

		if not pcall(function()
			tbl6 = game:GetService("HttpService"):JSONDecode(readfile("Banana Cat Hub/NotSameServers.json"))
		end) then
			table.insert(tbl6, hour)
			writefile("Banana Cat Hub/NotSameServers.json", game:GetService("HttpService"):JSONEncode(tbl6))
		end

		HopServerLess = function()
			local data

			if str2 == "" then
				data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
			else
				data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. str2))
			end

			if data.nextPageCursor and data.nextPageCursor ~= "null" and data.nextPageCursor ~= nil then
				str2 = data.nextPageCursor
			end

			local n3 = 0

			for _, v_5 in pairs(data.data) do
				local str3 = tostring(v_5.id)

				if tonumber(v_5.maxPlayers) > tonumber(v_5.playing) and tonumber(v_5.playing) <= 3 then
					local flag = true

					for _, v_6 in pairs(tbl6) do
						if n3 ~= 0 then
							if str3 == tostring(v_6) then
								flag = false
							end
						elseif tonumber(hour) ~= tonumber(v_6) then
							pcall(function()
								delfile("Banana Cat Hub/NotSameServers.json")
								tbl6 = {}
								table.insert(tbl6, hour)
							end)
						end

						n3 += 1
					end

					if flag == true then
						table.insert(tbl6, str3)
						wait()

						pcall(function()
							writefile("Banana Cat Hub/NotSameServers.json", game:GetService("HttpService"):JSONEncode(tbl6))
							wait()
							game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", str3)

							if getgenv().limit_type then
								getgenv().limit_type("clearAll")
							end
						end)

						wait(4)
					end
				end
			end
		end

		while wait() do
			HopServerLess()
		end
	end

	SectionServer.CreateButton({ Title = "Hop Server Less People" }, function()
		HopLessAll()
	end)

	MoonTextureId = function()
		local Lighting = game:GetService("Lighting")
		local fantasySky

		if game.PlaceId == getgenv().CheckPlaceId2 then
			fantasySky = Lighting:FindFirstChild("FantasySky")
		else
			fantasySky = Lighting:FindFirstChild("Sky")
		end

		if fantasySky and fantasySky:IsA("Sky") then
			return fantasySky.MoonTextureId
		end

		for _, child in ipairs(Lighting:GetChildren()) do
			if child:IsA("Sky") then
				return child.MoonTextureId
			end
		end

		return nil
	end

	CheckMoon = function()
		local v_5 = MoonTextureId()
		local flag = v_5 == "http://www.roblox.com/asset/?id=9709149431" or v_5 == "http://www.roblox.com/asset/?id=9709149052"
		local str2 = "Bad Moon"

		if flag then
			if v_5 == "http://www.roblox.com/asset/?id=9709149431" then
				str2 = "Full Moon"
			elseif v_5 == "http://www.roblox.com/asset/?id=9709149052" then
				str2 = "Next Night"
			end
		end

		return str2
	end

	function6 = function()
		return math.floor(game.Lighting.ClockTime)
	end

	getServerTime = function()
		RealTime = tostring(math.floor(game.Lighting.ClockTime * 100) / 100)
		RealTime = tostring(game.Lighting.ClockTime)
		RealTimeTable = RealTime:split(".")
		local v_5 = RealTimeTable[1]
		local n3 = tonumber(0 + tonumber(RealTimeTable[2] / 100)) * 60
		Minute = v_5
		Second = n3
		return Minute, Second
	end

	function8 = function()
		local clockTime = game.Lighting.ClockTime
		if CheckMoon() == "Full Moon" and clockTime <= 5 then
			return tostring(function6()) .. " ( Will End Moon In " .. math.floor(5 - clockTime) .. " Minutes )"
		end
		local flag = CheckMoon() == "Full Moon"
		local flag2

		if flag then
			flag2 = clockTime > 5 and clockTime < 12
		else
			flag2 = flag
		end

		if flag2 then
			return tostring(function6()) .. " ( Fake Moon )"
		end

		if CheckMoon() == "Full Moon" and clockTime > 12 and clockTime < 18 then
			return tostring(function6()) .. " ( Will Full Moon In " .. math.floor(18 - clockTime) .. " Minutes )"
		end

		if CheckMoon() == "Full Moon" and clockTime > 18 and clockTime <= 24 then
			return tostring(function6()) .. " ( Will End Moon In " .. math.floor(30 - clockTime) .. " Minutes )"
		end

		if CheckMoon() == "Next Night" and clockTime < 12 then
			return tostring(function6()) .. " ( Will Full Moon In " .. math.floor(18 - clockTime) .. " Minutes )"
		end

		if CheckMoon() == "Next Night" and clockTime > 12 then
			return tostring(function6()) .. " ( Will Full Moon In " .. math.floor(30 - clockTime) .. " Minutes )"
		end
		return tostring(function6())
	end

	CheckAcientOneDracoStatus = function()
		local localPlayer2 = game.Players.LocalPlayer
		localPlayer2 = localPlayer2 and localPlayer2.Character

		if not localPlayer2 or not localPlayer2:FindFirstChild("RaceTransformed") then
			if game.PlaceId == getgenv().CheckPlaceId then
				local response = nil

				pcall(function()
					local hydraIslandClient = game.workspace:FindFirstChild("HydraIslandClient")
					hydraIslandClient = hydraIslandClient and hydraIslandClient:FindFirstChild("RemoteFunction")

					if hydraIslandClient then
						response = hydraIslandClient:InvokeServer("Interacted")
					end
				end)

				if response == 1 or response == 2 or response == 3 or response == 4 then
					return "Ready For Trial"
				end
			end

			return "You have yet to achieve greatness"
		end

		local v_5 = nil
		local v_6 = nil
		local v_7 = nil

		pcall(function()
			local response, v_8, v_9 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("UpgradeRace", "Check", 2)
			v_5 = response
			v_6 = v_8
			v_7 = v_9
		end)

		if v_5 == 1 then
			return "Required Train More"
		end

		if v_5 == 2 or v_5 == 4 or v_5 == 7 then
			return "Can Buy Gear With " .. tostring(v_7 or 0) .. " Fragments"
		end

		if v_5 == 3 then
			return "Required Train More"
		end

		if v_5 == 5 then
			return "You Are Done Your Race."
		end

		if v_5 == 6 then
			return "Upgrades completed: " .. tostring((v_6 or 2) - 2) .. "/3, Need Trains More"
		end

		if v_5 ~= 8 then
			if v_5 == 0 then
				return "Ready For Trial"
			end
			return "You have yet to achieve greatness"
		end

		return "Remaining " .. tostring(10 - (v_6 or 0)) .. " training sessions."
	end

	local function fn()
		local localPlayer2 = game.Players.LocalPlayer
		localPlayer2 = localPlayer2 and localPlayer2.Character
		if not localPlayer2 or not localPlayer2:FindFirstChild("RaceTransformed") then
			return "You have yet to achieve greatness"
		end
		local v_5 = nil
		local v_6 = nil
		local v_7 = nil

		pcall(function()
			local response, v_8, v_9 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("UpgradeRace", "Check")
			v_5 = response
			v_6 = v_8
			v_7 = v_9
		end)

		if v_5 == 1 then
			return "Required Train More"
		end

		if v_5 == 2 or v_5 == 4 or v_5 == 7 then
			return "Can Buy Gear With " .. tostring(v_7 or 0) .. " Fragments"
		end

		if v_5 == 3 then
			return "Required Train More"
		end

		if v_5 == 5 then
			return "You Are Done Your Race."
		end

		if v_5 == 6 then
			return "Upgrades completed: " .. tostring((v_6 or 2) - 2) .. "/3, Need Trains More"
		end

		if v_5 ~= 8 then
			if v_5 == 0 then
				return "Ready For Trial"
			end
			return "You have yet to achieve greatness"
		end

		return "Remaining " .. tostring(10 - (v_6 or 0)) .. " training sessions."
	end

	local v_5 = nil
	local n3 = 0

	CheckAcientOneStatus = function()
		if v_5 and tick() - n3 < 1 then
			return v_5
		end
		v_5 = fn()
		n3 = tick()
		return v_5
	end

	ResetRaceStatus = function()
		v_5 = nil
	end

	CheckGoTrain = function()
		local v_6 = CheckAcientOneStatus()
		if string.find(v_6, "Upgrades completed") or v_6 == "Required Train More" or string.find(v_6, "training sessions.") or string.find(v_6, "Can Buy Gear") then
			return true
		end
	end

	CheckClockTime = function()
		local clockTime = game.Lighting.ClockTime
		local str2

		if clockTime >= 18 or clockTime < 5 then
			str2 = "Night"
		else
			str2 = "Day"
		end

		return str2
	end

	StatusCheckLeviathan = function()
		if game.PlaceId == getgenv().CheckPlaceId then
			if game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("InfoLeviathan", "1") ~= -1 then
				if game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("InfoLeviathan", "1") == 5 then
					return "You can find leviathan now"
				end
				return "Buy Find leviathan"
			end

			return "I DONT KNOW"
		end

		return "..."
	end

	IsMobAlive = function(arg)
		if not (arg and arg.Parent) then
			return false
		end
		local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart", true) or arg:IsA("Model") and arg.PrimaryPart
		local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildWhichIsA("Humanoid", true)
		if humanoidRootPart2 and humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
			return true
		end
		return false
	end

	local tbl6 = { "Deandre", "Urban", "Diablo" }
	CFrame.new(-5418.51904, 312.803192, -2828.00854)
	local tbl7 = {}
	local port = {}
	local cframe = CFrame.new(-447.467438, 6.72994, 5306.368652)
	local cframe2 = CFrame.new(-285.5, 44.2, 5556.1)
	local cframe3 = CFrame.new
	port[1] = cframe
	port[2] = cframe2

	do
		local values = table.pack(cframe3(-822.3, 65.8, 5972.5))
		table.move(values, 1, values.n, 3, port)
	end

	tbl7.port = port
	local hydra = {}
	local cframe4 = CFrame.new(5335.88623, 1004.77948, 241.501938)
	local cframe5 = CFrame.new(5750.2, 610.5, 240.1)
	local cframe6 = CFrame.new
	hydra[1] = cframe4
	hydra[2] = cframe5

	do
		local values = table.pack(cframe6(5228.4, 605.2, 1014.3))
		table.move(values, 1, values.n, 3, hydra)
	end

	tbl7.hydra = hydra
	local turtle = {}
	local cframe7 = CFrame.new(-12548, 337.2, -7481)
	local cframe8 = CFrame.new(-12001.6152, 1707.39319, -8789.03711)
	local cframe9 = CFrame.new(-13274.5, 396.1, -7814.2)
	local cframe10 = CFrame.new
	turtle[1] = cframe7
	turtle[2] = cframe8
	turtle[3] = cframe9

	do
		local values = table.pack(cframe10(-10526.3, 332, -8753.8))
		table.move(values, 1, values.n, 4, turtle)
	end

	tbl7.turtle = turtle
	local tree = {}
	local cframe11 = CFrame.new(2253.060059, 24.14422, -6405.669434)
	local cframe12 = CFrame.new(2847.2, 73.5, -7231)
	local cframe13 = CFrame.new
	tree[1] = cframe11
	tree[2] = cframe12

	do
		local values = table.pack(cframe13(2300, 450, -6800))
		table.move(values, 1, values.n, 3, tree)
	end

	tbl7.tree = tree

	local tbl8 = {
		port = tbl7.port[1],
		hydra = tbl7.hydra[1],
		hydar = tbl7.hydra[1],
		turtle = tbl7.turtle[1],
		mansion = tbl7.turtle[1],
		tree = tbl7.tree[1],
	}

	IsEliteName = function(arg)
		if type(arg) ~= "string" or arg == "" then
			return false
		end
		local v_6 = string.lower(arg)
		if string.find(v_6, "elite hunter", 1, true) or v_6 == "elite" then
			return false
		end

		for _, v_7 in ipairs(tbl6) do
			local v_8 = string.lower(v_7)
			if v_6 == v_8 or string.find(v_6, v_8, 1, true) then
				return true
			end
		end

		return false
	end

	ResolveIslandKeyFromText = function(arg)
		if type(arg) ~= "string" or arg == "" then
			return nil
		end
		local v_6 = string.lower(arg)
		if string.find(v_6, "port", 1, true) or string.find(v_6, "town", 1, true) then
			return "port"
		end

		if string.find(v_6, "hydra", 1, true) or string.find(v_6, "hydar", 1, true) then
			return "hydra"
		end

		if string.find(v_6, "turtle", 1, true) or string.find(v_6, "mansion", 1, true) or string.find(v_6, "floating", 1, true) then
			return "turtle"
		end

		if string.find(v_6, "tree", 1, true) or string.find(v_6, "great", 1, true) then
			return "tree"
		end
		return nil
	end

	ResolveIslandFromText = function(arg)
		local v_6 = ResolveIslandKeyFromText(arg)
		return v_6 and tbl8[v_6] or nil
	end

	GetEliteMob = function(arg)
		local function fn2(arg2)
			if not arg2 then
				return nil
			end

			for _, child in ipairs(arg2:GetChildren()) do
				if (child:IsA("Model") or child:FindFirstChild("HumanoidRootPart")) and IsEliteName(child.Name) then
					if not arg or string.find(string.lower(child.Name), string.lower(arg), 1, true) then
						local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart", true) or child.PrimaryPart
						local humanoid = child:FindFirstChildOfClass("Humanoid") or child:FindFirstChildWhichIsA("Humanoid", true)
						if humanoidRootPart2 and humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
							return child
						end
					end
				end
			end

			return nil
		end

		local v_6 = fn2(workspace:FindFirstChild("Enemies"))
		if v_6 then
			return v_6
		end
		local v_7 = fn2(workspace:FindFirstChild("Characters"))
		if v_7 then
			return v_7
		end
		local worldOrigin = workspace:FindFirstChild("_WorldOrigin")

		if worldOrigin then
			local v_8 = fn2(worldOrigin:FindFirstChild("Enemies"))
			if v_8 then
				return v_8
			end
		end

		for _, child in ipairs(workspace:GetChildren()) do
			if child:IsA("Model") and IsEliteName(child.Name) then
				if not arg or string.find(string.lower(child.Name), string.lower(arg), 1, true) then
					local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart", true) or child.PrimaryPart
					local humanoid = child:FindFirstChildOfClass("Humanoid") or child:FindFirstChildWhichIsA("Humanoid", true)
					if humanoidRootPart2 and humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
						return child
					end
				end
			end
		end

		return nil
	end

	GetEliteMobFromReplicated = function(arg)
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		if not ReplicatedStorage2 then
			return nil
		end

		for _, child in ipairs(ReplicatedStorage2:GetChildren()) do
			if child:IsA("Model") and IsEliteName(child.Name) then
				if not arg or string.find(string.lower(child.Name), string.lower(arg), 1, true) then
					local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart", true) or child.PrimaryPart
					if humanoidRootPart2 and humanoidRootPart2.Position.Magnitude > 100 then
						return child, humanoidRootPart2.CFrame
					end
				end
			end
		end

		return nil
	end

	local v_6 = nil

	local function fn2()
		if v_6 then
			return v_6
		end

		pcall(function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			ReplicatedStorage2 = ReplicatedStorage2 and ReplicatedStorage2:FindFirstChild("GuideModule")

			if ReplicatedStorage2 then
				v_6 = v_2(ReplicatedStorage2)
			end
		end)

		return v_6
	end

	HasEliteQuest = function(arg)
		local v_7 = fn2()

		if v_7 and v_7.Data and v_7.Data.QuestData then
			local questData = v_7.Data.QuestData
			local v_8 = string.lower(tostring(questData.QuestName or ""))
			local v_9 = string.lower(tostring(questData.Task or ""))
			local v_10 = string.lower(tostring(questData.Description or ""))
			if string.find(v_8, "elite", 1, true) or IsEliteName(v_8) or IsEliteName(v_9) or IsEliteName(v_10) or arg and (string.find(v_8, string.lower(arg), 1, true) or string.find(v_9, string.lower(arg), 1, true)) then
				return true
			end

			if type(questData.Task) == "table" then
				for k in pairs(questData.Task) do
					local v_11 = string.lower(tostring(k))
					if IsEliteName(v_11) or arg and string.find(v_11, string.lower(arg), 1, true) then
						return true
					end
				end
			end
		end

		if HasQuestUI and HasQuestUI() and GetNameDoubleQuest then
			local v_8 = GetNameDoubleQuest()

			if v_8 then
				v_8 = IsEliteName(v_8) or string.find(string.lower(tostring(v_8)), "elite", 1, true)
			end

			if v_8 then
				return true
			end
		end

		local playerGui = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local trackedQuestFrame = playerGui:FindFirstChild("TrackedQuestFrame")

			if trackedQuestFrame and trackedQuestFrame.Enabled and trackedQuestFrame:FindFirstChild("Frame") and trackedQuestFrame.Frame.Visible then
				local description = trackedQuestFrame.Frame:FindFirstChild("description", true)
				local v_8 = string.lower(description and description.Text or "")
				local title = trackedQuestFrame.Frame:FindFirstChild("title", true)
				local v_9 = string.lower(title and title.Text or "")
				if string.find(v_8, "elite", 1, true) or string.find(v_9, "elite", 1, true) or IsEliteName(v_8) or IsEliteName(v_9) or arg and (string.find(v_8, string.lower(arg), 1, true) or string.find(v_9, string.lower(arg), 1, true)) then
					return true
				end
			end

			local quest = playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest")

			if quest and quest.Visible then
				local title = quest:FindFirstChild("Container") and quest.Container:FindFirstChild("QuestTitle") and quest.Container.QuestTitle:FindFirstChild("Title")
				local v_8 = string.lower(title and title.Text or "")
				if string.find(v_8, "elite", 1, true) or IsEliteName(v_8) or arg and string.find(v_8, string.lower(arg), 1, true) then
					return true
				end

				for _, descendant in ipairs(quest:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Text ~= "" then
						local v_9 = string.lower(descendant.Text)
						if IsEliteName(v_9) or string.find(v_9, "elite", 1, true) then
							return true
						end
					end
				end
			end
		end

		return false
	end

	GetCurrentEliteMobName = function()
		local v_7 = GetEliteMob()

		if v_7 then
			for _, v_8 in ipairs(tbl6) do
				if string.find(string.lower(v_7.Name), string.lower(v_8), 1, true) then
					return v_8
				end
			end
		end

		local playerGui = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local quest = playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest")

			if quest and quest.Visible then
				for _, descendant in ipairs(quest:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Text ~= "" then
						for _, v_8 in ipairs(tbl6) do
							if string.find(string.lower(descendant.Text), string.lower(v_8), 1, true) then
								return v_8
							end
						end
					end
				end
			end

			local trackedQuestFrame = playerGui:FindFirstChild("TrackedQuestFrame")

			if trackedQuestFrame and trackedQuestFrame.Enabled and trackedQuestFrame:FindFirstChild("Frame") and trackedQuestFrame.Frame.Visible then
				for _, descendant in ipairs(trackedQuestFrame.Frame:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Text ~= "" then
						for _, v_8 in ipairs(tbl6) do
							if string.find(string.lower(descendant.Text), string.lower(v_8), 1, true) then
								return v_8
							end
						end
					end
				end
			end
		end

		local v_8 = fn2()

		if v_8 and v_8.Data and v_8.Data.QuestData then
			local questData = v_8.Data.QuestData
			local v_9 = string.lower(tostring(questData.QuestName or "") .. " " .. tostring(questData.Task or ""))

			for _, v_10 in ipairs(tbl6) do
				if string.find(v_9, string.lower(v_10), 1, true) then
					return v_10
				end
			end

			if type(questData.Task) == "table" then
				for k in pairs(questData.Task) do
					for _, v_10 in ipairs(tbl6) do
						if string.find(string.lower(tostring(k)), string.lower(v_10), 1, true) then
							return v_10
						end
					end
				end
			end
		end

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

		if ReplicatedStorage2 then
			for _, v_9 in ipairs(tbl6) do
				local v_10 = ReplicatedStorage2:FindFirstChild(v_9)

				if v_10 and v_10:IsA("Model") then
					local humanoidRootPart2 = v_10:FindFirstChild("HumanoidRootPart", true) or v_10.PrimaryPart
					if humanoidRootPart2 and humanoidRootPart2.Position.Magnitude > 100 then
						return v_9
					end
				end
			end
		end

		local enemies = workspace:FindFirstChild("Enemies")

		if enemies then
			for _, child in ipairs(enemies:GetChildren()) do
				if child:IsA("Model") and IsEliteName(child.Name) then
					for _, v_9 in ipairs(tbl6) do
						if string.find(string.lower(child.Name), string.lower(v_9), 1, true) then
							return v_9
						end
					end
				end
			end
		end

		return nil
	end

	GetEliteIslandKeyFromUI = function()
		local playerGui = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return nil
		end
		local main = playerGui:FindFirstChild("Main")
		local dialogue = main and main:FindFirstChild("Dialogue")

		if dialogue then
			for _, descendant in ipairs(dialogue:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Text ~= "" then
					local v_7 = ResolveIslandKeyFromText(descendant.Text)
					if v_7 then
						return v_7
					end
				end
			end
		end

		main = main and main:FindFirstChild("Quest")

		if main and main.Visible then
			for _, descendant in ipairs(main:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Text ~= "" then
					local v_7 = ResolveIslandKeyFromText(descendant.Text)
					if v_7 then
						return v_7
					end
				end
			end
		end

		local trackedQuestFrame = playerGui:FindFirstChild("TrackedQuestFrame")

		if trackedQuestFrame and trackedQuestFrame.Enabled then
			for _, descendant in ipairs(trackedQuestFrame:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Text ~= "" then
					local v_7 = ResolveIslandKeyFromText(descendant.Text)
					if v_7 then
						return v_7
					end
				end
			end
		end

		local v_7 = fn2()

		if v_7 and v_7.Data and v_7.Data.QuestData then
			local questData = v_7.Data.QuestData
			local v_8 = ResolveIslandKeyFromText(tostring(questData.QuestName or "") .. " " .. tostring(questData.Task or "") .. " " .. tostring(questData.Description or ""))
			if v_8 then
				return v_8
			end
		end

		return nil
	end

	GetEliteIslandFromUI = function()
		local v_7 = GetEliteIslandKeyFromUI()
		return v_7 and tbl8[v_7] or nil
	end

	v_3 = nil
	v_4 = nil
	local n4 = 0
	n = 1
	n2 = 0
	local n5 = 1
	local n6 = 0
	local tbl9 = { tbl8.turtle, tbl8.hydra, tbl8.port, tbl8.tree }

	GetNextElitePatrolCFrame = function()
		local now = tick()
		local humanoidRootPart2 = localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		local v_7 = tbl9[n5]

		if humanoidRootPart2 and v_7 then
			if (humanoidRootPart2.Position - v_7.Position).Magnitude < 350 or now - n6 > 25 then
				n5 = n5 % #tbl9 + 1
				n6 = now
			end
		elseif now - n6 > 25 then
			n5 = n5 % #tbl9 + 1
			n6 = now
		end

		return tbl9[n5]
	end

	GetEliteTargetCFrame = function(arg)
		local v_7 = arg or GetCurrentEliteMobName()
		local v_8 = GetEliteMob(v_7)

		if v_8 and IsMobAlive(v_8) then
			local humanoidRootPart2 = v_8:FindFirstChild("HumanoidRootPart", true) or v_8.PrimaryPart
			if humanoidRootPart2 then
				return humanoidRootPart2.CFrame
			end
		end

		local v_9, v_10 = GetEliteMobFromReplicated(v_7)
		if v_10 then
			return v_10
		end
		local v_11 = v_3 or GetEliteIslandKeyFromUI()

		if v_11 and tbl7[v_11] then
			v_3 = v_11
			local v_12 = tbl7[v_11]
			local humanoidRootPart2 = localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			local v_13 = v_12[n] or v_12[1]
			local now = tick()

			if humanoidRootPart2 and v_13 then
				if (humanoidRootPart2.Position - v_13.Position).Magnitude < 200 or now - n2 > 10 then
					n = n % #v_12 + 1
					n2 = now
				end
			elseif now - n2 > 10 then
				n = n % #v_12 + 1
				n2 = now
			end

			return v_12[n] or v_12[1]
		end

		return GetNextElitePatrolCFrame()
	end

	DetectEliteHunter = function(arg)
		local v_7 = GetEliteMob()
		if v_7 and IsMobAlive(v_7) then
			return v_7
		end

		if arg then
			if HasEliteQuest() then
				return true
			end
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

			if ReplicatedStorage2 then
				for _, child in ipairs(ReplicatedStorage2:GetChildren()) do
					if child:IsA("Model") and IsEliteName(child.Name) then
						local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart", true) or child.PrimaryPart
						if humanoidRootPart2 and humanoidRootPart2.Position.Magnitude > 100 then
							return child
						end
					end
				end
			end
		end

		return nil
	end

	EnsureEliteQuest = function(arg)
		if HasEliteQuest(arg) then
			if not v_3 then
				pcall(function()
					local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")

					if type(response) == "string" then
						local v_7 = ResolveIslandKeyFromText(response)

						if v_7 then
							v_3 = v_7
							n = 1
							n2 = tick()
						end
					end
				end)
			end

			return true
		end

		if tick() - n4 < 1.5 then
			return false
		end
		n4 = tick()
		local playerGui = game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")
		local quest = playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest")

		if quest and quest.Visible and not HasEliteQuest() then
			local flag = false

			for _, descendant in ipairs(quest:GetDescendants()) do
				if descendant:IsA("TextLabel") and descendant.Text ~= "" then
					local v_7 = string.lower(descendant.Text)
					if string.find(v_7, "elite", 1, true) or IsEliteName(v_7) then
						flag = true
						break
					end
				end
			end

			if not flag then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
				end)

				task.wait(0.2)
			end
		end

		local response = nil

		pcall(function()
			response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")
		end)

		if type(response) == "string" then
			local v_7 = ResolveIslandKeyFromText(response)

			if v_7 then
				v_3 = v_7
				n = 1
				n2 = tick()
			end
		end

		task.wait(0.2)

		if not HasEliteQuest(arg) then
			pcall(function()
				local response2 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter")

				if type(response2) == "string" and not v_3 then
					local v_7 = ResolveIslandKeyFromText(response2)

					if v_7 then
						v_3 = v_7
						n = 1
						n2 = tick()
					end
				end
			end)
		end

		pcall(function()
			local dialogue = playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Dialogue")

			if dialogue then
				for _, descendant in ipairs(dialogue:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Text ~= "" then
						local v_7 = ResolveIslandKeyFromText(descendant.Text)

						if v_7 then
							v_3 = v_7
							n = 1
							n2 = tick()
							break
						end
					end
				end

				dialogue.Visible = false
			end
		end)

		local character = localPlayer and localPlayer.Character
		local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart2 and humanoidRootPart2.Anchored then
			pcall(function()
				humanoidRootPart2.Anchored = false
			end)
		end

		return HasEliteQuest(arg)
	end

	local n7 = 0
	lastCheckTime = tick()

	GetOldestLocation = function()
		local huge = math.huge
		local v_7 = nil

		for _, child in ipairs(workspace._WorldOrigin.Locations:GetChildren()) do
			local attribute = child:GetAttribute("TimeIn")

			if attribute and attribute < huge then
				huge = attribute
				v_7 = child
			end
		end

		return v_7
	end

	spawn(function()
		while wait(0.25) do
			local ok, result = pcall(function()
				local distributedGameTime = game.workspace.DistributedGameTime
				local n8 = math.floor(distributedGameTime / 60 % 60)
				TimerLabel.SetText(string.format("Timer: %.0fh %.0fm %.0fs", math.floor(distributedGameTime / 3600), n8, distributedGameTime % 60))
				local v_7 = GetOldestLocation()

				if v_7 then
					local attribute = v_7:GetAttribute("TimeIn")
					local n9 = tick() - 25200 - attribute
					math.floor(n9 / 14400)
					local n10 = 14400 - n9 % 14400
					local n11 = math.floor(n10 / 3600)
					local n12 = math.floor(n10 % 3600 / 60)
					local n13 = math.floor(n10 % 60)
					local n14 = math.floor(n9 / 3600)
					local n15 = math.floor(n9 % 3600 / 60)
					local n16 = math.floor(n9 % 60)
					TimerServerLabel.SetText(string.format("Server Timer: %.0fh %.0fm %.0fs", n14, n15, n16))
					NextTimerServerLabel.SetText(string.format("Next Time Spawn Fist of Darkness or God's Chalice: %.0fh %.0fm %.0fs", n11, n12, n13))

					if tonumber(n11) == 0 and tonumber(n12) == 0 and tonumber(n13) <= 5 then
						getgenv().GoCollectChest = true
					end
				end

				if DetectEliteHunter(true) then
					StatusEliteHunter.SetText("Elite Hunter: ✅")
				else
					StatusEliteHunter.SetText("Elite Hunter: ❌")
				end

				if game.PlaceId == getgenv().CheckPlaceId then
					n7 = 0
					local islandModel = workspace.Map:FindFirstChild("TikiOutpost") and workspace.Map.TikiOutpost.IslandModel

					if islandModel then
						local tbl10 = {}

						for i = 1, 4 do
							local v_8 = islandModel:FindFirstChild("Eye" .. i, true)

							if v_8 then
								table.insert(tbl10, v_8)
							end
						end

						for _, v_8 in ipairs(tbl10) do
							if v_8.Transparency == 1 and n7 < 4 then
								n7 += 1
							end
						end
					end
				end

				StatusTyrant.SetText("Tyrant Eyes: " .. tostring(n7) .. " Eyes")
				local response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true) or ""

				if response:find("open the portal now") then
					game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
				end

				StatusKatakuri.SetText("Cake Prince: " .. string.gsub(response, "%D", "") .. " Mobs")
				Statusspy.SetText("Leviathan: " .. StatusCheckLeviathan())

				if workspace.Map:FindFirstChild("MysticIsland") then
					StatusMirage.SetText("Mirage Island: ✅")
				else
					StatusMirage.SetText("Mirage Island: ❌")
				end

				if not workspace.Map:FindFirstChild("PrehistoricIsland") then
					StatusPrehistoricIsland.SetText("Prehistoric Island: ❌")
				else
					StatusPrehistoricIsland.SetText("Prehistoric Island: ✅")
				end

				if not workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
					StatusFrozenDimension.SetText("Frozen Dimension: ❌")
				else
					StatusFrozenDimension.SetText("Frozen Dimension: ✅")
				end

				StatusGear.SetText("Ancient One: " .. CheckAcientOneStatus())

				if getgenv().StatusGearDraco then
					getgenv().StatusGearDraco.SetText("Draco: " .. CheckAcientOneDracoStatus())
				end

				StatusMoon.SetText("Moon Phase: " .. CheckMoon() .. " | " .. function8())
			end)

			if result then
				print(result)
			end
		end
	end)

	LocalPlayerMain = Main.CreatePage({ Page_Name = "LocalPlayer", Page_Title = "LocalPlayer" })
	SectionLocalPlayerMain = LocalPlayerMain.CreateSection("Local Player")

	SectionLocalPlayerMain.CreateToggle({
		Title = "Auto Translate",
		Desc = "It may take a bit longer to translate the first time.",
		Default = Settings["Auto Translate"] or false,
	}, function(arg)
		SaveSettings("Auto Translate", arg)
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Stop Tween" }, function()
		getgenv().noclip = false
		TweenManager.CancelCurrent()
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Fix UI Button Game" }, function()
		v_2(game:GetService("ReplicatedStorage").Modules.LastInput).IsMobile = function()
			return true
		end

		wait(0.5)
		localPlayer.Character.Humanoid.Health = 0
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Load config in Web" }, function()
		local HttpService_ = game:GetService("HttpService")
		game:GetService("RunService")
		local key = getgenv().Key
		local name = game.Players.LocalPlayer.Name

		ApplyConfigFromWeb = function(arg)
			for _, v_7 in pairs(arg) do
				if v_7.name then
					local v_8 = Options[v_7.name]

					if v_8 and v_7 then
						if v_7.value ~= nil and v_8.type ~= "slider_dropdown" and v_8.type ~= "priority_dropdown" then
							if v_8.FunctionCreate and v_8.FunctionCreate.SetValue then
								if v_8.type == "box" then
									v_8.FunctionCreate.SetValue(tostring(v_7.value))
								elseif v_8.type == "dropdown" then
									v_8.FunctionCreate.SetValue(v_7.value)
								elseif v_8.type == "slider" then
									v_8.FunctionCreate.SetValue(v_7.value)
								else
									v_8.FunctionCreate:SetValue(v_7.value)
								end
							elseif v_8.FunctionCreate and v_8.FunctionCreate.SetStage then
								v_8.FunctionCreate.SetStage(v_7.value)
							end
						end

						if v_8.type == "priority_dropdown" and v_7.selected then
							if v_8.FunctionCreate and v_8.FunctionCreate.SetValue then
								v_8.FunctionCreate.SetValue(v_7.selected)
							end
						end

						if v_8.type == "slider_dropdown" and v_7.values then
							for k, value in pairs(v_7.values) do
								if v_8.FunctionCreate and v_8.FunctionCreate.SetSubValue then
									v_8.FunctionCreate:SetSubValue(k, value)
								end
							end
						end
					end
				end
			end
		end

		local ok, result = pcall(function()
			local urlEncode = HttpService_.UrlEncode

			return request({
				Url = string.format("%s/config/get?authId=%s&userId=%s&roblox=true", "https://cfg.banana-hub.xyz", HttpService_:UrlEncode(key), urlEncode(HttpService_, name)),
				Method = "GET",
			})
		end)

		if ok and result.StatusCode == 200 then
			local v_7 = ApplyConfigFromWeb
			local data = HttpService_:JSONDecode(result.Body)
			v_7(data)
		end
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Push Data To Web ( just push when join game,if push again plz rejoin )" }, function()
		local HttpService_ = game:GetService("HttpService")

		BuildSchema = function()
			local tbl10 = {}
			local n8 = 1

			for k, v_7 in pairs(Options) do
				local pageName = v_7.Page_Name or "Default Page"
				local sectionName = v_7.Section_Name or "Default Section"
				local str2 = tostring(n8)

				if v_7.type == "toggle" then
					tbl10[str2] = { name = k, type = "toggle", value = v_7.value, page = pageName, section = sectionName }
				elseif v_7.type == "button" then
					tbl10[str2] = { name = k, type = "button", value = k, text = k, page = pageName, section = sectionName }
				elseif v_7.type == "textlabel" then
					local getText = v_7.FunctionCreate and v_7.FunctionCreate.GetText and v_7.FunctionCreate.GetText() or v_7.text or k

					tbl10[str2] = {
						name = k,
						type = "label",
						value = getText,
						text = getText,
						color = v_7.color or "#B8B8B8",
						size = v_7.size or "14px",
						bold = v_7.bold or false,
						page = pageName,
						section = sectionName,
					}
				elseif v_7.type == "box" then
					tbl10[str2] = { name = k, type = "box", value = v_7.value or "", page = pageName, section = sectionName }
				elseif v_7.type == "slider" then
					tbl10[str2] = {
						name = k,
						type = "slider",
						min = v_7.min or 0,
						max = v_7.max or 100,
						step = v_7.step or 1,
						value = v_7.value or v_7.min or 0,
						page = pageName,
						section = sectionName,
					}
				elseif v_7.type == "dropdown" then
					tbl10[str2] = {
						name = k,
						type = "dropdown",
						options = table.clone(v_7.list or {}),
						value = v_7.value or v_7.list and v_7.list[1] or "",
						page = pageName,
						section = sectionName,
					}
				elseif v_7.type == "priority_dropdown" then
					local v_8 = table.clone(v_7.value or {})

					tbl10[str2] = {
						name = k,
						type = "priority_dropdown",
						options = table.clone(v_7.list or {}),
						selected = v_8,
						value = v_8,
						page = pageName,
						section = sectionName,
					}
				elseif v_7.type == "multi_toggle" then
					tbl10[str2] = {
						name = k,
						type = "multi_toggle",
						options = table.clone(v_7.list or {}),
						value = table.clone(v_7.value or {}),
						page = pageName,
						section = sectionName,
					}
				elseif v_7.type == "slider_dropdown" then
					local tbl11 = {}
					local tbl12 = {}
					local v_8 = pairs
					local list = v_7.list or {}

					for k2, v_9 in v_8(list) do
						tbl11[k2] = { min = v_9.min or 0, max = v_9.max or 100, step = v_9.step or 1 }
						tbl12[k2] = v_7.value and v_7.value[k2] or v_9.Default or v_9.min or 0
					end

					tbl10[str2] = {
						name = k,
						type = "slider_dropdown",
						sliders = tbl11,
						values = tbl12,
						page = pageName,
						section = sectionName,
					}
				end

				n8 += 1
			end

			return tbl10
		end

		UploadSchemaToWeb = function(arg, arg2)
			if not arg or not arg2 then
				warn("❌ Missing authId or userId for schema upload")
				return false
			end
			local v_7 = BuildSchema()

			local ok, result = pcall(function()
				local urlEncode = HttpService_.UrlEncode

				return request({
					Url = string.format("%s/schema/init?authId=%s&userId=%s", "https://cfg.banana-hub.xyz", HttpService_:UrlEncode(arg), urlEncode(HttpService_, arg2)),
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService_:JSONEncode(v_7),
				})
			end)

			if ok and result.StatusCode == 200 then
				print("✅ Schema initialized (first time)")
				return true
			end

			if ok and result.StatusCode == 409 then
				print("ℹ️ Schema already exists, skipping upload")
				return true
			end
			warn("❌ Schema upload failed")

			if ok then
				warn("Status:", result.StatusCode)
				warn("Body:", result.Body)
			end

			return false
		end

		PushSchemaToWebupdate = function(arg, arg2)
			if not arg or not arg2 then
				return
			end
			local v_7 = BuildSchema()

			local ok, result = pcall(function()
				local urlEncode = HttpService_.UrlEncode

				return request({
					Url = string.format("%s/schema/update?authId=%s&userId=%s", "https://cfg.banana-hub.xyz", HttpService_:UrlEncode(arg), urlEncode(HttpService_, arg2)),
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService_:JSONEncode(v_7),
				})
			end)

			if ok and result.StatusCode == 200 then
				print("✅ Schema UPDATED → web will reload")
			else
				warn("❌ Push schema failed")

				if ok then
					warn("Status:", result.StatusCode)
					warn("Body:", result.Body)
				end
			end
		end

		local key = getgenv().Key
		local name = game.Players.LocalPlayer.Name

		request({
			Url = "https://cfg.banana-hub.xyz/config/get?authId=" .. key .. "&userId=" .. name .. "&roblox=true",
			Method = "GET",
		})

		ForceResetSchema = function(arg, arg2)
			pcall(function()
				local urlEncode = HttpService_.UrlEncode

				request({
					Url = string.format("%s/schema/delete?authId=%s&userId=%s", "https://cfg.banana-hub.xyz", HttpService_:UrlEncode(arg), urlEncode(HttpService_, arg2)),
					Method = "DELETE",
				})
			end)

			wait(0.5)
			return UploadSchemaToWeb(arg, arg2)
		end

		ForceResetSchema(key, name)
	end)

	local v_7 = nil

	pcall(function()
		v_7 = v_2(game.ReplicatedStorage:WaitForChild("Controllers", 5):WaitForChild("UI", 5):WaitForChild("Inventory", 5))
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Show Item" }, function()
		if not v_7 then
			return
		end

		if not game:GetService("CoreGui").ExperienceChat.bubbleChat:FindFirstChild("Right") then
			local localPlayer2 = game.Players.LocalPlayer
			local CoreGui = game:GetService("CoreGui")
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

			if not v_7.IsOpen then
				v_7:Open()
				task.wait(2)
			end

			local inventory = localPlayer2.PlayerGui:FindFirstChild("Inventory")
			if not inventory then
				return
			end
			local frame = inventory:FindFirstChild("Frame") or inventory:WaitForChild("Frame", 3)
			if not frame then
				return
			end
			local main = frame:FindFirstChild("Main")
			main = main and main:FindFirstChild("PageContent")
			main = main and main:FindFirstChild("Inner")
			main = main and main:FindFirstChild("TileGrid")
			main = main and main:FindFirstChild("Inner")
			main = main and main:FindFirstChild("Container")
			if not main or not main:IsA("ScrollingFrame") then
				return
			end
			local tbl10 = {}
			local tbl11 = {}
			main.CanvasPosition = Vector2.new(0, 0)
			local n8 = main.CanvasSize.Y.Offset - main.AbsoluteWindowSize.Y
			local n9 = 0

			while main.CanvasPosition.Y < n8 and task.wait(0.1) do
				main.CanvasPosition = Vector2.new(0, n9)

				for _, child in pairs(main:GetChildren()) do
					if child:FindFirstChild("Details") and child.Details:FindFirstChild("Line-1") then
						local str2 = child.Details["Line-1"].ContentText .. (child.Details:FindFirstChild("Line-2") and child.Details["Line-2"].ContentText or "")

						if not tbl10[str2] then
							tbl10[str2] = true
							table.insert(tbl11, child:Clone())
						end
					end
				end

				n9 += 20
			end

			for _, v_8 in ipairs({ "Left", "Right" }) do
				local v_9 = CoreGui.ExperienceChat.bubbleChat:FindFirstChild(v_8)

				if v_9 then
					v_9:Destroy()
				end
			end

			local frame2 = Instance.new("Frame", CoreGui.ExperienceChat.bubbleChat)
			frame2.Name = "Left"
			frame2.BackgroundTransparency = 1
			frame2.Size = UDim2.new(0.5, 0, 1, 0)
			local frame3 = Instance.new("Frame", CoreGui.ExperienceChat.bubbleChat)
			frame3.Name = "Right"
			frame3.BackgroundTransparency = 1
			frame3.Position = UDim2.new(0.5, 0, 0, 0)
			frame3.Size = UDim2.new(0.5, 0, 1, 0)

			local function createUIListLayout(arg)
				local uiListLayout = Instance.new("UIListLayout", arg)
				uiListLayout.FillDirection = Enum.FillDirection.Vertical
				uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.Padding = UDim.new(0, 10)
				return uiListLayout
			end

			createUIListLayout(frame2)
			createUIListLayout(frame3)

			local function createUIGridLayout(arg)
				local uiGridLayout = Instance.new("UIGridLayout", arg)
				uiGridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
				uiGridLayout.CellSize = UDim2.new(0, 70, 0, 70)
				uiGridLayout.FillDirectionMaxCells = 8
				uiGridLayout.FillDirection = Enum.FillDirection.Horizontal
				uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
				return uiGridLayout
			end

			local frame4 = Instance.new("Frame", frame2)
			frame4.BackgroundTransparency = 1
			frame4.Size = UDim2.new(1, 0, 0, 0)
			frame4.AutomaticSize = Enum.AutomaticSize.Y
			frame4.LayoutOrder = 1
			createUIGridLayout(frame4)
			local frame5 = Instance.new("Frame", frame3)
			frame5.BackgroundTransparency = 1
			frame5.Size = UDim2.new(1, 0, 0, 0)
			frame5.AutomaticSize = Enum.AutomaticSize.Y
			frame5.LayoutOrder = 1
			createUIGridLayout(frame5)
			local tbl12 = { Vector2.new(218, 225), Vector2.new(436, 225) }

			for _, v_8 in ipairs(tbl11) do
				local contentText = v_8.Details.Category.ContentText

				if contentText == "Blox Fruit" and table.find(tbl12, v_8.ImageRectOffset) then
					v_8.Parent = frame5
				elseif contentText ~= "Blox Fruit" then
					v_8.Parent = frame4
				end
			end

			local frame6 = Instance.new("Frame", frame3)
			frame6.BackgroundTransparency = 1
			frame6.Size = UDim2.new(1, 0, 0, 0)
			frame6.AutomaticSize = Enum.AutomaticSize.Y
			frame6.LayoutOrder = 100
			createUIGridLayout(frame6)
			local tbl13 = {}
			local tbl14 = {}

			for k, v_8 in pairs({
				Superhuman = Vector2.new(3, 2),
				DeathStep = Vector2.new(4, 3),
				ElectricClaw = Vector2.new(2, 0),
				SharkmanKarate = Vector2.new(0, 0),
				DragonTalon = Vector2.new(1, 5),
				Godhuman = "rbxassetid://10338473987",
			}) do
				if ReplicatedStorage2.Remotes.CommF_:InvokeServer("Buy" .. k, true) == 1 then
					local imageLabel2 = Instance.new("ImageLabel", frame6)
					imageLabel2.BackgroundTransparency = 1

					if type(v_8) == "string" then
						imageLabel2.Image = v_8
					else
						imageLabel2.Image = "rbxassetid://9945562382"
						imageLabel2.ImageRectSize = Vector2.new(100, 100)
						imageLabel2.ImageRectOffset = v_8 * 100
					end

					tbl14[k] = imageLabel2
					table.insert(tbl13, k)
				end
			end

			local function createTextLabel()
				local textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
				textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
				textLabel.Font = Enum.Font.GothamBold
				textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel.TextSize = 10
				textLabel.TextXAlignment = Enum.TextXAlignment.Right
				textLabel.TextYAlignment = Enum.TextYAlignment.Bottom
				textLabel.ZIndex = 5
				return textLabel
			end

			local function fn3(arg)
				for _, child in pairs(localPlayer2.Backpack:GetChildren()) do
					if child.Name:gsub(" ", "") == arg then
						return child
					end
				end
			end

			spawn(function()
				local n10 = #tbl13
				local n11 = 0

				while n11 < n10 do
					for k, v_8 in pairs(tbl14) do
						if not v_8:FindFirstChild("Ditme") then
							ReplicatedStorage2.Remotes.CommF_:InvokeServer("Buy" .. k)
							task.wait(0.1)
							local v_9 = fn3(k)

							if v_9 then
								v_9:WaitForChild("Level")
								local v_10 = createTextLabel()
								v_10.Name = "Ditme"
								v_10.Text = v_9.Level.Value
								v_10.Parent = v_8
								n11 += 1
							end
						end
					end

					task.wait()
				end
			end)

			task.wait(2)
			localPlayer2.PlayerGui.Main.AwakeningToggler.Visible = true
			local clone = localPlayer2.PlayerGui.Main.AwakeningToggler:Clone()
			clone.LayoutOrder = 101
			localPlayer2.PlayerGui.Main.AwakeningToggler.Visible = false
			clone.Parent = frame3
			clone.Size = UDim2.new(1, 0, 0.3, 0)

			local function fn4(arg)
				return tostring(arg):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
			end

			local clone2 = localPlayer2.PlayerGui.Main.Fragments:Clone()
			clone2.Parent = CoreGui.ExperienceChat.bubbleChat
			clone2.Position = UDim2.new(0, 6, 0.85799, 0)
			clone2.Text = "ƒ" .. fn4(localPlayer2.Data.Fragments.Value)
			wait(2)

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.MenuButton.Visible = false
			end)

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.HP.Visible = false
			end)

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.Energy.Visible = false
			end)

			for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main:GetChildren()) do
				if child:IsA("ImageButton") then
					child.Visible = false
				end
			end

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.Compass.Visible = false
			end)

			v_7:Close()
		else
			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.MenuButton.Visible = true
			end)

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.HP.Visible = true
			end)

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.Energy.Visible = true
			end)

			for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main:GetChildren()) do
				if child:IsA("ImageButton") then
					child.Visible = true
				end
			end

			pcall(function()
				game:GetService("Players").LocalPlayer.PlayerGui.Main.Compass.Visible = true
			end)

			for _, child in pairs(game:GetService("CoreGui").ExperienceChat.bubbleChat:GetChildren()) do
				if child.Name == "Left" or child.Name == "Right" or child.Name == "Fragments" then
					child:Destroy()
				end
			end
		end
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Open Devil Fruit Shop" }, function()
		local v_8 = v_2(game.ReplicatedStorage.Controllers.UI.FruitShop)
		v_8.init()
		v_8:Open()
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Open Devil Fruit Shop Mirage" }, function()
		local v_8 = v_2(game.ReplicatedStorage.Controllers.UI.FruitShop)
		v_8.init()
		v_8:Open("AdvancedFruitDealer")
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Open Title" }, function()
		game:GetService("Players").LocalPlayer.PlayerGui.Main.Titles.Visible = true
	end)

	SectionLocalPlayerMain.CreateButton({ Title = "Open Color" }, function()
		game:GetService("Players").LocalPlayer.PlayerGui.Main.Colors.Visible = true
	end)

	SectionLocalPlayerMain.CreateDropdown({
		Title = "Select Stats",
		List = PrepareMultiSelectList({ Melee = false, Defense = false, Sword = false, Gun = false, ["Demon Fruit"] = false }, Settings["Select Stats"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Stats"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Stats", arg, arg2)
	end)

	SectionLocalPlayerMain.CreateToggle({ Title = "Auto Stats", Desc = nil, Default = Settings["Auto Stats"] or false }, function(arg)
		spawn(function()
			while Settings["Auto Stats"] and task.wait(0.3) do
				pcall(function()
					for k, v_8 in next, Settings["Select Stats"], nil do
						v_8 = v_8 and game.Players.localPlayer.Data.Points.Value > 0 and game:GetService("Players").LocalPlayer.Data.Stats[k].Level.Value < 2800

						if v_8 then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", k, 9999)
							wait(3)
						end
					end
				end)
			end
		end)

		SaveSettings("Auto Stats", arg)
	end)

	SectionLocalPlayerMain.CreateDropdown({
		Title = "Select Team",
		List = { "Pirate", "Marine" },
		Search = true,
		Selected = false,
		Default = Settings["Select Team"] or nil,
	}, function(arg)
		SaveSettings("Select Team", arg)
	end)

	SectionLocalPlayerMain.CreateDropdown({
		Title = "Change Team",
		List = { "Pirates", "Marines" },
		Search = true,
		Selected = false,
		Default = nil,
	}, function(arg)
		if arg then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "SetTeam", arg }))
		end
	end)

	SectionLocalPlayerMain.CreateToggle({ Title = "Noclip", Desc = nil, Default = Settings.Noclip or false }, function(arg)
		SaveSettings("Noclip", arg)
	end)

	imageLabel = nil

	SetRobloxGUI = function(enabled)
		game.CoreGui.RobloxGui.Enabled = enabled
	end

	spawn(function()
		local now = tick()

		while true do
			wait(1)

			if tick() - now > 179 then
				game:Shutdown()
				wait(10)
			end

			if not (game:FindFirstChild("CoreGui") and game.Players.LocalPlayer and game.Players.LocalPlayer.Character) then
				continue
			end
			break
		end

		local now2 = tick()

		while true do
			wait(1)

			if tick() - now2 > 169 then
				game:Shutdown()
				wait(10)
			end

			if not (game.Players.LocalPlayer:FindFirstChild("Backpack") and game.Players.LocalPlayer:GetMouse()) then
				continue
			end
			break
		end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
		screenGui.ResetOnSpawn = false
		getgenv().SCGUI = screenGui

		repeat
			wait(1)
		until SCGUI

		imageLabel = Instance.new("ImageLabel", SCGUI)
		imageLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		imageLabel.Position = UDim2.new(0, 0, 0, -50)
		imageLabel.Size = UDim2.new(1, 0, 1, 50)
		imageLabel.Visible = false
		imageLabel.Name = "Black Screen"
		getgenv().BS_Text = Instance.new("TextLabel", imageLabel)
		BS_Text.TextSize = 30
		BS_Text.TextColor3 = Color3.fromRGB(255, 255, 255)
		BS_Text.AnchorPoint = Vector2.new(0.5, 0)
		BS_Text.Position = UDim2.new(0.5, 0, 0.6, 0)
		BS_Text.Font = Enum.Font.SourceSansBold
		BS_Text.RichText = true
		BS_Default = "\n<font color=\"rgb(45, 45, 45)\"><font size=\"20\">Black Screen</font></font>"

		getgenv().UpdateBlackScreenText = function(arg)
			BS_Text.Text = arg .. BS_Default
		end

		UpdateBlackScreenText("")
		getgenv().DisableBlackScreen = false
	end)

	local tbl10 = {}
	local tbl11 = {}

	for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
		if not string.find(child.Name, "Boat") and not string.find(child.Name, "Set Home") then
			table.insert(tbl10, child.Name)
			table.insert(tbl11, child)
		end
	end

	for _, child in pairs(game:GetService("ReplicatedStorage").NPCs:GetChildren()) do
		if not string.find(child.Name, "Boat") and not string.find(child.Name, "Set Home") then
			table.insert(tbl10, child.Name)
			table.insert(tbl11, child)
		end
	end

	local tbl12 = {}

	if game.PlaceId == getgenv().CheckPlaceId3 then
		tbl12 = {
			["Start Island"] = CFrame.new(1071.2832, 16.3085976, 1426.86792),
			["Marine Start"] = CFrame.new(-2573.3374, 6.88881969, 2046.99817),
			["Middle Town"] = CFrame.new(-655.824158, 7.88708115, 1436.67908),
			Jungle = CFrame.new(-1249.77222, 11.8870859, 341.356476),
			["Pirate Village"] = CFrame.new(-1122.34998, 4.78708982, 3855.91992),
			Desert = CFrame.new(1094.14587, 6.47350502, 4192.88721),
			["Frozen Village"] = CFrame.new(1198.00928, 27.0074959, -1211.73376),
			MarineFord = CFrame.new(-4505.375, 20.687294, 4260.55908),
			Colosseum = CFrame.new(-1428.35474, 7.38933945, -3014.37305),
			["Sky 1st Floor"] = CFrame.new(-4970.21875, 717.707275, -2622.35449),
			["Sky 2st Floor"] = CFrame.new(-4813.0249, 903.708557, -1912.69055),
			["Sky 3st Floor"] = CFrame.new(-7952.31006, 5545.52832, -320.704956),
			Prison = CFrame.new(4854.16455, 5.68742752, 740.194641),
			["Magma Village"] = CFrame.new(-5231.75879, 8.61593437, 8467.87695),
			["UndeyWater City"] = CFrame.new(61163.8516, 11.7796879, 1819.78418),
			["Fountain City"] = CFrame.new(5132.7124, 4.53632832, 4037.8562),
			["House Cyborg's"] = CFrame.new(6262.72559, 71.3003616, 3998.23047),
			["Shank's Room"] = CFrame.new(-1442.16553, 29.8788261, -28.3547478),
			["Mob Island"] = CFrame.new(-2850.20068, 7.39224768, 5354.99268),
		}
	elseif game.PlaceId == getgenv().CheckPlaceId2 then
		tbl12 = {
			["First Spot"] = CFrame.new(82.9490662, 18.0710983, 2834.98779),
			["Kingdom of Rose"] = game.Workspace._WorldOrigin.Locations["Kingdom of Rose"].CFrame,
			["Dark Ares"] = game.Workspace._WorldOrigin.Locations["Dark Arena"].CFrame,
			["Flamingo Mansion"] = CFrame.new(-390.096313, 331.886475, 673.464966),
			["Flamingo Room"] = CFrame.new(2302.19019, 15.1778421, 663.811035),
			["Green bit"] = CFrame.new(-2372.14697, 72.9919434, -3166.51416),
			Cafe = CFrame.new(-385.250916, 73.0458984, 297.388397),
			Factroy = CFrame.new(430.42569, 210.019623, -432.504791),
			Colosseum = CFrame.new(-1836.58191, 44.5890656, 1360.30652),
			["Ghost Island"] = CFrame.new(-5571.84424, 195.182297, -795.432922),
			["Ghost Island 2nd"] = CFrame.new(-5931.77979, 5.19706631, -1189.6908),
			["Snow Mountain"] = CFrame.new(1384.68298, 453.569031, -4990.09766),
			["Hot and Cold"] = CFrame.new(-6026.96484, 14.7461271, -5071.96338),
			["Magma Side"] = CFrame.new(-5478.39209, 15.9775667, -5246.9126),
			["Cursed Ship"] = CFrame.new(902.059143, 124.752518, 33071.8125),
			["Frosted Island"] = CFrame.new(5400.40381, 28.21698, -6236.99219),
			["Forgotten Island"] = CFrame.new(-3043.31543, 238.881271, -10191.5791),
			["Usoapp Island"] = CFrame.new(4748.78857, 8.35370827, 2849.57959),
			["Raids Low"] = CFrame.new(-5554.95313, 329.075623, -5930.31396),
			Minisky = CFrame.new(-260.358917, 49325.7031, -35259.3008),
		}
	elseif game.PlaceId == getgenv().CheckPlaceId then
		tbl12 = {
			["Port Town"] = CFrame.new(-287, 30, 5388),
			["Hydar Island"] = CFrame.new(3399.32227, 72.4142914, 1572.99963, -0.809679806, -4.48284467e-08, 0.586871922, 2.42332163e-08, 1, 1.09818842e-07, -0.586871922, 1.0313989e-07, -0.809679806),
			["Room Enma/Yama & Secret Temple"] = CFrame.new(5247, 7, 1097),
			["House Hydar Island"] = CFrame.new(5245, 602, 251),
			["Great Tree"] = CFrame.new(2443, 36, -6573),
			["Castle on the sea"] = CFrame.new(-5500, 314, -2855),
			Mansion = CFrame.new(-12548, 337, -7481),
			["Floating Turtle"] = CFrame.new(-10016, 332, -8326),
			["Haunted Castle"] = CFrame.new(-9509.34961, 142.130661, 5535.16309),
			["Peanut Island"] = CFrame.new(-2131, 38, -10106),
			["Ice Cream Island"] = CFrame.new(-950, 59, -10907),
			CakeLoaf = CFrame.new(-1762, 38, -11878),
			Tiki = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375),
		}
	end

	local tbl13 = {}

	for k in next, tbl12, nil do
		table.insert(tbl13, k)
	end

	SectionLocalPlayerMain.CreateDropdown({ Title = "Select Npc", List = tbl10, Search = true, Selected = false, Default = nil }, function(arg)
		notsave["Select Npc"] = arg
	end)

	SectionLocalPlayerMain.CreateToggle({ Title = "Teleport To Npc", Desc = nil, Default = false }, function(arg)
		notsave["Teleport To Npc"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionLocalPlayerMain.CreateDropdown({ Title = "Select Island", List = tbl13, Search = true, Selected = false, Default = nil }, function(arg)
		notsave["Select Island"] = arg
	end)

	SectionLocalPlayerMain.CreateToggle({ Title = "Teleport To Island", Desc = nil, Default = false }, function(arg)
		notsave["Teleport To Island"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionLocalPlayerMain.CreateToggle({ Title = "Teleport Mirage", Desc = nil, Default = false }, function(arg)
		notsave["Teleport Mirage"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	SectionLocalPlayerMain.CreateToggle({ Title = "Teleport Prehistoric Island", Desc = nil, Default = false }, function(arg)
		notsave["Teleport Prehistoric Island"] = arg

		if not arg then
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end)

	DetectPrehistoricIsland = function()
		local v_8 = next
		local children, v_9 = workspace._WorldOrigin.Locations:GetChildren()

		for _, v_10 in v_8, children, v_9 do
			if v_10.Name == "Prehistoric Island" and v_10:GetAttribute("CFrame") then
				return v_10
			end
		end
	end

	SetNoClip = function(noclip)
		getgenv().noclip = noclip
		local character = localPlayer.Character
		if not character then
			return
		end
		local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if not noclip then
			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = true
				end
			end

			if humanoid then
				humanoid.PlatformStand = false
			end

			if humanoidRootPart2 and humanoidRootPart2:FindFirstChild("FloatForce") and not ToggleNoclip() then
				humanoidRootPart2.FloatForce:Destroy()
			end
		end
	end

	ToggleNoclip = function()
		if Settings["Start Farm"] or Settings["Auto Present Event"] or Settings["Auto Celestial Soldier"] or Settings["Auto Rip Commander"] or Settings["Auto Event Halloween"] or Settings["Auto Attack Dungeon"] or Settings["Auto Fishing"] or Settings["Teleport To Fruit"] or Settings["Auto Factory"] or Settings["Auto Pirate Raid"] or Settings["Auto Elite Hunter"] or Settings["Hop Server Elite Hunter"] or Settings["Auto Touch Pad Haki"] or Settings["Auto Summon Rip Indra"] or Settings["Attack Rip Indra"] or Settings["Attack Soul Reaper"] or Settings["Summon Soul Reaper"] or Settings["Attack Dough King"] or Settings["Attack Darkbeard"] or Settings["Auto Raid"] or Settings["Auto Sea Event"] or Settings["Auto Shipwright"] or Settings["Teleport Acient Clock"] or Settings["Auto Upgrade Race V2-V3"] or Settings["Auto Trial"] or Settings["Auto Get Ghoul"] or Settings["Auto Get Cyborg"] or Settings["Auto Pull Lever"] or notsave["Teleport Mirage"] or notsave["Teleport To Island"] or notsave["Teleport To Npc"] or notsave["Teleport Prehistoric Island"] or notsave["Sanguine Art"] or notsave["God Human"] or notsave["Dragon Talon"] or notsave["Electric Claw"] or notsave["Sharkman Karate"] or notsave["Death Step"] or notsave.SuperHuman or notsave.DragonClaw or notsave.Electro or notsave["Fishman Karate"] or notsave["Black Leg"] or Settings["Teleport To Kitsune Island"] or Settings["Auto Spawn Kitsune Island"] or Settings["Auto Collect Soul Ember"] or Settings["Auto Summon Soul Ember"] or Settings["Auto Attack Leviathan"] or Settings["Auto Soul Guitar"] or Settings["Auto CDK"] or Settings["Auto Yama"] or Settings["Auto Tushita"] or Settings["Auto Upgrade Sword Inventory"] or Settings["Teleport Player"] or Settings["Auto Chest"] or Settings["Farm Observation"] or Settings["Auto Upgrade Gun Inventory"] or Settings["Kill Boss"] or Settings["Kill Mob"] or Settings["Auto UP Observation V2"] or Settings["Auto New World"] or Settings["Auto Third World"] or Settings["Tween Safe if have Items"] or Settings["Teleport Frozen Dimension"] or Settings["Auto Yoru Mini"] or Settings["Auto Quest Dojo Trainer"] or Settings["Auto Quest Dragon Hunter"] or Settings["Auto Crafting Volcanic Magnet"] or Settings["Auto Find Prehistoric Island"] or Settings["Auto Find Mirage"] or Settings["Auto Event Prehistoric Island"] or Settings["Auto Collect Bone"] or Settings["Auto Collect Berry"] or Settings["Auto Upgrade Race V2-V3 Draco"] or Settings["Auto Trial Draco"] or Settings["Auto Get Rainbow Haki"] or Settings["Follow Player Select"] or Settings["Auto Tween To Prehistoric Island"] or Settings["Auto Kill Golem"] or Settings["Auto Fix Volcano"] or Settings["Multi Find Leviathan"] or Settings["Fully Event Prehistoric Island"] or Settings["Auto Multi Raid"] or Settings["Auto Fire Shoot Heart Leviathan"] or Settings["Auto Buy Chip and Attack Law"] or Settings["Fully Trial Draco"] or Settings["Auto Finish Train Quest"] or Settings["Auto Destroy IDK"] or Settings["Auto Finish Train Draco Quest"] or Settings["Auto TTK"] or Settings["Auto Attack All Mob and Boss"] or Settings["Auto Collect Egg"] or Settings["Collect Chest When Server Spawn God's Chalice or Fist of Darkness"] then
			return true
		end
	end

	local TweenService = game:GetService("TweenService")

	getgenv().TweenManager = {
		currentTween = nil,
		currentPart = nil,
		currentGoal = nil,
		TweenRunning = false,
		CancelTweenOnly = function()
			local currentTween = TweenManager.currentTween
			local tween = getgenv().Tween

			if currentTween then
				pcall(function()
					currentTween:Cancel()
					currentTween:Destroy()
				end)
			end

			if tween and tween ~= currentTween then
				pcall(function()
					tween:Cancel()
					tween:Destroy()
				end)
			end

			TweenManager.currentTween = nil
			TweenManager.currentPart = nil
			TweenManager.currentGoal = nil
			TweenManager.TweenRunning = false
			getgenv().Tween = nil
		end,
		PlayTween = function(currentPart, arg, arg2, arg3)
			if not currentPart or not arg or not arg2 or not arg2.CFrame then
				return
			end

			if TweenManager.currentTween and TweenManager.currentPart == currentPart and TweenManager.currentGoal and ((arg3 or {}).TargetEpsilon or 12) >= (TweenManager.currentGoal.Position - arg2.CFrame.Position).Magnitude then
				return TweenManager.currentTween
			end
			TweenManager.CancelTweenOnly()
			local tween = TweenService:Create(currentPart, arg, arg2)
			TweenManager.currentTween = tween
			TweenManager.currentPart = currentPart
			TweenManager.currentGoal = arg2.CFrame
			TweenManager.TweenRunning = true
			getgenv().Tween = tween

			tween.Completed:Connect(function()
				if TweenManager.currentTween == tween then
					TweenManager.currentTween = nil
					TweenManager.currentPart = nil
					TweenManager.currentGoal = nil
					TweenManager.TweenRunning = false
					getgenv().Tween = nil

					pcall(function()
						tween:Destroy()
					end)
				end
			end)

			tween:Play()
			return tween
		end,
		CancelCurrent = function()
			local character = localPlayer.Character
			local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
			TweenManager.CancelTweenOnly()

			pcall(function()
				if not character then
					return
				end

				for _, descendant in ipairs(character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = true
					end
				end

				local humanoid = character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid.PlatformStand = false
				end

				if humanoidRootPart2 then
					if humanoidRootPart2:FindFirstChild("FloatForce") then
						humanoidRootPart2.FloatForce:Destroy()
					end

					humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
					humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero
				end
			end)

			if getgenv().TweenBoat then
				pcall(function()
					getgenv().TweenBoat:Cancel()
				end)

				getgenv().TweenBoat = nil
			end

			if getgenv().TweenBoatToFrozen then
				pcall(function()
					getgenv().TweenBoatToFrozen:Cancel()
				end)

				getgenv().TweenBoatToFrozen = nil
			end

			if getgenv().TweenBoatBack then
				pcall(function()
					getgenv().TweenBoatBack:Cancel()
				end)

				getgenv().TweenBoatBack = nil
			end

			if type(CancelTweenBoat) == "function" then
				pcall(CancelTweenBoat)
			end
		end,
	}

	TweenManager = getgenv().TweenManager
	local tbl14 = {}
	local CollectionService = game:GetService("CollectionService")
	local n8 = 0
	local flag = false

	local function fn3()
		n8 = tick() + 1.5

		if not CollectionService:HasTag(localPlayer, "Teleporting") then
			CollectionService:AddTag(localPlayer, "Teleporting")
			flag = true
		end
	end

	task.spawn(function()
		while task.wait(0.1) do
			if flag and tick() >= n8 then
				CollectionService:RemoveTag(localPlayer, "Teleporting")
				flag = false
			end
		end
	end)

	spawn(function()
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetUnlockables")
		local response

		repeat
			task.wait()
			response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetUnlockables")
		until response

		if response.DefeatedIndraTrueForm and game.PlaceId == getgenv().CheckPlaceId then
			tbl14["Caslte On The Sea"] = Vector3.new(-4967.6826, 314.8824, -3157.0984)
			tbl14.Hydra = Vector3.new(5661.5303, 1013.4113, -334.9619)
			tbl14.Mansion = Vector3.new(-12463.874, 374.91446, -7523.774)
		end

		if game.PlaceId == getgenv().CheckPlaceId then
			tbl14["Temple Clock"] = Vector3.new(28282.57, 14896.851, 105.10427)
		end

		if game.PlaceId == getgenv().CheckPlaceId2 then
			tbl14["122"] = Vector3.new(923.2125, 126.976006, 32852.832)
			tbl14["3032"] = Vector3.new(-6508.558, 89.034996, -132.83954)
		end

		if response.FlamingoAccess and game.PlaceId == getgenv().CheckPlaceId2 then
			tbl14.Mansion = Vector3.new(-288.46246, 306.1306, 597.99884)
			tbl14.Flamingo = Vector3.new(2284.912, 15.152046, 905.4829)
		end

		if game.PlaceId == getgenv().CheckPlaceId3 then
			tbl14 = {
				["1"] = Vector3.new(-7894.62, 5545.4917, -380.24673),
				["2"] = Vector3.new(-4607.8228, 872.5423, -1667.5569),
				["3"] = Vector3.new(61163.85, 11.759522, 1819.7842),
				["4"] = Vector3.new(3876.2805, 35.10614, -1939.3202),
			}
		end
	end)

	Players = game:GetService("Players")
	game:GetService("ReplicatedStorage")
	local VirtualInputManager = game:GetService("VirtualInputManager")

	local function fn4()
		local devilFruit = localPlayer.Data:FindFirstChild("DevilFruit")
		if not devilFruit or devilFruit.Value ~= "Portal-Portal" then
			return false
		end
		local skills = localPlayer and localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("Main") and localPlayer.PlayerGui.Main:FindFirstChild("Skills")
		skills = skills and skills:FindFirstChild(devilFruit.Value)
		local c = skills and skills:FindFirstChild("C")

		if not c or not c:IsA("Frame") then
			local portalPortal = localPlayer.Character:FindFirstChild("Portal-Portal") or localPlayer.Backpack:FindFirstChild("Portal-Portal")
			if not portalPortal then
				return false
			end
			local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid:EquipTool(portalPortal)
			end

			return false
		end

		local cooldown = c:FindFirstChild("Cooldown")
		return c.Title.TextColor3 == Color3.new(1, 1, 1) and (cooldown.Size == UDim2.new(0, 0, 1, -1) or cooldown.Size == UDim2.new(1, 0, 1, -1))
	end

	local function fn5(arg)
		local portalPortal = localPlayer.Character:FindFirstChild("Portal-Portal") or localPlayer.Backpack:FindFirstChild("Portal-Portal")
		if not portalPortal then
			return false
		end
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			humanoid:EquipTool(portalPortal)
		end

		local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
		local gateway = playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Gateway")
		if not gateway then
			return false
		end
		VirtualInputManager:SendKeyEvent(true, "C", false, game)
		VirtualInputManager:SendKeyEvent(false, "C", false, game)
		local n9 = tick() + 3

		while true do
			task.wait(0.1)
			if not (gateway.Visible or tick() > n9) then
				continue
			end
			break
		end

		if not gateway.Visible then
			return false
		end
		local mainContent = gateway:FindFirstChild("MainContent")
		if not mainContent then
			return false
		end
		local v_8 = mainContent.ScrollingFrame:FindFirstChild(tostring(arg))

		if v_8 and v_8.MouseButton1Click then
			for _, v_9 in pairs(getconnections(v_8.MouseButton1Click)) do
				pcall(function()
					v_9.Function()
				end)
			end

			return true
		end

		return false
	end

	local vector = Vector3.new(28282.57, 14896.851, 105.10427)

	local function fn6()
		local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		return humanoidRootPart2 ~= nil and (humanoidRootPart2.Position - vector).Magnitude < 1000
	end

	BorrowTempleOfTime = function()
		local templeOfTime = game.ReplicatedStorage.MapStash:FindFirstChild("Temple of Time")
		if not templeOfTime then
			return
		end
		templeOfTime:SetAttribute("ClientBorrowed", true)
		templeOfTime.Parent = workspace.Map

		task.spawn(function()
			local n9 = tick() + 30

			while true do
				task.wait(0.25)
				if not (templeOfTime.Parent ~= workspace.Map or fn6() or tick() > n9) then
					continue
				end
				break
			end

			templeOfTime:SetAttribute("ClientBorrowed", nil)

			if not fn6() and templeOfTime.Parent == workspace.Map then
				templeOfTime.Parent = game.ReplicatedStorage.MapStash
			end
		end)
	end

	GetTempleOfTime = function()
		local templeOfTime = workspace.Map:FindFirstChild("Temple of Time")
		if templeOfTime and not templeOfTime:GetAttribute("ClientBorrowed") then
			return templeOfTime
		end
	end

	local flag2 = false

	getgenv().IsPlayerDead = function()
		if not localPlayer.Character or not localPlayer.Character:FindFirstChild("Humanoid") or localPlayer.Character.Humanoid.Health == 0 then
			return true
		end
	end

	CS = game:GetService("CollectionService")
	cam = workspace.CurrentCamera

	LoadIslandByFakePoint = function(arg)
		local part = Instance.new("Part")
		part.Transparency = 1
		part.CanCollide = false
		part.Anchored = true
		part.Size = Vector3.zero
		part.CFrame = CFrame.new(arg:GetPivot().Position)
		CS:AddTag(part, "LoDPosition")
		part.Parent = cam
		return part
	end

	spawn(function()
		pcall(function()
			for _, child in ipairs(workspace:GetChildren()) do
				if child:IsA("Model") and child:GetAttribute("LevelOfDetailDiameter") then
					LoadIslandByFakePoint(child)
				end
			end

			for _, child in ipairs(workspace.Map:GetChildren()) do
				if child:IsA("Model") then
					LoadIslandByFakePoint(child)
				end
			end

			for _, child in ipairs(game:GetService("ReplicatedStorage").FakeIslands:GetChildren()) do
				if child:IsA("Model") then
					LoadIslandByFakePoint(child)
				end
			end
		end)
	end)

	getgenv().TweenGuidePart = nil
	getgenv().TweenConnection = nil
	getgenv().TweenInProgress = false
	getgenv().lastTarget = nil

	local function fn7(arg)
		if not arg then
			return nil
		end
		local locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")
		if not locations then
			return nil
		end
		local v_8 = nil
		local v_9 = nil

		for _, child in ipairs(locations:GetChildren()) do
			if child:IsA("BasePart") and not child:GetAttribute("IgnoreInTracking") then
				local magnitude = (child.Position - arg).Magnitude

				if not v_8 or magnitude < v_8 then
					v_8 = magnitude
					v_9 = child
				end
			end
		end

		return v_9
	end

	local function fn8(arg)
		if not arg then
			return nil
		end
		local v_8 = fn7(arg)
		if not v_8 then
			return nil
		end
		local mesh = v_8:FindFirstChild("Mesh")

		if mesh then
			if (v_8.Position - arg).Magnitude <= mesh.Scale.X / 2 then
				return v_8
			end
			return nil
		end

		return v_8
	end

	DetectNpcOni = function()
		local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end
		local v_8 = next
		local tbl15 = {}
		local npCs = workspace.NPCs
		local npCs2 = game:GetService("ReplicatedStorage").NPCs
		tbl15[1] = npCs
		tbl15[2] = npCs2
		local huge = math.huge
		local v_9 = nil

		for _, v_10 in v_8, tbl15, nil do
			local v_11 = next
			local children, v_12 = v_10:GetChildren()

			for _, v_13 in v_11, children, v_12 do
				if v_13:GetAttribute("NPCLoaded") and v_13:GetAttribute("NPCReady") and v_13:GetAttribute("DisplayName") == "Celestial Member" and v_13:FindFirstChild("HumanoidRootPart") then
					local magnitude = (humanoidRootPart2.Position - v_13.HumanoidRootPart.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v_9 = v_13
					end
				end
			end
		end

		return v_9, huge
	end

	CelestialDomainController = nil

	pcall(function()
		CelestialDomainController = v_2(game:GetService("ReplicatedStorage").Controllers.MapServices.CelestialDomainController)
	end)

	LocalPlayer = localPlayer
	ReplicatedStorage = game:GetService("ReplicatedStorage")
	WorldOrigin = workspace:WaitForChild("_WorldOrigin", 10)
	travelFunctions = {}
	PlayerSpawnsLot = {}
	BypassTpLocation = {}
	PlrData = game:GetService("Players").LocalPlayer.Data
	localPlayerFunctions = {}

	localPlayerFunctions.IsAlive = function()
		local character = LocalPlayer.Character
		if not character then
			return false
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return false
		end
		return humanoid.Health > 0
	end

	getHRP = function()
		local character = LocalPlayer.Character
		if not character then
			return nil
		end
		return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	end

	travelFunctions.GetDistance = function(arg, arg2)
		if not localPlayerFunctions.IsAlive() then
			return math.huge
		end

		if not arg2 then
			local v_8 = getHRP()
			if not v_8 then
				return math.huge
			end
			arg2 = v_8.Position
		end

		return (arg - arg2).Magnitude
	end

	travelFunctions.LoadBypassTPLocation = function()
		table.clear(PlayerSpawnsLot)
		table.clear(BypassTpLocation)
		local playerSpawns = WorldOrigin:FindFirstChild("PlayerSpawns")
		local locations = WorldOrigin:FindFirstChild("Locations")
		if not playerSpawns or not locations then
			return
		end

		for _, child in ipairs(playerSpawns:GetChildren()) do
			for _, child2 in ipairs(child:GetChildren()) do
				if child2:IsA("Model") then
					table.insert(PlayerSpawnsLot, { child2.Name, child2:GetModelCFrame() })
				end
			end

			child.ChildAdded:Connect(function(child2)
				task.wait()

				if child2:IsA("Model") then
					table.insert(PlayerSpawnsLot, { child2.Name, child2:GetModelCFrame() })
				end
			end)
		end

		local function fn9(arg)
			if not arg:IsA("BasePart") then
				return
			end
			BypassTpLocation[arg.Name] = {}
			local specialMesh = arg:FindFirstChildWhichIsA("SpecialMesh")
			local n9 = arg.Size.X * (specialMesh and specialMesh.Scale.X or 1) / 2

			for _, v_8 in ipairs(PlayerSpawnsLot) do
				if (v_8[2].Position - arg.Position).Magnitude <= n9 then
					table.insert(BypassTpLocation[arg.Name], v_8)
				end
			end
		end

		for _, child in ipairs(locations:GetChildren()) do
			fn9(child)
		end

		locations.ChildAdded:Connect(function(child)
			task.wait(3)
			fn9(child)
		end)
	end

	travelFunctions.GetTPLocation = function(arg)
		local locations = WorldOrigin:FindFirstChild("Locations")
		if not locations then
			return nil
		end
		local huge = math.huge
		local v_8 = nil

		for _, child in ipairs(locations:GetChildren()) do
			local v_9 = BypassTpLocation[child.Name]

			if v_9 then
				local specialMesh = child:FindFirstChildWhichIsA("SpecialMesh")

				if child.Size.X * (specialMesh and specialMesh.Scale.X or 1) / 2 >= travelFunctions.GetDistance(arg, child.Position) then
					for _, v_10 in ipairs(v_9) do
						local v_11 = travelFunctions.GetDistance(arg, v_10[2].Position)

						if v_11 < huge then
							v_8 = v_10[1]
							huge = v_11
						end
					end
				end
			end
		end

		return v_8
	end

	travelFunctions.TweenBypass = function(arg, arg2)
		local n9 = arg2 or 0
		if n9 >= 5 then
			return
		end

		local ok, result = pcall(function()
			if not arg then
				return
			end

			if not next(BypassTpLocation) then
				travelFunctions.LoadBypassTPLocation()
			end

			local character = LocalPlayer.Character
			if not character then
				return
			end

			if not getHRP() then
				return
			end
			local tbl15 = {}

			for _, v_8 in pairs(BypassTpLocation) do
				for _, v_9 in ipairs(v_8) do
					if not table.find(tbl15, v_9[2]) then
						table.insert(tbl15, v_9[2])
					end
				end
			end

			if #tbl15 == 0 then
				return
			end

			table.sort(tbl15, function(arg3, arg4)
				local position = arg4.Position
				return travelFunctions.GetDistance(arg3.Position, arg.Position) < travelFunctions.GetDistance(position, arg.Position)
			end)

			local lastSpawnPoint = character:FindFirstChild("LastSpawnPoint")

			if lastSpawnPoint then
				lastSpawnPoint.Disabled = true
			end

			task.wait()

			for _, v_8 in ipairs(tbl15) do
				local v_9 = travelFunctions.GetTPLocation(v_8.Position)

				if v_9 then
					local v_10 = travelFunctions.GetDistance(v_8.Position, arg.Position)

					if travelFunctions.GetDistance(arg.Position) > v_10 + 500 and travelFunctions.GetDistance(v_8.Position) >= 1000 then
						CommF:InvokeServer("SetLastSpawnPoint", v_9)

						if PlrData.LastSpawnPoint.Value == v_9 then
							character.Humanoid.Health = 0

							repeat
								task.wait()
							until localPlayerFunctions.IsAlive()

							if lastSpawnPoint then
								lastSpawnPoint.Disabled = false
							end

							travelFunctions.TweenBypass(arg, n9 + 1)
							return true
						end
					end
				end
			end

			if lastSpawnPoint then
				lastSpawnPoint.Disabled = false
			end
		end)

		if not ok then
			warn("[TweenBypass ERROR]:", result)
		end

		return false
	end

	ShouldResetTeleportSmart = function(arg)
		if not Settings["Reset Teleport"] then
			return false
		end

		if flag2 or ReadyToDodge then
			return false
		end
		local v_8 = getHRP()
		if not v_8 then
			return false
		end
		local v_9 = fn8(arg.Position)
		local v_10 = fn8(v_8.Position)
		if not v_9 then
			return true
		end

		if v_10 and v_9 and v_10.Name == v_9.Name then
			return false
		end
		return true
	end

	task.spawn(function()
		travelFunctions.LoadBypassTPLocation()
	end)

	BypassTp = travelFunctions

	local function fn9(parent)
		if not parent or parent:FindFirstChild("FloatForce") then
			return
		end
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "FloatForce"
		bodyVelocity.Velocity = Vector3.zero
		bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
		bodyVelocity.P = 10000
		bodyVelocity.Parent = parent
	end

	RunService = game:GetService("RunService")
	tbl3 = { LastTP = 0, LastCF = nil, ActiveConnection = nil, LastCall = 0 }
	local n9 = 40

	local function fn10()
		local charSpeed = getgenv().CharSpeed

		if not charSpeed then
			local charSpeed2 = { cap = 1000, nextRaise = 0 }
			getgenv().CharSpeed = charSpeed2
			charSpeed = charSpeed2
		end

		return charSpeed
	end

	local function fn11(currentPart, lastCF, arg, arg2)
		if tick() - (getgenv().LastToggleCancelTime or 0) < 0.8 then
			return
		end

		if not currentPart or typeof(lastCF) ~= "CFrame" then
			return
		end
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not character or currentPart.Parent ~= character or not humanoid or humanoid.Health <= 0 then
			return
		end

		if currentPart.Anchored then
			pcall(function()
				currentPart.Anchored = false
			end)
		end

		local lastTP = tbl3.LastTP
		if tick() - lastTP < 1 and lastCF == tbl3.LastCF then
			return
		end
		TweenManager.CancelTweenOnly()

		if tbl3.ActiveConnection and coroutine.status(tbl3.ActiveConnection) == "suspended" then
			pcall(coroutine.close, tbl3.ActiveConnection)
		end

		local n10 = math.max(tonumber(arg) or 350, 1)
		local n11 = tonumber(arg2) or 2.5
		tbl3.LastTP = tick()
		tbl3.LastCF = lastCF
		local flag3 = false
		local thread = nil
		local currentTween = {}

		local function fn12()
			if tbl3.ActiveConnection == thread then
				tbl3.ActiveConnection = nil
			end

			if TweenManager.currentTween == currentTween then
				TweenManager.currentTween = nil
				TweenManager.currentPart = nil
				TweenManager.currentGoal = nil
				TweenManager.TweenRunning = false
			end

			if getgenv().Tween == currentTween then
				getgenv().Tween = nil
			end
		end

		currentTween.Pause = function()
			flag3 = true

			if thread and coroutine.status(thread) == "suspended" then
				pcall(coroutine.close, thread)
			end
		end

		currentTween.Cancel = function(arg3)
			arg3:Pause()
			fn12()
		end

		currentTween.Destroy = function(arg3)
			arg3:Cancel()
		end

		thread = coroutine.create(function()
			local position = currentPart.Position
			local position2 = lastCF.Position
			local magnitude = (position2 - position).Magnitude
			local now = tick()
			local huge = math.huge
			local flag4 = true
			local v_8 = nil
			local n12

			while not flag3 do
				local character2 = localPlayer.Character
				local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")

				if not (character2 ~= character or currentPart.Parent ~= character2 or not humanoid2 or humanoid2.Health <= 0 or currentPart.Anchored or magnitude <= n11) then
					local result = RunService.Heartbeat:Wait()
					local v_9 = fn10()
					local position3 = currentPart.Position
					local magnitude2 = (position2 - position3).Magnitude

					if magnitude2 < huge - 5 then
						now = tick()
						huge = magnitude2
					elseif tick() - now > 2.5 then
						flag4 = false
					end

					if flag4 and n12 and v_8 and magnitude2 > v_8 + n9 then
						v_9.cap = math.max(v_9.cap * 0.7, 120)
						v_9.nextRaise = tick() + 3
					elseif not (flag4 and n12 and (position3 - n12).Magnitude > n9) then
						position3 = position
					end

					local n13 = position2 - position3
					local magnitude3 = n13.Magnitude
					local n14 = math.min(math.min(n10, v_9.cap) * result, 18)
					local flag5 = magnitude3 > n14

					if flag5 then
						local nextRaise = v_9.nextRaise
						flag5 = tick() >= nextRaise
					end

					if flag5 then
						v_9.cap = math.min(v_9.cap * 1.08, n10)
						v_9.nextRaise = tick() + 1.5
					end

					if magnitude3 <= n14 or magnitude3 <= 0.05 then
						n12 = position2
					else
						n12 = position3 + n13 / magnitude3 * n14
					end

					magnitude = (position2 - n12).Magnitude
					fn3()
					getgenv().noclip = true
					currentPart.CFrame = CFrame.new(n12)
					currentPart.AssemblyLinearVelocity = Vector3.zero
					currentPart.AssemblyAngularVelocity = Vector3.zero
					v_8 = magnitude2
					position = n12
					continue
				end

				break
			end

			if not flag3 and currentPart.Parent == localPlayer.Character and (position2 - currentPart.Position).Magnitude <= n11 then
				currentPart.CFrame = lastCF
				currentPart.AssemblyLinearVelocity = Vector3.zero
				currentPart.AssemblyAngularVelocity = Vector3.zero
			end

			fn12()
		end)

		tbl3.ActiveConnection = thread
		TweenManager.currentTween = currentTween
		TweenManager.currentPart = currentPart
		TweenManager.currentGoal = lastCF
		TweenManager.TweenRunning = true
		getgenv().Tween = currentTween
		if not coroutine.resume(thread) then
			currentTween:Cancel()
			return
		end
		return currentTween
	end

	toTarget = function(arg)
		local v_8 = table.pack(tick())
		local v_9 = table.pack(getgenv())
		local v_10, lastToggleCancelTime

		if (v_9[1]).LastToggleCancelTime then
			v_10 = v_8[1]
			lastToggleCancelTime = (v_9[1]).LastToggleCancelTime
		else
			v_10 = v_8[1]
			lastToggleCancelTime = 0
		end

		if v_10 - lastToggleCancelTime < 0.8 then
			return
		end

		if typeof(arg) ~= "CFrame" then
			return
		end
	end

	local v_8 = toTarget
	getgenv().BackupTween = v_8

	spawn(function()
		while wait(0.25) do
			local ok, result = pcall(function()
				if notsave["Teleport To Island"] then
					for k, v_9 in next, tbl12, nil do
						if k == notsave["Select Island"] then
							toTarget(v_9)
						end
					end
				end

				if notsave["Teleport To Npc"] then
					for _, v_9 in next, tbl11, nil do
						if v_9.Name == notsave["Select Npc"] then
							toTarget(v_9.HumanoidRootPart.CFrame)
						end
					end
				end

				if notsave["Teleport Mirage"] then
					if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
						local v_9 = DetectNpc("Advanced Fruit Dealer")
						if not v_9 or not v_9:FindFirstChild("HumanoidRootPart") then
							return
						end

						if v_9 then
							toTarget(v_9.HumanoidRootPart.CFrame)
							return
						end
					end
				end

				if notsave["Teleport Prehistoric Island"] then
					if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
						local v_9 = DetectNpc("Fossil Expert")
						if not v_9 or not v_9:FindFirstChild("HumanoidRootPart") then
							return
						end

						if v_9 then
							toTarget(v_9.HumanoidRootPart.CFrame)
							return
						end
					end
				end

				if Settings["Auto rejoin Disconnect"] then
					if not string.find(game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ErrorMessage.Text, "Teleport") then
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
					end
				end
			end)

			if result then
				print(result)
			end
		end
	end)
end

equiptool = function(arg)
	local character = localPlayer.Character
	character = character and character:FindFirstChildOfClass("Humanoid")

	if arg and localPlayer:FindFirstChild("Backpack") and localPlayer.Backpack:FindFirstChild(arg) and character and not character.Sit then
		character:EquipTool(localPlayer.Backpack:FindFirstChild(arg))
	end
end

NameWeapon = function(arg, arg2)
	local function fn(arg3)
		if not arg3 then
			return nil
		end
		local v_5 = next
		local children, v_6 = arg3:GetChildren()

		for _, v_7 in v_5, children, v_6 do
			if v_7:IsA("Tool") and v_7.ToolTip == arg then
				local v_8 = arg2
				local name

				if arg2 then
					name = v_7
				else
					name = v_8
				end

				name = name or v_7.Name
				return name
			end
		end
	end

	local backpack = localPlayer:FindFirstChild("Backpack")
	local character = localPlayer.Character
	return backpack and fn(backpack) or character and fn(character)
end

local v_5

do
	local v_6 = nil
	v_5 = nil
	local v_7 = nil
	local reRegisterAttack = nil
	local RegisterHit = nil

	local function fn()
		if v_5 and typeof(v_5) == "table" and (rawget(v_5, "GetRigOfHitPart") or v_5.GetRigOfHitPart) then
			return v_5
		end

		pcall(function()
			v_5 = v_2(game:GetService("ReplicatedStorage").Modules.CombatUtil)
		end)

		return v_5
	end

	pcall(function()
		v_6 = v_2(game:GetService("ReplicatedStorage").Mouse)
		fn()
		v_7 = v_2(game:GetService("ReplicatedStorage").Modules.Net)
		reRegisterAttack = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RE/RegisterAttack", 5)

		if v_7 then
			RegisterHit = v_7:RemoteEvent("RegisterHit", true)
		end
	end)

	local function fn2(arg, arg2, arg3)
		local tbl4 = {}

		for _, child in pairs(arg:GetChildren()) do
			if child:IsA("BasePart") and (child.Position - arg2).Magnitude <= arg3 then
				table.insert(tbl4, child)
			end
		end

		return tbl4
	end

	local function fn3(arg)
		local tbl4 = {}
		local v_8 = pairs
		local enemies = game:GetService("Workspace"):WaitForChild("Enemies")

		for _, child in v_8(enemies:GetChildren()) do
			table.insert(tbl4, child)
		end

		if arg then
			local v_9 = pairs
			local characters = game:GetService("Workspace"):WaitForChild("Characters")

			for _, child in v_9(characters:GetChildren()) do
				table.insert(tbl4, child)
			end
		end

		return tbl4
	end

	getgenv().getBladeHits = function(arg, arg2, arg3, arg4)
		local tbl4 = {}

		for _, v_8 in pairs(fn3(arg4)) do
			if v_8:IsDescendantOf(Workspace) and v_8 ~= arg and v_8:FindFirstChild("HumanoidRootPart") then
				local humanoidRootPart2 = v_8.HumanoidRootPart
				local n3 = Players:GetPlayerFromCharacter(v_8) and arg3 / 1.5 or arg3
				local tbl5 = { humanoidRootPart2.Position }

				if humanoidRootPart2.Size.Y > 5 then
					table.insert(tbl5, (humanoidRootPart2.CFrame * CFrame.new(0, -humanoidRootPart2.Size.Y * 1.5 + 3, 0)).Position)
				end

				local exitTo = nil

				for _, v_9 in pairs(tbl5) do
					if (v_9 - arg2[1].Position).Magnitude < 10 + n3 + humanoidRootPart2.Size.X / 2 then
						exitTo = 1
						break
					end
				end

				if exitTo == 1 then
					for _, v_9 in pairs(fn2(v_8, arg2[1].Position, n3 + humanoidRootPart2.Size.X / 2)) do
						table.insert(tbl4, v_9)
					end
				end
			end
		end

		return tbl4
	end

	local tbl4 = {
		RightUpperArm = true,
		RightLowerArm = true,
		RightHand = true,
		RightUpperLeg = true,
		RightLowerLeg = true,
		RightFoot = true,
		LeftUpperArm = true,
		LeftLowerArm = true,
		LeftHand = true,
		LeftUpperLeg = true,
		LeftLowerLeg = true,
		LeftFoot = true,
		UpperTorso = true,
		LowerTorso = true,
		Head = true,
	}

	AttackAOE = function(arg, arg2)
		local v_8 = fn()
		if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
			return
		end
		local tbl5 = {}
		local tbl6 = {}
		local getBladeHits = getgenv().getBladeHits
		local character = localPlayer.Character
		local tbl7 = { localPlayer.Character.HumanoidRootPart }
		arg = arg or 80

		for k, v_9 in getBladeHits(character, tbl7, arg, arg2) do
			if v_8 and v_8.GetRigOfHitPart then
				local ok, result = pcall(function()
					return v_8:GetRigOfHitPart(v_9)
				end)

				k = ok and result or nil
			end

			if not k and v_9 and v_9.Parent then
				local parent = v_9.Parent

				while true do
					if parent and parent ~= workspace then
						if parent:FindFirstChildOfClass("Humanoid") then
							k = parent
							break
						else
							parent = parent.Parent
							continue
						end
					end

					break
				end
			end

			local result

			if v_8 and v_8.IsVulnerable then
				local ok

				ok, result = pcall(function()
					return v_8:IsVulnerable(k)
				end)

				result = ok and result
			else
				result = k and k:FindFirstChildOfClass("Humanoid") and k.Humanoid.Health > 0
			end

			result = k and not tbl6[k] and tbl4[v_9.Name] and result

			if result then
				local summoner = k:FindFirstChild("Summoner")
				local summoner2 = localPlayer.Character:FindFirstChild("Summoner")

				if k ~= localPlayer.Character and (not summoner2 or k ~= summoner2.Value.Character) and (not Players:GetPlayerFromCharacter(localPlayer.Character) or not summoner or summoner.Value ~= Players:GetPlayerFromCharacter(localPlayer.Character)) then
					table.insert(tbl5, { k, v_9 })
					tbl6[k] = true
				end
			end
		end

		return #tbl5 > 0 and tbl5 or nil
	end

	v_u_27 = 0
	v_u_28 = false
	v_u_33 = false
	v_u_31 = nil
	v_u_32 = 0
	v_u_21 = 0
	v_u_16 = 1

	pcall(function()
		CameraShakerMain = v_2(game:GetService("ReplicatedStorage").Util.CameraShaker.Main)
	end)

	pcall(function()
		CameraShaker = v_2(game:GetService("ReplicatedStorage").Util.CameraShaker)
	end)

	attackMelee = function(arg)
		local v_8 = fn()
		if not v_8 then
			return
		end
		local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		if not tool then
			return
		end
		local v_9 = AttackAOE(arg, false)
		if not v_9 then
			return
		end
		local humanoid = game.Players.LocalPlayer.Character.Humanoid
		local rootPart = humanoid and humanoid.RootPart
		rootPart = rootPart and rootPart.Parent
		local movesetAnimCache = v_8:GetMovesetAnimCache(humanoid)

		if movesetAnimCache then
			local weaponName = v_8:GetWeaponName(tool)
			local weaponData = v_8:GetWeaponData(weaponName)
			local moveset = weaponData.Moveset

			if v_8:CanAttack(rootPart, weaponData.WeaponType) then
				v_u_33 = true
				v_u_32 = 5
				v_u_21 = os.clock()
				v_u_27 = v_u_27 + 1

				if #moveset.Basic < v_u_27 then
					v_u_27 = 1
				end

				local v_10 = movesetAnimCache[v_8:GetPureWeaponName(weaponName) .. "-basic" .. v_u_27]
				reRegisterAttack:FireServer(v_10.Length / (v_10:GetAttribute("SpeedMult") or 1))
				RegisterHit:FireServer(table.remove(v_9, 1)[2], v_9)
				v_10:Play(0.100000001, 1, 1 * (v_10:GetAttribute("SpeedMult") or 1))
				v_u_28 = true

				task.delay(v_10.Length / (v_10:GetAttribute("SpeedMult") or 1) * v_u_16, function()
					v_u_28 = false
				end)

				v_u_31 = v_10
				table.clear(v_9)
			end
		end
	end

	AttackFunction = function(arg)
		if localPlayer.Character.Stun.Value ~= 0 then
			return
		end

		if not Settings["Attack No Animation "] then
			attackMelee(arg)
		else
			local v_8 = AttackAOE(arg, false)
			if not v_8 then
				return
			end
			reRegisterAttack:FireServer(0)
			RegisterHit:FireServer(table.remove(v_8, 1)[2], v_8)
			table.clear(v_8)
		end
	end

	getgenv().AttackFunctionnhungSuperTrial = function()
		if localPlayer.Character.Stun.Value ~= 0 then
			return
		end
		local v_8 = AttackAOE(80, true)
		if not v_8 then
			return
		end
		reRegisterAttack:FireServer(0)
		RegisterHit:FireServer(table.remove(v_8, 1)[2], v_8)
		table.clear(v_8)
	end

	getgenv().AttackFunctionnhungSuper = getgenv().AttackFunctionnhungSuperTrial

	pcall(function()
		v_6 = v_2(game:GetService("ReplicatedStorage").Mouse)
	end)

	v_u_50 = nil
	v_u_51 = 1
	v_u_52 = time
	v_u_53 = v_u_52()

	local function fn4(arg, arg2, arg3)
		local character = localPlayer.Character
		local primaryPart = character and (character.PrimaryPart or character:FindFirstChild("HumanoidRootPart"))
		if not primaryPart or not arg then
			return false
		end
		local position = arg3 and arg.Position or arg.PrimaryPart and arg.PrimaryPart.Position
		if not position then
			return false
		end
		local unit = (position - primaryPart.Position).Unit
		local unit2 = ((v_6.Hit.Position - primaryPart.Position) * Vector3.new(1, 0, 1)).Unit
		local v_8 = NameWeapon("Blox Fruit")
		local v_9 = v_8 and character:FindFirstChild(v_8)
		if not v_9 then
			return false
		end
		local leftClickRemote = v_9:FindFirstChild("LeftClickRemote")
		local remoteFunction = v_9:FindFirstChild("RemoteFunction")
		local remoteEvent = v_9:FindFirstChild("RemoteEvent")

		if not leftClickRemote and remoteFunction then
			if remoteEvent then
				remoteEvent:FireServer(position)
			end

			remoteFunction:InvokeServer("TAP")
			return true
		end

		if leftClickRemote and v_8 == "Mammoth-Mammoth" then
			leftClickRemote:FireServer(position)
			return true
		end

		if leftClickRemote then
			v_u_51 = v_u_51 + 1

			if v_u_51 > 5 then
				v_u_51 = 1
			end

			leftClickRemote:FireServer(unit, v_u_51)

			if arg2 then
				leftClickRemote:FireServer(unit2, v_u_51)
			end

			return true
		end

		return false
	end

	getgenv().UseFruitM1 = function(arg, arg2)
		return fn4(arg, arg2, false)
	end

	getgenv().UseFruitM1Boat = function(arg, arg2)
		return fn4(arg, arg2, true)
	end
end

getgenv().PathClickM1 = {}

local function fn(character)
	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			task.wait(0.5)
			local remoteFunction = child:FindFirstChild("RemoteFunction")

			if remoteFunction then
				local name = child.Name
				getgenv().PathClickM1[name] = remoteFunction
			end
		end
	end)
end

if localPlayer.Character then
	fn(localPlayer.Character)
end

localPlayer.CharacterAdded:Connect(fn)

local function fn2(arg)
	return localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and arg and arg:FindFirstChild("HumanoidRootPart") and arg:FindFirstChild("Humanoid") and arg.Humanoid.Health > 0 and (localPlayer.Character.HumanoidRootPart.Position - arg.HumanoidRootPart.Position).Magnitude < 70
end

getgenv().ClickM1 = function(arg, arg2)
	if not (nil)(arg) then
		return
	end

	if Settings["Select Weapon"] == "Blox Fruit" then
		if getgenv().UseFruitM1(arg) then
			return
		end
	end

	local v_6

	if arg2 then
		arg2 = 80
		v_6 = AttackFunction
	else
		v_6 = AttackFunction
	end

	v_6(arg2 or 30)
end

getgenv().ClickM1Dungeon = function(arg, arg2)
	if not fn2(arg) then
		return
	end

	if Settings["Select Weapon Dungeon"] == "Blox Fruit" then
		if getgenv().UseFruitM1(arg) then
			return
		end
	end

	AttackFunction(arg2 and 80 or 30)
end

getgenv().ClickM1Volcano = function(arg, arg2)
	if not fn2(arg) then
		return
	end

	if Settings["Select Weapon Kill Golem"] and Settings["Select Weapon Kill Golem"] == "Blox Fruit" then
		if getgenv().UseFruitM1(arg) then
			return
		end
	end

	AttackFunction(arg2 and 80 or 30)
end

local modules = ReplicatedStorage:WaitForChild("Modules")

getgenv().SpamGunDragonStorm = function(arg)
	local v_6 = v_2(modules.CombatUtil)
	local character = localPlayer.Character
	character = character and character:FindFirstChild("Dragonstorm")
	if not character or v_6:IsGunReloading(character) then
		return
	end
	local v_7 = getupvalues(v_2(ReplicatedStorage.Controllers.CombatController).Attack)[9]
	if not v_7 then
		return
	end
	local v_8 = debug.getupvalue(v_7, 15)
	local v_9 = debug.getupvalue(v_7, 13)
	local v_10 = debug.getupvalue(v_7, 16)
	local v_11 = debug.getupvalue(v_7, 17)
	local v_12 = debug.getupvalue(v_7, 14)
	local v_13 = debug.getupvalue(v_7, 12)
	local v_14 = debug.getupvalue(v_7, 18)
	if not v_8 or not v_9 or not v_10 or not v_11 or not v_12 or not v_13 or not v_14 then
		return
	end
	local n3 = ((v_12 * v_9 + v_13 * v_8) % v_10 * v_10 + v_13 * v_9) % v_11
	local n4 = math.floor(n3 / v_10)
	local n5 = v_14 + 1
	debug.setupvalue(v_7, 15, v_8)
	debug.setupvalue(v_7, 13, v_9)
	debug.setupvalue(v_7, 16, v_10)
	debug.setupvalue(v_7, 17, v_11)
	debug.setupvalue(v_7, 14, n4)
	debug.setupvalue(v_7, 12, n3 - n4 * v_10)
	debug.setupvalue(v_7, 18, n5)
	ReplicatedStorage.Remotes.Validator2:FireServer(math.floor(n3 / v_11 * 16777215), n5)
	local net = modules:FindFirstChild("Net")
	net = net and net:FindFirstChild("RE/ShootGunEvent")

	if net then
		net:FireServer(arg.Position, { arg })
	end
end

ShootM1 = function(arg)
	spawn(function()
		if not v_2(game:GetService("ReplicatedStorage").Modules.CombatUtil):IsGunReloading(localPlayer.Character[NameWeapon("Gun")]) then
			if NameWeapon("Gun") ~= "Skull Guitar" then
				local v_6 = getupvalues(v_2(game:GetService("ReplicatedStorage").Controllers.CombatController).Attack)[9]
				local v_7 = debug.getupvalue(v_6, 15)
				local v_8 = debug.getupvalue(v_6, 13)
				local v_9 = debug.getupvalue(v_6, 16)
				local v_10 = debug.getupvalue(v_6, 17)
				local v_11 = debug.getupvalue(v_6, 14)
				local v_12 = debug.getupvalue(v_6, 12)
				local v_13 = debug.getupvalue(v_6, 18)
				local n3 = ((v_11 * v_8 + v_12 * v_7) % v_9 * v_9 + v_12 * v_8) % v_10
				local n4 = math.floor(n3 / v_9)
				local n5 = v_13 + 1
				debug.setupvalue(v_6, 15, v_7)
				debug.setupvalue(v_6, 13, v_8)
				debug.setupvalue(v_6, 16, v_9)
				debug.setupvalue(v_6, 17, v_10)
				debug.setupvalue(v_6, 14, n4)
				debug.setupvalue(v_6, 12, n3 - n4 * v_9)
				debug.setupvalue(v_6, 18, n5)
				game.ReplicatedStorage.Remotes.Validator2:FireServer(math.floor(n3 / v_10 * 16777215), n5)

				if NameWeapon("Gun") == "Cannon" then
					game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RE/ShootGunEvent"):FireServer(unpack({ arg }))
				else
					local tbl4 = { arg.HumanoidRootPart.Position, { arg.HumanoidRootPart } }
					game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RE/ShootGunEvent"):FireServer(unpack(tbl4))
				end

				task.wait(localPlayer.Character[NameWeapon("Gun")].Cooldown.Value)
			else
				local tbl4 = { "TAP", arg.HumanoidRootPart.Position }
				game:GetService("Players").LocalPlayer.Character:FindFirstChild("Skull Guitar").RemoteEvent:FireServer(unpack(tbl4))
				task.wait(localPlayer.Character[NameWeapon("Gun")].Cooldown.Value)
			end
		end
	end)
end

getgenv().SpamGunSkullGuitar = function(arg)
	local v_6 = v_2(modules.CombatUtil)
	local character = localPlayer.Character
	character = character and character:FindFirstChild("Skull Guitar")
	if not character or v_6:IsGunReloading(character) then
		return
	end

	if character:FindFirstChild("RemoteEvent") then
		character.RemoteEvent:FireServer("TAP", arg.Position)
	end
end

local v_6, cFrame, flag, v_7

local function fn3(arg, arg2)
	local v_8 = v_2(game:GetService("ReplicatedStorage").Modules.CombatUtil)
	local character = arg.Character
	local tbl4 = { arg.Character.HumanoidRootPart }
	local huge = math.huge
	local v_9 = nil
	local v_10 = nil

	for _, v_11 in getgenv().getBladeHits(character, tbl4, arg2, true) do
		local rigOfHitPart = v_8:GetRigOfHitPart(v_11)

		if rigOfHitPart and v_8:IsVulnerable(rigOfHitPart) then
			local magnitude = (arg.Character.HumanoidRootPart.Position - v_11.Position).Magnitude

			if magnitude < huge then
				huge = magnitude
				v_9 = rigOfHitPart
				v_10 = v_11
			end
		end
	end

	if v_9 and v_10 then
		return { v_9, v_10 }
	end
	return nil
end

DetectItemPlr = function(arg)
	local character = localPlayer.Character
	if character and character:FindFirstChild(arg) then
		return true
	end
	local backpack = localPlayer:FindFirstChild("Backpack")
	if backpack and backpack:FindFirstChild(arg) then
		return true
	end
	return false
end

sizepart = function(arg)
	AttackingMob = arg
	if not arg or not arg.Parent or not arg:FindFirstChild("HumanoidRootPart") then
		return
	end

	if localPlayer:DistanceFromCharacter(arg.HumanoidRootPart.Position) <= 50 then
		local v_8 = next
		local descendants, v_9 = arg:GetDescendants()

		for _, v_10 in v_8, descendants, v_9 do
			if (v_10:IsA("Part") or v_10:IsA("MeshPart")) and v_10.CanCollide then
				v_10.CanCollide = false
			end
		end
	end
end

v_6 = nil
cFrame = nil

DeleteIgnoredMob = function()
	for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
		if child:IsA("Model") and child:FindFirstChild("Ignored") then
			child.Ignored:Destroy()
		end
	end
end

DetectMob = function(arg)
	local match = typeof(arg) == "string" and arg:gsub(" %p?Lv%.? %d+%p?", ""):match("^%s*(.-)%s*$") or arg
	local huge = math.huge
	local v_8 = nil

	for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
		local match2 = child.Name:gsub(" %p?Lv%.? %d+%p?", ""):match("^%s*(.-)%s*$")
		local flag2

		if typeof(arg) == "table" then
			flag2 = table.find(arg, child.Name) or table.find(arg, match2)
		else
			flag2 = false

			if typeof(arg) == "string" then
				flag2 = child.Name == arg or match2 == match or match ~= "" and (string.find(child.Name, match, 1, true) ~= nil or string.find(match2, match, 1, true) ~= nil or string.find(match, match2, 1, true) ~= nil)
			end
		end

		flag2 = flag2 and IsMobAlive(child)

		if flag2 then
			local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			local humanoidRootPart3 = child:FindFirstChild("HumanoidRootPart")

			if not (not humanoidRootPart2 or not humanoidRootPart3) then
				local magnitude = (humanoidRootPart3.Position - humanoidRootPart2.Position).magnitude

				if magnitude < huge then
					huge = magnitude
					v_8 = child
				end
			end
		end
	end

	return v_8
end

CheckNameBoss = function(arg)
	local function fn4(arg2)
		if not arg2 then
			return false
		end
		local v_8 = string.lower(arg2)

		if typeof(arg) == "table" then
			for _, v_9 in pairs(arg) do
				if string.find(v_8, string.lower(tostring(v_9)), 1, true) then
					return true
				end
			end
		elseif typeof(arg) == "string" then
			if string.find(v_8, string.lower(arg), 1, true) then
				return true
			end
		end

		return false
	end

	local enemies = workspace:FindFirstChild("Enemies")

	if enemies then
		for _, child in ipairs(enemies:GetChildren()) do
			if fn4(child.Name) and IsMobAlive(child) then
				return child
			end
		end
	end

	local characters = workspace:FindFirstChild("Characters")

	if characters then
		for _, child in ipairs(characters:GetChildren()) do
			if fn4(child.Name) and IsMobAlive(child) then
				return child
			end
		end
	end

	for _, child in ipairs(workspace:GetChildren()) do
		if (child:IsA("Model") or child:IsA("Folder")) and fn4(child.Name) and IsMobAlive(child) then
			return child
		end
	end

	return nil
end

CheckBossServer = function(arg)
	local v_8 = CheckNameBoss(arg)
	if v_8 then
		return v_8
	end
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

	if ReplicatedStorage2 then
		local function fn4(arg2)
			if not arg2 then
				return false
			end
			local v_9 = string.lower(arg2)

			if typeof(arg) == "table" then
				for _, v_10 in pairs(arg) do
					if string.find(v_9, string.lower(tostring(v_10)), 1, true) then
						return true
					end
				end
			elseif typeof(arg) == "string" then
				if string.find(v_9, string.lower(arg), 1, true) then
					return true
				end
			end

			return false
		end

		for _, child in ipairs(ReplicatedStorage2:GetChildren()) do
			if fn4(child.Name) and IsMobAlive(child) then
				return child
			end
		end
	end

	return nil
end

getgenv().TableMobSpawn = {}

spawn(function()
	for _, v_8 in pairs(getnilinstances()) do
		local str

		if v_8:GetAttribute("DisplayName") and string.find(v_8:GetAttribute("DisplayName"), "Lv.") then
			str = v_8:GetAttribute("DisplayName"):gsub(" %pLv. %d+%p", "")
		else
			str = nil
		end

		if str then
			table.insert(TableMobSpawn, v_8)
		end
	end

	for _, child in pairs(game:GetService("Workspace")._WorldOrigin.EnemySpawns:GetChildren()) do
		local str

		if child:GetAttribute("DisplayName") and string.find(child:GetAttribute("DisplayName"), "Lv.") then
			str = child:GetAttribute("DisplayName"):gsub(" %pLv. %d+%p", "")
		else
			str = nil
		end

		if str then
			table.insert(TableMobSpawn, child)
		end
	end
end)

getcenter = function(arg)
	if string.find(arg, "Lv.") then
		name1 = arg:gsub(" %pLv. %d+%p", "")
	end

	local position = nil
	local n3 = 0

	for _, v_8 in pairs(TableMobSpawn) do
		local str

		if string.find(v_8.Name, "Lv.") then
			str = v_8.Name:gsub(" %pLv. %d+%p", "")
		else
			str = nil
		end

		local isPart = v_8:IsA("Part")

		if isPart then
			isPart = str and str == arg or arg == v_8.Name or name1 and v_8.Name == name1
		end

		if isPart then
			if position == nil then
				position = v_8.Position
				n3 += 1
			else
				position += v_8.Position
				n3 += 1
			end
		end
	end

	return CFrame.new(position / n3)
end

DetectPartMobBring = function(arg, arg2, arg3, arg4)
	local tbl4 = {}
	local str

	if string.find(arg, "Lv.") then
		str = arg:gsub(" %pLv. %d+%p", "")
	else
		str = nil
	end

	for _, v_8 in pairs(TableMobSpawn) do
		local str2

		if string.find(v_8.Name, "Lv.") then
			str2 = v_8.Name:gsub(" %pLv. %d+%p", "")
		else
			str2 = nil
		end

		if v_8:IsA("Part") and (str2 and str2 == arg or arg == v_8.Name or str and v_8.Name == str) then
			table.insert(tbl4, v_8)
		end
	end

	if arg3 then
		local huge = math.huge
		local v_8 = nil

		for _, v_9 in next, tbl4, nil do
			if not (not arg2 or not arg2:FindFirstChild("HumanoidRootPart")) then
				local magnitude = (arg2.HumanoidRootPart.Position - v_9.Position).Magnitude

				if huge > magnitude then
					huge = magnitude
					v_8 = v_9
				end
			end
		end

		return v_8
	end

	local tbl5 = {}

	for _, v_8 in next, tbl4, nil do
		if (arg4.Position - v_8.Position).Magnitude <= 200 then
			table.insert(tbl5, v_8)
		end
	end

	if #tbl5 < #tbl4 then
		return true
	end
end

isnetworkowner2 = function(arg)
	if not arg or not arg:IsA("BasePart") then
		return true
	end
	local characters = game.Workspace:FindFirstChild("Characters")
	if not characters then
		return true
	end

	for _, child in pairs(characters:GetChildren()) do
		if child.Name ~= localPlayer.Name then
			local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart2 and (humanoidRootPart2.Position - arg.Position).Magnitude <= 300 then
				return false
			end
		end
	end

	return true
end

BringMob = function(arg)
	if not Settings["Bring Mob"] then
		return
	end

	if not (arg and arg.Parent) then
		return
	end
	local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
	local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChild("Humanoid")
	if not humanoidRootPart2 or not humanoid or humanoid.Health <= 0 then
		return
	end

	if v_6 ~= arg then
		v_6 = arg
		local v_8 = DetectPartMobBring(arg.Name, arg, true)
		if not v_8 then
			return
		end
		cFrame = v_8.CFrame

		if game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" and localPlayer.Character and localPlayer.Character:FindFirstChild("RaceTransformed") and localPlayer.Character.RaceTransformed.Value then
			cFrame = getcenter(arg.Name)
		end

		DeleteIgnoredMob()
	end

	if DaBringMob then
		delay(0.1, function()
			getgenv().DaBringMob = false
		end)

		return
	end

	local tbl4 = {}

	if not arg:FindFirstChild("Ignored") then
		table.insert(tbl4, arg)
	end

	local bringMobCount = Settings["Bring Mob Count"] or 2
	local n3

	if bringMobCount > 2 then
		n3 = 350
	else
		n3 = 200
	end

	if game:GetService("Players").LocalPlayer.Data.Race.Value == "Cyborg" and localPlayer.Character:FindFirstChild("RaceTransformed") and localPlayer.Character.RaceTransformed.Value then
		n3 = 300
		bringMobCount = 6
	end

	local enemies = workspace:FindFirstChild("Enemies")

	if enemies and cFrame then
		for _, child in pairs(enemies:GetChildren()) do
			if child ~= arg and child.Name == arg.Name and not child:FindFirstChild("Ignored") and IsMobAlive(child) then
				local humanoidRootPart3 = child:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart3 and isnetworkowner2(humanoidRootPart3) then
					if (humanoidRootPart3.Position - cFrame.Position).Magnitude <= n3 and #tbl4 < bringMobCount then
						table.insert(tbl4, child)
					end
				end
			end
		end
	end

	local character = localPlayer.Character
	character = character and character:FindFirstChild("HumanoidRootPart")

	if cFrame and character and humanoidRootPart2 and (character.Position - humanoidRootPart2.Position).Magnitude <= 50 and isnetworkowner2(character) and #tbl4 >= 2 then
		for _, v_8 in pairs(tbl4) do
			if v_8 and v_8.Parent and IsMobAlive(v_8) then
				local humanoidRootPart3 = v_8:FindFirstChild("HumanoidRootPart")
				local humanoid2 = v_8:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart3 and humanoid2 and humanoid2:IsA("Humanoid") and humanoid2.Health > 0 then
					sizepart(v_8)

					if not isnetworkowner2(humanoidRootPart3) then
						humanoidRootPart3.CFrame = v_8.WorldPivot
						Instance.new("IntValue", v_8).Name = "Ignored"
						task.wait(0.3)
					else
						local random = math.random
						humanoidRootPart3.CFrame = cFrame * CFrame.new(0, math.random(0, 2), random(0, 2))

						task.spawn(function()
							local health = humanoid2.Health
							task.wait(2.2)

							if v_8 and v_8.Parent and not v_8:FindFirstChild("Ignored") then
								local humanoid3 = v_8:FindFirstChildOfClass("Humanoid")
								local humanoidRootPart4 = v_8:FindFirstChild("HumanoidRootPart")

								if humanoid3 and humanoidRootPart4 and humanoid3:IsA("Humanoid") and humanoid3.Health == health and humanoid3.Health > 0 then
									humanoidRootPart4.CFrame = v_8.WorldPivot
									Instance.new("IntValue", v_8).Name = "Ignored"
									task.wait(0.3)
								end
							end
						end)
					end

					getgenv().DaBringMob = true
				end
			end
		end
	end
end

task.wait(1)
SettingFarmMain = Main.CreatePage({ Page_Name = "Setting Farm", Page_Title = "Setting Farm" })
SettingFarmMainSection = SettingFarmMain.CreateSection("Setting Farm")
flag = false

v_7 = SettingFarmMainSection.CreateDropdown({
	Title = "Select Weapon",
	List = { "Melee", "Sword", "Blox Fruit" },
	Search = true,
	Selected = false,
	Default = Settings["Select Weapon"] or nil,
}, function(arg)
	SaveSettings("Select Weapon", arg)
end)

SettingFarmMainSection.CreateToggle({ Title = "Attack No Animation ", Desc = nil, Default = Settings["Attack No Animation "] or true }, function(arg)
	SaveSettings("Attack No Animation ", arg)
end)

SettingFarmMainSection.CreateToggle({
	Title = "Kill Aura Only Raid And Volcano",
	Desc = nil,
	Default = Settings["Kill Aura Only Raid And Volcano"] or false,
}, function(arg)
	SaveSettings("Kill Aura Only Raid And Volcano", arg)
end)

SettingFarmMainSection.CreateSlider({
	Title = "Time Delay Kill",
	Min = 0,
	Max = 5,
	Default = Settings["Time Delay Kill"] or 5,
	Precise = true,
}, function(arg)
	SaveSettings("Time Delay Kill", arg)
end)

SettingFarmMainSection.CreateToggle({ Title = "Auto Click", Desc = nil, Default = Settings["Auto Click"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Click"] and task.wait() do
				local ok, result = pcall(function()
					local v_8 = NameWeapon("Blox Fruit")

					if v_8 and localPlayer.Character:FindFirstChild(v_8) then
						local v_9 = AttackAOE(80, true)
						if not v_9 then
							return
						end
						local v_10 = v_9[1][1]
						getgenv().UseFruitM1(v_10)
					else
						getgenv().AttackFunctionnhungSuperTrial()
					end
				end)

				if result then
					print(result)
				end
			end
		end)
	end

	SaveSettings("Auto Click", arg)
end)

SettingFarmMainSection.CreateToggle({
	Title = "Kill Aura With DragonStorm",
	Desc = nil,
	Default = Settings["Kill Aura With DragonStorm"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Kill Aura With DragonStorm"] and wait() do
				pcall(function()
					if localPlayer.Character:FindFirstChild("Dragonstorm") and getgenv().SpamGunDragonStorm then
						local v_8 = fn3(game.Players.LocalPlayer, 150)

						if v_8 then
							SpamGunDragonStorm(v_8[1].PrimaryPart)
						end
					end
				end)
			end
		end)
	end

	SaveSettings("Kill Aura With DragonStorm", arg)
end)

FFCMatch = function(arg, arg2)
	for _, child in pairs(arg:GetChildren()) do
		if string.match(child.Name, arg2) then
			return child
		end
	end

	return nil
end

SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On Buso", Desc = nil, Default = Settings["Auto Turn On Buso"] or true }, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Turn On Buso"] and wait(1) do
				pcall(function()
					if not FFCMatch(localPlayer.Character, "_BusoLayer1") and not localPlayer.Character:FindFirstChild("HasBuso") then
						CommF:InvokeServer("Buso")
						task.wait(2)
					end
				end)
			end
		end)
	end

	SaveSettings("Auto Turn On Buso", arg)
end)

SettingFarmMainSection.CreateToggle({
	Title = "Auto Turn On Observation",
	Desc = nil,
	Default = Settings["Auto Turn On Observation"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Turn On Observation"] and wait(1) do
				pcall(function()
					if not game:GetService("Lighting").Blur.Enabled then
						game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
						wait()
						game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
						wait(3)
					end
				end)
			end
		end)
	end

	SaveSettings("Auto Turn On Observation", arg)
end)

TurnOnV4 = function()
	local character = localPlayer.Character
	local raceEnergy = character and character:FindFirstChild("RaceEnergy")
	local raceTransformed = character and character:FindFirstChild("RaceTransformed")
	if not raceEnergy or raceEnergy.Value < 1 or not raceTransformed or raceTransformed.Value then
		return
	end
	local awakening = localPlayer.Backpack:FindFirstChild("Awakening") or character:FindFirstChild("Awakening")

	if awakening then
		awakening.RemoteFunction:InvokeServer(true)
	end
end

local v_8

v_8 = SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On V4", Desc = nil, Default = Settings["Auto Turn On V4"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Turn On V4"] and task.wait(1) do
				pcall(TurnOnV4)
			end
		end)
	end

	SaveSettings("Auto Turn On V4", arg)
end)

SettingFarmMainSection.CreateToggle({ Title = "Auto Turn On V3", Desc = nil, Default = Settings["Auto Turn On V3"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Turn On V3"] and task.wait(1) do
				game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
				wait(2)
			end
		end)
	end

	SaveSettings("Auto Turn On V3", arg)
end)

SettingFarmMainSection.CreateToggle({
	Title = "Auto Dodge Skill Mobs",
	Desc = nil,
	Default = Settings["Auto Dodge Skill Mobs"] or false,
}, function(arg)
	SaveSettings("Auto Dodge Skill Mobs", arg)
end)

local v_9 = nil

game:GetService("Workspace").Enemies.DescendantAdded:Connect(function(descendant)
	if Settings["Auto Dodge Skill Mobs"] and nil and v_9.Parent and not Doding and (descendant.Name == "BodyGyro" or descendant.Name == "BodyPosition" or descendant.Name == "KiBlastFireShort") and descendant.Parent.Parent.Name == v_9.Name then
		getgenv().Doding = true
		getgenv().ReadyToDodge = true
		local now = tick()

		while true do
			wait()

			if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
				if not (not descendant or not descendant.Parent or tick() - now > 14) then
					continue
				end
			end

			break
		end

		if tick() - now < 2 then
			wait(0.5)
		end

		getgenv().Doding = false
		getgenv().ReadyToDodge = false
	end
end)

SettingFarmMainSection.CreateToggle({ Title = "Teleport Y if low health", Desc = nil, Default = Settings["Teleport Y"] or false }, function(arg)
	SaveSettings("Teleport Y", arg)
end)

SettingFarmMainSection.CreateSlider({
	Title = "% Health Player",
	Min = 0,
	Max = 100,
	Default = Settings["% Health Player"] or 40,
	Precise = true,
}, function(arg)
	SaveSettings("% Health Player", arg)
end)

SettingFarmMainSection.CreateSlider({
	Title = "Distance Teleport Y",
	Min = 0,
	Max = 10000,
	Default = Settings["Distance Teleport Y"] or 800,
	Precise = true,
}, function(arg)
	SaveSettings("Distance Teleport Y", arg)
end)

SettingFarmMainSection.CreateToggle({
	Title = "Tween Safe if have Items",
	Desc = nil,
	Default = Settings["Tween Safe if have Items"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Tween Safe if have Items"] and wait(0.25) do
				pcall(function()
					if CheckNameBoss("Darkbeard") and Settings["Attack Darkbeard"] then
						return
					end

					if DetectItemPlr("Fist of Darkness") and Settings["Summon Darkbeard"] then
						return
					end

					if (DetectItemPlr("Fist of Darkness") or DetectItemPlr("God's Chalice")) and Settings["Tween Safe if have Items"] then
						if game.PlaceId == getgenv().CheckPlaceId2 then
							toTarget(CFrame.new(-385.250916, 73.0458984, 297.388397))
						else
							toTarget(CFrame.new(-12463, 374, -7523))
						end
					end
				end)
			end
		end)
	end

	SaveSettings("Tween Safe if have Items", arg)
end)

SettingFarmMainSection.CreateSlider({
	Title = "Time Hop Server",
	Min = 0,
	Max = 60,
	Default = Settings["Time Hop Server"] or 10,
	Precise = true,
}, function(arg)
	SaveSettings("Time Hop Server", arg)
end)

SettingFarmMainSection.CreateToggle({ Title = "Use Portal Teleport", Desc = nil, Default = Settings["Use Portal Teleport"] or false }, function(arg)
	SaveSettings("Use Portal Teleport", arg)
end)

SettingFarmMainSection.CreateSlider({
	Title = "Bring Mob Count",
	Min = 2,
	Max = 6,
	Default = Settings["Bring Mob Count"] or 2,
	Precise = true,
}, function(arg)
	SaveSettings("Bring Mob Count", arg)
end)

SettingFarmMainSection.CreateToggle({ Title = "Bring Mob", Desc = nil, Default = Settings["Bring Mob"] or true }, function(arg)
	SaveSettings("Bring Mob", arg)
end)

SettingFarmMainSection.CreateToggle({ Title = "Reset Teleport [ Beta ]", Desc = nil, Default = Settings["Reset Teleport"] or false }, function(arg)
	SaveSettings("Reset Teleport", arg)
end)

SettingFarmMainSection.CreateSlider({
	Title = "Speed Tween ",
	Min = 0,
	Max = 1000,
	Default = Settings["Speed Tween "] or 300,
	Precise = true,
}, function(arg)
	SaveSettings("Speed Tween ", arg)
end)

SettingFarmMainSection.CreateLabel({ Title = "Recommended: 350. If you’re farming spots close to each other, use a higher speed" })
SettingSkillMain = Main.CreatePage({ Page_Name = "Hold and Select Skill", Page_Title = "Setting Hold and Select Skill" })
SelectSkillsSection = SettingSkillMain.CreateSection("Select Skills")

local function fn4(arg, arg2)
	local str = "Select Skills " .. arg
	local tbl4 = {}

	for _, v_10 in ipairs(arg2) do
		tbl4[v_10] = false
	end

	EnsureAllTrueDefaults(str, arg2)

	SelectSkillsSection.CreateDropdown({
		Title = str,
		List = PrepareMultiSelectList(tbl4, Settings[str], true),
		Search = true,
		Selected = true,
		Default = Settings[str] or nil,
	}, function(arg3, arg4)
		SaveSettings(str, arg3, arg4)
	end)
end

fn4("Melee", { "Z", "X", "C" })
fn4("Sword", { "Z", "X" })
fn4("Gun", { "Z", "X" })
fn4("Blox Fruit", { "Z", "X", "C", "V", "F" })
HoldSkillsSection = SettingSkillMain.CreateSection("Hold Skills")

local function fn5(arg, arg2)
	local tbl4 = {}

	for _, v_10 in ipairs(arg2) do
		tbl4[v_10] = {
			Title = v_10,
			KeyName = v_10,
			Min = 0,
			Max = 5,
			Default = Settings["Skill " .. v_10 .. " " .. arg] or 0.5,
			Precise = true,
		}
	end

	HoldSkillsSection.CreateDropdown({ Title = "Set Delay " .. arg, List = tbl4, Slider = true }, function(arg3, arg4)
		if arg4 and arg4.KeyName then
			SaveSettings("Skill " .. arg4.KeyName .. " " .. arg, arg4.Default)
		end
	end)
end

HoldSkillsSection.CreateToggle({
	Title = "Use skill fast dont hold",
	Desc = nil,
	Default = Settings["Use skill fast dont hold"] or false,
}, function(arg)
	SaveSettings("Use skill fast dont hold", arg)
end)

fn5("Melee", { "Z", "X", "C" })
fn5("Sword", { "Z", "X" })
fn5("Gun", { "Z", "X" })
fn5("Blox Fruit", { "Z", "X", "C", "V", "F" })
FarmMain = Main.CreatePage({ Page_Name = "Farming", Page_Title = "Farming" })
SettingAutoFarmSection = FarmMain.CreateSection("Setting Farm")

SettingAutoFarmSection.CreateDropdown({
	Title = "Select Method Farm",
	List = { "Level Farm", "Farm Bones", "Farm Katakuri", "Farm Tyrant of the Skies", "Aura Farm" },
	Search = false,
	Selected = false,
	Default = Settings["Select Method Farm"] or nil,
}, function(arg)
	SaveSettings("Select Method Farm", arg)
end)

SettingAutoFarmSection.CreateSlider({
	Title = "Distance Farm Aura",
	Min = 0,
	Max = 1000,
	Default = Settings["Distance Farm Aura"] or 300,
	Precise = true,
}, function(arg)
	SaveSettings("Distance Farm Aura", arg)
end)

SettingAutoFarmSection.CreateToggle({
	Title = "Ignore Attack Katakuri",
	Desc = nil,
	Default = Settings["Ignore Attack Katakuri"] or false,
}, function(arg)
	SaveSettings("Ignore Attack Katakuri", arg)
end)

SettingAutoFarmSection.CreateToggle({ Title = "Hop Find Katakuri", Desc = nil, Default = Settings["Hop Find Katakuri"] or false }, function(arg)
	SaveSettings("Hop Find Katakuri", arg)
end)

SettingAutoFarmSection.CreateToggle({
	Title = "Auto Quest [Katakuri/Bone/Tyrant]",
	Desc = nil,
	Default = Settings["Auto Quest [Katakuri/Bone/Tyrant]"] or false,
}, function(arg)
	SaveSettings("Auto Quest [Katakuri/Bone/Tyrant]", arg)
end)

local v_10

v_10 = SettingAutoFarmSection.CreateToggle({ Title = "Start Farm", Desc = nil, Default = Settings["Start Farm"] or false }, function(arg)
	SaveSettings("Start Farm", arg)

	if not arg then
		TweenManager.CancelCurrent()
	end
end)

MasteryFarmSection = FarmMain.CreateSection("Mastery Farm")

MasteryFarmSection.CreateDropdown({
	Title = "Select Method Farm Mastery",
	List = { "Blox Fruit", "Gun" },
	Search = true,
	Selected = false,
	Default = Settings["Select Method Farm Mastery"] or nil,
}, function(arg)
	SaveSettings("Select Method Farm Mastery", arg)
end)

MasteryFarmSection.CreateSlider({ Title = "Health %", Min = 0, Max = 100, Default = Settings["Health %"] or 40, Precise = true }, function(arg)
	SaveSettings("Health %", arg)
end)

MasteryFarmSection.CreateToggle({ Title = "Farm Mastery", Desc = nil, Default = Settings["Farm Mastery"] or false }, function(arg)
	SaveSettings("Farm Mastery", arg)

	if arg and not Settings["Start Farm"] then
		lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Start Farm Plz", ShowTime = 5 })
	end
end)

FarmingMaterialSection = FarmMain.CreateSection("Farming Material")

FarmingMaterialSection.CreateDropdown({
	Title = "Select Material",
	List = TableMaterials,
	Search = true,
	Selected = false,
	Default = Settings["Select Material"] or nil,
}, function(arg)
	SaveSettings("Select Material", arg)
end)

local tbl4, tbl5, fn6, n3

do
	local tbl6 = {}

	local function fn7(arg)
		for _, v_11 in next, arg, nil do
			if not table.find(tbl6, v_11) then
				return v_11
			end
		end
	end

	FarmingMaterialSection.CreateToggle({ Title = "Farm Material", Desc = nil, Default = Settings["Farm Material"] or false }, function(arg)
		SaveSettings("Farm Material", arg)

		if not arg then
			TweenManager.CancelCurrent()
			tbl6 = {}
		end
	end)

	local tbl7 = { "BartiloQuest", "Trainees", "MarineQuest", "CitizenQuest" }
	tbl4 = {}
	local tbl8 = { "Baking Staff", "Head Baker", "Cake Guard", "Cookie Crafter" }
	local tbl9 = { "Cocoa Warrior", "Chocolate Bar Battler", "Candy Rebel", "Sweet Thief" }
	tbl5 = { "Reborn Skeleton", "Demonic Soul", "Living Zombie", "Posessed Mummy" }
	local tbl10 = { "Isle Champion", "Serpent Hunter", "Skull Slayer", "Sun-kissed Warrior" }
	getgenv().NameMobQuest = ""
	getgenv().NameQuest = ""
	getgenv().IDQuest = 0
	getgenv().questpoint = {}
	local tbl11 = {}

	pcall(function()
		tbl11 = v_2(game.ReplicatedStorage.Quests)
	end)

	local function fn8()
		local value = localPlayer.Data.Level.Value

		if value >= 1450 and game.PlaceId == getgenv().CheckPlaceId2 then
			getgenv().NameMobQuest = "Water Fighter"
			getgenv().NameQuest = "ForgottenQuest"
			getgenv().IDQuest = 2
		elseif value >= 700 and game.PlaceId == getgenv().CheckPlaceId3 then
			getgenv().NameMobQuest = "Galley Captain"
			getgenv().NameQuest = "FountainQuest"
			getgenv().IDQuest = 2
		else
			local n4 = 0

			for k, v_11 in pairs(tbl11) do
				for k2, v_12 in pairs(v_11) do
					if not table.find(tbl7, k) then
						local levelReq = v_12.LevelReq

						for k3, v_13 in pairs(v_12.Task) do
							if value >= levelReq and levelReq >= n4 and v_13 > 1 then
								getgenv().NameMobQuest = k3
								getgenv().NameQuest = k
								getgenv().IDQuest = k2
								n4 = levelReq
							end
						end
					end
				end
			end
		end
	end

	CountQuest = function()
		local tbl12 = {}

		for _, v_11 in pairs(tbl11) do
			for _, v_12 in pairs(v_11) do
				for k in pairs(v_12.Task) do
					if k == getgenv().mobv then
						for _, v_13 in pairs(v_11) do
							if v_13.LevelReq <= localPlayer.Data.Level.Value and v_13.Name ~= "Town Raid" then
								for k2, v_14 in pairs(v_13.Task) do
									if v_14 > 1 then
										table.insert(tbl12, k2)
									end
								end
							end
						end
					end
				end
			end
		end

		return tbl12
	end

	local tbl12 = { Data = nil }

	local function fn9()
		if tbl12 and tbl12.Data then
			return tbl12
		end

		pcall(function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local guideModule

			if ReplicatedStorage2 then
				guideModule = ReplicatedStorage2:FindFirstChild("GuideModule") or ReplicatedStorage2:WaitForChild("GuideModule", 5)
			else
				guideModule = ReplicatedStorage2
			end

			if guideModule then
				tbl12 = v_2(guideModule)
			end
		end)

		return tbl12
	end

	pcall(function()
		tbl12 = v_2(game.ReplicatedStorage:WaitForChild("GuideModule", 5))
	end)

	local function fn10()
		local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return false
		end
		local quest = playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest")
		if quest and quest.Visible then
			return true
		end
		local trackedQuestFrame = playerGui:FindFirstChild("TrackedQuestFrame")
		if trackedQuestFrame and trackedQuestFrame.Enabled and trackedQuestFrame:FindFirstChild("Frame") and trackedQuestFrame.Frame.Visible then
			return true
		end
		return false
	end

	DontQuest = function()
		return fn10()
	end

	GetNameDoubleQuest = function()
		if not fn10() then
			return nil
		end
		local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			local trackedQuestFrame = playerGui:FindFirstChild("TrackedQuestFrame")

			if trackedQuestFrame and trackedQuestFrame.Enabled and trackedQuestFrame:FindFirstChild("Frame") and trackedQuestFrame.Frame.Visible then
				local description = trackedQuestFrame.Frame:FindFirstChild("description", true)

				if description and description.Text ~= "" then
					local match = description.Text:gsub("^Defeat%s*", ""):gsub("^%d+%s*", ""):gsub("%s*%(%d+/%d+%)", ""):gsub("%s*%d+/%d+", ""):gsub("%s*defeated", ""):gsub(" %p?Lv%.? %d+%p?", ""):match("^%s*(.-)%s*$")

					if match and match ~= "" then
						if getgenv().NameMobQuest and getgenv().NameMobQuest ~= "" and (match:find(getgenv().NameMobQuest, 1, true) or getgenv().NameMobQuest:find(match, 1, true)) then
							return getgenv().NameMobQuest
						end
						return match
					end
				end
			end

			local quest = playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Quest")

			if quest and quest.Visible then
				local title = quest:FindFirstChild("Container") and quest.Container:FindFirstChild("QuestTitle") and quest.Container.QuestTitle:FindFirstChild("Title")

				if title and title.Text ~= "" then
					local match = title.Text:gsub("^Defeat%s*", ""):gsub("^%d+%s*", ""):gsub("%s*%(%d+/%d+%)", ""):gsub("%s*%d+/%d+", ""):gsub("%s*defeated", ""):gsub(" %p?Lv%.? %d+%p?", ""):match("^%s*(.-)%s*$")

					if match and match ~= "" then
						if getgenv().NameMobQuest and getgenv().NameMobQuest ~= "" and (match:find(getgenv().NameMobQuest, 1, true) or getgenv().NameMobQuest:find(match, 1, true)) then
							return getgenv().NameMobQuest
						end
						return match
					end
				end
			end
		end

		if getgenv().NameMobQuest and getgenv().NameMobQuest ~= "" then
			return getgenv().NameMobQuest
		end
		local v_11 = fn9()

		if v_11 and v_11.Data and v_11.Data.QuestData and v_11.Data.QuestData.Task then
			local v_12 = table.pack(i_1())
			if v_12[1] then
				return v_12[2]
			end
		end

		return nil
	end

	DoubleQuest = function()
		wait(0.5)
		fn8()
		local tbl13 = {}

		if DontQuest() and GetNameDoubleQuest() == getgenv().NameMobQuest and #CountQuest() >= 2 then
			for k, v_11 in pairs(tbl11) do
				for _, v_12 in pairs(v_11) do
					for k2 in pairs(v_12.Task) do
						if tostring(k2) ~= getgenv().mobv then
							continue
						end

						for k3, v_13 in pairs(v_11) do
							for k4, v_14 in pairs(v_13.Task) do
								if k4 ~= getgenv().mobv and v_14 > 1 then
									tbl13.Name = k4
									tbl13.NameQuest = k
									tbl13.ID = k3
									return tbl13
								end
							end
						end
					end
				end
			end
		else
			tbl13.Name = getgenv().NameMobQuest
			tbl13.NameQuest = getgenv().NameQuest
			tbl13.ID = getgenv().IDQuest
		end

		return tbl13
	end

	CFrameQuest = function()
		local tbl13 = {}

		for k, v_11 in next, tbl11, nil do
			if k ~= "MarineQuest" then
				for _, v_12 in next, v_11, nil do
					tbl13[v_12.LevelReq] = k
				end
			end
		end

		getgenv().questpoint = {}

		for k, v_11 in next, tbl12.Data.NPCList, nil do
			for _, v_12 in next, v_11.Levels, nil do
				local v_13 = tbl13[v_12]

				if k.Parent.Name ~= "Marine Leader" and v_13 and not getgenv().questpoint[v_13] then
					getgenv().questpoint[v_13] = CFrame.new(v_11.Position)
				end
			end
		end

		getgenv().questpoint.SkyExp1Quest = CFrame.new(-7857.28516, 5544.34033, -382.321503)
	end

	local function fn11(arg)
		local v_11 = fn9()
		local v_12 = tbl11

		if not v_12 or not next(v_12) then
			pcall(function()
				tbl11 = v_2(game.ReplicatedStorage:WaitForChild("Quests", 5))
			end)

			v_12 = tbl11
		end

		if not v_11 or not v_11.Data or not v_11.Data.NPCList or not v_12 then
			return {}
		end
		local tbl13 = {}
		local flag2 = localPlayer.Team and localPlayer.Team.Name == "Marines"
		local n4 = -1

		for _, v_13 in pairs(v_11.Data.NPCList) do
			local internalQuestName = v_13.InternalQuestName
			local flag3 = table.find(tbl7, internalQuestName)

			if internalQuestName == "MarineQuest" and flag2 and arg < 15 then
				flag3 = false
			elseif internalQuestName == "BanditQuest1" and flag2 and arg < 15 then
				flag3 = true
			end

			if internalQuestName and not flag3 and v_13.Levels and v_12[internalQuestName] then
				for k, level in pairs(v_13.Levels) do
					local v_14 = v_12[internalQuestName][k]

					if v_14 and v_14.Task then
						local key, v_15 = next(v_14.Task)

						if v_15 and v_15 > 1 and level <= arg and level > n4 then
							tbl13 = {
								Level = level,
								Name = v_13.NPCName,
								QuestName = internalQuestName,
								Pos = v_13.Position,
								Id = k,
								Mob = key,
							}

							n4 = level
						end
					end
				end
			end
		end

		return tbl13
	end

	TakeQuestLevel = function()
		local v_11 = fn11(localPlayer.Data.Level.Value)
		if not v_11 or not v_11.Pos then
			return
		end
		local position = typeof(v_11.Pos) == "CFrame" and v_11.Pos.Position or v_11.Pos
		local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
		if not humanoidRootPart2 or not humanoid then
			return
		end
		local mob = v_11.Mob
		getgenv().mobv = mob
		local mob2 = v_11.Mob
		getgenv().NameMobQuest = mob2
		local questName = v_11.QuestName
		getgenv().NameQuest = questName
		local id = v_11.Id
		getgenv().IDQuest = id

		if (position - humanoidRootPart2.Position).Magnitude <= 30 and humanoid.Health > 0 then
			local id2 = v_11.Id
			CommF:InvokeServer("StartQuest", tostring(v_11.QuestName), id2)
			task.wait(0.35)

			if not fn10() then
				local id3 = (v_11.Id or 1) + 1
				CommF:InvokeServer("StartQuest", tostring(v_11.QuestName), id3)
				task.wait(0.35)

				if fn10() then
					v_11.Id = id3
					getgenv().IDQuest = id3

					pcall(function()
						local v_12 = tbl11 and tbl11[v_11.QuestName] and tbl11[v_11.QuestName][id3]

						if v_12 and v_12.Task then
							local mob3 = next(v_12.Task)

							if mob3 then
								v_11.Mob = mob3
								getgenv().mobv = mob3
								getgenv().NameMobQuest = mob3
							end
						end
					end)
				end
			end
		else
			toTarget(CFrame.new(position) * CFrame.new(0, 4, 2), true)
		end
	end

	DetectPartSpawnMob = function(arg, arg2)
		local function fn12(arg3)
			return arg3:gsub(" %p?Lv%.? %d+%p?", "")
		end

		local v_11 = string.find(arg, "Lv.") and fn12(arg) or arg

		for _, v_12 in pairs(TableMobSpawn) do
			if v_12:IsA("Part") then
				local name = string.find(v_12.Name, "Lv.") and fn12(v_12.Name) or v_12.Name
				if (name == arg or name == v_11) and (not arg2 or not v_12:FindFirstChild("Ignored")) then
					return v_12
				end
			end
		end

		local v_12 = pairs
		local children = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns") and workspace._WorldOrigin.EnemySpawns:GetChildren() or {}

		for _, child in v_12(children) do
			if child:IsA("Part") then
				local name = string.find(child.Name, "Lv.") and fn12(child.Name) or child.Name
				if (name == arg or name == v_11) and (not arg2 or not child:FindFirstChild("Ignored")) then
					table.insert(TableMobSpawn, child)
					return child
				end
			end
		end

		for _, v_13 in pairs(getnilinstances()) do
			if v_13:IsA("Part") then
				local name = string.find(v_13.Name, "Lv.") and fn12(v_13.Name) or v_13.Name
				if (name == arg or name == v_11) and (not arg2 or not v_13:FindFirstChild("Ignored")) then
					table.insert(TableMobSpawn, v_13)
					return v_13
				end
			end
		end

		return nil
	end

	DeleteIgnoredMobSpawn = function()
		for _, v_11 in pairs(TableMobSpawn) do
			if v_11:FindFirstChild("Ignored") then
				v_11.Ignored:Destroy()
			end
		end
	end

	DetectNameTablePart = function(arg)
		for _, v_11 in next, arg, nil do
			if not table.find(tbl4, v_11) then
				return v_11
			end
		end
	end

	TeleportSpawnMob = function(arg)
		if typeof(arg) == "table" then
			if #arg <= #tbl4 then
				tbl4 = {}
				return
			end
			local v_11 = DetectPartSpawnMob(DetectNameTablePart(arg))

			if v_11 then
				toTarget(v_11.CFrame * CFrame.new(0, 60, 0))
				wait(0.5)
			end
		else
			wait(0.5)
			local v_11 = DetectPartSpawnMob(arg, true)

			if v_11 then
				if (v_11.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(arg) then
					Instance.new("IntValue", v_11).Name = "Ignored"
				end

				toTarget(v_11.CFrame * CFrame.new(0, 60, 0))
			else
				DeleteIgnoredMobSpawn()
			end
		end
	end

	QuestBoneAndkatakuri = function(arg, arg2)
		local v_11 = getgenv().questpoint[arg]

		if not v_11 then
			CFrameQuest()
			task.wait(1.5)
			v_11 = getgenv().questpoint[arg]
			if not v_11 then
				return
			end
		end

		local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart2 or not humanoid then
			return
		end

		if (v_11.Position - humanoidRootPart2.Position).Magnitude <= 30 then
			if humanoid.Health > 0 then
				CommF:InvokeServer("StartQuest", arg, arg2)
				task.wait(0.5)
			end
		else
			toTarget(v_11 * CFrame.new(0, 4, 2), true)
		end
	end

	local tbl13 = { "Control-Control", "Buddha-Buddha", "Diamond-Diamond", "Falcon-Falcon" }

	local function fn12(arg, arg2)
		local skills = localPlayer and localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("Main") and localPlayer.PlayerGui.Main:FindFirstChild("Skills")
		local v_11 = skills and skills:FindFirstChild(arg)
		v_11 = v_11 and v_11:FindFirstChild(arg2)
		if not v_11 then
			return false
		end
		return v_11:IsA("Frame") and v_11.Title.TextColor3 == Color3.new(1, 1, 1) and (v_11.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v_11.Cooldown.Size == UDim2.new(1, 0, 1, -1))
	end

	local function fn13(arg)
		if fn12(arg, "Z") then
			local VirtualInputManager = game:GetService("VirtualInputManager")
			VirtualInputManager:SendKeyEvent(true, "Z", false, game)
			VirtualInputManager:SendKeyEvent(false, "Z", false, game)
		end
	end

	local function fn14(arg)
		if not arg or not arg:IsA("Tool") then
			return nil
		end
		local skills = localPlayer and localPlayer:FindFirstChild("PlayerGui") and localPlayer.PlayerGui:FindFirstChild("Main") and localPlayer.PlayerGui.Main:FindFirstChild("Skills")
		skills = skills and skills:FindFirstChild(arg.Name)
		if not skills then
			return nil
		end

		for _, child in ipairs(skills:GetChildren()) do
			local flag2 = child:IsA("Frame") and child.Name ~= "Template" and (child.Name ~= "Z" or not table.find(tbl13, arg.Name)) and Settings["Select Skills " .. arg.ToolTip] and Settings["Select Skills " .. arg.ToolTip][child.Name]
			local flag3

			if flag2 then
				flag3 = child.Title.TextColor3 == Color3.new(1, 1, 1) and child.Cooldown.Size == UDim2.new(0, 0, 1, -1) or child.Cooldown.Size == UDim2.new(1, 0, 1, -1)
			else
				flag3 = flag2
			end

			if flag3 then
				return child.Name
			end
		end

		return nil
	end

	UsedualFlock = function()
		equiptool(NameWeapon(Settings["Select Weapon"] or "Melee"))
	end

	FarmMastery = function(arg)
		local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
		if not arg or not humanoid or not arg:FindFirstChild("HumanoidRootPart") then
			return
		end
		local cFrame2 = arg.HumanoidRootPart.CFrame
		getgenv().AimPos = cFrame2
		if not Settings["Farm Mastery"] then
			UsedualFlock()
			return
		end

		if (Settings["Health %"] or 100) / 100 < humanoid.Health / humanoid.MaxHealth then
			UsedualFlock()
			return
		end
		local selectMethodFarmMastery = Settings["Select Method Farm Mastery"]
		local v_11 = NameWeapon(selectMethodFarmMastery)
		local v_12 = NameWeapon(selectMethodFarmMastery, true)
		if not v_11 or not v_12 then
			return
		end

		if selectMethodFarmMastery == "Gun" and localPlayer.Character:FindFirstChild(v_11) then
			ShootM1(arg)
		end

		equiptool(v_11)

		if v_11 == "Control-Control" then
			local globe = workspace._WorldOrigin:FindFirstChild("Globe")
			local flag2 = not globe

			if not flag2 then
				local n4 = globe.AB.CurveSize0 / 1.75
				flag2 = localPlayer:DistanceFromCharacter(globe.Position) > n4
			end

			if flag2 then
				fn13(v_11)
				return
			end
		elseif v_11 == "Buddha-Buddha" then
			if not (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart:FindFirstChild("Buddha")) then
				fn13(v_11)
				return
			end
		elseif v_11 == "Diamond-Diamond" then
			if not (localPlayer.Character and localPlayer.Character:FindFirstChild("DiamondBody")) then
				fn13(v_11)
				return
			end
		elseif v_11 == "Falcon-Falcon" then
			if not (localPlayer.Character and localPlayer.Character:FindFirstChild("FalconWings")) then
				fn13(v_11)
				return
			end
		end

		local v_13 = fn14(v_12)

		if v_13 then
			local n4 = Settings["Skill " .. v_13 .. " " .. v_12.ToolTip] or 0.5
			local VirtualInputManager = game:GetService("VirtualInputManager")
			VirtualInputManager:SendKeyEvent(true, v_13, false, game)

			if Settings["Use skill fast dont hold"] then
				task.wait(0.05)
			else
				task.wait(n4)
			end

			VirtualInputManager:SendKeyEvent(false, v_13, false, game)
		end
	end

	getgenv().StackFarm = true
	getgenv().StackFarmOther = true
	StackFarm = getgenv().StackFarm
	StackFarmOther = getgenv().StackFarmOther

	DetectMobAura = function()
		local distanceFarmAura = typeof(Settings["Distance Farm Aura"]) ~= "number" and tonumber(Settings["Distance Farm Aura"]) or Settings["Distance Farm Aura"] or 300
		local name = nil

		for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
			if IsMobAlive(child) then
				local magnitude = (child.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude

				if magnitude < distanceFarmAura then
					name = child.Name
					distanceFarmAura = magnitude
				end
			end
		end

		return name
	end

	getgenv().StackFarm = true
	getgenv().YPosFruit = 20

	CheckCDSkillTransformation = function(arg, arg2)
		local v_11 = next
		local name = arg.Name
		local children, v_12 = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills[name]:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Frame") then
				if v_13.Name ~= "Template" and not string.find(v_13.Title.Text, "Transformation") and arg2[v_13.Name] and v_13.Title.TextColor3 == Color3.new(1, 1, 1) and v_13.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v_13.Cooldown.Size == UDim2.new(1, 0, 1, -1) then
					return v_13, Settings["Skill " .. v_13.Name .. " " .. arg.ToolTip]
				end
			end
		end
	end

	AutoAllSkill = function()
		local Melee = NameWeapon("Melee", true) or false
		local Sword = NameWeapon("Sword", true) or false
		local flag2 = NameWeapon("Blox Fruit", true) or false
		local Gun = NameWeapon("Gun", true) or false
		local skills = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills
		if Melee and not skills:FindFirstChild(Melee.Name) then
			equiptool(Melee.Name)
			return
		end

		if Sword and not skills:FindFirstChild(Sword.Name) then
			equiptool(Sword.Name)
			return
		end

		if flag2 and not skills:FindFirstChild(flag2.Name) then
			equiptool(flag2.Name)
			return
		end

		if Gun and not skills:FindFirstChild(Gun.Name) then
			equiptool(Gun.Name)
			return
		end
		local v_11

		if Melee and CheckCDSkillTransformation(Melee, Settings["Select Skills " .. Melee.ToolTip]) then
			v_11 = CheckCDSkillTransformation(Melee, Settings["Select Skills " .. Melee.ToolTip])
		elseif Sword and CheckCDSkillTransformation(Sword, Settings["Select Skills " .. Sword.ToolTip]) then
			v_11 = CheckCDSkillTransformation(Sword, Settings["Select Skills " .. Sword.ToolTip])
		elseif Gun and CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip]) then
			v_11 = CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip])
		elseif flag2 and CheckCDSkillTransformation(flag2, Settings["Select Skills " .. flag2.ToolTip]) then
			v_11 = CheckCDSkillTransformation(flag2, Settings["Select Skills " .. flag2.ToolTip])
		else
			v_11 = nil
		end

		if v_11 then
			local name = v_11.Parent.Name
			equiptool(name)

			if localPlayer.Character:FindFirstChild(name) then
				game:GetService("VirtualInputManager"):SendKeyEvent(true, v_11.Name, false, game)

				if Settings["Use skill fast dont hold"] then
					task.wait(0.05)
				else
					task.wait(tonumber(holdskill))
				end

				game:GetService("VirtualInputManager"):SendKeyEvent(false, v_11.Name, false, game)
			end
		end
	end

	local v_11 = nil
	local v_12 = nil

	pcall(function()
		v_11 = v_2(game:GetService("ReplicatedStorage"):WaitForChild("ItemReplicationService", 5))
		v_12 = v_2(game:GetService("ReplicatedStorage"):WaitForChild("ItemConfig", 5))
	end)

	fn6 = function()
		if not v_11 or not v_12 then
			return {}
		end
		local tbl14 = {}
		local keys = v_11.KEYS

		for _, v_13 in v_11:GetItems(keys.QUANTITY) do
			if v_13.Value and v_13.Value > 0 then
				local ok, result = pcall(function()
					return v_12.match(v_13.ItemId):unwrap()
				end)

				if ok and result and result.Display then
					local category = result.Display.Category
					local storageKey = result.Index and result.Index.StorageKey

					if category == "Blox Fruit" then
						storageKey = storageKey or result.Display.Name or "ItemId_" .. v_13.ItemId
					else
						storageKey = result.Display.Name or storageKey or "ItemId_" .. v_13.ItemId
					end

					table.insert(tbl14, {
						Name = storageKey,
						Type = category,
						Count = v_13.Value,
						Mastery = v_11:ReadItem(keys.MASTERY, v_13.ItemId, v_13.NetworkedUID) or 0,
						ItemId = v_13.ItemId,
						UID = v_13.NetworkedUID,
					})
				end
			end
		end

		return tbl14
	end

	local tbl14 = nil
	local n4 = 0

	CheckItemInventory = function(arg)
		if not tbl14 or tick() - n4 > 1 then
			tbl14 = {}

			for _, v_13 in fn6() do
				tbl14[v_13.Name] = true
			end

			n4 = tick()
		end

		return tbl14[arg] == true
	end

	DetectModelDestroyTyrant = function()
		local v_13 = next
		local children, v_14 = (workspace.Map:FindFirstChild("TikiOutpost") and workspace.Map.TikiOutpost.IslandModel:FindFirstChild("EagleBossArena", true)):GetChildren()

		for _, v_15 in v_13, children, v_14 do
			if v_15.Name == "Tree" and not v_15:GetAttribute("AlreadyDestroyedClient") then
				return v_15
			end
		end
	end

	local function fn15()
		local str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

		return {
			encode = function(arg)
				return (arg:gsub(".", function(arg2)
					local v_13 = arg2:byte()
					local str2 = ""

					for i = 8, 1, -1 do
						str2 ..= v_13 % 2 ^ i - v_13 % 2 ^ (i - 1) > 0 and "1" or "0"
					end

					return str2
				end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(arg2)
					if #arg2 < 6 then
						return ""
					end
					local n5 = 0

					for i = 1, 6 do
						n5 += arg2:sub(i, i) == "1" and 2 ^ (6 - i) or 0
					end

					return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(n5 + 1, n5 + 1)
				end) .. ({ "", "==", "=" })[#arg % 3 + 1]
			end,
			decode = function(arg)
				return string.gsub(arg, "[^" .. str .. "=]", ""):gsub(".", function(arg2)
					if arg2 == "=" then
						return ""
					end
					local n5 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(arg2) - 1
					local str2 = ""

					for i = 6, 1, -1 do
						str2 ..= n5 % 2 ^ i - n5 % 2 ^ (i - 1) > 0 and "1" or "0"
					end

					return str2
				end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(arg2)
					if #arg2 ~= 8 then
						return ""
					end
					local n5 = 0

					for i = 1, 8 do
						n5 += arg2:sub(i, i) == "1" and 2 ^ (8 - i) or 0
					end

					return string.char(n5)
				end)
			end,
		}
	end

	fn15()

	local function fn16(arg)
		local v_13 = nil

		if pcall(function()
			if getgenv().ExploitReq then
				v_13 = getgenv().ExploitReq({
					Url = ("%s/data/recent?name=%s&limit=%s"):format("https://raw.banana-hub.xyz/api", arg, 100):gsub(" ", "%20"),
					Method = "GET",
				})
			end
		end) and v_13 and v_13.Body then
			return v_13.Body
		end

		return false
	end

	local now = nil

	SpecialHop = function(arg)
		if getgenv().Key and #getgenv().Key == 32 then
			return
		end

		if now and tick() - now < 5 then
			return
		end
		local tbl15 = {}
		local v_13 = fn16(arg, 700)
		if not v_13 then
			return
		end
		Servers = game:GetService("HttpService"):JSONDecode(v_13)

		for k, v_14 in next, Servers.data, nil do
			v_14 = v_14 and v_14.name == arg

			if v_14 then
				table.insert(tbl15, k)
			end
		end

		now = tick()

		if #tbl15 > 0 then
			local tbl16 = {}

			for _, v_14 in next, Servers.data, nil do
				if v_14 and v_14.name == arg then
					local jobid = v_14.jobid
					local players = v_14.Players
					local placeid = v_14.placeid
					local v_15
					v_15, v_15 = chunk()

					if string.find(jobid, "BananaCat") then
						jobid = v_15(jobid)
					end

					if jobid and jobid ~= game.JobId and not table.find(tbl16, jobid) and not CheckIsplayingRaid() and not Settings[jobid] and (players and players < game.Players.MaxPlayers or not v_14.Players) and (placeid and game.PlaceId == placeid or not placeid) then
						table.insert(tbl16, jobid)
						game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", tostring(jobid))
						SaveSettings(tostring(jobid), true)

						if getgenv().limit_type then
							getgenv().limit_type("clearAll")
						end
					end
				end
			end
		end
	end

	local cframe = CFrame.new(-2144.967041015625, 70.377159118652344, -12399.751953125)
	local tbl15 = { "Cake Prince", "Dough King" }

	local function fn17()
		local main = nil

		pcall(function()
			main = workspace.Map.CakeLoaf.BigMirror.Main
		end)

		if main and main:IsA("BasePart") then
			return main.CFrame
		end
		return cframe
	end

	local function fn18()
		local ok, result = pcall(function()
			return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
		end)

		if not ok or not result then
			return "unknown", 999
		end
		local str = tostring(result)
		return str, (tonumber(string.match(str, "%d+")))
	end

	local function fn19()
		local v_13 = CheckNameBoss(tbl15)
		if v_13 and IsMobAlive(v_13) then
			return true, v_13, 0, "Boss Alive"
		end
		local v_14, n5 = fn18()

		if v_14 ~= "unknown" then
			if n5 == nil or n5 <= 0 or v_14:find("open the portal") or v_14:find("already opened") or v_14:find("dimension") or v_14:find("Cake Prince") or v_14:find("Dough King") then
				n5 = n5 or 0
				return true, nil, n5, v_14
			end
		end

		return false, nil, n5 or 999, v_14
	end

	FarmMethod = function()
		if Settings["Auto Elite Hunter"] or Settings["Hop Server Elite Hunter"] then
			return
		end
		local selectMethodFarm = Settings["Select Method Farm"]
		local tbl16, str, n5

		if selectMethodFarm == "Farm Katakuri" then
			tbl16 = tbl8
			str = "CakeQuest2"
			n5 = 2275
		elseif selectMethodFarm == "Farm Bones" then
			tbl16 = tbl5
			str = "HauntedQuest2"
			n5 = 2050
		elseif selectMethodFarm == "Farm Tyrant of the Skies" then
			tbl16 = tbl10
			str = "TikiQuest3"
			n5 = 2575
		else
			local flag2 = selectMethodFarm == "Aura Farm" and DetectMobAura()
			tbl16 = nil
			str = nil
			n5 = 9999

			if flag2 then
				tbl16 = { DetectMobAura() }
				str = nil
			end
		end

		local v_13 = GetNameDoubleQuest()
		tbl16 = tbl16 or v_13 or ""

		if fn10() and (not tbl16 or tbl16 == "") then
			if getgenv().NameMobQuest and getgenv().NameMobQuest ~= "" then
				tbl16 = getgenv().NameMobQuest
			else
				local v_14 = fn11(localPlayer.Data.Level.Value)

				if v_14 and v_14.Mob then
					tbl16 = v_14.Mob
				end
			end
		end

		if not fn10() and typeof(tbl16) == "string" then
			TakeQuestLevel()
		else
			if Settings["Auto Quest [Katakuri/Bone/Tyrant]"] and localPlayer.Data.Level.Value >= n5 and not fn10() then
				local flag2

				if Settings["Select Method Farm"] == "Farm Katakuri" and not Settings["Ignore Attack Katakuri"] then
					flag2 = false

					if fn19() then
						flag2 = true
					end
				else
					local flag3 = Settings["Select Method Farm"] == "Farm Tyrant of the Skies" and CheckNameBoss("Tyrant of the Skies")
					flag2 = false

					if flag3 then
						flag2 = true
					end
				end

				if not flag2 then
					QuestBoneAndkatakuri(str, 2)
					return
				end
			end

			if Settings["Select Method Farm"] == "Farm Tyrant of the Skies" then
				if CheckNameBoss("Tyrant of the Skies") then
					local v_14 = CheckNameBoss("Tyrant of the Skies")

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_14)

							if game:GetService("Players").LocalPlayer.PlayerGui.TransformationHUD.ImageLabel.Visible and (Settings["Auto Finish Train Quest"] or Settings["Auto Finish Train Draco Quest"]) then
								toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							elseif Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							UsedualFlock()
							ClickM1(v_14)
							if not (not IsMobAlive(v_14) or not Settings["Start Farm"] or not StackFarm) then
								continue
							end
						end

						break
					end

					return
				end

				local islandModel = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("TikiOutpost", true) and workspace.Map.TikiOutpost:FindFirstChild("IslandModel", true)

				if islandModel then
					local eye1 = islandModel:FindFirstChild("Eye1", true)
					local eye2 = islandModel:FindFirstChild("Eye2", true)
					local eye3 = islandModel:FindFirstChild("Eye3", true)
					local eye4 = islandModel:FindFirstChild("Eye4", true)

					if eye1 and eye2 and eye3 and eye4 and eye1.Transparency == 0 and eye2.Transparency == 0 and eye3.Transparency == 0 and eye4.Transparency == 0 then
						local v_14 = DetectModelDestroyTyrant()

						if v_14 then
							if localPlayer:DistanceFromCharacter(v_14.WorldPivot.Position) > 10 then
								toTarget(v_14.WorldPivot)
							elseif CheckItemInventory("Skull Guitar") then
								if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Skull Guitar" then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Skull Guitar" }))
								else
									equiptool(NameWeapon("Gun"))
									local worldPivot = v_14.WorldPivot
									getgenv().SpamGunSkullGuitar(worldPivot)
								end
							else
								local worldPivot = v_14.WorldPivot
								getgenv().AimPos = worldPivot
								AutoAllSkill()
							end
						end

						return
					end
				end
			end

			if Settings["Select Method Farm"] == "Farm Katakuri" and not Settings["Ignore Attack Katakuri"] then
				local v_14, v_15 = fn19()

				if v_14 then
					if v_15 and IsMobAlive(v_15) then
						local v_16 = fn17()

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if IsMobAlive(v_15) then
									local humanoidRootPart2 = v_15:FindFirstChild("HumanoidRootPart") or v_15:IsA("Model") and v_15.PrimaryPart

									if humanoidRootPart2 then
										local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart3 and (humanoidRootPart3.Position - humanoidRootPart2.Position).Magnitude > 250 and (humanoidRootPart3.Position - v_16.Position).Magnitude > 50 then
											toTarget(v_16)
										else
											sizepart(v_15)

											if game:GetService("Players").LocalPlayer.PlayerGui.TransformationHUD.ImageLabel.Visible and (Settings["Auto Finish Train Quest"] or Settings["Auto Finish Train Draco Quest"]) then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
											elseif Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, getgenv().YPosFruit or 20, 0))
											else
												toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
											end

											UsedualFlock()
											ClickM1(v_15)
										end

										if not (not IsMobAlive(v_15) or not Settings["Start Farm"] or not StackFarm or Settings["Ignore Attack Katakuri"]) then
											continue
										end
									end
								end
							end

							break
						end

						return
					end

					if DetectItemPlr("Sweet Chalice") then
						equiptool("Sweet Chalice")
						task.wait(0.2)
					end

					pcall(function()
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
					end)

					local v_16 = fn17()
					toTarget(v_16)
					return
				end

				spawn(function()
					if Settings["Hop Find Katakuri"] then
						SpecialHop("Cake Prince")
					end
				end)
			end

			local v_14 = DetectMob(tbl16)

			if not v_14 then
				if typeof(tbl16) == "table" then
					if #tbl16 <= #tbl4 then
						tbl4 = {}
						return
					end
					local v_15 = DetectNameTablePart(tbl16)
					local v_16 = DetectPartSpawnMob(v_15)

					if v_16 then
						table.insert(tbl4, v_15)

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_16.CFrame * CFrame.new(0, 60, 0))
								if not ((v_16.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl16) or not Settings["Start Farm"] or not StackFarm) then
									continue
								end
							end

							break
						end

						wait(1)
					end
				else
					local v_15 = DetectPartSpawnMob(tbl16, true)

					if v_15 then
						Instance.new("IntValue", v_15).Name = "Ignored"

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_15.CFrame * CFrame.new(0, 60, 0))
								if not ((v_15.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl16) or not Settings["Start Farm"] or not StackFarm) then
									continue
								end
							end

							break
						end

						wait(1)
					else
						DeleteIgnoredMobSpawn()
					end
				end
			else
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(v_14)
						BringMob(v_14)
						FarmMastery(v_14)
						ClickM1(v_14)
						local humanoidRootPart2 = v_14:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart2 then
							if game:GetService("Players").LocalPlayer.PlayerGui.TransformationHUD.ImageLabel.Visible and (Settings["Auto Finish Train Quest"] or Settings["Auto Finish Train Draco Quest"]) then
								toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
							elseif Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, getgenv().YPosFruit, 0))
							else
								toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_14) or not Settings["Start Farm"] or not StackFarm or Settings["Select Method Farm"] == "Farm Katakuri" and not Settings["Ignore Attack Katakuri"] and CheckNameBoss(tbl15) ~= nil) then
								continue
							end
						end
					end

					break
				end

				if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
					getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
				end
			end
		end
	end

	FarmMaterial = function()
		if Settings["Auto Elite Hunter"] or Settings["Hop Server Elite Hunter"] then
			return
		end
		local selectMaterial = Settings["Select Material"]
		if not selectMaterial or not NameMaterials[selectMaterial] then
			return
		end

		if NameWorldMaterials[selectMaterial] and not NameWorldMaterials[selectMaterial][game.PlaceId] then
			local v_13 = NameWorldMaterials[selectMaterial][getgenv().CheckPlaceId2] or NameWorldMaterials[selectMaterial][getgenv().CheckPlaceId3] or NameWorldMaterials[selectMaterial][getgenv().CheckPlaceId]

			if v_13 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(v_13)
			end

			return
		end

		local v_13 = NameMaterials[selectMaterial]
		local v_14 = DetectMob(v_13)

		if not v_14 then
			if typeof(v_13) == "table" then
				if #v_13 <= #tbl6 then
					tbl6 = {}
					return
				end
				local v_15 = fn7(v_13)
				local v_16 = v_15 and DetectPartSpawnMob(v_15)

				if v_16 then
					table.insert(tbl6, v_15)

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_16.CFrame * CFrame.new(0, 60, 0))
							if not ((v_16.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(v_13) or not Settings["Farm Material"] or not StackFarm) then
								continue
							end
						end

						break
					end

					task.wait(1)
				end
			else
				local v_15 = DetectPartSpawnMob(v_13, true)

				if v_15 then
					Instance.new("IntValue", v_15).Name = "Ignored"

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_15.CFrame * CFrame.new(0, 60, 0))
							if not ((v_15.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(v_13) or not Settings["Farm Material"] or not StackFarm) then
								continue
							end
						end

						break
					end

					task.wait(1)
				else
					DeleteIgnoredMobSpawn()
				end
			end
		else
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					sizepart(v_14)
					BringMob(v_14)
					FarmMastery(v_14)
					ClickM1(v_14)
					local humanoidRootPart2 = v_14:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart2 then
						local visible = game:GetService("Players").LocalPlayer.PlayerGui.TransformationHUD.ImageLabel.Visible
						local autoFinishTrainQuest

						if visible then
							autoFinishTrainQuest = Settings["Auto Finish Train Quest"] or Settings["Auto Finish Train Draco Quest"]
						else
							autoFinishTrainQuest = visible
						end

						if autoFinishTrainQuest then
							toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
						elseif Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, getgenv().YPosFruit or 20, 0))
						else
							toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
						end

						if not (not IsMobAlive(v_14) or not Settings["Farm Material"] or not StackFarm) then
							continue
						end
					end
				end

				break
			end

			if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
				getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
			end
		end
	end

	spawn(function()
		while task.wait() do
			local ok, result = pcall(function()
				if Settings["Farm Material"] and StackFarm then
					FarmMaterial()
				elseif Settings["Start Farm"] and StackFarm then
					FarmMethod()
				end
			end)

			if result then
				print(result)
			end
		end
	end)

	stackFarmMain = Main.CreatePage({ Page_Name = "Stack Farming", Page_Title = "Stack Farming" })
	AutoWorldSection = stackFarmMain.CreateSection("Auto World")

	AutoWorldSection.CreateToggle({ Title = "Auto New World", Desc = nil, Default = Settings["Auto New World"] or false }, function(arg)
		SaveSettings("Auto New World", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	AutoWorldSection.CreateToggle({ Title = "Auto Third World", Desc = nil, Default = Settings["Auto Third World"] or false }, function(arg)
		SaveSettings("Auto Third World", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	getgenv().GetTime = nil
	NotiGetTime = true

	timeToSeconds = function(arg)
		local match, match2, v_13 = arg:match("^(%d+):(%d+):(%d+)$")

		if not match then
			match2, v_13 = arg:match("^(%d+):(%d+)$")
			match = 0
		end

		return tonumber(match) * 3600 + tonumber(match2) * 60 + tonumber(v_13)
	end

	secondsToTime = function(arg)
		return string.format("%d:%02d:%02d", math.floor(arg / 3600), math.floor(arg % 3600 / 60), arg % 60)
	end

	DetectPresent = function()
		local backpack = localPlayer:FindFirstChild("Backpack")

		if backpack then
			for _, v_13 in backpack:GetChildren() do
				if string.find(v_13.Name, "Holiday Gift") then
					return v_13
				end
			end
		end

		if localPlayer.Character then
			for _, v_13 in localPlayer.Character:GetChildren() do
				if string.find(v_13.Name, "Holiday Gift") then
					return v_13
				end
			end
		end
	end

	DetectPresentStore = function()
		local backpack = localPlayer:FindFirstChild("Backpack")

		if backpack then
			for _, v_13 in backpack:GetChildren() do
				if string.find(v_13.Name, "Holiday Gift") and not v_13:FindFirstChild("Ignored") then
					return v_13
				end
			end
		end

		if localPlayer.Character then
			for _, v_13 in localPlayer.Character:GetChildren() do
				if string.find(v_13.Name, "Holiday Gift") and not v_13:FindFirstChild("Ignored") then
					return v_13
				end
			end
		end
	end

	GetCountDownTime = function()
		if not getgenv().GetTime and not game.workspace:FindFirstChild("Countdown") then
			return "Go Get Time"
		end

		if workspace:FindFirstChild("Countdown") and workspace.Countdown.SurfaceGui.TextLabel.Text:find("START") then
			return 0
		end
		local text = workspace:FindFirstChild("Countdown") and workspace.Countdown.SurfaceGui.TextLabel.Text or secondsToTime(getgenv().GetTime)
		if tonumber(text:split(":")[1]) == 0 then
			return tonumber(text:split(":")[2])
		end
		return 55
	end

	getGift = function()
		if not workspace._WorldOrigin:FindFirstChild("Present") then
			return
		end

		for _, child in pairs(workspace._WorldOrigin:GetChildren()) do
			if child.Name == "Present" and child:FindFirstChild("Highlight") and child:FindFirstChild("Box") and child.Box:FindFirstChild("ProximityPrompt") then
				return child
			end
		end
	end

	StackDevilFruitSection = stackFarmMain.CreateSection("Devil Fruit")

	StackDevilFruitSection.CreateToggle({
		Title = "Collect Chest When Server Spawn\nGod's Chalice or Fist of Darkness",
		Desc = nil,
		Default = Settings["Collect Chest When Server Spawn God's Chalice or Fist of Darkness"] or false,
	}, function(arg)
		SaveSettings("Collect Chest When Server Spawn God's Chalice or Fist of Darkness", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	StackDevilFruitSection.CreateToggle({ Title = "Teleport To Fruit", Desc = nil, Default = Settings["Teleport To Fruit"] or false }, function(arg)
		SaveSettings("Teleport To Fruit", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	StackDevilFruitSection.CreateToggle({
		Title = "Teleport To Fruit [ Hop Server ]",
		Desc = nil,
		Default = Settings["Teleport To Fruit [ Hop Server ]"] or false,
	}, function(arg)
		SaveSettings("Teleport To Fruit [ Hop Server ]", arg)
	end)

	EventGameSection = stackFarmMain.CreateSection("Event Game")

	EventGameSection.CreateToggle({ Title = "Auto Factory", Desc = nil, Default = Settings["Auto Factory"] or false }, function(arg)
		SaveSettings("Auto Factory", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	EventGameSection.CreateToggle({ Title = "Auto Pirate Raid", Desc = nil, Default = Settings["Auto Pirate Raid"] or false }, function(arg)
		SaveSettings("Auto Pirate Raid", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossRipIndraSection = stackFarmMain.CreateSection("Boss Rip Indra")

	BossRipIndraSection.CreateToggle({ Title = "Auto Elite Hunter", Desc = nil, Default = Settings["Auto Elite Hunter"] or false }, function(arg)
		SaveSettings("Auto Elite Hunter", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossRipIndraSection.CreateToggle({
		Title = "Hop Server Elite Hunter",
		Desc = "Hop if u have God chalice and teleport in safezone",
		Default = Settings["Hop Server Elite Hunter"] or false,
	}, function(arg)
		SaveSettings("Hop Server Elite Hunter", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossRipIndraSection.CreateToggle({
		Title = "Auto Touch Pad Haki",
		Desc = nil,
		Default = Settings["Auto Touch Pad Haki"] or false,
	}, function(arg)
		SaveSettings("Auto Touch Pad Haki", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossRipIndraSection.CreateToggle({
		Title = "Auto Summon Rip Indra",
		Desc = nil,
		Default = Settings["Auto Summon Rip Indra"] or false,
	}, function(arg)
		SaveSettings("Auto Summon Rip Indra", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossRipIndraSection.CreateToggle({ Title = "Attack Rip Indra", Desc = nil, Default = Settings["Attack Rip Indra"] or false }, function(arg)
		SaveSettings("Attack Rip Indra", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossSoulReaperSection = stackFarmMain.CreateSection("Boss Soul Reaper")

	BossSoulReaperSection.CreateToggle({ Title = "Attack Soul Reaper", Desc = nil, Default = Settings["Attack Soul Reaper"] or false }, function(arg)
		SaveSettings("Attack Soul Reaper", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossSoulReaperSection.CreateToggle({ Title = "Summon Soul Reaper", Desc = nil, Default = Settings["Summon Soul Reaper"] or false }, function(arg)
		SaveSettings("Summon Soul Reaper", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossDoughKingSection = stackFarmMain.CreateSection("Boss Dough King")

	BossDoughKingSection.CreateToggle({ Title = "Attack Dough King", Desc = nil, Default = Settings["Attack Dough King"] or false }, function(arg)
		SaveSettings("Attack Dough King", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossDoughKingSection.CreateToggle({ Title = "Summon Dough King", Desc = nil, Default = Settings["Summon Dough King"] or false }, function(arg)
		if arg and not Settings["Attack Dough King"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Attack Dough King Plz", ShowTime = 5 })
		end

		if arg then
			spawn(function()
				while Settings["Summon Dough King"] and task.wait() do
					if DetectItemPlr("Sweet Chalice") then
						game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
					end
				end
			end)
		end

		SaveSettings("Summon Dough King", arg)
	end)

	BossDoughKingSection.CreateToggle({
		Title = "Hop Find Dough King",
		Desc = nil,
		Default = Settings["Hop Find Dough King"] or false,
	}, function(arg)
		if arg and not Settings["Attack Dough King"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Attack Dough King Plz", ShowTime = 5 })
		end

		SaveSettings("Hop Find Dough King", arg)
	end)

	BossDarkbeardSection = stackFarmMain.CreateSection("Boss Darkbeard")

	BossDarkbeardSection.CreateToggle({ Title = "Attack Darkbeard", Desc = nil, Default = Settings["Attack Darkbeard"] or false }, function(arg)
		SaveSettings("Attack Darkbeard", arg)

		if not arg then
			TweenManager.CancelCurrent()
		end
	end)

	BossDarkbeardSection.CreateToggle({ Title = "Summon Darkbeard", Desc = nil, Default = Settings["Summon Darkbeard"] or false }, function(arg)
		if arg and not Settings["Attack Darkbeard"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Attack Darkbeard Plz", ShowTime = 5 })
		end

		SaveSettings("Summon Darkbeard", arg)
	end)

	BossDarkbeardSection.CreateToggle({ Title = "Hop Find Darkbeard", Desc = nil, Default = Settings["Hop Find Darkbeard"] or false }, function(arg)
		if arg and not Settings["Attack Darkbeard"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Attack Darkbeard Plz", ShowTime = 5 })
		end

		SaveSettings("Hop Find Darkbeard", arg)
	end)

	GetPathFruit = function()
		local v_13 = next
		local children, v_14 = game.Workspace:GetChildren()

		for _, v_15 in v_13, children, v_14 do
			if (v_15:IsA("Tool") or v_15:IsA("Model")) and string.find(v_15.Name, "Fruit") and v_15:FindFirstChild("Handle") then
				return v_15
			end
		end
	end

	GetPirateRaid = function(arg)
		local v_13 = ipairs
		local replicatedStorage

		if arg then
			replicatedStorage = game.ReplicatedStorage
		else
			replicatedStorage = game.workspace.Enemies
		end

		for _, child in v_13(replicatedStorage:GetChildren()) do
			if child:IsA("Model") and child.Name ~= "Oni2" and not string.find(child.Name, "Boss") and not string.find(child.Name, "Friend") and not string.find(child.Name, "Wraith") and child.Name ~= "rip_indra True Form" and IsMobAlive(child) and (child.HumanoidRootPart.Position - Vector3.new(-5543, 313, -2964)).magnitude < 1000 then
				return child
			end
		end
	end

	DetectButtons = function()
		local v_13 = next
		local children, v_14 = game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:GetChildren()

		for _, v_15 in v_13, children, v_14 do
			if v_15:IsA("Part") and v_15.Part.BrickColor.Name ~= "Lime green" then
				return v_15
			end
		end
	end

	local tbl16 = { "Winter Sky", "Pure Red", "Snow White" }

	IsMisisngLegHaki = function(arg)
		local tbl17 = arg and {}
		local response = nil

		pcall(function()
			response = CommF:InvokeServer("getColors")
		end)

		if type(response) ~= "table" then
			return tbl17 or nil
		end
		local hiddenName = nil

		for _, v_13 in pairs(response) do
			if type(v_13) == "table" and v_13.HiddenName and table.find(tbl16, v_13.HiddenName) and not v_13.Unlocked then
				if tbl17 then
					table.insert(tbl17, v_13.HiddenName)
				elseif not hiddenName then
					hiddenName = v_13.HiddenName
				else
					hiddenName ..= ", " .. v_13.HiddenName
				end
			end
		end

		if tbl17 then
			return tbl17
		end
		return hiddenName
	end

	TouchPadHaki = function()
		local v_13 = DetectButtons()

		if v_13 then
			local function fn20(arg)
				pcall(function()
					local modules2 = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
					modules2 = modules2 and modules2:FindFirstChild("Net")
					modules2 = modules2 and modules2:FindFirstChild("RF/FruitCustomizerRF")

					if modules2 then
						modules2:InvokeServer({ StorageName = arg, Type = "AuraSkin", Context = "Equip" })
					end
				end)

				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", arg)
				end)
			end

			local name = v_13:FindFirstChild("Part") and v_13.Part:IsA("BasePart") and v_13.Part.BrickColor.Name or v_13:IsA("BasePart") and v_13.BrickColor.Name or ""

			if name == "Hot pink" then
				fn20("Winter Sky")
				toTarget(v_13.CFrame)
				wait(2)
			elseif name == "Really red" then
				fn20("Pure Red")
				toTarget(v_13.CFrame)
				wait(2)
			elseif name == "Oyster" then
				fn20("Snow White")
				toTarget(v_13.CFrame)
				wait(2)
			end
		end
	end

	getgenv().CheckCountItem = function(arg, arg2)
		local v_13 = next
		local v_14, v_15 = fn6()

		for _, v_16 in v_13, v_14, v_15 do
			if v_16.Name == arg and v_16.Count and v_16.Count >= arg2 then
				return true
			end
		end

		return false
	end

	CheckCountItem = getgenv().CheckCountItem

	getbackpack = function()
		mybackpack = {}
		local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")

		if backpack then
			for _, child in pairs(backpack:GetChildren()) do
				if child:IsA("Tool") and table.find(whitelistedfruit, child.Name) then
					table.insert(mybackpack, child.Name)
				end
			end
		end

		local character = game.Players.LocalPlayer.Character

		if character then
			for _, child in pairs(character:GetChildren()) do
				if child:IsA("Tool") and table.find(whitelistedfruit, child.Name) then
					table.insert(mybackpack, child.Name)
				end
			end
		end

		return mybackpack
	end

	CheckFruitplr = function()
		local backpack = localPlayer:FindFirstChild("Backpack")
		local name = nil

		if backpack then
			name = nil

			for _, child in pairs(backpack:GetChildren()) do
				if string.find(child.Name, "Fruit") then
					name = child.Name
				end
			end
		end

		if localPlayer.Character then
			for _, child in pairs(localPlayer.Character:GetChildren()) do
				if string.find(child.Name, "Fruit") then
					name = child.Name
				end
			end
		end

		return name
	end

	TakeFruitInventory = function(arg)
		local v_13 = next
		local v_14, v_15 = fn6()
		local huge = math.huge
		local v_16 = nil

		for _, v_17 in v_13, v_14, v_15 do
			if v_17.Type ~= "Blox Fruit" then
				continue
			end

			if not arg then
				for k, v_18 in pairs(getgenv().tablefruitausea3) do
					if v_17.Name == k then
						if tonumber(v_18) < tonumber(huge) then
							huge = v_18
							v_16 = k
						end
					end
				end

				continue
			end

			local name = v_17.Name
			if not getgenv().tablefruitausea3[name] then
				return v_17.Name
			end
		end

		return v_16
	end

	cframethangdaubuoiredhead = CFrame.new(-1926.78772, 12.1678171, 1739.80884, 0.956294656, 0, -0.292404652, 0, 1, 0, 0.292404652, 0, 0.956294656)

	StopThirdSea = function()
		if game.PlaceId == getgenv().CheckPlaceId2 and localPlayer.Data.Level.Value >= 1500 then
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 3 then
				return true
			end

			if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1") ~= 0 then
				if #getbackpack() >= 1 then
					return true
				end

				if not CheckFruitplr() and TakeFruitInventory() then
					StopStoreFruit = true
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", TakeFruitInventory())
				end
			elseif not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") then
				if CheckNameBoss("Don Swan") then
					return true
				end
			elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
				return true
			end
		end
	end

	checkplatebarito = function()
		local str

		if game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate1.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate1"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate2.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate2"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate3.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate3"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate4.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate4"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate5.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate5"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate6.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate6"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate7.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate7"
		elseif game:GetService("Workspace").Map.Dressrosa.BartiloPlates.Plate8.BrickColor == BrickColor.new("Sand yellow") then
			str = "Plate8"
		else
			str = nil
		end

		return str
	end

	AutoQuestBarito = function()
		if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
			if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
				local v_13 = DetectMob("Swan Pirate")

				if not v_13 then
					if typeof("Swan Pirate") == "table" then
						if #tbl4 >= 11 then
							tbl4 = {}
							return
						end
						local v_14 = DetectPartSpawnMob(DetectNameTablePart("Swan Pirate"))

						if v_14 then
							table.insert(tbl4, DetectNameTablePart("Swan Pirate"))

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
									if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Swan Pirate")) then
										continue
									end
								end

								break
							end

							wait(1)
						end
					else
						local v_14 = DetectPartSpawnMob("Swan Pirate", true)

						if v_14 then
							Instance.new("IntValue", v_14).Name = "Ignored"

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
									if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Swan Pirate")) then
										continue
									end
								end

								break
							end

							wait(1)
						else
							DeleteIgnoredMobSpawn()
						end
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_13)
							BringMob(v_13)
							UsedualFlock()
							ClickM1(v_13)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if IsMobAlive(v_13) then
								continue
							end
						end

						break
					end
				end
			elseif (localPlayer.Character.HumanoidRootPart.Position - CFrame.new(-456.28952, 73.0200958, 299.895966).Position).Magnitude > 8 then
				toTarget(CFrame.new(-456.28952, 73.0200958, 299.895966))
			else
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "StartQuest", "BartiloQuest", 1 }))
			end
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
			local Jeremy = CheckNameBoss("Jeremy")

			if Jeremy then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(Jeremy)
						UsedualFlock()
						ClickM1(Jeremy)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(Jeremy.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(Jeremy.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						if IsMobAlive(Jeremy) then
							continue
						end
					end

					break
				end
			end
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if (localPlayer.Character.HumanoidRootPart.Position - Vector3.new(-1835.65, 10.4325, 1679.75)).Magnitude > 100 then
						toTarget(CFrame.new(-1835.65, 10.4325, 1679.75))
					else
						localPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.Dressrosa.BartiloPlates[checkplatebarito()].CFrame
						task.wait()
						firetouchinterest(game:GetService("Workspace").Map.Dressrosa.BartiloPlates[checkplatebarito()], game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
						firetouchinterest(game:GetService("Workspace").Map.Dressrosa.BartiloPlates[checkplatebarito()], game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
					end

					if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 3 then
						continue
					end
				end

				break
			end
		end
	end

	SeaThird = function()
		if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou") == 0 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
		end

		if game.PlaceId == getgenv().CheckPlaceId2 and localPlayer.Data.Level.Value >= 1500 then
			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 then
				if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1") ~= 0 then
					if #getbackpack() >= 1 then
						toTarget(CFrame.new(-339.79840087891, 331.86065673828, 643.83178710938))

						if (Vector3.new(-339.7984, 331.86066, 643.8318) - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
							if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1") ~= 1 then
								local v_13 = next
								local v_14, v_15 = getbackpack()

								for _, v_16 in v_13, v_14, v_15 do
									localPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(v_16))
								end

								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TalkTrevor", "1")
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TalkTrevor", "2")
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TalkTrevor", "3")
							end
						end
					elseif not CheckFruitplr() and TakeFruitInventory() then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", TakeFruitInventory())
					end
				elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1") == 0 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou") == 0 then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
				elseif not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") then
					if CheckNameBoss("Don Swan") then
						local v_13 = CheckNameBoss("Don Swan")

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_13)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								UsedualFlock()
								ClickM1(v_13)
								if not (not v_13 or not v_13.Parent or v_13.Humanoid.Health == 0) then
									continue
								end
							end

							break
						end
					end
				elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
					if (localPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace").Map.IndraIsland.Part.Position).Magnitude > 1000 then
						toTarget(cframethangdaubuoiredhead)

						if (cframethangdaubuoiredhead.p - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
						end
					else
						local v_13 = next
						local children, v_14 = workspace.Enemies:GetChildren()

						for _, v_15 in v_13, children, v_14 do
							if v_15.Name == "rip_indra" and v_15:FindFirstChild("HumanoidRootPart") and v_15:FindFirstChild("Humanoid") and v_15.Humanoid.Health > 0 then
								if (v_15.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 300 then
									toTarget(v_15.HumanoidRootPart.CFrame)
								else
									while true do
										task.wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											sizepart(v_15)

											if Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(v_15.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
											else
												toTarget(v_15.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
											end

											ClickM1(v_15)
											UsedualFlock()
											if workspace.Enemies:FindFirstChild("rip_indra") then
												continue
											end
										end

										break
									end
								end
							end
						end
					end
				end
			else
				AutoQuestBarito()
			end
		end
	end

	n3 = 0

	PathFindChest = function()
		local v_13 = next
		local children, v_14 = game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()

		for _, v_15 in v_13, children, v_14 do
			if v_15:IsA("Model") and v_15:FindFirstChild("Part") and not v_15:FindFirstChild("Ignored") then
				return v_15
			end
		end
	end

	GetNearestChest = function()
		local v_13 = next
		local tagged, v_14 = game:GetService("CollectionService"):GetTagged("_ChestTagged")
		local huge = math.huge
		local v_15 = nil

		for _, v_16 in v_13, tagged, v_14 do
			if not v_16:GetAttribute("IsDisabled") and not v_16:FindFirstChild("Ignored") then
				local v_17 = localPlayer:DistanceFromCharacter(v_16.Position)

				if v_17 < huge then
					huge = v_17
					v_15 = v_16
				end
			end
		end

		return v_15
	end

	getgenv().DetectRaidCastle = false
	getgenv().ValueCollectChestSpawnGod = 0

	task.spawn(function()
		while task.wait() do
			local ok, result = pcall(function()
				if Settings["Auto New World"] then
					if game.PlaceId == getgenv().CheckPlaceId3 and localPlayer.Data.Level.Value >= 700 then
						StackFarm = false
						StackFarmOther = false

						if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa") ~= 0 then
							if game.Workspace.Map.Ice.Door.CanCollide then
								if not localPlayer.Character:FindFirstChild("Key") and not localPlayer.Backpack:FindFirstChild("Key") then
									local position = localPlayer.Character.HumanoidRootPart.Position

									if (CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359).Position - position).magnitude < 5 then
										game.ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
										equiptool("Key")
									else
										toTarget(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359))
									end
								else
									equiptool("Key")

									if localPlayer.Character:FindFirstChild("Key") then
										toTarget(game.Workspace.Map.Ice.Door.CFrame)
									end
								end
							elseif CheckNameBoss("Ice Admiral") then
								local v_13 = CheckNameBoss("Ice Admiral")

								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_13)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										ClickM1(v_13)
										UsedualFlock()
										if not (not v_13 or not v_13.Parent or v_13.Humanoid.Health == 0 or not Settings["Auto New World"]) then
											continue
										end
									end

									break
								end
							end
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
						end

						return
					end
				end

				if Settings["Collect Chest When Server Spawn God's Chalice or Fist of Darkness"] and getgenv().GoCollectChest then
					StackFarm = false
					StackFarmOther = false

					if getgenv().ValueCollectChestSpawnGod >= 10 then
						getgenv().GoCollectChest = false
						getgenv().ValueCollectChestSpawnGod = 0
					end

					local v_13 = GetNearestChest()

					if v_13 then
						getgenv().ValueCollectChestSpawnGod = getgenv().ValueCollectChestSpawnGod + 1
						local now2 = nil

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v_13.Position).Magnitude <= 5 then
									if not now2 then
										now2 = tick()
									elseif tick() - now2 >= 5 then
										Instance.new("IntValue", v_13).Name = "Ignored"
										wait(0.1)
									end

									if not Settings["Use Method Teleport"] then
										game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
										wait()
										game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
									end

									TweenManager.CancelCurrent()
								end

								if Settings["Use Method Teleport"] then
									localPlayer.Character.HumanoidRootPart.CFrame = v_13.CFrame
									TweenManager.CancelCurrent()
								else
									toTarget(v_13.CFrame, true)
								end

								if not (not v_13 or not v_13.Parent or not Settings["Collect Chest When Server Spawn God's Chalice or Fist of Darkness"] or v_13:GetAttribute("IsDisabled") or v_13:FindFirstChild("Ignored") or not v_13:FindFirstChild("TouchInterest")) then
									continue
								end
							end

							break
						end

						return
					end

					local v_14 = PathFindChest()

					if v_14 then
						toTarget(v_14.Part.CFrame)

						if (v_14.Part.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or GetNearestChest() then
							Instance.new("IntValue", v_14).Name = "Ignored"
						end
					else
						for _, child in pairs(game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()) do
							if child:FindFirstChild("Ignored") then
								child:FindFirstChild("Ignored"):Destroy()
							end
						end
					end
				end

				if game.PlaceId == getgenv().CheckPlaceId2 and Settings["Auto Third World"] then
					if StopThirdSea() then
						StackFarm = false
						StackFarmOther = false
						SeaThird()
						return
					end
				end

				if Settings["Attack Darkbeard"] then
					local Darkbeard = CheckNameBoss("Darkbeard")

					if Darkbeard then
						StackFarm = false
						StackFarmOther = false

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(Darkbeard)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(Darkbeard.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(Darkbeard.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								ClickM1(Darkbeard)
								UsedualFlock()
								if not (not IsMobAlive(Darkbeard) or not Settings["Attack Darkbeard"]) then
									continue
								end
							end

							break
						end

						return
					end

					if Settings["Summon Darkbeard"] and DetectItemPlr("Fist of Darkness") then
						StackFarm = false
						StackFarmOther = false
						local v_13 = game
						local position = localPlayer.Character.HumanoidRootPart.Position

						if (v_13:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection.Position - position).Magnitude <= 5 then
							equiptool("Fist of Darkness")
							firetouchinterest(game.Players.LocalPlayer.Character["Fist of Darkness"].Handle, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 0)
							firetouchinterest(game.Players.LocalPlayer.Character["Fist of Darkness"].Handle, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 1)
							firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 0)
							firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 1)
						else
							toTarget(game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection.CFrame)
						end

						return
					end

					spawn(function()
						if Settings["Hop Find Darkbeard"] then
							SpecialHop("Darkbeard")
						end
					end)
				end

				if Settings["Attack Rip Indra"] then
					local v_13 = CheckNameBoss("rip_indra True Form")

					if v_13 then
						StackFarm = false
						StackFarmOther = false

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_13)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								ClickM1(v_13)
								UsedualFlock()
								if not (not IsMobAlive(v_13) or not Settings["Attack Rip Indra"]) then
									continue
								end
							end

							break
						end

						return
					end
				end

				if Settings["Auto Touch Pad Haki"] and Settings["Auto Summon Rip Indra"] then
					if DetectItemPlr("God's Chalice") then
						StackFarm = false
						StackFarmOther = false
						if not game:GetService("Workspace").Map:FindFirstChild("Boat Castle") or not game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:FindFirstChildOfClass("Part") then
							toTarget(CFrame.new(-5500, 314, -2855))
							return
						end

						if DetectButtons() then
							TouchPadHaki()
							return
						end

						if not DetectButtons() then
							equiptool("God's Chalice")
							toTarget(game:GetService("Workspace").Map["Boat Castle"].Summoner.Detection.CFrame)
							return
						end
					end
				elseif Settings["Auto Touch Pad Haki"] then
					StackFarm = false
					StackFarmOther = false
					if not game:GetService("Workspace").Map:FindFirstChild("Boat Castle") or not game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:FindFirstChildOfClass("Part") then
						toTarget(CFrame.new(-5500, 314, -2855))
						return
					end

					if DetectButtons() then
						TouchPadHaki()
						return
					end
				elseif Settings["Auto Summon Rip Indra"] and DetectItemPlr("God's Chalice") then
					StackFarm = false
					StackFarmOther = false
					if not game:GetService("Workspace").Map:FindFirstChild("Boat Castle") or not game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:FindFirstChildOfClass("Part") then
						toTarget(CFrame.new(-5500, 314, -2855))
						return
					end
					equiptool("God's Chalice")
					toTarget(game:GetService("Workspace").Map["Boat Castle"].Summoner.Detection.CFrame)
					return
				end

				if game.PlaceId == getgenv().CheckPlaceId then
					if Settings["Attack Soul Reaper"] then
						local v_13 = CheckNameBoss("Soul Reaper")

						if v_13 and v_13:FindFirstChild("HumanoidRootPart") and IsMobAlive(v_13) then
							StackFarm = false
							StackFarmOther = false

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									if IsMobAlive(v_13) then
										local humanoidRootPart2 = v_13:FindFirstChild("HumanoidRootPart") or v_13:IsA("Model") and v_13.PrimaryPart

										if humanoidRootPart2 then
											sizepart(v_13)
											UsedualFlock()

											if Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
											else
												toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
											end

											ClickM1(v_13)
											if not (not IsMobAlive(v_13) or not Settings["Attack Soul Reaper"]) then
												continue
											end
										end
									end
								end

								break
							end

							return
						end

						if CheckBossServer("Soul Reaper") then
							StackFarm = false
							StackFarmOther = false
							toTarget(CFrame.new(-9522.0957, 315.89975, 6751.88818))
							return
						end
					end

					if Settings["Summon Soul Reaper"] and DetectItemPlr("Hallow Essence") and not CheckNameBoss("Soul Reaper") then
						StackFarm = false
						StackFarmOther = false
						local detection = nil

						pcall(function()
							detection = game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection
						end)

						local cFrame2 = detection and detection:IsA("BasePart") and detection.CFrame or CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125)
						equiptool("Hallow Essence")
						toTarget(cFrame2)
						local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart2 and (humanoidRootPart2.Position - cFrame2.Position).Magnitude <= 15 then
							equiptool("Hallow Essence")

							if detection and detection:IsA("BasePart") then
								local hallowEssence = localPlayer.Character and localPlayer.Character:FindFirstChild("Hallow Essence")

								if hallowEssence and hallowEssence:FindFirstChild("Handle") then
									pcall(function()
										firetouchinterest(hallowEssence.Handle, detection, 0)
										firetouchinterest(hallowEssence.Handle, detection, 1)
									end)
								end

								pcall(function()
									firetouchinterest(humanoidRootPart2, detection, 0)
									firetouchinterest(humanoidRootPart2, detection, 1)
								end)
							end
						end

						return
					end
				end

				if Settings["Attack Dough King"] then
					local v_13 = CheckNameBoss("Dough King")

					if v_13 then
						StackFarm = false
						StackFarmOther = false

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_13)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								ClickM1(v_13)
								UsedualFlock()
								if not (not IsMobAlive(v_13) or not Settings["Attack Dough King"]) then
									continue
								end
							end

							break
						end

						return
					end

					spawn(function()
						if Settings["Hop Find Dough King"] then
							SpecialHop("Dough King")
						end
					end)

					if Settings["Summon Dough King"] then
						if not DetectItemPlr("Sweet Chalice") then
							if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SweetChaliceNpc") == "Where are the items?" then
								if not CheckCountItem("Conjured Cocoa", 10) then
									StackFarm = false
									StackFarmOther = false

									if not DetectMob(tbl9) then
										if typeof(tbl9) == "table" then
											if #tbl4 >= #tbl9 then
												tbl4 = {}
												return
											end
											local v_14 = DetectPartSpawnMob(DetectNameTablePart(tbl9))

											if v_14 then
												table.insert(tbl4, DetectNameTablePart(tbl9))

												while true do
													wait()

													if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
														toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
														if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl9) or not Settings["Attack Dough King"]) then
															continue
														end
													end

													break
												end

												wait(1)
											end
										else
											local v_14 = DetectPartSpawnMob(tbl9, true)

											if v_14 then
												Instance.new("IntValue", v_14).Name = "Ignored"

												while true do
													wait()

													if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
														toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
														if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl9) or not Settings["Attack Dough King"]) then
															continue
														end
													end

													break
												end

												wait(1)
											else
												DeleteIgnoredMobSpawn()
											end
										end
									else
										local v_14 = DetectMob(tbl9)

										while true do
											task.wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												sizepart(v_14)
												BringMob(v_14)
												UsedualFlock()
												ClickM1(v_14)

												if Settings["Select Weapon"] == "Blox Fruit" then
													toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
												else
													toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
												end

												if not (not v_14 or not v_14.Parent or v_14.Humanoid.Health == 0 or not Settings["Attack Dough King"]) then
													continue
												end
											end

											break
										end
									end
								elseif not DetectItemPlr("God's Chalice") then
									local v_14 = GetEliteMob()

									if v_14 and IsMobAlive(v_14) then
										StackFarm = false
										StackFarmOther = false
										EnsureEliteQuest(v_14.Name)

										while true do
											task.wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												sizepart(v_14)

												if Settings["Select Weapon"] == "Blox Fruit" then
													toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
												else
													toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
												end

												ClickM1(v_14)
												UsedualFlock()
												if not (not IsMobAlive(v_14) or not Settings["Attack Dough King"]) then
													continue
												end
											end

											break
										end

										return
									end

									local v_15 = GetEliteTargetCFrame()

									if v_15 then
										StackFarm = false
										StackFarmOther = false
										toTarget(v_15)
										return
									end

									lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Waiting Elite Hunter", ShowTime = 5 })
									wait(5)
								end
							end
						elseif not DetectMob(tbl8) then
							if typeof(tbl8) == "table" then
								if #tbl4 >= #tbl8 then
									tbl4 = {}
									return
								end
								local v_14 = DetectPartSpawnMob(DetectNameTablePart(tbl8))

								if v_14 then
									table.insert(tbl4, DetectNameTablePart(tbl8))

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
											if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl8) or not Settings["Attack Dough King"]) then
												continue
											end
										end

										break
									end

									wait(1)
								end
							else
								local v_14 = DetectPartSpawnMob(tbl8, true)

								if v_14 then
									Instance.new("IntValue", v_14).Name = "Ignored"

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
											if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl8) or not Settings["Attack Dough King"]) then
												continue
											end
										end

										break
									end

									wait(1)
								else
									DeleteIgnoredMobSpawn()
								end
							end
						else
							local v_14 = DetectMob(tbl8)

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(v_14)
									BringMob(v_14)
									UsedualFlock()
									ClickM1(v_14)

									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
									end

									if not (not v_14 or not v_14.Parent or v_14.Humanoid.Health == 0 or not Settings["Attack Dough King"]) then
										continue
									end
								end

								break
							end
						end
					end
				end

				if Settings["Auto Elite Hunter"] or Settings["Hop Server Elite Hunter"] then
					local v_13 = GetEliteMob()

					if v_13 and IsMobAlive(v_13) then
						StackFarm = false
						StackFarmOther = false

						if Settings["Auto Elite Hunter"] then
							EnsureEliteQuest(v_13.Name)

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									if not (Settings["Auto Elite Hunter"] or Settings["Hop Server Elite Hunter"]) then
										TweenManager.CancelCurrent()
										break
									else
										local humanoidRootPart2 = v_13:FindFirstChild("HumanoidRootPart", true) or v_13.PrimaryPart

										if humanoidRootPart2 then
											sizepart(v_13)
											UsedualFlock()
											ClickM1(v_13)

											if Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
											else
												toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
											end

											local flag2 = not IsMobAlive(v_13)

											if not flag2 then
												flag2 = not (Settings["Auto Elite Hunter"] or Settings["Hop Server Elite Hunter"])
											end

											if not flag2 then
												continue
											end
										end
									end
								end

								break
							end

							v_3 = nil
							v_4 = nil
							n = 1
							n2 = 0

							if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
								getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
							end
						end

						return
					end

					local v_14 = HasEliteQuest()
					local v_15 = GetCurrentEliteMobName()

					if not v_14 then
						if Settings["Hop Server Elite Hunter"] and not Settings["Auto Elite Hunter"] then
							if not DetectItemPlr("God's Chalice") then
								HopServer()
							else
								toTarget(CFrame.new(-12463.8740234375, 374.91445922851562, -7523.77392578125))
							end

							return
						end

						EnsureEliteQuest(v_15)
						return
					end

					local v_16 = GetEliteTargetCFrame(v_15) or GetNextElitePatrolCFrame()

					if v_16 then
						StackFarm = false
						StackFarmOther = false
						toTarget(v_16)
						return
					end
				end

				if Settings["Auto Factory"] then
					CoreBoss = CheckNameBoss("Core")

					if CoreBoss then
						StackFarm = false
						StackFarmOther = false

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(CoreBoss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
								ClickM1(CoreBoss)
								UsedualFlock()
								if not (not IsMobAlive(CoreBoss) or not Settings["Auto Factory"]) then
									continue
								end
							end

							break
						end

						return
					end
				end

				if Settings["Auto Pirate Raid"] then
					local v_13 = GetPirateRaid() or GetPirateRaid(true)

					if v_13 then
						getgenv().DetectRaidCastle = true
						StackFarm = false
						StackFarmOther = false
						local cframe2 = Settings["Select Weapon"] == "Blox Fruit" and CFrame.new(-7, 20, 0) or CFrame.new(7, 20, 0)

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								UsedualFlock()
								sizepart(v_13)
								ClickM1(v_13)
								toTarget(v_13.HumanoidRootPart.CFrame * cframe2)
								if not (not IsMobAlive(v_13) or not Settings["Auto Pirate Raid"]) then
									continue
								end
							end

							break
						end
					elseif getgenv().DetectRaidCastle then
						StackFarm = false
						StackFarmOther = false
						local now2 = os.clock()
						local flag2 = false

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if GetPirateRaid() or GetPirateRaid(true) then
									flag2 = true
								end

								if not (os.clock() - now2 >= 10 or flag2) then
									continue
								end
							end

							break
						end

						if not flag2 then
							getgenv().DetectRaidCastle = false
						end
					end
				end

				if Settings["Teleport To Fruit"] then
					local v_13 = GetPathFruit()

					if v_13 then
						StackFarm = false
						StackFarmOther = false

						if (v_13.Handle.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5 then
							getgenv().noclip = false
							game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
							wait()
							game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
						else
							toTarget(v_13.Handle.CFrame, true)
						end

						return
					end

					if Settings["Teleport To Fruit [ Hop Server ]"] then
						HopServer()
						wait(5)
					end
				end

				if not StackFarm then
					StackFarm = true
				end

				if not StackFarmOther then
					StackFarmOther = true
				end
			end)

			if result then
				print(result)
			end
		end
	end)
end

FarmotherMain = Main.CreatePage({ Page_Name = "Farming Other", Page_Title = "Farming Other" })
EventEasterSection = FarmotherMain.CreateSection("Event Easter")

EventEasterSection.CreateButton({ Title = "Open Easter Shop" }, function()
	v_2(game.ReplicatedStorage.Controllers.UI.EventShop):Open("Easter2026")
end)

DetectEgg = function()
	local position = localPlayer.Character.PrimaryPart.Position
	local huge = math.huge
	local v_11 = nil

	for _, v_12 in pairs(game:GetService("CollectionService"):GetTagged("EasterEgg26")) do
		local magnitude = (position - v_12:GetAttribute("CFrame").Position).Magnitude

		if magnitude < huge then
			huge = magnitude
			v_11 = v_12
		end
	end

	return v_11
end

EventEasterSection.CreateToggle({
	Title = "Auto Collect Egg Easter",
	Desc = nil,
	Default = Settings["Auto Collect Egg Easter"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Collect Egg Easter"] and task.wait() do
				local ok, result = pcall(function()
					if not StackFarmOther then
						return
					end
					local v_11 = DetectEgg()

					if v_11 then
						toTarget(v_11:GetAttribute("CFrame"))
					end
				end)

				if result then
					print(result)
				end
			end
		end)
	end

	SaveSettings("Auto Collect Egg Easter", arg)
end)

FishingSection = FarmotherMain.CreateSection("Fishing")

FishingSection.CreateToggle({ Title = "Change Size Reel", Desc = nil, Default = Settings["Change Size Reel"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Change Size Reel"] and task.wait() do
				pcall(function()
					if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Fishing_Reeling") then
						game:GetService("Players").LocalPlayer.PlayerGui.Fishing_Reeling.Minigame.Container.ReelZone.Size = UDim2.new(0.98, 0, 0.13, 0)
					end
				end)
			end
		end)
	end

	SaveSettings("Change Size Reel", arg)
end)

FishingSection.CreateToggle({
	Title = "Auto Slap Battle",
	Desc = "There’s still a chance of a misclick",
	Default = Settings["Auto Slap Battle"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Slap Battle"] and task.wait() do
				pcall(function()
					if not game:GetService("Players").LocalPlayer:FindFirstChild("RemoteEvent") then
						repeat
							wait()
						until game:GetService("Players").LocalPlayer:FindFirstChild("RemoteEvent")

						local remoteEvent = game:GetService("Players").LocalPlayer.RemoteEvent
						local connection = nil

						remoteEvent.OnClientEvent:Connect(function(arg2, arg3, arg4, arg5, arg6, arg7, arg8)
							if arg2 == "startBar" and arg5 == game.Players.LocalPlayer then
								local n4 = 0.96 / arg4 * 0.5
								local n5 = 0.2 / arg4 * 1.5

								if connection then
									connection:Disconnect()
								end

								connection = game:GetService("RunService").Heartbeat:Connect(function()
									local serverTimeNow = workspace:GetServerTimeNow()
									local n6 = 0.02 + (serverTimeNow - arg3) % arg4 * n4

									if n6 >= 0.98 then
										n6 = 0.98 - n6 - 0.98
									end

									local n7

									if arg8 then
										n7 = 0.5
									else
										n7 = 0.4 + (serverTimeNow - arg3) % arg4 * 3 * n5

										if n7 >= 0.6 then
											n7 = 0.6 - n7 - 0.6
										end
									end

									if math.abs(n6 - n7) < 0.03 then
										remoteEvent:FireServer("Jump", workspace:GetServerTimeNow())
									end
								end)
							elseif arg2 == "killBar" then
								if connection then
									connection:Disconnect()
									connection = nil
								end
							end
						end)
					end
				end)
			end
		end)
	end

	SaveSettings("Auto Slap Battle", arg)
end)

do
	local savePositionFishing = Settings["Save Position Fishing"]
	local str = "Position : "

	if savePositionFishing then
		local vector = Vector3.new(savePositionFishing.posX, savePositionFishing.posY, savePositionFishing.posZ)
		local deg = math.deg
		local rz = savePositionFishing.rz
		str = string.format("Position : %.2f, %.2f, %.2f | Angle(deg) : %.1f, %.1f, %.1f", vector.X, vector.Y, vector.Z, math.deg(savePositionFishing.rx), math.deg(savePositionFishing.ry), deg(rz))
	end

	LocalPositionPlantSeed = FishingSection.CreateLabel({ Title = str })
end

FishingSection.CreateButton({ Title = "Save Position Fishing" }, function()
	local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart2 then
		return
	end
	local cFrame2 = humanoidRootPart2.CFrame
	local position = cFrame2.Position
	local v_11, v_12, v_13 = cFrame2:ToOrientation()
	local deg = math.deg
	LocalPositionPlantSeed.SetText(string.format("Position : %.2f, %.2f, %.2f | Angle(deg) : %.1f, %.1f, %.1f", position.X, position.Y, position.Z, math.deg(v_11), math.deg(v_12), deg(v_13)))
	SaveSettings("Save Position Fishing", { posX = position.X, posY = position.Y, posZ = position.Z, rx = v_11, ry = v_12, rz = v_13 })
end)

tbl = {}

pcall(function()
	for k in next, v_2(game:GetService("ReplicatedStorage").FishReplicated.BaitData).Types, nil do
		table.insert(tbl, k)
	end
end)

FishingSection.CreateDropdown({
	Title = "Select Bait",
	List = tbl,
	Search = true,
	Selected = false,
	Default = Settings["Select Bait"] or nil,
}, function(arg)
	SaveSettings("Select Bait", arg)
end)

do
	local v_11 = nil
	local v_12 = nil
	local v_13 = nil
	local v_14 = nil
	local v_15 = nil
	local v_16 = nil

	pcall(function()
		local fishingRequest = game.ReplicatedStorage.FishReplicated.FishingRequest
		local FishingRemote = v_2(game.ReplicatedStorage.Modules.Net):RemoteEvent("FishingRemote", true)
		local v_17 = v_2(game.ReplicatedStorage.Util.GetWaterHeightAtLocation)
		local CollectionService = game:GetService("CollectionService")
		local waterBodyTag = v_2(game.ReplicatedStorage.FishReplicated.FishingClient.Config).WATER_BODY_TAG
		local rod = v_2(game.ReplicatedStorage.FishReplicated.FishingClient.Config).Rod
		v_11 = fishingRequest
		v_12 = FishingRemote
		v_13 = v_17
		v_14 = CollectionService
		v_15 = waterBodyTag
		v_16 = rod
		v_2(game:GetService("ReplicatedStorage").FishReplicated.FishingClient.Components)
	end)

	local function fn7(arg, arg2, arg3)
		local n4 = v_13 and v_13(arg.Position) or 0
		local v_17, v_18 = workspace:FindPartOnRayWithIgnoreList(Ray.new(arg.Parent.Head.Position, arg.CFrame.LookVector * (arg2:GetAttribute("MaxLaunchDistance") or v_16 and v_16.MaxLaunchDistance or 100) * (0.5 + arg3 / 201)), { arg.Parent, workspace.Characters, workspace.Enemies })
		local tbl6 = { arg.Parent, workspace.Characters, workspace.Enemies }
		local v_19, v_20 = workspace:FindPartOnRayWithIgnoreList(Ray.new(v_18 + Vector3.new(0, 3, 0), Vector3.new(0, -500, 0)), tbl6)
		if not v_20 then
			return
		end
		local z = v_18.Z
		local vector = Vector3.new(v_18.X, math.max(v_20.Y, n4), z)
		return vector, v_19 and v_14 and v_14:HasTag(v_19, v_15) or vector.Y <= n4
	end

	DetectRod = function()
		if not localPlayer then
			return nil
		end
		local character = localPlayer.Character
		character = character and character:FindFirstChild("FishingRodData", true)
		if character then
			return character.Parent
		end

		for _, child in ipairs(localPlayer.Backpack:GetChildren()) do
			if child:FindFirstChild("FishingRodData") then
				return child
			end
		end

		return nil
	end

	pcall(function()
		v_2(game:GetService("ReplicatedStorage").FishReplicated.FishingClient.Components.CatchingMinigame)
	end)

	local function fn8()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local v_17 = DetectRod()
		if not character or not v_17 then
			return
		end

		if v_17.Parent == localPlayer.Backpack then
			equiptool(v_17.Name)
			task.wait(0.5)
			return
		end

		local attribute = v_17:GetAttribute("ServerState")

		if attribute then
			StatusFishingLabel.SetText("Status Fishing : " .. attribute)
		end

		if (v_17:GetAttribute("SkillChargeAlpha") or 0) >= 1 then
			game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/JobToolAbilities"):InvokeServer(unpack({ "Z", true }))
		end

		if not attribute or attribute == "ReeledIn" then
			getgenv().delaytimeBiting = nil

			if v_11 then
				v_11:InvokeServer("StartCasting")
			end

			task.wait(0.7)
			local v_18, v_19 = fn7(character, v_17, 98)
			if not v_18 then
				return
			end

			if not (v_11 and v_11:InvokeServer("CastLineAtLocation", v_18, 98, v_19)) then
				equiptool(NameWeapon("Melee"))
				return
			end

			if not getgenv().LoadFishingRemote then
				if v_12 then
					v_12.OnClientEvent:Connect(function(arg, arg2)
						if Settings["Auto Fishing"] then
							if arg ~= localPlayer then
								return
							end

							if arg2 == "SpawnFishOnBob" then
								task.wait(0.2)

								if v_11 then
									v_11:InvokeServer("Catching", true, { fastBite = true })
								end

								task.wait(2)

								pcall(function()
									game.ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("Catch", 1, 1, 1)
									game.ReplicatedStorage.FishReplicated.FishingRequest:InvokeServer("Catch", 1, 0, 1)
								end)
							end
						end
					end)
				end

				getgenv().LoadFishingRemote = true
			end
		elseif attribute == "Biting" then
			if not getgenv().delaytimeBiting then
				getgenv().delaytimeBiting = tick()
			end

			if tick() - (getgenv().delaytimeBiting or 0) >= 5 then
				equiptool(NameWeapon("Melee"))
				task.wait(1)
			end
		else
			getgenv().delaytimeBiting = nil
		end
	end

	local function fn9(arg, arg2)
		local v_17 = ipairs
		arg2 = arg2 or workspace:WaitForChild("Map")
		local huge = math.huge
		local v_18 = nil

		for _, descendant in v_17(arg2:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant.CanCollide then
				if arg.Y < descendant.Position.Y + descendant.Size.Y / 2 then
					local magnitude = (descendant.Position - arg).Magnitude

					if magnitude < huge then
						huge = magnitude
						v_18 = descendant
					end
				end
			end
		end

		if v_18 then
			return Vector3.new(v_18.Position.X, v_18.Position.Y + v_18.Size.Y / 2, v_18.Position.Z), v_18
		end
		return nil
	end

	local function fn10(arg, arg2)
		local position = arg.Position
		arg.CFrame = CFrame.new(arg.Position, arg.Position + (Vector3.new(arg2.X, arg.Position.Y, arg2.Z) - position).Unit)
	end

	humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

	GetGoldenVortex = function()
		local v_17 = next
		local children, v_18 = workspace.ActiveFishingSpots:GetChildren()
		local huge = math.huge
		local v_19 = nil

		for _, v_20 in v_17, children, v_18 do
			if v_20.Name == "GoldenVortex" then
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 then
					local magnitude = (humanoidRootPart2.Position - v_20.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v_19 = v_20
					end
				end
			end
		end

		return v_19
	end

	local ok, result = pcall(function()
		return identifyexecutor and identifyexecutor()
	end)

	okz = ok
	execc = result

	if okz and typeof(execc) == "string" then
		if execc:find("Seliware") then
			task.wait(2)
		elseif execc:find("Velocity") or execc:find("Delta") or execc:find("Real") then
			task.wait(5)
		end
	end

	StatusFishingLabel = FishingSection.CreateLabel({ Title = "Status Fishing :" })

	FishingSection.CreateToggle({
		Title = "Auto Tween To Event Fishing Spot",
		Desc = nil,
		Default = Settings["Auto Tween To Event Fishing Spot"] or false,
	}, function(arg)
		SaveSettings("Auto Tween To Event Fishing Spot", arg)
	end)

	CheckChestplr = function()
		local v_17 = nil

		for _, child in pairs(localPlayer.Backpack:GetChildren()) do
			if string.find(child.Name, "Chest") then
				v_17 = child
			end
		end

		for _, child in pairs(localPlayer.Character:GetChildren()) do
			if string.find(child.Name, "Chest") then
				v_17 = child
			end
		end

		return v_17
	end

	FishingSection.CreateToggle({ Title = "Auto Fishing", Desc = nil, Default = Settings["Auto Fishing"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Fishing"] and task.wait() do
					local ok2, result2 = pcall(function()
						if not StackFarmOther then
							return
						end

						if Settings["Auto Celestial Soldier"] and getgenv().AttackOniSoldier then
							return
						end

						if Settings["Auto Rip Commander"] and getgenv().AttackBossRedCommander then
							return
						end

						if game:GetService("Players").LocalPlayer.Data.FishingData:GetAttribute("SelectedBait") and game:GetService("Players").LocalPlayer.Data.FishingData:GetAttribute("SelectedBait") ~= "None" then
							local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

							if Settings["Auto Tween To Event Fishing Spot"] and GetGoldenVortex() then
								if not getgenv().Vortex or not getgenv().Vortex.Parent then
									getgenv().Vortex = GetGoldenVortex()
									task.wait(1)
									local genv = getgenv()
									local genv2 = getgenv()
									local v_17 = workspace
									local waitForChild = v_17.WaitForChild
									local v_18, v_19 = fn9(getgenv().Vortex.Position, waitForChild(v_17, "Map"))
									genv.higherPos = v_18
									genv2.partHigher = v_19
									return
								end

								if getgenv().Vortex then
									local position = GetGoldenVortex().Position

									if not ((humanoidRootPart2.CFrame.Position - getgenv().higherPos).Magnitude <= 5) then
										toTarget(CFrame.new(getgenv().higherPos))
									else
										if localPlayer:DistanceFromCharacter(position) > 100 then
											getgenv().Vortex = nil
											return
										end
										fn10(humanoidRootPart2, position)
										fn8()
									end

									return
								end
							end

							local savePositionFishing = Settings["Save Position Fishing"]
							if not savePositionFishing then
								return
							end
							local vector = Vector3.new(savePositionFishing.posX, savePositionFishing.posY, savePositionFishing.posZ)
							local n4 = CFrame.new(vector) * CFrame.fromOrientation(savePositionFishing.rx, savePositionFishing.ry, savePositionFishing.rz)

							if humanoidRootPart2 then
								local cFrame2 = humanoidRootPart2.CFrame

								if not ((cFrame2.Position - vector).Magnitude <= 10 and cFrame2.LookVector:Dot(n4.LookVector) > 0.99) then
									toTarget(n4)
								else
									fn8()
								end
							end
						else
							local selectBait = Settings["Select Bait"] or "Basic Bait"

							if CheckItemInventory(selectBait) then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", selectBait, { "Usables" } }))
							else
								game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", selectBait, 1, {} }))
							end
						end
					end)

					if result2 then
						print(result2)
					end
				end
			end)
		end

		SaveSettings("Auto Fishing", arg)
	end)
end

do
	local v_11 = nil

	pcall(function()
		v_11 = v_2(game.ReplicatedStorage.JobsReplicated)
	end)

	FishingSection.CreateToggle({ Title = "Auto Sell Fishing", Desc = nil, Default = Settings["Auto Sell Fishing"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Sell Fishing"] and task.wait(0.2) do
					local ok, result = pcall(function()
						if v_11 then
							v_11.InvokeServer("FishingNPC", "SellFish")
						end
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Sell Fishing", arg)
	end)

	FishingSection.CreateToggle({ Title = "Auto Open Chest", Desc = nil, Default = Settings["Auto Open Chest"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Open Chest"] and task.wait(0.2) do
					local ok, result = pcall(function()
						local v_12 = CheckChestplr()

						if v_12 then
							v_12.RemoteEvent:FireServer(unpack({ "Visual" }))
							task.wait(0.1)
							v_12.RemoteEvent:FireServer(unpack({ "Open" }))
						end
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Open Chest", arg)
	end)

	local tbl6 = {}

	pcall(function()
		for _, v_12 in next, v_2(game:GetService("ReplicatedStorage").Modules.Asset.RarityUtil.RarityData), nil do
			tbl6[v_12.Name] = false
		end
	end)

	DetectQuestFishing = function()
		local v_12 = GetNameDoubleQuest()
		if not v_12 then
			return false
		end
		local v_13 = nil

		for k in pairs(tbl6) do
			if string.find(v_12, k) then
				v_13 = k
				break
			else
				v_13 = nil
			end
		end

		if v_13 and Settings["Select Quest Fishing"] then
			for k in next, Settings["Select Quest Fishing"], nil do
				if string.find(v_12, k) then
					return true
				end
			end

			return false
		end

		return true
	end

	FishingSection.CreateDropdown({
		Title = "Select Quest Fishing",
		List = PrepareMultiSelectList(tbl6, Settings["Select Quest Fishing"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Quest Fishing"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Quest Fishing", arg, arg2)
	end)

	FishingSection.CreateToggle({
		Title = "Auto Accept Quest Fishing",
		Desc = nil,
		Default = Settings["Auto Accept Quest Fishing"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Accept Quest Fishing"] and task.wait() do
					local ok, result = pcall(function()
						if Settings["Auto Event Pain"] and getgenv().AttackEventLightning then
							return
						end

						if Settings["Auto Celestial Soldier"] and getgenv().AttackOniSoldier then
							return
						end

						if Settings["Auto Rip Commander"] and getgenv().AttackBossRedCommander then
							return
						end

						if not StackFarmOther then
							return
						end
						v_11.InvokeServer("FishingNPC", "Angler", "CheckQuest")
						local FishingNPC = v_11.InvokeServer("FishingNPC", "Angler", "Speak")

						if FishingNPC.canAccept then
							v_11.InvokeServer("FishingNPC", "Angler", "AskQuest")
						elseif FishingNPC.FailedAnglerQuest or not DetectQuestFishing() then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
						end

						task.wait(2)
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Accept Quest Fishing", arg)
	end)
end

QuestDragonSection = FarmotherMain.CreateSection("Quest Dragon")

QuestDojoTrainer = function()
	local ok, result = pcall(function()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local modules2 = ReplicatedStorage2:FindFirstChild("Modules") or ReplicatedStorage2:WaitForChild("Modules", 3)

		if modules2 then
			modules2 = modules2:FindFirstChild("Net") or modules2:WaitForChild("Net", 3)
		end

		if modules2 then
			modules2 = modules2:FindFirstChild("RF/InteractDragonQuest") or modules2:WaitForChild("RF/InteractDragonQuest", 3)
		end

		if modules2 then
			return modules2:InvokeServer({ NPC = "Dojo Trainer", Command = "RequestQuest" })
		end
		return nil
	end)

	if ok then
		return result
	end
	return nil
end

ClaimDojoQuest = function()
	local ok, result = pcall(function()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local modules2 = ReplicatedStorage2:FindFirstChild("Modules") or ReplicatedStorage2:WaitForChild("Modules", 3)

		if modules2 then
			modules2 = modules2:FindFirstChild("Net") or modules2:WaitForChild("Net", 3)
		end

		if modules2 then
			modules2 = modules2:FindFirstChild("RF/InteractDragonQuest") or modules2:WaitForChild("RF/InteractDragonQuest", 3)
		end

		if modules2 then
			return modules2:InvokeServer({ NPC = "Dojo Trainer", Command = "ClaimQuest" })
		end
		return nil
	end)

	return ok and result
end

AttackAllMobSection = FarmotherMain.CreateSection("Attack All Mobs")

DetectAllMob = function()
	local v_11 = next
	local children, v_12 = game:GetService("Workspace").Enemies:GetChildren()

	for _, v_13 in v_11, children, v_12 do
		if v_13.Name ~= "Spirit Tree" and v_13:GetAttribute("Level") and v_13:GetAttribute("FruitType") then
			return v_13
		end
	end

	local v_13 = next
	local children2, v_14 = game:GetService("ReplicatedStorage"):GetChildren()

	for _, v_15 in v_13, children2, v_14 do
		if v_15.Name ~= "Spirit Tree" and v_15:GetAttribute("Level") and v_15:GetAttribute("FruitType") then
			return v_15
		end
	end
end

AttackAllMobSection.CreateToggle({
	Title = "Auto Attack All Mob and Boss",
	Desc = nil,
	Default = Settings["Auto Attack All Mob and Boss"] or false,
}, function(arg)
	spawn(function()
		while Settings["Auto Attack All Mob and Boss"] and wait() do
			local ok, result = pcall(function()
				if not StackFarmOther then
					return
				end
				local v_11 = DetectAllMob()

				if v_11 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							UsedualFlock()
							ClickM1(v_11)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, getgenv().YPosFruit, 0))
							else
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_11) or not Settings["Auto Attack All Mob and Boss"] or not StackFarmOther) then
								continue
							end
						end

						break
					end
				end
			end)

			if result then
				print(result)
			end
		end
	end)

	SaveSettings("Auto Attack All Mob and Boss", arg)
end)

local tbl6

do
	local tbl7 = { "PirateBrigade", "PirateGrandBrigade" }
	local tbl8 = { "Fish Crew Member", "Shark" }

	DetectQuestSeaDragon = function()
		local v_11 = next
		local children, v_12 = game:GetService("Workspace").Enemies:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:FindFirstChild("Engine") and v_13:FindFirstChild("Health") and v_13.Health.Value > 0 and localPlayer:DistanceFromCharacter(v_13.Engine.Position) < 500 then
				return v_13
			end
		end

		local v_13 = DetectMob(tbl8)
		if v_13 and localPlayer:DistanceFromCharacter(v_13.HumanoidRootPart.Position) < 500 then
			return v_13
		end
		local Piranha = DetectMob("Piranha")
		if Piranha and localPlayer:DistanceFromCharacter(Piranha.HumanoidRootPart.Position) < 500 then
			return Piranha
		end
	end

	checkboat = function()
		local name = localPlayer.Name

		if Settings["Auto Sea Event With Friend"] and Settings["Auto Sea Event"] then
			name = Settings["Select Friend"]
		end

		local v_11 = next
		local children, v_12 = game:GetService("Workspace").Boats:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Model") then
				if v_13:FindFirstChild("Owner") and tostring(v_13.Owner.Value) == name and v_13.Humanoid.Value > 0 then
					return v_13
				end
			end
		end

		return false
	end

	getgenv().PosSEaY = -50

	TeleportSeaEvents = function(arg)
		if not arg then
			return
		end

		if arg:FindFirstChild("Engine") and arg:FindFirstChild("Health") and arg.Health.Value > 0 then
			toTarget(arg.Engine.CFrame * CFrame.new(0, Settings["Use Click M1 Fruit For Sea Event"] and -25 or -15, 0))
			return
		end

		if arg.Name == "SeaBeast1" and arg:FindFirstChild("HumanoidRootPart") then
			if (Vector3.new(0, arg:FindFirstChild("HumanoidRootPart").Position.Y, 0) - Vector3.new(0, -60, 0)).Magnitude <= 175 then
				if Settings["Use Click M1 Fruit For Sea Event"] then
					toTarget(arg.HumanoidRootPart.CFrame * CFrame.new(0, 200 + PosDodgeskill, 0), true)
				else
					toTarget(arg.HumanoidRootPart.CFrame * CFrame.new(0, 200 + PosDodgeskill, 50), true)
				end
			else
				toTarget(CFrame.new(arg.HumanoidRootPart.Position.X, 140, arg.HumanoidRootPart.Position.Z), true)
			end
		else
			local name = arg.Name
			local n4

			if Settings["Use Click M1 Fruit For Sea Event"] then
				n4 = 20
			elseif name == "Terrorshark" then
				n4 = 60
			else
				n4 = 20
			end

			if arg:FindFirstChildWhichIsA("Humanoid") and arg.Humanoid.Health > 0 then
				toTarget(arg.HumanoidRootPart.CFrame * CFrame.new(0, n4, 0))
			end
		end
	end

	local roughSea = 0

	DecectPartRoughSea = function()
		local v_11 = next
		local children, v_12 = game.workspace._WorldOrigin.Locations:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13.Name == "Rough Sea" and localPlayer:DistanceFromCharacter(v_13.Position) <= 3000 and Vector3.new(0.001, 0.001, 0.001) ~= workspace._WorldOrigin.RainEmitterPart.Size and not v_13:FindFirstChild("Ignored") then
				return v_13
			end
		end
	end

	AutoQuestDojo = function()
		if game.PlaceId ~= getgenv().CheckPlaceId and game.PlaceId ~= 7449423635 and game.PlaceId ~= 100117331123089 then
			lib.CreateNoti({
				Title = "Banana Cat Hub",
				Desc = "Auto Quest Dojo Trainer only works in Sea 3!",
				ShowTime = 5,
			})

			Settings["Auto Quest Dojo Trainer"] = false
			SaveSettings("Auto Quest Dojo Trainer", false)
			return
		end

		local n4 = CFrame.new(5868.453125, 1207.7784423828125, 870.819580078125) * CFrame.new(0, 4, -2)
		local dojoTrainer = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild("Dojo Trainer")

		if dojoTrainer and dojoTrainer:FindFirstChild("HumanoidRootPart") then
			n4 = dojoTrainer.HumanoidRootPart.CFrame * CFrame.new(0, 4, -2)
		end

		local dojoQuestCompleted = not getgenv().QuestTrainer or getgenv().DojoQuestCompleted

		if not dojoQuestCompleted and getgenv().QuestTrainer then
			local questTrainer = getgenv().QuestTrainer
			local n5 = tonumber(questTrainer.Goal) or 1
			local n6 = tonumber(questTrainer.CountKillMob) or 0

			if questTrainer.BeltName == "White" and n6 >= n5 then
				dojoQuestCompleted = true
			elseif questTrainer.BeltName == "Yellow" and n6 >= n5 then
				dojoQuestCompleted = true
			elseif questTrainer.BeltName == "Purple" and n6 >= n5 then
				dojoQuestCompleted = true
			elseif questTrainer.BeltName == "Red" and n6 >= n5 then
				dojoQuestCompleted = true
			else
				local startTime = questTrainer.BeltName == "Green" and questTrainer.StartTime

				if startTime then
					local startTime2 = questTrainer.StartTime
					startTime = tick() - startTime2 >= n5
				end

				if startTime then
					dojoQuestCompleted = true
				end
			end
		end

		if dojoQuestCompleted then
			if localPlayer:DistanceFromCharacter(n4.Position) > 15 then
				toTarget(n4)
				return
			end
			TweenManager.CancelCurrent()
			task.wait(0.3)
			local dojoQuestCompleted2 = getgenv().DojoQuestCompleted

			if not dojoQuestCompleted2 then
				dojoQuestCompleted2 = getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob

				if dojoQuestCompleted2 then
					dojoQuestCompleted2 = getgenv().QuestTrainer.CountKillMob >= (getgenv().QuestTrainer.Goal or 1)
				end
			end

			if dojoQuestCompleted2 then
				ClaimDojoQuest()
				getgenv().QuestTrainer = nil
				getgenv().DojoQuestCompleted = nil
				SaveSettings("QuestDojo", false)
				task.wait(1)
			end

			local v_11 = QuestDojoTrainer()
			if not v_11 or type(v_11) ~= "table" then
				task.wait(0.8)
				return
			end

			if v_11.Timeout then
				lib.CreateNoti({
					Title = "Banana Cat Hub",
					Desc = "That's enough training for today... Come back tomorrow!",
					ShowTime = 5,
				})

				getgenv().QuestTrainer = nil
				getgenv().DojoQuestCompleted = nil
				SaveSettings("QuestDojo", false)
				Settings["Auto Quest Dojo Trainer"] = false
				SaveSettings("Auto Quest Dojo Trainer", false)
				return
			end

			if not v_11.Quest then
				task.wait(0.8)
				return
			end
			local n5 = tonumber(v_11.Quest.Progress) or 0
			local goal = tonumber(v_11.Quest.Goal) or 1
			local str = tostring(v_11.Quest.BeltName)

			if goal <= n5 then
				ClaimDojoQuest()
				getgenv().QuestTrainer = nil
				getgenv().DojoQuestCompleted = nil
				SaveSettings("QuestDojo", false)
				task.wait(1)
				return
			end

			if str == "White" then
				local genv = getgenv()
				local questTrainer = { BeltName = "White", CountKillMob = n5 }
				goal = goal > 0 and goal or 20
				questTrainer.Goal = goal
				genv.QuestTrainer = questTrainer
			elseif str == "Yellow" then
				local genv = getgenv()
				local questTrainer = { BeltName = "Yellow", CountKillMob = n5 }
				goal = goal > 0 and goal or 5
				questTrainer.Goal = goal
				genv.QuestTrainer = questTrainer
			elseif str == "Green" then
				local genv = getgenv()
				local questTrainer = { BeltName = "Green", CountKillMob = n5 }
				goal = goal > 0 and goal or 300
				questTrainer.Goal = goal
				questTrainer.StartTime = tick()
				genv.QuestTrainer = questTrainer
			elseif str == "Purple" then
				local genv = getgenv()
				local questTrainer = { BeltName = "Purple", CountKillMob = n5 }
				goal = goal > 0 and goal or 3
				questTrainer.Goal = goal
				genv.QuestTrainer = questTrainer
			elseif str == "Red" then
				local genv = getgenv()
				local questTrainer = { BeltName = "Red", CountKillMob = n5 }
				goal = goal > 0 and goal or 1
				questTrainer.Goal = goal
				genv.QuestTrainer = questTrainer
			else
				if str ~= "Black" then
					lib.CreateNoti({
						Title = "Banana Cat Hub",
						Desc = "Belt [" .. str .. "] requires manual training or is not supported.",
						ShowTime = 5,
					})

					getgenv().QuestTrainer = nil
					Settings["Auto Quest Dojo Trainer"] = false
					SaveSettings("Auto Quest Dojo Trainer", false)
					return
				end

				getgenv().QuestTrainer = { BeltName = "Black", CountKillMob = n5, Goal = goal }
			end

			SaveSettings("QuestDojo", true)
			return
		end

		local questTrainer = getgenv().QuestTrainer
		if not questTrainer then
			return
		end

		if questTrainer.BeltName == "White" then
			SaveSettings("QuestDojo", true)
			local str = GetNameDoubleQuest() or ""

			if not localPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and typeof(str) == "string" and str ~= "" then
				TakeQuestLevel()
			else
				if str == "" then
					str = "Skull Slayer"
				end

				local v_11 = DetectMob(str)

				if not v_11 then
					local v_12 = DetectPartSpawnMob(str, true)

					if v_12 then
						Instance.new("IntValue", v_12).Name = "Ignored"

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
								if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(str) or not Settings["Auto Quest Dojo Trainer"] or getgenv().DojoQuestCompleted) then
									continue
								end
							end

							break
						end

						wait(1)
					else
						DeleteIgnoredMobSpawn()
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_11)
							BringMob(v_11)
							UsedualFlock()
							ClickM1(v_11)

							if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransformationHUD") and game:GetService("Players").LocalPlayer.PlayerGui.TransformationHUD:FindFirstChild("ImageLabel") and game:GetService("Players").LocalPlayer.PlayerGui.TransformationHUD.ImageLabel.Visible and (Settings["Auto Finish Train Quest"] or Settings["Auto Finish Train Draco Quest"]) then
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							elseif Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, getgenv().YPosFruit or 20, 0))
							else
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_11) or not Settings["Auto Quest Dojo Trainer"] or getgenv().DojoQuestCompleted) then
								continue
							end
						end

						break
					end

					if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
						getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
					end
				end
			end
		elseif questTrainer.BeltName == "Yellow" then
			SaveSettings("QuestDojo", true)
			local v_11 = DetectQuestSeaDragon()
			local v_12 = checkboat()

			if not v_11 then
				if not v_12 then
					local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

					if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
						toTarget(cframe)
					else
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
					end
				else
					task.spawn(function()
						NoclipBoat(v_12)
					end)

					local v_13 = DecectPartRoughSea()

					if v_13 then
						wait(1)
						local n5

						if roughSea == 0 then
							n5 = 7000
						else
							n5 = 0
						end

						roughSea = n5
						Instance.new("IntValue", v_13).Name = "Ignored"
						wait(0.5)
					end

					getgenv().RoughSea = roughSea
					local n5 = CFrame.new(-32975.9921875, v_12.WorldPivot.Y, 25963.7109375) * CFrame.new(0, v_12.WorldPivot.Y, 0 + RoughSea)

					if not localPlayer.Character.Humanoid.Sit then
						toTarget(v_12.VehicleSeat.CFrame)
					else
						manageTween(v_12.VehicleSeat, n5, 350, "TweenBoat")
					end
				end
			else
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						TeleportSeaEvents(v_11)
						local humanoidRootPart2 = v_11:FindFirstChild("HumanoidRootPart") or v_11:FindFirstChild("Engine")

						if humanoidRootPart2 then
							getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)
						end

						if v_11:FindFirstChildWhichIsA("Humanoid") then
							UsedualFlock()
							ClickM1(v_11, true)
						elseif humanoidRootPart2 and localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
							AutoAllSkill()
						end

						if not (not v_11 or not v_11.Parent or v_11:FindFirstChildWhichIsA("Humanoid") and v_11.Humanoid.Health <= 0 or v_11:FindFirstChild("Health") and v_11.Health.Value <= 0 or not Settings["Auto Quest Dojo Trainer"] or getgenv().DojoQuestCompleted) then
							continue
						end
					end

					break
				end

				if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
					getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
				end
			end
		elseif questTrainer.BeltName == "Purple" then
			SaveSettings("QuestDojo", true)
			local v_11 = DetectEliteHunter()

			if v_11 then
				StackFarm = false
				EnsureEliteQuest(v_11.Name)

				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not Settings["Auto Quest Dojo Trainer"] then
							TweenManager.CancelCurrent()
							break
						else
							sizepart(v_11)
							local humanoidRootPart2 = v_11:FindFirstChild("HumanoidRootPart", true) or v_11.PrimaryPart

							if humanoidRootPart2 then
								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
								end
							end

							ClickM1(v_11)
							UsedualFlock()
							if not (not IsMobAlive(v_11) or not Settings["Auto Quest Dojo Trainer"] or getgenv().DojoQuestCompleted) then
								continue
							end
						end
					end

					break
				end

				if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
					getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
				end

				return
			end

			task.wait(1)
		elseif questTrainer.BeltName == "Green" then
			SaveSettings("QuestDojo", true)
			local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
			local compass = playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("Compass")
			local dangerLevel = compass and compass:FindFirstChild("Frame") and compass.Frame:FindFirstChild("DangerLevel")

			if dangerLevel and dangerLevel.Visible and dangerLevel:FindFirstChild("TextLabel") and tonumber(dangerLevel.TextLabel.Text) == 6 then
				local n5 = (questTrainer.Goal or 300) - (questTrainer.CountKillMob or 0)

				if n5 <= 0 then
					n5 = 300
				end

				local now = tick()

				while true do
					task.wait(1)

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not (tick() - now >= n5 or not dangerLevel.Visible or not Settings["Auto Quest Dojo Trainer"] or getgenv().DojoQuestCompleted) then
							continue
						end
					end

					break
				end

				if tick() - now >= n5 or getgenv().DojoQuestCompleted then
					getgenv().DojoQuestCompleted = true
					getgenv().QuestTrainer = nil
					SaveSettings("QuestDojo", false)
				end
			else
				local v_11 = checkboat()

				if not v_11 then
					local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

					if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
						toTarget(cframe)
					else
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
					end
				else
					task.spawn(function()
						NoclipBoat(v_11)
					end)

					local v_12 = DecectPartRoughSea()

					if v_12 then
						wait(1)
						local n5

						if roughSea == 0 then
							n5 = 7000
						else
							n5 = 0
						end

						roughSea = n5
						Instance.new("IntValue", v_12).Name = "Ignored"
						wait(0.5)
					end

					getgenv().RoughSea = roughSea
					local n5 = CFrame.new(-32975.9921875, v_11.WorldPivot.Y, 25963.7109375) * CFrame.new(0, v_11.WorldPivot.Y, 0 + RoughSea)

					if not localPlayer.Character.Humanoid.Sit then
						toTarget(v_11.VehicleSeat.CFrame)
					else
						manageTween(v_11.VehicleSeat, n5, 350, "TweenBoat")
					end
				end
			end
		elseif questTrainer.BeltName == "Red" then
			SaveSettings("QuestDojo", true)
			local Terrorshark = CheckNameBoss("Terrorshark")
			local v_11 = checkboat()

			if not Terrorshark then
				if not v_11 then
					local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

					if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
						toTarget(cframe)
					else
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
					end
				else
					local v_12 = DecectPartRoughSea()

					if v_12 then
						wait(1)
						local n5

						if roughSea == 0 then
							n5 = 7000
						else
							n5 = 0
						end

						roughSea = n5
						Instance.new("IntValue", v_12).Name = "Ignored"
						wait(0.5)
					end

					getgenv().RoughSea = roughSea
					local n5 = CFrame.new(-32975.9921875, v_11.WorldPivot.Y, 25963.7109375) * CFrame.new(0, v_11.WorldPivot.Y, 0 + RoughSea)

					if not localPlayer.Character.Humanoid.Sit then
						toTarget(v_11.VehicleSeat.CFrame)
					else
						manageTween(v_11.VehicleSeat, n5, 350, "TweenBoat")
					end
				end
			else
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						TeleportSeaEvents(Terrorshark)
						local humanoidRootPart2 = Terrorshark:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart2 then
							getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)
						end

						if Terrorshark:FindFirstChildWhichIsA("Humanoid") then
							UsedualFlock()
							ClickM1(Terrorshark, true)
						elseif humanoidRootPart2 and localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
							AutoAllSkill()
						end

						if not (not Terrorshark or not Terrorshark.Parent or Terrorshark.Humanoid.Health <= 0 or not Settings["Auto Quest Dojo Trainer"] or getgenv().DojoQuestCompleted) then
							continue
						end
					end

					break
				end

				if getgenv().QuestTrainer and getgenv().QuestTrainer.CountKillMob then
					getgenv().QuestTrainer.CountKillMob = getgenv().QuestTrainer.CountKillMob + 1
				end
			end
		elseif questTrainer.BeltName == "Black" then
			SaveSettings("QuestDojo", true)

			if workspace.Map:FindFirstChild("PrehistoricIsland") or workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations") and workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
				local prehistoricIsland = workspace.Map:FindFirstChild("PrehistoricIsland")

				if prehistoricIsland and prehistoricIsland:FindFirstChild("Core") and prehistoricIsland.Core:FindFirstChild("ActivationPrompt") and prehistoricIsland.Core.ActivationPrompt:FindFirstChildWhichIsA("ProximityPrompt") then
					toTarget(prehistoricIsland.Core.CFrame)
				end
			end
		end
	end

	QuestDragonSection.CreateToggle({
		Title = "Auto Quest Dojo Trainer",
		Desc = nil,
		Default = Settings["Auto Quest Dojo Trainer"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Quest Dojo Trainer"] and task.wait(0.2) do
					local ok, result = pcall(function()
						AutoQuestDojo()
					end)

					if not ok and result then
						print("[Auto Quest Dojo Error]:", result)
					end
				end
			end)
		else
			TweenManager.CancelCurrent()
			getgenv().QuestTrainer = nil
			getgenv().DojoQuestCompleted = nil
			SaveSettings("QuestDojo", false)
		end

		SaveSettings("Auto Quest Dojo Trainer", arg)
	end)

	game:GetService("Players").LocalPlayer.PlayerGui.Notifications.ChildAdded:Connect(function(child)
		if child.Name == "NotificationTemplate" then
			while true do
				wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if not child:FindFirstChild("TranslateMe") then
						continue
					end
				end

				break
			end

			if child.TranslateMe.Text == "Head back to the Dojo to complete more tasks." then
				getgenv().DojoQuestCompleted = true
				getgenv().QuestTrainer = nil
				getgenv().QuestHunterDragon = nil
			end
		end

		if child.Name == "NotificationTemplate" then
			while true do
				wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if not child:FindFirstChild("TranslateMe") then
						continue
					end
				end

				break
			end

			if child.TranslateMe.Text == "{color1_Red}[ERROR]{color1_/} Can't perform actions while preparing to teleport!" then
				child:Destroy()
			end
		end
	end)

	DetectTree = function()
		local islandModel = workspace.Map:FindFirstChild("Waterfall") and workspace.Map.Waterfall:FindFirstChild("IslandModel")

		if not islandModel then
			local v_11 = toTarget
			local cframe = CFrame.new(5251.900390625, 17.18115234375, 453.6025390625)
			v_11(cframe)
			return nil
		end

		local fn7 = nil

		fn7 = function(arg)
			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("Model") and not child:FindFirstChild("Ignored") and child.Name == "Tree" and not child:GetAttribute("AlreadyDestroyedClient") and child:FindFirstChild("Group") and (child.Group:FindFirstChild("Meshes/bambootree") or child.Group:FindFirstChild("Meshes/plant1_Icosphere")) and not workspace:FindFirstChild("EmberTemplate") then
					return child
				end
				local v_11 = fn7(child)
				if v_11 then
					return v_11
				end
			end

			return nil
		end

		local v_11 = fn7(islandModel)

		if not v_11 then
			local fn8 = nil

			fn8 = function(arg)
				for _, child in ipairs(arg:GetChildren()) do
					if child:FindFirstChild("Ignored") then
						child.Ignored:Destroy()
					end

					fn8(child)
				end
			end

			fn8(islandModel)
		end

		return v_11
	end

	DetectEmberTemplate = function()
		for _, v_11 in game.workspace:GetChildren() do
			if v_11.Name == "EmberTemplate" and not v_11:FindFirstChild("Ignored") and v_11:FindFirstChild("Part") and v_11.Part.Position.Y > -100 then
				return v_11
			end
		end
	end

	AutoDragonHunter = function()
		local v_11 = DetectNpc("Dragon Hunter")
		if not v_11 or not v_11:FindFirstChild("HumanoidRootPart") then
			return
		end

		if not getgenv().QuestHunterDragon then
			if localPlayer:DistanceFromCharacter(v_11.HumanoidRootPart.Position) > 8 then
				toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4))
			else
				local response = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "Check" } }))

				if not response or response and not response.Text then
					getgenv().QuestHunterDragon = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "RequestQuest" } })).Text
				else
					local text = response.Text
					getgenv().QuestHunterDragon = text
				end
			end
		else
			local v_12 = DetectEmberTemplate()

			if v_12 then
				Instance.new("IntValue", v_12).Name = "Ignored"

				while true do
					wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						toTarget(v_12.Part.CFrame)
						if not (not v_12 or not v_12.Parent) then
							continue
						end
					end

					break
				end

				return
			end

			if string.find(getgenv().QuestHunterDragon, "Hydra Enforcers") then
				local v_13 = DetectMob("Hydra Enforcer")

				if not v_13 then
					local v_14 = DetectPartSpawnMob("Hydra Enforcer", true)

					if v_14 then
						Instance.new("IntValue", v_14).Name = "Ignored"

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
								if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Hydra Enforcer") or not Settings["Auto Quest Dragon Hunter"] or v_12) then
									continue
								end
							end

							break
						end

						wait(1)
					else
						DeleteIgnoredMobSpawn()
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_13)
							BringMob(v_13)
							UsedualFlock()
							ClickM1(v_13)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_13) or not Settings["Auto Quest Dragon Hunter"] or v_12) then
								continue
							end
						end

						break
					end
				end
			elseif string.find(getgenv().QuestHunterDragon, "Venomous Assailants") then
				local v_13 = DetectMob("Venomous Assailant")

				if not v_13 then
					local v_14 = DetectPartSpawnMob("Venomous Assailant", true)

					if v_14 then
						Instance.new("IntValue", v_14).Name = "Ignored"

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
								if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Venomous Assailant") or not Settings["Auto Quest Dragon Hunter"] or v_12) then
									continue
								end
							end

							break
						end

						wait(1)
					else
						DeleteIgnoredMobSpawn()
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_13)
							BringMob(v_13)
							UsedualFlock()
							ClickM1(v_13)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_13) or not Settings["Auto Quest Dragon Hunter"] or v_12) then
								continue
							end
						end

						break
					end
				end
			elseif string.find(getgenv().QuestHunterDragon, "trees") then
				local currentCamera = workspace.CurrentCamera
				local v_13 = DetectTree()

				if v_13 then
					Instance.new("IntValue", v_13).Name = "Ignored"
					local now = tick()

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							local position = v_13.WorldPivot.Position

							if localPlayer:DistanceFromCharacter(position) < 50 then
								AutoAllSkill()
							end

							if v_13:FindFirstChild("Meshes/plant1_Icosphere", true) then
								toTarget(v_13.WorldPivot)
								local worldPivot = v_13.WorldPivot
								getgenv().AimPos = worldPivot
								v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position)
								v_5.Target = v_13
							else
								local position2 = (v_13.WorldPivot * CFrame.new(5, -20, 0)).Position
								local position3 = (v_13.WorldPivot * CFrame.new(0, -20, 0)).Position
								toTarget(CFrame.new(position2))
								getgenv().AimPos = CFrame.new(position3)
								v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position3)
								v_5.Target = v_13
							end

							if not (not v_13 or not v_13.Parent or not Settings["Auto Quest Dragon Hunter"] or v_12 or v_13:GetAttribute("AlreadyDestroyedClient") or tick() - now >= 15) then
								continue
							end
						end

						break
					end
				end
			end
		end
	end

	QuestDragonSection.CreateToggle({
		Title = "Auto Quest Dragon Hunter",
		Desc = nil,
		Default = Settings["Auto Quest Dragon Hunter"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Quest Dragon Hunter"] and task.wait(0.1) do
					local ok, result = pcall(function()
						AutoDragonHunter()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Quest Dragon Hunter", arg)
	end)

	DetectBerryCFrame = function(arg)
		for _, v_11 in next, arg, nil do
			if v_11 then
				return v_11
			end
		end
	end

	DetectBerry = function()
		local v_11 = next
		local tagged, v_12 = game:GetService("CollectionService"):GetTagged("BerryBush")

		for _, v_13 in v_11, tagged, v_12 do
			if DetectBerryCFrame(v_13:GetAttributes()) then
				return v_13
			end
		end
	end

	DetectBerryESP = function()
		local v_11 = next
		local tagged, v_12 = game:GetService("CollectionService"):GetTagged("BerryBush")

		for _, v_13 in v_11, tagged, v_12 do
			if not v_13.Parent:FindFirstChild("Ignored") then
				local v_14 = DetectBerryCFrame(v_13:GetAttributes())
				if v_14 then
					return v_13, v_14
				end
			end
		end
	end

	DetectModelBerry = function(arg)
		for _, child in pairs(arg:GetChildren()) do
			if child then
				return child
			end
		end
	end

	GetCFrameSpawnBerry = function()
		local v_11 = next
		local tagged, v_12 = game:GetService("CollectionService"):GetTagged("BerryBush")
		local huge = math.huge
		local v_13 = nil

		for _, v_14 in v_11, tagged, v_12 do
			if not v_14.Parent:FindFirstChild("IgnoredBerry") then
				local v_15 = localPlayer:DistanceFromCharacter(v_14.Parent:GetAttribute("CFrame").Position)

				if huge > v_15 then
					huge = v_15
					v_13 = v_14
				end
			end
		end

		return v_13
	end

	BerrySection = FarmotherMain.CreateSection("Berry")

	BerrySection.CreateToggle({ Title = "Hop Find Berry", Desc = nil, Default = Settings["Hop Find Berry"] or false }, function(arg)
		SaveSettings("Hop Find Berry", arg)
	end)

	BerrySection.CreateToggle({ Title = "Auto Collect Berry", Desc = nil, Default = Settings["Auto Collect Berry"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Collect Berry"] and task.wait(0.1) do
					pcall(function()
						local v_11 = DetectBerry()

						if v_11 then
							local v_12 = DetectModelBerry(v_11)

							if not v_12 then
								toTarget(v_11.Parent.WorldPivot)
							else
								toTarget(v_12.WorldPivot)
								local proximityPrompt = v_12:FindFirstChild("ProximityPrompt")

								if proximityPrompt then
									fireproximityprompt(proximityPrompt)
								end
							end
						else
							lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Waiting Berry spawn", ShowTime = 5 })

							if Settings["Hop Find Berry"] then
								HopServer()
							end

							wait(5)
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Collect Berry", arg)
	end)

	FarmChestSection = FarmotherMain.CreateSection("Farm Chest")

	FarmChestSection.CreateSlider({
		Title = "Value Collect Chest to Hop",
		Min = 0,
		Max = 100,
		Default = Settings["Value Collect Chest to Hop"] or 20,
		Precise = true,
	}, function(arg)
		SaveSettings("Value Collect Chest to Hop", arg)
	end)

	AutoChest = function()
		if not StackFarmOther then
			return
		end
		local valueCollectChestToHop = Settings["Value Collect Chest to Hop"] or 20
		if CheckNameBoss("Darkbeard") and Settings["Attack Darkbeard"] then
			n3 = valueCollectChestToHop
			return
		end

		if DetectItemPlr("Fist of Darkness") and Settings["Summon Darkbeard"] then
			n3 = valueCollectChestToHop
			return
		end

		if (DetectItemPlr("Fist of Darkness") or DetectItemPlr("God's Chalice")) and Settings["Tween Safe if have Items"] then
			return
		end

		if n3 and n3 >= valueCollectChestToHop and Settings["Auto Chest Hop"] then
			HopServer()
			return
		end
		local v_11 = GetNearestChest()

		if v_11 then
			n3 += 1
			local now = nil

			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v_11.Position).Magnitude <= 5 then
						if not now then
							now = tick()
						elseif tick() - now >= 5 then
							Instance.new("IntValue", v_11).Name = "Ignored"
							wait(0.1)
						end

						if not Settings["Use Method Teleport"] then
							game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
							wait()
							game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
						end

						TweenManager.CancelCurrent()
					end

					if Settings["Use Method Teleport"] then
						localPlayer.Character.HumanoidRootPart.CFrame = v_11.CFrame
						TweenManager.CancelCurrent()
					else
						toTarget(v_11.CFrame, true)
					end

					if not (not v_11 or not v_11.Parent or not Settings["Auto Chest"] or v_11:GetAttribute("IsDisabled") or v_11:FindFirstChild("Ignored") or not v_11:FindFirstChild("TouchInterest") or not StackFarmOther) then
						continue
					end
				end

				break
			end
		else
			local v_12 = PathFindChest()

			if v_12 then
				toTarget(v_12.Part.CFrame)

				if (v_12.Part.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or GetNearestChest() then
					Instance.new("IntValue", v_12).Name = "Ignored"
				end
			else
				for _, child in pairs(game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()) do
					if child:FindFirstChild("Ignored") then
						child:FindFirstChild("Ignored"):Destroy()
					end
				end
			end
		end
	end

	FarmChestSection.CreateToggle({ Title = "Auto Chest Hop", Desc = nil, Default = Settings["Auto Chest Hop"] or false }, function(arg)
		SaveSettings("Auto Chest Hop", arg)
	end)

	FarmChestSection.CreateToggle({
		Title = "Use Method Teleport [ Risk ]",
		Desc = nil,
		Default = Settings["Use Method Teleport"] or false,
	}, function(arg)
		SaveSettings("Use Method Teleport", arg)
	end)

	FarmChestSection.CreateToggle({ Title = "Auto Chest", Desc = nil, Default = Settings["Auto Chest"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Chest"] and task.wait(0.1) do
					local ok, result = pcall(function()
						AutoChest()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Chest", arg)
	end)

	RaidLawSection = FarmotherMain.CreateSection("Raid Law")

	RaidLawSection.CreateToggle({
		Title = "Auto Buy Chip and Attack Law",
		Desc = nil,
		Default = Settings["Auto Buy Chip and Attack Law"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Buy Chip and Attack Law"] and task.wait() do
					pcall(function()
						if DetectItemPlr("Core Brain") then
							fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
							return
						end
						local Order = CheckNameBoss("Order")

						if Order then
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(Order)
									UsedualFlock()
									ClickM1(Order)

									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(Order.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(Order.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
									end

									if not (not IsMobAlive(Order) or not Settings["Auto Buy Chip and Attack Law"]) then
										continue
									end
								end

								break
							end
						elseif not DetectItemPlr("Microchip") and game.Players.LocalPlayer.Data.Fragments.Value >= 1000 then
							BuyChipLaw()
							wait(2)
						elseif DetectItemPlr("Microchip") then
							fireclickdetector(game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Buy Chip and Attack Law", arg)
	end)

	FarmObservationSection = FarmotherMain.CreateSection("Farm Observation")

	FarmObservation = function()
		local str = game.PlaceId == getgenv().CheckPlaceId2 and "Marine Captain" or "Marine Commodore"
		local cframe = DetectMob(str)

		if not game:GetService("Lighting").Blur.Enabled then
			game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
			game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
			task.wait()
			local humanoidRootPart2 = cframe and cframe.HumanoidRootPart or DetectPartSpawnMob(str)
			cframe = cframe and CFrame.new(0, 0, 50) or CFrame.new(0, 60, 0)
			toTarget(humanoidRootPart2.CFrame * cframe)
			task.wait(3)

			if not game:GetService("Lighting").Blur.Enabled and Settings["Farm Observation [ Hop Server ]"] then
				HopServer()
			end
		else
			local humanoidRootPart2 = cframe and cframe.HumanoidRootPart or DetectPartSpawnMob(str)
			local cframe2 = cframe and CFrame.new(0, 0, 3) or CFrame.new(0, 60, 0)

			if cframe then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						toTarget(humanoidRootPart2.CFrame * cframe2)
						if not (not Settings["Farm Observation"] or not game:GetService("Lighting").Blur.Enabled) then
							continue
						end
					end

					break
				end
			else
				toTarget(humanoidRootPart2.CFrame * cframe2)
			end
		end
	end

	ObservationV2 = function()
		if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 0 then
			if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
				local v_11 = DetectMob("Forest Pirate")

				if not v_11 then
					if typeof("Forest Pirate") == "table" then
						if #tbl4 >= 13 then
							tbl4 = {}
							return
						end
						local v_12 = DetectPartSpawnMob(DetectNameTablePart("Forest Pirate"))

						if v_12 then
							table.insert(tbl4, DetectNameTablePart("Forest Pirate"))

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
									if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Forest Pirate") or not Settings["Auto UP Observation V2"]) then
										continue
									end
								end

								break
							end

							wait(1)
						end
					else
						local v_12 = DetectPartSpawnMob("Forest Pirate", true)

						if v_12 then
							Instance.new("IntValue", v_12).Name = "Ignored"

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
									if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Forest Pirate") or not Settings["Auto UP Observation V2"]) then
										continue
									end
								end

								break
							end

							wait(1)
						else
							DeleteIgnoredMobSpawn()
						end
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_11)
							BringMob(v_11)
							UsedualFlock()
							ClickM1(v_11)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_11) or not Settings["Auto UP Observation V2"]) then
								continue
							end
						end

						break
					end
				end
			elseif localPlayer:DistanceFromCharacter(Vector3.new(-12441.591, 331.4885, -7676.1973)) < 10 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "StartQuest", "CitizenQuest", 1 }))
			else
				toTarget(CFrame.new(-12441.5908203125, 331.48849487304688, -7676.197265625))
			end
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 1 then
			if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "1") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
				local v_11 = CheckNameBoss("Captain Elephant")

				if v_11 then
					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_11)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							ClickM1(v_11)
							equiptool(NameWeapon(Settings["Select Weapon"]))
							if not (not IsMobAlive(v_11) or not Settings["Auto UP Observation V2"]) then
								continue
							end
						end

						break
					end
				else
					lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Waiting Boss Captain Elephant", ShowTime = 5 })
					wait(5)
				end
			elseif localPlayer:DistanceFromCharacter(Vector3.new(-12441.591, 331.4885, -7676.1973)) < 10 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "StartQuest", "CitizenQuest", 1 }))
			else
				toTarget(CFrame.new(-12441.5908203125, 331.48849487304688, -7676.197265625))
			end
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
			toTarget(CFrame.new(-12513.8, 336.167, -9872.91))
		elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 3 then
			local v_11 = tonumber
			local v_12 = string.gsub(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk", "Status"), "%D", "")

			if v_11(v_12) >= 5000 then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk2", "Start")
				local flag2 = localPlayer.Data.Beli.Value >= 5000000

				if flag2 then
					flag2 = DetectItemPlr("Pineapple") and DetectItemPlr("Apple") and DetectItemPlr("Banana")
				end

				if flag2 or DetectItemPlr("Fruit Bowl") then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
					game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk2", "Buy")
				else
					for _, v_13 in pairs({ "PineappleSpawner", "BananaSpawner", "AppleSpawner" }) do
						if game:GetService("Workspace"):FindFirstChild(v_13) then
							if game:GetService("Workspace"):FindFirstChild(v_13):FindFirstChildOfClass("Tool") then
								firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace"):FindFirstChild(v_13):FindFirstChildOfClass("Tool").Handle, 0)
							else
								lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Wating Fruit", ShowTime = 5 })
								wait(3)
							end
						end
					end
				end
			else
				local v_13 = next
				local children, v_14 = game.workspace.Enemies:GetChildren()
				local v_15 = nil

				for _, v_16 in v_13, children, v_14 do
					if v_16:IsA("Model") and v_16.Name == "Marine Commodore" and v_16:FindFirstChild("HumanoidRootPart") and v_16.Humanoid.Health > 0 then
						v_15 = v_16
					end
				end

				if not game:GetService("Lighting").Blur.Enabled then
					if v_15 then
						toTarget(v_15.HumanoidRootPart.CFrame * CFrame.new(0, 0, 50))
					end

					game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
					game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
					wait(2)
				elseif not v_15 then
					GetPart = DetectPartSpawnMob("Marine Commodore")
					toTarget(GetPart.CFrame * CFrame.new(0, 60, 0))
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_15.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
							if not (not Settings["Auto UP Observation V2"] or not game:GetService("Lighting").Blur.Enabled) then
								continue
							end
						end

						break
					end
				end
			end
		end
	end

	FarmObservationSection.CreateToggle({
		Title = "Auto UP Observation V2",
		Desc = nil,
		Default = Settings["Auto UP Observation V2"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto UP Observation V2"] and wait(0.1) do
					pcall(function()
						ObservationV2()
					end)
				end
			end)
		end

		SaveSettings("Auto UP Observation V2", arg)
	end)

	FarmObservationSection.CreateToggle({ Title = "Farm Observation", Desc = nil, Default = Settings["Farm Observation"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Farm Observation"] and wait(0.1) do
					pcall(function()
						FarmObservation()
					end)
				end
			end)
		end

		SaveSettings("Farm Observation", arg)
	end)

	FarmObservationSection.CreateToggle({
		Title = "Farm Observation [ Hop Server ]",
		Desc = nil,
		Default = Settings["Farm Observation [ Hop Server ]"] or false,
	}, function(arg)
		if arg and not Settings["Farm Observation"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Farm Observation plz", ShowTime = 5 })
		end

		SaveSettings("Farm Observation [ Hop Server ]", arg)
	end)

	AutoKillMobSection = FarmotherMain.CreateSection("Auto Kill Mob")

	TableMob = function()
		local tbl9 = {}
		local tbl10 = {}
		local v_11 = next
		local v_12, v_13 = v_2(game:GetService("ReplicatedStorage").Quests)

		for _, v_14 in v_11, v_12, v_13 do
			for _, v_15 in next, v_14, nil do
				for k, v_16 in next, v_15.Task, nil do
					if v_16 > 1 then
						table.insert(tbl10, k)
					end
				end
			end
		end

		if game:GetService("Workspace")._WorldOrigin.EnemySpawns:FindFirstChildWhichIsA("Part") then
			for _, child in pairs(game:GetService("Workspace")._WorldOrigin.EnemySpawns:GetChildren()) do
				if not string.find(child.Name, "Boss") and tbl9[child.Name] == nil then
					tbl9[child.Name] = false
				end
			end

			if string.find(game:GetService("Workspace")._WorldOrigin.EnemySpawns:GetChildren()[1].Name, "Lv.") then
				for _, v_14 in pairs(getnilinstances()) do
					if table.find(tbl10, tostring(v_14.Name:gsub(" %pLv. %d+%p", ""))) and tbl9[v_14.Name] == nil then
						tbl9[v_14.Name] = false
					end
				end
			else
				for _, v_14 in pairs(getnilinstances()) do
					if table.find(tbl10, v_14.Name) and tbl9[v_14.Name] == nil then
						tbl9[v_14.Name] = false
					end
				end
			end
		end

		return tbl9
	end

	local createDropdown = AutoKillMobSection.CreateDropdown
	local selectMob = Settings["Select Mob"]

	createDropdown({
		Title = "Select Mob",
		List = PrepareMultiSelectList(TableMob(), selectMob),
		Search = true,
		Selected = true,
		Default = Settings["Select Mob"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Mob", arg, arg2)
	end)

	FarmSelectMob = function()
		if not StackFarmOther then
			return
		end
		local tbl9 = {}

		for k in next, Settings["Select Mob"], nil do
			local str = k:gsub(" %pLv. %d+%p", "")
			table.insert(tbl9, str)
		end

		local v_11 = DetectMob(tbl9)

		if not v_11 then
			if typeof(tbl9) == "table" then
				if #tbl4 >= #tbl9 then
					tbl4 = {}
					return
				end
				local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl9))

				if v_12 then
					table.insert(tbl4, DetectNameTablePart(tbl9))

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
							if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl9) or not Settings["Kill Mob"]) then
								continue
							end
						end

						break
					end

					wait(1)
				end
			else
				local v_12 = DetectPartSpawnMob(tbl9, true)

				if v_12 then
					Instance.new("IntValue", v_12).Name = "Ignored"

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
							if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl9) or not Settings["Kill Mob"]) then
								continue
							end
						end

						break
					end

					wait(1)
				else
					DeleteIgnoredMobSpawn()
				end
			end
		else
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					sizepart(v_11)
					BringMob(v_11)
					UsedualFlock()
					ClickM1(v_11)

					if Settings["Select Weapon"] == "Blox Fruit" then
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
					else
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
					end

					if not (not IsMobAlive(v_11) or not Settings["Kill Mob"] or not StackFarmOther) then
						continue
					end
				end

				break
			end
		end
	end

	AutoKillMobSection.CreateToggle({ Title = "Kill Mob", Desc = nil, Default = Settings["Kill Mob"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Kill Mob"] and task.wait(0.1) do
					local ok, result = pcall(function()
						FarmSelectMob()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Kill Mob", arg)
	end)

	AutoKillBossSection = FarmotherMain.CreateSection("Auto Boss")

	local tbl9 = {
		"Gorilla King",
		"Bobby",
		"The Saw",
		"Yeti",
		"Mob Leader",
		"Vice Admiral",
		"Saber Expert",
		"Warden",
		"Chief Warden",
		"Swan",
		"Magma Admiral",
		"Fishman Lord",
		"Wysper",
		"Thunder God",
		"Cyborg",
		"Ice Admiral",
		"Diamond",
		"Jeremy",
		"Orbitus",
		"Don Swan",
		"Smoke Admiral",
		"Awakened Ice Admiral",
		"Tide Keeper",
		"Stone",
		"Island Empress",
		"Kilo Admiral",
		"Captain Elephant",
		"Beautiful Pirate",
		"Longma",
		"Cake Queen",
		"GreyBeard",
		"Order",
		"Cursed Captain",
		"Darkbeard",
		"Soul Reaper",
		"rip_indra True Form",
		"Mihawk",
		"Cake Prince",
		"Dough King",
	}

	TableBoss = function()
		local tbl10 = {}

		for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
			if table.find(tbl9, child.Name) then
				table.insert(tbl10, child.Name)
			end
		end

		for _, child in pairs(game.ReplicatedStorage:GetChildren()) do
			if table.find(tbl9, child.Name) then
				table.insert(tbl10, child.Name)
			end
		end

		return tbl10
	end

	local v_11 = AutoKillBossSection.CreateDropdown({
		Title = "Select Boss",
		List = TableBoss(),
		Search = true,
		Selected = false,
		Default = Settings["Select Boss"] or nil,
	}, function(arg)
		SaveSettings("Select Boss", arg)
	end)

	AutoKillBossSection.CreateButton({ Title = "Refresh Boss" }, function()
		v_11:GetNewList(TableBoss())
	end)

	AutoKillBoss = function()
		local v_12

		if Settings["Kill All Boss"] then
			v_12 = CheckNameBoss(TableBoss())
		else
			v_12 = CheckNameBoss(Settings["Select Boss"])
		end

		if v_12 then
			while true do
				wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					sizepart(v_12)

					if Settings["Select Weapon"] == "Blox Fruit" then
						toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
					else
						toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
					end

					ClickM1(v_12)
					UsedualFlock()
					if not (not IsMobAlive(v_12) or not Settings["Kill Boss"]) then
						continue
					end
				end

				break
			end
		elseif Settings["Hop Server Find Boss"] then
			HopServer()
			wait(5)
		end
	end

	AutoKillBossSection.CreateToggle({ Title = "Kill Boss", Desc = nil, Default = Settings["Kill Boss"] or false }, function(arg)
		spawn(function()
			while Settings["Kill Boss"] and wait() do
				pcall(function()
					AutoKillBoss()
				end)
			end
		end)

		SaveSettings("Kill Boss", arg)
	end)

	AutoKillBossSection.CreateToggle({ Title = "Kill All Boss", Desc = nil, Default = Settings["Kill All Boss"] or false }, function(arg)
		if arg and not Settings["Kill Boss"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Kill Boss plz", ShowTime = 5 })
		end

		SaveSettings("Kill All Boss", arg)
	end)

	AutoKillBossSection.CreateToggle({
		Title = "Hop Server Find Boss",
		Desc = nil,
		Default = Settings["Hop Server Find Boss"] or false,
	}, function(arg)
		SaveSettings("Hop Server Find Boss", arg)
	end)

	DFRaidMain = Main.CreatePage({ Page_Name = "Fruit and Raid, Dungeon", Page_Title = "Fruit and Raid and Dungeon Tab" })
	DevilFruitSection = DFRaidMain.CreateSection("Devil Fruit")

	DevilFruitSection.CreateToggle({ Title = "Random Devil Fruit", Desc = nil, Default = Settings["Random Devil Fruit"] or false }, function(arg)
		SaveSettings("Random Devil Fruit", arg)
	end)

	DevilFruitSection.CreateToggle({ Title = "Auto Store Fruit", Desc = nil, Default = Settings["Auto Store Fruit"] or false }, function(arg)
		SaveSettings("Auto Store Fruit", arg)
	end)

	DevilFruitSection.CreateDropdown({
		Title = "Blox Fruit Sniper Shop",
		List = PrepareMultiSelectList(TableDevilFruit, Settings["Blox Fruit Sniper Shop"]),
		Search = true,
		Selected = true,
		Default = Settings["Blox Fruit Sniper Shop"] or nil,
	}, function(arg, arg2)
		SaveSettings("Blox Fruit Sniper Shop", arg, arg2)
	end)

	DevilFruitSection.CreateToggle({
		Title = "Buy Blox Fruit Sniper Shop",
		Desc = nil,
		Default = Settings["Buy Blox Fruit Sniper Shop"] or false,
	}, function(arg)
		SaveSettings("Buy Blox Fruit Sniper Shop", arg)
	end)

	RaidsSection = DFRaidMain.CreateSection("Raids")
	local tbl10 = {}
	local v_12 = next
	tbl2 = {}
	local valueSpeedFlyBoat = nil

	pcall(function()
		local v_13 = next
		local v_14, v_15 = v_2(game.ReplicatedStorage.Raids)
		tbl10 = {}
		v_12 = v_13
		tbl2 = v_14
		valueSpeedFlyBoat = v_15
	end)

	for _, v_13 in v_12, tbl2, valueSpeedFlyBoat do
		for _, v_14 in next, v_13, nil do
			table.insert(tbl10, v_14)
		end
	end

	RaidsSection.CreateDropdown({
		Title = "Select Raid",
		List = tbl10,
		Search = true,
		Selected = false,
		Default = Settings["Select Raid"] or nil,
	}, function(arg)
		SaveSettings("Select Raid", arg)
	end)

	RaidsSection.CreateToggle({
		Title = "Get Fruit In Inventory Low Beli",
		Desc = nil,
		Default = Settings["Get Fruit In Inventory Low Beli"] or false,
	}, function(arg)
		SaveSettings("Get Fruit In Inventory Low Beli", arg)
	end)

	getgenv().KillRaidEnemy = function()
		for _, child in ipairs(game.workspace.Enemies:GetChildren()) do
			if IsMobAlive(child) then
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				end
			end
		end
	end

	getgenv().KillRaidEnemyLowhealth = function()
		for _, child in ipairs(game.workspace.Enemies:GetChildren()) do
			if IsMobAlive(child) then
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid and humanoid.MaxHealth > 0 and humanoid.Health / humanoid.MaxHealth < 0.2 then
					humanoid.Health = 0
				end
			end
		end
	end

	DetectMobRaid = function()
		local character = localPlayer and localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local enemies = workspace:FindFirstChild("Enemies")
		local v_13 = nil

		if enemies then
			local huge = math.huge
			v_13 = nil

			for _, child in ipairs(enemies:GetChildren()) do
				if IsMobAlive(child) then
					local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart") or child:IsA("Model") and child.PrimaryPart

					if humanoidRootPart2 then
						local magnitude = (character.Position - humanoidRootPart2.Position).Magnitude

						if magnitude <= 2500 and magnitude < huge then
							huge = magnitude
							v_13 = child
						end
					end
				end
			end
		end

		return v_13
	end

	BringMobNearst = function(arg)
		if DaBringMob then
			delay(0.15, function()
				getgenv().DaBringMob = false
			end)

			return
		end

		if not (arg and arg.Parent) then
			return
		end
		local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local v_13 = cFrame
		local v_14

		if cFrame then
			v_14 = character
		else
			v_14 = v_13
		end

		if v_14 and humanoidRootPart2 and (character.Position - humanoidRootPart2.Position).Magnitude <= 50 then
			local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")

			if enemies then
				for _, child in pairs(enemies:GetChildren()) do
					if child ~= arg and not child:FindFirstChild("Ignored") and IsMobAlive(child) then
						local humanoidRootPart3 = child:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart3 and isnetworkowner2(humanoidRootPart3) and (humanoidRootPart3.Position - cFrame.Position).Magnitude <= 350 then
							sizepart(child)
							local random = math.random
							humanoidRootPart3.CFrame = cFrame * CFrame.new(0, math.random(0, 2), random(0, 2))
							getgenv().DaBringMob = true
						end
					end
				end
			end
		end
	end

	BringMobRaid = function(arg)
		if not Settings["Bring Mob"] then
			return
		end

		if not (arg and arg.Parent) then
			return
		end
		local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end

		if v_6 ~= arg then
			v_6 = arg
			cFrame = humanoidRootPart2.CFrame
			DeleteIgnoredMob()
		end

		if DaBringMob then
			delay(0.1, function()
				getgenv().DaBringMob = false
			end)

			return
		end

		local tbl11 = {}

		if not arg:FindFirstChild("Ignored") then
			table.insert(tbl11, arg)
		end

		local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")

		if enemies and cFrame then
			for _, child in pairs(enemies:GetChildren()) do
				if child ~= arg and child.Name == arg.Name and not child:FindFirstChild("Ignored") and IsMobAlive(child) then
					local humanoidRootPart3 = child:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart3 and isnetworkowner2(humanoidRootPart3) and (humanoidRootPart3.Position - cFrame.Position).Magnitude <= 200 and #tbl11 < 1 then
						table.insert(tbl11, child)
					end
				end
			end
		end

		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		local v_13 = cFrame
		local v_14

		if cFrame then
			v_14 = character
		else
			v_14 = v_13
		end

		if v_14 and humanoidRootPart2 and (character.Position - humanoidRootPart2.Position).Magnitude <= 50 and isnetworkowner2(character) then
			for _, v_15 in pairs(tbl11) do
				if v_15 and v_15.Parent and IsMobAlive(v_15) then
					local humanoidRootPart3 = v_15:FindFirstChild("HumanoidRootPart")
					local humanoid = v_15:FindFirstChildOfClass("Humanoid")

					if humanoidRootPart3 and humanoid and humanoid:IsA("Humanoid") and humanoid.Health > 0 then
						sizepart(v_15)
						local random = math.random
						humanoidRootPart3.CFrame = cFrame * CFrame.new(0, math.random(0, 2), random(0, 2))

						task.spawn(function()
							local health = humanoid.Health
							task.wait(3.5)

							if v_15 and v_15.Parent and not v_15:FindFirstChild("Ignored") then
								local humanoid2 = v_15:FindFirstChildOfClass("Humanoid")
								local humanoidRootPart4 = v_15:FindFirstChild("HumanoidRootPart")

								if humanoid2 and humanoidRootPart4 and humanoid2:IsA("Humanoid") and humanoid2.Health == health and humanoid2.Health > 0 then
									humanoidRootPart4.CFrame = v_15.WorldPivot
									Instance.new("IntValue", v_15).Name = "Ignored"
									task.wait(0.3)
								end
							end
						end)

						getgenv().DaBringMob = true
					end
				end
			end
		end
	end

	local tbl11 = { "Island 1", "Island 2", "Island 3", "Island 4", "Island 5" }

	ResetRaidIslands = function()
		local worldOrigin = wOrigin or game:GetService("Workspace"):FindFirstChild("_WorldOrigin")
		local locations = worldOrigin and worldOrigin:FindFirstChild("Locations")

		if locations then
			for _, child in ipairs(locations:GetChildren()) do
				if child.Name:find("Pass$") then
					child.Name = child.Name:gsub("Pass$", "")
				end
			end
		end

		getgenv().CurrentRaidIsland = 1
		getgenv().CurrentRaidIslandIndex = 1
	end

	NextRaidIsland = function()
		local worldOrigin = wOrigin or game:GetService("Workspace"):FindFirstChild("_WorldOrigin")
		worldOrigin = worldOrigin and worldOrigin:FindFirstChild("Locations")
		if not worldOrigin then
			return nil
		end
		local character = localPlayer and localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local huge = math.huge
		local v_13 = nil
		local v_14 = nil

		for i, v_15 in ipairs(tbl11) do
			for _, child in ipairs(worldOrigin:GetChildren()) do
				if child.Name == v_15 then
					local magnitude = (character.Position - child.Position).Magnitude

					if magnitude < 3500 and magnitude < huge then
						huge = magnitude
						v_13 = child
						v_14 = i
					end
				end
			end
		end

		if v_13 then
			local cFrame2 = v_13.CFrame
			local name = v_13.Name
			v_13.Name = v_13.Name .. "Pass"

			if v_14 then
				getgenv().CurrentRaidIsland = v_14
				getgenv().CurrentRaidIslandIndex = v_14
			end

			local n4 = cFrame2 * CFrame.new(0, 60, 0)

			if name:find("Island 2") and Settings["Select Raid"] == "Phoenix" then
				n4 = cFrame2 * CFrame.new(300, 60, 0)
			end

			toTarget(n4)
			local now = tick()

			while true do
				task.wait(0.1)

				if localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and CheckInRaid() then
					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not (not Settings["Auto Raid"] and not Settings["Auto Multi Raid"]) then
							toTarget(n4)
							local character2 = localPlayer and localPlayer.Character
							character2 = character2 and character2:FindFirstChild("HumanoidRootPart")

							if character2 then
								local magnitude = (character2.Position - n4.Position).Magnitude

								if not (magnitude <= 150) then
									if not (magnitude <= 350 and DetectMobRaid()) then
										if not (tick() - now > 25) then
											continue
										end
									end
								end
							elseif not (tick() - now > 25) then
								continue
							end
						end
					end
				end

				break
			end

			local now2 = tick()

			while true do
				task.wait(0.1)

				if localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and CheckInRaid() then
					if not DetectMobRaid() then
						if not (tick() - now2 > 4) then
							continue
						end
					end
				end

				break
			end

			return v_13
		end

		return nil
	end

	GetLastRaidIsland = NextRaidIsland

	SyncRaidIslandFromMob = function()
	end

	UpdateRaidIslandFromMob = function()
	end

	CheckInRaid = function()
		local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
		local raidTimer = playerGui and playerGui:FindFirstChild("Main") and playerGui.Main:FindFirstChild("TopHUDList") and playerGui.Main.TopHUDList:FindFirstChild("RaidTimer")
		if raidTimer and raidTimer.Visible then
			return true
		end
		local worldOrigin = wOrigin or game:GetService("Workspace"):FindFirstChild("_WorldOrigin")

		if worldOrigin and worldOrigin:FindFirstChild("Locations") then
			for _, child in ipairs(worldOrigin.Locations:GetChildren()) do
				if string.find(child.Name, "Island ") and localPlayer:DistanceFromCharacter(child.Position) < 5000 then
					return true
				end
			end
		end

		return false
	end

	CheckAutoRaid = function()
		local flag2 = not getgenv().buychip
		local visible

		if flag2 then
			visible = flag2
		else
			visible = game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and CheckInRaid()
		end

		if visible then
			return true
		end
	end

	getgenv().CheckIsplayingRaid = function()
		local flag2 = DetectItemPlr("Special Microchip") or not getgenv().buychip
		local visible

		if flag2 then
			visible = flag2
		else
			visible = game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and CheckInRaid()
		end

		if visible then
			return true
		end
	end

	getgenv().buychip = true

	RaidsSection.CreateToggle({ Title = "Auto Raid", Desc = nil, Default = Settings["Auto Raid"] or false }, function(arg)
		if arg then
			if not CheckInRaid() then
				ResetRaidIslands()
			end

			spawn(function()
				while Settings["Auto Raid"] and task.wait() do
					local ok, result = pcall(function()
						local main = game.PlaceId == getgenv().CheckPlaceId2 and game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button:FindFirstChild("Main")
						local main2

						if game.PlaceId == getgenv().CheckPlaceId then
							main2 = game:GetService("Workspace").Map:FindFirstChild("Boat Castle") and game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button:FindFirstChild("Main")
						else
							main2 = main
						end

						local v_13 = main2

						if not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and not CheckInRaid() then
							ResetRaidIslands()
							if getgenv().TickTeleCastle and tick() - getgenv().TickTeleCastle < 5 then
								return
							end

							if not v_13 then
								if not DetectItemPlr("Special Microchip") then
									toTarget(CFrame.new(-5500, 314, -2855))
								else
									toTarget(CFrame.new(-5500, 314, -2855), false, true)
								end

								return
							end
						end

						if DetectItemPlr("Special Microchip") then
							if getgenv().waitgoraid then
								wait(5)
								getgenv().waitgoraid = false
							end

							getgenv().buychip = false
							fireclickdetector(v_13.ClickDetector)
							getgenv().TickTeleCastle = tick()

							if getgenv().Tween then
								getgenv().Tween:Pause()
								getgenv().Tween:Cancel()
							end

							return
						end

						if localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and CheckInRaid() then
							getgenv().waitgoraid = true
							getgenv().buychip = true
							local v_14 = DetectMobRaid()

							if v_14 then
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										if not getgenv().KillMobRaid and Settings["Kill Aura Only Raid And Volcano"] then
											getgenv().KillMobRaid = true
											local timeDelayKill = Settings["Time Delay Kill"] or 5

											pcall(function()
												v_14.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
											end)

											delay(timeDelayKill, function()
												getgenv().KillMobRaid = false
											end)
										end

										UsedualFlock()
										ClickM1(v_14)
										sizepart(v_14)
										BringMobRaid(v_14)
										local humanoidRootPart2 = v_14:FindFirstChild("HumanoidRootPart") or v_14:IsA("Model") and v_14.PrimaryPart

										if humanoidRootPart2 then
											if Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
											else
												toTarget(humanoidRootPart2.CFrame * CFrame.new(10, 20, 0))
											end

											if not (not IsMobAlive(v_14) or not Settings["Auto Raid"] or not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible) then
												continue
											end
										end
									end

									break
								end
							else
								NextRaidIsland()
							end

							return
						end

						if getgenv().buychip and localPlayer.Data.Level.Value >= 1100 and not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and not DetectItemPlr("Special Microchip") and not CheckInRaid() then
							if Settings["Hop Sever Raid"] then
								local v_14 = GetPathFruit()

								if v_14 then
									if not ((v_14.Handle.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 5) then
										toTarget(v_14.Handle.CFrame, true)
									end

									return
								end

								if not CheckFruitplr() then
									HopServer()
									wait(5)
									return
								end
							end

							if not CheckFruitplr() and TakeFruitInventory(true) and Settings["Get Fruit In Inventory Low Beli"] then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", TakeFruitInventory(true))
							end

							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", Settings["Select Raid"] or "Flame")
							wait(1)
						end
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Raid", arg)
	end)

	RaidsSection.CreateToggle({ Title = "Hop Sever Raid", Desc = nil, Default = Settings["Hop Sever Raid"] or false }, function(arg)
		if arg and not Settings["Auto Raid"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Auto Raid Plz", ShowTime = 5 })
		end

		SaveSettings("Hop Sever Raid", arg)
	end)

	RaidsSection.CreateToggle({ Title = "Auto Awake Fruit", Desc = nil, Default = Settings["Auto Awake Fruit"] or false }, function(arg)
		SaveSettings("Auto Awake Fruit", arg)
	end)

	MultiRaidsSection = DFRaidMain.CreateSection("Multi Raid")

	DetectNamePlayerMulti = function()
		local tbl12 = {}
		local v_13 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_13(Players2:GetChildren()) do
			if child.Name ~= localPlayer.Name then
				tbl12[child.Name] = false
			end
		end

		return tbl12
	end

	local createDropdown2 = MultiRaidsSection.CreateDropdown
	local selectPlayerMultiRaid = Settings["Select Player Multi Raid"]

	DropdownSelectPlayerMultiRaid = createDropdown2({
		Title = "Select Player Multi Raid",
		List = PrepareMultiSelectList(DetectNamePlayerMulti(), selectPlayerMultiRaid),
		Search = true,
		Selected = true,
		Default = Settings["Select Player Multi Raid"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Player Multi Raid", arg, arg2)
	end)

	MultiRaidsSection.CreateButton({ Title = "Refresh Player" }, function()
		DropdownSelectPlayerMultiRaid:GetNewList(DetectNamePlayerMulti())
	end)

	MultiRaidsSection.CreateToggle({ Title = "Account Buy Chip", Desc = nil, Default = Settings["Account Buy Chip"] or false }, function(arg)
		SaveSettings("Account Buy Chip", arg)
	end)

	MultiRaidsSection.CreateToggle({
		Title = "Account Pick Slot Raid",
		Desc = nil,
		Default = Settings["Account Pick Slot Raid"] or false,
	}, function(arg)
		SaveSettings("Account Pick Slot Raid", arg)
	end)

	DetectSlotRaid = function(arg)
		local v_13 = next
		local children, v_14 = arg:GetChildren()

		for _, v_15 in v_13, children, v_14 do
			if v_15:FindFirstChild("Hitbox") and v_15.Color.BrickColor.Name ~= "Lime green" then
				return v_15
			end
		end
	end

	NearSlotRaid = function(arg)
		local v_13 = next
		local children, v_14 = arg:GetChildren()

		for _, v_15 in v_13, children, v_14 do
			if v_15:FindFirstChild("Hitbox") then
				if localPlayer:DistanceFromCharacter(v_15.Hitbox.Position) < 10 then
					return true
				end
			end
		end
	end

	DetectMultiStartRaid = function(arg)
		local tbl12 = {}

		if Settings["Select Player Multi Raid"] then
			local v_13 = next
			local children, v_14 = arg:GetChildren()

			for _, v_15 in v_13, children, v_14 do
				if v_15:FindFirstChild("Hitbox") then
					for k in next, Settings["Select Player Multi Raid"], nil do
						if game.Players[k]:DistanceFromCharacter(v_15.Hitbox.Position) > 10 then
							table.insert(tbl12, k)
						end
					end
				end
			end
		end

		if #tbl12 == 0 then
			return true
		end
	end

	Multiraid = function(arg)
		local main = game.PlaceId == getgenv().CheckPlaceId2 and game:GetService("Workspace").Map.CircleIsland.RaidSummon2.Button:FindFirstChild("Main")

		if game.PlaceId == getgenv().CheckPlaceId then
			main = game:GetService("Workspace").Map:FindFirstChild("Boat Castle") and game:GetService("Workspace").Map["Boat Castle"].RaidSummon2.Button:FindFirstChild("Main")
		end

		if not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and not CheckInRaid() then
			if not main then
				if not DetectItemPlr("Special Microchip") then
					toTarget(CFrame.new(-5500, 314, -2855))
				else
					toTarget(CFrame.new(-5500, 314, -2855), false, true)
				end

				return
			end
		end

		if Settings["Account Pick Slot Raid"] then
			if not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and not CheckInRaid() and not NearSlotRaid(main.Parent.Parent) then
				local v_13 = Random.new():NextNumber(0, 2)
				task.wait(v_13)
				toTarget(DetectSlotRaid(main.Parent.Parent).Hitbox.CFrame * CFrame.new(0, -2, 0))
			end
		end

		if DetectItemPlr("Special Microchip") then
			if getgenv().waitgoraid then
				wait(5)
				getgenv().waitgoraid = false
			end

			getgenv().buychip = false

			if DetectMultiStartRaid(main.Parent.Parent) and Settings["Account Buy Chip"] then
				fireclickdetector(main.ClickDetector)
			end

			if getgenv().Tween then
				getgenv().Tween:Pause()
				getgenv().Tween:Cancel()
			end

			return
		end

		if not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and not CheckInRaid() then
			ResetRaidIslands()
		end

		if localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and CheckInRaid() then
			getgenv().waitgoraid = true
			getgenv().buychip = true
			local v_13 = DetectMobRaid()

			if v_13 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						UsedualFlock()
						ClickM1(v_13)
						local humanoidRootPart2 = v_13:FindFirstChild("HumanoidRootPart") or v_13:IsA("Model") and v_13.PrimaryPart

						if humanoidRootPart2 then
							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(humanoidRootPart2.CFrame * CFrame.new(10, 20, 0))
							end

							if not (not IsMobAlive(v_13) or not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible) then
								continue
							end
						end
					end

					break
				end
			else
				NextRaidIsland()
			end

			return
		end

		if Settings["Account Buy Chip"] and getgenv().buychip and localPlayer.Data.Level.Value >= 1100 and not localPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and not DetectItemPlr("Special Microchip") and not CheckInRaid() then
			if not CheckFruitplr() and TakeFruitInventory(true) and Settings["Get Fruit In Inventory Low Beli"] then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", TakeFruitInventory(true))
			end

			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", arg or "Flame")
			wait(1)
		end
	end

	MultiRaidsSection.CreateToggle({ Title = "Auto Multi Raid", Desc = nil, Default = Settings["Auto Multi Raid"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Multi Raid"] and task.wait(0.1) do
					local ok, result = pcall(function()
						Multiraid(Settings["Select Raid"])
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Multi Raid", arg)
	end)

	local v_13 = nil

	pcall(function()
		v_13 = v_2(game:GetService("ReplicatedStorage").Controllers.BannerClient)
	end)

	local function fn7()
		if v_13 and v_13.TryGetBannerItemIfActiveAsync then
			local v_14 = v_13.TryGetBannerItemIfActiveAsync()
			if v_14 and v_14.BoxName then
				return v_14.BoxName
			end
		end

		return "ZiolesGacha"
	end

	local function fn8()
		local GachaNetworkRF = v_2(game:GetService("ReplicatedStorage").Modules.Net):RemoteFunction("GachaNetworkRF")
		local v_14 = fn7()
		local tbl12 = { Context = "Check", BoxName = v_14 }

		if v_14 == "ZiolesGacha" then
			tbl12.SpokeNPC = "Blox Fruit Gacha"
		end

		local response = GachaNetworkRF:InvokeServer(tbl12)
		if response.Level.RequirementMet == false then
			warn("Chưa Lv50")
			return false
		end

		if response.RequirementsMet ~= true then
			return false
		end
		return GachaNetworkRF:InvokeServer({ Context = "Purchase", BoxName = v_14 }) == true
	end

	RandomFruit = function()
		fn8()
	end

	DetectCountDF = function()
		local v_14 = getbackpack()
		if #v_14 < 1 then
			return
		end
		local value = localPlayer.Data.FruitCap.Value
		local v_15 = fn6()

		for _, v_16 in v_14, nil, nil do
			local attribute = v_16:GetAttribute("OriginalName")

			for _, v_17 in v_15, nil, nil do
				if v_17.Type == "Blox Fruit" and (v_17.Name == attribute and v_17.Count < value or v_17.Name ~= attribute) then
					return true
				end
			end
		end
	end

	local v_14 = nil

	pcall(function()
		v_14 = v_2(game:GetService("ReplicatedStorage").FruitInfo)
	end)

	StoreFruit = function(arg)
		if not arg or typeof(arg) ~= "Instance" then
			return
		end

		for _, child in pairs(arg:GetChildren()) do
			if child:IsA("Tool") and string.find(child.Name, "Fruit") and not child:FindFirstChild("Ignored") then
				local v_15 = string.gsub(child.Name, " Fruit", "")
				local attribute = child:GetAttribute("OriginalName") or v_15 .. "-" .. v_15

				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", attribute, child)
				end)

				local intValue = Instance.new("IntValue")
				intValue.Name = "Ignored"
				intValue.Parent = child
				local selectRarityFruit = Settings["Webhook Store Fruit"] and Settings["Select Rarity Fruit"]
				local list

				if selectRarityFruit then
					list = v_14 and v_14.List and v_14.List[attribute] and Settings["Select Rarity Fruit"][v_14.List[attribute].Rarity.Name] or SkinFruit[child.Name]
				else
					list = selectRarityFruit
				end

				if list then
					local webhookStoreFruit = getgenv().WebhookStoreFruit or WebhookStoreFruit

					if webhookStoreFruit then
						webhookStoreFruit(child.Name)
					end
				end

				task.wait(2)
			end
		end
	end

	DetectFruitShop = function()
		local v_15 = next
		local response, v_16 = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", false)

		for _, v_17 in v_15, response, v_16 do
			if Settings["Blox Fruit Sniper Shop"][v_17.Name] then
				if v_17.OnSale then
					return v_17.Name
				end
			end
		end
	end

	BuyFruitShop = function()
		local v_15 = DetectFruitShop()

		if not Settings["Blox Fruit Sniper Shop"][game:GetService("Players").LocalPlayer.Data.DevilFruit.Value] and v_15 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", v_15)
		end
	end

	DungeonJoinSection = DFRaidMain.CreateSection("Join Dungeon")

	DetectNamePlayer = function()
		local tbl12 = {}
		local v_15 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_15(Players2:GetChildren()) do
			if child.Name ~= localPlayer.Name and not table.find(tbl12, child.Name) then
				table.insert(tbl12, child.Name)
			end
		end

		return tbl12
	end

	DropdownDropdownSelectAccountJoin = DungeonJoinSection.CreateDropdown({
		Title = "Select Account Join",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Account Join"] or nil,
	}, function(arg)
		SaveSettings("Select Account Join", arg)
	end)

	DungeonJoinSection.CreateButton({ Title = "Refresh Player" }, function()
		DropdownDropdownSelectAccountJoin:GetNewList(DetectNamePlayer())
	end)

	DetectPadJoinDungeon = function(arg)
		local v_15 = next
		local children, v_16 = workspace.Map["Simulation Hub"].Pads:GetChildren()

		for _, v_17 in v_15, children, v_16 do
			local flag2

			if arg then
				local userId = game.Players.LocalPlayer.UserId
				flag2 = v_17:GetAttribute("Initiator") == userId
			else
				flag2 = arg
			end

			if flag2 or v_17:GetAttribute("NumPlayersOnPad") == 0 then
				return v_17
			end
		end
	end

	DungeonJoinSection.CreateSlider({
		Title = "Min Player Join Dungeon",
		Min = 0,
		Max = 4,
		Default = Settings["Min Player Join Dungeon"] or 2,
		Precise = true,
	}, function(arg)
		SaveSettings("Min Player Join Dungeon", arg)
	end)

	DungeonJoinSection.CreateDropdown({
		Title = "Select Difficulty",
		List = { "Normal", "Hard", "Challenge" },
		Search = true,
		Selected = false,
		Default = Settings["Select Difficulty"] or nil,
	}, function(arg)
		SaveSettings("Select Difficulty", arg)
	end)

	DungeonJoinSection.CreateToggle({
		Title = "Account Start Dungeon",
		Desc = "Account Start Dungeon",
		Default = Settings["Account Start Dungeon"] or false,
	}, function(arg)
		SaveSettings("Account Start Dungeon", arg)
	end)

	DungeonJoinSection.CreateToggle({
		Title = "Auto Join Dungeon",
		Desc = "Auto Join Dungeon",
		Default = Settings["Auto Join Dungeon"] or false,
	}, function(arg)
		spawn(function()
			while Settings["Auto Join Dungeon"] and task.wait() do
				local ok, result = pcall(function()
					if game:GetService("ReplicatedStorage").DungeonReplicationObjects:FindFirstChildWhichIsA("Folder") then
						return
					end

					if Settings["Account Start Dungeon"] then
						if not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DungeonQueueSettingsMenu") or not game:GetService("Players").LocalPlayer.PlayerGui.DungeonQueueSettingsMenu.Enabled then
							local v_15 = DetectPadJoinDungeon()

							if v_15 then
								toTarget(v_15.PrimaryPart.CFrame * CFrame.new(0, 5, 0))
							end
						else
							local v_15 = DetectPadJoinDungeon(true)
							local attribute = v_15 and v_15:GetAttribute("NumPlayersOnPad") or 0
							local selectDifficulty = Settings["Select Difficulty"] or "Normal"

							if v_15:GetAttribute("Difficulty") ~= selectDifficulty then
								v_15.DungeonSettingsChanged:FireServer(unpack({ "Difficulty", selectDifficulty }))
							end

							if Settings["Min Player Join Dungeon"] <= attribute then
								v_15:FindFirstChild("DungeonSettingsChanged"):FireServer("Start")
								wait(2)
							end
						end
					elseif not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("DungeonQueueSettingsMenu") or not game:GetService("Players").LocalPlayer.PlayerGui.DungeonQueueSettingsMenu.Enabled then
						local v_15 = game:GetService("Players"):FindFirstChild(Settings["Select Account Join"] or "")

						if v_15 then
							toTarget(v_15.Character.HumanoidRootPart.CFrame)
						end
					end
				end)

				if result then
					print(result)
				end
			end
		end)

		SaveSettings("Auto Join Dungeon", arg)
	end)

	DungeonSection = DFRaidMain.CreateSection("Dungeon")

	DungeonSection.CreateDropdown({
		Title = "Select Weapon Dungeon",
		List = { "Melee", "Sword", "Blox Fruit", "Gun" },
		Search = true,
		Selected = false,
		Default = Settings["Select Weapon Dungeon"] or nil,
	}, function(arg)
		SaveSettings("Select Weapon Dungeon", arg)
	end)

	GetInfoDungeon = function(arg)
		local v_15 = game.ReplicatedStorage:WaitForChild("DungeonReplicationObjects"):FindFirstChild(arg, true)
		if v_15 then
			return v_15
		end
	end

	GetCurrentFloor = function()
		local attribute = localPlayer:GetAttribute("ExplorerGUID")
		attribute = attribute and GetInfoDungeon(attribute)
		if attribute then
			return attribute:GetAttribute("FloorId")
		end
	end

	GetHightFloor = function()
		local attribute = localPlayer:GetAttribute("ExplorerGUID")
		attribute = attribute and GetInfoDungeon(attribute)
		if attribute then
			return attribute.Parent.Parent:GetAttribute("CurrentExploredLevel")
		end
	end

	IsPointInsideModel = function(arg, arg2)
		if not arg or not arg:IsA("Model") then
			return false
		end
		local boundingBox, v_15 = arg:GetBoundingBox()
		local v_16 = boundingBox:PointToObjectSpace(arg2)
		local n4 = v_15 * 0.5
		local x = n4.X
		local flag2 = math.abs(v_16.X) <= x

		if flag2 then
			local y = n4.Y
			flag2 = math.abs(v_16.Y) <= y
		end

		if flag2 then
			local z = n4.Z
			flag2 = math.abs(v_16.Z) <= z
		end

		return flag2
	end

	DetectMobDungeon = function()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local v_15 = GetHightFloor()
		if not v_15 then
			return nil
		end
		local v_16 = workspace.Map.Dungeon:FindFirstChild(tostring(v_15))
		if not v_16 then
			return nil
		end
		local huge = math.huge
		local v_17 = nil

		for _, child in ipairs(workspace.Enemies:GetChildren()) do
			if IsMobAlive(child) and child.Name ~= "Blank Buddy" then
				local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
				child:FindFirstChildOfClass("Humanoid")

				if IsPointInsideModel(v_16, humanoidRootPart2.Position) then
					local magnitude = (humanoidRootPart2.Position - character.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v_17 = child
					end
				end
			end
		end

		return v_17
	end

	DetectPropHitboxPlaceholder = function()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local v_15 = GetHightFloor()
		if not v_15 then
			return nil
		end
		local v_16 = workspace.Map.Dungeon:FindFirstChild(tostring(v_15))
		if not v_16 then
			return nil
		end
		local huge = math.huge
		local v_17 = nil

		for _, child in ipairs(workspace.Enemies:GetChildren()) do
			if IsMobAlive(child) and child.Name == "PropHitboxPlaceholder" then
				local humanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")
				child:FindFirstChildOfClass("Humanoid")

				if IsPointInsideModel(v_16, humanoidRootPart2.Position) then
					local magnitude = (humanoidRootPart2.Position - character.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v_17 = child
					end
				end
			end
		end

		return v_17
	end

	ExplorerBuffs = { ExplorerBuffs = {} }

	pcall(function()
		ExplorerBuffs = v_2(game:GetService("ReplicatedStorage").DungeonShared.ExplorerBuffs)
	end)

	stripFont = function(arg)
		return (arg:gsub("<.->", ""))
	end

	DisplayNameToKey = {}

	for k, explorerBuff in pairs(ExplorerBuffs.ExplorerBuffs) do
		if explorerBuff.DisplayName then
			DisplayNameToKey[stripFont(explorerBuff.DisplayName)] = k
		end
	end

	CORE_BUFF_KEYS = {
		"Lifesteal",
		"AllCooldown",
		"AttackSpeedMultiplier",
		"FruitTAPCooldown",
		"Armor",
		"Sniper",
		"Overflow",
		"Gun",
		"Sword",
		"Melee",
		"Fruit",
		"Defense",
	}

	TableCardpriority = {}

	for _, v_15 in ipairs(CORE_BUFF_KEYS) do
		local v_16 = ExplorerBuffs.ExplorerBuffs[v_15]

		if v_16 and v_16.DisplayName then
			table.insert(TableCardpriority, stripFont(v_16.DisplayName))
		end
	end

	BuildPriorityMap = function(arg)
		local tbl12 = {}

		for _, v_15 in ipairs(arg) do
			local v_16 = DisplayNameToKey[v_15]

			if v_16 then
				tbl12[v_16] = true
			end
		end

		return tbl12
	end

	IsSkillCooldown = function(arg)
		if not arg then
			return false
		end

		if arg:find("Cooldown") then
			if arg:find("ZCooldown") or arg:find("XCooldown") or arg:find("CCooldown") or arg:find("VCooldown") then
				return true
			end
		end

		return false
	end

	DungeonSection.CreateDropdown({
		Title = "Select Card Priority",
		List = TableCardpriority,
		Search = true,
		Priority = true,
		Default = Settings["Select Card Priority"] or {},
	}, function(arg)
		if typeof(arg) ~= "table" then
			return
		end
		SaveSettings("Select Card Priority", table.clone(arg))
	end)

	AutoPickDungeonCard = function()
		local selectCardPriority = Settings["Select Card Priority"] or {}
		local tbl12 = {}
		local huge = math.huge
		local v_15 = nil

		for _, child in pairs(localPlayer.PlayerGui:GetChildren()) do
			local displayName = child:FindFirstChild("DisplayName", true)
			local buffDescription = child:FindFirstChild("BuffDescription", true)
			local textButton = child:FindFirstChildWhichIsA("TextButton", true)

			if displayName and buffDescription and textButton and displayName:IsA("TextLabel") then
				local v_16 = DisplayNameToKey[stripFont(displayName.Text)]

				if v_16 then
					if not IsSkillCooldown(v_16) then
						for i, v_17 in ipairs(selectCardPriority) do
							if DisplayNameToKey[v_17] == v_16 then
								if i < huge then
									huge = i
									v_15 = textButton
								end

								break
							end
						end

						table.insert(tbl12, textButton)
					end
				end
			end
		end

		if v_15 then
			print("AUTO PICK (PRIORITY INDEX):", huge)

			for _, v_16 in pairs(getconnections(v_15.Activated)) do
				v_16.Function()
			end

			return true
		end

		if #tbl12 > 0 then
			local v_16 = tbl12[math.random(1, #tbl12)]
			print("AUTO PICK (RANDOM)")

			for _, v_17 in pairs(getconnections(v_16.Activated)) do
				v_17.Function()
			end

			return true
		end

		return false
	end

	DungeonSection.CreateToggle({
		Title = "Auto Attack Dungeon",
		Desc = "Auto Attack Mob and go next Floor",
		Default = Settings["Auto Attack Dungeon"] or false,
	}, function(arg)
		SaveSettings("Auto Attack Dungeon", arg)
		if not arg then
			return
		end

		task.spawn(function()
			while Settings["Auto Attack Dungeon"] do
				task.wait()

				local ok, result = pcall(function()
					if localPlayer.Character.Humanoid.Health <= 0 then
						return
					end
					local v_15 = GetCurrentFloor()
					local v_16 = GetHightFloor()
					if not v_15 or not v_16 then
						return
					end

					if v_15 ~= v_16 then
						getgenv().AutoDungeonNextFloor = true
						local v_17 = workspace.Map.Dungeon:FindFirstChild(tostring(v_16 - 1))

						if v_17 and v_17:FindFirstChild("ExitTeleporter") and v_17.ExitTeleporter:FindFirstChild("Root") and v_17.ExitTeleporter.Root:FindFirstChild("TouchInterest") then
							if localPlayer:DistanceFromCharacter(v_17.ExitTeleporter.Root.Position) > 15 then
								task.wait(1)
								toTarget(v_17.ExitTeleporter.Root.CFrame * CFrame.new(0, 5, 0))
							else
								task.wait(3)
							end
						end

						return
					end

					if getgenv().AutoDungeonNextFloor then
						TweenManager.CancelCurrent()
						getgenv().AutoDungeonNextFloor = false
					end

					local v_17 = DetectMobDungeon()
					local v_18 = DetectPropHitboxPlaceholder()
					if not v_17 or not IsMobAlive(v_17) then
						return
					end

					if v_18 then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if Settings["Auto Attack Dungeon"] then
									if IsMobAlive(v_18) then
										if not (not GetCurrentFloor() or GetCurrentFloor() ~= GetHightFloor()) then
											local selectWeaponDungeon = Settings["Select Weapon Dungeon"] or "Melee"
											equiptool(NameWeapon(selectWeaponDungeon))

											if selectWeaponDungeon == "Gun" then
												if NameWeapon(selectWeaponDungeon) == "Dragonstorm" then
													SpamGunDragonStorm(v_18.HumanoidRootPart)
												else
													ShootM1(v_18)
												end
											else
												ClickM1Dungeon(v_18)
											end

											sizepart(v_18)

											if selectWeaponDungeon == "Blox Fruit" then
												toTarget(v_18.HumanoidRootPart.CFrame * CFrame.new(-7, 12, 0))
											else
												toTarget(v_18.HumanoidRootPart.CFrame * CFrame.new(10, 20, 0))
											end

											if not (localPlayer.Character.Humanoid.Health <= 0) then
												continue
											end
										end
									end
								end
							end

							break
						end
					else
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if Settings["Auto Attack Dungeon"] then
									if IsMobAlive(v_17) then
										if not (not GetCurrentFloor() or GetCurrentFloor() ~= GetHightFloor()) then
											local selectWeaponDungeon = Settings["Select Weapon Dungeon"] or "Melee"
											equiptool(NameWeapon(selectWeaponDungeon))

											if selectWeaponDungeon == "Gun" then
												if NameWeapon(selectWeaponDungeon) == "Dragonstorm" then
													SpamGunDragonStorm(v_17.HumanoidRootPart)
												else
													ShootM1(v_17)
												end
											else
												ClickM1Dungeon(v_17)
											end

											sizepart(v_17)

											if selectWeaponDungeon == "Blox Fruit" then
												toTarget(v_17.HumanoidRootPart.CFrame * CFrame.new(-7, 12, 0))
											else
												toTarget(v_17.HumanoidRootPart.CFrame * CFrame.new(10, 20, 0))
											end

											if not (localPlayer.Character.Humanoid.Health <= 0 or DetectPropHitboxPlaceholder()) then
												continue
											end
										end
									end
								end
							end

							break
						end
					end
				end)

				if result then
					warn("[Auto Dungeon Error]:", result)
				end
			end
		end)
	end)

	DungeonSection.CreateToggle({
		Title = "Auto Pick Card Dungeon",
		Desc = nil,
		Default = Settings["Auto Pick Card Dungeon"] or false,
	}, function(arg)
		SaveSettings("Auto Pick Card Dungeon", arg)
		if not arg then
			return
		end

		task.spawn(function()
			while Settings["Auto Pick Card Dungeon"] do
				task.wait()

				local ok, result = pcall(function()
					AutoPickDungeonCard()
				end)

				if result then
					warn("[Auto Pick Card Dungeon Error]:", result)
				end
			end
		end)
	end)

	local tbl12 = {
		["Zone 1"] = CFrame.new(-21767.4765625, 0, 5815.41259765625),
		["Zone 2"] = CFrame.new(-26017.931640625, 0, 5657.8837890625),
		["Zone 3"] = CFrame.new(-29545.703125, 0, 6377.98974609375),
		["Zone 4"] = CFrame.new(-33609.7578125, 0, 7422.890625),
		["Zone 5"] = CFrame.new(-38480.42578125, 0, 10350.943359375),
		["Zone 6"] = CFrame.new(-32975.9921875, 0, 25963.7109375),
	}

	tbl6 = { Melee = false, Sword = false, Gun = false, ["Blox Fruit"] = false }
	SeaEventTab = Main.CreatePage({ Page_Name = "Sea Event", Page_Title = "Sea Event Tab" })
	SettingSeaEventSection = SeaEventTab.CreateSection("Setting")

	SettingSeaEventSection.CreateDropdown({
		Title = "Select Zone",
		List = { "Zone 1", "Zone 2", "Zone 3", "Zone 4", "Zone 5", "Zone 6" },
		Search = true,
		Selected = false,
		Default = Settings["Select Zone"] or nil,
	}, function(arg)
		SaveSettings("Select Zone", arg)
	end)

	SettingSeaEventSection.CreateDropdown({
		Title = "Select Sea Events",
		List = PrepareMultiSelectList({
			SeaBeast = false,
			Ship = false,
			Shark = false,
			Terrorshark = false,
			Piranha = false,
			["Only Farm Ship Brigade"] = false,
		}, Settings["Select Sea Events"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Sea Events"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Sea Events", arg, arg2)
	end)

	SettingSeaEventSection.CreateDropdown({
		Title = "Select Boat",
		List = { "Beast Hunter", "Guardian", "Lantern", "Seleigh", "Brigade", "GrandBrigade" },
		Search = true,
		Selected = false,
		Default = Settings["Select Boat"] or nil,
	}, function(arg)
		SaveSettings("Select Boat", arg)
	end)

	SettingSeaEventSection.CreateDropdown({
		Title = "Select Weapons Use Skill",
		List = PrepareMultiSelectList(tbl6, Settings["Select Weapons Use Skill"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Weapons Use Skill"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Weapons Use Skill", arg, arg2)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Use Dragonstorm For Sea Event",
		Desc = "Only Farm Boat and Fish and TerrorShark",
		Default = Settings["Use Dragonstorm For Sea Event"] or false,
	}, function(arg)
		SaveSettings("Use Dragonstorm For Sea Event", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Use Click M1 Skull Guitar For Sea Event",
		Desc = "Only Farm Boat and Seabeast",
		Default = Settings["Use Click M1 Skull Guitar For Sea Event"] or false,
	}, function(arg)
		SaveSettings("Use Click M1 Skull Guitar For Sea Event", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Auto Change Dragonstorm With Skull Guitar",
		Desc = "When Kill Boat and Fish and TerrorShark use Dragonstorm\nKill Seabeast use Seabeast",
		Default = Settings["Auto Change Dragonstorm With Skull Guitar"] or false,
	}, function(arg)
		SaveSettings("Auto Change Dragonstorm With Skull Guitar", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Auto Change Dragonstorm When Kill Boat",
		Desc = nil,
		Default = Settings["Auto Change Dragonstorm When Kill Boat"] or false,
	}, function(arg)
		SaveSettings("Auto Change Dragonstorm When Kill Boat", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Use Click M1 Fruit For Sea Event",
		Desc = nil,
		Default = Settings["Use Click M1 Fruit For Sea Event"] or false,
	}, function(arg)
		SaveSettings("Use Click M1 Fruit For Sea Event", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Reset Character Buy Boat",
		Desc = "if u spawn in tiki it will reset for buy boat",
		Default = Settings["Reset Character Buy Boat"] or false,
	}, function(arg)
		SaveSettings("Reset Character Buy Boat", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Auto Dodge Skill Terrorshark",
		Desc = nil,
		Default = Settings["Auto Dodge Skill Terrorshark"] or false,
	}, function(arg)
		SaveSettings("Auto Dodge Skill Terrorshark", arg)
	end)

	local tbl13 = { "rbxassetid://8708221792", "rbxassetid://8708222556" }

	game.workspace._WorldOrigin.ChildAdded:Connect(function(child)
		if (Settings["Auto Sea Event"] or Settings["Auto Shipwright"]) and Settings["Auto Dodge Skill Terrorshark"] and getgenv().PathTerrorshark then
			local flag2 = child:IsA("Part") and (child.Name == "SharkSplash" or child.Name == "ChargeUp")
			local flag3

			if flag2 then
				local position = child.Position
				flag3 = (getgenv().PathTerrorshark.HumanoidRootPart.Position - position).Magnitude < 20
			else
				flag3 = flag2
			end

			if flag3 then
				getgenv().Doding = true
				getgenv().ReadyToDodge = true
				local now = tick()

				while true do
					wait(0.2)
					if not (not child or not child.Parent or tick() - now > 14) then
						continue
					end
					break
				end

				if tick() - now < 1 then
					wait(2.5)
				end

				getgenv().Doding = false
				getgenv().ReadyToDodge = false
			end
		end
	end)

	getgenv().PosDodgeskill = 0

	AddAnimationSeabeastPlayed = function(arg)
		local animationPlayed = arg.Humanoid.AnimationPlayed

		getgenv().PathAnimationSeabit = animationPlayed:Connect(function(arg2)
			if table.find(tbl13, tostring(arg2.Animation.AnimationId)) then
				getgenv().PosDodgeskill = 0

				if tostring(arg2.Animation.AnimationId) == "rbxassetid://8708222556" then
					task.wait(0.7)
				else
					task.wait(1.9)
				end

				local now = tick()
				getgenv().PosDodgeskill = 600

				while true do
					task.wait()
					if not (not arg2.IsPlaying or tick() - now >= 10) then
						continue
					end
					break
				end

				getgenv().PosDodgeskill = 0
			end
		end)
	end

	SettingSeaEventSection.CreateToggle({
		Title = "Auto Dodge Skill Seabeast",
		Desc = "Dodge Only Skill Kameha and waterbeam",
		Default = Settings["Auto Dodge Skill Seabeast"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Dodge Skill Seabeast"] and task.wait(0.15) do
					pcall(function()
						if getgenv().PathSeaBeast then
							local pathSeaBeast = getgenv().PathSeaBeast

							spawn(function()
								AddAnimationSeabeastPlayed(pathSeaBeast)
							end)

							while true do
								wait(0.1)
								if not (not pathSeaBeast or not pathSeaBeast.Parent or getgenv().PathSeaBeast ~= pathSeaBeast or not Settings["Auto Dodge Skill Seabeast"]) then
									continue
								end
								break
							end

							if getgenv().PathAnimationSeabit then
								getgenv().PathAnimationSeabit:Disconnect()
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Dodge Skill Seabeast", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Teleport Boat Other CFrame if Rough Sea",
		Desc = nil,
		Default = Settings["Teleport Boat Other CFrame if Rough Sea"] or false,
	}, function(arg)
		SaveSettings("Teleport Boat Other CFrame if Rough Sea", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Tween Until Have Sea Event",
		Desc = "When there's a sea event, it will stop to fight, and after finishing the fight, it will continue tweening",
		Default = Settings["Tween Until Have Sea Event"] or false,
	}, function(arg)
		SaveSettings("Tween Until Have Sea Event", arg)
	end)

	SettingSeaEventSection.CreateToggle({
		Title = "Will Back When over 10km",
		Desc = nil,
		Default = Settings["Will Back When over 10km"] or false,
	}, function(arg)
		SaveSettings("Will Back When over 10km", arg)
	end)

	local function fn9(arg)
		local character = localPlayer and localPlayer.Character
		if not character then
			return
		end

		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = not arg
			end
		end
	end

	setmetatable({}, { __mode = "k" })

	if type(getgenv().BoatSpeed) ~= "table" then
		getgenv().BoatSpeed = { cap = 100, ceiling = math.huge, nextRaise = 0 }
	end

	local function fn10()
		local ok, result = pcall(function()
			return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
		end)

		return ok and result / 1000 or 0.1
	end

	manageTween = function(arg, arg2, arg3, arg4)
		local flag2

		if not arg then
			flag2 = not arg
		else
			flag2 = not arg:IsA("BasePart")
		end

		if flag2 or typeof({}) ~= "CFrame" then
			return
		end
		local v_15 = table.pack(tonumber(Settings["Value Speed Tween Boat"]))
		local num, max

		if v_15[1] then
			num = v_15[1]
			max = math.max
		else
			max = math.max
			num = tonumber(arg3)
		end

		num = num or 350
		local v_16 = table.pack(max(num, 1))
		arg4 = arg4 or "TweenBoat"
		if (arg.Position - nil).Magnitude <= nil then
			return
		end
		local v_17 = getgenv()[arg4]

		if v_17 then
			pcall(function()
				v_17:Cancel()
			end)
		end

		error("devirt: LPH_JIT loop stack set to b'Cancel' (; stack {}) (at 0:7)")
	end

	local function fn11(arg, arg2, arg3)
		if not (arg and arg:FindFirstChild("VehicleSeat")) then
			return
		end
		return manageTween(arg.VehicleSeat, arg2, arg3 or 350, "TweenBoat")
	end

	local function fn12()
		local tweenBoat = getgenv().TweenBoat

		if tweenBoat then
			pcall(function()
				tweenBoat:Cancel()
			end)
		end

		getgenv().TweenBoat = nil
	end

	SpinBoat = function()
		local v_15 = checkboat()

		if getgenv().PathSpinBoat and v_15 and not Settings["Auto Sea Event With Friend"] and game.PlaceId == getgenv().CheckPlaceId and not localPlayer.Character.Humanoid.Sit then
			RoughSeaSpin = Settings["Teleport Boat Other CFrame if Rough Sea"] and roughSea or 0
			local v_16 = CFrameSpinBoat[NumberSpinBoat]
			local n4 = SelectedZoneCFrame() * CFrame.new(0, v_15.WorldPivot.Y, 0 + RoughSeaSpin) * v_16
			local now = tick()
			local v_17 = fn11(v_15, n4, 300)

			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if not (tick() - now >= 3 or not getgenv().PathSpinBoat or not Settings["Auto Sea Event"] or not v_17 or v_17.PlaybackState == Enum.PlaybackState.Completed) then
						continue
					end
				end

				break
			end

			if NumberSpinBoat >= 6 then
				NumberSpinBoat = 1
			else
				NumberSpinBoat = NumberSpinBoat + 1
			end
		end
	end

	NoclipBoat = function(arg)
		for _, descendant in ipairs(arg:GetDescendants()) do
			if (descendant:IsA("BasePart") or descendant:IsA("Part") or descendant:IsA("MeshPart")) and descendant.CanCollide then
				descendant.CanCollide = false
			end
		end
	end

	TurnOffNoclipBoat = function(arg)
		for _, descendant in ipairs(arg:GetDescendants()) do
			if (descendant:IsA("BasePart") or descendant:IsA("Part") or descendant:IsA("MeshPart")) and not descendant.CanCollide then
				descendant.CanCollide = true
			end
		end
	end

	BuyBoatAndTeleBoat = function(arg)
		local v_15 = checkboat()

		if Settings["Auto Sea Event With Friend"] and Settings["Auto Sea Event"] then
			local selectFriend = Settings["Select Friend"]
			toTarget(game:GetService("Players")[selectFriend].Character.HumanoidRootPart.CFrame)
			return
		end

		if not Settings["Auto Sea Event"] and not arg then
			return
		end

		if not v_15 or v_15 and localPlayer:DistanceFromCharacter(v_15.VehicleSeat.Position) >= 4000 then
			local cframe = CFrame.new(-13.488054275512695, 10.311711311340332, 2927.692)

			if game.PlaceId == getgenv().CheckPlaceId then
				cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)
			end

			if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
				if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 and game.PlaceId == getgenv().CheckPlaceId then
					if Settings["Reset Character Buy Boat"] then
						if not localPlayer:GetAttribute("CurrentLocation") or localPlayer:GetAttribute("CurrentLocation") ~= "Tiki Outpost" then
							if game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki" or game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki2" then
								localPlayer.Character.Humanoid.Health = 0
								return
							end
						end
					end
				end

				toTarget(cframe)
			else
				local selectBoat = Settings["Select Boat"]
				if not selectBoat then
					WarnOnce("SelectBoat", "Chon thuyen o Sea Event > Select Boat truoc da.")
					return
				end
				local flag2 = selectBoat == "Brigade"
				local commF = game:GetService("ReplicatedStorage").Remotes.CommF_
				local invokeServer = commF.InvokeServer

				if flag2 or selectBoat == "GrandBrigade" then
					selectBoat = "Pirate" .. selectBoat
				end

				invokeServer(commF, "BuyBoat", selectBoat)
				task.wait(3)
			end
		else
			task.spawn(function()
				NoclipBoat(v_15)
			end)

			if Settings["Tween Until Have Sea Event"] then
				local cframe = CFrame.new(-118834.515625, v_15.WorldPivot.Y, 999920.04941558838)

				if not localPlayer.Character.Humanoid.Sit then
					toTarget(v_15.VehicleSeat.CFrame)
				else
					fn11(v_15, cframe, 350)
				end
			else
				local cframe = CFrame.new(654.3875732421875, v_15.WorldPivot.Y, 6321.95947265625)
				local v_16 = DecectPartRoughSea()

				if v_16 then
					task.wait(1)
					local n4

					if roughSea == 0 then
						n4 = 7000
					else
						n4 = 0
					end

					roughSea = n4
					Instance.new("IntValue", v_16).Name = "Ignored"
					task.wait(0.5)
				end

				getgenv().RoughSea = Settings["Teleport Boat Other CFrame if Rough Sea"] and roughSea or 0

				if game.PlaceId == getgenv().CheckPlaceId then
					cframe = SelectedZoneCFrame() * CFrame.new(0, v_15.WorldPivot.Y, 0 + RoughSea)
				end

				if (v_15.VehicleSeat.Position - cframe.Position).Magnitude > 200 then
					local cframe2 = CFrame.new(cframe.Position.X, v_15.WorldPivot.Y, cframe.Position.Z)

					if not localPlayer.Character.Humanoid.Sit then
						toTarget(v_15.VehicleSeat.CFrame)
					else
						fn11(v_15, cframe2, 350)
					end
				else
					if Settings["Auto Repair Ur Ship"] then
						if localPlayer.PlayerGui.Main.BottomHUDList.ShipHealthBar.Visible then
							local v_17 = string.split(string.gsub(game:GetService("Players").LocalPlayer.PlayerGui.Main.BottomHUDList.ShipHealthBar.TextLabel.Text, "Ship ", ""), "/")

							if tonumber(v_17[1]) < tonumber(v_17[2]) then
								if localPlayer:DistanceFromCharacter(v_15.PrimaryPart.Position) < 20 then
									if not localPlayer.Character.Humanoid.Sit then
										if localPlayer.Character:FindFirstChild("_RepairHammer") then
											if localPlayer.Character._RepairHammer:FindFirstChild("M1UP") then
												localPlayer.Character._RepairHammer.M1UP:Destroy()
											elseif not localPlayer.Character._RepairHammer:GetAttribute("Repairing") then
												localPlayer.Character._RepairHammer.M1Down:FireServer("Default")
												task.wait(0.5)
											end
										else
											game:GetService("ReplicatedStorage").Remotes.SubclassNetwork.UseSubclass:InvokeServer(unpack({ { Action = "RequestHammer" } }))
											task.wait(3)
										end
									else
										toTarget(v_15.PrimaryPart.CFrame * CFrame.new(0, 15, 0))
									end
								else
									toTarget(v_15.PrimaryPart.CFrame * CFrame.new(0, 15, 0))
								end

								return
							end
						end
					end

					if not arg then
						if not localPlayer.Character.Humanoid.Sit then
							toTarget(v_15.VehicleSeat.CFrame)
						end

						local cframe2 = CFrame.new(cframe.Position.X, v_15.WorldPivot.Y, cframe.Position.Z)

						if DetectSeaEvents(true) then
							local now = tick()

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(cframe2 * CFrame.new(0, 2500, 0))
									if not (tick() - now >= 12) then
										continue
									end
								end

								break
							end
						elseif localPlayer.Character.Humanoid.Sit then
							fn11(v_15, cframe2, 350)
						end
					end
				end
			end
		end
	end

	SafeMultiSelect = function(arg)
		local v_15 = Settings[arg]

		if type(v_15) ~= "table" then
			local tbl14 = {}
			Settings[arg] = tbl14
			v_15 = tbl14
		end

		return v_15
	end

	SelectedZoneCFrame = function()
		local selectZone = Settings["Select Zone"]
		return selectZone and tbl12[selectZone] or tbl12["Zone 1"]
	end

	WarnOnce = function(arg, arg2)
		getgenv().__BFWarned = getgenv().__BFWarned or {}
		local v_15 = getgenv().__BFWarned[arg]
		if v_15 and tick() - v_15 < 15 then
			return
		end
		getgenv().__BFWarned[arg] = tick()

		pcall(function()
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = arg2, ShowTime = 5 })
		end)
	end

	DetectSeaEvents = function(arg)
		local v_15 = SafeMultiSelect("Select Sea Events")

		if arg or v_15.SeaBeast then
			local v_16 = next
			local children, v_17 = game:GetService("Workspace").SeaBeasts:GetChildren()

			for _, v_18 in v_16, children, v_17 do
				if v_18.Name == "SeaBeast1" and v_18:FindFirstChild("HumanoidRootPart") and v_18:FindFirstChild("HealthBBG") then
					local text = v_18.HealthBBG.Frame.TextLabel.Text
					local text2 = v_18.HealthBBG.Frame.TextLabel.Text
					local v_19 = tonumber
					local str

					if string.find(text:gsub("/%d+,%d+", ""), ",") then
						str = text2:gsub("%d+,%d+/", "")
					else
						str = text2:gsub("%d+/", "")
					end

					local str2 = str:gsub(",", "")
					if v_19(str2) >= 90000 and localPlayer:DistanceFromCharacter(v_18.HumanoidRootPart.Position) < 2000 then
						return v_18
					end
				end
			end
		end

		if arg or v_15.Terrorshark then
			local Terrorshark = CheckNameBoss("Terrorshark")
			if Terrorshark and localPlayer:DistanceFromCharacter(Terrorshark.HumanoidRootPart.Position) < 2000 then
				return Terrorshark
			end
		end

		if arg or v_15.Ship then
			local v_16 = next
			local children, v_17 = game:GetService("Workspace").Enemies:GetChildren()

			for _, v_18 in v_16, children, v_17 do
				if v_18:FindFirstChild("Engine") and v_18:FindFirstChild("Health") and v_18.Health.Value > 0 and localPlayer:DistanceFromCharacter(v_18.Engine.Position) < 2000 then
					if v_15["Only Farm Ship Brigade"] then
						if table.find(tbl7, v_18.Name) then
							return v_18
						end
						continue
					end

					return v_18
				end
			end
		end

		if arg or v_15.Shark then
			local v_16 = DetectMob(tbl8)
			if v_16 and localPlayer:DistanceFromCharacter(v_16.HumanoidRootPart.Position) < 2000 then
				return v_16
			end
		end

		if arg or v_15.Piranha then
			local Piranha = DetectMob("Piranha")
			if Piranha and localPlayer:DistanceFromCharacter(Piranha.HumanoidRootPart.Position) < 2000 then
				return Piranha
			end
		end

		return false
	end

	UseSkillGun = function()
		local Gun = NameWeapon("Gun", true) or false
		if Gun and not game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(Gun.Name) then
			equiptool(Gun.Name)
			return
		end
		local v_15

		if Gun and CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip]) then
			v_15 = CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip])
		else
			v_15 = nil
		end

		if v_15 then
			local name = v_15.Parent.Name
			equiptool(name)

			if localPlayer.Character:FindFirstChild(name) then
				task.wait(0.2)
				game:GetService("VirtualInputManager"):SendKeyEvent(true, v_15.Name, false, game)

				if Settings["Use skill fast dont hold"] then
					task.wait(0.05)
				else
					task.wait(tonumber(holdskill))
				end

				game:GetService("VirtualInputManager"):SendKeyEvent(false, v_15.Name, false, game)
			end
		end
	end

	AutoUseSkillSeabeast = function()
		local v_15 = SafeMultiSelect("Select Weapons Use Skill")
		local Melee = v_15.Melee and NameWeapon("Melee", true) or false
		local Sword = v_15.Sword and NameWeapon("Sword", true) or false
		local bloxFruit = v_15["Blox Fruit"] and NameWeapon("Blox Fruit", true) or false
		local Gun = v_15.Gun and NameWeapon("Gun", true) or false
		local skills = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills
		if Melee and not skills:FindFirstChild(Melee.Name) then
			equiptool(Melee.Name)
			return
		end

		if Sword and not skills:FindFirstChild(Sword.Name) then
			equiptool(Sword.Name)
			return
		end

		if bloxFruit and not skills:FindFirstChild(bloxFruit.Name) then
			equiptool(bloxFruit.Name)
			return
		end

		if Gun and not skills:FindFirstChild(Gun.Name) then
			equiptool(Gun.Name)
			return
		end
		local v_16

		if Melee and CheckCDSkillTransformation(Melee, Settings["Select Skills " .. Melee.ToolTip]) then
			v_16 = CheckCDSkillTransformation(Melee, Settings["Select Skills " .. Melee.ToolTip])
		elseif Sword and CheckCDSkillTransformation(Sword, Settings["Select Skills " .. Sword.ToolTip]) then
			v_16 = CheckCDSkillTransformation(Sword, Settings["Select Skills " .. Sword.ToolTip])
		elseif Gun and CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip]) then
			v_16 = CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip])
		elseif bloxFruit and CheckCDSkillTransformation(bloxFruit, Settings["Select Skills " .. bloxFruit.ToolTip]) then
			v_16 = CheckCDSkillTransformation(bloxFruit, Settings["Select Skills " .. bloxFruit.ToolTip])
		else
			v_16 = nil
		end

		if v_16 then
			local name = v_16.Parent.Name
			equiptool(name)

			if localPlayer.Character:FindFirstChild(name) then
				game:GetService("VirtualInputManager"):SendKeyEvent(true, v_16.Name, false, game)

				if Settings["Use skill fast dont hold"] then
					task.wait(0.05)
				else
					task.wait(tonumber(holdskill))
				end

				game:GetService("VirtualInputManager"):SendKeyEvent(false, v_16.Name, false, game)
			end
		end
	end

	UseSkillonlyFruit = function()
		local v_15 = NameWeapon("Blox Fruit", true)
		if v_15 and not game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(v_15.Name) then
			equiptool(v_15.Name)
			return
		end
		local v_16

		if v_15 and CheckCDSkillTransformation(v_15, Settings["Select Skills " .. v_15.ToolTip]) then
			v_16 = CheckCDSkillTransformation(v_15, Settings["Select Skills " .. v_15.ToolTip])
		else
			v_16 = nil
		end

		if v_16 then
			local name = v_16.Parent.Name
			equiptool(name)

			if localPlayer.Character:FindFirstChild(name) then
				game:GetService("VirtualInputManager"):SendKeyEvent(true, v_16.Name, false, game)

				if Settings["Use skill fast dont hold"] then
					task.wait(0.05)
				else
					task.wait(tonumber(holdskill))
				end

				game:GetService("VirtualInputManager"):SendKeyEvent(false, v_16.Name, false, game)
			end
		end
	end

	AutoSeabeast = function()
		if not StackFarmOther then
			return
		end
		local flag2 = false

		for k, v_15 in next, SafeMultiSelect("Select Sea Events"), nil do
			v_15 = v_15 and k ~= "Only Farm Ship Brigade"
			if v_15 then
				flag2 = true
				break
			end
		end

		if not flag2 then
			WarnOnce("NoSeaEvent", "Chua chon su kien nao o Sea Event > Select Sea Events.")
			return
		end
		local v_15 = DetectSeaEvents()

		if not v_15 then
			getgenv().PathSeaBeast = false
			getgenv().PathTerrorshark = false
			getgenv().PathSpinBoat = false
			BuyBoatAndTeleBoat()
		else
			fn12()

			if v_15.Name == "Terrorshark" then
				getgenv().PathTerrorshark = v_15
			end

			getgenv().PathSpinBoat = v_15

			while true do
				task.wait()
				TeleportSeaEvents(v_15)

				if v_15:FindFirstChildWhichIsA("Humanoid") then
					if Settings["Use Dragonstorm For Sea Event"] then
						if Settings["Auto Change Dragonstorm With Skull Guitar"] then
							if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Dragonstorm" then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Dragonstorm" }))
							end
						end

						equiptool(NameWeapon("Gun"))
						SpamGunDragonStorm(v_15.HumanoidRootPart)

						if localPlayer:DistanceFromCharacter(v_15.HumanoidRootPart.Position) < 400 then
							UseSkillGun()
						end
					elseif Settings["Use Click M1 Fruit For Sea Event"] then
						equiptool(NameWeapon("Blox Fruit"))
						local v_16 = NameWeapon("Blox Fruit")

						if localPlayer.Character:FindFirstChild(v_16) and localPlayer.Character[v_16]:FindFirstChild("LeftClickRemote") then
							getgenv().UseFruitM1(v_15)
						end
					else
						UsedualFlock()
						ClickM1(v_15, true)
					end
				else
					local humanoidRootPart2 = v_15:FindFirstChild("HumanoidRootPart") or v_15:FindFirstChild("Engine")

					if humanoidRootPart2 then
						if v_15.Name == "SeaBeast1" then
							getgenv().PathSeaBeast = v_15
							getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)
						else
							getgenv().AimPos = CFrame.new(localPlayer.Character.HumanoidRootPart.Position.X, -58, localPlayer.Character.HumanoidRootPart.Position.Z)
						end

						if Settings["Use Dragonstorm For Sea Event"] and v_15.Name ~= "SeaBeast1" then
							if Settings["Auto Change Dragonstorm With Skull Guitar"] then
								if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Dragonstorm" then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Dragonstorm" }))
								end
							end

							equiptool(NameWeapon("Gun"))
							SpamGunDragonStorm(humanoidRootPart2)

							if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
								UseSkillGun()
							end
						elseif Settings["Use Click M1 Skull Guitar For Sea Event"] then
							if Settings["Auto Change Dragonstorm With Skull Guitar"] then
								if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Skull Guitar" then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Skull Guitar" }))
								end
							end

							equiptool(NameWeapon("Gun"))
							SpamGunSkullGuitar(humanoidRootPart2)

							if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
								UseSkillGun()
							end
						elseif Settings["Auto Change Dragonstorm When Kill Boat"] and v_15:FindFirstChild("Health") and v_15.Health.Value > 0 and v_15:FindFirstChild("Engine") then
							if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Dragonstorm" then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Dragonstorm" }))
							end

							equiptool(NameWeapon("Gun"))
							SpamGunDragonStorm(humanoidRootPart2)

							if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
								UseSkillGun()
							end
						elseif Settings["Use Click M1 Fruit For Sea Event"] then
							equiptool(NameWeapon("Blox Fruit"))
							local v_16 = NameWeapon("Blox Fruit")

							if localPlayer.Character:FindFirstChild(v_16) and localPlayer.Character[v_16]:FindFirstChild("LeftClickRemote") then
								if v_15.Name == "SeaBeast1" then
									getgenv().UseFruitM1(v_15)
								else
									local cFrame2 = humanoidRootPart2.CFrame
									getgenv().UseFruitM1Boat(cFrame2 * CFrame.new(0, -35, 0))
								end
							end
						elseif localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
							AutoUseSkillSeabeast()
						end
					end
				end

				if not (not v_15 or not v_15.Parent or not Settings["Auto Sea Event"] or v_15:FindFirstChild("Health") and v_15.Health.Value == 0 or v_15:FindFirstChildWhichIsA("Humanoid") and v_15.Humanoid.Health == 0 or not StackFarmOther) then
					continue
				end
				break
			end
		end
	end

	FarmingSeaEventSection = SeaEventTab.CreateSection("Farming")

	local v_15 = FarmingSeaEventSection.CreateDropdown({
		Title = "Select Friend",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Friend"] or nil,
	}, function(arg)
		SaveSettings("Select Friend", arg)
	end)

	FarmingSeaEventSection.CreateButton({ Title = "Refresh Player" }, function()
		v_15:GetNewList(DetectNamePlayer())
	end)

	FarmingSeaEventSection.CreateToggle({
		Title = "Auto Sea Event With Friend",
		Desc = nil,
		Default = Settings["Auto Sea Event With Friend"] or false,
	}, function(arg)
		SaveSettings("Auto Sea Event With Friend", arg)
	end)

	local n4 = 0
	local n5 = 0
	local flag2 = false

	task.spawn(function()
		local localPlayer2 = game:GetService("Players").LocalPlayer

		if localPlayer2 then
			localPlayer2 = localPlayer2:FindFirstChild("PlayerGui") or localPlayer2:WaitForChild("PlayerGui", 30)
		end

		if not localPlayer2 then
			return
		end
		local main = localPlayer2:FindFirstChild("Main") or localPlayer2:WaitForChild("Main", 30)
		if not main then
			return
		end
		local dmgCounter = main:FindFirstChild("DmgCounter") or main:WaitForChild("DmgCounter", 30)
		if not dmgCounter then
			return
		end
		local text = dmgCounter:FindFirstChild("Text") or dmgCounter:WaitForChild("Text", 30)
		if not text then
			return
		end

		text:GetPropertyChangedSignal("Text"):Connect(function()
			local num = tonumber(text.Text)

			if not num or num == 0 then
				n4 = 0
				n5 = 0
				flag2 = false
			else
				flag2 = true
				n4 = num - n5
			end
		end)
	end)

	FarmingSeaEventSection.CreateToggle({
		Title = "Auto Repair Ur Ship",
		Desc = nil,
		Default = Settings["Auto Repair Ur Ship"] or false,
	}, function(arg)
		SaveSettings("Auto Repair Ur Ship", arg)
	end)

	FarmingSeaEventSection.CreateToggle({ Title = "Auto Sea Event", Desc = nil, Default = Settings["Auto Sea Event"] or false }, function(arg)
		if arg then
			getgenv().StopBoatSeaEvent = true

			spawn(function()
				while Settings["Auto Sea Event"] and task.wait() do
					local ok, result = pcall(function()
						AutoSeabeast()
					end)

					if not ok and result then
						print(result)
					end
				end
			end)
		elseif getgenv().StopBoatSeaEvent then
			fn12()
			getgenv().StopBoatSeaEvent = false
		end

		SaveSettings("Auto Sea Event", arg)
	end)

	DangerDistanceMod = nil

	if game.PlaceId == getgenv().CheckPlaceId then
		pcall(function()
			DangerDistanceMod = v_2(game:GetService("ReplicatedStorage").DangerDistance)
		end)
	end

	DistanceFindLeviathan = function()
		local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not DangerDistanceMod or not humanoidRootPart2 then
			return 0
		end
		local nearestNPC = DangerDistanceMod:GetNearestNPC(humanoidRootPart2.Position, 2600)
		nearestNPC = nearestNPC and nearestNPC[1]
		if not nearestNPC then
			return 0
		end
		return math.floor((DangerDistanceMod:GetDistance(nearestNPC) - humanoidRootPart2.Position).magnitude / 10)
	end

	ToggleFindMirage = FarmingSeaEventSection.CreateToggle({ Title = "Auto Find Mirage", Desc = nil, Default = Settings["Auto Find Mirage"] or false }, function(arg)
		spawn(function()
			while Settings["Auto Find Mirage"] and wait(0.1) do
				pcall(function()
					if not game:GetService("Workspace").Map:FindFirstChild("MysticIsland") then
						getgenv().RespawnMirage = true
						local v_16 = checkboat()

						if not v_16 or v_16 and localPlayer:DistanceFromCharacter(v_16.VehicleSeat.Position) >= 4000 then
							local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

							if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
								if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
									if game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki" then
										localPlayer.Character.Humanoid.Health = 0
										return
									end
								end

								toTarget(cframe)
							else
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
								wait(3)
							end
						elseif localPlayer.Character.Humanoid.Sit then
							local n6 = CFrame.new(-118834.515625, 160, -78.950584411621094) * CFrame.new(0, 0, 99999999)
							local cframe = CFrame.new(-32975.9921875, 160, 25963.7109375)
							local flag3

							if Settings["Will Back When over 10km"] then
								if DistanceFindLeviathan() >= 12000 then
									flag3 = true
								elseif DistanceFindLeviathan() <= 4800 then
									flag3 = false
								else
									flag3 = false
								end
							else
								flag3 = false
							end

							while true do
								task.wait(0.5)

								if getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8 then
									break
								else
									NoclipBoat(v_16)
									local v_17

									if Settings["Will Back When over 10km"] then
										if DistanceFindLeviathan() >= 10000 then
											flag3 = true
										elseif DistanceFindLeviathan() <= 4800 then
											flag3 = false
										end

										if flag3 then
											manageTween(v_16.VehicleSeat, cframe, 350, "TweenBoatBack")
											v_17 = flag3
										else
											v_17 = flag3
										end
									else
										v_17 = flag3
									end

									if not v_17 or not Settings["Will Back When over 10km"] then
										manageTween(v_16.VehicleSeat, n6, 350, "TweenBoat")
									end

									if not (not Settings["Auto Find Mirage"] or not localPlayer.Character.Humanoid.Sit or game:GetService("Workspace").Map:FindFirstChild("MysticIsland")) then
										flag3 = v_17
										continue
									end
								end

								break
							end

							if getgenv().TweenBoat then
								getgenv().TweenBoat:Pause()
								getgenv().TweenBoat:Cancel()
							end

							if getgenv().TweenBoatBack then
								getgenv().TweenBoatBack:Pause()
								getgenv().TweenBoatBack:Cancel()
							end
						else
							if getgenv().TweenBoat then
								getgenv().TweenBoat:Pause()
								getgenv().TweenBoat:Cancel()
							end

							if getgenv().TweenBoatBack then
								getgenv().TweenBoatBack:Pause()
								getgenv().TweenBoatBack:Cancel()
							end

							toTarget(v_16.VehicleSeat.CFrame)
						end
					else
						if getgenv().RespawnMirage and Settings["Webhook Find Mirage"] then
							getgenv().RespawnMirage = false

							if WebhookFindMirage then
								WebhookFindMirage()
							end
						end

						if getgenv().TweenBoat then
							getgenv().TweenBoat:Pause()
							getgenv().TweenBoat:Cancel()
						end

						lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Mirage Island Spawned", ShowTime = 5 })
						ToggleFindMirage:SetStage(false)
						wait(5)
					end
				end)
			end
		end)

		SaveSettings("Auto Find Mirage", arg)
	end)

	KitsuneEventSection = SeaEventTab.CreateSection("Kitsune Event")

	KitsuneEventSection.CreateToggle({
		Title = "Teleport To Kitsune Island",
		Desc = nil,
		Default = Settings["Teleport To Kitsune Island"] or false,
	}, function(arg)
		SaveSettings("Teleport To Kitsune Island", arg)
	end)

	KitsuneEventSection.CreateToggle({
		Title = "Hop Server [ Next Night or Near Full Moon > 2m ]",
		Desc = nil,
		Default = Settings["Hop Server Kitsune Island"] or false,
	}, function(arg)
		SaveSettings("Hop Server Kitsune Island", arg)
	end)

	KitsuneEventSection.CreateToggle({
		Title = "Auto Spawn Kitsune Island",
		Desc = nil,
		Default = Settings["Auto Spawn Kitsune Island"] or false,
	}, function(arg)
		if arg then
			lib.CreateNoti({
				Title = "Banana Cat Hub",
				Desc = "Turn On after Status Full Moon|( Will Full Moon In >= 0 Minutes )",
				ShowTime = 5,
			})
		end

		SaveSettings("Auto Spawn Kitsune Island", arg)
	end)

	KitsuneEventSection.CreateToggle({
		Title = "Auto Summon Soul Ember",
		Desc = nil,
		Default = Settings["Auto Summon Soul Ember"] or false,
	}, function(arg)
		SaveSettings("Auto Summon Soul Ember", arg)
	end)

	KitsuneEventSection.CreateToggle({
		Title = "Auto Collect Soul Ember",
		Desc = nil,
		Default = Settings["Auto Collect Soul Ember"] or false,
	}, function(arg)
		SaveSettings("Auto Collect Soul Ember", arg)
	end)

	KitsuneEventSection.CreateSlider({
		Title = "Values Azure Ember",
		Min = 0,
		Max = 25,
		Default = Settings["Values Azure Ember"] or 10,
		Precise = true,
	}, function(arg)
		SaveSettings("Values Azure Ember", arg)
	end)

	KitsuneEventSection.CreateToggle({
		Title = "Auto Trade Azure Ember",
		Desc = nil,
		Default = Settings["Auto Trade Azure Ember"] or false,
	}, function(arg)
		SaveSettings("Auto Trade Azure Ember", arg)
	end)

	DetectIslandKitsune = function()
		if game.workspace.Map:FindFirstChild("KitsuneIsland") and workspace.Map.KitsuneIsland.ShrineDialogPart.ProximityPrompt.Enabled then
			return true
		end
	end

	AutoSpawnKitsune = function()
		local clockTime = game.Lighting.ClockTime
		local v_16 = checkboat()

		if Settings["Hop Server Kitsune Island"] then
			local v_17 = CheckMoon()
			if not (v_17 == "Full Moon" and math.floor(18 - clockTime) <= 5 and math.floor(18 - clockTime) >= 0 or v_17 == "Next Night" or v_17 == "Full Moon" and clockTime <= 5 and math.floor(5 - clockTime) >= 11) then
				HopServer()
				return
			end
		end

		if not v_16 then
			local cframe = CFrame.new(-13.488054275512695, 10.311711311340332, 2927.692)

			if game.PlaceId == getgenv().CheckPlaceId then
				cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)
			end

			if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
				toTarget(cframe)
			else
				local selectBoat = Settings["Select Boat"]
				if not selectBoat then
					WarnOnce("SelectBoat", "Chon thuyen o Sea Event > Select Boat truoc da.")
					return
				end
				local flag3 = selectBoat == "Brigade"
				local commF = game:GetService("ReplicatedStorage").Remotes.CommF_
				local invokeServer = commF.InvokeServer

				if flag3 or selectBoat == "GrandBrigade" then
					selectBoat = "Pirate" .. selectBoat
				end

				invokeServer(commF, "BuyBoat", selectBoat)
				task.wait(3)
			end

			return
		end

		NoclipBoat(v_16)
		local n6 = CFrame.new(-32975.9921875, v_16.WorldPivot.Y, 25963.7109375) * CFrame.new(0, 0, 1000)

		if CheckMoon() == "Full Moon" and math.floor(18 - clockTime) <= 0 then
			if (v_16.VehicleSeat.Position - n6.Position).Magnitude > 200 then
				if not localPlayer.Character.Humanoid.Sit then
					toTarget(v_16.VehicleSeat.CFrame)
				else
					manageTween(v_16.VehicleSeat, n6, 350, "TweenBoat")
				end
			elseif not localPlayer.Character.Humanoid.Sit then
				toTarget(v_16.VehicleSeat.CFrame)
			end
		else
			if (v_16.VehicleSeat.Position - n6.Position).Magnitude > 200 then
				manageTween(v_16.VehicleSeat, n6, 350, "TweenBoat")
			end

			toTarget(n6 * CFrame.new(0, 2000, 0))
		end
	end

	DetectSoulEmber = function()
		local v_16 = next
		local children, v_17 = game.Workspace:GetChildren()

		for _, v_18 in v_16, children, v_17 do
			if v_18.Name == "EmberTemplate" and v_18:FindFirstChild("Part") then
				return v_18
			end
		end
	end

	CollectSoulEmber = function()
		local v_16 = DetectSoulEmber()

		if v_16 then
			if localPlayer:DistanceFromCharacter(v_16.Part.Position) > 100 then
				toTarget(v_16.Part.CFrame)
			else
				localPlayer.Character.HumanoidRootPart.CFrame = v_16.Part.CFrame
			end
		else
			toTarget(game.workspace._WorldOrigin.Locations["Kitsune Island"].CFrame)
		end
	end

	AutoSummonAzureEmber = function()
		if not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and DetectIslandKitsune() then
			if localPlayer:DistanceFromCharacter(game.Workspace.Map.KitsuneIsland.ShrineInactive.WorldPivot.Position) >= 10 then
				toTarget(game.Workspace.Map.KitsuneIsland.ShrineInactive.WorldPivot)
			else
				pcall(function()
					local net = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") and game.ReplicatedStorage.Modules:FindFirstChild("Net")
					net = net and net:FindFirstChild("RE/TouchKitsuneStatue")

					if net then
						net:FireServer()
					end
				end)

				wait(5)
			end
		end
	end

	TradeAzureEmber = function()
		if CheckCountItem("Azure Ember", tonumber(Settings["Values Azure Ember"])) and game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
			pcall(function()
				local net = game:GetService("ReplicatedStorage"):FindFirstChild("Modules") and game.ReplicatedStorage.Modules:FindFirstChild("Net")
				net = net and net:FindFirstChild("RF/KitsuneStatuePray")

				if net then
					net:InvokeServer()
				end
			end)

			wait(5)
		end
	end

	spawn(function()
		while true do
			wait(0.15)

			if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
				if not (Settings["Teleport To Kitsune Island"] or Settings["Auto Spawn Kitsune Island"] or Settings["Auto Collect Soul Ember"] or Settings["Auto Trade Azure Ember"]) then
					continue
				end
			end

			break
		end

		while task.wait(0.1) do
			pcall(function()
				if Settings["Teleport To Kitsune Island"] then
					if game.workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
						toTarget(game.workspace._WorldOrigin.Locations["Kitsune Island"].CFrame)
					end
				end

				if Settings["Auto Spawn Kitsune Island"] then
					pcall(function()
						if not DetectIslandKitsune() then
							AutoSpawnKitsune()
						end
					end)
				end

				if Settings["Auto Collect Soul Ember"] then
					if game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
						CollectSoulEmber()
					end
				end

				if Settings["Auto Summon Soul Ember"] then
					AutoSummonAzureEmber()
				end

				if Settings["Auto Trade Azure Ember"] then
					TradeAzureEmber()
				end
			end)
		end
	end)

	LeviathanEventSection = SeaEventTab.CreateSection("Leviathan Event")

	LeviathanEventSection.CreateButton({ Title = "Buy Spy" }, function()
		local spy = v_2(game.ReplicatedStorage.DialoguesList).Spy
		v_2(game.ReplicatedStorage.DialogueController):Start(spy)
	end)

	LeviathanEventSection.CreateButton({ Title = "Teleport your boat to current Position" }, function()
		local cFrame2 = localPlayer.Character.HumanoidRootPart.CFrame
		checkboat().VehicleSeat.CFrame = cFrame2
	end)

	LeviathanEventSection.CreateToggle({ Title = "Auto Buy Spy", Desc = nil, Default = Settings["Auto Buy Spy"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Buy Spy"] and task.wait(5) do
					pcall(function()
						if StatusCheckLeviathan() == "Buy Find leviathan" then
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("InfoLeviathan", "1")
							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Buy Spy", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Auto Buy Boat Beast Hunter",
		Desc = nil,
		Default = Settings["Auto Buy Boat Beast Hunter"] or false,
	}, function(arg)
		SaveSettings("Auto Buy Boat Beast Hunter", arg)
	end)

	checkboatFind = function()
		local v_16 = next
		local children, v_17 = game:GetService("Workspace").Boats:GetChildren()

		for _, v_18 in v_16, children, v_17 do
			if v_18:IsA("Model") then
				if v_18:FindFirstChild("Owner") and localPlayer:DistanceFromCharacter(v_18.VehicleSeat.Position) < 10 and localPlayer.Character.Humanoid.SeatPart and localPlayer.Character.Humanoid.SeatPart.Name == "VehicleSeat" and v_18.Humanoid.Value > 0 then
					return v_18
				end
			end
		end
	end

	tbl10 = {}
	tbl2 = next
	local v_16
	tbl, v_16 = game:GetService("ReplicatedStorage").RockGenerator.Rocks:GetChildren()

	for _, v_17 in tbl2, tbl, v_16 do
		table.insert(tbl10, v_17.Name)
	end

	DetectRockNear = function(arg)
		local position = arg.VehicleSeat.Position
		local attribute = arg:GetAttribute("Size")
		local v_17 = workspace:FindPartsInRegion3(Region3.new(position - attribute / 2, position + attribute / 2), nil, math.huge)

		if #v_17 > 0 then
			local v_18, v_19, v_20 = pairs(v_17)
			local v_21 = table.pack(i_1())
			if v_21[1] then
				return true
			end
		end
	end

	local function fn13(arg, arg2)
		return arg2 - arg
	end

	DetectSeaEventDodge = function(arg)
		if arg then
			local v_17 = next
			local children, v_18 = game:GetService("Workspace").SeaBeasts:GetChildren()

			for _, v_19 in v_17, children, v_18 do
				if v_19.Name == "SeaBeast1" and v_19:FindFirstChild("HumanoidRootPart") and v_19:FindFirstChild("HealthBBG") then
					local text = v_19.HealthBBG.Frame.TextLabel.Text
					local text2 = v_19.HealthBBG.Frame.TextLabel.Text
					local v_20 = tonumber
					local str

					if string.find(text:gsub("/%d+,%d+", ""), ",") then
						str = text2:gsub("%d+,%d+/", "")
					else
						str = text2:gsub("%d+/", "")
					end

					local str2 = str:gsub(",", "")
					if v_20(str2) >= 90000 and localPlayer:DistanceFromCharacter(v_19.HumanoidRootPart.Position) < 2000 then
						return v_19
					end
				end
			end
		end

		if arg then
			local Terrorshark = CheckNameBoss("Terrorshark")
			if Terrorshark and localPlayer:DistanceFromCharacter(Terrorshark.HumanoidRootPart.Position) < 2000 then
				return Terrorshark
			end
		end

		if arg then
			local v_17 = next
			local children, v_18 = game:GetService("Workspace").Enemies:GetChildren()

			for _, v_19 in v_17, children, v_18 do
				if v_19:FindFirstChild("Engine") and v_19:FindFirstChild("Health") and v_19.Health.Value > 0 and localPlayer:DistanceFromCharacter(v_19.Engine.Position) < 2000 then
					return v_19
				end
			end
		end

		return false
	end

	AutoFindLeviathan = function()
		if Settings["Auto Destroy IDK"] and getgenv().DesIdk then
			getgenv().DesIdk2 = true
			return
		end

		if Settings["Auto Destroy IDK"] and getgenv().DesIdk2 then
			toTarget(getgenv().OldBoat.VehicleSeat.CFrame)

			if localPlayer.Character.Humanoid.Sit then
				getgenv().DesIdk2 = false
			end

			return
		end

		local v_17 = checkboatFind()

		if not game.workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
			getgenv().RespawnLeviathan = true
			local v_18 = checkboat()

			if not v_18 and Settings["Auto Buy Boat Beast Hunter"] then
				local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

				if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
					if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
						if game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki" then
							localPlayer.Character.Humanoid.Health = 0
							return
						end
					end

					toTarget(cframe)
				else
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "Beast Hunter")
					wait(3)
				end
			elseif v_17 then
				getgenv().noclip = false
				local n6 = CFrame.new(-118834.515625, 160, -78.950584411621094) * CFrame.new(0, 0, 99999999)
				local cframe = CFrame.new(-32975.9921875, 160, 25963.7109375)
				local flag3

				if Settings["Will Back When over 10km"] then
					if DistanceFindLeviathan() >= 12000 then
						flag3 = true
					elseif DistanceFindLeviathan() <= 4800 then
						flag3 = false
					else
						flag3 = false
					end
				else
					flag3 = false
				end

				local y = v_17.VehicleSeat.Position.Y
				local maxForce = v_17.VehicleSeat.BodyVelocity.MaxForce
				wait(0.5)
				v_17.VehicleSeat.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				local v_19 = fn13(v_17.VehicleSeat.Position.Y, 1000)
				local flag4

				if not localPlayer.PlayerGui.Main.Compass.Frame.DangerLevel.Visible then
					wait(0.2)
					v_17.VehicleSeat.CFrame = v_17.VehicleSeat.CFrame * CFrame.new(0, v_19, 0)
					wait(1)
					flag4 = true
				else
					wait(0.2)
					v_17.VehicleSeat.CFrame = v_17.VehicleSeat.CFrame * CFrame.new(0, fn13(v_17.VehicleSeat.Position.Y, 160), 0)
					wait(1)
					flag4 = false
				end

				local flag5 = false

				while true do
					task.wait(0.5)

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						NoclipBoat(v_17)

						if localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("Humanoid") then
							local v_20 = next
							local descendants, v_21 = localPlayer.Character:GetDescendants()

							for _, v_22 in v_20, descendants, v_21 do
								if (v_22:IsA("MeshPart") or v_22:IsA("Part")) and v_22.CanCollide then
									v_22.CanCollide = false
								end
							end
						end

						if flag4 and (localPlayer.PlayerGui.Main.Compass.Frame.DangerLevel.Visible and localPlayer.PlayerGui.Main.Compass.Frame.DangerText.Visible and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.Main.Compass.Frame.DangerLevel.TextLabel.Text) >= 1 or tbl8(localPlayer.Character.HumanoidRootPart.CFrame) >= 4000) then
							getgenv().TweenBoat:Pause()
							getgenv().TweenBoat:Cancel()
							wait(0.5)
							v_17.VehicleSeat.CFrame = v_17.VehicleSeat.CFrame * CFrame.new(0, fn13(v_17.VehicleSeat.Position.Y, 160), 0)
							wait(0.5)
							flag4 = false
						end

						if not flag4 and v_17.VehicleSeat.Position.Y < 150 then
							if getgenv().TweenBoat then
								getgenv().TweenBoat:Pause()
								getgenv().TweenBoat:Cancel()
							end

							if getgenv().TweenBoatBack then
								getgenv().TweenBoatBack:Pause()
								getgenv().TweenBoatBack:Cancel()
							end

							wait(0.5)
							v_17.VehicleSeat.CFrame = v_17.VehicleSeat.CFrame * CFrame.new(0, fn13(v_17.VehicleSeat.Position.Y, 160), 0)
						end

						if not flag5 and DetectSeaEventDodge(true) and v_17.VehicleSeat.Position.Y < 500 then
							n6 = CFrame.new(-118834.515625, 500, -78.950584411621094) * CFrame.new(0, 0, 99999999)
							cframe = CFrame.new(-32975.9921875, 500, 25963.7109375)

							if getgenv().TweenBoat then
								getgenv().TweenBoat:Pause()
								getgenv().TweenBoat:Cancel()
							end

							if getgenv().TweenBoatBack then
								getgenv().TweenBoatBack:Pause()
								getgenv().TweenBoatBack:Cancel()
							end

							wait(0.5)
							v_17.VehicleSeat.CFrame = v_17.VehicleSeat.CFrame * CFrame.new(0, fn13(v_17.VehicleSeat.Position.Y, 500), 0)
							wait(0.5)
							flag5 = true
						elseif flag5 and not DetectSeaEventDodge(true) then
							n6 = CFrame.new(-118834.515625, 160, -78.950584411621094) * CFrame.new(0, 0, 99999999)
							cframe = CFrame.new(-32975.9921875, 160, 25963.7109375)

							if getgenv().TweenBoat then
								getgenv().TweenBoat:Pause()
								getgenv().TweenBoat:Cancel()
							end

							if getgenv().TweenBoatBack then
								getgenv().TweenBoatBack:Pause()
								getgenv().TweenBoatBack:Cancel()
							end

							wait(0.5)
							v_17.VehicleSeat.CFrame = v_17.VehicleSeat.CFrame * CFrame.new(0, fn13(v_17.VehicleSeat.Position.Y, 160), 0)
							wait(0.5)
							flag5 = false
						end

						if Settings["Will Back When over 10km"] then
							if DistanceFindLeviathan() >= 10000 then
								flag3 = true
							elseif DistanceFindLeviathan() <= 4800 then
								flag3 = false
							end

							if flag3 then
								manageTween(v_17.VehicleSeat, cframe, 350, "TweenBoatBack")
							end
						end

						if not flag3 or not Settings["Will Back When over 10km"] then
							manageTween(v_17.VehicleSeat, n6, 350, "TweenBoat")
						end

						local frozenDimension = not Settings["Auto Find Leviathan"] or not localPlayer.Character.Humanoid.Sit or game.workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension")
						local desIdk

						if frozenDimension then
							desIdk = frozenDimension
						else
							desIdk = Settings["Auto Destroy IDK"] and getgenv().DesIdk
						end

						if not desIdk then
							continue
						end
					end

					break
				end

				v_17.VehicleSeat.BodyVelocity.MaxForce = maxForce
				getgenv().OldBoat = v_17

				if getgenv().TweenBoat then
					getgenv().TweenBoat:Pause()
					getgenv().TweenBoat:Cancel()
				end

				if getgenv().TweenBoatBack then
					getgenv().TweenBoatBack:Pause()
					getgenv().TweenBoatBack:Cancel()
				end

				v_17.VehicleSeat.CFrame = CFrame.new(v_17.VehicleSeat.Position.X, y, v_17.VehicleSeat.Position.Z)
			elseif v_18 and Settings["Auto Buy Boat Beast Hunter"] then
				if not localPlayer.Character.Humanoid.Sit then
					toTarget(v_18.VehicleSeat.CFrame)
				end
			end
		else
			if getgenv().TweenBoat then
				getgenv().TweenBoat:Pause()
				getgenv().TweenBoat:Cancel()
			end

			if getgenv().TweenBoatBack then
				getgenv().TweenBoatBack:Pause()
				getgenv().TweenBoatBack:Cancel()
			end

			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Frozen Dimension Spawned", ShowTime = 5 })

			if getgenv().RespawnLeviathan and Settings["Webhook Find Leviathan"] then
				getgenv().RespawnLeviathan = false

				if WebhookFindLeviathan then
					WebhookFindLeviathan()
				end
			end

			wait(5)
		end
	end

	DestroyIDK = function()
		if StatusCheckLeviathan() == "I DONT KNOW" then
			getgenv().WebhookIDK = true
			local v_17 = DetectSeaEvents(true)

			if not v_17 then
				getgenv().PathSeaBeast = false
				getgenv().PathTerrorshark = false
				getgenv().PathSpinBoat = false
			else
				getgenv().DesIdk = true

				if getgenv().TweenBoat then
					getgenv().TweenBoat:Pause()
					getgenv().TweenBoat:Cancel()
				end

				if v_17.Name == "Terrorshark" then
					getgenv().PathTerrorshark = v_17
				end

				getgenv().PathSpinBoat = v_17

				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						spawn(function()
							TeleportSeaEvents(v_17)
						end)

						if v_17:FindFirstChildWhichIsA("Humanoid") then
							if Settings["Use Dragonstorm For Sea Event"] then
								if Settings["Auto Change Dragonstorm With Skull Guitar"] then
									if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Dragonstorm" then
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Dragonstorm" }))
									end
								end

								equiptool(NameWeapon("Gun"))
								SpamGunDragonStorm(v_17.HumanoidRootPart)

								if localPlayer:DistanceFromCharacter(v_17.HumanoidRootPart.Position) < 400 then
									UseSkillGun()
								end
							elseif Settings["Use Click M1 Fruit For Sea Event"] then
								equiptool(NameWeapon("Blox Fruit"))
								local v_18 = NameWeapon("Blox Fruit")

								if localPlayer.Character:FindFirstChild(v_18) and localPlayer.Character[v_18]:FindFirstChild("LeftClickRemote") then
									getgenv().UseFruitM1(v_17)
								end
							else
								UsedualFlock()
								ClickM1(v_17, true)
							end
						else
							local humanoidRootPart2 = v_17:FindFirstChild("HumanoidRootPart") or v_17:FindFirstChild("Engine")

							if v_17.Name == "SeaBeast1" then
								getgenv().PathSeaBeast = v_17
								getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)
							else
								getgenv().AimPos = CFrame.new(localPlayer.Character.HumanoidRootPart.Position.X, -58, localPlayer.Character.HumanoidRootPart.Position.Z)
							end

							if Settings["Use Dragonstorm For Sea Event"] and v_17.Name ~= "SeaBeast1" then
								if Settings["Auto Change Dragonstorm With Skull Guitar"] then
									if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Dragonstorm" then
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Dragonstorm" }))
									end
								end

								equiptool(NameWeapon("Gun"))
								SpamGunDragonStorm(humanoidRootPart2)

								if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
									UseSkillGun()
								end
							elseif Settings["Use Click M1 Skull Guitar For Sea Event"] then
								if Settings["Auto Change Dragonstorm With Skull Guitar"] then
									if not NameWeapon("Gun") or NameWeapon("Gun") ~= "Skull Guitar" then
										game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "LoadItem", "Skull Guitar" }))
									end
								end

								equiptool(NameWeapon("Gun"))
								SpamGunSkullGuitar(humanoidRootPart2)

								if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
									UseSkillGun()
								end
							elseif Settings["Use Click M1 Fruit For Sea Event"] then
								equiptool(NameWeapon("Blox Fruit"))
								local v_18 = NameWeapon("Blox Fruit")

								if localPlayer.Character:FindFirstChild(v_18) and localPlayer.Character[v_18]:FindFirstChild("LeftClickRemote") then
									if v_17.Name == "SeaBeast1" then
										getgenv().UseFruitM1(v_17)
									else
										local cFrame2 = humanoidRootPart2.CFrame
										getgenv().UseFruitM1Boat(cFrame2 * CFrame.new(0, -35, 0))
									end
								end
							elseif localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
								AutoUseSkillSeabeast()
							end
						end

						if not (not v_17 or not v_17.Parent or not Settings["Auto Destroy IDK"] or v_17:FindFirstChild("Health") and v_17.Health.Value == 0 or v_17:FindFirstChildWhichIsA("Humanoid") and v_17.Humanoid.Health == 0) then
							continue
						end
					end

					break
				end

				getgenv().DesIdk = false
			end
		elseif getgenv().WebhookIDK and Settings["Webhook Destroy IDK"] then
			local webhookDestroyIdk = getgenv().WebhookDestroyIdk or WebhookDestroyIdk

			if webhookDestroyIdk then
				webhookDestroyIdk()
			end

			getgenv().WebhookIDK = false
		end

		getgenv().DesIdk = false
	end

	getgenv().SpeedTeleportTiki = 70

	local v_17 = LeviathanEventSection.CreateDropdown({
		Title = "Select Owner Boat Find Leviathan",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Owner Boat Find Leviathan"] or nil,
	}, function(arg)
		SaveSettings("Select Owner Boat Find Leviathan", arg)
	end)

	LeviathanEventSection.CreateButton({ Title = "Refresh Player" }, function()
		v_17:GetNewList(DetectNamePlayer())
	end)

	checkboatMulti = function()
		local selectOwnerBoatFindLeviathan = Settings["Select Owner Boat Find Leviathan"]
		local v_18 = next
		local children, v_19 = game:GetService("Workspace").Boats:GetChildren()
		local v_20 = nil

		for _, v_21 in v_18, children, v_19 do
			if v_21:IsA("Model") then
				if v_21:FindFirstChild("Owner") and tostring(v_21.Owner.Value) == selectOwnerBoatFindLeviathan and v_21.Humanoid.Value > 0 then
					v_20 = v_21
				end
			end
		end

		if v_20 then
			local v_21 = next
			local children2, v_22 = v_20:GetChildren()

			for _, v_23 in v_21, children2, v_22 do
				if v_23.Name == "Cannon" and not v_23.Seat:FindFirstChild("SeatWeld") then
					return v_23
				end
			end
		end

		return false
	end

	LeviathanEventSection.CreateToggle({
		Title = "Multi Find Leviathan",
		Desc = nil,
		Default = Settings["Multi Find Leviathan"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Multi Find Leviathan"] and task.wait(0.1) do
					pcall(function()
						if Settings["Auto Destroy IDK"] and getgenv().DesIdk then
							return
						end
						local v_18 = checkboatMulti()

						if v_18 and not localPlayer.Character.Humanoid.Sit then
							toTarget(v_18.Seat.CFrame)
						elseif localPlayer.Character.Humanoid.Sit and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FloatForce") then
							TweenManager.CancelCurrent()
						end
					end)
				end
			end)
		end

		SaveSettings("Multi Find Leviathan", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Auto Find Leviathan",
		Desc = nil,
		Default = Settings["Auto Find Leviathan"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Find Leviathan"] and task.wait() do
					local ok, result = pcall(function()
						AutoFindLeviathan()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Find Leviathan", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Auto Start Leviathan",
		Desc = nil,
		Default = Settings["Auto Start Leviathan"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Start Leviathan"] and task.wait(2.5) do
					local ok, result = pcall(function()
						if game.workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
							local v_18 = nil

							for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
								if child.Name == "Frozen Watcher" then
									v_18 = child
								end
							end

							for _, child in pairs(game:GetService("ReplicatedStorage").NPCs:GetChildren()) do
								if child.Name == "Frozen Watcher" then
									v_18 = child
								end
							end

							if v_18 and localPlayer:DistanceFromCharacter(v_18.HumanoidRootPart.Position) < 8 then
								game.ReplicatedStorage.Remotes.CommF_:InvokeServer("OpenLeviathanGate")
							else
								toTarget(v_18.HumanoidRootPart.CFrame)
							end
						end
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Start Leviathan", arg)
	end)

	LeviathanEventSection.CreateToggle({ Title = "Auto Destroy IDK", Desc = nil, Default = Settings["Auto Destroy IDK"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Destroy IDK"] and task.wait(0.1) do
					local ok, result = pcall(function()
						DestroyIDK()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Destroy IDK", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Attack Multi Segments Leviathan",
		Desc = "Please enable the damage counter so I can calculate the damage dealt to that segment.\nplz Turn on multi Segments first.",
		Default = Settings["Attack Multi Segments Leviathan"] or false,
	}, function(arg)
		if arg and not Settings["Auto Attack Leviathan"] then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Auto Attack Leviathan, plz", ShowTime = 5 })
		end

		SaveSettings("Attack Multi Segments Leviathan", arg)
	end)

	LeviathanEventSection.CreateSlider({
		Title = "Value Damage Multi Segments",
		Min = 0,
		Max = 1000000,
		Default = Settings["Value Damage Multi Segments"] or 30000,
		Precise = true,
	}, function(arg)
		SaveSettings("Value Damage Multi Segments", arg)
	end)

	DetectLeviathan = function(arg, arg2)
		local v_18 = next
		local children, v_19 = arg:GetChildren()

		for _, v_20 in v_18, children, v_19 do
			if v_20.Name == "Leviathan Tail" and v_20:GetAttribute("HealthEnabled") and v_20.Health.Value > 0 then
				return v_20
			end
		end

		local v_20 = next
		local children2, v_21 = arg:GetChildren()

		for _, v_22 in v_20, children2, v_21 do
			if v_22.Name == "Leviathan" and not v_22:GetAttribute("Armored") and v_22.Health.Value > 0 then
				return v_22
			end
		end

		if arg2 then
			local v_22 = next
			local children3, v_23 = arg:GetChildren()

			for _, v_24 in v_22, children3, v_23 do
				if v_24.Name == "Leviathan Segment" and v_24:GetAttribute("SegmentId") == arg2 and v_24.Health.Value > 0 then
					return v_24
				end
			end
		end
	end

	MultiSegmentLeviathan = function(arg, arg2)
		if arg2 then
			local valueDamageMultiSegments = Settings["Value Damage Multi Segments"] or 30000
			local v_18 = next
			local children, v_19 = arg:GetChildren()

			for _, v_20 in v_18, children, v_19 do
				if v_20.Name == "Leviathan Segment" and v_20:GetAttribute("SegmentId") == arg2 and v_20.Health.Value > 0 and (not v_20:FindFirstChild("Tinhdamage") or v_20:FindFirstChild("Tinhdamage") and v_20.Tinhdamage.Value < valueDamageMultiSegments) then
					return v_20
				end
			end
		end
	end

	getgenv().CFrameLeviathan = CFrame.new(0, 142, 0)

	AutoAttackLeviathan = function()
		local v_18 = MultiSegmentLeviathan(game.workspace.SeaBeasts, 2) or MultiSegmentLeviathan(game.workspace.SeaBeasts, 3) or MultiSegmentLeviathan(game.workspace.SeaBeasts, 4)

		if Settings["Attack Multi Segments Leviathan"] then
			local valueDamageMultiSegments = Settings["Value Damage Multi Segments"] or 30000

			if v_18 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not v_18:FindFirstChild("Tinhdamage") then
							Instance.new("IntValue", v_18).Name = "Tinhdamage"
						end

						if v_18:FindFirstChild("Tinhdamage") and v_18.Tinhdamage.Value < valueDamageMultiSegments then
							if game:GetService("Players").LocalPlayer.PlayerGui.Main.DmgCounter.Visible and flag2 then
								v_18.Tinhdamage.Value = v_18.Tinhdamage.Value + n4
								n5 = n4
								flag2 = false
								task.wait(0.1)
							end
						end

						if v_18.Name == "Leviathan" then
							local cFrame2 = v_18.Hitbox11.CFrame
							getgenv().AimPos = cFrame2

							spawn(function()
								local v_19 = toTarget
								local cframe = CFrame.new(v_18.HumanoidRootPart.Position.X, 140, v_18.HumanoidRootPart.Position.Z)
								v_19(cframe)
							end)
						else
							local cFrame2 = v_18.Hitbox11.CFrame
							getgenv().AimPos = cFrame2

							spawn(function()
								local v_19 = toTarget
								local cframe = CFrame.new(v_18.HumanoidRootPart.Position.X, 142, v_18.HumanoidRootPart.Position.Z)
								v_19(cframe)
							end)
						end

						if Settings["Use Click M1 Fruit Leviathan"] then
							equiptool(NameWeapon("Blox Fruit"))
							local v_19 = NameWeapon("Blox Fruit")

							if localPlayer.Character:FindFirstChild(v_19) and localPlayer.Character[v_19]:FindFirstChild("LeftClickRemote") then
								getgenv().UseFruitM1(v_18, true)
							end
						elseif Settings["Use Click M1 Skull Guitar Leviathan"] then
							equiptool(NameWeapon("Gun"))
							SpamGunSkullGuitar(v.Hitbox11)

							if localPlayer:DistanceFromCharacter(v.Hitbox11.Position) < 400 then
								UseSkillGun()
							end
						elseif localPlayer:DistanceFromCharacter(v_18.RootPart.Position) < 400 then
							AutoUseSkillSeabeast()
						end

						if not (not v_18 or not v_18.Parent or v_18.Health.Value == 0 or not Settings["Auto Attack Leviathan"] or v_18:FindFirstChild("Tinhdamage") and v_18.Tinhdamage.Value >= valueDamageMultiSegments) then
							continue
						end
					end

					break
				end

				return
			end
		end

		local v_19 = DetectLeviathan(game.workspace.SeaBeasts, 2) or DetectLeviathan(game.workspace.SeaBeasts, 3) or DetectLeviathan(game.workspace.SeaBeasts, 4) or DetectLeviathan(game.workspace.SeaBeasts)

		if v_19 then
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if v_19.Name == "Leviathan" then
						local cFrame2 = v_19.Hitbox11.CFrame
						getgenv().AimPos = cFrame2

						spawn(function()
							local v_20 = toTarget
							local cframe = CFrame.new(v_19.HumanoidRootPart.Position.X, 140, v_19.HumanoidRootPart.Position.Z)
							v_20(cframe)
						end)
					else
						local cFrame2 = v_19.Hitbox11.CFrame
						getgenv().AimPos = cFrame2

						spawn(function()
							local v_20 = toTarget
							local cframe = CFrame.new(v_19.HumanoidRootPart.Position.X, 142, v_19.HumanoidRootPart.Position.Z)
							v_20(cframe)
						end)
					end

					if Settings["Use Click M1 Fruit Leviathan"] then
						equiptool(NameWeapon("Blox Fruit"))
						local v_20 = NameWeapon("Blox Fruit")

						if localPlayer.Character:FindFirstChild(v_20) and localPlayer.Character[v_20]:FindFirstChild("LeftClickRemote") then
							getgenv().UseFruitM1(v_19, true)
						end
					elseif Settings["Use Click M1 Skull Guitar Leviathan"] then
						equiptool(NameWeapon("Gun"))
						SpamGunSkullGuitar(v_19.Hitbox11)

						if localPlayer:DistanceFromCharacter(v_19.Hitbox11.Position) < 400 then
							UseSkillGun()
						end
					elseif localPlayer:DistanceFromCharacter(v_19.Hitbox11.Position) < 400 then
						AutoUseSkillSeabeast()
					end

					if not (not v_19 or not v_19.Parent or v_19.Health.Value == 0 or not Settings["Auto Attack Leviathan"] or Settings["Attack Multi Segments Leviathan"] and v_18) then
						continue
					end
				end

				break
			end
		end
	end

	local function fn14(arg, arg2)
		local cFrame2 = arg.PrimaryPart.CFrame
		local unit = (cFrame2.LookVector * Vector3.new(1, 0, 1)).Unit
		local unit2 = ((arg2 - cFrame2.Position) * Vector3.new(1, 0, 1)).Unit
		local v_18 = math.acos(math.clamp(unit:Dot(unit2), -1, 1))
		local v_19 = unit:Cross(unit2)
		local n6 = math.deg(v_18)

		if v_19.Y < 0 then
			n6 = -n6
		end

		return n6
	end

	local function fn15(arg, arg2)
		if not arg or not arg.PrimaryPart or not arg2 then
			return
		end
		local position = arg.PrimaryPart.Position
		local vector = Vector3.new(arg2.X, position.Y, arg2.Z)
		local setPrimaryPartCFrame = arg.SetPrimaryPartCFrame
		local v_18 = arg
		local cframe = CFrame.lookAt(position, vector)
		setPrimaryPartCFrame(v_18, cframe)
	end

	game:GetService("VirtualInputManager")

	local tbl14 = {
		Vector3.new(7415.8325, 24.000849, -6664.6826),
		Vector3.new(-4703.16, 24.00002, -7.8222027),
		Vector3.new(-8762.331, 23.999748, -452.25867),
		Vector3.new(-15018.063, 23.999054, 199.03154),
		Vector3.new(-16065.729, 23.999151, 421.89822),
	}

	local tbl15 = {
		Vector3.new(7415.8325, 24.000849, -6664.6826),
		Vector3.new(1162.8353, 24.000189, -1825.8121),
		Vector3.new(2517.8875, 24.000118, 5109.431),
		Vector3.new(5172.726, 23.999813, 3893.6245),
		Vector3.new(5203.809, 24.00104, 2013.0905),
	}

	playerModule = nil

	pcall(function()
		playerModule = v_2(game.Players.LocalPlayer:WaitForChild("PlayerScripts", 5):WaitForChild("PlayerModule", 5))
	end)

	AutoMoveTo = function(arg)
		if not playerModule then
			return
		end
		playerModule:GetClickToMoveController():MoveTo(arg, false, false)
	end

	DriveBoatToTiki = function()
		for _, v_18 in ipairs(tbl14) do
			while _G.autoDrive and task.wait() do
				local v_19 = checkboatFind()
				if not v_19 then
					return
				end
				local v_20 = fn14(v_19, v_18)

				if (v_19.PrimaryPart.Position - v_18).Magnitude < 10 then
					v_19.PrimaryPart.ThrottleFloat = 0
					v_19.PrimaryPart.Throttle = 0
					break
				end

				spawn(function()
					v_19.VehicleSeat.MaxSpeed = Settings["Speed Boat Auto Drive"] or 300
					NoclipBoat(v_19)
				end)

				if math.abs(v_20) > 5 then
					fn15(v_19, v_18)
					v_19.PrimaryPart.ThrottleFloat = 0
					v_19.PrimaryPart.Throttle = 0
				else
					v_19.PrimaryPart.ThrottleFloat = 1
					v_19.PrimaryPart.Throttle = 1
				end
			end
		end
	end

	DriveBoatToHydra = function()
		for _, v_18 in ipairs(tbl15) do
			while _G.autoDrive and task.wait(0.1) do
				local v_19 = checkboatFind()
				if not v_19 then
					return
				end
				local v_20 = fn14(v_19, v_18)

				if (v_19.PrimaryPart.Position - v_18).Magnitude < 10 then
					v_19.PrimaryPart.ThrottleFloat = 0
					v_19.PrimaryPart.Throttle = 0
					break
				end

				spawn(function()
					v_19.VehicleSeat.MaxSpeed = Settings["Speed Boat Auto Drive"] or 300
					NoclipBoat(v_19)
				end)

				if math.abs(v_20) > 5 then
					fn15(v_19, v_18)
					v_19.PrimaryPart.ThrottleFloat = 0
					v_19.PrimaryPart.Throttle = 0
				else
					v_19.PrimaryPart.ThrottleFloat = 1
					v_19.PrimaryPart.Throttle = 1
				end
			end
		end
	end

	LeviathanEventSection.CreateToggle({
		Title = "Auto Attack Leviathan",
		Desc = nil,
		Default = Settings["Auto Attack Leviathan"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Attack Leviathan"] and wait(0.1) do
					local ok, result = pcall(function()
						AutoAttackLeviathan()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Attack Leviathan", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Use Click M1 Fruit Leviathan",
		Desc = nil,
		Default = Settings["Use Click M1 Fruit Leviathan"] or false,
	}, function(arg)
		SaveSettings("Use Click M1 Fruit Leviathan", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Use Click M1 Skull Guitar Leviathan",
		Desc = nil,
		Default = Settings["Use Click M1 Skull Guitar Leviathan"] or false,
	}, function(arg)
		SaveSettings("Use Click M1 Skull Guitar Leviathan", arg)
	end)

	local v_18 = LeviathanEventSection.CreateDropdown({
		Title = "Select Owner Boat Beast Hunter Shoot Heart",
		List = DetectNamePlayer(),
		Search = true,
		Selected = false,
		Default = Settings["Select Owner Boat Beast Hunter"] or nil,
	}, function(arg)
		SaveSettings("Select Owner Boat Beast Hunter", arg)
	end)

	LeviathanEventSection.CreateButton({ Title = "Refresh Player" }, function()
		v_18:GetNewList(DetectNamePlayer())
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Use Your Boat Beast Hunter",
		Desc = nil,
		Default = Settings["Use Your Boat Beast Hunter"] or false,
	}, function(arg)
		SaveSettings("Use Your Boat Beast Hunter", arg)
	end)

	checkboatBeastHunter = function()
		local selectOwnerBoatBeastHunter = Settings["Select Owner Boat Beast Hunter"]

		if Settings["Use Your Boat Beast Hunter"] then
			selectOwnerBoatBeastHunter = localPlayer.Name
		end

		local v_19 = next
		local children, v_20 = game:GetService("Workspace").Boats:GetChildren()

		for _, v_21 in v_19, children, v_20 do
			if v_21:IsA("Model") then
				if v_21:FindFirstChild("Owner") and tostring(v_21.Owner.Value) == selectOwnerBoatBeastHunter and v_21.Humanoid.Value > 0 then
					return v_21
				end
			end
		end

		return false
	end

	ShootHeartLeviathan = function()
		if workspace.Map:FindFirstChild("FrozenHeart") then
			if not workspace.Map.FrozenHeart.Inside:GetAttribute("Harpooned") then
				local v_19 = checkboatBeastHunter()
				NoclipBoat(v_19)
				local TweenService = game:service("TweenService")
				local y = v_19.WorldPivot.Y
				local map = workspace.Map
				local n6 = CFrame.new(workspace.Map:FindFirstChild("FrozenHeart").Cube.Position.X, y, map:FindFirstChild("FrozenHeart").Cube.Position.Z) * CFrame.new(0, 0, 300) * CFrame.Angles(0, 6.2831853071795862, 0)

				if (n6.Position - v_19.VehicleSeat.Position).Magnitude > 5 then
					if localPlayer.Character.Humanoid.SeatPart and localPlayer.Character.Humanoid.SeatPart.Name == "VehicleSeat" then
						local tween = TweenService:Create(v_19.VehicleSeat, TweenInfo.new((n6.Position - v_19.VehicleSeat.Position).Magnitude / 150, Enum.EasingStyle.Quad), { CFrame = n6 })
						tween:Play()
						tween.Completed:wait()
						wait(1)
						fn15(v_19, workspace.Map:FindFirstChild("FrozenHeart").Inside.Position)
					else
						toTarget(v_19.VehicleSeat.CFrame)
					end
				elseif localPlayer.Character.Humanoid.SeatPart and localPlayer.Character.Humanoid.SeatPart.Parent.Name == "Harpoon" then
					local tbl16 = {
						"FireHarpoon",
						0.78539816339744828,
						0.00044342573293783646,
						v_19.Harpoon,
						(workspace:GetServerTimeNow()),
					}

					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(tbl16))
				else
					toTarget(v_19.Harpoon.Seat.CFrame)
				end
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Successfully Fire Shoot Heart Leviathan", ShowTime = 5 })
				wait(5)
			end
		end
	end

	LeviathanEventSection.CreateToggle({
		Title = "Auto Fire Shoot Heart Leviathan",
		Desc = nil,
		Default = Settings["Auto Fire Shoot Heart Leviathan"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Fire Shoot Heart Leviathan"] and task.wait(0.1) do
					local ok, result = pcall(function()
						ShootHeartLeviathan()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Fire Shoot Heart Leviathan", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Teleport Frozen Dimension",
		Desc = nil,
		Default = Settings["Teleport Frozen Dimension"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Teleport Frozen Dimension"] and wait() do
					pcall(function()
						if game.workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
							local v_19 = DetectNpc("Frozen Watcher")
							if not v_19 or not v_19:FindFirstChild("HumanoidRootPart") then
								return
							end

							if v_19 then
								toTarget(v_19.HumanoidRootPart.CFrame)
								return
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Teleport Frozen Dimension", arg)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Tween Boat To Frozen Dimension",
		Desc = nil,
		Default = Settings["Tween Boat To Frozen Dimension"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Tween Boat To Frozen Dimension"] and wait() do
					pcall(function()
						if game.workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
							AllNPCS = {}

							for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
								table.insert(AllNPCS, child)
							end

							for _, child in pairs(game:GetService("ReplicatedStorage").NPCs:GetChildren()) do
								table.insert(AllNPCS, child)
							end

							for _, v_19 in pairs(AllNPCS) do
								if v_19.Name == "Frozen Watcher" then
									local v_20 = checkboatFind()

									while true do
										task.wait()
										manageTween(v_20.VehicleSeat, CFrame.new(v_19.HumanoidRootPart.Position.X, v_20.VehicleSeat.Position.Y, v_19.HumanoidRootPart.Position.Z), 350, "TweenBoatToFrozen")
										NoclipBoat(v_20)
										if not (game:GetService("Workspace").NPCs:FindFirstChild("Frozen Watcher") or not Settings["Tween Boat To Frozen Dimension"]) then
											continue
										end
										break
									end

									if getgenv().TweenBoatToFrozen then
										getgenv().TweenBoatToFrozen:Pause()
										getgenv().TweenBoatToFrozen:Cancel()
									end
								end
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Tween Boat To Frozen Dimension", arg)
	end)

	LeviathanEventSection.CreateSlider({
		Title = "Speed Boat Auto Drive",
		Min = 0,
		Max = 500,
		Default = Settings["Speed Boat Auto Drive"] or 300,
		Precise = true,
	}, function(arg)
		SaveSettings("Speed Boat Auto Drive", arg)
	end)

	LeviathanEventSection.CreateToggle({ Title = "Drive Boat To Tiki", Desc = nil, Default = Settings["Drive Boat To Tiki"] or false }, function(autoDrive)
		_G.autoDrive = autoDrive

		if autoDrive then
			spawn(function()
				local ok, result = pcall(DriveBoatToTiki)

				if not ok then
					warn("Lỗi khi chạy DriveBoatToTiki:", result)
				end
			end)
		end

		SaveSettings("Drive Boat To Tiki", autoDrive)
	end)

	LeviathanEventSection.CreateToggle({
		Title = "Drive Boat To Hydra",
		Desc = nil,
		Default = Settings["Drive Boat To Hydra"] or false,
	}, function(autoDrive)
		_G.autoDrive = autoDrive

		if autoDrive then
			spawn(function()
				local ok, result = pcall(DriveBoatToHydra)

				if not ok then
					warn("Lỗi khi chạy DriveBoatToHydra:", result)
				end
			end)
		end

		SaveSettings("Drive Boat To Hydra", autoDrive)
	end)

	BoatSettingSection = SeaEventTab.CreateSection("Boat Setting")
	local v_19 = table.find({ Enum.Platform.IOS, Enum.Platform.Android }, game:GetService("UserInputService"):GetPlatform())
	FLYING = false
	QEfly = true
	iyflyspeed = 1

	getRoot = function(arg)
		return arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("Torso") or arg:FindFirstChild("UpperTorso")
	end

	sFLY = function(arg)
		while true do
			wait()
			if not (localPlayer and localPlayer.Character and getRoot(localPlayer.Character) and localPlayer.Character:FindFirstChildOfClass("Humanoid")) then
				continue
			end
			break
		end

		repeat
			wait()
		until IYMouse

		if flyKeyDown or flyKeyUp then
			flyKeyDown:Disconnect()
			flyKeyUp:Disconnect()
		end

		local v_20 = getRoot(localPlayer.Character)
		local tbl16 = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
		local tbl17 = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
		local n6 = 0

		local function fn16()
			FLYING = true
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Parent = v_20
			bodyVelocity.velocity = Vector3.zero
			bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

			task.spawn(function()
				while true do
					wait()

					if not arg and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
						Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = true
					end

					if tbl16.L + tbl16.R ~= 0 or tbl16.F + tbl16.B ~= 0 or tbl16.Q + tbl16.E ~= 0 then
						n6 = 50
					elseif not (tbl16.L + tbl16.R ~= 0 or tbl16.F + tbl16.B ~= 0 or tbl16.Q + tbl16.E ~= 0) and n6 ~= 0 then
						n6 = 0
					end

					if tbl16.L + tbl16.R ~= 0 or tbl16.F + tbl16.B ~= 0 or tbl16.Q + tbl16.E ~= 0 then
						local p = workspace.CurrentCamera.CoordinateFrame.p
						bodyVelocity.velocity = (workspace.CurrentCamera.CoordinateFrame.lookVector * (tbl16.F + tbl16.B) + workspace.CurrentCamera.CoordinateFrame * CFrame.new(tbl16.L + tbl16.R, (tbl16.F + tbl16.B + tbl16.Q + tbl16.E) * 0.2, 0).p - p) * n6
						tbl17 = { F = tbl16.F, B = tbl16.B, L = tbl16.L, R = tbl16.R }
					elseif tbl16.L + tbl16.R == 0 and tbl16.F + tbl16.B == 0 and tbl16.Q + tbl16.E == 0 and n6 ~= 0 then
						local p = workspace.CurrentCamera.CoordinateFrame.p
						bodyVelocity.velocity = (workspace.CurrentCamera.CoordinateFrame.lookVector * (tbl17.F + tbl17.B) + workspace.CurrentCamera.CoordinateFrame * CFrame.new(tbl17.L + tbl17.R, (tbl17.F + tbl17.B + tbl16.Q + tbl16.E) * 0.2, 0).p - p) * n6
					else
						bodyVelocity.velocity = Vector3.zero
					end

					if FLYING then
						continue
					end
					break
				end

				tbl16 = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
				tbl17 = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }
				n6 = 0
				bodyVelocity:Destroy()

				if Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
				end
			end)
		end

		flyKeyDown = IYMouse.KeyDown:Connect(function(arg2)
			if arg2:lower() == "w" then
				tbl16.F = arg and vehicleflyspeed or iyflyspeed
			elseif arg2:lower() == "s" then
				tbl16.B = -(arg and vehicleflyspeed or iyflyspeed)
			elseif arg2:lower() == "a" then
				tbl16.L = -(arg and vehicleflyspeed or iyflyspeed)
			elseif arg2:lower() == "d" then
				tbl16.R = arg and vehicleflyspeed or iyflyspeed
			elseif QEfly and arg2:lower() == "e" then
				tbl16.Q = (arg and vehicleflyspeed or iyflyspeed) * 2
			elseif QEfly and arg2:lower() == "q" then
				tbl16.E = -(arg and vehicleflyspeed or iyflyspeed) * 2
			end

			pcall(function()
				workspace.CurrentCamera.CameraType = Enum.CameraType.Track
			end)
		end)

		flyKeyUp = IYMouse.KeyUp:Connect(function(arg2)
			if arg2:lower() == "w" then
				tbl16.F = 0
			elseif arg2:lower() == "s" then
				tbl16.B = 0
			elseif arg2:lower() == "a" then
				tbl16.L = 0
			elseif arg2:lower() == "d" then
				tbl16.R = 0
			elseif arg2:lower() == "e" then
				tbl16.Q = 0
			elseif arg2:lower() == "q" then
				tbl16.E = 0
			end
		end)

		fn16()
	end

	randomStringfly = function()
		local tbl16 = {}

		for i = 1, math.random(10, 20) do
			tbl16[i] = string.char(math.random(32, 126))
		end

		return table.concat(tbl16)
	end

	NOFLY = function()
		FLYING = false

		if game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGuiFly") then
			game.Players.LocalPlayer.PlayerGui.ScreenGuiFly:Destroy()
		end

		if flyKeyDown or flyKeyUp then
			flyKeyDown:Disconnect()
			flyKeyUp:Disconnect()
		end

		if Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false
		end

		pcall(function()
			workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		end)
	end

	local v_20 = randomStringfly()
	local v_21 = randomStringfly()
	local connection = nil
	local connection2 = nil

	local function fn16(arg)
		pcall(function()
			FLYING = false

			if game.Players.LocalPlayer.PlayerGui:FindFirstChild("ScreenGuiFly") then
				game.Players.LocalPlayer.PlayerGui.ScreenGuiFly:Destroy()
			end

			local v_22 = getRoot(arg.Character)

			if v_22 then
				local v_23 = v_22:FindFirstChild(v_20)

				if v_23 then
					v_23:Destroy()
				end

				local v_24 = v_22:FindFirstChild(v_21)

				if v_24 then
					v_24:Destroy()
				end
			end

			local humanoid = arg.Character and arg.Character:FindFirstChildWhichIsA("Humanoid")

			if humanoid then
				humanoid.PlatformStand = false
			end

			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end
		end)
	end

	local function fn17(arg, arg2)
		fn16(arg)
		FLYING = true
		local v_22 = getRoot(arg.Character)
		local currentCamera = workspace.CurrentCamera
		local vector = Vector3.new()
		local vector2 = Vector3.zero
		local vector3 = Vector3.new(9e9, 9e9, 9e9)
		local v_23 = v_2(arg.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = v_20
		bodyVelocity.Parent = v_22
		bodyVelocity.MaxForce = vector2
		bodyVelocity.Velocity = vector2

		connection = arg.CharacterAdded:Connect(function()
			local bodyVelocity2 = Instance.new("BodyVelocity")
			bodyVelocity2.Name = v_20
			bodyVelocity2.Parent = v_22
			bodyVelocity2.MaxForce = vector2
			bodyVelocity2.Velocity = vector2
		end)

		local screenGui = Instance.new("ScreenGui")
		local textButton = Instance.new("TextButton")
		local textButton2 = Instance.new("TextButton")
		screenGui.Name = "ScreenGuiFly"
		screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.ResetOnSpawn = false
		textButton.Name = "FlyUp"
		textButton.Parent = screenGui
		textButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		textButton.BackgroundTransparency = 1
		textButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		textButton.BorderSizePixel = 0
		textButton.Position = UDim2.new(0.158661261, 0, 0.82663101, 0)
		textButton.Size = UDim2.new(0.0538219661, 0, 0.0765434727, 0)
		textButton.Font = Enum.Font.SourceSans
		textButton.Text = "↑"
		textButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		textButton.TextScaled = true
		textButton.TextSize = 14
		textButton.TextWrapped = true
		textButton2.Name = "FlyDown"
		textButton2.Parent = screenGui
		textButton2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		textButton2.BackgroundTransparency = 1
		textButton2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		textButton2.BorderSizePixel = 0
		textButton2.Position = UDim2.new(0.158661261, 0, 0.922887683, 0)
		textButton2.Size = UDim2.new(0.0538219661, 0, 0.0765434727, 0)
		textButton2.Font = Enum.Font.SourceSans
		textButton2.Text = "↓"
		textButton2.TextColor3 = Color3.fromRGB(0, 0, 0)
		textButton2.TextScaled = true
		textButton2.TextSize = 14
		textButton2.TextWrapped = true

		connection2 = game:GetService("RunService").RenderStepped:Connect(function()
			v_22 = getRoot(arg.Character)
			currentCamera = workspace.CurrentCamera

			if arg.Character:FindFirstChildWhichIsA("Humanoid") and v_22 and v_22:FindFirstChild(v_20) then
				local humanoid = arg.Character:FindFirstChildWhichIsA("Humanoid")
				local v_24 = v_22:FindFirstChild(v_20)
				v_24.MaxForce = vector3

				if not arg2 then
					humanoid.PlatformStand = true
				end

				v_24.Velocity = vector
				local moveVector = v_23:GetMoveVector()

				if moveVector.X > 0 then
					v_24.Velocity = v_24.Velocity + currentCamera.CFrame.RightVector * moveVector.X * (arg2 and vehicleflyspeed or iyflyspeed) * 50
				end

				if moveVector.X < 0 then
					v_24.Velocity = v_24.Velocity + currentCamera.CFrame.RightVector * moveVector.X * (arg2 and vehicleflyspeed or iyflyspeed) * 50
				end

				if moveVector.Z > 0 then
					v_24.Velocity = v_24.Velocity - currentCamera.CFrame.LookVector * moveVector.Z * (arg2 and vehicleflyspeed or iyflyspeed) * 50
				end

				if moveVector.Z < 0 then
					v_24.Velocity = v_24.Velocity - currentCamera.CFrame.LookVector * moveVector.Z * (arg2 and vehicleflyspeed or iyflyspeed) * 50
				end

				textButton2.MouseButton1Click:Connect(function()
					v_24.Velocity = Vector3.new(0, -20, 0)
				end)

				textButton.MouseButton1Click:Connect(function()
					v_24.Velocity = Vector3.new(0, 20, 0)
				end)
			end
		end)
	end

	BoatSettingSection.CreateToggle({ Title = "Fly Boat", Desc = nil, Default = Settings["Fly Boat"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Fly Boat"] and wait(0.1) do
					pcall(function()
						if localPlayer.Character.Humanoid.Sit then
							if not v_19 then
								NOFLY()
								wait()
								sFLY(true)
							else
								fn17(localPlayer, true)
							end

							while true do
								wait()
								if not (not Settings["Fly Boat"] or not localPlayer.Character.Humanoid.Sit) then
									continue
								end
								break
							end

							if not v_19 then
								NOFLY()
							else
								fn16(localPlayer)
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Fly Boat", arg)
	end)

	valueSpeedFlyBoat = Settings["Value Speed Fly Boat"]

	BoatSettingSection.CreateSlider({
		Title = "Value Speed Boat",
		Min = 0,
		Max = 500,
		Default = Settings["Value Speed Boat"] or 200,
		Precise = true,
	}, function(arg)
		SaveSettings("Value Speed Boat", arg)
	end)

	BoatSettingSection.CreateSlider({
		Title = "Value Speed Tween Boat",
		Min = 50,
		Max = 2000,
		Default = tonumber(Settings["Value Speed Tween Boat"]) or 350,
		Precise = true,
	}, function(arg)
		SaveSettings("Value Speed Tween Boat", arg)
		local tweenBoat = getgenv().TweenBoat

		if tweenBoat and tweenBoat.Speed then
			tweenBoat.Speed = math.max(tonumber(arg) or 350, 1)
		end
	end)

	BoatSettingSection.CreateSlider({
		Title = "Value Speed Fly Boat",
		Min = 0,
		Max = 10,
		Default = Settings["Value Speed Fly Boat"] or 3,
		Precise = true,
	}, function(arg)
		SaveSettings("Value Speed Fly Boat", arg)
	end)

	checkSpeedboat = function()
		local n6 = tonumber(Settings["Value Speed Boat"]) or 200
		local v_22 = checkboat()

		if v_22 then
			local vehicleSeat = v_22:FindFirstChild("VehicleSeat")
			if vehicleSeat and vehicleSeat.MaxSpeed + 1 < n6 then
				return v_22
			end
		end

		return false
	end

	ChangeSpeedBoat = function()
		local maxSpeed = tonumber(Settings["Value Speed Boat"]) or 200
		local v_22 = checkSpeedboat()

		if v_22 then
			v_22.VehicleSeat.MaxSpeed = maxSpeed
		end
	end

	BoatSettingSection.CreateToggle({ Title = "Change Speed Boat", Desc = nil, Default = Settings["Change Speed Boat"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Change Speed Boat"] and task.wait(0.3) do
					local ok, result = pcall(ChangeSpeedBoat)

					if not ok then
						WarnOnce("ChangeSpeedBoat", "Change Speed Boat loi: " .. tostring(result))
					end
				end
			end)
		end

		SaveSettings("Change Speed Boat", arg)
	end)

	RaceMain = Main.CreatePage({ Page_Name = "Upgrade Race", Page_Title = "Upgrade Race Tab" })
	RaceDracoSection = RaceMain.CreateSection("Race Draco")

	DetectGearUp = function(arg)
		local v_22 = v_2(game:GetService("Players").LocalPlayer.PlayerGui.TempleGui.LocalScriptTemple.Buttons)
		arg = arg or game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TempleClock", "Check")
		if type(arg) ~= "table" then
			return
		end
		local flag3 = arg.HadPoint == true
		local canSelect = arg.RaceLevel >= 2
		v_22.Gear1.GearType = "Default"
		v_22.Gear4.GearType = "Default"
		v_22.Gear5.GearType = "Default"
		v_22.Gear2.GearType = "Alpha"
		v_22.Gear2.CanSelect = false
		v_22.Gear3.CanSelect = false
		v_22.Gear2.GearType = arg.RaceDetails.Gears[1] == "A" and "Alpha" or arg.RaceDetails.Gears[1] == "B" and "Omega" or "Blank"
		v_22.Gear3.GearType = arg.RaceDetails.Gears[2] == "A" and "Alpha" or arg.RaceDetails.Gears[2] == "B" and "Omega" or "Blank"
		v_22.Gear4.GearType = arg.RaceDetails.Gears[3] == "A" and "Alpha" or arg.RaceDetails.Gears[3] == "B" and "Omega" or "Blank"
		local gear2 = v_22.Gear2
		local unlocked

		if arg.RaceDetails.A + arg.RaceDetails.B >= 0 then
			unlocked = canSelect
		else
			unlocked = false
		end

		gear2.Unlocked = unlocked
		local gear3 = v_22.Gear3
		local unlocked2

		if arg.RaceDetails.A + arg.RaceDetails.B >= 1 then
			unlocked2 = canSelect
		else
			unlocked2 = false
		end

		gear3.Unlocked = unlocked2
		local gear4 = v_22.Gear4
		local unlocked3

		if arg.RaceDetails.A + arg.RaceDetails.B >= 2 then
			unlocked3 = canSelect
		else
			unlocked3 = false
		end

		gear4.Unlocked = unlocked3
		v_22.Gear5.CanSelect = false
		v_22.Gear5.Unlocked = false

		if arg.RaceDetails.C >= 1 then
			v_22.Gear5.Unlocked = true
		end

		v_22.Gear1.Unlocked = true

		if not canSelect then
			v_22.Gear1.CanSelect = true
			v_22.Gear1.GearType = "Blank"
			flag3 = true
		else
			v_22.Gear1.CanSelect = false
			v_22.Gear1.GearType = "Default"
		end

		if not flag3 then
			v_22.Gear2.CanSelect = false
			v_22.Gear3.CanSelect = false
			v_22.Gear4.CanSelect = false
		else
			local gear22 = v_22.Gear2
			local canSelect2

			if arg.RaceDetails.A + arg.RaceDetails.B == 0 then
				canSelect2 = canSelect
			else
				canSelect2 = false
			end

			gear22.CanSelect = canSelect2
			local gear32 = v_22.Gear3
			local canSelect3

			if arg.RaceDetails.A + arg.RaceDetails.B == 1 then
				canSelect3 = canSelect
			else
				canSelect3 = false
			end

			gear32.CanSelect = canSelect3
			local gear42 = v_22.Gear4

			if not (arg.RaceDetails.A + arg.RaceDetails.B >= 2) then
				canSelect = false
			end

			gear42.CanSelect = canSelect

			if arg.RaceDetails.A + arg.RaceDetails.B >= 3 then
				v_22.Gear2.CanSelect = true
				v_22.Gear3.CanSelect = true
				v_22.Gear4.CanSelect = true

				if v_22.Gear2.GearType == "Alpha" and v_22.Gear3.GearType == "Alpha" and v_22.Gear4.GearType == "Omega" then
					v_22.Gear4.CanSelect = false
				elseif v_22.Gear2.GearType == "Omega" and v_22.Gear3.GearType == "Omega" and v_22.Gear4.GearType == "Alpha" then
					v_22.Gear4.CanSelect = false
				elseif v_22.Gear2.GearType == "Alpha" and v_22.Gear3.GearType == "Omega" and v_22.Gear4.GearType == "Omega" then
					v_22.Gear4.CanSelect = false
					v_22.Gear2.CanSelect = false
				elseif v_22.Gear2.GearType == "Omega" and v_22.Gear3.GearType == "Alpha" and v_22.Gear4.GearType == "Omega" then
					v_22.Gear4.CanSelect = false
					v_22.Gear3.CanSelect = false
				elseif v_22.Gear2.GearType == "Omega" and v_22.Gear3.GearType == "Alpha" and v_22.Gear4.GearType == "Alpha" then
					v_22.Gear4.CanSelect = false
					v_22.Gear2.CanSelect = false
				elseif v_22.Gear2.GearType == "Alpha" and v_22.Gear3.GearType == "Omega" and v_22.Gear4.GearType == "Alpha" then
					v_22.Gear4.CanSelect = false
					v_22.Gear3.CanSelect = false
				end
			end
		end

		for i = 1, 5 do
			local v_23 = v_22["Gear" .. i]
			if v_23 and v_23.CanSelect then
				return "Gear" .. i
			end
		end
	end

	ChooseGearV4 = function()
		local response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TempleClock", "Check")
		if not response or not response.HadPoint then
			return
		end
		local v_22 = DetectGearUp(response)
		if not v_22 then
			return
		end
		local str = Settings["Select Gear V4"] == "Alpha" and "Alpha" or "Omega"
		game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", v_22, str)
		local response2 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TempleClock", "Check")

		if response2 and response2.HadPoint and DetectGearUp(response2) == v_22 then
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TempleClock", "SpendPoint", v_22, str == "Alpha" and "Omega" or "Alpha")
		end
	end

	DetectFireFlower = function()
		local v_22 = next
		local children, v_23 = workspace.FireFlowers:GetChildren()

		for _, v_24 in v_22, children, v_23 do
			if v_24:IsA("Model") then
				return v_24
			end
		end
	end

	local tbl16 = { "V2InProgress", "V3InProgress", "V2TurnInReady", "V3TurnInReady" }

	AutoUpgradeRaceDraco = function()
		if game.Players.LocalPlayer.Data.Race.Value ~= "Draco" then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Change Race Draco plz", ShowTime = 5 })
			wait(5)
			return
		end

		if DetectItemPlr("Primordial Reign") then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done V3 Draco", ShowTime = 5 })
			wait(5)
			return
		end

		local dragonWizard = DetectNpc("Dragon Wizard") or workspace.NPCs:FindFirstChild("Dragon Wizard") or game:GetService("ReplicatedStorage").NPCs:FindFirstChild("Dragon Wizard")

		if not getgenv().QuestDraco or getgenv().QuestDraco and not table.find(tbl16, getgenv().QuestDraco.AvailableVQuest) then
			if localPlayer:DistanceFromCharacter(dragonWizard.HumanoidRootPart.Position) > 8 then
				toTarget(dragonWizard.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
			else
				getgenv().QuestDraco = game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Speak" })
				wait(1)

				if getgenv().QuestDraco and getgenv().QuestDraco.AvailableVQuest == "V2" or getgenv().QuestDraco.AvailableVQuest == "V3" then
					game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Begin" })
					getgenv().QuestDraco = game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Speak" })
				end
			end
		elseif getgenv().QuestDraco.AvailableVQuest == "V2TurnInReady" then
			game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Complete" })
			getgenv().QuestDraco = nil
		elseif getgenv().QuestDraco.AvailableVQuest == "V3TurnInReady" then
			game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Complete" })
			getgenv().QuestDraco = nil
		elseif getgenv().QuestDraco.AvailableVQuest == "V2InProgress" then
			if not CheckCountItem("Fire Flower", 5) then
				local v_22 = DetectFireFlower()

				if v_22 then
					toTarget(v_22.PrimaryPart.CFrame)

					if localPlayer:DistanceFromCharacter(v_22.PrimaryPart.Position) < 8 then
						fireproximityprompt(v_22.ProximityPrompt, 1)
					end
				else
					local v_23 = DetectMob("Forest Pirate")

					if not v_23 then
						local v_24 = DetectPartSpawnMob("Forest Pirate", true)

						if v_24 then
							Instance.new("IntValue", v_24).Name = "Ignored"

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_24.CFrame * CFrame.new(0, 60, 0))
									if not ((v_24.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Forest Pirate") or not Settings["Auto Upgrade Race V2-V3 Draco"] or wait(1)) then
										continue
									end
								end

								break
							end
						else
							DeleteIgnoredMobSpawn()
						end
					else
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_23)
								BringMob(v_23)
								UsedualFlock()
								ClickM1(v_23)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_23.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_23.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								if not (not IsMobAlive(v_23) or not Settings["Auto Upgrade Race V2-V3 Draco"]) then
									continue
								end
							end

							break
						end
					end
				end
			elseif localPlayer:DistanceFromCharacter(dragonWizard.HumanoidRootPart.Position) > 8 then
				toTarget(dragonWizard.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
			else
				game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Complete" })
				getgenv().QuestDraco = nil
			end
		elseif getgenv().QuestDraco.AvailableVQuest == "V3InProgress" then
			SaveSettings("V3InProgress", true)

			if not getgenv().KilledTerroshark then
				local Terrorshark = CheckNameBoss("Terrorshark")
				local v_22 = checkboat()

				if not Terrorshark then
					if not v_22 then
						local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

						if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
							toTarget(cframe)
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
						end
					else
						local v_23 = DecectPartRoughSea()

						if v_23 then
							wait(1)
							local n6

							if roughSea == 0 then
								n6 = 7000
							else
								n6 = 0
							end

							roughSea = n6
							Instance.new("IntValue", v_23).Name = "Ignored"
							wait(0.5)
						end

						getgenv().RoughSea = roughSea
						local n6 = CFrame.new(-32975.9921875, v_22.WorldPivot.Y, 25963.7109375) * CFrame.new(0, v_22.WorldPivot.Y, 0 + RoughSea)

						if not localPlayer.Character.Humanoid.Sit then
							toTarget(v_22.VehicleSeat.CFrame)
						else
							manageTween(v_22.VehicleSeat, n6, 350, "TweenBoat")
						end
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							TeleportSeaEvents(Terrorshark)
							local humanoidRootPart2 = Terrorshark:FindFirstChild("HumanoidRootPart")
							getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)
							UsedualFlock()
							ClickM1(Terrorshark, true)
							if not (not IsMobAlive(Terrorshark) or not Settings["Auto Upgrade Race V2-V3 Draco"]) then
								continue
							end
						end

						break
					end

					getgenv().KilledTerroshark = true
				end
			elseif localPlayer:DistanceFromCharacter(dragonWizard.HumanoidRootPart.Position) > 8 then
				toTarget(dragonWizard.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
			else
				game:GetService("ReplicatedStorage").Modules.Net["RF/InteractDragonQuest"]:InvokeServer({ NPC = "Dragon Wizard", Command = "Ascension", Action = "Complete" })
				getgenv().QuestDraco = nil
				getgenv().KilledTerroshark = false
			end
		end
	end
end

RaceDracoSection.CreateToggle({
	Title = "Auto Upgrade Race V2-V3 Draco",
	Desc = nil,
	Default = Settings["Auto Upgrade Race V2-V3 Draco"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Upgrade Race V2-V3 Draco"] and task.wait() do
				local ok, result = pcall(function()
					AutoUpgradeRaceDraco()
				end)

				if result then
					print(result)
				end
			end
		end)
	end

	SaveSettings("Auto Upgrade Race V2-V3 Draco", arg)
end)

CheckRelicChuaDat = function(arg)
	for _, descendant in pairs(arg:GetDescendants()) do
		if descendant:IsA("ParticleEmitter") and descendant.Enabled then
			return true
		end
	end
end

GetRelicChuaDat = function(arg)
	for k, v_11 in next, arg, nil do
		if string.find(k, "RelicModel") and CheckRelicChuaDat(v_11) then
			return v_11, k
		end
	end
end

GetRelicChuanbiDat = function(arg)
	for k, v_11 in next, arg, nil do
		if string.find(k, "RelicModel") and v_11.PrimaryPart:FindFirstChild("AlignPosition") and CheckRelicChuaDat(v_11) then
			return v_11, k
		end
	end
end

CheckModelTrialDraco = function()
	local tbl7 = {}
	v28 = workspace:WaitForChild("Map"):WaitForChild("DracoTrial")

	for _, v_11 in pairs({
		"Relic1",
		"Relic2",
		"Relic3",
		"EndRelic1",
		"EndRelic2",
		"EndRelic3",
		"Door1",
		"Door2",
		"Door3",
		"Brazier1",
		"Brazier2",
		"Brazier3",
		"Center",
		"EndPlatform",
		"TeleportOut",
	}) do
		tbl7[v_11] = v28:FindFirstChild(v_11, true)
	end

	local v_11 = next
	local children, v_12 = workspace._WorldOrigin:GetChildren()

	for _, v_13 in v_11, children, v_12 do
		if v_13:IsA("Model") and v_13.Name == "Relic" then
			local meshPart = v_13:FindFirstChildWhichIsA("MeshPart")

			if meshPart.Color == Color3.fromRGB(132, 203, 0) then
				tbl7.RelicModel1 = v_13
			end

			if meshPart.Color == Color3.fromRGB(232, 106, 110) then
				tbl7.RelicModel2 = v_13
			end

			if meshPart.Color == Color3.fromRGB(191, 153, 0) then
				tbl7.RelicModel3 = v_13
			end
		end
	end

	return tbl7
end

local createLabel = RaceDracoSection.CreateLabel
getgenv().StatusGearDraco = createLabel({ Title = "Acient One Draco Status" })

ToggleAutoTrialDraco = RaceDracoSection.CreateToggle({ Title = "Auto Trial Draco", Desc = nil, Default = Settings["Auto Trial Draco"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Trial Draco"] and task.wait(0.1) do
				local ok, result = pcall(function()
					if localPlayer:DistanceFromCharacter(workspace._WorldOrigin.Locations["Trial of Flames"].Position) <= 3000 then
						if workspace.Map.DracoTrial.TrialDoor.DoorTouch:FindFirstChild("TouchInterest") then
							getgenv().DoneTrialDraco = true
							toTarget(workspace.Map.DracoTrial.TrialDoor.DoorTouch.CFrame)
							wait(2)
							return
						end

						if game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
							local v_11 = CheckModelTrialDraco()
							local v_12, v_13 = GetRelicChuaDat(v_11)
							local v_14, v_15 = GetRelicChuanbiDat(v_11)

							if v_14 then
								local v_16 = v_11["EndRelic" .. v_15:split("RelicModel")[2]]
								local proximityPrompt = v_16:FindFirstChildWhichIsA("ProximityPrompt", true)

								if localPlayer:DistanceFromCharacter(v_16.WorldPivot.Position) > 8 then
									toTarget(v_16.WorldPivot)
								else
									wait(2)
									fireproximityprompt(proximityPrompt)
									wait(2)
								end
							elseif v_12 then
								local v_16 = v_11["Relic" .. v_13:split("RelicModel")[2]]
								local proximityPrompt = v_16:FindFirstChildWhichIsA("ProximityPrompt", true)

								if localPlayer:DistanceFromCharacter(v_16.WorldPivot.Position) > 8 then
									toTarget(v_16.WorldPivot)
								else
									wait(2)
									fireproximityprompt(proximityPrompt)
									wait(2)
								end
							end
						else
							game.ReplicatedStorage.Remotes.DracoTrial:InvokeServer()
							wait(3)
						end
					else
						if getgenv().DoneTrialDraco then
							lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done Trial", ShowTime = 5 })
							getgenv().DoneTrialDraco = false
							ToggleAutoTrialDraco:SetStage(false)
							return
						end

						if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
							if workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport") then
								toTarget(workspace.Map.PrehistoricIsland.TrialTeleport.CFrame)
							else
								local v_11 = DetectNpc("Fossil Expert")
								if not v_11 or not v_11:FindFirstChild("HumanoidRootPart") then
									return
								end

								if v_11 then
									toTarget(v_11.HumanoidRootPart.CFrame)
									return
								end
							end
						else
							lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Not have Prehistoric Island", ShowTime = 5 })
							wait(5)
						end
					end
				end)

				if result then
					print(result)
				end
			end
		end)
	end

	SaveSettings("Auto Trial Draco", arg)
end)

DetectRockVolcano = function()
	local v_11 = next
	local children, v_12 = workspace.Map.PrehistoricIsland.Core.VolcanoRocks:GetChildren()
	local huge = math.huge
	local v_13 = nil

	for _, v_14 in v_11, children, v_12 do
		if v_14.Name == "Rock" and v_14:FindFirstChild("VFXLayer") and v_14.VFXLayer:FindFirstChild("Specs") and v_14.VFXLayer.Specs.Enabled then
			local v_15 = localPlayer:DistanceFromCharacter(v_14.WorldPivot.Position)

			if v_15 < huge then
				huge = v_15
				v_13 = v_14
			end
		end
	end

	return v_13
end

AutoUseSkillFixLava = function()
	local selectWeaponsFixLava = Settings["Select Weapons Fix Lava"] or {}
	local Melee = selectWeaponsFixLava.Melee and NameWeapon("Melee", true) or false
	local Sword = selectWeaponsFixLava.Sword and NameWeapon("Sword", true) or false
	local bloxFruit = selectWeaponsFixLava["Blox Fruit"] and NameWeapon("Blox Fruit", true) or false
	local Gun = selectWeaponsFixLava.Gun and NameWeapon("Gun", true) or false
	local skills = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills
	if Melee and not skills:FindFirstChild(Melee.Name) then
		equiptool(Melee.Name)
		return
	end

	if Sword and not skills:FindFirstChild(Sword.Name) then
		equiptool(Sword.Name)
		return
	end

	if bloxFruit and not skills:FindFirstChild(bloxFruit.Name) then
		equiptool(bloxFruit.Name)
		return
	end

	if Gun and not skills:FindFirstChild(Gun.Name) then
		equiptool(Gun.Name)
		return
	end
	local v_11

	if Melee and CheckCDSkillTransformation(Melee, Settings["Select Skills " .. Melee.ToolTip]) then
		v_11 = CheckCDSkillTransformation(Melee, Settings["Select Skills " .. Melee.ToolTip])
	elseif Sword and CheckCDSkillTransformation(Sword, Settings["Select Skills " .. Sword.ToolTip]) then
		v_11 = CheckCDSkillTransformation(Sword, Settings["Select Skills " .. Sword.ToolTip])
	elseif Gun and CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip]) then
		v_11 = CheckCDSkillTransformation(Gun, Settings["Select Skills " .. Gun.ToolTip])
	elseif bloxFruit and CheckCDSkillTransformation(bloxFruit, Settings["Select Skills " .. bloxFruit.ToolTip]) then
		v_11 = CheckCDSkillTransformation(bloxFruit, Settings["Select Skills " .. bloxFruit.ToolTip])
	else
		v_11 = nil
	end

	if v_11 then
		local name = v_11.Parent.Name
		equiptool(name)

		if localPlayer.Character:FindFirstChild(name) then
			game:GetService("VirtualInputManager"):SendKeyEvent(true, v_11.Name, false, game)

			if Settings["Use skill fast dont hold"] then
				task.wait(0.05)
			else
				task.wait(tonumber(holdskill))
			end

			game:GetService("VirtualInputManager"):SendKeyEvent(false, v_11.Name, false, game)
		end
	end
end

DetectLava = function()
	local v_11 = next
	local descendants, v_12 = workspace.Map.PrehistoricIsland:GetDescendants()

	for _, v_13 in v_11, descendants, v_12 do
		if v_13.Name == "TouchInterest" and v_13.Parent.Name ~= "TrialTeleport" then
			return true
		end
	end
end

DetectGolem = function()
	for _, child in ipairs(game.workspace.Enemies:GetChildren()) do
		if child.Name == "Lava Golem" and IsMobAlive(child) and localPlayer:DistanceFromCharacter(child.HumanoidRootPart.Position) <= 1500 then
			return child
		end
	end
end

DeleteLava = function()
	local v_11 = next
	local children, v_12 = workspace.Map.PrehistoricIsland.Core.InteriorLava:GetChildren()

	for _, v_13 in v_11, children, v_12 do
		v_13:Destroy()
	end
end

DetectPositionVolcano = function()
	local tbl7 = { workspace.Map.PrehistoricIsland.Core.PrehistoricRelic.Skull.Position }
	local v_11 = next
	local descendants, v_12 = workspace.Map.PrehistoricIsland:GetDescendants()

	for _, v_13 in v_11, descendants, v_12 do
		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://87519803677536" and math.floor(v_13.Position.Y) == 293 then
			tbl7[2] = v_13.Position
		end

		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://9664674474" and math.floor(v_13.Position.Y) == 234 then
			tbl7[3] = v_13.Position
		end

		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://14130842310" and math.floor(v_13.Position.Y) == 266 then
			tbl7[4] = v_13.Position
		end

		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://15672470777" and math.floor(v_13.Position.Y) == 86 then
			tbl7[5] = v_13.Position
		end

		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://5159878936" and math.floor(v_13.Position.Y) == 261 then
			tbl7[6] = v_13.Position
		end

		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://138849514693209" and math.floor(v_13.Position.Y) == 242 then
			tbl7[7] = v_13.Position
		end

		if v_13:IsA("MeshPart") and v_13.MeshId == "rbxassetid://87519803677536" and math.floor(v_13.Position.Y) == 279 then
			tbl7[8] = v_13.Position
		end
	end

	return tbl7
end

CheckPosnearRock = function(arg, arg2)
	local huge = math.huge
	local v_11 = nil
	local n4 = 0

	for k, v_12 in next, arg, nil do
		local vector = Vector3.new(v_12.X, 0, v_12.Z)
		local magnitude = (Vector3.new(arg2.Position.X, 0, arg2.Position.Z) - vector).Magnitude

		if huge > magnitude then
			huge = magnitude
			v_11 = v_12
			n4 = k
		end
	end

	return v_11, n4
end

do
	local flag2 = false
	local n4 = 1

	local tbl7 = {
		[273] = CFrame.new(40, 0, 0),
		[286] = CFrame.new(40, 0, 0),
		[246] = CFrame.new(0, -40, 0),
		[486] = CFrame.new(40, 0, 0),
		[364] = CFrame.new(40, 0, 0),
		[682] = CFrame.new(0, 0, -40),
		[490] = CFrame.new(0, 40, 0),
		[691] = CFrame.new(40, 0, 0),
		[502] = CFrame.new(-40, 0, 0),
		[256] = CFrame.new(-40, 0, 0),
		[290] = CFrame.new(0, 40, 0),
		[427] = CFrame.new(0, 40, 0),
		[692] = CFrame.new(0, 0, 40),
		[316] = CFrame.new(0, 40, 0),
		[481] = CFrame.new(0, 40, 0),
		[594] = CFrame.new(0, 40, 0),
		[649] = CFrame.new(40, 0, 0),
		[285] = CFrame.new(0, -40, 0),
		[250] = CFrame.new(0, 40, 0),
		[454] = CFrame.new(-40, 0, 0),
	}

	BuyGearDracoV4 = function()
		if string.find(CheckAcientOneDracoStatus(), "Can Buy Gear") then
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
		end
	end

	FullyDraco = function()
		if not Settings["Auto Turn On V4"] then
			v_8:SetStage(true)
		end

		if not Settings["Auto Choose Gears"] and getgenv().ToggleAutoChooseGears then
			getgenv().ToggleAutoChooseGears:SetStage(true)
		end

		if CheckAcientOneDracoStatus() == "Ready For Trial" then
			if getgenv().WaitingjoinTrial then
				wait(5)
				getgenv().WaitingjoinTrial = false
			end

			if localPlayer:DistanceFromCharacter(workspace._WorldOrigin.Locations["Trial of Flames"].Position) <= 3000 then
				if workspace.Map.DracoTrial.TrialDoor.DoorTouch:FindFirstChild("TouchInterest") then
					getgenv().DoneTrialDraco = true
					toTarget(workspace.Map.DracoTrial.TrialDoor.DoorTouch.CFrame)
					wait(2)
					return
				end

				if game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
					local v_11 = CheckModelTrialDraco()
					local v_12, v_13 = GetRelicChuaDat(v_11)
					local v_14, v_15 = GetRelicChuanbiDat(v_11)

					if v_14 then
						local v_16 = v_11["EndRelic" .. v_15:split("RelicModel")[2]]
						local proximityPrompt = v_16:FindFirstChildWhichIsA("ProximityPrompt", true)

						if localPlayer:DistanceFromCharacter(v_16.WorldPivot.Position) > 8 then
							toTarget(v_16.WorldPivot)
						else
							wait(2)
							fireproximityprompt(proximityPrompt)
							wait(2)
						end
					elseif v_12 then
						local v_16 = v_11["Relic" .. v_13:split("RelicModel")[2]]
						local proximityPrompt = v_16:FindFirstChildWhichIsA("ProximityPrompt", true)

						if localPlayer:DistanceFromCharacter(v_16.WorldPivot.Position) > 8 then
							toTarget(v_16.WorldPivot)
						else
							wait(2)
							fireproximityprompt(proximityPrompt)
							wait(2)
						end
					end
				else
					game.ReplicatedStorage.Remotes.DracoTrial:InvokeServer()
					wait(3)
				end
			else
				if getgenv().DoneTrialDraco then
					wait(5)
					getgenv().DoneTrialDraco = false
					return
				end

				if not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
					getgenv().RespawnVolcano = true
					getgenv().turnoffnoclipBoatt = true

					if not CheckItemInventory("Volcanic Magnet") and not Settings["Ignore Craft Volcanic Magnet Draco"] then
						if getgenv().dacoMagnet then
							local now = tick()

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									if not (tick() - now >= 5 or game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")) then
										continue
									end
								end

								break
							end

							getgenv().dacoMagnet = false
							return
						end

						if not CheckCountItem("Scrap Metal", 10) then
							local tbl8 = { "Jungle Pirate", "Musketeer Pirate" }
							local v_11 = DetectMob(tbl8)

							if not v_11 then
								if typeof(tbl8) == "table" then
									if #tbl8 <= #tbl4 then
										tbl4 = {}
										return
									end
									local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl8))

									if v_12 then
										table.insert(tbl4, DetectNameTablePart(tbl8))

										while true do
											wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
												if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl8) or not Settings["Fully Trial Draco"]) then
													continue
												end
											end

											break
										end

										wait(1)
									end
								end
							else
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_11)
										BringMob(v_11)
										UsedualFlock()
										ClickM1(v_11)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										if not (not IsMobAlive(v_11) or not Settings["Fully Trial Draco"]) then
											continue
										end
									end

									break
								end
							end

							return
						end

						if not CheckCountItem("Blaze Ember", 15) then
							local dragonHunter = DetectNpc("Dragon Hunter") or workspace.NPCs:FindFirstChild("Dragon Hunter") or game:GetService("ReplicatedStorage").NPCs:FindFirstChild("Dragon Hunter")

							if not getgenv().QuestHunterDragon then
								if localPlayer:DistanceFromCharacter(dragonHunter.HumanoidRootPart.Position) > 8 then
									toTarget(dragonHunter.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
								else
									local response = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "Check" } }))

									if not response or response and not response.Text then
										getgenv().QuestHunterDragon = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "RequestQuest" } })).Text
									else
										local text = response.Text
										getgenv().QuestHunterDragon = text
									end
								end
							else
								local v_11 = DetectEmberTemplate()

								if v_11 then
									Instance.new("IntValue", v_11).Name = "Ignored"

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_11.Part.CFrame)
											if not (not v_11 or not v_11.Parent) then
												continue
											end
										end

										break
									end

									return
								end

								if string.find(getgenv().QuestHunterDragon, "Hydra Enforcers") then
									local v_12 = DetectMob("Hydra Enforcer")

									if not v_12 then
										local v_13 = DetectPartSpawnMob("Hydra Enforcer", true)

										if v_13 then
											Instance.new("IntValue", v_13).Name = "Ignored"

											while true do
												wait()

												if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
													toTarget(v_13.CFrame * CFrame.new(0, 60, 0))
													if not ((v_13.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Hydra Enforcer") or not Settings["Fully Trial Draco"] or v_11) then
														continue
													end
												end

												break
											end

											wait(1)
										else
											DeleteIgnoredMobSpawn()
										end
									else
										while true do
											task.wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												sizepart(v_12)
												BringMob(v_12)
												UsedualFlock()
												ClickM1(v_12)

												if Settings["Select Weapon"] == "Blox Fruit" then
													toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
												else
													toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
												end

												if not (not IsMobAlive(v_12) or not Settings["Fully Trial Draco"] or v_11) then
													continue
												end
											end

											break
										end
									end
								elseif string.find(getgenv().QuestHunterDragon, "Venomous Assailants") then
									local v_12 = DetectMob("Venomous Assailant")

									if not v_12 then
										local v_13 = DetectPartSpawnMob("Venomous Assailant", true)

										if v_13 then
											Instance.new("IntValue", v_13).Name = "Ignored"

											while true do
												wait()

												if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
													toTarget(v_13.CFrame * CFrame.new(0, 60, 0))
													if not ((v_13.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Venomous Assailant") or not Settings["Fully Trial Draco"] or v_11) then
														continue
													end
												end

												break
											end

											wait(1)
										else
											DeleteIgnoredMobSpawn()
										end
									else
										while true do
											task.wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												sizepart(v_12)
												BringMob(v_12)
												UsedualFlock()
												ClickM1(v_12)

												if Settings["Select Weapon"] == "Blox Fruit" then
													toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
												else
													toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
												end

												if not (not IsMobAlive(v_12) or not Settings["Fully Trial Draco"] or v_11) then
													continue
												end
											end

											break
										end
									end
								elseif string.find(getgenv().QuestHunterDragon, "trees") then
									local currentCamera = workspace.CurrentCamera
									local v_12 = DetectTree()

									if v_12 then
										Instance.new("IntValue", v_12).Name = "Ignored"
										local now = tick()

										while true do
											wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												local position = v_12.WorldPivot.Position

												if localPlayer:DistanceFromCharacter(position) < 50 then
													AutoAllSkill()
												end

												if v_12:FindFirstChild("Meshes/plant1_Icosphere", true) then
													toTarget(v_12.WorldPivot)
													local worldPivot = v_12.WorldPivot
													getgenv().AimPos = worldPivot
													v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position)
													v_5.Target = v_12
												else
													local position2 = (v_12.WorldPivot * CFrame.new(5, -20, 0)).Position
													local position3 = (v_12.WorldPivot * CFrame.new(0, -20, 0)).Position
													toTarget(CFrame.new(position2))
													getgenv().AimPos = CFrame.new(position3)
													v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position3)
													v_5.Target = v_12
												end

												if not (not v_12 or not v_12.Parent or not Settings["Fully Trial Draco"] or v_11 or v_12:GetAttribute("AlreadyDestroyedClient") or tick() - now >= 15) then
													continue
												end
											end

											break
										end
									end
								end
							end

							return
						end

						if CheckCountItem("Scrap Metal", 10) and CheckCountItem("Blaze Ember", 15) then
							game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", "Volcanic Magnet", 1, {} }))
							wait(2)
						end
					else
						getgenv().dacoMagnet = true

						if not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
							local v_11 = checkboat()

							if not v_11 or v_11 and localPlayer:DistanceFromCharacter(v_11.VehicleSeat.Position) >= 4000 then
								local cframe = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

								if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
									if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
										if not localPlayer:GetAttribute("CurrentLocation") or localPlayer:GetAttribute("CurrentLocation") ~= "Tiki Outpost" then
											if game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki" or game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki2" then
												localPlayer.Character.Humanoid.Health = 0
												return
											end
										end
									end

									toTarget(cframe)
								else
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
									wait(3)
								end
							elseif localPlayer.Character.Humanoid.Sit then
								task.spawn(function()
									NoclipBoat(v_11)
								end)

								manageTween(v_11.VehicleSeat, CFrame.new(-118834.515625, v_11.WorldPivot.Y, -78.950584411621094) * CFrame.new(0, 0, 99999999), 350, "TweenBoat")
							else
								if getgenv().TweenBoat then
									getgenv().TweenBoat:Pause()
									getgenv().TweenBoat:Cancel()
								end

								toTarget(v_11.VehicleSeat.CFrame)
							end
						end
					end
				else
					if getgenv().turnoffnoclipBoatt then
						getgenv().turnoffnoclipBoatt = false
						local v_11 = checkboat()

						if v_11 then
							TurnOffNoclipBoat(v_11)
						end
					end

					if getgenv().RespawnVolcano and Settings["Webhook Find Prehistoric Island"] then
						getgenv().RespawnVolcano = false

						if WebhookFindVolcano then
							WebhookFindVolcano()
						end
					end

					if getgenv().TweenBoat then
						getgenv().TweenBoat:Pause()
						getgenv().TweenBoat:Cancel()
					end

					if not localPlayer:GetAttribute("CurrentLocation") or localPlayer:GetAttribute("CurrentLocation") ~= "Prehistoric Island" then
						local v_11 = DetectNpc("Fossil Expert")
						if not v_11 or not v_11:FindFirstChild("HumanoidRootPart") then
							return
						end

						if v_11 then
							toTarget(v_11.HumanoidRootPart.CFrame)
							return
						end
					end

					if workspace.Map.PrehistoricIsland:FindFirstChild("TrialRock", true).Transparency == 1 then
						getgenv().WaitingjoinTrial = true
						toTarget(workspace.Map.PrehistoricIsland.TrialTeleport.CFrame)
						return
					end

					if DetectLava() then
						local v_11 = next
						local descendants, v_12 = workspace.Map.PrehistoricIsland:GetDescendants()

						for _, v_13 in v_11, descendants, v_12 do
							if v_13.Name == "TouchInterest" and v_13.Parent.Name ~= "TrialTeleport" then
								v_13:Destroy()
							end
						end
					end

					if #workspace.Map.PrehistoricIsland.Core.InteriorLava:GetChildren() > 0 then
						DeleteLava()
					end

					if not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
						if workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") and workspace.Map.PrehistoricIsland.Core.ActivationPrompt:FindFirstChild("ProximityPrompt") then
							toTarget(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame)

							if localPlayer:DistanceFromCharacter(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.Position) < 8 then
								fireproximityprompt(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.ProximityPrompt, 1)
								wait(3)
							end

							return
						end

						if not workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") and not workspace.Map.PrehistoricIsland.Core:FindFirstChild("FossilExpertSpawn") then
							local v_11 = DetectNpc("Fossil Expert")
							if not v_11 or not v_11:FindFirstChild("HumanoidRootPart") then
								return
							end

							if v_11 then
								toTarget(v_11.HumanoidRootPart.CFrame)
								return
							end
						end
					else
						if flag2 then
							local skull = workspace.Map.PrehistoricIsland.Core.PrehistoricRelic.Skull

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(skull.Position, skull.CFrame)
									if not (localPlayer:DistanceFromCharacter(skull.Position) <= 200 or DetectGolem() or DetectRockVolcano()) then
										continue
									end
								end

								break
							end

							flag2 = false
							return
						end

						local v_11 = DetectGolem()

						if v_11 then
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(0, 20, 7))

									if Settings["Select Method Kill Golem"] == "Instant Kill [ Risk and can bug no die mob ]" then
										if localPlayer:DistanceFromCharacter(v_11.HumanoidRootPart.Position) < 50 then
											KillRaidEnemy()
										end
									else
										equiptool(NameWeapon(Settings["Select Weapon Kill Golem"] or "Melee"))
										getgenv().ClickM1Volcano(v_11)
									end

									if not getgenv().KillMobRaid and Settings["Kill Aura Only Raid And Volcano"] then
										getgenv().KillMobRaid = true
										local timeDelayKill = Settings["Time Delay Kill"] or 5
										v_11.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)

										delay(timeDelayKill, function()
											getgenv().KillMobRaid = false
										end)
									end

									if not (not IsMobAlive(v_11) or not Settings["Fully Trial Draco"] or not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible) then
										continue
									end
								end

								break
							end
						end

						local v_12 = DetectRockVolcano()

						if v_12 then
							if Settings["Fix Volcano Safe"] then
								local v_13 = DetectPositionVolcano()
								local v_14, v_15 = CheckPosnearRock(v_13, localPlayer.Character.HumanoidRootPart)
								local distanceFromCharacter = localPlayer.DistanceFromCharacter
								local v_16 = CheckPosnearRock(v_13, v_12.WorldPivot)

								if distanceFromCharacter(localPlayer, v_16) >= 400 then
									n4 = v_15 + 1

									if v_15 >= 7 then
										n4 = 1
									end

									toTarget(CFrame.new(v_13[n4]))
								else
									local v_17 = tbl7[math.floor(v_12.WorldPivot.Position.Y)]

									while true do
										task.wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											if localPlayer:DistanceFromCharacter((v_12.WorldPivot * v_17).Position) > 8 then
												toTarget(v_12.WorldPivot * v_17)
											end

											if localPlayer:DistanceFromCharacter(v_12.WorldPivot.Position) < 100 then
												AutoUseSkillFixLava()
											end

											local worldPivot = v_12.WorldPivot
											getgenv().AimPos = worldPivot
											v_5.Hit = v_12.WorldPivot
											v_5.Target = v_12
											if not (not v_12 or not v_12.Parent or not Settings["Fully Trial Draco"] or not v_12.VFXLayer.Specs.Enabled or DetectGolem() or not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible) then
												continue
											end
										end

										break
									end

									if not DetectGolem() then
										flag2 = true
									end

									wait(1)
								end
							else
								local v_13 = tbl7[math.floor(v_12.WorldPivot.Position.Y)]

								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										if localPlayer:DistanceFromCharacter((v_12.WorldPivot * v_13).Position) > 8 then
											toTarget(v_12.WorldPivot * v_13)
										end

										if localPlayer:DistanceFromCharacter(v_12.WorldPivot.Position) < 100 then
											AutoUseSkillFixLava()
										end

										local worldPivot = v_12.WorldPivot
										getgenv().AimPos = worldPivot
										v_5.Hit = v_12.WorldPivot
										v_5.Target = v_12
										if not (not v_12 or not v_12.Parent or not Settings["Fully Trial Draco"] or not v_12.VFXLayer.Specs.Enabled or DetectGolem() or not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible) then
											continue
										end
									end

									break
								end

								if not DetectGolem() then
									flag2 = true
								end
							end
						end
					end
				end
			end
		elseif string.find(CheckAcientOneDracoStatus(), "Can Buy Gear") then
			BuyGearDracoV4()
		else
			local v_11 = DetectMob(tbl5)

			if v_11 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(v_11)
						BringMob(v_11)
						UsedualFlock()
						ClickM1(v_11)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						if not (not IsMobAlive(v_11) or not Settings["Fully Trial Draco"]) then
							continue
						end
					end

					break
				end
			elseif typeof(tbl5) == "table" then
				if #tbl5 <= #tbl4 then
					tbl4 = {}
					return
				end
				local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl5))

				if v_12 then
					table.insert(tbl4, DetectNameTablePart(tbl5))

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
							if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Fully Trial Draco"]) then
								continue
							end
						end

						break
					end

					wait(1)
				end
			else
				local v_12 = DetectPartSpawnMob(tbl5, true)

				if v_12 then
					Instance.new("IntValue", v_12).Name = "Ignored"

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
							if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Fully Trial Draco"]) then
								continue
							end
						end

						break
					end

					wait(1)
				else
					DeleteIgnoredMobSpawn()
				end
			end
		end
	end

	RaceDracoSection.CreateToggle({
		Title = "Fully Trial Draco",
		Desc = "Auto Craft and Auto Find and Auto Attack and Fix\n Auto Trial and auto Train Race and Buy Gear and Choose Gear",
		Default = Settings["Fully Trial Draco"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Fully Trial Draco"] and task.wait(0.1) do
					local ok, result = pcall(function()
						FullyDraco()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Fully Trial Draco", arg)
	end)

	RaceDracoSection.CreateToggle({
		Title = "Ignore Craft Volcanic Magnet [ Fully Draco ]",
		Desc = nil,
		Default = Settings["Ignore Craft Volcanic Magnet Draco"] or false,
	}, function(arg)
		SaveSettings("Ignore Craft Volcanic Magnet Draco", arg)
	end)

	RaceDracoSection.CreateToggle({
		Title = "Auto Buy Gear Draco",
		Desc = nil,
		Default = Settings["Auto Buy Gear Draco"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Buy Gear Draco"] and wait(0.3) do
					pcall(function()
						BuyGearDracoV4()
					end)
				end
			end)
		end

		SaveSettings("Auto Buy Gear Draco", arg)
	end)

	RaceDracoSection.CreateToggle({
		Title = "Auto Finish Train Draco Quest",
		Desc = nil,
		Default = Settings["Auto Finish Train Draco Quest"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Finish Train Draco Quest"] and wait(0.1) do
					pcall(function()
						if string.find(CheckAcientOneDracoStatus(), "Can Buy Gear") then
							BuyGearDracoV4()
						else
							local v_11 = DetectMob(tbl5)

							if v_11 then
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_11)
										BringMob(v_11)
										UsedualFlock()
										ClickM1(v_11)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										if not (not IsMobAlive(v_11) or not Settings["Auto Finish Train Draco Quest"]) then
											continue
										end
									end

									break
								end
							elseif typeof(tbl5) == "table" then
								if #tbl5 <= #tbl4 then
									tbl4 = {}
									return
								end
								local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl5))

								if v_12 then
									table.insert(tbl4, DetectNameTablePart(tbl5))

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
											if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto Finish Train Draco Quest"]) then
												continue
											end
										end

										break
									end

									wait(1)
								end
							else
								local v_12 = DetectPartSpawnMob(tbl5, true)

								if v_12 then
									Instance.new("IntValue", v_12).Name = "Ignored"

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
											if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto Finish Train Draco Quest"]) then
												continue
											end
										end

										break
									end

									wait(1)
								else
									DeleteIgnoredMobSpawn()
								end
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Finish Train Draco Quest", arg)
	end)

	RaceNormalSection = RaceMain.CreateSection("Race Normal")

	AutoMinkV2 = function()
		local v_11 = GetNearestChest()

		if v_11 then
			local now = nil

			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v_11.Position).Magnitude <= 5 then
						if not now then
							now = tick()
						elseif tick() - now >= 5 then
							Instance.new("IntValue", v_11).Name = "Ignored"
							wait(0.5)
						end

						game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
						wait()
						game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
						TweenManager.CancelCurrent()
					end

					toTarget(v_11.CFrame, true)
					if not (not v_11 or not v_11.Parent or not Settings["Auto Upgrade Race V2-V3"] or v_11:GetAttribute("IsDisabled") or v_11:FindFirstChild("Ignored") or not v_11:FindFirstChild("TouchInterest")) then
						continue
					end
				end

				break
			end
		else
			local v_12 = PathFindChest()

			if v_12 then
				toTarget(v_12.Part.CFrame)

				if (v_12.Part.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or GetNearestChest() then
					Instance.new("IntValue", v_12).Name = "Ignored"
				end
			else
				for _, child in pairs(game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()) do
					if child:FindFirstChild("Ignored") then
						child:FindFirstChild("Ignored"):Destroy()
					end
				end
			end
		end
	end

	DetectSeabeast = function()
		local v_11 = next
		local children, v_12 = game:GetService("Workspace").SeaBeasts:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13.Name == "SeaBeast1" then
				local text = v_13.HealthBBG.Frame.TextLabel.Text
				local text2 = v_13.HealthBBG.Frame.TextLabel.Text
				local v_14 = tonumber
				local str

				if string.find(text:gsub("/%d+,%d+", ""), ",") then
					str = text2:gsub("%d+,%d+/", "")
				else
					str = text2:gsub("%d+/", "")
				end

				local str2 = str:gsub(",", "")
				if v_14(str2) >= 90000 then
					return v_13
				end
			end
		end

		return false
	end

	AutoFishV2 = function()
		local v_11 = DetectSeabeast()
		local v_12 = checkboat()

		if not v_11 then
			if not v_12 then
				local cframe = CFrame.new(-11.948337554931641, 10.293913841247559, 2957.010498046875)

				if (cframe.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
					toTarget(cframe)
				else
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
				end
			else
				local cframe = CFrame.new(753.06536865234375, v_12.WorldPivot.Y, 6994.5146484375)

				if (v_12.VehicleSeat.Position - cframe.Position).Magnitude > 50 then
					v_12.VehicleSeat.CFrame = cframe
				elseif not localPlayer.Character.Humanoid.Sit then
					toTarget(v_12.VehicleSeat.CFrame)
				end
			end
		else
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					TeleportSeaEvents(v_11)
					local humanoidRootPart2 = v_11:FindFirstChild("HumanoidRootPart")
					getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)

					if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
						AutoAllSkill()
					end

					if not (not v_11 or not v_11.Parent or v_11.Health.Value <= 0 or not Settings["Auto Upgrade Race V2-V3"]) then
						continue
					end
				end

				break
			end
		end
	end

	CheckRace = function()
		local response = nil
		local response2 = nil

		pcall(function()
			response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
			response2 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
		end)

		local localPlayer2 = game.Players.LocalPlayer
		localPlayer2 = localPlayer2 and localPlayer2.Character
		if localPlayer2 and localPlayer2:FindFirstChild("RaceTransformed") then
			return " V4"
		end

		if response == -2 then
			return " V3"
		end

		if response2 == -2 then
			return " V2"
		end
		return " V1"
	end

	getgenv().Chests = {}
	getgenv().BlBossHuman = {}
	local tbl8 = {}
	local tbl9 = {}

	DetectPlayerAngel = function()
		local v_11 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_11(Players2:GetChildren()) do
			if child.Name ~= localPlayer.Name and game:GetService("Workspace").Characters:FindFirstChild(child.Name) and child.Data.Race.Value == "Skypiea" and not table.find(tbl8, child.Name) and child.Character:FindFirstChild("Humanoid") and child.Character.Humanoid.Health > 0 then
				return child
			end
		end
	end

	DetectPlayerGhoul = function()
		local v_11 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_11(Players2:GetChildren()) do
			if child.Name ~= localPlayer.Name and game:GetService("Workspace").Characters:FindFirstChild(child.Name) and not table.find(tbl9, child.Name) and child.Character:FindFirstChild("Humanoid") and child.Character.Humanoid.Health > 0 then
				return child
			end
		end
	end

	CheckSafezone = function(arg)
		for _, child in pairs(game:GetService("Workspace")._WorldOrigin.SafeZones:GetChildren()) do
			if child:IsA("Part") then
				if (child.Position - arg.HumanoidRootPart.Position).magnitude <= 400 and arg.Humanoid.Health / arg.Humanoid.MaxHealth >= 0.9 then
					return true
				end
			end
		end

		return false
	end

	CheckPlayercantAttack = function(arg)
		for _, descendant in pairs(game.Players.LocalPlayer.PlayerGui.Notifications:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				if string.find(descendant.Text, "attack") and not descendant:FindFirstChild(arg.Name) then
					local textBox = Instance.new("TextBox")
					textBox.Parent = descendant.Parent
					textBox.Name = arg.Name
					descendant:Destroy()
					return true
				end
			end
		end
	end

	UpgradeRaceV2AndV3 = function()
		local v_11 = CheckRace()

		if v_11 == " V3" then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done V3", ShowTime = 5 })
			wait(5)
			return
		end

		if game.PlaceId ~= getgenv().CheckPlaceId2 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "TravelDressrosa" }))
			return
		end

		if v_11 == " V1" then
			if localPlayer.Data.Beli.Value < 500000 then
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Beli >= 500k", ShowTime = 5 })
				wait(5)
				return
			end

			if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "2")
			elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
				if not DetectItemPlr("Flower 1") then
					toTarget(game:GetService("Workspace").Flower1.CFrame)
				elseif not DetectItemPlr("Flower 2") then
					toTarget(game:GetService("Workspace").Flower2.CFrame)
				elseif not DetectItemPlr("Flower 3") then
					local v_12 = DetectMob("Swan Pirate")

					if not v_12 then
						if typeof("Swan Pirate") == "table" then
							if #tbl4 >= 11 then
								tbl4 = {}
								return
							end
							local v_13 = DetectPartSpawnMob(DetectNameTablePart("Swan Pirate"))

							if v_13 then
								table.insert(tbl4, DetectNameTablePart("Swan Pirate"))

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_13.CFrame * CFrame.new(0, 60, 0))
										if not ((v_13.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Swan Pirate") or not Settings["Auto Upgrade Race V2-V3"]) then
											continue
										end
									end

									break
								end

								wait(1)
							end
						else
							local v_13 = DetectPartSpawnMob("Swan Pirate", true)

							if v_13 then
								Instance.new("IntValue", v_13).Name = "Ignored"

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_13.CFrame * CFrame.new(0, 60, 0))
										if not ((v_13.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Swan Pirate") or not Settings["Auto Upgrade Race V2-V3"]) then
											continue
										end
									end

									break
								end

								wait(1)
							else
								DeleteIgnoredMobSpawn()
							end
						end
					else
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_12)
								BringMob(v_12)
								UsedualFlock()
								ClickM1(v_12)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								if not (not IsMobAlive(v_12) or not Settings["Auto Upgrade Race V2-V3"]) then
									continue
								end
							end

							break
						end
					end
				end
			elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
				local position = localPlayer.Character.HumanoidRootPart.Position

				if (CFrame.new(-2777.6001, 72.9661407, -3571.42285).Position - position).Magnitude < 8 then
					toTarget(CFrame.new(-2777.6001, 72.9661407, -3571.42285))
				else
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Alchemist", "3")
				end
			else
				AutoQuestBarito()
			end
		else
			local response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
			if response == 0 then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
				return
			end

			if response == 2 then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
				return
			end

			if response == -1 then
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Beli >= 2m", ShowTime = 5 })
				wait(5)
				return
			end

			local str = game:GetService("Players").LocalPlayer.Data.Race.Value .. v_11

			if str == "Human V2" then
				local Jeremy = not table.find(BlBossHuman, "Jeremy") and CheckNameBoss("Jeremy") or not table.find(BlBossHuman, "Orbitus") and CheckNameBoss("Orbitus") or not table.find(BlBossHuman, "Diamond") and CheckNameBoss("Diamond")

				if Jeremy then
					local v_12 = CheckNameBoss(Jeremy.Name)

					if v_12 then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_12)
								UsedualFlock()
								ClickM1(v_12)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								if IsMobAlive(v_12) then
									continue
								end
							end

							break
						end

						if not table.find(BlBossHuman, Jeremy.Name) then
							table.insert(BlBossHuman, Jeremy.Name)
						end
					end
				else
					lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Waiting Boss Spawn", ShowTime = 5 })
					wait(5)
				end
			elseif str == "Mink V2" then
				AutoMinkV2()
			elseif str == "Cyborg V2" then
				if not CheckFruitplr() then
					if TakeFruitInventory(true) then
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", TakeFruitInventory(true))
					end
				end
			elseif str == "Fishman V2" then
				AutoFishV2()
			elseif str == "Skypiea V2" then
				local v_12 = DetectPlayerAngel()

				if v_12 then
					table.insert(tbl8, v_12.Name)
					local now = tick()

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							spawn(function()
								if game:GetService("Players").LocalPlayer.PlayerGui.Main.BottomHUDList.PvpDisabled.Visible then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
								end
							end)

							spawn(function()
								getgenv().AimPos = CFrame.new(v_12.Character.HumanoidRootPart.CFrame.p, v_12.Character.HumanoidRootPart.Position + v_12.Character.HumanoidRootPart.Velocity / 1.2)

								if localPlayer:DistanceFromCharacter(v_12.Character.HumanoidRootPart.Position) < 50 then
									localPlayer.Character.HumanoidRootPart.CFrame = v_12.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
								else
									toTarget(v_12.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
								end
							end)

							spawn(function()
								if localPlayer:DistanceFromCharacter(v_12.Character.HumanoidRootPart.Position) < 50 then
									AutoAllSkill(true)
								end
							end)

							if not (tick() - now >= 70 or not v_12.Character or not v_12.Character.Parent or v_12.Character.Humanoid.Health == 0 or CheckSafezone(v_12.Character) or CheckPlayercantAttack(v_12.Character) or not Settings["Auto Upgrade Race V2-V3"]) then
								continue
							end
						end

						break
					end
				else
					HopServer()
					wait(5)
				end
			elseif str == "Ghoul V2" then
				local v_12 = DetectPlayerGhoul()

				if v_12 then
					table.insert(tbl9, v_12.Name)
					local now = tick()

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							spawn(function()
								if game:GetService("Players").LocalPlayer.PlayerGui.Main.BottomHUDList.PvpDisabled.Visible then
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
								end
							end)

							spawn(function()
								getgenv().AimPos = CFrame.new(v_12.Character.HumanoidRootPart.CFrame.p, v_12.Character.HumanoidRootPart.Position + v_12.Character.HumanoidRootPart.Velocity / 1.2)

								if localPlayer:DistanceFromCharacter(v_12.Character.HumanoidRootPart.Position) < 50 then
									localPlayer.Character.HumanoidRootPart.CFrame = v_12.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
								else
									toTarget(v_12.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
								end
							end)

							spawn(function()
								if localPlayer:DistanceFromCharacter(v_12.Character.HumanoidRootPart.Position) < 50 then
									AutoAllSkill(true)
								end
							end)

							if not (tick() - now >= 70 or not v_12.Character or not v_12.Character.Parent or v_12.Character.Humanoid.Health == 0 or CheckSafezone(v_12.Character) or CheckPlayercantAttack(v_12.Character) or not Settings["Auto Upgrade Race V2-V3"]) then
								continue
							end
						end

						break
					end
				else
					HopServer()
					wait(5)
				end
			end
		end
	end

	RaceNormalSection.CreateToggle({
		Title = "Auto Upgrade Race V2-V3",
		Desc = nil,
		Default = Settings["Auto Upgrade Race V2-V3"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Upgrade Race V2-V3"] and wait(0.1) do
					local ok, result = pcall(function()
						UpgradeRaceV2AndV3()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Upgrade Race V2-V3", arg)
	end)

	BuyChipLaw = function()
		v354 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
		if v354 == 1 then
			return true
		end

		if v354 == 0 then
			return false
		end

		if v354 == 2 then
			return true
		end
	end

	local n5 = 0
	local flag3 = false
	local flag4 = false
	local cframe = CFrame.new(-5570.052734375, 332.41363525391, -5965.91015625)

	if not getgenv().CyborgCommEHooked then
		getgenv().CyborgCommEHooked = true

		pcall(function()
			game:GetService("ReplicatedStorage").Remotes.CommE.OnClientEvent:Connect(function(arg, ...)
				if arg == "Notify" then
					local str = tostring(...)
					local v_11 = string.lower(str)

					if string.find(v_11, "supply") or string.find(v_11, "microchip") or string.find(v_11, "order") then
						flag3 = true
						flag4 = true
					end
				end
			end)
		end)
	end

	DetectkeyCyborg = function(arg)
		local v_11 = string.lower(arg)
		local notifications = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("Notifications")

		if notifications then
			for _, child in pairs(notifications:GetChildren()) do
				if child.Name == "NotificationTemplate" and child:FindFirstChild("TranslateMe") then
					if string.find(string.lower(child.TranslateMe.Text), v_11, 1, true) then
						return true
					end
				end
			end
		end

		return false
	end

	ToggleAutoGetFullyCyborg = RaceNormalSection.CreateToggle({
		Title = "Auto Get Fully Cyborg",
		Desc = nil,
		Default = Settings["Auto Get Fully Cyborg"] or false,
	}, function(arg)
		SaveSettings("Auto Get Fully Cyborg", arg)

		if arg and not Settings["Auto Get Cyborg"] then
			if ToggleAutoGetCyborg and ToggleAutoGetCyborg.SetStage then
				ToggleAutoGetCyborg:SetStage(true)
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Turn On Auto Get Cyborg plz", ShowTime = 5 })
			end
		end
	end)

	RaceNormalSection.CreateToggle({
		Title = "Auto Get Cyborg Hop Collect Chest",
		Desc = nil,
		Default = Settings["Auto Get Cyborg Hop Collect Chest"] or false,
	}, function(arg)
		SaveSettings("Auto Get Cyborg Hop Collect Chest", arg)
	end)

	GetCyborg = function()
		local response = nil

		pcall(function()
			response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Check")
		end)

		if response == 2 then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "You already have Cyborg Race! Plz Turn Off", ShowTime = 5 })
			wait(5)
			return
		end

		if game.PlaceId ~= getgenv().CheckPlaceId2 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "TravelDressrosa" }))
			return
		end

		if response == 1 or response == true then
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
			return
		end
		local main = game:GetService("Workspace").Map.CircleIsland.RaidSummon.Button.Main

		if main and not main.CanCollide then
			pcall(function()
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
			end)

			return
		end

		if DetectItemPlr("Core Brain") or DetectItemPlr("Microchip") or CheckNameBoss("Order") then
			flag3 = true
			flag4 = true
		end

		if not flag3 then
			local ok, result = pcall(function()
				return game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckBlockPart")
			end)

			if ok and result then
				flag3 = true
				flag4 = true
			end
		end

		if not Settings["Auto Get Fully Cyborg"] then
			flag3 = true
			flag4 = true
		end

		if not flag4 and not flag3 then
			if localPlayer:DistanceFromCharacter(cframe.Position) > 20 then
				toTarget(cframe)
				return
			end

			pcall(function()
				fireclickdetector(main.ClickDetector)
			end)

			wait(1)

			local ok, result = pcall(function()
				return game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckBlockPart")
			end)

			if ok and result or DetectkeyCyborg("Microchip not found") or DetectkeyCyborg("supply") then
				flag3 = true
				flag4 = true
			else
				flag4 = true
			end
		end

		if flag3 and Settings["Auto Get Fully Cyborg"] then
			if ToggleAutoGetFullyCyborg and ToggleAutoGetFullyCyborg.SetStage then
				ToggleAutoGetFullyCyborg:SetStage(false)
			end

			SaveSettings("Auto Get Fully Cyborg", false)
		end

		if Settings["Auto Get Fully Cyborg"] and not CheckNameBoss("Order") and not flag3 then
			if not DetectItemPlr("Fist of Darkness") then
				if n5 >= 20 and Settings["Auto Get Cyborg Hop Collect Chest"] then
					if not getgenv().DelayHop then
						task.delay(5, function()
							getgenv().DelayHop = true

							spawn(function()
								HopLessAll()
							end)

							spawn(function()
								HopServer()
							end)

							getgenv().DelayHop = false
						end)
					end

					return
				end

				local v_11 = GetNearestChest()

				if v_11 then
					n5 += 1
					local now = nil

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v_11.Position).Magnitude <= 5 then
								if not now then
									now = tick()
								elseif tick() - now >= 5 then
									Instance.new("IntValue", v_11).Name = "Ignored"
									wait(0.5)
								end

								game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
								wait()
								game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
								TweenManager.CancelCurrent()
							end

							toTarget(v_11.CFrame, true)
							if not (not v_11 or not v_11.Parent or not Settings["Auto Get Cyborg"] or v_11:GetAttribute("IsDisabled") or v_11:FindFirstChild("Ignored") or not v_11:FindFirstChild("TouchInterest")) then
								continue
							end
						end

						break
					end
				else
					local v_12 = PathFindChest()

					if v_12 then
						toTarget(v_12.Part.CFrame)

						if (v_12.Part.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or GetNearestChest() then
							Instance.new("IntValue", v_12).Name = "Ignored"
						end
					else
						print("delete")

						for _, child in pairs(game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()) do
							if child:FindFirstChild("Ignored") then
								child:FindFirstChild("Ignored"):Destroy()
							end
						end
					end
				end

				return
			end

			if localPlayer:DistanceFromCharacter(cframe.Position) > 15 then
				toTarget(cframe)
				return
			end
			equiptool("Fist of Darkness")
			task.wait(0.3)
			fireclickdetector(main.ClickDetector)
			task.wait(1)

			if not DetectItemPlr("Fist of Darkness") then
				flag3 = true
				flag4 = true

				if ToggleAutoGetFullyCyborg and ToggleAutoGetFullyCyborg.SetStage then
					ToggleAutoGetFullyCyborg:SetStage(false)
				end

				SaveSettings("Auto Get Fully Cyborg", false)
			end

			return
		end

		if flag3 then
			if DetectItemPlr("Core Brain") then
				if localPlayer:DistanceFromCharacter(cframe.Position) > 15 then
					toTarget(cframe)
					return
				end
				equiptool("Core Brain")
				task.wait(0.3)
				fireclickdetector(main.ClickDetector)
				task.wait(1)

				pcall(function()
					game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CyborgTrainer", "Buy")
				end)

				return
			end

			local Order = CheckNameBoss("Order")

			if Order then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(Order)
						UsedualFlock()
						ClickM1(Order)

						if IsMobAlive(Order) then
							local humanoidRootPart2 = Order:FindFirstChild("HumanoidRootPart")

							if humanoidRootPart2 then
								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
								end

								if not (not IsMobAlive(Order) or not Settings["Auto Get Cyborg"]) then
									continue
								end
							end
						end
					end

					break
				end
			elseif not DetectItemPlr("Microchip") then
				if game.Players.LocalPlayer.Data.Fragments.Value >= 1000 then
					BuyChipLaw()
					wait(2)
				else
					lib.CreateNoti({
						Title = "Banana Cat Hub",
						Desc = "Not enough 1000 Fragments to buy Microchip!",
						ShowTime = 5,
					})

					wait(5)
				end
			elseif DetectItemPlr("Microchip") then
				if localPlayer:DistanceFromCharacter(cframe.Position) > 15 then
					toTarget(cframe)
					return
				end
				equiptool("Microchip")
				task.wait(0.3)
				fireclickdetector(main.ClickDetector)
				task.wait(1)
			end
		end
	end

	ToggleAutoGetCyborg = RaceNormalSection.CreateToggle({ Title = "Auto Get Cyborg", Desc = nil, Default = Settings["Auto Get Cyborg"] or false }, function(arg)
		if arg then
			flag4 = false
			flag3 = false

			spawn(function()
				while Settings["Auto Get Cyborg"] and wait(0.1) do
					local ok, result = pcall(function()
						GetCyborg()
					end)

					if not ok and result then
						print(result)
					end
				end
			end)
		else
			flag4 = false
			flag3 = false
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end

		SaveSettings("Auto Get Cyborg", arg)
	end)

	GetRaceGhoul = function()
		if game.PlaceId ~= getgenv().CheckPlaceId2 then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "TravelDressrosa" }))
			return
		end

		if game:GetService("Players").LocalPlayer.Data.Race.Value == "Ghoul" or game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm", "BuyCheck", 4, true) == 2 or game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm", "Change", 4, true) == 1 then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Plz Turn Off", ShowTime = 5 })
			wait(5)
			return
		end

		if not CheckCountItem("Ectoplasm", 100) then
			local tbl10 = { "Ship Deckhand", "Ship Steward", "Ship Officer", "Ship Engineer" }
			local v_11 = DetectMob(tbl10)

			if v_11 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(v_11)
						BringMob(v_11)
						UsedualFlock()
						ClickM1(v_11)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						if not (not IsMobAlive(v_11) or not Settings["Auto Get Ghoul"]) then
							continue
						end
					end

					break
				end
			elseif typeof(tbl10) == "table" then
				if #tbl4 >= #tbl10 then
					tbl4 = {}
					return
				end
				local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl10))

				if v_12 then
					table.insert(tbl4, DetectNameTablePart(tbl10))

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
							if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl10) or not Settings["Auto Get Ghoul"]) then
								continue
							end
						end

						break
					end

					wait(1)
				end
			else
				local v_12 = DetectPartSpawnMob(tbl10, true)

				if v_12 then
					Instance.new("IntValue", v_12).Name = "Ignored"

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
							if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl10) or not Settings["Auto Get Ghoul"]) then
								continue
							end
						end

						break
					end

					wait(1)
				else
					DeleteIgnoredMobSpawn()
				end
			end

			return
		end

		if DetectItemPlr("Hellfire Torch") then
			local position = localPlayer.Character.HumanoidRootPart.Position

			if (CFrame.new(918.615234, 122.202454, 33454.3789, -0.999998808, 0, 0.00172644004, 0, 1, 0, -0.00172644004, 0, -0.999998808).Position - position).Magnitude <= 8 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "Ectoplasm", "BuyCheck", 4 }))
				v352 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 4)
			else
				toTarget(CFrame.new(918.615234, 122.202454, 33454.3789, -0.999998808, 0, 0.00172644004, 0, 1, 0, -0.00172644004, 0, -0.999998808))
			end
		else
			local v_11 = CheckNameBoss("Cursed Captain")

			if v_11 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(v_11)
						UsedualFlock()
						ClickM1(v_11)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						if not (not IsMobAlive(v_11) or not Settings["Auto Get Ghoul"]) then
							continue
						end
					end

					break
				end

				wait(5)
			else
				if Settings["Hop Server Get Ghoul"] then
					SpecialHop("Cursed Captain")
				end

				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Wating Boss Spawn", ShowTime = 5 })
				wait(5)
			end
		end
	end

	RaceNormalSection.CreateToggle({
		Title = "Hop Server Find Boss Cursed Captain",
		Desc = nil,
		Default = Settings["Hop Server Get Ghoul"] or false,
	}, function(arg)
		SaveSettings("Hop Server Get Ghoul", arg)
	end)

	RaceNormalSection.CreateToggle({ Title = "Auto Get Ghoul", Desc = nil, Default = Settings["Auto Get Ghoul"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Get Ghoul"] and wait(0.1) do
					local ok, result = pcall(function()
						GetRaceGhoul()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Get Ghoul", arg)
	end)

	RaceV4Section = RaceMain.CreateSection("Race V4")

	RaceV4Section.CreateToggle({ Title = "No Frog", Desc = nil, Default = Settings["No Frog"] or false }, function(arg)
		if arg then
			local lighting = game.Lighting
			lighting.FogEnd = 100000

			for _, descendant in pairs(lighting:GetDescendants()) do
				if descendant:IsA("Atmosphere") then
					descendant:Destroy()
				end
			end
		end

		SaveSettings("No Frog", arg)
	end)

	RaceV4Section.CreateToggle({
		Title = "Teleport Acient Clock",
		Desc = nil,
		Default = Settings["Teleport Acient Clock"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Teleport Acient Clock"] and wait() do
					local prompt = game:GetService("Workspace").Map["Temple of Time"]:FindFirstChild("Prompt")

					if prompt then
						toTarget(prompt.CFrame)
					end
				end
			end)
		end

		SaveSettings("Teleport Acient Clock", arg)
	end)

	BuyGearV4 = function()
		if string.find(CheckAcientOneStatus(), "Can Buy Gear") then
			game.ReplicatedStorage.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
			ResetRaceStatus()
		end
	end

	local cframe2 = CFrame.new(28576.4688, 14935.9512, 75.469101, -1, -4.22219593e-08, 1.13133396e-08, 0, -0.258819044, -0.965925813, 4.37113883e-08, -0.965925813, 0.258819044)
	local n6 = 0.2

	getBlueGear = function()
		if game.workspace.Map:FindFirstChild("MysticIsland") then
			for _, child in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
				if child:IsA("MeshPart") and child.MeshId == "rbxassetid://10153114969" then
					return child
				end
			end
		end
	end

	getHighestPoint = function()
		if not game.workspace.Map:FindFirstChild("MysticIsland") then
			return nil
		end

		for _, descendant in pairs(game:GetService("Workspace").Map.MysticIsland:GetDescendants()) do
			if descendant:IsA("MeshPart") then
				if descendant.MeshId == "rbxassetid://6745037796" then
					return descendant
				end
			end
		end
	end

	local tbl10 = { "Last Resort", "Agility", "Water Body", "Heavenly Blood", "Energy Core", "Heightened Senses" }

	CheckAbility = function()
		local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")

		if backpack then
			for _, child in pairs(backpack:GetChildren()) do
				if table.find(tbl10, child.Name) then
					return true
				end
			end
		end

		local character = game.Players.LocalPlayer.Character

		if character then
			for _, child in pairs(character:GetChildren()) do
				if table.find(tbl10, child.Name) then
					return true
				end
			end
		end

		return false
	end

	CollectBlueGear = function()
		if not getHighestPoint() then
			local v_11 = DetectNpc("Advanced Fruit Dealer")
			if not v_11 or not v_11:FindFirstChild("HumanoidRootPart") then
				return
			end

			if v_11 then
				toTarget(v_11.HumanoidRootPart.CFrame)
				return
			end
		end

		local v_11 = getBlueGear()

		if v_11 and not v_11.CanCollide and v_11.Transparency ~= 1 then
			local character = game.Players.LocalPlayer.Character
			character = character and character:FindFirstChild("HumanoidRootPart")
			character = character and character:FindFirstChild("Agility")

			if character then
				character:Destroy()
			end

			toTarget(getBlueGear().CFrame)
		elseif v_11 and v_11.Transparency == 1 then
			local flag5 = getHighestPoint()

			if flag5 then
				local position = localPlayer.Character.HumanoidRootPart.Position
				flag5 = (getHighestPoint().CFrame * CFrame.new(0, 211.88, 0).Position - position).Magnitude > 10
			end

			if flag5 then
				toTarget(getHighestPoint().CFrame * CFrame.new(0, 211.88, 0))
			else
				game.Players.LocalPlayer.CameraMode = "LockFirstPerson"
				game.Players.LocalPlayer.CameraMode = "Classic"
				local now = tick()

				while true do
					wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						local currentCamera = game:GetService("Workspace").CurrentCamera
						local cframe3 = CFrame.new
						local position = game:GetService("Workspace").CurrentCamera.CFrame.Position
						local Lighting = game:GetService("Lighting")
						local v_12 = game
						currentCamera.CFrame = cframe3(position, Lighting:GetMoonDirection() + v_12:GetService("Workspace").CurrentCamera.CFrame.Position)
						if not (tick() - now >= 3) then
							continue
						end
					end

					break
				end

				game:GetService("VirtualInputManager"):SendKeyEvent(true, "T", false, game)
				task.wait(0.5)
				game:GetService("VirtualInputManager"):SendKeyEvent(false, "T", false, game)

				if not CheckAbility() and not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Agility") then
					local clone = game:GetService("ReplicatedStorage").FX.Agility:Clone()
					clone.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
					clone.Enabled = false
				end

				task.wait(1.5)
			end
		end
	end

	PullLeverV4 = function()
		if not CheckItemInventory("Valkyrie Helm") or not CheckItemInventory("Mirror Fractal") then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Not Valkyrie Helm or not Mirror Fractal", ShowTime = 5 })
			wait(5)
			return
		end

		if not game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("CheckTempleDoor") then
			local response = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
			if response == 1 then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")
				return
			end

			if response == 2 then
				toTarget(CFrame.new(3032.780029296875, 2280.85107421875, -7325.47802734375))
				local position = localPlayer.Character.HumanoidRootPart.Position

				if (CFrame.new(3032.780029296875, 2280.85107421875, -7325.47802734375).Position - position).Magnitude < 8 then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
				end

				return
			end

			if response == 3 then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")
				return
			end

			if game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and CheckClockTime() == "Night" then
				CollectBlueGear()
			elseif game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and CheckClockTime() ~= "Night" then
				if not getHighestPoint() then
					local v_11 = DetectNpc("Advanced Fruit Dealer")
					if v_11 then
						toTarget(v_11.HumanoidRootPart.CFrame)
						return
					end
				end

				local v_11 = getHighestPoint()
				local flag5

				if v_11 then
					local position = localPlayer.Character.HumanoidRootPart.Position
					flag5 = (getHighestPoint().CFrame * CFrame.new(0, 211.88, 0).Position - position).Magnitude > 10
				else
					flag5 = v_11
				end

				if flag5 then
					toTarget(getHighestPoint().CFrame * CFrame.new(0, 211.88, 0))
				end
			elseif not game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and Settings["Hop Server [Trial Or Pull Lever]"] then
				SpecialHop("Mirage")
			end
		else
			local v_11 = GetTempleOfTime()
			if not v_11 then
				toTarget(CFrame.new(28282.5703125, 14896.8505859375, 105.10427093505859))
				return
			end

			if v_11.Lever.Lever.CFrame.Z > cframe2.Z + n6 or v_11.Lever.Lever.CFrame.Z < cframe2.Z - n6 then
				if (localPlayer.Character.HumanoidRootPart.Position - v_11.Lever.Part.Position).Magnitude > 10 then
					toTarget(v_11.Lever.Part.CFrame)
				else
					fireproximityprompt(v_11.Lever.Prompt.ProximityPrompt, 1)
				end
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done Pull Lever", ShowTime = 5 })
				wait(5)
			end
		end
	end

	RaceV4Section.CreateToggle({ Title = "Auto Buy Gear", Desc = nil, Default = Settings["Auto Buy Gear"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Buy Gear"] and wait(0.2) do
					pcall(function()
						BuyGearV4()
					end)
				end
			end)
		end

		SaveSettings("Auto Buy Gear", arg)
	end)

	RaceV4Section.CreateDropdown({
		Title = "Select Gear V4",
		List = { "Alpha", "Omega" },
		Search = false,
		Selected = false,
		Default = Settings["Select Gear V4"] or "Omega",
	}, function(arg)
		SaveSettings("Select Gear V4", arg)
	end)

	getgenv().ToggleAutoChooseGears = RaceV4Section.CreateToggle({ Title = "Auto Choose Gears", Desc = nil, Default = Settings["Auto Choose Gears"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Choose Gears"] and wait(0.3) do
					local ok, result = pcall(function()
						ChooseGearV4()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Choose Gears", arg)
	end)

	RaceV4Section.CreateToggle({
		Title = "Auto Finish Train Quest",
		Desc = nil,
		Default = Settings["Auto Finish Train Quest"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Finish Train Quest"] and task.wait() do
					local ok, result = pcall(function()
						if Settings["Stack Train With Trial Race"] and not CheckGoTrain() then
							return
						end
						TurnOnV4()
						BuyGearV4()
						local v_11 = DetectMob(tbl5)

						if v_11 then
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(v_11)
									BringMob(v_11)
									UsedualFlock()
									ClickM1(v_11)

									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
									end

									if not (not IsMobAlive(v_11) or not Settings["Auto Finish Train Quest"] or not CheckGoTrain()) then
										continue
									end
								end

								break
							end
						elseif typeof(tbl5) == "table" then
							if #tbl5 <= #tbl4 then
								tbl4 = {}
								return
							end
							local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl5))

							if v_12 then
								table.insert(tbl4, DetectNameTablePart(tbl5))

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
										if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto Finish Train Quest"] or not CheckGoTrain()) then
											continue
										end
									end

									break
								end

								wait(1)
							end
						else
							local v_12 = DetectPartSpawnMob(tbl5, true)

							if v_12 then
								Instance.new("IntValue", v_12).Name = "Ignored"

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
										if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto Finish Train Quest"] or not CheckGoTrain()) then
											continue
										end
									end

									break
								end

								wait(1)
							else
								DeleteIgnoredMobSpawn()
							end
						end
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Finish Train Quest", arg)
	end)

	RaceV4Section.CreateToggle({
		Title = "Stack Train With Trial Race",
		Desc = nil,
		Default = Settings["Stack Train With Trial Race"] or false,
	}, function(arg)
		SaveSettings("Stack Train With Trial Race", arg)
	end)

	getgenv().TurnOffHOPSVPullAndTrial = RaceV4Section.CreateToggle({
		Title = "Hop Server [Trial Or Pull Lever]",
		Desc = nil,
		Default = Settings["Hop Server [Trial Or Pull Lever]"] or false,
	}, function(arg)
		SaveSettings("Hop Server [Trial Or Pull Lever]", arg)
	end)

	RaceV4Section.CreateToggle({ Title = "Auto Pull Lever", Desc = nil, Default = Settings["Auto Pull Lever"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Pull Lever"] and wait(0.1) do
					pcall(function()
						PullLeverV4()
					end)
				end
			end)
		end

		SaveSettings("Auto Pull Lever", arg)
	end)

	DetectNameMulti = function(arg)
		local tbl11 = {}

		if Settings["Select Players Multi"] and not arg then
			for k, v_11 in next, Settings["Select Players Multi"], nil do
				if v_11 then
					tbl11[k] = true
				end
			end
		end

		local v_11 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_11(Players2:GetChildren()) do
			if child.Name ~= localPlayer.Name and not table.find(tbl11, child.Name) then
				tbl11[child.Name] = false
			end
		end

		return tbl11
	end

	local createDropdown = RaceV4Section.CreateDropdown
	local selectPlayersMulti = Settings["Select Players Multi"]

	DropdownSelectPlayerMulti = createDropdown({
		Title = "Select Players Multi",
		List = PrepareMultiSelectList(DetectNameMulti(), selectPlayersMulti),
		Search = true,
		Selected = true,
		Default = Settings["Select Players Multi"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Players Multi", arg, arg2)
	end)

	RaceV4Section.CreateButton({ Title = "Refresh Player" }, function()
		DropdownSelectPlayerMulti:GetNewList(DetectNameMulti(true))
	end)

	RaceV4Section.CreateToggle({ Title = "Multi Trial", Desc = nil, Default = Settings["Multi Trial"] or false }, function(arg)
		SaveSettings("Multi Trial", arg)
	end)

	RaceV4Section.CreateToggle({
		Title = "Auto Reset Character",
		Desc = nil,
		Default = Settings["Auto Reset Character"] or false,
	}, function(arg)
		SaveSettings("Auto Reset Character", arg)
	end)

	ToggleAutoTrial = RaceV4Section.CreateToggle({ Title = "Auto Trial", Desc = nil, Default = Settings["Auto Trial"] or false }, function(arg)
		SaveSettings("Auto Trial", arg)
	end)

	RaceV4Section.CreateToggle({
		Title = "Auto Turn On V3 Near Door",
		Desc = "will auto turn on race \nif have players near door",
		Default = Settings["Auto Turn On V3 Near Door"] or false,
	}, function(arg)
		SaveSettings("Auto Turn On V3 Near Door", arg)
	end)

	KillTrialSection = RaceMain.CreateSection("Kill Trial")

	KillTrialSection.CreateDropdown({
		Title = "Select Weapon Attack Trial",
		List = { "Melee", "Sword", "Blox Fruit" },
		Search = true,
		Selected = false,
		Default = Settings["Select Weapon Attack Trial"] or nil,
	}, function(arg)
		SaveSettings("Select Weapon Attack Trial", arg)
	end)

	KillTrialSection.CreateToggle({
		Title = "Kill players When complete Trial",
		Desc = "Turn on before Start Attack and Turn on Auto Trial",
		Default = Settings["Kill players When complete Trial"] or false,
	}, function(arg)
		SaveSettings("Kill players When complete Trial", arg)
	end)

	KillTrialSection.CreateToggle({
		Title = "Use Skill when Kill Player",
		Desc = nil,
		Default = Settings["Use Skill when Kill Player"] or false,
	}, function(arg)
		SaveSettings("Use Skill when Kill Player", arg)
	end)

	KillTrialSection.CreateToggle({
		Title = "Just Use Skill when Player Active Ken",
		Desc = nil,
		Default = Settings["Just Use Skill when Player Active Ken"] or false,
	}, function(arg)
		SaveSettings("Just Use Skill when Player Active Ken", arg)
	end)

	DetectNameAbility = function(arg)
		local v_11 = next
		local children, v_12 = arg:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if table.find(tbl10, v_13.Name) then
				return true
			end
		end
	end

	GetOtherPlayerRaces = function()
		local tbl11 = {}
		local v_11 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_11(Players2:GetChildren()) do
			if child.Name ~= localPlayer.Name then
				tbl11[child.Name] = child.Data.Race.Value
			end
		end

		return tbl11
	end

	CheckMultiPlayerNearDoor = function()
		local v_11 = next
		local children, v_12 = game.Workspace.Characters:GetChildren()
		local n7 = 0

		for _, v_13 in v_11, children, v_12 do
			local name = v_13.Name
			local v_14 = GetOtherPlayerRaces()[name]

			if v_14 and DetectNameAbility(v_13.HumanoidRootPart) and (v_13.HumanoidRootPart.Position - game:GetService("Workspace").Map["Temple of Time"][v_14 .. "Corridor"].Door.Door.RightDoor.Union.Position).Magnitude < 100 then
				n7 += 1
			end
		end

		if n7 >= 2 then
			return true
		end
	end

	CheckMultiAccount = function()
		local tbl11 = {}
		local v_11 = pairs
		local Players2 = game:GetService("Players")

		for _, child in v_11(Players2:GetChildren()) do
			if Settings["Select Players Multi"] and Settings["Select Players Multi"][child.Name] then
				tbl11[child.Name] = child.Data.Race.Value
			end
		end

		return tbl11
	end

	CheckMultiTeleDoor = function()
		local v_11 = next
		local children, v_12 = game.Workspace.Characters:GetChildren()
		local n7 = 0

		for _, v_13 in v_11, children, v_12 do
			local name = v_13.Name
			local v_14 = CheckMultiAccount()[name]

			if v_14 and (v_13.HumanoidRootPart.Position - game:GetService("Workspace").Map["Temple of Time"][v_14 .. "Corridor"].Door.Door.RightDoor.Union.Position).Magnitude < 100 then
				n7 += 1
			end
		end

		if n7 >= 2 then
			return true
		end
	end

	TrialHuman = function()
		if game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Strength") then
			StrengthPart = game:GetService("Workspace")._WorldOrigin.Locations["Trial of Strength"]

			if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - StrengthPart.Position).Magnitude <= 1000 then
				for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
					if IsMobAlive(child) and (child.HumanoidRootPart.Position - StrengthPart.Position).Magnitude <= 1000 then
						return child
					end
				end
			end
		end
	end

	TrialGhoul = function()
		if game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Carnage") then
			if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")._WorldOrigin.Locations["Trial of Carnage"].Position).Magnitude <= 1000 then
				for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
					if IsMobAlive(child) and (child.HumanoidRootPart.Position - game:GetService("Workspace")._WorldOrigin.Locations["Trial of Carnage"].Position).Magnitude <= 1000 then
						return child
					end
				end
			end
		end
	end

	GetSeaBeastTrial = function()
		if not game.Workspace.Map:FindFirstChild("FishmanTrial") then
			return
		end
		local trialOfWater

		if game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Water") then
			trialOfWater = game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Water")
		else
			trialOfWater = nil
		end

		if trialOfWater then
			local v_11 = next
			local children, v_12 = game:GetService("Workspace").SeaBeasts:GetChildren()

			for _, v_13 in v_11, children, v_12 do
				if string.find(v_13.Name, "SeaBeast") and v_13:FindFirstChild("HumanoidRootPart") and (v_13.HumanoidRootPart.Position - trialOfWater.Position).Magnitude <= 1500 then
					if v_13.Health.Value > 0 then
						return v_13
					end
				end
			end
		end
	end

	getgenv().TrialDone = false
	getgenv().KillAuraDone = false

	TeleportSeabeast2 = function(arg)
		arg = arg and arg:FindFirstChild("HumanoidRootPart")
		if not arg then
			return
		end

		if (Vector3.new(0, arg.Position.Y, 0) - Vector3.new(0, -60, 0)).Magnitude <= 175 then
			toTarget(arg.CFrame * CFrame.new(0, 200, 50))
		else
			toTarget(CFrame.new(arg.Position.X, 140, arg.Position.Z))
		end
	end

	DetectPlayerKillName = function()
		local tbl11 = {}
		local v_11 = next
		local children, v_12 = game.Workspace.Characters:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Model") and v_13.Name ~= game.Players.LocalPlayer.Name and v_13:FindFirstChild("HumanoidRootPart") and v_13:FindFirstChild("Humanoid") and v_13.Humanoid.Health > 0 and (v_13.HumanoidRootPart.Position - Vector3.new(28718.068, 14887.5625, -60.548218)).Magnitude <= 400 then
				table.insert(tbl11, v_13.Name)
			end
		end

		return tbl11
	end

	getgenv().PlayerKillTrial = {}
	getgenv().BlackListPlayerTrial = {}

	NameAttackTrial = function()
		for k, v_11 in next, getgenv().PlayerKillTrial, nil do
			if not table.find(getgenv().BlackListPlayerTrial, v_11) then
				return v_11, k
			end
		end
	end

	CheckCDSkill = function(arg)
		if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(arg) then
			equiptool(arg)
			return
		end
		local v_11 = next
		local children, v_12 = game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills[arg]:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Frame") then
				if v_13.Name ~= "Template" and v_13.Title.TextColor3 == Color3.new(1, 1, 1) and v_13.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v_13.Cooldown.Size == UDim2.new(1, 0, 1, -1) then
					return v_13
				end
			end
		end
	end

	VerifyNearbyTrial = function()
		local tbl11 = {
			"Trial of the Machine",
			"Trial of Speed",
			"Trial of Strength",
			"Trial of Water",
			"Trial of the King",
			"Trial of Carnage",
			"Trial of Flames",
		}

		local v_11 = next
		local children, v_12 = workspace._WorldOrigin.Locations:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if table.find(tbl11, v_13.Name) and localPlayer:DistanceFromCharacter(v_13.Position) < 1500 then
				return true
			end
		end
	end

	AutoTrialV4 = function()
		if Settings["Auto Finish Train Quest"] and Settings["Stack Train With Trial Race"] and CheckGoTrain() then
			return
		end
		local clockTime = game.Lighting.ClockTime
		local flag5 = CheckMoon() == "Full Moon"

		if flag5 then
			flag5 = not (clockTime > 5 and clockTime < 12)
		end

		if (flag5 or CheckMoon() == "Next Night") and Settings["Hop Server [Trial Or Pull Lever]"] then
			if getgenv().TurnOffHOPSVPullAndTrial then
				getgenv().TurnOffHOPSVPullAndTrial:SetStage(false)
			end

			task.wait(3)
		elseif Settings["Hop Server [Trial Or Pull Lever]"] then
			HopServer()
			return
		end

		local v_11 = GetTempleOfTime()
		if not v_11 and not VerifyNearbyTrial() then
			toTarget(CFrame.new(28282.5703125, 14896.8505859375, 105.10427093505859))
			return
		end

		if v_11 and v_11.FFABorder:FindFirstChild("Forcefield") and v_11.FFABorder.Forcefield.Transparency == 1 or VerifyNearbyTrial() then
			if game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
				if VerifyNearbyTrial() and not getgenv().VerifyTrial then
					getgenv().VerifyTrial = true
				end

				while true do
					wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not (VerifyNearbyTrial() or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible) then
							continue
						end
					end

					break
				end

				local value = game.Players.LocalPlayer.Data.Race.Value

				if value == "Human" then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							local v_12 = TrialHuman()

							if v_12 then
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_12)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										ClickM1(v_12)
										UsedualFlock()
										if not (not IsMobAlive(v_12) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")._WorldOrigin.Locations["Trial of Strength"].Position).Magnitude > 1000) then
											continue
										end
									end

									break
								end
							end

							if not (not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")._WorldOrigin.Locations["Trial of Strength"].Position).Magnitude > 1000) then
								continue
							end
						end

						break
					end
				elseif value == "Skypiea" then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if game:GetService("Workspace")._WorldOrigin.Locations["Trial of the King"] and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")._WorldOrigin.Locations["Trial of the King"].CFrame.Position).Magnitude <= 1000 then
								toTarget(game:GetService("Workspace").Map.SkyTrial.Model.FinishPart.CFrame)
								task.wait(3)
							end

							if not (not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible or workspace.Map:FindFirstChild("Temple of Time") and workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0 or localPlayer:DistanceFromCharacter(game:GetService("Workspace").Map.SkyTrial.Model.FinishPart.Position) > 1000) then
								continue
							end
						end

						break
					end
				elseif value == "Fishman" then
					local trialOfWater

					if game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Water") then
						trialOfWater = game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Water")
					else
						trialOfWater = nil
					end

					if trialOfWater and (trialOfWater.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 then
						local v_12 = GetSeaBeastTrial()

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if v_12 then
									local humanoidRootPart2 = v_12:FindFirstChild("HumanoidRootPart")
									getgenv().AimPos = CFrame.new(humanoidRootPart2.Position.X, 40, humanoidRootPart2.Position.Z)
									TeleportSeabeast2(v_12)

									if localPlayer:DistanceFromCharacter(humanoidRootPart2.Position) < 400 then
										AutoAllSkill()
									end
								end

								local flag6 = not v_12 or not v_12.Parent or v_12.Health.Value == 0 or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible or workspace.Map:FindFirstChild("Temple of Time") and workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency == 0

								if not flag6 then
									local v_13 = localPlayer
									local distanceFromCharacter = v_13.DistanceFromCharacter

									local function fn7()
										local trialOfWater2 = game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Water")
										return trialOfWater2 and trialOfWater2.Position or Vector3.new()
									end

									local v_14 = fn7()
									flag6 = distanceFromCharacter(v_13, v_14) > 1000
								end

								if not flag6 then
									continue
								end
							end

							break
						end
					end
				elseif value == "Mink" then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace")._WorldOrigin.Locations["Trial of Speed"].Position).Magnitude <= 1000 then
								toTarget(game:GetService("Workspace").StartPoint.CFrame * CFrame.new(0, 2, 0))
							end

							local flag6 = not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible
							local flag7

							if flag6 then
								flag7 = flag6
							else
								local v_12 = localPlayer
								local distanceFromCharacter = v_12.DistanceFromCharacter

								local function fn7()
									local trialOfSpeed = game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Speed")
									return trialOfSpeed and trialOfSpeed.Position or Vector3.new()
								end

								local v_13 = fn7()
								flag7 = distanceFromCharacter(v_12, v_13) > 1000
							end

							if not flag7 then
								continue
							end
						end

						break
					end
				elseif value == "Ghoul" then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							local v_12 = TrialGhoul()

							if v_12 then
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_12)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										UsedualFlock()
										ClickM1(v_12)
										local flag6 = not IsMobAlive(v_12) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible

										if not flag6 then
											local v_13 = localPlayer
											local distanceFromCharacter = v_13.DistanceFromCharacter

											local function fn7()
												local trialOfCarnage = game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Carnage")
												return trialOfCarnage and trialOfCarnage.Position or Vector3.new()
											end

											local v_14 = fn7()
											flag6 = distanceFromCharacter(v_13, v_14) > 1000
										end

										if not flag6 then
											continue
										end
									end

									break
								end
							end

							local flag6 = not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible
							local flag7

							if flag6 then
								flag7 = flag6
							else
								local v_13 = localPlayer
								local distanceFromCharacter = v_13.DistanceFromCharacter

								local function fn7()
									local trialOfCarnage = game:GetService("Workspace")._WorldOrigin.Locations:FindFirstChild("Trial of Carnage")
									return trialOfCarnage and trialOfCarnage.Position or Vector3.new()
								end

								local v_14 = fn7()
								flag7 = distanceFromCharacter(v_13, v_14) > 1000
							end

							if not flag7 then
								continue
							end
						end

						break
					end
				elseif value == "Cyborg" then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(CFrame.new(28282.5703125, 14896.8505859375, 105.10427093505859))
							if game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
								continue
							end
						end

						break
					end
				end
			else
				if not v_11 then
					return
				end
				local union = v_11[localPlayer.Data.Race.Value .. "Corridor"].Door.Door.RightDoor.Union

				if localPlayer:DistanceFromCharacter(union.Position) > 8 then
					toTarget(union.CFrame)
				end

				if Settings["Multi Trial"] and CheckMultiTeleDoor() and localPlayer:DistanceFromCharacter(union.Position) <= 8 then
					game:service("VirtualInputManager"):SendKeyEvent(true, "T", false, game)
					task.wait()
					game:service("VirtualInputManager"):SendKeyEvent(false, "T", false, game)
					return
				end

				if Settings["Auto Turn On V3 Near Door"] and CheckMultiPlayerNearDoor() then
					game:service("VirtualInputManager"):SendKeyEvent(true, "T", false, game)
					task.wait()
					game:service("VirtualInputManager"):SendKeyEvent(false, "T", false, game)
				end
			end
		elseif getgenv().VerifyTrial then
			if not Settings["Multi Trial"] and not Settings["Auto Reset Character"] then
				Settings["Auto Trial"] = false
				ToggleAutoTrial:SetStage(false)
			end

			getgenv().VerifyTrial = false
		end
	end

	PlayerTrial = function()
		local forcefield = workspace.Map["Temple of Time"].FFABorder.Forcefield
		local position = forcefield.Position
		local size = forcefield.Size
		local v_11 = pairs
		local v_12 = workspace:FindPartsInRegion3(Region3.new(position - size / 2, position + size / 2), nil, math.huge)

		for _, v_13 in v_11(v_12) do
			local parent = v_13.Parent

			if parent and parent:FindFirstChild("Humanoid") then
				local playerFromCharacter = game.Players:GetPlayerFromCharacter(parent)
				if playerFromCharacter and playerFromCharacter.Name ~= localPlayer.Name and playerFromCharacter.Character.Humanoid.Health > 0 then
					return playerFromCharacter.Character
				end
			end
		end
	end

	local attributes = nil

	hasCooldownChanged = function(arg)
		local attributes2 = arg:GetAttributes()

		if not attributes then
			attributes = arg:GetAttributes()
		end

		for k, v_11 in next, attributes2, nil do
			if (string.find(k, "GunCooldown") or string.find(k, "MeleeCooldown") or string.find(k, "SwordCooldown") or string.find(k, "BloxFruitCooldown")) and v_11 > 0 then
				if attributes[k] ~= v_11 then
					attributes = attributes2
					return true
				end
			end
		end

		return false
	end

	spawn(function()
		while task.wait(0.1) do
			pcall(function()
				if Settings["Kill players When complete Trial"] then
					if workspace.Map:FindFirstChild("Temple of Time") and workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency ~= 1 then
						if game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
							local v_11 = PlayerTrial()

							if v_11 then
								while true do
									task.wait()

									task.spawn(function()
										if not game:GetService("Lighting").Blur.Enabled then
											game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
											task.wait()
											game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
											task.wait(3)
										end

										local cFrame2 = v_11.HumanoidRootPart.CFrame
										getgenv().AimPos = cFrame2
									end)

									if hasCooldownChanged(v_11) then
										local now = tick()

										while true do
											task.wait()

											if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
												task.spawn(getgenv().AttackFunctionnhungSuperTrial)
												localPlayer.Character.HumanoidRootPart.CFrame = v_11.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
												if not (tick() - now >= 0.75) then
													continue
												end
											end

											break
										end
									else
										localPlayer.Character.HumanoidRootPart.CFrame = v_11.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
									end

									task.spawn(getgenv().AttackFunctionnhungSuperTrial)
									equiptool(NameWeapon(Settings["Select Weapon Attack Trial"]))

									if Settings["Use Skill when Kill Player"] or Settings["Just Use Skill when Player Active Ken"] then
										if Settings["Just Use Skill when Player Active Ken"] and game.Players[v_11.Name]:GetAttribute("KenActive") or not Settings["Just Use Skill when Player Active Ken"] then
											task.spawn(function()
												local v_12 = CheckCDSkill(NameWeapon(Settings["Select Weapon Attack Trial"]))

												if v_12 then
													game:GetService("VirtualInputManager"):SendKeyEvent(true, v_12.Name, false, game)
													task.wait(0.05)
													game:GetService("VirtualInputManager"):SendKeyEvent(false, v_12.Name, false, game)
												end
											end)
										end
									end

									if not (not v_11 or not v_11.Parent or v_11.Humanoid.Health <= 0 or not Settings["Kill players When complete Trial"] or not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible or localPlayer.Character.Humanoid.Health <= 0) then
										continue
									end
									break
								end
							end
						end
					end
				end
			end)
		end
	end)

	spawn(function()
		while task.wait(0.1) do
			if Settings["Auto Trial"] then
				local ok, result = pcall(function()
					AutoTrialV4()
				end)

				if result then
					print(ok, result)
				end
			end

			pcall(function()
				if workspace.Map:FindFirstChild("Temple of Time") and workspace.Map["Temple of Time"].FFABorder.Forcefield.Transparency ~= 1 then
					if Settings["Auto Reset Character"] then
						localPlayer.Character.Humanoid.Health = 0
					end
				end
			end)
		end
	end)

	GetItemsMain = Main.CreatePage({ Page_Name = "Get and Upgrade Items", Page_Title = "Get and Upgrade Items Tab" })
	GetItemsSection = GetItemsMain.CreateSection("Get Items")

	GetItemsSection.CreateToggle({ Title = "Auto Trade Bone", Desc = nil, Default = Settings["Auto Trade Bone"] or false }, function(arg)
		SaveSettings("Auto Trade Bone", arg)
	end)

	GetItemsSection.CreateToggle({
		Title = "Auto Buy Legendary Sword",
		Desc = nil,
		Default = Settings["Auto Buy Legendary Sword"] or false,
	}, function(arg)
		SaveSettings("Auto Buy Legendary Sword", arg)
	end)

	GetItemsSection.CreateToggle({
		Title = "Auto Buy Haki Color",
		Desc = nil,
		Default = Settings["Auto Buy Haki Color"] or false,
	}, function(arg)
		SaveSettings("Auto Buy Haki Color", arg)
	end)

	GetItemsSection.CreateToggle({
		Title = "Hop Server [ Haki color or Legendary Sword]",
		Desc = nil,
		Default = Settings["Hop Server [ Haki color or Legendary Sword]"] or false,
	}, function(arg)
		SaveSettings("Hop Server [ Haki color or Legendary Sword]", arg)
	end)

	local tbl11 = { "Stone", "Hydra Leader", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate" }

	DetectQuestRainBowHaki = function(arg)
		if not arg then
			for _, v_11 in next, tbl11, nil do
				if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible and string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, v_11) then
					return false
				end
			end

			for _, v_11 in next, tbl11, nil do
				if not string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, v_11) or not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
					return true
				end
			end
		else
			for _, v_11 in next, tbl11, nil do
				if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, v_11) then
					return v_11
				end
			end
		end
	end

	GetRainBowHaki = function()
		if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("HornedMan") == 1 then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done Get Rainbow Haki", ShowTime = 5 })
			wait(5)
			return
		end

		local hornedMan = DetectNpc("Horned Man") or workspace.NPCs:FindFirstChild("Horned Man") or game:GetService("ReplicatedStorage").NPCs:FindFirstChild("Horned Man")

		if DetectQuestRainBowHaki() then
			if localPlayer:DistanceFromCharacter(hornedMan.HumanoidRootPart.Position) > 8 then
				toTarget(hornedMan.HumanoidRootPart.CFrame)
			else
				wait(2)
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
			end
		else
			local v_11 = CheckNameBoss(DetectQuestRainBowHaki(true))

			if v_11 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(v_11)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						ClickM1(v_11)
						UsedualFlock()
						if not (not IsMobAlive(v_11) or not Settings["Auto Get Rainbow Haki"]) then
							continue
						end
					end

					break
				end
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Waiting Boss Spawn", ShowTime = 5 })
				wait(5)
			end
		end
	end

	GetItemsSection.CreateToggle({
		Title = "Auto Get Rainbow Haki",
		Desc = nil,
		Default = Settings["Auto Get Rainbow Haki"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Get Rainbow Haki"] and task.wait(0.1) do
					local ok, result = pcall(function()
						GetRainBowHaki()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Get Rainbow Haki", arg)
	end)

	CountZombie = function(arg)
		local n7 = 0

		for _, child in pairs(game.workspace.Enemies:GetChildren()) do
			if child.Name == "Living Zombie" and child.Humanoid.Health > 0 then
				if not arg then
					n7 += 1
				end
			end
		end

		return n7
	end

	BlankTablets = { "Segment6", "Segment2", "Segment8", "Segment9", "Segment5" }

	Trophy = {
		Segment1 = "Trophy1",
		Segment3 = "Trophy2",
		Segment4 = "Trophy3",
		Segment7 = "Trophy4",
		Segment10 = "Trophy5",
	}

	Pipes = {
		Part1 = "Really black",
		Part2 = "Really black",
		Part3 = "Dusty Rose",
		Part4 = "Storm blue",
		Part5 = "Really black",
		Part6 = "Parsley green",
		Part7 = "Really black",
		Part8 = "Dusty Rose",
		Part9 = "Really black",
		Part10 = "Storm blue",
	}

	DetectHighHealthMob = function(arg)
		local n7 = 0
		local v_11 = nil

		for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
			if (typeof(arg) == "table" and table.find(arg, child.Name) or child.Name == arg) and IsMobAlive(child) then
				local humanoid = child:FindFirstChildOfClass("Humanoid")

				if humanoid then
					local health = humanoid.Health

					if n7 < health then
						n7 = health
						v_11 = child
					end
				end
			end
		end

		return v_11
	end

	GuitarPuzzleProgress = function()
		if not CommF:InvokeServer("GuitarPuzzleProgress", "Check") then
			if MoonTextureId() == "http://www.roblox.com/asset/?id=9709149431" and (game.Lighting.ClockTime > 16 or game.Lighting.ClockTime < 5) then
				if localPlayer:DistanceFromCharacter(Vector3.new(-8654.314, 140.9499, 6167.5283)) > 50 then
					toTarget(CFrame.new(-8654.314453125, 140.94990539550781, 6167.5283203125))
				end

				CommF:InvokeServer("gravestoneEvent", 2)
				CommF:InvokeServer("gravestoneEvent", 2, true)
				task.wait(1)
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Hop Full Moon", ShowTime = 5 })
				SpecialHop("FullMoon")
			end
		else
			if localPlayer.PlayerGui.Main.Dialogue.Visible then
				game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
				game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
			end

			if not CommF:InvokeServer("GuitarPuzzleProgress", "Check").Swamp then
				local position = localPlayer.Character.HumanoidRootPart.Position

				if (CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875).Position - position).Magnitude > 100 then
					toTarget(CFrame.new(-10171.7607421875, 158.62667846679688, 6008.0654296875))
				elseif CountZombie() == 6 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							DetectHighHealthMob("Living Zombie")

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									local v_11 = DetectHighHealthMob("Living Zombie")
									sizepart(v_11)
									UsedualFlock()
									ClickM1(v_11)

									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
									end

									if IsMobAlive(v_11) then
										continue
									end
								end

								break
							end

							if CountZombie() ~= 0 then
								continue
							end
						end

						break
					end
				end

				return
			end

			if not CommF:InvokeServer("GuitarPuzzleProgress", "Check").Gravestones then
				if localPlayer:DistanceFromCharacter(Vector3.new(-8761.477, 142.10487, 6086.0786)) > 50 then
					toTarget(CFrame.new(-8761.4765625, 142.10487365722656, 6086.07861328125))
				else
					for _, v_11 in pairs({
						game.workspace.Map["Haunted Castle"].Placard1.Right.ClickDetector,
						game.workspace.Map["Haunted Castle"].Placard2.Right.ClickDetector,
						game.workspace.Map["Haunted Castle"].Placard3.Left.ClickDetector,
						game.workspace.Map["Haunted Castle"].Placard4.Right.ClickDetector,
						game.workspace.Map["Haunted Castle"].Placard5.Left.ClickDetector,
						game.workspace.Map["Haunted Castle"].Placard6.Left.ClickDetector,
						game.workspace.Map["Haunted Castle"].Placard7.Left.ClickDetector,
					}) do
						fireclickdetector(v_11)
					end
				end
			elseif not CommF:InvokeServer("GuitarPuzzleProgress", "Check").Ghost then
				if localPlayer:DistanceFromCharacter(Vector3.new(-9755.659, 271.06613, 6290.6147)) > 50 then
					toTarget(CFrame.new(-9755.6591796875, 271.06613159179688, 6290.61474609375))
				end

				CommF:InvokeServer("GuitarPuzzleProgress", "Ghost")
				task.wait(3)
			elseif not CommF:InvokeServer("GuitarPuzzleProgress", "Check").Trophies then
				if localPlayer:DistanceFromCharacter(Vector3.new(-9530.013, 6.1048536, 6054.8335)) > 50 then
					toTarget(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375))
				end

				local tablet = game.workspace.Map["Haunted Castle"].Tablet

				for _, v_11 in pairs(BlankTablets) do
					local v_12 = tablet[v_11]

					if v_12.Line.Position.X ~= -9707.86328125 then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								fireclickdetector(v_12.ClickDetector)
								if v_12.Line.Position.X ~= -9707.86328125 then
									continue
								end
							end

							break
						end
					end
				end

				for k, v_11 in pairs(Trophy) do
					local v_12 = tostring(game.workspace.Map["Haunted Castle"].Trophies.Quest[v_11].Handle.CFrame):split(", ")[4]
					local str

					if v_12 == "1" or v_12 == "-1" then
						str = "90"
					else
						str = "180"
					end

					if not string.find(tostring(tablet[k].Line.Rotation.Z), str) then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								fireclickdetector(tablet[k].ClickDetector)
								if not string.find(tostring(tablet[k].Line.Rotation.Z), str) then
									continue
								end
							end

							break
						end

						print(k, str)
					end
				end
			elseif not CommF:InvokeServer("GuitarPuzzleProgress", "Check").Pipes then
				for k, v_11 in pairs(Pipes) do
					local v_12 = game.workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model[k]

					if v_12.BrickColor.Name ~= v_11 then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								fireclickdetector(v_12.ClickDetector)
								if v_12.BrickColor.Name ~= v_11 then
									continue
								end
							end

							break
						end
					end
				end
			end
		end
	end

	DetectRequestSoulGuitar = function()
		local tbl12 = {}
		local checkPlaceId2, str

		if not CheckCountItem("Ectoplasm", 250) then
			tbl12 = { "Ship Deckhand", "Ship Steward", "Ship Officer", "Ship Engineer" }
			checkPlaceId2 = getgenv().CheckPlaceId2
			str = "TravelDressrosa"
		else
			str = nil
			checkPlaceId2 = nil

			if not CheckCountItem("Bones", 500) then
				tbl12 = { "Reborn Skeleton", "Demonic Soul", "Living Zombie", "Posessed Mummy" }
				str = "TravelZou"
				checkPlaceId2 = getgenv().CheckPlaceId
			end
		end

		return tbl12, checkPlaceId2, str
	end

	AutoSoulGuitar = function()
		if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("soulGuitarBuy", true) == "[You already own this item.]" then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "[You already own this item.]", ShowTime = 5 })
			task.wait(5)
			return
		end

		if localPlayer.Data.Fragments.Value < 5000 then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Frag >= 5k", ShowTime = 5 })
			wait(5)
			return
		end

		if CheckCountItem("Dark Fragment", 1) and CheckCountItem("Ectoplasm", 250) and CheckCountItem("Bones", 500) then
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("soulGuitarBuy")

			if game.PlaceId == getgenv().CheckPlaceId then
				GuitarPuzzleProgress()
			else
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
			end

			return
		end

		if not CheckCountItem("Dark Fragment", 1) then
			if game.PlaceId == getgenv().CheckPlaceId2 then
				if CheckNameBoss("Darkbeard") then
					local Darkbeard = CheckNameBoss("Darkbeard")

					if Darkbeard then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(Darkbeard)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(Darkbeard.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(Darkbeard.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								UsedualFlock()
								ClickM1(Darkbeard)
								if not (not IsMobAlive(Darkbeard) or not Settings["Auto Soul Guitar"]) then
									continue
								end
							end

							break
						end
					end
				elseif localPlayer.Character:FindFirstChild("Fist of Darkness") or localPlayer.Backpack:FindFirstChild("Fist of Darkness") then
					local v_11 = game
					local position = localPlayer.Character.HumanoidRootPart.Position

					if (v_11:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection.Position - position).Magnitude <= 5 then
						equiptool("Fist of Darkness")
						firetouchinterest(game.Players.LocalPlayer.Character["Fist of Darkness"].Handle, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 0)
						firetouchinterest(game.Players.LocalPlayer.Character["Fist of Darkness"].Handle, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 1)
						firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 0)
						firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection, 1)
					else
						toTarget(game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection.CFrame)
					end
				else
					local v_11 = GetNearestChest()

					if v_11 then
						local now = nil

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v_11.Position).Magnitude <= 5 then
									if not now then
										now = tick()
									elseif tick() - now >= 5 then
										Instance.new("IntValue", v_11).Name = "Ignored"
										wait(0.5)
									end

									game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
									wait()
									game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
									TweenManager.CancelCurrent()
								end

								toTarget(v_11.CFrame, true)
								if not (not v_11 or not v_11.Parent or not Settings["Auto Soul Guitar"] or localPlayer.Character:FindFirstChild("Fist of Darkness") or localPlayer.Backpack:FindFirstChild("Fist of Darkness") or v_11:GetAttribute("IsDisabled") or v_11:FindFirstChild("Ignored") or not v_11:FindFirstChild("TouchInterest")) then
									continue
								end
							end

							break
						end
					else
						local v_12 = PathFindChest()

						if v_12 then
							toTarget(v_12.Part.CFrame)

							if (v_12.Part.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or GetNearestChest() then
								Instance.new("IntValue", v_12).Name = "Ignored"
							end
						else
							print("delete")

							for _, child in pairs(game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()) do
								if child:FindFirstChild("Ignored") then
									child:FindFirstChild("Ignored"):Destroy()
								end
							end
						end
					end
				end
			else
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
			end
		else
			local v_11, v_12, v_13 = DetectRequestSoulGuitar()

			if game.PlaceId == v_12 then
				local v_14 = DetectMob(v_11)

				if v_14 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_14)
							BringMob(v_14)
							UsedualFlock()
							ClickM1(v_14)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(v_14) or not Settings["Auto Soul Guitar"]) then
								continue
							end
						end

						break
					end
				elseif typeof(v_11) == "table" then
					if #v_11 <= #tbl4 then
						tbl4 = {}
						return
					end
					local v_15 = DetectPartSpawnMob(DetectNameTablePart(v_11))

					if v_15 then
						table.insert(tbl4, DetectNameTablePart(v_11))

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_15.CFrame * CFrame.new(0, 60, 0))
								if not ((v_15.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(v_11) or not Settings["Auto Soul Guitar"]) then
									continue
								end
							end

							break
						end

						wait(1)
					end
				else
					local v_15 = DetectPartSpawnMob(v_11, true)

					if v_15 then
						Instance.new("IntValue", v_15).Name = "Ignored"

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_15.CFrame * CFrame.new(0, 60, 0))
								if not ((v_15.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(v_11) or not Settings["Auto Soul Guitar"]) then
									continue
								end
							end

							break
						end

						wait(1)
					else
						DeleteIgnoredMobSpawn()
					end
				end
			else
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(v_13)
			end
		end
	end

	GetItemsSection.CreateToggle({ Title = "Auto Soul Guitar", Desc = nil, Default = Settings["Auto Soul Guitar"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Soul Guitar"] and task.wait(0.1) do
					local ok, result = pcall(function()
						AutoSoulGuitar()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Soul Guitar", arg)
	end)

	StartGood = true

	QuestGood3 = function()
		AllNPCS = {}

		for _, child in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
			table.insert(AllNPCS, child)
		end

		for _, child in pairs(game:GetService("ReplicatedStorage").NPCs:GetChildren()) do
			table.insert(AllNPCS, child)
		end

		for _, v_11 in pairs(AllNPCS) do
			if v_11.Name:match("Luxury Boat Dealer") then
				localPlayer.Character.HumanoidRootPart.CFrame = v_11.HumanoidRootPart.CFrame
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({ "CDKQuest", "BoatQuest", v_11 }))
			end
		end
	end

	QuestGood4 = function()
		if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(-5543.5327, 313.80063, -2964.2585)).magnitude > 1000 then
			toTarget(CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219))
		else
			local v_11 = GetPirateRaid() or GetPirateRaid(true)

			if v_11 then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						equiptool(NameWeapon("Sword"))
						sizepart(v_11)
						ClickM1(v_11)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						if IsMobAlive(v_11) then
							continue
						end
					end

					break
				end
			else
				if (Settings["Select Method Hop CDK1"] or {})["Hop Raid Castle [ Delay 20s Hop Because check Raids Castle ]"] then
					lib.CreateNoti({
						Title = "Banana Cat Hub",
						Desc = "Waiting 20s for check raid castle if dont have will Server",
						ShowTime = 5,
					})

					local now = tick()

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if not (GetPirateRaid() or GetPirateRaid(true) or tick() - now >= 20) then
								continue
							end
						end

						break
					end

					if not (GetPirateRaid() or GetPirateRaid(true)) then
						SpecialHop("Raid Castle")
					end
				else
					lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Waint Raid Castle", ShowTime = 5 })
				end

				wait(5)
			end
		end
	end

	TourchGood5 = function()
		local str

		if game:GetService("Workspace").Map.HeavenlyDimension.Torch1.ProximityPrompt.Enabled then
			str = "1"
		elseif game:GetService("Workspace").Map.HeavenlyDimension.Torch2.ProximityPrompt.Enabled then
			str = "2"
		elseif game:GetService("Workspace").Map.HeavenlyDimension.Torch3.ProximityPrompt.Enabled then
			str = "3"
		else
			str = nil
		end

		return str
	end

	DetectMobCDK = function()
		for _, child in pairs(game.Workspace.Enemies:GetChildren()) do
			local humanoid = child:IsA("Model") and child:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") and localPlayer:DistanceFromCharacter(child.HumanoidRootPart.Position) < 300 then
				return child
			end
		end
	end

	DetectMobHell = function()
		local v_11 = next
		local children, v_12 = game.Workspace.Enemies:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			local humanoid = v_13:IsA("Model") and v_13:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 and v_13:FindFirstChild("HumanoidRootPart") and localPlayer:DistanceFromCharacter(v_13.HumanoidRootPart.Position) < 300 then
				return v_13
			end
		end
	end

	Questgood5 = function()
		if (game:GetService("Workspace")._WorldOrigin.Locations["Heavenly Dimension"].Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude < 1000 then
			if game:GetService("Workspace").Map.HeavenlyDimension.Exit.BrickColor == BrickColor.new("Cloudy grey") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame
				toTarget(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
				return
			end

			if DetectMobCDK() then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						local v_11 = DetectMobHell()
						sizepart(v_11)
						equiptool(NameWeapon("Sword"))
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						getgenv().ClickM1(v_11)
						if DetectMobCDK() then
							continue
						end
					end

					break
				end
			else
				local v_11 = TourchGood5()

				if v_11 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if (localPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace").Map.HeavenlyDimension["Torch" .. v_11].Position).Magnitude > 5 then
								toTarget(game:GetService("Workspace").Map.HeavenlyDimension["Torch" .. v_11].CFrame)
							else
								fireproximityprompt(game:GetService("Workspace").Map.HeavenlyDimension["Torch" .. v_11].ProximityPrompt, 0)
								fireproximityprompt(game:GetService("Workspace").Map.HeavenlyDimension["Torch" .. v_11].ProximityPrompt, 1)
							end

							if not DetectMobCDK() then
								continue
							end
						end

						break
					end

					localPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
				end
			end
		elseif CheckNameBoss("Cake Queen") then
			local v_11 = CheckNameBoss("Cake Queen")

			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					sizepart(v_11)
					equiptool(NameWeapon("Sword"))
					ClickM1(v_11)

					if Settings["Select Weapon"] == "Blox Fruit" then
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
					else
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
					end

					if not (not IsMobAlive(v_11) or not Settings["Auto CDK"]) then
						continue
					end
				end

				break
			end

			TweenManager.CancelCurrent()
		else
			if Settings["Select Method Hop CDK1"] and Settings["Select Method Hop CDK1"]["Find Cake Queen"] then
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Hop Server Find Cake Queen\"", ShowTime = 5 })
				HopServer()
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Wating Cake Queen\"", ShowTime = 5 })
			end

			wait(5)
		end
	end

	QuestEvil3 = function()
		local v_11 = next
		local children, v_12 = game.workspace.Enemies:GetChildren()
		local v_13 = nil

		for _, v_14 in v_11, children, v_12 do
			if v_14:IsA("Model") and v_14.Name == "Marine Commodore" and v_14:FindFirstChild("HumanoidRootPart") and v_14.Humanoid.Health > 0 then
				v_13 = v_14
			end
		end

		if not v_13 then
			GetPart = DetectPartSpawnMob("Marine Commodore")
			toTarget(GetPart.CFrame * CFrame.new(0, 60, 0))
		else
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
					if not (localPlayer.Character.Humanoid.Health <= 0) then
						continue
					end
				end

				break
			end
		end
	end

	DetectMobPhaze = function()
		local v_11 = next
		local children, v_12 = game.workspace.Enemies:GetChildren()
		local v_13 = nil

		for _, v_14 in v_11, children, v_12 do
			local humanoid = v_14:IsA("Model") and v_14:FindFirstChildOfClass("Humanoid")

			if v_14:IsA("Model") and v_14:FindFirstChild("HumanoidRootPart") and v_14:FindFirstChild("HazeESP") and humanoid and humanoid.Health > 0 then
				v_13 = v_14
			end
		end

		return v_13
	end

	checknearstpartmobspawn = function()
		local v_11 = next
		local children, v_12 = game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13.Value > 0 then
				return v_13.Name
			end
		end
	end

	QuestEvil4 = function()
		if DetectMob(checknearstpartmobspawn()) then
			local v_11 = DetectMob(checknearstpartmobspawn())

			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					sizepart(v_11)
					BringMob(v_11)
					equiptool(NameWeapon("Sword"))
					ClickM1(v_11)

					if Settings["Select Weapon"] == "Blox Fruit" then
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
					else
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
					end

					if not (not v_11 or not v_11.Parent or v_11.Humanoid.Health == 0) then
						continue
					end
				end

				break
			end
		else
			GetPart = DetectPartSpawnMob(checknearstpartmobspawn())
			toTarget(GetPart.CFrame * CFrame.new(0, 15, 0))
		end
	end

	TourchEvil5 = function()
		local str

		if game:GetService("Workspace").Map.HellDimension.Torch1.ProximityPrompt.Enabled then
			str = "1"
		elseif game:GetService("Workspace").Map.HellDimension.Torch2.ProximityPrompt.Enabled then
			str = "2"
		elseif game:GetService("Workspace").Map.HellDimension.Torch3.ProximityPrompt.Enabled then
			str = "3"
		else
			str = nil
		end

		return str
	end

	QuestEvil5 = function()
		if (game:GetService("Workspace")._WorldOrigin.Locations["Hell Dimension"].Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
			if not CheckNameBoss("Soul Reaper") then
				if not localPlayer.Character:FindFirstChild("Hallow Essence") and not localPlayer.Backpack:FindFirstChild("Hallow Essence") then
					local v_11 = DetectMob(tbl5)

					if v_11 then
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_11)
								BringMob(v_11)
								equiptool(NameWeapon("Sword"))
								ClickM1(v_11)

								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								end

								if not (not IsMobAlive(v_11) or not Settings["Auto CDK"]) then
									continue
								end
							end

							break
						end
					elseif typeof(tbl5) == "table" then
						if #tbl5 <= #tbl4 then
							tbl4 = {}
							return
						end
						local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl5))

						if v_12 then
							table.insert(tbl4, DetectNameTablePart(tbl5))

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
									if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto CDK"]) then
										continue
									end
								end

								break
							end

							wait(1)
						end
					else
						local v_12 = DetectPartSpawnMob(tbl5, true)

						if v_12 then
							Instance.new("IntValue", v_12).Name = "Ignored"

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
									if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto CDK"]) then
										continue
									end
								end

								break
							end

							wait(1)
						else
							DeleteIgnoredMobSpawn()
						end
					end
				elseif (localPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.Position).Magnitude > 8 then
					toTarget(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
				else
					equiptool("Hallow Essence", true)
				end
			else
				local v_11 = CheckNameBoss("Soul Reaper")

				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
						local flag5 = localPlayer.Character.Humanoid.Health <= 0

						if not flag5 then
							local position = localPlayer.Character.HumanoidRootPart.Position
							flag5 = (game:GetService("Workspace")._WorldOrigin.Locations["Hell Dimension"].Position - position).Magnitude < 1000
						end

						if not flag5 then
							continue
						end
					end

					break
				end

				TweenManager.CancelCurrent()
				local now = tick()

				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						local flag5 = tick() - now >= 5

						if not flag5 then
							local position = localPlayer.Character.HumanoidRootPart.Position
							flag5 = (game:GetService("Workspace")._WorldOrigin.Locations["Hell Dimension"].Position - position).Magnitude < 1000
						end

						if not flag5 then
							continue
						end
					end

					break
				end
			end
		else
			if game:GetService("Workspace").Map.HellDimension.Exit.BrickColor == BrickColor.new("Olivine") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Map.HellDimension.Exit.CFrame
				toTarget(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
				return
			end

			if DetectMobCDK() then
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						local v_11 = DetectMobHell()
						sizepart(v_11)
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						equiptool(NameWeapon("Sword"))
						getgenv().ClickM1(v_11)
						if DetectMobCDK() then
							continue
						end
					end

					break
				end
			else
				local v_11 = TourchEvil5()

				if v_11 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if (localPlayer.Character.HumanoidRootPart.Position - game:GetService("Workspace").Map.HellDimension["Torch" .. v_11].Position).Magnitude > 5 then
								toTarget(game:GetService("Workspace").Map.HellDimension["Torch" .. v_11].CFrame)
							else
								fireproximityprompt(game:GetService("Workspace").Map.HellDimension["Torch" .. v_11].ProximityPrompt, 0)
								fireproximityprompt(game:GetService("Workspace").Map.HellDimension["Torch" .. v_11].ProximityPrompt, 1)
							end

							if not DetectMobCDK() then
								continue
							end
						end

						break
					end

					localPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)
				end
			end
		end
	end

	CheckMasterSword = function(arg, arg2)
		local v_11 = next
		local v_12, v_13 = fn6()

		for _, v_14 in v_11, v_12, v_13 do
			if v_14.Type == "Sword" and v_14.Name == arg and v_14.Mastery >= arg2 then
				return true
			end
		end

		return false
	end

	GetCDK = function()
		if not CheckItemInventory("Tushita") or not CheckItemInventory("Yama") then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Get Tushita and Yama", ShowTime = 5 })
			wait(5)
			return
		end

		if CheckItemInventory("Tushita") and CheckItemInventory("Yama") then
			if not CheckMasterSword("Yama", 350) or not CheckMasterSword("Tushita", 350) then
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Mastery >= 350", ShowTime = 5 })
				wait(5)
				return
			end

			if not localPlayer.Character:FindFirstChild("Tushita") and not localPlayer.Backpack:FindFirstChild("Tushita") and not localPlayer.Character:FindFirstChild("Yama") and not localPlayer.Backpack:FindFirstChild("Yama") then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Tushita")
				return
			end
			local commF = game.ReplicatedStorage.Remotes.CommF_
			getgenv().Good = commF:InvokeServer("CDKQuest", "Progress", "Good").Good
			local commF2 = game.ReplicatedStorage.Remotes.CommF_
			getgenv().Evil = commF2:InvokeServer("CDKQuest", "Progress", "Good").Evil
			local str

			if getgenv().Good == 4 and getgenv().Evil == 3 then
				str = "Pedestal2"
			elseif getgenv().Good == 3 and getgenv().Evil == 4 then
				str = "Pedestal1"
			else
				str = nil
			end

			if str then
				local v_11 = game
				local position = localPlayer.Character.HumanoidRootPart.Position

				if (v_11:GetService("Workspace").Map.Turtle.Cursed[str].Position - position).Magnitude < 10 then
					fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed[str].ProximityPrompt)
				else
					toTarget(game:GetService("Workspace").Map.Turtle.Cursed[str].CFrame)
				end
			end

			if localPlayer.PlayerGui.Main.Dialogue.Visible then
				game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
				game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
			end

			if getgenv().Good == 4 and getgenv().Evil == 4 then
				local v_11 = game
				local position = localPlayer.Character.HumanoidRootPart.Position

				if (v_11:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.Position - position).Magnitude > 10 then
					toTarget(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.CFrame)
				elseif game:GetService("Workspace").Map.Turtle.Cursed.PlacedGem.Transparency == 0 then
					if not game.Workspace.Enemies:FindFirstChild("Cursed Skeleton Boss") then
						toTarget(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125))
					else
						local v_12 = next
						local children, v_13 = game.Workspace.Enemies:GetChildren()

						for _, v_14 in v_12, children, v_13 do
							if v_14:IsA("Model") and v_14.Name == "Cursed Skeleton Boss" and v_14.Humanoid.Health > 0 then
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_14)
										equiptool(NameWeapon("Sword"))
										ClickM1(v_14)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_14.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										if not (not v_14 or not v_14.Parent or v_14.Humanoid.Health <= 0) then
											continue
										end
									end

									break
								end
							end
						end
					end
				else
					fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.ProximityPrompt)
				end
			end

			if getgenv().Good ~= 4 and getgenv().Good ~= -2 then
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")

				if getgenv().Good == -3 then
					QuestGood3()
				elseif getgenv().Good == -4 then
					QuestGood4()
				elseif getgenv().Good == -5 then
					Questgood5()
				end
			else
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")

				if getgenv().Evil == -3 then
					QuestEvil3()
				elseif getgenv().Evil == -4 then
					QuestEvil4()
				elseif getgenv().Evil == -5 then
					spawn(function()
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
					end)

					QuestEvil5()
				end
			end
		end
	end

	MethodHopCDk = {
		["Find Cake Queen"] = false,
		["Hop Raid Castle [ Delay 20s Hop Because check Raids Castle ]"] = false,
	}

	GetItemsSection.CreateDropdown({
		Title = "Select Method Hop CDK",
		List = PrepareMultiSelectList(MethodHopCDk, Settings["Select Method Hop CDK1"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Method Hop CDK1"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Method Hop CDK1", arg, arg2)
	end)

	GetItemsSection.CreateToggle({ Title = "Auto CDK", Desc = nil, Default = Settings["Auto CDK"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto CDK"] and task.wait(0.1) do
					local ok, result = pcall(function()
						GetCDK()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto CDK", arg)
	end)

	GetYama = function()
		if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") < 30 then
			local v_11 = DetectEliteHunter()

			if v_11 then
				EnsureEliteQuest(v_11.Name)

				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not Settings["Auto Yama"] then
							TweenManager.CancelCurrent()
							break
						else
							sizepart(v_11)
							local humanoidRootPart2 = v_11:FindFirstChild("HumanoidRootPart", true) or v_11.PrimaryPart

							if humanoidRootPart2 then
								if Settings["Select Weapon"] == "Blox Fruit" then
									toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
								else
									toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
								end
							end

							UsedualFlock()
							ClickM1(v_11)
							if not (not IsMobAlive(v_11) or not Settings["Auto Yama"]) then
								continue
							end
						end
					end

					break
				end
			end
		else
			if not game.Workspace.Map:FindFirstChild("Waterfall") or not game.Workspace.Map.Waterfall:FindFirstChild("SealedKatana") then
				local v_11 = toTarget
				local cframe3 = CFrame.new(5251.900390625, 17.18115234375, 453.6025390625)
				v_11(cframe3)
				return
			end

			if (game.Workspace.Map.Waterfall.SealedKatana.WorldPivot.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 50 then
				toTarget(game.Workspace.Map.Waterfall.SealedKatana.WorldPivot)
			elseif game.Workspace.Enemies:FindFirstChild("Ghost") then
				local Ghost = DetectMob("Ghost")

				if Ghost then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(Ghost)
							BringMob(Ghost)
							UsedualFlock()
							ClickM1(Ghost)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(Ghost.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(Ghost.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							if not (not IsMobAlive(Ghost) or not Settings["Auto Yama"]) then
								continue
							end
						end

						break
					end
				end
			else
				fireclickdetector(workspace.Map.Waterfall.SealedKatana.Hitbox.ClickDetector)
			end
		end
	end

	GetItemsSection.CreateToggle({ Title = "Auto Yama", Desc = nil, Default = Settings["Auto Yama"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Yama"] and task.wait(0.1) do
					local ok, result = pcall(function()
						GetYama()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Yama", arg)
	end)

	checkTorch = function()
		local str

		if not game:GetService("Workspace").Map.Turtle.QuestTorches.Torch1.Particles.Main.Enabled then
			str = "1"
		elseif not game:GetService("Workspace").Map.Turtle.QuestTorches.Torch2.Particles.Main.Enabled then
			str = "2"
		elseif not game:GetService("Workspace").Map.Turtle.QuestTorches.Torch3.Particles.Main.Enabled then
			str = "3"
		elseif not game:GetService("Workspace").Map.Turtle.QuestTorches.Torch4.Particles.Main.Enabled then
			str = "4"
		elseif not game:GetService("Workspace").Map.Turtle.QuestTorches.Torch5.Particles.Main.Enabled then
			str = "5"
		else
			str = nil
		end

		local v_11 = next
		local children, v_12 = game:GetService("Workspace").Map.Turtle.QuestTorches:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("MeshPart") and string.find(v_13.Name, str) and not v_13.Particles.Main.Enabled then
				return v_13
			end
		end
	end

	GetHitBoxTouch = function()
		local hitbox = workspace.Map:FindFirstChild("Waterfall") and game.Workspace.Map.Waterfall:FindFirstChild("IslandModel") and workspace.Map.Waterfall.IslandModel:FindFirstChild("Hitbox", true)
		if hitbox then
			return hitbox
		end
		local v_11 = next
		local v_12, v_13 = getnilinstances()

		for _, v_14 in v_11, v_12, v_13 do
			if v_14.Name == "Hitbox" then
				if (v_14.Position - Vector3.new(5713.5376, 38.383118, 255.2017)).Magnitude == 0 then
					return v_14
				end
			end
		end
	end

	GetTushita = function()
		local commF = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

		if commF:InvokeServer("TushitaProgress").OpenedDoor then
			if CheckNameBoss("Longma") then
				local Longma = CheckNameBoss("Longma")

				if Longma then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(Longma)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(Longma.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(Longma.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							UsedualFlock()
							ClickM1(Longma)
							if not (not IsMobAlive(Longma) or not Settings["Auto Tushita"]) then
								continue
							end
						end

						break
					end
				end
			end
		else
			local v_11 = GetHitBoxTouch()

			if not v_11 then
				local v_12 = toTarget
				local cframe3 = CFrame.new(5677.541015625, 28.533447265625, 357.9483642578125)
				v_12(cframe3)
				return
			end

			if v_11:FindFirstChild("TouchInterest") then
				if not localPlayer.Character:FindFirstChild("Holy Torch") and not localPlayer.Backpack:FindFirstChild("Holy Torch") then
					toTarget(v_11.CFrame)
				else
					equiptool("Holy Torch")

					if checkTorch() then
						for i = 1, 5 do
							commF:InvokeServer("TushitaProgress", "Torch", i)
						end

						wait(2)
					end
				end
			else
				lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Rip Indra Dont Spawn", ShowTime = 5 })
				wait(5)
			end
		end
	end

	GetItemsSection.CreateToggle({ Title = "Auto Tushita", Desc = nil, Default = Settings["Auto Tushita"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Tushita"] and task.wait() do
					local ok, result = pcall(function()
						GetTushita()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Tushita", arg)
	end)

	GetItemsSection.CreateToggle({ Title = "Auto TTK", Desc = nil, Default = Settings["Auto TTK"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto TTK"] and task.wait(0.1) do
					pcall(function()
						if not CheckMasterSword("Oroshi", 300) then
							if not DetectItemPlr("Oroshi") then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Oroshi")
							end
						elseif not CheckMasterSword("Saishi", 300) then
							if not DetectItemPlr("Saishi") then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Saishi")
							end
						elseif not CheckMasterSword("Shizu", 300) then
							if not DetectItemPlr("Shizu") then
								game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Shizu")
							end
						elseif not DetectItemPlr("True Triple Katana") then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("MysteriousMan", "2")
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "True Triple Katana")
						end

						local v_11 = DetectMob(tbl5)

						if v_11 then
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(v_11)
									BringMob(v_11)
									equiptool(NameWeapon("Sword"))
									ClickM1(v_11)

									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
									end

									if not (not IsMobAlive(v_11) or not Settings["Auto TTK"]) then
										continue
									end
								end

								break
							end
						elseif typeof(tbl5) == "table" then
							if #tbl4 >= #tbl5 then
								tbl4 = {}
								return
							end
							local v_12 = DetectPartSpawnMob(DetectNameTablePart(tbl5))

							if v_12 then
								table.insert(tbl4, DetectNameTablePart(tbl5))

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
										if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto TTK"]) then
											continue
										end
									end

									break
								end

								wait(1)
							end
						else
							local v_12 = DetectPartSpawnMob(tbl5, true)

							if v_12 then
								Instance.new("IntValue", v_12).Name = "Ignored"

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_12.CFrame * CFrame.new(0, 60, 0))
										if not ((v_12.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl5) or not Settings["Auto TTK"]) then
											continue
										end
									end

									break
								end

								wait(1)
							else
								DeleteIgnoredMobSpawn()
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Auto TTK", arg)
	end)

	doorcup = function()
		local v_11 = next
		local children, v_12 = game:GetService("Workspace").Map.Desert.Burn:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Part") and not v_13.CanCollide then
				return true
			end
		end

		return false
	end

	doorsaber = function()
		local v_11 = next
		local children, v_12 = game:GetService("Workspace").Map.Jungle.Final:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Part") and not v_13.CanCollide then
				return true
			end
		end

		return false
	end

	doortourch = function()
		local v_11 = next
		local children, v_12 = game:GetService("Workspace").Map.Jungle.QuestPlates:GetChildren()

		for _, v_13 in v_11, children, v_12 do
			if v_13:IsA("Model") then
				if v_13.Button:FindFirstChild("TouchInterest") then
					return v_13
				end
			end
		end
	end

	SaberSword = function()
		if localPlayer.Data.Level.Value >= 200 then
			if not doorsaber() then
				if game:GetService("Workspace").Map.Jungle.QuestPlates.Door.CanCollide then
					toTarget(doortourch().Button.CFrame)
				elseif doorcup() then
					if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= 0 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") ~= 1 then
						if not localPlayer.Character:FindFirstChild("Cup") and not localPlayer.Backpack:FindFirstChild("Cup") then
							if (localPlayer.Character.HumanoidRootPart.Position - CFrame.new(1112.46521, 4.92147732, 4364.55469, -0.743286014, -4.82822775e-11, -0.668973804, 4.62103383e-10, 1, -5.85609283e-10, 0.668973804, -7.444102e-10, -0.743286014).Position).Magnitude < 5 then
								toTarget(CFrame.new(1113.66992, 7.5484705, 4365.27832, -0.78613919, -2.19578524e-08, -0.618049502, 1.02977182e-09, 1, -3.68374984e-08, 0.618049502, -2.95958493e-08, -0.78613919))
								local humanoidRootPart2 = game.Players.LocalPlayer.Character.HumanoidRootPart
								firetouchinterest(game:GetService("Workspace").Map.Desert.Cup, humanoidRootPart2, 0)
								local humanoidRootPart3 = game.Players.LocalPlayer.Character.HumanoidRootPart
								firetouchinterest(game:GetService("Workspace").Map.Desert.Cup, humanoidRootPart3, 1)
								return
							end

							toTarget(CFrame.new(1112.46521, 4.92147732, 4364.55469, -0.743286014, -4.82822775e-11, -0.668973804, 4.62103383e-10, 1, -5.85609283e-10, 0.668973804, -7.444102e-10, -0.743286014))
						else
							equiptool("Cup")

							if localPlayer.Backpack:FindFirstChild("Cup") and localPlayer.Backpack.Cup.Handle:FindFirstChild("TouchInterest") or localPlayer.Character:FindFirstChild("Cup") and localPlayer.Character.Cup.Handle:FindFirstChild("TouchInterest") then
								toTarget(CFrame.new(1395.77307, 37.4733238, -1324.34631, -0.999978602, -6.53588605e-09, 0.00654155109, -6.57083277e-09, 1, -5.32077493e-09, -0.00654155109, -5.3636442e-09, -0.999978602))
							elseif localPlayer.Backpack:FindFirstChild("Cup") and not localPlayer.Backpack.Cup.Handle:FindFirstChild("TouchInterest") or localPlayer.Character:FindFirstChild("Cup") and not localPlayer.Character.Cup.Handle:FindFirstChild("TouchInterest") then
								if (localPlayer.Character.HumanoidRootPart.Position - Vector3.new(1457.8768, 88.3775, -1390.6892)).Magnitude > 8 then
									toTarget(CFrame.new(1457.8768310547, 88.377502441406, -1390.6892089844))
								else
									game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
								end
							end
						end
					elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 0 then
						local v_11 = CheckNameBoss("Mob Leader")

						if v_11 then
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(v_11)

									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
									end

									UsedualFlock()
									ClickM1(v_11)
									if not (not IsMobAlive(v_11) or not Settings["Auto Saber"]) then
										continue
									end
								end

								break
							end
						end
					elseif game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
						if not localPlayer.Character:FindFirstChild("Relic") and not localPlayer.Backpack:FindFirstChild("Relic") then
							if (localPlayer.Character.HumanoidRootPart.Position - CFrame.new(-1404.07996, 29.8520069, 5.26677656, 0.888123989, -4.0340602e-09, 0.459603906, 7.5884703e-09, 1, -5.8864642e-09, -0.459603906, 8.71560069e-09, 0.888123989)).Magnitude > 8 then
								toTarget(CFrame.new(-1404.07996, 29.8520069, 5.26677656, 0.888123989, -4.0340602e-09, 0.459603906, 7.5884703e-09, 1, -5.8864642e-09, -0.459603906, 8.71560069e-09, 0.888123989))
							else
								game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
							end
						else
							equiptool("Relic")
							toTarget(CFrame.new(-1405.3677978516, 29.977333068848, 4.5685839653015))
						end
					end
				elseif not localPlayer.Character:FindFirstChild("Torch") and not localPlayer.Backpack:FindFirstChild("Torch") then
					toTarget(game:GetService("Workspace").Map.Jungle.Torch.CFrame)
				else
					equiptool("Torch")

					if (localPlayer.Character.HumanoidRootPart.Position - CFrame.new(1115.23499, 4.92147732, 4349.36963, -0.670654476, -2.18307523e-08, 0.74176991, -9.06980624e-09, 1, 2.1230365e-08, -0.74176991, 7.51052998e-09, -0.670654476).Position).Magnitude < 5 then
						toTarget(CFrame.new(1114.59863, 4.92147732, 4350.64258, -0.508235395, 1.00975717e-09, 0.861218214, 7.77848985e-09, 1, 3.41788708e-09, -0.861218214, 8.43606784e-09, -0.508235395))
						firetouchinterest(game.Players.LocalPlayer.Character.Torch.Handle, game:GetService("Workspace").Map.Desert.Burn.Fire, 0)
						firetouchinterest(game.Players.LocalPlayer.Character.Torch.Handle, game:GetService("Workspace").Map.Desert.Burn.Fire, 1)
						return
					end

					toTarget(CFrame.new(1115.23499, 4.92147732, 4349.36963, -0.670654476, -2.18307523e-08, 0.74176991, -9.06980624e-09, 1, 2.1230365e-08, -0.74176991, 7.51052998e-09, -0.670654476))
				end
			else
				local v_11 = CheckNameBoss("Saber Expert")

				if v_11 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_11)

							if Settings["Select Weapon"] == "Blox Fruit" then
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
							else
								toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
							end

							UsedualFlock()
							ClickM1(v_11)
							if not (not IsMobAlive(v_11) or not Settings["Auto Saber"]) then
								continue
							end
						end

						break
					end
				end
			end
		end
	end

	GetItemsSection.CreateToggle({ Title = "Auto Saber", Desc = nil, Default = Settings["Auto Saber"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Saber"] and task.wait(0.1) do
					pcall(function()
						SaberSword()
					end)
				end
			end)
		end

		SaveSettings("Auto Saber", arg)
	end)

	autoCraftSharkAnchor = function()
		if CheckItemInventory("Shark Anchor") then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done Shark Anchor", ShowTime = 5 })
			wait(5)
			return
		end

		if not CheckItemInventory("Monster Magnet") then
			if not CheckItemInventory("Shark Tooth Necklace") and CheckCountItem("Mutant Tooth", 1) and CheckCountItem("Shark Tooth", 5) then
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", "ToothNecklace", 1, {} }))
			elseif not CheckItemInventory("Terror Jaw") and CheckCountItem("Mutant Tooth", 2) and CheckCountItem("Shark Tooth", 5) and CheckCountItem("Terror Eyes", 1) and CheckCountItem("Fool's Gold", 10) then
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", "TerrorJaw", 1, {} }))
			elseif CheckItemInventory("Shark Tooth Necklace") and CheckItemInventory("Terror Jaw") and CheckCountItem("Terror Eyes", 2) and CheckCountItem("Shark Tooth", 10) and CheckCountItem("Electric Wing", 10) and CheckCountItem("Fool's Gold", 20) then
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", "SharkAnchor", 1, {} }))
			end
		end
	end

	GetItemsSection.CreateToggle({
		Title = "Auto Craft Item Shark Anchor",
		Desc = nil,
		Default = Settings["Auto Craft Item Shark Anchor"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Craft Item Shark Anchor"] and wait(0.1) do
					pcall(function()
						autoCraftSharkAnchor()
					end)
				end
			end)
		end

		SaveSettings("Auto Craft Item Shark Anchor", arg)
	end)

	AutoYorumini = function()
		if CheckItemInventory("Dark Dagger") then
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "u haved Yoru Mini", ShowTime = 5 })
			return
		end
		local v_11 = CheckNameBoss("rip_indra True Form")

		if v_11 then
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					sizepart(v_11)

					if Settings["Select Weapon"] == "Blox Fruit" then
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
					else
						toTarget(v_11.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
					end

					UsedualFlock()
					ClickM1(v_11)
					if not (not IsMobAlive(v_11) or not Settings["Auto Yoru Mini"]) then
						continue
					end
				end

				break
			end
		elseif not DetectItemPlr("God's Chalice") then
			elitehunter = DetectEliteHunter()

			if elitehunter then
				local v_12 = elitehunter

				if v_12 then
					EnsureEliteQuest(v_12.Name)

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if not Settings["Auto Yoru Mini"] then
								TweenManager.CancelCurrent()
								break
							else
								sizepart(v_12)
								local humanoidRootPart2 = v_12:FindFirstChild("HumanoidRootPart", true) or v_12.PrimaryPart

								if humanoidRootPart2 then
									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
									end
								end

								UsedualFlock()
								ClickM1(v_12)
								if not (not IsMobAlive(v_12) or not Settings["Auto Yoru Mini"]) then
									continue
								end
							end
						end

						break
					end
				end
			else
				if n3 and n3 >= (Settings["Value Collect Chest to Hop"] or 20) and Settings["Auto Yoru Mini (Hop Server)"] then
					HopServer()
					return
				end
				local v_12 = GetNearestChest()

				if v_12 then
					n3 += 1
					local now = nil

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v_12.Position).Magnitude <= 5 then
								if not now then
									now = tick()
								elseif tick() - now >= 5 then
									Instance.new("IntValue", v_12).Name = "Ignored"
									wait(0.5)
								end

								game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
								wait()
								game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
								TweenManager.CancelCurrent()
							end

							toTarget(v_12.CFrame, true)
							if not (not v_12 or not v_12.Parent or not Settings["Auto Yoru Mini"] or v_12:GetAttribute("IsDisabled") or v_12:FindFirstChild("Ignored") or not v_12:FindFirstChild("TouchInterest")) then
								continue
							end
						end

						break
					end
				else
					local v_13 = PathFindChest()

					if v_13 then
						toTarget(v_13.Part.CFrame)

						if (v_13.Part.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or GetNearestChest() then
							Instance.new("IntValue", v_13).Name = "Ignored"
						end
					else
						print("delete")

						for _, child in pairs(game:GetService("Workspace")._WorldOrigin.PlayerSpawns.Pirates:GetChildren()) do
							if child:FindFirstChild("Ignored") then
								child:FindFirstChild("Ignored"):Destroy()
							end
						end
					end
				end
			end
		else
			n3 = Settings["Value Collect Chest to Hop"] or 20

			if not IsMisisngLegHaki() and DetectButtons() then
				TouchPadHaki()
			elseif not DetectButtons() then
				equiptool("God's Chalice")
				toTarget(game:GetService("Workspace").Map["Boat Castle"].Summoner.Detection.CFrame)
			end
		end
	end

	GetItemsSection.CreateToggle({
		Title = "Auto Yoru Mini",
		Desc = [[u need have 3 haki legendary,
it will auto chest, kill Elite Hunter Find Chalice,
Summon And Kill Rip Indra]],
		Default = Settings["Auto Yoru Mini"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Yoru Mini"] and wait(0.1) do
					pcall(function()
						AutoYorumini()
					end)
				end
			end)
		end

		SaveSettings("Auto Yoru Mini", arg)
	end)

	GetItemsSection.CreateToggle({
		Title = "Auto Yoru Mini (Hop Server)",
		Desc = "u can change value hop chest in Tab Farming Other",
		Default = Settings["Auto Yoru Mini"] or false,
	}, function(arg)
		SaveSettings("Auto Yoru Mini (Hop Server)", arg)
	end)

	MasteryWeaponSection = GetItemsMain.CreateSection("Mastery Weapon")
	BlMeleeFarmMastery = {}

	TableMelees = {
		Superhuman = 1,
		["Death Step"] = 2,
		["Sharkman Karate"] = 3,
		["Electric Claw"] = 4,
		["Dragon Talon"] = 5,
		["Black Leg"] = 6,
		["Fishman Karate"] = 7,
		Electro = 8,
		["Dragon Claw"] = 9,
	}

	DetectMeleeFarmMastery = function()
		local huge = math.huge
		local v_11

		for k, v_12 in next, TableMelees, nil do
			if not table.find(BlMeleeFarmMastery, k) then
				if v_12 < huge then
					huge = v_12
					v_11 = k
				end
			end
		end

		return v_11
	end

	CheckMasteryMelee = function(arg)
		for _, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if child:IsA("Tool") and (arg and child.Name == arg or not arg and child.ToolTip == "Melee") then
				return child.Level.Value
			end
		end

		for _, child in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			local isTool = child:IsA("Tool")
			local flag5

			if isTool then
				local flag6 = arg and child.Name == arg

				if flag6 then
					flag5 = flag6
				else
					flag5 = not arg and child.ToolTip == "Melee"
				end
			else
				flag5 = isTool
			end

			if flag5 then
				return child.Level.Value
			end
		end
	end

	MasteryWeaponSection.CreateToggle({
		Title = "Auto Farm Mastery 600 Melees",
		Desc = nil,
		Default = Settings["Auto Farm Mastery 600 Melees"] or false,
	}, function(arg)
		if arg then
			flag = true
			v_10:SetStage(true)
			v_7:SetValue("Melee")
		elseif not arg and flag then
			v_10:SetStage(false)
			flag = false
		end

		if arg then
			spawn(function()
				while Settings["Auto Farm Mastery 600 Melees"] and task.wait() do
					local ok, result = pcall(function()
						local v_11 = DetectMeleeFarmMastery()

						if not game.Players.LocalPlayer.Character:FindFirstChild(v_11) and not game.Players.LocalPlayer.Backpack:FindFirstChild(v_11) then
							if v_11 == "Dragon Claw" then
								game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
								game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
								return
							end

							game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buy" .. string.gsub(v_11, " ", ""))
						elseif CheckMasteryMelee(v_11) >= 600 then
							table.insert(BlMeleeFarmMastery, v_11)
						end
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Farm Mastery 600 Melees", arg)
	end)

	DetectSwordUnlock = function()
		local v_11 = next
		local v_12, v_13 = fn6()
		local n7 = 0
		local name = nil

		for _, v_14 in v_11, v_12, v_13 do
			if v_14.Type == "Sword" and 600 > v_14.Mastery then
				if n7 < v_14.Rarity then
					n7 = v_14.Rarity
					name = v_14.Name
				end
			end
		end

		return name
	end

	MasteryWeaponSection.CreateToggle({
		Title = "Auto Farm Mastery 600 Sword In Inventory",
		Desc = nil,
		Default = Settings["Auto Farm Mastery 600 Sword In Inventory"] or false,
	}, function(arg)
		if arg then
			flag = true
			v_10:SetStage(true)
			v_7:SetValue("Sword")
		elseif not arg and flag then
			v_10:SetStage(false)
			flag = false
		end

		if arg then
			spawn(function()
				while Settings["Auto Farm Mastery 600 Sword In Inventory"] and task.wait() do
					pcall(function()
						local v_11 = DetectSwordUnlock()

						if v_11 and not localPlayer.Backpack:FindFirstChild(v_11) and not localPlayer.Character:FindFirstChild(v_11) then
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", v_11)
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Farm Mastery 600 Sword In Inventory", arg)
	end)

	UpgradeWeaponSection = GetItemsMain.CreateSection("Upgrade Weapon")
	local createLabel2 = UpgradeWeaponSection.CreateLabel
	getgenv().StatusUpgradeWP = createLabel2({ Title = "" })

	DetectGunUnlock = function()
		local v_11 = next
		local v_12, v_13 = fn6()
		local n7 = 0
		local name = nil

		for _, v_14 in v_11, v_12, v_13 do
			if v_14.Type == "Gun" and 600 > v_14.Mastery then
				if n7 < v_14.Rarity then
					n7 = v_14.Rarity
					name = v_14.Name
				end
			end
		end

		return name
	end

	DetectItemUpgrade = function(arg)
		local tbl12 = {}

		local tbl13 = {
			"UpgradeItem",
			"Check",
			game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(NameWeapon(arg)) or game:GetService("Players").LocalPlayer.Character:FindFirstChild(NameWeapon(arg)),
		}

		for _, v_11 in next, game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(tbl13)).Required, nil do
			tbl12[v_11.Name] = v_11.Required
		end

		tbl12.NameWp = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(tbl13)).Result.Name
		tbl12.Physical = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(tbl13)).Result.Physical
		return tbl12
	end

	DetectNameWpUpgrade = function(arg)
		local v_11 = next
		local v_12, v_13 = fn6()
		local n7 = 0
		local name = nil

		if type(v_12) == "table" then
			for _, v_14 in v_11, v_12, v_13 do
				if type(v_14) == "table" and v_14.Type == arg and v_14.Upgrades == 0 then
					local rarity = v_14.Rarity or 0

					if n7 < rarity then
						name = v_14.Name
						n7 = rarity
					else
						local name2

						if n7 == rarity then
							name2 = v_14.Name
						else
							name2 = name
						end

						name = name2
					end
				end
			end
		end

		if not name then
			pcall(function()
				local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("getInventoryWeapons")

				if type(response) == "table" then
					for _, v_14 in pairs(response) do
						if type(v_14) == "table" and v_14.Type == arg and (v_14.Upgrades == 0 or not v_14.Upgrades) then
							local rarity = v_14.Rarity or 0

							if n7 < rarity then
								local name2 = v_14.Name
								n7 = rarity
								name = name2
							elseif n7 == rarity and not name then
								name = v_14.Name
							end
						end
					end
				end
			end)
		end

		return name
	end

	local n7 = nil
	local v_11 = nil

	DetectMaterialsUpgrade = function()
		for k, v_12 in next, v_11, nil do
			if k ~= "NameWp" and k ~= "Physical" and not CheckCountItem(k, v_12) and k ~= "Dark Fragment" and NameWorldMaterials[k] and NameWorldMaterials[k][game.PlaceId] then
				return k
			end
		end

		for k, v_12 in next, v_11, nil do
			if k ~= "NameWp" and k ~= "Physical" and not CheckCountItem(k, v_12) then
				return k
			end
		end
	end

	AutoUpgradeWeapon = function(arg)
		local v_12 = DetectNameWpUpgrade(arg)

		if not v_12 then
			if getgenv().StatusUpgradeWP then
				StatusUpgradeWP.SetText("No " .. tostring(arg) .. " to upgrade")
			end

			return
		end

		if NameWeapon(arg) ~= v_12 then
			if getgenv().StatusUpgradeWP then
				StatusUpgradeWP.SetText("Change Weapon: " .. tostring(v_12))
			end

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", v_12)
			return
		end

		if not v_11 or v_11.NameWp ~= v_12 then
			if not n7 then
				for _, descendant in pairs(game.Workspace.NPCs:GetDescendants()) do
					if descendant:IsA("Model") and descendant.Name == "Blacksmith" and descendant:FindFirstChild("Head") then
						n7 = descendant.Head.CFrame * CFrame.new(0, -2, 2)
					end
				end

				for _, descendant in pairs(game:GetService("ReplicatedStorage").NPCs:GetDescendants()) do
					if descendant:IsA("Model") and descendant.Name == "Blacksmith" and descendant:FindFirstChild("Head") and not n7 then
						n7 = descendant.Head.CFrame * CFrame.new(0, -2, 2)
					end
				end
			else
				if getgenv().StatusUpgradeWP then
					StatusUpgradeWP.SetText("Get info Upgrade WP")
				end

				if localPlayer:DistanceFromCharacter(n7.Position) > 10 then
					toTarget(n7, true)
				else
					v_11 = DetectItemUpgrade(arg)
				end
			end

			return
		end

		local v_13

		if v_11 then
			v_13 = DetectMaterialsUpgrade()
		else
			v_13 = nil
		end

		if v_11 and not v_13 then
			if getgenv().StatusUpgradeWP then
				StatusUpgradeWP.SetText("Go Upgrade Weapon")
			end

			toTarget(n7, true)

			if localPlayer:DistanceFromCharacter(n7.Position) < 10 then
				if game:GetService("Players").LocalPlayer.PlayerGui.Main.Craft.Visible then
					wait(1)

					for _, v_14 in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.Craft.Main.Bottom.Confirm.Activated)) do
						v_14.Function()
					end

					if not game:GetService("Players").LocalPlayer.PlayerGui.Main.Craft.Main.Bottom.Confirm.Visible then
						for _, v_14 in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Main.Craft.Main.Bottom.Close.Activated)) do
							v_14.Function()
						end
					end
				else
					local tbl12 = {
						"UpgradeItem",
						"Check",
						game:GetService("Players").LocalPlayer.Backpack:FindFirstChild(NameWeapon(arg)) or game:GetService("Players").LocalPlayer.Character:FindFirstChild(NameWeapon(arg)),
					}

					local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(tbl12))
					local required = response.Required
					local result = response.Result
					local resultStats = response.ResultStats
					v_2(game.Players.LocalPlayer.PlayerGui.Main.UIController.Craft)(required, result, resultStats)
					wait(1)
				end
			end
		end

		if v_13 then
			local v_14 = NameMaterials[v_13]

			if not v_14 then
				lib.CreateNoti({
					Title = "Banana Cat Hub",
					Desc = "Not Support Material " .. tostring(v_13) .. " Sorry",
					ShowTime = 5,
				})

				wait(5)
				return
			end

			if not NameWorldMaterials[v_13] or not NameWorldMaterials[v_13][game.PlaceId] then
				local v_15 = NameWorldMaterials[v_13] and (NameWorldMaterials[v_13][getgenv().CheckPlaceId2] or NameWorldMaterials[v_13][getgenv().CheckPlaceId3] or NameWorldMaterials[v_13][getgenv().CheckPlaceId])

				if v_15 then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(v_15)
				end

				return
			end

			if getgenv().StatusUpgradeWP then
				StatusUpgradeWP.SetText("Farm Material " .. tostring(v_13))
			end

			local v_15 = DetectMob(v_14)

			if not v_15 then
				if typeof(v_14) == "table" then
					if #v_14 <= #tbl4 then
						tbl4 = {}
						return
					end
					local v_16 = DetectPartSpawnMob(DetectNameTablePart(v_14))

					if v_16 then
						table.insert(tbl4, DetectNameTablePart(v_14))

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_16.CFrame * CFrame.new(0, 60, 0))
								if not ((v_16.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(v_14) or not Settings["Auto Upgrade Sword Inventory"] and not Settings["Auto Upgrade Gun Inventory"]) then
									continue
								end
							end

							break
						end

						wait(1)
					end
				else
					local v_16 = DetectPartSpawnMob(v_14, true)

					if v_16 then
						Instance.new("IntValue", v_16).Name = "Ignored"

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_16.CFrame * CFrame.new(0, 60, 0))
								if not ((v_16.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(v_14) or not Settings["Auto Upgrade Sword Inventory"] and not Settings["Auto Upgrade Gun Inventory"]) then
									continue
								end
							end

							break
						end

						wait(1)
					else
						DeleteIgnoredMobSpawn()
					end
				end
			else
				while true do
					task.wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						sizepart(v_15)
						BringMob(v_15)
						UsedualFlock()
						ClickM1(v_15)

						if Settings["Select Weapon"] == "Blox Fruit" then
							toTarget(v_15.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
						else
							toTarget(v_15.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
						end

						if not (not IsMobAlive(v_15) or not Settings["Auto Upgrade Sword Inventory"] and not Settings["Auto Upgrade Gun Inventory"]) then
							continue
						end
					end

					break
				end
			end
		end
	end

	UpgradeWeaponSection.CreateToggle({
		Title = "Auto Upgrade Sword Inventory",
		Desc = nil,
		Default = Settings["Auto Upgrade Sword Inventory"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Upgrade Sword Inventory"] and task.wait(0.1) do
					local ok, result = pcall(function()
						AutoUpgradeWeapon("Sword")
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Upgrade Sword Inventory", arg)
	end)

	UpgradeWeaponSection.CreateToggle({
		Title = "Auto Upgrade Gun Inventory",
		Desc = nil,
		Default = Settings["Auto Upgrade Gun Inventory"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Upgrade Gun Inventory"] and task.wait(0.1) do
					local ok, result = pcall(function()
						AutoUpgradeWeapon("Gun")
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Upgrade Gun Inventory", arg)
	end)

	VolcanoTab = Main.CreatePage({ Page_Name = "Volcano Event", Page_Title = "Volcano Event Tab" })
	SettingsVolcanoSection = VolcanoTab.CreateSection("Settings Volcano")

	SettingsVolcanoSection.CreateDropdown({
		Title = "Select Weapon Kill Golem",
		List = { "Melee", "Sword", "Blox Fruit" },
		Search = true,
		Selected = false,
		Default = Settings["Select Weapon Kill Golem"] or nil,
	}, function(arg)
		SaveSettings("Select Weapon Kill Golem", arg)
	end)

	SettingsVolcanoSection.CreateDropdown({
		Title = "Select Weapons Fix Lava",
		List = PrepareMultiSelectList(tbl6, Settings["Select Weapons Fix Lava"]),
		Search = true,
		Selected = true,
		Default = Settings["Select Weapons Fix Lava"] or nil,
	}, function(arg, arg2)
		SaveSettings("Select Weapons Fix Lava", arg, arg2)
	end)

	SettingsVolcanoSection.CreateDropdown({
		Title = "Select Method Kill Golem",
		List = { "Click M1", "Instant Kill [ Risk and can bug no die mob ]" },
		Search = true,
		Selected = false,
		Default = Settings["Select Method Kill Golem"] or nil,
	}, function(arg)
		SaveSettings("Select Method Kill Golem", arg)
	end)

	FarmingVolcanoSection = VolcanoTab.CreateSection("Farming Volcano")

	AutoCraftinMagnetVol = function()
		if not CheckItemInventory("Volcanic Magnet") then
			if not CheckCountItem("Scrap Metal", 10) then
				local tbl12 = { "Jungle Pirate" }
				local v_12 = DetectMob(tbl12)

				if not v_12 then
					if typeof(tbl12) == "table" then
						if #tbl12 <= #tbl4 then
							tbl4 = {}
							return
						end
						local v_13 = DetectPartSpawnMob(DetectNameTablePart(tbl12))

						if v_13 then
							table.insert(tbl4, DetectNameTablePart(tbl12))

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_13.CFrame * CFrame.new(0, 60, 0))
									if not ((v_13.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl12) or not Settings["Auto Crafting Volcanic Magnet"]) then
										continue
									end
								end

								break
							end

							wait(1)
						end
					end
				else
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							sizepart(v_12)
							BringMob(v_12)
							UsedualFlock()
							ClickM1(v_12)

							if IsMobAlive(v_12) then
								local humanoidRootPart2 = v_12:FindFirstChild("HumanoidRootPart")

								if humanoidRootPart2 then
									if Settings["Select Weapon"] == "Blox Fruit" then
										toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
									else
										toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
									end

									if not (not IsMobAlive(v_12) or not Settings["Auto Crafting Volcanic Magnet"]) then
										continue
									end
								end
							end
						end

						break
					end
				end

				return
			end

			if not CheckCountItem("Blaze Ember", 15) then
				local dragonHunter = DetectNpc("Dragon Hunter") or workspace.NPCs:FindFirstChild("Dragon Hunter") or game:GetService("ReplicatedStorage").NPCs:FindFirstChild("Dragon Hunter")

				if not getgenv().QuestHunterDragon then
					if localPlayer:DistanceFromCharacter(dragonHunter.HumanoidRootPart.Position) > 8 then
						toTarget(dragonHunter.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
					else
						local response = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "Check" } }))

						if not response or response and not response.Text then
							getgenv().QuestHunterDragon = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "RequestQuest" } })).Text
						else
							local text = response.Text
							getgenv().QuestHunterDragon = text
						end
					end
				else
					local v_12 = DetectEmberTemplate()

					if v_12 then
						Instance.new("IntValue", v_12).Name = "Ignored"

						while true do
							wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								toTarget(v_12.Part.CFrame)
								if not (not v_12 or not v_12.Parent or not Settings["Auto Crafting Volcanic Magnet"]) then
									continue
								end
							end

							break
						end

						return
					end

					if string.find(getgenv().QuestHunterDragon, "Hydra Enforcers") then
						local v_13 = DetectMob("Hydra Enforcer")

						if not v_13 then
							local v_14 = DetectPartSpawnMob("Hydra Enforcer", true)

							if v_14 then
								Instance.new("IntValue", v_14).Name = "Ignored"

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
										if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Hydra Enforcer") or not Settings["Auto Quest Dragon Hunter"] or not Settings["Auto Crafting Volcanic Magnet"] or v_12) then
											continue
										end
									end

									break
								end

								wait(1)
							else
								DeleteIgnoredMobSpawn()
							end
						else
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(v_13)
									BringMob(v_13)
									UsedualFlock()
									ClickM1(v_13)

									if IsMobAlive(v_13) then
										local humanoidRootPart2 = v_13:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart2 then
											if Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
											else
												toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
											end

											if not (not IsMobAlive(v_13) or not Settings["Auto Crafting Volcanic Magnet"] or v_12) then
												continue
											end
										end
									end
								end

								break
							end
						end
					elseif string.find(getgenv().QuestHunterDragon, "Venomous Assailants") then
						local v_13 = DetectMob("Venomous Assailant")

						if not v_13 then
							local v_14 = DetectPartSpawnMob("Venomous Assailant", true)

							if v_14 then
								Instance.new("IntValue", v_14).Name = "Ignored"

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
										if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Venomous Assailant") or not Settings["Auto Crafting Volcanic Magnet"] or v_12) then
											continue
										end
									end

									break
								end

								wait(1)
							else
								DeleteIgnoredMobSpawn()
							end
						else
							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									sizepart(v_13)
									BringMob(v_13)
									UsedualFlock()
									ClickM1(v_13)

									if IsMobAlive(v_13) then
										local humanoidRootPart2 = v_13:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart2 then
											if Settings["Select Weapon"] == "Blox Fruit" then
												toTarget(humanoidRootPart2.CFrame * CFrame.new(-7, 20, 0))
											else
												toTarget(humanoidRootPart2.CFrame * CFrame.new(7, 20, 0))
											end

											if not (not IsMobAlive(v_13) or not Settings["Auto Crafting Volcanic Magnet"] or v_12) then
												continue
											end
										end
									end
								end

								break
							end
						end
					elseif string.find(getgenv().QuestHunterDragon, "trees") then
						local v_13 = DetectTree()
						local currentCamera = workspace.CurrentCamera

						if v_13 then
							Instance.new("IntValue", v_13).Name = "Ignored"
							local now = tick()

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									local position = v_13.WorldPivot.Position

									if localPlayer:DistanceFromCharacter(position) < 50 then
										AutoAllSkill()
									end

									if v_13:FindFirstChild("Meshes/plant1_Icosphere", true) then
										toTarget(v_13.WorldPivot)
										local worldPivot = v_13.WorldPivot
										getgenv().AimPos = worldPivot
										v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position)
										v_5.Target = v_13
									else
										local position2 = (v_13.WorldPivot * CFrame.new(5, -20, 0)).Position
										local position3 = (v_13.WorldPivot * CFrame.new(0, -20, 0)).Position
										toTarget(CFrame.new(position2))
										getgenv().AimPos = CFrame.new(position3)
										v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position3)
										v_5.Target = v_13
									end

									if not (not v_13 or not v_13.Parent or not Settings["Auto Crafting Volcanic Magnet"] or v_12 or v_13:GetAttribute("AlreadyDestroyedClient") or tick() - now >= 15) then
										continue
									end
								end

								break
							end
						end
					end
				end

				return
			end

			if CheckCountItem("Scrap Metal", 10) and CheckCountItem("Blaze Ember", 15) then
				game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", "Volcanic Magnet", 1, {} }))
				wait(2)
			end
		else
			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Done Craft Volcanic Magnet", ShowTime = 5 })
			ToggleAutoCraftingVolcanicMagnet:SetStage(false)
			SaveSettings("Auto Crafting Volcanic Magnet", false)
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end
	end

	ToggleAutoCraftingVolcanicMagnet = FarmingVolcanoSection.CreateToggle({
		Title = "Auto Crafting Volcanic Magnet",
		Desc = nil,
		Default = Settings["Auto Crafting Volcanic Magnet"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Crafting Volcanic Magnet"] and wait(0.1) do
					pcall(function()
						AutoCraftinMagnetVol()
					end)
				end
			end)
		else
			getgenv().LastToggleCancelTime = tick()
			local tweenManager = getgenv().TweenManager or TweenManager

			if tweenManager and tweenManager.CancelCurrent then
				tweenManager.CancelCurrent()
			end
		end

		SaveSettings("Auto Crafting Volcanic Magnet", arg)
	end)

	AutoFindPrehistoric = function()
		if not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
			getgenv().RespawnVolcano = true
			local v_12 = checkboat()

			if not v_12 or v_12 and localPlayer:DistanceFromCharacter(v_12.VehicleSeat.Position) >= 4000 then
				local cframe3 = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

				if (cframe3.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
					if (cframe3.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
						if game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki" then
							localPlayer.Character.Humanoid.Health = 0
							return
						end
					end

					toTarget(cframe3)
				else
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
					wait(3)
				end
			elseif localPlayer.Character.Humanoid.Sit then
				local n8 = CFrame.new(-118834.515625, 160, -78.950584411621094) * CFrame.new(0, 0, 99999999)
				local cframe3 = CFrame.new(-32975.9921875, 160, 25963.7109375)
				local flag5

				if Settings["Will Back When over 10km"] then
					if DistanceFindLeviathan() >= 12000 then
						flag5 = true
					elseif DistanceFindLeviathan() <= 4800 then
						flag5 = false
					else
						flag5 = false
					end
				else
					flag5 = false
				end

				repeat
					task.wait(0.5)
					if getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8 then
						break
					end
					NoclipBoat(v_12)

					if Settings["Will Back When over 10km"] then
						if DistanceFindLeviathan() >= 10000 then
							flag5 = true
						elseif DistanceFindLeviathan() <= 4800 then
							flag5 = false
						end

						if flag5 then
							manageTween(v_12.VehicleSeat, cframe3, 350, "TweenBoatBack")
						end
					end

					if not flag5 or not Settings["Will Back When over 10km"] then
						manageTween(v_12.VehicleSeat, n8, 350, "TweenBoat")
					end
				until not Settings["Auto Find Prehistoric Island"] or not localPlayer.Character.Humanoid.Sit or game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")

				if getgenv().TweenBoat then
					getgenv().TweenBoat:Pause()
					getgenv().TweenBoat:Cancel()
				end

				if getgenv().TweenBoatBack then
					getgenv().TweenBoatBack:Pause()
					getgenv().TweenBoatBack:Cancel()
				end
			else
				if getgenv().TweenBoat then
					getgenv().TweenBoat:Pause()
					getgenv().TweenBoat:Cancel()
				end

				if getgenv().TweenBoatBack then
					getgenv().TweenBoatBack:Pause()
					getgenv().TweenBoatBack:Cancel()
				end

				toTarget(v_12.VehicleSeat.CFrame)
			end
		else
			if getgenv().RespawnVolcano and Settings["Webhook Find Prehistoric Island"] then
				getgenv().RespawnVolcano = false
				local webhookFindVolcano = WebhookFindVolcano or getgenv().WebhookFindVolcano

				if webhookFindVolcano then
					webhookFindVolcano()
				end
			end

			if getgenv().TweenBoat then
				getgenv().TweenBoat:Pause()
				getgenv().TweenBoat:Cancel()
			end

			lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Prehistoric Island Spawned", ShowTime = 5 })
			ToggleAutoFindPrehistoricIsland:SetStage(false)
			wait(5)
		end
	end

	ToggleAutoFindPrehistoricIsland = FarmingVolcanoSection.CreateToggle({
		Title = "Auto Find Prehistoric Island",
		Desc = nil,
		Default = Settings["Auto Find Prehistoric Island"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Find Prehistoric Island"] and wait(0.1) do
					pcall(function()
						AutoFindPrehistoric()
					end)
				end
			end)
		end

		SaveSettings("Auto Find Prehistoric Island", arg)
	end)

	AutoAttackVolcano = function()
		if game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
			if not localPlayer:GetAttribute("CurrentLocation") or localPlayer:GetAttribute("CurrentLocation") ~= "Prehistoric Island" then
				local v_12 = DetectNpc("Fossil Expert")
				if not v_12 or not v_12:FindFirstChild("HumanoidRootPart") then
					return
				end

				if v_12 then
					toTarget(v_12.HumanoidRootPart.CFrame)
					return
				end
			end

			if DetectLava() then
				local v_12 = next
				local descendants, v_13 = workspace.Map.PrehistoricIsland:GetDescendants()

				for _, v_14 in v_12, descendants, v_13 do
					if v_14.Name == "TouchInterest" and v_14.Parent.Name ~= "TrialTeleport" then
						v_14:Destroy()
					end
				end
			end

			if #workspace.Map.PrehistoricIsland.Core.InteriorLava:GetChildren() > 0 then
				DeleteLava()
			end

			if not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
				if workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") and workspace.Map.PrehistoricIsland.Core.ActivationPrompt:FindFirstChild("ProximityPrompt") then
					toTarget(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame)

					if localPlayer:DistanceFromCharacter(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.Position) < 8 then
						fireproximityprompt(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.ProximityPrompt, 1)
						wait(3)
					end

					return
				end

				if not workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") and not workspace.Map.PrehistoricIsland.Core:FindFirstChild("FossilExpertSpawn") then
					local v_12 = DetectNpc("Fossil Expert")
					if not v_12 or not v_12:FindFirstChild("HumanoidRootPart") then
						return
					end

					if v_12 then
						toTarget(v_12.HumanoidRootPart.CFrame)
						return
					end
				end
			else
				if flag2 then
					local skull = workspace.Map.PrehistoricIsland.Core.PrehistoricRelic.Skull

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(skull.CFrame)
							if not (localPlayer:DistanceFromCharacter(skull.Position) <= 200 or DetectGolem() or DetectRockVolcano()) then
								continue
							end
						end

						break
					end

					flag2 = false
					return
				end

				local v_12 = DetectGolem()

				if v_12 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(0, 20, 7))

							if Settings["Select Method Kill Golem"] == "Instant Kill [ Risk and can bug no die mob ]" then
								if localPlayer:DistanceFromCharacter(v_12.HumanoidRootPart.Position) < 50 then
									KillRaidEnemy()
								end
							else
								equiptool(NameWeapon(Settings["Select Weapon Kill Golem"] or "Melee"))
								getgenv().ClickM1Volcano(v_12)
							end

							if not getgenv().KillMobRaid and Settings["Kill Aura Only Raid And Volcano"] then
								getgenv().KillMobRaid = true
								local timeDelayKill = Settings["Time Delay Kill"] or 5
								v_12.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)

								delay(timeDelayKill, function()
									getgenv().KillMobRaid = false
								end)
							end

							if not (not IsMobAlive(v_12) or not Settings["Auto Event Prehistoric Island"]) then
								continue
							end
						end

						break
					end
				end

				local v_13 = DetectRockVolcano()

				if v_13 then
					if Settings["Fix Volcano Safe"] then
						local v_14 = DetectPositionVolcano()
						local v_15, v_16 = CheckPosnearRock(v_14, localPlayer.Character.HumanoidRootPart)
						local distanceFromCharacter = localPlayer.DistanceFromCharacter
						local v_17 = CheckPosnearRock(v_14, v_13.WorldPivot)

						if distanceFromCharacter(localPlayer, v_17) >= 400 then
							n4 = v_16 + 1

							if v_16 >= 7 then
								n4 = 1
							end

							toTarget(CFrame.new(v_14[n4]))
						else
							local v_18 = tbl7[math.floor(v_13.WorldPivot.Position.Y)]

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									if localPlayer:DistanceFromCharacter((v_13.WorldPivot * v_18).Position) > 8 then
										toTarget(v_13.WorldPivot * v_18)
									end

									if localPlayer:DistanceFromCharacter(v_13.WorldPivot.Position) < 100 then
										AutoUseSkillFixLava()
									end

									local worldPivot = v_13.WorldPivot
									getgenv().AimPos = worldPivot
									v_5.Hit = v_13.WorldPivot
									v_5.Target = v_13
									if not (not v_13 or not v_13.Parent or not Settings["Auto Event Prehistoric Island"] or not v_13.VFXLayer.Specs.Enabled or DetectGolem()) then
										continue
									end
								end

								break
							end

							if not DetectGolem() then
								flag2 = true
							end

							wait(1)
						end
					else
						local v_14 = tbl7[math.floor(v_13.WorldPivot.Position.Y)]

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if localPlayer:DistanceFromCharacter((v_13.WorldPivot * v_14).Position) > 8 then
									toTarget(v_13.WorldPivot * v_14)
								end

								if localPlayer:DistanceFromCharacter(v_13.WorldPivot.Position) < 100 then
									AutoUseSkillFixLava()
								end

								local worldPivot = v_13.WorldPivot
								getgenv().AimPos = worldPivot
								v_5.Hit = v_13.WorldPivot
								v_5.Target = v_13
								if not (not v_13 or not v_13.Parent or not Settings["Auto Event Prehistoric Island"] or not v_13.VFXLayer.Specs.Enabled or DetectGolem()) then
									continue
								end
							end

							break
						end

						if not DetectGolem() then
							flag2 = true
						end
					end
				end
			end
		end
	end

	FarmingVolcanoSection.CreateToggle({
		Title = "Auto Event Prehistoric Island",
		Desc = "auto Start Event and Auto kill golem, Auto Fix Volcano",
		Default = Settings["Auto Event Prehistoric Island"] or false,
	}, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Event Prehistoric Island"] and wait(0.1) do
					local ok, result = pcall(function()
						AutoAttackVolcano()
					end)

					if result then
						print(result)
					end
				end
			end)
		end

		SaveSettings("Auto Event Prehistoric Island", arg)
	end)

	DetectBone = function()
		for _, v_12 in game.workspace:GetChildren() do
			if v_12.Name == "DinoBone" then
				return v_12
			end
		end
	end

	FarmingVolcanoSection.CreateToggle({ Title = "Auto Collect Bone", Desc = nil, Default = Settings["Auto Collect Bone"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Collect Bone"] and wait() do
					pcall(function()
						local v_12 = DetectBone()

						if v_12 and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
							toTarget(v_12.CFrame)
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Collect Bone", arg)
	end)

	DetectDragonEggs = function()
		if #workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:GetChildren() > 0 then
			for _, v_12 in workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:GetChildren() do
				if v_12.Name == "DragonEgg" and v_12:FindFirstChild("Molten") and v_12.Molten:FindFirstChild("ProximityPrompt") then
					return v_12
				end
			end
		end
	end

	FarmingVolcanoSection.CreateToggle({ Title = "Auto Collect Egg", Desc = nil, Default = Settings["Auto Collect Egg"] or false }, function(arg)
		if arg then
			spawn(function()
				while Settings["Auto Collect Egg"] and wait() do
					pcall(function()
						local v_12 = DetectDragonEggs()

						if v_12 then
							if DetectBone() and Settings["Auto Collect Bone"] then
								return
							end
							toTarget(v_12.Molten.CFrame)

							if localPlayer:DistanceFromCharacter(v_12.Molten.Position) < 8 then
								fireproximityprompt(v_12.Molten.ProximityPrompt)
							end
						end
					end)
				end
			end)
		end

		SaveSettings("Auto Collect Egg", arg)
	end)

	FullyEventVolcano = function()
		if not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") then
			getgenv().RespawnVolcano = true
			getgenv().turnoffnoclipBoatt = true

			if not CheckItemInventory("Volcanic Magnet") and not Settings["Ignore Craft Volcanic Magnet"] then
				if getgenv().dacoMagnet then
					local now = tick()

					while true do
						wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							if not (tick() - now >= 5 or game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland")) then
								continue
							end
						end

						break
					end

					getgenv().dacoMagnet = false
					return
				end

				if not CheckCountItem("Scrap Metal", 10) then
					local tbl12 = { "Jungle Pirate", "Musketeer Pirate" }
					local v_12 = DetectMob(tbl12)

					if not v_12 then
						if typeof(tbl12) == "table" then
							if #tbl12 <= #tbl4 then
								tbl4 = {}
								return
							end
							local v_13 = DetectPartSpawnMob(DetectNameTablePart(tbl12))

							if v_13 then
								table.insert(tbl4, DetectNameTablePart(tbl12))

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										toTarget(v_13.CFrame * CFrame.new(0, 60, 0))
										if not ((v_13.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob(tbl12) or not Settings["Fully Event Prehistoric Island"]) then
											continue
										end
									end

									break
								end

								wait(1)
							end
						end
					else
						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								sizepart(v_12)
								BringMob(v_12)
								UsedualFlock()
								ClickM1(v_12)
								toTarget(v_12.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
								if not (not IsMobAlive(v_12) or not Settings["Fully Event Prehistoric Island"]) then
									continue
								end
							end

							break
						end
					end

					return
				end

				if not CheckCountItem("Blaze Ember", 15) then
					local dragonHunter = DetectNpc("Dragon Hunter") or workspace.NPCs:FindFirstChild("Dragon Hunter") or game:GetService("ReplicatedStorage").NPCs:FindFirstChild("Dragon Hunter")

					if not getgenv().QuestHunterDragon then
						if localPlayer:DistanceFromCharacter(dragonHunter.HumanoidRootPart.Position) > 8 then
							toTarget(dragonHunter.HumanoidRootPart.CFrame * CFrame.new(0, 4, 4))
						else
							local response = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "Check" } }))

							if not response or response and not response.Text then
								getgenv().QuestHunterDragon = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ { Context = "RequestQuest" } })).Text
							else
								local text = response.Text
								getgenv().QuestHunterDragon = text
							end
						end
					else
						local v_12 = DetectEmberTemplate()

						if v_12 then
							Instance.new("IntValue", v_12).Name = "Ignored"

							while true do
								wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									toTarget(v_12.Part.CFrame)
									if not (not v_12 or not v_12.Parent) then
										continue
									end
								end

								break
							end

							return
						end

						if string.find(getgenv().QuestHunterDragon, "Hydra Enforcers") then
							local v_13 = DetectMob("Hydra Enforcer")

							if not v_13 then
								local v_14 = DetectPartSpawnMob("Hydra Enforcer", true)

								if v_14 then
									Instance.new("IntValue", v_14).Name = "Ignored"

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
											if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Hydra Enforcer") or not Settings["Fully Event Prehistoric Island"] or v_12) then
												continue
											end
										end

										break
									end

									wait(1)
								else
									DeleteIgnoredMobSpawn()
								end
							else
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_13)
										BringMob(v_13)
										UsedualFlock()
										ClickM1(v_13)

										if Settings["Select Weapon"] == "Blox Fruit" then
											toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(-7, 20, 0))
										else
											toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										end

										if not (not IsMobAlive(v_13) or not Settings["Fully Event Prehistoric Island"] or v_12) then
											continue
										end
									end

									break
								end
							end
						elseif string.find(getgenv().QuestHunterDragon, "Venomous Assailants") then
							local v_13 = DetectMob("Venomous Assailant")

							if not v_13 then
								local v_14 = DetectPartSpawnMob("Venomous Assailant", true)

								if v_14 then
									Instance.new("IntValue", v_14).Name = "Ignored"

									while true do
										wait()

										if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
											toTarget(v_14.CFrame * CFrame.new(0, 60, 0))
											if not ((v_14.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 or DetectMob("Venomous Assailant") or not Settings["Fully Event Prehistoric Island"] or v_12) then
												continue
											end
										end

										break
									end

									wait(1)
								else
									DeleteIgnoredMobSpawn()
								end
							else
								while true do
									task.wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										sizepart(v_13)
										BringMob(v_13)
										UsedualFlock()
										ClickM1(v_13)
										toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(7, 20, 0))
										if not (not IsMobAlive(v_13) or not Settings["Fully Event Prehistoric Island"] or v_12) then
											continue
										end
									end

									break
								end
							end
						elseif string.find(getgenv().QuestHunterDragon, "trees") then
							local currentCamera = workspace.CurrentCamera
							local v_13 = DetectTree()

							if v_13 then
								Instance.new("IntValue", v_13).Name = "Ignored"
								local now = tick()

								while true do
									wait()

									if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
										local position = v_13.WorldPivot.Position

										if localPlayer:DistanceFromCharacter(position) < 50 then
											AutoAllSkill()
										end

										if v_13:FindFirstChild("Meshes/plant1_Icosphere", true) then
											toTarget(v_13.WorldPivot)
											local worldPivot = v_13.WorldPivot
											getgenv().AimPos = worldPivot
											v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position)
											v_5.Target = v_13
										else
											local position2 = (v_13.WorldPivot * CFrame.new(5, -20, 0)).Position
											local position3 = (v_13.WorldPivot * CFrame.new(0, -20, 0)).Position
											toTarget(CFrame.new(position2))
											getgenv().AimPos = CFrame.new(position3)
											v_5.Hit = CFrame.new(currentCamera.CFrame.Position, position3)
											v_5.Target = v_13
										end

										if not (not v_13 or not v_13.Parent or not Settings["Fully Event Prehistoric Island"] or v_12 or v_13:GetAttribute("AlreadyDestroyedClient") or tick() - now >= 15) then
											continue
										end
									end

									break
								end
							end
						end
					end

					return
				end

				if CheckCountItem("Scrap Metal", 10) and CheckCountItem("Blaze Ember", 15) then
					game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/Craft"):InvokeServer(unpack({ "Craft", "Volcanic Magnet", 1, {} }))
					wait(2)
				end
			else
				getgenv().dacoMagnet = true

				if not game:GetService("Workspace").Map:FindFirstChild("PrehistoricIsland") and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
					local v_12 = checkboat()

					if not v_12 or v_12 and localPlayer:DistanceFromCharacter(v_12.VehicleSeat.Position) >= 4000 then
						local cframe3 = CFrame.new(-16204.0810546875, 9.0863618850708, 479.2259521484375)

						if (cframe3.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 8 then
							if (cframe3.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude > 1000 then
								if not localPlayer:GetAttribute("CurrentLocation") or localPlayer:GetAttribute("CurrentLocation") ~= "Tiki Outpost" then
									if game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki" or game:GetService("Players").LocalPlayer.Data.LastSpawnPoint.Value == "Tiki2" then
										localPlayer.Character.Humanoid.Health = 0
										return
									end
								end
							end

							toTarget(cframe3)
						else
							game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBoat", "PirateBrigade")
							wait(3)
						end
					elseif localPlayer.Character.Humanoid.Sit then
						task.spawn(function()
							NoclipBoat(v_12)
						end)

						manageTween(v_12.VehicleSeat, CFrame.new(-118834.515625, v_12.WorldPivot.Y, -78.950584411621094) * CFrame.new(0, 0, 99999999), 350, "TweenBoat")
					else
						if getgenv().TweenBoat then
							getgenv().TweenBoat:Pause()
							getgenv().TweenBoat:Cancel()
						end

						toTarget(v_12.VehicleSeat.CFrame)
					end
				end
			end
		else
			if getgenv().turnoffnoclipBoatt then
				getgenv().turnoffnoclipBoatt = false
				local v_12 = checkboat()

				if v_12 then
					TurnOffNoclipBoat(v_12)
				end
			end

			if getgenv().RespawnVolcano and Settings["Webhook Find Prehistoric Island"] then
				getgenv().RespawnVolcano = false
				local webhookFindVolcano = WebhookFindVolcano or getgenv().WebhookFindVolcano

				if webhookFindVolcano then
					webhookFindVolcano()
				end
			end

			if getgenv().TweenBoat then
				getgenv().TweenBoat:Pause()
				getgenv().TweenBoat:Cancel()
			end

			if not localPlayer:GetAttribute("CurrentLocation") or localPlayer:GetAttribute("CurrentLocation") ~= "Prehistoric Island" then
				local v_12 = DetectNpc("Fossil Expert")
				if not v_12 or not v_12:FindFirstChild("HumanoidRootPart") then
					return
				end

				if v_12 then
					toTarget(v_12.HumanoidRootPart.CFrame)
					return
				end
			end

			local v_12 = DetectDragonEggs()

			if v_12 then
				toTarget(v_12.Molten.CFrame)

				if localPlayer:DistanceFromCharacter(v_12.Molten.Position) < 8 then
					fireproximityprompt(v_12.Molten.ProximityPrompt)
				end

				return
			end

			if not Settings["Ignore Collect Bone"] then
				local v_13 = DetectBone()
				if v_13 and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
					toTarget(v_13.CFrame)
					return
				end
			end

			if localPlayer:GetAttribute("CurrentLocation") == "Prehistoric Island" and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible and getgenv().CanReset then
				local now = tick()

				while true do
					wait()

					if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
						if not (tick() - now >= 10 or not Settings["Fully Event Prehistoric Island"] or DetectBone() and not Settings["Ignore Collect Bone"] or DetectDragonEggs()) then
							continue
						end
					end

					break
				end

				if Settings["Fully Event Prehistoric Island"] and not DetectDragonEggs() and (not DetectBone() and not Settings["Ignore Collect Bone"] or Settings["Ignore Collect Bone"]) then
					localPlayer.Character.Humanoid.Health = 0
					getgenv().CanReset = false
				end
			end

			if DetectLava() then
				local v_13 = next
				local descendants, v_14 = workspace.Map.PrehistoricIsland:GetDescendants()

				for _, v_15 in v_13, descendants, v_14 do
					if v_15.Name == "TouchInterest" and v_15.Parent.Name ~= "TrialTeleport" then
						v_15:Destroy()
					end
				end
			end

			if #workspace.Map.PrehistoricIsland.Core.InteriorLava:GetChildren() > 0 then
				DeleteLava()
			end

			if not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.PrehistoricRaidTimer.Visible and not game:GetService("Players").LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
				if workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") and workspace.Map.PrehistoricIsland.Core.ActivationPrompt:FindFirstChild("ProximityPrompt") then
					toTarget(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.CFrame)

					if localPlayer:DistanceFromCharacter(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.Position) < 8 then
						fireproximityprompt(workspace.Map.PrehistoricIsland.Core.ActivationPrompt.ProximityPrompt, 1)
						wait(3)
					end

					return
				end

				if not workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt") and not workspace.Map.PrehistoricIsland.Core:FindFirstChild("FossilExpertSpawn") then
					local v_13 = DetectNpc("Fossil Expert")
					if v_13 then
						toTarget(v_13.HumanoidRootPart.CFrame)
						return
					end
				end
			else
				getgenv().CanReset = true

				if flag2 then
					local skull = workspace.Map.PrehistoricIsland.Core.PrehistoricRelic.Skull

					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(skull.CFrame)
							if not (localPlayer:DistanceFromCharacter(skull.Position) <= 200 or DetectGolem() or DetectRockVolcano()) then
								continue
							end
						end

						break
					end

					flag2 = false
					return
				end

				local v_13 = DetectGolem()

				if v_13 then
					while true do
						task.wait()

						if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
							toTarget(v_13.HumanoidRootPart.CFrame * CFrame.new(0, 20, 7))

							if Settings["Select Method Kill Golem"] == "Instant Kill [ Risk and can bug no die mob ]" then
								if localPlayer:DistanceFromCharacter(v_13.HumanoidRootPart.Position) < 50 then
									KillRaidEnemy()
								end
							else
								equiptool(NameWeapon(Settings["Select Weapon Kill Golem"] or "Melee"))
								getgenv().ClickM1Volcano(v_13)
							end

							if not getgenv().KillMobRaid and Settings["Kill Aura Only Raid And Volcano"] then
								getgenv().KillMobRaid = true
								local timeDelayKill = Settings["Time Delay Kill"] or 5
								v_13.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)

								delay(timeDelayKill, function()
									getgenv().KillMobRaid = false
								end)
							end

							if not (not IsMobAlive(v_13) or not Settings["Fully Event Prehistoric Island"]) then
								continue
							end
						end

						break
					end
				end

				local v_14 = DetectRockVolcano()

				if v_14 then
					if Settings["Fix Volcano Safe"] then
						local v_15 = DetectPositionVolcano()
						local v_16, v_17 = CheckPosnearRock(v_15, localPlayer.Character.HumanoidRootPart)
						local distanceFromCharacter = localPlayer.DistanceFromCharacter
						local v_18 = CheckPosnearRock(v_15, v_14.WorldPivot)

						if distanceFromCharacter(localPlayer, v_18) >= 400 then
							n4 = v_17 + 1

							if v_17 >= 7 then
								n4 = 1
							end

							toTarget(CFrame.new(v_15[n4]))
						else
							local v_19 = tbl7[math.floor(v_14.WorldPivot.Position.Y)]

							while true do
								task.wait()

								if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
									if localPlayer:DistanceFromCharacter((v_14.WorldPivot * v_19).Position) > 8 then
										toTarget(v_14.WorldPivot * v_19)
									end

									if localPlayer:DistanceFromCharacter(v_14.WorldPivot.Position) < 100 then
										AutoUseSkillFixLava()
									end

									local worldPivot = v_14.WorldPivot
									getgenv().AimPos = worldPivot
									v_5.Hit = v_14.WorldPivot
									v_5.Target = v_14
									if not (not v_14 or not v_14.Parent or not Settings["Fully Event Prehistoric Island"] or not v_14.VFXLayer.Specs.Enabled or DetectGolem()) then
										continue
									end
								end

								break
							end

							if not DetectGolem() then
								flag2 = true
							end

							wait(1)
						end
					else
						local v_15 = tbl7[math.floor(v_14.WorldPivot.Position.Y)]

						while true do
							task.wait()

							if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
								if localPlayer:DistanceFromCharacter((v_14.WorldPivot * v_15).Position) > 8 then
									toTarget(v_14.WorldPivot * v_15)
								end

								if localPlayer:DistanceFromCharacter(v_14.WorldPivot.Position) < 100 then
									AutoUseSkillFixLava()
								end

								local worldPivot = v_14.WorldPivot
								getgenv().AimPos = worldPivot
								v_5.Hit = v_14.WorldPivot
								v_5.Target = v_14
								if not (not v_14 or not v_14.Parent or not Settings["Fully Event Prehistoric Island"] or not v_14.VFXLayer.Specs.Enabled or DetectGolem()) then
									continue
								end
							end

							break
						end

						if not DetectGolem() then
							flag2 = true
						end
					end
				end
			end
		end
	end
end

FullyVolcanoSection = VolcanoTab.CreateSection("Fully Volcano")

FullyVolcanoSection.CreateToggle({
	Title = "Ignore Craft Volcanic Magnet [ Fully ]",
	Desc = nil,
	Default = Settings["Ignore Craft Volcanic Magnet"] or false,
}, function(arg)
	SaveSettings("Ignore Craft Volcanic Magnet", arg)
end)

FullyVolcanoSection.CreateToggle({
	Title = "Ignore Collect Bone [ Fully ]",
	Desc = nil,
	Default = Settings["Ignore Collect Bone"] or false,
}, function(arg)
	SaveSettings("Ignore Collect Bone", arg)
end)

FullyVolcanoSection.CreateToggle({
	Title = "Fully Event Prehistoric Island",
	Desc = nil,
	Default = Settings["Fully Event Prehistoric Island"] or false,
}, function(arg)
	if arg then
		spawn(function()
			while Settings["Fully Event Prehistoric Island"] and task.wait() do
				local ok, result = pcall(function()
					FullyEventVolcano()
				end)

				if result then
					print(result)
				end
			end
		end)
	end

	SaveSettings("Fully Event Prehistoric Island", arg)
end)

ESPTab = Main.CreatePage({ Page_Name = "ESP", Page_Title = "ESP Tab" })
ESPSection = ESPTab.CreateSection("ESP")

EspSpawnBerry = function()
	local v_11, v_12 = DetectBerryESP()

	if v_11 then
		local intValue = Instance.new("IntValue", v_11.Parent)
		intValue.Name = "Ignored"
		local text = Drawing.new("Text")
		text.Visible = false
		text.Transparency = 1
		text.Text = v_11.Name
		text.Color = Color3.fromRGB(255, 255, 255)
		text.Size = 20
		text.Outline = true
		text.OutlineColor = Color3.fromRGB(0, 0, 0)
		text.Center = true
		text.Font = 1

		spawn(function()
			while true do
				task.wait()
				local v_13, v_14 = game.workspace.CurrentCamera:WorldToViewportPoint(v_11.Parent.WorldPivot.Position)

				if v_14 then
					text.Text = v_12 .. " (" .. math.round(localPlayer:DistanceFromCharacter(v_11.Parent.WorldPivot.Position)) .. ")"
					text.Position = Vector2.new(v_13.X, v_13.Y - 20)
					text.Visible = true
				else
					text.Visible = false
				end

				if not (not v_11 or not v_11.Parent or not Settings["ESP Berry"] or not DetectBerryCFrame(v_11:GetAttributes())) then
					continue
				end
				break
			end

			text:Remove()

			if v_11.Parent then
				intValue:Destroy()
			end
		end)
	end
end

ESPSection.CreateToggle({ Title = "ESP Berry", Desc = nil, Default = Settings["ESP Berry"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["ESP Berry"] and wait(0.2) do
				pcall(function()
					EspSpawnBerry()
				end)
			end
		end)
	end

	SaveSettings("ESP Berry", arg)
end)

DetectIsland = function()
	local v_11 = next
	local children, v_12 = workspace._WorldOrigin.Locations:GetChildren()

	for _, v_13 in v_11, children, v_12 do
		if v_13 and v_13:GetAttribute("CFrame") and not v_13:FindFirstChild("Ignored") then
			return v_13
		end
	end
end

EspIsland = function()
	local v_11 = DetectIsland()

	if v_11 then
		local intValue = Instance.new("IntValue", v_11)
		intValue.Name = "Ignored"
		local text = Drawing.new("Text")
		text.Visible = false
		text.Transparency = 1
		text.Text = v_11.Name
		text.Color = Color3.fromRGB(255, 255, 255)
		text.Size = 20
		text.Outline = true
		text.OutlineColor = Color3.fromRGB(0, 0, 0)
		text.Center = true
		text.Font = 1

		spawn(function()
			while true do
				task.wait()
				local v_12, v_13 = game.workspace.CurrentCamera:WorldToViewportPoint(v_11:GetAttribute("CFrame").Position)

				if v_13 then
					text.Text = v_11.Name .. " (" .. math.round(localPlayer:DistanceFromCharacter(v_11:GetAttribute("CFrame").Position)) .. ")"
					text.Position = Vector2.new(v_12.X, v_12.Y - 20)
					text.Visible = true
				else
					text.Visible = false
				end

				if not (not v_11 or not v_11.Parent or not Settings["ESP Island"]) then
					continue
				end
				break
			end

			text:Remove()

			if v_11.Parent then
				intValue:Destroy()
			end
		end)
	end
end

ESPSection.CreateToggle({ Title = "ESP Island", Desc = nil, Default = Settings["ESP Island"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["ESP Island"] and wait(0.2) do
				pcall(function()
					EspIsland()
				end)
			end
		end)
	end

	SaveSettings("ESP Island", arg)
end)

GetEspFruit = function()
	local v_11 = next
	local children, v_12 = game.Workspace:GetChildren()

	for _, v_13 in v_11, children, v_12 do
		local handle = v_13:FindFirstChild("Handle")
		if (v_13:IsA("Tool") or v_13:IsA("Model")) and string.find(v_13.Name, "Fruit") and handle and not handle:FindFirstChild("Ignored") then
			return v_13
		end
	end
end

local tbl7 = {
	["rbxassetid://15100283484"] = "Light Fruit",
	["rbxassetid://15116730102"] = "Love Fruit",
	["rbxassetid://15100273645"] = "Dough Fruit",
	["rbxassetid://15116967784"] = "Spider Fruit",
	["rbxassetid://15112263502"] = "Shadow Fruit",
	["rbxassetid://15104782377"] = "Blade Fruit",
	["rbxassetid://15060012861"] = "Rocket Fruit",
	["rbxassetid://15106768588"] = "Leopard Fruit",
	["rbxassetid://15112469964"] = "Falcon Fruit",
	["rbxassetid://15708895165"] = "T-Rex Fruit",
	["rbxassetid://19001642259"] = "Dragon (East) Fruit",
	["rbxassetid://86024571204851"] = "Gas Fruit",
	["rbxassetid://15100246632"] = "Phoenix Fruit",
	["rbxassetid://14661873358"] = "Sound Fruit",
	["rbxassetid://15111584216"] = "Flame Fruit",
	["rbxassetid://15105281957"] = "Spring Fruit",
	["rbxassetid://15116740364"] = "Bomb Fruit",
	["rbxassetid://15104817760"] = "Rubber Fruit",
	["rbxassetid://15057683975"] = "Spin Fruit",
	["rbxassetid://15105350415"] = "Magma Fruit",
	["rbxassetid://15482881956"] = "Kitsune Fruit",
	["rbxassetid://15100485671"] = "Barrier Fruit",
	["rbxassetid://18955022385"] = "Dragon (West) Fruit",
	["rbxassetid://101378450824208"] = "Yeti Fruit",
	["rbxassetid://15116721173"] = "Pain Fruit",
	["https://assetdelivery.roblox.com/v1/asset/?id=10395893751"] = "Venom Fruit",
	["rbxassetid://11908375285"] = "Spirit Fruit",
	["rbxassetid://15100433167"] = "Ice Fruit",
	["rbxassetid://15100299740"] = "Gravity Fruit",
	["rbxassetid://15107005807"] = "Spike Fruit",
	["rbxassetid://15116696973"] = "Smoke Fruit",
	["rbxassetid://15112600534"] = "Diamond Fruit",
	["rbxassetid://15112333093"] = "Ghost Fruit",
	["rbxassetid://15057718441"] = "Quake Fruit",
	["rbxassetid://15111517529"] = "Sand Fruit",
	["rbxassetid://15100313696"] = "Buddha Fruit",
	["rbxassetid://15116747420"] = "Rumble Fruit",
	["rbxassetid://15100384816"] = "Blizzard Fruit",
	["rbxassetid://15111553409"] = "Dark Fruit",
	["rbxassetid://14661837634"] = "Mammoth Fruit",
	["rbxassetid://15100184583"] = "Control Fruit",
}

GetFruitName = function(arg, arg2)
	if arg.ClassName == "Tool" then
		return arg.Name
	end
	local tbl8 = {}

	for _, descendant in pairs(arg:GetDescendants()) do
		if descendant:IsA("MeshPart") then
			table.insert(tbl8, descendant.MeshId)
		end
	end

	local str = "Fruit"

	for k, v_11 in pairs(tbl7) do
		if table.find(tbl8, k) then
			str = v_11
		end
	end

	if str == "Fruit " then
		local fruit = arg:FindFirstChild("Fruit")

		if fruit then
			if fruit:FindFirstChild("Retopo_Cube.001") then
				str = "Spirit Fruit"
			elseif fruit:FindFirstChild("Gravity cube.026") then
				if fruit:FindFirstChild("Gravity cube.001") then
					str = "Blizzard Fruit"
				else
					str = "Portal Fruit"
				end
			elseif fruit:FindFirstChild("Cube.011") then
				str = "Rubber Fruit"
			end
		end
	end

	if arg2 then
		str = "[Natural Spawn]\n" .. str
	end

	return str
end

EspFruit = function()
	local v_11 = GetEspFruit()
	if not v_11 then
		return
	end
	local v_12 = GetFruitName(v_11)
	local handle = v_11:FindFirstChild("Handle")
	if not handle then
		return
	end
	local intValue = Instance.new("IntValue")
	intValue.Name = "Ignored"
	intValue.Parent = handle

	local color = ({
		["Leopard Fruit"] = Color3.fromRGB(255, 170, 0),
		["Dragon (East) Fruit"] = Color3.fromRGB(255, 0, 0),
		["Dragon (West) Fruit"] = Color3.fromRGB(255, 80, 80),
		["Kitsune Fruit"] = Color3.fromRGB(200, 100, 255),
		["Spirit Fruit"] = Color3.fromRGB(120, 200, 255),
		["Venom Fruit"] = Color3.fromRGB(180, 60, 200),
		["Dough Fruit"] = Color3.fromRGB(255, 220, 180),
		["Light Fruit"] = Color3.fromRGB(255, 255, 150),
	})[v_12] or Color3.fromRGB(255, 255, 255)

	local text = Drawing.new("Text")
	text.Visible = false
	text.Transparency = 1
	text.Text = v_12
	text.Color = color
	text.Size = 20
	text.Outline = true
	text.OutlineColor = Color3.fromRGB(0, 0, 0)
	text.Center = true
	text.Font = 2
	local square = Drawing.new("Square")
	square.Visible = false
	square.Filled = true
	square.Color = Color3.fromRGB(0, 0, 0)
	square.Transparency = 0.4

	spawn(function()
		while true do
			task.wait()

			if handle then
				local v_13, v_14 = workspace.CurrentCamera:WorldToViewportPoint(handle.Position)

				if v_14 then
					text.Text = v_12 .. " [" .. math.round(localPlayer:DistanceFromCharacter(handle.Position)) .. "m]"
					text.Position = Vector2.new(v_13.X, v_13.Y - 20)
					text.Color = color
					text.Visible = true
					local textBounds = text.TextBounds
					square.Position = Vector2.new(text.Position.X - textBounds.X / 2 - 4, text.Position.Y - 2)
					square.Size = Vector2.new(textBounds.X + 8, textBounds.Y + 4)
					square.Visible = true
				else
					text.Visible = false
					square.Visible = false
				end
			end

			if not (not v_11 or not v_11.Parent or not handle.Parent or not Settings["ESP Fruit"]) then
				continue
			end
			break
		end

		text:Remove()
		square:Remove()

		if handle:FindFirstChild("Ignored") then
			handle.Ignored:Destroy()
		end
	end)
end

ESPSection.CreateToggle({ Title = "ESP Fruit", Desc = nil, Default = Settings["ESP Fruit"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["ESP Fruit"] and wait() do
				local ok, result = pcall(function()
					EspFruit()
				end)

				if result then
					print(result)
				end
			end
		end)
	end

	SaveSettings("ESP Fruit", arg)
end)

DetectPlayerESP = function()
	for _, child in pairs(game.Workspace.Characters:GetChildren()) do
		if child.Name ~= localPlayer.Name and not child:FindFirstChild("Ignored") then
			return child
		end
	end
end

ESPPlayer = function()
	local v_11 = DetectPlayerESP()

	if v_11 then
		local intValue = Instance.new("IntValue", v_11)
		intValue.Name = "Ignored"
		local text = Drawing.new("Text")
		text.Visible = false
		text.Transparency = 1
		text.Text = v_11.Name
		text.Color = Color3.fromRGB(255, 255, 255)
		text.Size = 20
		text.Outline = true
		text.OutlineColor = Color3.fromRGB(0, 0, 0)
		text.Center = true
		text.Font = 1

		spawn(function()
			while true do
				task.wait()

				if not (getgenv().LastToggleCancelTime and tick() - getgenv().LastToggleCancelTime < 0.8) then
					local humanoidRootPart2 = v_11:FindFirstChild("HumanoidRootPart")
					local humanoid = v_11:FindFirstChildOfClass("Humanoid")

					if not humanoidRootPart2 or not humanoid then
						text.Visible = false
					else
						local v_12, v_13 = game.workspace.CurrentCamera:WorldToViewportPoint(humanoidRootPart2.Position)

						if v_13 then
							local str = ")" .. "\n" .. humanoid.Health .. " / " .. humanoid.MaxHealth
							text.Text = v_11.Name .. " (" .. math.round(localPlayer:DistanceFromCharacter(humanoidRootPart2.Position)) .. str
							text.Position = Vector2.new(v_12.X, v_12.Y - 20)
							text.Visible = true
						else
							text.Visible = false
						end
					end

					if not (not v_11 or not v_11.Parent or not Settings["ESP Player"]) then
						continue
					end
				end

				break
			end

			text:Remove()

			if v_11.Parent then
				intValue:Destroy()
			end
		end)
	end
end

ESPSection.CreateToggle({ Title = "ESP Player", Desc = nil, Default = Settings["ESP Player"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["ESP Player"] and wait() do
				pcall(function()
					ESPPlayer()
				end)
			end
		end)
	end

	SaveSettings("ESP Player", arg)
end)

PvpTab = Main.CreatePage({ Page_Name = "PVP", Page_Title = "PVP Tab" })
SettingsAimbotSection = PvpTab.CreateSection("PVP")

local v_11 = SettingsAimbotSection.CreateDropdown({
	Title = "Select Player PVP",
	List = DetectNamePlayer(),
	Search = true,
	Selected = false,
	Default = Settings["Select Player PVP"] or nil,
}, function(arg)
	SaveSettings("Select Player PVP", arg)
end)

SettingsAimbotSection.CreateDropdown({
	Title = "Select Method Aimbot",
	List = { "Select Player", "Target nearest Player" },
	Search = true,
	Selected = false,
	Default = Settings["Select Method Aimbot"] or nil,
}, function(arg)
	SaveSettings("Select Method Aimbot", arg)
end)

SettingsAimbotSection.CreateButton({ Title = "Refresh Player" }, function()
	v_11:GetNewList(DetectNamePlayer())
end)

TeleportPlayer = function()
	local v_12 = pairs
	local Players2 = game:GetService("Players")

	for _, child in v_12(Players2:GetChildren()) do
		if child.Name == Settings["Select Player PVP"] then
			return child
		end
	end
end

SettingsAimbotSection.CreateToggle({ Title = "Teleport Player", Desc = nil, Default = Settings["Teleport Player"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Teleport Player"] and wait() do
				pcall(function()
					toTarget(TeleportPlayer().Character.HumanoidRootPart.CFrame)
				end)
			end
		end)
	end

	SaveSettings("Teleport Player", arg)
end)

ClosestPartaimbot = function()
	local huge = math.huge
	local v_12 = nil

	for _, child in pairs(game.Workspace.Characters:GetChildren()) do
		if child:IsA("Model") then
			if child.Name ~= localPlayer.Name and (game.Players.LocalPlayer.Team == game.Teams.Marines and game.Players[child.Name].Team ~= game.Teams.Marines or game.Players.LocalPlayer.Team ~= game.Teams.Marines) then
				local humanoidRootPart2 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
				local humanoidRootPart3 = child:FindFirstChild("HumanoidRootPart")

				if not (not humanoidRootPart2 or not humanoidRootPart3) then
					local magnitude = (humanoidRootPart2.Position - humanoidRootPart3.Position).Magnitude

					if magnitude < huge then
						huge = magnitude
						v_12 = child
					end
				end
			end
		end
	end

	return v_12
end

SettingsAimbotSection.CreateToggle({ Title = "Auto Aimbot", Desc = nil, Default = Settings["Auto Aimbot"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Auto Aimbot"] and task.wait() do
				pcall(function()
					if Settings["Select Method Aimbot"] == "Select Player" then
						local v_12 = game.Workspace.Characters[Settings["Select Player PVP"]]
						v_5.Hit = v_12.HumanoidRootPart.CFrame
						v_5.Target = v_12
						local p = v_12.HumanoidRootPart.CFrame.p
						local position = v_12.HumanoidRootPart.Position
						getgenv().AimPos = CFrame.new(p, position + v_12.HumanoidRootPart.Velocity / 0.5)
					else
						local v_12 = ClosestPartaimbot()
						v_5.Hit = v_12.HumanoidRootPart.CFrame
						v_5.Target = v_12
						local p = v_12.HumanoidRootPart.CFrame.p
						local position = v_12.HumanoidRootPart.Position
						getgenv().AimPos = CFrame.new(p, position + v_12.HumanoidRootPart.Velocity / 0.5)
					end
				end)
			end
		end)
	end

	SaveSettings("Auto Aimbot", arg)
end)

SettingsAimbotSection.CreateToggle({ Title = "Auto Aimbot Gun", Desc = nil, Default = Settings["Auto Aimbot Gun"] or false }, function(arg)
	SaveSettings("Auto Aimbot Gun", arg)
end)

pcall(function()
	local getTargetPosition = v_2(game:GetService("ReplicatedStorage").Modules.CombatUtil).GetTargetPosition

	v_2(game:GetService("ReplicatedStorage").Modules.CombatUtil).GetTargetPosition = function(arg, arg2, arg3, arg4, arg5)
		if Settings["Auto Aimbot Gun"] then
			local v_12

			if Settings["Select Method Aimbot"] == "Select Player" then
				v_12 = game.Workspace.Characters[Settings["Select Player PVP"]]
			else
				v_12 = ClosestPartaimbot()
			end

			if v_12 and v_12:FindFirstChild("HumanoidRootPart") then
				return v_12.HumanoidRootPart.Position
			end
		end

		return getTargetPosition(arg, arg2, arg3, arg4, arg5)
	end
end)

MISCPVPSection = PvpTab.CreateSection("MISC PVP")

MISCPVPSection.CreateSlider({
	Title = "Input WalkSpeed",
	Min = 0,
	Max = 500,
	Default = Settings["Input WalkSpeed"] or 200,
	Precise = true,
}, function(arg)
	SaveSettings("Input WalkSpeed", arg)
end)

MISCPVPSection.CreateSlider({
	Title = "Input JumpPower",
	Min = 0,
	Max = 500,
	Default = Settings["Input JumpPower"] or 200,
	Precise = true,
}, function(arg)
	SaveSettings("Input JumpPower", arg)
end)

MISCPVPSection.CreateToggle({ Title = "Change JumpPower", Desc = nil, Default = Settings["Change JumpPower"] or false }, function(arg)
	SaveSettings("Change JumpPower", arg)
end)

MISCPVPSection.CreateToggle({ Title = "Change WalkSpeed", Desc = nil, Default = Settings["Change WalkSpeed"] or false }, function(arg)
	SaveSettings("Change WalkSpeed", arg)
end)

MISCPVPSection.CreateToggle({ Title = "Walk On Water", Desc = nil, Default = Settings["Walk On Water "] or true }, function(arg)
	if arg then
		if not game.Workspace:FindFirstChild("WaterWalk") then
			platform = Instance.new("Part")
			platform.Name = "WaterWalk"
			platform.Size = Vector3.new(math.huge, 1, math.huge)
			platform.Transparency = 1
			platform.Anchored = true
			platform.Parent = game.workspace
		end

		spawn(function()
			while Settings["Walk On Water "] and task.wait() do
				pcall(function()
					if localPlayer.Character.Humanoid.Sit then
						platform.CanCollide = false
						return
					end
					local character = game.Players.LocalPlayer.Character
					character = character and character:FindFirstChild("HumanoidRootPart")
					if not character then
						platform.CanCollide = false
						return
					end

					if (Vector3.new(0, character.Position.Y, 0) - Vector3.new(0, -60, 0)).Magnitude > 60 then
						platform.CanCollide = false
						return
					end
					platform.CanCollide = true
					platform.Position = Vector3.new(character.Position.X, character.Position.Y * 0 - 5, character.Position.Z)
				end)
			end
		end)
	end

	SaveSettings("Walk On Water ", arg)
end)

TabWebhook = Main.CreatePage({ Page_Name = "Tab Webhook", Page_Title = "Tab Webhook" })
SectionWebhook = TabWebhook.CreateSection("Webhook")

SectionWebhook.CreateBox({
	Title = "Input Url Webhook",
	Placeholder = "Type here",
	Number = false,
	Default = Settings["Input Url Webhook"] or nil,
}, function(arg)
	SaveSettings("Input Url Webhook", arg)
end)

SectionWebhook.CreateBox({
	Title = "Input Discord Ping (Everyone/ID)",
	Placeholder = "Type here",
	Number = false,
	Default = Settings["Input Discord Ping"] or nil,
}, function(arg)
	SaveSettings("Input Discord Ping", arg)
end)

SectionWebhook.CreateToggle({ Title = "Ping Everyone/Id Discord", Desc = nil, Default = Settings["Ping Discord"] or false }, function(arg)
	SaveSettings("Ping Discord", arg)
end)

do
	local tbl8 = {
		Username = "Binini Hub",
		AvatarURL = "https://images-ext-1.discordapp.net/external/9LSZu__Uvs7I0N8MWag-JmwF2iT-pHCHSe2UdixGEXQ/%3Fsize%3D4096/https/cdn.discordapp.com/avatars/1262364141968949308/a_0c5fb64e2cbb35d029d73b44576c6a60.gif",
		BannerURL = "https://cdn.discordapp.com/attachments/1017024488665264218/1262729537578471504/banner_server.jpg",
		Title = "Banana Hub Notification",
		FooterText = "Binini Hub",
		Color = 16776960,
	}

	safe_str = function(arg)
		local ok, result = pcall(function()
			return tostring(arg)
		end)

		return ok and result or "nil"
	end

	get_ping_tag = function()
		local ok, result = pcall(function()
			return Settings["Ping Discord"]
		end)

		result = ok and result
		local str = ""

		if result then
			local ok2, result2 = pcall(function()
				return Settings["Input Discord Ping"]
			end)

			if ok2 and tonumber(result2) then
				str = "<@" .. result2 .. ">"
			else
				str = "@everyone"
			end
		end

		return str
	end

	get_webhook_url = function()
		local ok, result = pcall(function()
			return Settings["Input Url Webhook"]
		end)

		return ok and result or nil
	end

	iso8601_utc_now = function()
		return os.date("!%Y-%m-%dT%H:%M:%SZ")
	end

	base_fields = function(arg, arg2)
		local tbl9 = {}
		local tbl10 = { name = "Event", value = "`" .. safe_str(arg) .. "`", inline = true }
		local tbl11 = { name = "Detail", value = "`" .. safe_str(arg2) .. "`", inline = true }

		local tbl12 = {
			name = "Username",
			value = "||" .. safe_str(localPlayer and localPlayer.Name or "Unknown") .. "||",
			inline = true,
		}

		local tbl13 = { name = "PlaceId", value = "`" .. safe_str(game.PlaceId) .. "`", inline = true }
		local tbl14 = { name = "JobId", value = "`" .. safe_str(game.JobId) .. "`", inline = true }
		tbl9[1] = tbl10
		tbl9[2] = tbl11
		tbl9[3] = tbl12
		tbl9[4] = tbl13
		tbl9[5] = tbl14
		return tbl9
	end

	local function fn7(arg, arg2, arg3)
		local v_12 = get_webhook_url()
		if not v_12 or v_12 == "" then
			return
		end
		local tbl9

		if arg3 then
			tbl9 = {}
			local tbl10 = { name = "Stored Fruit", value = "```" .. safe_str(arg2) .. "```", inline = false }

			local tbl11 = {
				name = "Username",
				value = "||" .. safe_str(localPlayer and localPlayer.Name or "Unknown") .. "||",
				inline = true,
			}

			local tbl12 = { name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true }
			local tbl13 = { name = "PlaceId", value = "`" .. safe_str(game.PlaceId) .. "`", inline = true }
			tbl9[1] = tbl10
			tbl9[2] = tbl11
			tbl9[3] = tbl12
			tbl9[4] = tbl13
		else
			tbl9 = base_fields(arg, arg2)
		end

		local tbl10 = { content = get_ping_tag(), username = tbl8.Username, avatar_url = tbl8.AvatarURL }

		tbl10.embeds = {
			{
				title = tbl8.Title,
				description = "**Main Status**\nUsername : ||" .. safe_str(localPlayer and localPlayer.Name or "Unknown") .. "||",
				color = tbl8.Color,
				footer = { text = tbl8.FooterText },
				fields = tbl9,
				thumbnail = { url = tbl8.BannerURL },
				timestamp = iso8601_utc_now(),
			},
		}

		pcall(function()
			ExploitReq({
				Url = v_12,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode(tbl10),
			})
		end)
	end

	getgenv().WebhookStoreFruit = function(arg)
		fn7("Store Fruit", arg, true)
	end

	getgenv().WebhookFindVolcano = function()
		fn7("Prehistoric Island", "Spawned", false)
	end

	getgenv().WebhookFindLeviathan = function()
		fn7("Frozen Dimension", "Spawned", false)
	end

	getgenv().WebhookFindMirage = function()
		fn7("Mirage", "Spawned", false)
	end

	getgenv().WebhookDestroyIdk = function()
		fn7("Status", "Can Find Leviathan", false)
	end
end

WebhookStoreFruit = getgenv().WebhookStoreFruit
WebhookFindVolcano = getgenv().WebhookFindVolcano
WebhookFindLeviathan = getgenv().WebhookFindLeviathan
WebhookFindMirage = getgenv().WebhookFindMirage
WebhookDestroyIdk = getgenv().WebhookDestroyIdk

Webhookprofile = function()
	local tbl8 = {
		Color = 16776960,
		BannerURL = "https://cdn.discordapp.com/attachments/1017024488665264218/1262729537578471504/banner_server.jpg",
		AvatarURL = "https://images-ext-1.discordapp.net/external/9LSZu__Uvs7I0N8MWag-JmwF2iT-pHCHSe2UdixGEXQ/%3Fsize%3D4096/https/cdn.discordapp.com/avatars/1262364141968949308/a_0c5fb64e2cbb35d029d73b44576c6a60.gif",
		Username = "Binini Hub",
		Title = "<:bananacon:1261744974534541352> Banana Hub Notification <:bananacon:1261744974534541352>",
		FooterText = "Binini Hub",
		FruitMinValue = 1000000,
		ItemMinRarity = 3,
		MaxFieldLen = 1024,
		MaxDescLen = 3800,
	}

	local Players2 = game:GetService("Players")
	local HttpService_ = game:GetService("HttpService")
	local commF = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
	local localPlayer2 = Players2.LocalPlayer

	local function fn7(arg)
		local ok, result = pcall(function()
			return tostring(arg)
		end)

		return ok and result or "nil"
	end

	local function fn8(arg, arg2)
		local v_12 = fn7(arg or "")
		if arg2 < #v_12 then
			return v_12:sub(1, arg2 - 3) .. "..."
		end
		return v_12
	end

	local function fn9(arg, arg2)
		return "```\n" .. fn8(arg or "", arg2 - 8) .. "\n```"
	end

	local function fn10(arg)
		local tbl9 = {}
		local v_12 = ipairs
		arg = arg or {}

		for _, v_13 in v_12(arg) do
			tbl9[#tbl9 + 1] = fn7(v_13.Name or v_13)
		end

		return table.concat(tbl9, ",\n")
	end

	local function fn11(arg)
		local tbl9 = {}
		local v_12 = ipairs
		local tbl10 = arg or {}

		for _, v_13 in v_12(tbl10) do
			tbl9[#tbl9 + 1] = fn7(v_13)
		end

		return table.concat(tbl9, ",\n")
	end

	local function fn12(...)
		local tbl9 = { ... }

		local ok, result = pcall(function()
			return commF:InvokeServer(unpack(tbl9))
		end)

		if ok then
			return result
		end
		return nil
	end

	local function fn13()
		return os.date("!%Y-%m-%dT%H:%M:%SZ")
	end

	local function fn14()
		local str = localPlayer2.Data and localPlayer2.Data.DevilFruit and localPlayer2.Data.DevilFruit.Value or ""
		str = str ~= "" and str or "None"
		local n4 = 0

		if str ~= "None" then
			local character = localPlayer2.Backpack:FindFirstChild(str) or localPlayer2.Character and localPlayer2.Character:FindFirstChild(str)

			if character and character:FindFirstChild("Level") then
				n4 = tonumber(character.Level.Value) or 0
			end
		end

		return str, n4
	end

	local function fn15()
		if not fn12("AwakeningChanger", "Check") then
			return {}
		end
		local getAwakenedAbilities = fn12("getAwakenedAbilities")
		local tbl9 = {}

		if type(getAwakenedAbilities) == "table" then
			for k, getAwakenedAbility in pairs(getAwakenedAbilities) do
				if type(getAwakenedAbility) == "table" and getAwakenedAbility.Awakened then
					table.insert(tbl9, fn7(k))
				end
			end
		end

		table.sort(tbl9)
		return tbl9
	end

	local function fn16()
		local tbl9 = {}

		for _, v_12 in ipairs({
			"Death Step",
			"Sharkman Karate",
			"Electric Claw",
			"Dragon Talon",
			"Superhuman",
			"Godhuman",
			"Sanguine Art",
		}) do
			if fn12("Buy" .. v_12:gsub(" ", ""), true) == 1 then
				table.insert(tbl9, v_12)
			end
		end

		table.sort(tbl9)
		return tbl9
	end

	local function fn17()
		local tbl9 = {}
		local tbl10 = {}
		local v_12 = ipairs
		local tbl11 = fn6() or {}

		for _, v_13 in v_12(tbl11) do
			if type(v_13) == "table" then
				local num = tonumber(v_13.Value)
				local num2 = tonumber(v_13.Rarity)
				local v_14 = fn7(v_13.Name or "")

				if v_14 ~= "" and v_14:find("-", 1, true) then
					v_14 = v_14:split("-")[1]
				end

				if num and num >= tbl8.FruitMinValue then
					table.insert(tbl9, { Name = v_14, Value = num })
				elseif num2 and num2 >= tbl8.ItemMinRarity then
					table.insert(tbl10, { Name = v_14, Rarity = num2 })
				end
			end
		end

		table.sort(tbl9, function(arg, arg2)
			return (arg.Value or 0) > (arg2.Value or 0)
		end)

		table.sort(tbl10, function(arg, arg2)
			return (arg.Rarity or 0) > (arg2.Rarity or 0)
		end)

		return tbl9, tbl10
	end

	local tbl9 = {
		Name = fn7(localPlayer2 and localPlayer2.Name or "Unknown"),
		Level = localPlayer2.Data and localPlayer2.Data.Level and tonumber(localPlayer2.Data.Level.Value) or 0,
		Race = localPlayer2.Data and localPlayer2.Data.Race and fn7(localPlayer2.Data.Race.Value) or "Unknown",
	}

	local function fn18()
		if localPlayer2.Character and localPlayer2.Character:FindFirstChild("RaceTransformed") then
			return "V4"
		end

		if fn12("Wenlocktoad", "1") == -2 then
			return "V3"
		end

		if fn12("Alchemist", "1") == -2 then
			return "V2"
		end
		return "V1"
	end

	tbl9.RaceVer = "[" .. fn18() .. "]"
	local v_12, v_13 = fn14()
	tbl9.Fruit = v_12
	tbl9.FruitShort = v_12 ~= "None" and v_12:split("-")[1] or "None"
	tbl9.FruitMastery = v_13
	local v_14 = fn15()
	local str = #v_14 > 0 and " " .. table.concat(v_14, " ") or ""
	tbl9.FruitText = v_12 == "None" and "None" or tbl9.FruitShort .. " [" .. tostring(v_13) .. str .. "]"
	tbl9.Melees = fn16()
	local v_15, v_16 = fn17()
	tbl9.InventoryFruit = v_15
	tbl9.Inventory = v_16
	local n4 = tbl8.MaxFieldLen - 10
	local v_17 = fn8(fn11(tbl9.Melees), n4)
	local n5 = tbl8.MaxFieldLen - 10
	local v_18 = fn8(fn10(tbl9.InventoryFruit), n5)
	local n6 = tbl8.MaxFieldLen - 10
	local v_19 = fn8(fn10(tbl9.Inventory), n6)
	local str2 = ",\n Race : " .. tbl9.Race .. " " .. tbl9.RaceVer .. ",\n Fruits : " .. tbl9.FruitText .. " "
	local tbl10 = { username = tbl8.Username, avatar_url = tbl8.AvatarURL }
	local embeds = {}

	local tbl11 = {
		title = tbl8.Title,
		description = fn9(fn8(" Username : " .. tbl9.Name .. ",\n Level : " .. tostring(tbl9.Level) .. str2, tbl8.MaxDescLen), tbl8.MaxDescLen),
		color = tonumber(tbl8.Color),
		footer = { text = tbl8.FooterText },
	}

	local fields = {}
	local tbl12 = { name = "**Melee**", value = fn9(v_17, tbl8.MaxFieldLen), inline = true }
	local tbl13 = { name = "**Inventory Fruit**", value = fn9(v_18, tbl8.MaxFieldLen), inline = true }
	local tbl14 = { name = "**Inventory**", value = fn9(v_19, tbl8.MaxFieldLen), inline = false }
	fields[1] = tbl12
	fields[2] = tbl13
	fields[3] = tbl14
	tbl11.fields = fields
	tbl11.thumbnail = { url = tbl8.BannerURL }
	tbl11.timestamp = fn13()
	embeds[1] = tbl11
	tbl10.embeds = embeds

	local ok, result = pcall(function()
		return Settings["Input Url Webhook"]
	end)

	if not ok or not result or result == "" then
		return
	end

	pcall(function()
		ExploitReq({
			Url = result,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService_:JSONEncode(tbl10),
		})
	end)
end

SectionWebhook.CreateToggle({ Title = "Noti Profile", Desc = nil, Default = Settings["Noti Profile"] or false }, function(arg)
	if arg then
		spawn(function()
			while Settings["Noti Profile"] and wait() do
				pcall(function()
					Webhookprofile()
					wait(300)
				end)
			end
		end)
	end

	SaveSettings("Noti Profile", arg)
end)

TableRarityFruit = { Mythical = false, Legendary = false, Rare = false, Uncommon = false, Common = false }

SectionWebhook.CreateDropdown({
	Title = "Select Rarity Fruit",
	List = PrepareMultiSelectList(TableRarityFruit, Settings["Select Rarity Fruit"]),
	Search = true,
	Selected = true,
	Default = Settings["Select Rarity Fruit"] or nil,
}, function(arg, arg2)
	SaveSettings("Select Rarity Fruit", arg, arg2)
end)

SectionWebhook.CreateToggle({ Title = "Webhook Store Fruit", Desc = nil, Default = Settings["Webhook Store Fruit"] or false }, function(arg)
	SaveSettings("Webhook Store Fruit", arg)
end)

SectionWebhook.CreateToggle({
	Title = "Webhook Find Prehistoric Island",
	Desc = nil,
	Default = Settings["Webhook Find Prehistoric Island"] or false,
}, function(arg)
	SaveSettings("Webhook Find Prehistoric Island", arg)
end)

SectionWebhook.CreateToggle({
	Title = "Webhook Find Leviathan",
	Desc = nil,
	Default = Settings["Webhook Find Leviathan"] or false,
}, function(arg)
	SaveSettings("Webhook Find Leviathan", arg)
end)

SectionWebhook.CreateToggle({ Title = "Webhook Destroy IDK", Desc = nil, Default = Settings["Webhook Destroy IDK"] or false }, function(arg)
	SaveSettings("Webhook Destroy IDK", arg)
end)

SectionWebhook.CreateToggle({ Title = "Webhook Find Mirage", Desc = nil, Default = Settings["Webhook Find Mirage"] or false }, function(arg)
	SaveSettings("Webhook Find Mirage", arg)
end)

SettingPage = Main.CreatePage({ Page_Name = "Setting", Page_Title = "Setting Tab" })
tbl = SettingPage.CreateSection("Settings")

tbl.CreateToggle({ Title = "White Screen", Desc = nil, Default = Settings["White Screen"] or false }, function(arg)
	if not arg then
		game:GetService("RunService"):Set3dRenderingEnabled(true)
	else
		game:GetService("RunService"):Set3dRenderingEnabled(false)
	end

	SaveSettings("White Screen", arg)
end)

tbl.CreateToggle({ Title = "Black Screen", Desc = nil, Default = Settings["Black Screen"] or false }, function(arg)
	spawn(function()
		repeat
			wait()
		until imageLabel

		if not arg then
			imageLabel.Visible = false
			game:GetService("RunService"):Set3dRenderingEnabled(true)
			SetRobloxGUI(true)
		else
			imageLabel.Visible = true
			game:GetService("RunService"):Set3dRenderingEnabled(false)
			SetRobloxGUI(false)
		end
	end)

	SaveSettings("Black Screen", arg)
end)

local function fn7(arg)
	if type(arg) ~= "table" then
		return arg
	end
	local tbl8 = {}
	local tbl9 = {}
	local tbl10 = {}
	local str = "{\n"
	local n4 = 1

	while true do
		local n5 = 0

		for k in pairs(arg) do
			n5 += 1
		end

		local v_12, v_13, v_14 = pairs(arg)
		local n6 = 1

		for k, v_15 in v_12, v_13, v_14 do
			if tbl8[arg] == nil or n6 >= tbl8[arg] then
				local find = string.find
				local v_16 = T[24](str:len())
				local insert = table.insert

				if find(str, "}", T:d5(v_16)) then
					str ..= ",\n"
				elseif not string.find(str, "\n", str:len()) then
					str ..= "\n"
				end

				insert(tbl10, str)
				local str2

				if type(k) == "number" or type(k) == "boolean" then
					str2 = "[" .. tostring(k) .. "]"
				else
					str2 = "[\"" .. tostring(k) .. "\"]"
				end

				local str3

				if type(v_15) == "number" or type(v_15) == "boolean" then
					str3 = "" .. string.rep("\t", n4) .. str2 .. " = " .. tostring(v_15)

					if n6 == n5 then
						str = str3 .. "\n" .. string.rep("\t", n4 - 1) .. "}"
					else
						str = str3 .. ","
					end

					n6 += 1
				elseif type(v_15) == "table" then
					str = "" .. string.rep("\t", n4) .. str2 .. " = {\n"
					table.insert(tbl9, arg)
					table.insert(tbl9, v_15)
					tbl8[arg] = n6 + 1
					break
				else
					str3 = "" .. string.rep("\t", n4) .. str2 .. " = \"" .. tostring(v_15) .. "\""

					if n6 == n5 then
						str = str3 .. "\n" .. string.rep("\t", n4 - 1) .. "}"
					else
						str = str3 .. ","
					end

					n6 += 1
				end
			else
				if n6 == n5 then
					str ..= "\n" .. string.rep("\t", n4 - 1) .. "}"
				end

				n6 += 1
			end
		end

		if n5 == 0 then
			str ..= "\n" .. string.rep("\t", n4 - 1) .. "}"
		end

		if #tbl9 > 0 then
			arg = tbl9[#tbl9]
			tbl9[#tbl9] = nil
			n4 = tbl8[arg] == nil and n4 + 1 or n4 - 1
			continue
		end

		break
	end

	table.insert(tbl10, str)
	return "getgenv().Config = " .. table.concat(tbl10)
end

tbl.CreateToggle({ Title = "Remove Notifications", Desc = nil, Default = Settings["Remove Notifications"] or false }, function(arg)
	SaveSettings("Remove Notifications", arg)
end)

pcall(function()
	DisplayNoti = getupvalues(v_2(game:GetService("ReplicatedStorage").Notification).Display)[1]
end)

spawn(function()
	repeat
		wait(1)
	until Settings["Remove Notifications"]

	v_2(game:GetService("ReplicatedStorage").Notification).Dead = function(arg)
		if Settings["Remove Notifications"] then
			return true
		end
		local creationTime = arg.CreationTime
		return tick() - creationTime > arg.Duration
	end

	v_2(game:GetService("ReplicatedStorage").Notification).Display = function(arg)
		if Settings["Remove Notifications"] then
			return true
		end

		if arg.Displayed then
			return false
		end
		arg.Displayed = true
		arg.CreationTime = tick()
		arg.Label.Visible = true
		DisplayNoti:Add(arg)
		return true
	end
end)

tbl.CreateToggle({
	Title = "Auto rejoin Disconnect",
	Desc = nil,
	Default = Settings["Auto rejoin Disconnect"] or false,
}, function(arg)
	SaveSettings("Auto rejoin Disconnect", arg)
end)

tbl.CreateToggle({ Title = "Auto Load Script", Desc = nil, Default = Settings["Auto Load Script"] or false }, function(arg)
	SaveSettings("Auto Load Script", arg)
end)

tbl.CreateToggle({ Title = "Boost Fps", Desc = nil, Default = Settings["Boost Fps"] or false }, function(arg)
	if arg then
		local v_12 = game
		local lighting = v_12.Lighting
		local terrain = v_12.Workspace.Terrain
		terrain.WaterWaveSize = 0
		terrain.WaterWaveSpeed = 0
		terrain.WaterReflectance = 0
		terrain.WaterTransparency = 0
		lighting.GlobalShadows = false
		lighting.FogEnd = 9e9
		lighting.Brightness = 0
		settings().Rendering.QualityLevel = "Level01"

		for _, descendant in pairs(v_12:GetDescendants()) do
			if descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart") then
				descendant.Material = "Plastic"
				descendant.Reflectance = 0
			else
				local isDecal = descendant:IsA("Decal")

				if not isDecal then
					local isTexture = descendant:IsA("Texture")
					isDecal = true
					isDecal = isTexture and isDecal
				end

				if isDecal then
					descendant.Transparency = 1
				elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") and descendant.Parent.Name ~= "RelicFire" then
					descendant.Lifetime = NumberRange.new(0)
				elseif descendant:IsA("Explosion") then
					descendant.BlastPressure = 1
					descendant.BlastRadius = 1
				elseif descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
					descendant.Enabled = false
				elseif descendant:IsA("MeshPart") then
					descendant.Material = "Plastic"
					descendant.Reflectance = 0
					descendant.TextureID = 10385902758728956
				end
			end
		end

		for _, child in pairs(lighting:GetChildren()) do
			if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
				child.Enabled = false
			end
		end

		wait(1)
		local map = workspace:WaitForChild("Map")
		local unloaded = game.ReplicatedStorage:WaitForChild("Unloaded")
		local smoothPlastic = Enum.Material.SmoothPlastic
		local descendants = map:GetDescendants()
		wait(0.5)
		local descendants2 = unloaded:GetDescendants()
		wait(0.5)
		local clock = os.clock
		local wait_ = task.wait
		local isA = unloaded.IsA
		local v_13 = clock()
		local now = tick()
		local n4 = 0
		local v_14 = v_13

		for _, v_15 in next, descendants, nil do
			if isA(v_15, "BasePart") then
				v_15.Material = smoothPlastic
				n4 += 1

				if clock() - v_14 > 0.0083333333333333332 then
					wait_()
					wait_()
					v_14 = clock()
				end
			elseif v_15:IsA("Texture") and not v_15:GetAttribute("Offset") then
				v_15:Destroy()
			end
		end

		for _, v_15 in next, descendants2, nil do
			if isA(v_15, "BasePart") then
				v_15.Material = smoothPlastic
				n4 += 1

				if clock() - v_14 > 0.0083333333333333332 then
					wait_()
					wait_()
					v_14 = clock()
				end
			elseif v_15:IsA("Texture") and not v_15:GetAttribute("Offset") then
				v_15:Destroy()
			end
		end

		pcall(function()
			local playerScripts = game.Players.LocalPlayer:FindFirstChild("PlayerScripts")
			playerScripts = playerScripts and playerScripts:FindFirstChild("OptimizerClientActor")

			if playerScripts and playerScripts.SendMessage then
				playerScripts:SendMessage("Optimize", true)
			end
		end)

		print("Time taken to Fast Mode: ", tick() - now, clock() - v_13)
	end

	SaveSettings("Boost Fps", arg)
end)

spawn(function()
	while true do
		wait()
		if not (Settings["Boost Fps"] and game.Workspace:FindFirstChild("_WorldOrigin")) then
			continue
		end
		break
	end

	workspace._WorldOrigin.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart") or descendant:IsA("TrussPart") then
			descendant.Transparency = 1
			descendant.Material = "Plastic"
			descendant.Reflectance = 0
		end

		if descendant:IsA("Decal") or descendant:IsA("Texture") and decalsyeeted then
			descendant.Transparency = 1
		end

		if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
			if descendant.Parent.Name ~= "RelicFire" then
				descendant.Enabled = false
				descendant.Lifetime = NumberRange.new(0)
			end
		end

		if descendant:IsA("Explosion") then
			descendant.Enabled = false
			descendant.BlastPressure = 1
			descendant.BlastRadius = 1
		end

		if descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
			descendant.Enabled = false
		end

		if descendant:IsA("MeshPart") then
			descendant.Transparency = 1
			descendant.Material = "Plastic"
			descendant.Reflectance = 0
			descendant.TextureID = 10385902758728956
		end
	end)
end)

tbl.CreateButton({ Title = "Copy Config" }, function()
	local v_12 = setclipboard
	local v_13 = fn7
	local data = HttpService:JSONDecode(readfile(FolderName .. "/" .. SaveFileName))
	v_12(v_13(data))
	lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Successfully Copy Config", ShowTime = 5 })
end)

tbl.CreateBind({ Title = "Toggle GUI", Key = Enum.KeyCode.LeftControl }, function()
	getgenv().UIToggled = not getgenv().UIToggled

	if game.CoreGui:FindFirstChild("Nousigi Hub GUI") then
		for _, child in ipairs(game.CoreGui:GetChildren()) do
			if child.Name == "Nousigi Hub GUI" then
				child.Enabled = getgenv().UIToggled
			end
		end
	end
end)

spawn(function()
	pcall(function()
		if not (Settings["Auto Load Script"] and getgenv().Key) then
			while true do
				wait()
				if not (Settings["Auto Load Script"] and getgenv().Key) then
					continue
				end
				break
			end
		end

		local queueOnTeleport

		if syn then
			queueOnTeleport = syn.queue_on_teleport
		else
			queueOnTeleport = queue_on_teleport
		end

		if not queueOnTeleport then
			return
		end

		queueOnTeleport(string.format([[ repeat wait() until game:IsLoaded()
 getgenv().Key = %q
 getgenv().__BANANA_SCRIPT_ROUTE = "bf_main"
 return loadstring(game:HttpGet("https://banana-hub.xyz/loader/banana.lua"))()
 ]], getgenv().Key))
	end)
end)

loadstring([[local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
setreadonly(MT, false)
MT.__namecall = newcclosure(function(self, ...)
 local Method = getnamecallmethod()
 local Args = { ... }
 if
 Method == "FireServer"
 and self.Name == "RemoteEvent"
 and AimPos
 and tostring(AimPos.X) ~= "nan"
 and (
 Settings["Auto Event Prehistoric Island"]
 or Settings["Kill players When complete Trial"]
 or Settings["Auto Quest Dragon Hunter"]
 or Settings["Auto Quest Dojo Trainer"]
 or Settings["Farm Mastery"]
 or Settings["Auto Attack Leviathan"]
 or Settings["Auto Sea Event"]
 or Settings["Auto Upgrade Race V2-V3"]
 or Settings["Auto Trial"]
 or Settings["Auto Aimbot"]
 or Settings["Auto Shipwright"]
 )
 then
 if #Args == 1 and typeof(Args[1]) == "Vector3" then
 Args[1] = AimPos.Position
 end
 if #Args == 1 and typeof(Args[1]) == "CFrame" then
 Args[1] = AimPos
 end
 end
 return OldNameCall(self, unpack(Args))
end)
setreadonly(MT, true)
]])()

RunService = game:GetService("RunService")

pcall(function()
	runAsync = v_2(game.ReplicatedStorage.Util.runAsync)
end)

pcall(function()
	Spinner = v_2(game:GetService("ReplicatedStorage").Controllers.UI.Spinner)
end)

pcall(function()
	SharedGachaUtil = v_2(game.ReplicatedStorage.Modules.Gacha.SharedGachaUtil)
end)

pcall(function()
	TextUtil = v_2(game.ReplicatedStorage.Modules.Util.TextUtil)
end)

if not getgenv().BananaCatMainLoop then
	getgenv().BananaCatMainLoop = true
	lastHopTick = tick()
	lastFruitTick = tick()

	RunService.RenderStepped:Connect(function()
		pcall(function()
			sethiddenproperty(localPlayer, "SimulationRadius", 5000)
		end)

		local v_12 = lastHopTick

		if tick() - v_12 >= 500 then
			lastHopTick = tick()

			pcall(function()
				writefile("Banana Cat Hub/Jobid.json", HttpService:JSONEncode({}))
			end)
		end

		pcall(function()
			if Settings["Auto Aimbot"] then
				local v_13

				if Settings["Select Method Aimbot"] == "Select Player" then
					v_13 = workspace.Characters[Settings["Select Player PVP"]]
				else
					v_13 = ClosestPartaimbot()
				end

				if v_13 and v_13:FindFirstChild("HumanoidRootPart") then
					v_5.Hit = v_13.HumanoidRootPart.CFrame
					v_5.Target = v_13
					getgenv().AimPos = CFrame.new(v_13.HumanoidRootPart.Position, v_13.HumanoidRootPart.Position + v_13.HumanoidRootPart.Velocity / 0.5)
				end
			end

			local character = localPlayer.Character
			local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 and humanoidRootPart2:FindFirstChild("FloatForce") and not TweenManager.currentTween then
				local flag2 = not ToggleNoclip()
				local flag3

				if flag2 then
					flag3 = flag2
				else
					local lastCall = tbl3.LastCall
					flag3 = tick() - lastCall > 2
				end

				if flag3 then
					TweenManager.CancelCurrent()
				end
			end

			if character and (ToggleNoclip() or Settings.Noclip) then
				local v_13 = next
				local descendants, v_14 = character:GetDescendants()

				for _, v_15 in v_13, descendants, v_14 do
					if (v_15:IsA("MeshPart") or v_15:IsA("Part")) and v_15.CanCollide then
						v_15.CanCollide = false
					end
				end
			end

			character = character and character:FindFirstChildOfClass("Humanoid")

			if character then
				if Settings["Change WalkSpeed"] then
					character.WalkSpeed = Settings["Input WalkSpeed"] or 16
				end

				if Settings["Change JumpPower"] then
					character.JumpPower = Settings["Input JumpPower"] or 50
				end
			end
		end)

		local v_13 = lastFruitTick

		if tick() - v_13 >= 0.5 then
			lastFruitTick = tick()

			local ok, result = pcall(function()
				if Settings["Random Devil Fruit"] then
					local spinnerWindow = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("SpinnerWindow")

					if not spinnerWindow or not spinnerWindow.Enabled then
						RandomFruit()
					elseif spinnerWindow.Enabled and Spinner then
						pcall(function()
							Spinner:Close()
						end)
					end
				end

				if Settings["Auto Trade Bone"] then
					ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
				end

				if Settings["Buy Blox Fruit Sniper Shop"] then
					BuyFruitShop()
				end

				if Settings["Auto Store Fruit"] then
					if localPlayer and localPlayer:FindFirstChild("Backpack") then
						StoreFruit(localPlayer.Backpack)
					end

					if localPlayer and localPlayer.Character then
						StoreFruit(localPlayer.Character)
					end
				end

				if Settings["Auto Awake Fruit"] then
					ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Check")
					ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
				end

				local function fn8()
					local tbl8 = { "Shisui", "Saddi", "Wando" }
					local backpack = localPlayer and localPlayer:FindFirstChild("Backpack")
					local character = localPlayer and localPlayer.Character

					for _, v_14 in ipairs(tbl8) do
						if not (backpack and backpack:FindFirstChild(v_14) or character and character:FindFirstChild(v_14)) then
							local flag2 = false

							pcall(function()
								local response = ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventoryWeapons")

								if type(response) == "table" then
									for _, v_15 in pairs(response) do
										if v_15.Name == v_14 then
											flag2 = true
											break
										end
									end
								end
							end)

							if not flag2 then
								return v_14
							end
						end
					end

					return nil
				end

				if Settings["Auto Buy Legendary Sword"] then
					ReplicatedStorage.Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2")

					if Settings["Hop Server [ Haki color or Legendary Sword]"] then
						local v_14 = fn8()

						if v_14 then
							SpecialHop(v_14)
						else
							lib.CreateNoti({ Title = "Banana Cat Hub", Desc = "Full Sword Legendary", ShowTime = 5 })
						end
					end
				end

				if Settings["Auto Buy Haki Color"] then
					ReplicatedStorage.Remotes.CommF_:InvokeServer("ColorsDealer", "2")

					if Settings["Hop Server [ Haki color or Legendary Sword]"] then
						HopServer()
					end
				end
			end)

			if result then
				print(result)
			end
		end
	end)
end

getgenv().__BF_LOADED = true
