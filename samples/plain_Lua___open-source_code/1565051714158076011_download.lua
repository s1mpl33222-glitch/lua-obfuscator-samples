if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local S,P,G={"e6a0090bbf96a2986a3ab4ee4694600ce7862a105dae4531a1fc7cfe106fc9f9"},{},{[2809202155]=1};local i=P[game.PlaceId]or G[game.GameId];if not i then local n=function(...)
-- ========================================================
-- Chopa — YBA (v19.1)
-- Your Methion SH script (functions unchanged) in the Chopa blue design + the Chopa delivery agent
-- that talks to Chopa Hub (FunPay Lucky Arrow orders). Save as "auto_trader.lua" in the executor workspace.
-- ========================================================
-- Chopa: loading watchdog (runs from autoexec and after every hop, before the game has loaded).
-- "Stuck" = the game is not loaded and nothing new comes from the server (no new objects and no incoming
-- data for 15 s once loading started, 25 s while still connecting, 75 s in total), or Roblox shows an
-- error window while loading. A slow PC that is still receiving data is never interrupted.
-- Then it leaves for another YBA server: 1st try Roblox matchmaking (always a live server),
-- 2nd try a healthy server from the list, and so on every 10 s. It never leaves the game.
-- The server that hung goes to chopa_bad_servers.json: no bot joins it for 30 min.
-- When Roblox never connects to the server (no player object), scripts cannot move the client at all:
-- after a teleport without a player (25 s) the watchdog CLOSES Roblox at 40 s (freezes the window so
-- Chopa Hub closes the process; the injector starts it again). Also closed: not loaded after 90 s.
-- Every step is written to workspace/chopa_stuck_log.txt
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    if not env.__ChopaWatchdog then
        env.__ChopaWatchdog = true
        task.spawn(function()
            local Players = game:GetService("Players")
            local TS = game:GetService("TeleportService")
            local HS = game:GetService("HttpService")
            local YBA_PLACE = 2809202155                -- Your Bizarre Adventure
            local LOG = "chopa_stuck_log.txt"
            local function placeId() return (tonumber(game.PlaceId) or 0) ~= 0 and game.PlaceId or YBA_PLACE end
            local function log(msg)
                local line = os.date("%d.%m %H:%M:%S") .. "  [loading] " .. msg
                print("[Chopa] " .. msg)
                pcall(function()
                    local old = (type(isfile) == "function" and isfile(LOG)) and readfile(LOG) or ""
                    if type(appendfile) == "function" and #old < 150000 then
                        appendfile(LOG, line .. "\n")
                    elseif type(writefile) == "function" then
                        writefile(LOG, (old .. line .. "\n"):sub(-100000))      -- keep the file small
                    end
                end)
            end
            local function readJSON(path)
                local ok, data = pcall(function() return isfile(path) and HS:JSONDecode(readfile(path)) end)
                return ok and type(data) == "table" and data or nil
            end
            local function markBad(id)
                if type(id) ~= "string" or id == "" or type(writefile) ~= "function" then return end
                local bad = readJSON("chopa_bad_servers.json") or {}
                for k, t in pairs(bad) do if os.time() - (tonumber(t) or 0) > 1800 then bad[k] = nil end end
                bad[id] = os.time()
                pcall(function() writefile("chopa_bad_servers.json", HS:JSONEncode(bad)) end)
            end
            local function requeue()
                local qot = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
                if type(qot) ~= "function" then return end
                local src
                pcall(function()
                    if isfile("auto_trader.lua") then src = 'loadstring(readfile("auto_trader.lua"))()' end
                end)
                if src then pcall(qot, src) end
            end
            local tried = {}
            local function pickServer()
                local data
                local cache = readJSON("chopa_servers_cache.json")
                if cache and type(cache.data) == "table" and os.time() - (tonumber(cache.at) or 0) < 300 then data = cache.data end
                if not data then
                    pcall(function()
                        local p = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId()
                            .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"))
                        if type(p) == "table" and type(p.data) == "table" then data = p.data end
                    end)
                end
                if not data then return nil end
                local bad = readJSON("chopa_bad_servers.json") or {}
                local best = {}
                for _, sv in ipairs(data) do
                    local playing, maxP = tonumber(sv.playing) or 99, tonumber(sv.maxPlayers) or 0
                    local badAt = tonumber(bad[sv.id])
                    if type(sv.id) == "string" and sv.id ~= game.JobId and not tried[sv.id]
                        and not (badAt and os.time() - badAt < 1800)
                        and playing >= 3 and playing <= maxP - 4
                        and (tonumber(sv.fps) or 0) >= 55 and (tonumber(sv.ping) or 999) <= 220 then
                        table.insert(best, sv)
                    end
                end
                table.sort(best, function(a, b) return (tonumber(a.playing) or 0) < (tonumber(b.playing) or 0) end)
                local pick = best[math.random(1, math.max(1, math.min(5, #best)))]
                if pick then tried[pick.id] = true return pick.id end
                return nil
            end
            local function errorWindowShown()
                local ok, shown = pcall(function()
                    local p = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    p = p and p:FindFirstChild("promptOverlay")
                    p = p and p:FindFirstChild("ErrorPrompt")
                    return p ~= nil and p.Visible ~= false
                end)
                return ok and shown == true
            end
            -- Close Roblox: the window is frozen on purpose (busy loop, no yields) → Windows marks it
            -- "Not Responding" → Chopa Hub closes the process → the injector starts Roblox again.
            -- (game:Shutdown() only goes back to the Roblox home screen, the process would stay alive.)
            -- If nothing closes it within 150 s, it leaves the game the normal way.
            local function closeRoblox(reason)
                if env.__ChopaClosing then return end
                env.__ChopaClosing = true
                log("CLOSING Roblox (" .. reason .. ") — window frozen on purpose; Chopa Hub closes it, the injector restarts it")
                task.wait(0.3)
                task.delay(165, function() pcall(function() game:Shutdown() end) end)
                local untilT = os.clock() + 150
                while os.clock() < untilT do
                    pcall(function()
                        local t0 = os.clock()
                        while os.clock() - t0 < 3 do end
                    end)
                end
            end
            env.__ChopaCloseRoblox = closeRoblox
            local function progress()
                local n = 0
                pcall(function() n = #workspace:GetDescendants() end)
                pcall(function() n += #game:GetService("ReplicatedStorage"):GetDescendants() end)
                return n
            end
            local function receiving()             -- data is arriving from the server right now
                local ok, kbps = pcall(function() return game:GetService("Stats").DataReceiveKbps end)
                return ok and type(kbps) == "number" and kbps > 0.5
            end

            -- what kind of join this is (set by the hop / rejoin that queued the script; may arrive a bit later)
            local function joinKind()
                local kind = env.__ChopaJoinKind
                if type(kind) == "string" and kind ~= "" then return kind end
                return "start / autoexec"
            end
            local function joinTarget()
                local t = env.__ChopaJoinTarget
                return (type(t) == "string" and t ~= "") and t or nil
            end
            local started = os.clock()
            local lastCount, lastChange = progress(), os.clock()
            local attempts, nextTry = 0, 0
            log("started (loaded: " .. tostring(game:IsLoaded()) .. ", player: " .. tostring(Players.LocalPlayer ~= nil) .. ")")
            while not game:IsLoaded() do
                task.wait(1)
                local now = os.clock()
                local count = progress()
                if count ~= lastCount or receiving() then lastCount, lastChange = count, now end
                local quietFor = now - lastChange
                local limit = lastCount < 60 and 25 or 15        -- still connecting / already loading
                local errorShown = errorWindowShown()
                if (errorShown or quietFor >= limit or now - started >= 75) and now >= nextTry then
                    attempts += 1
                    nextTry = now + 10
                    local target = joinTarget()
                    if attempts == 1 and target then
                        markBad(target)
                        log("server " .. target:sub(1, 8) .. " did not load — no bot will join it for 30 min")
                    end
                    local why = errorShown and "error window" or string.format("nothing loaded for %.0f s", quietFor)
                    local lp = Players.LocalPlayer
                    local quiet = attempts > 6 and attempts % 6 ~= 0          -- long hang: log once a minute
                    if not lp then
                        -- not connected: the only call left is a teleport without a player object
                        local ok, err = true, nil
                        if attempts % 3 == 1 then
                            requeue()
                            ok, err = pcall(function() TS:Teleport(placeId()) end)
                        end
                        if not quiet then
                            log(string.format("try %d (%s, join: %s): Roblox never connected (no player)%s", attempts, why, joinKind(),
                                attempts % 3 == 1 and (" — teleport without player → " .. (ok and "sent" or tostring(err))) or ""))
                        end
                    else
                        requeue()
                        pcall(function() TS:TeleportCancel() end)
                        local id = (attempts % 2 == 0) and pickServer() or nil
                        if id then
                            local ok, err = pcall(function() TS:TeleportToPlaceInstance(placeId(), id, lp) end)
                            log(string.format("try %d (%s): healthy server %s → %s", attempts, why, id:sub(1, 8), ok and "sent" or tostring(err)))
                        else
                            local ok, err = pcall(function() TS:Teleport(placeId(), lp) end)
                            log(string.format("try %d (%s): YBA matchmaking → %s", attempts, why, ok and "sent" or tostring(err)))
                        end
                    end
                end
                -- no way out from inside: close Roblox (only while really joining a game, never on the app home)
                local lpNow = Players.LocalPlayer
                local joining = (tonumber(game.PlaceId) or 0) ~= 0 or (type(env.__ChopaJoinKind) == "string" and env.__ChopaJoinKind ~= "")
                local tooLong = (not lpNow and quietFor >= 40) or (now - started >= 90)
                if tooLong and joining then
                    closeRoblox(string.format("game not loaded for %.0f s%s, join: %s", now - started,
                        lpNow and "" or ", never connected", joinKind()))
                elseif tooLong and not env.__ChopaHomeNoted then
                    env.__ChopaHomeNoted = true
                    log("not loaded, but no game is being joined (PlaceId 0) — not closing")
                end
            end
            log(string.format("game loaded after %.0f s", os.clock() - started))
        end)
    end
end
if not game:IsLoaded() then game.Loaded:Wait() end
if _G.__CHOPA_LOADED then return end
_G.__CHOPA_LOADED = true
-- ================= CHOPA: rejoin YBA after ANY Roblox error =================
-- Detects: Roblox error window (Disconnected 277, kicked 267, server shut down 288, teleport failed …),
-- GuiService error message, lost server connection, and a frozen server (no data for 25 s).
-- Action: the script is queued again, then
--   * the window has a Reconnect button → it is pressed at once (fastest way back)
--   * then (or right away when there is no button) → join YBA through Roblox matchmaking,
--     which always gives a live server; repeated every 4 s until the bot is out.
-- It does not depend on clicking the button, so it works on every executor.
-- "DisconnectClientInitiated" is the client leaving on purpose (a hop) — not an error.
-- Rejoins are spaced out when errors repeat (3+ in 2 min → 20 s pause, 5+ → 60 s), so a kick loop does
-- not flood Roblox with joins (too many joins from one PC is what makes joins hang).
-- Still on the errored server 45 s after the first try → Roblox is closed (window frozen on purpose,
-- Chopa Hub closes it, the injector starts it again).
-- Every step is written to workspace/chopa_stuck_log.txt
task.spawn(function()
    local Players = game:GetService("Players")
    local TS = game:GetService("TeleportService")
    local GuiService = game:GetService("GuiService")
    local YBA_PLACE = 2809202155
    local R = { errorAt = nil, reason = "", lastTry = -1e9, tries = 0, teleportingAt = -1e9 }
    local VIM
    pcall(function() VIM = game:GetService("VirtualInputManager") end)

    local function placeId() return (tonumber(game.PlaceId) or 0) ~= 0 and game.PlaceId or YBA_PLACE end
    local function log(msg)
        print("[Chopa] " .. msg)
        pcall(function()
            local line = os.date("%d.%m %H:%M:%S") .. "  [error] " .. msg .. "\n"
            local old = (isfile and isfile("chopa_stuck_log.txt")) and readfile("chopa_stuck_log.txt") or ""
            if type(appendfile) == "function" and #old < 150000 then appendfile("chopa_stuck_log.txt", line)
            elseif type(writefile) == "function" then
                writefile("chopa_stuck_log.txt", (old .. line):sub(-100000))
            end
        end)
    end
    local function queueSelf()
        local qot = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
        if type(qot) == "function" and isfile and isfile("auto_trader.lua") then
            pcall(qot, 'local e = (type(getgenv) == "function" and getgenv()) or _G; e.__ChopaJoinKind = "rejoin after error"; e.__ChopaJoinTarget = ""\n'
                .. 'loadstring(readfile("auto_trader.lua"))()')
        end
    end
    -- rejoins of this account in the last minutes (shared file, survives the server change)
    local function rejoinsFile() return "chopa_rejoins_" .. tostring(Players.LocalPlayer and Players.LocalPlayer.Name or "x") .. ".json" end
    local function recentRejoins()
        local list = {}
        pcall(function()
            if isfile(rejoinsFile()) then
                for _, t in ipairs(game:GetService("HttpService"):JSONDecode(readfile(rejoinsFile()))) do
                    if os.time() - (tonumber(t) or 0) < 600 then table.insert(list, tonumber(t)) end
                end
            end
        end)
        return list
    end
    local function rememberRejoin()
        local list = recentRejoins()
        table.insert(list, os.time())
        pcall(function() writefile(rejoinsFile(), game:GetService("HttpService"):JSONEncode(list)) end)
    end
    local function errorPrompt()
        local ok, prompt = pcall(function()
            local rpg = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
            local overlay = rpg and rpg:FindFirstChild("promptOverlay")
            return overlay and overlay:FindFirstChild("ErrorPrompt")
        end)
        if ok and prompt and prompt.Visible ~= false then return prompt end
        return nil
    end
    local function promptText(prompt)
        local parts = {}
        pcall(function()
            for _, d in ipairs(prompt:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text ~= "" and not d:FindFirstAncestorWhichIsA("GuiButton") then
                    table.insert(parts, d.Text)
                end
            end
        end)
        return (table.concat(parts, " | "):gsub("%s+", " ")):sub(1, 120)
    end
    local function findReconnect(prompt)
        local found
        pcall(function()
            for _, d in ipairs(prompt:GetDescendants()) do
                if d:IsA("GuiButton") and d.Visible then
                    local label = d.Name .. " " .. (d:IsA("TextButton") and d.Text or "")
                    for _, t in ipairs(d:GetDescendants()) do
                        if t:IsA("TextLabel") then label = label .. " " .. t.Text end
                    end
                    label = label:lower()
                    if label:find("reconnect", 1, true) or label:find("переподключ", 1, true) then found = d return end
                end
            end
        end)
        return found
    end
    local function press(btn)
        local fired = false
        for _, sig in ipairs({ btn.Activated, btn.MouseButton1Click }) do
            if type(getconnections) == "function" then
                local ok, conns = pcall(getconnections, sig)
                if ok and type(conns) == "table" then
                    for _, c in ipairs(conns) do fired = true; pcall(function() c:Fire() end) end
                end
            elseif type(firesignal) == "function" then
                fired = pcall(firesignal, sig) or fired
            end
            if fired then break end
        end
        if VIM then
            pcall(function()
                local sg = btn:FindFirstAncestorWhichIsA("ScreenGui")
                local inset = (sg and not sg.IgnoreGuiInset) and GuiService:GetGuiInset().Y or 0
                local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2 + inset
                VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
            end)
        end
    end

    local genv = (type(getgenv) == "function" and getgenv()) or _G
    local function closeRoblox(reason)
        if genv.__ChopaClosing then return end
        genv.__ChopaClosing = true
        log("CLOSING Roblox (" .. reason .. ") — window frozen on purpose; Chopa Hub closes it, the injector restarts it")
        task.wait(0.3)
        task.delay(165, function() pcall(function() game:Shutdown() end) end)
        local untilT = os.clock() + 150
        while os.clock() < untilT do
            pcall(function()
                local t0 = os.clock()
                while os.clock() - t0 < 3 do end
            end)
        end
    end
    _G.__ChopaCloseRoblox = closeRoblox

    local function signal(reason)
        if R.errorAt then return end
        if reason:lower():find("clientinitiated", 1, true) then return end   -- our own hop / leave
        if reason:lower():find("exploit", 1, true) then reason = "kicked by YBA anti-cheat — " .. reason end
        -- leaving the server on purpose (server hop) is not an error
        if reason == "connection to the server lost" and os.clock() - R.teleportingAt < 45 then return end
        R.errorAt, R.reason = os.clock(), reason
        _G.__ChopaRejoining = true
        -- errors repeating fast (kick loop) → wait a bit before joining again
        local n = 0
        for _, t in ipairs(recentRejoins()) do if os.time() - t < 120 then n += 1 end end
        -- Chopa: instant rejoin; only a real kick loop (8+ errors in 2 min) waits 10 s
        R.waitUntil = os.clock() + (n >= 8 and 10 or 0)
        log("Roblox error: " .. reason .. (n >= 8 and string.format(" (%d rejoins in 2 min — waiting 10 s first)", n) or ""))
    end
    _G.__ChopaRejoin = signal

    pcall(function()
        Players.LocalPlayer.OnTeleport:Connect(function(state)
            if state == Enum.TeleportState.Started or state == Enum.TeleportState.WaitingForServer
                or state == Enum.TeleportState.InProgress then
                R.teleportingAt = os.clock()
            elseif state == Enum.TeleportState.Failed then
                R.teleportingAt = -1e9                 -- that join failed: the next try may start at once
            end
        end)
    end)
    pcall(function()
        GuiService.ErrorMessageChanged:Connect(function(msg)
            if type(msg) == "string" and msg ~= "" then signal("error message: " .. msg:sub(1, 120)) end
        end)
    end)
    pcall(function()
        game:GetService("NetworkClient").ChildRemoved:Connect(function()
            task.delay(0.2, function() signal("connection to the server lost") end)
        end)
    end)
    -- frozen server: game time stands still AND no data arrives for 15 s
    task.spawn(function()
        local lastT, sameSince = nil, os.clock()
        while not R.errorAt do
            task.wait(1)
            local okT, t = pcall(function() return workspace.DistributedGameTime end)
            if okT and t ~= lastT then lastT, sameSince = t, os.clock() end
            local okK, kbps = pcall(function() return game:GetService("Stats").DataReceiveKbps end)
            if okT and okK and type(kbps) == "number" and kbps < 0.05 and os.clock() - sameSince > 15
                and os.clock() - R.teleportingAt > 45 then
                signal("server stopped responding (15 s without data)")
            end
        end
    end)

    while true do
        task.wait(0.1)
        local prompt = errorPrompt()
        if prompt and not R.errorAt then signal("error window: " .. promptText(prompt)) end
        -- (while a join is already under way, a second one is not started on top of it)
        if R.errorAt and R.tries > 0 and os.clock() - math.max(R.errorAt, R.waitUntil or 0) >= 45 then
            closeRoblox("could not get back into YBA for 45 s after: " .. R.reason)
        end
        if R.errorAt and os.clock() >= (R.waitUntil or 0) and os.clock() - R.lastTry >= 2 and os.clock() - R.teleportingAt >= 4 then
            R.lastTry = os.clock()
            R.tries += 1
            if R.tries == 1 then rememberRejoin() end
            queueSelf()
            -- Chopa: from the very first try — Reconnect button (if shown) AND matchmaking join at once
            local btn = prompt and findReconnect(prompt)
            if btn then press(btn) end
            local ok, err = pcall(function() TS:Teleport(placeId(), Players.LocalPlayer) end)
            log(string.format("try %d: join YBA (matchmaking)%s → %s", R.tries, btn and " + Reconnect" or "",
                ok and "sent" or tostring(err)))
        end
    end
end)


-- ================= CHOPA: does this player have a saved config? =================
-- No config (a new user) → EVERY function starts switched off; the user turns on what he needs and saves
-- a config. With a config, the saved values are used (missing options keep their usual default).
do
    local has = false
    pcall(function()
        if type(isfolder) ~= "function" or type(listfiles) ~= "function" then return end
        for _, folder in ipairs({ "AirflowUI", "Chopa" }) do        -- the menu saves configs in AirflowUI
            if isfolder(folder) then
                for _, path in ipairs(listfiles(folder)) do
                    if tostring(path):lower():sub(-5) == ".json" then has = true break end
                end
            end
            if has then break end
        end
    end)
    _G.__ChopaHasConfig = has
end
local CHOPA_HAS_CONFIG = _G.__ChopaHasConfig == true

-- ================= CHOPA: fast main-menu skip (runs first, before the menu loads) =================
-- Presses Play the way the game does (PressedPlay), clicks Skip / Play buttons as a backup and
-- removes the loading screen. On/off: Graphics → Main menu (file chopa_skipmenu_<name>.txt).
do
    local SM = { enabled = true, done = false, running = false, took = nil,
        file = "chopa_skipmenu_" .. game:GetService("Players").LocalPlayer.Name .. ".txt" }
    _G.__ChopaSkipMenu = SM
    SM.enabled = _G.__ChopaHasConfig == true
    pcall(function()
        if isfile and isfile(SM.file) then SM.enabled = readfile(SM.file) ~= "0" end   -- the user's own choice
    end)

    function SM.run()
        if SM.running then return end
        SM.running = true
        local Players = game:GetService("Players")
        local GuiService = game:GetService("GuiService")
        local LP = Players.LocalPlayer
        local VIM
        pcall(function() VIM = game:GetService("VirtualInputManager") end)
        local started = os.clock()
        local lastRemote, lastClick, pressed = -10, -10, false

        local function screens(pg)
            local out = {}
            for _, n in ipairs({ "LoadingScreen1", "LoadingScreen" }) do
                local g = pg:FindFirstChild(n)
                if g then table.insert(out, g) end
            end
            return out
        end
        local function click(btn)
            -- the button's own handlers (MouseButton1Click, or Activated if it has none)
            for _, sig in ipairs({ btn.MouseButton1Click, btn.Activated }) do
                local n = 0
                if getconnections then
                    local ok, conns = pcall(getconnections, sig)
                    if ok and conns then for _, c in ipairs(conns) do n += 1; pcall(function() c:Fire() end) end end
                elseif firesignal then
                    n = pcall(firesignal, sig) and 1 or 0
                end
                if n > 0 then break end
            end
            if VIM and btn.AbsoluteSize.X > 0 and btn.AbsolutePosition.X >= 0 then
                local sg = btn:FindFirstAncestorWhichIsA("ScreenGui")
                local inset = (sg and not sg.IgnoreGuiInset) and GuiService:GetGuiInset().Y or 0
                local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
                local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2 + inset
                pcall(function()
                    VIM:SendMouseButtonEvent(x, y, 0, true, game, 1)
                    VIM:SendMouseButtonEvent(x, y, 0, false, game, 1)
                end)
            end
        end
        local function clickButtons(gui)
            for _, b in ipairs(gui:GetDescendants()) do
                if b:IsA("GuiButton") and b.Visible then
                    local name = b.Name:lower()
                    local text = b:IsA("TextButton") and b.Text:lower() or ""
                    if name:find("skip", 1, true) or text:find("skip", 1, true) or text:find("пропуст", 1, true)
                        or name:find("play", 1, true) or text:find("play", 1, true) or text:find("играть", 1, true) then
                        click(b)
                    end
                end
            end
        end

        while os.clock() - started < 60 do
            local pg = LP:FindFirstChild("PlayerGui")
            local char = LP.Character
            local list = pg and screens(pg) or {}
            -- no menu (already in the game, or it is gone after Play) → done; wait 3 s in case it appears late
            if pg and #list == 0 and (pressed or os.clock() - started > 3) then break end
            if #list > 0 then
                local remote = char and char:FindFirstChild("RemoteEvent")
                if remote and remote:IsA("RemoteEvent") and os.clock() - lastRemote > 1.5 then
                    lastRemote = os.clock()
                    pcall(function() remote:FireServer("PressedPlay") end)
                    pressed = true
                end
                if os.clock() - lastClick > 0.5 then
                    lastClick = os.clock()
                    for _, g in ipairs(list) do pcall(clickButtons, g) end
                end
                if pressed then
                    for _, g in ipairs(list) do pcall(function() g:Destroy() end) end
                    pcall(function() if LP:GetAttribute("LOADED") == nil then LP:SetAttribute("LOADED", "Skip") end end)
                    pcall(function()
                        local dof = game:GetService("Lighting"):FindFirstChild("DepthOfField")
                        if dof then dof:Destroy() end
                        local ls = workspace:FindFirstChild("LoadingScreen")
                        local song = ls and ls:FindFirstChild("Song")
                        if song then song:Destroy() end
                    end)
                end
            end
            task.wait(0.05)
        end
        if pressed then
            SM.took = os.clock() - started
            print(string.format("[Chopa] Main menu skipped in %.2f s", SM.took))
        end
        SM.done, SM.running = true, false
    end

    if SM.enabled then task.spawn(function() pcall(SM.run) end) end
end

-- ================= CHOPA DELIVERY AGENT (talks to Chopa Hub) =================
-- Runs in its own function so it never touches the Methion code below.
-- Shared with the Methion part: _G.__ChopaAgent.delivering / .pending (the farm pauses while true)
_G.__ChopaAgent = { delivering = false, pending = false, farming = false }
local function chopaDeliveryAgent()
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local VirtualUser = game:GetService("VirtualUser")
    local LocalPlayer = Players.LocalPlayer
    local ACCOUNT = LocalPlayer.Name
    local A = _G.__ChopaAgent

    -- GUIs that existed before the cheat menu was built (Roblox's own). Everything added to
    -- CoreGui / gethui() later belongs to the script and is hidden for the proof screenshot.
    local guiBaseline = {}
    local function guiRoots()
        local roots = {}
        pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
        pcall(function()
            if typeof(gethui) == "function" then
                local h = gethui()
                if h and h ~= roots[1] then table.insert(roots, h) end
            end
        end)
        return roots
    end
    for _, root in ipairs(guiRoots()) do
        pcall(function() for _, c in ipairs(root:GetChildren()) do guiBaseline[c] = true end end)
    end
    local SCRIPT_GUI = { "phantom", "methion", "chopa", "airflow" }   -- script GUIs that may fall back to PlayerGui
    local function hideCheatGui()
        local hidden = {}
        local function hide(g)
            if g:IsA("LayerCollector") and g.Name ~= "ChopaProof" and g.Enabled then
                g.Enabled = false
                table.insert(hidden, g)
            end
        end
        for _, root in ipairs(guiRoots()) do
            pcall(function()
                for _, c in ipairs(root:GetChildren()) do
                    if not guiBaseline[c] then
                        pcall(hide, c)
                        if c:IsA("Folder") then for _, cc in ipairs(c:GetChildren()) do pcall(hide, cc) end end
                    end
                end
            end)
        end
        pcall(function()
            for _, c in ipairs(LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
                local low = c.Name:lower()
                for _, key in ipairs(SCRIPT_GUI) do
                    if low:find(key, 1, true) then pcall(hide, c) break end
                end
            end
        end)
        return hidden
    end
    local function showCheatGui(hidden)
        for _, g in ipairs(hidden or {}) do pcall(function() if g.Parent then g.Enabled = true end end) end
    end

    local DLV = { JOIN_DELAY = 0, LOAD = 2, SPEED = 220, SEGMENT = 0.35, STOP = 4, TIMEOUT = 60, ANCHOR = 1, PICKUP = 3,
        CLEAR_RADIUS = 14, CLEAR_WAIT = 15,
        STEP_AWAY = 7,       -- after the drop the bot steps this far back so it never stands on its own money
        SETTLE = 8,          -- seconds the balance is watched after a drop (own money back = drop again)
        LIFT = 18,           -- the way back home goes this high above the ground (not across the money)
        MAX_REDROPS = 3 }
    local FILES = {
        handshake = "chopa_handshake_" .. ACCOUNT .. ".json",
        status = "chopa_status_" .. ACCOUNT .. ".json",
        queue = "trade_queue_" .. ACCOUNT .. ".json",
        stats = "chopa_farm_" .. ACCOUNT .. ".json",
        shot = "chopa_shot_" .. ACCOUNT .. ".json",
    }

    local function readJSON(path)
        if not isfile or not isfile(path) then return nil end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        return ok and data or nil
    end
    local function writeJSON(path, data)
        if writefile then pcall(function() writefile(path, HttpService:JSONEncode(data)) end) end
    end

    local executor = "Unknown Executor"
    pcall(function()
        if identifyexecutor then
            local n, v = identifyexecutor()
            executor = tostring(n) .. (v and (" " .. tostring(v)) or "")
        elseif getexecutorname then
            executor = tostring(getexecutorname())
        end
    end)
    writeJSON(FILES.handshake, { executor = executor, account = ACCOUNT, created_at = os.time() })

    -- anti-AFK (the bot must stay on the server for buyers)
    LocalPlayer.Idled:Connect(function()
        pcall(function()
            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
    end)

    local joinedAt = {}
    for _, p in ipairs(Players:GetPlayers()) do joinedAt[p.UserId] = 0 end
    Players.PlayerAdded:Connect(function(p) joinedAt[p.UserId] = tick() end)
    Players.PlayerRemoving:Connect(function(p) joinedAt[p.UserId] = nil end)

    local function myHRP()
        local c = LocalPlayer.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function targetHRP(p)
        local c = p.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function getMoney()
        local ps = LocalPlayer:FindFirstChild("PlayerStats")
        local m = ps and ps:FindFirstChild("Money")
        return m and tonumber(m.Value) and math.floor(m.Value) or nil
    end

    -- Lucky Arrow counter for the hub (baseline once the backpack is stable)
    local stats = readJSON(FILES.stats)
    stats = type(stats) == "table" and stats or {}
    -- count = nil until the inventory has been read (the hub shows «—», never a false 0)
    local lucky = { count = nil, session = 0, total = tonumber(stats.luckyTotal) or 0 }
    local function isLuckyTool(t)
        -- exactly «Lucky Arrow» (not Lucky Stone Mask / other arrows); spaces and case do not matter
        return t:IsA("Tool") and t.Name:lower():gsub("^%s+", ""):gsub("%s+$", "") == "lucky arrow"
    end
    local function countLucky()
        local n = 0
        for _, c in ipairs({ LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character }) do
            if c then
                for _, t in ipairs(c:GetChildren()) do
                    if isLuckyTool(t) then n += 1 end
                end
            end
        end
        return n
    end
    A.getMoney, A.countLucky, A.luckyStats = getMoney, countLucky, lucky     -- for the Discord webhook
    local function countItem(name)                 -- Tools of this item (names compared without case / spaces / dashes)
        local want, n = (tostring(name or ""):lower():gsub("[^%w]", "")), 0
        for _, c in ipairs({ LocalPlayer:FindFirstChild("Backpack"), LocalPlayer.Character }) do
            if c then
                for _, t in ipairs(c:GetChildren()) do
                    if t:IsA("Tool") and (t.Name:lower():gsub("[^%w]", "")) == want then n += 1 end
                end
            end
        end
        return n
    end
    A.countItem = countItem
    task.spawn(function()
        repeat task.wait(0.5) until LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Character
        task.wait(1.5)
        local stable, prev = 0, -1
        while stable < 2 do
            local n = countLucky()
            if n == prev then stable += 1 else stable, prev = 0, n end
            task.wait(0.5)
        end
        local last, lastChar = prev, LocalPlayer.Character
        lucky.count = prev
        while true do
            local n = countLucky()
            if LocalPlayer.Character ~= lastChar then
                lastChar = LocalPlayer.Character
                task.wait(3)
                n = countLucky()
                last = n
            end
            if n > last then
                local gain = n - last
                local skip = math.min(gain, A.boughtUncounted or 0)      -- bought in the shop, not farmed
                A.boughtUncounted = (A.boughtUncounted or 0) - skip
                gain -= skip
                if gain > 0 then
                    lucky.session += gain
                    lucky.total += gain
                    stats.luckyTotal = lucky.total
                    writeJSON(FILES.stats, stats)
                    if A.emit then pcall(A.emit, "pickup", { n = gain, have = n }) end
                end
            end
            last, lucky.count = n, n
            task.wait(1)
        end
    end)

    -- order queue written by the hub
    local function readQueue()
        local q = readJSON(FILES.queue)
        return type(q) == "table" and q or {}
    end
    local cache = { at = 0, pending = false }
    local function hasPending()
        if tick() - cache.at < 1 then return cache.pending end
        cache.at, cache.pending = tick(), false
        local keep = {}
        for _, o in ipairs(readQueue()) do
            local owes = (tonumber(o.trade_n) or 0) - (tonumber(o.traded) or 0) > 0
            if (tonumber(o.total_money) or 0) - (tonumber(o.dropped) or 0) > 0 or owes then cache.pending = true end
            if owes then keep[(tostring(o.item or "Lucky Arrow"):lower():gsub("[^%w]", ""))] = true end
        end
        A.keepQueue = keep                         -- autosell never sells what an order still has to get
        return cache.pending
    end
    local function saveProgress(orderId, fields)
        if type(fields) ~= "table" then fields = { dropped = fields } end      -- old call: money dropped
        local fresh = readQueue()
        for _, t in ipairs(fresh) do
            if tostring(t.order_id) == tostring(orderId) then
                for k, v in pairs(fields) do t[k] = v end
                writeJSON(FILES.queue, fresh)
                cache.at = 0
                return
            end
        end
    end

    -- status for the hub every 2 s
    task.spawn(function()
        while true do
            A.pending = hasPending()
            writeJSON(FILES.status, {
                account = ACCOUNT, money = getMoney() or -1, heartbeat = os.time(),
                busy = A.delivering, job = game.JobId, place_id = game.PlaceId, user_id = LocalPlayer.UserId,
                max_players = Players.MaxPlayers, pending = A.pending, players = #Players:GetPlayers(),
                mode = A.farming and "farm" or "deliver",
                lucky = lucky.count, lucky_session = lucky.session, lucky_total = lucky.total,
                joined = A.joinedList or {},
                timers = A.timers or {},
                alerts = A.alerts or {},
                can_trade = true,                       -- this script delivers Lucky Arrows by trade
                trades = A.trades or {},
                trade_log = A.tradeLog or {},
                autobuy = A.autobuy == true, autobuy_cap = A.autobuyCap or 9, shop_price = 75000,
                specs = A.specs or {},                  -- spec skins this bot owns (Halloween shop) → FunPay lots
            })
            task.wait(2)
        end
    end)

    -- smooth short tween steps toward a moving goal
    local function tweenTo(getGoal)
        local started = tick()
        while tick() - started < DLV.TIMEOUT do
            local hrp, goal = myHRP(), getGoal()
            if not hrp or not goal then return false end
            local offset = goal - hrp.Position
            local dist = offset.Magnitude
            if dist <= DLV.STOP then return true end
            local step = math.min(dist - DLV.STOP * 0.5, DLV.SPEED * DLV.SEGMENT)
            local nextPos = hrp.Position + offset.Unit * step
            local flat = Vector3.new(offset.X, 0, offset.Z)
            local look = flat.Magnitude > 0.1 and CFrame.lookAt(nextPos, nextPos + flat.Unit) or CFrame.new(nextPos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            local t = TweenService:Create(hrp, TweenInfo.new(math.max(0.03, step / DLV.SPEED), Enum.EasingStyle.Linear), { CFrame = look })
            t:Play()
            t.Completed:Wait()
        end
        return false
    end
    local function toPlayer(target)
        return tweenTo(function()
            local h = targetHRP(target)
            return h and (h.CFrame * CFrame.new(0, 0, 2)).Position
        end)
    end
    local function stayNear(target, seconds)
        local untilT = tick() + seconds
        while tick() < untilT do
            local hrp, thrp = myHRP(), targetHRP(target)
            if not hrp or not thrp then return end
            if (hrp.Position - thrp.Position).Magnitude > DLV.STOP + 2 then toPlayer(target) end
            hrp.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.15)
        end
    end
    local function strangersNear(target)
        local thrp = targetHRP(target)
        if not thrp then return 0 end
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p ~= target then
                local h = targetHRP(p)
                if h and (h.Position - thrp.Position).Magnitude < DLV.CLEAR_RADIUS then n += 1 end
            end
        end
        return n
    end
    local function findBuyer(name)
        name = name:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == name or p.DisplayName:lower() == name then return p end
        end
        return nil
    end

    -- 3D must be on while delivering (Graphics «No 3D Render» / black screen), otherwise the proof shot is empty
    local function refreshRender()
        if _G.__ChopaRefreshRender then pcall(_G.__ChopaRefreshRender) end
    end

    -- proof screenshot: a label with the order on screen, then the hub captures this Roblox window
    -- and sends it to the FunPay chat. The bot stands still until the hub has taken the picture.
    local function fmtMoney(n)
        return (tostring(math.floor(tonumber(n) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
    end
    local function proofTag(orderId, what)
        local ok, gui = pcall(function()
            local g = Instance.new("ScreenGui")
            g.Name = "ChopaProof"
            g.IgnoreGuiInset = true
            g.DisplayOrder = 999999
            g.ResetOnSpawn = false
            local t = Instance.new("TextLabel")
            t.AnchorPoint = Vector2.new(0.5, 0)
            t.Position = UDim2.new(0.5, 0, 0, 52)
            t.Size = UDim2.new(0, 0, 0, 34)
            t.AutomaticSize = Enum.AutomaticSize.X
            t.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
            t.BackgroundTransparency = 0.15
            t.Font = Enum.Font.GothamBold
            t.TextSize = 17
            t.TextColor3 = Color3.fromRGB(147, 197, 253)
            t.Text = string.format("  CHOPA  |  Order #%s  |  %s  |  %s  ",
                tostring(orderId), tostring(what), os.date("%Y-%m-%d %H:%M:%S"))
            t.Parent = g
            local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = t
            local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(96, 165, 250); st.Thickness = 1.5; st.Parent = t
            g.Parent = LocalPlayer:WaitForChild("PlayerGui")
            return g
        end)
        return ok and gui or nil
    end
    -- what: text on the label; info: {kind = "drop", amount = N} or {kind = "trade", lucky = N}
    local function proofShot(order, what, info)
        if not order.shot or not writefile or not isfile then return end
        local hidden = hideCheatGui()                    -- the menu must not be on the picture
        local tag
        pcall(function()
            tag = proofTag(order.order_id, what)
            task.wait(0.35)                              -- money on the ground / trade window drawn, menu gone
            local req = { order_id = tostring(order.order_id), buyer = tostring(order.buyer or ""),
                at = os.time(), user_id = LocalPlayer.UserId, job = game.JobId }
            for k, v in pairs(info or {}) do req[k] = v end
            writeJSON(FILES.shot, req)
            local t0 = tick()
            while tick() - t0 < 6 and isfile(FILES.shot) do task.wait(0.1) end   -- the hub deletes it after the shot
            if isfile(FILES.shot) then pcall(delfile, FILES.shot) end            -- hub not running
        end)
        if tag then pcall(function() tag:Destroy() end) end
        showCheatGui(hidden)                             -- the menu comes back right after the shot
    end

    -- ---- protection: the bot must not pick up the money it has just dropped ----
    A.alerts = A.alerts or {}
    local alertSeq = 0
    local function alert(text, fields)
        alertSeq += 1
        local a = { id = tostring(os.time()) .. "-" .. alertSeq, text = text }
        for k, v in pairs(fields or {}) do a[k] = v end
        table.insert(A.alerts, a)
        while #A.alerts > 5 do table.remove(A.alerts, 1) end
        warn("[Chopa] " .. text)
    end
    local function moveExact(goal, face)          -- one smooth move right onto the point
        local hrp = myHRP()
        if not hrp or not goal then return false end
        local dist = (goal - hrp.Position).Magnitude
        if dist < 0.5 then return true end
        local look = face and Vector3.new(face.X, goal.Y, face.Z) or nil
        local cf = (look and (look - goal).Magnitude > 0.1) and CFrame.lookAt(goal, look) or CFrame.new(goal)
        hrp.AssemblyLinearVelocity = Vector3.zero
        local t = TweenService:Create(hrp, TweenInfo.new(math.max(0.05, dist / DLV.SPEED), Enum.EasingStyle.Linear), { CFrame = cf })
        t:Play()
        t.Completed:Wait()
        return true
    end
    local function stepAway(dropPos, target)       -- back off from the drop, keep looking at the buyer
        local thrp = targetHRP(target)
        local from = thrp and thrp.Position or dropPos
        local dir = Vector3.new(dropPos.X - from.X, 0, dropPos.Z - from.Z)
        if dir.Magnitude < 0.5 then
            local hrp = myHRP()
            dir = hrp and Vector3.new(-hrp.CFrame.LookVector.X, 0, -hrp.CFrame.LookVector.Z) or Vector3.new(1, 0, 0)
        end
        if dir.Magnitude < 0.01 then dir = Vector3.new(1, 0, 0) end
        local goal = dropPos + dir.Unit * DLV.STEP_AWAY
        moveExact(goal, from)
        return goal
    end
    local function holdAt(pos)                     -- stay on the safe spot (no sliding back onto the money)
        local hrp = myHRP()
        if hrp and pos and (hrp.Position - pos).Magnitude > 1.5 then moveExact(pos) end
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
    end
    local function goHomeOver(home)                -- up → across → down: never walks over the drop
        local hrp = myHRP()
        if not hrp or not home then return end
        local up = Vector3.new(0, DLV.LIFT, 0)
        moveExact(hrp.Position + up)
        tweenTo(function() return home.Position + up end)
        moveExact(home.Position)
    end

    -- ================= TRADE DELIVERY (Lucky Arrows through the YBA trade window) =================
    -- Menu (bottom right) → Settings → «Enter a player's name below to trade with them» + Enter →
    -- the buyer accepts → CosmeticTrade window: put N Lucky Arrows (found by name, list scrolled to it) →
    -- proof screenshot → Confirm until «CONFIRMED!» → the buyer confirms → the HUD reloads →
    -- the arrows must have left the inventory. Money for the rest of the order is dropped after that.
    local PG = LocalPlayer:WaitForChild("PlayerGui")
    local GuiService = game:GetService("GuiService")
    local VIM
    pcall(function() VIM = game:GetService("VirtualInputManager") end)
    -- RETRY_GAP / REJOIN: the buyer reset, cancelled or rejoined → the trade is sent again 20 s later
    -- ACCEPT: how long the bot waits for the buyer to type the bot's nick; RESEND: the bot types his nick again
    local TRD = { ACCEPT = 90, RESEND = 15, FINISH = 75, RETRY_GAP = 20, REJOIN = 20 }
    local SHOP = { PRICE = 75000, ITEM = "1x Lucky Arrow" }

    local function child(root, ...)
        local o = root
        for _, n in ipairs({ ... }) do
            if not o then return nil end
            o = o:FindFirstChild(n)
        end
        return o
    end
    local function visibleDeep(obj)
        if not obj or not obj.Parent then return false end
        local p = obj
        while p and p ~= PG and p ~= game do
            if p:IsA("GuiObject") and not p.Visible then return false end
            if p:IsA("LayerCollector") and not p.Enabled then return false end
            p = p.Parent
        end
        return true
    end
    local function waitFor(fn, timeout, step)
        local t0 = tick()
        while tick() - t0 < timeout do
            local ok, r = pcall(fn)
            if ok and r then return r end
            task.wait(step or 0.2)
        end
        return nil
    end
    local function guiCentre(obj)
        local pos, s = obj.AbsolutePosition, obj.AbsoluteSize
        local x, y = pos.X + s.X / 2, pos.Y + s.Y / 2
        local layer = obj:FindFirstAncestorWhichIsA("LayerCollector")
        if layer and layer:IsA("ScreenGui") and not layer.IgnoreGuiInset then
            local ok, ins = pcall(function() return GuiService:GetGuiInset() end)
            if ok and ins then y += ins.Y end
        end
        return math.floor(x), math.floor(y)
    end
    -- press a game button: its own click handlers (no mouse needed), else a real mouse click
    local function pressGui(btn)
        if not btn then return false end
        local x, y = guiCentre(btn)
        if getconnections then
            for _, name in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down", "MouseButton1Up" }) do
                local ok, list = pcall(getconnections, btn[name])
                if ok and list and #list > 0 then
                    local fired = false
                    for _, c in ipairs(list) do
                        local mouse = name == "MouseButton1Down" or name == "MouseButton1Up"
                        local done = pcall(function() if mouse then c:Fire(x, y) else c:Fire() end end)
                        if not done and c.Function then
                            done = pcall(c.Function, mouse and x or nil, mouse and y or nil)
                        end
                        fired = fired or done
                    end
                    if fired then return true end
                end
            end
        end
        if firesignal then
            for _, name in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
                if pcall(firesignal, btn[name]) then return true end
            end
        end
        if VIM then
            return (pcall(function()
                VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
            end))
        end
        return false
    end
    -- one way of pressing a button; the trade checks the result and tries the next way if nothing happened
    local function pressWith(btn, method)
        if not btn then return false end
        local x, y = guiCentre(btn)
        if method == "conn" then
            if not getconnections then return false end
            local fired = false
            for _, name in ipairs({ "MouseButton1Click", "Activated", "MouseButton1Down" }) do
                local ok, list = pcall(getconnections, btn[name])
                if ok and list and #list > 0 then
                    for _, c in ipairs(list) do
                        local mouse = name == "MouseButton1Down"
                        local done = pcall(function() if mouse then c:Fire(x, y) else c:Fire() end end)
                        if not done and c.Function then done = pcall(c.Function, mouse and x or nil, mouse and y or nil) end
                        fired = fired or done
                    end
                    if fired then return true end
                end
            end
            return false
        elseif method == "firesignal" then
            if not firesignal then return false end
            for _, name in ipairs({ "MouseButton1Click", "Activated", "MouseButton1Down" }) do
                local ok, list = pcall(getconnections or function() return { 1 } end, btn[name])
                if (not ok) or (list and #list > 0) then
                    if pcall(firesignal, btn[name]) then return true end
                end
            end
            return false
        elseif method == "mouse" then
            if not VIM then return false end
            return (pcall(function()
                VIM:SendMouseMoveEvent(x, y, game)
                task.wait(0.05)
                VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
                task.wait(0.06)
                VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
            end))
        end
        return false
    end
    local PRESS_METHODS = { "conn", "firesignal", "mouse" }
    -- presses until check() becomes true; the way that worked is used first next time
    local function pressUntil(btn, check, wait)
        local order = {}
        if A.clickMethod then table.insert(order, A.clickMethod) end
        for _, m in ipairs(PRESS_METHODS) do if m ~= A.clickMethod then table.insert(order, m) end end
        for _, m in ipairs(order) do
            local sent = pressWith(btn, m)
            local okResult = sent and waitFor(check, wait or 2.5, 0.1)
            A.tlog(string.format("press %s via %s: sent=%s result=%s", btn and btn.Name or "?", m, tostring(sent), tostring(okResult ~= nil and okResult ~= false)))
            if okResult then A.clickMethod = m return true, m end
        end
        return false
    end

    -- trade log: file chopa_trade_log.txt + the hub journal (via status)
    A.tradeLog, A.tradeLogSeq = A.tradeLog or {}, A.tradeLogSeq or 0
    function A.tlog(text)
        local line = os.date("%H:%M:%S ") .. tostring(text)
        A.tradeLogSeq += 1
        table.insert(A.tradeLog, { id = tostring(os.time()) .. "-" .. A.tradeLogSeq, text = tostring(text) })
        while #A.tradeLog > 25 do table.remove(A.tradeLog, 1) end
        pcall(function()
            if appendfile and isfile and isfile("chopa_trade_log.txt") then appendfile("chopa_trade_log.txt", line .. "\n")
            elseif writefile then writefile("chopa_trade_log.txt", line .. "\n") end
        end)
        print("[Chopa trade] " .. line)
    end

    local function qty(label)                      -- "x3" -> 3
        return label and tonumber(tostring(label.Text or ""):match("(%d+)")) or 0
    end

    -- ---- the YBA trade window (PlayerGui.CosmeticTrade.Main) ----
    local function tradeMain() return child(PG, "CosmeticTrade", "Main") end
    local function tradeOpen() return visibleDeep(tradeMain()) end
    local TRADE_ITEM = "Lucky Arrow"               -- the item of the order being traded (Lucky Arrow / a spec skin)
    local function nameKey(s) return (tostring(s or ""):lower():gsub("[^%w]", "")) end
    local function isLucky(item)
        local title = child(item, "Square", "Title")
        local want = nameKey(TRADE_ITEM)
        return nameKey(item.Name) == want or (title ~= nil and nameKey(title.Text) == want)
    end
    local function findLuckyItem()
        local sf = child(tradeMain(), "Items", "ScrollingFrame")
        if not sf then return nil, nil end
        for _, it in ipairs(sf:GetChildren()) do
            if isLucky(it) then return it, sf end
        end
        return nil, sf
    end
    local function offered()                       -- how many of the item are in our «OFFERING» column
        local sf = child(tradeMain(), "Offering", "ScrollingFrame")
        if not sf then return 0 end
        for _, it in ipairs(sf:GetChildren()) do
            if isLucky(it) then
                local q = child(it, "Square", "Quantity")
                return q and qty(q) or 1
            end
        end
        return 0
    end
    local function scrollTo(item, sf)              -- the arrow can be in any slot: bring it into view
        pcall(function()
            local rel = item.AbsolutePosition.Y - sf.AbsolutePosition.Y + sf.CanvasPosition.Y
            local y = math.max(0, rel - (sf.AbsoluteSize.Y - item.AbsoluteSize.Y) / 2)
            sf.CanvasPosition = Vector2.new(sf.CanvasPosition.X, y)
        end)
    end
    local function confirmLabel()
        local l = child(tradeMain(), "Confirm", "TextLabel")
        return l and tostring(l.Text or ""):upper() or ""
    end
    local function cancelTrade()
        if tradeOpen() then
            pressGui(child(tradeMain(), "Cancel"))
            waitFor(function() return not tradeOpen() end, 5)
        end
    end

    -- ---- menu → settings → trade box ----
    local function menuOpen() return visibleDeep(child(PG, "HUD", "Main", "ToggleSettings")) end
    local function settingsOpen() return visibleDeep(child(PG, "HUD", "Main", "Frames", "Settings")) end
    local function closeMenus()
        if settingsOpen() then
            pressGui(child(PG, "HUD", "Main", "Frames", "Settings", "HUDBack"))
            waitFor(function() return not settingsOpen() end, 0.6, 0.05)
        end
        if menuOpen() then
            pressGui(child(PG, "HUD", "Main", "ToggleHUD"))
            waitFor(function() return not menuOpen() end, 0.6, 0.05)
        end
    end
    local function sendTradeRequest(name)
        if not settingsOpen() then
            if not menuOpen() then
                pressGui(child(PG, "HUD", "Main", "ToggleHUD"))
                waitFor(menuOpen, 1, 0.05)
            end
            pressGui(child(PG, "HUD", "Main", "ToggleSettings"))
            waitFor(settingsOpen, 1, 0.05)
        end
        local box = child(PG, "HUD", "Main", "Frames", "Settings", "TradeTextBox")
        if not box then closeMenus() return false, "trade box not found" end
        box.Text = name
        local sent = false
        if getconnections then
            local ok, list = pcall(getconnections, box.FocusLost)
            if ok and list then
                for _, c in ipairs(list) do
                    local done = pcall(function() c:Fire(true, nil) end)
                    if not done and c.Function then done = pcall(c.Function, true, nil) end
                    sent = sent or done
                end
            end
        end
        if not sent and firesignal then sent = pcall(firesignal, box.FocusLost, true) end
        if not sent and VIM then                   -- type it like a player: focus + Enter
            sent = pcall(function()
                box:CaptureFocus()
                box.Text = name
                task.wait(0.15)
                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                task.wait(0.05)
                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            end)
        end
        task.spawn(function() task.wait(0.15) closeMenus() end)   -- closes the menu while the trade is waited for
        return sent, sent and nil or "Enter could not be pressed"
    end

    -- after a trade YBA rebuilds the HUD: wait for it and for a stable inventory
    local function waitHudBack()
        task.wait(0.8)
        waitFor(function()
            local m = child(PG, "HUD", "Main", "DropMoney", "Money")
            return m and visibleDeep(m) and tostring(m.Text):match("%d") ~= nil
        end, 12, 0.2)
        task.wait(0.5)
        local prev, stable, t0 = -1, 0, tick()
        while stable < 2 and tick() - t0 < 6 do
            local n = countLucky()
            if n == prev then stable += 1 else stable, prev = 0, n end
            task.wait(0.3)
        end
    end

    -- trade state for the hub (chat messages / order status): sent, open, confirm, done, timeout, …
    A.trades = A.trades or {}
    local function setTrade(oid, state, extra)
        local t = A.trades[oid] or { tries = 0 }
        t.state, t.at = state, os.time()
        for k, v in pairs(extra or {}) do t[k] = v end
        A.trades[oid] = t
        return t
    end

    -- returns "done"|"partial"|"timeout"|"left"|"wrong"|"cancelled"|"add_failed"|"short"|"error", given
    local function headerIsBuyer(target)
        local header = child(tradeMain(), "Header", "TextLabel")
        local h = header and tostring(header.Text or ""):lower() or ""
        return h == "" or h:find(target.Name:lower(), 1, true) ~= nil
    end

    local function doTradeInner(order, target, n, buyerName)
        local oid = tostring(order.order_id)
        TRADE_ITEM = tostring(order.item or "Lucky Arrow")
        local isArrow = TRADE_ITEM:lower() == "lucky arrow"
        -- Lucky Arrows and Jack's items are Tools: counted in the backpack before and after the trade
        local toolsBefore = (not isArrow) and countItem(TRADE_ITEM) or 0
        local before = isArrow and countLucky() or (toolsBefore > 0 and toolsBefore or n)
        if before < n then A.tlog(string.format("only %d %s in the backpack, need %d", before, TRADE_ITEM, n)) return "short", 0 end
        local cancelledByUs, botConfirmed = false, false
        if tradeOpen() and not headerIsBuyer(target) then cancelTrade() end
        local char0 = target.Character
        local function gone()                       -- the buyer left the server or reset his character
            if not target.Parent then return "left" end
            if target.Character ~= char0 then return "reset" end
            return nil
        end
        local tr = A.trades[oid] or {}
        local opened = tradeOpen() and "open" or nil
        -- YBA: the trade opens when BOTH players typed each other's nick in the trade box.
        -- The bot types the buyer's nick (again every RESEND s while waiting); the chat tells the buyer
        -- to type the bot's nick.
        if not opened then
            tr = setTrade(oid, "sent", { n = n })
            tr.tries = (tr.tries or 0) + 1
            local ok, why = sendTradeRequest(target.Name)
            A.tlog(string.format("order #%s: typed %s in the trade box (%d %s, have %d): %s", oid, target.Name,
                n, TRADE_ITEM, before, ok and "ok" or ("FAILED " .. tostring(why))))
            if not ok then setTrade(oid, "error", { why = why }) return "error", 0 end
            local lastSend = tick()
            opened = waitFor(function()
                local g = gone()
                if g then return g end
                if tradeOpen() then return "open" end
                if tick() - lastSend >= TRD.RESEND then           -- type his nick again (the buyer may be late)
                    lastSend = tick()
                    sendTradeRequest(target.Name)
                end
                return nil
            end, TRD.ACCEPT, 0.15)
        end
        if opened ~= "open" then
            local st = (opened == "left" or opened == "reset") and opened or "timeout"
            A.tlog("trade not opened: " .. st)
            if tradeOpen() then cancelTrade() end
            setTrade(oid, st)
            return st, 0
        end
        -- 2) the window must be a trade with THIS buyer («Trading with Nick»)
        local header = child(tradeMain(), "Header", "TextLabel")
        local htext = header and tostring(header.Text or ""):lower() or ""
        if htext ~= "" and not htext:find(target.Name:lower(), 1, true) then
            cancelTrade()
            setTrade(oid, "wrong")
            return "wrong", 0
        end
        setTrade(oid, "open")
        A.tlog("trade window open: " .. (htext ~= "" and htext or "(no header)"))
        -- 3) put exactly n Lucky Arrows (each click adds one; checked in the OFFERING column)
        -- the item list is filled a moment after the window opens
        local found = waitFor(function() return findLuckyItem() end, 6, 0.1)
        task.wait(0.25)
        if not found then
            local _, sf = findLuckyItem()
            local names = {}
            for _, it in ipairs(sf and sf:GetChildren() or {}) do table.insert(names, it.Name) end
            A.tlog(TRADE_ITEM .. " NOT found in ITEMS. Items: " .. table.concat(names, ", "))
        end
        if not isArrow then                          -- the real number of this skin → correct the bot's count
            local have = 0
            local q = found and child(found, "Square", "Quantity")
            if found then have = q and qty(q) or 1 end
            if have < n then
                A.tlog(string.format("only %d %s in the trade window, need %d — cancel", have, TRADE_ITEM, n))
                cancelTrade()
                setTrade(oid, "short", { have = have })
                waitHudBack()
                return "short", 0
            end
            before = have
        end
        local clicks, fails = 0, 0
        while tradeOpen() and not gone() and offered() < n and clicks < n + 6 and fails < 3 do
            clicks += 1
            local item, sf = findLuckyItem()
            if not item then
                task.wait(0.5)
                fails += 1
            else
                local q = child(item, "Square", "Quantity")
                if q and qty(q) <= 0 then A.tlog("ITEMS shows " .. tostring(q.Text) .. " " .. TRADE_ITEM .. " — nothing to add") break end
                scrollTo(item, sf)
                task.wait(0.05)
                local was = offered()
                local title = child(item, "Square", "Title") or item:FindFirstChildWhichIsA("GuiButton", true)
                local ok, how = pressUntil(title, function() return offered() ~= was end, 2.5)
                A.tlog(string.format("add %s %d/%d: %s (offering x%d, items %s)", TRADE_ITEM, was + 1, n,
                    ok and ("ok via " .. how) or "NOT ADDED by any way", offered(), q and tostring(q.Text) or "?"))
                if not ok then fails += 1 end
            end
        end
        if gone() then
            cancelTrade()
            local st = gone()
            setTrade(oid, st)
            waitHudBack()
            return st, 0
        end
        if not tradeOpen() then setTrade(oid, "cancelled") waitHudBack() return "cancelled", 0 end
        if offered() ~= n then
            local got = offered()
            A.tlog(string.format("could not put %d %s (offering x%d) — cancel, retry in %d s", n, TRADE_ITEM, got, TRD.RETRY_GAP))
            cancelTrade()
            setTrade(oid, "add_failed", { offered = got })
            waitHudBack()
            return "add_failed", 0
        end
        -- 4) proof screenshot while the trade window is open (arrows in OFFERING, «Trading with Nick»)
        setTrade(oid, "confirm")
        proofShot(order, string.format("trade %d %s to %s", n, TRADE_ITEM, buyerName), { kind = "trade", lucky = n, item = TRADE_ITEM })
        -- 5) Confirm → «ARE YOU SURE?» → «CONFIRMED!», then wait for the buyer to confirm
        local t0 = tick()
        local abortedBy
        local confirmLogged = false
        while tradeOpen() and tick() - t0 < TRD.FINISH do
            if gone() == "reset" then abortedBy = "reset" cancelledByUs = true cancelTrade() break end
            if offered() ~= n then A.tlog("offering changed to x" .. offered() .. " — cancel") cancelledByUs = true cancelTrade() break end
            local label = confirmLabel()
            if not label:find("CONFIRMED", 1, true) then
                local ok, how = pressUntil(child(tradeMain(), "Confirm"), function()
                    return not tradeOpen() or confirmLabel() ~= label
                end, 2)
                A.tlog(string.format("confirm «%s» → «%s» %s", label, confirmLabel(), ok and ("via " .. how) or "NO REACTION"))
                if not ok then task.wait(1) end
            else
                if not confirmLogged then A.tlog("bot CONFIRMED, waiting for the buyer") confirmLogged = true end
                botConfirmed = true
                task.wait(0.3)
            end
        end
        if tradeOpen() then cancelledByUs = true cancelTrade() end   -- the buyer did not confirm in time
        waitHudBack()
        if not isArrow and toolsBefore > 0 then
            -- 6) a skin (a Tool like the arrows): it must have left the backpack (count read once it is stable)
            local prevN, stableN, t1 = -1, 0, tick()
            while stableN < 2 and tick() - t1 < 4 do
                local c = countItem(TRADE_ITEM)
                if c == prevN then stableN += 1 else stableN, prevN = 0, c end
                task.wait(0.3)
            end
            local left = toolsBefore - countItem(TRADE_ITEM)
            A.tlog(string.format("after trade: had %d %s, now %d → %s", toolsBefore, TRADE_ITEM, toolsBefore - left,
                left >= n and "DONE" or (left > 0 and "partial" or "nothing left the backpack")))
            if left >= n then setTrade(oid, "done", { gone = n }) return "done", n end
            if left > 0 then setTrade(oid, "partial", { gone = left }) return "partial", left end
            setTrade(oid, abortedBy or "cancelled")
            return abortedBy or "cancelled", 0
        end
        if not isArrow then
            -- 6) a skin that is not a Tool: the trade went through when both confirmed and the window closed by itself
            if botConfirmed and not cancelledByUs and not abortedBy then
                if A.specAdd then pcall(A.specAdd, TRADE_ITEM, -n) end
                A.tlog(string.format("after trade: %d %s given → DONE", n, TRADE_ITEM))
                setTrade(oid, "done", { gone = n })
                return "done", n
            end
            setTrade(oid, abortedBy or "cancelled")
            return abortedBy or "cancelled", 0
        end
        -- 6) the arrows must have left the inventory
        local gone = before - countLucky()
        A.tlog(string.format("after trade: had %d, now %d → %s", before, before - gone,
            gone >= n and "DONE" or (gone > 0 and "partial" or "nothing left the inventory")))
        if gone >= n then setTrade(oid, "done", { gone = n }) return "done", n end
        if gone > 0 then setTrade(oid, "partial", { gone = gone }) return "partial", gone end
        setTrade(oid, abortedBy or "cancelled")
        return abortedBy or "cancelled", 0
    end
    local function doTrade(order, target, n, buyerName)
        A.trading = true                           -- no auto buy while the arrow count is being checked
        local ok, res, got = pcall(doTradeInner, order, target, n, buyerName)
        A.trading = false
        if not ok then
            pcall(cancelTrade)
            setTrade(tostring(order.order_id), "error", { why = tostring(res) })
            return "error", 0
        end
        return res, got
    end

    -- ================= AUTO BUY LUCKY ARROWS (default ON) =================
    -- Money → Lucky Arrows in the shop ($75,000 each) while the bot is idle, up to the kept amount.
    A.autobuy = _G.__ChopaHasConfig == true            -- new user (no config): off
    pcall(function() if isfile and isfile("chopa_autobuy.txt") then A.autobuy = readfile("chopa_autobuy.txt") == "1" end end)
    A.autobuyCap = 9
    pcall(function()
        if isfile and isfile("chopa_autobuy_cap.txt") then
            A.autobuyCap = math.clamp(tonumber(readfile("chopa_autobuy_cap.txt")) or 9, 1, 50)
        end
    end)
    local function buyOne()
        local char = LocalPlayer.Character
        local ev = char and char:FindFirstChild("RemoteEvent")
        local m0 = getMoney()
        if not ev or not m0 or m0 < SHOP.PRICE then return false end
        local n0 = countLucky()
        A.boughtUncounted = (A.boughtUncounted or 0) + 1
        pcall(function() ev:FireServer("PurchaseShopItem", { ItemName = SHOP.ITEM }) end)
        local ok = waitFor(function() return countLucky() > n0 end, 4, 0.2)
        if not ok then A.boughtUncounted = math.max(0, (A.boughtUncounted or 1) - 1) end
        if ok and A.emit then pcall(A.emit, "buy", { n = 1, have = countLucky(), money = getMoney() }) end
        return ok ~= nil
    end
    local function buyArrows(count, keepMoney)     -- buys up to `count`, never below `keepMoney`
        local got = 0
        for _ = 1, count do
            local m = getMoney()
            if not m or m - SHOP.PRICE < (keepMoney or 0) then break end
            if not buyOne() then break end
            got += 1
            task.wait(0.4)
        end
        return got
    end
    A.buyArrows = buyArrows
    -- Chopa: buys all the time (also while an order is waiting), stops only during the delivery itself.
    -- Money promised to buyers in waiting orders is never spent; arrows those orders need may go above the cap.
    task.spawn(function()
        task.wait(5)
        local fails = 0
        while true do
            local waitS = 1
            if A.autobuy and not A.delivering and not A.trading and LocalPlayer.Character then
                local reserve, needArrows = 0, 0
                if A.pending then
                    for _, o in ipairs(readQueue()) do
                        reserve += math.max(0, (tonumber(o.total_money) or 0) - (tonumber(o.dropped) or 0))
                        needArrows += math.max(0, (tonumber(o.trade_n) or 0) - (tonumber(o.traded) or 0))
                    end
                end
                local m = getMoney()
                local target = math.max(A.autobuyCap or 9, needArrows)
                if m and m - SHOP.PRICE >= reserve and countLucky() < target then
                    if buyOne() then
                        fails, waitS = 0, 0.3
                    else
                        fails += 1
                        if fails >= 3 then
                            alert("Auto buy: buying a Lucky Arrow does not work — retrying in 30 s",
                                { kind = "autobuy_failed" })
                            fails, waitS = 0, 30
                        end
                    end
                end
            end
            task.wait(waitS)
        end
    end)

    -- trade part of an order: buy missing arrows, else move them to money (hub tells the buyer), then trade
    A.cool = A.cool or {}
    local function tradePart(order, target, buyerName, tradeLeft, left)
        local oid = tostring(order.order_id)
        local isArrow = tostring(order.item or "Lucky Arrow"):lower() == "lucky arrow"
        local have = isArrow and countLucky() or tradeLeft   -- nothing is bought during a delivery: the arrows
                                                          -- the bot has go by trade, the rest becomes money
        if have < tradeLeft then
            local short = tradeLeft - have
            local price = tonumber(order.price) or SHOP.PRICE
            local bal = getMoney()
            if bal and bal >= left + short * price then
                order.trade_n = (tonumber(order.trade_n) or 0) - short
                order.total_money = (order.total_money or 0) + short * price
                saveProgress(order.order_id, { trade_n = order.trade_n, total_money = order.total_money,
                    plan_changed = os.time() })
                alert(string.format("Order #%s: only %d Lucky Arrow — %d by trade + $%s money", oid, have,
                    order.trade_n - (tonumber(order.traded) or 0), fmtMoney(order.total_money)),
                    { kind = "plan_changed", order = oid, trade = order.trade_n, amount = order.total_money })
                tradeLeft, left = have, left + short * price
            else
                alert(string.format("Order #%s: not enough Lucky Arrows (%d/%d) and money", oid, have, tradeLeft),
                    { kind = "short", order = oid, n = tradeLeft, have = have })
                A.cool[oid] = tick() + 60
                return tradeLeft, left, false
            end
        end
        if tradeLeft > 0 then
            local res, got = doTrade(order, target, tradeLeft, buyerName)
            if (got or 0) > 0 then
                order.traded = (tonumber(order.traded) or 0) + got
                saveProgress(order.order_id, { traded = order.traded })
                if A.emit then pcall(A.emit, "trade", { order = oid, n = got, buyer = buyerName, item = order.item }) end
            end
            if res ~= "done" then
                A.cool[oid] = tick() + TRD.RETRY_GAP
                alert(string.format("Order #%s: trade %s", oid, res), { kind = "trade_" .. res, order = oid, n = tradeLeft })
            end
            tradeLeft = math.max(0, (tonumber(order.trade_n) or 0) - (tonumber(order.traded) or 0))
            return tradeLeft, left, res == "done"
        end
        return tradeLeft, left, true
    end

    -- delivery loop
    task.spawn(function()
        while task.wait(1) do
            local queue = readQueue()
            if A.knownOrders == nil then              -- orders already queued at start are not «new»
                A.knownOrders = {}
                for _, o in ipairs(queue) do A.knownOrders[tostring(o.order_id)] = true end
            else
                for _, o in ipairs(queue) do
                    local id = tostring(o.order_id)
                    if not A.knownOrders[id] then
                        A.knownOrders[id] = true
                        if A.emit then pcall(A.emit, "paid", { order = id, count = o.count, item = o.item,
                            trade = o.trade_n, money = o.total_money, buyer = o.buyer }) end
                    end
                end
            end
            A.seen = A.seen or {}
            local inQueue = {}
            for _, o in ipairs(queue) do inQueue[tostring(o.order_id)] = true end
            for id in pairs(A.seen) do if not inQueue[id] then A.seen[id] = nil end end
            for _, order in ipairs(queue) do
              -- Chopa: one order's error must not kill the delivery loop (that left the bot on
              -- «Order waiting» forever with «delivering» stuck on)
              local okOrder, errOrder = pcall(function()
                local buyerName = tostring(order.buyer or "")
                local left = math.max(0, (order.total_money or 0) - (order.dropped or 0))
                local tradeLeft = math.max(0, (tonumber(order.trade_n) or 0) - (tonumber(order.traded) or 0))
                local target = (left > 0 or tradeLeft > 0) and buyerName ~= "" and findBuyer(buyerName)
                -- the buyer is counted from the moment he is seen on this server for THIS order;
                -- money is dropped only after the timer (order.drop_delay from the hub, default 60 s)
                local oid = tostring(order.order_id)
                local delay = math.max(tonumber(order.drop_delay) or DLV.JOIN_DELAY, DLV.LOAD)   -- ≥2 s: he is loaded
                A.everReady = A.everReady or {}
                if A.everReady[oid] then delay = math.min(delay, TRD.REJOIN) end   -- buyer came back: 20 s
                -- the buyer reset his character → wait 20 s before the next trade
                A.charOf = A.charOf or {}
                if target then
                    local ch = target.Character
                    if A.charOf[oid] ~= nil and ch ~= A.charOf[oid] then
                        A.cool[oid] = math.max(A.cool[oid] or 0, tick() + TRD.REJOIN)
                    end
                    A.charOf[oid] = ch or false
                else
                    A.charOf[oid] = nil
                end
                if target then
                    A.seen[oid] = A.seen[oid] or tick()
                else
                    A.seen[oid] = nil
                end
                local list = {}
                for id in pairs(A.seen) do table.insert(list, id) end
                A.joinedList = list
                A.timers = A.timers or {}
                for id in pairs(A.timers) do if not A.seen[id] then A.timers[id] = nil end end
                if A.seen[oid] then A.timers[oid] = math.max(0, math.ceil(delay - (tick() - A.seen[oid]))) end
                local ready = target and A.seen[oid] and tick() - A.seen[oid] >= delay and tick() >= (A.cool[oid] or 0)
                    and target.Character and targetHRP(target) ~= nil           -- he is really in the game
                if ready then A.everReady[oid] = true end
                -- 1) Lucky Arrows by trade first
                if ready and tradeLeft > 0 then
                    A.delivering = true
                    refreshRender()
                    local hiddenMenu = hideCheatGui()        -- the cheat menu is hidden for the whole delivery
                    local okTrade
                    local okRun, e1, e2, e3 = pcall(tradePart, order, target, buyerName, tradeLeft, left)
                    if okRun then tradeLeft, left, okTrade = e1, e2, e3 else warn("[Chopa] trade: " .. tostring(e1)) end
                    if not (okRun and okTrade and left > 0) then showCheatGui(hiddenMenu) else A.menuHidden = hiddenMenu end
                    A.delivering = false
                    refreshRender()
                    if not okTrade then ready = false end
                    task.wait(1)
                end
                -- 2) then the money for the rest of the order
                if ready and tradeLeft == 0 and left > 0 and target.Parent and targetHRP(target) and myHRP() then
                    local bal = getMoney()
                    if bal and bal < left then
                        print(string.format("[Chopa] Not enough money: $%d < $%d", bal, left))
                    else
                        A.delivering = true
                        refreshRender()
                        local hiddenMenu = A.menuHidden or hideCheatGui()   -- still hidden after the trade part
                        A.menuHidden = nil
                        task.wait(1.5)                 -- let the farm put the character down
                        local home = myHRP() and myHRP().CFrame
                        if home and toPlayer(target) then
                            stayNear(target, DLV.ANCHOR)
                            local waitUntil = tick() + DLV.CLEAR_WAIT
                            while strangersNear(target) > 0 and tick() < waitUntil do stayNear(target, 0.5) end
                            local remote = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("RemoteEvent")
                            A.redrops = A.redrops or {}
                            local tries = A.redrops[oid] or { n = 0, at = 0 }
                            if remote and tries.n >= DLV.MAX_REDROPS and tick() - tries.at < 60 then
                                remote = nil                    -- several failed drops in a row: pause a minute
                            end
                            if remote then
                                local before = getMoney()
                                local dropPos = myHRP() and myHRP().Position
                                remote:FireServer("DropMoney", left)
                                print(string.format("[Chopa] Dropped $%d for %s", left, buyerName))
                                -- 1) step back at once: the money stays between the bot and the buyer
                                local safe = dropPos and stepAway(dropPos, target)
                                proofShot(order, string.format("dropped $%s to %s", fmtMoney(left), buyerName),
                                    { kind = "drop", amount = left })
                                -- 2) watch the balance: it must go down and stay down
                                local wentDown, cameBack = false, false
                                local t0 = tick()
                                while tick() - t0 < DLV.SETTLE do
                                    local m = getMoney()
                                    if before and m then
                                        if m <= before - math.floor(left * 0.99) then wentDown = true end
                                        if wentDown and m >= before - math.floor(left * 0.01) then cameBack = true break end
                                    end
                                    holdAt(safe)
                                    task.wait(0.2)
                                end
                                if before and not wentDown then
                                    local m = getMoney()
                                    wentDown = m ~= nil and m <= before - math.floor(left * 0.99)
                                end
                                if cameBack or (before and not wentDown) then
                                    tries.n, tries.at = tries.n + 1, tick()
                                    A.redrops[oid] = tries
                                    alert(string.format("Order #%s: %s — dropping again (try %d/%d)", oid,
                                        cameBack and "the bot picked its own money back up" or "the money did not leave the balance",
                                        tries.n, DLV.MAX_REDROPS),
                                        { kind = cameBack and "self_pickup" or "not_left", order = oid,
                                          n = tries.n, max = DLV.MAX_REDROPS, amount = left })
                                else
                                    A.redrops[oid] = nil
                                    order.dropped = (order.dropped or 0) + left
                                    saveProgress(order.order_id, order.dropped)
                                    if A.emit then pcall(A.emit, "drop", { order = oid, amount = left, buyer = buyerName }) end
                                end
                            end
                        end
                        if home then goHomeOver(home) end
                        showCheatGui(hiddenMenu)        -- the menu comes back after the delivery
                        A.delivering = false
                        refreshRender()
                        task.wait(1)
                    end
                end
                -- the money part did not start right after the trade (buyer left, no money…): menu back
                if A.menuHidden and not A.delivering then
                    showCheatGui(A.menuHidden)
                    A.menuHidden = nil
                end
              end)
              if not okOrder then
                  warn("[Chopa] delivery error, order #" .. tostring(order.order_id) .. ": " .. tostring(errOrder))
                  A.delivering = false
                  if A.menuHidden then pcall(showCheatGui, A.menuHidden) A.menuHidden = nil end
                  A.cool = A.cool or {}
                  A.cool[tostring(order.order_id)] = tick() + 10      -- next try of this order in 10 s
                  pcall(refreshRender)
              end
            end
        end
    end)
    print("[Chopa] Delivery agent started for @" .. ACCOUNT)
end
task.spawn(function()
    local ok, err = pcall(chopaDeliveryAgent)
    if not ok then warn("[Chopa] Delivery agent failed: " .. tostring(err)) end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local PhysicsService = game:GetService("PhysicsService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Chopa: after a server hop / rejoin the script is re-run from the local file (not from a remote URL)
local METHIONSH_RAW_URL = "auto_trader.lua"
local MethionSH_Env = type(getgenv) == "function" and getgenv() or _G
local SH_AUTOSTART = MethionSH_Env.__MethionSHAutoStart == true
if SH_AUTOSTART then MethionSH_Env.__MethionSHAutoStart = nil end

local AIRFLOW_LIBRARY_URL = "https://raw.githubusercontent.com/Methions/modf/refs/heads/main/par"

-- Chopa: download cache. The menu library and its two icon packs were downloaded on every start
-- (after every hop / rejoin). Now the saved copy is used at once and a fresh copy is downloaded in the
-- background for the next start. A broken / too small copy is ignored and downloaded again.
local function chopaCachedGet(url, file, mustContain)
    local cached
    pcall(function() if isfile and isfile(file) then cached = readfile(file) end end)
    local valid = type(cached) == "string" and #cached > 2000
        and (not mustContain or cached:find(mustContain, 1, true) ~= nil)
    local function save(src)
        if type(src) == "string" and #src > 2000 and type(writefile) == "function"
            and (not mustContain or src:find(mustContain, 1, true)) then
            pcall(writefile, file, src)
        end
    end
    if valid then
        task.spawn(function()
            local ok, src = pcall(function() return game:HttpGet(url) end)
            if ok then save(src) end
        end)
        return cached
    end
    local src = game:HttpGet(url)
    save(src)
    return src
end
pcall(function()
    local genv = type(getgenv) == "function" and getgenv() or nil
    if genv then genv.__ChopaCachedGet = chopaCachedGet end
end)
_G.__ChopaCachedGet = chopaCachedGet
local libraryOk, AirflowLibrary = pcall(function()
    local source = chopaCachedGet(AIRFLOW_LIBRARY_URL, "chopa_cache_airflow.lua", "return Library")
    -- icon packs through the same cache
    local cachedGetCode = "((getgenv and getgenv().__ChopaCachedGet) or _G.__ChopaCachedGet or function(u) return game:HttpGet(u) end)"
    source = source:gsub('game:HttpGet%("https://raw%.githubusercontent%.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons%.lua"%)',
        function() return cachedGetCode .. '("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua", "chopa_cache_icons_lucide.lua")' end)
    source = source:gsub("game:HttpGet%(NAJA_ICON_URL%)",
        function() return cachedGetCode .. '(NAJA_ICON_URL, "chopa_cache_icons_naja.lua")' end)
    assert(type(source) == "string" and #source > 0, "The Airflow library returned an empty response")

    if not source:find("function Window:_revealCards", 1, true)
        and not source:find("function Window._revealCards", 1, true) then
        local fallback = [[
if type(Window) == "table" and type(Window._revealCards) ~= "function" then
    function Window:_revealCards(tab, delay)
        if type(tab) ~= "table" or not tab.List then return end
        local list = tab.List
        pcall(function() list.CanvasPosition = Vector2.new(0, 0) end)
        for _, item in ipairs(list:GetChildren()) do
            if item:IsA("GuiObject") then
                item.Visible = true
                local scale = item:FindFirstChildOfClass("UIScale")
                if scale then scale.Scale = 1 end
            end
        end
    end
end
]]
        local patched, count = source:gsub("return%s+Library%s*$", fallback .. "\nreturn Library")
        if count > 0 then source = patched end
    end

    if not source:find("AF_ROBUST_VIEWPORT_PAIRING", 1, true) then
        local pairStart = source:find("local function viewerPair(a, b, list)", 1, true)
        local pairEnd = pairStart and source:find("local function wrapAngle", pairStart, true)
        if pairStart and pairEnd then
            local pairPatch = [[local AF_ROBUST_VIEWPORT_PAIRING = true
local function viewerPair(a, b, list)
    if not a or not b then return end
    if b:IsA("BasePart") then
        pcall(function() b.Anchored = true end)
        if a:IsA("BasePart") then list[#list + 1] = { a, b } end
    end
    local sourceChildren, cloneChildren = a:GetChildren(), b:GetChildren()
    local used = {}
    for _, sourceChild in ipairs(sourceChildren) do
        local matchIndex
        for index, cloneChild in ipairs(cloneChildren) do
            if not used[index] and cloneChild.Parent
                and cloneChild.Name == sourceChild.Name
                and cloneChild.ClassName == sourceChild.ClassName then
                matchIndex = index
                break
            end
        end
        if matchIndex then
            used[matchIndex] = true
            local cloneChild = cloneChildren[matchIndex]
            if VIEWER_STRIP[cloneChild.ClassName] then
                cloneChild:Destroy()
            else
                viewerPair(sourceChild, cloneChild, list)
            end
        end
    end
end
]]
            source = source:sub(1, pairStart - 1) .. pairPatch .. source:sub(pairEnd)
        end
    end

    if not source:find("AF_SAFE_VIEWPORT_BOUNDS", 1, true) then
        local boundsStart, boundsEnd = source:find("local cf, size = model:GetBoundingBox()", 1, true)
        if boundsStart and boundsEnd then
            local boundsPatch = [[local AF_SAFE_VIEWPORT_BOUNDS = true
local cf, size
local boundsOk = pcall(function() cf, size = model:GetBoundingBox() end)
if (not boundsOk or not cf or not size) and src:IsA("Model") then
    pcall(function() cf, size = src:GetBoundingBox() end)
end
if not cf or not size then
    local fallbackPart = list[1] and list[1][2]
    if fallbackPart and fallbackPart.Parent then
        cf, size = fallbackPart.CFrame, fallbackPart.Size
    else
        clone:Destroy()
        setEmpty(true, "Nothing to show")
        return
    end
end
]]
            source = source:sub(1, boundsStart - 1) .. boundsPatch .. source:sub(boundsEnd + 1)
        end
    end

    local toggleMarker = 'cfg, card, st = baseCard(self, cfg, { Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default" }, "TextButton", 56, "Toggle")'
    local toggleStart, toggleEnd = source:find(toggleMarker, 1, true)
    if toggleStart and toggleEnd and not source:find('Text = "LOCKED"', toggleEnd, true) then
        local lockVisual = [[
    if cfg.Locked == true then
        local lockedLabel = mkText {
            AnchorPoint = Vector2.new(1, .5),
            Position = UDim2.new(1, -58, .5, 0),
            Size = UDim2.fromOffset(48, 14),
            Text = "LOCKED",
            TextSize = 9,
            TextColor3 = Theme.Warning,
            TextXAlignment = Enum.TextXAlignment.Center,
            FontFace = Fonts.Bold,
            ZIndex = card.ZIndex + 3,
            Parent = card,
        }
    end
]]
        source = source:sub(1, toggleEnd) .. lockVisual .. source:sub(toggleEnd + 1)
    end
    local setMarker = 'function obj:Set(v, silent)\n\t\tv = v == true'
    local setReplacement = 'function obj:Set(v, silent)\n\t\tif cfg.Locked == true then return end\n\t\tv = v == true'
    local setStart, setEnd = source:find(setMarker, 1, true)
    if setStart and setEnd and not source:find('if cfg.Locked == true then return end', setStart, true) then
        source = source:sub(1, setStart - 1) .. setReplacement .. source:sub(setEnd + 1)
    end

    local initialToggleCallback = 'if obj.Value then fire(cfg.Callback, true) end'
    local guardedInitialCallback = 'if obj.Value and cfg.Locked ~= true then fire(cfg.Callback, true) end'
    local initialStart, initialEnd = source:find(initialToggleCallback, 1, true)
    if initialStart and initialEnd then
        source = source:sub(1, initialStart - 1) .. guardedInitialCallback .. source:sub(initialEnd + 1)
    end

    local chunk, compileError = loadstring(source)
    assert(chunk, compileError or "Could not compile Airflow library")
    return chunk()
end)

if not libraryOk or type(AirflowLibrary) ~= "table" then
    warn("[Methion] Could not load the Airflow library: " .. tostring(AirflowLibrary))
    return
end

pcall(function()
    AirflowLibrary:PreloadIcons()
end)

local AirflowCompat = {}
local CompatWindow = nil

local function adaptTab(rawTab, path)
    local tab = {}
    path = tostring(path or "Tab")
    -- Chopa: every control gets a config flag (tab/section/name), so Settings → Configurations saves it
    local function autoFlag(config, kind)
        if config.Flag then return config.Flag end
        if config.Locked == true then return nil end
        return "Chopa/" .. path .. "/" .. kind .. ":" .. tostring(config.Title or config.Name or "?")
    end

    function tab:Section(config)
        config = config or {}
        local section = rawTab:Section({
            Name = config.Title or config.Name or "Section",
            Side = config.Side,
            Collapsible = config.Collapsible,
            Collapsed = config.Collapsed,
        })
        return adaptTab(section, path .. "/" .. tostring(config.Title or config.Name or "Section"))
    end

    local function writeText(target, text, oldText, depth, seen)
        depth = depth or 0
        seen = seen or {}
        if target == nil or depth > 4 then return false end
        local kind = typeof(target)
        if kind == "Instance" then
            if target:IsA("TextLabel") or target:IsA("TextButton") or target:IsA("TextBox") then
                if oldText == nil or target.Text == oldText or target.Text == "" or target.Name == "Label" or target.Name == "Text" then
                    target.Text = text
                    return true
                end
                return false
            end
            if target:IsA("GuiObject") then
                local candidates = {}
                for _, child in ipairs(target:GetDescendants()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                        table.insert(candidates, child)
                    end
                end
                for _, child in ipairs(candidates) do
                    if oldText == nil or child.Text == oldText or child.Text == "" or child.Name == "Label" or child.Name == "Text" then
                        child.Text = text
                        return true
                    end
                end
                if #candidates == 1 then candidates[1].Text = text return true end
            end
            return false
        end
        if type(target) ~= "table" or seen[target] then return false end
        seen[target] = true
        for _, key in ipairs({"Instance", "Label", "TextLabel", "TitleLabel", "Frame", "Main", "Container", "Holder", "Object", "Element", "Raw"}) do
            local ok, child = pcall(function() return target[key] end)
            if ok and child ~= nil and child ~= target then
                if writeText(child, text, oldText, depth + 1, seen) then return true end
            end
        end
        return false
    end

    function tab:Toggle(config)
        config = config or {}
        local default = config.Value == true
        if default and not _G.__ChopaHasConfig and not config.KeepDefault then default = false end   -- new user: all off
        return rawTab:Toggle({
            Name = config.Title or config.Name or "Toggle",
            Desc = config.Desc or "",
            Default = default,
            Flag = autoFlag(config, "Toggle"),
            Locked = config.Locked == true,
            LockedReason = config.LockedReason or "Premium",
            Callback = config.Callback,
        })
    end

    function tab:Dropdown(config)
        config = config or {}
        local element = rawTab:Dropdown({
            Name = config.Title or config.Name or "Dropdown",
            Desc = config.Desc or "",
            Style = "Popup",
            SearchAfter = config.SearchAfter or 8,
            Options = config.Values or config.Options or {},
            Default = config.Value ~= nil and config.Value or config.Default,
            Multi = config.Multi == true,
            Flag = autoFlag(config, "Dropdown"),
            Callback = config.Callback,
        })

        local initialValue = config.Value ~= nil and config.Value or config.Default
        local wrapped = {
            Raw = element,
            Instance = nil,
            _displayValue = type(initialValue) == "table" and tostring(initialValue[1] or "") or tostring(initialValue or ""),
        }
        function wrapped:Refresh(options, preserveSelection)
            if self.Raw and type(self.Raw.Refresh) == "function" then
                return self.Raw:Refresh(options, preserveSelection)
            end
        end
        function wrapped:Set(value)
            local raw = self.Raw
            for _, methodName in ipairs({"Set", "SetValue", "SetSelected", "SetSelection", "Select"}) do
                local ok, method = pcall(function()
                    return raw and raw[methodName]
                end)
                if ok and type(method) == "function" then
                    local applied = pcall(function()
                        method(raw, value)
                    end)
                    if applied then
                        self._displayValue = tostring(value or "")
                        return true
                    end
                end
            end
            local previous = self._displayValue
            local applied = pcall(function()
                writeText(raw, tostring(value or ""), previous)
            end)
            self._displayValue = tostring(value or "")
            return applied
        end
        return wrapped
    end

    function tab:Progress(config)
        config = config or {}
        return rawTab:Progress({
            Name = config.Title or config.Name or "Progress",
            Desc = config.Desc or "",
            Default = config.Default or 0,
            Format = config.Format,
        })
    end

    function tab:Slider(config)
        config = config or {}
        local range = config.Value or {}
        return rawTab:Slider({
            Name = config.Title or config.Name or "Slider",
            Desc = config.Desc or "",
            Min = range.Min or config.Min or 0,
            Max = range.Max or config.Max or 100,
            Step = config.Step or 1,
            Default = range.Default or config.Default or range.Min or config.Min or 0,
            Suffix = config.Suffix,
            Flag = autoFlag(config, "Slider"),
            Callback = config.Callback,
        })
    end

    function tab:ColorPicker(config)
        config = config or {}
        return rawTab:ColorPicker({
            Name = config.Title or config.Name or "Color",
            Desc = config.Desc or "",
            Default = config.Value or config.Default or Color3.new(1, 1, 1),
            Flag = config.Flag,
            Callback = config.Callback,
        })
    end

    function tab:Button(config)
        config = config or {}
        return rawTab:Button({
            Name = config.Title or config.Name or "Button",
            Desc = config.Desc or "",
            Icon = config.Icon,
            Style = config.Style,
            Callback = config.Callback,
        })
    end

    function tab:Input(config)
        config = config or {}
        return rawTab:Input({
            Name = config.Title or config.Name or "Input",
            Desc = config.Desc or "",
            Placeholder = config.Placeholder or "",
            Default = config.Value ~= nil and config.Value or config.Default or "",
            Flag = autoFlag(config, "Input"),
            Callback = config.Callback,
        })
    end

    function tab:Paragraph(config)
        config = config or {}
        local title = tostring(config.Title or config.Name or "")
        local desc = tostring(config.Desc or config.Content or "")
        local label = rawTab:Label({
            Text = title ~= "" and (title .. "\n" .. desc) or desc,
        })

        local paragraph = {
            Title = title,
            Desc = desc,
            Label = label,
            _renderedText = title ~= "" and (title .. "\n" .. desc) or desc,
        }
        function paragraph:SetDesc(value)
            self.Desc = tostring(value)
            local text = self.Title ~= "" and (self.Title .. "\n" .. self.Desc) or self.Desc
            if text == self._renderedText then return end      -- Chopa perf: nothing changed
            local wrote = false
            if self.Label and type(self.Label.Set) == "function" then
                wrote = pcall(function() self.Label:Set(text) end)
            end
            pcall(function() writeText(self.Label, text, self._renderedText) end)
            self._renderedText = text
        end
        function paragraph:Set(value)
            return self:SetDesc(value)
        end
        return paragraph
    end

    function tab:Divider()
        return rawTab:Divider()
    end

    function tab:Header(text)
        return rawTab:Header(text)
    end

    function tab:Label(config)
        return rawTab:Label(config)
    end

    function tab:Viewer(config)
        config = config or {}
        local methodOk, viewerMethod = pcall(function()
            return rawTab.Viewer
        end)
        if not methodOk or type(viewerMethod) ~= "function" then
            warn("[Methion] The loaded Flow library does not expose Tab:Viewer. Update the Flow library before using Player Viewer.")
            return nil
        end

        local created, viewer = pcall(function()
            return rawTab:Viewer(config)
        end)
        if not created then
            warn("[Methion] Could not create Player Viewer: " .. tostring(viewer))
            return nil
        end
        return viewer
    end

    return tab
end

function AirflowCompat:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Chopa"
    local rawWindow = AirflowLibrary:CreateWindow({
        Name = config.Name or "Chopa",
        Title = title,
        LoadingSubtitle = config.Author or "YBA Hub",
        Icon = config.Icon or "rbxthumb://type=Asset&id=108858394161442&w=150&h=150",
        Size = config.Size or UDim2.fromOffset(580, 460),
        MinSize = Vector2.new(560, 380),
        MaxSize = Vector2.new(1100, 800),
        ToggleUIKeybind = "RightControl",
        OpenButton = { Title = title, Icon = config.Icon or "rbxthumb://type=Asset&id=108858394161442&w=150&h=150" },
        KeepOnScreen = true,
        MaxNotifications = 4,
        Loading = {
            Enabled = true,
            Duration = 0.4,
            Title = title,
            Text = "Preparing Chopa",
            Steps = { "Loading components", "Building controls", "Ready" },
        },
        ConfigurationSaving = {
            Enabled = false,
            FolderName = "Chopa",
            FileName = "Config",
        },
        Parent = game:GetService("CoreGui"),
        Settings = false,          -- Chopa: no gear button; its content lives in the "Settings" tab
    })

    local window = { Raw = rawWindow, MainFrame = nil }

    local itemFarmTab = nil
    local function hiddenControl(config)
        config = config or {}
        local control = {
            Value = config.Value ~= nil and config.Value or config.Default,
            Raw = nil,
            Desc = config.Desc or "",
        }
        control.Raw = control
        function control:Set(value)
            self.Value = value
            return true
        end
        function control:SetDesc(value)
            self.Desc = tostring(value or "")
            return true
        end
        function control:Refresh(...) return true end
        function control:Add(...) return true end
        function control:Remove(...) return true end
        return setmetatable(control, { __index = function()
            return function() return nil end
        end })
    end
    local hiddenTab = {}
    hiddenTab.Raw = hiddenTab
    setmetatable(hiddenTab, { __index = function(_, methodName)
        if methodName == "Section" or methodName == "Divider" or methodName == "Header" then
            return function() return hiddenTab end
        end
        return function(_, config) return hiddenControl(config) end
    end })

    function window:Tab(options)
        options = options or {}
        local requestedName = options.Title or options.Name or "Tab"
        if requestedName ~= "Auto-Farm" then
            return hiddenTab
        end
        if not itemFarmTab then
            local rawTab = self.Raw:Tab({
                Name = "ItemFarmSH",
                Icon = options.Icon or "package-search",
                Desc = "AFK item farming with server hopping.",
            })
            itemFarmTab = adaptTab(rawTab, "ItemFarmSH")
        end
        return itemFarmTab
    end

    function window:Notify(options)
        options = options or {}
        return self.Raw:Notify({
            Title = options.Title or "Chopa",
            Content = options.Content or options.Desc or "",
            Type = options.Type or "Info",
            Duration = options.Duration or 3,
            Icon = options.Icon,
        })
    end

    function window:Destroy()
        if self.Raw and type(self.Raw.Destroy) == "function" then
            return self.Raw:Destroy()
        end
    end

    function window:Toggle()
        if self.Raw and type(self.Raw.Toggle) == "function" then
            return self.Raw:Toggle()
        end
    end

    CompatWindow = window
    return window
end

function AirflowCompat:Notify(options)
    if CompatWindow then
        return CompatWindow:Notify(options)
    end
end

local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

-- ================= АНТИЧИТ БАЙПАСС (Methion / YBA) =================
local RETURNER_KEY = "idklolbrah2de"
local RETURNER_RESPONSE = "  ___XP DE KEY"
local bypassSupported = false

-- 1. Перехват вызова Returner через __namecall
pcall(function()
    if type(hookmetamethod) == "function" and type(newcclosure) == "function" then
        local old
        old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if not checkcaller() and typeof(self) == "Instance" and self.Name == "Returner" and rawequal((...), RETURNER_KEY) then
                return RETURNER_RESPONSE
            end
            return old(self, ...)
        end))
        bypassSupported = true
    end
end)

-- 2. Подмена проверки дистанции Magnitude для ItemSpawn
pcall(function()
    if type(getrawmetatable) == "function" and type(setreadonly) == "function" and type(newcclosure) == "function" then
        local meta = getrawmetatable(Vector3.new())
        if meta then
            setreadonly(meta, false)
            local old = meta.__index
            meta.__index = newcclosure(function(self, index)
                if not checkcaller() and (index == "magnitude" or index == "Magnitude") then
                    local cs = getcallingscript()
                    if cs then
                        local name = typeof(cs) == "Instance" and (cs.Name or "") or tostring(cs)
                        if name == "ItemSpawn" then 
                            return 0 
                        end
                    end
                end
                return old(self, index)
            end)
            setreadonly(meta, true)
        end
    end
end)

-- 3. Фоллбек-скрипт, если эксплойт не поддерживает перехват метатаблиц
if not bypassSupported then
    local fallbackOk, fallbackErr = pcall(function()
        local fallbackSource = game:HttpGet("https://pastebin.com/raw/c9xy3XzA")
        assert(type(fallbackSource) == "string" and #fallbackSource > 0, "Fallback script returned an empty response")
        local fallbackChunk, compileError = loadstring(fallbackSource)
        assert(type(fallbackChunk) == "function", compileError or "Fallback script could not be compiled")
        fallbackChunk()
    end)

    if not fallbackOk then
        warn("[Chopa] Bypass unsupported and fallback script failed: " .. tostring(fallbackErr))
        return
    else
        bypassSupported = true
    end
end
-- ===================================================================

local savedFarmTeleportMode = MethionSH_Env.__MethionSHFarmTeleportMode
local initialFarmTeleportMode = (savedFarmTeleportMode == "instant" or savedFarmTeleportMode == "tween") and savedFarmTeleportMode or (bypassSupported and "instant" or "tween")
local savedReloadOnKick = MethionSH_Env.__MethionSHReloadOnKick
local initialReloadOnKick = true
if type(savedReloadOnKick) == "boolean" then initialReloadOnKick = savedReloadOnKick end
local savedFarmOnlyItems = MethionSH_Env.__MethionSHFarmOnlyItems

-- Chopa: item lists saved in the executor workspace (shared by all accounts, survive restarts / hops)
local function chopaList(v)                -- dropdown value (list, map or string) -> clean list of names
    local out = {}
    if type(v) == "string" then
        if v ~= "" then out[1] = v end
    elseif type(v) == "table" then
        if #v > 0 then
            for _, x in ipairs(v) do if type(x) == "string" and x ~= "" then out[#out + 1] = x end end
        else
            for k, x in pairs(v) do if type(k) == "string" and x then out[#out + 1] = k end end
        end
    end
    return out
end
local function chopaReadList(file)
    local list = {}
    pcall(function()
        if isfile and isfile(file) then list = chopaList(HttpService:JSONDecode(readfile(file))) end
    end)
    return list
end
local function chopaWriteList(file, list)
    if type(writefile) == "function" then pcall(function() writefile(file, HttpService:JSONEncode(chopaList(list))) end) end
end
local CHOPA_FARM_ITEMS_FILE = "chopa_farm_items.json"
local CHOPA_SELL_BLACKLIST_FILE = "chopa_sell_blacklist.json"

local Config = {
    TweenSpeed = 220,
    SafeZone = Vector3.new(-212.241150, -33.486183, -283.842651),
    AutoBuyLucky = false,
    LuckyArrowPrice = 75000,
    LuckyArrowItem = "1x Lucky Arrow",
    FarmOnlyItems = (type(savedFarmOnlyItems) == "table" and #savedFarmOnlyItems > 0) and chopaList(savedFarmOnlyItems)
        or chopaReadList(CHOPA_FARM_ITEMS_FILE),
    AutoRejoinEnabled = initialReloadOnKick,
    FarmTeleportMode = initialFarmTeleportMode,
    InstantDelay = 0.35,
    Boosted = false,
    NotifyItemSpawn = CHOPA_HAS_CONFIG,
    Esp = {
        ShowHP = true,
        ShowDistance = true,
        ShowSpec = false,
        ShowStand = false,
        ShowPlayerName = true,
        ShowItemDistance = true,
        ItemTrackerPosition = "Bottom",
        PlayerTrackerPosition = "Bottom",
        ItemUseTypeColors = false,
        ItemHighlightColor = Color3.fromRGB(255, 185, 46),
        ItemOutlineColor = Color3.fromRGB(255, 255, 255),
        ItemNameColor = Color3.fromRGB(255, 255, 255),
        ItemFillTransparency = 0.45,
        ItemOutlineTransparency = 0,
        ItemTextSize = 13,
        PlayerFillColor = Color3.fromRGB(80, 175, 255),
        PlayerOutlineColor = Color3.fromRGB(255, 255, 255),
        PlayerNameColor = Color3.fromRGB(255, 255, 255),
        PlayerTextOutlineColor = Color3.fromRGB(0, 0, 0),
        PlayerFillTransparency = 0.6,
        PlayerOutlineTransparency = 0.15,
        PlayerTextSize = 13,
    },
    Weather = {TimeOfDayEnabled = false},
    Teleport = {
        Mode = bypassSupported and "Instant" or "Tween",
        SelectedLocation = "Prison Bridge",
        X = 0,
        Y = 0,
        Z = 0,
        SavedPosition = nil,
        LastPosition = nil,
        LocationNames = {
            "Prison Bridge", "Via dell'Oceano", "Merchant's Keep", "Parking Lot",
            "Via Toledo", "Train Station", "The Tallest Peak", "Pizzeria", "Arcade",
            "Vampire Hideout",
        },
        Locations = {
            ["Prison Bridge"] = Vector3.new(590.2, 0.2, -170.4),
            ["Via dell'Oceano"] = Vector3.new(16.8, -25.8, 588.4),
            ["Merchant's Keep"] = Vector3.new(-620.4, -25.8, -465.1),
            ["Parking Lot"] = Vector3.new(-146.7, 0.2, -675.5),
            ["Via Toledo"] = Vector3.new(-134.2, 0.2, -117.5),
            ["Train Station"] = Vector3.new(-456.1, 0.2, -8.7),
            ["The Tallest Peak"] = Vector3.new(-242.6, 284.2, 354.4),
            ["Pizzeria"] = Vector3.new(111.9, 6.0, 72.2),
            ["Arcade"] = Vector3.new(268.9, 1.8, -271.3),
            ["Vampire Hideout"] = Vector3.new(396.8, -31.5, -174.0),
        },
    },
    Player = {JumpPowerEnabled = false, JumpPower = 24, JumpPowerOriginal = nil, JumpUseJumpPowerOriginal = nil, NoClipEnabled = false, WalkSpeedEnabled = false, WalkSpeed = 24, WalkSpeedOriginal = nil},
    Trolling = {TargetPlayers = {}},
}

local State = {
    ItemEsp = CHOPA_HAS_CONFIG,
    NotifyItemSpawn = CHOPA_HAS_CONFIG,
    PlayerEsp = false,
    ItemTracker = false,
    PlayerTracker = false,
    Farm = false,
    HalloweenCandyFarm = false,
    HalloweenTurnInBusy = false,
    NoClip = false,
    TweenRunning = false,
    Selling = false,
    SelectedPlayer = nil,
    Spectate = false,
    LowGraphics = false,
}

local UIRefs = {}
local Tracked = {}
local TrackedRev = {}
local Pending = {}

local ESP_ITEMS = {
    ["Mysterious Arrow"] = Color3.fromRGB(255,185,46),
    ["Rokakaka"] = Color3.fromRGB(204,8,8),
    ["Gold Coin"] = Color3.fromRGB(255,215,71),
    ["Diamond"] = Color3.fromRGB(40,199,201),
    ["Stone Mask"] = Color3.fromRGB(128,128,128),
    ["Quinton's Glove"] = Color3.fromRGB(212,69,30),
    ["Steel Ball"] = Color3.fromRGB(58,189,76),
    ["Dio's Diary"] = Color3.fromRGB(97,49,5),
    ["Pure Rokakaka"] = Color3.fromRGB(255,84,84),
    ["Lucky Arrow"] = Color3.fromRGB(255,0,162),
    ["Lucky Stone Mask"] = Color3.fromRGB(132,0,255),
    ["Rib Cage of The Saint's Corpse"] = Color3.fromRGB(194,194,194),
    ["Ancient Scroll"] = Color3.fromRGB(0,85,255),
    ["Caesar's Headband"] = Color3.fromRGB(200,255,0),
    ["Clackers"] = Color3.fromRGB(0,85,255),
    ["Zeppeli's Hat"] = Color3.fromRGB(173,201,255),
    ["Christmas Present"] = Color3.fromRGB(68,140,0),
    ["Green Candy"] = Color3.fromRGB(0,255,238),
    ["Red Candy"] = Color3.fromRGB(0,255,238),
    ["Blue Candy"] = Color3.fromRGB(0,255,238),
    ["Yellow Candy"] = Color3.fromRGB(0,255,238),
}

local SELLABLE = {
    ["Mysterious Arrow"] = true, ["Rokakaka"] = true, ["Gold Coin"] = true,
    ["Diamond"] = true, ["Stone Mask"] = true, ["Quinton's Glove"] = true,
    ["Steel Ball"] = true, ["Dio's Diary"] = true, ["Pure Rokakaka"] = true,
    ["Rib Cage of The Saint's Corpse"] = true, ["Ancient Scroll"] = true,
    ["Caesar's Headband"] = true, ["Clackers"] = true, ["Zeppeli's Hat"] = true,
}

local Utils = {}

function Utils.basePart(obj)
    if not obj or not obj.Parent then return nil end
    if obj.Parent:IsA("BasePart") then return obj.Parent end
    return obj.Parent:FindFirstChildWhichIsA("BasePart", true)
        or (obj.Parent.Parent and obj.Parent.Parent:FindFirstChildWhichIsA("BasePart", true))
end

function Utils.validPos(part)
    if not part or not part:IsDescendantOf(workspace) then return false end
    local p = part.Position
    return not (math.abs(p.X) < 1 and math.abs(p.Y) < 1 and math.abs(p.Z) < 1)
end

function Utils.invisible(part)
    if not part or not part.Parent then return true end
    if not part:IsDescendantOf(workspace) then return true end
    if part.Transparency >= 1 then return true end
    if part.LocalTransparencyModifier >= 1 then return true end
    return false
end

function Utils.playerInfo(plr)
    local spec, stand = "?", "?"
    local ps = plr:FindFirstChild("PlayerStats")
    if ps then
        local s = ps:FindFirstChild("Spec")
        if s and s:IsA("StringValue") then spec = s.Value end
        local st = ps:FindFirstChild("Stand")
        if st and st:IsA("StringValue") then stand = st.Value end
    end
    return spec, stand
end

function Utils.stat(plr, name, mode)
    local ps = plr:FindFirstChild("PlayerStats")
    if not ps then return nil end
    local v = ps:FindFirstChild(name)
    if not v then return nil end
    local val = v.Value
    if mode == "hours" then
        local n = tonumber(val)
        if n then return string.format("%.1fh", n / 3.6) end
    elseif mode == "int" then
        local n = tonumber(val)
        if n then return tostring(math.floor(n)) end
    end
    return tostring(val)
end

function Utils.money()
    local ps = LP:FindFirstChild("PlayerStats")
    if not ps then return 0 end
    local m = ps:FindFirstChild("Money")
    if m then return tonumber(m.Value) or 0 end
    return 0
end

function Utils.character()
    return LP.Character or LP.CharacterAdded:Wait()
end

local Gui = {}

function Gui.isVisible(guiObject)
    if not guiObject or not guiObject:IsA("GuiObject") or not guiObject.Visible then
        return false
    end
    local current = guiObject.Parent
    while current do
        if current:IsA("GuiObject") and not current.Visible then
            return false
        end
        if current:IsA("ScreenGui") and not current.Enabled then
            return false
        end
        current = current.Parent
    end
    return true
end

function Gui.clickAt(x, y)
    local sent = false
    pcall(function()
        local virtualInput = game:GetService("VirtualInputManager")
        virtualInput:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.005)
        virtualInput:SendMouseButtonEvent(x, y, 0, false, game, 0)
        sent = true
    end)
    if not sent and type(mousemoverel) == "function" and type(mouse1click) == "function" then
        pcall(function()
            local mousePos = UserInputService:GetMouseLocation()
            mousemoverel(x - mousePos.X, y - mousePos.Y)
            task.wait(0.025)
            mouse1click()
            sent = true
        end)
    end
    return sent
end

function Gui.dialogueSignature(gui)
    if not gui or not gui.Parent then return "" end
    local parts = {}
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and Gui.isVisible(obj) then
            table.insert(parts, obj:GetFullName() .. "=" .. tostring(obj.Text))
        end
    end
    table.sort(parts)
    return table.concat(parts, "\30")
end

function Gui.dialogueText(gui)
    if not gui or not gui.Parent then return "" end
    local parts = {}
    local frame = gui:FindFirstChild("Frame")
    local options = frame and frame:FindFirstChild("Options")
    for _, obj in ipairs(gui:GetDescendants()) do
        if (obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton"))
            and Gui.isVisible(obj)
            and not (options and obj:IsDescendantOf(options)) then
            local value = tostring(obj.Text or "")
            if value ~= "" then table.insert(parts, value) end
        end
    end
    return table.concat(parts, " ")
end

function Gui.hasCombatDialogueWarning(gui)
    local text = string.lower(Gui.dialogueText(gui))
    if text == "" then return false end
    if text:find("pay attention to your fight", 1, true) then return true end
    if text:find("pay attention", 1, true) and text:match("%f[%a]fight%f[%A]") then return true end
    if text:match("%f[%a]fight%f[%A]") then return true end
    return false
end

function Gui.skipClick()
    local camera = workspace.CurrentCamera
    if not camera then return false end
    local viewport = camera.ViewportSize
    return Gui.clickAt(math.max(1, math.floor(viewport.X - 10)), 10)
end

function Gui.click(button)
    if not button or not button.Parent then return false end

    local fired = false
    if type(getconnections) == "function" then
        local ok, connections = pcall(function()
            return getconnections(button.MouseButton1Click)
        end)
        if ok and connections then
            for _, connection in pairs(connections) do
                local success = pcall(function()
                    connection:Fire()
                end)
                if success then fired = true end
            end
        end
    end
    if not fired and type(firesignal) == "function" then
        local ok = pcall(function()
            firesignal(button.MouseButton1Click)
        end)
        fired = ok
    end
    if not fired then
        local ok = pcall(function()
            button:Activate()
        end)
        fired = ok
    end
    if fired then return true end

    local pos = button.AbsolutePosition
    local size = button.AbsoluteSize
    if size.X > 0 and size.Y > 0 then
        return Gui.clickAt(pos.X + size.X / 2, pos.Y + size.Y / 2)
    end
    return false
end

function Gui.dialogueActive(gui)
    if not gui or not gui.Parent then return false end
    if gui:IsA("ScreenGui") and not gui.Enabled then return false end
    if gui:IsA("GuiObject") and not gui.Visible then return false end
    local frame = gui:FindFirstChild("Frame")
    if frame and frame:IsA("GuiObject") and not frame.Visible then return false end
    return true
end

function Gui.currentDialogue()
    local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:FindFirstChild("PlayerGui")
    local gui = playerGui and playerGui:FindFirstChild("DialogueGui") or nil
    return Gui.dialogueActive(gui) and gui or nil
end

function Gui.option(gui, name)
    local frame = gui and gui:FindFirstChild("Frame")
    if not frame then return nil end
    local options = frame:FindFirstChild("Options")
    if not options then return nil end

    local option = options:FindFirstChild(name) or options:FindFirstChild(name, true)
    if not option then return nil end
    if option:IsA("GuiButton") then return option end
    return option:FindFirstChildWhichIsA("GuiButton", true)
end

function Gui.hasVisibleOptions(gui)
    local frame = gui and gui:FindFirstChild("Frame")
    local options = frame and frame:FindFirstChild("Options")
    if not options or not Gui.isVisible(options) then return false end

    for _, name in ipairs({"Option1", "Option2", "Option3", "Option4", "Option5", "Option6", "Option7", "Option8"}) do
        local button = Gui.option(gui, name)
        if button and Gui.isVisible(button) then
            return true
        end
    end

    for _, descendant in ipairs(options:GetDescendants()) do
        if descendant:IsA("GuiButton") and Gui.isVisible(descendant) then
            return true
        end
    end
    for _, child in ipairs(options:GetChildren()) do
        if child:IsA("GuiButton") and Gui.isVisible(child) then
            return true
        end
    end
    return false
end

function Gui.waitDialogue(timeout)
    local start = tick()
    while tick() - start < timeout do
        local gui = Gui.currentDialogue()
        if gui and gui.Parent then return gui end
        task.wait()
    end
    return nil
end

function Gui.waitAndClickOption(name, timeout)
    local started = tick()
    local skipInterval = 0.12
    local lastSkip = tick() - skipInterval

    while tick() - started < timeout do
        local gui = Gui.currentDialogue()
        if not gui then
            task.wait()
            gui = Gui.currentDialogue()
            if not gui then
                return false
            end
        end

        local target = Gui.option(gui, name)
        if target and target.Parent and Gui.isVisible(target) then
            if Gui.click(target) then
                return true
            end
        elseif not Gui.hasVisibleOptions(gui) and tick() - lastSkip >= skipInterval then
            if Gui.skipClick() then
                lastSkip = tick()
            end
        end

        task.wait()
    end

    return false
end

function Gui.advanceUntilClosed(timeout)
    local started = tick()
    local lastSkip = tick()
    local skipInterval = 0.12

    while tick() - started < timeout do
        local gui = Gui.currentDialogue()
        if not gui or not Gui.dialogueActive(gui) then
            return true
        end

        if not Gui.hasVisibleOptions(gui) and tick() - lastSkip >= skipInterval then
            if Gui.skipClick() then
                lastSkip = tick()
            end
        end

        task.wait()
    end

    return Gui.currentDialogue() == nil
end

function Gui.forceCloseDialogue(timeout)
    local deadline = tick() + (tonumber(timeout) or 3)
    local lastSkip = 0

    while tick() < deadline do
        local gui = Gui.currentDialogue()
        if not gui then return true end

        local clickedClose = false
        for _, descendant in ipairs(gui:GetDescendants()) do
            if descendant:IsA("GuiButton") and Gui.isVisible(descendant) then
                local buttonName = string.lower(tostring(descendant.Name or ""))
                local buttonText = string.lower(tostring(descendant.Text or "")):gsub("%s+", "")
                local isCloseButton = buttonName == "close" or buttonName == "closebutton"
                    or buttonName == "exit" or buttonName == "exitbutton"
                    or buttonName == "x" or buttonName == "xbutton"
                    or buttonName == "skip" or buttonName == "skipbutton"
                    or buttonText == "close" or buttonText == "exit"
                    or buttonText == "x" or buttonText == "×" or buttonText == "skip"
                if isCloseButton and Gui.click(descendant) then
                    clickedClose = true
                    break
                end
            end
        end

        if not clickedClose and tick() - lastSkip >= 0.15 then
            Gui.skipClick()
            lastSkip = tick()
        end
        task.wait(0.05)
    end

    local remaining = Gui.currentDialogue()
    if remaining then
        local frame = remaining:FindFirstChild("Frame")
        if frame and frame:IsA("GuiObject") then
            frame.Visible = false
        elseif remaining:IsA("ScreenGui") then
            remaining.Enabled = false
        end
    end
    return Gui.currentDialogue() == nil
end

local ItemESP = {}

function ItemESP.isPlayerOwned(obj, part)
    -- Chopa perf: walk up the ancestors once instead of checking every player
    for i = 1, 2 do
        local candidate = (i == 1) and part or obj
        if candidate and candidate.Parent then
            local a = candidate
            while a and a ~= workspace and a ~= game do
                if a:IsA("Backpack") then return true end
                if a:IsA("Model") and Players:GetPlayerFromCharacter(a) then return true end
                a = a.Parent
            end
        end
    end
    return false
end

function ItemESP.colorFor(name)
    if Config.Esp.ItemUseTypeColors and ESP_ITEMS[name] then
        return ESP_ITEMS[name]
    end
    return Config.Esp.ItemHighlightColor or ESP_ITEMS[name] or Color3.fromRGB(255, 185, 46)
end

function ItemESP.labelText(part, name)
    local text = tostring(name or "Item")
    if Config.Esp.ShowItemDistance then
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root and part and part.Parent then
            text ..= "\n" .. tostring(math.floor((part.Position - root.Position).Magnitude)) .. " studs away"
        end
    end
    return text
end

function ItemESP.create(part, name, visible)
    if not part or not part.Parent then return end
    if ItemESP.isPlayerOwned(nil, part) then
        local existingHighlight = part:FindFirstChild("Phantom_ESP")
        local existingLabel = part:FindFirstChild("Phantom_Label")
        if existingHighlight then existingHighlight.Enabled = false end
        if existingLabel then existingLabel.Enabled = false end
        return
    end
    local color = ItemESP.colorFor(name)
    local shouldShow = visible == true and State.ItemEsp == true
    local hl = part:FindFirstChild("Phantom_ESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "Phantom_ESP"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = part
        hl.Parent = part
    end
    hl.Adornee = part
    hl.FillColor = color
    hl.OutlineColor = Config.Esp.ItemOutlineColor
    hl.FillTransparency = shouldShow and math.clamp(tonumber(Config.Esp.ItemFillTransparency) or 0.45, 0, 1) or 1
    hl.OutlineTransparency = shouldShow and math.clamp(tonumber(Config.Esp.ItemOutlineTransparency) or 0, 0, 1) or 1
    hl.Enabled = shouldShow

    local bb = part:FindFirstChild("Phantom_Label")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "Phantom_Label"
        bb.Size = UDim2.new(0, 170, 0, 44)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 4000
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Adornee = part
        bb.Parent = part
    end
    bb.Adornee = part
    local label = bb:FindFirstChild("Phantom_Text")
    if not label then
        label = Instance.new("TextLabel")
        label.Name = "Phantom_Text"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.Parent = bb
    end
    label.TextColor3 = Config.Esp.ItemNameColor
    label.TextSize = math.clamp(math.floor(tonumber(Config.Esp.ItemTextSize) or 13), 8, 24)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.25
    label.TextWrapped = true
    label.Text = ItemESP.labelText(part, name)
    bb.Enabled = shouldShow
end

function ItemESP.remove(part)
    if not part then return end
    local hl = part:FindFirstChild("Phantom_ESP")
    if hl then hl:Destroy() end
    local bb = part:FindFirstChild("Phantom_Label")
    if bb then bb:Destroy() end
end

function ItemESP.refresh()
    for part, data in pairs(Tracked) do
        if part and part.Parent and part:IsDescendantOf(workspace) then
            if not Utils.invisible(part) and not ItemESP.isPlayerOwned(data.Obj, part) then
                ItemESP.create(part, data.Name, State.ItemEsp)
            else
                local hl = part:FindFirstChild("Phantom_ESP")
                local bb = part:FindFirstChild("Phantom_Label")
                if hl then hl.Enabled = false end
                if bb then bb.Enabled = false end
            end
        end
    end
end

function ItemESP.setVisible(visible)
    State.ItemEsp = visible == true
    ItemESP.refresh()
end

function ItemESP.register(obj)
    if not obj or TrackedRev[obj] then return end
    local name, part
    if obj:IsA("ProximityPrompt") and ESP_ITEMS[obj.ObjectText or ""] then
        name = obj.ObjectText
        part = Utils.basePart(obj)
    elseif obj:IsA("BasePart") and ESP_ITEMS[obj.Name] then
        name = obj.Name
        part = obj
    end
    if not name or not part then return end
    if Tracked[part] then TrackedRev[obj] = part return end
    if not Utils.validPos(part) then
        table.insert(Pending, {obj = obj, part = part, name = name})
        return
    end
    if not Utils.invisible(part) then ItemESP.create(part, name, State.ItemEsp) end
    Tracked[part] = {Name = name, Obj = obj}
    TrackedRev[obj] = part
end

function ItemESP.unregister(part)
    if not part then return end
    if Tracked[part] then
        ItemESP.remove(part)
        Tracked[part] = nil
    end

    for object, mappedPart in pairs(TrackedRev) do
        if mappedPart == part then
            TrackedRev[object] = nil
        end
    end

    for index = #Pending, 1, -1 do
        local entry = Pending[index]
        if entry and entry.part == part then
            table.remove(Pending, index)
        end
    end
end

function ItemESP.scan()
    local list = workspace:GetDescendants()
    for i = 1, #list do
        local o = list[i]
        if o:IsA("ProximityPrompt") or (o:IsA("BasePart") and ESP_ITEMS[o.Name]) then
            ItemESP.register(o)
        end
        if i % 3000 == 0 and coroutine.isyieldable() then task.wait() end
    end
end

function ItemESP.count()
    local n = 0
    for part, data in pairs(Tracked) do
        if part and part:IsDescendantOf(workspace) and not Utils.invisible(part)
            and not ItemESP.isPlayerOwned(data and data.Obj, part) then
            n = n + 1
        end
    end
    return n
end

local PlayerESP = {}

function PlayerESP.create(char, name, visible)
    if not char or not char.Parent then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local shouldShow = visible == true and State.PlayerEsp == true
    local hl = char:FindFirstChild("Phantom_PlayerESP")
    if not hl then
        hl = Instance.new("Highlight")
        hl.Name = "Phantom_PlayerESP"
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Adornee = char
        hl.Parent = char
    end
    hl.Adornee = char
    hl.FillColor = Config.Esp.PlayerFillColor
    hl.OutlineColor = Config.Esp.PlayerOutlineColor
    hl.FillTransparency = shouldShow and math.clamp(tonumber(Config.Esp.PlayerFillTransparency) or 0.6, 0, 1) or 1
    hl.OutlineTransparency = shouldShow and math.clamp(tonumber(Config.Esp.PlayerOutlineTransparency) or 0.15, 0, 1) or 1
    hl.Enabled = shouldShow

    local bb = head:FindFirstChild("Phantom_PlayerLabel")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "Phantom_PlayerLabel"
        bb.Size = UDim2.new(0, 220, 0, 76)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 4000
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.Adornee = head
        bb.Parent = head
    end
    bb.Adornee = head
    local label = bb:FindFirstChild("Phantom_PlayerText")
    if not label then
        label = Instance.new("TextLabel")
        label.Name = "Phantom_PlayerText"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamMedium
        label.TextWrapped = true
        label.Parent = bb
        local stroke = Instance.new("UIStroke")
        stroke.Name = "Phantom_TextStroke"
        stroke.Thickness = 0.75
        stroke.Transparency = 0
        stroke.Parent = label
    end
    label.TextColor3 = Config.Esp.PlayerNameColor
    label.TextSize = math.clamp(math.floor(tonumber(Config.Esp.PlayerTextSize) or 13), 8, 24)
    label.TextStrokeColor3 = Config.Esp.PlayerTextOutlineColor
    label.TextStrokeTransparency = 0.15
    local stroke = label:FindFirstChild("Phantom_TextStroke")
    if stroke and stroke:IsA("UIStroke") then
        stroke.Color = Config.Esp.PlayerTextOutlineColor
        stroke.Thickness = 0.75
        stroke.Transparency = 0.05
    end
    bb.Enabled = shouldShow
end

function PlayerESP.refresh()
    if not State.PlayerEsp then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            PlayerESP.create(plr.Character, plr.Name, true)
        end
    end
end

function PlayerESP.remove(char)
    if not char then return end
    local hl = char:FindFirstChild("Phantom_PlayerESP")
    if hl then hl:Destroy() end
    local head = char:FindFirstChild("Head")
    if head then
        local bb = head:FindFirstChild("Phantom_PlayerLabel")
        if bb then bb:Destroy() end
    end
end

local TrackerESP = {
    Gui = nil,
    Lines = {},
}

function TrackerESP.ensureGui()
    if TrackerESP.Gui and TrackerESP.Gui.Parent then return TrackerESP.Gui end

    local oldGui
    local parent
    pcall(function()
        parent = game:GetService("CoreGui")
        oldGui = parent:FindFirstChild("Phantom_ESPTrackers")
    end)
    if not parent then
        parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
        oldGui = parent:FindFirstChild("Phantom_ESPTrackers")
    end
    if oldGui then pcall(function() oldGui:Destroy() end) end

    local gui = Instance.new("ScreenGui")
    gui.Name = "Phantom_ESPTrackers"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent
    TrackerESP.Gui = gui
    return gui
end

function TrackerESP.lineFor(target)
    local line = TrackerESP.Lines[target]
    if line and line.Parent then return line end

    line = Instance.new("Frame")
    line.Name = "TrackerLine"
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.12
    line.Size = UDim2.fromOffset(0, 2)
    line.Visible = false
    line.ZIndex = 20
    line.Parent = TrackerESP.ensureGui()
    TrackerESP.Lines[target] = line
    return line
end

function TrackerESP.updateLine(target, worldPosition, position, color, active, frameActive)
    if not active or not target or not target.Parent then return end
    local camera = workspace.CurrentCamera
    if not camera then return end

    local projected = camera:WorldToViewportPoint(worldPosition)
    local viewport = camera.ViewportSize
    if viewport.X <= 0 or viewport.Y <= 0 then return end

    local isTop = string.lower(tostring(position or "Bottom")) == "above"
    local startPoint = Vector2.new(viewport.X * 0.5, isTop and 0 or (viewport.Y - 1))
    local targetPoint = Vector2.new(projected.X, projected.Y)

    local targetInside = projected.Z > 0
        and targetPoint.X >= 0 and targetPoint.X <= viewport.X
        and targetPoint.Y >= 0 and targetPoint.Y <= viewport.Y
    if not targetInside then
        local existing = TrackerESP.Lines[target]
        if existing and existing.Parent then existing.Visible = false end
        return
    end

    local delta = targetPoint - startPoint
    local length = delta.Magnitude
    local line = TrackerESP.lineFor(target)
    if length < 1 then
        line.Visible = false
        return
    end

    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.fromOffset(
        (startPoint.X + targetPoint.X) * 0.5,
        (startPoint.Y + targetPoint.Y) * 0.5
    )
    line.Size = UDim2.fromOffset(length, 2)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.Visible = true
    frameActive[target] = true
end

RunService.RenderStepped:Connect(function()
    if not State.ItemTracker and not State.PlayerTracker and next(TrackerESP.Lines) == nil then return end
    local frameActive = {}

    if State.ItemTracker then
        for part, data in pairs(Tracked) do
            if part and part.Parent and part:IsDescendantOf(workspace)
                and Utils.validPos(part) and not Utils.invisible(part)
                and not ItemESP.isPlayerOwned(data and data.Obj, part) then
                TrackerESP.updateLine(
                    part,
                    part.Position,
                    Config.Esp.ItemTrackerPosition,
                    ItemESP.colorFor(data and data.Name or part.Name),
                    true,
                    frameActive
                )
            end
        end
    end

    if State.PlayerTracker then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local character = player.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root = character:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoid.Health > 0 and root then
                    TrackerESP.updateLine(
                        player,
                        root.Position + Vector3.new(0, 1.5, 0),
                        Config.Esp.PlayerTrackerPosition,
                        Config.Esp.PlayerFillColor,
                        true,
                        frameActive
                    )
                end
            end
        end
    end

    for target, line in pairs(TrackerESP.Lines) do
        if not frameActive[target] then
            if line and line.Parent then line.Visible = false end
            if not target or not target.Parent then
                if line then line:Destroy() end
                TrackerESP.Lines[target] = nil
            end
        end
    end
end)

local Selling = {}

local items = {}
local maxLimits = {
    ["Mysterious Arrow"] = 25,
    ["Rokakaka"] = 25,
    ["Gold Coin"] = 45,
    ["Diamond"] = 25,
    ["Pure Rokakaka"] = 999,
    ["Quinton's Glove"] = 10,
    ["Steel Ball"] = 10,
    ["Rib Cage of The Saint's Corpse"] = 10,
    ["Zepellin's Headband"] = 10,
    ["Zeppeli's Hat"] = 10,
    ["Caesar's Headband"] = 10,
    ["Clackers"] = 10,
    ["Stone Mask"] = 10,
    ["Ancient Scroll"] = 10,
    ["Dio's Diary"] = 10,
    ["Lucky Stone Mask"] = 999,
    ["Lucky Arrow"] = 999,
    ["Gold Umbrella"] = 999,
    ["Christmas Present"] = 999,
}

local nonSellable = {
    "Blue Candy", "Red Candy", "Green Candy", "Yellow Candy",
    "Lucky Arrow", "Lucky Stone Mask", "Christmas Present",
}
local nonSellableLookup = {}
for _, name in ipairs(nonSellable) do
    nonSellableLookup[name] = true
end

local itemOptions = {}
local seenOptions = {}
for name in pairs(maxLimits) do
    table.insert(itemOptions, name)
    seenOptions[name] = true
end
for _, name in ipairs(nonSellable) do
    if not seenOptions[name] then
        table.insert(itemOptions, name)
        seenOptions[name] = true
    end
end
table.sort(itemOptions)

local worthlessItems = {
    "Gold Coin", "Diamond", "Quinton's Glove", "Zeppeli's Hat",
    "Caesar's Headband", "Ancient Scroll",
}
local selectedAutoSellItems = {}
local selectedSellAllItems = {}
local autoSellMax = CHOPA_HAS_CONFIG
local autoSellSelected = false
local autoSellAllSelectedLoop = false
local autoSellInterval = 3
local autoSellLoopToken = 0
local pendingPickupChecks = {}
-- Chopa: "Auto Sell" — sell every sellable item the moment it is picked up (on by default, no interval).
-- Lucky Arrow, Lucky Stone Mask, candies and presents are never sold (nonSellable).
Selling.everything = CHOPA_HAS_CONFIG          -- new user (no config): off
function Selling.pickupOn()
    local agent = _G.__ChopaAgent
    if agent and agent.delivering then return false end      -- never sell while handing money to a buyer
    return autoSellSelected or Selling.everything == true
end

local function notifySelling(title, content)
    pcall(function()
        AirflowCompat:Notify({
            Title = title or "Selling",
            Content = content or "",
            Type = "Info",
            Duration = 3,
        })
    end)
end

local function countInventoryName(name)
    local count = 0
    local seenTools = {}
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then table.insert(containers, backpack) end

    for _, container in ipairs(containers) do
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") and object.Name == name and not seenTools[object] then
                seenTools[object] = true
                count += 1
            end
        end
    end
    return count
end

function Selling.updateItems()
    table.clear(items)
    for name in pairs(maxLimits) do
        items[name] = countInventoryName(name)
    end
    return items
end

-- Chopa: items the user never wants sold (Auto-Farm → Automation → "Never sell")
Selling.blacklist = {}
for _, n in ipairs(chopaReadList(CHOPA_SELL_BLACKLIST_FILE)) do Selling.blacklist[n] = true end

function Selling.allowed(name)
    if SELLABLE[name] ~= true or nonSellableLookup[name] or Selling.blacklist[name] then return false end
    -- Chopa: never sell what an order still has to get, or what Jack's auto buy collects for FunPay
    local A, key = _G.__ChopaAgent, (tostring(name):lower():gsub("[^%w]", ""))
    if A and ((A.keepQueue and A.keepQueue[key]) or (A.keepJack and A.keepJack[key])) then return false end
    return true
end

function Selling.tools()
    local list = {}
    local seenTools = {}
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then table.insert(containers, backpack) end

    for _, container in ipairs(containers) do
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") and Selling.allowed(object.Name) and not seenTools[object] then
                seenTools[object] = true
                table.insert(list, object)
            end
        end
    end
    return list
end

function Selling.inventoryCount()
    local count = 0
    local seenTools = {}
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then table.insert(containers, backpack) end

    for _, container in ipairs(containers) do
        for _, object in ipairs(container:GetChildren()) do
            if object:IsA("Tool") and not seenTools[object] then
                seenTools[object] = true
                count += 1
            end
        end
    end
    return count
end

function Selling.find(name)
    local character = LP.Character
    local tool = character and character:FindFirstChild(name)
    if tool and tool:IsA("Tool") then return tool end
    local backpack = LP:FindFirstChild("Backpack")
    tool = backpack and backpack:FindFirstChild(name)
    if tool and tool:IsA("Tool") then return tool end
    return nil
end

function Selling.equip(tool)
    if not tool or not tool.Parent then return false end
    local character = LP.Character
    if not character then return false end
    if tool.Parent == character then return true end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local ok = pcall(function()
        humanoid:EquipTool(tool)
    end)
    if not ok then return false end
    task.wait(0.03)
    return tool.Parent == character
end

function Selling.merchantRemote()
    local character = LP.Character
    local remote = character and character:FindFirstChild("RemoteEvent")
    local dialogueFolder = ReplicatedStorage:FindFirstChild("Dialogue")
    local merchant = dialogueFolder and dialogueFolder:FindFirstChild("Merchant")
    if remote and remote:IsA("RemoteEvent") and merchant then
        return remote, merchant
    end
    return nil, nil
end

function Selling.openMerchant()
    local remote, merchant = Selling.merchantRemote()
    if not remote or not merchant then return false end

    if Gui.currentDialogue() then return false end

    local ok = pcall(function()
        remote:FireServer("PromptTriggered", merchant)
    end)
    if not ok then return false end

    local gui = Gui.waitDialogue(3)
    return gui ~= nil and Gui.dialogueActive(gui)
end

function Selling.inInventory(tool)
    if not tool then return false end
    local character = LP.Character
    local backpack = LP:FindFirstChild("Backpack")
    return tool.Parent == character or tool.Parent == backpack
end

function Selling.clickOptionAndWait(optionName, timeout)
    local deadline = tick() + (tonumber(timeout) or 8)
    while tick() < deadline do
        local gui = Gui.currentDialogue()
        if not gui then
            task.wait()
        else
            local option = Gui.option(gui, optionName)
            if option and option.Parent and Gui.isVisible(option) then
                local before = Gui.dialogueSignature(gui)
                if Gui.click(option) then
                    local transitionDeadline = math.min(deadline, tick() + 1.1)
                    repeat
                        task.wait()
                        local current = Gui.currentDialogue()
                        if not current then return true end
                        local after = Gui.dialogueSignature(current)
                        local currentOption = Gui.option(current, optionName)
                        if after ~= before or not currentOption or not Gui.isVisible(currentOption) then
                            return true
                        end
                    until tick() >= transitionDeadline
                end
            elseif not Gui.hasVisibleOptions(gui) then
                Gui.skipClick()
                task.wait()
            else
                task.wait()
            end
        end
    end
    return false
end

function Selling.sell(toolName, targetTool)
    local tool = targetTool
    if not tool and type(toolName) == "string" then
        tool = Selling.find(toolName)
    end
    if not tool or not tool:IsA("Tool") or not Selling.inInventory(tool) then
        return false
    end
    if not Selling.allowed(tool.Name) then
        return false
    end

    if Gui.currentDialogue() then return false end

    Selling.equip(tool)
    task.wait()
    if not Selling.inInventory(tool) then return true end
    if Gui.currentDialogue() then return false end

    local ownedDialogue = nil
    local function abortSell()
        local current = Gui.currentDialogue()
        if ownedDialogue and current == ownedDialogue then
            for _ = 1, 3 do
                pcall(Gui.skipClick)
                task.wait(0.1)
                if not Gui.currentDialogue() then break end
            end
        end
        return false
    end

    if not Selling.openMerchant() then return false end
    ownedDialogue = Gui.currentDialogue()
    if not ownedDialogue then return false end
    if not Selling.clickOptionAndWait("Option1", 8) then return abortSell() end
    task.wait(0.04)

    local remote, merchant = Selling.merchantRemote()
    if not remote or not merchant then return abortSell() end
    local opened = pcall(function()
        remote:FireServer("PromptTriggered", merchant)
    end)
    if not opened or not Gui.waitDialogue(5) then return abortSell() end

    if not Selling.clickOptionAndWait("Option1", 8) then return abortSell() end
    task.wait(0.04)
    if not Selling.clickOptionAndWait("Option6", 8) then return abortSell() end

    local confirmUntil = tick() + 4
    while Selling.inInventory(tool) and tick() < confirmUntil do
        task.wait()
    end
    if Selling.inInventory(tool) then return abortSell() end
    return true
end

local function acquireSellingLock(timeout)
    local started = tick()
    timeout = timeout or 60
    while State.Selling or State.JackHold do       -- Chopa: Jack's points are spent first, then autosell
        if tick() - started >= timeout then
            return false
        end
        task.wait(0.03)
    end
    State.Selling = true
    return true
end

local function selectTools(predicate)
    local result = {}
    for _, tool in ipairs(Selling.tools()) do
        if not predicate or predicate(tool.Name) then
            table.insert(result, tool)
        end
    end
    return result
end

local function sellMatching(predicate, description, alreadyLocked)
    local ownsLock = not alreadyLocked
    if ownsLock and not acquireSellingLock(60) then
        notifySelling("Selling", "Another sell operation is still running.")
        return false
    end

    local sold = 0
    local ok, err = pcall(function()
        local maxPasses = 3
        for _ = 1, maxPasses do
            local current = selectTools(predicate)
            if #current == 0 then break end

            local soldBeforePass = sold
            for _, tool in ipairs(current) do
                if Selling.inInventory(tool) and Selling.allowed(tool.Name) and (not predicate or predicate(tool.Name)) then
                    local didSell = false
                    for attempt = 1, 2 do
                        if not Selling.inInventory(tool) then
                            didSell = true
                            sold += 1
                            break
                        end
                        local okSell, result = pcall(Selling.sell, tool.Name, tool)
                        if okSell and result then
                            didSell = true
                            sold += 1
                            break
                        end
                        if attempt < 2 then task.wait(0.35) end
                    end
                    if not didSell then task.wait(0.12) end
                end
            end

            if #selectTools(predicate) == 0 then break end
            if sold == soldBeforePass then break end
        end
    end)

    if ownsLock then State.Selling = false end
    if not ok then
        warn("[Methion] Selling failed: " .. tostring(err))
        notifySelling("Selling", "Selling stopped because an error occurred.")
        return false
    end

    Selling.updateItems()
    local remaining = #selectTools(predicate)
    if sold == 0 and remaining == 0 then
        notifySelling("Selling", "No " .. description .. " found.")
    elseif remaining > 0 then
        notifySelling("Selling", "Sold " .. sold .. " " .. description .. "; " .. remaining .. " still remain.")
    else
        notifySelling("Selling", "Sold " .. sold .. " " .. description .. ".")
    end
    return remaining == 0 and sold > 0
end

function Selling.sellAll(alreadyLocked)
    return sellMatching(nil, "items", alreadyLocked)
end

function Selling.sellAllSelected(selectedItems)
    local wanted = {}
    for _, name in ipairs(selectedItems or {}) do
        if type(name) == "string" then wanted[name] = true end
    end
    if next(wanted) == nil then
        notifySelling("Selling", "Select at least one item first.")
        return false
    end
    return sellMatching(function(name) return wanted[name] == true end, "selected items", false)
end

function Selling.sellAllWorthless()
    local wanted = {}
    for _, name in ipairs(worthlessItems) do wanted[name] = true end
    return sellMatching(function(name) return wanted[name] == true end, "worthless items", false)
end

function Selling.sellInventory()
    return sellMatching(nil, "items from inventory", false)
end

function Selling.checkAndSellMax()
    if not autoSellMax then return false end
    local agent = _G.__ChopaAgent
    if agent and agent.delivering then return false end      -- never sell while handing an order to a buyer
    if not acquireSellingLock(60) then return false end

    local soldSummary = {}
    local ok, err = pcall(function()
        Selling.updateItems()
        for _, name in ipairs(itemOptions) do
            local limit = maxLimits[name]
            if autoSellMax and limit and Selling.allowed(name) then
                local count = countInventoryName(name)
                while autoSellMax and count >= limit do
                    local tool = Selling.find(name)
                    if not tool or not Selling.inInventory(tool) then break end
                    local didSell = false
                    for attempt = 1, 2 do
                        if not Selling.inInventory(tool) then
                            didSell = true
                            break
                        end
                        local okSell, result = pcall(Selling.sell, name, tool)
                        if okSell and result then
                            didSell = true
                            break
                        end
                        if attempt < 2 then task.wait(0.35) end
                    end
                    if not didSell then break end
                    soldSummary[name] = (soldSummary[name] or 0) + 1
                    count = countInventoryName(name)
                    task.wait(0.08)
                end
            end
        end
    end)

    State.Selling = false
    Selling.updateItems()
    if not ok then
        warn("[Methion] Auto-sell-on-max failed: " .. tostring(err))
        return false
    end

    local parts = {}
    local totalSold = 0
    for _, name in ipairs(itemOptions) do
        local amount = soldSummary[name] or 0
        if amount > 0 then
            totalSold += amount
            table.insert(parts, tostring(amount) .. "x " .. name)
        end
    end
    if totalSold > 0 then
        notifySelling("Auto Sell", "Auto sold: " .. table.concat(parts, ", "))
    end
    return totalSold > 0
end

local function selectedForAutoSell(name)
    if Selling.everything then return true end
    for _, selectedName in ipairs(selectedAutoSellItems) do
        if selectedName == name then return true end
    end
    return false
end

_G.__MethionSellingRuntime = _G.__MethionSellingRuntime or {}
local SellRuntime = _G.__MethionSellingRuntime
SellRuntime.MaxSellWorkerRunning = false
SellRuntime.MaxSellCheckQueued = false
SellRuntime.SelectedPickupQueue = {}
SellRuntime.SelectedPickupQueued = setmetatable({}, {__mode = "k"})
SellRuntime.SelectedPickupWorkerRunning = false
SellRuntime.HandledInventoryTools = setmetatable({}, {__mode = "k"})

function Selling.requestAutoSellMaxCheck()
    if not autoSellMax then return end
    SellRuntime.MaxSellCheckQueued = true
    if SellRuntime.MaxSellWorkerRunning then return end

    SellRuntime.MaxSellWorkerRunning = true
    task.spawn(function()
        while autoSellMax and SellRuntime.MaxSellCheckQueued do
            SellRuntime.MaxSellCheckQueued = false
            local ok, err = pcall(Selling.checkAndSellMax)
            if not ok then warn("[Methion] Auto-sell-on-max worker failed: " .. tostring(err)) end
            task.wait(0.15)
        end
        SellRuntime.MaxSellWorkerRunning = false
        if autoSellMax and SellRuntime.MaxSellCheckQueued then
            Selling.requestAutoSellMaxCheck()
        end
    end)
end

function Selling.requestSelectedPickupSell(item)
    if not item or not item:IsA("Tool") or not Selling.pickupOn()
        or not selectedForAutoSell(item.Name) or not Selling.allowed(item.Name) then
        return
    end
    if SellRuntime.SelectedPickupQueued[item] then return end

    SellRuntime.SelectedPickupQueued[item] = true
    table.insert(SellRuntime.SelectedPickupQueue, item)
    if SellRuntime.SelectedPickupWorkerRunning then return end

    SellRuntime.SelectedPickupWorkerRunning = true
    task.spawn(function()
        while #SellRuntime.SelectedPickupQueue > 0 do
            local tool = table.remove(SellRuntime.SelectedPickupQueue, 1)
            local failedAttempts = 0
            local sold = false
            local missingSince = nil

            while Selling.pickupOn() and tool
                and selectedForAutoSell(tool.Name) and Selling.allowed(tool.Name) do
                if not tool.Parent or not Selling.inInventory(tool) then
                    missingSince = missingSince or tick()
                    if tick() - missingSince >= 2.5 then break end
                    task.wait(0.1)
                else
                    missingSince = nil
                    if Gui.currentDialogue() then
                        task.wait(0.3)
                    elseif acquireSellingLock(1) then
                        if Gui.currentDialogue() then
                            State.Selling = false
                            task.wait(0.3)
                        else
                            local okSell, didSell = pcall(Selling.sell, tool.Name, tool)
                            State.Selling = false
                            if okSell and didSell then
                                sold = true
                                if not Selling.everything then
                                    notifySelling("Auto Sell", "Auto sold " .. tool.Name .. " on pickup.")
                                end
                                break
                            end

                            failedAttempts = math.min(failedAttempts + 1, 12)
                            local backoff = math.min(4, 0.35 * failedAttempts)
                            task.wait(backoff)
                        end
                    else
                        task.wait(0.2)
                    end
                end
            end

            SellRuntime.SelectedPickupQueued[tool] = nil
            if not sold and tool and tool.Parent and Selling.inInventory(tool)
                and Selling.pickupOn() and selectedForAutoSell(tool.Name)
                and Selling.allowed(tool.Name) then
                task.wait(0.5)
                if not SellRuntime.SelectedPickupQueued[tool] then
                    SellRuntime.SelectedPickupQueued[tool] = true
                    table.insert(SellRuntime.SelectedPickupQueue, tool)
                end
            end
            if not sold then task.wait(0.05) end
        end
        SellRuntime.SelectedPickupWorkerRunning = false
    end)
end

local function handleInventoryAdded(item)
    if not item or not item:IsA("Tool") or SellRuntime.HandledInventoryTools[item] then return end
    SellRuntime.HandledInventoryTools[item] = true
    pendingPickupChecks[item] = true

    task.spawn(function()
        task.wait(Selling.everything and 0.05 or 0.2)
        if autoSellMax then Selling.requestAutoSellMaxCheck() end
        if Selling.pickupOn() and selectedForAutoSell(item.Name) and Selling.allowed(item.Name) then
            Selling.requestSelectedPickupSell(item)
        end
        pendingPickupChecks[item] = nil
    end)
end

local backpack = LP:FindFirstChild("Backpack") or LP:WaitForChild("Backpack", 10)
if backpack then
    backpack.ChildAdded:Connect(handleInventoryAdded)
end

local function connectCharacterInventory(character)
    if not character then return end
    character.ChildAdded:Connect(handleInventoryAdded)
end
if LP.Character then connectCharacterInventory(LP.Character) end
LP.CharacterAdded:Connect(connectCharacterInventory)

function Selling.sweepEverything()
    if not Selling.everything then return end
    for _, tool in ipairs(Selling.tools()) do
        if not SellRuntime.SelectedPickupQueued[tool] then Selling.requestSelectedPickupSell(tool) end
    end
end
task.spawn(function()
    while true do
        task.wait(1)
        pcall(Selling.sweepEverything)
    end
end)

function Selling.hasMaxedItems()
    if not autoSellMax then return false end
    for name, limit in pairs(maxLimits) do
        if limit and Selling.allowed(name) and countInventoryName(name) >= limit then
            return true
        end
    end
    return false
end

task.spawn(function()
    while true do
        task.wait(3)
        if autoSellMax and Selling.hasMaxedItems() then
            Selling.requestAutoSellMaxCheck()
        end
    end
end)

pcall(function()
    local env = type(getgenv) == "function" and getgenv() or _G
    env.MethionSelling = {
        items = items,
        maxLimits = maxLimits,
        nonSellable = nonSellable,
        itemOptions = itemOptions,
        worthlessItems = worthlessItems,
        updateItems = Selling.updateItems,
        sellItem = Selling.sell,
        sellAll = Selling.sellAll,
        sellAllSelected = Selling.sellAllSelected,
        sellAllWorthless = Selling.sellAllWorthless,
        sellInventory = Selling.sellInventory,
        checkAndSellMax = Selling.checkAndSellMax,
    }
end)

local Move = {}

function Move.flyCF(cf, speed, shouldContinue)
    local requestedSpeed = tonumber(speed) or tonumber(Config.TweenSpeed) or 220

    speed = math.clamp(requestedSpeed, 10, 500)

    local targetCFrame = typeof(cf) == "Vector3" and CFrame.new(cf) or cf
    if typeof(targetCFrame) ~= "CFrame" then return false end

    local ch = LP.Character or LP.CharacterAdded:Wait()
    local root = ch and ch:FindFirstChild("HumanoidRootPart")
    if not root then root = ch:WaitForChild("HumanoidRootPart", 5) end
    if not root or not root.Parent then return false end

    local distance = (targetCFrame.Position - root.Position).Magnitude
    if distance <= 0.001 then
        root.CFrame = targetCFrame
        return true
    end

    State.TweenRunning = true
    State.NoClip = true

    local anchor = Instance.new("Part")
    anchor.Name = "MethionAutoFarmTweenAnchor"
    anchor.Anchored = true
    anchor.CanCollide = false
    anchor.CanTouch = false
    anchor.CanQuery = false
    anchor.Transparency = 1
    anchor.Size = Vector3.one
    anchor.CFrame = root.CFrame
    anchor.Parent = workspace

    local duration = distance / speed
    local tween = TweenService:Create(
        anchor,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {CFrame = targetCFrame}
    )

    local cancelled = false
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if cancelled then return end
        if not anchor.Parent or not root.Parent or LP.Character ~= ch then
            cancelled = true
            pcall(function() tween:Cancel() end)
            return
        end

        root.CFrame = anchor.CFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        if shouldContinue then
            local ok, keepMoving = pcall(shouldContinue)
            if not ok or not keepMoving then
                cancelled = true
                pcall(function() tween:Cancel() end)
            end
        end
    end)

    local playbackState
    local waitOk = pcall(function()
        tween:Play()
        playbackState = tween.Completed:Wait()
    end)

    if connection then
        pcall(function() connection:Disconnect() end)
    end
    pcall(function() tween:Cancel() end)
    if anchor.Parent then pcall(function() anchor:Destroy() end) end

    local completed = waitOk and playbackState == Enum.PlaybackState.Completed and not cancelled
    if completed and root.Parent and LP.Character == ch then
        root.CFrame = targetCFrame
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    State.TweenRunning = false
    State.NoClip = false
    if completed then task.wait(0.05) end
    return completed
end

function Move.flyPart(part)
    if not part or not part.Parent then return false end
    return Move.flyCF(CFrame.new(part.Position))
end

function Move.flySafe()
    return Move.flyCF(CFrame.new(Config.SafeZone))
end

function Move.teleCF(cf)

    if not bypassSupported then
        return Move.flyCF(cf, Config.TweenSpeed)
    end

    local ch = LP.Character or LP.CharacterAdded:Wait()
    local root = ch:WaitForChild("HumanoidRootPart", 5)
    if not root then return false end
    local old = State.NoClip
    State.NoClip = true
    root.CFrame = cf
    root.Velocity = Vector3.new()
    root.RotVelocity = Vector3.new()
    task.wait(.05)
    State.NoClip = old
    return true
end

function Move.telePart(part)
    if not part or not part.Parent or not part:IsDescendantOf(workspace) then return false end
    if not bypassSupported then
        return Move.flyCF(CFrame.new(part.Position + Vector3.new(0, 3, 0)), Config.TweenSpeed)
    end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    return true
end

function Move.teleSafe()
    return Move.teleCF(CFrame.new(Config.SafeZone))
end

function Move.goToCF(cf, mode)
    if typeof(cf) ~= "CFrame" then return false end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    Config.Teleport.LastPosition = root.CFrame
    local selectedMode = mode or Config.Teleport.Mode
    if selectedMode == "Instant" and not bypassSupported then
        Config.Teleport.Mode = "Tween"
        selectedMode = "Tween"
    end
    if selectedMode == "Tween" then
        return Move.flyCF(cf, Config.TweenSpeed)
    end
    return Move.teleCF(cf)
end

local FarmVisual = {
    OriginalVisuals = setmetatable({}, {__mode = "k"}),
    AnimationMap = setmetatable({}, {__mode = "k"}),
    DecoyUpdateConnection = nil,
    FallbackWalkTrack = nil,
    FallbackWalkAnimation = nil,
    CameraBindBefore = "Phantom_Farm_Decoy_Camera_Before",
    CameraBindAfter = "Phantom_Farm_Decoy_Camera_After",
}

local function hideFarmVisual(instance)
    if not instance or not instance.Parent then return end

    if instance:IsA("BasePart") then
        if FarmVisual.OriginalVisuals[instance] == nil then
            FarmVisual.OriginalVisuals[instance] = {
                Kind = "BasePart",
                LocalTransparencyModifier = instance.LocalTransparencyModifier,
                Transparency = instance.Transparency,
            }
        end
        pcall(function()
            instance.LocalTransparencyModifier = 1
            instance.Transparency = 1
        end)
    elseif instance:IsA("Decal") or instance:IsA("Texture") then
        if FarmVisual.OriginalVisuals[instance] == nil then
            FarmVisual.OriginalVisuals[instance] = {
                Kind = "Texture",
                Transparency = instance.Transparency,
            }
        end
        pcall(function() instance.Transparency = 1 end)
    end
end

function FarmVisual.isActive()
    return FarmVisual.Character == LP.Character
        and FarmVisual.Decoy ~= nil
        and FarmVisual.Decoy.Parent ~= nil
        and FarmVisual.DecoyHumanoid ~= nil
        and FarmVisual.DecoyHumanoid.Parent ~= nil
end

function FarmVisual.cleanup()
    pcall(function()
        RunService:UnbindFromRenderStep(FarmVisual.CameraBindBefore)
        RunService:UnbindFromRenderStep(FarmVisual.CameraBindAfter)
    end)

    if FarmVisual.CharacterConnection then
        pcall(function() FarmVisual.CharacterConnection:Disconnect() end)
        FarmVisual.CharacterConnection = nil
    end
    if FarmVisual.DecoyUpdateConnection then
        pcall(function() FarmVisual.DecoyUpdateConnection:Disconnect() end)
        FarmVisual.DecoyUpdateConnection = nil
    end
    for _, entry in pairs(FarmVisual.AnimationMap or {}) do
        if type(entry) == "table" then
            if entry.Track then
                pcall(function() entry.Track:Stop(0) end)
                pcall(function() entry.Track:Destroy() end)
            end
            if entry.Animation then
                pcall(function() entry.Animation:Destroy() end)
            end
        end
    end
    FarmVisual.AnimationMap = setmetatable({}, {__mode = "k"})
    if FarmVisual.FallbackWalkTrack then
        pcall(function() FarmVisual.FallbackWalkTrack:Stop(0) end)
        pcall(function() FarmVisual.FallbackWalkTrack:Destroy() end)
        FarmVisual.FallbackWalkTrack = nil
    end
    if FarmVisual.FallbackWalkAnimation then
        pcall(function() FarmVisual.FallbackWalkAnimation:Destroy() end)
        FarmVisual.FallbackWalkAnimation = nil
    end

    for instance, saved in pairs(FarmVisual.OriginalVisuals or {}) do
        if instance and instance.Parent and type(saved) == "table" then
            pcall(function()
                if saved.Kind == "BasePart" then
                    instance.LocalTransparencyModifier = saved.LocalTransparencyModifier
                    instance.Transparency = saved.Transparency
                elseif saved.Kind == "Texture" then
                    instance.Transparency = saved.Transparency
                end
            end)
        end
    end
    FarmVisual.OriginalVisuals = setmetatable({}, {__mode = "k"})

    local wasActive = FarmVisual.Decoy ~= nil
    local previousSubject = FarmVisual.PreviousCameraSubject
    local previousCameraType = FarmVisual.PreviousCameraType
    local decoy = FarmVisual.Decoy

    FarmVisual.Character = nil
    FarmVisual.Decoy = nil
    FarmVisual.DecoyHumanoid = nil
    FarmVisual.DecoyRoot = nil
    FarmVisual.PreviousCameraSubject = nil
    FarmVisual.PreviousCameraType = nil

    if decoy then
        pcall(function() decoy:Destroy() end)
    end

    if wasActive then
        local camera = workspace.CurrentCamera
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if camera then
            pcall(function()
                camera.CameraType = previousCameraType or Enum.CameraType.Custom
                local subject = humanoid or previousSubject
                if subject and subject.Parent then
                    camera.CameraSubject = subject
                end
            end)
        end
    end
end

function FarmVisual.showSafeZoneDecoy()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid then return false end
    if FarmVisual.isActive() then return true end

    FarmVisual.cleanup()

    local wasArchivable = character.Archivable
    local ok, decoy
    pcall(function() character.Archivable = true end)
    ok, decoy = pcall(function() return character:Clone() end)
    pcall(function() character.Archivable = wasArchivable end)
    if not ok or not decoy or not decoy:IsA("Model") then
        return false
    end

    decoy.Name = "Phantom_FarmSafeZoneDecoy"
    local decoyRoot = decoy:FindFirstChild("HumanoidRootPart")
    local decoyHumanoid = decoy:FindFirstChildOfClass("Humanoid")
    if not decoyRoot or not decoyHumanoid then
        pcall(function() decoy:Destroy() end)
        return false
    end

    for _, descendant in ipairs(decoy:GetDescendants()) do
        if descendant:IsA("Script") or descendant:IsA("LocalScript") or descendant:IsA("ModuleScript")
            or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("ParticleEmitter")
            or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
            pcall(function() descendant:Destroy() end)
        elseif descendant:IsA("BasePart") then
            pcall(function()
                descendant.LocalTransparencyModifier = 0

                descendant.Anchored = descendant == decoyRoot
                descendant.CanCollide = false
                descendant.CanTouch = false
                descendant.CanQuery = false
                descendant.Massless = descendant ~= decoyRoot
            end)
        end
    end

    pcall(function()
        decoyHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        decoyHumanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        decoyHumanoid.BreakJointsOnDeath = false
        decoyHumanoid.AutoRotate = false
        decoyHumanoid.PlatformStand = false
        decoyHumanoid.Sit = false
        decoyHumanoid.WalkSpeed = humanoid.WalkSpeed
        decoyHumanoid.JumpPower = humanoid.JumpPower
        decoyHumanoid.UseJumpPower = humanoid.UseJumpPower
    end)

    local safeRootCFrame = CFrame.new(Config.SafeZone) * root.CFrame.Rotation
    local pivotOffset = root.CFrame:ToObjectSpace(character:GetPivot())
    decoy.Parent = workspace
    decoy:PivotTo(safeRootCFrame * pivotOffset)

    FarmVisual.Character = character
    FarmVisual.Decoy = decoy
    FarmVisual.DecoyHumanoid = decoyHumanoid
    FarmVisual.DecoyRoot = decoyRoot
    FarmVisual.AnimationMap = setmetatable({}, {__mode = "k"})
    FarmVisual.OriginalVisuals = setmetatable({}, {__mode = "k"})

    local decoyAnimator = decoyHumanoid:FindFirstChildOfClass("Animator")
    if not decoyAnimator then
        decoyAnimator = Instance.new("Animator")
        decoyAnimator.Parent = decoyHumanoid
    end

    local function findWalkAnimationId()
        local animateScript = character:FindFirstChild("Animate")
        if not animateScript then return nil end
        local fallbackRun
        for _, animationObject in ipairs(animateScript:GetDescendants()) do
            if animationObject:IsA("Animation") and animationObject.AnimationId ~= "" then
                local name = string.lower(animationObject.Name or "")
                if name == "walkanim" or name == "walk" or name:find("walk", 1, true) then
                    return animationObject.AnimationId
                elseif (name == "runanim" or name == "run" or name:find("run", 1, true)) and not fallbackRun then
                    fallbackRun = animationObject.AnimationId
                end
            end
        end
        return fallbackRun
    end

    local fallbackWalkId = findWalkAnimationId()
    if fallbackWalkId then
        local fallbackAnimation = Instance.new("Animation")
        fallbackAnimation.Name = "Phantom_FallbackWalkAnimation"
        fallbackAnimation.AnimationId = fallbackWalkId
        local fallbackTrack
        local fallbackLoaded = pcall(function()
            fallbackTrack = decoyAnimator:LoadAnimation(fallbackAnimation)
        end)
        if fallbackLoaded and fallbackTrack then
            pcall(function()
                fallbackTrack.Priority = Enum.AnimationPriority.Movement
                fallbackTrack.Looped = true
            end)
            FarmVisual.FallbackWalkAnimation = fallbackAnimation
            FarmVisual.FallbackWalkTrack = fallbackTrack
        else
            pcall(function() fallbackAnimation:Destroy() end)
        end
    end

    local nextAnimationSync = 0
    local function syncCurrentAnimations()
        local sourceAnimator = humanoid.Parent and humanoid:FindFirstChildOfClass("Animator")
        local visualAnimator = decoyHumanoid.Parent and decoyHumanoid:FindFirstChildOfClass("Animator")
        if not sourceAnimator or not visualAnimator then return end

        local playing = {}
        local hasMovementAnimation = false
        for _, sourceTrack in ipairs(sourceAnimator:GetPlayingAnimationTracks()) do
            if sourceTrack and sourceTrack.IsPlaying then
                if sourceTrack.Priority == Enum.AnimationPriority.Movement then
                    hasMovementAnimation = true
                end
                local sourceAnimation = sourceTrack.Animation
                local animationId = sourceAnimation and sourceAnimation.AnimationId or ""
                if animationId ~= "" then
                    playing[sourceTrack] = true
                    local entry = FarmVisual.AnimationMap[sourceTrack]
                    if not entry or entry.AnimationId ~= animationId then
                        if entry then
                            if entry.Track then
                                pcall(function() entry.Track:Stop(0) end)
                                pcall(function() entry.Track:Destroy() end)
                            end
                            if entry.Animation then
                                pcall(function() entry.Animation:Destroy() end)
                            end
                        end

                        local copiedAnimation = Instance.new("Animation")
                        copiedAnimation.Name = "Phantom_MirroredAnimation"
                        copiedAnimation.AnimationId = animationId
                        local copiedTrack
                        local loaded = pcall(function()
                            copiedTrack = visualAnimator:LoadAnimation(copiedAnimation)
                        end)
                        if loaded and copiedTrack then
                            pcall(function()
                                copiedTrack.Priority = sourceTrack.Priority
                                copiedTrack.Looped = sourceTrack.Looped
                                copiedTrack:Play(0.05, sourceTrack.WeightCurrent, sourceTrack.Speed)
                                copiedTrack.TimePosition = sourceTrack.TimePosition
                            end)
                            entry = {
                                Track = copiedTrack,
                                Animation = copiedAnimation,
                                AnimationId = animationId,
                                LastSync = 0,
                            }
                            FarmVisual.AnimationMap[sourceTrack] = entry
                        else
                            pcall(function() copiedAnimation:Destroy() end)
                            FarmVisual.AnimationMap[sourceTrack] = nil
                            entry = nil
                        end
                    end

                    if entry and entry.Track then
                        pcall(function()
                            local targetTrack = entry.Track
                            local speed = tonumber(sourceTrack.Speed) or 1
                            if targetTrack.Priority ~= sourceTrack.Priority then
                                targetTrack.Priority = sourceTrack.Priority
                            end
                            if targetTrack.Looped ~= sourceTrack.Looped then
                                targetTrack.Looped = sourceTrack.Looped
                            end
                            if not targetTrack.IsPlaying then
                                targetTrack:Play(0.05, sourceTrack.WeightCurrent, speed)
                            end
                            targetTrack:AdjustSpeed(speed)
                            if math.abs(targetTrack.TimePosition - sourceTrack.TimePosition) > 0.14 then
                                targetTrack.TimePosition = sourceTrack.TimePosition
                            end
                            local targetWeight = tonumber(sourceTrack.WeightTarget) or 1
                            if math.abs(targetTrack.WeightTarget - targetWeight) > 0.05 then
                                targetTrack:AdjustWeight(targetWeight, 0.06)
                            end
                        end)
                    end
                end
            end
        end

        for sourceTrack, entry in pairs(FarmVisual.AnimationMap) do
            if not playing[sourceTrack] then
                if entry.Track then
                    pcall(function() entry.Track:Stop(0.08) end)
                    pcall(function() entry.Track:Destroy() end)
                end
                if entry.Animation then
                    pcall(function() entry.Animation:Destroy() end)
                end
                FarmVisual.AnimationMap[sourceTrack] = nil
            end
        end

        local movement = humanoid.MoveDirection
        local isMoving = Vector3.new(movement.X, 0, movement.Z).Magnitude > 0.04
        local fallbackTrack = FarmVisual.FallbackWalkTrack
        if fallbackTrack then
            if isMoving and not hasMovementAnimation then
                if not fallbackTrack.IsPlaying then
                    pcall(function() fallbackTrack:Play(0.08, 1, 1) end)
                end
                pcall(function()
                    fallbackTrack:AdjustSpeed(math.clamp((tonumber(humanoid.WalkSpeed) or 16) / 16, 0.5, 2.5))
                end)
            elseif fallbackTrack.IsPlaying then
                pcall(function() fallbackTrack:Stop(0.08) end)
            end
        end
    end

    FarmVisual.DecoyUpdateConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if FarmVisual.Decoy ~= decoy or not decoy.Parent
            or FarmVisual.Character ~= character or LP.Character ~= character
            or not decoyRoot.Parent or not humanoid.Parent then
            return
        end

        local movement = humanoid.MoveDirection
        local horizontal = Vector3.new(movement.X, 0, movement.Z)
        if horizontal.Magnitude > 0.04 then
            local direction = horizontal.Unit
            local currentPivot = decoy:GetPivot()
            local speed = math.clamp(tonumber(humanoid.WalkSpeed) or 16, 0, 80)
            local step = math.min(math.max(tonumber(deltaTime) or 0, 0), 0.05)
            local nextPosition = currentPivot.Position + direction * speed * step
            local nextPivot = CFrame.lookAt(nextPosition, nextPosition + direction)
            pcall(function() decoy:PivotTo(nextPivot) end)
        end

        local now = os.clock()
        if now >= nextAnimationSync then
            nextAnimationSync = now + 0.05
            pcall(syncCurrentAnimations)
        end
    end)

    for _, descendant in ipairs(character:GetDescendants()) do
        hideFarmVisual(descendant)
    end

    FarmVisual.CharacterConnection = character.DescendantAdded:Connect(function(descendant)
        if FarmVisual.Character == character and FarmVisual.Decoy == decoy then
            hideFarmVisual(descendant)
        end
    end)

    local camera = workspace.CurrentCamera
    if camera then
        FarmVisual.PreviousCameraSubject = camera.CameraSubject
        FarmVisual.PreviousCameraType = camera.CameraType
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = decoyHumanoid
        end)
    end

    local function maintainDecoyCamera()
        if FarmVisual.Decoy ~= decoy or not decoy.Parent or not decoyHumanoid.Parent then
            return
        end

        for instance, saved in pairs(FarmVisual.OriginalVisuals or {}) do
            if instance and instance.Parent and type(saved) == "table" then
                pcall(function()
                    if saved.Kind == "BasePart" then
                        if instance.LocalTransparencyModifier ~= 1 then
                            instance.LocalTransparencyModifier = 1
                        end
                        if instance.Transparency ~= 1 then
                            instance.Transparency = 1
                        end
                    elseif saved.Kind == "Texture" and instance.Transparency ~= 1 then
                        instance.Transparency = 1
                    end
                end)
            end
        end

        local currentCamera = workspace.CurrentCamera
        if currentCamera then
            pcall(function()
                if currentCamera.CameraType ~= Enum.CameraType.Custom then
                    currentCamera.CameraType = Enum.CameraType.Custom
                end
                if currentCamera.CameraSubject ~= decoyHumanoid then
                    currentCamera.CameraSubject = decoyHumanoid
                end
            end)
        end
    end

    pcall(function()
        RunService:BindToRenderStep(
            FarmVisual.CameraBindBefore,
            Enum.RenderPriority.Camera.Value - 1,
            maintainDecoyCamera
        )
        RunService:BindToRenderStep(
            FarmVisual.CameraBindAfter,
            Enum.RenderPriority.Camera.Value + 1,
            maintainDecoyCamera
        )
        maintainDecoyCamera()
    end)

    return true
end

function FarmVisual.restoreAtSafe()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and (root.Position - Config.SafeZone).Magnitude > 6 then
        Move.teleSafe()
    end
    FarmVisual.cleanup()
    return root ~= nil
end

local Farm = {}

function Farm.isActive()
    return (State.Farm == true or State.HalloweenCandyFarm == true)
        and State.HalloweenTurnInBusy ~= true
        and _G.__MethionSHPreloading ~= true
end

Farm.PendingBoostedTarget = nil
Farm.PendingBoostedTargets = {}
Farm.BoostedTargetQueued = setmetatable({}, {__mode = "k"})
Farm.BoostedTargetSeen = setmetatable({}, {__mode = "k"})
Farm.BoostedTargetQueueLifetime = 12

local function refreshPendingBoostedTarget()
    Farm.PendingBoostedTarget = nil
    for index = #Farm.PendingBoostedTargets, 1, -1 do
        local entry = Farm.PendingBoostedTargets[index]
        if entry and entry.Part and entry.Part.Parent then
            Farm.PendingBoostedTarget = entry.Part
            break
        end
    end
end

function Farm.queueBoostedTarget(part)
    if not part or not part.Parent or not part:IsDescendantOf(workspace)
        or ItemESP.isPlayerOwned(nil, part) then
        return false
    end
    if Farm.BoostedTargetQueued[part] or Farm.BoostedTargetSeen[part] then
        return false
    end

    Farm.BoostedTargetQueued[part] = true
    Farm.BoostedTargetSeen[part] = true
    table.insert(Farm.PendingBoostedTargets, {
        Part = part,
        AddedAt = os.clock(),
    })
    Farm.PendingBoostedTarget = part
    return true
end

function Farm.nextReadyBoostedTarget(exceptPart, now, consume)
    now = now or tick()
    local queue = Farm.PendingBoostedTargets
    local currentClock = os.clock()

    for index = #queue, 1, -1 do
        local entry = queue[index]
        local part = entry and entry.Part
        local data = part and Tracked[part]
        local expired = not entry or currentClock - (entry.AddedAt or currentClock) > Farm.BoostedTargetQueueLifetime
        local playerOwned = part and ItemESP.isPlayerOwned(nil, part)
        local disallowed = data and not Farm.allowed(data.Name)
        if not part or not part.Parent or not part:IsDescendantOf(workspace)
            or expired or disallowed or playerOwned then
            if part then Farm.BoostedTargetQueued[part] = nil end
            table.remove(queue, index)
        end
    end

    for index, entry in ipairs(queue) do
        local part = entry and entry.Part
        local data = part and Tracked[part]
        if part and part ~= exceptPart and data
            and Farm.allowed(data.Name)
            and not ItemESP.isPlayerOwned(nil, part)
            and Utils.validPos(part) and not Utils.invisible(part)
            and (not data.FarmRetryAt or data.FarmRetryAt <= now) then
            if consume then
                Farm.BoostedTargetQueued[part] = nil
                table.remove(queue, index)
                refreshPendingBoostedTarget()
            end
            return part, data
        end
    end

    refreshPendingBoostedTarget()
    return nil
end

function Farm.allowed(name)
    if State.HalloweenCandyFarm then
        return name == "Green Candy" or name == "Red Candy"
            or name == "Blue Candy" or name == "Yellow Candy"
    end

    local filter = Config.FarmOnlyItems
    if not filter or #filter == 0 then return true end
    for _, n in ipairs(filter) do
        if n == "All items" or n == name then return true end
    end
    return false
end

local FARM_PRIORITY = {"Lucky Arrow", "Lucky Stone Mask", "Christmas Present"}

function Farm.priority(name)
    if not Farm.allowed(name) then return false end
    for _, n in ipairs(FARM_PRIORITY) do
        if n == name then return true end
    end
    return false
end

function Farm.nearest()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local now = tick()
    local nearest, nearestPart, nearestData, nearestDist = nil, nil, nil, math.huge
    local priorityItem, priorityPart, priorityData, priorityDist = nil, nil, nil, math.huge
    local origin = root.Position

    if State.Farm and Config.Boosted then
        local pending, data = Farm.nextReadyBoostedTarget(nil, now, true)
        if pending and data then
            local candidate = pending:FindFirstAncestorOfClass("Model") or pending
            if _G.__PhantomQuestFarmSetItemViewerTarget then
                pcall(_G.__PhantomQuestFarmSetItemViewerTarget, candidate)
            end
            return candidate, pending, data
        end
    end

    for part, data in pairs(Tracked) do
        if part and part:IsDescendantOf(workspace) and Utils.validPos(part)
            and not ItemESP.isPlayerOwned(data.Obj, part)
            and not Utils.invisible(part) and Farm.allowed(data.Name)
            and (not data.FarmRetryAt or data.FarmRetryAt <= now) then
            local distance = (part.Position - origin).Magnitude
            local candidate = part:FindFirstAncestorOfClass("Model") or part

            if distance < nearestDist then
                nearestDist = distance
                nearest = candidate
                nearestPart = part
                nearestData = data
            end

            if Farm.priority(data.Name) and distance < priorityDist then
                priorityDist = distance
                priorityItem = candidate
                priorityPart = part
                priorityData = data
            end
        end
    end

    local chosenItem = priorityItem or nearest
    local chosenPart = priorityPart or nearestPart
    local chosenData = priorityData or nearestData
    if chosenItem and _G.__PhantomQuestFarmSetItemViewerTarget then
        pcall(_G.__PhantomQuestFarmSetItemViewerTarget, chosenItem)
    end

    return chosenItem, chosenPart, chosenData
end

function Farm.waitForArrival(part, timeout)
    timeout = math.clamp(tonumber(timeout) or 2.5, 1.0, 4.0)
    local started = os.clock()
    local expectedCharacter = LP.Character
    local previousPosition = nil
    local stableFrames = 0
    local settleTime = math.clamp(tonumber(Config.InstantDelay) or 0.35, 0.2, 1.0)

    while Farm.isActive() and part and part.Parent and part:IsDescendantOf(workspace)
        and os.clock() - started < timeout do
        local character = LP.Character
        if not character or character ~= expectedCharacter then return false end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        local targetPosition = part.Position + Vector3.new(0, 3, 0)
        if (root.Position - targetPosition).Magnitude > 0.1 then
            root.CFrame = CFrame.new(targetPosition)
        end
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        local currentPosition = root.Position
        local moved = previousPosition and (currentPosition - previousPosition).Magnitude or 0
        if (currentPosition - targetPosition).Magnitude <= 0.15 and moved <= 0.35 then
            stableFrames += 1
        else
            stableFrames = 0
        end
        previousPosition = currentPosition

        if stableFrames >= 5 then
            local settleUntil = os.clock() + settleTime
            while Farm.isActive() and part and part.Parent and part:IsDescendantOf(workspace)
                and os.clock() < settleUntil do
                character = LP.Character
                if not character or character ~= expectedCharacter then return false end
                root = character:FindFirstChild("HumanoidRootPart")
                if not root then return false end

                targetPosition = part.Position + Vector3.new(0, 3, 0)
                if (root.Position - targetPosition).Magnitude > 0.1 then
                    root.CFrame = CFrame.new(targetPosition)
                end
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end

            if not Farm.isActive() or not part or not part.Parent or not part:IsDescendantOf(workspace) then
                return false
            end
            character = LP.Character
            root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then return false end
            targetPosition = part.Position + Vector3.new(0, 3, 0)
            if (root.Position - targetPosition).Magnitude > 0.1 then
                root.CFrame = CFrame.new(targetPosition)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end

            return Farm.isActive()
                and LP.Character == expectedCharacter
                and part.Parent ~= nil
                and part:IsDescendantOf(workspace)
                and (root.Position - (part.Position + Vector3.new(0, 3, 0))).Magnitude <= 0.5
                and (part.Position - root.Position).Magnitude <= 4.0
        end

        RunService.Heartbeat:Wait()
    end

    return false
end
function Farm.triggerPickupPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt:IsA("ProximityPrompt") or prompt.Enabled == false then
        return false
    end

    local oldHoldDuration
    pcall(function()
        oldHoldDuration = prompt.HoldDuration
        prompt.HoldDuration = 0
    end)

    local function restoreHoldDuration()
        if oldHoldDuration ~= nil and prompt.Parent then
            pcall(function() prompt.HoldDuration = oldHoldDuration end)
        end
    end

    if bypassSupported and type(fireproximityprompt) == "function" then
        local ok = pcall(function()
            fireproximityprompt(prompt, 0, true)
        end)
        if not ok then
            ok = pcall(function() fireproximityprompt(prompt) end)
        end
        restoreHoldDuration()
        if ok then return true end
    end

    local fired = false
    if type(getconnections) == "function" then
        local connectionsOk, connections = pcall(function()
            return getconnections(prompt.Triggered)
        end)
        if connectionsOk and connections then
            for _, connection in pairs(connections) do
                if connection and type(connection.Fire) == "function" then
                    local connectionFired = pcall(function()
                        connection:Fire(prompt)
                    end)
                    if connectionFired then fired = true end
                end
            end
        end
    end

    if not fired and prompt.Parent then
        local inputOk = pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
        if inputOk then fired = true end
    end

    restoreHoldDuration()
    return fired
end

function Farm.pickup(model, part)
    if not model or not model.Parent then return false end
    if not part or not part.Parent or Utils.invisible(part) then return false end
    local prompt = model:FindFirstChild("ProximityPrompt") or part:FindFirstChild("ProximityPrompt")
    if not prompt then
        prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
            or part:FindFirstChildWhichIsA("ProximityPrompt", true)
    end
    if not prompt or prompt.Enabled == false then return false end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    
    if (part.Position - root.Position).Magnitude > 4.25 then return false end
    return Farm.triggerPickupPrompt(prompt)
end

function Farm.pickupBoosted(model, part, trackedData)
    if not State.Farm or not Config.Boosted or not model or not model.Parent
        or not part or not part.Parent or not part:IsDescendantOf(workspace) then
        return false
    end

    local expectedCharacter = LP.Character
    if not expectedCharacter then return false end

    local startedAt = os.clock()
    local lastPromptAt = 0
    local lastSuccessfulTriggerAt = nil
    local nextPromptAt = 0
    local stableFrames = 0
    local previousAnchors = nil
    local promptInFlight = false
    local invisibleSince = nil

    local R6_BODY_PARTS = {
        "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg",
    }
    local R15_BODY_PARTS = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot",
    }

    local function itemRemoved()
        return not part or not part.Parent or not part:IsDescendantOf(workspace)
            or (model ~= part and model and not model.Parent)
    end

    local function characterSnapshot()
        local character = LP.Character
        if not character or character ~= expectedCharacter
            or not character.Parent or not character:IsDescendantOf(workspace) then
            return nil
        end

        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or humanoid.Health <= 0
            or not root or not root:IsA("BasePart")
            or not root:IsDescendantOf(character) then
            return nil
        end

        local requiredNames = humanoid.RigType == Enum.HumanoidRigType.R6
            and R6_BODY_PARTS or R15_BODY_PARTS
        local bodyParts = {}
        for _, name in ipairs(requiredNames) do
            local bodyPart = character:FindFirstChild(name)
            if not bodyPart or not bodyPart:IsA("BasePart")
                or not bodyPart:IsDescendantOf(character) then
                return nil
            end
            bodyParts[#bodyParts + 1] = bodyPart
        end

        local head = character:FindFirstChild("Head")
        local torsoName = humanoid.RigType == Enum.HumanoidRigType.R6 and "Torso" or "UpperTorso"
        local torso = character:FindFirstChild(torsoName)
        if not head or not head:IsA("BasePart") or not torso or not torso:IsA("BasePart") then
            return nil
        end

        return character, humanoid, root, head, torso, bodyParts
    end

    local function findPrompt()
        local saved = trackedData and trackedData.Obj
        if saved and saved.Parent and saved:IsA("ProximityPrompt")
            and saved:IsDescendantOf(workspace) then
            return saved
        end

        for _, object in ipairs({model, part}) do
            if object and object.Parent then
                if object:IsA("ProximityPrompt") then return object end
                local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then return prompt end
            end
        end

        local ancestor = part:FindFirstAncestorOfClass("Model")
        return ancestor and ancestor:FindFirstChildWhichIsA("ProximityPrompt", true) or nil
    end

    local function promptAnchor(prompt)
        if prompt and prompt.Parent then
            if prompt.Parent:IsA("BasePart") then
                return prompt.Parent
            end
            local ancestorPart = prompt:FindFirstAncestorWhichIsA("BasePart")
            if ancestorPart then return ancestorPart end
            local childPart = prompt.Parent:FindFirstChildWhichIsA("BasePart", true)
            if childPart then return childPart end
        end
        return part
    end

    local function verifyCharacterAtItem(anchor)
        local character, humanoid, root, head, torso, bodyParts = characterSnapshot()
        if not character then return false end
        if not anchor or not anchor.Parent or not anchor:IsDescendantOf(workspace) then
            return false
        end

        local targetPosition = anchor.Position + Vector3.new(0, 3, 0)
        if (root.Position - targetPosition).Magnitude > 0.25
            or (anchor.Position - root.Position).Magnitude > 4.25 then
            return false
        end

        if (head.Position - root.Position).Magnitude > 8
            or (torso.Position - root.Position).Magnitude > 8 then
            return false
        end
        for _, bodyPart in ipairs(bodyParts) do
            if not bodyPart.Parent or not bodyPart:IsDescendantOf(character)
                or (bodyPart.Position - root.Position).Magnitude > 9 then
                return false
            end
        end

        return true, character, humanoid, root, head, torso, bodyParts
    end

    local function anchorsAreStable(root, head, torso)
        local current = {root.Position, head.Position, torso.Position}
        local stable = previousAnchors ~= nil
        if previousAnchors then
            for index, position in ipairs(current) do
                if (position - previousAnchors[index]).Magnitude > 0.6 then
                    stable = false
                    break
                end
            end
        end
        previousAnchors = current
        return stable
    end

    local firstPrompt = findPrompt()
    local firstAnchor = promptAnchor(firstPrompt)
    if firstAnchor and firstAnchor.Parent then
        Move.telePart(firstAnchor)
    else
        Move.telePart(part)
    end

    while State.Farm and Config.Boosted and LP.Character == expectedCharacter
        and os.clock() - startedAt < 4.0 do
        if itemRemoved() then
            ItemESP.unregister(part)
            return true
        end

        local pendingSpawn = Farm.nextReadyBoostedTarget(part, tick(), false)
        if pendingSpawn then
            if trackedData then trackedData.FarmRetryAt = tick() end
            return false
        end

        local visibleAndPositioned = Utils.validPos(part) and not Utils.invisible(part)
        if not visibleAndPositioned then
            stableFrames = 0
            previousAnchors = nil
            local nowInvisible = os.clock()
            invisibleSince = invisibleSince or nowInvisible

            if lastSuccessfulTriggerAt and nowInvisible - lastSuccessfulTriggerAt >= 0.15
                and nowInvisible - invisibleSince >= 0.12 then
                ItemESP.unregister(part)
                return true
            end
            RunService.Heartbeat:Wait()
        else
            invisibleSince = nil
            local prompt = findPrompt()
            local anchor = promptAnchor(prompt)
            local character, humanoid, root, head, torso = characterSnapshot()

            if character and humanoid and root and head and torso and anchor and anchor.Parent then
                local targetPosition = anchor.Position + Vector3.new(0, 3, 0)
                if (root.Position - targetPosition).Magnitude > 0.04 then
                    root.CFrame = CFrame.new(targetPosition)
                end
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                local verified, verifiedCharacter, verifiedHumanoid,
                    verifiedRoot, verifiedHead, verifiedTorso = verifyCharacterAtItem(anchor)
                if verified and verifiedCharacter == expectedCharacter and verifiedHumanoid.Health > 0 then
                    if anchorsAreStable(verifiedRoot, verifiedHead, verifiedTorso) then
                        stableFrames += 1
                    else
                        stableFrames = 0
                    end

                    local now = os.clock()
                    if prompt and prompt.Parent and prompt:IsA("ProximityPrompt")
                        and prompt.Enabled ~= false and stableFrames >= 3
                        and not promptInFlight and now >= nextPromptAt then
                        local referencePart = promptAnchor(prompt)
                        local maxDistance = math.max(0, tonumber(prompt.MaxActivationDistance) or 10)
                        local distance = referencePart and referencePart.Parent
                            and (referencePart.Position - verifiedRoot.Position).Magnitude or math.huge

                        if referencePart and referencePart.Parent
                            and distance <= maxDistance + 0.1 and distance <= 4.25 then
                            promptInFlight = true
                            lastPromptAt = now
                            task.spawn(function()

                                task.wait(0.27)
                                local callbackOk, callbackErr = pcall(function()
                                    local currentPromptAnchor = promptAnchor(prompt)
                                    local finalVerified, finalCharacter, finalHumanoid, finalRoot =
                                        verifyCharacterAtItem(currentPromptAnchor)
                                    local readySpawn = Farm.nextReadyBoostedTarget(part, tick(), false)
                                    local stillValid = State.Farm and Config.Boosted
                                        and not itemRemoved()
                                        and Utils.validPos(part) and not Utils.invisible(part)
                                        and prompt.Parent ~= nil and prompt:IsDescendantOf(workspace)
                                        and prompt.Enabled ~= false
                                        and finalVerified and finalCharacter == expectedCharacter
                                        and finalHumanoid.Health > 0
                                        and readySpawn == nil

                                    if stillValid then
                                        local currentReference = promptAnchor(prompt)
                                        local currentMaxDistance = math.max(0, tonumber(prompt.MaxActivationDistance) or 10)
                                        local currentDistance = currentReference and currentReference.Parent
                                            and (currentReference.Position - finalRoot.Position).Magnitude or math.huge
                                        stillValid = currentReference ~= nil and currentReference.Parent ~= nil
                                            and currentDistance <= currentMaxDistance + 0.1
                                            and currentDistance <= 4.25
                                    end

                                    if stillValid then
                                        local fired = Farm.triggerPickupPrompt(prompt)
                                        if fired then
                                            lastSuccessfulTriggerAt = os.clock()
                                        end
                                    end
                                end)
                                if not callbackOk then
                                    warn("[Methion] Boosted pickup check failed: " .. tostring(callbackErr))
                                end
                                promptInFlight = false
                                nextPromptAt = os.clock() + 0.06
                            end)
                        end
                    end
                else
                    stableFrames = 0
                    previousAnchors = nil
                end
            else
                stableFrames = 0
                previousAnchors = nil
            end

            RunService.Heartbeat:Wait()
        end
    end

    if itemRemoved() then
        ItemESP.unregister(part)
        return true
    end

    if trackedData and Config.Boosted then
        trackedData.FarmRetryAt = tick() + 0.08
    end
    return false
end

function Farm.pickupTween(model, part, trackedData)
    if not part or not part.Parent or not part:IsDescendantOf(workspace) then
        if part then ItemESP.unregister(part) end
        return true
    end

    local function findPrompt()
        local saved = trackedData and trackedData.Obj
        if saved and saved.Parent and saved:IsA("ProximityPrompt") then
            return saved
        end

        local roots = {model, part}
        for _, object in ipairs(roots) do
            if object and object.Parent then
                if object:IsA("ProximityPrompt") then return object end
                local prompt = object:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then return prompt end
            end
        end

        local ancestor = part:FindFirstAncestorOfClass("Model")
        if ancestor and ancestor ~= model then
            return ancestor:FindFirstChildWhichIsA("ProximityPrompt", true)
        end
        return nil
    end

    if not bypassSupported then

        local expectedCharacter = LP.Character
        local started = tick()
        local lastPromptAt = 0

        while Farm.isActive() and model and model.Parent and part and part.Parent
            and part:IsDescendantOf(workspace) and tick() - started < 3.5 do
            local character = LP.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not character or not root then break end
            expectedCharacter = expectedCharacter or character
            if character ~= expectedCharacter then break end

            local targetPosition = part.Position + Vector3.new(0, 2.25, 0)
            if (root.Position - targetPosition).Magnitude > 2.5 then
                root.CFrame = CFrame.new(targetPosition, part.Position)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end

            local prompt = findPrompt()
            if prompt and prompt.Parent and prompt.Enabled ~= false
                and tick() - lastPromptAt >= 0.16 then
                lastPromptAt = tick()
                Farm.triggerPickupPrompt(prompt)
            end
            task.wait(0.1)
        end

        if not part.Parent or not part:IsDescendantOf(workspace)
            or (model and not model.Parent) then
            ItemESP.unregister(part)
            return true
        end

        if trackedData then trackedData.FarmRetryAt = tick() + 1.0 end
        return false
    end

    for attempt = 1, 3 do
        if not part.Parent or not part:IsDescendantOf(workspace) then
            ItemESP.unregister(part)
            return true
        end
        if model and not model.Parent then
            ItemESP.unregister(part)
            return true
        end

        local prompt = findPrompt()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if prompt and prompt.Parent and prompt.Enabled ~= false and root then
            local promptPart = prompt.Parent:IsA("BasePart") and prompt.Parent
                or prompt.Parent:FindFirstChildWhichIsA("BasePart", true)
            local referencePart = promptPart or part
            local distance = (referencePart.Position - root.Position).Magnitude
            local maxDistance = tonumber(prompt.MaxActivationDistance) or 10

            if distance > math.max(maxDistance, 6) then
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end

            Farm.triggerPickupPrompt(prompt)
        end

        task.wait(0.22)
        if not part.Parent or not part:IsDescendantOf(workspace) then
            ItemESP.unregister(part)
            return true
        end
        if trackedData then trackedData.FarmRetryAt = tick() + 0.35 end
    end

    if trackedData then trackedData.FarmRetryAt = tick() + 1.0 end
    return false
end

local function moveToSafeIfNeeded()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and (root.Position - Config.SafeZone).Magnitude > 6 then
        return Move.teleSafe()
    end
    return root ~= nil
end

function Farm.tick()
    if State.HalloweenTurnInBusy then return end
    -- Chopa: selling runs at the same time as the farm (the farm no longer pauses while an item is sold)

    if not Farm.isActive() then
        if FarmVisual.Decoy then FarmVisual.restoreAtSafe() end
        return
    end

    if State.TweenRunning then
        if FarmVisual.Decoy then FarmVisual.cleanup() end
        return
    end

    local instantMode = bypassSupported and Config.FarmTeleportMode == "instant"
    if instantMode then
        if not FarmVisual.isActive() then
            moveToSafeIfNeeded()
            if not Config.Boosted then task.wait(0.08) end
            FarmVisual.showSafeZoneDecoy()
        end
    elseif FarmVisual.Decoy then
        FarmVisual.cleanup()
    end

    local item, trackedPart, trackedData = Farm.nearest()
    if item then

        local part = Config.Boosted and trackedPart and trackedPart.Parent
            and trackedPart:IsDescendantOf(workspace) and trackedPart
            or (item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart", true))
        if instantMode then
            if part then
                if Config.Boosted and State.Farm then
                    Farm.pickupBoosted(item, part, trackedData)
                    if not part.Parent or not part:IsDescendantOf(workspace) or Utils.invisible(part) then
                        ItemESP.unregister(part)
                    end
                else
                    local moved = Move.telePart(part)
                    if moved and Farm.waitForArrival(part, 2.5) then
                        local picked = Farm.pickup(item, part)
                        if not picked and (not part.Parent or not part:IsDescendantOf(workspace)) then
                            ItemESP.unregister(part)
                        end
                    elseif not part.Parent or not part:IsDescendantOf(workspace) then
                        ItemESP.unregister(part)
                    end
                    task.wait(0.025)
                end
            else
                moveToSafeIfNeeded()
            end
        else

            local targetPart = trackedPart and trackedPart.Parent and trackedPart:IsDescendantOf(workspace)
                and trackedPart or part
            if targetPart then
                local moved = Move.flyCF(
                    CFrame.new(targetPart.Position + Vector3.new(0, 3, 0)),
                    Config.TweenSpeed,
                    function()
                        return Farm.isActive()
                            and targetPart.Parent ~= nil
                            and targetPart:IsDescendantOf(workspace)
                            and (not item or item.Parent ~= nil)
                    end
                )

                if moved and targetPart.Parent and targetPart:IsDescendantOf(workspace)
                    and Farm.waitForArrival(targetPart, 3.5) then
                    Farm.pickupTween(item, targetPart, trackedData)
                end

                if not targetPart.Parent or not targetPart:IsDescendantOf(workspace) then
                    ItemESP.unregister(targetPart)
                elseif trackedData then
                    trackedData.FarmRetryAt = trackedData.FarmRetryAt or 0
                end
                task.wait(0.1)
            else

                local roamPos = Vector3.new(math.random(-560, 560), 100, math.random(-600, 580))
                Move.flyCF(CFrame.new(roamPos), Config.TweenSpeed, function()
                    return Farm.isActive() and Farm.nearest() == nil
                end)
                task.wait(0.1)
            end
        end
    else
        if instantMode then
            moveToSafeIfNeeded()
        else
            
            local roamPos = Vector3.new(math.random(-560, 560), 100, math.random(-600, 580))
            Move.flyCF(CFrame.new(roamPos), Config.TweenSpeed, function()
                return Farm.isActive() and Farm.nearest() == nil
            end)
            task.wait(0.1)
        end
    end
end

local Player = {}

function Player.humanoid()
    local char = LP.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

function Player.jump()
    if not Config.Player.JumpPowerEnabled then return end
    local hum = Player.humanoid()
    if not hum then return end
    hum.UseJumpPower = true
    local power = math.clamp(tonumber(Config.Player.JumpPower) or 24, 1, 200)
    if hum.JumpPower ~= power then hum.JumpPower = power end
end

function Player.noclip()
    local char = LP.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = not Config.Player.NoClipEnabled
        end
    end
end

function Player.resetJump()
    local hum = Player.humanoid()
    if hum then
        hum.JumpPower = tonumber(Config.Player.JumpPowerOriginal) or 50
        if Config.Player.JumpUseJumpPowerOriginal ~= nil then
            hum.UseJumpPower = Config.Player.JumpUseJumpPowerOriginal
        end
    end
    Config.Player.JumpPowerOriginal = nil
    Config.Player.JumpUseJumpPowerOriginal = nil
end

function Player.enableJumpPower(enabled)
    local hum = Player.humanoid()
    if enabled then
        if hum and Config.Player.JumpPowerOriginal == nil then
            Config.Player.JumpPowerOriginal = hum.JumpPower
            Config.Player.JumpUseJumpPowerOriginal = hum.UseJumpPower
        end
        Config.Player.JumpPowerEnabled = true
        Player.jump()
    else
        Config.Player.JumpPowerEnabled = false
        Player.resetJump()
    end
end

function Player.applyWalkSpeed()
    if not Config.Player.WalkSpeedEnabled then return end
    local hum = Player.humanoid()
    if hum then
        local speed = math.clamp(tonumber(Config.Player.WalkSpeed) or 24, 1, 200)
        if hum.WalkSpeed ~= speed then hum.WalkSpeed = speed end
    end
end

function Player.enableWalkSpeed(enabled)
    if enabled then
        local hum = Player.humanoid()
        if Config.Player.WalkSpeedOriginal == nil then
            Config.Player.WalkSpeedOriginal = hum and hum.WalkSpeed or 16
        end
        Config.Player.WalkSpeedEnabled = true
        Player.applyWalkSpeed()
    else
        Config.Player.WalkSpeedEnabled = false
        local hum = Player.humanoid()
        if hum then hum.WalkSpeed = tonumber(Config.Player.WalkSpeedOriginal) or 16 end
        Config.Player.WalkSpeedOriginal = nil
    end
end

_G.MethionWalkSpeedRuntime = _G.MethionWalkSpeedRuntime or {}
for _, connectionName in ipairs({"Heartbeat", "CharacterAdded"}) do
    local connection = _G.MethionWalkSpeedRuntime[connectionName]
    if connection then pcall(function() connection:Disconnect() end) end
    _G.MethionWalkSpeedRuntime[connectionName] = nil
end

local LowGfx = {}

function LowGfx.apply()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e9
    end)
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then v.Enabled = false end
    end
    pcall(function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then t.WaterTransparency = 1 end
    end)
    task.spawn(function()
        local n = 0
        for _, obj in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.Reflectance = 0
                    obj.CastShadow = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                end
            end)
            n = n + 1
            if n % 250 == 0 then task.wait() end
        end
    end)
    pcall(function()
        if setfpscap then setfpscap(120) end
    end)
    State.LowGraphics = true
end

local Rejoin = {}
local rejoinConn = nil

function Rejoin.start()
    if rejoinConn then return end
    pcall(function()
        local GuiService = game:GetService("GuiService")
        local TeleportService = game:GetService("TeleportService")
        rejoinConn = GuiService.ErrorMessageChanged:Connect(function(message)
            if not Config.AutoRejoinEnabled then return end
            if not message or message == "" then return end
            if type(_G.__ChopaRejoin) == "function" then         -- Chopa: handled by the rejoin watcher
                _G.__ChopaRejoin("error message: " .. tostring(message):sub(1, 120))
                return
            end
            task.spawn(function()
                task.wait(0.05)
                local reloadHandler = _G.__MethionSHReloadAfterKick
                if type(reloadHandler) == "function" then
                    local ok, reloading = pcall(reloadHandler)
                    if ok and reloading then return end
                end
                local controller = _G.__MethionSHController
                if controller and controller.Enabled and type(controller.hop) == "function" then
                    local ok, hopped = pcall(function() return controller:hop() end)
                    if ok and hopped then return end
                end
                pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
            end)
        end)
    end)
end

function Rejoin.stop()
    if rejoinConn then
        rejoinConn:Disconnect()
        rejoinConn = nil
    end
end

local Shop = {}

function Shop.buy(itemName)
    pcall(function()
        local char = LP.Character
        if not char then return end
        local ev = char:FindFirstChild("RemoteEvent")
        if not ev then return end
        ev:FireServer("PurchaseShopItem", {ItemName = itemName})
    end)
end

function Shop.autoLucky()
    task.spawn(function()
        while Config.AutoBuyLucky do
            task.wait(1)
            if Utils.money() >= Config.LuckyArrowPrice then
                Shop.buy(Config.LuckyArrowItem)
                task.wait(2)
            end
        end
    end)
end

local Weather = {ActivePreset = "Original"}

local weatherOrig = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    AtmosphereDensity = Lighting:FindFirstChildOfClass("Atmosphere") and Lighting:FindFirstChildOfClass("Atmosphere").Density or 0.3,
    AtmosphereHaze = Lighting:FindFirstChildOfClass("Atmosphere") and Lighting:FindFirstChildOfClass("Atmosphere").Haze or 0,
}
weatherOrig.AtmosphereInstance = Lighting:FindFirstChildOfClass("Atmosphere")
weatherOrig.AtmosphereColor = weatherOrig.AtmosphereInstance and weatherOrig.AtmosphereInstance.Color or Color3.fromRGB(199, 199, 199)
weatherOrig.AtmosphereDecay = weatherOrig.AtmosphereInstance and weatherOrig.AtmosphereInstance.Decay or Color3.fromRGB(106, 112, 125)
weatherOrig.AtmosphereGlare = weatherOrig.AtmosphereInstance and weatherOrig.AtmosphereInstance.Glare or 0
weatherOrig.AtmosphereOffset = weatherOrig.AtmosphereInstance and weatherOrig.AtmosphereInstance.Offset or 0
weatherOrig.SunRaysInstance = Lighting:FindFirstChild("SunRaysEffect")
weatherOrig.SunRaysEnabled = weatherOrig.SunRaysInstance and weatherOrig.SunRaysInstance.Enabled or false
weatherOrig.SunRaysIntensity = weatherOrig.SunRaysInstance and weatherOrig.SunRaysInstance.Intensity or 0.15
weatherOrig.SunRaysSpread = weatherOrig.SunRaysInstance and weatherOrig.SunRaysInstance.Spread or 1

function Weather.updateStatus()
    pcall(function()
        if UIRefs.weatherPresetLabel then
            UIRefs.weatherPresetLabel:SetDesc(tostring(Weather.ActivePreset or "Original"))
        end
    end)
    pcall(function()
        if UIRefs.weatherTimeLabel then
            UIRefs.weatherTimeLabel:SetDesc(string.format("%.2f", Lighting.ClockTime))
        end
    end)
end

function Weather.sunRays(enabled)
    local sr = Lighting:FindFirstChild("SunRaysEffect")
    if enabled then
        if not sr then
            sr = Instance.new("SunRaysEffect")
            sr.Name = "SunRaysEffect"
            sr.Intensity = 0.15
            sr.Spread = 1
            sr.Parent = Lighting
        end
        sr.Enabled = true
    else
        if sr then sr.Enabled = false end
    end
end

function Weather.setBrightness(value)
    Lighting.Brightness = math.clamp(tonumber(value) or Lighting.Brightness, 0, 4)
    Weather.ActivePreset = "Custom"
    Weather.updateStatus()
end

function Weather.setDensity(value)
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atm then
        atm = Instance.new("Atmosphere")
        atm.Name = "Atmosphere"
        atm.Parent = Lighting
    end
    atm.Density = math.clamp(tonumber(value) or atm.Density, 0, 1)
    Weather.ActivePreset = "Custom"
    Weather.updateStatus()
end

function Weather.setSunRays(enabled)
    Weather.sunRays(enabled == true)
    Weather.ActivePreset = "Custom"
    Weather.updateStatus()
end

function Weather.reset()
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if weatherOrig.AtmosphereInstance then
        if not atm then
            atm = Instance.new("Atmosphere")
            atm.Name = "Atmosphere"
            atm.Parent = Lighting
        end
        atm.Density = weatherOrig.AtmosphereDensity
        atm.Haze = weatherOrig.AtmosphereHaze
        atm.Color = weatherOrig.AtmosphereColor
        atm.Decay = weatherOrig.AtmosphereDecay
        atm.Glare = weatherOrig.AtmosphereGlare
        atm.Offset = weatherOrig.AtmosphereOffset
    elseif atm then
        atm:Destroy()
    end

    Lighting.ClockTime = weatherOrig.ClockTime
    Lighting.Brightness = weatherOrig.Brightness
    Lighting.Ambient = weatherOrig.Ambient
    Lighting.OutdoorAmbient = weatherOrig.OutdoorAmbient
    Lighting.FogColor = weatherOrig.FogColor
    Lighting.FogStart = weatherOrig.FogStart
    Lighting.FogEnd = weatherOrig.FogEnd

    local sr = Lighting:FindFirstChild("SunRaysEffect")
    if weatherOrig.SunRaysInstance then
        if not sr then
            sr = Instance.new("SunRaysEffect")
            sr.Name = "SunRaysEffect"
            sr.Parent = Lighting
        end
        sr.Enabled = weatherOrig.SunRaysEnabled
        sr.Intensity = weatherOrig.SunRaysIntensity
        sr.Spread = weatherOrig.SunRaysSpread
    elseif sr then
        sr:Destroy()
    end

    Weather.ActivePreset = "Original"
    Weather.updateStatus()
end

function Weather.apply(preset)
    local atm = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atm then
        atm = Instance.new("Atmosphere")
        atm.Name = "Atmosphere"
        atm.Parent = Lighting
    end

    Lighting.Brightness = weatherOrig.Brightness
    Lighting.Ambient = weatherOrig.Ambient
    Lighting.OutdoorAmbient = weatherOrig.OutdoorAmbient
    Lighting.FogColor = weatherOrig.FogColor
    Lighting.FogStart = weatherOrig.FogStart
    Lighting.FogEnd = weatherOrig.FogEnd
    atm.Density = weatherOrig.AtmosphereDensity
    atm.Haze = weatherOrig.AtmosphereHaze
    atm.Color = weatherOrig.AtmosphereColor
    atm.Decay = weatherOrig.AtmosphereDecay
    atm.Glare = weatherOrig.AtmosphereGlare
    atm.Offset = weatherOrig.AtmosphereOffset
    Weather.sunRays(false)

    local presetTime = nil
    if preset == "Clear" then
        presetTime = 12
        Lighting.Brightness = 3
        atm.Density = 0.08
        atm.Haze = 0
        atm.Color = Color3.fromRGB(255, 240, 200)
    elseif preset == "Sunny" then
        presetTime = 14
        Lighting.Brightness = 2.5
        atm.Density = 0.12
        atm.Haze = 0
        atm.Color = Color3.fromRGB(255, 246, 225)
        Weather.sunRays(true)
    elseif preset == "Sunset" then
        presetTime = 18.5
        Lighting.Brightness = 1.8
        Lighting.Ambient = Color3.fromRGB(105, 76, 74)
        Lighting.OutdoorAmbient = Color3.fromRGB(135, 91, 72)
        atm.Density = 0.2
        atm.Haze = 0.08
        atm.Color = Color3.fromRGB(255, 183, 126)
    elseif preset == "Overcast" then
        presetTime = 13
        Lighting.Brightness = 1.25
        Lighting.Ambient = Color3.fromRGB(105, 108, 115)
        Lighting.OutdoorAmbient = Color3.fromRGB(125, 128, 135)
        atm.Density = 0.32
        atm.Haze = 0.1
        atm.Color = Color3.fromRGB(195, 201, 210)
    elseif preset == "Night" then
        presetTime = 0
        Lighting.Brightness = 0.5
        Lighting.Ambient = Color3.fromRGB(35, 38, 58)
        Lighting.OutdoorAmbient = Color3.fromRGB(25, 30, 50)
        atm.Density = 0.35
        atm.Haze = 0
        atm.Color = Color3.fromRGB(30, 40, 80)
    elseif preset == "Fog" then
        presetTime = 15
        Lighting.Brightness = 1
        Lighting.FogStart = 0
        Lighting.FogEnd = 450
        Lighting.FogColor = Color3.fromRGB(190, 195, 200)
        atm.Density = 0.45
        atm.Haze = 0.11
        atm.Color = Color3.fromRGB(200, 200, 200)
    else
        return
    end

    if presetTime and not Config.Weather.TimeOfDayEnabled then
        Lighting.ClockTime = presetTime
    end
    Weather.ActivePreset = tostring(preset)
    Weather.updateStatus()
end

local Cam = {
    Active = false,
    Target = nil,
    OriginalCameraType = nil,
    OriginalCameraSubject = nil,
    OriginalCameraCFrame = nil,
    OriginalCameraFocus = nil,
    BeforeCameraStep = "Phantom_PlayerSpectate_BeforeCamera",
    AfterCameraStep = "Phantom_PlayerSpectate_AfterCamera",
}

function Cam.getSubject(targetPlayer)
    local character = targetPlayer and targetPlayer.Character
    if not character then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    return humanoid or root
end

function Cam.maintainCamera()
    if not Cam.Active then return end
    local cam = workspace.CurrentCamera
    if not cam then return end

    local subject = Cam.getSubject(Cam.Target)
    if not subject then
        local character = LP.Character
        subject = character and character:FindFirstChildOfClass("Humanoid") or nil
    end
    if not subject or not subject.Parent then return end

    pcall(function()
        if cam.CameraType ~= Enum.CameraType.Custom then
            cam.CameraType = Enum.CameraType.Custom
        end
        if cam.CameraSubject ~= subject then
            cam.CameraSubject = subject
        end
    end)
end

function Cam.start(targetPlayer)
    if not targetPlayer or targetPlayer == LP or not targetPlayer.Parent then
        return false
    end

    if Cam.Active then
        Cam.Target = targetPlayer
        Cam.maintainCamera()
        return true
    end

    local cam = workspace.CurrentCamera
    if not cam then return false end

    Cam.OriginalCameraType = cam.CameraType
    Cam.OriginalCameraSubject = cam.CameraSubject
    Cam.OriginalCameraCFrame = cam.CFrame
    Cam.OriginalCameraFocus = cam.Focus
    Cam.Target = targetPlayer
    Cam.Active = true

    pcall(function() RunService:UnbindFromRenderStep(Cam.BeforeCameraStep) end)
    pcall(function() RunService:UnbindFromRenderStep(Cam.AfterCameraStep) end)
    RunService:BindToRenderStep(
        Cam.BeforeCameraStep,
        Enum.RenderPriority.Camera.Value - 1,
        Cam.maintainCamera
    )
    RunService:BindToRenderStep(
        Cam.AfterCameraStep,
        Enum.RenderPriority.Camera.Value + 1,
        Cam.maintainCamera
    )
    Cam.maintainCamera()
    return true
end

function Cam.stop()
    Cam.Active = false
    pcall(function() RunService:UnbindFromRenderStep(Cam.BeforeCameraStep) end)
    pcall(function() RunService:UnbindFromRenderStep(Cam.AfterCameraStep) end)

    local cam = workspace.CurrentCamera
    if cam then
        local subject = Cam.OriginalCameraSubject
        if not subject or not subject.Parent then
            local character = LP.Character
            subject = character and character:FindFirstChildOfClass("Humanoid") or nil
        end
        pcall(function()
            cam.CameraType = Cam.OriginalCameraType or Enum.CameraType.Custom
            if subject and subject.Parent then cam.CameraSubject = subject end
            if Cam.OriginalCameraCFrame then cam.CFrame = Cam.OriginalCameraCFrame end
            if Cam.OriginalCameraFocus then cam.Focus = Cam.OriginalCameraFocus end
        end)
    end

    Cam.Target = nil
    Cam.OriginalCameraType = nil
    Cam.OriginalCameraSubject = nil
    Cam.OriginalCameraCFrame = nil
    Cam.OriginalCameraFocus = nil
end

local Loops = {}

function Loops.noclip()
    RunService.Stepped:Connect(function()
        if not State.NoClip then return end
        local char = LP.Character
        if not char then return end
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end

function Loops.farm()
    task.spawn(function()
        while true do
            if Farm.isActive() and bypassSupported and Config.FarmTeleportMode == "instant" then

                Farm.tick()
                task.wait()
            else
                task.wait(0.1)
                Farm.tick()
            end
        end
    end)
end

function Loops.itemLabels()
    task.spawn(function()
        while true do
            task.wait(.3)
            if State.ItemEsp then
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local myPos = root and root.Position
                for part, data in pairs(Tracked) do
                    if not part or not part:IsDescendantOf(workspace) then
                        ItemESP.unregister(part)
                    elseif ItemESP.isPlayerOwned(data.Obj or part, part) then
                        data.PlayerOwned = true
                        local hl = part:FindFirstChild("Phantom_ESP")
                        local bb = part:FindFirstChild("Phantom_Label")
                        if hl then hl.Enabled = false end
                        if bb then bb.Enabled = false end
                    elseif not Utils.validPos(part) then
                        ItemESP.unregister(part)
                        table.insert(Pending, {obj = data.Obj or part, part = part, name = data.Name})
                    elseif myPos then
                        if data.PlayerOwned then
                            data.PlayerOwned = false
                            ItemESP.create(part, data.Name, State.ItemEsp)
                        end
                        local bb = part:FindFirstChild("Phantom_Label")
                        local label = bb and bb:FindFirstChild("Phantom_Text")
                        if label then
                            local txt = ItemESP.labelText(part, data.Name)
                            if label.Text ~= txt then label.Text = txt end
                            local col = Config.Esp.ItemNameColor
                            if label.TextColor3 ~= col then label.TextColor3 = col end
                            local size = math.clamp(math.floor(tonumber(Config.Esp.ItemTextSize) or 13), 8, 24)
                            if label.TextSize ~= size then label.TextSize = size end
                        end
                    end
                end
            else
                task.wait(.5)
            end
        end
    end)
end

function Loops.pending()
    task.spawn(function()
        while true do
            if Farm.isActive() and bypassSupported and Config.FarmTeleportMode == "instant" then
                RunService.Heartbeat:Wait()
            else
                task.wait(.2)
            end
            for i = #Pending, 1, -1 do
                local e = Pending[i]
                if e.obj and e.obj:IsDescendantOf(game) and Utils.validPos(e.part) then
                    table.remove(Pending, i)
                    if not Tracked[e.part] then ItemESP.register(e.obj) end
                elseif not e.obj or not e.obj:IsDescendantOf(game) then
                    table.remove(Pending, i)
                end
            end
        end
    end)
end

function Loops.playerESP()
    task.spawn(function()
        while true do
            task.wait(.25)
            if State.PlayerEsp then
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local myPos = root and root.Position
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LP and plr.Character then
                        local pchar = plr.Character
                        local head = pchar:FindFirstChild("Head")
                        local hum = pchar:FindFirstChildOfClass("Humanoid")
                        local proot = pchar:FindFirstChild("HumanoidRootPart")
                        if head and hum and proot and hum.Health > 0 then
                            PlayerESP.create(pchar, plr.Name, true)
                            local bb = head:FindFirstChild("Phantom_PlayerLabel")
                            local label = bb and bb:FindFirstChild("Phantom_PlayerText")
                            if label and myPos then
                                local dist = math.floor((proot.Position - myPos).Magnitude)
                                local hp = math.floor(hum.Health)
                                local spec, stand = Utils.playerInfo(plr)
                                local lines = {}
                                if Config.Esp.ShowPlayerName then
                                    table.insert(lines, plr.Name)
                                end
                                local details = {}
                                if Config.Esp.ShowHP then
                                    local hpPercent = math.floor((hum.Health / math.max(hum.MaxHealth, 1)) * 100 + 0.5)
                                    table.insert(details, tostring(hpPercent) .. "% HP")
                                end
                                if Config.Esp.ShowDistance then
                                    table.insert(details, tostring(dist) .. "m")
                                end
                                if #details > 0 then table.insert(lines, table.concat(details, " | ")) end
                                local identity = {}
                                if Config.Esp.ShowStand then table.insert(identity, stand) end
                                if Config.Esp.ShowSpec then table.insert(identity, spec) end
                                if #identity > 0 then table.insert(lines, table.concat(identity, " | ")) end
                                label.Text = table.concat(lines, "\n")
                            end
                        else
                            PlayerESP.remove(pchar)
                        end
                    end
                end
            else
                task.wait(.5)
            end
        end
    end)
end

function Loops.spectate()
    task.spawn(function()
        while true do
            task.wait(0.3)
            if State.Spectate then
                local target = State.SelectedPlayer
                if not target or target == LP or not target.Parent then
                    State.Spectate = false
                    Cam.stop()
                    local ui = _G.__PhantomRemadeUI
                    local control = ui and ui.SpectateToggle
                    if control and type(control.Set) == "function" then
                        pcall(function() control:Set(false) end)
                    end
                elseif not Cam.Active or Cam.Target ~= target then
                    Cam.start(target)
                else

                    Cam.maintainCamera()
                end
            elseif Cam.Active then
                Cam.stop()
            end
        end
    end)
end

local PlayerInfo = {}

function PlayerInfo.cleanName(s)
    return string.lower(string.gsub(s, "%s+", ""))
end

function PlayerInfo.findByInput(input)
    local clean = PlayerInfo.cleanName(input)
    if clean == "" then return nil end
    local exact, partial, contains = nil, nil, nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local c = PlayerInfo.cleanName(plr.Name)
            local display = PlayerInfo.cleanName(plr.DisplayName or "")
            if c == clean or display == clean then
                exact = plr
                break
            elseif not partial and (string.find(c, clean, 1, true) == 1 or string.find(display, clean, 1, true) == 1) then
                partial = plr
            elseif not contains and (string.find(c, clean, 1, true) or string.find(display, clean, 1, true)) then
                contains = plr
            end
        end
    end
    return exact or partial or contains
end

local __paraLast = setmetatable({}, {__mode = "k"})
function PlayerInfo.setPara(para, value)
    if not para then return end
    local text = tostring(value)
    if __paraLast[para] == text then return end
    __paraLast[para] = text
    local renderedText = para.Title and para.Title ~= "" and (para.Title .. "\n" .. text) or text
    local ok = pcall(function() para:SetDesc(text) end)
    if not ok then pcall(function() para:Set(text) end) end
    pcall(function() para.Desc = text end)
    local function forceText(target, depth, seen)
        depth = depth or 0
        seen = seen or {}
        if target == nil or depth > 4 then return false end
        if typeof(target) == "Instance" then
            if target:IsA("TextLabel") or target:IsA("TextBox") or target:IsA("TextButton") then
                target.Text = renderedText
                return true
            end
            if target:IsA("GuiObject") then
                local labels = {}
                for _, child in ipairs(target:GetDescendants()) do
                    if child:IsA("TextLabel") then table.insert(labels, child) end
                end
                if #labels == 1 then labels[1].Text = renderedText return true end
                for _, child in ipairs(labels) do
                    if child.Name == "Label" or child.Name == "Text" then
                        child.Text = renderedText
                        return true
                    elseif child.Name == "Desc" or child.Name == "Description" then
                        child.Text = text
                        return true
                    end
                end
            end
            return false
        end
        if type(target) ~= "table" or seen[target] then return false end
        seen[target] = true
        for _, key in ipairs({"Instance", "Label", "TextLabel", "TitleLabel", "Frame", "Main", "Container", "Holder", "Object", "Element", "Raw"}) do
            local child
            pcall(function() child = target[key] end)
            if child and forceText(child, depth + 1, seen) then return true end
        end
        return false
    end
    forceText(para)
end

function PlayerInfo.updateLabels()
    if not State.SelectedPlayer or not State.SelectedPlayer.Parent then
        for _, key in ipairs({
            "targetPlayerLabel", "displayNameLabel", "userIdLabel", "accountAgeLabel",
            "usernameLabel", "hpLabel", "standLabel", "specLabel", "prestigeLabel",
            "lvlLabel", "expLabel", "moneyLabel", "playtimeLabel", "gangLabel",
            "equippedStandLabel", "slot1Label", "slot2Label", "slot3Label",
            "equippedSpecLabel", "specSlot1Label", "raceLabel", "questLabel",
            "sbrLabel", "skillLabel", "pityLabel", "gemsLabel",
        }) do
            PlayerInfo.setPara(UIRefs[key], "--")
        end
        PlayerInfo.setPara(UIRefs.targetPlayerLabel, "None selected")
        return
    end
    local plr = State.SelectedPlayer
    local char = plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hpVal = "--"
    if hum then
        hpVal = tostring(math.floor(hum.Health + 0.5)) .. " / " .. tostring(math.floor(hum.MaxHealth + 0.5))
    end
    local spec, stand = Utils.playerInfo(plr)
    PlayerInfo.setPara(UIRefs.targetPlayerLabel, tostring(plr.DisplayName or plr.Name) .. "  (@" .. plr.Name .. ")")
    PlayerInfo.setPara(UIRefs.displayNameLabel, plr.DisplayName or plr.Name)
    PlayerInfo.setPara(UIRefs.userIdLabel, tostring(plr.UserId))
    PlayerInfo.setPara(UIRefs.accountAgeLabel, tostring(plr.AccountAge) .. " days")
    local gangVal = Utils.stat(plr, "Gang") or "Gang-less"
    if gangVal == "" or gangVal == "None" or gangVal == "none" then gangVal = "Gang-less" end
    PlayerInfo.setPara(UIRefs.usernameLabel, plr.Name)
    PlayerInfo.setPara(UIRefs.hpLabel, hpVal)
    PlayerInfo.setPara(UIRefs.standLabel, stand)
    PlayerInfo.setPara(UIRefs.specLabel, spec)
    PlayerInfo.setPara(UIRefs.prestigeLabel, Utils.stat(plr, "Prestige") or "--")
    PlayerInfo.setPara(UIRefs.lvlLabel, Utils.stat(plr, "Level") or "--")
    PlayerInfo.setPara(UIRefs.expLabel, Utils.stat(plr, "Experience") or "--")
    PlayerInfo.setPara(UIRefs.moneyLabel, Utils.stat(plr, "Money", "int") or "--")
    PlayerInfo.setPara(UIRefs.playtimeLabel, Utils.stat(plr, "PlayTime", "hours") or "--")
    PlayerInfo.setPara(UIRefs.gangLabel, gangVal)
    PlayerInfo.setPara(UIRefs.equippedStandLabel, Utils.stat(plr, "Stand") or "--")
    PlayerInfo.setPara(UIRefs.slot1Label, Utils.stat(plr, "Slot1") or "--")
    PlayerInfo.setPara(UIRefs.slot2Label, Utils.stat(plr, "Slot2") or "--")
    PlayerInfo.setPara(UIRefs.slot3Label, Utils.stat(plr, "Slot3") or "--")
    PlayerInfo.setPara(UIRefs.equippedSpecLabel, Utils.stat(plr, "Spec") or "--")
    PlayerInfo.setPara(UIRefs.specSlot1Label, Utils.stat(plr, "StyleSlot1") or "--")
    PlayerInfo.setPara(UIRefs.raceLabel, Utils.stat(plr, "Race") or "--")
    PlayerInfo.setPara(UIRefs.questLabel, Utils.stat(plr, "Quest") or "--")
    PlayerInfo.setPara(UIRefs.sbrLabel, Utils.stat(plr, "SteelBallRunWins") or "--")
    PlayerInfo.setPara(UIRefs.skillLabel, Utils.stat(plr, "SkillPoints") or "--")
    PlayerInfo.setPara(UIRefs.pityLabel, Utils.stat(plr, "PityCount") or "--")
    PlayerInfo.setPara(UIRefs.gemsLabel, Utils.stat(plr, "Gems") or "--")
end

function PlayerInfo.listPlayers()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then table.insert(list, plr.Name) end
    end
    table.sort(list, function(a, b)
        return string.lower(a) < string.lower(b)
    end)
    table.insert(list, 1, "-- Select player --")
    return list
end

function PlayerInfo.setSelected(plr)
    if plr == LP or (plr and not plr.Parent) then plr = nil end
    State.SelectedPlayer = plr
    if State.Spectate then
        if plr then
            Cam.start(plr)
        else
            State.Spectate = false
            Cam.stop()
            local ui = _G.__PhantomRemadeUI
            local control = ui and ui.SpectateToggle
            if control and type(control.Set) == "function" then
                pcall(function() control:Set(false) end)
            end
        end
    end
    local viewer = _G.__PhantomPlayerInfoViewer
    if plr and viewer and type(viewer.Set) == "function" then
        pcall(function() viewer:Set(plr) end)
    end
    pcall(PlayerInfo.updateLabels)
end

function PlayerInfo.selectNearest()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, nearestDistance = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and humanoid and humanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearest, nearestDistance = plr, distance
                end
            end
        end
    end
    PlayerInfo.setSelected(nearest)
    return nearest, nearestDistance
end

function PlayerInfo.refreshList()
    local uiState = _G.__PhantomRemadeUI
    local dropdown = uiState and uiState.PlayerDropdown
    if dropdown then
        pcall(function() dropdown:Refresh(PlayerInfo.listPlayers(), true) end)
    end
end

function Loops.playerInfo()
    task.spawn(function()
        while true do
            task.wait(.5)
            pcall(PlayerInfo.updateLabels)
        end
    end)
end

function Loops.counter()
    task.spawn(function()
        while true do
            task.wait(1)
            pcall(function()
                PlayerInfo.setPara(UIRefs.farmItemsLabel, tostring(ItemESP.count()))
            end)
        end
    end)
end

local SHController = {
    Enabled = false,
    Running = false,
    Token = 0,
    VisitedJobs = type(MethionSH_Env.__MethionSHVisitedJobs) == "table"
        and MethionSH_Env.__MethionSHVisitedJobs or {},
}
_G.__MethionSHController = SHController
-- Chopa: servers whose join failed (skipped for 10 min) and the count of failed hops in a row
SHController.BadJobs = {}
SHController.Failures = 0
local AFKFarmToggle = nil

local SHStats = MethionSH_Env.__MethionSHStats
if type(SHStats) ~= "table" then SHStats = {} end
local activeJobId = tostring(game.JobId or "")
local sameStatsServer = activeJobId ~= "" and SHStats.CurrentJobId == activeJobId
SHStats.ServersHopped = math.max(0, math.floor(tonumber(SHStats.ServersHopped) or 0))
SHStats.ItemsCollected = math.max(0, math.floor(tonumber(SHStats.ItemsCollected) or 0))
SHStats.LifetimeMoneyEarned = math.max(0, tonumber(SHStats.LifetimeMoneyEarned) or 0)
SHStats.CurrentServerItems = math.max(0, math.floor(tonumber(SHStats.CurrentServerItems) or 0))
SHStats.CurrentServerMoneyEarned = math.max(0, tonumber(SHStats.CurrentServerMoneyEarned) or 0)
SHStats.StartedAt = tonumber(SHStats.StartedAt) or os.time()
SHStats.Status = "Idle"
if not sameStatsServer then
    SHStats.CurrentJobId = activeJobId
    SHStats.CurrentServerItems = 0
    SHStats.CurrentServerMoneyEarned = 0
    SHStats.ServerStartedAt = os.time()
    SHStats.LastMoneyObserved = nil
end
MethionSH_Env.__MethionSHStats = SHStats
local shTeleportPending = false

local function isJobVisited(jobId)
    for _, visitedId in ipairs(SHController.VisitedJobs) do
        if visitedId == jobId then return true end
    end
    return false
end

local function rememberCurrentJob()
    local jobId = game.JobId
    if jobId and jobId ~= "" and not isJobVisited(jobId) then
        table.insert(SHController.VisitedJobs, jobId)
        while #SHController.VisitedJobs > 50 do
            table.remove(SHController.VisitedJobs, 1)
        end
    end
    MethionSH_Env.__MethionSHVisitedJobs = SHController.VisitedJobs
end

local function resolvedMethionSHUrl()
    local url = METHIONSH_RAW_URL
    if type(url) ~= "string" or url == "" then return nil end
    return url
end

local ENTER_GAME_SOURCE = [=[
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local function enterGame()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    pcall(function()
        if not playerGui:FindFirstChild("HUD") then
            local objects = ReplicatedStorage:FindFirstChild("Objects")
            local hudTemplate = objects and objects:FindFirstChild("HUD")
            if hudTemplate then
                hudTemplate:Clone().Parent = playerGui
            end
        end
    end)
    local character = LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()
    local remote = character:WaitForChild("RemoteEvent", 15)
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer("PressedPlay")
    end
    for _, name in ipairs({
        "LoadingScreen1",
        "LoadingScreen"
    }) do
        local screen = playerGui:FindFirstChild(name)
        if screen then
            screen:Destroy()
        end
    end
    LocalPlayer:SetAttribute("LOADED", "Skip")
    local depthOfField = Lighting:FindFirstChild("DepthOfField")
    if depthOfField then
        depthOfField:Destroy()
    end
    local loadingScreen = workspace:FindFirstChild("LoadingScreen")
    if loadingScreen then
        local song = loadingScreen:FindFirstChild("Song")
        if song then
            song:Destroy()
        end
    end
end
for _ = 1, 8 do
    local ok, err = pcall(enterGame)
    if not ok then
        warn("[AutoPlay] Attempt failed: " .. tostring(err))
    end
    if LocalPlayer:GetAttribute("LOADED") ~= nil and LocalPlayer.Character then break end
    task.wait(2)
end
]=]

local function countFarmableItems()
    local count = 0
    for part, data in pairs(Tracked) do
        if part and part.Parent and part:IsDescendantOf(workspace)
            and data and Farm.allowed(data.Name)
            and Utils.validPos(part) and not Utils.invisible(part)
            and not ItemESP.isPlayerOwned(data.Obj, part) then
            count += 1
        end
    end
    return count
end

-- Chopa: server list for hopping — FEWEST players first (no random servers).
-- One request (Roblox already sorts Asc by players), retried on rate limit, cached for 60 s and
-- prefetched while farming, so a hop starts instantly. Refused / hung servers are skipped for 10 min.
SHController.Candidates = {}
SHController.CandidatesAt = 0
-- Chopa: which server the hop picks — "Random" (default) or "Fewest players". Saved in chopa_hop_mode.txt
SHController.PickMode = "Random"
pcall(function()
    if isfile and isfile("chopa_hop_mode.txt") and readfile("chopa_hop_mode.txt") == "Fewest players" then
        SHController.PickMode = "Fewest players"
    end
end)
SHController.Fetching = false

-- Chopa: several farming accounts in one executor workspace never share a server.
--   * every bot writes chopa_status_<name>.json (server it is on) — the delivery agent does that
--   * before joining, a bot "books" the server in chopa_hopclaim_<name>.json
--   * chopa_visited_all.json: servers any bot joined in the last 20 min → bots keep rotating servers
--   * if two bots still end up together, the one whose name is later in order moves on
local ChopaBots = {
    claimFile = "chopa_hopclaim_" .. LP.Name .. ".json",
    sharedFile = "chopa_visited_all.json",
    cacheAt = 0, cache = {},
}
function ChopaBots.read(path)
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
    return ok and type(data) == "table" and data or nil
end
-- {jobId = botName} for the servers my other bots are on / are joining
function ChopaBots.others(fresh)
    if not fresh and os.clock() - ChopaBots.cacheAt < 3 then return ChopaBots.cache end
    local jobs = {}
    ChopaBots.cacheAt, ChopaBots.cache = os.clock(), jobs
    if type(listfiles) ~= "function" or type(readfile) ~= "function" then return jobs end
    local ok, files = pcall(listfiles, "")
    if not ok or type(files) ~= "table" or #files == 0 then ok, files = pcall(listfiles, ".") end
    if not ok or type(files) ~= "table" then return jobs end
    for _, f in ipairs(files) do
        f = tostring(f)
        local name = f:match("chopa_status_(.-)%.json$")
        if name and name ~= LP.Name then
            local d = ChopaBots.read(f)
            if d and os.time() - (tonumber(d.heartbeat) or 0) < 30 and type(d.job) == "string" and d.job ~= "" then
                jobs[d.job] = name
            end
        end
        local claimer = f:match("chopa_hopclaim_(.-)%.json$")
        if claimer and claimer ~= LP.Name then
            local d = ChopaBots.read(f)
            if d and os.time() - (tonumber(d.at) or 0) < 90 and type(d.job) == "string" then
                jobs[d.job] = jobs[d.job] or claimer
            end
        end
    end
    return jobs
end
function ChopaBots.claim(jobId)
    if type(writefile) ~= "function" then return end
    pcall(function() writefile(ChopaBots.claimFile, HttpService:JSONEncode({job = jobId, at = os.time()})) end)
end
function ChopaBots.sharedVisited()
    local out = {}
    for id, t in pairs((type(isfile) == "function" and isfile(ChopaBots.sharedFile)) and ChopaBots.read(ChopaBots.sharedFile) or {}) do
        if os.time() - (tonumber(t) or 0) < 1200 then out[id] = tonumber(t) end
    end
    return out
end
function ChopaBots.markVisited(jobId)
    if type(writefile) ~= "function" then return end
    local v = ChopaBots.sharedVisited()
    v[jobId] = os.time()
    if game.JobId ~= "" then v[game.JobId] = v[game.JobId] or os.time() end
    pcall(function() writefile(ChopaBots.sharedFile, HttpService:JSONEncode(v)) end)
end
-- joins of all my bots are spaced at least 4 s apart: many joins from one PC in the same second is
-- when Roblox stops connecting (endless loading without a player — the log showed it in bursts)
-- wall clock in seconds with milliseconds (the same for every Roblox window on this PC)
local function chopaNow()
    local ok, ms = pcall(function() return DateTime.now().UnixTimestampMillis end)
    return ok and ms / 1000 or os.time()
end
ChopaBots.JOIN_GAP = 1            -- seconds between two of my bots starting a join (Roblox limits bursts)
function ChopaBots.waitJoinSlot()
    task.wait(math.random() * 0.03)
    for _ = 1, 30 do
        local d = (type(isfile) == "function" and isfile("chopa_joins.json")) and ChopaBots.read("chopa_joins.json")
        local last = d and (tonumber(d.ms) or tonumber(d.at)) or 0
        local free = last + ChopaBots.JOIN_GAP - chopaNow()
        if free <= 0 or (d and d.by == LP.Name) then break end
        SHStats.Status = "Waiting for a free join slot"
        task.wait(free + math.random() * 0.3)
    end
    if type(writefile) == "function" then
        pcall(function() writefile("chopa_joins.json", HttpService:JSONEncode({at = os.time(), ms = chopaNow(), by = LP.Name})) end)
    end
end
function ChopaBots.badServers()
    local out = {}
    for id, t in pairs((type(isfile) == "function" and isfile("chopa_bad_servers.json")) and ChopaBots.read("chopa_bad_servers.json") or {}) do
        if os.time() - (tonumber(t) or 0) < 1800 then out[id] = tonumber(t) end
    end
    return out
end
function ChopaBots.markBad(jobId)
    if type(jobId) ~= "string" or jobId == "" or type(writefile) ~= "function" then return end
    local bad = ChopaBots.badServers()
    bad[jobId] = os.time()
    pcall(function() writefile("chopa_bad_servers.json", HttpService:JSONEncode(bad)) end)
end
_G.__ChopaBots = ChopaBots

SHController.FetchFails = 0
SHController.NextFetchAt = 0
SHController.LastError = ""
SHController.StuckSource = [==[
-- Chopa: loading watchdog (runs from autoexec and after every hop, before the game has loaded).
-- "Stuck" = the game is not loaded and nothing new comes from the server (no new objects and no incoming
-- data for 15 s once loading started, 25 s while still connecting, 75 s in total), or Roblox shows an
-- error window while loading. A slow PC that is still receiving data is never interrupted.
-- Then it leaves for another YBA server: 1st try Roblox matchmaking (always a live server),
-- 2nd try a healthy server from the list, and so on every 10 s. It never leaves the game.
-- The server that hung goes to chopa_bad_servers.json: no bot joins it for 30 min.
-- When Roblox never connects to the server (no player object), scripts cannot move the client at all:
-- after a teleport without a player (25 s) the watchdog CLOSES Roblox at 40 s (freezes the window so
-- Chopa Hub closes the process; the injector starts it again). Also closed: not loaded after 90 s.
-- Every step is written to workspace/chopa_stuck_log.txt
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    if not env.__ChopaWatchdog then
        env.__ChopaWatchdog = true
        task.spawn(function()
            local Players = game:GetService("Players")
            local TS = game:GetService("TeleportService")
            local HS = game:GetService("HttpService")
            local YBA_PLACE = 2809202155                -- Your Bizarre Adventure
            local LOG = "chopa_stuck_log.txt"
            local function placeId() return (tonumber(game.PlaceId) or 0) ~= 0 and game.PlaceId or YBA_PLACE end
            local function log(msg)
                local line = os.date("%d.%m %H:%M:%S") .. "  [loading] " .. msg
                print("[Chopa] " .. msg)
                pcall(function()
                    local old = (type(isfile) == "function" and isfile(LOG)) and readfile(LOG) or ""
                    if type(appendfile) == "function" and #old < 150000 then
                        appendfile(LOG, line .. "\n")
                    elseif type(writefile) == "function" then
                        writefile(LOG, (old .. line .. "\n"):sub(-100000))      -- keep the file small
                    end
                end)
            end
            local function readJSON(path)
                local ok, data = pcall(function() return isfile(path) and HS:JSONDecode(readfile(path)) end)
                return ok and type(data) == "table" and data or nil
            end
            local function markBad(id)
                if type(id) ~= "string" or id == "" or type(writefile) ~= "function" then return end
                local bad = readJSON("chopa_bad_servers.json") or {}
                for k, t in pairs(bad) do if os.time() - (tonumber(t) or 0) > 1800 then bad[k] = nil end end
                bad[id] = os.time()
                pcall(function() writefile("chopa_bad_servers.json", HS:JSONEncode(bad)) end)
            end
            local function requeue()
                local qot = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
                if type(qot) ~= "function" then return end
                local src
                pcall(function()
                    if isfile("auto_trader.lua") then src = 'loadstring(readfile("auto_trader.lua"))()' end
                end)
                if src then pcall(qot, src) end
            end
            local tried = {}
            local function pickServer()
                local data
                local cache = readJSON("chopa_servers_cache.json")
                if cache and type(cache.data) == "table" and os.time() - (tonumber(cache.at) or 0) < 300 then data = cache.data end
                if not data then
                    pcall(function()
                        local p = HS:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId()
                            .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"))
                        if type(p) == "table" and type(p.data) == "table" then data = p.data end
                    end)
                end
                if not data then return nil end
                local bad = readJSON("chopa_bad_servers.json") or {}
                local best = {}
                for _, sv in ipairs(data) do
                    local playing, maxP = tonumber(sv.playing) or 99, tonumber(sv.maxPlayers) or 0
                    local badAt = tonumber(bad[sv.id])
                    if type(sv.id) == "string" and sv.id ~= game.JobId and not tried[sv.id]
                        and not (badAt and os.time() - badAt < 1800)
                        and playing >= 3 and playing <= maxP - 4
                        and (tonumber(sv.fps) or 0) >= 55 and (tonumber(sv.ping) or 999) <= 220 then
                        table.insert(best, sv)
                    end
                end
                table.sort(best, function(a, b) return (tonumber(a.playing) or 0) < (tonumber(b.playing) or 0) end)
                local pick = best[math.random(1, math.max(1, math.min(5, #best)))]
                if pick then tried[pick.id] = true return pick.id end
                return nil
            end
            local function errorWindowShown()
                local ok, shown = pcall(function()
                    local p = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    p = p and p:FindFirstChild("promptOverlay")
                    p = p and p:FindFirstChild("ErrorPrompt")
                    return p ~= nil and p.Visible ~= false
                end)
                return ok and shown == true
            end
            -- Close Roblox: the window is frozen on purpose (busy loop, no yields) → Windows marks it
            -- "Not Responding" → Chopa Hub closes the process → the injector starts Roblox again.
            -- (game:Shutdown() only goes back to the Roblox home screen, the process would stay alive.)
            -- If nothing closes it within 150 s, it leaves the game the normal way.
            local function closeRoblox(reason)
                if env.__ChopaClosing then return end
                env.__ChopaClosing = true
                log("CLOSING Roblox (" .. reason .. ") — window frozen on purpose; Chopa Hub closes it, the injector restarts it")
                task.wait(0.3)
                task.delay(165, function() pcall(function() game:Shutdown() end) end)
                local untilT = os.clock() + 150
                while os.clock() < untilT do
                    pcall(function()
                        local t0 = os.clock()
                        while os.clock() - t0 < 3 do end
                    end)
                end
            end
            env.__ChopaCloseRoblox = closeRoblox
            local function progress()
                local n = 0
                pcall(function() n = #workspace:GetDescendants() end)
                pcall(function() n += #game:GetService("ReplicatedStorage"):GetDescendants() end)
                return n
            end
            local function receiving()             -- data is arriving from the server right now
                local ok, kbps = pcall(function() return game:GetService("Stats").DataReceiveKbps end)
                return ok and type(kbps) == "number" and kbps > 0.5
            end

            -- what kind of join this is (set by the hop / rejoin that queued the script; may arrive a bit later)
            local function joinKind()
                local kind = env.__ChopaJoinKind
                if type(kind) == "string" and kind ~= "" then return kind end
                return "start / autoexec"
            end
            local function joinTarget()
                local t = env.__ChopaJoinTarget
                return (type(t) == "string" and t ~= "") and t or nil
            end
            local started = os.clock()
            local lastCount, lastChange = progress(), os.clock()
            local attempts, nextTry = 0, 0
            log("started (loaded: " .. tostring(game:IsLoaded()) .. ", player: " .. tostring(Players.LocalPlayer ~= nil) .. ")")
            while not game:IsLoaded() do
                task.wait(1)
                local now = os.clock()
                local count = progress()
                if count ~= lastCount or receiving() then lastCount, lastChange = count, now end
                local quietFor = now - lastChange
                local limit = lastCount < 60 and 25 or 15        -- still connecting / already loading
                local errorShown = errorWindowShown()
                if (errorShown or quietFor >= limit or now - started >= 75) and now >= nextTry then
                    attempts += 1
                    nextTry = now + 10
                    local target = joinTarget()
                    if attempts == 1 and target then
                        markBad(target)
                        log("server " .. target:sub(1, 8) .. " did not load — no bot will join it for 30 min")
                    end
                    local why = errorShown and "error window" or string.format("nothing loaded for %.0f s", quietFor)
                    local lp = Players.LocalPlayer
                    local quiet = attempts > 6 and attempts % 6 ~= 0          -- long hang: log once a minute
                    if not lp then
                        -- not connected: the only call left is a teleport without a player object
                        local ok, err = true, nil
                        if attempts % 3 == 1 then
                            requeue()
                            ok, err = pcall(function() TS:Teleport(placeId()) end)
                        end
                        if not quiet then
                            log(string.format("try %d (%s, join: %s): Roblox never connected (no player)%s", attempts, why, joinKind(),
                                attempts % 3 == 1 and (" — teleport without player → " .. (ok and "sent" or tostring(err))) or ""))
                        end
                    else
                        requeue()
                        pcall(function() TS:TeleportCancel() end)
                        local id = (attempts % 2 == 0) and pickServer() or nil
                        if id then
                            local ok, err = pcall(function() TS:TeleportToPlaceInstance(placeId(), id, lp) end)
                            log(string.format("try %d (%s): healthy server %s → %s", attempts, why, id:sub(1, 8), ok and "sent" or tostring(err)))
                        else
                            local ok, err = pcall(function() TS:Teleport(placeId(), lp) end)
                            log(string.format("try %d (%s): YBA matchmaking → %s", attempts, why, ok and "sent" or tostring(err)))
                        end
                    end
                end
                -- no way out from inside: close Roblox (only while really joining a game, never on the app home)
                local lpNow = Players.LocalPlayer
                local joining = (tonumber(game.PlaceId) or 0) ~= 0 or (type(env.__ChopaJoinKind) == "string" and env.__ChopaJoinKind ~= "")
                local tooLong = (not lpNow and quietFor >= 40) or (now - started >= 90)
                if tooLong and joining then
                    closeRoblox(string.format("game not loaded for %.0f s%s, join: %s", now - started,
                        lpNow and "" or ", never connected", joinKind()))
                elseif tooLong and not env.__ChopaHomeNoted then
                    env.__ChopaHomeNoted = true
                    log("not loaded, but no game is being joined (PlaceId 0) — not closing")
                end
            end
            log(string.format("game loaded after %.0f s", os.clock() - started))
        end)
    end
end
]==]

-- one server list shared by all bots for 40 s (fewer requests → Roblox does not block them)
local function fetchFewestServers()
    local cacheFile = "chopa_servers_cache.json"
    local cache = type(isfile) == "function" and isfile(cacheFile) and ChopaBots.read(cacheFile)
    if cache and os.time() - (tonumber(cache.at) or 0) < 40 and type(cache.data) == "table" and #cache.data > 0 then
        return cache.data
    end
    if os.clock() < SHController.NextFetchAt then
        SHController.LastError = "server list blocked (too many requests) — waiting"
        return nil
    end
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true",
        game.PlaceId, (SHController.PickMode == "Random" and math.random(1, 2) == 1) and "Desc" or "Asc"
    )
    local function get(u)
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if type(req) == "function" then
            local ok, res = pcall(req, {Url = u, Method = "GET"})
            if ok and type(res) == "table" then return tonumber(res.StatusCode) or 0, res.Body end
        end
        local ok, body = pcall(function() return game:HttpGet(u) end)
        if ok then return 200, body end
        return 0, tostring(body)
    end
    local code, body = get(url)
    local decodedOk, payload = pcall(function() return HttpService:JSONDecode(body) end)
    if code == 200 and decodedOk and type(payload) == "table" and type(payload.data) == "table" then
        local all = payload.data
        -- a second page gives more healthy servers to choose from
        if type(payload.nextPageCursor) == "string" and #all < 200 then
            local code2, body2 = get(url .. "&cursor=" .. HttpService:UrlEncode(payload.nextPageCursor))
            local ok2, p2 = pcall(function() return HttpService:JSONDecode(body2) end)
            if code2 == 200 and ok2 and type(p2) == "table" and type(p2.data) == "table" then
                for _, sv in ipairs(p2.data) do table.insert(all, sv) end
            end
        end
        SHController.FetchFails = 0
        if type(writefile) == "function" then
            pcall(function() writefile(cacheFile, HttpService:JSONEncode({at = os.time(), data = all})) end)
        end
        return all
    end
    SHController.FetchFails += 1
    local waitFor = math.min(30, 3 * 2 ^ (SHController.FetchFails - 1))
    SHController.NextFetchAt = os.clock() + waitFor
    SHController.LastError = (code == 429 and "Roblox: too many requests" or ("server list error " .. tostring(code)))
        .. string.format(" — retry in %ds", waitFor)
    warn("[MethionSH] " .. SHController.LastError)
    return nil
end

-- "Best" server = healthy + few players:
--   tier 1: server FPS >= 55, ping <= 180 ms, 2+ players, 2+ free slots
--   tier 2: FPS >= 45, ping <= 280 ms, 2+ players          (only if tier 1 is empty)
--   tier 3: any server with 2+ free slots                   (only if both are empty)
-- 0–1 player servers are often old / shutting-down servers that load forever, so they come last.
-- Servers that are known to load: FPS / ping healthy, 3+ players (0–2 player servers are often old
-- servers that are closing after an update — those are the ones that load forever) and room for 4 more.
-- No match → the hop uses Roblox matchmaking, which always gives a live server.
local CANDIDATE_TIERS = {
    {minFps = 55, maxPing = 200, minPlayers = 3, minFree = 4},
    {minFps = 48, maxPing = 280, minPlayers = 3, minFree = 3},
}
local function buildCandidates(list)
    local others = ChopaBots.others(true)
    local shared = ChopaBots.sharedVisited()
    local sharedBad = ChopaBots.badServers()
    for tierIndex, tier in ipairs(CANDIDATE_TIERS) do
        local fresh, any = {}, {}
        for _, server in ipairs(list or {}) do
            local id = server.id
            local playing = tonumber(server.playing) or math.huge
            local maxPlayers = tonumber(server.maxPlayers) or 0
            local fps = tonumber(server.fps) or 50
            local ping = tonumber(server.ping) or 150
            local badAt = SHController.BadJobs[id]
            if type(id) == "string" and id ~= "" and id ~= game.JobId
                and maxPlayers > 0 and playing <= maxPlayers - tier.minFree
                and not (badAt and os.clock() - badAt < 600)
                and not sharedBad[id]                                -- did not load for some bot lately
                and not others[id]                                   -- another of my bots is there
                and fps >= tier.minFps and ping <= tier.maxPing and playing >= tier.minPlayers then
                local entry = {id = id, playing = playing, maxPlayers = maxPlayers, ping = ping, fps = fps,
                    tier = tierIndex, r = math.random()}
                table.insert(any, entry)
                if not isJobVisited(id) and not shared[id] then table.insert(fresh, entry) end
            end
        end
        local out = #fresh > 0 and fresh or any
        if #out > 0 and SHController.PickMode == "Random" then
            -- random server among the working ones, but low-ping ones first (they load faster and
            -- hang less): random order inside each 60 ms ping band
            table.sort(out, function(x, y)
                local bx, by = math.floor(x.ping / 60), math.floor(y.ping / 60)
                if bx ~= by then return bx < by end
                return x.r < y.r
            end)
            return out
        end
        if #out > 0 then
            table.sort(out, function(x, y)
                if x.playing ~= y.playing then return x.playing < y.playing end
                if math.floor(x.ping / 60) ~= math.floor(y.ping / 60) then return x.ping < y.ping end
                return x.r < y.r
            end)
            -- bots hopping at the same moment pick different servers: shuffle the lowest group
            local top = 0
            for i = 1, math.min(8, #out) do
                if out[i].playing <= out[1].playing + 1 then top = i end
            end
            for i = top, 2, -1 do
                local j = math.random(1, i)
                out[i], out[j] = out[j], out[i]
            end
            return out
        end
    end
    return {}
end

function SHController:refreshCandidates(force)
    if self.Fetching then
        while self.Fetching do task.wait(0.05) end
        return #self.Candidates > 0
    end
    if not force and #self.Candidates > 0 and os.clock() - self.CandidatesAt < 60 then return true end
    self.Fetching = true
    local list = fetchFewestServers()
    if list then
        self.Candidates = buildCandidates(list)
        self.CandidatesAt = os.clock()
    end
    self.Fetching = false
    return #self.Candidates > 0
end

local function getPublicServerCandidate()
    SHController:refreshCandidates(false)
    local others = ChopaBots.others(true)
    while #SHController.Candidates > 0 do
        local entry = table.remove(SHController.Candidates, 1)
        local badAt = SHController.BadJobs[entry.id]
        if entry.id ~= game.JobId and not (badAt and os.clock() - badAt < 600) and not others[entry.id] then return entry end
    end
    if SHController:refreshCandidates(true) then return table.remove(SHController.Candidates, 1) end
    return nil
end

local function queueNextRun(url, autoStart)
    local queueFunction = MethionSH_Env.queue_on_teleport or MethionSH_Env.queueonteleport
    if type(queueFunction) ~= "function" and type(MethionSH_Env.syn) == "table" then
        queueFunction = MethionSH_Env.syn.queue_on_teleport
    end
    if type(queueFunction) ~= "function" then
        warn("[MethionSH] This executor does not expose queue_on_teleport.")
        return false
    end

    local mode = Config.FarmTeleportMode == "tween" and "tween" or "instant"
    local filterJson = HttpService:JSONEncode(Config.FarmOnlyItems or {})
    local visitedJson = HttpService:JSONEncode(SHController.VisitedJobs)
    local statsPayload = {
        ServersHopped = SHStats.ServersHopped,
        ItemsCollected = SHStats.ItemsCollected,
        LifetimeMoneyEarned = SHStats.LifetimeMoneyEarned,
        CurrentServerItems = SHStats.CurrentServerItems,
        CurrentServerMoneyEarned = SHStats.CurrentServerMoneyEarned,
        StartedAt = SHStats.StartedAt,
        CurrentJobId = SHStats.CurrentJobId,
        LastMoneyObserved = SHStats.LastMoneyObserved,
        ServerStartedAt = SHStats.ServerStartedAt,
    }
    local statsJson = HttpService:JSONEncode(statsPayload)
    local queueSource = table.concat({
        "repeat task.wait() until game:IsLoaded()",
        "local env = type(getgenv) == \"function\" and getgenv() or _G",
        "local http = game:GetService(\"HttpService\")",
        "local statsOk, stats = pcall(function() return http:JSONDecode(" .. string.format("%q", statsJson) .. ") end)",
        "if statsOk and type(stats) == \"table\" then env.__MethionSHStats = stats end",
        "local mode = " .. string.format("%q", mode),
        "env.__MethionSHFarmTeleportMode = mode",
        "local filterOk, filter = pcall(function() return http:JSONDecode(" .. string.format("%q", filterJson) .. ") end)",
        "if filterOk and type(filter) == \"table\" then env.__MethionSHFarmOnlyItems = filter end",
        "env.__MethionSHReloadOnKick = " .. tostring(Config.AutoRejoinEnabled == true),
        "env.__MethionSHAutoStart = " .. tostring(autoStart == true),
        "env.__MethionSHVisitedJobs = http:JSONDecode(" .. string.format("%q", visitedJson) .. ")",
        "local Players = game:GetService(\"Players\")",
        "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")",
        "local Lighting = game:GetService(\"Lighting\")",
        "local TeleportService = game:GetService(\"TeleportService\")",
        "local player = Players.LocalPlayer",
        "local function enterGame()",
        "    local playerGui = player:WaitForChild(\"PlayerGui\")",
        "    pcall(function() if not playerGui:FindFirstChild(\"HUD\") then local objects = ReplicatedStorage:FindFirstChild(\"Objects\"); local template = objects and objects:FindFirstChild(\"HUD\"); if template then template:Clone().Parent = playerGui end end end)",
        "    local character = player.Character or player.CharacterAdded:Wait()",
        "    local remote = character:WaitForChild(\"RemoteEvent\", 15)",
        "    if remote and remote:IsA(\"RemoteEvent\") then remote:FireServer(\"PressedPlay\") end",
        "    for _, name in ipairs({\"LoadingScreen1\", \"LoadingScreen\"}) do local screen = playerGui:FindFirstChild(name); if screen then screen:Destroy() end end",
        "    player:SetAttribute(\"LOADED\", \"Skip\")",
        "    local dof = Lighting:FindFirstChild(\"DepthOfField\"); if dof then dof:Destroy() end",
        "    local loading = workspace:FindFirstChild(\"LoadingScreen\"); local song = loading and loading:FindFirstChild(\"Song\"); if song then song:Destroy() end",
        "end",
        "task.spawn(function() for _ = 1, 8 do pcall(enterGame); if player:GetAttribute(\"LOADED\") ~= nil and player.Character then break end; task.wait(2) end end)",
        "local deadline = os.clock() + 10",
        "local entered = false",
        "repeat",
        "    task.wait(0.1)",
        "    local character = player.Character",
        "    local humanoid = character and character:FindFirstChildOfClass(\"Humanoid\")",
        "    local root = character and character:FindFirstChild(\"HumanoidRootPart\")",
        "    entered = character ~= nil and character.Parent ~= nil and humanoid ~= nil and humanoid.Health > 0 and root ~= nil and player:GetAttribute(\"LOADED\") == \"Skip\"",
        "until entered or os.clock() >= deadline",
        "if not entered then",
        "    local queueFn = env.queue_on_teleport or env.queueonteleport",
        "    if type(queueFn) ~= \"function\" and type(env.syn) == \"table\" then queueFn = env.syn.queue_on_teleport end",
        "    local retrySource = env.__MethionSHRecoverySource",
        "    if type(queueFn) == \"function\" and type(retrySource) == \"string\" then pcall(queueFn, retrySource) end",
        "    local targetId = nil",
        "    local ok, response = pcall(function() return game:HttpGet(\"https://games.roblox.com/v1/games/\" .. tostring(game.PlaceId) .. \"/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true\") end)",
        "    local badOk, bad = pcall(function() return isfile(\"chopa_bad_servers.json\") and http:JSONDecode(readfile(\"chopa_bad_servers.json\")) or {} end)",
        "    if not badOk or type(bad) ~= \"table\" then bad = {} end",
        "    if ok and type(response) == \"string\" then",
        "        local decodedOk, payload = pcall(function() return http:JSONDecode(response) end)",
        "        if decodedOk and type(payload) == \"table\" and type(payload.data) == \"table\" then",
        "            local candidates = {}",
        "            for _, server in ipairs(payload.data) do local id = server.id; local playing = tonumber(server.playing) or math.huge; local maximum = tonumber(server.maxPlayers) or 0; local badAt = tonumber(bad[id] or 0) or 0; if type(id) == \"string\" and id ~= \"\" and id ~= game.JobId and os.time() - badAt > 1800 and maximum > 0 and playing >= 3 and playing <= maximum - 3 and (tonumber(server.fps) or 50) >= 50 and (tonumber(server.ping) or 150) <= 250 then table.insert(candidates, {id = id, playing = playing, ping = tonumber(server.ping) or 150}) end end",
        "            table.sort(candidates, function(a, b) return a.ping < b.ping end)",
        "            if candidates[1] then targetId = candidates[math.random(1, math.min(3, #candidates))].id end",
        "        end",
        "    end",
        "    local hopOk = false",
        "    if targetId then hopOk = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end) end",
        "    if not hopOk then task.wait(2); if targetId then pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, targetId, player) end) end end",
        "    return",
        "end",
        "task.wait(0.1)",
        "if not (isfile and isfile(" .. string.format("%q", url) .. ")) then warn('[Chopa] auto_trader.lua not found in workspace') return end",
        "local source = readfile(" .. string.format("%q", url) .. ")",
        "assert(type(source) == 'string' and #source > 0, 'MethionSH source is empty')",
        "local chunk, err = loadstring(source)",
        "assert(type(chunk) == 'function', tostring(err or 'MethionSH compile failed'))",
        "chunk()",
        "",
    }, "\n")
    local joinKind = SHController.NextJoinTarget and ("hop to server " .. tostring(SHController.NextJoinTarget):sub(1, 8)) or "hop (matchmaking)"
    queueSource = "local __chopaEnv = (type(getgenv) == \"function\" and getgenv()) or _G\n"
        .. "__chopaEnv.__ChopaJoinTarget = " .. string.format("%q", tostring(SHController.NextJoinTarget or "")) .. "\n"
        .. "__chopaEnv.__ChopaJoinKind = " .. string.format("%q", joinKind) .. "\n"
        .. SHController.StuckSource .. "\n" .. queueSource
    SHController.NextJoinTarget = nil
    if type(writefile) == "function" then pcall(writefile, "chopa_queued.lua", queueSource) end
    MethionSH_Env.__MethionSHRecoverySource = queueSource
    local ok, err = pcall(queueFunction, queueSource)
    if not ok then
        warn("[MethionSH] Could not queue the next run: " .. tostring(err))
        return false
    end
    return true
end

function SHController:hop()
    local chopaAgent = _G.__ChopaAgent
    if chopaAgent and (chopaAgent.pending or chopaAgent.delivering) then
        SHStats.Status = "Order waiting"
        return false                       -- Chopa: a FunPay buyer is coming to this server
    end
    local url = resolvedMethionSHUrl()
    if not url then
        if not self.UrlWarningShown then
            self.UrlWarningShown = true
            AirflowCompat:Notify({
                Title = "MethionSH URL missing",
                Content = "The configured MethionSH source URL is invalid. Check METHIONSH_RAW_URL in the script.",
                Type = "Warning",
                Duration = 7,
            })
            warn("[MethionSH] METHIONSH_RAW_URL is invalid; automatic server hopping cannot re-execute the script.")
        end
        return false
    end
    self.UrlWarningShown = false

    rememberCurrentJob()
    ChopaBots.waitJoinSlot()
    local target = nil
    for _ = 1, ((self.Failures or 0) >= 2 and 0 or 6) do       -- after 2 failed joins: matchmaking below
        target = getPublicServerCandidate()
        if not target then break end
        ChopaBots.claim(target.id)
        task.wait(0.04 + math.random() * 0.04)
        local owner = ChopaBots.others(true)[target.id]
        if not owner or owner > LP.Name then break end          -- two bots booked it at once: first name keeps it
        SHStats.Status = "@" .. owner .. " took that server"
        target = nil
    end
    if not target then
        -- Chopa: no live server in the list, or 2 joins in a row did not work → Roblox matchmaking
        local why = (self.Failures or 0) >= 2 and "2 joins failed" or (SHController.LastError ~= "" and SHController.LastError or "no live server in the list")
        SHController.NextJoinTarget = nil
        if not queueNextRun(url, true) then
            SHStats.Status = "Retrying"
            return false
        end
        pcall(function() TeleportService:TeleportCancel() end)
        shTeleportPending = true
        self.LastTarget = nil
        self.HopStartedAt = os.clock()
        local okMatch, errMatch = pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
        if not okMatch then
            shTeleportPending = false
            self.Failures = (self.Failures or 0) + 1
            SHStats.Status = "Retrying"
            warn("[MethionSH] Matchmaking join failed: " .. tostring(errMatch))
            return false
        end
        SHStats.ServersHopped += 1
        SHStats.Status = "Hopping (matchmaking)"
        warn("[MethionSH] Joining YBA through matchmaking (" .. why .. ")")
        return true
    end
    SHController.LastError = ""
    ChopaBots.markVisited(target.id)
    SHController.NextJoinTarget = target.id

    local previousHopCount = SHStats.ServersHopped
    SHStats.ServersHopped = previousHopCount + 1
    SHStats.Status = "Hopping"
    if not queueNextRun(url, true) then
        SHStats.ServersHopped = previousHopCount
        SHStats.Status = "Retrying"
        return false
    end

    pcall(function() TeleportService:TeleportCancel() end)    -- a hung earlier join would block this one
    shTeleportPending = true
    self.LastTarget = target.id
    self.HopStartedAt = os.clock()
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LP)
    end)
    if not ok then
        shTeleportPending = false
        SHController.BadJobs[target.id] = os.clock()
        ChopaBots.markBad(target.id)
        self.Failures = (self.Failures or 0) + 1
        SHStats.ServersHopped = previousHopCount
        SHStats.Status = "Retrying"
        warn("[MethionSH] Server hop failed: " .. tostring(err))
        return false
    end
    return true
end

_G.__MethionSHReloadAfterKick = function()
    local url = resolvedMethionSHUrl()
    if not url then return false end
    local shouldResumeFarm = SHController.Enabled or State.Farm == true
    if not queueNextRun(url, shouldResumeFarm) then return false end
    -- Chopa: rejoin the server with the fewest players (not a random one)
    for _ = 1, 3 do
        local target = getPublicServerCandidate()
        if target and pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, LP) end) then
            return true
        end
        task.wait(1)
    end
    local ok = pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)   -- last resort: no server list at all
    return ok
end

function SHController:stop()
    self.Enabled = false
    self.Running = false
    self.Token += 1
    _G.__MethionSHPreloading = false
    SHStats.Status = "Idle"
end

function SHController:start()
    if self.Enabled then return end
    self.Enabled = true
    self.Running = true
    self.Token += 1
    local myToken = self.Token
    State.Farm = true
    State.NoClip = true
    SHStats.Status = "Starting"
    _G.__MethionSHPreloading = true

    task.spawn(function()
        while not _G.__MethionSHReady and self.Enabled and self.Token == myToken do
            task.wait(0.1)
        end
        if not self.Enabled or self.Token ~= myToken then return end

        local charDeadline = os.clock() + 30
        local character, humanoid, root
        repeat
            character = LP.Character
            humanoid = character and character:FindFirstChildOfClass("Humanoid")
            root = character and character:FindFirstChild("HumanoidRootPart")
            if character and character.Parent and humanoid and humanoid.Health > 0 and root then break end
            task.wait(0.1)
        until not self.Enabled or self.Token ~= myToken or os.clock() >= charDeadline

        if not self.Enabled or self.Token ~= myToken then return end
        if not (character and character.Parent and humanoid and humanoid.Health > 0 and root) then
            warn("[MethionSH] AFK Farm stopped: character did not finish loading.")
            self:stop()
            State.Farm = false
            State.NoClip = false
            return
        end

        if not bypassSupported then
            warn("[MethionSH] AFK Farm requires the Instant bypass supported by this executor.")
            self:stop()
            State.Farm = false
            State.NoClip = false
            return
        end
        ItemESP.scan()
        if not self.Enabled or self.Token ~= myToken then return end
        _G.__MethionSHPreloading = false
        State.Farm = true
        SHStats.Status = "Farming"
        local sawItems = countFarmableItems() > 0
        local emptySince = nil

        local nextScan = os.clock() + 12.0
        local runStarted = os.clock()

        while self.Enabled and self.Token == myToken do
            if os.clock() >= nextScan then
                ItemESP.scan()
                nextScan = os.clock() + 12.0
            end

            -- Chopa: another of my bots is on this server too → the one whose name is later in order hops
            if os.clock() - (self.DupCheckAt or 0) > 3 then
                self.DupCheckAt = os.clock()
                local owner = ChopaBots.others(true)[game.JobId]
                local chopaAgent = _G.__ChopaAgent
                if owner and owner < LP.Name and not (chopaAgent and (chopaAgent.pending or chopaAgent.delivering)) then
                    self.DupSince = self.DupSince or os.clock()
                    SHStats.Status = "@" .. owner .. " is here — moving"
                    if os.clock() - self.DupSince > 6 then self.DupSince = nil break end
                else
                    self.DupSince = nil
                end
            end
            local remaining = countFarmableItems()
            -- Chopa: load the next servers in the background while the last items are farmed
            if not self.Fetching and os.clock() >= (SHController.NextFetchAt or 0)
                and (#self.Candidates == 0 or os.clock() - self.CandidatesAt > (remaining <= 2 and 20 or 50)) then
                task.spawn(function() self:refreshCandidates(true) end)    -- the hop starts with a fresh list at once
            end
            if remaining > 0 then
                sawItems = true
                emptySince = nil
            else
                emptySince = emptySince or os.clock()
                -- Chopa: instant hop — 0.2 s after the last item (1.5 s if this server never had any,
                -- so items that are still loading after the join are not skipped)
                local grace = sawItems and 0.2 or 1.5
                if os.clock() - emptySince >= grace and os.clock() - runStarted >= 0.5 then
                    break
                end
            end
            task.wait(0.05)
        end

        if not self.Enabled or self.Token ~= myToken then return end

        _G.__MethionSHPreloading = false
        State.Farm = false
        State.NoClip = false
        if AFKFarmToggle and type(AFKFarmToggle.Set) == "function" then
            pcall(function() AFKFarmToggle:Set(true, true) end)
        end
        if autoSellMax then
            pcall(function() Selling.requestAutoSellMaxCheck() end)
        end
        local sellDeadline = os.clock() + 0.5
        while State.Selling and os.clock() < sellDeadline and self.Enabled and self.Token == myToken do
            task.wait(0.1)
        end

        -- Chopa: a started teleport can still fail (server full, "Teleport failed") or hang on the
        -- loading screen. We are still on this server then, so keep trying instead of stopping.
        while self.Enabled and self.Token == myToken do
            local chopaAgent = _G.__ChopaAgent
            if chopaAgent and (chopaAgent.pending or chopaAgent.delivering) then
                SHStats.Status = "Order waiting"
                task.wait(2)
            elseif _G.__ChopaRejoining then
                SHStats.Status = "Rejoining after an error"      -- the rejoin watcher is taking the bot out
                task.wait(1)
            elseif shTeleportPending and os.clock() - (self.HopStartedAt or 0) < 8 then
                task.wait(0.5)
            else
                if shTeleportPending then
                    -- 8 s and still here: that join hung → cancel it, otherwise Roblox refuses every next one
                    shTeleportPending = false
                    pcall(function() TeleportService:TeleportCancel() end)
                    if self.LastTarget then
                        SHController.BadJobs[self.LastTarget] = os.clock()
                        ChopaBots.markBad(self.LastTarget)
                    end
                    self.Failures = (self.Failures or 0) + 1
                    SHStats.ServersHopped = math.max(0, SHStats.ServersHopped - 1)
                    warn("[MethionSH] Join did not finish in 8 s — cancelled, trying another server")
                end
                if (self.Failures or 0) >= 6 and type(_G.__ChopaCloseRoblox) == "function" then
                    _G.__ChopaCloseRoblox("6 server hops in a row did not work")   -- the injector restarts Roblox
                end
                if not self:hop() then
                    task.wait(math.clamp((SHController.NextFetchAt or 0) - os.clock(), 1, 30))
                end
            end
        end
    end)
end

if MethionSH_Env.__MethionSHTeleportFailedConnection then
    pcall(function() MethionSH_Env.__MethionSHTeleportFailedConnection:Disconnect() end)
end
MethionSH_Env.__MethionSHTeleportFailedConnection = TeleportService.TeleportInitFailed:Connect(function(player, result, message)
    if player == LP and shTeleportPending then
        shTeleportPending = false
        SHStats.ServersHopped = math.max(0, SHStats.ServersHopped - 1)
        SHStats.Status = "Retrying"
        -- Chopa: remember the refused server; the hop loop above picks the next one right away
        if SHController.LastTarget then
            SHController.BadJobs[SHController.LastTarget] = os.clock()
            ChopaBots.markBad(SHController.LastTarget)
        end
        SHController.Failures = (SHController.Failures or 0) + 1
        SHController.HopStartedAt = 0
        warn("[MethionSH] Teleport refused (" .. tostring(result and result.Name or message or "?") .. ") — next server")
    end
end)

local function shFormatNumber(value)
    local number = math.max(0, math.floor(tonumber(value) or 0))
    local formatted = tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return formatted:gsub("^,", "")
end

local function shFormatDuration(seconds)
    seconds = math.max(0, math.floor(tonumber(seconds) or 0))
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local remaining = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, remaining)
end

local itemToolSeen = setmetatable({}, {__mode = "k"})
local inventoryContainers = setmetatable({}, {__mode = "k"})
local oldInventoryConnections = MethionSH_Env.__MethionSHInventoryConnections
if type(oldInventoryConnections) == "table" then
    for _, connection in ipairs(oldInventoryConnections) do
        pcall(function() connection:Disconnect() end)
    end
end
local inventoryConnections = {}
MethionSH_Env.__MethionSHInventoryConnections = inventoryConnections
local function isFarmItemTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = tostring(tool.Name or "")
    local normalized = name:gsub("^%s*%d+%s*[xX]%s*", "")
    return ESP_ITEMS[name] ~= nil or ESP_ITEMS[normalized] ~= nil
end

local function countNewFarmItemTool(tool)
    if not isFarmItemTool(tool) or itemToolSeen[tool] then return end
    itemToolSeen[tool] = true
    SHStats.ItemsCollected += 1
    SHStats.CurrentServerItems += 1
end

local function bindInventoryContainer(container)
    if not container or inventoryContainers[container] then return end
    inventoryContainers[container] = true
    for _, child in ipairs(container:GetChildren()) do
        if isFarmItemTool(child) then itemToolSeen[child] = true end
    end
    table.insert(inventoryConnections, container.ChildAdded:Connect(countNewFarmItemTool))
end

local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
if backpack then bindInventoryContainer(backpack) end
if LP.Character then bindInventoryContainer(LP.Character) end
if MethionSH_Env.__MethionSHBackpackWatcher then
    pcall(function() MethionSH_Env.__MethionSHBackpackWatcher:Disconnect() end)
end
MethionSH_Env.__MethionSHBackpackWatcher = LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") or child.Name == "Backpack" then
        bindInventoryContainer(child)
    end
end)
if MethionSH_Env.__MethionSHCharacterAddedConnection then
    pcall(function() MethionSH_Env.__MethionSHCharacterAddedConnection:Disconnect() end)
end
MethionSH_Env.__MethionSHCharacterAddedConnection = LP.CharacterAdded:Connect(function(character)
    bindInventoryContainer(character)
end)

local function bindMoneyStat()
    local statsFolder = LP:FindFirstChild("PlayerStats")
    if not statsFolder then return false end
    local money = statsFolder:FindFirstChild("Money")
    if not money or not money:IsA("ValueBase") then return false end

    if MethionSH_Env.__MethionSHMoneyValueConnection then
        pcall(function() MethionSH_Env.__MethionSHMoneyValueConnection:Disconnect() end)
    end
    local function recordMoney(value)
        local amount = tonumber(value)
        if not amount then return end
        local previous = tonumber(SHStats.LastMoneyObserved)
        if previous and SHStats.CurrentJobId == activeJobId then
            local delta = amount - previous
            if delta > 0 then
                SHStats.LifetimeMoneyEarned += delta
                SHStats.CurrentServerMoneyEarned += delta
            end
        end
        SHStats.LastMoneyObserved = amount
    end
    recordMoney(money.Value)
    MethionSH_Env.__MethionSHMoneyValueConnection = money:GetPropertyChangedSignal("Value"):Connect(function()
        recordMoney(money.Value)
    end)
    return true
end

if MethionSH_Env.__MethionSHMoneyValueConnection then
    pcall(function() MethionSH_Env.__MethionSHMoneyValueConnection:Disconnect() end)
end
if MethionSH_Env.__MethionSHStatsFolderConnection then
    pcall(function() MethionSH_Env.__MethionSHStatsFolderConnection:Disconnect() end)
end
if MethionSH_Env.__MethionSHPlayerStatsAddedConnection then
    pcall(function() MethionSH_Env.__MethionSHPlayerStatsAddedConnection:Disconnect() end)
end
bindMoneyStat()
local statsFolder = LP:FindFirstChild("PlayerStats")
if statsFolder then
    MethionSH_Env.__MethionSHStatsFolderConnection = statsFolder.ChildAdded:Connect(function(child)
        if child.Name == "Money" then task.defer(bindMoneyStat) end
    end)
end
MethionSH_Env.__MethionSHPlayerStatsAddedConnection = LP.ChildAdded:Connect(function(child)
    if child.Name == "PlayerStats" then
        task.defer(function()
            if child.Parent == LP then
                bindMoneyStat()
                if MethionSH_Env.__MethionSHStatsFolderConnection then
                    pcall(function() MethionSH_Env.__MethionSHStatsFolderConnection:Disconnect() end)
                end
                MethionSH_Env.__MethionSHStatsFolderConnection = child.ChildAdded:Connect(function(valueObject)
                    if valueObject.Name == "Money" then task.defer(bindMoneyStat) end
                end)
            end
        end)
    end
end)

local function createServerStatsPanel()
    local oldConnections = MethionSH_Env.__MethionSHStatsUiConnections
    if type(oldConnections) == "table" then
        for _, connection in ipairs(oldConnections) do
            pcall(function() connection:Disconnect() end)
        end
    end
    local connections = {}
    MethionSH_Env.__MethionSHStatsUiConnections = connections

    local coreGui = game:GetService("CoreGui")
    pcall(function()
        local old = coreGui:FindFirstChild("MethionSH_ServerStats")
        if old then old:Destroy() end
    end)
    local parent = coreGui
    local screen = Instance.new("ScreenGui")
    screen.Name = "MethionSH_ServerStats"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    screen.DisplayOrder = 10020
    local parentOk = pcall(function() screen.Parent = parent end)
    if not parentOk or not screen.Parent then
        local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
        screen.Parent = playerGui
    end

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.fromOffset(244, 236)
    panel.Position = UDim2.new(0, 10, 0.36, 0)
    panel.BackgroundColor3 = Color3.fromRGB(10, 17, 38)
    panel.BackgroundTransparency = 0.06
    panel.BorderSizePixel = 0
    panel.Parent = screen
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = panel
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(37, 62, 130)
    outline.Transparency = 0.18
    outline.Thickness = 1
    outline.Parent = panel
    local scale = Instance.new("UIScale")
    scale.Parent = panel

    local header = Instance.new("Frame")
    header.Name = "DragHeader"
    header.BackgroundTransparency = 1
    header.Position = UDim2.fromOffset(0, 0)
    header.Size = UDim2.new(1, 0, 0, 48)
    header.Active = true
    header.Parent = panel

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(13, 8)
    title.Size = UDim2.new(1, -90, 0, 21)
    title.Font = Enum.Font.GothamBold
    title.Text = "SERVER HOPPER"
    title.TextColor3 = Color3.fromRGB(237, 241, 248)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Active = false
    title.Parent = header

    local subtitle = Instance.new("TextLabel")
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.fromOffset(13, 28)
    subtitle.Size = UDim2.new(1, -26, 0, 13)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "SESSION TOTALS"
    subtitle.TextColor3 = Color3.fromRGB(139, 149, 166)
    subtitle.TextSize = 9
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Active = false
    subtitle.Parent = header

    local statusBadge = Instance.new("TextLabel")
    statusBadge.Name = "Status"
    statusBadge.AnchorPoint = Vector2.new(1, 0)
    statusBadge.Position = UDim2.new(1, -11, 0, 11)
    statusBadge.Size = UDim2.fromOffset(69, 20)
    statusBadge.BackgroundColor3 = Color3.fromRGB(37, 64, 58)
    statusBadge.BorderSizePixel = 0
    statusBadge.Font = Enum.Font.GothamBold
    statusBadge.Text = "STARTING"
    statusBadge.TextColor3 = Color3.fromRGB(148, 230, 194)
    statusBadge.TextSize = 9
    statusBadge.Active = false
    statusBadge.Parent = header
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 5)
    statusCorner.Parent = statusBadge

    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Position = UDim2.fromOffset(12, 48)
    accent.Size = UDim2.new(1, -24, 0, 2)
    accent.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
    accent.BorderSizePixel = 0
    accent.Parent = panel

    local rowsFrame = Instance.new("Frame")
    rowsFrame.Name = "Rows"
    rowsFrame.BackgroundTransparency = 1
    rowsFrame.Position = UDim2.fromOffset(12, 57)
    rowsFrame.Size = UDim2.new(1, -24, 0, 150)
    rowsFrame.Parent = panel
    local rowLayout = Instance.new("UIListLayout")
    rowLayout.Padding = UDim.new(0, 2)
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = rowsFrame

    local rows = {}
    local rowSpecs = {
        {"SERVERS HOPPED", "ServersHopped"},
        {"ITEMS THIS SERVER", "CurrentServerItems"},
        {"ITEMS COLLECTED", "ItemsCollected"},
        {"EARNED THIS SERVER", "CurrentServerMoneyEarned", true},
        {"TOTAL MONEY EARNED", "LifetimeMoneyEarned", true},
        {"SESSION TIME", "SessionTime"},
    }
    for index, spec in ipairs(rowSpecs) do
        local row = Instance.new("Frame")
        row.Name = "StatRow" .. tostring(index)
        row.Size = UDim2.new(1, 0, 0, 21)
        row.BackgroundTransparency = 1
        row.LayoutOrder = index
        row.Parent = rowsFrame

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.61, 0, 1, 0)
        label.Font = Enum.Font.GothamMedium
        label.Text = spec[1]
        label.TextColor3 = Color3.fromRGB(151, 161, 177)
        label.TextSize = 9
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Name = "Value"
        value.BackgroundTransparency = 1
        value.Position = UDim2.new(0.61, 0, 0, 0)
        value.Size = UDim2.new(0.39, 0, 1, 0)
        value.Font = Enum.Font.GothamSemibold
        value.Text = "0"
        value.TextColor3 = Color3.fromRGB(237, 241, 248)
        value.TextSize = 11
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.Parent = row
        rows[spec[2]] = {Label = value, Money = spec[3] == true}
    end

    local serverLabel = Instance.new("TextLabel")
    serverLabel.Name = "ServerId"
    serverLabel.BackgroundTransparency = 1
    serverLabel.Position = UDim2.new(0, 12, 1, -20)
    serverLabel.Size = UDim2.new(1, -24, 0, 12)
    serverLabel.Font = Enum.Font.Code
    serverLabel.Text = "SERVER 00000000"
    serverLabel.TextColor3 = Color3.fromRGB(111, 123, 142)
    serverLabel.TextSize = 9
    serverLabel.TextXAlignment = Enum.TextXAlignment.Left
    serverLabel.Parent = panel

    local function updateResponsive()
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
        if viewport.X < 430 then
            scale.Scale = 0.82
            panel.Position = UDim2.new(0, 7, 0.32, 0)
        elseif viewport.X < 700 then
            scale.Scale = 0.9
            panel.Position = UDim2.new(0, 8, 0.34, 0)
        else
            scale.Scale = 1
            panel.Position = UDim2.new(0, 10, 0.36, 0)
        end
    end
    local function bindCamera(camera)
        if camera then
            table.insert(connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsive))
        end
        updateResponsive()
    end
    bindCamera(workspace.CurrentCamera)
    table.insert(connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        bindCamera(workspace.CurrentCamera)
    end))

    local dragging = false
    local dragStart = nil
    local startPosition = nil
    table.insert(connections, header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = panel.Position
        end
    end))
    table.insert(connections, header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart or not startPosition then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end))

    local function updateStats()
        local values = {
            ServersHopped = SHStats.ServersHopped,
            CurrentServerItems = SHStats.CurrentServerItems,
            ItemsCollected = SHStats.ItemsCollected,
            CurrentServerMoneyEarned = SHStats.CurrentServerMoneyEarned,
            LifetimeMoneyEarned = SHStats.LifetimeMoneyEarned,
            SessionTime = shFormatDuration(os.time() - (tonumber(SHStats.StartedAt) or os.time())),
        }
        for key, row in pairs(rows) do
            local value = values[key]
            local txt
            if row.Money then
                txt = "$" .. shFormatNumber(value)
            elseif key == "SessionTime" then
                txt = tostring(value)
            else
                txt = shFormatNumber(value)
            end
            if row.Label.Text ~= txt then row.Label.Text = txt end
        end

        local status = tostring(SHStats.Status or "Idle")
        statusBadge.Text = string.upper(status)
        if status == "Farming" then
            statusBadge.BackgroundColor3 = Color3.fromRGB(37, 64, 58)
            statusBadge.TextColor3 = Color3.fromRGB(148, 230, 194)
        elseif status == "Hopping" then
            statusBadge.BackgroundColor3 = Color3.fromRGB(45, 58, 83)
            statusBadge.TextColor3 = Color3.fromRGB(167, 198, 255)
        elseif status == "Retrying" then
            statusBadge.BackgroundColor3 = Color3.fromRGB(83, 61, 39)
            statusBadge.TextColor3 = Color3.fromRGB(255, 207, 140)
        else
            statusBadge.BackgroundColor3 = Color3.fromRGB(50, 54, 64)
            statusBadge.TextColor3 = Color3.fromRGB(185, 192, 205)
        end
        local job = tostring(game.JobId or "")
        serverLabel.Text = "SERVER " .. (job ~= "" and string.sub(job, 1, 8) or "UNKNOWN")
    end

    updateStats()
    task.spawn(function()
        while screen.Parent do
            pcall(updateStats)
            task.wait(1)
        end
    end)
end

createServerStatsPanel()

local Window = AirflowCompat:CreateWindow({
    Name = "Chopa",
    Title = "Chopa",
    Author = "YBA Hub",
    Icon = "rbxthumb://type=Asset&id=108858394161442&w=150&h=150",
    Theme = "Phantom",
    Folder = "Chopa",
    Size = UDim2.fromOffset(820, 580),
    Transparent = true,
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    OpenButton = {
        Title = "Chopa",
        Enabled = true,
        Draggable = true,
        Scale = 1,
        Color = ColorSequence.new(Color3.fromRGB(37, 99, 235), Color3.fromRGB(56, 189, 248)),
    },
    User = {Enabled = true, Anonymous = false, Title = "Chopa", Avatar = "rbxthumb://type=Asset&id=108858394161442&w=150&h=150", Icon = "rbxthumb://type=Asset&id=108858394161442&w=150&h=150"},
})

pcall(function()
    local mainFrame = Window.MainFrame or Window.Frame or Window.Window
    if mainFrame and mainFrame:IsA("Frame") then
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new {
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 14, 32)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 64, 175)),
        }
        grad.Rotation = 135
        grad.Parent = mainFrame
        mainFrame.BackgroundColor3 = Color3.fromRGB(8, 14, 32)
    end
end)

-- Chopa: blue theme for the whole window (Airflow presets + accent colour)
pcall(function() AirflowLibrary:SetTheme("Ocean", true) end)
pcall(function() AirflowLibrary:SetAccent(Color3.fromRGB(59, 130, 246), true) end)

local function setupAutoPrestige(parentTab)
    
    _G.MethionAutoPrestige = _G.MethionAutoPrestige or {}
    local AP = _G.MethionAutoPrestige
    AP.Enabled = false
    AP.Busy = false
    AP.Status = "Idle"
    if AP.Mode == nil then AP.Mode = "Storyline" end
    if AP.VampFarmModeRequested == nil then AP.VampFarmModeRequested = false end
    if AP.VampFarmActive == nil then AP.VampFarmActive = false end
    if AP.StorylineSweepCancelled == nil then AP.StorylineSweepCancelled = false end
    if AP.VampFarmSweepStarted == nil then AP.VampFarmSweepStarted = false end
    if AP.VampFarmFullSweepCompleted == nil then AP.VampFarmFullSweepCompleted = false end
    if AP.VampFarmSweepHasInteracted == nil then AP.VampFarmSweepHasInteracted = false end
    if AP.VampFarmStep11Reached == nil then AP.VampFarmStep11Reached = false end
    if AP.VampFarmStep11Completed == nil then AP.VampFarmStep11Completed = false end
    if AP.VampFarmPost11SweepActive == nil then AP.VampFarmPost11SweepActive = false end
    if AP.StorylineStep11OptionIndex == nil then AP.StorylineStep11OptionIndex = 1 end
    AP.StorylineStep11OptionIndex = math.clamp(math.floor(tonumber(AP.StorylineStep11OptionIndex) or 1), 1, 6)
    if AP.StorylineStep11FailureCount == nil then AP.StorylineStep11FailureCount = 0 end
    AP.SyncingDropdown = false

    local AutoPlayer = LP
    local AutoGui = AutoPlayer:WaitForChild("PlayerGui")
    local AutoBackpack = AutoPlayer:WaitForChild("Backpack")
    local AutoStats = AutoPlayer:WaitForChild("PlayerStats")
    local AutoLevel = AutoStats:WaitForChild("Level")
    local AutoStand = AutoStats:WaitForChild("Stand")
    local AutoPrestige = AutoStats:WaitForChild("Prestige")
    local AutoSpec = AutoStats:WaitForChild("Spec")
    local AutoExperience = AutoStats:FindFirstChild("Experience")
    local AutoQuestsPath = {"HUD", "Main", "Frames", "Quest", "Quests"}
    local lastNpcKillAt = tick()
    local warnedNoKill = false
    local errorCount = 0
    local runtimeMisses = 0
    local StoryQuestSent = {}
    local VampireQuestSent = false

    local STATUS_LABEL
    local PROGRESS_BAR
    local PROGRESS_DETAIL_LABEL
    local STORYLINE_DROPDOWN
    local updateStorylineProgress
    local syncStorylineDropdown
    local function setStatus(value)
        AP.Status = tostring(value or "Idle")
        if STATUS_LABEL and type(STATUS_LABEL.SetDesc) == "function" then
            pcall(function() STATUS_LABEL:SetDesc(AP.Status) end)
        end
        if updateStorylineProgress then
            pcall(updateStorylineProgress)
        end
    end

    local function notify(title, content, duration)
        pcall(function()
            Window:Notify({Title = title, Content = content, Duration = duration or 5, Type = "Info"})
        end)
    end

    local function autoCharacter()
        local char = AutoPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then return char end
        return AutoPlayer.CharacterAdded:Wait()
    end

    local function autoRoot()
        local char = autoCharacter()
        return char:WaitForChild("HumanoidRootPart", 6)
    end

    local function autoHumanoid()
        local char = autoCharacter()
        return char:FindFirstChildWhichIsA("Humanoid")
    end

    local function autoRemoteEvent()
        local char = autoCharacter()
        local remote = char:FindFirstChild("RemoteEvent") or char:WaitForChild("RemoteEvent", 5)
        return remote and remote:IsA("RemoteEvent") and remote or nil
    end

    local function autoRemoteFunction()
        local char = autoCharacter()
        local remote = char:FindFirstChild("RemoteFunction") or char:WaitForChild("RemoteFunction", 5)
        return remote and remote:IsA("RemoteFunction") and remote or nil
    end

    local function autoRuntimeReady()
        local char = AutoPlayer.Character
        if not char or not char.Parent then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        return root ~= nil and hum ~= nil and hum.Health > 0
            and char:FindFirstChild("RemoteEvent") ~= nil
            and char:FindFirstChild("RemoteFunction") ~= nil
    end

    local function waitAutoRuntime(seconds)
        local deadline = tick() + (seconds or 8)
        repeat
            if autoRuntimeReady() then return true end
            task.wait(0.2)
        until tick() >= deadline or not AP.Enabled
        return autoRuntimeReady()
    end

    local function waitAutoRespawn(seconds)
        local old = AutoPlayer.Character
        local deadline = tick() + (seconds or 22)
        repeat
            local char = AutoPlayer.Character
            if char and char ~= old and char:FindFirstChild("HumanoidRootPart")
                and char:FindFirstChildWhichIsA("Humanoid")
                and char:FindFirstChild("RemoteEvent") and char:FindFirstChild("RemoteFunction") then
                return true
            end
            task.wait(0.2)
        until tick() >= deadline or not AP.Enabled
        return autoRuntimeReady()
    end

    local function autoQuests()
        local found = {}
        local current = AutoGui
        for _, name in ipairs(AutoQuestsPath) do
            current = current and current:FindFirstChild(name)
        end
        if not current then return found end
        for _, obj in ipairs(current:GetChildren()) do
            if obj.Name ~= "Sample" then found[obj.Name] = true end
        end
        return found
    end

    local function isBlacklistedStand(name)
        local list = {"Six Pistols", "Hermit Purple", "Aerosmith", "Beach Boy", "Mr. President", "White Album", "Anubis", "Tusk ACT 1"}
        name = string.lower(tostring(name or ""))
        for _, blocked in ipairs(list) do
            if name == string.lower(blocked) then return true end
        end
        return false
    end

    local function autoStandMorph()
        return autoCharacter():FindFirstChild("StandMorph")
    end

    local function toggleAutoStand()
        local rf = autoRemoteFunction()
        if rf then pcall(function() rf:InvokeServer("ToggleStand", "Toggle") end) end
    end

    local function autoLearnSkill(skillName, treeType)
        local rf = autoRemoteFunction()
        if not rf then return end
        pcall(function()
            rf:InvokeServer("LearnSkill", {Skill = skillName, SkillTreeType = treeType})
        end)
    end

    local function isCaesarSpec()
        if string.find(string.lower(tostring(AutoSpec.Value or "")), "caesar", 1, true) then return true end
        local char = AutoPlayer.Character
        return (char and char:FindFirstChild("Caesar's Headband") ~= nil)
            or AutoBackpack:FindFirstChild("Caesar's Headband") ~= nil
    end

    local function learnAllAutoSkills()
        pcall(function()
            local tree = AutoPlayer:FindFirstChild("StandSkillTree")
            if tree then
                local standName = tostring(AutoStand.Value)
                local wanted = {}
                for _, skill in ipairs(tree:GetChildren()) do
                    local lower = string.lower(skill.Name)
                    local include = true
                    if string.find(standName, "King Crimson", 1, true) then
                        include = string.find(lower, "destructive power", 1, true) ~= nil or lower == "chop"
                    elseif standName == "Star Platinum: The World" or standName == "Star Platinum The World" then
                        include = string.find(lower, "destructive power", 1, true) ~= nil
                            or string.find(lower, "precision", 1, true) ~= nil
                            or lower == "ora kicks" or lower == "bearing shot" or lower == "ora beatdown"
                    end
                    if include and skill:IsA("BoolValue") and not skill.Value then table.insert(wanted, skill) end
                end
                table.sort(wanted, function(a, b) return a.Name < b.Name end)
                for _, skill in ipairs(wanted) do
                    if not AP.Enabled then return end
                    autoLearnSkill(skill.Name, "Stand")
                    task.wait(0.05)
                end
            end
            if isCaesarSpec() then
                for _, skill in ipairs({"Bubble Launcher", "Breathing Technique I"}) do
                    if not AP.Enabled then return end
                    autoLearnSkill(skill, "Spec")
                    task.wait(0.05)
                end
            else
                for _, skill in ipairs({"Lung Capacity I", "Lung Capacity II", "Lung Capacity III", "Lung Capacity IV", "Lung Capacity V", "Breathing Technique I", "Breathing Technique II", "Breathing Technique III", "Breathing Technique IV", "Breathing Technique V"}) do
                    if not AP.Enabled then return end
                    autoLearnSkill(skill, "Spec")
                    task.wait(0.05)
                end
            end
        end)
    end

    local function autoSkillOnKey(char, keyName)
        local folder = char and char:FindFirstChild("StandSkills")
        local node = folder and folder:FindFirstChild("Enum.KeyCode." .. keyName)
        return node and node.Value or nil
    end

    local function autoSkillCooling(skillName)
        if not skillName or skillName == "" then return false end
        local hud = AutoGui:FindFirstChild("HUD")
        local cooldowns = hud and hud:FindFirstChild("Cooldowns")
        local frame = cooldowns and cooldowns:FindFirstChild("Frame")
        return frame ~= nil and frame:FindFirstChild(skillName) ~= nil
    end

    local function autoHasStandSkill(skillName)
        local tree = AutoPlayer:FindFirstChild("StandSkillTree")
        local skill = tree and tree:FindFirstChild(skillName)
        return skill and skill.Value == true or false
    end

    local function autoKillSkillRule(skillName)
        local lower = string.lower(tostring(skillName or ""))
        if string.find(lower, "finger", 1, true) or string.find(lower, "kick", 1, true) then
            return {match = true, hpGate = 0.4}
        elseif string.find(lower, "rage", 1, true) then
            return {match = true, hpGate = nil}
        end
        return nil
    end

    local function autoStandKeyPlan(standName)
        local lower = string.lower(tostring(standName or ""))
        if string.find(lower, "silver chariot", 1, true) then return {"Y", "H", "Z", "T"} end
        if string.find(lower, "d4c", 1, true) then return {"Y", "U"} end
        if string.find(lower, "king crimson", 1, true) then return {} end
        return {"H", "T", "X", "Y", "U", "Z"}
    end

    local function findAliveAutoNPC(npcName)
        local living = workspace:FindFirstChild("Living")
        if not living then return nil end
        for _, npc in ipairs(living:GetChildren()) do
            local hp = npc:FindFirstChild("Health")
            if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") and hp and hp.Value > 0 then
                return npc
            end
        end
        return nil
    end

    local function pauseForCombatDialogue(gui)
        if not Gui.hasCombatDialogueWarning(gui) then return false end
        AP.CombatDialogueDeferred = true
        local untilTime = tonumber(AP.CombatDialoguePauseUntil) or 0
        if untilTime <= tick() then
            untilTime = tick() + 10
            AP.CombatDialoguePauseUntil = untilTime
            setStatus("Fight detected. Waiting 10 seconds before trying again.")
        else
            setStatus("Fight detected. Waiting before trying again.")
        end

        while AP.Enabled and tick() < untilTime do
            task.wait(math.min(0.1, math.max(0, untilTime - tick())))
        end
        if not AP.Enabled then return true end
        AP.CombatDialoguePauseUntil = 0

        for _ = 1, 3 do
            local current = Gui.currentDialogue()
            if not current or not Gui.hasCombatDialogueWarning(current) then break end
            pcall(function() Gui.skipClick() end)
            task.wait(0.15)
        end
        return true
    end

    local function openAutoDialogue(npcName, dialogueName, forceReplace)
        if State.Selling then return false end
        local remote = autoRemoteEvent()
        if not remote then return false end
        local previousGui = Gui.currentDialogue()
        local previousSignature = Gui.dialogueSignature(previousGui)

        local function waitForRequestedDialogue(timeout)
            local deadline = tick() + (timeout or 3)
            local sawPreviousClose = false
            while tick() < deadline do
                local current = Gui.currentDialogue()
                if not current then
                    if previousGui then sawPreviousClose = true end
                elseif not previousGui or current ~= previousGui or sawPreviousClose
                    or Gui.dialogueSignature(current) ~= previousSignature then
                    return true
                end
                task.wait(0.05)
            end
            return false
        end

        local dialogueRoot = ReplicatedStorage:FindFirstChild("Dialogue")
        local target = nil
        if dialogueRoot then

            local speakerNode = nil
            if type(npcName) == "string" and npcName ~= "" then
                speakerNode = dialogueRoot:FindFirstChild(npcName)
                    or dialogueRoot:FindFirstChild(npcName, true)
            end

            if speakerNode then
                if type(dialogueName) == "string" and dialogueName ~= "" then
                    if speakerNode.Name == dialogueName then
                        target = speakerNode
                    else
                        target = speakerNode:FindFirstChild(dialogueName, true)
                    end
                end
                if not target then target = speakerNode end
            end

            if not target and type(dialogueName) == "string" then
                target = dialogueRoot:FindFirstChild(dialogueName, true)
            end
            if not target and type(npcName) == "string" then
                target = dialogueRoot:FindFirstChild(npcName, true)
            end
        end

        if target and (not previousGui or forceReplace) then
            pcall(function()
                remote:FireServer("PromptTriggered", target)
            end)
            if waitForRequestedDialogue(3) then return true end
        elseif target and previousGui and not forceReplace then
            return true
        end

        pcall(function()
            remote:FireServer("DialogueInteracted", {
                DialogueName = dialogueName or npcName,
                Speaker = npcName,
            })
        end)
        return waitForRequestedDialogue(3)
    end

    local function advanceAutoDialogue(optionName, timeoutSec)
        local optionSequence = type(optionName) == "table" and optionName or nil
        local deadline = tick() + (timeoutSec or (optionSequence and 8.0 or 4.0))
        local nextActionAt = tick() + 0.22
        local sawDialogue = false
        local clickedAny = false

        local sequenceIndex = optionSequence and math.clamp(
            math.floor(tonumber(AP.StorylineStep11OptionIndex) or 1),
            1,
            #optionSequence + 1
        ) or 1
        local waitingSignature = nil
        local transitionDeadline = 0

        local function signature(gui)
            return Gui.dialogueSignature(gui)
        end

        while tick() < deadline do
            if State.Selling then return false end
            local gui = Gui.currentDialogue()
            if gui and Gui.hasCombatDialogueWarning(gui) then
                pauseForCombatDialogue(gui)
                return false
            end
            if not gui then
                if sawDialogue then
                    if not optionSequence or sequenceIndex > #optionSequence then
                        return true
                    end
                    return false
                end
                task.wait(0.05)
            else
                sawDialogue = true
                if optionSequence and waitingSignature then
                    local currentSignature = signature(gui)
                    if currentSignature ~= waitingSignature or tick() >= transitionDeadline then
                        waitingSignature = nil
                    else
                        task.wait(0.025)
                        continue
                    end
                end

                if tick() >= nextActionAt then

                    local clicked = false
                    local signatureBeforeClick = optionSequence and signature(gui) or nil
                    if optionSequence and sequenceIndex > #optionSequence then

                        clicked = Gui.skipClick()
                    else
                        local desiredOption = optionSequence and optionSequence[sequenceIndex]
                            or (type(optionName) == "string" and optionName or "Option1")
                        local target = Gui.option(gui, desiredOption)

                        if not optionSequence and not (target and target.Parent and Gui.isVisible(target)) then
                            target = nil
                            local options = gui:FindFirstChild("Frame")
                            options = options and options:FindFirstChild("Options")
                            if options then
                                for index = 1, 8 do
                                    local option = options:FindFirstChild("Option" .. index)
                                    local button = option and (option:FindFirstChildOfClass("TextButton") or option:FindFirstChildWhichIsA("GuiButton"))
                                    if button and Gui.isVisible(button) then
                                        target = button
                                        break
                                    end
                                end
                            end
                        end

                        if target and target.Parent and Gui.isVisible(target) then
                            clicked = Gui.click(target)
                            if clicked and optionSequence then
                                sequenceIndex += 1
                                AP.StorylineStep11OptionIndex = sequenceIndex
                            end
                        elseif not Gui.hasVisibleOptions(gui) then
                            clicked = Gui.skipClick()
                        end
                    end

                    if clicked then
                        clickedAny = true
                        nextActionAt = tick() + 0.18
                        if optionSequence then
                            waitingSignature = signatureBeforeClick
                            transitionDeadline = tick() + 0.65
                        end
                    else
                        nextActionAt = tick() + 0.12
                    end
                end
                task.wait(0.025)
            end
        end

        if optionSequence then

            return sawDialogue and sequenceIndex > #optionSequence
        end

        return sawDialogue and Gui.currentDialogue() == nil
    end

    local function fireDialogue(npcName, dialogueName, optionName)
        if State.Selling then return false end
        AP.CombatDialogueDeferred = false
        local optionSequence = type(optionName) == "table" and optionName or nil
        local gui = Gui.currentDialogue()
        if gui and Gui.hasCombatDialogueWarning(gui) then
            pauseForCombatDialogue(gui)
            return false
        end

        local replacingCompletedStep11 = not optionSequence
            and tonumber(AP.StorylineStep11OptionIndex or 1) > 5
        if optionSequence and AP.StorylineStep11OptionIndex > #optionSequence and not gui then
            AP.StorylineStep11OptionIndex = 1
            return true
        end

        if not gui or replacingCompletedStep11 then
            if not openAutoDialogue(npcName, dialogueName, replacingCompletedStep11) then
                setStatus(replacingCompletedStep11
                    and ("Waiting for Storyline " .. tostring(npcName) .. " to replace the completed #7 dialogue")
                    or ("Waiting for dialogue: " .. tostring(npcName)))
                return false
            end
            if replacingCompletedStep11 then
                AP.StorylineStep11OptionIndex = 1
            end
            task.wait(0.22)
        end

        if not Gui.currentDialogue() then return false end
        local timeout = optionSequence and 18.0 or 6.0
        local completed = advanceAutoDialogue(optionName or "Option1", timeout)
        if completed and optionSequence and not Gui.currentDialogue() then
            AP.StorylineStep11OptionIndex = 1
        end
        return completed
    end

    local STORY_KEYS = {"#1", "#1", "#1", "#2", "#3", "#3", "#3", "#4", "#5", "#6", "#7", "#8", "#9", "#10", "#11", "#11", "#12", "#14"}
    local STORY_DIALOGUES = {"Dialogue2", "Dialogue6", "Dialogue6", "Dialogue3", "Dialogue3", "Dialogue3", "Dialogue6", "Dialogue3", "Dialogue5", "Dialogue5", "Dialogue5", "Dialogue4", "Dialogue7", "Dialogue6", "Dialogue8", "Dialogue11", "Dialogue3", "Dialogue2"}
    local STORY_OPTION_SEQUENCES = {}
    for i, key in ipairs(STORY_KEYS) do
        if key == "#7" then
            STORY_OPTION_SEQUENCES[i] = {"Option1", "Option1", "Option2", "Option1", "Option1"}
            break
        end
    end
    local STORY_NPCS = {
        {quest = "Help Giorno by Defeating Security Guards", npc = "Security Guard", offZ = 2, offY = 20},
        {quest = "Defeat Leaky Eye Luca", npc = "Leaky Eye Luca", offZ = 2, offY = 20},
        {quest = "Defeat Bucciarati", npc = "Bucciarati", offZ = 2, offY = 20},
        {quest = "Defeat Fugo And His Purple Haze", npc = "Fugo", offZ = 2, offY = 20},
        {quest = "Defeat Pesci", npc = "Pesci", offZ = 0, offY = 20},
        {quest = "Defeat Ghiaccio", npc = "Ghiaccio", offZ = 2, offY = 20},
        {quest = "Defeat Diavolo", npc = "Diavolo", offZ = 2, offY = 20},
    }
    local VAMPIRE_QUEST = "Take down 3 vampires"
    local STORYLINE_LABELS = {}
    for i, key in ipairs(STORY_KEYS) do
        STORYLINE_LABELS[i] = string.format("Step %02d - Storyline %s (%s)", i, key, STORY_DIALOGUES[i])
    end

    updateStorylineProgress = function()
        if not PROGRESS_BAR then return end
        local total = #STORY_KEYS
        local cursor = math.clamp(math.floor(tonumber(AP.StorylineCursor) or 1), 1, total + 1)
        local percent
        if AP.VampFarmActive or (cursor > total and (AP.Mode ~= "Vamp Farm" or AP.VampFarmFullSweepCompleted == true)) then
            percent = 100
        elseif cursor > total then
            percent = 99
        else
            percent = math.floor((math.clamp(cursor - 1, 0, total) / total) * 100 + 0.5)
        end
        local detail
        if AP.VampFarmActive then
            detail = "Vamp Farm active. Storyline sweep cancelled."
        elseif cursor <= total then
            detail = string.format("Next: Storyline %s · step %d/%d", STORY_KEYS[cursor], cursor, total)
            if AP.Mode == "Vamp Farm" and AP.VampFarmSweepStarted then
                detail = "Sweeping from Storyline #1 to find your current progress.\n" .. detail
            elseif AP.Mode == "Vamp Farm" then
                detail = "Vamp Farm selected. Sweep starts at Storyline #1 when enabled.\n" .. detail
            end
        else
            if AP.Mode == "Vamp Farm" and AP.VampFarmFullSweepCompleted ~= true then
                detail = "All 18 mapped steps checked. Confirming no storyline quest remains before Vamp Farm."
            else
                detail = "Mapped storylines complete. Checking the vampire quest."
            end
        end
        pcall(function()
            PROGRESS_BAR:Set(percent / 100, true)
        end)
        if PROGRESS_DETAIL_LABEL and type(PROGRESS_DETAIL_LABEL.SetDesc) == "function" then
            pcall(function()
                PROGRESS_DETAIL_LABEL:SetDesc(detail)
            end)
        end
    end

    syncStorylineDropdown = function()
        if not STORYLINE_DROPDOWN or AP.SyncingDropdown then return end
        local target
        if AP.VampFarmActive then
            target = "Vamp Farm"
        elseif AP.Mode == "Vamp Farm" and not AP.VampFarmSweepStarted then
            target = "Vamp Farm"
        else
            local cursor = math.clamp(math.floor(tonumber(AP.StorylineCursor) or 1), 1, #STORY_KEYS + 1)
            if AP.Mode == "Vamp Farm" and AP.VampFarmSweepStarted and cursor > #STORY_KEYS then
                target = "Vamp Farm"
            else
                target = STORYLINE_LABELS[math.min(cursor, #STORY_KEYS)] or "Continue where I left off"
            end
        end
        if target then
            AP.SyncingDropdown = true
            pcall(function() STORYLINE_DROPDOWN:Set(target) end)
            AP.SyncingDropdown = false
        end
    end

    local markVampFarm
    markVampFarm = function(reason)
        if AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true then
            local cursor = math.floor(tonumber(AP.StorylineCursor) or 1)
            if AP.VampFarmFullSweepCompleted ~= true or cursor <= #STORY_KEYS then
                return false
            end
        end
        if AP.VampFarmActive and AP.StorylineSweepCancelled then return true end
        AP.Mode = "Vamp Farm"
        AP.VampFarmModeRequested = true
        AP.VampFarmActive = true
        AP.StorylineSweepCancelled = true
        AP.VampFarmSweepStarted = true
        AP.StorylineCursor = #STORY_KEYS + 1
        AP.StorylineCursorVersion = 2
        AP.StorylineCheckpointKnown = true
        AP.StorylineForceRecoverySweep = false
        AP.StorylineRecoveryUsed = false
        syncStorylineDropdown()
        updateStorylineProgress()
        setStatus("Vamp Farm is active.")
        return true
    end

    if AP.StorylineCursorVersion ~= 2 then
        AP.StorylineCursor = 1
        AP.StorylineCursorVersion = 2
        AP.StorylineLastDialogueIndex = nil
        AP.StorylineLastQuest = nil
        AP.StorylineRecoveryUsed = false
        AP.StorylineForceRecoverySweep = false
        AP.StorylineCheckpointKnown = false
    end
    AP.StorylineCursor = math.clamp(math.floor(tonumber(AP.StorylineCursor) or 1), 1, #STORY_KEYS + 1)
    if AP.StorylineRecoveryUsed == nil then AP.StorylineRecoveryUsed = false end
    if AP.StorylineForceRecoverySweep == nil then AP.StorylineForceRecoverySweep = false end
    if AP.StorylineCheckpointKnown == nil then AP.StorylineCheckpointKnown = false end

    local function delayVampFarmUntilStorylineEnd()

        local cursor = math.floor(tonumber(AP.StorylineCursor) or 1)
        return AP.Mode == "Vamp Farm"
            and AP.VampFarmModeRequested == true
            and (AP.VampFarmFullSweepCompleted ~= true or cursor <= #STORY_KEYS)
    end

    local function currentAutoProgressQuest()

        local quests = autoQuests()
        for _, entry in ipairs(STORY_NPCS) do
            if quests[entry.quest] then return entry.quest end
        end
        if quests[VAMPIRE_QUEST] then

            if AP.Mode ~= "Vamp Farm" or AP.VampFarmModeRequested ~= true then
                return nil
            end
            local cursor = math.floor(tonumber(AP.StorylineCursor) or 1)
            if delayVampFarmUntilStorylineEnd()
                or AP.VampFarmFullSweepCompleted ~= true
                or cursor <= #STORY_KEYS then
                return nil
            end
            if markVampFarm then markVampFarm("Vampire quest detected after full storyline sweep") end
            return VAMPIRE_QUEST
        end
        return nil
    end

    local function saveStorylineCheckpoint(nextIndex, matchedIndex, questName)
        AP.StorylineCursor = math.clamp(math.floor(tonumber(nextIndex) or 1), 1, #STORY_KEYS + 1)
        if matchedIndex then AP.StorylineLastDialogueIndex = matchedIndex end
        if questName then
            AP.StorylineLastQuest = questName
            AP.StorylineRecoveryUsed = false
        end
        AP.StorylineCursorVersion = 2
        AP.StorylineCheckpointKnown = true
        if syncStorylineDropdown then syncStorylineDropdown() end
        if updateStorylineProgress then updateStorylineProgress() end
    end

    local function fireStorylineRange(firstIndex, lastIndex)
        if AP.Mode == "Vamp Farm" and not AP.VampFarmActive then
            AP.VampFarmSweepStarted = true
        end
        for i = firstIndex, lastIndex do
            if not AP.Enabled then return false, false end
            local stepCharacter = AutoPlayer.Character
            AP.StorylineCursor = i
            if syncStorylineDropdown then syncStorylineDropdown() end
            if updateStorylineProgress then updateStorylineProgress() end

            if i == 11
                and AP.Mode == "Vamp Farm"
                and AP.VampFarmModeRequested == true
                and AP.VampFarmStep11Completed == true then
                saveStorylineCheckpoint(12, 11, nil)
                AP.VampFarmPost11SweepActive = true
                setStatus("Storyline step 7 is done. Continuing from step 8.")
                continue
            end

            local alreadyActive = currentAutoProgressQuest()
            if alreadyActive then
                AP.StorylineLastQuest = alreadyActive
                return true, true
            end

            setStatus("Continuing storyline " .. STORY_KEYS[i] .. " (" .. tostring(i) .. "/" .. tostring(#STORY_KEYS) .. ")")
            local choices = STORY_OPTION_SEQUENCES[i] or "Option1"
            local interacted = fireDialogue("Storyline " .. STORY_KEYS[i], STORY_DIALOGUES[i], choices)
            task.wait(0.1)

            if not interacted and not AP.CombatDialogueDeferred
                and AP.StorylineForceRecoverySweep and AP.Enabled and not STORY_OPTION_SEQUENCES[i] then
                task.wait(0.2)
                interacted = fireDialogue("Storyline " .. STORY_KEYS[i], STORY_DIALOGUES[i], choices)
                task.wait(0.1)
            end

            if AP.CombatDialogueDeferred then
                AP.CombatDialogueDeferred = false
                saveStorylineCheckpoint(i, nil, nil)
                setStatus("Can’t talk during combat. Trying again in 10 seconds.")
                return false, false
            end

            local characterAfterStep = AutoPlayer.Character
            local humanoidAfterStep = characterAfterStep and characterAfterStep:FindFirstChildWhichIsA("Humanoid")
            local diedOrResetDuringStep = characterAfterStep ~= stepCharacter
                or not humanoidAfterStep
                or humanoidAfterStep.Health <= 0
            if diedOrResetDuringStep then
                if not characterAfterStep or not humanoidAfterStep or humanoidAfterStep.Health <= 0 then
                    if not waitAutoRespawn(22) then
                        AP.StorylineCursor = i
                        AP.StorylineCheckpointKnown = true
                        AP.StorylineForceRecoverySweep = false
                        if syncStorylineDropdown then syncStorylineDropdown() end
                        if updateStorylineProgress then updateStorylineProgress() end
                        setStatus("Died during Storyline " .. STORY_KEYS[i] .. ". Will try again after respawning.")
                        return false, false
                    end
                end
                task.wait(0.55)
                AP.StorylineCursor = i
                AP.StorylineCursorVersion = 2
                AP.StorylineCheckpointKnown = true
                AP.StorylineForceRecoverySweep = false
                AP.StorylineRecoveryUsed = false
                if syncStorylineDropdown then syncStorylineDropdown() end
                if updateStorylineProgress then updateStorylineProgress() end
                setStatus("You respawned during Storyline " .. STORY_KEYS[i] .. ". Trying the same step again.")
                return false, false
            end

            local requireThisStep = AP.Mode == "Vamp Farm"
                and AP.VampFarmModeRequested == true
                and AP.VampFarmSweepStarted == true
                and AP.VampFarmFullSweepCompleted ~= true
                and ((i == 12 and AP.VampFarmStep11Reached == true)
                    or (i > 12 and AP.VampFarmPost11SweepActive == true))

            if AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true then
                if interacted then
                    AP.VampFarmSweepHasInteracted = true
                    if i == 11 then
                        AP.VampFarmStep11Reached = true
                        AP.VampFarmStep11Completed = true
                        AP.VampFarmPost11SweepActive = true
                    end
                    if i == 12 then AP.VampFarmPost11SweepActive = true end
                end
            end
            if i == 11 and interacted then
                AP.StorylineStep11FailureCount = 0
            end

            local questName = currentAutoProgressQuest()
            if questName then
                if questName == VAMPIRE_QUEST then

                    return true, true
                end
                saveStorylineCheckpoint(i + 1, i, questName)
                AP.StorylineForceRecoverySweep = false
                setStatus("Finished Storyline " .. STORY_KEYS[i] .. ": " .. questName)
                return true, true
            end

            if STORY_OPTION_SEQUENCES[i] and not interacted and not Gui.currentDialogue() then
                if i == 11 and AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true then
                    AP.VampFarmStep11Reached = true
                    AP.VampFarmStep11Completed = true
                    AP.VampFarmPost11SweepActive = true
                end
                AP.StorylineStep11OptionIndex = 1
                AP.StorylineStep11FailureCount = 0
                saveStorylineCheckpoint(i + 1, i, nil)
                setStatus("Could not do Storyline " .. STORY_KEYS[i] .. ". Moving on.")
                continue
            end

            if not interacted and requireThisStep then
                saveStorylineCheckpoint(i, nil, nil)
                setStatus("Vamp Farm paused at step " .. tostring(i) .. ". Waiting for this dialogue.")
                return false, false
            end

            if STORY_OPTION_SEQUENCES[i] and not interacted then
                AP.StorylineForceRecoverySweep = false
                for _ = 1, 3 do
                    if not Gui.currentDialogue() then break end
                    pcall(Gui.skipClick)
                    task.wait(0.15)
                end

                if i == 11 then
                    AP.StorylineStep11FailureCount = (tonumber(AP.StorylineStep11FailureCount) or 0) + 1
                    if AP.StorylineStep11FailureCount >= 2 then

                        AP.StorylineStep11OptionIndex = #STORY_OPTION_SEQUENCES[i] + 1
                        if AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true then
                            AP.VampFarmStep11Reached = true
                            AP.VampFarmStep11Completed = true
                            AP.VampFarmPost11SweepActive = true
                        end
                        saveStorylineCheckpoint(i + 1, i, nil)
                        setStatus("Storyline step 7 got stuck. Moving to step 8.")
                        continue
                    end
                end

                saveStorylineCheckpoint(i, nil, nil)
                setStatus("Storyline " .. STORY_KEYS[i] .. " was incomplete. Trying again.")
                return false, false
            end

            if not interacted and Gui.currentDialogue() then
                saveStorylineCheckpoint(i, nil, nil)
                setStatus("Finishing Storyline " .. STORY_KEYS[i] .. " before continuing.")
                return false, false
            end

            if interacted then
                saveStorylineCheckpoint(i + 1, i, nil)
            elseif AP.StorylineForceRecoverySweep and AP.Enabled then

                saveStorylineCheckpoint(i + 1, i, nil)
                setStatus("Checking Storyline " .. STORY_KEYS[i])
            else

                saveStorylineCheckpoint(i + 1, i, nil)
                setStatus("Skipping unavailable Storyline " .. STORY_KEYS[i] .. ". Moving on.")
            end
        end
        return false, true
    end

    local function fireStorylineSweep()
        if AP.StorylineSweepCancelled or AP.VampFarmActive then
            return false
        end
        local activeQuest = currentAutoProgressQuest()
        if activeQuest then
            AP.StorylineLastQuest = activeQuest
            return true
        end

        local startIndex = math.clamp(math.floor(tonumber(AP.StorylineCursor) or 1), 1, #STORY_KEYS + 1)
        if startIndex <= #STORY_KEYS then
            local found, completed = fireStorylineRange(startIndex, #STORY_KEYS)
            if found then return true end
            if not completed or not AP.Enabled then return false end
        end

        if startIndex > 1
            and AP.StorylineForceRecoverySweep
            and not AP.StorylineRecoveryUsed
            and AP.Enabled
            and not (AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true) then
            AP.StorylineRecoveryUsed = true
            local found, completed = fireStorylineRange(1, math.min(startIndex - 1, #STORY_KEYS))
            if found then return true end
            if not completed or not AP.Enabled then return false end
        elseif startIndex == 1 and AP.StorylineForceRecoverySweep then
            AP.StorylineRecoveryUsed = true
        end

        AP.StorylineCursor = #STORY_KEYS + 1
        if syncStorylineDropdown then syncStorylineDropdown() end
        if updateStorylineProgress then updateStorylineProgress() end

        local finalQuests = autoQuests()
        for _, entry in ipairs(STORY_NPCS) do
            if finalQuests[entry.quest] then
                AP.StorylineCheckpointKnown = true
                setStatus("Storyline nearly done. Finishing quest: " .. entry.quest)
                return true
            end
        end

        AP.VampFarmFullSweepCompleted = true
        AP.Mode = "Vamp Farm"
        AP.VampFarmModeRequested = true
        AP.VampFarmSweepStarted = true
        AP.VampFarmActive = false
        AP.StorylineSweepCancelled = false
        AP.StorylineCursor = #STORY_KEYS + 1
        AP.StorylineCursorVersion = 2
        AP.StorylineCheckpointKnown = true
        AP.StorylineForceRecoverySweep = false
        AP.StorylineRecoveryUsed = false
        if syncStorylineDropdown then syncStorylineDropdown() end
        if updateStorylineProgress then updateStorylineProgress() end
        setStatus("Storyline complete. Starting Vamp Farm.")

        local vampireQuestNow = finalQuests[VAMPIRE_QUEST]
        if vampireQuestNow then
            markVampFarm("Full 18-step storyline sweep completed; existing vampire quest retained")
            return true
        end

        return currentAutoProgressQuest() ~= nil
    end

    local function aggressiveStorylineAdvance(timeoutSec)
        local deadline = tick() + (timeoutSec or 15)
        while AP.Enabled and tick() < deadline do
            if currentAutoProgressQuest() then return true end
            local before = AP.StorylineCursor
            fireStorylineSweep()
            if currentAutoProgressQuest() then return true end
            if AP.StorylineCursor >= #STORY_KEYS + 1 and AP.StorylineRecoveryUsed then
                return false
            end
            if AP.StorylineCursor == before then task.wait(0.2) end
        end
        return currentAutoProgressQuest() ~= nil
    end

    local function prestigeKillNPC(npcName, offsetZ, offsetY)
        local npc
        local deadline = tick() + 12
        while AP.Enabled and tick() < deadline do
            local living = workspace:FindFirstChild("Living")
            npc = living and living:FindFirstChild(npcName)
            if npc and npc:FindFirstChild("HumanoidRootPart") then break end
            setStatus("Waiting for " .. npcName .. " to spawn")
            task.wait(0.4)
        end
        if not npc or not npc:FindFirstChild("HumanoidRootPart") then return false end

        local npcRoot = npc.HumanoidRootPart
        local healthValue = npc:FindFirstChild("Health")
        local maxHP = (healthValue and tonumber(healthValue.Value)) or 100
        local killConfirmed = false
        local xpConnection
        if AutoExperience then
            xpConnection = AutoExperience:GetPropertyChangedSignal("Value"):Connect(function() killConfirmed = true end)
        end
        local moneyConnection
        pcall(function()
            local moneyFolder = AutoGui:WaitForChild("HUD"):WaitForChild("Main"):WaitForChild("DropMoney"):WaitForChild("Money")
            moneyConnection = moneyFolder.ChildAdded:Connect(function() killConfirmed = true end)
        end)

        local function toggleStandUntilReady()
            local ends = tick() + 3
            while AP.Enabled and tick() < ends do
                if autoStandMorph() then return true end
                toggleAutoStand()
                task.wait(0.25)
            end
            return autoStandMorph() ~= nil
        end
        if not toggleStandUntilReady() then
            setStatus("Stand not ready. Resetting character.")
            pcall(function() autoHumanoid().Health = 0 end)
            waitAutoRespawn(22)
            if xpConnection then xpConnection:Disconnect() end
            if moneyConnection then moneyConnection:Disconnect() end
            return false
        end

        task.spawn(learnAllAutoSkills)
        local verticalOffset = -(offsetY or 20)
        local function stabilize(anchored)
            local root = autoRoot()
            if not root then return end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if anchored ~= nil then root.Anchored = anchored end
        end

        local combatCamera = workspace.CurrentCamera
        local originalCameraType = combatCamera and combatCamera.CameraType
        local originalCameraSubject = combatCamera and combatCamera.CameraSubject
        local originalCameraCFrame = combatCamera and combatCamera.CFrame
        local originalCameraFocus = combatCamera and combatCamera.Focus
        local previousPlayerSpectate = Cam and Cam.Active
        local previousSpectateTarget = Cam and Cam.Target
        if previousPlayerSpectate then pcall(function() Cam.stop() end) end

        local beforeCameraName = "Phantom_StorylineNPC_BeforeCamera"
        local afterCameraName = "Phantom_StorylineNPC_AfterCamera"
        pcall(function() RunService:UnbindFromRenderStep(beforeCameraName) end)
        pcall(function() RunService:UnbindFromRenderStep(afterCameraName) end)

        local function getCombatCameraSubject()
            local target = npc
            if not target or not target.Parent then return nil end
            local targetHumanoid = target:FindFirstChildOfClass("Humanoid")
            local targetRoot = target:FindFirstChild("HumanoidRootPart")
            
            return targetHumanoid or targetRoot
        end

        local function maintainCombatCamera()
            if not AP.Enabled then return end
            local currentCamera = workspace.CurrentCamera
            if currentCamera then combatCamera = currentCamera end
            if not combatCamera then return end

            local subject = getCombatCameraSubject()
            if not subject or not subject.Parent then return end
            if combatCamera.CameraType ~= Enum.CameraType.Custom then
                combatCamera.CameraType = Enum.CameraType.Custom
            end
            if combatCamera.CameraSubject ~= subject then
                combatCamera.CameraSubject = subject
            end
        end

        RunService:BindToRenderStep(
            beforeCameraName,
            Enum.RenderPriority.Camera.Value - 1,
            maintainCombatCamera
        )
        RunService:BindToRenderStep(
            afterCameraName,
            Enum.RenderPriority.Camera.Value + 1,
            maintainCombatCamera
        )
        maintainCombatCamera()

        local engage = npcRoot.CFrame - npcRoot.CFrame.LookVector * (offsetZ or 2) + Vector3.new(0, verticalOffset, 0)
        stabilize(false)
        local root = autoRoot()
        if root then root.CFrame = CFrame.lookAt(engage.Position, npcRoot.Position) end
        task.wait(0.15)

        local finished = false
        while AP.Enabled do
            task.wait()
            stabilize(false)
            local currentRoot = npc and npc:FindFirstChild("HumanoidRootPart")
            if currentRoot then npcRoot = currentRoot end
            local hp = npc and npc:FindFirstChild("Health")
            local alive = npc and npc.Parent and hp and tonumber(hp.Value) and hp.Value > 0
            if npcName == "Security Guard" and not alive and not killConfirmed then
                local nextNpc = findAliveAutoNPC(npcName)
                if nextNpc and nextNpc ~= npc then
                    npc = nextNpc
                    npcRoot = nextNpc.HumanoidRootPart
                    maxHP = (nextNpc:FindFirstChild("Health") and nextNpc.Health.Value) or maxHP
                    task.wait()
                    continue
                end
            end
            if not alive or killConfirmed then
                finished = true
                local remote = autoRemoteEvent()
                if remote then pcall(function() remote:FireServer("InputEnded", {Input = Enum.KeyCode.E}) end) end
                stabilize(true)
                task.wait(0.12)
                stabilize(false)
                break
            end

            if not autoStandMorph() then
                toggleStandUntilReady()
                task.wait(0.1)
                continue
            end
            pcall(function()
                local char = AutoPlayer.Character
                local remote = autoRemoteEvent()
                if not char or not remote then return end
                local currentHP = npc:FindFirstChild("Health") and npc.Health.Value or 0
                local hpFraction = currentHP / math.max(maxHP, 1)
                local ragdolled = npc:FindFirstChild("RagdollParts") ~= nil
                local barraging = char:FindFirstChild("Stand Barraging") ~= nil
                local stand = autoStandMorph()
                local standRoot = stand and stand:FindFirstChild("HumanoidRootPart")
                local head = npc:FindFirstChild("Head")
                if standRoot and head then
                    standRoot.CFrame = CFrame.lookAt(head.Position + Vector3.new(0, 3.8, 0), npcRoot.Position)
                end
                local standName = tostring(AutoStand.Value)
                local requiem = standName == "King Crimson Requiem" or standName == "King Crimson: Requiem"
                    or standName == "Star Platinum: The World" or standName == "Star Platinum The World"
                if not requiem then
                    if autoSkillCooling("Stand Barrage") or ragdolled or hpFraction <= 0.45 then
                        remote:FireServer("InputEnded", {Input = Enum.KeyCode.E})
                    else
                        remote:FireServer("InputBegan", {Input = Enum.KeyCode.E})
                    end
                end
                if not ragdolled and not barraging then
                    for _, keyName in ipairs(autoStandKeyPlan(standName)) do
                        local skill = autoSkillOnKey(char, keyName)
                        if skill and skill ~= "" and skill ~= "Ora Kicks" and autoHasStandSkill(skill) and not autoSkillCooling(skill) then
                            local allowed = true
                            if standName == "Silver Chariot" and string.find(string.lower(skill), "barrage", 1, true) then
                                allowed = false
                            elseif standName ~= "D4C" and standName ~= "King Crimson" and not requiem then
                                local rule = autoKillSkillRule(skill)
                                allowed = rule ~= nil and (rule.hpGate == nil or hpFraction > rule.hpGate)
                            end
                            local keyCode = Enum.KeyCode[keyName]
                            if allowed and keyCode then
                                remote:FireServer("InputBegan", {Input = keyCode})
                                remote:FireServer("InputEnded", {Input = keyCode})
                            end
                        end
                    end
                end
                remote:FireServer("Attack", "m1")
                local follow = npcRoot.CFrame - npcRoot.CFrame.LookVector * (offsetZ or 2) + Vector3.new(0, verticalOffset, 0)
                local rootNow = autoRoot()
                if rootNow then rootNow.CFrame = CFrame.lookAt(follow.Position, npcRoot.Position) end
                stabilize(false)
            end)
        end
        pcall(function() RunService:UnbindFromRenderStep(beforeCameraName) end)
        pcall(function() RunService:UnbindFromRenderStep(afterCameraName) end)
        local restoreCamera = workspace.CurrentCamera or combatCamera
        if restoreCamera then
            pcall(function()
                restoreCamera.CameraType = originalCameraType or Enum.CameraType.Custom
                if originalCameraSubject and originalCameraSubject.Parent then
                    restoreCamera.CameraSubject = originalCameraSubject
                end
                if originalCameraCFrame then restoreCamera.CFrame = originalCameraCFrame end
                if originalCameraFocus then restoreCamera.Focus = originalCameraFocus end
            end)
        end
        if previousPlayerSpectate and previousSpectateTarget then
            task.defer(function()
                if previousSpectateTarget.Parent then pcall(function() Cam.start(previousSpectateTarget) end) end
            end)
        end
        if xpConnection then xpConnection:Disconnect() end
        if moneyConnection then moneyConnection:Disconnect() end
        return finished
    end

    local function canPrestigeNow()
        return (AutoLevel.Value >= 35 and AutoPrestige.Value == 0)
            or (AutoLevel.Value >= 40 and AutoPrestige.Value == 1)
            or (AutoLevel.Value >= 45 and AutoPrestige.Value == 2)
    end

    local function autoFirePrestige()
        local previous = tonumber(AutoPrestige.Value) or 0
        local dialogueFolder = ReplicatedStorage:FindFirstChild("Dialogue")
        local prestigeDialogue = dialogueFolder and dialogueFolder:FindFirstChild("Prestige Master")
        if not prestigeDialogue then
            setStatus("Could not find Prestige Master.")
            return false
        end

        setStatus("Talking to Prestige Master.")
        local confirmed = false
        for attempt = 1, 3 do
            if not AP.Enabled then return false end
            if State.Selling then
                task.wait(0.2)
                continue
            end
            if (tonumber(AutoPrestige.Value) or 0) > previous then
                confirmed = true
                break
            end

            local remote = autoRemoteEvent()
            if not remote then
                setStatus("Waiting to prestige.")
                task.wait(0.35)
                continue
            end

            local fired = pcall(function()
                remote:FireServer("PromptTriggered", prestigeDialogue)
            end)
            if not fired then
                setStatus("Could not talk to Prestige Master (attempt " .. attempt .. "/3)")
                task.wait(0.35)
                continue
            end

            setStatus("Talking to Prestige Master (attempt " .. attempt .. "/3")
            local gui = Gui.waitDialogue(3)
            if gui and AP.Enabled and (tonumber(AutoPrestige.Value) or 0) <= previous then
                advanceAutoDialogue("Option1", 5.0)
            end

            local confirmDeadline = tick() + 2.5
            repeat
                if (tonumber(AutoPrestige.Value) or 0) > previous then
                    confirmed = true
                    break
                end
                task.wait(0.1)
            until tick() >= confirmDeadline or not AP.Enabled

            if confirmed then break end
            if attempt < 3 and AP.Enabled then
                setStatus("Prestige did not work. Trying again.")
                task.wait(0.4)
            end
        end

        if not confirmed and (tonumber(AutoPrestige.Value) or 0) > previous then
            confirmed = true
        end
        if not confirmed then
            setStatus("Prestige failed. Try again.")
            return false
        end

        notify("Auto Prestige", "Prestiged to " .. tostring(AutoPrestige.Value) .. ".", 5)
        pcall(function() autoHumanoid().Health = 0 end)
        if not waitAutoRespawn(22) then
            setStatus("Could not respawn after prestige.")
            return false
        end
        task.wait(1)
        AP.StorylineCursor = 1
        AP.StorylineLastDialogueIndex = nil
        AP.StorylineLastQuest = nil
        AP.StorylineRecoveryUsed = false
        AP.StorylineForceRecoverySweep = true
        AP.StorylineCheckpointKnown = false
        AP.VampFarmActive = false
        AP.StorylineSweepCancelled = false
        AP.VampFarmFullSweepCompleted = false
        AP.VampFarmSweepHasInteracted = false
        AP.VampFarmStep11Reached = false
        AP.VampFarmStep11Completed = false
        AP.VampFarmPost11SweepActive = false
        AP.VampFarmSweepStarted = AP.VampFarmModeRequested == true
        if AP.VampFarmModeRequested then AP.Mode = "Vamp Farm" end
        if syncStorylineDropdown then syncStorylineDropdown() end
        if updateStorylineProgress then updateStorylineProgress() end
        local untilTime = tick() + 8
        repeat
            fireStorylineSweep()
            task.wait(0.3)
        until next(autoQuests()) ~= nil or tick() >= untilTime or not AP.Enabled
        return AP.Enabled
    end

    local function useRequiemArrowIfPresent()
        if AutoPrestige.Value < 1 then return end
        local standName = tostring(AutoStand.Value)
        if standName ~= "King Crimson" and standName ~= "Star Platinum" then return end
        local arrow = AutoBackpack:FindFirstChild("Requiem Arrow")
        if not arrow then return end
        local skillTree = AutoPlayer:FindFirstChild("CharacterSkillTree")
        local worthiness = skillTree and skillTree:FindFirstChild("Worthiness V")
        if not (worthiness and worthiness.Value) then
            for _, skill in ipairs({"Worthiness", "Worthiness II", "Worthiness III", "Worthiness IV", "Worthiness V"}) do
                if not AP.Enabled then return end
                autoLearnSkill(skill, "Character")
                task.wait(0.1)
            end
            task.wait(0.4)
        end
        notify("Auto Prestige", "Found a Requiem Arrow. Trying to use it.", 5)
        local hum = autoHumanoid()
        if hum then pcall(function() hum:EquipTool(arrow) end) end
        local equipped = autoCharacter():FindFirstChild("Requiem Arrow")
        if equipped then
            pcall(function() equipped:Activate() end)
            local gui = Gui.waitDialogue(3)
            if gui then
                advanceAutoDialogue("Option1", 3.0)
            end
        end
        setStatus("Used Requiem Arrow on " .. standName)
        task.wait(2)
    end

    local function progressStory()
        if not AP.Enabled then return false end
        useRequiemArrowIfPresent()
        local quests = autoQuests()
        for _, entry in ipairs(STORY_NPCS) do
            if not AP.Enabled then return false end
            if quests[entry.quest] then
                setStatus("Killing " .. entry.npc)
                local currentStoryDialogueIndex = tonumber(AP.StorylineLastDialogueIndex)
                local deathDetected = false
                local retrySameStepAfterDeath = false
                local monitoredCharacter = AutoPlayer.Character
                local deathConnection
                local function monitorCharacterDeath(character)
                    if deathConnection then
                        deathConnection:Disconnect()
                        deathConnection = nil
                    end
                    monitoredCharacter = character
                    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid then
                        deathConnection = humanoid.Died:Connect(function()
                            deathDetected = true
                        end)
                    end
                end
                monitorCharacterDeath(monitoredCharacter)

                while AP.Enabled do
                    local liveCharacter = AutoPlayer.Character
                    local liveHumanoid = liveCharacter and liveCharacter:FindFirstChildWhichIsA("Humanoid")
                    if liveCharacter ~= monitoredCharacter or not liveHumanoid or liveHumanoid.Health <= 0 then
                        deathDetected = true
                    end

                    if deathDetected then
                        setStatus("Died during " .. entry.quest .. ". Waiting to continue the same step.")
                        local characterNow = AutoPlayer.Character
                        local humanoidNow = characterNow and characterNow:FindFirstChildWhichIsA("Humanoid")
                        if not characterNow or not humanoidNow or humanoidNow.Health <= 0 then
                            if not waitAutoRespawn(22) then
                                task.wait(0.25)
                                continue
                            end
                        end
                        task.wait(0.65)

                        local respawnedCharacter = AutoPlayer.Character
                        local respawnedHumanoid = respawnedCharacter and respawnedCharacter:FindFirstChildWhichIsA("Humanoid")
                        if not respawnedCharacter or not respawnedHumanoid or respawnedHumanoid.Health <= 0 then
                            task.wait(0.25)
                            continue
                        end

                        local recoveredQuests = autoQuests()
                        if recoveredQuests[entry.quest] then
                            deathDetected = false
                            monitorCharacterDeath(respawnedCharacter)
                            setStatus("Back in the game. Continuing the quest: " .. entry.quest)
                            continue
                        end

                        local recoveryIndex = currentStoryDialogueIndex or tonumber(AP.StorylineLastDialogueIndex)
                        if not recoveryIndex then
                            local savedCursor = tonumber(AP.StorylineCursor) or 1
                            recoveryIndex = savedCursor > 1 and (savedCursor - 1) or savedCursor
                        end
                        if recoveryIndex and recoveryIndex >= 1 and recoveryIndex <= #STORY_KEYS then
                            AP.StorylineCursor = math.clamp(math.floor(recoveryIndex), 1, #STORY_KEYS)
                            AP.StorylineCursorVersion = 2
                            AP.StorylineCheckpointKnown = true
                            AP.StorylineForceRecoverySweep = false
                            AP.StorylineRecoveryUsed = false
                            AP.StorylineLastQuest = nil
                            if syncStorylineDropdown then syncStorylineDropdown() end
                            if updateStorylineProgress then updateStorylineProgress() end
                            setStatus("You respawned before finishing " .. entry.quest .. "; retrying Storyline " .. STORY_KEYS[recoveryIndex])
                        else
                            setStatus("You respawned before finishing " .. entry.quest .. ". Keeping your place.")
                        end
                        retrySameStepAfterDeath = true
                        break
                    end

                    local nowQuests = autoQuests()
                    if not nowQuests[entry.quest] then
                        break
                    end

                    if prestigeKillNPC(entry.npc, entry.offZ, entry.offY) then
                        lastNpcKillAt = tick()
                        warnedNoKill = false
                    end
                    local refreshedQuests = autoQuests()
                    if quests[entry.quest] and not refreshedQuests[entry.quest] and not StoryQuestSent[entry.quest] then
                        StoryQuestSent[entry.quest] = true
                    elseif refreshedQuests[entry.quest] then
                        StoryQuestSent[entry.quest] = false
                    end
                    quests = refreshedQuests
                    task.wait(entry.npc == "Security Guard" and 0.8 or 0.08)
                end
                if deathConnection then
                    deathConnection:Disconnect()
                    deathConnection = nil
                end
                if retrySameStepAfterDeath then
                    return true
                end
                if entry.npc == "Diavolo" and AP.Enabled then
                    fireStorylineSweep()
                    task.wait(0.3)
                    fireDialogue("Storyline #14", "Dialogue7", "Option1")
                    local hum = autoHumanoid()
                    if hum then hum.Health = 0 task.wait(2) end
                end
                return true
            end
        end

        if AP.Enabled and not AP.StorylineSweepCancelled and not currentAutoProgressQuest() then
            setStatus("Continuing the storyline.")
            fireStorylineSweep()
            task.wait(0.25)
            quests = autoQuests()
        end

        local vampFarmMode = AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true
        local cursorAtEnd = (tonumber(AP.StorylineCursor) or 1) > #STORY_KEYS
        local vampSweepFinished = vampFarmMode
            and AP.VampFarmFullSweepCompleted == true
            and cursorAtEnd
            and not delayVampFarmUntilStorylineEnd()

        if vampFarmMode then

            if not vampSweepFinished then
                setStatus("Finishing the storyline before Vamp Farm.")
                return false
            end

            local current = autoQuests()
            for _, entry in ipairs(STORY_NPCS) do
                if current[entry.quest] then
                    setStatus("Finish this quest before Vamp Farm: " .. entry.quest)
                    return false
                end
            end

            if not current[VAMPIRE_QUEST] then

                for attempt = 1, 12 do
                    if not AP.Enabled then return false end
                    current = autoQuests()
                    if current[VAMPIRE_QUEST] then break end

                    local storyQuestActive = false
                    for _, entry in ipairs(STORY_NPCS) do
                        if current[entry.quest] then storyQuestActive = true break end
                    end
                    if storyQuestActive then
                        setStatus("Finishing the quest before Vamp Farm.")
                        return false
                    end

                    setStatus("Storyline done. Trying to start the Vampire quest (attempt " .. attempt .. "/12)")
                    local opened = openAutoDialogue("William Zeppeli", "Dialogue4", true)
                    if opened then
                        advanceAutoDialogue("Option1", 5.0)
                    end
                    task.wait(0.4)
                    current = autoQuests()
                    if current[VAMPIRE_QUEST] then break end
                end
            end

            if current[VAMPIRE_QUEST] then
                if markVampFarm then
                    markVampFarm("Vampire quest active after full 18-step sweep")
                end
                setStatus("Killing Vampires")
                while AP.Enabled and autoQuests()[VAMPIRE_QUEST] do
                    if prestigeKillNPC("Vampire", 0, 14) then
                        lastNpcKillAt = tick()
                        warnedNoKill = false
                    else
                        task.wait(0.4)
                    end
                    local latest = autoQuests()
                    VampireQuestSent = not latest[VAMPIRE_QUEST]
                end
                return true
            end

            setStatus("Storyline done. Waiting for the Vampire quest.")
            return false
        end

        local waitingForStorylineEnd = delayVampFarmUntilStorylineEnd()
        if AutoLevel.Value >= 25 and not quests[VAMPIRE_QUEST] and not waitingForStorylineEnd then
            local fresh = autoQuests()
            local storyActive = false
            for _, entry in ipairs(STORY_NPCS) do
                if fresh[entry.quest] then storyActive = true break end
            end
            if not storyActive and not fresh[VAMPIRE_QUEST] then
                setStatus("Checking for the Vampire quest.")
                fireDialogue("William Zeppeli", "Dialogue4", "Option1")
                task.wait(0.25)
            end
        end

        return false
    end

    local function runAutoPrestige()
        if AP.Busy then return end
        AP.Busy = true
        runtimeMisses = 0
        errorCount = 0
        if isBlacklistedStand(AutoStand.Value) then
            notify("Auto Prestige", "Do not use a blacklisted stand: " .. tostring(AutoStand.Value) .. ".", 8)
            AP.Enabled = false
            AP.Busy = false
            setStatus("Blacklisted stand")
            return
        end
        if not waitAutoRuntime(8) then
            notify("Auto Prestige", "Character is not ready. Try again in a moment.", 7)
            AP.Enabled = false
            AP.Busy = false
            setStatus("Character not ready.")
            return
        end
        task.spawn(learnAllAutoSkills)
        lastNpcKillAt = tick()
        warnedNoKill = false

        while AP.Enabled do

            local vampFarmRequested = AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true
            if AutoLevel.Value >= 50 and not vampFarmRequested then
                notify("Auto Prestige", "Max level reached.", 7)
                setStatus("Max level (50)")
                AP.Enabled = false
                break
            end
            if tick() - lastNpcKillAt >= 240 and not warnedNoKill then
                warnedNoKill = true
                notify("Auto Prestige", "No NPCs defeated for a while. Check your farm.", 8)
                setStatus("No NPCs defeated for a while.")
            end
            if not autoRuntimeReady() then
                runtimeMisses += 1
                setStatus("Trying to recover (" .. tostring(runtimeMisses) .. "/3)")
                if not waitAutoRuntime(6) and runtimeMisses >= 3 then
                    notify("Auto Prestige", "Stopped because the character was not ready.", 7)
                    AP.Enabled = false
                    break
                end
                task.wait(0.35)
                continue
            end
            runtimeMisses = 0
            if isBlacklistedStand(AutoStand.Value) then
                notify("Auto Prestige", "Stopped. This stand is blocked: " .. tostring(AutoStand.Value) .. ".", 7)
                AP.Enabled = false
                break
            end
            local ok, err = pcall(function()
                if canPrestigeNow() and not autoFirePrestige() then error("prestige flow failed") end
                if not AP.Enabled then return end
                local progressed = progressStory()
                if not progressed and AP.Enabled then
                    if AP.StorylineSweepCancelled or AP.VampFarmActive then
                        setStatus("Vamp Farm is running. Waiting for the next quest.")
                        task.wait(1)
                    elseif AP.Mode == "Vamp Farm" and AP.VampFarmModeRequested == true then
                        local atVampireHandoff = AP.VampFarmFullSweepCompleted == true
                            and (tonumber(AP.StorylineCursor) or 1) > #STORY_KEYS
                        if atVampireHandoff then

                            setStatus("Storyline done. Trying to start Vamp Farm again.")
                        else

                            setStatus("Continuing Vamp Farm.")
                        end
                        task.wait(1)
                    else
                        setStatus("Starting the storyline.")
                        local attempts = 0
                        while AP.Enabled and attempts < 15 and next(autoQuests()) == nil do
                            local before = AP.StorylineCursor
                            fireStorylineSweep()
                            attempts += 1
                            if next(autoQuests()) ~= nil then break end
                            if AP.StorylineCursor >= #STORY_KEYS + 1 then break end
                            if AP.StorylineCursor == before then break end
                        end
                        if next(autoQuests()) == nil and AP.Enabled then
                            AP.StorylineForceRecoverySweep = false
                            AP.StorylineCheckpointKnown = true
                            setStatus("No new quest yet. Staying on step " .. tostring(AP.StorylineCursor))
                            task.wait(1)
                        end
                    end
                end
            end)
            if not ok then
                errorCount += 1
                setStatus("Trying to recover (" .. tostring(errorCount) .. "/3)")
                warn("[Auto Prestige] " .. tostring(err))
                if errorCount >= 3 then
                    notify("Auto Prestige", "Stopped after repeated errors.", 7)
                    AP.Enabled = false
                    break
                end
                waitAutoRuntime(6)
                task.wait(0.75)
            else
                errorCount = 0
                task.wait(0.3)
            end
        end
        AP.Busy = false
        if AP.Status ~= "Max level (50)" then setStatus("Stopped") end
    end

    local AutoPrestigeMain = parentTab:Section({Title = "Auto Storyline Controls", Side = "left"})
    AutoPrestigeMain:Paragraph({Title = "Auto Storyline", Desc = "Automatically finish the storyline, then start Vamp Farm."})
    STATUS_LABEL = AutoPrestigeMain:Paragraph({Title = "Status", Desc = AP.Status})
    PROGRESS_BAR = AutoPrestigeMain:Progress({
        Title = "Storyline Progress",
        Desc = "Shows your storyline progress.",
        Default = 0,
        Format = function(value)
            return tostring(math.floor(value * 100 + 0.5)) .. "%"
        end,
    })
    PROGRESS_DETAIL_LABEL = AutoPrestigeMain:Paragraph({Title = "Next Step", Desc = "Next: Step 1 of 18"})

    local storylineStartValues = {"Continue where I left off"}
    local storylineStartIndex = {}
    for i, label in ipairs(STORYLINE_LABELS) do
        table.insert(storylineStartValues, label)
        storylineStartIndex[label] = i
    end
    table.insert(storylineStartValues, "Vamp Farm")
    STORYLINE_DROPDOWN = AutoPrestigeMain:Dropdown({
        Title = "Storyline / Farm Mode",
        Desc = "Choose where to start, or pick Vamp Farm to finish the storyline first.",
        Values = storylineStartValues,
        Value = "Continue where I left off",
        Multi = false,
        Callback = function(selected)
            if AP.SyncingDropdown then return end
            if type(selected) == "table" then selected = selected[1] end
            if selected == "Vamp Farm" then
                AP.Mode = "Vamp Farm"
                AP.VampFarmModeRequested = true
                AP.VampFarmActive = false
                AP.StorylineSweepCancelled = false
                AP.VampFarmFullSweepCompleted = false
                AP.VampFarmSweepHasInteracted = false
                AP.VampFarmStep11Reached = false
                AP.VampFarmStep11Completed = false
                AP.VampFarmPost11SweepActive = false
                AP.VampFarmSweepStarted = false
                AP.StorylineCursor = 1
                AP.StorylineStep11OptionIndex = 1
                AP.StorylineStep11FailureCount = 0
                AP.StorylineCursorVersion = 2
                AP.StorylineCheckpointKnown = false
                AP.StorylineForceRecoverySweep = true
                AP.StorylineRecoveryUsed = false
                AP.StorylineLastDialogueIndex = nil
                AP.StorylineLastQuest = nil
                setStatus("Vamp Farm selected. Starting from the beginning.")
                return
            end
            if not selected or selected == "Continue where I left off" then
                AP.Mode = "Storyline"
                AP.VampFarmModeRequested = false
                AP.VampFarmActive = false
                AP.VampFarmFullSweepCompleted = false
                AP.StorylineSweepCancelled = false
                AP.VampFarmSweepStarted = false
                AP.StorylineManualStartIndex = nil
                setStatus("Continuing from step " .. tostring(AP.StorylineCursor or 1))
                return
            end
            local index = storylineStartIndex[selected]
            if index then
                AP.Mode = "Storyline"
                if index ~= 11 then
                    AP.StorylineStep11OptionIndex = 1
                    AP.StorylineStep11FailureCount = 0
                end
                AP.VampFarmModeRequested = false
                AP.VampFarmActive = false
                AP.VampFarmFullSweepCompleted = false
                AP.StorylineSweepCancelled = false
                AP.VampFarmSweepStarted = false
                AP.StorylineManualStartIndex = index
                AP.StorylineCursor = index
                AP.StorylineCursorVersion = 2
                AP.StorylineCheckpointKnown = true
                AP.StorylineForceRecoverySweep = false
                AP.StorylineRecoveryUsed = false
                setStatus("Starting from " .. selected)
            end
        end,
    })
    if updateStorylineProgress then updateStorylineProgress() end

    if not bypassSupported then
        AutoPrestigeMain:Paragraph({Title = "Unavailable", Desc = "Auto Storyline is not available on this executor."})
    else
        AutoPrestigeMain:Toggle({
            Title = "Auto Storyline",
            Desc = "Finish the storyline, then start Vamp Farm.",
            Value = false,
            Callback = function(state)
                if AP.Busy and state then return end
                if state then
                    local sharedEnv = _G
                    if type(getgenv) == "function" then
                        pcall(function() sharedEnv = getgenv() or _G end)
                    end
                    if _G.QuestFarmEnabled or _G.NPCFarmEnabled or sharedEnv.QuestFarmEnabled or sharedEnv.NPCFarmEnabled then
                        notify("Auto Storyline", "Turn off Quest Farm or NPC Farm first.", 5)
                        return
                    end
                    if isBlacklistedStand(AutoStand.Value) then
                        notify("Auto Storyline", "Do not use a blacklisted stand: " .. tostring(AutoStand.Value) .. ".", 8)
                        setStatus("Blacklisted stand")
                        return
                    end
                end
                AP.Enabled = state
                if state then
                    if AP.Mode == "Vamp Farm" and not AP.VampFarmActive and not AP.VampFarmSweepStarted then
                        AP.VampFarmFullSweepCompleted = false
                        AP.VampFarmSweepHasInteracted = false
                        AP.VampFarmStep11Reached = false
                        AP.VampFarmStep11Completed = false
                        AP.VampFarmPost11SweepActive = false
                        AP.StorylineCursor = 1
                        AP.StorylineStep11OptionIndex = 1
                        AP.StorylineStep11FailureCount = 0
                        AP.StorylineRecoveryUsed = false
                        AP.StorylineLastDialogueIndex = nil
                        AP.StorylineLastQuest = nil
                        AP.StorylineForceRecoverySweep = true
                        AP.StorylineCheckpointKnown = false
                        AP.StorylineSweepCancelled = false
                        AP.VampFarmSweepStarted = true
                        setStatus("Checking the storyline from the beginning.")
                    else
                        
                        local savedCursor = tonumber(AP.StorylineCursor)
                        local checkpointValid = AP.StorylineCursorVersion == 2
                            and AP.StorylineCheckpointKnown == true
                            and savedCursor ~= nil
                            and savedCursor >= 1
                            and savedCursor <= #STORY_KEYS + 1
                        if checkpointValid then
                            AP.StorylineCursor = math.clamp(math.floor(savedCursor), 1, #STORY_KEYS + 1)
                            if not AP.StorylineSweepCancelled then AP.StorylineForceRecoverySweep = false end
                            setStatus("Continuing from step " .. tostring(AP.StorylineCursor))
                        else
                            AP.StorylineCursor = 1
                            AP.StorylineRecoveryUsed = false
                            AP.StorylineLastDialogueIndex = nil
                            AP.StorylineLastQuest = nil
                            AP.StorylineForceRecoverySweep = true
                            AP.StorylineCheckpointKnown = false
                            setStatus("Starting the storyline from the beginning.")
                        end
                    end
                    AP.StorylineCursorVersion = 2
                    if syncStorylineDropdown then syncStorylineDropdown() end
                    if updateStorylineProgress then updateStorylineProgress() end
                    notify("Auto Storyline", "Started.", 5)
                    task.spawn(runAutoPrestige)
                else
                    setStatus("Stopped")
                    notify("Auto Storyline", "Stopped.", 5)
                end
            end,
        })
    end

    local AutoPrestigeQuick = parentTab:Section({Title = "Storyline Quick Actions", Side = "right"})
    AutoPrestigeQuick:Paragraph({Title = "Storyline", Desc = "Use these buttons when Auto Storyline is off."})
    AutoPrestigeQuick:Button({
        Title = "Continue Storyline",
        Desc = "Keep going through dialogue until you get a fighting quest.",
        Callback = function()
            if AP.Enabled or AP.Busy then
                notify("Storyline", "Turn off Auto Storyline first.", 5)
                return
            end
            if AP.StorylineCursor == nil then
                AP.StorylineCursor = 1
            elseif AP.StorylineCursor > #STORY_KEYS then
                local restartIndex = tonumber(AP.StorylineManualStartIndex)
                if not restartIndex then
                    setStatus("All dialogue steps are done. Choose where to continue.")
                    notify("Storyline", "Choose where to start first.", 6)
                    return
                end
                AP.StorylineCursor = math.clamp(math.floor(restartIndex), 1, #STORY_KEYS)
                AP.StorylineCursorVersion = 2
                AP.StorylineCheckpointKnown = true
                AP.StorylineForceRecoverySweep = false
                AP.StorylineRecoveryUsed = false
            end
            AP.Enabled = true
            task.spawn(function()
                local sweepResult
                local ok, err = pcall(function()
                    sweepResult = fireStorylineSweep()
                end)
                AP.Enabled = false
                if not ok then
                    setStatus("Dialogue failed: " .. tostring(err))
                    warn("[Storyline] " .. tostring(err))
                    notify("Storyline", "Dialogue did not finish. Try again.", 5)
                    return
                end
                local activeQuest = currentAutoProgressQuest()
                if activeQuest then
                    setStatus("Stopped at combat quest: " .. activeQuest)
                    notify("Storyline", "Fighting quest found: " .. activeQuest .. ". Finish it, then press Continue Storyline again.", 6)
                elseif AP.StorylineCursor > #STORY_KEYS then
                    setStatus("Dialogue finished. Choose another starting point to continue.")
                    notify("Storyline", "Done. Choose where to continue next time.", 6)
                elseif sweepResult == false then
                    setStatus("Paused at step " .. tostring(AP.StorylineCursor) .. ". You can retry this step.")
                    notify("Storyline", "This dialogue did not finish. Your starting point was saved.", 6)
                else
                    setStatus("Finished at step " .. tostring(AP.StorylineCursor))
                    notify("Storyline", "Done. Press Continue Storyline when you are ready.", 5)
                end
            end)
        end,
    })
    AP.Stop = function()
        AP.Enabled = false
        setStatus("Stopped")
    end
end

local FarmTab = Window:Tab({Title = "Auto-Farm", Icon = "zap"})
local AutoPrestigeTab = Window:Tab({Title = "Auto Prestige", Icon = "book-open"})
_G.__PhantomQuestFarmTab = Window:Tab({
    Title = "Quest Farm",
    Icon = "swords",
    Desc = "Auto-farm quests and NPCs.",
})
local HalloweenTab = Window:Tab({
    Title = "Halloween Event",
    Icon = "ghost",
    Desc = "Collect candy and turn it in to Jack.",
})

local Halloween = {
    AutoTurnIn = CHOPA_HAS_CONFIG,
    TurnInThreshold = 20,
    TurnInBusy = false,
    LastTurnInAt = 0,
    StatusLabel = nil,
    PointsLabel = nil,
    CachedJackPoints = nil,
}

local HALLOWEEN_CANDY_NAMES = {
    "Green Candy",
    "Red Candy",
    "Blue Candy",
    "Yellow Candy",
}

function Halloween.countCandies()
    local total = 0
    for _, candyName in ipairs(HALLOWEEN_CANDY_NAMES) do
        total += countInventoryName(candyName)
    end
    return total
end

function Halloween.captureJackPoints(gui)
    if not gui or not gui.Parent then return false end
    local ok, rawText = pcall(function()
        return Gui.dialogueText(gui)
    end)
    if not ok or type(rawText) ~= "string" or rawText == "" then return false end

    local text = string.lower(rawText):gsub(",", "")
    local digits = text:match("you%s+now%s+have%s+(%d+)%s+points?")
    if not digits then return false end

    local points = tonumber(digits)
    if not points then return false end
    Halloween.CachedJackPoints = points
    return true
end

function Halloween.readJackPoints()
    local aliases = {
        jackpoints = 120,
        halloweenpoints = 115,
        candypoints = 110,
        pumpkinpoints = 105,
        eventpoints = 100,
        trickortreatpoints = 98,
        jackpoint = 95,
        halloweenpoint = 94,
        candypoint = 93,
        pumpkinpoint = 92,
        eventpoint = 91,
        halloweencurrency = 85,
        candycurrency = 84,
        eventcurrency = 83,
        jackcurrency = 82,
        trickortreatcurrency = 80,
        halloweentokens = 75,
        candytokens = 74,
        jacktokens = 73,
    }

    local function normalize(value)
        return string.lower(tostring(value or "")):gsub("[^%w]", "")
    end

    local bestValue = Halloween.CachedJackPoints
    local bestScore = bestValue ~= nil and 1000 or -1
    local scanRoots = {}
    for _, rootName in ipairs({"PlayerStats", "leaderstats", "Stats", "Data"}) do
        local root = LP:FindFirstChild(rootName)
        if root then table.insert(scanRoots, root) end
    end

    local seen = {}
    for _, root in ipairs(scanRoots) do
        if root and not seen[root] then
            seen[root] = true
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("ValueBase") then
                    local key = normalize(obj.Name)
                    local score = aliases[key]
                    if not score and key:find("point", 1, true) then
                        local ancestor = obj.Parent
                        local eventContext = false
                        while ancestor and ancestor ~= root do
                            local contextName = normalize(ancestor.Name)
                            if contextName:find("jack", 1, true)
                                or contextName:find("halloween", 1, true)
                                or contextName:find("candy", 1, true)
                                or contextName:find("pumpkin", 1, true)
                                or contextName:find("trickortreat", 1, true)
                                or contextName:find("event", 1, true) then
                                eventContext = true
                                break
                            end
                            ancestor = ancestor.Parent
                        end
                        if eventContext then score = 70 end
                    end
                    if score and score > bestScore then
                        bestScore = score
                        bestValue = obj.Value
                    end
                end
            end
        end
    end

    for name, value in pairs(LP:GetAttributes()) do
        local key = normalize(name)
        local score = aliases[key]
        if score and score > bestScore then
            bestScore = score
            bestValue = value
        end
    end

    if bestValue == nil then bestValue = Halloween.CachedJackPoints end
    if bestValue == nil then return nil end
    local numeric = tonumber(bestValue)
    if numeric then
        local rounded = math.floor(numeric)
        local formatted = tostring(rounded)
        while true do
            local replaced, count = formatted:gsub("^(%-?%d+)(%d%d%d)", "%1,%2")
            formatted = replaced
            if count == 0 then break end
        end
        return formatted
    end
    return tostring(bestValue)
end

local function halloweenNotify(title, message, notificationType)
    pcall(function()
        AirflowCompat:Notify({
            Title = title or "Halloween Event",
            Content = message or "",
            Type = notificationType or "Info",
            Duration = 4,
        })
    end)
end

local function turnInHalloweenCandies()
    if Halloween.TurnInBusy or State.HalloweenTurnInBusy then
        return false, "A candy turn-in is already running."
    end
    if State.Selling then
        return false, "Wait until selling finishes first."
    end
    if Gui.currentDialogue() then
        return false, "Close the current NPC dialogue before turning in candy."
    end

    local candyCount = Halloween.countCandies()
    if candyCount <= 0 then
        return false, "You do not have any candy to turn in."
    end

    local character = LP.Character
    local remote = character and character:FindFirstChild("RemoteEvent")
    local dialogueFolder = ReplicatedStorage:FindFirstChild("Dialogue")
    local dialogueTemplate = dialogueFolder and dialogueFolder:FindFirstChild("Halloween Event")
    if not remote or not remote:IsA("RemoteEvent") or not dialogueTemplate then
        return false, "Halloween Event dialogue or the character RemoteEvent is unavailable."
    end

    Halloween.TurnInBusy = true
    State.HalloweenTurnInBusy = true
    local success = false
    local openedDialogue = nil
    local failureReason = "Could not select the candy turn-in option."

    local ok, err = pcall(function()
        remote:FireServer("PromptTriggered", dialogueTemplate)
        local dialogue = Gui.waitDialogue(4)
        if not dialogue or not Gui.dialogueActive(dialogue) then
            failureReason = "Jack's dialogue did not open."
            return
        end
        openedDialogue = dialogue

        if not Gui.waitAndClickOption("Option2", 5) then
            failureReason = "The second dialogue option was not available."
            return
        end

        local captureDeadline = tick() + 2.5
        repeat
            local responseDialogue = Gui.currentDialogue() or openedDialogue
            if Halloween.captureJackPoints(responseDialogue) then break end
            task.wait(0.1)
        until tick() >= captureDeadline

        success = true
        Halloween.LastTurnInAt = tick()
    end)

    if openedDialogue then
        pcall(function()
            Gui.forceCloseDialogue(3)
        end)
    end

    Halloween.TurnInBusy = false
    State.HalloweenTurnInBusy = false

    if not ok then
        return false, "Turn-in failed: " .. tostring(err)
    end
    return success, success and ("Turn-in requested for " .. tostring(candyCount) .. " candies.") or failureReason
end

local HalloweenCollection = HalloweenTab:Section({Title = "Candy Collection", Side = "left"})
HalloweenCollection:Paragraph({
    Title = "Auto Collect Candies",
    Desc = "Picks up Halloween candy only.",
})
HalloweenCollection:Toggle({
    Title = "Auto Collect Candies",
    Desc = "Collect Halloween candy automatically.",
    Icon = "candy",
    Value = false,
    Callback = function(state)
        State.HalloweenCandyFarm = state == true
        if State.HalloweenCandyFarm then
            State.NoClip = true
            ItemESP.scan()
        elseif not State.Farm then
            State.NoClip = false
        end
        halloweenNotify("Halloween Event", State.HalloweenCandyFarm and "Candy-only collection enabled." or "Candy-only collection disabled.")
    end,
})

local HalloweenInfo = HalloweenTab:Section({Title = "Info", Side = "left"})
Halloween.PointsLabel = HalloweenInfo:Paragraph({
    Title = "Points from Jack",
    Desc = "Checking your event points...",
})
Halloween.StatusLabel = HalloweenInfo:Paragraph({
    Title = "Candy Inventory",
    Desc = "Checking your candy...",
})

local HalloweenTurnInSection = HalloweenTab:Section({Title = "Candy Turn-In", Side = "right"})
HalloweenTurnInSection:Input({
    Title = "Candy Turn-In Threshold",
    Desc = "Turn in candy when you have this many. Max: 45.",
    Placeholder = "20",
    Value = "20",
    Callback = function(value)
        local amount = tonumber(value)
        if amount then
            Halloween.TurnInThreshold = math.clamp(math.floor(amount), 1, 45)
        end
    end,
})
HalloweenTurnInSection:Toggle({
    Title = "Auto Turn In Candies",
    Desc = "Turn in your candy automatically when you reach the amount above.",
    Icon = "message-circle",
    Value = true,
    Callback = function(state)
        Halloween.AutoTurnIn = state == true
        halloweenNotify("Halloween Event", Halloween.AutoTurnIn and "Automatic candy turn-in enabled." or "Automatic candy turn-in disabled.")
    end,
})
HalloweenTurnInSection:Button({
    Title = "Turn In Candies Now",
    Desc = "Turn in your candy now.",
    Icon = "gift",
    Callback = function()
        task.spawn(function()
            local success, message = turnInHalloweenCandies()
            halloweenNotify("Halloween Event", message, success and "Success" or "Warning")
        end)
    end,
})
task.spawn(function()
    local lastStatusUpdate = 0
    while true do
        task.wait(1)

        local activeDialogue = Gui.currentDialogue()
        if activeDialogue then
            Halloween.captureJackPoints(activeDialogue)
        end

        local candyCount = Halloween.countCandies()
        if tick() - lastStatusUpdate >= 3 then
            lastStatusUpdate = tick()
            if Halloween.StatusLabel then
                pcall(function()
                    Halloween.StatusLabel:SetDesc(string.format(
                        "%d / 45 candies in inventory. Auto turn-in threshold: %d.",
                        candyCount,
                        math.clamp(tonumber(Halloween.TurnInThreshold) or 20, 1, 45)
                    ))
                end)
            end
            if Halloween.PointsLabel then
                pcall(function()
                    local points = Halloween.readJackPoints()
                    Halloween.PointsLabel:SetDesc(points and (points .. " points") or "Points value not found in player stats yet.")
                end)
            end
        end

        local threshold = math.clamp(math.floor(tonumber(Halloween.TurnInThreshold) or 20), 1, 45)
        if Halloween.AutoTurnIn and candyCount >= threshold
            and not Halloween.TurnInBusy and not State.Selling
            and tick() - (Halloween.LastTurnInAt or 0) >= 1.0 then
            local startingCount = candyCount
            local success, message = turnInHalloweenCandies()
            if success then
                halloweenNotify("Halloween Event", message, "Success")
                local waitUntil = tick() + 5
                repeat
                    task.wait(0.2)
                until not Halloween.AutoTurnIn
                    or Halloween.countCandies() < startingCount
                    or tick() >= waitUntil
                task.wait(1.0)
            elseif Halloween.AutoTurnIn then
                task.wait(2.0)
            end
        end
    end
end)

local FarmAutomation = FarmTab:Section({Title = "Automation", Side = "left"})
AFKFarmToggle = FarmAutomation:Toggle({
    Title = "AFK Farm",
    Desc = "Collect all available items, then hop to another public server and repeat.",
    Icon = "zap",
    Value = SH_AUTOSTART,
    KeepDefault = true,          -- continues the farm after a hop (not a default)
    Callback = function(state)
        if state then
            State.Farm = true
            State.NoClip = true
            ItemESP.scan()
            SHController:start()
        else
            SHController:stop()
            State.Farm = false
            if State.HalloweenCandyFarm then
                State.NoClip = true
                return
            end
            if FarmVisual.Decoy and not State.Selling then FarmVisual.restoreAtSafe() end
            State.NoClip = false
            local c = LP.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then
                    h:ChangeState(Enum.HumanoidStateType.GettingUp)
                    h:ChangeState(Enum.HumanoidStateType.Running)
                    task.wait(.05)
                    h:ChangeState(Enum.HumanoidStateType.Freefall)
                end
            end
        end
    end,
})
setupAutoPrestige(AutoPrestigeTab)

FarmAutomation:Toggle({
    Title = "Auto Sell",
    Desc = "Sell every item right after pickup, no interval. Never sells Lucky Arrow / Lucky Stone Mask / candies / presents.",
    Icon = "hand-coins",
    Value = true,
    Callback = function(state)
        Selling.everything = state == true
        autoSellMax = state == true
        if state then
            task.spawn(Selling.sweepEverything)
            Selling.requestAutoSellMaxCheck()
        end
    end,
})

do
    local sellableNames = {}
    for n in pairs(SELLABLE) do sellableNames[#sellableNames + 1] = n end
    table.sort(sellableNames)
    local current = {}
    for n in pairs(Selling.blacklist) do current[#current + 1] = n end
    table.sort(current)
    FarmAutomation:Dropdown({
        Title = "Never sell",
        Desc = "These items are never sold (Auto Sell, sell on max, sell buttons). Lucky Arrow / Lucky Stone Mask / candies / presents are never sold anyway.",
        Icon = "ban",
        Values = sellableNames,
        Value = current,
        Multi = true,
        Callback = function(selected)
            local list = chopaList(selected)
            local map = {}
            for _, n in ipairs(list) do map[n] = true end
            Selling.blacklist = map
            chopaWriteList(CHOPA_SELL_BLACKLIST_FILE, list)
        end,
    })
end

local FarmSettings = FarmTab:Section({Title = "Farm Filters", Side = "right"})
FarmSettings:Dropdown({
    Title = "Teleport mode",
    Desc = bypassSupported and "Choose how to move between items." or "Instant isn't available here. Tween is enabled.",
    Icon = "zap",
    Values = bypassSupported and {"Instant", "Tween"} or {"Tween"},
    Value = Config.FarmTeleportMode == "instant" and "Instant" or "Tween",
    Multi = false,
    Callback = function(selected)
        if selected == "Instant" and not bypassSupported then
            Config.FarmTeleportMode = "tween"
            MethionSH_Env.__MethionSHFarmTeleportMode = Config.FarmTeleportMode
            AirflowCompat:Notify({Title = "Instant unavailable", Content = "Instant mode isn't supported here. Tween stays on.", Type = "Warning", Duration = 4})
            return
        end
        Config.FarmTeleportMode = (selected == "Instant" and bypassSupported) and "instant" or "tween"
        MethionSH_Env.__MethionSHFarmTeleportMode = Config.FarmTeleportMode
    end,
})
FarmSettings:Dropdown({
    Title = "Only items to farm",
    Desc = "Choose items to farm. Leave empty to farm everything.",
    Icon = "filter",
    Values = {
        "All items",
        "Mysterious Arrow", "Rokakaka", "Gold Coin", "Diamond", "Stone Mask",
        "Quinton's Glove", "Steel Ball", "Dio's Diary", "Pure Rokakaka",
        "Lucky Arrow", "Lucky Stone Mask", "Rib Cage of The Saint's Corpse",
        "Ancient Scroll", "Caesar's Headband", "Clackers", "Zeppeli's Hat",
        "Christmas Present", "Green Candy", "Red Candy", "Blue Candy", "Yellow Candy",
    },
    Value = #Config.FarmOnlyItems > 0 and Config.FarmOnlyItems or {"All items"},
    Multi = true,
    Callback = function(selected)
        Config.FarmOnlyItems = chopaList(selected)
        MethionSH_Env.__MethionSHFarmOnlyItems = Config.FarmOnlyItems
        chopaWriteList(CHOPA_FARM_ITEMS_FILE, Config.FarmOnlyItems)     -- Chopa: kept after restart / rejoin
    end,
})
FarmSettings:Slider({
    Title = "Instant Arrival Delay",
    Desc = "Let the character settle before picking up an item.",
    Icon = "timer",
    Value = {Min = 0.2, Max = 1.0, Default = 0.35},
    Step = 0.05,
    Callback = function(value)
        Config.InstantDelay = math.clamp(tonumber(value) or 0.35, 0.2, 1.0)
    end,
})
FarmSettings:Slider({
    Title = "Tween Speed",
    Desc = "Movement speed when Tween mode is selected.",
    Icon = "gauge",
    Value = {Min = 10, Max = 500, Default = 220},
    Step = 5,
    Callback = function(value)
        Config.TweenSpeed = math.clamp(tonumber(value) or 220, 10, 500)
    end,
})
FarmSettings:Toggle({
    Title = "Boosted",
    Desc = "Faster pickup; may cause kicks. Instant mode only.",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        Config.Boosted = state == true
        if Config.Boosted then
            AirflowCompat:Notify({
                Title = "Boosted enabled",
                Content = "Boosted may cause frequent kicks. Disable it if the server becomes unstable.",
                Type = "Warning",
                Duration = 5,
            })
        end
    end,
})
FarmSettings:Toggle({
    Title = "Reload script on kick",
    Desc = "Rejoin, enter the game, and reload the script after a kick.",
    Icon = "refresh-cw",
    Value = Config.AutoRejoinEnabled,
    Callback = function(state)
        Config.AutoRejoinEnabled = state == true
        MethionSH_Env.__MethionSHReloadOnKick = Config.AutoRejoinEnabled
        if state then Rejoin.start() else Rejoin.stop() end
    end,
})
local FarmViewerSection = FarmTab:Section({Title = "Live Item Target", Side = "left"})
local FarmItemViewerLastTarget = nil
_G.__PhantomFarmItemViewer = FarmViewerSection:Viewer({
    Name = "Auto Farm Item Viewer",
    Desc = "Shows the item Auto Farm is going for.",
    Players = false,
    Height = 240,
    Float = false,
    AutoRotate = true,
    SpinSpeed = 0.7,
    Interactive = true,
    ShowTargetSelector = false,
    ShowTargetSwitch = false,
    ShowPreviousButton = false,
    ShowNextButton = false,
    ShowTargetDropdown = false,
    ShowHint = false,
    ShowToolStrip = false,
    ShowZoomControls = false,
    ShowZoomIn = false,
    ShowZoomOut = false,
    ShowPanToggle = false,
    ShowRotateToggle = false,
    ShowLockFacing = false,
    ShowSpectate = false,
    ShowResetView = false,
    ShowPresets = false,
    ShowFloatButton = false,
    Callback = function(target)
        if target then FarmItemViewerLastTarget = target end
    end,
})
_G.__PhantomQuestFarmSetItemViewerTarget = function(target)
    if typeof(target) ~= "Instance" or not target.Parent then return end
    if target == FarmItemViewerLastTarget then return end
    FarmItemViewerLastTarget = target
    local viewer = _G.__PhantomFarmItemViewer
    if not viewer then return end
    local setMethod
    pcall(function() setMethod = viewer.Set end)
    if type(setMethod) == "function" then
        local ok = pcall(function() setMethod(viewer, target) end)
        if ok then return end
    end
    pcall(function() viewer:Add(target, nil, true) end)
end

local ESPTab = Window:Tab({Title = "ESP", Icon = "eye", Desc = "Show items and players."})
ESPTab:Header("ESP Control Center")
ESPTab:Paragraph({
    Title = "World overlays",
    Desc = "Change item and player ESP separately.",
})

local ESPViewerSection = ESPTab:Section({Title = "Live Target Viewer", Side = "right"})
ESPViewerSection:Paragraph({
    Title = "3D viewer",
    Desc = "Drag to look around, then select a player, NPC, or item.",
})
UIRefs.viewerTargetStatus = ESPViewerSection:Paragraph({
    Title = "Selected target",
    Desc = "Nothing selected.",
})

_G.__PhantomViewerAddedTargets = setmetatable({}, {__mode = "k"})
_G.__PhantomPlayerViewer = ESPViewerSection:Viewer({
    Name = "Player Viewer",
    Desc = "Shows players, NPCs, and items.",
    Players = true,
    Height = 240,
    Float = false,
    Callback = function(target, index)
        local targetName = "Unknown target"
        local targetKind = "OBJECT"
        if typeof(target) == "Instance" then
            targetName = target.Name
            if target:IsA("Player") then
                targetKind = "PLAYER"
            elseif target:IsA("Tool") then
                targetKind = "ITEM"
            elseif target:IsA("Model") then
                targetKind = target:FindFirstChild("Spawn") and "NPC" or "MODEL"
            elseif target:IsA("BasePart") then
                targetKind = "ITEM / PART"
            end
        end
        if UIRefs.viewerTargetStatus and UIRefs.viewerTargetStatus.SetDesc then
            UIRefs.viewerTargetStatus:SetDesc(targetKind .. " | " .. targetName .. " | index " .. tostring(index or "?"))
        end
    end,
})
if not _G.__PhantomPlayerViewer and UIRefs.viewerTargetStatus then
    UIRefs.viewerTargetStatus:SetDesc("Viewer unavailable. The loaded Flow library must include the Tab:Viewer element.")
end

_G.__PhantomViewerAddTarget = function(target, selectTarget)
    local viewer = _G.__PhantomPlayerViewer
    if not viewer or typeof(target) ~= "Instance" then return false end

    local addedTargets = _G.__PhantomViewerAddedTargets
    if type(addedTargets) ~= "table" then
        addedTargets = setmetatable({}, {__mode = "k"})
        _G.__PhantomViewerAddedTargets = addedTargets
    end

    if addedTargets[target] then
        if selectTarget and type(viewer.Set) == "function" then
            pcall(function() viewer:Set(target) end)
        end
        return true
    end

    local ok = pcall(function()
        if selectTarget then
            viewer:Add(target, nil, true)
        else
            viewer:Add(target)
        end
    end)
    if not ok then return false end
    addedTargets[target] = true

    pcall(function()
        target.AncestryChanged:Connect(function()
            task.defer(function()
                if target.Parent and target:IsDescendantOf(workspace) then return end
                local currentViewer = _G.__PhantomPlayerViewer
                if currentViewer and type(currentViewer.Remove) == "function" then
                    pcall(function() currentViewer:Remove(target) end)
                end
                local currentTargets = _G.__PhantomViewerAddedTargets
                if type(currentTargets) == "table" then currentTargets[target] = nil end
            end)
        end)
    end)
    return true
end

local function addViewerNPC(npc)
    if not npc or not npc:IsA("Model") then return end
    task.spawn(function()
        if not npc:FindFirstChild("Spawn") and npc.Parent then
            pcall(function() npc:WaitForChild("Spawn", 1) end)
        end
        if npc.Parent and npc:IsDescendantOf(workspace) and npc:FindFirstChild("Spawn") then
            if _G.__PhantomViewerAddTarget then
                _G.__PhantomViewerAddTarget(npc)
            end
        end
    end)
end

local existingLivingForViewer = workspace:FindFirstChild("Living")
if existingLivingForViewer then
    for _, npc in ipairs(existingLivingForViewer:GetChildren()) do
        addViewerNPC(npc)
    end
    existingLivingForViewer.ChildAdded:Connect(addViewerNPC)
end
workspace.ChildAdded:Connect(function(child)
    if child and child.Name == "Living" then
        for _, npc in ipairs(child:GetChildren()) do
            addViewerNPC(npc)
        end
        child.ChildAdded:Connect(addViewerNPC)
    end
end)

local ItemControl = ESPTab:Section({Title = "Item tracking", Side = "left"})
ItemControl:Toggle({
    Title = "Item ESP",
    Desc = "Highlight items around the map.",
    Icon = "package-search",
    Value = true,
    Callback = function(state)
        State.ItemEsp = state
        if state then ItemESP.scan() end
        ItemESP.setVisible(state)
    end,
})
UIRefs.farmItemsLabel = ItemControl:Paragraph({Title = "Items detected", Desc = tostring(ItemESP.count())})
ItemControl:Toggle({
    Title = "Show item distance",
    Desc = "Show the distance under each item name.",
    Icon = "ruler",
    Value = Config.Esp.ShowItemDistance,
    Callback = function(state)
        Config.Esp.ShowItemDistance = state
        ItemESP.refresh()
    end,
})
ItemControl:Toggle({
    Title = "Item tracker",
    Desc = "Draw a line from the screen edge to each world item.",
    Icon = "route",
    Value = State.ItemTracker,
    Callback = function(state)
        State.ItemTracker = state == true
    end,
})
ItemControl:Dropdown({
    Title = "Item tracker position",
    Desc = "Start each item line from one fixed point at the top or bottom center.",
    Values = {"Above", "Bottom"},
    Value = Config.Esp.ItemTrackerPosition,
    Callback = function(value)
        if value == "Above" or value == "Bottom" then
            Config.Esp.ItemTrackerPosition = value
        end
    end,
})
ItemControl:Toggle({
    Title = "Notify on item spawn",
    Desc = "Notify me when an item appears.",
    Icon = "bell-ring",
    Value = true,
    Callback = function(state)
        State.NotifyItemSpawn = state
        Config.NotifyItemSpawn = state
    end,
})
ItemControl:Toggle({
    Title = "Use per-item colors",
    Desc = "Use a different color for each item type.",
    Icon = "palette",
    Value = Config.Esp.ItemUseTypeColors,
    Callback = function(state)
        Config.Esp.ItemUseTypeColors = state
        ItemESP.refresh()
    end,
})

local ItemAppearance = ESPTab:Section({Title = "Item appearance", Side = "left"})
ItemAppearance:ColorPicker({
    Title = "Item highlight color",
    Desc = "Item fill color.",
    Default = Config.Esp.ItemHighlightColor,
    Flag = "PhantomESPItemHighlightColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.ItemHighlightColor = color
        ItemESP.refresh()
    end,
})
ItemAppearance:ColorPicker({
    Title = "Item outline color",
    Desc = "Item outline color.",
    Default = Config.Esp.ItemOutlineColor,
    Flag = "PhantomESPItemOutlineColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.ItemOutlineColor = color
        ItemESP.refresh()
    end,
})
ItemAppearance:ColorPicker({
    Title = "Item name color",
    Desc = "Item text color.",
    Default = Config.Esp.ItemNameColor,
    Flag = "PhantomESPItemNameColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.ItemNameColor = color
        ItemESP.refresh()
    end,
})
ItemAppearance:Slider({
    Title = "Highlight fill opacity",
    Desc = "Lower values make the fill more solid.",
    Value = {Min = 0, Max = 0.95, Default = Config.Esp.ItemFillTransparency},
    Step = 0.05,
    Callback = function(value)
        Config.Esp.ItemFillTransparency = value
        ItemESP.refresh()
    end,
})
ItemAppearance:Slider({
    Title = "Outline transparency",
    Desc = "0 makes the outline solid.",
    Value = {Min = 0, Max = 0.95, Default = Config.Esp.ItemOutlineTransparency},
    Step = 0.05,
    Callback = function(value)
        Config.Esp.ItemOutlineTransparency = value
        ItemESP.refresh()
    end,
})
ItemAppearance:Slider({
    Title = "Item label size",
    Desc = "Item name size.",
    Value = {Min = 8, Max = 24, Default = Config.Esp.ItemTextSize},
    Step = 1,
    Callback = function(value)
        Config.Esp.ItemTextSize = value
        ItemESP.refresh()
    end,
})

local PlayerControl = ESPTab:Section({Title = "Player tracking", Side = "right"})
PlayerControl:Toggle({
    Title = "Player ESP",
    Desc = "Highlight other players.",
    Icon = "users",
    Value = false,
    Callback = function(state)
        State.PlayerEsp = state
        if state then
            PlayerESP.refresh()
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then PlayerESP.remove(plr.Character) end
            end
        end
    end,
})
PlayerControl:Toggle({
    Title = "Player tracker",
    Desc = "Draw a line from the screen edge to each other player.",
    Icon = "route",
    Value = State.PlayerTracker,
    Callback = function(state)
        State.PlayerTracker = state == true
    end,
})
PlayerControl:Dropdown({
    Title = "Player tracker position",
    Desc = "Start each player line from one fixed point at the top or bottom center.",
    Values = {"Above", "Bottom"},
    Value = Config.Esp.PlayerTrackerPosition,
    Callback = function(value)
        if value == "Above" or value == "Bottom" then
            Config.Esp.PlayerTrackerPosition = value
        end
    end,
})
PlayerControl:Toggle({
    Title = "Show player name",
    Desc = "Show player names.",
    Icon = "user-round",
    Value = Config.Esp.ShowPlayerName,
    Callback = function(state) Config.Esp.ShowPlayerName = state end,
})
PlayerControl:Toggle({
    Title = "Show health",
    Desc = "Show health percentage.",
    Icon = "heart-pulse",
    Value = Config.Esp.ShowHP,
    Callback = function(state) Config.Esp.ShowHP = state end,
})
PlayerControl:Toggle({
    Title = "Show distance",
    Desc = "Show distance to the player.",
    Icon = "map-pin",
    Value = Config.Esp.ShowDistance,
    Callback = function(state) Config.Esp.ShowDistance = state end,
})
PlayerControl:Toggle({
    Title = "Show stand",
    Desc = "Show their stand.",
    Icon = "shield",
    Value = Config.Esp.ShowStand,
    Callback = function(state) Config.Esp.ShowStand = state end,
})
PlayerControl:Toggle({
    Title = "Show spec",
    Desc = "Show their fighting style.",
    Icon = "swords",
    Value = Config.Esp.ShowSpec,
    Callback = function(state) Config.Esp.ShowSpec = state end,
})

local PlayerAppearance = ESPTab:Section({Title = "Player appearance", Side = "right"})
PlayerAppearance:ColorPicker({
    Title = "Player highlight color",
    Desc = "Player fill color.",
    Default = Config.Esp.PlayerFillColor,
    Flag = "PhantomESPPlayerFillColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.PlayerFillColor = color
        PlayerESP.refresh()
    end,
})
PlayerAppearance:ColorPicker({
    Title = "Player outline color",
    Desc = "Player outline color.",
    Default = Config.Esp.PlayerOutlineColor,
    Flag = "PhantomESPPlayerOutlineColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.PlayerOutlineColor = color
        PlayerESP.refresh()
    end,
})
PlayerAppearance:ColorPicker({
    Title = "Player name color",
    Desc = "Player text color.",
    Default = Config.Esp.PlayerNameColor,
    Flag = "PhantomESPPlayerNameColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.PlayerNameColor = color
        PlayerESP.refresh()
    end,
})
PlayerAppearance:ColorPicker({
    Title = "Player text outline",
    Desc = "Player text outline color.",
    Default = Config.Esp.PlayerTextOutlineColor,
    Flag = "PhantomESPPlayerTextOutlineColor",
    Callback = function(color)
        if typeof(color) ~= "Color3" then return end
        Config.Esp.PlayerTextOutlineColor = color
        PlayerESP.refresh()
    end,
})
PlayerAppearance:Slider({
    Title = "Player fill transparency",
    Desc = "Lower values make the highlight more solid.",
    Value = {Min = 0, Max = 0.95, Default = Config.Esp.PlayerFillTransparency},
    Step = 0.05,
    Callback = function(value)
        Config.Esp.PlayerFillTransparency = value
        PlayerESP.refresh()
    end,
})
PlayerAppearance:Slider({
    Title = "Player outline transparency",
    Desc = "Change the outline strength.",
    Value = {Min = 0, Max = 0.95, Default = Config.Esp.PlayerOutlineTransparency},
    Step = 0.05,
    Callback = function(value)
        Config.Esp.PlayerOutlineTransparency = value
        PlayerESP.refresh()
    end,
})
PlayerAppearance:Slider({
    Title = "Player label size",
    Desc = "Player text size.",
    Value = {Min = 8, Max = 24, Default = Config.Esp.PlayerTextSize},
    Step = 1,
    Callback = function(value)
        Config.Esp.PlayerTextSize = value
        PlayerESP.refresh()
    end,
})

local SellTab = Window:Tab({Title = "Selling", Icon = "dollar-sign"})
SellTab:Toggle({
    Title = "Auto Sell on Max",
    Desc = "Sell items when they reach their limit.",
    Icon = "package-check",
    Value = true,
    Callback = function(state)
        autoSellMax = state
        if state then Selling.requestAutoSellMaxCheck() end
    end,
})
SellTab:Dropdown({
    Title = "Auto Sell Items (on Pickup)",
    Desc = "Choose what to sell when picked up.",
    Icon = "package",
    Values = itemOptions,
    Value = {},
    Multi = true,
    Callback = function(selected)
        selectedAutoSellItems = selected or {}
    end,
})
SellTab:Toggle({
    Title = "Auto Sell Selected on Pickup",
    Desc = "Sell selected items automatically.",
    Icon = "mouse-pointer-click",
    Value = false,
    Callback = function(state)
        autoSellSelected = state
    end,
})
SellTab:Dropdown({
    Title = "Select Items to Sell All Now",
    Desc = "Choose items for manual selling.",
    Icon = "list-check",
    Values = itemOptions,
    Value = {},
    Multi = true,
    Callback = function(selected)
        selectedSellAllItems = selected or {}
    end,
})
SellTab:Button({
    Title = "Sell All Selected Now",
    Desc = "Sell the selected items now.",
    Icon = "package-check",
    Callback = function()
        task.spawn(function() Selling.sellAllSelected(selectedSellAllItems) end)
    end,
})
SellTab:Slider({
    Title = "Auto Sell Interval (minutes)",
    Desc = "How often to repeat the sale.",
    Icon = "clock",
    Value = {Min = 1, Max = 10, Default = 3},
    Step = 1,
    Callback = function(value)
        autoSellInterval = math.clamp(tonumber(value) or 3, 1, 10)
    end,
})
SellTab:Toggle({
    Title = "Auto Sell All Selected Loop",
    Desc = "Keep selling selected items on a loop.",
    Icon = "repeat",
    Value = false,
    Callback = function(state)
        autoSellAllSelectedLoop = state
        autoSellLoopToken += 1
        local myToken = autoSellLoopToken
        if state then
            task.spawn(function()
                while autoSellAllSelectedLoop and myToken == autoSellLoopToken do
                    local waitUntil = tick() + (math.clamp(tonumber(autoSellInterval) or 3, 1, 10) * 60)
                    while autoSellAllSelectedLoop and myToken == autoSellLoopToken and tick() < waitUntil do
                        task.wait(0.25)
                    end
                    if not autoSellAllSelectedLoop or myToken ~= autoSellLoopToken then break end
                    local chosen = table.clone(selectedSellAllItems)
                    if #chosen > 0 then
                        local okLoop, errLoop = pcall(Selling.sellAllSelected, chosen)
                        if not okLoop then warn("[Methion] Selected-item sell loop failed: " .. tostring(errLoop)) end
                    end
                end
            end)
        end
    end,
})
SellTab:Divider()
SellTab:Button({
    Title = "Sell All Worthless Items",
    Desc = "Sell coins, diamonds, gloves, hats, headbands, and scrolls.",
    Icon = "hand-coins",
    Callback = function()
        task.spawn(Selling.sellAllWorthless)
    end,
})
SellTab:Button({
    Title = "Sell Inventory",
    Desc = "Sell all sellable items.",
    Icon = "shopping-cart",
    Callback = function()
        task.spawn(Selling.sellInventory)
    end,
})

do
local PlayerTab = Window:Tab({Title = "Misc", Icon = "user-round-cog"})
_G.__MethionMiscSections = _G.__MethionMiscSections or {}
_G.__MethionMiscSections.Dialogue = PlayerTab:Section({Title = "Dialogue / Skills", Side = "left"})
_G.__MethionMiscSections.Environment = PlayerTab:Section({Title = "Environment", Side = "left"})
_G.__MethionMiscSections.Movement = PlayerTab:Section({Title = "Character Movement", Side = "left"})

local function miscNotify(title, content, kind)
    pcall(function()
        if CompatWindow then
            CompatWindow:Notify({Title = title, Content = content, Type = kind or "Info", Duration = 4})
        end
    end)
end
_G.__MethionMiscSections.Dialogue:Paragraph({
    Title = "Dialogue / Skills",
    Desc = "NPC dialogue and character skills.",
})
_G.__MethionMiscSections.Dialogue:Button({
    Title = "Talk to Jesus",
    Desc = "Talk to Jesus.",
    Icon = "message-circle",
    Callback = function()
        task.spawn(function()
            local ok, err = pcall(function()
                local args = {
                    "PromptTriggered",
                    ReplicatedStorage:WaitForChild("Dialogue"):WaitForChild("Jesus"),
                }
                local character = LP.Character or LP.CharacterAdded:Wait()
                character:WaitForChild("RemoteEvent"):FireServer(unpack(args))
            end)
            local say = function(t, m) print("[Chopa] " .. t .. ": " .. m) end   -- there is no global notify here
            if ok then
                say("Talk to Jesus", "Jesus dialogue prompt sent.")
            else
                say("Talk to Jesus", "Could not trigger Jesus: " .. tostring(err))
            end
        end)
    end,
})

local antiVamp = false
local antiVampConn = nil

local function enforceHumanRace()
    local stats = LP:FindFirstChild("PlayerStats")
    local race = stats and stats:FindFirstChild("Race")
    if race and race:IsA("StringValue") and race.Value ~= "Human" then
        race.Value = "Human"
    end
end

_G.__MethionMiscSections.Environment:Toggle({
    Title = "Anti Vamp Burn",
    Desc = "Stay human to avoid sun damage.",
    Icon = "moon",
    Value = false,
    Callback = function(state)
        antiVamp = state == true
        if antiVamp then
            if antiVampConn then pcall(function() antiVampConn:Disconnect() end) end
            pcall(enforceHumanRace)
            local elapsed = 0
            antiVampConn = RunService.Heartbeat:Connect(function(dt)
                if not antiVamp then return end
                elapsed += dt
                if elapsed < 0.5 then return end
                elapsed = 0
                pcall(enforceHumanRace)
            end)
            miscNotify("Anti Vamp Burn", "Anti Vamp Burn enabled.", "Success")
        else
            if antiVampConn then
                pcall(function() antiVampConn:Disconnect() end)
                antiVampConn = nil
            end
            miscNotify("Anti Vamp Burn", "Anti Vamp Burn stopped. The current race value was left as-is.", "Info")
        end
    end,
})

_G.__MethionMiscSections.Dialogue:Button({
    Title = "Learn Worthiness",
    Desc = "Learn Worthiness I–V.",
    Icon = "book-open",
    Callback = function()
        task.spawn(function()
            local skills = {"Worthiness", "Worthiness II", "Worthiness III", "Worthiness IV", "Worthiness V"}
            local sent = 0
            for _, skillName in ipairs(skills) do
                local character = LP.Character or LP.CharacterAdded:Wait()
                local remoteFunction = character:FindFirstChild("RemoteFunction") or character:WaitForChild("RemoteFunction", 5)
                if remoteFunction and remoteFunction:IsA("RemoteFunction") then
                    local ok = pcall(function()
                        remoteFunction:InvokeServer("LearnSkill", {
                            Skill = skillName,
                            SkillTreeType = "Character",
                        })
                    end)
                    if ok then sent += 1 end
                end
                task.wait(0.1)
            end
            if sent == #skills then
                miscNotify("Learn Worthiness", "Worthiness I-V requests sent.", "Success")
            else
                miscNotify("Learn Worthiness", tostring(sent) .. "/5 Worthiness requests sent. Check skill points and try again if needed.", "Warning")
            end
        end)
    end,
})
local MovementSection = _G.__MethionMiscSections.Movement
MovementSection:Divider()
MovementSection:Toggle({
    Title = "No-Clip",
    Desc = "Walk through walls.",
    Icon = "shield-off",
    Value = false,
    Callback = function(state)
        Config.Player.NoClipEnabled = state == true
        Player.noclip()
    end,
})

_G.MethionMovementState = _G.MethionMovementState or {
    wsEnabled = false,
    jpEnabled = false,
    wsSpeed = 24,
    jpPower = 24,
    wsConn = nil,
    jpConn = nil,
}
local MovementState = _G.MethionMovementState
for _, key in ipairs({"wsConn", "jpConn"}) do
    if MovementState[key] then pcall(function() MovementState[key]:Disconnect() end) end
    MovementState[key] = nil
end
MovementState.wsEnabled = false
MovementState.jpEnabled = false
MovementState.wsSpeed = 24
MovementState.jpPower = 24
Config.Player.WalkSpeedEnabled = false
Config.Player.JumpPowerEnabled = false
Config.Player.WalkSpeed = 24
Config.Player.JumpPower = 24

_G.MethionGERFloatRuntime = _G.MethionGERFloatRuntime or {}
local GERFloat = _G.MethionGERFloatRuntime
for _, key in ipairs({"conn", "characterConn"}) do
    if GERFloat[key] then pcall(function() GERFloat[key]:Disconnect() end) end
    GERFloat[key] = nil
end
if GERFloat.track then pcall(function() GERFloat.track:Stop() end) end
if GERFloat.anim then pcall(function() GERFloat.anim:Destroy() end) end
GERFloat.enabled = false
GERFloat.track = nil
GERFloat.anim = nil
GERFloat.boundCharacter = nil

local function bindGERFloat(character)
    if not GERFloat.enabled or not character then return end
    if GERFloat.track then pcall(function() GERFloat.track:Stop() end) end
    if GERFloat.anim then pcall(function() GERFloat.anim:Destroy() end) end
    GERFloat.track = nil
    GERFloat.anim = nil
    GERFloat.boundCharacter = character

    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid or not GERFloat.enabled or LP.Character ~= character then return end

    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://4638021147"
    GERFloat.anim = animation
    local ok, track = pcall(function() return humanoid:LoadAnimation(animation) end)
    if ok and track then
        GERFloat.track = track
        track.Priority = Enum.AnimationPriority.Action
        track.Looped = true
        track:Play()
    end
end

local function setGERFloat(enabled)
    GERFloat.enabled = enabled == true
    if GERFloat.conn then pcall(function() GERFloat.conn:Disconnect() end) GERFloat.conn = nil end
    if GERFloat.characterConn then pcall(function() GERFloat.characterConn:Disconnect() end) GERFloat.characterConn = nil end
    if not GERFloat.enabled then
        if GERFloat.track then pcall(function() GERFloat.track:Stop() end) end
        if GERFloat.anim then pcall(function() GERFloat.anim:Destroy() end) end
        GERFloat.track = nil
        GERFloat.anim = nil
        GERFloat.boundCharacter = nil
        return
    end

    if LP.Character then task.spawn(bindGERFloat, LP.Character) end
    GERFloat.characterConn = LP.CharacterAdded:Connect(function(character)
        task.wait(0.35)
        if GERFloat.enabled then bindGERFloat(character) end
    end)
    GERFloat.conn = RunService.RenderStepped:Connect(function()
        if not GERFloat.enabled then return end
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local velocity = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
        end
    end)
end

local function giveClickTpTool()
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if not backpack then
        miscNotify("ClickTP", "Backpack is not ready yet.", "Warning")
        return
    end
    local existing = backpack:FindFirstChild("ClickTP")
    if not existing and LP.Character then existing = LP.Character:FindFirstChild("ClickTP") end
    if existing then pcall(function() existing:Destroy() end) end

    local tool = Instance.new("Tool")
    tool.Name = "ClickTP"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.ToolTip = "Teleport to mouse click"
    local busy = false
    tool.Activated:Connect(function()
        if busy then return end
        busy = true
        task.delay(0.08, function() busy = false end)
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local mouse = LP:GetMouse()
        local hit = mouse and mouse.Hit
        if not hit then return end
        root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
    end)
    tool.Parent = backpack
    miscNotify("ClickTP", "ClickTP added to your backpack.", "Success")
end

MovementSection:Button({
    Title = "Give ClickTP Tool",
    Desc = "Equip the tool and click where you want to go.",
    Icon = "mouse-pointer-2",
    Callback = giveClickTpTool,
})
MovementSection:Slider({
    Title = "WalkSpeed",
    Desc = "Speed while WalkSpeed is enabled.",
    Icon = "gauge",
    Value = {Min = 1, Max = 200, Default = 24},
    Step = 1,
    Callback = function(value)
        MovementState.wsSpeed = math.clamp(tonumber(value) or 24, 1, 200)
        Config.Player.WalkSpeed = MovementState.wsSpeed
    end,
})
MovementSection:Toggle({
    Title = "Enable WalkSpeed",
    Desc = "Keep this speed after respawning.",
    Icon = "footprints",
    Value = false,
    Callback = function(enabled)
        MovementState.wsEnabled = enabled == true
        Config.Player.WalkSpeedEnabled = MovementState.wsEnabled
        if MovementState.wsConn then pcall(function() MovementState.wsConn:Disconnect() end) MovementState.wsConn = nil end
        if MovementState.wsEnabled then
            MovementState.wsConn = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local character = LP.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid.WalkSpeed = MovementState.wsSpeed end
                end)
            end)
        end
    end,
})
MovementSection:Toggle({
    Title = "GER Float",
    Desc = "Use the floating animation.",
    Icon = "move-vertical",
    Value = false,
    Callback = function(enabled)
        local ok, err = pcall(setGERFloat, enabled)
        if not ok then
            pcall(setGERFloat, false)
            miscNotify("GER Float", tostring(err), "Warning")
        end
    end,
})
MovementSection:Slider({
    Title = "JumpPower",
    Desc = "Jump power while enabled.",
    Icon = "arrow-up",
    Value = {Min = 1, Max = 200, Default = 24},
    Step = 1,
    Callback = function(value)
        MovementState.jpPower = math.clamp(tonumber(value) or 24, 1, 200)
        Config.Player.JumpPower = MovementState.jpPower
    end,
})
MovementSection:Toggle({
    Title = "Enable JumpPower",
    Desc = "Keep this jump power after respawning.",
    Icon = "arrow-up-right",
    Value = false,
    Callback = function(enabled)
        MovementState.jpEnabled = enabled == true
        Config.Player.JumpPowerEnabled = MovementState.jpEnabled
        if MovementState.jpConn then pcall(function() MovementState.jpConn:Disconnect() end) MovementState.jpConn = nil end
        if MovementState.jpEnabled then
            MovementState.jpConn = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local character = LP.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid.JumpPower = MovementState.jpPower end
                end)
            end)
        end
    end,
})

_G.MethionAutoSprintRuntime = _G.MethionAutoSprintRuntime or {}
local AutoSprint = _G.MethionAutoSprintRuntime
if AutoSprint.conn then pcall(function() AutoSprint.conn:Disconnect() end) end
AutoSprint.conn = nil
AutoSprint.enabled = false
local function setAutoSprint(enabled)
    AutoSprint.enabled = enabled == true
    if AutoSprint.conn then pcall(function() AutoSprint.conn:Disconnect() end) AutoSprint.conn = nil end
    if not AutoSprint.enabled then return end
    local lastToggleAt = 0
    AutoSprint.conn = RunService.Heartbeat:Connect(function()
        if not AutoSprint.enabled then return end
        local character = LP.Character
        if not character or character:GetAttribute("Sprinting") then return end
        local now = tick()
        if now - lastToggleAt < 0.25 then return end
        local remoteFunction = character:FindFirstChild("RemoteFunction")
        if not remoteFunction then return end
        lastToggleAt = now
        pcall(function() remoteFunction:InvokeServer("ToggleSprinting") end)
    end)
end
MovementSection:Toggle({
    Title = "Auto Sprint",
    Desc = "Sprint automatically.",
    Icon = "zap",
    Value = false,
    Callback = function(enabled)
        local ok, err = pcall(setAutoSprint, enabled)
        if not ok then
            pcall(setAutoSprint, false)
            miscNotify("Auto Sprint", tostring(err), "Warning")
        end
    end,
})

local StandPilotSection = PlayerTab:Section({Title = "Stand Pilot", Side = "right"})
_G.MethionStandPilotRuntime = _G.MethionStandPilotRuntime or {}
local StandPilot = _G.MethionStandPilotRuntime
if type(StandPilot.Cleanup) == "function" then pcall(StandPilot.Cleanup) end
for _, connection in pairs(StandPilot.Connections or {}) do
    pcall(function() connection:Disconnect() end)
end
if StandPilot.InfiniteRangeConnection then pcall(function() StandPilot.InfiniteRangeConnection:Disconnect() end) end
StandPilot.Enabled = false
StandPilot.Connections = {}
StandPilot.Collision = {}
StandPilot.CollisionGroups = {}
StandPilot.AlignStates = {}
StandPilot.InfiniteRangeEnabled = false
StandPilot.InfiniteRangeConnection = nil
StandPilot.Character = nil
StandPilot.Stand = nil
StandPilot.Controller = nil
StandPilot.FocusCam = nil
StandPilot.AnimationTracks = {}
StandPilot.AnimationObjects = {}
StandPilot.Animator = nil
StandPilot.ActiveMovementAnimation = nil
StandPilot.WalkSpeed = 16
StandPilot.RunSpeed = 44
StandPilot.OriginalWalkSpeed = nil
StandPilot.OriginalHipHeight = nil
StandPilot.ActiveSpeedMode = nil

local STAND_PILOT_GROUND_LIFT = 0.55
local STAND_PILOT_ANIMATION_IDS = {

    {Name = "Idle", Id = "rbxassetid://4628343401", Priority = Enum.AnimationPriority.Movement},
    {Name = "IdleSecondary", Id = "rbxassetid://4653736266", Priority = Enum.AnimationPriority.Movement},
    {Name = "SlowWalk", Id = "rbxassetid://4773319528", Priority = Enum.AnimationPriority.Movement},
    {Name = "Walk", Id = "rbxassetid://4653548217", Priority = Enum.AnimationPriority.Movement},
    {Name = "Run", Id = "rbxassetid://5191325822", Priority = Enum.AnimationPriority.Action},
}

local function getStandMorph()
    local character = LP.Character
    return character and character:FindFirstChild("StandMorph")
end

local function getCharacterRemoteFunction(character)
    character = character or LP.Character
    if not character then return nil end
    local remoteFunction = character:FindFirstChild("RemoteFunction")
    if not remoteFunction then
        local ok, result = pcall(function() return character:WaitForChild("RemoteFunction", 5) end)
        if ok then remoteFunction = result end
    end
    return remoteFunction
end

local function resolveStandController(standMorph)
    if not standMorph then return nil end
    local humanoid = standMorph:FindFirstChildOfClass("Humanoid")
    if humanoid then return humanoid end
    return standMorph:FindFirstChildOfClass("AnimationController") or standMorph:FindFirstChild("AnimationController")
end

local function prepareStandPilotController(controller)
    if not controller then return end

    StandPilot.OriginalWalkSpeed = nil
    StandPilot.OriginalHipHeight = nil
    StandPilot.ActiveSpeedMode = nil

    pcall(function()
        local currentSpeed = controller.WalkSpeed
        if type(currentSpeed) == "number" then
            StandPilot.OriginalWalkSpeed = currentSpeed
        end
    end)

    if controller:IsA("Humanoid") then
        pcall(function()
            StandPilot.OriginalHipHeight = controller.HipHeight
            controller.HipHeight = StandPilot.OriginalHipHeight + STAND_PILOT_GROUND_LIFT
        end)
    end
end

local function applyStandPilotSpeed(modeName)
    local controller = StandPilot.Controller
    if not controller or not controller.Parent then return end

    local desiredSpeed
    if modeName == "Run" then
        desiredSpeed = StandPilot.RunSpeed
    elseif modeName == "SlowWalk" then
        desiredSpeed = math.min(StandPilot.WalkSpeed, 8)
    else
        desiredSpeed = StandPilot.WalkSpeed
    end

    pcall(function()
        controller.WalkSpeed = desiredSpeed
    end)
    StandPilot.ActiveSpeedMode = modeName
end

local function standPilotAnimationRate(modeName)
    local rate = 1
    if modeName == "Walk" then
        rate = StandPilot.WalkSpeed / 18
    elseif modeName == "SlowWalk" then
        rate = math.min(StandPilot.WalkSpeed, 8) / 10
    elseif modeName == "Run" then
        rate = StandPilot.RunSpeed / 52
    end
    return math.clamp(rate, 0.55, 1.35)
end

local function clearStandPilotAnimations()
    for _, track in pairs(StandPilot.AnimationTracks or {}) do
        if track then pcall(function() track:Stop(0.12) end) end
    end
    for _, animation in pairs(StandPilot.AnimationObjects or {}) do
        if animation then pcall(function() animation:Destroy() end) end
    end
    StandPilot.AnimationTracks = {}
    StandPilot.AnimationObjects = {}
    StandPilot.Animator = nil
    StandPilot.ActiveMovementAnimation = nil
end

local function bindStandPilotAnimations(stand, controller)
    clearStandPilotAnimations()
    if not stand or not controller then return end

    local animator = controller:FindFirstChildOfClass("Animator")
    if not animator and (controller:IsA("Humanoid") or controller:IsA("AnimationController")) then
        local ok, created = pcall(function()
            local newAnimator = Instance.new("Animator")
            newAnimator.Parent = controller
            return newAnimator
        end)
        if ok then animator = created end
    end
    if not animator then return end

    StandPilot.Animator = animator
    for _, definition in ipairs(STAND_PILOT_ANIMATION_IDS) do
        local animation = Instance.new("Animation")
        animation.Name = "MethionPilot_" .. definition.Name
        animation.AnimationId = definition.Id
        local ok, track = pcall(function() return animator:LoadAnimation(animation) end)
        if ok and track then
            track.Looped = true
            track.Priority = definition.Priority
            StandPilot.AnimationTracks[definition.Name] = track
            StandPilot.AnimationObjects[definition.Name] = animation
        else
            pcall(function() animation:Destroy() end)
        end
    end
end

local function updateStandPilotMovementAnimation()
    if not StandPilot.Enabled then return end

    local character = StandPilot.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local movement = humanoid and humanoid.MoveDirection or Vector3.zero
    local characterIsMoving = movement.Magnitude > 0.05

    local sprinting = character and character:GetAttribute("Sprinting") == true
    local shiftDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
        or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    local slowWalkDown = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)

    local stateName = "Idle"
    if characterIsMoving then
        if sprinting or shiftDown then
            stateName = "Run"
        elseif slowWalkDown or StandPilot.WalkSpeed <= 8 then
            stateName = "SlowWalk"
        else
            stateName = "Walk"
        end
    end

    applyStandPilotSpeed(stateName)

    if stateName == "Idle" then
        for name, track in pairs(StandPilot.AnimationTracks or {}) do
            if track and name ~= "Idle" and name ~= "IdleSecondary" then
                pcall(function() track:Stop(0.15) end)
            end
        end

        for _, name in ipairs({"Idle", "IdleSecondary"}) do
            local idleTrack = StandPilot.AnimationTracks[name]
            if idleTrack then
                pcall(function()
                    idleTrack:AdjustSpeed(1)
                    if not idleTrack.IsPlaying then
                        idleTrack:Play(0.18, 1, 1)
                    end
                end)
            end
        end

        StandPilot.ActiveMovementAnimation = "Idle"
        return
    end

    local selected = StandPilot.AnimationTracks[stateName]
    local playbackRate = standPilotAnimationRate(stateName)

    if StandPilot.ActiveMovementAnimation == stateName then
        if selected then pcall(function() selected:AdjustSpeed(playbackRate) end) end
        return
    end

    for _, track in pairs(StandPilot.AnimationTracks or {}) do
        if track then pcall(function() track:Stop(0.15) end) end
    end

    if selected then
        pcall(function()
            selected:Play(0.15, 1, playbackRate)
        end)
        StandPilot.ActiveMovementAnimation = stateName
    else
        StandPilot.ActiveMovementAnimation = nil
    end
end

local function setPilotCollisionGroup(object)
    if not object or not object.Parent then return end
    if object:IsA("BasePart") or object:IsA("UnionOperation") then
        pcall(function()
            if StandPilot.CollisionGroups[object] == nil then
                StandPilot.CollisionGroups[object] = object.CollisionGroup
            end
            PhysicsService:SetPartCollisionGroup(object, "Players")
        end)
    end
end

local function stopStandPilot()
    local wasActive = StandPilot.Enabled
    StandPilot.Enabled = false

    local controllerToRestore = StandPilot.Controller
    if controllerToRestore and controllerToRestore.Parent then
        if StandPilot.OriginalWalkSpeed ~= nil then
            pcall(function() controllerToRestore.WalkSpeed = StandPilot.OriginalWalkSpeed end)
        end
        if controllerToRestore:IsA("Humanoid") and StandPilot.OriginalHipHeight ~= nil then
            pcall(function() controllerToRestore.HipHeight = StandPilot.OriginalHipHeight end)
        end
    end

    clearStandPilotAnimations()
    for _, connection in pairs(StandPilot.Connections or {}) do
        if connection then pcall(function() connection:Disconnect() end) end
    end
    StandPilot.Connections = {}

    for part, canCollide in pairs(StandPilot.Collision or {}) do
        if part and part.Parent then pcall(function() part.CanCollide = canCollide end) end
    end
    StandPilot.Collision = {}

    for part, collisionGroup in pairs(StandPilot.CollisionGroups or {}) do
        if part and part.Parent and type(collisionGroup) == "string" then
            pcall(function() part.CollisionGroup = collisionGroup end)
        end
    end
    StandPilot.CollisionGroups = {}

    for constraint, wasEnabled in pairs(StandPilot.AlignStates or {}) do
        if constraint and constraint.Parent then pcall(function() constraint.Enabled = wasEnabled end) end
    end
    StandPilot.AlignStates = {}

    local character = StandPilot.Character
    local stand = StandPilot.Stand
    local characterRoot = character and character:FindFirstChild("HumanoidRootPart")
    local standRoot = stand and stand:FindFirstChild("HumanoidRootPart")
    if characterRoot and standRoot then
        pcall(function()
            characterRoot.CFrame = standRoot.CFrame
            characterRoot.AssemblyLinearVelocity = Vector3.zero
            characterRoot.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    if StandPilot.FocusCam then pcall(function() StandPilot.FocusCam:Destroy() end) end
    StandPilot.FocusCam = nil

    local locations = workspace:FindFirstChild("Locations")
    local storage = ReplicatedStorage:FindFirstChild("TempStoragePilot")
    if storage then
        if locations then
            for _, object in ipairs(storage:GetChildren()) do
                if object.Name == "Naples' Sewers" then pcall(function() object.Parent = locations end) end
            end
        end
        pcall(function() storage:Destroy() end)
    end

    if stand and stand.Parent and character then
        local remoteFunction = getCharacterRemoteFunction(character)
        if remoteFunction then pcall(function() remoteFunction:InvokeServer("ToggleStand", "Toggle") end) end
    end

    StandPilot.Character = nil
    StandPilot.Stand = nil
    StandPilot.Controller = nil
    StandPilot.OriginalWalkSpeed = nil
    StandPilot.OriginalHipHeight = nil
    StandPilot.ActiveSpeedMode = nil
    if wasActive then miscNotify("Stand Pilot", "Stand Pilot disabled.", "Info") end
end
StandPilot.Cleanup = stopStandPilot

local function setStandPilot(enabled)
    if not enabled then
        stopStandPilot()
        return
    end
    if StandPilot.Enabled then return end

    local character = LP.Character or LP.CharacterAdded:Wait()
    local characterRoot = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local remoteFunction = getCharacterRemoteFunction(character)
    if not characterRoot or not humanoid or not remoteFunction then
        miscNotify("Stand Pilot", "Character is not ready yet.", "Warning")
        return
    end

    local stand = character:FindFirstChild("StandMorph")
    if not stand then
        pcall(function() remoteFunction:InvokeServer("ToggleStand", "Toggle") end)
        local deadline = tick() + 5
        repeat
            task.wait(0.1)
            stand = character:FindFirstChild("StandMorph")
        until stand or tick() >= deadline or LP.Character ~= character
    end
    if not stand then
        miscNotify("Stand Pilot", "Could not summon your stand.", "Warning")
        return
    end

    local controller = resolveStandController(stand)
    local standRoot = stand:FindFirstChild("HumanoidRootPart") or stand:WaitForChild("HumanoidRootPart", 3)
    if not controller or not standRoot then
        miscNotify("Stand Pilot", "Stand is not fully loaded.", "Warning")
        return
    end

    StandPilot.Character = character
    StandPilot.Stand = stand
    StandPilot.Controller = controller
    StandPilot.Connections = {}
    StandPilot.Collision = {}
    StandPilot.CollisionGroups = {}
    StandPilot.AlignStates = {}
    prepareStandPilotController(controller)
    bindStandPilotAnimations(stand, controller)

    pcall(function()
        local oldFocus = character:FindFirstChild("FocusCam")
        if oldFocus then oldFocus:Destroy() end
        local focus = Instance.new("ObjectValue")
        focus.Name = "FocusCam"
        focus.Value = controller
        focus.Parent = stand.Parent or character
        StandPilot.FocusCam = focus
    end)

    pcall(function()
        local oldStorage = ReplicatedStorage:FindFirstChild("TempStoragePilot")
        if oldStorage then oldStorage:Destroy() end
        local storage = Instance.new("Folder")
        storage.Name = "TempStoragePilot"
        storage.Parent = ReplicatedStorage
        local locations = workspace:FindFirstChild("Locations")
        local sewers = locations and locations:FindFirstChild("Naples' Sewers")
        if sewers then sewers.Parent = storage end
    end)

    local primary = stand.PrimaryPart or standRoot
    local standAttach = primary and primary:FindFirstChild("StandAttach")
    if standAttach then
        for _, name in ipairs({"AlignOrientation", "AlignPosition"}) do
            local constraint = standAttach:FindFirstChild(name)
            if constraint then
                StandPilot.AlignStates[constraint] = constraint.Enabled
                pcall(function() constraint.Enabled = false end)
            end
        end
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            StandPilot.Collision[part] = part.CanCollide
            pcall(function() part.CanCollide = false end)
        end
    end

    StandPilot.Enabled = true
    table.insert(StandPilot.Connections, UserInputService.JumpRequest:Connect(function()
        if not StandPilot.Enabled or not StandPilot.Controller then return end
        pcall(function() StandPilot.Controller.Jump = true end)
    end))

    table.insert(StandPilot.Connections, character.DescendantAdded:Connect(function(object)
        if not StandPilot.Enabled or not object:IsA("BasePart") then return end
        if StandPilot.Collision[object] == nil then StandPilot.Collision[object] = object.CanCollide end
        pcall(function() object.CanCollide = false end)
        setPilotCollisionGroup(object)
    end))

    local nextSummonAttempt = 0
    table.insert(StandPilot.Connections, RunService.Heartbeat:Connect(function()
        if not StandPilot.Enabled then return end
        if LP.Character ~= character or not character.Parent then
            stopStandPilot()
            return
        end
        if not stand or not stand.Parent then
            local currentStand = getStandMorph()
            if currentStand then
                stand = currentStand
                StandPilot.Stand = currentStand
                standRoot = currentStand:FindFirstChild("HumanoidRootPart")
                controller = resolveStandController(currentStand)
                StandPilot.Controller = controller
                prepareStandPilotController(controller)
                bindStandPilotAnimations(currentStand, controller)
            else
                if tick() >= nextSummonAttempt then
                    nextSummonAttempt = tick() + 1
                    pcall(function() remoteFunction:InvokeServer("ToggleStand", "Toggle") end)
                end
                return
            end
        end

        local camera = workspace.CurrentCamera
        if camera and controller and type(controller.Move) == "function" then
            local moveDirection = camera.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
            pcall(function() controller:Move(moveDirection, true) end)
        end

        updateStandPilotMovementAnimation()

        if standRoot and standRoot.Parent and characterRoot and characterRoot.Parent then
            pcall(function()
                characterRoot.CFrame = standRoot.CFrame - Vector3.new(0, 35, 0)
                characterRoot.AssemblyLinearVelocity = Vector3.zero
                characterRoot.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end))

    pcall(function()
        for _, object in ipairs((stand.Parent or stand):GetDescendants()) do setPilotCollisionGroup(object) end
    end)
    miscNotify("Stand Pilot", "Stand Pilot enabled.", "Success")
end

StandPilotSection:Button({
    Title = "Toggle Stand",
    Desc = "Summon or hide your stand.",
    Icon = "user-round",
    Callback = function()
        task.spawn(function()
            local ok, err = pcall(function()
                local character = LP.Character or LP.CharacterAdded:Wait()
                local remoteFunction = getCharacterRemoteFunction(character)
                if not remoteFunction then error("RemoteFunction is not ready") end
                remoteFunction:InvokeServer("ToggleStand", "Toggle")
            end)
            if ok then
                miscNotify("Toggle Stand", "Stand toggle requested.", "Success")
            else
                miscNotify("Toggle Stand", tostring(err), "Warning")
            end
        end)
    end,
})
StandPilotSection:Toggle({
    Title = "Stand Pilot",
    Desc = "Move your stand while your character follows.",
    Icon = "user-round-cog",
    Value = false,
    Callback = function(enabled)
        task.spawn(function()
            local ok, err = pcall(function() setStandPilot(enabled) end)
            if not ok then
                pcall(stopStandPilot)
                miscNotify("Stand Pilot", "Could not change Stand Pilot: " .. tostring(err), "Warning")
            end
        end)
    end,
})
StandPilotSection:Slider({
    Title = "Walk Speed",
    Desc = "Walking speed (1–100).",
    Icon = "footprints",
    Value = {Min = 1, Max = 100, Default = 16},
    Step = 1,
    Callback = function(value)
        StandPilot.WalkSpeed = math.clamp(tonumber(value) or 16, 1, 100)
    end,
})
StandPilotSection:Slider({
    Title = "Run Speed",
    Desc = "Running speed (1–150).",
    Icon = "gauge",
    Value = {Min = 1, Max = 150, Default = 44},
    Step = 1,
    Callback = function(value)
        StandPilot.RunSpeed = math.clamp(tonumber(value) or 44, 1, 150)
    end,
})
StandPilotSection:Toggle({
    Title = "Inf Pilot Range",
    Desc = "Extend stand pilot range.",
    Icon = "scan",
    Value = false,
    Callback = function(enabled)
        StandPilot.InfiniteRangeEnabled = enabled == true
        if StandPilot.InfiniteRangeConnection then
            pcall(function() StandPilot.InfiniteRangeConnection:Disconnect() end)
            StandPilot.InfiniteRangeConnection = nil
        end
        if StandPilot.InfiniteRangeEnabled then
            StandPilot.InfiniteRangeConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local stand = getStandMorph()
                    local isPiloting = stand and stand:FindFirstChild("IsPiloting")
                    if isPiloting then isPiloting.Value = 999999 end
                end)
            end)
            miscNotify("Pilot", "Infinite Pilot Range enabled.", "Success")
        else
            miscNotify("Pilot", "Infinite Pilot Range disabled.", "Info")
        end
    end,
})

if _G.MethionMiscCharacterAddedConnection then
    pcall(function() _G.MethionMiscCharacterAddedConnection:Disconnect() end)
end
_G.MethionMiscCharacterAddedConnection = LP.CharacterAdded:Connect(function()
    task.delay(1, function()
        if StandPilot.Enabled then stopStandPilot() end
    end)
end)

end

-- Chopa: the Trolling tab (Sticky Fingers pull / Mr. President kidnapper) is not included.

if _G.__MethionStandModels then
    _G.__MethionStandModels.AutoApplyRunning = false
    if type(_G.__MethionStandModels.RestoreVisual) == "function" then
        pcall(function() _G.__MethionStandModels.RestoreVisual() end)
    end
end
_G.__MethionStandModels = {
    Catalog = {},
    CatalogByLabel = {},
    Options = {},
    Previewed = setmetatable({}, {__mode = "k"}),
    SelectedModel = nil,
    SelectedLabel = nil,
    SelectedPlayer = nil,
    UseVisual = false,
    VisualClone = nil,
    VisualConnection = nil,
    VisualDescendantConnection = nil,
    VisualNoclipConnection = nil,
    AppliedStand = nil,
    AutoApplyRunning = false,
    AutoApplyLastTry = 0,
    AutoApplyWaitingForStand = false,
    AutoApplyWaitingForModel = false,
    GhostCollisionGroup = nil,
    GhostCollisionGroupReady = false,
    JointMap = {},
    HiddenProperties = {},
    HiddenStand = nil,
    RootToPivot = CFrame.new(),
    PlayerModels = {},
    PlayerNameInput = "",
    SelectedKind = nil,
}

_G.__MethionStandModels.SetStatus = function(message)
    local state = _G.__MethionStandModels
    if state and state.Status and type(state.Status.SetDesc) == "function" then
        pcall(function() state.Status:SetDesc(tostring(message or "")) end)
    end
end

_G.__MethionStandModels.EnsureGhostCollisionGroup = function()
    local state = _G.__MethionStandModels
    if state.GhostCollisionGroupReady and state.GhostCollisionGroup then
        return state.GhostCollisionGroup
    end
    local physics = PhysicsService
    local groupName = "MethionStandNoCollision"
    local groups = {}
    local listed, currentGroups = pcall(function()
        return physics:GetRegisteredCollisionGroups()
    end)
    if listed and type(currentGroups) == "table" then groups = currentGroups end

    local exists = false
    for _, group in ipairs(groups) do
        local name = group.name or group.Name
        if name == groupName then exists = true break end
    end
    if not exists then
        pcall(function() physics:RegisterCollisionGroup(groupName) end)
    end

    local ok, registered = pcall(function()
        return physics:GetRegisteredCollisionGroups()
    end)
    if ok and type(registered) == "table" then
        for _, group in ipairs(registered) do
            local other = group.name or group.Name
            if type(other) == "string" and other ~= "" then
                pcall(function() physics:CollisionGroupSetCollidable(groupName, other, false) end)
            end
        end
    end

    state.GhostCollisionGroup = groupName
    state.GhostCollisionGroupReady = true
    return groupName
end

_G.__MethionStandModels.MakeGhostPart = function(part)
    if not part or not part:IsA("BasePart") then return end
    local state = _G.__MethionStandModels
    local groupName = state.GhostCollisionGroup or _G.__MethionStandModels.EnsureGhostCollisionGroup()
    pcall(function() part.CanCollide = false end)
    pcall(function() part.CanTouch = false end)
    pcall(function() part.CanQuery = false end)
    pcall(function() part.Massless = true end)
    if groupName then pcall(function() part.CollisionGroup = groupName end) end
end

_G.__MethionStandModels.MakeModelNoCollision = function(model)
    if not model then return end
    _G.__MethionStandModels.EnsureGhostCollisionGroup()
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("BasePart") then
            _G.__MethionStandModels.MakeGhostPart(object)
        end
    end
end

_G.__MethionStandModels.GetLocalStand = function()
    local state = _G.__MethionStandModels
    local stand
    pcall(function() stand = getStandMorph() end)
    if stand and stand:IsA("Model") then return stand end
    local character = LP.Character
    stand = character and character:FindFirstChild("StandMorph", true)
    if stand and stand:IsA("Model") then return stand end
    local living = workspace:FindFirstChild("Living")
    local livingCharacter = living and living:FindFirstChild(LP.Name)
    stand = livingCharacter and livingCharacter:FindFirstChild("StandMorph", true)
    if stand and stand:IsA("Model") then return stand end
    return nil
end

_G.__MethionStandModels.IsLocalStandActive = function(stand)
    if not stand or not stand:IsA("Model") or not stand.Parent or not stand:IsDescendantOf(workspace) then
        return false
    end
    local character = LP.Character
    local summoned = character and character:FindFirstChild("SummonedStand")
    if summoned then
        local ok, value = pcall(function() return summoned.Value end)
        if ok and (value == false or value == nil) then
            return false
        end
    end
    return true
end

_G.__MethionStandModels.GetPlayerStand = function(player)
    if not player then return nil end
    local living = workspace:FindFirstChild("Living")
    local livingCharacter = living and living:FindFirstChild(player.Name)
    local candidates = {}
    if livingCharacter then table.insert(candidates, livingCharacter) end
    if player.Character then table.insert(candidates, player.Character) end
    for _, character in ipairs(candidates) do
        if character then
            local stand = character:FindFirstChild("StandMorph")
            if not (stand and stand:IsA("Model")) then
                stand = character:FindFirstChild("StandMorph", true)
            end
            if stand and stand:IsA("Model") and stand:FindFirstChildWhichIsA("BasePart", true) then
                return stand
            end
        end
    end
    return nil
end

_G.__MethionStandModels.ReadModelHint = function(model, hint)
    if not model then return nil end
    local lowerHint = string.lower(hint)
    local function useful(value)
        if value == nil then return nil end
        local text = tostring(value)
        if text == "" or text == "false" or text == "0" then return nil end
        if tonumber(text) then return nil end
        return text
    end
    local ok, attributes = pcall(function() return model:GetAttributes() end)
    if ok then
        for key, value in pairs(attributes) do
            if string.find(string.lower(tostring(key)), lowerHint, 1, true) then
                local result = useful(value)
                if result then return result end
            end
        end
    end
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("ValueBase") and string.find(string.lower(object.Name), lowerHint, 1, true) then
            local okValue, value = pcall(function() return object.Value end)
            if okValue then
                local result = useful(value)
                if result then return result end
            end
        end
    end
    return nil
end

_G.__MethionStandModels.GetStandLabel = function(player, stand)
    local stats = player and player:FindFirstChild("PlayerStats")
    local standValue = stats and stats:FindFirstChild("Stand")
    local standName = standValue and tostring(standValue.Value) or "Stand"
    local skin = _G.__MethionStandModels.ReadModelHint(stand, "skin")
        or _G.__MethionStandModels.ReadModelHint(stand, "variant")
        or _G.__MethionStandModels.ReadModelHint(stand, "form")
    if skin and string.lower(skin) ~= string.lower(standName) then
        return player.Name .. "  |  " .. standName .. "  |  " .. skin
    end
    return player.Name .. "  |  " .. standName
end

_G.__MethionStandModels.RestoreHiddenParts = function()
    local state = _G.__MethionStandModels
    if not state then return end
    for object, saved in pairs(state.HiddenProperties or {}) do
        if object and object.Parent and saved then
            pcall(function()
                if saved.Property == "LocalTransparencyModifier" then
                    object.LocalTransparencyModifier = saved.Value
                elseif saved.Property == "Enabled" then
                    object.Enabled = saved.Value
                end
                if saved.CanCollide ~= nil then
                    object.CanCollide = saved.CanCollide
                end
            end)
        end
    end
    state.HiddenProperties = {}
    state.HiddenStand = nil
end

_G.__MethionStandModels.HideOriginalStand = function(stand)
    local state = _G.__MethionStandModels
    if not state or not stand or not stand.Parent then return end
    state.HiddenStand = stand
    for _, object in ipairs(stand:GetDescendants()) do
        if object:IsA("BasePart") then
            local saved = state.HiddenProperties[object]
            if saved == nil then
                saved = {
                    Property = "LocalTransparencyModifier",
                    Value = object.LocalTransparencyModifier,
                }
                state.HiddenProperties[object] = saved
            end
            if saved.CanCollide == nil then
                saved.CanCollide = object.CanCollide
            end
            pcall(function()
                object.LocalTransparencyModifier = 1
                object.CanCollide = false
            end)
        elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") then
            if state.HiddenProperties[object] == nil then
                state.HiddenProperties[object] = {Property = "Enabled", Value = object.Enabled}
            end
            pcall(function() object.Enabled = false end)
        end
    end
end

_G.__MethionStandModels.RestoreVisual = function(keepToggleState, preserveHiddenStand)
    local state = _G.__MethionStandModels
    if not state then return end
    if state.VisualConnection then
        pcall(function() state.VisualConnection:Disconnect() end)
        state.VisualConnection = nil
    end
    if state.VisualDescendantConnection then
        pcall(function() state.VisualDescendantConnection:Disconnect() end)
        state.VisualDescendantConnection = nil
    end
    if state.VisualNoclipConnection then
        pcall(function() state.VisualNoclipConnection:Disconnect() end)
        state.VisualNoclipConnection = nil
    end
    if state.VisualClone then
        pcall(function() state.VisualClone:Destroy() end)
        state.VisualClone = nil
    end
    state.JointMap = {}
    state.AppliedStand = nil
    if preserveHiddenStand and state.HiddenStand and state.HiddenStand.Parent then

        _G.__MethionStandModels.HideOriginalStand(state.HiddenStand)
    else
        _G.__MethionStandModels.RestoreHiddenParts()
    end
    if not keepToggleState then state.UseVisual = false end
end

_G.__MethionStandModels.SelectModel = function(label)
    local state = _G.__MethionStandModels
    if not state then return end
    local entry = state.CatalogByLabel[tostring(label or "")]
    if type(entry) ~= "table" then return end
    local model = entry.Model
    if not model or not model.Parent then
        _G.__MethionStandModels.SetStatus("That player's model disappeared. Refresh Skins and select another model.")
        return
    end
    state.SelectedLabel = tostring(label)
    state.SelectedModel = model
    state.SelectedPlayer = entry.Player
    state.SelectedKind = entry.Kind or "Stand"
    if state.SelectedKind == "Character" then
        _G.__MethionStandModels.SetStatus("Selected Roblox character " .. state.SelectedLabel .. ". This loads the account avatar even when offline; it is not the player's private YBA stand skin. Animation retargeting depends on compatible joints.")
    else
        _G.__MethionStandModels.SetStatus("Selected " .. state.SelectedLabel .. ". This player's visible StandMorph provides the appearance only; your own stand animation drives the replacement.")
    end

    local viewer = state.Viewer
    if viewer then
        local ok = pcall(function()
            if type(viewer.Clear) == "function" then
                viewer:Clear()
            end
            if type(viewer.Add) == "function" then
                viewer:Add(model, state.SelectedLabel, true)
            elseif type(viewer.Set) == "function" then
                viewer:Set(model, state.SelectedLabel)
            else
                error("Viewer does not expose Add or Set")
            end
            if type(viewer.SetAutoRotate) == "function" then
                viewer:SetAutoRotate(true)
            end
            if type(viewer.Refresh) == "function" then
                viewer:Refresh()
            end
        end)
        if ok then
            state.Previewed[model] = true
        else
            _G.__MethionStandModels.SetStatus("Selected the model, but the live preview could not load it. Try Refresh Skins or load the username again.")
        end
    end
    if state.UseVisual then
        if type(state.StartAutoApply) == "function" then
            state.StartAutoApply()
        end
        local applied, result = pcall(function() return _G.__MethionStandModels.ApplyVisual(true) end)
        if not applied or result ~= true then
            _G.__MethionStandModels.SetStatus("Could not apply selected stand: " .. tostring(result or "source unavailable"))
        end
    end
end

_G.__MethionStandModels.ApplyVisual = function(keepToggleState)
    local state = _G.__MethionStandModels
    if not state then return false end
    local replacingActiveVisual = state.UseVisual == true and state.VisualClone ~= nil
    _G.__MethionStandModels.RestoreVisual(true, replacingActiveVisual)

    local function abortApply(message)

        if keepToggleState == true or state.UseVisual == true then
            state.UseVisual = true
        end
        _G.__MethionStandModels.RestoreVisual(true)
        _G.__MethionStandModels.SetStatus(message)
        return false
    end

    local source = state.SelectedModel
    local stand = _G.__MethionStandModels.GetLocalStand()
    local standRoot = stand and (stand:FindFirstChild("HumanoidRootPart", true) or stand.PrimaryPart or stand:FindFirstChildWhichIsA("BasePart", true))
    if not source or not source.Parent then
        return abortApply("Choose a player's active stand from the dropdown first, then enable Use this model.")
    end
    if not stand or not standRoot or not _G.__MethionStandModels.IsLocalStandActive(stand) then
        return abortApply("Use this model is enabled. Summon your stand to apply the selected model; it will apply automatically when your stand is equipped.")
    end

    local wasArchivable = source.Archivable
    local clone
    local cloneOk = pcall(function()
        source.Archivable = true
        clone = source:Clone()
    end)
    pcall(function() source.Archivable = wasArchivable end)
    if not cloneOk or not clone or not clone:IsA("Model") then
        if clone then pcall(function() clone:Destroy() end) end
        return abortApply("Could not clone that player's stand. Refresh and select a different active stand.")
    end

    for _, object in ipairs(clone:GetDescendants()) do
        if object:IsA("Script") or object:IsA("LocalScript") or object:IsA("ModuleScript")
            or object:IsA("RemoteEvent") or object:IsA("RemoteFunction")
            or object:IsA("BindableEvent") or object:IsA("BindableFunction")
            or object:IsA("ProximityPrompt") or object:IsA("ClickDetector") then
            pcall(function() object:Destroy() end)
        end
    end

    local cloneRoot = clone:FindFirstChild("HumanoidRootPart", true) or clone.PrimaryPart
        or clone:FindFirstChildWhichIsA("BasePart", true)
    if not cloneRoot then
        pcall(function() clone:Destroy() end)
        return abortApply("The selected live stand has no usable root part, so it cannot be aligned to yours.")
    end

    local function relativePath(rootModel, object)
        local path = {}
        local current = object
        while current and current ~= rootModel do
            table.insert(path, 1, current.Name)
            current = current.Parent
        end
        return table.concat(path, "\31")
    end

    local localJointsByPath = {}
    local localJointsByName = {}
    for _, object in ipairs(stand:GetDescendants()) do
        if object:IsA("Motor6D") or object:IsA("Bone") then
            localJointsByPath[relativePath(stand, object)] = object
            localJointsByName[object.Name] = localJointsByName[object.Name] or {}
            table.insert(localJointsByName[object.Name], object)
        end
    end

    local jointMap = {}
    local usedLocalJoints = {}
    for _, object in ipairs(clone:GetDescendants()) do
        if object:IsA("Motor6D") or object:IsA("Bone") then
            local original = localJointsByPath[relativePath(clone, object)]
            if not original or original.ClassName ~= object.ClassName or usedLocalJoints[original] then
                original = nil
                for _, candidate in ipairs(localJointsByName[object.Name] or {}) do
                    if candidate.ClassName == object.ClassName and not usedLocalJoints[candidate] then
                        original = candidate
                        break
                    end
                end
            end
            if original then
                usedLocalJoints[original] = true
                table.insert(jointMap, {Source = original, Clone = object})
            end
        end
    end

    local connectedParts = {}
    local adjacency = {}
    local function linkParts(a, b)
        if not (a and b and a:IsA("BasePart") and b:IsA("BasePart")) then return end
        adjacency[a] = adjacency[a] or {}
        adjacency[b] = adjacency[b] or {}
        table.insert(adjacency[a], b)
        table.insert(adjacency[b], a)
    end
    for _, object in ipairs(clone:GetDescendants()) do
        if object:IsA("JointInstance") or object:IsA("WeldConstraint") then
            pcall(function() linkParts(object.Part0, object.Part1) end)
        elseif object:IsA("Constraint") then
            pcall(function()
                local a = object.Attachment0
                local b = object.Attachment1
                linkParts(a and a.Parent, b and b.Parent)
            end)
        end
    end
    local queue = {cloneRoot}
    connectedParts[cloneRoot] = true
    local queueIndex = 1
    while queueIndex <= #queue do
        local part = queue[queueIndex]
        queueIndex += 1
        for _, connected in ipairs(adjacency[part] or {}) do
            if not connectedParts[connected] then
                connectedParts[connected] = true
                table.insert(queue, connected)
            end
        end
    end

    local rootToPivot = cloneRoot.CFrame:ToObjectSpace(clone:GetPivot())
    clone.Name = "MethionLocalStandModel"
    pcall(function() clone:SetAttribute("MethionVisualStandModel", true) end)

    local ghostGroup = _G.__MethionStandModels.EnsureGhostCollisionGroup()
    for _, object in ipairs(clone:GetDescendants()) do
        if object:IsA("BasePart") then
            _G.__MethionStandModels.MakeGhostPart(object)
            pcall(function()
                if ghostGroup then object.CollisionGroup = ghostGroup end
                object.Anchored = (object == cloneRoot) or not connectedParts[object]
                object.LocalTransparencyModifier = 0
            end)
        elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam") then
            pcall(function() object.Enabled = false end)
        end
    end

    state.VisualClone = clone
    state.AppliedStand = stand
    state.VisualConnection = nil
    state.JointMap = jointMap
    state.RootToPivot = rootToPivot
    state.UseVisual = true
    state.VisualDescendantConnection = clone.DescendantAdded:Connect(function(object)
        if object:IsA("BasePart") then
            _G.__MethionStandModels.MakeGhostPart(object)
        end
    end)
    _G.__MethionStandModels.HideOriginalStand(stand)
    clone.Parent = workspace
    _G.__MethionStandModels.MakeModelNoCollision(clone)
    pcall(function() clone:PivotTo(standRoot.CFrame * rootToPivot) end)

    local nextGhostPass = 0
    state.VisualNoclipConnection = RunService.Stepped:Connect(function()
        if not state.UseVisual or not state.VisualClone or not state.VisualClone.Parent then return end
        if os.clock() < nextGhostPass then return end
        nextGhostPass = os.clock() + 0.25
        _G.__MethionStandModels.MakeModelNoCollision(state.VisualClone)
        if state.HiddenStand and state.HiddenStand.Parent then
            for _, object in ipairs(state.HiddenStand:GetDescendants()) do
                if object:IsA("BasePart") then
                    pcall(function() object.CanCollide = false end)
                end
            end
        end
    end)

    state.VisualConnection = RunService.RenderStepped:Connect(function()
        if not state.UseVisual or not state.VisualClone or not state.VisualClone.Parent then return end

        for _, pair in ipairs(state.JointMap or {}) do
            local sourceJoint = pair.Source
            local cloneJoint = pair.Clone
            if sourceJoint and sourceJoint.Parent and cloneJoint and cloneJoint.Parent then
                pcall(function() cloneJoint.Transform = sourceJoint.Transform end)
            end
        end

        local currentStand = _G.__MethionStandModels.GetLocalStand()
        local currentRoot = currentStand and (currentStand:FindFirstChild("HumanoidRootPart", true) or currentStand.PrimaryPart or currentStand:FindFirstChildWhichIsA("BasePart", true))
        if not currentStand or not currentRoot or not _G.__MethionStandModels.IsLocalStandActive(currentStand) then

            _G.__MethionStandModels.RestoreVisual(true)
            state.AutoApplyWaitingForStand = true
            _G.__MethionStandModels.SetStatus("Use this model is still enabled. Summon your stand and the selected model will apply automatically.")
            return
        end
        if currentStand ~= state.AppliedStand then

            _G.__MethionStandModels.RestoreVisual(true)
            state.AutoApplyWaitingForStand = false
            _G.__MethionStandModels.SetStatus("Your stand changed. Reapplying the selected model automatically...")
            return
        end
        if os.clock() >= (state.NextHidePass or 0) then
            state.NextHidePass = os.clock() + 0.25
            _G.__MethionStandModels.HideOriginalStand(currentStand)
        end
        pcall(function() state.VisualClone:PivotTo(currentRoot.CFrame * state.RootToPivot) end)
    end)
    local sourceName = tostring(state.SelectedLabel or "selected model")
    if state.SelectedKind == "Character" then
        _G.__MethionStandModels.SetStatus("Applied " .. sourceName .. " as a local visual. Use this model stays enabled and will automatically reapply when you summon your stand again; avatar-to-stand animation matching depends on compatible joints.")
    else
        _G.__MethionStandModels.SetStatus("Applied " .. sourceName .. " as a local appearance. Use this model stays enabled and will automatically reapply when you summon your stand again. Your own stand animation drives the replacement.")
    end
    return true
end

_G.__MethionStandModels.StartAutoApply = function()
    local state = _G.__MethionStandModels
    if not state or state.AutoApplyRunning then return end
    state.AutoApplyRunning = true

    task.spawn(function()
        while state and state.AutoApplyRunning do
            if state.UseVisual then
                local source = state.SelectedModel
                local stand = _G.__MethionStandModels.GetLocalStand()
                local root = stand and (stand:FindFirstChild("HumanoidRootPart", true) or stand.PrimaryPart or stand:FindFirstChildWhichIsA("BasePart", true))
                local standReady = stand and root and _G.__MethionStandModels.IsLocalStandActive(stand)
                local visualReady = state.VisualClone and state.VisualClone.Parent and standReady and state.AppliedStand == stand

                if visualReady then
                    state.AutoApplyWaitingForStand = false
                    state.AutoApplyWaitingForModel = false
                else
                    if state.VisualClone and state.VisualClone.Parent then
                        
                        _G.__MethionStandModels.RestoreVisual(true)
                    end

                    if not standReady then
                        state.AutoApplyWaitingForModel = false
                        if not state.AutoApplyWaitingForStand then
                            state.AutoApplyWaitingForStand = true
                            _G.__MethionStandModels.SetStatus("Use this model is enabled. Summon your stand and the selected model will apply automatically.")
                        end
                    elseif not source or not source.Parent then
                        state.AutoApplyWaitingForStand = false
                        if not state.AutoApplyWaitingForModel then
                            state.AutoApplyWaitingForModel = true
                            _G.__MethionStandModels.SetStatus("Use this model is enabled. Select a skin or load a player's username and it will apply automatically.")
                        end
                    elseif tick() - (state.AutoApplyLastTry or 0) >= 1 then
                        state.AutoApplyWaitingForStand = false
                        state.AutoApplyWaitingForModel = false
                        state.AutoApplyLastTry = tick()
                        local ok, result = pcall(function()
                            return _G.__MethionStandModels.ApplyVisual(true)
                        end)
                        if not ok then
                            _G.__MethionStandModels.SetStatus("Automatic skin application failed and will retry: " .. tostring(result))
                        end
                    end
                end
            else
                state.AutoApplyWaitingForStand = false
                state.AutoApplyWaitingForModel = false
            end
            task.wait(0.25)
        end
    end)
end

_G.__MethionStandModels.Scan = function()
    local state = _G.__MethionStandModels
    state.Catalog = {}
    state.CatalogByLabel = {}
    state.Options = {}
    state.SelectedModel = nil
    state.SelectedPlayer = nil

    local seenModels = {}
    for _, player in ipairs(Players:GetPlayers()) do
        local stand = _G.__MethionStandModels.GetPlayerStand(player)
        if stand and not seenModels[stand] then
            local label = _G.__MethionStandModels.GetStandLabel(player, stand)
            local baseLabel, suffix = label, 2
            while state.CatalogByLabel[label] do
                label = baseLabel .. " [" .. tostring(suffix) .. "]"
                suffix += 1
            end
            seenModels[stand] = true
            state.Catalog[stand] = label
            state.CatalogByLabel[label] = {Model = stand, Player = player, Kind = "Stand"}
            table.insert(state.Options, label)
        end
    end

    for label, entry in pairs(state.PlayerModels or {}) do
        if entry and entry.Model and entry.Model.Parent then
            state.Catalog[entry.Model] = label
            state.CatalogByLabel[label] = {Model = entry.Model, Player = entry.Player, Kind = "Character", UserId = entry.UserId}
            table.insert(state.Options, label)
        end
    end

    table.sort(state.Options, function(a, b) return string.lower(a) < string.lower(b) end)
    if state.Dropdown and type(state.Dropdown.Refresh) == "function" then
        pcall(function()
            state.Dropdown:Refresh(#state.Options > 0 and state.Options or {"No active player skins found"}, true)
        end)
    end
    if #state.Options == 0 then
        _G.__MethionStandModels.SetStatus("No models found yet. Refresh skins or load a Roblox username in the Player Character section. Offline characters can load from their public Roblox avatar, but their private YBA stand model cannot be retrieved while offline.")
        return 0
    end

    local localStand = _G.__MethionStandModels.GetLocalStand()
    local preferred
    if localStand then
        for label, entry in pairs(state.CatalogByLabel) do
            if entry.Model == localStand then preferred = label break end
        end
    end
    preferred = preferred or state.Options[1]
    if state.Dropdown and type(state.Dropdown.Set) == "function" then
        pcall(function() state.Dropdown:Set(preferred) end)
    end
    _G.__MethionStandModels.SelectModel(preferred)
    _G.__MethionStandModels.SetStatus("Found " .. tostring(#state.Options) .. " model(s), including active player skins and any loaded Roblox character avatars. Offline avatar entries persist across refreshes for this session.")
    return #state.Options
end

_G.__MethionStandModels.LoadPlayerCharacter = function(username)
    local state = _G.__MethionStandModels
    username = tostring(username or state.PlayerNameInput or ""):gsub("^%s*(.-)%s*$", "%1")
    if username == "" then
        _G.__MethionStandModels.SetStatus("Enter a Roblox username first.")
        return false, "empty username"
    end
    _G.__MethionStandModels.SetStatus("Loading Roblox avatar for @" .. username .. "... This may also work when the account is offline.")

    local userId
    local idOk, idResult = pcall(function()
        return Players:GetUserIdFromNameAsync(username)
    end)
    if not idOk or not tonumber(idResult) then
        local message = "Could not resolve Roblox username @" .. username .. ". Check the exact username and try again."
        _G.__MethionStandModels.SetStatus(message)
        return false, message
    end
    userId = tonumber(idResult)

    local description
    local descriptionErrors = {}
    for _, methodName in ipairs({"GetHumanoidDescriptionFromUserIdAsync", "GetHumanoidDescriptionFromUserId"}) do
        local method
        pcall(function() method = Players[methodName] end)
        if type(method) == "function" then
            local ok, result = pcall(function() return method(Players, userId) end)
            if ok and result then
                description = result
                break
            end
            table.insert(descriptionErrors, tostring(result))
        end
    end

    local model
    if description then
        for _, methodName in ipairs({"CreateHumanoidModelFromDescriptionAsync", "CreateHumanoidModelFromDescription"}) do
            local method
            pcall(function() method = Players[methodName] end)
            if type(method) == "function" then
                local ok, result = pcall(function()
                    return method(Players, description, Enum.HumanoidRigType.R15)
                end)
                if ok and result and result:IsA("Model") then
                    model = result
                    break
                end
                table.insert(descriptionErrors, tostring(result))
            end
        end
    end

    if not model then
        local appearanceMethod
        pcall(function() appearanceMethod = Players.GetCharacterAppearanceAsync end)
        if type(appearanceMethod) == "function" then
            local ok, result = pcall(function() return appearanceMethod(Players, userId) end)
            if ok and result and result:IsA("Model") then
                model = result
            elseif not ok then
                table.insert(descriptionErrors, tostring(result))
            end
        end
    end

    local onlinePlayer = Players:GetPlayerByUserId(userId)
    if not model and onlinePlayer and onlinePlayer.Character then
        local character = onlinePlayer.Character
        local wasArchivable = character.Archivable
        pcall(function()
            character.Archivable = true
            model = character:Clone()
        end)
        pcall(function() character.Archivable = wasArchivable end)
    end

    if not model or not model:IsA("Model") then
        local detail = #descriptionErrors > 0 and (" Details: " .. table.concat(descriptionErrors, " | ")) or ""
        local message = "Roblox did not allow this client to create the avatar model for @" .. username .. "." .. detail .. " Private YBA stand models are only obtainable while replicated by the game."
        _G.__MethionStandModels.SetStatus(message)
        return false, message
    end

    local cache = ReplicatedStorage:FindFirstChild("MethionPlayerModelCache")
    if not cache then
        cache = Instance.new("Folder")
        cache.Name = "MethionPlayerModelCache"
        cache.Parent = ReplicatedStorage
    end
    local modelName = "MethionAvatar_" .. tostring(userId)
    local oldModel = cache:FindFirstChild(modelName)
    if oldModel then

        pcall(function() oldModel:Destroy() end)
    end
    local modelRoot = model:FindFirstChild("HumanoidRootPart", true) or model:FindFirstChildWhichIsA("BasePart", true)
    if modelRoot and modelRoot:IsA("BasePart") then
        pcall(function() model.PrimaryPart = modelRoot end)
        pcall(function() model:PivotTo(CFrame.new()) end)
    end
    model.Name = modelName
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("Script") or object:IsA("LocalScript") or object:IsA("ModuleScript") then
            pcall(function() object:Destroy() end)
        elseif object:IsA("BasePart") then
            _G.__MethionStandModels.MakeGhostPart(object)
        end
    end
    _G.__MethionStandModels.MakeModelNoCollision(model)
    model.Parent = cache

    local displayName = username
    pcall(function()
        local ok, info = pcall(function() return Players:GetNameFromUserIdAsync(userId) end)
        if ok and info then displayName = info end
    end)
    local label = "Character  |  " .. displayName .. "  |  " .. tostring(userId)
    state.PlayerModels[label] = {Model = model, Player = onlinePlayer, UserId = userId, Username = username}
    state.Options = state.Options or {}
    if not table.find(state.Options, label) then table.insert(state.Options, label) end
    table.sort(state.Options, function(a, b) return string.lower(a) < string.lower(b) end)
    state.Catalog[model] = label
    state.CatalogByLabel[label] = {Model = model, Player = onlinePlayer, Kind = "Character", UserId = userId}
    if state.Dropdown and type(state.Dropdown.Refresh) == "function" then
        pcall(function() state.Dropdown:Refresh(state.Options, true) end)
    end
    if state.Dropdown and type(state.Dropdown.Set) == "function" then
        pcall(function() state.Dropdown:Set(label) end)
    end
    _G.__MethionStandModels.SelectModel(label)
    _G.__MethionStandModels.SetStatus("Loaded avatar @" .. username .. ".")
    return true, label
end

local function skinsNotify(title, content, kind)
    pcall(function()
        AirflowCompat:Notify({Title = title, Content = content, Type = kind or "Info", Duration = 4})
    end)
end

_G.__MethionStandModels.Tab = Window:Tab({Title = "Skins", Icon = "user-round-cog", Desc = "View skins or load a player avatar."})
_G.__MethionStandModels.LibrarySection = _G.__MethionStandModels.Tab:Section({Title = "Skin Library", Side = "left"})
_G.__MethionStandModels.ViewerSection = _G.__MethionStandModels.Tab:Section({Title = "Live Skin Preview", Side = "right"})
_G.__MethionStandModels.LibrarySection:Paragraph({
    Title = "Skins & Player Avatars",
    Desc = "Choose a skin from the list or enter a username to load that player’s avatar.",
})
_G.__MethionStandModels.PlayerNameBox = _G.__MethionStandModels.LibrarySection:Input({
    Title = "Player Username",
    Desc = "Enter a Roblox username.",
    Placeholder = "username",
    Value = "",
    Callback = function(value)
        _G.__MethionStandModels.PlayerNameInput = tostring(value or "")
    end,
})
_G.__MethionStandModels.LibrarySection:Button({
    Title = "Load Player Character",
    Desc = "Load the player’s avatar by username.",
    Icon = "user-round-search",
    Callback = function()
        task.spawn(function()
            local ok, result = pcall(function()
                local success, detail = _G.__MethionStandModels.LoadPlayerCharacter(_G.__MethionStandModels.PlayerNameInput)
                if not success then error(detail or "avatar load failed") end
                return detail
            end)
            if ok then
                skinsNotify("Skins", "Loaded player character model.", "Success")
            else
                _G.__MethionStandModels.SetStatus("Could not load player character: " .. tostring(result))
                skinsNotify("Skins", "Could not load that Roblox avatar. Check username or client API access.", "Warning")
            end
        end)
    end,
})
_G.__MethionStandModels.Status = _G.__MethionStandModels.LibrarySection:Paragraph({Title = "Scan status", Desc = "Refresh the list or enter a username."})
_G.__MethionStandModels.Dropdown = _G.__MethionStandModels.LibrarySection:Dropdown({
    Title = "Skin / Player Avatar",
    Desc = "Available skins and loaded player avatars.",
    Values = {"Press Refresh Skins"},
    Value = "Press Refresh Skins",
    Multi = false,
    Callback = function(value)
        _G.__MethionStandModels.SelectModel(value)
    end,
})
_G.__MethionStandModels.LibrarySection:Button({
    Title = "Refresh Skins",
    Desc = "Refresh the skin list.",
    Icon = "refresh-cw",
    Callback = function()
        task.spawn(function()
            local ok, count = pcall(function() return _G.__MethionStandModels.Scan() end)
            if not ok then
                _G.__MethionStandModels.SetStatus("Scan failed: " .. tostring(count))
                skinsNotify("Skins", "Could not scan active player skins.", "Warning")
            elseif count and count > 0 then
                skinsNotify("Skins", "Found " .. tostring(count) .. " skin/avatar model(s).", "Success")
            else
                skinsNotify("Skins", "No models found. Load a username or wait for a player skin to replicate.", "Warning")
            end
        end)
    end,
})
_G.__MethionStandModels.UseToggle = _G.__MethionStandModels.LibrarySection:Toggle({
    Title = "Use this model",
    Desc = "Use this model for your stand. Only you can see it.",
    Icon = "eye",
    Value = false,
    Callback = function(enabled)
        _G.__MethionStandModels.UseVisual = enabled == true
        if enabled then
            _G.__MethionStandModels.StartAutoApply()
            local ok, result = pcall(function() return _G.__MethionStandModels.ApplyVisual(true) end)
            if not ok or result ~= true then

                _G.__MethionStandModels.UseVisual = true
                _G.__MethionStandModels.StartAutoApply()
                _G.__MethionStandModels.SetStatus("Use this model remains enabled. It will apply automatically when your selected model and summoned stand are available.")
                skinsNotify("Skins", "Use this model stays enabled and will apply automatically when the selected model and stand are available.", "Info")
            end
        else
            _G.__MethionStandModels.RestoreVisual(false)
            _G.__MethionStandModels.SetStatus("Restored your original stand appearance locally.")
        end
    end,
})
_G.__MethionStandModels.ViewerStatus = _G.__MethionStandModels.ViewerSection:Paragraph({Title = "Selected skin / avatar", Desc = "Choose a skin or load an avatar to preview it."})
_G.__MethionStandModels.Viewer = _G.__MethionStandModels.ViewerSection:Viewer({
    Name = "Selected Skin / Avatar",
    Desc = "Preview the selected model.",
    Players = false,
    Height = 280,
    Float = false,
    AutoRotate = true,
    SpinSpeed = 0.7,
    Callback = function(target)
        if target and typeof(target) == "Instance" then
            pcall(function() _G.__MethionStandModels.ViewerStatus:SetDesc("Previewing: " .. tostring(_G.__MethionStandModels.SelectedLabel or target.Name)) end)
        end
    end,
})
if not _G.__MethionStandModels.Viewer then
    _G.__MethionStandModels.ViewerStatus:SetDesc("The live viewer is unavailable in this Flow library version. The local visual replacement can still be used.")
end
task.spawn(function()
    task.wait(8)
    pcall(function() _G.__MethionStandModels.Scan() end)
end)

local TeleportsTab = Window:Tab({Title = "Teleports", Icon = "map-pin", Desc = "Teleport to places or players."})
_G.__PhantomRemadeUI = _G.__PhantomRemadeUI or {}

_G.__PhantomRemadeUI.TeleportQuickSection = TeleportsTab:Section({Title = "Quick Destinations", Side = "left"})
_G.__PhantomRemadeUI.TeleportQuickSection:Paragraph({
    Title = "Map Landmarks",
    Desc = "Choose a place to teleport to.",
})

_G.__PhantomRemadeUI.TeleportToolsSection = TeleportsTab:Section({Title = "Travel Tools", Side = "right"})
_G.__PhantomRemadeUI.TeleportToolsSection:Dropdown({
    Title = "Destination",
    Desc = "Choose where to go.",
    Values = Config.Teleport.LocationNames,
    Value = Config.Teleport.SelectedLocation,
    Callback = function(selected)
        if Config.Teleport.Locations[selected] then
            Config.Teleport.SelectedLocation = selected
        end
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Dropdown({
    Title = "Travel Mode",
    Desc = bypassSupported and "Instant moves you there right away. Tween moves you smoothly." or "Instant isn't available here. Tween is enabled.",
    Values = bypassSupported and {"Instant", "Tween"} or {"Tween"},
    Value = Config.Teleport.Mode,
    Callback = function(selected)
        if selected == "Instant" and not bypassSupported then
            Config.Teleport.Mode = "Tween"
            AirflowCompat:Notify({Title = "Instant unavailable", Content = "Instant mode isn't supported here. Tween stays on.", Type = "Warning", Duration = 4})
            return
        end
        if selected == "Instant" or selected == "Tween" then
            Config.Teleport.Mode = selected == "Instant" and bypassSupported and "Instant" or "Tween"
        end
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Button({
    Title = "Teleport to Destination",
    Desc = "Go to the selected place.",
    Icon = "map-pin",
    Callback = function()
        local destination = Config.Teleport.Locations[Config.Teleport.SelectedLocation]
        if not destination then
            AirflowCompat:Notify({Title = "Teleports", Content = "Choose a valid destination first.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(CFrame.new(destination)) end)
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Button({
    Title = "Save Current Position",
    Desc = "Save where you are now.",
    Icon = "bookmark",
    Callback = function()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        Config.Teleport.SavedPosition = root.CFrame
        AirflowCompat:Notify({Title = "Teleports", Content = "Current position saved.", Type = "Success"})
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Button({
    Title = "Return to Saved Position",
    Desc = "Return to your saved spot.",
    Icon = "corner-up-left",
    Callback = function()
        if not Config.Teleport.SavedPosition then
            AirflowCompat:Notify({Title = "Teleports", Content = "Save a position first.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(Config.Teleport.SavedPosition) end)
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Button({
    Title = "Return to Last Position",
    Desc = "Go back to where you were before your last teleport.",
    Icon = "history",
    Callback = function()
        if not Config.Teleport.LastPosition then
            AirflowCompat:Notify({Title = "Teleports", Content = "No previous position has been recorded yet.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(Config.Teleport.LastPosition) end)
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Divider()
_G.__PhantomRemadeUI.TeleportToolsSection:Paragraph({
    Title = "Custom Coordinates",
    Desc = "Enter X, Y, and Z to teleport there.",
})
_G.__PhantomRemadeUI.TeleportToolsSection:Input({
    Title = "Coordinate X",
    Value = "0",
    Placeholder = "X",
    Callback = function(text) Config.Teleport.X = tonumber(text) end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Input({
    Title = "Coordinate Y",
    Value = "0",
    Placeholder = "Y",
    Callback = function(text) Config.Teleport.Y = tonumber(text) end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Input({
    Title = "Coordinate Z",
    Value = "0",
    Placeholder = "Z",
    Callback = function(text) Config.Teleport.Z = tonumber(text) end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Button({
    Title = "Teleport to Coordinates",
    Desc = "Enter valid X, Y, and Z values.",
    Icon = "crosshair",
    Callback = function()
        local x, y, z = tonumber(Config.Teleport.X), tonumber(Config.Teleport.Y), tonumber(Config.Teleport.Z)
        if x == nil or y == nil or z == nil or math.abs(x) > 100000 or math.abs(y) > 100000 or math.abs(z) > 100000 then
            AirflowCompat:Notify({Title = "Teleports", Content = "Enter valid X, Y, and Z values within ±100000.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(CFrame.new(Vector3.new(x, y, z))) end)
    end,
})
_G.__PhantomRemadeUI.TeleportToolsSection:Button({
    Title = "Teleport to Selected Player",
    Desc = "Teleport to the player you selected in Player Info.",
    Icon = "user-round",
    Callback = function()
        local target = State.SelectedPlayer
        local character = target and target.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then
            AirflowCompat:Notify({Title = "Teleports", Content = "Select a live player in Player Info first.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(root.CFrame * CFrame.new(0, 3, 4)) end)
    end,
})

for _, name in ipairs(Config.Teleport.LocationNames) do
    local locationName = name
    _G.__PhantomRemadeUI.TeleportQuickSection:Button({
        Title = locationName,
        Desc = "Teleport to " .. locationName,
        Icon = "map-pin",
        Callback = function()
            local position = Config.Teleport.Locations[locationName]
            if position then
                task.spawn(function() Move.goToCF(CFrame.new(position)) end)
            end
        end,
    })
end

local ShopTab = Window:Tab({Title = "Shop", Icon = "shopping-cart", Desc = "Buy items and fighting styles."})
ShopTab:Header("Shop & Trainer Center")
_G.__MethionShopSections = _G.__MethionShopSections or {}
_G.__MethionShopSections.Dialogues = ShopTab:Section({Title = "NPCs & Special Dialogue", Side = "left"})
_G.__MethionShopSections.Styles = ShopTab:Section({Title = "Fighting Styles", Side = "left"})
_G.__MethionShopSections.Items = ShopTab:Section({Title = "Items & Rare Supplies", Side = "right"})
_G.__MethionShopSections.Parts = ShopTab:Section({Title = "Saint's Corpse Parts", Side = "right"})
_G.__MethionShopSections.Consumables = ShopTab:Section({Title = "Food & Miscellaneous", Side = "right"})
local ShopDialoguesSection = _G.__MethionShopSections.Dialogues
local ShopStylesSection = _G.__MethionShopSections.Styles
local ShopItemsSection = _G.__MethionShopSections.Items
local ShopPartsSection = _G.__MethionShopSections.Parts
local ShopConsumablesSection = _G.__MethionShopSections.Consumables

local function shopNotify(title, content, kind)
    AirflowCompat:Notify({Title = title, Content = content, Type = kind or "Info", Duration = 4})
end

local function shopRemoteEvent()
    local character = LP.Character or LP.CharacterAdded:Wait()
    return character and (character:FindFirstChild("RemoteEvent") or character:WaitForChild("RemoteEvent", 5))
end

local function fireNpc(npcName)
    if State.Selling then
        shopNotify("Shop", "Wait until the current sale finishes before opening another dialogue.", "Warning")
        return false
    end
    local npc = nil
    for _, folderName in ipairs({"Dialogue", "NewDialogue"}) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        if folder then
            npc = folder:FindFirstChild(npcName)
            if not npc and npcName == "Jotaro" then
                npc = folder:FindFirstChild("Jotaro.") or folder:FindFirstChild("Jotaro Kujo")
            end
            if npc then break end
        end
    end
    local remote = shopRemoteEvent()
    if not npc or not remote then
        shopNotify("Shop", "Could not open dialogue for " .. tostring(npcName) .. ".", "Warning")
        return false
    end
    local ok, err = pcall(function() remote:FireServer("PromptTriggered", npc) end)
    if not ok then shopNotify("Shop", tostring(err), "Warning") end
    return ok
end

local function fireDialogueChoice(npcName, dialogueName, optionName)
    if State.Selling then
        shopNotify("Shop", "Wait until the current sale finishes before opening another dialogue.", "Warning")
        return false
    end
    local remote = shopRemoteEvent()
    if not remote then
        shopNotify("Shop", "Your character isn't ready yet.", "Warning")
        return false
    end
    local ok, err = pcall(function()
        remote:FireServer("EndDialogue", {
            NPC = npcName,
            Dialogue = dialogueName,
            Option = optionName,
        })
    end)
    if not ok then shopNotify("Shop", tostring(err), "Warning") end
    return ok
end

local function shopHasItem(itemName, neededCount)
    neededCount = tonumber(neededCount) or 1
    local count = 0
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    local character = LP.Character
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item.Name == itemName then count += 1 end
        end
    end
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item.Name == itemName then count += 1 end
        end
    end
    return count >= neededCount
end

local function shopBuyRequest(itemName, price)
    price = tonumber(price) or 0
    if Utils.money() < price then
        shopNotify("Shop", "Need $" .. tostring(price) .. " to buy " .. tostring(itemName) .. ".", "Warning")
        return
    end
    local remote = shopRemoteEvent()
    if not remote then
        shopNotify("Shop", "Your character isn't ready yet.", "Warning")
        return
    end
    local ok, err = pcall(function()
        remote:FireServer("PurchaseShopItem", {ItemName = itemName})
    end)
    if ok then
        shopNotify("Shop", "Purchase request sent for " .. tostring(itemName) .. ".", "Success")
    else
        shopNotify("Shop", "Purchase request failed: " .. tostring(err), "Warning")
    end
end

local function addShopButton(section, title, description, iconName, callback)
    section:Button({
        Title = title,
        Desc = description or "",
        Icon = iconName or "shopping-cart",
        Callback = callback,
    })
end

ShopDialoguesSection:Paragraph({
    Title = "Trainer Dialogues",
    Desc = "Open trainer dialogue. Some trainers need items or money.",
})
for _, entry in ipairs({
    {"Vampirism Trainer", "Vampirism Trainer"},
    {"Boxing Trainer", "Boxing Trainer"},
    {"Hamon Trainer", "Hamon Trainer"},
    {"Spin Trainer", "Spin Trainer"},
    {"Sword Style Trainer", "Sword Style Trainer"},
    {"Merchant", "Merchant"},
}) do
    local label, npcName = entry[1], entry[2]
    addShopButton(ShopDialoguesSection, label, "Open dialogue with " .. npcName .. ".", "message-circle", function()
        if fireNpc(npcName) then shopNotify("Shop", npcName .. " dialogue triggered.", "Success") end
    end)
end
ShopDialoguesSection:Divider()
addShopButton(ShopDialoguesSection, "Trigger Jesus Dialogue", "Open the Jesus dialogue prompt.", "message-circle", function()
    if fireNpc("Jesus") then shopNotify("Shop", "Jesus dialogue triggered.", "Success") end
end)
addShopButton(ShopDialoguesSection, "Open Jotaro Dialogue", "Trigger Jotaro's dialogue prompt.", "message-circle", function()
    if fireNpc("Jotaro") then shopNotify("Shop", "Jotaro dialogue triggered.", "Info") end
end)
addShopButton(ShopDialoguesSection, "Skip Jotaro Dialogue", "Attempts to advance visible dialogue options for a short period.", "fast-forward", function()
    if not fireNpc("Jotaro") then return end
    task.spawn(function()
        for _ = 1, 40 do
            local dialogue = Gui.currentDialogue()
            if dialogue then
                if Gui.hasVisibleOptions(dialogue) then
                    local option = Gui.option(dialogue, "Option1")
                    if option and Gui.isVisible(option) then Gui.click(option) end
                else
                    Gui.skipClick()
                end
            end
            task.wait(0.1)
        end
        shopNotify("Shop", "Jotaro dialogue skip sequence finished.", "Info")
    end)
end)
addShopButton(ShopDialoguesSection, "Open Halloween Event Shop", "Trigger the Halloween Event dialogue if available.", "store", function()
    if fireNpc("Halloween Event") then shopNotify("Shop", "Halloween Event dialogue triggered.", "Success") end
end)

ShopStylesSection:Paragraph({
    Title = "Fighting Style Purchases",
    Desc = "Check each button for the items and money you need.",
})
addShopButton(ShopStylesSection, "Reset Fighting Style", "Requires 3 Diamonds and $5,000.", "refresh-cw", function()
    if not shopHasItem("Diamond", 3) or Utils.money() < 5000 then
        shopNotify("Shop", "Reset requires 3 Diamonds and $5,000.", "Warning")
        return
    end
    local remote = shopRemoteEvent()
    if remote then
        local ok = pcall(function()
            remote:FireServer("EndDialogue", {NPC = "Matt", Option = "Option1", Dialogue = "Dialogue5"})
        end)
        shopNotify("Shop", ok and "Fighting style reset request sent." or "Could not request the fighting style reset.", ok and "Success" or "Warning")
    end
end)
addShopButton(ShopStylesSection, "Buy Boxing", "Requires Quinton's Glove and $10,000.", "hand", function()
    if not shopHasItem("Quinton's Glove") or Utils.money() < 10000 then
        shopNotify("Shop", "Boxing requires Quinton's Glove and $10,000.", "Warning")
        return
    end
    if fireDialogueChoice("Quinton", "Dialogue5", "Option1") then shopNotify("Shop", "Boxing purchase request sent.", "Success") end
end)
addShopButton(ShopStylesSection, "Buy Boxing Gloves", "Costs $1,000 and requires Boxing Style.", "hand", function()
    if Utils.money() < 1000 then
        shopNotify("Shop", "Boxing Gloves cost $1,000.", "Warning")
        return
    end
    if fireDialogueChoice("Boxing Gloves", "Dialogue1", "Option1") then shopNotify("Shop", "Boxing Gloves request sent.", "Success") end
end)
addShopButton(ShopStylesSection, "Buy Sword Style", "Requires Ancient Scroll and $10,000.", "swords", function()
    if not shopHasItem("Ancient Scroll") or Utils.money() < 10000 then
        shopNotify("Shop", "Sword Style requires an Ancient Scroll and $10,000.", "Warning")
        return
    end
    if fireDialogueChoice("Uzurashi", "Dialogue5", "Option1") then shopNotify("Shop", "Sword Style purchase request sent.", "Success") end
end)
addShopButton(ShopStylesSection, "Buy Pluck", "Requires Sword Style.", "swords", function()
    local spec = LP:FindFirstChild("PlayerStats") and LP.PlayerStats:FindFirstChild("Spec")
    if not spec or spec.Value ~= "SwordStyle" then
        shopNotify("Shop", "Pluck requires Sword Style first.", "Warning")
        return
    end
    if fireDialogueChoice("Pluck", "Dialogue1", "Option1") then shopNotify("Shop", "Pluck purchase request sent.", "Success") end
end)
addShopButton(ShopStylesSection, "Buy Spin", "Requires Steel Ball and $10,000.", "circle-dot", function()
    if not shopHasItem("Steel Ball") or Utils.money() < 10000 then
        shopNotify("Shop", "Spin requires Steel Ball and $10,000.", "Warning")
        return
    end
    if fireDialogueChoice("Gyro", "Dialogue2", "Option1") then shopNotify("Shop", "Spin purchase request sent.", "Success") end
end)
addShopButton(ShopStylesSection, "Buy Vampire", "Requires Stone Mask and $10,000.", "moon", function()
    if not shopHasItem("Stone Mask") or Utils.money() < 10000 then
        shopNotify("Shop", "Vampire requires a Stone Mask and $10,000.", "Warning")
        return
    end
    if fireDialogueChoice("Elder Vampire Roomy", "Dialogue5", "Option1") then shopNotify("Shop", "Vampire purchase request sent.", "Success") end
end)
addShopButton(ShopStylesSection, "Buy Hamon", "Requires a Hamon trainer item and $10,000; opens the trainer dialogue.", "sun", function()
    local hasTrainerItem = shopHasItem("Caesar's Headband") or shopHasItem("Clackers") or shopHasItem("Zeppeli's Hat")
    if not hasTrainerItem or Utils.money() < 10000 then
        shopNotify("Shop", "Hamon requires Caesar's Headband, Clackers, or Zeppeli's Hat plus $10,000.", "Warning")
        return
    end
    if not fireNpc("Lisa Lisa") then return end
    task.spawn(function()
        local deadline = os.clock() + 8
        while os.clock() < deadline do
            local stats = LP:FindFirstChild("PlayerStats")
            local spec = stats and stats:FindFirstChild("Spec")
            if spec and tostring(spec.Value) ~= "None" then
                shopNotify("Shop", "Hamon trainer interaction completed.", "Success")
                return
            end
            local dialogue = Gui.currentDialogue()
            if dialogue then
                if Gui.hasVisibleOptions(dialogue) then
                    local option = Gui.option(dialogue, "Option1")
                    if option and Gui.isVisible(option) then Gui.click(option) end
                else
                    Gui.skipClick()
                end
            end
            task.wait(0.15)
        end
        shopNotify("Shop", "Hamon dialogue was opened, but the style was not confirmed. Finish the dialogue manually if needed.", "Info")
    end)
end)

ShopItemsSection:Paragraph({
    Title = "Item Purchases",
    Desc = "Buy items. Prices are shown on each button.",
})
for _, entry in ipairs({
    {"Lucky Arrow", "1x Lucky Arrow", 75000},
    {"Mysterious Arrow", "1x Mysterious Arrow", 750},
    {"Rokakaka", "1x Rokakaka", 2500},
    {"Pure Rokakaka", "1x Pure Rokakaka", 4000},
    {"DIO's Diary", "1x DIO's Diary", 20000},
}) do
    local label, itemName, price = entry[1], entry[2], entry[3]
    addShopButton(ShopItemsSection, "Buy " .. label, "Price: $" .. tostring(price), "shopping-cart", function()
        shopBuyRequest(itemName, price)
    end)
end
ShopPartsSection:Paragraph({
    Title = "Saint's Corpse Parts",
    Desc = "Buy Saint’s Corpse parts.",
})
for _, entry in ipairs({
    {"Rib Cage of the Saint's Corpse", "1x Rib Cage of the Saint's Corpse", 3500},
    {"Left Arm of the Saint's Corpse", "1x Left Arm of the Saint's Corpse", 15000},
    {"Heart of the Saint's Corpse", "1x Heart of the Saint's Corpse", 45000},
    {"Pelvis of the Saint's Corpse", "1x Pelvis of the Saint's Corpse", 45000},
}) do
    local label, itemName, price = entry[1], entry[2], entry[3]
    addShopButton(ShopPartsSection, "Buy " .. label, "Price: $" .. tostring(price), "package", function()
        shopBuyRequest(itemName, price)
    end)
end
addShopButton(ShopConsumablesSection, "Buy Mysterious Bow", "Request the Mysterious Bow Seller dialogue.", "bow-arrow", function()
    if fireDialogueChoice("Mysterious Bow Seller", "Dialogue4", "Option1") then shopNotify("Shop", "Mysterious Bow purchase request sent.", "Success") end
end)
addShopButton(ShopConsumablesSection, "Buy Pizza", "Costs $50.", "utensils", function()
    if Utils.money() < 50 then shopNotify("Shop", "Pizza costs $50.", "Warning") return end
    if fireDialogueChoice("Pizza", "Dialogue2", "Option1") then shopNotify("Shop", "Pizza request sent.", "Success") end
end)
addShopButton(ShopConsumablesSection, "Buy Tea", "Costs $50.", "coffee", function()
    if Utils.money() < 50 then shopNotify("Shop", "Tea costs $50.", "Warning") return end
    if fireDialogueChoice("Cafe", "Dialogue2", "Option1") then shopNotify("Shop", "Tea request sent.", "Success") end
end)

local WeatherTab = Window:Tab({Title = "Weather", Icon = "cloud", Desc = "Change how the game looks on your screen."})
WeatherTab:Header("Weather Studio")
WeatherTab:Paragraph({
    Title = "Local Visual Settings",
    Desc = "These settings only change what you see.",
})
_G.__PhantomRemadeUI.WeatherPresets = WeatherTab:Section({Title = "Weather Presets", Side = "left"})
_G.__PhantomRemadeUI.WeatherSettings = WeatherTab:Section({Title = "Lighting Controls", Side = "right"})
UIRefs.weatherPresetLabel = _G.__PhantomRemadeUI.WeatherPresets:Paragraph({Title = "Active Preset", Desc = "Original"})
UIRefs.weatherTimeLabel = _G.__PhantomRemadeUI.WeatherPresets:Paragraph({Title = "Local Clock Time", Desc = string.format("%.2f", Lighting.ClockTime)})
_G.__PhantomRemadeUI.WeatherPresets:Divider()
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Clear", Desc = "Clear skies.", Icon = "sun", Callback = function() Weather.apply("Clear") end})
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Sunny", Desc = "Bright sunny lighting.", Icon = "sunrise", Callback = function() Weather.apply("Sunny") end})
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Sunset", Desc = "Sunset lighting.", Icon = "sunset", Callback = function() Weather.apply("Sunset") end})
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Overcast", Desc = "Cloudy lighting.", Icon = "cloud", Callback = function() Weather.apply("Overcast") end})
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Night", Desc = "Night lighting.", Icon = "moon", Callback = function() Weather.apply("Night") end})
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Fog", Desc = "Foggy lighting.", Icon = "cloud-fog", Callback = function() Weather.apply("Fog") end})
_G.__PhantomRemadeUI.WeatherPresets:Button({Title = "Reset Weather", Desc = "Restore the original lighting.", Icon = "refresh-cw", Callback = Weather.reset})

_G.__PhantomRemadeUI.WeatherSettings:Toggle({
    Title = "Manual Time of Day",
    Desc = "Let the slider change the time.",
    Icon = "clock",
    Value = false,
    Callback = function(state)
        Config.Weather.TimeOfDayEnabled = state
        Weather.updateStatus()
    end,
})
_G.__PhantomRemadeUI.WeatherSettings:Slider({
    Title = "Time of Day",
    Desc = "0 = midnight, 12 = noon, 18 = evening.",
    Icon = "clock",
    Value = {Min = 0, Max = 24, Default = math.floor(Lighting.ClockTime)},
    Step = 1,
    Callback = function(value)
        if Config.Weather.TimeOfDayEnabled then
            Lighting.ClockTime = value
            Weather.ActivePreset = "Custom"
        end
        Weather.updateStatus()
    end,
})
_G.__PhantomRemadeUI.WeatherSettings:Slider({
    Title = "Brightness",
    Desc = "Set the brightness.",
    Icon = "sun",
    Value = {Min = 0, Max = 4, Default = math.clamp(Lighting.Brightness, 0, 4)},
    Step = 0.1,
    Callback = function(value) Weather.setBrightness(value) end,
})
_G.__PhantomRemadeUI.WeatherSettings:Slider({
    Title = "Atmosphere Density",
    Desc = "Set the fog thickness.",
    Icon = "cloud-fog",
    Value = {Min = 0, Max = 0.8, Default = math.clamp(weatherOrig.AtmosphereDensity, 0, 0.8)},
    Step = 0.05,
    Callback = function(value) Weather.setDensity(value) end,
})
_G.__PhantomRemadeUI.WeatherSettings:Toggle({
    Title = "Sun Rays",
    Desc = "Toggle sun rays.",
    Icon = "sun",
    Value = weatherOrig.SunRaysEnabled,
    Callback = function(state) Weather.setSunRays(state) end,
})
Weather.updateStatus()

local PlayerInfoTab = Window:Tab({Title = "Player Info", Icon = "info", Desc = "View player stats and teleport to them."})
PlayerInfoTab:Header("Player Inspector")
PlayerInfoTab:Paragraph({
    Title = "Live Player Details",
    Desc = "Choose a player to see their stats.",
})
_G.__PhantomRemadeUI.PlayerTargetSection = PlayerInfoTab:Section({Title = "Player Target", Side = "left"})
_G.__PhantomRemadeUI.PlayerOverviewSection = PlayerInfoTab:Section({Title = "Player Overview", Side = "left"})
_G.__PhantomRemadeUI.PlayerProgressSection = PlayerInfoTab:Section({Title = "Progress & Stats", Side = "right"})
_G.__PhantomRemadeUI.PlayerLoadoutSection = PlayerInfoTab:Section({Title = "Loadout", Side = "right"})

_G.__PhantomPlayerInfoViewer = _G.__PhantomRemadeUI.PlayerProgressSection:Viewer({
    Name = "Selected Player Viewer",
    Desc = "Follow the selected player automatically.",
    Players = true,
    Height = 240,
    Float = false,
    Callback = function(target)
        if typeof(target) == "Instance" and target:IsA("Player") and target ~= State.SelectedPlayer then
            PlayerInfo.setSelected(target)
            if _G.__PhantomRemadeUI.PlayerDropdown then
                pcall(function() _G.__PhantomRemadeUI.PlayerDropdown:Set(target.Name) end)
            end
        end
    end,
})

UIRefs.targetPlayerLabel = _G.__PhantomRemadeUI.PlayerTargetSection:Paragraph({Title = "Selected Target", Desc = "None selected"})
_G.__PhantomRemadeUI.PlayerDropdown = _G.__PhantomRemadeUI.PlayerTargetSection:Dropdown({
    Title = "Select Player",
    Desc = "Choose a player.",
    Values = PlayerInfo.listPlayers(),
    Value = State.SelectedPlayer and State.SelectedPlayer.Name or "-- Select player --",
    Callback = function(name)
        if name == "-- Select player --" then
            PlayerInfo.setSelected(nil)
        else
            PlayerInfo.setSelected(PlayerInfo.findByInput(name))
        end
    end,
})
_G.__PhantomRemadeUI.PlayerTargetSection:Input({
    Title = "Search Player",
    Desc = "Search by username or display name.",
    Icon = "search",
    Value = "",
    Placeholder = "Username or display name",
    Callback = function(text)
        local target = PlayerInfo.findByInput(text)
        PlayerInfo.setSelected(target)
        if target and _G.__PhantomRemadeUI.PlayerDropdown then
            pcall(function() _G.__PhantomRemadeUI.PlayerDropdown:Set(target.Name) end)
        end
    end,
})
_G.__PhantomRemadeUI.PlayerTargetSection:Button({
    Title = "Refresh Player List",
    Desc = "Refresh the player list.",
    Icon = "refresh-cw",
    Callback = function()
        PlayerInfo.refreshList()
        AirflowCompat:Notify({Title = "Player Info", Content = "Player list refreshed.", Type = "Success"})
    end,
})
_G.__PhantomRemadeUI.PlayerTargetSection:Button({
    Title = "Select Nearest Player",
    Desc = "Select the closest player.",
    Icon = "locate-fixed",
    Callback = function()
        local target, distance = PlayerInfo.selectNearest()
        if target then
            if _G.__PhantomRemadeUI.PlayerDropdown then
                pcall(function() _G.__PhantomRemadeUI.PlayerDropdown:Set(target.Name) end)
            end
            AirflowCompat:Notify({Title = "Player Info", Content = "Selected " .. target.Name .. " (" .. tostring(math.floor(distance)) .. " studs away).", Type = "Info"})
        else
            AirflowCompat:Notify({Title = "Player Info", Content = "No living target player was found.", Type = "Warning"})
        end
    end,
})
_G.__PhantomRemadeUI.SpectateToggle = _G.__PhantomRemadeUI.PlayerTargetSection:Toggle({
    Title = "Spectate Target",
    Desc = "Watch the selected player. Turn this off to return.",
    Icon = "eye",
    Value = false,
    Callback = function(enabled)
        State.Spectate = enabled == true
        if State.Spectate then
            local target = State.SelectedPlayer
            if not target or target == LP or not target.Parent then
                State.Spectate = false
                Cam.stop()
                task.defer(function()
                    local control = _G.__PhantomRemadeUI and _G.__PhantomRemadeUI.SpectateToggle
                    if control and type(control.Set) == "function" then
                        pcall(function() control:Set(false) end)
                    end
                end)
                AirflowCompat:Notify({Title = "Player Info", Content = "Select a player first.", Type = "Warning"})
                return
            end
            if not Cam.start(target) then
                State.Spectate = false
                Cam.stop()
                AirflowCompat:Notify({Title = "Player Info", Content = "Could not start spectating that player.", Type = "Warning"})
            end
        else
            Cam.stop()
        end
    end,
})
_G.__PhantomRemadeUI.PlayerTargetSection:Button({
    Title = "Teleport to Target",
    Desc = "Teleport near the selected player.",
    Icon = "map-pin",
    Callback = function()
        local target = State.SelectedPlayer
        local character = target and target.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then
            AirflowCompat:Notify({Title = "Player Info", Content = "Select a player with a loaded character first.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(CFrame.new(root.Position + Vector3.new(0, 3, 0))) end)
    end,
})
_G.__PhantomRemadeUI.PlayerTargetSection:Button({
    Title = "Teleport Behind Target",
    Desc = "Teleport behind the selected player.",
    Icon = "corner-up-right",
    Callback = function()
        local target = State.SelectedPlayer
        local character = target and target.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then
            AirflowCompat:Notify({Title = "Player Info", Content = "Select a player with a loaded character first.", Type = "Warning"})
            return
        end
        task.spawn(function() Move.goToCF(root.CFrame * CFrame.new(0, 3, 4)) end)
    end,
})
_G.__PhantomRemadeUI.PlayerTargetSection:Button({
    Title = "Copy Username",
    Desc = "Copy the selected player’s username.",
    Icon = "copy",
    Callback = function()
        local target = State.SelectedPlayer
        if not target then
            AirflowCompat:Notify({Title = "Player Info", Content = "Select a player first.", Type = "Warning"})
            return
        end
        if type(setclipboard) == "function" then
            local ok = pcall(setclipboard, target.Name)
            if ok then
                AirflowCompat:Notify({Title = "Player Info", Content = "Copied @" .. target.Name .. ".", Type = "Success"})
            else
                AirflowCompat:Notify({Title = "Player Info", Content = "Clipboard access failed in this environment.", Type = "Warning"})
            end
        else
            AirflowCompat:Notify({Title = "Player Info", Content = "Clipboard access is not supported by this environment.", Type = "Warning"})
        end
    end,
})

UIRefs.usernameLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "Username", Desc = "--"})
UIRefs.displayNameLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "Display Name", Desc = "--"})
UIRefs.userIdLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "User ID", Desc = "--"})
UIRefs.accountAgeLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "Account Age", Desc = "--"})
UIRefs.hpLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "Health", Desc = "--"})
UIRefs.standLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "Stand", Desc = "--"})
UIRefs.specLabel = _G.__PhantomRemadeUI.PlayerOverviewSection:Paragraph({Title = "Fighting Style", Desc = "--"})

UIRefs.prestigeLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Prestige", Desc = "--"})
UIRefs.lvlLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Level", Desc = "--"})
UIRefs.expLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Experience", Desc = "--"})
UIRefs.moneyLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Money", Desc = "--"})
UIRefs.playtimeLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Playtime", Desc = "--"})
UIRefs.gangLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Gang", Desc = "--"})
UIRefs.raceLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Race", Desc = "--"})
UIRefs.questLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Current Quest", Desc = "--"})
UIRefs.sbrLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "SBR Wins", Desc = "--"})
UIRefs.skillLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Available Skill Points", Desc = "--"})
UIRefs.pityLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Pity Count", Desc = "--"})
UIRefs.gemsLabel = _G.__PhantomRemadeUI.PlayerProgressSection:Paragraph({Title = "Gems", Desc = "--"})

UIRefs.equippedStandLabel = _G.__PhantomRemadeUI.PlayerLoadoutSection:Paragraph({Title = "Equipped Stand", Desc = "--"})
UIRefs.slot1Label = _G.__PhantomRemadeUI.PlayerLoadoutSection:Paragraph({Title = "Stand Slot 1", Desc = "--"})
UIRefs.slot2Label = _G.__PhantomRemadeUI.PlayerLoadoutSection:Paragraph({Title = "Stand Slot 2", Desc = "--"})
UIRefs.slot3Label = _G.__PhantomRemadeUI.PlayerLoadoutSection:Paragraph({Title = "Stand Slot 3", Desc = "--"})
UIRefs.equippedSpecLabel = _G.__PhantomRemadeUI.PlayerLoadoutSection:Paragraph({Title = "Equipped Fighting Style", Desc = "--"})
UIRefs.specSlot1Label = _G.__PhantomRemadeUI.PlayerLoadoutSection:Paragraph({Title = "Fighting Style Slot 1", Desc = "--"})

Players.PlayerAdded:Connect(function()
    task.delay(0.5, function() PlayerInfo.refreshList() end)
end)
Players.PlayerRemoving:Connect(function(plr)
    task.defer(function()
        if State.SelectedPlayer == plr then
            PlayerInfo.setSelected(nil)
            if _G.__PhantomRemadeUI.PlayerDropdown then
                pcall(function() _G.__PhantomRemadeUI.PlayerDropdown:Set("-- Select player --") end)
            end
        end
        PlayerInfo.refreshList()
    end)
end)

local SettingsTab = Window:Tab({Title = "Settings", Icon = "settings", Desc = "General settings."})
_G.__MethionSettingsSections = _G.__MethionSettingsSections or {}
_G.__MethionSettingsSections.General = SettingsTab:Section({Title = "General", Side = "left"})
_G.__MethionSettingsSections.Movement = SettingsTab:Section({Title = "Movement", Side = "right"})
_G.__MethionSettingsSections.Performance = SettingsTab:Section({Title = "Performance", Side = "left"})

_G.__MethionSettingsSections.General:Paragraph({Title = "General Settings", Desc = "Rejoin and auto-farm settings."})
_G.__MethionSettingsSections.General:Toggle({
    Title = "Reload script on kick",
    Desc = "Rejoin, enter the game, and reload the script after a kick.",
    Icon = "refresh-cw",
    Value = Config.AutoRejoinEnabled,
    Callback = function(state)
        Config.AutoRejoinEnabled = state == true
        MethionSH_Env.__MethionSHReloadOnKick = Config.AutoRejoinEnabled
        if state then Rejoin.start() else Rejoin.stop() end
    end,
})

_G.__MethionSettingsSections.Movement:Paragraph({Title = "Movement", Desc = "Change auto-farm speed and pickup delay."})
_G.__MethionSettingsSections.Movement:Slider({
    Title = "Tween Speed",
    Desc = "Set how fast Tween moves you. Higher means faster.",
    Icon = "gauge",
    Value = {Min = 10, Max = 500, Default = 220},
    Step = 5,
    Callback = function(v) Config.TweenSpeed = math.clamp(tonumber(v) or 220, 10, 500) end,
})
_G.__MethionSettingsSections.Movement:Slider({
    Title = "Instant Arrival Delay",
    Desc = "Wait a moment before picking up an item.",
    Icon = "timer",
    Value = {Min = 0.2, Max = 1.0, Default = 0.35},
    Step = 0.05,
    Callback = function(v) Config.InstantDelay = v end,
})
_G.__MethionSettingsSections.Movement:Toggle({
    Title = "Boosted",
    Desc = "Faster item pickup. May get you kicked. Instant mode only.",
    Icon = "zap",
    Value = false,
    Callback = function(state)
        Config.Boosted = state == true
        if Config.Boosted then
            AirflowCompat:Notify({
                Title = "Boosted enabled",
                Content = "Warning: Boosted may cause frequent kicks. Disable it if the server becomes unstable.",
                Type = "Warning",
                Duration = 5,
            })
        end
    end,
})
_G.__MethionSettingsSections.Performance:Paragraph({Title = "Performance", Desc = "Use this if the game runs slowly. Rejoin to reset it."})
_G.__MethionSettingsSections.Performance:Button({
    Title = "Low Graphics",
    Desc = "Lowers graphics. Rejoin to reset.",
    Icon = "zap",
    Callback = function()
        if not State.LowGraphics then LowGfx.apply() end
    end,
})

-- ================= CHOPA: JACK'S SHOP (Halloween points) → FunPay =================
-- Jack's real menu (recorded in the game, October 2026):
--   «I want to use my points!» → category («2026 Halloween Event Items», «2022 …», «2021 …», «Normal Items»)
--   → item «Name (… Skin) - price». A click on the item BUYS it at once (no question): the item appears in the
--   backpack as a Tool and the dialogue closes. Points are only in Jack's line «You currently have N points».
-- The bot buys only the whitelisted items, spends ALL points (the item it has fewest of first), never clicks an
-- item it can't afford, and counts the items in its backpack → Chopa Hub keeps the FunPay lots in stock.
-- Runs in task.spawn: adds no locals to the main chunk and an error here never stops the script.
task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local A = _G.__ChopaAgent or {}
    local CACHE = "chopa_jack_items.json"            -- written by «Read Jack's shop» and by jack_items_scanner.lua
    local JACK_SHOP = {
        { cat = "2026 Halloween Event Items", items = { "Boxing Blobs", "Spectral Marrow", "Jack-o-Ball", "Sanguine Veil" } },
        { cat = "2022 Halloween Event Items", items = { "Eye of The Saint's Corpse", "Bone Gloves", "Cursed Scythe" } },
        { cat = "2021 Halloween Event Items", items = { "Stop Sign", "Boxing Claws", "Scythe", "Random Halloween Cosmetic" } },
        { cat = "Normal Items", items = { "Mysterious Arrow", "Rokakaka", "Rib Cage of The Saint's Corpse", "DIO's Diary",
            "Green Baby", "Lucky Arrow" } },
    }
    local NOT_FOR_SALE = { sanguineveil = "can't be traded", randomhalloweencosmetic = "a random item" }
    local DEFAULT_ITEMS = { "Jack-o-Ball", "Spectral Marrow", "Boxing Blobs" }
    local JACK_PRICE = { boxingblobs = 60, spectralmarrow = 70, jackoball = 45, sanguineveil = 75,
        eyeofthesaintscorpse = 45, bonegloves = 60, cursedscythe = 70, stopsign = 45, boxingclaws = 60, scythe = 70 }
    local SLOTS, NONE = 6, "—"                         -- «Buy order»: the bot buys these one after another, in turn
    local ORDER_FILE = "chopa_jack_order_" .. tostring(LP and LP.Name or "bot") .. ".txt"
    local AVOID = { "candy", "candies", "turn in", "bye", "leave", "gonna go", "nevermind", "never mind", "later",
        "cancel", "goodbye", "nothing", "no thanks", "back", "explain" }
    local NO_MONEY = { "not enough", "don't have enough", "do not have enough", "need more", "insufficient", "can't afford" }

    local function norm(s) return (tostring(s or ""):lower():gsub("[^%w]", "")) end
    local function trim(x) return (tostring(x or ""):gsub("^%s+", ""):gsub("%s+$", "")) end
    local function has(text, words)
        text = tostring(text or ""):lower()
        for _, w in ipairs(words) do if text:find(w, 1, true) then return true end end
        return false
    end
    local function notify(text, kind)
        pcall(function() AirflowCompat:Notify({ Title = "Jack's shop", Content = text, Type = kind or "Info", Duration = 5 }) end)
    end
    -- «Jack-o-Ball (Steel Ball Skin) - 45» → «Jack-o-Ball»
    local function cleanName(t)
        t = trim(t)
        for _, sep in ipairs({ " – ", " — ", " - ", ": ", " | " }) do
            local i = t:find(sep, 1, true)
            if i and t:sub(i):find("%d") then t = t:sub(1, i - 1) end
        end
        t = t:gsub("%s*%b()%s*$", ""):gsub("%s*%b[]%s*$", "")
        t = t:gsub("%s*[%d,%.]+%s*[Pp]oints?%s*$", "")
        return trim(t)
    end
    local function priceOf(t) return tonumber(tostring(t):match("%-%s*(%d+)%s*$") or tostring(t):match("(%d+)%s*[Pp]oints?%)?%s*$")) end

    local S = { busy = false, fail = {}, price = {}, nextTry = 0, last = "—", points = nil, pointsAt = 0, reread = false }
    local UIE = {}
    local function getv(obj, fallback)
        if not obj then return fallback end
        local ok, v = pcall(function()
            if obj.Raw and type(obj.Raw.Get) == "function" then return obj.Raw:Get() end
            if type(obj.Get) == "function" then return obj:Get() end
        end)
        if ok and v ~= nil then return v end
        return fallback
    end

    -- ---------- Jack's assortment: what was read from the game, else the table above ----------
    local function shopData()
        local list = {}
        pcall(function()
            if isfile and isfile(CACHE) then
                local d = HttpService:JSONDecode(readfile(CACHE))
                if type(d) == "table" and type(d.shop) == "table" then
                    for _, c in ipairs(d.shop) do
                        if type(c) == "table" and c.cat and type(c.items) == "table" then table.insert(list, { cat = c.cat, items = c.items }) end
                    end
                elseif type(d) == "table" and type(d.paths) == "table" then   -- the first scanner's format
                    local by = {}
                    for name, p in pairs(d.paths) do
                        local cat = type(p) == "table" and p[1]
                        if cat then
                            if not by[cat] then by[cat] = { cat = cat, items = {} } table.insert(list, by[cat]) end
                            table.insert(by[cat].items, name)
                        end
                    end
                end
            end
        end)
        local seen = {}
        for _, c in ipairs(list) do for _, n in ipairs(c.items) do seen[norm(n)] = true end end
        for _, c in ipairs(JACK_SHOP) do                 -- the known table fills what was not read
            local extra = {}
            for _, n in ipairs(c.items) do if not seen[norm(n)] then table.insert(extra, n) end end
            if #extra > 0 then table.insert(list, { cat = c.cat, items = extra }) end
        end
        return list
    end
    local function categoryOf(item)
        for _, c in ipairs(shopData()) do
            for _, n in ipairs(c.items) do if norm(n) == norm(item) then return c.cat, n end end
        end
        return nil, item
    end
    local function allItems()                         -- Halloween items only: Normal Items are never bought
        local out, seen = {}, {}
        for _, c in ipairs(shopData()) do
            if tostring(c.cat):lower():find("halloween", 1, true) then
                for _, n in ipairs(c.items) do
                    if not NOT_FOR_SALE[norm(n)] and not seen[norm(n)] then seen[norm(n)] = true table.insert(out, n) end
                end
            end
        end
        return out
    end
    local function isHalloween(item)
        for _, n in ipairs(allItems()) do if norm(n) == norm(item) then return n end end
        return nil
    end

    -- ---------- items in the backpack (Jack's items are Tools, like Lucky Arrows) ----------
    local function bagCount(item)
        local want, n = norm(item), 0
        for _, cont in ipairs({ LP:FindFirstChild("Backpack"), LP.Character }) do
            if cont then
                for _, t in ipairs(cont:GetChildren()) do
                    if t:IsA("Tool") and norm(t.Name) == want then n += 1 end
                end
            end
        end
        return n
    end
    A.specs = {}
    A.specAdd = function() end                         -- the backpack is the count now (kept for the trade code)
    A.specSet = function(name, n) A.specs[name] = n end
    task.spawn(function()                              -- skins / Jack's items this bot owns → Chopa Hub (stock)
        while true do
            local set = {}
            for _, c in ipairs(shopData()) do for _, n in ipairs(c.items) do set[norm(n)] = true end end
            set.luckyarrow = nil                       -- Lucky Arrows have their own lot
            local counts = {}
            for _, cont in ipairs({ LP:FindFirstChild("Backpack"), LP.Character }) do
                if cont then
                    for _, t in ipairs(cont:GetChildren()) do
                        if t:IsA("Tool") and set[norm(t.Name)] then counts[t.Name] = (counts[t.Name] or 0) + 1 end
                    end
                end
            end
            A.specs = counts
            task.wait(3)
        end
    end)

    -- ---------- the whitelist ----------
    local function wanted()                            -- the buy order: slot 1, 2, 3 … (a repeated item = bought more often)
        local out = {}
        for k = 1, SLOTS do
            local v = getv(UIE.slots and UIE.slots[k], DEFAULT_ITEMS[k] or NONE)
            if type(v) == "table" then v = v[1] end
            v = trim(v)
            if v ~= "" and v ~= NONE then
                local real = isHalloween(v)
                if real then
                    table.insert(out, real)
                elseif NOT_FOR_SALE[norm(v)] and not S.warned then
                    S.warned = true
                    notify(v .. ": " .. NOT_FOR_SALE[norm(v)] .. " — not bought", "Warning")
                end
            end
        end
        return out
    end

    -- ---------- Jack's dialogue ----------
    local function optionText(btn)
        local parts = {}
        local function add(o)
            if (o:IsA("TextLabel") or o:IsA("TextButton")) and tostring(o.Text or "") ~= "" then table.insert(parts, tostring(o.Text)) end
        end
        add(btn)
        local holder = btn.Parent and btn.Parent.Name:match("^Option%d+$") and btn.Parent or btn
        for _, d in ipairs(holder:GetDescendants()) do if d ~= btn then add(d) end end
        return trim(table.concat(parts, " "))
    end
    local function options(gui)
        local out = {}
        for i = 1, 12 do
            local b = Gui.option(gui, "Option" .. i)
            if b and Gui.isVisible(b) then table.insert(out, { btn = b, text = optionText(b), name = "Option" .. i }) end
        end
        return out
    end
    -- Jack's line in words (the game draws every letter as its own label: only the word labels are read)
    local function jackSaid(gui)
        local ok, text = pcall(function()
            local words = {}
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextLabel") and d.Name:match("^Group%d+$") and Gui.isVisible(d) then
                    table.insert(words, { d:GetFullName(), tostring(d.Text or "") })
                end
            end
            if #words == 0 then return nil end
            table.sort(words, function(a, b) return a[1] < b[1] end)
            local out = {}
            for _, w in ipairs(words) do table.insert(out, w[2]) end
            return (table.concat(out, " "):gsub("%s+", " "))
        end)
        if ok and text then return trim(text) end
        return trim(Gui.dialogueText(gui))
    end
    local function readPoints(gui)
        local t = jackSaid(gui):lower():gsub(",", "")
        return tonumber(t:match("have%s+(%d+)%s+points?"))
    end
    local function waitOptions(timeout, log, prev)       -- waits for NEW options (the old ones stay for a moment)
        local t0, lastSaid = tick(), nil
        while tick() - t0 < timeout do
            local gui = Gui.currentDialogue()
            if not gui then return nil, {} end
            local said = jackSaid(gui)
            if log and said ~= "" and said ~= lastSaid then lastSaid = said table.insert(log, "  Jack: «" .. said:sub(1, 160) .. "»") end
            local opts = options(gui)
            local sig = {}
            for _, o in ipairs(opts) do table.insert(sig, o.text) end
            sig = table.concat(sig, "|")
            if #opts > 0 and sig ~= prev then
                if log then table.insert(log, "  options: " .. sig) end
                return gui, opts, sig
            end
            if #opts == 0 then Gui.skipClick() end       -- Jack is still talking → next line
            task.wait(0.2)
        end
        return Gui.currentDialogue(), {}, prev
    end
    local function openJack()
        local character = LP.Character
        local remote = character and character:FindFirstChild("RemoteEvent")
        local folder = ReplicatedStorage:FindFirstChild("Dialogue")
        local template = folder and folder:FindFirstChild("Halloween Event")
        if not remote or not template then return false, "Jack's dialogue is unavailable (is the event on?)" end
        remote:FireServer("PromptTriggered", template)
        if not Gui.waitDialogue(4) then return false, "Jack's dialogue did not open" end
        return true
    end
    local function idle()
        return not (A.delivering or A.trading or State.Selling or Halloween.TurnInBusy
            or State.HalloweenTurnInBusy or Gui.currentDialogue())
    end
    local function saveLog(lines, title)
        pcall(function()
            writefile("chopa_jack_menu.txt", os.date("%Y-%m-%d %H:%M:%S") .. " " .. title .. "\n" .. table.concat(lines, "\n") .. "\n")
        end)
        for _, l in ipairs(lines) do print("[Chopa Jack] " .. l) end
    end
    -- Jack → «I want to use my points!» → category `cat` (nil = stop at the category list)
    local function goTo(cat, log)
        pcall(Gui.forceCloseDialogue, 2)
        local ok, msg = openJack()
        if not ok then return nil, msg end
        local gui, opts, sig = waitOptions(6, log)
        if not gui or #opts == 0 then return nil, "Jack shows no options" end
        local use
        for _, o in ipairs(opts) do
            if o.text:lower():find("points", 1, true) and not has(o.text, AVOID) then use = o break end
        end
        if not use then return nil, "no «I want to use my points!» option" end
        table.insert(log, "  → «" .. use.text .. "»")
        Gui.click(use.btn)
        gui, opts, sig = waitOptions(6, log, sig)
        if not gui or #opts == 0 then return nil, "Jack's menu closed" end
        if not cat then return gui, opts end
        local c
        for _, o in ipairs(opts) do if norm(o.text) == norm(cat) then c = o break end end
        if not c then return nil, "no category «" .. cat .. "»" end
        table.insert(log, "  → «" .. c.text .. "»")
        Gui.click(c.btn)
        gui, opts = waitOptions(6, log, sig)
        if not gui or #opts == 0 then return nil, "«" .. cat .. "» shows nothing" end
        return gui, opts
    end
    local function points()
        local c = tonumber(Halloween.CachedJackPoints)  -- the turn-in code reads «you now have N points»
        if c and Halloween.CachedJackPoints ~= S.cacheSeen then
            S.cacheSeen = Halloween.CachedJackPoints
            S.points, S.pointsAt = c, tick()
        end
        local turnIn = Halloween.LastTurnInAt or 0
        if turnIn > (S.turnInSeen or 0) then           -- candy turned in: the points grew
            S.turnInSeen, S.nextTry, S.errs = turnIn, 0, 0
            if S.pointsAt < turnIn - 5 then S.turnInWait = turnIn end
        end
        if S.turnInWait and S.pointsAt >= S.turnInWait - 5 then S.turnInWait = nil end
        if S.turnInWait and tick() - S.turnInWait > 15 then
            -- Jack's answer was not readable: the number is unknown now → ONE visit reads it
            S.turnInWait, S.points, S.check = nil, nil, true
        end
        return S.points
    end
    local function priceFor(item) return S.price[norm(item)] or JACK_PRICE[norm(item)] end
    local function readOrderIdx()
        local n = 1
        pcall(function() if isfile and isfile(ORDER_FILE) then n = tonumber(readfile(ORDER_FILE)) or 1 end end)
        return math.max(1, math.floor(n))
    end
    S.idx = readOrderIdx()                             -- the place in the buy order survives a rejoin
    local function nextItem()
        local list = wanted()
        if #list == 0 then return nil end
        return list[(S.idx - 1) % #list + 1]
    end
    local function advance()
        S.idx += 1
        pcall(function() if writefile then writefile(ORDER_FILE, tostring(S.idx)) end end)
    end
    -- Jack's words are read whenever his window is open (a turn-in by hand too) → the points stay known
    task.spawn(function()
        while true do
            task.wait(0.3)
            pcall(function()
                local gui = Gui.currentDialogue()
                if gui then
                    local p = readPoints(gui)
                    if p and p ~= S.lastSaidPoints then S.lastSaidPoints, S.points, S.pointsAt = p, p, tick() S.check = false end
                elseif S.lastSaidPoints then
                    S.lastSaidPoints = nil
                end
            end)
        end
    end)

    -- ---------- reading Jack's shop (buys nothing: only «use my points» and the categories are clicked) ----------
    local function readShop()
        if S.busy then return nil, "busy" end
        S.busy, State.HalloweenTurnInBusy = true, true
        local log, shop = {}, {}
        local ok, err = pcall(function()
            local gui, opts = goTo(nil, log)
            if not gui then error(opts) end
            local cats = {}
            for _, o in ipairs(opts) do if not has(o.text, AVOID) then table.insert(cats, o.text) end end
            for _, cat in ipairs(cats) do
                local g, items = goTo(cat, log)
                if g then
                    local p = readPoints(g)
                    if p then S.points, S.pointsAt = p, tick() end
                    local names = {}
                    for _, o in ipairs(items) do
                        if not has(o.text, AVOID) then
                            local n = cleanName(o.text)
                            if n ~= "" then
                                table.insert(names, n)
                                S.price[norm(n)] = priceOf(o.text) or S.price[norm(n)]
                            end
                        end
                    end
                    table.insert(shop, { cat = cat, items = names })
                end
            end
        end)
        pcall(Gui.forceCloseDialogue, 2)
        S.busy, State.HalloweenTurnInBusy = false, false
        local summary = {}
        for _, c in ipairs(shop) do table.insert(summary, c.cat .. ": " .. table.concat(c.items, ", ")) end
        saveLog(log, "read Jack's shop → " .. (#shop > 0 and table.concat(summary, " | ") or tostring(err)))
        if #shop == 0 then return nil, ok and "nothing was read" or tostring(err) end
        pcall(function() writefile(CACHE, HttpService:JSONEncode({ shop = shop, at = os.time(), by = LP.Name })) end)
        return shop
    end

    -- ---------- buying one item ----------
    local function buyOne(item)
        if S.busy then return false, "busy" end
        local cat, name = categoryOf(item)
        if not cat then return false, "«" .. item .. "» is not in Jack's shop — press «Read Jack's shop»" end
        S.busy, State.HalloweenTurnInBusy = true, true
        local log = {}
        local ok, res, info = pcall(function()
            local gui, opts = goTo(cat, log)
            if not gui then return "error", opts end
            local p = readPoints(gui)
            if p then S.points, S.pointsAt = p, tick() end
            local opt
            for _, o in ipairs(opts) do if norm(cleanName(o.text)) == norm(name) then opt = o break end end
            if not opt then return "notfound", "«" .. name .. "» is not in «" .. cat .. "»" end
            local price = priceOf(opt.text)
            if price then S.price[norm(name)] = price end
            if p and price and p < price then return "nomoney", p .. " points < " .. price end
            local before = bagCount(name)
            local arrow = norm(name) == "luckyarrow"
            if arrow then A.boughtUncounted = (A.boughtUncounted or 0) + 1 end   -- bought, not picked up
            table.insert(log, string.format("  → BUY «%s» (points %s, price %s, had %d)", opt.text, tostring(p), tostring(price), before))
            A.jackBuy = { key = norm(name), at = tick() }      -- the webhook does not report it as «picked up»
            Gui.click(opt.btn)
            local t0, lastSaid = tick(), nil
            while tick() - t0 < 8 do
                if bagCount(name) > before then A.jackBuy.at = tick() return "done", price end
                local g = Gui.currentDialogue()
                if g then
                    local said = jackSaid(g)
                    if said ~= "" and said ~= lastSaid then lastSaid = said table.insert(log, "  Jack: «" .. said:sub(1, 160) .. "»") end
                end
                task.wait(0.2)
            end
            if arrow then A.boughtUncounted = math.max(0, (A.boughtUncounted or 1) - 1) end
            if has(table.concat(log, " "), NO_MONEY) then return "nomoney", "Jack: not enough points" end
            return "nothing", "«" .. name .. "» did not appear in the backpack"
        end)
        pcall(Gui.forceCloseDialogue, 3)
        S.busy, State.HalloweenTurnInBusy = false, false
        if not ok then saveLog({ tostring(res) }, "error") return false, "error: " .. tostring(res) end
        if res == "done" then
            if S.points and info then S.points = S.points - info end
            if norm(name) == norm(nextItem() or "") then advance() end
            S.last = name .. (info and (" (−" .. info .. " pts)") or "")
            if A.emit then pcall(A.emit, "spec_buy", { name = name, points = S.points, spent = info, have = bagCount(name) }) end
            return true, "Bought " .. name
        end
        saveLog(log, "buy " .. name .. " → " .. tostring(res) .. ": " .. tostring(info))
        if res == "nomoney" then return false, "nomoney" end
        if res == "notfound" and not S.reread then            -- the assortment changed: read it again, then retry
            S.reread = true
            if readShop() then return false, "retry" end
        end
        return false, "Could not buy " .. name .. ": " .. tostring(info)
    end

    -- ---------- the next item of the buy order, if the known points pay for it ----------
    -- Jack's window is opened ONLY when the bot knows it has enough points (or once, to read them, after a candy
    -- turn-in whose answer could not be read)
    local function candidates()
        local item = nextItem()
        if not item then return {} end
        local p, price = points(), priceFor(item)
        if p and price and p >= price then return { item } end
        if p == nil and S.check then return { item } end
        return {}
    end
    -- Auto buy works whether the farm is on or off (the farm keeps running).
    -- While Jack's points can still buy a ticked item, autosell waits (State.JackHold);
    -- when the points run out, autosell goes on as usual.
    local function waitIdle(timeout)
        local t0, dlgSince = tick(), nil
        while tick() - t0 < timeout do
            if getv(UIE.auto, false) ~= true then return false end
            if idle() then return true end
            local blockedByDialogue = Gui.currentDialogue() and not (A.delivering or A.trading or State.Selling
                or Halloween.TurnInBusy or State.HalloweenTurnInBusy)
            if blockedByDialogue then
                dlgSince = dlgSince or tick()
                if tick() - dlgSince > 20 then pcall(Gui.forceCloseDialogue, 2) dlgSince = nil end   -- a stuck window
            else
                dlgSince = nil
            end
            task.wait(0.3)
        end
        return idle()
    end
    task.spawn(function()
        while true do
            task.wait(2)
            local okLoop, errLoop = pcall(function()
                local keep = {}                       -- autosell never sells the items ticked for FunPay
                for _, n in ipairs(wanted()) do keep[norm(n)] = true end
                A.keepJack = keep
                local on = getv(UIE.auto, false) == true
                local item = on and tick() >= S.nextTry and candidates()[1] or nil
                State.JackHold = item ~= nil and not S.busy
                if item and waitIdle(45) then
                    local ok, why = buyOne(item)
                    if ok then
                        S.fail, S.errs = {}, 0
                        notify(why, "Success")
                    elseif why == "nomoney" then
                        S.check = false               -- the real points were read in the window
                    elseif why ~= "retry" and why ~= "busy" then
                        S.errs = (S.errs or 0) + 1         -- 1, 2, 4 … 10 min: a broken shop does not keep pausing autosell
                        S.nextTry = tick() + math.min(600, 60 * 2 ^ (S.errs - 1))
                        notify(why, "Warning")
                    end
                    if not candidates()[1] then
                        State.JackHold = false
                        notify("Jack's points are spent — autosell is on again", "Info")
                    end
                end
            end)
            if not okLoop then                    -- an error must never leave autosell paused for good
                State.JackHold = false
                warn("[Chopa Jack] auto buy: " .. tostring(errLoop))
            end
        end
    end)

    -- ---------- UI: «Halloween Event» tab (the options are part of the config) ----------
    -- the flags keep the path they had on Auto-Farm, so configs saved before still load
    local htab = adaptTab(Window.Raw:Tab({ Name = "Halloween Event", Icon = "ghost",
        Desc = "Buy spec skins from Jack for candy points → FunPay" }), "ItemFarmSH")
    _G.__ChopaHalloweenTab = htab
    -- candy → points: the old Halloween tab is hidden, so its switches could never be changed (a new user had
    -- no candy turn-in at all → no points for Jack). The same switches are here, saved in the config.
    pcall(function()
        local candy = htab:Section({ Title = "Candy", Side = "right" })
        candy:Toggle({ Title = "Auto Collect Candies", Value = false,
            Desc = "Picks up Halloween candy (also works together with the item farm)",
            Callback = function(state)
                State.HalloweenCandyFarm = state == true
                if State.HalloweenCandyFarm then
                    State.NoClip = true
                    pcall(ItemESP.scan)
                elseif not State.Farm then
                    State.NoClip = false
                end
            end })
        candy:Toggle({ Title = "Auto Turn In Candies", Value = true,
            Desc = "Gives the candy to Jack for points when you have the amount below",
            Callback = function(state) Halloween.AutoTurnIn = state == true end })
        candy:Slider({ Title = "Turn in at, candies", Desc = "Max 45 candies fit in the inventory",
            Value = { Min = 1, Max = 45, Default = 20 }, Step = 1,
            Callback = function(v) Halloween.TurnInThreshold = math.clamp(math.floor(tonumber(v) or 20), 1, 45) end })
        candy:Button({ Title = "Turn In Candies Now", Desc = "Gives all your candy to Jack now", Callback = function()
            task.spawn(function()
                local ok, msg = turnInHalloweenCandies()
                notify(tostring(msg), ok and "Success" or "Warning")
            end)
        end })
        local cinfo = candy:Paragraph({ Title = "Candy", Desc = "Checking…" })
        task.spawn(function()
            while true do
                pcall(function()
                    cinfo:SetDesc(string.format("%d / 45 candies · turn in at %d · auto turn-in %s",
                        Halloween.countCandies(), math.clamp(tonumber(Halloween.TurnInThreshold) or 20, 1, 45),
                        Halloween.AutoTurnIn and "on" or "off"))
                end)
                task.wait(3)
            end
        end)
    end)
    local section = htab:Section({ Title = "Jack's shop → FunPay", Side = "left" })
    local info = section:Paragraph({ Title = "Jack's shop", Desc = "Checking…" })
    UIE.auto = section:Toggle({ Title = "Auto buy from Jack", KeepDefault = true, Value = false,
        Desc = "Buys the items of the buy order in turn. Jack is opened only when you have enough points. "
            .. "Works with or without the farm; autosell waits until the points are spent" })
    UIE.slots = {}
    local choices = { NONE }
    for _, n in ipairs(allItems()) do table.insert(choices, n) end
    local ORD = { "1st", "2nd", "3rd", "4th", "5th", "6th" }
    for k = 1, SLOTS do
        UIE.slots[k] = section:Dropdown({ Title = "Buy " .. ORD[k], Values = choices, Value = DEFAULT_ITEMS[k] or NONE,
            Desc = k == 1 and "Buy order: 1st → 2nd → … → 1st again. «—» = empty. Halloween items only" or nil })
    end
    section:Button({ Title = "Buy one now", Desc = "Buys the next item of the buy order (also reads your points)", Callback = function()
        task.spawn(function()
            if not idle() then notify("Wait: the bot is busy (order / selling / dialogue)", "Warning") return end
            S.nextTry = 0                                -- by hand: Jack is opened even if the points are unknown
            local item = nextItem()
            if not item then notify("Choose items in «Buy 1st…6th»", "Warning") return end
            local p, price = points(), priceFor(item)
            if p and price and p < price then notify(item .. " costs " .. price .. " points, you have " .. p, "Warning") return end
            local ok, why = buyOne(item)
            notify(why == "nomoney" and ("Not enough points for " .. item) or why, ok and "Success" or "Warning")
        end)
    end })
    task.spawn(function()
        while true do
            local parts, seenP = {}, {}
            for _, n in ipairs(wanted()) do
                if not seenP[norm(n)] then seenP[norm(n)] = true table.insert(parts, n .. ": " .. bagCount(n)) end
            end
            local nx, p = nextItem(), points()
            local price = nx and priceFor(nx)
            local state
            if not nx then state = "choose items in «Buy 1st…6th»"
            elseif p == nil then state = "points unknown — turn in candy or press «Buy one now»"
            elseif price and p < price then state = "waiting: " .. nx .. " needs " .. price .. " points"
            else state = "next: " .. nx .. (price and (" (" .. price .. " pts)") or "") end
            pcall(function()
                info:SetDesc((#parts > 0 and (table.concat(parts, " · ") .. "\n") or "") ..
                    "Points: " .. tostring(p or "?") .. " · " .. state .. " · last bought: " .. S.last ..
                    (State.JackHold and "\nAutosell paused: spending points" or ""))
            end)
            task.wait(3)
        end
    end)
end)

-- ================= CHOPA: DISCORD WEBHOOK =================
-- Auto-Farm → Discord Webhook. The user pastes his own webhook link; events (whitelisted items picked up,
-- Lucky Arrow bought, order delivered) and a periodic report (farmed money, balance, Lucky Arrows) go to his
-- Discord channel. All its settings are normal config options (saved with «Save» in Configurations).
-- Runs in task.spawn: adds no locals to the main chunk and an error here never stops the script.
task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local A = _G.__ChopaAgent or {}
    local LEGACY = "chopa_webhook.json"                 -- settings file of the first version → moved into the config
    local W = {
        queue = {}, pick = nil, bought = nil, warned = false, items = { ["Lucky Arrow"] = true },
        farmed = 0, picked = 0, pickedOther = 0, lastMoney = nil, startedAt = os.time(), periodStart = os.time(),
    }
    local D = { url = "", pickup = true, buy = true, delivery = true, stats = true, interval = 60, items = { "Lucky Arrow" },
        paid = true, specbuy = true }
    pcall(function()
        if isfile and isfile(LEGACY) then
            local saved = HttpService:JSONDecode(readfile(LEGACY))
            if type(saved) == "table" then
                for _, k in ipairs({ "url", "pickup", "buy", "delivery", "stats", "interval" }) do
                    if saved[k] ~= nil then D[k] = saved[k] end
                end
            end
        end
    end)
    D.interval = math.clamp(tonumber(D.interval) or 60, 15, 180)
    local UIE = {}                                     -- the settings controls: their current values are the settings
    local function getv(obj, fallback)
        if not obj then return fallback end
        local ok, v = pcall(function()
            if obj.Raw and type(obj.Raw.Get) == "function" then return obj.Raw:Get() end
            if type(obj.Get) == "function" then return obj:Get() end
            return obj.Value
        end)
        if ok and v ~= nil then return v end
        return fallback
    end
    local function validUrl(u)
        u = tostring(u or "")
        return u:match("^https://discord%.com/api/webhooks/%d+/[%w%-_]+$")
            or u:match("^https://discordapp%.com/api/webhooks/%d+/[%w%-_]+$")
            or u:match("^https://canary%.discord%.com/api/webhooks/%d+/[%w%-_]+$")
            or u:match("^https://ptb%.discord%.com/api/webhooks/%d+/[%w%-_]+$")
    end
    local function trim(s) return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")) end
    -- the link is read from the text box every time (a loaded config changes the box without a callback)
    local function url()
        local u = trim(getv(UIE.url, D.url))
        return validUrl(u) and u or nil
    end
    local function on(key) return getv(UIE[key], D[key]) == true end
    local function interval() return math.clamp(tonumber(getv(UIE.interval, D.interval)) or 60, 15, 180) end
    local function wanted(name)
        if not on("pickup") then return false end
        local list = getv(UIE.items, nil)
        if type(list) == "table" then
            for _, n in ipairs(list) do if n == name then return true end end
            return false
        end
        return W.items[name] == true
    end
    local function notify(title, text, kind)
        pcall(function() AirflowCompat:Notify({ Title = title, Content = text, Type = kind or "Info", Duration = 5 }) end)
    end
    local function money(n)
        local s = tostring(math.floor(tonumber(n) or 0))
        local neg = s:sub(1, 1) == "-"
        if neg then s = s:sub(2) end
        s = s:reverse():gsub("(%d%d%d)", "%1 "):reverse():gsub("^ ", "")
        return (neg and "-$" or "$") .. s
    end
    local function dur(sec)
        sec = math.max(0, math.floor(sec))
        local h, m = math.floor(sec / 3600), math.floor(sec % 3600 / 60)
        return h > 0 and string.format("%d ч %d мин", h, m) or string.format("%d мин", m)
    end
    local function luckyNow()
        local ls = A.luckyStats
        if ls and ls.count then return ls.count end
        local ok, n = pcall(function() return A.countLucky and A.countLucky() end)
        return ok and n or nil
    end
    local function balance()
        local ok, m = pcall(function() return A.getMoney and A.getMoney() end)
        return ok and m or nil
    end

    -- ---------- sending (one message every 1.5 s, Discord rate limit respected) ----------
    local function httpRequest()
        return (syn and syn.request) or (http and http.request) or http_request or request
            or (fluxus and fluxus.request)
    end
    local function push(embed)
        if not url() then return end
        embed.footer = { text = "Chopa · @" .. LP.Name }
        embed.timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        table.insert(W.queue, embed)
        while #W.queue > 30 do table.remove(W.queue, 1) end
    end
    local function post(embed)
        local req, target = httpRequest(), url()
        if not target then return true end
        if not req then
            if not W.warned then
                W.warned = true
                notify("Discord Webhook", "Your executor can't send HTTP requests — webhooks are off", "Warning")
            end
            return true
        end
        local ok, res = pcall(req, {
            Url = target, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ username = "Chopa", embeds = { embed } }),
        })
        if not ok or type(res) ~= "table" then return true end
        local code = tonumber(res.StatusCode) or 0
        if code == 429 then
            local wait = 2
            pcall(function() wait = tonumber(HttpService:JSONDecode(res.Body).retry_after) or 2 end)
            if wait > 100 then wait = wait / 1000 end           -- old API answered in ms
            task.wait(math.clamp(wait, 1, 30))
            return false                                         -- try this message again
        end
        if code == 401 or code == 404 then
            notify("Discord Webhook", "Webhook link is wrong or was deleted (HTTP " .. code .. ")", "Error")
        end
        return true
    end
    task.spawn(function()
        while true do
            if #W.queue > 0 and url() then
                if post(W.queue[1]) then table.remove(W.queue, 1) end
                task.wait(1.5)
            else
                task.wait(0.5)
            end
        end
    end)

    -- ---------- events ----------
    local GREEN, BLUE, GOLD, PURPLE = 0x34D399, 0x5B8CFF, 0xF5A524, 0x7C6CFF
    local function picked(name, n)
        if name == "Lucky Arrow" then W.picked += n else W.pickedOther += n end
        if not wanted(name) then return end
        W.pick = W.pick or { items = {}, order = {}, at = tick() }
        if not W.pick.items[name] then table.insert(W.pick.order, name) end
        W.pick.items[name] = (W.pick.items[name] or 0) + n
    end
    local prevEmit = A.emit
    A.emit = function(kind, data)
        if prevEmit then pcall(prevEmit, kind, data) end
        data = data or {}
        if kind == "pickup" then                         -- Lucky Arrow (shop purchases already excluded)
            picked("Lucky Arrow", data.n or 1)
        elseif kind == "buy" and on("buy") then
            W.bought = W.bought or { n = 0, at = tick() }
            W.bought.n += data.n or 1
            W.bought.have, W.bought.money = data.have, data.money
        elseif kind == "trade" and on("delivery") then
            push({ title = "📦 Выдача заказа #" .. tostring(data.order),
                description = string.format("**%d × %s** переданы трейдом → **%s**", data.n or 0,
                    tostring(data.item or "Lucky Arrow"), tostring(data.buyer)),
                color = PURPLE })
        elseif kind == "paid" and on("paid") then
            local test = tostring(data.order):match("^TEST_") ~= nil
            local item = tostring(data.item or "Lucky Arrow")
            local how = {}
            if (tonumber(data.trade) or 0) > 0 then table.insert(how, data.trade .. " трейдом") end
            if (tonumber(data.money) or 0) > 0 then table.insert(how, money(data.money) .. " деньгами") end
            push({ title = (test and "🧪 Тестовый заказ #" or "💰 Оплачен заказ #") .. tostring(data.order),
                description = string.format("**%s × %s**%s", tostring(data.count or data.trade or "?"), item,
                    #how > 0 and ("\nВыдача: " .. table.concat(how, " + ")) or ""),
                color = GOLD, fields = { { name = "Бот", value = "@" .. LP.Name, inline = true },
                    { name = "Покупатель", value = (data.buyer and data.buyer ~= "") and tostring(data.buyer) or "ник ещё не указан",
                      inline = true } } })
        elseif kind == "spec_buy" and on("specbuy") then
            push({ title = "🎃 Куплен скин у Джека: " .. tostring(data.name), color = 0xFF7A1A,
                description = data.spent and ("Потрачено **" .. tostring(data.spent) .. "** очков") or nil,
                fields = { { name = "Таких скинов у бота", value = tostring(data.have or "?"), inline = true },
                    { name = "Осталось очков", value = tostring(data.points or "?"), inline = true } } })
        elseif kind == "drop" and on("delivery") then
            push({ title = "💵 Выдача заказа #" .. tostring(data.order),
                description = string.format("Выброшено **%s** → **%s**", money(data.amount), tostring(data.buyer)),
                color = PURPLE, fields = { { name = "Баланс", value = money(balance()), inline = true } } })
        end
    end
    -- other items: counted in the backpack (Lucky Arrow comes from the bot's own counter above)
    local KNOWN = {}
    for name in pairs(ESP_ITEMS or {}) do KNOWN[trim(name):lower()] = name end
    local function countItems()
        local c = {}
        for _, cont in ipairs({ LP:FindFirstChild("Backpack"), LP.Character }) do
            if cont then
                for _, t in ipairs(cont:GetChildren()) do
                    local name = t:IsA("Tool") and KNOWN[trim(t.Name):lower()]
                    if name then c[name] = (c[name] or 0) + 1 end
                end
            end
        end
        return c
    end
    task.spawn(function()
        repeat task.wait(1) until LP:FindFirstChild("Backpack") and LP.Character
        task.wait(3)
        local last, lastChar = countItems(), LP.Character
        while true do
            task.wait(1)
            if LP.Character ~= lastChar then             -- respawn: the backpack is rebuilt, nothing was picked up
                lastChar = LP.Character
                task.wait(3)
                last = countItems()
            else
                local now = countItems()
                local jb = A.jackBuy
                for name, n in pairs(now) do
                    local gain = n - (last[name] or 0)
                    local bought = jb and tick() - jb.at < 6 and jb.key == (name:lower():gsub("[^%w]", ""))
                    if gain > 0 and name ~= "Lucky Arrow" and not bought then picked(name, gain) end
                end
                last = now
            end
        end
    end)
    -- pickups / purchases a few seconds apart go out as one message
    task.spawn(function()
        while true do
            task.wait(2)
            if W.pick and tick() - W.pick.at >= 8 then
                local p = W.pick; W.pick = nil
                local fields = { { name = "Lucky Arrow в инвентаре", value = tostring(luckyNow() or "?"), inline = true } }
                if #p.order == 1 and p.order[1] == "Lucky Arrow" then
                    local n = p.items["Lucky Arrow"]
                    table.insert(fields, { name = "Lucky за сессию", value = tostring(A.luckyStats and A.luckyStats.session or "?"), inline = true })
                    push({ title = "🍀 Подобрана Lucky Arrow" .. (n > 1 and (" ×" .. n) or ""), color = GREEN, fields = fields })
                else
                    local lines = {}
                    for _, name in ipairs(p.order) do
                        table.insert(lines, "• **" .. name .. "**" .. (p.items[name] > 1 and (" ×" .. p.items[name]) or ""))
                    end
                    push({ title = "🎒 Подобраны предметы", description = table.concat(lines, "\n"), color = GREEN, fields = fields })
                end
            end
            if W.bought and tick() - W.bought.at >= 8 then
                local b = W.bought; W.bought = nil
                push({ title = "🛒 Куплена Lucky Arrow" .. (b.n > 1 and (" ×" .. b.n) or ""),
                    description = "Потрачено **" .. money(b.n * 75000) .. "**", color = BLUE, fields = {
                        { name = "В инвентаре", value = tostring(b.have or luckyNow() or "?"), inline = true },
                        { name = "Баланс", value = money(b.money or balance()), inline = true } } })
            end
        end
    end)

    -- ---------- farm counter + periodic report ----------
    task.spawn(function()                 -- every rise of the balance = farmed (purchases / deliveries only lower it)
        while true do
            task.wait(5)
            local m = balance()
            if m == nil then
                W.lastMoney = nil          -- unknown (rejoin): no fake jump when it comes back
            else
                if W.lastMoney and m > W.lastMoney and m - W.lastMoney <= 2000000 then
                    W.farmed += m - W.lastMoney
                end
                W.lastMoney = m
            end
        end
    end)
    local function sendStats()
        local period = os.time() - W.periodStart
        local perHour = period > 60 and math.floor(W.farmed * 3600 / period) or W.farmed
        push({ title = "📊 Статистика · @" .. LP.Name, color = GOLD,
            description = "За последние **" .. dur(period) .. "**",
            fields = {
                { name = "Нафармлено", value = money(W.farmed), inline = true },
                { name = "В среднем за час", value = money(perHour), inline = true },
                { name = "Баланс", value = money(balance()), inline = true },
                { name = "Lucky Arrow в инвентаре", value = tostring(luckyNow() or "?"), inline = true },
                { name = "Подобрано Lucky", value = tostring(W.picked), inline = true },
                { name = "Другие предметы", value = tostring(W.pickedOther), inline = true },
                { name = "Онлайн", value = dur(os.time() - W.startedAt), inline = true },
            } })
        W.farmed, W.picked, W.pickedOther, W.periodStart = 0, 0, 0, os.time()
    end
    task.spawn(function()
        while true do
            task.wait(10)
            if on("stats") and url() and os.time() - W.periodStart >= interval() * 60 then sendStats() end
        end
    end)

    -- ---------- settings UI: Settings tab (config options: Save in Configurations keeps them) ----------
    local function buildUI(settingsTab)
    local section = settingsTab:Section({ Title = "Discord Webhook", Side = "right" })
    section:Paragraph({ Title = "Discord Webhook",
        Desc = "Paste your webhook link (Discord channel → Edit → Integrations → Webhooks → Copy URL). "
            .. "These options are part of the config — press Save in Configurations to keep them." })
    UIE.url = section:Input({
        Title = "Webhook URL", Desc = "https://discord.com/api/webhooks/…", Placeholder = "https://discord.com/api/webhooks/...",
        Value = D.url,
        Callback = function(v)
            v = trim(v)
            if v ~= "" and not validUrl(v) then notify("Discord Webhook", "This is not a Discord webhook link", "Warning")
            elseif v ~= "" then notify("Discord Webhook", "Webhook set — press Save in Configurations to keep it", "Success") end
        end,
    })
    local function toggle(key, title, desc)
        UIE[key] = section:Toggle({ Title = title, Desc = desc, Value = D[key] == true, KeepDefault = true })
    end
    toggle("pickup", "Item picked up", "Message when the bot picks up an item from the list below")
    local options = {}
    for name in pairs(ESP_ITEMS or {}) do if name ~= "Lucky Arrow" then table.insert(options, name) end end
    table.sort(options)
    table.insert(options, 1, "Lucky Arrow")
    UIE.items = section:Dropdown({
        Title = "Items to send", Desc = "Whitelist: only these items are sent to Discord",
        Values = options, Value = D.items, Multi = true,
        Callback = function(list)
            W.items = {}
            for _, n in ipairs(type(list) == "table" and list or {}) do W.items[n] = true end
        end,
    })
    toggle("paid", "Order paid", "Message when a FunPay order is paid and given to this bot")
    toggle("buy", "Lucky Arrow bought", "Message when auto buy buys a Lucky Arrow in the shop")
    toggle("specbuy", "Spec skin bought", "Message when the bot buys a spec skin from Jack")
    toggle("delivery", "Order delivered", "Message when the bot gives an order to a buyer (trade / money)")
    toggle("stats", "Farm report", "Farmed money, balance and Lucky Arrows every N minutes")
    UIE.interval = section:Slider({ Title = "Report every, min", Desc = "How often the farm report is sent",
        Value = { Min = 15, Max = 180, Default = D.interval }, Step = 15 })
    section:Button({ Title = "Send test message", Desc = "Checks the link", Callback = function()
        if not url() then notify("Discord Webhook", "Paste a webhook link first", "Warning") return end
        push({ title = "✅ Вебхук подключён", description = "Бот **@" .. LP.Name .. "** будет присылать сюда уведомления.",
            color = GREEN, fields = { { name = "Баланс", value = money(balance()), inline = true },
                { name = "Lucky Arrow", value = tostring(luckyNow() or "?"), inline = true } } })
        notify("Discord Webhook", "Test message sent", "Success")
    end })
    section:Button({ Title = "Send report now", Desc = "Farm report for the time since the last one",
        Callback = function()
            if not url() then notify("Discord Webhook", "Paste a webhook link first", "Warning") return end
            sendStats()
        end })
    end
    if _G.__ChopaSettingsTab and _G.__ChopaSettingsWin == (Window and Window.Raw) then pcall(buildUI, _G.__ChopaSettingsTab)
    else _G.__ChopaWebhookUI = buildUI end

    -- the old settings file is not needed once a config with these options has been saved
    pcall(function()
        local raw = Window and Window.Raw
        if not (raw and isfile and isfile(LEGACY)) then return end
        local save = raw.SaveConfig
        raw.SaveConfig = function(self, ...)
            local a, b = save(self, ...)
            if a and isfile(LEGACY) and type(delfile) == "function" then pcall(delfile, LEGACY) end
            return a, b
        end
    end)
end)

local InfoTab = Window:Tab({Title = "Info", Icon = "layout-dashboard", Desc = "Script status and help."})
InfoTab:Header("CHOPA  /  CONTROL CENTER")
InfoTab:Paragraph({
    Title = "Script Dashboard",
    Desc = "Check what is working, or copy the status if you need help.",
})

do
    local previousDashboard = _G.__MethionInfoDashboard
    local dashboardToken = (previousDashboard and tonumber(previousDashboard.Token) or 0) + 1
    local dashboard = {Token = dashboardToken, Labels = {}}
    _G.__MethionInfoDashboard = dashboard

    local sessionSection = InfoTab:Section({Title = "Session Overview", Side = "left"})
    local systemsSection = InfoTab:Section({Title = "Feature Status", Side = "right"})
    local diagnosticsSection = InfoTab:Section({Title = "Status Check", Side = "left"})
    local helpSection = InfoTab:Section({Title = "Troubleshooting", Side = "right"})
    local aboutSection = InfoTab:Section({Title = "About Chopa", Side = "right"})

    local function addInfoLabel(section, key, title, initial)
        dashboard.Labels[key] = section:Paragraph({Title = title, Desc = initial or "Checking..."})
    end

    local lastInfo = {}
    local function setInfoLabel(key, value)
        local label = dashboard.Labels[key]
        local text = tostring(value)
        if lastInfo[key] == text then return end
        lastInfo[key] = text
        if label and type(label.SetDesc) == "function" then
            pcall(function() label:SetDesc(text) end)
        end
    end

    local function onOff(value)
        return value and "Enabled" or "Disabled"
    end

    local function questFarmEnabled()
        local enabled = _G.QuestFarmEnabled == true or _G.NPCFarmEnabled == true
        pcall(function()
            if type(getgenv) == "function" then
                local env = getgenv()
                if type(env) == "table" then
                    enabled = enabled or env.QuestFarmEnabled == true or env.NPCFarmEnabled == true
                end
            end
        end)
        pcall(function()
            if type(shared) == "table" then
                enabled = enabled or shared.QuestFarmEnabled == true or shared.NPCFarmEnabled == true
            end
        end)
        return enabled
    end

    addInfoLabel(sessionSection, "Player", "Player", "--")
    addInfoLabel(sessionSection, "DisplayName", "Display Name", "--")
    addInfoLabel(sessionSection, "Character", "Character", "--")
    addInfoLabel(sessionSection, "Health", "Health", "--")
    addInfoLabel(sessionSection, "Money", "Money", "--")
    addInfoLabel(sessionSection, "Place", "Place ID", "--")
    addInfoLabel(sessionSection, "Players", "Players in Server", "--")
    addInfoLabel(sessionSection, "Server", "Server Identifier", "--")

    addInfoLabel(systemsSection, "ItemESP", "Item ESP", "Checking...")
    addInfoLabel(systemsSection, "PlayerESP", "Player ESP", "Checking...")
    addInfoLabel(systemsSection, "ItemFarm", "Item Farm", "Checking...")
    addInfoLabel(systemsSection, "QuestFarm", "Quest Farm", "Checking...")
    addInfoLabel(systemsSection, "AutoRejoin", "Reload script on kick", "Checking...")
    addInfoLabel(systemsSection, "Selling", "Selling System", "Checking...")
    addInfoLabel(systemsSection, "Spectate", "Player Spectate", "Checking...")
    addInfoLabel(systemsSection, "LowGraphics", "Low Graphics", "Checking...")

    addInfoLabel(diagnosticsSection, "Library", "Interface", "Checking...")
    addInfoLabel(diagnosticsSection, "Hook", "Instant Mode Support", "Checking...")
    addInfoLabel(diagnosticsSection, "QuestModule", "Quest Farm", "Checking...")
    addInfoLabel(diagnosticsSection, "ItemScan", "Item Scan", "Checking...")
    addInfoLabel(diagnosticsSection, "Clipboard", "Clipboard Support", "Checking...")

    helpSection:Paragraph({
        Title = "Frequent Kicks or Unstable Movement",
        Desc = "Lower Tween Speed. If pickups fail, raise Instant Arrival Delay a little.",
    })
    helpSection:Paragraph({
        Title = "Items Not Highlighting",
        Desc = "Turn on Item ESP. If items still do not show, try Tween mode.",
    })
    helpSection:Paragraph({
        Title = "Dialogue Gets Stuck",
        Desc = "Let the current dialogue finish before starting another one. Avoid clicking options while farming or selling.",
    })
    helpSection:Paragraph({
        Title = "Some Features Not Working",
        Desc = "Some features may not work on every executor. Check the status above.",
    })

    aboutSection:Paragraph({Title = "Project", Desc = "Chopa (based on Methion SH)"})
    aboutSection:Paragraph({Title = "Version", Desc = "2"})
    aboutSection:Paragraph({Title = "Owner / Author", Desc = "Diablo"})
    aboutSection:Paragraph({Title = "Interface and Lua Work", Desc = "Diablo"})
    aboutSection:Paragraph({Title = "Credit", Desc = "redikXrbs."})

    function dashboard:Refresh()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local jobId = tostring(game.JobId or "")
        local shortJobId = jobId ~= "" and string.sub(jobId, 1, 8) or "Private session"
        local characterStatus = "Respawning"
        if character then
            characterStatus = humanoid and root and "Ready" or "Loading character"
        end

        setInfoLabel("Player", "@" .. tostring(LP.Name))
        setInfoLabel("DisplayName", tostring(LP.DisplayName or LP.Name))
        setInfoLabel("Character", characterStatus)
        setInfoLabel("Health", humanoid and (string.format("%.0f / %.0f HP", humanoid.Health, humanoid.MaxHealth)) or "Unavailable")
        setInfoLabel("Money", tostring(Utils.money()))
        setInfoLabel("Place", tostring(game.PlaceId))
        setInfoLabel("Players", tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers))
        setInfoLabel("Server", shortJobId)

        setInfoLabel("ItemESP", onOff(State.ItemEsp == true))
        setInfoLabel("PlayerESP", onOff(State.PlayerEsp == true))
        setInfoLabel("ItemFarm", onOff(State.Farm == true))
        setInfoLabel("QuestFarm", onOff(questFarmEnabled()))
        setInfoLabel("AutoRejoin", onOff(Config.AutoRejoinEnabled == true))
        setInfoLabel("Selling", State.Selling and "In progress" or "Idle")
        setInfoLabel("Spectate", onOff(State.Spectate == true))
        setInfoLabel("LowGraphics", onOff(State.LowGraphics == true))

        setInfoLabel("Library", type(AirflowLibrary) == "table" and "Loaded" or "Unavailable")
        setInfoLabel("Hook", "Not included (Chopa)")
        if _G.__PhantomQuestFarmLoaded == true then
            setInfoLabel("QuestModule", "Loaded")
        elseif _G.__PhantomQuestFarmLoadError ~= nil then
            setInfoLabel("QuestModule", "Load failed: " .. tostring(_G.__PhantomQuestFarmLoadError))
        else
            setInfoLabel("QuestModule", "Loading or unavailable")
        end
        setInfoLabel("ItemScan", tostring(ItemESP.count()) .. " tracked  |  " .. tostring(#Pending) .. " pending")
        setInfoLabel("Clipboard", type(setclipboard) == "function" and "Available" or "Not available here")
    end

    function dashboard:BuildSummary()
        self:Refresh()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local lines = {
            "Chopa diagnostics | based on Methion SH",
            "Player: @" .. tostring(LP.Name) .. " (" .. tostring(LP.DisplayName or LP.Name) .. ")",
            "Place ID: " .. tostring(game.PlaceId),
            "Server players: " .. tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers),
            "Character: " .. tostring(character and humanoid and "Ready" or "Not fully loaded"),
            "UI library: " .. tostring(type(AirflowLibrary) == "table" and "Loaded" or "Unavailable"),
            "Returner hook: not included (Chopa)",
            "Quest module: " .. tostring(_G.__PhantomQuestFarmLoaded == true and "Loaded" or (_G.__PhantomQuestFarmLoadError and "Load failed" or "Loading / unavailable")),
            "Tracked items: " .. tostring(ItemESP.count()),
            "Pending items: " .. tostring(#Pending),
            "Item ESP: " .. tostring(State.ItemEsp == true),
            "Player ESP: " .. tostring(State.PlayerEsp == true),
            "Item farm: " .. tostring(State.Farm == true),
            "Quest farm: " .. tostring(questFarmEnabled()),
            "Reload script on kick: " .. tostring(Config.AutoRejoinEnabled == true),
            "Selling: " .. tostring(State.Selling == true),
        }
        return table.concat(lines, "\n")
    end

    diagnosticsSection:Button({
        Title = "Refresh Status",
        Desc = "Refresh the status above.",
        Icon = "refresh-cw",
        Callback = function()
            local ok = pcall(function() dashboard:Refresh() end)
            AirflowCompat:Notify({
                Title = "Status",
                Content = ok and "Status refreshed." or "A diagnostic value could not be read.",
                Type = ok and "Success" or "Warning",
                Duration = 3,
            })
        end,
    })
    diagnosticsSection:Button({
        Title = "Copy Status Info",
        Desc = "Copy the status details.",
        Icon = "copy",
        Callback = function()
            local report = dashboard:BuildSummary()
            if type(setclipboard) ~= "function" then
                AirflowCompat:Notify({Title = "Status", Content = "Clipboard copy isn't available here.", Type = "Warning", Duration = 4})
                return
            end
            local copied = pcall(setclipboard, report)
            AirflowCompat:Notify({
                Title = "Status",
                Content = copied and "Status copied." or "Could not copy the status.",
                Type = copied and "Success" or "Warning",
                Duration = 3,
            })
        end,
    })

    pcall(function() dashboard:Refresh() end)
    task.spawn(function()
        while _G.__MethionInfoDashboard == dashboard and dashboard.Token == dashboardToken do
            task.wait(2.5)
            if _G.__MethionInfoDashboard ~= dashboard then break end
            pcall(function() dashboard:Refresh() end)
        end
    end)
end

_G.__PhantomQuestFarmWrapSection = function(rawSection)
    local wrapped = {}

    function wrapped:Section(title, side, icon)
        local section = rawSection:Section({
            Title = tostring(title or "Section"),
            Side = string.lower(tostring(side or "Left")),
        })
        return _G.__PhantomQuestFarmWrapSection(section)
    end

    function wrapped:Viewer(config)
        config = config or {}
        local ok, viewer = pcall(function()
            return rawSection:Viewer(config)
        end)
        if not ok then
            warn("[Methion] Could not create Quest Farm item viewer: " .. tostring(viewer))
            return nil
        end
        return viewer
    end

    function wrapped:Dropdown(title, options, defaultValue, callback, desc)
        local list = {}
        for _, item in ipairs(options or {}) do
            table.insert(list, item)
        end
        local control = rawSection:Dropdown({
            Title = tostring(title or "Dropdown"),
            Desc = type(desc) == "string" and desc or "",
            Values = list,
            Value = defaultValue,
            Multi = false,
            Callback = callback,
        })
        control.Options = list

        local originalRefresh = control.Refresh
        function control:Refresh(newOptions, preserveSelection)
            if type(newOptions) == "table" then
                self.Options = newOptions
            end
            return originalRefresh(self, newOptions or self.Options, preserveSelection)
        end

        function control:Add(value)
            if value == nil then return false end
            for _, existing in ipairs(self.Options or {}) do
                if existing == value then return false end
            end
            table.insert(self.Options, value)
            self:Refresh(self.Options, true)
            return true
        end

        return control
    end

    function wrapped:MultiDropdown(title, options, defaultValue, callback, desc)
        return rawSection:Dropdown({
            Title = tostring(title or "Multi-select"),
            Desc = type(desc) == "string" and desc or "",
            Values = options or {},
            Value = defaultValue or {},
            Multi = true,
            Callback = callback,
        })
    end

    function wrapped:Toggle(title, defaultValue, callback, desc, icon, locked, lockedReason)
        return rawSection:Toggle({
            Title = tostring(title or "Toggle"),
            Desc = tostring(desc or ""),
            Icon = icon,
            Value = defaultValue == true,
            Locked = locked == true,
            LockedReason = tostring(lockedReason or "Premium"),
            Callback = callback,
        })
    end

    function wrapped:Button(title, callback, desc, icon, locked, lockedReason)
        return rawSection:Button({
            Title = tostring(title or "Button"),
            Desc = tostring(desc or ""),
            Icon = icon,
            Locked = locked == true,
            LockedReason = tostring(lockedReason or "Premium"),
            Callback = callback,
        })
    end

    function wrapped:Paragraph(title, desc)
        local titleText = tostring(title or "")
        local description = tostring(desc or "")
        local rendered = titleText ~= "" and (titleText .. "\n" .. description) or description
        local rawLabel = nil
        pcall(function() rawLabel = rawSection:Label({Text = rendered}) end)
        local paragraph = {Raw = rawLabel, Title = titleText, Desc = description, Text = rendered}
        local function write(value)
            paragraph.Text = tostring(value or "")
            local wrote = false
            pcall(function()
                if paragraph.Raw and type(paragraph.Raw.Set) == "function" then
                    paragraph.Raw:Set(paragraph.Text)
                    wrote = true
                end
            end)
            if not wrote then
                pcall(function()
                    local target = paragraph.Raw
                    if typeof(target) == "Instance" then
                        if target:IsA("TextLabel") or target:IsA("TextButton") then
                            target.Text = paragraph.Text
                            wrote = true
                        else
                            for _, child in ipairs(target:GetDescendants()) do
                                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                                    child.Text = paragraph.Text
                                    wrote = true
                                    break
                                end
                            end
                        end
                    elseif type(target) == "table" then
                        for _, key in ipairs({"Instance", "Label", "TextLabel", "Frame", "Container", "Raw"}) do
                            local candidate = target[key]
                            if typeof(candidate) == "Instance" then
                                if candidate:IsA("TextLabel") or candidate:IsA("TextButton") then
                                    candidate.Text = paragraph.Text
                                    wrote = true
                                    break
                                end
                                for _, child in ipairs(candidate:GetDescendants()) do
                                    if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                                        child.Text = paragraph.Text
                                        wrote = true
                                        break
                                    end
                                end
                            end
                            if wrote then break end
                        end
                    end
                end)
            end
            return wrote
        end
        function paragraph:Set(value)
            return write(value)
        end
        function paragraph:SetDesc(value)
            self.Desc = tostring(value or "")
            return write(self.Title ~= "" and (self.Title .. "\n" .. self.Desc) or self.Desc)
        end
        return paragraph
    end

    function wrapped:Divider()
        pcall(function() rawSection:Divider() end)
    end

    function wrapped:Slider(title, minValue, maxValue, defaultValue, step, callback, desc)
        return rawSection:Slider({
            Name = tostring(title or "Slider"),
            Title = tostring(title or "Slider"),
            Desc = tostring(desc or ""),
            Min = tonumber(minValue) or 0,
            Max = tonumber(maxValue) or 100,
            Default = tonumber(defaultValue) or tonumber(minValue) or 0,
            Step = tonumber(step) or 1,
            Callback = callback,
        })
    end

    return wrapped
end

_G.__PhantomQuestFarmWrapTab = function(rawTab)
    local wrapped = {}
    function wrapped:Section(title, side, icon)
        local section = rawTab:Section({
            Title = tostring(title or "Section"),
            Side = string.lower(tostring(side or "Left")),
        })
        return _G.__PhantomQuestFarmWrapSection(section)
    end
    return wrapped
end

_G.__PhantomQuestFarmWindowProxy = {
    Notify = function(_, title, content, duration, kind)
        return Window:Notify({
            Title = tostring(title or "Methion"),
            Content = tostring(content or ""),
            Duration = tonumber(duration) or 3,
            Type = tostring(kind or "Info"),
        })
    end,
}

_G.__PhantomQuestFarmLoaded = false
_G.__PhantomQuestFarmLoadError = nil
_G.__PhantomQuestFarmConfig = {
    enableNoclip = function()
        State.NoClip = true
    end,
    disableNoclip = function()
        State.NoClip = false
    end,
    isSelling = function()
        return State.Selling == true
    end,
    canStart = function()
        local env = type(getgenv) == "function" and getgenv() or _G
        return not State.Farm and not State.HalloweenCandyFarm
            and not State.Selling
            and not (env and (env.autoPrestigeEnabled or env.autoPrestigeBusy))
    end,
    dialogue = {
        currentDialogue = function() return Gui.currentDialogue() end,
        waitDialogue = function(timeout) return Gui.waitDialogue(timeout) end,
        dialogueActive = function(gui) return Gui.dialogueActive(gui) end,
        isVisible = function(guiObject) return Gui.isVisible(guiObject) end,
        hasVisibleOptions = function(gui) return Gui.hasVisibleOptions(gui) end,
        option = function(gui, name) return Gui.option(gui, name) end,
        click = function(button) return Gui.click(button) end,
        skipClick = function() return Gui.skipClick() end,
        waitAndClickOption = function(name, timeout) return Gui.waitAndClickOption(name, timeout) end,
    },
}

_G.__PhantomQuestFarmOk, _G.__PhantomQuestFarmErr = pcall(function()
    _G.__PhantomQuestFarmFactory = loadstring([==[
return function(Window, player, QuestTab, config)
	local enableNoclip = config.enableNoclip
	local disableNoclip = config.disableNoclip
	local function isSelling()
		if type(config.isSelling) ~= "function" then return false end
		local ok, value = pcall(config.isSelling)
		return ok and value == true
	end

	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local HttpService = game:GetService("HttpService")
	local Stats = game:GetService("Stats")
	local UserInputService = game:GetService("UserInputService")
	local PhysicsService = game:GetService("PhysicsService")
	local MarketplaceService = game:GetService("MarketplaceService")
	local TeleportService = game:GetService("TeleportService")

	local PlayerStats = player:WaitForChild("PlayerStats")
	local PlayerLevel = PlayerStats:WaitForChild("Level")
	local PlayerPity = PlayerStats:WaitForChild("PityCount")
	local PlayerStand = PlayerStats:WaitForChild("Stand")
	local PlayerPrestige = PlayerStats:WaitForChild("Prestige")
	local PlayerSpec = PlayerStats:WaitForChild("Spec")
	local PlayerMoney = PlayerStats:WaitForChild("Money")
	local ClientFX = ReplicatedStorage:WaitForChild("ClientFX")
	local Dialogues = workspace:WaitForChild("Dialogues")

	local function GetPlayer()
		return game.Players.LocalPlayer
	end

	local function GetCharacter()
		return GetPlayer().Character or GetPlayer().CharacterAdded:Wait()
	end

	local function GetHRP()
		local Character = GetCharacter()
		return Character and Character:FindFirstChild("HumanoidRootPart")
	end

	local function EldiabloIsMobile()
		if rawget(_G, "mobile_ui") then return true end
		if type(shared) == "table" and rawget(shared, "mobile_ui") then return true end
		if getgenv then
			local ok, g = pcall(getgenv)
			if ok and type(g) == "table" and (rawget(g, "mobile_ui") or rawget(g, "Eldiablo_Mobile")) then
				return true
			end
		end
		return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	end

	local farmNoclipConnections = setmetatable({}, {__mode = "k"})
	local function farmEnsureNoclip(char)
		if not char then return end
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
		if not farmNoclipConnections[char] then
			farmNoclipConnections[char] = char.DescendantAdded:Connect(function(v)
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end)
		end
	end

	local function farmReleaseNoclip(char)
		if not char then return end
		local connection = farmNoclipConnections[char]
		if connection then
			pcall(function() connection:Disconnect() end)
			farmNoclipConnections[char] = nil
		end
	end

	local function farmThrottledHeartbeat(fn, fpsMobile, fpsDesktop)
		fpsMobile = fpsMobile or 20
		fpsDesktop = fpsDesktop or 45
		local interval = 1 / (EldiabloIsMobile() and fpsMobile or fpsDesktop)
		local accum = 0
		return RunService.Heartbeat:Connect(function(dt)
			accum = accum + dt
			if accum < interval then return end
			accum = accum - interval
			fn(dt)
		end)
	end

	local function farmStepWait(default)
		default = default or 0
		return EldiabloIsMobile() and math.max(default, 0.06) or default
	end

	local function getRootPart()
		local char = GetCharacter()
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function teleportUp()
		local hrp = getRootPart()
		if not hrp then return end
		local fallY = workspace.FallenPartsDestroyHeight
		local p = hrp.Position
		if p.Y < fallY + 100 then
			hrp.Position = Vector3.new(p.X, fallY + 180, p.Z)
		end
		hrp.Anchored = true
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero

		local pad = Instance.new("Part")
		pad.Name = tostring(math.random(1, 6764))
		pad.Anchored = true
		pad.Size = Vector3.new(150, 1, 150)
		pad.Transparency = 1
		pad.CFrame = hrp.CFrame * CFrame.new(0, 200, 0)
		pad.Parent = workspace
		hrp.CFrame = pad.CFrame * CFrame.new(0, 6, 0)
		hrp.Anchored = false
		task.delay(15, function()
			if pad and pad.Parent then
				pad:Destroy()
			end
		end)
	end

	local function notify(title, msg, duration, kind)
		pcall(function()
			if Window and Window.Notify then
				Window:Notify(title, msg, type(duration) == "number" and duration or 4)
			end
		end)
	end

	local function clearFocusCam(char)
		if not char then return end
		pcall(function()
			local fc = char:FindFirstChild("FocusCam")
			if fc then
				fc:Destroy()
			end
		end)
	end

	local function fireproximityprompt(prompt)
		if not prompt then return end
		pcall(function()
			if type(getconnections) == "function" and prompt.Triggered then
				for _, conn in pairs(getconnections(prompt.Triggered)) do
					conn:Fire(prompt)
				end
				return
			end
			if type(prompt.InputHoldBegin) == "function" then
				prompt:InputHoldBegin()
				task.wait(0.1)
				if type(prompt.InputHoldEnd) == "function" then
					prompt:InputHoldEnd()
				end
			end
		end)
	end

	local STAND_KEEPALIVE_EXCLUDED = {
		["Beach Boy"] = true,
		["Hermit Purple"] = true,
		["Mr. President"] = true,
		["Sex Pistols"] = true,
		["Anubis"] = true,
		["None"] = true,
	}

	local FarmConfig = {
		KillLoopDelay = 0,
		QuestCheckDelay = 0.35,
		FarmingMethod = "Auto (Detect)",
		Distance = -28,
	}

	local FarmState = {
		Active = false,
		CurrentQuest = nil,
		CompletedQuest = false,
		OriginalCFrame = nil,
	}

	local QuestRuntime = {
		ManualQuest = nil,
		Phase = "Idle",
		Message = "Quest Farm is ready.",
		LastAcceptAttempt = 0,
		LastAcceptQuest = nil,
		LastTurnInAttempt = 0,
		ActiveQuest = nil,
		DialogueTarget = nil,
		OverrideRequested = false,
	}
	local QuestStatusLabel = nil
	local QuestProgressLabel = nil

	local function setQuestStatus(phase, message)
		local nextPhase = tostring(phase or "Ready")
		local nextMessage = tostring(message or "")
		local changed = QuestRuntime.Phase ~= nextPhase or QuestRuntime.Message ~= nextMessage
		if changed then
			QuestRuntime.Phase = nextPhase
			QuestRuntime.Message = nextMessage
			pcall(function()
				if QuestStatusLabel and QuestStatusLabel.SetDesc then
					QuestStatusLabel:SetDesc(QuestRuntime.Message)
				end
			end)
		end

		if nextPhase == "Farming selected target" then
			pcall(function()
				if QuestProgressLabel and QuestProgressLabel.SetDesc then
					QuestProgressLabel:SetDesc(nextMessage)
				end
			end)
		end
	end

	local QuestNPCView = {
		Active = false,
		Target = nil,
		Camera = nil,
		CameraType = nil,
		CameraSubject = nil,
		CameraCFrame = nil,
		CameraFocus = nil,
	}
	local QUEST_VIEW_BEFORE = "Phantom_QuestFarm_NPCView_BeforeCamera"
	local QUEST_VIEW_AFTER = "Phantom_QuestFarm_NPCView_AfterCamera"

	local function keepQuestNPCInView()
		if not QuestNPCView.Active then return end
		local camera = workspace.CurrentCamera
		if camera then QuestNPCView.Camera = camera end
		camera = QuestNPCView.Camera
		local target = QuestNPCView.Target
		if not camera or not target or not target.Parent then return end
		local subject = target:FindFirstChildOfClass("Humanoid") or target:FindFirstChild("HumanoidRootPart")
		if not subject or not subject.Parent then return end
		if camera.CameraType ~= Enum.CameraType.Custom then
			camera.CameraType = Enum.CameraType.Custom
		end
		if camera.CameraSubject ~= subject then
			camera.CameraSubject = subject
		end
	end

	local function startQuestNPCView(npc)
		if not npc then return end
		if QuestNPCView.Active then
			QuestNPCView.Target = npc
			keepQuestNPCInView()
			return
		end
		local camera = workspace.CurrentCamera
		QuestNPCView.Camera = camera
		QuestNPCView.CameraType = camera and camera.CameraType or nil
		QuestNPCView.CameraSubject = camera and camera.CameraSubject or nil
		QuestNPCView.CameraCFrame = camera and camera.CFrame or nil
		QuestNPCView.CameraFocus = camera and camera.Focus or nil
		QuestNPCView.Target = npc
		QuestNPCView.Active = true
		pcall(function() RunService:UnbindFromRenderStep(QUEST_VIEW_BEFORE) end)
		pcall(function() RunService:UnbindFromRenderStep(QUEST_VIEW_AFTER) end)
		RunService:BindToRenderStep(QUEST_VIEW_BEFORE, Enum.RenderPriority.Camera.Value - 1, keepQuestNPCInView)
		RunService:BindToRenderStep(QUEST_VIEW_AFTER, Enum.RenderPriority.Camera.Value + 1, keepQuestNPCInView)
		keepQuestNPCInView()
	end

	local function stopQuestNPCView()
		if not QuestNPCView.Active then return end
		pcall(function() RunService:UnbindFromRenderStep(QUEST_VIEW_BEFORE) end)
		pcall(function() RunService:UnbindFromRenderStep(QUEST_VIEW_AFTER) end)
		local camera = workspace.CurrentCamera or QuestNPCView.Camera
		if camera then
			pcall(function()
				camera.CameraType = QuestNPCView.CameraType or Enum.CameraType.Custom
				if QuestNPCView.CameraSubject and QuestNPCView.CameraSubject.Parent then
					camera.CameraSubject = QuestNPCView.CameraSubject
				end
				if QuestNPCView.CameraCFrame then camera.CFrame = QuestNPCView.CameraCFrame end
				if QuestNPCView.CameraFocus then camera.Focus = QuestNPCView.CameraFocus end
			end)
		end
		QuestNPCView.Active = false
		QuestNPCView.Target = nil
		QuestNPCView.Camera = nil
		QuestNPCView.CameraType = nil
		QuestNPCView.CameraSubject = nil
		QuestNPCView.CameraCFrame = nil
		QuestNPCView.CameraFocus = nil
	end

	local function zeroFarmVelocity(part)
		if not part then return end
		part.AssemblyLinearVelocity = Vector3.zero
		part.AssemblyAngularVelocity = Vector3.zero
	end

	local QuestStickState = _G.__MethionQuestStickState or {
		Target = nil,
		LastMoveAt = 0,
		LastGoal = nil,
	}
	QuestStickState.LastGoal = nil
	_G.__MethionQuestStickState = QuestStickState

	local function stickFarmPartsToNPC(char, npc, handheld)
		if not char or not npc or not npc.Parent then return end
		local playerRoot = char:FindFirstChild("HumanoidRootPart")
		local npcRoot = npc:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChildWhichIsA("Humanoid")
		if not playerRoot or not npcRoot or not humanoid or humanoid.Health <= 0 then return end

		local verticalOffset = handheld and 1.5 or (tonumber(FarmConfig.Distance) or -28)
		local backOffset = handheld and 2.5 or 1.8
		local follow = npcRoot.CFrame - npcRoot.CFrame.LookVector * backOffset
		follow = follow + Vector3.new(0, verticalOffset, 0)
		local targetCFrame = CFrame.lookAt(follow.Position, npcRoot.Position)

		local stand = char:FindFirstChild("StandMorph")
		local standRoot = stand and (stand.PrimaryPart or stand:FindFirstChild("HumanoidRootPart"))
		if not handheld and standRoot then
			local standFollow = npcRoot.CFrame - npcRoot.CFrame.LookVector * 2.5
			standFollow = standFollow + Vector3.new(0, 1.5, 0)
			standRoot.CFrame = CFrame.lookAt(standFollow.Position, npcRoot.Position)
			zeroFarmVelocity(standRoot)
		end

		playerRoot.CFrame = targetCFrame
		zeroFarmVelocity(playerRoot)
	end

	local FarmUtil = {}
	FarmUtil.CurrentEnemy = nil

	function FarmUtil.GetCharacter()
		return Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
	end

	function FarmUtil.GetHRP()
		local char = FarmUtil.GetCharacter()
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function isHandheldMethod()
		local m = FarmConfig.FarmingMethod
		if type(m) == "table" then m = m[1] end
		if m == "Handheld/Fist" then
			return true
		end
		if m == "Auto" or m == "Auto (Detect)" then
			return STAND_KEEPALIVE_EXCLUDED[Players.LocalPlayer.PlayerStats.Stand.Value] == true
		end
		return false
	end

	function FarmUtil.EquipStand()
		local char = FarmUtil.GetCharacter()
		if not char then return false end
		if isHandheldMethod() then
			if char:FindFirstChildWhichIsA("Tool") then
				return true
			end
			local rf = char:FindFirstChild("RemoteFunction")
			if rf then
				pcall(function()
					rf:InvokeServer("ToggleStand", "Toggle")
				end)
				task.wait(0.25)
				return char:FindFirstChildWhichIsA("Tool") ~= nil
			end
			return true
		end
		local ss = char:FindFirstChild("SummonedStand")
		if ss and ss.Value then
			return true
		end
		local rf = char:FindFirstChild("RemoteFunction")
		if rf then
			pcall(function()
				rf:InvokeServer("ToggleStand", "Toggle")
			end)
			task.wait(0.25)
			ss = char:FindFirstChild("SummonedStand")
			return ss and ss.Value
		end
		return false
	end

	function FarmUtil.UseMove(move)
		local char = FarmUtil.GetCharacter()
		if char and char:FindFirstChild("RemoteEvent") then
			pcall(function()
				char.RemoteEvent:FireServer("Attack", move)
			end)
		end
	end

	function FarmUtil.CountItem(itemName)
		local count = 0
		for _, v in pairs(Players.LocalPlayer.Backpack:GetChildren()) do
			if v.Name == itemName then
				count = count + 1
			end
		end
		local char = FarmUtil.GetCharacter()
		if char then
			local tool = char:FindFirstChildWhichIsA("Tool")
			if tool and tool.Name == itemName then
				count = count + 1
			end
		end
		return count
	end

	local function clickThroughDialogue()
		local plr = game:GetService("Players").LocalPlayer
		local dialogueGui = plr.PlayerGui:FindFirstChild("DialogueGui")
		local startTime = tick()
		while dialogueGui and dialogueGui.Parent and tick() - startTime < 5 do
			pcall(function()
				local frame = dialogueGui:FindFirstChild("Frame")
				if not frame then return end
				local clickContinue = frame:FindFirstChild("ClickContinue")
				if clickContinue then
					for _, conn in pairs(getconnections(clickContinue.MouseButton1Click)) do
						conn:Fire()
					end
				end
				local options = frame:FindFirstChild("Options")
				if options then
					local option1 = options:FindFirstChild("Option1")
					if option1 then
						local textButton = option1:FindFirstChild("TextButton")
						if textButton then
							for _, conn in pairs(getconnections(textButton.MouseButton1Click)) do
								conn:Fire()
							end
						end
					end
				end
			end)
			task.wait(0.1)
			dialogueGui = plr.PlayerGui:FindFirstChild("DialogueGui")
		end
	end

	local QuestDialogueBridge = config and config.dialogue or {}

	local function normalizeDialogueText(value)
		local text = string.lower(tostring(value or ""))
		text = text:gsub("[^%w%s]", " ")
		text = text:gsub("%s+", " ")
		return text:match("^%s*(.-)%s*$") or ""
	end

	local function containsDialoguePhrase(text, phrase)
		local haystack = " " .. normalizeDialogueText(text) .. " "
		local needle = " " .. normalizeDialogueText(phrase) .. " "
		return needle ~= "  " and haystack:find(needle, 1, true) ~= nil
	end

	local function questOptionText(button)
		if not button then return "" end
		local pieces = {}
		if button:IsA("TextButton") and button.Text ~= "" then table.insert(pieces, button.Text) end
		for _, child in ipairs(button:GetDescendants()) do
			if (child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox")) and child.Text and child.Text ~= "" then
				table.insert(pieces, child.Text)
			end
		end
		return normalizeDialogueText(table.concat(pieces, " "))
	end

	local function questDialogueMatchesNPC(gui, npc, dialogueName)
		if not gui or not npc then return false end
		local pieces = {}
		for _, child in ipairs(gui:GetDescendants()) do
			if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
				if child.Text and child.Text ~= "" then table.insert(pieces, child.Text) end
			end
		end
		local joined = normalizeDialogueText(table.concat(pieces, " "))
		local npcName = normalizeDialogueText(npc.Name)
		npcName = npcName:gsub(" lvl %d+.*$", "")
		local dialog = normalizeDialogueText(dialogueName)
		return (npcName ~= "" and containsDialoguePhrase(joined, npcName))
			or (dialog ~= "" and #dialog >= 4 and containsDialoguePhrase(joined, dialog))
	end

	local function chooseQuestOption(gui, mode)
		local positive = mode == "turnin"
			and {"turn in", "complete", "finished", "reward", "claim", "deliver", "hand over", "here", "done", "yes", "continue", "next", "okay", "ok"}
			or {"accept", "take quest", "help", "start", "begin", "yes", "quest", "sure", "okay", "ok", "ready", "do it"}

		local negative = {"no thanks", "not now", "don't", "do not", "decline", "cancel", "leave", "later", "never mind", "no, "}
		local firstSafeName, firstSafeButton = nil, nil
		local bestName, bestButton, bestScore = nil, nil, 0

		for optionIndex = 1, 8 do
			local optionName = "Option" .. tostring(optionIndex)
			local button = QuestDialogueBridge.option and QuestDialogueBridge.option(gui, optionName)
			if button and button.Parent and QuestDialogueBridge.isVisible and QuestDialogueBridge.isVisible(button) then
				local text = questOptionText(button)
				local score = 0
				for _, word in ipairs(positive) do
					if containsDialoguePhrase(text, word) then score = score + 2 end
				end
				for _, word in ipairs(negative) do
					if containsDialoguePhrase(text, word) then score = score - 5 end
				end

				if score >= 0 then
					if not firstSafeButton then
						firstSafeName, firstSafeButton = optionName, button
					end
					if score > bestScore then
						bestName, bestButton, bestScore = optionName, button, score
					end
				end
			end
		end

		return bestName or firstSafeName, bestButton or firstSafeButton
	end

	local function questDialogueSignature(gui)
		if not gui then return "" end
		local pieces = {}
		for _, child in ipairs(gui:GetDescendants()) do
			if (child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox"))
				and child.Text and child.Text ~= ""
				and (not QuestDialogueBridge.isVisible or QuestDialogueBridge.isVisible(child)) then
				table.insert(pieces, child.Name .. "=" .. tostring(child.Text))
			end
		end
		table.sort(pieces)
		return table.concat(pieces, "\30")
	end

	local function driveQuestDialogue(NPC, mode)
		if isSelling() or not NPC then return false end
		local dialogueNameObject = NPC:FindFirstChild("Dialogue")
		local dialogueName = dialogueNameObject and tostring(dialogueNameObject.Value or "") or ""
		if dialogueName == "" then return false end

		local character = GetCharacter()
		local remote = character and character:FindFirstChild("RemoteEvent")
		if not remote then return false end

		local dialogueFolder = ReplicatedStorage:FindFirstChild("Dialogue")
		local templateName = NPC.Name == "DIO [Lvl. 35+]" and "DIO" or dialogueName
		local dialogueTemplate = dialogueFolder and dialogueFolder:FindFirstChild(templateName)
		local gui = QuestDialogueBridge.currentDialogue and QuestDialogueBridge.currentDialogue()
		local opened = false

		local function dismissPreviousDialogueOnce()
			if QuestDialogueBridge.skipClick then pcall(QuestDialogueBridge.skipClick) end
			task.wait(0.12)
			return not (QuestDialogueBridge.currentDialogue and QuestDialogueBridge.currentDialogue())
		end

		if gui then
			local trackedTarget = QuestRuntime.DialogueTarget
			if trackedTarget == NPC.Name or questDialogueMatchesNPC(gui, NPC, dialogueName) then
				QuestRuntime.DialogueTarget = NPC.Name
				opened = true
			elseif dismissPreviousDialogueOnce() then
				QuestRuntime.DialogueTarget = nil
				gui = nil
			else
				setQuestStatus("Waiting for dialogue", "Close the previous NPC dialogue, then Quest Farm can use " .. tostring(NPC.Name) .. ".")
				return false
			end
		else
			QuestRuntime.DialogueTarget = nil
		end

		if isSelling() then return false end
		if not opened and dialogueTemplate then
			QuestRuntime.DialogueTarget = NPC.Name
			pcall(function() remote:FireServer("PromptTriggered", dialogueTemplate) end)
			if QuestDialogueBridge.waitDialogue then
				gui = QuestDialogueBridge.waitDialogue(3)
				opened = gui ~= nil
			end
			if not opened then QuestRuntime.DialogueTarget = nil end
		end

		if not opened then
			if isSelling() then return false end
			QuestRuntime.DialogueTarget = NPC.Name
			pcall(function()
				remote:FireServer("DialogueInteracted", {DialogueName = dialogueName, Speaker = NPC.Name})
			end)
			if QuestDialogueBridge.waitDialogue then
				gui = QuestDialogueBridge.waitDialogue(4)
				opened = gui ~= nil
			end
			if not opened then QuestRuntime.DialogueTarget = nil end
		end

		if not opened then return false end

		local deadline = tick() + 12
		local actionCount = 0
		local clickedAny = false
		local sawGui = false
		local lastActionSignature = nil
		local lastActionTarget = nil
		local lastActionAt = 0

		while tick() < deadline and actionCount < 12 and FarmState.Active do
			if isSelling() then return false end
			gui = QuestDialogueBridge.currentDialogue and QuestDialogueBridge.currentDialogue()
			if gui then
				sawGui = true
				local signature = questDialogueSignature(gui)
				local optionName, target = chooseQuestOption(gui, mode)
				if signature == lastActionSignature and target == lastActionTarget then
					if tick() - lastActionAt >= 2 then
						if QuestRuntime.DialogueTarget == NPC.Name then QuestRuntime.DialogueTarget = nil end
						return clickedAny
					end
					task.wait(0.08)
				else
					local clicked = false
					if target and optionName then
						if QuestDialogueBridge.click then clicked = QuestDialogueBridge.click(target) == true end
						if not clicked and QuestDialogueBridge.waitAndClickOption then
							clicked = QuestDialogueBridge.waitAndClickOption(optionName, 0.8) == true
						end
					else
						if QuestDialogueBridge.skipClick then
							pcall(QuestDialogueBridge.skipClick)
							clicked = true
						elseif QuestDialogueBridge.waitAndClickOption then
							clicked = QuestDialogueBridge.waitAndClickOption("Option1", 0.5) == true
						end
					end

					if clicked then
						if target and optionName then clickedAny = true end
						lastActionSignature = signature
						lastActionTarget = target
						lastActionAt = tick()
						actionCount = actionCount + 1
						task.wait(0.16)
					else
						task.wait(0.08)
					end
				end
			elseif sawGui then
				task.wait(0.2)
				if not (QuestDialogueBridge.currentDialogue and QuestDialogueBridge.currentDialogue()) then
					if QuestRuntime.DialogueTarget == NPC.Name then QuestRuntime.DialogueTarget = nil end
					return clickedAny
				end
			else
				task.wait(0.1)
			end
		end

		if not (QuestDialogueBridge.currentDialogue and QuestDialogueBridge.currentDialogue()) and QuestRuntime.DialogueTarget == NPC.Name then
			QuestRuntime.DialogueTarget = nil
		end
		return clickedAny
	end

	local function closeQuestDialogueIfOpen()
		local bridge = QuestDialogueBridge
		if bridge and bridge.currentDialogue and bridge.currentDialogue() and bridge.skipClick then
			pcall(bridge.skipClick)
			task.wait(0.08)
		end
	end

	local function GetQuest(NPC)
		if not NPC or isSelling() then return false end
		local ok, interacted = pcall(driveQuestDialogue, NPC, "accept")
		if not ok then
			warn("[Quest Farm] Quest dialogue failed: " .. tostring(interacted))
			return false
		end
		closeQuestDialogueIfOpen()
		return interacted == true
	end

	local function TurnInQuest(NPC)
		if not NPC or isSelling() then return false end
		local ok, interacted = pcall(driveQuestDialogue, NPC, "turnin")
		if not ok then
			warn("[Quest Farm] Turn-in dialogue failed: " .. tostring(interacted))
			return false
		end
		closeQuestDialogueIfOpen()
		return interacted == true
	end

	FarmUtil.GetQuest = GetQuest

	local function questEnemyNameMatches(instName, questEnemy)
		if instName == questEnemy then
			return true
		end
		if questEnemy == "Heaven Ascension Dio" then
			local n = string.lower(instName or "")
			if n:find("heaven", 1, true) and n:find("dio", 1, true) then
				if n:find("ascension", 1, true) or n:find("ascended", 1, true) then
					return true
				end
			end
		end
		return false
	end

	local NPC_KILL_POST_BUFFER_SEC = 1

	local function findAliveQuestEnemy(enemyName)
		if not enemyName or enemyName == "" then return nil end
		local function consider(inst)
			if not inst or not inst.Parent then return nil end
			if not questEnemyNameMatches(inst.Name, enemyName) then return nil end
			local h = inst:FindFirstChild("Health")
			local hrp = inst:FindFirstChild("HumanoidRootPart")
			if h and hrp and h.Value > 0 then
				return inst
			end
			return nil
		end
		local living = workspace:FindFirstChild("Living")
		if living then
			for _, child in ipairs(living:GetChildren()) do
				local e = consider(child)
				if e then return e end
			end
			for _, child in ipairs(living:GetDescendants()) do
				if child ~= living and child.Parent ~= living then
					local e = consider(child)
					if e then return e end
				end
			end
		end
		local mob2 = workspace:FindFirstChild("Mob_Spawns2")
		if mob2 then
			for _, child in ipairs(mob2:GetDescendants()) do
				local e = consider(child)
				if e then return e end
			end
		end
		return nil
	end

	function FarmUtil.Kill(enemy)
		if not enemy or not enemy.Parent then return end
		local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
		local enemyHealth = enemy:FindFirstChild("Health")
		if not (enemyHRP and enemyHealth and enemyHealth.Value > 0) then return end
		local hrp = FarmUtil.GetHRP()
		if not hrp then return end

		FarmUtil.CurrentEnemy = enemy
		local progressConn
		local questProgressAdvanced = false

		local okKill = pcall(function()
			local handheld = isHandheldMethod()
			local lp = Players.LocalPlayer
			local stats = lp:FindFirstChild("PlayerStats")
			local questProgress = stats and stats:FindFirstChild("QuestProgress")
			local questProgressStart = tonumber(questProgress and questProgress.Value) or 0
			if questProgress then
				progressConn = questProgress:GetPropertyChangedSignal("Value"):Connect(function()
					local currentProgress = tonumber(questProgress.Value) or 0
					if currentProgress ~= questProgressStart then
						questProgressAdvanced = true
					end
				end)
			end

			if not handheld then
				FarmUtil.EquipStand()
				local standWaitTimeout = tick() + 4
				repeat task.wait(0.05) until (FarmUtil.GetCharacter():FindFirstChild("SummonedStand") and FarmUtil.GetCharacter():FindFirstChild("SummonedStand").Value) or tick() > standWaitTimeout
				task.wait(0.1)
			end

			while FarmState.Active and not FarmState.CompletedQuest and not QuestRuntime.OverrideRequested do
				if enemy.Parent == nil or not enemy:FindFirstChild("HumanoidRootPart") then
					break
				end
				local currentEnemyHRP = enemy:FindFirstChild("HumanoidRootPart")
				local h = enemy:FindFirstChild("Health")
				if h and h.Value <= 0 then
					task.wait(0.25)
					break
				end
				if questProgressAdvanced then
					break
				end
				local char = Players.LocalPlayer.Character
				local hum = char and char:FindFirstChildWhichIsA("Humanoid")
				if hum and hum.Health > 0 then
					if handheld or char:FindFirstChild("StandMorph") then
						FarmUtil.UseMove("m1")
						local remote = char:FindFirstChild("RemoteEvent")
						if remote then
							if game:GetService("CollectionService"):HasTag(enemy, "Blocking") then
								remote:FireServer("InputBegan", { Input = Enum.KeyCode.R })
							end
							local keys = getgenv().AutoUseStandSkillKeys or {"E"}
							for _, keyName in ipairs(keys) do
								local skillKey = keyName and Enum.KeyCode[keyName] or nil
								if skillKey then
									remote:FireServer("InputBegan", { Input = skillKey })
								end
							end
						end
					else
						task.wait(0.3)
					end
				else
					Players.LocalPlayer.CharacterAdded:Wait()
					if not handheld then
						FarmUtil.EquipStand()
					end
					task.wait(0.3)
				end
				local kd = FarmConfig.KillLoopDelay
				if type(kd) == "number" and kd > 0 then
					task.wait(math.min(kd, 2))
				else
					task.wait()
				end
			end
		end)

		local bufUntil = tick() + (QuestRuntime.OverrideRequested and 0 or NPC_KILL_POST_BUFFER_SEC)
		while FarmState.Active and not FarmState.CompletedQuest and not questProgressAdvanced
			and not QuestRuntime.OverrideRequested and tick() < bufUntil do
			local currentHealth = enemy and enemy:FindFirstChild("Health")
			if not enemy or not enemy.Parent or not currentHealth or currentHealth.Value <= 0 then break end
			local char = Players.LocalPlayer.Character
			local hum = char and char:FindFirstChildWhichIsA("Humanoid")
			if hum and hum.Health > 0 then
				if isHandheldMethod() or (char and char:FindFirstChild("StandMorph")) then
					FarmUtil.UseMove("m1")
					local remote = char:FindFirstChild("RemoteEvent")
					if remote then
						local keys = getgenv().AutoUseStandSkillKeys or {"E"}
						for _, keyName in ipairs(keys) do
							local skillKey = keyName and Enum.KeyCode[keyName] or nil
							if skillKey then
								remote:FireServer("InputBegan", { Input = skillKey })
							end
						end
					end
				else
					task.wait(0.3)
				end
			end
			local kd = FarmConfig.KillLoopDelay
			if type(kd) == "number" and kd > 0 then
				task.wait(math.min(kd, 2))
			else
				task.wait()
			end
		end

		if progressConn then pcall(function() progressConn:Disconnect() end) end
		stopQuestNPCView()
		clearFocusCam(Players.LocalPlayer.Character)

		local safeHRP = FarmUtil.GetHRP()
		if safeHRP then
			safeHRP.AssemblyLinearVelocity = Vector3.zero
			safeHRP.AssemblyAngularVelocity = Vector3.zero
		end

		FarmUtil.CurrentEnemy = nil
	end

	function FarmUtil.Collect(item)
		if not item or not item.Parent then return false end
		local char = FarmUtil.GetCharacter()
		local hrp = FarmUtil.GetHRP()
		if not char or not hrp then return false end
		local function getItemPart()
			if not item or not item.Parent then return nil end
			if item:IsA("BasePart") then return item end
			return item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)
		end
		local part = getItemPart()
		if not part then return false end
		local started = tick()
		local lastPromptAt = 0
		farmEnsureNoclip(char)
		while FarmState.Active and item.Parent and tick() - started < 3.5 do
			part = getItemPart()
			if not part then break end
			local targetPosition = part.Position + Vector3.new(0, 2.25, 0)
			if (hrp.Position - targetPosition).Magnitude > 2.5 then
				hrp.CFrame = CFrame.new(targetPosition, part.Position)
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end
			local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
			if prompt and prompt.Enabled and (tick() - lastPromptAt >= 0.16) then
				lastPromptAt = tick()
				fireproximityprompt(prompt)
			end
			task.wait(0.1)
		end
		return not item.Parent
	end

	local QuestInfo = {
		["Officer Sam [Lvl. 1+]"] = { Enemy = "Thug" },
		["Deputy Bertrude [Lvl. 10+]"] = { Enemy = "Corrupt Police" },
		["Abbacchio's Partner [Lvl 15+]"] = { Enemy = "Alpha Thug" },
		["Dracula [Lvl. 20+]"] = { Enemy = "Zombie Henchman" },
		["William Zeppeli [Lvl. 25+]"] = { Enemy = "Vampire" },
		["Doppio [Lvl. 30+]"] = { Enemy = "DIO" },
		["DIO [Lvl. 35+]"] = { Enemy = "Jotaro" },
	}

	local QUEST_LEVEL_REQUIREMENTS = {
		["Officer Sam [Lvl. 1+]"] = 1,
		["Deputy Bertrude [Lvl. 10+]"] = 10,
		["Abbacchio's Partner [Lvl 15+]"] = 15,
		["Dracula [Lvl. 20+]"] = 20,
		["William Zeppeli [Lvl. 25+]"] = 25,
		["Doppio [Lvl. 30+]"] = 30,
		["DIO [Lvl. 35+]"] = 35,
	}

	local QUEST_SELECTION_ORDER = {
		"Officer Sam [Lvl. 1+]",
		"Deputy Bertrude [Lvl. 10+]",
		"Abbacchio's Partner [Lvl 15+]",
		"Dracula [Lvl. 20+]",
		"William Zeppeli [Lvl. 25+]",
		"Doppio [Lvl. 30+]",
		"DIO [Lvl. 35+]",
	}

	local function ParseQuests()
		local parsed = {}
		for questName in pairs(QuestInfo) do
			table.insert(parsed, questName)
		end
		table.sort(parsed, function(a, b)
			local levelA = QUEST_LEVEL_REQUIREMENTS[a] or tonumber(tostring(a):match("(%d+)")) or math.huge
			local levelB = QUEST_LEVEL_REQUIREMENTS[b] or tonumber(tostring(b):match("(%d+)")) or math.huge
			if levelA == levelB then return a < b end
			return levelA < levelB
		end)
		return parsed
	end

	local ParsedQuests = ParseQuests()
	if workspace:FindFirstChild("Dialogues") then
		workspace.Dialogues.ChildAdded:Connect(function(child)
			if not child or not QuestInfo[child.Name] then return end
			for _, existing in ipairs(ParsedQuests) do
				if existing == child.Name then return end
			end
			table.insert(ParsedQuests, child.Name)
			table.sort(ParsedQuests)
			pcall(function()
				if QuestDropdown and QuestDropdown.Refresh then
					QuestDropdown:Refresh(ParsedQuests, true)
				end
			end)
		end)
	end

	local function GetBestQuest()
		local playerLevel = Players.LocalPlayer.PlayerStats.Level.Value
		local bestQuest, highestReq = nil, 0
		for _, questName in pairs(ParsedQuests) do
			if QuestInfo[questName] and questName ~= "Auto (Best for Level)" and questName ~= "No quests available" then
				local levelReq = tonumber(questName:match("%d+"))
				if levelReq and levelReq <= playerLevel and levelReq >= highestReq then
					highestReq = levelReq
					bestQuest = questName
				end
			end
		end
		if not bestQuest then
			for questName, _ in pairs(QuestInfo) do
				local levelReq = tonumber(questName:match("%d+"))
				if levelReq and levelReq <= playerLevel and levelReq >= highestReq then
					highestReq = levelReq
					bestQuest = questName
				end
			end
		end
		return bestQuest
	end

	local function GetBestQuestForLevel(currentLevel)
		local level = tonumber(currentLevel) or 0
		local bestQuest, highestReq = nil, -1

		for _, questName in ipairs(QUEST_SELECTION_ORDER) do
			if QuestInfo[questName] then
				local requirement = QUEST_LEVEL_REQUIREMENTS[questName]
					or tonumber(tostring(questName):match("(%d+)"))
				if requirement and requirement <= level and requirement > highestReq then
					bestQuest, highestReq = questName, requirement
				end
			end
		end

		if not bestQuest then
			for questName in pairs(QuestInfo) do
				local requirement = QUEST_LEVEL_REQUIREMENTS[questName]
					or tonumber(tostring(questName):match("(%d+)"))
				if requirement and requirement <= level and requirement > highestReq then
					bestQuest, highestReq = questName, requirement
				end
			end
		end
		return bestQuest
	end

	local function GetLowestLevelQuest()
		local lowestQuest, lowestReq = nil, math.huge
		for _, questName in ipairs(ParsedQuests) do
			if QuestInfo[questName] then
				local requirement = tonumber(tostring(questName):match("(%d+)"))
				if requirement and requirement < lowestReq then
					lowestQuest, lowestReq = questName, requirement
				end
			end
		end
		if not lowestQuest then
			for questName in pairs(QuestInfo) do
				local requirement = tonumber(tostring(questName):match("(%d+)"))
				if requirement and requirement < lowestReq then
					lowestQuest, lowestReq = questName, requirement
				end
			end
		end
		return lowestQuest
	end

	local function GetQuestLevelRequirement(questName)
		if not questName then return 0 end
		return QUEST_LEVEL_REQUIREMENTS[questName] or tonumber(tostring(questName):match("(%d+)")) or 0
	end

	local function GetPlayerLevel()
		local player = GetPlayer()
		if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Level") then
			return player.PlayerStats.Level.Value
		end
		return 0
	end

	local function UpdateQuestStatusLabel()
		local target = FarmState.CurrentQuest or QuestRuntime.ManualQuest or getgenv().SelectedQuest
		local stats = player and player:FindFirstChild("PlayerStats")
		local progressObject = stats and stats:FindFirstChild("QuestProgress")
		local maximumObject = stats and stats:FindFirstChild("QuestMaxProgress")
		local progress = tonumber(progressObject and progressObject.Value) or 0
		local maximum = tonumber(maximumObject and maximumObject.Value) or 0
		local labelText = target and ("Target: " .. tostring(target)) or "No target selected"
		if target and maximum > 0 then
			local remaining = math.max(0, maximum - progress)
			labelText ..= " | " .. tostring(progress) .. "/" .. tostring(maximum)
			if remaining == 0 then
				labelText ..= " | Finished"
			else
				labelText ..= " (" .. tostring(remaining) .. " left)"
			end
		end
		pcall(function()
			if _G.QuestCurrentQuestLabelObj then
				if _G.QuestCurrentQuestLabelObj.Set then
					_G.QuestCurrentQuestLabelObj:Set(labelText)
				elseif _G.QuestCurrentQuestLabelObj.Text then
					_G.QuestCurrentQuestLabelObj.Text = labelText
				end
			end
		end)
	end

	local function IsPlayerReady()
		local player = GetPlayer()
		if not player then return false end
		local character = player.Character
		if not character then return false end
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if not humanoid then return false end
		if humanoid.Health <= 0 then return false end
		if not character:FindFirstChild("HumanoidRootPart") then return false end
		if not character.PrimaryPart then return false end
		return true
	end

	local function WaitForCharacter(timeout)
		timeout = timeout or 10
		local player = GetPlayer()
		if not player then return false end
		local start = tick()
		while tick() - start < timeout do
			if player.Character then
				local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
				if humanoid and humanoid.Health > 0 then
					return true
				end
			end
			task.wait(0.1)
		end
		return false
	end

	local function getRemoteFunction()
		return GetCharacter():WaitForChild("RemoteFunction")
	end

	local function learnSkill(skill, treeType)
		pcall(function()
			getRemoteFunction():InvokeServer("LearnSkill", {
				Skill = skill,
				SkillTreeType = treeType,
			})
		end)
	end

	local SPEC_SKILLS = {
		"Hamon Breathing","Lung Capacity I","Lung Capacity II","Lung Capacity III",
		"Lung Capacity IV","Lung Capacity V","Breathing Technique I","Breathing Technique II",
		"Breathing Technique III","Breathing Technique IV","Breathing Technique V",
	}

	local function learnAllSkills()
		pcall(function()
			local sst = player:FindFirstChild("StandSkillTree")
			if sst then
				for _, v in pairs(sst:GetChildren()) do
					if not v.Value then
						learnSkill(v.Name, "Stand")
					end
				end
			end
			local info = getRemoteFunction():InvokeServer("ReturnSkillInfoInTree", {
				Type   = "Stand",
				Skills = { [19] = "Inhale" },
			})
			if info and info.Inhale and info.Inhale.AssignedKey ~= "L" then
				getRemoteFunction():InvokeServer("AssignSkillKey", {
					Type  = "Stand",
					Key   = "Enum.KeyCode.L",
					Skill = "Inhale",
				})
			end
			for _, name in ipairs(SPEC_SKILLS) do
				learnSkill(name, "Spec")
			end
		end)
	end

	local function getQuests()
		local t = {}
		local ok, questFrame = pcall(function()
			return player.PlayerGui:WaitForChild("HUD")
				:WaitForChild("Main")
				:WaitForChild("Frames")
				:WaitForChild("Quest")
				:WaitForChild("Quests")
		end)
		if not ok then return t end
		for _, v in pairs(questFrame:GetChildren()) do
			if v.Name ~= "Sample" then t[v.Name] = true end
		end
		return t
	end

	local function getPity()
		return PlayerPity.Value <= 0 and 1
			or math.clamp(1 + PlayerPity.Value / 25, 0, 10)
	end

	local function roundTwo(n)
		return math.floor(n * 100) / 100
	end

	local function FarmLoop()
		local lp = Players.LocalPlayer
		local playerGui = lp:WaitForChild("PlayerGui")
		local hud = playerGui:FindFirstChild("HUD")
		local completionConnection
		local activeTarget = nil
		local acceptAttempted = false
		local turnInRetryAt = 0
		local turnInStartedAt = nil
		local turnInAttempted = false
		local turnInInteracted = false
		local turnInStartProgress = 0
		local turnInStartMaximum = 0
		local trackedQuestMaximum = 0
		local ignoreProgressCompletionUntil = 0

		local function questProgressValues()
			local stats = lp:FindFirstChild("PlayerStats")
			local progress = stats and stats:FindFirstChild("QuestProgress")
			local maximum = stats and stats:FindFirstChild("QuestMaxProgress")
			return tonumber(progress and progress.Value) or 0, tonumber(maximum and maximum.Value) or 0
		end

		local function displayQuestProgressValues()
			local progress, maximum = questProgressValues()
			if tick() < ignoreProgressCompletionUntil and not FarmState.CompletedQuest then
				return 0, math.max(maximum, trackedQuestMaximum, 0)
			end
			if acceptAttempted and maximum > 0 then
				trackedQuestMaximum = math.max(trackedQuestMaximum, maximum)
			end
			local displayMaximum = math.max(maximum, trackedQuestMaximum, progress, 0)
			local displayProgress = math.max(0, progress)
			if displayMaximum > 0 then
				displayProgress = math.min(displayProgress, displayMaximum)
			end
			return displayProgress, displayMaximum
		end

		local function isValidQuest(name)
			return type(name) == "string" and QuestInfo[name] ~= nil and name ~= "No quests available"
		end

		local function chooseNextQuest()
			local chosen
			if getgenv().AutoSelectBestQuest == true then
				chosen = GetBestQuestForLevel(GetPlayerLevel())
			else
				chosen = QuestRuntime.ManualQuest or getgenv().SelectedQuest
			end
			if not isValidQuest(chosen) then chosen = GetLowestLevelQuest() end
			return isValidQuest(chosen) and chosen or nil
		end

		local function updateProgressLabel()
			local progress, maximum = displayQuestProgressValues()
			local detail = tostring(activeTarget or "No quest selected")
			local questData = activeTarget and QuestInfo[activeTarget]

			if questData and questData.Enemy then
				detail ..= "  •  target: " .. tostring(questData.Enemy)
				if maximum > 0 then
					detail ..= "  •  " .. tostring(progress) .. "/" .. tostring(maximum)
				end
			elseif questData and questData.Item then
				local count = FarmUtil.CountItem(questData.Item)
				detail ..= "  •  " .. tostring(count) .. "/" .. tostring(questData.Amount) .. " " .. tostring(questData.Item)
			elseif maximum > 0 then
				detail ..= "  •  " .. tostring(progress) .. "/" .. tostring(maximum)
			end

			setQuestStatus("Farming selected target", detail)
		end

		local function assignNextTarget()
			local nextQuest = chooseNextQuest()
			if not nextQuest then
				setQuestStatus("No quest available", "Choose a quest or wait for the quest catalog to become available.")
				return false
			end
			activeTarget = nextQuest
			FarmState.CurrentQuest = nextQuest
			QuestRuntime.ActiveQuest = nextQuest
			FarmState.CompletedQuest = false
			getgenv().CompletedQuest = false
			acceptAttempted = false
			turnInRetryAt = 0
			turnInStartedAt = nil
			turnInAttempted = false
			turnInInteracted = false
			turnInStartProgress = 0
			turnInStartMaximum = 0
			trackedQuestMaximum = 0
			ignoreProgressCompletionUntil = tick() + 1.25
			setQuestStatus("Quest target selected", "Target: " .. tostring(nextQuest) .. ". Quest Farm will open this giver once, then farm its configured objective.")
			return true
		end

		local function attemptAcceptOnce(questName)
			if acceptAttempted or not isValidQuest(questName) or isSelling() then return acceptAttempted end
			local dialogues = workspace:FindFirstChild("Dialogues")
			local npc = dialogues and dialogues:FindFirstChild(questName)
			if not npc then
				setQuestStatus("Waiting for quest giver", "Waiting for " .. tostring(questName) .. " to load before making the single quest request.")
				return false
			end

			acceptAttempted = true
			QuestRuntime.LastAcceptAttempt = tick()
			QuestRuntime.LastAcceptQuest = questName
			setQuestStatus("Requesting quest once", "Opening " .. tostring(questName) .. " and selecting its quest option once, without checking which quest is already active.")
			local ok, interacted = pcall(GetQuest, npc)
			if not ok then
				warn("[Quest Farm] Quest request failed: " .. tostring(interacted))
				setQuestStatus("Quest request attempted", "The NPC dialogue was attempted once. The farm will still work the selected target.")
			elseif interacted then
				setQuestStatus("Quest requested", "NPC dialogue interaction finished. Farming " .. tostring(questName) .. " regardless of any existing quest state.")
			else
				setQuestStatus("Quest request attempted", "The NPC dialogue was attempted once. Farming will continue using the selected target and progress counter only.")
			end
			task.wait(0.25)
			return true
		end

		local function clearFinishedTarget(questName)
			setQuestStatus("Quest cycle handled", "Finished the " .. tostring(questName) .. " cycle. Preparing the next quest request.")
			activeTarget = nil
			FarmState.CurrentQuest = nil
			QuestRuntime.ActiveQuest = nil
			FarmState.CompletedQuest = false
			getgenv().CompletedQuest = false
			acceptAttempted = false
			turnInRetryAt = 0
			turnInStartedAt = nil
			turnInAttempted = false
			turnInInteracted = false
			turnInStartProgress = 0
			turnInStartMaximum = 0
			trackedQuestMaximum = 0
			ignoreProgressCompletionUntil = tick() + 1.25
		end

		local function attemptTurnIn(questName)
			if isSelling() then return false end

			local currentProgress, currentMaximum = questProgressValues()
			if turnInAttempted then
				local progressReset = turnInStartMaximum > 0
					and (currentMaximum < turnInStartMaximum or currentProgress < turnInStartProgress)
				if progressReset then
					clearFinishedTarget(questName)
					return true
				end
				if turnInStartedAt and turnInInteracted and tick() - turnInStartedAt >= 3.5 then
					clearFinishedTarget(questName)
					return true
				end
				if turnInStartedAt and not turnInInteracted and tick() - turnInStartedAt >= 5 then
					setQuestStatus("Turn-in needs attention", "The completion dialogue was attempted once but did not confirm. It will not reopen repeatedly. Toggle Quest Farm off and on to retry.")
				end
				return false
			end

			if tick() < turnInRetryAt then return false end
			local dialogues = workspace:FindFirstChild("Dialogues")
			local npc = dialogues and dialogues:FindFirstChild(questName)
			if not npc then
				setQuestStatus("Waiting to turn in", "The objective is complete. Waiting for " .. tostring(questName) .. " to load for the reward interaction.")
				turnInRetryAt = tick() + 1.25
				return false
			end

			turnInStartedAt = tick()
			turnInStartProgress = currentProgress
			turnInStartMaximum = currentMaximum
			turnInAttempted = true
			turnInInteracted = false
			QuestRuntime.LastTurnInAttempt = turnInStartedAt
			setQuestStatus("Turning in quest", "The objective is complete. Opening " .. tostring(questName) .. " once to claim the reward.")
			local ok, interacted = pcall(TurnInQuest, npc)
			if not ok then
				warn("[Quest Farm] Turn-in attempt failed: " .. tostring(interacted))
				interacted = false
			end
			turnInInteracted = interacted == true
			task.wait(0.65)
			local afterProgress, afterMaximum = questProgressValues()
			local progressReset = turnInStartMaximum > 0
				and (afterMaximum < turnInStartMaximum or afterProgress < turnInStartProgress)

			if progressReset or (turnInStartMaximum <= 0 and turnInInteracted) then
				clearFinishedTarget(questName)
				return true
			end

			if turnInInteracted then
				setQuestStatus("Waiting for turn-in", "The turn-in option was selected once. Waiting for the counter to reset without reopening the dialogue.")
			else
				setQuestStatus("Turn-in attempted once", "The completion dialogue did not confirm a selection. Waiting without reopening the giver repeatedly.")
			end
			return false
		end

		if hud then
			completionConnection = hud.DescendantAdded:Connect(function(child)
				if child and child.Name == "QuestCompleted" and FarmState.Active then
					FarmState.CompletedQuest = true
					getgenv().CompletedQuest = true
				end
			end)
		end

		task.spawn(function()
			while FarmState.Active do
				task.wait(2.5)
				if not FarmState.Active then break end
				local stats = lp:FindFirstChild("PlayerStats")
				local standValue = stats and stats:FindFirstChild("Stand")
				if isHandheldMethod() and not STAND_KEEPALIVE_EXCLUDED[standValue and standValue.Value or ""] then continue end
				local char = lp.Character
				if char then
					local ss = char:FindFirstChild("SummonedStand")
					if not (ss and ss.Value) then pcall(FarmUtil.EquipStand) end
				end
			end
		end)

		local masterConn = RunService.Heartbeat:Connect(function()
			if not FarmState.Active then return end
			local char = lp.Character
			if not char then return end
			local root = char:FindFirstChild("HumanoidRootPart")
			if not root then return end
			local enemy = FarmUtil.CurrentEnemy
			if enemy and enemy.Parent and enemy:FindFirstChild("HumanoidRootPart") then
				startQuestNPCView(enemy)
				stickFarmPartsToNPC(char, enemy, isHandheldMethod())
			else
				stopQuestNPCView()
				zeroFarmVelocity(root)
			end
		end, 22, 45)

		while FarmState.Active do
			if not IsPlayerReady() then
				setQuestStatus("Waiting for character", "Waiting for your character to finish spawning before continuing Quest Farm.")
				task.wait(0.3)
				continue
			end

			if not activeTarget and not assignNextTarget() then
				task.wait(0.5)
				continue
			end

			if not attemptAcceptOnce(activeTarget) then
				task.wait(0.2)
				continue
			end

			local questData = QuestInfo[activeTarget]
			if not questData then
				setQuestStatus("Unknown target", "No objective handler exists for " .. tostring(activeTarget) .. ".")
				task.wait(0.3)
				continue
			end

			local progress, maximum = questProgressValues()
			if acceptAttempted and maximum > 0 and tick() >= ignoreProgressCompletionUntil then
				trackedQuestMaximum = math.max(trackedQuestMaximum, maximum)
			end
			local complete = FarmState.CompletedQuest == true
			if maximum > 0 and progress >= maximum and tick() >= ignoreProgressCompletionUntil then
				complete = true
			end

			if questData.Item then
				local count = FarmUtil.CountItem(questData.Item)
				if count >= questData.Amount then complete = true end
			end

			if complete then
				FarmState.CompletedQuest = true
				getgenv().CompletedQuest = true
				if not turnInAttempted then updateProgressLabel() end
				attemptTurnIn(activeTarget)
				task.wait(0.12)
				continue
			end

			FarmState.CompletedQuest = false
			getgenv().CompletedQuest = false
			if questData.Enemy then
				updateProgressLabel()
				local enemy = findAliveQuestEnemy(questData.Enemy)
				if enemy then
					local ok, err = pcall(FarmUtil.Kill, enemy)
					if not ok then
						warn("[Quest Farm] Combat iteration failed: " .. tostring(err))
						setQuestStatus("Recovering combat", "The target action failed. Reacquiring the configured enemy and continuing.")
						task.wait(0.25)
					end
				else
					task.wait(0.2)
				end
			elseif questData.Item then
				local count = FarmUtil.CountItem(questData.Item)
				setQuestStatus("Collecting selected objective", tostring(activeTarget) .. "  •  " .. tostring(count) .. "/" .. tostring(questData.Amount) .. " " .. tostring(questData.Item))
				local spawns = workspace:FindFirstChild("Item_Spawns")
				local spawnParent = spawns and spawns:FindFirstChild("Items")
				local targetItem
				if spawnParent then
					for _, item in ipairs(spawnParent:GetChildren()) do
						if item.Name == questData.Item then targetItem = item break end
					end
				end
				if targetItem then
					local ok, err = pcall(FarmUtil.Collect, targetItem)
					if not ok then warn("[Quest Farm] Item collection failed: " .. tostring(err)) end
				else
					task.wait(0.25)
				end
			end

			updateProgressLabel()
			task.wait(math.max(0.1, tonumber(FarmConfig.QuestCheckDelay) or 0.35))
		end

		FarmUtil.CurrentEnemy = nil
		stopQuestNPCView()
		pcall(function() if masterConn then masterConn:Disconnect() end end)
		pcall(function() if completionConnection then completionConnection:Disconnect() end end)
	end

	local noQuestKillEnabled = false
	local noQuestKillTarget = "Vampire"

	local function killNPCNoQuest(npcName)
		local enemy = nil
		local containers = { workspace:FindFirstChild("Living") or workspace }
		if workspace:FindFirstChild("Mob_Spawns2") then
			table.insert(containers, workspace.Mob_Spawns2)
		end
		for _, container in pairs(containers) do
			for _, child in pairs(container:GetDescendants()) do
				if child.Name == npcName or questEnemyNameMatches(child.Name, npcName) then
					local h = child:FindFirstChild("Health")
					local hrp = child:FindFirstChild("HumanoidRootPart")
					if h and h.Value > 0 and hrp then
						enemy = child
						break
					end
				end
			end
			if enemy then break end
		end
		if not enemy then return end

		local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
		if not enemyHRP then return end

		local handheld = isHandheldMethod()
		if not handheld then
			FarmUtil.EquipStand()
			task.wait(0.3)
		end

		local running = true
		local moneyConn
		local dropMoney = Players.LocalPlayer.PlayerGui:FindFirstChild("HUD")
			and Players.LocalPlayer.PlayerGui.HUD:FindFirstChild("Main")
			and Players.LocalPlayer.PlayerGui.HUD.Main:FindFirstChild("DropMoney")
			and Players.LocalPlayer.PlayerGui.HUD.Main.DropMoney:FindFirstChild("Money")
		if dropMoney then
			moneyConn = dropMoney.ChildAdded:Connect(function(child)
				if tonumber(string.match(child.Name, "%d+")) then
					running = false
					if moneyConn then moneyConn:Disconnect() moneyConn = nil end
				end
			end)
		end

		local heartbeat = RunService.Heartbeat:Connect(function()
			if not running or not noQuestKillEnabled then return end
			if enemy.Parent == nil then return end
			local currentHRP = enemy:FindFirstChild("HumanoidRootPart")
			if not currentHRP then return end
			local char = Players.LocalPlayer.Character
			if not char then return end
			local hHRP = char:FindFirstChild("HumanoidRootPart")
			if not hHRP then return end

			local hum = char:FindFirstChildWhichIsA("Humanoid")
			if not (hum and hum.Health > 0) then return end
			stickFarmPartsToNPC(char, enemy, handheld)
		end, 22, 45)

		while running and noQuestKillEnabled do
			if enemy.Parent == nil or not enemy:FindFirstChild("HumanoidRootPart") then
				running = false
				break
			end
			local currentEnemyHRP = enemy:FindFirstChild("HumanoidRootPart")
			local h = enemy:FindFirstChild("Health")
			if h and h.Value <= 0 then
				running = false
				break
			end
			local char = Players.LocalPlayer.Character
			local hum = char and char:FindFirstChildWhichIsA("Humanoid")
			if hum and hum.Health > 0 then
				if handheld or char:FindFirstChild("StandMorph") then
					FarmUtil.UseMove("m1")
					local remote = char:FindFirstChild("RemoteEvent")
					if remote then
						if game:GetService("CollectionService"):HasTag(enemy, "Blocking") then
							remote:FireServer("InputBegan", { Input = Enum.KeyCode.R })
						end
						local keys = getgenv().AutoUseStandSkillKeys or {"E"}
						for _, keyName in ipairs(keys) do
							local skillKey = keyName and Enum.KeyCode[keyName] or nil
							if skillKey then
								remote:FireServer("InputBegan", { Input = skillKey })
							end
						end
					end
				else
					task.wait(0.3)
				end
			else
				Players.LocalPlayer.CharacterAdded:Wait()
				if not handheld then FarmUtil.EquipStand() end
				task.wait(0.3)
			end
			task.wait(farmStepWait())
		end
		if moneyConn then
			moneyConn:Disconnect()
			moneyConn = nil
		end

		local bufUntil = tick() + NPC_KILL_POST_BUFFER_SEC
		while noQuestKillEnabled and tick() < bufUntil do
			local char = Players.LocalPlayer.Character
			local hum = char and char:FindFirstChildWhichIsA("Humanoid")
			if hum and hum.Health > 0 then
				if char:FindFirstChild("StandMorph") then
					FarmUtil.UseMove("m1")
					local remote = char:FindFirstChild("RemoteEvent")
					if remote then
						local keys = getgenv().AutoUseStandSkillKeys or {"E"}
						for _, keyName in ipairs(keys) do
							local skillKey = keyName and Enum.KeyCode[keyName] or nil
							if skillKey then
								remote:FireServer("InputBegan", { Input = skillKey })
							end
						end
					end
				else
					task.wait(0.3)
				end
			end
			task.wait(farmStepWait())
		end

		if heartbeat then heartbeat:Disconnect() end
		stopQuestNPCView()
		local char = Players.LocalPlayer.Character
		if char then
			clearFocusCam(char)
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = true end
			end
		end
	end

	QuestLeft = QuestTab:Section("Quest Controller", "Left", "target")
	QuestRight = QuestTab:Section("NPC Farm & Tools", "Right", "swords")

	getgenv().QuestDelay = tonumber(getgenv().QuestDelay) or 0.6
	getgenv().QuestMethod = getgenv().QuestMethod or "With Stand"
	getgenv().CompletedQuest = false
	getgenv().QuestFarmEnabled = false
	getgenv().NPCFarmEnabled = false
	getgenv().NoStandNotified = false
	getgenv().TargetNPC = getgenv().TargetNPC or ""
	getgenv().AutoUseStandSkillKey = "E"
	getgenv().LastQuestNotifyTime = 0
	getgenv().QuestNotifyCooldown = 5
	getgenv().PreviousQuest = nil
	if getgenv().AutoSelectBestQuest == nil then getgenv().AutoSelectBestQuest = true end

	if #ParsedQuests == 0 then
		for questName in pairs(QuestInfo) do table.insert(ParsedQuests, questName) end
		table.sort(ParsedQuests)
	end
	if #ParsedQuests == 0 then table.insert(ParsedQuests, "No quests available") end

	local initialManualQuest = getgenv().SelectedQuest
	if not (type(initialManualQuest) == "string" and QuestInfo[initialManualQuest]) then
		initialManualQuest = GetLowestLevelQuest() or ParsedQuests[1]
	end
	QuestRuntime.ManualQuest = initialManualQuest
	getgenv().SelectedQuest = initialManualQuest
	QuestStatusLabel = QuestLeft:Paragraph("Automation Status", "Ready. Choose a quest, then enable Quest Farm.")
	QuestProgressLabel = QuestLeft:Paragraph("Selected Target", "No target selected")
	_G.QuestCurrentQuestLabelObj = QuestProgressLabel
	QuestLeft:Divider()

	local AutoSelectBestQuestToggle = nil
	QuestDropdown = QuestLeft:Dropdown("Manual Quest Selection", ParsedQuests, initialManualQuest or "No quests available", function(selected)
		if type(selected) == "table" then selected = selected[1] end
		if not (type(selected) == "string" and QuestInfo[selected]) then return end

		if getgenv().AutoSelectBestQuest then
			getgenv().AutoSelectBestQuest = false
			if AutoSelectBestQuestToggle then
				for _, methodName in ipairs({"SetValue", "Set", "SetState"}) do
					local ok, method = pcall(function()
						return AutoSelectBestQuestToggle[methodName]
					end)
					if ok and type(method) == "function" then
						local applied = pcall(function()
							method(AutoSelectBestQuestToggle, false)
						end)
						if applied then break end
					end
				end
			end
		end

		QuestRuntime.ManualQuest = selected
		getgenv().SelectedQuest = selected
		if not FarmState.Active then FarmState.CurrentQuest = nil end
		if FarmState.Active then QuestRuntime.OverrideRequested = false end
		setQuestStatus("Manual target selected", "Selected: " .. selected .. ". Quest Farm will request this target once when the next quest cycle begins.")
		Window:Notify("Quest Farm", "Manual quest selected: " .. selected, 3)
	end)

	AutoSelectBestQuestToggle = QuestLeft:Toggle("Auto Select Best Quest", getgenv().AutoSelectBestQuest == true, function(state)
		getgenv().AutoSelectBestQuest = state == true
		if state then
			QuestRuntime.OverrideRequested = false
			local currentLevel = GetPlayerLevel()
			local best = GetBestQuestForLevel(currentLevel)
			setQuestStatus("Automatic selection", "Auto mode is ON. Player level: " .. tostring(currentLevel) .. ". Next target: " .. tostring(best or "waiting for an available quest") .. ". The target is recalculated after each completed quest cycle.")
			Window:Notify("Quest Farm", "Auto selection enabled at level " .. tostring(currentLevel) .. ". Target: " .. tostring(best or "none available") .. ". The next target is recalculated after completion.", 4)
		else
			local manual = QuestRuntime.ManualQuest or GetLowestLevelQuest()
			if manual then
				QuestRuntime.ManualQuest = manual
				getgenv().SelectedQuest = manual
			end
			setQuestStatus("Manual selection", "Auto mode is OFF. Quest Farm will use your selected quest: " .. tostring(manual or "choose a quest") .. ". It won't replace it with the best-for-level quest.")
			Window:Notify("Quest Farm", "Auto Select Best Quest disabled. Your manual selection will be respected.", 3)
		end
	end, "When enabled, recalculates the highest quest available for your level after each completed quest cycle. When disabled, keeps using your chosen quest.", "list-check")

	QuestMethodDropdown = QuestLeft:Dropdown("Combat Method", {"With Stand", "Without Stand"}, getgenv().QuestMethod, function(selected)
		if selected ~= "With Stand" and selected ~= "Without Stand" then return end
		getgenv().QuestMethod = selected
		FarmConfig.FarmingMethod = selected == "With Stand" and "Auto (Detect)" or "Handheld/Fist"
		setQuestStatus("Combat method updated", "Quest combat will use " .. selected .. ". The setting applies to the next combat action.")
	end, "Choose whether the farm uses your stand or handheld attacks.")

	getgenv().AutoUseStandSkillKeys = getgenv().AutoUseStandSkillKeys or {"E"}
	QuestLeft:MultiDropdown("Auto Use Stand Skills", {"B","C","E","F","G","H","I","J","K","L","M","N","O","P","T","U","V","X","Y","Z"}, getgenv().AutoUseStandSkillKeys, function(selectedList)
		selectedList = selectedList or {}
		getgenv().AutoUseStandSkillKeys = selectedList
		setQuestStatus("Skill keys updated", "Automatic skill keys: " .. (#selectedList > 0 and table.concat(selectedList, ", ") or "none") .. ".")
		if #selectedList > 2 then
			local skillTree = player:FindFirstChild("StandSkillTree")
			local hasUnlearned = false
			if skillTree then
				for _, skill in ipairs(skillTree:GetChildren()) do
					if skill:IsA("ValueBase") and skill.Value ~= true then hasUnlearned = true break end
				end
			end
			if hasUnlearned then
				Window:Notify("Quest Farm", "Multiple skills selected. Learning available stand skills in the background.", 4)
				task.spawn(function() pcall(learnAllSkills) end)
			end
		end
	end, "Select the stand skill keys to repeat during each combat encounter.")

	QuestLeft:Slider("Combat Loop Delay", 0, 0.25, 0, 0.01, function(value)
		FarmConfig.KillLoopDelay = math.clamp(tonumber(value) or 0, 0, 0.25)
	end, "Increase this slightly if attacks are being sent too quickly.")
	QuestLeft:Slider("Quest Check Delay", 0.1, 1, 0.35, 0.05, function(value)
		FarmConfig.QuestCheckDelay = math.clamp(tonumber(value) or 0.35, 0.1, 1)
	end, "How often the farm rechecks progress when not fighting.")

	QuestLeft:Divider()
	local QuestFarmToggle
	local function resetQuestFarmToggle()
		if QuestFarmToggle and type(QuestFarmToggle.Set) == "function" then
			pcall(function() QuestFarmToggle:Set(false, true) end)
		end
	end
	QuestFarmToggle = QuestLeft:Toggle("Enable Quest Farm", getgenv().QuestFarmEnabled == true, function(value)
		if value then
			if config.canStart and not config.canStart() then
				setQuestStatus("Blocked by another farm", "Stop Auto Farm, Auto Prestige, and selling before starting Quest Farm.")
				Window:Notify("Quest Farm", "Stop Auto Farm, Auto Prestige, and selling before starting Quest Farm.", 4)
				resetQuestFarmToggle()
				return
			end
			if getgenv().normalFarmOn or getgenv().afkFarmOn or getgenv().afkUnderneathFarmOn or getgenv().safePlaceFarmOn then
				setQuestStatus("Blocked by item farm", "Turn off Item Farm before starting Quest Farm.")
				Window:Notify("Quest Farm", "Item Farm is running. Disable it first.", 4)
				resetQuestFarmToggle()
				return
			end
			if getgenv().NPCFarmEnabled then
				setQuestStatus("Blocked by NPC Farm", "Turn off the standalone NPC Farm before starting Quest Farm.")
				Window:Notify("Quest Farm", "NPC Farm is running. Disable it first.", 4)
				resetQuestFarmToggle()
				return
			end
			if not getgenv().AutoSelectBestQuest and not (QuestRuntime.ManualQuest and QuestInfo[QuestRuntime.ManualQuest]) then
				setQuestStatus("Choose a quest", "Select a manual quest before starting with Auto Select Best Quest disabled.")
				Window:Notify("Quest Farm", "Choose a quest first, or enable Auto Select Best Quest.", 4)
				resetQuestFarmToggle()
				return
			end
			local root = FarmUtil.GetHRP()
			FarmState.OriginalCFrame = root and root.CFrame or nil
			FarmState.CurrentQuest = nil
			FarmState.CompletedQuest = false
			QuestRuntime.ActiveQuest = nil
			QuestRuntime.LastAcceptAttempt = 0
			QuestRuntime.LastAcceptQuest = nil
			QuestRuntime.LastTurnInAttempt = 0
			QuestRuntime.DialogueTarget = nil
			QuestRuntime.OverrideRequested = false
			FarmState.Active = true
			getgenv().QuestFarmEnabled = true
			getgenv().CompletedQuest = false
			if enableNoclip then pcall(enableNoclip) end
			local startLevel = GetPlayerLevel()
			local chosen = getgenv().AutoSelectBestQuest and GetBestQuestForLevel(startLevel) or QuestRuntime.ManualQuest
			setQuestStatus("Quest Farm starting", "Player level: " .. tostring(startLevel) .. ". Target: " .. tostring(chosen or "the selected target") .. ". The selected quest giver will be opened once, then its configured objective will be farmed.")
			Window:Notify("Quest Farm", "Started. The selected quest giver will be contacted once per quest cycle; objective farming follows the selected target, not detected quest names.", 3)
			task.spawn(function()
				local ok, err = pcall(FarmLoop)
				if not ok then
					warn("[Quest Farm] Main loop stopped: " .. tostring(err))
					FarmState.Active = false
					FarmState.CurrentQuest = nil
					FarmState.CompletedQuest = false
					getgenv().QuestFarmEnabled = false
					getgenv().CompletedQuest = false
					resetQuestFarmToggle()
					stopQuestNPCView()
					clearFocusCam(FarmUtil.GetCharacter())
					if disableNoclip then pcall(disableNoclip) end
					if not noQuestKillEnabled and farmReleaseNoclip then pcall(farmReleaseNoclip, FarmUtil.GetCharacter()) end
					setQuestStatus("Stopped after error", "The farm recovered from a runtime error: " .. tostring(err))
					Window:Notify("Quest Farm", "Stopped after an error. Details were written to the executor console.", 6)
					if FarmState.OriginalCFrame then
						local currentRoot = FarmUtil.GetHRP()
						if currentRoot then pcall(function() currentRoot.CFrame = FarmState.OriginalCFrame end) end
						FarmState.OriginalCFrame = nil
					end
				end
			end)
		else
			FarmState.Active = false
			FarmState.CurrentQuest = nil
			FarmState.CompletedQuest = false
			QuestRuntime.ActiveQuest = nil
			getgenv().QuestFarmEnabled = false
			getgenv().CompletedQuest = false
			stopQuestNPCView()
			if not noQuestKillEnabled and farmReleaseNoclip then pcall(farmReleaseNoclip, FarmUtil.GetCharacter()) end
			clearFocusCam(FarmUtil.GetCharacter())
			if FarmState.OriginalCFrame then
				local root = FarmUtil.GetHRP()
				if root then pcall(function() root.CFrame = FarmState.OriginalCFrame end) end
				FarmState.OriginalCFrame = nil
			end
			if disableNoclip then pcall(disableNoclip) end
			setQuestStatus("Stopped", "Quest Farm is stopped. Your manual quest selection has been kept.")
			Window:Notify("Quest Farm", "Stopped. Your selected quest was saved.", 3)
		end
	end, "Request the selected quest once, farm its configured objective, turn it in, and recalculate the next target from your level.", "play")

	QuestRight:Divider()
	local function GetAllNPCs()
		local NPCs, seen = {}, {}
		local living = workspace:FindFirstChild("Living")
		if living then
			for _, npc in ipairs(living:GetChildren()) do
				if npc:FindFirstChild("Spawn") and not seen[npc.Name] then
					seen[npc.Name] = true
					table.insert(NPCs, npc.Name)
				end
			end
		end
		table.sort(NPCs)
		return NPCs
	end

	local NPCList = GetAllNPCs()
	if #NPCList == 0 then NPCList = {"Vampire"} end
	local NPCDropdown = QuestRight:Dropdown("NPC Target", NPCList, getgenv().TargetNPC ~= "" and getgenv().TargetNPC or NPCList[1], function(selected)
		if type(selected) ~= "string" or selected == "" then return end
		getgenv().TargetNPC = selected
		noQuestKillTarget = selected
		Window:Notify("NPC Farm", "Target saved: " .. selected, 3)
	end, "Choose a target for the separate no-quest NPC farm.")

	if getgenv().TargetNPC == "" then getgenv().TargetNPC = NPCList[1] or "Vampire" end
	noQuestKillTarget = getgenv().TargetNPC
	local livingFolder = workspace:FindFirstChild("Living")
	if livingFolder then
		livingFolder.ChildAdded:Connect(function(child)
			if not child or not child:FindFirstChild("Spawn") then return end
			if NPCDropdown and NPCDropdown.Add then NPCDropdown:Add(child.Name) end
		end)
	end

	QuestRight:Toggle("Enable NPC Farm", false, function(state)
		if state then
			if getgenv().normalFarmOn or getgenv().afkFarmOn or getgenv().afkUnderneathFarmOn or getgenv().safePlaceFarmOn then
				Window:Notify("NPC Farm", "Item Farm is running. Disable it first.", 4)
				return
			end
			if getgenv().QuestFarmEnabled then
				Window:Notify("NPC Farm", "Quest Farm is running. Disable it first.", 4)
				return
			end
		end
		getgenv().NPCFarmEnabled = state == true
		noQuestKillEnabled = state == true
		if state then
			if getgenv().TargetNPC == "" then
				Window:Notify("NPC Farm", "Choose an NPC first.", 4)
				getgenv().NPCFarmEnabled = false
				noQuestKillEnabled = false
				return
			end
			Window:Notify("NPC Farm", "Started farming: " .. getgenv().TargetNPC, 3)
			if enableNoclip then pcall(enableNoclip) end
			task.spawn(function()
				while noQuestKillEnabled do
					pcall(killNPCNoQuest, noQuestKillTarget)
					task.wait(0.2)
				end
				if disableNoclip then pcall(disableNoclip) end
				Window:Notify("NPC Farm", "Stopped farming.", 3)
			end)
			task.spawn(function()
				while noQuestKillEnabled do
					task.wait(2.5)
					if not noQuestKillEnabled then break end
					if isHandheldMethod() then continue end
					local char = Players.LocalPlayer.Character
					if char then
						local ss = char:FindFirstChild("SummonedStand")
						if not (ss and ss.Value) then pcall(FarmUtil.EquipStand) end
					end
				end
			end)
		else
			noQuestKillEnabled = false
			if disableNoclip then pcall(disableNoclip) end
			if not FarmState.Active and farmReleaseNoclip then pcall(farmReleaseNoclip, Players.LocalPlayer.Character) end
			Window:Notify("NPC Farm", "Stopped farming.", 3)
		end
	end, "Farm a selected NPC without requiring a quest.", "swords")

	QuestRight:Button("Show Stats", function()
		local statsText = "Stand: " .. tostring(PlayerStand.Value) .. " | Level: " .. tostring(PlayerLevel.Value) .. " | Pity: " .. tostring(roundTwo(getPity())) .. " | Money: $" .. tostring(PlayerMoney.Value) .. " | Spec: " .. tostring(PlayerSpec.Value)
		Window:Notify("Player Stats", statsText, 10)
	end, "Display your current character stats.", "chart-no-axes-column")

	QuestRight:Button("Show Active Quests", function()
		local quests = getQuests()
		local names = {}
		for name in pairs(quests) do table.insert(names, tostring(name)) end
		table.sort(names)
		Window:Notify("Active Quests", #names > 0 and table.concat(names, "\n") or "No active quests.", 6)
	end, "List the quest cards currently visible in your HUD.", "list")

	QuestRight:Button("Learn All Stand Skills", function()
		if getgenv().autoPrestigeEnabled or getgenv().autoPrestigeBusy then
			Window:Notify("Skills", "Auto Prestige is running. Stop it first.", 5)
			return
		end
		task.spawn(function()
			local ok, err = pcall(learnAllSkills)
			if ok then Window:Notify("Skills", "Skill learning requests sent.", 4)
			else Window:Notify("Skills", "Skill learning failed: " .. tostring(err), 5) end
		end)
	end, "Send learning requests for the known stand and spec skills.", "graduation-cap")

	farmThrottledHeartbeat(function()
		if not (FarmState.Active or noQuestKillEnabled or getgenv().__EldiabloAutoStwActive) then return end
		local char = Players.LocalPlayer.Character
		if not char then return end
		farmEnsureNoclip(char)
	end, 12, 30)

	notify("", "Mob Farm ready.", 4)
end
]==])()
    if type(_G.__PhantomQuestFarmFactory) ~= "function" then
        error("Quest farm module did not return a factory function")
    end
    _G.__PhantomQuestFarm = _G.__PhantomQuestFarmFactory(
        _G.__PhantomQuestFarmWindowProxy,
        LP,
        _G.__PhantomQuestFarmWrapTab(_G.__PhantomQuestFarmTab),
        _G.__PhantomQuestFarmConfig
    )
    _G.__PhantomQuestFarmLoaded = true
end)
if not _G.__PhantomQuestFarmOk then
    _G.__PhantomQuestFarmLoadError = _G.__PhantomQuestFarmErr
end

if not _G.__PhantomQuestFarmLoaded then
    warn("[Methion] Quest Farm module failed to load: " .. tostring(_G.__PhantomQuestFarmLoadError or "unknown error"))
    pcall(function()
        Window:Notify({
            Title = "Quest Farm",
            Content = "Module did not start. Check executor output for the error.",
            Type = "Error",
            Duration = 6,
        })
    end)
end

ItemESP.scan()

if _G.__PhantomViewerAddTarget then
    for part, data in pairs(Tracked) do
        if part and part.Parent and part:IsDescendantOf(workspace) then
            local target = part:FindFirstAncestorOfClass("Model") or part
            pcall(_G.__PhantomViewerAddTarget, target)
        end
    end
end

local NotifiedSpawnParts = setmetatable({}, {__mode = "k"})
Farm.SpawnPromptConnections = Farm.SpawnPromptConnections or setmetatable({}, {__mode = "k"})

local function spawnedItemInfo(obj)
    if not obj then return nil end
    local name, part
    if obj:IsA("ProximityPrompt") then
        name = obj.ObjectText or ""
        if not ESP_ITEMS[name] then return nil end
        part = Utils.basePart(obj)
    elseif obj:IsA("BasePart") and ESP_ITEMS[obj.Name] then
        name, part = obj.Name, obj
    end

    if name and part and not ItemESP.isPlayerOwned(obj, part) then
        local target = part:FindFirstAncestorOfClass("Model") or part
        if _G.__PhantomViewerAddTarget then
            pcall(_G.__PhantomViewerAddTarget, target)
        end
        return name, part
    end
    return nil
end

local function setBoostedSpawnTarget(itemName, itemPart)
    if not State.Farm or not Config.Boosted or not itemName or not itemPart
        or not itemPart.Parent or not itemPart:IsDescendantOf(workspace)
        or ItemESP.isPlayerOwned(nil, itemPart)
        or not Farm.allowed(itemName) then
        return
    end

    Farm.queueBoostedTarget(itemPart)
end

function Farm.notifySpawnedItem(itemName, itemPart)
    if not itemName or not itemPart then return end
    local spawnKey = itemPart:FindFirstAncestorOfClass("Model") or itemPart
    if not State.NotifyItemSpawn or not Config.NotifyItemSpawn or NotifiedSpawnParts[spawnKey] then return end
    NotifiedSpawnParts[spawnKey] = true
    pcall(function()
        AirflowCompat:Notify({
            Title = "Item Spawned",
            Content = itemName .. " has spawned",
            Icon = "bell",
            Type = "Info",
            Duration = 3,
        })
    end)
end

workspace.DescendantAdded:Connect(function(o)

    if not o or not o.Parent then return end
    if o:IsA("ProximityPrompt") then
        ItemESP.register(o)
        local itemName, itemPart = spawnedItemInfo(o)
        if itemName then
            setBoostedSpawnTarget(itemName, itemPart)
            Farm.notifySpawnedItem(itemName, itemPart)
        elseif not Farm.SpawnPromptConnections[o] then
            Farm.SpawnPromptConnections[o] = o:GetPropertyChangedSignal("ObjectText"):Connect(function()
                if not o.Parent then
                    local connection = Farm.SpawnPromptConnections[o]
                    if connection then connection:Disconnect() end
                    Farm.SpawnPromptConnections[o] = nil
                    return
                end
                local lateName, latePart = spawnedItemInfo(o)
                if lateName and latePart then
                    ItemESP.register(o)
                    setBoostedSpawnTarget(lateName, latePart)
                    Farm.notifySpawnedItem(lateName, latePart)
                    local connection = Farm.SpawnPromptConnections[o]
                    if connection then connection:Disconnect() end
                    Farm.SpawnPromptConnections[o] = nil
                end
            end)
        end
    elseif o:IsA("BasePart") then
        ItemESP.register(o)
        local itemName, itemPart = spawnedItemInfo(o)
        if itemName then
            setBoostedSpawnTarget(itemName, itemPart)
            Farm.notifySpawnedItem(itemName, itemPart)
        end
    end
end)

Rejoin.start()
Loops.noclip()
Loops.farm()
Loops.itemLabels()
Loops.pending()
Loops.playerESP()
Loops.spectate()
Loops.playerInfo()
Loops.counter()

task.spawn(function()
    local enterChunk, enterError = loadstring(ENTER_GAME_SOURCE)
    if not enterChunk then
        warn("[AutoPlay] Could not compile enter-game script: " .. tostring(enterError))
        return
    end
    enterChunk()
end)

_G.__MethionSHReady = true
if SH_AUTOSTART then
    task.defer(function()
        SHController:start()
    end)
end

-- ================= CHOPA: Graphics tab (lighter rendering for farming) =================
task.spawn(function()
    local ok, err = pcall(function()
        local UIS = game:GetService("UserInputService")
        -- Chopa: MAX SAVING by default (bots should not load the PC). 3D and 30 FPS come back by themselves
        -- while the bot delivers an order (trade window / money drop / screenshot).
        local HC = _G.__ChopaHasConfig == true     -- no config: graphics untouched until the user switches it on
        local G = {
            noRender = false, blackScreen = true, background = false, focused = true,
            fpsOn = false, fps = 60, quality = false, effects = false, textures = false,
            hidePlayers = false, mute = false, extra = false,
            saved = setmetatable({}, { __mode = "k" }), conns = {},
        }

        -- 3D rendering + black screen + FPS cap (one place decides the final state)
        local overlay
        local function makeOverlay()
            if overlay and overlay.Parent then return overlay end
            local gui = Instance.new("ScreenGui")
            gui.Name = "ChopaBlackScreen"
            gui.IgnoreGuiInset = true
            gui.ResetOnSpawn = false
            gui.DisplayOrder = -100          -- the menu lives in CoreGui and stays on top
            local f = Instance.new("Frame")
            f.Size = UDim2.fromScale(1, 1)
            f.BackgroundColor3 = Color3.new(0, 0, 0)
            f.BorderSizePixel = 0
            f.Parent = gui
            local t = Instance.new("TextLabel")
            t.Name = "Info"
            t.BackgroundTransparency = 1
            t.Size = UDim2.new(1, 0, 0, 60)
            t.Position = UDim2.new(0, 0, 0.5, -30)
            t.Font = Enum.Font.GothamBold
            t.TextSize = 20
            t.TextColor3 = Color3.fromRGB(96, 165, 250)
            t.Text = "Chopa — 3D rendering off"
            t.Parent = f
            gui.Parent = LP:WaitForChild("PlayerGui")
            overlay = gui
            return gui
        end
        local function setFps(n)
            if setfpscap then pcall(setfpscap, n) end
        end
        local function refreshRender()
            local away = G.background and not G.focused
            local delivering = _G.__ChopaAgent and _G.__ChopaAgent.delivering
            local render = delivering or not (G.noRender or away)
            pcall(function() RunService:Set3dRenderingEnabled(render) end)
            if not render and G.blackScreen then makeOverlay().Enabled = true
            elseif overlay then overlay.Enabled = false end
            if delivering then setFps(math.max(G.fpsOn and G.fps or 60, 30))
            elseif G.fpsOn then setFps(G.fps)      -- background mode only turns 3D off, FPS follows "FPS cap"
            else setFps(60) end
        end
        _G.__ChopaRefreshRender = refreshRender
        table.insert(G.conns, UIS.WindowFocusReleased:Connect(function() G.focused = false; refreshRender() end))
        table.insert(G.conns, UIS.WindowFocused:Connect(function() G.focused = true; refreshRender() end))
        task.spawn(function()          -- money / arrows on the black screen
            while task.wait(2) do
                if overlay and overlay.Enabled then
                    local money = "?"
                    pcall(function() money = tostring(LP.PlayerStats.Money.Value) end)
                    local arrows = 0
                    for _, c in ipairs({ LP:FindFirstChild("Backpack"), LP.Character }) do
                        if c then for _, t in ipairs(c:GetChildren()) do
                            if t:IsA("Tool") and t.Name:lower():find("lucky arrow", 1, true) then arrows += 1 end
                        end end
                    end
                    pcall(function()
                        overlay.Frame.Info.Text = string.format("Chopa — 3D rendering off\n$%s · Lucky Arrows: %d · %s",
                            money, arrows, os.date("%H:%M:%S"))
                    end)
                end
            end
        end)

        -- remembers original values so every option can be switched back off
        local function remember(obj, props)
            local s = G.saved[obj]
            if not s then s = {}; G.saved[obj] = s end
            for _, p in ipairs(props) do
                if s[p] == nil then pcall(function() s[p] = obj[p] end) end
            end
        end
        local function restore(obj, props)
            local s = G.saved[obj]
            if not s then return end
            for _, p in ipairs(props) do
                if s[p] ~= nil then pcall(function() obj[p] = s[p] end); s[p] = nil end
            end
        end
        local EFFECT = { ParticleEmitter = true, Trail = true, Beam = true, Fire = true, Smoke = true, Sparkles = true, Explosion = false }
        local function effectObj(o)
            if o:IsA("PostEffect") or o:IsA("Atmosphere") then return true end
            return EFFECT[o.ClassName] == true
        end
        local function fixEffect(o, on)
            if not effectObj(o) then return end
            if o:IsA("Atmosphere") then
                if on then remember(o, { "Density" }); o.Density = 0 else restore(o, { "Density" }) end
            elseif on then remember(o, { "Enabled" }); pcall(function() o.Enabled = false end)
            else restore(o, { "Enabled" }) end
        end
        local function fixTexture(o, on)
            if o:IsA("BasePart") then
                if on then
                    remember(o, { "Material", "Reflectance", "CastShadow" })
                    pcall(function() o.Material = Enum.Material.SmoothPlastic; o.Reflectance = 0; o.CastShadow = false end)
                else restore(o, { "Material", "Reflectance", "CastShadow" }) end
            elseif o:IsA("Decal") or o:IsA("Texture") then
                if on then remember(o, { "Transparency" }); pcall(function() o.Transparency = 1 end)
                else restore(o, { "Transparency" }) end
            end
        end
        local function sweep(fn, on)
            task.spawn(function()
                local n = 0
                for _, root in ipairs({ workspace, Lighting }) do
                    for _, o in ipairs(root:GetDescendants()) do
                        fn(o, on)
                        n += 1
                        if n % 250 == 0 then task.wait() end
                    end
                end
            end)
        end
        -- new objects (items, skills, other players' effects) get the same treatment
        local function onAdded(o)
            if G.effects then fixEffect(o, true) end
            if G.textures then fixTexture(o, true) end
        end
        table.insert(G.conns, workspace.DescendantAdded:Connect(function(o) if G.effects or G.textures then task.defer(onAdded, o) end end))
        table.insert(G.conns, Lighting.DescendantAdded:Connect(function(o) if G.effects or G.textures then task.defer(onAdded, o) end end))

        local function hideCharacter(char, hide)
            for _, o in ipairs(char:GetDescendants()) do
                if o:IsA("BasePart") or o:IsA("Decal") then
                    pcall(function() o.LocalTransparencyModifier = hide and 1 or 0 end)
                end
            end
        end
        task.spawn(function()
            while task.wait(1) do
                if G.hidePlayers then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then hideCharacter(p.Character, true) end
                    end
                end
            end
        end)

        -- this window shows only real tabs, so the Graphics tab is created directly in the library
        local tab = adaptTab(Window.Raw:Tab({ Name = "Graphics", Icon = "monitor", Desc = "Lighter graphics and FPS for farming." }), "Graphics")
        -- presets switch the controls through their config flags (the UI updates and the callbacks run)
        local function applyPreset(values)
            for key, value in pairs(values) do
                local obj = AirflowLibrary.Flags and AirflowLibrary.Flags["Chopa/" .. key]
                if obj and type(obj.Set) == "function" then pcall(function() obj:Set(value) end) end
            end
        end
        local render = tab:Section({ Title = "Rendering", Side = "left" })
        local quality = tab:Section({ Title = "Quality", Side = "right" })
        local menu = tab:Section({ Title = "Main menu", Side = "left" })
        local SM = _G.__ChopaSkipMenu
        local menuInfo = menu:Paragraph({ Title = "Fast menu skip", Desc = "" })
        local function menuStatus()
            pcall(function()
                menuInfo:SetDesc(SM.took and string.format("Last skip: %.2f s", SM.took)
                    or (SM.enabled and "Runs first on every execute / rejoin." or "Off"))
            end)
        end
        menuStatus()
        menu:Toggle({ Title = "Auto skip main menu", Desc = "Presses Play/Skip instantly when the script starts (also after rejoin / hop).",
            Value = SM.enabled, KeepDefault = true, NoSave = true, Callback = function(v)
                SM.enabled = v == true
                if writefile then pcall(writefile, SM.file, SM.enabled and "1" or "0") end
                menuStatus()
            end })
        menu:Button({ Title = "Skip menu now", Icon = "skip-forward", Callback = function()
            task.spawn(function() pcall(SM.run); menuStatus() end)
        end })
        task.delay(8, menuStatus)
        local status = render:Paragraph({ Title = "Status", Desc = "" })

        render:Toggle({ Title = "No 3D Render", Desc = "Stops drawing the world (huge GPU/CPU saving). Farming keeps working; 3D comes back for deliveries.",
            Value = true, Callback = function(v) G.noRender = v == true; refreshRender() end })
        render:Toggle({ Title = "Black screen", Desc = "Black screen with money and arrows while 3D is off.",
            Value = true, Callback = function(v) G.blackScreen = v == true; refreshRender() end })
        render:Toggle({ Title = "Save power in background", Desc = "When Roblox is not the active window: 3D off (FPS is set only by FPS cap).",
            Value = true, Callback = function(v) G.background = v == true; refreshRender() end })
        render:Toggle({ Title = "FPS cap", Desc = setfpscap and "Limit FPS to the value below (30 while delivering)." or "Your executor has no setfpscap.",
            Value = false, Callback = function(v) G.fpsOn = v == true; refreshRender() end })
        render:Slider({ Title = "FPS limit", Desc = "Used only while FPS cap is on. Lower = less CPU.", Value = { Min = 5, Max = 240, Default = 60 },
            Step = 5, Callback = function(v) G.fps = math.clamp(tonumber(v) or 60, 5, 240); refreshRender() end })

        quality:Toggle({ Title = "Lowest quality level", Desc = "Sets Roblox graphics quality to 1.", Value = true,
            Callback = function(v)
                G.quality = v == true
                pcall(function()
                    local r = settings().Rendering
                    if G.quality then
                        G.oldQuality = G.oldQuality or r.QualityLevel
                        r.QualityLevel = Enum.QualityLevel.Level01
                    elseif G.oldQuality then
                        r.QualityLevel = G.oldQuality
                    end
                end)
                pcall(function()
                    local ugs = UserSettings():GetService("UserGameSettings")
                    if G.quality then
                        G.oldSaved = G.oldSaved or ugs.SavedQualityLevel
                        ugs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
                    elseif G.oldSaved then
                        ugs.SavedQualityLevel = G.oldSaved
                    end
                end)
            end })
        quality:Toggle({ Title = "Remove effects", Desc = "Particles, trails, beams, blur, bloom, atmosphere.", Value = true,
            Callback = function(v) G.effects = v == true; sweep(fixEffect, G.effects) end })
        quality:Toggle({ Title = "Remove textures & shadows", Desc = "Plastic materials, no decals or shadows.", Value = true,
            Callback = function(v)
                G.textures = v == true
                pcall(function()
                    if G.textures then remember(Lighting, { "GlobalShadows", "FogEnd" }); Lighting.GlobalShadows = false; Lighting.FogEnd = 1e9
                    else restore(Lighting, { "GlobalShadows", "FogEnd" }) end
                end)
                pcall(function()
                    local t = workspace:FindFirstChildOfClass("Terrain")
                    if not t then return end
                    if G.textures then remember(t, { "Decoration", "WaterWaveSize", "WaterReflectance" }); t.Decoration = false; t.WaterWaveSize = 0; t.WaterReflectance = 0
                    else restore(t, { "Decoration", "WaterWaveSize", "WaterReflectance" }) end
                end)
                sweep(fixTexture, G.textures)
            end })
        quality:Toggle({ Title = "Hide other players", Desc = "Only on your screen. Delivery still works.", Value = false,
            Callback = function(v)
                G.hidePlayers = v == true
                if not G.hidePlayers then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LP and p.Character then hideCharacter(p.Character, false) end
                    end
                end
            end })
        quality:Toggle({ Title = "Mute game", Desc = "Master volume 0 (no sound decoding).", Value = true,
            Callback = function(v)
                G.mute = v == true
                pcall(function()
                    local ugs = UserSettings():GetService("UserGameSettings")
                    if G.mute then G.oldVolume = G.oldVolume or ugs.MasterVolume; ugs.MasterVolume = 0
                    else ugs.MasterVolume = G.oldVolume or 1 end
                end)
            end })
        quality:Toggle({ Title = "Extra CPU saving", Value = true,
            Desc = "Lowest mesh detail, no sounds playing, no terrain decoration, simple lighting.",
            Callback = function(v)
                G.extra = v == true
                pcall(function()
                    local r = settings().Rendering
                    if G.extra then
                        G.oldMesh = G.oldMesh or r.MeshPartDetailLevel
                        r.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
                    elseif G.oldMesh then r.MeshPartDetailLevel = G.oldMesh end
                end)
                pcall(function()
                    if G.extra then
                        remember(Lighting, { "Brightness", "EnvironmentDiffuseScale", "EnvironmentSpecularScale" })
                        Lighting.EnvironmentDiffuseScale = 0
                        Lighting.EnvironmentSpecularScale = 0
                    else restore(Lighting, { "Brightness", "EnvironmentDiffuseScale", "EnvironmentSpecularScale" }) end
                end)
                -- stop sounds instead of only muting (no audio work at all)
                task.spawn(pcall, function()
                    local n = 0
                    for _, o in ipairs(workspace:GetDescendants()) do
                        if o:IsA("Sound") then
                            if G.extra then remember(o, { "Playing" }); pcall(function() o.Playing = false end)
                            else restore(o, { "Playing" }) end
                        end
                        n += 1
                        if n % 500 == 0 then task.wait() end
                    end
                end)
            end })
        table.insert(G.conns, workspace.DescendantAdded:Connect(function(o)
            if G.extra and o:IsA("Sound") then task.defer(function() pcall(function() o.Playing = false end) end) end
        end))
        quality:Button({ Title = "Farm preset", Desc = "Lowest quality, no effects/textures, 30 FPS, power saving in background.",
            Icon = "zap", Callback = function()
                applyPreset({
                    ["Graphics/Quality/Toggle:Lowest quality level"] = true,
                    ["Graphics/Quality/Toggle:Remove effects"] = true,
                    ["Graphics/Quality/Toggle:Remove textures & shadows"] = true,
                    ["Graphics/Rendering/Toggle:FPS cap"] = true,
                    ["Graphics/Rendering/Slider:FPS limit"] = 30,
                    ["Graphics/Rendering/Toggle:Save power in background"] = true,
                })
            end })
        quality:Button({ Title = "Max saving (AFK)", Desc = "Everything on: no 3D, 10 FPS, lowest quality, no effects/textures/sound.", Icon = "moon",
            Callback = function()
                applyPreset({
                    ["Graphics/Quality/Toggle:Lowest quality level"] = true,
                    ["Graphics/Quality/Toggle:Remove effects"] = true,
                    ["Graphics/Quality/Toggle:Remove textures & shadows"] = true,
                    ["Graphics/Rendering/Toggle:FPS cap"] = true,
                    ["Graphics/Rendering/Slider:FPS limit"] = 10,
                    ["Graphics/Rendering/Toggle:No 3D Render"] = true,
                    ["Graphics/Rendering/Toggle:Save power in background"] = true,
                    ["Graphics/Quality/Toggle:Mute game"] = true,
                    ["Graphics/Quality/Toggle:Extra CPU saving"] = true,
                })
            end })

        local frames, fps = 0, 0
        table.insert(G.conns, RunService.Heartbeat:Connect(function() frames += 1 end))
        task.spawn(function()
            while task.wait(1) do
                fps, frames = frames, 0
                pcall(function()
                    status:SetDesc(string.format("3D: %s · FPS cap: %s · FPS: %d\nWindow: %s",
                        (G.noRender or (G.background and not G.focused)) and "off" or "on",
                        (G.fpsOn and tostring(G.fps) or "off"),
                        fps, G.focused and "active" or "background"))
                end)
            end
        end)
    end)
    if not ok then warn("[Chopa] Graphics tab failed: " .. tostring(err)) end
end)

-- ================= CHOPA: "Settings" tab — everything that was behind the gear button =================
-- Configurations (save / load / auto save / load on startup), language, theme, menu key, interface.
pcall(function()
    local Library = AirflowLibrary
    local win = Window.Raw
    local tab = win:Tab { Name = "Settings", Desc = "Interface, theme and configuration", Icon = "settings" }

    -- Chopa: "Auto save" is OFF by default and is switched off again on every start / rejoin
    -- (the panel shows it off; you can turn it on for the current session)
    win._autoSaveEnabled = false
    pcall(function() win:_saveUISettings() end)
    local cfgPanel = tab:ConfigPanel { Name = "Configurations" }

    -- Chopa: one config for ALL accounts (same executor workspace). When any account changes a setting,
    -- the config file is saved and every other running account loads it within a few seconds.
    -- New accounts load the shared config on start. Switch: "Sync config to all accounts".
    -- OFF by default; turned on only by hand (chopa_config_sync_on.txt = "1"; the old chopa_config_sync.txt is ignored).
    do
        local HS = game:GetService("HttpService")
        local Sync = { enabled = false, known = nil, file = "chopa_config_sync_on.txt" }
        pcall(function() if isfile and isfile(Sync.file) and readfile(Sync.file) == "1" then Sync.enabled = true end end)
        local function cfgFile(name) return tostring(win.ConfigFolder) .. "/" .. tostring(name or win.ConfigName) .. ".json" end
        local function read(path)
            local ok, c = pcall(function() return isfile(path) and readfile(path) or nil end)
            return ok and c or nil
        end
        local function sharedName()
            local raw = read(tostring(win.ConfigFolder) .. "/_airflow_ui.settings")
            local ok, d = pcall(function() return raw and HS:JSONDecode(raw) end)
            return ok and type(d) == "table" and type(d.ConfigName) == "string" and d.ConfigName ~= "" and d.ConfigName or nil
        end
        -- own saves are not "changes from another account"
        local originalSave = win.SaveConfig
        win.SaveConfig = function(self, name, ...)
            local a, b = originalSave(self, name, ...)
            Sync.known = read(cfgFile(name))
            return a, b
        end
        local function pull(reason)
            if not read(cfgFile()) then return end
            local ok = pcall(function() win:LoadConfig(win.ConfigName) end)
            Sync.known = read(cfgFile())
            if ok and reason then
                pcall(function() win:Notify { Title = "Config", Content = reason, Type = "Info", Duration = 3 } end)
            end
        end
        tab:Toggle {
            Name = "Sync config to all accounts", Desc = "Off by default. When on, every bot uses the same settings: a change on one account is applied on all of them",
            Default = Sync.enabled, Quickable = false,
            Callback = function(v)
                Sync.enabled = v == true
                if writefile then pcall(writefile, Sync.file, Sync.enabled and "1" or "0") end
                -- (Auto save stays as it is: it is off after every rejoin)
            end,
        }
        task.spawn(function()
            repeat task.wait(0.5) until win._autoSaveReady or win._destroyed
            if win._destroyed or not (isfile and readfile) then return end
            if Sync.enabled then
                win._autoSaveEnabled = false                -- Auto save is off after every start / rejoin
                local name = sharedName()
                if name then win.ConfigName = name end
                if not win._autoLoaded then win._autoLoaded = true; pull("Shared config \"" .. tostring(win.ConfigName) .. "\" loaded") end
                pcall(function() cfgPanel:Refresh() end)
            end
            Sync.known = Sync.known or read(cfgFile())
            while not win._destroyed do
                task.wait(3)
                if Sync.enabled then
                    local name = sharedName()
                    if name and name ~= win.ConfigName then
                        win.ConfigName = name
                        pull("Switched to config \"" .. name .. "\" from another account")
                        pcall(function() cfgPanel:Refresh() end)
                    else
                        local current = read(cfgFile())
                        if current and Sync.known and current ~= Sync.known then
                            pull("Settings updated from another account")
                        elseif current and not Sync.known then
                            Sync.known = current
                        end
                    end
                end
            end
        end)
    end

    -- Chopa: Lucky Arrows for trade delivery — auto buy (ON by default, saved in chopa_autobuy.txt)
    -- Chopa: share a config as JSON text (copy to clipboard / paste and load)
    tab:Header("Config JSON", "file-json")
    do
        local HS = game:GetService("HttpService")
        local pasted = ""
        local function cfgPath(name) return tostring(win.ConfigFolder) .. "/" .. tostring(name) .. ".json" end
        local function note(text, kind)
            pcall(function() win:Notify { Title = "Config JSON", Content = text, Type = kind or "Info", Duration = 4 } end)
        end
        tab:Button {
            Name = "Copy config as JSON", Desc = "Saves the current settings and copies them as JSON text", Icon = "copy", Quickable = false,
            Callback = function()
                if type(setclipboard) ~= "function" or type(readfile) ~= "function" then
                    note("This executor has no clipboard / file access", "Warning") return
                end
                local name = tostring(win.ConfigName or "Config")
                local saved, err = pcall(function() win:SaveConfig(name) end)
                local text
                pcall(function() if isfile(cfgPath(name)) then text = readfile(cfgPath(name)) end end)
                if type(text) ~= "string" or text == "" then
                    note("Could not read the config: " .. tostring(saved and "file not found" or err), "Warning") return
                end
                local copied = pcall(setclipboard, text)
                note(copied and ("Config \"" .. name .. "\" copied (" .. #text .. " chars)") or "Clipboard copy failed",
                    copied and "Success" or "Warning")
            end,
        }
        tab:Input {
            Name = "Paste config JSON", Desc = "Paste the JSON text here, then press \"Load pasted JSON\"",
            Placeholder = "{ ... }", Default = "", Quickable = false,
            Callback = function(v) pasted = tostring(v or "") end,
        }
        tab:Button {
            Name = "Load pasted JSON", Desc = "Checks the text and applies it to the current config (the old one is kept as a backup)",
            Icon = "download", Quickable = false,
            Callback = function()
                local text = (pasted:gsub("^%s+", ""):gsub("%s+$", ""))
                if text == "" then note("Paste the JSON first", "Warning") return end
                local ok, data = pcall(function() return HS:JSONDecode(text) end)
                if not ok or type(data) ~= "table" then note("This is not valid JSON", "Warning") return end
                if type(writefile) ~= "function" then note("This executor cannot write files", "Warning") return end
                local name = tostring(win.ConfigName or "Config")
                pcall(function()
                    if isfolder and makefolder and not isfolder(tostring(win.ConfigFolder)) then makefolder(tostring(win.ConfigFolder)) end
                end)
                pcall(function()                     -- backup of the config that gets replaced
                    if isfile(cfgPath(name)) then writefile(cfgPath(name .. "_backup"), readfile(cfgPath(name))) end
                end)
                if not pcall(writefile, cfgPath(name), text) then note("Could not save the config file", "Warning") return end
                local loaded, err = pcall(function() win:LoadConfig(name) end)
                pcall(function() cfgPanel:Refresh() end)
                note(loaded and ("Config applied to \"" .. name .. "\" (backup: " .. name .. "_backup)") or ("Load failed: " .. tostring(err)),
                    loaded and "Success" or "Warning")
            end,
        }
    end

    tab:Header("Lucky Arrows", "shopping-cart")
    do
        local A = _G.__ChopaAgent or {}
        tab:Toggle {
            Name = "Auto buy Lucky Arrows", Quickable = false,
            Desc = "While the bot has no order: buys Lucky Arrows in the shop ($75,000) up to the amount below",
            Default = A.autobuy ~= false,
            Callback = function(v)
                A.autobuy = v == true
                if writefile then pcall(writefile, "chopa_autobuy.txt", A.autobuy and "1" or "0") end
            end,
        }
        tab:Slider {
            Name = "Keep Lucky Arrows", Desc = "Auto buy stops at this many (one trade gives up to 9)",
            Min = 1, Max = 20, Step = 1, Default = A.autobuyCap or 9, Quickable = false,
            Callback = function(v)
                A.autobuyCap = math.clamp(math.floor(tonumber(v) or 9), 1, 50)
                if writefile then pcall(writefile, "chopa_autobuy_cap.txt", tostring(A.autobuyCap)) end
            end,
        }
    end

    tab:Header("Server Hop", "server")
    tab:Dropdown {
        Name = "Server choice", Desc = "Random: any working server. Fewest players: the emptiest working server",
        Options = { "Random", "Fewest players" }, Default = SHController.PickMode, Style = "Popup", Quickable = false,
        Flag = "Chopa/Settings/HopMode",
        Callback = function(v)
            if type(v) == "table" then v = v[1] end
            if v ~= "Random" and v ~= "Fewest players" then return end
            SHController.PickMode = v
            SHController.Candidates, SHController.CandidatesAt = {}, 0
            if writefile then pcall(writefile, "chopa_hop_mode.txt", v) end
        end,
    }

    tab:Header("Language", "languages")
    local langDrop = tab:Dropdown {
        Name = "Interface language", Desc = "Choose the language you are most comfortable with", Options = Library:GetLanguages(),
        Default = Library._lang, Style = "Popup", Quickable = false,
        Callback = function(v) if v then Library:SetLanguage(v) end end,
    }
    table.insert(Library._onLang, function(name)
        if win._destroyed then return end
        langDrop:Set(name, true)
    end)

    tab:Header("Theme", "palette")
    local themeDrop = tab:Dropdown {
        Name = "Theme", Desc = "Recolors the window, popups and floating panels", Options = Library:GetThemes(),
        Default = Library._themeState.Preset, Style = "Popup", SearchAfter = 99, Quickable = false,
        Callback = function(v) if v then Library:SetTheme(v, false, "dropdown") end end,
    }
    local accent = tab:ColorPicker {
        Name = "Accent color", Desc = "Overrides the accent of the current theme", Default = Library:GetPalette().Accent,
        Callback = function(c) Library:SetAccent(c, false, "picker") end,
    }
    tab:Button {
        Name = "Reset accent", Desc = "Go back to the accent of the selected theme", Icon = "rotate-ccw", Quickable = false,
        Callback = function() Library:SetAccent(nil, false, "reset") end,
    }
    table.insert(Library._onTheme, function(source)
        if win._destroyed then return end
        local pal = Library:GetPalette()
        if source ~= "dropdown" then themeDrop:Set(Library._themeState.Preset, true) end
        if source ~= "picker" then accent:Set(pal.Accent, true) end
    end)

    tab:Header("Interface", "layout-dashboard")
    tab:Keybind {
        Name = "Menu key", Desc = "Show or hide the window", Default = win.Keybind, Flag = "AF_MenuKey", Quickable = false,
        OnChanged = function(k)
            if k then win:SetKeybind(k) end
            win:_autoSave()
        end,
    }
    tab:Toggle {
        Name = "Keep on screen", Desc = "Stops the window from being dragged out of view", Default = win.KeepOnScreen, Flag = "AF_KeepOnScreen", Quickable = false,
        Callback = function(v)
            win.KeepOnScreen = v ~= false
            if win._introDone and win.KeepOnScreen then win:_clampToScreen() end
        end,
    }
    tab:Toggle {
        Name = "Collapse to pill", Desc = "Menu key and close button shrink the window into a floating pill", Default = win.MobilePill, Flag = "AF_Pill", Quickable = false,
        Callback = function(v) if v ~= win.MobilePill then win:SetMobilePill(v) end end,
    }
    tab:Stepper {
        Name = "Max notifications", Desc = "How many toasts can stack at once", Min = 1, Max = 8, Step = 1, Default = win.MaxNotifications,
        Flag = "AF_MaxToasts", Quickable = false, Callback = function(v) win.MaxNotifications = v end,
    }
    tab:Button {
        Name = "Test notification", Desc = "Preview the current theme in a toast", Icon = "bell", Quickable = false,
        Callback = function() win:Notify { Title = "Chopa", Content = "Notifications use the active theme.", Type = "Info", Duration = 3 } end,
    }
    tab:QuickAccess { Name = "Quick access", Desc = "Pin buttons, toggles and keybinds as floating shortcuts" }

    -- Chopa: Discord webhook options (flags keep their old path, so saved configs still load)
    _G.__ChopaSettingsTab, _G.__ChopaSettingsWin = adaptTab(tab, "ItemFarmSH"), win
    if _G.__ChopaWebhookUI then
        local okUI, errUI = pcall(_G.__ChopaWebhookUI, _G.__ChopaSettingsTab)
        if not okUI then warn("[Chopa] webhook settings failed: " .. tostring(errUI)) end
        _G.__ChopaWebhookUI = nil
    end

    tab:Header("Danger zone", "triangle-alert")
    tab:Button {
        Name = "Destroy UI", Desc = "Removes the window and every floating panel", Icon = "trash-2", Quickable = false,
        Callback = function()
            win:Confirm {
                Title = "Destroy UI?", Content = "This removes the window and every floating panel.", Icon = "trash-2", ConfirmText = "Destroy",
                Callback = function()
                    task.delay(.24, function() if not win._destroyed then win:Destroy() end end)
                end,
            }
        end,
    }
end)

print("[Chopa] Loaded (Methion SH functions, blue theme)")

pcall(function()
    AirflowCompat:Notify({Title = "Chopa", Content = "Loaded!", Icon = "check", Type = "Success", Duration = 3})
end)

-- ================= CHOPA GLUE: pause the item / candy farm while an order is delivered =================
task.spawn(function()
    local A = _G.__ChopaAgent
    local paused = nil
    while true do
        task.wait(0.2)
        A.farming = State.Farm == true or State.HalloweenCandyFarm == true or paused ~= nil
        local hold = A.delivering or A.pending
        if hold and not paused and (State.Farm or State.HalloweenCandyFarm) then
            paused = { farm = State.Farm, candy = State.HalloweenCandyFarm }
            State.Farm, State.HalloweenCandyFarm = false, false
            State.NoClip = false
            print("[Chopa] Order waiting — item farm paused")
        elseif not hold and paused then
            State.Farm, State.HalloweenCandyFarm = paused.farm, paused.candy
            State.NoClip = true
            pcall(ItemESP.scan)
            paused = nil
            print("[Chopa] Order delivered — item farm resumed")
        end
    end
end)
end;n();return end;do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;if not (string.sub(x.Body,1,8)=="https://")then warn(m);return end;a,x=q({Url=x.Body,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;f()end end