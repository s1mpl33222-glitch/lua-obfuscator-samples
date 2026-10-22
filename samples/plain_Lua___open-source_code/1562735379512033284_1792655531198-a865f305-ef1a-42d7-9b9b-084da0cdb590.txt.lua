local ProfileService = require(game.ServerScriptService.ProfileService)
local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local DataStore = DataStoreService:GetDataStore("DonasiStats")
local Profiles = {}
local saveStructure = {
	Donated = 0,
	Raised = 0,
}

local cheaters = {
	"",
}

local PlayerProfileStore = ProfileService.GetProfileStore("PlayerDonationData", saveStructure)
local function PlayerDataLoaded(player)
	local profile = Profiles[player]

	local folder = player:FindFirstChild("leaderstats")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "leaderstats"
		folder.Parent = player
	end

	local Donated = folder:FindFirstChild("Donated")
	if not Donated then
		Donated = Instance.new("IntValue")
		Donated.Name = "Donated"
		Donated.Parent = folder
	end
	Donated.Value = profile.Data.Donated

	local Raised = folder:FindFirstChild("Raised")
	if not Raised then
		Raised = Instance.new("IntValue")
		Raised.Name = "Raised"
		Raised.Parent = folder
	end
	Raised.Value = profile.Data.Raised

	spawn(function()
		if profile ~= nil then
			if table.find(cheaters, player.Name) then
				profile.Data.Donated = 0
				profile.Data.Raised = 0
			end

			Donated.Value = profile.Data.Donated
			Raised.Value = profile.Data.Raised
		end
	end)

end

local function PlayerAdded(player)
	local profile = PlayerProfileStore:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")
	if profile ~= nil then
		profile:ListenToRelease(function()
			Profiles[player] = nil
			player:Kick("Your profile has been loaded remotely. Please rejoin.")
		end)

		if player:IsDescendantOf(Players) then
			Profiles[player] = profile

			PlayerDataLoaded(player)
		else
			profile:Release()
		end
	else
		player:Kick("Unable to load saved data. Please rejoin.")
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	spawn(function()
		PlayerAdded(player)
	end)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		local success, errorMessage = pcall(function()
			DataStore:SetAsync(player.UserId, {
				Donated = player.leaderstats.Donated.Value,
				Raised = player.leaderstats.Raised.Value,
			})
		end)

		if not success then
			warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
		end

		profile:Release()
	end
end)

local function AddRaised(userID, amount)
	local player = Players:GetPlayerByUserId(userID)
	if player then
		local profile = Profiles[player]
		profile.Data.Raised = profile.Data.Raised + amount
	end
end

local function AddDonated(userID, amount)
	local player = Players:GetPlayerByUserId(userID)
	if player then
		local profile = Profiles[player]
		profile.Data.Donated = profile.Data.Donated + amount
	end
end

game.ReplicatedStorage.Jar_Replicated.JarEvents.IncreaseVal.Event:Connect(function(userID, amount, stat)
	if stat == "Raised" then
		AddRaised(userID, amount)
	elseif stat == "Donated" then
		AddDonated(userID, amount)
	end
end)

local GetPlayerdata = game.ReplicatedStorage.Jar_Replicated.JarEvents.GetPlayerData

GetPlayerdata.OnServerEvent:Connect(function(player, userID, stat, val)
	local profile = Profiles[player]
	GetPlayerdata:FireClient(player, profile.Data[stat], val)
end)

return Profiles