local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

repeat task.wait() until game:IsLoaded()
repeat task.wait() until Players.LocalPlayer
local LP = Players.LocalPlayer
repeat task.wait() until LP:FindFirstChild("PlayerGui")

local Currency
pcall(function()
    Currency = require(ReplicatedStorage:WaitForChild("Library"):WaitForChild("Client"):WaitForChild("Currency"))
end)
local Network
pcall(function()
    Network = require(ReplicatedStorage.Library.Client.Network)
end)

repeat task.wait() until LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
task.wait(0.8)

local WINTER_CF = CFrame.new(-4170.39307, 1028.96558, -4252.91553)
local VOID_CF = CFrame.new(-4249.06836, 2029.65088, -4252.03369)
local VOID_NEAR = VOID_CF * CFrame.new(0, 0, 10)
local MERCHANT_CF = CFrame.new(-4246.11279, 28.84262, -4205.35498)
local MERCHANT_NEAR = MERCHANT_CF * CFrame.new(0, 0, 14)

local cachedCostText, cachedCostNum = "-", nil
local cachedCoinsText, cachedCoinsNum = "-", nil
local costFresh = false
local totalRebirths, sessionRebirths = "-", 0
local statusText = "Idle"
local etaText, avgText = "-", "-"
local merchantText = "-"
local Status, CoinLbl, CostLbl, TotalLbl, SessionLbl, EtaLbl, AvgLbl, MercLbl, StatusDot
local SidePanel, SideMerc, SideCost, SideEta, SideStock, SideCoins
local sampleCoins, sampleTime = nil, nil
local coinRate = 0
local cycleStart = tick()
local lastRebirthAt = tick()
local totalCycleTime = 0
local idledConn
local autoRollOn = false
local rollThread
local afkEnabled = false
local merchantOn = false
local comboOn = false
local merchantBusy = false
local restockAt = nil
local lastMerchantVisit = 0
local merchantOffers = {}
local merchantKind = "DicesMerchant"
local afkThread
local eventEntered = false
local running = false
local Raid = {
    on = false,
    busy = false,
    hatch = true,
    raids = 0,
    eggs = 0,
    acc = 0,
    onAt = 0,
    points = 0,
    lvl = 0,
    status = "Raid idle",
}

local GOLD = Color3.fromRGB(232, 195, 106)
local ACCENT = Color3.fromRGB(80, 220, 140)
local ACCENT2 = Color3.fromRGB(90, 170, 255)
local ACCENT3 = Color3.fromRGB(255, 186, 72)
local ACCENT4 = Color3.fromRGB(186, 120, 255)
local BG = Color3.fromRGB(12, 13, 17)
local CARD = Color3.fromRGB(18, 20, 26)
local ROW = Color3.fromRGB(20, 22, 29)
local LINE = Color3.fromRGB(36, 40, 50)
local MUTED = Color3.fromRGB(128, 134, 148)
local WHITE = Color3.fromRGB(240, 242, 246)

local function setStatus(t)
    statusText = tostring(t or "")
end

local function formatTime(sec)
    if not sec or sec ~= sec or sec < 0 then
        return "-"
    end
    sec = math.floor(sec)
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)
    local s = sec % 60
    if h > 0 then
        return string.format("%dh %dm", h, m)
    end
    if m > 0 then
        return string.format("%dm %ds", m, s)
    end
    return string.format("%ds", s)
end

local function formatCoins(n)
    if type(n) ~= "number" or n ~= n then
        return "-"
    end
    local absn = math.abs(n)
    if absn >= 1e12 then
        return string.format("%.2fT", n / 1e12)
    end
    if absn >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    end
    if absn >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    end
    if absn >= 1e3 then
        return string.format("%.2fK", n / 1e3)
    end
    return tostring(math.floor(n + 0.5))
end

local function updateCoins()
    if not Currency or type(Currency.Get) ~= "function" then
        return
    end
    local n = Currency.Get("PixelCoins")
    if type(n) == "number" then
        cachedCoinsNum = n
        cachedCoinsText = formatCoins(n)
    end
end

pcall(updateCoins)

local function applyMerchantPacket(pack)
    if type(pack) ~= "table" or not pack.Offers then
        return
    end
    if pack.State and type(pack.State.RemainingSeconds) == "number" then
        restockAt = tick() + math.max(pack.State.RemainingSeconds, 1)
    end
    if pack.State and type(pack.State.Kind) == "string" then
        merchantKind = pack.State.Kind
    end
    merchantOffers = {}
    for i = 1, 3 do
        local o = pack.Offers[i]
        if type(o) == "table" then
            merchantOffers[i] = {
                key = o.OfferKey,
                stock = tonumber(o.Stock) or 0,
                price = tonumber(o.PriceGems) or 0,
                item = o.ItemId,
                unlocked = o.Unlocked ~= false
            }
        end
    end
end

pcall(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then
        return
    end
    for _, ev in ipairs(remotes:GetChildren()) do
        pcall(function()
            ev.OnClientEvent:Connect(function(a, b, c)
                local pack = (type(a) == "table" and a.Offers and a)
                    or (type(b) == "table" and b.Offers and b)
                    or (type(c) == "table" and c.Offers and c)
                if pack then
                    applyMerchantPacket(pack)
                end
            end)
        end)
    end
end)

local function getHRP()
    local char = LP.Character
    local t = tick()
    while (not char or not char:FindFirstChild("HumanoidRootPart")) and tick() - t < 20 do
        char = LP.Character
        task.wait(0.1)
    end
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function smoothTP(cf, steps)
    steps = steps or 22
    local hrp = getHRP()
    if not hrp then
        return
    end
    local start = hrp.CFrame
    for i = 1, steps do
        if not hrp.Parent then
            return
        end
        hrp.CFrame = start:Lerp(cf, i / steps)
        task.wait(0.03)
    end
    if hrp.Parent then
        hrp.CFrame = cf
    end
end

local function tapIdleKey()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
    end)
end

local function antiAFK()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    pcall(tapIdleKey)
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and not merchantBusy then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.05)
            hum:Move(Vector3.new(0.08, 0, 0), true)
            task.wait(0.08)
            hum:Move(Vector3.zero, true)
        end
    end)
end

local function bindIdle()
    if idledConn then
        pcall(function()
            idledConn:Disconnect()
        end)
        idledConn = nil
    end
    pcall(function()
        idledConn = LP.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            pcall(tapIdleKey)
        end)
    end)
end

local function startAntiAFK()
    bindIdle()
    pcall(function()
        LP.CharacterAdded:Connect(function()
            if afkEnabled then
                task.wait(1)
                bindIdle()
                pcall(antiAFK)
            end
        end)
    end)
    if afkThread then
        pcall(function()
            task.cancel(afkThread)
        end)
    end
    afkThread = task.spawn(function()
        while afkEnabled do
            pcall(antiAFK)
            task.wait(12)
        end
    end)
end

local function stopAntiAFK()
    if idledConn then
        pcall(function()
            idledConn:Disconnect()
        end)
        idledConn = nil
    end
    if afkThread then
        pcall(function()
            task.cancel(afkThread)
        end)
        afkThread = nil
    end
end

local function invokeNet(name)
    if not Network then
        return
    end
    local done = false
    task.spawn(function()
        pcall(function()
            Network.InvokeServer(name)
        end)
        done = true
    end)
    local t = tick()
    while not done and tick() - t < 6 do
        task.wait(0.1)
    end
end

local function getRngChannel()
    if not Network or not Network.Channel then
        return nil
    end
    local ok, ch = pcall(function()
        return Network.Channel("RNG")
    end)
    if ok then
        return ch
    end
end

local function rngFire(a, b)
    local ch = getRngChannel()
    pcall(function()
        if ch then
            ch:FireServer(a, b)
        end
    end)
    pcall(function()
        if Network and Network.FireServer then
            Network.FireServer("RNG", a, b)
        end
    end)
end

local BOARD_NAMES = {
    BreakablesIncremental = true,
    PixelCoinsMultiplier = true,
    LuckMultiplier = true,
}

local function findIncrementalBoard()
    local cached
    local ok, inst = pcall(function()
        return workspace._THINGS.Minigames.ServerOwned.RNGEvent.Interact.Boards.IncrementalBoard
    end)
    if ok and inst then
        return inst
    end
    ok, inst = pcall(function()
        return workspace:FindFirstChild("IncrementalBoard", true)
    end)
    if ok and inst then
        return inst
    end
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "IncrementalBoard" or (obj.Name == "Content" and obj:FindFirstChild("LuckMultiplier")) then
                cached = obj.Name == "IncrementalBoard" and obj or obj
                break
            end
        end
    end)
    return cached
end

local function getBoardContent()
    local board = findIncrementalBoard()
    if not board then
        return nil
    end
    if board.Name == "Content" then
        return board
    end
    local content
    pcall(function()
        content = board.Main.SurfaceGui.Bottom.Content
    end)
    if content then
        return content
    end
    pcall(function()
        for _, d in ipairs(board:GetDescendants()) do
            if d.Name == "Content" and (d:FindFirstChild("LuckMultiplier") or d:FindFirstChild("BreakablesIncremental") or d:FindFirstChild("PixelCoinsMultiplier")) then
                content = d
                break
            end
        end
    end)
    return content
