if _G.MM2ValuesCleanup then
	pcall(_G.MM2ValuesCleanup)
end

local alive = true
local enabled = true
_G.MM2ValuesCleanup = function()
	alive = false
	enabled = false
end

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local RAW_JSON_URL = "https://raw.githubusercontent.com/Namedadude/Supreme-Values-MM2-Scraper/refs/heads/main/scraper/values.json?nocache=" .. tostring(math.random(1, 1000000))

local DatabaseExact = {}
local DatabaseByName = {}
local DatabaseSingle = {}
local valueSource = "none"

local Sync = nil
local syncAssetIndex = {}
local syncNameIndex = {}
local syncIdIndex = {}
local syncKeyIndex = {}
local indexBuilt = false

local detailsCache = {}
local valueCache = {}
local createdLabels = {}
local titleState = { yourBase = nil, yourTitle = nil }

local function cleanString(s)
	if not s then return "" end
	s = tostring(s):lower()
	s = s:gsub("[\194\160\160\226\128\139\239\187\191]", " ")
	s = s:gsub("^%s+", ""):gsub("%s+$", "")
	s = s:gsub("[\226\128\153\226\128\152`]", "'")
	s = s:gsub("’", "'"):gsub("`", "'")
	s = s:gsub("%s*%b()", ""):gsub("%s*%b[]", "")
	s = s:gsub("%s*x%s*%d+$", "")
	s = s:gsub("^%s*%d+%s*x%s+", "")
	s = s:gsub("%s+knife$", ""):gsub("%s+gun$", ""):gsub("%s+pistol$", ""):gsub("%s+revolver$", ""):gsub("%s+pet$", "")
	s = s:gsub("^%s+", ""):gsub("%s+$", "")
	s = s:gsub("(%a)%s+(%d+)", "%1%2")
	s = s:gsub("%-", "")

	return s
end

local function getWordVariations(base)
	local vars = { base }
	local no_space = base:gsub("%s+", "")
	if no_space ~= base then
		table.insert(vars, no_space)
	end

	local len = #base
	if base:match("ies$") and len > 3 then
		table.insert(vars, base:sub(1, -4) .. "y")
	elseif base:match("y$") and len > 1 then
		table.insert(vars, base:sub(1, -2) .. "ies")
	end

	if base:match("ves$") and len > 3 then
		table.insert(vars, base:sub(1, -4) .. "f")
		table.insert(vars, base:sub(1, -4) .. "fe")
	elseif base:match("fe$") and len > 2 then
		table.insert(vars, base:sub(1, -3) .. "ves")
	elseif base:match("f$") and len > 1 then
		table.insert(vars, base:sub(1, -2) .. "ves")
	end

	if base:match("es$") and len > 2 then
		table.insert(vars, base:sub(1, -3))
		table.insert(vars, base:sub(1, -2))
	elseif base:match("[cs]h$") or base:match("[xsz]$") then
		table.insert(vars, base .. "es")
	end

	if base:match("s$") and not base:match("ss$") and len > 1 then
		table.insert(vars, base:sub(1, -2))
	elseif not base:match("s$") then
		table.insert(vars, base .. "s")
	end

	local res = {}
	local seen = {}
	for _, v in ipairs(vars) do
		if v ~= "" and not seen[v] then
			seen[v] = true
			table.insert(res, v)
		end
	end
	return res
end

local function httpGet(url)
	local ok, res = pcall(function()
		local fn = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
		if fn then
			local response = fn({ Url = url, Method = "GET" })
			if type(response) == "table" then
				return response.Body or response.body
			end
			return response
		else
			return game:HttpGet(url)
		end
	end)
	if ok and type(res) == "string" and #res > 10 then
		return res
	end
	return nil
end

local function loadLiveValues()
	local body = httpGet(RAW_JSON_URL)
	if not body then
		valueSource = "failed"
		return false
	end
	local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
	if not ok or type(data) ~= "table" then
		valueSource = "failed"
		return false
	end
	local items = data.items or data
	if type(items) ~= "table" then
		valueSource = "failed"
		return false
	end

	DatabaseExact = {}
	DatabaseByName = {}
	DatabaseSingle = {}
	local count = 0

	for key, info in pairs(items) do
		if type(info) == "table" then
			local valStr = tostring(info.value or "N/A")
			local num = tonumber(info.numericValue)
			if not num then
				local clean = valStr:gsub(",", "")
				num = tonumber(clean)
			end
			if not num or valStr:lower():match("^x") or valStr:lower():match("t1") then
				num = 0
			end

			local entry = {
				key = tostring(key):lower(),
				name = info.name or tostring(key),
				value = valStr,
				val = num,
				stability = info.stability,
				demand = info.demand,
				type = info.type and tostring(info.type):lower() or "unknown",
				rarity = info.rarity and tostring(info.rarity):lower() or "unknown",
				year = info.year and tonumber(info.year) or nil,
				tier = info.tier,
				isChroma = (info.isChroma == true) or (tostring(info.rarity):lower() == "chroma") or tostring(key):lower():find("^chroma") ~= nil
			}

			local keyLower = tostring(key):lower():gsub("’", "'")
			DatabaseExact[keyLower] = entry

			local base = cleanString(entry.name)
			if base ~= "" then
				if entry.year then
					DatabaseExact[base .. tostring(entry.year)] = entry
					DatabaseExact[base .. " " .. tostring(entry.year)] = entry
					DatabaseExact[base .. " (" .. tostring(entry.year) .. ")"] = entry
				end
				if not DatabaseByName[base] then
					DatabaseByName[base] = {}
				end
				table.insert(DatabaseByName[base], entry)

				for _, var in ipairs(getWordVariations(base)) do
					if var ~= base then
						if not DatabaseByName[var] then
							DatabaseByName[var] = {}
						end
						table.insert(DatabaseByName[var], entry)
					end
				end
			end

			local rawNameClean = cleanString(info.name)
			if rawNameClean ~= "" and rawNameClean ~= base then
				if not DatabaseByName[rawNameClean] then
					DatabaseByName[rawNameClean] = {}
				end
				table.insert(DatabaseByName[rawNameClean], entry)

				for _, var in ipairs(getWordVariations(rawNameClean)) do
					if var ~= rawNameClean then
						if not DatabaseByName[var] then
							DatabaseByName[var] = {}
						end
						table.insert(DatabaseByName[var], entry)
					end
				end
			end

			count = count + 1
		end
	end

	for base, list in pairs(DatabaseByName) do
		if #list == 1 then
			DatabaseSingle[base] = list[1]
		end
	end

	if count < 1 then
		valueSource = "failed"
		return false
	end

	valueSource = "live (" .. tostring(count) .. ")"
	return true
