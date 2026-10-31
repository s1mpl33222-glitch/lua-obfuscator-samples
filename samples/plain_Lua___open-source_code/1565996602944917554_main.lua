-- [KRIPH] actividad + avisos en el juego
do
local G = (getgenv and getgenv()) or _G
local BASE, TK, SN, OW = "https://kriph-loader.pages.dev", "WyJuZXh2eXIiLCJzY3JpcHQiLDE3OTM2MDU4ODVd.f3a333bfcf5fd9de8c58f1b80fc36654", "script", "nexvyr"
local RK = "__KRIPH_RT_" .. OW
local RT = G[RK]
if RT and RT.v == 3 then
    RT.script, RT.tk, RT.pending = SN, TK, true
else
    RT = { v = 3, script = SN, tk = TK, pending = true, t0 = os.clock() }
    G[RK] = RT
    local function main()
        local req = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
        if type(req) ~= "function" then return end
        local Players = game:GetService("Players")
        local HttpService = game:GetService("HttpService")
        local TweenService = game:GetService("TweenService")
        if not game:IsLoaded() then game.Loaded:Wait() end
        local lp = Players.LocalPlayer
        while not lp do task.wait(0.2); lp = Players.LocalPlayer end
        local gname = ""
        pcall(function() gname = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
        if gname == "" then gname = tostring(game.Name) end
        local exec = "unknown"
        pcall(function() if identifyexecutor then exec = tostring((identifyexecutor())) end end)

        local function call(method, path, data)
            local ok, res = pcall(req, {
                Url = BASE .. path, Method = method,
                Headers = { ["Content-Type"] = "application/json" },
                Body = data and HttpService:JSONEncode(data) or nil,
            })
            if not ok or type(res) ~= "table" then return nil end
            local code = tonumber(res.StatusCode or res.Status)
            if code and code ~= 200 then return nil end
            local ok2, out = pcall(function() return HttpService:JSONDecode(res.Body) end)
            return ok2 and out or nil
        end
        local function send(ev)
            return call("POST", "/api/hb", {
                tk = RT.tk, ev = ev, u = lp.Name, dn = lp.DisplayName, id = lp.UserId,
                pl = game.PlaceId, uni = game.GameId, g = gname, s = RT.script, x = exec,
                up = math.floor(os.clock() - RT.t0),
            })
        end

        local function show(msg)
            local okUI = pcall(function()
                local parent = (gethui and gethui()) or game:GetService("CoreGui")
                local gui = G.__KRIPH_GUI
                if not gui or not gui.Parent then
                    gui = Instance.new("ScreenGui")
                    gui.Name = "KRIPH_AVISOS"
                    gui.ResetOnSpawn = false
                    gui.IgnoreGuiInset = true
                    gui.DisplayOrder = 2147483647
                    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
                    gui.Parent = parent
                    local holder = Instance.new("Frame")
                    holder.Name = "L"
                    holder.BackgroundTransparency = 1
                    holder.AnchorPoint = Vector2.new(1, 0)
                    holder.Position = UDim2.new(1, -16, 0, 16)
                    holder.Size = UDim2.new(0, 320, 1, -32)
                    holder.Parent = gui
                    local ll = Instance.new("UIListLayout")
                    ll.Padding = UDim.new(0, 8)
                    ll.SortOrder = Enum.SortOrder.LayoutOrder
                    ll.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    ll.Parent = holder
                    G.__KRIPH_GUI = gui
                end
                local card = Instance.new("CanvasGroup")
                card.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
                card.BorderSizePixel = 0
                card.Size = UDim2.new(1, 0, 0, 0)
                card.AutomaticSize = Enum.AutomaticSize.Y
                card.GroupTransparency = 1
                local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 12); corner.Parent = card
                local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(42, 42, 48); stroke.Thickness = 1; stroke.Parent = card
                local pad = Instance.new("UIPadding")
                pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 12), UDim.new(0, 12)
                pad.PaddingLeft, pad.PaddingRight = UDim.new(0, 14), UDim.new(0, 14)
                pad.Parent = card
                local lay = Instance.new("UIListLayout"); lay.Padding = UDim.new(0, 4); lay.Parent = card
                local title = Instance.new("TextLabel")
                title.BackgroundTransparency = 1
                title.Size = UDim2.new(1, 0, 0, 16)
                title.Font = Enum.Font.GothamBold
                title.Text = "KRIPH OBFUSCADOR"
                title.TextColor3 = Color3.fromRGB(244, 245, 247)
                title.TextSize = 13
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.LayoutOrder = 1
                title.Parent = card
                local body = Instance.new("TextLabel")
                body.BackgroundTransparency = 1
                body.Size = UDim2.new(1, 0, 0, 0)
                body.AutomaticSize = Enum.AutomaticSize.Y
                body.Font = Enum.Font.Gotham
                body.RichText = false
                body.Text = msg
                body.TextColor3 = Color3.fromRGB(190, 194, 204)
                body.TextSize = 13
                body.TextWrapped = true
                body.TextXAlignment = Enum.TextXAlignment.Left
                body.TextYAlignment = Enum.TextYAlignment.Top
                body.LayoutOrder = 2
                body.Parent = card
                card.Parent = gui:FindFirstChild("L")
                TweenService:Create(card, TweenInfo.new(0.25), { GroupTransparency = 0 }):Play()
                task.delay(math.clamp(4 + #msg / 25, 5, 12), function()
                    pcall(function()
                        TweenService:Create(card, TweenInfo.new(0.3), { GroupTransparency = 1 }):Play()
                        task.wait(0.35)
                        card:Destroy()
                    end)
                end)
            end)
            if not okUI then
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "KRIPH", Text = msg, Duration = 8 })
                end)
            end
        end

        pcall(function()
            Players.PlayerRemoving:Connect(function(p)
                if p == lp then send("bye") end
            end)
        end)

        local since, lastHb, lastPoll = nil, -1e9, -1e9
        while G[RK] == RT do
            local now = os.clock()
            if RT.pending then
                RT.pending = false
                send("run")
                lastHb = now
            elseif now - lastHb >= 45 then
                send("hb")
                lastHb = now
            end
            if now - lastPoll >= 6 then
                lastPoll = now
                local r = call("GET", "/api/poll?tk=" .. RT.tk .. (since and ("&since=" .. since) or ""))
                if type(r) == "table" then
                    if tonumber(r.seq) then since = tonumber(r.seq) end
                    if type(r.items) == "table" then
                        for _, it in ipairs(r.items) do
                            if type(it) == "table" and type(it.m) == "string" then show(it.m) end
                        end
                    end
                end
            end
            task.wait(1)
        end
    end
    local sp = (task and task.spawn) or function(f) coroutine.wrap(f)() end
    sp(function() pcall(main) end)
end
end

local gui = Instance.new("ScreenGui")
gui.Name = "BotonPrueba"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 120, 0, 44)
btn.Position = UDim2.new(0, 20, 0.5, 0)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Text = "Botón"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.Parent = gui

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)