end

local function waitBoard(timeout)
    local t = tick()
    while tick() - t < (timeout or 8) do
        local c = getBoardContent()
        if c then
            return true
        end
        task.wait(0.2)
    end
    return getBoardContent() ~= nil
end

local function fireBtn(btn)
    if not btn then
        return
    end
    pcall(function()
        for _, ev in ipairs({btn.Activated, btn.MouseButton1Click, btn.MouseButton1Down}) do
            pcall(function()
                for _, conn in pairs(getconnections(ev)) do
                    pcall(function()
                        if conn.Fire then
                            conn:Fire()
                        end
                        if conn.Function then
                            conn.Function()
                        end
                    end)
                end
            end)
            pcall(function()
                firesignal(ev)
            end)
        end
    end)
    pcall(function()
        if typeof(btn.Activate) == "function" then
            btn:Activate()
        end
    end)
end

local function clickGui(obj)
    if not obj then
        return
    end
    fireBtn(obj)
    pcall(function()
        local pos = obj.AbsolutePosition
        local size = obj.AbsoluteSize
        if size.X < 2 or size.Y < 2 then
            return
        end
        local cx = pos.X + size.X * 0.5
        local cy = pos.Y + size.Y * 0.5
        local inset = Vector2.new(0, 0)
        pcall(function()
            inset = game:GetService("GuiService"):GetGuiInset()
        end)
        clickScreen(cx, cy)
        clickScreen(cx + inset.X, cy + inset.Y)
        clickScreen(cx, cy + inset.Y)
    end)
end

local function getMainGui()
    local ok, guiMod = pcall(function()
        return require(ReplicatedStorage.Library.Client.GUI)
    end)
    if ok and guiMod and guiMod.Main then
        local ok2, main = pcall(function()
            return guiMod.Main()
        end)
        if ok2 then
            return main
        end
    end
    return LP.PlayerGui:FindFirstChild("Main")
end

local function getRollingFrame()
    local main = getMainGui()
    if main then
        local r = main:FindFirstChild("Rolling")
        if r then
            return r
        end
    end
    local pg = LP:FindFirstChild("PlayerGui")
    if not pg then
        return nil
    end
    local found
    pcall(function()
        found = pg:FindFirstChild("Rolling", true)
    end)
    return found
end

local function rollGuiReady()
    return getRollingFrame() ~= nil
end

