-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("Players")
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

t1.value2 = game:GetService("MarketplaceService")
t1.value3 = game:GetService("ServerStorage")

local OverheadAurionStudio = ReplicatedStorage:WaitForChild("AurionStudio//SummitKitV2//RS"):WaitForChild("SummitSystemReplicatedStorage"):WaitForChild("OverheadAurionStudio")

t1.value4 = require(OverheadAurionStudio:WaitForChild("OverheadConfig_Client"))

local GetTitleDataFunction = OverheadAurionStudio:WaitForChild("GetTitleDataFunction")

t1.value5 = OverheadAurionStudio:WaitForChild("CustomTitleEvent")
t1.value6 = DataStoreService:GetDataStore("CustomTitles_V10")
t1.value7 = DataStoreService:GetDataStore("PlayerRanks_V1")
t1.value8 = DataStoreService:GetDataStore("AdminRoles_v1")
t1.value9 = nil
task.spawn(function()
    local v19 = tick() + 30

    while v19 > tick() do
        local PlayerDataReady = t1.value3:FindFirstChild("PlayerDataReady")

        if PlayerDataReady then
            t1.value9 = PlayerDataReady

            return
        end

        task.wait(0.5)
    end
end)

local t2 = {
	Ranks = {
		[1] = {
			Text = "Owner",
			Mode = "gradient",
			Preset = "aurion"
		}
	}
}
local t3 = {
	Ranks = {
		[1] = {
			Text = "Developer",
			Mode = "gradient",
			Preset = "happiness"
		}
	}
}
local t4 = {
	Ranks = {
		[1] = {
			Text = "Admin",
			Mode = "gradient",
			Preset = "uti"
		}
	}
}
local t5 = {
	Ranks = {
		[1] = {
			Text = "Moderator",
			Mode = "gradient",
			Preset = "acaa"
		}
	}
}
local t6 = {
	Ranks = {
		[1] = {
			Text = "Caster",
			Mode = "gradient",
			Preset = "arctic"
		}
	}
}
t1.value10 = {
	Owner = t2,
	Developer = t3,
	Admin = t4,
	Moderator = t5,
	Caster = t6
}
t1.value11 = 30
t1.value12 = 0.1
t1.value13 = 2
t1.value14 = 90
t1.value15 = 3
t1.value16 = 1
t1.value17 = 0.2
t1.value18 = 12
t1.value19 = 300
t1.value20 = 10
t1.value21 = {
	"Name",
	"Name2",
	"Name3",
	"Name4",
	"Name5",
	"Name6",
	"Name7",
	"Name8",
	"Name9",
	"Name10"
}
function t1.value22()
    local t7 = {}

    for i = 1, t1.value20 do
        t7[i] = "rainbow"
    end

    return t7
end
t1.value23 = nil
function t1.value24()
    local t8 = {}

    for i = 1, t1.value20 do
        t8[i] = {
			R = 255,
			G = 255,
			B = 255
		}
    end

    return t8
end
function t1.value25()
    local t9 = {}

    for i = 1, t1.value20 do
        t9[i] = ""
    end

    return t9
end
t1.value26 = {}
t1.value27 = {}
t1.value28 = {}
t1.value29 = {}
t1.value30 = nil
t1.value31 = {}
t1.value32 = {}
t1.value23 = {}
t1.value33 = {}
t1.value30 = 0
function t1.value34(p1)
    local timestamp = tick()

    if t1.value23[p1] and timestamp - t1.value23[p1] < t1.value17 then
        return false
    end

    if t1.value30 >= t1.value18 then
        return false
    end

    return true
end
function t1.value35()
    t1.value30 = math.max(0, t1.value30 - 1)
end
local function v11(p2, p3, p4)
    if not p3 then
        p3 = t1.value15
    end

    local n1 = 0

    while not t1.value34(p4) and n1 < 3 do
        task.wait(0.1)
        n1 += 0.1
    end

    if not t1.value34(p4) then
        return false, nil
    end

    t1.value23[p4] = tick()

    local _ = t1.value30 + 1
    local n2 = 0

    while n2 < p3 do
        local success, result = pcall(p2)
        if success then
            t1.value35()

            return true, result
        end
        n2 += 1
        if n2 < p3 then
            task.wait(t1.value16 * n2)
        end
    end

    t1.value35()

    return false, nil
