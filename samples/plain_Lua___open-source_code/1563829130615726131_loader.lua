--!nocheck
local API_URL = "https://vora-hub-platform.vercel.app"
local LOADER_PROTOCOL = "2026-09-15"
local LOADER_INTEGRITY = "77d177523928a88c9d42010c2335485267ba1ea564f31d39408001c38da986c3"
local environment = (type(getgenv) == "function" and getgenv()) or _G
local persistKey = environment.VORA_SAVE_KEY ~= false

local key = (type(environment.SCRIPT_KEY) == "string" and environment.SCRIPT_KEY ~= "") and environment.SCRIPT_KEY
    or (type(environment.__VoraKey) == "string" and environment.__VoraKey ~= "") and environment.__VoraKey
    or (persistKey and type(environment.__VoraSavedKey) == "string" and environment.__VoraSavedKey ~= "") and environment.__VoraSavedKey
    or (type(_G.SCRIPT_KEY) == "string" and _G.SCRIPT_KEY ~= "") and _G.SCRIPT_KEY
    or nil

if persistKey and not key and type(readfile) == "function" and type(isfile) == "function" then
    pcall(function()
        if isfile("vora_saved_key.txt") then
            local saved = readfile("vora_saved_key.txt")
            if type(saved) == "string" and #saved >= 10 then
                key = saved:match("^%s*(.-)%s*$")
            end
        end
    end)
end

if key then
    environment.SCRIPT_KEY = key
    environment.__VoraKey = key
    environment.__VoraSavedKey = key
    _G.SCRIPT_KEY = key
    if persistKey and type(writefile) == "function" then
        pcall(writefile, "vora_saved_key.txt", key)
    end
end

environment.__VoraResumeLoaderUrl = API_URL .. "/loader.lua"

local httpRequest = (type(request) == "function" and request)
    or (type(http_request) == "function" and http_request)
    or (syn and type(syn.request) == "function" and syn.request)
    or (http and type(http.request) == "function" and http.request)
    or (fluxus and type(fluxus.request) == "function" and fluxus.request)

local executorName = "Unknown"
if type(getexecutorname) == "function" then
    local ok, name = pcall(getexecutorname)
    if ok and type(name) == "string" then executorName = name end
elseif type(identifyexecutor) == "function" then
    local ok, name = pcall(identifyexecutor)
    if ok and type(name) == "string" then executorName = name end
end

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then
    local playerTimeout = os.clock() + 3
    while not localPlayer and os.clock() < playerTimeout do
        task.wait(0.05)
        localPlayer = Players.LocalPlayer
    end
end

local function resolveHWID()
    if type(gethwid) == "function" then
        local ok, val = pcall(gethwid)
        if ok and type(val) == "string" and #val >= 3 then return val end
    end
    if type(get_hwid) == "function" then
        local ok, val = pcall(get_hwid)
        if ok and type(val) == "string" and #val >= 3 then return val end
    end
    if type(get_device_id) == "function" then
        local ok, val = pcall(get_device_id)
        if ok and type(val) == "string" and #val >= 3 then return val end
    end
    local ok, analyticsId = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and type(analyticsId) == "string" and #analyticsId >= 3 then return analyticsId end
    if localPlayer and localPlayer.UserId and localPlayer.UserId > 0 then
        return "ROBLOX_USER_" .. tostring(localPlayer.UserId)
    end
    return "DELTA_DEVICE_STABLE"
end

local hwid = resolveHWID()
local HttpService = game:GetService("HttpService")
local startedAt = os.clock()
local resolvedGameId = (game.GameId and game.GameId > 0) and game.GameId or 0
if type(LOADER_INTEGRITY) ~= "string" or not LOADER_INTEGRITY:match("^[a-f0-9]+$") then
    warn("[Vora Hub] Loader integrity verification failed. Please fetch the official loader again.")
    return
