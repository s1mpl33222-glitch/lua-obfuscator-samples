local n1 = 7994
local n2 = 3198
local function u3(p1, p2, p3)
    local v38 = bit32.bxor(p1, n1)
    local v39 = bit32.bxor(p2, n2)
    local v40 = bit32.bxor(p3, n1)
    return v38 + v39 * 65536 + v40 * 4294967296
end
local t1 = {
    a = 4933,
    b = 63370,
    c = 57323,
}
local function u5(p4)
    local n3 = 0
    while p4 > 0 do
        n3 += p4 % 10
        p4 = math.floor(p4 / 10)
    end
    return n3 % 97
end
local u6 = false
local u7 = false
local GroupService = game:GetService("GroupService")
local function u9()
    local v43 = u3(t1.a, t1.b, t1.c)
    if v43 == game.CreatorId and u5(v43) == 46 then
        return true
    end
    if game.CreatorType == Enum.CreatorType.Group then
        local ok, result = pcall(function()
            return GroupService:GetGroupInfoAsync(game.CreatorId)
        end)
        if ok then
            ok = result
        end
        if ok then
            ok = result.Owner
        end
        if ok then
            local Players = game:GetService("Players")
            for _, player in ipairs(Players:GetPlayers()) do
                if result.Owner.Id == player.UserId then
                    return true
                end
            end
        end
    end
    return false
end
local HttpService = game:GetService("HttpService")
local function u11()
    local str = tostring(game.CreatorId)
    local u50 = game.CreatorType == Enum.CreatorType.Group and "&groupId=" .. str or ""
    local ok, result = pcall(function()
        return HttpService:GetAsync("https://license-server1-production.up.railway.app/check?creatorId=" .. str .. u50, true)
    end)
    local u53 = result
    if not ok or not u53 then
        return nil
    end
    local ok2, result2 = pcall(function()
        return HttpService:JSONDecode(u53)
    end)
    if not ok2 then
        return nil
    end
    return result2 and result2.valid == true
end
local function u12()
    local Players = game:GetService("Players")
    for _, player in ipairs(Players:GetPlayers()) do
        player:Kick("Game tidak berlisensi.")
    end
    if not u7 then
        u7 = true
        Players.PlayerAdded:Connect(function(player)
            if not u6 then
                player:Kick("Game tidak berlisensi.")
            end
        end)
    end
end
local function u13()
    if u9() then
        u6 = true
        return
    end
    local v59 = u11()
    if v59 == nil then
        u6 = true
        return
    end
    if v59 then
        u6 = true
    else
        u6 = false
        u12()
    end
end
local function u14()
    return u6 == true
end
task.spawn(u13)
task.spawn(function()
    while true do
        task.wait(600)
        u13()
    end
end)
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerSettings_v1 = DataStoreService:GetDataStore("PlayerSettings_v1")
local SettingsRemote = ReplicatedStorage:WaitForChild("AurionStudio//SummitKitV2//RS"):WaitForChild("SystemRS"):WaitForChild("SettingsRemote")
if type(u14) ~= "function" then
    error("[SettingsSystem] Integrity check failed - core license module missing or modified.")
end
local t2 = {
    graphicsMode = "High",
    effectsEnabled = true,
    shadowEnabled = true,
    hideTag = false,
    hideUI = false,
    hidePlayer = false,
    muteBoomBox = false,
    muteSticker = false,
    brightness = 1.79,
    exposure = 0,
    contrast = 0,
    jumpX = 0.5,
    jumpY = 0.5,
    jumpSize = 0.5,
    slX = 0.5,
    slY = 0.5,
    slSize = 0.5,
}
local t3 = {
    High = true,
    Medium = true,
    Low = true,
}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}
local n4 = 3
local n5 = 0.75
local n6 = 3
local n7 = 1.5
local function u30(p5)
    local t8 = {}
    for k, v in pairs(p5) do
        t8[k] = v
    end
    return t8
end
local function u31(p6)
    local v65 = u30(t2)
    if type(p6) ~= "table" then
        return v65
    end
    for k, v in pairs(t2) do
        local v68 = k
        local v69 = p6[v68]
        if v69 ~= nil and type(v69) == type(v) then
            if v68 == "graphicsMode" then
                if t3[v69] then
                    v65[v68] = v69
                end
            elseif type(v69) == "number" then
                if v69 == v69 and v69 ~= math.huge and v69 ~= -math.huge then
                    v65[v68] = math.clamp(v69, -10, 10)
                end
            else
                v65[v68] = v69
            end
        end
    end
    return v65
end
local function u32(p7)
    local u71 = "Player_" .. p7.UserId
    local v72 = nil
    local v73 = false
    for i = 1, n6 do
        local ok, result = pcall(function()
            return PlayerSettings_v1:GetAsync(u71)
        end)
        if ok then
            v72 = result
            v73 = true
            break
        end
        if i < n6 then
            task.wait(n7)
        end
    end
    local v77 = u31(v73 and v72 or nil)
    t4[p7] = v77
    t5[p7] = false
    return v77
end
local function u33(p8)
    local u79 = t4[p8]
    if not u79 then
        return
    end
    if not t5[p8] then
        return
    end
    local u80 = "Player_" .. p8.UserId
    if pcall(function()
        PlayerSettings_v1:SetAsync(u80, u79)
    end) then
        t5[p8] = false
    end
end
local function u34(p9)
    if t6[p9] then
        return
    end
    t6[p9] = true
    task.delay(n4, function()
        t6[p9] = nil
        if p9 and p9.Parent then
            u33(p9)
        end
    end)
end
Players.PlayerAdded:Connect(function(player)
    if not u14() then
        return
    end
    local v84 = u32(player)
    SettingsRemote:FireClient(player, "LoadSettings", v84)
end)
Players.PlayerRemoving:Connect(function(player)
    u33(player)
    t4[player] = nil
    t5[player] = nil
    t6[player] = nil
    t7[player] = nil
end)
SettingsRemote.OnServerEvent:Connect(function(player, p10, p11)
    if not u14() then
        return
    end
    if p10 ~= "SaveSettings" then
        return
    end
    if type(p11) ~= "table" then
        return
    end
    local timestamp = tick()
    local v90 = t7[player]
    if v90 and timestamp - v90 < n5 then
        return
    end
    t7[player] = timestamp
    local v91 = t4[player]
    if not v91 then
        return
    end
    local v92 = u31(p11)
    for k in pairs(t2) do
        v91[k] = v92[k]
    end
    t5[player] = true
    u34(player)
end)
game:BindToClose(function()
    local players = Players:GetPlayers()
    for _, v in ipairs(players) do
        u33(v)
    end
end)