local function collectRollBlob()
    local blob = ""
    local rolling = getRollingFrame()
    if not rolling then
        return blob
    end
    pcall(function()
        for _, d in ipairs(rolling:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                blob = blob .. " " .. string.lower(d.Text or "")
            end
        end
    end)
    return blob
end

local lastDiceCf, lastDiceMove = nil, 0

local function diceMoving()
    local rolling = getRollingFrame()
    if not rolling then
        return false
    end
    local moved = false
    pcall(function()
        for _, d in ipairs(rolling:GetDescendants()) do
            if d:IsA("WorldModel") or d:IsA("ViewportFrame") or d:IsA("Model") then
                local part = d:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    local cf = part.CFrame
                    if lastDiceCf and (cf.Position - lastDiceCf.Position).Magnitude > 0.02 then
                        moved = true
                    end
                    lastDiceCf = cf
                    break
                end
            end
        end
    end)
    if moved then
        lastDiceMove = tick()
    end
    return moved or (tick() - lastDiceMove < 1.2)
end

local function isDiceBusy()
    local blob = collectRollBlob()
    if blob:find("rolling", 1, true) or blob:find("hatching", 1, true) or blob:find("revealing", 1, true) then
        return true
    end
    if blob:find("auto on", 1, true) or blob:find("stop auto", 1, true) then
        return true
    end
    if diceMoving() then
        return true
    end
    local ch = getRngChannel()
    local busy = false
    pcall(function()
        if ch and ch.HasRolling then
            busy = ch.HasRolling == true
        end
    end)
    return busy
end

local function pressHide()
    local rolling = getRollingFrame()
    if not rolling then
        return
    end
    pcall(function()
        fireBtn(rolling.Action.Hide.Button)
    end)
    pcall(function()
        for _, d in ipairs(rolling:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("ImageButton") then
                local tx = string.lower((d.Text or d.Name or ""))
                local title = d:FindFirstChild("Title")
                if title then
                    tx = tx .. " " .. string.lower(title.Text or "")
                end
                if tx:find("hide", 1, true) and d:IsA("GuiButton") then
                    fireBtn(d)
                elseif tx:find("hide", 1, true) and d.Parent and d.Parent:IsA("GuiButton") then
                    fireBtn(d.Parent)
                end
            end
        end
    end)
end

local function pressAutoBtn()
    local rolling = getRollingFrame()
    if not rolling then
        return
    end
    pcall(function()
        fireBtn(rolling.Action.Auto.Button)
    end)
    pcall(function()
        for _, d in ipairs(rolling:GetDescendants()) do
            if d:IsA("GuiButton") then
                local tx = string.lower(d.Name or "")
                local title = d:FindFirstChild("Title")
                if title then
                    tx = tx .. " " .. string.lower(title.Text or "")
                end
                if tx:find("auto", 1, true) and not tx:find("hide", 1, true) then
                    fireBtn(d)
                end
            end
        end
    end)
end

local function kickAutoRoll()
    rngFire("SetAutoRolling", true)
    if not rollGuiReady() then
        return
    end
    if isDiceBusy() then
        pressHide()
        return
    end
    pressAutoBtn()
    task.wait(0.25)
    rngFire("SetAutoRolling", true)
    pressHide()
end

local function stopAutoRoll()
    autoRollOn = false
    if rollThread then
        pcall(function()
            task.cancel(rollThread)
        end)
        rollThread = nil
    end
    rngFire("SetAutoRolling", false)
end

local function enableAutoRoll()
    if not autoRollOn then
        return
    end
    kickAutoRoll()
end

local function startRollWatch()
    if rollThread then
        pcall(function()
            task.cancel(rollThread)
        end)
        rollThread = nil
    end
    rollThread = task.spawn(function()
        local idleFor = 0
        while autoRollOn do
            rngFire("SetAutoRolling", true)
            if isDiceBusy() then
                idleFor = 0
            else
                idleFor = idleFor + 0.7
                if idleFor >= 1.4 then
                    kickAutoRoll()
                    idleFor = 0
                end
            end
            task.wait(0.7)
        end
    end)
end

local function recoverAutoRoll()
    if not autoRollOn then
        return
    end
    startRollWatch()
    task.spawn(function()
        local t = tick()
        while autoRollOn and tick() - t < 6 do
            rngFire("SetAutoRolling", true)
            if isDiceBusy() then
                pressHide()
                return
            end
            if rollGuiReady() then
                kickAutoRoll()
                return
            end
            task.wait(0.3)
        end
    end)
end

local function parseAmount(str)
    if not str then
        return nil
    end
    str = tostring(str):gsub(",", ""):gsub("%s+", "")
    local num, suf = str:match("([%d%.]+)([A-Za-z]*)")
    num = tonumber(num)
    if not num then
        return nil
    end
    suf = string.lower(suf or "")
    local mul = {k = 1e3, m = 1e6, b = 1e9, t = 1e12, qd = 1e15, qn = 1e18, qi = 1e18, sx = 1e21}
    if mul[suf] then
        num = num * mul[suf]
    end
    return num
end

local function parseLevelPair(text)
    if not text then
        return nil, nil
    end
    text = tostring(text):gsub(",", ""):gsub("%s+", "")
    local a, b = text:match("(%d+)/(%d+)")
    if a and b then
        return tonumber(a), tonumber(b)
    end
end

local function findUpgradeFrame(name)
    local content = getBoardContent()
    if not content then
        return nil
    end
    local direct = content:FindFirstChild(name)
    if direct then
        return direct
    end
    local needles = {
        BreakablesIncremental = { "breakable", "health" },
        PixelCoinsMultiplier = { "pixel coin", "coins multiplier" },
        LuckMultiplier = { "luck" },
    }
    local keys = needles[name]
    if not keys then
        return nil
    end
    for _, child in ipairs(content:GetChildren()) do
        local blob = string.lower(child.Name)
        pcall(function()
            for _, d in ipairs(child:GetDescendants()) do
                if d:IsA("TextLabel") or d:IsA("TextButton") then
                    blob = blob .. " " .. string.lower(d.Text or "")
                end
            end
        end)
        local ok = true
        for _, key in ipairs(keys) do
            if not blob:find(key, 1, true) then
                ok = false
                break
            end
        end
        if ok then
            return child
        end
    end
end

local function getUpgradeLevel(name)
    local cur, maxLvl = 0, 1
    pcall(function()
        local frame = findUpgradeFrame(name)
        if not frame then
            return
        end
        local bestA, bestB
        local function consider(text)
            local a, b = parseLevelPair(text)
            if a and b and b >= 10 then
                if not bestB or b > bestB then
                    bestA, bestB = a, b
                end
            end
        end
        pcall(function()
            consider(frame.Main.Lvl.Text)
        end)
        for _, d in ipairs(frame:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                consider(d.Text)
            end
        end
        if bestA then
            cur, maxLvl = bestA, bestB
        end
    end)
    return cur, maxLvl
end

local function allUpgradesMaxed()
    local seen = 0
    for _, name in ipairs({"BreakablesIncremental", "PixelCoinsMultiplier", "LuckMultiplier"}) do
        local cur, maxLvl = getUpgradeLevel(name)
        if maxLvl <= 1 then
            return false
        end
        seen = seen + 1
        if cur < maxLvl then
            return false
        end
    end
    return seen == 3
end

local function upgradesReset()
    local b = getUpgradeLevel("BreakablesIncremental")
    local p = getUpgradeLevel("PixelCoinsMultiplier")
    local l = getUpgradeLevel("LuckMultiplier")
    return b < 20 and p < 50 and l < 20
end

local function buyRemote(name, n)
    if not Network then
        return
    end
    n = n or 50
    pcall(function()
        Network.InvokeServer(name, n)
    end)
    pcall(function()
        Network.InvokeServer(name, 1)
    end)
end

local function buyOne(name)
    local n = 50
    local frame = findUpgradeFrame(name)
    if frame then
        local buyMaxBtn = frame:FindFirstChild("Buttons") and frame.Buttons:FindFirstChild("BuyMax") and frame.Buttons.BuyMax:FindFirstChild("Button")
        local title = buyMaxBtn and buyMaxBtn:FindFirstChild("Title")
        if title and title.Text then
            n = tonumber(title.Text:match("%((%d+)%)")) or n
        end
        if n < 1 then
            n = 1
        end
        buyRemote(name, n)
        if buyMaxBtn then
            fireBtn(buyMaxBtn)
        end
        local buyBtn = frame:FindFirstChild("Buttons") and frame.Buttons:FindFirstChild("Buy") and frame.Buttons.Buy:FindFirstChild("Button")
        if buyBtn then
            fireBtn(buyBtn)
        end
        return
    end
    buyRemote(name, n)
end

local function buyAllOnce()
    local b, bm = getUpgradeLevel("BreakablesIncremental")
    local p, pm = getUpgradeLevel("PixelCoinsMultiplier")
    local l, lm = getUpgradeLevel("LuckMultiplier")
    if b < bm or p < pm then
        if b < bm then
            buyOne("BreakablesIncremental")
        end
        if p < pm then
            buyOne("PixelCoinsMultiplier")
        end
        return
    end
    if l < lm then
        buyOne("LuckMultiplier")
    end
end

local function rebirthGuiOpen()
    local gui = LP.PlayerGui:FindFirstChild("RNGRebirth")
    if not gui or gui.Enabled == false then
        return nil
    end
    return gui
end

local function considerRebirthTotal(n)
    n = tonumber(n)
    if not n or n < 0 or n > 1e12 then
        return
    end
    if typeof(totalRebirths) ~= "number" or n > totalRebirths then
        totalRebirths = math.floor(n)
    end
end

local function readRebirthsFromCurrency()
    if not Currency or not Currency.Get then
        return
    end
    for _, name in ipairs({
        "RngRebirths", "RNGRebirths", "RNG2Rebirths", "Rebirths", "rng rebirths", "RNG rebirths"
    }) do
        local ok, val = pcall(function()
            return Currency.Get(name)
        end)
        if ok and type(val) == "number" and val > 0 then
            considerRebirthTotal(val)
        end
    end
end

local function readRebirthsFromGui(root, allowBareNumber)
    if not root then
        return
    end
    pcall(function()
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local t = obj.Text or ""
                local raw = t:match("Rebirth!%s*%((.-)%)")
                if raw then
                    local num = parseAmount(raw)
                    if num then
                        cachedCostText = raw
                        cachedCostNum = num
                        costFresh = true
                    end
                end
                local low = string.lower(t .. " " .. obj.Name)
                local cleaned = t:gsub(",", "")
                if allowBareNumber and t:match("^[%d,]+$") then
                    local n = tonumber(cleaned)
                    if n and n >= 1 then
                        considerRebirthTotal(n)
                    end
                elseif low:find("rebirth", 1, true) then
                    local n = tonumber(cleaned:match("(%d+)"))
                    if n and n >= 1 then
                        considerRebirthTotal(n)
                    end
                end
            end
        end
    end)
end

local function updateRebirthCost()
    readRebirthsFromCurrency()
    local gui = rebirthGuiOpen() or (LP.PlayerGui and LP.PlayerGui:FindFirstChild("RNGRebirth"))
    if gui then
        readRebirthsFromGui(gui, true)
    end
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if not pg then
            return
        end
        for _, name in ipairs({"Main", "Rebirths", "HUD", "RNGRebirth"}) do
            local g = pg:FindFirstChild(name)
            if g then
                readRebirthsFromGui(g, name == "RNGRebirth" or name == "Rebirths")
            end
        end
    end)
end

local function updateRate()
    if not cachedCoinsNum then
        return
    end
    local now = tick()
    if sampleCoins and sampleTime and now - sampleTime >= 8 then
        local gained = cachedCoinsNum - sampleCoins
        local dt = now - sampleTime
        if dt > 0 then
            local instant = gained / dt
            if instant > 0 then
                coinRate = (coinRate == 0) and instant or (coinRate * 0.7 + instant * 0.3)
            end
        end
        sampleCoins, sampleTime = cachedCoinsNum, now
    elseif not sampleCoins then
        sampleCoins, sampleTime = cachedCoinsNum, now
    end
end

local function refreshEtaAvg()
    local maxed = false
    pcall(function()
        maxed = allUpgradesMaxed()
    end)
    if not maxed or not costFresh or not cachedCostNum or not cachedCoinsNum then
        etaText = "-"
    elseif cachedCoinsNum >= cachedCostNum then
        etaText = "Ready"
    elseif coinRate > 0 then
        etaText = formatTime((cachedCostNum - cachedCoinsNum) / coinRate)
    else
        etaText = "-"
    end
    if sessionRebirths <= 0 then
        avgText = formatTime(tick() - cycleStart)
    else
        avgText = formatTime(totalCycleTime / sessionRebirths)
    end
    if not merchantOn then
        merchantText = "Off"
    elseif not restockAt then
        merchantText = "..."
    else
        local left = restockAt - tick()
        if left <= 0 then
            merchantText = "Now"
        else
            merchantText = formatTime(left)
        end
    end
end

local function canAfford()
    updateCoins()
    return costFresh and cachedCostNum ~= nil and cachedCoinsNum ~= nil and cachedCoinsNum >= cachedCostNum
end

local function waitRebirthGui(timeout)
    local t = tick()
    while tick() - t < (timeout or 8) do
        local gui = rebirthGuiOpen()
        if gui then
            updateRebirthCost()
            return gui
        end
        task.wait(0.15)
    end
    return rebirthGuiOpen()
end

local function pressRebirth(gui)
    gui = gui or rebirthGuiOpen()
    pcall(function()
        Network.InvokeServer("RNGRebirth")
    end)
    pcall(function()
        Network.InvokeServer("Rebirth")
    end)
    pcall(function()
        Network.InvokeServer("DoRebirth")
    end)
    if not gui then
        return
    end
    pcall(function()
        clickGui(gui.Frame.Content.Rebirth.Button)
    end)
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("ImageButton") or obj:IsA("TextButton") or obj:IsA("GuiButton") then
            local title = obj:FindFirstChild("Title", true)
            local tx = string.lower(((title and title.Text) or obj.Text or obj.Name or ""))
            if tx:find("rebirth") then
                clickGui(obj)
            end
        elseif obj:IsA("TextLabel") then
            local tx = string.lower(obj.Text or "")
            if tx:find("rebirth!") and obj.Parent and obj.Parent:IsA("GuiButton") then
                clickGui(obj.Parent)
            end
        end
    end
end

local function merchantGui()
    local gui = LP.PlayerGui:FindFirstChild("Merchant")
    if gui and gui.Enabled ~= false then
        return gui
    end
end

local function parseRestockFromBlob(blob)
    if not blob then
        return nil
    end
    local t = string.lower(tostring(blob))
    local n = tonumber(t:match("restock[%w%s:]*?(%d+)%s*min"))
    if n then
        return n * 60
    end
    n = tonumber(t:match("restock[%w%s:]*?(%d+)%s*sec"))
    if n then
        return n
    end
    n = tonumber(t:match("(%d+)%s*minutes?"))
    if n and t:find("restock") then
        return n * 60
    end
    n = tonumber(t:match("(%d+)%s*seconds?"))
    if n and t:find("restock") then
        return n
    end
end

local function captureRestock(gui)
    gui = gui or merchantGui()
    if not gui then
        return
    end
    local parts = {}
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            table.insert(parts, obj.Text or "")
        end
    end
    local sec = parseRestockFromBlob(table.concat(parts, " "))
    if sec then
        restockAt = tick() + math.max(sec, 3)
    end
end

local function clickScreen(x, y)
    pcall(function()
        if mousemoveabs then
            mousemoveabs(x, y)
        end
    end)
    pcall(function()
        if mouse1click then
            mouse1click()
        end
    end)
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.02)
        vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
end

local function fireMerchantBtn(btn)
    clickGui(btn)
    local off
    pcall(function()
        local name = btn:GetFullName()
        local slot = tonumber(name:match("Offer_(%d+)"))
        if slot then
            buyOfferRemote(slot)
        end
    end)
end

local function readOfferStock(offer)
    if not offer then
        return 0
    end
    for _, d in ipairs(offer:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local n = tostring(d.Text or ""):match("[xX]%s*(%d+)%s*in%s*Stock")
            if n then
                return tonumber(n) or 0
            end
        end
    end
    return 0
end

local function readOffers(gui)
    local rows = {}
    if not gui then
        return rows
    end
    local offers
    pcall(function()
        offers = gui.Frame.Frame.Offers
    end)
    if not offers then
        return rows
    end
    for i = 1, 3 do
        local offer = offers:FindFirstChild("Offer_" .. i)
        if offer then
            local btn
            pcall(function()
                btn = offer.Content.Action.Button
            end)
            rows[i] = {
                offer = offer,
                btn = btn,
                stock = readOfferStock(offer)
            }
        end
    end
    return rows
end

local function waitStockDrop(offer, before, timeout)
    local t = tick()
    while tick() - t < (timeout or 0.55) do
        local now = readOfferStock(offer)
        if now < before then
            return true, now
        end
        task.wait(0.04)
    end
    return false, readOfferStock(offer)
end

local function slotStock(i)
    if merchantOffers[i] then
        return merchantOffers[i].stock
    end
    return -1
end

local function totalCachedStock()
    local n = 0
    local any = false
    for i = 1, 3 do
        if merchantOffers[i] then
            n = n + (merchantOffers[i].stock or 0)
            any = true
        end
    end
    if any then
        return n
    end
    return -1
end

local function buyOfferRemote(i)
    local off = merchantOffers[i]
    local key = off and off.key or ("respect_tier_" .. i)
    local kind = merchantKind or "DicesMerchant"
    if not Network then
        return
    end
    pcall(function()
        Network.InvokeServer(kind, key)
    end)
    pcall(function()
        Network.InvokeServer(kind, i)
    end)
    pcall(function()
        Network.InvokeServer(key)
    end)
    pcall(function()
        if Network.FireServer then
            Network.FireServer(kind, key)
        end
    end)
end

local function waitCachedStockDrop(i, before, timeout)
    local t = tick()
    while tick() - t < (timeout or 0.7) do
        local now = slotStock(i)
        if now >= 0 and now < before then
            return true
        end
        task.wait(0.05)
    end
    return false
end

local function currentStock(i, rows)
    local s = slotStock(i)
    if s >= 0 then
        return s
    end
    if rows and rows[i] then
        return rows[i].stock or 0
    end
    return 0
end

local function offerBlockedText(offer)
    if not offer then
        return false
    end
    for _, d in ipairs(offer:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local t = string.lower(tostring(d.Text or ""))
            if t:find("not enough") or t:find("out of stock") then
                return true
            end
        end
    end
    return false
end

local function canBuySlot(i, rows)
    updateCoins()
    local stock = currentStock(i, rows)
    if stock <= 0 then
        return false
    end
    local off = merchantOffers[i]
    if off and off.unlocked == false then
        return false
    end
    if off and off.price and cachedCoinsNum and off.price > cachedCoinsNum then
        return false
    end
    if rows and rows[i] and offerBlockedText(rows[i].offer) then
        return false
    end
    return true
end

local function anyBuyable(rows)
    for i = 1, 3 do
        if canBuySlot(i, rows) then
            return true
        end
    end
    return false
end

local function buyMerchantOffers(gui)
    local started = tick()
    for i = 1, 3 do
        local fails = 0
        while tick() - started < 18 and fails < 4 do
            gui = merchantGui() or gui
            local rows = readOffers(gui)
            if not canBuySlot(i, rows) then
                break
            end
            local before = currentStock(i, rows)
            local left = 0
            for s = 1, 3 do
                if canBuySlot(s, rows) then
                    left = left + currentStock(s, rows)
                end
            end
            setStatus("Buying dice " .. tostring(left))
            if rows[i] and rows[i].btn then
                fireMerchantBtn(rows[i].btn)
            else
                fails = fails + 1
                task.wait(0.2)
            end
            local dropped = waitCachedStockDrop(i, before, 0.55)
            if not dropped and rows[i] and rows[i].offer then
                dropped = waitStockDrop(rows[i].offer, before, 0.35)
            end
            if dropped then
                fails = 0
            else
                fails = fails + 1
                task.wait(0.12)
            end
        end
    end
end

local function waitMerchantGui(timeout)
    local t = tick()
    while tick() - t < (timeout or 7) do
        local gui = merchantGui()
        if gui then
            return gui
        end
        task.wait(0.15)
    end
    return merchantGui()
end

local function visitMerchant()
    if not merchantOn then
        return
    end
    merchantBusy = true
    setStatus("Going Merchant")
    if not eventEntered then
        invokeNet("RNGEvent")
        task.wait(2.2)
        eventEntered = true
    end
    smoothTP(MERCHANT_NEAR, 18)
    task.wait(0.6)
    smoothTP(MERCHANT_CF, 22)
    task.wait(1.1)
    local gui = waitMerchantGui(7)
    if gui then
        captureRestock(gui)
        local rows = readOffers(gui)
        if anyBuyable(rows) then
            setStatus("Buying dice")
            buyMerchantOffers(gui)
            task.wait(0.25)
        else
            setStatus("Merchant empty")
        end
        captureRestock(gui)
        if running then
            setStatus("Merchant done")
        else
            setStatus("Merchant done - turn on Full Cycle")
        end
    else
        setStatus("Merchant GUI missing")
        if not restockAt then
            restockAt = tick() + 300
        end
    end
    if not restockAt then
        restockAt = tick() + 300
    end
    lastMerchantVisit = tick()
    merchantBusy = false
end

local function merchantDue()
    if not merchantOn or merchantBusy then
        return false
    end
    if restockAt and tick() >= (restockAt - 1) then
        return true
    end
    if tick() - lastMerchantVisit < 25 then
        return false
    end
    return anyBuyable(readOffers(merchantGui()))
end

local function enterVoidSlow()
    smoothTP(VOID_NEAR, 20)
    task.wait(0.8)
    smoothTP(VOID_CF, 28)
    task.wait(1.2)
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = VOID_CF
    end
end

local function goWinter()
    setStatus("Going Winter")
    invokeNet("RNGWinter")
    task.wait(2.2)
    smoothTP(WINTER_CF)
    waitBoard(8)
    task.wait(0.6)
end

local function goVoidOpenGui()
    invokeNet("RNGVoid")
    task.wait(2.8)
    enterVoidSlow()
    return waitRebirthGui(8)
end

local function onRebirthSuccess()
    local now = tick()
    totalCycleTime = totalCycleTime + (now - lastRebirthAt)
    lastRebirthAt = now
    sessionRebirths = sessionRebirths + 1
    if typeof(totalRebirths) == "number" then
        totalRebirths = totalRebirths + 1
    end
    cachedCostText, cachedCostNum = "-", nil
    costFresh = false
    sampleCoins, sampleTime, coinRate = nil, nil, 0
    task.wait(1.5)
    if autoRollOn then
        startRollWatch()
        recoverAutoRoll()
    end
end

local function visitVoid()
    if merchantDue() then
        return "merchant"
    end
    setStatus("Traveling to Void")
    local gui = goVoidOpenGui()
    if not gui then
        setStatus("Rebirth menu missing")
        goWinter()
        return "no_gui"
    end
    task.wait(1.2)
    updateRebirthCost()
    updateCoins()
    if not canAfford() then
        setStatus("Not enough coins")
        goWinter()
        return "farm"
    end
    local beforeCoins = cachedCoinsNum
    setStatus("Attempting rebirth")
    for _ = 1, 4 do
        pressRebirth(rebirthGuiOpen() or gui)
        local t = tick()
        while tick() - t < 2.5 do
            if upgradesReset() then
                onRebirthSuccess()
                setStatus("Rebirth complete")
                return "success"
            end
            updateCoins()
            if beforeCoins and cachedCoinsNum and cachedCoinsNum < beforeCoins * 0.2 then
                onRebirthSuccess()
                setStatus("Rebirth complete")
                return "success"
            end
            task.wait(0.2)
        end
    end
    setStatus("Rebirth click failed, retry")
    goWinter()
    return "farm"
end

local function farmWinter()
    local hasBoard = waitBoard(6)
    if not hasBoard then
        setStatus("Winter board missing - remote buy")
    end
    local started = tick()
    while running do
        if merchantDue() then
            return "need_merchant"
        end
        updateCoins()
        updateRate()
        if not allUpgradesMaxed() then
            local b, bm = getUpgradeLevel("BreakablesIncremental")
            local p, pm = getUpgradeLevel("PixelCoinsMultiplier")
            local l, lm = getUpgradeLevel("LuckMultiplier")
            if not hasBoard then
                hasBoard = waitBoard(1)
                setStatus("Buying upgrades (remote)")
                buyRemote("BreakablesIncremental", 50)
                buyRemote("PixelCoinsMultiplier", 50)
                if b >= bm and p >= pm then
                    buyRemote("LuckMultiplier", 50)
                end
            elseif b < bm or p < pm then
                setStatus(string.format("Coins + Break  %d/%d  %d/%d", b, bm, p, pm))
            else
                setStatus(string.format("Luck  %d/%d", l, lm))
            end
            buyAllOnce()
        else
            if merchantDue() then
                return "need_merchant"
            end
            if canAfford() then
                return "need_void"
            end
            if not costFresh and tick() - started > 12 then
                return "need_void"
            end
            setStatus("Maxed - farming " .. tostring(cachedCostText))
        end
        task.wait(0.4)
    end
    return "stop"
end

local function doFullCycle()
    if not eventEntered then
        setStatus("Entering event")
        invokeNet("RNGEvent")
        task.wait(2.2)
        eventEntered = true
    end
    if merchantOn then
        visitMerchant()
    end
    goWinter()
    if autoRollOn then
        recoverAutoRoll()
    end
    while running do
        local result = farmWinter()
        if result == "stop" or not running then
            return
        end
        if result == "need_merchant" then
            visitMerchant()
            goWinter()
            if autoRollOn then
                recoverAutoRoll()
            end
        elseif result == "need_void" then
            if merchantDue() then
                visitMerchant()
                goWinter()
                if autoRollOn then
                    recoverAutoRoll()
                end
            else
                local r = visitVoid()
                if r == "merchant" then
                    visitMerchant()
                    goWinter()
                    if autoRollOn then
                        recoverAutoRoll()
                    end
                elseif r == "success" then
                    setStatus("Restarting farm")
                    if merchantDue() then
                        visitMerchant()
                    end
                    goWinter()
                    if autoRollOn then
                        recoverAutoRoll()
                    end
                end
            end
        end
    end
end


local function bootRaid()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:WaitForChild("Remotes")
    local Init = remotes and remotes:FindFirstChild("Init")

    local function raidSay(t)
        Raid.status = tostring(t or "")
        print("[raid]", Raid.status)
    end

    local function raidFmtNum(n)
        n = math.floor(tonumber(n) or 0)
        local s = tostring(n)
        local k
        while true do
            s, k = string.gsub(s, "^(-?%d+)(%d%d%d)", "%1,%2")
            if k == 0 then
                break
            end
        end
        return s
    end

    local function raidFarmSec()
        local t = Raid.acc
        if Raid.onAt > 0 then
            t = t + (os.clock() - Raid.onAt)
        end
        return t
    end

    local function raidFmtTime(sec)
        sec = math.floor(sec or 0)
        local h = math.floor(sec / 3600)
        local m = math.floor((sec % 3600) / 60)
        local s = sec % 60
        if h > 0 then
            return string.format("%d:%02d:%02d", h, m, s)
        end
        return string.format("%d:%02d", m, s)
    end

    local function grabRaidStats()
        pcall(function()
            if Currency and Currency.Get then
                local v = Currency.Get("RaidPoints")
                if type(v) == "number" then
                    Raid.points = v
                end
            end
        end)
        pcall(function()
            local lab = LP.PlayerGui.RaidLvlDmg.Container.Progress.Lvl
            local n = tonumber(string.match(lab.Text or "", "%d+"))
            if n then
                Raid.lvl = n
            end
        end)
    end

    local function raidDiffFromLvl(lvl)
        lvl = tonumber(lvl) or 0
        if lvl >= 2500 then
            return 5
        end
        if lvl >= 1200 then
            return 4
        end
        if lvl >= 500 then
            return 3
        end
        if lvl >= 100 then
            return 2
        end
        return 1
    end

    local function raidInvoke(ev, a, b, c)
        if not ev then
            return nil
        end
        local res
        local ok = pcall(function()
            if c ~= nil then
                res = ev:InvokeServer(a, b, c)
            elseif b ~= nil then
                res = ev:InvokeServer(a, b)
            elseif a ~= nil then
                res = ev:InvokeServer(a)
            else
                res = ev:InvokeServer()
            end
        end)
        if not ok then
            return nil
        end
        return res
    end

    local function findRaidCluster()
        local list = remotes:GetChildren()
        local slotsI, slotsEv
        for i = 130, math.min(180, #list) do
            local ev = list[i]
            if ev and ev:IsA("RemoteFunction") then
                local res
                local ok = pcall(function()
                    res = ev:InvokeServer()
                end)
                if ok and type(res) == "table" then
                    for _, info in pairs(res) do
                        if type(info) == "table" and info.Slot ~= nil and info.Difficulty ~= nil then
                            slotsI, slotsEv = i, ev
                            break
                        end
                    end
                end
            end
            if slotsEv then
                break
            end
        end
        if not slotsI then
            slotsI = 146
            slotsEv = list[146]
        end
        local function at(off)
            return list[slotsI + off]
        end
        return {
            slots = slotsEv,
            claim = at(1),
            cfg = at(2),
            start = at(4),
            unclaim = at(3),
            hit = at(15),
            lobbyRF = at(16),
            leave = at(17),
            lobbyRE = at(18),
        }
    end

    local function raidPetGuids()
        local out = {}
        pcall(function()
            local Pet = require(ReplicatedStorage.Library.Client.Pet)
            for _, data in pairs(Pet.Pets) do
                if type(data) == "table" and type(data.GUID) == "string" and #data.GUID == 16 then
                    table.insert(out, data.GUID)
                end
            end
        end)
        return out
    end

    local function raidSlotState(R)
        local mine, empty
        pcall(function()
            local all = R.slots:InvokeServer()
            if type(all) ~= "table" then
                return
            end
            for _, info in pairs(all) do
                if type(info) == "table" then
                    if info.OwnerName == LP.Name or info.OwnerId == LP.UserId then
                        mine = info.Slot
                    elseif not empty and info.Started ~= true and (info.OwnerName == nil or info.OwnerName == "") then
                        empty = info.Slot
                    end
                end
            end
        end)
        return mine, empty
    end

    local function raidGroundY(pos)
        local origin = pos + Vector3.new(0, 30, 0)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        if LP.Character then
            params.FilterDescendantsInstances = {LP.Character}
        end
        local hit = workspace:Raycast(origin, Vector3.new(0, -90, 0), params)
        if hit then
            return hit.Position.Y + 3.2
        end
        return pos.Y
    end

    local function raidSmoothTo(pos, lookAt)
        local hrp = getHRP()
        if not hrp then
            return
        end
        local y = raidGroundY(pos)
        local dest = Vector3.new(pos.X, y, pos.Z)
        local look = lookAt or dest
        local goal = CFrame.new(dest, Vector3.new(look.X, y, look.Z))
        local startCf = hrp.CFrame
        for i = 1, 4 do
            if hrp.Parent then
                hrp.CFrame = startCf:Lerp(goal, i / 4)
            end
            task.wait(0.01)
        end
        if hrp.Parent then
            hrp.CFrame = goal
        end
    end

    local function raidRoomGates()
        local out = {}
        local rooms
        pcall(function()
            rooms = workspace._THINGS.Minigames.RaidLobby.Rooms
        end)
        if not rooms then
            return out
        end
        for i = 1, 6 do
            local room = rooms:FindFirstChild(tostring(i))
            if room then
                local gate = room:FindFirstChild("Gate")
                local hit = gate and gate:FindFirstChild("Hitbox")
                if hit then
                    table.insert(out, {n = i, part = hit, room = room})
                end
            end
        end
        return out
    end

    local function raidPushPath(R, pets)
        local gates = raidRoomGates()
        if #gates == 0 then
            raidSay("No Rooms.Gate")
            return
        end
        for i = 1, #gates do
            if not Raid.on then
                break
            end
            local g = gates[i]
            raidSay("Gate " .. tostring(g.n) .. " / 6")
            local part = g.part
            local hrp = getHRP()
            if not hrp then
                break
            end
            local flat = Vector3.new(part.Position.X - hrp.Position.X, 0, part.Position.Z - hrp.Position.Z)
            if flat.Magnitude < 0.05 then
                flat = Vector3.new(0, 0, -1)
            else
                flat = flat.Unit
            end
            raidSmoothTo(part.Position - flat * 5, part.Position)

            local function hpNow()
                local bh = g.room:FindFirstChild("BreakableHealth")
                if not bh then
                    return nil
                end
                local lab = bh:FindFirstChild("Label", true)
                if not (lab and lab:IsA("TextLabel")) then
                    return nil
                end
                return tonumber(string.match(lab.Text or "", "([%d%.]+)%s*/"))
            end

            local hitting = true
            task.spawn(function()
                while hitting and Raid.on do
                    for p = 1, #pets do
                        if not hitting then
                            break
                        end
                        task.spawn(function()
                            raidInvoke(R.hit, tostring(g.n), pets[p])
                        end)
                    end
                    task.wait(0.08)
                end
            end)

            local t0 = os.clock()
            local seenHp
            local damaged = false
            while Raid.on do
                local hp = hpNow()
                if hp then
                    seenHp = seenHp or hp
                    if hp < seenHp then
                        damaged = true
                    end
                end
                if hp == 0 then
                    break
                end
                if damaged and hp == nil then
                    break
                end
                if os.clock() - t0 > 15 then
                    break
                end
                task.wait(0.04)
            end
            hitting = false
        end
    end

    local function findEmperor()
        local best
        pcall(function()
            best = workspace._THINGS.Minigames.RaidEvent.Map.Scenery.Decor.EmperorEgg.EggModel
        end)
        if best then
            return best
        end
        pcall(function()
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("BasePart") and string.find(string.lower(d.Name), "emperor", 1, true) then
                    best = d
                    break
                end
            end
        end)
        return best
    end

    local function hatchEmperor()
        if not Raid.hatch then
            raidSay("Hatch skipped")
            return
        end
        raidSay("Hatch Emperor")
        local part = findEmperor()
        pcall(function()
            if part then
                local cf = part:IsA("Model") and part:GetPivot() or part.CFrame
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = cf * CFrame.new(0, 3, 6)
                end
            end
        end)
        task.wait(0.45)
        local amt = 12
        task.spawn(function()
            pcall(function()
                local OpenEgg = require(ReplicatedStorage.Library.Client.OpenEgg)
                pcall(function()
                    OpenEgg.Request("EmperorEgg", amt)
                end)
                pcall(function()
                    OpenEgg.Play("EmperorEgg", amt)
                end)
            end)
            local guid = HttpService:GenerateGUID(false)
            local list = remotes:GetChildren()
            for _, i in ipairs({91, 90, 92, 89}) do
                local ev = list[i]
                if ev and ev:IsA("RemoteFunction") then
                    pcall(function()
                        ev:InvokeServer("EmperorEgg", amt, guid)
                    end)
                end
            end
        end)
        task.wait(1.4)
        raidSay("Hatch done")
    end

    local function raidGo()
        Raid.busy = true
        raidSay("Resolve remotes")
        local R = findRaidCluster()
        task.wait(0.2)
        local mine, empty = raidSlotState(R)
        local slot = mine or empty or 1
        local claimed = mine ~= nil
        if mine then
            raidSay("Reuse slot " .. tostring(mine))
        else
            claimed = raidInvoke(R.claim, slot) == true
            if not claimed then
                for i = 1, 10 do
                    if raidInvoke(R.claim, i) == true then
                        slot, claimed = i, true
                        break
                    end
                end
            end
        end
        if not claimed and R.unclaim then
            for i = 1, 10 do
                raidInvoke(R.unclaim, i)
            end
            task.wait(0.4)
            mine, empty = raidSlotState(R)
            slot = empty or 1
            claimed = raidInvoke(R.claim, slot) == true
        end
        if not claimed then
            raidSay("No empty slot")
            Raid.busy = false
            return
        end

        pcall(grabRaidStats)
        local want = raidDiffFromLvl(Raid.lvl)
        local set
        for d = want, 1, -1 do
            if raidInvoke(R.cfg, slot, d, "Public") then
                set = d
                break
            end
        end
        raidSay("Diff " .. tostring(set or want) .. " lvl " .. tostring(Raid.lvl))

        local started = raidInvoke(R.start, slot)
        raidSay("Start " .. tostring(started))

        if Init then
            pcall(function()
                Init:FireServer("RaidPortals", "RemoteEvent", "SlotUpdated")
                Init:FireServer("RaidGates", "RemoteEvent", "State")
                Init:FireServer("RaidGates", "RemoteEvent", "Snapshot")
            end)
        end
        raidInvoke(R.lobbyRF, "RaidLobby")
        pcall(function()
            if R.lobbyRE and R.lobbyRE.FireServer then
                R.lobbyRE:FireServer("RaidLobby")
            end
        end)

        raidSay("Wait instance")
        task.wait(0.4)
        local pets = raidPetGuids()
        if #pets == 0 then
            raidSay("No pets")
            Raid.busy = false
            return
        end
        local readyAt = os.clock()
        while #raidRoomGates() == 0 and os.clock() - readyAt < 6 and Raid.on do
            raidSay("Wait rooms")
            task.wait(0.2)
        end
        if #raidRoomGates() == 0 then
            raidSay("No rooms")
            Raid.busy = false
            return
        end
        raidPushPath(R, pets)
        Raid.raids = Raid.raids + 1

        raidSay("Leaving")
        task.wait(0.35)
        pcall(function()
            raidInvoke(R.leave)
        end)
        task.wait(0.3)
        pcall(function()
            if R.unclaim then
                raidInvoke(R.unclaim, slot)
            end
        end)
        raidSay("Wait hatch world")
        task.wait(1.2)
        pcall(hatchEmperor)
        if Raid.hatch then
            Raid.eggs = Raid.eggs + 12
        end
        Raid.busy = false
        raidSay(Raid.on and "Loop" or "Done")
    end

    local raidThread
    local function startRaidLoop()
        if raidThread then
            return
        end
        Raid.on = true
        Raid.onAt = os.clock()
        raidThread = task.spawn(function()
            while Raid.on do
                local ok, err = pcall(raidGo)
                if not ok then
                    raidSay("Retry")
                    print("[raid] err", err)
                end
                if not Raid.on then
                    break
                end
                raidSay("Next raid")
                task.wait(1.4)
            end
            Raid.busy = false
            raidThread = nil
            raidSay("Stopped")
        end)
    end

    local function stopRaidLoop()
        Raid.on = false
        Raid.busy = false
        raidThread = nil
        if Raid.onAt > 0 then
            Raid.acc = Raid.acc + (os.clock() - Raid.onAt)
            Raid.onAt = 0
        end
        raidSay("Stopped")
    end

    Raid.grab = grabRaidStats
    Raid.fmtNum = raidFmtNum
    Raid.farmSec = raidFarmSec
    Raid.fmtTime = raidFmtTime
    Raid.start = startRaidLoop
    Raid.stop = stopRaidLoop
end
bootRaid()

local function getHost()
    local pg = LP.PlayerGui
    local main = pg:FindFirstChild("Main")
    if main then
        return main
    end
    for _, g in ipairs(pg:GetChildren()) do
        if g:IsA("LayerCollector") then
            return g
        end
    end
    return pg
end

local function bootUi()
local open = true
local host = getHost()
local overlay = LP.PlayerGui:FindFirstChild("OsamaSide")
if overlay then
    overlay:Destroy()
end
overlay = Instance.new("ScreenGui")
overlay.Name = "OsamaSide"
overlay.ResetOnSpawn = false
overlay.IgnoreGuiInset = true
overlay.DisplayOrder = 120
overlay.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
overlay.Parent = LP.PlayerGui
pcall(function()
    local old = host:FindFirstChild("OsamaHub")
    if old then
        old:Destroy()
    end
    local oldW = host:FindFirstChild("OsamaWarn")
    if oldW then
        oldW:Destroy()
    end
    local oldS = host:FindFirstChild("OsamaMercCard")
    if oldS then
        oldS:Destroy()
    end
end)
pcall(function()
    local old = LP.PlayerGui:FindFirstChild("OsamaHub")
    if old then
        old:Destroy()
    end
end)

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

local function stroke(p, col, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or LINE
    s.Transparency = tr or 0.4
    s.Thickness = 1
    s.Parent = p
end

local function txt(parent, props)
    local x = Instance.new("TextLabel")
    x.BackgroundTransparency = 1
    x.Font = Enum.Font.GothamMedium
    x.TextColor3 = WHITE
    x.TextSize = 12
    x.TextXAlignment = Enum.TextXAlignment.Left
    for k, v in pairs(props) do
        x[k] = v
    end
    x.Parent = parent
    return x
end

local Panel = Instance.new("Frame")
Panel.Name = "OsamaHub"
Panel.Size = UDim2.new(0, 236, 0, 338)
Panel.Position = UDim2.new(0, 16, 0.22, 0)
Panel.BackgroundColor3 = BG
Panel.BorderSizePixel = 0
Panel.ZIndex = 50
Panel.Parent = host
corner(Panel, 14)
stroke(Panel, Color3.fromRGB(48, 52, 64), 0.35)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, -20, 0, 40)
header.Position = UDim2.new(0, 10, 0, 10)
header.BackgroundTransparency = 1
header.Parent = Panel

local badge = Instance.new("Frame")
badge.Size = UDim2.new(0, 26, 0, 26)
badge.Position = UDim2.new(0, 2, 0.5, -13)
badge.BackgroundColor3 = Color3.fromRGB(26, 22, 14)
badge.BorderSizePixel = 0
badge.Parent = header
corner(badge, 7)
stroke(badge, GOLD, 0.45)
txt(badge, {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "O",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = GOLD,
    TextXAlignment = Enum.TextXAlignment.Center
})
txt(header, {
    Size = UDim2.new(1, -50, 0, 16),
    Position = UDim2.new(0, 36, 0, 4),
    Text = "OSAMA HUB",
    Font = Enum.Font.GothamBold,
    TextSize = 14
})
txt(header, {
    Size = UDim2.new(1, -50, 0, 14),
    Position = UDim2.new(0, 36, 0, 20),
    Text = "RNG - Clicker Simulator",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = MUTED
})

StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 7, 0, 7)
StatusDot.Position = UDim2.new(1, -8, 0, 8)
StatusDot.BackgroundColor3 = Color3.fromRGB(70, 76, 90)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = header
corner(StatusDot, 8)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 54)
divider.BackgroundColor3 = LINE
divider.BorderSizePixel = 0
divider.Parent = Panel

local function makeToggle(text, sub, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 34)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = ROW
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = Panel
    corner(btn, 10)
    txt(btn, {
        Size = UDim2.new(1, -56, 0, 15),
        Position = UDim2.new(0, 12, 0, 5),
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12
    })
    txt(btn, {
        Size = UDim2.new(1, -56, 0, 13),
        Position = UDim2.new(0, 12, 0, 21),
        Text = sub,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = MUTED
    })
    local pill = Instance.new("Frame")
    pill.Name = "Pill"
    pill.Size = UDim2.new(0, 32, 0, 18)
    pill.Position = UDim2.new(1, -42, 0.5, -9)
    pill.BackgroundColor3 = Color3.fromRGB(34, 38, 48)
    pill.Parent = btn
    corner(pill, 9)
    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(210, 214, 224)
    knob.Parent = pill
    corner(knob, 8)
    return btn, pill, knob
end

local CycleBtn, CyclePill, CycleKnob = makeToggle("Auto RNG Rebirth", "Winter + Void", 58)
local MercBtn, MercPill, MercKnob = makeToggle("Dice Merchant", "Buy on restock", 96)
local ComboBtn, ComboPill, ComboKnob = makeToggle("Dice + Auto RNG", "Merchant then rebirth", 134)
local RollBtn, RollPill, RollKnob = makeToggle("Auto Roll", "Keep rolling", 172)
local AfkBtn, AfkPill, AfkKnob = makeToggle("Anti-AFK", "No idle kick", 210)
local RaidBtn, RaidPill, RaidKnob = makeToggle("Auto Raid", "Gates + leave + hatch", 248)
local HatchBtn, HatchPill, HatchKnob = makeToggle("Hatch Emperor", "x12 after raid", 286)

local function setToggle(pill, knob, on, onColor)
    pcall(function()
        TweenService:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            BackgroundColor3 = on and onColor or Color3.fromRGB(34, 38, 48)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            Position = on and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
            BackgroundColor3 = on and Color3.new(1, 1, 1) or Color3.fromRGB(210, 214, 224)
        }):Play()
    end)
