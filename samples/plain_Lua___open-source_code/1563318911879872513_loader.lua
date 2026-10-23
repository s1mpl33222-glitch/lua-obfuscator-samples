-- dior loader

local BASE = "http://78.154.103.27:12177"
local KEY_FILE = "dior_key.txt"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local THEME = {
    bg          = Color3.fromRGB(10, 10, 14),
    surface     = Color3.fromRGB(22, 22, 28),
    border      = Color3.fromRGB(42, 42, 52),
    text        = Color3.fromRGB(240, 240, 245),
    text_dim    = Color3.fromRGB(150, 150, 162),
    text_faint  = Color3.fromRGB(96, 96, 108),
    accent      = Color3.fromRGB(240, 199, 94),
    green       = Color3.fromRGB(74, 222, 128),
    red         = Color3.fromRGB(248, 113, 113),
}

local SPRING    = TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SPRING_IN = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
local SOFT      = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function get_hwid()
    local fns = {
        function() return game:GetService("RbxAnalyticsService"):GetClientId() end,
        function() return gethwid and gethwid() end,
        function() return syn and syn.get_hwid and syn.get_hwid() end,
        function() return hwid and hwid() end,
    }
    for _, fn in ipairs(fns) do
        local ok, v = pcall(fn)
        if ok and type(v) == "string" and #v > 8 then return v end
    end
    return "fb_" .. tostring(LocalPlayer.UserId) .. "_" .. tostring(game.PlaceId)
end

local function read_key()
    if isfile and isfile(KEY_FILE) and readfile then
        local ok, v = pcall(readfile, KEY_FILE)
        if ok and v and #v > 0 then return v:gsub("%s+", "") end
    end
    return nil
end

local function save_key(k)
    if writefile then pcall(writefile, KEY_FILE, k) end
end

local function fetch(url)
    local ok, res = pcall(function() return game:HttpGet(url, true) end)
    if ok and res and #res > 0 then return res end
    local req = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or (krnl and krnl.request) or request
    if req then
        local o, r = pcall(req, { Url = url, Method = "GET" })
        if o and r and r.Body then return r.Body end
    end
    return nil
end

local function build_ui()
    local pg = LocalPlayer:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "dior_loader"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 500
    gui.Parent = pg

    local backdrop = Instance.new("Frame")
    backdrop.Size = UDim2.new(1, 0, 1, 0)
    backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    backdrop.BackgroundTransparency = 1
    backdrop.BorderSizePixel = 0
    backdrop.Parent = gui
    TweenService:Create(backdrop, SPRING, { BackgroundTransparency = 0.42 }):Play()

    local shadow = Instance.new("Frame")
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.new(0.5, 0, 0.45, 0)
    shadow.Size = UDim2.new(0, 356, 0, 216)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 1
    shadow.BorderSizePixel = 0
    shadow.Parent = gui
    local sC = Instance.new("UICorner") sC.CornerRadius = UDim.new(0, 22) sC.Parent = shadow
    TweenService:Create(shadow, SPRING, { BackgroundTransparency = 0.72 }):Play()

    local card = Instance.new("Frame")
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.new(0.5, 0, 0.45, 24)
    card.Size = UDim2.new(0, 320, 0, 188)
    card.BackgroundColor3 = THEME.bg
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.Parent = gui
    local cC = Instance.new("UICorner") cC.CornerRadius = UDim.new(0, 18) cC.Parent = card
    local cStroke = Instance.new("UIStroke")
    cStroke.Color = THEME.border
    cStroke.Thickness = 1
    cStroke.Transparency = 1
    cStroke.Parent = card
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14)),
    })
    grad.Rotation = 135
    grad.Parent = card

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 22) pad.PaddingBottom = UDim.new(0, 22)
    pad.PaddingLeft = UDim.new(0, 24) pad.PaddingRight = UDim.new(0, 24)
    pad.Parent = card

    TweenService:Create(card, SPRING, {
        Position = UDim2.new(0.5, 0, 0.45, 0),
        Size = UDim2.new(0, 340, 0, 200),
        BackgroundTransparency = 0.06,
    }):Play()
    TweenService:Create(cStroke, SPRING, { Transparency = 0.4 }):Play()

    local content = Instance.new("Frame")
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, 0, 1, 0)
    content.Parent = card

    return { gui = gui, backdrop = backdrop, shadow = shadow, card = card, content = content, stroke = cStroke }
end

