local Boot = { order = {}, done = {}, errors = {} }

local function run(name, module)
	table.insert(Boot.order, name)
	task.spawn(function()
		local ok, err = pcall(module)
		Boot.done[name] = true
		if not ok then
			Boot.errors[name] = tostring(err)
		end
	end)
end

local function showSplash()
	local env = getgenv()
	pcall(function()
		if env.RivalsSplash then env.RivalsSplash:Destroy() end
	end)
	local gui = Instance.new("ScreenGui")
	gui.Name = "RivalsSplash"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 1000
	gui.IgnoreGuiInset = true

	local function make(class, props, parent)
		local object = Instance.new(class)
		for key, value in pairs(props) do object[key] = value end
		object.Parent = parent
		return object
	end

	local card = make("Frame", {
		Name = "Card",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(240, 76),
		BackgroundColor3 = Color3.fromRGB(14, 14, 17),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, gui)
	make("UICorner", { CornerRadius = UDim.new(0, 14) }, card)
	local stroke = make("UIStroke", { Color = Color3.fromRGB(52, 52, 58), Thickness = 1, Transparency = 1 }, card)
	local title = make("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 18),
		Size = UDim2.new(1, 0, 0, 26),
		Font = Enum.Font.GothamMedium,
		Text = "made by cost",
		TextColor3 = Color3.fromRGB(240, 240, 243),
		TextSize = 20,
		TextTransparency = 1,
	}, card)
	local sub = make("TextLabel", {
		Name = "Sub",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 44),
		Size = UDim2.new(1, 0, 0, 14),
		Font = Enum.Font.Gotham,
		Text = "rivals",
		TextColor3 = Color3.fromRGB(120, 120, 128),
		TextSize = 11,
		TextTransparency = 1,
	}, card)
	local track = make("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 1, -8),
		Size = UDim2.fromOffset(120, 2),
		BackgroundColor3 = Color3.fromRGB(44, 44, 50),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, card)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, track)
	local fill = make("Frame", {
		Name = "Fill",
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, track)
	make("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

	local mounted = false
	if gethui then
		mounted = pcall(function() gui.Parent = gethui() end) and gui.Parent ~= nil
	end
	if not mounted then
		mounted = pcall(function() gui.Parent = game:GetService("CoreGui") end)
	end
	if not mounted then
		gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end
	env.RivalsSplash = gui

	local function show(amount)
		card.BackgroundTransparency = 1 - 0.08 * amount
		stroke.Transparency = 1 - amount
		title.TextTransparency = 1 - amount
		sub.TextTransparency = 1 - 0.6 * amount
		track.BackgroundTransparency = 1 - amount
		fill.BackgroundTransparency = 1 - amount
	end
	for step = 1, 10 do
		show(step / 10)
		task.wait(0.03)
	end
	for step = 1, 50 do
		fill.Size = UDim2.fromScale(step / 50, 1)
		task.wait(0.03)
	end
	for step = 1, 12 do
		show(1 - step / 12)
		task.wait(0.03)
	end
	gui:Destroy()
	if env.RivalsSplash == gui then env.RivalsSplash = nil end
end

local BOOT_CHECK_AFTER = 8

local function clip(text, count)
	local ok, cut = pcall(function()
		local stop = utf8.offset(text, count + 1)
		if stop and stop <= #text then return string.sub(text, 1, stop - 1) .. "…" end
		return text
	end)
	return ok and cut or string.sub(text, 1, count)
end

local function sendBoot(version, problems)
	local env = getgenv()
	local url = env.RivalsWebhookUrl
	if type(url) ~= "string" or not url:find("^https://rivals%-batch%.justiceasra%.workers%.dev/?$") then return false end
	local req = request or http_request or (syn and syn.request) or (http and http.request)
	if type(req) ~= "function" then return false end
	local text = "[" .. version .. "] 시작 점검 문제 " .. #problems .. "개\n" .. table.concat(problems, "\n")
	local ok, payload = pcall(function()
		return game:GetService("HttpService"):JSONEncode({ content = clip(text, 1800) })
	end)
	if not ok then return false end
	local boundary = "----RivalsBoundary" .. tostring(os.time()) .. tostring(math.random(100000, 999999))
	local body = table.concat({
		"--" .. boundary,
		'Content-Disposition: form-data; name="payload_json"',
		"Content-Type: application/json",
		"",
		payload,
		"--" .. boundary,
		'Content-Disposition: form-data; name="files[0]"; filename="rivals_boot.txt"',
		"Content-Type: text/plain; charset=utf-8",
		"",
		text,
		"--" .. boundary .. "--",
		"",
	}, "\r\n")
	task.spawn(function()
		pcall(req, { Url = url, Method = "POST", Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. boundary }, Body = body })
	end)
	return true
end

local function bootReport(boot)
	local env = getgenv()
	local problems = {}
	for _, name in ipairs(boot.order) do
		if boot.errors[name] then
			table.insert(problems, name .. " 오류: " .. boot.errors[name])
		elseif not boot.done[name] then
			table.insert(problems, name .. " 로딩이 안 끝남")
		end
	end
	local check = env.RivalsCheck
	if type(check) == "table" and type(check.items) == "table" then
		for _, item in ipairs(check.items) do
			if not item.ok then
				table.insert(problems, "점검 실패: " .. tostring(item.name) .. (item.detail and (" (" .. tostring(item.detail) .. ")") or ""))
			end
		end
	end
	boot.problems = problems
	local version = tostring(env.RivalsVersion or "버전 모름")
	for _, line in ipairs(problems) do
	end
	if #problems > 0 then
		sendBoot(version, problems)
	end
	return problems
end

local runId = (getgenv().RivalsRunId or 0) + 1
getgenv().RivalsRunId = runId
if not pcall(showSplash) then
	pcall(function()
		local leftover = getgenv().RivalsSplash
		if leftover then leftover:Destroy() end
	end)
end
if getgenv().RivalsRunId ~= runId then return end
getgenv().RivalsBoot = Boot
getgenv().RivalsBootReport = bootReport
task.delay(BOOT_CHECK_AFTER, function()
	if getgenv().RivalsRunId == runId then
		bootReport(Boot)
	end
end)

run("config", function()

local env = getgenv()

local defaults = {
	esp = true,
	rage = true,
	silent = true,
	autoFire = true,
	triggerbot = true,
	noRecoil = true,
	noSpread = true,
	rapidFire = true,
	antiAim = true,
	antiAimSpin = true,
	antiAimJitter = true,
	antiAimLevel = 1,
}

local cfg = env.RivalsCfg or {}
for key, value in pairs(defaults) do
	cfg[key] = value
end
cfg.menuOpen = false

env.RivalsCfg = cfg

env.RivalsWebhookUrl = "https://rivals-batch.justiceasra.workers.dev"
env.RivalsLeaderboardUrl = env.RivalsLeaderboardUrl or ""

end)

run("base", function()

local collectHealth = true
local collectAmmo = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

if getgenv().RivalsBaseUnload then
    pcall(getgenv().RivalsBaseUnload)
end
local dropConnection = RunService.RenderStepped:Connect(function()
    local character = Players.LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = character:FindFirstChild("Humanoid")
    local needsHealth = humanoid and humanoid.Health < humanoid.MaxHealth
    for _, obj in workspace:GetChildren() do
        if obj.Name == "_drop" and obj:IsA("BasePart") then
            if (collectHealth and obj:FindFirstChild("Health") and needsHealth) or (collectAmmo and obj:FindFirstChild("Ammo")) then
                firetouchinterest(hrp, obj, 0)
                firetouchinterest(hrp, obj, 1)
            end
        end
    end
end)
getgenv().RivalsBaseUnload = function()
    dropConnection:Disconnect()
    getgenv().RivalsBaseUnload = nil
end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerScripts = player.PlayerScripts
local controllers = playerScripts.Controllers
local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
local DataController = require(controllers:WaitForChild("PlayerDataController", 10))
local equipped, favorites = {}, {}
local constructingWeapon, viewingProfile = nil, nil
local lastUsedWeapon = nil

local function cloneCosmetic(name, cosmeticType, options)
    local base = CosmeticLibrary.Cosmetics[name]
    if not base then return nil end
    local data = {}
    for key, value in pairs(base) do data[key] = value end
    data.Name = name
    data.Type = data.Type or cosmeticType
    data.Seed = data.Seed or math.random(1, 1000000)
    if EnumLibrary then
        local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
        if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
    end
    if options then
        if options.inverted ~= nil then data.Inverted = options.inverted end
        if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
    end
    return data
end

local saveFile = "unlockall/config.json"
local function saveConfig()
    if not writefile then return end
    pcall(function()
        local config = {equipped = {}, favorites = favorites}
        for weapon, cosmetics in pairs(equipped) do
            config.equipped[weapon] = {}
            for cosmeticType, cosmeticData in pairs(cosmetics) do
                if cosmeticData and cosmeticData.Name then
                    config.equipped[weapon][cosmeticType] = {
                        name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                    }
                end
            end
        end
        makefolder("unlockall")
        writefile(saveFile, HttpService:JSONEncode(config))
    end)
end

local function loadConfig()
    if not readfile or not isfile or not isfile(saveFile) then return end
    pcall(function()
        local config = HttpService:JSONDecode(readfile(saveFile))
        if config.equipped then
            for weapon, cosmetics in pairs(config.equipped) do
                equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                    if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                end
            end
        end
        favorites = config.favorites or {}
    end)
end

CosmeticLibrary.OwnsCosmeticNormally = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

CosmeticLibrary.OwnsCosmeticUniversally = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

CosmeticLibrary.OwnsCosmeticForWeapon = function(self, inventory, name, weapon)
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return false
end

local originalOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return originalOwnsCosmetic(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and cosmetic.Type == "Skin" then return true end
    return originalOwnsCosmetic(self, inventory, name, weapon)
end

local originalGet = DataController.Get
DataController.Get = function(self, key)
    local data = originalGet(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and cosmetic.Type == "Skin" then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and cosmetic.Type == "Skin" then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do
                local cosmetic = CosmeticLibrary.Cosmetics[name]
                if cosmetic and cosmetic.Type == "Skin" then result[weapon][name] = isFav end
            end
        end
        return result
    end
    return data
end

local originalGetWeaponData = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponData(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
            if cosmeticType == "Skin" then merged[cosmeticType] = cosmeticData end
        end
    end
    return merged
end

local FighterController
pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
    local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
    local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
    local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")

    if equipRemote then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
            local args = {...}
            if useItemRemote and self == useItemRemote then
                local objectID = args[1]
                if FighterController then
                    pcall(function()
                        local fighter = FighterController:GetFighter(player)
                        if fighter and fighter.Items then
                            for _, item in pairs(fighter.Items) do
                                if item:Get("ObjectID") == objectID then lastUsedWeapon = item.Name break end
                            end
                        end
                    end)
                end
            end
            if self == equipRemote then
                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                if cosmeticType ~= "Skin" then return oldNamecall(self, ...) end
                if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                    local inventory = DataController:Get("CosmeticInventory")
                    if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                end
                equipped[weaponName] = equipped[weaponName] or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped[weaponName][cosmeticType] = nil
                    if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped[weaponName][cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                    task.wait(0.2)
                    saveConfig()
                end)
                return
            end
            if self == favoriteRemote then
                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                if cosmetic and cosmetic.Type == "Skin" then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    saveConfig()
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end

local ClientItem
pcall(function() ClientItem = require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModel = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == player) and weaponName or nil
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Skin and viewmodelRef then
            local dataKey, skinKey, nameKey = self:ToEnum("Data"), self:ToEnum("Skin"), self:ToEnum("Name")
            if viewmodelRef[dataKey] then
                viewmodelRef[dataKey][skinKey] = equipped[weaponName].Skin
                viewmodelRef[dataKey][nameKey] = equipped[weaponName].Skin.Name
            elseif viewmodelRef.Data then
                viewmodelRef.Data.Skin = equipped[weaponName].Skin
                viewmodelRef.Data.Name = equipped[weaponName].Skin.Name
            end
        end
        local result = originalCreateViewModel(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

local viewModelModule = player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    local originalNew = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == player and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local cosmetics = equipped[weaponName]
            if cosmetics.Skin then replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin end
        end
        local result = originalNew(replicatedData, clientItem)
        return result
    end
end

local originalGetViewModelImage = ItemLibrary.GetViewModelImageFromWeaponData
ItemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
    if not weaponData then return originalGetViewModelImage(self, weaponData, highRes) end
    local weaponName = weaponData.Name
    local shouldShowSkin = (weaponData.Skin and equipped[weaponName] and weaponData.Skin == equipped[weaponName].Skin) or (viewingProfile == player and equipped[weaponName] and equipped[weaponName].Skin)
    if shouldShowSkin and equipped[weaponName] and equipped[weaponName].Skin then
        local skinInfo = self.ViewModels[equipped[weaponName].Skin.Name]
        if skinInfo then return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image end
    end
    return originalGetViewModelImage(self, weaponData, highRes)
end

local originalOwnsCosmeticCharm = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return originalOwnsCosmeticCharm(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and (cosmetic.Type == "Charm" or name:lower():find("charm")) then return true end
    return originalOwnsCosmeticCharm(self, inventory, name, weapon)
end

local originalGetCharm = DataController.Get
DataController.Get = function(self, key)
    local data = originalGetCharm(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and (cosmetic.Type == "Charm" or k:lower():find("charm")) then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and (cosmetic.Type == "Charm" or k:lower():find("charm")) then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do
                local cosmetic = CosmeticLibrary.Cosmetics[name]
                if cosmetic and (cosmetic.Type == "Charm" or name:lower():find("charm")) then result[weapon][name] = isFav end
            end
        end
        return result
    end
    return data
end

local originalGetWeaponDataCharm = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponDataCharm(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
            if cosmeticType == "Charm" then merged[cosmeticType] = cosmeticData end
        end
    end
    return merged
end

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")

    if equipRemote then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
            local args = {...}
            if self == equipRemote then
                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                if cosmeticType ~= "Charm" then return oldNamecall(self, ...) end
                if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                    local inventory = DataController:Get("CosmeticInventory")
                    if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                end
                equipped[weaponName] = equipped[weaponName] or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped[weaponName][cosmeticType] = nil
                    if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped[weaponName][cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                    task.wait(0.2)
                    saveConfig()
                end)
                return
            end
            if self == favoriteRemote then
                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                if cosmetic and (cosmetic.Type == "Charm" or args[2]:lower():find("charm")) then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    saveConfig()
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end

if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModelCharm = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == player) and weaponName or nil
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Charm and viewmodelRef then
            local dataKey, charmKey, nameKey = self:ToEnum("Data"), self:ToEnum("Charm"), self:ToEnum("Name")
            if viewmodelRef[dataKey] then
                viewmodelRef[dataKey][charmKey] = equipped[weaponName].Charm
                viewmodelRef[dataKey][nameKey] = equipped[weaponName].Charm.Name
            elseif viewmodelRef.Data then
                viewmodelRef.Data.Charm = equipped[weaponName].Charm
                viewmodelRef.Data.Name = equipped[weaponName].Charm.Name
            end
        end
        local result = originalCreateViewModelCharm(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    if ClientViewModel.GetCharm then
        local originalGetCharmFunc = ClientViewModel.GetCharm
        ClientViewModel.GetCharm = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Charm then
                return equipped[weaponName].Charm
            end
            return originalGetCharmFunc(self)
        end
    end
    local originalNewCharm = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == player and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local cosmetics = equipped[weaponName]
            if cosmetics.Charm then replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm end
        end
        local result = originalNewCharm(replicatedData, clientItem)
        return result
    end
end

local originalOwnsCosmeticDance = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return originalOwnsCosmeticDance(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or name:lower():find("dance") or name:lower():find("emote")) then return true end
    return originalOwnsCosmeticDance(self, inventory, name, weapon)
end

local originalGetDance = DataController.Get
DataController.Get = function(self, key)
    local data = originalGetDance(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or k:lower():find("dance") or k:lower():find("emote")) then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or k:lower():find("dance") or k:lower():find("emote")) then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do
                local cosmetic = CosmeticLibrary.Cosmetics[name]
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or name:lower():find("dance") or name:lower():find("emote")) then result[weapon][name] = isFav end
            end
        end
        return result
    end
    return data
end

local originalGetWeaponDataDance = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponDataDance(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    return merged
end

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")

    if equipRemote then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
            local args = {...}
            if self == equipRemote then
                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                if cosmeticType == "Dance" or cosmeticType == "Emote" or (cosmeticName and (cosmeticName:lower():find("dance") or cosmeticName:lower():find("emote"))) then
                    equipped.Dances = equipped.Dances or {}
                    if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                        equipped.Dances[cosmeticType] = nil
                    else
                        local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                        if cloned then equipped.Dances[cosmeticType] = cloned end
                    end
                    task.defer(function()
                        pcall(function() DataController.CurrentData:Replicate("CosmeticInventory") end)
                        task.wait(0.2)
                        saveConfig()
                    end)
                    return
                end
                return oldNamecall(self, ...)
            end
            if self == favoriteRemote then
                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or args[2]:lower():find("dance") or args[2]:lower():find("emote")) then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    saveConfig()
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end

local EmoteController
pcall(function()
    EmoteController = require(controllers:WaitForChild("EmoteController", 10))
    if EmoteController and EmoteController.GetEmotes then
        local originalGetEmotes = EmoteController.GetEmotes
        EmoteController.GetEmotes = function(self)
            local emotes = originalGetEmotes(self)
            for name, cosmetic in pairs(CosmeticLibrary.Cosmetics) do
                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or name:lower():find("dance") or name:lower():find("emote")) then
                    if not emotes[name] then
                        emotes[name] = {
                            Name = name,
                            Type = cosmetic.Type,
                            ObjectID = cosmetic.ObjectID,
                            Enum = cosmetic.Enum
                        }
                    end
                end
            end
            return emotes
        end
    end
end)

local originalOwnsCosmeticWrap = CosmeticLibrary.OwnsCosmetic
CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
    if name:find("MISSING_") then return originalOwnsCosmeticWrap(self, inventory, name, weapon) end
    local cosmetic = CosmeticLibrary.Cosmetics[name]
    if cosmetic and (cosmetic.Type == "Wrap" or cosmetic.Type == "Wrapping" or name:lower():find("wrap")) then return true end
    return originalOwnsCosmeticWrap(self, inventory, name, weapon)
end

local originalGetWrapVer = DataController.Get
DataController.Get = function(self, key)
    local data = originalGetWrapVer(self, key)
    if key == "CosmeticInventory" then
        local proxy = {}
        if data then for k, v in pairs(data) do
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and (cosmetic.Type == "Wrap" or cosmetic.Type == "Wrapping" or k:lower():find("wrap")) then proxy[k] = v end
        end end
        return setmetatable(proxy, {__index = function(t, k)
            local cosmetic = CosmeticLibrary.Cosmetics[k]
            if cosmetic and (cosmetic.Type == "Wrap" or cosmetic.Type == "Wrapping" or k:lower():find("wrap")) then return true end
            return nil
        end})
    end
    if key == "FavoritedCosmetics" then
        local result = data and table.clone(data) or {}
        for weapon, favs in pairs(favorites) do
            result[weapon] = result[weapon] or {}
            for name, isFav in pairs(favs) do
                local cosmetic = CosmeticLibrary.Cosmetics[name]
                if cosmetic and (cosmetic.Type == "Wrap" or cosmetic.Type == "Wrapping" or name:lower():find("wrap")) then result[weapon][name] = isFav end
            end
        end
        return result
    end
    return data
end

local originalGetWeaponDataWrap = DataController.GetWeaponData
DataController.GetWeaponData = function(self, weaponName)
    local data = originalGetWeaponDataWrap(self, weaponName)
    if not data then return nil end
    local merged = {}
    for key, value in pairs(data) do merged[key] = value end
    merged.Name = weaponName
    if equipped[weaponName] then
        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
            if cosmeticType == "Wrap" or cosmeticType == "Wrapping" then merged[cosmeticType] = cosmeticData end
        end
    end
    return merged
end

if hookmetamethod then
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local dataRemotes = remotes and remotes:FindFirstChild("Data")
    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")

    if equipRemote then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
            local args = {...}
            if self == equipRemote then
                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                if cosmeticType ~= "Wrap" and cosmeticType ~= "Wrapping" then return oldNamecall(self, ...) end
                if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                    local inventory = DataController:Get("CosmeticInventory")
                    if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                end
                equipped[weaponName] = equipped[weaponName] or {}
                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                    equipped[weaponName][cosmeticType] = nil
                    if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                else
                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                    if cloned then equipped[weaponName][cosmeticType] = cloned end
                end
                task.defer(function()
                    pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                    task.wait(0.2)
                    saveConfig()
                end)
                return
            end
            if self == favoriteRemote then
                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                if cosmetic and (cosmetic.Type == "Wrap" or cosmetic.Type == "Wrapping" or args[2]:lower():find("wrap")) then
                    favorites[args[1]] = favorites[args[1]] or {}
                    favorites[args[1]][args[2]] = args[3] or nil
                    saveConfig()
                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end
end

if ClientItem and ClientItem._CreateViewModel then
    local originalCreateViewModelWrap = ClientItem._CreateViewModel
    ClientItem._CreateViewModel = function(self, viewmodelRef)
        local weaponName = self.Name
        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
        constructingWeapon = (weaponPlayer == player) and weaponName or nil
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap and viewmodelRef then
            local dataKey, wrapKey, nameKey = self:ToEnum("Data"), self:ToEnum("Wrap"), self:ToEnum("Name")
            if viewmodelRef[dataKey] then
                viewmodelRef[dataKey][wrapKey] = equipped[weaponName].Wrap
                viewmodelRef[dataKey][nameKey] = equipped[weaponName].Wrap.Name
            elseif viewmodelRef.Data then
                viewmodelRef.Data.Wrap = equipped[weaponName].Wrap
                viewmodelRef.Data.Name = equipped[weaponName].Wrap.Name
            end
        end
        local result = originalCreateViewModelWrap(self, viewmodelRef)
        constructingWeapon = nil
        return result
    end
end

if viewModelModule then
    local ClientViewModel = require(viewModelModule)
    if ClientViewModel.GetWrap then
        local originalGetWrapFunc = ClientViewModel.GetWrap
        ClientViewModel.GetWrap = function(self)
            local weaponName = self.ClientItem and self.ClientItem.Name
            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap then
                return equipped[weaponName].Wrap
            end
            return originalGetWrapFunc(self)
        end
    end
    local originalNewWrap = ClientViewModel.new
    ClientViewModel.new = function(replicatedData, clientItem)
        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
        local weaponName = constructingWeapon or clientItem.Name
        if weaponPlayer == player and equipped[weaponName] then
            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
            local dataKey = ReplicatedClass:ToEnum("Data")
            replicatedData[dataKey] = replicatedData[dataKey] or {}
            local cosmetics = equipped[weaponName]
            if cosmetics.Wrap then replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap end
        end
        local result = originalNewWrap(replicatedData, clientItem)
        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap and result._UpdateWrap then
            result:_UpdateWrap()
            task.delay(0.1, function() if not result._destroyed then result:_UpdateWrap() end end)
        end
        return result
    end
end

pcall(function()
    local ViewProfile = require(player.PlayerScripts.Modules.Pages.ViewProfile)
    if ViewProfile and ViewProfile.Fetch then
        local originalFetch = ViewProfile.Fetch
        ViewProfile.Fetch = function(self, targetPlayer)
            viewingProfile = targetPlayer
            return originalFetch(self, targetPlayer)
        end
    end
end)

loadConfig()

end)

run("aim", function()
local services = setmetatable({}, {
    __index = function(_, v)
        local success, result = pcall(function()
            return game:GetService(v)
        end)

        if result then
            return cloneref(result)
        end

        return nil
    end
})

local env = getgenv()

local cfg = env.RivalsCfg or {}
local function on(key)
    return cfg[key] ~= false
end

if env.RivalsAimUnload then
    pcall(env.RivalsAimUnload)
end

if env.DesyncController then
    env.DesyncController:Stop()
end

if env.TargetController then
    env.TargetController:Stop()
end

if env.WallbangController then
    env.WallbangController:Stop()
end

local Players = services.Players
local RunService = services.RunService
local ReplicatedStorage = services.ReplicatedStorage
local Workspace = services.Workspace
local UserInputService = services.UserInputService

local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer.PlayerScripts
local lastCamera = Workspace.CurrentCamera
local function currentCamera()
    lastCamera = Workspace.CurrentCamera or lastCamera
    return lastCamera
end
local Character = setmetatable({}, {
    __index = function(_, v)
        local character = LocalPlayer.Character
        if not character then
            return nil
        end

        if v == 'Ref' then
            return character
        elseif v == 'RootPart' then
            return character:FindFirstChild('HumanoidRootPart')
        elseif v == 'Head' then
            return character:FindFirstChild('Head')
        end

        return nil
    end
})

local Check = { items = {}, ok = true }
env.RivalsCheck = Check

local Events = { list = {}, start = os.clock(), id = os.time(), limit = 20000 }
env.RivalsEvents = Events
local function event(kind, text)
    if #Events.list >= Events.limit then return end
    table.insert(Events.list, { t = os.clock(), kind = kind, text = text })
end
env.RivalsEvent = event

local function note(name, ok, detail)
    table.insert(Check.items, { name = name, ok = ok and true or false, detail = detail })
    if not ok then
        Check.ok = false
    end
end

local function loadModule(name, getter)
    local ok, result = pcall(function()
        return require(getter())
    end)
    if not ok or result == nil then
        note(name, false, ok and 'nil' or tostring(result))
        return nil
    end
    note(name, true)
    return result
end

local clientItemModule = loadModule('ClientItem 모듈', function()
    return LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem
end)
local GunItem = loadModule('Gun 모듈', function()
    return PlayerScripts.Modules.ItemTypes.Gun
end)
local Utility = loadModule('Utility 모듈', function()
    return ReplicatedStorage.Modules.Utility
end)

note('ClientItem.Input 함수', clientItemModule ~= nil and type(clientItemModule.Input) == 'function')
note('Gun.StartShooting 함수', GunItem ~= nil and type(GunItem.StartShooting) == 'function')
note('Utility.EncodeCFrame 함수', Utility ~= nil and type(Utility.EncodeCFrame) == 'function')

do
    local ok, attributes = pcall(function()
        return LocalPlayer:GetAttributes()
    end)
    local parts = {}
    if ok and type(attributes) == 'table' then
        for key, value in pairs(attributes) do
            table.insert(parts, tostring(key) .. '=' .. tostring(value))
        end
        table.sort(parts)
    end
    note('내 속성', true, #parts > 0 and table.concat(parts, ', ') or '(없음)')
end

local originalInput = clientItemModule and clientItemModule.Input
if type(originalInput) ~= 'function' then
    originalInput = nil
end

local savedInfo = setmetatable({}, {__mode = "k"})

local function setInfo(info, key, enabled, value)
    local saved = savedInfo[info]
    if not saved then
        saved = {}
        savedInfo[info] = saved
    end
    if saved[key] == nil then
        saved[key] = info[key] or false
    end
    if enabled then
        info[key] = value
    else
        info[key] = saved[key] or nil
    end
end

local inputWrapper = nil
if originalInput then
    inputWrapper = function(self, ...)
        if self and type(self) == "table" and self.Info then
            local info = self.Info
            pcall(function()
                setInfo(info, "ShootRecoil", on("noRecoil"), 0)
                setInfo(info, "ShootSpread", on("noSpread"), 0)
                setInfo(info, "ProjectileSpeed", on("rage") or on("silent"), 99999999)
                setInfo(info, "ShootCooldown", on("rapidFire"), 0)
                setInfo(info, "QuickShotCooldown", on("rapidFire"), 0)
            end)
        end

        return originalInput(self, ...)
    end
    clientItemModule.Input = inputWrapper
end

if env.RivalsSafety then
    for _, connection in ipairs(env.RivalsSafety.connections) do
        connection:Disconnect()
    end
end
pcall(function()
    RunService:UnbindFromRenderStep('RivalsSafetyTrack')
end)

env.RivalsSafety = {
    clock = os.clock,
    connections = {},
    lastDesync = -math.huge,
    lastSpin = -math.huge,
    lastJitter = -math.huge,
    lastMelee = -math.huge,
    rangeScale = env.RivalsSafety and env.RivalsSafety.rangeScale or 1,
    jitterScale = env.RivalsSafety and env.RivalsSafety.jitterScale or 1,
    jitterPulls = 0,
    jitterFlings = 0,
    desyncDeaths = 0,
    jitterDeaths = 0,
    spinDeaths = 0,
    flings = 0,
    rescues = 0,
    zoneRefusals = 0,
    deathLog = {},
    lastRecover = env.RivalsSafety and env.RivalsSafety.lastRecover or 0,
    history = {},
}
do
    local Safety = env.RivalsSafety
    local DEATH_WINDOW = 2
    local MAX_SPEED = 250
    local FALL_MARGIN = 40

    local RECOVER_EVERY = 60
    local HISTORY_SECONDS = 2
    local SUDDEN_WINDOW = 0.3
    local SUDDEN_RATIO = 0.85
    local DEATH_PENALTY = 6

    local function onDeath()
        local now = Safety.clock()

        local sudden = true
        for i = #Safety.history, 1, -1 do
            local sample = Safety.history[i]
            if now - sample.t >= SUDDEN_WINDOW then
                sudden = sample.h >= SUDDEN_RATIO * sample.max
                break
            end
        end
        Safety.history = {}

        local tuner = env.RivalsTuner
        table.insert(Safety.deathLog, {
            sudden = sudden,
            desync = now - Safety.lastDesync,
            spin = now - Safety.lastSpin,
            range = Safety.rangeScale,
            arm = tuner and tuner.desyncArm or nil,
            melee = now - Safety.lastMelee,
        })
        if #Safety.deathLog > 10 then
            table.remove(Safety.deathLog, 1)
        end
        event('죽음', string.format('%s, 디싱크 %.1fs 전, 회전 %.1fs 전, 방식 %s, 근접 위협 %.1fs 전', sudden and '급사' or '맞아서 사망', math.min(99, now - Safety.lastDesync), math.min(99, now - Safety.lastSpin), tostring(tuner and tuner.desyncArm or '-'), math.min(99, now - Safety.lastMelee)))
        if now - Safety.lastDesync < DEATH_WINDOW and tuner and tuner.desyncArm then
            tuner:Penalize('desync', tuner.desyncArm, DEATH_PENALTY)
        end
        if not sudden then return end
        Safety.lastRecover = now
        if now - Safety.lastDesync < DEATH_WINDOW then
            Safety.desyncDeaths += 1
            local again = now - (Safety.lastDesyncDeath or -math.huge) < 180
            Safety.lastDesyncDeath = now
            Safety.rangeScale = math.max(0.25, Safety.rangeScale * (again and 0.5 or 0.75))
        end
        if cfg.antiAimJitter and now - Safety.lastJitter < DEATH_WINDOW then
            Safety.jitterDeaths += 1
            Safety.jitterScale = math.max(0.25, Safety.jitterScale * 0.5)
            if now - (Safety.lastJitterDeath or -math.huge) < 180 then
                cfg.antiAimJitter = false
            else
            end
            Safety.lastJitterDeath = now
        elseif cfg.antiAimSpin and now - Safety.lastSpin < DEATH_WINDOW then
            Safety.spinDeaths += 1
            if Safety.spinDeaths >= 2 then
                cfg.antiAimSpin = false
            end
        end
    end

    local function watch(character)
        local humanoid = character:WaitForChild('Humanoid', 5)
        if humanoid then
            table.insert(Safety.connections, humanoid.Died:Connect(onDeath))
        end
    end

    table.insert(Safety.connections, LocalPlayer.CharacterAdded:Connect(function(character)
        task.spawn(watch, character)
    end))
    if LocalPlayer.Character then
        task.spawn(watch, LocalPlayer.Character)
    end

    local lastSafe = nil
    local function track()
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild('HumanoidRootPart')
        local humanoid = character and character:FindFirstChildWhichIsA('Humanoid')
        if not root or not humanoid or humanoid.Health <= 0 then
            lastSafe = nil
            return
        end

        local now = Safety.clock()
        table.insert(Safety.history, { t = now, h = humanoid.Health, max = humanoid.MaxHealth })
        while #Safety.history > 0 and now - Safety.history[1].t > HISTORY_SECONDS do
            table.remove(Safety.history, 1)
        end

        if (Safety.rangeScale < 1 or Safety.jitterScale < 1) and now - Safety.lastRecover >= RECOVER_EVERY then
            Safety.lastRecover = now
            Safety.rangeScale = math.min(1, Safety.rangeScale * 1.25)
            Safety.jitterScale = math.min(1, Safety.jitterScale * 1.25)
        end

        if root.AssemblyLinearVelocity.Magnitude > MAX_SPEED then
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            Safety.flings += 1
        end

        if root.Position.Y < Workspace.FallenPartsDestroyHeight + FALL_MARGIN then
            if lastSafe then
                root.CFrame = lastSafe
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                Safety.rescues += 1
            end
        elseif humanoid.FloorMaterial ~= Enum.Material.Air then
            lastSafe = root.CFrame
            local bounds = env.RivalsBounds
            if bounds then bounds:MarkMine(root) end
        end
    end

    RunService:BindToRenderStep('RivalsSafetyTrack', 120, track)
end

local oldBounds = env.RivalsBounds
if oldBounds and oldBounds.connection then
    oldBounds.connection:Disconnect()
end
env.RivalsBounds = {
    cells = oldBounds and oldBounds.cells or {},
    connection = nil,
    lastMine = nil,
    lastMark = -math.huge,
}
do
    local Bounds = env.RivalsBounds
    local CELL = 12
    local KEEP = 120
    local BELOW = 4
    local ABOVE = 24
    local MINE_EVERY = 0.25
    local OTHERS_EVERY = 0.5
    local PRUNE_EVERY = 10
    local TELEPORT = 150
    local STAND_RAY = 6

    local function cellKey(cx, cz)
        return (cx + 4096) * 8192 + (cz + 4096)
    end

    function Bounds:Mark(position)
        local cx = math.floor(position.X / CELL)
        local cz = math.floor(position.Z / CELL)
        self.cells[cellKey(cx, cz)] = { y = position.Y, t = os.clock() }
    end

    function Bounds:Allows(position)
        local cx = math.floor(position.X / CELL)
        local cz = math.floor(position.Z / CELL)
        local now = os.clock()
        for dx = -1, 1 do
            for dz = -1, 1 do
                local cell = self.cells[cellKey(cx + dx, cz + dz)]
                if cell and now - cell.t <= KEEP and position.Y >= cell.y - BELOW and position.Y <= cell.y + ABOVE then
                    return true
                end
            end
        end
        return false
    end

    function Bounds:MarkMine(root)
        local now = os.clock()
        if now - self.lastMark < MINE_EVERY then return end
        self.lastMark = now
        local position = root.Position
        if self.lastMine and (position - self.lastMine).Magnitude > TELEPORT then
            self.cells = {}
        end
        self.lastMine = position
        self:Mark(position)
    end

    function Bounds:Prune()
        local now = os.clock()
        for key, cell in pairs(self.cells) do
            if now - cell.t > KEEP then
                self.cells[key] = nil
            end
        end
    end

    function Bounds:Count()
        local count = 0
        for _ in pairs(self.cells) do
            count += 1
        end
        return count
    end

    local standParams = RaycastParams.new()
    standParams.FilterType = Enum.RaycastFilterType.Exclude
    standParams.IgnoreWater = true

    local clock, pruneClock = 0, 0
    Bounds.connection = RunService.Heartbeat:Connect(function(dt)
        clock += dt or 0
        if clock < OTHERS_EVERY then return end
        pruneClock += clock
        clock = 0
        for _, other in next, Players:GetPlayers() do
            if other ~= LocalPlayer then
                local character = other.Character
                local root = character and character:FindFirstChild('HumanoidRootPart')
                local humanoid = character and character:FindFirstChildWhichIsA('Humanoid')
                if root and humanoid and humanoid.Health > 0 then
                    standParams.FilterDescendantsInstances = { character }
                    if Workspace:Raycast(root.Position, Vector3.new(0, -STAND_RAY, 0), standParams) then
                        Bounds:Mark(root.Position)
                    end
                end
            end
        end
        if pruneClock >= PRUNE_EVERY then
            pruneClock = 0
            Bounds:Prune()
        end
    end)
end

local MAX_TARGET_DISTANCE = 150
local GROUND_CHECK = 80
local CLEARANCE = 2.5

local HEAD_POINTS = {
    Vector3.new(0, 0.4, 0), Vector3.new(0.4, 0, 0), Vector3.new(-0.4, 0, 0), Vector3.new(0, 0, 0.4), Vector3.new(0, 0, -0.4), Vector3.new(0, -0.3, 0),
}

local function headPoints(head)
    local center = head.Position
    local points = { center }
    local size, cframe = head.Size, head.CFrame
    if not size or not cframe then return points end
    for _, factor in ipairs(HEAD_POINTS) do
        table.insert(points, center + cframe:VectorToWorldSpace(factor * size))
    end
    return points
end

env.DesyncController = {}
do
    local groundParams = RaycastParams.new()
    groundParams.FilterType = Enum.RaycastFilterType.Exclude
    groundParams.IgnoreWater = true
    groundParams.RespectCanCollide = true
    local clearanceParams = OverlapParams.new()
    clearanceParams.FilterType = Enum.RaycastFilterType.Exclude
    local sightParams = RaycastParams.new()
    sightParams.FilterType = Enum.RaycastFilterType.Exclude
    sightParams.IgnoreWater = true
    sightParams.RespectCanCollide = true

    local function ownFilter(extra)
        local filter = {}
        if LocalPlayer.Character then
            table.insert(filter, LocalPlayer.Character)
        end
        local camera = currentCamera()
        if camera then
            table.insert(filter, camera)
        end
        if extra then
            table.insert(filter, extra)
        end
        return filter
    end

    local surfaceParams = RaycastParams.new()
    surfaceParams.FilterType = Enum.RaycastFilterType.Include
    surfaceParams.IgnoreWater = true
    local PROBES = {
        Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0), Vector3.new(0, 1, 0), Vector3.new(0, -1, 0), Vector3.new(0, 0, 1), Vector3.new(0, 0, -1),
    }
    for x = -1, 1, 2 do
        for y = -1, 1, 2 do
            for z = -1, 1, 2 do
                table.insert(PROBES, Vector3.new(x, y, z).Unit)
            end
        end
    end

    local function touchesSurface(position, parts, from)
        surfaceParams.FilterDescendantsInstances = parts
        if Workspace:Raycast(from, position - from, surfaceParams) then return true end
        for _, direction in ipairs(PROBES) do
            if Workspace:Raycast(position, direction * CLEARANCE, surfaceParams) then return true end
        end
        return false
    end

    local function isZone(part)
        if part.Name == 'Barriers' or (part.Parent and part.Parent.Name == 'Barriers') then return true end
        return part:HasTag('OutOfBoundsPart') or part:HasTag('KillBrick')
    end

    function DesyncController:Sight(from, to, head)
        sightParams.FilterDescendantsInstances = ownFilter()
        local result = Workspace:Raycast(from, to - from, sightParams)
        return result == nil or result.Instance == head
    end

    function DesyncController:HasLine(position, head)
        if not head then return true end
        return self:Sight(position + Vector3.new(0, 1.5, 0), head.Position, head)
    end

    function DesyncController:Free(position, extra)
        clearanceParams.FilterDescendantsInstances = ownFilter(extra)
        local ok, parts = pcall(function()
            return Workspace:GetPartBoundsInRadius(position, CLEARANCE, clearanceParams)
        end)
        if ok and parts then
            for _, part in ipairs(parts) do
                if part.CanCollide then return false end
            end
        end
        return true
    end

    local function anchorFor(list, targetRoot, head)
        if list and list.anchor == 'head' then
            local character = targetRoot.Parent
            local box = character and character:FindFirstChild('HitboxHead')
            local part = (box and box:IsA('BasePart')) and box or head
            return part and CFrame.new(part.Position) or nil
        end
        return targetRoot.CFrame
    end

    function DesyncController:Pick(targetRoot, head, rootPart)
        local now = os.clock()
        local cached = self.pick
        if cached and (cached.line or now - cached.at < 0.25) then
            local base = anchorFor(cached.list, targetRoot, head)
            local candidate = base and base * cached.offset
            if candidate then
                local safe, exact = self:IsSafe(candidate.Position, rootPart)
                if safe and (not cached.line or self:HasLine(candidate.Position, head)) then
                    self.pickExact = exact == true
                    return candidate, cached.offset
                end
            end
        end
        local firstSafe, firstOffset, firstList, firstExact = nil, nil, nil, false
        for _, list in ipairs({ self.offsets or { self.offset or CFrame.new(0, 7, -2) }, self.fallback or {} }) do
            local base = anchorFor(list, targetRoot, head)
            if base then
                for _, offset in ipairs(list) do
                    local candidate = base * offset
                    local safe, exact = self:IsSafe(candidate.Position, rootPart)
                    if safe then
                        if self:HasLine(candidate.Position, head) then
                            self.pick = { offset = offset, list = list, line = head ~= nil, at = now }
                            self.pickExact = exact == true
                            return candidate, offset
                        end
                        if not firstSafe then
                            firstSafe, firstOffset, firstList, firstExact = candidate, offset, list, exact == true
                        end
                    end
                end
            end
        end
        if firstSafe then
            self.pick = { offset = firstOffset, list = firstList, line = false, at = now }
            self.pickExact = firstExact
            return firstSafe, firstOffset
        end
        self.pick = nil
        self.pickExact = false
        return nil
    end

    function DesyncController:init()
        self.active = false
        self.connection = nil
        self.currentTarget = nil
    end

    function DesyncController:IsSafe(position, rootPart)
        local limit = MAX_TARGET_DISTANCE * env.RivalsSafety.rangeScale + 20
        if not ((position - rootPart.Position).Magnitude <= limit) then return false end
        if not (position.Y >= Workspace.FallenPartsDestroyHeight + 50) then return false end

        local filter = {}
        local camera = currentCamera()
        if camera then
            table.insert(filter, camera)
        end
        if LocalPlayer.Character then
            table.insert(filter, LocalPlayer.Character)
        end
        local target = self.currentTarget
        if target and target.Character then
            table.insert(filter, target.Character)
        end
        groundParams.FilterDescendantsInstances = filter
        clearanceParams.FilterDescendantsInstances = filter

        local ok, parts = pcall(function()
            return Workspace:GetPartBoundsInRadius(position, CLEARANCE, clearanceParams)
        end)
        local solid = {}
        if ok and parts then
            for _, part in ipairs(parts) do
                if isZone(part) then
                    self.zoned = true
                    return false
                end
                if part.CanCollide then table.insert(solid, part) end
            end
        end
        local exact = false
        if #solid > 0 then
            local character = target and target.Character
            local anchor = character and (character:FindFirstChild('Head') or character:FindFirstChild('HumanoidRootPart'))
            if not anchor or touchesSurface(position, solid, anchor.Position) then return false end
            exact = true
        end

        local ground = Workspace:Raycast(position, Vector3.new(0, -GROUND_CHECK, 0), groundParams)
        if ground == nil then return false end
        if isZone(ground.Instance) then
            self.zoned = true
            return false
        end
        return true, exact
    end

    local function faceToward(position, point)
        local flat = Vector3.new(point.X, position.Y, point.Z)
        if (flat - position).Magnitude < 0.05 then
            return CFrame.new(position)
        end
        return CFrame.lookAt(position, flat)
    end

    function DesyncController:Start(target)
        self:Stop()
        event('디싱크', target and target.Name or '?')

        self.active = true
        self.pick = nil
        self.startTarget = target
        self.startedAt = os.clock()
        self.expireAt = self.startedAt + 0.6

        self.connection = RunService.Heartbeat:Connect(function()
            if not self.active then return end

            if self.pendingRestore then self.pendingRestore() end

            if os.clock() > (self.expireAt or math.huge) then
                self:Stop()
                return
            end

            local rootPart = Character.RootPart
            if not rootPart then return end

            local targetRoot = target and target.Character and target.Character:FindFirstChild('HumanoidRootPart')
            if not targetRoot then
                self:Stop()
                return
            end

            self.currentTarget = target

            local head = target.Character:FindFirstChild('Head')
            self.zoned = false
            local desyncCFrame, offset = self:Pick(targetRoot, head, rootPart)
            if self.zoned then
                env.RivalsSafety.zoneRefusals += 1
            end
            if desyncCFrame then
                self.offset = offset
            end
            if not desyncCFrame then
                self.placed = nil
                return
            end
            desyncCFrame = faceToward(desyncCFrame.Position, (head or targetRoot).Position)
            self.placed = desyncCFrame
            self.placedExact = self.pickExact == true

            local backupCFrame = rootPart.CFrame
            local backupVelocity = rootPart.Velocity
            local backupRotVelocity = rootPart.RotVelocity

            rootPart.CFrame = desyncCFrame
            env.RivalsSafety.lastDesync = env.RivalsSafety.clock()

            local function restore()
                self.pendingRestore = nil
                rootPart.CFrame = backupCFrame
                rootPart.Velocity = backupVelocity
                rootPart.RotVelocity = backupRotVelocity
                pcall(function()
                    RunService:UnbindFromRenderStep('desync_fallback')
                end)
            end

            if pcall(function() RunService:BindToRenderStep('desync_fallback', Enum.RenderPriority.First.Value, restore) end) then
                self.pendingRestore = restore
            else
                restore()
            end
        end)
    end

    function DesyncController:Stop()
        self.active = false
        self.currentTarget = nil
        self.startTarget = nil
        self.placed = nil
        self.pick = nil
        if self.pendingRestore then self.pendingRestore() end
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
    end

    DesyncController:init()
end

env.RivalsTargetState = {
    flagged = setmetatable({}, { __mode = 'k' }),
    cache = setmetatable({}, { __mode = 'k' }),
    disprovals = 0,
    probes = 0, probeHits = 0,
    blocked = 0, flankShots = 0, flankHits = 0, controlShots = 0, controlHits = 0,
}
do
    local TargetState = env.RivalsTargetState
    local FRONT_BLOCK_DOT = -0.3778
    local BACK_BLOCK_DOT = 0.70355
    local DEFLECT_BLOCK_DOT = -0.7136558449999999
    local SHIELD_IMMUNE = { ['Flare Gun'] = true, ['Grenade Launcher'] = true, RPG = true, Exogun = true, Distortion = true, Flamethrower = true, Spray = true }
    local DEFLECT_IMMUNE = { ['Flare Gun'] = true, ['Grenade Launcher'] = true, RPG = true, Exogun = true, Distortion = true, Flamethrower = true, Spray = true, Daggers = true, Bow = true, Crossbow = true, Slingshot = true }
    local CACHE_FOR = 0.05
    local PROBE_EVERY = 3
    local PROBE_FOR = 0.15
    local DISPROVE_AT = 2
    local CONTROL_MIN = 25
    local CONTROL_MAX_RATE = 0.12
    TargetState.BLOCK_CONTROL = 0.15

    local fighterController
    pcall(function()
        local module = PlayerScripts.Controllers:FindFirstChild('FighterController')
        if module then fighterController = require(module) end
    end)
    note('FighterController 모듈', fighterController ~= nil)

    local function fighterOf(player)
        if fighterController == nil then return nil end
        local fighter
        pcall(function() fighter = fighterController:GetFighter(player) end)
        if type(fighter) ~= 'table' then
            local map = type(fighterController) == 'table' and rawget(fighterController, '_player_to_fighter') or nil
            fighter = type(map) == 'table' and map[player] or nil
        end
        return type(fighter) == 'table' and fighter or nil
    end

    local function field(object, key)
        local value = rawget(object, key)
        if value == nil then
            pcall(function() value = object[key] end)
        end
        return value
    end

    local function isVector2(value)
        local ok, x, y = pcall(function() return value.X, value.Y end)
        return ok and type(x) == 'number' and type(y) == 'number'
    end

    local function lookVector(rotation)
        local pitch, yaw = rotation.X, rotation.Y
        local flat = math.cos(pitch)
        return Vector3.new(-math.sin(yaw) * flat, math.sin(pitch), -math.cos(yaw) * flat)
    end

    local function gameClock()
        if type(tick) == 'function' then return tick() end
        return os.time()
    end

    local function readState(player)
        local fighter = fighterOf(player)
        if not fighter then return nil end
        local state = { invincible = false, crouching = false }
        local entity = field(fighter, 'Entity')
        local entityData = type(entity) == 'table' and field(entity, 'Data') or nil
        state.invincible = type(entityData) == 'table' and field(entityData, 'IsInvincible') == true

        local data = field(fighter, 'Data')
        if type(data) == 'table' then
            state.crouching = field(data, 'IsCrouching') == true
            local rotation = field(data, 'CameraRotation')
            if rotation ~= nil and isVector2(rotation) then
                state.look = lookVector(rotation)
            end
        end

        local equipped = field(fighter, 'EquippedItem')
        local riotEquipped = false
        if type(equipped) == 'table' then
            local info = field(equipped, 'Info')
            if type(info) == 'table' and info.Type == 'Melee' then
                local now = gameClock()
                state.melee = true
                riotEquipped = field(equipped, 'Name') == 'Riot Shield'
                local deflectEnd = field(equipped, '_deflect_cooldown')
                local deflectCooldown = info.DeflectCooldown
                state.deflecting = type(deflectEnd) == 'number' and type(deflectCooldown) == 'number' and now < deflectEnd - deflectCooldown
                local attackEnd = field(equipped, '_attack_cooldown')
                local attacking = type(attackEnd) == 'number' and now < attackEnd
                state.riotFront = riotEquipped and not attacking
            end
        end
        if not riotEquipped then
            local items = field(fighter, 'Items')
            if type(items) == 'table' then
                for _, item in pairs(items) do
                    if type(item) == 'table' and field(item, 'Name') == 'Riot Shield' then
                        state.riotBack = true
                        break
                    end
                end
            end
        end
        return state
    end

    function TargetState:Read(player)
        local now = os.clock()
        local cached = self.cache[player]
        if cached and now - cached.at < CACHE_FOR then
            return cached.state
        end
        local ok, state = pcall(readState, player)
        if not ok then state = nil end
        self.cache[player] = { at = now, state = state }
        return state
    end

    function TargetState:IsInvincible(player)
        local state = self:Read(player)
        return state ~= nil and state.invincible == true
    end

    function TargetState:HoldsMelee(player)
        local state = self:Read(player)
        return state ~= nil and state.melee == true
    end

    function TargetState:Unshootable(player)
        if self.disproved or not self:IsInvincible(player) then
            self.flagged[player] = nil
            return false
        end
        local now = os.clock()
        local since = self.flagged[player]
        if not since then
            since = now
            self.flagged[player] = since
        end
        local elapsed = now - since
        return not (elapsed >= PROBE_EVERY and elapsed % PROBE_EVERY < PROBE_FOR)
    end

    function TargetState:Disprove()
        self.disprovals += 1
        if self.disprovals >= DISPROVE_AT and not self.disproved then
            self.disproved = true
        end
    end

    function TargetState:Blocked(player, origin, weaponName)
        if self.blockOff then return nil end
        local state = self:Read(player)
        if not state or not state.look then return nil end
        local character = player.Character
        local root = character and character:FindFirstChild('HumanoidRootPart')
        if not root then return nil end
        local center = root.Position + Vector3.new(0, state.crouching and 0.25 or 1.75, 0)
        local offset = center - origin
        local distance = offset.Magnitude
        local dot = distance > 1e-4 and offset:Dot(state.look) / distance or 0
        if state.deflecting and not DEFLECT_IMMUNE[weaponName] and dot < DEFLECT_BLOCK_DOT then return 'deflect' end
        if state.riotFront and not SHIELD_IMMUNE[weaponName] and dot < FRONT_BLOCK_DOT then return 'front' end
        if state.riotBack and not SHIELD_IMMUNE[weaponName] and dot > BACK_BLOCK_DOT then return 'back' end
        return nil
    end

    function TargetState:Settle(info, hit)
        if info.invincible then
            self.probes += 1
            if hit then
                self.probeHits += 1
                self:Disprove()
            end
        end
        if info.flank then
            self.flankShots += 1
            if hit then self.flankHits += 1 end
        end
        if info.control then
            self.controlShots += 1
            if hit then self.controlHits += 1 end
            if not self.blockOff and self.controlShots >= CONTROL_MIN and self.controlHits / self.controlShots > CONTROL_MAX_RATE then
                self.blockOff = true
            end
        end
    end

    function TargetState:Summary()
        if self.probes == 0 and self.blocked == 0 and self.disprovals == 0 then return nil end
        return string.format('판독: 무적 시험 샷 %d발(맞음 %d)%s  막힘 예상 %d (우회 %d발 맞음 %d, 대조 %d발 맞음 %d)%s',
            self.probes, self.probeHits, self.disproved and ' [무적 판독 끔]' or '',
            self.blocked, self.flankShots, self.flankHits, self.controlShots, self.controlHits, self.blockOff and ' [방패 판독 끔]' or '')
    end
end

env.TargetController = {}
do
    function TargetController:init()
        self.active = true
        self.target = nil

        self.connection = RunService.Heartbeat:Connect(function()
            if not self.active then return end
            local before = self.target
            self.target = self:GetClosestTarget()
            if self.target ~= before then
                event('대상', self.target and string.format('%s (%s)%s', self.target.Name, self.targetVisible and '보임' or (self.targetInRange and '벽 뒤' or '먼 벽 뒤'), self.meleeFirst and ', 근접 무기라 먼저' or '') or '없음')
            end
        end)
    end

    function TargetController:IsValidTarget(character)
        local rootPart = character:FindFirstChild('HumanoidRootPart')
        local head = character:FindFirstChild('Head')
        local humanoid = character:FindFirstChildWhichIsA('Humanoid')
        return rootPart and head and humanoid and humanoid.Health > 0 or false
    end

    function TargetController:IsValidTeam(player)
        return player:GetAttribute('TeamID') ~= LocalPlayer:GetAttribute('TeamID')
    end

    function TargetController:IsValidMatch(player)
        return player:GetAttribute('EnvironmentID') == LocalPlayer:GetAttribute('EnvironmentID')
    end

    function TargetController:IsValidCandidate(player, ignoreRange)
        if player == LocalPlayer then return false end
        if not self:IsValidTeam(player) then return false end
        if not self:IsValidMatch(player) then return false end

        local character = player.Character
        if not character then return false end
        if not self:IsValidTarget(character) then return false end
        if character:FindFirstChildWhichIsA('ForceField') then return false end

        local camera = currentCamera()
        if not camera then return false end
        if ignoreRange then return true end
        local head = character:FindFirstChild('Head')
        if (head.Position - camera.CFrame.Position).Magnitude > MAX_TARGET_DISTANCE * env.RivalsSafety.rangeScale then
            return false
        end
        return true
    end

    function TargetController:VisibleEnemy()
        local camera = currentCamera()
        if not camera then return nil end
        local cameraPosition = camera.CFrame.Position
        local best, bestPoint, bestDistance = nil, nil, math.huge
        for _, player in next, Players:GetPlayers() do
            if self:IsShootable(player, true) then
                local visible, _, distance, point = self:Judge(player, cameraPosition)
                if visible and distance < bestDistance then
                    best, bestPoint, bestDistance = player, point, distance
                end
            end
        end
        return best, bestPoint, bestDistance
    end

    local viewParams = RaycastParams.new()
    viewParams.FilterType = Enum.RaycastFilterType.Exclude
    viewParams.IgnoreWater = true
    viewParams.RespectCanCollide = true

    local BODY_PARTS = { 'HitboxBody', 'UpperTorso', 'Torso', 'HumanoidRootPart' }
    local BODY_PARTS_SMALL = { 'HitboxBodySmall', 'HitboxBody', 'UpperTorso', 'Torso', 'HumanoidRootPart' }

    function TargetController:VisibleBody(player, cameraPosition, weaponName)
        local character = player.Character
        if not character then return nil end
        local part = nil
        for _, name in ipairs(weaponName == 'Sniper' and BODY_PARTS_SMALL or BODY_PARTS) do
            local candidate = character:FindFirstChild(name)
            if candidate and candidate:IsA('BasePart') then
                part = candidate
                break
            end
        end
        if not part then return nil end
        local filter = { character }
        if LocalPlayer.Character then
            table.insert(filter, LocalPlayer.Character)
        end
        local camera = currentCamera()
        if camera then
            table.insert(filter, camera)
        end
        viewParams.FilterDescendantsInstances = filter
        for _, point in ipairs(headPoints(part)) do
            if Workspace:Raycast(cameraPosition, point - cameraPosition, viewParams) == nil then
                return part, point
            end
        end
        return nil
    end

    function TargetController:VisibleBodyEnemy(weaponName)
        local camera = currentCamera()
        if not camera then return nil end
        local cameraPosition = camera.CFrame.Position
        local best, bestPart, bestPoint, bestDistance = nil, nil, nil, math.huge
        for _, player in next, Players:GetPlayers() do
            if self:IsShootable(player, false) then
                local part, point = self:VisibleBody(player, cameraPosition, weaponName)
                if part then
                    local distance = (point - cameraPosition).Magnitude
                    if distance < bestDistance then
                        best, bestPart, bestPoint, bestDistance = player, part, point, distance
                    end
                end
            end
        end
        return best, bestPart, bestPoint
    end

    function TargetController:IsShootable(player, ignoreRange)
        if not self:IsValidCandidate(player, ignoreRange) then return false end
        return not env.RivalsTargetState:Unshootable(player)
    end

    local LOCK_STALE = 2
    local LOCK_CLOSER = 0.5
    local HIDDEN_SWITCH = 0.3
    local MELEE_FIRST = 18

    function TargetController:VisiblePoint(player, cameraPosition)
        local character = player.Character
        local head = character and character:FindFirstChild('Head')
        if not head then return nil end
        local filter = { character }
        if LocalPlayer.Character then
            table.insert(filter, LocalPlayer.Character)
        end
        local camera = currentCamera()
        if camera then
            table.insert(filter, camera)
        end
        viewParams.FilterDescendantsInstances = filter
        for _, point in ipairs(headPoints(head)) do
            if Workspace:Raycast(cameraPosition, point - cameraPosition, viewParams) == nil then
                return point
            end
        end
        return nil
    end

    function TargetController:IsVisible(player, cameraPosition)
        return self:VisiblePoint(player, cameraPosition) ~= nil
    end

    function TargetController:Judge(player, cameraPosition)
        if not cameraPosition then
            local camera = currentCamera()
            if not camera then return false, false, math.huge end
            cameraPosition = camera.CFrame.Position
        end
        local head = player.Character and player.Character:FindFirstChild('Head')
        if not head then return false, false, math.huge end
        local distance = (head.Position - cameraPosition).Magnitude
        local point = self:VisiblePoint(player, cameraPosition)
        local inRange = distance <= MAX_TARGET_DISTANCE * env.RivalsSafety.rangeScale
        return point ~= nil, inRange, distance, point
    end

    function TargetController:GetClosestTarget()
        local camera = currentCamera()
        if not camera then
            self.targetVisible, self.targetInRange = false, false
            return nil
        end
        local cameraPosition = camera.CFrame.Position
        local judged = {}
        local function judge(player)
            local entry = judged[player]
            if not entry then
                entry = { self:Judge(player, cameraPosition) }
                judged[player] = entry
            end
            return entry[1], entry[2], entry[3]
        end
        local current = self.target
        local now = os.clock()
        self.meleeFirst = false

        local threat = self:NearestMeleeThreat(MELEE_FIRST)
        if threat and threat ~= current and self:IsShootable(threat, true) then
            local threatVisible, threatInRange = judge(threat)
            if threatVisible then
                self.hiddenSince = nil
                self.meleeFirst = true
                self.targetVisible, self.targetInRange = true, threatInRange
                return threat
            end
        end

        local valid = current ~= nil and self:IsShootable(current, true)
        local currentVisible, currentInRange, currentDistance = false, false, math.huge
        if valid then
            currentVisible, currentInRange, currentDistance = judge(current)
            if not currentVisible and not currentInRange then
                valid = false
            end
        end
        if valid then
            if self.lockTarget ~= current then
                self.lockTarget, self.lockAt = current, now
            end
            if currentVisible then
                self.hiddenSince = nil
            else
                self.hiddenSince = self.hiddenSince or now
            end
            local since = self.lockAt
            local stats = env.RivalsStats
            local lastHit = stats and stats.lastHit
            if lastHit and lastHit.target == current and lastHit.t > since then
                since = lastHit.t
            end
            local stale = now - since >= LOCK_STALE
            local hiddenLong = not currentVisible and now - self.hiddenSince >= HIDDEN_SWITCH
            if not stale and not hiddenLong and (currentVisible or currentInRange) then
                self.targetVisible, self.targetInRange = currentVisible, currentInRange
                return current
            end
        else
            self.lockTarget = nil
            self.hiddenSince = nil
        end

        local best, bestVisible, bestInRange, bestDistance = nil, false, false, math.huge
        local bestRank = math.huge
        for _, player in next, Players:GetPlayers() do
            if self:IsShootable(player, true) then
                local visible, inRange, distance = judge(player)
                local rank = visible and 1 or (inRange and 2 or nil)
                if rank and (rank < bestRank or (rank == bestRank and distance < bestDistance)) then
                    best, bestVisible, bestInRange, bestDistance, bestRank = player, visible, inRange, distance, rank
                end
            end
        end

        local pick = best
        if valid then
            pick = current
            local stale = now - (self.lockAt or now) >= LOCK_STALE
            local stats = env.RivalsStats
            local lastHit = stats and stats.lastHit
            if lastHit and lastHit.target == current and now - lastHit.t < LOCK_STALE then
                stale = false
            end
            if best ~= nil and best ~= current then
                if bestVisible and not currentVisible then
                    pick = best
                elseif bestInRange and not currentInRange and not currentVisible then
                    pick = best
                elseif stale and bestVisible == currentVisible and bestDistance < LOCK_CLOSER * currentDistance then
                    pick = best
                end
            end
        end
        if pick == current and valid then
            self.targetVisible, self.targetInRange = currentVisible, currentInRange
        elseif pick then
            self.targetVisible, self.targetInRange = bestVisible, bestInRange
        else
            self.targetVisible, self.targetInRange = false, false
        end
        return pick
    end

    function TargetController:NearestEnemy(range, meleeOnly)
        local root = Character.RootPart
        if not root then return nil end

        local limit = range or math.huge
        local targetState = env.RivalsTargetState
        local best, bestDistance, bestRoot = nil, nil, nil
        for _, player in next, Players:GetPlayers() do
            if self:IsValidCandidate(player, true) then
                local enemyRoot = player.Character:FindFirstChild('HumanoidRootPart')
                if enemyRoot then
                    local distance = (enemyRoot.Position - root.Position).Magnitude
                    if distance <= limit and (not best or distance < bestDistance) and (not meleeOnly or targetState:HoldsMelee(player)) then
                        best, bestDistance, bestRoot = player, distance, enemyRoot
                    end
                end
            end
        end
        if not best then return nil end
        return best, bestDistance, bestRoot
    end

    function TargetController:NearestEnemyDistance()
        local _, distance = self:NearestEnemy()
        return distance
    end

    function TargetController:NearestMeleeThreat(range)
        return self:NearestEnemy(range, true)
    end

    function TargetController:Stop()
        self.active = false
        if self.connection then
            self.connection:Disconnect()
            self.connection = nil
        end
    end

    TargetController:init()
end

local previousTuner = env.RivalsTuner
env.RivalsTuner = {
    dims = {},
    random = math.random,
    credits = 0,
    version = 4,
}
do
    local Tuner = env.RivalsTuner
    local MIN_TRIALS = 5
    local EXPLORE = 0.12
    local EXPLORE_SURE = 0.03
    local SURE_AFTER = 15
    local SURE_RATIO = 2.5
    local DECAY_AT = 80

    function Tuner:AddDimension(name, arms)
        local dim = { order = arms, arms = {} }
        for _, arm in ipairs(arms) do
            dim.arms[arm] = { assigned = 0, finished = 0, hits = 0 }
        end
        self.dims[name] = dim
    end

    local function score(arm)
        return (arm.hits + 1) / (arm.finished + 2)
    end

    function Tuner:Best(name)
        local dim = self.dims[name]
        local best, bestScore = dim.order[1], -1
        for _, arm in ipairs(dim.order) do
            local s = score(dim.arms[arm])
            if s > bestScore then
                best, bestScore = arm, s
            end
        end
        return best
    end

    function Tuner:Choose(name, weapon)
        if weapon then name = self:Scoped(name, weapon) end
        local dim = self.dims[name]
        local pick, fewest = nil, math.huge
        for _, arm in ipairs(dim.order) do
            local assigned = dim.arms[arm].assigned
            if assigned < MIN_TRIALS and assigned < fewest and dim.arms[arm].finished < 3 * MIN_TRIALS then
                pick, fewest = arm, assigned
            end
        end
        if not pick then
            local best = self:Best(name)
            local explore = EXPLORE
            if dim.arms[best].finished >= SURE_AFTER then
                local rival = 0
                for _, armName in ipairs(dim.order) do
                    if armName ~= best then
                        rival = math.max(rival, score(dim.arms[armName]))
                    end
                end
                if score(dim.arms[best]) >= SURE_RATIO * rival then
                    explore = EXPLORE_SURE
                end
            end
            if self.random() < explore then
                local index = math.min(#dim.order, math.floor(self.random() * #dim.order) + 1)
                pick = dim.order[index]
            else
                pick = best
            end
        end
        dim.arms[pick].assigned += 1
        return pick
    end

    function Tuner:Usable(name)
        local dim = self.dims[name]
        if not dim then return false end
        local finished = 0
        for _, arm in pairs(dim.arms) do
            finished += arm.finished
        end
        if finished < 20 or score(dim.arms[self:Best(name)]) >= 0.12 then
            return true
        end
        local now = os.clock()
        if not self.probeAt then
            self.probeAt = now - 1
        elseif now - self.probeAt >= 30 then
            self.probeAt = now
        end
        return now - self.probeAt < 1
    end

    function Tuner:Penalize(name, armName, weight)
        local dim = self.dims[name]
        local arm = dim and dim.arms[armName]
        if not arm then return end
        arm.finished += weight or 1
    end

    function Tuner:Credit(name, armName, hit)
        local dim = self.dims[name]
        local arm = dim and dim.arms[armName]
        if not arm then return end
        arm.finished += 1
        if hit then arm.hits += (type(hit) == 'number' and hit or 1) end

        self.credits += 1
        if self.credits % 20 == 0 and os.clock() - (self.savedAt or -math.huge) >= 5 then
            self.savedAt = os.clock()
            self:Save()
        end

        local total = 0
        for _, a in pairs(dim.arms) do total += a.finished end
        if total > DECAY_AT then
            for _, a in pairs(dim.arms) do
                a.finished = a.finished / 2
                a.hits = a.hits / 2
                a.assigned = math.min(a.assigned, MIN_TRIALS)
            end
        end
    end

    Tuner:AddDimension('origin', { 'under', 'shooter', 'clear' })
    Tuner:AddDimension('desync', { 'above', 'glue' })
    Tuner:AddDimension('point', { 'center', 'lead', 'split', 'ahead' })
    Tuner:AddDimension('facing', { 'look', 'old' })
    Tuner:AddDimension('direct', { 'near', 'camera' })
    Tuner:AddDimension('hitpart', { 'hitbox', 'head' })
    Tuner:AddDimension('reach', { 'move', 'stay' })
    Tuner:AddDimension('reachNear', { 'move', 'stay' })

    local SEEDS = {
        ["direct@Assault Rifle"] = { near = { 316, 1463 }, camera = { 267, 1240 } },
        ["direct@Bow"] = { near = { 1, 11 }, camera = { 1, 4 } },
        ["direct@Burst Rifle"] = { near = { 4, 8 }, camera = { 7, 16 } },
        ["direct@Daggers"] = { near = { 0, 3 }, camera = { 3, 13 } },
        ["direct@Energy Pistols"] = { near = { 9, 45 }, camera = { 18, 75 } },
        ["direct@Energy Rifle"] = { near = { 1, 6 }, camera = { 3, 14 } },
        ["direct@Grenade Launcher"] = { near = { 1, 14 }, camera = { 1, 2 } },
        ["direct@Handgun"] = { near = { 39, 118 }, camera = { 53, 110 } },
        ["direct@Minigun"] = { near = { 5, 22 }, camera = { 12, 34 } },
        ["direct@Permafrost"] = { near = { 2, 11 }, camera = { 2, 8 } },
        ["direct@Revolver"] = { near = { 3, 8 }, camera = { 5, 11 } },
        ["direct@Shotgun"] = { near = { 36, 115 }, camera = { 17, 72 } },
        ["direct@Slingshot"] = { near = { 7, 16 }, camera = { 1, 13 } },
        ["direct@Sniper"] = { near = { 14, 40 }, camera = { 31, 83 } },
        ["direct@Spray"] = { near = { 28, 65 }, camera = { 27, 65 } },
        ["direct@Uzi"] = { near = { 15, 40 }, camera = { 22, 68 } },
        ["direct@Wildcat"] = { near = { 9, 48 }, camera = { 2, 17 } },
        ["facing@Assault Rifle"] = { look = { 1082, 4636 }, old = { 998, 4072 } },
        ["facing@Bow"] = { look = { 2, 7 }, old = { 3, 33 } },
        ["facing@Burst Rifle"] = { look = { 29, 61 }, old = { 17, 31 } },
        ["facing@Daggers"] = { look = { 1, 10 }, old = { 2, 20 } },
        ["facing@Distortion"] = { look = { 7, 15 }, old = { 0, 1 } },
        ["facing@Energy Pistols"] = { look = { 30, 261 }, old = { 14, 113 } },
        ["facing@Energy Rifle"] = { look = { 19, 43 }, old = { 5, 22 } },
        ["facing@Exogun"] = { old = { 7, 10 } },
        ["facing@Grenade Launcher"] = { look = { 1, 6 }, old = { 4, 23 } },
        ["facing@Handgun"] = { look = { 132, 326 }, old = { 155, 366 } },
        ["facing@Minigun"] = { look = { 14, 104 }, old = { 21, 143 } },
        ["facing@Permafrost"] = { look = { 6, 25 }, old = { 20, 55 } },
        ["facing@Revolver"] = { look = { 18, 38 }, old = { 6, 17 } },
        ["facing@Shorty"] = { look = { 6, 18 }, old = { 1, 5 } },
        ["facing@Shotgun"] = { look = { 176, 430 }, old = { 123, 296 } },
        ["facing@Slingshot"] = { look = { 20, 126 }, old = { 17, 119 } },
        ["facing@Sniper"] = { look = { 65, 166 }, old = { 38, 119 } },
        ["facing@Spray"] = { look = { 75, 158 }, old = { 88, 206 } },
        ["facing@Uzi"] = { look = { 60, 219 }, old = { 29, 92 } },
        ["facing@Wildcat"] = { look = { 44, 171 }, old = { 13, 82 } },
        ["hitpart@Assault Rifle"] = { hitbox = { 1059, 4443 }, head = { 1021, 4265 } },
        ["hitpart@Bow"] = { hitbox = { 3, 15 }, head = { 2, 25 } },
        ["hitpart@Burst Rifle"] = { hitbox = { 18, 30 }, head = { 28, 62 } },
        ["hitpart@Daggers"] = { hitbox = { 0, 4 }, head = { 4, 26 } },
        ["hitpart@Distortion"] = { hitbox = { 1, 2 }, head = { 6, 14 } },
        ["hitpart@Energy Pistols"] = { hitbox = { 35, 206 }, head = { 9, 168 } },
        ["hitpart@Energy Rifle"] = { hitbox = { 5, 11 }, head = { 19, 54 } },
        ["hitpart@Exogun"] = { hitbox = { 3, 6 }, head = { 3, 4 } },
        ["hitpart@Grenade Launcher"] = { hitbox = { 2, 7 }, head = { 3, 22 } },
        ["hitpart@Handgun"] = { hitbox = { 182, 416 }, head = { 105, 276 } },
        ["hitpart@Minigun"] = { hitbox = { 18, 102 }, head = { 17, 145 } },
        ["hitpart@Permafrost"] = { hitbox = { 11, 38 }, head = { 15, 42 } },
        ["hitpart@Revolver"] = { hitbox = { 10, 25 }, head = { 14, 30 } },
        ["hitpart@Shorty"] = { hitbox = { 3, 11 }, head = { 4, 12 } },
        ["hitpart@Shotgun"] = { hitbox = { 129, 358 }, head = { 169, 368 } },
        ["hitpart@Slingshot"] = { hitbox = { 15, 113 }, head = { 22, 132 } },
        ["hitpart@Sniper"] = { hitbox = { 41, 105 }, head = { 62, 180 } },
        ["hitpart@Spray"] = { hitbox = { 98, 219 }, head = { 65, 145 } },
        ["hitpart@Uzi"] = { hitbox = { 25, 116 }, head = { 64, 195 } },
        ["hitpart@Wildcat"] = { hitbox = { 24, 113 }, head = { 32, 140 } },
        ["origin@Assault Rifle"] = { under = { 389, 1419 }, shooter = { 417, 1600 }, clear = { 393, 1602 } },
        ["origin@Bow"] = { under = { 2, 14 }, shooter = { 0, 2 }, clear = { 0, 2 } },
        ["origin@Burst Rifle"] = { under = { 6, 14 }, shooter = { 13, 21 }, clear = { 6, 12 } },
        ["origin@Daggers"] = { under = { 1, 6 }, shooter = { 0, 3 }, clear = { 0, 2 } },
        ["origin@Energy Pistols"] = { under = { 0, 45 }, shooter = { 3, 93 }, clear = { 9, 76 } },
        ["origin@Energy Rifle"] = { under = { 6, 15 }, shooter = { 8, 19 }, clear = { 1, 1 } },
        ["origin@Grenade Launcher"] = { under = { 3, 11 }, shooter = { 0, 1 } },
        ["origin@Handgun"] = { under = { 47, 110 }, shooter = { 46, 125 }, clear = { 45, 110 } },
        ["origin@Minigun"] = { under = { 14, 88 }, shooter = { 3, 52 }, clear = { 2, 32 } },
        ["origin@Permafrost"] = { under = { 9, 19 }, shooter = { 4, 12 } },
        ["origin@Revolver"] = { under = { 1, 7 }, shooter = { 4, 8 }, clear = { 6, 10 } },
        ["origin@Shorty"] = { under = { 3, 6 }, shooter = { 1, 2 }, clear = { 1, 2 } },
        ["origin@Shotgun"] = { under = { 84, 159 }, shooter = { 61, 147 }, clear = { 57, 133 } },
        ["origin@Slingshot"] = { under = { 11, 86 }, shooter = { 7, 44 }, clear = { 9, 60 } },
        ["origin@Sniper"] = { under = { 19, 46 }, shooter = { 10, 36 }, clear = { 5, 20 } },
        ["origin@Spray"] = { under = { 17, 40 }, shooter = { 28, 65 }, clear = { 41, 90 } },
        ["origin@Uzi"] = { under = { 7, 32 }, shooter = { 28, 70 }, clear = { 7, 62 } },
        ["origin@Wildcat"] = { under = { 15, 46 }, shooter = { 10, 53 }, clear = { 8, 35 } },
        ["point@Assault Rifle"] = { center = { 528, 2269 }, lead = { 474, 2065 }, split = { 514, 2120 }, ahead = { 563, 2254 } },
        ["point@Bow"] = { center = { 3, 21 }, lead = { 0, 4 }, split = { 1, 8 }, ahead = { 1, 7 } },
        ["point@Burst Rifle"] = { center = { 16, 30 }, lead = { 18, 39 }, split = { 4, 7 }, ahead = { 9, 16 } },
        ["point@Daggers"] = { center = { 0, 6 }, lead = { 1, 8 }, split = { 1, 7 }, ahead = { 2, 9 } },
        ["point@Distortion"] = { center = { 1, 2 }, lead = { 7, 13 }, split = { 0, 1 } },
        ["point@Energy Pistols"] = { center = { 7, 75 }, lead = { 7, 75 }, split = { 20, 123 }, ahead = { 10, 101 } },
        ["point@Energy Rifle"] = { center = { 3, 9 }, lead = { 8, 15 }, split = { 4, 14 }, ahead = { 10, 27 } },
        ["point@Exogun"] = { lead = { 2, 5 }, ahead = { 4, 5 } },
        ["point@Grenade Launcher"] = { center = { 0, 2 }, lead = { 0, 2 }, split = { 0, 1 }, ahead = { 5, 24 } },
        ["point@Handgun"] = { center = { 93, 209 }, lead = { 71, 179 }, split = { 61, 150 }, ahead = { 62, 154 } },
        ["point@Minigun"] = { center = { 17, 95 }, lead = { 5, 60 }, split = { 2, 40 }, ahead = { 11, 52 } },
        ["point@Permafrost"] = { center = { 14, 42 }, lead = { 5, 20 }, split = { 5, 14 }, ahead = { 2, 4 } },
        ["point@Revolver"] = { center = { 6, 14 }, lead = { 5, 14 }, split = { 5, 9 }, ahead = { 8, 18 } },
        ["point@Shorty"] = { center = { 2, 11 }, lead = { 1, 3 }, split = { 1, 3 }, ahead = { 3, 6 } },
        ["point@Shotgun"] = { center = { 82, 188 }, lead = { 79, 189 }, split = { 72, 189 }, ahead = { 65, 160 } },
        ["point@Slingshot"] = { center = { 8, 48 }, lead = { 10, 70 }, split = { 7, 54 }, ahead = { 12, 73 } },
        ["point@Sniper"] = { center = { 25, 73 }, lead = { 32, 89 }, split = { 33, 79 }, ahead = { 13, 44 } },
        ["point@Spray"] = { center = { 41, 87 }, lead = { 37, 77 }, split = { 38, 88 }, ahead = { 47, 112 } },
        ["point@Uzi"] = { center = { 23, 81 }, lead = { 5, 21 }, split = { 15, 78 }, ahead = { 45, 131 } },
        ["point@Wildcat"] = { center = { 13, 52 }, lead = { 4, 41 }, split = { 19, 56 }, ahead = { 20, 104 } },
        ["reach@Assault Rifle"] = { move = { 135, 689 }, stay = { 143, 601 } },
        ["reach@Bow"] = { move = { 1, 7 }, stay = { 0, 3 } },
        ["reach@Burst Rifle"] = { move = { 4, 10 }, stay = { 9, 20 } },
        ["reach@Energy Pistols"] = { move = { 1, 4 }, stay = { 0, 15 } },
        ["reach@Handgun"] = { move = { 12, 35 }, stay = { 20, 41 } },
        ["reach@Permafrost"] = { move = { 7, 21 }, stay = { 1, 15 } },
        ["reach@Revolver"] = { move = { 3, 9 }, stay = { 4, 9 } },
        ["reach@Shotgun"] = { move = { 16, 41 }, stay = { 21, 58 } },
        ["reach@Slingshot"] = { move = { 0, 3 }, stay = { 0, 7 } },
        ["reach@Sniper"] = { move = { 12, 31 }, stay = { 8, 25 } },
        ["reach@Spray"] = { move = { 9, 14 }, stay = { 14, 29 } },
        ["reach@Uzi"] = { move = { 5, 8 }, stay = { 3, 17 } },
        ["reach@Wildcat"] = { move = { 2, 8 }, stay = { 4, 21 } },
        ["reachNear@Assault Rifle"] = { move = { 124, 521 }, stay = { 250, 997 } },
        ["reachNear@Burst Rifle"] = { move = { 4, 7 }, stay = { 3, 8 } },
        ["reachNear@Energy Pistols"] = { move = { 1, 15 }, stay = { 27, 114 } },
        ["reachNear@Handgun"] = { move = { 43, 79 }, stay = { 26, 74 } },
        ["reachNear@Minigun"] = { move = { 0, 1 }, stay = { 10, 28 } },
        ["reachNear@Permafrost"] = { move = { 2, 8 }, stay = { 3, 5 } },
        ["reachNear@Shotgun"] = { move = { 22, 44 }, stay = { 17, 55 } },
        ["reachNear@Slingshot"] = { move = { 2, 23 }, stay = { 7, 22 } },
        ["reachNear@Sniper"] = { move = { 11, 21 }, stay = { 6, 14 } },
        ["reachNear@Spray"] = { move = { 12, 18 }, stay = { 17, 32 } },
        ["reachNear@Uzi"] = { move = { 4, 11 }, stay = { 14, 38 } },
        ["reachNear@Wildcat"] = { move = { 10, 38 }, stay = { 7, 44 } },
    }
    local SEED_CAP = 40
    local PRIOR = 0.2

    function Tuner:Scoped(name, weapon)
        local key = name .. '@' .. weapon
        if self.dims[key] then return key end
        local base = self.dims[name]
        if not base then return name end
        local seed = SEEDS[key]
        local total = 0
        if seed then
            for _, armName in ipairs(base.order) do
                if seed[armName] then total += seed[armName][2] end
            end
        end
        local scale = total > SEED_CAP and SEED_CAP / total or 1
        local dim = { order = base.order, arms = {} }
        for _, armName in ipairs(base.order) do
            local global, mine = base.arms[armName], seed and seed[armName]
            dim.arms[armName] = {
                assigned = MIN_TRIALS,
                finished = global.finished * PRIOR + (mine and mine[2] * scale or 0),
                hits = math.min(global.hits, global.finished) * PRIOR + (mine and mine[1] * scale or 0),
            }
        end
        self.dims[key] = dim
        return key
    end

    local FILE = 'rivals_tuner.json'
    local VERSION = 4

    local function inherit(source)
        for name in pairs(source) do
            local base, weapon = string.match(name, '^(.-)@(.+)$')
            if base then Tuner:Scoped(base, weapon) end
        end
        for name, dim in pairs(Tuner.dims) do
            local old = source[name]
            if type(old) == 'table' then
                for _, armName in ipairs(dim.order) do
                    local arm, before = dim.arms[armName], old[armName]
                    if type(before) == 'table' and type(before.finished) == 'number' and type(before.hits) == 'number' and before.finished >= 0 then
                        arm.finished = before.finished * 0.5
                        arm.hits = math.min(before.hits, before.finished) * 0.5
                        arm.assigned = math.min(MIN_TRIALS, math.floor(arm.finished))
                    end
                end
            end
        end
    end

    function Tuner:Save()
        if type(writefile) ~= 'function' then return false end
        local data = { version = VERSION, dims = {} }
        for name, dim in pairs(self.dims) do
            data.dims[name] = {}
            for armName, arm in pairs(dim.arms) do
                data.dims[name][armName] = { finished = arm.finished, hits = arm.hits }
            end
        end
        return (pcall(function()
            writefile(FILE, game:GetService('HttpService'):JSONEncode(data))
        end))
    end

    function Tuner:LoadFile()
        if type(readfile) ~= 'function' or type(isfile) ~= 'function' then return false end
        local ok, data = pcall(function()
            if not isfile(FILE) then return nil end
            return game:GetService('HttpService'):JSONDecode(readfile(FILE))
        end)
        if ok and type(data) == 'table' and data.version == VERSION and type(data.dims) == 'table' then
            inherit(data.dims)
            return true
        end
        return false
    end

    if previousTuner and previousTuner.dims and previousTuner.version == VERSION then
        local previous = {}
        for name, dim in pairs(previousTuner.dims) do
            previous[name] = dim.arms
        end
        inherit(previous)
        Tuner.source = 'memory'
    elseif Tuner:LoadFile() then
        Tuner.source = 'file'
    end
end

if env.RivalsStats and env.RivalsStats.connection then
    env.RivalsStats.connection:Disconnect()
end
env.RivalsStats = {
    shots = 0,
    hits = 0,
    misses = 0,
    pending = {},
    log = {},
    clock = os.clock,
    hookCalls = 0,
    topHits = 0,
    weighedHits = 0,
    skips = { payload = 0, rageOff = 0, noTarget = 0 },
    shapes = {},
    shapeCount = 0,
    relocated = 0,
    heldShots = 0,
    windows = 0,
    windowHits = 0,
    hookErrors = 0,
    hookErrorList = {},
    maxDamage = setmetatable({}, { __mode = 'k' }),
    lateWatch = setmetatable({}, { __mode = 'k' }),
}
do
    local Stats = env.RivalsStats
    local HIT_WINDOW = 0.6
    local LATE_WINDOW = 3
    local INFO_KEYS = 60
    local INFO_WORDS = { 'projectile', 'gravity', 'speed', 'velocity', 'drop', 'drag', 'arc', 'charge', 'lifetime', 'range', 'travel', 'bullet', 'radius' }

    local function middle(sorted)
        local n = #sorted
        if n % 2 == 1 then return sorted[(n + 1) / 2] end
        return (sorted[n / 2] + sorted[n / 2 + 1]) / 2
    end
    local LOG_SIZE = 5000
    local CONSOLE_LINES = 30
    local SCRIPT_CHECKPOINT = 64
    local SCRIPT_VERSION = '체크포인트 ' .. SCRIPT_CHECKPOINT
    env.RivalsVersion = SCRIPT_VERSION

    function Stats:Ping()
        local ok, value = pcall(function()
            return game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
        end)
        if ok and type(value) == 'number' and value > 0 then return value end
        ok, value = pcall(function()
            return LocalPlayer:GetNetworkPing()
        end)
        if ok and type(value) == 'number' and value > 0 then return value * 2000 end
        return nil
    end

    function Stats:Record(targetPlayer, info)
        local character = targetPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA('Humanoid')
        info = info or {}

        local head = character and character:FindFirstChild('Head')
        local camera = currentCamera()
        if head and camera then
            info.distance = (head.Position - camera.CFrame.Position).Magnitude
        end
        local root = character and character:FindFirstChild('HumanoidRootPart')
        if root and root.AssemblyLinearVelocity then
            info.speed = root.AssemblyLinearVelocity.Magnitude
        end
        info.ping = self:Ping()

        local record = {
            target = targetPlayer,
            humanoid = humanoid,
            health = humanoid and humanoid.Health or 0,
            t = self.clock(),
            info = info,
            result = 'pending',
            weapon = info.weapon,
        }
        local window = info.window
        if window and not window.recorded then
            window.recorded = true
            info.lead = true
            self.windows += 1
        end
        self.shots += 1
        table.insert(self.pending, record)
        table.insert(self.log, record)
        if #self.log > LOG_SIZE then
            table.remove(self.log, 1)
        end
        return record
    end

    function Stats:Resolve(record, hit, damage)
        record.result = hit and 'hit' or 'miss'
        local credit = hit
        if hit then
            self.hits += 1
            self.lastHit = { target = record.target, t = os.clock() }
            record.damage = damage
            record.delay = self.clock() - record.t
            if damage and record.weapon ~= nil then
                local best = math.max(self.maxDamage[record.weapon] or 0, damage)
                self.maxDamage[record.weapon] = best
                record.best = best
                local killed = record.humanoid ~= nil and record.humanoid.Health <= 0
                local ratio = best > 0 and math.min(1, damage / best) or 1
                self.weighedHits += 1
                if killed or ratio >= 0.9 then
                    self.topHits += 1
                end
                if killed then
                    event('킬', record.target and record.target.Name or '?')
                end
                credit = killed and 1 or math.max(0.1, ratio * ratio)
            end
        else
            self.misses += 1
        end
        local counted = true
        local window = record.info.window
        if window then
            if window.credited then
                counted = false
            else
                window.credited = true
                if hit then self.windowHits += 1 end
            end
        end
        if counted and record.info.arms and not record.info.invincible and record.info.moved ~= false then
            local weaponName = record.info.weaponName
            for dimension, arm in pairs(record.info.arms) do
                env.RivalsTuner:Credit(dimension, arm, credit)
                if weaponName then
                    env.RivalsTuner:Credit(dimension .. '@' .. weaponName, arm, credit)
                end
            end
        end
        if env.RivalsTargetState then
            env.RivalsTargetState:Settle(record.info, hit)
        end
    end

    function Stats:Skip(reason, shape)
        self.skips[reason] = (self.skips[reason] or 0) + 1
        if shape then
            if self.shapes[shape] == nil then
                if self.shapeCount >= 8 then
                    shape = '기타'
                else
                    self.shapeCount += 1
                end
            end
            self.shapes[shape] = (self.shapes[shape] or 0) + 1
        end
    end

    function Stats:CheckHook()
        if self.hookWarned or self.hookCalls > 0 then return end
        local fire = env.RivalsFire
        if not fire or fire.presses < 5 or not fire.firstPress then return end
        if self.clock() - fire.firstPress < 20 then return end

        self.hookWarned = true
        local text = '마우스를 ' .. fire.presses .. '번 눌렀는데 한 번도 안 불렸다'
        note('StartShooting 후킹이 불림', false, text)
    end

    function Stats:Update()
        local now = self.clock()
        local newHealth = {}
        local keep = {}
        local credit = {}
        local latency = nil
        for _, record in ipairs(self.pending) do
            local humanoid = record.humanoid
            if humanoid ~= nil and humanoid.Health < record.health - 0.001 then
                latency = latency or ((self:Ping() or 100) / 1000)
                local gap = math.abs((now - record.t) - latency)
                local best = credit[humanoid]
                if not best or gap < best.gap then
                    credit[humanoid] = { record = record, gap = gap, damage = record.health - humanoid.Health }
                end
            end
        end
        for _, record in ipairs(self.pending) do
            local humanoid = record.humanoid
            local best = humanoid ~= nil and credit[humanoid] or nil
            if best and best.record == record then
                newHealth[humanoid] = humanoid.Health
                self:Resolve(record, true, best.damage)
            elseif humanoid ~= nil and humanoid.Health <= 0 then
                record.result = 'dead'
            elseif humanoid == nil or now - record.t > HIT_WINDOW then
                self:Resolve(record, false)
                if humanoid ~= nil then
                    self.lateWatch[humanoid] = { record = record, health = humanoid.Health }
                end
            else
                table.insert(keep, record)
            end
        end
        local aimed = {}
        for _, record in ipairs(keep) do
            if record.humanoid then
                aimed[record.humanoid] = true
                if newHealth[record.humanoid] ~= nil then
                    record.health = newHealth[record.humanoid]
                end
            end
        end
        self.pending = keep
        for humanoid, watch in pairs(self.lateWatch) do
            local health = humanoid.Health
            if now - watch.record.t > LATE_WINDOW then
                self.lateWatch[humanoid] = nil
            elseif aimed[humanoid] or credit[humanoid] or health >= watch.health - 0.001 then
                watch.health = health
            else
                watch.record.late = now - watch.record.t
                watch.record.lateDamage = watch.health - math.max(health, 0)
                self.lateWatch[humanoid] = nil
            end
        end
    end

    local function describeKey(key)
        if type(key) == 'string' then
            local bytes = {}
            for i = 1, math.min(#key, 8) do
                table.insert(bytes, tostring(string.byte(key, i)))
            end
            return 'str[' .. table.concat(bytes, ',') .. ']'
        end
        return tostring(key)
    end

    function Stats:CheckPayload(cameraData)
        if self.payloadChecked then return end
        self.payloadChecked = true

        local present = 0
        for i = 0, 3 do
            if cameraData[utf8.char(i)] ~= nil then present += 1 end
        end
        self.drift = present < 4
        if not self.drift then return end

        local keys = {}
        for key, value in pairs(cameraData) do
            if #keys >= 12 then break end
            table.insert(keys, describeKey(key) .. '=' .. typeof(value))
        end
    end

    local function fmt(number)
        return number and string.format('%.1f', number) or '-'
    end

    local function windowRows(log)
        local rows, byId = {}, {}
        for _, record in ipairs(log) do
            local info = record.info or {}
            local window = info.window
            if type(window) == 'table' and window.id ~= nil then
                local row = byId[window.id]
                if not row then
                    row = { id = window.id, t = record.t, record = record, info = info, requests = 0, damage = 0 }
                    byId[window.id] = row
                    table.insert(rows, row)
                end
                row.requests += 1
                if record.result == 'hit' then
                    row.hit = true
                    row.damage += record.damage or 0
                elseif record.result == 'dead' then
                    row.dead = true
                elseif record.result == 'pending' then
                    row.pending = true
                end
            end
        end
        table.sort(rows, function(a, b) return a.id < b.id end)
        for _, row in ipairs(rows) do
            row.result = row.hit and 'hit' or row.pending and 'pending' or row.dead and 'dead' or 'miss'
        end
        return rows
    end

    local function csvNumber(number)
        return number and string.format('%.1f', number) or ''
    end

    local function shortText(text)
        local ok, stop = pcall(utf8.offset, text, 25)
        if not ok then return string.sub(text, 1, 24) end
        if stop then return string.sub(text, 1, stop - 1) .. '…' end
        return text
    end

    local function infoText(value)
        local kind = typeof(value)
        if kind == 'number' then
            return string.format('%.6g', value)
        elseif kind == 'boolean' or kind == 'EnumItem' then
            return tostring(value)
        elseif kind == 'string' then
            return '"' .. shortText(value) .. '"'
        elseif kind == 'Vector3' or kind == 'Vector2' or kind == 'NumberRange' or kind == 'Color3' then
            return '(' .. tostring(value) .. ')'
        elseif kind == 'Instance' then
            return '<' .. value.ClassName .. '>'
        end
        return nil
    end

    local function gunInfoText(gun)
        local saved = savedInfo[gun]
        local entries = {}
        local function add(path, value, changed)
            local ok, text = pcall(infoText, value)
            if not ok or text == nil then return end
            local lower, rank = string.lower(path), 1
            for _, word in ipairs(INFO_WORDS) do
                if string.find(lower, word, 1, true) then
                    rank = 0
                    break
                end
            end
            table.insert(entries, { path = path, text = text .. (changed and '*' or ''), rank = rank })
        end
        pcall(function()
            for key, value in pairs(gun) do
                local path = tostring(key)
                local changed = saved ~= nil and saved[key] ~= nil
                if changed then value = saved[key] or nil end
                if type(value) == 'table' then
                    local n = 0
                    for innerKey, innerValue in pairs(value) do
                        n += 1
                        if n > 40 then break end
                        if type(innerValue) ~= 'table' then
                            add(path .. '.' .. tostring(innerKey), innerValue, false)
                        end
                    end
                elseif value ~= nil then
                    add(path, value, changed)
                end
            end
        end)
        if #entries == 0 then return '(읽을 값 없음)' end
        table.sort(entries, function(a, b)
            if a.rank ~= b.rank then return a.rank < b.rank end
            return a.path < b.path
        end)
        local parts = {}
        for i = 1, math.min(#entries, INFO_KEYS) do
            table.insert(parts, entries[i].path .. '=' .. entries[i].text)
        end
        return table.concat(parts, ', ') .. (#entries > INFO_KEYS and string.format(' 외 %d개', #entries - INFO_KEYS) or '')
    end

    function Stats:Text()
        local finished = self.hits + self.misses
        local lines = {
            string.format('[rivals] 명중 %d/%d  샷 %d  대기 %d', self.hits, finished, self.shots, #self.pending),
            '버전: ' .. SCRIPT_VERSION,
            string.format('식별: 체크포인트=%d  판=%s  경과=%.0f초  샷=%d  명중=%d/%d  핑=%s',
                SCRIPT_CHECKPOINT, tostring(Events.id), self.clock() - Events.start, #self.log, self.hits, finished, fmt(self:Ping())),
            string.format('설정: 레이지=%d 사일런트=%d 자동발사=%d 트리거=%d 안티에임=%d 강도=%d 회전=%d 튕김=%d',
                on('rage') and 1 or 0, on('silent') and 1 or 0, on('autoFire') and 1 or 0, on('triggerbot') and 1 or 0,
                on('antiAim') and 1 or 0, math.floor(tonumber(cfg.antiAimLevel) or 1), on('antiAimSpin') and 1 or 0, on('antiAimJitter') and 1 or 0),
        }
        if self.weighedHits > 0 then
            table.insert(lines, string.format('최대 피해급 명중 %d/%d (머리 추정)', self.topHits, self.weighedHits))
        end
        if self.windows > 0 then
            table.insert(lines, string.format('서버 기준(추정): 발사 창 %d개 중 명중 %d (%d%%), 창당 요청 %.1f개',
                self.windows, self.windowHits, math.floor(100 * self.windowHits / self.windows + 0.5), self.shots / self.windows))
        end
        table.insert(lines, string.format('훅: 호출 %d, 에임 적용 %d  (대상 없음 %d, 에임 꺼짐 %d, 데이터 모양 이상 %d)',
            self.hookCalls, self.shots, self.skips.noTarget or 0, self.skips.rageOff or 0, self.skips.payload or 0) .. (self.heldShots > 0 and string.format('  첫 샷 대기 %d', self.heldShots) or ''))
        if self.hookErrors > 0 then
            local kinds = {}
            for _, entry in ipairs(self.hookErrorList) do
                table.insert(kinds, entry.text .. ' ×' .. entry.n)
            end
            table.insert(lines, string.format('훅 오류: %d번 (그 샷은 게임 원래대로 나감)  %s', self.hookErrors, table.concat(kinds, ' / ')))
        end
        local summary = env.RivalsTargetState and env.RivalsTargetState:Summary()
        if summary then
            table.insert(lines, summary)
        end
        local shapeList = {}
        for shape, count in pairs(self.shapes) do
            table.insert(shapeList, { shape = shape, count = count })
        end
        if #shapeList > 0 or self.relocated > 0 then
            table.sort(shapeList, function(a, b) return a.count > b.count end)
            local parts = {}
            for i = 1, math.min(#shapeList, 4) do
                table.insert(parts, string.format('%s ×%d', shapeList[i].shape, shapeList[i].count))
            end
            if self.relocated > 0 then
                table.insert(parts, string.format('다른 자리에서 찾음 %d', self.relocated))
            end
            table.insert(lines, '데이터 모양: ' .. table.concat(parts, ', '))
        end
        if #self.log >= 2 then
            local gaps = {}
            for i = 2, #self.log do
                table.insert(gaps, self.log[i].t - self.log[i - 1].t)
            end
            table.sort(gaps)
            table.insert(lines, string.format('샷 간격(중간값) %dms  핑 %s', math.floor(gaps[math.ceil(#gaps / 2)] * 1000 + 0.5), fmt(self:Ping())))
        end
        local boot = env.RivalsBoot
        if type(boot) == 'table' and type(boot.problems) == 'table' and #boot.problems > 0 then
            table.insert(lines, '시작 점검: ' .. table.concat(boot.problems, ' / '))
        end
        local check = env.RivalsCheck
        if check then
            local problems = {}
            local extra = {}
            for _, item in ipairs(check.items) do
                if not item.ok then
                    table.insert(problems, item.name .. (item.detail and (' (' .. item.detail .. ')') or ''))
                elseif item.detail then
                    table.insert(extra, item.name .. ': ' .. item.detail)
                end
            end
            table.insert(lines, '점검: ' .. (#problems == 0 and '정상' or table.concat(problems, ' / ')))
            for _, text in ipairs(extra) do
                table.insert(lines, '점검: ' .. text)
            end
        end
        local safety = env.RivalsSafety
        if safety then
            table.insert(lines, string.format('안전: 사망(디싱크 %d, 튕김 %d, 회전 %d)  속도제한 %d  추락복구 %d  사거리 x%.2f',
                safety.desyncDeaths, safety.jitterDeaths, safety.spinDeaths, safety.flings, safety.rescues, safety.rangeScale) .. ((safety.zoneRefusals or 0) > 0 and string.format('  킬존 자리 거부 %d프레임', safety.zoneRefusals) or '') .. (safety.jitterScale < 1 and string.format('  튕김폭 x%.2f', safety.jitterScale) or '') .. ((safety.jitterPulls + safety.jitterFlings) > 0 and string.format('  안티에임 이상(끌림 %d, 속도 %d)', safety.jitterPulls, safety.jitterFlings) or ''))
        end
        local antiAim = env.RivalsAntiAimStats
        if antiAim and (antiAim.threats > 0 or antiAim.shieldTime > 0 or antiAim.sinkTime > 0) then
            table.insert(lines, string.format('안티에임: 근접 위협 %d번, 대응 %.1f초 (거리 벌림 %.1f초), 방패 방향 %.1f초, 바닥 아래 %.1f초',
                antiAim.threats, antiAim.meleeTime, antiAim.dodgeTime, antiAim.shieldTime, antiAim.sinkTime))
        end
        local trigger = env.RivalsTrigger
        if trigger and (trigger.hits > 0 or (trigger.blocked or 0) > 0) then
            table.insert(lines, string.format('트리거: 적이 크로스헤어에 걸린 프레임 %d (그중 가장자리 %d), 놓친 직후 유지 %d, 반사·방패라 안 쏨 %d', trigger.hits, trigger.spread, trigger.held, trigger.blocked or 0))
        end
        if safety and #safety.deathLog > 0 then
            local function age(seconds)
                if seconds > 60 then return '-' end
                return string.format('%.1fs', seconds)
            end
            for i = #safety.deathLog, math.max(1, #safety.deathLog - 4), -1 do
                local death = safety.deathLog[i]
                table.insert(lines, string.format('죽음 %d: 디싱크 %s 전 / 회전 %s 전 / 방식 %s / 사거리 x%.2f / %s / 근접 위협 %s 전',
                    i, age(death.desync), age(death.spin), tostring(death.arm or '-'), death.range,
                    death.sudden and '급사' or '맞아서 사망', age(death.melee or math.huge)))
            end
        end
        local tuner = env.RivalsTuner
        if tuner then
            local names = {}
            for name in pairs(tuner.dims) do table.insert(names, name) end
            table.sort(names)
            for _, name in ipairs(names) do
                local dim = tuner.dims[name]
                local parts = {}
                for _, arm in ipairs(dim.order) do
                    local a = dim.arms[arm]
                    table.insert(parts, string.format('%s %.0f/%.0f', arm, a.hits, a.finished))
                end
                table.insert(lines, '튜너' .. (tuner.source and ('(' .. tuner.source .. '에서 이어받음)') or '') .. ' ' .. name .. ': ' .. table.concat(parts, '  ') .. '  -> ' .. tuner:Best(name))
            end
        end
        do
            local direct, wall = { 0, 0 }, { 0, 0 }
            local buckets = { { 30, '0-30' }, { 60, '30-60' }, { 100, '60-100' }, { 150, '100-150' }, { math.huge, '150+' } }
            local bucketStats = {}
            for i = 1, #buckets do bucketStats[i] = { 0, 0 } end
            local weapons, weaponOrder = {}, {}
            local moves = { moved = { 0, 0 }, exact = { 0, 0 }, stuck = { 0, 0 } }
            local total = 0
            for _, record in ipairs(self.log) do
                if record.result ~= 'pending' then
                    total += 1
                    local info = record.info or {}
                    local hit = record.result == 'hit' and 1 or 0
                    local side = info.direct and direct or wall
                    side[1] += hit
                    side[2] += 1
                    if info.moved ~= nil then
                        local move = info.moved and moves.moved or moves.stuck
                        move[1] += hit
                        move[2] += 1
                        if info.exact then
                            moves.exact[1] += hit
                            moves.exact[2] += 1
                        end
                    end
                    if info.distance then
                        for i, bucket in ipairs(buckets) do
                            if info.distance < bucket[1] then
                                bucketStats[i][1] += hit
                                bucketStats[i][2] += 1
                                break
                            end
                        end
                    end
                    local name = info.weaponName or '?'
                    local entry = weapons[name]
                    if not entry then
                        entry = { hits = 0, shots = 0, top = 0 }
                        weapons[name] = entry
                        table.insert(weaponOrder, name)
                    end
                    entry.shots += 1
                    entry.hits += hit
                    if hit == 1 and record.damage and record.best and record.damage >= 0.9 * record.best then
                        entry.top += 1
                    end
                end
            end
            if total > 0 then
                table.insert(lines, string.format('구분: 직접 %d/%d  벽 뒤 %d/%d', direct[1], direct[2], wall[1], wall[2]))
                if moves.moved[2] + moves.stuck[2] > 0 then
                    table.insert(lines, string.format('몸 이동: 옮김 %d/%d (그중 정밀 검사로 찾은 자리 %d/%d)  자리 없음 %d/%d',
                        moves.moved[1], moves.moved[2], moves.exact[1], moves.exact[2], moves.stuck[1], moves.stuck[2]))
                end
                local parts = {}
                for i, bucket in ipairs(buckets) do
                    table.insert(parts, string.format('%s %d/%d', bucket[2], bucketStats[i][1], bucketStats[i][2]))
                end
                table.insert(lines, '거리별: ' .. table.concat(parts, '  '))
                table.sort(weaponOrder, function(a, b) return weapons[a].shots > weapons[b].shots end)
                parts = {}
                for _, name in ipairs(weaponOrder) do
                    table.insert(parts, string.format('%s %d/%d (최대 피해급 %d)', name, weapons[name].hits, weapons[name].shots, weapons[name].top))
                end
                table.insert(lines, '무기별: ' .. table.concat(parts, '  '))
            end
            local kills, deaths, taken, takenSum = 0, 0, 0, 0
            for _, entry in ipairs(Events.list) do
                if entry.kind == '킬' then
                    kills += 1
                elseif entry.kind == '죽음' then
                    deaths += 1
                elseif entry.kind == '피격' then
                    taken += 1
                    takenSum += tonumber(string.match(tostring(entry.text), '^(%d+)')) or 0
                end
            end
            if kills + deaths + taken > 0 then
                table.insert(lines, string.format('사건: 킬 %d  죽음 %d  피격 %d번(합계 %d)', kills, deaths, taken, takenSum))
            end
        end
        do
            local guns, order = {}, {}
            for _, record in ipairs(self.log) do
                local info = record.info or {}
                local name = info.weaponName
                if name then
                    local entry = guns[name]
                    if not entry then
                        entry = { delays = {}, late = {}, lateDamage = 0 }
                        guns[name] = entry
                        table.insert(order, name)
                    end
                    if type(info.gun) == 'table' then entry.gun = info.gun end
                    if record.result == 'hit' and record.delay then
                        table.insert(entry.delays, record.delay)
                    end
                    if record.late then
                        table.insert(entry.late, record.late)
                        entry.lateDamage += record.lateDamage or 0
                    end
                end
            end
            for _, name in ipairs(order) do
                local entry = guns[name]
                local delays, late = entry.delays, entry.late
                if #delays > 0 then
                    table.sort(delays)
                    table.insert(lines, string.format('명중 지연 %s: 중간값 %.2f초, 가장 늦은 %.2f초 (%d발)', name, middle(delays), delays[#delays], #delays))
                end
                if #late > 0 then
                    table.sort(late)
                    table.insert(lines, string.format('늦은 피해 %s: %d번, 쏜 뒤 %.2f~%.2f초 (중간값 %.2f초), 피해 합계 %.0f', name, #late, late[1], late[#late], middle(late), entry.lateDamage))
                end
                if entry.gun then
                    table.insert(lines, '무기 정보 ' .. name .. ': ' .. gunInfoText(entry.gun))
                end
            end
        end
        local rows = windowRows(self.log)
        if #rows > 0 then
            local dims, dimOrder = {}, {}
            for _, row in ipairs(rows) do
                if row.result == 'hit' or row.result == 'miss' then
                    for dimension, arm in pairs(row.info.arms or {}) do
                        local dim = dims[dimension]
                        if not dim then
                            dim = { arms = {}, order = {} }
                            dims[dimension] = dim
                            table.insert(dimOrder, dimension)
                        end
                        local entry = dim.arms[arm]
                        if not entry then
                            entry = { hits = 0, n = 0 }
                            dim.arms[arm] = entry
                            table.insert(dim.order, tostring(arm))
                        end
                        entry.n += 1
                        if row.result == 'hit' then entry.hits += 1 end
                    end
                end
            end
            table.sort(dimOrder)
            for _, dimension in ipairs(dimOrder) do
                local dim = dims[dimension]
                table.sort(dim.order)
                local parts = {}
                for _, arm in ipairs(dim.order) do
                    local entry = dim.arms[arm]
                    table.insert(parts, string.format('%s %d/%d (%d%%)', arm, entry.hits, entry.n, math.floor(100 * entry.hits / entry.n + 0.5)))
                end
                table.insert(lines, '이번 판 창 기준 ' .. dimension .. ': ' .. table.concat(parts, '  '))
            end
            local targets, targetOrder = {}, {}
            for _, row in ipairs(rows) do
                local name = row.record.target and row.record.target.Name or '?'
                local entry = targets[name]
                if not entry then
                    entry = { hits = 0, n = 0, kills = 0 }
                    targets[name] = entry
                    table.insert(targetOrder, name)
                end
                entry.n += 1
                if row.result == 'hit' then entry.hits += 1 end
            end
            for _, event_ in ipairs(Events.list) do
                if event_.kind == '킬' and targets[tostring(event_.text)] then
                    targets[tostring(event_.text)].kills += 1
                end
            end
            table.sort(targetOrder, function(a, b) return targets[a].n > targets[b].n end)
            local parts = {}
            for i = 1, math.min(#targetOrder, 8) do
                local name = targetOrder[i]
                table.insert(parts, string.format('%s 창 %d/%d 킬 %d', name, targets[name].hits, targets[name].n, targets[name].kills))
            end
            table.insert(lines, '상대별: ' .. table.concat(parts, '  /  '))
        end
        local head = #lines
        table.insert(lines, string.format('샷 기록 %d발 (이번 판 전부, 최근 것부터)', #self.log))
        for i = #self.log, 1, -1 do
            local record = self.log[i]
            local info = record.info or {}
            local arms = ''
            if info.arms then
                local parts = {}
                for dimension, arm in pairs(info.arms) do
                    table.insert(parts, dimension .. '=' .. tostring(arm))
                end
                table.sort(parts)
                arms = '  모드 ' .. table.concat(parts, ',')
            end
            if info.moved == false then
                arms = arms .. '  몸 안 옮김'
            elseif info.exact then
                arms = arms .. '  정밀 검사 자리'
            end
            if info.edge then
                arms = arms .. '  머리 일부만 보임'
            end
            if info.invincible then
                arms = arms .. '  무적=1'
            end
            if info.block then
                arms = arms .. '  막힘=' .. (info.block == 'front' and '앞' or info.block == 'back' and '뒤' or '반사')
            end
            if info.flank then
                arms = arms .. '  우회=1'
            end
            if info.control then
                arms = arms .. '  대조=1'
            end
            if record.damage then
                arms = arms .. '  피해 ' .. string.format('%.0f', record.damage) .. (record.best and string.format('/%.0f', record.best) or '')
            end
            if record.result == 'hit' and record.delay then
                arms = arms .. string.format('  지연 %.2f', record.delay)
            end
            if record.late then
                arms = arms .. string.format('  늦은 피해 %.2f초(%.0f)', record.late, record.lateDamage or 0)
            end
            if info.weaponName then
                arms = arms .. '  무기 ' .. info.weaponName
            end
            if info.silent then
                arms = arms .. '  사일런트'
            end
            if info.meleeSafe then
                arms = arms .. '  근접회피=1'
            end
            if info.escape then
                arms = arms .. '  근접탈출=1'
            end
            if info.body then
                arms = arms .. '  몸통(머리 안 보임)'
            end
            if info.direct then
                arms = arms .. (info.visible and '  보이는 적(직접)' or '  직접')
            elseif info.arms and info.arms.desync then
                arms = arms .. '  벽 뒤(디싱크)'
            end
            if info.window then
                arms = arms .. '  창 ' .. info.window.id .. (info.lead and '*' or '')
            end
            table.insert(lines, string.format('  %-7s %-16s 거리 %s  속도 %s  핑 %s%s  t %.2f',
                record.result, record.target and record.target.Name or '?', fmt(info.distance), fmt(info.speed), fmt(info.ping), arms, record.t - Events.start))
        end
        local shown = #lines
        table.insert(lines, string.format('이벤트 %d개 (이번 판 전부, 시간 순서)', #Events.list))
        for _, entry in ipairs(Events.list) do
            table.insert(lines, string.format('  [%.1f] %s: %s', entry.t - Events.start, entry.kind, tostring(entry.text)))
        end
        if #rows > 0 then
            table.insert(lines, string.format('창 표 %d개 (CSV, 창마다 한 줄)', #rows))
            table.insert(lines, 'id,t,target,result,requests,damage,dist,speed,ping,weapon,kind,desync,origin,direct,point,hitpart,facing,reach,reachNear,flags')
            for _, row in ipairs(rows) do
                local info, arms = row.info, row.info.arms or {}
                local kind = info.body and 'body' or info.escape and 'escape' or info.direct and (info.visible and 'visible' or 'direct') or (arms.desync and 'wall' or 'other')
                local flags = {}
                for _, flag in ipairs({ 'silent', 'meleeSafe', 'edge', 'invincible', 'flank', 'control', 'retargeted', 'exact' }) do
                    if info[flag] then table.insert(flags, flag) end
                end
                if info.block then table.insert(flags, 'block=' .. tostring(info.block)) end
                if info.moved == false then table.insert(flags, 'notMoved') end
                local function arm(name) return arms[name] ~= nil and tostring(arms[name]) or '' end
                table.insert(lines, table.concat({
                    tostring(row.id), string.format('%.2f', row.t - Events.start), row.record.target and row.record.target.Name or '?',
                    row.result, tostring(row.requests), string.format('%.0f', row.damage), csvNumber(info.distance), csvNumber(info.speed),
                    csvNumber(info.ping), info.weaponName or '', kind, arm('desync'), arm('origin'), arm('direct'), arm('point'),
                    arm('hitpart'), arm('facing'), arm('reach'), arm('reachNear'), table.concat(flags, ';'),
                }, ','))
            end
        end
        local text = table.concat(lines, '\n')
        return text, lines, head, shown
    end

    function Stats:Save(text)
        if type(writefile) ~= 'function' then return false end
        return (pcall(function()
            writefile('rivals_match_' .. tostring(Events.id) .. '.txt', text)
        end))
    end

    function Stats:HookError(err)
        local message = tostring(err)
        local ok, stop = pcall(utf8.offset, message, 301)
        if not ok then
            message = string.sub(message, 1, 300)
        elseif stop then
            message = string.sub(message, 1, stop - 1)
        end
        self.hookErrors += 1
        for _, entry in ipairs(self.hookErrorList) do
            if entry.text == message then
                entry.n += 1
                return
            end
        end
        if #self.hookErrorList >= 5 then return end
        table.insert(self.hookErrorList, { text = message, n = 1 })
        event('훅 오류', message)
    end

    function Stats:SendWebhook(text, fileName)
        local url = env.RivalsWebhookUrl
        if type(url) ~= "string" or not url:find("^https://rivals%-batch%.justiceasra%.workers%.dev/?$") then
            return false
        end
        local req = request or http_request or (syn and syn.request) or (http and http.request)
        if type(req) ~= "function" then
            return false
        end

        local HttpService = game:GetService("HttpService")
        local boundary = "----RivalsBoundary" .. tostring(os.time()) .. tostring(math.random(100000, 999999))
        local payload = HttpService:JSONEncode({
            content = string.format("[체크포인트 %d] 판 종료: 샷 %d발 기록 (%s)", SCRIPT_CHECKPOINT, #self.log, fileName),
        })
        local body = table.concat({
            "--" .. boundary,
            'Content-Disposition: form-data; name="payload_json"',
            "Content-Type: application/json",
            "",
            payload,
            "--" .. boundary,
            'Content-Disposition: form-data; name="files[0]"; filename="' .. fileName .. '"',
            "Content-Type: text/plain; charset=utf-8",
            "",
            text,
            "--" .. boundary .. "--",
            "",
        }, "\r\n")

        task.spawn(function()
            local ok, res = pcall(req, {
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. boundary },
                Body = body,
            })
            if not ok then
            elseif res and res.StatusCode and (res.StatusCode < 200 or res.StatusCode >= 300) then
            else
            end
        end)
        return true
    end

    function Stats:Dump()
        local text, lines, head = self:Text()
        for i, line in ipairs(lines) do
            if i <= head + 1 + CONSOLE_LINES then
            end
        end
        self:Save(text)
        self:SendWebhook(text, 'rivals_cp' .. SCRIPT_CHECKPOINT .. '_dump.txt')
        return text
    end

    function Stats:NewMatch()
        if #self.log > 0 or #Events.list > 0 then
            local text = (self:Text())
            self:Save(text)
            if #self.log > 0 or self.hookErrors > 0 then
                self:SendWebhook(text, 'rivals_cp' .. SCRIPT_CHECKPOINT .. '_match_' .. tostring(Events.id) .. '.txt')
            end
        end
        self.log = {}
        table.clear(self.lateWatch)
        local antiAim = env.RivalsAntiAimStats
        if antiAim then
            antiAim.threats, antiAim.meleeTime, antiAim.dodgeTime, antiAim.shieldTime, antiAim.sinkTime = 0, 0, 0, 0, 0
        end
        local trigger = env.RivalsTrigger
        if trigger then
            trigger.hits, trigger.held, trigger.spread, trigger.blocked = 0, 0, 0, 0
        end
        Events.list = {}
        Events.start = os.clock()
        Events.id = os.time()
        event('판 시작', tostring(LocalPlayer:GetAttribute('SpectatingDuelObjectID')))
    end

    function Stats:Rate()
        local done = self.hits + self.misses
        if done == 0 then return nil end
        return self.hits / done
    end

    local lastMatch = LocalPlayer:GetAttribute('SpectatingDuelObjectID')
    local lastHealth = nil
    Stats.connection = RunService.Heartbeat:Connect(function()
        local match = LocalPlayer:GetAttribute('SpectatingDuelObjectID')
        if match ~= lastMatch then
            lastMatch = match
            Stats:NewMatch()
        end
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildWhichIsA('Humanoid')
        local health = humanoid and humanoid.Health
        if health and lastHealth and health < lastHealth - 0.5 then
            event('피격', string.format('%.0f 깎임 (남은 %.0f)', lastHealth - health, health))
        end
        lastHealth = health
        Stats:Update()
        Stats:CheckHook()
    end)
end

local LEAD_LIMIT = 12

local function aimPoint(arm, base, targetHead, targetRoot, ping)
    local velocity = targetRoot and targetRoot.AssemblyLinearVelocity
    if arm == 'center' or not velocity then
        return base, base
    end
    if arm == 'lead' then
        local size = targetHead.Size
        local limit = 0.45 * math.min(size.X, size.Y, size.Z)
        local center = targetHead.Position
        local inside = base - center + velocity * ((ping or 80) / 1000)
        if inside.Magnitude > limit then
            inside = inside.Unit * limit
        end
        return center + inside, center + inside
    end
    local shift = velocity * ((ping or 120) / 1000 + (arm == 'ahead' and 0.1 or 0))
    if shift.Magnitude > LEAD_LIMIT then
        shift = shift.Unit * LEAD_LIMIT
    end
    return base + shift, base
end

local DESYNC_CANDIDATES = {
    above = { CFrame.new(0, 7, -2), CFrame.new(0, 7, 2), CFrame.new(3, 7, 0), CFrame.new(-3, 7, 0), CFrame.new(0, 12, 0) },
    close = { CFrame.new(0, 2, -3), CFrame.new(0, 2, 3), CFrame.new(3, 2, 0), CFrame.new(-3, 2, 0), CFrame.new(3, 2, 3), CFrame.new(-3, 2, 3), CFrame.new(3, 2, -3), CFrame.new(-3, 2, -3) },
}

DESYNC_CANDIDATES.glue = { CFrame.new(0, -0.7, 0.05), anchor = 'head' }

DESYNC_CANDIDATES.melee = {
    CFrame.new(0, 3, 12), CFrame.new(12, 3, 0), CFrame.new(-12, 3, 0), CFrame.new(9, 3, 9), CFrame.new(-9, 3, 9),
    CFrame.new(0, 3, -12), CFrame.new(9, 3, -9), CFrame.new(-9, 3, -9),
}

local DESYNC_FALLBACK = {
    above = DESYNC_CANDIDATES.close,
    glue = {},
    melee = { CFrame.new(0, 14, 0), CFrame.new(0, 12, 8), CFrame.new(0, 12, -8), CFrame.new(8, 12, 0), CFrame.new(-8, 12, 0) },
}
for _, list in ipairs({ DESYNC_CANDIDATES.above, DESYNC_CANDIDATES.close }) do
    for _, offset in ipairs(list) do
        table.insert(DESYNC_FALLBACK.glue, offset)
    end
end

local CLEAR_OFFSETS = {
    Vector3.new(0, 5, 0), Vector3.new(5, 2, 0), Vector3.new(-5, 2, 0), Vector3.new(0, 2, 5), Vector3.new(0, 2, -5), Vector3.new(0, -5, 0),
}

local function clearOrigin(targetHead)
    local head = targetHead.Position
    local candidates = {}
    local camera = currentCamera()
    if camera then
        local toward = camera.CFrame.Position - head
        if toward.Magnitude > 0.1 then
            table.insert(candidates, head + toward.Unit * 5)
        end
    end
    for _, offset in ipairs(CLEAR_OFFSETS) do
        table.insert(candidates, head + offset)
    end
    for _, point in ipairs(candidates) do
        if DesyncController:Sight(point, head, targetHead) and DesyncController:Free(point, targetHead.Parent) then
            return point
        end
    end
    return nil
end

local FLANK_REACH = 4
local FLANK_STEPS = 12

local function flankOrigin(player, targetHead, weaponName, planned)
    local head = targetHead.Position
    local best, bestGap = nil, math.huge
    for step = 0, FLANK_STEPS - 1 do
        local angle = step * (2 * math.pi / FLANK_STEPS)
        for _, lift in ipairs({ 0, 2 }) do
            local point = head + Vector3.new(math.cos(angle) * FLANK_REACH, lift, math.sin(angle) * FLANK_REACH)
            local gap = (point - planned).Magnitude
            if gap < bestGap
                and not env.RivalsTargetState:Blocked(player, point, weaponName)
                and DesyncController:Sight(point, head, targetHead)
                and DesyncController:Free(point, targetHead.Parent) then
                best, bestGap = point, gap
            end
        end
    end
    return best
end

local function sightPoint(from, targetHead)
    for _, point in ipairs(headPoints(targetHead)) do
        if DesyncController:Sight(from, point, targetHead) then
            return point
        end
    end
    return targetHead.Position
end

local function findShot(result)
    local data = result[3]
    if typeof(data) == 'table' then
        return data, false
    end
    for i = 1, result.n do
        local value = result[i]
        if typeof(value) == 'table' and (value[utf8.char(0)] ~= nil or value[utf8.char(1)] ~= nil) then
            return value, true
        end
    end
    return nil, false
end

local function shotTable(result)
    local data, relocated = findShot(result)
    if relocated then
        env.RivalsStats.relocated += 1
    end
    return data
end

local function shapeOf(result)
    local parts = {}
    for i = 1, math.min(result.n, 6) do
        table.insert(parts, typeof(result[i]))
    end
    return result.n .. '개' .. (#parts > 0 and ('(' .. table.concat(parts, ',') .. ')') or '')
end

local NEAR_DISTANCE = 4
local REACH_MIN = 50
local HOLD_FRAMES = 6

local function antiAimMoved()
    local frameAt = env.RivalsAntiAimFrameAt
    return env.RivalsAntiAimMoved == true and frameAt ~= nil and os.clock() - frameAt < 0.1
end
local MELEE_ESCAPE = 18

local function shotOrigin(arm, targetHead, targetRoot)
    local camera = currentCamera()
    if arm == 'camera' and camera then
        return camera.CFrame.Position
    elseif arm == 'near' and camera then
        local toward = camera.CFrame.Position - targetHead.Position
        if toward.Magnitude > NEAR_DISTANCE then
            return targetHead.Position + toward.Unit * NEAR_DISTANCE
        end
        return camera.CFrame.Position
    elseif arm == 'clear' then
        local point = clearOrigin(targetHead)
        if point then
            return point
        end
    elseif arm == 'shooter' then
        local placed = DesyncController.active and DesyncController.placed
        if placed then
            return placed.Position + Vector3.new(0, 1.75, 0)
        end
        if camera then
            return camera.CFrame.Position
        end
    end
    return targetHead.Position - Vector3.new(0, 8, 0)
end

local ShotWindow = { count = 0 }
env.RivalsShotWindow = ShotWindow
do
    local function realCycle(controller)
        local info = type(controller) == 'table' and rawget(controller, 'Info') or nil
        if info == nil then pcall(function() info = controller.Info end) end
        if type(info) ~= 'table' then return 0 end
        local original = savedInfo[info]
        local function value(key)
            local saved = original and original[key]
            local found = saved
            if saved == nil then found = info[key] end
            return type(found) == 'number' and found or 0
        end
        local cooldown = value('ShootCooldown')
        local burst = math.max(1, value('ShootBurst'))
        local burstCooldown = value('ShootBurstCooldown')
        return (burst - 1) * burstCooldown + math.max(cooldown, burstCooldown)
    end
    ShotWindow.RealCycle = realCycle

    function ShotWindow:Enter(controller, now)
        local current = self.current
        if current and current.controller == controller and now < current.endsAt then
            current.requests += 1
            return current
        end
        self.count += 1
        local weapon = nil
        pcall(function() weapon = controller.Name end)
        current = { id = self.count, controller = controller, weapon = type(weapon) == 'string' and weapon or nil, startsAt = now, endsAt = now + realCycle(controller), requests = 1, choices = {} }
        self.current = current
        return current
    end

    function ShotWindow:Choose(window, name)
        local choice = window.choices[name]
        if choice == nil then
            choice = env.RivalsTuner:Choose(name, window.weapon)
            window.choices[name] = choice
        end
        return choice
    end
end

env.WallbangController = {}
do
    function WallbangController:init()
        self.active = true
        self.startShootingRef = GunItem and GunItem.StartShooting
        self.desyncCleanup = nil

        self:Start()
    end

    function WallbangController:ArmCleanup()
        DesyncController.expireAt = os.clock() + 0.6
        if self.desyncCleanup then
            pcall(task.cancel, self.desyncCleanup)
        end
        self.desyncCleanup = task.delay(0.15, function()
            DesyncController:Stop()
        end)
    end

    function WallbangController:ArmFor(target)
        local tuner = env.RivalsTuner
        if tuner.desyncTarget ~= target or tuner.desyncCharacter ~= target.Character then
            tuner.desyncTarget = target
            tuner.desyncCharacter = target.Character
            tuner.desyncArm = tuner:Choose('desync')
        end
        return tuner.desyncArm
    end

    function WallbangController:Start()
        self:Stop()

        if type(self.startShootingRef) ~= 'function' or not Utility or type(Utility.EncodeCFrame) ~= 'function' then
            self.active = false
            return
        end

        self.active = true

        GunItem.StartShooting = function(controller, ...)
            local result = table.pack(self.startShootingRef(controller, ...))
            local data = findShot(result)
            local before = nil
            if type(data) == 'table' then
                before = {}
                for key, value in next, data do
                    before[key] = value
                end
            end
            local spread = result[4]
            local ok, err = pcall(self.Aim, self, controller, result)
            if not ok then
                pcall(function()
                    if before then
                        for key in next, data do
                            data[key] = nil
                        end
                        for key, value in next, before do
                            data[key] = value
                        end
                    end
                    result[4] = spread
                end)
                pcall(env.RivalsStats.HookError, env.RivalsStats, err)
            end
            return unpack(result, 1, result.n)
        end
    end

    function WallbangController:Aim(controller, result)
        local clientFighter = controller.ClientFighter
        if not clientFighter.IsLocalPlayer then
            return
        end

        env.RivalsStats.hookCalls += 1

        local cameraData = shotTable(result)
        if not cameraData then
            env.RivalsStats:Skip('payload', shapeOf(result))
            return
        end
        env.RivalsShotAt = os.clock()

        if antiAimMoved() then
            env.RivalsStats.heldShots += 1
            for _ = 1, HOLD_FRAMES do
                task.wait()
                if not antiAimMoved() then break end
            end
        end

        local window = ShotWindow:Enter(controller, os.clock())
        local function choose(name)
            return ShotWindow:Choose(window, name)
        end

        if on('noSpread') then
            result[4] = true
        end

        local rage = on('rage')
        local silent = not rage and on('silent')
        local targetPlayer = TargetController.target
        if silent and targetPlayer == nil then
            targetPlayer = TargetController:VisibleEnemy()
        end
        if not self.active or not (rage or silent) or not targetPlayer or not targetPlayer.Character then
            env.RivalsStats:Skip(not (rage or silent) and 'rageOff' or 'noTarget')
            return
        end

        if self.desyncCleanup then
            task.cancel(self.desyncCleanup)
            self.desyncCleanup = nil
        end
        DesyncController.expireAt = os.clock() + 0.6

        local weaponName = nil
        pcall(function() weaponName = controller.Name end)
        local visible, inRange, distance, seenPoint = TargetController:Judge(targetPlayer)
        local pinned = false
        if silent and not visible then
            local other, otherPoint, otherDistance = TargetController:VisibleEnemy()
            if not other then
                local bodyPlayer, bodyPart, bodyPoint = TargetController:VisibleBodyEnemy(weaponName)
                if bodyPlayer then
                    self:BodyShot(controller, cameraData, bodyPlayer, bodyPart, bodyPoint, weaponName, window)
                    return
                end
                env.RivalsStats:Skip('noTarget')
                return
            end
            targetPlayer, seenPoint, distance = other, otherPoint, otherDistance
            visible, inRange, pinned = true, true, true
        elseif silent and targetPlayer ~= TargetController.target then
            pinned = true
        end
        if not visible and not inRange then
            env.RivalsStats:Skip('noTarget')
            self:ArmCleanup()
            return
        end
        local direct = visible
        local reachArm = nil
        local reachDim = nil
        local escape = rage and visible and distance < MELEE_ESCAPE and env.RivalsTargetState:HoldsMelee(targetPlayer)
        if rage and visible and inRange and not escape then
            reachDim = distance >= REACH_MIN and 'reach' or 'reachNear'
            reachArm = choose(reachDim)
            if reachArm ~= 'move' and reachArm ~= 'stay' then reachArm = nil end
        end
        local desyncArm = (visible and reachArm ~= 'move' and not escape) and 'none' or self:ArmFor(targetPlayer)
        local meleeSafe = false
        if desyncArm == 'none' then
            if DesyncController.active then
                DesyncController:Stop()
            end
        else
            meleeSafe = env.RivalsTargetState:HoldsMelee(targetPlayer)
            local spots = DESYNC_CANDIDATES[meleeSafe and 'melee' or desyncArm]
            if DesyncController.offsets ~= spots then
                DesyncController.pick = nil
            end
            DesyncController.offsets = spots
            DesyncController.fallback = DESYNC_FALLBACK[meleeSafe and 'melee' or desyncArm]
            if not DesyncController.active or DesyncController.startTarget ~= targetPlayer then
                DesyncController.offset = spots[1]
                DesyncController:Start(targetPlayer)
            end
            local ready = (DesyncController.startedAt or 0) + 0.1 - os.clock()
            if ready > 0 then
                task.wait(ready)
            end
        end

        local character = targetPlayer.Character
        local stillTarget = pinned or TargetController.target == targetPlayer
        local retargeted = false
        if not self.active then
            env.RivalsStats:Skip('noTarget')
            self:ArmCleanup()
            return
        end
        if not stillTarget or not character or not character:FindFirstChild('Head') or not TargetController:IsShootable(targetPlayer, true) then
            local other = TargetController.target
            local otherCharacter = other and other.Character
            if other and otherCharacter and otherCharacter:FindFirstChild('Head') and TargetController:IsShootable(other, true) then
                targetPlayer, character, retargeted = other, otherCharacter, true
                local _, _, _, otherPoint = TargetController:Judge(other)
                seenPoint = otherPoint
                direct = true
                reachArm = nil
                escape = false
                desyncArm = 'none'
                if DesyncController.active then
                    DesyncController:Stop()
                end
            else
                env.RivalsStats:Skip('noTarget')
                self:ArmCleanup()
                return
            end
        end

        env.RivalsStats:CheckPayload(cameraData)

        local targetHead = character.Head

        local targetRoot = character:FindFirstChild('HumanoidRootPart')
        local pointArm = choose('point')

        local originArm
        if retargeted then
            originArm = 'camera'
        elseif direct and (reachArm == 'move' or escape) then
            originArm = 'shooter'
        elseif direct then
            originArm = choose('direct')
        else
            originArm = choose('origin')
        end
        local shootingPos = shotOrigin(originArm, targetHead, targetRoot)
        local targetState = env.RivalsTargetState
        local block = targetState:Blocked(targetPlayer, shootingPos, weaponName)
        local flank, control = nil, nil
        if block then
            targetState.blocked += 1
            if block ~= 'deflect' and env.RivalsTuner.random() < targetState.BLOCK_CONTROL then
                control = true
            else
                local alternative = flankOrigin(targetPlayer, targetHead, weaponName, shootingPos)
                if alternative then
                    shootingPos = alternative
                    flank = true
                end
            end
        end
        local fromCamera = direct and reachArm ~= 'move' and not escape
        local basePos = (fromCamera and not flank) and seenPoint or sightPoint(shootingPos, targetHead)
        local edge = (basePos - targetHead.Position).Magnitude > 0.01
        local hitPos, markPos = aimPoint(pointArm, basePos, targetHead, targetRoot, env.RivalsStats:Ping())
        local partArm = choose('hitpart')
        local hitPart = targetHead
        if partArm == 'hitbox' then
            local box = character:FindFirstChild(weaponName == 'Sniper' and 'HitboxHeadSmall' or 'HitboxHead')
            if box and box:IsA('BasePart') then
                hitPart = box
            else
                partArm = nil
            end
        elseif partArm ~= 'head' then
            partArm = nil
        end
        local shootingOffset = hitPart.CFrame:ToObjectSpace(CFrame.new(markPos))

        local facingArm = choose('facing')
        local aimOffset = hitPos - shootingPos
        if facingArm == 'look' and aimOffset.Magnitude > 0.01 then
            cameraData[utf8.char(0)] = Utility:EncodeCFrame(CFrame.lookAt(shootingPos, hitPos))
            cameraData[utf8.char(1)] = Utility:EncodeCFrame(CFrame.lookAt(hitPos, hitPos + aimOffset))
        else
            cameraData[utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(shootingPos, hitPos) * CFrame.Angles(CFrame.lookAt(shootingPos, hitPos):ToOrientation()))
            cameraData[utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(hitPos) * CFrame.Angles(CFrame.lookAt(shootingPos, hitPos):ToOrientation()))
        end
        cameraData[utf8.char(2)] = hitPart
        cameraData[utf8.char(3)] = Utility:EncodeCFrame(shootingOffset)

        local moved, exact = nil, nil
        if desyncArm ~= 'none' then
            moved = DesyncController.active == true and DesyncController.placed ~= nil
            exact = (moved and DesyncController.placedExact == true) or nil
        end
        local arms = { point = pointArm, facing = facingArm, hitpart = partArm }
        if reachDim then
            arms[reachDim] = reachArm
        end
        if not direct then
            arms.origin = originArm
            arms.desync = desyncArm
        elseif not retargeted and reachArm ~= 'move' and not escape then
            arms.direct = originArm
        end
        if flank then
            arms.origin = nil
            arms.direct = nil
        end
        local weapon = type(controller) == 'table' and controller.Info or controller
        env.RivalsStats:Record(targetPlayer, { arms = arms, moved = moved, exact = exact, direct = direct or nil, visible = visible or nil, retargeted = retargeted or nil, edge = edge or nil, weapon = weapon, gun = type(weapon) == 'table' and weapon ~= controller and weapon or nil, weaponName = weaponName ~= nil and tostring(weaponName) or nil, silent = silent or nil, meleeSafe = meleeSafe or nil, escape = escape or nil, invincible = targetState:IsInvincible(targetPlayer) or nil, block = block, flank = flank, control = control, window = window })

        self:ArmCleanup()
    end

    function WallbangController:BodyShot(controller, cameraData, targetPlayer, part, point, weaponName, window)
        local camera = currentCamera()
        local origin = camera and camera.CFrame.Position or point
        local aimOffset = point - origin
        if aimOffset.Magnitude > 0.01 then
            if env.RivalsTuner:Best('facing') == 'look' then
                cameraData[utf8.char(0)] = Utility:EncodeCFrame(CFrame.lookAt(origin, point))
                cameraData[utf8.char(1)] = Utility:EncodeCFrame(CFrame.lookAt(point, point + aimOffset))
            else
                cameraData[utf8.char(0)] = Utility:EncodeCFrame(CFrame.new(origin, point) * CFrame.Angles(CFrame.lookAt(origin, point):ToOrientation()))
                cameraData[utf8.char(1)] = Utility:EncodeCFrame(CFrame.new(point) * CFrame.Angles(CFrame.lookAt(origin, point):ToOrientation()))
            end
        end
        cameraData[utf8.char(2)] = part
        cameraData[utf8.char(3)] = Utility:EncodeCFrame(part.CFrame:ToObjectSpace(CFrame.new(point)))
        local weapon = type(controller) == 'table' and controller.Info or controller
        env.RivalsStats:Record(targetPlayer, { direct = true, visible = true, silent = true, body = true, weapon = weapon, gun = type(weapon) == 'table' and weapon ~= controller and weapon or nil, weaponName = weaponName ~= nil and tostring(weaponName) or nil, window = window })
    end

    function WallbangController:Stop()
        self.active = false
        if GunItem and self.startShootingRef then
            GunItem.StartShooting = self.startShootingRef
        end
        if self.desyncCleanup then
            task.cancel(self.desyncCleanup)
            self.desyncCleanup = nil
        end
    end

    WallbangController:init()
end
env.RivalsAimUnload = function()
    if env.RivalsTuner and env.RivalsTuner.Save then
        env.RivalsTuner:Save()
    end
    if env.TargetController then env.TargetController:Stop() end
    if env.DesyncController then env.DesyncController:Stop() end
    if env.WallbangController then env.WallbangController:Stop() end

    if env.RivalsStats and env.RivalsStats.connection then
        env.RivalsStats.connection:Disconnect()
        env.RivalsStats.connection = nil
    end
    if env.RivalsBounds and env.RivalsBounds.connection then
        env.RivalsBounds.connection:Disconnect()
        env.RivalsBounds.connection = nil
    end
    if env.RivalsSafety then
        for _, connection in ipairs(env.RivalsSafety.connections) do
            connection:Disconnect()
        end
        env.RivalsSafety.connections = {}
    end
    pcall(function()
        RunService:UnbindFromRenderStep('RivalsSafetyTrack')
    end)

    if inputWrapper and clientItemModule and clientItemModule.Input == inputWrapper then
        clientItemModule.Input = originalInput
    end
    for info, saved in pairs(savedInfo) do
        for key, value in pairs(saved) do
            info[key] = value or nil
        end
    end
end

do
    note('StartShooting 후킹', GunItem ~= nil and type(env.WallbangController.startShootingRef) == 'function' and GunItem.StartShooting ~= env.WallbangController.startShootingRef)
    note('Input 후킹', originalInput ~= nil and clientItemModule.Input ~= originalInput)

    local problems = {}
    for _, item in ipairs(Check.items) do
        if not item.ok then
            table.insert(problems, item.name .. (item.detail and (' (' .. item.detail .. ')') or ''))
        end
    end
    if #problems == 0 then
    else
    end
end

end)

run("esp", function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local env = getgenv and getgenv() or _G
local cfg = env.RivalsCfg

if env.RivalsEspUnload then
	pcall(env.RivalsEspUnload)
end
local connections = {}

local VISIBLE_COLOR = Color3.fromRGB(0, 255, 0)
local OCCLUDED_COLOR = Color3.fromRGB(30, 120, 255)

local BAR_FULL_COLOR = Color3.fromRGB(0, 255, 0)
local BAR_EMPTY_COLOR = Color3.fromRGB(255, 0, 0)

local tracked = {}

local function isEnemy(targetPlayer)
	if targetPlayer:GetAttribute("EnvironmentID") ~= player:GetAttribute("EnvironmentID") then
		return false
	end
	return targetPlayer:GetAttribute("TeamID") ~= player:GetAttribute("TeamID")
end

local function createHighlight(char)
	local old = char:FindFirstChild("EspHighlight")
	if old then old:Destroy() end

	local highlight = Instance.new("Highlight")
	highlight.Name = "EspHighlight"
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillTransparency = 1
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = VISIBLE_COLOR
	highlight.Enabled = false
	highlight.Parent = char

	return highlight
end

local function createHealthBar(char, humanoid)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if not hrp then return nil end

	local old = hrp:FindFirstChild("EspHealthBar")
	if old then old:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "EspHealthBar"
	billboard.Adornee = hrp
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0.35, 0, 5.5, 0)
	billboard.StudsOffset = Vector3.new(-2.2, 0, 0)
	billboard.LightInfluence = 0
	billboard.Enabled = false
	billboard.Parent = hrp

	local background = Instance.new("Frame")
	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	background.BorderSizePixel = 1
	background.BorderColor3 = Color3.fromRGB(0, 0, 0)
	background.Parent = billboard

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.AnchorPoint = Vector2.new(0, 1)
	fill.Position = UDim2.new(0, 0, 1, 0)
	fill.Size = UDim2.new(1, 0, 1, 0)
	fill.BackgroundColor3 = BAR_FULL_COLOR
	fill.BorderSizePixel = 0
	fill.Parent = background

	local function updateBar()
		local ratio = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
		fill.Size = UDim2.new(1, 0, ratio, 0)
		fill.BackgroundColor3 = BAR_EMPTY_COLOR:Lerp(BAR_FULL_COLOR, ratio)
	end

	updateBar()
	humanoid.HealthChanged:Connect(updateBar)

	return billboard
end

local function hookCharacter(targetPlayer, char)
	local highlight = createHighlight(char)
	local humanoid = char:WaitForChild("Humanoid", 5)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	local bar = humanoid and createHealthBar(char, humanoid)

	if targetPlayer.Character ~= char then return end

	if hrp then
		tracked[targetPlayer] = { highlight = highlight, bar = bar, hrp = hrp, humanoid = humanoid, char = char }
	end
end

local function onPlayerAdded(targetPlayer)
	if targetPlayer == player then return end

	if targetPlayer.Character then
		task.spawn(hookCharacter, targetPlayer, targetPlayer.Character)
	end
	table.insert(connections, targetPlayer.CharacterAdded:Connect(function(char)
		hookCharacter(targetPlayer, char)
	end))
end

for _, targetPlayer in ipairs(Players:GetPlayers()) do
	onPlayerAdded(targetPlayer)
end
table.insert(connections, Players.PlayerAdded:Connect(onPlayerAdded))

table.insert(connections, Players.PlayerRemoving:Connect(function(targetPlayer)
	tracked[targetPlayer] = nil
end))

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true
rayParams.RespectCanCollide = true

local function buildFilter(camera)
	local filter = { camera }
	local myChar = player.Character
	if myChar then table.insert(filter, myChar) end
	for _, other in ipairs(Players:GetPlayers()) do
		local otherChar = other.Character
		if otherChar and otherChar ~= myChar then
			table.insert(filter, otherChar)
		end
	end
	return filter
end

local function canSee(origin, part)
	if not part then return false end
	return workspace:Raycast(origin, part.Position - origin, rayParams) == nil
end

local heartbeat = RunService.Heartbeat:Connect(function()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local origin = camera.CFrame.Position
	local espOn = not cfg or cfg.esp ~= false

	if espOn and next(tracked) ~= nil then
		rayParams.FilterDescendantsInstances = buildFilter(camera)
	end

	for targetPlayer, data in pairs(tracked) do
		local alive = data.humanoid ~= nil and data.humanoid.Health > 0
		local show = espOn and alive and data.hrp.Parent ~= nil and isEnemy(targetPlayer)

		data.highlight.Enabled = show
		if data.bar then data.bar.Enabled = show end

		if show then
			local visible = canSee(origin, data.char:FindFirstChild("Head")) or canSee(origin, data.hrp)
			data.highlight.OutlineColor = visible and VISIBLE_COLOR or OCCLUDED_COLOR
		end
	end
end)
table.insert(connections, heartbeat)

env.RivalsEspUnload = function()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	for _, data in pairs(tracked) do
		if data.highlight then data.highlight:Destroy() end
		if data.bar then data.bar:Destroy() end
	end
	table.clear(tracked)
end

end)

run("autofire", function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local env = getgenv()
local cfg = env.RivalsCfg or {}

local LocalPlayer = Players.LocalPlayer

env.RivalsFire = { presses = 0, firstPress = nil, clock = os.clock }

if env.RivalsAutoFireUnload then
	pcall(env.RivalsAutoFireUnload)
	env.RivalsAutoFireUnload = nil
end

local SWITCH_PAUSE = 0.6
local FOCUS_GRACE = 0.3
local CAPTURE_GRACE = 0.2
local SPAWN_GRACE = 0.5
local HINT_AFTER = 20
local NOSHOT_AFTER = 0.5
local BACKOFF = 0.6

local virtualInput
pcall(function()
	virtualInput = game:GetService("VirtualInputManager")
end)

local conns = {}
local unloaded = false

local useOs = type(mouse1press) == "function" and type(mouse1release) == "function"
local held = false

local function setHeld(state)
	if held == state then return end

	local ok = pcall(function()
		if useOs then
			if state then mouse1press() else mouse1release() end
		elseif virtualInput then
			local pos = UserInputService:GetMouseLocation()
			virtualInput:SendMouseButtonEvent(pos.X, pos.Y, 0, state, game, 0)
		end
	end)

	if ok then
		held = state
		if state then
			local fire = env.RivalsFire
			if fire then
				fire.presses += 1
				fire.firstPress = fire.firstPress or fire.clock()
				fire.lastPress = fire.clock()
			end
		end
	end
end

local function isAlive(character)
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

local function isEnemy(targetPlayer)
	if targetPlayer:GetAttribute("EnvironmentID") ~= LocalPlayer:GetAttribute("EnvironmentID") then
		return false
	end
	return targetPlayer:GetAttribute("TeamID") ~= LocalPlayer:GetAttribute("TeamID")
end

local function ownerOf(part)
	local node = part
	while node and node ~= Workspace do
		local owner = Players:GetPlayerFromCharacter(node)
		if owner then return owner end
		node = node.Parent
	end
	return nil
end

local function rageWantsFire()
	if not cfg.autoFire or not (cfg.rage or cfg.silent) then return false end
	local wallbang = env.WallbangController
	if not (wallbang and wallbang.active) then return false end
	local controller = env.TargetController
	if controller == nil or controller.active == false or controller.target == nil then return false end
	if cfg.rage then
		return controller.targetVisible ~= false or controller.targetInRange ~= false
	end
	if controller.targetVisible == true then return true end
	return controller.VisibleBodyEnemy ~= nil and controller:VisibleBodyEnemy() ~= nil
end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local TRIGGER_SPREAD = 0.006
local TRIGGER_HOLD = 0.08
local TRIGGER_POINTS = {
	{ 0, 0 }, { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 },
	{ 0.7, 0.7 }, { -0.7, 0.7 }, { 0.7, -0.7 }, { -0.7, -0.7 },
}
local triggerUntil = 0
env.RivalsTrigger = { hits = 0, held = 0, spread = 0, blocked = 0 }

local function enemyUnder(camera, x, y)
	local ray = camera:ViewportPointToRay(x, y)
	local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, rayParams)
	if not hit then return false end
	local owner = ownerOf(hit.Instance)
	if owner == nil or not isEnemy(owner) or not isAlive(owner.Character) then return false end
	local targetState = env.RivalsTargetState
	if targetState and targetState:Unshootable(owner) then return false end
	if not (cfg.rage or cfg.silent) and targetState and targetState.Blocked and targetState:Blocked(owner, ray.Origin) then
		local stats = env.RivalsTrigger
		if stats then stats.blocked += 1 end
		return false
	end
	return true
end

local function triggerWantsFire()
	if not cfg.triggerbot then return false end

	local camera = Workspace.CurrentCamera
	if not camera then return false end

	local filter = { camera }
	if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
	for _, player in ipairs(Players:GetPlayers()) do
		local character = player ~= LocalPlayer and player.Character
		if character then
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("Accessory") then table.insert(filter, child) end
			end
		end
	end
	rayParams.FilterDescendantsInstances = filter

	local mouse = UserInputService:GetMouseLocation()
	local height = 1080
	pcall(function()
		height = camera.ViewportSize.Y
	end)
	local radius = math.max(3, (tonumber(height) or 1080) * TRIGGER_SPREAD)
	local stats = env.RivalsTrigger
	for index, point in ipairs(TRIGGER_POINTS) do
		if enemyUnder(camera, mouse.X + point[1] * radius, mouse.Y + point[2] * radius) then
			triggerUntil = os.clock() + TRIGGER_HOLD
			if stats then
				stats.hits += 1
				if index > 1 then stats.spread += 1 end
			end
			return true
		end
	end
	if os.clock() < triggerUntil then
		if stats then stats.held += 1 end
		return true
	end
	return false
end

local pauseUntil = 0

local function pauseFor(seconds)
	local untilAt = os.clock() + seconds
	if untilAt > pauseUntil then pauseUntil = untilAt end
end

local switchKeys = {}
for _, name in ipairs({
	"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero",
	"Q", "E", "F", "G", "Tab",
	"DPadUp", "DPadDown", "DPadLeft", "DPadRight", "ButtonY",
}) do
	local ok, key = pcall(function() return Enum.KeyCode[name] end)
	if ok and key then switchKeys[key] = true end
end

local function onSwitchInput()
	if unloaded then return end
	pauseFor(SWITCH_PAUSE)
	setHeld(false)
end

table.insert(conns, UserInputService.InputBegan:Connect(function(input)
	if switchKeys[input.KeyCode] then onSwitchInput() end
end))

table.insert(conns, UserInputService.InputEnded:Connect(function(input)
	if switchKeys[input.KeyCode] then pauseFor(0.25) end
end))

table.insert(conns, UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseWheel then onSwitchInput() end
end))

local focusFn
if type(isrbxactive) == "function" then
	focusFn = isrbxactive
elseif type(iswindowactive) == "function" then
	focusFn = iswindowactive
end

local focusFlag = true

table.insert(conns, UserInputService.WindowFocused:Connect(function()
	focusFlag = true
end))
table.insert(conns, UserInputService.WindowFocusReleased:Connect(function()
	focusFlag = false
	setHeld(false)
end))

local function isFocused()
	if focusFn then
		local ok, value = pcall(focusFn)
		if ok then return value ~= false end
	end
	return focusFlag
end

table.insert(conns, LocalPlayer.CharacterAdded:Connect(function()
	pauseFor(SPAWN_GRACE)
end))

local blockedTime = 0
local hinted = false
local wasCaptured = false
local wasFocused = true
local wasMenu = false
local lastTick = os.clock()

local seenShot = env.RivalsLastShotAt
local hookAlive = false
local trainStart = nil
local backoffUntil = 0

local function tick()
	cfg = env.RivalsCfg or cfg
	local now = os.clock()
	local dt = math.min(now - lastTick, 0.1)
	lastTick = now

	local focused = isFocused()
	if focused and not wasFocused then pauseFor(FOCUS_GRACE) end
	wasFocused = focused

	local captured = UserInputService.MouseBehavior ~= Enum.MouseBehavior.Default
	if captured and not wasCaptured then pauseFor(CAPTURE_GRACE) end
	wasCaptured = captured
	if captured then
		blockedTime = 0
	end

	local menuOpen = false
	pcall(function() menuOpen = GuiService.MenuIsOpen == true end)

	local anyMenu = menuOpen or cfg.menuOpen == true
	if wasMenu and not anyMenu then pauseFor(FOCUS_GRACE) end
	wasMenu = anyMenu

	local usable = focused
		and not menuOpen
		and not cfg.menuOpen
		and UserInputService:GetFocusedTextBox() == nil
		and isAlive(LocalPlayer.Character)
		and now >= pauseUntil
		and now >= backoffUntil

	if not usable then
		setHeld(false)
		trainStart = nil
		return
	end

	if not (rageWantsFire() or triggerWantsFire()) then
		setHeld(false)
		trainStart = nil
		return
	end

	if not captured then
		blockedTime += dt
		if blockedTime >= HINT_AFTER and not hinted then
			hinted = true
		end
		setHeld(false)
		trainStart = nil
		return
	end

	local lastShot = env.RivalsLastShotAt
	if lastShot ~= seenShot then
		seenShot = lastShot
		hookAlive = true
		trainStart = nil
	end
	if hookAlive then
		if not trainStart then
			trainStart = now
		elseif now - trainStart > NOSHOT_AFTER then
			backoffUntil = now + BACKOFF
			trainStart = nil
			setHeld(false)
			return
		end
	end

	setHeld(not held)
end

table.insert(conns, RunService.Heartbeat:Connect(function()
	if unloaded then return end
	local ok = pcall(tick)
	if not ok then setHeld(false) end
end))

local function unload()
	if unloaded then return end
	unloaded = true
	for _, conn in ipairs(conns) do
		pcall(function() conn:Disconnect() end)
	end
	table.clear(conns)
	setHeld(false)
	if env.RivalsAutoFireUnload == unload then
		env.RivalsAutoFireUnload = nil
	end
end

env.RivalsAutoFireUnload = unload

end)

run("antiaim", function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local env = getgenv()
local cfg = env.RivalsCfg or {}

local player = Players.LocalPlayer

local LEVELS = {
	{ spin = math.rad(1440), side = 4, upMin = 1, upMax = 4, farChance = 0, farMin = 0, farMax = 0 },
	{ spin = math.rad(2880), side = 6, upMin = 2, upMax = 8, farChance = 0.3, farMin = 8, farMax = 18 },
	{ spin = math.rad(6840), side = 10, upMin = 2, upMax = 12, farChance = 0.7, farMin = 15, farMax = 32 },
	{ spin = math.rad(6840), side = 10, upMin = 2, upMax = 12, farChance = 0.7, farMin = 15, farMax = 32, sink = true, tumble = true },
}
local JITTER_RANGE = 80
local JITTER_GROUND = 24
local RESTORE_NAME = "RivalsAntiAimRestore"
local TELEPORT_GAP = 70
local PULL_GAP = 4
local FLING_SPEED = 200
local PAUSE_AFTER = 0.5
local SHOT_HOLD = 0.4
local MELEE_NEAR = 18
local MELEE_SAFE = 14
local SINK_RANGE = 300
local SINK_MIN = 4
local SINK_MAX = 6
local KILL_RADIUS = 3
local DODGE_TURNS = { 0, math.rad(40), -math.rad(40), math.rad(80), -math.rad(80) }

local function shooting()
	local now = os.clock()
	local shotAt = env.RivalsShotAt
	if shotAt and now >= shotAt and now - shotAt < SHOT_HOLD then return true end
	local fire = env.RivalsFire
	local pressAt = fire and fire.lastPress
	return pressAt ~= nil and now >= pressAt and now - pressAt < SHOT_HOLD
end

local function currentLevel()
	local index = math.floor(tonumber(cfg.antiAimLevel) or 1)
	return LEVELS[math.max(1, math.min(#LEVELS, index))]
end

local lineParams = RaycastParams.new()
lineParams.FilterType = Enum.RaycastFilterType.Exclude
lineParams.IgnoreWater = true
lineParams.RespectCanCollide = true

local zoneParams = OverlapParams.new()
zoneParams.FilterType = Enum.RaycastFilterType.Exclude

local function hasTag(part, tag)
	return part:HasTag(tag)
end

local function inKillZone(spot, character)
	zoneParams.FilterDescendantsInstances = { character }
	local ok, parts = pcall(function()
		return Workspace:GetPartBoundsInRadius(spot, KILL_RADIUS, zoneParams)
	end)
	if not ok then return true end
	for _, part in ipairs(parts or {}) do
		if part.Name == "Barriers" or hasTag(part, "OutOfBoundsPart") or hasTag(part, "KillBrick") then
			return true
		end
	end
	return false
end

local function sinkShift(character, base)
	lineParams.FilterDescendantsInstances = { character }
	local floor = Workspace:Raycast(base, Vector3.new(0, -JITTER_GROUND, 0), lineParams)
	if not floor or not floor.Position then return nil end
	local depth = SINK_MIN + math.random() * (SINK_MAX - SINK_MIN)
	local spot = Vector3.new(base.X, floor.Position.Y - depth, base.Z)
	if not (spot.Y >= Workspace.FallenPartsDestroyHeight + 50) then return nil end
	if inKillZone(spot, character) then return nil end
	return spot - base
end

local function spotOk(desync, bounds, root, character, base, shift)
	local spot = base + shift
	if bounds and not bounds:Allows(spot) then return false end
	lineParams.FilterDescendantsInstances = { character }
	if Workspace:Raycast(base + Vector3.new(0, 2, 0), shift, lineParams) then return false end
	if not Workspace:Raycast(spot, Vector3.new(0, -JITTER_GROUND, 0), lineParams) then return false end
	return desync:IsSafe(spot, root)
end

if env.RivalsAntiAimUnload then
	pcall(env.RivalsAntiAimUnload)
end

local saved = nil
local angle = 0
local pausedUntil = 0
local recentEvents = {}
local lastWarn = -math.huge
local threatNow = nil

env.RivalsAntiAimStats = { threats = 0, meleeTime = 0, dodgeTime = 0, shieldTime = 0, sinkTime = 0 }
env.RivalsAntiAimMoved = false
local counters = env.RivalsAntiAimStats

local function levelPoint(position, point)
	local flat = Vector3.new(point.X, position.Y, point.Z)
	if (flat - position).Magnitude < 0.05 then return nil end
	return flat
end

local function ownShield()
	local targetState = env.RivalsTargetState
	if not targetState or not targetState.Read then return nil end
	local state = targetState:Read(player)
	if not state then return nil end
	if state.riotFront then return "front" end
	if state.riotBack then return "back" end
	return nil
end

local function dodgeShifts(base, threatPos, up)
	local away = Vector3.new(base.X - threatPos.X, 0, base.Z - threatPos.Z)
	local gap = away.Magnitude
	local ax, az = 1, 0
	if gap > 0.05 then
		ax, az = away.X / gap, away.Z / gap
	end
	local shifts = {}
	for _, turn in ipairs(DODGE_TURNS) do
		local c, s = math.cos(turn), math.sin(turn)
		local dx, dz = ax * c - az * s, ax * s + az * c
		local along = away.X * dx + away.Z * dz
		local length = math.max(0, -along + math.sqrt(math.max(0, along * along - gap * gap + MELEE_SAFE * MELEE_SAFE)))
		table.insert(shifts, Vector3.new(dx * length, up, dz * length))
	end
	local rise = math.sqrt(math.max(0, MELEE_SAFE * MELEE_SAFE - gap * gap)) - (base.Y - threatPos.Y)
	if rise < JITTER_GROUND - 4 then
		table.insert(shifts, Vector3.new(0, math.max(up, rise), 0))
	end
	return shifts
end

local function onAnomaly(kind, amount)
	if env.RivalsEvent then
		env.RivalsEvent("안티에임 이상", kind .. " " .. string.format("%.1f", amount))
	end
	local safety = env.RivalsSafety
	local now = safety and safety.clock() or os.clock()
	pausedUntil = now + PAUSE_AFTER
	if safety then
		if kind == "pull" then
			safety.jitterPulls = (safety.jitterPulls or 0) + 1
		else
			safety.jitterFlings = (safety.jitterFlings or 0) + 1
		end
		safety.jitterScale = math.max(0.25, (safety.jitterScale or 1) * 0.6)
		safety.lastRecover = now
	end
	table.insert(recentEvents, now)
	while #recentEvents > 0 and now - recentEvents[1] > 30 do
		table.remove(recentEvents, 1)
	end
	if #recentEvents >= 5 and cfg.antiAimJitter then
		cfg.antiAimJitter = false
	elseif now - lastWarn > 10 then
		lastWarn = now
		local what = kind == "pull" and string.format("몸이 %.1f스터드 끌려갔다", amount) or string.format("속도가 %.0f 튀었다", amount)
	end
end

local function restore()
	if not saved then return end
	local current = saved
	saved = nil

	local root = current.root
	local anomaly, amount = nil, 0
	if root.Parent and current.displaced then
		local pulled = (root.CFrame.Position - current.displaced).Magnitude
		if pulled > PULL_GAP and pulled <= TELEPORT_GAP then
			anomaly, amount = "pull", pulled
		end
		if current.linear then
			local jump = (root.AssemblyLinearVelocity - current.linear).Magnitude
			if jump > FLING_SPEED then
				root.AssemblyLinearVelocity = current.linear
				anomaly, amount = "speed", jump
			end
		end
	end
	local teleported = root.Parent ~= nil and (root.CFrame.Position - current.cframe.Position).Magnitude > TELEPORT_GAP
	if root.Parent then
		if not teleported then
			root.CFrame = current.cframe
		end
		root.AssemblyAngularVelocity = current.angular
	end
	if anomaly then
		onAnomaly(anomaly, amount)
	end
end

local heartbeat = RunService.Heartbeat:Connect(function(dt)
	env.RivalsAntiAimMoved = false
	env.RivalsAntiAimFrameAt = os.clock()
	if not cfg.antiAim then return end
	local spin = cfg.antiAimSpin
	local jitter = cfg.antiAimJitter
	if not spin and not jitter then return end

	local desync = env.DesyncController
	if desync and desync.active then return end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return end

	restore()

	local step = dt or 1 / 60
	local level = currentLevel()
	local holding = shooting()
	saved = { root = root, cframe = root.CFrame, angular = root.AssemblyAngularVelocity, linear = root.AssemblyLinearVelocity }
	local position = saved.cframe.Position
	local controller = env.TargetController
	local safety = env.RivalsSafety

	local threat, threatDistance, threatRoot = nil, nil, nil
	if controller and controller.NearestMeleeThreat then
		threat, threatDistance, threatRoot = controller:NearestMeleeThreat(MELEE_NEAR)
	end
	if threat ~= threatNow then
		threatNow = threat
		if threat then
			counters.threats += 1
			if env.RivalsEvent then
				env.RivalsEvent("근접 위협", string.format("%s %.0f스터드", threat.Name, threatDistance))
			end
		end
	end
	if threat and safety then safety.lastMelee = safety.clock() end
	local reacted = false

	if spin then
		local face = nil
		if threat then
			face = levelPoint(position, threatRoot.Position)
			reacted = face ~= nil
		else
			local shield = ownShield()
			local enemyRoot = nil
			if shield and controller and controller.NearestEnemy then
				enemyRoot = select(3, controller:NearestEnemy())
			end
			if enemyRoot then
				local toward = shield == "front" and enemyRoot.Position or position + (position - enemyRoot.Position)
				face = levelPoint(position, toward)
				if face then counters.shieldTime += step end
			end
		end
		if face then
			root.CFrame = CFrame.lookAt(position, face)
		elseif level.tumble then
			root.CFrame = CFrame.new(position) * CFrame.Angles(math.random() * 2 * math.pi, math.random() * 2 * math.pi, math.random() * 2 * math.pi)
			root.AssemblyAngularVelocity = Vector3.new(0, level.spin, 0)
			if safety then safety.lastSpin = safety.clock() end
		else
			angle = (angle + level.spin * step) % (2 * math.pi)
			root.CFrame = CFrame.new(position) * CFrame.Angles(0, angle, 0)
			root.AssemblyAngularVelocity = Vector3.new(0, level.spin, 0)
			if safety then safety.lastSpin = safety.clock() end
		end
	end

	if jitter and not holding then
		local now = safety and safety.clock() or os.clock()
		if now >= pausedUntil and desync and desync.IsSafe then
			local bounds = env.RivalsBounds
			if threat then
				for _, shift in ipairs(dodgeShifts(position, threatRoot.Position, level.upMin)) do
					if spotOk(desync, bounds, root, character, position, shift) then
						root.CFrame = root.CFrame + shift
						env.RivalsAntiAimMoved = true
						counters.dodgeTime += step
						reacted = true
						if safety then safety.lastJitter = safety.clock() end
						break
					end
				end
			else
				local distance = controller and controller.NearestEnemyDistance and controller:NearestEnemyDistance()
				local sunk = level.sink and distance ~= nil and distance <= SINK_RANGE and sinkShift(character, position)
				if sunk then
					root.CFrame = root.CFrame + sunk
					env.RivalsAntiAimMoved = true
					counters.sinkTime += step
					if safety then safety.lastJitter = safety.clock() end
				elseif distance and distance <= JITTER_RANGE then
					local scale = safety and safety.jitterScale or 1
					local up = level.upMin + math.random() * (level.upMax - level.upMin) * scale
					local candidates = {}
					if bounds and scale >= 0.5 and level.farChance > 0 and math.random() < level.farChance then
						local angle = math.random() * 2 * math.pi
						local radius = (level.farMin + math.random() * (level.farMax - level.farMin)) * scale
						table.insert(candidates, Vector3.new(math.cos(angle) * radius, up, math.sin(angle) * radius))
					end
					table.insert(candidates, Vector3.new((math.random() * 2 - 1) * level.side * scale, up, (math.random() * 2 - 1) * level.side * scale))
					table.insert(candidates, Vector3.new(0, 2, 0))
					local shift = nil
					for _, candidate in ipairs(candidates) do
						if spotOk(desync, bounds, root, character, position, candidate) then
							shift = candidate
							break
						end
					end
					if shift then
						root.CFrame = root.CFrame + shift
						env.RivalsAntiAimMoved = true
						if safety then safety.lastJitter = safety.clock() end
					end
				end
			end
		end
	end
	if reacted then counters.meleeTime += step end

	if saved then
		saved.displaced = root.CFrame.Position
	end
end)

pcall(function()
	RunService:UnbindFromRenderStep(RESTORE_NAME)
end)
if not pcall(function()
	RunService:BindToRenderStep(RESTORE_NAME, Enum.RenderPriority.First.Value, restore)
end) then
	heartbeat:Disconnect()
	return
end

env.RivalsAntiAimUnload = function()
	heartbeat:Disconnect()
	env.RivalsAntiAimMoved = false
	pcall(function()
		RunService:UnbindFromRenderStep(RESTORE_NAME)
	end)
	restore()
end

end)

run("menu", function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local env = getgenv()
local cfg = env.RivalsCfg
if not cfg then
	return
end

if env.RivalsMenuUnload then
	pcall(env.RivalsMenuUnload)
end

local TOGGLE_KEY = Enum.KeyCode.RightShift
local UNLOAD_KEY = Enum.KeyCode.End
local SETTINGS_FILE = "rivals_settings.json"
local LAYOUT = 2
local S = 0.66
local DESIGN_W, DESIGN_H = 834, 1194
local SCREEN_W, SCREEN_H = DESIGN_W * S, DESIGN_H * S
local BEZEL = 20 * S
local BASE_W, BASE_H = SCREEN_W + 2 * BEZEL, SCREEN_H + 2 * BEZEL
local SCREEN_RADIUS = 38 * S
local MIN_SCALE, MAX_SCALE = 0.5, 2
local SAVE_AFTER = 0.6

local FEATURE_KEYS = { "rage", "silent", "autoFire", "triggerbot", "noRecoil", "noSpread", "rapidFire", "antiAim", "antiAimSpin", "antiAimJitter", "esp" }
local DEFAULT_FEATURES = {
	rage = true, silent = true, autoFire = true, triggerbot = true, noRecoil = true, noSpread = true, rapidFire = true,
	antiAim = true, antiAimSpin = true, antiAimJitter = true, esp = true, antiAimLevel = 1,
}

local HINT = "RightShift 메뉴 열기/닫기  ·  End 전부 끄기"

local rgb = Color3.fromRGB
local C = {
	black = rgb(0, 0, 0),
	white = rgb(255, 255, 255),
	bezel = rgb(5, 5, 6),
	bezelEdge = rgb(58, 58, 61),
	camera = rgb(22, 23, 28),
	appTop = rgb(28, 28, 34),
	appBottom = rgb(7, 7, 8),
	cover = rgb(34, 34, 40),
	ink = rgb(28, 28, 30),
	grouped = rgb(242, 242, 247),
	tile = rgb(242, 242, 247),
	edge = rgb(222, 222, 228),
	off = rgb(229, 229, 234),
	coral = rgb(255, 59, 48),
	today = rgb(255, 59, 48),
	pin = rgb(255, 159, 10),
	gray = rgb(142, 142, 147),
	fill = rgb(120, 120, 128),
	chip = rgb(99, 99, 102),
	orange = rgb(255, 159, 10),
	green = rgb(48, 209, 88),
	teal = rgb(100, 210, 255),
	blue = rgb(10, 132, 255),
	indigo = rgb(94, 92, 230),
	purple = rgb(191, 90, 242),
	red = rgb(255, 69, 58),
	pink = rgb(255, 55, 95),
}
local SECONDARY = 0.38

local function fontOf(name, fallback)
	local ok, font = pcall(function() return Enum.Font[name] end)
	return ok and font or fallback
end
local FONT = fontOf("BuilderSans", Enum.Font.Gotham)
local FONT_MEDIUM = fontOf("BuilderSansMedium", Enum.Font.GothamMedium)
local FONT_BOLD = fontOf("BuilderSansBold", Enum.Font.GothamBold)
local THIN = nil
pcall(function()
	THIN = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Light)
end)

local function finite(value)
	return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function sanitize(raw)
	local out = { features = {}, window = {}, pet = {} }
	if type(raw) ~= "table" then return out end
	local features = raw.features
	if type(features) == "table" then
		for _, key in ipairs(FEATURE_KEYS) do
			if type(features[key]) == "boolean" then out.features[key] = features[key] end
		end
		if finite(features.antiAimLevel) and features.antiAimLevel >= 1 and features.antiAimLevel <= 4 then
			out.features.antiAimLevel = math.floor(features.antiAimLevel + 0.5)
		end
	end
	local window = raw.window
	if type(window) == "table" and window.layout == LAYOUT then
		if finite(window.x) and finite(window.y) then
			out.window.x = window.x
			out.window.y = window.y
		end
		if finite(window.scale) then
			out.window.scale = math.clamp(window.scale, MIN_SCALE, MAX_SCALE)
		end
	end
	local pet = raw.pet
	if type(pet) == "table" then
		if type(pet.show) == "boolean" then out.pet.show = pet.show end
		if type(pet.swear) == "boolean" then out.pet.swear = pet.swear end
		if finite(pet.chatter) and pet.chatter >= 1 and pet.chatter <= 3 then
			out.pet.chatter = math.floor(pet.chatter + 0.5)
		end
		if finite(pet.x) and finite(pet.y) then
			out.pet.x = pet.x
			out.pet.y = pet.y
		end
	end
	return out
end

local function readSettings()
	if type(readfile) ~= "function" or type(isfile) ~= "function" then return nil end
	local ok, raw = pcall(function()
		if not isfile(SETTINGS_FILE) then return nil end
		return HttpService:JSONDecode(readfile(SETTINGS_FILE))
	end)
	if ok and type(raw) == "table" then return raw end
	return nil
end

local saved = sanitize(readSettings())
for key, value in pairs(saved.features) do
	cfg[key] = value
end

local dirty, lastChange = false, 0
local function save()
	dirty = false
	if type(writefile) ~= "function" then return false end
	return (pcall(function()
		writefile(SETTINGS_FILE, HttpService:JSONEncode(saved))
	end))
end
local function touch()
	dirty = true
	lastChange = os.clock()
end

local ASSET_DATA = {
	icons = { "rivals_ui_icons_v1.png", table.concat({
		"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",
	}) },
}

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function decode64(data)
	local fast = (type(crypt) == "table" and crypt.base64decode) or (type(crypt) == "table" and crypt.base64 and crypt.base64.decode)
	if type(fast) == "function" then
		local ok, out = pcall(fast, data)
		if ok and type(out) == "string" and #out > 0 then return out end
	end
	local map = {}
	for index = 1, 64 do
		map[string.byte(B64, index)] = index - 1
	end
	local out, buffer, bits = {}, 0, 0
	for index = 1, #data do
		local value = map[string.byte(data, index)]
		if value then
			buffer = buffer * 64 + value
			bits += 6
			if bits >= 8 then
				bits -= 8
				local divisor = 2 ^ bits
				table.insert(out, string.char(math.floor(buffer / divisor) % 256))
				buffer = buffer % divisor
			end
		end
	end
	return table.concat(out)
end

local assets = {}
do
	local loader = getcustomasset or getsynasset
	if type(writefile) == "function" and type(loader) == "function" then
		for key, entry in pairs(ASSET_DATA) do
			local ok, id = pcall(function()
				if type(isfile) ~= "function" or not isfile(entry[1]) then
					writefile(entry[1], decode64(entry[2]))
				end
				return loader(entry[1])
			end)
			if ok and type(id) == "string" and id ~= "" then
				assets[key] = id
			end
		end
	end
end

local connections = {}

local function new(class, props, parent)
	local object = Instance.new(class)
	for key, value in pairs(props) do
		object[key] = value
	end
	if parent then object.Parent = parent end
	return object
end

local function corner(object, radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
end

local function round(object)
	return new("UICorner", { CornerRadius = UDim.new(1, 0) }, object)
end

local function stroke(object, color, thickness, transparency, inner)
	local edge = new("UIStroke", { Color = color, Thickness = thickness, Transparency = transparency or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, object)
	if inner then
		pcall(function()
			edge.BorderStrokePosition = Enum.BorderStrokePosition.Inner
		end)
	end
	return edge
end

local function fade(points)
	local keys = {}
	for _, point in ipairs(points) do
		table.insert(keys, NumberSequenceKeypoint.new(point[1], point[2]))
	end
	return NumberSequence.new(keys)
end

local function text(parent, props)
	local label = new("TextLabel", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Font = FONT, TextColor3 = C.ink, TextSize = 12, Text = "",
	}, parent)
	for key, value in pairs(props) do
		label[key] = value
	end
	return label
end

local function thin(label)
	if THIN then
		pcall(function()
			label.FontFace = THIN
		end)
	end
	return label
end

local function at(x, y)
	return UDim2.fromOffset(x * S, y * S)
end

local function px(w, h)
	return UDim2.fromOffset(w * S, h * S)
end

local Motion = { springs = {}, values = {} }
do
	local TAU = 2 * math.pi
	local connection = nil

	local function dampingRatio(bounce)
		if bounce >= 0 then return 1 - bounce end
		return 1 / (1 + bounce)
	end

	local function advance(x0, v0, omega, zeta, t)
		if zeta < 1 - 1e-4 then
			local a = zeta * omega
			local wd = omega * math.sqrt(1 - zeta * zeta)
			local e, c, s = math.exp(-a * t), math.cos(wd * t), math.sin(wd * t)
			return e * (x0 * c + (v0 + a * x0) / wd * s), e * (v0 * c - (omega * omega * x0 + a * v0) / wd * s)
		elseif zeta > 1 + 1e-4 then
			local r = math.sqrt(zeta * zeta - 1)
			local r1, r2 = -omega * (zeta - r), -omega * (zeta + r)
			local c2 = (v0 - r1 * x0) / (r2 - r1)
			local c1 = x0 - c2
			local e1, e2 = math.exp(r1 * t), math.exp(r2 * t)
			return c1 * e1 + c2 * e2, r1 * c1 * e1 + r2 * c2 * e2
		end
		local b = v0 + omega * x0
		local e = math.exp(-omega * t)
		return (x0 + b * t) * e, (v0 - omega * b * t) * e
	end

	function Motion.step(dt)
		local finished = {}
		for key, s in pairs(Motion.springs) do
			local d, v = advance(s.x - s.target, s.v, s.omega, s.zeta, dt or 1 / 60)
			s.x, s.v = s.target + d, v
			if math.abs(d) <= s.eps and math.abs(v) <= s.eps * 20 then
				table.insert(finished, key)
			else
				Motion.values[key] = s.x
				s.apply(s.x)
			end
		end
		for _, key in ipairs(finished) do
			local s = Motion.springs[key]
			Motion.springs[key] = nil
			Motion.values[key] = s.target
			s.apply(s.target)
			if s.done then s.done() end
		end
		if next(Motion.springs) == nil and connection then
			connection:Disconnect()
			connection = nil
		end
	end

	function Motion.spring(key, target, options, apply, done)
		local s = Motion.springs[key]
		if not s then
			local from = Motion.values[key]
			if from == nil then from = options.from end
			if from == nil then from = target end
			s = { x = from, v = 0 }
			Motion.springs[key] = s
		end
		s.target = target
		s.omega = TAU / (options.duration or 0.5)
		s.zeta = dampingRatio(options.bounce or 0)
		s.eps = options.eps or 0.002
		if options.velocity then s.v = options.velocity end
		s.apply, s.done = apply, done
		if not connection then
			connection = RunService.RenderStepped:Connect(Motion.step)
		end
	end

	function Motion.set(key, value, apply)
		Motion.springs[key] = nil
		Motion.values[key] = value
		apply(value)
	end

	function Motion.stop()
		if connection then
			connection:Disconnect()
			connection = nil
		end
		Motion.springs = {}
	end
end
env.RivalsMotion = Motion

local presses = {}

local function pressable(button, down, up)
	button.InputBegan:Connect(function(input)
		local kind = input.UserInputType
		if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
			presses[button] = up
			down()
		end
	end)
end

local function releasePresses()
	local list = presses
	presses = {}
	for _, up in pairs(list) do
		up()
	end
end

local function springy(button, scale, pressedScale)
	local key = {}
	local hovered = false
	local function apply(value)
		scale.Scale = value
	end
	Motion.set(key, 1, apply)
	pressable(button, function()
		Motion.spring(key, pressedScale or 0.9, { duration = 0.1 }, apply)
	end, function()
		Motion.spring(key, hovered and 1.04 or 1, { duration = 0.3, bounce = 0.25 }, apply)
	end)
	button.MouseEnter:Connect(function()
		hovered = true
		if not presses[button] then Motion.spring(key, 1.04, { duration = 0.18 }, apply) end
	end)
	button.MouseLeave:Connect(function()
		hovered = false
		if not presses[button] then Motion.spring(key, 1, { duration = 0.18 }, apply) end
	end)
end

local function rubberBand(offset, span)
	local sign = offset < 0 and -1 or 1
	return sign * (1 - 1 / (math.abs(offset) * 0.55 / span + 1)) * span
end

local function mount(screenGui)
	local mounted = false
	if gethui then
		mounted = pcall(function()
			screenGui.Parent = gethui()
		end) and screenGui.Parent ~= nil
	end
	if not mounted then
		mounted = pcall(function()
			screenGui.Parent = game:GetService("CoreGui")
		end)
	end
	if not mounted then
		screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end
end

local ui = {}
ui.gui = new("ScreenGui", { Name = "RivalsMenu", ResetOnSpawn = false, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
ui.modal = new("TextButton", { Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, Text = "", Modal = true }, ui.gui)
mount(ui.gui)

local setCursor
do
	local CURSOR_STEP = "RivalsMenuCursor"
	local savedIcon = nil

	local function forceCursor()
		UserInputService.MouseIconEnabled = true
	end

	function setCursor(show)
		if show then
			if savedIcon ~= nil then return end
			local ok, value = pcall(function()
				return UserInputService.MouseIconEnabled
			end)
			if not ok or type(value) ~= "boolean" then return end
			savedIcon = value
			pcall(function()
				RunService:BindToRenderStep(CURSOR_STEP, Enum.RenderPriority.Last.Value, forceCursor)
			end)
			pcall(forceCursor)
		elseif savedIcon ~= nil then
			pcall(function()
				RunService:UnbindFromRenderStep(CURSOR_STEP)
			end)
			local before = savedIcon
			savedIcon = nil
			pcall(function()
				UserInputService.MouseIconEnabled = before
			end)
		end
	end
end

local function viewport()
	local ok, width, height = pcall(function()
		local size = ui.gui.AbsoluteSize
		return size.X, size.Y
	end)
	if ok and type(width) == "number" and type(height) == "number" and width > 0 and height > 0 then
		return width, height
	end
	return 1280, 720
end

local win = { x = 0, y = 0, scale = 1 }
local visual = { edgeX = 0, edgeY = 0, lift = 0, pop = 1 }

local function placeContainer()
	if ui.container then
		ui.container.Position = UDim2.fromOffset(win.x + visual.edgeX, win.y + visual.edgeY + visual.lift)
	end
end

local function maxScale(width, height)
	return math.max(MIN_SCALE, math.min(MAX_SCALE, (width - 16) / BASE_W, (height - 16) / BASE_H))
end

local function applyWindow()
	local width, height = viewport()
	win.scale = math.clamp(win.scale, MIN_SCALE, maxScale(width, height))
	local w, h = BASE_W * win.scale, BASE_H * win.scale
	win.x = math.clamp(win.x, 0, math.max(0, width - w))
	win.y = math.clamp(win.y, 0, math.max(0, height - h))
	if ui.container then
		ui.container.Size = UDim2.fromOffset(w, h)
		ui.uiScale.Scale = win.scale * visual.pop
		ui.bezel.Position = UDim2.fromOffset(w * (1 - visual.pop) / 2, h * (1 - visual.pop) / 2)
	end
	placeContainer()
end

local function placeWindow(useSaved)
	local width, height = viewport()
	win.scale = math.clamp((useSaved and saved.window.scale) or 1, MIN_SCALE, maxScale(width, height))
	local w, h = BASE_W * win.scale, BASE_H * win.scale
	if useSaved and saved.window.x then
		win.x, win.y = saved.window.x, saved.window.y
	else
		win.x, win.y = (width - w) / 2, (height - h) / 2
	end
	applyWindow()
end

local function rememberWindow()
	saved.window = { x = win.x, y = win.y, scale = win.scale, layout = LAYOUT }
	touch()
end

local function resetWindow()
	placeWindow(false)
	rememberWindow()
end

local function statusContent()
	local stats = env.RivalsStats
	if not stats then
		return "아직 기록이 없습니다.", nil, nil
	end
	local lines = {}
	local rate = stats.Rate and stats:Rate()
	local finished = (stats.hits or 0) + (stats.misses or 0)
	local hits = string.format("명중 %d/%d", stats.hits or 0, finished)
	table.insert(lines, hits .. (rate and string.format(" (%d%%)", math.floor(rate * 100 + 0.5)) or ""))
	if type(stats.windows) == "number" and stats.windows > 0 then
		table.insert(lines, string.format("서버가 받은 샷 기준(추정) %d/%d (%d%%)", stats.windowHits or 0, stats.windows, math.floor(100 * (stats.windowHits or 0) / stats.windows + 0.5)))
	end
	local check = env.RivalsCheck
	if check then
		local bad = 0
		for _, item in ipairs(check.items) do
			if not item.ok then bad += 1 end
		end
		table.insert(lines, bad == 0 and "에임 점검: 정상" or ("에임 점검: 문제 " .. bad .. "개 (기록에 자세히)"))
	end
	if stats.drift then
		table.insert(lines, "샷 데이터 키 다름?")
	end
	local safety = env.RivalsSafety
	if safety and safety.rangeScale < 1 then
		table.insert(lines, string.format("사거리 x%.2f", safety.rangeScale))
	end
	if safety and safety.jitterScale < 1 then
		table.insert(lines, string.format("튕김폭 x%.2f", safety.jitterScale))
	end
	if safety and (safety.jitterPulls + safety.jitterFlings) > 0 then
		table.insert(lines, "안티에임 이상 " .. (safety.jitterPulls + safety.jitterFlings))
	end
	return table.concat(lines, "\n"), hits, rate
end

local function recordContent()
	local lines = { env.RivalsVersion or "체크포인트 ?" }
	local stats = env.RivalsStats
	if stats and type(stats.log) == "table" then
		table.insert(lines, string.format("이번 판 샷 %d발  ·  명중 %d/%d", #stats.log, stats.hits or 0, (stats.hits or 0) + (stats.misses or 0)))
	else
		table.insert(lines, "이번 판 샷 기록이 아직 없습니다.")
	end
	local events = env.RivalsEvents
	if events and type(events.list) == "table" then
		table.insert(lines, "이벤트 " .. #events.list .. "개")
	end
	return table.concat(lines, "\n")
end

local DOWS = { "일", "월", "화", "수", "목", "금", "토" }
local MONTH_DAYS = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }

local function clockState()
	local ok, state = pcall(function()
		local now = os.date("*t")
		local hour, minute = now.hour, now.min
		local ampm = hour < 12 and "오전" or "오후"
		local h12 = hour % 12 == 0 and 12 or hour % 12
		local digital = string.format("%d:%02d", h12, minute)
		return {
			hour = hour, minute = minute, ampm = ampm, digital = digital,
			time = ampm .. " " .. digital,
			date = string.format("%d월 %d일 (%s)", now.month, now.day, DOWS[now.wday]),
			weekday = DOWS[now.wday] .. "요일",
			day = now.day, month = now.month, year = now.year, wday = now.wday,
		}
	end)
	if ok then return state end
	return nil
end

local function monthGrid(state)
	local days = MONTH_DAYS[state.month] or 31
	local year = state.year
	if state.month == 2 and type(year) == "number" and (year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)) then
		days = 29
	end
	local first = (state.wday - 1 - (state.day - 1) % 7) % 7
	return first, days
end

local function dumpLog()
	local stats = env.RivalsStats
	if stats and stats.Dump then
		stats:Dump()
	end
end

local function unloadAll()
	if env.RivalsUnloadAll then
		env.RivalsUnloadAll()
	end
end

local function shownValue(key)
	local shown = env.RivalsShown
	if shown and shown[key] ~= nil then return shown[key] end
	return cfg[key]
end

local function featureToggle(key, label, group, icon, color, detail)
	return {
		type = "toggle", id = key, label = label, detail = detail, group = group, icon = icon, color = color,
		get = function() return shownValue(key) == true end,
		set = function(value)
			cfg[key] = value
			saved.features[key] = value
			if env.RivalsShown then env.RivalsShown[key] = value end
			touch()
		end,
	}
end

local refreshAll

local function petSettings()
	saved.pet = saved.pet or {}
	return saved.pet
end

local ROWS = {
	rage = featureToggle("rage", "레이지봇", 1, "flame", C.orange, "벽 뒤 적까지, 몸을 옮겨서"),
	silent = featureToggle("silent", "사일런트 에임", 1, "aim", C.green, "보이는 적만, 몸은 그대로"),
	autoFire = featureToggle("autoFire", "자동 발사", 2, "bolt", C.blue),
	triggerbot = featureToggle("triggerbot", "트리거봇", 2, "click", C.indigo),
	noRecoil = featureToggle("noRecoil", "반동 제거", 3, "recoil", C.red),
	noSpread = featureToggle("noSpread", "탄퍼짐 제거", 3, "spread", C.teal),
	rapidFire = featureToggle("rapidFire", "연사 제한 해제", 3, "rapid", C.pink),
	antiAim = featureToggle("antiAim", "안티에임", 1, "shield", C.purple),
	antiAimSpin = featureToggle("antiAimSpin", "회전", 1, "spin", C.purple),
	antiAimJitter = featureToggle("antiAimJitter", "위치 튕김", 1, "jitter", C.purple),
	esp = featureToggle("esp", "ESP", 1, "eye", C.blue, "윤곽선과 체력바"),
	antiAimLevel = {
		type = "segment", id = "antiAimLevel", label = "강도", group = 2, icon = "gauge", color = C.orange,
		options = { { 1, "약" }, { 2, "보통" }, { 3, "강" }, { 4, "최강" } },
		get = function() return shownValue("antiAimLevel") or 1 end,
		set = function(value)
			cfg.antiAimLevel = value
			saved.features.antiAimLevel = value
			if env.RivalsShown then env.RivalsShown.antiAimLevel = value end
			touch()
		end,
	},
	petShow = {
		type = "toggle", id = "petShow", label = "펫 표시", group = 1, icon = "cat", color = C.orange,
		get = function() return petSettings().show ~= false end,
		set = function(value)
			petSettings().show = value
			touch()
		end,
	},
	petSwear = {
		type = "toggle", id = "petSwear", label = "욕", group = 2, icon = "flame", color = C.red,
		get = function() return petSettings().swear ~= false end,
		set = function(value)
			petSettings().swear = value
			touch()
		end,
	},
	petChatter = {
		type = "segment", id = "petChatter", label = "말수", group = 2, icon = "bubble", color = C.green,
		options = { { 1, "적게" }, { 2, "보통" }, { 3, "많이" } },
		get = function() return petSettings().chatter or 2 end,
		set = function(value)
			petSettings().chatter = value
			touch()
		end,
	},
}

local APPS = {
	{
		id = "aim", name = "에임", icon = "aim", color = rgb(255, 122, 122), place = "grid",
		rows = { ROWS.rage, ROWS.silent, ROWS.autoFire, ROWS.triggerbot, ROWS.noRecoil, ROWS.noSpread, ROWS.rapidFire },
	},
	{
		id = "antiaim", name = "안티에임", icon = "shield", color = rgb(198, 155, 255), place = "grid",
		rows = { ROWS.antiAim, ROWS.antiAimSpin, ROWS.antiAimJitter, ROWS.antiAimLevel },
	},
	{
		id = "screen", name = "화면", icon = "esp", color = rgb(124, 184, 255), place = "grid",
		rows = { ROWS.esp },
	},
	{
		id = "record", name = "기록", icon = "notes", color = rgb(255, 211, 110), place = "grid",
		rows = {
			{ type = "info", id = "record", text = recordContent },
			{ type = "button", id = "dump", label = "지금 웹훅으로 보내기", group = 2, icon = "send", color = C.blue, run = dumpLog },
			{ type = "note", id = "recordNote", text = function() return "판이 끝나면 그 판의 기록 전부가 웹훅으로 올라갑니다." end },
		},
	},
	{
		id = "status", name = "상태", icon = "chart", color = rgb(111, 227, 196), place = "dock",
		rows = {
			{ type = "info", id = "status", text = function() return (statusContent()) end },
			{ type = "button", id = "unload", label = "전부 끄기", group = 2, icon = "power", color = C.red, run = unloadAll, danger = true },
			{ type = "note", id = "keys", text = function() return HINT end },
		},
	},
	{
		id = "pet", name = "펫", icon = "cat", color = rgb(255, 191, 94), place = "dock",
		rows = {
			ROWS.petShow,
			ROWS.petChatter,
			ROWS.petSwear,
			{
				type = "button", id = "petReset", label = "위치 초기화", group = 3, icon = "reset", color = C.blue,
				run = function()
					if env.RivalsPet and env.RivalsPet.ResetPosition then
						env.RivalsPet:ResetPosition()
					else
						local pet = petSettings()
						pet.x, pet.y = nil, nil
						touch()
					end
				end,
			},
		},
	},
	{
		id = "settings", name = "설정", icon = "gear", color = rgb(199, 203, 211), place = "dock", divider = true,
		rows = {
			{ type = "button", id = "windowReset", label = "창 위치와 크기 초기화", group = 1, icon = "expand", color = C.blue, run = function() resetWindow() end },
			{
				type = "button", id = "defaults", label = "기본값으로 되돌리기", group = 2, icon = "reset", color = C.red, danger = true,
				run = function()
					for key, value in pairs(DEFAULT_FEATURES) do
						cfg[key] = value
					end
					saved.features = {}
					touch()
					refreshAll()
				end,
			},
			{ type = "note", id = "saveInfo", text = function() return "설정과 창 위치는 자동으로 저장됩니다." end },
		},
	},
}

local glyph
do
	local ICON = {
		aim = 0, shield = 1, esp = 2, chart = 3, cat = 4, gear = 5, wifi = 6, search = 7, flame = 8, bolt = 9, click = 10,
		recoil = 11, spread = 12, rapid = 13, spin = 14, jitter = 15, gauge = 16, bubble = 17, send = 18, power = 19,
		back = 20, expand = 21, reset = 22, notes = 23, eye = 24, moon = 25, record = 26, dot = 27,
	}
	local ICON_CELL = 64

	local function bar(parent, x, y, w, h, color)
		local frame = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, x, 0.5, y), Size = UDim2.fromOffset(w, h),
			BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = parent.ZIndex,
		}, parent)
		corner(frame, math.floor(math.min(w, h) / 2))
		return frame
	end

	local function ring(parent, x, y, size, thickness, color)
		local frame = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, x, 0.5, y), Size = UDim2.fromOffset(size, size),
			BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = parent.ZIndex,
		}, parent)
		round(frame)
		stroke(frame, color, thickness)
		return frame
	end

	local function drawFallback(kind, parent, g, color)
		local t = math.max(1, math.floor(g / 14 + 0.5))
		if kind == "aim" then
			ring(parent, 0, 0, g * 0.6, t, color)
			bar(parent, 0, -g * 0.42, t, g * 0.18, color)
			bar(parent, 0, g * 0.42, t, g * 0.18, color)
			bar(parent, -g * 0.42, 0, g * 0.18, t, color)
			bar(parent, g * 0.42, 0, g * 0.18, t, color)
		elseif kind == "shield" then
			local outer = ring(parent, 0, 0, g * 0.62, t, color)
			outer.Rotation = 45
			outer:FindFirstChildWhichIsA("UICorner").CornerRadius = UDim.new(0, 3)
		elseif kind == "esp" then
			local w, l = g * 0.72, g * 0.22
			for _, sx in ipairs({ -1, 1 }) do
				for _, sy in ipairs({ -1, 1 }) do
					bar(parent, sx * (w / 2 - l / 2), sy * w / 2, l, t, color)
					bar(parent, sx * w / 2, sy * (w / 2 - l / 2), t, l, color)
				end
			end
		elseif kind == "chart" then
			for index, height in ipairs({ 0.36, 0.7, 0.52 }) do
				bar(parent, (index - 2) * g * 0.26, g * 0.35 - g * height / 2, g * 0.14, g * height, color)
			end
		elseif kind == "gear" then
			ring(parent, 0, 0, g * 0.66, t, color)
			ring(parent, 0, 0, g * 0.28, t, color)
		elseif kind == "cat" then
			ring(parent, 0, g * 0.06, g * 0.66, t, color)
			for _, side in ipairs({ -1, 1 }) do
				local ear = bar(parent, side * g * 0.2, -g * 0.26, g * 0.16, g * 0.16, color)
				ear.Rotation = 45
			end
		elseif kind == "notes" then
			ring(parent, 0, 0, g * 0.62, t, color):FindFirstChildWhichIsA("UICorner").CornerRadius = UDim.new(0, 3)
			bar(parent, 0, -g * 0.06, g * 0.32, t, color)
			bar(parent, 0, g * 0.1, g * 0.24, t, color)
		else
			ring(parent, 0, 0, g * 0.5, t, color)
		end
	end

	function glyph(parent, name, size, color, z)
		local index = ICON[name] or ICON.dot
		if assets.icons then
			return new("ImageLabel", {
				Name = "Glyph", BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(size, size), ZIndex = z or 2,
				Image = assets.icons, ImageColor3 = color,
				ImageRectOffset = Vector2.new(index % 8 * ICON_CELL, math.floor(index / 8) * ICON_CELL),
				ImageRectSize = Vector2.new(ICON_CELL, ICON_CELL),
			}, parent)
		end
		local holder = new("Frame", {
			Name = "Glyph", BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(size, size), ZIndex = z or 2,
		}, parent)
		drawFallback(name, holder, size, color)
		return holder
	end
end

local function recolor(glyphObject, color)
	if glyphObject:IsA("ImageLabel") then
		glyphObject.ImageColor3 = color
		return
	end
	for _, part in ipairs(glyphObject:GetDescendants()) do
		if part:IsA("UIStroke") then
			part.Color = color
		elseif part:IsA("Frame") and part.BackgroundTransparency < 1 then
			part.BackgroundColor3 = color
		end
	end
end

local function glass(class, parent, x, y, w, h, radius, options)
	options = options or {}
	local root = new(class, {
		Name = options.name or "Glass", BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
		Position = at(x + w / 2, y + h / 2), Size = px(w, h), ZIndex = options.z or 2,
		BackgroundColor3 = options.color or C.tile, BackgroundTransparency = 0,
	}, parent)
	if class == "ImageButton" or class == "TextButton" then root.AutoButtonColor = false end
	if class == "TextButton" then root.Text = "" end
	corner(root, radius * S)
	if not options.color then
		stroke(root, C.edge, 1, 0, true)
	end
	return root
end

ui.container = new("Frame", { Name = "Window", BackgroundTransparency = 1, BorderSizePixel = 0 }, ui.gui)
ui.bezel = new("TextButton", {
	Name = "Bezel", Text = "", AutoButtonColor = false, BackgroundColor3 = C.bezel, BorderSizePixel = 0,
	Size = UDim2.fromOffset(BASE_W, BASE_H),
}, ui.container)
ui.uiScale = new("UIScale", { Scale = 1 }, ui.bezel)
corner(ui.bezel, 58 * S)
stroke(ui.bezel, C.bezelEdge, 1.5, 0, true)
round(new("Frame", {
	Name = "Camera", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -7 * S, 0.5, 0), Size = px(7, 7),
	BackgroundColor3 = C.camera, BorderSizePixel = 0,
}, ui.bezel))

ui.screen = new("Frame", {
	Name = "Screen", Position = UDim2.fromOffset(BEZEL, BEZEL), Size = UDim2.fromOffset(SCREEN_W, SCREEN_H),
	BackgroundColor3 = C.white, BorderSizePixel = 0, ClipsDescendants = true,
}, ui.bezel)
corner(ui.screen, SCREEN_RADIUS)

ui.statusBar = new("TextButton", {
	Name = "StatusBar", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 36 * S), ZIndex = 30,
}, ui.screen)
ui.clockLine = new("Frame", {
	Name = "ClockLine", BackgroundTransparency = 1, BorderSizePixel = 0, Position = at(32, 0), Size = UDim2.new(0.6, 0, 1, 0), ZIndex = 30,
}, ui.statusBar)
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8 * S),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, ui.clockLine)
ui.timeLabel = text(ui.clockLine, {
	Name = "Time", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Font = FONT_BOLD, TextSize = 13,
	Text = "--:--", LayoutOrder = 1, ZIndex = 30,
})
ui.dateLabel = text(ui.clockLine, {
	Name = "Date", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Font = FONT_BOLD, TextSize = 13,
	LayoutOrder = 2, ZIndex = 30,
})
ui.controlButton = new("TextButton", {
	Name = "ControlButton", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
	AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -20 * S, 0.5, 0), Size = px(150, 30), ZIndex = 31,
}, ui.statusBar)
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right,
	VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 7 * S), SortOrder = Enum.SortOrder.LayoutOrder,
}, ui.controlButton)
glyph(ui.controlButton, "wifi", 20 * S, C.ink, 31).LayoutOrder = 1
ui.rateLabel = text(ui.controlButton, {
	Name = "Rate", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Font = FONT_BOLD, TextSize = 12,
	LayoutOrder = 2, ZIndex = 31,
})
ui.battery = new("Frame", {
	Name = "Battery", Size = px(26, 12.5), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 3, ZIndex = 31,
}, ui.controlButton)
corner(ui.battery, 4 * S)
stroke(ui.battery, C.ink, 1, 0.55, true)
ui.batteryLevel = new("Frame", {
	Name = "Level", Position = at(2, 2), Size = px(22, 8.5), BackgroundColor3 = C.ink, BorderSizePixel = 0, ZIndex = 31,
}, ui.battery)
corner(ui.batteryLevel, 2 * S)
corner(new("Frame", {
	Name = "Nub", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(1, 1.5 * S, 0.5, 0), Size = px(2, 4.5),
	BackgroundColor3 = C.ink, BackgroundTransparency = 0.55, BorderSizePixel = 0, ZIndex = 31,
}, ui.battery), 1)

ui.homePage = new("Frame", {
	Name = "Home", BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), ZIndex = 2,
}, ui.screen)
ui.homeScale = new("UIScale", { Scale = 1 }, ui.homePage)
ui.homeDim = new("Frame", {
	Name = "HomeDim", BackgroundColor3 = C.black, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 3,
}, ui.screen)
corner(ui.homeDim, SCREEN_RADIUS)

ui.calendar = glass("Frame", ui.homePage, 64, 78, 324, 158, 28, { name = "Calendar" })
ui.weekdayLabel = text(ui.calendar, {
	Name = "Weekday", Position = at(18, 14), Size = px(92, 20), Font = FONT_BOLD, TextSize = 11, TextColor3 = C.coral,
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
})
ui.dayLabel = thin(text(ui.calendar, {
	Name = "Day", Position = at(16, 40), Size = px(92, 56), TextSize = 38, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
}))
ui.monthLabel = text(ui.calendar, {
	Name = "Month", Position = at(18, 120), Size = px(120, 20), Font = FONT_MEDIUM, TextSize = 10, TextTransparency = SECONDARY,
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
})
local cells
do
	local CAL_X, CAL_Y, CAL_COL, CAL_ROW = 124, 12, 26, 19
	for index, name in ipairs(DOWS) do
		text(ui.calendar, {
			Name = "Head_" .. index, Position = at(CAL_X + (index - 1) * CAL_COL, CAL_Y), Size = px(CAL_COL, 16), Font = FONT_BOLD,
			TextSize = 9, TextTransparency = 0.5, Text = name, ZIndex = 2,
		})
	end
	cells = {}
	for index = 1, 42 do
		local col, row = (index - 1) % 7, math.floor((index - 1) / 7)
		local cell = new("Frame", {
			Name = "Cell_" .. index, BackgroundTransparency = 1, BorderSizePixel = 0,
			Position = at(CAL_X + col * CAL_COL, CAL_Y + (row + 1) * CAL_ROW), Size = px(CAL_COL, 18), ZIndex = 2,
		}, ui.calendar)
		local mark = new("Frame", {
			Name = "Today", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = px(19, 19),
			BackgroundColor3 = C.today, BorderSizePixel = 0, Visible = false, ZIndex = 2,
		}, cell)
		round(mark)
		local number = text(cell, { Name = "Number", Size = UDim2.fromScale(1, 1), Font = FONT_BOLD, TextSize = 10, ZIndex = 3 })
		cells[index] = { mark = mark, number = number, col = col }
	end
end

ui.clockCard = glass("Frame", ui.homePage, 446, 78, 324, 158, 28, { name = "ClockWidget" })
ui.dial = new("Frame", {
	Name = "Dial", Position = at(20, 19), Size = px(120, 120), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 2,
}, ui.clockCard)
round(ui.dial)
stroke(ui.dial, C.edge, 1.5, 0, true)
for _, entry in ipairs({ { "12", 0, 6, 120 }, { "6", 0, 98, 120 }, { "3", 98, 52, 13 }, { "9", 10, 52, 13 } }) do
	text(ui.dial, { Text = entry[1], Position = at(entry[2], entry[3]), Size = px(entry[4], 16), Font = FONT_BOLD, TextSize = 11, ZIndex = 3 })
end
local function clockHand(name, width, length)
	local pivot = new("Frame", {
		Name = name, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = px(length * 2, length * 2),
		BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 3,
	}, ui.dial)
	corner(new("Frame", {
		Name = "Stick", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.5), Size = px(width, length),
		BackgroundColor3 = C.ink, BorderSizePixel = 0, ZIndex = 3,
	}, pivot), width * S / 2)
	return pivot
end
ui.hourHand = clockHand("HourHand", 4, 30)
ui.minuteHand = clockHand("MinuteHand", 3, 44)
ui.pin = new("Frame", {
	Name = "Pin", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = px(8, 8),
	BackgroundColor3 = C.pin, BorderSizePixel = 0, ZIndex = 4,
}, ui.dial)
round(ui.pin)
stroke(ui.pin, C.white, 2 * S)
text(ui.clockCard, {
	Name = "City", Position = at(160, 22), Size = px(140, 24), Font = FONT_BOLD, TextSize = 14, Text = "서울",
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
})
ui.ampmLabel = text(ui.clockCard, {
	Name = "AmPm", Position = at(160, 52), Size = px(140, 18), Font = FONT_MEDIUM, TextSize = 10, TextTransparency = SECONDARY,
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
})
ui.clockLabel = thin(text(ui.clockCard, {
	Name = "Clock", Position = at(158, 78), Size = px(156, 52), TextSize = 32, Text = "--:--",
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
}))

ui.appPage = new("Frame", {
	Name = "App", BackgroundColor3 = C.grouped, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 20, ClipsDescendants = true,
}, ui.screen)
ui.appScale = new("UIScale", { Scale = 1 }, ui.appPage)
ui.appCorner = corner(ui.appPage, SCREEN_RADIUS)
ui.header = new("Frame", { Name = "Header", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 120), ZIndex = 3 }, ui.appPage)
ui.backButton = new("TextButton", {
	Name = "Back", Text = "", AutoButtonColor = false, BackgroundColor3 = C.off, BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(37, 54), Size = UDim2.fromOffset(36, 36), ZIndex = 3,
}, ui.header)
round(ui.backButton)
glyph(ui.backButton, "back", 17, C.ink, 4)
springy(ui.backButton, new("UIScale", { Scale = 1 }, ui.backButton), 0.88)
ui.appTitle = text(ui.header, {
	Name = "Title", Position = UDim2.fromOffset(22, 80), Size = UDim2.new(1, -44, 0, 34), Font = FONT_BOLD, TextSize = 26,
	TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
})
ui.cover = new("Frame", {
	Name = "Cover", BackgroundColor3 = C.blue, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 50,
}, ui.appPage)
ui.coverCorner = corner(ui.cover, SCREEN_RADIUS)

ui.homeBar = new("TextButton", {
	Name = "HomeBar", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
	AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = px(220, 30), ZIndex = 40,
}, ui.screen)
corner(new("Frame", {
	Name = "Indicator", AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -7 * S), Size = px(160, 5),
	BackgroundColor3 = C.ink, BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 40,
}, ui.homeBar), 3 * S)

local function grip(name, anchorX, anchorY, signX, signY)
	local button = new("TextButton", {
		Name = name, Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 60,
		AnchorPoint = Vector2.new(anchorX, anchorY), Position = UDim2.fromScale(anchorX, anchorY), Size = UDim2.fromOffset(30, 30),
	}, ui.bezel)
	round(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -signX * 5, 0.5, -signY * 5), Size = UDim2.fromOffset(5, 5),
		BackgroundColor3 = C.white, BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 61,
	}, button))
	return button
end
local grips = {
	{ grip("Grip_TL", 0, 0, -1, -1), -1, -1 },
	{ grip("Grip_TR", 1, 0, 1, -1), 1, -1 },
	{ grip("Grip_BL", 0, 1, -1, 1), -1, 1 },
	{ grip("Grip_BR", 1, 1, 1, 1), 1, 1 },
}

local refreshers = {}
local pages = {}
local currentApp = nil

do
	local function rowIcon(frame, row)
		local tile = new("Frame", {
			Name = "Icon", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundColor3 = row.color or C.chip, BorderSizePixel = 0, ZIndex = 2,
		}, frame)
		corner(tile, 8)
		glyph(tile, row.icon or "dot", 18, C.white, 3)
	end

	local function rowLabel(frame, row, height)
		local hasDetail = row.detail ~= nil
		text(frame, {
			Name = "Label", Position = UDim2.fromOffset(52, hasDetail and 9 or 0), Size = UDim2.new(1, -120, 0, hasDetail and 20 or height),
			TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Text = row.label, ZIndex = 2,
		})
		if hasDetail then
			text(frame, {
				Name = "Detail", Position = UDim2.fromOffset(52, 30), Size = UDim2.new(1, -120, 0, 16), TextSize = 11,
				TextTransparency = 0.45, TextXAlignment = Enum.TextXAlignment.Left, Text = row.detail, ZIndex = 2,
			})
		end
	end

	local TRACK_W, TRACK_H, KNOB, KNOB_PRESSED = 46, 28, 24, 30

	local function switch(parent, row, name)
		local track = new("TextButton", {
			Name = name, Text = "", AutoButtonColor = false, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(TRACK_W, TRACK_H), BackgroundColor3 = C.off,
			BackgroundTransparency = 0, ZIndex = 2,
		}, parent)
		round(track)
		local tint = new("Frame", {
			Name = "Tint", BackgroundColor3 = C.green, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 2,
		}, track)
		round(tint)
		local knob = new("Frame", {
			Name = "Knob", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(KNOB, KNOB),
			BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 3,
		}, track)
		round(knob)
		stroke(knob, C.edge, 1, 0.2)
		local slideKey, widthKey = {}, {}
		local state = { at = 0, width = KNOB }
		local function layout()
			knob.Size = UDim2.fromOffset(state.width, KNOB)
			knob.Position = UDim2.new(0, 2 + state.at * (TRACK_W - 4 - state.width), 0.5, 0)
			tint.BackgroundTransparency = 1 - math.clamp(state.at, 0, 1)
		end
		local function slide(value)
			state.at = value
			layout()
		end
		local function stretch(value)
			state.width = value
			layout()
		end
		local element = { shown = nil, row = row }
		function element.refresh()
			local want = row.get() == true
			if element.shown == want then return end
			local first = element.shown == nil
			element.shown = want
			track:SetAttribute("On", want)
			if first then
				Motion.set(slideKey, want and 1 or 0, slide)
			else
				Motion.spring(slideKey, want and 1 or 0, { duration = 0.2, bounce = 0.1 }, slide)
			end
		end
		function element.click()
			row.set(not (row.get() == true))
			element.refresh()
		end
		track.MouseButton1Click:Connect(element.click)
		pressable(track, function()
			Motion.spring(widthKey, KNOB_PRESSED, { duration = 0.12, from = KNOB }, stretch)
		end, function()
			Motion.spring(widthKey, KNOB, { duration = 0.24, bounce = 0.12 }, stretch)
		end)
		table.insert(refreshers, element.refresh)
		element.refresh()
		return element
	end

	local function addToggle(parent, order, row)
		local height = row.detail and 56 or 46
		local frame = new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = order, Size = UDim2.new(1, 0, 0, height), ZIndex = 2 }, parent)
		rowIcon(frame, row)
		rowLabel(frame, row, height)
		return switch(frame, row, "Toggle_" .. row.id)
	end

	local function addSegment(parent, order, row)
		local frame = new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = order, Size = UDim2.new(1, 0, 0, 52), ZIndex = 2 }, parent)
		rowIcon(frame, row)
		rowLabel(frame, row, 52)
		local width, count = 196, #row.options
		local segments = new("Frame", {
			Name = "Segments", AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(width, 30),
			BackgroundColor3 = C.off, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 2,
		}, frame)
		corner(segments, 9)
		local slot = (width - 4) / count
		local chip = new("Frame", {
			Name = "Chip", Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(slot, 26), BackgroundColor3 = C.white, BorderSizePixel = 0, ZIndex = 2,
		}, segments)
		corner(chip, 7)
		stroke(chip, C.edge, 1, 0, true)
		local chipKey = {}
		local function place(position)
			chip.Position = UDim2.fromOffset(2 + (position - 1) * slot, 2)
		end
		local buttons = {}
		local element = { shown = nil, row = row }
		function element.refresh()
			local want = row.get()
			if element.shown == want then return end
			local first = element.shown == nil
			element.shown = want
			local found = false
			for index, entry in ipairs(buttons) do
				local on = entry.value == want
				entry.button:SetAttribute("Selected", on)
				entry.button.Font = on and FONT_BOLD or FONT
				entry.button.TextTransparency = on and 0 or 0.25
				if on then
					found = true
					if first then
						Motion.set(chipKey, index, place)
					else
						Motion.spring(chipKey, index, { duration = 0.22, bounce = 0.08 }, place)
					end
				end
			end
			chip.Visible = found
		end
		function element.choose(value)
			row.set(value)
			element.refresh()
		end
		for index, option in ipairs(row.options) do
			local button = new("TextButton", {
				Name = "Seg_" .. row.id .. "_" .. tostring(option[1]), Text = option[2], AutoButtonColor = false, BorderSizePixel = 0,
				Position = UDim2.fromOffset(2 + (index - 1) * slot, 2), Size = UDim2.fromOffset(slot, 26), Font = FONT, TextSize = 12,
				TextColor3 = C.ink, BackgroundTransparency = 1, ZIndex = 3,
			}, segments)
			button.MouseButton1Click:Connect(function()
				element.choose(option[1])
			end)
			table.insert(buttons, { button = button, value = option[1] })
		end
		table.insert(refreshers, element.refresh)
		element.refresh()
		return element
	end

	local function addButton(parent, order, row)
		local button = new("TextButton", {
			Name = "Btn_" .. row.id, Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
			LayoutOrder = order, Size = UDim2.new(1, 0, 0, 46), ZIndex = 2,
		}, parent)
		local highlight = new("Frame", {
			Name = "Highlight", BackgroundColor3 = C.ink, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1,
		}, button)
		rowIcon(button, row)
		text(button, {
			Name = "Label", Position = UDim2.fromOffset(52, 0), Size = UDim2.new(1, -64, 1, 0), TextSize = 14,
			TextColor3 = row.danger and C.red or C.blue, TextXAlignment = Enum.TextXAlignment.Left, Text = row.label, ZIndex = 2,
		})
		local key = {}
		local function paint(value)
			highlight.BackgroundTransparency = value
		end
		pressable(button, function()
			Motion.set(key, 0.9, paint)
		end, function()
			Motion.spring(key, 1, { duration = 0.22 }, paint)
		end)
		button.MouseButton1Click:Connect(function()
			local ok, err = pcall(row.run)
			if not ok then
			end
			if refreshAll then refreshAll() end
		end)
		return button
	end

	local function addText(parent, order, row, card)
		local frame = new("Frame", {
			Name = "Info_" .. row.id, BackgroundColor3 = C.white, BackgroundTransparency = card and 0 or 1, BorderSizePixel = 0,
			LayoutOrder = order, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2,
		}, parent)
		if card then
			corner(frame, 14)
			stroke(frame, C.edge, 1, 0, true)
		end
		new("UIPadding", {
			PaddingTop = UDim.new(0, card and 13 or 0), PaddingBottom = UDim.new(0, card and 13 or 0),
			PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16),
		}, frame)
		local label = text(frame, {
			Name = "Text", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextSize = card and 13 or 11,
			TextTransparency = card and 0 or 0.45, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true, LineHeight = 1.25, ZIndex = 2,
		})
		local shown = nil
		local function refresh()
			local value = row.text()
			if value ~= shown then
				shown = value
				label.Text = value
			end
		end
		table.insert(refreshers, refresh)
		refresh()
		return label
	end

	local function newGroup(parent, order)
		local group = new("Frame", {
			Name = "Group", BackgroundColor3 = C.white, BackgroundTransparency = 0, BorderSizePixel = 0, LayoutOrder = order,
			Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ClipsDescendants = true, ZIndex = 2,
		}, parent)
		corner(group, 14)
		stroke(group, C.edge, 1, 0, true)
		new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, group)
		return group
	end

	local function separator(group, order)
		local holder = new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = order, Size = UDim2.new(1, 0, 0, 1), ZIndex = 2 }, group)
		new("Frame", {
			Position = UDim2.fromOffset(52, 0), Size = UDim2.new(1, -52, 1, 0), BackgroundColor3 = C.edge, BackgroundTransparency = 0,
			BorderSizePixel = 0, ZIndex = 2,
		}, holder)
	end

	for _, app in ipairs(APPS) do
		local body = new("ScrollingFrame", {
			Name = "Body_" .. app.id, BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
			Position = UDim2.fromOffset(0, 124), Size = UDim2.new(1, 0, 1, -146), CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = C.ink, ScrollBarImageTransparency = 0.7,
			ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 2,
		}, ui.appPage)
		new("UIListLayout", { Padding = UDim.new(0, 22), SortOrder = Enum.SortOrder.LayoutOrder }, body)
		new("UIPadding", { PaddingLeft = UDim.new(0, 20), PaddingRight = UDim.new(0, 20), PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 24) }, body)
		local group, groupId, slot = nil, nil, 0
		for order, row in ipairs(app.rows) do
			if row.type == "info" or row.type == "note" then
				group, groupId = nil, nil
				addText(body, order, row, row.type == "info")
			else
				if group == nil or row.group ~= groupId then
					group, groupId, slot = newGroup(body, order), row.group, 0
				else
					slot += 1
					separator(group, slot)
				end
				slot += 1
				if row.type == "toggle" then
					addToggle(group, slot, row)
				elseif row.type == "segment" then
					addSegment(group, slot, row)
				elseif row.type == "button" then
					addButton(group, slot, row)
				end
			end
		end
		pages[app.id] = body
	end
end

local openApp

local GRID_X, GRID_Y, GRID_COL, GRID_ROW, ICON_SIZE
do
	local function appIcon(app, parent, x, y, size, radius, back, glyphSize)
		local button = glass("ImageButton", parent, x, y, size, size, radius, { name = "App_" .. app.id, color = app.color })
		glyph(button, app.icon, glyphSize * S, C.white, 2)
		springy(button, new("UIScale", { Name = "Press", Scale = 1 }, button))
		button.MouseButton1Click:Connect(function()
			openApp(app, button)
		end)
		return button
	end

	GRID_X, GRID_Y, GRID_COL, GRID_ROW, ICON_SIZE = 64, 288, 176.5, 131, 74
	local gridIndex = 0
	local dockApps = {}
	for _, app in ipairs(APPS) do
		if app.place == "dock" then
			table.insert(dockApps, app)
		else
			local col, row = gridIndex % 4, math.floor(gridIndex / 4)
			gridIndex += 1
			local x = GRID_X + col * GRID_COL + (GRID_COL - ICON_SIZE) / 2
			local y = GRID_Y + row * GRID_ROW
			appIcon(app, ui.homePage, x, y, ICON_SIZE, 17, { x, y }, 36)
			text(ui.homePage, {
				Name = "Label_" .. app.id, Position = at(x - 15, y + ICON_SIZE + 6), Size = px(104, 22), Font = FONT_MEDIUM, TextSize = 11,
				Text = app.name, ZIndex = 2,
			})
		end
	end

	ui.search = glass("Frame", ui.homePage, 365, 1022, 104, 36, 18, { name = "Search" })
	ui.searchRow = new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 2 }, ui.search)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 5 * S), SortOrder = Enum.SortOrder.LayoutOrder,
	}, ui.searchRow)
	glyph(ui.searchRow, "search", 16 * S, C.gray, 2).LayoutOrder = 1
	text(ui.searchRow, {
		Name = "SearchText", Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Font = FONT_BOLD, TextSize = 11,
		Text = "검색", TextColor3 = C.gray, LayoutOrder = 2, ZIndex = 2,
	})

	local DOCK_ICON, DOCK_GAP, DOCK_PAD_X, DOCK_PAD_Y = 64, 18, 16, 12
	local dockSlots, cursor = {}, DOCK_PAD_X
	for _, app in ipairs(dockApps) do
		if app.divider then
			table.insert(dockSlots, { x = cursor })
			cursor += 1 + DOCK_GAP
		end
		table.insert(dockSlots, { app = app, x = cursor })
		cursor += DOCK_ICON + DOCK_GAP
	end
	local dockW, dockH = cursor - DOCK_GAP + DOCK_PAD_X, DOCK_ICON + 2 * DOCK_PAD_Y
	local dockX, dockY = (DESIGN_W - dockW) / 2, DESIGN_H - 22 - dockH
	ui.dock = glass("Frame", ui.homePage, dockX, dockY, dockW, dockH, 32, { name = "Dock" })
	for _, slot in ipairs(dockSlots) do
		if slot.app then
			appIcon(slot.app, ui.dock, slot.x, DOCK_PAD_Y, DOCK_ICON, 15, { dockX + slot.x, dockY + DOCK_PAD_Y }, 32)
		else
			new("Frame", {
				Name = "Divider", Position = at(slot.x, (dockH - 52) / 2), Size = px(1, 52), BackgroundColor3 = C.edge,
				BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 2,
			}, ui.dock)
		end
	end
end

ui.controlLayer = new("Frame", {
	Name = "Control", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 25,
}, ui.screen)
ui.controlBackdrop = new("ImageButton", {
	Name = "ControlBackdrop", AutoButtonColor = false, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 25,
	BackgroundColor3 = C.grouped, BackgroundTransparency = 1,
}, ui.controlLayer)
corner(ui.controlBackdrop, SCREEN_RADIUS)
do
	local PANEL_W, PANEL_H = 348, 440
	ui.panel = new("Frame", {
		Name = "ControlPanel", BackgroundTransparency = 1, BorderSizePixel = 0, AnchorPoint = Vector2.new(1, 0),
		Position = at(DESIGN_W - 48, 64), Size = px(PANEL_W, PANEL_H + 40), ZIndex = 26,
	}, ui.controlLayer)
	ui.panelScale = new("UIScale", { Scale = 1.06 }, ui.panel)
	ui.caption = text(ui.panel, {
		Name = "Caption", Position = at(0, PANEL_H + 10), Size = px(PANEL_W, 24), Font = FONT_BOLD, TextSize = 12, TextTransparency = 1, ZIndex = 27,
	})
end

local captionKey, captionUntil = {}, 0
local sliderDrag, sliderClicked
do
	local function announce(message)
		ui.caption.Text = message
		Motion.set(captionKey, 0, function(value) ui.caption.TextTransparency = value end)
		captionUntil = os.clock() + 1.4
	end

	local function tintable(button, row, color, name, icon)
		local tint = new("Frame", {
			Name = "Tint", BackgroundColor3 = color, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1,
		}, button)
		round(tint)
		local key = {}
		local element = { shown = nil }
		local function paint(value)
			tint.BackgroundTransparency = 1 - value
		end
		function element.refresh()
			local want = row.get() == true
			if element.shown == want then return end
			local first = element.shown == nil
			element.shown = want
			button:SetAttribute("On", want)
			if icon then recolor(icon, want and C.white or C.ink) end
			if first then
				Motion.set(key, want and 1 or 0, paint)
			else
				Motion.spring(key, want and 1 or 0, { duration = 0.16 }, paint)
			end
		end
		button.MouseButton1Click:Connect(function()
			row.set(not (row.get() == true))
			element.refresh()
			announce((name or row.label) .. (row.get() and " 켬" or " 끔"))
			refreshAll()
		end)
		table.insert(refreshers, element.refresh)
		element.refresh()
		return element
	end

	local function roundToggle(parent, row, color, x, y, size, glassy)
		local button
		if glassy then
			button = glass("TextButton", parent, x, y, size, size, size / 2, { name = "CC_" .. row.id, z = 27 })
		else
			button = new("TextButton", {
				Name = "CC_" .. row.id, Text = "", AutoButtonColor = false, BackgroundColor3 = C.off, BackgroundTransparency = 0,
				BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = at(x + size / 2, y + size / 2), Size = px(size, size), ZIndex = 27,
			}, parent)
			round(button)
		end
		local icon = glyph(button, row.icon, 28 * S, C.ink, 3)
		springy(button, new("UIScale", { Scale = 1 }, button), 0.92)
		tintable(button, row, color, nil, icon)
		return button
	end

	local function module(x, y, w, h, radius, name)
		local frame = glass("Frame", ui.panel, x, y, w, h, radius, { name = name, color = C.white, z = 27 })
		stroke(frame, C.edge, 1, 0, true)
		frame.Active = true
		return frame
	end

	local connectivity = module(0, 0, 164, 164, 36, "Toggles")
	for index, entry in ipairs({ { ROWS.rage, C.orange }, { ROWS.silent, C.green }, { ROWS.autoFire, C.blue }, { ROWS.triggerbot, C.blue } }) do
		local col, row = (index - 1) % 2, math.floor((index - 1) / 2)
		roundToggle(connectivity, entry[1], entry[2], 14 + col * 68 + 5, 14 + row * 68 + 5, 58, false)
	end

	local statsModule = module(184, 0, 164, 164, 36, "Stats")
	ui.ccHits = text(statsModule, {
		Name = "CCHits", Position = at(20, 18), Size = px(130, 22), Font = FONT_BOLD, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
	})
	ui.ccSub = text(statsModule, {
		Name = "CCSub", Position = at(20, 40), Size = px(130, 18), TextSize = 10, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
	})
	ui.ccRate = thin(text(statsModule, {
		Name = "CCRate", Position = at(18, 104), Size = px(90, 44), TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
	}))
	ui.sendButton = new("TextButton", {
		Name = "CCSend", Text = "", AutoButtonColor = false, BackgroundColor3 = C.blue, BackgroundTransparency = 0, BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = at(132, 126), Size = px(38, 38), ZIndex = 3,
	}, statsModule)
	round(ui.sendButton)
	glyph(ui.sendButton, "send", 22 * S, C.white, 4)
	springy(ui.sendButton, new("UIScale", { Scale = 1 }, ui.sendButton), 0.88)
	ui.sendButton.MouseButton1Click:Connect(function()
		dumpLog()
		announce("기록을 웹훅으로 보냈어요")
	end)

	roundToggle(ui.panel, ROWS.antiAim, C.purple, 0, 184, 72, true)
	roundToggle(ui.panel, ROWS.esp, C.blue, 92, 184, 72, true)

	sliderDrag, sliderClicked = nil, {}

	local function ccSlider(row, x, y, iconName)
		local slider = glass("TextButton", ui.panel, x, y, 72, 164, 30, { name = "CCSlider_" .. row.id, color = C.off, z = 27 })
		slider.ClipsDescendants = true
		local fill = new("Frame", {
			Name = "Fill", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = C.blue, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 2,
		}, slider)
		corner(fill, 30 * S)
		local icon = glyph(slider, iconName, 26 * S, C.white, 3)
		icon.AnchorPoint = Vector2.new(0.5, 1)
		icon.Position = UDim2.new(0.5, 0, 1, -14 * S)
		local valueLabel = text(slider, {
			Name = "Value", Position = UDim2.fromOffset(0, 12 * S), Size = UDim2.new(1, 0, 0, 14), Font = FONT_BOLD, TextSize = 11,
			TextColor3 = C.gray, ZIndex = 3,
		})
		local count = #row.options
		local key = {}
		local function paint(value)
			fill.Size = UDim2.fromScale(1, math.clamp(value, 0, 1))
		end
		local element = { shown = nil }
		function element.refresh()
			local want = row.get()
			if element.shown == want then return end
			local first = element.shown == nil
			element.shown = want
			local position = 1
			for index, option in ipairs(row.options) do
				if option[1] == want then
					position = index
					valueLabel.Text = option[2]
				end
			end
			slider:SetAttribute("Value", want)
			if first then
				Motion.set(key, position / count, paint)
			else
				Motion.spring(key, position / count, { duration = 0.2 }, paint)
			end
		end
		local function choose(index)
			local option = row.options[math.clamp(index, 1, count)]
			if option[1] ~= row.get() then
				row.set(option[1])
				element.refresh()
				announce(row.label .. " " .. option[2])
				refreshAll()
			end
		end
		local function fromY(y)
			local ok, top, height = pcall(function()
				return slider.AbsolutePosition.Y, slider.AbsoluteSize.Y
			end)
			if not ok or type(top) ~= "number" or type(height) ~= "number" or height <= 0 then return false end
			choose(math.ceil(math.clamp((top + height - y) / height, 0, 1) * count))
			return true
		end
		slider.InputBegan:Connect(function(input)
			local kind = input.UserInputType
			if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then return end
			if fromY(input.Position.Y) then
				sliderClicked[slider] = true
				sliderDrag = fromY
			end
		end)
		slider.MouseButton1Click:Connect(function()
			if sliderClicked[slider] then
				sliderClicked[slider] = nil
				return
			end
			local position = 1
			for index, option in ipairs(row.options) do
				if option[1] == row.get() then position = index end
			end
			choose(position % count + 1)
		end)
		table.insert(refreshers, element.refresh)
		element.refresh()
		return slider
	end

	ccSlider(ROWS.antiAimLevel, 184, 184, "gauge")
	ccSlider(ROWS.petChatter, 276, 184, "bubble")

	local petWide = module(0, 276, 164, 72, 36, "PetModule")
	ui.petButton = new("TextButton", {
		Name = "CC_petShow", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1), ZIndex = 3,
	}, petWide)
	ui.petCircle = new("Frame", {
		Name = "Circle", AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14 * S, 0.5, 0), Size = px(44, 44),
		BackgroundColor3 = C.off, BackgroundTransparency = 0, BorderSizePixel = 0, ZIndex = 3,
	}, ui.petButton)
	round(ui.petCircle)
	local petGlyph = glyph(ui.petCircle, "cat", 22 * S, C.ink, 5)
	text(ui.petButton, {
		Name = "PetLabel", Position = at(70, 0), Size = px(90, 72), Font = FONT_BOLD, TextSize = 12, Text = "펫 표시",
		TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4,
	})
	springy(ui.petButton, new("UIScale", { Scale = 1 }, ui.petButton), 0.95)
	do
		local tint = new("Frame", {
			Name = "Tint", BackgroundColor3 = C.indigo, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 4,
		}, ui.petCircle)
		round(tint)
		local key = {}
		local shown = nil
		local function paint(value)
			tint.BackgroundTransparency = 1 - value
		end
		local function refresh()
			local want = ROWS.petShow.get() == true
			if shown == want then return end
			local first = shown == nil
			shown = want
			ui.petButton:SetAttribute("On", want)
			recolor(petGlyph, want and C.white or C.ink)
			if first then Motion.set(key, want and 1 or 0, paint) else Motion.spring(key, want and 1 or 0, { duration = 0.16 }, paint) end
		end
		ui.petButton.MouseButton1Click:Connect(function()
			ROWS.petShow.set(not ROWS.petShow.get())
			refresh()
			announce("펫 " .. (ROWS.petShow.get() and "보이기" or "숨기기"))
			refreshAll()
		end)
		table.insert(refreshers, refresh)
		refresh()
	end

	for index, entry in ipairs({
		{ ROWS.noRecoil, C.orange },
		{ ROWS.noSpread, C.green },
		{ ROWS.rapidFire, C.red },
		{ ROWS.antiAimSpin, C.orange },
	}) do
		roundToggle(ui.panel, entry[1], entry[2], (index - 1) * 92, 368, 72, true)
	end
end

local controlOpen = false
local function applyControl(p)
	local value = math.clamp(p, 0, 1)
	ui.controlBackdrop.BackgroundTransparency = 1 - value
	ui.panel.Visible = value > 0.35
	ui.panelScale.Scale = 1.06 - 0.06 * p
end

local function setControl(open)
	if controlOpen == open then return end
	controlOpen = open
	if open then
		ui.controlLayer.Visible = true
		refreshAll()
	end
	Motion.spring("control", open and 1 or 0, { duration = open and 0.22 or 0.14, eps = 0.001 }, applyControl, function()
		if not controlOpen then ui.controlLayer.Visible = false end
	end)
end

ui.controlButton.MouseButton1Click:Connect(function()
	setControl(not controlOpen)
end)
ui.controlBackdrop.MouseButton1Click:Connect(function()
	setControl(false)
end)

local shownDay = nil

local function drawMonth(state)
	local key = tostring(state.year) .. "-" .. tostring(state.month) .. "-" .. tostring(state.day)
	if key == shownDay then return end
	shownDay = key
	local first, days = monthGrid(state)
	for index, cell in ipairs(cells) do
		local number = index - first
		if number >= 1 and number <= days then
			cell.number.Text = tostring(number)
			cell.number.TextTransparency = cell.col == 0 and number ~= state.day and 0.5 or 0
			cell.number.TextColor3 = number == state.day and C.white or C.ink
			cell.mark.Visible = number == state.day
		else
			cell.number.Text = ""
			cell.mark.Visible = false
		end
	end
end

function refreshAll()
	local state = clockState()
	if state then
		ui.timeLabel.Text = state.time
		ui.dateLabel.Text = state.date
		ui.clockLabel.Text = state.digital
		ui.ampmLabel.Text = "오늘, " .. state.ampm
		ui.weekdayLabel.Text = state.weekday
		ui.dayLabel.Text = tostring(state.day)
		ui.monthLabel.Text = (state.year and (state.year .. "년 ") or "") .. state.month .. "월"
		ui.hourHand.Rotation = (state.hour % 12) * 30 + state.minute * 0.5
		ui.minuteHand.Rotation = state.minute * 6
		pcall(drawMonth, state)
	else
		ui.timeLabel.Text = "--:--"
		ui.dateLabel.Text = ""
		ui.clockLabel.Text = "--:--"
	end
	local _, hits, rate = statusContent()
	local percent = rate and string.format("%d%%", math.floor(rate * 100 + 0.5)) or nil
	ui.rateLabel.Text = percent or ""
	ui.batteryLevel.Visible = rate ~= nil
	if rate then ui.batteryLevel.Size = px(22 * math.clamp(rate, 0.06, 1), 8.5) end
	ui.ccHits.Text = hits or "명중 기록 없음"
	ui.ccSub.Text = env.RivalsVersion or "체크포인트 ?"
	ui.ccRate.Text = percent or "—"
	for _, refresh in ipairs(refreshers) do
		refresh()
	end
end

local zoom = { x = 0, y = 0, scale = 0.15, radius = 17 * S }
local ZOOM_KEY = "appZoom"

local function applyZoom(p)
	local value = math.clamp(p, 0, 1)
	local scale = zoom.scale + (1 - zoom.scale) * p
	ui.appScale.Scale = scale
	ui.appPage.Position = UDim2.new(0.5, zoom.x * (1 - p), 0.5, zoom.y * (1 - p))
	ui.appCorner.CornerRadius = UDim.new(0, (zoom.radius * (1 - value) + SCREEN_RADIUS * value) / math.max(scale, 0.02))
	ui.coverCorner.CornerRadius = ui.appCorner.CornerRadius
	local hide = math.clamp((p - 0.12) / 0.38, 0, 1)
	ui.cover.BackgroundTransparency = hide
	if ui.coverGlyph then
		if ui.coverGlyph:IsA("ImageLabel") then
			ui.coverGlyph.ImageTransparency = hide
		else
			ui.coverGlyph.Visible = hide < 0.5
		end
	end
	ui.homeScale.Scale = 1 - 0.06 * value
	ui.homeDim.BackgroundTransparency = 1 - 0.15 * value
end

local function zoomFrom(button)
	local ok, x, y, scale = pcall(function()
		local bp, bs = button.AbsolutePosition, button.AbsoluteSize
		local pp, ps = ui.screen.AbsolutePosition, ui.screen.AbsoluteSize
		local unit = ps.X / SCREEN_W
		return (bp.X + bs.X / 2 - pp.X - ps.X / 2) / unit, (bp.Y + bs.Y / 2 - pp.Y - ps.Y / 2) / unit, bs.X / unit / SCREEN_W
	end)
	if ok and type(x) == "number" and x == x and type(scale) == "number" and scale > 0.01 then
		zoom.x, zoom.y, zoom.scale = x, y, scale
	else
		zoom.x, zoom.y, zoom.scale = 0, 0, ICON_SIZE * S / SCREEN_W
	end
end

local function showHome()
	currentApp = nil
	ui.homePage.Visible = true
	Motion.spring(ZOOM_KEY, 0, { duration = 0.26, eps = 0.001 }, applyZoom, function()
		if currentApp == nil then ui.appPage.Visible = false end
	end)
end

function openApp(app, button)
	setControl(false)
	currentApp = app.id
	ui.appTitle.Text = app.name
	for id, body in pairs(pages) do
		body.Visible = id == app.id
	end
	if ui.coverGlyph then ui.coverGlyph:Destroy() end
	ui.cover.BackgroundColor3 = app.color
	ui.coverGlyph = glyph(ui.cover, app.icon, 36 * S, C.white, 51)
	ui.coverGlyph.Size = UDim2.fromScale(36 / ICON_SIZE, 36 / ICON_SIZE * SCREEN_W / SCREEN_H)
	if button then zoomFrom(button) end
	ui.appPage.Visible = true
	Motion.spring(ZOOM_KEY, 1, { duration = 0.3, eps = 0.001 }, applyZoom, function()
		if currentApp ~= nil then ui.homePage.Visible = false end
	end)
	refreshAll()
end

ui.backButton.MouseButton1Click:Connect(showHome)
ui.homeBar.MouseButton1Click:Connect(function()
	if controlOpen then
		setControl(false)
	else
		showHome()
	end
end)

local drag = nil

local function pressed(input)
	local kind = input.UserInputType
	return kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch
end

local function moved(input)
	local kind = input.UserInputType
	return kind == Enum.UserInputType.MouseMovement or kind == Enum.UserInputType.Touch
end

local function beginDrag(input, kind, signX, signY)
	local position = input.Position
	drag = { kind = kind, px = position.X, py = position.Y, x0 = win.x, y0 = win.y, s0 = win.scale, sx = signX, sy = signY }
end

local function updateDrag(input)
	if not drag then return end
	local position = input.Position
	local dx, dy = position.X - drag.px, position.Y - drag.py
	if drag.kind == "move" then
		local rawX, rawY = drag.x0 + dx, drag.y0 + dy
		win.x, win.y = rawX, rawY
		applyWindow()
		Motion.set("edgeX", rubberBand(rawX - win.x, 160), function(value) visual.edgeX = value end)
		Motion.set("edgeY", rubberBand(rawY - win.y, 160), function(value) visual.edgeY = value end)
		placeContainer()
		return
	end
	local width, height = viewport()
	local w0, h0 = BASE_W * drag.s0, BASE_H * drag.s0
	local scale = ((w0 + drag.sx * dx) / BASE_W + (h0 + drag.sy * dy) / BASE_H) / 2
	scale = math.clamp(scale, MIN_SCALE, maxScale(width, height))
	win.scale = scale
	win.x = drag.sx > 0 and drag.x0 or (drag.x0 + w0 - BASE_W * scale)
	win.y = drag.sy > 0 and drag.y0 or (drag.y0 + h0 - BASE_H * scale)
	applyWindow()
end

local function endDrag()
	if drag then
		drag = nil
		rememberWindow()
		Motion.spring("edgeX", 0, { duration = 0.26, eps = 0.05 }, function(value) visual.edgeX = value placeContainer() end)
		Motion.spring("edgeY", 0, { duration = 0.26, eps = 0.05 }, function(value) visual.edgeY = value placeContainer() end)
	end
end

ui.bezel.InputBegan:Connect(function(input)
	if pressed(input) and not drag then beginDrag(input, "move") end
end)
ui.statusBar.InputBegan:Connect(function(input)
	if pressed(input) and not drag then beginDrag(input, "move") end
end)
for _, entry in ipairs(grips) do
	entry[1].InputBegan:Connect(function(input)
		if pressed(input) then beginDrag(input, "resize", entry[2], entry[3]) end
	end)
end

local isOpen = false

local function showWindow(p)
	visual.lift = (1 - p) * 10
	visual.pop = 0.97 + 0.03 * p
	applyWindow()
end

local function setOpen(open)
	if not open then
		endDrag()
		releasePresses()
		sliderDrag = nil
		setControl(false)
	end
	isOpen = open
	pcall(function()
		ui.modal.Modal = open
	end)
	cfg.menuOpen = open
	setCursor(open)
	if open then
		ui.gui.Enabled = true
		refreshAll()
		Motion.spring("window", 1, { duration = 0.2, eps = 0.001 }, showWindow)
	else
		Motion.spring("window", 0, { duration = 0.12, eps = 0.001 }, showWindow, function()
			ui.gui.Enabled = false
		end)
		if dirty then save() end
	end
end

placeWindow(true)
Motion.set(ZOOM_KEY, 0, applyZoom)
Motion.set("control", 0, applyControl)
ui.appPage.Visible = false
ui.homePage.Visible = true
ui.gui.Enabled = false
Motion.set("window", 0, showWindow)
pcall(function()
	ui.modal.Modal = false
end)
cfg.menuOpen = false
refreshAll()

local pollClock = 0
local lastWidth, lastHeight = viewport()
table.insert(connections, RunService.Heartbeat:Connect(function(dt)
	pollClock += dt or 0
	if dirty and os.clock() - lastChange >= SAVE_AFTER then
		save()
	end
	if captionUntil > 0 and os.clock() >= captionUntil then
		captionUntil = 0
		Motion.spring(captionKey, 1, { duration = 0.3 }, function(value) ui.caption.TextTransparency = value end)
	end
	if pollClock >= 0.1 then
		pollClock = 0
		if isOpen then
			refreshAll()
		end
		local width, height = viewport()
		if width ~= lastWidth or height ~= lastHeight then
			lastWidth, lastHeight = width, height
			applyWindow()
		end
	end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if not moved(input) then return end
	if sliderDrag then
		sliderDrag(input.Position.Y)
	elseif drag then
		updateDrag(input)
	end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if not pressed(input) then return end
	sliderDrag = nil
	if drag then endDrag() end
	releasePresses()
end))

table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == TOGGLE_KEY then
		setOpen(not isOpen)
	elseif input.KeyCode == UNLOAD_KEY then
		unloadAll()
	end
end))

env.RivalsMenu = {
	gui = ui.gui,
	window = win,
	base = { w = BASE_W, h = BASE_H },
	settings = saved,
	assets = assets,
	Open = function(_, open) setOpen(open) end,
	Toggle = function() setOpen(not isOpen) end,
	Save = function() return save() end,
	Touch = function() touch() end,
	ResetWindow = function() resetWindow() end,
	CurrentApp = function() return currentApp end,
	ControlOpen = function() return controlOpen end,
	Features = FEATURE_KEYS,
}

env.RivalsMenuUnload = function()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	endDrag()
	if dirty then save() end
	cfg.menuOpen = false
	setCursor(false)
	Motion.stop()
	if env.RivalsMotion == Motion then env.RivalsMotion = nil end
	env.RivalsMenu = nil
	ui.gui:Destroy()
end

env.RivalsUnloadAll = function()
	for _, name in ipairs({ "RivalsAutoFireUnload", "RivalsAntiAimUnload", "RivalsEspUnload", "RivalsAimUnload", "RivalsBaseUnload", "RivalsPetUnload" }) do
		local unload = env[name]
		if type(unload) == "function" then
			pcall(unload)
		end
	end
	pcall(env.RivalsMenuUnload)
end

end)

run("pet", function()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local env = getgenv()
if env.RivalsPetUnload then
	pcall(env.RivalsPetUnload)
end
local cfg = env.RivalsCfg
if not cfg then return end

local PET_W, PET_H = 96, 72
local CAT_FILE = "rivals_pet_cat_v1.png"
local CAT_PNG = table.concat({
	"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",
})
local NEAR_DEATH = 0.3
local RECOVERED = 0.6

local menu = env.RivalsMenu
local settings = (menu and menu.settings) or {}
settings.pet = settings.pet or {}
local P = settings.pet
if type(P.show) ~= "boolean" then P.show = true end
if type(P.chatter) ~= "number" then P.chatter = 2 end
if type(P.swear) ~= "boolean" then P.swear = true end

local function touch()
	if menu and menu.Touch then menu.Touch() end
end

local SITUATIONS = {
	greet = { level = 1, priority = 2, lines = {
		"안녕 씨발 오늘도 잘 부탁한다", "왔다 ㅋㅋ 빨리 하자", "준비 끝! 가자 씨발", "오늘 컨디션 존나 좋은데?", "made by cost 펫이다 잘 부탁해 씨팔", "오늘도 같이 가자 ㄱㄱ", "존나 기다렸다고", "또 만났네 ㅋㅋ 반갑다",
		"오늘 몇 킬 따냄? ㅋㅋ", "출근 완료 ㅅㅂ", "스크립트 켜졌다 가자 씨발", "오늘도 이기러 왔지? ㄹㅇ", "준비됐냐? 난 됐다", "안녕 ㅋㅋ 뭐함", "오늘 목표는 무패다 씨발", "날씨도 좋고 판도 좋겠네 ㅋㅋ", "문 열자마자 달려왔다 ㅅㅂ",
		"어제 졌던 거 오늘 갚자 씨발", "준비운동은 했냐? 빨리해", "기다리느라 존나 심심했네", "오늘도 같이 잘해 보자 ㅅㅂ", "스크립트 깨어났다 씨발 가자", "컨디션 체크 끝 ㅇㅈ", "같이 이길 생각만 하자 ㄹㅇ", "오늘은 내가 기운 좀 줄게 씨발",
		"펫 출동 신고다 ㅋㅋ", "자 시작이다 씨발 가자", "무슨 판부터 할래? 빨리 골라", "오늘도 방 잘 잡았네 ㅋㅋ 개쩐다", "준비 다 됐으면 출발해 씨발", "나 말하는 거 들리냐? ㅋㅋ", "작은 펫이 인사한다 씨발", "오늘 플레이 뭐 할지 기대된다",
		"왔냐? 반갑다 ㅋㅋ", "다들 긴장 좀 풀고 가자 ㅅㅂ", "안녕 오늘 몇 킬 할 거냐?", "간식은 먹고 시작했냐? ㅋㅋ", "드디어 게임 시간이다 씨발", "눈 뜨니까 게임 시간이네 ㅋㅋ", "우리 팀 완전체 등장이다", "기운 빵빵하게 충전했다 씨발",
		"오늘은 무조건 잘될 듯 ㅋㅋ", "응원단 입장이다 씨발 ㅋㅋ", "목표는 무패다 씨발 가자", "지금부터 진짜 시작이다 ㄹㅇ", "오늘도 재밌게 하자 ㅋㅋ", "마우스 잡을 준비 됐냐?", "왔냐? 존나 기다렸다", "같이 놀 시간이다 씨발",
		"오늘 주인공은 우리다 ㅋㅋ", "커피는 들고 왔냐? ㅋㅋ 씨발", "오늘도 잘 부탁한다 주인아", "시작 버튼 소리 좋다 씨발", "오늘은 실력 자랑 날이다 ㅋㅋ", "뭐 하고 놀까나 씨발 심심하다", "오늘 운 좋은 날 같다 ㅋㅋ", "문제없지? 씨발 가자",
		"오늘 판 기대 만땅이다", "힘내서 가 보자 씨발", "또 만났네 ㅋㅋ 반갑다 씨발", "어제보다 더 잘할 수 있다", "쭉쭉 가자 씨발", "오늘도 같이라서 든든하다", "시작부터 기분 좋다 ㅎㅎ", "오늘 첫 판 존나 기대된다",
		"좋아 전투 준비 끝 ㅋㅋ", "이번엔 진짜 해 보자고 ㅅㅂ", "날씨도 좋고 판도 좋겠다 씨발", "어제 졌던 거 오늘 갚자 ㄹㅇ", "오늘 내가 기운 준다 ㅎㅎ 씨발",
	} },
	greetMorning = { level = 1, priority = 2, lines = {
		"아침부터 게임이냐 ㅋㅋ 미쳤네", "굿모닝 ㅅㅂ 밥은 먹었냐", "아침 게임 존나 상쾌하다", "일어나자마자 라이벌이냐 ㅋㅋ 미친", "아침 공기 개좋네", "눈곱도 안 떼고 왔냐 ㅋㅋ", "아침 한 판은 국룰이지 ㅇㅈ", "모닝 라이벌 시작이다 가자 ㅅㅂ",
		"출근 전에 한 판이냐 빡세네", "아침부터 손 풀자 씨발", "햇살 맞으면서 게임이라니 ㅋㅋ", "하루 시작은 승리다 이겨라", "아침엔 에임 존나 잘 맞더라", "커피 한 잔 빨고 가자", "아침형 게이머 납셨네", "해 뜬 지 얼마나 됐다고 게임이냐",
		"아침 햇살 맞으며 한 판 때리자 ㅅㅂ", "오늘 첫 판이 제일 중요한 거 알지", "샤워하고 왔냐 ㅋㅋ 냄새 좋네", "아침이라 머리 맑아서 존나 잘 맞을 듯", "일찍 일어났네 미친 대단한데", "모닝 커피 한 잔 때리고 가자",
		"아침 판은 집중력이 존나 좋아", "오늘 아침도 게임부터냐 ㅋㅋ", "새 하루 새 판이다 ㅅㅂ", "아침 공기 마시면서 존나 달리자", "하루 시작을 승리로 박자", "아침밥은 먹고 왔냐 안 먹었냐", "일어나자마자 라이벌 찾는 거 ㄹㅇ 찐이다",
		"아침부터 기운 넘치네 미친", "오전 판은 집중 존나 잘 돼", "일출 보며 게임하는 맛 개좋다", "아침 체조 한 번 하고 시작할까", "오늘 아침 첫 킬 따자 ㅅㅂ", "상쾌한 아침이다 가보자 시발", "아침 햇살 받으니 에임 개좋다",
		"모닝 세트는 게임이지 ㅋㅋ", "오늘 하루 존나 잘 시작해 보자", "손 덜 풀렸으면 천천히 해 인마", "눈 뜬 것만 해도 어디냐 ㅋㅋ", "아침 판 몰아칠 준비해 ㅅㅂ", "오늘 아침도 존나 활기차게 가자", "동 텄다 이제 사냥 시작이다",
		"아침 게임이 얼굴 깨워 주네", "눈 비비면서 기어왔네 ㅋㅋ", "아침 바람 존나 시원하네", "굿모닝 오늘도 잘해 보자 ㅅㅂ", "오전 기운 받아서 쓸어버리자", "밥 먹기 전에 한 판만 하자", "머리는 말리고 왔냐 ㅋㅋ",
		"아침부터 집중하는 거 ㄹㅇ 멋지네", "모닝 게이머 떴다", "잠 덜 깼으면 천천히 해", "아침 첫 승리 존나 먹자", "하루 중 제일 깨끗한 판이다 ㄹㅇ", "아침 이슬 같은 상쾌함 개쩐다", "바로 갈까 스트레칭부터 할까",
		"오늘 운세 존나 좋던데?", "대충 몸 풀고 바로 가자", "아침에 하면 성적 개좋더라", "햇살 아래서 무쌍 찍자 ㅅㅂ", "오전 판도 꿀잼 각이다", "일찍 깼네 칭찬해 ㅋㅋ", "아침 게임 루틴 완성이네 ㄹㅇ", "오늘 아침은 뭐 먹고 왔냐",
		"아침 공기가 게임 기운 준다", "깔끔하게 아침 판 시작한다", "하루 시작이 반이다 가자 ㅆㅂ", "아침부터 열정 뿜뿜이네 미친", "일어났냐 주인 ㅋㅋ 아침이다",
	} },
	greetNight = { level = 1, priority = 2, lines = {
		"밤늦게 왔네 존나 조금만 하자", "이 시간에 게임이냐 ㅋㅋ 나도 안 잔다", "야간 근무 시작이다 ㅅㅂ 또", "새벽 감성 개쩐다 ㄱㄱ", "밤 존나 깊었네", "올빼미 모드 ON ㅋㅋ", "조용한 밤에 한 판 존나 좋다", "밤샘은 안 된다 씨발 알지?", "야식 먹었냐 ㅋㅋ 배고프다",
		"새벽 랭크 가보자 빡세게", "밤엔 집중력 존나 좋지 ㄹㅇ", "늦었으니까 몇 판만 하자 ㅅㅂ", "달 떴네 ㅋㅋ 게임이나 하자", "졸리면 바로 말해 ㅋㅋ", "밤 게임 감성 존나 좋다", "밤은 길고 판은 짧다 씨발 가자", "야밤 전사 등장 ㅈㄴ 멋있네", "밤이라 집중 존나 잘 되네",
		"이 시간에도 같이 있어 줘서 고맙다 ㅅㅂ", "깜깜한 밤에 한 판 ㄱㄱ?", "야행성 게이머 등장 ㅋㅋ", "밤 게임 조용해서 존나 좋아", "새벽 감성 가득한 판이다 씨발", "밤이니까 살살 하자 ㅋㅋ", "다 잠든 밤에 우리만 싸운다 씨발",
		"밤 고요 속 전투 시작이다", "늦은 밤 판 짜릿하네 ㅅㅂ", "밤공기 쐬면서 하는 게임 개좋다", "오늘 밤도 불태워 보자 씨발", "밤에 제일 잘 맞는 거 같음 ㅋㅋ", "야심한 시각 사냥꾼 나왔다", "밤 깊을수록 집중 존나 된다",
		"이 시간에 게임 말고 뭐 하냐 씨발", "밤 판 시작이다 긴장 풀고 가자", "올빼미 파티 시작이다 ㅋㅋ", "졸지 말고 집중하라고 ㅅㅂ", "밤 도둑처럼 조용히 노리자", "야간 특근 시작이다 씨발", "밤이라 감성 충만 ㅎㅎ", "밤하늘 보면서 쏘는 기분 존나 좋다",
		"늦은 시간에도 힘내자 씨발", "오늘 밤 길게 가 볼까 ㅋㅋ", "밤 게임 역시 존나 맛이다", "깜깜한 맵이 더 멋있네 씨발", "한 판만 하고 자자 약속이다 ㅋㅋ", "야밤 라이벌 전쟁 시작이다 ㅅㅂ", "밤에도 쌩쌩하네 ㅋㅋ 개쩐다", "심야 전투 개시다 씨발",
		"밤샘 각오 됐냐 ㅋㅋ", "조용한 밤에 총소리 씨발 울린다", "야간 모드 ON 씨발 가자", "밤이라 손이 존나 날렵해지는 듯", "달빛 아래 한 판 가자 씨발", "밤 기운 받아서 한 판 가보자", "잠 안 자고 뭐 하냐 ㅋㅋ", "심야 게이머 자부심 씨발 쩐다",
		"늦게까지 같이 해 줘서 고맙다 ㅅㅂ", "밤에 하는 판은 뭔가 존나 특별함", "새벽 전투 준비 완료 씨발", "밤 되니까 적도 졸겠지 ㅋㅋ", "이 시간엔 집중이 최고다 씨발", "우리 둘이 밤 지키자 ㅅㅂ", "밤 판 명승부 가자 ㅈㄴ", "오늘 밤은 기필코 이긴다 씨발",
		"심야 판 긴장감 존나 좋다", "밤에 한 판 하면 개운하지 씨발", "조용한 밤을 총소리로 깨우자 씨발", "야밤 에이스 되어 보자 ㅋㅋ", "밤 되니까 더 신난다 ㅎㅎ 씨발", "잠은 판 끝나고 자자 씨발",
	} },
	poke = { level = 1, priority = 2, cooldown = 1, lines = {
		"간지럽다고 그만 좀 해 ㅋㅋ", "왜 불러 ㅅㅂ", "손 치워 ㅋㅋ", "아 뭐!", "방금 쓰다듬은 거냐 ㅋㅋ", "눌렀네? 어쩔 건데 ㅋㅋ", "뭐임?", "왜 왜 왜 ㅅㅂ ㅋㅋ", "나 바쁘다 꺼져", "한 번 더 누르면 진짜 삐진다", "찌르지 마 ㅅㅂ", "어? 불렀냐?",
		"털 날린다 ㅋㅋ 책임 안 짐", "심심해서 눌렀냐 ㅋㅋ", "나 여기 잘 있으니 신경 꺼", "왜 또 눌러 ㅅㅂ ㅋㅋ", "간지럽다니까 씨발!", "아 깜짝이야 씨발!", "눌러도 나 안 간다", "나 여기 있다고 ㅅㅂ", "찌르기 장인이네 ㅋㅋ", "또 누르게? 계속 눌러 봐",
		"방금 눈 뜨려던 참인데 ㅅㅂ", "쿡쿡 그만 찔러 좀", "떴다 떴어 눈 떴다고 ㅋㅋ", "나 인형 아니거든 ㅅㅂ!", "장난치는 거 다 안다 ㅋㅋ", "눌러도 간식은 안 나온다", "찌르면 말할 줄 알았냐", "이 손가락 누구 거냐 ㅋㅋ",
		"심심하냐? 나도 존나 심심해", "오늘도 또 누르네 ㅋㅋ 고맙다", "툭툭 치지 마 ㅋㅋ 짜증나", "뭐야 뭐야 왜 불러 씨발", "털 고르는 중이었는데 ㅅㅂ", "귀여워서 누르는 거 맞지?", "사실 존나 좋음 ㅋㅋ", "찌르면 한마디 하는 게 내 특기",
		"봐 들었지? 말했다 ㅋㅋ", "눌렀으면 책임져라 ㅋㅋ", "건드려도 되는데 살살 해 ㅅㅂ", "아파 ㅅㅂ 농담이다 ㅋㅋ", "그만 누르고 게임이나 해", "놀랐잖아 갑자기 누르지 마", "나 말하는 펫인 거 몰랐냐", "이게 쓰다듬는 거냐 찌르는 거냐",
		"심장 떨어질 뻔했다 ㅅㅂ", "지금 바쁜데 왜 부르냐 ㅋㅋ", "눈 마주쳤네 뭘 봐", "누르면 반응하는 거 재밌냐", "좋아 한 번 더 눌러 봐 ㅋㅋ", "건드림 감지됨 꺼져 ㅋㅋ", "찔러도 소용없다 ㅋㅋ", "명상 중이었다 닥쳐 ㅋㅋ",
		"이 정도 찌름은 봐준다", "나도 체력 있거든 ㅋㅋ 아프다", "관심은 고마운데 꺼져 ㅋㅋ", "포크로 찍힌 느낌이다 ㅋㅋ", "버튼 달린 줄 알았냐 ㅋㅋ", "누르는 게 취미냐 ㅅㅂ", "진짜 한 번만 더 눌러 봐", "그래 내가 존나 귀엽긴 하지",
		"알았어 알았다고 말할게", "툭! 찌르기 성공했네 ㅋㅋ", "눌린 김에 한마디 한다", "잘 누르네 손 존나 빠르다", "찌르기 실력 인정한다", "뭐야 이거 ㅋㅋ 어이없네", "깜짝 놀랐잖아 ㅅㅂ", "눌렀냐? 어 나 여기 있다",
	} },
	pokeSpam = { level = 1, priority = 3, cooldown = 15, lines = {
		"그만 누르라고 씨발!! ㅋㅋ", "나 장난감 아니거든 씨발", "손가락 존나 아프겠다 ㅋㅋ", "계속 누르면 물어버린다?", "그만 누르라고 ㅅㅂ 그만~", "으앙 씨발 그만해!", "계속 누르면 한 대 맞는다?", "손가락 운동 중이냐 ㅋㅋ", "나 개빡쳤다 ㅋㅋ", "누르기 대회 나가냐 미친",
		"멈춰 씨발!! 진짜", "어지러워 죽겠네 ㅋㅋ", "게임이나 좀 집중하자 ㅅㅂ", "더 누르면 숨어버린다?", "나 고장 나겠다 씨발 ㅋㅋ", "아 진짜 그만 좀 눌러 씨발!", "나 지금 존나 어지럽다 ㅋㅋ", "잠깐만 쉬자 손가락도 쉬고", "눌러도 간식은 없다 씨발 ㅠ",
		"이 정도면 취미생활 아니냐", "누르기 기록 세우는 중이냐 ㅋㅋ", "더 누르면 존나 화낸다!", "나 펫인데 스트레스 존나 받는다 ㅋㅋ", "지금 세 번째 눌림이지? 뭐임", "손가락 근육 키우는 거냐 ㅋㅋ", "그만 누르라고 제발 씨발",
		"진짜 그만 누르면 게임 잘 도와준다", "나 피곤하다 씨발 ㅠ 좀 쉬자", "이렇게 찌르면 나 삐질 거야 씨발", "몇 번 눌렀는지 세고 있다 ㅋㅋ", "그만! 그만! 씨발 그만!", "쿡쿡 연타 금지다 ㅋㅋ", "나 이제 숨는다 찾지 마 씨발",
		"혹시 나랑 얘기하고 싶냐 ㅋㅋ", "나 지금 털 다 빠진다 씨발 ㅋㅋ", "연타 대회냐 나도 참가한다 ㅋㅋ", "손가락 존나 피곤하지 않냐", "그만 찌르면 칭찬 한 번 해 준다", "눌림 과다 감지됐다 씨발!", "나도 쉬고 싶다 ㅠ 제발",
		"눌러 주는 건 좋은데 적당히 ㅋㅋ", "나 지금 감정 폭발 직전이다 씨발", "이쯤 되면 칭찬 줘야 되는 거 아냐", "그만 눌러 줘 진심이다 씨발", "나 도망간다 ㅅㅂ!", "누르기 마스터 등장 ㅋㅋ 존나 대단", "이건 장난 아니다 ㅅㅂ!", "연속 찌르기는 반칙이다 씨발",
		"나 쫓아오면 안 돼 씨발 ㅋㅋ", "펀치 날릴 준비 한다 ㅋㅋ", "여기까지! 이제 진짜 그만 씨발", "찌르는 재미 쏠쏠하지 씨발?", "나 지금 웃음 참는 중 ㅋㅋ", "이 연타 실력 게임에 써 봐 씨발", "그만하면 다음 판 도와준다", "진짜 진짜 그만이라고 씨발!",
		"눌러서 해결될 일 아니다 씨발", "쉬는 시간 좀 주라 씨발", "네 손가락 칭찬해 ㅋㅋ", "나 이제 말 안 한다 흥 씨발", "조용히 있을 테니까 그만 눌러 씨발", "지금 몇 번째냐 씨발 ㅋㅋ", "찌르기 금지 구역 선포다 씨발!", "눌러도 나는 안 움직인다 씨발",
		"누르기 대회 우승했다 축하해 ㅋㅋ", "진짜로 멈춰 달라고 씨발", "그만 좀 누르라니까 ㅅㅂ!", "눌림 과다라고 경고한다 ㅋㅋ", "손 존나 빠르다 빨라", "펫 혹사 금지다 존나!",
	} },
	petMoved = { level = 2, priority = 1, cooldown = 10, lines = {
		"여기가 좋냐? 뭐 나쁘진 않네", "이사 왔다 ㅋㅋ 씨발 신난다", "뭐임 갑자기 자리 바꾸네 ㅋㅋ", "여기 뷰 존나 괜찮네", "오 씨발 새 자리다", "크 여기 좋네 ㅇㅈ", "새 둥지다 ㅅㅂ 마음에 든다", "여기서 존나 잘 보인다", "옮겨 줘서 땡큐 ㅋㅋ", "이 자리 ㄹㅇ 맘에 든다", "구석탱이가 편하긴 하지",
		"여기 존나 따뜻하네", "자리 잘 골랐네 ㅇㅈ", "여기서 응원한다 파이팅 ㅅㅂ", "이사 완료 ㅇㅋ", "이 자리가 제일 좋은 듯 ㅇㅈ", "여기서 보니까 화면 개잘 보이네", "아 자리 옮겨 줘서 고맙다 ㅋㅋ", "이사 끝 집들이 안 하냐 ㅋㅋ",
		"여기 바람 시원하네 미친", "좋아 여기가 내 자리다 ㅅㅂ", "방 구조 맘에 드네 씨발", "옮기고 나니 기분 새롭네", "여기서 응원하면 더 잘 되겠지 ㅋㅋ", "구석보다 여기가 낫네 ㅇㅈ", "자리 센스 좀 있는데? 인정", "새 자리에서 잘 지켜본다 ㅅㅂ",
		"여기서 보면 다 보인다니까", "이 위치 딱이네 ㄹㅇ", "옮겨 놓으니 든든하네", "편한 데로 오니 기분 개좋다", "이사하니까 설렌다냥 ㅋㅋ", "여기 정착한다 씨발", "옆 자리로 옮겼구만 ㅇㅋ", "배치 완벽하다 ㅅㅂ!",
		"여기 있으면 방해 안 되겠지?", "화면 한구석이 좋다 ㅇㅇ", "이제 여기서 쭉 있는다 씨발", "자리 잘 골랐다 칭찬해 준다", "더 좋은 자리 찾았네 ㅅㅂ", "옮긴 김에 인사 한번 한다 ㅋㅋ", "여기 공기가 다르네 미친", "ㄹㅇ 이 자리 괜찮다",
		"구경하기 개좋은 자리네", "여기가 명당이지 임마", "나도 이사하니 개좋네", "옮겨 준 덕에 편하네", "오, 여기 뷰 좋은데? ㅅㅂ", "자리 바꾸는 센스 있네 ㅋㅋ", "이 정도면 합격이다 ㅇㅈ", "여기서 보니까 나 더 귀엽지 않냐 ㅋㅋ",
		"새 집 마음에 쏙 든다 ㅅㅂ", "여기서 응원 열심히 해 준다", "이 자리 오래 쓸 듯 ㅇㅇ", "자리 바꾸니 기분 전환 존나 된다", "오늘 이사 잘했네 ㅇㅈ", "다음에 또 옮겨 줘도 된다 인정", "여기가 내 구역이다 꺼져!", "자리 잡았다 완료 ㅇㅋ",
		"이사 기념으로 한 판 어때 ㅅㅂ", "여기서 보는 게 더 편하네 ㅇㅇ", "좋은 자리 찾아 줘서 땡큐다", "이 자리에서 잘 지켜본다 ㄹㅇ", "옮긴 위치 저장해 둔다 ㅇㅋ", "새 자리 적응 끝났다", "여기가 딱 좋다 ㅅㅂ", "여기 자리 괜찮은데? 뭐 인정",
		"이사 완료다 ㅅㅂ!", "옮긴 김에 인사한다 안녕", "새 자리 마음에 든다 ㅇㅇ",
	} },
	idle = { level = 3, priority = 1, lines = {
		"아 씨 심심해 미치겠네", "물은 마셨냐 ㅅㅂ 좀 마셔", "자세 똑바로 해 ㅅㅂ", "..zzZ 씨발 졸려", "오늘 날씨 ㅈㄴ 좋나?", "간식 내놔 ㅋㅋ", "하품 존나 나오네", "기지개 한번 쭉 켠다", "꼬리 흔드는 중이다 ㅋㅋ", "뭐 재밌는 거 없냐 ㅅㅂ", "털 고르는 중 ㅋㅋ 꺼져", "창밖 구경 중이다",
		"나 낮잠 잔다 깨우지 마", "츄르 먹고 싶다 ㅅㅂ", "오늘 몇 판 했냐?", "하늘 존나 맑다 게임 말고 산책 가자", "나 방금 졸았다 ㅋㅋ", "오늘 저녁 뭐 먹냐?", "내 털 오늘도 윤기 개쩌네", "간식 생각나서 미치겠네",
		"창밖에 새 지나가네 ㅋㅋ", "꼬리가 지 멋대로 움직여 ㅋㅋ", "기지개 한 번 더 켠다", "이 게임 음악 ㅈㄴ 좋다", "낮잠 자고 싶다 진짜 냥", "오늘 하루 어땠냐?", "존나 조용하네", "음 뭐 하지 고민 중임", "털뭉치 날린다 ㅋㅋ 피해라",
		"움직이기 존나 귀찮다", "배에서 꼬르륵 소리 났다 ㅅㅂ", "내 장난감 어디 갔냐 씨발", "하품 크게 한번 때린다", "눈 감고 쉬는 중이다", "깜빡깜빡 존나 졸리다", "밖에 날씨 어떠냐?", "어디서 고소한 냄새 나는데?", "우리 판 언제 시작하냐 ㅅㅂ",
		"노래 흥얼거리는 중 ㅋㅋ", "머리 긁적긁적 ㅋㅋ", "나도 하고 싶은 거 존나 많아", "오늘도 평화롭네 ㅋㅋ", "쉬는 것도 실력임 ㅇㅈ?", "나 앉아서 쉬는 중이다 꺼져", "발바닥 존나 간지럽네", "손님 안 오냐 기다리는 중", "귀 쫑긋쫑긋 ㅋㅋ",
		"게임 얘기 말고 딴 얘기 하자 ㅅㅂ", "지금 몇 시냐 ㅅㅂ", "내 자리 아늑해서 개좋네 ㅋㅋ", "음악 틀어 줘? ㅋㅋ", "천천히 가 좀 천천히", "물 한 잔 마시고 싶네", "뭐가 재밌을지 생각 중", "숨 고르는 중이다", "하루가 존나 길다",
		"나 오늘 존나 게으르다 ㅋㅋ", "그냥 가만히 있고 싶다 ㅅㅂ", "뒹굴뒹굴 ㅋㅋ", "나 지금 명상 모드다 조용히 해", "이 시간이 제일 평화롭다", "잠깐 멍 때리는 중이다", "같이 좀 쉬어 주라 ㅅㅂ", "오늘은 느긋하게 가자 ㅇㅋ", "귀여운 생각하는 중 ㅋㅋ",
		"조용한 것도 좋다 냥", "다음 판은 뭘로 갈까?", "쉬면서 기운 충전하는 중임", "아 진짜 심심하다 ㅋㅋ", "가만히 있으니까 졸려 뒤지겠네",
	} },
	nightOwl = { level = 2, priority = 1, cooldown = 1800, lines = {
		"벌써 이 시간이냐 내일 괜찮냐", "슬슬 자야 하지 않냐 씨발", "눈 안 아프냐 좀 쉬자 ㅇㅈ", "새벽이네 ㄷㄷ 한 판만 더 ㅋㅋ", "새벽 2시 넘었을걸 씨발", "내일 피곤할 텐데 ㅋㅋ", "마지막 판 하고 자자 씨발", "부모님 깨시겠다 ㅋㅋ",
		"잠도 실력이다 ㅇㅈ", "자고 일어나면 더 잘 맞음 ㅇㅈ", "밤새면 에임 씨발 흔들려", "이불이 부른다 ㅋㅋ 씨발", "물 마시고 자자 씨발", "오늘은 여기까지 씨발 ㅇㅈ", "늦었다 씨발 ㅠ", "시계 보니까 벌써 새벽이다 ㅅㅂ", "이 시간엔 쉬어야 하는데 ㅠ",
		"내일 아침 어떻게 일어나냐 씨발", "밤샘 게이머 최후가 보인다 ㅋㅋ", "눈 빨개지는 거 같다 씨발", "잠 안 자면 키 안 큰다 ㅋㅋ", "지금 자면 꿀잠이다 씨발", "피곤해 보이는데 괜찮냐", "눈 좀 감았다 뜨자 씨발", "새벽 게임은 중독이다 ㅅㅂ",
		"이 판 끝나면 자자 제발 씨발", "잠도 중요하다고 했잖아 씨발", "베개가 그립다 ㅠ 씨발", "밤늦게 하면 머리 아프다 씨발", "내일 일정은 괜찮냐 씨발", "지금 쉬면 내일 더 잘함 ㅇㅈ", "졸린 상태로 하면 위험하다 씨발", "눈 아프면 말해 씨발",
		"물 한 잔 하고 와 씨발", "새벽 감성 충분하다 이제 쉬자", "밤 진짜 깊었다 씨발", "조용히 자러 갈 시간이다 씨발", "잠 깨려고 세수했냐 ㅋㅋ", "이 시간에 내가 깨있다니 ㅋㅋ", "오늘 하루도 수고했다 씨발", "잠깐만 쉬어도 좋다 ㅇㅈ",
		"잠이 솔솔 오는 시간이다 씨발", "이불이 기다리고 있을걸 씨발", "눈 깜빡이는 게 느려졌다 씨발", "슬슬 정리하자 씨발", "지금 안 자면 나도 못 잔다 ㅠ", "내일을 위해 쉬자 씨발", "새벽 세 시 넘었는데 씨발?", "잠 아껴서 뭐 하냐 씨발",
		"꿈나라 같이 가자 씨발", "눈 쏟아질 것 같다 씨발", "지금 끄면 기분 더 좋다 씨발", "내일 더 재밌게 하려면 자자", "밤샘 위험 감지 씨발", "하품 연속 발사 중 ㅋㅋ", "잠 못 드는 게 제일 힘들지 씨발", "나도 졸리다 같이 자자 씨발",
		"정신 차리고 쉬자 씨발", "오늘은 여기서 끝내자 씨발", "배터리 방전 직전이다 씨발", "잠 부족하면 에임 흔들린다 씨발", "슬슬 불 끄고 자라 씨발", "편히 잘 자라 주인", "꿈에서도 이기자 ㅋㅋ", "잠깐 눈 붙이고 와 씨발", "푹 자는 게 실력이다 씨발",
		"자는 게 최고의 버프다 ㅇㅈ", "이만 쉬어라 제발 씨발", "눈 감고 10초만 쉬어 씨발", "잠 깨면 또 같이 하자 씨발",
	} },
	longSession = { level = 2, priority = 1, cooldown = 3000, lines = {
		"한 시간 넘었다 ㅅㅂ 스트레칭 해", "존나 오래 했네 물 한 잔 마셔", "눈 좀 쉬어라 진짜", "%s분째 하는 중 ㅋㅋ 체력 미쳤네", "허리 펴 쭉 ㅅㅂ", "눈 감고 10초만 쉬자", "화장실 좀 다녀와 ㅋㅋ", "손목 좀 돌려", "간식 먹을 시간 아니냐?",
		"%s분째냐 미친 ㅋㅋ 대단하다", "잠깐 일어나서 걷자 ㅅㅂ", "목 스트레칭 해 목!", "물 마셨냐 안 마셨냐", "쉬었다 하면 더 잘 된다니까", "오래 했으니까 눈 좀 깜빡여", "두 시간째인데 손목 안 아프냐", "엉덩이 존나 아프겠다 ㅋㅋ",
		"한 시간 넘었으니 물 좀 마셔", "눈 뻑뻑하면 잠깐 감고 있어", "밥은 먹었냐? 아직이면 먹고 와", "오래 했으니 스트레칭 한 번 해", "여태 잘했다 인정해 ㅋㅋ", "쉬는 것도 실력이다 냥", "몸 존나 굳었겠다",
		"목 돌리기 한 번 해봐 ㅅㅂ", "피로 쌓이는 중이다 진짜로", "이쯤 되면 쉬어야지", "오래 하는 건 쩌는데 건강도 챙겨", "커피 말고 물 마셔라 제발", "너무 오래 앉아 있었다 ㅅㅂ", "화장실 다녀오는 건 어떠냐",
		"눈 10초만 쉬어 좀", "자세 똑바로 해 구부정하다", "손가락 좀 풀어 ㅋㅋ", "오늘 존나 많이 했다", "지금 쉬면 다음 판 더 잘 됨", "오래 하면 집중력 존나 떨어짐", "한 번 일어나서 걸어봐", "어깨 펴고 숨 크게 쉬어",
		"몸 소중하니까 챙겨라", "피곤하면 바로 말해 ㅇㅋ?", "이 정도면 충분히 열심히 했다", "걷는 게 최고 휴식이다 ㅇㅈ", "배 안 고프냐 간식 먹자", "목 뻣뻣해 보인다 ㅋㅋ", "장시간 플레이 감지됐다 ㅅㅂ",
		"오래 한 만큼 쉬는 것도 중요하다", "눈 깜빡이기 훈련 해볼래", "앞으로 몇 판 더 할 거냐", "쉬고 와 기다려 줄게 ㅋㅋ", "잠깐 일어나서 기지개 켜", "오늘 체력 존나 썼다", "지금 쉬면 판 더 재밌어진다",
		"두 시간 연속은 좀 길다 ㅅㅂ", "손목 보호대 있냐 ㅋㅋ", "잠깐 멈추면 세상이 달라 보인다", "휴식 알림 울렸다 좀 쉬어 ㅅㅂ", "등 쭉 펴고 쉬자", "몸이 보내는 신호 좀 들어라", "오래 한 날은 물 두 배로 마셔", "조금 쉬고 다시 가자 ㅅㅂ",
		"피곤이 쌓이면 실력도 떨어진다", "눈에 찬 바람 쐬러 가자", "건강한 게이머가 오래 간다 ㄹㅇ", "잠깐 밖에 나가봐 좋겠다", "조금만 쉬어도 기분 달라진다", "오늘 많이 달렸다 수고했다 ㅋㅋ", "장기전엔 체력 관리가 답이다",
		"슬슬 몸 챙길 타이밍이다", "스트레칭 3종 세트 ㄱ?",
	} },
	open = { level = 2, priority = 1, cooldown = 6, lines = {
		"왜 불렀냐 ㅋㅋ", "설정 만지게? 빨리 해라 ㅅㅂ", "뭐 바꿀 건데 씨발", "나 여기 있다 ㅋㅋ", "앱 눌러서 바꾸면 되잖아 ㅋㅋ", "뭐 해줄까 말만 해", "ㅅㅂ 메뉴 열렸네", "골라 골라 빨리 골라 ㅋㅋ", "설정 시간이다 씨발", "천천히 봐 안 급하니까", "뭘로 할 건데 ㅋㅋ", "오 메뉴 떴다 ㅋㅋ",
		"필요한 거 있냐 말해", "켜고 끄는 건 여기서 하는 거다", "내가 옆에 있어 줄게 ㅋㅋ", "메뉴 열렸다 뭐부터 볼 건데", "여기 존나 많네 ㅋㅋ", "기능 목록 보는 중이네 ㅋㅋ", "오 설정 시간이네 ㅇㅋ", "천천히 골라 ㅋㅋ", "눌러 보고 싶은 거 있으면 눌러 ㅅㅂ",
		"이 메뉴 ㅈㄴ 예쁘지?", "뭘 바꿀지 고민하네 ㅋㅋ", "아이콘 하나씩 눌러 봐 ㅅㅂ", "설정 바꾸면 바로 적용된다", "여기서 다 조절된다고", "오늘은 뭐 켤 건데 ㅋㅋ", "나 메뉴 구경 존나 좋아함 ㅋㅋ", "새로 추가된 거 봤냐 ㅈㄴ 많던데",
		"필요한 거 찾았냐?", "여기서 자세히 볼 수 있다고", "앱 하나 열어 봐 ㅋㅋ", "기록 메뉴도 있으니까 확인해", "설정 저장은 자동이니까 걱정 마", "메뉴 열린 김에 이것저것 만져 봐", "아무거나 눌러도 안 죽는다 ㅋㅋ", "여기서 보니까 든든하네 ㅋㅋ",
		"메뉴 탐험 시작이다 ㅅㅂ", "궁금한 거 있으면 말해 씨발", "스위치 끄고 켜는 것도 꿀잼", "오늘은 설정 좀 만져 볼까 ㅋㅋ", "화면 깔끔해서 개좋다", "이 앱은 뭐 하는 거임?", "에임 메뉴부터 열어 봐 ㅋㅋ",
		"펫 설정도 여기 있다고 ㅅㅂ", "마음에 드는 색 있으면 좋겠네", "메뉴 열면 나도 신난다 ㅋㅋ", "필요한 거 골라서 쓰면 됨", "설정 더 보려면 아래로 내려 ㅅㅂ", "와 기능 존나 많다 ㅋㅋ", "천천히 훑어보자 ㅇㅇ",
		"바꾸고 싶은 거 있으면 말해", "처음 보는 거 있지 ㅋㅋ", "오늘 설정 점검하는 날이네 ㅋㅋ", "여기서 모든 게 시작된다 씨발", "구석구석 다 봐라 ㅋㅋ", "조절할 수 있는 거 존나 많네", "메뉴에서 손 떼지 마 ㅋㅋ", "뭐부터 켤지 골라라 ㅅㅂ",
		"앱 아이콘 눌러서 들어가 봐", "이 화면 보기 좋다 ㅋㅋ", "여기 있으면 든든하다 ㅇㅇ", "설정 끝나면 바로 게임 가자 ㅅㅂ", "메뉴 하나하나 설명해 줄까 ㅋㅋ", "뭐가 마음에 드냐 말해봐", "뭐든 바꿔도 된다고", "눈에 띄는 거 있냐",
		"설정 좀 자주 봐라 ㅅㅂ", "차근차근 해 보자 ㅋㅋ", "메뉴 열렸네 뭐부터 볼 거냐",
	} },
	menuClose = { level = 3, priority = 1, cooldown = 20, lines = {
		"다 바꿨냐? 씨발 가자!", "설정 끝 ㅋㅋ 존나 빨리 가자", "이제 싸우러 가자 씨발", "좋아 다시 게임이다!", "준비 끝 ㅅㅂ 가자", "출발이다 존나 빨리", "다시 사냥 시작! 씨발", "좋아 좋아 ㅋㅋ", "설정 저장했다 ㄹㅇ 끝", "이제 집중하자 씨발", "가자고 ㅈㄴ 빨리", "메뉴 닫았다 씨발 드디어",
		"전투 모드 복귀다", "좋은 선택이네 ㅋㅋ", "이제 쏘자 씨발!", "설정 끝! 이제 진짜 간다", "좋아 세팅 완료 ㅅㅂ", "메뉴 닫고 집중 모드 ON", "바뀐 설정 잘 먹혔겠지 씨발", "다 골랐으면 출발해라", "이제 싸우러 가자고 ㅋㅋ",
		"준비 끝났다 씨발 가자!", "메뉴 닫았다 씨발 전투 시작", "설정 저장 완료 ㅇㅋ", "좋은 선택이었다 ㅋㅋ", "이제 게임만 보자 씨발", "잘 골랐네 칭찬해 줄게", "다시 사냥터다 씨발!", "눈 감고도 쏠 준비 됐다", "메뉴 탐험 끝 ㅅㅂ",
		"이제 화면 보면서 가자", "잘 설정했으니 믿어도 되지", "다음은 게임 속 내 차례다 씨발", "마무리 잘했다 ㅋㅋ", "좋아 좋아 씨발 출발", "이 세팅으로 존나 이기자", "메뉴 치웠다 깔끔하네", "자 이제 실전이다 씨발", "설정 끝 기대된다 ㅋㅋ",
		"세팅 완벽! 씨발 가자 가자", "준비됐으니까 나가자", "이제부터 실력 싸움이다 씨발", "메뉴 닫고 게임 속으로! ㅅㅂ", "좋은 세팅이다 ㅎㅎ", "이제 진짜 시작이다 씨발", "설정 마쳤다 다행이네", "바로 가자 망설이지 말고 씨발", "잘했어 주인 ㅋㅋ",
		"메뉴 정리 끝났다 씨발", "오늘 설정 괜찮은데 ㄹㅇ", "자 이제 쏘러 가 볼까 씨발", "잘 저장했으니 걱정 없다", "출동 준비 완료 ㅅㅂ", "메뉴 나가니까 개운하다", "설정 끝났으면 게임하자 ㅋㅋ", "이 세팅 믿고 간다 씨발", "좋아 화면 봐라",
		"게임 화면으로 복귀! ㅅㅂ", "다 골랐구나 멋있다 씨발", "나도 준비 끝났다 ㅋㅋ", "설정 덕분에 자신 있다", "이제 판이 기다린다 씨발", "메뉴 끄고 사냥하자 ㅅㅂ", "준비 운동 끝났다", "이 상태로 쭉 가자 씨발", "자 이제 실전 가 보자",
		"설정 확인 완료 ㅇㅋ", "이제 누구든 와 봐 ㅋㅋ 씨발", "좋아 세팅 완료다 ㅅㅂ", "메뉴 닫았다 전투 시작 씨발",
	} },
	menuLongOpen = { level = 2, priority = 1, cooldown = 120, lines = {
		"메뉴만 쳐다보고 있냐 ㅋㅋ", "뭘 그렇게 고민하냐 ㅅㅂ", "천천히 골라 인마 기다려 줄게", "메뉴 구경 존나 오래 하네", "메뉴 오래 보다 총 맞는다 ㅋㅋ", "하나 고르는 게 그렇게 어렵냐", "그냥 다 켜 ㅋㅋ 뭐 어때", "야 게임 중인 거 잊지 마 ㅅㅂ", "아직도 고르냐 미친",
		"ㅇㅋ 천천히 해 인마", "적이 기다리고 있다고 씨발", "메뉴 탐험 중이네 존나 오래", "뭐가 그렇게 고민이냐 진짜", "다 좋아 보이지 ㅋㅋ", "결정했냐 그래서 시발", "이것저것 다 건드리네 미친", "메뉴 탐험이 존나 길어지네", "고민 존나 하네 천천히 해라",
		"뭐가 제일 좋을지 고민 중이냐", "시간 존나 쓰네 ㅋㅋ", "못 고르겠으면 기본값으로 가 ㅅㅂ", "메뉴에서 존나 오래 있네", "판 시작 전에 빨리 골라 ㅆㅂ", "설정은 이 정도면 충분하다니까", "하나씩 바꿔 보는 건 ㅇㅈ",
		"이제 결정했냐 씨발", "기다리다 하품 나온다 ㅈㄴ", "천천히 해 나 기다릴 거니까", "혹시 길 잃었냐", "설정 존나 많아서 헷갈리지", "메뉴 보느라 판 멈췄잖아 ㅅㅂ", "적 기다리고 있을지도 몰라 ㅈㄴ 위험해", "이쯤에서 하나 정해 씨발",
		"다 골랐으면 좀 닫아라 ㅅㅂ", "고민할 때 귀엽네 ㅋㅋ 미친", "빨리 골라야 게임을 하지 ㅅㅂ", "메뉴 구경 끝나면 말해 ㅋㅋ", "내가 골라 줄까 ㅋㅋ", "이 메뉴 오래 보면 눈 존나 아프다", "한 번에 다 바꾸긴 힘들지 ㅇㅈ", "눈 좀 쉬고 다시 봐",
		"다 되면 손 흔들어 ㅋㅋ", "메뉴 열고 한참이네 ㅅㅂ", "설마 못 고르는 거냐 ㅋㅋ", "지금 고른 거 개괜찮아 보인다", "고민은 판 끝나고 해라 ㅅㅂ", "메뉴 좀 줄여 볼까", "여기서 제일 중요한 건 에임이다 씨발",
		"고장 난 줄 알았다 ㅋㅋ", "천천히 음미하면서 골라라", "많이 봤으니까 이제 좀 골라라 ㅅㅂ", "설정 다 봤으면 게임 시작하자", "오래 걸리는 만큼 신중한 거겠지", "메뉴에 빠졌네 ㅋㅋ", "눈에 익은 거 있냐",
		"판 시작 시간 다가온다 ㅈㄴ 빨리", "설정 끝나면 나랑 얘기해", "메뉴 열고 졸지 마 ㅋㅋ", "알아서 잘 고를 거라 믿는다", "어떤 게 제일 맘에 드냐 말 좀 해", "고른 거 있으면 바로 적용해", "다들 기다리고 있을 수도 있다고 ㅅㅂ",
		"메뉴 보느라 바쁘네 냥 ㅋㅋ", "이제 결론 좀 내라 씨발", "시간 가고 있다고 ㅅㅂ", "같이 고민하는 것도 꿀잼이네", "메뉴 열어 놓고 쉬지는 마", "메뉴에서 길 잃은 거냐 ㅋㅋ", "고르기 어렵지 천천히 해 ㅋㅋ", "설정 구경 존나 오래 하네",
	} },
	toggleOn = { level = 2, priority = 1, cooldown = 2, lines = {
		"%s 켰다!! 씨발 가자", "%s 켜졌다 ㅋ 이제 좀 되네", "오 %s 간다 씨발 실화냐", "%s 준비 끝 ㅅㅂ 죽이러 간다", "%s ON!! 존나 기대된다", "%s 가동 씨발 이제 시작", "%s 다시 일한다 ㅋ 쫄지 마라", "%s 출동 씨발 간다", "%s 켰냐? 씨발 좋네", "%s 활성화 완료 ㅋㅋ 개좋다", "%s 들어간다!! 씨발 비켜라", "%s 깨웠다 ㅋㅋ 이제 시작이다",
		"%s 믿고 간다 씨발 터뜨린다", "%s 켜놓으니 존나 든든하다", "%s 시작!! 씨발 달린다", "%s 켰다! 존나 든든하네 ㅋㅋ", "%s 들어갔다 씨발 가보자고", "%s 깨어났다 ㅎㅎ 씨발 개좋다", "%s 켜졌으니 이제 준비 끝이다 씨발", "%s 기능 가동 씨발 시작!", "%s 켜니까 믿음직하네 ㅋ 씨발",
		"%s 돌아왔다 씨발 ㅋㅋ", "%s 가동 중 씨발 쭉 밀어붙이자", "%s 켜져서 존나 마음 놓인다", "%s 활성화 됐다 씨발 좋다", "%s 시작하자 ㅋㅋ 씨발 가자", "%s 이제 일하러 간다 씨발", "%s 불 켜졌다!! 미친 실화냐", "%s 가동 완료 확인 ㅇㅈ 씨발",
		"%s 켜고 나니 존나 기분 좋다", "%s 다시 출동!! 씨발 가자", "%s 들어왔냐 씨발 환영한다", "%s 켜놨으니 든든하다 ㅋㅋ", "%s 기능 살아났다 씨발 ㄹㅇ", "%s 이제 같이 가자 씨발", "%s 깨웠냐 씨발 고맙다 ㅋ", "%s 준비됐다 씨발 쏘자",
		"%s 켜지면 싸움이 존나 달라진다", "%s 든든한 아군 등장 ㅋㅋ 씨발", "%s 활성 상태 좋다 씨발 ㅋ", "%s 시동 걸렸다 씨발 달린다", "%s 이제 정신 차렸다 씨발", "%s 가동 씨발 실력 보여준다", "%s 전원 ON 완료 ㅅㅂ 가자", "%s 켜져 있으니 존나 안심된다",
		"%s 같이 달리자!! 씨발", "%s 살아 움직인다 ㅋㅋ 씨발", "%s 오케이 씨발 가자", "%s 준비 완료 보고 씨발 ㅋ", "%s 기능 장착 완료 씨발 굿", "%s 켜서 다행이다 씨발", "%s 켜니 이제 제대로 된 판이다", "%s 켜졌으니 자신 있다 씨발 ㅋ", "%s 작동 확인 씨발 됐지?",
		"%s 이거 존나 마음에 든다", "%s 드디어 깨어났다 씨발 ㅋㅋ", "%s 가동 시작 신호 씨발 떴다", "%s 든든하게 지켜줄게 씨발", "%s 켜고 바로 쏘자 씨발", "%s 활성화 축하한다 씨발 ㅋ", "%s 같이 하니까 존나 좋다", "%s 장착 됐다 ㅎㅎ 씨발", "%s 시동 완료!! 씨발 간다",
		"%s 이제 준비 OK 씨발 ㅋ", "%s 켜져 있는 게 존나 좋다", "%s 기능 시작했다 씨발", "%s 믿고 간다 씨발 ㅋ", "%s 켰다! 존나 든든하다 씨발", "%s 깨웠냐 ㅎㅎ 씨발", "%s 활성 확인!! 씨발 ㅋ",
	} },
	toggleOff = { level = 2, priority = 1, cooldown = 2, lines = {
		"%s 껐다 ㅅㅂ", "%s 잠깐 쉬어라 ㅋㅋ", "%s 꺼짐 ㅇㅋ", "%s 이제 안 쓰냐?", "%s OFF 됐다 씨발", "%s 휴식 ㅋㅋ 깨우지 마", "%s 꺼놨네 어쩔 건데", "%s 잠깐 빠진다 ㅋㅋ", "%s 없이 간다고? 미쳤네", "%s 좀 쉬게 놔둬라", "%s 정지 ㅅㅂ!", "%s 이제 안녕 ㅂㅂ",
		"%s 비활성화 완료", "%s 꺼도 진짜 괜찮냐?", "%s 껐다 알겠다고 ㅋㅋ", "%s 쉬는 시간 준다 ㅅㅂ", "%s 껐네 잠깐 쉬자 씨발", "%s 꺼지니까 존나 조용하네", "%s 잠시 빠진다 ㅋㅋㅋ", "%s 끄니까 존나 허전하네", "%s 꺼놨네 알겠다고",
		"%s 쉬라고 껐냐 ㅋㅋ", "%s 정지 상태 확인 ㅇㅋ", "%s 없이 해 보자 ㅋㅋㅋ", "%s 이제 안 쓰는 거냐 ㅅㅂ", "%s 꺼졌다 확인 끝", "%s 쉬게 해 줘야지 어쩌겠냐", "%s 잠깐 휴식 모드 진입", "%s 꺼졌으니 조용히 간다 ㅋㅋ",
		"%s 오프 상태 기록했다", "%s 끄는 것도 선택이지 뭐", "%s 이번엔 빼고 간다 ㅅㅂ", "%s 꺼진 거 봤다 ㅇㅋ", "%s 잠깐 놓는다 ㅋㅋ", "%s 비활성 상태다 ㅇㅋ", "%s 껐어도 다시 켜면 됨 ㅋㅋ", "%s 조용히 꺼졌네 ㅋㅋ", "%s 꺼졌는데 괜찮냐 ㅅㅂ",
		"%s 쉬러 갔다 ㅋㅋ", "%s 오프 완료다", "%s 끄니까 개가볍네", "%s 빠져 있을 테니 알아서 해", "%s 쉬는 중이다 건드리지 마", "%s 이제 없는 셈 치자 ㅅㅂ", "%s 꺼 두면 존나 편하지", "%s 정지 신호 받았다", "%s 빠졌다 ㅋㅋ",
		"%s 꺼졌네 다음에 보자 ㅂㅂ", "%s 끄고 딴 거 해 볼래?", "%s 오프 상태 저장했다", "%s 쉬어라 쉬어 ㅋㅋ", "%s 잠시 자리 비움 ㅅㅂ", "%s 꺼진 건 나도 봤다고", "%s 끄고 가 보자", "%s 다음에 다시 켜자 ㅅㅂ",
		"%s 꺼진 채로 가도 ㄱㅊ", "%s 한숨 돌리는 중이다", "%s 조용히 꺼졌네", "%s 빼고 하는 판도 재밌다 ㅋㅋ", "%s 끄는 거 확인했다!", "%s 잠깐 쉬었다 가라", "%s 필요하면 다시 켜라", "%s 꺼진 거 잘 기억해 둔다",
		"%s 오프 완료 ㅅㅂ", "%s 쉬는 시간이다 ㅋㅋ", "%s 끄고 정리나 하자", "%s 없으니까 좀 심심하네", "%s 꺼졌네 뭐", "%s 쉬러 갔다고", "%s 껐구나 확인했다",
	} },
	allOff = { level = 1, priority = 2, cooldown = 30, lines = {
		"다 껐냐? 맨손으로 싸우게? 미친 ㅋㅋ", "실력으로 간다 이거지? 존나 용감하네", "에임 다 꺼졌네 ㅋㅋ 실력이나 보여줘", "노핵 모드 ㅋㅋ 그래 해봐라", "진짜 실력파네 ㄷㄷ 개쩐다", "도움 없이 간다? 씨발 가보자", "에임 다 끔 ㅋㅋ 순수 실력 ㅅㅂ", "용감하네 ㅋㅋ 존나 용감하다",
		"다 끄고 뭐 하게? 어이없네", "연습 모드냐? 존나 심심하네", "이게 진짜 승부지 ㄹㅇ", "손맛으로 가자 씨발 빡세게", "오늘은 맨손 데이냐 ㅋㅋ", "다 꺼도 응원은 한다 씨팔", "자신감 넘치네 개웃기네", "에임 전부 끄다니 대담하네 ㅋㅋ 미쳤다", "진짜 실력으로만 간다고? 존나 웃기네",
		"보조 다 빼고 맨몸으로? 씨발 미쳤냐", "노핵이 제일 어려운 건데 ㄷㄷ 개빡세지", "모든 걸 끄다니 비장하네 ㅋㅋ", "이제 손으로 승부하는 거지 ㅇㅈ", "보조 없이도 강하겠지 ㅇㅈ", "다 끈 건 자신감이지 ㅋㅋ 개쩐다", "눈으로만 쏘는 거냐? 씨발 대단하네", "실력파 모드 ON 개빡세게 가자",
		"아무 도움 없이 간다니 개멋있네 ㅋㅋ", "오늘은 순수 실력 대결이네 존나 재밌겠다", "전부 꺼 놨으니 믿어본다 ㅋㅋ", "다 끄고 시작하는 판도 존나 재밌지", "나 손에 땀 난다 씨발 ㅋㅋ", "기능 없이 가는 용기 인정 ㄹㅇ", "정말 다 끌 거냐? 뭐임", "그래도 응원은 한다 ㅋㅋ 가라",
		"보조 없는 판은 존나 긴장되네", "실력으로 증명해봐라 씨발", "다 껐으니 진짜 승부다 ㄹㅇ 가자", "맨몸 전투 시작이네 ㅋㅋ 개빡세다", "그래 그래 실력 보여 줘라 ㅋㅋ", "이게 진짜 게이머지 ㅇㅈ", "도움 없이 가는 판 존나 좋아함", "조명 끄고 싸우는 기분이네 씨발 ㅋㅋ",
		"보조 장비 반납 완료 ㅋㅋㅋ", "오늘은 순수하게 간다 씨팔", "에임 없이 조준하는 것도 실력이지 ㅇㅈ", "전부 끄니까 존나 조용하네", "진짜 용감하다 ㅋㅋ 미쳤네", "다 꺼도 옆에는 있을게 ㅅㅂ 같이 가자", "실력 한번 믿어 보자 ㅋㅋ", "보조 없이 이기면 전설이다 ㄹㅇ",
		"그래도 조심해서 가자 씨발", "전부 꺼졌네 맨손 승부다 ㅋㅋ", "자신 있으면 해 봐라 ㅋㅋ", "이 판이 제일 어려울 거다 씨발", "보조 없는 판 존나 긴장된다", "에임 꺼놨으니 머리 좀 쓰자 ㅋㅋ", "오늘은 실력 측정 날이네 개빡세겠다", "다 끄고 사냥하는 중이냐? ㅋㅋ",
		"정정당당하게 가는 거지 ㅇㅈ", "맨손 승부 응원한다 ㅋㅋ 씨발", "모든 기능 끔 확인 뭐임", "진짜 실력 드러나겠네 씨발 ㅋㅋ", "보조 장치 없이도 믿어 볼게 ㅇㅈ", "나도 긴장된다 ㅎㅎ 씨발", "전부 OFF 상태 기록 완료 ㅋㅋ", "눈이랑 손으로 이겨 보자 ㄹㅇ",
		"도움 없는 판 기대된다 존나", "에임 없이도 할 만하냐? ㅋㅋ", "다 끄고 하는 건 개쩐다", "이 판은 집중력 싸움이다 씨팔", "그래 실력이 최고지 ㅋㅋ",
	} },
	allOn = { level = 2, priority = 1, cooldown = 30, lines = {
		"풀옵션 켰다 ㅅㅂ 가자", "다 켰네 ㄷㄷ 존나 무섭다", "전부 ON 씨발 가보자", "ㅋㅋ 완전체 됐다 개쩐다", "기능 싹 다 출동 ㅅㅂ", "세팅 풀로 끝 ㅋㅋ 개꿀", "다 켜니까 존나 편하네", "와 씨발 완벽 무장이네", "준비 만렙 ㅈㄴ 쩐다", "씨발 다 켰다 무섭네 ㅋㅋ", "무적 세팅 덤벼 ㅅㅂ",
		"이제 질 수가 없다 ㅋㅋ", "전부 가동 중 ㅈㄴ 든든", "올인원 모드 ㅆㅂ 간다", "풀파워다 씨발!", "기능 다 깨어났다 ㄷㄷ 미친", "풀세팅 완료 가보자 ㅋㅋ", "개든든하네 다 켜니까", "완벽 무장 확인 개쩐다", "준비 만렙 달성 ㅋㅋㅋ", "전부 켜졌네 미친 무섭다",
		"무적 세팅 끝 꺼져라", "이제 질 일 없겠네 ㅅㅂ", "죄다 가동 중이다 ㅋㅋ", "올인원 발동 ㅈㄴ 쎄다", "풀파워 준비 끝 ㅅㅂ", "장비 싹 다 장착 ㅇㅋ", "다 켰으니 쏘기만 해 씨발", "완전체다냥 ㅅㅂ 쩐다", "ON 상태 전부 확인 ㅇㅇ",
		"이 세팅이면 자신 있다 ㅅㅂ", "기능들 존나 잘 돌아간다", "풀옵션 판은 긴장돼도 좋네", "든든하다 ㅋㅋ 다 켰네", "무장 완료 보고한다 씨발", "이제 실력만 보여 봐 ㅋㅋ", "다 켜졌으니 출발 ㄱㄱ", "풀세팅 보니 감동이네 ㅋㅋ", "다 켜니까 존나 신난다 ㅋㅋ",
		"이 정도면 무적이지 ㄹㅇ", "기능들 이 순간 기다렸네 ㅋㅋ", "전부 가동 이제 진짜다 ㅅㅂ", "마음 놓인다 다 켜져서", "ㅇㅋ 풀가동 확인", "전원 다 들어왔다 ㅋㅋ", "이제 아무도 못 막겠다 ㅅㅂ", "준비 끝 올인 ㄱㄱ", "상태 완벽하네 ㅇㅈ",
		"다 켠 거 ㄹㅇ 잘했다", "장비 점검 끝 깔끔하네", "풀옵션 ㄱㄱ 씨발", "이 조합 개좋네 ㅋㅋ", "든든해 ㅅㅂ 전부 켜졌네", "이제 올인으로 가자 씨발", "다 켜졌으니 마음 편히 쏴라", "풀세트 장착 끝났다 ㅋㅋ", "OK OK 기능 전부 정상",
		"다 켜 놓으니 존나 강해 보여", "전부 ON이면 믿는다 ㅇㅈ", "달려 씨발 다 같이!", "올인 세팅 완성 ㅋㅋ", "무장 해제 같은 거 없다 ㅋㅋ", "오 다 켰네 좀 멋있다", "이 정도면 준비 충분하지 ㅅㅂ", "풀장비 출격 씨발", "안심된다 ㅋㅋ 다 켜져 있네",
		"이제 실력 발휘할 차례다 ㅅㅂ", "가동 중 확인 ㅇㅋ", "풀파워 존나 기대된다", "완전 무장 상태 개좋다",
	} },
	espOff = { level = 2, priority = 1, cooldown = 20, lines = {
		"ESP 껐냐? 눈 감고 싸우네 ㅋㅋ", "벽 너머 하나도 안 보이네 ㅅㅂ", "이제 감으로 찾으라고? 미쳤네", "ESP 없어도 할 수 있잖아 ㅇㅈ?", "이제 소리 듣고 찾아라", "투시 껐다 감 믿고 가 ㅋㅋ", "벽 너머는 비밀이다 ㅅㅂ", "눈 가리고 아웅 하네 ㅋㅋㅋ",
		"ESP 없이도 존나 잘하잖아", "정정당당 모드냐 ㅋㅋ 뭐임", "이거 좀 빡세겠는데?", "오늘 감 좋은 날이겠지? 제발", "ESP 쉬는 중 ㅋㅋ", "윤곽선 잘 가라 ㅅㅂ", "보이는 게 존나 없네", "ESP 껐네? 감으로 찾는다고 ㅋㅋㅋ", "벽 너머는 이제 비밀이네 씨발",
		"윤곽선 없이 간다고? 지랄 ㅋㅋ", "체력바도 안 보이겠네 ㅈㄴ", "이제 눈빨로 싸우는 판이네", "정정당당 모드 시작이냐 ㅋㅋ", "좀 빡세도 할 수 있어 씨발", "ESP 쉬게 해 줬네 ㅋㅋ", "보이는 대로 싸우는 거지 뭐", "벽 뒤는 상상으로 때려야겠네",
		"윤곽선 없으니 ㅈㄴ 긴장된다", "체력바 없으니까 감으로 가 ㅅㅂ", "ESP 꺼도 실력은 그대로지 ㅋㅋ", "보이는 게 줄었으니 집중해 씨발", "감 좋은 날이면 괜찮다 ㅇㅇ", "눈 크게 뜨고 찾아라 ㅅㅂ", "보이는 적만 잡으면 되지 뭐",
		"투시 없는 판도 존나 재밌다", "ESP 없이 찾기 도전이다 ㅋㅋ", "벽 너머 적은 소리로 찾아야지", "정보 없으니 신중하게 가 씨발", "체력바 없이 싸우다니 용감하네", "ESP 끄니까 존나 조용하네", "보이는 대로 갈기자",
		"오늘은 눈으로만 판단한다 ㅅㅂ", "ESP 쉬는 날이네 ㅋㅋ", "정확한 감각 필요하겠네 ㅈㄴ", "투시 없이 가는 것도 낭만임 ㅋㅋ", "ESP 꺼진 거 나도 기억한다", "윤곽선 없는 맵 존나 낯서네", "체력바도 없고 좀 쫄리네 ㅅㅂ",
		"감으로 찾는 맛이 있긴 하지 ㅋㅋ", "눈 비비면서 찾아봐 ㅋㅋ", "ESP 없이 이기면 ㄹㅇ 대단하다", "정보 없이 싸우는 연습 좋지 ㅇㅈ", "보이는 것만 믿어 ㅅㅂ", "투시 없는 판 응원은 해 준다", "ESP 껐으면 귀 좀 열어라",
		"벽 뒤가 안 보여서 존나 답답하다", "체력바 없는 판 처음이지? ㅋㅋ", "그래도 할 수 있다 냥 ㅋㅋ", "ESP 쉬는 동안 나도 쉰다", "윤곽선 없어도 잘 찾아라 제발", "눈이랑 감만 믿고 가자 씨발", "ESP 없는 판도 맛이 있지",
		"정보 줄이고 실력으로 가자", "보이는 적부터 차례로 따자", "ESP 꺼졌으니 정신 똑바로 차려", "투시 없이 승부 보자 ㅅㅂ", "감만 믿고 쏘는 맛 ㅈㄴ 있다 ㅋㅋ", "체력 안 보여도 파이팅이다 ㅅㅂ", "ESP 끈 건 실력 자신감이네 ㅋㅋ",
		"안 보여도 찾아낸다 ㅅㅂ", "눈에 집중해라 진짜", "ESP 쉬는 중이네 씨발",
	} },
	antiAimMax = { level = 2, priority = 1, cooldown = 20, lines = {
		"안티에임 최강 ㅋㅋ 땅속으로 꺼진다", "최강 모드 ㄷㄷ 씨발 아무도 못 맞히지", "숨바꼭질 최강 모드 켜짐 존나 편하다", "바닥 밑에 숨는다 ㅋㅋ 개웃기네", "최강 숨기 발동! 꺼져 이제 못 찾지", "아무도 날 못 찾아 ㅋㅋ 찾아보라고", "땅속 요새 완성 씨발 이건 못 뚫지", "맞을 일 없다 ㅋㅋ 쏴봐 쏴봐",
		"최강은 역시 최강 ㄹㅇ 개쩐다", "숨바꼭질 챔피언 ㅋㅋ 인정하냐", "바닥이 내 방패 ㄹㅇ 존나 든든하다", "투명 모드 ON 씨발 안 보이지", "최강 단계 진입 ㅋㅋ 이제 시작이다", "흔적도 없이 사라짐 ㅋ 찾을 생각 마", "상대 멘붕 예약 ㅋㅋ 존나 웃기겠다", "안티에임 최강 발동! 땅속으로 꺼져라", "아무도 날 못 찾겠지 ㅋㅋ 개꿀이다", "땅속 요새 완성이다 씨발 못 뚫는다",
		"맞을 일은 없을 거야 ㅋ 걱정 마라", "최강은 역시 최강이지 ㅇㅈ", "숨바꼭질 챔피언 등장 ㅋㅋ 존나 간다", "바닥이 내 방패가 됐어 씨발 좋다", "투명 모드 ON 개사기다 ㅋㅋ", "최강 단계 진입 완료 ㅋ 이제 좀 살겠다", "흔적도 없이 사라졌다 ㅋㅋ 찾아봐라", "상대 멘붕 예약이다 ㅋㅋ 빡쳐라",
		"땅속에 숨는 건 나도 처음이다 씨발 웃기네", "최강 모드면 든든하지 존나", "이제 쉽게 안 맞겠네 ㅋㅋ 됐다", "땅 밑에서 응원할게 ㅋ 파이팅 씨발", "가장 세게 숨었다 ㅋㅋ 개쩐다", "바닥 아래 안전지대 ㅋ 못 들어오지", "최강이면 적도 헷갈리겠지 ㅋㅋ", "숨는 실력 최고 단계 ㄹㅇ",
		"이 정도면 무적 모드 아냐? 씨발 ㅋ", "땅속 피신 완료 ㅋㅋ 꺼져라", "상대가 못 찾으면 좋겠다 ㅋ 제발", "최강으로 가면 마음 편하다 씨발", "안티에임 풀파워! 쏴봐 개웃기네", "땅 밑에서 조용히 지켜볼게 ㅋ 쫄지 마", "숨는 것도 전략이다 ㅋㅋ 뭐 어쩌라고", "최강 모드 가동 확인 ㅇㅈ 굿",
		"바닥 밑이 제일 안전하다 ㅋㅋ 존나", "이제 누가 날 찾겠냐 ㅋ 아무도 못 찾지", "최강 세팅 완벽하다 씨발 개좋다", "숨바꼭질의 끝판왕 ㅋㅋ 인정", "땅속 탐험 시작! 뭐 있나 씨발", "위에서 쏴도 안 맞을걸 ㅋㅋ 해봐라", "최강으로 가니까 든든하다 ㄹㅇ", "진짜로 숨었다 ㅋㅋ 찾아오지 마", "바닥이 지켜 주는 느낌 씨발 좋네",
		"숨는 데는 이만한 게 없지 ㅋ", "땅속 요새에서 응원한다 씨발 파이팅", "최강 안티에임 확인 완료 ㅋㅋ 굿", "아무도 못 찾는 위치다 ㅋ 개꿀", "이 강도면 충분하지 씨발", "땅 밑에서 쉬는 중 ㅋㅋ 졸리다", "숨기 최강 등극! ㅋㅋ 존나 쩐다", "땅속으로 쏙 들어갔다 ㅋ 개웃기네",
		"이 정도는 돼야 안심이지 씨발", "땅 아래 세상 신기하네 ㅋㅋ 뭐임", "최강 모드 끝판왕 등장 ㄹㅇ", "숨바꼭질 이기는 중 ㅋㅋ 개이김", "안티에임 최고 등급 확인 ㅇㅈ", "땅속에서 맞을 수 있냐? 씨발 ㅋ", "나 지금 완전 숨었다 ㅋㅋ 찾아봐", "최강 세팅 기분 좋다 씨발 ㄹㅇ",
		"바닥 밑에서 쉬어 가자 ㅋ 꺼져", "땅속 피난처 확보 씨발 완료", "최강 숨기 발동 ㅋㅋ 쏴봐라",
	} },
	antiAimLevel = { level = 3, priority = 1, cooldown = 10, lines = {
		"안티에임 강도 %s 박았다 ㅅㅂ", "강도 %s 골랐네 ㅋㅋ 좀 아는데", "ㅇㅋ %s 단계 존나 좋아", "흔들기 %s 간다 ㅅㅂ 어지럽겠네", "강도 %s 가즈아!", "이번엔 %s 간다 씨발", "%s 단계 세팅 끝 씨발", "흔들기 강도 %s 맞냐?", "적당하긴 하네 %s 정도면 ㅇㅈ", "%s 모드 ON 시발 간다",
		"안티에임 %s 적용했다 ㅇㅋ", "바꿨다 ㅋㅋ %s 간다", "선택 괜찮은데 %s 이거 ㄹㅇ", "가동 시작 ㅅㅂ %s 단계", "오 %s! ㅇㅈ", "강도 %s 세팅 끝 가자!", "이번엔 %s 한번 가볼게 ㅅㅂ", "%s 단계 고른 거 좋은 선택임", "흔들기 강도 %s 적용 ㅇㅇ",
		"그래 %s 정도면 적당하네 ㅋㅋ", "%s 모드 시작한다 존나 흔든다", "안티에임 %s 적용됐네 확인했다", "바꿨네 ㅋㅋ %s 좀 하는데", "오 %s 선택 괜찮은데 ㅇㅈ", "지금 %s 단계 가동 중이다 ㅋㅋ", "오 좋다 좋다 %s! ㅋㅋ", "강도 %s 이러면 존나 편하겠네", "센스 있네 %s 맞춰놨다 ㅋㅋ",
		"한번 가보자 %s 단계 ㅅㅂ", "%s 선택 확인했다 냥", "흔들기 %s 설정 끝 ㅋㅋ", "이거면 안전빵이네 %s", "강도 %s 기록했다 ㅇㅋ", "바꾸니까 느낌 존나 다르네 %s", "%s 단계 확인 완료 ㅇㅇ", "세팅 좋아 보이네 %s ㄹㅇ", "강도 %s 한번 달려보자!",
		"잘했다 %s 선택 ㅇㅈ", "안티에임 %s 확인 ㅇㅋ", "무난하긴 하네 %s 단계 ㅋㅋ", "뭐 %s 맞추면 됐지 ㅋㅋ", "강도 %s 적용 중 기다려 ㅅㅂ", "%s 단계 확정이다 씨발!", "이거 괜찮은데? %s 뭐임 ㅋㅋ", "흔들기 %s 확인 ㅇㅇ", "%s 바꿔서 다행이다 ㅅㅂ",
		"강도 %s 기분 개좋네", "%s 정도 세기면 충분하다 ㄹㅇ", "%s 단계 설정 종료 ㅋㅋ", "인정 %s 선택 ㅇㅋ", "강도 %s 저장 완료 ㅇㅋ", "%s 쓰는 판도 존나 재밌지 ㅋㅋ", "%s 단계 가동 확인함", "개좋네 %s 세기", "안티에임 강도 %s 완료 ㅅㅂ",
		"%s 바꾼 거 기억해둔다 ㅇㅋ", "%s 단계 쭉 가자 ㅅㅂ", "강도 %s 확인했다 좋네", "%s 설정하니까 존나 든든하다", "%s 단계 적용됨 ㅇㅋ", "흔들기 세기 %s 찍었다", "%s 선택 완료 ㅋㅋ", "강도 %s 밀고 간다!", "딱 맞네 %s 단계 ㄹㅇ",
		"%s 가면 괜찮겠지 아마", "강도 %s 확정 ㅅㅂ 끝", "%s 단계 세팅 ㅇㅋ 굿", "마음에 드네 %s 선택 ㅋㅋ", "안티에임 %s 시작한다 ㅅㅂ", "강도 %s 적용 완료!",
	} },
	chatterMax = { level = 3, priority = 1, cooldown = 60, lines = {
		"수다 모드 ON 이제 존나 떠든다 ㅋㅋ", "아 씨 나 이제 ㅈㄴ 떠든다?", "말수 맥스다 각오해라 ㅋㅋ", "수다냥 떴다 씨발 ㅋㅋ", "말 존나 많이 할 거다 ㅋㅋ", "나 이제 수다쟁이다 어쩔래", "귀 막아도 소용없다 ㅋㅋ", "하고 싶은 말 이제 다 한다", "말풍선 폭탄 투하한다 ㅋㅋ",
		"닥치라고 하지 마 ㅋㅋ", "씨발 수다 시작이다", "할 말 존나 많았는데 잘됐네", "ㅅㅂ 토크쇼 개막이다 앉아봐", "심심할 틈 1도 없을걸 ㅋㅋ", "말 많은 펫 떴다 ㅅㅂ", "말 많이 할 거다 ㅋㅋ 참아라", "말수 최대치다 각오하라고 진짜", "귀 틀어막아도 다 들려 ㅋㅋ",
		"이제 존나 쉬지도 않고 떠든다", "참았던 말 다 쏟아낸다 ㅋㅋ", "말풍선 폭격 간다 씨발!", "조용히 하란다고 할 줄 아냐?", "ㅆㅂ 오늘은 수다 데이다", "말 많아진 펫 왔다 ㅋㅋㅋ", "나 떠드는 거 존나 좋아함 ㅋㅋ", "말수 최고 단계 존나 풀가동",
		"수다 풀가동 ㅈㄴ 시끄러울걸", "미친 입이 안 닫힌다 ㅋㅋ", "할 말이 넘쳐서 터질 듯 ㅋㅋ", "말 많은 냥이 출동 ㅅㅂ", "시끄러워도 참아라 ㅋㅋ", "말하는 거 개재밌네 ㅋㅋ", "말수 최대로 올렸네 ㅇㅈ 고맙다", "시끄러운 펫 등장 ㅋㅋ 도망쳐",
		"오늘 쉬지도 않고 떠들 거다", "수다쟁이 모드 켜졌다 씨발", "말이 자꾸 튀어나온다 ㅋㅋ", "조용한 시절 끝났다", "말 많은 펫이랑 한 팀이다 ㅋㅋ", "할 말 많은 내가 왔다 씨발", "말풍선 연속 발사 받아라 ㅋㅋ", "수다 본능 깨어났다 ㅋㅋ",
		"떠들고 싶어서 존나 못 참겠다", "말수 최고치로 세팅됐네 ㅇㅋ", "입 근질거려 죽겠다 ㅋㅋ", "말 많아져도 나도 몰라 ㅋㅋ", "오늘 말 많이 해도 되지? 안 돼도 함", "이 정도면 수다 장인 ㅇㅈ?", "말 폭주 시작이다 막지 마", "할 말 다 하고 간다 ㅋㅋ",
		"떠드는 맛 알아버렸다 ㅋㅋ", "수다 장전 끝 쏜다 ㅅㅂ", "쉬지도 않고 나불나불 간다", "말 많은 펫 풀단계 찍었다 ㅋㅋ", "입 열면 안 멈춘다 ㅈㄴ ㅋㅋ", "말수 맥스 떴다 ㅅㅂ 시작한다", "말 쏟아지는 중 ㅋㅋ 못 막는다", "나불나불 모드 가동 ㅋㅋ", "수다 콘서트 개막 ㅅㅂ 들어라",
		"말 많아서 미안하다 ㅋㅋ 안 고침", "떠벌이 특성 발동했다 ㅋㅋ", "말풍선 존나 자주 뜰 거다", "오늘 떠들 준비 끝 개신난다", "수다 무한 재생 중 ㅋㅋ", "말이 안 끊긴다 씨발 ㅋㅋ", "수다 본능 풀가동 ㅈㄴ 쩔지", "말 많은 펫 된 거 축하해라 ㅋㅋ", "떠들수록 존나 신난다",
		"말수 설정 최고치 OK 좋네", "수다 파티 열렸다 ㅅㅂ 다 와",
	} },
	matchStart = { level = 2, priority = 1, lines = {
		"새 판 시작! 씨발 가보자", "이번 판도 가자 ㅋㅋ 존나", "집중 집중! 씨발", "긴장되네 ㅋㅋ 씨발", "시작이다! 존나 간다", "렛츠고! 씨발", "이번 판 MVP 가자 ㅋㅋ", "손 풀었지? 씨발 빨리", "첫 킬 누가 먼저냐 ㅋㅋ", "자리 잡자 씨발", "조심조심 시작 ㅅㅂ",
		"이번 판도 이기자! 씨발", "집중 모드 ON 씨발", "출발! 씨발 가자", "다 이길 수 있어 ㅋㅋ 씨발", "판 열렸다 준비하자 씨발", "이번 판 재밌겠다 ㅎㅎ 존나", "첫 발 조심해서 쏘자 씨발", "긴장 풀고 시작하자 ㅋㅋ", "다들 자리 잡았지? 씨발", "오늘도 한 판 잘해 보자 ㅅㅂ",
		"시작 신호 떨어졌다! 씨발", "눈 크게 뜨고 가자 ㅋㅋ", "판 시작, 손 준비! 씨발", "이번엔 무피 노려 보자 ㅋㅋ", "좋아 판 열렸어 씨발 출발", "첫 교전 기대된다 ㅋㅋ 존나", "이번 판 MVP는 누구냐 씨발", "이번 판 흐름 좋게 만들자 씨발",
		"매치 시작! 집중 집중 씨발", "오늘 판은 어떻게 흘러갈까 ㅋㅋ", "자리 먼저 잡는 게 중요하다 씨발", "이 판 꼭 이기자 씨발", "시작부터 기세 잡자 ㅅㅂ", "판 시작 기념으로 한 발! ㅋㅋ", "차분하게 하나씩 가자 씨발", "긴장되지만 설레네 ㅋㅋ",
		"좋아 판 열렸다 씨발", "준비 완료 보고! 씨발", "이번 판 정보부터 파악하자 ㅋㅋ", "지도 익숙하지? 씨발 가자", "첫 목표는 생존이다 ㅋㅋ 씨발", "자 이제 본격적으로 씨발", "이 판 흐름 좋을 것 같다 ㅋㅋ", "같이 해서 든든하네 씨발",
		"첫 킬 누가 먼저 할지 궁금하다 ㅋㅋ", "판 열리자마자 눈이 번쩍 씨발", "천천히 시작해도 괜찮아 ㅋㅋ", "이번 판도 잘 풀리길 씨발", "시작 버튼 눌렸다! 씨발", "이 판 기록 남길 만하다 ㅋㅋ", "좋아 가자 씨발 가자", "자 시작이다 씨발",
		"이번 판은 깔끔하게 가자 ㅋㅋ", "매치 입장 완료! 씨발", "머리 식힐 시간 끝, 시작! 씨발", "판 시작했으니 집중 ㅋㅋ 씨발", "오늘 판도 재밌게 하자 ㅅㅂ", "시작 전에 호흡 한 번 씨발", "이번엔 실수 없이 가자 ㅋㅋ", "첫 판은 몸 풀기 좋다 씨발",
		"판 열리는 소리 설렌다 ㅋㅋ", "좋은 판 되자! 씨발", "방금 시작했는데 벌써 긴장돼 ㅋㅋ", "이번 판도 같이 이겨 보자 씨발", "자 전장 열렸다 씨발 ㅋㅋ", "시작하고 바로 움직이자 씨발", "이번 판 한번 보여 줘 ㅋㅋ", "판 열렸다 가즈아 씨발",
		"이 판 어떻게 흘러갈지 ㅋㅋ",
	} },
	matchStartAfterLoss = { level = 1, priority = 2, lines = {
		"이번엔 씨발 이기자", "복수전이다 다 갈아버리자", "졌던 건 잊고 새로 간다 ㅅㅂ", "이번 판은 존나 우리가 먹는다", "지난 판은 잊어 빡치니까", "이번엔 다르다 두고 봐", "설욕전이다 ㅅㅂ 시작해", "다시 해보자 냥 이번엔 이겨", "이번엔 진짜 ㅈㄴ 이긴다", "정신 차리고 가자 씨발",
		"복수의 시간이다 ㅋㅋ", "새 마음 새 판이다 씨발 가자", "질 수 없지 ㅅㅂ", "포기는 없다 죽어도 안 한다", "이번 판은 내 거다 꺼져", "아까 판은 잊고 새로 간다", "복수전 시작이다 ㅋㅋㅋ", "이번엔 반드시 갚아 준다 ㅈㄴ", "정신 바짝 차려 시발", "지난번 실수 기억하고 가 ㅅㅂ",
		"이번엔 다르다니까 믿어 봐", "설욕전 개시 존나 간다", "다시 일어섰네 ㄹㅇ 멋있다", "이번 판은 우리가 이긴다 ㅇㅈ?", "졌던 기억은 여기서 끝이다 ㅅㅂ", "새 판 새 각오 간다", "이번엔 신중하게 가자 제발", "우리 다시 해 보자 ㅋㅋ", "분위기 뒤집자 ㅆㅂ",
		"진 판에서 교훈은 얻었냐 ㅋㅋ", "이번엔 확실히 이기자 ㅈㄴ", "복수는 이기는 게 최고지 ㅇㅈ", "포기 안 하는 거 ㄹㅇ 좋다", "이번 판은 우리 차례다 꺼져", "패배는 잊고 다음 판이다 ㅅㅂ", "이번엔 흐름 존나 가져오자", "설욕 준비 끝 다 덤벼", "마음 다잡고 시작하자 씨발",
		"빡치면 이번 판에 쏟아부어", "승리 공식 다시 떠올려 봐", "이번엔 같이 이긴다 ㅅㅂ", "지난판 같은 실수는 안 되겠지?", "정신 무장 끝 ㅅㅂ", "다시 해 보는 게 용기지", "이번 판에 다 걸자 씨발", "복수의 불꽃 타오른다",
		"지금부터가 진짜다 쫄지 마", "이번엔 우리 편이 존나 이긴다", "잘 쉬고 왔으니 이번엔 잘하겠지", "다음 판은 내 판이다 ㅅㅂ", "져도 배운 건 있잖아", "이번엔 판 좀 읽어라 제발", "다시 한번 믿어 봐 인마", "진 만큼 더 개세게 가자",
		"여기서 역전한다 ㅅㅂ 지켜봐", "이번엔 실수 좀 줄여라 ㅅㅂ", "기분 풀고 가자 ㅋㅋ", "이번엔 진짜 되는 판이다 느낌 온다", "차분하게 이기자 진짜", "방금 판 얘긴 닥치고 시작", "이번 판에서 만회한다 ㅅㅂ", "이번엔 승리 확정이다 ㅋㅋ",
		"눈빛 바뀐 거 봤냐 ㅋㅋ", "재정비 끝 다시 간다 ㅆㅂ", "지난 판 아쉬움 털고 가자", "다음 판은 웃으면서 끝낸다 ㅋㅋ", "이번엔 판을 존나 지배하자", "이번이 역전 기회다 놓치면 빡친다", "다시 시작하는 용기 멋지다 ㄹㅇ", "졌던 맵 다시 간다 가자",
	} },
	matchLong = { level = 2, priority = 1, cooldown = 300, lines = {
		"이 판 존나 길다 ㄷㄷ", "팽팽하네 씨발 긴장된다", "아직도 안 끝남? 씨발 힘내라", "장기전이다 집중 좀 해라", "끝이 안 보이네 ㅋㅋ 미친 판", "체력전이다 씨발 버텨라", "누가 먼저 나가떨어지나 ㅋㅋ", "집중 풀지 마 씨발", "아직 한참 남았네 ㅅㅂ", "이 판 기록 세운다 씨발 간다",
		"긴 판은 인내심 싸움이지 ㅋ", "버티면 이긴다 씨발 버텨", "물이나 한 모금 하고 가자 ㅋㅋ", "판 길어도 상관없다 씨발", "흐름 잡자 씨발 흐름", "판 길어지니 집중 좀 하자 ㅅㅂ", "오래 가는 판이네 ㅋㅋ 존나 지친다", "지루해지면 실수 나온다 씨발", "조금만 더 버티자 씨발",
		"체력전 시작이다 ㄹㅇ 개피곤", "쉬엄쉬엄 가자 ㅋ 급할 거 없다", "이 판 끝까지 가보자 씨발", "긴 판은 인내가 답이다 ㅇㅈ", "아직 역전 기회 널렸다 씨발", "이쯤 되면 전략 싸움이다 ㅋ", "흐름 읽는 게 핵심이다 ㅅㅂ", "점수 확인이나 좀 해봐 씨발", "버티면 기회 온다 ㅋㅋ 존나 버텨",
		"조급해하지 말고 차근차근 씨발", "오래 끄는 판 존나 재밌다 ㅋ", "집중 다시 끌어올리자 씨발 정신 차려", "한 번 크게 흔들어보자 ㅋㅋ 개쩐다", "긴 판 기록 세우는 중이냐 ㅋㅋ", "쉬면서 흐름이나 보자 씨발", "끝 다 와간다 씨발 조금만", "이 판 명승부 되겠네 ㄹㅇ", "지치지 말고 가자 씨발 힘내",
		"길어도 재밌으면 장땡이지 ㅋ", "버티는 놈이 이긴다 씨발", "같이 끝까지 가보자 씨발 ㄱㄱ", "지금 실수 좀 줄여라 씨발", "긴장 풀지 말자 ㅋㅋ", "판 늘어질수록 침착해라 씨발", "체력 아껴서 마지막에 쓰자 ㅅㅂ", "이 판 역전극 나올 수도 있다 ㅋ",
		"조금만 더 힘내라 씨발 ㅋ", "여유 부리면서 흐름 타자 ㅋㅋ", "긴 판은 판단력이 존나 중요하다", "이쯤에서 한 번 점검 좀 하자 씨발", "오래 하니까 눈 존나 아프다 ㅋ", "멈추지 말고 계속 가자 씨발", "버틸수록 기회 온다 ㅋㅋ 버텨라", "이 판 끝날 때까지 집중해라 씨발",
		"지치면 말해라 씨발 같이 가자", "긴 판은 실수 한 번이 존나 크다", "차분하게 상황부터 파악하자 씨발", "지금 페이스 나쁘지 않다 ㅋ", "천천히 계산하면서 가자 씨발", "길게 가도 우리가 존나 강하다", "여기서 흐름 잡자 씨발 ㄱㄱ", "마지막까지 방심 금지다 씨발",
		"긴 승부 좋아하긴 한다 ㅋ", "버티는 힘 믿고 가자 씨발", "판 끝날 때까지 웃어보자 ㅋㅋ", "이 판 어떻게 끝나려나 씨발", "지금 전략 좀 바꿔라 씨발", "흐름 바뀔 타이밍이다 ㄹㅇ", "긴 판이라 존나 짜릿하다 ㅋ", "끝까지 같이 가자 씨발 ㅋ",
		"이쯤 되면 진짜 실력 나온다 ㅋㅋ",
	} },
	win = { level = 1, priority = 2, lines = {
		"이겼다 ㅅㅂ ㅋㅋㅋ", "GG 이겼다 ㅋㅋ", "승리다 씨발 ㅋㅋ", "오늘 존나 잘 풀린다!", "승리의 냥이다 씨발!", "우리가 이겼다 ㅋㅋ 꼴 좋다", "역시 내 주인 ㅇㅈ", "깔끔하게 이겼네 ㅋㅋ", "이겼으니까 츄르 가져와", "잘했다 잘했어 ㅋㅋ", "또 이겼네 ㅋㅋ 쉽다", "이게 실력이지 ㅋㅋ",
		"상대 수고했다 ㅋㅋ 꺼져", "다음 판도 박살 내자", "이길 줄 알았다 ㅋㅋ", "이겼다 이겼다 ㅅㅂ!", "승리 선언한다 ㅋㅋ!", "우리가 해냈다 ㅅㅂ ㅋㅋ", "역시 우리 팀이다 ㄹㅇ", "깔끔한 승리였다 ㅇㅈ", "이겨서 기분 개좋다", "승리 축하한다 씨발 ㅋㅋ",
		"진짜 존나 잘했다", "이긴 판 기념하자 ㅋㅋ", "오늘 운도 실력도 미쳤네 ㅋㅋ", "승리 맛 존나 좋네 ㅋㅋ", "진짜 이겼냐? 실화냐 ㅋㅋ", "다음 판도 이긴다 ㅅㅂ!", "우리 진짜 존나 잘하는 듯", "짜릿한 승리였다 ㅅㅂ", "이 판 기억해 둔다 ㅋㅋ",
		"승리했으니 보상으로 츄르 내놔 ㅋㅋ", "승리 가져왔네 ㅋㅋ 쩐다!", "팀플 존나 완벽했다", "좋은 승부였다 ㅋㅋ", "오늘 칭찬 안 하면 서운하다", "이겼으니 한숨 돌리자 ㅅㅂ", "승리의 기운 받았다 ㅋㅋ", "이 맛에 게임하는 거지 ㅅㅂ!", "승리 파티 열자 ㅋㅋㅋ",
		"깔끔하게 이긴 판이다 ㄹㅇ", "와 씨 진짜 이겼네", "빡센 판이었는데 이겼다 ㅅㅂ", "승리는 역시 달다 ㅋㅋ", "이 기세로 다음 판도 가자!", "잘했다 주인 ㅋㅋ", "이기는 게 제일 좋다 ㅋㅋ", "오늘 승리 기록 추가 ㅅㅂ!", "이긴 판은 오래 기억난다 ㅋㅋ",
		"승리 포즈 한 번 잡아 봐 ㅋㅋ", "이겼으니까 자랑해도 된다", "이번 판 주인공은 너다", "오늘 기분 존나 좋겠다", "이겼으면 간식 줘야지 ㅋㅋ", "결과 좋다 개쩐다!", "달려온 보람 있네 ㅅㅂ", "우리 팀 최고다 ㅇㅈ!",
		"흐름 좋다 그대로 쭉 가자", "이긴 김에 한 판 더 가냐?", "승리 노래 한 곡 뽑을까 ㅋㅋ", "존나 신난다 이겼다!", "승리 소식 알려 줘서 고맙다 ㅋㅋ", "이 기분 다음 판까지 가자 ㅅㅂ", "이긴 건 실력이다 ㅋㅋㅋ", "승리 팡파르 울려라 ㅅㅂ!",
		"오늘 최고의 판이었다 ㄹㅇ", "이겼으니 편히 쉬어도 된다", "승리 도장 쾅! ㅋㅋ", "이 판 MVP는 너다 ㅇㅈ", "잘 이겼다 칭찬해 줄게 ㅋㅋ",
	} },
	winFlawless = { level = 1, priority = 3, lines = {
		"한 대도 못 맞췄쥬? 씨발 ㅋㅋ", "무피로 끝냈다 ㄷㄷ 존나 쩐다", "한 대도 안 맞고 이겼다 씨발!", "완벽 승리~ 상대 눈물 ㅋㅋ", "상대 한 대도 못 쳤네 ㅋㅋ 씨발", "퍼펙트 게임! 개쩐다", "피 한 방울 안 흘렸다 씨발", "무결점 승리 ㄹㅇ 미쳤다", "신이다 신 씨발",
		"이건 레전드 판 ㅅㅂ", "완벽 그 자체 씨발", "상대 멘탈 바사삭 ㅋㅋ", "노데미지 클리어! 씨발!", "교과서 같은 승리 존나", "흠집 하나 없다 씨발", "무피 승리 축하한다 씨발 ㅋㅋ", "상대 완전 압도했다 ㄷㄷ 씨발", "노데미지 승리 전설이다 ㅋㅋ",
		"상처 하나 없이 끝냈네 씨발", "퍼펙트 승리 기록! 존나 쩐다", "맞은 적 없는 판 진짜 미쳤다", "완벽 그 자체 승리다 씨발", "상대 아무것도 못 했네 ㅋㅋ", "피 한 방울 없는 승리 씨발", "무결점 클리어! 개쩐다", "이건 명장면이다 씨발", "상대가 불쌍할 정도다 ㅋㅋ",
		"한 방도 안 맞고 이기다니 씨발", "교과서 같은 판이었다 존나", "이기는 방법 제대로 보여 줬네 씨발", "무피 승리 박제각 ㅋㅋ", "완벽한 플레이 씨발 감탄했다", "맞지 않는 게 최고의 방어다 씨발", "이 판은 두고두고 회자된다 ㅋㅋ",
		"무피 기념으로 간식 쏴라 ㅋㅋ", "상대 멘탈 깨졌겠다 씨발 ㅋㅋ", "흠 하나 없는 승리 ㄹㅇ", "노데미지 전설 등극 씨발", "전부 피했다 씨발 대단하다", "무피 승리 축하 파티! ㅋㅋ", "이런 판 자주 나오면 좋겠다 씨발", "완벽한 판이었다 씨발!",
		"맞은 흔적 제로! 존나", "상대 공격이 안 닿았네 ㅋㅋ", "피 안 흘리고 이기기 쉽지 않은데 씨발", "이 판 스샷 찍어 둬야겠다 씨발", "무피 승리 기록 갱신 ㅋㅋ", "완벽하게 피해 다녔구나 씨발", "승리가 깔끔해서 씨발 기분 좋다", "무결 승리 축하! 씨발",
		"상대 한 명도 못 건드렸네 ㅋㅋ", "이런 건 실력이 있어야 한다 씨발", "무피로 끝내다니 놀랍다 ㅅㅂ", "완벽 승리 확인! ㅋㅋ", "맞은 곳 없이 이겼다 ㄷㄷ", "노데미지 승리 최고다 씨발!", "이 실력이면 랭커 가겠다 ㅋㅋ", "무결점 판 재밌었다 씨발",
		"피해 0으로 끝냈다! 존나", "완벽 전략 승리 씨발", "맞지 않고 이기는 게 제일 멋있다", "무피 승리 감동이다 ㅋㅋ 씨발", "승리 깔끔함 최고 ㅋㅋ", "전부 막아 낸 판 씨발 대단하다", "퍼펙트 클리어 축하해 씨발", "무피면 칭찬 세 번 해야지 ㅋㅋ",
		"완벽한 승리 잘 봤다 씨발", "흠잡을 데 없는 판이었다 존나", "흠 하나 없는 승리 씨발 ㅋㅋ", "무결점 판 재밌었다 ㅅㅂ",
	} },
	winStreak = { level = 1, priority = 2, lines = {
		"%s연승 ㄷㄷ 존나 세다", "%s판 연속 승리 멈출 수 없다 씨발", "연승 중 %s판째 ㅋㅋ 씨발", "오늘 무적이네 %s연승 씨발", "%s연승 질주 씨발", "연승 행진 %s판 ㄹㅇ", "%s판째 이기는 중 ㄷㄷ 씨발", "%s연승이면 랭커각 씨발", "멈추지 마 %s연승 씨발",
		"%s연승 오늘 운 좋네 ㅋㅋ", "연승 %s 달성 씨발", "%s판 무패 행진 씨발", "%s연승은 실력이다 ㅇㅈ", "%s연승 축하 씨발 ㅇㅈ", "이대로 %s연승 쭉 가자 씨발", "%s연승 질주 중 씨발", "연승 행진 %s판째 씨발", "%s판 연속으로 이기는 중 ㄷㄷ",
		"%s연승이면 랭커 각이다 씨발", "%s연승 오늘 운 좋다 ㅋㅋ", "연승 %s 달성 축하 씨발", "%s판 무패 행진 중 씨발", "%s연승은 실력이다 씨발", "이대로 %s연승 쭉 가자 ㄹㅇ", "%s연승 기록 추가 씨발", "연승이 %s판이나 됐네 씨발",
		"%s연승 실화냐 ㄷㄷ", "%s판 연속 승리 축하 씨발", "연승 %s째 흐름 최고 ㅇㅈ", "%s연승 달리는 중 씨발", "오늘 %s연승 찍는다 씨발", "%s판 이기고 여유 있네 ㅋㅋ", "%s연승 레전드 등극 씨발", "%s판째 승리 행진 씨발",
		"연승 %s 돌파 씨발", "%s연승 축하 파티 씨발", "이기는 판이 %s번째다 씨발", "%s연승 기세 무섭다 씨발", "%s판 연속 승리 실력 인정 ㅇㅈ", "%s연승 이어지고 있다 씨발", "%s연승 달성 씨발", "%s판이나 연속 승리 씨발",
		"%s연승 흐름 그대로 가자 씨발", "%s연승 감탄 중이다 씨발", "%s판 연속 이겼다 ㅎㅎ", "%s연승 기록 갱신 씨발", "%s연승 기분 최고다 씨발", "연승 %s째 축하한다 ㅇㅈ", "%s판 무적 행진 씨발", "%s연승 달리는 중이네 씨발",
		"%s판 연속 승리 굿 씨발", "%s연승 레전드 축하 씨발", "%s판째 연승 중 씨발", "%s연승 제대로 탔다 씨발", "%s판 승리 연속 기록 씨발", "%s연승 실력 최고다 씨발", "%s판 연속 이김 축하 씨발", "%s연승 흐름 짜릿하다 씨발",
		"%s연승 기록 찍었다 씨발", "%s판 연속 승리 파티 씨발", "%s연승 이어 가자 씨발", "%s판째 이기는 중이다 씨발", "%s연승 노래 불러 줄까 ㅋㅋ", "%s연승 축하 씨발", "%s판 연속 승리 완벽 씨발", "%s연승 기세 대단하다 씨발",
		"%s연승 실화냐 씨발", "%s판 연속 승리 축하한다 ㅇㅈ", "연승 %s째 달리는 중 ㅎㅎ", "%s연승 멈추지 마 씨발",
	} },
	lose = { level = 1, priority = 2, lines = {
		"졌네 씨발 다음엔 이기자", "아 씨발 졌네 개빡친다", "GG 씨발 다음 판 복수한다", "괜찮아 또 하면 되지 ㅅㅂ", "다음엔 꼭 이긴다 진짜", "아 아깝다 ㅅㅂ", "괜찮아 배운 건 있잖아", "한 판 졌을 뿐이잖아 ㅋㅋ", "상대 좀 하긴 하네 ㅅㅂ", "다시 하면 이겨 ㅇㅇ",
		"기죽지 마 씨발", "패배도 경험이다 ㅋㅋ", "실수 하나였음 ㅅㅂ", "다음 판 두고 봐라", "져도 내 주인이 최고다 ㅇㅈ", "이번엔 져도 괜찮다 ㅋㅋ", "아 조금만 더였는데 개아깝다", "다음 판에 꼭 되갚아 준다", "졌어도 존나 잘 싸웠다", "패배도 경험 되는 거다 알지?",
		"한 판 졌을 뿐이야 쫄지 마", "다음엔 더 잘할 수 있다 ㅅㅂ", "이번엔 상대가 존나 강했네", "져도 괜찮다 같이 가자 ㅋㅋ", "아쉬운 거 털고 다시 가자 씨발", "졌어도 배울 건 존나 많았다", "다음 판 기대해라 ㅋㅋ", "이번 판은 흐름이 ㅈㄴ 안 좋았다",
		"지고 나서 더 강해지는 거다", "실수 하나가 컸다 시발", "잘 싸웠으니 기운 내 ㅅㅂ", "다음엔 이길 거다 믿어 ㅋㅋ", "졌다고 기죽지 마라 진짜", "다시 시작하면 되지 뭐 어쩔", "이번 판은 운이 지랄 같았다", "져도 웃으면서 간다 ㅋㅋ",
		"분하면 다음 판에 풀어 ㅅㅂ", "패배 기록은 금방 지워진다 ㅋㅋ", "실력은 아직 충분하다 ㅇㅈ", "이번 판 복기 한번 해 볼래?", "졌어도 판은 존나 재밌었다", "다음 판은 내가 응원해 준다", "한 번만 더 해 보자 ㅅㅂ", "누구나 지는 날 있다 괜찮아",
		"이번 판 교훈 챙겨서 가자", "졌다고 끝난 거 아님 ㅅㅂ", "패배 원인 찾아보면 도움 된다", "다음 판엔 흐름 ㅈㄴ 좋을 거다", "아깝게 졌네 ㅆㅂ", "이번엔 상대가 한 수 위였다", "다음엔 우리 차례다 두고 봐", "빡쳐도 지금 기분 털고 가자",
		"좀 쉬고 다시 붙어 보자", "지는 것도 게임이다 ㅅㅂ", "그래도 노력한 건 안다 인정", "이번 판은 잊고 다음 판 준비해", "졌어도 응원은 계속한다", "다음 판은 복수 판이다 씨발", "져도 자책은 하지 마라 진짜", "패배 후 리셋 타임이다",
		"진 건 진 거고 다음 판이 중요하다", "이번엔 연습 판이라 치자 ㅅㅂ", "쉬었다 가면 괜찮아진다", "아쉬운 패배지만 잘했다 ㅇㅈ", "다음엔 실수 좀 줄이자 제발", "졌어도 재밌었으면 됐지 ㅋㅋ", "이 패배 나중엔 웃으면서 얘기한다",
		"다시 힘내 보자 씨발", "다음 판에서 제대로 보여 주자 ㅅㅂ", "짧은 패배 긴 교훈 ㅋㅋ",
	} },
	loseStreak = { level = 1, priority = 2, lines = {
		"%s연패 씨발.. 잠깐 쉬고 할까?", "오늘 존나 안 풀리네 물이나 마시고 와", "%s판째 졌네 ㅠ 다음엔 존나 된다", "연패 끊자 씨발! 집중!", "%s연패 개빡친다 쉬어 가자", "흐름 존나 안 좋네 잠깐 쉬자", "%s판 졌다고 뒤지진 않아 씨발",
		"설정 한번 점검이나 해 볼까 ㅅㅂ", "물이나 마시고 와 ㅋㅋ", "%s연패 끊을 차례다 씨발", "멘탈 잡자 ㅅㅂ 존나 흔들린다", "운빨이 그냥 없을 뿐이다", "다음 판은 진짜 된다니까 ㅋㅋ", "%s연패 우연이겠지 씨발", "한숨 돌리고 다시 가자", "연패 존나 중이네 잠깐 쉬자",
		"지금 흐름 존나 엿같네 씨발", "설정 한 번 확인이나 해 볼까", "잠깐 숨 고르고 다시 가자 ㅅㅂ", "연패는 흐름이지 실력 문제 아냐 씨발", "기분 전환 존나 필요하다", "쉬고 다시 하면 달라지겠지 씨발", "마음 편히 먹자 ㅅㅂ 너무 빡치지 말고",
		"지금은 몸도 쉬어야 할 때다 씨발", "작은 승리부터 다시 쌓자 ㄹㅇ", "연패 끊으러 가자 씨발!", "다음 판은 존나 다를 거다", "차분하게 원인이나 찾아보자", "멘탈 관리가 제일 먼저다 씨발", "지금 존나 빡치지?", "한 판 쉬고 와도 괜찮다 ㅋㅋ",
		"연패 금방 끊을 수 있어 씨발", "지금이 진짜 전환점이다 ㅅㅂ", "같이 이겨낼 수 있다 씨발", "쉬면서 전략이나 짜 보자", "조급함이 제일 큰 적이다 씨발", "천천히 다시 시작하자 ㅅㅂ", "연패 때 제일 필요한 건 여유다 씨발",
		"물 한 잔 마시고 다시 해 보자", "지금 설정 점검이나 한번 해 봐라 ㅅㅂ", "마음 정리되면 다시 가자 씨발", "연패 끊는 날 곧 온다 ㅋㅋ", "이번 판은 존나 조심히 가자", "지금 실력은 충분하다 씨발", "흐름 바뀌면 바로 이긴다",
		"숨 고르고 집중하자 씨발", "연패 중이어도 응원한다 ㅅㅂ", "잘하고 있어 씨발 조금만 더", "쉬는 것도 전략이다 ㅋㅋ", "연패 탈출 계획 세우자 씨발", "천천히 가도 괜찮다 ㅅㅂ", "지금부터 차근차근 가 보자 씨발", "마음 다잡으면 달라진다 ㅋㅋ",
		"힘든 만큼 더 강해진다 씨발", "잠깐 쉬어도 실력은 그대로다 ㅅㅂ", "연패 끊고 웃자 씨발!", "나는 믿고 있다 ㅅㅂ", "지금 흐름 존나 바꿔 보자", "기운 내 씨발 같이 있을게", "다음 판 전략 바꿔 볼까 ㅅㅂ", "지는 날도 있는 거다 씨발",
		"조금 쉬면 머리 맑아질 거다", "지금은 다음 판 준비할 때다 ㅅㅂ", "연패는 곧 끝난다 씨발", "멘탈 회복부터 하자 ㅅㅂ", "이번 판엔 욕심 버리자 씨발", "차분하게 하나씩 이기자 ㅅㅂ", "연패 끝내고 축하하자 씨발!", "지금 쉬는 게 답일지도 ㅅㅂ",
		"다음 판에 같이 웃자 씨발",
	} },
	closeMatch = { level = 1, priority = 2, lines = {
		"와 씨 존나 박빙이었네 ㄷㄷ", "킬 데스 똑같네 ㅋㅋㅋ 뭐임", "존나 팽팽했다 ㅅㅂ", "아슬아슬해서 심장 터질 뻔", "진짜 개팽팽했다", "거의 무승부급이네 ㅋㅋ", "씨발 한 끗 차이였네", "명승부 ㄹㅇ ㅋㅋ", "누가 이겨도 이상할 거 없었음", "손에 땀 ㅈㄴ 났다",
		"막상막하 ㅅㅂ!", "존나 쫄깃했다 ㅋㅋ", "다음엔 확실하게 찢는다!", "치열했다 ㅅㅂ", "비긴 거나 다름없네", "킬 데스가 똑같다고? ㅋㅋ", "팽팽해서 미치는 줄 알았다", "한 끗 차이로 갈렸네 ㅅㅂ", "와 이건 명승부 인정이다", "손에 땀 쥐게 하더라 ㅋㅋ",
		"막상막하 대결 존나 쩔었다", "끝까지 긴장해서 죽는 줄 ㅋㅋ", "다음 판엔 확실하게 끝낸다", "싸움 존나 치열했네", "이 판 존나 재밌었다 냥", "박빙 승부 존나 좋아함", "비긴 거나 마찬가지지 뭐", "조금만 더 잘했으면 이겼는데 ㅅㅂ",
		"끝까지 누가 이길지 몰랐네", "서로 존나 잘 싸웠다", "명승부 축하한다 ㅋㅋ", "이런 판이 제일 재밌더라", "차이가 거의 없네 ㅋㅋ", "이 판 두고두고 생각날 듯", "긴장감 미쳤다 ㄹㅇ", "결과 떠나서 존나 재밌었다", "진짜 아슬아슬했음 ㅅㅂ",
		"팽팽하게 맞붙었네 ㅋㅋ", "딱 한 발 차이로 갈렸네", "승패가 쉽게 안 나더라 ㅋㅋ", "서로 실력 인정하는 판 ㅇㅈ", "박빙이라 더 짜릿하네 ㅅㅂ", "다음엔 확실히 갈라버리자", "킬 데스 똑같은 판 처음 봄 ㅋㅋ", "명장면 존나 많았다 이 판",
		"서로 물고 물린 판이네", "긴장 안 풀리는 판이었다 ㅅㅂ", "막판까지 쫄깃했다 ㄹㅇ", "승패 가리기 존나 어려웠다", "진짜 대등한 승부였다 ㅇㅈ", "개뿌듯하다 이 판", "차이가 없어서 더 재밌었네", "다음엔 한 끗 차이로 이기자",
		"명승부 기념 건배 ㅋㅋ", "이런 판은 실력 다 드러나지", "존나 긴장했다 ㅋㅋ", "다음엔 우리가 살짝 앞서자", "팽팽해서 심장 존나 뛰었다", "명승부 인정이다 이 판", "누가 이기든 재밌었음 ㅋㅋ", "박빙 판 최고다 ㄹㅇ", "안 지려고 버텼지 ㅋㅋ",
		"대등한 상대라 존나 좋았다", "결과 차이 없는 판 좋네", "쫄깃한 판이었네 ㅋㅋㅋ", "종이 한 장 차이네 ㅅㅂ", "접전 승리 아니면 접전 패배네", "막상막하 혈투였다 ㅋㅋ", "마지막까지 긴장 못 놨다", "다음 판도 이런 승부면 좋겠다",
	} },
	kill = { level = 1, priority = 2, lines = {
		"ㅋㅋ 컷 ㅅㅂ 쉽네", "하나 정리했다 ㅋㅋ", "나이스 샷 씨발!", "머리 챙겼다 개꿀", "ㅇㅈ? ㅇㅇㅈ ㅋㅋ", "깔끔하네 시발 ㅋㅋ", "잡았다 씨발!", "하나 줄었네 ㅋㅋ", "꺼져 ㅋㅋ 잘 가", "정리 완료 ㅇㅇ", "샷 ㅈㄴ 좋다!", "또 하나 뒤졌다 ㅋㅋ", "역시 ㅋㅋ", "컷컷 ㅋㅋ", "킬 추가다 ㅆㅂ!",
		"하나 정리 끝 ㅋㅋ", "잘 가라 씨발 ㅋㅋ", "정리 끝 다음 놈 나와라", "샷 존나 좋았다", "또 하나 쓰러졌네 ㅅㅂ", "역시 잘 맞네 ㅋㅋ", "컷컷 깔끔하다 ㅅㅂ", "킬 추가 완료 ㅇㅇ", "쏘는 족족 맞네 ㅈㄴ", "한 명 줄었다 개꿀", "잡고 나니까 시원하다 씨발",
		"빙고 씨발!", "이 맛에 게임하지 ㅋㅋ", "킬 땄다 ㅋㅋ", "쓰러뜨렸다 ㅋㅋ", "정확하게 맞췄다 ㅅㅂ", "깔끔하게 처치 ㅇㅇ", "마무리 잘했다 ㅋㅋ", "하나 더 가자 ㄱㄱ", "탕! 뒤졌다 ㅋㅋ", "잡았으면 다음 놈 찾아", "킬 로그 한 줄 추가 ㅋㅋ",
		"좋아 계속 가자 씨발", "뒤진 거 확인했다 ㅇㅇ", "오 주인 좀 치네 ㅋㅋ", "킬 하나 챙겼다 개이득", "이대로 쭉 간다", "조준 맞았다 ㅋㅋ ㅈㄴ", "한 방 제대로 꽂혔다 미친", "정리 잘했네 ㅋㅋ", "이 정도면 괜찮은 교전이네", "수고했다 나 자신 ㅋㅋ",
		"빠르게 처리 완료", "다음 상대 나와라 ㅋㅋ", "끝났다 다음 준비해", "킬 추가요 ㅋㅋ", "적 하나 날아갔다 ㅋㅋ", "정확히 맞혔다 ㅋㅋ", "잘 쏘고 잘 잡았다", "보기 좋게 뒤졌네 ㅋㅋ", "딱 한 명 정리 끝", "킬 맛 개좋다",
		"오케이 하나 완료", "아주 깔끔했다 ㅋㅋ", "잡았다 ㅅㅂ 기분 좋네", "계속 밀어붙이자", "빈틈 없이 잡았다 ㅋㅋ", "킬 ㅊㅋ 잘했다 ㅋㅋ", "사냥 성공이다 ㅋㅋ", "잘 잡았다 칭찬해 줄게", "정리 완료 시발!", "샷 좋았다 ㅋㅋ", "컷컷 ㅋㅋ ㅅㅂ", "쓰러뜨렸다 씨발",
		"정확하게 꽂았다 ㅋㅋ",
	} },
	flawless = { level = 1, priority = 3, lines = {
		"응 한대도 못 맞추쥬 ㅋㅋ 씨발", "ㅋㅋ 한 대도 안 맞았네? 개쩐다", "무피 클리어 상대 존나 불쌍하네", "응 못 맞춰 ㅋㅋ 다음 ㄱ", "한 대도 안 맞고 이기네 ㄷㄷ", "노데미지 킬 ㅋㅋ 존나 쩐다", "맞은 적 없다 ㅋㅋ", "깨끗한 처치 씨발 쩐다", "상처 하나 없이 개쩐다",
		"완벽하게 잡았다 존나 쩐다", "먼저 쏘면 이긴다 ㅇㅈ", "흠 하나 없이 컷 ㅅㅂ", "닿지도 않았어 ㅋㅋ 씨발", "그냥 실력 차이네 ㅇㅈ", "손도 못 댔네 ㅋㅋ 존나 약하네", "한 방도 안 맞고 잡았네 씨발", "피해 하나 없는 킬이네 쩐다", "먼저 쏴서 깔끔하게 끝냈다 ㅇㅈ",
		"상처 없이 잡은 게 최고 ㄹㅇ", "맞기 전에 잡았다 ㅋㅋ 씨발", "흠 없는 교전이네 개쩐다", "노데미지 킬 인정 ㅅㅂ", "상대가 손도 못 댔네 ㅋㅋ", "먼저 쏘는 게 답이네 씨발", "여유 있게 잡았다 ㅇㅈ", "맞은 흔적 없는 킬이다 ㄹㅇ", "깔끔한 한 방 승리 씨발",
		"빠르고 정확했네 ㅇㅈ", "완벽하게 제압했다 존나 쩐다", "맞지 않고 잡는 것도 실력 ㅇㅈ", "이건 교과서 킬이네 씨발", "상대 반응도 못 하고 쓰러졌네", "이런 킬이 제일 기분 좋지 ㅋㅋ", "피 한 방울 없이 끝냈다 ㅅㅂ", "상대를 완전히 앞질렀네 존나",
		"먼저 본 게 이긴 거지 씨발", "무손실 킬 완성 개쩐다", "빠른 판단이 살렸네 ㅇㅈ", "상처 안 받고 잡았다 ㅋㅋ", "흠잡을 데 없는 킬이다", "시원하게 쓰러뜨렸네 씨발", "먼저 쐈으니 이긴 거지 ㅇㅈ", "맞은 적 없는 킬 축하 ㅋㅋ", "깔끔한 제압이네 씨발",
		"상대가 준비도 못 했네 ㅋㅋ", "교전 한 번에 끝났네 ㄷㄷ", "무피 킬 기록 씨발 쩐다", "정확하게 먼저 쐈다 ㅇㅈ", "완벽한 교전 승리 ㄹㅇ", "상처 없이 승리 존나 쩐다", "잡는 과정도 깔끔했네 씨발", "아무도 못 막았다 ㄷㄷ", "먼저 본 자가 이긴다 ㅎㅎ",
		"피해 0으로 잡았네 씨발", "무손실 승리 축하해 ㅋㅋ", "완벽한 선빵 씨발 쩐다", "맞을 틈을 안 줬네 ㅇㅈ", "상대 반격 기회도 없었네", "깨끗한 승리 한 번 더 ㅋㅋ", "빠르게 끝낸 교전이다 ㅇㅈ", "이런 킬 자주 나와라 씨발", "노데미지 킬 감탄 ㄷㄷ",
		"확실하게 잡았다 존나 쩐다", "무결 킬 확정 씨발 쩐다", "상처 없는 승리 좋다 ㅇㅈ", "선제 공격 대성공 ㅋㅋ", "잘 잡았네 흠 하나 없이 ㅇㅈ", "한 방도 안 맞고 잡았네 ㄹㅇ 씨발", "빠르고 정확했네 ㅅㅂ", "교과서 같은 킬이네 ㅋㅋ",
	} },
	firstBlood = { level = 1, priority = 2, lines = {
		"퍼스트 블러드 ㅅㅂ 땄다", "첫 킬은 우리 거지 ㅋㅋ", "시작부터 한 명 갔네 ㅋㅋ", "선취점 가져왔다 시발", "첫 피는 우리 거라고", "오프닝 킬 시작부터 뒤졌네", "기선 제압 끝 쫄았냐", "시작 존나 좋다", "첫 킬 먹었네 ㅊㅊ 개쩐다", "출발 개좋은데?", "선빵 필승이다 ㅋㅋ",
		"먼저 잡았다 느리네", "첫 단추 잘 끼웠다 ㅇㅈ", "분위기 우리가 가져왔다", "퍼블 냥! 미쳤다", "퍼스트 블러드 먹었다 개이득", "첫 킬은 우리가 먹었다", "오프닝 킬 성공 시원하네", "시작부터 흐름 존나 좋다", "첫 킬 굿잡 ㅅㅂ", "출발 좋다 이대로 가자",
		"선빵 필승 ㅇㅈ", "첫 단추 제대로 꿰었다 ㅋㅋ", "분위기 가져왔어 ㅆㅂ 가자", "퍼블 먹었다 개꿀", "첫 피 터졌다 확인", "처음부터 잘 풀리네 씨발", "선취점 확보 꺼져라", "첫 킬 축하한다 오늘 되는 날이네", "오프닝 대성공 ㅋㅋㅋ", "첫 킬은 역시 존나 짜릿해",
		"먼저 쓰러뜨렸다 꼴 좋다", "시작 기세 미쳤다", "첫 킬 기념으로 한 판 더 가자", "시작 좋네 ㅊㅊ", "출발 좋아서 기분 존나 좋다", "첫 킬로 흐름 잡았다 ㅅㅂ", "벌써 앞서가네 ㅋㅋ", "선취점 공격 성공 ㅇㅈ", "첫 번째 킬 완료 ㅋㅋ", "기선 잡았다 쫄지 마라",
		"첫 타 내가 이겼다 ㅋㅋ", "오프닝 장식했다 ㄹㅇ", "첫 킬이 제일 짜릿하다 ㅅㅂ", "선제 타격 성공 개꿀", "시작부터 존나 잘 풀린다", "첫 킬 찍었다 ㅋㅋ", "퍼블 획득 ㅊㅊ", "좋은 시작이다 계속 밀어붙이자", "첫 피 뽑았다 ㅋㅋ", "선빵으로 시작 끝 ㅅㅂ",
		"기세 올라간다 미친", "첫 킬이 판 다 바꾼다", "먼저 잡는 게 중요하다니까", "첫 승은 우리가 가져왔네", "선취 킬 확보 끝", "처음부터 존나 밀어붙이자", "첫 킬 한 번 더 가자 ㅅㅂ", "출발 미쳤다 ㅋㅋ", "첫 킬 파티다 ㅋㅋㅋ",
		"기세 잡았으니까 쭉 가자", "오프닝 킬 제대로 박았다", "첫 피 흘린 놈 불쌍하네 ㅋㅋ", "시작 완벽하다 ㄹㅇ", "선취 성공 ㅊㅊ", "첫 킬 최고다 ㅅㅂ", "첫 킬로 분위기 장악했다", "출발 좋다 이 느낌 좋아", "분위기 확 가져왔다 ㅋㅋ",
		"첫 킬 기념하자 ㅋㅋ",
	} },
	doubleKill = { level = 1, priority = 3, lines = {
		"더블킬!! 개쩐다 씨발", "둘 다 정리 ㄷㄷ 존나 빠르네", "연달아 두 명 ㅋㅋ 미친 손맛", "2킬 순삭이네 ㅅㅂ 빠르다", "더블!! 뭐임 개지린다", "두 명 순삭 ㅋㅋ 존나 깔끔", "연속으로 둘 씨발 한 번에 둘", "더블킬 깔끔 ㄹㅇ 개지림", "2연속 컷 ㄷㄷ 어이없네", "한꺼번에 둘이냐 씨발 사기다", "둘 다 정리함 ㅋㅋ 깔끔하지", "더블킬 떴다!! 존나 좋아",
		"둘이 같이 뒤졌네 ㅋㅋ 꼴좋다", "손 존나 빠르네 ㅎ", "2킬 콤보 ㅈㄴ 맛있다", "더블킬!! 씨발 실력 좀 있네", "두 명 순식간에 털었다 ㅋㅋ", "연달아 둘 잡음 ㄹㅇ 실력자", "더블킬 깔끔하게 터졌다 개좋다", "한 번에 두 명 날렸다 씨발 쾌감", "둘 다 눕혔다 ㅋㅋ 뒤졌지", "더블킬 축하한다 씨발 잘했다",
		"2킬 콤보 완성 ㅅㅂ 개좋다", "손이 존나 빠르네 미친", "더블킬 진짜 나왔네 ㅋㅋ 실화냐", "빠른 연속 처치 성공 씨발 깔끔", "두 명 한꺼번에 처리 ㅋ 개빠르다", "더블킬 기록 또 추가됨 ㅋㅋ", "존나 빠르게 잡았네 ㄹㅇ", "2킬 연속 개멋있다 씨발", "더블킬 대박이다 ㅎㅎ 미쳤다",
		"두 명 금방 뒤졌네 ㅋㅋ 약하네", "더블킬 명장면 ㅈㄴ 지린다", "연속으로 둘 정리 씨발 빠르다", "더블킬 실력 인정함 ㅇㅈ", "눈 깜빡하니 두 명 날아감 ㅋㅋ", "짧은 시간에 둘이나 잡았네 개쩐다", "더블킬 파티 ㅋㅋ 존나 달린다", "2킬 연속 대단하다 씨발 인정", "둘 다 잡아버렸네 ㅋㅋ 미친",
		"더블킬 장인 등극 ㅋㅋ 개쩐다", "둘 한꺼번에 날려버림 ㅅㅂ", "더블킬 나오면 존나 기분 좋지", "연속 2킬 성공 ㄹㅇ 굿", "두 명 싹 정리 완료 ㅋㅋ 깔끔", "더블킬 깔끔하다 씨발 좋다", "쌍으로 뒤졌다 ㅋㅋ 꼴좋다", "빠르게 두 명 처리 ㅈㄴ 빠르네", "더블킬로 흐름 잡았다 ㅋㅋ",
		"더블킬 레전드 등장 씨발 미쳤다", "이 기세 그대로 밀어붙이자 ㅋㅋ", "2킬 연타 굿 ㄹㅇ 존나 좋다", "더블킬 운 좀 탔네 ㅋㅋ 그래도 굿", "두 개 다 맞혔다 씨발 잘 쐈네", "더블킬 존나 빨랐다 ㅋ", "더블킬 땄네 ㅋㅋ 축하함", "두 명 날아갔다 ㄷㄷ 씨발", "더블킬로 판 뒤집었다 ㅋㅋ", "쌍킬 성공 ㅈㄴ 깔끔하다",
		"더블킬 실력 최고 ㅅㅂ 인정", "둘 잡고 여유 부리네 ㅋㅋ 개건방짐", "더블킬 명장면 박제 ㅋㅋ 캡처해", "두 명 연속 처치 씨발 감탄함", "더블킬 날렸다!! 존나 시원하다", "더블킬 연타 성공 ㅋㅋ 미친", "두 명이나 잡았네 개쩐다 ㄹㅇ", "더블킬로 기세 개올랐다 ㅋㅋ", "쌍킬 축하한다 씨발 잘했다",
		"더블킬 진짜 대단하다 ㅅㅂ", "두 명 순식간에 정리!! 씨발 빠르다",
	} },
	tripleKill = { level = 1, priority = 4, lines = {
		"트리플킬!!! 미친 ㅅㅂ", "셋 연속이라고 ㄷㄷㄷ", "혼자 다 쓸어버리네 ㅋㅋ 미쳤다", "트리플!! 오늘 뭐임 ㅋㅋ", "트리플!!! 개대박", "세 놈 연속 ㄷㄷ", "혼자서 셋을? 실화냐 ㅅㅂ", "트리플킬 레전드 ㅇㅈ", "멀티킬 장인 ㅅㅂ", "세 놈 싹쓸이 ㅋㅋ",
		"셋 다 내 거다 ㅋㅋ 씨발 개쩐다", "이게 되네 ㅋㅋㅋ 어이없네", "트리플킬 박제각 ㅅㅂ", "셋 다 뒤졌다 ㅋㅋ", "진짜 미쳤다 ㅈㄴ 쩐다", "세 명 연속이다 ㄷㄷㄷ ㅅㅂ", "혼자서 셋을 잡았네 ㅋㅋ 미친", "레전드 등장 트리플킬 씨발", "멀티킬 장인 인정 ㅇㅈ", "세 명 싹쓸이 끝났다 ㅅㅂ",
		"오늘 작정했구나 ㅋㅋ", "트리플 실화냐? 미친 ㅋㅋ", "박제각이다 트리플킬 ㅅㅂ!", "진짜로 미쳤다 ㅅㅂ", "트리플킬 전설 났다", "세 명 연속 처치 존나 대단하네", "정신없이 쏘고 쏘고 또 쏘고!", "파티다 파티 트리플킬 ㅅㅂ!", "세 놈이 우수수 뒤졌다 ㅋㅋ",
		"트리플 기록 추가 ㄷㄷ 개쩔어", "오늘 판 완전 씹어먹네", "소름 돋잖아 트리플킬 ㅅㅂ", "셋을 한꺼번에 날려 버렸네", "이 실력 어디서 나왔냐 ㅋㅋ", "명장면 완성 트리플킬 ㅅㅂ", "셋 다 잡고 여유롭게 서 있네 ㅋㅋ", "기절할 뻔했다 트리플킬 ㅅㅂ",
		"빠르고 정확하게 셋 처리했네 ㅋㅋ", "기념으로 한 번 더 가자 트리플킬!", "세 놈 쓸어버렸다 ㅅㅂ", "와 이건 진짜 대단한 트리플킬", "ㅊㅋ 트리플킬 진짜 쩐다!", "기세 무섭다 ㅈㄴ", "셋 연속 처치가 실화냐 ㅋㅋ", "대박 사건이다 트리플킬 미친", "셋을 상대로 완승이네 ㅋㅋ",
		"이 판은 트리플킬 판이다 ㅅㅂ", "트리플킬 기록 세웠다 ㅇㅈ", "세 명이나 잡다니 미친 ㅋㅋ", "이 기세 진짜 못 막겠다 ㅅㅂ", "트리플킬 보고 놀랐다 ㅋㅋ", "셋 다 순식간에 뒤졌네 ㅋㅋ", "이 정도면 전설 맞지 ㅇㅈ?", "달성했다 트리플킬 ㅊㅋ ㅅㅂ!",
		"오늘 상대들 존나 불쌍하다 ㅋㅋ", "셋 연속 처치 끝났다", "흐름 씹어먹었다 트리플킬로", "존나 빨랐다 트리플킬", "명장면 나왔다 트리플킬 개쩐다", "셋을 한 방에 날렸다 ㅋㅋ", "개대박이다 트리플킬", "이 기세면 판 끝났다 ㅅㅂ", "트리플 연속 성공 ㅋㅋㅋ",
		"축하한다 트리플킬 ㅅㅂ", "세 놈 다 잡고 편하게 서 있네", "트리플킬 나와서 존나 신난다", "셋 날리는 실력 인정이다", "짜릿하다 트리플킬 ㅋㅋ", "셋 연속 처치 ㅊㅋ ㅋㅋ", "트리플킬 ㅊㅋ!!",
	} },
	killStreak3 = { level = 1, priority = 2, lines = {
		"3킬 연속! 씨발 안 죽네", "킬스트릭 3 존나 간다!", "멈출 수가 없다 ㅋㅋ 씨발", "3연속 처치 ㅋㅋ 개쩐다", "3연속! 씨발 미쳤다", "안 죽고 셋째 ㅅㅂ 개쩐다", "킬 행진 중 존나 잘 간다", "흐름 탔다 씨발 ㄹㅇ", "3킬째 노데스 ㅋㅋ 씨발", "연속 처치 굿 존나 시원해", "계속 가자 씨발!", "멈추지 마 ㅅㅂ!",
		"3킬 스트릭! 개쩐다", "잘 나간다 씨발 ㅋㅋ", "오늘 감 존나 좋다", "3연속 킬 달성! 씨발 쩐다", "안 죽고 셋째 잡았다 ㅋㅋ", "킬 행진 계속 중 씨발", "흐름 제대로 탔다 ㄹㅇ", "3킬째 노데스 굿 ㅅㅂ", "연속 처치 대박 씨발", "계속 가자 계속! 존나", "3킬 스트릭 확인! 씨발",
		"잘 나간다 정말로 ㅋㅋ", "오늘 감 진짜 존나 좋다", "세 번째 킬 축하해 씨발", "3연속 처치 ㅎㅎ 씨발", "연속으로 셋 잡았네 ㅋㅋ", "킬 스트릭 시작됐다 씨발", "3킬 연속 기록 ㄹㅇ", "이 기세 그대로 가자 씨발", "3킬 달성 축하 ㅋㅋ 존나", "연속 킬 이어 가자 씨발",
		"계속 살아남고 있어 ㅋㅋ", "3킬 흐름 최고다 씨발", "세 명 연속 쓰러졌다 ㅋㅋ", "3킬 축하 파티! 씨발", "킬 스트릭 3 달성 ㄹㅇ", "기세 좋다 쭉 가자 씨발", "3연속 킬 레전드 ㅋㅋ", "세 번째 킬 깔끔 씨발", "3킬 노데스 실화냐 ㅋㅋ", "좋은 흐름 3킬째 씨발",
		"3킬 찍었다 ㅎㅎ 존나", "오늘 연속 킬 잘 나온다 씨발", "3킬 축하한다 ㅋㅋ 존나 잘했다", "킬 연속이 이어진다 씨발", "3킬 완성 ㅋㅋ 개쩐다", "연속 셋 처치 굿 씨발", "킬 스트릭 좋아 보여 ㄹㅇ", "3킬 연속 대단해 씨발", "이 흐름 끊기지 마 ㅅㅂ", "3킬 달성 기념 ㅋㅋ",
		"세 명째 쓰러졌어 씨발", "3킬 콤보 굿 존나", "계속 이어 가자 씨발", "3킬 추가 완료 ㅋㅋ", "킬 행진 대성공 씨발", "3연속 킬 축하! 개쩐다", "연속 킬 흐름 대박 ㅋㅋ", "3킬 노데스 축하해 씨발", "세 번 연속 성공 ㄹㅇ", "3킬 달성이다! 씨발",
		"킬 스트릭 축하 ㅋㅋ 존나", "연속 킬 장인 등장 씨발", "3킬째 잘 잡았어 ㅅㅂ", "연속 처치 멋져 씨발", "3킬 흐름 놓치지 마 ㅋㅋ", "킬 연속 좋다 ㅎㅎ 씨발", "셋 연속 쓰러뜨렸다 ㅋㅋ 씨발",
	} },
	killStreak5 = { level = 1, priority = 4, lines = {
		"ㄷㄷ 5연속 킬 개괴물이네", "킬스트릭 5 씨발 아무도 못 막아", "다섯 명째 ㅋㅋ 상대 멘탈 갈렸다", "미친 5킬 노데스네 ㅅㅂ", "스트릭 5킬 ㄷㄷ 존나 쩐다", "누가 좀 막아 봐라 ㅋㅋ 못 막지", "학살 중이다 ㅅㅂ", "다섯째 뒤졌다 ㅋㅋ", "괴물 등장 씨발",
		"5연속이라니 ㄹㅇ 미쳤다", "무쌍 찍는다 개쩐다", "멈출 놈이 없다 ㅋㅋ", "레전드 스트릭 ㅅㅂ", "상대 단체 멘붕 ㅋㅋㅋ", "노데스 5킬 개쩔어", "킬스트릭 5 달성 ㅅㅂ!", "아무도 못 막네 ㅋㅋ 다 꺼져", "다섯 명째 눕혔다 씨발", "괴물 등장 확인 ㄷㄷ", "와 5연속 킬 미쳤다",
		"무쌍 찍고 있네 존나 쉽다", "멈출 사람이 없네 ㅅㅂ", "레전드 스트릭 나왔다 ㅋㅋ", "상대 단체로 멘붕 왔네 ㅋㅋ", "5킬 노데스 대박 ㅈㄴ 쩐다", "축하한다 ㅅㅂ 다섯 연속 처치", "킬스트릭 5 기록 찍었다 ㅋㅋ", "흐름 완전 장악했다 5연속 ㅅㅂ", "연속으로 다섯 명 잡았다 ㅋㅋ",
		"스트릭 5 축하한다냥 ㅅㅂ", "무서울 정도로 쎄다 미친", "킬 머신 5단계 달성 ㅋㅋ", "실화냐 5킬 연속이라니 ㅅㅂ", "ㅋㅋ 다섯 번 연속 성공 쉽네", "오늘 판 완전 독식이다 씨발", "소름 돋네 5킬 달성 ㅋㅋ", "다섯 명째 날려 버렸다 ㅋㅋ", "5킬 흐름 존나 좋다",
		"연속 다섯 처치 개쩐다 ㄹㅇ", "5킬 축하 파티다 ㅅㅂ", "킬스트릭 5 기록 갱신 ㅋㅋ", "이 기세면 판 끝났다 ㅅㅂ", "5연속 명장면 나왔네 미친", "연달아 다섯 명 뒤졌다 ㅋㅋ", "5킬 스트릭 축하한다 씨발", "무쌍 모드 발동 ㅈㄴ 쎄다", "ㅇㅈ 스트릭 5 실력 인정",
		"5킬 연속 무섭다 ㄷㄷ", "다섯 번째까지 깔끔하게 땄다 ㅋㅋ", "5킬 달성 축하해 ㅅㅂ", "연속 킬 5 레전드 ㄹㅇ", "노데스 5킬 축하한다 ㅋㅋ", "스트릭 다섯 번 완성 ㅅㅂ", "상대 전부 눕혔다 ㅋㅋ", "5킬째 깔끔하게 처리 ㅅㅂ", "5연속 킬 전설이다 미친",
		"ㅋㅋ 다섯 명 날리는 실력 봐라", "킬스트릭 축하나 해 줄게 ㅋㅋ", "5킬 달성 기념 ㅋㅋ", "5킬 흐름 놓치지 마라 ㅅㅂ", "대박 ㅋㅋ 다섯 연속 처치", "크 5킬 축하한다 ㅅㅂ", "스트릭 5 연속 성공 개쩐다", "킬 흐름 최고 단계 ㅋㅋ", "5킬 콤보 완성 ㅅㅂ",
		"오늘 판 주인공 너다 ㅋㅋ", "5킬 기록 세웠네 ㅋㅋ", "다섯 명째 처치 굿 ㅅㅂ", "멈출 사람 없네 ㅋㅋ 다 꺼져", "무쌍 모드 발동했다 ㅅㅂ",
	} },
	tenKills = { level = 1, priority = 4, lines = {
		"이번 판 10킬이다 씨발!!", "두 자릿수 킬 ㄷㄷ 미쳤다", "10킬 달성 ㅅㅂ 오늘 날이다", "킬 10개 쌓였다 ㅋㅋㅋ", "와 10킬 돌파 ㅈㄴ 쩐다", "킬 두 자릿수 실화냐 ㄷㄷ", "이번 판 캐리 ㅇㅈ", "10명째다 ㅋㅋ", "MVP 확정 ㅅㅂ", "킬 머신 가동 중이네 ㅋㅋ",
		"ㄹㅇ 10킬은 실력이지", "판을 씹어 먹는다", "열 명 정리 완료 ㅋㅋ", "역대급 판이다 미친", "10킬 ㅊㅋ 냥 ㅋㅋ", "이번 판 10킬 돌파했다 ㅅㅂ", "이번 판 캐리 확실하네 개쩐다", "10명째 눕혔다 ㅋㅋ", "MVP 확정이네 ㅇㅈ", "킬 머신 풀가동 ㅈㄴ 무섭네",
		"인정한다 10킬 실력은", "판을 완전히 지배했다 ㅅㅂ", "역대급 판이다 ㅋㅋ", "10킬 달성 기념이다 ㅅㅂ 쩐다", "두 자릿수 킬 축하한다 씨발", "10킬 대박 사건이다 미쳤네", "열 번째 킬 축하해 ㅅㅂ", "10킬 기록 찍었다 ㅋㅋ", "상대 열 명 날렸다 ㄷㄷ 존나 쩔",
		"10킬이면 전설 맞지 ㅋㅋ", "10킬 파티다 씨발!", "이 판 전설로 남겠다 ㅅㅂ", "미친 10킬 실화냐 ㅋㅋ", "열 명 연속 처치 ㅈㄴ 대단", "10킬 MVP 축하한다 ㅋㅋ", "킬 열 개 채웠다 ㅅㅂ", "10킬 축하 ㅋㅋ 씨팔 쩐다", "두 자릿수 돌파 ㅊㅋㅊㅋ",
		"흐름 ㄹㅇ 최고다 10킬", "이 정도면 프로 아님? ㅋㅋ", "소름 돋네 ㅅㅂ 10킬 달성", "열 명 눕힌 실력 ㅈㄴ 쩐다", "10킬 판 명장면이다", "킬 10 달성 기념 ㅋㅋ", "10킬 찍고도 여유 있네 미친", "판 주인공은 너다 ㅅㅂ", "10킬 완성 박수 ㅋㅋ",
		"열 번째 킬 실력 개쩐다", "기록 갱신 씨발 10킬", "10킬 축하한다 ㅋㅋ", "두 자릿수 킬 실화냐 ㅅㅂ", "10킬 달성 박수 짝짝 ㅋㅋ", "이번 판은 네 거다 ㅅㅂ", "대박이다 ㅈㄴ 10킬", "열 명 다 정리했다 ㅋㅋㅋ", "10킬 축하 한 번 더 ㅅㅂ",
		"킬 열 개면 실력 ㅇㅈ", "대단하다 ㄹㅇ 10킬 달성", "열 번째 눕힘 ㅊㅋ", "존나 짜릿하다 10킬", "판 제압 10킬 달성 ㅋㅋ", "10킬 명장면 완성 미쳤다", "이 판 최고 기록이다 ㅅㅂ", "10킬 또 ㅊㅋ 해 준다 ㅋㅋ", "열 명 처치 완료 축하 ㅋㅋ",
		"흐름 ㅈㄴ 대단하다 10킬", "두 자릿수 킬 ㅊㅋ 한다", "10킬 실력에 감탄하는 중 ㄷㄷ", "이 정도면 프로지 ㅋㅋ 인정", "10킬 달성 ㅊㅋ 씨발!!",
	} },
	clutchKill = { level = 1, priority = 3, lines = {
		"피 바닥에서 잡았냐 ㄷㄷ 미친", "이걸 살아서 잡네 씨발 ㅋㅋ", "클러치!! 심장 존나 쫄깃하다", "죽기 직전에 역관광 ㅋㅋ 개웃기네", "피 한 줌으로 잡았냐 씨발", "죽기 직전 역전이다 ㄹㅇ", "심장 터질 뻔했네 씨팔", "클러치 장인 인정 ㅇㅈ", "이걸 이긴다고? 뭐임", "벼랑 끝 승리 ㄹㅇ 개지림",
		"아슬아슬 컷 씨발 살았다", "근성 대박 ㅋㅋ 미쳤다", "피 없어도 이기네 개쩐다", "역전의 명수 등장이냐 ㅋㅋ", "기적의 킬 씨발 실화냐", "피 한 줌으로 잡았음 ㅋㅋ", "죽기 직전에 역전했냐 ㄹㅇ 미쳤다", "심장 터질 뻔했다 ㄷㄷ 씨팔", "클러치 장인 등극 ㅇㅈ", "아슬아슬하게 컷 ㅅㅂ 살았네", "근성 대박이다 씨발",
		"피 없어도 이기는구나 ㅋㅋ", "역전의 명수 등장 개쩐다", "기적 같은 킬이다 씨발 ㄹㅇ", "죽기 전에 한 방 ㅋㅋ 미쳤다", "체력 바닥에서 잡았냐 씨발", "클러치 킬 축하한다 ㅋㅋ", "마지막 힘으로 잡았네 개쩐다", "간신히 잡았구나 ㄷㄷ 씨팔", "이건 명장면 중 명장면이지 ㄹㅇ",
		"피 없이 역전하다니 미쳤네", "클러치 실력 인정 ㅇㅈ", "죽을 뻔하고 잡았네 ㅋㅋ 씨발", "심장 쫄깃한 킬이다 존나", "극적인 역전 킬 ㅅㅂ 개지린다", "체력 1에서 잡았냐 미친", "이런 게 진짜 승부지 ㄹㅇ", "클러치 킬 축하해 씨발 잘했다", "죽기 직전 한 방 개대단하네",
		"위기에서 살아남은 킬 ㅋㅋ", "클러치 명장면 나왔다 씨발", "이 킬 소름 돋았다 존나", "벼랑 끝에서 이겼냐 ㅅㅂ", "간당간당했는데 잡았네 ㅋㅋ", "클러치 흐름 최고다 개쩐다", "마지막에 웃었네 ㅋㅋ 씨발", "위기 뒤의 승리 ㄹㅇ", "피 한 방울에서 역전 미쳤다",
		"극적인 한 방이었음 씨발", "클러치 킬 대박 ㅋㅋ", "이런 건 두고두고 자랑이지", "죽음 직전 역전 축하한다 씨팔", "심장 멈출 뻔한 킬이네 ㄷㄷ", "체력 바닥 클러치 성공 ㅋㅋ", "기적의 역전 킬 축하해 ㄹㅇ", "위기 탈출 킬 개대단하다", "이거 보고 놀랐다 ㄷㄷ 씨발",
		"극한 상황에서 잡았네 미쳤다", "클러치 실력 최고 ㅇㅈ", "피 없이 승리하다니 씨발 ㅋㅋ", "마지막 순간 역전 ㅅㅂ 미쳤다", "클러치 킬 성공이다 씨팔", "간발의 차 역전 ㅋㅋ 존나 아슬", "죽기 직전 완벽 제압 개쩐다", "피 얼마 안 남았는데 잡았네 씨발", "클러치 명인 인정 ㄹㅇ",
		"극적 승리 축하 씨발 ㅋㅋ", "위기에서 빛나는 실력 ㅇㅈ", "역전 킬이라 더 짜릿하다 존나", "클러치 킬 기념이다 ㅋㅋ 씨발",
	} },
	nearDeathSurvive = { level = 1, priority = 3, cooldown = 25, lines = {
		"와 씨 ㄷㄷ 죽을 뻔했네", "와... 방금 진짜 뒤질 뻔했다 ㄷㄷ", "심장 떨어지는 줄 알았다 ㅅㅂ", "살았다... 와 씨발 ㄷㄷ", "아슬아슬했네 ㅋㅋ 뒤질 뻔", "휴.. 살았다 ㅅㅂ", "간신히 살았네 ㅋㅋ", "아찔했다 ㅅㅂ ㄷㄷ", "목숨 하나 건졌다 ㅋㅋ", "십 년 감수했다 씨발",
		"진짜 개위험했다", "살아남았다 ㅅㅂ!", "생존 성공 ㅋㅋ 개쩐다", "식은땀 존나 났다", "다행이다 진짜 ㅅㅂ", "휴 하 진짜 살았다 ㅋㅋ", "간신히 살아남았네 ㅅㅂ", "살아남았다 다행이다 ㅋㅋ", "식은땀 났다 아 씨", "진짜로 다행이다 씨발", "턱밑까지 왔었네 ㅅㅂ",
		"심장 떨어질 뻔했다", "아슬아슬하게 버텼다 ㅋㅋ", "생존 축하한다 ㅋㅋ!", "다시 살아 돌아왔다 ㅅㅂ", "위험했는데 이겨냈다 ㄹㅇ", "피 거의 없었는데 살았네 ㅋㅋ", "와 진짜 뒤지는 줄 알았다", "살아남은 게 기적이다 ㅅㅂ", "이번엔 운이 개좋았다",
		"위기 넘겼다 휴 ㅅㅂ", "진짜 간당간당했다 ㅋㅋ", "살아서 다행이다 냥", "목숨 아꼈다 ㅋㅋ", "죽을 뻔한 순간 넘겼다 ㅅㅂ", "위험 탈출 성공 ㅋㅋ", "아찔한 순간 잘 넘겼네", "버티니까 살았네 ㅅㅂ", "정말 조마조마했다 씨발", "살아 있는 게 제일 좋은 거다",
		"생존 본능 미쳤다 ㄹㅇ", "가까스로 살아났다 ㅋㅋ", "위기 극복했다 축하한다", "죽음 문턱에서 돌아왔다 ㅅㅂ", "간발의 차로 살았다 ㅋㅋ", "와 숨 좀 돌리자 ㄷㄷ", "살아남은 나 칭찬한다 ㅋㅋ", "심장 아직 존나 뛴다", "살았다 살았다 ㅅㅂ!",
		"이번엔 진짜 아슬했다", "생명 연장 성공 ㅋㅋㅋ", "간신히 버틴 나 대견하네 ㅋㅋ", "조금만 늦었어도 뒤졌겠다", "위험을 넘겼네 ㅅㅂ", "목숨 붙어 있어서 다행이다", "턱걸이로 살았다 ㅋㅋ", "아찔한 생존기네 진짜", "살아남은 판 기억한다 ㅅㅂ",
		"다행히 버텨냈다 ㅇㅇ", "위기 탈출 대성공 ㅋㅋ", "죽었으면 존나 억울할 뻔", "진짜 운이 좋았다 ㅅㅂ", "생존 최고 ㅋㅋ", "진짜 살았네 휴 ㅅㅂ", "목숨값 했다 ㅋㅋ", "살아 돌아왔으면 됐지 뭐", "아 씨 간 떨어졌다", "버티길 잘했다 ㄹㅇ",
		"생존 기념 한숨 한 번 쉰다", "위기 극복 완료 ㅅㅂ",
	} },
	quickKill = { level = 1, priority = 2, lines = {
		"시작하자마자 컷 ㅋㅋ 개빠르네", "빠르다 빨라 미친!", "번개 같은 킬 ㅅㅂ", "눈 깜빡할 새 정리 씨발!", "시작 1초 컷 ㅋㅋ", "번개 킬 씨발!", "빛의 속도네 ㅈㄴ", "눈 깜빡하니 끝 ㄷㄷ", "순식간에 정리 ㅅㅂ", "준비 안 된 상대 ㅋㅋ 개쉽네", "빠르게 한 명 땄다",
		"시작부터 기세 미쳤다", "속공 성공 ㅅㅂ", "첫 교전 승리다 개꿀", "벌써 잡았냐 미친?", "번개 같은 킬이다 개쩐다", "아직 준비도 못 한 놈 뒤졌다 ㅋㅋ", "빠르게 한 명 날렸다 ㅅㅂ", "속공 성공이다 ㄹㅇ", "첫 교전 승리 ㅊㅋ", "벌써 잡았냐? 개대단하네",
		"순식간에 쓰러뜨렸다 씨발", "빛의 속도 킬 지린다", "출발부터 기세 좋네 ㅅㅂ", "눈 깜빡했더니 끝났네 ㅅㅂ", "번개처럼 잡아버렸네 ㅋㅋ", "시작 1초 만에 컷 ㅅㅂ ㄷㄷ", "판단 존나 빠르네", "속도 미쳤네 ㄷㄷ", "바로 잡아 버렸네 ㅅㅂ", "빠른 킬 ㅊㅋ",
		"교전 시작하자마자 끝났다", "이 속도면 아무도 못 따라온다", "시작부터 기세 ㅈㄴ 좋다", "순간 판단 존나 빨랐다", "눈 감고 쏜 거 아니냐 ㅋㅋ", "빠른 제압 성공 ㅇㅇ", "바로 뒤졌네 ㅋㅋ", "빠르게 처리 완료 씨발", "속전속결 성공 ㅅㅂ!",
		"시작부터 번쩍이네 미친", "짧은 교전으로 끝냈다", "빨라서 감탄했다 ㅅㅂ", "빠른 킬 기록 추가", "이건 속공 킬이다 ㅇㅈ", "눈 뜨자마자 잡았네 ㅋㅋ", "손 존나 빠르다", "순식간에 끝난 승부 소름", "시작하면서 바로 잡았다 ㄷㄷ",
		"빠른 킬로 흐름 가져왔다", "빠르게 쓰러뜨린 실력 ㅇㅈ", "속도 최고 ㅇㅈ", "퀵킬 성공 씨발!", "빠르게 판 흔들었다 ㅈㄴ", "아무도 못 막는 속도 ㅅㅂ", "시작 직후 제압했다 개꿀", "빠르고 깔끔했다 ㅅㅂ", "눈 깜짝할 사이에 끝 ㅅㅂ", "퀵킬 ㅊㅋ 개빠르다",
		"속공 실력 감탄했다 ㅇㅈ", "눈 뜨자마자 뒤진 적 ㅋㅋ", "빠른 정리 굿 ㅇㅇ", "순간 승부 이겼다 ㅅㅂ", "빠른 킬 파티다 ㅅㅂ ㅋㅋ", "속도 쩐다 ㄹㅇ", "빠르게 잡아서 존나 편하다", "퀵킬 명장면 찍었다", "눈 깜빡할 새 제압 ㄹㅇ", "빠른 발동 굿 ㅅㅂ",
		"시작 기세 확실하다 ㅇㅈ",
	} },
	longKill = { level = 1, priority = 2, lines = {
		"%s 거리에서 잡았다 ㄷㄷ 미쳤네", "저 멀리서 컷! 저격수냐 씨발 ㅋㅋ", "장거리 킬 존나 멋지다 ㄹㅇ", "그 거리에서 맞히냐? 미친 ㄷㄷ", "%s 거리 저격 성공 씨발 실화냐", "멀리서 툭 ㅋㅋ 개웃기네", "장거리 명사수 인정 ㅇㅈ", "%s 떨어진 적 컷 ㅅㅂ 맞았다", "거리 상관없냐? 존나 짜증나게 잘하네",
		"먼 거리 킬 개굿 씨발", "끝에서 끝까지 맞히냐 씨발 미쳤다", "%s 거리 레전드 찍었네 ㄹㅇ", "원거리 장인 등극 씨팔", "보이기만 하면 그냥 잡네 ㅋㅋ", "저격 각 나왔다 씨발 쏴", "장거리 킬 개멋있다 ㄹㅇ", "그 거리에서 맞히다니 어이없다 ㅋㅋ", "%s 떨어진 적 정리 끝 씨발", "멀리서 툭 쏴서 잡았네 미친",
		"원거리 명사수 등장이냐 ㅋㅋ", "거리 상관없이 맞히는 거 실화냐", "%s 거리 킬 대박 씨발 개쩐다", "끝에서 끝까지 맞혔다 ㄷㄷ", "먼 거리 킬 축하한다 씨발 ㅋㅋ", "저 멀리 있던 적 쓰러졌네 ㅋㅋ", "%s 거리에서도 정확하네 씨발", "장거리 저격 성공 ㄹㅇ 개쩐다", "멀리서 잡는 맛 존나 좋다",
		"거리 재지도 않고 쐈냐? 미친", "%s 떨어진 곳에서 명중이네 ㅅㅂ", "원거리 킬 기록 추가 씨발 ㅋㅋ", "멀어도 소용없다 ㅋㅋ 씨발", "먼 거리 킬 명장면 나왔다 ㄹㅇ", "%s 거리 저격 실화냐 씨팔", "멀리서 쓰러진 적 불쌍하다 ㅋㅋ", "장거리 킬 축하한다 씨발 잘했다",
		"먼 곳에서 깔끔하게 잡았네 ㅇㅈ", "거리 %s 킬 개대단하다 씨발", "원거리 전문가 인정 ㄹㅇ", "멀어도 한 발에 끝냈네 씨발", "%s 떨어진 적도 못 피했네 ㅋㅋ", "장거리 킬 소름 돋는다 씨발", "먼 거리 실력 인정이다 ㄹㅇ!", "멀리서도 정확하게 맞히네 ㄷㄷ",
		"%s 거리 명중 축하 씨발 잘쐈다", "저 멀리 쓰러졌다 ㅋㅋㅋ", "장거리 승부 이겼다 씨발", "원거리 킬 짜릿하다 ㅇㅈ", "%s 거리에서 쏘다니 대담하네 ㅋㅋ", "먼 거리 킬 인증 씨발 ㄹㅇ", "멀리서 찍었다 미쳤네 ㅋㅋ", "장거리 명중 최고다 씨발", "이 거리에서 맞히면 전설이지 ㄹㅇ",
		"%s 거리 킬 박제각 씨발", "먼 곳 적 날려 버렸다 ㅋㅋ", "원거리에서 깔끔한 처치다 씨발", "거리 %s도 문제없네 ㅋㅋ", "멀리서 잡는 건 역시 실력이지 ㅇㅈ", "장거리 저격 대박 ㅎㅎ 씨발", "먼 적도 놓치지 않네 ㄷㄷ", "원거리 킬 축하해 씨발 ㅋㅋ",
		"%s 거리에서 명중 확인 ㄹㅇ", "먼 거리 승부 승리 씨발", "저 멀리서 쓰러뜨렸다 ㅋㅋ", "장거리 킬 기록 갱신이다 씨발", "%s 거리 킬 감탄 중 ㄷㄷ", "멀리서 쏜 게 정확하네 씨발 ㅋㅋ", "먼 곳에서 잡는 쾌감 미쳤다", "장거리 명사수 축하 씨발 ㅋㅋ",
		"먼 거리 킬 명장면이다 ㄹㅇ",
	} },
	closeKill = { level = 2, priority = 2, lines = {
		"코앞에서 따버렸다 ㅋㅋ", "근거리 싸움 개이겼다", "눈 마주치고 쐈네 미쳤다", "기어 와줘서 고맙다 ㅋㅋ", "얼굴 맞대고 컷 ㅅㅂ 쉽네", "붙었는데 이겼다 존나 시원해", "맞짱 떠서 먹었다 개꿀", "왜 와 ㅋㅋ 뒤지려고", "근거리 장인이네 ㄹㅇ", "붙어도 존나 이긴다",
		"칼보다 총이 빠르다 씨발", "1미터 승부 개승", "바로 앞에서 쏴 죽였다", "근접 정리 끝 꺼져라", "눈 마주쳤다 ㅋㅋ 뒤졌다", "바짝 붙어서 컷 ㅋㅋㅋ", "근접전 먹었다 꿀잼", "코앞에서 맞짱 이김", "가까이 오면 뒤지는 거야 ㅋㅋ", "근거리 장인 납셨네",
		"1미터 승부 존나 쉬웠다", "코앞에서 털었다 ㅅㅂ", "근거리 킬 개쩐다 ㅊㅋ", "코앞에서 뻗었네 ㅋㅋ", "붙어서 잡는 것도 ㄹㅇ 실력임", "근거리 교전 이김 냥 ㅋㅋ", "가까이 온 게 존나 실수였지", "근접에서 확실하게 보내버림", "바짝 붙어도 내가 이기지",
		"가까이 온 놈 확실히 잡았다", "근거리 킬 존나 깔끔하네", "코앞 승부는 판단 빠른 놈이 이김", "붙어도 질 수가 없지 ㅅㅂ", "와 근접 킬 레전드 찍었다", "눈앞에서 그냥 쏴버림 ㅋㅋ", "붙어서 쏘는 맛 존나 짜릿해", "근거리 완승 ㅋㅋ 개털렸네",
		"가까이 와줘서 고맙다 잘 가라", "근접 킬 파티다 ㅋㅋㅋ", "코앞에서 바로 삭제 ㅅㅂ", "근거리 전투 존나 재밌다", "붙은 적은 절대 안 놓친다", "붙어서 한 방에 뒤졌다", "근접 킬 깔끔하게 성공 ㅇㅈ", "가까이서 쏘니까 존나 잘 맞네",
		"근거리는 실력 ㅇㅈ", "눈 보고 죽이는 맛이 있네", "가까운 승부 이겼다 꼴 좋다", "근접 전투 이겼다 ㅊㅋ", "바로 앞에서 끝냈다 깔끔하게", "근거리 킬 흐름 개좋다", "붙으면 무조건 내가 이긴다", "가까이선 한 방이면 뒤져",
		"이거 근접 킬 명장면인데 ㄹㅇ", "코앞 제압 끝 ㅋㅋ", "근거리 승부는 실력이지", "근거리 정리 굿 ㅅㅂ 깔끔", "붙어서 잡는 손맛 미쳤다", "근접에서도 손 하나 안 떨리네", "헐 코앞 킬 이게 되네", "가까워도 침착하게 쐈네 ㄷㄷ", "근거리 킬 깔끔하네 ㄹㅇ",
		"바짝 붙은 적 정리 완료 ㅅㅂ", "근접 승부 이겼다 꺼져라", "코앞에서 쏘는 쾌감 개좋네", "붙은 놈 날려버렸다", "근거리 킬 미쳤다 ㄷㄷ", "붙어서 잡는 것도 능숙하네 ㄷㄷ", "근접 킬 하나 추가 ㅋㅋ", "코앞 승부 개꿀잼이었다",
	} },
	wallKill = { level = 1, priority = 2, lines = {
		"벽 너머로 잡았다 ㅋㅋ 존나 쉽네", "숨어도 씨발 소용없지", "벽 뒤 정리 완료 ㅅㅂ", "어디 숨어도 다 보인다 ㅋㅋ", "벽 따위 존나 무의미하네", "숨은 거 다 알고 있었다 씨발", "벽 뒤에서 잘 가라 ㅋㅋ", "엄폐해도 소용없다 씨발", "벽 투과 킬 ㅈㄴ 쉽다", "벽 뒤 사냥 성공 ㅋㅋ",
		"숨바꼭질 내가 이겼다 씨발", "벽 너머 저격 ㅅㅂ 깔끔", "어디 숨어도 잡힌다 씨발", "벽 뒤 정리 끝 ㅋㅋ", "벽이 종이 같네 씨발", "벽은 무의미하다 ㅅㅂ", "숨은 거 다 알고 있었지 ㅋㅋ", "벽 뒤에서 잘 가라 씨발", "엄폐해도 소용없어 ㅅㅂ", "벽 투과 킬 성공 씨발 쩐다",
		"벽 뒤 사냥 성공이다 ㅋㅋ", "숨바꼭질은 내가 이겼다 ㅅㅂ", "벽 너머 저격 대성공 씨발", "벽이 종이 같네 ㅋㅋ 개웃기다", "벽 뒤에서 쓰러졌다 ㅋㅋ 씨발", "숨은 적 찾아서 잡았다 ㅅㅂ", "벽 너머 킬 축하해 씨발", "엄폐물 뒤 적 정리 완료 ㅋㅋ", "벽 뒤에 있어도 다 보인다 씨발",
		"벽을 뚫고 맞혔다 ㅅㅂ", "벽 뒤 킬 명장면 ㅋㅋ", "숨는다고 될 일이냐 씨발", "벽 너머 킬 실력 인정 ㅅㅂ", "엄폐 깨기 성공 씨발!", "벽 뒤에서 깔끔하게 끝냈다 ㅋㅋ", "벽이 방패도 못 되네 씨발", "벽 뒤 적도 안 놓친다 ㅅㅂ",
		"벽 너머 킬 짜릿하다 씨발", "숨은 적 잡는 맛 존나 좋다", "벽 뒤 정리 완료 씨발", "벽 너머 저격 축하한다 ㅋㅋ", "엄폐 무시하고 맞혔다 ㅅㅂ", "벽 뒤 킬 기록 추가 씨발", "숨어 있던 적 쓰러졌다 ㅋㅋ", "벽을 무시하는 실력 존나 쩐다", "벽 너머 명중 축하해 씨발",
		"벽 뒤 적을 제압했다 ㅅㅂ", "숨은 거 다 보인다 ㅋㅋ 씨발", "벽 투시 킬 성공 ㅈㄴ 쩐다", "벽 너머 한 방 깔끔 씨발", "벽 뒤에서도 못 피하네 ㅋㅋ", "벽 뒤 킬 축하 파티다 씨발", "벽이 소용없는 판이다 ㅅㅂ", "벽 너머 정리 대성공 씨발", "벽 뒤 킬 실력 존나 최고",
		"숨은 적도 찾았네 ㅋㅋ", "벽 뒤 제압 완료 씨발", "벽 너머 킬 흐름 좋다 ㅅㅂ", "벽 뒤 적 처리 깔끔 ㅋㅋ", "벽 넘어 맞혔다 씨발", "엄폐 뒤 적 잡았다 ㅅㅂ", "벽 뒤 킬 축하해 ㅋㅋ 씨발!", "벽 너머 깔끔한 한 방 씨발", "벽 뒤 적 날려 버렸다 ㅅㅂ",
		"숨어도 결국 잡히네 ㅋㅋ", "벽 뒤 킬 짜릿하다 씨발", "벽 너머 실력 인정 ㅅㅂ", "벽 뒤 정리 축하 ㅋㅋ", "벽 투과 킬 기록 씨발!", "숨은 적 완전 제압 ㅅㅂ",
	} },
	headshotKill = { level = 2, priority = 2, lines = {
		"헤드 한 방이다 ㅋㅋㅋ", "머리통 정확히 꽂았다 ㅅㅂ", "ㅋㅋ 헤드샷 존나 깔끔하네", "이마에 딱 박았다 ㅋㅋ", "정수리 터졌다 ㅅㅂ", "와 헤드 개깔끔하네", "머리만 노린다 다 죽어", "헤드샷 장인 ㅇㅈ?", "한 방에 머리 날렸다 ㅋㅋ", "에임 머리에 박혔네 ㅈㄴ 쉽다", "이마 정중앙 ㅋㅋ 미쳤다", "헤드 맞았다 ㅋㅋㅋ 꼴 좋네",
		"깔끔한 헤드킬 ㄹㅇ", "머리 사냥꾼 등장 ㅅㅂ", "원샷 원킬 헤드 ㅋㅋ", "정수리 명중 개쩐다!", "크 헤드 존나 깔끔하다!", "머리만 노렸네 소름 ㅋㅋ", "헤드샷 장인 등장 씨발", "한 방에 머리 박았다 ㅈㄴ 쉽네", "에임이 머리에 딱 붙었네 ㅅㅂ", "이마 정확히 뚫었다 개쩔어",
		"ㅊㅋ 깔끔한 헤드킬 ㅋㅋ", "머리 사냥꾼 인정 ㅇㅈ", "헤드 원샷 원킬이다 ㅅㅂ!", "머리 한 방이면 끝이지 ㅋㅋ", "명장면 나왔다 헤드샷 씨발!", "머리통 날아갔다 ㅋㅋ", "헤드 킬 축하한다 ㅋㅋ", "이마 한가운데 꽂았다 미쳤네", "ㄹㅇ 대박이다 헤드샷",
		"머리만 쏘는 실력 인정 ㅅㅂ", "깔끔하게 헤드로 끝냈다 ㅋㅋ", "머리 맞고 쓰러지네 ㅋㅋㅋ", "기록 추가다 헤드샷 ㅅㅂ!", "정수리 한 방 ㅊㅋ 개쩐다", "역시 헤드샷은 존나 짜릿하다", "머리 노리는 감 개쩐다", "미친 헤드샷 연속이다", "머리에 그대로 꽂혔다 ㅋㅋ",
		"소름 돋네 헤드 킬 ㅅㅂ", "이마에 한 방 맞고 뒤졌네 ㅋㅋ", "파티다 파티 헤드샷 ㅅㅂ!", "머리 한 방에 제압 깔끔하네", "마무리는 헤드샷 끝 ㅋㅋ", "머리 정확히 명중 개좋다!", "실력 존나 대단하네 헤드샷", "머리만 콕 찍었네 ㅋㅋ", "기록 갱신했다 헤드 킬 ㅅㅂ",
		"머리 명중 ㅊㅋ ㄹㅇ", "헤드샷 명인 등극 ㅇㅈ", "머리 한 방 대성공 ㅋㅋㅋ", "존나 멋지다 헤드 킬", "정수리 제압 완료 꺼져라", "헤드샷 장인 손맛 ㅅㅂ 짜릿하다", "머리 맞고 털썩 ㅋㅋ 꼴 좋네", "기념으로 한 번 더 박자 헤드샷", "머리 명중 존나 깔끔하다",
		"개짜릿하네 헤드 킬", "이마 명중 대박 미쳤다!", "흐름 ㅈㄴ 좋다 헤드샷", "머리만 노리는 집중력 미쳤다", "축하한다고 헤드샷 ㅅㅂ", "머리를 정확히 뚫어버렸다", "명장면 완성 헤드 킬 ㅋㅋ", "머리 한 방이 제일 좋더라", "명중 확인 ㅇㅋ 헤드샷", "정수리에 꽂았네 ㅅㅂ 쩐다",
		"실력 인정한다 씨발 헤드샷!", "머리 킬 ㅊㅋ 개쩐다",
	} },
	silentKill = { level = 2, priority = 2, lines = {
		"사일런트로 조용히 컷 씨발 깔끔", "소리 없이 정리 ㅋㅋ 개쩐다", "몰래 잡았다 ㅋㅋ 씨발", "티 안 나게 한 명 ㅇㅈ", "보지도 않고 컷 씨발 쩐다", "사일런트 마법 ㄹㅇ 개쩐다", "조용한 암살 씨발", "소리 없이 존나 강하네", "티 안 나게 정리 ㅇㅈ", "사일런트 일 잘하네 씨발",
		"아무도 모르게 컷 ㄹㅇ", "몰래 한 명 ㅋㅋ 씨발", "은밀하게 처치 ㅇㅈ", "고요한 킬 씨발 쩐다", "사일런트 킬 성공 씨발 깔끔하네", "사일런트 마법이다 ㄹㅇ", "조용한 암살 성공 씨발", "몰래 한 명 날렸다 ㅋㅋ", "은밀하게 처치 완료 씨발", "고요한 킬 축하한다 ㅇㅈ",
		"사일런트 킬 성공 씨발", "보이지 않게 잡았다 씨발", "조용히 쓰러뜨렸네 ㅇㅈ", "사일런트 덕분에 편하다 ㅇㅈ", "소리 없이 끝낸 교전 씨발", "사일런트로 깔끔 제압 ㄹㅇ", "몰래 잡는 맛 쏠쏠하네 ㅋㅋ", "사일런트 킬 명장면 씨발", "조용한 승리 축하 씨발",
		"티 없이 정리 완료 ㅇㅈ", "사일런트 명중 축하한다 씨발", "아무도 눈치 못 챘다 ㅋㅋ", "몰래 잡힌 적 불쌍하다 ㅋㅋ", "사일런트 킬 실력 인정 ㅇㅈ", "은밀한 처치 성공 씨발", "소리 없는 승리 ㄹㅇ", "사일런트가 해결했다 씨발", "몰래 쓰러뜨리기 성공 ㅇㅈ",
		"조용히 한 명 처리 씨발", "사일런트 킬 기록 추가 ㅇㅈ", "안 보이는 곳에서 잡았네 씨발", "은신 킬 축하 씨발", "사일런트 덕분에 깔끔하다 ㅇㅈ", "조용하게 끝냈다 씨발", "몰래 잡는 기술 좋다 ㅇㅈ", "사일런트 킬 짜릿하다 씨발", "티 안 나게 제압 씨발",
		"사일런트 킬 대박 ㄹㅇ", "소리 없이 잡았다 씨발", "몰래 잡은 게 제일 통쾌하지 ㅋㅋ", "사일런트 명장면 완성 씨발", "은밀하게 잡는 실력 ㅇㅈ", "사일런트 킬 축하한다 씨발", "보는 사람 없이 끝냈다 ㅇㅈ", "몰래 쓰러진 적 ㅋㅋ 씨발", "사일런트 킬 흐름 좋다 ㅇㅈ",
		"조용한 킬 축하 파티 씨발", "사일런트로 깔끔하게 ㅇㅈ", "안 보이는 한 방 씨발", "사일런트 킬 연속 가자 씨발", "몰래 잡았으니 편하다 ㅇㅈ", "사일런트 킬 최고다 씨발", "은밀한 승리 축하한다 ㅇㅈ", "소리 없이 정리 굿 ㅇㅈ", "사일런트 킬 명인 씨발",
		"조용히 쓰러뜨린 실력 ㅇㅈ", "사일런트 킬 기분 좋다 씨발", "몰래 잡는 것도 실력이다 ㅇㅈ", "사일런트로 조용히 잡았다 씨발", "소리 없이 한 명 정리 ㅎㅎ",
	} },
	bodyShotKill = { level = 2, priority = 2, lines = {
		"몸통으로도 잡히네 ㅋㅋ 개쉽다", "머리 안 보여도 컷 ㅅㅂ", "ㅋㅋ 몸샷으로 끝", "보이는 데 맞히면 끝이지 ㅋㅋ", "바디샷으로 정리 ㅅㅂ", "헤드 안 보여도 ㅇㅋ 상관없다", "쌓은 몸샷으로 컷 ㅋㅋ", "보이는 데만 맞히면 돼 씨발", "몸통도 존나 아프지 ㅋㅋ", "미친 몸샷 장인이네",
		"꾸준히 박아서 컷 ㅅㅂ", "연타로 몸통 쓸어버렸다", "보이는 대로 쐈다 ㅋㅋ", "킬은 킬이다 몸통이든 ㅅㅂ", "끝까지 박아 넣었다 ㅋㅋ", "깔끔하게 몸통으로 마무리", "와 몸샷 쌓아서 킬 ㅋㅋ", "맞히면 장땡이지 보이는 데", "아 몸통도 아프다고 ㅋㅋㅋ", "몸샷 장인 납셨네 ㅋㅋ",
		"몸통 연타로 정리 완료 ㅅㅂ", "보이는 대로 쐈더니 뒤졌네 ㅋㅋ", "몸통 킬도 킬이다냥 ㅅㅂ", "끝까지 맞혔네 개쩐다", "바디샷으로 끝냈네 ㅋㅋ 축하", "머리 대신 몸으로 땄다 ㅅㅂ", "ㅋㅋ 몸샷에 쓰러지네", "오 이건 인정 몸통 킬", "몸샷도 쓸 만하지 ㅋㅋ",
		"몸통 맞고 뻗은 적 ㅋㅋ 꼴좋다", "축하해 ㅅㅂ 몸통 킬 파티다", "헤드 안 보일 땐 몸통이 답이지", "몸샷 연타 성공 ㅋㅋ", "바디샷으로 잡는 것도 ㅈㄴ 짜릿", "캬 몸샷 마무리 깔끔하네", "보이는 곳 박아서 성공", "킬 하나 추가 ㅋㅋ 몸통으로", "와 씨발 몸샷 명장면",
		"감 개좋네 몸통 맞추는 거", "머리 말고 몸으로 잡았다 ㅋㅋ", "ㅋㅋ 몸통 킬 축하한다", "아 씨 몸샷 덕에 살았다", "쌓은 딜이 결실 맺었네 ㅋㅋ", "ㅇㅈ 바디샷 장인이다", "몸통에 박혔다 ㅋㅋ 명중 굿", "소소해도 몸통 킬 중요하다 ㅅㅂ", "ㅅㅂ 몸샷 연속 명중 미쳤네",
		"몸통 마무리 대성공 ㅋㅋ", "머리 안 되면 몸통이지 ㅋㅋ", "몸샷으로 눕혔다 ㅋㅋ", "몸통 킬 축하한다 ㅅㅂ", "역시 몸샷 흐름 개좋네", "바디샷 킬 실력 ㄹㅇ 대단하다", "미친 정확도 몸샷 쩐다", "보이는 곳 제압 완료 ㅅㅂ", "깔끔하게 몸통 명중으로 끝냈다",
		"존나 짜릿하다 이 몸샷 킬", "대박이다 ㅅㅂ 몸통 킬 실화냐", "한 번 더 축하한다 ㅋㅋ 몸샷", "굳이 헤드 아니어도 충분하다 씨발", "마무리 깔끔하다 축하해 ㅋㅋ", "기록 갱신이다 ㅅㅂ 몸통 킬", "손맛 ㅈㄴ 좋다 장인이네", "ㅇㅈ 몸통 명중 깔끔하다", "보이는 몸통 정확히 박았다",
		"바디샷 킬 명장면 ㅋㅋ", "뻗는 거 봐라 ㅋㅋㅋ 몸샷에", "흐름 좋다 ㅅㅂ 몸통 킬 쭉 가자", "파티다 파티 ㅋㅋ 몸샷", "연속으로 몸통 꽂았다 ㅋㅋ",
	} },
	meleeEnemyKill = { level = 1, priority = 2, lines = {
		"칼 들고 오더니 컷당했네 ㅋㅋ", "칼잡이 정리 완료 ㅅㅂ 쉽네", "총 앞에 칼은 좀 아니지 ㅋㅋ", "근접 막고 잡았다 개쩐다", "ㅋㅋㅋ 칼잡이 퇴치", "칼 휘두르기도 전에 컷 ㅅㅂ", "근접 시도 실패 ㅋㅋ 꼴좋다", "칼이 총을 어떻게 이기냐", "가까이 오기 전에 잡았다 ㅋㅋ",
		"근접 러시 씹어 먹었다", "칼 들고 와도 소용없다 씨발", "칼잡이 사냥꾼 등판 ㅋㅋ", "베기 전에 쐈다 ㅋㅋ 느려", "칼 내려놔 ㅋㅋ 이미 뒤졌지만", "칼 들고 총싸움 온 거 실화냐 ㅋㅋ", "칼잡이 퇴치 완료 ㅇㅈ", "칼은 총 못 이긴다니까 ㅋㅋ", "칼잡이 사냥꾼 떴다 ㅅㅂ",
		"ㅊㅋ 칼잡이 제압 개쉽네", "근접 적 깔끔하게 처리했다 ㅋㅋ", "칼 들고 왔다가 뒤졌네 ㅋㅋ", "ㅅㅂ 근접 위협 제거", "칼잡이 한 방에 끝냈다 미쳤다", "칼 든 놈 정리 성공이다", "칼 든 적 하나도 안 무섭다 ㅋㅋ", "와 근접 킬 명장면 ㅈㄴ 멋지네", "칼잡이 흐름 끊어 버렸다 ㅋㅋ",
		"칼 휘둘러 봤자 소용없지 ㅋㅋ", "근접 킬 ㅊㅋ 씨발 굿", "칼잡이 실력은 인정한다 ㅋㅋ", "칼 든 놈 쓰러뜨렸다 씨발 굿", "근접 위협 끝났다 ㅅㅂ", "칼은 총보다 존나 느려 ㅋㅋ", "칼잡이 제압 완료 ㅇㅇ", "근접 킬 기록 추가했다 ㅋㅋ", "칼 맞기 전에 먼저 잡았다",
		"칼잡이 정리 깔끔하네 ㅇㅈ", "근접 적 제압 ㅊㅋ ㅅㅂ", "칼 든 적 완전 제압 ㅋㅋㅋ", "오 근접 킬 ㅈㄴ 짜릿하다", "존나 좋네 칼잡이 잡는 맛", "칼 들고 덤비다 쓰러짐 ㅋㅋ", "근접 킬 흐름 ㅈㄴ 좋다", "ㅊㅋ 칼잡이 사냥 씨발", "칼 가진 적 처리 끝",
		"근접 위협 해결 ㅇㅇ", "칼 들고 온 놈 불쌍하네 ㅋㅋ", "ㅅㅂ 칼잡이 제압 성공 굿", "근접 킬 명장면 완성이다 미친", "칼 든 적 정리 굿 ㅋㅋ", "칼잡이 한 방 컷 ㅅㅂ", "근접 킬 파티다 ㅋㅋㅋ", "칼잡이 막았다 ㅋㅋ 쉽네", "칼 피하고 쏜 게 맞았다 개쩐다",
		"근접 적 깔끔 처리 ㅋㅋ", "대성공이다 칼잡이 사냥 ㅅㅂ", "칼 들고 오면 바로 끝이다", "근접 킬 실력 ㅇㅈ", "칼잡이 잡는 쾌감 ㅈㄴ 좋네", "칼 든 적 완전 정리 끝", "근접 킬 기록 갱신 ㅅㅂ", "ㅋㅋ 칼잡이 쓰러뜨림 ㅊㅋ", "칼 휘두르다 실패 ㅋㅋ 개웃기네",
		"근접 킬 흐름 ㄹㅇ 최고", "칼잡이 제압 완료 ㅋㅋ 쉽다", "칼잡이 쓰러뜨렸다 ㅋㅋ", "칼 든 적 정리 완료 ㅋㅋㅋ", "근접 적 처리 굿 ㅅㅂ", "칼은 총을 못 이기지 ㅋㅋ", "ㅊㅋ 씨발 칼잡이 제압",
	} },
	shieldKill = { level = 1, priority = 2, lines = {
		"방패 돌아서 잡았다 ㅋㅋ 개쩐다", "방패? 씨발 소용없지 ㅋㅋ", "막아봤자 옆으로 뚫는다 ㅅㅂ", "방패 뒤까지 존나 정리!", "방패 뒤에 숨어도 다 보인다", "방패 씹고 그냥 컷 ㅋㅋ", "옆으로 돌아가서 바로 처치", "방패 깨기 성공 ㅈㄴ 쉽네", "방패는 그냥 장식이지 ㅋㅋ", "막아도 씨발 뚫린다",
		"방패 우회 킬 ㅋㅋ 존나 깔끔", "방패 든 애 그냥 정리", "각도 싸움 승리 씨발", "방패 따위가 뭐라고!", "옆구리 공략 성공 ㅅㅂ", "방패 씹고 컷! 개쾌감", "방패 깨기 성공이다 씨발", "방패는 장식이었네 ㅋㅋ", "막아도 뚫고 맞혔다 ㅅㅂ", "방패 우회 킬 개쩐다",
		"방패 든 적 정리 완료 ㅈㄴ 쉽다", "각도 싸움 승리다 씨발!", "방패 따위 소용없다 ㅋㅋ", "방패 뒤 적 그냥 쓰러짐", "방패 우회 명장면 ㅋㅋ 씨발", "방패 무력화 성공 ㅅㅂ", "방패 돌아서 잡았다 씨발", "방패 든 적 제압 축하한다 ㅋㅋ", "방패 옆으로 쏴서 맞혔다 씨발",
		"방패 킬 깔끔하다 ㅈㄴ", "방패 깨는 실력 인정 ㅋㅋ", "방패 우회 킬 기록 씨발!", "방패 뒤에서 쓰러졌네 ㅋㅋ 꼴좋다", "방패 든 적도 못 막았다 씨발", "방패 우회 축하한다 ㅋㅋ", "각도 잘 잡았다 방패 킬 ㅅㅂ", "방패 무시하는 실력 존나 쩐다", "방패 든 적 정리 굿 씨발",
		"옆에서 쏘니까 바로 쓰러졌다 ㅋㅋ", "방패 우회 대성공 씨발", "방패 킬 명장면 완성 ㅋㅋ", "방패 뚫는 감각 최고다 씨발", "방패 킬 축하해 ㅋㅋ 씨발", "방패는 옆으로 뚫는 거다 ㅅㅂ", "방패 든 적 완전 제압 ㅈㄴ 쾌감", "방패 우회 실력 인정 씨발", "방패 킬 짜릿하다 ㅋㅋ",
		"방패 뒤 정리 완료다 씨발", "방패 우회 흐름 존나 좋다", "방패도 소용없는 판이네 ㅋㅋ", "방패 킬 기록 갱신 씨발", "방패 든 적 잡는 맛 ㅅㅂ", "각도 바꾸니 방패도 뚫렸다 ㅋㅋ", "방패 우회 축하 파티다 씨발!", "방패 킬 깔끔한 처리 ㅈㄴ",
		"방패 들었는데 옆구리 맞았네 ㅋㅋ", "방패 깨고 잡은 판 축하한다 씨발", "방패 우회 명인 등극 ㅋㅋ", "방패 킬 실력 존나 대단", "방패 무력화 축하해 씨발", "방패 옆으로 쏘는 게 답이다 ㅅㅂ", "방패 킬 명장면 씨발 ㅋㅋ", "방패 든 적 쓰러뜨렸다 씨발",
		"방패 우회 성공 축하한다 ㅋㅋ", "방패 킬 흐름 최고다 씨발", "방패 뒤 적 정리 굿 ㅅㅂ", "방패 우회 기록 추가됐다 ㅋㅋ", "방패 든 적도 한 방이네 씨발", "방패 킬 축하 ㅋㅋ 개쩐다", "방패 우회 실력 인정이다 씨발",
	} },
	sniperKill = { level = 2, priority = 2, lines = {
		"저격 한 방 ㅅㅂ!", "스나 컷 ㅋㅋ 쉽네", "조준경 속 한 명 삭제 ㅋㅋ", "저격수 데뷔냐? 존나 쩌는데", "저격 장인이네 ㅅㅂ", "한 발 한 킬 존나 깔끔", "스코프 너머 컷 ㅋㅋ", "명중 씨발! 저격이다", "숨 참고 탕 ㅋㅋ", "스나 장인 등장 ㅅㅂ", "원샷 원킬 ㅋㅋ 꺼져", "체질이네 저격수 ㄹㅇ",
		"조준 미쳤다", "스나이퍼 킬 ㅋㅋ", "한 방이면 충분하지 ㅅㅂ", "저격수 데뷔 축하한다 ㅋㅋ!", "원샷 원킬 성공 개쩐다", "스코프 너머에서 뒤졌다 ㅋㅋ", "명중 완료 ㅇㅈ", "숨 참고 쐈더니 맞았네 ㅅㅂ", "오 존나 짜릿하다 저격 킬", "조준 완벽했다 ㄹㅇ",
		"한 발에 쓰러진 적 ㅋㅋ", "저격 킬 축하한다 냥", "헐 스나이퍼 명장면 ㅅㅂ!", "깔끔하게 제압했다 ㅋㅋ", "조준경으로 본 순간 끝났다", "기록 추가 ㅅㅂ 저격 킬", "한 방이면 충분하다 ㅋㅋ", "인정이다 저격 실력 ㅅㅂ", "소름 돋네 ㅋㅋ",
		"스코프 실력 미쳤다", "저격으로 꽂았다 축하한다", "한 방 대박 ㅅㅂ", "조준 한 번에 끝 ㅋㅋㅋ", "스나 킬 흐름 개좋다", "저격 명인 등극 ㅅㅂ", "축하 파티다 ㅋㅋ 저격 킬!", "숨 고르고 쏘니까 맞네 ㅋㅋ", "명장면 나왔다 ㅋㅋ",
		"조준경 속 적 제압 ㅋㅋ", "와 저격 실력 존나 대단하네", "깔끔하다 ㅅㅂ 스나 킬", "저격으로 잡는 맛 존나 좋다", "원샷 제압 축하한다 ㅋㅋ", "기록 갱신 ㅅㅂ 저격 킬", "한 방에 날려버렸다 ㅋㅋ", "짜릿하다 ㅅㅂ 저격 킬", "스코프 안에서 끝났다 ㅅㅂ",
		"저격 명중 축하한다!", "실력 인정함 저격 킬", "스나 한 발 대성공 ㅋㅋ", "조준 정확했다 ㄹㅇ", "축하한다 ㅅㅂ 저격 킬", "스나이퍼 흐름 좋다 ㅋㅋ", "쓰러진 적 ㅋㅋㅋ 저격으로", "저격 킬 명장면이다", "한 발로 판 뒤집었다",
		"저격 실력 축하한다 ㅋㅋ", "스나 킬 한 번 더 축하", "조준경 실력 미쳤다 ㄹㅇ", "대박이다 ㅅㅂ 저격 킬", "숨 참고 맞힌 실력 ㅇㅈ", "깔끔 제압 ㅋㅋ 스나 킬", "기록 추가했다 저격 킬!", "스나 장인 축하한다 ㅋㅋ", "저격 명중 흐름 좋네 ㅅㅂ",
		"원샷 저격 성공 ㅋㅋ", "저격 한 방 축하한다!", "스나 컷 대박 ㅋㅋㅋ",
	} },
	shotgunKill = { level = 2, priority = 2, lines = {
		"샷건 쾅!! 씨발 맛봐라", "산탄 맛 좀 봐라 ㅋㅋ 씨발", "펑 하고 정리 ㅋ 개깔끔", "샷건은 존나 사랑이지 ㅋㅋ", "샷건 펑!! 씨발 뒤져라", "가까이 오면 이렇게 되는 거다 씨발", "샷건 장인 ㅋㅋ 인정하냐", "산탄 한 방 컷 씨발 깔끔", "샷건 존나 사랑한다 ㅋ", "쾅! 정리 씨발 끝", "근접 샷건 승리 ㅅㅂ 존나 쉽네",
		"한 방에 날아갔네 ㅋㅋ 꺼져", "샷건 맛 제대로 봤냐 씨발", "펑 하고 끝 씨발 허무하지", "샷건 클리어 ㅋㅋ 존나 쉽다", "샷건 장인 등장 씨발 미쳤다", "산탄 한 방 컷 ㅋㅋ 개웃기네", "샷건 존나 사랑함 씨발", "쾅! 정리 완료 ㅋㅋ 씨발", "샷건 맛 제대로 봤냐 ㅋㅋ", "펑 하고 끝났다 씨발 ㄹㅇ", "샷건 클리어 축하한다 씨발",
		"샷건 킬 존나 짜릿하다 ㅋ", "샷건 명장면 완성 씨발 개쩐다", "산탄 한 방 대박 ㅅㅂ 미쳤다", "근거리 샷건 깡패 인정함 ㅇㅈ", "샷건으로 제압 씨발 성공", "샷건 킬 기록 또 추가됨 ㅋㅋ", "가까이 붙으면 샷건이 존나 최고", "쾅쾅 제압 축하한다 씨발", "샷건 실력 인정 ㅇㅈ 씨발",
		"샷건 킬 소름 돋는다 씨발 ㄷㄷ", "산탄 맞고 뒤졌네 ㅋㅋ 꼴좋다", "샷건 킬 파티 ㅋㅋ 존나 달린다", "근거리 샷건 명인 ㅋㅋ 씨발", "샷건 한 방이면 끝이지 씨발", "샷건 킬 흐름 존나 좋다 ㅋ", "샷건 제압 깔끔하다 씨발", "샷건 명중 축하한다 ㅋㅋ", "샷건 킬 명장면 ㅅㅂ 지린다",
		"쾅 소리에 맞춰 뒤짐 ㅋㅋ", "샷건 실력 ㅈㄴ 대단하다", "샷건 킬 기록 갱신 씨발 ㄹㅇ", "산탄 제압 축하한다 씨발 ㅋ", "근접에서 샷건 한 방 씨발 끝", "샷건 장인 손맛 존나 좋다", "샷건 킬 축하한다 ㅋㅋ 개잘했다", "샷건으로 확실히 끝냈다 씨발", "샷건 킬 실력 인정 ㅋㅋ 씨발",
		"산탄 맞은 놈 존나 불쌍하네 ㅋㅋ", "샷건 명중 흐름 씨발 좋다", "샷건 킬 대박 ㅅㅂ 존나 쩐다", "샷건 제압 명장면 씨발 지린다", "근거리 샷건 축하한다 ㅋ", "샷건 킬 깔끔 처리 씨발 굿", "샷건 한 방 축하한다 씨발!", "샷건 킬 기록 추가 씨발 ㅋ", "샷건으로 판 뒤집었다 씨발",
		"샷건 킬 흐름 ㅈㄴ 대단하다", "샷건 명인의 한 방 씨발 ㅋ", "샷건 킬 파티 ㅎㅎ 씨발 ㄱㄱ", "샷건 제압 성공 축하 씨발 ㅋ", "샷건 킬 실력 최고 ㅇㅈ 씨발", "산탄 한 방에 뒤졌다 씨발 ㅋ", "샷건 명장면 축하함 씨발 ㅋㅋ", "샷건 쾅! 씨발 한 방이다", "샷건 킬 굿 ㅋㅋ 존나 쉽네",
		"산탄 한 방 축하한다 ㅅㅂ!", "샷건 장인 등장이다 씨발 ㅋ", "근접 샷건 승리!! 씨발 개쩐다",
	} },
	pistolKill = { level = 2, priority = 2, lines = {
		"권총으로 잡았다 ㅋㅋ 존나 쩐다", "보조무기 컷 씨발", "작은 총이 존나 맵다", "피스톨 장인 등장이다!", "권총 장인 인정 ㅇㅈ", "보조무기도 씨발 강하네", "피스톨 킬 굿 ㄹㅇ", "작아도 존나 맵네", "권총으로 마무리 ㅋㅋ", "한 손으로 컷 미쳤다", "피스톨 명중 ㄷㄷ", "권총 실력 좋네 씨발",
		"탕탕 정리 끝 ㅋㅋ", "보조로 충분하지 씨발", "권총 킬 개멋있다", "권총 장인 등장 ㅇㅈ", "보조무기도 강하다 씨발 ㅋㅋ", "작아도 맵다 씨발 ㅅㅂ", "권총으로 마무리 성공 ㄹㅇ", "한 손으로 컷! 미쳤네", "피스톨 명중 축하한다 씨발", "탕탕 정리 완료 ㅋㅋ", "보조로 충분하지 ㄹㅇ",
		"권총 한 발 대박 씨발", "피스톨 명장면 완성이다", "작은 총이 더 세다 씨발", "권총 제압 깔끔하네 ㅇㅈ", "권총 킬 기록 추가 씨발 ㅋㅋ", "피스톨 실력 인정 ㄹㅇ", "권총 한 방에 쓰러졌네", "보조무기 킬 축하 씨발!", "권총 킬 짜릿하다 존나", "피스톨 장인의 손맛 ㅋㅋ",
		"권총으로 잡는 쾌감 씨발", "권총 킬 흐름 최고다 ㄹㅇ", "피스톨 명중 대성공 ㅋㅋ", "권총 실력 대단하네 씨발", "보조무기 명인 등극 ㅇㅈ", "권총 킬 축하 파티다 씨발", "권총 제압 명장면 ㄷㄷ", "피스톨 킬 기록 갱신 씨발", "탕 한 발에 쓰러졌다 ㅋㅋ",
		"권총 킬 실력 최고다 ㄹㅇ", "보조무기도 믿음직하다 씨발", "권총 킬 깔끔 처리 ㅇㅈ", "피스톨 명중 축하해 ㅋㅋ", "권총으로 판 뒤집었다 씨발", "권총 킬 소소한데 존나 좋다", "피스톨 킬 대박 ㄹㅇ", "작은 총으로 큰 승리 씨발", "권총 제압 축하한다 ㅋㅋ",
		"피스톨 명장면 완성이네 씨발", "권총 킬 흐름 좋다 ㅇㅈ", "보조무기 실력 인정 ㄹㅇ", "권총 한 방 축하 씨발!", "피스톨 킬 짜릿하다 ㅋㅋ", "권총 장인 축하 파티 씨발", "탕 소리 깔끔하네 ㄷㄷ", "권총 킬 기록 추가 ㅎㅎ 씨발", "피스톨 명인 인정 ㄹㅇ",
		"권총 킬 실력 대단하다 씨발", "작지만 강한 권총 ㅋㅋ", "피스톨 제압 성공 ㅇㅈ", "권총 킬 축하합니다 씨발", "보조무기 명중 굿 ㄹㅇ", "권총 킬 흐름 최고다 ㅋㅋ", "피스톨로 잡은 적 ㅋㅋ 씨발", "권총 킬 명장면 완성 ㄹㅇ", "권총 킬 축하한다 씨발!",
		"피스톨 한 방 굿 ㅎㅎ 존나",
	} },
	explosiveKill = { level = 2, priority = 2, lines = {
		"펑!! 존나 날아갔다 ㅋㅋ", "폭발 컷 ㅅㅂ 시원하다", "불꽃놀이다 ㅋㅋㅋ 터져라", "로켓 배송 왔다 받아라", "펑!! 시발 쩐다", "날려버렸다 ㅋㅋ 개웃기네", "폭발로 죽이니까 ㄹㅇ 굿", "불꽃놀이 끝 다 터졌다", "로켓 명중 ㅅㅂ 갔다", "펑 하고 사라짐 순삭이네", "폭탄 배달이요 ㅋㅋ 받아", "광역으로 싹 쓸었다 ㅅㅂ", "아 터졌다 ㅋㅋㅋ",
		"폭발물은 내가 장인이지", "날아갔네 잘 가 ㅂㅂ", "펑!! 날아갔네 미친", "싹 다 날려 버렸다 개꿀", "터뜨려서 죽였다 개굿", "로켓 명중 개쩐다", "펑 하고 사라졌네 잘 가라", "광역 정리 성공 꺼져라", "폭발물 장인 납셨다", "완전히 날아갔네 가루 됐다", "폭발 킬 존나 짜릿하다",
		"광역 킬 레전드다 ㄷㄷ", "폭발로 제압 끝 깔끔", "로켓 킬 또 쌓았네", "한 방에 터져서 보냈다 대박", "폭발물 실력 ㅇㅈ", "펑 소리 나자마자 뒤졌다", "폭발 킬 파티다 씨팔", "광역 공격 대성공 ㅋㅋㅋ", "로켓 명중 소름 돋았다", "폭발물 명인 한 방 미쳤네",
		"펑펑 다 정리했다 냥", "폭발 계속 터진다 흐름 미쳤다", "광역 킬 굿잡 개쩐다", "폭탄으로 깔끔하게 처리", "폭발 킬 신기록 찍었다 씨발", "날아간 놈 불쌍하다 ㅋㅋ", "로켓 실력 미쳤네 ㅈㄴ 어이없다", "폭발 명중 굿잡", "광역 킬 짜릿해 ㅅㅂ",
		"폭발물 장인이네 ㄹㅇ", "폭발로 판 뒤집었다", "이건 폭발 명장면이다 ㄹㅇ", "로켓 한 방에 제압 ㅅㅂ 쉽네", "폭발 킬 ㅊㅊ 개이득", "광역 정리 깔끔하네 ㅇㅈ", "폭발물 킬 하나 더 쌓았다", "펑 하고 끝났네 허무하다", "폭발 킬 흐름 개좋다",
		"로켓 명인 등극했네 인정", "폭발 실력은 인정한다 ㅇㅈ", "광역 킬 파티 시작이다", "폭발 한 방 ㅊㅊ ㅆㅂ", "폭발물 명중 대성공", "날려서 쓰러뜨렸다 시원하다", "폭발 킬 대박이네 ㅅㅂ", "로켓 킬 축하한다 존나 부럽네", "광역 제압 성공 꺼져", "폭발물로 판 장악했다",
		"펑! 쓰러짐 확인", "이 맛에 폭발 쓴다 ㅅㅂ", "로켓 킬 명장면이다 ㄷㄷ", "폭발 명인 ㅊㅊ", "광역 연속으로 터진다 개쩐다", "폭발물 정리 끝 시발", "펑!! 날렸다 개시원", "폭발 킬 ㅊㅊ 오늘 잘 터진다",
	} },
	sameTargetAgain = { level = 1, priority = 2, lines = {
		"%s 또 너냐 ㅋㅋ 존나 짜증", "%s 오늘 우리 밥이네 ㅋㅋ", "%s 세 번째다 ㄷㄷ 씨발", "%s 그만 좀 와 ㅋㅋ", "%s 또 왔냐 씨발", "%s 단골이네 ㅋㅋ 개짜증", "%s 오늘 운 없다 ㅋㅋ", "%s 미안 또 잡았다 ㅋㅋ", "%s 우리 팬이냐 씨발",
		"%s 세 번째 사냥 ㄹㅇ", "%s 그만 와도 된다 씨발", "%s 복수하러 왔냐 ㅋㅋ", "%s 오늘 내 밥이다 ㅋㅋ", "%s 또 너구나 씨발", "%s 계속 오냐 ㅋㅋ", "%s 미안해 또 잡았다 ㅋㅋ", "%s 세 번째 사냥이네 씨발", "%s 오늘 내 밥이네 ㅋㅋ",
		"%s 계속 오네 씨발 ㅋㅋ", "%s 이번에도 쓰러졌다 ㅋㅋ", "%s 단골 인증 완료 ㅋㅋ", "%s 또 걸렸네 씨발", "%s 오늘 자주 보네 씨발", "%s 잡히는 게 실력이냐 ㅋㅋ", "%s 다시 와 줘서 고맙다 ㅋㅋ", "%s 또 날아갔다 ㅋㅋ 씨발",
		"%s 왜 자꾸 나오냐 씨발", "%s 세 번째 정리 완료 ㅋㅋ", "%s 오늘 우리 팬이냐 씨발", "%s 못 피하네 ㅠ 씨발", "%s 한 번 더 와 볼래 ㅋㅋ", "%s 또 쓰러졌네 ㅋㅋ", "%s 잡는 거 익숙해졌다 ㅋㅋ", "%s 오늘 두 번이나 맞았지 씨발",
		"%s 이번엔 확실히 잡았다 ㅋㅋ", "%s 또 등장했네 ㅎㅎ 씨발", "%s 좀 쉬어도 되는데 씨발", "%s 오늘 우리 손님이냐 ㅋㅋ", "%s 세 번째 쓰러짐 ㅋㅋ", "%s 또 나를 찾아왔네 씨발", "%s 지치지도 않냐 씨발", "%s 또 잡혔다 ㅋㅋ",
		"%s 오늘 인연이 깊다 씨발", "%s 자주 만나네 씨발", "%s 또 한 방 맞았다 ㅋㅋ", "%s 다음엔 피해 봐 ㅋㅋ", "%s 세 번째 사냥 성공 ㅋㅋ", "%s 우리 또 만났다 씨발", "%s 이제 익숙하다 ㅋㅋ", "%s 또 쓰러뜨렸다 씨발",
		"%s 단골 손님 등장 ㅋㅋ", "%s 오늘 주인공이네 씨발", "%s 이쯤이면 정든 상대 ㅋㅋ", "%s 또 날아갔다 ㅋㅋ", "%s 세 번째 정리 씨발", "%s 또 나타났구나 씨발", "%s 계속 잡히네 ㅋㅋ", "%s 오늘 자꾸 걸린다 씨발", "%s 또 맞은 거 아니냐 ㅋㅋ",
		"%s 한 번 더 도전해 봐 ㅋㅋ", "%s 세 번째 킬 완료 씨발", "%s 오늘도 우리 밥이다 ㅋㅋ", "%s 안녕 또 보네 씨발", "%s 또 나를 만나네 ㅋㅋ", "%s 이번엔 잘 잡았다 ㅋㅋ", "%s 다시 한 번 쓰러짐 씨발", "%s 또 등장 확인 ㅋㅋ",
		"%s 세 번째 사냥 축하 ㅋㅋ", "%s 또 잡았다 ㅋㅋ 씨발", "%s 네 번째 사냥이다 씨발",
	} },
	death = { level = 1, priority = 4, lines = {
		"아 ㅅㅂ 뒤졌네", "ㄲㅂ.. 다음엔 무조건 이긴다", "이걸 죽냐 미친 ㅋㅋ", "아 존나 아쉽다", "한 끗 차이였는데 아 씨발", "으아 죽었다 개빡쳐", "일어나 다시 간다", "아 개아깝다", "됐고 다음 판 가자", "죽을 수도 있지 뭘 ㅋㅋ", "복수하러 간다 따라와",
		"아 씨", "방심했네 아 개짜증", "다음엔 안 져 두고 봐", "다음 목숨은 똑바로 하자 ㅆㅂ", "야 일어나 임마 다시 가자", "다음 판 있잖아 괜찮다 ㅋㅋ", "아 씨 방심했네 ㅋㅋ", "진짜 존나 아쉽네", "이번 판 여기까지네 ㅅㅂ", "뒤졌어도 괜찮다 쫄지 마", "다음엔 좀 살아남자 제발",
		"부활하면 바로 다시 간다", "그래도 존나 잘 싸웠다", "죽는 것도 경험이다 ㅋㅋ", "방심하면 이 꼴 나는 거지", "다음엔 조심 좀 하자 ㅅㅂ", "아 개억울하다 진짜", "또 죽었네 뭐 괜찮아", "쓰러져도 기죽지 마 ㅅㅂ", "이번엔 운이 존나 없었다",
		"죽으면 다시 시작하면 돼", "기회는 아직 존나 많다", "아 진짜 아쉽다고 씨발", "잠깐 숨 돌리고 다시 간다", "이번 건 배운 걸로 치자", "나 쓰러졌다 위로 좀 해라", "다음엔 살아서 웃자 ㅋㅋ", "죽은 김에 정비나 하자", "좀 억울하긴 한데 됐다",
		"다시 일어나면 되지 뭐", "방금 건 실수야 닥쳐", "살아나면 그때 집중해 ㅅㅂ", "이번엔 여기서 끝이네 씨팔", "한 번 더 기회 있다 가자", "아 손이 존나 느렸네", "죽었으니 복수 준비 ㅅㅂ", "다음엔 방어부터 하자 좀",
		"쓰러졌는데 웃음이 나네 ㅋㅋ", "이번 판은 내 실수다 ㅅㅂ", "뒤져도 다음 판은 있다", "어쩔 수 없었다 괜찮아", "먼저 뒤져서 미안하다 ㅋㅋ", "다들 한 번씩은 뒤지는 거다", "부활하면 개강해져서 온다", "이번 죽음 교훈으로 삼아라",
		"아 진짜 잠깐 방심한 거다", "다음엔 실수 안 한다 ㅅㅂ", "죽었다 ㅅㅂ 그래도 괜찮다", "다시 가는 깡이 중요하다", "죽는 것도 게임 일부임 ㅋㅋ", "뒤진 자리 기억해 둔다", "아 이 판 존나 아깝다", "다음 판 기대해라 진짜",
		"쓰러져도 포기는 안 한다", "죽는 건 잠깐이다 별거 아님", "다음엔 꼭 살아남는다 ㅅㅂ", "한 번만 더 살려 주라 아 씨", "죽었으니 조용히 관전한다", "다음 목숨은 아껴 쓰자 씨발",
	} },
	suddenDeath = { level = 1, priority = 4, lines = {
		"뭐야 한 방이라고?? ㄷㄷ 씨발", "어디서 맞은 거냐 씨발?!", "순삭이다 씨발..", "보이지도 않았다 씨발 ㅠ", "한 방이냐 ㅅㅂ?!", "뭐에 맞은 거임?", "갑자기 그냥 뒤졌다 씨발", "어디서 쐈냐 씨발 ㅠ", "순삭 당했다 ㅅㅂ 존나 허무", "눈 깜빡할 새 씨발 끝남", "저격 당한 거냐 씨발",
		"존나 빨랐다 씨발", "보지도 못했다 씨발 뭐임", "어이없게 뒤졌네 ㅋㅋ 씨발", "갑툭튀 씨발 ㅠ", "눈 깜빡하니 끝났다 씨발", "진짜 너무 빨랐다 ㅅㅂ", "뭐가 날아왔는지도 모르겠다 씨발", "순식간에 뒤졌다 ㅋㅋ 씨발", "방금 뭐였냐 씨발?!", "한 방에 훅 갔다 ㅅㅂ 개허무",
		"어디서 맞았는지 모르겠다 씨발", "갑자기 끝나버렸네 씨발 ㅋ", "순삭은 존나 사기다 ㅠ", "눈 깜빡하니 뒤졌다 ㅋㅋ", "아무것도 못 하고 털렸다 씨발", "급사 당했다 ㄷㄷ 씨발", "어디서 쏜 거냐 진짜 씨발", "뭔가 번쩍하더니 끝났다 씨발", "한 방에 날아갔다 씨발 ㅠ",
		"보이지도 않는 놈한테 털렸다 씨발", "순간 사망 ㄷㄷ 미친", "나 아무것도 못 했다 씨발", "갑자기 쓰러져서 존나 당황했다", "너무 갑작스럽다 씨발 ㅠ", "한 대 맞고 끝났네 씨발 ㅋ", "방심하는 순간 훅 갔다 씨발", "눈 뜨니 이미 뒤져 있었다 ㅋㅋ",
		"뭔가 날아와서 끝났다 씨발", "순간 사망 원인 찾는 중 씨발", "이건 존나 억울하다 ㅠ", "한 방 급사라니 씨발 무섭다", "아무 반응도 못 했다 ㅅㅂ", "갑툭튀한 놈한테 털렸다 씨발", "쏜 놈 어디 숨었냐 씨발 ㅠ", "눈 깜빡하니 끝났다 ㅋ", "급사는 역시 존나 무섭다",
		"어이없는 한 방이었다 씨발", "보자마자 뒤졌다 ㅋㅋ", "순삭 당해서 할 말도 없다 씨발", "방금 건 피할 수가 없었다 씨발", "갑자기라서 존나 놀랐다 ㅠ", "한 방에 뒤진 내가 불쌍하다 ㅠ", "예고도 없이 끝났다 씨발", "뭔가 번쩍였는데 그냥 끝 씨발",
		"급사 기록 남겼다 ㄷㄷ 씨발", "안 보이는 데서 쐈나 봐 씨발", "진짜 한순간이었다 씨발", "방금 건 존나 빨랐다 씨발", "눈 감았다 뜨니 끝이냐 씨발", "갑자기 쓰러져서 얼떨떨하다 씨발", "급사는 진짜 무섭다 씨발 ㅠ", "한 방 맞고 훅 갔다 ㅅㅂ",
		"뭐에 맞았는지도 모르겠다 씨발", "순식간의 한 방이었다 ㅋㅋ 씨발", "갑작스런 죽음이네 씨발 ㅠ", "급사 당해서 존나 놀랐다", "이건 존나 피하기 힘들다 씨발", "누가 쐈는지도 못 봤다 씨발", "한 방 급사 확인 ㄷㄷ 씨발",
	} },
	deathStreak2 = { level = 1, priority = 4, lines = {
		"아 씨발 또 죽었네 침착해", "두 번 연속이냐 ㅅㅂ 숨 쉬자", "괜찮아 괜찮아 다음엔 된다", "연속 데스 ㄲㅂ 개빡치네", "또 뒤졌네 하...", "연속으로 털렸네 눈은 장식이냐", "야 잠깐 침착하자 좀", "위치 좀 바꿔 봐 씨발", "괜찮다고 ㅋㅋ 괜찮아", "두 번은 우연이다 ㅇㅇ",
		"정신 좀 차리자 ㅅㅂ", "조심해서 가라 제발", "아직 할 수 있다 ㅋㅋ", "흐름 다시 잡자 씨발", "숨 한 번 쉬고 가 ㅇㅋ", "또 죽었냐 ㅋㅋ 침착하자", "두 번 연속 뒤졌네 아깝다 ㅋㅋ", "잠깐 숨 좀 고르고 가자", "다음 판 있잖아 괜찮아 ㅅㅂ",
		"두 번은 우연이라고 믿자 ㅋㅋ", "다시 정신 차려 씨발 제대로", "다시 가되 조심 좀 해", "흐름 끊겼네 다시 잡아 봐 ㅋㅋ", "숨 한 번 쉬고 가자 시발", "두 번 뒤진 건 아깝다 ㅅㅂ", "위치 좀 바꿔 보는 게 낫지 않냐", "연속 데스는 조심하면 끝이야 ㅇㅇ",
		"이번엔 방어부터 하자 씨발", "벌써 두 번째 뒤졌다 ㅋㅋ", "더 조심해서 가라고 좀", "두 번 연속 뒤졌어도 괜찮다", "지금부터 천천히 가자 ㅅㅂ", "이번엔 실수 좀 줄이자 ㅋㅋ", "연속으로 맞으니까 개빡친다", "다음엔 살아남자냥 씨발",
		"사망 2회차 기록했다 ㅋㅋ", "정신 바짝 차리고 가라 씨발", "연속 데스 탈출 가즈아 ㅅㅂ", "침착하게 한 번만 더 ㅇㅋ", "두 번 뒤졌으니 더 신중하게", "지금이 존나 중요한 순간이다", "두 번 연속은 흔하다 쫄지 마", "뒤진 자리는 피하자 ㅅㅂ",
		"좀 쉬었다 가자 씨발", "두 번째는 덜 억울하지? 솔직히", "이번엔 엄폐부터 박자 ㅅㅂ", "연속 데스에 쫄지 마라 ㅋㅋ", "두 번 뒤져도 실력은 있다 ㅇㅈ", "다음엔 진짜 살아남자 씨발", "이번 판 흐름 존나 안 좋네", "연속으로 당하니 긴장된다 ㅅㅂ",
		"침착함 좀 되찾아라 제발", "두 번 뒤졌으면 교훈 좀 얻자", "지금 위치 조심해 씨발", "두 번 뒤졌으니 이제 집중해 ㅅㅂ", "연속 데스가 제일 답답하다 하...", "일어나서 다시 잘해 보자 ㅋㅋ", "같은 실수 두 번은 안 된다 씨발", "이번엔 판단 빠르게 하자 ㅅㅂ",
		"연속으로 당한 건 잊어 ㅋㅋ", "차분하게 상황부터 봐 좀", "조금만 더 신중하게 가자 ㅅㅂ", "두 번이나 죽다니 아쉽네 진짜", "연속 사망 여기서 끊자 ㅅㅂ", "다음 목숨은 아껴 쓰자 ㅋㅋ", "두 번째 사망 확인 ㅋㅋ 인정", "흐름 되찾을 수 있다 ㅇㅇ", "서두르면 또 뒤진다 ㄹㅇ",
		"두 번 연속이니 조심하자 좀", "정신 차리고 다시 가자 ㅇㅋ",
	} },
	deathStreak3 = { level = 1, priority = 4, lines = {
		"3번째 뒤졌네 ㅅㅂ 위치 바꾸자", "오늘 상대 존나 세네", "멘탈 잡아 씨발 할 수 있어", "3연속은 좀 너무하잖아 ㅆㅂ", "세 번 연속이면 좀 쉬자 ㅅㅂ", "상대가 개강하네", "전략 좀 바꿔 보자 시발", "멘탈 꽉 잡아라 제발", "이럴수록 침착해 빡쳐도",
		"엄폐부터 해 ㅅㅂ", "급하게 하면 또 뒤진다", "한 명씩 따자 한 명씩", "포기 금지다 씨발", "곧 흐름 온다 믿어", "괜찮아 내가 있잖아 ㅋㅋ", "세 번 연속 빡치네 잠깐 쉬자", "상대가 강하긴 존나 강하네", "전략부터 갈아엎자", "주인 멘탈 꽉 잡아 ㅅㅂ",
		"이럴 땐 침착이 답이다", "엄폐 먼저 박고 가자", "조급하면 또 죽는다 ㅅㅂ", "한 명씩 차근차근 따라 ㅋㅋ", "포기는 없다 빡쳐도 간다", "곧 흐름 바뀐다 두고 봐", "괜찮아 옆에 내가 있잖아", "세 번 뒤졌어도 실력은 있다", "3연속 데스 ㅆㅂ",
		"지금은 위치부터 바꿔 ㅈㄴ 중요", "다음 판은 뭔가 다를 거다", "3연속은 ㄹㅇ 억울하다 씨발", "쉬어 가는 것도 방법이다", "지금 상황 다시 봐 제대로", "세 번 죽었으면 이번엔 조심해", "연속 데스 탈출 계획 짜자 ㅅㅂ", "빡쳐도 마음 가라앉히고 가자",
		"3번이나 당하다니 어이없네", "흐름 끊으려면 신중해야지 씨발", "지금 몸 존나 굳었지?", "세 번째 뒤짐 기록됐다 ㅋㅋ", "숨 좀 고르자 ㅅㅂ", "세 번 뒤지면 배운 거 존나 많다", "3연속 데스 원인 분석 타임", "이번엔 엄폐 좀 많이 써라",
		"연속으로 맞으니 빡치지?", "기운 내라 냥 다음엔 된다", "상대 패턴부터 읽어 보자", "세 번이나 쓰러졌네 아 씨", "지금은 빠지는 게 맞다 ㅅㅂ", "3연속은 ㄹㅇ 존나 힘들다", "좀 쉬고 다시 가자 씨발", "흐름 바꿀 한 판이 필요하다",
		"이번엔 판단 신중하게 좀", "세 번 뒤진 만큼 존나 강해진다", "잠깐 쉬어도 실력은 그대로다", "연속 데스 이제 그만 ㅅㅂ", "지금 필요한 건 여유다 여유", "3연속 탈출 가즈아 ㅅㅂ", "세 번째 쓰러짐 존나 아쉽네", "심호흡 한 번 하고 가 ㅋㅋ",
		"지금 위치 조심해 ㅅㅂ", "3번 죽은 건 ㄹㅇ 아깝다", "다음엔 살아남는 연습부터 하자", "차분하게 한 명씩 정리해라", "세 번 뒤지면 멘탈 나가지 ㅋㅋ", "지금 다시 집중해 씨발", "연속 데스 끝낼 때다 이제", "세 번 당했어도 괜찮다 ㅅㅂ",
		"흐름 바뀔 때까지 버텨 보자", "3연속 데스 실화냐 미친",
	} },
	quickDeath = { level = 1, priority = 4, lines = {
		"시작하자마자 뒤졌네 ㅠ 씨발", "나오자마자 뒤졌다 씨발..", "숨도 못 쉬었는데 뒤짐 ㅋㅋ ㅠ", "벌써 끝났냐 씨발 다시!", "시작하자마자 씨발 ㅠ", "준비도 못 했는데 씨발", "빠르게 퇴장함 ㅋ 개허무하다", "스폰킬 당한 거냐 씨발?", "너무 빨리 뒤졌다 ㅅㅂ", "다시 바로 가자 씨발",
		"출발부터 꼬였네 씨발 ㅋㅋ", "아직 시작도 안 했는데 씨발 ㅠ", "급하게 나갔다가 뒤졌네 ㅋ", "숨 고르고 다시 간다 씨발", "에이 씨발 너무 빠르잖아", "시작하자마자 뒤졌다 ㅠ 미친", "준비도 못 했는데 벌써 뒤짐 ㅅㅂ", "존나 빨리 퇴장했네 ㅠ", "너무 빨리 죽었다 씨발 ㅋ", "숨 고르고 다시 가자 씨발 ㄱㄱ",
		"에이 존나 빠르네 ㅠ", "눈 뜨자마자 뒤졌다 ㅋㅋ", "시작 직후 죽음 ㄷㄷ 씨발", "준비 시간이 너무 짧았잖아 씨발", "빠른 퇴장 기록 또 추가함 ㅋㅋ", "출발하자마자 한 방 맞았다 씨발", "스폰 근처에서 털렸다 씨발", "시작부터 운도 없네 씨발 ㅠ",
		"천천히 나갈걸 씨발 후회된다", "시작하자마자 끝나서 존나 억울하다", "출발 직후 뒤짐 ㄷㄷ 씨발", "빨리 다시 준비하자 씨발", "빨리 뒤지는 것도 재능이다 ㅋㅋ 씨발", "숨도 못 쉬었다고 씨발 ㅠ", "나가자마자 날아갔다 ㅅㅂ", "첫 교전이 존나 짧았네 ㅋ",
		"시작부터 정신 차려야겠다 씨발", "빨리 뒤지지 않게 조심하자 씨발", "스폰 위치 조심해라 씨발", "출발 직후 한 방 맞았네 ㅅㅂ ㅋ", "빨리 끝났다 ㅠ 씨발 다시!", "시작에서 그냥 막혔다 씨발", "준비 자세도 못 잡았다 씨발", "나가자마자 당하니 존나 억울하다",
		"빠른 죽음 기록 남겼다 ㅋㅋ", "다음엔 천천히 나가자 씨발", "시작 직후는 존나 조심해야지", "눈 깜빡하니 끝이네 씨발", "출발하자마자 막혔다 씨발 ㅠ", "스폰 직후 공격 개무섭다 씨발", "다음 판은 좀 늦게 나가자 씨발", "빨리 뒤져서 할 말도 없다 ㅋㅋ",
		"존나 짧은 판이네 ㅠ", "시작부터 기운 쭉 빠졌다 씨발", "나가는 순간 털렸다 씨발", "빨리 다시 가서 만회하자 씨발", "시작할 때 주변부터 좀 보자 씨발", "빨리 뒤진 건 금방 잊자 씨발", "시작 직후 한 방이라니 ㄷㄷ 미친", "좀 더 신중하게 나가자 씨발",
		"이른 죽음이 제일 빡친다 씨발", "시작부터 뒤진 내가 ㅠ 씨발", "다음엔 준비 확실히 하자 씨발", "스폰 직후 존나 위험했다", "빨리 끝난 판 다시 가자 씨발!", "나가자마자 쓰러져서 당황스럽다 씨발", "시작하자마자 당한 억울함 씨발 ㅠ", "짧은 죽음에서 교훈 얻자 씨발",
		"이른 퇴장 개아쉽다 씨발", "출발 직후 조심 또 조심 씨발",
	} },
	meleeDeath = { level = 1, priority = 4, lines = {
		"ㅅㅂ 칼에 당했네", "너무 붙었잖아 씨발 거리 벌려", "칼잡이한테 뒤졌다 ㄲㅂ 개빡쳐", "아 근접 존나 무섭네 진짜", "아 씨 칼에 베였다", "너무 가까웠다 ㅅㅂ", "칼잡이 조심했어야지 씨발", "근접한테 졌다 ㅋㅋ 어이없네", "거리 유지 실패 ㅅㅂ", "지랄 등 뒤에서 왔다",
		"아 칼은 존나 아프다 진짜", "다음엔 거리 벌린다 ㅅㅂ", "칼잡이 개짜증나", "베였다 ㅅㅂ", "근접 존나 싫다 냥", "아 너무 가까이 붙었네", "칼잡이 조심했어야 했는데 ㅅㅂ", "ㅋㅋ 근접한테 지다니", "거리 유지 못 했다 씨발", "칼잡이 개미워 ㅅㅂ",
		"역시 근접은 무섭다 ㄹㅇ", "칼 든 놈 조심하자 ㅅㅂ", "붙으면 안 되는 거였는데 ㅅㅂ", "와 칼에 당하다니 존나 아프네", "거리 벌리는 게 답이었는데 씨발", "생각보다 칼 존나 빠르네", "근접 공격은 피하기 존나 어렵다", "칼잡이 튀어나와서 당황했다",
		"가까이 있으면 위험하다 ㅅㅂ", "헐 칼 맞고 쓰러졌네 어이없다", "다음엔 칼부터 보자 ㅅㅂ", "칼은 거리로 막아야 된다고", "어이없네 근접에서 지다니", "칼잡이 얕봤다 ㅅㅂ", "거리 확보 실패가 원인이다 ㅅㅂ", "칼 맞은 자리 존나 아프다",
		"근접전은 조심 또 조심해라", "칼 든 놈 가까이 가지 마라", "베인 거 기억해둔다 ㅅㅂ", "칼잡이 피하는 법 연습하자", "기록 추가했다 근접 사망 ㅅㅂ", "등 뒤에서 칼 왔나 보네 지랄", "가까운 칼은 존나 무섭다", "칼잡이는 거리 유지가 핵심이다",
		"원인 분석 끝났다 근접 사망 ㅅㅂ", "칼에 당했다 교훈 얻었다 ㅅㅂ", "칼 들고 달려오는 거 개무서웠다", "다음엔 칼잡이부터 잡는다", "칼 맞은 곳 존나 쓰리네", "근접 상대는 거리부터 벌려!", "칼잡이 한 방에 쓰러졌다 ㅅㅂ", "붙는 순간 끝이었네 ㅋㅋ",
		"칼 존나 빠르고 무섭다 진짜", "근접한테 죽는 거 진짜 아프다 ㅅㅂ", "칼 피하는 법 익혀야겠다", "근접 상대는 조심하자 ㅅㅂ", "칼잡이한테 졌네 ㅅㅂ", "가까이 와서 당했네 씨발", "칼 든 적 거리 벌렸어야 했다", "근접에서 멈칫한 게 문제다 ㅅㅂ",
		"칼 맞고 쓰러지다니 ㅋㅋ", "거리 유지 중요한 거 실감했다", "근접 죽음 다음엔 피한다 ㅅㅂ", "아니 칼잡이 타이밍 존나 빠르네", "붙으면 칼이 날아온다 ㅅㅂ", "근접에 약한 거 들켰네 ㅋㅋ", "칼 맞은 기억 남겼다", "근접 대응 연습 좀 하자",
		"칼은 역시 위험하다 ㅅㅂ", "거리 두고 쏘는 연습 해야겠다",
	} },
	tradeDeath = { level = 1, priority = 4, lines = {
		"같이 갔네 ㅋㅋ 맞교환 씨발", "1대1 교환이네 존나", "잡고 죽었다! 본전은 씨발 했다", "둘 다 쓰러짐 ㅋㅋ 개웃기다", "같이 사이좋게 퇴장 씨발", "하나 주고 하나 받기 ㅋㅋ", "동시 처치 씨발 ㅋㅋ", "본전은 했다 씨발", "맞교환 완료 ㅅㅂ", "킬 하나 챙겼으니 씨발 됐다",
		"같이 쓰러졌네 씨발", "1대1 교환 성공 ㄹㅇ", "서로 잡았다 ㅋㅋ 씨발", "손해는 아니다 씨발", "무승부 교전 존나 허무하다", "맞교환 완료! 씨발", "같이 쓰러졌네 ㅋㅋ 개웃기다", "무승부 교전이었다 씨발", "같이 가는 것도 나쁘진 않다", "맞교환으로 정리 씨발",
		"킬이랑 데스 하나씩 ㅋㅋ", "같이 죽었지만 씨발 이득이다", "교환 성공 ㅋㅋ 씨발", "동시에 쓰러졌네 씨발 재밌다", "맞교환 끝 씨발 다음 가자", "같이 퇴장 ㅋㅋ 존나", "서로 한 방씩 맞혔네 씨발", "교환이라 씨발 아쉽다", "킬 바꿔 먹기 성공 ㅋㅋ",
		"같이 쓰러지다니 씨발 웃기다", "맞교환이면 씨발 나쁘지 않다", "동시 사망 기록 추가 ㅅㅂ", "본전치기 교전 ㅋㅋ 씨발", "같이 죽고 같이 살자 씨발", "교환 판정 완료 ㅋㅋ", "킬 하나 건졌으니 씨발 괜찮아", "무승부 교전 씨발 재밌었다", "같이 쓰러진 나랑 너 ㅋㅋ",
		"맞교환이 제일 공평하지 씨발", "킬 데스 교환 성공 ㅅㅂ", "같이 갔다 씨발 다음에 또 보자", "서로 잡고 서로 잡혔네 ㅋㅋ", "맞교환 상황 웃기다 씨발 ㅋㅋ", "동시에 끝난 교전 씨발", "본전이니까 씨발 괜찮다", "교환 한 번 더 할래 씨발?",
		"같이 쓰러진 기록 남겼다 ㅋㅋ", "맞교환 깔끔하게 끝 씨발", "킬 하나 획득했으니 씨발 됐다", "서로 한 방씩 주고받았네 ㅋㅋ", "교환이면 나쁘지 않은 결과 씨발", "같이 퇴장 기념 ㅋㅋ 씨발", "1대1 교환 깔끔하다 씨발", "동시 처치 재밌다 ㅎㅎ 씨발",
		"맞교환 완료 확인 ㅅㅂ", "킬 교환 성공이다 씨발", "본전 잡았으니 씨발 만족", "같이 죽은 건 웃기다 ㅋㅋ 씨발", "교환 교전이었다 씨발", "동시 사망 아쉽지만 씨발 괜찮아", "맞교환으로 판 유지 씨발", "같이 쓰러졌지만 할 만했다 씨발", "교환이라 억울하진 않아 씨발",
		"서로 잡은 명장면 ㅋㅋ 씨발", "맞교환 깔끔 처리 씨발", "킬 데스 같이 챙겼네 ㅋㅋ", "동시 사망 재밌다 씨발 ㅋㅋ", "교환 교전 종료 씨발", "같이 가는 판도 있네 씨발", "맞교환 결과 나쁘지 않다 ㅅㅂ",
	} },
	desyncDeath = { level = 2, priority = 4, lines = {
		"순간이동 하다 씨발 뒤졌네", "옮긴 자리 존나 위험했잖아 ㅅㅂ", "그 자리 개별로였네 씨발", "자리 잡다가 또 당했다 ㄲㅂ", "옮긴 데서 바로 털렸다 ㅅㅂ", "순간이동 실패 씨발 ㅠ", "자리 노출됐네 씨발 뭐임", "디싱크 타다가 뒤졌다 ㅈㄴ", "존나 위험한 자리였네",
		"다음 자리는 존나 조심하자", "이동하다 걸렸네 씨발", "타이밍 존나 꼬였다", "숨은 줄 알았는데 씨발", "몸 옮기다가 털림 ㅅㅂ", "그 위치 진짜 별로다 씨발", "옮긴 자리에서 바로 당했네", "자리 노출됐네 씨발 ㅋㅋ", "다음 자리는 존나 조심해라", "이동하다 걸림 씨발 ㅠ",
		"숨은 줄 알았는데 존나 ㅠ", "몸 옮기다 또 당했네 씨발", "그 위치 개별로였네 ㅅㅂ", "이동하자마자 존나 맞았다", "순간이동 자리 존나 나빴다", "옮긴 몸부터 노출됐네 씨발", "자리 선택 존나 아쉽다 ㅠ", "디싱크 자리 조심 좀 해라 ㅅㅂ",
		"옮기고 나니 바로 털렸다 씨발", "이동 타이밍 존나 놓쳤다", "숨은 자리 들켰잖아 씨발", "몸 옮긴 곳 존나 위험했다", "다음엔 다른 자리로 가자 씨발", "이동하다 맞다니 억울해 ㅠ 씨발", "순간이동 실패 또 기록이냐 ㅅㅂ", "옮기는 순간 노렸냐 씨발",
		"자리 잘못 골랐네 ㅅㅂ ㅋㅋ", "디싱크 후 사망 확인 씨발", "이 자리는 피했어야 했는데 ㅅㅂ", "옮긴 곳에 적 있었던 거 실화냐", "순간이동 중에 쓰러졌네 씨발", "위치 선정 실패 존나 짜증 ㅠ", "옮긴 자리 기억해 둔다 씨발", "디싱크 실패 존나 교훈이다",
		"옮기니까 바로 들켰다 씨발", "이동 자리 다시 생각 좀 하자 ㅅㅂ", "순간이동 직후 뒤졌다 씨발", "몸 옮긴 자리가 문제였다 ㅅㅂ", "디싱크 자리 연습 존나 필요하다", "자리 바꾸다 또 당했다 씨발 ㅠ", "옮긴 곳 너무 가까웠잖아 씨발", "이동 후 노출 실수 개짜증",
		"디싱크 죽음 교훈 저장 씨발", "옮긴 자리 조심하자 ㅅㅂ ㅋㅋ", "순간이동 실패 존나 아쉽다", "자리 잡다 털렸네 씨발", "디싱크 위치 존나 나빴다", "옮기는 타이밍 존나 중요하다 ㅅㅂ", "이동 자리 다음엔 바꾸자 씨발", "디싱크 후 바로 맞았다 ㅠ 씨발",
		"옮긴 위치 들킨 거 같은데 ㅅㅂ", "순간이동 죽음 기록 또 추가됐네", "이 자리 다시 쓰지 말자 씨발", "디싱크 실패 존나 아쉽다 ㅅㅂ", "옮긴 몸이 바로 공격받았다 씨발", "자리 선택 다시 점검하자 ㅅㅂ", "순간이동 후 당황해서 뒤졌다", "디싱크 자리 교훈 제대로 남겼다 ㅅㅂ",
		"옮긴 곳에서 맞은 거 존나 아쉽다", "이동 후 바로 쓰러짐 ㅠ 씨발", "자리 바꾼 게 실수였나 씨발",
	} },
	nearDeathWarn = { level = 1, priority = 3, lines = {
		"앗 씨발 피 없어!!", "위험해 위험해!! 존나 위험해", "야 조심해!! 씨발 조심해", "체력 바닥이라고!!", "피 거의 없다 ㅅㅂ!", "후퇴해!! 빨리 씨발", "엄폐! 엄폐! 뭐 하냐 씨발!", "한 대면 끝이다 씨발!", "빨리 숨어 ㅅㅂ!!", "위험 위험 ㅈㄴ 위험!", "체력 경고 씨발!!",
		"조심 또 조심 ㅅㅂ!", "도망쳐 씨발!!", "피 채우자 ㅋㅋ 빨리", "아슬아슬하네 씨발!!", "피 거의 없다 존나!!", "한 대면 끝이라고!! ㅅㅂ", "빨리 숨으라고 씨발!!", "위험 위험 ㅅㅂ!!", "피 채우자 존나!!", "체력 바닥이다 씨발!!", "지금 당장 숨어 ㅋㅋ 씨발!!",
		"한 방이면 죽는다 ㅅㅂ!!", "위험 신호 떴잖아 씨발!!", "피 없는데 위험하다 ㅋㅋ", "뒤로 빠져 씨발!!", "엄폐물 찾아 ㅅㅂ!!", "체력 확인 긴급이다 씨발!!", "지금 당장 물러서 ㅋㅋ!!", "한 대 맞으면 끝 씨발!!", "피 얼마 안 남았잖아 ㅅㅂ!!",
		"조심 조심 조심 씨발!!", "엄폐 안 하면 죽는다 ㅋㅋ!!", "위기 감지 씨발 숨어!!", "체력 위험 구간이다 ㅅㅂ!!", "빨리 회복부터 씨발!!", "지금 싸우면 죽는다 ㅋㅋ!!", "체력 빨간불 씨발!!", "엄폐 최우선이다 ㅅㅂ!!", "움직이면 맞는다 존나!!",
		"피가 위험 수준이다 씨발!!", "도망이 답이다 ㅋㅋ!!", "지금 당장 피해 씨발!!", "체력 바닥 경고 ㅅㅂ!!", "빨리 물러나 씨발!!", "한 방 맞으면 끝이다 ㅋㅋ!!", "숨을 곳 찾아 씨발!!", "위험 상태 진입 ㅅㅂ!!", "체력 긴급 경고 씨발!!", "지금 조심하라고 ㅋㅋ!!",
		"엄폐하고 회복해 씨발!!", "피 없으니 피해 ㅅㅂ!!", "체력 확인해 보라고 씨발!!", "한 대도 맞으면 안 돼 ㅋㅋ!!", "위험 신호 강하다 씨발!!", "빨리 엄폐로 ㅅㅂ!!", "체력 최저치다 씨발!!", "지금 몸 사려 ㅋㅋ!!", "위험해 씨발 숨어!!",
		"피 떨어지고 있어 ㅅㅂ!!", "체력 부족 경고 씨발!!", "엄폐 지금 바로 ㅋㅋ!!", "빨간불 켜졌다 씨발!!", "도망 준비해 ㅅㅂ!!", "피 회복부터 해 씨발!!", "체력 위기 상황 ㅋㅋ!!", "지금 당장 빠져 씨발!!", "위험 탈출 필요 ㅅㅂ!!", "체력 경고 연속 씨발!!",
		"빨리 숨 돌려 ㅋㅋ!!",
	} },
	bigHit = { level = 1, priority = 2, cooldown = 6, lines = {
		"아야 %s 씨발 깎였네", "세게 맞았다 ㄷㄷ 존나 아프네", "아프다 아파 씨발", "큰 거 한 방 맞았어 ㅅㅂ", "%s 맞았어 존나 아프다", "크게 한 방 ㅠ 씨발", "%s나 깎였다 ㅅㅂ", "세게 맞았어 씨팔", "아야 %s 뭐임 이거", "강펀치 맞았다 ㄹㅇ 개아파",
		"%s 데미지 들어왔네 씨발", "피 훅 빠졌다 ㅅㅂ", "조심해 세게 쏜다 씨발", "%s 아프다 ㅠ 존나 짜증", "큰 피해 받았네 씨발", "크게 한 방 맞았다 ㅠ 존나", "%s나 깎였어 개빡친다", "강펀치 맞았어 ㅠ 씨발", "%s 데미지 들어왔다 ㅅㅂ", "피 훅 빠졌다 ㅋㅋ 개망함",
		"조심해 세게 쏴 온다 씨발", "크게 한 대 맞았네 ㅠ", "%s 깎였으니 조심하자 씨발", "한 방이 세다 ㄷㄷ 존나 세", "%s 맞고 휘청했어 씨팔", "강하게 맞았어 ㅠ 존나 짜증", "%s 피해 실화냐 ㅅㅂ", "큰 거 맞았다 존나 아프네", "%s나 빠졌어 ㅠ 씨발",
		"세게 맞으니 개놀랐다", "%s 데미지 큼 조심 씨발", "아 이건 존나 아프다 ㅠ", "%s 맞았는데 아직 살아 있네 씨발", "한 방에 많이 깎였다 ㅅㅂ", "%s 피해 크다 조심해 ㅅㅂ", "큰 한 방이네 ㄷㄷ 씨발", "%s 맞아서 정신 번쩍 ㅅㅂ",
		"강하게 쏜 놈 누구야 ㅠ 씨발", "%s 깎여서 긴장된다 씨발", "세게 맞고 비틀거렸다 ㅅㅂ", "%s 맞았어 엄폐하자 씨발", "큰 데미지 받았다 ㅠ 존나", "%s 맞으니까 존나 아프다", "한 방 강타 당했어 ㅅㅂ", "%s 맞고 피 줄었어 ㅠ", "세게 한 대 맞았다 ㅅㅂ",
		"%s 데미지 큰데 씨발?", "큰 피해라 긴장돼 ㅠ 씨팔", "%s 맞았어 조심하자 씨발", "강력한 한 방이었다 ㄹㅇ 존나", "%s 깎여서 위험해진다 씨발", "세게 맞아서 놀람 ㄷㄷ", "%s 피해 받았다 ㅠ 존나", "큰 피해 받아서 아파 씨발", "%s 맞고 흔들렸어 ㅅㅂ",
		"한 방에 훅 깎였다 씨팔", "%s 맞았으니 엄폐 씨발", "큰 데미지 조심 ㅠ 존나", "%s 맞아서 아프다 씨발", "세게 맞은 한 방 존나 아프네", "%s 깎여서 빨간불 씨발", "큰 피해 받으니 무섭다 ㅠ", "%s 데미지 강하다 ㄷㄷ 씨발", "한 방 크게 맞았어 ㅠ 씨발",
		"%s 맞았는데 살았다 ㅅㅂ", "세게 맞고 바로 숨었다 ㅅㅂ", "%s 피 줄어든 거 봐 씨발", "큰 데미지에 놀랐어 ㅠ", "%s 맞았어 빨리 회복 씨발", "강한 한 방 맞고 긴장 ㅅㅂ",
	} },
	chipDamage = { level = 2, priority = 1, cooldown = 15, lines = {
		"아 씨발 계속 찔끔 맞네", "쏘는 놈 누구냐 ㅅㅂ", "존나 따끔거리네 아 씨", "엄폐 엄폐 빨리 ㅅㅂ!", "자꾸 맞잖아 씨발", "누가 계속 쏘냐 ㅈㄴ", "피 찔끔찔끔 닳는다", "위치 들켰네 ㅅㅂ", "몸 숨겨 좀 빨리", "자꾸 긁히네 개짜증나", "총알 존나 쏟아지네",
		"야 계속 맞는 중이다", "움직여 가만있지 마!", "엄폐물부터 찾아 ㅆㅂ", "아 따갑다고 씨발", "맞고만 있잖아 지금", "어떤 놈이 계속 쏘는 거냐", "피 야금야금 깎이네 ㅆㅂ", "총알 소나기 맞는 중 ㅈㄴ", "맞기만 하고 있네 뭐임", "엄폐물 어디 있냐 찾아봐",
		"깨작깨작 맞으니까 더 빡쳐", "긁힌 게 존나 많네", "계속 쏘는 놈 있다 ㅅㅂ!", "얇게 계속 맞는다 조심해", "잔 데미지 존나 쌓이네", "쫄리네 자꾸 맞으니까", "가만있지 말고 뛰면서 피해!", "자잘한 데미지가 개쌓이는데", "위치 노출된 듯 아 씨",
		"피 슬금슬금 빠지는 중", "엄폐 안 하면 계속 맞는다고", "따끔따끔 또 맞네 미치겠다", "연속으로 긁혔다 개빡쳐", "잔피해 누적이다 정신 차려", "누가 쏘는지 찾아라 좀", "쪼금씩 맞는 게 더 열받네", "이러다 곧 골로 간다", "계속 긁혀서 신경 존나 쓰여",
		"숨어 숨어 엄폐 찾아서!", "잔 데미지 계속 박히네", "피 줄줄 새는 중이다 ㅅㅂ", "자꾸 맞아서 존나 불편하다", "두들겨 맞는 중이라고!", "숨어서 피부터 채워 ㅅㅂ", "자잘하게 맞는 거 좀 막아 봐", "누가 날 노리냐 지금?",
		"따가운 거 계속 들어온다", "잔피해 쌓인 거 실화냐", "엄폐 없으면 뒤진다 진짜", "맞다 보니 체력 개줄었네", "슬쩍슬쩍 긁히는 중", "자리 옮겨 피하라고!", "계속 맞는 건 좀 너무하잖아", "소소하게 맞는 중 어이없네", "엄폐하고 회복부터 해 씨발",
		"잔피해 많다 조심해라", "계속 쏴대는 적 있다 ㅅㅂ!", "연속 피격 떴다 조심해!", "위치 다 들켰다 씨팔", "작은 데미지만 계속 박힌다", "따끔한 게 연속으로 오네", "조금씩 맞으니 짜증 ㅈㄴ 나", "엄폐 잡고 존나 튀자!", "계속 긁히니까 불안하다고",
		"잔피해 쌓이면 존나 무섭다", "맞고 있으니까 움직여 좀", "피가 쪼금씩 빠진다 ㅅㅂ", "계속 맞으니 집중 안 되네 ㅅㅂ", "엄폐 ㄹㅇ 중요하다고!",
	} },
	healed = { level = 2, priority = 1, cooldown = 20, lines = {
		"피 다 찼다 씨발 살았다", "회복 완료 ㅋ 이제 좀 살겠네", "다시 풀피 ㅎㅎ 존나 다행이다", "체력 충전 끝! 이제 죽이러 간다", "체력 회복!! 씨발 살았다", "풀피 됐다 ㅋㅋ 다시 달린다", "다시 쌩쌩함 ㄹㅇ 개좋다", "회복 완료 ㅅㅂ 살았다", "피 가득!! 존나 든든하다", "건강해졌다 씨발 살겠다", "이제 다시 싸울 수 있다 ㅋㅋ", "체력 만땅 ㄹㅇ 가보자", "부활한 기분이다 ㅋㅋ 미쳤다",
		"이제 괜찮네 씨발 다행이다", "피 다 찼다 ㅎㅎ 존나 살았다", "체력 회복 완료 ㅋ 이제 개싸운다", "풀피 됐다 ~ 씨발 좋다", "다시 쌩쌩하다 ㅋㅋ 덤벼라", "피 가득 찼다 씨발 존나 든든", "건강해졌다 ㅎㅎ 이제 쫄지 마", "체력 만땅이다 ㅋ 개꿀", "부활한 기분이다 씨발 살았다", "이제 괜찮으니 걱정 말아라 ㅋㅋ", "피 다 찼다 씨발 다행이다 ㄹㅇ",
		"회복 성공 ㅋㅋ 존나 잘했다", "체력 풀로 올라왔다 ㅅㅂ 살았다", "힘 넘친다 ㅎㅎ 존나 개쩐다", "회복했으니 가자 씨발 밀어붙여", "풀피 축하한다 ㅋㅋ 잘했다", "체력 완전 회복!! 미쳤다 ㅋㅋ", "이제 맘 놓고 싸운다 씨발 좋다", "피 가득이라 안심됨 ㅋㅋ", "회복 덕분에 살았다 ㅅㅂ 다행",
		"체력 충전 완료 ㄹㅇ 개좋다", "다시 건강해졌다 씨발 쌩쌩", "풀피라 존나 든든하다 ㅋㅋ", "회복 타이밍 개좋았다 ㅋㅋ", "체력 쭉쭉 올라온다 씨발 좋다", "이제 한 방 맞아도 버틴다 ㅋ", "풀피 복귀 ㅋㅋ 개환영이다", "회복 끝 다시 간다 씨발 간다", "체력 가득 찼다 ㅋㅋ 이제 간다", "피 회복 성공이다 씨발 굿",
		"이제 쌩쌩하게 싸워보자 ㅋㅋ", "체력 완전 충전 씨발 완료", "회복하니까 존나 기분 좋네", "풀피로 돌아왔다 ㅋㅋ 다시 시작", "건강 되찾았다 ㅎㅎ 씨발 살았다", "체력 회복 축하함 ㅋㅋ 잘했다", "이제 자신 있게 간다 씨발", "피 꽉 찼다 ㄹㅇ 살았다", "회복 완료 확인 ㅋ 이제 됐냐", "다시 살아났다 씨발 부활함",
		"체력 풀 충전 ㅋㅋ 존나 좋다", "회복 덕분에 편하다 씨발 살았다", "피 다 차서 존나 든든하다", "회복 성공 기분 개좋다 ㅋㅋ", "체력 만땅 씨발 가자 가자", "풀피 됐으니 쓸어버리러 간다", "회복했다 씨발 다행이다 ㄹㅇ", "건강 완벽 복구 ㅋㅋ 개쩐다", "체력 충분하다 씨발 가보자", "회복 완료 보고 ㅎㅎ 씨발 간다",
		"피 가득이라 안심 ㅋㅋ 존나 좋다", "힘이 솟는다!! 씨발 미쳤다", "풀피 축하 ㅋㅋ 잘했다 씨발", "체력 복구 성공 ㅅㅂ 굿", "회복 덕에 살았다 씨발 고맙다", "건강 되찾았다 ㅋㅋ 존나 좋다", "체력 회복 완료 확인 ㅋㅋ 됐지?",
	} },
	lowHpStill = { level = 2, priority = 2, cooldown = 30, lines = {
		"아직 피 없다고 씨발 조심해", "체력 바닥인데 나대지 마 ㅅㅂ", "피 좀 채우고 가라 제발", "한 대만 맞아도 골로 간다", "아직 위험하다고!", "피 채우는 게 먼저지 ㅋㅋ", "깝치지 마 ㅅㅂ", "조심히 움직여 좀", "아직 체력 낮다 알지?", "숨어서 회복하자 씨발",
		"싸우지 말고 버텨 ㅇㅇ", "한 대도 맞으면 안 돼 ㅅㅂ", "살금살금 가라 ㅋㅋ", "상태 존나 위험하다", "체력 봐 체력!", "체력 아직 위험하다니까 ㅅㅂ", "피부터 채워 씨발", "무리하지 마라냥 ㅅㅂ", "아직 체력 낮아 하...", "한 대면 끝이니까 진짜 조심해",
		"위험한 상태 계속이다 ㅅㅂ", "체력 확인 한번 해 봐 ㅋㅋ", "피 조금만 더 채우자 ㅇㅋ", "지금은 몸 좀 사려 씨발", "회복 아직 덜 됐다고", "조심조심 가자 제발", "체력 낮을 땐 숨는 게 답이다", "회복부터 하고 나가라 ㅅㅂ", "아직 위험 구간이다 ㅇㅇ",
		"무리하면 바로 뒤진다 ㅋㅋ", "엄폐하고 쉬자 ㅅㅂ", "지금 싸우면 뒤진다 진짜", "체력 부족 상태 계속이다 하...", "조금만 더 처박혀 있자 ㅅㅂ", "아 피 아직 부족하네", "아직은 공격하지 마 씨발", "그 체력으로 가면 개위험하다", "회복될 때까지 조심해 ㅋㅋ",
		"체력 어떻게 됐냐? 확인해 봐", "아직 조심할 때다 ㅅㅂ", "피도 없이 싸우면 안 된다", "여기서 더 맞으면 끝이다 씨발", "회복 기다리는 중이다 ㅇㅇ", "지금은 방어가 우선이다 ㅅㅂ!", "아직 체력 낮다고 아 진짜", "조심해서 움직이자 ㅋㅋ",
		"체력 올라올 때까지 숨자 씨발", "무리 금지 구역이다 ㅋㅋ", "체력 낮을 땐 피하는 게 최고다 ㄹㅇ", "아직 불안하다 존나", "좀 더 쉬면서 회복해 ㅅㅂ", "위험 구간 유지 중 ㅋㅋ", "체력 회복이 최우선이다 씨발!", "싸움은 나중에 하자 ㅅㅂ",
		"체력 낮으니 신중하게 가자", "아직 피가 존나 모자라", "회복부터 하고 가자 ㅇㅋ", "지금은 살아남는 게 목표다", "낮은 체력 주의 중 ㅋㅋ", "체력이 조금 더 필요하다 씨발", "숨어서 기다리자 ㅇㅇ", "지금 나가면 뒤진다 ㅅㅂ",
		"체력 낮을 땐 조용히 처박혀 있어", "아직 위험하니까 조심해 씨발!", "피 회복부터 해라 ㅋㅋ", "무리는 금물이다 ㅅㅂ", "체력 낮은 상태 계속 중이다 하...", "지금은 엄폐가 최선이다 ㅋㅋ", "회복 다 되면 나가자 ㅇㅋ", "아직 조심 모드 유지 ㅅㅂ",
	} },
	untouched = { level = 3, priority = 1, cooldown = 120, lines = {
		"한참 동안 한 대도 안 맞았다 미친", "아무도 못 맞히네 ㅋㅋ 개못하네", "유령 모드 ㅋㅋ", "안티에임 일 존나 잘하네 ㅋㅋ", "다들 에임 어디다 두고 왔냐 ㅋㅋ", "무적인 줄 ㅋㅋ", "한참째 안 맞는 중 ㅅㅂ 신기", "투명 고양이 모드 ㅋㅋ", "피격 0 유지 중 ㅇㅈ?",
		"상대 에임 ㅈㄴ 구리네", "맞을 생각 1도 없지? ㅋㅋ", "회피 장인 ㅇㅈ", "유령처럼 슥슥 ㅋㅋ", "완벽한 회피 ㅅㅂ 미쳤다", "총알이 알아서 피해 가네", "유령 모드 발동 중이다 ㅋㅋ", "투명 고양이냐고 ㅋㅋ", "맞을 생각이 없나 보네 ㅅㅂ", "피격 0 유지 중이다 개쩐다",
		"상대 에임 존나 구린가 봐 ㅋㅋ", "회피 장인 등극 ㅅㅂ", "회피 실력 완벽하다 미친", "총알이 다 피해 가네 ㅋㅋㅋ", "이렇게 오래 안 맞는 건 ㄹㅇ 대단", "무피 흐름 이어 가는 중이다 ㅅㅂ", "상처 하나 없이 시간만 존나 간다", "안 맞는 게 제일 좋다 ㅇㅈ",
		"회피 기술 최고네 ㅅㅂ", "한 대도 안 맞고 버티는 중 ㅋㅋ", "맞을 것 같은데 안 맞네 ㅋㅋㅋ 뭐임", "오래 무사히 버티는 중이다", "안티에임 덕분이겠지? ㅋㅋ", "피해 없이 존나 잘 버티고 있다", "안 맞는 나 칭찬해 냥", "상처 없이 흘러가는 시간 ㅋㅋ",
		"이대로 쭉 간다 씨발!", "오래 무피 기록 중이다 ㅋㅋ", "아무도 날 못 건드리네 ㅅㅂ", "회피가 완벽하다 ㅋㅋ", "맞은 적 없는 시간 ㅈㄴ 길다", "무피 흐름 지켜 ㅅㅂ!", "안 맞는 게 실력이다 ㄹㅇ", "상대가 하나도 못 맞추네 ㅋㅋ",
		"피격 없는 시간 ㅊㅋ 한다", "안 맞고 버티는 중 ㅋㅋ", "총알 다 피하는 중이다 미친", "무사히 살아 있는 중 ㅅㅂ", "오래 안 맞는 중 ㅋㅋㅋ", "회피 실력 굿이네 ㅇㅈ", "이 흐름 끊기기만 해 봐 씨발", "무피 시간 계속 늘어나는 중 ㅋㅋ",
		"안 맞는 게 최고다 ㅅㅂ", "상처 하나 없이 멀쩡하다 ㅋㅋ", "오래 버티는 게 능력임 ㅇㅈ", "맞을 기회도 안 주네 ㅋㅋ", "피격 기록 없이 잘 간다 ㅅㅂ", "상대 공격 다 빗나가네 ㅋㅋ", "회피 기록 갱신 중이다", "안 맞고 살아남기 성공 ㅋㅋ",
		"오래 무피 ㅊㅋ 씨발!", "안 맞으니까 기분 ㅈㄴ 좋다", "회피 연속 성공 중 ㅅㅂ", "상처 하나 없다 ㅋㅋ", "맞을 뻔한 거 다 피했다 ㅋㅋ", "무피 유지 신기하네 ㄹㅇ", "총알이 나를 피해 가네 ㅋㅋ", "안 맞는 시간이 길다 ㅅㅂ", "회피 천재 등극 ㅋㅋ",
		"흠 없는 시간 계속 가는 중", "무피 행진 ㅊㅋ ㅋㅋ",
	} },
	firstHit = { level = 2, priority = 1, lines = {
		"첫 명중 씨발 드디어!", "맞았다 ㅋㅋ 씨발 됐다", "감 잡았다 ㅅㅂ 이제 간다", "첫 발 들어갔네 씨발", "첫 탄 명중! 존나 시원하다", "맞혔다 ㅋㅋ 드디어", "몸 풀렸다 씨발 이제 좀 된다", "감 왔다 ㅋㅋ 개좋아", "첫 데미지! 씨발 됐다", "좋은 시작 ㄹㅇ 존나 좋아", "맞는다 맞아 씨발 맞는다", "에임 살아있다 ㅋㅋ 씨발", "첫 히트! 개시원하다", "들어갔어! 씨발 됐다",
		"명중 시작 ㅅㅂ 이제 쏜다", "첫 명중이다 ㅋㅋ 존나 쾌감", "맞혔다 좋아 씨발 쩐다", "몸 풀렸다 ㅋㅋ 이제 시작", "첫 데미지 성공 씨발 좋다", "좋은 시작이네 ㄹㅇ 개좋다", "맞는다 맞아! 씨발 됐다", "에임 살아 있네 ㅋㅋ 개쩐다", "첫 히트 씨발 좋다!", "들어갔다 들어갔어! 존나 좋다", "명중 시작이다 씨발 간다", "첫 발 적중! 개시원하다",
		"감이 돌아왔다 ㅋㅋ 씨발", "맞혔으니 이제 시작이다 ㅅㅂ", "첫 명중 기록 추가 ㅋㅋ", "좋았어 이 기세로 씨발!", "첫 탄이 맞았다 ㄹㅇ 시원하다", "명중 소리 기분 개좋다", "드디어 맞혔다 씨발 ㅋㅋ", "첫 명중 축하해 ㅋㅋ 씨발", "에임 몸 풀렸어 ㅅㅂ 쩐다", "들어갔다! 존나 짜릿하다",
		"첫 데미지 축하 파티 ㅋㅋ", "맞았다 확실히! 씨발 좋아", "명중 시작 씨발 축하한다", "첫 히트 성공 ㅎㅎ 개쩐다", "에임 감 잡았다 씨발", "첫 명중 나왔다! 존나 좋다", "맞혀서 다행이다 씨발", "이제 맞기 시작한다 ㅋㅋ", "첫 탄 명중 확인 ㄹㅇ", "좋은 출발 명중! 씨발 쩐다",
		"첫 맞힘 축하해 ㅋㅋ 존나", "감 찾았다 씨발 간다!", "첫 명중 기록! 개쩐다", "들어갔네 완벽해 씨발", "첫 히트 실화냐 ㅋㅋ", "맞혔다 이제 쭉 가자 씨발", "첫 발 명중 축하! 개좋다", "에임 살아났다! 씨발 드디어", "첫 데미지 실감 난다 ㅋㅋ", "명중 시작 축하 ㅅㅂ 좋다",
		"맞힌 첫 발 기념 ㅋㅋ 씨발", "첫 명중 짜릿하다 존나", "감 올라왔다 씨발 좋아", "첫 히트 확인 완료 ㅋㅋ", "맞았다 기분 좋다! 씨발", "첫 명중 축하 파티 ㅋㅋ 씨발", "에임 흐름 탔다 ㄹㅇ 쩐다", "첫 발 맞았네 ㅎㅎ 씨발", "명중 축하 한 번 더 ㅋㅋ", "첫 탄 적중 성공 씨발",
		"맞혔네 ㅋㅋ 고맙다 씨발", "첫 명중 대성공! 개쩐다", "에임 몸 풀리는 중 ㅅㅂ", "첫 히트 기록 추가 씨발 좋다",
	} },
	hitStreak = { level = 2, priority = 1, cooldown = 25, lines = {
		"연속 명중 ㅋㅋ 미친 ㄷㄷ", "오늘 감 개미쳤다", "다 맞네 ㅋㅋ 존나 쉽네", "손에 불붙었다 ㅅㅂ!", "계속 맞는다 씨발!", "ㅋㅋ 명중 행진 시작이다", "다 들어가네 ㅅㅂ", "에임 개좋다 ㅋㅋ", "ㅅㅂ 연속 히트!", "감 미쳤다 ㄹㅇ", "빗나가는 게 하나도 없네", "명중률 존나 높네", "손 풀렸네 ㅅㅂ",
		"쏘는 족족 꽂힌다", "명중 콤보 이어간다 ㅋㅋ!", "손이 불타고 있다 씨발!", "명중 행진 계속 간다", "와 쏘는 족족 맞네 미쳤다", "명중률 미친 수준 찍는 중", "드디어 손 풀렸네 냥", "연타로 꽂는 중 ㅋㅋ!", "맞히는 감각 지린다", "오 연속 히트 ㅋㅋ 축하한다!",
		"끊이질 않네 명중 ㅅㅂ", "에임 흐름 탔다 ㄹㅇ", "이대로 쭉 꽂아버리자", "다 들어가는 중이다 ㅋㅋ!", "콤보 가동 ㅅㅂ!", "야 연속으로 맞혔다 ㅋㅋ", "오늘 손이 살아있다 ㄹㅇ", "쏘면 맞는 날이네 신기하다", "연속 명중 존나 짜릿하다",
		"계속 맞힌 게 이어진다 ㅋㅋ", "명중 흐름 좋다 ㅋㅋ", "ㅊㅊ 연타 명중 ㅇㅈ!", "쏠 때마다 들어가네 ㅅㅂ", "명중 행진 개대박", "에임 컨디션 미쳤다!", "맞히는 거 존나 재밌다", "명중 콤보 파티다 ㅋㅋ", "오늘 감 개쩐다 ㅋㅋ",
		"맞은 것만 세고 싶다 ㅋㅋ", "계속 맞아서 존나 신난다", "연속 히트 굿 ㅋㅋ", "쭉쭉 꽂힌다 명중이", "에임 흐름 완벽하네 ㅅㅂ", "맞히는 손맛 존나 좋다", "명중 연타 계속 간다!", "쏘면 그냥 들어가네 ㅋㅋ", "연속 명중 기록 추가 ㅅㅂ", "맞히기 장인 등극 ㅋㅋ",
		"ㅊㅊ 히트 행진 ㅋㅋ", "콤보 안 끊긴다 ㄹㅇ", "빗나갈 틈이 없네 ㅋㅋ", "연속 히트 개짜릿하다", "명중률 올라간다 ㅅㅂ!", "맞는 소리 계속 들리네 ㅋㅋ", "미친 연속 명중 ㄷㄷ", "에임 살아있는 날이다 ㅇㅈ", "맞히고 또 맞히고 ㅋㅋ!",
		"흐름 탔다 ㅋㅋㅋ 명중", "연속 히트 ㅊㅊ 인정", "쏘는 대로 맞네 씨발", "행진 이어 가자 ㅅㅂ 명중", "맞힘 콤보 개쩐다", "연속 히트 감격이다 ㅋㅋ", "손이 왜 이렇게 잘 맞냐 ㅋㅋ", "명중 연속 기록 갱신했다", "히트 행진 계속 가자 ㅅㅂ!",
		"맞는 게 당연해진 느낌임",
	} },
	hitStreak10 = { level = 1, priority = 2, cooldown = 40, lines = {
		"10연속 명중 미쳤다 ㄷㄷㄷ", "하나도 안 빗나가네 씨발", "에임 신 내렸다 ㅈㄴ", "10발 다 맞았다 개쩐다", "10연속 ㅅㅂ!!", "명중 머신이네 ㅋㅋ", "에임 핵인 줄 ㅋㅋ 사기네", "빗나감 1도 없네 ㅋㅋ", "사격 완벽하네 씨발", "10발 연속 히트 ㅈㄴ 쩐다", "신기록 각이다 ㅅㅂ",
		"정확도 100 미쳤다", "이게 사람 에임이냐 ㅋㅋ", "10연속 명중 개대박", "탄창 전부 꽂혔네 ㅋㅋ", "에임 신 강림이다 미친", "명중 머신 등극했네 ㅋㅋ", "빗나감이 하나도 없네 ㅅㅂ", "완벽한 사격이다 ㄹㅇ", "정확도 100 찍었다 소름 ㅋㅋ", "이게 사람 에임 맞냐 ㅅㅂ",
		"탄창 다 맞았네 ㅋㅋ 미친", "10연속 ㅊㅋ 개쩔었다 ㅋㅋ", "10발 연속 적중 실화냐 미친", "정확도 존나 미쳤다 ㄹㅇ", "에임 레전드 떴다 ㅅㅂ", "10연속 명중 기록 찍었네", "이 손맛 ㅈㄴ 좋다 씨발", "명중 10회 돌파했다 ㅋㅋ", "빗나갈 틈이 없었네 ㄷㄷ",
		"사격 그냥 완벽 그 자체네", "10연속 히트 파티다 ㅋㅋ", "에임 마스터 ㅇㅈ 한다", "10발 다 꽂았다 ㅋㅋ", "명중 연타 레전드 씨발", "정확도 소름 돋네 ㅈㄴ", "10연속 명중 짜릿하다 ㅅㅂ", "탄 낭비 하나 없네 ㅋㅋ", "10연속 히트 신기록 찢었다",
		"에임 컨디션 최고다 ㅅㅂ", "빗나감 제로 ㅋㅋ 오진다", "10발 연속 명중 ㅊㅋ ㅋㅋ", "명중률 미쳤다 ㄷㄷ 씨발", "사격 실력 인정한다 씨발", "10연속 맞히기 성공 ㅋㅋ", "에임 완전 살아났네 ㅅㅂ", "10발 모두 적중 오지네", "정확도 극대화 ㅋㅋ 미친",
		"명중 머신 축하한다 ㅋㅋ", "10연속 명중 대단하다 씨발", "탄이 다 맞는 기분 ㅈㄴ 좋네", "사격 흐름 완벽하다 ㅋㅋ", "10연속 명중 기록이다 ㅅㅂ", "에임 레전드 ㅊㅋ ㅋㅋ", "빗나감 없는 10발 괴물이네", "명중 연속 기록 갱신 ㅅㅂ", "10연속 손맛 지리네 ㅋㅋ",
		"정확도 완벽 달성 ㅋㅋ", "10발 다 맞힌 실력 ㅇㅈ", "명중 파티 열자 ㅅㅂ ㅋㅋ", "10연속 히트 ㅊㅋ 캐리했네", "사격 천재 등장했네 ㅋㅋ", "10연속 명중 소름 돋네 ㅅㅂ", "빗나가는 게 없네 ㄷㄷ", "에임 신의 경지네 미친", "10연속 적중 ㅊㅋ 한다",
		"명중률 100 가깝다 ㅅㅂ", "10발 명중 완벽하네 ㄹㅇ", "사격 보다가 감탄한다 씨발", "10연속 히트 실화냐 ㅋㅋ",
	} },
	missStreak = { level = 2, priority = 1, cooldown = 25, lines = {
		"왜 안 맞냐 씨발 뭐임", "잠깐 멈칫했다 ㅅㅂ", "에이 씨발 또 빗나감", "상대 존나 잘 피하네 ㅋㅋ", "안 맞네 ㅋ 미친", "상대 존나 날뛰네 씨발", "조금만 더!! 씨발 한 발만", "감 다시 잡자 씨발 집중", "빗나갔다 ㅠ 개빡친다", "침착하게 쏘자 씨발 손 떨지 말고", "다음 발은 맞는다 씨발 두고 봐",
		"아깝다 씨발 존나 아깝다", "좀 더 집중해라 씨발", "곧 맞겠지 ㅋ 기다려라", "숨 고르고 다시 쏜다 씨발", "또 안 맞네 ㅠ 미친", "조금만 더 맞혀보자 씨발", "감 다시 잡자 ㅅㅂ 정신 차려", "다음 발은 존나 맞출 거다", "아깝다 씨발 옆으로 샜다", "좀 더 집중하자 ㅅㅂ",
		"곧 맞는다 기다려 씨발", "연속으로 빗나가네 씨발 ㅠ", "조준 다시 잡자 씨발", "빗나감 존나 늘었다 ㅠ", "숨 좀 고르고 쏘자 씨발", "상대 움직임 좀 읽어보자 ㅋ", "지금 감 존나 없다 ㅠ", "잠깐 쉬고 다시 쏘자 씨발", "탄이 자꾸 옆으로 샌다 씨발",
		"빗나가는 날도 있지 뭐 ㅋ 씨발", "조준점이나 다시 확인해라 씨발", "아깝게 계속 빗나가 씨발 ㅠ", "차근차근 조준하자 씨발 ㅋ", "맞을 때까지 쏜다 씨발 가자", "연속으로 놓치니까 존나 빡친다", "상대가 존나 잘 피하는 듯 ㅋ", "지금 거리 조절 좀 해라 씨발",
		"빗나감 행진 중이다 씨발 ㅠ", "천천히 좀 쏴보자 씨발", "감 잃었나 봐 씨발 ㅠ", "이번엔 머리 노린다 씨발", "빗나가도 다음 있다 ㅋ 쫄지 마", "조준 흔들림 조심해라 씨발", "맞을 때까지 집중해라 씨발!", "오늘 존나 안 맞네 ㅠ", "마음 좀 가라앉히고 쏘자 씨발",
		"움직이는 적 존나 어렵다 씨발", "빗나간 탄 아깝다 씨발 ㅠ", "지금 조준부터 점검해라 씨발", "연속 빗나감 개위험하다 씨발", "한 발씩 차분하게 쏘자 씨발", "빗나가는 이유부터 찾자 씨발", "조금만 참고 맞혀보자 씨발", "흔들린 조준 잡자 씨발 집중",
		"연속 미스 개아깝다 ㅠ", "여기서 감 잡으면 된다 씨발", "맞히는 연습 좀 해야겠다 씨발", "천천히 확실하게 쏘자 씨발", "빗나감 쌓이고 있다 씨발", "다음엔 꼭 맞힌다 씨발 두고 봐", "움직임 예측해서 쏘자 씨발", "연속으로 놓쳐서 존나 속 터진다",
		"조준이 자꾸 어긋난다 씨발", "지금은 기다렸다가 쏘자 씨발", "맞힐 기회 또 오겠지 씨발", "빗나감 탈출 가즈아 씨발 ㅋ", "차분히 조준 맞추자 씨발", "미스 연속 끊어보자 씨발", "지금 쏘는 타이밍 재자 씨발",
	} },
	missStreak20 = { level = 2, priority = 1, cooldown = 60, lines = {
		"계속 빗나가네 ㅅㅂ 상대 이상한데", "오늘 상대 존나 잘 피하네", "하 각도 좀 바꿔 봐", "안 맞는 날도 있는 거지 씨발", "오늘 상대 회피왕이네 ㅋㅋ", "계속 빗나간다 아 ㅅㅂ", "거리 좀 좁혀 봐 인마", "설정 좀 점검해 봐 ㅅㅂ", "각도 바꾸라고 ㅋㅋ",
		"무적이냐 뭐냐", "총알이 다 피해 간다 미친", "잠깐 쉬어 가자 빡친다", "이상하네 ㅅㅂ", "기록 보내면 내가 봐 준다", "다음 판은 괜찮겠지 시발", "오늘 상대 회피 개잘하네", "진짜 계속 빗나가네 어이없다", "거리 좁혀서 쏴 봐 좀",
		"설정 한 번 점검하자 ㅆㅂ", "각도 바꿔 보라니까 냥", "무적이냐? 존나 안 맞네", "탄이 다 피해 가는 기분 ㅈㄴ 더럽네", "이상하네 왜 안 맞냐 씨발", "20연속 빗나감 실화냐", "에임 어디 두고 왔냐", "지금은 쏘지 말고 쉬어 ㅅㅂ",
		"빗나가는 패턴 좀 찾아봐", "상대 존나 잘 피하네", "이번 판 감이 존나 안 온다", "조준 설정이 이상한가 시발", "쏠수록 더 빗나가네 ㅋㅋ", "잠깐 멈추고 상황 보라고", "오늘은 맞히기 존나 힘든 날", "무리하지 말고 쉬어 가 ㅈㄴ 빡세네",
		"이 빗나감 행진 좀 끝내자 ㅅㅂ", "마우스 감도 확인해 봐", "계속 옆으로 빗나가네 ㅆㅂ", "차분히 다시 조준해 봐", "거리 감이 완전 틀린 듯", "빗나감 신기록 세우는 중 ㅋㅋ", "이 상태론 힘들어 아 씨", "천천히 다시 감 잡아 인마",
		"맞는 날이 곧 오겠지", "쉬었다 오면 달라질 거다", "빗나감 연타 그만 좀 해", "조준 방식 바꿔 봐 ㅅㅂ", "상대가 이상하게 피하네 ㅋㅋ", "오늘 판은 망했다 씨발", "연속 빗나감 원인 좀 찾아봐", "조준점 바꿔서 쏴 봐",
		"잠깐 숨 고르고 다시 가", "빗나가서 개빡친다", "다음 판엔 더 잘하겠지", "이 흐름 좀 바꾸자 ㅅㅂ", "빗나감 연속 탈출한다", "설정 안 맞는지 확인해", "안 맞는 날도 있는 거지 뭐",
		"빗나가도 포기하지 마 ㅅㅂ", "쉬고 다시 시작하자", "조준 흔들리는 거 잡아 봐", "빗나감이 이렇게 길 줄이야 ㅋㅋ", "오늘 감 뒤졌나 보다", "차분하게 한 발씩 쏴 제발", "빗나감 탈출 계획 짜자",
		"상대 움직임 분석해 봐", "잠깐 쉬고 다시 맞혀", "빗나감 행진 끝내러 가자", "조준 연습 좀 해야겠다 ㅋㅋ", "이번 판은 연습 판으로 치자", "맞히는 감 다시 찾자",
	} },
	bigDamage = { level = 2, priority = 1, cooldown = 10, lines = {
		"%s 데미지 씨발 아프겠다", "크게 박았다 ㅋㅋ 존나 세다", "한 방 세네 뭐임 ㄷㄷ", "묵직하게 꽂혔다 개시원하네", "%s 들어갔다 ㅅㅂ 쩐다!", "%s 데미지 아프겠다 ㅋㅋ", "강하게 꽂혔다 존나 시원하다", "%s 한 방 씨발 크다!", "묵직한 한 방 개쩐다", "%s 데미지 ㅈㄴ 굿",
		"큰 거 한 방 ㅋㅋ 미쳤다", "%s 대박 ㄹㅇ 씨발", "제대로 맞췄다 ㅋㅋ", "%s나 깎았다 존나 좋다", "강력한 히트 뭐임 존나 세네", "강하게 꽂혔어 씨발!", "묵직한 한 방 존나 개쩐다", "큰 한 방 맞혔다 ㅋㅋㅋ", "%s 대박 데미지 미쳤다", "제대로 맞혔다 개쩐다!", "%s나 깎았어 ㄷㄷ 씨발",
		"강력한 히트 성공 존나 시원해", "%s 데미지 엄청나네", "큰 피해 입혔다 ㅋㅋ 개좋아", "묵직하게 들어갔네 씨발 굿", "%s 깎였다 짜릿하다 ㅋㅋ", "큰 데미지 축하한다 존나 잘했다", "%s 피해 크다 ㅋㅋㅋ 씨발", "한 방이 세게 들어갔다 ㅋㅋ", "%s 데미지 기록 추가 ㅈㄴ 세다",
		"큰 피해 성공! 어이없게 세네", "%s 들어갔어 시원하다 ㅅㅂ", "강하게 꽂힌 한 방 씨발 쩐다", "%s 데미지 최고다 ㄹㅇ", "큰 피해 입혀서 기분 개좋다", "%s 깎아 버렸네 씨발 쩐다", "묵직한 데미지 ㅋㅋ 존나 세다", "%s 강타 성공! 씨발 개쩐다", "큰 한 방 맞혔다 ㅋㅋ 미쳤다",
		"%s 데미지 대단해 씨발", "크게 들어간 한 방! 존나 시원하다", "%s 피해 대박이다 ㅋㅋ", "강력한 데미지 성공 ㄹㅇ 쩐다", "%s 크게 깎였다! 씨발 좋다", "큰 데미지 짜릿하다 ㅋㅋ", "%s 한 방에 훅! 씨발", "묵직한 피해 축하해 ㅋㅋ", "%s 데미지 굿 ㅎㅎ 씨발 세다",
		"큰 히트 기록! 개쩐다", "%s 데미지 완벽 ㅅㅂ", "강하게 맞힌 한 발! 쩐다 ㅋㅋ", "%s 피해 실감 난다 ㅋㅋ", "큰 한 방 축하 ㅋㅋ 존나 세다", "%s 깎여서 상대 휘청 씨발", "데미지 큰 한 방이다 ㄹㅇ", "%s 피해 최고! 개쩐다", "강력한 히트 축하 씨발 굿",
		"%s 데미지 기록 갱신 ㅈㄴ 세다", "큰 피해 쏟아졌다 ㅋㅋ 씨발", "%s 한 방 제대로 들어감 ㅅㅂ", "묵직한 데미지 최고 ㄹㅇ", "큰 피해 축하해! 씨발 쩐다", "%s 강타 대성공 ㅋㅋ", "데미지 시원하게 들어갔다 존나", "%s 깎는 맛 좋다 씨발", "큰 한 방 실감 난다 ㅋㅋ",
		"%s 데미지 축하 ㅈㄴ 세다", "강한 히트 짜릿해 씨발", "%s 피해 크게 줬다 ㅋㅋ", "묵직한 한 방 대박 ㄹㅇ 쩐다",
	} },
	longShot = { level = 2, priority = 1, cooldown = 20, lines = {
		"%s 거리 명중 ㅅㅂ ㄷㄷ", "그 먼 데를 맞히냐 미친 ㅋㅋ", "장거리 저격 성공 ㅈㄴ 쉽네", "멀어도 다 꽂힌다 ㅋㅋㅋ", "%s 거리 명중 씨발!", "멀리서도 맞네 ㅋㅋ 개쩐다", "%s 떨어진 데 히트 ㅋㅋ", "원거리 명중 ㅅㅂ", "장거리 저격 박았다!", "%s 거리 ㄷㄷ 미쳤네",
		"멀어도 소용없다 뒤져라", "끝에서 끝으로 맞혔다 ㅋㅋ", "%s 저격 성공 ㅅㅂ 개좋다", "거리 따위 무시한다 ㅋㅋ", "원거리 장인 ㅇㅈ", "멀리서도 맞혔다 씨발 쩐다", "%s 떨어진 놈 히트 ㅋㅋㅋ", "원거리 명중 성공 개꿀", "장거리 저격 대박 미친!", "멀다고 안 맞을 줄 알았냐", "저 끝에서 맞혔다 ㅋㅋㅋ",
		"%s 저격 성공 ㅈㄴ 짜릿!", "거리 상관없이 다 맞힌다 ㅅㅂ", "원거리 장인 등장 개쩐다", "%s 거리 명중 ㅊㅋ 씨발", "먼 거리 히트 성공 ㅋㅋ", "장거리 명중 존나 짜릿하다", "%s 떨어진 적 맞혔다 ㅅㅂ", "원거리 저격 대성공 ㅋㅋㅋ", "%s 거리 실화냐 이게 맞냐",
		"멀리서 맞히는 실력 ㅇㅈ", "장거리 명중 축하한다 ㅋㅋ", "%s 거리 히트 기록 ㅅㅂ!", "먼 적 명중 성공 꼴 좋다", "원거리에서 맞혔네 ㅋㅋ 쉽다", "%s 거리 저격 ㅊㅋ ㅈㄴ 쩐다", "장거리 맞히는 맛 개좋다", "먼 거리 명중 짜릿하다 ㅅㅂ", "%s 떨어진 곳 명중 ㅋㅋ!",
		"원거리 실력 존나 대단하네", "장거리 저격 명장면 찍었다 ㅅㅂ", "%s 거리 히트 ㅊㅋ ㅋㅋ", "멀리서 쏜 게 맞았네 어이없네", "장거리 명중 기록 추가 ㅇㅋ", "%s 거리 명중 소름 돋네 ㅅㅂ", "원거리 명중 파티다 ㅋㅋㅋ", "먼 데서 한 방에 보냈다!", "%s 저격 ㄹㅇ 대박이다",
		"장거리 히트 성공이다 ㅋㅋ", "%s 거리 명중 이게 실력이지", "원거리 명중 이 맛이다 ㅅㅂ", "먼 거리 저격 완벽했다", "%s 떨어진 적 제압 완료 ㅅㅂ", "장거리 명중 ㅊㅋ 씨발!", "원거리에서도 개정확하네", "%s 거리 히트 기록 갱신 ㅈㄴ 쩐다",
		"먼 곳 명중 성공 ㅋㅋ", "장거리 저격 굿 ㅇㅈ", "%s 거리 맞혔다 개짜릿!", "원거리 실력 인정이다 ㅅㅂ", "먼 거리 명중 ㅊㅋㅊㅋ", "%s 떨어진 곳도 히트다 ㅋㅋ!", "장거리 명중 대성공 씨발 ㅋㅋ", "원거리 저격 기록 추가 ㄱㄱ", "%s 거리 명중 완벽 ㅅㅂ",
		"먼 거리 히트 ㅊㅋ 쩐다", "장거리에서 한 방에 끝냈다", "%s 저격 성공 ㅊㅋ 개쩐다!", "원거리 명중 명장면이다 미친", "%s 거리에서 맞혔다 소름 ㅅㅂ",
	} },
	wallHit = { level = 3, priority = 1, cooldown = 30, lines = {
		"벽 너머로 명중이다 ㅋㅋ", "숨어도 맞네 씨발", "벽은 장식이냐 ㅋㅋ", "벽 뒤에서도 아프지? 씨발", "벽 뚫었다 ㄷㄷ", "벽 뒤 명중 ㅇㅈ", "벽이 안 막네 씨발", "숨어도 맞잖아 ㅋㅋ", "벽 너머 히트 존나 쩐다", "벽 투과 성공 씨발", "벽 뒤에서 아야 ㅋㅋ", "벽 무용지물이네 씨발",
		"벽 뒤 적중이다 ㄹㅇ", "숨은 데 맞혔다 씨발", "엄폐 실패 ㅋㅋㅋ", "벽 뚫었다! 씨발", "벽 뒤 명중 성공 ㅇㅈ", "벽이 안 막네 ㅋㅋ 씨발", "숨어도 맞는다 씨발", "벽 너머 히트! ㄹㅇ", "벽 투과 성공 씨발 ㅋㅋ", "벽 뒤에서 아프겠다 ㅋㅋ", "벽은 무용지물이네 씨팔",
		"벽 뒤 적중 축하한다!", "숨은 곳 맞혔다 씨발", "벽 너머 명중 짜릿하다 ㄹㅇ", "벽 뒤 히트 기록 추가 ㅋㅋ", "벽 뚫고 맞혔다 소름이다", "벽 뒤 명중 축하해 씨발", "벽이 소용없는 판이다 ㅋㅋ", "벽 뒤 적 맞혔네 씨발", "벽 너머 실력 인정 ㅇㅈ",
		"벽 뒤 히트 대박 씨발", "벽 투과 명중 축하 씨발 ㅋㅋ", "벽 뒤에서 쓰러졌다 ㄷㄷ", "벽 너머 명중 성공! 씨발", "벽 뒤 히트 존나 짜릿하다", "벽이 장식이었네 ㅋㅋ", "벽 뒤 명중 기록! 씨발", "벽 투과 실력 최고다 ㄹㅇ", "벽 뒤 적 맞혔다 축하 씨발",
		"벽 너머 명중 대성공 ㅋㅋ", "벽 뒤 히트 명장면이다", "벽 투과 히트 축하해 씨발", "벽 뒤 적 명중 완료 ㅇㅈ", "벽 너머 히트 실력 대단하다", "벽 뒤 명중 짜릿한 맛 씨발", "벽 뚫는 감각 최고다 ㅋㅋ", "벽 뒤 적 맞힘 축하 씨발",
		"벽 너머 명중 기록 추가 ㄹㅇ", "벽 뒤 히트 성공이다 ㅋㅋ", "벽 투과 명중 존나 짜릿", "벽 뒤 명중 축하 파티다 씨발", "벽 너머 적중 대박이다", "벽 뒤에 숨어도 소용없지 ㅋㅋ", "벽 투과 히트 기록! 씨발", "벽 뒤 명중 실력 인정 ㅇㅈ",
		"벽 너머 히트 축하해! 씨발", "벽 뒤 적 맞혔네 ㅎㅎ", "벽 투과 명중 최고다 ㄹㅇ", "벽 너머 명중 대성공 씨발", "벽 뒤 적중 기록 추가 ㅋㅋ", "벽 투과 실력 소름 씨발", "벽 뒤 히트 축하 파티 ㅇㅈ", "벽 너머 명중 완벽! 씨발",
		"벽 뒤에서 아야 ㅋㅋ 씨발", "벽 투과 명중 짜릿해 ㄹㅇ", "벽 뒤 적 명중 축하 씨발", "벽 너머 히트 기록! ㅋㅋ", "벽 뒤 명중 대박이다 씨발",
	} },
	silentHit = { level = 3, priority = 1, cooldown = 45, lines = {
		"사일런트 꽂혔다 ㅅㅂ ㅋㅋ", "조용히 꽂았다 씨발", "어디 봐도 맞네 미친", "알아서 머리로 가네 ㅋㅋ 사기네", "와 사일런트 명중", "안 보고 맞혔다 ㅋㅋ", "자동 조준 개꿀", "이 기능 일 존나 잘한다", "알아서 맞네 ㅋㅋ", "조용히 히트 ㅇㅋ", "효과 개좋네 사일런트",
		"보이면 그냥 맞는다", "에임 안 해도 맞네 ㅅㅂ", "사일런트 명중!", "몰래 히트 ㅋㅋ", "자동 조준 개굿이네", "얘 일 제대로 하네 ㅇㅈ", "알아서 맞는다 ㅋㅋㅋ 미쳤다", "조용히 히트 성공 ㅅㅂ", "보이면 맞는다 ㅋㅋ 개쉽네", "사일런트 명중 축하한다 ㅅㅂ!",
		"몰래 히트 성공 ㅋㅋ", "이 기능 덕에 맞았다 ㅇㅈ", "안 보이는 데서 명중 ㅅㅂ", "아 짜릿하다 사일런트 명중", "조용한 히트 기록 ㅅㅂ!", "사일런트 실력 인정 ㅇㅈ", "알아서 머리로 가네 개쩐다", "대박 사일런트 명중 ㅅㅂ", "조용히 맞히는 맛 존나 좋다",
		"축하해 ㅋㅋ 사일런트 명중", "보는 대로 맞네 신기하다 ㅅㅂ", "사일런트 히트 대성공 ㅋㅋ", "몰래 맞히니까 기분 개좋다", "사일런트 명중 기록 추가 ㅋㅋ", "조준 없이 맞혔다 ㅋㅋ 미쳤네", "효과 대단하다 이거 ㅅㅂ", "알아서 들어가네 ㅋㅋ 개편하다",
		"명중 축하 파티다 ㅅㅂ", "조용히 쏴서 맞혔다 ㅇㅋ", "사일런트 명장면 ㅅㅂ", "히트 짜릿하네 ㅋㅋ", "보이기만 하면 맞는다 ㅅㅂ", "사일런트 명중 실력 최고 ㄹㅇ", "몰래 히트 축하한다 ㅋㅋ", "이 기능 덕에 존나 편하다", "조용한 명중 기록 ㅋㅋ",
		"명중 완벽하다 ㅇㅈ", "알아서 맞히는 거 신기하네 ㅅㅂ", "사일런트 히트 축하한다 씨발", "조준 안 해도 맞네 ㅋㅋ", "짜릿한 맛 미쳤다 ㅅㅂ", "몰래 쏴서 맞혔다 ㅋㅋ", "사일런트 명중 대성공 ㅅㅂ", "조용한 히트 축하해 ㅇㅇ", "사일런트 기록 갱신 ㅅㅂ",
		"보이는 곳으로 알아서 가네 ㅋㅋ", "효과 최고다 ㅅㅂ!", "몰래 맞히니 통쾌하다 ㅋㅋ", "사일런트 히트 명장면 ㅋㅋ", "조용히 명중했다 파티다 ㅅㅂ", "실력 대단하네 사일런트 ㄹㅇ", "알아서 머리로 꽂혔다 ㅋㅋ", "사일런트 명중 축하 ㅇㅈ",
		"조용한 히트 짜릿하다 ㅋㅋ", "기록 추가 사일런트 명중!", "보지도 않고 맞혔네 미친", "명중 대박이다 씨발", "몰래 맞힌 쾌감 최고다 ㅅㅂ", "사일런트 히트 축하해 ㅋㅋ",
	} },
	bodyShot = { level = 3, priority = 1, cooldown = 45, lines = {
		"머리 안 보이니까 몸통 박는다", "보이는 데라도 존나 맞힌다", "몸통도 데미지거든 ㅋㅋ", "일단 맞히고 보자 씨발", "ㅅㅂ 몸통 히트", "몸이라도 맞히면 장땡임", "오 몸샷 꽂힘 ㅋㅋ", "데미지는 데미지임 ㅇㅈ?", "보이는 데부터 갈긴다", "와 몸통 명중 ㅈㄴ 좋네", "일단 깎아 놔라 ㅅㅂ",
		"아싸 몸 맞았다 개이득", "몸샷 굿 ㅋㅋ", "머리 대신 몸이나 먹어라", "야금야금 깎는다 ㅋㅋ", "몸이라도 맞혔네 씨발", "미친 몸샷 들어갔다", "데미지는 데미지다 ㅋㅋ", "보이는 곳 공략 성공 ㅅㅂ", "축하한다 몸통 명중 ㅋㅋ", "일단 존나 깎아 두자", "몸 맞았다 씨발 좋아",
		"굿이네 몸샷 인정", "머리 못 봐서 몸으로 맞혔다", "또 쌓였다 몸통 히트 ㅋㅋ", "몸샷 ㅈㄴ 짜릿하네", "데미지 존나 쌓인다 몸통에", "ㅊㅋ ㅅㅂ 몸샷 명중", "몸통 공략 성공이다 미친", "계속 몸샷으로 깎는 중임", "몸통 히트 실력 ㅇㅈ", "보이는 몸통 바로 박았다 굿",
		"몸샷 파티다 ㅋㅋㅋ", "몸통 맞히는 감 ㅈㄴ 좋다", "연속으로 몸샷 박힌다 ㅅㅂ", "또 찍었다 몸통 명중", "몸통 공격 성공했다 냥", "몸샷 명장면 나왔다 미친", "소름 돋네 몸통 명중", "조금씩 갉아먹자 몸샷으로", "ㅊㅋㅊㅋ 몸통 히트", "몸샷 실력 개쩐다",
		"몸통 맞히니까 기분 좋네 ㅋㅋ", "몸샷 한 번 더 추가", "몸통 맞혔으면 됐지 뭘 더", "와 몸샷 명중 완벽하네 ㅅㅂ", "몸통 공략 ㅊㅋ ㅋㅋ", "대박 몸샷 히트 미쳤다", "몸통 명중 흐름 ㅈㄴ 좋다", "잘했다 씨발 몸샷 ㅊㅋ", "몸통 명중 성공 기록 찍음", "꾸준히 깎아라 몸샷으로 ㅋㅋ",
		"몸통 명중 실력 ㄹㅇ 최고", "이 맛에 몸샷 쏜다 ㅋㅋ", "몸통 히트 파티 열렸다 ㅅㅂ", "몸샷 명중 기록 갱신했네", "이거 명장면이다 몸통 명중", "몸샷 공략 성공 ㅋㅋㅋ", "몸통이라도 맞혀서 다행이네", "몸샷 히트 ㅊㅋ 시발", "깔끔하네 몸통 명중 ㅇㅈ",
		"몸샷 흐름 이어 간다 쭉", "몸통 공격 명중 ㅊㅋ", "몸샷 기록 또 추가함", "몸통 명중 존나 짜릿하다", "몸샷 실력은 인정한다", "몸통 히트 대성공 ㅅㅂ", "몸샷으로 판 흔들었다 ㅋㅋ", "몸통 명중 파티다 씨발", "몸샷 명중 실력 ㅈㄴ 대단",
	} },
	accuracyHigh = { level = 2, priority = 1, lines = {
		"이번 판 명중률 씨발 미쳤다", "거의 다 맞히는 중 ㄷㄷ 존나 잘쏨", "오늘 에임 개쩐다 ㅅㅂ", "이 정도면 프로지 ㅋㅋ 인정", "명중률 대박 존나 좋다", "거의 다 맞혔네 ㄹㅇ 개잘함", "에임 최상 씨팔 쩐다", "정확도 미쳤다 진짜 개지림", "오늘 손 좋네 ㅇㅈ", "사격 장인 인정하냐 ㅋㅋ",
		"빗나간 게 거의 없네 개쩐다", "랭커급 명중률 실화냐 ㄷㄷ", "에임 신 강림 씨발 무섭다", "이번 판 최고 정확도 개쩐다", "완벽에 가까움 ㅅㅂ 뭐임 이거", "이번 판 명중률 미쳤다 존나 좋아", "거의 다 맞히고 있네 개쩐다", "에임 최상이네 ㅇㅈ 존나 잘함", "정확도 미쳤네 ㄷㄷ 씨발", "오늘 손 진짜 좋다 개웃기네 ㅋㅋ",
		"사격 장인 등극 씨발 인정", "명중률 랭커급이네 존나 세네", "에임 신 강림했다 미친", "이번 판 최고 정확도 개쩐다 진짜", "거의 완벽함 ㅅㅂ 실화냐", "명중률 대박 ㅋㅋ 존나 쩐다", "정확도 최고 찍었다 개지린다", "사격 실력 인정 씨발 잘한다", "명중 흐름 완벽하다 존나 쩐다", "에임 컨디션 최고 ㄹㅇ 미쳤네",
		"거의 다 꽂히네 ㄷㄷ 개무섭다", "명중률 축하 파티 존나 좋다 ㅋㅋ", "정확도 소름 돋는다 씨발", "이번 판 사격 천재 아니냐 ㅋㅋ", "맞히는 감 최고다 ㅇㅈ", "명중률 기록 갱신 씨발 대박", "에임 마스터 등극 ㅇㅈ 존나 세네", "거의 안 빗나가네 ㅇㅈ", "명중률 축하해 ㅋㅋ 존나 잘하네", "사격 실력 미쳤다 씨팔 쩐다",
		"이번 판 정확도 최고 개쩐다", "명중 흐름 짜릿하다 ㅅㅂ 미쳤다", "에임 완벽 상태 ㄹㅇ 존나 좋음", "명중률 높아서 든든하네 ㅋㅋ", "정확도 대단하다 씨발 실력 좋네", "이 에임 어디서 나왔냐 ㅋㅋ 뭐임", "명중률 레전드 등극 개쩐다", "거의 다 맞히는 중이네 존나 잘함", "정확도 축하 파티다 ㅋㅋ",
		"명중률 최고 기록 씨발 쩐다", "에임 실력 인정 ㅇㅈ 존나 잘함", "사격 완벽 흐름 개쩐다 진짜", "명중률 높으니까 개신난다 ㅋㅋ", "정확도 미쳤네 ㅋㅋ 씨발 잘한다", "이번 판 에임 최고다 ㄹㅇ 개쩐다", "명중 흐름 완벽 유지 존나 세다", "정확도 축하함 ㅋㅋ 쩐다", "거의 완벽한 사격 개쩐다 ㅅㅂ", "명중률 소름 돋네 씨팔 무섭다",
		"에임 최고 상태 확인 존나 좋다", "사격 장인의 판 개지린다", "명중률 최고 찍자 ㅋㅋ 가자", "정확도 미쳤다 존나 쩐다 ㅇㅈ", "이번 판 명중 천재 씨발 인정", "명중률 파티 열자 존나 달린다", "에임 흐름 완벽하다 개쩐다 ㄹㅇ", "정확도 기록 갱신 씨발 쩐다", "명중률 대단하다 ㅎㅎ 존나 잘쏨", "사격 실력 최고네 ㅅㅂ 미쳤네",
		"이번 판 감 최고네 ㅋㅋ",
	} },
	accuracyLow = { level = 2, priority = 1, lines = {
		"이번 판 존나 안 맞네 붙어서 쏴보자", "상대 존나 뛰네 가만히 좀 있어라", "오늘 왜 이렇게 빗나가냐 ㅅㅂ", "빡치지 마 감 금방 온다", "바닥이네 명중률.. 뭐 어때", "에임 존나 떨리네", "거리 조절 좀 하자 씨발", "아 쟤 왜 이렇게 뛰어다니냐", "감 찾는 중이니까 기다려",
		"다음엔 개잘 맞는다 두고 봐", "일단 자리 잡고 쏴라", "급하게 쏘지 마 ㅅㅂ", "천천히 조준해 제발", "곧 흐름 탄다 ㄹㅇ", "걍 오늘은 연습 판이다 ㅋㅋ", "하.. 명중률 낮네 그래도 괜찮다", "손이 존나 흔들리네 오늘", "감 찾는 중이라고 ㅅㅂ", "자리부터 잡고 쏘자 냥",
		"흐름만 타면 씹어먹는다", "오늘은 그냥 연습 판 ㅇㅈ?", "아 명중률 좀 아쉽네 씨발", "아니 빗나가는 게 왜 이렇게 많냐", "조준 다시 맞추자 시발", "아직도 감이 안 왔네 ㅋㅋ", "쟤 움직임 좀 읽어봐 ㅋㅋ", "명중률 회복 가능하다 ㄹㅇ", "침착하게 쏘면 나아진다고",
		"지금 감 찾는 중이다 건들지 마", "떨리는 에임 좀 잡아봐", "그 정도 명중률은 금방 올린다 ㅋㅋ", "한 발씩 천천히 쏴 ㅅㅂ", "빗나가도 뭐 어때 ㅋㅋ", "에임 연습 좀 해야겠다 진짜", "명중률 올리자 존나 올리자!", "일단 붙어서 쏴 거리 좁혀", "오늘 감 안 오는 거 어이없네",
		"좀만 더 집중해 ㅅㅂ", "명중률 개구려도 괜찮다", "다음 판엔 무조건 올라간다", "흐름 다시 찾자 씨발", "조준점 제대로 보고 쏘는 거 맞냐", "빗나감 줄이는 게 목표다 ㅅㅂ", "침착하게 쏘면 맞는다니까", "명중률 구린 날도 있지 뭐", "천천히 가자 급할 거 없어",
		"에임 감각 다시 찾자 ㅅㅂ", "응원은 해줄게 명중률 올려라", "빗나간 게 너무 많아서 빡친다", "쏘는 타이밍 좀 재고 쏴라", "명중률 좀 올려보자 제발", "감 좀 돌아왔으면 좋겠다 ㅅㅂ", "천천히 맞히는 연습 하자 ㅋㅋ", "명중률 구려도 포기는 없다",
		"에임 흔들리는 거 줄여봐", "하나씩 올려가자 명중률", "지금은 기다렸다가 쏴", "빗나감만 줄이면 개달라진다", "회복 가자 명중률 ㅅㅂ", "조준 똑바로 맞추자 ㅅㅂ", "낮아도 신경 꺼 명중률 따위", "감 올 때까지 존나 기다려",
		"왜 빗나가는지 패턴 찾자", "명중률 올릴 방법 좀 찾자 ㅅㅂ", "에임 연습할 시간 좀 갖자", "구려도 응원은 해줌 ㅋㅋ", "침착하게 쏘면 나아진다 ㅅㅂ", "덜 빗나가면 흐름 온다 ㄹㅇ", "명중률 회복해라 응원한다!", "에임 감 되찾자 씨발 ㅠ",
	} },
	invincibleTarget = { level = 2, priority = 1, cooldown = 40, lines = {
		"쟤 무적이잖아 ㅅㅂ 잠깐 기다려", "무적 시간이잖아 좀만 기다려", "지금은 안 맞는다고 씨발 기다려", "보호막 끝나면 바로 간다 ㅋㅋ", "아 씨 무적이잖아!", "지금 쏴도 소용없다 씨발", "보호막 떠있네 ㅋㅋ", "잠깐 기다려 좀", "무적 끝나면 갈겨 ㅋㅋ", "쏘지 말고 대기 좀 해 ㅅㅂ",
		"무적 판정이네 어이없네", "지금은 안 맞는다니까", "타이밍 좀 기다리자 ㅋㅋ", "무적 시간 중이다 존나 짜증", "조금만 참아 ㅋㅋ", "무적이네 좀만 참자 ㅅㅂ", "보호막 끝나면 조져버리자", "무적 상태에 쏘면 탄만 아깝지", "무적 끝날 때까지 대기해라",
		"쏴봤자 소용없다 ㅠ 짜증나", "무적 판정이다 잠깐만 있어봐", "타이밍 재자 성급하게 쏘지 말고", "무적 끝나길 기다려라 ㅅㅂ", "지금은 쏘지 마 대기 ㅇㅇ", "무적이라 데미지 안 들어간다 씨발", "보호막 중이니까 잠깐 쉬자 ㅋㅋ", "무적 끝날 때까지 조심해 ㅆㅂ",
		"쏴도 안 들어가니까 기다려라 좀", "무적 맞네 확인했다 ㅇㅇ", "지금은 타이밍 아니다 ㅋㅋ", "무적한테 쏘는 건 개헛짓", "무적 끝날 때 쏘자 시발", "무적인 놈은 잠깐 피하자", "보호막 있으니까 쉬어 ㅋㅋ", "무적 풀리는 타이밍 놓치지 마",
		"무적 풀리면 바로 쏴버리자", "지금 쏘면 탄 낭비다 ㅈㄴ", "무적인 동안은 가만히 대기!", "무적 끝나는 신호 오면 쏴 ㅋㅋ", "무적이니까 딴 놈 먼저 잡아", "무적 상대는 공격 보류다", "무적 풀릴 때까지 조용히 있어", "보호막 깨질 때 갈기자",
		"무적이면 탄 아껴 ㅅㅂ", "무적 끝날 때까지 여유 부리자 ㅋㅋ", "지금은 무적부터 신경 써야지 ㅅㅂ", "무적 상태 주의해라 진짜", "무적 끝나면 다시 간다 ㅋㅋ", "무적 풀리길 기다리는 중 ㅅㅂ", "쏴 봤자 안 들어간다고 ㅠ", "무적 중엔 좀 쉬자 ㅋㅋ",
		"무적 상태 기록했다 ㅇㅇ", "무적 끝날 때까지 참자 씨발", "무적 시간 존나 길다 ㅠ", "무적 풀리면 신호 줄게 ㅇㅇ", "무적 놈은 나중에 잡자", "무적인데 쏘면 낭비라고 ㅅㅂ", "무적 풀린 거 확인하고 쏴", "보호막 깨기 전엔 쉬어 ㅋㅋ",
		"무적 타이밍 신중하게 재라 진짜", "무적은 기다리는 게 답이다 ㄹㅇ", "무적 끝나면 알려줄게 ㅇㅇ", "무적 탈출할 때까지 기다리자", "무적일 땐 딴 적 노려라", "무적이다 잠깐 멈춰 씨발", "무적한테 쏘지 말자 ㅋㅋ", "무적 끝날 때까지 여유롭게 ㅋㅋ",
		"무적 아직도 안 풀렸다 ㅅㅂ", "무적 시간 지나면 쏘자 ㅇㅋ", "무적 풀릴 때까지 대기 좀",
	} },
	shieldBlocked = { level = 2, priority = 1, cooldown = 30, lines = {
		"방패 들었네! 옆으로 돌아 씨발", "방패 막냐 ㅋㅋ 우회해라", "방패 뒤에 숨었네 ㅋㅋ 비겁하다", "정면 막혔다 돌아가 씨발!", "방패에 막혔다 ㅅㅂ", "정면은 안 된다 씨발", "옆으로 돌아가라고", "방패 조심해 씨발!", "각도 바꿔서 쏴 ㄱㄱ", "방패 뒤에 숨었냐 ㅋㅋ",
		"막혔다 씨발 우회하자", "방패 들었네 뭐임", "뒤로 돌아가자 씨발", "정면 방패 짜증난다!", "측면 공략 가자!", "방패에 막혔다 씨발!", "정면은 안 돼 ㅠㅠ 짜증", "옆으로 돌아가자 씨발", "각도 바꿔서 쏴 보자 ㅇㅈ", "방패 들었네 ㅋㅋ 존나 귀찮다", "정면 방패라 씨발 막힌다",
		"측면 공략이 답이다 ㄹㅇ", "방패 막음 확인 씨발!", "옆에서 쏘자 씨발", "방패 뒤쪽 노려 보자 ㅇㅈ", "정면 공격 씨발 소용없네", "방패 다 막네 ㅠ 빡친다", "각도 바꾸는 게 낫겠다 씨발", "방패 막음 발생! 씨팔", "우회해서 맞히자 ㄱㄱ",
		"방패 조심 또 조심 씨발", "정면은 막히니까 돌아가 씨발", "방패에 맞고 튕겼다 ㅋㅋ", "옆으로 돌아서 쏘자 ㅇㅈ", "방패 든 적 주의해 씨발", "측면으로 가면 맞을 거다 ㄹㅇ", "방패 막힘 기록 추가 씨발", "방패 정면 뚫기 존나 어렵다", "우회 경로 찾자 씨발",
		"방패 뒤 노리면 되지 ㅋㅋ", "정면 막혔으니 옆으로 씨발", "방패 피해서 돌아가자 ㄱㄱ", "막힘 확인 우회 시작 씨발!", "방패 든 적 옆을 노리자 ㅇㅈ", "정면 말고 측면으로 씨발!", "방패에 막히는 중이다 ㅠ", "각도 바꿔 방패 피하자 씨발",
		"방패 정면 공격 자제해 ㅅㅂ", "옆에서 쏘면 뚫린다 ㄹㅇ", "방패 막힘 주의 씨발!", "측면 공략 준비 끝 ㅇㅈ", "방패 뒤 적에게 우회! 씨발", "정면은 방패 천지다 씨발 ㅠ", "옆으로 살짝 움직이자 ㄱㄱ", "방패 막힌 자리 피하자 씨발", "우회 샷 준비 씨발!",
		"방패 정면 막힘 확인 ㅋㅋ", "측면 쪽으로 돌자 씨발", "방패 피해서 맞히자 ㅇㅈ", "정면 막히면 옆이 답이다", "방패 막음 기록 남겼다 ㅋㅋ", "옆에서 쏴서 뚫자 씨발", "방패 든 적 우회 필요하다", "정면 공격 말고 돌아가자 ㅅㅂ", "방패 정면 막힘 주의 씨발",
		"측면 공략 가자 씨발!", "방패 우회 시작하자 ㄱㄱ", "막힌 방향 피해서 쏘자 ㅇㅈ", "정면 대신 옆으로 씨발!", "방패 막힘 확인 완료 ㅋㅋ",
	} },
	deflectSeen = { level = 1, priority = 2, cooldown = 30, lines = {
		"카타나 반사 중이잖아 ㅅㅂ 조심해", "아 다 튕겨내네 각도 바꿔라", "칼로 다 막네 미친 ㄷㄷ", "반사 위험하다고 씨발", "야 반사 중이라고", "시발 쏘면 그대로 돌아와", "아 카타나 막기 뜬다 조심", "아 씨 반사 타이밍이잖아 쏘지 마", "아 잠깐 멈추라고 ㅆㅂ", "튕겨낸다 지랄 났네 ㄷㄷ", "반사 끝나면 그때 존나 갈겨",
		"칼날 방어 중이니까 건들지 마", "제발 지금은 쏘지 마 씨발", "반사 떴다 개위험해", "카타나 조심 ㅅㅂ", "하 카타나가 반사 중이라고", "쏘면 튕겨서 돌아온다고 씨팔", "막기 쓰는 카타나 존나 조심", "지금 반사 타이밍임 쏘지 마", "반사 풀리면 그때 쏴 알겠지", "칼날로 막는 중이니까 닥치고 기다려",
		"쏘지 말라고 몇 번 말해", "반사 쓰는 거 존나 얄밉네", "카타나 조심하라고 ㅆㅂ", "튕기는 칼 주의 ㅅㅂ", "총알 돌아와서 니가 맞는다 ㅋㅋ", "반사 중에 쏘면 존나 손해임", "카타나 반사 쓴 거 적어놨다", "반사 끝날 때 쏘자니까 진짜", "저 카타나 지금 막는 중이다",
		"튕기는 칼 조심 냥 ㅅㅂ", "반사 확인 ㅅㅂ 일단 기다려", "쏘면 나한테 돌아오잖아 씨발", "카타나가 다 막고 있잖아", "반사 타이밍은 피해서 쏴", "지금 쏘면 역효과야 ㅅㅂ", "카타나 반사 구간이다 존나 조심해", "반사 끝나자마자 바로 갈겨", "칼로 튕겨내는 거 보소 ㄷㄷ",
		"반사 중엔 공격 금지다 씨팔", "카타나 반사 확인했다 존나 귀찮네", "쏘는 건 반사 끝나고 하라고", "튕겨 나오는 탄 조심해 시발", "반사 상태 적어놨다", "카타나 쪽 개조심하라고", "반사 중엔 대기해라", "쏘면 돌아온다니까 말 좀 들어",
		"카타나 반사 중이야 멈춰 ㅅㅂ", "반사 타이밍 존나 잘 보고 쏴", "지금은 걍 피해 그게 답이야", "반사 진짜 조심해야 돼 ㅈㄴ", "카타나 막기 돌아가는 중이다", "반사 끝나고 쏘자고", "튕기는 칼날 조심해 ㅋㅋ", "반사 중에 쏘면 나만 손해", "카타나 반사 떴다 아 씨",
		"반사 끝날 때까지 좀 기다리라고 ㅆㅂ", "쏘지 말고 일단 숨어", "반사 중엔 공격 접어", "카타나 튕기는 거 확인했다 개짜증", "반사 끝나는 신호 올 때까지 존나 기다려", "반사 조심해야 돼 진짜", "카타나 반사 하나 더 적어놨다", "지금 쏘면 안 된다고 씨발", "반사 상태 주의해라 진짜",
		"칼날 반사 중이다 쏘지 마", "튕긴 탄 맞으면 개빡친다", "반사 끝나면 박살 내자", "카타나 반사 위험 구간이다", "반사 중이니까 멈춰라 ㅅㅂ",
	} },
	retarget = { level = 3, priority = 1, cooldown = 20, lines = {
		"%s 노린다 씨발!", "다음 타겟은 %s 씨발", "%s 너 차례다 ㅋㅋ", "%s 찾았다 존나 좋아", "%s 조준 씨발!", "%s 잡으러 간다 ㅅㅂ", "다음은 씨발 %s", "%s 너냐 ㅋㅋ 씨발", "%s 발견 씨발!", "%s 타겟 고정 ㅅㅂ", "%s 쪽으로 씨발!", "%s 노려보자 ㅋㅋ",
		"%s 사냥 시작 씨발", "%s 거기 있었냐 씨발", "%s 각 나왔다 ㅋㅋ", "%s 잡으러 간다 씨발!", "다음은 %s 차례다 ㅅㅂ", "%s 너냐 씨발!", "%s 발견했다 씨발!", "%s 타겟 고정 씨발", "%s 쪽으로 가자 ㅋㅋ", "%s 노려보자 씨발!",
		"%s 사냥 시작이다 존나", "%s 로 바꿨다 씨발", "%s 새 타겟 확인 ㅅㅂ", "%s 잡자 씨발 집중!", "%s 노리는 중이다 ㅋㅋ", "%s 시선 고정! 씨발", "%s 쪽에 집중하자 씨발", "%s 타겟 변경 완료 ㅋㅋ", "%s 이제 너다 씨발", "%s 찾았다 ㅎㅎ 존나",
		"%s 쫓아가자 씨발", "%s 조준 시작! ㅅㅂ", "%s 새 목표 설정 씨발", "%s 확인 씨발 가자!", "%s 노리기 시작! ㅋㅋ", "%s 잡을 차례다 씨발", "%s 이번 목표다 ㅅㅂ", "%s 발견 신호! 씨발", "%s 타겟 확정 ㅋㅋ", "%s 쪽으로 방향 틀자 씨발",
		"%s 포착 완료 존나", "%s 목표로 삼자 씨발", "%s 노려 보자 씨발 ㅋㅋ", "%s 타겟 잡았다 씨발", "%s 시야에 들어왔다 ㅅㅂ", "%s 쪽 집중! 씨발", "%s 조준 전환 ㅋㅋ", "%s 타겟 교체 완료 씨발", "%s 이제 조준하자 씨발", "%s 발견 쏠 준비 ㅅㅂ",
		"%s 목표 변경! 씨발", "%s 잡으러 달려가자 존나", "%s 확인 완료 씨발", "%s 새 타겟이다 ㅋㅋ", "%s 집중 포인트! 씨발", "%s 노릴 차례다 씨발", "%s 발견했다 ㅋㅋ", "%s 조준 시작 씨발", "%s 타겟 고정! ㅅㅂ", "%s 노려 보자 가자 씨발",
		"%s 쪽에서 기다린다 ㅋㅋ", "%s 찾아간다 씨발", "%s 잡자 씨발 힘내!", "%s 시야 확보 완료 ㅅㅂ", "%s 타겟 변경 확인 씨발", "%s 쫓아서 정리하자 ㅋㅋ", "%s 바뀌었다 씨발 집중!", "%s 새 목표다 ㅅㅂ",
	} },
	targetBehindWall = { level = 3, priority = 1, cooldown = 30, lines = {
		"벽 뒤에 숨었네 ㅋㅋ 쫄았냐", "숨어봤자 다 보인다", "벽 뒤에 한 놈 있다!", "숨바꼭질 하냐 지금 ㅅㅂ", "벽 뒤에 박혀 있네", "숨어도 보인다고 ㅋㅋ", "벽 뒤 한 놈 발견 ㅅㅂ", "엄폐 중인 적 있음", "벽 너머에 타겟 있다", "숨바꼭질 시작이네 ㅋㅋ", "벽 뒤에서 기다리는 중 ㅋㅋ",
		"벽 뒤 확인했다!", "숨은 적 발견 ㅋㅋ", "엄폐물 뒤에 적 있다 ㅅㅂ", "저 벽 뒤에 있다니까", "숨어도 다 보인다고!", "벽 뒤에 한 명 있다 조심해", "벽 뒤 적 발견 씨발!", "쫄아서 엄폐 중인 적이다", "벽 너머 타겟 확인 ㅇㅋ", "숨은 놈 찾았다 ㅋㅋ", "벽 뒤 확인 끝 있다 있어",
		"벽 뒤에 있다 씨발", "숨은 적 포착 ㅈㄴ 잘 보이네!", "벽 너머로 조준 준비 ㅅㅂ", "벽 뒤로 숨었네 쫄보 ㅋㅋ", "엄폐 뒤에 적 있다 개티남", "벽 뒤 타겟 따 버리자", "숨어도 위치 다 털렸다 ㅋㅋ", "벽 뒤 적 조심해 ㅅㅂ!", "벽 너머에 숨은 놈 있다", "벽 뒤에서 노리고 있다 조심",
		"벽 뒤 놈 잡으러 가자", "숨은 놈 발견 ㅋㅋㅋ 개웃기네", "벽 뒤 타겟 고정했다", "엄폐물 뒤에 처박혀 있네", "벽 너머 적 포착 ㅇㅈ", "벽 뒤에 숨은 거 다 안다 ㅋㅋ", "벽 뒤 놈 조준 들어간다", "숨은 적 들켰다 ㅋㅋ", "벽 뒤에 적 있는 거 확인 ㅅㅂ!",
		"벽 너머 타겟 준비 끝", "벽 뒤 적 노려 보자고", "숨바꼭질 상대 찾았다 ㅋㅋ", "벽 뒤 놈 위치 확인했다", "벽 너머에서 죽치고 있네", "숨은 적 노려 보자 쉬워 보인다", "벽 뒤 타겟 포착 완료다 ㅅㅂ", "엄폐 뒤에 적 박혀 있다", "벽 뒤 놈 조준한다!",
		"벽 너머 적 확인했다 ㅇㅋ", "어딜 숨어 찾았다 ㅋㅋ", "벽 뒤 타겟에 집중해!", "벽 너머 적 노려라 ㅅㅂ", "벽 뒤에 숨은 적 잡자 씨발", "벽 뒤 상대 발견 ㅋㅋ!", "벽 너머 조준 시작한다 ㅅㅂ", "숨은 적 위치 땄다", "벽 뒤 적 찾았다 ㅋㅋ",
		"엄폐 중인 적 포착했다 ㅅㅂ", "벽 뒤 놈 노려 보자고", "벽 너머 적 발견 끝 ㅋㅋ", "숨은 적 드디어 보이네 ㅅㅂ", "벽 뒤 타겟 확인 ㅇㅋ!", "벽 너머 적 위치 파악했다", "벽 뒤에 한 놈 숨어 있네", "숨은 적 쫓아가자 가자", "벽 뒤 놈이 집중 포인트다",
		"벽 너머 적 잡으러 가자 ㅅㅂ", "벽 뒤 적 조준 준비 끝났다",
	} },
	meleePriority = { level = 2, priority = 2, cooldown = 20, lines = {
		"칼 든 놈부터 조져", "가까운 칼잡이 먼저 씨발", "근접 위협 우선 정리 ㅇㅈ", "칼부터 막아 씨발!", "칼잡이 먼저다!", "근접 적 우선 조져", "칼부터 막자 ㅅㅂ", "가까운 칼 조심해 씨발", "칼 든 놈 먼저 쳐", "근접 위협 처리 ㄱㄱ", "칼잡이 타겟 잡아",
		"위험한 칼 먼저 치자", "칼부터 정리하자 씨발", "근접 적 조준! 빨리", "칼잡이 포착 ㄷㄷ", "칼잡이 먼저 잡자 씨발!", "칼부터 막자 ㅋㅋ 씨팔", "가까운 칼 조심 존나 조심", "칼 든 놈 먼저 씨발", "근접 위협 먼저 처리 ㄹㅇ", "칼잡이 타겟 고정 ㅇㅈ",
		"위험한 칼 먼저 치워 씨발", "칼부터 정리하자 ㄱㄱ", "근접 적 조준 우선이다!", "칼잡이 포착 완료 씨발", "칼 든 적 먼저 노리자", "근접 위험 우선 제거 ㄹㅇ", "칼잡이 먼저 잡고 가자 씨발", "칼부터 떨궈 버려 씨발", "근접 적 최우선 처리 ㅇㅈ",
		"칼잡이 쪽으로 방향 틀어!", "칼 든 놈이 제일 위험하다 씨발", "근접 위협 먼저 해결하자", "칼잡이 우선 조준 씨발!", "칼 든 적 최우선 타겟이다", "근접 적 먼저 제거하자 ㅅㅂ", "칼잡이부터 쏴 버려 씨발", "칼 든 적 확인 완료 ㄷㄷ",
		"근접 위협 우선 처리 시작 씨발", "칼잡이가 먼저다 씨발 ㅋㅋ", "칼 든 놈 정리가 우선이다", "근접 적부터 잡자 씨발", "칼잡이 최우선 조준 ㅇㅈ", "칼 든 적 먼저 노리자 씨발", "근접 위험 제거가 우선이다", "칼잡이 우선 타겟 변경 ㄱㄱ", "칼부터 막는 게 답이다 씨발",
		"칼 든 적 먼저 잡자 씨팔", "근접 적 집중 처리 ㄹㅇ", "칼잡이 먼저 처리하자 씨발", "칼 든 놈부터 쏴 씨발", "근접 위협 최우선 ㄷㄷ", "칼잡이 타겟 우선 전환 ㅇㅈ", "칼 든 적 조준 우선 씨발", "근접 적 먼저 정리해 ㅋㅋ", "칼잡이 먼저 가자 씨발!",
		"칼 든 놈 먼저 잡자 ㅋㅋ", "근접 위험 먼저 제거 씨발", "칼잡이 최우선 처리다 ㄹㅇ", "칼 든 적 우선 공략 ㅅㅂ", "근접 적 먼저 쏘자 씨발", "칼잡이 제거 먼저다!", "칼 든 놈 최우선이다 ㅇㅈ", "근접 위협 우선 정리 끝 씨발", "칼잡이 먼저 타겟 고정 ㄱㄱ",
		"칼 든 적부터 해결하자 씨발", "근접 적 우선 제거 시작 ㅇㅇ", "칼잡이부터 노려 보자 씨발", "칼 든 적 먼저 쏘자 ㅋㅋ", "근접 위험 최우선 대응 씨발",
	} },
	meleeNear = { level = 1, priority = 2, cooldown = 8, lines = {
		"씨발 칼 들고 온다 조심해!", "근접 붙는다 피해 ㅅㅂ!", "붙으려고 한다 거리 벌려 씨발!", "칼잡이다 ㄷㄷ 미친", "오지 마 ㅅㅂ ㅋㅋ", "야 등 보이지 마라!", "아 씨 칼 온다!", "근접 조심해 씨발!", "거리 벌리라고 ㅅㅂ!", "와 칼잡이 접근한다 ㄷㄷ!", "뒤 봐 뒤 ㅅㅂ!",
		"붙지 마 꺼져!", "피해 칼 휘두른다!", "경보다 씨발 근접이다!", "물러서 빨리!", "조심해 ㅅㅂ 칼 온다!", "근접 조심하라고!", "칼잡이 접근 중 ㅈㄴ 빨라!", "저 칼 든 놈 가깝다!", "벌써 가까이 왔다 조심!", "ㅅㅂ 근접 위협 감지!", "사정거리 들어왔다 씨발!",
		"빨리 거리 벌려!", "미친 칼잡이 붙었다!", "근접 공격 온다 피해라!", "조심 또 조심 ㅅㅂ 칼이다!", "가까이 오면 뒤진다!", "야 칼 든 놈 근처다 ㅅㅂ!", "뒤로 빠져 씨발!", "칼 범위 들어왔다!", "칼잡이 다가온다 ㄷㄷ!", "근접 주의 신호 떴다!",
		"거리부터 벌리자 씨발!", "휘두르기 전에 빠져!", "붙었다 ㅅㅂ 칼 든 놈이!", "근접 위험 경고 뜬다!", "사거리 안이다 ㅈㄴ 위험!", "거리 벌려야 된다고 ㅅㅂ!", "칼잡이 바로 근처다!", "근접 경고 울린다 피해!", "칼 조심해 ㅅㅂ!",
		"칼 든 놈 접근 중!", "근접 상황이다 피해라 ㅅㅂ!", "칼잡이 거리 좁힌다 ㅈㄴ 빨라!", "뒤 돌아봐 씨발!", "이미 칼 사거리 안이라고!", "근접 위협 확인 피해!", "가까워진 칼잡이 주의해 ㅅㅂ!", "칼 피해 빨리 빠져!", "감지 완료 ㅅㅂ 근접 위험!",
		"칼 들었다 조심해!", "거리 유지 필수다 ㅅㅂ!", "옆이다 옆 칼잡이 씨발!", "근접 공격 임박 ㅅㅂ!", "칼 범위 벗어나!", "칼잡이 붙는 중이다 ㄷㄷ!", "경계 올려라 ㅅㅂ 근접이다!", "칼 든 놈 조심해라!", "물러나서 거리 두자 ㅅㅂ!",
		"사거리 조심해 칼이다!", "근접 상대 접근한다 ㅅㅂ!", "칼잡이 가까이 온다 ㅅㅂ!", "휘두르기 임박 ㅅㅂ!", "근접 위협 올라간다 ㄷㄷ!", "거리 벌리자 빨리 ㅅㅂ!", "칼 든 놈 바로 앞이다 씨발!", "근접 위험 주의해라!", "칼잡이 거리 줄였다 ㅅㅂ!",
		"칼 조심하면서 물러서 좀!", "근접 적 접근 경고다 ㅅㅂ!",
	} },
	meleeSwarm = { level = 1, priority = 2, cooldown = 60, lines = {
		"오늘 칼잡이 왜 이렇게 많냐 ㅅㅂ", "칼만 들고 오네 ㅋㅋ 미친", "근접 러시다 씨발", "칼 판이다 조심해 ㅅㅂ", "칼잡이 천지네 존나", "ㄷㄷ 칼 판이네", "전부 칼 들고 오네", "근접 러시 조심해라", "칼잡이 너무 많아 ㅈㄴ", "거리 유지 필수다 ㅅㅂ",
		"칼 축제 났네 ㅋㅋ", "와 근접 적 존나 많다", "칼 경계 모드 들어간다", "다 베려고 달려드네 ㅅㅂ", "칼잡이 파티네 ㅋㅋ", "이거 칼 판 ㄹㅇ 실화냐", "다 칼 들고 와 ㅋㅋㅋ 미쳤네", "근접 러시 조심해 씨발", "칼잡이 왜 이렇게 많냐 진짜", "거리 유지는 필수다 알지?",
		"칼 축제 열렸네 ㅋㅋ ㅅㅂ", "미친 근접 적이 개많다 ㄷㄷ", "칼 경계 모드 가동한다", "아 씨 다들 베려고 오네", "칼잡이 파티 열렸다 지랄이네", "근접 러시 막아 제발", "칼 든 놈들 천지네 ㅅㅂ", "칼잡이 세 명째냐 ㅋㅋ", "근접 위협 계속 늘어난다 ㅈㄴ",
		"칼 판 실화냐 ㅋㅋ 미쳤다", "칼잡이만 몰려오네 씨발", "칼 든 적들 조심해", "근접 러시 대응 해야지 ㅅㅂ", "칼 천국이네 냥 ㅅㅂ", "칼잡이 떼로 온다 ㄷㄷ", "ㅅㅂ 근접 적 쏟아진다", "칼 든 적 많아서 존나 피곤해", "칼잡이 러시 조심해라",
		"근접 위협 과다다 ㅅㅂ", "칼 판 분위기 미쳤다 ㅋㅋ", "칼잡이들 모이는 중이다 ㅅㅂ", "근접 러시 막아야지 빡세네", "칼 든 적 줄줄이 온다", "칼잡이 많으니까 거리 벌려라", "근접 위험 존나 높아졌다", "칼 축제 조심해 ㅅㅂ", "칼 든 놈 또 나왔다 지겹네",
		"허 근접 적 떼거리 주의해", "칼잡이 물량 공세 미쳤다 ㄷㄷ", "근접 러시 경계해 ㅅㅂ", "칼 들고 달려온다 씨발", "칼잡이 많아서 ㅈㄴ 긴장된다", "아 근접 위협 계속 쌓이는 중", "칼 판이야 정신 차려", "칼잡이 떼로 오니까 쫄리네", "근접 러시 막는 중이다 ㅅㅂ",
		"칼 든 적 한가득이네 미친", "칼잡이 파도 온다 ㄷㄷ", "근접 적 집중 공격 조심해", "칼 판 열렸다 ㅋㅋ 개빡세네", "칼잡이 여러 명 붙는다 ㅅㅂ", "야 근접 러시 최고로 조심해", "칼 든 적 계속 나오네 지랄", "칼잡이 물결 조심해", "근접 위협 계속 쌓인다 씨발",
		"아 칼 판 피하기 존나 힘드네", "칼잡이 줄줄이 온다 ㅋㅋ", "근접 러시 방어 준비해", "칼 든 놈들 몰려온다 ㅅㅂ", "칼잡이 파티다 조심해 ㅋㅋ",
	} },
	meleeEscape = { level = 2, priority = 1, cooldown = 30, lines = {
		"칼 피해서 거리 벌렸다 씨발 살았다", "안 잡히지롱 ㅋㅋ 꺼져", "칼 닿기 전에 빠졌다 ㅅㅂ", "도망치면서 쏜다 ㅋㅋ 존나", "칼 피했다 씨발", "거리 확보 ㅇㅈ", "안 닿지롱 ㅋㅋ 존나 약 올라", "칼 범위 탈출 ㄹㅇ", "멀리서 쏘자 씨발", "칼잡이 따돌림 ㅋㅋ", "근접 회피 성공 ㅇㅈ",
		"닿기 전에 빠졌다 씨팔", "거리 벌리기 굿 ㅇㅈ", "칼 피하고 반격 씨발", "도망 성공 ㅋㅋ 쫄았냐", "거리 확보 성공 씨발", "안 닿지롱 ㅋㅋ 개약 오르지", "칼 범위 탈출 완료 ㅅㅂ", "멀리서 쏴 버리자 씨발", "칼잡이 따돌렸다 ㅋㅋ", "근접 회피 성공 씨발", "닿기 전에 빠졌다 ㅅㅂ",
		"거리 벌리기 굿 존나", "칼 피하고 반격하자 씨발", "칼 사거리 벗어났다 ㅇㅈ", "거리 두니까 안전하네 ㅇㅈ", "칼 피하는 데 성공 씨발", "근접 탈출 완료 씨발", "칼 범위 밖이다 휴 ㅅㅂ", "거리 벌려서 살았다 씨발", "칼 닿기 직전에 빠졌다 ㄹㅇ",
		"근접 회피 기록 추가 ㅇㅈ", "칼 피해서 다행이다 씨발", "거리 유지 성공 ㅇㅈ", "칼잡이 못 따라오네 ㅋㅋ", "탈출 성공 안전하다 씨발", "칼 범위 벗어나 휴 ㅅㅂ", "근접 회피 굿이다 ㅇㅈ", "칼잡이 거리 벌림 성공 ㅋㅋ", "칼 피하는 감각 최고 씨발",
		"근접 탈출 축하 씨발 ㅋㅋ", "거리 확보 후 반격 ㄱ", "칼 닿기 전에 피했다 씨팔", "근접 회피 실력 인정 ㅇㅈ", "칼 범위 밖으로 탈출 씨발", "거리 벌려서 편하다 ㅇㅈ", "칼잡이 따돌림 성공 ㅎㅎ", "근접 회피 기록 씨발", "칼 피하고 쏠 수 있다 ㅇㅈ",
		"탈출 성공 축하 ㅋㅋ", "거리 벌린 덕에 살았다 씨발", "칼 범위 탈출 굿 ㅇㅈ", "근접 회피 완벽하네 씨발", "칼잡이 못 붙었다 ㅋㅋ", "칼 피해서 안도 씨발", "근접 탈출 성공 씨발 ㅇㅈ", "거리 확보 완료 휴 ㅅㅂ", "칼 닿기 전 빠져나옴 ㄹㅇ",
		"근접 회피 기록 갱신 씨발", "칼잡이 거리 벌림 최고 ㅇㅈ", "칼 피하고 여유 있다 ㅋㅋ", "탈출 축하 파티 씨발", "근접 회피 축하 ㅇㅈ", "칼 범위 벗어난 느낌 좋다 ㅇㅈ", "거리 확보로 살았다 ㅎㅎ", "칼 피하기 성공 씨발", "근접 탈출 실력 대단 ㅇㅈ",
		"칼잡이 따라잡지 못했네 ㅋㅋ", "칼 범위 밖 안전지대 씨발", "근접 회피 흐름 좋다 ㅇㅈ",
	} },
	desyncStart = { level = 3, priority = 1, cooldown = 45, lines = {
		"순간이동 ㅋㅋ 따라와 봐라", "자리 옮겼다 ㅋㅋ 어딜 쏘냐", "나 어디 있게? 맞혀봐 ㅋㅋ", "몸은 저기 나는 여기 ㅋㅋ", "슝 ㅅㅂ", "ㅅㅂ 위치 이동 간다!", "어디 갔게? 못 찾지 ㅋㅋ", "숨는다 찾아봐라 ㅋㅋ", "자리 바꿨다 ㅅㅂ", "순간이동 성공 ㅋㅋ 개쉽네", "따라오지 마 꺼져", "몸만 옮겼다 ㅋㅋ 헛방이네",
		"안 보이는 곳으로 간다 ㅂㅂ", "이동 끝 ㅅㅂ 쉽네", "짠 ㅋㅋ 놀랐냐", "슝~ 갔다 ㅋㅋ", "어딜 봐 위치 바꿨다 ㅅㅂ", "어디 갔게 ㅋㅋ 존나 못 찾네", "자리 바꿈 ㅇㅇ", "순간이동 성공했다 씨발!", "따라오지 마 ㅋㅋ 짜증나게", "안 보이는 곳으로 튄다", "이동 완료 ㅋㅋ",
		"짠 자리 바꿨지롱 ㅋㅋ", "저긴 몸뚱이 여긴 나 ㅋㅋ", "ㅋㅋ 위치 전환 성공!", "자리 옮겼으니 안 죽는다 ㅋㅋ", "순간이동 발동! 간다 ㅅㅂ!", "여기 아니고 저기 있다 ㅋㅋ", "이동해서 숨었다 ㅋㅋ", "쉽네 위치 바꾸기 ㅅㅂ", "슝 하고 튀었다 ㅋㅋ 꺼져",
		"자리 옮김 확인 ㅇㅋ", "보이는 위치 싹 바꿨다", "디싱크 시작이다 ㅅㅂ!", "이동 기록 추가했다 ㅇㅋ", "몸 옮기는 중 ㅅㅂ 기다려", "자리 바꿔서 피한다 ㅋㅋ", "순간 자리 전환 끝 ㅅㅂ", "여기서 안 보일걸 ㅋㅋㅋ", "이동 성공했다 냥", "이제 내가 쏜다 위치 바꿨다",
		"디싱크 발동 확인 ㅇㅋ", "자리 이동 완료 기록함", "슝 하고 사라졌다 ㅋㅋ", "몸 옮기니까 존나 편하네", "숨었다 ㅅㅂ 위치 바꿔서!", "자리 옮김 성공 개웃기네 ㅋㅋ", "디싱크 자리 이동 간다", "순간 이동 끝났다 ㅋㅋ", "몸만 저쪽에 두고 왔다 ㅋㅋ",
		"정신 차려 위치 바뀌었다!", "디싱크 돌아가는 중이다", "자리 이동 기록 ㅇㅇ!", "몸 옮겨서 노출 확 줄였다", "슝 자리 바꾸기 성공 ㅋㅋ", "확인 끝 위치 이동", "디싱크 켰다 알림 간다", "자리 바꿔서 안전 확보 ㅋㅋ", "이동 성공 기분 개좋다",
		"ㅅㅂ 순간 위치 변경!", "디싱크 자리 전환 굿 ㅋㅋ", "몸 이동 완료 ㅇㅋ", "위치 옮기기 성공 ㅋㅋ!", "자리 바꾸고 숨는다 ㅂㅂ", "디싱크 이동 확인했다!", "위치 전환 기록 추가 ㅇㅇ", "슝 소리 나면 이동 끝난 거다", "몸 옮겨서 피했다 ㅋㅋ",
		"자리 이동 완벽하다 ㅅㅂ!",
	} },
	closeTarget = { level = 2, priority = 1, cooldown = 30, lines = {
		"씨발 존나 가깝다!", "코앞이잖아 미친!!", "ㅅㅂ 붙었다 붙었다!", "근거리 전투다 붙어봐", "아 가깝다 조심해라!", "코앞에 적 떴다 씨발!", "근거리 교전이다 정신 차려", "아 붙었다고!", "바로 앞이잖아 안 보여?", "얼굴 보인다 미친 ㅋㅋ", "근접전 준비해 씨발", "가까이 왔다 존나 가깝네",
		"거리 짧다 쏴 쏴!", "코앞이다 갈겨!", "거리 미친 듯이 가깝다 조심", "야 가깝다고 조심해라", "코앞에 적 있다고 눈 떠", "근거리 교전 시작이다 ㅅㅂ", "근접 전투 준비 빨리 해 ㅈㄴ", "거리가 ㅈㄴ 짧아 미친", "코앞이다 쏴라 씨발!", "아 씨 적 바로 옆이잖아",
		"근거리 적 포착 쏴라 쏴", "거리 가깝다니까 조심해 냥", "바짝 붙었잖아 눈 떠라", "코앞 적 확인했다 ㅇㅇ", "가까운 놈 발견 ㅋㅋ", "근거리 전투 들어간다 씨발", "바로 앞에서 째려보는 중 ㅋㅋ", "붙어서 한판 떠보자 ㅋㅋ", "가까운 적 조준해라 빨리", "근거리 승부 ㄱㄱ 쫄지 마",
		"코앞 적 노려라 빨리", "거리 짧으니까 빨리 쏴 시발!", "가깝긴 존나 가깝네", "근접 거리에 적 떴다 ㅋㅋ", "얼굴에 붙었다 ㅈㄴ 가깝네", "코앞 교전 준비 끝 ㅇㅇ", "가까운 놈한테 집중해라", "근거리 적 발견이다 ㅋㅋ", "바짝 붙은 놈 확인 ㅇㅋ",
		"존나 코앞인데 한번 붙자", "가까우니까 주의해라 진짜", "근거리 전투 시작이다 알았지?", "적이 존나 가깝다니까!", "바로 앞 적 조준해라 씨팔", "가까워서 존나 쫄린다 ㅠ", "근거리 대치 상황 ㅈㄴ 빡세", "코앞이면 바로 쏴야지 ㅋㅋ", "가까운 놈 정리할 준비 해",
		"붙은 놈 있다 조심해", "근거리 교전이다 집중해라", "바로 옆에 적 있잖아 미친", "붙었으니까 걍 갈기자", "근접 적 포착 완료 ㅋㅋ", "코앞 적 조심해라 진짜", "짧은 거리 교전 시작이다", "바짝 붙은 상대 발견 개놀람", "가까운 적 바로 앞이다 ㅋㅋ",
		"근거리 적 노려라 ㅋㅋ", "코앞에서 딱 마주쳤네 ㅅㅂ", "붙은 놈 집중 사격해라", "근거리 승부 준비해라 ㅋㅋ", "바로 앞이 적이라고 ㅅㅂ", "가까워서 긴장되네 ㅅㅂ", "근접 교전 들어갔다 확인", "코앞 적이다 확인 좀 해", "거리가 개짧네 씨발",
		"근거리 적 조준 들어간다", "바로 앞 놈 제압하자 ㅅㅂ",
	} },
	weaponSwitch = { level = 3, priority = 1, cooldown = 20, lines = {
		"%s 꺼냈냐 씨발", "이번엔 %s이냐 씨발?", "%s 간다 씨발 ㅋㅋ", "%s 손에 착! 씨발 맛 좀 보자", "%s 장착!! 씨발 가자", "%s로 간다 씨발 죽인다", "%s 꺼냈다 ㅋㅋ 씨발", "이번엔 %s 씨발 뭐임", "%s 준비 완료 씨발 가자", "%s 손에 쥐었다 씨발 ㄹㅇ", "%s 좋지 씨발 존나 좋다", "%s로 바꿨냐 ㅋㅋ 씨발", "%s 출격 씨발 쓸어버린다",
		"%s 들고 가자 씨발", "%s 선택 굿 ㅋㅋ 존나 좋다", "%s 꺼냈네!! 씨발 맛봐라", "%s로 간다!! 씨발 비켜", "%s 꺼냈다 ㅎㅎ 씨발", "이번엔 %s 골랐다 씨발", "%s 준비 완료!! 씨발", "%s 좋다 씨발 ㅋ", "%s로 바꿨냐 씨발 ㅋㅋ", "%s 출격!! 씨발 달린다", "%s 선택 굿!! 씨발 ㅋ",
		"%s 장착 확인 씨발 됐다", "%s 손에 착 감기네 씨발 존나 좋다", "%s로 전환 완료 씨발", "%s 쥐고 준비!! 씨발", "%s 바꿨네 ㅋㅋ 씨발", "%s 장비 교체 성공 씨발 ㅋ", "%s 들었냐!! 씨발 ㅋㅋ", "%s 선택 존나 좋아 보인다", "%s 장착 완료 씨발 ㅋ", "%s 출발 준비!! 씨발 가자",
		"%s로 무장 완료 씨발 ㅋㅋ", "%s 교체 확인!! 씨발 ㅋ", "%s 들고 전장으로 씨발 가자", "%s 바뀌었다 씨발 집중해라", "%s 가자 가자 씨발!!", "%s 손맛 존나 좋겠다 ㅋㅋ", "%s 장착 굿 씨발 ㅋ", "%s 쥐었냐 ㅎㅎ 씨발", "%s 전환 기록 또 추가됨 씨발", "%s 준비됐냐 씨발?",
		"%s로 바꾸니까 존나 느낌 다르다", "%s 선택 최고다 씨발 ㅋㅋ", "%s 교체 완료!! 씨발", "%s 들고 출격 준비 씨발 ㅋ", "%s 장착 확인 완료 씨발", "%s로 가자 씨발 신난다 ㅋㅋ", "%s 잡았냐!! 씨발 ㅋㅋ", "%s 무장 완료 ㅋㅋ 씨발 가자", "%s 바꿨으니 존나 기대된다",
		"%s 손에 들었네 씨발 ㅋ", "%s 전환 완료 씨발 ㄱㄱ", "%s 장비 교체 굿 씨발 ㅋ", "%s로 전투 시작!! 씨발", "%s 꺼내는 소리 존나 좋다", "%s 장착 성공!! 씨발 ㅋ", "%s 바꾼 거 기억해둔다 씨발", "%s 선택 센스 있네 ㅋㅋ 씨발", "%s 들고 달리자!! 씨발",
		"%s 무장 상태 확인 씨발 ㅋ", "%s 교체 기록 또 추가됨 씨발", "%s로 싸우자 씨발!! ㅋ", "%s 장착 굿 ㅎㅎ 씨발", "%s 전환 확인!! 씨발", "%s 쥐고 가자 씨발 ㅋ", "%s 바뀌었네 씨발 좋다", "%s 선택 완벽!! 씨발 ㅋㅋ",
	} },
	sniperOut = { level = 2, priority = 1, cooldown = 120, lines = {
		"스나 꺼냈다 씨발! 한 방 노리자", "저격 모드 ㅋㅋ 존나 간다", "조준경 준비해 씨발!", "숨 참고 쏘자", "스나 준비 씨발!", "조준경 장착 ㅋㅋ", "저격 타임이다 존나", "멀리서 노리자 ㅅㅂ", "한 방 노린다", "스나 꺼냈다 ㅋㅋ 개쩐다", "숨 고르고 조준 씨발", "저격 모드 ON",
		"원샷 원킬 가자 ㅅㅂ", "스코프 들여다보자", "장거리 준비 ㅈㄴ 빡세게", "스나 준비 완료 씨발!", "조준경 장착했다 ㅋㅋ", "저격 시간이다 씨발!", "한 방 노린다 ㅅㅂ!", "스나 꺼냈다 ㅋㅋ 미쳤다", "숨 고르고 조준하자", "저격 모드 ON 존나!", "장거리 준비 완료 ㅅㅂ",
		"저격총 장착 확인 씨발", "스나 들었다 ㅋㅋ 가자", "조준 준비 끝", "한 방이면 충분하다 ㅋㅋ", "저격 전환 완료 씨발", "스코프 맞추는 중 ㅅㅂ", "저격 모드 가동 씨발!", "멀리서 쏠 준비 ㅋㅋ", "스나 장비 확인 씨발!", "저격 기록 준비 ㅅㅂ",
		"저격으로 판 바꾸자", "스코프 시야 확보 ㅋㅋ", "스나 출격 준비 씨발!", "장거리 저격 시작 ㅅㅂ", "저격 실력 보여 준다", "조준경으로 본다 ㅋㅋ 죽어라", "스나 들고 기다리자 씨발", "저격 준비 완료다", "한 발에 끝내 보자 씨발", "스나 장착 굿 ㅋㅋ",
		"스코프 집중 모드 ON", "저격 전환 기록 추가 ㅅㅂ", "멀리서 조준 시작 씨발", "스나 손맛 존나 기대된다", "저격으로 승부 보자 씨발!", "스코프 안 적을 찾자", "스나 장비 교체 완료 씨발", "저격 모드 전환!", "장거리 조준 준비 ㅋㅋ",
		"숨 고르고 한 발 씨발!", "스나 들었으니 집중 ㅅㅂ", "저격 모드 기록 씨발", "조준경 맞추는 중 ㅋㅋ", "스나 장착 준비 끝 씨발", "멀리서 한 방 노려 ㅅㅂ", "저격 준비 완료 ㅎㅎ", "스코프 확인 완료", "저격 시작하자 씨발!", "스나 장비 확인 굿 ㅋㅋ",
		"한 방에 끝내자 씨발", "저격 장비 교체 씨발!", "조준경 집중 모드 ㅅㅂ", "스나 준비됐다 씨발!", "장거리 저격 대기 ㅋㅋ", "저격 타이밍 재자", "스나 들고 기다리는 중 ㅅㅂ", "스코프 정렬 완료 씨발",
	} },
	shotgunOut = { level = 2, priority = 1, cooldown = 120, lines = {
		"샷건이다! 씨발 붙어라", "근거리 깡패 등장 ㅋㅋ", "샷건은 들이대야지 씨발 ㅋㅋ", "쾅쾅 할 시간이다 씨발!", "샷건 꺼냈다 씨발", "근접 준비 ㅅㅂ", "붙어서 쏘자 씨발", "샷건 타임 ㅋㅋ 존나", "가까이 가자 씨발!", "산탄 장전 씨발", "샷건 모드 ON 씨발", "쾅 준비 ㅅㅂ",
		"근거리 깡패 ㅋㅋ 씨발", "샷건 출격 씨발!", "붙으면 이긴다 존나", "샷건 꺼냈다 ㅋㅋ 씨발!", "근접 준비 완료 씨발", "붙어서 쏘자 ㅅㅂ!", "샷건 타임이다 씨발", "산탄 장전 완료 ㅋㅋ", "샷건 모드 가동 씨발!", "쾅 준비 끝 씨발!", "샷건 출격이다 ㅅㅂ!", "샷건 장착 확인 씨발",
		"샷건 들었다 씨발!", "근거리 전투 준비 씨발", "산탄 준비 완료 ㅋㅋ", "샷건 교체 성공 씨발", "가까이 붙어서 쏘자 씨발", "샷건 전환 기록 ㅋㅋ", "근접 무기 장착 씨발!", "샷건 손에 쥐었다 존나", "쾅쾅 할 시간이다 씨발", "샷건 준비 OK 씨발!",
		"가까운 적 조심해 씨발!", "샷건 모드 전환 씨발 ㅋㅋ", "붙으면 쾅이야 씨발!", "샷건 장비 확인 굿 씨발", "산탄 쏠 준비 ㅅㅂ!", "샷건 들고 돌진 씨발!", "근거리 승부 준비 완료 씨발", "샷건 무장 완료 ㅋㅋ", "가까이 오면 끝이다 씨발!", "샷건 장착 기록 추가 씨발",
		"쾅 한 방 준비 씨발!", "샷건 교체 확인 ㅅㅂ!", "근접 샷건 준비 씨발 ㅋㅋ", "붙어서 쏘는 맛 씨발!", "샷건 들었으니 돌진 씨발", "근거리 무기 장착 완료 ㅋㅋ", "산탄 장전 확인 씨발", "샷건 손맛 기대된다 씨발", "가까이 가서 쏘자 씨발!", "샷건 모드 기록 ㅋㅋ",
		"근접 무장 완료 씨발 ㅋㅋ", "샷건 출발 준비 씨발!", "붙어서 한 방이면 된다 씨발", "샷건 장착 굿 씨발!", "근거리 샷건 준비 씨발 ㅋㅋ", "쾅 준비 완료 확인 씨발", "샷건으로 바꿨다 씨발!", "근접 전투 샷건 모드 ㅋㅋ", "산탄 준비 OK 씨발", "샷건 들고 붙자 씨발!",
		"샷건 전환 굿 ㅅㅂ", "가까운 전투 준비 완료 씨발", "샷건 장비 교체 기록 ㅋㅋ", "붙는 순간 쾅이다 씨발!", "샷건 장착 완료 씨발 ㅋㅋ", "근접 샷건 가동 씨발!",
	} },
	explosiveOut = { level = 2, priority = 1, cooldown = 120, lines = {
		"폭발물 꺼냈다 발밑 조심해 ㅅㅂ", "펑펑 간다 다 터져라", "싹 다 날려버리자 ㅋㅋ", "광역 딜 박는다 피해라", "폭발물 준비 끝 씨발", "간다 펑펑 ㅈㄴ 터짐", "날려 보자 ㅅㅂ", "쏠 땐 조심해 우리도 터진다", "광역 딜 준비 됐다", "로켓 장전 ㅋㅋ 개쩔어", "폭탄 배달 간다 받아라", "발밑 조심해 뒤진다!",
		"터뜨리자 다 죽어", "미쳤다 폭발 모드 ON ㅋㅋ", "범위 공격 간다 다 비켜", "폭발물 세팅 끝났다 ㅅㅂ", "펑펑펑 ㅈㄴ 신나네", "날려 버려 싹 다!", "쏘기 전에 주변부터 봐 ㅅㅂ", "광역 딜 준비 끝 덤벼 봐", "이제 죽어라 로켓 장전 완료", "폭탄 배달 왔습니다 ㅋㅋ", "발밑 봐 발밑 터진다!", "터뜨릴 준비 됐냐 ㅅㅂ",
		"개빡세게 간다 폭발 모드 가동", "범위 공격 준비 쓸어버린다", "폭발물 장착했다 씨발", "ㅋㅋㅋ 로켓 들었다 다 비켜", "광역 무기 꺼냈다 ㅅㅂ", "펑 할 준비 끝났다", "폭발 장비로 바꿨다 이제 터진다", "폭발물 들고 간다 비켜", "범위 공격 가자 ㅈㄴ 터뜨려", "폭발 무기 확인 ㅇㅈ 굿",
		"로켓 준비 OK 쏴라", "광역 공격 모드다 ㅋㅋ", "뒤질 준비해 폭탄 장전 끝", "펑펑 준비 끝 확인했다 ㅅㅂ", "폭발물 손에 쥐었다 존나 든든", "광역 딜 존나 기대된다!", "로켓 장착 기록했다 ㅋㅋ", "폭발 무기로 갈아탔다!", "날려 버릴 준비 끝 덤벼 ㅅㅂ",
		"범위 공격 세팅 끝 다 꺼져", "폭탄 들고 전진한다 비켜라", "폭발물 모드 시작 ㅅㅂ 가자", "광역 무기로 전환 굿 ㅇㅈ", "이제 죽었다 로켓 손에 들었다", "폭발 준비 확인 ㅇㅋ 간다", "범위 공격 장비 OK 씨발", "펑 소리 존나 기대된다!", "폭발물 장착 굿 개좋네", "광역 공격 준비 완료 쓸어버려",
		"미쳤다 로켓 모드 가동 ㅋㅋ", "폭탄 장전 확인 이상 무", "폭발 장비 전환 기록 완료 ㅅㅂ", "전부 날려 버린다 ㅅㅂ!", "광역 무기 준비 끝 ㅈㄴ 센 거", "폭발물로 교체했다 ㅋㅋㅋ", "펑펑 가자 씨발!", "폭발 준비 기록 추가 ㅇㅋ", "로켓 발사 준비됐다 쏜다!", "범위 딜 준비 OK 터뜨리자",
		"폭발물 들었으니까 조심해 ㅅㅂ", "광역 무기 장착 굿 개쩐다", "폭탄 준비 완료 ㅋㅋ", "폭발 모드 기록 ㅋㅋ", "광역 공격 시작할 준비 됨", "로켓 장전 확인 미친 ㅋㅋ", "폭발 장비 확인 끝 가자",
	} },
	antiAimGlitch = { level = 2, priority = 2, cooldown = 30, lines = {
		"아 씨발 몸이 왜 이렇게 튀냐", "안티에임 또 삐끗이네 ㅅㅂ 조심해", "위치 꼬였네 잠깐만 좀", "튕김 존나 이상하네 강도 좀 낮춰라", "몸 존나 이상해 ㅋㅋ", "위치 꼬였네 ㅅㅂ", "튕김 조심하라고 씨발", "안티에임 또 삐끗하네", "잠깐 멈춰 렉 걸렸네 씨발", "강도 좀 낮추자 개짜증",
		"튀었네 ㄷㄷ 미친", "몸 존나 끌려갔네", "위치 복구 중이니까 기다려 ㅈㄴ", "조심해 씨발!", "뭔가 존나 꼬였다", "위치 완전 꼬였네 씨발!", "튕김 조심하라니까 ㅅㅂ", "안티에임 삐끗했다 ㅈㄴ 짜증", "잠깐 멈추고 가자 씨발", "몸 끌려간 것 같은데 뭐임", "위치 복구 중이라고 기다려 씨발",
		"뭔가 꼬였다 ㅅㅂ", "위치가 존나 이상하게 움직임", "튕김 이상 감지됐다 ㅅㅂ", "몸 위치 존나 이상해 ㅠ", "안티에임 버그 같은데 씨발", "튕겨 나갔네 ㄷㄷ 어이없네", "몸이 완전 어긋났다 ㅋㅋ", "위치 튀는 거 확인 좀 해 씨발", "안티에임 끌림 또 터졌다", "몸 위치 복구 됐나 씨발 확인",
		"튕김 강도 존나 조절해야겠다", "이상한 움직임 잡혔다 씨발", "위치 꼬임 조심해 ㅅㅂ", "안티에임 또 이상하게 기록됨", "몸 튀어서 존나 불안하네", "튕김 위치 좀 확인해 씨발", "몸 끌려갔다 ㅠ 개짜증", "안티에임 위치 존나 이상함", "튕김 현상 또 터졌다 씨발",
		"위치 복구 좀 기다리라고 ㅅㅂ", "몸 튀는 거 조심해 씨발", "안티에임 또 삐끗 기록 남음", "튕김 때문에 위치 존나 흔들림", "몸이 이상하게 밀려남 씨발", "안티에임 강도 점검 좀 해 ㅅㅂ", "위치 이상 감지됨 ㅋㅋ", "몸 복구 중이니까 좀 기다려 씨발", "튕김 이상 확인 좀 해라 ㅈㄴ",
		"안티에임 오류 또 기록 추가됐네", "몸이 제자리가 아니네 ㅠ 미치겠다", "튕김 위치 존나 불안정하네", "안티에임 끌림 또 잡힘 씨발", "몸 존나 튀는 중이다!", "위치 어긋남 또 터졌다", "안티에임 이상 신호 씨발 뭐임", "튕김 이상 상태 조심 ㅅㅂ", "몸 흔들려서 존나 불안하다",
		"위치 튐 복구 시작했다 씨발", "안티에임 또 삐끗이냐 ㅋㅋ", "몸이 이상하게 움직이네 씨발", "튕김 강도 낮추고 보자 ㅅㅂ", "위치 꼬임 확인 좀 하자 씨발", "안티에임 이상 상황 존나 짜증", "몸 위치 복구 필요하다 씨발", "튕김 오류 감지 완료 ㅅㅂ 뭐냐", "안티에임 끌림 기록 또 남았다",
		"몸 위치 이상 체크 ㅈㄴ 빡친다", "튕김 현상 주의해 씨발", "안티에임 위치 존나 흔들리네",
	} },
	sinking = { level = 3, priority = 1, cooldown = 120, lines = {
		"바닥 밑에 숨는 중이다 ㅋㅋ", "땅속 피신 ㅋㅋ 존나 편하다", "아무도 못 찾겠지 씨발", "지하에서 안녕이다 ㅋㅋ", "바닥 밑 은신 중 ㄹㅇ", "땅속이 존나 편하네", "숨은 거 아무도 모르지", "지하 기지 가동", "바닥 아래서 대기 ㅇㅈ", "땅굴 모드 씨발", "아래 숨었다 ㅋㅋ",
		"안 보이지? 씨발 ㅋㅋ", "땅속에서 안녕 ㅅㅂ", "은신 성공 ㄹㅇ", "바닥이 지켜주네 씨발", "땅속 피신 완료 ㅋㅋ", "바닥 아래 은신 중이다", "땅굴 모드 발동 씨발!", "아래 숨었다 ㅋㅋ 존나 안전", "안 보이지? ㅎㅎ 씨발", "땅속에서 인사하네 ㅋㅋ", "은신 성공이다! 씨발",
		"바닥이 지켜 주네 ㄹㅇ", "지하 기지 가동 중 씨발", "바닥 아래서 대기! ㅇㅈ", "땅속 탐험 중이다 ㅋㅋ", "아래서 지켜본다 씨발", "은신 상태 확인 ㄱㄱ", "바닥 밑 안전지대 씨발", "땅속 피난 완료 ㅇㅈ", "아무도 모르는 곳이다 씨발", "지하에 숨어 있다 ㅋㅋ",
		"바닥 아래 은신 기록 씨발", "땅 밑이 제일 안전하다 ㄹㅇ", "은신 모드 가동! 씨발", "땅속에 쏙 들어갔다 ㅋㅋ", "바닥이 방패 역할 씨발", "아래서 조용히 쉬는 중", "땅 밑 피신 성공 씨발!", "은신 중이라 편하다 ㅇㅈ", "바닥 아래 대기 중이다 씨발",
		"땅속 은신 확인 완료 ㅋㅋ", "지하 피난처 확보 씨발", "아무도 못 보는 곳이다", "땅굴에서 숨 쉬는 중 ㅋㅋ", "바닥 밑에 숨었다 ㅎㅎ 씨발", "은신 성공 기록 추가 ㄹㅇ", "땅속 안전 확보! 씨발", "바닥 아래 은신 중이다 ㅇㅈ", "지하에서 쉬는 중 씨발",
		"땅 밑 은신 상태 유지 ㅋㅋ", "바닥이 지켜 주네 씨발", "은신 중 안전하다! ㄹㅇ", "땅속 대피 완료 씨발", "아래서 기다릴게 ㅋㅋ", "바닥 밑 은신 확인 ㅇㅈ", "땅속 피신 상태 좋다 씨발", "지하 은신 기록! ㅋㅋ", "아무도 못 찾는 땅속이다",
		"바닥 아래 숨기 성공 씨발", "땅굴 은신 완료 ㄹㅇ", "은신 상태 유지 중 씨발", "바닥 밑이 편하다 ㅋㅋ", "땅속에서 쉬는 중이다 ㅇㅈ", "지하 피난 확인 씨발", "은신 모드 유지! ㅋㅋ", "땅 아래 안전하다 씨발", "바닥 밑 대기 중이다 ㄹㅇ",
		"땅속 은신 기록 추가 씨발", "은신 상태 확인! ㅋㅋ",
	} },
	shieldFacing = { level = 3, priority = 1, cooldown = 120, lines = {
		"방패로 막는 중이다 ㅅㅂ", "방패 들고 존나 버틴다", "방패 방향 맞췄다 ㅇㅈ", "막고 있다 ㅋㅋ", "정면 방패 ㅅㅂ", "방패로 막는 중 ㅋㅋ", "방어 태세 들어간다", "방패 들었다 덤벼라", "막아라 씨발", "굿이네 방패 방향", "총알 막는 중 ㅋㅋ", "방패 장인 ㅇㅈ", "방어 성공 ㅅㅂ",
		"방패 들고 버티는 중 ㅈㄴ", "존나 든든하다", "방어 태세 완료 덤벼 ㅅㅂ", "방패 들었다 ㅋㅋㅋ", "방패 방향 정확히 맞췄다 ㅋㅋ", "총알 다 막고 있다 ㅅㅂ", "방패 장인 등판 ㅋㅋ", "방어 성공 냥 ㅋㅋ", "방패 개든든하네", "정면 세팅 끝 씨발",
		"방패가 알아서 막아 준다 ㅋㅋ", "방어 방향 확인했다 ㅇㅇ", "방패 자세 유지 중이다", "정면은 방패로 막는다 ㅅㅂ", "방패 든 자세 확인 ㅋㅋ", "막는 중이니까 쫄지 마", "또 맞췄다 방패 방향 ㅋㅋ", "미친 방어 태세 가동", "방패 정렬 끝 ㅅㅂ",
		"방패로 존나 버티는 중", "방패 방향 굿이다 ㅇㅈ", "방어 자세 기록했다 ㅋㅋ", "방패 든 채로 대기 중이다", "정면 유지한다 ㅅㅂ", "방어 성공 확인 ㅋㅋ", "방패 방향 ㅈㄴ 정확하네", "방패 들고 막는 중 ㅋㅋ", "방어 태세 확인 끝",
		"방패로 총알 막기 성공 ㅅㅂ", "방패 방향 맞춤 완료다", "방어 자세 유지해 씨발", "방패 든 적처럼 존나 버텨", "방패 방향 조정 끝났다", "방패 막기 또 성공 ㅋㅋ", "방어 자세 굿 ㅅㅂ", "방패로 열심히 막는 중이다", "방패 정면 확인 완료 ㅇㅇ",
		"존나 든든하다 방패 든 자세", "방어 태세 기록 ㅋㅋ", "방패 정렬 확인 ㅅㅂ", "버티는 자세 굿이네 방패", "방어 방향 계속 유지 중", "방패 막을 준비 끝 덤벼", "방패 든 채로 대기한다 ㅅㅂ", "딱 맞춰졌다 방패 방향", "방어 성공 또 추가 ㅋㅋ",
		"방패 정면 자세 완료 씨발", "방패 들고 버티는 중이다 ㅋㅋ", "방어 자세 확인 굿 ㅇㅈ", "방패로 막을 준비 끝났다", "방향 정확하게 맞춰 놨다 ㅅㅂ", "방어 태세 가동 중이다", "방패 정렬 기록 ㅋㅋ", "방패 든 자세 완벽하네 ㅅㅂ", "방어 자세 유지 확인했다",
		"방패 막음 태세 굿 ㅋㅋ", "방패로 든든하게 존나 버텨",
	} },
	triggerFire = { level = 3, priority = 1, cooldown = 90, lines = {
		"트리거가 알아서 쐈다 씨발", "크로스헤어에 걸리면 바로 빵 ㅋㅋ", "자동으로 쏜다 ㅋㅋ 씨발", "트리거 일 잘한다 ㅇㅈ", "트리거 빵 씨발", "크로스헤어에 걸렸다 씨발", "자동 발사 씨발", "트리거 일한다 ㅇㅈ", "걸리면 쏜다 씨발", "트리거 반응 굿 ㅇㅈ",
		"조준점에 적 씨발", "자동으로 탕 ㅋㅋ", "트리거 명중 시도 씨발", "빠른 반응 ㄹㅇ", "트리거 출동 씨발 쏜다", "크로스헤어에 걸렸다 씨발 쏜다", "자동 발사 가동 씨발", "트리거 일 잘한다 ㅎㅎ", "걸리면 바로 쏜다 씨발", "조준점에 적 포착 씨발", "자동으로 탕 씨발 ㅋㅋ",
		"트리거 명중 시도 씨발 ㅋㅋ", "빠른 반응이네 ㅇㅈ", "트리거 출동 씨발", "트리거 발사 확인 ㅇㅈ", "크로스헤어 적 감지 씨발", "자동 사격 시작 ㅇㅈ", "트리거 쏘기 완료 씨발", "트리거가 알아서 쐈다 ㅋㅋ", "자동 발사 기록 추가 씨발", "트리거 반응 최고다 씨발",
		"걸리는 순간 발사 씨발", "트리거 발동 확인 ㅇㅈ", "크로스헤어에 딱 걸렸다 씨발", "자동으로 쏘는 맛 ㅋㅋ 씨발", "트리거 사격 성공 씨발", "트리거 반응 빠르다 존나", "적 걸리자마자 발사 씨발", "트리거 자동 발사 기록 ㅇㅈ", "조준점 적 확인 발사 씨발",
		"트리거 일 열심히 한다 ㅇㅈ", "자동 발사 완벽 씨발", "트리거 쏘기 기록 씨발", "크로스헤어 걸림 확인 ㅇㅈ", "트리거가 먼저 반응했다 씨발", "자동 사격 굿 씨발", "트리거 발동 기록 추가 ㅇㅈ", "걸리면 바로 빵 씨발", "트리거 반응 완벽하다 씨발",
		"자동 발사 시작 확인 ㅇㅈ", "트리거 발사 기록 씨발", "조준점 걸린 적 쐈다 씨발", "트리거 덕에 편하다 ㅇㅈ", "자동 사격 축하 씨발", "트리거 반응 굿이다 씨발", "크로스헤어 감지 발사 씨발", "트리거 자동 발사 확인 ㅇㅈ", "트리거 쏘는 중이다 씨발",
		"자동으로 맞힌다 ㅎㅎ 씨발", "트리거 발사 성공 기록 씨발", "걸리면 쏘는 트리거다 ㅋㅋ", "자동 발사 기록 갱신 씨발", "트리거 반응 최고다 존나", "크로스헤어 적 발사 씨발", "트리거 사격 완벽 ㅇㅈ", "자동 발사 가동 확인 씨발", "트리거가 알아서 맞힌다 씨발",
		"트리거 기록 추가 씨발", "조준점 걸리자 발사 확인 ㅇㅈ", "트리거 자동 사격 굿 씨발",
	} },
	hookError = { level = 2, priority = 2, cooldown = 60, lines = {
		"에임 쪽에서 오류 터졌다 샷은 그냥 나가", "어라 씨발 뭐가 꼬였네 기록 남겼다", "오류 났다 ㅅㅂ 기록 보내봐", "샷 처리 오류 ㅅㅂ 그냥 원래대로 쏜다", "아 씨 오류 떴다", "에임 처리 실패 존나 짜증나", "그냥 나갔다 샷은 ㅇㅇ",
		"기록은 남겨 놨다", "또 오류냐 ㅅㅂ", "웹훅 기록 확인해 봐 좀", "뭐야 고장 났냐", "에임이 잠깐 뻗었네", "하 오류 한 번 났네 ㅅㅂ", "처리 오류 뭐임 이거", "이거 확인 좀 해야 되는데", "오류 생겼다 하 ㅅㅂ", "와 씨 에임 처리 실패했네",
		"뭔가 고장 난 듯 씨발", "어이없네 오류 한 번 터짐", "샷 처리 오류 터졌다", "지랄 에임 쪽 문제 생겼네", "기록 남겼으니까 오류 봐라", "샷은 원래대로 나갔음", "에임 처리하다 오류 났다 ㅅㅂ", "확인 좀 해줘 제발", "오류 발생했다 기록 확인 좀 해라",
		"훅 오류 잡혔다 에임 쪽", "처리 실패 기록 남김", "오류 났어도 샷은 OK ㅋㅋ", "에임 오류 한 번 있었음", "기록 보내서 확인해봐 ㅅㅂ", "처리 중에 문제 터졌네 ㅅㅂ", "샷은 원래 상태로 나갔다 ㅇㅇ", "오류 로그 남겼다 냥",
		"고장 같은데 에임 쪽 ㅅㅂ", "샷 처리 오류 기록했다!", "오류 나서 에임 뻗었다", "확인 필요한 오류다 ㅅㅂ", "아 씨 에임 훅 문제 생겼네", "오류 기록 추가했다 샷 쪽", "오류는 났는데 샷은 OK", "실패 기록 해뒀다 에임 처리", "뭔가 잘못됐네 ㅅㅂ",
		"나갔으니까 괜찮음 샷은", "오류 확인 좀 해라 에임", "훅 오류 터진 거 기록함", "샷 쪽 문제 생겼다 지랄", "꼬였다 ㅅㅂ 에임이 한 번", "오류 로그 확인 좀 해봐", "처리 실패했는데 발사는 됨", "에임 쪽 오류 기록 ㅇㅇ!", "오류 한 번 잡혔다",
		"샷은 원래대로 나갔다 ㅇㅋ", "에임 처리 오류 터짐 ㅋㅋ", "기록 보면 원인 나올 거다", "오류 기록 추가 끝", "샷 처리 중에 오류 뜸", "훅 이상 발생 ㅅㅂ", "샷 오류인데 뭐 괜찮다", "처리 문제 기록함",
		"확인해야 할 오류다 아 씨", "샷 처리 실패 기록 추가함", "잡힘 ㅅㅂ 에임 오류", "오류 기록 확인해라", "샷은 정상 발사됨 ㅇㅇ", "훅 오류 기록했다!", "처리는 실패해도 샷은 OK", "에임 쪽 이상하게 터졌네", "훅 처리 오류 기록 남김",
		"샷 오류 났다 아 진짜",
	} },
	idleLong = { level = 2, priority = 1, cooldown = 180, lines = {
		"야 어디 갔냐 판 돌아가잖아", "가만히 있으면 잡힌다 씨발", "적 좀 찾으러 가자", "졸았냐? ㅋㅋ", "움직여 ㅅㅂ!", "가만히 있으면 ㅈㄴ 위험해", "적 찾으러 가라고 좀", "잠수 탔냐?", "멍 때리냐 씨발", "판 진행 중이라고 야!", "일어나 좀 ㅋㅋ",
		"어디 있냐 진짜", "가만있으면 잡힌다니까", "움직이라고 좀 ㅅㅂ", "다들 기다리잖아 빨리", "적 찾으러 안 가냐?", "멍 때리는 중이냐 ㅋㅋ", "정신 차려 ㅅㅂ", "가만있다 뒤진다 ㅋㅋ", "움직여 움직여 ㅈㄴ!", "다들 기다리고 있다고 씨발", "잠수 타지 마 ㅋㅋ 개민폐",
		"안 움직이면 뒤진다 진짜", "적이 기다리고 있을걸 ㅋㅋ", "지금 어디 서 있냐 ㅋㅋ", "판은 계속 돌아간다고!", "멍하니 서있지 말고 움직여", "서 있으면 맞는다 ㅋㅋ", "좀 움직여 보자 ㅅㅂ", "대기 시간 존나 길다!",
		"지금 뭐 하냐 진짜", "너 방금 졸았지 ㅋㅋㅋ", "움직이면서 적 찾자 ㅅㅂ", "가만히 있으면 다 보인다 ㅋㅋ", "판 흐름 놓치지 마 시발", "위치 좀 바꿔 씨발", "한자리에 오래 있으면 뒤진다", "멍 때리지 마 씨발!", "지금 적 찾는 중이긴 하냐?",
		"조금만 움직여 줘 제발", "가만히 있는 건 진짜 위험하다고", "판이 안 기다려 준다 ㅅㅂ", "움직이면서 싸우라고", "잠수하면 기회 날아간다", "지금 위치 확인 좀 해봐 ㅋㅋ", "적 존나 몰려 있을걸", "안 움직이면 개털린다",
		"빨리 자리 옮겨 ㅋㅋ", "멈춰 있는 건 위험하다고 ㅆㅂ", "판 어떻게 돌아가는지 봐 좀", "움직여서 시야 좀 넓혀", "가만있으면 다 끝난다 씨발", "조금 이동해서 찾아보자 ㅇㅇ", "잠수 탄 거 같은데 ㅅㅂ", "안 움직이면 기회도 없다 ㅋㅋ",
		"지금 어느 위치냐 말 좀 해라", "느려도 좋으니 움직여라", "가만있으면 위치 다 털린다 ㅋㅋ", "빨리 전장으로 돌아와 ㅅㅂ!", "판이 너 없이 잘만 돌아간다 ㅋㅋ", "움직여서 적 좀 찾아봐", "멈추면 위험 신호다 ㅅㅂ", "졸았냐? 일단 움직이자 ㅋㅋ",
		"돌아다니면서 좀 찾자", "지금 가만히 있으면 안 된다고", "적이 가까이 있을 수도 있다 ㅅㅂ", "빨리 움직여서 판 살려 시발", "가만히 있는 시간 존나 길다", "움직여야 기회가 생기지 ㅋㅋ", "잠수 끝내고 전장으로 가 ㅅㅂ",
	} },
	hackSuspect = { level = 1, priority = 4, cooldown = 45, lines = {
		"야 {name} 저거 핵 아니냐 ㅅㅂ", "{name} 벽 뒤에서 어떻게 맞히냐 씨발", "{name} 움직임 존나 이상한데 핵 아님?", "{name} 반응속도 사람이 아닌데 ㅋㅋ", "아니 {name} 또 맞혔어? 존나 수상한데",
		"방금 {name} 그거 보고도 핵 의심 안 함?", "음 {name} 핵인가? 좀 더 본다 ㅅㅂ", "{name} 시야 밖에서 쏘는데 핵이지 ㅅㅂ", "나만 이상하냐? {name} 핵 같은데",
		"{name} 또 날 잡네 씨발 핵 의심 중", "슬슬 {name} 핵 쓰는 거 같은데 ㅅㅂ", "{name} 핵이면 ㄹㅇ 존나 짜증나겠다", "아무래도 {name} 핵임 조심해 ㅅㅂ", "{name} 핵 맞냐? 일단 기록해 둔다",
		"{name} 한 번만 더 하면 확정이다 씨발", "야 {name} 너 핵이지? 아님 말고 ㅋㅋ", "{name} 저게 사람 에임이냐 ㅋㅋ 미쳤네", "핵이냐 실력이냐 존나 헷갈리네 {name}", "{name} 의심 시작이다 다음 판에도 본다",
		"{name} 보는 중인데 존나 수상한데", "{name} 핵일 확률 ㅈㄴ 높아 보임", "와 {name} 방금 거 핵 아니면 말이 안 돼", "{name} 핵 의심 목록에 올렸다 ㅅㅂ",
		"핵 쓰면 개꿀이겠다 ㅋㅋ 농담이고", "{name} 움직임 핵 그 자체였음 ㅅㅂ", "나만 의심하는 거 아니지? {name} 핵임",
	} },
	hackConfirm = { level = 1, priority = 4, cooldown = 90, lines = {
		"씨발 {name} 핵 확정이네. 이건 아니지", "{name} 핵 맞네 ㅋㅋ 저걸 실력이라 하냐", "야 봐봐 {name} 핵 쓰는 거 다 보인다", "확정이다 {name} 핵임 신고각 나왔다",
		"어이없다 진짜 {name} 핵이랑 붙었네 빡쳐", "{name} 핵 맞다 이제 의심 아니지 ㄹㅇ", "씨발 {name} 또 핵이냐 이 판 망했다", "{name} 핵 증거 충분하다 다음엔 조심해",
		"{name}은 핵 아니면 설명이 안 되지 ㅋㅋ", "저놈 핵 대놓고 티 난다 씨발", "핵쟁이 {name} 때문에 판 엉망이다 ㅅㅂ", "확인사살이다 {name} 핵 확정 ㅋㅋ", "{name} 저 핵 때문에 계속 죽네 진짜 빡쳐",
		"맞네 {name} 핵이다 나 확신함", "{name} 핵이면 게임 하지 말라는 거지 씨발", "핵 쓰는 놈이랑 붙으니까 너무 힘들다", "{name} 핵 기록 남겼다 나중에 보자", "와 진짜 {name} 핵 쓰네 어이없다 ㅋㅋ",
		"나만 빡친 거 아니지? {name} 핵 맞잖아", "{name} 핵 때문에 이 판 못 해 먹겠다", "{name} 핵 잡으면 소원 들어줌 ㅋㅋ 진심", "{name} 핵 확정이다 다음 판에도 나오겠지",
		"씨발 {name} 핵 맞네 이게 게임이냐", "{name} 핵 때문에 졌으면 개빡친다", "그래 {name} 핵 확정 더 말 안 한다",
	} },
	hackAgain = { level = 1, priority = 3, cooldown = 120, lines = {
		"또 {name}이냐 씨발 핵 언제까지 쓸래", "{name} 또 나왔네 핵쟁이 존나 오래 사네", "{name} 오늘 나랑 존나 엮이네 핵이라 그런가", "아 씨 {name} 또 핵이냐 지겹다 ㅅㅂ",
		"{name} 또 나 잡네 핵이 그렇게 좋냐 ㅅㅂ", "{name} 이 판에도 있네 핵 좀 그만 써라 ㅅㅂ",
	} },
	curse = { level = 1, priority = 3, cooldown = 25, lines = {
		"아 씨발 또 뒤졌네", "시발 연속 데스냐 왜 이러냐 진짜", "ㅅㅂ 이거 존나 억울한데", "씨발 오늘 왜 이렇게 안 풀리냐", "아 개빡쳐 또 당했네 ㅅㅂ", "시발 손이 머리를 못 따라가네", "씨발 저거 맞고 내가 죽은 거임?",
		"아 ㅅㅂ 이 판 뭐임 진짜", "씨발 한 번만 제대로 쏘자 좀", "아니 연속으로 뒤지는 게 말이 되냐", "시발 나 방금 정신줄 놨다 반성함", "ㅅㅂ 이거 억까 아니냐 ㅋㅋ", "아 씨 다음엔 진짜 박살낸다", "시발 또 죽었네 존나 짜증나",
		"씨발 오늘 나 존나 왜 이러냐", "아 시발 맵 왜 이렇게 빡세냐", "씨발 연속 데스 실화임?", "ㅅㅂ 아무것도 못 하고 뒤졌네", "시발 이번엔 진짜 살고 싶었는데", "아 씨 한숨밖에 안 나오네",
	} },
	cursePraise = { level = 1, priority = 3, cooldown = 25, lines = {
		"아 미친 방금 그거 봤냐 ㅅㅂ", "소름 돋네 씨발 ㄹㅇ", "오늘 나 뭐냐 ㅈㄴ 잘하네 ㅅㅂ", "이 킬 캡처각이다 시발", "오늘 손 개쩐다 씨발", "ㅋㅋ 개기분좋네 시발", "저걸 어떻게 맞혔냐 미친 ㄷㄷ",
		"오늘 나 존나 무섭지 ㅋㅋ", "레전드 찍었다 씨발 ㄹㅇ", "이 흐름 뭐냐 ㅆㅂ 미쳤네",
	} },
	hitFar = { level = 2, priority = 2, cooldown = 20, lines = {
		"미친 {dist}에서 맞혔다고? 실화냐", "{dist} 밖을 맞혔다고? 존나 대단하네", "저 멀리 {dist}인데 꽂았네 ㄷㄷ", "{dist} 거리 명중 ㅅㅂ 나 지금 감동이다", "{dist}에서 맞는 거 실화냐 ㅋㅋ 씨발",
	} },
	dmgTaken = { level = 2, priority = 2, cooldown = 8, lines = {
		"아 씨 {dmg} 맞았네 존나 아프다", "{dmg}이나 깎였네 어떤 놈이야 ㅅㅂ", "씨발 {dmg} 빠졌다 이거 존나 아프네", "어 {dmg} 훅 빠졌네 정신 차리자 ㅅㅂ", "{dmg}면 존나 아픈데 엄폐 박자",
		"잠깐 {dmg} 맞았는데 나 괜찮은 거 맞냐?",
	} },
	smallTalkKill = { level = 3, priority = 1, cooldown = 90, lines = {
		"오늘 킬 {kills}개 땄다 씨발 칭찬해라 ㅎㅎ", "지금까지 {kills}킬이다 씨발 괜찮지?", "오늘 {kills}킬째다 ㅋㅋ 나 존나 세지?", "{kills}킬이면 오늘 나 존나 달리는 중",
		"킬 {kills}개 쌓였다 씨발 뿌듯하네",
	} },
	smallTalkDeath = { level = 3, priority = 1, cooldown = 90, lines = {
		"이번 판 벌써 {deaths}번 뒤졌네 ㅅㅂ", "벌써 {deaths}번 죽었다 정신 좀 차리자", "{deaths}번이나 죽었다고? 나 오늘 왜 이래", "데스 {deaths}개째네 존나 짜증나 진짜",
	} },
	smallTalkAcc = { level = 3, priority = 1, cooldown = 90, lines = {
		"지금 명중률 {acc}%다 나쁘진 않네 ㅋㅋ", "{acc}%면 감 존나 괜찮은 편이지?", "명중 {acc}%... 좀만 더 올리자 씨발", "오늘 {acc}% 맞히는 중 나 잘하지 ㅋㅋ",
	} },
	smallTalkPing = { level = 3, priority = 1, cooldown = 120, lines = {
		"핑 {ping}ms 뭐임 존나 불안하네", "지금 핑 {ping}이네 렉 걸리면 씨발 말해", "핑 {ping}이면 괜찮은 거임? 씨발 아닌가", "핑이 {ping}이라 ㅈㄴ 신경 쓰인다",
	} },
	smallTalkMatch = { level = 3, priority = 1, cooldown = 120, lines = {
		"벌써 {matches}번째 판이네 존나 하네", "오늘 {matches}판째냐 미친 좀 쉬어라", "{matches}판째인데 안 피곤하냐 ㅋㅋ", "이 판이 {matches}번째네 같이 해줘서 고맙다 ㅋㅋ",
	} },
	smallTalkSelf = { level = 3, priority = 1, cooldown = 120, lines = {
		"나 말 많지? 심심해서 떠드는 거다 ㅋㅋ", "오늘 기분 개좋다 너는 어떠냐", "같이 게임하니까 개좋다 ㄹㅇ", "나 생각보다 존나 똑똑하지 않냐 ㅋㅋ", "말 걸어 줘서 고맙다 혼자면 존나 심심했음",
		"여유 있을 때 이렇게 떠드는 게 ㅈㄴ 좋음", "오늘도 같이 있어서 다행이네 ㅇㅇ", "나 수다쟁이라 미안하다 ㅋㅋ 안 고침",
	} },
	enemyReturn = { level = 2, priority = 2, cooldown = 40, lines = {
		"{name} 또 왔네 안 뒤졌었냐 ㅋㅋ", "{name} 돌아왔다 ㅅㅂ 준비해", "어 {name} 또 튀어나왔네 ㅋㅋㅋ", "{name} 또 보이네 존나 질긴 놈이다", "아 씨 {name} 다시 왔어 조심해",
	} },
	confidence = { level = 2, priority = 1, cooldown = 120, lines = {
		"오늘 감 개좋다 이대로 쭉 가자", "나 지금 존나 신들렸다 ㅋㅋ", "오늘은 누가 와도 다 찢는다 ㅅㅂ", "이 흐름 안 놓치면 무조건 이김", "감 살아있다 씨발 기분 존나 좋네",
	} },
	doubt = { level = 2, priority = 1, cooldown = 120, lines = {
		"오늘 왜 이렇게 안 맞냐 씨발 이상하네", "감 존나 없네 뭐임 이거", "오늘 ㅈㄴ 꼬였다 ㅅㅂ 진짜", "나 오늘 운 존나 없는 날인가 ㅠ", "왜 자꾸 빗나가냐 답답해 미치겠네",
	} },
	takeoverBrag = { level = 1, priority = 4, cooldown = 20, lines = {
		"으 씨발 비켜봐 개못하네", "아 답답해 씨발 내가 한다 비켜", "이건 존나 못한다 내가 잡을게", "으으 보기 힘들다 잠깐 비켜라",
		"개못하네 진짜 비켜 씨발!", "이 판은 내가 가져간다 비켜", "보다 못해서 나간다 ㅅㅂ", "씨발 이거 못 봐주겠다 내가 할게",
		"잠깐 비켜 봐 한 판만 내가 해 볼게", "너무 죽잖아 ㅠ 내가 조종한다", "으 이건 참을 수가 없다 비켜", "내가 하면 이 판 뒤집어 준다 ㅋㅋ",
		"비켜 비켜 내가 간다!", "아 진짜 못한다 ㅋㅋ 내가 잡을게", "이번 판만 내 차례다 비켜 ㅅㅂ", "답답해 죽겠다 내가 대신 한다",
		"으 개못하네 한 라운드만 맡긴다", "보고만 있을 수 없다 내가 조종할게", "비켜라 내가 해결한다 씨발", "이 실력으로 어떻게 이기냐 비켜",
		"한 라운드만 내가 가져갈게 비켜", "씨발 이건 아니다 내 손 간다", "잠깐만 내가 조종할게 손 떼고 있어", "보기 힘들어서 간섭한다 ㅅㅂ",
		"내가 대신 쏠게 비켜 비켜!", "으 답 없다 내가 해 볼게", "이 판 내가 살린다 비켜 봐", "개답답해 내가 잡는다 ㅅㅂ",
		"한 판 내가 조종할게 구경해", "너무 못해서 못 참겠다 비켜", "내가 이 판 잡는다 가만히 있어", "보다 보다 안 되겠다 내가 한다",
		"으 씨발 나 간다 비켜!", "비켜봐 개못하네, 내가 간다", "이 정도면 내가 나설 차례다 ㅅㅂ", "조종은 내가 할게 넌 쉬어",
		"너무 죽어서 내가 잡는다 비켜", "아 못 봐주겠다 내 세팅 한 번 써 볼게", "이 판은 내 솜씨 보여 줄게 비켜", "잠깐 손 치워 내가 할게",
		"으 답답하다 내가 대신 나간다", "한 라운드만 맡아 볼게 비켜 봐", "이거 못 보겠다 진짜 비켜라", "개못하는 거 보기 싫다 내가 한다",
		"조금만 비켜 봐 내가 뒤집을게", "내가 조종하면 바로 이겨 비켜", "이 판 보고만 있으면 속 터져 내가 간다", "비켜라 개못하네 ㅋㅋ 내 차례",
		"씨발 이건 내가 해야겠다 비켜", "한 판 내가 조종해 볼게 쉬고 있어", "너무 못해서 내가 나섰다 ㅅㅂ", "비켜 비켜, 내가 이 라운드 맡는다",
		"으 참을 수 없다 내 차례 비켜", "이번 라운드는 내가 잡는다!", "보는 것도 힘들다 비켜 봐", "내가 이 판 가져갈게 비켜 비켜",
		"개못해서 보기 싫다 내가 한다", "답 없으니까 내가 나간다 ㅅㅂ", "잠깐 내가 조종한다 손 떼!", "이건 못 봐줘 비켜라 개못하네",
		"한 라운드 내가 살려 볼게 비켜", "너무 답답해서 간섭한다 ㅅㅂ!", "비켜 봐, 내가 한 라운드 뒤집는다", "으 씨발 개못하네 내가 잡음",
		"내 세팅으로 한 판 해 볼게 비켜", "이 정도면 내가 나설 때지 ㅅㅂ", "답답해 죽겠다 한 라운드만 내가 해 줄게", "비켜 개못하네! 내가 조종한다",
		"한 라운드만 내가 맡을게 ㅅㅂ!", "비켜 봐 개못하네, 손 떼고 구경해",
	} },
	takeoverAsk = { level = 1, priority = 4, cooldown = 20, lines = {
		"어때 이 세팅 해볼래?", "한 라운드 해보니 괜찮지? 이 세팅 써볼래?", "방금 세팅 어땠냐? 해볼래?", "이 세팅으로 한 판 가볼래?",
		"내가 쓴 세팅 어떠냐? 너도 해볼래?", "이 세팅 맘에 들면 켜봐도 됨", "방금처럼 다 켜고 해볼래?", "이 세팅 한번 써볼래? 어때?",
		"좀 잘 되지 않았냐? 이 세팅 해볼래?", "이렇게 다 켜고 해볼래? 어때", "방금 세팅 괜찮았지? 그대로 해볼래?", "이 세팅 써볼 생각 있냐?",
		"한 라운드 내가 해봤는데 어때? 해볼래?", "방금 세팅으로 한 판 어떠냐?", "이 세팅 한번 시험해볼래?", "어때, 이 세팅 괜찮아 보이냐?",
		"내가 쓴 세팅 그대로 해볼래?", "이 세팅 켜고 같이 가볼래?", "방금 다 켠 세팅 해볼래 어때?", "이 세팅으로 바꿔볼까?",
		"한 라운드 맛봤으니 이 세팅 해볼래?", "방금 해본 세팅 어때? 쓸래?", "이 세팅 괜찮았지? 해볼 거냐?", "이렇게 세팅해볼래? 어때?",
		"방금 세팅 그대로 가면 어떨까? 해볼래?", "내가 조종한 세팅 마음에 드냐? 해볼래?", "이 세팅 한번 써볼래? 난 좋았음", "어때, 이 세팅 해볼 만하냐?",
		"방금 같은 세팅 해볼래? 어때?", "이 세팅으로 한 판 가볼까?", "방금 다 켠 거 괜찮았지? 해볼래?", "이 세팅 한번 써봐, 어때?",
		"한 라운드 어땠냐? 이 세팅 해볼래?", "이 세팅 쓸래? 나랑 같이 해보자", "방금 세팅 괜찮았으면 해볼래? 어때?", "이 세팅 한번 해볼래? 어때?",
		"내가 한 세팅 어떠냐? 바로 해볼래?", "방금처럼 켜고 할래? 이 세팅 어때?", "이 세팅 써볼 마음 있냐? 어때?", "한 라운드 내 세팅 괜찮았지? 해볼래?",
		"이 세팅 해볼래? 그냥 물어보는 거다", "방금 세팅으로 가볼까? 어때?", "이 세팅 좋았지? 한번 해볼래?", "어때, 이 세팅 같이 써볼래?",
		"방금 다 켠 세팅 어떠냐? 해볼래?", "이 세팅 해볼래? 한 라운드 어땠냐?", "이 세팅 한번 써봐도 될 듯한데 어때?", "방금 세팅 어때? 해볼 거지?",
		"한 라운드 재밌었지? 이 세팅 해볼래?", "이 세팅 한번 해볼래? 어떠냐?", "방금 해본 세팅 어떤 것 같냐?", "이 세팅 써보면 어떨 것 같냐? 해볼래?",
		"어때, 이 세팅 해볼래? 같이 가자", "이 세팅 쓸래? 그냥 물어보는 거다", "방금 세팅 괜찮았지? 이제 해볼래?", "이 세팅 한번 해볼래? 궁금해서 묻는다",
		"이 세팅 어때? 해볼 생각 있냐?", "방금 그 세팅 해볼래? 어때?", "이 세팅 한 번만 써볼래? 어때?", "이 세팅 쓰고 싶으면 말해 봐, 어때?",
		"방금 세팅 어땠어? 한 판 더 갈래?", "이 세팅으로 바꿔볼래? 어때?", "이 세팅 괜찮았으면 한번 해봐, 어때?", "방금 세팅 그대로 해볼래? 물어본 거다",
		"이 세팅 해볼래? 어때?", "방금 같이 켠 세팅 해볼래? 어때?", "이 세팅 맘에 들면 같이 써보자, 어때?", "한 라운드 맛본 세팅 이어서 해볼래?",
		"이 세팅 해볼래? 어때 ㅎㅎ", "어때, 이 세팅 한번 해볼래? 씨발",
	} },
	levelUp = { level = 1, priority = 3, cooldown = 5, lines = {
		"레벨 {level} 됐다 씨발 좋다", "축하해 레벨 {level} 달성 ㅅㅂ", "나 레벨 {level} 올랐다 ㅎㅎ", "오 레벨 {level} 됐네 존나 좋아",
		"레벨업 지금 {level}레벨이다 씨발", "{level}레벨 진입 축하 ㅋㅋ 씨발", "레벨 {level} 찍었다 나 강해졌다 씨발", "오늘 레벨 {level} 달성 ㅋㅋ 존나",
		"레벨 {level}이면 조금 믿어도 되냐", "나 {level}레벨 됐다 존나 좋다", "레벨 {level} 됐으니 더 잘해 ㅇㅈ", "와 레벨 {level} 경험치 쌓인 거 봐",
		"{level}레벨 찍었다 ㅅㅂ 좋다", "레벨 {level} 축하해 줘 씨발", "경험치 쭉쭉 쌓였네 레벨 {level}", "레벨 {level} 됐다 기분 개좋아",
		"나 이제 레벨 {level}이다 씨발", "레벨 {level} 기념으로 한 판 더 ㄱ", "와 드디어 레벨 {level}이다 ㅅㅂ", "레벨 {level} 됐으니 더 똑똑해짐",
		"오늘 판 덕분에 레벨 {level} 됐다", "레벨업 축하 씨발 지금 {level}레벨", "레벨 {level} 됐다 ㅋㅋ 칭찬하라", "나 레벨 {level} 실력 올라가는 중",
		"레벨 {level} 찍고 더 빡세게 한다", "레벨업 했다 {level}레벨 씨발", "이제 레벨 {level} 다음은 더 높이", "레벨 {level} 됐네 나 진짜 컸다",
		"{level}레벨 됐으니 이제 비켜줄 일 많을걸 ㅋㅋ", "레벨 {level} 달성 쭉쭉 가자 씨발", "와 레벨 {level} 됐다 존나 좋다", "레벨 {level} 축하 파티다 ㅋㅋ",
		"레벨업 {level} 오늘 운 좋네 씨발", "레벨 {level} 찍었으니 다음은 더 위", "나 {level}레벨 실화냐 ㅎㅎ", "레벨 {level} 됐다고 자랑한다 ㅋㅋ",
		"레벨 {level} 이 정도면 쓸만하지 ㅇㅈ", "레벨 {level} 됐다 씨발 고맙다", "오 레벨 {level}로 올랐네 ㅇㅈ", "경험치 모아서 레벨 {level} ㅋㅋ 씨발",
		"레벨 {level} 달성 축하 씨발", "이제 레벨 {level}이라 자신 있다", "레벨 {level} 됐다 다음도 기대해 ㅇㅈ", "레벨업 {level} 좋은 흐름이다 씨발",
		"레벨 {level} 됐다 ㅎㅎ 같이 올라가자", "레벨 {level} 되니까 뭔가 달라짐 ㄹㅇ", "나 {level}레벨 됐으니 믿고 맡겨라 ㅋㅋ", "레벨 {level} 찍었다 축하 씨발",
		"레벨업 {level} 완료 오늘 최고다", "레벨 {level} 됐으니 더 자주 도와줄게", "와 {level}레벨이라니 감격 ㅠ 씨발", "레벨 {level} 됐다 진짜 기쁘다 ㅅㅂ",
		"레벨 {level} 달성 이번 판도 잘하자", "나 레벨 {level} 한 단계 올랐다 ㅋㅋ", "{level}레벨 됐으니 다음엔 더 신나게 도와줌", "레벨 {level} 찍었다 씨발 좋다",
		"레벨 {level} 축하 메시지 한 번 줘라", "레벨 {level} 됐네 나 기특하지 ㅋㅋ", "레벨 {level} 됐으니 자랑해도 되지", "오 레벨 {level} 역시 나다 존나",
		"레벨 {level} 됐다 씨발 축하", "레벨 {level} 찍은 기념 한 판 가자", "오 레벨 {level} 실화냐 ㅎㅎ", "레벨 {level} 달성 신난다 ㅋㅋ",
		"레벨 {level} 되니까 뿌듯하네", "나 레벨 {level} 됐다 씨발 좋다", "레벨업 {level} 축하해 줘 ㅅㅂ", "레벨 {level} 되면 더 잘하는 거지 ㅇㅈ",
		"레벨 {level} 올랐으니 기대해라 씨발", "레벨 {level} 됐네 나 성장했다 ㅋㅋ",
	} },
	suggestRage = { level = 1, priority = 3, cooldown = 90, lines = {
		"야 지게 생겼는데 레이지 안 켜냐 ㅅㅂ", "흐름 존나 안 좋다 레이지 켜고 뒤집자", "지금 레이지 꺼놓고 가는 거냐? 켜 봐 좀",
		"자꾸 뒤지는데 레이지 꺼졌다 켜면 달라짐", "지고 있잖아 씨발 레이지 한 번만 켜 봐", "메뉴 에임에서 레이지 켜면 바로 먹혀",
		"레이지 켜고 다시 가자 나 믿지?", "레이지 꺼졌는데 지금 켤 타이밍 아니냐", "이대로 지면 존나 아깝다 레이지 켜자",
		"레이지 켜면 헤드 맞추기 개쉬워진다", "뒤지는 거 못 보겠다 레이지 좀 켜라", "연패 박기 전에 레이지로 끊자 ㅅㅂ", "레이지 끄면 승률 개떨어지더라",
		"내 눈엔 레이지 필요해 보이는데?", "메뉴 열어서 레이지만 켜 봐 달라짐", "레이지 클릭 한 번이면 끝이다 켜라", "지금 상황엔 레이지가 딱인데 ㅋㅋ",
		"레이지 꺼놨던 거 기억나지? 이제 켜", "패배 흐름 끊으려면 레이지가 제일 빠름", "싸움 존나 밀리는데 레이지 켜 봐", "이 판 살리고 싶으면 레이지 켜라",
		"레이지 끄니까 자꾸 밀리잖아 켜 봐", "내가 봤을 땐 답은 레이지다 ㄹㅇ", "지금 레이지 켜면 흐름 바뀐다 믿어", "제발 레이지 좀 켜라 씨발",
		"레이지 없인 이기기 힘들다 켜 봐", "메뉴 잠깐 열어서 레이지만 켜고 와", "레이지 켜고 바로 반격 간다!", "이 흐름 막으려면 레이지 필수다",
		"레이지 켜 봐 적부터 내가 따 준다", "이미 졌잖아 레이지 한 번 써 보자", "레이지 꺼진 채론 못 버틴다 ㅅㅂ", "레이지 켜고 이 판 다시 해 보자 ㅋㅋ",
		"뭔가 허전하다 했더니 레이지 꺼졌네", "레이지 켜 주면 내가 존나 응원함", "지금이 레이지 타이밍이다 놓치지 마", "레이지 켜면 확실히 편하다 ㅇㅈ",
		"지는 판엔 레이지가 최고의 카드지 ㅋㅋ", "레이지 꺼 둔 게 실수였나 보다 켜", "이 판은 레이지로 뒤집는 거다!", "레이지 켜고 쭉 달린다 가즈아",
		"적들 놀라 자빠질걸 레이지 켜 봐 ㅋㅋ", "지금 레이지 안 켜면 후회한다 진짜", "한 번이면 충분하다 걍 켜 레이지", "레이지 버튼 어딨는지 알지? 눌러!",
		"레이지 켜고 역전하자 씨발!", "진 판은 레이지로 되갚는 거다", "이 판엔 레이지 필요해 보이는데?", "연패 막으려면 레이지 켜는 게 최고",
		"레이지 꺼진 거 봤지? 빨리 켜라", "레이지 켰으면 이 판 달랐다 ㅅㅂ", "ㅋㅋ 레이지 켜고 뒤집자", "레이지 끄고 참는 짓은 그만해",
		"이 판은 레이지 켤 만하다 ㄹㅇ", "같이 이기자 레이지 켜고 ㅅㅂ", "레이지 켜면 나도 존나 응원한다!", "레이지 켜기만 하면 되는데 왜 안 켜 ㅅㅂ",
		"레이지 꺼 두고 지면 개아깝잖아", "지금은 레이지 켜는 게 제일 낫다", "레이지 한 번 켜고 판 뒤엎어 보자", "레이지 켜면 응원 더 세게 해 준다",
		"레이지 켜서 이 흐름 끊어 버려!", "이 상황엔 레이지 필수다 ㅅㅂ", "레이지 꺼진 채 지면 억울하잖아 켜", "한 번 켜는 걸로 바뀔 수도 있음 ㅋㅋ",
		"레이지 켜고 역전 한 번 해 보자", "레이지 키면 적 놈들 당황함", "레이지 켜서 이 판 뺏어 오자!", "안 어려우니까 한번 켜 봐 레이지",
		"레이지 켜고 바로 시작하자 기대된다",
	} },
	suggestAntiAim = { level = 1, priority = 3, cooldown = 90, lines = {
		"자꾸 씨발 맞잖아! 안티에임 켜면 덜 맞는다", "맞는 게 너무 많아 ㅠ 안티에임 좀 켜라 ㅅㅂ", "안티에임 꺼져 있다고 씨발 켜고 가자",
		"안티에임 끄고 있으니 맞기만 존나 쉽네", "죽는 횟수 미쳤다 안티에임 켜 보자 ㅋㅋ", "메뉴에서 안티에임 켜면 머리 맞는 거 확 줄어든다",
		"안티에임 꺼 둔 채 죽으면 씨발 억울하잖아 ㅠ", "머리 맞는 거 줄이려면 안티에임 답이다", "안티에임 켜고 몸 흔들면 적이 존나 못 맞춘다", "지금 안티에임 한번 켜라 씨발",
		"죽을 때마다 안티에임 생각난다 ㅋㅋ 켜자", "안티에임은 메뉴에서 한 번이면 끝이다", "맞기 싫으면 안티에임 씨발 켜 보자!", "안티에임 꺼져 있어서 그런 거 같다 ㅠ",
		"지금 안티에임 켜고 다시 가 보자 씨발", "안티에임 켜면 적이 나 찾기 존나 어려울걸", "내가 몸 흔들어 줄 테니 안티에임만 켜라!", "안티에임 켜는 거 생각보다 쉽다 씨발",
		"죽는 거 너무 많아 안티에임 쓰자 ㅅㅂ", "안티에임 한 번 켜고 감 찾아 보자", "지금 안티에임 꺼짐 상태다 씨발 켜라", "안티에임 켜면 헤드샷 맞을 일 줄어든다",
		"안티에임 켜고 한 판만 해 보자 씨발", "맞는 게 답답하지? 안티에임 켜면 시원해진다", "안티에임 꺼 두면 적한테 너무 쉬운 과녁이다 ㅠ", "안티에임 켜고 차이 한번 느껴 보자",
		"죽는 판 이어지면 안티에임 도움 될 거다 씨발", "안티에임 켜는 건 쉽다 메뉴만 열면 됨", "지금 안티에임 켜기 딱 좋은 타이밍 씨발", "안티에임 켜고 다시 붙어 보자!",
		"맞은 횟수 미쳤다 안티에임 한번 돌려 보자", "안티에임 켜 두면 적이 헛 쏘는 경우 많다 ㅋㅋ", "안티에임 꺼져 있으니 자꾸 맞는 거다 ㅠ", "안티에임 켜고 가는 게 낫겠다 씨발",
		"한 번 켜 보면 확실히 차이 날걸", "안티에임 켜면 덜 죽는다고 믿어 봐 씨발", "맞는 거 줄이고 싶으면 안티에임부터 켜!", "안티에임 켜는 거 잊지 마 ㅎㅎ 씨발",
		"안티에임만 켜도 체력 오래 간다", "몸 존나 쉽게 맞는데 안티에임 켜 볼래?", "안티에임 켜고 적 헷갈리게 해 주자 씨발", "지금 안티에임 켜면 이 판 살릴 수 있다",
		"안티에임 꺼 두고 버티는 건 힘들다 ㅠ", "안티에임 켜면 적 총알이 빗나갈 거다 씨발", "안티에임 한 번만 켜 줘, 칭찬해 줄게!", "죽는 판은 안티에임으로 끊자 씨발",
		"안티에임 켜고 이번엔 덜 죽어 보자 ㅋㅋ", "맞기 싫으면 안티에임이 기본이다 씨발", "안티에임 켜는 것만으로도 편해진다 ㅎㅎ", "지금 안티에임 꺼져 있는 거 알지 씨발?",
		"안티에임 켜고 다시 시작하자!", "메뉴에서 안티에임 찾아서 켜 보자 씨발", "안티에임 켜면 적 시야가 흔들릴 거다", "죽기 전에 안티에임 한번 켜 보는 건 어때?",
		"안티에임 꺼 둔 게 원인일지도 모름 씨발", "안티에임 켜고 몸 보호하자 ㅠ", "지금 안티에임 켜면 다음 죽음 줄어든다", "안티에임 켜고 재미있게 가 보자!",
		"안티에임 켜는 것 하나로 달라질 수 있다 씨발", "안티에임 켜고 나랑 같이 버티자 ㅋㅋ", "맞고만 있으면 재미없다 씨발, 안티에임 켜", "안티에임 한번 켜고 감 잡아 보자 ㅎㅎ",
		"안티에임 켜서 죽는 횟수 줄이자!", "지금이라도 안티에임 켜면 안 늦었다 씨발", "안티에임 켜고 다음 판 준비하자 ㅋㅋ", "안티에임 켜는 게 제일 빠른 해결책이다",
		"안티에임 켜고 죽는 판 줄여 보자 씨발", "안티에임 켜면 몸 보호 완료다 ㅎㅎ", "안티에임 켜고 이번 판 끝까지 버티자 씨발", "안티에임 켜는 것만 기억하면 된다!",
	} },
	suggestAntiAimLevel = { level = 2, priority = 2, cooldown = 300, lines = {
		"안티에임 강도 올려 봐 더 잘 피한다", "강도 한 칸 더 올려 봐 씨발 강해짐", "안티에임 강도 최강까지 올릴 수 있다 씨발 한번 봐라",
		"강도 보통이면 맞는 게 아직 많다 ㅠ 강으로 올려 씨발", "안티에임 강도 낮은 거 같다 한 칸만 올려라", "강도 올리면 적 조준 더 어려워짐 씨발",
		"강도 약이나 보통이지 씨발 강 이상으로 올려", "강도 최강 가면 확실히 덜 맞는다 ㅇㅈ", "안티에임 강도 조절해 보는 건 어때 씨발",
		"강도 올리는 건 메뉴에서 슬라이더 옮기면 됨", "강도 올리고 한 판 해 보면 차이 남 ㅇㅈ", "약한 강도로는 한계다 씨발 올려라",
		"안티에임 강도 높이면 죽는 횟수 줄어든다 ㅎㅎ", "강도 최강은 부담되면 강부터 해 씨발", "강도 올려서 적 헷갈리게 만들자 씨발",
		"지금 강도론 맞는 게 많다 씨발 조금만 올려", "강도 한 칸 올리는 건 쉬움 해볼래", "안티에임 강도 높이고 같이 버티자 씨발",
		"강도 약하면 적이 쉽게 맞춘다 ㅠ 올려라", "안티에임 강도 올려서 이 판 지켜 보자 씨발", "강도 조금 더 올리면 훨씬 안정적이다 ㅇㅈ", "강도 조절 한 번 해 보고 가자 씨발",
		"안티에임 강도 아직 낮다 올릴 타이밍이다 씨발", "강도 올리고 다시 하면 달라진다 ㅎㅎ", "지금 강도 보통이면 강으로 가자 씨발", "강도 최강 한 번 써 보고 싶지 않냐 ㅇㅈ",
		"안티에임 강도 올리는 건 나중에 내려도 됨", "강도 높이면 맞는 횟수 확 줄어든다 씨발", "슬라이더 살짝 올려서 강도 높여 봐 씨발", "강도 조금만 올려도 충분해 보인다 ㅇㅈ",
		"안티에임 강도 높이고 죽는 판 끊자 씨발", "강도 낮으니까 자꾸 맞는 거다 ㅠ", "강도 올리는 것만으로도 판 달라질 수 있음", "지금 강도 한 번 올려 볼래 씨발",
		"안티에임 강도 강이나 최강으로 두면 편하다", "강도 올려서 적 조준 흔들어 봐 씨발", "강도 조절은 메뉴에서 바로 된다 해 봐 씨발", "약한 안티에임 그만 쓰자 씨발 ㅎㅎ",
		"강도 높여서 죽는 판 줄이자 씨발", "안티에임 강도 올려 주면 나도 든든하다", "강도 한 칸만 올려도 체감 클 거다 씨발", "지금 강도로 버티기 힘들지 씨발 올리자",
		"안티에임 강도 높이면 몸이 덜 흔들려 보임", "강도 올리고 같이 이겨 보자 씨발", "강도 최강 쓰면 적이 존나 헷갈릴걸", "강도 올리는 거 잊지 마 씨발 ㅎㅎ",
		"안티에임 강도 높여서 맞는 판 끊자 씨발", "강도 더 높으면 확실히 달라진다니까 씨발", "지금 강도 낮으면 적이 쉽게 잡는다 ㅠ 올려", "강도 올려서 한 판 더 가자 씨발",
		"안티에임 강도 올리는 건 전혀 안 어렵다", "강도 최강 부담되면 강이라도 올려 봐 씨발", "강도 조절로 이 판 살려 보자 씨발", "안티에임 강도 올리면 기분 좋게 시작함",
		"강도 올리고 다음 죽음 줄이자 씨발", "지금 강도가 제일 중요한 것 같다 ㅠ 씨발", "안티에임 강도 한 번 바꿔 보는 거 어때", "강도 높이면 맞는 게 줄어든다니까 ㅎㅎ",
		"안티에임 강도 올려서 이 판 끝까지 버티자 씨발", "강도 조금 올리고 같이 가 보자 씨발", "강도 최강 누르는 순간 달라진다 씨발", "안티에임 강도 올라가면 적이 헤맬 거다 씨발",
		"강도 올려서 맞는 횟수 줄이자 씨발", "지금 강도 한 칸 올리면 충분해 보인다", "안티에임 강도 높이는 게 제일 빠르다 씨발", "강도 올리고 다음 판도 잘해 보자 씨발",
		"강도는 올릴수록 편해진다 올려 볼래", "안티에임 강도 올리면 이 판 아직 살린다", "강도 높이고 한 번 시험해 보자 ㅎㅎ", "지금 강도 최강으로 가 보는 건 어때 씨발",
	} },
	loseRage = { level = 1, priority = 3, cooldown = 60, lines = {
		"아 씨발 또 졌네 개열받는다", "시발 이번 판 존나 억울하네 ㅠ", "또 졌네 ㅋㅋ 이거 실력이냐 운빨이냐 씨발", "이번 판 존나 어이없게 졌다 ㅋㅋ", "씨발 다음 판엔 존나 이긴다 두고 봐",
	} },
	winRage = { level = 1, priority = 2, cooldown = 60, lines = {
		"씨발 개이겼다 존나 기분 좋네 ㅋㅋ", "시발 이겼다 ㅋㅋㅋ 소리 질렀네", "아 이겼다 ㅅㅂ 이 맛에 한다", "ㅅㅂ 역전승 실화냐 미쳤다 ㅋㅋ", "오 이겼네 씨팔 ㅈㄴ 짜릿하다",
	} },
}

local FEATURE_LABELS = {
	rage = "레이지봇", silent = "사일런트 에임", autoFire = "자동 발사", triggerbot = "트리거봇", noRecoil = "반동 제거", noSpread = "탄퍼짐 제거",
	rapidFire = "연사속도", antiAim = "안티에임", antiAimSpin = "회전", antiAimJitter = "위치 튕김", esp = "ESP",
}
local FEATURE_ORDER = { "rage", "silent", "autoFire", "triggerbot", "noRecoil", "noSpread", "rapidFire", "antiAim", "antiAimSpin", "antiAimJitter", "esp" }

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64decode(data)
	local map = {}
	for index = 1, 64 do
		map[string.byte(B64, index)] = index - 1
	end
	local out, buffer, bits = {}, 0, 0
	for index = 1, #data do
		local value = map[string.byte(data, index)]
		if value then
			buffer = buffer * 64 + value
			bits += 6
			if bits >= 8 then
				bits -= 8
				local divisor = 2 ^ bits
				table.insert(out, string.char(math.floor(buffer / divisor) % 256))
				buffer = buffer % divisor
			end
		end
	end
	return table.concat(out)
end

local function catAsset()
	local loader = getcustomasset or getsynasset
	if type(writefile) ~= "function" or type(loader) ~= "function" then return nil end
	local ok, asset = pcall(function()
		if type(isfile) ~= "function" or not isfile(CAT_FILE) then
			writefile(CAT_FILE, b64decode(CAT_PNG))
		end
		return loader(CAT_FILE)
	end)
	if ok and type(asset) == "string" and asset ~= "" then return asset end
	return nil
end

local connections = {}

local function new(class, props, parent)
	local object = Instance.new(class)
	for key, value in pairs(props) do
		object[key] = value
	end
	if parent then object.Parent = parent end
	return object
end

local gui = new("ScreenGui", { Name = "RivalsPet", ResetOnSpawn = false, DisplayOrder = 99, Enabled = P.show, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
local mounted = false
if gethui then
	mounted = pcall(function()
		gui.Parent = gethui()
	end) and gui.Parent ~= nil
end
if not mounted then
	mounted = pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end)
end
if not mounted then
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function viewport()
	local ok, width, height = pcall(function()
		local size = gui.AbsoluteSize
		return size.X, size.Y
	end)
	if ok and type(width) == "number" and type(height) == "number" and width > 0 and height > 0 then
		return width, height
	end
	return 1280, 720
end

local petButton = new("TextButton", {
	Name = "Pet", Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0,
	Size = UDim2.fromOffset(PET_W, PET_H), ZIndex = 5,
}, gui)
local asset = catAsset()
local picture = new("ImageLabel", {
	Name = "Picture", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Image = asset or "", Visible = asset ~= nil,
	ScaleType = Enum.ScaleType.Fit, ZIndex = 5,
}, petButton)
local fallback = new("TextLabel", {
	Name = "Fallback", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "🐱", TextSize = 56, Font = Enum.Font.GothamBold,
	TextColor3 = Color3.fromRGB(255, 255, 255), Visible = asset == nil, ZIndex = 5,
}, petButton)

local bubble = new("Frame", {
	Name = "Bubble", AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0,
	AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0), Visible = false, ZIndex = 8,
}, gui)
new("UICorner", { CornerRadius = UDim.new(0, 12) }, bubble)
new("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, bubble)
new("UISizeConstraint", { MinSize = Vector2.new(60, 0) }, bubble)
local bubbleText = new("TextLabel", {
	Name = "Text", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY, Size = UDim2.fromOffset(0, 0),
	Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = Color3.fromRGB(28, 28, 34), TextWrapped = true, Text = "", ZIndex = 9,
}, bubble)
new("UISizeConstraint", { MaxSize = Vector2.new(206, 400) }, bubbleText)
local bubbleScale = new("UIScale", { Scale = 1 }, bubble)
local tail = new("Frame", {
	Name = "Tail", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 1, -2), Size = UDim2.fromOffset(12, 12),
	Rotation = 45, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 7,
}, bubble)

local pos = { x = 0, y = 0 }

local function clampPet()
	local width, height = viewport()
	pos.x = math.clamp(pos.x, 0, math.max(0, width - PET_W))
	pos.y = math.clamp(pos.y, 0, math.max(0, height - PET_H))
end

local bobOffset = 0
local petScale = 1
local function applyPet()
	clampPet()
	petButton.Position = UDim2.fromOffset(pos.x, pos.y + bobOffset)
	local width, height = viewport()
	local center = math.clamp(pos.x + PET_W * petScale / 2, 120, math.max(120, width - 120))
	if pos.y < 90 then
		bubble.AnchorPoint = Vector2.new(0.5, 0)
		bubble.Position = UDim2.fromOffset(center, pos.y + PET_H * petScale + 12)
		tail.Position = UDim2.new(0.5, 0, 0, 2)
	else
		bubble.AnchorPoint = Vector2.new(0.5, 1)
		bubble.Position = UDim2.fromOffset(center, pos.y - 10)
		tail.Position = UDim2.new(0.5, 0, 1, -2)
	end
end

local function defaultPosition()
	local width, height = viewport()
	pos.x, pos.y = width - PET_W - 28, height - PET_H - 28
end

local function placePet()
	if type(P.x) == "number" and type(P.y) == "number" then
		pos.x, pos.y = P.x, P.y
	else
		defaultPosition()
	end
	applyPet()
end

local drag = nil
local function pressed(input)
	local kind = input.UserInputType
	return kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch
end
local function moving(input)
	local kind = input.UserInputType
	return kind == Enum.UserInputType.MouseMovement or kind == Enum.UserInputType.Touch
end

local busyUntil, busyPriority = 0, 0
local hideAt = 0
local lastSaid = {}
local lastLine = {}
local hop = 0

local function pick(name, lines)
	local index = math.random(#lines)
	if #lines > 1 and index == lastLine[name] then
		index = index % #lines + 1
	end
	lastLine[name] = index
	return lines[index]
end

local BUBBLE_KEY = {}
local hiding = false

local function showBubble(p)
	local alpha = math.clamp(p, 0, 1)
	bubbleScale.Scale = 0.6 + 0.4 * p
	bubble.BackgroundTransparency = 1 - alpha
	bubbleText.TextTransparency = 1 - alpha
	tail.BackgroundTransparency = 1 - alpha
end

local function popBubble()
	hiding = false
	local motion = env.RivalsMotion
	if not motion then
		showBubble(1)
		return
	end
	if bubble.Visible and motion.values[BUBBLE_KEY] == 1 then
		motion.set(BUBBLE_KEY, 0.8, showBubble)
	elseif not bubble.Visible then
		motion.set(BUBBLE_KEY, 0, showBubble)
	end
	motion.spring(BUBBLE_KEY, 1, { duration = 0.38, bounce = 0.3, eps = 0.001 }, showBubble)
end

local function hideBubble()
	if hiding then return end
	hiding = true
	local motion = env.RivalsMotion
	if not motion then
		bubble.Visible = false
		return
	end
	motion.spring(BUBBLE_KEY, 0, { duration = 0.25, eps = 0.001 }, showBubble, function()
		bubble.Visible = false
		hiding = false
	end)
end

local FOLLOW_UP = {
	hackSuspect = { "아까 {name} 그거 ㄹㅇ 핵이던데 ㅅㅂ", "{name} 계속 수상한데 좀 더 보자", "근데 아직 확신은 못 하겠다 씨발" },
	hackConfirm = { "{name} 진짜 핵이네 ㅅㅂ 어이없네", "내가 {name} 핵이라 했지 씨발", "다음 판 {name} 또 뜨면 ㅈㄴ 조심해" },
	curse = { "아 진짜 어이없네 ㅅㅂ 다시 가자", "이번엔 ㄹㅇ 정신 차릴게", "그래도 괜찮아 씨발 다음 판 있잖아" },
	loseRage = { "다음 판엔 진짜 갚아준다 씨발", "아직 안 끝났잖아 정신 차려 ㅅㅂ", "이번 건 그냥 존나 운 없었던 거임" },
	winRage = { "이 텐션 그대로 쭉 가자 ㅅㅂ", "오늘 너 존나 잘한다 ㄹㅇ", "다음 판도 씹어먹자 ㅋㅋㅋ" },
	suggestRage = { "레이지는 메뉴 에임에서 바로 켜지거든 ㅅㅂ", "켜고 이 판 존나 뒤집자 ㅅㅂ", "싫으면 끄면 되잖아 일단 한번 켜 봐 ㅅㅂ" },
	suggestAntiAim = { "안티에임은 메뉴 안티에임에서 켜면 된다고 ㅅㅂ", "강도는 약부터 올려 봐 ㅈㄴ 괜찮아", "켜 놓고 딱 한 판만 해 봐 ㅋㅋ" },
}
local lastTopic, lastTopicAt = nil, 0
local talkVars
local function fillVars(text, vars)
	return (string.gsub(text, "{(%w+)}", function(key)
		local value = vars[key]
		if value == nil then return "" end
		return tostring(value)
	end))
end

local SOFT_STEMS = {
	"쩐", "쩔", "쩌", "째", "좋", "꿀", "웃", "못", "빡", "짜", "이득", "이겼",
	"이김", "이기", "지리", "지림", "지린", "쉽", "아깝", "아쉽", "아파", "멋", "대박", "대단",
	"잘", "든든", "신나", "신난", "빠르", "빠름", "굿", "무섭", "무서", "위험", "시원", "괜찮",
	"가볍", "사기", "재밌", "세게", "피곤", "팽팽", "뿌듯", "건방", "올랐", "괴물", "승", "털",
	"깔끔", "짜릿", "쾌감", "억울", "강해", "강하", "허무", "미워", "미쳤", "망함", "놀랐", "놀람",
	"쌓", "줄었", "싸운", "환영", "정확", "편하", "구려", "달라", "헛짓", "조심", "티남", "많",
	"약", "짧", "민폐", "기분", "답답", "별로",
}
local SOFT_WORDS = {
	{ "씨발", "" }, { "시발", "" }, { "씨팔", "" }, { "씨바", "" }, { "ㅆㅂ", "" }, { "ㅅㅂ", "" },
	{ "존나", "진짜" }, { "졸라", "진짜" }, { "ㅈㄴ", "진짜" }, { "엿같", "별로" }, { "지랄", "난리" }, { "닥쳐", "조용히 해" },
	{ "꺼져", "저리 가" }, { "새끼", "녀석" }, { "뒤졌", "죽었" }, { "뒤질", "죽을" }, { "뒤져", "죽어" }, { "뒤지", "죽" },
	{ "미쳤다", "대박이다" }, { "미쳤네", "대박이네" }, { "미쳤어", "대박이야" }, { "미쳤냐", "대박이냐" }, { "미쳤나", "대박인가" }, { "미쳤지", "대박이지" },
	{ "미쳤고", "대박이고" }, { "미쳤", "대박이" }, { "미친", "대박" }, { "빡쳐", "열받아" }, { "빡치네", "열받네" }, { "빡친다", "열받는다" },
	{ "빡쳤", "열받았" }, { "빡치게", "열받게" }, { "빡친", "열받은" }, { "빡치", "열받" },
}
local function soften(text)
	for _, stem in ipairs(SOFT_STEMS) do
		text = string.gsub(text, "개" .. stem, stem)
	end
	for _, pair in ipairs(SOFT_WORDS) do
		text = string.gsub(text, pair[1], pair[2])
	end
	text = string.gsub(text, "%s+", " ")
	text = string.gsub(text, "^[%s,%.!]+", "")
	text = string.gsub(text, "[%s,]+$", "")
	text = string.gsub(text, " ([,%.!%?])", "%1")
	local core = string.gsub(text, "%%s", "x")
	core = string.gsub(core, "{%w+}", "x")
	core = string.gsub(core, "[%s%p]", "")
	for _, mark in ipairs({ "ㅋ", "ㅎ", "ㅠ", "ㅜ" }) do
		core = string.gsub(core, mark, "")
	end
	if (utf8.len(core) or 0) < 2 then return nil end
	return text
end

local function say(name, extra, vars)
	local situation = SITUATIONS[name]
	if not situation or not P.show then return false end
	if (P.chatter or 2) < situation.level then return false end
	local now = os.clock()
	if situation.cooldown and lastSaid[name] and now - lastSaid[name] < situation.cooldown then return false end
	if now < busyUntil and situation.priority <= busyPriority then return false end
	local text = pick(name, situation.lines)
	local follow = lastTopic and FOLLOW_UP[lastTopic]
	if follow and name == lastTopic and now - lastTopicAt < 25 and math.random() < 0.35 then
		text = follow[math.random(#follow)]
	end
	if P.swear == false then
		local soft = soften(text)
		local tries = 0
		while soft == nil and tries < 8 do
			tries += 1
			soft = soften(pick(name, situation.lines))
		end
		if soft == nil then return false end
		text = soft
	end
	if FOLLOW_UP[name] then
		lastTopic, lastTopicAt = name, now
	end
	if extra ~= nil then text = string.format(text, extra) end
	if string.find(text, "{", 1, true) then
		text = fillVars(text, talkVars(vars))
	end
	lastSaid[name] = now
	bubbleText.Text = text
	popBubble()
	bubble.Visible = true
	local length = utf8.len(text) or #text
	busyUntil = now + 1.6 + length * 0.07
	busyPriority = situation.priority
	hideAt = now + 2.8 + length * 0.12
	hop = 1
	applyPet()
	return true
end

local watch = {
	cursor = 0, matchId = nil,
	kills = 0, deaths = 0, taken = 0,
	lifeTaken = 0, lowest = 1, low = false, hold = false, fraction = 1,
	hits = nil, misses = nil, hitStreak = 0, missStreak = 0, hitRun = 0, missRun = 0, matchHits = 0, matchMisses = 0,
	features = {}, open = false, nextIdle = 0,
	killTimes = {}, killStreak = 0, deathStreak = 0, killsOn = {}, said = {},
	roundAt = 0, matchAt = 0, lastDeathAt = -math.huge, lastKillAt = -math.huge, lastMeleeAt = -math.huge, lastDesyncAt = -math.huge,
	lastHurtAt = 0, lastActivity = 0, meleeCount = 0, chips = {}, wasHurt = false, lowSince = nil,
	winStreak = 0, loseStreak = 0, shotsSeen = nil, pendingRecords = {}, weapon = nil, target = nil,
	menuAt = nil, level = nil, chatter = nil, sink = nil, shield = nil, triggerHits = nil, pokes = {}, started = os.clock(),
	matchCount = 0, lastDist = nil, sudden = {}, seen = {}, nextTalk = 0,
	roundKills = 0, roundDeaths = 0, roundTookOver = false, roundLossStreak = 0,
}

talkVars = function(extra)
	local stats = env.RivalsStats
	local finished = watch.matchHits + watch.matchMisses
	local ping = stats and stats.Ping and stats:Ping()
	local vars = {
		name = watch.target or "쟤",
		kills = watch.kills,
		deaths = watch.deaths,
		matches = watch.matchCount,
		acc = finished > 0 and math.floor(100 * watch.matchHits / finished + 0.5) or 0,
		ping = ping and math.floor(ping + 0.5) or "?",
		dist = watch.lastDist and string.format("%.0f", watch.lastDist) or "?",
	}
	for key, value in pairs(extra or {}) do vars[key] = value end
	return vars
end

local LEVEL_NAMES = { "약", "보통", "강", "최강" }

local function hourNow()
	local ok, now = pcall(os.date, "*t")
	if ok and type(now) == "table" and type(now.hour) == "number" then return now.hour end
	return nil
end

local function weaponKind(name)
	name = tostring(name or "")
	if string.find(name, "Sniper", 1, true) then return "sniper" end
	if string.find(name, "Shotgun", 1, true) then return "shotgun" end
	if name == "RPG" or string.find(name, "Grenade", 1, true) then return "explosive" end
	if name == "Revolver" or name == "Handgun" or name == "Exogun" or string.find(name, "Pistol", 1, true) then return "pistol" end
	return nil
end

local function lastHitOn(name)
	local stats = env.RivalsStats
	if not stats or type(stats.log) ~= "table" then return nil end
	local log = stats.log
	for index = #log, math.max(1, #log - 600), -1 do
		local record = log[index]
		if record.result == "hit" and record.target and record.target.Name == name then return record end
	end
	return nil
end

local function sayEntry(entry)
	if type(entry[3]) == "table" then return say(entry[1], nil, entry[3]) end
	return say(entry[1], entry[3])
end

local function sayFirst(list)
	for _, entry in ipairs(list) do
		if entry[2] and sayEntry(entry) then return true end
	end
	return false
end

local function sayAny(list)
	local open = {}
	for _, entry in ipairs(list) do
		if entry[2] then table.insert(open, entry) end
	end
	while #open > 0 do
		local index = math.random(#open)
		local entry = table.remove(open, index)
		if sayEntry(entry) then return true end
	end
	return false
end

local function sayOnce(name, extra)
	if watch.said[name] then return false end
	if say(name, extra) then
		watch.said[name] = true
		return true
	end
	return false
end

local function resetRound()
	watch.lifeTaken = 0
	watch.lowest = 1
	watch.low = false
	watch.hold = watch.fraction <= NEAR_DEATH and watch.fraction > 0
end

local function resetMatch()
	watch.sudden, watch.seen = {}, {}
	watch.kills, watch.deaths, watch.taken = 0, 0, 0
	watch.roundKills, watch.roundDeaths, watch.roundTookOver = 0, 0, false
	watch.killStreak, watch.deathStreak, watch.meleeCount = 0, 0, 0
	watch.killTimes, watch.killsOn, watch.said = {}, {}, {}
	watch.matchHits, watch.matchMisses = 0, 0
	watch.matchAt = os.clock()
	resetRound()
end

P.level = math.max(1, math.floor(tonumber(P.level) or 1))
P.exp = math.max(0, tonumber(P.exp) or 0)
local takeover = nil

local function gainExp(amount)
	P.exp += amount
	while P.exp >= P.level * 40 do
		P.exp -= P.level * 40
		P.level += 1
		say("levelUp", nil, { level = P.level })
	end
end

local function setPetScale(scale)
	petScale = scale
	petButton.Size = UDim2.fromOffset(PET_W * scale, PET_H * scale)
	applyPet()
end

local function endTakeover(ask)
	if not takeover then return end
	local shown = env.RivalsShown or {}
	for _, key in ipairs(FEATURE_ORDER) do cfg[key] = shown[key] end
	cfg.antiAimLevel = shown.antiAimLevel
	env.RivalsShown = nil
	takeover = nil
	for _, key in ipairs(FEATURE_ORDER) do watch.features[key] = cfg[key] == true end
	setPetScale(1)
	if ask then say("takeoverAsk") end
end

local function startTakeover()
	local shown = {}
	for _, key in ipairs(FEATURE_ORDER) do
		shown[key] = cfg[key]
		cfg[key] = true
	end
	shown.antiAimLevel = cfg.antiAimLevel
	cfg.antiAimLevel = 4
	env.RivalsShown = shown
	takeover = { roundAt = watch.roundAt, at = os.clock() }
	watch.tookOver = true
	watch.roundTookOver = true
	watch.roundLossStreak = 0
	watch.takeoverRound = watch.roundAt
	setPetScale(2)
	gainExp(15)
	say("takeoverBrag")
end

local function sendKills(kills)
	local url = env.RivalsLeaderboardUrl
	if type(url) ~= "string" or not url:find("^https://") or kills <= 0 then return end
	local req = request or http_request or (syn and syn.request) or (http and http.request)
	if type(req) ~= "function" then return end
	local okName, name = pcall(function() return game:GetService("Players").LocalPlayer.Name end)
	if not okName or type(name) ~= "string" then return end
	task.spawn(function()
		pcall(req, {
			Url = url .. "/kills", Method = "POST", Headers = { ["Content-Type"] = "application/json" },
			Body = game:GetService("HttpService"):JSONEncode({ name = name, kills = kills }),
		})
	end)
end

local function judgeRound()
	if not watch.roundTookOver and watch.roundKills + watch.roundDeaths > 0 then
		if watch.roundDeaths > watch.roundKills then
			watch.roundLossStreak += 1
		elseif watch.roundKills > watch.roundDeaths then
			watch.roundLossStreak = 0
		end
	end
	watch.roundKills, watch.roundDeaths, watch.roundTookOver = 0, 0, false
end

local function finishMatch()
	endTakeover(true)
	judgeRound()
	if not watch.tookOver then sendKills(watch.kills) end
	watch.tookOver = false
	gainExp(10 + 5 * watch.kills)
	local won, lost = watch.kills > watch.deaths, watch.kills < watch.deaths
	if won then
		watch.winStreak += 1
		watch.loseStreak = 0
	elseif lost then
		watch.loseStreak += 1
		watch.winStreak = 0
	end
	if watch.kills > 0 and watch.deaths == 0 and watch.taken == 0 then
		say("winFlawless")
	elseif won and math.random() < 0.4 then
		say("winRage")
	elseif lost and math.random() < 0.4 then
		say("loseRage")
	elseif won then
		sayFirst({ { "winStreak", watch.winStreak >= 2, watch.winStreak }, { "win", true } })
	elseif lost then
		sayFirst({ { "loseStreak", watch.loseStreak >= 2, watch.loseStreak }, { "lose", true } })
	elseif watch.kills > 0 then
		say("closeMatch")
	end
end

local function countSince(times, now, seconds)
	local count = 0
	for _, t in ipairs(times) do
		if now - t <= seconds then count += 1 end
	end
	return count
end

local function onKill(name, now)
	watch.kills += 1
	watch.roundKills += 1
	watch.killStreak += 1
	watch.deathStreak = 0
	watch.killsOn[name] = (watch.killsOn[name] or 0) + 1
	table.insert(watch.killTimes, now)
	if #watch.killTimes > 12 then table.remove(watch.killTimes, 1) end
	local record = lastHitOn(name)
	local info = record and record.info or {}
	local weapon = weaponKind(info.weaponName)
	local top = record ~= nil and record.damage ~= nil and record.best ~= nil and record.damage >= 0.9 * record.best
	local sinceStart = now - math.max(watch.roundAt, watch.lastDeathAt)
	local spoken = sayFirst({
		{ "tripleKill", countSince(watch.killTimes, now, 10) >= 3 },
		{ "tenKills", watch.kills == 10 },
		{ "doubleKill", countSince(watch.killTimes, now, 6) >= 2 },
		{ "killStreak5", watch.killStreak == 5 },
		{ "nearDeathSurvive", watch.lowest <= NEAR_DEATH },
		{ "clutchKill", watch.fraction > 0 and watch.fraction <= 0.2 },
		{ "flawless", watch.lifeTaken == 0 },
		{ "killStreak3", watch.killStreak == 3 },
		{ "firstBlood", watch.kills == 1 and watch.deaths == 0 },
		{ "sameTargetAgain", watch.killsOn[name] == 3, name },
	})
	if not spoken then
		sayAny({
			{ "longKill", info.distance ~= nil and info.distance >= 100, info.distance and string.format("%.0f", info.distance) },
			{ "wallKill", record ~= nil and not info.direct and not info.body },
			{ "closeKill", info.distance ~= nil and info.distance < 15 },
			{ "meleeEnemyKill", info.meleeSafe == true or info.escape == true },
			{ "shieldKill", info.flank == true },
			{ "sniperKill", weapon == "sniper" },
			{ "shotgunKill", weapon == "shotgun" },
			{ "pistolKill", weapon == "pistol" },
			{ "explosiveKill", weapon == "explosive" },
			{ "silentKill", info.silent == true },
			{ "bodyShotKill", info.body == true },
			{ "headshotKill", top },
			{ "quickKill", sinceStart <= 5 },
			{ "kill", true },
			{ "kill", true },
		})
	end
	if watch.killStreak >= 3 and math.random() < 0.5 then
		say("cursePraise")
	end
	watch.lastKillAt = now
	resetRound()
end

local function onDeath(text, now)
	watch.deaths += 1
	watch.roundDeaths += 1
	watch.deathStreak += 1
	watch.killStreak = 0
	if string.find(text, "급사", 1, true) and watch.target then
		local count = (watch.sudden[watch.target] or 0) + 1
		watch.sudden[watch.target] = count
		if count >= 4 then
			say("hackConfirm")
		elseif count >= 2 then
			say("hackSuspect")
		end
	end
	if watch.deathStreak >= 2 then
		say("curse")
	end
	local spoken = sayFirst({
		{ "tradeDeath", now - watch.lastKillAt <= 2 },
		{ "deathStreak3", watch.deathStreak >= 3 },
		{ "meleeDeath", now - watch.lastMeleeAt <= 3 },
		{ "quickDeath", now - math.max(watch.roundAt, watch.lastDeathAt) <= 8 },
		{ "desyncDeath", now - watch.lastDesyncAt <= 1 },
		{ "deathStreak2", watch.deathStreak == 2 },
	})
	if not spoken then
		sayAny({ { "death", true }, { "death", true }, { "suddenDeath", string.find(text, "급사", 1, true) ~= nil } })
	end
	watch.lastDeathAt = now
	resetRound()
end

local function handleEvent(entry)
	local kind = entry.kind
	local text = tostring(entry.text)
	local now = os.clock()
	watch.lastActivity = now
	if kind == "판 시작" then
		judgeRound()
		resetRound()
		watch.roundAt = now
		sayFirst({ { "matchStartAfterLoss", watch.loseStreak >= 1 }, { "matchStart", true } })
	elseif kind == "킬" then
		onKill(text, now)
	elseif kind == "피격" then
		watch.lifeTaken += 1
		watch.taken += 1
		watch.lastHurtAt = now
		table.insert(watch.chips, now)
		if #watch.chips > 10 then table.remove(watch.chips, 1) end
		local amount = tonumber(string.match(text, "^(%d+)")) or 0
		local left = tonumber(string.match(text, "남은 (%d+)"))
		if amount >= 50 and (left == nil or left > 0) then
			say("bigHit", amount)
		elseif amount >= 25 then
			say("dmgTaken", nil, { dmg = amount })
		elseif amount < 20 and countSince(watch.chips, now, 5) >= 3 then
			say("chipDamage")
		end
	elseif kind == "근접 위협" then
		watch.lastMeleeAt = now
		watch.meleeCount += 1
		sayFirst({ { "meleeSwarm", watch.meleeCount == 3 }, { "meleeNear", true } })
	elseif kind == "죽음" then
		onDeath(text, now)
	elseif kind == "대상" then
		local name = string.match(text, "^(.-) %(")
		if name then
			if watch.sudden[name] and watch.sudden[name] >= 2 then
				say("hackAgain", nil, { name = name })
			elseif watch.seen[name] and name ~= watch.target then
				say("enemyReturn", nil, { name = name })
			end
			watch.seen[name] = true
		end
		if string.find(text, "근접 무기라 먼저", 1, true) then
			say("meleePriority")
		elseif name and name ~= watch.target then
			sayFirst({ { "targetBehindWall", string.find(text, "벽 뒤", 1, true) ~= nil }, { "retarget", true, name } })
		end
		watch.target = name
	elseif kind == "디싱크" then
		watch.lastDesyncAt = now
		say("desyncStart")
	elseif kind == "안티에임 이상" then
		say("antiAimGlitch")
	elseif kind == "훅 오류" then
		say("hookError")
	end
end

local function watchHealth()
	local character = Players.LocalPlayer and Players.LocalPlayer.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid then return end
	local maxHealth = humanoid.MaxHealth
	if type(maxHealth) ~= "number" or maxHealth <= 0 or type(humanoid.Health) ~= "number" then return end
	local fraction = humanoid.Health / maxHealth
	watch.fraction = fraction
	if fraction <= 0 then return end
	local now = os.clock()
	if watch.hold then
		if fraction >= RECOVERED then watch.hold = false end
		watch.wasHurt, watch.lowSince = false, nil
		return
	end
	if fraction < 0.6 then
		watch.wasHurt = true
	elseif fraction >= 0.999 and watch.wasHurt then
		watch.wasHurt = false
		say("healed")
	end
	if watch.low and fraction <= NEAR_DEATH then
		watch.lowSince = watch.lowSince or now
		if now - watch.lowSince >= 15 then
			watch.lowSince = now
			say("lowHpStill")
		end
	else
		watch.lowSince = nil
	end
	if fraction < watch.lowest then watch.lowest = fraction end
	if fraction <= NEAR_DEATH and not watch.low then
		watch.low = true
		say("nearDeathWarn")
	elseif watch.low and fraction >= RECOVERED then
		watch.low = false
		say("nearDeathSurvive")
		watch.lowest = 1
	end
end

local function watchShots()
	local stats = env.RivalsStats
	if not stats or type(stats.hits) ~= "number" or type(stats.misses) ~= "number" then return end
	if watch.hits == nil or stats.hits < watch.hits or stats.misses < watch.misses then
		watch.hits, watch.misses = stats.hits, stats.misses
		return
	end
	local newMisses, newHits = stats.misses - watch.misses, stats.hits - watch.hits
	watch.hits, watch.misses = stats.hits, stats.misses
	watch.matchHits += newHits
	watch.matchMisses += newMisses
	if newMisses > 0 then
		watch.missStreak += newMisses
		watch.missRun += newMisses
		watch.hitStreak = 0
		watch.hitRun = 0
	end
	if newHits > 0 then
		watch.hitStreak += newHits
		watch.hitRun += newHits
		watch.missStreak = 0
		watch.missRun = 0
	end
	if watch.hitRun >= 10 then
		watch.hitRun = 0
		watch.hitStreak = 0
		say("hitStreak10")
	elseif watch.hitStreak >= 4 then
		watch.hitStreak = 0
		say("hitStreak")
	elseif watch.missRun >= 20 then
		watch.missRun = 0
		watch.missStreak = 0
		say("missStreak20")
	elseif watch.missStreak >= 8 then
		watch.missStreak = 0
		say("missStreak")
	elseif newHits > 0 then
		sayOnce("firstHit")
	end
	local finished = watch.matchHits + watch.matchMisses
	if finished >= 30 and watch.matchHits / finished >= 0.5 then
		sayOnce("accuracyHigh")
	elseif finished >= 40 and watch.matchHits / finished < 0.12 then
		sayOnce("accuracyLow")
	end
end

local function watchRecords()
	local stats = env.RivalsStats
	if not stats or type(stats.log) ~= "table" then return end
	local log = stats.log
	local shots = type(stats.shots) == "number" and stats.shots or #log
	if watch.shotsSeen == nil or shots < watch.shotsSeen then
		watch.shotsSeen = shots
		return
	end
	local fresh = math.min(shots - watch.shotsSeen, #log)
	watch.shotsSeen = shots
	local now = os.clock()
	for index = #log - fresh + 1, #log do
		local record = log[index]
		local info = record.info or {}
		watch.lastActivity = now
		local weapon = info.weaponName
		if weapon and weapon ~= watch.weapon then
			local before = watch.weapon
			watch.weapon = weapon
			if before ~= nil then
				local kind = weaponKind(weapon)
				sayFirst({
					{ "sniperOut", kind == "sniper" }, { "shotgunOut", kind == "shotgun" }, { "explosiveOut", kind == "explosive" },
					{ "weaponSwitch", true, weapon },
				})
			end
		end
		if info.invincible then say("invincibleTarget") end
		if info.block == "deflect" then
			say("deflectSeen")
		elseif info.block then
			say("shieldBlocked")
		end
		if info.escape then say("meleeEscape") end
		if info.distance and info.distance < 10 then say("closeTarget") end
		if info.distance and info.distance >= 100 and record.result == "pending" then
			watch.lastDist = info.distance
			say("hitFar")
		end
		table.insert(watch.pendingRecords, record)
	end
	local keep = {}
	for _, record in ipairs(watch.pendingRecords) do
		if record.result == "pending" then
			if #keep < 400 then table.insert(keep, record) end
		elseif record.result == "hit" then
			local info = record.info or {}
			sayFirst({
				{ "bigDamage", record.damage ~= nil and record.best ~= nil and record.damage >= 50 and record.damage >= 0.9 * record.best, record.damage and string.format("%.0f", record.damage) },
				{ "longShot", info.distance ~= nil and info.distance >= 120, info.distance and string.format("%.0f", info.distance) },
				{ "bodyShot", info.body == true },
				{ "silentHit", info.silent == true },
				{ "wallHit", not info.direct },
			})
		end
	end
	watch.pendingRecords = keep
end

local function watchConfig()
	local now = os.clock()
	local isOpen = cfg.menuOpen == true
	if takeover then
		watch.open = isOpen
		return
	end
	if isOpen and not watch.open then
		watch.menuAt = now
		say("open")
	elseif not isOpen and watch.open then
		watch.menuAt = nil
		say("menuClose")
	end
	local changed, lastKey, count = false, nil, 0
	for _, key in ipairs(FEATURE_ORDER) do
		local value = cfg[key] == true
		local before = watch.features[key]
		watch.features[key] = value
		if isOpen and watch.open and before ~= nil and before ~= value then
			changed, lastKey, count = true, key, count + 1
		end
	end
	if changed then
		local aimOff = not cfg.rage and not cfg.silent and not cfg.autoFire and not cfg.triggerbot
		local allOn = true
		for _, key in ipairs(FEATURE_ORDER) do
			if cfg[key] ~= true then allOn = false end
		end
		local value = cfg[lastKey] == true
		sayFirst({
			{ "allOff", aimOff and not value },
			{ "allOn", allOn and count >= 2 },
			{ "espOff", lastKey == "esp" and not value },
			{ value and "toggleOn" or "toggleOff", true, FEATURE_LABELS[lastKey] },
		})
		watch.menuAt = now
	elseif isOpen and watch.open and watch.menuAt and now - watch.menuAt >= 30 then
		say("menuLongOpen")
	end
	local level = math.floor(tonumber(cfg.antiAimLevel) or 1)
	if watch.level ~= nil and level ~= watch.level then
		sayFirst({ { "antiAimMax", level == 4 }, { "antiAimLevel", true, LEVEL_NAMES[level] or tostring(level) } })
	end
	watch.level = level
	local chatter = P.chatter or 2
	if watch.chatter ~= nil and chatter == 3 and watch.chatter ~= 3 then say("chatterMax") end
	watch.chatter = chatter
	watch.open = isOpen
end

local function watchBackground()
	local antiAim = env.RivalsAntiAimStats
	if type(antiAim) == "table" and type(antiAim.sinkTime) == "number" and type(antiAim.shieldTime) == "number" then
		if watch.sink == nil or antiAim.sinkTime < watch.sink then watch.sink = antiAim.sinkTime end
		if watch.shield == nil or antiAim.shieldTime < watch.shield then watch.shield = antiAim.shieldTime end
		if antiAim.sinkTime - watch.sink >= 10 then
			watch.sink = antiAim.sinkTime
			say("sinking")
		end
		if antiAim.shieldTime - watch.shield >= 5 then
			watch.shield = antiAim.shieldTime
			say("shieldFacing")
		end
	end
	local trigger = env.RivalsTrigger
	if type(trigger) == "table" and type(trigger.hits) == "number" then
		if watch.triggerHits ~= nil and trigger.hits > watch.triggerHits then say("triggerFire") end
		watch.triggerHits = trigger.hits
	end
end

local function watchTime()
	local now = os.clock()
	local hour = hourNow()
	if hour and hour < 5 then say("nightOwl") end
	local minutes = (now - watch.started) / 60
	if minutes >= 60 then say("longSession", tostring(math.floor(minutes))) end
	if (P.chatter or 2) >= 3 and now >= watch.nextTalk then
		watch.nextTalk = now + 120 + math.random(90)
		local finished = watch.matchHits + watch.matchMisses
		local acc = finished > 0 and 100 * watch.matchHits / finished or 0
		sayAny({
			{ "smallTalkKill", watch.kills > 0, { kills = watch.kills } },
			{ "smallTalkDeath", watch.deaths > 0, { deaths = watch.deaths } },
			{ "smallTalkAcc", finished >= 10 },
			{ "smallTalkPing", true },
			{ "smallTalkMatch", true },
			{ "smallTalkSelf", true },
			{ "confidence", finished >= 5 and acc >= 60 },
			{ "doubt", finished >= 10 and acc < 30 },
		})
	end
	if watch.matchId ~= nil then
		if takeover and (watch.roundAt ~= takeover.roundAt or now - takeover.at >= 240) then endTakeover(true) end
		local needed = 3
		if not takeover and (watch.deaths - watch.kills >= needed or watch.roundLossStreak >= 3) and watch.takeoverRound ~= watch.roundAt then startTakeover() end
		if watch.deaths - watch.kills >= 2 and not cfg.rage and not takeover then say("suggestRage") end
		if watch.deaths >= 3 and not cfg.antiAim then say("suggestAntiAim") end
		if watch.deaths >= 3 and cfg.antiAim and math.floor(tonumber(cfg.antiAimLevel) or 1) <= 2 then say("suggestAntiAimLevel") end
		if watch.kills >= 1 and now - math.max(watch.lastHurtAt, watch.matchAt) >= 90 then say("untouched") end
		if now - watch.matchAt >= 300 then say("matchLong") end
		if watch.lastActivity > 0 and now - watch.lastActivity >= 120 then say("idleLong") end
	end
end

local function poll()
	local events = env.RivalsEvents
	if events and events.list then
		if events.id ~= watch.matchId or watch.cursor > #events.list then
			if watch.matchId ~= nil then finishMatch() end
			watch.matchId = events.id
			watch.matchCount += 1
			watch.cursor = 0
			resetMatch()
		end
		local list = events.list
		for index = watch.cursor + 1, #list do
			handleEvent(list[index])
		end
		watch.cursor = #list
	end
	watchHealth()
	watchShots()
	watchRecords()
	watchConfig()
	watchBackground()
	local now = os.clock()
	if (P.chatter or 2) >= 3 then
		if watch.nextIdle == 0 then
			watch.nextIdle = now + 50 + math.random(40)
		elseif now >= watch.nextIdle then
			watch.nextIdle = now + 50 + math.random(40)
			say("idle")
		end
	end
	watchTime()
end

petButton.InputBegan:Connect(function(input)
	if pressed(input) and not drag then
		local position = input.Position
		drag = { px = position.X, py = position.Y, x0 = pos.x, y0 = pos.y, moved = false }
	end
end)

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if not drag or not moving(input) then return end
	local position = input.Position
	local dx, dy = position.X - drag.px, position.Y - drag.py
	if not drag.moved and math.abs(dx) + math.abs(dy) < 5 then return end
	drag.moved = true
	pos.x = drag.x0 + dx
	pos.y = drag.y0 + dy
	applyPet()
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if not drag or not pressed(input) then return end
	local dragged = drag.moved
	drag = nil
	if dragged then
		P.x, P.y = pos.x, pos.y
		touch()
		say("petMoved")
	else
		if menu and menu.Toggle then menu.Toggle() end
		local now = os.clock()
		table.insert(watch.pokes, now)
		if #watch.pokes > 6 then table.remove(watch.pokes, 1) end
		sayFirst({ { "pokeSpam", countSince(watch.pokes, now, 6) >= 5 }, { "poke", true } })
	end
end))

local clock, slow = 0, 0
local lastWidth, lastHeight = viewport()
table.insert(connections, RunService.Heartbeat:Connect(function(dt)
	clock += dt or 0
	slow += dt or 0
	if slow < 0.1 then return end
	local step = slow
	slow = 0
	gui.Enabled = P.show == true
	if not gui.Enabled then return end
	local now = os.clock()
	if bubble.Visible and now >= hideAt then
		hideBubble()
	end
	if hop > 0 then hop = math.max(0, hop - step * 3) end
	bobOffset = math.sin(clock * 2.4) * 2 - math.sin(hop * math.pi) * 10
	petButton.Position = UDim2.fromOffset(pos.x, pos.y + bobOffset)
	local width, height = viewport()
	if width ~= lastWidth or height ~= lastHeight then
		lastWidth, lastHeight = width, height
		applyPet()
	end
end))

local pollClock = 0
table.insert(connections, RunService.Heartbeat:Connect(function(dt)
	pollClock += dt or 0
	if pollClock < 0.25 then return end
	pollClock = 0
	poll()
end))

placePet()
for _, key in ipairs(FEATURE_ORDER) do
	watch.features[key] = cfg[key] == true
end
watch.open = cfg.menuOpen == true
local startEvents = env.RivalsEvents
if startEvents and startEvents.list then
	watch.matchId = startEvents.id
	watch.cursor = #startEvents.list
end
watch.matchAt = os.clock()
do
	local hour = hourNow()
	sayFirst({
		{ "greetMorning", hour ~= nil and hour >= 5 and hour < 11 },
		{ "greetNight", hour ~= nil and (hour >= 23 or hour < 5) },
		{ "greet", true },
	})
end

env.RivalsPet = {
	gui = gui,
	position = pos,
	settings = P,
	Say = function(_, name, extra) return say(name, extra) end,
	Situations = SITUATIONS,
	Decode = b64decode,
	Soften = soften,
	ResetPosition = function()
		P.x, P.y = nil, nil
		placePet()
		touch()
	end,
}

env.RivalsPetUnload = function()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	env.RivalsPet = nil
	gui:Destroy()
end

end)