end

local loaded = loadLiveValues()
print("[TradeValues] values: " .. tostring(valueSource))

local function indexSyncItem(itemData, itemKey, bagName)
	if type(itemData) ~= "table" then return end
	itemData.BagName = bagName
	itemData.SyncKey = itemKey

	local img = itemData.Image
	if img and type(img) == "string" then
		local lImg = img:lower()
		local id = lImg:match("[?&]assetid=(%d+)") or lImg:match("[?&]id=(%d+)") or lImg:match("rbxassetid://(%d+)") or lImg:match("id=(%d+)") or lImg:match("(%d+)")
		if id then
			local numId = tonumber(id)
			if numId then
				syncAssetIndex[numId] = itemData
			end
		end
	end

	local cId = itemData.ItemID or itemData.id or itemKey
	if cId then
		syncIdIndex[tostring(cId):lower()] = itemData
		local numId = tonumber(cId)
		if numId then
			syncAssetIndex[numId] = itemData
		end
	end

	local cName = itemData.ItemName or itemData.Name or itemData.DisplayName or itemKey
	if cName then
		local clean = cleanString(tostring(cName))
		if clean ~= "" then
			syncNameIndex[clean] = itemData
		end
	end

	if itemKey then
		syncKeyIndex[tostring(itemKey):lower()] = itemData
	end
end

local function buildSyncAssetIndex()
	if not Sync then return end
	syncAssetIndex = {}
	syncNameIndex = {}
	syncIdIndex = {}
	syncKeyIndex = {}

	for bagName, bag in pairs(Sync) do
		if type(bag) == "table" then
			local isSubTableOfItems = false
			for k, v in pairs(bag) do
				if type(v) == "table" then
					isSubTableOfItems = true
					indexSyncItem(v, k, tostring(bagName))
				end
			end
			if not isSubTableOfItems and (bag.Image or bag.ItemID or bag.ItemName) then
				indexSyncItem(bag, bagName, "Items")
			end
		end
	end
	indexBuilt = true
end

task.spawn(function()
	local ok, mod = pcall(function()
		local root = ReplicatedStorage:FindFirstChild("ReplicatedStorage") or ReplicatedStorage
		local db = root:FindFirstChild("Database") or root:WaitForChild("Database", 5)
		if not db then return nil end
		local syncMod = db:FindFirstChild("Sync") or db:WaitForChild("Sync", 5)
		if not syncMod then return nil end
		return require(syncMod)
	end)
	if ok and mod then
		Sync = mod
		pcall(buildSyncAssetIndex)
	end
end)

local function findItemId(slot)
	if not slot then return nil end
	local id = slot:GetAttribute("ItemID") or slot:GetAttribute("ID") or slot:GetAttribute("ItemId")
	if id then return tostring(id) end

	for _, name in ipairs({ "ItemID", "ID", "ItemId", "WeaponID" }) do
		local v = slot:FindFirstChild(name, true)
		if v and v:IsA("ValueBase") then return tostring(v.Value) end
	end

	local sName = slot.Name
	local sLower = sName:lower()
	if sLower ~= "item" and sLower ~= "newitem" and sLower ~= "container" and sLower ~= "slot" and sLower ~= "template" and sLower ~= "gun" and sLower ~= "knife" and not sName:match("^%d+$") then
		return sName
	end
	return nil
end

local function findItemIdByIcon(slot)
	if not slot then return nil end
	local icon = slot:FindFirstChild("Icon", true) or slot:FindFirstChild("ItemIcon", true)
	if not icon or not icon:IsA("ImageLabel") then return nil end
	local img = icon.Image
	if not img or img == "" then return nil end
	local lImg = img:lower()
	local id = lImg:match("[?&]assetid=(%d+)") or lImg:match("[?&]id=(%d+)") or lImg:match("rbxassetid://(%d+)") or lImg:match("id=(%d+)") or lImg:match("(%d+)")
	if id then return tonumber(id) end
	return nil
end