end
function t1.value36(p5)
    local v28 = t1.value10[p5]

    if not v28 or not v28.Ranks then
        return nil
    end

    local v29 = t1.value22()
    local v30 = t1.value24()
    local v31 = t1.value25()
    local t11 = {
		IsRoleTitle = true,
		Name = nil,
		Name2 = nil,
		Name3 = nil,
		Name4 = nil,
		Name5 = nil,
		Name6 = nil,
		Name7 = nil,
		Name8 = nil,
		Name9 = nil,
		Name10 = nil,
		Speed = 0.4,
		Modes = v29,
		Colors = v30,
		Presets = v31
	}

    for i = 1, t1.value20 do
        local v34 = i
        local v35 = v28.Ranks[v34]

        if v35 then
            t11[t1.value21[v34]] = v35.Text
            t11.Modes[v34] = v35.Mode or "rainbow"

            if v35.Mode == "gradient" then
                t11.Presets[v34] = v35.Preset or "gold"
                t11.Colors[v34] = {
					R = 255,
					G = 255,
					B = 255
				}
            elseif v35.Mode == "solid" and v35.Color then
                t11.Colors[v34] = v35.Color
            else
                t11.Colors[v34] = {
					R = 255,
					G = 255,
					B = 255
				}
            end
        end
    end

    return t11
end
t1.value37 = nil
function t1.value37(p6)
    local v49, v50 = v11(function()
        return t1.value8:GetAsync("Role_" .. tostring(p6))
    end, 2, "role_get_" .. p6)

    if v49 and v50 then
        return v50
    end

    return nil
end
function t1.value38(p7)
    if t1.value26[p7] ~= nil then
        return t1.value26[p7]
    end

    local v52 = t1.value37(p7)

    t1.value26[p7] = v52 or false

    return v52
end
local AdminRoleChangedEvent = OverheadAurionStudio:FindFirstChild("AdminRoleChangedEvent")

if not AdminRoleChangedEvent then
    AdminRoleChangedEvent = Instance.new("BindableEvent")
    AdminRoleChangedEvent.Name = "AdminRoleChangedEvent"
    AdminRoleChangedEvent.Parent = OverheadAurionStudio
end
AdminRoleChangedEvent.Event:Connect(function(p8, p9)
    t1.value26[p8] = p9 or false
    t1.value33["shared_rank_" .. tostring(p8)] = nil
    t1.value27[p8] = nil
    t1.value28[p8] = nil
end)

local ClearCacheEvent = OverheadAurionStudio:FindFirstChild("ClearCacheEvent")

if not ClearCacheEvent then
    ClearCacheEvent = Instance.new("BindableEvent")
    ClearCacheEvent.Name = "ClearCacheEvent"
    ClearCacheEvent.Parent = OverheadAurionStudio
end
ClearCacheEvent.Event:Connect(function(p10)
    if not p10 then
        return
    end

    t1.value27[p10] = nil
    t1.value28[p10] = nil
    t1.value33["shared_rank_" .. tostring(p10)] = nil

    for k in pairs(t1.value31) do
        local v57 = k

        if p10 == tonumber(v57:match("^(%d+)_")) then
            t1.value31[v57] = nil
        end
    end
end)

local RemoteFunction = Instance.new("RemoteFunction")

RemoteFunction.Name = "GamepassCheckFunction"
RemoteFunction.Parent = OverheadAurionStudio
function RemoteFunction.OnServerInvoke(_, p12, p13)
    local v68 = typeof(p12) ~= "Instance"
    if not v68 then
        v68 = not p12:IsA("Player")
    end
    if v68 then
        return false
    end
    if typeof(p13) ~= "number" then
        return false
    end
    if not p12.Parent then
        return false
    end
    local v69 = p12.UserId .. "_" .. p13
    if t1.value31[v69] ~= nil then
        return t1.value31[v69]
    end
    local t12, v71 = v11(function()
        return t1.value2:UserOwnsGamePassAsync(p12.UserId, p13)
    end, 2, "gamepass_" .. v69)
    if t12 then
        t1.value31[v69] = v71

        return v71
    end

    return false
end
local function v15(p14)
    if not p14 or not p14.Parent then
        return nil
    end

    local UserId = p14.UserId
    local v79 = t1.value27[UserId]

    if v79 then
        v79 = t1.value27[UserId].LoadedFromDS
    end

    if v79 then
        return t1.value27[UserId].Data
    end

    local v80, v81 = v11(function()
        return t1.value6:GetAsync("Title_" .. UserId)
    end, 2, "title_load_" .. UserId)

    if v80 and v81 then
        return v81
    end

    return {
		Title = nil,
		Preset = "inferno",
		ExpireTime = "perm"
	}