end

local stats = Instance.new("Frame")
stats.Name = "OsamaRngCard"
stats.Size = UDim2.new(0, 188, 0, 168)
stats.Position = UDim2.new(1, 12, 0, 0)
stats.BackgroundColor3 = BG
stats.BorderSizePixel = 0
stats.Visible = false
stats.ZIndex = 80
stats.Parent = Panel
corner(stats, 14)
stroke(stats, Color3.fromRGB(48, 52, 64), 0.35)

Status = txt(stats, {
    Size = UDim2.new(1, -16, 0, 14),
    Position = UDim2.new(0, 10, 0, 8),
    Text = "Idle",
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextColor3 = GOLD
})

local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -20, 0, 1)
sep.Position = UDim2.new(0, 10, 0, 28)
sep.BackgroundColor3 = LINE
sep.BorderSizePixel = 0
sep.Parent = stats

local function row(y, key)
    txt(stats, {
        Size = UDim2.new(0.52, 0, 0, 16),
        Position = UDim2.new(0, 10, 0, y),
        Text = key,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = MUTED
    })
    return txt(stats, {
        Size = UDim2.new(0.44, 0, 0, 16),
        Position = UDim2.new(0.52, 0, 0, y),
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right
    })
end

CoinLbl = row(32, "COINS")
CostLbl = row(50, "REBIRTH")
EtaLbl = row(68, "ETA")
AvgLbl = row(86, "AVG")
TotalLbl = row(104, "TOTAL")
SessionLbl = row(122, "SESSION")

