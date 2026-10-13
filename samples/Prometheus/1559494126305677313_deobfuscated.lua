-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("ReplicatedStorage"),
	value3 = game:GetService("ServerStorage"),
	value4 = 1,
	value5 = 0.2,
	value6 = 50,
	value7 = 25,
	value8 = {
		Start = 0,
		Summit = 10000,
		["God Summit"] = 20000
	}
}
function t1.value9(p1)
    if not p1 or p1 == "" then
        return 0
    end

    local v8 = t1.value8[p1]

    if v8 then
        return v8
    end

    return tonumber(p1:match("%d+")) or 0
end
function t1.value10(p2)
    if not p2 or p2 == "" then
        return "0"
    end

    if t1.value8[p2] then
        return p2
    end

    return p2:match("%d+") or p2
end
local LeaderboardRemotes = t1.value2:FindFirstChild("LeaderboardRemotes")

if not LeaderboardRemotes then
    LeaderboardRemotes = Instance.new("Folder")
    LeaderboardRemotes.Name = "LeaderboardRemotes"
    LeaderboardRemotes.Parent = t1.value2
end
t1.value11 = LeaderboardRemotes
local LeaderboardUpdate = t1.value11:FindFirstChild("LeaderboardUpdate")

if not LeaderboardUpdate then
    LeaderboardUpdate = Instance.new("RemoteEvent")
    LeaderboardUpdate.Name = "LeaderboardUpdate"
    LeaderboardUpdate.Parent = t1.value11
end
t1.value12 = LeaderboardUpdate
t1.value13 = nil
task.spawn(function()
    local v9 = tick() + 30

    while v9 > tick() do
        local PlayerDataReady = t1.value3:FindFirstChild("PlayerDataReady")

        if PlayerDataReady then
            t1.value13 = PlayerDataReady

            return
        end

        task.wait(0.5)
    end
end)
t1.value14 = {}
t1.value15 = {}
t1.value16 = nil
t1.value17 = {}
t1.value18 = {}
t1.value19 = ""
t1.value20 = false
t1.value21 = false
t1.value22 = nil
function t1.value23(p3)
    if not t1.value14[p3] then
        t1.value14[p3] = {
			summitCount = 0,
			cpNum = 0,
			touchedAt = 1e999,
			checkpoint = "0"
		}
    end

    return t1.value14[p3]
end
function t1.value24()
    local n1 = 0

    for _, player in ipairs(t1.value1:GetPlayers()) do
        if player and player.Parent then
            local v25 = t1.value14[player.UserId]

            if v25 then
                local value17 = t1.value17

                n1 += 1

                if value17[n1] then
                    t1.value17[n1].userId = player.UserId
                    t1.value17[n1].displayName = player.DisplayName
                    t1.value17[n1].name = player.Name
                    t1.value17[n1].summit = v25.summitCount
                    t1.value17[n1].cpNum = v25.cpNum
                    t1.value17[n1].touchedAt = v25.touchedAt
                    t1.value17[n1].checkpoint = v25.checkpoint
                else
                    local value17_2 = t1.value17
                    local UserId = player.UserId
                    local DisplayName = player.DisplayName
                    local playerName = player.Name
                    local summitCount = v25.summitCount
                    local cpNum = v25.cpNum
                    local touchedAt = v25.touchedAt
                    local checkpoint = v25.checkpoint

                    value17_2[n1] = {
						userId = UserId,
						displayName = DisplayName,
						name = playerName,
						summit = summitCount,
						cpNum = cpNum,
						touchedAt = touchedAt,
						checkpoint = checkpoint
					}
                end
            end
        end
    end

    for i = n1 + 1, #t1.value17 do
        t1.value17[i] = nil
    end

    table.sort(t1.value17, function(p4, p5)
        if p4.cpNum ~= p5.cpNum then
            return p4.cpNum > p5.cpNum
        end

        return p4.touchedAt < p5.touchedAt
    end)

    local t2 = {}

    for i = 1, math.min(n1, t1.value6) do
        local v38 = t1.value17[i]
        local userId = v38.userId
        local displayName = v38.displayName
        local name = v38.name
        local summit = v38.summit
        local checkpoint = v38.checkpoint

        t2[i] = {
			rank = i,
			userId = userId,
			displayName = displayName,
			name = name,
			summit = summit,
			checkpoint = checkpoint
		}
    end

    return t2