local function getItemDetails(slot, displayName)
	if not indexBuilt and Sync then
		pcall(buildSyncAssetIndex)
	end

	local assetId = findItemIdByIcon(slot)
	local slotPath = slot and (slot.Parent and slot.Parent.Name .. "/" .. slot.Name or slot.Name) or ""
	local dKey = tostring(assetId or "nil") .. "_" .. tostring(displayName or "") .. "_" .. slotPath
	if detailsCache[dKey] then
		local cached = detailsCache[dKey]
		if cached.fromSync or not Sync then
			return cached.englishName, cached.rarity, cached.itemType, cached.isChroma, cached.year
		end
	end

	local itemId = findItemId(slot)
	local data = nil

	if assetId and syncAssetIndex[assetId] then
		data = syncAssetIndex[assetId]
	end

	if not data and itemId then
		local idLower = tostring(itemId):lower()
		data = syncIdIndex[idLower] or syncKeyIndex[idLower] or syncNameIndex[idLower]
	end

	if not data and displayName then
		local cleanDisp = cleanString(displayName)
		if cleanDisp ~= "" then
			data = syncNameIndex[cleanDisp] or syncKeyIndex[cleanDisp]
		end
	end

	if not data and assetId and Sync then
		for offset = -15, 15 do
			local candidate = syncAssetIndex[assetId + offset]
			if candidate then
				local cName = candidate.ItemName or candidate.Name or candidate.DisplayName or candidate.SyncKey
				if cName and displayName and cleanString(cName) == cleanString(displayName) then
					data = candidate
					break
				end
			end
		end
	end

	local englishName, rarity, itemType, year = nil, nil, nil, nil
	local isChroma = false

	if data then
		englishName = data.ItemName or data.Name or data.DisplayName or data.SyncKey
		rarity = data.Rarity

		local rawType = tostring(data.ItemType or data.Type or ""):lower()
		if rawType == "weapon skin" or rawType == "weapon" then
			itemType = "weapon skin"
		elseif rawType == "misc" then
			itemType = "misc"
		elseif rawType:find("emote") or rawType:find("toy") or rawType:find("radio") or rawType:find("effect") or rawType:find("perk") or rawType:find("power") or rawType:find("ability") or rawType:find("bundle") or rawType:find("box") then
			itemType = "untradable"
		elseif rawType ~= "" then
			itemType = rawType
		end

		local bag = data.BagName
		if bag then
			local bLower = bag:lower()
			if bLower:find("pet") or bLower == "walking" or bLower:find("egg") then
				itemType = "pet"
			elseif bLower:find("emote") or bLower:find("toy") or bLower:find("effect") or bLower:find("power") or bLower:find("ability") or bLower:find("perk") or bLower:find("skill") or bLower:find("radio") or bLower:find("box") or bLower:find("bundle") or bLower:find("material") or bLower:find("currenc") or bLower:find("recipe") or bLower:find("badge") or bLower:find("nametag") then
				if itemType ~= "misc" then
					itemType = "untradable"
				end
			elseif bLower:find("knife") or bLower:find("knives") then
				itemType = "knife"
			elseif bLower:find("gun") or bLower:find("guns") then
				itemType = "gun"
			end
		end

		local dataId = tostring(data.ItemID or data.id or data.SyncKey or ""):lower()
		if itemType ~= "untradable" and itemType ~= "misc" then
			if dataId:find("_gun") or dataId:find("_g$") or dataId:find("gun") then
				itemType = "gun"
			elseif dataId:find("_knife") or dataId:find("_k$") or dataId:find("knife") then
				itemType = "knife"
			end
		end

		local extractedYear = data.Year
		if not extractedYear then
			for _, keyName in ipairs({ "Event", "Season", "ItemID", "id", "ItemName", "Name", "DisplayName", "SyncKey" }) do
				local val = data[keyName]
				if val then
					local y = tostring(val):match("(20%d%d)")
					if y then
						extractedYear = tonumber(y)
						break
					end
				end
			end
		end
		year = extractedYear

		if dataId:find("chroma") and not dataId:find("chromatic") then
			isChroma = true
		end
	end

	if not englishName then
		englishName = displayName
	end

	if (not itemType or itemType == "weapon skin" or itemType == "weapon" or itemType == "unknown") and itemId then
		local idLower = tostring(itemId):lower()
		if idLower:find("_gun") or idLower:find("_g$") or idLower:find("gun") then
			itemType = "gun"
		elseif idLower:find("_knife") or idLower:find("_k$") or idLower:find("knife") then
			itemType = "knife"
		end
	end

	if slot then
		local current = slot
		local depth = 0
		local ancestorType = nil
		while current and current ~= game and depth < 15 do
			depth = depth + 1
			local name = current.Name:lower()
			if name:find("emote") or name:find("toy") or name:find("radio") or name:find("effect") or name:find("perk") or name:find("power") or name:find("ability") then
				ancestorType = "untradable"
				break
			elseif name:find("pet") then
				ancestorType = "pet"
				break
			elseif name == "gun" or name == "guns" or name == "items2" or name == "inventory2" then
				if not ancestorType then ancestorType = "gun" end
			elseif name == "knife" or name == "knives" then
				if not ancestorType then ancestorType = "knife" end
			elseif name == "weapons" then
				if not ancestorType then ancestorType = "weapon skin" end
			end
			current = current.Parent
		end

		if ancestorType == "untradable" then
			itemType = "untradable"
		elseif ancestorType and (not itemType or itemType == "weapon skin" or itemType == "weapon" or itemType == "unknown") then
			itemType = ancestorType
		end
	end

	if (not itemType or itemType == "weapon skin" or itemType == "weapon" or itemType == "unknown") and englishName then
		local lowerName = englishName:lower()
		if lowerName:find("%(gun%)") or lowerName:find("%s+gun$") or lowerName:find("pistol") or lowerName:find("revolver") or lowerName:find("luger") or lowerName:find("blaster") then
			itemType = "gun"
		elseif lowerName:find("%(knife%)") or lowerName:find("%s+knife$") or lowerName:find("scythe") or lowerName:find("blade") or lowerName:find("dagger") or lowerName:find("axe") or lowerName:find("sword") then
			itemType = "knife"
		elseif lowerName:find("pet") then
			itemType = "pet"
		end
	end

	if (not rarity or rarity == "" or rarity == "unknown") and slot then
		local slotRarity = slot:GetAttribute("Rarity") or slot:FindFirstChild("Rarity", true)
		if slotRarity then
			if typeof(slotRarity) == "Instance" and slotRarity:IsA("ValueBase") then
				rarity = tostring(slotRarity.Value):lower()
			else
				rarity = tostring(slotRarity):lower()
			end
		end
	end

	if itemType == "weapon skin" or itemType == "weapon" then
		itemType = "unknown"
	end

	if slot then
		local function checkChromaTag(p)
			if not p then return false end
			for _, c in pairs(p:GetChildren()) do
				if c:IsA("GuiObject") and c.Visible then
					local cName = c.Name:lower()
					if cName:find("chroma") or cName:find("хрома") then return true end
					if c:IsA("TextLabel") and (c.Text:lower():find("chroma") or c.Text:lower():find("хрома")) then return true end
				end
			end
			return false
		end
		local tagsFrame = slot:FindFirstChild("Tags", true)
		if checkChromaTag(tagsFrame) or checkChromaTag(slot:FindFirstChild("Container")) or checkChromaTag(slot) then
			isChroma = true
		end
	end

	local dispLower = displayName and tostring(displayName):lower() or ""
	if dispLower:find("chroma") or dispLower:find("хрома") then
		isChroma = true
	end

	if englishName then englishName = tostring(englishName) end
	if rarity then rarity = tostring(rarity):lower() end
	if isChroma and englishName and not englishName:lower():find("^chroma") then
		englishName = "Chroma " .. englishName
	end

	if englishName and cleanString(englishName) == "scratch" then
		local idStr = itemId and tostring(itemId):lower() or ""
		local slotName = slot and slot.Name:lower() or ""
		if idStr:find("blue") or slotName:find("blue") then
			englishName = "Blue Scratch"
		elseif idStr:find("red") or slotName:find("red") then
			englishName = "Red Scratch"
		end
	end

	detailsCache[dKey] = {
		englishName = englishName,
		rarity = rarity,
		itemType = itemType,
		isChroma = isChroma,
		year = year,
		fromSync = (Sync ~= nil)
	}

	return englishName, rarity, itemType, isChroma, year