end
function t1.value39(p15, p16)
    local v74 = not p15
    if not v74 then
        v74 = not p15.Parent
    end
    if v74 then
        return false
    end
    local UserId = p15.UserId
    local u76 = UserId

    return (v11(function()
        t1.value6:SetAsync("Title_" .. u76, p16)

        return true
    end, 3, "title_save_" .. u76))
end
function t1.value40(p17, p18)
    local v84 = not p17
    if not v84 then
        v84 = not p17.Parent
    end
    if v84 then
        return false
    end
    local v85 = p18 or t1.value11
    if t1.value28[p17.UserId] then
        return true
    end
    local timestamp = tick()
    local u87 = false
    local connection
    if t1.value9 then
        connection = t1.value9.Event:Connect(function(p19)
            if p19 == p17.UserId then
                u87 = true
            end
        end)
    end
    while not u87 and v85 > tick() - timestamp do
        local v89 = not p17

        if not v89 then
            v89 = not p17.Parent
        end

        if v89 then
            break
        end

        task.wait(t1.value12)
    end
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
    end
    if u87 then
        t1.value28[p17.UserId] = true

        return true
    end
    local leaderstats = p17:FindFirstChild("leaderstats")
    if leaderstats then
        local Summit = leaderstats:FindFirstChild("Summit")

        if Summit then
            Summit = leaderstats:FindFirstChild("Position")
        end

        leaderstats = Summit
    end
    if leaderstats then
        t1.value28[p17.UserId] = true

        return true
    end

    return false
end
function GetTitleDataFunction.OnServerInvoke(player, p20, p21)
    if not player or not player.Parent then
        return nil
    end

    local v98 = p20 ~= nil

    if v98 then
        v98 = typeof(p20) ~= "Instance"

        if not v98 then
            v98 = not p20:IsA("Player")
        end
    end

    if v98 then
        return nil
    end

    local v99 = p20 or player

    if not v99 or not v99.Parent then
        return nil
    end

    if p21 == "summit" then
        local v100 = t1.value27[v99.UserId]

        if v100 and v100.Summit then
            return v100.Summit
        end

        local leaderstats = v99:FindFirstChild("leaderstats")

        if leaderstats then
            local Summit = leaderstats:FindFirstChild("Summit")

            if Summit then
                return Summit.Value
            end
        end

        return 0
    end

    if t1.value38(v99.UserId) then
        return {
			Title = nil,
			Gradient = nil,
			Summit = 0
		}
    end

    local v103 = t1.value27[v99.UserId]
    local v104 = v103

    if v103 then
        v104 = v103.Title

        if v104 then
            v104 = v103.CacheTime

            if v104 then
                v104 = tick() - v103.CacheTime < 45
            end
        end
    end

    if v104 then
        local Title = v103.Title
        local Gradient = v103.Gradient
        local v107 = v103.Summit or 0

        return {
			Title = Title,
			Gradient = Gradient,
			Summit = v107
		}
    end

    if not t1.value28[v99.UserId] and not t1.value40(v99, 15) then
        return {
			Title = nil,
			Gradient = nil,
			Summit = 0
		}
    end

    local n3 = 0
    local leaderstats = v99:FindFirstChild("leaderstats")

    if leaderstats then
        local Summit = leaderstats:FindFirstChild("Summit")

        if Summit then
            n3 = Summit.Value
        end
    end

    local v111 = v15(v99)

    if v111 and v111.Title then
        local v112 = v111.Preset or "inferno"
        local v113 = t1.value4.CustomTitleColors[v112]
        local Title = v111.Title
        local timestamp = tick()
        local t13 = {
			Title = Title,
			Gradient = v113,
			Summit = n3,
			CacheTime = timestamp,
			LoadedFromDS = true,
			Data = v111
		}

        t1.value27[v99.UserId] = t13

        local t13Title = t13.Title
        local Gradient = t13.Gradient
        local Summit = t13.Summit

        return {
			Title = t13Title,
			Gradient = Gradient,
			Summit = Summit
		}
    end

    local timestamp = tick()
    local t14 = {
		Title = nil,
		Gradient = nil,
		Summit = n3,
		CacheTime = timestamp
	}

    t1.value27[v99.UserId] = t14

    local t14Title = t14.Title
    local Gradient = t14.Gradient
    local Summit = t14.Summit

    return {
		Title = t14Title,
		Gradient = Gradient,
		Summit = Summit
	}
