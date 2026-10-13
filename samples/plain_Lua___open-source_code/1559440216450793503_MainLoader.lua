-- Hi skids or people looking at this there nothing fucking interesting here you pleb.
repeat task.wait(0.1) until game:IsLoaded()

local Loader, Services, LuarmorAPI
do
    local urls = {
        "https://zekehub.com/scripts/UILib/BootstrapLoader.lua",
        "https://zekehub.com/scripts/Utility/Services.lua",
        "https://sdkapi-public.luarmor.net/library.lua"
    }
    local results, errors = table.create(3), {}
    local done = 0
    local started = os.clock()

    for i, url in urls do
        task.spawn(function()
            local ok, result = pcall(function()
                return loadstring(game:HttpGet(url))()
            end)
            if ok and result then
                results[i] = result
            else
                table.insert(errors, url .. " -> " .. tostring(result))
            end
            done += 1
        end)
    end

    repeat task.wait() until done == 3

    Loader, Services, LuarmorAPI = results[1], results[2], results[3]

    if not Loader then
        warn("[ZekeHub] Failed to download the loader:\n" .. table.concat(errors, "\n"))
        return
    end

    if #errors > 0 then
        Loader:Fail("Download Failed", table.concat(errors, "\n") .. "\nCheck your internet / VPN and try again.")
        return
    end

    Loader:Record(string.format("Downloaded loader libraries (%.2fs)", os.clock() - started))
end

LuarmorAPI.script_id = "af96623a60cdc415dbf7d2e77e0a6deb"

local MarketplaceService, Players = Services:Get("MarketplaceService", "Players")

local Utilities = {}
local Handlers = {}

do
    local TimeUnits = {
        { unit = "d", seconds = 86400 },
        { unit = "h", seconds = 3600 },
        { unit = "m", seconds = 60 },
        { unit = "s", seconds = 1 }
    }

    function Utilities.FormatDuration(seconds)
        if not seconds or seconds <= 0 or seconds == -1 then
            return "Lifetime"
        end

        local parts = {}
        local remaining = seconds

        for _, data in TimeUnits do
            local value = math.floor(remaining / data.seconds)
            if value > 0 then
                table.insert(parts, value .. data.unit)
                remaining = remaining % data.seconds
                if #parts >= 2 then break end
            end
        end

        return #parts > 0 and table.concat(parts, " ") or "0s"
    end

    function Utilities.GetGameInfo()
        local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
        return {
            Name = ok and info.Name or "Unknown Game",
            Creator = ok and info.Creator.Name or "Unknown"
        }
    end

    function Utilities.GetExecutor()
        return identifyexecutor and identifyexecutor() or "Unknown"
    end

    function Utilities.CopyDiscord()
        pcall(setclipboard, "discord.gg/zekehub")
    end
end

do
    Handlers.KEY_VALID = function(data)
        task.spawn(LuarmorAPI.purge_cache)

        local player = Players.LocalPlayer
        local timeLeft = Utilities.FormatDuration(data.auth_expire > 0 and (data.auth_expire - os.time()) or -1)

        local details = {
            "Welcome, " .. player.DisplayName,
            "Executions: " .. tostring(data.total_executions),
            "Expires: " .. timeLeft
        }

        if data.note and data.note ~= "" then
            table.insert(details, "Note: " .. data.note)
        end

        Loader:Log(table.concat(details, "\n"), "Good")
        Loader:SetStatus("Loading ZekeHub...")
        Loader:SetProgress(40)

        local started = os.clock()
        local ok, err = pcall(LuarmorAPI.load_script)
        if not ok then
            Loader:Fail("Script Error", tostring(err) ~= "" and tostring(err) or "The loader stopped without an error message.")
            return false
        end

        Loader:Record(string.format("Luarmor loader finished (%.1fs)", os.clock() - started))
        return true
    end

    Handlers.KEY_HWID_LOCKED = function()
        Utilities.CopyDiscord()
        Loader:Fail("HWID Mismatch", "This key is linked to another device.\nReset it via the Dashboard or Discord bot.\nDiscord invite copied to clipboard.")
        return false
    end

    Handlers.KEY_EXPIRED = function()
        Utilities.CopyDiscord()
        Loader:Fail("Subscription Expired", "Your key has expired.\nRenew to keep using ZekeHub.\nDiscord invite copied to clipboard.")
        return false
    end

    Handlers.KEY_BANNED = function()
        Utilities.CopyDiscord()
        Loader:Fail("Access Revoked", "This key has been blacklisted.\nContact support if this is a mistake.\nDiscord invite copied to clipboard.")
        return false
    end

    Handlers.KEY_INCORRECT = function()
        Utilities.CopyDiscord()
        Loader:Fail("Invalid Key", "Key not found in database.\nDiscord invite copied to clipboard.")
        return false
    end
end

do
    local function Authenticate()
        if not script_key then
            Loader:Fail("Authentication Failed", "No key provided.\nCheck your key and try again.")
            return false
        end

        Loader:SetStatus("Authenticating...")
        Loader:SetProgress(20)

        local ok, status = pcall(LuarmorAPI.check_key, script_key)
        if not ok or type(status) ~= "table" then
            Loader:Fail("Authentication Error", "Key check failed: " .. tostring(status) .. "\nLuarmor may be down, try again in a minute.")
            return false
        end

        Loader:Record("Key check: " .. tostring(status.code))

        local handler = Handlers[status.code]
        if handler then
            return handler(status.data)
        end

        Utilities.CopyDiscord()
        Loader:Fail("Authentication Error", "Code: " .. tostring(status.code) .. "\nDiscord invite copied to clipboard.")
        return false
    end

    local gameInfo = Utilities.GetGameInfo()
    local executor = Utilities.GetExecutor()

    Loader:Log("Game: " .. gameInfo.Name .. " (" .. game.PlaceId .. ")\nExecutor: " .. executor)
    Loader:SetStatus("Starting...")
    Loader:SetProgress(8)

    Authenticate()
end

--[[local Runner = loadstring(game:HttpGet("https://raw.githubusercontent.com/AccountBurner/Burner/refs/heads/main/game.lua"))() -- i didnt make this shit i found it on github and thought it was funny so i used it

Runner:Show({
    Title = "ZekeHub is down",
    Subtitle = "keys will be compensated for downtime period. So please wait for the next update.",
    Invite = "discord.gg/zekehub",
    InviteLabel = "copy discord",
    ScoreFile = "score.txt"
})]]