end

local function smartMatchDatabase(englishName, itemType, rarity, year, isChroma)
	if not englishName or englishName == "" then return nil end

	local cleanName = tostring(englishName):lower():gsub("’", "'"):gsub("^%s+", ""):gsub("%s+$", "")
	
	if DatabaseExact[cleanName] then
		local match = DatabaseExact[cleanName]
		if not (itemType and (itemType == "knife" or itemType == "gun") and match.type == "pet") then
			return match
		end
	end

	local base = cleanString(cleanName)
	if base == "" then return nil end

	if DatabaseExact[base] then
		local match = DatabaseExact[base]
		if not (itemType and (itemType == "knife" or itemType == "gun") and match.type == "pet") then
			return match
		end
	end

	if year and DatabaseExact[base .. tostring(year)] then
		local match = DatabaseExact[base .. tostring(year)]
		if not (itemType and (itemType == "knife" or itemType == "gun") and match.type == "pet") then
			return match
		end
	end

	if DatabaseSingle[base] then
		local match = DatabaseSingle[base]
		if not (itemType and (itemType == "knife" or itemType == "gun") and match.type == "pet") then
			if not isChroma or match.isChroma then
				return match
			end
		end
	end

	local candidates = DatabaseByName[base]
	if not candidates or #candidates == 0 then
		for _, var in ipairs(getWordVariations(base)) do
			if DatabaseByName[var] and #DatabaseByName[var] > 0 then
				candidates = DatabaseByName[var]
				break
			end
		end
	end

	if candidates and #candidates > 0 then
		if #candidates == 1 then
			return candidates[1]
		end

		local pool = candidates

		if isChroma then
			local chromaPool = {}
			for _, c in ipairs(pool) do
				if c.isChroma or c.rarity == "chroma" or c.key:find("^chroma") then
					table.insert(chromaPool, c)
				end
			end
			if #chromaPool > 0 then pool = chromaPool end
		else
			local nonChromaPool = {}
			for _, c in ipairs(pool) do
				if not c.isChroma and c.rarity ~= "chroma" and not c.key:find("^chroma") then
					table.insert(nonChromaPool, c)
				end
			end
			if #nonChromaPool > 0 then pool = nonChromaPool end
		end

		if #pool == 1 then return pool[1] end

		if year then
			local yr = tonumber(year)
			if yr then
				local yearPool = {}
				for _, c in ipairs(pool) do
					if c.year == yr then
						table.insert(yearPool, c)
					end
				end
				if #yearPool > 0 then pool = yearPool end
			end
		end

		if #pool == 1 then return pool[1] end

		if rarity and rarity ~= "" and rarity ~= "unknown" then
			local rLower = tostring(rarity):lower()
			local rarPool = {}
			for _, c in ipairs(pool) do
				if c.rarity == rLower then
					table.insert(rarPool, c)
				end
			end
			if #rarPool > 0 then pool = rarPool end
		end

		if #pool == 1 then return pool[1] end

		if itemType and itemType ~= "" and itemType ~= "unknown" and itemType ~= "weapon" and itemType ~= "weapon skin" then
			local tLower = tostring(itemType):lower()
			local exactTypePool = {}
			local unknownTypePool = {}
			for _, c in ipairs(pool) do
				if c.type == tLower then
					table.insert(exactTypePool, c)
				elseif c.type == "unknown" then
					table.insert(unknownTypePool, c)
				end
			end
			if #exactTypePool > 0 then
				pool = exactTypePool
			elseif #unknownTypePool > 0 then
				pool = unknownTypePool
			end
		end

		if #pool == 1 then return pool[1] end

		local noTrophies = {}
		for _, c in ipairs(pool) do
			if (c.val or 0) < 100000 then
				table.insert(noTrophies, c)
			end
		end
		if #noTrophies > 0 and #noTrophies < #pool then
			pool = noTrophies
		end

		if #pool == 1 then return pool[1] end

		local firstVal = pool[1].value
		local allSame = true
		for i = 2, #pool do
			if pool[i].value ~= firstVal then
				allSame = false
				break
			end
		end
		if allSame then return pool[1] end

		return pool[1]
	end

	local types = {}
	if itemType and itemType ~= "unknown" and itemType ~= "weapon skin" and itemType ~= "weapon" then
		table.insert(types, itemType)
	else
		table.insert(types, "knife")
		table.insert(types, "gun")
	end

	local baseVars = getWordVariations(base)
	for _, b in ipairs(baseVars) do
		for _, t in ipairs(types) do
			if year and rarity then
				local k = b .. " (" .. t .. ") (" .. rarity .. ") (" .. tostring(year) .. ")"
				if DatabaseExact[k] then return DatabaseExact[k] end
			end
			if rarity then
				local k = b .. " (" .. t .. ") (" .. rarity .. ")"
				if DatabaseExact[k] then return DatabaseExact[k] end
			end
			if year then
				local k = b .. " (" .. t .. ") (" .. tostring(year) .. ")"
				if DatabaseExact[k] then return DatabaseExact[k] end
			end
			local k = b .. " (" .. t .. ")"
			if DatabaseExact[k] then return DatabaseExact[k] end
		end

		if year and rarity then
			local k = b .. " (" .. rarity .. ") (" .. tostring(year) .. ")"
			if DatabaseExact[k] then return DatabaseExact[k] end
		end
		if rarity then
			local k = b .. " (" .. rarity .. ")"
			if DatabaseExact[k] then return DatabaseExact[k] end
		end
		if year then
			local k = b .. " (" .. tostring(year) .. ")"
			if DatabaseExact[k] then return DatabaseExact[k] end
		end
	end

	return nil