end
local RemoteFunction2 = Instance.new("RemoteFunction")

RemoteFunction2.Name = "GetRankDataFunction"
RemoteFunction2.Parent = OverheadAurionStudio
function t1.value41(p22)
    local v130 = t1.value22()
    local v131 = t1.value24()
    local v132 = t1.value25()
    local t15 = {
		Name = nil,
		Name2 = nil,
		Name3 = nil,
		Name4 = nil,
		Name5 = nil,
		Name6 = nil,
		Name7 = nil,
		Name8 = nil,
		Name9 = nil,
		Name10 = nil,
		Speed = 0.4,
		Modes = v130,
		Colors = v131,
		Presets = v132
	}
    local t16 = {}
    for v137, v138 in pairs(p22.Ranks or {}) do

        local num = tonumber(v137)
        local v140 = num

        if num then
            v140 = num >= 1 and num <= t1.value20
        end

        if v140 then
            t16[num] = v138
        end
    end
    for i = 1, t1.value20 do
        local v142 = i
        local v143 = t16[v142]

        if v143 then
            t15[t1.value21[v142]] = v143.Text
            t15.Modes[v142] = v143.Mode or "rainbow"

            if v143.Mode == "solid" and v143.Color then
                t15.Colors[v142] = v143.Color
            elseif v143.Mode == "gradient" then
                local Preset = v143.Preset

                if Preset then
                    Preset = v143.Preset ~= ""
                end

                if Preset then
                    t15.Presets[v142] = v143.Preset
                else
                    t15.Presets[v142] = "inferno"
                end

                t15.Colors[v142] = {
					R = 255,
					G = 255,
					B = 255
				}
            else
                t15.Colors[v142] = {
					R = 255,
					G = 255,
					B = 255
				}
            end
        end
    end

    return t15
end
function t1.value42(p23)
    if type(p23.Ranks) ~= "table" then
        return false
    end

    for _, v in pairs(p23.Ranks) do
        local v128 = v.Mode == "gradient"

        if v128 then
            v128 = not v.Preset

            if not v128 then
                v128 = v.Preset == ""
            end
        end

        if v128 then
            return true
        end
    end

    return false
end
function RemoteFunction2.OnServerInvoke(_, p25, p26)
    if typeof(p25) ~= "Instance" or not p25:IsA("Player") then
        return nil
    end

    if not p25.Parent then
        return nil
    end

    local UserId = p25.UserId

    if p26 ~= "custom" then
        local v149 = t1.value38(UserId)

        if v149 then
            local v150 = t1.value36(v149)

            if v150 then
                return v150
            end
        end
    end

    local v151 = "shared_rank_" .. UserId
    local v152 = t1.value33[v151]
    local v153 = v152

    if v152 then
        v153 = tick() - v152.Time < t1.value19
    end

    if v153 then
        local Data = v152.Data

        if Data and Data.Ranks then
            if not t1.value42(Data) then
                return t1.value41(Data)
            end

            t1.value33[v151] = nil
        end
    end

    local v155, v156 = v11(function()
        return t1.value7:GetAsync("Rank_" .. UserId)
    end, 2, "rank_get_" .. UserId)

    if v155 then
        v155 = v156 and v156.Ranks
    end

    if v155 then
        local value33 = t1.value33
        local timestamp = tick()

        value33[v151] = {
			Data = v156,
			Time = timestamp
		}

        return t1.value41(v156)
    end

    return nil
end
function t1.value43(p27, p28, p29, p30)
    local v163 = not p27

    if not v163 then
        v163 = not p27.Parent
    end

    if v163 then
        return false
    end

    local v164 = p29 or "inferno"

    if not t1.value4.CustomTitleColors[v164] then
        return false
    end

    if not t1.value40(p27, 8) then
        return false
    end

    local v165 = p30 or "perm"
    local t17 = {
		Title = p28,
		Preset = v164,
		ExpireTime = v165
	}

    if not t1.value39(p27, t17) then
        return false
    end

    local v167 = t1.value4.CustomTitleColors[v164]
    local n4 = 0
    local leaderstats = p27:FindFirstChild("leaderstats")

    if leaderstats then
        local Summit = leaderstats:FindFirstChild("Summit")

        if Summit then
            n4 = Summit.Value
        end
    end

    local value27 = t1.value27
    local UserId = p27.UserId
    local timestamp = tick()

    value27[UserId] = {
		Title = p28,
		Gradient = v167,
		Summit = n4,
		CacheTime = timestamp,
		LoadedFromDS = true,
		Data = t17
	}
    task.spawn(function()
        pcall(function()
            local v245 = p27

            if v245 then
                v245 = p27.Parent
            end

            if v245 then
                t1.value5:FireAllClients(p27, p28, v167)
            end
        end)
    end)

    return true