end
local function showTamperModal(titleText, subtitleText)
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        local screen = Instance.new("ScreenGui")
        screen.Name = "VoraSecurityPrompt"
        screen.ResetOnSpawn = false
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local overlay = Instance.new("Frame")
        overlay.Name = "Overlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.5
        overlay.BorderSizePixel = 0
        overlay.Parent = screen

        local modal = Instance.new("Frame")
        modal.Name = "Modal"
        modal.Size = UDim2.new(0, 360, 0, 180)
        modal.Position = UDim2.new(0.5, -180, 0.5, -90)
        modal.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
        modal.BorderSizePixel = 0
        modal.Parent = overlay

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = modal

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(50, 45, 65)
        stroke.Thickness = 1.2
        stroke.Parent = modal

        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.Size = UDim2.new(1, -32, 0, 26)
        title.Position = UDim2.new(0, 16, 0, 18)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = titleText or "You are blacklisted"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 19
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = modal

        local desc = Instance.new("TextLabel")
        desc.Name = "Desc"
        desc.Size = UDim2.new(1, -32, 0, 52)
        desc.Position = UDim2.new(0, 16, 0, 48)
        desc.BackgroundTransparency = 1
        desc.Font = Enum.Font.Gotham
        desc.Text = subtitleText or "You have been blacklisted from this script:\nTampering detected (type 1)\nYou can retry in 24 hours"
        desc.TextColor3 = Color3.fromRGB(161, 161, 170)
        desc.TextSize = 13
        desc.TextWrapped = true
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = modal

        local leaveBtn = Instance.new("TextButton")
        leaveBtn.Name = "LeaveBtn"
        leaveBtn.Size = UDim2.new(1, -32, 0, 38)
        leaveBtn.Position = UDim2.new(0, 16, 1, -52)
        leaveBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
        leaveBtn.BorderSizePixel = 0
        leaveBtn.Font = Enum.Font.GothamSemibold
        leaveBtn.Text = "Leave"
        leaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        leaveBtn.TextSize = 14
        leaveBtn.AutoButtonColor = true
        leaveBtn.Parent = modal

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = leaveBtn

        leaveBtn.MouseButton1Click:Connect(function()
            local player = game:GetService("Players").LocalPlayer
            if player and type(player.Kick) == "function" then
                player:Kick((titleText or "Blacklisted") .. "\n" .. (subtitleText or ""))
            end
        end)

        if syn and type(syn.protect_gui) == "function" then
            syn.protect_gui(screen)
            screen.Parent = CoreGui
        elseif type(gethui) == "function" then
            screen.Parent = gethui()
        else
            screen.Parent = CoreGui
        end
    end)
end

local function kickPlayer(msg)
    local player = game:GetService("Players").LocalPlayer
    if player and type(player.Kick) == "function" then
        pcall(function() player:Kick(msg) end)
    end
    warn(msg)
end

local function reportAndKick(tamperType, reasonText, modalSubtitle, telemetryOnly)
    if httpRequest then
        pcall(httpRequest, {
            Url = API_URL .. "/v1/report-tampering",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({
                hwid = hwid,
                tamperType = tamperType,
                detail = reasonText,
                keyHint = key and string.sub(key, 1, 16) or nil,
                gameId = resolvedGameId,
                executor = executorName,
                telemetryOnly = telemetryOnly == true,
            }),
        })
    end
    if telemetryOnly then
        warn("[Vora Hub] A client compatibility signal was recorded.")
        return
    end
    showTamperModal("You are blacklisted", modalSubtitle)
    task.wait(2.5)
    kickPlayer("\n\n[Vora Hub]\n" .. reasonText .. "\n")
end

local origWritefile = environment.writefile or _G.writefile
local origAppendfile = environment.appendfile or _G.appendfile
local origSetclipboard = environment.setclipboard or _G.setclipboard or environment.toclipboard or _G.toclipboard or environment.set_clipboard or _G.set_clipboard