end

local function lookupDisplayAndNumericValue(displayName, slot)
	local assetId = findItemIdByIcon(slot)
	local slotPath = slot and (slot.Parent and slot.Parent.Name .. "/" .. slot.Name or slot.Name) or ""
	local cacheKey = tostring(displayName) .. "_" .. tostring(assetId or "nil") .. "_" .. slotPath
	if valueCache[cacheKey] then
		local cached = valueCache[cacheKey]
		if cached.fromSync or not Sync then
			return cached.disp, cached.val, cached.stability, cached.tier
		end
	end

	local englishName, rarity, itemType, isChroma, year = getItemDetails(slot, displayName)
	if isChroma then
		rarity = "chroma"
	end

	if not englishName or englishName == "" then
		if Sync ~= nil and assetId ~= nil then
			valueCache[cacheKey] = { disp = "N/A", val = 0, stability = "N/A", tier = nil, fromSync = true }
		end
		return "N/A", 0, "N/A", nil
	end

	if itemType and (itemType == "emote" or itemType == "effect" or itemType == "perk" or itemType == "untradable" or itemType == "power" or itemType == "ability" or itemType == "skill" or itemType == "radio" or itemType == "toy" or itemType == "toys" or itemType == "mysterybox" or itemType == "itembundle") then
		valueCache[cacheKey] = { disp = nil, val = 0, stability = nil, tier = nil, fromSync = (Sync ~= nil) }
		return nil, 0, nil, nil
	end

	local match = smartMatchDatabase(englishName, itemType, rarity, year, isChroma)
	if match then
		valueCache[cacheKey] = { disp = match.value, val = match.val or 0, stability = match.stability, tier = match.tier, fromSync = (Sync ~= nil) }
		return match.value, match.val or 0, match.stability, match.tier
	end

	if Sync ~= nil and assetId ~= nil then
		valueCache[cacheKey] = { disp = "N/A", val = 0, stability = "N/A", tier = nil, fromSync = true }
	end
	return "N/A", 0, "N/A", nil
end

local function fmt(v)
	if not v or v == 0 then return "0" end
	local sign = v < 0 and "-" or ""
	v = math.abs(v)
	if v < 1 and v > 0 then
		local s = string.format("%.4f", v):gsub("0+$", ""):gsub("%.$", "")
		return sign .. s
	end
	local formatted = tostring(math.floor(v + 0.5))
	local k
	while true do
		formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then break end
	end
	return sign .. formatted
end

local function shortenTierText(s)
	if not s then return "" end
	s = tostring(s)
	s = s:gsub("[Uu]ncommons?", "unc")
	s = s:gsub("[Ll]egendaries", "leg"):gsub("[Ll]egendary", "leg")
	s = s:gsub("[Cc]ommons?", "com")
	s = s:gsub("[Rr]ares?", "rare")
	return s
end

local function addValueLabel(parent, itemName, slot, isOffer)
	if not enabled or not parent then return end

	local disp, val, stability, tier = lookupDisplayAndNumericValue(itemName, slot)
	if not disp then
		local label = parent:FindFirstChild("ValueLabel")
		if label then
			pcall(function() label:Destroy() end)
		end
		local stabLabel = parent:FindFirstChild("StabilityLabel")
		if stabLabel then
			pcall(function() stabLabel:Destroy() end)
		end
		local tierLabel = parent:FindFirstChild("TierLabel")
		if tierLabel then
			pcall(function() tierLabel:Destroy() end)
		end
		return
	end
	
	local displayText = ""
	if disp:lower() == "n/a" then
		displayText = "N/A"
	elseif disp:sub(1, 1):lower() == "x" then
		displayText = shortenTierText(disp)
	else
		local cleanDisp = disp:gsub(",", "")
		local num = tonumber(cleanDisp)
		if num then
			displayText = fmt(num)
		else
			displayText = shortenTierText(disp)
		end
	end

	local label = parent:FindFirstChild("ValueLabel")
	if label and label:IsA("TextLabel") then
		if label.Text ~= displayText then
			label.Text = displayText
		end
		label.Position = UDim2.new(0, 4, 0, 4)
		label.ZIndex = 150
	else
		if label then
			pcall(function() label:Destroy() end)
		end
		label = Instance.new("TextLabel")
		label.Name = "ValueLabel"
		label.Size = UDim2.new(0.65, 0, 0, 14)
		label.Position = UDim2.new(0, 4, 0, 4)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.BackgroundTransparency = 1
		label.Text = displayText
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.ZIndex = 150
		label.TextStrokeTransparency = 0.5
		label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		label.Parent = parent
	end
	
	if isOffer then
		local found = false
		for _, l in ipairs(createdLabels) do
			if l == label then found = true break end
		end
		if not found then
			table.insert(createdLabels, label)
		end
	end

	local stabLabel = parent:FindFirstChild("StabilityLabel")
	if stability and stability ~= "N/A" and stability ~= "" then
		local stabColor = Color3.fromRGB(255, 255, 255)

		if stabLabel and stabLabel:IsA("TextLabel") then
			if stabLabel.Text ~= stability then
				stabLabel.Text = stability
			end
			stabLabel.TextColor3 = stabColor
			stabLabel.Position = UDim2.new(0, 4, 0, 18)
			stabLabel.ZIndex = 150
		else
			if stabLabel then
				pcall(function() stabLabel:Destroy() end)
			end
			stabLabel = Instance.new("TextLabel")
			stabLabel.Name = "StabilityLabel"
			stabLabel.Size = UDim2.new(0.65, 0, 0, 10)
			stabLabel.Position = UDim2.new(0, 4, 0, 18)
			stabLabel.TextXAlignment = Enum.TextXAlignment.Left
			stabLabel.BackgroundTransparency = 1
			stabLabel.Text = stability
			stabLabel.TextColor3 = stabColor
			stabLabel.TextScaled = true
			stabLabel.Font = Enum.Font.SourceSansBold
			stabLabel.ZIndex = 150
			stabLabel.TextStrokeTransparency = 0.5
			stabLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			stabLabel.Parent = parent
		end

		if isOffer then
			local found = false
			for _, l in ipairs(createdLabels) do
				if l == stabLabel then found = true break end
			end
			if not found then
				table.insert(createdLabels, stabLabel)
			end
		end
	else
		if stabLabel then
			pcall(function() stabLabel:Destroy() end)
		end
	end

	local tierLabel = parent:FindFirstChild("TierLabel")
	if tier and tier ~= "N/A" and tier ~= "" then
		local tierText = tostring(tier)
		local tierColor = Color3.fromRGB(255, 255, 255)

		if tierLabel and tierLabel:IsA("TextLabel") then
			if tierLabel.Text ~= tierText then
				tierLabel.Text = tierText
			end
			tierLabel.TextColor3 = tierColor
			tierLabel.Position = UDim2.new(0, 4, 0, 28)
			tierLabel.ZIndex = 150
		else
			if tierLabel then
				pcall(function() tierLabel:Destroy() end)
			end
			tierLabel = Instance.new("TextLabel")
			tierLabel.Name = "TierLabel"
			tierLabel.Size = UDim2.new(0.65, 0, 0, 10)
			tierLabel.Position = UDim2.new(0, 4, 0, 28)
			tierLabel.TextXAlignment = Enum.TextXAlignment.Left
			tierLabel.BackgroundTransparency = 1
			tierLabel.Text = tierText
			tierLabel.TextColor3 = tierColor
			tierLabel.TextScaled = true
			tierLabel.Font = Enum.Font.SourceSansBold
			tierLabel.ZIndex = 150
			tierLabel.TextStrokeTransparency = 0.5
			tierLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			tierLabel.Parent = parent
		end

		if isOffer then
			local found = false
			for _, l in ipairs(createdLabels) do
				if l == tierLabel then found = true break end
			end
			if not found then
				table.insert(createdLabels, tierLabel)
			end
		end
	else
		if tierLabel then
			pcall(function() tierLabel:Destroy() end)
		end
	end