local function stockLine()
    local bits = {}
    for i = 1, 3 do
        if merchantOffers[i] then
            table.insert(bits, tostring(merchantOffers[i].stock or 0))
        else
            table.insert(bits, "-")
        end
    end
    return table.concat(bits, " / ")
end

SidePanel = stats
txt(stats, {
    Size = UDim2.new(1, -16, 0, 14),
    Position = UDim2.new(0, 10, 0, 148),
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextColor3 = MUTED
})

SideMerc, SideStock, SideCoins, SideCost, SideEta = nil, nil, nil, nil, nil

local RaidCard, RaidStatusLbl, RaidLvlLbl, RaidPtsLbl, RaidCountLbl, RaidEggLbl, RaidTimeLbl
local hatchUiOn = true
local function layoutSides()
    local rngOn = running or merchantOn or comboOn or autoRollOn
    local raidShow = Raid.on or hatchUiOn
    if stats then
        stats.Visible = rngOn
        stats.Position = UDim2.new(1, 12, 0, 0)
    end
    if RaidCard then
        RaidCard.Visible = raidShow
        if rngOn then
            RaidCard.Position = UDim2.new(1, 12, 0, 178)
        else
            RaidCard.Position = UDim2.new(1, 12, 0, 0)
        end
    end
end
local function setSideVisible(on)
    layoutSides()