local function swap_content(ui, builder)
    local old = {}
    for _, c in ipairs(ui.content:GetChildren()) do
        if c:IsA("GuiObject") then
            table.insert(old, c)
            TweenService:Create(c, SOFT, { BackgroundTransparency = 1 }):Play()
            if c:IsA("TextLabel") or c:IsA("TextButton") or c:IsA("TextBox") then
                TweenService:Create(c, SOFT, { TextTransparency = 1 }):Play()
            end
        end
    end
    task.delay(0.14, function()
        for _, c in ipairs(old) do c:Destroy() end
        if ui.gui.Parent then
            local new = builder()
            for _, el in ipairs(new) do el.Parent = ui.content end
        end
    end)
end

local function show_input(ui, on_submit, opts)
    opts = opts or {}
    swap_content(ui, function()
        local out = {}

        local title = Instance.new("TextLabel")
        title.Text = "dior"
        title.Font = Enum.Font.GothamBold
        title.TextSize = 22
        title.TextColor3 = THEME.accent
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, 0, 0, 26)
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextTransparency = 1
        table.insert(out, title)
        task.delay(0.05, function() TweenService:Create(title, SOFT, { TextTransparency = 0 }):Play() end)

        local sub = Instance.new("TextLabel")
        sub.Text = "enter your key to continue"
        sub.Font = Enum.Font.GothamMedium
        sub.TextSize = 12
        sub.TextColor3 = THEME.text_dim
        sub.BackgroundTransparency = 1
        sub.Size = UDim2.new(1, 0, 0, 18)
        sub.Position = UDim2.new(0, 0, 0, 28)
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.TextTransparency = 1
        table.insert(out, sub)
        task.delay(0.09, function() TweenService:Create(sub, SOFT, { TextTransparency = 0 }):Play() end)

        local holder = Instance.new("Frame")
        holder.BackgroundColor3 = THEME.surface
        holder.BorderSizePixel = 0
        holder.Size = UDim2.new(1, 0, 0, 42)
        holder.Position = UDim2.new(0, 0, 0, 60)
        holder.BackgroundTransparency = 1
        table.insert(out, holder)
        local hC = Instance.new("UICorner") hC.CornerRadius = UDim.new(0, 11) hC.Parent = holder
        local hS = Instance.new("UIStroke")
        hS.Color = THEME.border
        hS.Thickness = 1
        hS.Transparency = 1
        hS.Parent = holder
        task.delay(0.13, function()
            TweenService:Create(holder, SOFT, { BackgroundTransparency = 0 }):Play()
            TweenService:Create(hS, SOFT, { Transparency = 0.3 }):Play()
        end)

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -20, 1, 0)
        box.Position = UDim2.new(0, 10, 0, 0)
        box.BackgroundTransparency = 1
        box.Text = opts.prefill or ""
        box.PlaceholderText = "DIOR-XXXX-XXXX-XXXX"
        box.PlaceholderColor3 = THEME.text_faint
        box.TextColor3 = THEME.text
        box.Font = Enum.Font.GothamMedium
        box.TextSize = 13
        box.ClearTextOnFocus = false
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.TextTransparency = 1
        box.Parent = holder
        task.delay(0.15, function()
            TweenService:Create(box, SOFT, { TextTransparency = 0 }):Play()
            box:CaptureFocus()
        end)

        local err = Instance.new("TextLabel")
        err.Text = opts.error and ("· " .. opts.error) or ""
        err.Font = Enum.Font.GothamMedium
        err.TextSize = 11
        err.TextColor3 = THEME.red
        err.BackgroundTransparency = 1
        err.Size = UDim2.new(1, 0, 0, 16)
        err.Position = UDim2.new(0, 0, 0, 108)
        err.TextXAlignment = Enum.TextXAlignment.Left
        err.TextTransparency = 1
        table.insert(out, err)
        if opts.error then
            task.delay(0.18, function() TweenService:Create(err, SOFT, { TextTransparency = 0 }):Play() end)
        end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.Position = UDim2.new(0, 0, 1, -38)
        btn.BackgroundColor3 = THEME.accent
        btn.BorderSizePixel = 0
        btn.Text = "continue"
        btn.TextColor3 = THEME.bg
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.TextTransparency = 1
        btn.BackgroundTransparency = 1
        table.insert(out, btn)
        local bC = Instance.new("UICorner") bC.CornerRadius = UDim.new(0, 11) bC.Parent = btn
        task.delay(0.17, function()
            TweenService:Create(btn, SOFT, { BackgroundTransparency = 0, TextTransparency = 0 }):Play()
        end)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, SOFT, { BackgroundColor3 = Color3.fromRGB(244, 212, 122) }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, SOFT, { BackgroundColor3 = THEME.accent }):Play()
        end)

        local submitted = false
        local function submit()
            if submitted then return end
            local k = box.Text:gsub("%s+", "")
            if #k < 6 then
                err.Text = "· key looks too short"
                TweenService:Create(err, SOFT, { TextTransparency = 0 }):Play()
                return
            end
            submitted = true
            TweenService:Create(btn, SOFT, { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
            on_submit(k)
        end

        btn.MouseButton1Click:Connect(submit)
        box.FocusLost:Connect(function(enter) if enter then submit() end end)
        box:GetPropertyChangedSignal("Text"):Connect(function()
            if err.Text ~= "" then
                TweenService:Create(err, SOFT, { TextTransparency = 1 }):Play()
            end
        end)

        return out
    end)
end

local function show_loading(ui, message)
    swap_content(ui, function()
        local out = {}

        local spinner = Instance.new("Frame")
        spinner.AnchorPoint = Vector2.new(0.5, 0.5)
        spinner.Position = UDim2.new(0.5, 0, 0.4, 0)
        spinner.Size = UDim2.new(0, 48, 0, 48)
        spinner.BackgroundTransparency = 1
        table.insert(out, spinner)

        for i = 1, 3 do
            local dot = Instance.new("Frame")
            dot.AnchorPoint = Vector2.new(0.5, 0.5)
            dot.Size = UDim2.new(0, 8, 0, 8)
            dot.BackgroundColor3 = THEME.accent
            dot.BorderSizePixel = 0
            dot.BackgroundTransparency = 1
            dot.Parent = spinner
            local c = Instance.new("UICorner") c.CornerRadius = UDim.new(1, 0) c.Parent = dot
            local angle = math.rad((i - 1) * 120)
            dot.Position = UDim2.new(0.5, math.cos(angle) * 16, 0.5, math.sin(angle) * 16)
            task.delay(0.1 + i * 0.06, function()
                TweenService:Create(dot, SOFT, { BackgroundTransparency = 0 }):Play()
            end)
        end

        task.spawn(function()
            while spinner.Parent do
                spinner.Rotation = (spinner.Rotation + 4) % 360
                task.wait(0.016)
            end
        end)

        local txt = Instance.new("TextLabel")
        txt.Text = message or "verifying key"
        txt.Font = Enum.Font.GothamMedium
        txt.TextSize = 13
        txt.TextColor3 = THEME.text_dim
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0, 0, 0.75, 0)
        txt.TextTransparency = 1
        table.insert(out, txt)
        task.delay(0.2, function() TweenService:Create(txt, SOFT, { TextTransparency = 0 }):Play() end)

        return out
    end)