end

local function clearValueLabels()
	for _, l in pairs(createdLabels) do
		pcall(function() l:Destroy() end)
	end
	createdLabels = {}
end

local function processContainerDescendants(parent, isOffer)
	if not enabled or not parent then return end
	for _, child in pairs(parent:GetDescendants()) do
		if child:IsA("GuiObject") then
			local container = child:FindFirstChild("Container") or child
			if container and (container:FindFirstChild("Icon") or container:FindFirstChild("ItemIcon")) then
				local nameFrame = child:FindFirstChild("ItemName") or container:FindFirstChild("ItemName")
				local label = nameFrame and (nameFrame:IsA("TextLabel") and nameFrame or nameFrame:FindFirstChild("Label") or nameFrame:FindFirstChildWhichIsA("TextLabel"))
				if not label then
					label = child:FindFirstChild("ItemName", true) or child:FindFirstChild("Label", true)
				end
				if label and label:IsA("TextLabel") and label.Text ~= "" and label.Text ~= "Loading..." then
					addValueLabel(container, label.Text, child, isOffer)
				end
			end
		end
	end
end

local function removeValueLabels(parent)
	if not parent then return end
	for _, desc in pairs(parent:GetDescendants()) do
		if desc.Name == "ValueLabel" or desc.Name == "StabilityLabel" or desc.Name == "TierLabel" then
			pcall(function() desc:Destroy() end)
		end
	end
end

local function removeAllLabels()
	for _, l in pairs(createdLabels) do
		pcall(function() l:Destroy() end)
	end
	createdLabels = {}

	local function scanAndRemove(inst)
		if not inst then return end
		for _, desc in pairs(inst:GetDescendants()) do
			if desc.Name == "ValueLabel" or desc.Name == "StabilityLabel" or desc.Name == "TierLabel" then
				pcall(function() desc:Destroy() end)
			end
		end
	end

	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then
		scanAndRemove(pg:FindFirstChild("TradeGUI"))
		scanAndRemove(pg:FindFirstChild("TradeGUI_Phone"))
		scanAndRemove(pg:FindFirstChild("MainGUI"))
		scanAndRemove(pg:FindFirstChild("InventoryPhone"))
		scanAndRemove(pg:FindFirstChild("Inventory_Phone"))
	end

	local rep = ReplicatedStorage:FindFirstChild("ReplicatedStorage") or ReplicatedStorage
	if rep then
		scanAndRemove(rep:FindFirstChild("MainGUI"))
	end

	if titleState.yourTitle and titleState.yourTitle:IsA("TextLabel") then
		local base = titleState.yourBase or stripBracketSuffix(titleState.yourTitle.Text)
		if base == "" then base = "YOUR OFFER" end
		if titleState.yourTitle.Text ~= base then titleState.yourTitle.Text = base end
	end
	titleState.yourBase = nil
	titleState.yourTitle = nil
end

local function sumOffer(offer)
	local total = 0
	if not offer then return total end
	local container = offer:FindFirstChild("Container", true) or offer
	for _, slot in pairs(container:GetChildren()) do
		if slot:IsA("GuiObject") and slot.Visible then
			local icon = slot:FindFirstChild("Icon", true) or slot:FindFirstChild("ItemIcon", true)
			if icon and icon:IsA("ImageLabel") and icon.Visible and icon.Image ~= "" then
				local nameFrame = slot:FindFirstChild("ItemName", true) or slot:FindFirstChild("Name", true) or slot
				local label = nameFrame:FindFirstChild("Label", true) or slot:FindFirstChild("Label", true) or slot:FindFirstChildWhichIsA("TextLabel", true)
				if label and label:IsA("TextLabel") and label.Visible and label.Text ~= "" and label.Text ~= "Loading..." then
					local _, val = lookupDisplayAndNumericValue(label.Text, slot)
					total = total + (val or 0)
				end
			end
		end
	end
	return total
