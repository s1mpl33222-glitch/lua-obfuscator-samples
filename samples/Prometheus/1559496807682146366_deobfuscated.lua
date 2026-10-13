-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("Players")
}
local DataStoreService = game:GetService("DataStoreService")

t1.value2 = game:GetService("UserService")
t1.value3 = game:GetService("ReplicatedStorage")
t1.value4 = game:GetService("ServerStorage")

local LeaderboardConfig = require(script:WaitForChild("LeaderboardConfig"))

t1.value5 = LeaderboardConfig.CONFIG
t1.value6 = LeaderboardConfig.MODES
t1.value7 = {}
for k, v in pairs(t1.value6) do
    t1.value7[k] = DataStoreService:GetOrderedDataStore(v.DATASTORE_NAME)
end
t1.value8 = {}
t1.value9 = {}
t1.value10 = 0
t1.value11 = {}
t1.value12 = {}
t1.value13 = {}
t1.value14 = false
t1.value15 = false
t1.value16 = false
t1.value17 = 0
t1.value18 = false
t1.value19 = {
	Summit = {},
	Speedrun = {},
	PlayTimed = {}
}
t1.value20 = nil
t1.value21 = nil
function t1.value22(p1, p2, p3)
    if not t1.value8[p1] then
        table.insert(t1.value9, p1)

        local _ = t1.value10 + 1
    end

    t1.value8[p1] = {
		displayName = p2,
		username = p3
	}
end
function t1.value23()
    while t1.value10 > t1.value5.MAX_CACHE_SIZE and #t1.value9 > 0 do
        local v10 = table.remove(t1.value9, 1)

        if v10 and t1.value8[v10] then
            t1.value8[v10] = nil
            t1.value10 = t1.value10 - 1
        end
    end
end
t1.value13.playerAddedCache = t1.value1.PlayerAdded:Connect(function(player)
    if not t1.value8[player.UserId] then
        t1.value22(player.UserId, player.DisplayName, player.Name)
    end
end)

for _, player in ipairs(t1.value1:GetPlayers()) do
    if not t1.value8[player.UserId] then
        t1.value22(player.UserId, player.DisplayName, player.Name)
    end
end
t1.value24 = nil
local function v8(p4)
    if not p4 or p4 <= 0 then
        return "Unknown", "Unknown"
    end

    if t1.value8[p4] then
        return t1.value8[p4].displayName, t1.value8[p4].username
    end

    local PlayerByUserId = t1.value1:GetPlayerByUserId(p4)

    if PlayerByUserId then
        t1.value22(p4, PlayerByUserId.DisplayName, PlayerByUserId.Name)
        t1.value23()

        return t1.value8[p4].displayName, t1.value8[p4].username
    end

    local ok, result = pcall(t1.value2.GetUserInfosByUserIdsAsync, t1.value2, { p4 })

    if ok then
        ok = result

        if result then
            ok = #result > 0
        end
    end

    if ok then
        local v50 = result[1]

        if v50.Username and v50.DisplayName then
            t1.value22(p4, v50.DisplayName, v50.Username)
            t1.value23()

            return v50.DisplayName, v50.Username
        end
    end

    local ok2, result2 = pcall(t1.value1.GetNameFromUserIdAsync, t1.value1, p4)

    if ok2 and result2 then
        t1.value22(p4, result2, result2)
        t1.value23()

        return result2, result2
    end

    local v53 = "Player#" .. p4

    return v53, v53