end

local function show_success(ui)
    swap_content(ui, function()
        local out = {}
        local holder = Instance.new("Frame")
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.Position = UDim2.new(0.5, 0, 0.4, 0)
        holder.Size = UDim2.new(0, 56, 0, 56)
        holder.BackgroundColor3 = THEME.green
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        table.insert(out, holder)
        local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(1, 0) hc.Parent = holder
        task.delay(0.05, function() TweenService:Create(holder, SPRING, { BackgroundTransparency = 0.85 }):Play() end)

        local check = Instance.new("TextLabel")
        check.Text = "✓"
        check.Font = Enum.Font.GothamBold
        check.TextSize = 30
        check.TextColor3 = THEME.green
        check.BackgroundTransparency = 1
        check.Size = UDim2.new(1, 0, 1, 0)
        check.TextTransparency = 1
        check.Parent = holder
        task.delay(0.15, function() TweenService:Create(check, SPRING, { TextTransparency = 0 }):Play() end)

        local txt = Instance.new("TextLabel")
        txt.Text = "authenticated"
        txt.Font = Enum.Font.GothamSemibold
        txt.TextSize = 14
        txt.TextColor3 = THEME.text
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0, 0, 0.75, 0)
        txt.TextTransparency = 1
        table.insert(out, txt)
        task.delay(0.25, function() TweenService:Create(txt, SOFT, { TextTransparency = 0 }):Play() end)

        return out
    end)
end