end

local function stripBracketSuffix(text)
	if not text then return "" end
	return (text:gsub("%s*%[[%+%-]?[%d%.,]+[KkMm]?%]%s*$", ""))
end

local function getTradeGui()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if pg then
		local t = pg:FindFirstChild("TradeGUI") or pg:FindFirstChild("TradeGUI_Phone")
		if t then return t end
	end
	return StarterGui:FindFirstChild("TradeGUI") or StarterGui:FindFirstChild("TradeGUI_Phone")
end

local function isTradeActive(tradeGui)
	if not tradeGui or not tradeGui.Enabled then return false end
	local container = tradeGui:FindFirstChild("Container")
	if not container or not container.Visible then return false end
	local trade = container:FindFirstChild("Trade")
	if not trade or not trade.Visible then return false end
	return true
end

local function isPhoneTradeActive(tradeGUIPhone)
	if not tradeGUIPhone or not tradeGUIPhone.Enabled then return false end
	local container = tradeGUIPhone:FindFirstChild("Container")
	local trade = container and container:FindFirstChild("Trade")
	if trade and container.Visible and trade.Visible then return true end

	local inactive = tradeGUIPhone:FindFirstChild("Inactive")
	local frame = inactive and inactive:FindFirstChild("Frame")
	local main = frame and frame:FindFirstChild("Main")
	local trade2 = main and main:FindFirstChild("Trade")
	if trade2 and frame.Visible and main.Visible and trade2.Visible then return true end

	return false
end

local function getTitles(tradeGui)
	local container = tradeGui and tradeGui:FindFirstChild("Container")
	local trade = container and container:FindFirstChild("Trade")
	if not trade then return nil, nil, nil end
	local yourOffer = trade:FindFirstChild("YourOffer")
	local theirOffer = trade:FindFirstChild("TheirOffer")
	local yourTitle = yourOffer and (yourOffer:FindFirstChild("Title") or yourOffer:FindFirstChild("Title", true))
	return yourTitle, yourOffer, theirOffer
end

local function formatDiffBracket(diff)
	if diff > 0 then return "  [+" .. fmt(diff) .. "]" end
	if diff < 0 then return "  [" .. fmt(diff) .. "]" end
	return "  [0]"
end

local function updateTitles(trade, tradeGui)
	if not enabled or not tradeGui then return end
	local yourTitle, yourOffer, theirOffer = getTitles(tradeGui)
	if not yourTitle or not yourTitle:IsA("TextLabel") then return end

	if yourTitle ~= titleState.yourTitle then
		titleState.yourTitle = yourTitle
		titleState.yourBase = nil
	end

	local base = titleState.yourBase
	if not base then
		base = stripBracketSuffix(yourTitle.Text)
		if base == "" then base = "YOUR OFFER" end
		titleState.yourBase = base
	end

	local you = sumOffer(yourOffer or (trade and trade:FindFirstChild("YourOffer")))
	local them = sumOffer(theirOffer or (trade and trade:FindFirstChild("TheirOffer")))

	if you == 0 and them == 0 then
		if yourTitle.Text ~= base then yourTitle.Text = base end
	else
		local newText = base .. formatDiffBracket(them - you)
		if yourTitle.Text ~= newText then yourTitle.Text = newText end
	end
end

local function resetTitlesIfTradeClosed()
	local desktop = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("TradeGUI")
	local phone = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("TradeGUI_Phone")

	if not isTradeActive(desktop) and not isPhoneTradeActive(phone) then
		if titleState.yourTitle and titleState.yourTitle:IsA("TextLabel") then
			local base = titleState.yourBase or stripBracketSuffix(titleState.yourTitle.Text)
			if base == "" then base = "YOUR OFFER" end
			if titleState.yourTitle.Text ~= base then titleState.yourTitle.Text = base end
		end
		titleState.yourBase = nil
		titleState.yourTitle = nil
		clearValueLabels()
	end
end