end

RaidCard = Instance.new("Frame")
RaidCard.Name = "OsamaRaidCard"
RaidCard.Size = UDim2.new(0, 188, 0, 168)
RaidCard.Position = UDim2.new(1, 12, 0, 0)
RaidCard.BackgroundColor3 = BG
RaidCard.BorderSizePixel = 0
RaidCard.Visible = false
RaidCard.ZIndex = 80
RaidCard.Parent = Panel
corner(RaidCard, 14)
stroke(RaidCard, Color3.fromRGB(48, 52, 64), 0.35)

txt(RaidCard, {
    Size = UDim2.new(1, -16, 0, 16),
    Position = UDim2.new(0, 10, 0, 8),
    Text = "RAID",
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = ACCENT2
})

local function raidRow(y, key)
    txt(RaidCard, {
        Size = UDim2.new(0.48, 0, 0, 16),
        Position = UDim2.new(0, 10, 0, y),
        Text = key,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = MUTED
    })
    return txt(RaidCard, {
        Size = UDim2.new(0.46, 0, 0, 16),
        Position = UDim2.new(0.50, 0, 0, y),
        Text = "-",
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right
    })
end

RaidStatusLbl = txt(RaidCard, {
    Size = UDim2.new(1, -16, 0, 14),
    Position = UDim2.new(0, 10, 0, 26),
    Text = "Raid idle",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = GOLD
})
RaidLvlLbl = raidRow(44, "LEVEL")
RaidPtsLbl = raidRow(64, "POINTS")
RaidCountLbl = raidRow(84, "RAIDS")
RaidEggLbl = raidRow(104, "EGGS")
RaidTimeLbl = raidRow(124, "TIME")