end
t1.value25 = nil
function t1.value25(p6)
    local v17 = #p6

    for i = 1, v17 do
        local v19 = p6[i]

        t1.value18[i] = v19.userId .. "_" .. v19.summit .. "_" .. v19.checkpoint
    end

    for i = v17 + 1, #t1.value18 do
        t1.value18[i] = nil
    end

    return table.concat(t1.value18, "|")
end
t1.value26 = nil
function t1.value26()
    if t1.value20 then
        return
    end

    task.delay(t1.value5, function()
        local v68 = t1.value24()

        if #v68 == 0 then
            return
        end

        local v69 = t1.value25(v68)

        if v69 == t1.value19 then
            return
        end

        t1.value19 = v69
        t1.value12:FireAllClients(v68)
    end)
end
function t1.value16(p7)
    local v12 = t1.value15[p7]

    if not v12 then
        return
    end

    for _, v in ipairs(v12) do
        local v15 = v

        pcall(function()
            v15:Disconnect()
        end)
    end

    t1.value15[p7] = nil
end
function t1.value27(p8, p9)
    local v46 = p8

    if v46 then
        v46 = p8.Parent

        if v46 then
            v46 = p9 and p9.Parent
        end
    end

    if not v46 then
        return
    end

    local Summit = p9:FindFirstChild("Summit")
    local Position = p9:FindFirstChild("Position")

    if not Summit or not Position then
        return
    end

    local v49 = t1.value23(p8.UserId)

    v49.summitCount = tonumber(Summit.Value) or 0

    local str = tostring(Position.Value)
    local v51 = t1.value9(str)

    v49.cpNum = v51
    v49.checkpoint = v51 > 0 and t1.value10(str) or "0"

    local t3 = {}

    t3[#t3 + 1] = Summit.Changed:Connect(function(property)
        local v71 = p8

        if v71 then
            v71 = p8.Parent
        end

        if not v71 then
            return
        end

        local v72 = t1.value14[p8.UserId]

        if not v72 then
            return
        end

        v72.summitCount = tonumber(property) or 0
        t1.value26()
    end)
    t3[#t3 + 1] = Position.Changed:Connect(function(property)
        local v74 = p8

        if v74 then
            v74 = p8.Parent
        end

        if not v74 then
            return
        end

        local v75 = t1.value14[p8.UserId]

        if not v75 then
            return
        end

        local str2 = tostring(property)
        local v77 = t1.value9(str2)

        if v77 > v75.cpNum then
            v75.cpNum = v77
            v75.checkpoint = t1.value10(str2)
            v75.touchedAt = tick()
        elseif v77 == 0 then
            v75.cpNum = 0
            v75.checkpoint = "0"
            v75.touchedAt = 1e999
        end

        t1.value26()
    end)

    local v53 = p8

    if v53 then
        v53 = p8.Parent
    end

    if not v53 then
        for _, v in ipairs(t3) do
            local v56 = v

            pcall(function()
                v56:Disconnect()
            end)
        end

        return
    end

    t1.value16(p8.UserId)
    t1.value15[p8.UserId] = t3
    t1.value26()
