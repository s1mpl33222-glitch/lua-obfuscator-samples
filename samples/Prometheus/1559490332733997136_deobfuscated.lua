-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = 7994,
	value2 = nil,
	value2 = 3198
}
function t1.value3(p1, p2, p3)
    return bit32.bxor(p1, t1.value1) + bit32.bxor(p2, t1.value2) * 65536 + bit32.bxor(p3, t1.value1) * 4294967296
end
t1.value4 = {
	a = 4933,
	b = 63370,
	c = 57323
}
t1.value5 = nil
function t1.value5(p4)
    local n1 = 0

    while p4 > 0 do
        n1 += p4 % 10
        p4 = math.floor(p4 / 10)
    end

    return n1 % 97
end
function t1.value6()
    local v49 = game.CreatorId == t1.value3(t1.value4.a, t1.value4.b, t1.value4.c)

    if v49 then
        v49 = t1.value5(t1.value3(t1.value4.a, t1.value4.b, t1.value4.c)) == 46
    end

    return v49
end
local HttpService = game:GetService("HttpService")

t1.value7 = nil
t1.value7 = HttpService
function t1.value8()
    local ok, result = pcall(function()
        return t1.value7:GetAsync("https://license-server1-production.up.railway.app/check?creatorId=" .. tostring(game.CreatorId), true)
    end)
    local v52 = result

    if not ok or not v52 then
        return nil
    end

    local ok2, result2 = pcall(function()
        return t1.value7:JSONDecode(v52)
    end)

    if not ok2 then
        return nil
    end

    return result2 and result2.valid == true
end
task.spawn(function()
    if t1.value6() then
        return
    end

    local v55 = t1.value8()

    if v55 == nil then
        return
    end

    if not v55 then
        local Players = game:GetService("Players")
        local GetPlayers = Players.GetPlayers

        for _, v in ipairs(GetPlayers(Players)) do
            v:Kick("Game tidak berlisensi.")
        end

        Players.PlayerAdded:Connect(function(player)
            player:Kick("Game tidak berlisensi.")
        end)
    end
end)

local AdminConfig = require(script:WaitForChild("AdminConfig"))

t1.value9 = AdminConfig.OWNER_USERIDS
t1.value10 = AdminConfig.ROLE_HIERARCHY
t1.value11 = AdminConfig.CFG
t1.value12 = game:GetService("Players")
t1.value13 = game:GetService("ReplicatedStorage")

local DataStoreService = game:GetService("DataStoreService")

game:GetService("MarketplaceService")
t1.value14 = game:GetService("ServerStorage")
t1.value15 = game:GetService("MessagingService")
t1.value16 = {}
for _, v in ipairs(AdminConfig.VALID_PRESETS) do
    t1.value16[v] = true
end
t1.value17 = DataStoreService:GetDataStore(AdminConfig.DATASTORE_NAMES.Role)
t1.value18 = DataStoreService:GetDataStore(AdminConfig.DATASTORE_NAMES.Master)
t1.value19 = DataStoreService:GetOrderedDataStore(AdminConfig.DATASTORE_NAMES.Summit)
t1.value20 = DataStoreService:GetOrderedDataStore(AdminConfig.DATASTORE_NAMES.Time)
t1.value21 = DataStoreService:GetDataStore(AdminConfig.DATASTORE_NAMES.Rank)
t1.value22 = DataStoreService:GetDataStore(AdminConfig.DATASTORE_NAMES.VIPGift)

local AdminPanelRemotes = t1.value13:FindFirstChild("AdminPanelRemotes")

if not AdminPanelRemotes then
    AdminPanelRemotes = Instance.new("Folder")
    AdminPanelRemotes.Name = "AdminPanelRemotes"
    AdminPanelRemotes.Parent = t1.value13
end
t1.value23 = AdminPanelRemotes
local function v8(p5, p6)
    local p6_2 = t1.value23:FindFirstChild(p6)

    if p6_2 then
        return p6_2
    end

    local v63 = Instance.new(p5)

    v63.Name = p6
    v63.Parent = t1.value23

    return v63
end
local v9 = v8("RemoteFunction", "GetRole")
local v10 = v8("RemoteFunction", "GetRoleForUser")
local v11 = v8("RemoteFunction", "GetAllAdmins")
local v12 = v8("RemoteFunction", "SearchPlayer")
local v13 = v8("RemoteFunction", "GetOnlinePlayers")
local v14 = v8("RemoteFunction", "SearchSummitPlayer")
local v15 = v8("RemoteFunction", "GetPlayerSummit")
local v16 = v8("RemoteFunction", "GetOnlineForTitle")
local v17 = v8("RemoteFunction", "SearchTitlePlayer")
local v18 = v8("RemoteFunction", "RankManagerFunction")
local v19 = v8("RemoteFunction", "GetTeleportList")
local v20 = v8("RemoteFunction", "GetVIPGiftList")
local t2 = {
	GetRole = v9,
	GetRoleForUser = v10,
	GetAllAdmins = v11,
	SearchPlayer = v12,
	GetOnlinePlayers = v13,
	SearchSummit = v14,
	GetPlayerSummit = v15,
	GetOnlineTitle = v16,
	SearchTitle = v17,
	RankManager = v18,
	GetTeleportList = v19,
	GetVIPGiftList = v20
}
local v22 = v8("RemoteEvent", "RoleUpdated")
local v23 = v8("RemoteEvent", "AddRole")
local v24 = v8("RemoteEvent", "RemoveRole")
local v25 = v8("RemoteEvent", "AdminListUpdated")
local v26 = v8("RemoteEvent", "NotifyClient")
local v27 = v8("RemoteEvent", "SendMessage")
local v28 = v8("RemoteEvent", "ReceiveMessage")
local v29 = v8("RemoteEvent", "AddSummit")
local v30 = v8("RemoteEvent", "RemoveSummit")
local v31 = v8("RemoteEvent", "ResetSummit")
local v32 = v8("RemoteEvent", "ResetBestTime")
local v33 = v8("RemoteEvent", "TeleportAdmin")
local v34 = v8("RemoteEvent", "GiftVIP")
local v35 = v8("RemoteEvent", "RemoveVIPGift")
local v36 = v8("RemoteEvent", "VIPGiftListUpdated")

t1.value24 = {
	RoleUpdated = v22,
	AddRole = v23,
	RemoveRole = v24,
	AdminListUpdated = v25,
	NotifyClient = v26,
	SendMessage = v27,
	ReceiveMessage = v28,
	AddSummit = v29,
	RemoveSummit = v30,
	ResetSummit = v31,
	ResetBestTime = v32,
	TeleportAdmin = v33,
	GiftVIP = v34,
	RemoveVIPGift = v35,
	VIPGiftListUpdated = v36
}
t1.value25 = {}
t1.value26 = {}
t1.value27 = {}
t1.value28 = nil
t1.value29 = nil
t1.value30 = nil
t1.value31 = nil
t1.value32 = nil
t1.value33 = {}
t1.value34 = nil
t1.value35 = AdminConfig.VIP_ITEM_KEY
task.spawn(function()
    local n2 = 0

    while not _G.ShopAPI and n2 < 30 do
        task.wait(1)
        n2 += 1
    end

    t1.value34 = _G.ShopAPI
end)