txt(Panel, {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -18),
    Text = "Right Shift - osamahub",
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(80, 86, 98),
    TextXAlignment = Enum.TextXAlignment.Center
})

local Warn = Instance.new("Frame")
Warn.Name = "OsamaWarn"
Warn.Size = UDim2.new(1, 0, 1, 0)
Warn.BackgroundColor3 = Color3.fromRGB(4, 5, 8)
Warn.BackgroundTransparency = 0.35
Warn.BorderSizePixel = 0
Warn.ZIndex = 90
Warn.Parent = host

local Card = Instance.new("Frame")
Card.Size = UDim2.new(0, 340, 0, 210)
Card.AnchorPoint = Vector2.new(0.5, 0.5)
Card.Position = UDim2.new(0.5, 0, 0.5, 0)
Card.BackgroundColor3 = BG
Card.BorderSizePixel = 0
Card.ZIndex = 91
Card.Parent = Warn
corner(Card, 14)
stroke(Card, Color3.fromRGB(48, 52, 64), 0.35)

txt(Card, {
    Size = UDim2.new(1, -24, 0, 22),
    Position = UDim2.new(0, 12, 0, 16),
    Text = "WARNING",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = GOLD,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 92
})

txt(Card, {
    Size = UDim2.new(1, -32, 0, 72),
    Position = UDim2.new(0, 16, 0, 46),
    Text = "For the script to work properly:\nManually teleport to RNG Dice SPAWN,\nthen turn on Full Cycle.",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Top,
    ZIndex = 92
})