end
t1.value28 = t1.value1.PlayerAdded:Connect(function(player)
    t1.value23(player.UserId)
    t1.value16(player.UserId)
    task.spawn(function()
        local v88 = player
        if v88 then
            v88 = player.Parent
        end
        if not v88 then
            return
        end
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            t1.value27(player, leaderstats)

            return
        end
        local u90 = false
        local u91
        if t1.value13 then
            u91 = t1.value13.Event:Connect(function(p10)
                local v100 = u90

                if not v100 then
                    v100 = p10 ~= player.UserId
                end

                if v100 then
                    return
                end

                u90 = true

                if u91 then
                    pcall(function()
                        u91:Disconnect()
                    end)
                    u91 = nil
                end

                local leaderstats2 = player:FindFirstChild("leaderstats")

                if leaderstats2 then
                    t1.value27(player, leaderstats2)
                end
            end)
        end
        local n2 = 0
        local leaderstats3
        repeat
            local v93 = not u90

            if v93 then
                v93 = n2 < t1.value7

                if v93 then
                    v93 = player

                    if v93 then
                        v93 = player.Parent
                    end
                end
            end

            if not v93 then
                if u91 then
                    pcall(function()
                        u91:Disconnect()
                    end)
                end

                return
            end

            task.wait(0.1)

            local v94 = player

            n2 += 0.1
            leaderstats3 = v94:FindFirstChild("leaderstats")
        until leaderstats3
        u90 = true
        if u91 then
            pcall(function()
                u91:Disconnect()
            end)
            u91 = nil
        end
        t1.value27(player, leaderstats3)
    end)
end)
t1.value29 = t1.value1.PlayerRemoving:Connect(function(player)
    if not player then
        return
    end

    t1.value16(player.UserId)
    t1.value14[player.UserId] = nil
    task.defer(t1.value26)
end)

for _, player in ipairs(t1.value1:GetPlayers()) do
    t1.value23(player.UserId)
    task.spawn(function(p11)
        t1.value16(p11.UserId)
        task.spawn(function()
            local v80 = p11
            if v80 then
                v80 = p11.Parent
            end
            if not v80 then
                return
            end
            local leaderstats = p11:FindFirstChild("leaderstats")
            if leaderstats then
                t1.value27(p11, leaderstats)

                return
            end
            local u82 = false
            local u83
            if t1.value13 then
                u83 = t1.value13.Event:Connect(function(p12)
                    local v97 = u82

                    if not v97 then
                        v97 = p12 ~= p11.UserId
                    end

                    if v97 then
                        return
                    end

                    u82 = true

                    if u83 then
                        pcall(function()
                            u83:Disconnect()
                        end)
                        u83 = nil
                    end

                    local leaderstats4 = p11:FindFirstChild("leaderstats")

                    if leaderstats4 then
                        t1.value27(p11, leaderstats4)
                    end
                end)
            end
            local n3 = 0
            local leaderstats5
            repeat
                local v85 = not u82

                if v85 then
                    v85 = n3 < t1.value7

                    if v85 then
                        v85 = p11

                        if v85 then
                            v85 = p11.Parent
                        end
                    end
                end

                if not v85 then
                    if u83 then
                        pcall(function()
                            u83:Disconnect()
                        end)
                    end

                    return
                end

                task.wait(0.1)

                local v86 = p11

                n3 += 0.1
                leaderstats5 = v86:FindFirstChild("leaderstats")
            until leaderstats5
            u82 = true
            if u83 then
                pcall(function()
                    u83:Disconnect()
                end)
                u83 = nil
            end
            t1.value27(p11, leaderstats5)
        end)
    end, player)
end;
(function()
    if t1.value21 then
        return
    end

    t1.value21 = true
    t1.value22 = task.spawn(function()
        while t1.value21 do
            task.wait(t1.value4)

            if not t1.value21 then
                return
            end

            local v78 = t1.value24()

            if #v78 ~= 0 then
                local v79 = t1.value25(v78)

                if v79 ~= t1.value19 then
                    t1.value19 = v79
                    t1.value12:FireAllClients(v78)
                end
            end
        end
    end)
end)()
game:BindToClose(function()
    if t1.value22 then
        pcall(function()
            task.cancel(t1.value22)
        end)
        t1.value22 = nil
    end
    t1.value28:Disconnect()
    t1.value29:Disconnect()
    local t4 = {}
    for v63 in pairs(t1.value15) do

        t4[#t4 + 1] = v63
    end
    for _, v in ipairs(t4) do
        t1.value16(v)
    end
    table.clear(t1.value14)
    table.clear(t1.value17)
    table.clear(t1.value18)
end)
