if not game:IsLoaded() then
	game.Loaded:Wait()
end

if getgenv().LixHubLoaded then
	return
end

getgenv().LixHubLoaded = true

local StarterGui = game:GetService("StarterGui")

local scripts = {
	[33861560] = {
		name = "Universal Tower Defense",
		ffa = true,
		url = "https://api.luarmor.net/files/v4/loaders/7b964728f0872ba471d90063958fc028.lua",
	},

	[9190691] = {
		name = "Anime Squadron",
		ffa = false,
		script_id = "2687bfdac44a8af920b0137a331c8b33",
	},

	[17347863] = {
		name = "Attack On Titan Revolution",
		ffa = false,
		script_id = "434886011fd1689509fc7d727cebb483",
	},

	[35929511] = {
		name = "Anime Expeditions",
		ffa = false,
		script_id = "ed4e6fa2c50ca4ea890bedf40fc647f2",
	},
	[111457579] = {
		name = "Anime Origins",
		ffa = false,
		script_id = "79cd2cfb6a8e0410f8d173691ac5affe",
	},
	[12851171] = {
		name = "Slayers 2",
		ffa = false,
		script_id = "e9b5a1c2f839972aa230cbd4c29dc423",
	},
	[35186067] = {
		name = "Re://Adventures",
		ffa = false,
		script_id = "d19cdd5d7e1bb03101e7b15381c88777",
	},
}

local current = scripts[game.CreatorId]

if not current then
	getgenv().LixHubLoaded = nil

	StarterGui:SetCore("SendNotification", {
		Title = "LixHub",
		Text = "Game not supported",
		Duration = 5,
	})

	return
end

StarterGui:SetCore("SendNotification", {
	Title = "LixHub",
	Text = "Script loading...",
	Duration = 5,
})

if current.ffa then
	loadstring(game:HttpGet(current.url))()
	return
end

getgenv().LixHub = {
	name = current.name,
	script_id = current.script_id,
	creator_id = game.CreatorId,
	linkvertise = "https://ads.luarmor.net/get_key?for=LixHub_Key__Linkvertise-WEFGHDrpehny",
	workink = "https://ads.luarmor.net/get_key?for=LixHub_Key__LootLabs-dcrcsXfaDhbB",
}

loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/Lixtron/Hub/refs/heads/main/keysystem.lua"
))()