function t1.value36(p7, p8)
    local v98 = tostring(p7) .. "_" .. p8
    local timestamp = tick()
    local v100 = t1.value27[v98]

    if not v100 then
        t1.value27[v98] = {
			count = 1,
			t = timestamp
		}

        return true
    end

    if timestamp - v100.t >= t1.value11.RATE_WINDOW then
        v100.count = 1
        v100.t = timestamp

        return true
    end

    local s1 = "count"

    v100[s1] = v100[s1] + 1

    return v100.count <= t1.value11.RATE_MAX
end
function t1.value37(p9)
    local v103 = tostring(p9) .. "_"
    local t3 = {}
    for v107 in pairs(t1.value27) do

        if v103 == v107:sub(1, #v103) then
            table.insert(t3, v107)
        end
    end
    for _, v in ipairs(t3) do
        t1.value27[v] = nil
    end
end
task.spawn(function()
    while true do
        task.wait(120)
        local timestamp = tick()
        local t4 = {}
        for v128, v129 in pairs(t1.value27) do

            if timestamp - v129.t > t1.value11.RATE_WINDOW * 4 then
                table.insert(t4, v128)
            end
        end
        for _, v in ipairs(t4) do
            t1.value27[v] = nil
        end
    end
end)

local function v37(p10, p11)
    if type(p10) ~= "string" then
        return false
    end

    local v145 = #p10 < 1

    if not v145 then
        v145 = (p11 or 100) < #p10
    end

    if v145 then
        return false
    end

    for _, v in ipairs({
		10,
		13,
		9,
		0
	}) do
        if p10:find(string.char(v)) then
            return false
        end
    end

    return true
end
function t1.value38(p12)
    local v137 = type(p12) == "number"

    if v137 then
        v137 = p12 > 0

        if v137 then
            v137 = p12 == math.floor(p12)
        end
    end

    return v137
end
function t1.value39(p13)
    local v133 = type(p13) == "number"

    if v133 then
        v133 = p13 > 0

        if v133 then
            v133 = p13 == math.floor(p13)

            if v133 then
                v133 = p13 <= t1.value11.MAX_SUMMIT
            end
        end
    end

    return v133
end
function t1.value40(p14)
    if type(p14) ~= "table" then
        return false
    end

    for _, v in ipairs({
		"R",
		"G",
		"B"
	}) do
        local v151 = p14[v]
        local v152 = type(v151) ~= "number"

        if not v152 then
            v152 = v151 < 0

            if not v152 then
                v152 = v151 > 255

                if not v152 then
                    v152 = v151 ~= math.floor(v151)
                end
            end
        end

        if v152 then
            return false
        end
    end

    return true
end
function t1.value41(p15)
    if type(p15) ~= "table" then
        return {}
    end

    local t5 = {}

    for k, v in pairs(p15) do
        local num = tonumber(k)
        local v123 = num

        if num then
            v123 = num >= 1

            if v123 then
                v123 = num <= t1.value11.MAX_RANKS

                if v123 then
                    v123 = type(v) == "table"
                end
            end
        end

        if v123 then
            t5[num] = v
        end
    end

    return t5
end
function t1.value42(p16)
    if type(p16) ~= "table" then
        return false, "data harus table"
    end
    if type(p16.Ranks) ~= "table" then
        return false, "Ranks harus table"
    end
    local n3 = 0
    for v157 in pairs(p16.Ranks) do

        n3 += 1
    end
    if n3 == 0 then
        return false, "Minimal 1 rank"
    end
    if n3 > t1.value11.MAX_RANKS then
        return false, "Maksimal " .. t1.value11.MAX_RANKS .. " rank"
    end
    for k, v in pairs(p16.Ranks) do
        local v160 = k
        local v161 = type(v160) ~= "number"

        if not v161 then
            v161 = v160 < 1

            if not v161 then
                v161 = v160 > t1.value11.MAX_RANKS
            end
        end

        if v161 then
            return false, "Index rank tidak valid"
        end

        if type(v) ~= "table" then
            return false, "Rank " .. v160 .. " harus table"
        end

        if not v37(v.Text, t1.value11.MAX_RANK_TEXT) then
            return false, "Rank " .. v160 .. " teks tidak valid"
        end

        local v162 = v.Text:find("<")

        if not v162 then
            v162 = v.Text:find(">")
        end

        if v162 then
            return false, "Rank " .. v160 .. " mengandung karakter terlarang"
        end

        local vMode = v.Mode
        local v164 = vMode ~= "rainbow"

        if v164 then
            v164 = vMode ~= "gradient" and vMode ~= "solid"
        end

        if v164 then
            return false, "Rank " .. v160 .. " mode tidak valid"
        end

        if vMode == "gradient" then
            local v165 = type(v.Preset) ~= "string"

            if not v165 then
                v165 = not t1.value16[v.Preset:lower()]
            end

            if v165 then
                return false, "Rank " .. v160 .. " preset tidak valid"
            end
        end

        local v166 = vMode == "solid"

        if v166 then
            v166 = not t1.value40(v.Color)
        end

        if v166 then
            return false, "Rank " .. v160 .. " warna tidak valid"
        end
    end

    return true, "ok"
end
function t1.value43(p17)
    local v139, v140, v141 = ipairs(t1.value9)

    repeat
        local v142

        v141, v142 = v139(v140, v141)

        if not v141 then
            return false
        end
    until v142 == p17

    return true
end
function t1.value44(p18)
    return t1.value10[p18] or 0
end
function t1.value45(p19)
    if not p19 or not p19.Parent then
        return nil
    end

    return t1.value25[p19.UserId]
end
function t1.value46(p20, p21)
    local v174 = t1.value45(p20)

    return v174 ~= nil and t1.value44(v174) >= t1.value44(p21)
end
function t1.value47(p22, p23, p24)
    local v90 = p22

    if p22 then
        v90 = p22.Parent
    end

    if v90 then
        t1.value24.NotifyClient:FireClient(p22, p23, p24)
    end
end
function t1.value48(p25, p26, p27, p28)
    for _, v in ipairs(t1.value26) do
        if p25 == v.userId then
            v.role = p26
            v.username = p27
            v.displayName = p28

            return
        end
    end

    table.insert(t1.value26, {
		userId = p25,
		role = p26,
		username = p27,
		displayName = p28
	})
end
function t1.value49(p29)
    for i, v in ipairs(t1.value26) do
        if p29 == v.userId then
            table.remove(t1.value26, i)

            return
        end
    end
end
function t1.value50()
    task.spawn(function()
        pcall(function()
            t1.value18:SetAsync("MasterList", t1.value26)
        end)
    end)
end
function t1.value51()
    for _, player in ipairs(t1.value12:GetPlayers()) do
        if t1.value25[player.UserId] then
            t1.value24.AdminListUpdated:FireClient(player, t1.value26)
        end
    end
end
function t1.value52(p30, p31)
    task.spawn(function()
        pcall(function()
            if p31 then
                t1.value17:SetAsync("Role_" .. p30, p31)

                return
            end

            t1.value17:RemoveAsync("Role_" .. p30)
        end)
    end)
end
local function v38(p32)
    local UserId = p32.UserId

    if t1.value43(UserId) then
        t1.value25[UserId] = "Owner"
        t1.value48(UserId, "Owner", p32.Name, p32.DisplayName)
        t1.value50()
        t1.value52(UserId, "Owner")
        task.delay(2, function()
            local v448 = p32

            if v448 then
                v448 = p32.Parent
            end

            if v448 then
                t1.value51()
            end
        end)

        return "Owner"
    end

    local ok, result = pcall(function()
        return t1.value17:GetAsync("Role_" .. UserId)
    end)

    if ok then
        ok = t1.value10[result]
    end

    if ok then
        t1.value25[UserId] = result
        t1.value48(UserId, result, p32.Name, p32.DisplayName)
        t1.value50()

        return result
    end

    t1.value25[UserId] = nil

    return nil
end
function t1.value53(p33)
    if not p33 or not p33.Parent then
        return
    end

    if p33.PlayerGui:FindFirstChild("AdminPanelGui") then
        return
    end

    local AdminPanelGui = t1.value14:FindFirstChild("AdminPanelGui")

    if not AdminPanelGui then
        return
    end

    AdminPanelGui:Clone().Parent = p33.PlayerGui
end
function t1.value54(p34)
    if not p34 or not p34.Parent then
        return
    end

    local AdminPanelGui = p34.PlayerGui:FindFirstChild("AdminPanelGui")

    if AdminPanelGui then
        AdminPanelGui:Destroy()
    end
end
function t1.value55(p35)
    local v92 = not p35

    if not v92 then
        v92 = not p35.Parent
    end

    if v92 then
        return
    end

    task.spawn(function()
        if t1.value31 then
            pcall(function()
                t1.value31:Fire(p35.UserId)
            end)
        end

        task.wait(0.4)

        local v443 = not p35

        if not v443 then
            v443 = not p35.Parent
        end

        if v443 then
            return
        end

        local v444 = t1.value13:FindFirstChild("AurionStudio//SummitKitV2//RS")
        local v445 = v444 and v444:FindFirstChild("SummitSystemReplicatedStorage")

        if v445 then
            v445 = v445:FindFirstChild("OverheadAurionStudio")
        end

        if not v445 then
            return
        end

        local RecreateOverheadEvent = v445:FindFirstChild("RecreateOverheadEvent")

        if not RecreateOverheadEvent then
            return
        end

        pcall(function()
            RecreateOverheadEvent:FireAllClients(p35)
        end)
        task.wait(0.4)

        local v447 = p35

        if v447 then
            v447 = p35.Parent
        end

        if v447 then
            pcall(function()
                RecreateOverheadEvent:FireAllClients(p35)
            end)
        end
    end)
end
task.spawn(function()
    local ok, result = pcall(function()
        return t1.value13:WaitForChild("AurionStudio//SummitKitV2//RS"):WaitForChild("SummitSystemReplicatedStorage"):WaitForChild("OverheadAurionStudio", 30)
    end)
    local v209 = result

    if not ok or not v209 then
        return
    end

    local function v210(p36)
        local p36_2 = v209:FindFirstChild(p36)

        if not p36_2 then
            p36_2 = Instance.new("BindableEvent")
            p36_2.Name = p36
            p36_2.Parent = v209
        end

        return p36_2
    end

    v210("ClearCacheEvent")
    t1.value32 = v210("AdminRoleChangedEvent")
end)
task.spawn(function()
    local ok, result = pcall(function()
        return t1.value13:WaitForChild("CheckpointRemotes", 30)
    end)
    local v213 = result
    if not ok or not v213 then
        return
    end
    local success = pcall(function()
        return v213:WaitForChild("AdminGetPlayerData", 15)
    end)
    if not success then
    end
    local ok3, result3 = pcall(function()
        return v213:WaitForChild("AdminSetPlayerData", 15)
    end)
    if ok3 then
        t1.value29 = result3
    end
    local ok4, _ = pcall(function()
        return v213:WaitForChild("AdminPatchData", 15)
    end)
    if not ok4 then
    end
end)

local v39 = (function()
    local ok, result = pcall(function()
        return workspace:WaitForChild("AurionStudio//SummitKitV2//WS", 15):WaitForChild("SummitSystemAurionStudio", 15)
    end)
    local v223 = not ok

    if not v223 then
        v223 = not result
    end

    if v223 then
        return nil
    end

    local Checkpoints = result:FindFirstChild("Checkpoints")
    local Summits = result:FindFirstChild("Summits")

    return {
		Checkpoints = Checkpoints,
		Summits = Summits
	}
end)()
t1.value56 = nil
t1.value56 = v39
function t1.value57(p37)
    return tonumber(string.match(p37, "%d+")) or 0
end
function t1.value58()
    local v240 = not t1.value56
    local t7 = {}
    if not v240 then
        v240 = not t1.value56.Checkpoints
    end
    if v240 then
        return t7
    end
    local t8 = {}
    for v245, v246 in ipairs(t1.value56.Checkpoints:GetChildren()) do

        local v247 = v246:IsA("BasePart")

        if not v247 then
            v247 = v246:IsA("Model")

            if v247 then
                v247 = v246:FindFirstChild("CPTouch")
            end
        end

        if v247 then
            local v248 = t1.value57(v246.Name)

            if v248 > 0 then
                table.insert(t8, {
					Name = v246.Name,
					Num = v248
				})
            end
        end
    end
    table.sort(t8, function(p38, p39)
        return p38.Num < p39.Num
    end)
    for i, v in ipairs(t8) do
        local vName = v.Name
        local v252 = "Checkpoint " .. i

        t7[i] = {
			Name = vName,
			Label = v252
		}
    end

    return t7
end
t1.value59 = nil
function t1.value59()
    local t9 = {}
    local v233 = not t1.value56

    if not v233 then
        v233 = not t1.value56.Summits
    end

    if v233 then
        return t9
    end

    for _, child in ipairs(t1.value56.Summits:GetChildren()) do
        local v236 = child:IsA("BasePart")

        if not v236 then
            v236 = child:IsA("Model")
        end

        if v236 then
            local insert = table.insert
            local childName = child.Name
            local childName2 = child.Name

            insert(t9, {
				Name = childName,
				Label = childName2
			})
        end
    end

    table.sort(t9, function(p40, p41)
        return p40.Name < p41.Name
    end)

    return t9
end
function t1.value60(p42)
    local value56 = t1.value56

    if value56 then
        value56 = t1.value56.Checkpoints
    end

    if value56 then
        local p42_2 = t1.value56.Checkpoints:FindFirstChild(p42)

        if p42_2 then
            local v229 = p42_2:IsA("Model")

            if v229 then
                v229 = p42_2:FindFirstChild("CPTouch") or p42_2:FindFirstChildWhichIsA("BasePart")
            end

            return v229 or p42_2
        end
    end

    local value56_2 = t1.value56

    if value56_2 then
        value56_2 = t1.value56.Summits
    end

    if value56_2 then
        local p42_3 = t1.value56.Summits:FindFirstChild(p42)

        if p42_3 then
            return p42_3:IsA("Model") and p42_3:FindFirstChildWhichIsA("BasePart") or p42_3
        end
    end

    return nil
end
function t1.value61(p43)
    local v254, v255, v256 = ipairs(t1.value58())

    repeat
        local v257

        v256, v257 = v254(v255, v256)

        if not v256 then
            for _, v in ipairs(t1.value59()) do
                if p43 == v.Name then
                    return true
                end
            end

            return false
        end
    until p43 == v257.Name

    return true
end
local function v40(p44, p45)
    local v262 = not p44

    if not v262 then
        v262 = not p44.Parent
    end

    if v262 then
        return false, "Player tidak online"
    end

    local v263 = t1.value60(p45)

    if not v263 then
        return false, "Tujuan tidak ditemukan di map"
    end

    local Character = p44.Character
    local v265 = Character and Character:FindFirstChild("HumanoidRootPart")

    if not v265 then
        return false, "Character belum siap"
    end

    v265.AssemblyLinearVelocity = Vector3.zero
    v265.AssemblyAngularVelocity = Vector3.zero

    local v266 = v263.Position.Y + v263.Size.Y / 2 + t1.value11.TP_SPAWN_OFFSET_Y
    local LookVector = v263.CFrame.LookVector

    Character:PivotTo(CFrame.new(v263.Position.X, v266, v263.Position.Z) * CFrame.fromEulerAnglesXYZ(0, math.atan2(-LookVector.X, -LookVector.Z), 0))
    task.defer(function()
        local v455 = v265

        if v455 then
            v455 = v265.Parent
        end

        if v455 then
            v265.AssemblyLinearVelocity = Vector3.zero
            v265.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    return true, "OK"
end
function t1.value62(p46)
    if not t1.value38(p46) then
        return {
			SummitCount = 0,
			BestTime = 0,
			isOnline = false
		}
    end

    local PlayerByUserId = t1.value12:GetPlayerByUserId(p46)

    if PlayerByUserId and PlayerByUserId.Parent ~= nil then
        if t1.value28 then
            local ok, result = pcall(function()
                return t1.value28:Invoke(p46)
            end)

            if ok then
                ok = type(result) == "table"
            end

            if ok then
                local v184 = result.SummitCount or 0
                local v185 = result.BestTime or 0

                return {
					SummitCount = v184,
					BestTime = v185,
					isOnline = true
				}
            end
        end

        local leaderstats = PlayerByUserId:FindFirstChild("leaderstats")
        local v187 = leaderstats and leaderstats:FindFirstChild("Summit")

        return {
			SummitCount = v187 and v187.Value or 0,
			BestTime = 0,
			isOnline = true
		}
    end

    if t1.value28 then
        local ok, result = pcall(function()
            return t1.value28:Invoke(p46)
        end)

        if ok then
            ok = type(result) == "table"
        end

        if ok then
            local v190 = result.SummitCount or 0
            local v191 = result.BestTime or 0

            return {
				SummitCount = v190,
				BestTime = v191,
				isOnline = false
			}
        end
    end

    return {
		SummitCount = 0,
		BestTime = 0,
		isOnline = false
	}
end
function t1.value63(p47, p48)
    if not t1.value38(p47) then
        return false, "userId tidak valid"
    end

    if type(p48) ~= "table" then
        return false, "changes bukan table"
    end

    local PlayerByUserId = t1.value12:GetPlayerByUserId(p47)

    if PlayerByUserId and PlayerByUserId.Parent ~= nil then
        if t1.value29 then
            local ok, result = pcall(function()
                return t1.value29:Invoke(p47, p48)
            end)

            if ok and result then
                return true, "ok"
            end
        end

        if t1.value30 then
            pcall(function()
                t1.value30:Fire(p47, p48)
            end)

            return true, "ok-patch"
        end

        return false, "CheckpointRemotes belum siap"
    end

    if t1.value29 then
        local ok, result, v201 = pcall(function()
            return t1.value29:Invoke(p47, p48)
        end)

        if ok and result then
            return true, "ok-globalupdate"
        end

        if ok then
            local _tostring = tostring

            if not v201 then
                v201 = "GlobalUpdate gagal"
            end

            return false, _tostring(v201)
        end

        return false, tostring(result)
    end

    return false, "adminSetData tidak tersedia"
end
function t1.value64(p49, p50, p51)
    if not p49 or not p49.Parent then
        return
    end

    local leaderstats = p49:FindFirstChild("leaderstats")

    if not leaderstats then
        return
    end

    if p50 ~= nil then
        local Summit = leaderstats:FindFirstChild("Summit")

        if Summit then
            Summit.Value = p50
        end
    end

    if p51 ~= nil then
        local BestTime = leaderstats:FindFirstChild("BestTime")

        if BestTime then
            local v72 = math.floor(p51 / 3600)
            local v73 = math.floor(p51 % 3600 / 60)
            local v74 = math.floor(p51 % 60)
            local v75 = p51 > 0

            if v75 then
                v75 = string.format("%02d:%02d:%02d", v72, v73, v74)
            end

            BestTime.Value = v75 or "--:--:--"
        end
    end
end
function t1.value65(p52)
    if not p52 or p52 <= 0 then
        return "--:--:--"
    end

    return string.format("%02d:%02d:%02d", math.floor(p52 / 3600), math.floor(p52 % 3600 / 60), math.floor(p52 % 60))
end
function t1.value66(p53, p54, p55)
    if p54 ~= nil then
        if p54 > 0 then
            pcall(function()
                t1.value19:SetAsync(tostring(p53), p54)
            end)
        else
            pcall(function()
                t1.value19:RemoveAsync((tostring(p53)))
            end)
        end
    end

    if p55 ~= nil then
        if p55 > 0 then
            pcall(function()
                t1.value20:SetAsync(tostring(p53), (math.floor(p55 * 1000)))
            end)

            return
        end

        pcall(function()
            t1.value20:RemoveAsync((tostring(p53)))
        end)
    end
end
function t1.value67(p56, p57)
    if not p56 and not p57 then
        return
    end

    task.delay(2, function()
        local ForceRefreshLeaderboard = t1.value14:FindFirstChild("ForceRefreshLeaderboard")

        if ForceRefreshLeaderboard then
            pcall(function()
                ForceRefreshLeaderboard:Fire()
            end)
        end
    end)
end
function t1.value68(p58, p59, p60)
    for _, v in ipairs(t1.value33) do
        if p58 == v.userId then
            v.username = p59
            v.displayName = p60

            return
        end
    end

    table.insert(t1.value33, {
		userId = p58,
		username = p59,
		displayName = p60
	})
end
function t1.value69(p61)
    for i, v in ipairs(t1.value33) do
        if p61 == v.userId then
            table.remove(t1.value33, i)

            return
        end
    end
end
function t1.value70()
    task.spawn(function()
        pcall(function()
            t1.value22:SetAsync("List", t1.value33)
        end)
    end)
end
function t1.value71()
    for _, player in ipairs(t1.value12:GetPlayers()) do
        if t1.value25[player.UserId] then
            t1.value24.VIPGiftListUpdated:FireClient(player, t1.value33)
        end
    end
end
function t2.GetRole.OnServerInvoke(player)
    if not player or not player.Parent then
        return nil
    end

    return t1.value45(player)
end
function t2.GetRoleForUser.OnServerInvoke(player, p62)
    if not player or not player.Parent then
        return nil
    end

    if not t1.value38(p62) then
        return nil
    end

    return t1.value25[p62]
end
function t2.GetAllAdmins.OnServerInvoke(player)
    if not t1.value46(player, "Moderator") then
        return {}
    end

    return t1.value26
end
function t2.SearchPlayer.OnServerInvoke(player, p63)
    if not t1.value46(player, "Developer") then
        return {
			found = false,
			reason = "Tidak punya izin"
		}
    end

    if not t1.value36(player.UserId, "SearchPlayer") then
        return {
			found = false,
			reason = "Terlalu banyak request"
		}
    end

    if not v37(p63, t1.value11.MAX_USERNAME) then
        return {
			found = false,
			reason = "Username tidak valid"
		}
    end

    local v276 = p63:lower():gsub("%s+", "")

    for _, player2 in ipairs(t1.value12:GetPlayers()) do
        if v276 == player2.Name:lower() then
            local UserId = player2.UserId
            local player2Name = player2.Name
            local DisplayName = player2.DisplayName
            local v282 = t1.value25[player2.UserId]

            return {
				found = true,
				userId = UserId,
				username = player2Name,
				displayName = DisplayName,
				currentRole = v282
			}
        end
    end

    return {
		found = false,
		reason = "Player tidak ditemukan atau offline"
	}
end
function t2.GetOnlinePlayers.OnServerInvoke(player)
    if not t1.value46(player, "Developer") then
        return {}
    end

    if not t1.value36(player.UserId, "GetOnline") then
        return {}
    end

    local t10 = {}

    for _, player3 in ipairs(t1.value12:GetPlayers()) do
        local insert = table.insert
        local UserId = player3.UserId
        local player3Name = player3.Name
        local DisplayName = player3.DisplayName

        insert(t10, {
			userId = UserId,
			username = player3Name,
			displayName = DisplayName
		})
    end

    return t10
end
function t2.SearchSummit.OnServerInvoke(player, p64)
    if not t1.value46(player, "Developer") then
        return {
			found = false,
			reason = "Tidak punya izin"
		}
    end

    if not t1.value36(player.UserId, "SearchSummit") then
        return {
			found = false,
			reason = "Terlalu banyak request"
		}
    end

    if not v37(p64, t1.value11.MAX_USERNAME) then
        return {
			found = false,
			reason = "Username tidak valid"
		}
    end

    local v293 = p64:gsub("%s+", "")
    local v294, v295, v296 = ipairs(t1.value12:GetPlayers())
    local v297

    repeat
        v296, v297 = v294(v295, v296)

        if not v296 then
            local ok, result = pcall(function()
                return t1.value12:GetUserIdFromNameAsync(v293)
            end)
            local v300 = result

            if ok and v300 then
                local ok5, result4 = pcall(function()
                    return t1.value12:GetNameFromUserIdAsync(v300)
                end)
                local v303 = ok5 and result4 or v293

                return {
					found = true,
					userId = v300,
					username = v293,
					displayName = v303,
					isOnline = false
				}
            end

            return {
				found = false,
				reason = "Player tidak ditemukan"
			}
        end
    until v297.Name:lower() == v293:lower()

    local UserId = v297.UserId
    local Name = v297.Name
    local DisplayName = v297.DisplayName

    return {
		found = true,
		userId = UserId,
		username = Name,
		displayName = DisplayName,
		isOnline = true
	}
end
function t2.GetPlayerSummit.OnServerInvoke(player, p65)
    if not t1.value46(player, "Developer") then
        return nil
    end

    if not t1.value36(player.UserId, "GetSummit") then
        return nil
    end

    if not t1.value38(p65) then
        return nil
    end

    local v309 = t1.value62(p65)
    local SummitCount = v309.SummitCount
    local BestTime = v309.BestTime
    local v312 = t1.value65(v309.BestTime)
    local isOnline = v309.isOnline

    return {
		summitCount = SummitCount,
		bestTime = BestTime,
		bestTimeStr = v312,
		isOnline = isOnline
	}
end
function t2.GetOnlineTitle.OnServerInvoke(player)
    if not t1.value46(player, "Developer") then
        return {}
    end

    if not t1.value36(player.UserId, "GetOnlineTitle") then
        return {}
    end

    local t11 = {}

    for _, player4 in ipairs(t1.value12:GetPlayers()) do
        local insert = table.insert
        local UserId = player4.UserId
        local player4Name = player4.Name
        local DisplayName = player4.DisplayName

        insert(t11, {
			userId = UserId,
			username = player4Name,
			displayName = DisplayName
		})
    end

    return t11
end
function t2.SearchTitle.OnServerInvoke(player, p66)
    if not t1.value46(player, "Developer") then
        return {
			found = false,
			reason = "Tidak punya izin"
		}
    end

    if not t1.value36(player.UserId, "SearchTitle") then
        return {
			found = false,
			reason = "Terlalu banyak request"
		}
    end

    if not v37(p66, t1.value11.MAX_USERNAME) then
        return {
			found = false,
			reason = "Username tidak valid"
		}
    end

    local v324 = p66:gsub("%s+", "")
    local v325, v326, v327 = ipairs(t1.value12:GetPlayers())
    local v328

    repeat
        v327, v328 = v325(v326, v327)

        if not v327 then
            local ok, result = pcall(function()
                return t1.value12:GetUserIdFromNameAsync(v324)
            end)
            local v331 = result

            if ok and v331 then
                local ok6, result5 = pcall(function()
                    return t1.value12:GetNameFromUserIdAsync(v331)
                end)
                local v334 = ok6 and result5 or v324

                return {
					found = true,
					userId = v331,
					username = v324,
					displayName = v334,
					isOnline = false
				}
            end

            return {
				found = false,
				reason = "Player tidak ditemukan"
			}
        end
    until v328.Name:lower() == v324:lower()

    local UserId = v328.UserId
    local Name = v328.Name
    local DisplayName = v328.DisplayName

    return {
		found = true,
		userId = UserId,
		username = Name,
		displayName = DisplayName,
		isOnline = true
	}
end
function t2.RankManager.OnServerInvoke(player, p67, p68)
    if not t1.value46(player, "Developer") then
        return {
			Success = false,
			Message = "Tidak punya izin!"
		}
    end

    if not t1.value36(player.UserId, "RankManager") then
        return {
			Success = false,
			Message = "Terlalu banyak request!"
		}
    end

    if not v37(p67, 20) then
        return {
			Success = false,
			Message = "Action tidak valid!"
		}
    end

    if type(p68) ~= "table" then
        return {
			Success = false,
			Message = "Data tidak valid!"
		}
    end

    if p67 == "save" then
        local t12, v342 = t1.value42(p68)
        if not t12 then
            return {
				Success = false,
				Message = v342
			}
        end
        if not t1.value38(p68.UserId) then
            return {
				Success = false,
				Message = "UserId tidak valid!"
			}
        end
        if not v37(p68.Username, t1.value11.MAX_USERNAME) then
            return {
				Success = false,
				Message = "Username tidak valid!"
			}
        end
        if pcall(function()
            local value21 = t1.value21
            local v457 = "Rank_" .. p68.UserId
            local Username = p68.Username
            local Ranks = p68.Ranks
            local SetAsync = value21.SetAsync
            local UserId = player.UserId
            local timestamp = os.time()

            SetAsync(value21, v457, {
				Username = Username,
				Ranks = Ranks,
				SavedBy = UserId,
				SavedAt = timestamp
			})
        end) then
            local PlayerByUserId = t1.value12:GetPlayerByUserId(p68.UserId)

            if PlayerByUserId then
                task.delay(0.5, function()
                    t1.value55(PlayerByUserId)
                end)
            end

            local v344 = "Title disimpan untuk @" .. p68.Username .. "!"

            return {
				Success = true,
				Message = v344
			}
        end

        return {
			Success = false,
			Message = "Gagal menyimpan ke DataStore!"
		}
    end

    if p67 == "load" then
        if not t1.value38(p68.UserId) then
            return {
				Success = false,
				Message = "UserId tidak valid!"
			}
        end

        local ok, result = pcall(function()
            return t1.value21:GetAsync("Rank_" .. p68.UserId)
        end)

        if ok and result then
            result.Ranks = t1.value41(result.Ranks)

            return {
				Success = true,
				Data = result
			}
        end

        return {
			Success = false,
			Message = "Belum ada title"
		}
    end

    if p67 == "delete" then
        if not t1.value38(p68.UserId) then
            return {
				Success = false,
				Message = "UserId tidak valid!"
			}
        end

        local v347 = v37(p68.Username, t1.value11.MAX_USERNAME)

        if v347 then
            v347 = p68.Username
        end

        local v348 = v347 or "?"

        if pcall(function()
            t1.value21:RemoveAsync("Rank_" .. p68.UserId)
        end) then
            local PlayerByUserId = t1.value12:GetPlayerByUserId(p68.UserId)

            if PlayerByUserId then
                task.delay(0.5, function()
                    t1.value55(PlayerByUserId)
                end)
            end

            local v350 = "Title @" .. v348 .. " dihapus!"

            return {
				Success = true,
				Message = v350
			}
        end

        return {
			Success = false,
			Message = "Gagal menghapus!"
		}
    end

    return {
		Success = false,
		Message = "Action tidak dikenal!"
	}
end
function t2.GetTeleportList.OnServerInvoke(player)
    if not t1.value46(player, "Developer") then
        return {
			Checkpoints = {},
			Summits = {}
		}
    end

    if not t1.value36(player.UserId, "GetTeleportList") then
        return {
			Checkpoints = {},
			Summits = {}
		}
    end

    local v352 = t1.value58()
    local v353 = t1.value59()

    return {
		Checkpoints = v352,
		Summits = v353
	}
end
function t2.GetVIPGiftList.OnServerInvoke(player)
    if not t1.value46(player, "Admin") then
        return {}
    end

    return t1.value33
end
t1.value24.GiftVIP.OnServerEvent:Connect(function(player, p69, p70, p71)
    if not t1.value46(player, "Admin") then
        t1.value47(player, "error", "Tidak punya izin!")

        return
    end

    if not t1.value36(player.UserId, "GiftVIP") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end

    if not t1.value38(p69) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end

    if not v37(p70, t1.value11.MAX_USERNAME) then
        t1.value47(player, "error", "Username tidak valid!")

        return
    end

    if p69 == player.UserId then
        t1.value47(player, "error", "Tidak bisa gift VIP ke diri sendiri!")

        return
    end

    if not t1.value34 then
        t1.value47(player, "error", "Sistem shop belum siap, coba lagi sebentar!")

        return
    end

    if t1.value34.OwnsItem(p69, t1.value35) then
        t1.value47(player, "error", "@" .. p70 .. " sudah memiliki VIP!")

        return
    end

    t1.value34.GrantItem(p69, t1.value35)
    t1.value68(p69, p70, v37(p71, t1.value11.MAX_USERNAME) and p71 or p70)
    t1.value70()

    local PlayerByUserId = t1.value12:GetPlayerByUserId(p69)

    if PlayerByUserId then
        t1.value47(PlayerByUserId, "info", "Kamu mendapatkan VIP dari " .. player.Name .. "!")
    end

    t1.value47(player, "success", "VIP diberikan ke @" .. p70 .. "!")
    t1.value71()
end)
t1.value24.RemoveVIPGift.OnServerEvent:Connect(function(player, p72, p73)
    if not t1.value46(player, "Admin") then
        t1.value47(player, "error", "Tidak punya izin!")

        return
    end

    if not t1.value36(player.UserId, "RemoveVIPGift") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end

    if not t1.value38(p72) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end

    if not t1.value34 then
        t1.value47(player, "error", "Sistem shop belum siap, coba lagi sebentar!")

        return
    end

    t1.value34.RevokeItem(p72, t1.value35)
    t1.value69(p72)
    t1.value70()

    local PlayerByUserId = t1.value12:GetPlayerByUserId(p72)

    if PlayerByUserId then
        t1.value47(PlayerByUserId, "info", "VIP kamu dicabut oleh " .. player.Name .. ".")
    end

    local v364 = v37(p73, t1.value11.MAX_USERNAME) and p73 or "?"

    t1.value47(player, "success", "VIP dicabut dari @" .. v364)
    t1.value71()
end)
t1.value24.AddSummit.OnServerEvent:Connect(function(player, p74, p75, p76)
    if not t1.value46(player, "Developer") then
        return
    end
    if not t1.value36(player.UserId, "AddSummit") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end
    if not t1.value38(p74) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end
    if not t1.value39(p76) then
        t1.value47(player, "error", "Jumlah tidak valid!")

        return
    end
    local SummitCount = t1.value62(p74).SummitCount
    local v370 = SummitCount + p76
    local t13, v372 = t1.value63(p74, {
		SummitCount = v370
	})
    if t13 then
        t1.value66(p74, v370, nil)
        t1.value67(true, false)

        local PlayerByUserId = t1.value12:GetPlayerByUserId(p74)

        if PlayerByUserId then
            if not t1.value29 then
                t1.value64(PlayerByUserId, v370, nil)
            end

            t1.value47(PlayerByUserId, "info", "Summit kamu bertambah " .. p76 .. " oleh " .. player.Name)
            task.delay(0.3, function()
                local v463 = PlayerByUserId

                if v463 then
                    v463 = PlayerByUserId.Parent
                end

                if v463 then
                    local v464 = PlayerByUserId

                    t1.value55(v464)
                end
            end)
        end

        local v374 = v37(p75, t1.value11.MAX_USERNAME) and p75 or "?"

        t1.value47(player, "success", "+(" .. p76 .. ") summit -> @" .. v374 .. " (" .. SummitCount .. " -> " .. v370 .. ")")

        return
    end
    t1.value47(player, "error", "Gagal update summit: " .. v372 or "unknown")
end)
t1.value24.RemoveSummit.OnServerEvent:Connect(function(player, p77, p78, p79)
    if not t1.value46(player, "Developer") then
        return
    end
    if not t1.value36(player.UserId, "RemoveSummit") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end
    if not t1.value38(p77) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end
    if not t1.value39(p79) then
        t1.value47(player, "error", "Jumlah tidak valid!")

        return
    end
    local SummitCount = t1.value62(p77).SummitCount
    local v380 = math.max(0, SummitCount - p79)
    local t14, v382 = t1.value63(p77, {
		SummitCount = v380
	})
    if t14 then
        t1.value66(p77, v380, nil)
        t1.value67(true, false)

        local PlayerByUserId = t1.value12:GetPlayerByUserId(p77)

        if PlayerByUserId then
            if not t1.value29 then
                t1.value64(PlayerByUserId, v380, nil)
            end

            t1.value47(PlayerByUserId, "info", "Summit kamu berkurang " .. p79 .. " oleh " .. player.Name)
            task.delay(0.3, function()
                local v465 = PlayerByUserId

                if v465 then
                    v465 = PlayerByUserId.Parent
                end

                if v465 then
                    local v466 = PlayerByUserId

                    t1.value55(v466)
                end
            end)
        end

        local v384 = v37(p78, t1.value11.MAX_USERNAME) and p78 or "?"

        t1.value47(player, "success", "-(" .. p79 .. ") summit -> @" .. v384 .. " (" .. SummitCount .. " -> " .. v380 .. ")")

        return
    end
    local value47 = t1.value47
    if not v382 then
        v382 = "unknown"
    end
    value47(player, "error", "Gagal update summit: " .. v382)
end)
t1.value24.ResetSummit.OnServerEvent:Connect(function(player, p80, p81)
    if not t1.value46(player, "Developer") then
        return
    end

    if not t1.value36(player.UserId, "ResetSummit") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end

    if not t1.value38(p80) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end

    local SummitCount = t1.value62(p80).SummitCount
    local v390, v391 = t1.value63(p80, {
		SummitCount = 0
	})

    if v390 then
        t1.value66(p80, 0, nil)
        t1.value67(true, false)

        local PlayerByUserId = t1.value12:GetPlayerByUserId(p80)

        if PlayerByUserId then
            if not t1.value29 then
                t1.value64(PlayerByUserId, 0, nil)
            end

            t1.value47(PlayerByUserId, "info", "Summit kamu direset oleh " .. player.Name)
            task.delay(0.3, function()
                local v467 = PlayerByUserId

                if v467 then
                    v467 = PlayerByUserId.Parent
                end

                if v467 then
                    local v468 = PlayerByUserId

                    t1.value55(v468)
                end
            end)
        end

        local v393 = v37(p81, t1.value11.MAX_USERNAME) and p81 or "?"

        t1.value47(player, "success", "Reset summit @" .. v393 .. " (" .. SummitCount .. " -> 0)")

        return
    end

    t1.value47(player, "error", "Gagal reset summit: " .. v391 or "unknown")
end)
t1.value24.ResetBestTime.OnServerEvent:Connect(function(player, p82, p83)
    if not t1.value46(player, "Developer") then
        return
    end

    if not t1.value36(player.UserId, "ResetTime") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end

    if not t1.value38(p82) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end

    local v397 = t1.value65(t1.value62(p82).BestTime)
    local v398, v399 = t1.value63(p82, {
		BestTime = 0
	})

    if v398 then
        t1.value66(p82, nil, 0)
        t1.value67(false, true)

        local PlayerByUserId = t1.value12:GetPlayerByUserId(p82)

        if PlayerByUserId then
            if not t1.value29 then
                t1.value64(PlayerByUserId, nil, 0)
            end

            t1.value47(PlayerByUserId, "info", "Best time kamu direset oleh " .. player.Name)
        end

        local v401 = v37(p83, t1.value11.MAX_USERNAME) and p83 or "?"

        t1.value47(player, "success", "Reset best time @" .. v401 .. " (" .. v397 .. " -> --:--:--)")

        return
    end

    t1.value47(player, "error", "Gagal reset best time: " .. v399 or "unknown")
end)
t1.value24.AddRole.OnServerEvent:Connect(function(player, p84, p85, p86, p87)
    if not t1.value46(player, "Developer") then
        t1.value47(player, "error", "Tidak punya izin!")

        return
    end

    if not t1.value36(player.UserId, "AddRole") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end

    if not t1.value38(p84) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end

    if not v37(p85, t1.value11.MAX_USERNAME) then
        t1.value47(player, "error", "Username tidak valid!")

        return
    end

    if not t1.value10[p87] then
        t1.value47(player, "error", "Role tidak valid!")

        return
    end

    local v407 = p87 == "Owner"

    if v407 then
        v407 = not t1.value43(player.UserId)
    end

    if v407 then
        t1.value47(player, "error", "Hanya Owner yang bisa assign role Owner!")

        return
    end

    local v408 = t1.value45(player)

    if v408 ~= "Owner" and t1.value44(p87) >= t1.value44(v408) then
        t1.value47(player, "error", "Kamu tidak bisa assign role " .. p87 .. "!")

        return
    end

    t1.value25[p84] = p87
    t1.value52(p84, p87)
    t1.value48(p84, p87, p85, v37(p86, t1.value11.MAX_USERNAME) and p86 or p85)
    t1.value50()

    local PlayerByUserId = t1.value12:GetPlayerByUserId(p84)

    if PlayerByUserId then
        t1.value24.RoleUpdated:FireClient(PlayerByUserId, p87)
        t1.value47(PlayerByUserId, "info", "Kamu sekarang memiliki role " .. p87 .. ".")
        t1.value53(PlayerByUserId)

        if t1.value32 then
            pcall(function()
                t1.value32:Fire(p84, p87)
            end)
        end

        task.delay(0.5, function()
            local v469 = PlayerByUserId

            if v469 then
                v469 = PlayerByUserId.Parent
            end

            if v469 then
                local v470 = PlayerByUserId

                t1.value55(v470)
            end
        end)
    elseif t1.value32 then
        pcall(function()
            t1.value32:Fire(p84, p87)
        end)
    end

    t1.value47(player, "success", "Role " .. p87 .. " diberikan ke @" .. p85)
    t1.value51()
end)
t1.value24.RemoveRole.OnServerEvent:Connect(function(player, p88, p89)
    if not t1.value46(player, "Developer") then
        t1.value47(player, "error", "Tidak punya izin!")

        return
    end

    if not t1.value36(player.UserId, "RemoveRole") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end

    if not t1.value38(p88) then
        t1.value47(player, "error", "UserId tidak valid!")

        return
    end

    local v413 = t1.value25[p88]

    if not v413 then
        for _, v in ipairs(t1.value26) do
            if p88 == v.userId then
                v413 = v.role

                break
            end
        end
    end

    if v413 == "Owner" then
        t1.value47(player, "error", "Role Owner tidak bisa dihapus!")

        return
    end

    local v416 = t1.value45(player)
    local v417 = v416 ~= "Owner"

    if v417 then
        v417 = t1.value44(v413 or "") >= t1.value44(v416)
    end

    if v417 then
        t1.value47(player, "error", "Tidak bisa hapus role setara atau lebih tinggi!")

        return
    end

    t1.value25[p88] = nil
    t1.value52(p88, nil)
    t1.value49(p88)
    t1.value50()

    local PlayerByUserId = t1.value12:GetPlayerByUserId(p88)

    if PlayerByUserId then
        t1.value24.RoleUpdated:FireClient(PlayerByUserId, nil)
        t1.value47(PlayerByUserId, "info", "Role kamu dihapus oleh " .. player.Name .. ".")
        t1.value54(PlayerByUserId)

        if t1.value32 then
            pcall(function()
                t1.value32:Fire(p88, nil)
            end)
        end

        task.delay(0.5, function()
            local v471 = PlayerByUserId

            if v471 then
                v471 = PlayerByUserId.Parent
            end

            if v471 then
                local v472 = PlayerByUserId

                t1.value55(v472)
            end
        end)
    elseif t1.value32 then
        pcall(function()
            t1.value32:Fire(p88, nil)
        end)
    end

    local v419 = v37(p89, t1.value11.MAX_USERNAME) and p89 or "?"

    t1.value47(player, "success", "Role dihapus dari @" .. v419)
    t1.value51()
end)
t1.value24.TeleportAdmin.OnServerEvent:Connect(function(player, p90)
    if not t1.value46(player, "Developer") then
        t1.value47(player, "error", "Tidak punya izin!")

        return
    end
    if not t1.value36(player.UserId, "TeleportAdmin") then
        t1.value47(player, "error", "Terlalu banyak request!")

        return
    end
    if not v37(p90, t1.value11.MAX_TP_NAME) then
        t1.value47(player, "error", "Tujuan tidak valid!")

        return
    end
    if not t1.value61(p90) then
        t1.value47(player, "error", "Tujuan tidak dikenal!")

        return
    end
    local t15, v423 = v40(player, p90)
    if t15 then
        t1.value47(player, "success", "Teleport ke " .. p90 .. " berhasil!")

        return
    end
    local value47 = t1.value47
    if not v423 then
        v423 = "unknown"
    end
    value47(player, "error", "Gagal teleport: " .. v423)
end)
t1.value72 = nil
function t1.value72(p91, p92)
    for _, player in ipairs(t1.value12:GetPlayers()) do
        t1.value24.ReceiveMessage:FireClient(player, p91, p92)
    end
end
pcall(function()
    t1.value15:SubscribeAsync("AdminGlobalMsg", function(p93)
        local Data = p93.Data

        if type(Data) ~= "table" then
            return
        end

        if type(Data.sender) ~= "table" then
            return
        end

        if not v37(Data.text, t1.value11.MAX_MSG) then
            return
        end

        t1.value72(Data.sender, Data.text)
    end)
end)
t1.value24.SendMessage.OnServerEvent:Connect(function(player, p94, p95)
    if not t1.value46(player, "Moderator") then
        return
    end

    if not t1.value36(player.UserId, "SendMsg") then
        t1.value47(player, "error", "Terlalu banyak pesan!")

        return
    end

    if not v37(p94, t1.value11.MAX_MSG) then
        t1.value47(player, "error", "Pesan tidak valid!")

        return
    end

    if type(p95) ~= "boolean" then
        p95 = false
    end

    local UserId = player.UserId
    local playerName = player.Name
    local DisplayName = player.DisplayName
    local v435 = t1.value45(player)
    local t16 = {
		userId = UserId,
		username = playerName,
		displayName = DisplayName,
		role = v435
	}

    if p95 then
        if not pcall(function()
            t1.value15:PublishAsync("AdminGlobalMsg", {
				sender = t16,
				text = p94
			})
        end) then
            t1.value72(t16, p94)

            return
        end
    else
        t1.value72(t16, p94)
    end
end)
t1.value12.PlayerAdded:Connect(function(player)
    local v438 = v38(player)

    if not v438 then
        return
    end

    task.delay(1, function()
        local v475 = player

        if v475 then
            v475 = player.Parent
        end

        if v475 then
            local v476 = player

            t1.value53(v476)
        end
    end)
    task.delay(1.5, function()
        local v477 = player

        if v477 then
            v477 = player.Parent
        end

        if v477 then
            t1.value24.RoleUpdated:FireClient(player, v438)
        end
    end)
    task.delay(2, function()
        local v478 = player

        if v478 then
            v478 = player.Parent
        end

        if v478 then
            t1.value51()
        end
    end)
    task.delay(2, function()
        local v479 = player

        if v479 then
            v479 = player.Parent
        end

        if v479 then
            t1.value71()
        end
    end)
end)
t1.value12.PlayerRemoving:Connect(function(player)
    if not player then
        return
    end

    if not t1.value43(player.UserId) then
        t1.value25[player.UserId] = nil
    end

    t1.value37(player.UserId)
end);
(function()
    local ok, result = pcall(function()
        return t1.value18:GetAsync("MasterList")
    end)

    if ok then
        ok = type(result) == "table"
    end

    t1.value26 = ok and result or {}
end)();
(function()
    local ok, result = pcall(function()
        return t1.value22:GetAsync("List")
    end)

    if ok then
        ok = type(result) == "table"
    end

    t1.value33 = ok and result or {}
end)()
for _, player in ipairs(t1.value12:GetPlayers()) do
    local v43 = player

    task.spawn(function()
        local v440 = v38(v43)

        if not v440 then
            return
        end

        t1.value53(v43)
        task.delay(2, function()
            local v480 = v43

            if v480 then
                v480 = v43.Parent
            end

            if v480 then
                t1.value24.RoleUpdated:FireClient(v43, v440)
            end
        end)
    end)
end