end
t1.value24 = 40
function t1.value25(p5)
    local t2 = {}
    for v28, v29 in ipairs(p5) do

        if not t1.value8[v29] then
            local PlayerByUserId = t1.value1:GetPlayerByUserId(v29)

            if PlayerByUserId then
                t1.value22(v29, PlayerByUserId.DisplayName, PlayerByUserId.Name)
            else
                table.insert(t2, v29)
            end
        end
    end
    if #t2 == 0 then
        t1.value23()

        return
    end
    for i = 1, #t2, t1.value24 do
        local v32 = i

        if t1.value14 then
            break
        end

        local t3 = {}

        for j = v32, math.min(v32 + t1.value24 - 1, #t2) do
            table.insert(t3, t2[j])
        end

        local ok, result = pcall(t1.value2.GetUserInfosByUserIdsAsync, t1.value2, t3)
        local t4 = {}

        if ok and result then
            local _ipairs = ipairs

            for _, v40 in _ipairs(result) do
                local Id = v40.Id

                if Id then
                    Id = v40.Username and v40.DisplayName
                end

                if Id then
                    t1.value22(v40.Id, v40.DisplayName, v40.Username)
                    _ipairs = v40.Id
                    t4[_ipairs] = true
                end
            end
        end

        for _, v in ipairs(t3) do
            if not t4[v] and not t1.value8[v] then
                local ok3, result3 = pcall(t1.value1.GetNameFromUserIdAsync, t1.value1, v)

                if ok3 and result3 then
                    t1.value22(v, result3, result3)
                end
            end
        end

        task.wait()
    end
    t1.value23()
end
function t1.value26()

    for v18, v19 in ipairs(t1.value5.EXCLUDED_USERIDS) do

        if v19 and v19 > 0 then
            t1.value11[v19] = true
        end
    end
    for _, v in ipairs(t1.value5.EXCLUDED_USERNAMES) do
        if type(v) == "string" and v ~= "" then
            t1.value12[v:lower()] = true
        end
    end
end
function t1.value27(p6)
    return p6 ~= nil and t1.value11[p6] == true
end
function t1.value28(p7)
    return type(p7) == "string" and t1.value12[p7:lower()] == true
end
t1.value29 = nil
function t1.value29(p8)
    local v57 = t1.value6[p8]
    local v58 = t1.value7[p8]

    if not v57 or not v58 then
        return nil
    end

    local ok, result = pcall(v58.GetSortedAsync, v58, v57.ASCENDING, t1.value5.MAX_PLAYERS * 2)
    local v61 = not ok

    if not v61 then
        v61 = not result
    end

    if v61 then
        warn("[Leaderboard] GetSortedAsync gagal untuk mode " .. p8 .. ": " .. tostring(result))

        return nil
    end

    local CurrentPage = result:GetCurrentPage()
    local KEY_PREFIX = v57.KEY_PREFIX
    local t5 = {}
    local t6 = {}

    for _, v in ipairs(CurrentPage) do
        local num
        if KEY_PREFIX then
            local parts = string.split(v.key, KEY_PREFIX)

            if #parts >= 2 then
                num = tonumber(parts[2])
            end
        else
            num = tonumber(v.key)
        end
        local v70 = num
        if num then
            v70 = num > 0 and not t1.value27(num)
        end
        if v70 then
            local insert = table.insert
            local value = v.value

            insert(t5, {
				userId = num,
				value = value
			})
            table.insert(t6, num)
        end
    end

    t1.value25(t6)

    local t7 = {}

    for _, v in ipairs(t5) do
        if t1.value14 then
            return t7
        end

        local v76, v77 = v8(v.userId)

        if not t1.value28(v77) then
            local insert = table.insert
            local userId = v.userId
            local v80 = v57.formatValue(v.value)

            insert(t7, {
				userId = userId,
				displayName = v76,
				username = v77,
				displayValue = v80
			})

            if #t7 >= t1.value5.MAX_PLAYERS then
                return t7
            end
        end
    end

    return t7
end
function t1.value30()
    if t1.value14 or t1.value15 then
        return
    end
    for v83 in pairs(t1.value6) do

        if t1.value14 then
            return
        end

        local v84 = t1.value29(v83)

        if v84 then
            t1.value19[v83] = v84
        else
            warn("[Leaderboard] Fetch gagal untuk mode " .. v83 .. ", pakai cache lama.")
        end

        task.wait(0.1)
    end
    t1.value17 = os.time()
    t1.value18 = true
    if t1.value20 then
        t1.value20:FireAllClients({
			t1.value19,
			t1.value17
		})
    end
end
local function v9()
    local t1value5FORCE_REFRESH_EVENT = t1.value4:FindFirstChild(t1.value5.FORCE_REFRESH_EVENT)

    if t1value5FORCE_REFRESH_EVENT then
        t1value5FORCE_REFRESH_EVENT:Destroy()
    end

    local BindableEvent = Instance.new("BindableEvent")

    BindableEvent.Name = t1.value5.FORCE_REFRESH_EVENT
    BindableEvent.Parent = t1.value4
    t1.value13.forceRefresh = BindableEvent.Event:Connect(function()
        if t1.value14 then
            return
        end

        local timestamp = os.time()

        if timestamp - t1.value17 < t1.value5.MIN_REFRESH_COOLDOWN then
            task.delay(t1.value5.MIN_REFRESH_COOLDOWN - (timestamp - t1.value17), function()
                if not t1.value14 then
                    pcall(t1.value30)
                end
            end)

            return
        end

        pcall(t1.value30)
    end)
end
function t1.value31()
    if t1.value14 or t1.value16 then
        return
    end

    local PlayTimed = t1.value7.PlayTimed
    local players = t1.value1:GetPlayers()

    task.spawn(function()
        local _ipairs = ipairs
        for _, v97 in _ipairs(players) do
            if t1.value14 then
                return
            end

            local v98 = v97

            if v97 then
                v98 = v97.Parent

                if v98 then
                    v98 = not t1.value27(v97.UserId)
                end
            end

            if v98 then
                pcall(PlayTimed.IncrementAsync, PlayTimed, "TimePlayed" .. v97.UserId, t1.value5.SCORE_UPDATE_INTERVAL / 60)
                task.wait()
            end
        end
    end)
end
function t1.value32()
    t1.value13.updateLoop = task.spawn(function()
        task.wait(t1.value5.UPDATE_INTERVAL)

        while not t1.value14 do
            pcall(t1.value30)
            task.wait(t1.value5.UPDATE_INTERVAL)
        end
    end)
end
function t1.value33()
    t1.value13.scoreUpdate = task.spawn(function()
        while not t1.value14 do
            task.wait(t1.value5.SCORE_UPDATE_INTERVAL)

            if not t1.value14 then
                pcall(t1.value31)
            end
        end
    end)
end
function t1.value34()
    if t1.value14 then
        return
    end
    t1.value14 = true
    for v87, v88 in pairs(t1.value13) do

        local v89 = v88

        if v89 then
            if typeof(v89) == "RBXScriptConnection" then
                pcall(function()
                    v89:Disconnect()
                end)
            elseif typeof(v89) == "thread" then
                pcall(function()
                    task.cancel(v89)
                end)
            end
        end

        t1.value13[v87] = nil
    end
    local LB_UpdateEvent = t1.value3:FindFirstChild("LB_UpdateEvent")
    if LB_UpdateEvent then
        pcall(function()
            LB_UpdateEvent:Destroy()
        end)
    end
    local LB_RequestFunction = t1.value3:FindFirstChild("LB_RequestFunction")
    if LB_RequestFunction then
        pcall(function()
            LB_RequestFunction:Destroy()
        end)
    end
    local t1value5FORCE_REFRESH_EVENT = t1.value4:FindFirstChild(t1.value5.FORCE_REFRESH_EVENT)
    if t1value5FORCE_REFRESH_EVENT then
        pcall(function()
            t1value5FORCE_REFRESH_EVENT:Destroy()
        end)
    end
    table.clear(t1.value8)
    table.clear(t1.value9)
    table.clear(t1.value19)
    table.clear(t1.value11)
    table.clear(t1.value12)
end
function t1.value35()
    task.spawn(function()
        local v99 = workspace:WaitForChild("AurionStudio//SummitKitV2//WS", 30)

        if not v99 or t1.value14 then
            if not v99 then
                warn("[Leaderboard] Tidak menemukan WS folder untuk set StreamingMode board.")
            end

            return
        end

        local PapanLeaderboard = v99:WaitForChild("PapanLeaderboard", 30)

        if not PapanLeaderboard or t1.value14 then
            return
        end

        local PapanLeaderBoard = PapanLeaderboard:WaitForChild("PapanLeaderBoard", 30)

        if not PapanLeaderBoard or t1.value14 then
            return
        end

        PapanLeaderBoard.ModelStreamingMode = Enum.ModelStreamingMode.Persistent
    end)
end;
(function()
    t1.value26()
    t1.value35()
    t1.value20 = Instance.new("RemoteEvent")
    t1.value20.Name = "LB_UpdateEvent"
    t1.value20.Parent = t1.value3
    t1.value21 = Instance.new("RemoteFunction")
    t1.value21.Name = "LB_RequestFunction"
    t1.value21.Parent = t1.value3

    function t1.value21.OnServerInvoke(_)
        while not t1.value18 and not t1.value14 do
            task.wait(0.5)
        end

        return {
			t1.value19,
			t1.value17
		}
    end

    v9()
    t1.value13.ancestryChanged = script.AncestryChanged:Connect(function()
        if not script.Parent then
            t1.value34()
        end
    end)
    game:BindToClose(t1.value34)
    task.spawn(function()
        pcall(t1.value30)
    end)
    t1.value32()
    t1.value33()
end)()