local function show_error(ui, reason, on_retry)
    swap_content(ui, function()
        local out = {}
        local holder = Instance.new("Frame")
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.Position = UDim2.new(0.5, 0, 0.4, 0)
        holder.Size = UDim2.new(0, 56, 0, 56)
        holder.BackgroundColor3 = THEME.red
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        table.insert(out, holder)
        local hc = Instance.new("UICorner") hc.CornerRadius = UDim.new(1, 0) hc.Parent = holder
        task.delay(0.05, function() TweenService:Create(holder, SPRING, { BackgroundTransparency = 0.85 }):Play() end)

        local bang = Instance.new("TextLabel")
        bang.Text = "!"
        bang.Font = Enum.Font.GothamBold
        bang.TextSize = 32
        bang.TextColor3 = THEME.red
        bang.BackgroundTransparency = 1
        bang.Size = UDim2.new(1, 0, 1, 0)
        bang.TextTransparency = 1
        bang.Parent = holder
        task.delay(0.15, function() TweenService:Create(bang, SPRING, { TextTransparency = 0 }):Play() end)

        local txt = Instance.new("TextLabel")
        txt.Text = reason or "auth failed"
        txt.Font = Enum.Font.GothamSemibold
        txt.TextSize = 14
        txt.TextColor3 = THEME.text
        txt.BackgroundTransparency = 1
        txt.Size = UDim2.new(1, 0, 0, 20)
        txt.Position = UDim2.new(0, 0, 0.72, 0)
        txt.TextTransparency = 1
        table.insert(out, txt)
        task.delay(0.25, function() TweenService:Create(txt, SOFT, { TextTransparency = 0 }):Play() end)

        local sub = Instance.new("TextLabel")
        sub.Text = "tap to retry"
        sub.Font = Enum.Font.GothamMedium
        sub.TextSize = 12
        sub.TextColor3 = THEME.text_faint
        sub.BackgroundTransparency = 1
        sub.Size = UDim2.new(1, 0, 0, 16)
        sub.Position = UDim2.new(0, 0, 0.9, -8)
        sub.TextTransparency = 1
        table.insert(out, sub)
        task.delay(0.32, function() TweenService:Create(sub, SOFT, { TextTransparency = 0 }):Play() end)

        local hit = Instance.new("TextButton")
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.Parent = holder
        hit.MouseButton1Click:Connect(on_retry)

        return out
    end)
end

local function destroy_ui(ui)
    TweenService:Create(ui.card, SPRING_IN, {
        Position = UDim2.new(0.5, 0, 0.45, 20),
        Size = UDim2.new(0, 320, 0, 188),
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(ui.shadow, SPRING_IN, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(ui.backdrop, SPRING_IN, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(ui.stroke, SPRING_IN, { Transparency = 1 }):Play()
    task.delay(0.4, function() if ui.gui then ui.gui:Destroy() end end)
end

local REASON_PRETTY = {
    hwid_mismatch = "key bound to another device",
    expired       = "key has expired",
    revoked       = "key has been revoked",
    unknown_key   = "key doesn't exist",
    no_key        = "no key provided",
    no_hwid       = "hwid missing",
}

local function classify_response(body)
    if not body or #body < 20 then
        return { ok = false, reason = "empty response from server" }
    end
    if body:sub(1, 1) == "{" then
        local reason = body:match('"reason"%s*:%s*"([^"]+)"') or "unknown"
        return { ok = false, reason = REASON_PRETTY[reason] or reason }
    end
    if body:sub(1, 12) == "Unauthorized" then
        return { ok = false, reason = "unauthorized" }
    end
    return { ok = true, body = body }
end

local function attempt_auth(key, hwid)
    local body = fetch(BASE .. "/auth?key=" .. key .. "&hwid=" .. hwid)
    return classify_response(body)
end

local function load_and_run(body)
    local fn, err = loadstring(body)
    if not fn then
        warn("[dior] main script syntax error: " .. tostring(err))
        return false
    end
    local ok, run_err = pcall(fn)
    if not ok then
        warn("[dior] main script runtime error: " .. tostring(run_err))
        return false
    end
    return true
end

local function run()
    local hwid = get_hwid()
    local saved = read_key()

    if saved then
        local r = attempt_auth(saved, hwid)
        if r.ok then
            save_key(saved)
            if load_and_run(r.body) then return end
        end
    end

    local ui = build_ui()
    local last_error = nil
    local prefill = saved or ""

    local function prompt_once()
        local done = false
        local final_key
        show_input(ui, function(k) final_key = k; done = true end, {
            prefill = prefill,
            error = last_error,
        })
        while not done do task.wait(0.05) end
        return final_key
    end

    while true do
        local k = prompt_once()
        if not k then destroy_ui(ui) return end
        prefill = k

        show_loading(ui, "verifying key")
        local res = attempt_auth(k, hwid)

        if res.ok then
            save_key(k)
            show_success(ui)
            task.wait(0.85)
            destroy_ui(ui)
            task.wait(0.35)
            load_and_run(res.body)
            return
        else
            last_error = res.reason
            show_error(ui, res.reason, function() end)
            task.wait(1.4)
        end
    end
end

local ok, err = pcall(run)
if not ok then warn("[dior] loader crashed: " .. tostring(err)) end
