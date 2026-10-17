-- Recovered runtime. Missing original game dependencies are reported explicitly.
local globalEnv = getfenv()
local function createRuntime(overrides)
    local context = {}
    for key,value in pairs(overrides or {}) do context[key]=value end
    local function service(name)
        if not game then return nil end
        local ok,value=pcall(game.GetService,game,name)
        return ok and value or nil
    end
    local players=context.Players or service("Players")
    local player=context.LocalPlayer or (players and players.LocalPlayer)
    local config=context.spoofConfig or {}
    context.spoofConfig=config
    context.Players,context.LocalPlayer=players,player
    context.Workspace=context.Workspace or workspace
    context.localOriginalUserId=context.localOriginalUserId or (player and player.UserId) or 0
    context.localOriginalName=context.localOriginalName or (player and player.Name) or ""
    context.origUserId=context.origUserId or context.localOriginalUserId
    context.localUserId=context.localUserId or context.localOriginalUserId
    context.origPlayerName=context.origPlayerName or context.localOriginalName
    context.origDisplayName=context.origDisplayName or (player and player.DisplayName) or context.origPlayerName
    context.origGetPlayerByUserId=context.origGetPlayerByUserId or (players and players.GetPlayerByUserId)
    context.origGetAttribute=context.origGetAttribute or (player and player.GetAttribute)
    context.clockFunc=context.clockFunc or os.clock
    context.cfg=context.cfg or {cacheTtl=0.25}
    context.beamRotationOffset=context.beamRotationOffset or 0
    context.prngState=context.prngState or 0
    context.tickCounter=context.tickCounter or 0
    for _,key in ipairs({"rankedConfig","ownershipCache","timestampCache","unlockedTable1","unlockedTable2","unlockedTable3","unlockedTable4","unlockedTable5","weaponSkinsMap1","weaponSkinsMap2","weaponSkinsMap3","savedSettings","equippedCosmeticsOverride","specificUnlockedWeapons","ItemDatabase","favoritedWeaponsMap","WeaponConfig","favoritedCosmeticsOverride","equippedEmotesOverride","streakSpoofState","origBillboardOffsets","activeBeamsList","yabujinUsers"})do
        context[key]=context[key] or {}
    end
    context.pingConfig=context.pingConfig or {PingSpoof=false,PingMode="Static",PingValue=50}
    context.stretchConfig=context.stretchConfig or {x=1,y=1}
    for _,key in ipairs({"_safeQueue","RealUserIdMap","OtherPlayerOriginals","_menuLockedCosmetics"})do config[key]=config[key] or {}end
    config._stopped=false
    local YabujinDeobfuscated={Context=context,Required={},Alive=true}
    local function resolve(key)
        if context[key]~=nil then return context[key]end
        if globalEnv[key]~=nil then return globalEnv[key]end
        if key=="spooferActive"or key=="forceUnlockAll"or key=="unlockerEnabled"or key=="isActive"then return false end
        if key=="weaponUnlockMode"then return "None"end
        if key=="getRealUserId"or key=="getSpoofedPlayerNames"or key=="isCosmeticUnlocked"then
            return function(...)
                local name=key=="isCosmeticUnlocked"and"isCosmeticUnlockedCached"or key
                return assert(YabujinDeobfuscated[name],"Recovered helper unavailable: "..name)(...)
            end
        end
        if key=="getYabujinSpoofField"then
            return function(userId,field)
                local user=context.yabujinUsers[userId]or context.yabujinUsers[tostring(userId)]
                return user and user.spoofer and user.spoofer[field]
            end
        end
        return nil
    end
    local runtimeEnv=setmetatable({}, {__index=function(_,key)
        if context[key]~=nil then return context[key]end
        return globalEnv[key]
    end,__newindex=function(_,key,value)context[key]=value end})
    setfenv(1,runtimeEnv)



-- ============================================================================
-- PART 1: Yabujin Client (Roblox Rivals) Core Functions & Hooks
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Function [22]: runWithElevatedThreadIdentity (485 bytes)
-- Description: Elevates executor thread identity to 8 (with fallback to 7, 6, 3 on 'lacking capability') for privileged Roblox API calls.
-- Resolved Upvalues: [1] = setthreadidentity, [2] = pcall, [3] = getthreadidentity
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["runWithElevatedThreadIdentity"]={"setthreadidentity","pcall","getthreadidentity"}
    local setthreadidentity, pcall, getthreadidentity = resolve("setthreadidentity"), resolve("pcall"), resolve("getthreadidentity")
    YabujinDeobfuscated.runWithElevatedThreadIdentity = function(b, ...)
        if not setthreadidentity then return pcall(b, ...)
    end
    local J
    pcall(function()
        J = getthreadidentity and(getthreadidentity())
    end)
    pcall(setthreadidentity, 8)
    local N = table.pack(pcall(b, ...))
    if not N[1] and type(N[2]) == "string" and(N[2]:find("lacking capability", 1, true)) then
        local A = {7, 6, 3}
        for q, q in ipairs(A) do
            pcall(setthreadidentity, q)
            N = table.pack(pcall(b, ...))
            if N[1] then
                break
            end
            if type(N[2]) ~= "string" or not N[2]:find("lacking capability", 1, true) then
                break
            end
        end
    end
    if J ~= nil then
        pcall(setthreadidentity, J)
    end
    return table.unpack(N, 1, N.n)
end
end

-- ----------------------------------------------------------------------------
-- Function [125]: runSafeQueueWorker (205 bytes)
-- Description: Background coroutine loop that maintains thread identity 8 and executes queued callbacks in _safeQueue via _withId.
-- Resolved Upvalues: [1] = setthreadidentity, [2] = pcall, [3] = spoofConfig
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["runSafeQueueWorker"]={"setthreadidentity","pcall","spoofConfig"}
    local setthreadidentity, pcall, spoofConfig = resolve("setthreadidentity"), resolve("pcall"), resolve("spoofConfig")
    YabujinDeobfuscated.runSafeQueueWorker = function()
        while not spoofConfig._stopped do
            if setthreadidentity then
                pcall(setthreadidentity, 8)
            end
            while#spoofConfig._safeQueue > 0 do
                local b = table.remove(spoofConfig._safeQueue, 1)
                if b then
                    spoofConfig._withId(b)
                end
            end
            task.wait()
        end
    end
end

-- ----------------------------------------------------------------------------
-- Function [55]: getRealUserId (210 bytes)
-- Description: Returns the real UserId of a Player (checking LocalPlayer and RealUserIdMap before player.UserId).
-- Resolved Upvalues: [1] = LocalPlayer, [2] = localOriginalUserId, [3] = spoofConfig
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["getRealUserId"]={"LocalPlayer","localOriginalUserId","spoofConfig"}
    local LocalPlayer, localOriginalUserId, spoofConfig = resolve("LocalPlayer"), resolve("localOriginalUserId"), resolve("spoofConfig")
    YabujinDeobfuscated.getRealUserId = function(b)
        if b == LocalPlayer then return localOriginalUserId
    end
    local J = spoofConfig.RealUserIdMap
    if J and J[b] then
        return J[b]
    end
    if typeof(b) == "Instance" and(b:IsA("Player")) then
        return b.UserId
    end
    return 0
end
end

-- ----------------------------------------------------------------------------
-- Function [42]: getOriginalPlayerName (178 bytes)
-- Description: Returns the unspoofed username of a Player from OtherPlayerOriginals.
-- Resolved Upvalues: [1] = LocalPlayer, [2] = localOriginalName, [3] = spoofConfig
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["getOriginalPlayerName"]={"LocalPlayer","localOriginalName","spoofConfig"}
    local LocalPlayer, localOriginalName, spoofConfig = resolve("LocalPlayer"), resolve("localOriginalName"), resolve("spoofConfig")
    YabujinDeobfuscated.getOriginalPlayerName = function(b)
        if b == LocalPlayer then return localOriginalName
    end
    local J = spoofConfig.OtherPlayerOriginals
    if J and J[b] and J[b].Name then
        return J[b].Name
    end
    return b.Name
end
end

-- ----------------------------------------------------------------------------
-- Function [108]: getSpoofedPlayerNames (693 bytes)
-- Description: Returns (spoofedName, spoofedDisplayName) for LocalPlayer, yabujinUsers[userId].spoofer, or AnonymousMode.
-- Resolved Upvalues: [1] = LocalPlayer, [2] = spoofConfig, [3] = getRealUserId, [4] = getYabujinSpoofField
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["getSpoofedPlayerNames"]={"LocalPlayer","spoofConfig","getRealUserId","getYabujinSpoofField"}
    local LocalPlayer, spoofConfig, getRealUserId, getYabujinSpoofField = resolve("LocalPlayer"), resolve("spoofConfig"), resolve("getRealUserId"), resolve("getYabujinSpoofField")
    YabujinDeobfuscated.getSpoofedPlayerNames = function(b)
        if not b then return nil, nil
    end
    if b == LocalPlayer then
        if not spoofConfig.UsernameSpoof then
            return nil, nil
        end
        local J, N = spoofConfig.SpoofedName, spoofConfig.SpoofedDisplayName
        local A = J and J ~= "" and J or nil
        return A, N and N ~= "" and N or A
    end
    local J = getRealUserId(b)
    b = yabujinUsers[J] or yabujinUsers[tostring(J)]
    if b and b.spoofer and(next(b.spoofer)) then
        local b = getYabujinSpoofField(J, "Username")
        if not b or type(b) ~= "table" then
            return nil, nil
        end
        local J = b.name and b.name ~= "" and b.name or nil
        return J, b.displayName and b.displayName ~= "" and b.displayName or J
    end
    if spoofConfig.AnonymousMode then
        return spoofConfig.AnonName or "Roblox", spoofConfig.AnonDisplayName or "Roblox"
    end
    return nil, nil
end
end

-- ----------------------------------------------------------------------------
-- Function [91]: applyLocalPlayerIdentitySpoof (1190 bytes)
-- Description: Applies spoofed Name, DisplayName, and UserId to LocalPlayer and updates the in-game PlayerLabel UI.
-- Resolved Upvalues: [1] = spoofConfig, [2] = origPlayerName, [3] = LocalPlayer, [4] = pcall, [5] = origDisplayName, [6] = origUserId
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["applyLocalPlayerIdentitySpoof"]={"spoofConfig","origPlayerName","LocalPlayer","pcall","origDisplayName","origUserId"}
    local spoofConfig, origPlayerName, LocalPlayer, pcall, origDisplayName, origUserId = resolve("spoofConfig"), resolve("origPlayerName"), resolve("LocalPlayer"), resolve("pcall"), resolve("origDisplayName"), resolve("origUserId")
    YabujinDeobfuscated.applyLocalPlayerIdentitySpoof = function()
        local b = nil
        if spoofConfig.UsernameSpoof then
            local J = spoofConfig.SpoofedName
            b = J and J ~= "" and J or origPlayerName
        else
            b = origPlayerName
        end
        local J = b ~= LocalPlayer.Name
        if J then
            pcall(function()
                local N = spoofConfig._findPlayersFrame and(spoofConfig._findPlayersFrame())
                if N then
                    local A = N:FindFirstChild("PlayerLabel" .. LocalPlayer.Name)
                    if A then
                        A:Destroy()
                    end
                end
            end)
        end
        pcall(function()
            LocalPlayer.Name = b
        end)
        if spoofConfig.UsernameSpoof then
            local b, N = spoofConfig.SpoofedDisplayName, spoofConfig.SpoofedName
            if b and b ~= "" then
                pcall(function()
                    LocalPlayer.DisplayName = b
                end)
            elseif N and N ~= "" then
                pcall(function()
                    LocalPlayer.DisplayName = N
                end)
            else
                pcall(function()
                    LocalPlayer.DisplayName = origDisplayName
                end)
            end
        else
            pcall(function()
                LocalPlayer.DisplayName = origDisplayName
            end)
        end
        if not J then
            pcall(function()
                local b = spoofConfig._findPlayersFrame and(spoofConfig._findPlayersFrame())
                if b then
                    local J = b:FindFirstChild("PlayerLabel" .. LocalPlayer.Name)
                    if J then
                        local b = J:FindFirstChild("DisplayNameLabel")
                        if b then
                            b.Text = LocalPlayer.DisplayName
                        end
                    end
                end
            end)
        end
        spoofConfig._withId(function()
            if spoofConfig.AvatarSpoof and spoofConfig.AvatarUserId and spoofConfig.AvatarUserId ~= 0 then LocalPlayer.UserId = spoofConfig.AvatarUserId
        else
            LocalPlayer.UserId = origUserId
        end
    end)
end
end

-- ----------------------------------------------------------------------------
-- Function [99]: hookGetPlayerByUserId (374 bytes)
-- Description: Hooks Players:GetPlayerByUserId to resolve spoofed AvatarUserId and RealUserIdMap entries.
-- Resolved Upvalues: [1] = spoofConfig, [2] = localOriginalUserId, [3] = origGetPlayerByUserId, [4] = localSpoofTargetId
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookGetPlayerByUserId"]={"spoofConfig","localOriginalUserId","origGetPlayerByUserId","localSpoofTargetId"}
    local spoofConfig, localOriginalUserId, origGetPlayerByUserId, localSpoofTargetId = resolve("spoofConfig"), resolve("localOriginalUserId"), resolve("origGetPlayerByUserId"), resolve("localSpoofTargetId")
    YabujinDeobfuscated.hookGetPlayerByUserId = function(b, J)
        if spoofConfig.AvatarSpoof and spoofConfig.AvatarUserId then
        if type(J) == "number" and(J == spoofConfig.AvatarUserId or J == localOriginalUserId) then
            return origGetPlayerByUserId(b, localSpoofTargetId)
        end
    end
    local N = origGetPlayerByUserId(b, J)
    if not N and type(J) == "number" and spoofConfig.RealUserIdMap then
        for A, q in pairs(spoofConfig.RealUserIdMap) do
            if q == J then
                local J = origGetPlayerByUserId(b, A)
                if J then
                    return J
                end
            end
        end
    end
    return N
end
end

-- ----------------------------------------------------------------------------
-- Function [1]: hookPlayerGetAttribute (1146 bytes)
-- Description: Hooks Player:GetAttribute to spoof Streak, ELO, LeaderboardRank, Level, and PlayerStatus ('Prime'/'Contraband') for yabujinUsers and AnonymousMode.
-- Resolved Upvalues: [1] = getRealUserId, [2] = getYabujinSpoofField, [3] = spoofConfig, [4] = origGetAttribute
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookPlayerGetAttribute"]={"getRealUserId","getYabujinSpoofField","spoofConfig","origGetAttribute"}
    local getRealUserId, getYabujinSpoofField, spoofConfig, origGetAttribute = resolve("getRealUserId"), resolve("getYabujinSpoofField"), resolve("spoofConfig"), resolve("origGetAttribute")
    YabujinDeobfuscated.hookPlayerGetAttribute = function(b, J)
        if typeof(b) == "Instance" and(b:IsA("Player")) then local N = getRealUserId(b)
        if yabujinUsers[N] and yabujinUsers[N].spoofer then
            if J == "StatisticDuelsWinStreak" then
                local A = getYabujinSpoofField(N, "Streak")
                if A then
                    return A
                end
            elseif J == "DisplayELO" then
                local A = getYabujinSpoofField(N, "ELO")
                if A then
                    return A
                end
            elseif J == "DisplayELOLeaderboardRanking" then
                local A = getYabujinSpoofField(N, "LeaderboardRank")
                if A then
                    return A
                end
            elseif J == "Level" then
                local A = getYabujinSpoofField(N, "Level")
                if A then
                    return A
                end
            elseif J == "PlayerStatus" then
                local A = getYabujinSpoofField(N, "Pass")
                if A and type(A) == "number" and A > 1 then
                    if A == 2 then
                        return "Prime"
                    elseif A == 3 then
                        return "Contraband"
                    end
                end
            end
        end
    end
    if spoofConfig.AnonymousMode then
        local N = getRealUserId(b)
        if not(yabujinUsers[N] and yabujinUsers[N].spoofer) then
            if J == "StatisticDuelsWinStreak" and spoofConfig.AnonStreak then
                return spoofConfig.AnonStreak
            end
            if J == "DisplayELO" and spoofConfig.AnonELO then
                return spoofConfig.AnonELO
            end
            if J == "Level" and spoofConfig.AnonLevel then
                return spoofConfig.AnonLevel
            end
            if J == "DisplayELOLeaderboardRanking" then
                return 0
            end
        end
    end
    return origGetAttribute(b, J)
end
end

-- ----------------------------------------------------------------------------
-- Function [8]: hookNametagDisplayName (527 bytes)
-- Description: Hooks player nametag/chat display name for yabujinUsers, AnonymousMode, and local UsernameSpoof.
-- Resolved Upvalues: [1] = LocalPlayer, [2] = getRealUserId, [3] = getSpoofedPlayerNames, [4] = spoofConfig, [5] = origNametagFunc
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookNametagDisplayName"]={"LocalPlayer","getRealUserId","getSpoofedPlayerNames","spoofConfig","origNametagFunc"}
    local LocalPlayer, getRealUserId, getSpoofedPlayerNames, spoofConfig, origNametagFunc = resolve("LocalPlayer"), resolve("getRealUserId"), resolve("getSpoofedPlayerNames"), resolve("spoofConfig"), resolve("origNametagFunc")
    YabujinDeobfuscated.hookNametagDisplayName = function(b, J, N, A)
        if J and J ~= LocalPlayer then local q = getRealUserId(J)
        local W = yabujinUsers[q] or yabujinUsers[tostring(q)]
        if W and W.spoofer and(next(W.spoofer)) then
            local q, q = getSpoofedPlayerNames(J)
            N = if q and q ~= "" then q else N
        elseif spoofConfig.AnonymousMode then
            return origNametagFunc(b, J, spoofConfig.AnonDisplayName or "Roblox", A)
        end
    end
    return origNametagFunc(b, J, if J == LocalPlayer and spoofConfig.UsernameSpoof then spoofConfig.SpoofedDisplayName ~= "" and spoofConfig.SpoofedDisplayName or(spoofConfig.SpoofedName ~= "" and spoofConfig.SpoofedName or J.DisplayName) else N, A)
end
end

-- ----------------------------------------------------------------------------
-- Function [20]: hookClientDataGet (9874 bytes)
-- Description: Core Rivals client data interceptor: spoofs Seasons, Ranked ELO, LeaderboardRank, BattlePass, Currencies (Keys, UnlockTokens, EventCurrency, Glory, SkinTickets), CosmeticInventory, WeaponInventory, EquippedCosmetics, EquippedEmotes, Statistics, FavoriteWeapons/Map, WeaponStatistics, DuelHistory, and LoggedELOEvents.
-- Resolved Upvalues: [1] = spooferActive, [2] = origDataGet, [3] = spoofConfig, [4] = rankedConfig, [5] = cachedSeasonsTable, [6] = cachedOrigSeasons, [7] = cachedSeasonsKey, [8] = equippedCosmeticsOverride, [9] = isCosmeticUnlocked, [10] = weaponUnlockMode, [11] = cachedWeaponInventory, [12] = specificUnlockedWeapons, [13] = ItemDatabase, [14] = favoritedWeaponsMap, [15] = WeaponConfig, [16] = favoritedCosmeticsOverride, [17] = equippedEmotesOverride, [18] = streakSpoofState
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookClientDataGet"]={"spooferActive","origDataGet","spoofConfig","rankedConfig","cachedSeasonsTable","cachedOrigSeasons","cachedSeasonsKey","equippedCosmeticsOverride","isCosmeticUnlocked","weaponUnlockMode","cachedWeaponInventory","specificUnlockedWeapons","ItemDatabase","favoritedWeaponsMap","WeaponConfig","favoritedCosmeticsOverride","equippedEmotesOverride","streakSpoofState"}
    local spooferActive, origDataGet, spoofConfig, rankedConfig, cachedSeasonsTable, cachedOrigSeasons, cachedSeasonsKey, equippedCosmeticsOverride, isCosmeticUnlocked, weaponUnlockMode, cachedWeaponInventory, specificUnlockedWeapons, ItemDatabase, favoritedWeaponsMap, WeaponConfig, favoritedCosmeticsOverride, equippedEmotesOverride, streakSpoofState = resolve("spooferActive"), resolve("origDataGet"), resolve("spoofConfig"), resolve("rankedConfig"), resolve("cachedSeasonsTable"), resolve("cachedOrigSeasons"), resolve("cachedSeasonsKey"), resolve("equippedCosmeticsOverride"), resolve("isCosmeticUnlocked"), resolve("weaponUnlockMode"), resolve("cachedWeaponInventory"), resolve("specificUnlockedWeapons"), resolve("ItemDatabase"), resolve("favoritedWeaponsMap"), resolve("WeaponConfig"), resolve("favoritedCosmeticsOverride"), resolve("equippedEmotesOverride"), resolve("streakSpoofState")
    YabujinDeobfuscated.hookClientDataGet = function(b, J, ...)
        if not spooferActive then return origDataGet(b, J, ...)
    end
    if spoofConfig.HideBeginnerTasks and J == "BeginnerTasksCompleted" then
        return math.huge
    end
    if J == "Seasons" then
        local N = rankedConfig.forceRankedFakeElo and spoofConfig._forceRankedSummaryElo ~= nil
        if not spoofConfig.ELOSpoof and not spoofConfig.PassSpoof and not spoofConfig.PassLevelSpoof and not N then
            return origDataGet(b, J, ...)
        end
        local A = origDataGet(b, J, ...)
        local q = tostring(spoofConfig.ELOSpoof) .. "|" .. tostring(spoofConfig.SpoofedELO or "") .. "|" .. tostring(spoofConfig.SpoofedLeaderboardRank or "") .. "|" .. tostring(rankedConfig.forceRankedFakeElo) .. "|" .. tostring(spoofConfig._forceRankedSummaryElo or "")
        if cachedSeasonsTable and cachedOrigSeasons == A and cachedSeasonsKey == q then
            return cachedSeasonsTable
        end
        if A then
            local W = table.clone(A)
            for U, L in pairs(W) do
                local h, B, R = false, if N then spoofConfig._forceRankedSummaryElo else
                if spoofConfig.ELOSpoof and spoofConfig.SpoofedELO then
                    spoofConfig.SpoofedELO
                else
                    nil
                    if B and L.RankedPerformances then
                        R = table.clone(L)
                        local s = table.clone(L.RankedPerformances)
                        for d, w in pairs(s) do
                            local u = table.clone(w)
                            u.CurrentELO = B
                            if not N and spoofConfig.SpoofedLeaderboardRank then
                                u.CurrentLeaderboardRanking = spoofConfig.SpoofedLeaderboardRank
                                if u.Metadata then
                                    w = table.clone(u.Metadata)
                                    w.FinalLeaderboardRank = spoofConfig.SpoofedLeaderboardRank
                                    u.Metadata = w
                                end
                            elseif not N then
                                u.CurrentLeaderboardRanking = nil
                            end
                            if u.HighestELO and u.HighestELO < B then
                                u.HighestELO = B
                            end
                            s[d] = u
                        end
                        R.RankedPerformances = s
                        h = true
                    else
                        R = L
                    end
                    if(spoofConfig.PassSpoof and spoofConfig.SpoofPassTrack or spoofConfig.PassLevelSpoof and spoofConfig.SpoofedPassLevel) and L.BattlePass then
                        R = if R == L then(table.clone(L)) else R
                        B = table.clone(L.BattlePass)
                        if spoofConfig.PassSpoof and spoofConfig.SpoofPassTrack then
                            if spoofConfig.SpoofPassTrack == 3 then
                                B.MaxPassTrackNum = 2
                                B.SeasonPassBundleOwned = true
                            else
                                B.MaxPassTrackNum = spoofConfig.SpoofPassTrack
                                B.SeasonPassBundleOwned = false
                            end
                        end
                        if spoofConfig.PassLevelSpoof and spoofConfig.SpoofedPassLevel then
                            B.PassLevel = spoofConfig.SpoofedPassLevel
                        end
                        R.BattlePass = B
                        h = true
                    end
                    if h then
                        W[U] = R
                    end
                end
                cachedSeasonsTable, cachedOrigSeasons, cachedSeasonsKey = W, A, q
                return W
            end
            return A
        end
        if J == "EquippedCosmetics" then
            local N = origDataGet(b, J, ...)
            if not next(equippedCosmeticsOverride) then
                return N
            end
            local A = N and(table.clone(N)) or{}
            for N, q in pairs(equippedCosmeticsOverride) do
                A[N] = A[N] or{}
                for W, U in pairs(q) do
                    A[N][W] = U
                end
            end
            return A
        end
        if J == "Level" then
            if spoofConfig.LevelSpoof and spoofConfig.SpoofedLevel then
                return spoofConfig.SpoofedLevel
            end
            return origDataGet(b, J, ...)
        end
        if J == "WeaponKeys" then
            if spoofConfig.KeysSpoof and spoofConfig.SpoofedKeys then
                return spoofConfig.SpoofedKeys
            end
            return origDataGet(b, J, ...)
        end
        if J == "UnlockTokens" then
            if spoofConfig.TokensSpoof and spoofConfig.SpoofedTokens then
                return spoofConfig.SpoofedTokens
            end
            return origDataGet(b, J, ...)
        end
        if J == "EventCurrency" then
            if spoofConfig.EventCurrSpoof and spoofConfig.SpoofedEventCurr then
                return spoofConfig.SpoofedEventCurr
            end
            return origDataGet(b, J, ...)
        end
        if J == "Glory" then
            if spoofConfig.GlorySpoof and spoofConfig.SpoofedGlory then
                return spoofConfig.SpoofedGlory
            end
            return origDataGet(b, J, ...)
        end
        if J == "SkinTickets" then
            if spoofConfig.SkinTicketsSpoof and spoofConfig.SpoofedSkinTickets then
                return spoofConfig.SpoofedSkinTickets
            end
            return origDataGet(b, J, ...)
        end
        if J == "StatisticPlaytime" then
            if spoofConfig.PlaytimeSpoof and spoofConfig.SpoofedPlaytime then
                return spoofConfig.SpoofedPlaytime
            end
            return origDataGet(b, J, ...)
        end
        if J == "CosmeticInventory" then
            if spoofConfig._cachedInvProxy and spoofConfig._cachedInvProxySelf == b then
                return spoofConfig._cachedInvProxy
            end
            local N, A, q = b, 0
            local W = setmetatable({}, {__index = function(U, L)
                if not spooferActive then
                if q then
                    return rawget(q, L)
                end
                return nil
            end
            U = tick()
            if not q or U -A > 2 then
                q, A = origDataGet(N, "CosmeticInventory"), U
            end
            if q and(rawget(q, L)) then
                return rawget(q, L)
            end
            if isCosmeticUnlocked(L) then
                return true
            end
        end
        })
        spoofConfig._cachedInvProxy = W
        spoofConfig._cachedInvProxySelf = b
        return W
    end
    if J == "WeaponInventory" then
        if weaponUnlockMode == "none" then
            local N = origDataGet(b, J, ...)
            if type(spoofConfig._scriptUnlockedWeapons) ~= "table" or not next(spoofConfig._scriptUnlockedWeapons) then
                return N
            end
            local A = {}
            if N then
                for q, W in pairs(N) do
                    if not spoofConfig._scriptUnlockedWeapons[W and W.Name or q] then
                        A[q] = W
                    end
                end
            end
            return A
        end
        if cachedWeaponInventory then
            return cachedWeaponInventory
        end
        local N = origDataGet(b, J, ...)
        local A = {}
        if weaponUnlockMode == "specific" then
            if N then
                for q, W in pairs(N) do
                    if specificUnlockedWeapons[q] then
                        A[q] = W
                    end
                end
            end
            for q in pairs(specificUnlockedWeapons) do
                if not A[q] then
                    local W = ItemDatabase.Items[q]
                    if W and W.Class then
                        A[q] = {Name = q, Owned = true, Class = W.Class, Unlocked = true, Level = 1, XP = 0, IsFavorited = favoritedWeaponsMap[q] or false}
                    end
                end
            end
        elseif weaponUnlockMode == "unlockable" then
            if N then
                for q, W in pairs(N) do
                    A[q] = W
                end
            end
            for q, W in ipairs(WeaponConfig.OwnableWeapons or{}) do
                if not A[W] then
                    q = ItemDatabase.Items[W]
                    if q and q.Class then
                        A[W] = {Name = W, Owned = true, Class = q.Class, Unlocked = true, Level = 1, XP = 0, IsFavorited = favoritedWeaponsMap[W] or false}
                    end
                end
            end
        elseif weaponUnlockMode == "all" then
            if N then
                for q, W in pairs(N) do
                    A[q] = W
                end
            end
            for N, q in pairs(ItemDatabase.Items) do
                if not A[N] and q and q.Class then
                    A[N] = {Name = N, Owned = true, Class = q.Class, Unlocked = true, Level = 1, XP = 0, IsFavorited = favoritedWeaponsMap[N] or false}
                end
            end
        end
        for N, q in pairs(A) do
            if favoritedWeaponsMap[N] ~= nil then
                q.IsFavorited = favoritedWeaponsMap[N]
            end
        end
        cachedWeaponInventory = A
        return A
    end
    if J == "FavoritedCosmetics" then
        local N = origDataGet(b, J, ...)
        if not next(favoritedCosmeticsOverride) then
            return N
        end
        local A, q = N and(table.clone(N)) or{}, origDataGet(b, "CosmeticInventory")
        for N, W in pairs(favoritedCosmeticsOverride) do
            for U, L in pairs(W) do
                if L and(isCosmeticUnlocked(U) or q and(rawget(q, U))) then
                    A[N] = A[N] or{}
                    A[N][U] = L
                end
            end
        end
        return A
    end
    if J == "EquippedEmotes" then
        if not next(equippedEmotesOverride) then
            return origDataGet(b, J, ...)
        end
        local N = origDataGet(b, J, ...)
        local A = N and(table.clone(N)) or{}
        for N, q in pairs(equippedEmotesOverride) do
            if q and q.Name and q.Name ~= "" then
                A[N] = q
            end
        end
        return A
    end
    if J == "RankedELO" or J == "RankedCurrentELO" or J == "ELO" then
        if spoofConfig.ELOSpoof and spoofConfig.SpoofedELO then
            return spoofConfig.SpoofedELO
        end
        return origDataGet(b, J, ...)
    end
    if J == "Statistics" then
        if not spoofConfig.StatsSpoof or not spoofConfig.SpoofedStats then
            return origDataGet(b, J, ...)
        end
        local N = origDataGet(b, J, ...)
        if not N then
            return N
        end
        local A, q = table.clone(N), spoofConfig.SpoofedStats
        if q.casualWins then
            A.CasualWins = q.casualWins
        end
        if q.casualLosses then
            A.CasualLosses = q.casualLosses
        end
        if q.rankedWins then
            A.RankedWins = q.rankedWins
        end
        if q.rankedLosses then
            A.RankedLosses = q.rankedLosses
        end
        if q.streak then
            A.Streak = q.streak
        end
        return A
    end
    if spoofConfig.StatsSpoof and spoofConfig.SpoofedStats then
        local N = spoofConfig.SpoofedStats
        if J == "StatisticDuelsWon" and N.casualWins then
            return N.casualWins
        end
        if J == "StatisticDuelsLost" and N.casualLosses then
            return N.casualLosses
        end
        if J == "StatisticDuelsWinStreak" and streakSpoofState.streakEnabled then
            local A = streakSpoofState.spoofedStreak or 0
            if streakSpoofState.streakStackReal then
                return(origDataGet(b, J, ...) or 0) + A
            end
            return A
        end
        if J == "StatisticRankedDuelsWon" and N.rankedWins then
            return N.rankedWins
        end
        if J == "StatisticRankedDuelsLost" and N.rankedLosses then
            return N.rankedLosses
        end
        if J == "StatisticDuelsWinPercent" then
            local A = N.casualWins or(origDataGet(b, "StatisticDuelsWon")) or 0
            local q = A + (N.casualLosses or(origDataGet(b, "StatisticDuelsLost")) or 0)
            if q > 0 then
                return A / q
            end
        end
        if J == "StatisticRankedDuelsWinPercent" then
            local A = N.rankedWins or(origDataGet(b, "StatisticRankedDuelsWon")) or 0
            local q = A + (N.rankedLosses or(origDataGet(b, "StatisticRankedDuelsLost")) or 0)
            if q > 0 then
                return A / q
            end
        end
        if J == "StatisticDuelsPlayed" then
            local A, q = N.casualWins or(origDataGet(b, "StatisticDuelsWon")) or 0, N.casualLosses or(origDataGet(b, "StatisticDuelsLost")) or 0
            if N.casualWins or N.casualLosses then
                return A + q
            end
        end
        if J == "StatisticRankedDuelsPlayed" then
            local A, q = N.rankedWins or(origDataGet(b, "StatisticRankedDuelsWon")) or 0, N.rankedLosses or(origDataGet(b, "StatisticRankedDuelsLost")) or 0
            if N.rankedWins or N.rankedLosses then
                return A + q
            end
        end
    end
    if spoofConfig.FavSpoof then
        if J == "StatisticFavoriteWeaponPrimary" and spoofConfig.SpoofedFavWeapons and spoofConfig.SpoofedFavWeapons.Primary then
            return spoofConfig.SpoofedFavWeapons.Primary
        end
        if J == "StatisticFavoriteWeaponSecondary" and spoofConfig.SpoofedFavWeapons and spoofConfig.SpoofedFavWeapons.Secondary then
            return spoofConfig.SpoofedFavWeapons.Secondary
        end
        if J == "StatisticFavoriteWeaponMelee" and spoofConfig.SpoofedFavWeapons and spoofConfig.SpoofedFavWeapons.Melee then
            return spoofConfig.SpoofedFavWeapons.Melee
        end
        if J == "StatisticFavoriteWeaponUtility" and spoofConfig.SpoofedFavWeapons and spoofConfig.SpoofedFavWeapons.Utility then
            return spoofConfig.SpoofedFavWeapons.Utility
        end
        if J == "StatisticFavoriteWeapon" and spoofConfig.SpoofedFavWeapons then
            local N = spoofConfig.SpoofedFavWeapons.Primary or spoofConfig.SpoofedFavWeapons.Secondary or spoofConfig.SpoofedFavWeapons.Melee or spoofConfig.SpoofedFavWeapons.Utility
            if N then
                return N
            end
        end
        if J == "StatisticFavoriteMap" and spoofConfig.SpoofedFavMap then
            return spoofConfig.SpoofedFavMap
        end
    end
    if J == "WeaponStatistics" then
        local N, A = origDataGet(b, J, ...), spoofConfig.ContractSpoof
        if A and A.enabled and A.perWeapon then
            local q = N and(table.clone(N)) or{}
            for W, U in pairs(A.perWeapon) do
                if U and(U.kills or U.playtime) then
                    local L = q[W] and(table.clone(q[W])) or{}
                    if A.stackReal then
                        if U.kills then
                            L.StatisticEliminations = (L.StatisticEliminations or 0) + U.kills
                        end
                        if U.playtime then
                            L.StatisticPlaytime = (L.StatisticPlaytime or 0) + U.playtime
                        end
                    else
                        if U.kills then
                            L.StatisticEliminations = U.kills
                        end
                        if U.playtime then
                            L.StatisticPlaytime = U.playtime
                        end
                    end
                    q[W] = L
                end
            end
            return q
        end
        return N
    end
    if J == "DuelHistory" then
        local N = origDataGet(b, J, ...)
        if not spoofConfig.DuelHistorySpoof or not spoofConfig.SpoofedDuelHistory or#spoofConfig.SpoofedDuelHistory == 0 then
            return N
        end
        local A = {}
        for q, q in ipairs(spoofConfig.SpoofedDuelHistory) do
            A[#A + 1] = q
        end
        if spoofConfig.DuelHistoryReplace then
            return A
        end
        if N and type(N) == "table" then
            for q, q in ipairs(N) do
                A[#A + 1] = q
            end
        end
        return A
    end
    if J == "LoggedELOEvents" then
        local N = origDataGet(b, J, ...)
        if not spoofConfig.DuelHistorySpoof or not spoofConfig.SpoofedELOEvents or#spoofConfig.SpoofedELOEvents == 0 then
            return N
        end
        local A = {}
        for q, q in ipairs(spoofConfig.SpoofedELOEvents) do
            A[#A + 1] = q
        end
        if not spoofConfig.DuelHistoryReplace and N and type(N) == "table" then
            for q, q in ipairs(N) do
                A[#A + 1] = q
            end
        end
        return A
    end
    return origDataGet(b, J, ...)
end
end

-- ----------------------------------------------------------------------------
-- Function [126]: isCosmeticUnlockedCached (320 bytes)
-- Description: Checks whether a cosmetic item is unlocked across 5 cosmetic tables with a cfg.cacheTtl timestamp cache.
-- Resolved Upvalues: [1] = forceUnlockAll, [2] = unlockerEnabled, [3] = ownershipCache, [4] = timestampCache, [5] = unlockedTable1, [6] = unlockedTable2, [7] = unlockedTable3, [8] = unlockedTable4, [9] = unlockedTable5
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["isCosmeticUnlockedCached"]={"forceUnlockAll","unlockerEnabled","ownershipCache","timestampCache","unlockedTable1","unlockedTable2","unlockedTable3","unlockedTable4","unlockedTable5"}
    local forceUnlockAll, unlockerEnabled, ownershipCache, timestampCache, unlockedTable1, unlockedTable2, unlockedTable3, unlockedTable4, unlockedTable5 = resolve("forceUnlockAll"), resolve("unlockerEnabled"), resolve("ownershipCache"), resolve("timestampCache"), resolve("unlockedTable1"), resolve("unlockedTable2"), resolve("unlockedTable3"), resolve("unlockedTable4"), resolve("unlockedTable5")
    YabujinDeobfuscated.isCosmeticUnlockedCached = function(b)
        if not forceUnlockAll and not unlockerEnabled then return false
    end
    local J = tick()
    local N = ownershipCache[b]
    if N ~= nil and J -(timestampCache[b] or 0) < cfg.cacheTtl then
        return N
    end
    N = unlockedTable1[b] or unlockedTable2[b] or unlockedTable3[b] or unlockedTable4[b] or unlockedTable5[b]
    ownershipCache[b] = N
    timestampCache[b] = J
    return N
end
end

-- ----------------------------------------------------------------------------
-- Function [18]: hookOwnsWeaponCosmetic (542 bytes)
-- Description: Hooks weapon cosmetic ownership check (ownsWep) to unlock skins/cosmetics.
-- Resolved Upvalues: [1] = unlockerEnabled, [2] = origCosmeticController, [3] = spoofConfig, [4] = unlockedTable1, [5] = unlockedTable2, [6] = unlockedTable3, [7] = unlockedTable4, [8] = unlockedTable5, [9] = weaponSkinsMap1, [10] = weaponSkinsMap2, [11] = weaponSkinsMap3
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookOwnsWeaponCosmetic"]={"unlockerEnabled","origCosmeticController","spoofConfig","unlockedTable1","unlockedTable2","unlockedTable3","unlockedTable4","unlockedTable5","weaponSkinsMap1","weaponSkinsMap2","weaponSkinsMap3"}
    local unlockerEnabled, origCosmeticController, spoofConfig, unlockedTable1, unlockedTable2, unlockedTable3, unlockedTable4, unlockedTable5, weaponSkinsMap1, weaponSkinsMap2, weaponSkinsMap3 = resolve("unlockerEnabled"), resolve("origCosmeticController"), resolve("spoofConfig"), resolve("unlockedTable1"), resolve("unlockedTable2"), resolve("unlockedTable3"), resolve("unlockedTable4"), resolve("unlockedTable5"), resolve("weaponSkinsMap1"), resolve("weaponSkinsMap2"), resolve("weaponSkinsMap3")
    YabujinDeobfuscated.hookOwnsWeaponCosmetic = function(b, J, N, A)
        if not N or string.sub(N, 1, 8) == "MISSING_" then return false
    end
    if not unlockerEnabled then
        return origCosmeticController.ownsWep(b, J, N, A)
    end
    if spoofConfig._menuLockedCosmetics and spoofConfig._menuLockedCosmetics[N] then
        return false
    end
    if origCosmeticController.ownsWep(b, J, N, A) then
        return true
    end
    if unlockedTable1[N] or unlockedTable2[N] or unlockedTable3[N] or unlockedTable4[N] or unlockedTable5[N] then
        return true
    end
    if A then
        J = weaponSkinsMap1[N]
        if J and J[A] then
            return true
        end
        b = weaponSkinsMap2[N]
        if b and b[A] then
            return true
        end
        local b = weaponSkinsMap3[N]
        if b and b[A] then
            return true
        end
    end
    return false
end
end

-- ----------------------------------------------------------------------------
-- Function [63]: hookOwnsUniversalCosmetic (357 bytes)
-- Description: Hooks universal cosmetic ownership check (ownsUniv).
-- Resolved Upvalues: [1] = unlockerEnabled, [2] = origCosmeticController, [3] = spoofConfig, [4] = unlockedTable1, [5] = unlockedTable2, [6] = unlockedTable3, [7] = unlockedTable4, [8] = unlockedTable5
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookOwnsUniversalCosmetic"]={"unlockerEnabled","origCosmeticController","spoofConfig","unlockedTable1","unlockedTable2","unlockedTable3","unlockedTable4","unlockedTable5"}
    local unlockerEnabled, origCosmeticController, spoofConfig, unlockedTable1, unlockedTable2, unlockedTable3, unlockedTable4, unlockedTable5 = resolve("unlockerEnabled"), resolve("origCosmeticController"), resolve("spoofConfig"), resolve("unlockedTable1"), resolve("unlockedTable2"), resolve("unlockedTable3"), resolve("unlockedTable4"), resolve("unlockedTable5")
    YabujinDeobfuscated.hookOwnsUniversalCosmetic = function(b, J, N)
        if not N or string.sub(N, 1, 8) == "MISSING_" then return false
    end
    if not unlockerEnabled then
        return origCosmeticController.ownsUniv(b, J, N)
    end
    if spoofConfig._menuLockedCosmetics and spoofConfig._menuLockedCosmetics[N] then
        return false
    end
    if origCosmeticController.ownsUniv(b, J, N) then
        return true
    end
    return unlockedTable1[N] or unlockedTable2[N] or unlockedTable3[N] or unlockedTable4[N] or unlockedTable5[N] or false
end
end

-- ----------------------------------------------------------------------------
-- Function [69]: hookOwnsGeneralCosmetic (532 bytes)
-- Description: Hooks general cosmetic ownership check (owns).
-- Resolved Upvalues: [1] = unlockerEnabled, [2] = origCosmeticController, [3] = spoofConfig, [4] = unlockedTable1, [5] = unlockedTable2, [6] = unlockedTable3, [7] = unlockedTable4, [8] = unlockedTable5, [9] = weaponSkinsMap1, [10] = weaponSkinsMap2, [11] = weaponSkinsMap3
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookOwnsGeneralCosmetic"]={"unlockerEnabled","origCosmeticController","spoofConfig","unlockedTable1","unlockedTable2","unlockedTable3","unlockedTable4","unlockedTable5","weaponSkinsMap1","weaponSkinsMap2","weaponSkinsMap3"}
    local unlockerEnabled, origCosmeticController, spoofConfig, unlockedTable1, unlockedTable2, unlockedTable3, unlockedTable4, unlockedTable5, weaponSkinsMap1, weaponSkinsMap2, weaponSkinsMap3 = resolve("unlockerEnabled"), resolve("origCosmeticController"), resolve("spoofConfig"), resolve("unlockedTable1"), resolve("unlockedTable2"), resolve("unlockedTable3"), resolve("unlockedTable4"), resolve("unlockedTable5"), resolve("weaponSkinsMap1"), resolve("weaponSkinsMap2"), resolve("weaponSkinsMap3")
    YabujinDeobfuscated.hookOwnsGeneralCosmetic = function(b, J, N, A)
        if not N or string.sub(N, 1, 8) == "MISSING_" then return false
    end
    if not unlockerEnabled then
        return origCosmeticController.owns(b, J, N, A)
    end
    if spoofConfig._menuLockedCosmetics and spoofConfig._menuLockedCosmetics[N] then
        return false
    end
    if origCosmeticController.owns(b, J, N, A) then
        return true
    end
    if unlockedTable1[N] or unlockedTable2[N] or unlockedTable3[N] or unlockedTable4[N] or unlockedTable5[N] then
        return true
    end
    if A then
        J = weaponSkinsMap1[N]
        if J and J[A] then
            return true
        end
        b = weaponSkinsMap2[N]
        if b and b[A] then
            return true
        end
        local b = weaponSkinsMap3[N]
        if b and b[A] then
            return true
        end
    end
    return false
end
end

-- ----------------------------------------------------------------------------
-- Function [73]: hookOwnsCategoryCosmetic (494 bytes)
-- Description: Hooks category cosmetic ownership check (ownsSome).
-- Resolved Upvalues: [1] = unlockerEnabled, [2] = origCosmeticController, [3] = spoofConfig, [4] = isCosmeticUnlocked, [5] = weaponSkinsMap1, [6] = weaponSkinsMap2, [7] = weaponSkinsMap3
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookOwnsCategoryCosmetic"]={"unlockerEnabled","origCosmeticController","spoofConfig","isCosmeticUnlocked","weaponSkinsMap1","weaponSkinsMap2","weaponSkinsMap3"}
    local unlockerEnabled, origCosmeticController, spoofConfig, isCosmeticUnlocked, weaponSkinsMap1, weaponSkinsMap2, weaponSkinsMap3 = resolve("unlockerEnabled"), resolve("origCosmeticController"), resolve("spoofConfig"), resolve("isCosmeticUnlocked"), resolve("weaponSkinsMap1"), resolve("weaponSkinsMap2"), resolve("weaponSkinsMap3")
    YabujinDeobfuscated.hookOwnsCategoryCosmetic = function(b, J, N)
        if not N or string.sub(N, 1, 8) == "MISSING_" then return false
    end
    if not unlockerEnabled then
        return origCosmeticController.ownsSome(b, J, N)
    end
    if spoofConfig._menuLockedCosmetics and spoofConfig._menuLockedCosmetics[N] then
        return false
    end
    if origCosmeticController.ownsSome(b, J, N) then
        return true
    end
    if isCosmeticUnlocked(N) then
        return true
    end
    J = weaponSkinsMap1[N]
    if J and(next(J)) then
        return true
    end
    b = weaponSkinsMap2[N]
    if b and(next(b)) then
        return true
    end
    b = weaponSkinsMap3[N]
    if b and(next(b)) then
        return true
    end
    return false
end
end

-- ----------------------------------------------------------------------------
-- Function [96]: hookOwnsNormalCosmetic (371 bytes)
-- Description: Hooks normal cosmetic ownership check (ownsNormal).
-- Resolved Upvalues: [1] = unlockerEnabled, [2] = origCosmeticController, [3] = spoofConfig, [4] = unlockedTable1, [5] = unlockedTable2, [6] = unlockedTable3, [7] = unlockedTable4, [8] = unlockedTable5
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookOwnsNormalCosmetic"]={"unlockerEnabled","origCosmeticController","spoofConfig","unlockedTable1","unlockedTable2","unlockedTable3","unlockedTable4","unlockedTable5"}
    local unlockerEnabled, origCosmeticController, spoofConfig, unlockedTable1, unlockedTable2, unlockedTable3, unlockedTable4, unlockedTable5 = resolve("unlockerEnabled"), resolve("origCosmeticController"), resolve("spoofConfig"), resolve("unlockedTable1"), resolve("unlockedTable2"), resolve("unlockedTable3"), resolve("unlockedTable4"), resolve("unlockedTable5")
    YabujinDeobfuscated.hookOwnsNormalCosmetic = function(b, J, N, A)
        if not N or string.sub(N, 1, 8) == "MISSING_" then return false
    end
    if not unlockerEnabled then
        return origCosmeticController.ownsNormal(b, J, N, A)
    end
    if spoofConfig._menuLockedCosmetics and spoofConfig._menuLockedCosmetics[N] then
        return false
    end
    if origCosmeticController.ownsNormal(b, J, N, A) then
        return true
    end
    return unlockedTable1[N] or unlockedTable2[N] or unlockedTable3[N] or unlockedTable4[N] or unlockedTable5[N] or false
end
end

-- ----------------------------------------------------------------------------
-- Function [102]: hookShopPurchaseSkinTickets (596 bytes)
-- Description: Hooks shop purchase controller to spoof SkinTickets purchases, deduct SpoofedSkinTickets, replicate CurrentData, and trigger _onSkinTicketPurchase.
-- Resolved Upvalues: [1] = spoofConfig, [2] = savedSettings, [3] = pcall, [4] = clientDataController, [5] = origShopPurchase
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookShopPurchaseSkinTickets"]={"spoofConfig","savedSettings","pcall","clientDataController","origShopPurchase"}
    local spoofConfig, savedSettings, pcall, clientDataController, origShopPurchase = resolve("spoofConfig"), resolve("savedSettings"), resolve("pcall"), resolve("clientDataController"), resolve("origShopPurchase")
    YabujinDeobfuscated.hookShopPurchaseSkinTickets = function(b, J, N, ...)
        if spoofConfig.SkinTicketsSpoof and N == "SkinTickets" then local A = b
        task.spawn(function()
            game:GetService("RunService").Heartbeat:Wait()
            local q = A:GetShopEntry(J)
            if q then
                local A = q.Prices and q.Prices[N] or 10
                if spoofConfig.SpoofedSkinTickets then
                    spoofConfig.SpoofedSkinTickets = math.max(0, spoofConfig.SpoofedSkinTickets -A)
                    savedSettings.spoofSkinTickets = spoofConfig.SpoofedSkinTickets
                    pcall(function()
                        clientDataController.CurrentData:Replicate("SkinTickets")
                    end)
                end
                if spoofConfig._onSkinTicketPurchase then
                    spoofConfig._onSkinTicketPurchase(q)
                end
            end
        end)
        return
    end
    return origShopPurchase(b, J, N, ...)
end
end

-- ----------------------------------------------------------------------------
-- Function [48]: hookLeaderboardSurfaceGui (1136 bytes)
-- Description: Hooks in-world Leaderboard SurfaceGui slot generation to spoof avatar headshots for LocalPlayer and yabujinUsers.
-- Resolved Upvalues: [1] = pcall, [2] = origGenerateLeaderboard, [3] = localUserId, [4] = spoofConfig, [5] = leaderboardConstants, [6] = getYabujinSpoofField
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookLeaderboardSurfaceGui"]={"pcall","origGenerateLeaderboard","localUserId","spoofConfig","leaderboardConstants","getYabujinSpoofField"}
    local pcall, origGenerateLeaderboard, localUserId, spoofConfig, leaderboardConstants, getYabujinSpoofField = resolve("pcall"), resolve("origGenerateLeaderboard"), resolve("localUserId"), resolve("spoofConfig"), resolve("leaderboardConstants"), resolve("getYabujinSpoofField")
    YabujinDeobfuscated.hookLeaderboardSurfaceGui = function(b)
        pcall(function()
            for J, J in pairs(b._player_slots or{}) do
                pcall(function()
                    J:Destroy()
                end)
            end
        end)
        b._player_slots = {}
        b._generate_hash = (b._generate_hash or 0) + 1
        if b.SurfaceGui and b.SurfaceGui.Title then
            b.SurfaceGui.Title.Text = "Loading..."
        end
        local J = origGenerateLeaderboard(b)
        pcall(function()
            local N = b._leaderboards_serial and b._leaderboards_serial[b._leaderboard_name]
            local A = N and N.Players
            if not A or#A == 0 or not b._player_slots then
                return
            end
            for q, W in ipairs(b._player_slots) do
                N = A[q]
                if not N then
                    break
                end
                q = tonumber(N.key)
                if not q then
                    break
                end
                if q == localUserId or spoofConfig.AvatarSpoof and spoofConfig.AvatarUserId and q == spoofConfig.AvatarUserId then
                    if spoofConfig.AvatarSpoof and spoofConfig.AvatarUserId and spoofConfig.AvatarUserId ~= 0 then
                        pcall(function()
                            W.Left.Headshot.Image = string.format(leaderboardConstants.HEADSHOT_IMAGE, spoofConfig.AvatarUserId)
                        end)
                    end
                elseif yabujinUsers[q] and yabujinUsers[q].spoofer then
                    local b = getYabujinSpoofField(q, "Avatar")
                    if b and type(b) == "number" and b ~= 0 then
                        pcall(function()
                            W.Left.Headshot.Image = string.format(leaderboardConstants.HEADSHOT_IMAGE, b)
                        end)
                    end
                end
            end
        end)
        return J
    end
end

-- ----------------------------------------------------------------------------
-- Function [13]: hookGetNetworkPing (524 bytes)
-- Description: Hooks network ping getter to spoof ping (Static, Random, Multiply, Divide, Plus, Minus).
-- Resolved Upvalues: [1] = origGetPing, [2] = pingConfig
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["hookGetNetworkPing"]={"origGetPing","pingConfig"}
    local origGetPing, pingConfig = resolve("origGetPing"), resolve("pingConfig")
    YabujinDeobfuscated.hookGetNetworkPing = function(b, J, ...)
        local N = origGetPing(b, J, ...)
        if pingConfig.PingSpoof then
            J, b = pingConfig.PingMode or "Static", pingConfig.PingValue or 20
            if J == "Static" then
                return b
            elseif J == "Random" then
                local A, q = tonumber(pingConfig.PingRandomMin) or 1, tonumber(pingConfig.PingRandomMax) or 100
                if A > q then
                    q, A = A, q
                end
                return math.random(A, q)
            elseif J == "Multiply" then
                return math.floor(N * b)
            elseif J == "Divide" then
                return math.floor(N / b)
            elseif J == "Plus" then
                return math.floor(N + b)
            elseif J == "Minus" then
                return math.floor(N -b)
            end
        end
        return N
    end
end

-- ----------------------------------------------------------------------------
-- Function [60]: updateStretchedResolution (809 bytes)
-- Description: Applies horizontal/vertical aspect-ratio stretch to CurrentCamera.CFrame and compensates BillboardGui StudsOffsetWorldSpace across all player characters.
-- Resolved Upvalues: [1] = Workspace, [2] = stretchConfig, [3] = Players, [4] = origBillboardOffsets
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["updateStretchedResolution"]={"Workspace","stretchConfig","Players","origBillboardOffsets"}
    local Workspace, stretchConfig, Players, origBillboardOffsets = resolve("Workspace"), resolve("stretchConfig"), resolve("Players"), resolve("origBillboardOffsets")
    YabujinDeobfuscated.updateStretchedResolution = function()
        local b = Workspace.CurrentCamera
        if not b then
            return
        end
        local J, N = stretchConfig.x, stretchConfig.y
        if J ~= 1 and J > 0 then
            b.CFrame = b.CFrame * CFrame.new(0, 0, 0, J, 0, 0, 0, 1, 0, 0, 0, 1)
            local A = b.CFrame.Position
            local q = b.CFrame.RightVector
            local W = 1 / J -1
            for J, U in ipairs(Players:GetPlayers()) do
                J = U.Character
                if J then
                    for U, U in ipairs(J:GetChildren()) do
                        if U:IsA("BasePart") then
                            for J, L in ipairs(U:GetChildren()) do
                                if L:IsA("BillboardGui") then
                                    if not origBillboardOffsets[L] then
                                        origBillboardOffsets[L] = L.StudsOffsetWorldSpace
                                    end
                                    J = ((L.Adornee and typeof(L.Adornee) == "Instance" and(L.Adornee:IsA("BasePart")) and L.Adornee.Position or U.Position) -A):Dot(q)
                                    L.StudsOffsetWorldSpace = origBillboardOffsets[L] + q * (J * W)
                                end
                            end
                        end
                    end
                end
            end
        end
        if N ~= 1 then
            b.CFrame = b.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, N, 0, 0, 0, 1)
        end
    end
end

-- ----------------------------------------------------------------------------
-- Function [17]: updateCameraMotionBlur (418 bytes)
-- Description: Updates camera motion blur Size each frame based on camera velocity and angular rotation.
-- Resolved Upvalues: [1] = motionBlurState
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["updateCameraMotionBlur"]={"motionBlurState"}
    local motionBlurState = resolve("motionBlurState")
    YabujinDeobfuscated.updateCameraMotionBlur = function(b)
        local J = workspace.CurrentCamera
        if not J or not motionBlurState.blur then
            return
        end
        local N = J.CFrame
        if motionBlurState.lastCFrame then
            J = motionBlurState.lastCFrame
            local A, q = (N.Position -J.Position).Magnitude / math.max(b, 0.004166666666666667), (N.LookVector -J.LookVector).Magnitude * 60
            local b = math.clamp(A * 0.05 + q * motionBlurState.strength * 0.5, 0, motionBlurState.strength)
            motionBlurState.blur.Size = motionBlurState.blur.Size * 0.5 + b * 0.5
        end
        motionBlurState.lastCFrame = N
    end
end

-- ----------------------------------------------------------------------------
-- Function [78]: syncPartToCameraCFrame (160 bytes)
-- Description: Synchronizes a world part's CFrame directly to workspace.CurrentCamera.CFrame.
-- Resolved Upvalues: [1] = targetPart, [2] = lastCameraCFrame
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["syncPartToCameraCFrame"]={"targetPart","lastCameraCFrame"}
    local targetPart, lastCameraCFrame = resolve("targetPart"), resolve("lastCameraCFrame")
    YabujinDeobfuscated.syncPartToCameraCFrame = function()
        local b = workspace.CurrentCamera
        if b and targetPart.Parent then
            lastCameraCFrame = b.CFrame
            targetPart.CFrame = lastCameraCFrame
        end
    end
end

-- ----------------------------------------------------------------------------
-- Function [85]: syncPartAboveCamera (195 bytes)
-- Description: Positions a target part 32 studs above workspace.CurrentCamera.CFrame.Position.
-- Resolved Upvalues: [1] = pcall, [2] = targetPart
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["syncPartAboveCamera"]={"pcall","targetPart"}
    local pcall, targetPart = resolve("pcall"), resolve("targetPart")
    YabujinDeobfuscated.syncPartAboveCamera = function()
        pcall(function()
            local b = workspace.CurrentCamera
            if b and targetPart.Parent then
                targetPart.CFrame = CFrame.new(b.CFrame.Position + Vector3.new(0, 32, 0))
            end
        end)
    end
end

-- ----------------------------------------------------------------------------
-- Function [107]: updateBezierPulseBeams (2106 bytes)
-- Description: Updates 3D cubic Bezier pulse beam parts (size, CFrame orientation, transparency, and ColorSequence keypoints).
-- Resolved Upvalues: [1] = activeBeamsList, [2] = heartbeatConnection, [3] = clockFunc, [4] = calcPulseAlpha, [5] = evalCubicBezier, [6] = simplexNoise, [7] = beamRotationOffset
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["updateBezierPulseBeams"]={"activeBeamsList","heartbeatConnection","clockFunc","calcPulseAlpha","evalCubicBezier","simplexNoise","beamRotationOffset"}
    local activeBeamsList, heartbeatConnection, clockFunc, calcPulseAlpha, evalCubicBezier, simplexNoise, beamRotationOffset = resolve("activeBeamsList"), resolve("heartbeatConnection"), resolve("clockFunc"), resolve("calcPulseAlpha"), resolve("evalCubicBezier"), resolve("simplexNoise"), resolve("beamRotationOffset")
    YabujinDeobfuscated.updateBezierPulseBeams = function()
        if next(activeBeamsList) == nil then
        if heartbeatConnection then
            heartbeatConnection:Disconnect()
            heartbeatConnection = nil
        end
        return
    end
    for b, J in pairs(activeBeamsList) do
        if J.Enabled == true then
            J.PartsHidden = false
            local N, A, q, W, U, L = 1 -J.MaxTransparency, 1 -J.MinTransparency, J.MinRadius, J.MaxRadius, J.Thickness, J.Parts
            local h, B, R, s, d, w, u, C, o, H, z = #L, J.RanNum, J.StartT, J.AnimationSpeed, J.Frequency, J.MinThicknessMultiplier, J.MaxThicknessMultiplier, J.Attachment0, J.Attachment1, J.CurveSize0, J.CurveSize1
            local P = C.WorldPosition
            local Y = C.WorldPosition + C.WorldAxis * H
            local f = o.WorldPosition -o.WorldAxis * z
            local l = o.WorldPosition
            local Q, v, Z, p, F, a, t = clockFunc() -R, J.PulseLength, J.PulseSpeed, J.FadeLength, J.Color, J.ColorOffsetSpeed, 1 -J.ContractFrom
            if Q < (v + 1) / Z then
                C, b = P, P
                for g = 1, h, 1 do
                    local _ = L[g]
                    local L = g / h
                    H = calcPulseAlpha(L, Z, v, p, Q, N, A)
                    R, z = evalCubicBezier(P, Y, f, l, L), -Q
                    local N = s * z + d * 10 * L -0.2 + B * 4
                    local A = 5 * (s * 0.01 * z / 10 + d * L) + B * 4
                    local s, d, z = simplexNoise(5 * N, 1.5, 1 * A, 0, 0.6283185307179586) + simplexNoise(0.5 * N, 1.5, 0.1 * A, 0, 5.654866776461628), simplexNoise(3.4, A, N, q, W) * math.exp(- 5000 * (L -0.5) ^ 10), simplexNoise(2.3, A, N, w, u)
                    local q = g ~= h and(CFrame.new(C, R) * CFrame.Angles(0, 0, s) * CFrame.Angles(math.acos(math.clamp(simplexNoise(A, N, 2.7, 6.123233995736766E-17, 1), -1, 1)), 0, 0) * CFrame.new(0, 0, -d)).Position or R
                    if H > t then
                        _.Size = Vector3.new((q -b).Magnitude, U * z * H, U * z * H)
                        _.CFrame = CFrame.lookAt(0.5 * (b + q), q) * beamRotationOffset
                        _.Transparency = 1 -H
                    elseif H > t -1 / (h * p) then
                        o = (1 -(H -(t -1 / (h * p))) * h * p) * (L < Q * Z -0.5 * v and 1 or -1)
                        _.Size = Vector3.new((1 -math.abs(o)) * (q -b).Magnitude, U * z * H, U * z * H)
                        _.CFrame = CFrame.lookAt(b + (q -b) * (math.max(0, o) + 0.5 * (1 -math.abs(o))), q) * beamRotationOffset
                        _.Transparency = 1 -H
                    else
                        _.Transparency = 1
                    end
                    if typeof(F) == "Color3" then
                        _.Color = F
                    else
                        L = (B + L -Q * a) % 1
                        g = F.Keypoints
                        for M = 1, #g -1, 1 do
                            if g[M].Time < L and L < g[M + 1].Time then
                                _.Color = g[M].Value:Lerp(g[M + 1].Value, (L -g[M].Time) / (g[M + 1].Time -g[M].Time))
                                break
                            end
                        end
                    end
                    C, b = R, q
                end
            else
                J:Destroy()
            end
        elseif J.PartsHidden == false then
            J.PartsHidden = true
            local M = J.DisabledTransparency
            for b = 1, #J.Parts, 1 do
                J.Parts[b].Transparency = M
            end
        end
    end
end
end

-- ----------------------------------------------------------------------------
-- Function [89]: delayedCall10ms (79 bytes)
-- Description: Waits 0.01s via task.wait and invokes wrapped 2-arg function.
-- Resolved Upvalues: [1] = wrappedFunc
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["delayedCall10ms"]={"wrappedFunc"}
    local wrappedFunc = resolve("wrappedFunc")
    YabujinDeobfuscated.delayedCall10ms = function(b, J)
        task.wait(0.01)
        return wrappedFunc(b, J)
    end
end

-- ----------------------------------------------------------------------------
-- Function [98]: delayedCall20ms (73 bytes)
-- Description: Waits 0.02s via task.wait and invokes wrapped function.
-- Resolved Upvalues: [1] = wrappedFunc
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["delayedCall20ms"]={"wrappedFunc"}
    local wrappedFunc = resolve("wrappedFunc")
    YabujinDeobfuscated.delayedCall20ms = function(b)
        task.wait(0.02)
        return wrappedFunc(b)
    end
end

-- ----------------------------------------------------------------------------
-- Function [79]: delayedCall30ms (73 bytes)
-- Description: Waits 0.03s via task.wait and invokes wrapped function.
-- Resolved Upvalues: [1] = wrappedFunc
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["delayedCall30ms"]={"wrappedFunc"}
    local wrappedFunc = resolve("wrappedFunc")
    YabujinDeobfuscated.delayedCall30ms = function(b)
        task.wait(0.03)
        return wrappedFunc(b)
    end
end

-- ----------------------------------------------------------------------------
-- Function [83]: forwardOptionalCallback (92 bytes)
-- Description: Calls the current callback upvalue if assigned.
-- Resolved Upvalues: [1] = callbackRef
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["forwardOptionalCallback"]={"callbackRef"}
    local callbackRef = resolve("callbackRef")
    YabujinDeobfuscated.forwardOptionalCallback = function(...)
        local b = callbackRef
        if b then
            b(...)
        end
    end
end

-- ----------------------------------------------------------------------------
-- Function [122]: incrementActiveTickCounter (104 bytes)
-- Description: Increments tick counter upvalue when active flag is true.
-- Resolved Upvalues: [1] = isActive, [2] = tickCounter
-- ----------------------------------------------------------------------------
do
    YabujinDeobfuscated.Required["incrementActiveTickCounter"]={"isActive","tickCounter"}
    local isActive, tickCounter = resolve("isActive"), resolve("tickCounter")
    YabujinDeobfuscated.incrementActiveTickCounter = function()
        if not isActive then return
    end
    tickCounter += 1
end
end

-- ============================================================================
-- PART 2: Embedded Obsidian ThemeManager ([71] — 11,147 bytes)
-- ============================================================================

YabujinDeobfuscated.initObsidianThemeManager = function()
        local b, J = cloneref or clonereference or function(N)
            return N
        end, clonefunction or copyfunction or function(N)
            return N
        end
        local N = b(game:GetService("HttpService"))
        local b = isfolder
        local A = isfile
        local q = listfiles
        if typeof(J) == "function" then
            local W, U, L = J(b), J(A), J(q)
            local J, h = pcall(function()
                return W("test" .. tostring(math.random(1000000, 9999999)))
            end)
            if J == false or typeof(h) ~= "boolean" then
                b = function(J)
                    local h, B = pcall(W, J)
                    return h and B or false
                end
                A = function(J)
                    local W, h = pcall(U, J)
                    return W and h or false
                end
                q = function(J)
                    local W, U = pcall(L, J)
                    return W and U or{}
                end
            end
        end
        local J = {}
        do
            local W = {"FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor"}
            J.Folder = "ObsidianLibSettings"
            J.Library = nil
            J.AppliedToTab = false
            J.BuiltInThemes = {Default = {1, {FontColor = "dcdce4", MainColor = "1c1c22", AccentColor = "6382ff", BackgroundColor = "121216", OutlineColor = "2a2a32"}}, BBot = {2, {FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414"}}, Fatality = {3, {FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d"}}, Jester = {4, {FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737"}}, Mint = {5, {FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737"}}, ["Tokyo Night"] = {6, {FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232"}}, Ubuntu = {7, {FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919"}}, Quartz = {8, {FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f"}}, Nord = {9, {FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a"}}, Dracula = {10, {FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4"}}, Monokai = {11, {FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e"}}, Gruvbox = {12, {FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945"}}, Solarized = {13, {FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75"}}, Catppuccin = {14, {FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268"}}, ["One Dark"] = {15, {FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370"}}, Cyberpunk = {16, {FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e"}}, ["Oceanic Next"] = {17, {FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46"}}, Material = {18, {FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242"}}, Minimal = {19, {FontColor = "dcdce4", MainColor = "1c1c22", AccentColor = "6382ff", BackgroundColor = "121216", OutlineColor = "2a2a32"}}}
            J.SetLibrary = function(U, L)
                U.Library = L
            end
            J.GetPaths = function(U)
                local L, h = {}, U.Folder:split("/")
                for B = 1, #h, 1 do
                    L[#L + 1] = table.concat(h, "/", 1, B)
                end
                L[#L + 1] = U.Folder .. "/themes"
                return L
            end
            J.BuildFolderTree = function(U)
                local L = U:GetPaths()
                for h = 1, #L, 1 do
                    U = L[h]
                    if not b(U) then
                        makefolder(U)
                    end
                end
            end
            J.CheckFolderTree = function(U)
                if b(U.Folder) then return
            end
            U:BuildFolderTree()
            task.wait(0.1)
        end
        J.SetFolder = function(b, U)
            b.Folder = U
            b:BuildFolderTree()
        end
        J.ApplyTheme = function(b, U)
            local L = b:GetCustomTheme(U)
            local h = L or b.BuiltInThemes[U]
            if not h then
                return
            end
            for U, B in pairs(L or h[2]) do
                if U ~= "VideoLink" then
                    if U == "FontFace" then
                        b.Library:SetFont(Enum.Font[B])
                        if b.Library.Options[U] then
                            b.Library.Options[U]:SetValue(B)
                        end
                    else
                        b.Library.Scheme[U] = Color3.fromHex(B)
                        if b.Library.Options[U] then
                            b.Library.Options[U]:SetValueRGB(Color3.fromHex(B))
                        end
                    end
                end
            end
            b:ThemeUpdate()
        end
        J.ThemeUpdate = function(b)
            for U, U in W, nil, nil do
                if b.Library.Options and b.Library.Options[U] then
                    b.Library.Scheme[U] = b.Library.Options[U].Value
                end
            end
            b.Library:UpdateColorsUsingRegistry()
        end
        J.GetCustomTheme = function(b, U)
            local L = b.Folder .. "/themes/" .. U .. ".json"
            if not A(L) then
                return nil
            end
            U = readfile(L)
            L, b = pcall(N.JSONDecode, N, U)
            if not L then
                return nil
            end
            return b
        end
        J.LoadDefault = function(b)
            local U, L, h = "Default", A(b.Folder .. "/themes/default.txt") and(readfile(b.Folder .. "/themes/default.txt")), true
            if L then
                if b.BuiltInThemes[L] then
                    U = L
                elseif b:GetCustomTheme(L) then
                    h, U = false, L
                end
            else
                U = if b.BuiltInThemes[b.DefaultTheme] then b.DefaultTheme else U
            end
            if h then
                b.Library.Options.ThemeManager_ThemeList:SetValue(U)
            else
                b:ApplyTheme(U)
            end
        end
        J.SaveDefault = function(b, U)
            writefile(b.Folder .. "/themes/default.txt", U)
        end
        J.SetDefaultTheme = function(b, U)
            assert(b.Library, "Must set ThemeManager.Library first!")
            assert(not b.AppliedToTab, "Cannot set default theme after applying ThemeManager to a tab!")
            local L, h = {}, {}
            for B, B in W, nil, nil do
                if typeof(U[B]) == "Color3" then
                    L[B] = "#" .. U[B]:ToHex()
                    h[B] = U[B]
                elseif typeof(U[B]) == "string" then
                    L[B] = U[B]:sub(1, 1) == "#" and U[B] or "#" .. U[B]
                    h[B] = Color3.fromHex(U[B])
                else
                    L[B] = J.BuiltInThemes.Default[2][B]
                    h[B] = Color3.fromHex(J.BuiltInThemes.Default[2][B])
                end
            end
            if typeof(U.FontFace) == "EnumItem" then
                L.FontFace = U.FontFace.Name
                h.Font = Font.fromEnum(U.FontFace)
            elseif typeof(U.FontFace) == "string" then
                L.FontFace = U.FontFace
                h.Font = Font.fromEnum(Enum.Font[U.FontFace])
            else
                L.FontFace = "Code"
                h.Font = Font.fromEnum(Enum.Font.Code)
            end
            U = {"RedColor", "DarkColor", "WhiteColor"}
            for B, B in U, nil, nil do
                h[B] = b.Library.Scheme[B]
            end
            b.Library.Scheme = h
            b.BuiltInThemes.Default = {1, L}
            b.Library:UpdateColorsUsingRegistry()
        end
        J.SaveCustomTheme = function(b, U)
            if U:gsub(" ", "") == "" then b.Library:Notify("Invalid file name for theme (empty)", 3)
            return
        end
        local L = {}
        for h, h in W, nil, nil do
            L[h] = b.Library.Options[h].Value:ToHex()
        end
        L.FontFace = b.Library.Options.FontFace.Value
        writefile(b.Folder .. "/themes/" .. U .. ".json", N:JSONEncode(L))
    end
    J.Delete = function(b, N)
        if not N then return false, "no config file is selected"
    end
    local W = b.Folder .. "/themes/" .. N .. ".json"
    if not A(W) then
        return false, "invalid file"
    end
    if not pcall(delfile, W) then
        return false, "delete file error"
    end
    return true
end
J.ReloadCustomThemes = function(b)
    local N, A = q(b.Folder .. "/themes"), {}
    for q = 1, #N, 1 do
        b = N[q]
        if b:sub(- 5) == ".json" then
            q = b:find(".json", 1, true)
            local N, W = (b:sub(q, q)), q
            while N ~= "/" and N ~= "\\" and N ~= "" do
                q -= 1
                N = (b:sub(q, q))
            end
            if N == "/" or N == "\\" then
                table.insert(A, b:sub(q + 1, W -1))
            end
        end
    end
    return A
end
J.CreateThemeManager = function(b, N)
    N:AddLabel("Background color"):AddColorPicker("BackgroundColor", {Default = b.Library.Scheme.BackgroundColor})
    N:AddLabel("Main color"):AddColorPicker("MainColor", {Default = b.Library.Scheme.MainColor})
    N:AddLabel("Accent color"):AddColorPicker("AccentColor", {Default = b.Library.Scheme.AccentColor})
    N:AddLabel("Outline color"):AddColorPicker("OutlineColor", {Default = b.Library.Scheme.OutlineColor})
    N:AddLabel("Font color"):AddColorPicker("FontColor", {Default = b.Library.Scheme.FontColor})
    N:AddDropdown("FontFace", {Text = "Font Face", Default = "Code", Values = {"BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans"}})
    local A = {}
    for q, W in pairs(b.BuiltInThemes) do
        table.insert(A, q)
    end
    table.sort(A, function(q, W)
        return b.BuiltInThemes[q][1] < b.BuiltInThemes[W][1]
    end)
    N:AddDivider()
    N:AddDropdown("ThemeManager_ThemeList", {Text = "Theme list", Values = A, Default = 1})
    N:AddButton("Set as default", function()
        b:SaveDefault(b.Library.Options.ThemeManager_ThemeList.Value)
        b.Library:Notify(string.format("Set default theme to %q", b.Library.Options.ThemeManager_ThemeList.Value))
    end)
    b.Library.Options.ThemeManager_ThemeList:OnChanged(function()
        b:ApplyTheme(b.Library.Options.ThemeManager_ThemeList.Value)
    end)
    N:AddDivider()
    N:AddInput("ThemeManager_CustomThemeName", {Text = "Custom theme name"})
    N:AddButton("Create theme", function()
        local A = b.Library.Options.ThemeManager_CustomThemeName.Value
        if A:gsub(" ", "") == "" then
            b.Library:Notify("Invalid theme name (empty)", 2)
            return
        end
        b:SaveCustomTheme(A)
        b.Library:Notify(string.format("Created theme %q", A))
        b.Library.Options.ThemeManager_CustomThemeList:SetValues(b:ReloadCustomThemes())
        b.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
    end)
    N:AddDivider()
    N:AddDropdown("ThemeManager_CustomThemeList", {Text = "Custom themes", Values = b:ReloadCustomThemes(), AllowNull = true, Default = 1})
    N:AddButton("Load theme", function()
        local A = b.Library.Options.ThemeManager_CustomThemeList.Value
        b:ApplyTheme(A)
        b.Library:Notify(string.format("Loaded theme %q", A))
    end)
    N:AddButton("Overwrite theme", function()
        local A = b.Library.Options.ThemeManager_CustomThemeList.Value
        b:SaveCustomTheme(A)
        b.Library:Notify(string.format("Overwrote config %q", A))
    end)
    N:AddButton("Delete theme", function()
        local A = b.Library.Options.ThemeManager_CustomThemeList.Value
        local q, W = b:Delete(A)
        if not q then
            b.Library:Notify("Failed to delete theme: " .. W)
            return
        end
        b.Library:Notify(string.format("Deleted theme %q", A))
        b.Library.Options.ThemeManager_CustomThemeList:SetValues(b:ReloadCustomThemes())
        b.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
    end)
    N:AddButton("Refresh list", function()
        b.Library.Options.ThemeManager_CustomThemeList:SetValues(b:ReloadCustomThemes())
        b.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
    end)
    N:AddButton("Set as default", function()
        if b.Library.Options.ThemeManager_CustomThemeList.Value ~= nil and b.Library.Options.ThemeManager_CustomThemeList.Value ~= "" then b:SaveDefault(b.Library.Options.ThemeManager_CustomThemeList.Value)
        b.Library:Notify(string.format("Set default theme to %q", b.Library.Options.ThemeManager_CustomThemeList.Value))
    end
end)
N:AddButton("Reset default", function()
    if not pcall(delfile, b.Folder .. "/themes/default.txt") then b.Library:Notify("Failed to reset default: delete file error")
    return
end
b.Library:Notify("Set default theme to nothing")
b.Library.Options.ThemeManager_CustomThemeList:SetValues(b:ReloadCustomThemes())
b.Library.Options.ThemeManager_CustomThemeList:SetValue(nil)
end)
b:LoadDefault()
b.AppliedToTab = true
local function M()
    b:ThemeUpdate()
end
b.Library.Options.BackgroundColor:OnChanged(M)
b.Library.Options.MainColor:OnChanged(M)
b.Library.Options.AccentColor:OnChanged(M)
b.Library.Options.OutlineColor:OnChanged(M)
b.Library.Options.FontColor:OnChanged(M)
b.Library.Options.FontFace:OnChanged(function(M)
    b.Library:SetFont(Enum.Font[M])
    b.Library:UpdateColorsUsingRegistry()
end)
end
J.CreateGroupBox = function(M, b)
    assert(M.Library, "Must set ThemeManager.Library first!")
    return b:AddLeftGroupbox("Themes", "paintbrush")
end
J.ApplyToTab = function(M, b)
    assert(M.Library, "Must set ThemeManager.Library first!")
    M:CreateThemeManager((M:CreateGroupBox(b)))
end
J.ApplyToGroupbox = function(M, b)
    assert(M.Library, "Must set ThemeManager.Library first!")
    M:CreateThemeManager(b)
end
J:BuildFolderTree()
end
getgenv().ObsidianThemeManager = J
return J
end

-- ============================================================================
-- PART 3: Embedded YabujinLibrary / Obsidian UI Library ([56] — 146,597 bytes)
-- ============================================================================

do
    local yabujinCoreState = { _withId=function(fn, ...) return YabujinDeobfuscated.runWithElevatedThreadIdentity(fn, ...) end }
    YabujinDeobfuscated.initYabujinObsidianLibrary = function()
        local upval_3 = context.AssetBaseUrl or ""

        local b = Instance.new
        yabujinCoreState._instNew = b
        local J = cloneref or clonereference or function(N)
            return N
        end
        local N, A, q, W, U, L, h, B, R, s, d = J(game:GetService("CoreGui")), J(game:GetService("Players")), J(game:GetService("RunService")), J(game:GetService("SoundService")), J(game:GetService("UserInputService")), J(game:GetService("TextService")), J(game:GetService("Teams")), J(game:GetService("TweenService")), getgenv or function()
            return shared
        end, setclipboard or nil, protectgui or syn and syn.protect_gui or function()
        end
        local w, u = gethui or function()
            return N
        end, A.LocalPlayer or(A.PlayerAdded:Wait())
        local C = J(u:GetMouse())
        local J = {}
        local o = {}
        local H = {}
        local z = {}
        local P = {}
        local Y = {}
        local f = {TransparencyTexture = {RobloxId = 139785960036434, Path = "Obsidian/assets/TransparencyTexture.png", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/TransparencyTexture.png", Id = nil}, SaturationMap = {RobloxId = 4155801252, Path = "Obsidian/assets/SaturationMap.png", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/SaturationMap.png", Id = nil}, ShadowImage = {RobloxId = 6015897843, Path = "Obsidian/assets/shadow.png", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/shadow.png", Id = nil}, HoverSound = {RobloxId = 6895079853, Path = "Obsidian/assets/sounds/hover.wav", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/sounds/hover.wav", Id = nil}, ClickSound = {RobloxId = 6895079853, Path = "Obsidian/assets/sounds/click.wav", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/sounds/click.wav", Id = nil}, ToggleOnSound = {RobloxId = 6895079853, Path = "Obsidian/assets/sounds/toggle_on.wav", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/sounds/toggle_on.wav", Id = nil}, ToggleOffSound = {RobloxId = 6895079853, Path = "Obsidian/assets/sounds/toggle_off.wav", URL = "https://raw.githubusercontent.com/deividcomsono/Obsidian/refs/heads/main/assets/sounds/toggle_off.wav", Id = nil}}
        do
            local function l(Q, v)
                if not isfolder or not makefolder then return
            end
            local Z = Q:split("/")
            if v then
                table.remove(Z, #Z)
            end
            Q = ""
            for v, v in ipairs(Z) do
                if not isfolder(Q .. v) then
                    makefolder(Q .. v)
                end
                Q ..= v .. "/"
            end
            return Q
        end
        Y.AddAsset = function(Q, v, Z, p)
            if f[Q] ~= nil then error(string.format("Asset %q already exists", Q))
        end
        assert(typeof(v) == "number", "RobloxAssetId must be a number")
        f[Q] = {RobloxId = v, Path = string.format("Obsidian/custom_assets/%s", Q), URL = Z, Id = nil}
        Y.DownloadAsset(Q, p)
    end
    Y.GetAsset = function(Q)
        if not f[Q] then return nil
    end
    local v = f[Q]
    if v.Id then
        return v.Id
    end
    Q = string.format("rbxassetid://%s", v.RobloxId)
    if getcustomasset then
        local Z, p = pcall(getcustomasset, v.Path)
        Q = if Z and p then p else Q
    end
    v.Id = Q
    return Q
end
Y.DownloadAsset = function(Q, v)
    if not getcustomasset or not writefile or not isfile then return false, "missing functions"
end
local Z = f[Q]
l(Z.Path, true)
if v ~= true and(isfile(Z.Path)) then
    return true, nil
end
Q, v = pcall(function()
    local l
    if(identifyexecutor and(identifyexecutor()) or "Unknown") == "Wave" and request then
        local p, F = pcall(request, {Url = Z.URL, Method = "GET"})
        l = if p and F and F.Body then F.Body else l
    end
    writefile(Z.Path, if not l then(game:HttpGet(Z.URL)) else l)
end)
return Q, v
end
-- Use native Roblox asset IDs without downloading files.
end
local f = {LocalPlayer = u, DevicePlatform = nil, IsMobile = false, IsRobloxFocused = true, ScreenGui = nil, SearchText = "", Searching = false, GlobalSearch = false, LastSearchTab = nil, ActiveTab = nil, Tabs = {}, TabButtons = {}, DependencyBoxes = {}, KeybindFrame = nil, KeybindContainer = nil, KeybindToggles = {}, Notifications = {}, ToggleKeybind = Enum.KeyCode.RightControl, TweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), NotifyTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), Toggled = false, Unloaded = false, Labels = J, Buttons = o, Toggles = H, Options = z, NotifySide = "Right", ShowCustomCursor = true, ForceCheckbox = false, ShowToggleFrameInKeybinds = true, NotifyOnError = false, CantDragForced = false, Signals = {}, UnloadSignals = {}, OriginalMinSize = Vector2.new(480, 360), MinSize = Vector2.new(480, 360), DPIScale = 1, CornerRadius = 12, IsLightTheme = false, Scheme = {BackgroundColor = Color3.fromRGB(13, 14, 18), MainColor = Color3.fromRGB(21, 22, 28), AccentColor = Color3.fromRGB(150, 120, 255), OutlineColor = Color3.fromRGB(34, 36, 46), FontColor = Color3.fromRGB(236, 237, 244), Font = (function()
    local l, Q = pcall(function()
        return Font.fromEnum(Enum.Font.BuilderSansMedium)
    end)
    if l and Q then
        return Q
    end
    return Font.fromEnum(Enum.Font.GothamMedium)
end)(), RedColor = Color3.fromRGB(255, 70, 90), DarkColor = Color3.new(0, 0, 0), WhiteColor = Color3.new(1, 1, 1)}, Registry = {}, Scales = {}, ImageManager = Y}
if q:IsStudio() then
    if U.TouchEnabled and not U.MouseEnabled then
        f.IsMobile = true
        f.OriginalMinSize = Vector2.new(480, 240)
    else
        f.IsMobile = false
        f.OriginalMinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        f.DevicePlatform = U:GetPlatform()
    end)
    f.IsMobile = f.DevicePlatform == Enum.Platform.Android or f.DevicePlatform == Enum.Platform.IOS
    f.OriginalMinSize = f.IsMobile and(Vector2.new(480, 240)) or(Vector2.new(480, 360))
end
local l, Q, v, Z, p = {Frame = {BorderSizePixel = 0}, ImageLabel = {BackgroundTransparency = 1, BorderSizePixel = 0}, ImageButton = {AutoButtonColor = false, BorderSizePixel = 0}, ScrollingFrame = {BorderSizePixel = 0}, TextLabel = {BorderSizePixel = 0, FontFace = "Font", RichText = true, TextColor3 = "FontColor"}, TextButton = {AutoButtonColor = false, BorderSizePixel = 0, FontFace = "Font", RichText = true, TextColor3 = "FontColor"}, TextBox = {BorderSizePixel = 0, FontFace = "Font", PlaceholderColor3 = function()
    local F, a, t = f.Scheme.FontColor:ToHSV()
    return Color3.fromHSV(F, a, t / 2)
end, Text = "", TextColor3 = "FontColor"}, UIListLayout = {SortOrder = Enum.SortOrder.LayoutOrder}, UIStroke = {ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, Window = {Title = "No Title", Footer = "No Footer", Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(720, 600), IconSize = UDim2.fromOffset(30, 30), AutoShow = true, Center = true, Resizable = true, SearchbarSize = UDim2.fromScale(1, 1), GlobalSearch = false, CornerRadius = 8, NotifySide = "Right", ShowCustomCursor = true, Font = Enum.Font.GothamMedium, ToggleKeybind = Enum.KeyCode.RightControl, MobileButtonsSide = "Left", UnlockMouseWhileOpen = true, EnableBlur = true, EnableSnowfall = false, GlassType = "None", EnableFadeIn = true, EnableSidebarResize = false, EnableCompacting = true, DisableCompactingSnap = false, SidebarCompacted = false, MinContainerWidth = 256, MinSidebarWidth = 128, SidebarCompactWidth = 48, SidebarCollapseThreshold = 0.5, CompactWidthActivation = 128}, Toggle = {Text = "Toggle", Default = false, Callback = function()
end, Changed = function()
end, Risky = false, Disabled = false, Visible = true}, Input = {Text = "Input", Default = "", Finished = false, Numeric = false, ClearTextOnFocus = true, Placeholder = "", AllowEmpty = true, EmptyReset = "---", Callback = function()
end, Changed = function()
end, Disabled = false, Visible = true}, Slider = {Text = "Slider", Default = 0, Min = 0, Max = 100, Rounding = 0, Prefix = "", Suffix = "", Callback = function()
end, Changed = function()
end, Disabled = false, Visible = true}, Dropdown = {Values = {}, DisabledValues = {}, Multi = false, MaxVisibleDropdownItems = 8, Callback = function()
end, Changed = function()
end, Disabled = false, Visible = true}, Viewport = {Object = nil, Camera = nil, Clone = true, AutoFocus = true, Interactive = false, Zoom = true, Height = 200, Visible = true}, Image = {Image = "", Transparency = 0, BackgroundTransparency = 0, Color = Color3.new(1, 1, 1), RectOffset = Vector2.zero, RectSize = Vector2.zero, ScaleType = Enum.ScaleType.Fit, Height = 200, Visible = true}, Video = {Video = "", Looped = false, Playing = false, Volume = 1, Height = 200, Visible = true}, UIPassthrough = {Instance = nil, Height = 24, Visible = true}, KeyPicker = {Text = "KeyPicker", Default = "None", DefaultModifiers = {}, Mode = "Toggle", Modes = {"Always", "Toggle", "Hold"}, SyncToggleState = false, Callback = function()
end, ChangedCallback = function()
end, Changed = function()
end, Clicked = function()
end
}, ColorPicker = {Default = Color3.new(1, 1, 1), Callback = function()
end, Changed = function()
end
}}, {Bottom = {0, 1}, Right = {1, 0}}, {Left = {0.5, 1}, Right = {0.5, 1}}, {RedColor = "Red", WhiteColor = "White", DarkColor = "Dark"}, {Red = "RedColor", White = "WhiteColor", Dark = "DarkColor"}
local function F(a)
    if not a then return nil
end
local t = Z[a]
if t and f.Scheme[t] ~= nil then
    f.Scheme[a] = f.Scheme[t]
    f.Scheme[t] = nil
    return f.Scheme[a]
end
t = p[a]
if t and f.Scheme[t] ~= nil then
    warn(string.format("Scheme Value %q is deprecated, please use %q instead.", a, t))
    return f.Scheme[t]
end
return f.Scheme[a]
end
local function Z(p, a, t)
    local g = Instance.new("BindableEvent")
    local _ = p:Once(function(...)
        if not t or typeof(t) == "function" and(t(...)) then g:Fire(true)
    else
        g:Fire(false)
    end
end)
task.delay(a, function()
    _:Disconnect()
    g:Fire(false)
end)
p = g.Event:Wait()
g:Destroy()
return p
end
local function p(a, t)
    return a.UserInputType == Enum.UserInputType.MouseButton1 or t == true and a.UserInputType == Enum.UserInputType.MouseButton2 or a.UserInputType == Enum.UserInputType.Touch
end
local function a(t, g)
    return p(t, g) and t.UserInputState == Enum.UserInputState.Begin and f.IsRobloxFocused
end
local function t(g)
    return(g.UserInputType == Enum.UserInputType.MouseMovement or g.UserInputType == Enum.UserInputType.Touch) and g.UserInputState == Enum.UserInputState.Change
end
local function g(_, c)
    return p(_, c) and(_.UserInputState == Enum.UserInputState.Begin or _.UserInputState == Enum.UserInputState.Change) and f.IsRobloxFocused
end
local function p(_)
    local c = 0
    for e, e in pairs(_) do
        c += 1
    end
    return c
end
local function _(c)
    if not(c and c.PlaybackState == Enum.PlaybackState.Playing) then return
end
c:Cancel()
end
local function c(e)
    return e:match("^%s*(.-)%s*$")
end
local function e(r, I)
    assert(I >= 0, "Invalid rounding number.")
    if I == 0 then
        return math.floor(r)
    end
    return tonumber(string.format("%." .. I .. "f", r))
end
local function r(I)
    local x = A:GetPlayers()
    if I then
        local I = table.find(x, u)
        if I then
            table.remove(x, I)
        end
    end
    table.sort(x, function(u, I)
        return u.Name:lower() < I.Name:lower()
    end)
    return x
end
local function u()
    local I = h:GetTeams()
    table.sort(I, function(x, D)
        return x.Name:lower() < D.Name:lower()
    end)
    return I
end
f.UpdateDependencyBoxes = function(I)
    for I, I in pairs(f.DependencyBoxes) do
        I:Update(true)
    end
    if f.Searching then
        f:UpdateSearch(f.SearchText)
    end
end
local function I(x, D)
    local X = 0
    for V, K in pairs(x.Elements) do
        if K.Type == "Divider" then
            K.Holder.Visible = false
        elseif K.SubButton then
            local j, O = false, K.Text:lower():match(D) and K.Visible
            if O then
                j = true
            else
                K.Base.Visible = false
            end
            V = K.SubButton.Text:lower():match(D) and K.SubButton.Visible
            if V then
                j = true
            else
                K.SubButton.Base.Visible = false
            end
            K.Holder.Visible = j
            X = if j then X + 1 else X
        elseif K.Text and(K.Text:lower():match(D)) and K.Visible then
            K.Holder.Visible = true
            X += 1
        else
            K.Holder.Visible = false
        end
    end
    for V, V in pairs(x.DependencyBoxes) do
        X = if V.Visible then X + I(V, D) else X
    end
    x.Holder.Visible = X > 0
    return X
end
local function x(D)
    for X, X in pairs(D.Elements) do
        X.Holder.Visible = typeof(X.Visible) == "boolean" and X.Visible or true
        if X.SubButton then
            X.Base.Visible = X.Visible
            X.SubButton.Base.Visible = X.SubButton.Visible
        end
    end
    D:Resize()
    D.Holder.Visible = true
    for X, X in pairs(D.DependencyBoxes) do
        if X.Visible then
            x(X)
        end
    end
end
local function D(X, V)
    if not X then return
end
local K = false
for j, O in pairs(X.Groupboxes) do
    j = 0
    for m, k in pairs(O.Elements) do
        if k.Type == "Divider" then
            k.Holder.Visible = false
        elseif k.SubButton then
            local n, E = false, k.Text:lower():match(V) and k.Visible
            if E then
                n = true
            else
                k.Base.Visible = false
            end
            m = k.SubButton.Text:lower():match(V) and k.SubButton.Visible
            if m then
                n = true
            else
                k.SubButton.Base.Visible = false
            end
            k.Holder.Visible = n
            j = if n then j + 1 else j
        elseif k.Text and(k.Text:lower():match(V)) and k.Visible then
            k.Holder.Visible = true
            j += 1
        else
            k.Holder.Visible = false
        end
    end
    for m, m in pairs(O.DependencyBoxes) do
        j = if m.Visible then j + I(m, V) else j
    end
    if j > 0 then
        O:Resize()
        K = true
    end
    O.BoxHolder.Visible = j > 0
end
for j, O in pairs(X.Tabboxes) do
    j = {}
    for X, m in pairs(O.Tabs) do
        j[m] = 0
        for k, n in pairs(m.Elements) do
            if n.Type == "Divider" then
                n.Holder.Visible = false
            elseif n.SubButton then
                X, k = false, n.Text:lower():match(V) and n.Visible
                if k then
                    X = true
                else
                    n.Base.Visible = false
                end
                local k = n.SubButton.Text:lower():match(V) and n.SubButton.Visible
                if k then
                    X = true
                else
                    n.SubButton.Base.Visible = false
                end
                n.Holder.Visible = X
                if X then
                    j[m] = j[m] + 1
                end
            elseif n.Text and(n.Text:lower():match(V)) and n.Visible then
                n.Holder.Visible = true
                j[m] = j[m] + 1
            else
                n.Holder.Visible = false
            end
        end
        for X, X in pairs(m.DependencyBoxes) do
            if X.Visible then
                j[m] = j[m] + I(X, V)
            end
        end
    end
    local I = 0
    for X, V in pairs(j) do
        X.ButtonHolder.Visible = V > 0
        if V > 0 then
            I += 1
            if O.ActiveTab == X then
                X:Resize()
            elseif O.ActiveTab and j[O.ActiveTab] == 0 then
                X:Show()
            end
            K = true
        end
    end
    O.BoxHolder.Visible = I > 0
end
return K
end
local function I(X)
    if not X then return
end
for V, V in pairs(X.Groupboxes) do
    for K, K in pairs(V.Elements) do
        K.Holder.Visible = typeof(K.Visible) == "boolean" and K.Visible or true
        if K.SubButton then
            K.Base.Visible = K.Visible
            K.SubButton.Base.Visible = K.SubButton.Visible
        end
    end
    for K, K in pairs(V.DependencyBoxes) do
        if K.Visible then
            x(K)
        end
    end
    V:Resize()
    V.BoxHolder.Visible = true
end
for V, V in pairs(X.Tabboxes) do
    for X, X in pairs(V.Tabs) do
        for K, K in pairs(X.Elements) do
            K.Holder.Visible = typeof(K.Visible) == "boolean" and K.Visible or true
            if K.SubButton then
                K.Base.Visible = K.Visible
                K.SubButton.Base.Visible = K.SubButton.Visible
            end
        end
        for K, K in pairs(X.DependencyBoxes) do
            if K.Visible then
                x(K)
            end
        end
        X.ButtonHolder.Visible = true
    end
    if V.ActiveTab then
        V.ActiveTab:Resize()
    end
    V.BoxHolder.Visible = true
end
end
f.UpdateSearch = function(x, X)
    f.SearchText = X
    x = {}
    if f.GlobalSearch then
        for V, V in pairs(f.Tabs) do
            if typeof(V) == "table" and not V.IsKeyTab then
                table.insert(x, V)
            end
        end
    elseif f.LastSearchTab and typeof(f.LastSearchTab) == "table" then
        table.insert(x, f.LastSearchTab)
    end
    for V, V in ipairs(x) do
        I(V)
    end
    local I = X:lower()
    if c(I) == "" then
        f.Searching = false
        f.LastSearchTab = nil
        return
    end
    if not f.GlobalSearch and f.ActiveTab and f.ActiveTab.IsKeyTab then
        f.Searching = false
        f.LastSearchTab = nil
        return
    end
    f.Searching = true
    local V = {}
    if f.GlobalSearch then
        if#x == 0 then
            for K, K in pairs(f.Tabs) do
                if typeof(K) == "table" and not K.IsKeyTab then
                    table.insert(x, K)
                end
            end
        end
        V = x
    elseif f.ActiveTab then
        table.insert(V, f.ActiveTab)
    end
    local K
    x = false
    for j, j in ipairs(V) do
        if D(j, I) then
            if not K then
                K = j
            end
            x = if j == f.ActiveTab then true else x
        end
    end
    if f.GlobalSearch then
        if x and f.ActiveTab then
            f.ActiveTab:RefreshSides()
        elseif K then
            local I = X
            task.defer(function()
                if f.SearchText ~= I then return
            end
            if f.ActiveTab ~= K then
                K:Show()
            end
        end)
    end
    f.LastSearchTab = nil
else
    f.LastSearchTab = f.ActiveTab
end
end
f.AddToRegistry = function(I, I, x)
    f.Registry[I] = x
end
f.RemoveFromRegistry = function(I, I)
    f.Registry[I] = nil
end
f.UpdateColorsUsingRegistry = function(I)
    for x, D in pairs(f.Registry) do
        for X, V in pairs(D) do
            I = F(V)
            if I or typeof(V) == "function" then
                x[X] = I or(V())
            end
        end
    end
end
f.SetDPIScale = function(I, I)
    f.DPIScale = I / 100
    f.MinSize = f.OriginalMinSize * f.DPIScale
    for I, I in pairs(f.Scales) do
        I.Scale = f.DPIScale
    end
    for I, I in pairs(z) do
        if I.Type == "Dropdown" then
            I:RecalculateListSize()
        end
    end
    for I, I in pairs(f.Notifications) do
        I:Resize()
    end
end
f.GiveSignal = function(I, x)
    I = typeof(x)
    if x and(I == "RBXScriptConnection" or I == "RBXScriptSignal") then
        table.insert(f.Signals, x)
    end
    return x
end
f.PlaySound = function(I, I, I, I)
end
f.LoadSounds = function(I)
end
function IsValidCustomIcon(I)
    return typeof(I) == "string" and(I:match("rbxasset") or(I:match("roblox%.com/asset/%?id=")) or(I:match("rbxthumb://type=")))
end
local I, x = false
do
    local D, X = upval_3 .. "/Lucide/source.lua"
    local function V(K)
        if X then return
    end
    if request then
        pcall(function()
            local j = request({Url = K, Method = "GET"})
            local O = j and j.Body and#j.Body > 100
            if O then
                X = j.Body
            end
        end)
    end
    if not X then
        pcall(function()
            local j = game:HttpGet(K)
            local K = j and#j > 100
            if K then
                X = j
            end
        end)
    end
end
if upval_3 ~= "" then V(D) end
V("https://raw.githubusercontent.com/deividcomsono/lucide-roblox-direct/refs/heads/main/source.lua")
if X then
    pcall(function()
        if upval_3 ~= "" then X = X:gsub("https://raw%.githubusercontent%.com/deividcomsono/lucide%-roblox%-direct/refs/heads/main/spritesheets/", upval_3 .. "/Lucide/spritesheets/") end
    end)
    pcall(function()
        local D = loadstring(X)
        if D then
            local X = D()
            if X and X.GetAsset then
                I, x = true, X
            end
        end
    end)
end
end
f.GetIcon = function(D, D)
    if not I or not x then return
end
local X, V = pcall(x.GetAsset, D)
if not X or not V then
    return
end
return V
end
f.GetCustomIcon = function(D, D)
    if not IsValidCustomIcon(D) then return f:GetIcon(D)
else
    return{Url = D, ImageRectOffset = Vector2.zero, ImageRectSize = Vector2.zero, Custom = true}
end
end
f.Validate = function(D, D, X)
    if typeof(D) ~= "table" then return X
end
for V, K in pairs(X) do
    if typeof(V) ~= "number" then
        if typeof(K) == "table" then
            D[V] = f:Validate(D[V], K)
        elseif D[V] == nil then
            D[V] = K
        end
    end
end
return D
end
local D = {ScreenGui = true, SurfaceGui = true, BillboardGui = true, Lighting = true, UIScale = true, UIListLayout = true, UIGridLayout = true, UITableLayout = true, UIPageLayout = true, UIAspectRatioConstraint = true, UISizeConstraint = true, UITextSizeConstraint = true, UICorner = true, UIPadding = true, UIGradient = true, UIStroke = true, UIFlexItem = true}
local function X(V, K)
    local j = f.Registry[K] or{}
    for O, m in pairs(V) do
        if j[O] then
            j[O] = nil
        elseif O ~= "Text" then
            local V = F(m)
            if V or typeof(m) == "function" then
                j[O] = m
                m = V or(m())
            end
        end
        K[O] = m
    end
    if p(j) > 0 then
        f.Registry[K] = j
    end
end
local function F(V, K)
    local j = b(V)
    if l[V] then
        X(l[V], j)
    end
    X(K, j)
    if K.Parent and not K.ZIndex and not D[V] and not D[K.Parent.ClassName] then
        pcall(function()
            j.ZIndex = K.Parent.ZIndex
        end)
    end
    return j
end
local function b(D, X)
    if not(pcall(function()
        local V = X
        if not V then
            X = N
        end
        D.Parent = if typeof(X) == "function" then(X()) else X
    end) and D.Parent) then
        D.Parent = f.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end
local function D(X, V)
    if V then b(X, N)
    return
end
pcall(d, X)
b(X, w)
end
local b = F("ScreenGui", {Name = "Obsidian", DisplayOrder = 999, ResetOnSpawn = false})
D(b)
f.ScreenGui = b
b.DescendantRemoving:Connect(function(N)
    f:RemoveFromRegistry(N)
end)
local N = F("TextButton", {BackgroundTransparency = 1, Modal = false, Size = UDim2.fromScale(0, 0), AnchorPoint = Vector2.zero, Text = "", ZIndex = -999, Parent = b})
local d, w
do
    d = F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "WhiteColor", Size = UDim2.fromOffset(9, 1), Visible = false, ZIndex = 999, Parent = b})
    F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "DarkColor", Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 2, 1, 2), ZIndex = 998, Parent = d})
    D = F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "WhiteColor", Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(1, 9), Parent = d})
    F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "DarkColor", Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, 2, 1, 2), ZIndex = 998, Parent = D})
    w = F("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(20, 20), ZIndex = 1000, Visible = false, Parent = d})
end
local D
do
    D = F("Frame", {AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Position = UDim2.new(1, -6, 0, 6), Size = UDim2.new(0, 300, 1, -6), Parent = b})
    table.insert(f.Scales, (F("UIScale", {Parent = D})))
    F("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 8), Parent = D})
end
f.ResetCursorIcon = function(X)
    w.Visible = false
    w.Size = UDim2.fromOffset(20, 20)
end
f.ChangeCursorIcon = function(X, V)
    if not V or V == "" then f:ResetCursorIcon()
    return
end
X = f:GetCustomIcon(V)
assert(X, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")
w.Visible = true
w.Image = X.Url
w.ImageRectOffset = X.ImageRectOffset
w.ImageRectSize = X.ImageRectSize
end
f.ChangeCursorIconSize = function(X, X)
    assert(typeof(X) == "UDim2", "UDim2 expected.")
    w.Size = X
end
f.GetBetterColor = function(X, X, V)
    V*=f.IsLightTheme and -4 or 2
    return Color3.fromRGB(math.clamp(X.R * 255 + V, 0, 255), math.clamp(X.G * 255 + V, 0, 255), math.clamp(X.B * 255 + V, 0, 255))
end
f.GetLighterColor = function(X, X)
    local V, K, j = X:ToHSV()
    return Color3.fromHSV(V, math.max(0, K -0.1), math.min(1, j + 0.1))
end
f.GetDarkerColor = function(X, X)
    local V, K, j = X:ToHSV()
    return Color3.fromHSV(V, K, j / 2)
end
f.GetKeyString = function(X, X)
    if X.EnumType == Enum.KeyCode and X.Value > 33 and X.Value < 127 then return string.char(X.Value)
end
return X.Name
end
f.GetTextBounds = function(X, V, K, j, O)
    X = Instance.new("GetTextBoundsParams")
    X.Text = V
    X.RichText = true
    X.Font = K
    X.Size = j
    X.Width = O or workspace.CurrentCamera.ViewportSize.X -32
    j = L:GetTextBoundsAsync(X)
    return j.X, j.Y
end
f.MouseIsOverFrame = function(L, L, X)
    local V, K = L.AbsolutePosition, L.AbsoluteSize
    return X.X >= V.X and X.X <= V.X + K.X and X.Y >= V.Y and X.Y <= V.Y + K.Y
end
f.SafeCallback = function(L, X, ...)
    if not(X and typeof(X) == "function") then return
end
L = table.pack(xpcall(X, function(X)
    task.defer(error, debug.traceback(X, 2))
    if f.NotifyOnError then
        f:Notify(X)
    end
    return X
end, ...))
if not L[1] then
    return nil
end
return table.unpack(L, 2, L.n)
end
f.MakeDraggable = function(L, L, X, V, K)
    local j, O
    local m, k = false
    X.InputBegan:Connect(function(X)
        if not a(X) or K and f.CantDragForced then return
    end
    j = X.Position
    O, m = L.Position, true
    k = X.Changed:Connect(function()
        if X.UserInputState ~= Enum.UserInputState.End then return
    end
    m = false
    if k and k.Connected then
        k:Disconnect()
        k = nil
    end
end)
end)
f:GiveSignal(U.InputChanged:Connect(function(X)
    if not V and not f.Toggled or K and f.CantDragForced or not(b and b.Parent) then m = false
    if k and k.Connected then
        k:Disconnect()
        k = nil
    end
    return
end
if m and(t(X)) then
    local V = X.Position -j
    L.Position = UDim2.new(O.X.Scale, O.X.Offset + V.X, O.Y.Scale, O.Y.Offset + V.Y)
end
end))
end
f.MakeResizable = function(L, L, X, V)
    local K, j
    local O, m = false
    X.InputBegan:Connect(function(X)
        if not a(X) then return
    end
    K = X.Position
    j, O = L.Size, true
    m = X.Changed:Connect(function()
        if X.UserInputState ~= Enum.UserInputState.End then return
    end
    O = false
    if m and m.Connected then
        m:Disconnect()
        m = nil
    end
end)
end)
f:GiveSignal(U.InputChanged:Connect(function(X)
    if not L.Visible or not(b and b.Parent) then O = false
    if m and m.Connected then
        m:Disconnect()
        m = nil
    end
    return
end
if O and(t(X)) then
    local O = X.Position -K
    L.Size = UDim2.new(j.X.Scale, math.clamp(j.X.Offset + O.X, f.MinSize.X, math.huge), j.Y.Scale, math.clamp(j.Y.Offset + O.Y, f.MinSize.Y, math.huge))
    if V then
        f:SafeCallback(V)
    end
end
end))
end
f.MakeCover = function(L, L, X)
    local V, K = Q[X] or{0, 0}, v[X] or{1, 0.5}
    return(F("Frame", {AnchorPoint = Vector2.new(V[1], V[2]), BackgroundColor3 = L.BackgroundColor3, Position = UDim2.fromScale(V[1], V[2]), Size = UDim2.fromScale(K[1], K[2]), Parent = L}))
end
f.MakeLine = function(L, L, Q)
    return(F("Frame", {AnchorPoint = Q.AnchorPoint or Vector2.zero, BackgroundColor3 = "OutlineColor", Position = Q.Position, Size = Q.Size, ZIndex = Q.ZIndex or L.ZIndex, Parent = L}))
end
f.AddOutline = function(L, L)
    return F("UIStroke", {Color = "OutlineColor", Thickness = 1, ZIndex = 2, Parent = L}), (F("UIStroke", {Color = "DarkColor", Thickness = 0, ZIndex = 1, Parent = L}))
end
f.AddBlank = function(L, L, Q)
    return F("Frame", {BackgroundTransparency = 1, Size = Q or(UDim2.fromScale(0, 0)), Parent = L})
end
f.MakeOutline = function(L, Q, v, X)
    warn("Obsidian is deprecated, please use Obsidian instead.")
    L = F("Frame", {BackgroundColor3 = "DarkColor", Position = UDim2.fromOffset(- 2, -2), Size = UDim2.new(1, 4, 1, 4), ZIndex = X, Parent = Q})
    Q = F("Frame", {BackgroundColor3 = "OutlineColor", Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), ZIndex = X, Parent = L})
    if v and v > 0 then
        F("UICorner", {CornerRadius = UDim.new(0, v + 1), Parent = L})
        F("UICorner", {CornerRadius = UDim.new(0, v), Parent = Q})
    end
    return L, Q
end
f.AddDraggableLabel = function(L, L)
    local Q, v = {}, F("TextLabel", {AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = "BackgroundColor", Size = UDim2.fromOffset(0, 0), Position = UDim2.fromOffset(6, 6), Text = L, TextSize = 15, ZIndex = 10, Parent = b})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = v})
    F("UIPadding", {PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingTop = UDim.new(0, 6), Parent = v})
    table.insert(f.Scales, F("UIScale", {Parent = v}))
    f:AddOutline(v)
    f:MakeDraggable(v, v, true)
    Q.Label = v
    Q.SetText = function(L, L)
        pcall(function()
            v.Text = L
        end)
    end
    Q.SetVisible = function(L, L)
        pcall(function()
            v.Visible = L
        end)
    end
    return Q
end
f.AddDraggableButton = function(L, L, Q, v)
    local X, V = {}, F("TextButton", {BackgroundColor3 = "BackgroundColor", Position = UDim2.fromOffset(6, 6), TextSize = 16, ZIndex = 10, Parent = b})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = V})
    if not v then
        table.insert(f.Scales, F("UIScale", {Parent = V}))
    end
    f:AddOutline(V)
    V.MouseButton1Click:Connect(function()
        f:SafeCallback(Q, X)
    end)
    f:MakeDraggable(V, V, true)
    X.Button = V
    X.SetText = function(Q, Q)
        local v, K = f:GetTextBounds(Q, f.Scheme.Font, 16)
        V.Text = Q
        V.Size = UDim2.fromOffset(v * 2, K * 2)
    end
    X:SetText(L)
    return X
end
f.AddDraggableMenu = function(L, Q)
    L = F("Frame", {AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = "BackgroundColor", Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(0, 0), ZIndex = 10, Parent = b})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = L})
    table.insert(f.Scales, F("UIScale", {Parent = L}))
    f:AddOutline(L)
    f:MakeLine(L, {Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 0, 1)})
    local v = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), Text = Q, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = L})
    F("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = v})
    Q = F("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 35), Size = UDim2.new(1, 0, 1, -35), Parent = L})
    F("UIListLayout", {Padding = UDim.new(0, 7), Parent = Q})
    F("UIPadding", {PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), PaddingTop = UDim.new(0, 7), Parent = Q})
    f:MakeDraggable(L, v, true)
    return L, Q
end
f.CreateFloatingPanel = function(L, Q)
    Q = Q or{}
    local v, X, V, K, j, O = Q.Title or "Panel", Q.Width or 580, Q.Height or 380, Q.Position or(UDim2.fromOffset(200, 100)), Q.SidebarWidth or 140, {Tabs = {}, ActiveTab = nil, TabOrder = {}}
    local Q = F("TextButton", {BackgroundColor3 = function()
        return f:GetBetterColor(f.Scheme.BackgroundColor, -1)
    end, Text = "", AutoButtonColor = false, BorderSizePixel = 0, Position = K, Size = UDim2.fromOffset(X, V), ClipsDescendants = true, Visible = false, ZIndex = 100, Parent = b})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = Q})
    table.insert(f.Scales, F("UIScale", {Parent = Q}))
    F("UIStroke", {Color = "AccentColor", Transparency = 0.7, Thickness = 1, Parent = Q})
    f:AddOutline(Q)
    V = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = Q})
    f:MakeDraggable(Q, V, true)
    f:MakeLine(Q, {Position = UDim2.fromOffset(0, 36), Size = UDim2.new(1, 0, 0, 1)})
    X = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0, j, 1, 0), Parent = V})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), Parent = X})
    local K = F("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), Text = v, TextSize = 15, Parent = X})
    f:AddToRegistry(K, {TextColor3 = "FontColor"})
    L = F("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.new(1, -j -16, 0, 20), Parent = V})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 4), Parent = L})
    local v = F("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), Text = "", TextSize = 12, TextTransparency = 0.5, Parent = L})
    f:AddToRegistry(v, {TextColor3 = "FontColor"})
    local X = F("TextButton", {BackgroundTransparency = 1, Size = UDim2.fromOffset(36, 36), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Text = "X", TextSize = 14, Parent = V})
    f:AddToRegistry(X, {TextColor3 = "FontColor"})
    X.MouseEnter:Connect(function()
        pcall(function()
            X.TextColor3 = f.Scheme.RedColor
        end)
    end)
    X.MouseLeave:Connect(function()
        pcall(function()
            X.TextColor3 = f.Scheme.FontColor
        end)
    end)
    X.MouseButton1Click:Connect(function()
        Q.Visible = false
    end)
    L = F("Frame", {BackgroundColor3 = "BackgroundColor", Position = UDim2.fromOffset(0, 37), Size = UDim2.new(0, j, 1, -37), Parent = Q})
    local X = F("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.fromScale(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2, ScrollBarImageTransparency = 0.6, Parent = L})
    F("UIListLayout", {Padding = UDim.new(0, 2), Parent = X})
    F("UIPadding", {PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = X})
    F("Frame", {BackgroundColor3 = "OutlineColor", Position = UDim2.new(0, j, 0, 37), Size = UDim2.new(0, 1, 1, -37), Parent = Q})
    local L = F("ScrollingFrame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(j + 1, 37), Size = UDim2.new(1, -j -1, 1, -37), CanvasSize = UDim2.fromScale(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageTransparency = 0.4, Parent = Q})
    f:AddToRegistry(L, {ScrollBarImageColor3 = "AccentColor"})
    F("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = L})
    O.Frame = Q
    O.SetVisible = function(V, V)
        Q.Visible = V
    end
    O.Toggle = function(V)
        Q.Visible = not Q.Visible
    end
    O.SetTitle = function(Q, Q)
        K.Text = Q
    end
    O.AddTab = function(Q, V, K)
        local j = F("TextButton", {BackgroundColor3 = "MainColor", BackgroundTransparency = 1, AutoButtonColor = false, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 28), Text = "", Parent = X})
        F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius / 2), Parent = j})
        F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), Parent = j})
        F("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = j})
        Q = K and(f:GetIcon(K))
        if Q then
            K = F("ImageLabel", {BackgroundTransparency = 1, Size = UDim2.fromOffset(14, 14), Image = Q.Url or Q, Parent = j})
            if Q.ImageRectOffset then
                K.ImageRectOffset = Q.ImageRectOffset
            end
            if Q.ImageRectSize then
                K.ImageRectSize = Q.ImageRectSize
            end
            f:AddToRegistry(K, {ImageColor3 = "FontColor"})
        end
        Q = F("TextLabel", {BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), Text = V, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = j})
        f:AddToRegistry(Q, {TextColor3 = "FontColor"})
        K = F("Frame", {BackgroundColor3 = "AccentColor", Position = UDim2.fromOffset(0, 0), Size = UDim2.new(0, 3, 1, 0), Visible = false, Parent = j})
        F("UICorner", {CornerRadius = UDim.new(0, 2), Parent = K})
        local X = F("ScrollingFrame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.fromScale(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageTransparency = 0.4, BorderSizePixel = 0, Visible = false, Parent = L})
        f:AddToRegistry(X, {ScrollBarImageColor3 = "AccentColor"})
        local L = F("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = X})
        F("UIListLayout", {Padding = UDim.new(0, 8), Parent = L})
        F("UIPadding", {PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), PaddingTop = UDim.new(0, 7), Parent = L})
        local m = {Container = L, Holder = L, Tab = {}, DependencyBoxes = {}, Elements = {}, Resize = function(k)
        end
        }
        setmetatable(m, f.BaseGroupbox)
        L = {Name = V, Button = j, Label = Q, AccentLine = K, Scroll = X, Groupbox = m, Container = X}
        j.MouseEnter:Connect(function()
            if O.ActiveTab ~= V then j.BackgroundTransparency = 0.7
        end
    end)
    j.MouseLeave:Connect(function()
        if O.ActiveTab ~= V then j.BackgroundTransparency = 1
    end
end)
j.MouseButton1Click:Connect(function()
    O:SwitchTab(V)
end)
table.insert(O.TabOrder, V)
O.Tabs[V] = L
if not O.ActiveTab then
    O:SwitchTab(V)
end
return m
end
O.SwitchTab = function(L, Q)
    for X, V in pairs(O.Tabs) do
        L = X == Q
        V.Container.Visible = L
        V.AccentLine.Visible = L
        V.Button.BackgroundTransparency = L and 0 or 1
        V.Label.TextTransparency = L and 0 or 0.4
    end
    v.Text = Q
    O.ActiveTab = Q
end
return O
end
do
    local L = f:AddDraggableLabel("")
    L:SetVisible(false)
    f.SetWatermark = function(Q, Q)
        warn("Watermark is deprecated, please use Library instead.")
        L:SetText(Q)
    end
    f.SetWatermarkVisibility = function(Q, Q)
        warn("Watermark is deprecated, please use Library instead.")
        L:SetVisible(Q)
    end
end
local L
local function Q()
    return f.Window and f.Window.Frame
end
f.AddContextMenu = function(v, v, X, V, K, j)
    local O
    if K then
        O = F("ScrollingFrame", {AutomaticCanvasSize = K == 2 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None, AutomaticSize = K == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None, BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png", CanvasSize = UDim2.fromOffset(0, 0), ClipsDescendants = true, ScrollBarImageColor3 = "OutlineColor", ScrollBarThickness = K == 2 and 2 or 0, Size = typeof(X) == "function" and(X()) or X, TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png", Visible = false, ZIndex = 50, Parent = b})
    else
        O = F("Frame", {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, ClipsDescendants = true, Size = typeof(X) == "function" and(X()) or X, Visible = false, ZIndex = 50, Parent = b})
    end
    table.insert(f.Scales, F("UIScale", {Parent = O}))
    local m = {Active = false, Holder = v, Menu = O, List = nil, Signal = nil, ScrollConns = {}, Size = X}
    if K then
        m.List = F("UIListLayout", {Parent = O})
    end
    local function X()
        if typeof(V) == "function" then local K = V()
        return K[1] or 0, K[2] or 0
    end
    return V[1], V[2]
end
local function V()
    local K, k = X()
    local X, n = v.AbsolutePosition.X + K, v.AbsolutePosition.Y + k
    O.Size = typeof(m.Size) == "function" and(m.Size()) or m.Size
    k = Q()
    if k and k.Parent then
        local K, E, S, G = k.AbsolutePosition, k.AbsoluteSize, O.AbsoluteSize.X, O.AbsoluteSize.Y
        S, G = if S <= 0 and O.Size.X.Offset > 0 then O.Size.X.Offset * f.DPIScale else S, if G <= 0 and O.Size.Y.Offset > 0 then O.Size.Y.Offset * f.DPIScale else G
        local k, y = n + G, K.Y
        n, X = if G > 0 then(math.clamp(if k > y + E.Y then v.AbsolutePosition.Y -G -2 else n, K.Y, math.max(K.Y, K.Y + E.Y -G))) else
        if k > y + E.Y then
            v.AbsolutePosition.Y -G -2
        else
            n, if S > 0 then(math.clamp(X, K.X, math.max(K.X, K.X + E.X -S))) else X
        end
        O.Position = UDim2.fromOffset(math.floor(X), math.floor(n))
    end
    m.UnbindScrollClose = function(X)
        for X, X in ipairs(m.ScrollConns) do
            pcall(function()
                X:Disconnect()
            end)
        end
        table.clear(m.ScrollConns)
    end
    m.BindScrollClose = function(X)
        m:UnbindScrollClose()
        local X, K = v.Parent, Q()
        while X and X ~= b do
            if X:IsA("ScrollingFrame") then
                table.insert(m.ScrollConns, X:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                    m:Close()
                end))
            end
            if X == K then
                break
            end
            X = X.Parent
        end
    end
    m.Open = function(Q)
        if L == m then return
    elseif L then
        L:Close()
    end
    L = m
    m.Active = true
    V()
    if typeof(j) == "function" then
        f:SafeCallback(j, true)
    end
    O.Visible = true
    m:BindScrollClose()
    m.Signal = v:GetPropertyChangedSignal("AbsolutePosition"):Connect(V)
end
m.Close = function(Q)
    if L ~= m then return
end
O.Visible = false
if m.Signal then
    m.Signal:Disconnect()
    m.Signal = nil
end
m:UnbindScrollClose()
m.Active = false
L = nil
if typeof(j) == "function" then
    f:SafeCallback(j, false)
end
end
m.Toggle = function(Q)
    if m.Active then m:Close()
else
    m:Open()
end
end
m.SetSize = function(Q, Q)
    m.Size = Q
    O.Size = typeof(Q) == "function" and(Q()) or Q
    if m.Active then
        V()
    end
end
m.Destroy = function(Q)
    m:Close()
    m:UnbindScrollClose()
    Q = L
    if Q == m then
        L = nil
    end
    for v = #f.Scales, 1, -1 do
        Q = f.Scales[v]
        if Q and Q.Parent == O then
            table.remove(f.Scales, v)
        end
    end
    pcall(function()
        O:Destroy()
    end)
end
return m
end
f:GiveSignal(U.InputBegan:Connect(function(Q)
    if f.Unloaded then return
end
if a(Q, true) then
    local v = Q.Position
    if L and not(f:MouseIsOverFrame(L.Menu, v) or(f:MouseIsOverFrame(L.Holder, v))) then
        L:Close()
    end
end
end))
local Q = F("TextLabel", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, TextSize = 14, TextWrapped = true, Visible = false, ZIndex = 20, Parent = b})
F("UIPadding", {PaddingBottom = UDim.new(0, 2), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 2), Parent = Q})
table.insert(f.Scales, (F("UIScale", {Parent = Q})))
Q:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    if f.Unloaded then return
end
local v = f:GetTextBounds(Q.Text, Q.FontFace, Q.TextSize, (workspace.CurrentCamera.ViewportSize.X -Q.AbsolutePosition.X -8) / f.DPIScale)
Q.Size = UDim2.fromOffset(v + 8)
end)
local v
f.AddTooltip = function(X, X, V, K)
    local j = {Disabled = false, Hovering = false, Signals = {}}
    local function O()
        if v == K or L and(f:MouseIsOverFrame(L.Menu, C)) or j.Disabled and typeof(V) ~= "string" or not j.Disabled and typeof(X) ~= "string" then return
    end
    v = K
    Q.Text = j.Disabled and V or X
    Q.Visible = true
    while f.Toggled and(f:MouseIsOverFrame(K, C)) and not(L and(f:MouseIsOverFrame(L.Menu, C))) do
        Q.Position = UDim2.fromOffset(C.X + (f.ShowCustomCursor and 8 or 14), C.Y + (f.ShowCustomCursor and 8 or 12))
        q.RenderStepped:Wait()
    end
    Q.Visible = false
    v = nil
end
local function L(X)
    local V = typeof(X)
    if X and(V == "RBXScriptConnection" or V == "RBXScriptSignal") then
        table.insert(j.Signals, X)
    end
    return X
end
L(K.MouseEnter:Connect(O))
L(K.MouseMoved:Connect(O))
L(K.MouseLeave:Connect(function()
    if v ~= K then return
end
Q.Visible = false
v = nil
end))
j.Destroy = function(L)
    for X = #j.Signals, 1, -1 do
        L = table.remove(j.Signals, X)
        if L and L.Connected then
            L:Disconnect()
        end
    end
    if v == K then
        if Q then
            Q.Visible = false
        end
        v = nil
    end
end
table.insert(P, Q)
return j
end
f.OnUnload = function(L, L)
    table.insert(f.UnloadSignals, L)
end
f.Unload = function(L)
    for v = #f.Signals, 1, -1 do
        L = table.remove(f.Signals, v)
        if L and L.Connected then
            L:Disconnect()
        end
    end
    for L, L in pairs(f.UnloadSignals) do
        f:SafeCallback(L)
    end
    for L, L in pairs(P) do
        f:SafeCallback(L.Destroy, L)
    end
    f.Unloaded = true
    b:Destroy()
    R().YabujinLibrary = nil
end
local L, P, v, X, V = f:GetIcon("check"), f:GetIcon("chevron-up"), f:GetIcon("move-diagonal-2"), f:GetIcon("key"), f:GetIcon("move")
f.SetIconModule = function(K, K)
    I, x = true, K
    L = f:GetIcon("check")
    P = f:GetIcon("chevron-up")
    v = f:GetIcon("move-diagonal-2")
    X = f:GetIcon("key")
    V = f:GetIcon("move")
end
local I = {}
do
    local x, K = {AddKeyPicker = function(j, O, m)
        m = f:Validate(m, l.KeyPicker)
        local k = j
        local n, E = k.TextLabel, {Text = m.Text, Value = m.Default, Modifiers = m.DefaultModifiers, DisplayValue = m.Default, Toggled = false, Mode = m.Mode, SyncToggleState = m.SyncToggleState, Callback = m.Callback, ChangedCallback = m.ChangedCallback, Changed = m.Changed, Clicked = m.Clicked, Type = "KeyPicker"}
        if E.Mode == "Press" then
            assert(k.Type == "Label", "KeyPicker with the mode 'Press' can be only applied on Labels.")
            E.SyncToggleState = false
            m.Modes = {"Press"}
            m.Mode = "Press"
        end
        if E.SyncToggleState then
            m.Modes = {"Toggle", "Hold"}
            if not table.find(m.Modes, m.Mode) then
                m.Mode = "Toggle"
            end
        end
        local S, G, y, i, T = false, {MB1 = Enum.UserInputType.MouseButton1, MB2 = Enum.UserInputType.MouseButton2, MB3 = Enum.UserInputType.MouseButton3}, {[Enum.UserInputType.MouseButton1] = "MB1", [Enum.UserInputType.MouseButton2] = "MB2", [Enum.UserInputType.MouseButton3] = "MB3"}, {LAlt = Enum.KeyCode.LeftAlt, RAlt = Enum.KeyCode.RightAlt, LCtrl = Enum.KeyCode.LeftControl, RCtrl = Enum.KeyCode.RightControl, LShift = Enum.KeyCode.LeftShift, RShift = Enum.KeyCode.RightShift, Tab = Enum.KeyCode.Tab, CapsLock = Enum.KeyCode.CapsLock}, {[Enum.KeyCode.LeftAlt] = "LAlt", [Enum.KeyCode.RightAlt] = "RAlt", [Enum.KeyCode.LeftControl] = "LCtrl", [Enum.KeyCode.RightControl] = "RCtrl", [Enum.KeyCode.LeftShift] = "LShift", [Enum.KeyCode.RightShift] = "RShift", [Enum.KeyCode.Tab] = "Tab", [Enum.KeyCode.CapsLock] = "CapsLock"}
        local function MJ(bJ)
            return bJ.UserInputType == Enum.UserInputType.Keyboard and T[bJ.KeyCode] ~= nil
        end
        local function bJ()
            local JJ = {}
            for NJ, AJ in pairs(i) do
                if not table.find(JJ, NJ) and(U:IsKeyDown(AJ)) then
                    table.insert(JJ, NJ)
                end
            end
            return JJ
        end
        local function JJ(NJ)
            if not(typeof(NJ) == "table" and p(NJ) > 0) then return true
        end
        local AJ, qJ = bJ(), true
        for bJ, bJ in pairs(NJ) do
            if not table.find(AJ, bJ) then
                qJ = false
                break
            end
        end
        return qJ
    end
    local function bJ(NJ)
        if not NJ then return false
    end
    if y[NJ.UserInputType] ~= nil then
        return U:IsMouseButtonPressed(NJ.UserInputType) and not U:GetFocusedTextBox()
    elseif NJ.UserInputType == Enum.UserInputType.Keyboard then
        return U:IsKeyDown(NJ.KeyCode) and not U:GetFocusedTextBox()
    else
        return false
    end
end
local function NJ(AJ)
    local qJ = {}
    for WJ, WJ in pairs(AJ) do
        table.insert(qJ, i[WJ])
    end
    return qJ
end
local function AJ(qJ)
    if typeof(qJ) ~= "table" then return{}
end
local WJ = {}
for UJ, UJ in pairs(qJ) do
    if i[UJ] then
        table.insert(WJ, UJ)
    end
end
return WJ
end
E.Modifiers = AJ(E.Modifiers)
local i, qJ = F("TextButton", {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Size = UDim2.fromOffset(18, 18), Text = E.Value, TextSize = 14, Parent = n}), {Normal = E.Mode ~= "Toggle"}
do
    local WJ = F("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 16), Text = "", Visible = not m.NoUI, Parent = f.KeybindContainer})
    local UJ, LJ = F("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Size = UDim2.fromScale(0, 1), Text = "", TextSize = 14, TextTransparency = 0.5, Parent = WJ}), F("Frame", {AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = "MainColor", Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(14, 14), SizeConstraint = Enum.SizeConstraint.RelativeYY, Parent = WJ})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius / 2), Parent = LJ})
    F("UIStroke", {Color = "OutlineColor", Parent = LJ})
    local hJ = F("ImageLabel", {Image = L and L.Url or "", ImageColor3 = "FontColor", ImageRectOffset = L and L.ImageRectOffset or Vector2.zero, ImageRectSize = L and L.ImageRectSize or Vector2.zero, ImageTransparency = 1, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4), Parent = LJ})
    qJ.Display = function(BJ, BJ)
        UJ.TextTransparency = BJ and 0 or 0.5
        hJ.ImageTransparency = BJ and 0 or 1
    end
    qJ.SetText = function(hJ, hJ)
        UJ.Text = hJ
    end
    qJ.SetVisibility = function(hJ, hJ)
        WJ.Visible = hJ
    end
    qJ.SetNormal = function(hJ, BJ)
        qJ.Normal = BJ
        hJ = not BJ
        WJ.Active = hJ
        UJ.Position = BJ and(UDim2.fromOffset(0, 0)) or(UDim2.fromOffset(22, 0))
        LJ.Visible = hJ
    end
    E.DoClick = function(...)
    end
    WJ.MouseButton1Click:Connect(function()
        if qJ.Normal then return
    end
    E.Toggled = not E.Toggled
    E:DoClick()
end)
qJ.Holder = WJ
qJ.Label = UJ
qJ.Checkbox = LJ
qJ.Loaded = true
table.insert(f.KeybindToggles, qJ)
end
local WJ = f:AddContextMenu(i, UDim2.fromOffset(62, 0), function()
    return{i.AbsoluteSize.X + 1.5, 0.5}
end, 1)
E.Menu = WJ
local UJ = {}
for LJ, LJ in pairs(m.Modes) do
    local hJ, BJ = {}, F("TextButton", {BackgroundColor3 = "MainColor", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 21), Text = LJ, TextSize = 14, TextTransparency = 0.5, Parent = WJ.Menu})
    hJ.Select = function(RJ)
        for RJ, RJ in pairs(UJ) do
            RJ:Deselect()
        end
        E.Mode = LJ
        BJ.BackgroundTransparency = 0
        BJ.TextTransparency = 0
        WJ:Close()
    end
    hJ.Deselect = function(RJ)
        E.Mode = nil
        BJ.BackgroundTransparency = 1
        BJ.TextTransparency = 0.5
    end
    BJ.MouseButton1Click:Connect(function()
        hJ:Select()
    end)
    if E.Mode == LJ then
        hJ:Select()
    end
    UJ[LJ] = hJ
end
E.Display = function(LJ, LJ)
    if f.Unloaded then return
end
local hJ, BJ = f:GetTextBounds(LJ or E.DisplayValue, i.FontFace, i.TextSize, n.AbsoluteSize.X)
i.Text = LJ or E.DisplayValue
i.Size = UDim2.fromOffset(hJ + 9, BJ + 4)
end
E.Update = function(n)
    E:Display()
    if m.NoUI then
        return
    end
    if E.Mode == "Toggle" and k.Type == "Toggle" and k.Disabled then
        qJ:SetVisibility(false)
        return
    end
    local n, LJ = E:GetState(), f.ShowToggleFrameInKeybinds and E.Mode == "Toggle"
    if E.SyncToggleState and k.Value ~= n then
        k:SetValue(n)
    end
    if qJ.Loaded then
        if LJ then
            qJ:SetNormal(false)
        else
            qJ:SetNormal(true)
        end
        qJ:SetText(("[%s] %s (%s)"):format(E.DisplayValue, E.Text, E.Mode))
        qJ:SetVisibility(true)
        qJ:Display(n)
    end
end
E.GetState = function(n)
    if E.Mode == "Always" then return true
elseif E.Mode == "Hold" then
    n = E.Value
    if n == "None" then
        return false
    end
    if not JJ(E.Modifiers) then
        return false
    end
    if G[n] ~= nil then
        return U:IsMouseButtonPressed(G[n]) and not U:GetFocusedTextBox()
    else
        return U:IsKeyDown(Enum.KeyCode[n]) and not U:GetFocusedTextBox()
    end
else
    return E.Toggled
end
end
E.OnChanged = function(n, n)
    E.Changed = n
end
E.OnClick = function(n, n)
    E.Clicked = n
end
E.DoClick = function(n)
    if E.Mode == "Press" then
    if E.Toggled and m.WaitForCallback == true then
        return
    end
    E.Toggled = true
end
f:SafeCallback(E.Callback, E.Toggled)
f:SafeCallback(E.Clicked, E.Toggled)
if E.Mode == "Press" then
    E.Toggled = false
end
end
E.SetValue = function(m, n)
    local LJ, hJ, BJ = n[1], n[2], n[3]
    m, n = pcall(function()
        if LJ == "None" then LJ = nil
        return nil
    end
    if G[LJ] == nil then
        return Enum.KeyCode[LJ]
    end
    return G[LJ]
end)
if LJ == nil then
    E.Value = "None"
elseif m then
    E.Value = LJ
else
    E.Value = "Unknown"
end
E.Modifiers = AJ(typeof(BJ) == "table" and BJ or E.Modifiers)
E.DisplayValue = p(E.Modifiers) > 0 and table.concat(E.Modifiers, " + ") .. " + " .. E.Value or E.Value
if UJ[hJ] then
    UJ[hJ]:Select()
end
m = NJ(E.Modifiers)
f:SafeCallback(E.ChangedCallback, n, m)
f:SafeCallback(E.Changed, n, m)
E:Update()
end
E.SetText = function(m, m)
    qJ:SetText(m)
    E:Update()
end
i.MouseButton1Click:Connect(function()
    if S then return
end
S = true
i.Text = "..."
i.Size = UDim2.fromOffset(29, 18)
local m
local n = {}
local function G()
    m = U.InputBegan:Wait()
    return U:GetFocusedTextBox() ~= nil
end
repeat
    task.wait()
    i.Text = "..."
    i.Size = UDim2.fromOffset(29, 18)
    if G() then
        S = false
        E:Update()
        return
    end
    if m.KeyCode == Enum.KeyCode.Escape then
        break
    end
    if MJ(m) then
        local NJ = false
        repeat
            task.wait()
            if U:IsKeyDown(m.KeyCode) then
                task.wait(0.075)
                if U:IsKeyDown(m.KeyCode) then
                    if not table.find(n, T[m.KeyCode]) then
                        n[#n + 1] = T[m.KeyCode]
                        E:Display(table.concat(n, " + ") .. " + ...")
                    end
                    local AJ = NJ
                    if G() then
                        NJ = true
                        break
                    end
                    if m.KeyCode == Enum.KeyCode.Escape then
                        NJ = AJ
                        break
                    end
                    if not MJ(m) then
                        NJ = AJ
                        break
                    end
                elseif not table.find(n, T[m.KeyCode]) then
                    break
                end
            end
            until false
            if NJ then
                S = false
                E:Update()
                return
            end
        end
        break
        until false
        local G, T = if y[m.UserInputType] ~= nil then y[m.UserInputType] else
        if m.UserInputType == Enum.UserInputType.Keyboard then
            m.KeyCode == Enum.KeyCode.Escape and "None" or m.KeyCode.Name
        else
            "Unknown", {"Touch", "MB1", "MB2", "MB3", "W", "A", "S", "D", "Space", "LeftShift", "LeftControl"}
            for MJ, MJ in pairs(T) do
                if G == MJ then
                    f:Notify("Cant use " .. MJ .. " as keybind", 3)
                    S = false
                    E:Update()
                    return
                end
            end
            n = (m.KeyCode == Enum.KeyCode.Escape or G == "Unknown") and{} or n
            E.Toggled = false
            E:SetValue({G, E.Mode, n})
            repeat
                task.wait()
                until not bJ(m) or(U:GetFocusedTextBox())
                S = false
            end)
            i.MouseButton2Click:Connect(WJ.Toggle)
            f:GiveSignal(U.InputBegan:Connect(function(m)
                if f.Unloaded then return
            end
            if E.Mode == "Always" or E.Value == "Unknown" or E.Value == "None" or S or(U:GetFocusedTextBox()) then
                return
            end
            local n = E.Value
            local G = if n and JJ(E.Modifiers) == true and(y[m.UserInputType] == n or m.UserInputType == Enum.UserInputType.Keyboard and m.KeyCode.Name == n) then true else false
            if E.Mode == "Toggle" then
                if G then
                    E.Toggled = not E.Toggled
                    E:DoClick()
                end
            elseif E.Mode == "Press" then
                if G then
                    E:DoClick()
                end
            end
            E:Update()
        end))
        f:GiveSignal(U.InputEnded:Connect(function()
            if f.Unloaded then return
        end
        if E.Value == "Unknown" or E.Value == "None" or S or(U:GetFocusedTextBox()) then
            return
        end
        E:Update()
    end))
    E:Update()
    if k.Addons then
        table.insert(k.Addons, E)
    end
    E.Default = E.Value
    E.DefaultModifiers = table.clone(E.Modifiers or{})
    z[O] = E
    return j
end
}, {}
for j = 0, 1, 0.1 do
    table.insert(K, ColorSequenceKeypoint.new(j, Color3.fromHSV(j, 1, 1)))
end
x.AddColorPicker = function(j, O, m)
    m = f:Validate(m, l.ColorPicker)
    local k, n = j.TextLabel, {Value = m.Default, Transparency = m.Transparency or 0, Title = m.Title, Callback = m.Callback, Changed = m.Changed, Type = "ColorPicker"}
    n.Hue, n.Sat, n.Vib = n.Value:ToHSV()
    local E = F("TextButton", {BackgroundColor3 = n.Value, BorderColor3 = f:GetDarkerColor(n.Value), BorderSizePixel = 1, Size = UDim2.fromOffset(18, 18), Text = "", Parent = k})
    local S, G = F("ImageLabel", {Image = Y.GetAsset("TransparencyTexture"), ImageTransparency = 1 -n.Transparency, ScaleType = Enum.ScaleType.Tile, Size = UDim2.fromScale(1, 1), TileSize = UDim2.fromOffset(9, 9), Parent = E}), f:AddContextMenu(E, UDim2.fromOffset(m.Transparency and 256 or 234, 0), function()
        return{0.5, E.AbsoluteSize.Y + 1.5}
    end, 1)
    G.List.Padding = UDim.new(0, 8)
    n.ColorMenu = G
    F("UIPadding", {PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 6), Parent = G.Menu})
    if typeof(n.Title) == "string" then
        F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 8), Text = n.Title, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = G.Menu})
    end
    k = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 200), Parent = G.Menu})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), Parent = k})
    local y = F("ImageButton", {BackgroundColor3 = n.Value, Image = Y.GetAsset("SaturationMap"), Size = UDim2.fromOffset(200, 200), Parent = k})
    local i = F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "WhiteColor", Size = UDim2.fromOffset(6, 6), Parent = y})
    F("UICorner", {CornerRadius = UDim.new(1, 0), Parent = i})
    F("UIStroke", {Color = "DarkColor", Parent = i})
    local T = F("TextButton", {Size = UDim2.fromOffset(16, 200), Text = "", Parent = k})
    F("UIGradient", {Color = ColorSequence.new(K), Rotation = 90, Parent = T})
    local K = F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "WhiteColor", BorderColor3 = "DarkColor", BorderSizePixel = 1, Position = UDim2.fromScale(0.5, n.Hue), Size = UDim2.new(1, 2, 0, 1), Parent = T})
    local MJ, bJ, JJ
    if m.Transparency then
        MJ = F("ImageButton", {Image = Y.GetAsset("TransparencyTexture"), ScaleType = Enum.ScaleType.Tile, Size = UDim2.fromOffset(16, 200), TileSize = UDim2.fromOffset(8, 8), Parent = k})
        bJ = F("Frame", {BackgroundColor3 = n.Value, Size = UDim2.fromScale(1, 1), Parent = MJ})
        F("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}), Parent = bJ})
        JJ = F("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "WhiteColor", BorderColor3 = "DarkColor", BorderSizePixel = 1, Position = UDim2.fromScale(0.5, n.Transparency), Size = UDim2.new(1, 2, 0, 1), Parent = MJ})
    end
    k = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20), Parent = G.Menu})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = UDim.new(0, 8), Parent = k})
    local Y, NJ, AJ = F("TextBox", {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, ClearTextOnFocus = false, Size = UDim2.fromScale(1, 1), Text = "#??????", TextSize = 14, Parent = k}), F("TextBox", {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, ClearTextOnFocus = false, Size = UDim2.fromScale(1, 1), Text = "?, ?, ?", TextSize = 14, Parent = k}), f:AddContextMenu(E, UDim2.fromOffset(93, 0), function()
        return{E.AbsoluteSize.X + 1.5, 0.5}
    end, 1)
    n.ContextMenu = AJ
    local function k(qJ, WJ)
        F("TextButton", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 21), Text = qJ, TextSize = 14, Parent = AJ.Menu}).MouseButton1Click:Connect(function()
            f:SafeCallback(WJ)
            AJ:Close()
        end)
    end
    k("Copy color", function()
        f.CopiedColor = {n.Value, n.Transparency}
    end)
    n.SetValueRGB = function(...)
    end
    k("Paste color", function()
        n:SetValueRGB(f.CopiedColor[1], f.CopiedColor[2])
    end)
    if s then
        k("Copy Hex", function()
            s(tostring(n.Value:ToHex()))
        end)
        k("Copy RGB", function()
            s(table.concat({math.floor(n.Value.R * 255), math.floor(n.Value.G * 255), math.floor(n.Value.B * 255)}, ", "))
        end)
    end
    n.SetHSVFromRGB = function(s, s)
        n.Hue, n.Sat, n.Vib = s:ToHSV()
    end
    n.Display = function(s)
        if f.Unloaded then return
    end
    n.Value = Color3.fromHSV(n.Hue, n.Sat, n.Vib)
    E.BackgroundColor3 = n.Value
    E.BorderColor3 = f:GetDarkerColor(n.Value)
    S.ImageTransparency = 1 -n.Transparency
    y.BackgroundColor3 = Color3.fromHSV(n.Hue, 1, 1)
    if bJ then
        bJ.BackgroundColor3 = n.Value
    end
    i.Position = UDim2.fromScale(n.Sat, 1 -n.Vib)
    K.Position = UDim2.fromScale(0.5, n.Hue)
    if JJ then
        JJ.Position = UDim2.fromScale(0.5, n.Transparency)
    end
    Y.Text = "#" .. n.Value:ToHex()
    NJ.Text = table.concat({math.floor(n.Value.R * 255), math.floor(n.Value.G * 255), math.floor(n.Value.B * 255)}, ", ")
end
n.Update = function(s)
    n:Display()
    f:SafeCallback(n.Callback, n.Value)
    f:SafeCallback(n.Changed, n.Value)
end
n.OnChanged = function(s, s)
    n.Changed = s
end
n.SetValue = function(s, K, k)
    if typeof(K) == "Color3" then n:SetValueRGB(K, k)
    return
end
s = Color3.fromHSV(K[1], K[2], K[3])
n.Transparency = m.Transparency and k or 0
n:SetHSVFromRGB(s)
n:Update()
end
n.SetValueRGB = function(s, s, K)
    n.Transparency = m.Transparency and K or 0
    n:SetHSVFromRGB(s)
    n:Update()
end
E.MouseButton1Click:Connect(G.Toggle)
E.MouseButton2Click:Connect(AJ.Toggle)
y.InputBegan:Connect(function(s)
    while g(s) do
        local s = y.AbsolutePosition.X
        local K = s + y.AbsoluteSize.X
        local m, k = math.clamp(C.X, s, K), y.AbsolutePosition.Y
        local E = k + y.AbsoluteSize.Y
        local S, G, y = math.clamp(C.Y, k, E), n.Sat, n.Vib
        n.Sat = (m -s) / (K -s)
        n.Vib = 1 -(S -k) / (E -k)
        if n.Sat ~= G or n.Vib ~= y then
            n:Update()
        end
        q.RenderStepped:Wait()
    end
end)
T.InputBegan:Connect(function(s)
    while g(s) do
        local s = T.AbsolutePosition.Y
        local K = s + T.AbsoluteSize.Y
        local m, k = math.clamp(C.Y, s, K), n.Hue
        n.Hue = (m -s) / (K -s)
        if n.Hue ~= k then
            n:Update()
        end
        q.RenderStepped:Wait()
    end
end)
if MJ then
    MJ.InputBegan:Connect(function(s)
        while g(s) do
            local s, K = MJ.AbsolutePosition.Y, MJ.AbsolutePosition.Y + MJ.AbsoluteSize.Y
            local m, k = math.clamp(C.Y, s, K), n.Transparency
            n.Transparency = (m -s) / (K -s)
            if n.Transparency ~= k then
                n:Update()
            end
            q.RenderStepped:Wait()
        end
    end)
end
Y.FocusLost:Connect(function(s)
    if not s then return
end
local s, K = pcall(Color3.fromHex, Y.Text)
if s and typeof(K) == "Color3" then
    n.Hue, n.Sat, n.Vib = K:ToHSV()
end
n:Update()
end)
NJ.FocusLost:Connect(function(s)
    if not s then return
end
local s, Y, K = NJ.Text:match("(%d+),%s*(%d+),%s*(%d+)")
if s and Y and K then
    n:SetHSVFromRGB(Color3.fromRGB(s, Y, K))
end
n:Update()
end)
n:Display()
if j.Addons then
    table.insert(j.Addons, n)
end
n.Default = n.Value
z[O] = n
return j
end
x.AddInlineButton = function(s, Y)
    Y = if typeof(Y) ~= "table" then{Text = tostring(Y or "")} else Y
    local K = s.TextLabel
    assert(K, "AddInlineButton can only be applied on Toggles or Labels.")
    local j, O = {Text = Y.Text or "", Icon = Y.Icon, Func = Y.Func or Y.Callback or function()
    end, Tooltip = Y.Tooltip, DisabledTooltip = Y.DisabledTooltip, TooltipTable = nil, Risky = Y.Risky or false, Disabled = Y.Disabled or false, Visible = Y.Visible ~= false, Tween = nil, Type = "InlineButton"}, Y.Size or 16
    local m = F("TextButton", {Active = not j.Disabled, BackgroundColor3 = j.Disabled and "BackgroundColor" or "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Size = UDim2.fromOffset(O, O), Text = "", TextSize = 11, TextTransparency = j.Disabled and 0.8 or 0.35, Visible = j.Visible, Parent = K})
    local K, O = F("UIStroke", {Color = "OutlineColor", Transparency = j.Disabled and 0.5 or 0, Parent = m}), false
    if j.Icon then
        Y = f:GetIcon(j.Icon)
        if Y then
            F("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Image = Y.Url or "", ImageColor3 = "FontColor", ImageRectOffset = Y.ImageRectOffset or Vector2.zero, ImageRectSize = Y.ImageRectSize or Vector2.zero, ImageTransparency = j.Disabled and 0.8 or 0.2, Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(1, -4, 1, -4), Parent = m})
            O = true
        end
    end
    if not O then
        m.Text = j.Text
    end
    j.Base = m
    j.Stroke = K
    j.UpdateColors = function(Y)
        if f.Unloaded then return
    end
    _(j.Tween)
    m.BackgroundColor3 = j.Disabled and f.Scheme.BackgroundColor or f.Scheme.MainColor
    m.TextTransparency = j.Disabled and 0.8 or 0.35
    K.Transparency = j.Disabled and 0.5 or 0
    m.Active = not j.Disabled
    f.Registry[m].BackgroundColor3 = j.Disabled and "BackgroundColor" or "MainColor"
end
j.SetDisabled = function(Y, Y)
    j.Disabled = Y
    if j.TooltipTable then
        j.TooltipTable.Disabled = j.Disabled
    end
    j:UpdateColors()
end
j.SetVisible = function(Y, Y)
    j.Visible = Y
    m.Visible = Y
end
j.SetText = function(Y, Y)
    j.Text = Y
    m.Text = Y
end
m.MouseEnter:Connect(function()
    if j.Disabled then return
end
f:PlaySound("hover", 0.06, 1.5)
j.Tween = B:Create(m, f.TweenInfo, {TextTransparency = 0})
j.Tween:Play()
end)
m.MouseLeave:Connect(function()
    if j.Disabled then return
end
j.Tween = B:Create(m, f.TweenInfo, {TextTransparency = 0.35})
j.Tween:Play()
end)
m.MouseButton1Click:Connect(function()
    if j.Disabled then return
end
f:PlaySound("click", 0.12, 1)
f:SafeCallback(j.Func)
end)
if typeof(j.Tooltip) == "string" or typeof(j.DisabledTooltip) == "string" then
    j.TooltipTable = f:AddTooltip(j.Tooltip, j.DisabledTooltip, m)
    j.TooltipTable.Disabled = j.Disabled
end
if j.Risky then
    m.TextColor3 = f.Scheme.RedColor
    f.Registry[m].TextColor3 = "RedColor"
end
j:UpdateColors()
if s.Addons then
    table.insert(s.Addons, j)
end
return j
end
I.__index = x
I.__namecall = function(s, s, ...)
    return x[s](...)
end
end
local s = {}
do
    local Y = {}
    local function x(K)
        f.Registry[K] = nil
        for j, j in ipairs(K:GetDescendants()) do
            f.Registry[j] = nil
        end
    end
    Y.RemoveElement = function(K, j)
        if not j then return
    end
    pcall(function()
        if j.Menu and j.Menu.Destroy then j.Menu:Destroy()
    end
end)
pcall(function()
    if j.TooltipTable and j.TooltipTable.Destroy then j.TooltipTable:Destroy()
end
end)
local O = {H, z, J}
for m, m in ipairs(O) do
    for O, k in pairs(m) do
        if k == j then
            m[O] = nil
        end
    end
end
local O = j.Holder or j.Base
if O then
    pcall(function()
        x(O)
    end)
    pcall(function()
        O:Destroy()
    end)
end
for x = #K.Elements, 1, -1 do
    if K.Elements[x] == j then
        table.remove(K.Elements, x)
    end
end
pcall(function()
    K:Resize()
end)
end
Y.Clear = function(x)
    for K = #x.Elements, 1, -1 do
        x:RemoveElement(x.Elements[K])
    end
end
Y.AddDivider = function(x, K)
    local j = x.Container
    local O = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 6), Parent = j})
    if K then
        j = F("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), Text = K, TextSize = 14, TextTransparency = 0.5, TextXAlignment = Enum.TextXAlignment.Center, Parent = O})
        local m = f:GetTextBounds(K, j.FontFace, j.TextSize, j.AbsoluteSize.X)
        local K = math.floor(m / 2) + 10
        F("Frame", {AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(0.5, -K, 0, 2), Parent = O})
        F("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(1, 0.5), Size = UDim2.new(0.5, -K, 0, 2), Parent = O})
    else
        F("Frame", {AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 2), Parent = O})
    end
    x:Resize()
    table.insert(x.Elements, {Holder = O, Type = "Divider"})
end
Y.AddLabel = function(x, ...)
    local K, j, O = {}, select(1, ...), select(2, ...)
    if typeof(j) == "table" or typeof(O) == "table" then
        local m = typeof(j) == "table" and j or O
        K.Text = m.Text or ""
        K.DoesWrap = m.DoesWrap or false
        K.Size = m.Size or 14
        K.Visible = m.Visible or true
        K.Idx = typeof(O) == "table" and j or nil
    else
        K.Text = j or ""
        K.DoesWrap = O or false
        K.Size = 14
        K.Visible = true
        K.Idx = select(3, ...) or nil
    end
    local j = x
    local m, k = j.Container, {Text = K.Text, DoesWrap = K.DoesWrap, Addons = {}, Visible = K.Visible, Type = "Label"}
    local n = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = k.Text, TextSize = K.Size, TextWrapped = k.DoesWrap, TextXAlignment = j.IsKeyTab and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left, Parent = m})
    k.SetVisible = function(E, E)
        k.Visible = E
        n.Visible = k.Visible
        j:Resize()
    end
    k.SetText = function(E, S)
        k.Text = S
        n.Text = S
        if k.DoesWrap then
            E, S = f:GetTextBounds(k.Text, n.FontFace, n.TextSize, n.AbsoluteSize.X)
            n.Size = UDim2.new(1, 0, 0, S + 4)
        end
        j:Resize()
    end
    if k.DoesWrap then
        O, x = f:GetTextBounds(k.Text, n.FontFace, n.TextSize, n.AbsoluteSize.X)
        n.Size = UDim2.new(1, 0, 0, x + 4)
        local x = n.AbsoluteSize
        n:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if n.AbsoluteSize == x then return
        end
        local O, O = f:GetTextBounds(k.Text, n.FontFace, n.TextSize, n.AbsoluteSize.X)
        n.Size = UDim2.new(1, 0, 0, O + 4)
        x = n.AbsoluteSize
        j:Resize()
    end)
else
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), Parent = n})
end
j:Resize()
k.TextLabel = n
k.Container = m
if not K.DoesWrap then
    setmetatable(k, I)
end
k.Holder = n
table.insert(j.Elements, k)
if K.Idx then
    J[K.Idx] = k
else
    table.insert(J, k)
end
return k
end
Y.AddButton = function(J, ...)
    local function x(...)
        local K, j, O = {}, select(1, ...), select(2, ...)
        if typeof(j) == "table" or typeof(O) == "table" then
            local m = typeof(j) == "table" and j or O
            K.Text = m.Text or ""
            K.Func = m.Func or m.Callback or function()
            end
            K.DoubleClick = m.DoubleClick
            K.Tooltip = m.Tooltip
            K.DisabledTooltip = m.DisabledTooltip
            K.Risky = m.Risky or false
            K.Disabled = m.Disabled or false
            K.Visible = m.Visible or true
            K.Idx = typeof(O) == "table" and j or nil
        else
            K.Text = j or ""
            K.Func = O or function()
            end
            K.DoubleClick = false
            K.Tooltip = nil
            K.DisabledTooltip = nil
            K.Risky = false
            K.Disabled = false
            K.Visible = true
            K.Idx = select(3, ...) or nil
        end
        return K
    end
    local K, j = x(...), J
    local J, O = j.Container, {Text = K.Text, Func = K.Func, DoubleClick = K.DoubleClick, Tooltip = K.Tooltip, DisabledTooltip = K.DisabledTooltip, TooltipTable = nil, Risky = K.Risky, Disabled = K.Disabled, Visible = K.Visible, Tween = nil, Type = "Button"}
    local m = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 21), Parent = J})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill, Padding = UDim.new(0, 9), Parent = m})
    local function J(k)
        local n = F("TextButton", {Active = not k.Disabled, BackgroundColor3 = k.Disabled and "BackgroundColor" or "MainColor", Size = UDim2.fromScale(1, 1), Text = k.Text, TextSize = 14, TextTransparency = 0.3, Visible = k.Visible, Parent = m})
        return n, (F("UIStroke", {Color = "OutlineColor", Transparency = k.Disabled and 0.5 or 0, Parent = n}))
    end
    local function k(n)
        n.Base.MouseEnter:Connect(function()
            if n.Disabled then return
        end
        f:PlaySound("hover", 0.08, 1.5)
        n.Tween = B:Create(n.Base, f.TweenInfo, {TextTransparency = 0})
        n.Tween:Play()
    end)
    n.Base.MouseLeave:Connect(function()
        if n.Disabled then return
    end
    n.Tween = B:Create(n.Base, f.TweenInfo, {TextTransparency = 0.4})
    n.Tween:Play()
end)
n.Base.MouseButton1Click:Connect(function()
    if n.Disabled or n.Locked then return
end
f:PlaySound("click", 0.15, 1)
if n.DoubleClick then
    n.Locked = true
    n.Base.Text = "Are you sure?"
    n.Base.TextColor3 = f.Scheme.AccentColor
    f.Registry[n.Base].TextColor3 = "AccentColor"
    local E = Z(n.Base.MouseButton1Click, 0.5)
    n.Base.Text = n.Text
    n.Base.TextColor3 = n.Risky and f.Scheme.RedColor or f.Scheme.FontColor
    f.Registry[n.Base].TextColor3 = n.Risky and "RedColor" or "FontColor"
    if E then
        f:SafeCallback(n.Func)
    end
    q.RenderStepped:Wait()
    n.Locked = false
    return
end
f:SafeCallback(n.Func)
end)
end
O.Base, O.Stroke = J(O)
k(O)
O.AddButton = function(Z, ...)
    Z = x(...)
    local x = {Text = Z.Text, Func = Z.Func, DoubleClick = Z.DoubleClick, Tooltip = Z.Tooltip, DisabledTooltip = Z.DisabledTooltip, TooltipTable = nil, Risky = Z.Risky, Disabled = Z.Disabled, Visible = Z.Visible, Tween = nil, Type = "SubButton"}
    O.SubButton = x
    x.Base, x.Stroke = J(x)
    k(x)
    x.UpdateColors = function(J)
        if f.Unloaded then return
    end
    _(x.Tween)
    x.Base.BackgroundColor3 = x.Disabled and f.Scheme.BackgroundColor or f.Scheme.MainColor
    x.Base.TextTransparency = x.Disabled and 0.8 or 0.4
    x.Stroke.Transparency = x.Disabled and 0.5 or 0
    f.Registry[x.Base].BackgroundColor3 = x.Disabled and "BackgroundColor" or "MainColor"
end
x.SetDisabled = function(J, J)
    x.Disabled = J
    if x.TooltipTable then
        x.TooltipTable.Disabled = x.Disabled
    end
    x.Base.Active = not x.Disabled
    x:UpdateColors()
end
x.SetVisible = function(J, J)
    x.Visible = J
    x.Base.Visible = x.Visible
    j:Resize()
end
x.SetText = function(J, J)
    x.Text = J
    x.Base.Text = J
end
if typeof(x.Tooltip) == "string" or typeof(x.DisabledTooltip) == "string" then
    x.TooltipTable = f:AddTooltip(x.Tooltip, x.DisabledTooltip, x.Base)
    x.TooltipTable.Disabled = x.Disabled
end
if x.Risky then
    x.Base.TextColor3 = f.Scheme.RedColor
    f.Registry[x.Base].TextColor3 = "RedColor"
end
x:UpdateColors()
if Z.Idx then
    o[Z.Idx] = x
else
    table.insert(o, x)
end
return x
end
O.UpdateColors = function(J)
    if f.Unloaded then return
end
_(O.Tween)
O.Base.BackgroundColor3 = O.Disabled and f.Scheme.BackgroundColor or f.Scheme.MainColor
O.Base.TextTransparency = O.Disabled and 0.8 or 0.4
O.Stroke.Transparency = O.Disabled and 0.5 or 0
f.Registry[O.Base].BackgroundColor3 = O.Disabled and "BackgroundColor" or "MainColor"
end
O.SetDisabled = function(J, J)
    O.Disabled = J
    if O.TooltipTable then
        O.TooltipTable.Disabled = O.Disabled
    end
    O.Base.Active = not O.Disabled
    O:UpdateColors()
end
O.SetVisible = function(J, J)
    O.Visible = J
    m.Visible = O.Visible
    j:Resize()
end
O.SetText = function(J, J)
    O.Text = J
    O.Base.Text = J
end
if typeof(O.Tooltip) == "string" or typeof(O.DisabledTooltip) == "string" then
    O.TooltipTable = f:AddTooltip(O.Tooltip, O.DisabledTooltip, O.Base)
    O.TooltipTable.Disabled = O.Disabled
end
if O.Risky then
    O.Base.TextColor3 = f.Scheme.RedColor
    f.Registry[O.Base].TextColor3 = "RedColor"
end
O:UpdateColors()
j:Resize()
O.Holder = m
table.insert(j.Elements, O)
if K.Idx then
    o[K.Idx] = O
else
    table.insert(o, O)
end
return O
end
Y.AddCheckbox = function(J, o, Z)
    Z = f:Validate(Z, l.Toggle)
    local _ = J
    local J, x = _.Container, {Text = Z.Text, Value = Z.Default, Tooltip = Z.Tooltip, DisabledTooltip = Z.DisabledTooltip, TooltipTable = nil, Callback = Z.Callback, Changed = Z.Changed, Risky = Z.Risky, Disabled = Z.Disabled, Visible = Z.Visible, Addons = {}, Type = "Toggle"}
    local Z = F("TextButton", {Active = not x.Disabled, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = "", Visible = x.Visible, Parent = J})
    local K = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -26, 1, 0), Text = x.Text, TextSize = 14, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Left, Parent = Z})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), Parent = K})
    local j = F("Frame", {BackgroundColor3 = "MainColor", Size = UDim2.fromScale(1, 1), SizeConstraint = Enum.SizeConstraint.RelativeYY, Parent = Z})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius / 2), Parent = j})
    local O, m = F("UIStroke", {Color = "OutlineColor", Parent = j}), F("ImageLabel", {Image = L and L.Url or "", ImageColor3 = "FontColor", ImageRectOffset = L and L.ImageRectOffset or Vector2.zero, ImageRectSize = L and L.ImageRectSize or Vector2.zero, ImageTransparency = 1, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4), Parent = j})
    x.UpdateColors = function(k)
        x:Display()
    end
    x.Display = function(k)
        if f.Unloaded then return
    end
    local function k()
        O.Transparency = x.Disabled and 0.5 or 0
        if x.Disabled then
            K.TextTransparency = 0.8
            m.ImageTransparency = x.Value and 0.8 or 1
            j.BackgroundColor3 = f.Scheme.BackgroundColor
            f.Registry[j].BackgroundColor3 = "BackgroundColor"
            return
        end
        B:Create(K, f.TweenInfo, {TextTransparency = x.Value and 0 or 0.4}):Play()
        B:Create(m, f.TweenInfo, {ImageTransparency = x.Value and 0 or 1}):Play()
        j.BackgroundColor3 = f.Scheme.MainColor
        f.Registry[j].BackgroundColor3 = "MainColor"
    end
    if yabujinCoreState and yabujinCoreState._withId then
        yabujinCoreState._withId(k)
    else
        pcall(k)
    end
end
x.OnChanged = function(j, j)
    x.Changed = j
end
x.SetValue = function(j, j)
    if x.Disabled then return
end
x.Value = j
x:Display()
for j, j in pairs(x.Addons) do
    if j.Type == "KeyPicker" and j.SyncToggleState then
        j.Toggled = x.Value
        j:Update()
    end
end
f:UpdateDependencyBoxes()
f:SafeCallback(x.Callback, x.Value)
f:SafeCallback(x.Changed, x.Value)
end
x.SetDisabled = function(j, j)
    x.Disabled = j
    if x.TooltipTable then
        x.TooltipTable.Disabled = x.Disabled
    end
    for j, j in pairs(x.Addons) do
        if j.Type == "KeyPicker" and j.SyncToggleState then
            j:Update()
        end
    end
    Z.Active = not x.Disabled
    x:Display()
end
x.SetVisible = function(j, j)
    x.Visible = j
    Z.Visible = x.Visible
    _:Resize()
end
x.SetText = function(j, j)
    x.Text = j
    K.Text = j
end
Z.MouseButton1Click:Connect(function()
    if x.Disabled then return
end
local j = not x.Value
f:PlaySound(j and "toggle_on" or "toggle_off", 0.12, j and 1.1 or 0.9)
x:SetValue(j)
end)
if typeof(x.Tooltip) == "string" or typeof(x.DisabledTooltip) == "string" then
    x.TooltipTable = f:AddTooltip(x.Tooltip, x.DisabledTooltip, Z)
    x.TooltipTable.Disabled = x.Disabled
end
if x.Risky then
    K.TextColor3 = f.Scheme.RedColor
    f.Registry[K].TextColor3 = "RedColor"
end
x:Display()
_:Resize()
x.TextLabel = K
x.Container = J
setmetatable(x, I)
x.Holder = Z
table.insert(_.Elements, x)
x.Default = x.Value
H[o] = x
return x
end
Y.AddToggle = function(J, o, Z)
    Z = f:Validate(Z, l.Toggle)
    local _ = J
    local J, x = _.Container, {Text = Z.Text, Value = Z.Default, Tooltip = Z.Tooltip, DisabledTooltip = Z.DisabledTooltip, TooltipTable = nil, Callback = Z.Callback, Changed = Z.Changed, Risky = Z.Risky, Disabled = Z.Disabled, Visible = Z.Visible, Addons = {}, Type = "Toggle"}
    local Z = F("TextButton", {Active = not x.Disabled, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), Text = "", Visible = x.Visible, Parent = J})
    local K = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -26, 1, 0), Text = x.Text, TextSize = 14, TextTransparency = 0.4, TextXAlignment = Enum.TextXAlignment.Left, Parent = Z})
    F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), Parent = K})
    local j = F("Frame", {BackgroundColor3 = "MainColor", Size = UDim2.fromScale(1, 1), SizeConstraint = Enum.SizeConstraint.RelativeYY, Parent = Z})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius / 2), Parent = j})
    local O, m = F("UIStroke", {Color = "OutlineColor", Parent = j}), F("ImageLabel", {Image = L and L.Url or "", ImageColor3 = "FontColor", ImageRectOffset = L and L.ImageRectOffset or Vector2.zero, ImageRectSize = L and L.ImageRectSize or Vector2.zero, ImageTransparency = 1, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4), Parent = j})
    x.UpdateColors = function(L)
        x:Display()
    end
    x.Display = function(L)
        if f.Unloaded then return
    end
    local function L()
        O.Transparency = x.Disabled and 0.5 or 0
        if x.Disabled then
            K.TextTransparency = 0.8
            m.ImageTransparency = x.Value and 0.8 or 1
            j.BackgroundColor3 = f.Scheme.BackgroundColor
            f.Registry[j].BackgroundColor3 = "BackgroundColor"
            return
        end
        B:Create(K, f.TweenInfo, {TextTransparency = x.Value and 0 or 0.4}):Play()
        B:Create(m, f.TweenInfo, {ImageTransparency = x.Value and 0 or 1}):Play()
        j.BackgroundColor3 = f.Scheme.MainColor
        f.Registry[j].BackgroundColor3 = "MainColor"
    end
    if yabujinCoreState and yabujinCoreState._withId then
        yabujinCoreState._withId(L)
    else
        pcall(L)
    end
end
x.OnChanged = function(L, L)
    x.Changed = L
end
x.SetValue = function(L, L)
    if x.Disabled then return
end
x.Value = L
x:Display()
for L, L in pairs(x.Addons) do
    if L.Type == "KeyPicker" and L.SyncToggleState then
        L.Toggled = x.Value
        L:Update()
    end
end
f:UpdateDependencyBoxes()
f:SafeCallback(x.Callback, x.Value)
f:SafeCallback(x.Changed, x.Value)
end
x.SetDisabled = function(L, L)
    x.Disabled = L
    if x.TooltipTable then
        x.TooltipTable.Disabled = x.Disabled
    end
    for L, L in pairs(x.Addons) do
        if L.Type == "KeyPicker" and L.SyncToggleState then
            L:Update()
        end
    end
    Z.Active = not x.Disabled
    x:Display()
end
x.SetVisible = function(L, L)
    x.Visible = L
    Z.Visible = x.Visible
    _:Resize()
end
x.SetText = function(L, L)
    x.Text = L
    K.Text = L
end
Z.MouseButton1Click:Connect(function()
    if x.Disabled then return
end
local L = not x.Value
f:PlaySound(L and "toggle_on" or "toggle_off", 0.12, L and 1.1 or 0.9)
x:SetValue(L)
end)
if typeof(x.Tooltip) == "string" or typeof(x.DisabledTooltip) == "string" then
    x.TooltipTable = f:AddTooltip(x.Tooltip, x.DisabledTooltip, Z)
    x.TooltipTable.Disabled = x.Disabled
end
if x.Risky then
    K.TextColor3 = f.Scheme.RedColor
    f.Registry[K].TextColor3 = "RedColor"
end
x:Display()
_:Resize()
x.TextLabel = K
x.Container = J
setmetatable(x, I)
x.Holder = Z
table.insert(_.Elements, x)
x.Default = x.Value
H[o] = x
return x
end
Y.AddInput = function(J, L, o)
    o = f:Validate(o, l.Input)
    local H = J
    local J, Z = H.Container, {Text = o.Text, Value = o.Default, Finished = o.Finished, Numeric = o.Numeric, ClearTextOnFocus = o.ClearTextOnFocus, Placeholder = o.Placeholder, AllowEmpty = o.AllowEmpty, EmptyReset = o.EmptyReset, Tooltip = o.Tooltip, DisabledTooltip = o.DisabledTooltip, TooltipTable = nil, Callback = o.Callback, Changed = o.Changed, Disabled = o.Disabled, Visible = o.Visible, Type = "Input"}
    local _ = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 39), Visible = Z.Visible, Parent = J})
    local J, I = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), Text = Z.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = _}), F("TextBox", {AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, ClearTextOnFocus = not Z.Disabled and Z.ClearTextOnFocus, PlaceholderText = Z.Placeholder, Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 21), Text = Z.Value, TextEditable = not Z.Disabled, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = _})
    F("UIPadding", {PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 4), Parent = I})
    Z.UpdateColors = function(x)
        if f.Unloaded then return
    end
    J.TextTransparency = Z.Disabled and 0.8 or 0
    I.TextTransparency = Z.Disabled and 0.8 or 0
end
Z.OnChanged = function(x, x)
    Z.Changed = x
end
Z.SetValue = function(x, x)
    if x == nil then x = Z.EmptyReset or(Z.Numeric and "0" or "")
end
if not Z.AllowEmpty and c(x) == "" then
    x = Z.EmptyReset or(Z.Numeric and "0" or "")
end
if o.MaxLength and#x > o.MaxLength then
    x = x:sub(1, o.MaxLength)
end
if Z.Numeric then
    if#tostring(x) > 0 and not tonumber(x) then
        x = Z.Value or "0"
    end
end
Z.Value = x
local function o()
    I.Text = tostring(x)
end
if yabujinCoreState and yabujinCoreState._withId then
    yabujinCoreState._withId(o)
else
    pcall(o)
end
if not Z.Disabled then
    f:SafeCallback(Z.Callback, Z.Value)
    f:SafeCallback(Z.Changed, Z.Value)
end
end
Z.SetDisabled = function(o, o)
    Z.Disabled = o
    if Z.TooltipTable then
        Z.TooltipTable.Disabled = Z.Disabled
    end
    I.ClearTextOnFocus = not Z.Disabled and Z.ClearTextOnFocus
    I.TextEditable = not Z.Disabled
    Z:UpdateColors()
end
Z.SetVisible = function(o, o)
    Z.Visible = o
    _.Visible = Z.Visible
    H:Resize()
end
Z.SetText = function(o, o)
    Z.Text = o
    J.Text = o
end
if Z.Finished then
    I.FocusLost:Connect(function(J)
        if not J then return
    end
    Z:SetValue(I.Text)
end)
else
    I:GetPropertyChangedSignal("Text"):Connect(function()
        Z:SetValue(I.Text)
    end)
end
if typeof(Z.Tooltip) == "string" or typeof(Z.DisabledTooltip) == "string" then
    Z.TooltipTable = f:AddTooltip(Z.Tooltip, Z.DisabledTooltip, I)
    Z.TooltipTable.Disabled = Z.Disabled
end
H:Resize()
Z.Holder = _
table.insert(H.Elements, Z)
Z.Default = Z.Value
z[L] = Z
return Z
end
Y.AddSlider = function(J, L, o)
    o = f:Validate(o, l.Slider)
    local H = J
    local J, Z = H.Container, {Text = o.Text, Value = o.Default, Min = o.Min, Max = o.Max, Prefix = o.Prefix, Suffix = o.Suffix, Compact = o.Compact, Rounding = o.Rounding, Tooltip = o.Tooltip, DisabledTooltip = o.DisabledTooltip, TooltipTable = nil, Callback = o.Callback, Changed = o.Changed, Disabled = o.Disabled, Visible = o.Visible, Type = "Slider"}
    local _ = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, o.Compact and 13 or 31), Visible = Z.Visible, Parent = J})
    local J
    if not o.Compact then
        J = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), Text = Z.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = _})
    end
    local c = F("TextButton", {Active = not Z.Disabled, AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 8), Text = "", Parent = _})
    F("UICorner", {CornerRadius = UDim.new(0, 4), Parent = c})
    local I = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", TextSize = 14, ZIndex = 2, Parent = c})
    F("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Color = "DarkColor", LineJoinMode = Enum.LineJoinMode.Miter, Parent = I})
    local x = F("Frame", {BackgroundColor3 = "AccentColor", Size = UDim2.fromScale(0.5, 1), Parent = c})
    F("UICorner", {CornerRadius = UDim.new(0, 4), Parent = x})
    Z.UpdateColors = function(K)
        if f.Unloaded then return
    end
    if J then
        J.TextTransparency = Z.Disabled and 0.8 or 0
    end
    I.TextTransparency = Z.Disabled and 0.8 or 0
    x.BackgroundColor3 = Z.Disabled and f.Scheme.OutlineColor or f.Scheme.AccentColor
    f.Registry[x].BackgroundColor3 = Z.Disabled and "OutlineColor" or "AccentColor"
end
Z.Display = function(K)
    if f.Unloaded then return
end
K = if o.FormatDisplayValue then(o.FormatDisplayValue(Z, Z.Value)) else nil
if K then
    I.Text = tostring(K)
elseif o.Compact then
    I.Text = string.format("%s: %s%s%s", Z.Text, Z.Prefix, Z.Value, Z.Suffix)
elseif o.HideMax then
    I.Text = string.format("%s%s%s", Z.Prefix, Z.Value, Z.Suffix)
else
    I.Text = string.format("%s%s%s/%s%s%s", Z.Prefix, Z.Value, Z.Suffix, Z.Prefix, Z.Max, Z.Suffix)
end
K = (Z.Value -Z.Min) / (Z.Max -Z.Min)
x.Size = UDim2.fromScale(K, 1)
end
Z.OnChanged = function(o, o)
    Z.Changed = o
end
Z.SetMax = function(o, o)
    assert(o > Z.Min, "Max value cannot be less than the current min value.")
    Z:SetValue(math.clamp(Z.Value, Z.Min, o))
    Z.Max = o
    Z:Display()
end
Z.SetMin = function(o, o)
    assert(o < Z.Max, "Min value cannot be greater than the current max value.")
    Z:SetValue(math.clamp(Z.Value, o, Z.Max))
    Z.Min = o
    Z:Display()
end
Z.SetValue = function(o, I)
    if Z.Disabled then return
end
o = tonumber(I)
if not o or o == Z.Value then
    return
end
Z.Value = math.clamp(o, Z.Min, Z.Max)
Z:Display()
f:SafeCallback(Z.Callback, Z.Value)
f:SafeCallback(Z.Changed, Z.Value)
end
Z.SetDisabled = function(o, o)
    Z.Disabled = o
    if Z.TooltipTable then
        Z.TooltipTable.Disabled = Z.Disabled
    end
    c.Active = not Z.Disabled
    Z:UpdateColors()
end
Z.SetVisible = function(o, o)
    Z.Visible = o
    _.Visible = Z.Visible
    H:Resize()
end
Z.SetText = function(o, o)
    Z.Text = o
    if J then
        J.Text = o
        return
    end
    Z:Display()
end
Z.SetPrefix = function(J, J)
    Z.Prefix = J
    Z:Display()
end
Z.SetSuffix = function(J, J)
    Z.Suffix = J
    Z:Display()
end
c.InputBegan:Connect(function(J)
    if not a(J) or Z.Disabled then return
end
for o, o in pairs(f.ActiveTab.Sides) do
    o.ScrollingEnabled = false
end
while g(J) do
    local J = C.X
    local o, g = math.clamp((J -c.AbsolutePosition.X) / c.AbsoluteSize.X, 0, 1), Z.Value
    Z.Value = e(Z.Min + (Z.Max -Z.Min) * o, Z.Rounding)
    Z:Display()
    if Z.Value ~= g then
        f:SafeCallback(Z.Callback, Z.Value)
        f:SafeCallback(Z.Changed, Z.Value)
    end
    q.RenderStepped:Wait()
end
for J, J in pairs(f.ActiveTab.Sides) do
    J.ScrollingEnabled = true
end
end)
if typeof(Z.Tooltip) == "string" or typeof(Z.DisabledTooltip) == "string" then
    Z.TooltipTable = f:AddTooltip(Z.Tooltip, Z.DisabledTooltip, c)
    Z.TooltipTable.Disabled = Z.Disabled
end
Z:UpdateColors()
Z:Display()
H:Resize()
Z.Holder = _
table.insert(H.Elements, Z)
Z.Default = Z.Value
z[L] = Z
return Z
end
Y.AddDropdown = function(J, L, o)
    o = f:Validate(o, l.Dropdown)
    local H = J
    J = H.Container
    if o.SpecialType == "Player" then
        o.Values = r(o.ExcludeLocalPlayer)
        o.AllowNull = true
    elseif o.SpecialType == "Team" then
        o.Values = u()
        o.AllowNull = true
    end
    local Z = {Text = typeof(o.Text) == "string" and o.Text or nil, Value = o.Multi and{} or nil, Values = o.Values, DisabledValues = o.DisabledValues, Multi = o.Multi, SpecialType = o.SpecialType, ExcludeLocalPlayer = o.ExcludeLocalPlayer, Tooltip = o.Tooltip, DisabledTooltip = o.DisabledTooltip, TooltipTable = nil, Callback = o.Callback, Changed = o.Changed, Disabled = o.Disabled, Visible = o.Visible, Type = "Dropdown"}
    local g = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, Z.Text and 39 or 21), Visible = Z.Visible, Parent = J})
    local _, c = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 14), Text = Z.Text, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Visible = not not o.Text, Parent = g}), F("TextButton", {Active = not Z.Disabled, AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 21), Text = "---", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = g})
    F("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 4), Parent = c})
    local e = F("ImageLabel", {AnchorPoint = Vector2.new(1, 0.5), Image = P and P.Url or "", ImageColor3 = "FontColor", ImageRectOffset = P and P.ImageRectOffset or Vector2.zero, ImageRectSize = P and P.ImageRectSize or Vector2.zero, ImageTransparency = 0.5, Position = UDim2.fromScale(1, 0.5), Size = UDim2.fromOffset(16, 16), Parent = c})
    local P
    if o.Searchable then
        P = F("TextBox", {BackgroundTransparency = 1, PlaceholderText = "Search...", Position = UDim2.fromOffset(- 8, 0), Size = UDim2.new(1, -12, 1, 0), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Visible = false, Parent = c})
        F("UIPadding", {PaddingLeft = UDim.new(0, 8), Parent = P})
    end
    local I = f:AddContextMenu(c, function()
        return UDim2.fromOffset(c.AbsoluteSize.X / f.DPIScale, 0)
    end, function()
        return{0.5, c.AbsoluteSize.Y + 1.5}
    end, 2, function(x)
        c.TextTransparency = x and P and 1 or 0
        e.ImageTransparency = x and 0 or 0.5
        e.Rotation = x and 180 or 0
        if P then
            P.Text = ""
            P.Visible = x
        end
    end)
    Z.Menu = I
    Z.RecalculateListSize = function(x, x)
        local K = math.clamp((x or(p(Z.Values))) * 21, 0, o.MaxVisibleDropdownItems * 21)
        I:SetSize(function()
            return UDim2.fromOffset(c.AbsoluteSize.X / f.DPIScale, K)
        end)
    end
    Z.UpdateColors = function(p)
        if f.Unloaded then return
    end
    _.TextTransparency = Z.Disabled and 0.8 or 0
    c.TextTransparency = Z.Disabled and 0.8 or 0
    e.ImageTransparency = Z.Disabled and 0.8 or I.Active and 0 or 0.5
end
Z.Display = function(p)
    if f.Unloaded then return
end
p = ""
if o.Multi then
    for e, e in pairs(Z.Values) do
        p = if Z.Value[e] then p .. (o.FormatDisplayValue and(tostring(o.FormatDisplayValue(e))) or(tostring(e))) .. ", " else p
    end
    p = (p:sub(1, #p -2))
else
    p = Z.Value and(tostring(Z.Value)) or ""
    p = if p ~= "" and o.FormatDisplayValue then(tostring(o.FormatDisplayValue(p))) else p
end
c.Text = (if#p > 25 then p:sub(1, 22) .. "..." else p) == "" and "---" or(if#p > 25 then p:sub(1, 22) .. "..." else p)
end
Z.OnChanged = function(p, p)
    Z.Changed = p
end
Z.GetActiveValues = function(p)
    if o.Multi then p = {}
    for e, x in pairs(Z.Value) do
        table.insert(p, e)
    end
    return p
end
return Z.Value and 1 or 0
end
local p = {}
Z.BuildDropdownList = function(e)
    local x, K = Z.Values, Z.DisabledValues
    for j, O in pairs(p) do
        j:Destroy()
    end
    table.clear(p)
    e = 0
    for j, j in pairs(x) do
        if not P or(tostring(j):lower():match(P.Text:lower())) then
            e += 1
            local x, O = table.find(K, j), {}
            local K = F("TextButton", {BackgroundColor3 = "MainColor", BackgroundTransparency = 1, LayoutOrder = x and 1 or 0, Size = UDim2.new(1, 0, 0, 21), Text = tostring(j), TextSize = 14, TextTransparency = 0.5, TextXAlignment = Enum.TextXAlignment.Left, Parent = I.Menu})
            F("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), Parent = K})
            local m
            if o.Multi then
                m = Z.Value[j]
            else
                m = Z.Value == j
            end
            O.UpdateButton = function(k)
                m = if o.Multi then Z.Value[j] else Z.Value == j
                K.BackgroundTransparency = m and 0 or 1
                K.TextTransparency = x and 0.8 or m and 0 or 0.5
            end
            if not x then
                K.MouseButton1Click:Connect(function()
                    local x = not m
                    if not(Z:GetActiveValues() == 1 and not x and not o.AllowNull) then
                        m = x
                        if o.Multi then
                            Z.Value[j] = m and true or nil
                        else
                            Z.Value = m and j or nil
                        end
                        for x, x in pairs(p) do
                            x:UpdateButton()
                        end
                    end
                    O:UpdateButton()
                    Z:Display()
                    f:UpdateDependencyBoxes()
                    f:SafeCallback(Z.Callback, Z.Value)
                    f:SafeCallback(Z.Changed, Z.Value)
                end)
            end
            O:UpdateButton()
            Z:Display()
            p[K] = O
        end
    end
    Z:RecalculateListSize(e)
end
Z.SetValue = function(e, x)
    if o.Multi then e = {}
    for K, j in x or{}, nil, nil do
        if typeof(j) ~= "boolean" then
            e[j] = true
        elseif j and(table.find(Z.Values, K)) then
            e[K] = true
        end
    end
    Z.Value = e
elseif table.find(Z.Values, x) then
    Z.Value = x
elseif not x then
    Z.Value = nil
end
Z:Display()
for e, e in pairs(p) do
    e:UpdateButton()
end
if not Z.Disabled then
    f:UpdateDependencyBoxes()
    f:SafeCallback(Z.Callback, Z.Value)
    f:SafeCallback(Z.Changed, Z.Value)
end
end
Z.SetValues = function(p, p)
    Z.Values = p
    Z:BuildDropdownList()
end
Z.SetMulti = function(p, e)
    e = not not e
    if o.Multi == e then
        return
    end
    o.Multi = e
    Z.Multi = e
    if e then
        local e, x = Z.Value, {}
        if typeof(e) == "string" then
            x[e] = true
        end
        Z.Value = x
    else
        p = nil
        if typeof(Z.Value) == "table" then
            for e, e in ipairs(Z.Values) do
                if Z.Value[e] then
                    p = e
                    break
                end
            end
        end
        Z.Value = p
    end
    Z:BuildDropdownList()
    Z:Display()
end
Z.AddValues = function(p, p)
    if typeof(p) == "table" then for e, e in pairs(p) do
        table.insert(Z.Values, e)
    end
elseif typeof(p) == "string" then
    table.insert(Z.Values, p)
else
    return
end
Z:BuildDropdownList()
end
Z.SetDisabledValues = function(p, p)
    Z.DisabledValues = p
    Z:BuildDropdownList()
end
Z.AddDisabledValues = function(p, p)
    if typeof(p) == "table" then for e, e in pairs(p) do
        table.insert(Z.DisabledValues, e)
    end
elseif typeof(p) == "string" then
    table.insert(Z.DisabledValues, p)
else
    return
end
Z:BuildDropdownList()
end
Z.SetDisabled = function(p, p)
    Z.Disabled = p
    if Z.TooltipTable then
        Z.TooltipTable.Disabled = Z.Disabled
    end
    I:Close()
    c.Active = not Z.Disabled
    Z:UpdateColors()
end
Z.SetVisible = function(p, p)
    Z.Visible = p
    g.Visible = Z.Visible
    H:Resize()
end
Z.SetText = function(p, p)
    Z.Text = p
    g.Size = UDim2.new(1, 0, 0, p and 39 or 21)
    _.Text = p or ""
    _.Visible = not not p
end
c.MouseButton1Click:Connect(function()
    if Z.Disabled then return
end
I:Toggle()
end)
if P then
    P:GetPropertyChangedSignal("Text"):Connect(Z.BuildDropdownList)
end
J = {}
if typeof(o.Default) == "string" then
    local P = table.find(Z.Values, o.Default)
    if P then
        table.insert(J, P)
    end
elseif typeof(o.Default) == "table" then
    for P, p in next, o.Default, nil do
        P = table.find(Z.Values, p)
        if P then
            table.insert(J, P)
        end
    end
elseif Z.Values[o.Default] ~= nil then
    table.insert(J, o.Default)
end
if next(J) then
    for P = 1, #J, 1 do
        local p = J[P]
        if o.Multi then
            Z.Value[Z.Values[p]] = true
        else
            Z.Value = Z.Values[p]
        end
        if not o.Multi then
            break
        end
    end
end
if typeof(Z.Tooltip) == "string" or typeof(Z.DisabledTooltip) == "string" then
    Z.TooltipTable = f:AddTooltip(Z.Tooltip, Z.DisabledTooltip, c)
    Z.TooltipTable.Disabled = Z.Disabled
end
Z:UpdateColors()
Z:Display()
Z:BuildDropdownList()
H:Resize()
Z.Holder = g
table.insert(H.Elements, Z)
Z.Default = J
Z.DefaultValues = Z.Values
z[L] = Z
return Z
end
Y.AddViewport = function(J, L, o)
    o = f:Validate(o, l.Viewport)
    local H = J
    local P, Z, p, g = H.Container, false, false
    local _, c = 0, o.Object
    if o.Clone and typeof(o.Object) == "Instance" then
        J = o.Object
        if J.Archivable then
            c = (c:Clone())
        else
            o.Object.Archivable = true
            c = c:Clone()
            o.Object.Archivable = false
        end
    end
    local e = {Object = c, Camera = not o.Camera and(Instance.new("Camera")) or o.Camera, Interactive = o.Interactive, Zoom = o.Zoom, AutoFocus = o.AutoFocus, Visible = o.Visible, Type = "Viewport"}
    assert(typeof(e.Object) == "Instance" and(e.Object:IsA("BasePart") or(e.Object:IsA("Model"))), "Instance must be a BasePart or Model.")
    assert(typeof(e.Camera) == "Instance" and(e.Camera:IsA("Camera")), "Camera must be a valid Camera instance.")
    local function c(I)
        if I:IsA("BasePart") then return I.Size
    end
    return select(2, I:GetBoundingBox())
end
local function I()
    local x = c(e.Object)
    local c = math.max(x.X, x.Y, x.Z)
    local x, K = c * 2, e.Object:GetPivot().Position
    e.Camera.CFrame = CFrame.new(K + Vector3.new(0, c / 2, x), K)
end
local c = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, o.Height), Visible = e.Visible, Parent = P})
J = F("Frame", {AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1), Parent = c})
F("UIPadding", {PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 4), Parent = J})
local o = F("ViewportFrame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = J, CurrentCamera = e.Camera, Active = e.Interactive})
o.MouseEnter:Connect(function()
    if not e.Interactive then return
end
for J, J in pairs(H.Tab.Sides) do
    J.ScrollingEnabled = false
end
end)
o.MouseLeave:Connect(function()
    if not e.Interactive then return
end
for J, J in pairs(H.Tab.Sides) do
    J.ScrollingEnabled = true
end
end)
o.InputBegan:Connect(function(J)
    if not e.Interactive then return
end
if J.UserInputType == Enum.UserInputType.MouseButton1 or J.UserInputType == Enum.UserInputType.MouseButton2 then
    Z = true
    g = J.Position
elseif J.UserInputType == Enum.UserInputType.Touch and not p then
    Z = true
    g = J.Position
end
end)
f:GiveSignal(U.InputEnded:Connect(function(J)
    if f.Unloaded then return
end
if not e.Interactive then
    return
end
local P = J.UserInputType == Enum.UserInputType.MouseButton1 or J.UserInputType == Enum.UserInputType.MouseButton2
if P then
    Z = false
else
    local P, x = J.UserInputType, Enum.UserInputType.Touch
    if P == x then
        Z = false
    end
end
end))
f:GiveSignal(U.InputChanged:Connect(function(J)
    if f.Unloaded then return
end
if not e.Interactive or not Z or p then
    return
end
if J.UserInputType == Enum.UserInputType.MouseMovement or J.UserInputType == Enum.UserInputType.Touch then
    local P = J.Position -g
    g = J.Position
    local J, g, x = e.Object:GetPivot().Position, e.Camera, CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -P.X * 0.01)
    g.CFrame = CFrame.new(J) * x * CFrame.new(- J) * g.CFrame
    x = CFrame.fromAxisAngle(g.CFrame.RightVector, -P.Y * 0.01)
    P = CFrame.new(J) * x * CFrame.new(- J) * g.CFrame
    if P.UpVector.Y > 0.1 then
        g.CFrame = P
    end
end
end))
o.InputChanged:Connect(function(J)
    if not e.Interactive or not e.Zoom then return
end
if J.UserInputType == Enum.UserInputType.MouseWheel then
    local P = J.Position.Z * 2
    local J, g, x = e.Camera.CFrame + e.Camera.CFrame.LookVector * P, pcall(function()
        return e.Object:GetPivot().Position
    end)
    if g and x then
        P = (J.Position -x).Magnitude
        if P > 1 and P < 50 then
            e.Camera.CFrame = J
        end
    else
        e.Camera.CFrame = J
    end
end
end)
f:GiveSignal(U.TouchPinch:Connect(function(J, P, g, x)
    if f.Unloaded then return
end
if not e.Interactive or not e.Zoom or not f:MouseIsOverFrame(o, J[1]) then
    return
end
if x == Enum.UserInputState.Begin then
    p, Z = true, false
    _ = (J[1] -J[2]).Magnitude
elseif x == Enum.UserInputState.Change then
    P = (J[1] -J[2]).Magnitude
    g = (P -_) * 0.1
    _ = P
    e.Camera.CFrame = e.Camera.CFrame + e.Camera.CFrame.LookVector * g
else
    local J = x == Enum.UserInputState.End or x == Enum.UserInputState.Cancel
    if J then
        p = false
    end
end
end))
e.Object.Parent = o
if e.AutoFocus then
    I()
end
e.SetObject = function(J, J, P)
    assert(J, "Object cannot be nil.")
    J = if P then(J:Clone()) else J
    if e.Object then
        e.Object:Destroy()
    end
    e.Object = J
    e.Object.Parent = o
    H:Resize()
end
e.SetHeight = function(J, J)
    assert(J > 0, "Height must be greater than 0.")
    c.Size = UDim2.new(1, 0, 0, J)
    H:Resize()
end
e.Focus = function(J)
    if not e.Object then return
end
I()
end
e.SetCamera = function(J, J)
    assert(J and typeof(J) == "Instance" and(J:IsA("Camera")), "Camera must be a valid Camera instance.")
    e.Camera = J
    o.CurrentCamera = J
end
e.SetInteractive = function(J, J)
    e.Interactive = J
    o.Active = J
end
e.SetVisible = function(J, J)
    e.Visible = J
    c.Visible = e.Visible
    H:Resize()
end
H:Resize()
e.Holder = c
table.insert(H.Elements, e)
z[L] = e
return e
end
Y.AddImage = function(J, L, o)
    o = f:Validate(o, l.Image)
    local H = J
    local P, Z = H.Container, {Image = o.Image, Color = o.Color, RectOffset = o.RectOffset, RectSize = o.RectSize, Height = o.Height, ScaleType = o.ScaleType, Transparency = o.Transparency, BackgroundTransparency = o.BackgroundTransparency, Visible = o.Visible, Type = "Image"}
    local p = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, o.Height), Visible = Z.Visible, Parent = P})
    P = F("Frame", {AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, BackgroundTransparency = Z.BackgroundTransparency, Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1), Parent = p})
    F("UIPadding", {PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 4), Parent = P})
    J = {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Image = Z.Image, ImageTransparency = Z.Transparency, ImageColor3 = Z.Color, ImageRectOffset = Z.RectOffset, ImageRectSize = Z.RectSize, ScaleType = Z.ScaleType, Parent = P}
    o = f:GetCustomIcon(J.Image)
    assert(o, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")
    J.Image = o.Url
    J.ImageRectOffset = o.ImageRectOffset
    J.ImageRectSize = o.ImageRectSize
    local o = F("ImageLabel", J)
    Z.SetHeight = function(J, J)
        assert(J > 0, "Height must be greater than 0.")
        Z.Height = J
        p.Size = UDim2.new(1, 0, 0, J)
        H:Resize()
    end
    Z.SetImage = function(J, P)
        assert(typeof(P) == "string", "Image must be a string.")
        J = f:GetCustomIcon(P)
        assert(J, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")
        P = J.Url
        Z.RectOffset = J.ImageRectOffset
        Z.RectSize = J.ImageRectSize
        o.Image = P
        Z.Image = P
    end
    Z.SetColor = function(J, J)
        assert(typeof(J) == "Color3", "Color must be a Color3 value.")
        o.ImageColor3 = J
        Z.Color = J
    end
    Z.SetRectOffset = function(J, J)
        assert(typeof(J) == "Vector2", "RectOffset must be a Vector2 value.")
        o.ImageRectOffset = J
        Z.RectOffset = J
    end
    Z.SetRectSize = function(J, J)
        assert(typeof(J) == "Vector2", "RectSize must be a Vector2 value.")
        o.ImageRectSize = J
        Z.RectSize = J
    end
    Z.SetScaleType = function(J, J)
        assert(typeof(J) == "EnumItem" and(J:IsA("ScaleType")), "ScaleType must be a valid Enum.ScaleType.")
        o.ScaleType = J
        Z.ScaleType = J
    end
    Z.SetTransparency = function(J, J)
        assert(typeof(J) == "number", "Transparency must be a number between 0 and 1.")
        assert(J >= 0 and J <= 1, "Transparency must be between 0 and 1.")
        o.ImageTransparency = J
        Z.Transparency = J
    end
    Z.SetVisible = function(J, J)
        Z.Visible = J
        p.Visible = Z.Visible
        H:Resize()
    end
    H:Resize()
    Z.Holder = p
    table.insert(H.Elements, Z)
    z[L] = Z
    return Z
end
Y.AddVideo = function(J, L, o)
    o = f:Validate(o, l.Video)
    local H = J
    local J, P = H.Container, {Video = o.Video, Looped = o.Looped, Playing = o.Playing, Volume = o.Volume, Height = o.Height, Visible = o.Visible, Type = "Video"}
    local Z = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, o.Height), Visible = P.Visible, Parent = J})
    J = F("Frame", {AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1), Parent = Z})
    F("UIPadding", {PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 4), Parent = J})
    local o = F("VideoFrame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Video = P.Video, Looped = P.Looped, Volume = P.Volume, Parent = J})
    o.Playing = P.Playing
    P.SetHeight = function(J, J)
        assert(J > 0, "Height must be greater than 0.")
        P.Height = J
        Z.Size = UDim2.new(1, 0, 0, J)
        H:Resize()
    end
    P.SetVideo = function(J, J)
        assert(typeof(J) == "string", "Video must be a string.")
        o.Video = J
        P.Video = J
    end
    P.SetLooped = function(J, J)
        assert(typeof(J) == "boolean", "Looped must be a boolean.")
        o.Looped = J
        P.Looped = J
    end
    P.SetVolume = function(J, J)
        assert(typeof(J) == "number", "Volume must be a number between 0 and 10.")
        o.Volume = J
        P.Volume = J
    end
    P.SetPlaying = function(J, J)
        assert(typeof(J) == "boolean", "Playing must be a boolean.")
        o.Playing = J
        P.Playing = J
    end
    P.Play = function(J)
        o.Playing = true
        P.Playing = true
    end
    P.Pause = function(J)
        o.Playing = false
        P.Playing = false
    end
    P.SetVisible = function(J, J)
        P.Visible = J
        Z.Visible = P.Visible
        H:Resize()
    end
    H:Resize()
    P.Holder = Z
    P.VideoFrame = o
    table.insert(H.Elements, P)
    z[L] = P
    return P
end
Y.AddUIPassthrough = function(J, L, o)
    o = f:Validate(o, l.UIPassthrough)
    local H = J
    J = H.Container
    assert(o.Instance, "Instance must be provided.")
    assert(typeof(o.Instance) == "Instance" and(o.Instance:IsA("GuiBase2d")), "Instance must inherit from GuiBase2d.")
    assert(typeof(o.Height) == "number" and o.Height > 0, "Height must be a number greater than 0.")
    local P = {Instance = o.Instance, Height = o.Height, Visible = o.Visible, Type = "UIPassthrough"}
    local Z = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, o.Height), Visible = P.Visible, Parent = J})
    P.Instance.Parent = Z
    H:Resize()
    P.SetHeight = function(J, J)
        assert(typeof(J) == "number" and J > 0, "Height must be a number greater than 0.")
        P.Height = J
        Z.Size = UDim2.new(1, 0, 0, J)
        H:Resize()
    end
    P.SetInstance = function(J, J)
        assert(J, "Instance must be provided.")
        assert(typeof(J) == "Instance" and(J:IsA("GuiBase2d")), "Instance must inherit from GuiBase2d.")
        if P.Instance then
            P.Instance.Parent = nil
        end
        P.Instance = J
        P.Instance.Parent = Z
    end
    P.SetVisible = function(J, J)
        P.Visible = J
        Z.Visible = P.Visible
        H:Resize()
    end
    P.Holder = Z
    table.insert(H.Elements, P)
    z[L] = P
    return P
end
Y.AddDependencyBox = function(J)
    local L = J
    local J, o, H = L.Container
    do
        o = F("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false, Parent = J})
        H = F("UIListLayout", {Padding = UDim.new(0, 8), Parent = o})
    end
    local J
    J = {Visible = false, Dependencies = {}, Holder = o, Container = o, Elements = {}, DependencyBoxes = {}, Resize = function(P)
        o.Size = UDim2.new(1, 0, 0, H.AbsoluteContentSize.Y / f.DPIScale)
        L:Resize()
    end, Update = function(P, Z)
        for p, g in pairs(J.Dependencies) do
            p, P = g[1], g[2]
            if p.Type == "Toggle" and p.Value ~= P then
                o.Visible = false
                J.Visible = false
                return
            elseif p.Type == "Dropdown" then
                if typeof(p.Value) == "table" then
                    if not p.Value[P] then
                        o.Visible = false
                        J.Visible = false
                        return
                    end
                elseif p.Value ~= P then
                    o.Visible = false
                    J.Visible = false
                    return
                end
            end
        end
        J.Visible = true
        o.Visible = true
        if not f.Searching then
            task.defer(function()
                J:Resize()
            end)
        elseif not Z then
            f:UpdateSearch(f.SearchText)
        end
    end
    }
    H:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if not J.Visible then return
    end
    J:Resize()
end)
J.SetupDependencies = function(H, H)
    for P, P in pairs(H) do
        assert(typeof(P) == "table", "Dependency should be a table.")
        assert(P[1] ~= nil, "Dependency is missing element.")
        assert(P[2] ~= nil, "Dependency is missing expected value.")
    end
    J.Dependencies = H
    J:Update()
end
o:GetPropertyChangedSignal("Visible"):Connect(function()
    J:Resize()
end)
setmetatable(J, s)
J.Destroy = function(H)
    for P = #J.DependencyBoxes, 1, -1 do
        H = J.DependencyBoxes[P]
        if H and H.Destroy then
            H:Destroy()
        end
    end
    J:Clear()
    for H = #L.DependencyBoxes, 1, -1 do
        if L.DependencyBoxes[H] == J then
            table.remove(L.DependencyBoxes, H)
        end
    end
    for H = #f.DependencyBoxes, 1, -1 do
        if f.DependencyBoxes[H] == J then
            table.remove(f.DependencyBoxes, H)
        end
    end
    pcall(function()
        o:Destroy()
    end)
    L:Resize()
end
table.insert(L.DependencyBoxes, J)
table.insert(f.DependencyBoxes, J)
return J
end
Y.AddDependencyGroupbox = function(J)
    local L, o, H, P = J.Tab, J.BoxHolder
    do
        H = F("Frame", {BackgroundColor3 = "BackgroundColor", Size = UDim2.fromScale(1, 0), Visible = false, Parent = o})
        F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = H})
        f:AddOutline(H)
        P = F("UIListLayout", {Padding = UDim.new(0, 8), Parent = H})
        F("UIPadding", {PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), PaddingTop = UDim.new(0, 7), Parent = H})
    end
    local J
    J = {Visible = false, Dependencies = {}, BoxHolder = o, Holder = H, Container = H, Tab = L, Elements = {}, DependencyBoxes = {}, Resize = function(o)
        H.Size = UDim2.new(1, 0, 0, P.AbsoluteContentSize.Y / f.DPIScale + 18)
    end, Update = function(o, P)
        for Z, p in pairs(J.Dependencies) do
            o, Z = p[1], p[2]
            if o.Type == "Toggle" and o.Value ~= Z then
                H.Visible = false
                J.Visible = false
                return
            elseif o.Type == "Dropdown" then
                if typeof(o.Value) == "table" then
                    if not o.Value[Z] then
                        H.Visible = false
                        J.Visible = false
                        return
                    end
                elseif o.Value ~= Z then
                    H.Visible = false
                    J.Visible = false
                    return
                end
            end
        end
        J.Visible = true
        if not f.Searching then
            H.Visible = true
            J:Resize()
        elseif not P then
            f:UpdateSearch(f.SearchText)
        end
    end, SetupDependencies = function(o, o)
        for H, H in pairs(o) do
            assert(typeof(H) == "table", "Dependency should be a table.")
            assert(H[1] ~= nil, "Dependency is missing element.")
            assert(H[2] ~= nil, "Dependency is missing expected value.")
        end
        J.Dependencies = o
        J:Update()
    end
    }
    setmetatable(J, s)
    table.insert(L.DependencyGroupboxes, J)
    table.insert(f.DependencyBoxes, J)
    return J
end
s.__index = Y
s.__namecall = function(J, J, ...)
    return Y[J](...)
end
f.BaseGroupbox = s
end
f.SetFont = function(J, L)
    J = typeof(L)
    f.Scheme.Font = if J == "EnumItem" then(Font.fromEnum(L)) else L
    f:UpdateColorsUsingRegistry()
end
f.SetNotifySide = function(J, J)
    f.NotifySide = J
end
f.Notify = function(J, ...)
    local L, o = {}, select(1, ...)
    if typeof(o) == "table" then
        L.Title = tostring(o.Title)
        L.Description = tostring(o.Description)
        L.Time = o.Time or 5
        L.SoundId = o.SoundId
        L.Steps = o.Steps
        L.Persist = o.Persist
    else
        L.Description = tostring(o)
        L.Time = select(2, ...) or 5
        L.SoundId = select(3, ...)
    end
    L.Destroyed = false
    local H, P = false
    if typeof(L.Time) == "Instance" then
        P = L.Time.Destroying:Connect(function()
            H = true
            P:Disconnect()
            P = nil
        end)
    end
    local Y = F("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), Visible = false, Parent = D})
    local Z = F("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = "MainColor", Position = f.NotifySide:lower() == "left" and(UDim2.new(- 1, -8, 0, -2)) or(UDim2.new(1, 8, 0, -2)), Size = UDim2.fromScale(1, 1), ZIndex = 5, Parent = Y})
    F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = Z})
    F("UIListLayout", {Padding = UDim.new(0, 4), Parent = Z})
    F("UIPadding", {PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), Parent = Z})
    f:AddOutline(Z)
    local p, g
    local _, c, e = 0, 0
    if L.Title then
        p = F("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Size = UDim2.fromScale(0, 0), Text = L.Title, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = Z})
    end
    if L.Description then
        g = F("TextLabel", {AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Size = UDim2.fromScale(0, 0), Text = L.Description, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = Z})
    end
    L.Resize = function(I)
        if p then local I, x = f:GetTextBounds(p.Text, p.FontFace, p.TextSize, D.AbsoluteSize.X / f.DPIScale -24)
        p.Size = UDim2.fromOffset(0, x)
        _ = I
    end
    if g then
        local I, x = f:GetTextBounds(g.Text, g.FontFace, g.TextSize, D.AbsoluteSize.X / f.DPIScale -24)
        g.Size = UDim2.fromOffset(0, x)
        c = I
    end
    Y.Size = UDim2.fromOffset(math.max(_, c) + 24, 0)
end
L.ChangeTitle = function(_, _)
    if p then L.Title = tostring(_)
    p.Text = L.Title
    L:Resize()
end
end
L.ChangeDescription = function(p, p)
    if g then L.Description = tostring(p)
    g.Text = L.Description
    L:Resize()
end
end
L.ChangeStep = function(p, p)
    if e and L.Steps then p = math.clamp(p or 0, 0, L.Steps)
    e.Size = UDim2.fromScale(p / L.Steps, 1)
end
end
L.Destroy = function(p)
    L.Destroyed = true
    if typeof(L.Time) == "Instance" then
        pcall(L.Time.Destroy, L.Time)
    end
    if P then
        P:Disconnect()
    end
    B:Create(Z, f.NotifyTweenInfo, {Position = f.NotifySide:lower() == "left" and(UDim2.new(- 1, -8, 0, -2)) or(UDim2.new(1, 8, 0, -2))}):Play()
    task.delay(f.NotifyTweenInfo.Time, function()
        f.Notifications[Y] = nil
        Y:Destroy()
    end)
end
L:Resize()
o = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 7), Visible = L.Persist ~= true and typeof(L.Time) ~= "Instance" or typeof(L.Steps) == "number", Parent = Z})
J = F("Frame", {BackgroundColor3 = "BackgroundColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromOffset(0, 3), Size = UDim2.new(1, 0, 0, 2), Parent = o})
e = F("Frame", {BackgroundColor3 = "AccentColor", Size = UDim2.fromScale(1, 1), Parent = J})
if typeof(L.Time) == "Instance" then
    e.Size = UDim2.fromScale(0, 1)
end
if L.SoundId then
    o = L.SoundId
    F("Sound", {SoundId = if typeof(o) == "number" then(string.format("rbxassetid://%d", o)) else o, Volume = 3, PlayOnRemove = true, Parent = W}):Destroy()
end
f.Notifications[Y] = L
Y.Visible = true
B:Create(Z, f.NotifyTweenInfo, {Position = UDim2.fromOffset(0, 0)}):Play()
task.delay(f.NotifyTweenInfo.Time, function()
    if L.Persist then return
elseif typeof(L.Time) == "Instance" then
    repeat
        task.wait()
        until H or L.Destroyed
    else
        B:Create(e, TweenInfo.new(L.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = UDim2.fromScale(0, 1)}):Play()
        task.wait(L.Time)
    end
    if not L.Destroyed then
        L:Destroy()
    end
end)
return L
end
f.CreateWindow = function(J, W)
    W = f:Validate(W, l.Window)
    J = workspace.CurrentCamera.ViewportSize
    if q:IsStudio() and J.X <= 5 and J.Y <= 5 then
        repeat
            J = workspace.CurrentCamera.ViewportSize
            task.wait()
            until J.X > 5 and J.Y > 5
        end
        local L, o = J.X -64, J.Y -64
        f.OriginalMinSize = Vector2.new(math.min(f.OriginalMinSize.X, L), math.min(f.OriginalMinSize.Y, o))
        f.MinSize = f.OriginalMinSize
        W.Size = UDim2.fromOffset(math.clamp(W.Size.X.Offset, f.MinSize.X, L), math.clamp(W.Size.Y.Offset, f.MinSize.Y, o))
        if typeof(W.Font) == "EnumItem" then
            W.Font = Font.fromEnum(W.Font)
        end
        W.CornerRadius = math.min(W.CornerRadius, 20)
        if W.Compact ~= nil then
            W.SidebarCompacted = W.Compact
        end
        if W.SidebarMinWidth ~= nil then
            W.MinSidebarWidth = W.SidebarMinWidth
        end
        W.MinSidebarWidth = math.max(64, W.MinSidebarWidth)
        W.SidebarCompactWidth = math.max(48, W.SidebarCompactWidth)
        W.SidebarCollapseThreshold = math.clamp(W.SidebarCollapseThreshold, 0.1, 0.9)
        W.CompactWidthActivation = math.max(48, W.CompactWidthActivation)
        f.CornerRadius = W.CornerRadius
        f:SetNotifySide(W.NotifySide)
        f.ShowCustomCursor = W.ShowCustomCursor
        f.Scheme.Font = W.Font
        f.ToggleKeybind = W.ToggleKeybind
        f.GlobalSearch = W.GlobalSearch
        local H, P, Y, l, Z, p, g, _, c, e, I, x, D, K, j, O, m = W.SearchbarSize == UDim2.fromScale(1, 1)
        local k, n, E, S = false, false, {}
        local G, y, i, T = 1, {}, math.ceil(W.Size.X.Offset * 0.3), W.SidebarCompacted
        local MJ = i
        do
            f.KeybindFrame, f.KeybindContainer = f:AddDraggableMenu("Keybinds")
            f.KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
            f.KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
            f.KeybindFrame.Visible = false
            P = F("TextButton", {BackgroundColor3 = function()
                return f:GetBetterColor(f.Scheme.BackgroundColor, -1)
            end, Name = "Main", Text = "", Position = W.Position, Size = W.Size, Visible = false, ClipsDescendants = true, BackgroundTransparency = W.GlassType == "Full" and 0.3 or(W.GlassType == "TopOnly" and 1 or 0), Parent = b})
            f._customBg = F("ImageLabel", {BackgroundTransparency = 1, Image = "", ImageTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, ZIndex = 0, Visible = false, Parent = P})
            F("UICorner", {CornerRadius = UDim.new(0, f.CornerRadius), Parent = f._customBg})
            o = F("UIStroke", {Color = function()
                return f:GetBetterColor(f.Scheme.OutlineColor, 2)
            end, Transparency = 0.5, Thickness = 1, Parent = P})
            f.Registry[o].Color = function()
                return f:GetBetterColor(f.Scheme.OutlineColor, 2)
            end
            if W.GlassType == "Full" then
                S = F("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9, Thickness = 1, Parent = P})
            end
            j = F("Frame", {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, Size = UDim2.new(2, 0, 2, 0), Position = UDim2.fromScale(- 0.5, -0.5), ZIndex = -1, Visible = false, Parent = b})
            O = F("BlurEffect", {Size = 0, Parent = game:GetService("Lighting")})
            if W.EnableSnowfall then
                k = true
                m = F("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 10, Visible = W.AutoShow, Parent = b})
                n = W.AutoShow
                local o, bJ = game:GetService("RunService"), {}
                for JJ = 1, 100, 1 do
                    local NJ, AJ, qJ, WJ = math.random(3, 6), math.random(30, 60) / 100, math.random(0, 100) / 100, math.random(- 50, -5) / 100
                    L = F("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = AJ, Size = UDim2.fromOffset(NJ, NJ), Position = UDim2.fromScale(qJ, WJ), Rotation = math.random(0, 360), Parent = m})
                    F("UICorner", {CornerRadius = UDim.new(1, 0), Parent = L})
                    bJ[JJ] = {frame = L, velY = 0.012, velX = math.random(- 3, 3) / 1000, rotSpeed = math.random(- 60, 60) / 100, delay = math.random(0, 150) / 100, elapsed = 0, posY = WJ, posX = qJ, rot = math.random(0, 360)}
                end
                f:GiveSignal((o.Heartbeat:Connect(function(o)
                    if not n then return
                end
                local JJ = o * 60
                for NJ, NJ in pairs(bJ) do
                    if NJ.elapsed < NJ.delay then
                        NJ.elapsed = NJ.elapsed + o
                    else
                        NJ.posY = NJ.posY + NJ.velY * G * JJ
                        NJ.posX = NJ.posX + NJ.velX * JJ
                        NJ.rot = NJ.rot + NJ.rotSpeed * JJ
                        if NJ.posY > 1.2 then
                            NJ.posY = math.random(- 30, -5) / 100
                            NJ.posX = math.random(0, 100) / 100
                        end
                        if NJ.posX < -0.05 then
                            NJ.posX = 1.05
                        end
                        if NJ.posX > 1.05 then
                            NJ.posX = -0.05
                        end
                        NJ.frame.Position = UDim2.fromScale(NJ.posX, NJ.posY)
                        NJ.frame.Rotation = NJ.rot
                    end
                end
            end)))
        end
        if W.EnableFadeIn then
            P.Size = UDim2.fromOffset(W.Size.X.Offset * 0.95, W.Size.Y.Offset * 0.95)
            P.BackgroundTransparency = 1
            task.spawn(function()
                task.wait(0.05)
                local o = W.GlassType == "Full" and 0.3 or(W.GlassType == "TopOnly" and 1 or 0)
                B:Create(P, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = W.Size, BackgroundTransparency = o}):Play()
            end)
        end
        F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = P})
        table.insert(f.Scales, F("UIScale", {Parent = P}))
        f:AddOutline(P)
        f:MakeLine(P, {Position = UDim2.fromOffset(0, 48), Size = UDim2.new(1, 0, 0, 1)})
        Y = F("Frame", {BackgroundColor3 = "OutlineColor", Position = UDim2.fromOffset(i, 0), Size = UDim2.new(0, 1, 1, -21), Parent = P})
        if W.BackgroundImage then
            F("ImageLabel", {Image = W.BackgroundImage, Position = UDim2.fromScale(0, 0), Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Stretch, ZIndex = 999, BackgroundTransparency = 1, ImageTransparency = 0.75, Parent = P})
        end
        if W.Center then
            P.AnchorPoint = Vector2.new(0.5, 0.5)
            P.Position = UDim2.fromScale(0.5, 0.5)
        end
        J = F("Frame", {Name = "TopBar", BackgroundTransparency = W.GlassType == "TopOnly" and 0.3 or 1, BackgroundColor3 = function()
            return f:GetBetterColor(f.Scheme.BackgroundColor, -1)
        end, Size = UDim2.new(1, 0, 0, 48), Parent = P})
        if W.GlassType == "TopOnly" then
            F("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9, Thickness = 1, Parent = J})
            F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = J})
        end
        f:MakeDraggable(P, J, false, true)
        l = F("Frame", {BackgroundTransparency = 1, ClipsDescendants = true, Size = UDim2.new(0, i, 1, 0), Parent = J})
        if W.Icon then
            p = F("ImageLabel", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0), Image = tonumber(W.Icon) and(string.format("rbxassetid://%d", W.Icon)) or W.Icon, Size = W.IconSize, Parent = l})
        else
            p = F("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.5), Size = W.IconSize, Text = W.Title:sub(1, 1), TextScaled = true, Visible = false, Parent = l})
        end
        Z = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = W.Title, TextSize = 20, TextXAlignment = Enum.TextXAlignment.Center, Parent = l})
        g = F("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, -49, 0.5, 0), Size = UDim2.new(1, -i -57 -1, 1, -16), Parent = J})
        F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), Parent = g})
        c = F("Frame", {Size = UDim2.fromScale(W.DisableSearch and 1 or 0.5, 1), Visible = false, BackgroundTransparency = 1, Parent = g})
        F("UIFlexItem", {FlexMode = Enum.UIFlexMode.Grow, Parent = c})
        F("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = c})
        F("UIPadding", {PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), Parent = c})
        e = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = "", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = c})
        I = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = "", TextWrapped = true, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 0.5, Parent = c})
        _ = F("TextBox", {BackgroundColor3 = "MainColor", PlaceholderText = "Search", Size = W.SearchbarSize, TextScaled = true, Visible = not(W.DisableSearch or false), Parent = g})
        F("UIFlexItem", {FlexMode = Enum.UIFlexMode.Shrink, Parent = _})
        F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = _})
        F("UIPadding", {PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), Parent = _})
        F("UIStroke", {Color = "OutlineColor", Parent = _})
        local o = f:GetIcon("search")
        if o then
            F("ImageLabel", {Image = o.Url, ImageColor3 = "FontColor", ImageRectOffset = o.ImageRectOffset, ImageRectSize = o.ImageRectSize, ImageTransparency = 0.5, Size = UDim2.fromScale(1, 1), SizeConstraint = Enum.SizeConstraint.RelativeYY, Parent = _})
        end
        if V then
            F("ImageLabel", {AnchorPoint = Vector2.new(1, 0.5), Image = V.Url, ImageColor3 = "OutlineColor", ImageRectOffset = V.ImageRectOffset, ImageRectSize = V.ImageRectSize, Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(28, 28), SizeConstraint = Enum.SizeConstraint.RelativeYY, Parent = J})
        end
        o = F("Frame", {AnchorPoint = Vector2.new(0, 1), BackgroundColor3 = function()
            return f:GetBetterColor(f.Scheme.BackgroundColor, 4)
        end, Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 20), Parent = P})
        F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = o})
        F("Frame", {BackgroundColor3 = function()
            return f:GetBetterColor(f.Scheme.BackgroundColor, 4)
        end, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, W.CornerRadius), Parent = o})
        f:MakeLine(P, {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -20), Size = UDim2.new(1, 0, 0, 1)})
        o = F("Frame", {AnchorPoint = Vector2.new(0, 1), BackgroundTransparency = 1, Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, 20), Parent = P})
        F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = W.Footer, TextSize = 14, TextTransparency = 0.5, Parent = o})
        if W.Resizable then
            x = F("TextButton", {AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1, Position = UDim2.new(1, -W.CornerRadius / 4, 0, 0), Size = UDim2.fromScale(1, 1), SizeConstraint = Enum.SizeConstraint.RelativeYY, Text = "", Parent = o})
            f:MakeResizable(P, x, function()
                W.Size = P.Size
                f._persistentWindowSize = P.Size
                for o, o in pairs(f.Tabs) do
                    o:Resize(true)
                end
            end)
            f._persistentWindowSize = W.Size
        end
        F("ImageLabel", {Image = v and v.Url or "", ImageColor3 = "FontColor", ImageRectOffset = v and v.ImageRectOffset or Vector2.zero, ImageRectSize = v and v.ImageRectSize or Vector2.zero, ImageTransparency = 0.5, Position = UDim2.fromOffset(2, 2), Size = UDim2.new(1, -4, 1, -4), Parent = x})
        D = F("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundColor3 = "BackgroundColor", CanvasSize = UDim2.fromScale(0, 0), ClipsDescendants = true, Position = UDim2.fromOffset(0, 49), ScrollBarThickness = 0, Size = UDim2.new(0, i, 1, -70), Parent = P})
        table.insert(y, D)
        F("UIListLayout", {Parent = D})
        K = F("Frame", {AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = function()
            return f:GetBetterColor(f.Scheme.BackgroundColor, 1)
        end, Name = "Container", Position = UDim2.new(1, 0, 0, 49), Size = UDim2.new(1, -i -1, 1, -70), Parent = P})
        table.insert(y, K)
        F("UIPadding", {PaddingBottom = UDim.new(0, 0), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 0), Parent = K})
    end
    local o = {Frame = P}
    f.Window = o
    o.ChangeTitle = function(v, v)
        assert(typeof(v) == "string", "Expected string for title got: " .. typeof(v))
        Z.Text = v
        W.Title = v
    end
    local function v()
        T = o:GetSidebarWidth() == W.SidebarCompactWidth
        local x = W
        if x.DisableCompactingSnap then
            T = o:GetSidebarWidth() <= W.CompactWidthActivation
        end
        Z.Visible = not T
        if not W.Icon then
            p.Visible = T
        end
        for p, p in pairs(f.TabButtons) do
            if p.Icon then
                p.Label.Visible = not T
                p.Padding.PaddingBottom = UDim.new(0, T and 6 or 11)
                p.Padding.PaddingLeft = UDim.new(0, T and 6 or 12)
                p.Padding.PaddingRight = UDim.new(0, T and 6 or 12)
                p.Padding.PaddingTop = UDim.new(0, T and 6 or 11)
                p.Icon.SizeConstraint = T and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
            end
        end
    end
    o.IsSidebarCompacted = function(p)
        return T
    end
    o.SetCompact = function(p, p)
        o:SetSidebarWidth(p and W.SidebarCompactWidth or MJ)
    end
    o.GetSidebarWidth = function(p)
        return D.Size.X.Offset
    end
    o.SetSidebarWidth = function(p, x)
        x = math.clamp(x, 48, P.Size.X.Offset -W.MinContainerWidth -1)
        Y.Position = UDim2.fromOffset(x, 0)
        l.Size = UDim2.new(0, x, 1, 0)
        g.Size = UDim2.new(1, -x -57 -1, 1, -16)
        D.Size = UDim2.new(0, x, 1, -70 -(o._cardReserve or 0))
        K.Size = UDim2.new(1, -x -1, 1, -70)
        if W.EnableCompacting then
            v()
        end
        p = T
        if not p then
            MJ = x
        end
        if o._onSidebarWidth then
            o._onSidebarWidth(x)
        end
    end
    o.ShowTabInfo = function(v, v, p)
        e.Text = v
        I.Text = p
        if H then
            _.Size = UDim2.fromScale(0.5, 1)
        end
        c.Visible = true
    end
    o.HideTabInfo = function(v)
        c.Visible = false
        if H then
            _.Size = UDim2.fromScale(1, 1)
        end
    end
    local H, v, p, g, c
    o.SetPlayerCard = function(e, e)
        e = e or{}
        local I, x, V = tonumber(e.UserId) or A.LocalPlayer and A.LocalPlayer.UserId or 1, e.Username or A.LocalPlayer and A.LocalPlayer.DisplayName or A.LocalPlayer and A.LocalPlayer.Name or "Player", e.Status or ""
        if not H then
            H = F("Frame", {BackgroundColor3 = "MainColor", Position = UDim2.new(0, 8, 1, -70), Size = UDim2.new(0, 100, 0, 44), Parent = P})
            F("UICorner", {CornerRadius = UDim.new(0, 6), Parent = H})
            F("UIStroke", {Color = "OutlineColor", Transparency = 0.4, Parent = H})
            v = F("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = "OutlineColor", Position = UDim2.new(0, 22, 0.5, 0), Size = UDim2.fromOffset(32, 32), Parent = H})
            F("UICorner", {CornerRadius = UDim.new(1, 0), Parent = v})
            p = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 46, 0, 6), Size = UDim2.new(1, -52, 0, 16), Text = "", TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = H})
            g = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 46, 0, 23), Size = UDim2.new(1, -52, 0, 14), Text = "", TextColor3 = Color3.new(1, 1, 1), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = H})
            c = F("UIGradient", {Parent = g})
            local MJ, bJ = 0
            bJ = q.RenderStepped:Connect(function(JJ)
                if f.Unloaded or not c.Parent then
                if bJ then
                    bJ:Disconnect()
                end
                return
            end
            MJ = (MJ + JJ * 1.5) % 6.2831853
            c.Offset = Vector2.new(math.sin(MJ), 0)
        end)
        o._cardReserve = 0
        function o._onSidebarWidth(MJ)
            local bJ = math.max(32, MJ -16)
            H.Size = UDim2.new(0, bJ, 0, 44)
            local H = 26 + 6 * math.clamp((MJ -54) / 120, 0, 1)
            v.Size = UDim2.fromOffset(H, H)
            v.Position = UDim2.new(0, math.min(bJ / 2, 8 + H / 2), 0.5, 0)
            H = math.clamp((MJ -100) / 60, 0, 1)
            p.TextTransparency = 1 -H
            g.TextTransparency = g.Text ~= "" and 1 -H or 1
        end
        o:SetSidebarWidth(o:GetSidebarWidth())
    end
    v.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", I)
    p.Text = x
    g.Text = V
    c.Color = e.StatusGradient or(ColorSequence.new({ColorSequenceKeypoint.new(0, f.Scheme.AccentColor), ColorSequenceKeypoint.new(1, f.Scheme.FontColor)}))
    if o._onSidebarWidth then
        o._onSidebarWidth(o:GetSidebarWidth())
    end
end
o.AddTab = function(H, ...)
    local v, p, g
    if select("#", ...) == 1 and typeof(...) == "table" then
        H = select(1, ...)
        v = H.Name or "Tab"
        g, p = H.Icon, H.Description
    else
        v = select(1, ...)
        g, p = select(2, ...), select(3, ...)
    end
    local c, e, I, x, V, MJ
    g = f:GetCustomIcon(g)
    do
        c = F("TextButton", {BackgroundColor3 = "MainColor", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Text = "", Parent = D})
        F("UIGradient", {Color = ColorSequence.new({ColorSequenceKeypoint.new(0, f.Scheme.AccentColor), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(math.clamp(f.Scheme.AccentColor.R * 255 + 30, 0, 255), math.clamp(f.Scheme.AccentColor.G * 255 + 30, 0, 255), math.clamp(f.Scheme.AccentColor.B * 255 + 30, 0, 255))), ColorSequenceKeypoint.new(1, f.Scheme.AccentColor)}), Rotation = 45, Enabled = false, Parent = c})
        H = F("UIPadding", {PaddingBottom = UDim.new(0, T and 6 or 11), PaddingLeft = UDim.new(0, T and 6 or 12), PaddingRight = UDim.new(0, T and 6 or 12), PaddingTop = UDim.new(0, T and 6 or 11), Parent = c})
        e = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -30, 1, 0), Text = v, TextSize = 16, TextTransparency = 0.5, TextXAlignment = Enum.TextXAlignment.Left, Visible = not T, Parent = c})
        if g then
            I = F("ImageLabel", {Image = g.Url, ImageColor3 = g.Custom and "WhiteColor" or "AccentColor", ImageRectOffset = g.ImageRectOffset, ImageRectSize = g.ImageRectSize, ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(1, 1), SizeConstraint = T and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY, Parent = c})
        end
        table.insert(f.TabButtons, {Label = e, Padding = H, Icon = I})
        x = F("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(0, 0), Visible = false, Parent = K})
        V = F("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, CanvasSize = UDim2.fromScale(0, 0), ScrollBarImageTransparency = 1, ScrollBarThickness = 0, Size = UDim2.new(0.5, -3, 1, 0), Parent = x})
        F("UIListLayout", {Padding = UDim.new(0, 2), Parent = V})
        F("UIPadding", {PaddingBottom = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2), PaddingTop = UDim.new(0, 2), Parent = V})
        F("Frame", {BackgroundTransparency = 1, LayoutOrder = -1, Parent = V})
        F("Frame", {BackgroundTransparency = 1, LayoutOrder = 1, Parent = V})
        MJ = F("ScrollingFrame", {AnchorPoint = Vector2.new(1, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, CanvasSize = UDim2.fromScale(0, 0), Position = UDim2.fromScale(1, 0), ScrollBarImageTransparency = 1, ScrollBarThickness = 0, Size = UDim2.new(0.5, -3, 1, 0), Parent = x})
        F("UIListLayout", {Padding = UDim.new(0, 2), Parent = MJ})
        F("UIPadding", {PaddingBottom = UDim.new(0, 2), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2), PaddingTop = UDim.new(0, 2), Parent = MJ})
        F("Frame", {BackgroundTransparency = 1, LayoutOrder = -1, Parent = MJ})
        F("Frame", {BackgroundTransparency = 1, LayoutOrder = 1, Parent = MJ})
    end
    local H = F("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 7), Size = UDim2.fromScale(1, 0), Visible = false, Parent = x})
    local g, bJ, JJ, NJ, AJ, qJ, WJ
    do
        g = F("Frame", {BackgroundColor3 = "BackgroundColor", Position = UDim2.fromOffset(2, 0), Size = UDim2.new(1, -5, 0, 0), Parent = H})
        F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = g})
        bJ, JJ = f:AddOutline(g)
        NJ = F("ScrollingFrame", {BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3, ScrollingDirection = Enum.ScrollingDirection.Y, Parent = g})
        F("UIPadding", {PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingTop = UDim.new(0, 4), Parent = NJ})
        AJ = F("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -4, 0, 14), Text = "", TextColor3 = Color3.fromRGB(255, 50, 50), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = NJ})
        qJ = F("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Color = Color3.fromRGB(169, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter, Parent = AJ})
        WJ = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 16), Size = UDim2.new(1, -4, 0, 0), Text = "", TextSize = 14, TextWrapped = true, Parent = NJ, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top})
        F("UIStroke", {ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Color = "DarkColor", LineJoinMode = Enum.LineJoinMode.Miter, Parent = WJ})
    end
    local UJ
    UJ = {Groupboxes = {}, Tabboxes = {}, DependencyGroupboxes = {}, Sides = {V, MJ}, WarningBox = {IsNormal = false, LockSize = false, Visible = false, Title = "WARNING", Text = ""}, UpdateWarningBox = function(LJ, LJ)
        if typeof(LJ.IsNormal) == "boolean" then UJ.WarningBox.IsNormal = LJ.IsNormal
    end
    if typeof(LJ.LockSize) == "boolean" then
        UJ.WarningBox.LockSize = LJ.LockSize
    end
    if typeof(LJ.Visible) == "boolean" then
        UJ.WarningBox.Visible = LJ.Visible
    end
    if typeof(LJ.Title) == "string" then
        UJ.WarningBox.Title = LJ.Title
    end
    if typeof(LJ.Text) == "string" then
        UJ.WarningBox.Text = LJ.Text
    end
    H.Visible = UJ.WarningBox.Visible
    AJ.Text = UJ.WarningBox.Title
    WJ.Text = UJ.WarningBox.Text
    UJ:Resize(true)
    g.BackgroundColor3 = UJ.WarningBox.IsNormal == true and f.Scheme.BackgroundColor or(Color3.fromRGB(127, 0, 0))
    JJ.Color = UJ.WarningBox.IsNormal == true and f.Scheme.DarkColor or(Color3.fromRGB(85, 0, 0))
    bJ.Color = UJ.WarningBox.IsNormal == true and f.Scheme.OutlineColor or(Color3.fromRGB(255, 50, 50))
    AJ.TextColor3 = UJ.WarningBox.IsNormal == true and f.Scheme.FontColor or(Color3.fromRGB(255, 50, 50))
    qJ.Color = UJ.WarningBox.IsNormal == true and f.Scheme.OutlineColor or(Color3.fromRGB(169, 0, 0))
    if not f.Registry[g] then
        f:AddToRegistry(g, {})
    end
    if not f.Registry[JJ] then
        f:AddToRegistry(JJ, {})
    end
    if not f.Registry[bJ] then
        f:AddToRegistry(bJ, {})
    end
    if not f.Registry[AJ] then
        f:AddToRegistry(AJ, {})
    end
    if not f.Registry[qJ] then
        f:AddToRegistry(qJ, {})
    end
    f.Registry[g].BackgroundColor3 = function()
        return UJ.WarningBox.IsNormal == true and f.Scheme.BackgroundColor or(Color3.fromRGB(127, 0, 0))
    end
    f.Registry[JJ].Color = function()
        return UJ.WarningBox.IsNormal == true and f.Scheme.DarkColor or(Color3.fromRGB(85, 0, 0))
    end
    f.Registry[bJ].Color = function()
        return UJ.WarningBox.IsNormal == true and f.Scheme.OutlineColor or(Color3.fromRGB(255, 50, 50))
    end
    f.Registry[AJ].TextColor3 = function()
        return UJ.WarningBox.IsNormal == true and f.Scheme.FontColor or(Color3.fromRGB(255, 50, 50))
    end
    f.Registry[qJ].Color = function()
        return UJ.WarningBox.IsNormal == true and f.Scheme.OutlineColor or(Color3.fromRGB(169, 0, 0))
    end
end, RefreshSides = function(bJ)
    bJ = H.Visible and g.Size.Y.Offset + 8 or 0
    for H, H in pairs(UJ.Sides) do
        H.Position = UDim2.new(H.Position.X.Scale, 0, 0, bJ)
        H.Size = UDim2.new(0.5, -3, 1, -bJ)
    end
end, Resize = function(H, bJ)
    if bJ then local bJ, JJ, JJ = math.floor(x.AbsoluteSize.Y / 3.25), f:GetTextBounds(WJ.Text, f.Scheme.Font, WJ.TextSize, WJ.AbsoluteSize.X)
    H = 24 + JJ
    if UJ.WarningBox.LockSize == true and H >= bJ then
        NJ.CanvasSize = UDim2.fromOffset(0, H)
        H = bJ
    else
        NJ.CanvasSize = UDim2.fromOffset(0, 0)
    end
    WJ.Size = UDim2.new(1, -4, 0, JJ)
    g.Size = UDim2.new(1, -5, 0, H + 4)
end
UJ:RefreshSides()
end, AddGroupbox = function(H, g)
    H = F("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), Parent = g.Side == 1 and V or MJ})
    F("UIListLayout", {Padding = UDim.new(0, 6), Parent = H})
    F("UIPadding", {PaddingBottom = UDim.new(0, 4), PaddingTop = UDim.new(0, 4), Parent = H})
    local bJ, JJ, NJ
    do
        bJ = F("Frame", {BackgroundColor3 = "BackgroundColor", Size = UDim2.fromScale(1, 0), Parent = H})
        F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = bJ})
        f:AddOutline(bJ)
        f:MakeLine(bJ, {Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 0, 1)})
        local AJ = f:GetCustomIcon(g.IconName)
        if AJ then
            F("ImageLabel", {Image = AJ.Url, ImageColor3 = AJ.Custom and "WhiteColor" or "AccentColor", ImageRectOffset = AJ.ImageRectOffset, ImageRectSize = AJ.ImageRectSize, Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(22, 22), Parent = bJ})
        end
        local qJ = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(AJ and 24 or 0, 0), Size = UDim2.new(1, 0, 0, 38), Text = g.Name, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = bJ})
        F("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = qJ})
        NJ = F("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 39), Size = UDim2.new(1, 0, 1, -39), Parent = bJ})
        JJ = F("UIListLayout", {Padding = UDim.new(0, 10), Parent = NJ})
        F("UIPadding", {PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), Parent = NJ})
    end
    local AJ = {BoxHolder = H, Holder = bJ, Container = NJ, Tab = UJ, DependencyBoxes = {}, Elements = {}, Resize = function(H)
        bJ.Size = UDim2.new(1, 0, 0, JJ.AbsoluteContentSize.Y / f.DPIScale + 59)
    end
    }
    setmetatable(AJ, s)
    AJ:Resize()
    UJ.Groupboxes[g.Name] = AJ
    return AJ
end, AddLeftGroupbox = function(H, H, g)
    return UJ:AddGroupbox({Side = 1, Name = H, IconName = g})
end, AddRightGroupbox = function(H, H, g)
    return UJ:AddGroupbox({Side = 2, Name = H, IconName = g})
end, AddTabbox = function(H, g)
    H = F("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0), Parent = g.Side == 1 and V or MJ})
    F("UIListLayout", {Padding = UDim.new(0, 6), Parent = H})
    F("UIPadding", {PaddingBottom = UDim.new(0, 4), PaddingTop = UDim.new(0, 4), Parent = H})
    local V, MJ
    do
        V = F("Frame", {BackgroundColor3 = "BackgroundColor", Size = UDim2.fromScale(1, 0), Parent = H})
        F("UICorner", {CornerRadius = UDim.new(0, W.CornerRadius), Parent = V})
        f:AddOutline(V)
        MJ = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34), Parent = V})
        F("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalFlex = Enum.UIFlexAlignment.Fill, Parent = MJ})
    end
    local bJ
    bJ = {ActiveTab = nil, BoxHolder = H, Holder = V, Tabs = {}, AddTab = function(H, H, JJ)
        local NJ = F("TextButton", {BackgroundColor3 = "MainColor", BackgroundTransparency = 0, Size = UDim2.fromOffset(0, 34), Text = H, TextSize = 15, TextTransparency = JJ and 0.8 or 0.5, Parent = MJ})
        local MJ, AJ = f:MakeLine(NJ, {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 1), Size = UDim2.new(1, 0, 0, 1)}), F("Frame", {BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 35), Size = UDim2.new(1, 0, 1, -35), Visible = false, Parent = V})
        local qJ = F("UIListLayout", {Padding = UDim.new(0, 8), Parent = AJ})
        F("UIPadding", {PaddingBottom = UDim.new(0, 7), PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), PaddingTop = UDim.new(0, 7), Parent = AJ})
        local WJ
        WJ = {ButtonHolder = NJ, Container = AJ, Tab = UJ, Elements = {}, DependencyBoxes = {}, Show = function(LJ)
            if bJ.ActiveTab then bJ.ActiveTab:Hide()
        end
        NJ.BackgroundTransparency = 1
        NJ.TextTransparency = 0
        MJ.Visible = false
        AJ.Visible = true
        bJ.ActiveTab = WJ
        WJ:Resize()
    end, Hide = function(LJ)
        NJ.BackgroundTransparency = 0
        NJ.TextTransparency = 0.5
        MJ.Visible = true
        AJ.Visible = false
        bJ.ActiveTab = nil
    end, Resize = function(MJ)
        if bJ.ActiveTab ~= WJ then return
    end
    V.Size = UDim2.new(1, 0, 0, qJ.AbsoluteContentSize.Y / f.DPIScale + 49)
end
}
if JJ then
    WJ.Disabled = true
end
if not bJ.ActiveTab and not JJ then
    WJ:Show()
end
NJ.MouseButton1Click:Connect(function()
    if WJ.Disabled then return
end
WJ:Show()
end)
setmetatable(WJ, s)
bJ.Tabs[H] = WJ
return WJ
end
}
if g.Name then
    UJ.Tabboxes[g.Name] = bJ
else
    table.insert(UJ.Tabboxes, bJ)
end
return bJ
end, AddLeftTabbox = function(H, H)
    return UJ:AddTabbox({Side = 1, Name = H})
end, AddRightTabbox = function(H, H)
    return UJ:AddTabbox({Side = 2, Name = H})
end, Hover = function(H, H)
    if f.ActiveTab == UJ then return
end
B:Create(e, f.TweenInfo, {TextTransparency = H and 0.25 or 0.5}):Play()
if I then
    B:Create(I, f.TweenInfo, {ImageTransparency = H and 0.25 or 0.5}):Play()
end
end, Show = function(H)
    if f.ActiveTab then f.ActiveTab:Hide()
end
f:PlaySound("click", 0.15, 1)
B:Create(c, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
B:Create(e, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
if I then
    B:Create(I, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
end
if p then
    o:ShowTabInfo(v, p)
end
x.Position = UDim2.fromOffset(0, 10)
x.Visible = true
B:Create(x, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)}):Play()
f.ActiveTab = UJ
if f.Searching then
    f:UpdateSearch(f.SearchText)
end
end, Hide = function(H)
    B:Create(c, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    B:Create(e, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0.5}):Play()
    if I then
        B:Create(I, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0.5}):Play()
    end
    x.Visible = false
    o:HideTabInfo()
    f.ActiveTab = nil
end
}
if not f.ActiveTab then
    UJ:Show()
end
c.MouseEnter:Connect(function()
    f:PlaySound("hover", 0.08, 1.5)
    UJ:Hover(true)
end)
c.MouseLeave:Connect(function()
    UJ:Hover(false)
end)
c.MouseButton1Click:Connect(UJ.Show)
f.Tabs[v] = UJ
return UJ
end
o.AddKeyTab = function(H, ...)
    local v, p, g
    if select("#", ...) == 1 and typeof(...) == "table" then
        H = select(1, ...)
        v = H.Name or "Tab"
        g, p = H.Icon, H.Description
    else
        v = select(1, ...) or "Tab"
        g, p = select(2, ...), select(3, ...)
    end
    g = g or "key"
    local c, e, I, x
    g = g == "key" and X or(f:GetCustomIcon(g))
    do
        c = F("TextButton", {BackgroundColor3 = "MainColor", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Text = "", Parent = D})
        H = F("UIPadding", {PaddingBottom = UDim.new(0, T and 6 or 11), PaddingLeft = UDim.new(0, T and 6 or 12), PaddingRight = UDim.new(0, T and 6 or 12), PaddingTop = UDim.new(0, T and 6 or 11), Parent = c})
        e = F("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -30, 1, 0), Text = v, TextSize = 16, TextTransparency = 0.5, TextXAlignment = Enum.TextXAlignment.Left, Visible = not T, Parent = c})
        if g then
            I = F("ImageLabel", {Image = g.Url, ImageColor3 = g.Custom and "WhiteColor" or "AccentColor", ImageRectOffset = g.ImageRectOffset, ImageRectSize = g.ImageRectSize, ImageTransparency = 0.5, Size = UDim2.fromScale(1, 1), SizeConstraint = T and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY, Parent = c})
        end
        table.insert(f.TabButtons, {Label = e, Padding = H, Icon = I})
        x = F("ScrollingFrame", {AutomaticCanvasSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, CanvasSize = UDim2.fromScale(0, 0), ScrollBarThickness = 0, Size = UDim2.fromScale(1, 1), Visible = false, Parent = K})
        F("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim.new(0, 8), VerticalAlignment = Enum.VerticalAlignment.Center, Parent = x})
        F("UIPadding", {PaddingLeft = UDim.new(0, 1), PaddingRight = UDim.new(0, 1), Parent = x})
    end
    local H
    H = {Elements = {}, IsKeyTab = true, AddKeyBox = function(g, X)
        assert(typeof(X) == "function", "Callback must be a function")
        g = F("Frame", {BackgroundTransparency = 1, Size = UDim2.new(0.75, 0, 0, 21), Parent = x})
        local V = F("TextBox", {BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, PlaceholderText = "Key", Size = UDim2.new(1, -71, 1, 0), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = g})
        F("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = V})
        local K = F("TextButton", {AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = "MainColor", BorderColor3 = "OutlineColor", BorderSizePixel = 1, Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, 63, 1, 0), Text = "Execute", TextSize = 14, Parent = g})
        K.InputBegan:Connect(function(g)
            if not a(g) then return
        end
        if not f:MouseIsOverFrame(K, g.Position) then
            return
        end
        X(V.Text)
    end)
end, RefreshSides = function(g)
end, Resize = function(g)
end, Hover = function(g, g)
    if f.ActiveTab == H then return
end
B:Create(e, f.TweenInfo, {TextTransparency = g and 0.25 or 0.5}):Play()
if I then
    B:Create(I, f.TweenInfo, {ImageTransparency = g and 0.25 or 0.5}):Play()
end
end, Show = function(g)
    if f.ActiveTab then f.ActiveTab:Hide()
end
B:Create(c, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
B:Create(e, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
if I then
    B:Create(I, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
end
x.Visible = true
if p then
    o:ShowTabInfo(v, p)
end
f.ActiveTab = H
if f.Searching then
    f:UpdateSearch(f.SearchText)
end
end, Hide = function(p)
    B:Create(c, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    B:Create(e, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 0.5}):Play()
    if I then
        B:Create(I, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {ImageTransparency = 0.5}):Play()
    end
    x.Visible = false
    o:HideTabInfo()
    f.ActiveTab = nil
end
}
if not f.ActiveTab then
    H:Show()
end
c.MouseEnter:Connect(function()
    H:Hover(true)
end)
c.MouseLeave:Connect(function()
    H:Hover(false)
end)
c.MouseButton1Click:Connect(H.Show)
H.Container = x
setmetatable(H, s)
f.Tabs[v] = H
return H
end
function f.Toggle(s, H)
    if typeof(H) == "boolean" then f.Toggled = H
else
    f.Toggled = not f.Toggled
end
if m then
    m.Visible = k
    n = k
end
for v, v in pairs(E) do
    pcall(function()
        v:Cancel()
    end)
end
E = {}
if f.Toggled then
    f:PlaySound("toggle_on", 0.4)
    P.AnchorPoint = Vector2.new(0.5, 0.5)
    P.Size = UDim2.fromOffset(W.Size.X.Offset * 0.92, W.Size.Y.Offset * 0.92)
    P.Visible = true
    s = W.GlassType == "Full" and 0.3 or(W.GlassType == "TopOnly" and 1 or 0)
    P.BackgroundTransparency = 1
    H = B:Create(P, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = W.Size, BackgroundTransparency = s})
    table.insert(E, H)
    H:Play()
    if W.EnableBlur then
        j.Visible = true
        local s, H = B:Create(j, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}), B:Create(O, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = 56})
        table.insert(E, s)
        table.insert(E, H)
        s:Play()
        H:Play()
    end
else
    f:PlaySound("toggle_off", 0.4)
    local s = B:Create(P, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.fromOffset(W.Size.X.Offset * 0.92, W.Size.Y.Offset * 0.92), BackgroundTransparency = 1})
    table.insert(E, s)
    s:Play()
    s.Completed:Connect(function()
        if not f.Toggled then P.Visible = false
        P.AnchorPoint = Vector2.new(0, 0)
    end
end)
local s, H = B:Create(j, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}), B:Create(O, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = 0})
table.insert(E, s)
table.insert(E, H)
s:Play()
H:Play()
s.Completed:Connect(function()
    if not f.Toggled then j.Visible = false
end
end)
end
if W.UnlockMouseWhileOpen then
    N.Modal = f.Toggled
end
if f.Toggled and not f.IsMobile then
    local N = U.MouseIconEnabled
    pcall(function()
        q:UnbindFromRenderStep("ShowCursor")
    end)
    q:BindToRenderStep("ShowCursor", Enum.RenderPriority.Last.Value, function()
        U.MouseIconEnabled = not f.ShowCustomCursor
        d.Position = UDim2.fromOffset(C.X, C.Y)
        d.Visible = f.ShowCustomCursor
        if not(f.Toggled and b and b.Parent) then
            U.MouseIconEnabled = N
            d.Visible = false
            q:UnbindFromRenderStep("ShowCursor")
        end
    end)
elseif not f.Toggled then
    Q.Visible = false
    for N, N in pairs(f.Options) do
        if N.Type == "ColorPicker" then
            N.ColorMenu:Close()
            N.ContextMenu:Close()
        elseif N.Type == "Dropdown" or N.Type == "KeyPicker" then
            N.Menu:Close()
        end
    end
end
end
if W.EnableSidebarResize then
    local N, s, C = (W.MinSidebarWidth + W.SidebarCompactWidth) * W.SidebarCollapseThreshold
    local H, Q = false
    i = F("TextButton", {AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0), Size = UDim2.new(0, 8, 1, 0), Text = "", Parent = Y})
    i.MouseEnter:Connect(function()
        B:Create(Y, f.TweenInfo, {BackgroundColor3 = f:GetLighterColor(f.Scheme.OutlineColor)}):Play()
    end)
    i.MouseLeave:Connect(function()
        if H then return
    end
    B:Create(Y, f.TweenInfo, {BackgroundColor3 = f.Scheme.OutlineColor}):Play()
end)
i.InputBegan:Connect(function(v)
    if not a(v) then return
end
f.CantDragForced = true
s = v.Position
C, H = o:GetSidebarWidth(), true
Q = v.Changed:Connect(function()
    if v.UserInputState ~= Enum.UserInputState.End then return
end
f.CantDragForced = false
B:Create(Y, f.TweenInfo, {BackgroundColor3 = f.Scheme.OutlineColor}):Play()
H = false
if Q and Q.Connected then
    Q:Disconnect()
    Q = nil
end
end)
end)
f:GiveSignal(U.InputChanged:Connect(function(v)
    if not f.Toggled or not(b and b.Parent) then H = false
    if Q and Q.Connected then
        Q:Disconnect()
        Q = nil
    end
    return
end
if H and(t(v)) then
    local H = v.Position -s
    local s = C + H.X
    if W.DisableCompactingSnap then
        o:SetSidebarWidth(s)
        return
    end
    if s > N then
        o:SetSidebarWidth(math.max(s, W.MinSidebarWidth))
    else
        o:SetSidebarWidth(W.SidebarCompactWidth)
    end
end
end))
end
if W.EnableCompacting and W.SidebarCompacted then
    o:SetSidebarWidth(W.SidebarCompactWidth)
end
if W.AutoShow then
    task.spawn(f.Toggle)
end
if f.IsMobile then
    J, L = f:AddDraggableButton("Toggle", function()
        f:Toggle()
    end, true), f:AddDraggableButton("Lock", function(N)
        f.CantDragForced = not f.CantDragForced
        N:SetText(f.CantDragForced and "Unlock" or "Lock")
    end, true)
    o._mobileButtons = {J, L}
    if W.MobileButtonsSide == "Right" then
        J.Button.Position = UDim2.new(1, -6, 0, 6)
        J.Button.AnchorPoint = Vector2.new(1, 0)
        L.Button.Position = UDim2.new(1, -6, 0, 46)
        L.Button.AnchorPoint = Vector2.new(1, 0)
    else
        L.Button.Position = UDim2.fromOffset(6, 46)
    end
end
_:GetPropertyChangedSignal("Text"):Connect(function()
    f:UpdateSearch(_.Text)
end)
f:GiveSignal(U.InputBegan:Connect(function(J, processed)
    if processed or f.Unloaded then return
end
if U:GetFocusedTextBox() then
    return
end
if typeof(f.ToggleKeybind) == "table" and f.ToggleKeybind.Type == "KeyPicker" and J.KeyCode.Name == f.ToggleKeybind.Value or J.KeyCode == f.ToggleKeybind then
    f.Toggle()
end
end))
f:GiveSignal(U.WindowFocused:Connect(function()
    f.IsRobloxFocused = true
end))
f:GiveSignal(U.WindowFocusReleased:Connect(function()
    f.IsRobloxFocused = false
end))
o.SetSnowfall = function(J, N)
    k = N
    if N and not m then
        m, n = F("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 10, Visible = true, Parent = b}), true
        local L, s = game:GetService("RunService"), {}
        for C = 1, 100, 1 do
            local H, Q, v, p = math.random(3, 6), math.random(30, 60) / 100, math.random(0, 100) / 100, math.random(- 50, -5) / 100
            J = F("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = Q, Size = UDim2.fromOffset(H, H), Position = UDim2.fromScale(v, p), Rotation = math.random(0, 360), Parent = m})
            F("UICorner", {CornerRadius = UDim.new(1, 0), Parent = J})
            s[C] = {frame = J, velY = 0.012, velX = math.random(- 3, 3) / 1000, rotSpeed = math.random(- 60, 60) / 100, delay = math.random(0, 150) / 100, elapsed = 0, posY = p, posX = v, rot = math.random(0, 360)}
        end
        f:GiveSignal((L.Heartbeat:Connect(function(J)
            if not n then return
        end
        local L = J * 60
        for C, C in pairs(s) do
            if C.elapsed < C.delay then
                C.elapsed = C.elapsed + J
            else
                C.posY = C.posY + C.velY * G * L
                C.posX = C.posX + C.velX * L
                C.rot = C.rot + C.rotSpeed * L
                if C.posY > 1.2 then
                    C.posY = math.random(- 30, -5) / 100
                    C.posX = math.random(0, 100) / 100
                end
                if C.posX < -0.05 then
                    C.posX = 1.05
                end
                if C.posX > 1.05 then
                    C.posX = -0.05
                end
                C.frame.Position = UDim2.fromScale(C.posX, C.posY)
                C.frame.Rotation = C.rot
            end
        end
    end)))
elseif not N and m then
    m.Visible = false
    n = false
elseif m then
    m.Visible = N
    n = N
end
end
o.SetBlur = function(J, J)
    W.EnableBlur = J
    if not f.Toggled then
        return
    end
    for N, N in pairs(E) do
        pcall(function()
            N:Cancel()
        end)
    end
    E = {}
    if J then
        j.Visible = true
        local J, N = B:Create(j, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}), B:Create(O, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 56})
        table.insert(E, J)
        table.insert(E, N)
        J:Play()
        N:Play()
    else
        local J, N = B:Create(j, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}), B:Create(O, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0})
        table.insert(E, J)
        table.insert(E, N)
        J:Play()
        N:Play()
        J.Completed:Connect(function()
            j.Visible = false
        end)
    end
end
o.SetGlassType = function(J, N)
    W.GlassType = N
    if S then
        S:Destroy()
        S = nil
    end
    J = P:FindFirstChild("TopBar")
    if J then
        J.BackgroundTransparency = 1
    end
    if N == "Full" then
        P.BackgroundTransparency = 0.3
        for L, L in pairs(y) do
            if L and L.Parent then
                L.BackgroundTransparency = 1
            end
        end
        S = F("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9, Thickness = 1, Parent = P})
    elseif N == "TopOnly" then
        for N, N in pairs(y) do
            if N and N.Parent then
                N.BackgroundTransparency = 0
            end
        end
        J = P:FindFirstChild("TopBar")
        if J then
            P.BackgroundTransparency = 1
            J.BackgroundTransparency = 0.3
            S = F("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.9, Thickness = 1, Parent = J})
        end
    else
        P.BackgroundTransparency = 0
        for J, J in pairs(y) do
            if J and J.Parent then
                J.BackgroundTransparency = 0
            end
        end
    end
end
o.SetCustomBackground = function(J, N)
    J = f._customBg
    if not J then
        return
    end
    if not N or N == "" then
        J.Image = ""
        J.Visible = false
        return
    end
    local L = tostring(N)
    J.Image = if not L:match("://") then "rbxassetid://" .. L:gsub("%D", "") else L
    J.Visible = true
end
o.SetBackgroundOpacity = function(J, N)
    J = f._customBg
    if not J then
        return
    end
    J.ImageTransparency = 1 -math.clamp(N, 0, 1)
end
o.SetMobileButtonOpacity = function(J, J)
    local N = 1 -math.clamp(J, 0, 1)
    for J, J in pairs(o._mobileButtons or{}) do
        if J and J.Button then
            pcall(function()
                J.Button.BackgroundTransparency = N
                J.Button.TextTransparency = N
                for L, L in ipairs(J.Button:GetChildren()) do
                    if L:IsA("UIStroke") then
                        L.Transparency = N
                    end
                end
            end)
        end
    end
end
o.SetSnowColor = function(J, J)
    if not m then return
end
for N, N in m:GetChildren() do
    if N:IsA("Frame") then
        N.BackgroundColor3 = J
    end
end
end
o.SetSnowSpeed = function(J, J)
    G = J or 1
end
o.SetSnowAmount = function(J, N)
    if not m then return
end
J = #m:GetChildren()
if N > J then
    for L = J + 1, N, 1 do
        local L = F("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = math.random(20, 60) / 100, Size = UDim2.fromOffset(math.random(2, 6), math.random(2, 6)), Position = UDim2.fromScale(math.random(0, 100) / 100, -0.1), Parent = m})
        F("UICorner", {CornerRadius = UDim.new(1, 0), Parent = L})
        task.spawn(function()
            while n and L and L.Parent do
                local s, C, H = math.random(8, 15) / (G or 1), math.random(110, 130) / 100, L.Position.X.Scale + math.random(- 20, 20) / 100
                B:Create(L, TweenInfo.new(s, Enum.EasingStyle.Linear), {Position = UDim2.fromScale(H, C)}):Play()
                task.wait(s)
                if n then
                    L.Position = UDim2.fromScale(math.random(0, 100) / 100, -0.1)
                end
            end
        end)
    end
elseif N < J then
    for L = J, N + 1, -1 do
        local J = m:GetChildren()[L]
        if J then
            J:Destroy()
        end
    end
end
end
o.EnableSidebarHover = function(J, J)
    if f.IsMobile then return
end
J = J or{}
local N, L, B = J.CollapsedWidth or 54, J.ExpandedWidth or(o:GetSidebarWidth()), J.Speed or 18
W.EnableCompacting = false
local s, C, H = L, o:GetSidebarWidth(), -1
local function Q(v)
    local p, g = N / 2, math.clamp((v -0.12) / 0.6, 0, 1)
    g = g * g * (3 -2 * g)
    for v, _ in pairs(f.TabButtons) do
        if _.Padding then
            _.Padding.PaddingLeft = UDim.new(0, 0)
            _.Padding.PaddingRight = UDim.new(0, 0)
            _.Padding.PaddingTop = UDim.new(0, 0)
            _.Padding.PaddingBottom = UDim.new(0, 0)
        end
        if _.Icon then
            _.Icon.AnchorPoint = Vector2.new(0.5, 0.5)
            _.Icon.SizeConstraint = Enum.SizeConstraint.RelativeYY
            _.Icon.Size = UDim2.fromScale(0.46, 0.46)
            _.Icon.Position = UDim2.new(0, p, 0.5, 0)
        end
        if _.Label then
            _.Label.Visible = true
            _.Label.Position = UDim2.fromOffset(p + 14 + 8 * g, 0)
            v = _.Label.Parent.BackgroundTransparency < 0.5 and 0 or 0.5
            _.Label.TextTransparency = v + (1 -v) * (1 -g)
        end
    end
    Z.Visible = true
    Z.TextTransparency = 1 -g
end
f:GiveSignal(q.RenderStepped:Connect(function(v)
    if not(b and b.Parent and P.Visible) then return
end
C = if math.abs(s -C) >= 0.5 then C + (s -C) * (1 -math.exp(- v * B)) else s
if math.abs(C -H) >= 0.1 then
    H = C
    o:SetSidebarWidth(C)
end
Q(math.clamp((C -N) / math.max(1, L -N), 0, 1))
end))
local B = 0
local function H()
    B += 1
    s = L
end
local function L()
    B = math.max(0, B -1)
    task.delay(0.06, function()
        local v = B
        if v <= 0 then
            s = N
        end
    end)
end
J = {D, l, Y}
for B, B in ipairs(J) do
    f:GiveSignal(B.MouseEnter:Connect(H))
    f:GiveSignal(B.MouseLeave:Connect(L))
end
s, C = N, N
o:SetSidebarWidth(N)
Q(0)
end
o.EnableResize = function(J, J)
    J = J or{}
    local N, L, B, s = J.Thickness or 6, J.CornerSize or 12, J.Smooth ~= false, Color3.fromRGB(6, 6, 8)
    local J, C, H = F("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = s, ImageTransparency = 0.35, Position = UDim2.new(0.5, 2, 0.5, 3), Size = UDim2.fromOffset(21, 21), ZIndex = 997, Visible = false, Parent = d}), {Vector2.new(1, 0), Vector2.new(- 1, 0), Vector2.new(0, 1), Vector2.new(0, -1), Vector2.new(1, 1), Vector2.new(1, -1), Vector2.new(- 1, 1), Vector2.new(- 1, -1)}, {}
    for Y, Y in ipairs(C) do
        H[#H + 1] = F("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ImageColor3 = s, Position = UDim2.new(0.5, Y.X * 1.6, 0.5, Y.Y * 1.6), Size = UDim2.fromOffset(20, 20), ZIndex = 999, Visible = false, Parent = d})
    end
    local function s(C, Y)
        C.Image = Y.Url
        C.ImageRectOffset = Y.ImageRectOffset
        C.ImageRectSize = Y.ImageRectSize
        C.Visible = true
    end
    local function C(Y)
        local l = Y and(f:GetIcon(Y))
        if not l then
            return
        end
        d.BackgroundTransparency = 1
        for Y, Y in ipairs(d:GetChildren()) do
            if Y:IsA("Frame") then
                Y.Visible = false
            end
        end
        s(w, l)
        s(J, l)
        for Y, Y in ipairs(H) do
            s(Y, l)
        end
    end
    local function s()
        for Y, Y in ipairs(d:GetChildren()) do
            if Y:IsA("Frame") then
                Y.Visible = true
            end
        end
        d.BackgroundTransparency = 0
        w.Visible = false
        J.Visible = false
        for J, J in ipairs(H) do
            J.Visible = false
        end
    end
    local J, d, w = false, P:FindFirstChild("TopBar"), false
    if d then
        f:GiveSignal(d.InputBegan:Connect(function(d)
            if a(d) and not f.CantDragForced then w, J = true, true
            C("move")
        end
    end))
end
f:GiveSignal(U.InputEnded:Connect(function(d)
    if w and d.UserInputType == Enum.UserInputType.MouseButton1 then w, J = false, false
    s()
end
end))
local d, w, H, Y, l = P.Size.X.Offset, P.Size.Y.Offset, P.Position.X.Offset, P.Position.Y.Offset, false
if B then
    f:GiveSignal(q.RenderStepped:Connect(function(q)
        if not l or not(b and b.Parent and P.Visible) then return
    end
    local Q, v, Z = P.Size, P.Position, math.clamp(q * 16, 0, 1)
    P.Size = UDim2.new(Q.X.Scale, Q.X.Offset + (d -Q.X.Offset) * Z, Q.Y.Scale, Q.Y.Offset + (w -Q.Y.Offset) * Z)
    P.Position = UDim2.new(v.X.Scale, v.X.Offset + (H -v.X.Offset) * Z, v.Y.Scale, v.Y.Offset + (Y -v.Y.Offset) * Z)
end))
end
local function q(Q, v, Z, p)
    local g = F("TextButton", {Active = true, AutoButtonColor = false, BackgroundTransparency = 1, Text = "", ZIndex = 60, Parent = P})
    p(g)
    local p, F, _, c, e, I = false
    g.MouseEnter:Connect(function()
        if not J then C(Z)
    end
end)
g.MouseLeave:Connect(function()
    if not J then s()
end
end)
g.InputBegan:Connect(function(g)
    if not a(g) then return
end
p, l, J = true, true, true
C(Z)
F = g.Position
d, w = P.Size.X.Offset, P.Size.Y.Offset
H, Y, _, c = P.Position.X.Offset, P.Position.Y.Offset, d, w
e, I = H, Y
end)
f:GiveSignal(U.InputEnded:Connect(function(C)
    if p and C.UserInputType == Enum.UserInputType.MouseButton1 then p, l, J = false, false, false
    s()
    W.Size = UDim2.fromOffset(d, w)
    f._persistentWindowSize = W.Size
    for J, J in pairs(f.Tabs) do
        pcall(function()
            J:Resize(true)
        end)
    end
end
end))
f:GiveSignal(U.InputChanged:Connect(function(M)
    if not p or not t(M) then return
end
if not(b and b.Parent) then
    p, l = false, false
    return
end
local b, J = workspace.CurrentCamera.ViewportSize, M.Position -F
local M, W = math.clamp(_ + Q * J.X, f.MinSize.X, b.X -20), math.clamp(c + v * J.Y, f.MinSize.Y, b.Y -20)
H = e + Q * (M -_) / 2
Y, d, w = I + v * (W -c) / 2, M, W
if not B then
    P.Size = UDim2.new(P.Size.X.Scale, d, P.Size.Y.Scale, w)
    P.Position = UDim2.new(P.Position.X.Scale, H, P.Position.Y.Scale, Y)
end
end))
end
q(0, -1, "move-vertical", function(M)
    M.AnchorPoint = Vector2.new(0.5, 0)
    M.Position = UDim2.new(0.5, 0, 0, 0)
    M.Size = UDim2.new(1, -L * 2, 0, N)
end)
q(0, 1, "move-vertical", function(M)
    M.AnchorPoint = Vector2.new(0.5, 1)
    M.Position = UDim2.new(0.5, 0, 1, 0)
    M.Size = UDim2.new(1, -L * 2, 0, N)
end)
q(- 1, 0, "move-horizontal", function(M)
    M.AnchorPoint = Vector2.new(0, 0.5)
    M.Position = UDim2.new(0, 0, 0.5, 0)
    M.Size = UDim2.new(0, N, 1, -L * 2)
end)
q(1, 0, "move-horizontal", function(M)
    M.AnchorPoint = Vector2.new(1, 0.5)
    M.Position = UDim2.new(1, 0, 0.5, 0)
    M.Size = UDim2.new(0, N, 1, -L * 2)
end)
q(- 1, -1, "move-diagonal", function(M)
    M.AnchorPoint = Vector2.new(0, 0)
    M.Position = UDim2.new(0, 0, 0, 0)
    M.Size = UDim2.fromOffset(L, L)
end)
q(1, 1, "move-diagonal", function(M)
    M.AnchorPoint = Vector2.new(1, 1)
    M.Position = UDim2.new(1, 0, 1, 0)
    M.Size = UDim2.fromOffset(L, L)
end)
q(1, -1, "move-diagonal-2", function(M)
    M.AnchorPoint = Vector2.new(1, 0)
    M.Position = UDim2.new(1, 0, 0, 0)
    M.Size = UDim2.fromOffset(L, L)
end)
q(- 1, 1, "move-diagonal-2", function(M)
    M.AnchorPoint = Vector2.new(0, 1)
    M.Position = UDim2.new(0, 0, 1, 0)
    M.Size = UDim2.fromOffset(L, L)
end)
end
f:OnUnload(function() O:Destroy() end)
return o
end
local function M()
    if f.Unloaded then return
end
local b, J = r(), r(true)
for N, N in pairs(z) do
    if N.Type == "Dropdown" and N.SpecialType == "Player" then
        N:SetValues(N.ExcludeLocalPlayer and J or b)
    end
end
end
local function b()
    if f.Unloaded then return
end
local J = u()
for N, N in pairs(z) do
    if N.Type == "Dropdown" and N.SpecialType == "Team" then
        N:SetValues(J)
    end
end
end
f:GiveSignal(A.PlayerAdded:Connect(M))
f:GiveSignal(A.PlayerRemoving:Connect(M))
f:GiveSignal(h.ChildAdded:Connect(b))
f:GiveSignal(h.ChildRemoved:Connect(b))
R().YabujinLibrary = f
return f
end
end

-- ============================================================================
-- PART 4: Luraph v14.x Crypto Primitives (ChaCha20 & RC4) & Decoy Functions
-- ============================================================================

-- Function [54]: chacha20CoreRounds (550 bytes) — Luraph ChaCha20 stream cipher quarter-round block mixer (modulo 2^32, rotations 16, 12, 8, 7).
YabujinDeobfuscated.chacha20CoreRounds = function(M, b)
    return function(J, N)
        local A = J[13]
        for A = 1, N, 2 do
            for N = 1, 32, 4 do
                local q, W, U, L = M:Yq(b[1], N), M:Yq(b[1], N + 1), M:Yq(b[1], N + 2), M:Yq(b[1], N + 3)
                local b, N, h, B = J[q], J[W], J[U], J[L]
                b = (b + N) % 4294967296
                A = upval_30(B, b)
                B = upval_123(upval_33(A, 16), (upval_74(A, 16))) % 4294967296
                h = (h + B) % 4294967296
                A = upval_30(N, h)
                N = upval_123(upval_33(A, 12), (upval_74(A, 20))) % 4294967296
                b = upval_21(b + N, 4294967295)
                A = upval_30(B, b)
                B = upval_123(upval_33(A, 8), (upval_74(A, 24))) % 4294967296
                h = (h + B) % 4294967296
                A = upval_30(N, h)
                N = upval_123(upval_33(A, 7), (upval_74(A, 25))) % 4294967296
                J[q] = b
                J[W] = N
                J[U] = h
                J[L] = B
            end
        end
    end
end

-- Function [115]: rc4BufferDecryptor (1519 bytes) — Luraph RC4 stream cipher buffer decryptor.
YabujinDeobfuscated.rc4BufferDecryptor = function(M, b)
    return function()
        local J, N, A, q, W, U, L, h, B, R, s, d, w = 8
        while true do
            if J <= 4 then
                if J <= 1 then
                    if J <= 0 then
                        local u, C = M[33](U, 16), M[21](q + 1, 255)
                        local o = M[21](W + R[C], 255)
                        local H, z = R[o], R[C]
                        R[C] = H
                        R[o] = z
                        z = M[123](A, u, (M[33](R[M[21](R[C] + R[o], 255)], 24)))
                        M[86](s, w, (M[30](M[19](L, h + w), z)))
                        J, A, q, W, U = 7, C, o, C, o
                    else
                        return s
                    end
                elseif J <= 2 then
                    local u = M[21](W + 1, 255)
                    local C = M[21](U + R[u], 255)
                    R[u], R[C] = R[C], R[u]
                    local o = R[M[21](R[u] + R[C], 255)]
                    M[90](s, A, (M[30](M[70](L, h + A), o)))
                    J, W, U = 9, u, C
                elseif J <= 3 then
                    local u, C = B -1, 1 + 0
                    J, N = 9, {d -C, C, u + 0, nil, N}
                else
                    J, N = 3, N[2]
                end
            elseif J <= 7 then
                if J <= 5 then
                    local u = M[21](W + 1, 255)
                    local C = M[21](U + R[u], 255)
                    R[u], R[C] = R[C], R[u]
                    local o, H = M[123](0, (M[33](R[M[21](R[u] + R[C], 255)], 0))), M[21](u + 1, 255)
                    u = M[21](C + R[H], 255)
                    J, A, q, W, U = 6, o, H, u, R[u]
                elseif J <= 6 then
                    R[q], R[W] = U, R[q]
                    local u, C = M[123](A, (M[33](R[M[21](R[q] + R[W], 255)], 8))), M[21](q + 1, 255)
                    local o = M[21](W + R[C], 255)
                    R[C], R[o] = R[o], R[C]
                    J, A, q, W, U = 0, u, C, o, R[M[21](R[C] + R[o], 255)]
                else
                    local q, u, C = N[3], N[4], N[5]
                    local o, H = q + u, u <= 0
                    local u, z, P = not H, o >= C, o <= C
                    q = H and z or u and P
                    N[3] = o
                    if q then
                        J, w = 5, o
                    else
                        J = 4
                    end
                end
            elseif J <= 8 then
                local q = upval_1
                local w = upval_2
                local u = M[121](q) -w
                local C, o, H = upval_3, M[104](u), u -u % 4
                local M, b = H -1, 4 + 0
                J, N, W, U, L, h, B, R, s, d = 7, {nil, N, 0 -b, b, M + 0}, 0, 0, q, w, u, C, o, H
            elseif J <= 9 then
                local M, b, q = N[1], N[2], N[3]
                local W, U = M + b, b <= 0
                local M, L, h = not U, W >= q, W <= q
                b = U and L or M and h
                N[1] = W
                if b then
                    J, A = 2, W
                else
                    J = 10
                end
            else
                J, N = 1, N[5]
            end
        end
    end
end

-- Function [29]: lcgPrngStepShort (224 bytes) — Luraph LCG PRNG state update helper (modulo 2^28).
YabujinDeobfuscated.lcgPrngStepShort = function(M, b)
    return function()
        local b = 1
        while true do
            if b <= 0 then
                return
            else
                prngState = (108001 * prngState + 41316589) % 268435456
                prngState, b = (277145 * prngState + 18527935) % 268435456, 0
            end
        end
    end
end

-- Function [100]: lcgPrngStateMixer (1835 bytes) — Luraph multi-round LCG PRNG state mixer (modulo 2^28).
YabujinDeobfuscated.lcgPrngStateMixer = function(M, b)
    return function()
        local b, J, N = 3
        while true do
            if b <= 3 then
                if b <= 1 then
                    if b <= 0 then
                        prngState = (J + N) % 268435456
                        prngState = (690929 * prngState + 119601043) % 268435456
                        prngState = (859391 * prngState + 120116449) % 268435456
                        prngState, b = (171135 * prngState + 144943331) % 268435456, 1
                    else
                        prngState = (582423 * prngState + 54050079) % 268435456
                        prngState = (297915 * prngState + 21926831) % 268435456
                        prngState = (443227 * prngState + 143916285) % 268435456
                        b, J, N = 5, 351993 * prngState, 20986297
                    end
                elseif b <= 2 then
                    return
                else
                    prngState = (40009 * prngState + 130141905) % 268435456
                    prngState = (793801 * prngState + 99058595) % 268435456
                    prngState = (164495 * prngState + 14226451) % 268435456
                    b, J = 7, 918999 * prngState + 33991111
                end
            elseif b <= 5 then
                if b <= 4 then
                    prngState = J
                    prngState = (257053 * prngState + 49005783) % 268435456
                    prngState = (878903 * prngState + 15147739) % 268435456
                    prngState = (673811 * prngState + 67595405) % 268435456
                    b, J, N = 0, 650741 * prngState, 222415865
                else
                    prngState = (J + N) % 268435456
                    prngState = (106839 * prngState + 131364431) % 268435456
                    prngState = (677009 * prngState + 59323863) % 268435456
                    prngState, b = (654607 * prngState + 14723519) % 268435456, 2
                end
            elseif b <= 6 then
                prngState = (J * N + 71663543) % 268435456
                prngState = (180075 * prngState + 149212815) % 268435456
                prngState = (310757 * prngState + 149644699) % 268435456
                b, J = 4, (434999 * prngState + 14898349) % 268435456
            else
                prngState = J % 268435456
                prngState = (910865 * prngState + 89397363) % 268435456
                prngState = (635211 * prngState + 129853869) % 268435456
                prngState = (195469 * prngState + 103376131) % 268435456
                b, J, N = 6, 429183, prngState
            end
        end
    end
end

-- Function [57]: luraphDecoyGuiScanner (730 bytes) — Luraph polymorphic chaff/decoy coroutine loop.
YabujinDeobfuscated.luraphDecoyGuiScanner = function(M, b)
    return function()
        while true do
            if not decoyTable1[24](function()
                local b = decoyTable1[1][decoyTable1[2]][decoyTable1[3]][decoyTable1[4]][decoyTable1[5]][decoyTable1[6]][decoyTable1[7]]
                local J = b[decoyTable1[8]](b)
                for N, N in decoyTable1[9](J) do
                    if N[decoyTable1[10]](N, decoyTable1[11]) and(N[decoyTable1[12]](N, decoyTable1[20])) then
                        b = N[decoyTable1[20]][decoyTable1[13]]
                        if decoyTable1[16](decoyTable2, b[decoyTable1[14]](b, 3)) then
                            decoyTarget = N
                            break
                        end
                    end
                end
                if decoyTarget then
                    local b = decoyTarget[decoyTable1[20]][decoyTable1[13]]
                    decoyTarget[decoyTable1[20]][decoyTable1[13]] = b[decoyTable1[14]](b, 1, 2) .. decoyTable2[1][decoyTable1[14]](decoyTable2[1], 1, 10) .. decoySep .. decoyVal1 .. decoyVal2
                    decoyTarget[decoyTable1[17]][decoyTable1[18]] = decoyVal3
                    decoyTarget[decoyTable1[20]][decoyTable1[19]] = decoyVal4
                end
            end) then
                decoyTable1[21](decoyTable1[22])
            else
                decoyTable1[21](decoyTable1[23])
            end
        end
    end
end

-- Function [68]: luraphDecoyProgressBar (614 bytes) — Luraph chaff/decoy progress bar loop.
YabujinDeobfuscated.luraphDecoyProgressBar = function(M, b)
    return function()
        while true do
            if activeFlag then
                local b = progressValue
                local J = progressMax
                if b < J then
                    progressValue += 1
                end
                J = mathFloor(progressValue / 5)
                outputText = strTable[strDecrypt("P", 30780822482938)] .. strTable[strDecrypt("\206", 10650770187967)]:rep(J) .. strTable[strDecrypt("\218", 11767495764687)]:rep(20 -J) .. strTable[strDecrypt("\18 \11", 17444542037878)] .. progressValue .. strTable[strDecrypt(" \207\135\147I", 4720313110828)]
            end
            waitFunc(0.03)
            if stopFlag then
                break
            end
        end
    end
end


    config._withId=function(callback,...)
        return YabujinDeobfuscated.runWithElevatedThreadIdentity(callback,...)
    end
    function YabujinDeobfuscated:MissingDependencies(name)
        local missing={}
        for _,key in ipairs(self.Required[name]or{})do
            if resolve(key)==nil and not key:match("^cached") and key~="setthreadidentity"and key~="getthreadidentity"and key~="callbackRef"and key~="heartbeatConnection"and key~="lastCameraCFrame"then missing[#missing+1]=key end
        end
        return missing
    end
    function YabujinDeobfuscated:Call(name,...)
        local fn=self[name]
        if type(fn)~="function"then return false,"Unknown recovered function: "..tostring(name)end
        local missing=self:MissingDependencies(name)
        if #missing>0 then return false,"Missing original dependencies for "..name..": "..table.concat(missing,", ")end
        return pcall(fn,...)
    end
    function YabujinDeobfuscated:Unload()
        if not self.Alive then return end
        self.Alive=false
        config._stopped=true
        if self.Backend then self.Backend:Destroy()end
        if self.StopPlex then self:StopPlex()end
        if self.Library and self.Library.Unload then pcall(self.Library.Unload,self.Library)end
    end
    return YabujinDeobfuscated
end
local environment=getgenv and getgenv()or globalEnv
local options=environment.__YabujinOptions or {}
local previous=environment.YabujinRecovered
if previous and previous.Unload then pcall(previous.Unload,previous)end
local runtime=createRuntime(options.Dependencies)
runtime.New=createRuntime
runtime.SourceStatus="Recovered functions with dependency bindings; original client startup and some upvalues were not included."
environment.YabujinRecovered=runtime
function runtime:StartUI()
    if self.Library then return self.Library end
    local ok,library=self:Call("initYabujinObsidianLibrary")
    if not ok then return nil,library end
    if type(library)~="table"or type(library.CreateWindow)~="function"then return nil,"Recovered UI initializer did not return a window library"end
    self.Library=library
    return library
end
local createPlexBackend=(function()
return function(context)
    local exportedApi
    local mainapi=context
    local RunService=game:GetService("RunService")
    local HttpService=game:GetService("HttpService")
    local UserInputService=game:GetService("UserInputService")
    local LionLibrary,LionWindow=nil,nil
    local function run(callback)callback()end
run(function()

            -- Unlock All integrated with the cosmetic changer
local plrs = game:GetService("Players")
local reps = game:GetService("ReplicatedStorage")
local http = game:GetService("HttpService")
local collectionService = game:GetService("CollectionService")

local lp = plrs.LocalPlayer
if not lp then return end

local lps = lp:FindFirstChild("PlayerScripts") or lp:WaitForChild("PlayerScripts", 10)
if not lps then return end

local ctrls = lps:FindFirstChild("Controllers") or lps:WaitForChild("Controllers", 10)
local rmods = reps:FindFirstChild("Modules") or reps:WaitForChild("Modules", 10)
if not ctrls or not rmods then return end

local function safeRequireModule(module)
    if not module then return nil end
    local ok, result = pcall(require, module)
    return ok and result or nil
end

local elib = safeRequireModule(rmods:WaitForChild("EnumLibrary", 10))
if elib and elib.WaitForEnumBuilder then
    pcall(function()
        elib:WaitForEnumBuilder()
    end)
end
local clib = safeRequireModule(rmods:WaitForChild("CosmeticLibrary", 10))
local ilib = safeRequireModule(rmods:WaitForChild("ItemLibrary", 10))
local consts = safeRequireModule(rmods:WaitForChild("CONSTANTS", 10))
local dctrl = safeRequireModule(ctrls:WaitForChild("PlayerDataController", 10))
if not (elib and clib and ilib and consts and dctrl and clib.Cosmetics) then return end
local coss = clib.Cosmetics

local function findDescendantByName(parent, name)
    if not parent then return nil end
    local direct = parent:FindFirstChild(name)
    if direct then return direct end
    for _, descendant in ipairs(parent:GetDescendants()) do
        if descendant.Name == name then
            return descendant
        end
    end
    return nil
end

local KNIFE_CUSTOM_SKIN = "Knife (Custom Skin)"
local REAVER_KNIFE_CUSTOM_SKIN = "reaver"
local DAGGERS_CUSTOM_SKIN = "Jett"
local SATCHEL_CUSTOM_SKIN = "Raze"
local SNIPER_CUSTOM_SKIN = "Chamber"
local RPG_CUSTOM_SKIN = "RPG Raze"
local FISTS_CUSTOM_SKIN = "Agent"
local BOW_CUSTOM_SKIN = "Sova"
local ASSAULT_RIFLE_CUSTOM_SKIN = "Vandal"
local DICE_TRIPMINE_SKIN = "Subspace Tripmine (Custom Skin)"
local DICE_TRIPMINE_OUTER_MESH_ID = "rbxassetid://5555691474"
local DICE_TRIPMINE_INNER_MESH_ID = "rbxassetid://5555691356"
local DICE_TRIPMINE_IMAGE_ID = "rbxassetid://98372867049331"
local DICE_TRIPMINE_IMAGE_HIGH_RES_ID = "rbxassetid://75601061529918"
local DICE_TRIPMINE_MESH_SCALE = 3.35
local DICE_TRIPMINE_WORLD_MESH_SCALE = 3.25
local SPIKE_TRIPMINE_SKIN = "Spike"
local SPIKE_TRIPMINE_MESH_ID = "rbxassetid://97754746098028"
local TRIPMINE_STAR_REMOVE_MESH_ID = "rbxassetid://13792525075"
local SPIKE_TRIPMINE_MESH_SCALE = 85
local SPIKE_TRIPMINE_WORLD_MESH_SCALE = 50
local SNIPER_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://98786413608787"
local SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://131686603013672"
local SNIPER_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.025, 0.025, 0.025)
local SNIPER_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0, -0.25, 0)
local DAGGERS_CUSTOM_SOURCE_MESH_ID = "rbxassetid://94772705561955"
local DAGGERS_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://128075492497238"
local DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://79246900644201"
local DAGGERS_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.03, 0.03, 0.03)
local DAGGERS_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, -90)
local SATCHEL_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://129982008330139"
local SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://121713947189258"
local SATCHEL_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.5, 0.5, 0.5)
local SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE = Vector3.new(0.6, 0.6, 0.6)
local SATCHEL_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, -90, 0)
local RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://81554047161707"
local RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://133257377819985"
local RPG_CUSTOM_REPLACEMENT_SCALE = 0.5
local RPG_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, 0)
local RPG_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0.04, 0, 0)
local FISTS_CUSTOM_LEFT_MESH_ID = "rbxassetid://120273083766829"
local FISTS_CUSTOM_LEFT_TEXTURE_ID = "rbxassetid://124608382264962"
local FISTS_CUSTOM_RIGHT_MESH_ID = "rbxassetid://129220833982000"
local FISTS_CUSTOM_RIGHT_TEXTURE_ID = "rbxassetid://118482605175566"
local FISTS_CUSTOM_MESH_SCALE = Vector3.new(0.1, 0.1, 0.1)
local FISTS_CUSTOM_LEFT_ROTATION = Vector3.new(45, 0, 0)
local FISTS_CUSTOM_RIGHT_ROTATION = Vector3.new(-45, 0, 0)
local BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://80147707463344"
local BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://87690225474067"
local BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID = "rbxassetid://97839236861642"
local BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID = "rbxassetid://82458179247269"
local BOW_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.25, 0.25, 0.25)

local CUSTOM_SKIN_IMAGE_OVERRIDES = {
    [REAVER_KNIFE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    ["sky"] = { Image = "", ImageHighResolution = "" },
    ["Camera"] = { Image = "", ImageHighResolution = "" },
    ["Grenade Raze"] = { Image = "", ImageHighResolution = "" },
    [DAGGERS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    [SATCHEL_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    [SNIPER_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    ["Operator"] = { Image = "", ImageHighResolution = "" },
    [RPG_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    [FISTS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    [BOW_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    [ASSAULT_RIFLE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
    [DICE_TRIPMINE_SKIN] = { Image = DICE_TRIPMINE_IMAGE_ID, ImageHighResolution = DICE_TRIPMINE_IMAGE_HIGH_RES_ID },
    [SPIKE_TRIPMINE_SKIN] = { Image = "", ImageHighResolution = "" }
}

local SNIPER_MESH_SKIN_OVERRIDES = {
    [SNIPER_CUSTOM_SKIN] = {
        Skin = SNIPER_CUSTOM_SKIN,
        BodyMeshIds = {
            "rbxassetid://95497877882755",
            "rbxassetid://118920880889483",
            "rbxassetid://80662423119419"
        },
        RemoveMeshIds = {
            "rbxassetid://100168191352015",
            "rbxassetid://82935541182957",
            "rbxassetid://95388370230390",
            "rbxassetid://84918196407550"
        },
        ReplacementMeshId = SNIPER_CUSTOM_REPLACEMENT_MESH_ID,
        ReplacementTextureId = SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID,
        ReplacementSize = SNIPER_CUSTOM_REPLACEMENT_SIZE,
        ReplacementOffset = SNIPER_CUSTOM_REPLACEMENT_OFFSET
    },
    ["Operator"] = {
        Skin = "Operator",
        BodyMeshIds = {
            "rbxassetid://13188893115",
            "rbxassetid://13188892761",
            "rbxassetid://14778413014",
            "rbxassetid://13188893017",
            "rbxassetid://14774727092"
        },
        RemoveMeshIds = {
            "rbxassetid://13188893310",
            "rbxassetid://13188892855"
        },
        BulletMeshIds = {
            "rbxassetid://14002915797"
        },
        MagazineMeshIds = {
            "rbxassetid://13188892532",
            "rbxassetid://13188892651"
        },
        BodyReplacementMeshId = "rbxassetid://132995629661821",
        BodyReplacementTextureId = "rbxassetid://80634410259243",
        ScopeReplacementMeshId = "rbxassetid://103988563532751",
        ScopeReplacementTextureId = "rbxassetid://136789986141252",
        MagazineReplacementMeshId = "rbxassetid://80074307887476",
        MagazineReplacementTextureId = "rbxassetid://80634410259243",
        ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
        ReplacementOffset = Vector3.new(0, -0.25, 0),
        ScopeOffset = Vector3.new(0.175, 0.5, 0.005),
        MagazineOffset = Vector3.new(0.7, 0, 0.05),
        BulletOffset = Vector3.new(-1.25, 0, 0),
        ReplacementVersion = 9
    }
}

local DAGGERS_MESH_SKIN_OVERRIDES = {
    [DAGGERS_CUSTOM_SKIN] = {
        Skin = DAGGERS_CUSTOM_SKIN,
        SourceMeshIds = { DAGGERS_CUSTOM_SOURCE_MESH_ID },
        ReplacementMeshId = DAGGERS_CUSTOM_REPLACEMENT_MESH_ID,
        ReplacementTextureId = DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID,
        ReplacementSize = DAGGERS_CUSTOM_REPLACEMENT_SIZE,
        ReplacementRotation = DAGGERS_CUSTOM_REPLACEMENT_ROTATION,
        ReplacementVersion = 6,
        FallbackBodyNames = { "LeftBody", "RightBody" }
    }
}

local SATCHEL_MESH_SKIN_OVERRIDES = {
    [SATCHEL_CUSTOM_SKIN] = {
        Skin = SATCHEL_CUSTOM_SKIN,
        SourceMeshIds = {
            "rbxassetid://138805549853994",
            "rbxassetid://125258747465100",
            "rbxassetid://111319295872696",
            "rbxassetid://129504437671598",
            "rbxassetid://104440368867933"
        },
        ReplacementMeshId = SATCHEL_CUSTOM_REPLACEMENT_MESH_ID,
        ReplacementTextureId = SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID,
        ReplacementSize = SATCHEL_CUSTOM_REPLACEMENT_SIZE,
        WorldReplacementSize = SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE,
        ReplacementRotation = SATCHEL_CUSTOM_REPLACEMENT_ROTATION,
        ReplacementVersion = 5
    },
    [REAVER_KNIFE_CUSTOM_SKIN] = {
        Skin = REAVER_KNIFE_CUSTOM_SKIN,
        SourceMeshIds = {
            "rbxassetid://85166039303292",
            "rbxassetid://125674590013235",
            "rbxassetid://97042702941502",
            "rbxassetid://116723276788898",
            "rbxassetid://99266754879173"
        },
        ReplacementMeshId = "rbxassetid://76054449109492",
        ReplacementTextureId = "rbxassetid://117578984602503",
        ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
        ReplacementRotation = Vector3.new(0, 90, 0),
        ReplacementOffset = Vector3.new(0, 0.5, 0),
        ReplacementVersion = 3
    },
    ["sky"] = {
        Skin = "sky",
        SourceMeshIds = { "rbxassetid://140203670599306" },
        ReplacementMeshId = "rbxassetid://78577370691269",
        ReplacementTextureId = "rbxassetid://130284287910497",
        ReplacementSize = Vector3.new(0.6, 0.6, 0.6),
        ReplacementRotation = Vector3.new(0, 90, 0),
        WorldSourceMeshIds = { "rbxassetid://140203670599306" },
        WorldReplacementMeshId = "rbxassetid://111122607123480",
        WorldReplacementTextureId = "rbxassetid://86629139856581",
        WorldReplacementSize = Vector3.new(0.3, 0.3, 0.3),
        WorldReplacementRotation = Vector3.zero,
        ReplacementVersion = 2
    },
    ["Grenade Raze"] = {
        Skin = "Grenade Raze",
        SourceMeshIds = {
            "rbxassetid://87132852844264",
            "rbxassetid://96681677373844",
            "rbxassetid://121396126155803",
            "rbxassetid://121842208464560"
        },
        ReplacementMeshId = "rbxassetid://80612596590820",
        ReplacementTextureId = "rbxassetid://123233413518598",
        ReplacementSize = Vector3.new(0.8, 0.8, 0.8),
        ReplacementVersion = 2
    },
    ["Camera"] = {
        Skin = "Camera",
        SourceMeshIds = {
            "rbxassetid://17835823024",
            "rbxassetid://17835823121",
            "rbxassetid://17835823211"
        },
        ReplacementMeshId = "rbxassetid://112849634500139",
        ReplacementTextureId = "rbxassetid://126465878813440",
        ReplacementSize = Vector3.new(0.5, 0.5, 0.5),
        ReplacementRotation = Vector3.new(0, 0, -90),
        WorldSourceMeshIds = {
            "rbxassetid://17835823024",
            "rbxassetid://17835823121",
            "rbxassetid://17835823211"
        },
        WorldReplacementSize = Vector3.new(2, 2, 2),
        WorldReplacementRotation = Vector3.new(0, 90, -90),
        ReplacementVersion = 2
    }
}

local RPG_MESH_SKIN_OVERRIDES = {
    [RPG_CUSTOM_SKIN] = {
        Skin = RPG_CUSTOM_SKIN,
        BodyMeshIds = {
            "rbxassetid://17638908187",
            "rbxassetid://17638908626"
        },
        JuggleMeshIds = {
            "rbxassetid://17638908803",
            "rbxassetid://17638907818"
        },
        RocketMeshIds = {
            "rbxassetid://17638908803",
            "rbxassetid://17638907818"
        },
        BodyReplacementMeshId = RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID,
        BodyReplacementTextureId = RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
        ReplacementScale = RPG_CUSTOM_REPLACEMENT_SCALE,
        ReplacementRotation = RPG_CUSTOM_REPLACEMENT_ROTATION,
        ReplacementOffset = RPG_CUSTOM_REPLACEMENT_OFFSET,
        ReplacementVersion = 3
    }
}

local FISTS_MESH_SKIN_OVERRIDES = {
    [FISTS_CUSTOM_SKIN] = {
        Skin = FISTS_CUSTOM_SKIN,
        LeftPartName = "LeftItem",
        RightPartName = "RightItem",
        LeftMeshId = FISTS_CUSTOM_LEFT_MESH_ID,
        LeftTextureId = FISTS_CUSTOM_LEFT_TEXTURE_ID,
        RightMeshId = FISTS_CUSTOM_RIGHT_MESH_ID,
        RightTextureId = FISTS_CUSTOM_RIGHT_TEXTURE_ID,
        MeshScale = FISTS_CUSTOM_MESH_SCALE,
        LeftRotation = FISTS_CUSTOM_LEFT_ROTATION,
        RightRotation = FISTS_CUSTOM_RIGHT_ROTATION,
        ReplacementVersion = 1
    }
}

local BOW_MESH_SKIN_OVERRIDES = {
    [BOW_CUSTOM_SKIN] = {
        Skin = BOW_CUSTOM_SKIN,
        BodyMeshIds = {
            "rbxassetid://116947825701555",
            "rbxassetid://80510746199823"
        },
        ArrowMeshIds = {
            "rbxassetid://108027163190911",
            "rbxassetid://114261802270550"
        },
        BodyReplacementMeshId = BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID,
        BodyReplacementTextureId = BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
        ArrowReplacementMeshId = BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID,
        ArrowReplacementTextureId = BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID,
        ReplacementSize = BOW_CUSTOM_REPLACEMENT_SIZE,
        ReplacementVersion = 2
    }
}

local ASSAULT_RIFLE_MESH_SKIN_OVERRIDES = {
    [ASSAULT_RIFLE_CUSTOM_SKIN] = {
        Skin = ASSAULT_RIFLE_CUSTOM_SKIN,
        BodyMeshIds = {
            "rbxassetid://17661950733",
            "rbxassetid://17661950585",
            "rbxassetid://17662005180",
            "rbxassetid://17662016762"
        },
        BoltMeshIds = {
            "rbxassetid://17661950452"
        },
        MagazineMeshIds = {
            "rbxassetid://17662005301",
            "rbxassetid://17662005453"
        },
        ReloadMagazineMeshIds = {
            "rbxassetid://17662005453",
            "rbxassetid://17662005301"
        },
        BodyReplacementMeshId = "rbxassetid://138100951261312",
        BodyReplacementTextureId = "rbxassetid://84167100219585",
        MagazineReplacementMeshId = "rbxassetid://92935167277909",
        MagazineReplacementTextureId = "rbxassetid://84167100219585",
        ReloadMagazineReplacementMeshId = "rbxassetid://92935167277909",
        ReloadMagazineReplacementTextureId = "rbxassetid://84167100219585",
        ReplacementSize = Vector3.new(0.35, 0.35, 0.35),
        ReplacementOffset = Vector3.new(0.1, -0.25, 0.04),
        MagazineOffset = Vector3.new(-0.135, -0.2, -0.03),
        ReplacementVersion = 6
    }
}

local TRIPMINE_MESH_SKIN_OVERRIDES = {
    [DICE_TRIPMINE_SKIN] = {
        Skin = DICE_TRIPMINE_SKIN,
        MeshIds = { DICE_TRIPMINE_OUTER_MESH_ID, DICE_TRIPMINE_INNER_MESH_ID },
        RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
        Scale = DICE_TRIPMINE_MESH_SCALE,
        WorldScale = DICE_TRIPMINE_WORLD_MESH_SCALE,
        WorldGroundOffset = 0.5,
        ExtraMeshScale = 1.15,
        WorldExtraMeshScale = 1,
        Color = Color3.fromRGB(255, 255, 255),
        Material = Enum.Material.SmoothPlastic,
        Reflectance = 0,
        ClearTexture = true
    },
    [SPIKE_TRIPMINE_SKIN] = {
        Skin = SPIKE_TRIPMINE_SKIN,
        MeshId = SPIKE_TRIPMINE_MESH_ID,
        RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
        Scale = SPIKE_TRIPMINE_MESH_SCALE,
        WorldScale = SPIKE_TRIPMINE_WORLD_MESH_SCALE,
        WorldGroundOffset = 0.5,
        Color = Color3.fromRGB(163, 162, 165),
        ClearTexture = true
    }
}

local function normalizeAssetId(assetId)
    return tostring(assetId or ""):match("%d+") or ""
end

local function getTripmineMeshIds(profile)
    local ids = {}
    if type(profile and profile.MeshIds) == "table" then
        for _, meshId in ipairs(profile.MeshIds) do
            if normalizeAssetId(meshId) ~= "" then
                table.insert(ids, meshId)
            end
        end
    elseif profile and normalizeAssetId(profile.MeshId) ~= "" then
        table.insert(ids, profile.MeshId)
    end
    return ids
end

local function getTripmineExtraMeshScale(profile, worldVisual)
    if worldVisual then
        return profile and profile.WorldExtraMeshScale or 1
    end
    return profile and profile.ExtraMeshScale or 1
end

local function getTripmineMeshSignature(profile, worldVisual)
    local normalized = {}
    for _, meshId in ipairs(getTripmineMeshIds(profile)) do
        table.insert(normalized, normalizeAssetId(meshId))
    end
    return table.concat(normalized, ",") .. "|" .. tostring(getTripmineExtraMeshScale(profile, worldVisual))
end

local function scaleTripmineMeshVector(scale, multiplier)
    multiplier = multiplier or 1
    if typeof(scale) == "Vector3" then
        return scale * multiplier
    end
    return Vector3.new(scale, scale, scale) * multiplier
end

local function meshMatchesAssetId(inst, assetId)
    local id = normalizeAssetId(assetId)
    if id == "" or typeof(inst) ~= "Instance" then return false end
    if inst:IsA("SpecialMesh") then
        return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureId) == id
    elseif inst:IsA("MeshPart") then
        return normalizeAssetId(inst.MeshId) == id or normalizeAssetId(inst.TextureID) == id
    end
    return false
end

local function isCustomTripmineMeshIgnored(inst)
    local current = inst
    while current do
        if current:GetAttribute("__LionHiddenTripmineMesh") then
            return true
        end
        local compactName = tostring(current.Name or ""):lower():gsub("[%s_%-%p]", "")
        if compactName:find("arm", 1, true)
            or compactName:find("hand", 1, true)
            or compactName:find("fake", 1, true)
            or compactName:find("charm", 1, true)
            or compactName:find("hitbox", 1, true) then
            return true
        end
        current = current.Parent
    end
    return false
end

local function scoreCustomTripmineMeshTarget(root, meshLike, removedMeshId)
    if removedMeshId and meshMatchesAssetId(meshLike, removedMeshId) then return nil end
    local part = meshLike:IsA("SpecialMesh") and meshLike.Parent or meshLike
    if not (part and part:IsA("BasePart")) or isCustomTripmineMeshIgnored(part) then return nil end
    local score = part.Size.Magnitude
    local name = tostring(part.Name or ""):lower()
    if root:IsA("Model") and part == root.PrimaryPart then score += 1000 end
    if name:find("mesh", 1, true) then score += 500 end
    if name:find("body", 1, true) then score += 250 end
    if name:find("mine", 1, true) or name:find("trip", 1, true) then score += 250 end
    return score
end

local function findCustomTripmineMeshTarget(root, profile)
    if typeof(root) ~= "Instance" then return nil end
    local best, bestScore = nil, -math.huge
    local removedMeshId = profile and (profile.RemoveMeshId or profile.HideMeshId)
    local function consider(obj)
        if obj:IsA("SpecialMesh") or obj:IsA("MeshPart") then
            local score = scoreCustomTripmineMeshTarget(root, obj, removedMeshId)
            if score and score > bestScore then
                best = obj
                bestScore = score
            end
        end
    end
    consider(root)
    for _, descendant in ipairs(root:GetDescendants()) do
        consider(descendant)
    end
    return best
end

local function removeTripmineMeshAsset(root, assetId)
    if typeof(root) ~= "Instance" or not assetId then return end
    local remove = {}
    local function queueIfMatch(obj)
        if meshMatchesAssetId(obj, assetId) then
            local part = obj:IsA("SpecialMesh") and obj.Parent or obj
            if part and part:IsA("BasePart") then
                table.insert(remove, part)
            elseif obj:IsA("SpecialMesh") then
                table.insert(remove, obj)
            end
        end
    end
    queueIfMatch(root)
    for _, obj in ipairs(root:GetDescendants()) do
        queueIfMatch(obj)
    end
    for _, obj in ipairs(remove) do
        if obj and obj.Parent then
            obj:SetAttribute("__LionRemovedTripmineMesh", true)
            obj:Destroy()
        end
    end
end

local function removeCustomTripmineExtraMeshes(root)
    if typeof(root) ~= "Instance" then return end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:GetAttribute("__LionCustomTripmineExtraMesh") then
            obj:Destroy()
        end
    end
end

local function getMeshLikePart(obj)
    if typeof(obj) ~= "Instance" then return nil end
    if obj:IsA("SpecialMesh") then
        return obj.Parent and obj.Parent:IsA("BasePart") and obj.Parent or nil
    end
    return obj:IsA("BasePart") and obj or nil
end

local function meshMatchesAnyAssetId(inst, assetIds)
    for _, assetId in ipairs(assetIds or {}) do
        if meshMatchesAssetId(inst, assetId) then
            return true
        end
    end
    return false
end

local function rotationCFrameFromDegrees(rotation)
    if typeof(rotation) ~= "Vector3" then return CFrame.identity end
    return CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
end

local function namePathContains(inst, needle)
    needle = tostring(needle or ""):lower()
    if needle == "" then return false end
    local current = inst
    while current and current ~= game do
        if tostring(current.Name or ""):lower():find(needle, 1, true) then
            return true
        end
        current = current.Parent
    end
    return false
end

local function hideDaggerMeshAnchor(part)
    if not (part and part:IsA("BasePart")) then return end
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function() part.CastShadow = false end)
    pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
    part:SetAttribute("__LionDaggerHiddenAnchor", true)
    part:SetAttribute("IgnoreObject", true)
    part:SetAttribute("IgnoreTransparency", true)
    pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
    if part:IsA("MeshPart") then
        pcall(function() part.TextureID = "" end)
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        elseif child:IsA("SpecialMesh") then
            child.Scale = Vector3.zero
            pcall(function() child.TextureId = "" end)
        end
    end
end

local function addReplacementSpecialMesh(part, profile, defaultScale)
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = profile.ReplacementMeshId
    pcall(function() mesh.TextureId = profile.ReplacementTextureId or "" end)
    mesh.Scale = profile.ReplacementMeshScale or profile.ReplacementSize or defaultScale or Vector3.new(1, 1, 1)
    pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
    mesh.Parent = part
    return mesh
end

local function createDaggerReplacementMeshPart(anchor, profile)
    if not (anchor and anchor:IsA("BasePart")) then return false end
    if anchor:GetAttribute("__LionDaggerReplacementMeshPart") then return true end

    local parent = anchor.Parent
    if not parent then return false end
    local originalName = anchor.Name
    anchor.Name = "__LionDaggerAnchor_" .. originalName

    local replacement = Instance.new("Part")
    replacement.Name = originalName
    replacement.Size = Vector3.new(1, 1, 1)
    replacement.CFrame = anchor.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
    replacement.Anchored = anchor.Anchored
    replacement.CanCollide = false
    replacement.CanTouch = false
    replacement.CanQuery = false
    replacement.Massless = true
    replacement.Color = Color3.fromRGB(255, 255, 255)
    pcall(function() replacement.Material = anchor.Material end)
    pcall(function() replacement.CastShadow = false end)
    replacement:SetAttribute("__LionCustomDaggerMesh", true)
    replacement:SetAttribute("__LionDaggerReplacementMeshPart", true)
    replacement:SetAttribute("IgnoreTransparency", true)
    addReplacementSpecialMesh(replacement, profile)
    local wrapGroup = anchor:GetAttribute("WrapGroup")
    if wrapGroup ~= nil then
        replacement:SetAttribute("WrapGroup", wrapGroup)
    end
    pcall(function()
        if collectionService:HasTag(anchor, "Wrappable") then
            collectionService:AddTag(replacement, "Wrappable")
        end
    end)
    replacement.Parent = parent

    local weld = Instance.new("WeldConstraint")
    weld.Name = "__LionDaggerReplacementWeld"
    weld.Part0 = anchor
    weld.Part1 = replacement
    weld.Parent = replacement

    hideDaggerMeshAnchor(anchor)
    return true
end

local function applyMeshReplacementToObject(obj, profile)
    if typeof(obj) ~= "Instance" then return false end
    if obj:GetAttribute("__LionDaggerReplacementMeshPart") or obj:GetAttribute("__LionDaggerHiddenAnchor") then
        return false
    end
    local part = getMeshLikePart(obj)
    if obj:IsA("MeshPart") then
        return createDaggerReplacementMeshPart(obj, profile)
    elseif obj:IsA("SpecialMesh") then
        if part then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
            part.Color = Color3.fromRGB(255, 255, 255)
            pcall(function() part.CastShadow = false end)
            if profile.ReplacementRotation then
                part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
            end
        end
        pcall(function() obj.MeshId = profile.ReplacementMeshId end)
        pcall(function() obj.TextureId = profile.ReplacementTextureId or "" end)
        if profile.ReplacementSize then
            pcall(function() obj.Scale = profile.ReplacementSize end)
        end
        obj:SetAttribute("__LionCustomDaggerMesh", true)
        return true
    end
    return false
end

local function getDaggerMeshSignature(profile)
    local size = profile.ReplacementSize or Vector3.zero
    local rotation = profile.ReplacementRotation or Vector3.zero
    return table.concat({
        table.concat(profile.SourceMeshIds or {}, ","),
        tostring(profile.ReplacementMeshId or ""),
        tostring(profile.ReplacementTextureId or ""),
        tostring(size.X),
        tostring(size.Y),
        tostring(size.Z),
        tostring(rotation.X),
        tostring(rotation.Y),
        tostring(rotation.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

local function applyDaggerMeshProfile(root, profile)
    if typeof(root) ~= "Instance" or not profile then return false end
    local signature = getDaggerMeshSignature(profile)
    if root:GetAttribute("__LionDaggerMeshSkin") == profile.Skin
        and root:GetAttribute("__LionDaggerMeshSignature") == signature then
        return true
    end

    local replaced, seen = 0, {}
    local function replaceIfTarget(obj)
        if seen[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
        seen[obj] = true
        if applyMeshReplacementToObject(obj, profile) then
            replaced += 1
        end
    end

    replaceIfTarget(root)
    for _, obj in ipairs(root:GetDescendants()) do
        replaceIfTarget(obj)
    end

    for _, bodyName in ipairs(profile.FallbackBodyNames or {}) do
        for _, obj in ipairs(root:GetDescendants()) do
            if obj.Name == bodyName then
                local target = obj:FindFirstChild("MeshPart")
                if target and not seen[target] and target:IsA("MeshPart") then
                    seen[target] = true
                    if applyMeshReplacementToObject(target, profile) then
                        replaced += 1
                    end
                end
            end
        end
    end

    root:SetAttribute("__LionDaggerMeshSkin", profile.Skin)
    root:SetAttribute("__LionDaggerMeshSignature", signature)
    root:SetAttribute("__LionDaggerMeshCount", replaced)
    return replaced > 0
end

local function hideSatchelMeshAnchor(part)
    if not (part and part:IsA("BasePart")) then return end
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function() part.CastShadow = false end)
    pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
    part:SetAttribute("__LionSatchelHiddenAnchor", true)
    part:SetAttribute("IgnoreObject", true)
    part:SetAttribute("IgnoreTransparency", true)
    pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
    if part:IsA("MeshPart") then
        pcall(function() part.TextureID = "" end)
        pcall(function() part.MeshId = "" end)
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        elseif child:IsA("SpecialMesh") then
            child.Scale = Vector3.zero
            pcall(function() child.MeshId = "" end)
            pcall(function() child.TextureId = "" end)
        end
    end
end

local function getReplacementAverageCFrame(parts)
    local first = parts and parts[1]
    if not first then return CFrame.identity end
    local position = Vector3.zero
    for _, part in ipairs(parts) do
        position += part.Position
    end
    position /= #parts
    return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

local function createSatchelReplacementMeshPart(root, profile, anchors)
    local anchor = anchors and anchors[1]
    if not (anchor and anchor:IsA("BasePart")) then return false end
    local parent = anchor.Parent
    if not parent then return false end

    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:GetAttribute("__LionSatchelReplacementMeshPart") then
            descendant:Destroy()
        end
    end

    local replacement = Instance.new("Part")
    replacement.Name = "__LionCustomSatchelReplacement"
    replacement.Size = Vector3.new(1, 1, 1)
    replacement.CFrame = getReplacementAverageCFrame(anchors)
        * CFrame.new(profile.ReplacementOffset or Vector3.zero)
        * rotationCFrameFromDegrees(profile.ReplacementRotation)
    replacement.Anchored = anchor.Anchored
    replacement.CanCollide = false
    replacement.CanTouch = false
    replacement.CanQuery = false
    replacement.Massless = true
    replacement.Color = Color3.fromRGB(255, 255, 255)
    pcall(function() replacement.Material = anchor.Material end)
    pcall(function() replacement.CastShadow = false end)
    replacement:SetAttribute("__LionCustomSatchelMesh", true)
    replacement:SetAttribute("__LionSatchelReplacementMeshPart", true)
    replacement:SetAttribute("IgnoreTransparency", true)
    addReplacementSpecialMesh(replacement, profile, Vector3.new(1, 1, 1))
    local wrapGroup = anchor:GetAttribute("WrapGroup")
    if wrapGroup ~= nil then
        replacement:SetAttribute("WrapGroup", wrapGroup)
    end
    pcall(function()
        if collectionService:HasTag(anchor, "Wrappable") then
            collectionService:AddTag(replacement, "Wrappable")
        end
    end)
    replacement.Parent = parent

    local weld = Instance.new("WeldConstraint")
    weld.Name = "__LionSatchelReplacementWeld"
    weld.Part0 = anchor
    weld.Part1 = replacement
    weld.Parent = replacement

    for _, part in ipairs(anchors) do
        if part and part.Parent then
            if not part.Name:find("__LionSatchelAnchor_", 1, true) then
                part.Name = "__LionSatchelAnchor_" .. part.Name
            end
            hideSatchelMeshAnchor(part)
        end
    end
    return true
end

local function applySatchelReplacementToObject(obj, profile)
    if typeof(obj) ~= "Instance" then return false end
    if obj:GetAttribute("__LionSatchelReplacementMeshPart") then return false end
    local part = getMeshLikePart(obj)
    if part and part:GetAttribute("__LionSatchelHiddenAnchor") then return false end
    return part and createSatchelReplacementMeshPart(part.Parent or part, profile, { part }) or false
end

local function getSatchelMeshSignature(profile)
    local rotation = profile.ReplacementRotation or Vector3.zero
    local offset = profile.ReplacementOffset or Vector3.zero
    local size = profile.ReplacementSize or Vector3.zero
    return table.concat({
        table.concat(profile.SourceMeshIds or {}, ","),
        tostring(profile.ReplacementMeshId or ""),
        tostring(profile.ReplacementTextureId or ""),
        tostring(size.X),
        tostring(size.Y),
        tostring(size.Z),
        tostring(offset.X),
        tostring(offset.Y),
        tostring(offset.Z),
        tostring(rotation.X),
        tostring(rotation.Y),
        tostring(rotation.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

local function applySatchelMeshProfile(root, profile)
    if typeof(root) ~= "Instance" or not profile then return false end
    local signature = getSatchelMeshSignature(profile)
    if root:GetAttribute("__LionSatchelMeshSkin") == profile.Skin
        and root:GetAttribute("__LionSatchelMeshSignature") == signature then
        return true
    end

    local bodyParts, seenObjects, seenParts = {}, {}, {}
    local function replaceIfTarget(obj)
        if seenObjects[obj] or not meshMatchesAnyAssetId(obj, profile.SourceMeshIds) then return end
        seenObjects[obj] = true
        local part = getMeshLikePart(obj)
        if part and not seenParts[part] then
            seenParts[part] = true
            table.insert(bodyParts, part)
        end
    end

    replaceIfTarget(root)
    for _, obj in ipairs(root:GetDescendants()) do
        replaceIfTarget(obj)
    end

    local replaced = createSatchelReplacementMeshPart(root, profile, bodyParts) and 1 or 0

    root:SetAttribute("__LionSatchelMeshSkin", profile.Skin)
    root:SetAttribute("__LionSatchelMeshSignature", signature)
    root:SetAttribute("__LionSatchelMeshCount", replaced)
    return replaced > 0
end

local function getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
    local profile = SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName]
    if profile and worldAsset and (
        profile.WorldSourceMeshIds
        or profile.WorldReplacementMeshId
        or profile.WorldReplacementTextureId
        or profile.WorldReplacementSize
        or profile.WorldReplacementRotation
        or profile.WorldReplacementOffset
    ) then
        local worldProfile = table.clone(profile)
        worldProfile.SourceMeshIds = profile.WorldSourceMeshIds or profile.SourceMeshIds
        worldProfile.ReplacementMeshId = profile.WorldReplacementMeshId or profile.ReplacementMeshId
        worldProfile.ReplacementTextureId = profile.WorldReplacementTextureId or profile.ReplacementTextureId
        worldProfile.ReplacementSize = profile.WorldReplacementSize or profile.ReplacementSize
        worldProfile.ReplacementRotation = profile.WorldReplacementRotation or profile.ReplacementRotation
        worldProfile.ReplacementOffset = profile.WorldReplacementOffset or profile.ReplacementOffset
        return worldProfile
    end
    return profile
end

local function hideRpgMeshPart(part)
    if not (part and part:IsA("BasePart")) then return false end
    if part:GetAttribute("__LionRpgHiddenPart") then return true end
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function() part.CastShadow = false end)
    pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
    part:SetAttribute("__LionRpgHiddenPart", true)
    part:SetAttribute("IgnoreObject", true)
    part:SetAttribute("IgnoreTransparency", true)
    part:SetAttribute("WrapGroup", 0)
    pcall(function() part:RemoveTag("Wrappable") end)
    pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
    if part:IsA("MeshPart") then
        pcall(function() part.TextureID = "" end)
        pcall(function() part.MeshId = "" end)
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        elseif child:IsA("SpecialMesh") then
            child.Scale = Vector3.zero
            pcall(function() child.MeshId = "" end)
            pcall(function() child.TextureId = "" end)
        elseif child:IsA("Highlight") then
            child.Enabled = false
        end
    end
    return true
end

local function applyRpgMeshReplacement(obj, meshId, textureId, profile)
    local part = getMeshLikePart(obj)
    if not part or part:GetAttribute("__LionRpgHiddenPart") then return false end
    part.Transparency = 0
    part.LocalTransparencyModifier = 0
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    part:SetAttribute("__LionCustomRpgMesh", true)
    part:SetAttribute("IgnoreTransparency", true)
    if not part:GetAttribute("__LionRpgReplacementAdjusted") then
        local scale = tonumber(profile and profile.ReplacementScale) or 1
        if scale ~= 1 then
            pcall(function()
                part.Size = part.Size * scale
            end)
        end
        if profile and profile.ReplacementOffset then
            pcall(function()
                part.CFrame = part.CFrame * CFrame.new(profile.ReplacementOffset)
            end)
        end
        if profile and profile.ReplacementRotation then
            pcall(function()
                part.CFrame = part.CFrame * rotationCFrameFromDegrees(profile.ReplacementRotation)
            end)
        end
        part:SetAttribute("__LionRpgReplacementAdjusted", true)
    end
    if obj:IsA("MeshPart") then
        pcall(function() obj.MeshId = meshId end)
        pcall(function() obj.TextureID = textureId or "" end)
        return true
    elseif obj:IsA("SpecialMesh") then
        pcall(function() obj.MeshType = Enum.MeshType.FileMesh end)
        pcall(function() obj.MeshId = meshId end)
        pcall(function() obj.TextureId = textureId or "" end)
        pcall(function() obj.VertexColor = Vector3.new(1, 1, 1) end)
        return true
    end
    return false
end

local function getRpgMeshSignature(profile)
    local rotation = profile.ReplacementRotation or Vector3.zero
    local offset = profile.ReplacementOffset or Vector3.zero
    return table.concat({
        table.concat(profile.BodyMeshIds or {}, ","),
        table.concat(profile.JuggleMeshIds or {}, ","),
        table.concat(profile.RocketMeshIds or {}, ","),
        tostring(profile.BodyReplacementMeshId or ""),
        tostring(profile.BodyReplacementTextureId or ""),
        tostring(profile.ReplacementScale or 1),
        tostring(rotation.X),
        tostring(rotation.Y),
        tostring(rotation.Z),
        tostring(offset.X),
        tostring(offset.Y),
        tostring(offset.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

local function applyRpgMeshProfile(root, profile, options)
    if typeof(root) ~= "Instance" or not profile then return false end
    options = options or {}
    local signature = getRpgMeshSignature(profile)
    if root:GetAttribute("__LionRpgMeshSkin") == profile.Skin
        and root:GetAttribute("__LionRpgMeshSignature") == signature
        and root:GetAttribute("__LionRpgRocketVisible") == false then
        return true
    end

    local changed, removed, seen = 0, 0, {}
    local function applyIfTarget(obj)
        if seen[obj] then return end
        if not (meshMatchesAnyAssetId(obj, profile.BodyMeshIds)
            or meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)
            or meshMatchesAnyAssetId(obj, profile.RocketMeshIds)) then
            return
        end
        seen[obj] = true
        local part = getMeshLikePart(obj)
        if not part then return end
        if (namePathContains(obj, "rocket") and meshMatchesAnyAssetId(obj, profile.RocketMeshIds))
            or (namePathContains(obj, "juggle") and meshMatchesAnyAssetId(obj, profile.JuggleMeshIds)) then
            if hideRpgMeshPart(part) then removed += 1 end
        elseif meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
            if applyRpgMeshReplacement(obj, profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
                changed += 1
            end
        end
    end

    applyIfTarget(root)
    for _, obj in ipairs(root:GetDescendants()) do
        applyIfTarget(obj)
    end

    root:SetAttribute("__LionRpgMeshSkin", profile.Skin)
    root:SetAttribute("__LionRpgMeshSignature", signature)
    root:SetAttribute("__LionRpgRocketVisible", false)
    root:SetAttribute("__LionRpgMeshCount", changed)
    root:SetAttribute("__LionRpgHiddenCount", removed)
    return changed > 0 or removed > 0
end

local function createFistsReplacementPart(part, meshId, textureId, meshScale, rotation)
    if not (part and part:IsA("BasePart")) then return false end
    for _, child in ipairs(part:GetChildren()) do
        child:Destroy()
    end

    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    part:SetAttribute("__LionFistsHiddenAnchor", true)
    part:SetAttribute("IgnoreTransparency", true)

    local replacement = Instance.new("Part")
    replacement.Name = "__LionCustomFistsMesh"
    replacement.Size = part.Size
    replacement.CFrame = part.CFrame * rotationCFrameFromDegrees(rotation)
    replacement.Anchored = false
    replacement.CanCollide = false
    replacement.CanTouch = false
    replacement.CanQuery = false
    replacement.Massless = true
    replacement.Transparency = 0
    replacement.LocalTransparencyModifier = 0
    replacement:SetAttribute("__LionCustomFistsMesh", true)
    replacement:SetAttribute("IgnoreTransparency", true)
    replacement.Parent = part

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = meshId
    pcall(function() mesh.TextureId = textureId or "" end)
    mesh.Scale = meshScale or Vector3.new(0.1, 0.1, 0.1)
    pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
    mesh.Parent = replacement

    local weld = Instance.new("WeldConstraint")
    weld.Name = "__LionCustomFistsMeshWeld"
    weld.Part0 = part
    weld.Part1 = replacement
    weld.Parent = replacement
    return true
end

local function getFistsMeshSignature(profile)
    local scale = profile.MeshScale or Vector3.zero
    local leftRotation = profile.LeftRotation or Vector3.zero
    local rightRotation = profile.RightRotation or Vector3.zero
    return table.concat({
        tostring(profile.LeftMeshId or ""),
        tostring(profile.LeftTextureId or ""),
        tostring(profile.RightMeshId or ""),
        tostring(profile.RightTextureId or ""),
        tostring(scale.X),
        tostring(scale.Y),
        tostring(scale.Z),
        tostring(leftRotation.X),
        tostring(leftRotation.Y),
        tostring(leftRotation.Z),
        tostring(rightRotation.X),
        tostring(rightRotation.Y),
        tostring(rightRotation.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

local function applyFistsMeshProfile(root, profile)
    if typeof(root) ~= "Instance" or not profile then return false end
    local signature = getFistsMeshSignature(profile)
    if root:GetAttribute("__LionFistsMeshSkin") == profile.Skin
        and root:GetAttribute("__LionFistsMeshSignature") == signature
        and (root:GetAttribute("__LionFistsMeshCount") or 0) > 0 then
        return true
    end

    local left = findDescendantByName(root, profile.LeftPartName or "LeftItem")
    local right = findDescendantByName(root, profile.RightPartName or "RightItem")
    local applied = 0
    if createFistsReplacementPart(left, profile.LeftMeshId, profile.LeftTextureId, profile.MeshScale, profile.LeftRotation) then
        applied += 1
    end
    if createFistsReplacementPart(right, profile.RightMeshId, profile.RightTextureId, profile.MeshScale, profile.RightRotation) then
        applied += 1
    end

    root:SetAttribute("__LionFistsMeshSkin", profile.Skin)
    root:SetAttribute("__LionFistsMeshSignature", signature)
    root:SetAttribute("__LionFistsMeshCount", applied)
    return applied > 0
end

local function hideBowMeshAnchor(part)
    if not (part and part:IsA("BasePart")) then return false end
    if part:GetAttribute("__LionBowHiddenAnchor") then return true end
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function() part.CastShadow = false end)
    pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
    part:SetAttribute("__LionBowHiddenAnchor", true)
    part:SetAttribute("IgnoreObject", true)
    part:SetAttribute("IgnoreTransparency", true)
    pcall(function() part:RemoveTag("Wrappable") end)
    pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
    if part:IsA("MeshPart") then
        pcall(function() part.TextureID = "" end)
        pcall(function() part.MeshId = "" end)
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        elseif child:IsA("SpecialMesh") then
            child.Scale = Vector3.zero
            pcall(function() child.MeshId = "" end)
            pcall(function() child.TextureId = "" end)
        elseif child:IsA("Highlight") then
            child.Enabled = false
        end
    end
    return true
end

local function createBowReplacementMeshPart(root, anchors, replacementName, meshId, textureId, profile)
    local anchor = anchors and anchors[1]
    if not (anchor and anchor:IsA("BasePart")) then return false end
    local parent = anchor.Parent or root
    if not parent then return false end

    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:GetAttribute("__LionBowReplacementMeshPart") and descendant.Name == replacementName then
            descendant:Destroy()
        end
    end

    local replacement = Instance.new("Part")
    replacement.Name = replacementName
    replacement.Size = Vector3.new(1, 1, 1)
    replacement.CFrame = getReplacementAverageCFrame(anchors)
    replacement.Anchored = anchor.Anchored
    replacement.CanCollide = false
    replacement.CanTouch = false
    replacement.CanQuery = false
    replacement.Massless = true
    replacement.Transparency = 0
    replacement.LocalTransparencyModifier = 0
    replacement:SetAttribute("__LionCustomBowMesh", true)
    replacement:SetAttribute("__LionBowReplacementMeshPart", true)
    replacement:SetAttribute("IgnoreTransparency", true)

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = meshId
    pcall(function() mesh.TextureId = textureId or "" end)
    mesh.Scale = profile.ReplacementSize or Vector3.new(0.5, 0.5, 0.5)
    pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
    mesh.Parent = replacement

    local wrapGroup = anchor:GetAttribute("WrapGroup")
    if wrapGroup ~= nil then
        replacement:SetAttribute("WrapGroup", wrapGroup)
    end
    pcall(function()
        if collectionService:HasTag(anchor, "Wrappable") then
            collectionService:AddTag(replacement, "Wrappable")
        end
    end)
    replacement.Parent = parent

    if not replacement.Anchored then
        local weld = Instance.new("WeldConstraint")
        weld.Name = "__LionBowReplacementWeld"
        weld.Part0 = anchor
        weld.Part1 = replacement
        weld.Parent = replacement
    end

    for _, part in ipairs(anchors) do
        hideBowMeshAnchor(part)
    end
    return true
end

local function getBowMeshSignature(profile)
    local size = profile.ReplacementSize or Vector3.zero
    return table.concat({
        table.concat(profile.BodyMeshIds or {}, ","),
        table.concat(profile.ArrowMeshIds or {}, ","),
        tostring(profile.BodyReplacementMeshId or ""),
        tostring(profile.BodyReplacementTextureId or ""),
        tostring(profile.ArrowReplacementMeshId or ""),
        tostring(profile.ArrowReplacementTextureId or ""),
        tostring(size.X),
        tostring(size.Y),
        tostring(size.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

local function applyBowMeshProfile(root, profile)
    if typeof(root) ~= "Instance" or not profile then return false end
    local signature = getBowMeshSignature(profile)
    if root:GetAttribute("__LionBowMeshSkin") == profile.Skin
        and root:GetAttribute("__LionBowMeshSignature") == signature
        and (root:GetAttribute("__LionBowMeshCount") or 0) > 0 then
        return true
    end

    local bodyParts, arrowParts, seenParts = {}, {}, {}
    local function collectIfTarget(obj)
        local part = getMeshLikePart(obj)
        if not part or seenParts[part] then return end
        if meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
            seenParts[part] = true
            table.insert(bodyParts, part)
        elseif meshMatchesAnyAssetId(obj, profile.ArrowMeshIds) then
            seenParts[part] = true
            table.insert(arrowParts, part)
        end
    end

    collectIfTarget(root)
    for _, obj in ipairs(root:GetDescendants()) do
        collectIfTarget(obj)
    end

    local applied = 0
    if createBowReplacementMeshPart(root, bodyParts, "__LionCustomBowBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, profile) then
        applied += 1
    end
    if createBowReplacementMeshPart(root, arrowParts, "__LionCustomBowArrow", profile.ArrowReplacementMeshId, profile.ArrowReplacementTextureId, profile) then
        applied += 1
    end

    root:SetAttribute("__LionBowMeshSkin", profile.Skin)
    root:SetAttribute("__LionBowMeshSignature", signature)
    root:SetAttribute("__LionBowMeshCount", applied)
    return applied > 0
end

local function hideAssaultRifleMeshAnchor(part, anchorType)
    if not (part and part:IsA("BasePart")) then return false end
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function() part.CastShadow = false end)
    pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
    part:SetAttribute("__LionAssaultRifleHiddenAnchor", true)
    part:SetAttribute("__LionAssaultRifleAnchorType", anchorType or "Part")
    part:SetAttribute("IgnoreObject", true)
    part:SetAttribute("IgnoreTransparency", true)
    pcall(function() part:RemoveTag("Wrappable") end)
    pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
    if part:IsA("MeshPart") then
        pcall(function() part.TextureID = "" end)
        pcall(function() part.MeshId = "" end)
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        elseif child:IsA("SpecialMesh") then
            child.Scale = Vector3.zero
            pcall(function() child.MeshId = "" end)
            pcall(function() child.TextureId = "" end)
        elseif child:IsA("Highlight") then
            child.Enabled = false
        end
    end
    return true
end

local function createAssaultRifleReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
    if not (anchor and anchor:IsA("BasePart")) then return false end
    local parent = anchor.Parent or root
    if not parent then return false end

    local replacement = Instance.new("MeshPart")
    replacement.Name = replacementName
    replacement.Size = profile.ReplacementSize or Vector3.new(0.35, 0.35, 0.35)
    replacement.CFrame = cframe or anchor.CFrame
    replacement.Anchored = anchor.Anchored
    replacement.CanCollide = false
    replacement.CanTouch = false
    replacement.CanQuery = false
    replacement.Massless = true
    replacement.Transparency = 0
    replacement.LocalTransparencyModifier = 0
    replacement.Color = Color3.fromRGB(255, 255, 255)
    pcall(function() replacement.MeshId = meshId end)
    pcall(function() replacement.TextureID = textureId or "" end)
    pcall(function() replacement.Material = anchor.Material end)
    pcall(function() replacement.CastShadow = false end)
    replacement:SetAttribute("__LionCustomAssaultRifleMesh", true)
    replacement:SetAttribute("__LionAssaultRifleReplacementMeshPart", true)
    replacement:SetAttribute("IgnoreTransparency", true)

    local wrapGroup = anchor:GetAttribute("WrapGroup")
    if wrapGroup ~= nil then
        replacement:SetAttribute("WrapGroup", wrapGroup)
    end
    pcall(function()
        if collectionService:HasTag(anchor, "Wrappable") then
            collectionService:AddTag(replacement, "Wrappable")
        end
    end)
    replacement.Parent = parent

    if not replacement.Anchored then
        local weld = Instance.new("WeldConstraint")
        weld.Name = "__LionAssaultRifleReplacementWeld"
        weld.Part0 = anchor
        weld.Part1 = replacement
        weld.Parent = replacement
    end

    return true
end

local function getAssaultRifleMeshSignature(profile)
    local size = profile.ReplacementSize or Vector3.zero
    local replacementOffset = profile.ReplacementOffset or Vector3.zero
    local magazineOffset = profile.MagazineOffset or Vector3.zero
    return table.concat({
        table.concat(profile.BodyMeshIds or {}, ","),
        table.concat(profile.BoltMeshIds or {}, ","),
        table.concat(profile.MagazineMeshIds or {}, ","),
        table.concat(profile.ReloadMagazineMeshIds or {}, ","),
        tostring(profile.BodyReplacementMeshId or ""),
        tostring(profile.BodyReplacementTextureId or ""),
        tostring(profile.MagazineReplacementMeshId or ""),
        tostring(profile.MagazineReplacementTextureId or ""),
        tostring(profile.ReloadMagazineReplacementMeshId or ""),
        tostring(profile.ReloadMagazineReplacementTextureId or ""),
        tostring(size.X),
        tostring(size.Y),
        tostring(size.Z),
        tostring(replacementOffset.X),
        tostring(replacementOffset.Y),
        tostring(replacementOffset.Z),
        tostring(magazineOffset.X),
        tostring(magazineOffset.Y),
        tostring(magazineOffset.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

local function applyAssaultRifleMeshProfile(root, profile)
    if typeof(root) ~= "Instance" or not profile then return false end
    local signature = getAssaultRifleMeshSignature(profile)
    if root:GetAttribute("__LionAssaultRifleMeshSkin") == profile.Skin
        and root:GetAttribute("__LionAssaultRifleMeshSignature") == signature
        and (root:GetAttribute("__LionAssaultRifleMeshCount") or 0) > 0 then
        return true
    end

    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:GetAttribute("__LionAssaultRifleReplacementMeshPart") then
            descendant:Destroy()
        end
    end

    local bodyParts, magazineParts, reloadMagazineParts, boltParts, seenParts = {}, {}, {}, {}, {}
    local function collectIfTarget(obj)
        local part = getMeshLikePart(obj)
        if not part or seenParts[part] then return end
        local previousType = part:GetAttribute("__LionAssaultRifleAnchorType")
        local isReloadMagazine = previousType == "ReloadMagazine"
            or (meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) and namePathContains(obj, "reload"))
        if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
            seenParts[part] = true
            table.insert(bodyParts, part)
        elseif isReloadMagazine then
            seenParts[part] = true
            table.insert(reloadMagazineParts, part)
        elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) or meshMatchesAnyAssetId(obj, profile.ReloadMagazineMeshIds) then
            seenParts[part] = true
            table.insert(magazineParts, part)
        elseif previousType == "Bolt" or meshMatchesAnyAssetId(obj, profile.BoltMeshIds) then
            seenParts[part] = true
            table.insert(boltParts, part)
        end
    end

    collectIfTarget(root)
    for _, obj in ipairs(root:GetDescendants()) do
        collectIfTarget(obj)
    end

    local bodyAnchor = bodyParts[1] or magazineParts[1] or boltParts[1]
    local magazineAnchor = magazineParts[1] or bodyAnchor
    local reloadMagazineAnchor = reloadMagazineParts[1] or magazineAnchor
    local bodyCFrame = bodyParts[1] and getReplacementAverageCFrame(bodyParts) or (bodyAnchor and bodyAnchor.CFrame) or CFrame.identity
    local reloadMagazineCFrame = reloadMagazineParts[1] and getReplacementAverageCFrame(reloadMagazineParts) or bodyCFrame
    local replacementOffset = profile.ReplacementOffset or Vector3.zero
    local magazineOffset = profile.MagazineOffset or Vector3.zero
    bodyCFrame = bodyCFrame * CFrame.new(replacementOffset)
    reloadMagazineCFrame = reloadMagazineCFrame * CFrame.new(replacementOffset)
    local applied = 0
    if createAssaultRifleReplacementMeshPart(root, bodyAnchor, "__LionCustomAssaultRifleBody", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
        applied += 1
    end
    if createAssaultRifleReplacementMeshPart(root, magazineAnchor, "__LionCustomAssaultRifleMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, bodyCFrame * CFrame.new(magazineOffset), profile) then
        applied += 1
    end
    if reloadMagazineParts[1] and createAssaultRifleReplacementMeshPart(root, reloadMagazineAnchor, "__LionCustomAssaultRifleReloadMagazine", profile.ReloadMagazineReplacementMeshId or profile.MagazineReplacementMeshId, profile.ReloadMagazineReplacementTextureId or profile.MagazineReplacementTextureId, reloadMagazineCFrame, profile) then
        applied += 1
    end

    for _, part in ipairs(bodyParts) do
        hideAssaultRifleMeshAnchor(part, "Body")
    end
    for _, part in ipairs(magazineParts) do
        hideAssaultRifleMeshAnchor(part, "Magazine")
    end
    for _, part in ipairs(reloadMagazineParts) do
        hideAssaultRifleMeshAnchor(part, "ReloadMagazine")
    end
    for _, part in ipairs(boltParts) do
        hideAssaultRifleMeshAnchor(part, "Bolt")
    end

    root:SetAttribute("__LionAssaultRifleMeshSkin", profile.Skin)
    root:SetAttribute("__LionAssaultRifleMeshSignature", signature)
    root:SetAttribute("__LionAssaultRifleMeshCount", applied)
    return applied > 0
end

function __LionHideSniperMeshAnchor(part, anchorType)
    if not (part and part:IsA("BasePart")) then return false end
    part.Transparency = 1
    part.LocalTransparencyModifier = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    pcall(function() part.CastShadow = false end)
    pcall(function() part.Material = Enum.Material.SmoothPlastic end)
    pcall(function() part.Reflectance = 0 end)
    pcall(function() part.Size = Vector3.new(0.001, 0.001, 0.001) end)
    part:SetAttribute("__LionHiddenSniperMesh", true)
    part:SetAttribute("__LionCustomSniperHiddenPart", true)
    part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
    part:SetAttribute("IgnoreObject", true)
    part:SetAttribute("IgnoreTransparency", true)
    part:SetAttribute("WrapGroup", 0)
    pcall(function() part:RemoveTag("Wrappable") end)
    pcall(function() collectionService:RemoveTag(part, "Wrappable") end)
    if part:IsA("MeshPart") then
        pcall(function() part.TextureID = "" end)
        pcall(function() part.MeshId = "" end)
    end
    for _, child in ipairs(part:GetDescendants()) do
        if child:IsA("Decal") or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("SurfaceAppearance") then
            child:Destroy()
        elseif child:IsA("SpecialMesh") then
            child.Scale = Vector3.zero
            pcall(function() child.MeshId = "" end)
            pcall(function() child.TextureId = "" end)
        elseif child:IsA("Highlight") then
            child.Enabled = false
        end
    end
    return true
end

function __LionOffsetSniperVisibleAnchor(part, anchorType, offset)
    if not (part and part:IsA("BasePart")) then return false end
    local originalCFrame = part:GetAttribute("__LionSniperOriginalCFrame")
    if typeof(originalCFrame) ~= "CFrame" then
        originalCFrame = part.CFrame
        part:SetAttribute("__LionSniperOriginalCFrame", originalCFrame)
    end
    part.CFrame = originalCFrame * CFrame.new(offset or Vector3.zero)
    part:SetAttribute("__LionSniperAnchorType", anchorType or "Part")
    part:SetAttribute("__LionSniperVisibleOffset", true)
    return true
end

local function hideSniperMeshId(root, assetId)
    local parts = {}
    if typeof(root) ~= "Instance" or not assetId then return parts end
    local seen = {}

    local function hideIfMatch(obj)
        if not meshMatchesAssetId(obj, assetId) then return end
        local part = getMeshLikePart(obj)
        if part and not seen[part] then
            seen[part] = true
            if __LionHideSniperMeshAnchor(part) then
                table.insert(parts, part)
            end
        elseif obj:IsA("SpecialMesh") then
            obj.Scale = Vector3.zero
        end
    end

    hideIfMatch(root)
    for _, obj in ipairs(root:GetDescendants()) do
        hideIfMatch(obj)
    end
    return parts
end

local function getAverageCFrame(parts)
    local first = parts[1]
    if not first then return CFrame.identity end
    local position = Vector3.zero
    for _, part in ipairs(parts) do
        position += part.Position
    end
    position /= #parts
    return CFrame.new(position) * (first.CFrame - first.CFrame.Position)
end

function __LionCreateSniperReplacementMeshPart(root, anchor, replacementName, meshId, textureId, cframe, profile)
    if not (anchor and anchor:IsA("BasePart")) then return false end
    local parent = anchor.Parent or root
    if not parent then return false end

    local replacement = Instance.new("MeshPart")
    replacement.Name = replacementName
    pcall(function() replacement.MeshId = meshId end)
    pcall(function() replacement.TextureID = textureId or "" end)
    replacement.Size = profile.ReplacementSize or Vector3.new(0.05, 0.05, 0.05)
    replacement.CFrame = cframe or anchor.CFrame
    replacement.Anchored = anchor.Anchored
    replacement.CanCollide = false
    replacement.CanTouch = false
    replacement.CanQuery = false
    replacement.Massless = true
    replacement.Transparency = 0
    replacement.LocalTransparencyModifier = 0
    replacement.Color = Color3.fromRGB(255, 255, 255)
    pcall(function() replacement.Material = anchor.Material end)
    pcall(function() replacement.CastShadow = false end)
    replacement:SetAttribute("__LionCustomSniperReplacement", true)
    replacement:SetAttribute("WrapGroup", 1)
    replacement:SetAttribute("IgnoreTransparency", true)
    pcall(function() replacement:AddTag("Wrappable") end)
    pcall(function() collectionService:AddTag(replacement, "Wrappable") end)
    replacement.Parent = parent

    if not replacement.Anchored then
        local weld = Instance.new("WeldConstraint")
        weld.Name = "__LionCustomSniperReplacementWeld"
        weld.Part0 = anchor
        weld.Part1 = replacement
        weld.Parent = replacement
    end
    return true
end

local function setupSniperReplacementPart(root, profile, bodyParts)
    local anchor = bodyParts[1]
    if not anchor then return false end
    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:GetAttribute("__LionCustomSniperReplacement") then
            descendant:Destroy()
        end
    end

    return __LionCreateSniperReplacementMeshPart(
        root,
        anchor,
        "__LionCustomSniperReplacement",
        profile.ReplacementMeshId,
        profile.ReplacementTextureId,
        getAverageCFrame(bodyParts) * CFrame.new(profile.ReplacementOffset or Vector3.zero),
        profile
    )
end

local function getSniperMeshSignature(profile)
    local body = table.concat(profile.BodyMeshIds or {}, ",")
    local remove = table.concat(profile.RemoveMeshIds or {}, ",")
    local magazine = table.concat(profile.MagazineMeshIds or {}, ",")
    local bullet = table.concat(profile.BulletMeshIds or {}, ",")
    local size = profile.ReplacementSize or Vector3.zero
    local offset = profile.ReplacementOffset or Vector3.zero
    local bulletOffset = profile.BulletOffset or Vector3.zero
    return table.concat({
        body,
        remove,
        magazine,
        bullet,
        tostring(profile.ReplacementMeshId or ""),
        tostring(profile.ReplacementTextureId or ""),
        tostring(profile.BodyReplacementMeshId or ""),
        tostring(profile.BodyReplacementTextureId or ""),
        tostring(profile.ScopeReplacementMeshId or ""),
        tostring(profile.ScopeReplacementTextureId or ""),
        tostring(profile.MagazineReplacementMeshId or ""),
        tostring(profile.MagazineReplacementTextureId or ""),
        tostring(size.X),
        tostring(size.Y),
        tostring(size.Z),
        tostring(offset.X),
        tostring(offset.Y),
        tostring(offset.Z),
        tostring((profile.ScopeOffset or Vector3.zero).X),
        tostring((profile.ScopeOffset or Vector3.zero).Y),
        tostring((profile.ScopeOffset or Vector3.zero).Z),
        tostring((profile.MagazineOffset or Vector3.zero).X),
        tostring((profile.MagazineOffset or Vector3.zero).Y),
        tostring((profile.MagazineOffset or Vector3.zero).Z),
        tostring(bulletOffset.X),
        tostring(bulletOffset.Y),
        tostring(bulletOffset.Z),
        tostring(profile.ReplacementVersion or 1)
    }, "|")
end

function __LionApplySniperMultiMeshProfile(root, profile)
    for _, descendant in ipairs(root:GetDescendants()) do
        if descendant:GetAttribute("__LionCustomSniperReplacement") then
            descendant:Destroy()
        end
    end

    local bodyParts, magazineParts, bulletParts, removeParts, seenParts = {}, {}, {}, {}, {}
    local function collectIfTarget(obj)
        local part = getMeshLikePart(obj)
        if not part or seenParts[part] then return end
        local previousType = part:GetAttribute("__LionSniperAnchorType")
        if previousType == "Body" or meshMatchesAnyAssetId(obj, profile.BodyMeshIds) then
            seenParts[part] = true
            table.insert(bodyParts, part)
        elseif previousType == "Magazine" or meshMatchesAnyAssetId(obj, profile.MagazineMeshIds) then
            seenParts[part] = true
            table.insert(magazineParts, part)
        elseif previousType == "Bullet" or meshMatchesAnyAssetId(obj, profile.BulletMeshIds) then
            seenParts[part] = true
            table.insert(bulletParts, part)
        elseif previousType == "Remove" or meshMatchesAnyAssetId(obj, profile.RemoveMeshIds) then
            seenParts[part] = true
            table.insert(removeParts, part)
        end
    end

    collectIfTarget(root)
    for _, obj in ipairs(root:GetDescendants()) do
        collectIfTarget(obj)
    end

    local bodyAnchor = bodyParts[1] or magazineParts[1]
    local magazineAnchor = magazineParts[1] or bodyAnchor
    if not bodyAnchor then return false end

    local offset = profile.ReplacementOffset or Vector3.zero
    local bodyCFrame = (bodyParts[1] and getReplacementAverageCFrame(bodyParts) or bodyAnchor.CFrame) * CFrame.new(offset)
    local scopeCFrame = bodyCFrame * CFrame.new(profile.ScopeOffset or Vector3.zero)
    local magazineCFrame = bodyCFrame * CFrame.new(profile.MagazineOffset or Vector3.zero)
    local applied = 0
    if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperReplacement", profile.BodyReplacementMeshId, profile.BodyReplacementTextureId, bodyCFrame, profile) then
        applied += 1
    end
    if __LionCreateSniperReplacementMeshPart(root, bodyAnchor, "__LionCustomSniperScope", profile.ScopeReplacementMeshId, profile.ScopeReplacementTextureId, scopeCFrame, profile) then
        applied += 1
    end
    if __LionCreateSniperReplacementMeshPart(root, magazineAnchor, "__LionCustomSniperMagazine", profile.MagazineReplacementMeshId, profile.MagazineReplacementTextureId, magazineCFrame, profile) then
        applied += 1
    end

    for _, part in ipairs(bodyParts) do
        __LionHideSniperMeshAnchor(part, "Body")
    end
    for _, part in ipairs(magazineParts) do
        __LionHideSniperMeshAnchor(part, "Magazine")
    end
    for _, part in ipairs(bulletParts) do
        __LionOffsetSniperVisibleAnchor(part, "Bullet", profile.BulletOffset or Vector3.zero)
    end
    for _, part in ipairs(removeParts) do
        __LionHideSniperMeshAnchor(part, "Remove")
    end
    return applied > 0
end

local function applySniperMeshProfile(root, profile)
    if typeof(root) ~= "Instance" or not profile then return false end
    local signature = getSniperMeshSignature(profile)
    if root:GetAttribute("__LionSniperMeshSkin") == profile.Skin
        and root:GetAttribute("__LionSniperMeshSignature") == signature then
        return true
    end

    local applied
    if profile.BodyReplacementMeshId or profile.ScopeReplacementMeshId or profile.MagazineReplacementMeshId then
        applied = __LionApplySniperMultiMeshProfile(root, profile)
        if not applied then return false end
        root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
        root:SetAttribute("__LionSniperMeshSignature", signature)
        return true
    end

    local bodyParts = {}
    for _, meshId in ipairs(profile.BodyMeshIds or {}) do
        for _, part in ipairs(hideSniperMeshId(root, meshId)) do
            table.insert(bodyParts, part)
        end
    end
    for _, meshId in ipairs(profile.RemoveMeshIds or {}) do
        hideSniperMeshId(root, meshId)
    end

    if not setupSniperReplacementPart(root, profile, bodyParts) then
        return false
    end
    root:SetAttribute("__LionSniperMeshSkin", profile.Skin)
    root:SetAttribute("__LionSniperMeshSignature", signature)
    return true
end

local function applyTripminePartVisual(part, profile)
    if not (part and part:IsA("BasePart")) then return end
    local color = profile.Color
    if color then
        part.Color = color
        part.BrickColor = BrickColor.new(color)
    end
    part.Material = profile.Material or Enum.Material.SmoothPlastic
    if profile.Reflectance then
        part.Reflectance = profile.Reflectance
    end
    part.Transparency = 0
    part.LocalTransparencyModifier = 0
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Massless = true
    if part:GetAttribute("WrapGroup") == nil then
        part:SetAttribute("WrapGroup", 1)
    end
    part:SetAttribute("IgnoreTransparency", true)
    pcall(function() part:AddTag("Wrappable") end)
    pcall(function() collectionService:AddTag(part, "Wrappable") end)
end

local function addTripmineExtraMeshPart(basePart, meshId, meshScale, profile, index)
    if not (basePart and basePart:IsA("BasePart") and basePart.Parent) then return nil end
    local overlay = Instance.new("Part")
    overlay.Name = "__LionCustomTripmineMeshExtra" .. tostring(index or "")
    overlay.Anchored = basePart.Anchored
    overlay.CFrame = basePart.CFrame
    overlay.Size = basePart.Size
    overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
    overlay:SetAttribute("__LionCustomTripmineExtraMesh", true)
    applyTripminePartVisual(overlay, profile)

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = meshId
    if profile.ClearTexture then
        pcall(function() mesh.TextureId = "" end)
    elseif profile.TextureId then
        pcall(function() mesh.TextureId = profile.TextureId end)
    end
    mesh.Scale = meshScale
    pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
    mesh.Parent = overlay
    overlay.Parent = basePart.Parent

    local weld = Instance.new("WeldConstraint")
    weld.Name = "__LionCustomTripmineMeshExtraWeld"
    weld.Part0 = basePart
    weld.Part1 = overlay
    weld.Parent = overlay
    return overlay
end

local function applyTripmineMeshProfile(root, profile, worldVisual)
    if typeof(root) ~= "Instance" then return false end
    if not profile then return false end
    local meshIds = getTripmineMeshIds(profile)
    if #meshIds == 0 then return false end
    local extraMeshScale = getTripmineExtraMeshScale(profile, worldVisual)
    local meshSignature = getTripmineMeshSignature(profile, worldVisual)
    local meshScale = (worldVisual and profile.WorldScale) or profile.Scale or 1
    if root:GetAttribute("__LionTripmineMeshSkin") == profile.Skin
        and root:GetAttribute("__LionCustomTripmineMeshIds") == meshSignature
        and root:GetAttribute("__LionCustomTripmineMeshScale") == meshScale then
        return true
    end
    removeCustomTripmineExtraMeshes(root)
    removeTripmineMeshAsset(root, profile.RemoveMeshId or profile.HideMeshId)
    local target = findCustomTripmineMeshTarget(root, profile)
    if not target then return false end
    local customPart

    if target:IsA("SpecialMesh") then
        pcall(function() target.MeshType = Enum.MeshType.FileMesh end)
        target.MeshId = meshIds[1]
        if profile.TextureId then
            pcall(function() target.TextureId = profile.TextureId end)
        elseif profile.ClearTexture then
            pcall(function() target.TextureId = "" end)
        end
        target.Scale = target.Scale * meshScale
        pcall(function() target.VertexColor = Vector3.new(1, 1, 1) end)
        customPart = target.Parent
        applyTripminePartVisual(customPart, profile)
        for index = 2, #meshIds do
            addTripmineExtraMeshPart(customPart, meshIds[index], scaleTripmineMeshVector(target.Scale, extraMeshScale), profile, index)
        end
    elseif target:IsA("MeshPart") then
        local originalSize = target.Size
        local okMesh = pcall(function()
            target.MeshId = meshIds[1]
        end)
        if profile.TextureId then
            pcall(function() target.TextureID = profile.TextureId end)
        elseif profile.ClearTexture then
            pcall(function() target.TextureID = "" end)
        end
        applyTripminePartVisual(target, profile)
        if okMesh then
            pcall(function()
                target.Size = originalSize * meshScale
            end)
            customPart = target
            for index = 2, #meshIds do
                addTripmineExtraMeshPart(target, meshIds[index], scaleTripmineMeshVector(Vector3.new(1, 1, 1), extraMeshScale), profile, index)
            end
        elseif target.Parent then
            pcall(function()
                target.Transparency = 1
                target.LocalTransparencyModifier = 1
            end)
            local overlay = target.Parent:FindFirstChild("__LionCustomTripmineMesh")
            if not (overlay and overlay:IsA("BasePart")) then
                overlay = Instance.new("Part")
                overlay.Name = "__LionCustomTripmineMesh"
                overlay.Anchored = target.Anchored
                overlay.CanCollide = false
                overlay.CanTouch = false
                overlay.CanQuery = false
                overlay.Massless = true
                overlay.Parent = target.Parent
            end
            overlay.Size = originalSize
            overlay.CFrame = target.CFrame
            applyTripminePartVisual(overlay, profile)
            local mesh = overlay:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = meshIds[1]
            if profile.TextureId then
                pcall(function() mesh.TextureId = profile.TextureId end)
            elseif profile.ClearTexture then
                pcall(function() mesh.TextureId = "" end)
            end
            mesh.Scale = Vector3.new(meshScale, meshScale, meshScale)
            pcall(function() mesh.VertexColor = Vector3.new(1, 1, 1) end)
            mesh.Parent = overlay
            overlay:SetAttribute("__LionCustomTripmineMeshPart", true)
            customPart = overlay
            for index = 2, #meshIds do
                addTripmineExtraMeshPart(overlay, meshIds[index], scaleTripmineMeshVector(meshScale, extraMeshScale), profile, index)
            end
            if not overlay:FindFirstChild("__LionCustomTripmineMeshWeld") then
                local weld = Instance.new("WeldConstraint")
                weld.Name = "__LionCustomTripmineMeshWeld"
                weld.Part0 = target
                weld.Part1 = overlay
                weld.Parent = overlay
            end
        end
    end

    if customPart and customPart:IsA("BasePart") then
        customPart:SetAttribute("__LionCustomTripmineMeshPart", true)
    end
    root:SetAttribute("__LionTripmineMeshSkin", profile.Skin)
    root:SetAttribute("__LionCustomTripmineMeshId", meshIds[1])
    root:SetAttribute("__LionCustomTripmineMeshIds", meshSignature)
    root:SetAttribute("__LionCustomTripmineMeshScale", meshScale)
    return true
end

local function applyVirtualViewModelAssetOverrides(cosmeticName, asset, worldAsset)
    local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
    if profile then
        applyTripmineMeshProfile(asset, profile)
    end
    local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
    if daggerProfile then
        applyDaggerMeshProfile(asset, daggerProfile)
    end
    local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
    if satchelProfile then
        applySatchelMeshProfile(asset, satchelProfile)
    end
    local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
    if rpgProfile then
        applyRpgMeshProfile(asset, rpgProfile)
    end
    local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
    if fistsProfile then
        applyFistsMeshProfile(asset, fistsProfile)
    end
    local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
    if bowProfile then
        applyBowMeshProfile(asset, bowProfile)
    end
    local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
    if assaultRifleProfile then
        applyAssaultRifleMeshProfile(asset, assaultRifleProfile)
    end
    local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
    if sniperProfile then
        applySniperMeshProfile(asset, sniperProfile)
    end
end

local function shouldRebuildVirtualViewModelAsset(cosmeticName, asset, worldAsset)
    local profile = TRIPMINE_MESH_SKIN_OVERRIDES[cosmeticName]
    if profile then
        local meshIds = getTripmineMeshIds(profile)
        return not asset
            or asset:GetAttribute("__LionTripmineMeshSkin") ~= profile.Skin
            or asset:GetAttribute("__LionCustomTripmineMeshIds") ~= getTripmineMeshSignature(profile)
            or asset:GetAttribute("__LionCustomTripmineMeshScale") ~= (profile.Scale or 1)
            or asset:GetAttribute("__LionCustomTripmineMeshId") ~= meshIds[1]
    end
    local sniperProfile = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName]
    if sniperProfile then
        return not asset
            or asset:GetAttribute("__LionSniperMeshSkin") ~= sniperProfile.Skin
            or asset:GetAttribute("__LionSniperMeshSignature") ~= getSniperMeshSignature(sniperProfile)
            or not asset:FindFirstChild("__LionCustomSniperReplacement", true)
    end
    local daggerProfile = DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName]
    if daggerProfile then
        return not asset
            or asset:GetAttribute("__LionDaggerMeshSkin") ~= daggerProfile.Skin
            or asset:GetAttribute("__LionDaggerMeshSignature") ~= getDaggerMeshSignature(daggerProfile)
            or (asset:GetAttribute("__LionDaggerMeshCount") or 0) <= 0
    end
    local satchelProfile = getSatchelMeshProfileForAsset(cosmeticName, worldAsset)
    if satchelProfile then
        return not asset
            or asset:GetAttribute("__LionSatchelMeshSkin") ~= satchelProfile.Skin
            or asset:GetAttribute("__LionSatchelMeshSignature") ~= getSatchelMeshSignature(satchelProfile)
            or (asset:GetAttribute("__LionSatchelMeshCount") or 0) <= 0
    end
    local rpgProfile = RPG_MESH_SKIN_OVERRIDES[cosmeticName]
    if rpgProfile then
        return not asset
            or asset:GetAttribute("__LionRpgMeshSkin") ~= rpgProfile.Skin
            or asset:GetAttribute("__LionRpgMeshSignature") ~= getRpgMeshSignature(rpgProfile)
            or asset:GetAttribute("__LionRpgRocketVisible") ~= false
            or ((asset:GetAttribute("__LionRpgMeshCount") or 0) + (asset:GetAttribute("__LionRpgHiddenCount") or 0)) <= 0
    end
    local fistsProfile = FISTS_MESH_SKIN_OVERRIDES[cosmeticName]
    if fistsProfile then
        return not asset
            or asset:GetAttribute("__LionFistsMeshSkin") ~= fistsProfile.Skin
            or asset:GetAttribute("__LionFistsMeshSignature") ~= getFistsMeshSignature(fistsProfile)
            or (asset:GetAttribute("__LionFistsMeshCount") or 0) <= 0
    end
    local bowProfile = BOW_MESH_SKIN_OVERRIDES[cosmeticName]
    if bowProfile then
        return not asset
            or asset:GetAttribute("__LionBowMeshSkin") ~= bowProfile.Skin
            or asset:GetAttribute("__LionBowMeshSignature") ~= getBowMeshSignature(bowProfile)
            or (asset:GetAttribute("__LionBowMeshCount") or 0) <= 0
    end
    local assaultRifleProfile = ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName]
    if assaultRifleProfile then
        return not asset
            or asset:GetAttribute("__LionAssaultRifleMeshSkin") ~= assaultRifleProfile.Skin
            or asset:GetAttribute("__LionAssaultRifleMeshSignature") ~= getAssaultRifleMeshSignature(assaultRifleProfile)
            or (asset:GetAttribute("__LionAssaultRifleMeshCount") or 0) <= 0
    end
    return cosmeticName == DICE_TRIPMINE_SKIN
        and asset
        and asset:GetAttribute("__LionRightArmRetargeted")
end

local function ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
    local sourceInfo = ilib.ViewModels and ilib.ViewModels[viewModelName]
    if not sourceInfo then return nil end

    if cosmeticName ~= viewModelName then
        local usesSourceAnimations = SNIPER_MESH_SKIN_OVERRIDES[cosmeticName] or DAGGERS_MESH_SKIN_OVERRIDES[cosmeticName] or SATCHEL_MESH_SKIN_OVERRIDES[cosmeticName] or RPG_MESH_SKIN_OVERRIDES[cosmeticName] or FISTS_MESH_SKIN_OVERRIDES[cosmeticName] or BOW_MESH_SKIN_OVERRIDES[cosmeticName] or ASSAULT_RIFLE_MESH_SKIN_OVERRIDES[cosmeticName] or cosmeticName == KNIFE_CUSTOM_SKIN or cosmeticName == "Grenade (Custom Skin)" or cosmeticName == "Molotov (Custom Skin)" or cosmeticName == "Satchel (Custom Skin)" or cosmeticName == "Smoke Grenade (Custom Skin)" or cosmeticName == "Warpstone (Custom Skin)" or cosmeticName == "sky"
        local animationInfo = usesSourceAnimations and sourceInfo or ilib.ViewModels[itemName]
        local baseInfo = animationInfo or sourceInfo
        local virtualInfo = table.clone(sourceInfo)
        if type(baseInfo.Animations) == "table" then
            virtualInfo.Animations = table.clone(baseInfo.Animations)
        end
        ilib.ViewModels[cosmeticName] = virtualInfo

        pcall(function()
            local viewModelAssets = lps.Assets and lps.Assets:FindFirstChild("ViewModels")
            if not viewModelAssets then return end
            local existingAsset = findDescendantByName(viewModelAssets, cosmeticName)
            if existingAsset then
                if shouldRebuildVirtualViewModelAsset(cosmeticName, existingAsset, false) then
                    existingAsset:Destroy()
                else
                    applyVirtualViewModelAssetOverrides(cosmeticName, existingAsset, false)
                    return
                end
            end

            local sourceAsset = findDescendantByName(viewModelAssets, viewModelName)
            if sourceAsset then
                local clonedAsset = sourceAsset:Clone()
                clonedAsset.Name = cosmeticName
                applyVirtualViewModelAssetOverrides(cosmeticName, clonedAsset, false)
                clonedAsset.Parent = viewModelAssets
            end
        end)

        pcall(function()
            local throwables = lps.Assets and lps.Assets:FindFirstChild("Throwables")
            if not throwables then return end
            local existingThrowable = throwables:FindFirstChild(cosmeticName)
            if existingThrowable then
                if shouldRebuildVirtualViewModelAsset(cosmeticName, existingThrowable, true) then
                    existingThrowable:Destroy()
                else
                    applyVirtualViewModelAssetOverrides(cosmeticName, existingThrowable, true)
                    return
                end
            end
            local sourceThrowable = findDescendantByName(throwables, viewModelName)
            if sourceThrowable then
                local clonedThrowable = sourceThrowable:Clone()
                clonedThrowable.Name = cosmeticName
                applyVirtualViewModelAssetOverrides(cosmeticName, clonedThrowable, true)
                clonedThrowable.Parent = throwables
            end
        end)

        pcall(function()
            if itemName ~= "Jump Pad" then return end
            local misc = lps.Assets and lps.Assets:FindFirstChild("Misc")
            local jumpPads = misc and misc:FindFirstChild("JumpPads")
            if not jumpPads then return end
            local existingJumpPad = jumpPads:FindFirstChild(cosmeticName)
            if existingJumpPad then
                if shouldRebuildVirtualViewModelAsset(cosmeticName, existingJumpPad, true) then
                    existingJumpPad:Destroy()
                else
                    applyVirtualViewModelAssetOverrides(cosmeticName, existingJumpPad, true)
                    return
                end
            end
            local sourceJumpPad = jumpPads:FindFirstChild(viewModelName) or jumpPads:FindFirstChild("Default")
            if sourceJumpPad then
                local clonedJumpPad = sourceJumpPad:Clone()
                clonedJumpPad.Name = cosmeticName
                applyVirtualViewModelAssetOverrides(cosmeticName, clonedJumpPad, true)
                clonedJumpPad.Parent = jumpPads
            end
        end)
    end

    return sourceInfo
end

local function registerVirtualWeaponSkin(cosmeticName, itemName, viewModelName, rarity, displayName, worldViewModelName)
    local viewModelInfo = ensureVirtualViewModel(cosmeticName, itemName, viewModelName)
    if not viewModelInfo then return end
    local imageInfo = cosmeticName == DICE_TRIPMINE_SKIN and ilib.ViewModels and ilib.ViewModels["RNG Dice"] or viewModelInfo
    local image = imageInfo.Image or ""
    local imageHighResolution = imageInfo.ImageHighResolution or imageInfo.Image or ""
    local imageOverride = CUSTOM_SKIN_IMAGE_OVERRIDES[cosmeticName]
    if imageOverride then
        image = imageOverride.Image or ""
        imageHighResolution = imageOverride.ImageHighResolution or imageOverride.Image or ""
    end

    if ilib.ViewModels and ilib.ViewModels[cosmeticName] then
        ilib.ViewModels[cosmeticName].Image = image
        ilib.ViewModels[cosmeticName].ImageHighResolution = imageHighResolution
    end

    coss[cosmeticName] = {
        Rarity = clib.Rarities[rarity] and rarity or "Legendary",
        Type = "Skin",
        DisplayName = displayName or cosmeticName,
        ViewModelName = cosmeticName,
        SourceViewModelName = viewModelName,
        WorldViewModelName = worldViewModelName or viewModelName,
        Image = image,
        ImageHighResolution = imageHighResolution,
        ImageScale = 3,
        ItemName = itemName,
        GetDescription = function() return "Custom skin for " .. itemName end,
        Owned = true,
        Unlocked = true,
        Locked = false
    }
end

local function registerVirtualWeaponSkins()
    coss["Flashbang (Custom Skin)"] = nil
    if ilib.ViewModels then
        ilib.ViewModels["Flashbang (Custom Skin)"] = nil
    end
    registerVirtualWeaponSkin(KNIFE_CUSTOM_SKIN, "Knife", "Glast Shard", "Contraband")
    registerVirtualWeaponSkin(REAVER_KNIFE_CUSTOM_SKIN, "Knife", "Pencil", "Contraband", "reaver")
    registerVirtualWeaponSkin(DAGGERS_CUSTOM_SKIN, "Daggers", "Keynais", "Contraband")
    registerVirtualWeaponSkin("Grenade (Custom Skin)", "Grenade", "Elixir", "Contraband")
    registerVirtualWeaponSkin("Grenade Raze", "Grenade", "Glorious Grenade", "Contraband", "Raze")
    registerVirtualWeaponSkin("sky", "Flashbang", "Shining Star", "Contraband")
    registerVirtualWeaponSkin("Molotov (Custom Skin)", "Molotov", "Elixir", "Contraband", "Elixir")
    registerVirtualWeaponSkin("Satchel (Custom Skin)", "Satchel", "Elixir", "Contraband")
    registerVirtualWeaponSkin(SATCHEL_CUSTOM_SKIN, "Satchel", "Satchel", "Contraband", "Raze", SATCHEL_CUSTOM_SKIN)
    registerVirtualWeaponSkin("Smoke Grenade (Custom Skin)", "Smoke Grenade", "Elixir", "Contraband")
    registerVirtualWeaponSkin("Warpstone (Custom Skin)", "Warpstone", "Elixir", "Contraband")
    registerVirtualWeaponSkin("Scythe (Custom Skin)", "Scythe", "Scepter", "Contraband")
    registerVirtualWeaponSkin("Katana (Custom Skin)", "Katana", "Scepter", "Contraband")
    registerVirtualWeaponSkin("Spear (Custom Skin)", "Spear", "Scepter", "Contraband")
    registerVirtualWeaponSkin("Handgun (Custom Skin)", "Handgun", "Glass Cannon", "Contraband")
    registerVirtualWeaponSkin(SNIPER_CUSTOM_SKIN, "Sniper", "Keyper", "Contraband")
    registerVirtualWeaponSkin("Operator", "Sniper", "Sniper", "Contraband")
    registerVirtualWeaponSkin("Medkit (Custom Skin)", "Medkit", "RNG Dice", "Contraband")
    registerVirtualWeaponSkin(RPG_CUSTOM_SKIN, "RPG", "Nuke Launcher", "Contraband", "Raze", RPG_CUSTOM_SKIN)
    registerVirtualWeaponSkin(FISTS_CUSTOM_SKIN, "Fists", "Fists", "Contraband", "Agent")
    registerVirtualWeaponSkin(BOW_CUSTOM_SKIN, "Bow", "Frostbite Bow", "Contraband")
    registerVirtualWeaponSkin(ASSAULT_RIFLE_CUSTOM_SKIN, "Assault Rifle", "AK-47", "Contraband")
    registerVirtualWeaponSkin("Camera", "Jump Pad", "Jump Pad", "Contraband", "Camera", "Camera")
    registerVirtualWeaponSkin(DICE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", nil, DICE_TRIPMINE_SKIN)
    registerVirtualWeaponSkin(SPIKE_TRIPMINE_SKIN, "Subspace Tripmine", "Subspace Tripmine", "Contraband", "Spike", SPIKE_TRIPMINE_SKIN)
end

registerVirtualWeaponSkins()

local cdata = dctrl.CurrentData
if not cdata then
    task.spawn(function()
        repeat task.wait() until dctrl.CurrentData
        cdata = dctrl.CurrentData
    end)
end

local equip, favs = {}, {}
local peerEquip = {}
local peerViewModelOriginals = setmetatable({}, {__mode = "k"})
local function cosmeticsForPlayer(player, weapon)
    if player == lp then return equip[weapon] end
    return player and peerEquip[player.UserId] and peerEquip[player.UserId][weapon] or nil
end
local scheduleSkinAutoSave
local forceCosmeticUpdate
local applyCosmeticToWeapon
local cwep, vprof, lwep
local lpname = lp.Name
local fcache = {}
local customCosmeticsRuntime = {
    CachedEquip = {},
    EquipSuspended = false,
    Definitions = {},
    Assets = {},
    Injected = {},
    Boxes = {},
    Granted = {},
    Locked = {},
    LockedBoxes = {},
    OwnershipRevision = 0,
    Metadata = {},
    LocalRewardEntries = setmetatable({}, {__mode = "k"}),
    CatalogRevision = 0,
    BatchDepth = 0,
    PendingFields = {},
    Alive = true,
    Types = {Skin = true, Wrap = true, Charm = true, Finisher = true},
}

local function banned(n)
    if type(n) ~= "string" then return true end
    if n:find("MISSING_", 1, true) then return true end
    -- Registered finishers are selectable even when their names match old exclusions.
    if coss[n] and coss[n].Type == "Finisher" then return false end
    return n:find("Bubblegum", 1, true) or n:find("Ragdoll", 1, true)
        or n:find("Fall Apart", 1, true) or n:find("Every Finisher Ever", 1, true)
end

-- Used by ownership, inventory actions, and both UI adapters; keep it outside
-- the private ownership-mask scope so every caller sees the same predicate.
local function unlockableCatalogEntry(name, cosmetic)
    if type(name) ~= "string" or type(cosmetic) ~= "table" or banned(name) then return false end
    return cosmetic.Type == "Skin" or cosmetic.Type == "Wrap" or cosmetic.Type == "Charm"
        or cosmetic.Type == "Dance" or cosmetic.Type == "Emote" or cosmetic.Type == "Finisher"
end

local function toenum(n)
    if not elib then return nil end
    -- Reading the map avoids EnumLibrary's assert for catalog-only cosmetics.
    -- Those names are valid locally but are intentionally absent from the
    -- network enum table (for example Chromatic and Alien Head).
    return elib._to_enum and elib._to_enum[n] or nil
end

local function clonecos(name, ctype, inv, favonly)
    if banned(name) then return nil end
    local base = coss[name]
    if not base then return nil end
    local d = table.clone(base)
    d.Name = name
    d.Type = d.Type or ctype
    d.Seed = d.Seed or math.random(1, 1000000)
    d.Owned = true
    d.Unlocked = true
    d.Locked = false
    d.Amount = math.max(1, tonumber(d.Amount) or 1)
    d.Count = math.max(1, tonumber(d.Count) or 1)
    local eid = toenum(name)
    if eid then d.Enum = eid d.ObjectID = d.ObjectID or eid end
    if inv ~= nil then d.Inverted = inv end
    if favonly ~= nil then d.OnlyUseFavorites = favonly end
    return d
end

-- savecfg and loadcfg removed

-- Unlock All uses the local PlayerData mask from the supplied reference.
-- Real account ownership stays untouched; only this client sees the expanded catalog.
local unlockAllEnabled = false
local spoofWeaponOwnerEnabled = false
local syncUnlockMask
local getRealCosmeticEntry
local unlockEmoteNames
local emoteWheelSlots = {}
local emoteWheelCustom = false
local function hasCosmeticOwnershipOverrides()
    return next(customCosmeticsRuntime.Definitions) ~= nil or next(customCosmeticsRuntime.Injected) ~= nil
        or next(customCosmeticsRuntime.Granted) ~= nil or next(customCosmeticsRuntime.Locked) ~= nil
end
local function hasBoxOwnershipOverrides()
    return next(customCosmeticsRuntime.Boxes) ~= nil or next(customCosmeticsRuntime.LockedBoxes) ~= nil
end
do
local unlockMaskTarget, unlockMaskInner, unlockMaskConnection = nil, nil, nil
local unlockSpoof = {}
local unlockEmoteCache = nil
local unlockedCosmeticCache, unlockedCosmeticCatalogCount = nil, 0
local unlockedWeaponCache = nil

local enumBackedCosmeticCache = {}
local unlock_rev, unlock_memo = 0, {}
local function memoize_unlock(key, build)
    return function(real)
        local count = 0
        if type(real) == "table" then for _ in next, real do count += 1 end end
        local m = unlock_memo[key]
        if m and m.real == real and m.rev == unlock_rev and m.count == count then return m.value end
        local value = build(real)
        unlock_memo[key] = {real = real, rev = unlock_rev, count = count, value = value}
        return value
    end
end
local function build_owned_weapons(real)
    local out, present = {}, {}
    if type(real) == "table" then
        for index, entry in ipairs(real) do
            out[index] = entry
            if type(entry) == "table" and type(entry.Name) == "string" then present[entry.Name] = true end
        end
    end
    if not unlockedWeaponCache then
        unlockedWeaponCache = {}
        for name, item in pairs((ilib and ilib.Items) or {}) do
            if type(name) == "string" and type(item) == "table" then table.insert(unlockedWeaponCache, name) end
        end
        table.sort(unlockedWeaponCache)
    end
    for _, name in ipairs(unlockedWeaponCache) do
        if not present[name] then table.insert(out, {Name=name, Level=1, XP=0, Prestige=0}) end
    end
    return out
end

local function build_unlocked_cosmetics(real)
    local out = {}
    if type(real) == "table" then
        for key, value in pairs(real) do out[key] = value end
    end
    for name in pairs(customCosmeticsRuntime.Locked) do out[name] = nil end
    local catalogCount = customCosmeticsRuntime.CatalogRevision
    if not unlockedCosmeticCache or unlockedCosmeticCatalogCount ~= catalogCount then
        unlockedCosmeticCache = {}
        unlockedCosmeticCatalogCount = catalogCount
        local weapons = {}
        for weaponName, weaponData in pairs(coss) do
            if type(weaponData) == "table" and weaponData.Type == "Weapon" then
                weapons[weaponName] = true
            end
        end
        for name, cosmetic in pairs(coss) do
            if unlockableCatalogEntry(name, cosmetic) then
            if cosmetic.Type == "Skin" then
                local itemName = cosmetic.ItemName or cosmetic.WeaponName or cosmetic.Weapon or cosmetic.Item
                unlockedCosmeticCache[name] = itemName and {[tostring(itemName)] = true} or table.clone(weapons)
            elseif cosmetic.Type == "Wrap" then
                unlockedCosmeticCache[name] = {IsUniversal = true}
            else
                unlockedCosmeticCache[name] = true
            end
            end
        end
    end
    for name, compatible in pairs(unlockedCosmeticCache) do
        if customCosmeticsRuntime.Locked[name] then continue end
        if not unlockAllEnabled and customCosmeticsRuntime.Definitions[name] == nil and customCosmeticsRuntime.Injected[name] == nil and customCosmeticsRuntime.Granted[name] == nil then continue end
        local owned = out[name]
        if compatible == true then
            out[name] = true
        elseif type(owned) == "table" then
            owned = table.clone(owned)
            for key in pairs(compatible) do owned[key] = true end
            out[name] = owned
        else
            out[name] = table.clone(compatible)
        end
    end
    return out
end

unlockEmoteNames = function()
    if unlockEmoteCache ~= nil then return unlockEmoteCache end
    local out = {}
    for name, cosmetic in pairs(coss) do
        if unlockableCatalogEntry(name, cosmetic) and cosmetic.Type == "Emote" then
            table.insert(out, name)
        end
    end
    table.sort(out)
    unlockEmoteCache = out
    return out
end

local function build_emote_slots(real)
    local out = {}
    if type(real) == "table" then
        for key, value in pairs(real) do
            if type(value) ~= "table" or not customCosmeticsRuntime.Locked[value.Name] then out[key] = value end
        end
    end
    for slot = 1, 8 do
        local picked = emoteWheelSlots[slot]
        if picked == false then
            out[tostring(slot)] = nil
        elseif type(picked) == "string" and not customCosmeticsRuntime.Locked[picked] then
            out[tostring(slot)] = {Name = picked}
        end
    end
    return out
end

local function build_box_inventory(real)
    -- Verified in Backpack and InspectBackpackReward: rewards are an ordered
    -- UnclaimedRewards array, not a map of box names or guessed inventory fields.
    local out = {}
    if type(real) == "table" then
        for _, entry in ipairs(real) do
            if type(entry) ~= "table" or not customCosmeticsRuntime.LockedBoxes[tostring(entry.Name or "")] then
                table.insert(out, entry)
            end
        end
    end
    for _, kind in ipairs({"Injected", "Boxes"}) do
        local names = {}
        for name in pairs(customCosmeticsRuntime[kind]) do table.insert(names, name) end
        table.sort(names)
        for _, name in ipairs(names) do
            if kind == "Boxes" and customCosmeticsRuntime.LockedBoxes[name] then continue end
            local definition = customCosmeticsRuntime.Definitions[name]
            local cosmetic = coss[name]
            if customCosmeticsRuntime[kind][name] <= 0 then continue end
            local entry = {Name = name, Quantity = customCosmeticsRuntime[kind][name],
                Weapon = kind == "Boxes" and "IsRandom"
                    or (definition and definition.Weapon) or (cosmetic and cosmetic.ItemName) or "IsUniversal"}
            customCosmeticsRuntime.LocalRewardEntries[entry] = {Kind = kind, Name = name}
            table.insert(out, entry)
        end
    end
    return out
end

local everyOwnedWeapon = memoize_unlock("weapons", build_owned_weapons)
local everyUnlockedCosmetic = memoize_unlock("cosmetics", build_unlocked_cosmetics)
local everyUnlockedEmoteSlot = memoize_unlock("emotes", build_emote_slots)
local everySpoofedBoxInventory = memoize_unlock("boxes", build_box_inventory)

local function removeUnlockMask()
    if unlockMaskTarget == nil then return end
    local target, inner = unlockMaskTarget, unlockMaskInner
    unlockMaskTarget, unlockMaskInner = nil, nil
    pcall(function()
        if target and inner then rawset(target, "Data", inner) end
    end)
end

getRealCosmeticEntry = function(name)
    local real = unlockMaskInner and unlockMaskInner.CosmeticInventory
    return type(real) == "table" and real[name] or nil
end

local function installUnlockMask()
    local current = dctrl.CurrentData
    if current == nil then return false, "player data is still loading" end
    if current == unlockMaskTarget then return true end
    removeUnlockMask()
    local inner = rawget(current, "Data")
    if type(inner) ~= "table" then return false, "CurrentData.Data is not ready" end
    local proxy = setmetatable({}, {
        __index = function(_, key)
            local transform = unlockSpoof[key]
            if transform ~= nil then return transform(inner[key]) end
            return inner[key]
        end,
        __newindex = function(_, key, value) inner[key] = value end,
        __iter = function() return next, inner end,
        __len = function() return #inner end,
    })
    rawset(current, "Data", proxy)
    unlockMaskTarget, unlockMaskInner = current, inner
    cdata = current
    return true
end

local function refreshUnlockField(key)
    pcall(function()
        local current = dctrl.CurrentData
        if current then
            -- Fire the exact client signal used by ReplicatedClass:Replicate,
            -- without entering its network encoding path for local-only names.
            current:GetDataChangedSignal(key):Fire(current:Get(key), key)
        end
    end)
end

local function ensureUnlockMaskWatcher()
    if unlockMaskConnection ~= nil then return end
    pcall(function()
        local signal = dctrl.PlayerDataAdded
        if signal == nil then return end
        unlockMaskConnection = signal:Connect(function()
            if not unlockAllEnabled and not spoofWeaponOwnerEnabled and not emoteWheelCustom and not hasCosmeticOwnershipOverrides() and not hasBoxOwnershipOverrides() then return end
            task.defer(function()
                if syncUnlockMask then syncUnlockMask() end
            end)
        end)
    end)
end

syncUnlockMask = function(fields)
    fields = fields or {CosmeticInventory = true, WeaponInventory = true, EquippedEmotes = true, UnclaimedRewards = true}
    for key in pairs(fields) do customCosmeticsRuntime.PendingFields[key] = true end
    if customCosmeticsRuntime.BatchDepth > 0 then return true end
    unlock_rev += 1
    unlockSpoof.CosmeticInventory = (unlockAllEnabled or hasCosmeticOwnershipOverrides()) and everyUnlockedCosmetic or nil
    unlockSpoof.WeaponInventory = spoofWeaponOwnerEnabled and everyOwnedWeapon or nil
    unlockSpoof.EquippedEmotes = (unlockAllEnabled or emoteWheelCustom or next(customCosmeticsRuntime.Locked) ~= nil) and everyUnlockedEmoteSlot or nil
    unlockSpoof.UnclaimedRewards = (hasBoxOwnershipOverrides() or next(customCosmeticsRuntime.Injected) ~= nil)
        and everySpoofedBoxInventory or nil
    ensureUnlockMaskWatcher()
    local ok, why = true, nil
    if not unlockAllEnabled and not spoofWeaponOwnerEnabled and not emoteWheelCustom and not hasCosmeticOwnershipOverrides() and not hasBoxOwnershipOverrides() then
        removeUnlockMask()
    else
        ok, why = installUnlockMask()
    end
    if ok and not customCosmeticsRuntime.RefreshQueued and customCosmeticsRuntime.Alive then
        customCosmeticsRuntime.RefreshQueued = true
        task.defer(function()
            customCosmeticsRuntime.RefreshQueued = false
            if not customCosmeticsRuntime.Alive then return end
            local pending = customCosmeticsRuntime.PendingFields
            customCosmeticsRuntime.PendingFields = {}
            for key in pairs(pending) do refreshUnlockField(key) end
            if customCosmeticsRuntime.NativeCatalogDirty then
                customCosmeticsRuntime.NativeCatalogDirty = false
                customCosmeticsRuntime:RefreshNativePicker()
            end
        end)
    end
    return ok, why
end

mainapi:Clean(function()
    unlockAllEnabled = false
    spoofWeaponOwnerEnabled = false
    unlockSpoof.CosmeticInventory = nil
    unlockSpoof.WeaponInventory = nil
    unlockSpoof.EquippedEmotes = nil
    unlockSpoof.UnclaimedRewards = nil
    if unlockMaskConnection then
        pcall(function() unlockMaskConnection:Disconnect() end)
        unlockMaskConnection = nil
    end
    removeUnlockMask()
end)
end

local cosmeticReadsAlive=true
local oget = dctrl.Get
local wrappedCosmeticGet=function(self, key)
    local data = oget(self, key)
    -- CosmeticInventory and EquippedEmotes come from the PlayerData mask.
    -- Keep the local favorites merge used by the cosmetic picker.
    if cosmeticReadsAlive and key == "FavoritedCosmetics" and unlockAllEnabled then
        local res = data and table.clone(data) or {}
        for wep, fv in favs do
            local slot = res[wep] or {}
            res[wep] = slot
            for name, isfav in fv do
                if not banned(name) then slot[name] = isfav end
            end
        end
        return res
    end
    return data
end

local localWeaponDataRecords = setmetatable({}, {__mode="k"})
local ogetwep = dctrl.GetWeaponData
localWeaponDataRecords.ReadOriginal = function(self,weapon)
    local previous=getthreadidentity and getthreadidentity()
    if not previous or previous<=2 or not setthreadidentity then return ogetwep(self,weapon)end
    setthreadidentity(2)
    local ok,value=pcall(ogetwep,self,weapon)
    setthreadidentity(previous)
    if not ok then error(value,0)end
    return value
end
local wrappedCosmeticWeaponData=function(self, wname)
    local data=localWeaponDataRecords.ReadOriginal(self,wname)
    if not data or not cosmeticReadsAlive then return data end
    local selected=equip[wname]
    if not selected or next(selected)==nil then return data end
    local merged=table.clone(data)
    merged.Name=wname
    localWeaponDataRecords[merged]=true
    for category,value in pairs(selected) do merged[category]=value end
    return merged
end
dctrl.Get=wrappedCosmeticGet
dctrl.GetWeaponData=wrappedCosmeticWeaponData
mainapi:Clean(function()
    cosmeticReadsAlive=false
    if dctrl.Get==wrappedCosmeticGet then dctrl.Get=oget end
    if dctrl.GetWeaponData==wrappedCosmeticWeaponData then dctrl.GetWeaponData=ogetwep end
    table.clear(localWeaponDataRecords)
end)

local function saferep(key)
    if key == "CosmeticInventory" and (unlockAllEnabled or hasCosmeticOwnershipOverrides()) then return end
    pcall(function()
        if not cdata and dctrl.CurrentData then cdata = dctrl.CurrentData end
        if cdata then cdata:Replicate(key) end
    end)
end

local fctrl, wrapController
local disableAnimatedWraps = false
local refreshAnimatedWrapState = function() end
pcall(function() fctrl = require(ctrls:WaitForChild("FighterController", 10)) end)
pcall(function() wrapController = require(ctrls:WaitForChild("WrapController", 10)) end)
if wrapController then
    -- Different Rivals builds keep their animated-wrap loop behind differently
    -- named helpers. Guard every animation-specific helper instead of polling the
    -- viewmodel every frame; static wraps still go through the normal controller.
    for methodName, method in pairs(wrapController) do
        if type(method) == "function" and tostring(methodName):lower():find("anim", 1, true) then
            local originalMethod = method
            wrapController[methodName] = function(self, ...)
                if disableAnimatedWraps then return nil end
                return originalMethod(self, ...)
            end
        end
    end
end
local replicatedClass
pcall(function()
    local identity = getthreadidentity and getthreadidentity()
    if setthreadidentity then pcall(setthreadidentity, 2) end
    local ok, result = pcall(require, reps.Modules.ReplicatedClass)
    if identity and setthreadidentity then pcall(setthreadidentity, identity) end
    if ok then replicatedClass = result end
end)
if replicatedClass then
    local env = getgenv and getgenv() or _G
    local state = env.__PlexLocalCosmeticDataGuard
    if not state then
        state = {OriginalSet = replicatedClass.Set}
        env.__PlexLocalCosmeticDataGuard = state
    end
    -- Reuse the native original while upgrading the handler on reinjection.
    replicatedClass.Set = function(self, key, value)
            local getter = state.GetDesired
            local item = rawget(self, "ClientItem")
            if getter and (key == "Skin" or key == "Wrap" or key == "Charm" or key == "Finisher" or (key == "Name" and item)) then
                local fighter = item and item.ClientFighter or rawget(self, "ClientFighter")
                if fighter and fighter.Player == state.Player then
                    local desired = getter(item and item.Name or rawget(self, "Name") or (self.Data and self.Data.Name), key)
                    if desired ~= nil then value = desired end
                end
            end
            return state.OriginalSet(self, key, value)
    end
    state.Player = lp
    state.GetDesired = function(weapon, cosmeticType)
        local selected = weapon and equip[weapon]
        if cosmeticType == "Name" then
            local skin = selected and selected.Skin
            return skin and (skin.ViewModelName or skin.Name)
        end
        return selected and selected[cosmeticType] or nil
    end
    mainapi:Clean(function()
        state.GetDesired = nil
        state.Player = nil
    end)
end
local charmAssets, wrapPreviewAsset, wrapTextureAssets
pcall(function()
    charmAssets = lps.Assets:WaitForChild("Charms", 10)
    wrapPreviewAsset = lps.Assets:WaitForChild("Misc", 10):WaitForChild("Wrap", 10)
    wrapTextureAssets = lps.Assets:WaitForChild("WrapTextures", 10)
end)

local function resolveViewModelName(weapon, cosmetics)
    local skin = cosmetics and cosmetics.Skin
    local skinName = skin and (skin.ViewModelName or skin.Name)
    return skinName or weapon
end

local function resolveViewModelSourceName(weapon, cosmetics)
    local skin = cosmetics and cosmetics.Skin
    return skin and (skin.SourceViewModelName or skin.ViewModelName or skin.Name) or weapon
end

function customCosmeticsRuntime:AssetId(value)
    local text = tostring(value or ""):match("^%s*(.-)%s*$")
    local id = text:match("^(%d+)$") or text:match("^rbxassetid://(%d+)$")
    local number = id and tonumber(id)
    return number and number > 0 and number <= 9007199254740991 and tostring(number) or nil
end

function customCosmeticsRuntime:Key(kind, weapon, name)
    return "Plex Custom " .. kind .. " | " .. weapon .. " | " .. name
end

function customCosmeticsRuntime:BeginBatch()
    self.BatchDepth += 1
end

function customCosmeticsRuntime:EndBatch()
    self.BatchDepth = math.max(0, self.BatchDepth - 1)
    if self.BatchDepth == 0 and next(self.PendingFields) and syncUnlockMask then syncUnlockMask({}) end
end

function customCosmeticsRuntime:CatalogChanged(key, removed, kind)
    self.CatalogRevision += 1
    local names = clib.CosmeticsAlphabetized
    if type(names) == "table" then
        local index = table.find(names, key)
        if removed then
            if index then table.remove(names, index) end
        elseif not index then
            table.insert(names, key)
        end
    end
    self.NativeCatalogDirty = true
    self.NativeCatalogTypes = self.NativeCatalogTypes or {}
    if kind then self.NativeCatalogTypes[kind] = true end
end

function customCosmeticsRuntime:RefreshNativePicker()
    local changed = self.NativeCatalogTypes or {}
    self.NativeCatalogTypes = nil
    local module = lps.Modules.UserInterface:FindFirstChild("Equipment")
    local controller = module and safeRequireModule(module)
    if not controller or not controller.IsOpen then return end
    -- A skin edit must not rebuild hundreds of unrelated wrap/charm previews.
    if not changed[controller:GetCustomizingType()] then return end
    local picker = controller.Interface and controller.Interface.Customize and controller.Interface.Customize.Cosmetics
    if picker and picker._Generate then
        local ok, err = pcall(picker._Generate, picker)
        if not ok then warn("[Plex Cosmetics] Native picker refresh: " .. tostring(err)) end
    end
end

function customCosmeticsRuntime:BaseViewModel(weapon)
    self.BaseNames = self.BaseNames or {}
    if self.BaseNames[weapon] then return self.BaseNames[weapon] end
    local base = ilib.ViewModels and ilib.ViewModels[weapon] and weapon
    if not base then
        for name, cosmetic in pairs(coss) do
            if type(cosmetic) == "table" and cosmetic.Type == "Skin" and cosmetic.ItemName == weapon and not cosmetic.PlexCustom then
                local candidate = cosmetic.ViewModelName or name
                if ilib.ViewModels and ilib.ViewModels[candidate] then base = candidate break end
            end
        end
    end
    if base then self.BaseNames[weapon] = base end
    return base
end

function customCosmeticsRuntime:ValidateAsset(id, image)
    local cached = self.Metadata[id]
    if not cached or (not cached.Info and os.clock() - cached.At > 10) then
        local ok, result = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(tonumber(id))
        end)
        cached = {At = os.clock(), Info = ok and result or nil, Error = not ok and tostring(result) or nil}
        self.Metadata[id] = cached
    end
    if not cached.Info then return false, "Asset " .. id .. " is unavailable: " .. tostring(cached.Error) end
    local kind = cached.Info.AssetTypeId
    if image == "Animation" then
        if kind ~= Enum.AssetType.Animation.Value then return false, "Asset " .. id .. " must be an animation" end
    elseif image == "Icon" then
        -- Icons can point at a model/mesh thumbnail as well as a raw image.
    elseif image == "Animation" or image == "Sound" then
        local expected = image == "Animation" and Enum.AssetType.Animation.Value or Enum.AssetType.Audio.Value
        if kind ~= expected then return false, "Asset " .. id .. " must be a " .. string.lower(image) .. " asset" end
    elseif image then
        if kind ~= Enum.AssetType.Image.Value and kind ~= Enum.AssetType.Decal.Value then
            return false, "Asset " .. id .. " must be an image or decal"
        end
    elseif kind ~= Enum.AssetType.Mesh.Value and kind ~= Enum.AssetType.Model.Value then
        return false, "Asset " .. id .. " must be a model or mesh"
    end
    return true
end

function customCosmeticsRuntime:AssetImage(id, thumbnail)
    local metadata = self.Metadata[id]
    local kind = metadata and metadata.Info and metadata.Info.AssetTypeId
    if not thumbnail and (kind == Enum.AssetType.Image.Value or kind == Enum.AssetType.Decal.Value) then
        return "rbxassetid://" .. id
    end
    return "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420"
end

function customCosmeticsRuntime:GunOptions(raw, base)
    local options = {Animations = {}, Sounds = {}, Signature = ""}
    local signatures = {}
    for field, assetType in pairs({Animations = "Animation", Sounds = "Sound"}) do
        local values = raw[field]
        if values ~= nil and type(values) ~= "table" then error(field .. " must be an action-to-asset-ID table") end
        for action, value in pairs(values or {}) do
            if not base or not base.Animations or not base.Animations[action] then error("This weapon has no " .. tostring(action) .. " animation") end
            local id = self:AssetId(value)
            if not id then error("Enter a valid " .. string.lower(assetType) .. " asset ID for " .. action) end
            local ok, why = self:ValidateAsset(id, assetType)
            if not ok then error(why) end
            options[field][action] = id
            table.insert(signatures, field .. action .. "=" .. id)
        end
    end
    for field, range in pairs({AnimationSpeed = {0.1, 4}, SoundVolume = {0, 2}, SoundPitch = {0.1, 3}}) do
        if raw[field] ~= nil and tostring(raw[field]):match("%S") then
            local value = tonumber(raw[field])
            if not value or value ~= value or value < range[1] or value > range[2] then error(field .. " must be between " .. range[1] .. " and " .. range[2]) end
            options[field] = value
            table.insert(signatures, field .. "=" .. tostring(value))
        end
    end
    table.sort(signatures)
    options.Signature = table.concat(signatures, "|")
    return options
end

function customCosmeticsRuntime:PrepareGunOverrides(definition, viewInfo)
    if not next(definition.Animations) and not next(definition.Sounds) and not definition.AnimationSpeed then return end
    local animations = safeRequireModule(reps.Modules.AnimationLibrary)
    local sounds = safeRequireModule(reps.Modules.SoundLibrary)
    if not animations or not animations.Info or not sounds or not sounds.AnimationSounds then error("Native animation/sound libraries are unavailable") end
    local prepared = {Animations = animations.Info, Sounds = sounds.AnimationSounds, Entries = {}}
    for action, sourceName in pairs(viewInfo.Animations) do
        if definition.Animations[action] or definition.Sounds[action] or definition.AnimationSpeed then
            local source = animations.Info[sourceName]
            if type(source) ~= "table" then error("The native " .. action .. " animation is unavailable") end
            local name = definition.Key .. " | Animation | " .. action
            local descriptor = table.clone(source)
            if definition.Animations[action] then descriptor.AnimationID = "rbxassetid://" .. definition.Animations[action] end
            if definition.AnimationSpeed then
                local ratio = (source.Speed or 1) / definition.AnimationSpeed
                descriptor.Speed = definition.AnimationSpeed
                if source.Length then descriptor.Length = source.Length * ratio end
                if source.ActionTimestamp then descriptor.ActionTimestamp = source.ActionTimestamp * ratio end
            end
            local function remapCallback(callback)
                if type(callback) ~= "function" then return callback end
                return function(viewModel, speed, hash)
                    -- Native callbacks wait on their original script name. Keep that
                    -- name mapped to this animation's cancellation hash while they run.
                    local hashes = viewModel.Animator and viewModel.Animator._animation_hashes
                    local previous = hashes and hashes[sourceName]
                    if hashes then hashes[sourceName] = hash end
                    local ok, err = pcall(callback, viewModel, speed, hash)
                    if hashes and hashes[sourceName] == hash then hashes[sourceName] = previous end
                    if not ok then error(err) end
                end
            end
            descriptor.SoundCallback = remapCallback(source.SoundCallback)
            descriptor.EffectCallback = remapCallback(source.EffectCallback)
            local preload = sounds.AnimationSounds[sourceName]
            if definition.Sounds[action] then
                local soundId = "rbxassetid://" .. definition.Sounds[action]
                local volume, pitch = definition.SoundVolume or 1, definition.SoundPitch or 1
                descriptor.SoundCallback = function(viewModel) viewModel:CreateSound(soundId, volume, pitch, true, 5) end
                preload = {soundId}
            end
            viewInfo.Animations[action] = name
            prepared.Entries[name] = {Animation = descriptor, Sounds = preload}
        end
    end
    return prepared
end

function customCosmeticsRuntime:ClearGunOverrides(key)
    local overrides = self.GunOverrides and self.GunOverrides[key]
    if not overrides then return end
    for name, entry in pairs(overrides.Entries) do
        if overrides.Animations[name] == entry.Animation then overrides.Animations[name] = nil end
        if overrides.Sounds[name] == entry.Sounds then overrides.Sounds[name] = nil end
    end
    self.GunOverrides[key] = nil
end

function customCosmeticsRuntime:LoadModel(id)
    self.ModelCache = self.ModelCache or {}
    local cached = self.ModelCache[id]
    if cached then cached.At = os.clock() return cached.Asset:Clone() end
    -- Invoke the engine method directly. GetObjects goes through the executor's
    -- array-returning loader and disconnected the live client during our probe.
    local previousIdentity = getthreadidentity and getthreadidentity()
    if setthreadidentity then pcall(setthreadidentity, 8) end
    local ok, model = pcall(function()
        local service = game:GetService("InsertService")
        return service.LoadLocalAsset(service, "rbxassetid://" .. id)
    end)
    if previousIdentity ~= nil and setthreadidentity then pcall(setthreadidentity, previousIdentity) end
    if not ok or typeof(model) ~= "Instance" then error("Could not load model " .. id .. ": " .. tostring(model)) end
    model.Parent = nil
    local valid, why = pcall(function()
        local descendants = model:GetDescendants()
        if #descendants > 512 then error("Model exceeds the 512-object visual limit") end
        local parts = 0
        for _, object in ipairs(descendants) do
            if object:IsA("LuaSourceContainer") or object:IsA("Humanoid") or object:IsA("AnimationController")
                or object:IsA("Sound") or object:IsA("Constraint") or object:IsA("JointInstance") then
                object:Destroy()
            elseif object:IsA("BasePart") then
                parts += 1
                if parts > 128 then error("Model exceeds the 128-part visual limit") end
                object.Anchored, object.Massless = true, true
                object.CanCollide, object.CanTouch, object.CanQuery = false, false, false
                if object.Transparency >= 1 then
                    -- Imported rig/collision helpers must stay invisible when native
                    -- wraps and the viewmodel appearance modifier refresh the model.
                    object:SetAttribute("PlexCustomHiddenRig", true)
                    object:SetAttribute("IgnoreTransparency", true)
                end
            end
        end
        if parts == 0 or not model:IsA("Model") then error("The asset contains no compatible model geometry") end
        model.PrimaryPart = model:FindFirstChildWhichIsA("BasePart", true)
    end)
    if not valid or not self.Alive then model:Destroy() error(why or "Cosmetic changer was unloaded") end
    -- Bound retained templates; published cosmetics own separate clones.
    local count, oldestId, oldestAt = 0, nil, math.huge
    for key, entry in pairs(self.ModelCache) do
        count += 1
        if entry.At < oldestAt then oldestId, oldestAt = key, entry.At end
    end
    if count >= 8 then self.ModelCache[oldestId].Asset:Destroy() self.ModelCache[oldestId] = nil end
    self.ModelCache[id] = {Asset = model, At = os.clock()}
    return model:Clone()
end

function customCosmeticsRuntime:EnsureNativeSlots()
    if self.NativeSlotClass then return end
    local module = lps.Modules:FindFirstChild("CosmeticSlot")
    local class = module and safeRequireModule(module)
    if not self.Alive or not class or type(class.new) ~= "function" then return end
    local original = class.new
    local replacement = function(name, ...)
        local slot = original(name, ...)
        local entry = coss[name]
        if self.Alive and entry and entry.PlexCustom then
            slot:OverrideNameText(entry.DisplayName)
            -- Native _Setup replaces the image with a cosmetic-type symbol.
            -- Custom assets own their thumbnail and display name instead.
            local icon = slot.Frame.Button.Icon
            icon.Image, icon.ImageColor3 = entry.Image, Color3.new(1, 1, 1)
            icon.ImageTransparency, icon.ZIndex = slot.IsLocked and 0.5 or 0, 3
            icon.Size = UDim2.fromScale(0.75, 0.75)
        end
        return slot
    end
    class.new = replacement
    self.NativeSlotClass, self.NativeSlotOriginal, self.NativeSlotReplacement = class, original, replacement
end

function customCosmeticsRuntime:Remove(key)
    local definition = self.Definitions[key]
    if not definition then return false end
    if definition.Type == "Emote" then
        if shared.LionCosmeticChanger.StopCustomEmote then shared.LionCosmeticChanger.StopCustomEmote(key) end
        if self.StopEmotePreviews then self:StopEmotePreviews(key) end
        for slot, name in pairs(emoteWheelSlots) do
            if name == key then emoteWheelSlots[slot] = false end
        end
        self.Definitions[key], coss[key] = nil, nil
        self:CatalogChanged(key, true, "Emote")
        unlockEmoteCache = nil
        if syncUnlockMask then syncUnlockMask({CosmeticInventory = true, EquippedEmotes = true}) end
        return true
    end
    local asset = self.Assets[key]
    if typeof(asset) == "Instance" then asset:Destroy() end
    self.Assets[key], self.Definitions[key], coss[key] = nil, nil, nil
    self:ClearGunOverrides(key)
    if definition.Type == "Skin" and ilib.ViewModels then ilib.ViewModels[key] = nil end
    for _, selections in ipairs({equip, self.CachedEquip}) do
        for _, weaponData in pairs(selections) do
            local equipped = weaponData[definition.Type]
            if equipped and equipped.Name == key then weaponData[definition.Type] = nil end
        end
    end
    fcache[definition.Weapon] = nil
    self:CatalogChanged(key, true, definition.Type)
    if syncUnlockMask then syncUnlockMask({CosmeticInventory = true, WeaponInventory = true}) end
    if self.Alive and forceCosmeticUpdate then task.defer(forceCosmeticUpdate, definition.Weapon, definition.Type) end
    return true
end

function customCosmeticsRuntime:LoadAsset(definition)
    local assets = lps:FindFirstChild("Assets")
    local folderName = definition.Type == "Skin" and "ViewModels"
        or definition.Type == "Wrap" and "WrapTextures" or definition.Type == "Charm" and "Charms" or nil
    local destination = folderName and assets and assets:FindFirstChild(folderName)
    if folderName and not destination then error(folderName .. " asset folder is unavailable") end
    local asset
    if definition.Type == "Skin" then
        self.SourceAssets = self.SourceAssets or {}
        local source = self.SourceAssets[definition.Base]
        if not source or not source.Parent then
            source = findDescendantByName(destination, definition.Base)
            self.SourceAssets[definition.Base] = source
        end
        if not source then error("The selected weapon has no loaded base model") end
        asset = source:Clone()
    else
        asset = Instance.new(definition.Type == "Wrap" and "Folder" or "Model")
    end
    self.StagedAsset = asset
    asset.Name = definition.Key
    if definition.Type == "Skin" then asset:SetAttribute("PlexCustomSkin", true) end
    if definition.Type == "Wrap" then
        for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
            local texture = Instance.new("Texture")
            texture.Face = face
            texture.Texture = "rbxassetid://" .. definition.ModelId
            texture.Parent = asset
        end
    else
        local body = definition.Type == "Skin" and asset:FindFirstChild("Body")
        if definition.Type == "Skin" and not body then
            -- Fists/dual weapons use arm submodels rather than a Body. Add only
            -- the invisible attachment the native viewmodel constructor needs.
            local anchor = asset:FindFirstChildWhichIsA("BasePart", true)
            if anchor then
                body = Instance.new("Model")
                body.Name, body.Parent = "Body", asset
                local primary = Instance.new("Part")
                primary.Name, primary.Size, primary.Transparency = "Primary", Vector3.one * 0.1, 1
                primary.CFrame, primary.Parent = anchor.CFrame, body
                primary.CanCollide, primary.CanTouch, primary.CanQuery = false, false, false
                body.PrimaryPart = primary
            end
        end
        local root = body and body:FindFirstChildWhichIsA("BasePart", true)
        if definition.Type == "Skin" and not root then error("The weapon model has no compatible Body attachment") end
        if root then
            local descendants = asset:GetDescendants()
            if #descendants > 512 then error("The weapon model is too complex for a custom replacement") end
            for _, object in ipairs(descendants) do
                if object:IsA("BasePart") then
                    object.Transparency = 1
                    object.LocalTransparencyModifier = 1
                    object:SetAttribute("PlexCustomHiddenRig", true)
                    object:SetAttribute("IgnoreTransparency", true)
                elseif object:IsA("Decal") or object:IsA("Texture") then
                    object.Transparency = 1
                    object:SetAttribute("IgnoreTransparency", true)
                end
            end
        end
        if definition.AssetType == Enum.AssetType.Model.Value then
            local visual = self:LoadModel(definition.ModelId)
            visual.Name = "PlexCustomVisual"
            visual.Parent = body or asset
            if root then
                local _, visualSize = visual:GetBoundingBox()
                local baseSpan = math.max(root.Size.X, root.Size.Y, root.Size.Z)
                -- Include only the original weapon geometry when calculating scale.
                for _, object in ipairs(body:GetDescendants()) do
                    if object:IsA("BasePart") and not object:IsDescendantOf(visual) then
                        baseSpan = math.max(baseSpan, object.Size.X, object.Size.Y, object.Size.Z)
                    end
                end
                local visualSpan = math.max(visualSize.X, visualSize.Y, visualSize.Z)
                if visualSpan > 0 then visual:ScaleTo(visual:GetScale() * math.clamp(baseSpan / visualSpan, 0.001, 100)) end
                visual:PivotTo(root.CFrame)
            end
            for _, part in ipairs(visual:GetDescendants()) do
                if part:IsA("BasePart") then
                    if root then
                        part:SetAttribute("WrapGroup", 1)
                        part:AddTag("Wrappable")
                    end
                    part.Anchored = not root
                    local anchor = root or visual.PrimaryPart
                    if part ~= anchor then
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0, weld.Part1, weld.Parent = anchor, part, part
                    end
                end
            end
            if not root then
                asset.PrimaryPart = visual.PrimaryPart
                for _, part in ipairs(visual:GetDescendants()) do if part:IsA("BasePart") then part.Anchored = false end end
            end
        else
            local visual = Instance.new("Part")
            visual.Name = "PlexCustomVisual"
            visual.Size = Vector3.one
            visual.CanCollide, visual.CanTouch, visual.CanQuery = false, false, false
            visual.Massless = true
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://" .. definition.ModelId
            mesh.Parent = visual
            visual.Parent = body or asset
            if root then
                visual:SetAttribute("WrapGroup", 1)
                visual:AddTag("Wrappable")
                visual.CFrame = root.CFrame
                local weld = Instance.new("WeldConstraint")
                weld.Part0, weld.Part1, weld.Parent = root, visual, visual
            else asset.PrimaryPart = visual end
        end
    end
    if definition.Type == "Charm" then
        -- Both native charm rendering paths require Primary, Hook, and a pivot
        -- attachment. A bare mesh/model can appear in the list but cannot equip.
        local visualRoot = asset.PrimaryPart
        local primary = Instance.new("Part")
        primary.Name, primary.Transparency, primary.Size = "Primary", 1, Vector3.one * 0.1
        primary.CFrame = visualRoot.CFrame
        primary.CanCollide, primary.CanTouch, primary.CanQuery, primary.Massless = false, false, false, true
        primary:SetAttribute("PlexCustomHiddenRig", true)
        primary:SetAttribute("IgnoreTransparency", true)
        primary.Parent = asset
        asset.PrimaryPart = primary
        local attachment = Instance.new("Attachment")
        attachment.Name, attachment.Parent = "_pivot_attachment", primary
        local hook = Instance.new("Model")
        hook.Name, hook.Parent = "Hook", asset
        local weld = Instance.new("WeldConstraint")
        weld.Part0, weld.Part1, weld.Parent = primary, visualRoot, primary
        local _, size = asset:GetBoundingBox()
        local span = math.max(size.X, size.Y, size.Z)
        if span > 0 then asset:ScaleTo(asset:GetScale() * math.clamp(0.75 / span, 0.001, 100)) end
    end
    return asset, destination
end

function customCosmeticsRuntime:RegisterEmote(raw)
    local name = tostring(raw.Name or ""):match("^%s*(.-)%s*$")
    local id = self:AssetId(raw.AnimationId or raw.ModelId)
    local icon = self:AssetId(raw.IconId)
    local rarity = tostring(raw.Rarity or "Common")
    if name == "" or #name > 100 then return false, "Enter an emote name of 1–100 characters" end
    if not id then return false, "Enter a valid animation asset ID" end
    if not clib.Rarities[rarity] then return false, "Choose a registered rarity" end
    if tostring(raw.IconId or ""):match("%S") and not icon then return false, "Enter a valid icon ID or leave it blank" end
    local valid, why = self:ValidateAsset(id, "Animation")
    if not valid then return false, why end
    if icon then valid, why = self:ValidateAsset(icon, "Icon") if not valid then return false, why end end
    if not self.Alive then return false, "Cosmetic changer was unloaded" end
    if self.EnsureEmotePreview then self:EnsureEmotePreview() end
    local key = self:Key("Emote", "", name)
    local definition = {Key=key, Type="Emote", Weapon="", Name=name, Rarity=rarity,
        AnimationId=id, ModelId=id, IconId=icon or "", Speed=math.clamp(tonumber(raw.Speed) or 1, 0.1, 3), Loop=raw.Loop==true}
    local image = self:AssetImage(icon or id, not icon)
    local entry = {Type="Emote", Rarity=rarity, DisplayName=name, Image=image, ImageHighResolution=image,
        ImageScale=1, IsTraversal=false, ViewportCFrameOffset=CFrame.new(), PlexCustom=true,
        Description="Custom animation emote", Owned=true, Unlocked=true, Locked=false}
    entry.GetDescription = function() return entry.Description end
    self.Definitions[key], coss[key] = definition, entry
    unlockEmoteCache = nil
    self:CatalogChanged(key, false, "Emote")
    if syncUnlockMask then syncUnlockMask({CosmeticInventory=true}) end
    return true, key
end

function customCosmeticsRuntime:_Register(raw)
    if type(raw) ~= "table" then return false, "Invalid custom cosmetic definition" end
    if raw.Type == "Emote" then return self:RegisterEmote(raw) end
    local kind, weapon = tostring(raw.Type or "Skin"), tostring(raw.Weapon or "")
    local name = tostring(raw.Name or ""):match("^%s*(.-)%s*$")
    local rarity = tostring(raw.Rarity or "Common")
    local iconId, modelId = self:AssetId(raw.IconId), self:AssetId(raw.ModelId)
    if not self.Types[kind] then return false, "Choose a supported cosmetic type" end
    if not (ilib.Items and ilib.Items[weapon]) then return false, "Choose a weapon" end
    if name == "" or #name > 100 then return false, "Enter a custom name of 1–100 characters" end
    if not clib.Rarities[rarity] then return false, "Choose a registered cosmetic rarity" end
    if not modelId then return false, "Enter a valid positive asset ID" end
    if tostring(raw.IconId or ""):match("%S") and not iconId then return false, "Enter a valid icon asset ID or leave it blank" end
    local key = self:Key(kind, weapon, name)
    local baseName = kind == "Skin" and self:BaseViewModel(weapon) or nil
    local gun = self:GunOptions(raw, baseName and ilib.ViewModels[baseName])
    local previous = self.Definitions[key]
    if previous and previous.Rarity == rarity and previous.IconId == (iconId or "") and previous.ModelId == modelId
        and (previous.GunSignature or "") == gun.Signature then
        return true, key
    end
    local valid, why = self:ValidateAsset(modelId, kind == "Wrap")
    if not valid then return false, why end
    if iconId then
        valid, why = self:ValidateAsset(iconId, "Icon")
        if not valid then return false, why end
    end
    if not self.Alive then return false, "Cosmetic changer was unloaded" end
    local definition = {Key = key, Type = kind, Weapon = weapon, Name = name, Rarity = rarity,
        IconId = iconId or "", ModelId = modelId, AssetType = self.Metadata[modelId].Info.AssetTypeId,
        Base = baseName, Animations = gun.Animations, Sounds = gun.Sounds, GunSignature = gun.Signature,
        AnimationSpeed = gun.AnimationSpeed, SoundVolume = gun.SoundVolume, SoundPitch = gun.SoundPitch}
    if kind == "Skin" and not definition.Base then return false, "No compatible base viewmodel exists for " .. weapon end
    local image = self:AssetImage(iconId or modelId, not iconId)
    local entry = {Type = kind, Rarity = rarity, DisplayName = name, Image = image,
        ImageHighResolution = image, ImageScale = 1, ItemName = weapon,
        Owned = true, Unlocked = true, Locked = false, PlexCustom = true}
    entry.Description = "Custom " .. string.lower(kind) .. " for " .. weapon
    entry.GetDescription = function() return entry.Description end
    local viewInfo, gunOverrides
    if kind == "Skin" then
        entry.ViewModelName, entry.SourceViewModelName, entry.WorldViewModelName = key, definition.Base, key
        viewInfo = table.clone(ilib.ViewModels[definition.Base])
        viewInfo.Animations = table.clone(viewInfo.Animations or {})
        viewInfo.Image, viewInfo.ImageHighResolution = image, image
        gunOverrides = self:PrepareGunOverrides(definition, viewInfo)
    elseif kind == "Wrap" then
        -- WrapController reads all three groups, including its inverted mapping.
        -- Provide a static texture profile without starting a native wrap animator.
        entry.WrapGroups = {}
        for group = 1, 3 do
            entry.WrapGroups[group] = {Textures = key, Color = Color3.new(1, 1, 1),
                Transparency = 0, Reflectance = 0, Material = Enum.Material.SmoothPlastic, MaterialVariant = ""}
        end
    end
    local asset, destination = self:LoadAsset(definition)
    self:EnsureNativeSlots()
    if not self.Alive then return false, "Cosmetic changer was unloaded" end
    -- Nothing is published until validation and the complete staged asset succeed.
    local previousAsset = self.Assets[key]
    asset.Parent = destination
    self:ClearGunOverrides(key)
    if gunOverrides then
        self.GunOverrides = self.GunOverrides or {}
        self.GunOverrides[key] = gunOverrides
        for name, override in pairs(gunOverrides.Entries) do
            gunOverrides.Animations[name], gunOverrides.Sounds[name] = override.Animation, override.Sounds
        end
    end
    coss[key], self.Definitions[key], self.Assets[key] = entry, definition, asset
    if viewInfo then ilib.ViewModels[key] = viewInfo end
    self.StagedAsset = nil
    if typeof(previousAsset) == "Instance" then previousAsset:Destroy() end
    self:CatalogChanged(key, false, kind)
    if syncUnlockMask then syncUnlockMask({CosmeticInventory = true}) end
    if equip[weapon] and equip[weapon].Skin and equip[weapon].Skin.Name == key and forceCosmeticUpdate then
        task.defer(forceCosmeticUpdate, weapon, "Skin")
    end
    return true, key
end

function customCosmeticsRuntime:Register(raw)
    if self.Busy then return false, "A cosmetic is already being created; wait for it to finish" end
    if not self.Alive then return false, "Cosmetic changer was unloaded" end
    self.Busy = true
    local ok, success, result = pcall(self._Register, self, raw)
    if self.StagedAsset then self.StagedAsset:Destroy() self.StagedAsset = nil end
    self.Busy = false
    if not ok then return false, tostring(success) end
    return success, result
end

function customCosmeticsRuntime:Clear()
    self:BeginBatch()
    local keys = {}
    for key in pairs(self.Definitions) do table.insert(keys, key) end
    for _, key in ipairs(keys) do self:Remove(key) end
    self:EndBatch()
end

function customCosmeticsRuntime:Serialize()
    local result = {}
    for _, definition in pairs(self.Definitions) do
        table.insert(result, {Type=definition.Type, Weapon=definition.Weapon, Name=definition.Name,
            Rarity=definition.Rarity, IconId=definition.IconId, ModelId=definition.ModelId,
            AnimationId=definition.AnimationId, Speed=definition.Speed, Loop=definition.Loop,
            Animations=table.clone(definition.Animations or {}), Sounds=table.clone(definition.Sounds or {}),
            AnimationSpeed=definition.AnimationSpeed, SoundVolume=definition.SoundVolume, SoundPitch=definition.SoundPitch})
    end
    table.sort(result, function(a, b)
        return (a.Type .. a.Weapon .. a.Name):lower() < (b.Type .. b.Weapon .. b.Name):lower()
    end)
    return result
end

function customCosmeticsRuntime:EnsureRewardUse()
    if self.RewardUseClass then return end
    local module = lps.Modules.Prompts:FindFirstChild("InspectBackpackReward")
    local class = module and safeRequireModule(module)
    if not class or type(class.Use) ~= "function" then return end
    local original = class.Use
    local replacement = function(prompt, quantity, ...)
        local descriptor = self.LocalRewardEntries[prompt._reward_data]
        if not self.Alive or not descriptor then return original(prompt, quantity, ...) end
        if prompt._is_using then return end
        local ok, why
        if descriptor.Kind == "Boxes" then
            ok, why = self:OpenBox(descriptor.Name, quantity, prompt._reward_data.Weapon)
        else
            local count = self.Injected[descriptor.Name] or 0
            ok = count > 0
            if ok then
                self.Injected[descriptor.Name] = math.max(0, count - 1)
                syncUnlockMask({UnclaimedRewards = true})
            else why = "This local reward has already been used" end
        end
        if ok then
            if prompt.CloseRequest then prompt:CloseRequest() end
        elseif why then mainapi:Notify({Text = tostring(why), Duration = 4}) end
    end
    class.Use = replacement
    self.RewardUseClass, self.RewardUseOriginal, self.RewardUseReplacement = class, original, replacement
end

function customCosmeticsRuntime:Inject(name, amount)
    local cosmetic = name and coss[name]
    if not unlockableCatalogEntry(name, cosmetic) then return false, "Choose a valid cosmetic" end
    amount = math.clamp(math.floor(tonumber(amount) or 1), 1, 9999)
    if self.Injected[name] == amount then return true end
    self:EnsureRewardUse()
    self.Injected[name] = amount
    if syncUnlockMask then syncUnlockMask({CosmeticInventory = true, UnclaimedRewards = true}) end
    return true
end

function customCosmeticsRuntime:RemoveInjected(name)
    if not name or (self.Injected[name] == nil and self.Granted[name] == nil) then return false end
    self.Injected[name], self.Granted[name] = nil, nil
    if syncUnlockMask then syncUnlockMask({CosmeticInventory = true, UnclaimedRewards = true}) end
    return true
end

function customCosmeticsRuntime:BoxNames()
    if self.BoxCatalog then return self.BoxCatalog end
    local names = {}
    for name, reward in pairs(clib.Rewards or {}) do
        if type(reward) == "table" and reward.Type == "Lootbox" and type(reward.GetContents) == "function" then
            table.insert(names, name)
        end
    end
    table.sort(names, function(a, b) return a:lower() < b:lower() end)
    self.BoxCatalog = names
    return names
end

function customCosmeticsRuntime:InjectBox(name, amount)
    local reward = name and clib.Rewards and clib.Rewards[name]
    if not reward or reward.Type ~= "Lootbox" or type(reward.GetContents) ~= "function" then return false, "Choose a registered box" end
    amount = math.clamp(math.floor(tonumber(amount) or 1), 1, 9999)
    if self.Boxes[name] == amount then return true end
    self:EnsureRewardUse()
    self.Boxes[name] = amount
    if syncUnlockMask then syncUnlockMask({UnclaimedRewards = true}) end
    return true
end

function customCosmeticsRuntime:RemoveBox(name)
    if not name or self.Boxes[name] == nil then return false end
    self.Boxes[name] = nil
    if syncUnlockMask then syncUnlockMask({UnclaimedRewards = true}) end
    return true
end

function customCosmeticsRuntime:SetSpecificOwnership(selections, unlocked)
    if type(selections) ~= "table" then return false, "Choose at least one cosmetic or box" end
    local changed, fields = 0, {}
    for key, value in pairs(selections) do
        local entryId = type(key) == "number" and value or key
        local selected = type(key) == "number" or value == true
        if selected and type(entryId) == "string" then
            local kind, name = entryId:match("^(%a+)|(.+)$")
            if kind == "Cosmetic" and unlockableCatalogEntry(name, coss[name]) then
                if unlocked then
                    self.Locked[name] = nil
                    self.Granted[name] = true
                else
                    self.Granted[name] = nil
                    self.Injected[name] = nil
                    self.Locked[name] = true
                    for weapon, slots in pairs(equip) do
                        for cosmeticType, equipped in pairs(slots) do
                            if type(equipped) == "table" and equipped.Name == name then
                                slots[cosmeticType] = nil
                                if type(forceCosmeticUpdate) == "function" then task.defer(forceCosmeticUpdate, weapon, cosmeticType) end
                            end
                        end
                        if not next(slots) then equip[weapon] = nil end
                    end
                    for weapon, slots in pairs(self.CachedEquip) do
                        for category, selected in pairs(slots) do
                            if selected.Name == name then slots[category] = nil end
                        end
                        if not next(slots) then self.CachedEquip[weapon] = nil end
                    end
                    for slot, picked in pairs(emoteWheelSlots) do
                        if picked == name then emoteWheelSlots[slot] = false end
                    end
                end
                self.NativeCatalogDirty = true
                self.NativeCatalogTypes = self.NativeCatalogTypes or {}
                self.NativeCatalogTypes[tostring(coss[name].Type)] = true
                fields.CosmeticInventory = true
                fields.EquippedEmotes = true
                fields.UnclaimedRewards = true
                changed += 1
            elseif kind == "Box" then
                local reward = clib.Rewards and clib.Rewards[name]
                if type(reward) == "table" and reward.Type == "Lootbox" and type(reward.GetContents) == "function" then
                    if unlocked then
                        self.LockedBoxes[name] = nil
                        self.Boxes[name] = math.max(1, tonumber(self.Boxes[name]) or 0)
                        self:EnsureRewardUse()
                    else
                        self.Boxes[name] = nil
                        self.LockedBoxes[name] = true
                    end
                    fields.UnclaimedRewards = true
                    changed += 1
                end
            end
        end
    end
    if changed == 0 then return false, "Choose at least one valid cosmetic or box" end
    self.OwnershipRevision += 1
    local ok, why = syncUnlockMask(fields)
    if not ok then return false, why end
    return true, changed
end

function customCosmeticsRuntime:AnnounceBox(name, quantity, summary)
    -- DisplaySystemMessage is client-local; never send a fabricated player chat.
    local message = "[Plex] Unboxed " .. quantity .. " × " .. name .. ": " .. summary
    local function escape(text)
        return text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end
    local ok = pcall(function()
        local chat = game:GetService("TextChatService")
        local channels = chat:FindFirstChild("TextChannels")
        local channel = channels and (channels:FindFirstChild("RBXSystem") or channels:FindFirstChild("RBXGeneral"))
        if not channel then error("No system chat channel") end
        channel:DisplaySystemMessage(escape(message), "Plex.LocalUnbox")
    end)
    if not ok then
        pcall(function() game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {Text = message}) end)
    end
end

function customCosmeticsRuntime:OpenBox(name, quantity, weapon)
    if self.Opening then return false, "Wait for the current box opening to finish" end
    local count = name and self.Boxes[name] or 0
    if count <= 0 then return false, "Inject this box first" end
    local box = clib.Rewards[name]
    if not box or type(box.GetContents) ~= "function" then return false, "The box catalog is unavailable" end
    weapon = weapon or "IsRandom"
    self.BoxContents = self.BoxContents or {}
    local cacheKey = name .. "|" .. weapon
    local pool = self.BoxContents[cacheKey]
    if not pool then
        local ok, contents = pcall(box.GetContents, weapon)
        if not ok or type(contents) ~= "table" then return false, "Could not read this box's rewards" end
        pool = {Entries = {}, Total = 0}
        for _, entry in ipairs(contents) do
            local reward, weight = entry.Reward, tonumber(entry.Weight)
            if type(reward) == "table" and unlockableCatalogEntry(reward.Name, coss[reward.Name]) and weight and weight > 0 then
                pool.Total += weight
                table.insert(pool.Entries, {Reward = reward, Threshold = pool.Total})
            end
        end
        self.BoxContents[cacheKey] = pool
    end
    if pool.Total <= 0 then return false, "This box has no supported local cosmetic rewards" end
    -- Honour the requested quantity. Bound presentation separately, so a 100-box
    -- action grants 100 outcomes without cloning 100 native slots in one frame.
    quantity = math.min(count, math.clamp(math.floor(tonumber(quantity) or 1), 1, 9999))
    local outcomes, names, totals = {}, {}, {}
    for _ = 1, quantity do
        local roll, selected = math.random() * pool.Total, nil
        for _, entry in ipairs(pool.Entries) do if roll <= entry.Threshold then selected = entry.Reward break end end
        if not selected then return false, "The box reward table is invalid" end
        local result = table.clone(selected)
        self.Granted[result.Name] = true
        table.insert(outcomes, {RewardData = result})
        if not totals[result.Name] then table.insert(names, result.Name) end
        totals[result.Name] = (totals[result.Name] or 0) + (tonumber(result.Quantity) or 1)
    end
    local summary = {}
    for _, rewardName in ipairs(names) do
        table.insert(summary, rewardName .. (totals[rewardName] > 1 and (" × " .. totals[rewardName]) or ""))
    end
    summary = table.concat(summary, ", ")
    self.Boxes[name] = count > quantity and count - quantity or nil
    syncUnlockMask({CosmeticInventory = true, UnclaimedRewards = true})
    local character = lp.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local template = lps.Assets.Lootboxes:FindFirstChild(name)
    if root and template and box.SoundProfile then
        self.Opening = true
        self.BoxProgress = {Name = name, Total = quantity, Completed = 0}
        task.spawn(function()
            local effect = safeRequireModule(lps.Modules.Functions.LootboxEffect)
            local active, firstError = 0, nil
            if type(effect) == "function" then
                for _, outcome in ipairs(outcomes) do
                    while self.Alive and active >= 8 do task.wait(0.1) end
                    if not self.Alive or not root.Parent then break end
                    active += 1
                    task.spawn(function()
                        local ok, err = pcall(effect, root.Position, name, {outcome}, 0, root, lp, nil, math.random(1, 2147483646))
                        if not ok and not firstError then firstError = tostring(err) end
                        self.BoxProgress.Completed += 1
                        active -= 1
                    end)
                    task.wait(0.05)
                end
                while active > 0 do task.wait(0.1) end
            end
            self.Opening = false
            if firstError then warn("[Plex Inventory] Local box effect: " .. firstError) end
        end)
    end
    self:AnnounceBox(name, quantity, summary)
    return true, summary
end

function customCosmeticsRuntime:PlayFinisher(entity, key)
    local definition = self.Definitions[key]
    local template = self.Assets[key]
    if not definition or definition.Type ~= "Finisher" or typeof(template) ~= "Instance" then return false end
    local model
    pcall(function() model = rawget(entity, "Model") or entity.Model end)
    local pivotPart = typeof(model) == "Instance" and (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart)
    if not pivotPart then return false end
    local clone = template:Clone()
    clone.Name = "PlexCustomFinisher"
    for _, part in ipairs(clone:GetDescendants()) do if part:IsA("BasePart") then part.Anchored = true end end
    clone.Parent = workspace
    if clone:IsA("Model") then clone:PivotTo(pivotPart.CFrame)
    elseif clone:IsA("BasePart") then clone.CFrame = pivotPart.CFrame
    else
        local part = clone:FindFirstChildWhichIsA("BasePart", true)
        if part then part.CFrame = pivotPart.CFrame end
    end
    game:GetService("Debris"):AddItem(clone, 5)
    return true
end

local virtualViewModelClassOverrides = {
    [KNIFE_CUSTOM_SKIN] = "Knife",
    [REAVER_KNIFE_CUSTOM_SKIN] = "Knife",
    [DAGGERS_CUSTOM_SKIN] = "Keynais",
    [SNIPER_CUSTOM_SKIN] = "Keyper",
    ["Operator"] = "Sniper",
    [RPG_CUSTOM_SKIN] = "Nuke Launcher",
    [FISTS_CUSTOM_SKIN] = "Fists",
        [BOW_CUSTOM_SKIN] = "Frostbite Bow",
        [ASSAULT_RIFLE_CUSTOM_SKIN] = "AK-47",
        ["Grenade (Custom Skin)"] = "Elixir",
        ["Grenade Raze"] = "Glorious Grenade",
        ["sky"] = "Shining Star",
    ["Molotov (Custom Skin)"] = "Elixir",
    ["Satchel (Custom Skin)"] = "Elixir",
    ["Smoke Grenade (Custom Skin)"] = "Elixir",
    ["Warpstone (Custom Skin)"] = "Elixir",
    [SATCHEL_CUSTOM_SKIN] = "BaseSatchel",
    [DICE_TRIPMINE_SKIN] = "SubspaceTripmine",
    [SPIKE_TRIPMINE_SKIN] = "SubspaceTripmine"
}

local function resolveViewModelClassName(_, cosmetics, resolvedName)
    local custom = resolvedName and customCosmeticsRuntime.Definitions[resolvedName]
    return (custom and custom.Base) or (resolvedName and virtualViewModelClassOverrides[resolvedName]) or resolvedName
end

local resolveViewModelClass
local clientViewModelClass
local clientViewModelBaseNew
local constructingVirtualViewModelClass = false

local function getewep()
    if not fctrl then return nil end
    local fighter = fctrl:GetFighter(lp)
    if not fighter or not fighter.Items then return nil end
    for _, item in fighter.Items do
        if item.IsEquipped then return item.Name end
    end
    return nil
end

if hookfunction then
    local rems = reps:FindFirstChild("Remotes")
    local drems = rems and rems:FindFirstChild("Data")
    local eqrem = drems and drems:FindFirstChild("EquipCosmetic")
    local favrem = drems and drems:FindFirstChild("FavoriteCosmetic")
    local rrems = rems and rems:FindFirstChild("Replication")
    local frems = rrems and rrems:FindFirstChild("Fighter")
    local uirem = frems and frems:FindFirstChild("UseItem")
    local function normalizeCosmeticType(value)
        local name = value
        if type(name) ~= "string" and elib and elib.FromEnum then
            pcall(function() name = elib:FromEnum(value) end)
        end
        if type(name) ~= "string" then return nil end
        local lower = name:lower()
        if lower == "skin" then return "Skin" end
        if lower == "wrap" then return "Wrap" end
        if lower == "charm" then return "Charm" end
        if lower == "finisher" then return "Finisher" end
        return nil
    end

    local function normalizeCosmeticEquipArgs(args)
        local wname, ctype, cname, opts = args[1], args[2], args[3], args[4]
        if type(wname) == "table" then
            local payload = wname
            wname = payload.WeaponName or payload.Weapon or payload.ItemName or payload.Item
            ctype = payload.CosmeticType or payload.Type or ctype
            cname = payload.CosmeticName or payload.Cosmetic or payload.Name or cname
            opts = payload.Options or payload.Opts or opts
        end
        if type(wname) == "table" then
            wname = wname.Name or wname.ItemName or wname.WeaponName
        end
        if type(cname) == "table" then
            ctype = ctype or cname.Type
            cname = cname.Name or cname.CosmeticName or cname.DisplayName
        end
        if type(cname) ~= "string" and elib and elib.FromEnum then
            pcall(function() cname = elib:FromEnum(cname) end)
        end
        ctype = normalizeCosmeticType(ctype)
        if not ctype and type(cname) == "string" and type(coss[cname]) == "table" then
            ctype = normalizeCosmeticType(coss[cname].Type)
        end
        return wname, ctype, cname, type(opts) == "table" and opts or {}
    end

    local function handleCosmeticEquip(args)
        if not unlockAllEnabled and next(customCosmeticsRuntime.Definitions) == nil
            and next(customCosmeticsRuntime.Injected) == nil and next(customCosmeticsRuntime.Granted) == nil then return false end
        local wname, ctype, cname, opts = normalizeCosmeticEquipArgs(args)
        if type(wname) ~= "string" or not ctype then return false end
        if not cname or cname == "None" or cname == "" then
            local slots = equip[wname]
            if slots then
                slots[ctype] = nil
                if not next(slots) then equip[wname] = nil end
            end
            if ctype == "Finisher" then fcache[wname] = nil end
            task.defer(saferep, "WeaponInventory")
            task.defer(forceCosmeticUpdate, wname, ctype)
            if scheduleSkinAutoSave then scheduleSkinAutoSave() end
            return false
        end
        if type(cname) ~= "string" or banned(cname) then return false end
        local catalog = coss[cname]
        if type(catalog) ~= "table" then return false end
        -- Trust the catalog type for wraps/charms even if the locker sends an enum,
        -- lowercase name, or stale type field.
        ctype = normalizeCosmeticType(catalog.Type) or ctype
        local owned = getRealCosmeticEntry and getRealCosmeticEntry(cname)
        if owned == true or (type(owned) == "table" and (owned[wname] or owned.IsUniversal == true)) then
            return false
        end
        applyCosmeticToWeapon(wname, cname, ctype)
        local applied = equip[wname] and equip[wname][ctype]
        if applied then
            if opts.IsInverted ~= nil then applied.Inverted = opts.IsInverted == true end
            if opts.OnlyUseFavorites ~= nil then applied.OnlyUseFavorites = opts.OnlyUseFavorites == true end
        end
        if scheduleSkinAutoSave then scheduleSkinAutoSave() end
        return true
    end

    -- Roblox colon calls use __namecall; hooking FireServer alone misses the game's equip UI.
    if eqrem and hookmetamethod and getnamecallmethod then
        local hookState = getgenv().__PlexCosmeticEquipHook
        if not hookState then
            hookState = {}
            getgenv().__PlexCosmeticEquipHook = hookState
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                if hookState.Remote == self and getnamecallmethod() == "FireServer" then
                    hookState.Calls = (hookState.Calls or 0) + 1
                    local handler = hookState.Handler
                    if handler then
                        local ok, handled = pcall(handler, {...})
                        hookState.LastResult = ok and tostring(handled) or tostring(handled)
                        if ok and handled then return end
                        if not ok then warn("[Plex Skins] Equip hook: " .. tostring(handled)) end
                    end
                end
                return oldNamecall(self, ...)
            end))
        end
        hookState.Remote = eqrem
        hookState.Handler = handleCosmeticEquip
        mainapi:Clean(function()
            if hookState.Handler == handleCosmeticEquip then
                hookState.Handler = nil
                hookState.Remote = nil
            end
        end)
    end

    if eqrem then
        local directState = getgenv().__PlexCosmeticDirectHook
        if not directState then
            directState = {}
            getgenv().__PlexCosmeticDirectHook = directState
            local oldFireServer
            oldFireServer = hookfunction(eqrem.FireServer, newcclosure(function(self, ...)
                local handler = directState.Handler
                if handler and (self == directState.Equip or self == directState.Fav or self == directState.Use) then
                    local ok, handled = pcall(handler, self, {...})
                    if ok and handled then return end
                    if not ok then warn("[Plex Skins] Direct equip hook: " .. tostring(handled)) end
                end
                return oldFireServer(self, ...)
            end))
        end
        directState.Equip, directState.Fav, directState.Use = eqrem, favrem, uirem
        directState.Handler = function(self, args)
            if uirem and self == uirem and fctrl then
                pcall(function()
                    local fighter = fctrl:GetFighter(lp)
                    if fighter and fighter.Items then
                        for _, item in fighter.Items do
                            if item:Get("ObjectID") == args[1] then lwep = item.Name break end
                        end
                    end
                end)
            end
            if self == eqrem then return handleCosmeticEquip(args) end
            if self == favrem and unlockAllEnabled then
                local fwep, fname, fstate = args[1], args[2], args[3]
                if type(fwep) ~= "string" or not fname or fname == "None" or fname == "" or banned(fname) then return false end
                favs[fwep] = favs[fwep] or {}
                favs[fwep][fname] = fstate or nil
                task.spawn(saferep, "FavoritedCosmetics")
                return true
            end
            return false
        end
        local activeHandler = directState.Handler
        mainapi:Clean(function()
            if directState.Handler == activeHandler then directState.Handler = nil end
        end)
    end
end

local citem
pcall(function() citem = require(lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

-- Older builds left these four wrappers installed after unload. A stale
-- constructor can overwrite the new selection or reference a deleted asset.
-- Migrate only recognized Plex wrappers, then own/restore every replacement.
local cosmeticMethodRecords = {}
local function cosmeticMethodOriginal(class, method)
    local original = class[method]
    local seen = {}
    local function unwrap(fn, depth)
        if type(fn) ~= "function" or seen[fn] or depth > 8 then return nil end
        seen[fn] = true
        local source, name = debug.info(fn, "sn")
        if name == method then return fn end
        if not (source:find("PlexMain", 1, true) or source:find("plex.cc TPHandler", 1, true)) then return nil end
        if not debug.getupvalues then return nil end
        local ok, values = pcall(debug.getupvalues, fn)
        if not ok then return nil end
        for _, candidate in pairs(values) do
            if type(candidate) == "function" then
                local candidateName = debug.info(candidate, "n")
                if candidateName == "" or candidateName == method then
                    local found = unwrap(candidate, depth + 1)
                    if found then return found end
                end
            end
        end
    end
    original = unwrap(original, 0) or original
    class[method] = original
    return original
end
local function ownCosmeticMethod(class, method, original)
    cosmeticMethodRecords[#cosmeticMethodRecords + 1] = {Class = class, Method = method, Original = original, Replacement = class[method]}
end
mainapi:Clean(function()
    for _, record in ipairs(cosmeticMethodRecords) do
        if record.Class[record.Method] == record.Replacement then record.Class[record.Method] = record.Original end
    end
    table.clear(cosmeticMethodRecords)
end)

local function hideCustomSkinRig(viewModel)
    local model = type(viewModel) == "table" and viewModel.ItemModel
    if typeof(model) ~= "Instance" or not model:GetAttribute("PlexCustomSkin") or viewModel.__PlexSkinRigHidden then return end
    viewModel.__PlexSkinRigHidden = true
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part:GetAttribute("PlexCustomHiddenRig") then
            part.Transparency, part.LocalTransparencyModifier = 1, 1
            -- Use the native visibility stack so first/third-person transitions
            -- cannot reveal the weapon geometry behind the replacement.
            if viewModel._LocalTransparencyModifier then viewModel:_LocalTransparencyModifier(part, "PlexCustomSkin", 1) end
        end
    end
end

local function applyLiveFistsMeshProfile(wname, viewModel)
    if wname ~= "Fists" then return end
    local skin = equip[wname] and equip[wname].Skin
    local skinName = skin and (skin.ViewModelName or skin.Name)
    local profile = skinName and FISTS_MESH_SKIN_OVERRIDES[skinName]
    if not profile then return end

    task.spawn(function()
        for _ = 1, 30 do
            local model
            if typeof(viewModel) == "Instance" then
                model = viewModel
            elseif type(viewModel) == "table" then
                model = viewModel.Model or viewModel.ItemModel
            end
            if typeof(model) == "Instance" then
                if applyFistsMeshProfile(model, profile) then
                    return
                end
            end
            task.wait()
        end
    end)
end

if citem and citem._CreateViewModel then
    local ocvm = cosmeticMethodOriginal(citem, "_CreateViewModel")
    citem._CreateViewModel = function(self, vmref)
        local wname = self.Name
        local wplr = self.ClientFighter and self.ClientFighter.Player
        cwep = (wplr == lp) and wname or nil
        local directClass
        local selectedCosmetics = cosmeticsForPlayer(wplr, wname)
        if selectedCosmetics and vmref then
            local cos = selectedCosmetics
            local dk = self:ToEnum("Data")
            local data = vmref[dk] or vmref.Data or {}
            if data then
                if vmref[dk] ~= nil or vmref.Data == nil then
                    vmref[dk] = data
                    vmref.Data = nil
                else
                    vmref.Data = data
                end
                local resolvedName = resolveViewModelName(wname, cos)
                local className = resolveViewModelClassName(wname, cos, resolvedName)
                if cos.Skin then
                    data[self:ToEnum("Skin")] = cos.Skin
                end
                data[self:ToEnum("Name")] = resolvedName
                if cos.Wrap then
                    data[self:ToEnum("Wrap")] = cos.Wrap
                end
                if cos.Charm then
                    data[self:ToEnum("Charm")] = cos.Charm
                end
                data.Skin = nil
                data.Name = nil
                data.Wrap = nil
                data.Charm = nil
                if className ~= resolvedName and resolveViewModelClass then
                    directClass = resolveViewModelClass(className)
                end
            end
        end
        if directClass and directClass ~= clientViewModelClass and directClass.new then
            local identity = getthreadidentity and getthreadidentity() or 8
            constructingVirtualViewModelClass = true
            local ok, res = pcall(function()
                if setthreadidentity then pcall(setthreadidentity, 2) end
                return directClass.new(vmref, self)
            end)
            constructingVirtualViewModelClass = false
            if setthreadidentity then pcall(setthreadidentity, identity) end
            cwep = nil
            if ok then
                hideCustomSkinRig(res)
                applyLiveFistsMeshProfile(wname, res)
                return res
            end
        end
        local res = ocvm(self, vmref)
        cwep = nil
        hideCustomSkinRig(res)
        applyLiveFistsMeshProfile(wname, res)
        return res
    end
    ownCosmeticMethod(citem, "_CreateViewModel", ocvm)
end

local vmmod = lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
if vmmod then
    local loaded, cvm = pcall(require, vmmod)
    if not loaded or type(cvm) ~= "table" then
        warn("[Plex Skins] Viewmodel hook unavailable: " .. tostring(cvm))
        cvm = nil
    end
    if cvm then
    clientViewModelClass = cvm
    if cvm.GetWrap then
        local ogw = cosmeticMethodOriginal(cvm, "GetWrap")
        cvm.GetWrap = function(self)
            local ci = self.ClientItem
            local wname = ci and ci.Name
            local wplr = ci and ci.ClientFighter and ci.ClientFighter.Player
            local weq = wname and cosmeticsForPlayer(wplr, wname)
            return (weq and weq.Wrap) or ogw(self)
        end
        ownCosmeticMethod(cvm, "GetWrap", ogw)
    end
    if cvm._UpdateWrap and wrapController then
        local oldUpdateWrap = cosmeticMethodOriginal(cvm, "_UpdateWrap")
        local function isCustomTripmineViewModel(self)
            if not self then return false end
            if TRIPMINE_MESH_SKIN_OVERRIDES[self.Name] then
                return true
            end
            local ci = self.ClientItem
            local weapon = ci and ci.Name
            local skin = weapon and equip[weapon] and equip[weapon].Skin
            local skinName = skin and (skin.ViewModelName or skin.Name)
            return weapon == "Subspace Tripmine" and TRIPMINE_MESH_SKIN_OVERRIDES[skinName] ~= nil
        end
        local function collectCustomTripmineWrapTargets(model)
            local targets = {}
            for _, descendant in ipairs(model:GetDescendants()) do
                if descendant:IsA("BasePart") and descendant:GetAttribute("__LionCustomTripmineMeshPart") then
                    if descendant:GetAttribute("WrapGroup") == nil then
                        descendant:SetAttribute("WrapGroup", 1)
                    end
                    descendant:SetAttribute("IgnoreTransparency", true)
                    pcall(function() descendant:AddTag("Wrappable") end)
                    pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
                    table.insert(targets, descendant)
                end
            end
            return targets
        end
        cvm._UpdateWrap = function(self, ...)
            if isCustomTripmineViewModel(self) and self.Model then
                local targets = collectCustomTripmineWrapTargets(self.Model)
                if #targets > 0 then
                    local wrap = self.GetWrap and self:GetWrap() or nil
                    if self._original_wrap_properties then
                        pcall(wrapController.ResetWrap, wrapController, self._original_wrap_properties)
                        self._original_wrap_properties = nil
                    end
                    if self.__LionCustomTripmineWrapProperties then
                        pcall(wrapController.ResetWrap, wrapController, self.__LionCustomTripmineWrapProperties)
                        self.__LionCustomTripmineWrapProperties = nil
                    end
                    if wrap then
                        self.__LionCustomTripmineWrapProperties = wrapController:RecordOriginalWrapProperties(targets)
                        wrapController:ApplyWrap(self.__LionCustomTripmineWrapProperties, wrap, true)
                    end
                    if self._UpdateLocalTransparencyModifiers then
                        pcall(self._UpdateLocalTransparencyModifiers, self)
                    end
                    return
                end
            end
            return oldUpdateWrap(self, ...)
        end
        ownCosmeticMethod(cvm, "_UpdateWrap", oldUpdateWrap)
    end
    local onew = cosmeticMethodOriginal(cvm, "new")
    clientViewModelBaseNew = onew
    cvm.new = function(rdata, cliitm)
        if constructingVirtualViewModelClass then
            return onew(rdata, cliitm)
        end
        local wplr = cliitm.ClientFighter and cliitm.ClientFighter.Player
        local wname = cwep or cliitm.Name
        local className = wname
        local selectedCosmetics = cosmeticsForPlayer(wplr, wname)
        if selectedCosmetics then
            local rcls = require(reps.Modules.ReplicatedClass)
            local dk = rcls:ToEnum("Data")
            local slot = rdata[dk] or rdata.Data or {}
            if rdata[dk] ~= nil or rdata.Data == nil then
                rdata[dk] = slot
                rdata.Data = nil
            else
                rdata.Data = slot
            end
            local cos = selectedCosmetics
            local resolvedName = resolveViewModelName(wname, cos)
            className = resolveViewModelClassName(wname, cos, resolvedName)
            if cos.Skin then
                slot[rcls:ToEnum("Skin")] = cos.Skin
            end
            slot[rcls:ToEnum("Name")] = resolvedName
            if cos.Wrap then
                slot[rcls:ToEnum("Wrap")] = cos.Wrap
            end
            if cos.Charm then
                slot[rcls:ToEnum("Charm")] = cos.Charm
            end
            slot.Skin = nil
            slot.Name = nil
            slot.Wrap = nil
            slot.Charm = nil
        end
        local targetNew = onew
        local targetClass = className ~= wname and resolveViewModelClass and resolveViewModelClass(className)
        if targetClass and targetClass ~= clientViewModelClass and targetClass.new then
            targetNew = targetClass.new
        end
        constructingVirtualViewModelClass = targetNew ~= onew
        local ok, res = pcall(targetNew, rdata, cliitm)
        constructingVirtualViewModelClass = false
        if not ok and selectedCosmetics and selectedCosmetics.Skin then
            local rcls = require(reps.Modules.ReplicatedClass)
            local dk = rcls:ToEnum("Data")
            local slot = rdata[dk] or rdata.Data or {}
            rdata[dk] = slot
            rdata.Data = nil
            slot[rcls:ToEnum("Name")] = wname
            slot.Name = nil
            ok, res = pcall(onew, rdata, cliitm)
        end
        if not ok then error(res) end
        hideCustomSkinRig(res)
        if selectedCosmetics and res then
            for _, method in ipairs({"_UpdateWrap", "UpdateWrap", "_UpdateCharm", "UpdateCharm", "_UpdateCosmetics", "UpdateCosmetics"}) do
                if res[method] then
                    pcall(res[method], res)
                end
            end
            applyLiveFistsMeshProfile(wname, res)
        end
        return res
    end
    ownCosmeticMethod(cvm, "new", onew)
    end
end

local viewModelClassCache = {}
local function normalizeViewModelName(name)
    return tostring(name or ""):gsub("[%W_]+", ""):lower()
end

resolveViewModelClass = function(name)
    if not clientViewModelClass then return nil end
    local key = normalizeViewModelName(name)
    if viewModelClassCache[key] ~= nil then
        return viewModelClassCache[key] or clientViewModelClass
    end
    local targetClass = clientViewModelClass
    local vmFolder = lps.Modules:FindFirstChild("ViewModels")
    if vmFolder then
        for _, module in pairs(vmFolder:GetDescendants()) do
            if module:IsA("ModuleScript") and normalizeViewModelName(module.Name) == key then
                local ok, customClass = pcall(require, module)
                if ok and type(customClass) == "table" and type(customClass.new) == "function" then
                    targetClass = customClass
                end
                break
            end
        end
    end
    viewModelClassCache[key] = targetClass
    return targetClass
end

;(function()
local function getLocalItem(weapon)
    local fighter = fctrl and fctrl:GetFighter(lp)
    for _, item in pairs(fighter and fighter.Items or {}) do
        if item.Name == weapon then
            return item
        end
    end
end

refreshAnimatedWrapState = function()
    local fighter = fctrl and fctrl:GetFighter(lp)
    for _, item in pairs(fighter and fighter.Items or {}) do
        local viewModel = item and item.ViewModel
        for _, object in ipairs({item, viewModel}) do
            if object then
                for _, methodName in ipairs({"_UpdateWrap", "UpdateWrap"}) do
                    local method = object[methodName]
                    if type(method) == "function" then pcall(method, object) end
                end
            end
        end
    end
end

local function getWorldSkinName(weapon)
    local skin = equip[weapon] and equip[weapon].Skin
    return skin and (skin.WorldViewModelName or skin.SourceViewModelName or skin.ViewModelName or skin.Name)
end

local function getEquippedWeaponWrap(weapon)
    local item = getLocalItem(weapon)
    if item and item.GetWrap then
        local ok, wrap = pcall(item.GetWrap, item)
        if ok then
            return wrap
        end
    end
    return equip[weapon] and equip[weapon].Wrap
end

local function isInsideWorkspaceViewModels(inst)
    local viewModels = workspace:FindFirstChild("ViewModels")
    return viewModels and inst:IsDescendantOf(viewModels)
end

local function isRpgRazeEquipped()
    return getWorldSkinName("RPG") == RPG_CUSTOM_SKIN
end

local function tryApplyRpgProjectileSkin(inst)
    local profile = RPG_MESH_SKIN_OVERRIDES[RPG_CUSTOM_SKIN]
    if not (profile and isRpgRazeEquipped() and typeof(inst) == "Instance") then return end
    if isInsideWorkspaceViewModels(inst) then return end
    if inst:GetAttribute("__LionRpgProjectileSkinChecked") then return end

    local shouldApply = false
    if inst:IsA("MeshPart") or inst:IsA("SpecialMesh") then
        shouldApply = meshMatchesAnyAssetId(inst, profile.RocketMeshIds) or meshMatchesAnyAssetId(inst, profile.JuggleMeshIds)
    elseif inst:IsA("Model") then
        shouldApply = namePathContains(inst, "rocket") or namePathContains(inst, "projectile")
    end
    if not shouldApply then return end

    inst:SetAttribute("__LionRpgProjectileSkinChecked", true)
    applyRpgMeshProfile(inst, profile, {
        ShowRocket = true,
        ForceRocket = true
    })
end

local function installRpgProjectileSkinHook()
    local env = getgenv and getgenv() or _G
    local state = env.__LionRpgProjectileSkinHookState or {}
    env.__LionRpgProjectileSkinHookState = state
    local version = 2
    if state.Version == version and state.Connection then return end
    if state.Connection then
        pcall(function() state.Connection:Disconnect() end)
    end
    state.Version = version
    state.Connection = workspace.DescendantAdded:Connect(function(inst)
        if isRpgRazeEquipped() and (inst:IsA("MeshPart") or inst:IsA("SpecialMesh") or inst:IsA("Model")) then
            task.defer(tryApplyRpgProjectileSkin, inst)
        end
    end)
    task.spawn(function()
        if not isRpgRazeEquipped() then return end
        for i, inst in ipairs(workspace:GetDescendants()) do
            if state.Version ~= version then return end
            tryApplyRpgProjectileSkin(inst)
            if i % 250 == 0 then RunService.Heartbeat:Wait() end
        end
    end)
end

local function disableRpgProjectileSkinHook()
    local env = getgenv and getgenv() or _G
    local state = env.__LionRpgProjectileSkinHookState
    if state and state.Connection then
        pcall(function() state.Connection:Disconnect() end)
    end
    env.__LionRpgProjectileSkinHookState = {
        Version = 3,
        Connection = nil
    }
end

local function ensurePlacedTripmineWrapTargets(visual)
    if typeof(visual) ~= "Instance" then return end
    for _, descendant in ipairs(visual:GetDescendants()) do
        if descendant:IsA("BasePart") and descendant:GetAttribute("__LionCustomTripmineMeshPart") then
            if descendant:GetAttribute("WrapGroup") == nil then
                descendant:SetAttribute("WrapGroup", 1)
            end
            descendant:SetAttribute("IgnoreTransparency", true)
            pcall(function() descendant:AddTag("Wrappable") end)
            pcall(function() collectionService:AddTag(descendant, "Wrappable") end)
        end
    end
end

local function applyPlacedTripmineWrap(visual)
    if not wrapController or typeof(visual) ~= "Instance" then return end
    ensurePlacedTripmineWrapTargets(visual)
    local wrap = getEquippedWeaponWrap("Subspace Tripmine")
    pcall(function()
        local originalWrapProperties = wrapController:RecordOriginalWrapProperties(visual)
        wrapController:ApplyWrap(originalWrapProperties, wrap, true)
    end)
end

local function isLocalPlacedObject(object, weapon)
    local userId = object:GetAttribute("PlacedByUserID")
        or object:GetAttribute("ThrownByUserID")
        or object:GetAttribute("OwnerUserID")
    if userId ~= nil then
        return tonumber(userId) == lp.UserId
    end

    local objectId = object:GetAttribute("ObjectID")
    local item = getLocalItem(weapon)
    return objectId ~= nil and item and item.Get and item:Get("ObjectID") == objectId
end

local function isInsidePlacedSkinVisual(inst)
    local current = inst
    while current do
        if current.Name == "__LionPlacedSkin" or current:GetAttribute("__LionPlacedSkin") then
            return true
        end
        current = current.Parent
    end
    return false
end

local function hideOriginalTripmineVisual(object)
    if typeof(object) ~= "Instance" then return end

    local function hide(inst)
        if isInsidePlacedSkinVisual(inst) then return end
        if inst:IsA("BasePart") then
            inst.Transparency = 1
            inst.LocalTransparencyModifier = 1
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            inst.Transparency = 1
        elseif inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") then
            inst.Enabled = false
        end
    end

    for _, descendant in ipairs(object:GetDescendants()) do
        hide(descendant)
    end

    if not object:GetAttribute("__LionHideOriginalTripmineHook") then
        object:SetAttribute("__LionHideOriginalTripmineHook", true)
        local connection
        connection = object.DescendantAdded:Connect(function(descendant)
            task.defer(hide, descendant)
        end)
        task.delay(8, function()
            if connection then
                connection:Disconnect()
            end
        end)
    end

    if not object:GetAttribute("__LionHideOriginalTripmineLoop") then
        object:SetAttribute("__LionHideOriginalTripmineLoop", true)
        task.spawn(function()
            for _ = 1, 80 do
                if not object.Parent then break end
                for _, descendant in ipairs(object:GetDescendants()) do
                    hide(descendant)
                end
                task.wait(0.1)
            end
            if object.Parent then
                object:SetAttribute("__LionHideOriginalTripmineLoop", nil)
            end
        end)
    end
end

local function prunePlacedTripmineVisualToCustomMesh(visual)
    if typeof(visual) ~= "Instance" then return end
    local primaryPart
    for _, descendant in ipairs(visual:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("__LionCustomTripmineMeshPart") then
                primaryPart = primaryPart or descendant
            else
                descendant:Destroy()
            end
        end
    end
    if visual:IsA("Model") and primaryPart then
        visual.PrimaryPart = primaryPart
    end
end

local function isInsideCustomTripmineMeshPart(inst)
    local current = inst
    while current do
        if current:IsA("BasePart") and current:GetAttribute("__LionCustomTripmineMeshPart") then
            return true
        end
        current = current.Parent
    end
    return false
end

local function forcePlacedSkinVisualVisible(visual)
    if typeof(visual) ~= "Instance" then return end

    local function show(inst)
        if inst:IsA("BasePart") and inst:GetAttribute("__LionCustomTripmineMeshPart") then
            inst.Transparency = 0
            inst.LocalTransparencyModifier = 0
        elseif (inst:IsA("Decal") or inst:IsA("Texture")) and isInsideCustomTripmineMeshPart(inst) then
            inst.Transparency = 0
        end
    end

    for _, descendant in ipairs(visual:GetDescendants()) do
        show(descendant)
    end

    if not visual:GetAttribute("__LionShowPlacedSkinLoop") then
        visual:SetAttribute("__LionShowPlacedSkinLoop", true)
        local connection
        connection = visual.DescendantAdded:Connect(function(descendant)
            task.defer(show, descendant)
        end)
        task.spawn(function()
            for _ = 1, 100 do
                if not visual.Parent then break end
                for _, descendant in ipairs(visual:GetDescendants()) do
                    show(descendant)
                end
                task.wait(0.1)
            end
            if connection then
                connection:Disconnect()
            end
            if visual.Parent then
                visual:SetAttribute("__LionShowPlacedSkinLoop", nil)
            end
        end)
    end
end

local function pivotPlacedTripmineVisual(visual, hitbox, profile)
    if not (visual and visual:IsA("Model") and hitbox and hitbox:IsA("BasePart")) then return end
    local boundsCFrame, boundsSize = visual:GetBoundingBox()
    local centerOffset = visual:GetPivot():ToObjectSpace(boundsCFrame)
    local groundOffset = profile and profile.WorldGroundOffset or 0
    local targetCenterOffsetY = (-hitbox.Size.Y * 0.5) + (boundsSize.Y * 0.5) + groundOffset
    local targetBoundsCFrame = hitbox.CFrame * CFrame.new(0, targetCenterOffsetY, 0)
    visual:PivotTo(targetBoundsCFrame * centerOffset:Inverse())
end

local function placedVisualAnchor(object)
    if not object or not object.Parent then return nil end
    local hitbox = object:FindFirstChild("Hitbox", true)
    if hitbox and hitbox:IsA("BasePart") then return hitbox end
    if object:IsA("BasePart") then return object end
    if object:IsA("Model") then
        if object.PrimaryPart and object.PrimaryPart:IsA("BasePart") then return object.PrimaryPart end
        return object:FindFirstChildWhichIsA("BasePart", true)
    end
    return object:FindFirstChildWhichIsA("BasePart", true)
end

local function replacePlacedModelVisual(object, source)
    if typeof(object) ~= "Instance" or typeof(source) ~= "Instance" or not object.Parent then return false end
    local existing = object:FindFirstChild("__LionPlacedSkin")
    if existing then existing:Destroy() end
    local anchor = placedVisualAnchor(object)
    if not anchor then return false end

    local visual = source:Clone()
    if visual:IsA("Folder") then
        local model = Instance.new("Model")
        model.Name = visual.Name
        for _, child in ipairs(visual:GetChildren()) do child.Parent = model end
        visual:Destroy()
        visual = model
    elseif visual:IsA("BasePart") then
        local model = Instance.new("Model")
        model.Name = visual.Name
        visual.Parent = model
        model.PrimaryPart = visual
        visual = model
    end
    if not visual:IsA("Model") then
        visual:Destroy()
        return false
    end

    visual.Name = "__LionPlacedSkin"
    visual:SetAttribute("__LionPlacedSkin", true)
    for _, descendant in ipairs(visual:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false
            descendant.CanCollide = false
            descendant.CanTouch = false
            descendant.CanQuery = false
            descendant.Massless = true
            descendant.LocalTransparencyModifier = 0
        end
    end

    local targetCFrame = anchor.CFrame
    if object:IsA("Model") then
        pcall(function() targetCFrame = object:GetPivot() end)
    end
    visual.Parent = object
    visual:PivotTo(targetCFrame)

    -- Hide only the original local visual. Physics/collision objects remain in place.
    for _, descendant in ipairs(object:GetDescendants()) do
        if not descendant:IsDescendantOf(visual) then
            if descendant:IsA("BasePart") then
                descendant.LocalTransparencyModifier = 1
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant.Transparency = 1
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                descendant.Enabled = false
            end
        end
    end

    for _, part in ipairs(visual:GetDescendants()) do
        if part:IsA("BasePart") then
            local weld = Instance.new("WeldConstraint")
            weld.Name = "PlexPlacedVisualWeld"
            weld.Part0 = anchor
            weld.Part1 = part
            weld.Parent = part
        end
    end
    return true
end

local function installPlacedCosmeticHooks()
    local components = lps.Modules:FindFirstChild("GameComponents")
    if not components then return end

    pcall(function()
        local jumpPads = require(components:WaitForChild("JumpPads", 10))
        if jumpPads.__LionSkinHook then return end
        jumpPads.__LionSkinHook = true
        local oldObjectAdded = jumpPads._ObjectAdded
        jumpPads._ObjectAdded = function(self, object)
            local skinName = getWorldSkinName("Jump Pad")
            local replaceLocal = skinName and isLocalPlacedObject(object, "Jump Pad")
            if replaceLocal then
                object:SetAttribute("ViewModelName", skinName)
            end
            local result = oldObjectAdded(self, object)
            if replaceLocal then
                task.defer(function()
                    if not object.Parent then return end
                    local misc = lps.Assets and lps.Assets:FindFirstChild("Misc")
                    local assets = misc and misc:FindFirstChild("JumpPads")
                    local source = assets and (assets:FindFirstChild(skinName) or findDescendantByName(assets, skinName))
                    if source then
                        replacePlacedModelVisual(object, source)
                    end
                end)
            end
            return result
        end
    end)

    pcall(function()
        local tripmines = require(components:WaitForChild("SubspaceTripmines", 10))
        if tripmines.__LionSkinHook then return end
        tripmines.__LionSkinHook = true
        local oldObjectAdded = tripmines._ObjectAdded
        tripmines._ObjectAdded = function(self, object)
            local skinName = getWorldSkinName("Subspace Tripmine")
            local placedSkinName = skinName == "RNG Dice" and DICE_TRIPMINE_SKIN or skinName
            local meshProfile = TRIPMINE_MESH_SKIN_OVERRIDES[placedSkinName]
            if meshProfile and isLocalPlacedObject(object, "Subspace Tripmine") then
                task.defer(function()
                    if not object.Parent or object:FindFirstChild("__LionPlacedSkin") then return end
                    hideOriginalTripmineVisual(object)

                    local throwables = lps.Assets:FindFirstChild("Throwables")
                    local viewModels = lps.Assets:FindFirstChild("ViewModels")
                    local sourceName = meshProfile.BaseAssetName or "Subspace Tripmine"
                    local source = (throwables and findDescendantByName(throwables, sourceName)) or (viewModels and findDescendantByName(viewModels, sourceName))
                    local hitbox = object:FindFirstChild("Hitbox", true)
                    if not source or not hitbox or not hitbox:IsA("BasePart") then return end

                    local visual = source:Clone()
                    if not applyTripmineMeshProfile(visual, meshProfile, true) then
                        visual:Destroy()
                        return
                    end
                    prunePlacedTripmineVisualToCustomMesh(visual)
                    if visual:IsA("BasePart") then
                        local model = Instance.new("Model")
                        model.Name = visual.Name
                        visual.Parent = model
                        model.PrimaryPart = visual
                        visual = model
                    end
                    if not visual:IsA("Model") then return end
                    for _, descendant in pairs(visual:GetDescendants()) do
                        if descendant.Name == "_right_arm" or descendant.Name == "_left_arm" or descendant.Name == "_fake" then
                            descendant:Destroy()
                        end
                    end
                    visual.Name = "__LionPlacedSkin"
                    visual:SetAttribute("__LionPlacedSkin", true)
                    visual.Parent = object
                    hideOriginalTripmineVisual(object)
                    pivotPlacedTripmineVisual(visual, hitbox, meshProfile)
                    forcePlacedSkinVisualVisible(visual)
                    for _, part in pairs(visual:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Anchored = false
                            part.CanCollide = false
                            part.CanTouch = false
                            part.CanQuery = false
                            part.Massless = true
                            local weld = Instance.new("WeldConstraint")
                            weld.Part0 = hitbox
                            weld.Part1 = part
                            weld.Parent = part
                        end
                    end
                    applyPlacedTripmineWrap(visual)
                    forcePlacedSkinVisualVisible(visual)
                end)
            end
            return oldObjectAdded(self, object)
        end
    end)

    pcall(function()
        local fireHitboxes = require(components:WaitForChild("FireHitboxes", 10))
        local fireAssets = lps.Assets:WaitForChild("Misc", 10):WaitForChild("FireHitboxes", 10)
        if not fireAssets:FindFirstChild("Elixir") then
            local elixirEffect = lps.Assets.Misc:FindFirstChild("ElixirExplosionEffect")
            local defaultFire = fireAssets:FindFirstChild("Default")
            if elixirEffect and defaultFire then
                local elixirFire = defaultFire:Clone()
                elixirFire.Name = "Elixir"
                for _, effect in pairs(elixirFire:GetDescendants()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Beam") then
                        effect:Destroy()
                    end
                end
                local primary = elixirFire:FindFirstChild("Primary")
                local attachment = elixirEffect:FindFirstChild("Attachment")
                if primary and attachment then
                    attachment:Clone().Parent = primary
                end
                elixirFire.Parent = fireAssets
            end
        end

        local collectionService = game:GetService("CollectionService")
        local function replaceFireVisual(object)
            local skinName = getWorldSkinName("Molotov")
            if not skinName or not isLocalPlacedObject(object, "Molotov") then return end
            object:SetAttribute("ViewModelName", skinName)
            task.spawn(function()
                local entry
                for _ = 1, 20 do
                    entry = fireHitboxes._fire_hitboxes and fireHitboxes._fire_hitboxes[object]
                    if entry and entry.Visual then break end
                    task.wait()
                end
                if not entry or not entry.Visual or not object.Parent then return end
                local source = fireAssets:FindFirstChild(skinName) or fireAssets:FindFirstChild("Default")
                if not source then return end

                local visual = source:Clone()
                visual.Name = skinName
                visual.PrimaryPart = visual:FindFirstChild("Primary")
                if not visual.PrimaryPart then return end
                visual.PrimaryPart.Size = object.Size
                visual:PivotTo(object.CFrame)
                visual.Parent = workspace
                for _, sound in ipairs({entry.Sound1, entry.Sound2}) do
                    if sound then sound.Parent = visual.PrimaryPart end
                end
                local oldVisual = entry.Visual
                entry.Visual = visual
                oldVisual:Destroy()
            end)
        end

        collectionService:GetInstanceAddedSignal("FireHitbox"):Connect(replaceFireVisual)
        for _, object in pairs(collectionService:GetTagged("FireHitbox")) do
            task.defer(replaceFireVisual, object)
        end
    end)

    pcall(function()
        local smokeModule = lps.Modules:FindFirstChild("SmokeCloud")
        if not smokeModule then return end
        local smokeCloud = require(smokeModule)
        if smokeCloud.__LionSkinHook or type(smokeCloud.new) ~= "function" then return end
        smokeCloud.__LionSkinHook = true

        local oldNew = smokeCloud.new
        smokeCloud.new = function(...)
            local args = { ... }
            local cloud = oldNew(...)
            task.defer(function()
                local skinName = getWorldSkinName("Smoke Grenade")
                if skinName ~= "Elixir" or type(cloud) ~= "table" then return end

                local ownerObject
                for _, value in ipairs(args) do
                    if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
                        ownerObject = value
                        break
                    end
                end

                local model = cloud.Model
                if not ownerObject then
                    for _, value in pairs(cloud) do
                        if typeof(value) == "Instance" and isLocalPlacedObject(value, "Smoke Grenade") then
                            ownerObject = value
                            break
                        end
                    end
                end
                if not ownerObject and typeof(model) == "Instance" and isLocalPlacedObject(model, "Smoke Grenade") then
                    ownerObject = model
                end
                if not ownerObject then
                    local item = getLocalItem("Smoke Grenade")
                    local localObjectId = item and item.Get and item:Get("ObjectID")
                    local cloudObjectId = rawget(cloud, "ObjectID") or rawget(cloud, "_object_id")
                    if localObjectId ~= nil and cloudObjectId == localObjectId then
                        ownerObject = model
                    end
                end
                if not ownerObject or typeof(model) ~= "Instance" or not model.Parent then return end
                if model:FindFirstChild("__LionSmokeSkin") then return end

                for _, descendant in pairs(model:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        descendant.LocalTransparencyModifier = 1
                    end
                end

                local throwables = lps.Assets:FindFirstChild("Throwables")
                local source = throwables and throwables:FindFirstChild(skinName)
                if not source then return end

                local visual = source:Clone()
                visual.Name = "__LionSmokeSkin"
                local anchor = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
                if not anchor then
                    anchor = Instance.new("Part")
                    anchor.Name = "__LionSmokeAnchor"
                    anchor.Size = Vector3.new(0.1, 0.1, 0.1)
                    anchor.Transparency = 1
                    anchor.Anchored = true
                    anchor.CanCollide = false
                    anchor.CanTouch = false
                    anchor.CanQuery = false
                    anchor.CFrame = model:IsA("Model") and model:GetPivot() or CFrame.new()
                    anchor.Parent = model
                end

                visual.Parent = model
                visual:PivotTo(anchor.CFrame)
                for _, part in pairs(visual:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = false
                        part.CanCollide = false
                        part.CanTouch = false
                        part.CanQuery = false
                        part.Massless = true
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0 = anchor
                        weld.Part1 = part
                        weld.Parent = part
                    end
                end
            end)
            return cloud
        end
    end)
end

disableRpgProjectileSkinHook()
installPlacedCosmeticHooks()
end)()

local function isValidViewModel(viewModel)
    return type(viewModel) == "table"
        and viewModel._destroyed ~= true
        and typeof(viewModel.Model) == "Instance"
        and typeof(viewModel.ItemModel) == "Instance"
end

local ogvi = ilib.GetViewModelImageFromWeaponData
local wrappedCosmeticImage=function(self, wdata, hires)
    if not wdata or not localWeaponDataRecords[wdata] then return ogvi(self, wdata, hires) end
    local wname = wdata.Name
    local weq = equip[wname]
    if weq and weq.Skin then
        local skinViewModelName = weq.Skin.ViewModelName or weq.Skin.Name
        local skinSourceName = weq.Skin.SourceViewModelName or skinViewModelName
        local sinfo = self.ViewModels[skinViewModelName] or self.ViewModels[skinSourceName]
        if sinfo then return sinfo[hires and "ImageHighResolution" or "Image"] or sinfo.Image end
        return weq.Skin[hires and "ImageHighResolution" or "Image"] or weq.Skin.Image or ""
    end
    return ogvi(self, wdata, hires)
end
ilib.GetViewModelImageFromWeaponData=wrappedCosmeticImage
mainapi:Clean(function()
    if ilib.GetViewModelImageFromWeaponData==wrappedCosmeticImage then ilib.GetViewModelImageFromWeaponData=ogvi end
end)

pcall(function()
    local vpmod = require(lps.Modules.Pages.ViewProfile)
    if vpmod and vpmod.Fetch then
        local ofetch = vpmod.Fetch
        vpmod.Fetch = function(self, tplr)
            vprof = tplr
            return ofetch(self, tplr)
        end
    end
end)

local cent
pcall(function() cent = require(lps.Modules.ClientReplicatedClasses.ClientEntity) end)

if cent and cent._PlayFinisher then
    local ofin = cent._PlayFinisher

    -- Diamond Hands is meant to read like a frozen diamond statue.
    -- Keep the eliminated character locked in the pose it had when the
    -- finisher started instead of letting the normal death physics fold it
    -- onto the floor.
    local function freezeDiamondHandsModel(entity)
        local model
        pcall(function()
            model = rawget(entity, "Model") or entity.Model
        end)
        if typeof(model) ~= "Instance" then return end

        local function lockParts()
            if not model.Parent then return false end
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("BasePart") then
                    pcall(function()
                        obj.AssemblyLinearVelocity = Vector3.zero
                        obj.AssemblyAngularVelocity = Vector3.zero
                        obj.Anchored = true
                    end)
                end
            end
            return true
        end

        lockParts()
        task.spawn(function()
            -- The finisher/death controller can touch the rig for a few frames
            -- after _PlayFinisher starts. Re-lock briefly so it cannot ragdoll.
            local started = os.clock()
            while os.clock() - started < 5 do
                if not lockParts() then break end
                task.wait(0.05)
            end
        end)
    end

    cent._PlayFinisher = function(self, fname, isFinal, eliminator, serial, ...)
        if eliminator and eliminator ~= lp then
            local fighter = fctrl and fctrl:GetFighter(eliminator)
            local item = fighter and fighter.EquippedItem
            local weaponName = item and item.Name
            local peerCosmetics = weaponName and cosmeticsForPlayer(eliminator, weaponName)
            local peerFinisher = peerCosmetics and peerCosmetics.Finisher and peerCosmetics.Finisher.Name
            if peerFinisher then
                if customCosmeticsRuntime:PlayFinisher(self, peerFinisher) then return true end
                if tostring(peerFinisher):lower() == "diamond hands" then freezeDiamondHandsModel(self) end
                return ofin(self, peerFinisher, isFinal, eliminator, serial, ...)
            end
        end
        -- The live game sends the player responsible for this elimination.
        if not unlockAllEnabled or eliminator ~= lp then
            return ofin(self, fname, isFinal, eliminator, serial, ...)
        end
        local ewep = getewep() or lwep
        local tfin = ewep and (fcache[ewep] or (equip[ewep] and equip[ewep].Finisher and equip[ewep].Finisher.Name))
        local finisherName = tfin or fname
        if customCosmeticsRuntime:PlayFinisher(self, finisherName) then return true end
        if tostring(finisherName):lower() == "diamond hands" then
            freezeDiamondHandsModel(self)
        end
        return ofin(self, finisherName, isFinal, eliminator, serial, ...)
    end
end


for wname, wdata in equip do
    if wdata.Finisher and wdata.Finisher.Name then
        fcache[wname] = wdata.Finisher.Name
    end
end

;(function()
local cosmeticGuiState = {
    Wanted = false,
    Gui = nil,
    WeaponSearch = "",
    CosmeticSearch = "",
    Mode = "Skin",
    SelectedWeapon = nil,
    SelectedCosmetic = nil,
    Weapons = {},
    Cosmetics = {},
    Columns = 6,
    TileW = 130,
    TileH = 124
}

local function displayName(name, data)
    return tostring((data and (data.DisplayName or data.Name)) or name or "")
end

local function iconFrom(data, fallback, name)
    if not data then return fallback or "" end
    local cosmeticImage = name and consts and consts.COSMETIC_IMAGES and consts.COSMETIC_IMAGES[name]
    local typeInfo = data.Type and clib.Types and clib.Types[data.Type]
    return cosmeticImage
        or data.ImageHighResolution
        or data.Image
        or data.Icon
        or data.Texture
        or fallback
        or (typeInfo and typeInfo.Image)
        or ""
end

local function sortByName(list)
    table.sort(list, function(a, b)
        return tostring(a.Name):lower() < tostring(b.Name):lower()
    end)
    return list
end

local function cosmeticMatchesWeapon(data, weapon)
    if not data then return false end
    local itemName = data.ItemName or data.WeaponName or data.Weapon or data.Item
    if itemName then
        return tostring(itemName):lower() == tostring(weapon or ""):lower()
    end
    return data.Type ~= "Skin"
end

local function rebuildCosmeticLists()
    table.clear(cosmeticGuiState.Weapons)
    table.clear(cosmeticGuiState.Cosmetics)

    for name, data in pairs(coss) do
        if not banned(name) and data.Type == "Weapon" then
            local dispName = displayName(name, data)
            local dispImg = iconFrom(data, ilib.Items and ilib.Items[name] and ilib.Items[name].Image, name)
            if equip[name] and equip[name].Skin then
                local skinData = equip[name].Skin
                dispName = displayName(skinData.Name, skinData)
                dispImg = iconFrom(skinData, nil, skinData.Name)
            end
            table.insert(cosmeticGuiState.Weapons, {
                Name = name,
                Display = dispName,
                Image = dispImg,
                Data = data
            })
        end
    end

    if #cosmeticGuiState.Weapons == 0 and ilib.ItemsAlphabetized then
        for _, name in ipairs(ilib.ItemsAlphabetized) do
            local data = ilib.Items and ilib.Items[name]
            if data and not banned(name) then
                local dispName = displayName(name, data)
                local dispImg = iconFrom(data, nil, name)
                if equip[name] and equip[name].Skin then
                    local skinData = equip[name].Skin
                    dispName = displayName(skinData.Name, skinData)
                    dispImg = iconFrom(skinData, nil, skinData.Name)
                end
                table.insert(cosmeticGuiState.Weapons, {
                    Name = name,
                    Display = dispName,
                    Image = dispImg,
                    Data = data
                })
            end
        end
    end

    sortByName(cosmeticGuiState.Weapons)
    if not cosmeticGuiState.SelectedWeapon and cosmeticGuiState.Weapons[1] then
        cosmeticGuiState.SelectedWeapon = cosmeticGuiState.Weapons[1].Name
    end

    local mode = cosmeticGuiState.Mode
    for name, data in pairs(coss) do
        if not banned(name) and data.Type == mode and cosmeticMatchesWeapon(data, cosmeticGuiState.SelectedWeapon) then
            table.insert(cosmeticGuiState.Cosmetics, {
                Name = name,
                Display = displayName(name, data),
                Image = iconFrom(data, nil, name),
                Data = data
            })
        end
    end

    sortByName(cosmeticGuiState.Cosmetics)
end

forceCosmeticUpdate = function(weapon, ctype)
    task.spawn(function()
        if not customCosmeticsRuntime.Alive then return end
        saferep("CosmeticInventory")
        saferep("WeaponInventory")
        -- Finishers belong to the entity elimination hook, not viewmodel serials.
        -- EnumLibrary has no Finisher field; encoding it aborts every rebuild.
        if ctype == "Finisher" then return end

        -- The unmasked weapon data is the baseline when an override is suspended.
        local cosmetics = table.clone(localWeaponDataRecords.ReadOriginal(dctrl, weapon) or {})
        for category, value in pairs(equip[weapon] or {}) do cosmetics[category] = value end
        local fighter = fctrl and fctrl:GetFighter(lp)
        if not fighter then return end
        local item
        for _, fighterItem in fighter.Items or {} do
            if fighterItem.Name == weapon then
                item = fighterItem
                break
            end
        end
        if not item then return end
        local wasEquipped = fighter.EquippedItem == item or item.IsEquipped == true

        local function refreshHotbar()
            local hotbar = fighter.FighterInterface and fighter.FighterInterface.Hotbar
            for _, hotbarSlot in pairs(hotbar and hotbar._hotbar_slots or {}) do
                if hotbarSlot.ClientItem == item then
                    if hotbarSlot._Setup then
                        pcall(hotbarSlot._Setup, hotbarSlot)
                    end
                    if hotbarSlot.UpdateVisuals then
                        pcall(hotbarSlot.UpdateVisuals, hotbarSlot)
                    end
                    break
                end
            end
        end

        for _, category in ipairs({"Skin", "Wrap", "Charm"}) do
            pcall(function()
                if item.Set then item:Set(category, cosmetics[category]) end
            end)
            pcall(function()
                if item.Data then item.Data[category] = cosmetics[category] end
            end)
        end

        local rebuilt = false
        local oldViewModel = item.ViewModel
        if oldViewModel and oldViewModel._serial and replicatedClass and clientViewModelClass then
            local serial = table.clone(oldViewModel._serial)
            local dataKey = replicatedClass:ToEnum("Data")
            local data = table.clone(serial.Data or serial[dataKey] or {})
            serial[dataKey] = data
            serial.Data = nil

            for _, cosmeticType in ipairs({"Skin", "Wrap", "Charm"}) do
                local cosmetic = cosmetics[cosmeticType]
                data[replicatedClass:ToEnum(cosmeticType)] = cosmetic
                data[cosmeticType] = nil
                if oldViewModel.Data then
                    oldViewModel.Data[cosmeticType] = cosmetic
                end
            end
            local resolvedName = resolveViewModelName(weapon, cosmetics)
            data[replicatedClass:ToEnum("Name")] = resolvedName
            data.Name = nil

            local className = resolveViewModelClassName(weapon, cosmetics, resolvedName)
            local targetClass = resolveViewModelClass(className) or clientViewModelClass
            local identity = getthreadidentity and getthreadidentity() or 8
            constructingVirtualViewModelClass = targetClass ~= clientViewModelClass
            local ok, newViewModel = pcall(function()
                if setthreadidentity then pcall(setthreadidentity, 2) end
                return targetClass.new(serial, item)
            end)
            constructingVirtualViewModelClass = false
            if setthreadidentity then pcall(setthreadidentity, identity) end

            if (not ok or not isValidViewModel(newViewModel)) and resolvedName ~= weapon then
                if newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
                    pcall(newViewModel.Destroy, newViewModel)
                end
                data[replicatedClass:ToEnum("Name")] = weapon
                data.Name = nil
                ok, newViewModel = pcall(function()
                    if setthreadidentity then pcall(setthreadidentity, 2) end
                    return (clientViewModelBaseNew or clientViewModelClass.new)(serial, item)
                end)
                if setthreadidentity then pcall(setthreadidentity, identity) end
            end

            if ok and isValidViewModel(newViewModel) then
                hideCustomSkinRig(newViewModel)
                if wasEquipped and oldViewModel.Unequip then
                    pcall(oldViewModel.Unequip, oldViewModel)
                end
                item.ViewModel = newViewModel
                if wasEquipped and newViewModel.Equip then
                    pcall(newViewModel.Equip, newViewModel, true)
                end
                if oldViewModel ~= newViewModel and oldViewModel.Destroy then
                    pcall(oldViewModel.Destroy, oldViewModel)
                end
                refreshHotbar()
                rebuilt = true
            elseif newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
                pcall(newViewModel.Destroy, newViewModel)
            end
        end

        local vm = item.ViewModel
        for _, obj in ipairs({item, vm}) do
            if obj then
                for _, method in ipairs({
                    "_UpdateWrap",
                    "UpdateWrap",
                    "_UpdateCharm",
                    "UpdateCharm",
                    "_UpdateCosmetics",
                    "UpdateCosmetics",
                    "_RefreshViewModel",
                    "RefreshViewModel",
                    "UpdateViewModel"
                }) do
                    if obj[method] then
                        pcall(obj[method], obj)
                    end
                end
            end
        end

        task.wait(0.1)
        saferep("WeaponInventory")
        refreshHotbar()
    end)
end

applyCosmeticToWeapon = function(weapon, cosmeticName, ctype, skipRebuild)
    if not weapon or weapon == "" then return end
    ctype = ctype or cosmeticGuiState.Mode
    local independentlyOwned = cosmeticName and (customCosmeticsRuntime.Definitions[cosmeticName]
        or customCosmeticsRuntime.Injected[cosmeticName] or customCosmeticsRuntime.Granted[cosmeticName])
    local suspended = customCosmeticsRuntime.EquipSuspended and (skipRebuild or not independentlyOwned)
    local selections = suspended and customCosmeticsRuntime.CachedEquip or equip
    if not suspended and customCosmeticsRuntime.EquipSuspended then
        local cached = customCosmeticsRuntime.CachedEquip[weapon]
        if cached then cached[ctype] = nil end
    end
    selections[weapon] = selections[weapon] or {}

    if not cosmeticName or cosmeticName == "" or cosmeticName == "None" then
        selections[weapon][ctype] = nil
        if ctype == "Finisher" and not suspended then fcache[weapon] = nil end
    else
        if cosmeticName == "__random" then
            local pool = cosmeticGuiState.Cosmetics
            local pick = pool[math.random(1, math.max(1, #pool))]
            cosmeticName = pick and pick.Name or nil
        end
        local cloned = cosmeticName and clonecos(cosmeticName, ctype)
        if cloned then
            selections[weapon][ctype] = cloned
            if ctype == "Finisher" and not suspended then
                fcache[weapon] = cloned.Name
            end
        end
    end

    if selections[weapon] and not next(selections[weapon]) then
        selections[weapon] = nil
    end
    if not skipRebuild and scheduleSkinAutoSave then scheduleSkinAutoSave() end
    if not skipRebuild and not suspended then
        task.defer(function()
            saferep("CosmeticInventory")
            saferep("WeaponInventory")
            forceCosmeticUpdate(weapon, ctype)
        end)
    end
end

local function rebuildPeerViewModels(player, restoring)
    task.spawn(function()
        local fighter = fctrl and fctrl:GetFighter(player)
        if not (fighter and replicatedClass and clientViewModelClass) then return end
        for _, item in pairs(fighter.Items or {}) do
            local oldViewModel = item and item.ViewModel
            if oldViewModel and oldViewModel._serial then
                if not peerViewModelOriginals[item] then
                    local original = table.clone(oldViewModel._serial)
                    local dataKey = replicatedClass:ToEnum("Data")
                    local data = oldViewModel._serial.Data or oldViewModel._serial[dataKey]
                    if type(data) == "table" then
                        local dataCopy = table.clone(data)
                        if original[dataKey] ~= nil or original.Data == nil then
                            original[dataKey], original.Data = dataCopy, nil
                        else
                            original.Data = dataCopy
                        end
                    end
                    peerViewModelOriginals[item] = original
                end

                local serial = table.clone(peerViewModelOriginals[item])
                local dataKey = replicatedClass:ToEnum("Data")
                local data = table.clone(serial.Data or serial[dataKey] or {})
                serial[dataKey], serial.Data = data, nil
                local cosmetics = restoring and nil or cosmeticsForPlayer(player, item.Name)
                local resolvedName = item.Name
                if cosmetics then
                    for _, cosmeticType in ipairs({"Skin", "Wrap", "Charm"}) do
                        data[replicatedClass:ToEnum(cosmeticType)] = cosmetics[cosmeticType]
                        data[cosmeticType] = nil
                    end
                    if oldViewModel.Data then
                        for _, cosmeticType in ipairs({"Skin", "Wrap", "Charm"}) do
                            if cosmetics[cosmeticType] ~= nil then oldViewModel.Data[cosmeticType] = cosmetics[cosmeticType] end
                        end
                    end
                    resolvedName = resolveViewModelName(item.Name, cosmetics)
                    data[replicatedClass:ToEnum("Name")] = resolvedName
                    data.Name = nil
                end

                local className = cosmetics and resolveViewModelClassName(item.Name, cosmetics, resolvedName) or item.Name
                local targetClass = resolveViewModelClass(className) or clientViewModelClass
                local previousIdentity = getthreadidentity and getthreadidentity() or 8
                constructingVirtualViewModelClass = targetClass ~= clientViewModelClass
                local ok, newViewModel = pcall(function()
                    if setthreadidentity then pcall(setthreadidentity, 2) end
                    return targetClass.new(serial, item)
                end)
                constructingVirtualViewModelClass = false
                if setthreadidentity then pcall(setthreadidentity, previousIdentity) end

                if ok and isValidViewModel(newViewModel) then
                    local wasEquipped = fighter.EquippedItem == item or item.IsEquipped == true
                    if wasEquipped and oldViewModel.Unequip then pcall(oldViewModel.Unequip, oldViewModel) end
                    item.ViewModel = newViewModel
                    if wasEquipped and newViewModel.Equip then pcall(newViewModel.Equip, newViewModel, true) end
                    if oldViewModel ~= newViewModel and oldViewModel.Destroy then pcall(oldViewModel.Destroy, oldViewModel) end
                elseif newViewModel and type(newViewModel) == "table" and newViewModel.Destroy then
                    pcall(newViewModel.Destroy, newViewModel)
                end
                if restoring then peerViewModelOriginals[item] = nil end
            end
        end
    end)
end

-- Keep the desired selections separate from the table consumed by live hooks.
-- Rebuild once per affected weapon, not once for each cosmetic category.
function customCosmeticsRuntime:SetEquipSuspended(suspended)
    if self.EquipSuspended == suspended then return end
    self.EquipSuspended = suspended
    local affected = {}
    if suspended then
        for weapon, slots in pairs(equip) do
            self.CachedEquip[weapon] = slots
            affected[weapon] = true
        end
        table.clear(equip)
    else
        for weapon, slots in pairs(self.CachedEquip) do
            local active = equip[weapon] or {}
            for category, value in pairs(slots) do if active[category] == nil then active[category] = value end end
            equip[weapon] = active
            affected[weapon] = true
        end
        table.clear(self.CachedEquip)
    end
    table.clear(fcache)
    for weapon, slots in pairs(equip) do
        if slots.Finisher then fcache[weapon] = slots.Finisher.Name end
    end
    for weapon in pairs(affected) do task.defer(forceCosmeticUpdate, weapon, "Skin") end
    saferep("WeaponInventory")
    rebuildCosmeticLists()
    if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
end

shared.LionCosmeticChanger = {
    SetUnlockAll = function(enabled)
        unlockAllEnabled = enabled == true
        customCosmeticsRuntime:SetEquipSuspended(not unlockAllEnabled)
        if LionLibrary and LionLibrary.NativeUI then
            LionLibrary.NativeUI.cfg.PlexUnlockAll = unlockAllEnabled
            if LionLibrary.NativeMenu then LionLibrary.NativeMenu.refreshToggles() end
        end
        local ok, why = syncUnlockMask()
        if not ok and unlockAllEnabled then
            mainapi:Notify({Text="Unlock All is waiting for player data: "..tostring(why),Duration=2})
        end
        saferep("CosmeticInventory")
        saferep("FavoritedCosmetics")
        saferep("EquippedEmotes")
        if scheduleSkinAutoSave then scheduleSkinAutoSave() end
    end,
    SetVisible = function(visible)
        cosmeticGuiState.Wanted = false
        if visible and LionLibrary and LionLibrary.NativeMenu then
            LionLibrary:SetVisible(true)
            LionLibrary.NativeMenu.showTab("skins")
        end
    end,
    Toggle = function()
        cosmeticGuiState.Wanted = false
        if LionLibrary and LionLibrary.NativeMenu then
            LionLibrary:SetVisible(true)
            LionLibrary.NativeMenu.showTab("skins")
        end
    end,
    Refresh = function()
        rebuildCosmeticLists()
        if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
    end,
    GetEquipData = function()
        local export = {}
        local selections = table.clone(customCosmeticsRuntime.CachedEquip)
        for weapon, slots in pairs(equip) do
            local merged = table.clone(selections[weapon] or {})
            for category, value in pairs(slots) do merged[category] = value end
            selections[weapon] = merged
        end
        for w, cats in pairs(selections) do
            export[w] = {}
            for cat, data in pairs(cats) do
                if data and data.Name then
                    local saved = {Name = data.Name}
                    if cat == "Wrap" then saved.Inverted = data.Inverted == true end
                    if data.OnlyUseFavorites ~= nil then saved.OnlyUseFavorites = data.OnlyUseFavorites == true end
                    export[w][cat] = saved
                end
            end
        end
        return export
    end,
    ExportPeerData = function()
        local export, count = {}, 0
        local currentWeapon = getewep() or lwep
        local function addWeapon(weapon, cats)
            if count >= 32 or type(weapon) ~= "string" or type(cats) ~= "table" then return end
            local compact = {}
            for category, data in pairs(cats) do
                if (category == "Skin" or category == "Wrap" or category == "Charm" or category == "Finisher")
                    and data and type(data.Name) == "string" then
                    compact[category:sub(1, 1):lower()] = data.Name:sub(1, 80)
                end
            end
            if next(compact) then
                export[tostring(weapon):sub(1, 64)] = compact
                count += 1
            end
        end
        if currentWeapon and equip[currentWeapon] then addWeapon(currentWeapon, equip[currentWeapon]) end
        for weapon, cats in pairs(equip) do
            if count >= 32 then break end
            if weapon ~= currentWeapon then addWeapon(weapon, cats) end
        end
        return next(export) and export or nil, currentWeapon
    end,
    ApplyPeerData = function(player, data)
        if not player or player == lp or type(data) ~= "table" then return end
        local restored, count = {}, 0
        local categories = {s="Skin", w="Wrap", c="Charm", f="Finisher"}
        for weapon, compact in pairs(data) do
            if count >= 32 then break end
            if type(weapon) == "string" and type(compact) == "table" then
                local cats = {}
                for short, category in pairs(categories) do
                    local name = compact[short]
                    if type(name) == "string" and #name <= 80 then
                        local cosmetic = clonecos(name, category)
                        if cosmetic then cats[category] = cosmetic end
                    end
                end
                if next(cats) then
                    restored[weapon] = cats
                    count += 1
                end
            end
        end
        peerEquip[player.UserId] = restored
        rebuildPeerViewModels(player, false)
        local fighter = fctrl and fctrl:GetFighter(player)
        for _, item in pairs(fighter and fighter.Items or {}) do
            for _, object in ipairs({item, item.ViewModel}) do
                for _, method in ipairs({"_UpdateWrap", "UpdateWrap", "_UpdateCharm", "UpdateCharm", "_UpdateCosmetics", "UpdateCosmetics"}) do
                    if object and type(object[method]) == "function" then pcall(object[method], object) end
                end
            end
        end
    end,
    RemovePeerData = function(player)
        if player then
            peerEquip[player.UserId] = nil
            rebuildPeerViewModels(player, true)
        end
    end,
    LoadEquipData = function(data)
        if type(data) ~= "table" then return end
        table.clear(customCosmeticsRuntime.CachedEquip)
        table.clear(equip)
        table.clear(fcache)
        for w, cats in pairs(data) do
            if type(cats) == "table" then
                for cat, saved in pairs(cats) do
                    local name = saved
                    local inverted, onlyUseFavorites
                    if type(saved) == "table" then
                        name = saved.Name or saved.CosmeticName
                        inverted = saved.Inverted
                        onlyUseFavorites = saved.OnlyUseFavorites
                    end
                    if type(name) == "string" then
                        applyCosmeticToWeapon(w, name, cat, true)
                        local selections = customCosmeticsRuntime.EquipSuspended and customCosmeticsRuntime.CachedEquip or equip
                        local applied = selections[w] and selections[w][cat]
                        if applied then
                            if inverted ~= nil then applied.Inverted = inverted == true end
                            if onlyUseFavorites ~= nil then applied.OnlyUseFavorites = onlyUseFavorites == true end
                        end
                        task.defer(function()
                            if not customCosmeticsRuntime.EquipSuspended then pcall(forceCosmeticUpdate, w, cat) end
                        end)
                    end
                end
            end
        end
        saferep("CosmeticInventory")
        saferep("WeaponInventory")
        if cosmeticGuiState.SelectedWeapon then
            local currentEquip = equip[cosmeticGuiState.SelectedWeapon]
            if currentEquip and currentEquip[cosmeticGuiState.Mode] then
                cosmeticGuiState.SelectedCosmetic = currentEquip[cosmeticGuiState.Mode].Name
            else
                cosmeticGuiState.SelectedCosmetic = nil
            end
        end
        rebuildCosmeticLists()
        if cosmeticGuiState.Refresh then cosmeticGuiState.Refresh() end
    end,
    Apply = applyCosmeticToWeapon,
    State = cosmeticGuiState
}
shared.LionCosmeticChanger.RegisterCustomCosmetic = function(definition)
    return customCosmeticsRuntime:Register(definition)
end
shared.LionCosmeticChanger.RemoveCustomCosmetic = function(key)
    return customCosmeticsRuntime:Remove(key)
end
shared.LionCosmeticChanger.ListCustomCosmetics = function()
    return customCosmeticsRuntime:Serialize()
end
shared.LionCosmeticChanger.InjectCosmetic = function(name, amount) return customCosmeticsRuntime:Inject(name, amount) end
shared.LionCosmeticChanger.RemoveInjectedCosmetic = function(name) return customCosmeticsRuntime:RemoveInjected(name) end
shared.LionCosmeticChanger.InjectBox = function(name, amount) return customCosmeticsRuntime:InjectBox(name, amount) end
shared.LionCosmeticChanger.RemoveBox = function(name) return customCosmeticsRuntime:RemoveBox(name) end
shared.LionCosmeticChanger.OpenBox = function(name, quantity, weapon) return customCosmeticsRuntime:OpenBox(name, quantity, weapon) end
shared.LionCosmeticChanger.ListBoxes = function() return customCosmeticsRuntime:BoxNames() end
shared.LionCosmeticChanger.SetSpecificOwnership = function(selections, unlocked)
    return customCosmeticsRuntime:SetSpecificOwnership(selections, unlocked)
end
mainapi:Clean(function()
    customCosmeticsRuntime.Alive = false
    if customCosmeticsRuntime.RewardUseClass and customCosmeticsRuntime.RewardUseClass.Use == customCosmeticsRuntime.RewardUseReplacement then
        customCosmeticsRuntime.RewardUseClass.Use = customCosmeticsRuntime.RewardUseOriginal
    end
    customCosmeticsRuntime:Clear()
    if customCosmeticsRuntime.NativeSlotClass and customCosmeticsRuntime.NativeSlotClass.new == customCosmeticsRuntime.NativeSlotReplacement then
        customCosmeticsRuntime.NativeSlotClass.new = customCosmeticsRuntime.NativeSlotOriginal
    end
    for _, cached in pairs(customCosmeticsRuntime.ModelCache or {}) do cached.Asset:Destroy() end
    customCosmeticsRuntime.ModelCache = nil
    table.clear(customCosmeticsRuntime.Injected)
    table.clear(customCosmeticsRuntime.Boxes)
    table.clear(customCosmeticsRuntime.Granted)
    table.clear(customCosmeticsRuntime.Locked)
    table.clear(customCosmeticsRuntime.LockedBoxes)
    if syncUnlockMask then syncUnlockMask() end
end)
mainapi:Clean(plrs.PlayerRemoving:Connect(function(player)
    peerEquip[player.UserId] = nil
end))
mainapi:Clean(function()
    table.clear(peerEquip)
    table.clear(peerViewModelOriginals)
end)

-- Spoofed emotes can appear equipped through the local PlayerData mask, but
-- RIVALS still checks real ownership when UseEmoteByName runs. Keep owned
-- emotes on the normal path and locally instantiate spoofed emotes with the
-- game's own emote modules.
do
    local emoteController
    local originalUseEmoteByName
    local installedEmoteHook = false
    local currentCustomEmote, currentCustomKey

    local function withIdentity2(callback)
        local previous = getthreadidentity and getthreadidentity()
        if setthreadidentity then pcall(setthreadidentity, 2) end
        local ok, result = pcall(callback)
        if previous ~= nil and setthreadidentity then pcall(setthreadidentity, previous) end
        return ok, result
    end

    function customCosmeticsRuntime:CreateEmote(name, humanoid)
        local definition = assert(self.Definitions[name], "Custom emote no longer exists")
        local ok, base = withIdentity2(function() return require(reps.Modules.Emote) end)
        if not ok or type(base) ~= "table" then error("Native emote base unavailable") end
        local object = base.new(nil, name, humanoid)
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. definition.AnimationId
        table.insert(object._destroy_these, animation)
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then object:Destroy() error("Character animator unavailable") end
        local loaded, track = pcall(animator.LoadAnimation, animator, animation)
        if not loaded then object:Destroy() error(tostring(track)) end
        table.insert(object._animation_tracks, track)
        track.Priority, track.Looped = Enum.AnimationPriority.Action4, definition.Loop
        object.PlayClient = function() track:Play(0.1, 1, definition.Speed) end
        table.insert(object._connections, track.Stopped:Connect(function() object:Destroy() end))
        return object
    end

    function customCosmeticsRuntime:StopEmotePreviews(key)
        for preview in pairs(self.EmotePreviews or {}) do
            if not key or (preview._last_emote and preview._last_emote.Name == key) then
                preview._playing_hash += 1
                if preview._last_emote then preview._last_emote:Destroy() preview._last_emote = nil end
                if preview._last_rig then preview._last_rig:Destroy() preview._last_rig = nil end
                self.EmotePreviews[preview] = nil
            end
        end
    end

    function customCosmeticsRuntime:EnsureEmotePreview()
        if self.EmotePreviewClass then return end
        local scene = lps.Modules.UserInterface.Equipment:FindFirstChild("Scene")
        local node = scene and scene:FindFirstChild("EmotePlayer")
        local class = node and safeRequireModule(node)
        if not class or type(class._StartPlaying) ~= "function" then return end
        local original = class._StartPlaying
        self.EmotePreviews = setmetatable({}, {__mode="k"})
        local replacement = function(preview, ...)
            local key = preview.Scene.Equipment:GetSelectedCosmetic()
            local definition = self.Definitions[key]
            if not self.Alive or not definition or definition.Type ~= "Emote" or preview.Scene.Equipment:GetCustomizingType() ~= "Emote" then
                self.EmotePreviews[preview] = nil
                return original(preview, ...)
            end
            self.EmotePreviews[preview] = true
            preview._playing_hash += 1
            if preview._last_emote then preview._last_emote:Destroy() preview._last_emote = nil end
            if preview._last_rig then preview._last_rig:Destroy() preview._last_rig = nil end
            local ok, why = pcall(function()
                local rig = fctrl:GenerateCharacterModel(lp.UserId).Template:Clone()
                preview._last_rig = rig
                rig:PivotTo(preview.Scene:GetHumanoidCFrame())
                rig.HumanoidRootPart.Anchored = true
                rig.Humanoid:SetAttribute("SimulateMoving", true)
                rig.Parent = preview.Scene.Model
                preview._last_emote = self:CreateEmote(key, rig.Humanoid)
                preview._last_emote:PlayClient()
            end)
            if not ok then self:StopEmotePreviews(key) warn("[Plex Emote] Preview: " .. tostring(why)) end
        end
        class._StartPlaying = replacement
        self.EmotePreviewClass = class
        mainapi:Clean(function()
            self:StopEmotePreviews()
            if class._StartPlaying == replacement then class._StartPlaying = original end
        end)
    end


    local function reallyOwnsEmote(name)
        local entry = getRealCosmeticEntry and getRealCosmeticEntry(name)
        if entry == nil or entry == false then return false end
        if type(entry) == "table" and entry.Owned == false then return false end
        return true
    end

    local function localEntity()
        local fighter
        pcall(function()
            fighter = (fctrl and fctrl.LocalFighter) or (fctrl and fctrl:GetFighter(lp))
        end)
        return fighter and fighter.Entity or nil
    end

    local function playSpoofedEmote(name)
        if type(name) ~= "string" or name == "" then return false, "invalid emote" end
        if customCosmeticsRuntime.Locked[name] then return false, "this emote is locally locked" end
        local cosmetic = coss[name]
        if type(cosmetic) ~= "table" or cosmetic.Type ~= "Emote" then
            return false, "unknown emote"
        end

        local entity = localEntity()
        if not entity then return false, "local fighter not ready" end

        local humanoid
        pcall(function() humanoid = entity.Humanoid end)
        if not humanoid and lp.Character then humanoid = lp.Character:FindFirstChildOfClass("Humanoid") end
        if not humanoid or humanoid.Health <= 0 then return false, "you must be alive" end

        local custom = customCosmeticsRuntime.Definitions[name]
        local emoteModule
        if custom and custom.Type == "Emote" then
            emoteModule = {new=function(hum)
                local object = customCosmeticsRuntime:CreateEmote(name, hum)
                object.Destroying:Connect(function()
                    if currentCustomEmote == object then currentCustomEmote, currentCustomKey = nil, nil end
                    if rawget(entity, "_current_emote") == object then
                        rawset(entity, "_current_emote", nil)
                        if entity.EmoteStatusChanged then entity.EmoteStatusChanged:Fire() end
                    end
                end)
                currentCustomEmote, currentCustomKey = object, name
                return object
            end}
        end
        pcall(function()
            if emoteModule then return end
            local modules = reps:FindFirstChild("Modules")
            local folder = modules and modules:FindFirstChild("Emotes")
            local node = folder and folder:FindFirstChild(name)
            if node then withIdentity2(function() emoteModule = require(node) end) end
        end)
        if type(emoteModule) ~= "table" or type(emoteModule.new) ~= "function" then
            return false, "emote module unavailable"
        end

        if currentCustomEmote then currentCustomEmote:Destroy() end
        pcall(function() entity:CancelEmote(nil) end)

        local object
        local objectId = "PLEX_EMOTE_" .. tostring(math.random(100000000, 999999999))
        local started = false
        withIdentity2(function()
            started = pcall(function()
                object = emoteModule.new(humanoid)
                if type(object.SetSerial) == "function" then
                    object:SetSerial({ObjectID=objectId,Name=name,Seed=math.random(1,1000000)})
                end
                rawset(entity, "_current_emote", object)
                pcall(function()
                    if entity.EmoteStatusChanged then entity.EmoteStatusChanged:Fire() end
                end)
                if type(object.PlayServer) == "function" then task.spawn(function() pcall(object.PlayServer, object) end) end
                if type(object.PlayClient) == "function" then task.spawn(function() pcall(object.PlayClient, object) end) end
            end)
        end)
        if not started then return false, "emote failed to start" end

        task.spawn(function()
            local root = humanoid.RootPart
            local origin = root and root.Position
            local t0 = os.clock()
            while rawget(entity, "_current_emote") == object do
                task.wait(0.15)
                root = humanoid.RootPart
                local moved = root and origin and (root.Position-origin).Magnitude >= 4
                local lifetime = tonumber(object.Lifetime)
                if humanoid.Health <= 0 or moved or (lifetime and os.clock()-t0 > lifetime+0.5) then
                    pcall(function() entity:CancelEmote(objectId) end)
                    break
                end
            end
        end)
        return true
    end

    local function resolveEmoteController()
        if emoteController then return emoteController end
        pcall(function()
            local node = ctrls:FindFirstChild("EmoteController")
            if not node then
                for _, child in ipairs(lps:GetDescendants()) do
                    if child:IsA("ModuleScript") and child.Name == "EmoteController" then node=child break end
                end
            end
            if node then emoteController=require(node) end
        end)
        return emoteController
    end

    local function installEmoteHook()
        if installedEmoteHook then return true end
        local controller=resolveEmoteController()
        if type(controller)~="table" or type(controller.UseEmoteByName)~="function" then return false end
        originalUseEmoteByName=controller.UseEmoteByName
        local replacement=function(self,name,...)
            if customCosmeticsRuntime.Locked[name] then return false, "this emote is locally locked" end
            local custom = customCosmeticsRuntime.Definitions[name]
            if custom and custom.Type == "Emote" then return playSpoofedEmote(name) end
            if type(name)=="string" and not reallyOwnsEmote(name) then
                local played=playSpoofedEmote(name)
                if played then return true end
            end
            return originalUseEmoteByName(self,name,...)
        end
        local ok=pcall(function() controller.UseEmoteByName=replacement end)
        installedEmoteHook=ok and controller.UseEmoteByName==replacement
        return installedEmoteHook
    end

    shared.LionCosmeticChanger.PlayEmote=function(name)
        if customCosmeticsRuntime.Locked[name] then return false, "this emote is locally locked" end
        installEmoteHook()
        if reallyOwnsEmote(name) then
            local controller=resolveEmoteController()
            if controller and type(controller.UseEmoteByName)=="function" then
                local ok=pcall(controller.UseEmoteByName,controller,name)
                if ok then return true end
            end
        end
        return playSpoofedEmote(name)
    end
    shared.LionCosmeticChanger.InstallEmoteHook=installEmoteHook
    shared.LionCosmeticChanger.StopCustomEmote=function(key)
        if currentCustomEmote and (not key or currentCustomKey == key) then currentCustomEmote:Destroy() end
    end

    installEmoteHook()

    mainapi:Clean(function()
        shared.LionCosmeticChanger.StopCustomEmote()
        if installedEmoteHook and emoteController and originalUseEmoteByName then
            pcall(function() emoteController.UseEmoteByName=originalUseEmoteByName end)
        end
    end)
end

local skinConfig = {
    Folder = "Plex/CascadeSkinConfigs",
    State = {LastConfig = "default", AutoLoad = false, AutoSave = false},
    Loading = false,
    Ready = false,
    SaveToken = 0,
}
skinConfig.StatePath = skinConfig.Folder .. "/active.json"
local function skinConfigName(value)
    return tostring(value or ""):gsub("[^%w_%-%[%] %.']", "")
end
function skinConfig:EnsureFolder()
    if type(makefolder) ~= "function" or type(isfolder) ~= "function" then return end
    if not isfolder("Plex") then makefolder("Plex") end
    if not isfolder(self.Folder) then makefolder(self.Folder) end
end
function skinConfig:SaveState()
    if type(writefile) ~= "function" then return end
    self:EnsureFolder()
    pcall(writefile, self.StatePath, HttpService:JSONEncode(self.State))
end
do
    if type(readfile) == "function" and type(isfile) == "function" and isfile(skinConfig.StatePath) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(skinConfig.StatePath)) end)
        if ok and type(data) == "table" then
            skinConfig.State.LastConfig = skinConfigName(data.LastConfig)
            skinConfig.State.AutoLoad = data.AutoLoad ~= false
            skinConfig.State.AutoSave = data.AutoSave ~= false
        end
    end
end
function skinConfig:List()
    local names = {}
    if type(listfiles) ~= "function" then return names end
    local ok, files = pcall(listfiles, self.Folder)
    if not ok or type(files) ~= "table" then return names end
    for _, file in ipairs(files) do
        local name = tostring(file):gsub("\\", "/"):match("([^/]+)%.json$")
        if name and name ~= "active" then table.insert(names, name) end
    end
    table.sort(names)
    return names
end
function skinConfig:Save(name, imported)
    name = skinConfigName(name)
    if name == "" or name == "active" then return false, "Enter a skin config name" end
    if type(writefile) ~= "function" then return false, "File writing is unavailable" end
    self:EnsureFolder()
    local savedWheel = {}
    for slot = 1, 8 do
        if emoteWheelSlots[slot] ~= nil then savedWheel[tostring(slot)] = emoteWheelSlots[slot] end
    end
    local data = {Version = 7, Equip = imported or shared.LionCosmeticChanger.GetEquipData(), CustomCosmetics = customCosmeticsRuntime:Serialize(), UnlockAll = unlockAllEnabled, SpoofWeaponOwner = spoofWeaponOwnerEnabled, DisableAnimatedWraps = disableAnimatedWraps, EmoteWheel = savedWheel}
    local ok, err = pcall(writefile, self.Folder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    if not ok then return false, tostring(err) end
    self.State.LastConfig = name
    self:SaveState()
    return true
end
function skinConfig:Load(name)
    name = skinConfigName(name)
    local path = self.Folder .. "/" .. name .. ".json"
    if name == "" or type(isfile) ~= "function" or not isfile(path) then return false, "Skin config not found: " .. name end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" or type(data.Equip) ~= "table" then return false, "Invalid skin config: " .. name end
    self.Loading = true
    customCosmeticsRuntime:BeginBatch()
    local applied, err = pcall(function()
        customCosmeticsRuntime:Clear()
        if type(data.CustomCosmetics) == "table" then
            for _, definition in ipairs(data.CustomCosmetics) do
                local registered, why = customCosmeticsRuntime:Register(definition)
                if not registered then warn("[Plex Skins] Custom cosmetic skipped: " .. tostring(why)) end
            end
        end
        if data.UnlockAll ~= nil then shared.LionCosmeticChanger.SetUnlockAll(data.UnlockAll == true) end
        if data.SpoofWeaponOwner ~= nil then
            spoofWeaponOwnerEnabled = data.SpoofWeaponOwner == true
            syncUnlockMask()
        end
        if data.DisableAnimatedWraps ~= nil then
            disableAnimatedWraps = data.DisableAnimatedWraps == true
            if LionLibrary and LionLibrary.NativeUI then
                LionLibrary.NativeUI.cfg.PlexDisableAnimatedWraps = disableAnimatedWraps
            end
            task.defer(refreshAnimatedWrapState)
        end
        shared.LionCosmeticChanger.LoadEquipData(data.Equip)
        table.clear(emoteWheelSlots)
        if type(data.EmoteWheel) == "table" then
            for slot = 1, 8 do
                local value = data.EmoteWheel[tostring(slot)]
                if value == nil then value = data.EmoteWheel[slot] end
                if value == false or (type(value) == "string" and coss[value] and coss[value].Type == "Emote") then
                    emoteWheelSlots[slot] = value
                end
            end
        end
        emoteWheelCustom = next(emoteWheelSlots) ~= nil
        syncUnlockMask()
    end)
    customCosmeticsRuntime:EndBatch()
    self.Loading = false
    if not applied then return false, tostring(err) end
    self.State.LastConfig = name
    self:SaveState()
    return true
end
function skinConfig:ImportLegacy()
    local path = self.Folder .. "/" .. skinConfigName(self.State.LastConfig) .. ".json"
    if type(isfile) ~= "function" or isfile(path) or type(readfile) ~= "function" then return false end
    local general = "main"
    if isfile("Overlay/autoload.json") then
        local ok, state = pcall(function() return HttpService:JSONDecode(readfile("Overlay/autoload.json")) end)
        if ok and type(state) == "table" then general = skinConfigName(state.LastConfig) end
    end
    local oldPath = "Overlay/settings/" .. general .. ".json"
    if not isfile(oldPath) then return false end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(oldPath)) end)
    if not ok or type(data) ~= "table" or type(data.custom) ~= "table" or next(data.custom) == nil then return false end
    return self:Save(self.State.LastConfig, data.custom)
end
function skinConfig:TryAutoLoad()
    self.Ready = true
    if not self.State.AutoLoad then return false end
    self:ImportLegacy()
    if type(isfile) ~= "function" or not isfile(self.Folder .. "/" .. skinConfigName(self.State.LastConfig) .. ".json") then
        return false
    end
    local ok, err = self:Load(self.State.LastConfig)
    if not ok then warn("[Plex Skins] Auto load: " .. tostring(err)) end
    return ok
end
scheduleSkinAutoSave = function()
    if not skinConfig.Ready or skinConfig.Loading or not skinConfig.State.AutoSave then return end
    skinConfig.SaveToken += 1
    local token = skinConfig.SaveToken
    task.delay(0.6, function()
        if token ~= skinConfig.SaveToken or skinConfig.Loading then return end
        local ok, err = skinConfig:Save(skinConfig.State.LastConfig)
        if not ok then warn("[Plex Skins] Auto save: " .. tostring(err)) end
    end)
end
shared.LionCosmeticChanger.TryAutoLoadConfig = function() return skinConfig:TryAutoLoad() end
shared.LionCosmeticChanger.SaveConfig = function(name) return skinConfig:Save(name) end
shared.LionCosmeticChanger.LoadConfig = function(name) return skinConfig:Load(name) end
shared.LionCosmeticChanger.ListConfigs = function() return skinConfig:List() end



shared.LionCosmeticChanger.SetWeaponOwnership = function(enabled)
    spoofWeaponOwnerEnabled = enabled == true
    local ok, why = syncUnlockMask()
    saferep("WeaponInventory")
    return ok, why
end
shared.LionCosmeticChanger.SetAnimatedWrapsDisabled = function(enabled)
    disableAnimatedWraps = enabled == true
    for weapon in pairs(equip) do task.defer(forceCosmeticUpdate, weapon, "Wrap") end
end
shared.LionCosmeticChanger.CascadeCatalog = function(kind, weapon, query)
    local items = {}
    query = tostring(query or ""):lower()
    for name, data in pairs(coss) do
        if not banned(name) and data.Type == kind and (kind == "Weapon" or cosmeticMatchesWeapon(data, weapon))
            and tostring(displayName(name,data)):lower():find(query,1,true) then
            items[#items+1] = {Name=name,Display=displayName(name,data),Image=iconFrom(data,nil,name)}
        end
    end
    if kind == "Weapon" and #items == 0 then
        for name, data in pairs(ilib.Items or {}) do
            if not banned(name) and name:lower():find(query,1,true) then
                items[#items+1] = {Name=name,Display=displayName(name,data),Image=iconFrom(data,nil,name)}
            end
        end
    end
    return sortByName(items)
end
shared.LionCosmeticChanger.CascadeEquip = function(weapon, name, kind)
    assert(ilib.Items and ilib.Items[weapon], "Choose a valid weapon")
    if name and name ~= "None" then
        local data = assert(coss[name], "Cosmetic no longer exists")
        assert(data.Type == kind and cosmeticMatchesWeapon(data,weapon), "Cosmetic is incompatible with this weapon")
        local ok, why = customCosmeticsRuntime:SetSpecificOwnership({["Cosmetic|"..name]=true},true)
        assert(ok, tostring(why))
    end
    applyCosmeticToWeapon(weapon,name,kind)
end
shared.LionCosmeticChanger.CascadeReset = function()
    local affected={}
    for weapon in pairs(equip)do affected[weapon]=true end
    for weapon in pairs(customCosmeticsRuntime.CachedEquip)do affected[weapon]=true end
    table.clear(equip); table.clear(customCosmeticsRuntime.CachedEquip); table.clear(fcache)
    for weapon in pairs(affected)do task.defer(forceCosmeticUpdate,weapon,"Skin")end
    saferep("WeaponInventory")
end
skinConfig.Ready = true
exportedApi = shared.LionCosmeticChanger
end)()
end)

;(function()
 local LocalPlayer=game:GetService("Players").LocalPlayer
 local ReplicatedStorage=game:GetService("ReplicatedStorage")
 local Config={}
    local seasonCfg={}
    local seasonNames={[0]="Zero",[1]="Warp",[2]="Polar",[3]="Fame"}
    local seasonByName={Zero=0,Warp=1,Polar=2,Fame=3}
    local seasonLib
    local seasonOriginal
    local seasonReplacement
    local fighterController
    local seasonRecords=setmetatable({}, {__mode="k"})

    local function seasonNumber(value)
        if type(value)=="number" then return value end
        if type(value)~="string" then return nil end
        return seasonByName[value] or tonumber(value:match("^Season (%d+)$")) or tonumber(value)
    end

    local function resolveSeasonLibrary()
        if seasonLib then return seasonLib end
        pcall(function()
            local modules=ReplicatedStorage:FindFirstChild("Modules")
            local module=modules and modules:FindFirstChild("SeasonLibrary")
            if module then seasonLib=require(module) end
        end)
        return seasonLib
    end

    local function seasonRankProfile(index)
        local lib=resolveSeasonLibrary()
        local season=lib and lib.Seasons[seasonNames[index]]
        return season and season.RankProfile
    end

    local function seasonRankChoices(index)
        local profile=seasonRankProfile(index)
        return profile and table.clone(profile.RanksOrder) or {}
    end

    local function seasonMetadata(value)
        local index=seasonNumber(value)
        local cfg=index~=nil and seasonCfg[index] or nil
        if not Config.__SeasonSpoof or not cfg or not cfg.enabled then return nil end
        local profile=seasonRankProfile(index)
        local rank=profile and profile.Ranks[cfg.rankName]
        if not rank then return nil end
        return {SeasonELO=rank.RequiredELO,
            SeasonLeaderboardRank=rank.RequiredELOLeaderboardRanking and math.clamp(math.floor(tonumber(cfg.rank) or 1),1,200) or nil}
    end

    local function recordSeasonCharm(model,season,elo,arch,hasNativeData)
        local saved=seasonRecords[model]
        if saved then return saved end
        saved={season=season,elo=elo,arch=arch,native=hasNativeData,labels={}}
        local extra=model:FindFirstChild("Extra")
        saved.extra=extra and extra:Clone()
        for _,object in ipairs(model:GetDescendants()) do
            if object:HasTag("CharmLeaderboardRank") then saved.labels[object]=object.Text end
        end
        seasonRecords[model]=saved
        return saved
    end

    local function restoreCharmRankGeometry(model,season,md)
        local rank=seasonLib:GetRank(md.SeasonELO,nil,md.SeasonLeaderboardRank or math.huge,seasonLib.Seasons[season].RankProfile.Name)
        local extra=model:FindFirstChild("Extra")
        if not extra or extra:FindFirstChild(rank) then return end
        local assets=LocalPlayer.PlayerScripts.Assets.Charms
        local template=assets:FindFirstChild(model.Name)
        local source=template and template:FindFirstChild("Extra")
        local shape=source and source:FindFirstChild(rank)
        if shape then shape:Clone().Parent=extra end
    end

    local function resolveFighterController()
        if fighterController then return fighterController end
        pcall(function()
            local scripts=LocalPlayer:FindFirstChild("PlayerScripts")
            local controllers=scripts and scripts:FindFirstChild("Controllers")
            local module=controllers and controllers:FindFirstChild("FighterController")
            if module then fighterController=require(module) end
        end)
        return fighterController
    end

    local function equippedViewmodelRoot()
        local controller=resolveFighterController()
        if not controller then return nil end
        local fighter=controller.LocalFighter
        if not fighter and type(controller.GetFighter)=="function" then
            pcall(function() fighter=controller:GetFighter(LocalPlayer) end)
        end
        local item=fighter and fighter.EquippedItem
        local vm=item and item.ViewModel
        return vm and (vm.Model or vm._model) or nil
    end

    local function installSeasonHook()
        local lib=resolveSeasonLibrary()
        if not lib or seasonOriginal or type(lib.FormatSeasonRankCharm)~="function" then return end
        local original=lib.FormatSeasonRankCharm
        local replacement=function(self,model,season,elo,arch,...)
            local md=seasonMetadata(season)
            if md then
                if typeof(model)=="Instance" and seasonRecords[model]==nil then
                    recordSeasonCharm(model,season,elo,arch,true)
                end
                restoreCharmRankGeometry(model,season,md)
                elo,arch=md.SeasonELO,md.SeasonLeaderboardRank
            end
            return original(self,model,season,elo,arch,...)
        end
        local ok=pcall(function() lib.FormatSeasonRankCharm=replacement end)
        if ok and lib.FormatSeasonRankCharm==replacement then
            seasonOriginal=original
            seasonReplacement=replacement
        end
    end

    local function restoreSeasonCharm(model,saved)
        if typeof(model)=="Instance" and model.Parent then
            if saved.extra then
                local extra=model:FindFirstChild("Extra")
                if extra then extra:Destroy() end
                saved.extra.Parent=model
                saved.extra=nil
            end
            for label,text in pairs(saved.labels or {}) do if label.Parent then label.Text=text end end
            if saved.native then pcall(seasonOriginal,seasonLib,model,saved.season,saved.elo,saved.arch) end
        end
        if saved.extra then saved.extra:Destroy() end
    end

    local function restoreSeasonCharms()
        if not seasonLib or not seasonOriginal then return end
        for model,saved in pairs(seasonRecords) do restoreSeasonCharm(model,saved) end
        table.clear(seasonRecords)
    end

    local function refreshSeasonCharms()
        if not Config.__SeasonSpoof then restoreSeasonCharms() return end
        installSeasonHook()
        if not seasonLib or not seasonOriginal then return end

        for model,saved in pairs(seasonRecords) do
            if typeof(model)=="Instance" and model.Parent then
                local md=seasonMetadata(saved.season)
                if md then
                    restoreCharmRankGeometry(model,saved.season,md)
                    pcall(seasonOriginal,seasonLib,model,saved.season,md.SeasonELO,md.SeasonLeaderboardRank)
                else
                    restoreSeasonCharm(model,saved)
                    seasonRecords[model]=nil
                end
            else
                restoreSeasonCharm(model,saved)
                seasonRecords[model]=nil
            end
        end

        local roots={equippedViewmodelRoot(),workspace.CurrentCamera,LocalPlayer.Character}
        local seen=setmetatable({}, {__mode="k"})
        local function restyle(model)
            if typeof(model)~="Instance" or not model:IsA("Model") or seen[model] then return end
            seen[model]=true
            local index=seasonNumber(model.Name)
            if index==nil then return end
            local md=seasonMetadata(index)
            if not md then return end
            local saved=seasonRecords[model]
            local season=saved and saved.season or seasonNames[index] or model.Name
            if not saved then
                recordSeasonCharm(model,season,nil,nil,false)
            end
            pcall(seasonLib.FormatSeasonRankCharm,seasonLib,model,season,md.SeasonELO,md.SeasonLeaderboardRank)
        end
        for _,root in ipairs(roots) do
            if typeof(root)=="Instance" then
                restyle(root)
                for _,model in ipairs(root:GetDescendants()) do restyle(model) end
            end
        end
    end

    for i=0,3 do seasonCfg[i]={enabled=false,rankName="Archnemesis",rank=1} end
    function exportedApi.RankedCharmChoices(index)return seasonRankChoices(index)end
    function exportedApi.SetRankedCharm(index, rank, placement, enabled)
        assert(seasonCfg[index], "Unknown season")
        assert(table.find(seasonRankChoices(index),rank), "Unknown rank for season")
        seasonCfg[index]={enabled=enabled==true,rankName=rank,rank=math.clamp(math.floor(tonumber(placement)or 1),1,200)}
        Config.__SeasonSpoof=false
        for _,cfg in pairs(seasonCfg)do if cfg.enabled then Config.__SeasonSpoof=true;break end end
        refreshSeasonCharms()
    end
    mainapi:Clean(function()
        Config.__SeasonSpoof=false
        restoreSeasonCharms()
        if seasonLib and seasonLib.FormatSeasonRankCharm==seasonReplacement then seasonLib.FormatSeasonRankCharm=seasonOriginal end
    end)
end)()

local LocalPlayer=game:GetService("Players").LocalPlayer
run(function()
    local RankSpoofer, Rank, RankPlacement
    local originals=setmetatable({}, {__mode="k"})
    local rankConnections={}
    local function backup(object,property)if not originals[object]then originals[object]={property,object[property]}end end
    local icons = {
        Bronze = "rbxassetid://111599878354131",
        Silver = "rbxassetid://82834564754747",
        Gold = "rbxassetid://80716950169934",
        Diamond = "rbxassetid://131795064007344",
        Onyx = "rbxassetid://114166096331502",
        Nemesis = "rbxassetid://133903971285645",
        ["Arch Nemesis"] = "rbxassetid://134520747948636",
    }

    local rankedPreview = {}
    local function setRankedPreviewEnabled(enabled)
        if enabled and not rankedPreview.Controller then
            local controllerScript = LocalPlayer.PlayerScripts.Controllers:FindFirstChild("SeasonController")
            local ok, controller = pcall(function() return controllerScript and require(controllerScript) end)
            if ok and controller and type(controller.IsRankedUnlocked) == "function" then
                rankedPreview.Controller = controller
                rankedPreview.RawOriginal = rawget(controller, "IsRankedUnlocked")
                rankedPreview.Original = controller.IsRankedUnlocked
                rankedPreview.Replacement = function(self, ...)
                    if RankSpoofer and RankSpoofer.Enabled then return true end
                    return rankedPreview.Original(self, ...)
                end
                controller.IsRankedUnlocked = rankedPreview.Replacement
            end
        elseif not enabled and rankedPreview.Controller then
            if rankedPreview.Controller.IsRankedUnlocked == rankedPreview.Replacement then
                rankedPreview.Controller.IsRankedUnlocked = rankedPreview.RawOriginal
            end
            rankedPreview.Controller = nil
        end
        -- Refresh the existing page once; its native open path handles later visits.
        pcall(function()
            local pageScript = LocalPlayer.PlayerScripts.Modules.Pages:FindFirstChild("Ranked")
            local page = pageScript and require(pageScript)
            if page and page.Locked then page.Locked:_Update() end
        end)
    end
    mainapi:Clean(function() setRankedPreviewEnabled(false) end)

    local function isMyRow(slot)
        local playerFrame = slot:FindFirstChild("Player")
        if not playerFrame then return false end
        for _, node in ipairs(playerFrame:GetDescendants()) do
            if node:IsA("TextLabel") and (node.Text == LocalPlayer.Name or node.Text == LocalPlayer.DisplayName or node.Text == "@" .. LocalPlayer.Name) then
                return true
            end
        end
        return false
    end

    local function apply()
        if not RankSpoofer.Enabled then return end
        local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not playerGui then return end
        local rank = Rank.Value
        local placement = rank == "Arch Nemesis" and math.clamp(math.floor(tonumber(RankPlacement and RankPlacement.Value) or 1), 1, 200) or nil
        local rankText = placement and (rank .. " #" .. placement) or rank
        local icon = icons[rank]
        for _, obj in ipairs(playerGui:GetDescendants()) do
            if obj:IsA("TextLabel") and (obj.Name == "LeftRank" or obj.Name == "RightRank") and obj:FindFirstAncestor("ELOBar") then
                backup(obj,"Text")
                obj.Text = rankText
            end
        end
        local list = playerGui:FindFirstChild("PlayerList", true)
        if list and icon then
            for _, slot in ipairs(list:GetDescendants()) do
                if slot.Name == "PlayerListSlot" and isMyRow(slot) then
                    local stat = slot:FindFirstChild("Leaderstat")
                    local container = stat and stat:FindFirstChild("RankContainer")
                    if container then
                        for _, image in ipairs(container:GetDescendants()) do
                            if image.Name == "Icon" and (image:IsA("ImageLabel") or image:IsA("ImageButton")) then
                                backup(image,"Image")
                                image.Image = icon
                            end
                        end
                    end
                end
            end
        end
    end

    RankSpoofer,Rank,RankPlacement={Enabled=false},{Value="Arch Nemesis"},{Value=1}
    local function restore()
        for object,saved in pairs(originals)do if object.Parent then object[saved[1]]=saved[2]end end
        table.clear(originals)
    end
    local queued=false
    local function requestRefresh()
        if queued or not RankSpoofer.Enabled then return end
        queued=true
        task.defer(function()queued=false;if RankSpoofer.Enabled then apply()end end)
    end
    function exportedApi.SetRankSpoof(enabled,rank,placement)
        for _,connection in ipairs(rankConnections)do connection:Disconnect()end
        table.clear(rankConnections)
        restore()
        Rank.Value,RankPlacement.Value=rank or "Arch Nemesis",math.clamp(math.floor(tonumber(placement)or 1),1,200)
        RankSpoofer.Enabled=enabled==true
        setRankedPreviewEnabled(RankSpoofer.Enabled)
        if RankSpoofer.Enabled then
            local gui=LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if gui then rankConnections[#rankConnections+1]=gui.DescendantAdded:Connect(function(object)
                if object.Name=="LeftRank"or object.Name=="RightRank"or object.Name=="Icon"or object.Name=="PlayerListSlot"then requestRefresh()end
            end)end
            apply()
        end
    end
    mainapi:Clean(function()
        RankSpoofer.Enabled=false
        for _,connection in ipairs(rankConnections)do connection:Disconnect()end
        restore()
    end)
end)

local identityReady=false
local function ensureIdentity()
 if identityReady then return end
 identityReady=true
run(function()
    local service = game:GetService("Players")
    local ownPlayer = service.LocalPlayer
    local alive, refreshing = true, false
    local originals, records, playerConnections = {}, {}, {}
    local objectCache = setmetatable({}, {__mode = "k"})
    local objectConnections = setmetatable({}, {__mode = "k"})
    local humanoidCache = setmetatable({}, {__mode = "k"})
    local customPictureFrames = setmetatable({}, {__mode = "k"})
    local appearance = {}
    local rootConnections, tokens = {}, {}
    local presentationSurfaces = setmetatable({}, {__mode = "k"})
    local ownName, ownAvatar, enemy, advancedAvatar
    local peerConfigs = setmetatable({}, {__mode = "k"})
    local function allSpoofConfigs()
        local configs = {}
        for _, config in ipairs({ownName, ownAvatar, enemy, advancedAvatar}) do
            if config then table.insert(configs, config) end
        end
        for _, config in pairs(peerConfigs) do
            table.insert(configs, config)
        end
        return configs
    end
    local updateCustomPicture
    local spoofFolder = workspace:FindFirstChild("__PlexAvatarSpoofs")
    if spoofFolder and not spoofFolder:IsA("Folder") then
        pcall(function() spoofFolder:Destroy() end)
        spoofFolder = nil
    end
    if not spoofFolder then
        spoofFolder = Instance.new("Folder")
        spoofFolder.Name = "__PlexAvatarSpoofs"
        spoofFolder.Archivable = false
        spoofFolder.Parent = workspace
    end

    -- Hooks persist across reloads, but their active records are replaced.
    local hookState = getgenv().__LionIdentitySpoofState
    if not hookState then
        hookState = {}
        getgenv().__LionIdentitySpoofState = hookState
    end

    hookState.Records = hookState.Records or {}
    hookState.AvatarCharacters = hookState.AvatarCharacters or setmetatable({}, {__mode = "k"})
    hookState.AvatarObjects = hookState.AvatarObjects or setmetatable({}, {__mode = "k"})
    hookState.AvatarDescriptionsByUserId = hookState.AvatarDescriptionsByUserId or {}
    hookState.AvatarDescriptionsByCharacter = hookState.AvatarDescriptionsByCharacter or setmetatable({}, {__mode = "k"})

    if hookState.Version ~= 2 and hookmetamethod and getnamecallmethod then
        hookState.Version = 2

        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(object, key)
            local record = hookState.Records[object]
            if record and (not checkcaller or not checkcaller()) then
                if key == "Name" and record.Username ~= "" then return record.Username end
                if key == "DisplayName" and record.DisplayName ~= "" then return record.DisplayName end
                if key == "CharacterAppearanceId" and record.AvatarSourceUserId then
                    return record.AvatarSourceUserId
                end
            end
            return oldIndex(object, key)
        end))
        hookState.ReadOriginal = function(object, key) return oldIndex(object, key) end

        local function cloneDescription(description)
            if typeof(description) ~= "Instance" then return nil end
            local okClass, className = pcall(oldIndex, description, "ClassName")
            if not okClass or className ~= "HumanoidDescription" then return nil end
            local okClone, cloneMethod = pcall(oldIndex, description, "Clone")
            if not okClone or type(cloneMethod) ~= "function" then return nil end
            local clonedOK, cloned = pcall(cloneMethod, description)
            return clonedOK and cloned or nil
        end

        local function destroyDirect(instance)
            if typeof(instance) ~= "Instance" then return end
            local okDestroy, destroyMethod = pcall(oldIndex, instance, "Destroy")
            if okDestroy and type(destroyMethod) == "function" then
                pcall(destroyMethod, instance)
            end
        end

        local spoofed_methods = {
            GetAppliedDescription = true, ApplyDescription = true, ApplyDescriptionReset = true,
            ApplyDescriptionClientServer = true, RemoveAccessories = true, Destroy = true, Remove = true,
            GetHumanoidDescriptionFromUserIdAsync = true, GetHumanoidDescriptionFromUserId = true,
            GetUserThumbnailAsync = true,
        }
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(object, ...)
            local method = getnamecallmethod()
            if not spoofed_methods[method] then return oldNamecall(object, ...) end
            local external = not checkcaller or not checkcaller()

            if external and typeof(object) == "Instance" then
                local className
                local okClass, resolvedClass = pcall(oldIndex, object, "ClassName")
                if okClass then className = resolvedClass end

                if className == "Humanoid" then
                    local character
                    local okParent, resolvedParent = pcall(oldIndex, object, "Parent")
                    if okParent then character = resolvedParent end
                    local spoofDescription = hookState.AvatarDescriptionsByCharacter[character]

                    if spoofDescription then
                        if method == "GetAppliedDescription" then
                            local cloned = cloneDescription(spoofDescription)
                            if cloned then return cloned end
                        elseif method == "ApplyDescription"
                            or method == "ApplyDescriptionReset"
                            or method == "ApplyDescriptionClientServer" then
                            local args = table.pack(...)
                            local cloned = cloneDescription(spoofDescription)
                            if cloned then
                                args[1] = cloned
                                local okMethod, applyMethod = pcall(oldIndex, object, method)
                                if okMethod and type(applyMethod) == "function" then
                                    local results = table.pack(pcall(applyMethod, object, table.unpack(args, 1, args.n)))
                                    destroyDirect(cloned)
                                    if results[1] then
                                        return table.unpack(results, 2, results.n)
                                    end
                                else
                                    destroyDirect(cloned)
                                end
                            end
                        elseif method == "RemoveAccessories" then
                            local repairDescription = spoofDescription
                            task.delay(0.15, function()
                                if not repairDescription
                                    or hookState.AvatarDescriptionsByCharacter[character] ~= repairDescription then
                                    return
                                end
                                local currentHumanoid = character and character:FindFirstChildOfClass("Humanoid")
                                if not currentHumanoid then return end
                                local cloned = repairDescription:Clone()
                                pcall(function()
                                    currentHumanoid:ApplyDescriptionReset(cloned)
                                end)
                                cloned:Destroy()
                            end)
                        end
                    end
                elseif hookState.AvatarObjects[object]
                    and (method == "Destroy" or method == "Remove") then
                    return nil
                end
            end

            if object == service and external then
                local args = table.pack(...)
                local requestedUserId = tonumber(args[1])
                local spoofDescription = requestedUserId
                    and hookState.AvatarDescriptionsByUserId[requestedUserId]

                if spoofDescription
                    and (method == "GetHumanoidDescriptionFromUserIdAsync"
                        or method == "GetHumanoidDescriptionFromUserId") then
                    local cloned = cloneDescription(spoofDescription)
                    if cloned then return cloned end
                end

                if method == "GetUserThumbnailAsync" then
                    for player, record in pairs(hookState.Records) do
                        if player.UserId == args[1] and record.Picture and record.SourceUserId then
                            args[1] = record.SourceUserId
                            return oldNamecall(object, table.unpack(args, 1, args.n))
                        end
                    end
                end
            end

            return oldNamecall(object, ...)
        end))
    end

    hookState.Records = records
    if getgenv().__LionNameSpoofState then getgenv().__LionNameSpoofState.Enabled = false end

    local function readOriginal(player, key)
        if hookState.ReadOriginal then return hookState.ReadOriginal(player, key) end
        return player[key]
    end

    local function remember(player)
        if not originals[player] then
            originals[player] = {
                Username = tostring(readOriginal(player, "Name") or player.Name or ""),
                DisplayName = tostring(readOriginal(player, "DisplayName") or player.DisplayName or player.Name or ""),
                Thumbnails = {},
            }
        end
        return originals[player]
    end

    local function isEnemy(player)
        return player ~= ownPlayer and (ownPlayer.Neutral or player.Neutral or player.Team ~= ownPlayer.Team)
    end

    local function targets(config)
        if not config.Enemies then return {ownPlayer} end
        local result = {}
        for _, player in ipairs(service:GetPlayers()) do
            if player ~= ownPlayer and (config.Target == "All enemies" and isEnemy(player)
                or config.Target == remember(player).Username .. " (" .. player.UserId .. ")") then
                table.insert(result, player)
            end
        end
        return result
    end

    local function configTargetsPlayer(config, player)
        if not config or not player then return false end
        if not config.Enemies then return player == ownPlayer end
        if player == ownPlayer then return false end
        if config.Target == "All enemies" then return isEnemy(player) end
        return config.Target == remember(player).Username .. " (" .. player.UserId .. ")"
    end

    local function replaceNames(text)
        local result, cursor = {}, 1
        while cursor <= #text do
            local matched = false
            for _, token in ipairs(tokens) do
                local last = cursor + #token[1] - 1
                if text:sub(cursor, last) == token[1]
                    and not text:sub(cursor - 1, cursor - 1):match("[%w_]")
                    and not text:sub(last + 1, last + 1):match("[%w_]") then
                    table.insert(result, token[2])
                    cursor, matched = last + 1, true
                    break
                end
            end
            if not matched then
                table.insert(result, text:sub(cursor, cursor))
                cursor += 1
            end
        end
        return table.concat(result)
    end

    local function pictureFor(image)
        local id = tonumber(image:match("[Uu]ser[Ii]d=(%d+)"))
        for player, record in pairs(records) do
            if record.Picture and record.SourceUserId then
                if id == player.UserId then
                    return image:gsub("([Uu]ser[Ii]d=)%d+", "%1" .. record.SourceUserId)
                end
                if originals[player].Thumbnails[image] then
                    return "rbxthumb://type=AvatarHeadShot&id=" .. record.SourceUserId .. "&w=420&h=420"
                end
                if image:find("rbxthumb://", 1, true) and tonumber(image:match("[&?]id=(%d+)")) == player.UserId
                    and image:find("type=Avatar", 1, true) then
                    return image:gsub("([&?]id=)%d+", "%1" .. record.SourceUserId)
                end
            end
        end
        return image
    end

    local function applyObject(object)
        if not alive or refreshing then return end
        local property = (object:IsA("TextLabel") or object:IsA("TextButton")) and "Text"
            or (object:IsA("ImageLabel") or object:IsA("ImageButton")) and "Image"
        if not property then return end
        pcall(function()
            local current = object[property]
            local entry = objectCache[object]
            if not entry then
                entry = { Property = property, Original = current }
                objectCache[object] = entry
            elseif entry.Writing then return
            elseif current ~= entry.Applied then entry.Original = current end
            local updated = property == "Text" and replaceNames(entry.Original) or pictureFor(entry.Original)
            entry.Applied = updated
            if updated ~= current then
                entry.Writing = true
                object[property] = updated
                entry.Writing = false
            end
            if property == "Image" and updateCustomPicture then
                updateCustomPicture(object, entry.Original)
            end
            if not objectConnections[object] then
                objectConnections[object] = object:GetPropertyChangedSignal(property):Connect(function()
                    if next(records) then applyObject(object) end
                end)
            end
        end)
    end

    local presentationSurfaceNames = {
        EliminatedEffect=true, EliminatedCard=true, ViewProfile=true,
        Profile=true, Leaderboard=true, PlayerList=true, FinalResults=true,
        Winners=true, DuelerProfile=true,
    }
    local function rememberPresentationSurface(object)
        if presentationSurfaceNames[object.Name] then presentationSurfaces[object] = true end
    end

    local function scan()
        -- UI identity spoofing only needs UI trees. Scanning all of Workspace here
        -- caused large, unpredictable frame spikes on maps with many descendants.
        local roots = {game:GetService("CoreGui")}
        local playerGui = ownPlayer:FindFirstChildOfClass("PlayerGui")
        if playerGui then table.insert(roots, playerGui) end

        for _, root in ipairs(roots) do
            if root then
                if not rootConnections[root] then
                    rootConnections[root] = root.DescendantAdded:Connect(function(object)
                        rememberPresentationSurface(object)
                        if next(records) then task.defer(applyObject, object) end
                    end)
                end
                for _, object in ipairs(root:GetDescendants()) do
                    rememberPresentationSurface(object)
                    applyObject(object)
                end
            end
        end

        -- Still catch newly-created world-space nameplates without doing a full
        -- Workspace:GetDescendants() pass.
        if not rootConnections[workspace] then
            rootConnections[workspace] = workspace.DescendantAdded:Connect(function(object)
                if not next(records) then return end
                if object:IsA("TextLabel") or object:IsA("TextButton")
                    or object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    task.defer(applyObject, object)
                end
            end)
        end
    end

    -- Rivals detaches and later repopulates these small presentation trees.
    -- A bounded refresh catches reused cards without returning to expensive
    -- full-PlayerGui scans on every frame.
    local function refreshPresentationSurfaces()
        if not next(records) then return end
        for object in pairs(presentationSurfaces) do
            if not object.Parent then
                presentationSurfaces[object] = nil
            else
                local visible = true
                if object:IsA("GuiObject") then visible = object.Visible end
                if object:IsA("LayerCollector") then visible = object.Enabled end
                if visible then
                    applyObject(object)
                    for _, descendant in ipairs(object:GetDescendants()) do applyObject(descendant) end
                end
            end
        end
    end

    local function restoreUI()
        refreshing = true
        for object, entry in pairs(objectCache) do
            pcall(function()
                if object[entry.Property] == entry.Applied then object[entry.Property] = entry.Original end
            end)
        end
        table.clear(objectCache)
        for imageObject, state in pairs(customPictureFrames) do
            pcall(function()
                if state.TransparencyConnection then state.TransparencyConnection:Disconnect() end
                if state.Viewport then state.Viewport:Destroy() end
                if imageObject and imageObject.Parent then
                    imageObject.ImageTransparency = state.OriginalTransparency
                end
            end)
        end
        table.clear(customPictureFrames)
        for humanoid, original in pairs(humanoidCache) do
            pcall(function() humanoid.DisplayName = original end)
        end
        table.clear(humanoidCache)
        refreshing = false
    end

    local syncViewModelArms

    local function restoreAvatar(player)
        local saved = appearance[player]
        if not saved then return end
        appearance[player] = nil
        if saved.Character then
            hookState.AvatarCharacters[saved.Character] = nil
            hookState.AvatarDescriptionsByCharacter[saved.Character] = nil
        end

        if saved.NativeDescription and saved.OriginalDescription and saved.Character and saved.Character.Parent then
            local humanoid = saved.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local description = saved.OriginalDescription
                pcall(function() humanoid:ApplyDescriptionReset(description) end)
            end
            pcall(function() saved.OriginalDescription:Destroy() end)
            saved.OriginalDescription = nil
        end

        if saved.Connection then pcall(function() saved.Connection:Disconnect() end) end
        if saved.Connections then
            for _, connection in ipairs(saved.Connections) do
                pcall(function() connection:Disconnect() end)
            end
        end

        if saved.HiddenHeads then
            for head, original in pairs(saved.HiddenHeads) do
                if head and head.Parent then
                    pcall(function()
                        head.Transparency = original.Transparency
                        head.LocalTransparencyModifier = original.LocalTransparencyModifier
                    end)
                end
            end
        elseif saved.HeadHidden and saved.Head and saved.Head.Parent then
            pcall(function()
                saved.Head.Transparency = saved.HeadTransparency
                saved.Head.LocalTransparencyModifier = saved.HeadLocalTransparency
            end)
        end

        for _, object in ipairs(saved.Added or {}) do
            pcall(function()
                if object then
                    hookState.AvatarObjects[object] = nil
                    for _, descendant in ipairs(object:GetDescendants()) do
                        hookState.AvatarObjects[descendant] = nil
                    end
                    if object.Parent then object:Destroy() end
                end
            end)
        end

        for _, entry in ipairs(saved.Removed or {}) do
            pcall(function()
                if entry.Object and entry.Parent and entry.Parent.Parent then
                    entry.Object.Parent = entry.Parent
                end
            end)
        end

        if player == ownPlayer then task.defer(syncViewModelArms) end
    end

    -- The local first-person viewmodel (arms/hands/fingers) is spawned from
    -- the real account appearance, so the avatar spoof must mirror the
    -- spoofed shirt/skin onto it. Without this the spoof only shows on the
    -- full character rig, lobby preview, and ESP snapshot.
    local viewmodelArmCache = setmetatable({}, {__mode = "k"}) -- part -> {Color, Decals}
    local viewmodelSyncNext = 0

    local function viewmodelArmParts()
        local folder = workspace:FindFirstChild("ViewModels")
        if not folder then return {} end
        local parts = {}
        for _, descendant in ipairs(folder:GetDescendants()) do
            if descendant:IsA("BasePart") and (descendant.Name == "LeftArm" or descendant.Name == "RightArm") then
                parts[#parts + 1] = descendant
            end
        end
        return parts
    end

    local function toAssetId(value)
        if type(value) == "number" and value > 0 then return value end
        if type(value) == "string" then
            local id = tonumber(value:match("(%d+)"))
            if id and id > 0 then return id end
        end
        return nil
    end

    local function firstPartColor(character, names)
        for _, name in ipairs(names) do
            local part = character:FindFirstChild(name)
            if part and part:IsA("BasePart") then return part.Color end
        end
        return nil
    end

    syncViewModelArms = function()
        if not alive then return end
        local saved = appearance[ownPlayer]
        if not saved then
            if next(viewmodelArmCache) then
                for part, original in pairs(viewmodelArmCache) do
                    pcall(function()
                        if part and part.Parent then part.Color = original.Color end
                        for decal, texture in pairs(original.Decals) do
                            if decal and decal.Parent then decal.Texture = texture end
                        end
                    end)
                end
                table.clear(viewmodelArmCache)
            end
            return
        end

        local config = saved.Config
        local description = config and config.Description
        local character = ownPlayer.Character

        local shirtTemplate
        local characterShirt = character and character:FindFirstChildOfClass("Shirt")
        if characterShirt and characterShirt.ShirtTemplate and characterShirt.ShirtTemplate ~= "" then
            shirtTemplate = characterShirt.ShirtTemplate
        else
            local id = description and toAssetId(description.Shirt)
            if id then shirtTemplate = "rbxassetid://" .. tostring(id) end
        end

        local leftColor, rightColor
        if description then
            pcall(function()
                leftColor = typeof(description.LeftArmColor) == "Color3" and description.LeftArmColor or leftColor
                rightColor = typeof(description.RightArmColor) == "Color3" and description.RightArmColor or rightColor
            end)
        end
        if character then
            leftColor = leftColor or firstPartColor(character, {"LeftUpperArm", "LeftLowerArm", "LeftArm", "LeftHand"})
            rightColor = rightColor or firstPartColor(character, {"RightUpperArm", "RightLowerArm", "RightArm", "RightHand"})
        end

        for _, part in ipairs(viewmodelArmParts()) do
            pcall(function()
                local original = viewmodelArmCache[part]
                if not original then
                    original = {Color = part.Color, Decals = {}}
                    viewmodelArmCache[part] = original
                    for _, decal in ipairs(part:GetDescendants()) do
                        if decal:IsA("Decal") then original.Decals[decal] = decal.Texture end
                    end
                end
                local color = part.Name == "RightArm" and rightColor or leftColor
                if color then part.Color = color end
                if shirtTemplate then
                    for _, decal in ipairs(part:GetDescendants()) do
                        if decal:IsA("Decal") and decal.Texture ~= shirtTemplate then
                            decal.Texture = shirtTemplate
                        end
                    end
                end
            end)
        end
    end

    do
        local RunService = game:GetService("RunService")
        local connection = RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now < viewmodelSyncNext then return end
            viewmodelSyncNext = now + 0.5
            syncViewModelArms()
        end)
        table.insert(rootConnections, connection)
    end

    local function warnFailure(config, message)
        warn("[Spoofer] " .. config.Label .. ": " .. tostring(message))
    end

    local function clearAvatarTemplates(config)
        for _, model in pairs(config.Templates or {}) do
            pcall(function() model:Destroy() end)
        end
        config.Templates = {}
        config.TemplatePending = {}
    end

    local function getAvatarTemplate(config, rigType, generation, cutscene)
        if not config.Description then return nil end
        config.Templates = config.Templates or {}
        config.TemplatePending = config.TemplatePending or {}
        local key = cutscene and "Cutscene" or tostring(rigType)
        if config.Templates[key] then return config.Templates[key] end
        if config.TemplatePending[key] then
            local deadline = os.clock() + 12
            while config.TemplatePending[key] and os.clock() < deadline do task.wait(0.1) end
            return config.Templates[key]
        end
        local pending = {}
        config.TemplatePending[key] = pending
        local description = config.Description
        if cutscene then
            description = description:Clone()
            description.Torso = 15365012259
            description.LeftArm = 15365010034
            description.RightArm = 15365012263
            description.LeftLeg = 15365010038
            description.RightLeg = 15365010030
        end
        local ok, model = pcall(function()
            return service:CreateHumanoidModelFromDescriptionAsync(description, rigType)
        end)
        if cutscene then description:Destroy() end
        if config.TemplatePending[key] == pending then config.TemplatePending[key] = nil end
        if not ok then
            if alive and config.Enabled and config.Generation == generation then warnFailure(config, model) end
            return nil
        end
        if not alive or not config.Enabled or config.Generation ~= generation then
            model:Destroy()
            return nil
        end
        model.Archivable = true
        config.Templates[key] = model
        return model
    end

    local function customPictureRecord(image)
        local lower = tostring(image or ""):lower()
        for player, record in pairs(records) do
            if record.CustomPicture and record.AvatarDescription and record.AvatarConfig then
                local directId = tonumber(lower:match("userid=(%d+)")) or tonumber(lower:match("[&?]id=(%d+)"))
                local original = originals[player]
                if (directId == player.UserId and (lower:find("avatar", 1, true) or lower:find("headshot", 1, true)))
                    or (original and original.Thumbnails[image]) then
                    return player, record
                end
            end
        end
    end

    updateCustomPicture = function(imageObject, image)
        if not imageObject or not imageObject.Parent
            or not (imageObject:IsA("ImageLabel") or imageObject:IsA("ImageButton")) then
            return
        end

        local player, record = customPictureRecord(image)
        local existing = customPictureFrames[imageObject]
        local current, visible = imageObject, true
        while current do
            if current:IsA("GuiObject") and not current.Visible then visible = false break end
            if current:IsA("LayerCollector") and not current.Enabled then visible = false break end
            current = current.Parent
        end
        if not visible then
            if existing then
                pcall(function()
                    if existing.TransparencyConnection then existing.TransparencyConnection:Disconnect() end
                    if existing.Viewport then existing.Viewport:Destroy() end
                    imageObject.ImageTransparency = existing.OriginalTransparency
                end)
                customPictureFrames[imageObject] = nil
            end
            return
        end
        if not player or not record then
            if existing then
                pcall(function()
                    if existing.TransparencyConnection then existing.TransparencyConnection:Disconnect() end
                    if existing.Viewport then existing.Viewport:Destroy() end
                    imageObject.ImageTransparency = existing.OriginalTransparency
                end)
                customPictureFrames[imageObject] = nil
            end
            return
        end

        local config = record.AvatarConfig
        local revision = record.AvatarRevision or 0
        if existing and existing.Config == config and existing.Revision == revision
            and existing.Viewport and existing.Viewport.Parent == imageObject then
            return
        end

        local originalTransparency = existing and existing.OriginalTransparency or imageObject.ImageTransparency
        if existing then
            pcall(function()
                if existing.TransparencyConnection then existing.TransparencyConnection:Disconnect() end
                if existing.Viewport then existing.Viewport:Destroy() end
            end)
        end

        local viewport = Instance.new("ViewportFrame")
        viewport.Name = "__PlexAvatarPicture"
        viewport.BackgroundTransparency = 1
        viewport.BorderSizePixel = 0
        viewport.Size = UDim2.fromScale(1, 1)
        viewport.Position = UDim2.fromScale(0, 0)
        viewport.ZIndex = imageObject.ZIndex + 1
        viewport.ClipsDescendants = true
        viewport.Ambient = Color3.fromRGB(200, 200, 200)
        viewport.LightColor = Color3.fromRGB(255, 255, 255)
        viewport.Parent = imageObject

        local camera = Instance.new("Camera")
        camera.FieldOfView = math.clamp(tonumber(config.PfpFov) or 28, 10, 90)
        camera.Parent = viewport
        viewport.CurrentCamera = camera

        local world = Instance.new("WorldModel")
        world.Name = "AvatarPictureWorld"
        world.Parent = viewport

        local state = {
            Viewport = viewport,
            OriginalTransparency = originalTransparency,
            Config = config,
            Revision = revision,
        }
        customPictureFrames[imageObject] = state
        local writingTransparency = false
        local function hideOriginalPicture()
            if writingTransparency or customPictureFrames[imageObject] ~= state or not imageObject.Parent then return end
            if imageObject.ImageTransparency ~= 1 then
                writingTransparency = true
                imageObject.ImageTransparency = 1
                writingTransparency = false
            end
        end
        hideOriginalPicture()
        state.TransparencyConnection = imageObject:GetPropertyChangedSignal("ImageTransparency"):Connect(hideOriginalPicture)

        task.spawn(function()
            local template = getAvatarTemplate(config, Enum.HumanoidRigType.R15, config.Generation, false)
            if not template or not alive or not config.Enabled
                or (config.AvatarRevision or 0) ~= revision
                or customPictureFrames[imageObject] ~= state
                or not viewport.Parent then
                return
            end

            local model = template:Clone()
            model.Name = "AvatarPictureModel"
            model.Parent = world
            if config.Headless then
                local head = model:FindFirstChild("Head", true)
                if head and head:IsA("BasePart") then
                    head.Transparency, head.LocalTransparencyModifier = 1, 1
                    for _, object in ipairs(head:GetDescendants()) do
                        if object:IsA("Decal") or object:IsA("Texture") then object.Transparency = 1 end
                    end
                end
            end

            for _, object in ipairs(model:GetDescendants()) do
                if object:IsA("BasePart") then
                    object.Anchored = true
                    object.CanCollide = false
                    object.CanTouch = false
                    object.CanQuery = false
                end
            end

            local yaw = math.rad(tonumber(config.PfpYaw) or 0)
            pcall(function() model:PivotTo(CFrame.Angles(0, yaw, 0)) end)

            local function framePortrait()
                if not viewport.Parent or customPictureFrames[imageObject] ~= state then return end
                local head = model:FindFirstChild("Head", true)
                local torso = model:FindFirstChild("UpperTorso", true) or model:FindFirstChild("Torso", true)
                local focusPart = head or torso or model:FindFirstChild("HumanoidRootPart", true)
                    or model:FindFirstChildWhichIsA("BasePart", true)
                local focus = focusPart and focusPart.Position or model:GetPivot().Position
                if head or torso then focus += Vector3.new(0, -0.35, 0) end
                local frame = Vector3.new(
                    (tonumber(config.PfpOffsetX) or 0) / 50,
                    (tonumber(config.PfpOffsetY) or 0) / 50,
                    0
                )
                local target = focus + frame
                local zoom = math.clamp(tonumber(config.PfpZoom) or 100, 25, 300) / 100
                -- Use a fixed portrait distance even while an emote moves limbs.
                -- Bounding-box fitting makes wide emotes shrink into a tiny PFP.
                local distance = 3.15 / zoom
                local pitch = math.rad(math.clamp(tonumber(config.PfpPitch) or 0, -60, 60))
                local cameraOffset = Vector3.new(0, math.sin(pitch) * distance, -math.cos(pitch) * distance)
                camera.CFrame = CFrame.lookAt(target + cameraOffset, target)
            end

            -- Show the correctly-sized portrait while the animation asset loads.
            framePortrait()

            local animationId = tostring(config.PfpAnimationId or ""):match("%d+")
            if animationId then
                pcall(function()
                    local humanoid = model:FindFirstChildOfClass("Humanoid")
                    if not humanoid then return end
                    local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator")
                    animator.Parent = humanoid
                    local animation = Instance.new("Animation")
                    animation.Name = "PlexPicturePose"
                    animation.AnimationId = "rbxassetid://" .. animationId
                    animation.Parent = model
                    local track = animator:LoadAnimation(animation)
                    track:Play(0, 1, 1)
                    local deadline = os.clock() + 3
                    while track.Length <= 0 and os.clock() < deadline and viewport.Parent do
                        task.wait()
                    end
                    if track.Length > 0 then
                        local pose = math.clamp(tonumber(config.PfpPosePosition) or 50, 0, 100) / 100
                        track.TimePosition = math.min(track.Length * pose, math.max(track.Length - 0.001, 0))
                    end
                    track:AdjustSpeed(0)
                    local runService = game:GetService("RunService")
                    runService.Heartbeat:Wait()
                    runService.Heartbeat:Wait()
                end)
            end
            -- Reframe after Motor6D transforms from the frozen pose have settled.
            framePortrait()
        end)
    end

    -- Render a local avatar on the existing rig, preserving its game controllers.
     -- Apply the spoofed outfit to the existing character rig.
    -- This follows the supplied source: replace clothing/accessories/face locally
    -- instead of welding a second full avatar body on top of the live character.
    local function applyAvatar(player, config, generation, forceAppearance)
        if not alive or not config.Enabled or config.Generation ~= generation then return end
        local character = player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 10)
        if not humanoid or not humanoid:IsA("Humanoid") then return end
        if player == ownPlayer then
            local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 10)
            if not root or humanoid.Health <= 0 then return end
        end
        if not alive or not config.Enabled or config.Generation ~= generation or player.Character ~= character then return end

        local existing = appearance[player]
        if not forceAppearance and existing and existing.Config == config and existing.Character == character
            and existing.SourceUserId == config.SourceUserId
            and existing.AvatarRevision == (config.AvatarRevision or 0) then
            if not config.NativeApplyUnavailable then
                hookState.AvatarDescriptionsByCharacter[character] = config.Description
            end
            return
        end

        if config.Description and not config.NativeApplyUnavailable then
            restoreAvatar(player)

            local originalDescription
            pcall(function()
                originalDescription = humanoid:GetAppliedDescription()
            end)

            hookState.AvatarCharacters[character] = true
            hookState.AvatarDescriptionsByCharacter[character] = config.Description

            local spoofDescription = config.Description:Clone()
            local applied, applyError = pcall(function()
                humanoid:ApplyDescriptionReset(spoofDescription)
            end)
            spoofDescription:Destroy()

            if applied then
                appearance[player] = {
                    Added = {},
                    Removed = {},
                    Connections = {},
                    Config = config,
                    Character = character,
                    SourceUserId = config.SourceUserId,
                    AvatarRevision = config.AvatarRevision or 0,
                    NativeDescription = true,
                    OriginalDescription = originalDescription,
                }
                if player == ownPlayer then task.defer(syncViewModelArms) end
                return
            end

            hookState.AvatarCharacters[character] = nil
            hookState.AvatarDescriptionsByCharacter[character] = nil
            if originalDescription then pcall(function() originalDescription:Destroy() end) end
            local errorText = tostring(applyError)
            if errorText:lower():find("backend server", 1, true) then
                config.NativeApplyUnavailable = true
                if not config.NativeFallbackWarned then
                    config.NativeFallbackWarned = true
                    warnFailure(config, "The game blocks client avatar data; using the R6 appearance fallback")
                end
            elseif not config.NativeFallbackWarned then
                config.NativeFallbackWarned = true
                warnFailure(config, "Native avatar apply failed, using R6 fallback: " .. errorText)
            end
        end

        local template = getAvatarTemplate(config, humanoid.RigType, generation, false)
        if not template then return end
        local donor = template:Clone()

        if not alive or not config.Enabled or config.Generation ~= generation or player.Character ~= character then
            donor:Destroy()
            return
        end

        restoreAvatar(player)

        local saved = {
            Added = {},
            Removed = {},
            Connections = {},
            Config = config,
            Character = character,
            SourceUserId = config.SourceUserId,
            AvatarRevision = config.AvatarRevision or 0,
        }
        appearance[player] = saved
        hookState.AvatarCharacters[character] = true
        if player == ownPlayer then task.defer(syncViewModelArms) end

        local function isAppearanceObject(object)
            return object:IsA("Accessory")
                or object:IsA("Shirt")
                or object:IsA("Pants")
                or object:IsA("ShirtGraphic")
                or (object:IsA("CharacterMesh") and object.BodyPart == Enum.BodyPart.Head)
        end

        local function isOurObject(object)
            return object:GetAttribute("__PlexAvatarSpoof") == true
        end

        local function isHairAccessory(object)
            if not object:IsA("Accessory") then return false end
            local okType, accessoryType = pcall(function() return object.AccessoryType end)
            if okType and accessoryType == Enum.AccessoryType.Hair then return true end

            local handle = object:FindFirstChild("Handle")
            if handle and handle:FindFirstChild("HairAttachment") then return true end

            -- Older R6 hair can report AccessoryType.Unknown. Names are the final
            -- fallback after the type and attachment checks.
            return object.Name:lower():find("hair", 1, true) ~= nil
        end

        local function rememberRemoved(object, parent)
            for _, entry in ipairs(saved.Removed) do
                if entry.Object == object then return end
            end
            saved.Removed[#saved.Removed + 1] = {Object = object, Parent = parent}
        end

        local function removeOriginal(object)
            if not object or isOurObject(object) then return end
            if isAppearanceObject(object) and object.Parent == character then
                rememberRemoved(object, character)
                object.Parent = nil
                return
            end

            local head = character:FindFirstChild("Head")
            if head and (object:IsA("Decal") or object:IsA("SpecialMesh")) and object.Parent == head then
                rememberRemoved(object, head)
                object.Parent = nil
            end
        end

        local function addSpoofObject(object, parent)
            local copy = object:Clone()
            copy:SetAttribute("__PlexAvatarSpoof", true)
            hookState.AvatarObjects[copy] = true

            for _, descendant in ipairs(copy:GetDescendants()) do
                hookState.AvatarObjects[descendant] = true
                if descendant:IsA("BasePart") then
                    descendant.Anchored = false
                    descendant.CanCollide = false
                    descendant.CanTouch = false
                    descendant.CanQuery = false
                    descendant.Massless = true
                end
            end

            copy.Parent = parent
            saved.Added[#saved.Added + 1] = copy
            return copy
        end

        local function attachAccessory(copy)
            if not copy:IsA("Accessory") then return end
            local handle = copy:FindFirstChild("Handle")
            if not handle then return end

            local old = handle:FindFirstChild("AccessoryWeld")
            if old then old:Destroy() end

            local attachment = handle:FindFirstChildOfClass("Attachment")
            local target = attachment and character:FindFirstChild(attachment.Name, true)

            if target and target:IsDescendantOf(copy) then target = nil end
            if not target and attachment then
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        target = part:FindFirstChild(attachment.Name)
                        if target then break end
                    end
                end
            end
            if target and not target:IsA("Attachment") then target = nil end

            local head = character:FindFirstChild("Head")
            if target or head then
                local bodyPart = target and target.Parent or head
                local bodyOffset = target and target.CFrame or CFrame.new(0, 0.5, 0)
                local handleOffset = attachment and attachment.CFrame or copy.AttachmentPoint
                -- Align the loose handle before welding it. Otherwise the physics
                -- solver can pull the live character toward the donor rig's origin.
                handle.CFrame = bodyPart.CFrame * bodyOffset * handleOffset:Inverse()
                handle.AssemblyLinearVelocity = Vector3.zero
                handle.AssemblyAngularVelocity = Vector3.zero
                local weld = Instance.new("Weld")
                weld.Name = "PlexAvatarAccessoryWeld"
                weld.Part0 = bodyPart
                weld.Part1 = handle
                weld.C0 = bodyOffset
                weld.C1 = handleOffset
                weld.Parent = handle
            end
        end

        local function hideR6Head(head)
            if not config.Headless or appearance[player] ~= saved
                or not head or not head:IsA("BasePart") or head.Name ~= "Head" then
                return
            end

            saved.HiddenHeads = saved.HiddenHeads or setmetatable({}, {__mode = "k"})
            if saved.HiddenHeads[head] then return end

            local original = {
                Transparency = head.Transparency,
                LocalTransparencyModifier = head.LocalTransparencyModifier,
            }
            saved.HiddenHeads[head] = original

            local correctingHead = false
            local function keepHeadHidden()
                if correctingHead or appearance[player] ~= saved or not head.Parent then return end
                correctingHead = true
                head.Transparency = 1
                head.LocalTransparencyModifier = 1
                correctingHead = false
            end
            keepHeadHidden()
            saved.Connections[#saved.Connections + 1] = head:GetPropertyChangedSignal("Transparency"):Connect(keepHeadHidden)
            saved.Connections[#saved.Connections + 1] = head:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(keepHeadHidden)
        end

        local function buildOutfit()
            if appearance[player] ~= saved or player.Character ~= character then return false end

            for _, object in ipairs(character:GetChildren()) do
                removeOriginal(object)
            end

            local head = character:FindFirstChild("Head")
            if head then
                for _, object in ipairs(head:GetChildren()) do
                    removeOriginal(object)
                end

                if config.Headless then
                    hideR6Head(head)
                end
            end

            for _, object in ipairs(donor:GetChildren()) do
                if isAppearanceObject(object) and not (config.NoHair and isHairAccessory(object)) then
                    local copy = addSpoofObject(object, character)
                    if copy:IsA("Accessory") then attachAccessory(copy) end
                end
            end

            local sourceHead = donor:FindFirstChild("Head")
            if head and sourceHead and not config.Headless then
                for _, object in ipairs(sourceHead:GetChildren()) do
                    if object:IsA("Decal") or object:IsA("SpecialMesh") then
                        addSpoofObject(object, head)
                    end
                end
            end

            return true
        end

        local built, failure = pcall(buildOutfit)
        donor:Destroy()

        if not built or failure == false then
            restoreAvatar(player)
            warnFailure(config, built and "Could not apply spoofed outfit" or failure)
            return
        end

        -- Keep the spoof itself untouched after this initial build. If RIVALS
        -- tries to insert its real appearance again, discard only those new
        -- originals; the spoofed objects are never rebuilt or periodically reapplied.
        saved.Connection = character.DescendantAdded:Connect(function(object)
            if appearance[player] ~= saved or isOurObject(object) then return end
            if config.Headless and object:IsA("BasePart") and object.Name == "Head" then
                task.defer(hideR6Head, object)
                return
            end
            local head = character:FindFirstChild("Head")
            if not isAppearanceObject(object)
                and not ((object:IsA("Decal") or object:IsA("SpecialMesh")) and object.Parent == head) then
                return
            end
            task.defer(function()
                if appearance[player] == saved then pcall(removeOriginal, object) end
            end)
        end)
    end

    local function rebuildRecords()
        restoreUI()
        table.clear(records)
        table.clear(tokens)
        table.clear(hookState.AvatarDescriptionsByUserId)
        table.clear(hookState.AvatarDescriptionsByCharacter)
        for _, config in ipairs(allSpoofConfigs()) do
            if config.Enabled then
                for _, player in ipairs(targets(config)) do
                    local original = remember(player)
                    local shownUsername = config.Anonymous and "Anonymous" or tostring(config.Username or "")
                    local shownDisplayName = config.Anonymous and "Anonymous" or tostring(config.DisplayName or "")
                    local record = records[player] or {Username = "", DisplayName = "", Picture = false}
                    records[player] = record
                    if shownUsername ~= "" then record.Username = shownUsername end
                    if shownDisplayName ~= "" then record.DisplayName = shownDisplayName end
                    if config.Picture and (config.Anonymous or config.SourceUserId) then
                        record.SourceUserId = config.Anonymous and 1 or config.SourceUserId
                        record.Picture = true
                    end
                    if config.Avatar and config.Description then
                        if config.SourceUserId then record.AvatarSourceUserId = config.SourceUserId end
                        record.AvatarDescription = config.Description
                        record.AvatarConfig = config
                        record.AvatarRevision = config.AvatarRevision or 0
                        record.CustomPicture = config.CustomPicture == true
                        hookState.AvatarDescriptionsByUserId[player.UserId] = config.Description
                        if player.Character and not config.NativeApplyUnavailable then
                            hookState.AvatarDescriptionsByCharacter[player.Character] = config.Description
                        end
                    end
                    if shownUsername ~= "" then
                        table.insert(tokens, {"@" .. original.Username, "@" .. shownUsername})
                        table.insert(tokens, {original.Username, shownUsername})
                    end
                    if shownDisplayName ~= "" and (original.DisplayName ~= original.Username or shownUsername == "") then
                        table.insert(tokens, {original.DisplayName, shownDisplayName})
                    end
                    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid and shownDisplayName ~= "" then
                        humanoidCache[humanoid] = humanoid.DisplayName
                        humanoid.DisplayName = shownDisplayName
                    end
                end
            end
        end
        table.sort(tokens, function(a, b) return #a[1] > #b[1] end)
        if next(records) then scan() end
    end

    local function applyPeerDescriptionOverrides(description, values, headless, noHair)
        if not description then return end
        values = type(values) == "table" and values or {}
        local single = {sh="Shirt", pa="Pants", ts="GraphicTShirt", fa="Face", he="Head"}
        local lists = {ha="HatAccessory", hr="HairAccessory", fc="FaceAccessory", ne="NeckAccessory",
            so="ShoulderAccessory", fr="FrontAccessory", ba="BackAccessory", wa="WaistAccessory"}
        for key, property in pairs(single) do
            local value = values[key]
            if value ~= nil and tostring(value) ~= "" then
                local number = tonumber(tostring(value):match("%d+")) or 0
                pcall(function() description[property] = math.floor(number) end)
            end
        end
        for key, property in pairs(lists) do
            local value = values[key]
            if value ~= nil then
                local ids = {}
                for id in tostring(value):gmatch("%d+") do ids[#ids + 1] = id end
                pcall(function() description[property] = table.concat(ids, ",") end)
            end
        end
        if headless then
            pcall(function() description.Head = 134082579 end)
            pcall(function() description.Face = 0 end)
        end
        if noHair then pcall(function() description.HairAccessory = "" end) end
    end

    local function refresh(config, forceAvatar)
        if not alive then return end
        config.Generation += 1
        local generation = config.Generation
        local source = config.Anonymous and "1" or tostring(config.Source or ""):match("^%s*(.-)%s*$")
        if source == "" and config.Headless then source = tostring(ownPlayer.UserId) end
        local sourceChanged = config.ResolvedSource ~= source
        config.ResolvedSource = source

        if not config.Enabled or source == "" then
            for player, saved in pairs(appearance) do
                if saved.Config == config then restoreAvatar(player) end
            end
            if config.Description then config.Description:Destroy() end
            clearAvatarTemplates(config)
            config.SourceUserId, config.Description = nil, nil
            rebuildRecords()
            return
        end

        if sourceChanged or forceAvatar == true then
            config.AvatarRevision = (config.AvatarRevision or 0) + 1
            if config.Description then config.Description:Destroy() end
            clearAvatarTemplates(config)
            config.SourceUserId, config.Description = nil, nil
        end

        if not config.Avatar then
            for player, saved in pairs(appearance) do
                if saved.Config == config then restoreAvatar(player) end
            end
        end

        rebuildRecords()
        task.spawn(function()
            local id = config.SourceUserId
            if not id then
                local ok, result = pcall(function()
                    local numeric = tonumber(source)
                    if numeric and numeric > 0 and numeric % 1 == 0 then return numeric end
                    return service:GetUserIdFromNameAsync(source:gsub("^@", ""))
                end)
                if not alive or config.Generation ~= generation or not config.Enabled then return end
                if not ok then
                    for player, saved in pairs(appearance) do
                        if saved.Config == config then restoreAvatar(player) end
                    end
                    warnFailure(config, "Could not find avatar account: " .. tostring(result))
                    return
                end
                id = result
                config.SourceUserId = id
            end

            if config.Avatar and not config.Description then
                local descOK, description = pcall(function()
                    return service:GetHumanoidDescriptionFromUserIdAsync(id)
                end)
                if not alive or config.Generation ~= generation or not config.Enabled then
                    if descOK then description:Destroy() end
                    return
                end
                if descOK then
                    if config.PeerValues or config.Headless or config.NoHair then
                        applyPeerDescriptionOverrides(description, config.PeerValues, config.Headless, config.NoHair)
                    end
                    config.Description = description
                else
                    for player, saved in pairs(appearance) do
                        if saved.Config == config then restoreAvatar(player) end
                    end
                    warnFailure(config, description)
                end
            end

            if config.Avatar and config.Description then
                task.spawn(getAvatarTemplate, config, Enum.HumanoidRigType.R15, generation, true)
            end

            rebuildRecords()
            local wanted = {}
            for _, player in ipairs(targets(config)) do
                wanted[player] = true
                if config.Picture then
                    task.spawn(function()
                        local original = remember(player)
                        for _, size in ipairs({Enum.ThumbnailSize.Size100x100, Enum.ThumbnailSize.Size150x150, Enum.ThumbnailSize.Size420x420}) do
                            local thumbOK, url = pcall(function()
                                return service:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, size)
                            end)
                            if thumbOK then original.Thumbnails[url] = true end
                        end
                        if alive and config.Enabled and config.Generation == generation then scan() end
                    end)
                end
                if config.Avatar and config.Description then
                    task.spawn(function()
                        applyAvatar(player, config, generation)
                    end)
                end
            end

            for player, saved in pairs(appearance) do
                if saved.Config == config and not wanted[player] then restoreAvatar(player) end
            end
        end)
    end

    local function playerList()
        local names = {"All enemies"}
        for _, player in ipairs(service:GetPlayers()) do
            if player ~= ownPlayer then table.insert(names, remember(player).Username .. " (" .. player.UserId .. ")") end
        end
        table.sort(names, function(a, b) if a == "All enemies" then return true elseif b == "All enemies" then return false end return a < b end)
        return names
    end


    local function bareConfig(label,kind)
        return {Label=label,Enabled=false,Username="",DisplayName="",Source="",Picture=kind~="name",Avatar=kind~="name",Anonymous=false,Enemies=false,Generation=0,Target="All enemies",Selector={}}
    end
    ownName=bareConfig("Username Spoofer","name")
    ownAvatar=bareConfig("Avatar Spoofer","avatar")
    enemy=bareConfig("Enemy Spoofer","both")
    advancedAvatar=bareConfig("Advanced Avatar Spoofer","avatar")
    -- EliminatedEffect fills the cloned card synchronously and then yields for
    -- its five-second lifetime. Apply identity/profile state at that first
    -- yield so the card never keeps the account thumbnail or stale stats.
    local okEliminatedEffect, eliminatedEffect = pcall(function()
        return require(ownPlayer.PlayerScripts.Modules.UserInterface.EliminatedEffect)
    end)
    if okEliminatedEffect and type(eliminatedEffect) == "table"
        and type(eliminatedEffect.Play) == "function" then
        local originalEliminatedPlay = eliminatedEffect.Play
        local wrappedEliminatedPlay
        local function applyEliminatedCard(player)
            if not alive or typeof(player) ~= "Instance" or not player:IsA("Player") then return end
            local card = rawget(eliminatedEffect, "_last_eliminated_card")
            if not card or not card.Parent then return end

            local record = records[player]
            local frame = card:FindFirstChild("Frame")
            local outerContainer = frame and frame:FindFirstChild("Container")
            local clip = outerContainer and outerContainer:FindFirstChild("Clip")
            local container = clip and clip:FindFirstChild("Container")
            -- Apply images and generic replacements first. The explicit labels
            -- below must be last because a spoofed username can equal the
            -- player's original display name and otherwise get replaced twice.
            for _, object in ipairs(card:GetDescendants()) do applyObject(object) end
            if container and record then
                local playerLabel = container:FindFirstChild("Player")
                local usernameLabel = container:FindFirstChild("Username")
                local shownName = record.DisplayName ~= "" and record.DisplayName
                    or (record.Username ~= "" and record.Username or nil)
                if playerLabel and playerLabel:IsA("TextLabel") and shownName then
                    playerLabel.Text = shownName
                end
                if usernameLabel and usernameLabel:IsA("TextLabel") and record.Username ~= "" then
                    usernameLabel.Text = "@" .. record.Username
                end
            end

            local slot = card:FindFirstChild("TeammateSlot", true)
            local level = slot and slot:FindFirstChild("Level")
            local levelTitle = level and level:FindFirstChild("Title")
            local streak = slot and slot:FindFirstChild("Streak")
            local streakValue = streak and streak:FindFirstChild("Value")
            local spoofedLevel = player:GetAttribute("Level")
            local spoofedStreak = player:GetAttribute("StatisticDuelsWinStreak")
                or player:GetAttribute("WinStreak") or player:GetAttribute("CurrentWinStreak")
            if levelTitle and levelTitle:IsA("TextLabel") and spoofedLevel ~= nil then
                levelTitle.Text = tostring(math.floor(tonumber(spoofedLevel) or 0))
            end
            if streakValue and streakValue:IsA("TextLabel") and spoofedStreak ~= nil then
                streakValue.Text = tostring(math.floor(tonumber(spoofedStreak) or 0))
            end
        end
        wrappedEliminatedPlay = function(self, player, ...)
            task.defer(function()
                task.wait()
                applyEliminatedCard(player or ownPlayer)
            end)
            return originalEliminatedPlay(self, player, ...)
        end
        eliminatedEffect.Play = wrappedEliminatedPlay
        mainapi:Clean(function()
            if eliminatedEffect.Play == wrappedEliminatedPlay then
                eliminatedEffect.Play = originalEliminatedPlay
            end
        end)
    end

    -- FinalResults.Winners asks ClientDueler for a separate cutscene model.
    -- Its preloaded model is based on the account's real user ID, so use our
    -- cached local avatar template for the selected player instead.
    local okDueler, duelClass = pcall(function()
        return require(ownPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientDueler)
    end)
    if okDueler and type(duelClass) == "table" and type(duelClass.GetCharacterModelForCutscene) == "function" then
        local originalCutsceneModel = duelClass.GetCharacterModelForCutscene
        local wrappedCutsceneModel
        wrappedCutsceneModel = function(self, ...)
            local player = self.Player
            local config
            local selected = false
            if player == ownPlayer then
                config = (advancedAvatar and advancedAvatar.Enabled) and advancedAvatar or ownAvatar
                selected = true
            elseif peerConfigs[player] and peerConfigs[player].Enabled then
                config = peerConfigs[player]
                selected = true
            else
                config = enemy
            end
            if not selected and config and config.Enabled then
                for _, target in ipairs(targets(enemy)) do
                    if target == player then selected = true break end
                end
            end
            local template = selected and config.Enabled and config.Avatar
                and config.Templates and config.Templates.Cutscene
            if not template and selected and config.Enabled and config.Avatar and config.Description then
                template = getAvatarTemplate(config, Enum.HumanoidRigType.R15, config.Generation, true)
            end
            if not template then return originalCutsceneModel(self, ...) end
            local model = template:Clone()
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                end
            end
            local root = model:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = true end
            return model
        end
        duelClass.GetCharacterModelForCutscene = wrappedCutsceneModel
        mainapi:Clean(function()
            if duelClass.GetCharacterModelForCutscene == wrappedCutsceneModel then
                duelClass.GetCharacterModelForCutscene = originalCutsceneModel
            end
        end)
    end

    local function watchPlayer(player)
        remember(player)
        if playerConnections[player] then return end
        playerConnections[player] = {
            player.CharacterAdded:Connect(function(character)
                -- Register the description before yielding. Character-loading code may
                -- request or reapply appearance data during the same spawn frame.
                for _, config in ipairs(allSpoofConfigs()) do
                    if config.Enabled and config.Avatar and config.Description
                        and not config.NativeApplyUnavailable
                        and configTargetsPlayer(config, player) then
                        hookState.AvatarDescriptionsByCharacter[character] = config.Description
                    end
                end
                task.defer(function()
                    if not alive or player.Character ~= character then return end
                    rebuildRecords()
                    for _, config in ipairs(allSpoofConfigs()) do
                        if config.Enabled and config.Avatar and config.Description
                            and configTargetsPlayer(config, player) then
                            if not config.NativeApplyUnavailable then
                                hookState.AvatarDescriptionsByCharacter[character] = config.Description
                            end
                            task.spawn(applyAvatar, player, config, config.Generation)
                        end
                    end
                end)
            end),
            player.CharacterAppearanceLoaded:Connect(function(character)
                task.defer(function()
                    if not alive or player.Character ~= character then return end
                    rebuildRecords()
                    for _, config in ipairs(allSpoofConfigs()) do
                        if config.Enabled and config.Avatar and config.Description
                            and configTargetsPlayer(config, player) then
                            if not config.NativeApplyUnavailable then
                                hookState.AvatarDescriptionsByCharacter[character] = config.Description
                            end
                            task.spawn(applyAvatar, player, config, config.Generation, true)
                        end
                    end
                end)
            end),
            player:GetPropertyChangedSignal("Team"):Connect(function()
                if alive and enemy.Enabled and enemy.Target == "All enemies" then refresh(enemy) end
            end),
            player:GetPropertyChangedSignal("Neutral"):Connect(function()
                if alive and enemy.Enabled and enemy.Target == "All enemies" then refresh(enemy) end
            end),
        }
    end
    for _, player in ipairs(service:GetPlayers()) do watchPlayer(player) end
    mainapi:Clean(service.PlayerAdded:Connect(function(player)
        watchPlayer(player)
        if enemy.Selector.SetList then
            enemy.Selector:SetList(playerList())
        elseif enemy.Selector.SetValues then
            enemy.Selector:SetValues(playerList())
        end
        if enemy.Enabled then refresh(enemy) end
    end))
    mainapi:Clean(service.PlayerRemoving:Connect(function(player)
        if shared.PlexSpooferPeerSync then shared.PlexSpooferPeerSync.Remove(player) end
        restoreAvatar(player)
        if playerConnections[player] then
            for _, connection in ipairs(playerConnections[player]) do connection:Disconnect() end
            playerConnections[player] = nil
        end
        originals[player], records[player] = nil, nil
        task.defer(function()
            if alive then
                if enemy.Selector.SetList then
                    enemy.Selector:SetList(playerList())
                elseif enemy.Selector.SetValues then
                    enemy.Selector:SetValues(playerList())
                end
                if enemy.Enabled then refresh(enemy) end
            end
        end)
    end))
    mainapi:Clean(function()
        alive = false
        ownName.Enabled, ownAvatar.Enabled, enemy.Enabled, advancedAvatar.Enabled = false, false, false, false
        ownName.Generation += 1
        ownAvatar.Generation += 1
        enemy.Generation += 1
        advancedAvatar.Generation += 1
        table.clear(records)
        restoreUI()
        for player in pairs(appearance) do restoreAvatar(player) end
        for _, list in pairs(playerConnections) do for _, connection in ipairs(list) do connection:Disconnect() end end
        for _, connection in pairs(rootConnections) do connection:Disconnect() end
        for _, connection in pairs(objectConnections) do connection:Disconnect() end
        if ownAvatar.Description then ownAvatar.Description:Destroy() end
        if enemy.Description then enemy.Description:Destroy() end
        if advancedAvatar.Description then advancedAvatar.Description:Destroy() end
        if advancedAvatar.BaseDescription then advancedAvatar.BaseDescription:Destroy() end
        clearAvatarTemplates(ownAvatar)
        clearAvatarTemplates(enemy)
        clearAvatarTemplates(advancedAvatar)
        for player, config in pairs(peerConfigs) do
            if config.Description then config.Description:Destroy() end
            clearAvatarTemplates(config)
            peerConfigs[player] = nil
        end
        shared.PlexSpooferPeerSync = nil
        if spoofFolder and spoofFolder.Parent then pcall(function() spoofFolder:Destroy() end) end
    end)

    function exportedApi.SetAvatar(enabled,source,headless)
        ownAvatar.Enabled=enabled==true
        ownAvatar.Source=tostring(source or "")
        ownAvatar.Headless=headless==true
        ownAvatar.CustomPicture=ownAvatar.Headless
        refresh(ownAvatar,true)
    end
    function exportedApi.SetUsername(enabled,username,displayName)
        ownName.Enabled=enabled==true
        ownName.Username=tostring(username or "")
        ownName.DisplayName=tostring(displayName or "")
        rebuildRecords()
    end
end)

end

exportedApi.SetAvatar=function(enabled,...)if not enabled and not identityReady then return end;ensureIdentity();return exportedApi.SetAvatar(enabled,...)end
exportedApi.SetUsername=function(enabled,...)if not enabled and not identityReady then return end;ensureIdentity();return exportedApi.SetUsername(enabled,...)end

    return assert(exportedApi,"Cosmetic controller unavailable. Join a fully loaded Rivals lobby.")
end

end)()
local function dispose(resource)
    if type(resource)=="function" then pcall(resource)
    elseif resource and resource.Disconnect then pcall(resource.Disconnect,resource)
    elseif resource and resource.Destroy then pcall(resource.Destroy,resource) end
end
runtime.PlexResources={}
function runtime:StopPlex()
    if self.PlexContext then self.PlexContext.Active=false end
    for index=#self.PlexResources,1,-1 do dispose(self.PlexResources[index]) end
    table.clear(self.PlexResources)
    if shared.LionCosmeticChanger==self.PlexApi then shared.LionCosmeticChanger=nil end
    self.PlexApi=nil
end
function runtime:EnsurePlex()
    assert(self.Alive,"Yabujin is unloaded")
    if self.PlexApi then return self.PlexApi end
    assert(not(shared.Modern and not shared.Modern.Uninjecting),"Unload Plex before enabling the standalone backend")
    local ctx={Active=true}
    self.PlexContext=ctx
    function ctx:Clean(resource)
        if not runtime.Alive or not self.Active then dispose(resource) else runtime.PlexResources[#runtime.PlexResources+1]=resource end
    end
    function ctx:Notify(data)
        if runtime.Library then runtime.Library:Notify(tostring(data.Text or data),4) end
    end
    local ok,api=pcall(createPlexBackend,ctx)
    if not ok then self:StopPlex(); error(api,0) end
    self.PlexApi=api
    return api
end
local createBackend=(function()
return function(runtime)
    local backend={Enabled=false,Alive=true,Unlock=false,Attributes={},AttributeConnections={},BlurState={strength=12}}
    local config=runtime.Context.spoofConfig
    local players=game:GetService('Players')
    local player=players.LocalPlayer
    local attributeFields={Level={'LevelSpoof','SpoofedLevel'},DisplayELO={'ELOSpoof','SpoofedELO'},DisplayELOLeaderboardRanking={'LeaderboardRankSpoof','SpoofedLeaderboardRank'},StatisticDuelsWinStreak={'StreakSpoof','SpoofedStreak'},PlayerStatus={'PassSpoof','SpoofedPlayerStatus'}}
    function backend:RefreshAttributes()
        for attribute,fields in pairs(attributeFields)do
            local value=self.Enabled and config[fields[1]]and config[fields[2]]or nil
            local saved=self.Attributes[attribute]
            if value~=nil then
                if not saved then saved={Value=player:GetAttribute(attribute)};self.Attributes[attribute]=saved end
                player:SetAttribute(attribute,value)
            elseif saved then
                self.Attributes[attribute]=nil
                player:SetAttribute(attribute,saved.Value)
            end
        end
    end
    function backend:Initialize()
        if self.Controller then return end
        runtime:EnsurePlex()
        local scripts=assert(player:FindFirstChild('PlayerScripts'),'PlayerScripts not ready')
        local controllers=assert(scripts:FindFirstChild('Controllers'),'Controllers not ready')
        local module=assert(controllers:FindFirstChild('PlayerDataController'),'This place has no Rivals PlayerDataController')
        local controller=require(module)
        assert(type(controller.Get)=='function','PlayerDataController.Get unavailable')
        self.Controller,self.OriginalGet=controller,controller.Get
        local dependencies=table.clone(runtime.Context)
        dependencies.spooferActive=true
        dependencies.spoofConfig=config
        dependencies.origDataGet=self.OriginalGet
        dependencies.weaponUnlockMode='none'
        self.Bound=runtime.New(dependencies)
        self.Read=function(owner,key,...)
            if not backend.Alive or not backend.Enabled then return backend.OriginalGet(owner,key,...)end

            return backend.Bound.hookClientDataGet(owner,key,...)
        end
    end
    function backend:RefreshInventory()
        runtime:EnsurePlex().SetUnlockAll(self.Unlock==true)
    end
    function backend:SetEnabled(enabled)
        if enabled then
            assert(self.Alive,'Backend unloaded')
            self:Initialize()
            self.Enabled=true
            self.Controller.Get=self.Read

        else
            self.Enabled=false
            if self.Controller and self.Controller.Get==self.Read then self.Controller.Get=self.OriginalGet end
            self.Inventory=nil
        end
        self:RefreshAttributes()
    end
    function backend:Refresh()
        self:RefreshAttributes()
        if self.Enabled and self.Controller then
            for _,key in ipairs({'Level','WeaponKeys','UnlockTokens','Glory','SkinTickets','EventCurrency','Seasons','Statistics'})do
                pcall(function()
                    local data=self.Controller.CurrentData
                    if data then data:GetDataChangedSignal(key):Fire(self.Controller:Get(key),key)end
                end)
            end
        end
    end
    function backend:SetIdentity(enabled)
        config.UsernameSpoof=enabled==true
        if enabled or runtime.PlexApi then
            runtime:EnsurePlex().SetUsername(enabled==true,config.SpoofedName or "",config.SpoofedDisplayName or "")
        end
    end
    function backend:SetBlur(enabled)
        if self.BlurConnection then self.BlurConnection:Disconnect();self.BlurConnection=nil end
        if self.BlurState.blur then self.BlurState.blur:Destroy();self.BlurState.blur=nil end
        self.BlurState.lastCFrame=nil
        if not enabled then return end
        local blur=Instance.new('BlurEffect');blur.Name='YabujinRecoveredMotionBlur';blur.Size=0;blur.Parent=game:GetService('Lighting')
        self.BlurState.blur=blur
        local helper=runtime.New({motionBlurState=self.BlurState})
        self.BlurConnection=game:GetService('RunService').Heartbeat:Connect(function(dt)helper.updateCameraMotionBlur(dt)end)
    end
    function backend:Destroy()
        if not self.Alive then return end
        self:SetEnabled(false)
        self:SetBlur(false)
        if config.UsernameSpoof then self:SetIdentity(false)end
        self.Alive=false
    end
    return backend
end

end)()
local createFrontend=(function()
return function(runtime,library)
    local backend=runtime.Backend
    local config=runtime.Context.spoofConfig
    local window=library:CreateWindow({Title='Yabujin',Footer='Standalone client · Plex cosmetic backend',AutoShow=true,Center=true,ToggleKeybind=Enum.KeyCode.RightShift})
    runtime.Window=window
    local tabs={Spoofers=window:AddTab('Spoofers','user'),Resources=window:AddTab('Resources','coins'),Cosmetics=window:AddTab('Cosmetics','shirt'),Visuals=window:AddTab('Visuals','eye'),Settings=window:AddTab('Settings','settings')}
    tabs.Inventory=window:AddTab('Inventory','box')
    tabs.Custom=window:AddTab('Custom cosmetics','palette')
    tabs.Ranks=window:AddTab('Ranks','award')
    local controls={}
    runtime.Controls=controls
    local function safe(fn)
        return function(...)
            local ok,why=pcall(fn,...)
            if not ok then runtime.LastError=why;warn('[Yabujin] '..tostring(why));if library.Notify then library:Notify(tostring(why),6)end end
        end
    end
    local menu=tabs.Settings:AddLeftGroupbox('Menu')
    local savedKey='RightShift'
    local settingsPath='Yabujin/menu.json'
    pcall(function()
        if isfile and readfile and isfile(settingsPath)then
            local data=game:GetService('HttpService'):JSONDecode(readfile(settingsPath))
            if type(data)=='table' and type(data.Key)=='string' and Enum.KeyCode[data.Key] and data.Key~='Unknown'then savedKey=data.Key end
        end
    end)
    local function saveMenuKey(key)
        pcall(function()
            if not writefile or not makefolder or not isfolder then return end
            if not isfolder('Yabujin')then makefolder('Yabujin')end
            writefile(settingsPath,game:GetService('HttpService'):JSONEncode({Key=key}))
        end)
    end
    function window:SetVisible(visible)
        if library.Unloaded then return end
        if library.Toggled~=(visible==true)then library:Toggle(visible==true)end
    end
    menu:AddLabel('Show / hide menu'):AddKeyPicker('Recovery_MenuKeybind',{
        Text='Menu keybind',Default=savedKey,Mode='Toggle',Modes={'Toggle'},NoUI=true,SyncToggleState=false,
        ChangedCallback=function()
            local picker=library.Options.Recovery_MenuKeybind
            if not picker then return end
            local ok,key=pcall(function()return Enum.KeyCode[picker.Value]end)
            if not ok or not key or key==Enum.KeyCode.Unknown then
                library:Notify('Choose a keyboard key for the menu.',3)
                picker:SetValue({savedKey,'Toggle'})
                return
            end
            savedKey=picker.Value
            library.ToggleKeybind=key
            saveMenuKey(savedKey)
        end,
    })
    library.ToggleKeybind=Enum.KeyCode[savedKey]
    menu:AddLabel('Default: Right Shift. Click the key above to rebind; typing does not toggle the menu.')
    menu:AddButton({Text='Reset menu key',Func=function()
        library.Options.Recovery_MenuKeybind:SetValue({'RightShift','Toggle'})
    end})
    local backendGroup=tabs.Settings:AddLeftGroupbox('Backend')
    backendGroup:AddToggle('Recovery_Backend',{Text='Enable data spoofing',Default=false,Callback=safe(function(value)backend:SetEnabled(value)end)})
    backendGroup:AddLabel('Spoofers change this client’s display; server balances and progression stay unchanged.')
    backendGroup:AddButton({Text='Refresh client display',Func=safe(function()backend:Refresh()end)})
    backendGroup:AddButton({Text='Unload',Func=function()runtime:Unload()end})
    local identity=tabs.Spoofers:AddLeftGroupbox('Username')
    config.SpoofedName,config.SpoofedDisplayName='',''
    identity:AddInput('Recovery_Username',{Text='Username',Default='',Finished=true,Callback=function(value)config.SpoofedName=value end})
    identity:AddInput('Recovery_DisplayName',{Text='Display name',Default='',Finished=true,Callback=function(value)config.SpoofedDisplayName=value end})
    identity:AddToggle('Recovery_NameEnabled',{Text='Username spoofer',Default=false,Callback=safe(function(value)backend:SetIdentity(value)end)})
    identity:AddButton({Text='Apply names',Func=safe(function()backend:SetIdentity(config.UsernameSpoof==true)end)})
    local profile=tabs.Spoofers:AddRightGroupbox('Profile display')
    local resources=tabs.Resources:AddLeftGroupbox('Currencies')
    local progression=tabs.Resources:AddRightGroupbox('Progression')
    local function numberControl(group,title,flag,field,default)
        config[flag],config[field]=false,default
        group:AddToggle('Recovery_'..flag,{Text=title,Default=false,Callback=safe(function(value)config[flag]=value;backend:Refresh()end)})
        group:AddInput('Recovery_'..field,{Text=title..' value',Default=tostring(default),Numeric=true,Finished=true,Callback=safe(function(value)
            local number=tonumber(value);assert(number and number==number and math.abs(number)<1e12,'Enter a finite number')
            config[field]=math.max(0,math.floor(number));backend:Refresh()
        end)})
    end
    numberControl(profile,'Level','LevelSpoof','SpoofedLevel',100)
    numberControl(profile,'ELO','ELOSpoof','SpoofedELO',2000)
    numberControl(profile,'Leaderboard rank','LeaderboardRankSpoof','SpoofedLeaderboardRank',1)
    numberControl(profile,'Win streak','StreakSpoof','SpoofedStreak',100)
    numberControl(resources,'Keys','KeysSpoof','SpoofedKeys',1000)
    numberControl(resources,'Unlock tokens','TokensSpoof','SpoofedTokens',100)
    numberControl(resources,'Event currency','EventCurrSpoof','SpoofedEventCurr',100)
    numberControl(resources,'Glory','GlorySpoof','SpoofedGlory',100)
    numberControl(resources,'Skin tickets','SkinTicketsSpoof','SpoofedSkinTickets',100)
    numberControl(progression,'Playtime','PlaytimeSpoof','SpoofedPlaytime',3600)
    local function api() return runtime:EnsurePlex() end
    local state={Weapon=nil,Kind='Skin',Selection=nil,Page=1,Query='',Entries={}}
    runtime.CosmeticState=state
    local cosmetic=tabs.Cosmetics:AddLeftGroupbox('Skin changer')
    local selected=tabs.Cosmetics:AddRightGroupbox('Cosmetics')
    cosmetic:AddToggle('Recovery_UnlockPreview',{Text='Unlock all cosmetics',Default=false,Callback=safe(function(value)
        backend.Unlock=value;backend:RefreshInventory()
    end)})
    cosmetic:AddToggle('Recovery_WeaponOwnership',{Text='Spoof weapon ownership',Default=false,Callback=safe(function(value)
        local ok,why=api().SetWeaponOwnership(value);assert(ok~=false,tostring(why))
    end)})
    local function refreshItems()
        if not runtime.PlexApi or not state.Weapon then return end
        state.Entries=api().CascadeCatalog(state.Kind,state.Weapon,state.Query)
        local values={}
        local pages=math.max(1,math.ceil(#state.Entries/60))
        state.Page=math.clamp(state.Page,1,pages)
        for index=(state.Page-1)*60+1,math.min(state.Page*60,#state.Entries)do values[#values+1]=state.Entries[index].Name end
        library.Options.Recovery_Cosmetic:SetValues(values)
        state.Selection=values[1]
        if state.Selection then library.Options.Recovery_Cosmetic:SetValue(state.Selection)end
        if runtime.CatalogStatus then runtime.CatalogStatus:SetText('Page '..state.Page..' / '..pages..' · '..#state.Entries..' items')end
    end
    cosmetic:AddDropdown('Recovery_Weapon',{Text='Weapon',Values={},AllowNull=true,Callback=safe(function(value)
        state.Weapon=value;state.Page=1;refreshItems()
    end)})
    cosmetic:AddDropdown('Recovery_Kind',{Text='Type',Values={'Skin','Wrap','Charm','Finisher','Emote'},Default='Skin',Callback=safe(function(value)
        state.Kind=value;state.Page=1;refreshItems()
    end)})
    cosmetic:AddInput('Recovery_CosmeticQuery',{Text='Search',Default='',Finished=true,Callback=safe(function(value)
        state.Query=value;state.Page=1;refreshItems()
    end)})
    selected:AddDropdown('Recovery_Cosmetic',{Text='Cosmetic',Values={},AllowNull=true,Callback=function(value)state.Selection=value end})
    runtime.CatalogStatus=selected:AddLabel('Press Load catalog to fetch items.')
    cosmetic:AddButton({Text='Load catalog',Func=safe(function()
        local values={}
        for _,entry in ipairs(api().CascadeCatalog('Weapon'))do values[#values+1]=entry.Name end
        library.Options.Recovery_Weapon:SetValues(values)
        if values[1]then library.Options.Recovery_Weapon:SetValue(state.Weapon or values[1])end
        refreshItems()
    end)})
    selected:AddButton({Text='Previous page',Func=safe(function()state.Page=math.max(1,state.Page-1);refreshItems()end)})
    selected:AddButton({Text='Next page',Func=safe(function()state.Page+=1;refreshItems()end)})
    selected:AddButton({Text='Equip selected',Func=safe(function()
        assert(state.Selection,'Choose a cosmetic');api().CascadeEquip(state.Weapon,state.Selection,state.Kind)
    end)})
    selected:AddButton({Text='Restore selected slot',Func=safe(function()api().CascadeEquip(state.Weapon,'None',state.Kind)end)})
    selected:AddButton({Text='Reset all cosmetics',Func=safe(function()api().CascadeReset()end)})
    local avatar=tabs.Spoofers:AddLeftGroupbox('Avatar')
    local identityState={Enabled=false,Source='',Headless=false}
    local function applyAvatar()api().SetAvatar(identityState.Enabled,identityState.Source,identityState.Headless)end
    avatar:AddInput('Recovery_AvatarSource',{Text='Username or user ID',Default='',Finished=true,Callback=function(value)identityState.Source=value end})
    avatar:AddToggle('Recovery_AvatarEnabled',{Text='Avatar spoofer',Default=false,Callback=safe(function(value)identityState.Enabled=value;applyAvatar()end)})
    avatar:AddToggle('Recovery_Headless',{Text='Headless',Default=false,Callback=safe(function(value)identityState.Headless=value;if identityState.Enabled then applyAvatar()end end)})
    avatar:AddButton({Text='Apply avatar',Func=safe(applyAvatar)})
    local rank=tabs.Ranks:AddLeftGroupbox('Rank display')
    local rankState={Enabled=false,Name='Gold',Placement=1,Season=0,CharmEnabled=false,CharmRank=nil,CharmPlacement=1}
    local function applyRank()api().SetRankSpoof(rankState.Enabled,rankState.Name,rankState.Placement)end
    rank:AddDropdown('Recovery_Rank',{Text='Rank',Values={'Bronze','Silver','Gold','Diamond','Onyx','Nemesis','Arch Nemesis'},Default='Gold',Callback=safe(function(value)rankState.Name=value;if rankState.Enabled then applyRank()end end)})
    rank:AddSlider('Recovery_RankPosition',{Text='Top placement',Min=1,Max=200,Default=1,Rounding=0,Callback=safe(function(value)rankState.Placement=value;if rankState.Enabled then applyRank()end end)})
    rank:AddToggle('Recovery_RankEnabled',{Text='Rank spoofer',Default=false,Callback=safe(function(value)rankState.Enabled=value;applyRank()end)})
    local charm=tabs.Ranks:AddRightGroupbox('Ranked charm')
    local function refreshCharm()
        local values=api().RankedCharmChoices(rankState.Season)
        library.Options.Recovery_CharmRank:SetValues(values)
        rankState.CharmRank=values[1]
        if values[1]then library.Options.Recovery_CharmRank:SetValue(values[1])end
    end
    local function applyCharm()
        if not rankState.CharmRank then refreshCharm()end
        api().SetRankedCharm(rankState.Season,rankState.CharmRank,rankState.CharmPlacement,rankState.CharmEnabled)
    end
    charm:AddDropdown('Recovery_CharmSeason',{Text='Season',Values={'Zero','Warp','Polar','Fame'},Default='Zero',Callback=safe(function(value)
        local previous=rankState.Season
        if runtime.PlexApi and rankState.CharmRank and rankState.CharmEnabled then api().SetRankedCharm(previous,rankState.CharmRank,rankState.CharmPlacement,false)end
        rankState.Season=(table.find({'Zero','Warp','Polar','Fame'},value)or 1)-1
        if runtime.PlexApi then refreshCharm();if rankState.CharmEnabled then applyCharm()end end
    end)})
    charm:AddDropdown('Recovery_CharmRank',{Text='Rank',Values={},AllowNull=true,Callback=safe(function(value)rankState.CharmRank=value;if rankState.CharmEnabled then applyCharm()end end)})
    charm:AddButton({Text='Load ranks',Func=safe(refreshCharm)})
    charm:AddSlider('Recovery_CharmPosition',{Text='Top placement',Min=1,Max=200,Default=1,Rounding=0,Callback=safe(function(value)rankState.CharmPlacement=value;if rankState.CharmEnabled then applyCharm()end end)})
    charm:AddToggle('Recovery_CharmEnabled',{Text='Ranked charm spoofer',Default=false,Callback=safe(function(value)rankState.CharmEnabled=value;applyCharm()end)})
    local inject=tabs.Inventory:AddLeftGroupbox('Cosmetics')
    local inventoryState={Amount=1,Box=nil,Open=1}
    inject:AddSlider('Recovery_InjectAmount',{Text='Amount',Min=1,Max=9999,Default=1,Rounding=0,Callback=function(value)inventoryState.Amount=value end})
    inject:AddButton({Text='Inject selected cosmetic',Func=safe(function()
        assert(state.Selection,'Choose a cosmetic in the Cosmetics tab')
        local ok,why=api().InjectCosmetic(state.Selection,inventoryState.Amount);assert(ok,tostring(why))
    end)})
    inject:AddButton({Text='Remove selected cosmetic',Func=safe(function()api().RemoveInjectedCosmetic(state.Selection)end)})
    local boxes=tabs.Inventory:AddRightGroupbox('Boxes')
    boxes:AddDropdown('Recovery_Box',{Text='Box',Values={},AllowNull=true,Callback=function(value)inventoryState.Box=value end})
    boxes:AddButton({Text='Load box catalog',Func=safe(function()
        local values=api().ListBoxes();library.Options.Recovery_Box:SetValues(values)
        if values[1]then library.Options.Recovery_Box:SetValue(values[1])end
    end)})
    boxes:AddButton({Text='Inject box',Func=safe(function()
        assert(inventoryState.Box,'Choose a box');local ok,why=api().InjectBox(inventoryState.Box,inventoryState.Amount);assert(ok,tostring(why))
    end)})
    boxes:AddSlider('Recovery_OpenAmount',{Text='Open amount',Min=1,Max=9999,Default=1,Rounding=0,Callback=function(value)inventoryState.Open=value end})
    boxes:AddButton({Text='Open selected box',Func=safe(function()
        assert(inventoryState.Box,'Choose a box');local ok,why=api().OpenBox(inventoryState.Box,inventoryState.Open,state.Weapon);assert(ok,tostring(why))
        library:Notify(tostring(why),4)
    end)})
    boxes:AddButton({Text='Remove box',Func=safe(function()api().RemoveBox(inventoryState.Box)end)})
    local creator=tabs.Custom:AddLeftGroupbox('Create cosmetic')
    local custom={Type='Skin',Name='',Rarity='Common',IconId='',ModelId=''}
    creator:AddDropdown('Recovery_CustomType',{Text='Type',Values={'Skin','Wrap','Charm','Finisher','Emote'},Default='Skin',Callback=function(value)custom.Type=value end})
    creator:AddDropdown('Recovery_CustomRarity',{Text='Rarity',Values={'Common','Uncommon','Rare','Epic','Legendary','Contraband'},Default='Common',Callback=function(value)custom.Rarity=value end})
    for _,spec in ipairs({{'Name','Custom name'},{'IconId','Icon asset ID (optional)'},{'ModelId','Model / texture / animation asset ID'}})do
        creator:AddInput('Recovery_Custom'..spec[1],{Text=spec[2],Default='',Finished=true,Callback=function(value)custom[spec[1]]=value end})
    end
    creator:AddLabel('Uses the weapon selected in Cosmetics. Wraps use textures; emotes use animations.')
    creator:AddButton({Text='Create cosmetic',Func=safe(function()
        local def=table.clone(custom);def.Weapon=state.Weapon
        if def.Type=='Emote'then def.AnimationId=def.ModelId end
        local ok,key=api().RegisterCustomCosmetic(def);assert(ok,tostring(key));library:Notify('Created '..tostring(def.Name),3);refreshItems()
    end)})
    local files=tabs.Settings:AddRightGroupbox('Cosmetic config')
    local configName='default'
    files:AddInput('Recovery_ConfigName',{Text='Config name',Default='default',Finished=true,Callback=function(value)configName=value end})
    files:AddButton({Text='Save cosmetics',Func=safe(function()local ok,why=api().SaveConfig(configName);assert(ok~=false,tostring(why))end)})
    files:AddButton({Text='Load cosmetics',Func=safe(function()local ok,why=api().LoadConfig(configName);assert(ok~=false,tostring(why));refreshItems()end)})
    local visual=tabs.Visuals:AddLeftGroupbox('Motion blur')
    visual:AddToggle('Recovery_MotionBlur',{Text='Motion blur',Default=false,Callback=safe(function(value)backend:SetBlur(value)end)})
    visual:AddSlider('Recovery_BlurStrength',{Text='Strength',Default=12,Min=1,Max=30,Rounding=0,Callback=function(value)backend.BlurState.strength=value end})
    if library.OnUnload then library:OnUnload(function()
        backend:Destroy();runtime:StopPlex();runtime.Alive=false
    end)end
    return window
end

end)()
if game then runtime.Backend=createBackend(runtime)end
if options.AutoStart~=false and game then
    local library,why=runtime:StartUI()
    if library then
        local ok,result=pcall(createFrontend,runtime,library)
        if not ok then runtime.LastError=result;warn("[Yabujin Recovery] Window failed: "..tostring(result))end
    else runtime.LastError=why;warn("[Yabujin Recovery] UI failed: "..tostring(why))end
end
return runtime