task.spawn(function()
	while alive and task.wait(0.35) do
		if enabled then
			pcall(resetTitlesIfTradeClosed)

			pcall(function()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				local tradeGUI = pg and pg:FindFirstChild("TradeGUI")
				if isTradeActive(tradeGUI) then
					local container = tradeGUI:FindFirstChild("Container")
					local trade = container:FindFirstChild("Trade")
					if trade then
						local yourOffer = trade:FindFirstChild("YourOffer")
						if yourOffer then processContainerDescendants(yourOffer, true) end
						
						local theirOffer = trade:FindFirstChild("TheirOffer")
						if theirOffer then processContainerDescendants(theirOffer, true) end
						
						updateTitles(trade, tradeGUI)
					end
					local items = container:FindFirstChild("Items")
					if items and items.Visible then processContainerDescendants(items, false) end
					local items2 = container:FindFirstChild("Items2")
					if items2 and items2.Visible then processContainerDescendants(items2, false) end
				end
			end)

			pcall(function()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				local tradeGUIPhone = pg and pg:FindFirstChild("TradeGUI_Phone")
				if isPhoneTradeActive(tradeGUIPhone) then
					local container = tradeGUIPhone:FindFirstChild("Container")
					if container and container.Visible then
						local trade = container:FindFirstChild("Trade")
						if trade and trade.Visible then
							local yourOffer = trade:FindFirstChild("YourOffer")
							if yourOffer then processContainerDescendants(yourOffer, true) end
							
							local theirOffer = trade:FindFirstChild("TheirOffer")
							if theirOffer then processContainerDescendants(theirOffer, true) end
							
							updateTitles(trade, tradeGUIPhone)
						end
						local items = container:FindFirstChild("Items")
						if items and items.Visible then processContainerDescendants(items, false) end
						local items2 = container:FindFirstChild("Items2")
						if items2 and items2.Visible then processContainerDescendants(items2, false) end
					end

					local inactive = tradeGUIPhone:FindFirstChild("Inactive")
					local frame = inactive and inactive:FindFirstChild("Frame")
					local main = frame and frame:FindFirstChild("Main")
					if main and frame.Visible and main.Visible then
						local trade = main:FindFirstChild("Trade")
						if trade and trade.Visible then
							local yourOffer = trade:FindFirstChild("YourOffer")
							if yourOffer then processContainerDescendants(yourOffer, true) end
							
							local theirOffer = trade:FindFirstChild("TheirOffer")
							if theirOffer then processContainerDescendants(theirOffer, true) end
							
							updateTitles(trade, tradeGUIPhone)
						end
						local items = main:FindFirstChild("Items")
						if items and items.Visible then processContainerDescendants(items, false) end
						local items2 = main:FindFirstChild("Items2")
						if items2 and items2.Visible then processContainerDescendants(items2, false) end
					end
				end
			end)

			pcall(function()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				local rep = ReplicatedStorage:FindFirstChild("ReplicatedStorage") or ReplicatedStorage
				local repMain = rep:FindFirstChild("MainGUI")
				
				local targets = {}
				if pg then
					local mainGUI = pg:FindFirstChild("MainGUI")
					local gameFrame = mainGUI and mainGUI:FindFirstChild("Game")
					if gameFrame then table.insert(targets, gameFrame) end
					
					local lobby = mainGUI and mainGUI:FindFirstChild("Lobby")
					if lobby then
						processContainerDescendants(lobby, false)
					end
				end
				if repMain then
					local gameFrame = repMain:FindFirstChild("Game")
					if gameFrame then table.insert(targets, gameFrame) end
					
					local lobby = repMain:FindFirstChild("Lobby")
					if lobby then
						processContainerDescendants(lobby, false)
					end
				end

				for _, gameFrame in ipairs(targets) do
					local inv = gameFrame:FindFirstChild("Inventory")
					if inv and (inv.Visible or gameFrame.Parent == repMain) then
						processContainerDescendants(inv, false)
					end
					
					local inv2 = gameFrame:FindFirstChild("Inventory2")
					if inv2 and (inv2.Visible or gameFrame.Parent == repMain) then
						processContainerDescendants(inv2, false)
					end

					local viewProfile = gameFrame:FindFirstChild("ViewProfile")
					if viewProfile and (viewProfile.Visible or gameFrame.Parent == repMain) then
						processContainerDescendants(viewProfile, false)
					end

					local crafting = gameFrame:FindFirstChild("Crafting")
					if crafting and (crafting.Visible or gameFrame.Parent == repMain) then
						processContainerDescendants(crafting, false)
					end

					local leaderboard = gameFrame:FindFirstChild("Leaderboard")
					local inspect = leaderboard and leaderboard:FindFirstChild("Inspect")
					if inspect and (inspect.Visible or gameFrame.Parent == repMain) then
						processContainerDescendants(inspect, false)
					end
				end

				local phoneInv = pg and (pg:FindFirstChild("InventoryPhone") or pg:FindFirstChild("Inventory_Phone"))
				if phoneInv and phoneInv.Visible then
					processContainerDescendants(phoneInv, false)
				end
			end)
		end
	end
end)

local function setEnabled(state)
	local newState
	if state == nil then
		newState = not enabled
	else
		newState = (state == true)
	end
	if enabled == newState then return enabled end
	enabled = newState
	if not enabled then
		pcall(removeAllLabels)
	else
		task.spawn(function()
			pcall(function()
				local pg = LocalPlayer:FindFirstChild("PlayerGui")
				if pg then
					local mainGUI = pg:FindFirstChild("MainGUI")
					local gameFrame = mainGUI and mainGUI:FindFirstChild("Game")
					local inv = gameFrame and gameFrame:FindFirstChild("Inventory")
					if inv and inv.Visible then
						processContainerDescendants(inv, false)
					end
					local tradeGUI = pg:FindFirstChild("TradeGUI")
					if isTradeActive(tradeGUI) then
						local container = tradeGUI:FindFirstChild("Container")
						local trade = container and container:FindFirstChild("Trade")
						if trade then
							local yourOffer = trade:FindFirstChild("YourOffer")
							if yourOffer then processContainerDescendants(yourOffer, true) end
							local theirOffer = trade:FindFirstChild("TheirOffer")
							if theirOffer then processContainerDescendants(theirOffer, true) end
							updateTitles(trade, tradeGUI)
						end
					end
				end
			end)
		end)
	end
	return enabled
end

local function toggleEnabled()
	return setEnabled(not enabled)
end

local function isEnabled()
	return enabled
end

local function destroyScript()
	alive = false
	enabled = false
	pcall(removeAllLabels)
	if _G.MM2ValuesCleanup then
		_G.MM2ValuesCleanup = nil
	end
end

_G.MM2ValuesCleanup = function()
	destroyScript()
end

local MM2Values = {}

function MM2Values.SetEnabled(selfOrState, maybeState)
	local state = (maybeState ~= nil) and maybeState or selfOrState
	if selfOrState == MM2Values and maybeState == nil then
		state = nil
	end
	return setEnabled(state)
end

function MM2Values.Toggle(self)
	return toggleEnabled()
end

function MM2Values.IsEnabled(self)
	return isEnabled()
end

function MM2Values.Clear(self)
	pcall(removeAllLabels)
end

function MM2Values.Destroy(self)
	destroyScript()
end

_G.MM2Values = MM2Values
_G.SetMM2ValuesEnabled = setEnabled
_G.ToggleMM2Values = toggleEnabled
_G.IsMM2ValuesEnabled = isEnabled

if type(getgenv) == "function" then
	local g = getgenv()
	if type(g) == "table" then
		g.MM2Values = MM2Values
		g.SetMM2ValuesEnabled = setEnabled
		g.ToggleMM2Values = toggleEnabled
		g.IsMM2ValuesEnabled = isEnabled
	end
end

print("[TradeValues] LOADED | source=" .. tostring(valueSource) .. " | by Namedadude")
if valueSource == "failed" then
	warn("[TradeValues] JSON load failed — check URL / HttpService")
end

return MM2Values