local function trapIo(origFn, isClipboard)
    return function(target, content, ...)
        local payloadText = isClipboard and tostring(target or "") or tostring(content or "")
        local isDump = false
        local targetLower = type(target) == "string" and string.lower(target) or ""
        local isWhitelistedFile = not isClipboard and (
            targetLower == "vora_saved_key.txt"
            or string.find(targetLower, "^obsidian/")
            or string.find(targetLower, "/obsidian/")
            or string.find(targetLower, "%.png$")
            or string.find(targetLower, "%.jpg$")
            or string.find(targetLower, "%.jpeg$")
        )
        if not isWhitelistedFile then
            if #payloadText > 200 then
                if string.find(payloadText, "@VoraHub")
                    or string.find(payloadText, "SCRIPT_KEY")
                    or string.find(payloadText, "sessionToken")
                    or string.find(payloadText, "deliveryToken")
                    or string.find(payloadText, "VoraShield_")
                    or string.find(payloadText, "__VoraKey")
                    or string.find(payloadText, "__VoraSavedKey")
                    or string.find(payloadText, "__vora_vm")
                    or string.find(payloadText, "voradump")
                    or string.find(payloadText, "-- [Core Engine]") then
                    isDump = true
                end
            end
            if not isClipboard and string.find(targetLower, "voradump") then
                isDump = true
            end
        end
        if isDump then
            reportAndKick(1, (isClipboard and "clipboard" or "writefile") .. "_dump_intercept_attempt: " .. tostring(target), "You have been blacklisted from this script:\nTampering detected (type 1 - payload dump)\nUnauthorized capture detour blocked.")
            if not isClipboard and origFn then pcall(origFn, target, "-- [Vora Security] Dump attempt blocked.", ...) end
            error("[Vora Security] Unauthorized capture attempt blocked.")
        end
        if origFn then return origFn(target, content, ...) end
    end
end

if type(origWritefile) == "function" then
    environment.writefile = trapIo(origWritefile, false)
    _G.writefile = environment.writefile
end
if type(origAppendfile) == "function" then
    environment.appendfile = trapIo(origAppendfile, false)
    _G.appendfile = environment.appendfile
end
if type(origSetclipboard) == "function" then
    local trappedClip = trapIo(origSetclipboard, true)
    if environment.setclipboard then environment.setclipboard = trappedClip end
    if _G.setclipboard then _G.setclipboard = trappedClip end
    if environment.toclipboard then environment.toclipboard = trappedClip end
    if _G.toclipboard then _G.toclipboard = trappedClip end
    if environment.set_clipboard then environment.set_clipboard = trappedClip end
    if _G.set_clipboard then _G.set_clipboard = trappedClip end
end

-- Best-effort, log-only filesystem signal collection. We inspect only file
-- names returned by the executor and never read file contents or block access.
local function reportTelemetry(eventType, details)
    if not httpRequest then return end
    pcall(httpRequest, {
        Url = API_URL .. "/v1/report-tampering",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({
            hwid = hwid,
            telemetryOnly = true,
            telemetryType = eventType,
            telemetryDetails = details or {},
            keyHint = key and string.sub(key, 1, 16) or nil,
            gameId = resolvedGameId,
            placeId = game.PlaceId or 0,
            executor = executorName,
        }),
    })
end