local TimerPill = Instance.new("Frame")
TimerPill.Size = UDim2.new(0, 44, 0, 34)
TimerPill.Position = UDim2.new(0, 16, 1, -50)
TimerPill.BackgroundColor3 = Color3.fromRGB(28, 24, 16)
TimerPill.BorderSizePixel = 0
TimerPill.ZIndex = 92
TimerPill.Parent = Card
corner(TimerPill, 8)
stroke(TimerPill, GOLD, 0.45)

local TimerLbl = txt(TimerPill, {
    Size = UDim2.new(1, 0, 1, 0),
    Text = "5",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = GOLD,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 93
})

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(1, -76, 0, 34)
CloseBtn.Position = UDim2.new(0, 66, 1, -50)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
CloseBtn.AutoButtonColor = false
CloseBtn.Text = "Please wait"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.TextColor3 = MUTED
CloseBtn.Active = false
CloseBtn.ZIndex = 92
CloseBtn.Parent = Card
corner(CloseBtn, 8)

local warnLocked = true
task.spawn(function()
    for i = 5, 1, -1 do
        TimerLbl.Text = tostring(i)
        task.wait(1)
    end
    warnLocked = false
    TimerLbl.Text = "OK"
    CloseBtn.Active = true
    CloseBtn.AutoButtonColor = true
    CloseBtn.Text = "Close"
    CloseBtn.TextColor3 = Color3.fromRGB(20, 16, 10)
    CloseBtn.BackgroundColor3 = GOLD
end)

CloseBtn.MouseButton1Click:Connect(function()
    if warnLocked then
        return
    end
    Warn:Destroy()
end)

local tw = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local function toggleGui()
    open = not open
    pcall(function()
        TweenService:Create(Panel, tw, {
            Position = open and UDim2.new(0, 16, 0.22, 0) or UDim2.new(0, -270, 0.22, 0)
        }):Play()
        layoutSides()
        if not open then
            if stats then
                TweenService:Create(stats, tw, {
                    Position = UDim2.new(0, -220, 0.22, 0)
                }):Play()
            end
            if RaidCard then
                TweenService:Create(RaidCard, tw, {
                    Position = UDim2.new(0, -220, 0.22, 0)
                }):Play()
            end
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then
        return
    end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleGui()
    end
end)

local lastUi = 0
RunService.Heartbeat:Connect(function()
    if tick() - lastUi < 0.25 then
        return
    end
    lastUi = tick()
    pcall(updateCoins)
    if Raid.grab then pcall(Raid.grab) end
    pcall(updateRebirthCost)
    pcall(updateRate)
    pcall(refreshEtaAvg)
    pcall(function()
        if Status then
            Status.Text = statusText
        end
        if CoinLbl then
            CoinLbl.Text = tostring(cachedCoinsText)
        end
        if CostLbl then
            CostLbl.Text = tostring(cachedCostText)
        end
        if EtaLbl then
            EtaLbl.Text = etaText
        end
        if AvgLbl then
            AvgLbl.Text = avgText
        end
        if TotalLbl then
            TotalLbl.Text = tostring(totalRebirths)
        end
        if SessionLbl then
            SessionLbl.Text = tostring(sessionRebirths)
        end
        if MercLbl then
            MercLbl.Text = tostring(merchantText)
        end
        if SideMerc then
            SideMerc.Text = tostring(merchantText)
        end
        if SideStock then
            SideStock.Text = stockLine()
        end
        if SideCoins then
            SideCoins.Text = tostring(cachedCoinsText)
        end
        if SideCost then
            SideCost.Text = tostring(cachedCostText)
        end
        if SideEta then
            SideEta.Text = etaText
        end
        if RaidStatusLbl then
            RaidStatusLbl.Text = Raid.status
        end
        if RaidLvlLbl then
            RaidLvlLbl.Text = tostring(Raid.lvl)
        end
        if RaidPtsLbl then
            RaidPtsLbl.Text = Raid.fmtNum(Raid.points)
        end
        if RaidCountLbl then
            RaidCountLbl.Text = tostring(Raid.raids)
        end
        if RaidEggLbl then
            RaidEggLbl.Text = tostring(Raid.eggs)
        end
        if RaidTimeLbl then
            RaidTimeLbl.Text = Raid.fmtTime(Raid.farmSec())
        end
        layoutSides()
    end)
end)

local cycleThread

local function stopCycle()
    running = false
    if cycleThread then
        pcall(function()
            task.cancel(cycleThread)
        end)
        cycleThread = nil
    end
    setToggle(CyclePill, CycleKnob, false, ACCENT)
    pcall(function()
        StatusDot.BackgroundColor3 = Color3.fromRGB(70, 76, 90)
    end)
    setStatus("Stopped")
end

local function startCycle()
    if cycleThread then
        pcall(function()
            task.cancel(cycleThread)
        end)
        cycleThread = nil
    end
    running = true
    cycleStart = tick()
    lastRebirthAt = tick()
    eventEntered = false
    setToggle(CyclePill, CycleKnob, not comboOn, ACCENT)
    pcall(function()
        StatusDot.BackgroundColor3 = ACCENT
    end)
    setStatus("Starting")
    cycleThread = task.spawn(function()
        while running do
            local ok, err = pcall(doFullCycle)
            if not running then
                break
            end
            if not ok then
                setStatus("Retry")
                print("[osamahub] cycle", err)
                task.wait(2)
            else
                task.wait(1)
            end
        end
        setStatus("Stopped")
    end)
end

local function setMerchantMode(on)
    merchantOn = on
    setToggle(MercPill, MercKnob, on and not comboOn, ACCENT4)
    setSideVisible(on)
    if on then
        task.spawn(function()
            pcall(visitMerchant)
            if running then
                pcall(goWinter)
                if autoRollOn then
                    startRollWatch()
                    recoverAutoRoll()
                end
            end
        end)
    else
        restockAt = nil
        merchantText = "Off"
    end
end

local function setCombo(on)
    comboOn = on
    setToggle(ComboPill, ComboKnob, on, GOLD)
    if on then
        setToggle(CyclePill, CycleKnob, false, ACCENT)
        setToggle(MercPill, MercKnob, false, ACCENT4)
        merchantOn = true
        setSideVisible(true)
        startCycle()
        setToggle(CyclePill, CycleKnob, false, ACCENT)
    else
        merchantOn = false
        setSideVisible(false)
        stopCycle()
    end
end

CycleBtn.MouseButton1Click:Connect(function()
    if comboOn then
        setCombo(false)
    end
    if running then
        stopCycle()
    else
        startCycle()
        setToggle(CyclePill, CycleKnob, true, ACCENT)
    end
    layoutSides()
end)

MercBtn.MouseButton1Click:Connect(function()
    if comboOn then
        comboOn = false
        setToggle(ComboPill, ComboKnob, false, GOLD)
        stopCycle()
    end
    setMerchantMode(not merchantOn)
    layoutSides()
end)

ComboBtn.MouseButton1Click:Connect(function()
    setCombo(not comboOn)
    layoutSides()
end)

RollBtn.MouseButton1Click:Connect(function()
    autoRollOn = not autoRollOn
    setToggle(RollPill, RollKnob, autoRollOn, ACCENT3)
    if autoRollOn then
        startRollWatch()
        recoverAutoRoll()
    else
        stopAutoRoll()
    end
    layoutSides()
end)

AfkBtn.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled
    setToggle(AfkPill, AfkKnob, afkEnabled, ACCENT2)
    if afkEnabled then
        startAntiAFK()
    else
        stopAntiAFK()
    end
end)

AfkBtn.MouseButton1Click:Connect(function()
    afkEnabled = not afkEnabled
    setToggle(AfkPill, AfkKnob, afkEnabled, ACCENT2)
    if afkEnabled then
        startAntiAFK()
    else
        stopAntiAFK()
    end
end)

RaidBtn.MouseButton1Click:Connect(function()
    if Raid.on then
        Raid.stop()
        setToggle(RaidPill, RaidKnob, false, ACCENT2)
    else
        Raid.start()
        setToggle(RaidPill, RaidKnob, true, ACCENT2)
    end
    layoutSides()
end)

HatchBtn.MouseButton1Click:Connect(function()
    Raid.hatch = not Raid.hatch
    hatchUiOn = Raid.hatch
    setToggle(HatchPill, HatchKnob, Raid.hatch, ACCENT3)
    layoutSides()
end)

afkEnabled = true
setToggle(AfkPill, AfkKnob, true, ACCENT2)
startAntiAFK()
setToggle(HatchPill, HatchKnob, true, ACCENT3)
print("[osamahub] ready")
end
bootUi()