end
function t1.value44(p31)
    local v196 = not p31

    if not v196 then
        v196 = not p31.Parent
    end

    if v196 then
        return false
    end

    t1.value39(p31, {
		Title = nil,
		Preset = "inferno",
		ExpireTime = "perm"
	})
    t1.value27[p31.UserId] = nil
    task.spawn(function()
        pcall(function()
            local v248 = p31

            if v248 then
                v248 = p31.Parent
            end

            if v248 then
                t1.value5:FireAllClients(p31, nil, nil)
            end
        end)
    end)

    return true
end
function t1.value45(p32, p33)
    local v176 = not p32

    if not v176 then
        v176 = not p32.Parent
    end

    if v176 then
        return
    end

    if t1.value38(p32.UserId) then
        return
    end

    local v177 = not p33 and 15 or 8

    if not t1.value40(p32, v177) then
        return
    end

    local _task = task
    local v179 = p33 and 0.2

    _task.wait(v179 or 0.8)

    local v180 = not p32

    if not v180 then
        v180 = not p32.Parent
    end

    if v180 then
        return
    end

    local v181 = t1.value27[p32.UserId]
    local v182 = v181

    if v182 then
        v182 = v181.Title

        if v182 then
            v182 = v181.CacheTime

            if v182 then
                v182 = tick() - v181.CacheTime < 180
            end
        end
    end

    if v182 then
        task.spawn(function()
            pcall(function()
                local v246 = p32

                if v246 then
                    v246 = p32.Parent
                end

                if v246 then
                    t1.value5:FireAllClients(p32, v181.Title, v181.Gradient)
                end
            end)
        end)

        return
    end

    local v183 = v15(p32)
    local v184 = v183

    if v184 then
        v184 = v183.Title
    end

    if v184 then
        local v185 = v183.Preset or "inferno"
        local v186 = t1.value4.CustomTitleColors[v185]
        local n5 = 0
        local leaderstats = p32:FindFirstChild("leaderstats")

        if leaderstats then
            local Summit = leaderstats:FindFirstChild("Summit")

            if Summit then
                n5 = Summit.Value
            end
        end

        local value27 = t1.value27
        local UserId = p32.UserId
        local Title = v183.Title
        local timestamp = tick()

        value27[UserId] = {
			Title = Title,
			Gradient = v186,
			Summit = n5,
			CacheTime = timestamp,
			LoadedFromDS = true,
			Data = v183
		}
        task.spawn(function()
            pcall(function()
                local v247 = p32

                if v247 then
                    v247 = p32.Parent
                end

                if v247 then
                    t1.value5:FireAllClients(p32, v183.Title, v186)
                end
            end)
        end)
    end
end
function t1.value46(p34)
    if not p34 or not p34.Parent then
        return false
    end

    if p34.UserId == game.CreatorId then
        return true
    end

    if t1.value38(p34.UserId) then
        return true
    end

    return false
end
function t1.value47(p35)
    local v198 = p35:lower()

    for _, player in ipairs(t1.value1:GetPlayers()) do
        local v201 = player.Name:lower():find(v198, 1, true)

        if not v201 then
            v201 = player.DisplayName and player.DisplayName:lower():find(v198, 1, true)
        end

        if v201 then
            return player
        end
    end

    return nil
end
function t1.value48(p36)
    local UserId = p36.UserId
    local v94 = t1.value29[UserId]

    if v94 and tick() - v94 < t1.value13 then
        return false
    end

    t1.value29[UserId] = tick()

    return true