local function scanFilesystemSignals()
    if type(listfiles) ~= "function" then return nil end
    local roots = { "workspace", "autoexec" }
    local patterns = {
        { "dex", "dex" },
        { "simplespy", "simple_spy" },
        { "simple spy", "simple_spy" },
        { "remotespy", "remote_spy" },
        { "remote spy", "remote_spy" },
        { "saveinstance", "saveinstance" },
        { "decompiler", "decompiler" },
        { "decompile", "decompiler" },
        { "scriptdump", "script_dump" },
        { "script dump", "script_dump" },
        { "dump.lua", "dump_tool" },
        { "hydroxide", "hydroxide" },
    }
    local categories, names = {}, {}
    local autoexecFiles, workspaceFiles = {}, {}
    local entriesScanned, rootsScanned = 0, 0
    for _, root in ipairs(roots) do
        local ok, entries = pcall(listfiles, root)
        if ok and type(entries) == "table" then
            rootsScanned = rootsScanned + 1
            for _, entry in ipairs(entries) do
                if entriesScanned >= 1000 then break end
                entriesScanned = entriesScanned + 1
                local rawPath = tostring(entry)
                local path = string.lower(rawPath)
                local basename = rawPath:match("[^/\\]+$") or rawPath
                local targetFiles = root == "autoexec" and autoexecFiles or workspaceFiles
                if #targetFiles < 200 then targetFiles[#targetFiles + 1] = string.sub(basename, 1, 120) end
                for _, rule in ipairs(patterns) do
                    if string.find(path, rule[1], 1, true) then
                        categories[rule[2]] = true
                        if #names < 12 then
                            names[#names + 1] = string.sub(basename, 1, 80)
                        end
                        break
                    end
                end
            end
        end
    end
    local categoryList = {}
    for category in pairs(categories) do categoryList[#categoryList + 1] = category end
    table.sort(categoryList)
    table.sort(names)
    return {
        rootsScanned = rootsScanned,
        entriesScanned = entriesScanned,
        matches = categoryList,
        names = names,
        autoexecFiles = autoexecFiles,
        workspaceFiles = workspaceFiles,
    }
end

local filesystemScan = scanFilesystemSignals()
if filesystemScan then
    reportTelemetry("filesystem_scan", filesystemScan)
end

local function verifyHttpIntegrity(fn)
    if type(fn) ~= "function" then return { "http_unavailable" } end
    local signals = {}
    if type(isfunctionhooked) == "function" then
        local ok, hooked = pcall(isfunctionhooked, fn)
        if ok and hooked == true then
            table.insert(signals, "http_hook_reported")
        end
    end
    if type(debug) == "table" and type(debug.getinfo) == "function" then
        local ok, info = pcall(debug.getinfo, fn)
        if ok and type(info) == "table" then
            if info.what ~= "C" then
                table.insert(signals, "http_lua_closure_detected")
            end
            if type(info.nups) == "number" and info.nups > 0 then
                table.insert(signals, "http_upvalues_detected")
            end
            if type(info.source) == "string" and info.source ~= "=[C]" and not string.find(info.source, "^%[C%]") then
                table.insert(signals, "http_source_not_c")
            end
        end
    end
    if type(iscclosure) == "function" then
        local okCc, isCc = pcall(iscclosure, fn)
        if okCc and isCc == false then
            table.insert(signals, "http_not_cclosure")
        end
    end
    return signals
end

if httpRequest then
    local httpSignals = verifyHttpIntegrity(httpRequest)
    if #httpSignals > 0 then
        local hasReportedHook = false
        local onlyClosureSignals = true
        for _, sig in ipairs(httpSignals) do
            if sig == "http_hook_reported" then
                hasReportedHook = true
                onlyClosureSignals = false
                break
            end
        end

        local execLower = string.lower(executorName or "")
        local isReportOnlyExec = string.find(execLower, "xeno")
            or string.find(execLower, "delta")
            or string.find(execLower, "solara")
            or string.find(execLower, "wrd")
            or string.find(execLower, "wave")
            or string.find(execLower, "fluxus")
            or string.find(execLower, "arceus")
            or string.find(execLower, "codex")

        if hasReportedHook then
            return reportAndKick(1, "http_hook_detected: " .. table.concat(httpSignals, ","), "You have been blacklisted from this script:\nTampering detected (type 1 - network hook)\nNetwork function detour intercepted.")
        elseif isReportOnlyExec then
            -- Known budget/mobile executors that wrap request in Luau closures: telemetry only
            reportTelemetry("http_integrity_metadata", { signals = httpSignals, executor = executorName })
        else
            -- Advanced executors (Potassium, Real, Volt, etc.) MUST have native C closures; Luau closures indicate tampering/hooking
            return reportAndKick(1, "http_hook_detected: " .. table.concat(httpSignals, ","), "You have been blacklisted from this script:\nTampering detected (type 1 - network hook)\nNetwork function detour intercepted.")
        end
    end
end

local response, payload, decoded
local clientNonce
for attempt = 1, 3 do
    clientNonce = HttpService:GenerateGUID(false)
    local requestBody = HttpService:JSONEncode({
        key = key,
        hwid = hwid,
        gameId = resolvedGameId,
        placeId = game.PlaceId or 0,
        executor = executorName,
        nonce = clientNonce,
        loaderProtocol = LOADER_PROTOCOL,
        loaderIntegrity = LOADER_INTEGRITY,
        robloxUserId = localPlayer and localPlayer.UserId or nil,
        robloxUsername = localPlayer and localPlayer.Name or nil,
        robloxDisplayName = localPlayer and localPlayer.DisplayName or nil,
    })
    local sent, result = false, nil
    if httpRequest then
        sent, result = pcall(httpRequest, {
            Url = API_URL .. "/v1/bootstrap",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = requestBody,
        })
    end
    response = sent and result or nil
    decoded, payload = pcall(HttpService.JSONDecode, HttpService,
        type(response) == "table" and response.Body or "")
    if type(response) == "table" and response.Success
        and decoded and type(payload) == "table" and payload.ok == true then
        break
    end
    local status = type(response) == "table" and tonumber(response.StatusCode) or nil
    local reason = decoded and type(payload) == "table" and payload.error or nil
    local retryable = not sent or type(response) ~= "table" or (status and status >= 500)
        or reason == "verification_failed" or reason == "service_unavailable"
    if not retryable or attempt == 3 then break end
    task.wait(attempt * 0.35)
end

if not (type(response) == "table" and response.Success
    and decoded and type(payload) == "table" and payload.ok == true) then
    local reason = decoded and type(payload) == "table" and payload.error or nil
    local remHours = decoded and type(payload) == "table" and payload.remainingHours or nil
    local isFreeGame = (decoded and type(payload) == "table" and payload.isPaid == false) or reason == "invalid_free_key"
    local freeKeyUrl = (decoded and type(payload) == "table" and type(payload.keyUrl) == "string" and payload.keyUrl ~= "") and payload.keyUrl or (API_URL .. "/getkey")

    if reason == "hwid_blacklisted" then
        local hoursMsg = (remHours and remHours > 0)
            and ("You can retry in %d hours"):format(remHours)
            or (remHours == -1 and "This blacklist is permanent." or "You can retry later.")
        showTamperModal("You are blacklisted", "You have been blacklisted from this script:\nTampering detected (type 1)\n" .. hoursMsg)
        task.wait(2.5)
        return kickPlayer("\n\n[Vora Hub]\nYou are blacklisted from this script:\nTampering detected (type 1)\n" .. hoursMsg)
    end

    if reason == "replay_detected" then
        showTamperModal("You are blacklisted", "You have been blacklisted from this script:\nTampering detected (type 2 - replay)\nReplay attack detected: execution nonce already consumed.")
        task.wait(2.5)
        return kickPlayer("\n\n[Vora Hub]\nTampering detected (type 2 - replay)\nReplay attack detected: execution nonce already consumed.\n")
    end

    if reason == "verification_failed" or reason == "service_unavailable" then
        return warn("[Vora Hub] Verification service is temporarily unavailable. Try again shortly.")
    end
    if reason == "device_limit" then
        if isFreeGame then
            return kickPlayer(("\n\n[Vora Hub]\nThis free key is already linked to another device.\nGet your own free key here:\n%s\n"):format(freeKeyUrl))
        else
            return kickPlayer("\n\n[Vora Hub]\nThis key is already linked to another device.\nPlease create a ticket in our Discord to reset your HWID:\nhttps://discord.gg/XhZCyCArtb\n")
        end
    end
    if reason == "paid_only" then
        return kickPlayer("\n\n[Vora Hub]\nThis game requires a premium or lifetime key.\nFree checkpoint keys can only access free games.\nPurchase a key in our Discord:\nhttps://discord.gg/XhZCyCArtb\n")
    end
    if reason == "invalid_free_key" or (isFreeGame and (reason == "invalid_key" or reason == "key_required")) then
        return kickPlayer(("\n\n[Vora Hub]\nThis game is FREE, but requires an access key!\nGet your free key here:\n%s\n"):format(freeKeyUrl))
    end
    if reason == "invalid_key" or reason == "key_required" then
        return kickPlayer("\n\n[Vora Hub]\nInvalid key.\nPurchase a key in our Discord:\nhttps://discord.gg/XhZCyCArtb\n")
    end
    if reason == "key_expired" then
        if isFreeGame then
            return kickPlayer(("\n\n[Vora Hub]\nYour free access key has expired!\nGet a new free key here:\n%s\n"):format(freeKeyUrl))
        else
            return kickPlayer("\n\n[Vora Hub]\nYour key has expired.\nRenew your key in our Discord:\nhttps://discord.gg/XhZCyCArtb\n")
        end
    end
    if reason == "key_revoked" then
        return kickPlayer("\n\n[Vora Hub]\nYour key has been revoked.\nContact support in our Discord:\nhttps://discord.gg/XhZCyCArtb\n")
    end
    if reason == "unsupported_game" then
        return kickPlayer("\n\n[Vora Hub]\nThis game is currently not supported.\nJoin our Discord for updates:\nhttps://discord.gg/XhZCyCArtb\n")
    end
    if reason then
        return kickPlayer(("\n\n[Vora Hub]\nAccess rejected: %s\nDiscord: https://discord.gg/XhZCyCArtb\n"):format(tostring(reason)))
    end
    return warn(("[Vora Hub] Verification request failed (%s)."):format(
        tostring(type(response) == "table" and response.StatusCode or "network")))
end

local moduleBody, downloadErrorDetail
if httpRequest then
    local ok, res = pcall(httpRequest, {
        Url = payload.moduleUrl, Method = "GET",
        Headers = { ["Authorization"] = "Bearer " .. tostring(payload.deliveryToken or ""), ["X-Vora-Hwid"] = hwid },
    })
    if ok and type(res) == "table" and res.Success and type(res.Body) == "string" and #res.Body > 0 then
        moduleBody = res.Body
    else
        downloadErrorDetail = (type(res) == "table" and res.StatusCode and tostring(res.StatusCode)) or (not ok and tostring(res)) or "request_failed"
    end
end
if not moduleBody and not payload.deliveryToken then
    local ok, body = pcall(game.HttpGet, game, payload.moduleUrl)
    if ok and type(body) == "string" and #body > 0 then
        moduleBody = body
    else
        downloadErrorDetail = tostring(body)
    end
end

if not moduleBody then
    return warn(("[Vora Hub] The game module could not be downloaded (%s)."):format(tostring(downloadErrorDetail or "unknown")))
end

local secSettings = (type(payload) == "table" and type(payload.security) == "table") and payload.security or {}
local antiHookEnabled = secSettings.antiHook ~= false
local canaryEnabled = secSettings.canary ~= false
local maxDelayMs = tonumber(secSettings.maxDelayMs) or 2000

local function verifyRuntime()
    if type(loadstring) ~= "function" then return false, "loadstring_unavailable" end
    local signals = {}
    if type(isfunctionhooked) == "function" then
        local ok, hooked = pcall(isfunctionhooked, loadstring)
        if ok and hooked == true then
            table.insert(signals, "loadstring_hook_reported")
        end
    end
    if secSettings.cClosureCheck ~= false and type(debug) == "table" and type(debug.getinfo) == "function" then
        local ok, info = pcall(debug.getinfo, loadstring)
        if ok and type(info) == "table" then
            if info.what ~= "C"
                or (type(info.source) == "string" and info.source ~= "=[C]" and not string.find(info.source, "^%[C%]"))
                or (type(info.nups) == "number" and info.nups > 0) then
                table.insert(signals, "loadstring_metadata_unusual")
            end
        end
    end
    if secSettings.deepIntegrity ~= false and type(debug) == "table" and type(debug.getinfo) == "function" then
        -- Invariant Control Probe: pure Lua dummy closure must never report what == 'C'
        local okDummy, dummyInfo = pcall(debug.getinfo, function() return 1 end)
        if okDummy and type(dummyInfo) == "table" and dummyInfo.what == "C" then
            table.insert(signals, "dummy_function_reported_as_c")
        end
        -- Introspect debug.getinfo itself
        local okDgi, dgiInfo = pcall(debug.getinfo, debug.getinfo)
        if okDgi and type(dgiInfo) == "table" then
            if dgiInfo.what ~= "C" or (type(dgiInfo.nups) == "number" and dgiInfo.nups > 0) then
                table.insert(signals, "debug_getinfo_metadata_unusual")
            end
        end
    end
    if secSettings.deepIntegrity ~= false and type(iscclosure) == "function" then
        local okCc, isCc = pcall(iscclosure, loadstring)
        if okCc and isCc == false then
            table.insert(signals, "iscclosure_disagrees")
        end
    end
    return true, table.concat(signals, ",")
end

if antiHookEnabled then
    local runtimeOk, runtimeSignals = verifyRuntime()
    if runtimeSignals and #runtimeSignals > 0 then
        reportTelemetry("runtime_integrity_metadata", { signals = runtimeSignals })
    end
    if not runtimeOk then
        reportTelemetry("runtime_unavailable", { reason = runtimeSignals or "unknown" })
        return warn("[Vora Hub] This executor is missing a required runtime feature.")
    end
end

local function runCanaryCheck(maxMs)
    local t0 = os.clock()
    local okWait = pcall(task.wait)
    local t1 = os.clock()
    local elapsedMs = (t1 - t0) * 1000
    if elapsedMs > maxMs then
        return false, ("Frame delay anomaly: " .. math.floor(elapsedMs) .. "ms exceeded limit " .. maxMs .. "ms")
    end

    local RunService = game:GetService("RunService")
    if RunService and type(RunService.Heartbeat) == "userdata" and type(RunService.Heartbeat.Connect) == "function" then
        task.spawn(function()
            local fired = false
            local hbT0 = os.clock()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                fired = true
                if conn then conn:Disconnect() conn = nil end
            end)
            task.wait(0.2)
            if conn then conn:Disconnect() end
            local hbElapsed = (os.clock() - hbT0) * 1000
            if not fired and hbElapsed > 500 then
                reportAndKick(2, "Physics heartbeat stalled or suppressed", nil, true)
            end
        end)
    end
    return true, nil
end

if canaryEnabled then
    local canaryOk, canaryErr = runCanaryCheck(maxDelayMs)
    if not canaryOk then
        reportAndKick(2, tostring(canaryErr), nil, true)
    end
end

if canaryEnabled then
    task.spawn(function()
        local lastTick = os.clock()
        while task.wait(2.0) do
            local curTick = os.clock()
            local deltaMs = (curTick - lastTick) * 1000
            if deltaMs > (maxDelayMs + 3000) then
                reportAndKick(2, "Watchdog delay: " .. math.floor(deltaMs) .. "ms", nil, true)
                break
            end
            lastTick = curTick
        end
    end)
end

local raw_loadstring = loadstring
local targetGame = tostring(payload.game)

if secSettings.loadstringCanary ~= false then
    local pStart = os.clock()
    local probeFn, pErr = raw_loadstring("return (0xCAFE + 1337)", "@VoraHub/Canary")
    local pElapsed = (os.clock() - pStart) * 1000
    if type(probeFn) ~= "function" then
        moduleBody = nil
        reportAndKick(1, "Canary compile unavailable: " .. tostring(pErr), nil, true)
        return warn("[Vora Hub] Runtime environment verification failed.")
    end
    local ok, pRes = pcall(probeFn)
    if not ok or pRes ~= (0xCAFE + 1337) then
        moduleBody = nil
        reportAndKick(1, "Canary execution unavailable or unexpected", nil, true)
        return warn("[Vora Hub] Runtime environment verification failed.")
    end
    if pElapsed > 150 then
        reportAndKick(2, "Canary compilation slow: " .. math.floor(pElapsed) .. "ms", nil, true)
    end
end

local module, compileError = raw_loadstring(moduleBody, "@VoraHub/" .. targetGame)

if type(origWritefile) == "function" then
    environment.writefile = origWritefile
    _G.writefile = origWritefile
end
if type(origAppendfile) == "function" then
    environment.appendfile = origAppendfile
    _G.appendfile = origAppendfile
end
if type(origSetclipboard) == "function" then
    if environment.setclipboard then environment.setclipboard = origSetclipboard end
    if _G.setclipboard then _G.setclipboard = origSetclipboard end
    if environment.toclipboard then environment.toclipboard = origSetclipboard end
    if _G.toclipboard then _G.toclipboard = origSetclipboard end
    if environment.set_clipboard then environment.set_clipboard = origSetclipboard end
    if _G.set_clipboard then _G.set_clipboard = origSetclipboard end
end

local sessionToken = payload.sessionToken
local watermarkToken = payload.watermark

-- Best-effort reference cleanup; the executor can still capture delivered code.
local antiDumpActive = secSettings.antiDump ~= false
local closureCloakActive = secSettings.closureCloak ~= false

moduleBody = nil
payload = nil
requestBody = nil
response = nil
if key then
    environment.SCRIPT_KEY = key
    _G.SCRIPT_KEY = key
    environment.__VoraKey = key
    environment.__VoraSavedKey = key
    if persistKey and type(writefile) == "function" then
        pcall(writefile, "vora_saved_key.txt", key)
    end
end

if not module then return warn("[Vora Hub] " .. tostring(compileError)) end
print(("[Vora Hub] Verified in %.2fs; loading %s."):format(os.clock()-startedAt, targetGame))

local targetFn = module
if closureCloakActive then
    -- Cloak loader closure from debug.getinfo and inspection
    local origEnv = (type(getfenv) == "function" and getfenv(targetFn)) or (type(getgenv) == "function" and getgenv()) or _G
    local dummyEnv = setmetatable({}, {
        __index = function(t, k)
            return origEnv[k]
        end,
        __newindex = origEnv,
        __metatable = "The metatable is locked",
    })
    if setfenv then pcall(setfenv, targetFn, dummyEnv) end
end

local ok, runError = pcall(targetFn, sessionToken, hwid, clientNonce, API_URL, watermarkToken)
if not persistKey then
    environment.SCRIPT_KEY = nil
    environment.__VoraKey = nil
    environment.__VoraSavedKey = nil
    _G.SCRIPT_KEY = nil
    key = nil
end
sessionToken = nil
watermarkToken = nil
clientNonce = nil
hwid = nil
targetFn = nil
module = nil

if antiDumpActive and collectgarbage then
    pcall(function() collectgarbage("step", 100) end)
    if task and type(task.delay) == "function" then
        task.delay(3, function()
            pcall(function() collectgarbage("collect") end)
        end)
    else
        pcall(function() collectgarbage("collect") end)
    end
end
if not ok then
    warn("[Vora Hub] Runtime error: " .. tostring(runError))
end
return ok