end
t1.value49 = nil
function t1.value49(p37)
    local v206 = not p37
    if not v206 then
        v206 = not p37.Parent
    end
    if v206 then
        return
    end
    local connection
    connection = p37.Chatted:Connect(function(message)
        local v236 = not p37

        if not v236 then
            v236 = not p37.Parent
        end

        if v236 then
            local v237 = connection

            if v237 then
                v237 = connection.Connected
            end

            if v237 then
                pcall(function()
                    connection:Disconnect()
                end)
            end

            return
        end

        if not t1.value46(p37) then
            return
        end

        if not t1.value48(p37) then
            return
        end

        local parts = message:split(" ")
        local v239 = parts[1]:lower()

        if v239 == "!settitle" then
            if #parts < 3 then
                return
            end

            local v240 = parts[2]
            local v241 = parts[3]

            if #v241 > 20 then
                return
            end

            local v242 = parts[4] or "inferno"
            local v243 = t1.value47(v240)

            if v243 then
                t1.value43(v243, v241, v242)

                return
            end
        elseif v239 == "!removetitle" then
            if #parts < 2 then
                return
            end

            local v244 = t1.value47(parts[2])

            if v244 then
                t1.value44(v244)
            end
        end
    end)
    if not t1.value32[p37.UserId] then
        t1.value32[p37.UserId] = {}
    end
    table.insert(t1.value32[p37.UserId], connection)
end
function t1.value50(p38)
    if not p38 then
        return
    end

    if t1.value32[p38] then
        for _, v in ipairs(t1.value32[p38]) do
            local v61 = v
            local v62 = v61

            if v62 then
                v62 = typeof(v61) == "RBXScriptConnection"

                if v62 then
                    v62 = v61.Connected
                end
            end

            if v62 then
                pcall(function()
                    v61:Disconnect()
                end)
            end
        end

        t1.value32[p38] = nil
    end

    t1.value28[p38] = nil
    t1.value29[p38] = nil

    for k in pairs(t1.value31) do
        local v64 = k

        if p38 == tonumber(v64:match("^(%d+)_")) then
            t1.value31[v64] = nil
        end
    end

    task.delay(t1.value14, function()
        if not t1.value1:GetPlayerByUserId(p38) then

            t1.value27[p38] = nil
        end
    end)
end
function t1.value51(p39)
    local v203 = not p39
    if not v203 then
        v203 = not p39.Parent
    end
    if v203 then
        return
    end
    if not t1.value32[p39.UserId] then
        t1.value32[p39.UserId] = {}
    end
    task.spawn(function()
        local v231 = t1.value37(p39.UserId)

        t1.value26[p39.UserId] = v231 or false
    end)
    t1.value49(p39)
    task.spawn(function()
        if not t1.value40(p39, t1.value11) then
            return
        end

        task.wait(1.5)

        local v232 = p39

        if v232 then
            v232 = p39.Parent
        end

        if v232 then
            t1.value45(p39, false)
        end
    end)
    local connection
    connection = p39.CharacterAdded:Connect(function()
        local v233 = not p39

        if not v233 then
            v233 = not p39.Parent
        end

        if v233 then
            local v234 = connection

            if v234 then
                v234 = connection.Connected
            end

            if v234 then
                pcall(function()
                    connection:Disconnect()
                end)
            end

            return
        end

        task.spawn(function()
            t1.value45(p39, true)
        end)
    end)
    table.insert(t1.value32[p39.UserId], connection)
end
t1.value1.PlayerAdded:Connect(function(player)
    task.spawn(t1.value51, player)
end)

for _, player in ipairs(t1.value1:GetPlayers()) do
    task.spawn(t1.value51, player)
end
t1.value1.PlayerRemoving:Connect(function(player)
    if not player then
        return
    end

    t1.value26[player.UserId] = nil
    t1.value50(player.UserId)
end)
task.spawn(function()
    while true do
        task.wait(180)
        local t18 = {}
        local timestamp = tick()
        for v214, v215 in ipairs(t1.value1:GetPlayers()) do

            t18[v215.UserId] = true
        end
        for k in pairs(t1.value31) do
            local v217 = k
            local num = tonumber(v217:match("^(%d+)_"))

            if num and not t18[num] then
                t1.value31[v217] = nil
            end
        end
        for v221, v222 in pairs(t1.value29) do

            if tick() - v222 > 1800 and not t18[v221] then
                t1.value29[v221] = nil
            end
        end
        for v225, v226 in pairs(t1.value23) do

            if timestamp - v226 > 180 then
                t1.value23[v225] = nil
            end
        end
        for k, v in pairs(t1.value33) do
            if timestamp - v.Time > t1.value19 then
                t1.value33[k] = nil
            end
        end
    end
end)
