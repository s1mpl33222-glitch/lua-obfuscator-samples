local DiamondUI = (function()
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local pg = lp:WaitForChild("PlayerGui")
    local genv = (getgenv and getgenv()) or _G
    for _, g in ipairs(pg:GetChildren()) do
        if g.Name:sub(1, 10) == "DiamondUI_" or g.Name == "cm_menu" then g:Destroy() end
    end
    if genv.dui_conns then
        for _, c in ipairs(genv.dui_conns) do
            pcall(function() c:Disconnect() end)
        end
    end
    genv.dui_conns = {}
    local function keep(c)
        table.insert(genv.dui_conns, c)
        return c
    end
    local Lib = {Version = "1.0.0", Windows = {}, _order = 1000, _toasts = {}, _toastList = {}}
    local Window = {}
    Window.__index = Window
    local Tab = {}
    Tab.__index = Tab
    local Container = {}
    Container.__index = Container
    local THEMES = {
        Dark = {
            Background = Color3.fromRGB(15, 15, 19), Topbar = Color3.fromRGB(21, 21, 27),
            Sidebar = Color3.fromRGB(19, 19, 24), Surface = Color3.fromRGB(25, 25, 32),
            Element = Color3.fromRGB(34, 34, 43), ElementHover = Color3.fromRGB(44, 44, 56),
            Stroke = Color3.fromRGB(180, 145, 20), Text = Color3.fromRGB(238, 238, 245),
            SubText = Color3.fromRGB(148, 150, 168), Accent = Color3.fromRGB(255, 200, 30),
            Success = Color3.fromRGB(64, 208, 128), Warning = Color3.fromRGB(255, 188, 66),
            Danger = Color3.fromRGB(240, 82, 94),
        },
        Light = {
            Background = Color3.fromRGB(240, 241, 246), Topbar = Color3.fromRGB(250, 250, 253),
            Sidebar = Color3.fromRGB(245, 246, 250), Surface = Color3.fromRGB(255, 255, 255),
            Element = Color3.fromRGB(236, 238, 245), ElementHover = Color3.fromRGB(224, 227, 237),
            Stroke = Color3.fromRGB(215, 185, 80), Text = Color3.fromRGB(30, 32, 44),
            SubText = Color3.fromRGB(104, 108, 128), Accent = Color3.fromRGB(210, 165, 0),
            Success = Color3.fromRGB(34, 170, 98), Warning = Color3.fromRGB(230, 150, 20),
            Danger = Color3.fromRGB(220, 60, 72),
        },
        Midnight = {
            Background = Color3.fromRGB(12, 10, 22), Topbar = Color3.fromRGB(18, 15, 32),
            Sidebar = Color3.fromRGB(16, 13, 28), Surface = Color3.fromRGB(22, 18, 40),
            Element = Color3.fromRGB(32, 27, 56), ElementHover = Color3.fromRGB(42, 36, 72),
            Stroke = Color3.fromRGB(150, 120, 25), Text = Color3.fromRGB(240, 236, 255),
            SubText = Color3.fromRGB(150, 142, 190), Accent = Color3.fromRGB(255, 210, 40),
            Success = Color3.fromRGB(80, 220, 150), Warning = Color3.fromRGB(255, 196, 80),
            Danger = Color3.fromRGB(255, 90, 110),
        },
        Ocean = {
            Background = Color3.fromRGB(10, 18, 24), Topbar = Color3.fromRGB(14, 26, 34),
            Sidebar = Color3.fromRGB(12, 22, 30), Surface = Color3.fromRGB(17, 31, 41),
            Element = Color3.fromRGB(24, 44, 58), ElementHover = Color3.fromRGB(32, 58, 76),
            Stroke = Color3.fromRGB(160, 130, 25), Text = Color3.fromRGB(232, 246, 250),
            SubText = Color3.fromRGB(130, 170, 186), Accent = Color3.fromRGB(255, 200, 30),
            Success = Color3.fromRGB(70, 220, 140), Warning = Color3.fromRGB(255, 190, 80),
            Danger = Color3.fromRGB(245, 90, 100),
        },
    }
    Lib.Themes = THEMES
    local function copy(t)
        local r = {}
        for k, v in pairs(t) do r[k] = v end
        return r
    end
    local function new(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        if parent then o.Parent = parent end
        return o
    end
    local function round(o, r)
        return new("UICorner", {CornerRadius = UDim.new(0, r or 8)}, o)
    end
    local function padding(o, l, t, r, b)
        return new("UIPadding", {
            PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t),
            PaddingRight = UDim.new(0, r or l), PaddingBottom = UDim.new(0, b or t),
        }, o)
    end
    local TI = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local TI_FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tween(o, props, info)
        local t = TweenService:Create(o, info or TI, props)
        t:Play()
        return t
    end
    local function safe(cb, ...)
        if type(cb) ~= "function" then return end
        local ok, err = pcall(cb, ...)
        if not ok then warn("[BeeZ Hub] callback error: " .. tostring(err)) end
    end
    local function sanitize(s)
        s = tostring(s or ""):gsub("[^%w _%-#]", ""):gsub("^%s+", ""):gsub("%s+$", "")
        return s:sub(1, 24)
    end
    Lib.Sanitize = sanitize
    local function P(keys, ...)
        local first = ...
        if type(first) == "table" then return first end
        local args = {...}
        local o = {}
        for i, k in ipairs(keys) do o[k] = args[i] end
        return o
    end
    function Lib.Rich(text, color)
        return string.format('<font color="rgb(%d,%d,%d)">%s</font>',
            math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5), tostring(text))
    end
    local function trackDrag(input, onMove, onEnd)
        local conns, done = {}, false
        local function finish()
            if done then return end
            done = true
            for _, c in ipairs(conns) do c:Disconnect() end
            if onEnd then onEnd() end
        end
        table.insert(conns, UIS.InputChanged:Connect(function(i)
            if i == input or (input.UserInputType == Enum.UserInputType.MouseButton1
                and i.UserInputType == Enum.UserInputType.MouseMovement) then
                onMove(i.Position)
            end
        end))
        table.insert(conns, UIS.InputEnded:Connect(function(i)
            if i == input then finish() end
        end))
        table.insert(conns, input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then finish() end
        end))
    end
    local function isPointer(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end
    function Lib.MakeStore(folder, memKey)
        local hasFS = type(writefile) == "function" and type(readfile) == "function"
            and type(listfiles) == "function" and type(delfile) == "function"
            and type(isfolder) == "function" and type(makefolder) == "function"
        local mem = genv[memKey] or {items = {}, auto = nil}
        genv[memKey] = mem
        if hasFS then
            pcall(function()
                local root = folder:match("^([^/]+)")
                if root and not isfolder(root) then makefolder(root) end
                if not isfolder(folder) then makefolder(folder) end
            end)
        end
        local S = {hasFS = hasFS}
        local function path(n) return folder .. "/" .. n .. ".json" end
        function S.list()
            local names = {}
            if hasFS then
                local ok, files = pcall(listfiles, folder)
                if ok and type(files) == "table" then
                    for _, f in ipairs(files) do
                        local n = tostring(f):match("([^/\\]+)%.json$")
                        if n then table.insert(names, n) end
                    end
                end
            else
                for n in pairs(mem.items) do table.insert(names, n) end
            end
            table.sort(names)
            return names
        end
        function S.exists(n)
            for _, x in ipairs(S.list()) do
                if x == n then return true end
            end
            return false
        end
        function S.read(n)
            if not hasFS then return mem.items[n] end
            local ok, raw = pcall(readfile, path(n))
            if not ok or type(raw) ~= "string" then return nil end
            local ok2, d = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok2 and type(d) == "table" then return d end
            return nil
        end
        function S.write(n, t)
            if not hasFS then
                mem.items[n] = t
                return true
            end
            return (pcall(function() writefile(path(n), HttpService:JSONEncode(t)) end))
        end
        function S.delete(n)
            if not hasFS then
                mem.items[n] = nil
                return true
            end
            return (pcall(delfile, path(n)))
        end
        function S.getAuto()
            if not hasFS then return mem.auto end
            local ok, raw = pcall(readfile, folder .. "/_autoload.txt")
            if ok and type(raw) == "string" then
                local n = raw:match("^%s*(.-)%s*$")
                if n and n ~= "" then return n end
            end
            return nil
        end
        function S.setAuto(n)
            if not hasFS then
                mem.auto = n
                return
            end
            pcall(writefile, folder .. "/_autoload.txt", n or "")
        end
        return S
    end
    local function encodeVal(v)
        if typeof(v) == "Color3" then return {__c3 = {v.R, v.G, v.B}} end
        return v
    end
    local function decodeVal(v)
        if type(v) == "table" and type(v.__c3) == "table" then
            return Color3.new(v.__c3[1] or 0, v.__c3[2] or 0, v.__c3[3] or 0)
        end
        return v
    end
    local function stateIO(folder)
        local hasFS = type(writefile) == "function" and type(readfile) == "function"
            and type(isfolder) == "function" and type(makefolder) == "function"
        local memKey = "dui_state_" .. folder
        local path = folder .. "/settings.json"
        if hasFS then
            pcall(function()
                local root = folder:match("^([^/]+)")
                if root and not isfolder(root) then makefolder(root) end
                if not isfolder(folder) then makefolder(folder) end
            end)
        end
        local io = {hasFS = hasFS}
        function io.read()
            if not hasFS then return genv[memKey] end
            local ok, raw = pcall(readfile, path)
            if not ok or type(raw) ~= "string" then return nil end
            local ok2, d = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok2 and type(d) == "table" then return d end
            return nil
        end
        function io.write(t)
            if not hasFS then
                genv[memKey] = t
                return true
            end
            return (pcall(function() writefile(path, HttpService:JSONEncode(t)) end))
        end
        return io
    end
    local function ensureNotify()
        if Lib._nList and Lib._nList.Parent then return end
        local g = new("ScreenGui", {
            Name = "DiamondUI_Notify", ResetOnSpawn = false, IgnoreGuiInset = false,
            DisplayOrder = 100000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        g.Parent = pg
        local list = new("Frame", {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 104),
            Size = UDim2.new(0, 250, 1, -112), BackgroundTransparency = 1,
        }, g)
        new("UIListLayout", {
            Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Top,
        }, list)
        Lib._nGui, Lib._nList = g, list
    end
    function Lib:Notify(a, b, c)
        local o = type(a) == "table" and a or {Title = a, Content = b, Duration = c}
        if Lib.Tr then
            local copy = {}
            for k, v in pairs(o) do copy[k] = v end
            if type(copy.Title) == "string" then copy.Title = Lib.Tr(copy.Title) end
            if type(copy.Content) == "string" then copy.Content = Lib.Tr(copy.Content) end
            o = copy
        end
        local ok, err = pcall(function()
            ensureNotify()
            local win1 = Lib.Windows[1]
            local th = (win1 and win1.Theme) or THEMES.Dark
            local dur = o.Duration or 3
            local key = tostring(o.Title) .. "|" .. tostring(o.Content)
            local ex = Lib._toasts[key]
            if ex and ex.alive then
                ex.expire = os.clock() + dur
                return
            end
            local alive = {}
            for _, t in ipairs(Lib._toastList) do
                if t.alive then table.insert(alive, t) end
            end
            Lib._toastList = alive
            while #Lib._toastList >= 4 do
                local oldest = table.remove(Lib._toastList, 1)
                oldest.expire = 0
            end
            local kind = o.Type or "Info"
            local col = th.Accent
            if kind == "Success" then col = th.Success
            elseif kind == "Warning" then col = th.Warning
            elseif kind == "Error" then col = th.Danger end
            Lib._seq = (Lib._seq or 0) + 1
            local card = new("CanvasGroup", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = th.Surface, BorderSizePixel = 0, GroupTransparency = 1, LayoutOrder = Lib._seq,
            }, Lib._nList)
            round(card, 8)
            new("UIStroke", {Color = th.Stroke, Thickness = 1}, card)
            new("Frame", {Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = col, BorderSizePixel = 0}, card)
            local inner = new("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            }, card)
            padding(inner, 14, 8, 10, 8)
            new("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, inner)
            if o.Title and tostring(o.Title) ~= "" then
                new("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                    Text = tostring(o.Title), RichText = true, TextWrapped = true, Font = Enum.Font.GothamBold,
                    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = th.Text, LayoutOrder = 1,
                }, inner)
            end
            if o.Content and tostring(o.Content) ~= "" then
                new("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                    Text = tostring(o.Content), RichText = true, TextWrapped = true, Font = Enum.Font.Gotham,
                    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = th.SubText, LayoutOrder = 2,
                }, inner)
            end
            local click = new("TextButton", {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5,
            }, card)
            local t = {alive = true, expire = os.clock() + dur}
            Lib._toasts[key] = t
            table.insert(Lib._toastList, t)
            click.Activated:Connect(function() t.expire = 0 end)
            tween(card, {GroupTransparency = 0}, TI)
            task.spawn(function()
                while t.alive and os.clock() < t.expire do task.wait(0.1) end
                pcall(function() tween(card, {GroupTransparency = 1}, TI) end)
                task.wait(0.25)
                t.alive = false
                if Lib._toasts[key] == t then Lib._toasts[key] = nil end
                pcall(function() card:Destroy() end)
            end)
        end)
        if not ok then warn("[BeeZ Hub] notify failed: " .. tostring(err)) end
    end
    keep(UIS.InputBegan:Connect(function(input, gp)
        if Lib._listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local fn = Lib._listening
                Lib._listening = nil
                fn(input.KeyCode)
            end
            return
        end
        if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for _, win in ipairs(Lib.Windows) do
            for _, kb in ipairs(win._keybinds) do
                if kb.down then kb.down(input.KeyCode) end
            end
        end
    end))
    keep(UIS.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        for _, win in ipairs(Lib.Windows) do
            for _, kb in ipairs(win._keybinds) do
                if kb.up then kb.up(input.KeyCode) end
            end
        end
    end))
    function Lib:_nextOrder()
        Lib._order = Lib._order + 1
        return Lib._order
    end
    function Lib:_front(win)
        if win.Gui and win.Gui.DisplayOrder ~= Lib._order then
            win.Gui.DisplayOrder = Lib:_nextOrder()
        end
    end
    function Window:_bind(obj, prop, key)
        obj[prop] = self.Theme[key]
        table.insert(self._bound, {obj, prop, key})
    end
    function Window:_onTheme(fn)
        table.insert(self._hooks, fn)
    end
    function Window:_reg(flag, comp)
        if flag then self.Flags[flag] = comp end
    end
    local function resolveTheme(v)
        if type(v) == "table" then
            local t = copy(THEMES.Dark)
            for k, c in pairs(v) do t[k] = c end
            return "Custom", t
        end
        if THEMES[v] then return v, copy(THEMES[v]) end
        return "Dark", copy(THEMES.Dark)
    end
    function Window:SetTheme(v)
        if type(v) == "table" then self._customTbl = v end
        local name, t = resolveTheme(v)
        self.ThemeName = name
        self._baseAccent = t.Accent
        if self._accent then t.Accent = self._accent end
        self.Theme = t
        local aliveList = {}
        for _, e in ipairs(self._bound) do
            local obj = e[1]
            if obj.Parent ~= nil then
                table.insert(aliveList, e)
                tween(obj, {[e[2]] = t[e[3]]}, TI)
            end
        end
        self._bound = aliveList
        for _, fn in ipairs(self._hooks) do pcall(fn) end
        if self._accentPicker and not self._accent then self._accentPicker:Set(t.Accent, true) end
    end
    function Window:SetAccent(c)
        if c ~= nil and self._baseAccent then
            local b = self._baseAccent
            if math.abs(c.R - b.R) + math.abs(c.G - b.G) + math.abs(c.B - b.B) < 0.01 then c = nil end
        end
        self._accent = c
        local col = c or self._baseAccent
        self.Theme.Accent = col
        for _, e in ipairs(self._bound) do
            if e[3] == "Accent" and e[1].Parent ~= nil then e[1][e[2]] = col end
        end
        for _, fn in ipairs(self._hooks) do pcall(fn) end
    end
    function Window:SetScale(s)
        s = math.clamp(tonumber(s) or 1, 0.6, 1.3)
        self.Scale = s
        self.UIScale.Scale = s
        self.Holder.Size = UDim2.fromScale(1 / s, 1 / s)
    end
    function Window:SetTransparency(t)
        t = math.clamp(tonumber(t) or 0, 0, 0.7)
        self.Transparency = t
        for _, fr in ipairs(self._transFrames) do fr.BackgroundTransparency = t end
    end
    function Window:SetLocked(v) self.Locked = v and true or false end
    function Window:Notify(a, b, c) Lib:Notify(a, b, c) end
    function Window:ResetPosition()
        self.Main.Position = UDim2.fromScale(0.5, 0.5)
        self.Main.Size = UDim2.fromOffset(self._defSize.X, self._defSize.Y)
    end
    function Window:Toggle(v)
        if v == nil then v = not self.Main.Visible end
        self.Main.Visible = v
        if not v then self:_closePopup() end
        if v then Lib:_front(self) end
    end
    function Window:Minimize(v)
        if v == nil then v = not self._min end
        self._min = v
        self._side.Visible = not v
        self._contentF.Visible = not v
        self._sep.Visible = not v
        self._grip.Visible = not v
        self:_closePopup()
        if v then
            self._fullSize = self.Main.Size
            tween(self.Main, {Size = UDim2.fromOffset(self.Main.Size.X.Offset, 40)}, TI)
        else
            tween(self.Main, {Size = self._fullSize or UDim2.fromOffset(self._defSize.X, self._defSize.Y)}, TI)
        end
    end
    function Window:Destroy()
        for i, w in ipairs(Lib.Windows) do
            if w == self then
                table.remove(Lib.Windows, i)
                break
            end
        end
        if self.Gui then self.Gui:Destroy() end
    end
    function Window:_openPopup(frame)
        if self._popup and self._popup ~= frame then self._popup.Visible = false end
        self._popup = frame
        self.Catcher.Visible = true
        frame.Visible = true
    end
    function Window:_closePopup()
        if self._popup then self._popup.Visible = false end
        self._popup = nil
        if self.Catcher then self.Catcher.Visible = false end
    end
    function Window:_place(frame, anchor, w, h)
        local s = self.Scale
        local ap, as = anchor.AbsolutePosition, anchor.AbsoluteSize
        local sw, sh = self.Gui.AbsoluteSize.X / s, self.Gui.AbsoluteSize.Y / s
        local x = ap.X / s
        local y = (ap.Y + as.Y) / s + 3
        if y + h > sh - 6 then y = ap.Y / s - h - 3 end
        if y < 6 then y = 6 end
        x = math.clamp(x, 6, math.max(6, sw - w - 6))
        frame.Position = UDim2.fromOffset(x, y)
        frame.Size = UDim2.fromOffset(w, h)
    end
    function Window:_tip(obj, text)
        if not text or text == "" then return end
        local function show()
            self._tipLabel.Text = Lib.Tr and Lib.Tr(tostring(text)) or tostring(text)
            local s = self.Scale
            local ap, as = obj.AbsolutePosition, obj.AbsoluteSize
            local sw = self.Gui.AbsoluteSize.X / s
            local x = math.clamp(ap.X / s, 6, math.max(6, sw - 236))
            local y = (ap.Y + as.Y) / s + 4
            self._tipFrame.Position = UDim2.fromOffset(x, y)
            self._tipFrame.Visible = true
        end
        local hover, holding = false, false
        obj.MouseEnter:Connect(function()
            hover = true
            task.delay(0.5, function() if hover then show() end end)
        end)
        obj.MouseLeave:Connect(function()
            hover = false
            self._tipFrame.Visible = false
        end)
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                holding = true
                task.delay(0.55, function() if holding then show() end end)
            end
        end)
        obj.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                holding = false
                task.delay(1.5, function() if not holding then self._tipFrame.Visible = false end end)
            end
        end)
    end
    function Window:SetLoadOrder(list)
        self._loadLast = type(list) == "table" and list or {}
    end
    function Window:_snapshot()
        local flags, keys = {}, {}
        for flag, comp in pairs(self.Flags) do
            if not comp.NoSave and comp.Get then
                local ok, v = pcall(function() return comp:Get() end)
                if ok and v ~= nil then
                    local ev = encodeVal(v)
                    if pcall(function() return HttpService:JSONEncode({ev}) end) then
                        flags[flag] = ev
                        keys[#keys + 1] = flag
                    end
                end
            end
        end
        table.sort(keys)
        local sig = {}
        for i, k in ipairs(keys) do sig[i] = k .. "=" .. HttpService:JSONEncode({flags[k]}) end
        return flags, table.concat(sig, "\n")
    end
    function Window:RestoreState()
        local io = self._stateIO
        local d = io.read()
        local restored = false
        if type(d) == "table" and type(d.flags) == "table" then
            restored = true
            local function applyFlag(flag, v)
                local comp = self.Flags[flag]
                if comp and not comp.NoSave and comp.Set then
                    pcall(function() comp:Set(decodeVal(v)) end)
                end
            end
            local late = {}
            for _, fl in ipairs(self._loadLast or {}) do late[fl] = true end
            if d.flags["ui.theme"] ~= nil then applyFlag("ui.theme", d.flags["ui.theme"]) end
            for flag, v in pairs(d.flags) do
                if not late[flag] and flag ~= "ui.theme" then applyFlag(flag, v) end
            end
            for _, fl in ipairs(self._loadLast or {}) do
                if d.flags[fl] ~= nil then applyFlag(fl, d.flags[fl]) end
            end
        end
        local _, last = self:_snapshot()
        task.spawn(function()
            while self.Gui and self.Gui.Parent do
                task.wait(0.4)
                local flags, cur = self:_snapshot()
                if cur ~= last and io.write({v = 2, flags = flags}) then last = cur end
            end
        end)
        return restored
    end
    function Window:SelectTab(tab)
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = (t == tab)
            t._active = (t == tab)
            t._paint()
        end
        self._activeTab = tab
        self:_closePopup()
    end
    local TAB_ICONS = {
        info = "rbxassetid://124560466474914",
        box = "rbxassetid://101768155599700",
        house = "rbxassetid://98755624629571",
        ["circle-dot"] = "rbxassetid://82947033619201",
        ["share-2"] = "rbxassetid://71210767962065",
        webhook = "rbxassetid://112812457747322",
        wrench = "rbxassetid://112148279212860",
        settings = "rbxassetid://80758916183665",
    }
    function Window:AddTab(name, opts)
        opts = opts or {}
        local win = self
        local tab = setmetatable({Window = win, Name = tostring(name), _sections = {}, _active = false}, Tab)
        local btn = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
            BorderSizePixel = 0, LayoutOrder = #win.Tabs + 1,
        }, win._tabList)
        round(btn, 8)
        local bar = new("Frame", {
            Position = UDim2.new(0, 0, 0.5, -9), Size = UDim2.fromOffset(3, 18), BorderSizePixel = 0, Visible = false,
        }, btn)
        round(bar, 2)
        win:_bind(bar, "BackgroundColor3", "Accent")
        local iconId = opts.Icon and (TAB_ICONS[opts.Icon] or opts.Icon)
        local textX = iconId and 36 or 14
        if iconId then
            local icon = new("ImageLabel", {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 11, 0.5, 0), Size = UDim2.fromOffset(18, 18),
                BackgroundTransparency = 1, Image = iconId, ScaleType = Enum.ScaleType.Fit,
            }, btn)
            win:_bind(icon, "ImageColor3", "Accent")
        end
        local lbl = new("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(textX, 0), Size = UDim2.new(1, -textX, 1, 0),
            Text = tab.Name, Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, btn)
        tab._paint = function()
            local th = win.Theme
            bar.Visible = tab._active
            btn.BackgroundTransparency = tab._active and 0 or 1
            btn.BackgroundColor3 = th.Element
            lbl.TextColor3 = tab._active and th.Text or th.SubText
        end
        win:_onTheme(tab._paint)
        btn.MouseEnter:Connect(function()
            if not tab._active then lbl.TextColor3 = win.Theme.Text end
        end)
        btn.MouseLeave:Connect(function()
            if not tab._active then lbl.TextColor3 = win.Theme.SubText end
        end)
        btn.Activated:Connect(function() win:SelectTab(tab) end)
        local page = new("ScrollingFrame", {
            Name = "Page_" .. tab.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false,
        }, win._contentF)
        win:_bind(page, "ScrollBarImageColor3", "Accent")
        padding(page, 10, 10, 10, 10)
        new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, page)
        tab.Page, tab.Button = page, btn
        table.insert(win.Tabs, tab)
        tab._paint()
        if #win.Tabs == 1 then win:SelectTab(tab) end
        return tab
    end
    function Tab:AddSection(title, opts)
        opts = opts or {}
        local win = self.Window
        local card = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0,
            LayoutOrder = #self._sections + 1,
        }, self.Page)
        win:_bind(card, "BackgroundColor3", "Surface")
        round(card, 10)
        local cs = new("UIStroke", {Thickness = 1}, card)
        win:_bind(cs, "Color", "Stroke")
        padding(card, 10, 8, 10, 10)
        new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, card)
        local body = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 1,
        }, card)
        new("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, body)
        if title and title ~= "" then
            local header = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = 0,
            }, card)
            local hl = new("TextLabel", {
                BackgroundTransparency = 1, Size = UDim2.new(1, -24, 1, 0), Text = string.upper(tostring(title)),
                Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
            }, header)
            win:_bind(hl, "TextColor3", "Accent")
            local chev = new("TextLabel", {
                BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.fromOffset(20, 20), Text = "v", Font = Enum.Font.GothamBold, TextSize = 12,
            }, header)
            win:_bind(chev, "TextColor3", "SubText")
            if opts.Collapsible ~= false then
                local open = opts.Collapsed ~= true
                body.Visible = open
                chev.Text = open and "v" or ">"
                header.Activated:Connect(function()
                    open = not open
                    body.Visible = open
                    chev.Text = open and "v" or ">"
                end)
            else
                chev.Visible = false
            end
        end
        local c = setmetatable({Window = win, Frame = body, Page = self.Page, Tab = self}, Container)
        table.insert(self._sections, c)
        return c
    end
    function Tab:_default()
        if not self._def then self._def = self:AddSection(nil) end
        return self._def
    end
    function Container:_order()
        self._n = (self._n or 0) + 1
        return self._n
    end
    local function hoverColor(th, key)
        if key == "Element" then return th.ElementHover end
        return th[key]:Lerp(Color3.new(1, 1, 1), 0.14)
    end
    local function elementBase(self, height, tooltip, colorKey)
        local win = self.Window
        colorKey = colorKey or "Element"
        local f = new("TextButton", {
            Size = UDim2.new(1, 0, 0, height), BorderSizePixel = 0, Text = "", AutoButtonColor = false,
            LayoutOrder = self:_order(),
        }, self.Frame)
        win:_bind(f, "BackgroundColor3", colorKey)
        round(f, 8)
        f.MouseEnter:Connect(function()
            tween(f, {BackgroundColor3 = hoverColor(win.Theme, colorKey)}, TI_FAST)
        end)
        f.MouseLeave:Connect(function()
            tween(f, {BackgroundColor3 = win.Theme[colorKey]}, TI_FAST)
        end)
        if tooltip then win:_tip(f, tooltip) end
        return f
    end
    local function textLabel(win, parent, props, colorKey)
        props.BackgroundTransparency = 1
        props.Font = props.Font or Enum.Font.GothamMedium
        props.TextSize = props.TextSize or 13
        props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
        local l = new("TextLabel", props, parent)
        win:_bind(l, "TextColor3", colorKey or "Text")
        return l
    end
    local function fieldStyle(win, o)
        round(o, 6)
        win:_bind(o, "BackgroundColor3", "Background")
        local s = new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o)
        win:_bind(s, "Color", "Stroke")
    end
    local function finish(obj, f)
        obj.Frame = f
        function obj:SetVisible(v) f.Visible = v and true or false end
        function obj:Destroy() f:Destroy() end
        return obj
    end
    function Container:AddLabel(...)
        local o = P({"Text"}, ...)
        local win = self.Window
        local l = new("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = tostring(o.Text or ""), RichText = true, TextWrapped = true, Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = self:_order(),
        }, self.Frame)
        win:_bind(l, "TextColor3", o.Color or "SubText")
        padding(l, 4, 2)
        local obj = {}
        function obj:SetText(t) l.Text = tostring(t) end
        function obj:Get() return l.Text end
        function obj:Set(t) l.Text = tostring(t) end
        return finish(obj, l)
    end
    function Container:AddParagraph(...)
        local o = P({"Title", "Content"}, ...)
        local win = self.Window
        local f = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, LayoutOrder = self:_order(),
        }, self.Frame)
        win:_bind(f, "BackgroundColor3", "Element")
        round(f, 8)
        padding(f, 10, 8, 10, 8)
        new("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, f)
        local t = textLabel(win, f, {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = tostring(o.Title or ""),
            RichText = true, TextWrapped = true, Font = Enum.Font.GothamBold, TextSize = 13, LayoutOrder = 1,
        }, "Text")
        local c = textLabel(win, f, {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = tostring(o.Content or ""),
            RichText = true, TextWrapped = true, Font = Enum.Font.Gotham, TextSize = 12, TextYAlignment = Enum.TextYAlignment.Top,
            LayoutOrder = 2,
        }, "SubText")
        local obj = {}
        function obj:SetTitle(x) t.Text = tostring(x) end
        function obj:SetContent(x) c.Text = tostring(x) end
        return finish(obj, f)
    end
    function Container:AddDivider()
        local win = self.Window
        local d = new("Frame", {Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, LayoutOrder = self:_order()}, self.Frame)
        win:_bind(d, "BackgroundColor3", "Stroke")
        return finish({}, d)
    end
    function Container:AddButton(...)
        local o = P({"Name", "Callback"}, ...)
        local win = self.Window
        local style = o.Style or "Default"
        local key = (style == "Accent" and "Accent") or (style == "Danger" and "Danger") or "Element"
        local f = elementBase(self, 34, o.Tooltip, key)
        local txt = new("TextLabel", {
            BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = tostring(o.Name or "Button"), RichText = true,
            Font = Enum.Font.GothamMedium, TextSize = 13,
        }, f)
        if key == "Element" then
            win:_bind(txt, "TextColor3", "Text")
        else
            txt.TextColor3 = Color3.new(1, 1, 1)
        end
        f.Activated:Connect(function()
            local th = win.Theme
            tween(f, {BackgroundColor3 = th[key]:Lerp(Color3.new(0, 0, 0), 0.18)}, TI_FAST)
            task.delay(0.12, function()
                tween(f, {BackgroundColor3 = th[key]}, TI_FAST)
            end)
            safe(o.Callback)
        end)
        local obj = {}
        function obj:SetText(t) txt.Text = tostring(t) end
        function obj:SetCallback(cb) o.Callback = cb end
        return finish(obj, f)
    end
    function Container:AddToggle(...)
        local o = P({"Name", "Default", "Callback"}, ...)
        local win = self.Window
        local f = elementBase(self, 34, o.Tooltip)
        textLabel(win, f, {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -62, 1, 0), Text = tostring(o.Name or "Toggle"),
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Text")
        local track = new("Frame", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(40, 20),
            BorderSizePixel = 0,
        }, f)
        round(track, 10)
        local knob = new("Frame", {
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(14, 14),
            BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1),
        }, track)
        round(knob, 7)
        local state = o.Default == true
        local function paint(animate)
            local th = win.Theme
            local col = state and th.Accent or th.Stroke
            local pos = state and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
            if animate then
                tween(track, {BackgroundColor3 = col}, TI)
                tween(knob, {Position = pos}, TI)
            else
                track.BackgroundColor3 = col
                knob.Position = pos
            end
        end
        paint(false)
        win:_onTheme(function() paint(false) end)
        local obj = {NoSave = o.NoSave}
        function obj:Get() return state end
        function obj:Set(v, silent)
            v = v and true or false
            if v == state then return end
            state = v
            paint(true)
            if not silent then safe(o.Callback, state) end
        end
        f.Activated:Connect(function() obj:Set(not state) end)
        win:_reg(o.Flag, obj)
        return finish(obj, f)
    end
    function Container:AddSlider(...)
        local o = P({"Name", "Min", "Max", "Default", "Callback"}, ...)
        local win = self.Window
        local min, max = tonumber(o.Min) or 0, tonumber(o.Max) or 100
        if max < min then min, max = max, min end
        local step = tonumber(o.Step) or 1
        if step <= 0 then step = 1 end
        local suffix = tostring(o.Suffix or "")
        local value = math.clamp(tonumber(o.Default) or min, min, max)
        local f = elementBase(self, 48, o.Tooltip)
        textLabel(win, f, {
            Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -90, 0, 16), Text = tostring(o.Name or "Slider"),
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Text")
        local valL = textLabel(win, f, {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 6), Size = UDim2.fromOffset(72, 16),
            TextXAlignment = Enum.TextXAlignment.Right, Font = Enum.Font.GothamBold, TextSize = 12,
        }, "Accent")
        local hit = new("TextButton", {
            Position = UDim2.new(0, 8, 0, 26), Size = UDim2.new(1, -16, 0, 18), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false,
        }, f)
        local bar = new("Frame", {
            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 6), BorderSizePixel = 0,
        }, hit)
        win:_bind(bar, "BackgroundColor3", "Stroke")
        round(bar, 3)
        local fill = new("Frame", {Size = UDim2.fromScale(0, 1), BorderSizePixel = 0}, bar)
        win:_bind(fill, "BackgroundColor3", "Accent")
        round(fill, 3)
        local knob = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(14, 14),
            BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 2,
        }, bar)
        round(knob, 7)
        local function fmt(v)
            if step >= 1 then return tostring(math.floor(v + 0.5)) end
            local s = string.format("%.2f", v):gsub("0+$", ""):gsub("%.$", "")
            return s
        end
        local function setValue(v, silent)
            v = math.clamp(v, min, max)
            v = math.floor((v - min) / step + 0.5) * step + min
            v = math.clamp(v, min, max)
            value = v
            local a = (max > min) and (v - min) / (max - min) or 0
            fill.Size = UDim2.fromScale(a, 1)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            valL.Text = fmt(v) .. suffix
            if not silent then safe(o.Callback, v) end
        end
        setValue(value, true)
        local function fromInput(px)
            local a = math.clamp((px - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
            setValue(min + a * (max - min))
        end
        hit.InputBegan:Connect(function(input)
            if not isPointer(input) then return end
            if self.Page then self.Page.ScrollingEnabled = false end
            fromInput(input.Position.X)
            trackDrag(input, function(p) fromInput(p.X) end, function()
                if self.Page then self.Page.ScrollingEnabled = true end
            end)
        end)
        local obj = {NoSave = o.NoSave}
        function obj:Get() return value end
        function obj:Set(v, silent)
            if tonumber(v) then setValue(tonumber(v), silent) end
        end
        win:_reg(o.Flag, obj)
        return finish(obj, f)
    end
    function Container:AddInput(...)
        local o = P({"Name", "Default", "Callback"}, ...)
        local win = self.Window
        local f = elementBase(self, 34, o.Tooltip)
        textLabel(win, f, {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(0.5, -14, 1, 0), Text = tostring(o.Name or "Input"),
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Text")
        local box = new("TextBox", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.new(0.5, -6, 0, 24),
            Text = tostring(o.Default or ""), PlaceholderText = tostring(o.Placeholder or ""),
            ClearTextOnFocus = o.ClearOnFocus == true, Font = Enum.Font.Gotham, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
        }, f)
        fieldStyle(win, box)
        padding(box, 8, 0)
        win:_bind(box, "TextColor3", "Text")
        win:_bind(box, "PlaceholderColor3", "SubText")
        local value = box.Text
        box.FocusLost:Connect(function(enter)
            if o.Numeric then
                local n = tonumber(box.Text)
                if n then box.Text = tostring(n) else box.Text = value end
            end
            value = box.Text
            safe(o.Callback, value, enter)
        end)
        local obj = {NoSave = o.NoSave}
        function obj:Get() return box.Text end
        function obj:Set(v, silent)
            box.Text = tostring(v or "")
            value = box.Text
            if not silent then safe(o.Callback, value, false) end
        end
        win:_reg(o.Flag, obj)
        return finish(obj, f)
    end
    function Container:AddDropdown(...)
        local o = P({"Name", "Options", "Default", "Callback"}, ...)
        local win = self.Window
        local options = type(o.Options) == "table" and o.Options or {}
        local searchable = o.Searchable ~= false
        local f = elementBase(self, 34, o.Tooltip)
        textLabel(win, f, {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(0.5, -14, 1, 0), Text = tostring(o.Name or "Dropdown"),
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Text")
        local btn = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.new(0.5, -6, 0, 24),
            Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        }, f)
        fieldStyle(win, btn)
        local val = textLabel(win, btn, {
            Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -26, 1, 0), Font = Enum.Font.GothamMedium,
            TextSize = 12, TextTruncate = Enum.TextTruncate.AtEnd, Text = "None",
        }, "Text")
        textLabel(win, btn, {
            AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -2, 0, 0), Size = UDim2.fromOffset(20, 24),
            Text = "v", Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center,
        }, "SubText")
        local value
        local popup, search, listFrame
        local rows = {}
        local obj = {NoSave = o.NoSave}
        local function paintRows()
            local th = win.Theme
            for _, r in ipairs(rows) do
                local sel = (value ~= nil) and (r.opt == value or tostring(r.opt) == tostring(value))
                r.btn.TextColor3 = sel and th.Accent or th.Text
                r.btn.Font = sel and Enum.Font.GothamBold or Enum.Font.GothamMedium
                r.btn.BackgroundColor3 = th.Element
                r.btn.BackgroundTransparency = sel and 0 or 1
            end
        end
        local function rebuildRows()
            if not listFrame then return end
            for _, c in ipairs(listFrame:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            rows = {}
            for i, opt in ipairs(options) do
                local b = new("TextButton", {
                    Size = UDim2.new(1, -4, 0, 26), BackgroundTransparency = 1, AutoButtonColor = false,
                    Text = tostring(opt), Font = Enum.Font.GothamMedium, TextSize = 12, BorderSizePixel = 0, LayoutOrder = i,
                }, listFrame)
                round(b, 6)
                rows[i] = {btn = b, opt = opt}
                b.Activated:Connect(function()
                    obj:Set(opt)
                    win:_closePopup()
                end)
            end
            paintRows()
        end
        win:_onTheme(paintRows)
        local function build()
            popup = new("Frame", {Visible = false, BorderSizePixel = 0, ZIndex = 3}, win.Overlay)
            win:_bind(popup, "BackgroundColor3", "Surface")
            round(popup, 8)
            local ps = new("UIStroke", {Thickness = 1}, popup)
            win:_bind(ps, "Color", "Stroke")
            local topOff = 0
            if searchable then
                search = new("TextBox", {
                    Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 0, 24), Text = "",
                    PlaceholderText = "Search...", ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
                }, popup)
                fieldStyle(win, search)
                padding(search, 8, 0)
                win:_bind(search, "TextColor3", "Text")
                win:_bind(search, "PlaceholderColor3", "SubText")
                topOff = 34
                search:GetPropertyChangedSignal("Text"):Connect(function()
                    local q = search.Text:lower()
                    for _, r in ipairs(rows) do
                        r.btn.Visible = (q == "" or tostring(r.opt):lower():find(q, 1, true) ~= nil)
                    end
                end)
            end
            listFrame = new("ScrollingFrame", {
                Position = UDim2.fromOffset(4, topOff + 4), Size = UDim2.new(1, -8, 1, -(topOff + 8)),
                BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
            }, popup)
            win:_bind(listFrame, "ScrollBarImageColor3", "Accent")
            new("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, listFrame)
            rebuildRows()
        end
        btn.Activated:Connect(function()
            if not popup then build() end
            if search then search.Text = "" end
            for _, r in ipairs(rows) do r.btn.Visible = true end
            local h = math.min(math.max(#options, 1), 6) * 28 + (searchable and 34 or 0) + 10
            win:_place(popup, btn, btn.AbsoluteSize.X / win.Scale, h)
            win:_openPopup(popup)
        end)
        function obj:Get() return value end
        function obj:Set(v, silent)
            local found
            if v ~= nil then
                for _, opt in ipairs(options) do
                    if opt == v or tostring(opt) == tostring(v) then
                        found = opt
                        break
                    end
                end
            end
            value = found
            val.Text = (found ~= nil) and tostring(found) or "None"
            paintRows()
            if not silent and found ~= nil then safe(o.Callback, found) end
        end
        function obj:SetOptions(list)
            options = type(list) == "table" and list or {}
            local keep = false
            for _, opt in ipairs(options) do
                if value ~= nil and (opt == value or tostring(opt) == tostring(value)) then keep = true end
            end
            if not keep then
                value = nil
                val.Text = "None"
            end
            rebuildRows()
        end
        obj.Refresh = obj.SetOptions
        if o.Default ~= nil then obj:Set(o.Default, true) end
        win:_reg(o.Flag, obj)
        return finish(obj, f)
    end
    function Container:AddColorPicker(...)
        local o = P({"Name", "Default", "Callback"}, ...)
        local win = self.Window
        local color = typeof(o.Default) == "Color3" and o.Default or Color3.fromRGB(255, 255, 255)
        local h, s, v = Color3.toHSV(color)
        local f = elementBase(self, 34, o.Tooltip)
        textLabel(win, f, {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -70, 1, 0), Text = tostring(o.Name or "Color"),
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Text")
        local sw = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(44, 20),
            Text = "", AutoButtonColor = false, BorderSizePixel = 0, BackgroundColor3 = color,
        }, f)
        round(sw, 6)
        local sws = new("UIStroke", {Thickness = 1}, sw)
        win:_bind(sws, "Color", "Stroke")
        local popup, svBox, svCursor, hueBar, hueCursor, hexBox, preview
        local obj = {NoSave = o.NoSave}
        local function hex(c)
            return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
        end
        local function refreshPopup()
            if not popup then return end
            svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
            hueCursor.Position = UDim2.new(0.5, 0, h, 0)
            preview.BackgroundColor3 = color
            hexBox.Text = hex(color)
        end
        local function apply(silent)
            color = Color3.fromHSV(h, s, v)
            sw.BackgroundColor3 = color
            refreshPopup()
            if not silent then safe(o.Callback, color) end
        end
        local function build()
            popup = new("Frame", {Visible = false, BorderSizePixel = 0, ZIndex = 3}, win.Overlay)
            win:_bind(popup, "BackgroundColor3", "Surface")
            round(popup, 8)
            local ps = new("UIStroke", {Thickness = 1}, popup)
            win:_bind(ps, "Color", "Stroke")
            svBox = new("TextButton", {
                Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(150, 100), Text = "", AutoButtonColor = false,
                BorderSizePixel = 0, BackgroundColor3 = Color3.fromHSV(h, 1, 1),
            }, popup)
            round(svBox, 6)
            local white = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0}, svBox)
            round(white, 6)
            new("UIGradient", {
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)}),
            }, white)
            local black = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0}, svBox)
            round(black, 6)
            new("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}),
            }, black)
            svCursor = new("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, ZIndex = 4,
            }, svBox)
            round(svCursor, 6)
            new("UIStroke", {Thickness = 2, Color = Color3.new(1, 1, 1)}, svCursor)
            hueBar = new("TextButton", {
                Position = UDim2.fromOffset(166, 8), Size = UDim2.fromOffset(18, 100), Text = "", AutoButtonColor = false,
                BorderSizePixel = 0, BackgroundColor3 = Color3.new(1, 1, 1),
            }, popup)
            round(hueBar, 6)
            local seq = {}
            for i = 0, 6 do
                table.insert(seq, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 >= 1 and 0.999 or i / 6, 1, 1)))
            end
            new("UIGradient", {Rotation = 90, Color = ColorSequence.new(seq)}, hueBar)
            hueCursor = new("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(1, 4, 0, 5), BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0, ZIndex = 4,
            }, hueBar)
            round(hueCursor, 2)
            new("UIStroke", {Thickness = 1, Color = Color3.new(0, 0, 0)}, hueCursor)
            hexBox = new("TextBox", {
                Position = UDim2.fromOffset(8, 116), Size = UDim2.fromOffset(112, 26), Text = hex(color), ClearTextOnFocus = false,
                Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0,
            }, popup)
            fieldStyle(win, hexBox)
            padding(hexBox, 8, 0)
            win:_bind(hexBox, "TextColor3", "Text")
            preview = new("Frame", {
                Position = UDim2.fromOffset(128, 116), Size = UDim2.fromOffset(56, 26), BorderSizePixel = 0, BackgroundColor3 = color,
            }, popup)
            round(preview, 6)
            local function svFrom(p)
                s = math.clamp((p.X - svBox.AbsolutePosition.X) / math.max(svBox.AbsoluteSize.X, 1), 0, 1)
                v = 1 - math.clamp((p.Y - svBox.AbsolutePosition.Y) / math.max(svBox.AbsoluteSize.Y, 1), 0, 1)
                apply(false)
            end
            local function hueFrom(p)
                h = math.clamp((p.Y - hueBar.AbsolutePosition.Y) / math.max(hueBar.AbsoluteSize.Y, 1), 0, 0.999)
                apply(false)
            end
            svBox.InputBegan:Connect(function(input)
                if not isPointer(input) then return end
                svFrom(input.Position)
                trackDrag(input, svFrom)
            end)
            hueBar.InputBegan:Connect(function(input)
                if not isPointer(input) then return end
                hueFrom(input.Position)
                trackDrag(input, hueFrom)
            end)
            hexBox.FocusLost:Connect(function()
                local txt = hexBox.Text:gsub("#", "")
                if #txt == 6 then
                    local r, g, b = tonumber(txt:sub(1, 2), 16), tonumber(txt:sub(3, 4), 16), tonumber(txt:sub(5, 6), 16)
                    if r and g and b then
                        h, s, v = Color3.toHSV(Color3.fromRGB(r, g, b))
                        apply(false)
                        return
                    end
                end
                hexBox.Text = hex(color)
            end)
            refreshPopup()
        end
        sw.Activated:Connect(function()
            if not popup then build() end
            refreshPopup()
            win:_place(popup, sw, 192, 150)
            win:_openPopup(popup)
        end)
        function obj:Get() return color end
        function obj:Set(c, silent)
            if typeof(c) ~= "Color3" then return end
            h, s, v = Color3.toHSV(c)
            apply(silent)
        end
        win:_reg(o.Flag, obj)
        return finish(obj, f)
    end
    function Container:AddKeybind(...)
        local o = P({"Name", "Default", "Callback"}, ...)
        local win = self.Window
        local mode = o.Mode or "Press"
        local function toKey(x)
            if typeof(x) == "EnumItem" then return x end
            if type(x) == "string" and x ~= "" and x ~= "None" then
                local ok, kc = pcall(function() return Enum.KeyCode[x] end)
                if ok then return kc end
            end
            return nil
        end
        local key = toKey(o.Default)
        local f = elementBase(self, 34, o.Tooltip)
        textLabel(win, f, {
            Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -116, 1, 0), Text = tostring(o.Name or "Keybind"),
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, "Text")
        local btn = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0.5, 0), Size = UDim2.fromOffset(96, 24),
            Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        }, f)
        fieldStyle(win, btn)
        local txt = textLabel(win, btn, {
            Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, Font = Enum.Font.GothamBold,
            TextSize = 11, Text = "None",
        }, "Text")
        local listening, state = false, false
        local function paint() txt.Text = listening and "..." or (key and key.Name or "None") end
        paint()
        local obj = {NoSave = o.NoSave}
        function obj:Get() return key and key.Name or "None" end
        function obj:Set(x, silent)
            key = toKey(x)
            paint()
            if not silent then safe(o.Changed, key) end
        end
        btn.Activated:Connect(function()
            if listening then return end
            listening = true
            paint()
            Lib._listening = function(code)
                listening = false
                if code == Enum.KeyCode.Escape then key = nil else key = code end
                paint()
                safe(o.Changed, key)
            end
        end)
        table.insert(win._keybinds, {
            down = function(code)
                if not key or code ~= key then return end
                if mode == "Toggle" then
                    state = not state
                    safe(o.Callback, state)
                elseif mode == "Hold" then
                    safe(o.Callback, true)
                else
                    safe(o.Callback, key)
                end
            end,
            up = function(code)
                if mode == "Hold" and key and code == key then safe(o.Callback, false) end
            end,
        })
        win:_reg(o.Flag, obj)
        return finish(obj, f)
    end
    function Container:AddGrid(...)
        local o = P({"Columns", "CellHeight"}, ...)
        local cols = math.max(1, math.floor(tonumber(o.Columns) or 2))
        local pad = tonumber(o.Padding) or 6
        local g = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            LayoutOrder = self:_order(),
        }, self.Frame)
        new("UIGridLayout", {
            CellPadding = UDim2.fromOffset(pad, pad),
            CellSize = UDim2.new(1 / cols, -math.ceil(pad * (cols - 1) / cols), 0, tonumber(o.CellHeight) or 34),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, g)
        return setmetatable({Window = self.Window, Frame = g, Page = self.Page, Tab = self.Tab}, Container)
    end
    for _, name in ipairs({"AddLabel", "AddParagraph", "AddDivider", "AddButton", "AddToggle", "AddSlider", "AddInput",
        "AddDropdown", "AddColorPicker", "AddKeybind", "AddGrid"}) do
        Tab[name] = function(self, ...)
            return Container[name](self:_default(), ...)
        end
    end
    function Window:AddSettingsTab(name)
        local win = self
        local tab = self:AddTab(name or "Settings", {Icon = "settings"})
        local ap = tab:AddSection("Appearance")
        ap:AddDropdown({
            Name = "Theme", Flag = "ui.theme", Options = {"Dark", "Light", "Midnight", "Ocean"},
            Default = win.ThemeName, Searchable = false,
            Callback = function(v) win:SetTheme(v) end,
        })
        win._accentPicker = ap:AddColorPicker({
            Name = "Accent Color", Flag = "ui.accent", Default = win.Theme.Accent,
            Callback = function(c) win:SetAccent(c) end,
        })
        ap:AddSlider({
            Name = "Transparency", Flag = "ui.transparency", Min = 0, Max = 0.6, Step = 0.05, Default = win.Transparency,
            Callback = function(v) win:SetTransparency(v) end,
        })
        ap:AddSlider({
            Name = "UI Scale", Flag = "ui.scale", Min = 0.7, Max = 1.2, Step = 0.05, Default = win.Scale,
            Callback = function(v) win:SetScale(v) end,
        })
        local ct = tab:AddSection("Controls")
        ct:AddToggle({
            Name = "Lock UI", Flag = "ui.lock", Default = false,
            Tooltip = "Disables dragging and resizing the window",
            Callback = function(v) win:SetLocked(v) end,
        })
        ct:AddKeybind({
            Name = "Toggle UI Key", Flag = "ui.key", Default = win.ToggleKey, Mode = "Press",
            Changed = function(k) win.ToggleKey = k or Enum.KeyCode.RightShift end,
        })
        ct:AddButton({Name = "Reset Window Position", Callback = function() win:ResetPosition() end})
        return tab
    end
    function Lib:CreateWindow(a, b)
        local o = type(a) == "table" and a or {Title = a, Subtitle = b}
        local self = setmetatable({}, Window)
        self.Title = tostring(o.Title or "Window")
        self.Subtitle = tostring(o.Subtitle or "")
        self.Scale = 1
        self.Locked = false
        self.Flags = {}
        self.Tabs = {}
        self._bound, self._hooks, self._keybinds, self._transFrames = {}, {}, {}, {}
        self.Transparency = 0
        self._defSize = (typeof(o.Size) == "Vector2") and o.Size or Vector2.new(540, 310)
        self.MinSize = (typeof(o.MinSize) == "Vector2") and o.MinSize or Vector2.new(430, 250)
        self.MaxSize = (typeof(o.MaxSize) == "Vector2") and o.MaxSize or Vector2.new(720, 440)
        self.ToggleKey = (typeof(o.ToggleKey) == "EnumItem") and o.ToggleKey or Enum.KeyCode.RightShift
        self.ConfigFolder = tostring(o.ConfigFolder or "DiamondUI")
        self._stateIO = stateIO(self.ConfigFolder)
        if type(o.Theme) == "table" then self._customTbl = o.Theme end
        local tn, tt = resolveTheme(o.Theme or "Dark")
        self.ThemeName, self.Theme, self._baseAccent = tn, tt, tt.Accent
        local safeName = (self.Title:gsub("%W", ""))
        local gui = new("ScreenGui", {
            Name = "DiamondUI_" .. safeName, ResetOnSpawn = false, IgnoreGuiInset = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = Lib:_nextOrder(),
        })
        gui.Parent = pg
        self.Gui = gui
        local holder = new("Frame", {Name = "Holder", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}, gui)
        local uiscale = new("UIScale", {Scale = 1}, holder)
        self.Holder, self.UIScale = holder, uiscale
        local main = new("Frame", {
            Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(self._defSize.X, self._defSize.Y), BorderSizePixel = 0,
        }, holder)
        self:_bind(main, "BackgroundColor3", "Background")
        round(main, 12)
        local mst = new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, main)
        self:_bind(mst, "Color", "Stroke")
        self.Main = main
        table.insert(self._transFrames, main)
        main.InputBegan:Connect(function(input)
            if isPointer(input) then Lib:_front(self) end
        end)
        local top = new("Frame", {Name = "Topbar", Size = UDim2.new(1, 0, 0, 40), BorderSizePixel = 0}, main)
        self:_bind(top, "BackgroundColor3", "Topbar")
        round(top, 12)
        local topFill = new("Frame", {
            Position = UDim2.new(0, 0, 1, -12), Size = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0,
        }, top)
        self:_bind(topFill, "BackgroundColor3", "Topbar")
        table.insert(self._transFrames, top)
        table.insert(self._transFrames, topFill)
        local topLine = new("Frame", {
            Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0,
        }, top)
        self:_bind(topLine, "BackgroundColor3", "Stroke")
        
        -- ĐÃ XÓA DÒNG ÉP MÀU VÀNG ĐỂ ẢNH HIỂN THỊ ĐÚNG MÀU GỐC
        local logo = new("ImageLabel", {
            Position = UDim2.fromOffset(17, 15), Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1, Image = "rbxthumb://type=Asset&id=109784820389254&w=420&h=420", ScaleType = Enum.ScaleType.Fit
        }, top)

        local tl = new("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 3), Size = UDim2.new(1, -120, 0, 19),
            Text = self.Title, Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, top)
        self:_bind(tl, "TextColor3", "Text")
        local sl = new("TextLabel", {
            BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 21), Size = UDim2.new(1, -120, 0, 14),
            Text = self.Subtitle, Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, top)
        self:_bind(sl, "TextColor3", "SubText")
        local function topBtn(text, xOff, cb)
            local btn = new("TextButton", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOff, 0.5, 0), Size = UDim2.fromOffset(26, 26),
                BackgroundTransparency = 1, Text = text, Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false,
                BorderSizePixel = 0,
            }, top)
            round(btn, 6)
            self:_bind(btn, "TextColor3", "SubText")
            btn.MouseEnter:Connect(function()
                btn.BackgroundTransparency = 0
                btn.BackgroundColor3 = self.Theme.Element
            end)
            btn.MouseLeave:Connect(function() btn.BackgroundTransparency = 1 end)
            btn.Activated:Connect(cb)
            return btn
        end
        topBtn("x", -10, function() self:Toggle(false) end)
        topBtn("-", -40, function() self:Minimize() end)
        top.InputBegan:Connect(function(input)
            if self.Locked or not isPointer(input) then return end
            Lib:_front(self)
            local sp, si = main.Position, input.Position
            trackDrag(input, function(p)
                local d = (p - si) / self.Scale
                main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end)
        end)
        local side = new("Frame", {
            Name = "Sidebar", Position = UDim2.fromOffset(0, 41), Size = UDim2.new(0, 118, 1, -41), BorderSizePixel = 0,
        }, main)
        self:_bind(side, "BackgroundColor3", "Sidebar")
        round(side, 12)
        local sf1 = new("Frame", {Size = UDim2.new(1, 0, 0, 12), BorderSizePixel = 0}, side)
        self:_bind(sf1, "BackgroundColor3", "Sidebar")
        local sf2 = new("Frame", {Position = UDim2.new(1, -12, 0, 0), Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0}, side)
        self:_bind(sf2, "BackgroundColor3", "Sidebar")
        table.insert(self._transFrames, side)
        table.insert(self._transFrames, sf1)
        table.insert(self._transFrames, sf2)
        self._side = side
        local tabList = new("ScrollingFrame", {
            Position = UDim2.fromOffset(0, 6), Size = UDim2.new(1, 0, 1, -12), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        }, side)
        padding(tabList, 8, 2, 8, 2)
        new("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, tabList)
        self._tabList = tabList
        local sep = new("Frame", {
            Position = UDim2.fromOffset(118, 41), Size = UDim2.new(0, 1, 1, -41), BorderSizePixel = 0,
        }, main)
        self:_bind(sep, "BackgroundColor3", "Stroke")
        self._sep = sep
        local content = new("Frame", {
            Name = "Content", Position = UDim2.fromOffset(119, 41), Size = UDim2.new(1, -119, 1, -41),
            BackgroundTransparency = 1, ClipsDescendants = true,
        }, main)
        self._contentF = content
        local grip = new("TextButton", {
            AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -2, 1, -2), Size = UDim2.fromOffset(28, 28),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 6,
        }, main)
        for _, pt in ipairs({{17, 17}, {17, 10}, {10, 17}}) do
            local dot = new("Frame", {
                Position = UDim2.fromOffset(pt[1], pt[2]), Size = UDim2.fromOffset(3, 3), BorderSizePixel = 0, ZIndex = 6,
            }, grip)
            round(dot, 2)
            self:_bind(dot, "BackgroundColor3", "SubText")
        end
        self._grip = grip
        grip.InputBegan:Connect(function(input)
            if self.Locked or self._min or not isPointer(input) then return end
            local s = self.Scale
            local sz, ps, si = main.Size, main.Position, input.Position
            local maxW = math.min(self.MaxSize.X, self.Gui.AbsoluteSize.X / s - 16)
            local maxH = math.min(self.MaxSize.Y, self.Gui.AbsoluteSize.Y / s - 16)
            trackDrag(input, function(p)
                local d = (p - si) / s
                local w = math.clamp(sz.X.Offset + d.X, self.MinSize.X, math.max(self.MinSize.X, maxW))
                local h = math.clamp(sz.Y.Offset + d.Y, self.MinSize.Y, math.max(self.MinSize.Y, maxH))
                main.Size = UDim2.fromOffset(w, h)
                main.Position = UDim2.new(ps.X.Scale, ps.X.Offset + (w - sz.X.Offset) / 2,
                    ps.Y.Scale, ps.Y.Offset + (h - sz.Y.Offset) / 2)
            end)
        end)
        local overlay = new("Frame", {
            Name = "Overlay", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 100,
        }, holder)
        self.Overlay = overlay
        local catcher = new("TextButton", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
            Visible = false, ZIndex = 1,
        }, overlay)
        catcher.Activated:Connect(function() self:_closePopup() end)
        self.Catcher = catcher
        local tip = new("Frame", {
            Visible = false, Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BorderSizePixel = 0, ZIndex = 10,
        }, overlay)
        self:_bind(tip, "BackgroundColor3", "Surface")
        round(tip, 6)
        local tipStroke = new("UIStroke", {Thickness = 1}, tip)
        self:_bind(tipStroke, "Color", "Stroke")
        padding(tip, 8, 6, 8, 6)
        local tipLabel = new("TextLabel", {
            Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Text = "",
            RichText = true, TextWrapped = true, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 11,
        }, tip)
        new("UISizeConstraint", {MaxSize = Vector2.new(220, 400)}, tipLabel)
        self:_bind(tipLabel, "TextColor3", "Text")
        self._tipFrame, self._tipLabel = tip, tipLabel
        if o.ToggleButton ~= false then
            local tb = new("TextButton", {
                Name = "ToggleBtn", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 56),
                Size = UDim2.fromOffset(40, 40), Text = "", AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 2,
            }, holder)
            self:_bind(tb, "BackgroundColor3", "Topbar")
            round(tb, 20)
            local tbs = new("UIStroke", {Thickness = 1.5}, tb)
            self:_bind(tbs, "Color", "Accent")
            
            -- ĐÃ XÓA DÒNG ÉP MÀU VÀNG ĐỂ ẢNH HIỂN THỊ ĐÚNG MÀU GỐC
            local dia = new("ImageLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(26, 26),
                BackgroundTransparency = 1, Image = "rbxthumb://type=Asset&id=109784820389254&w=420&h=420", ScaleType = Enum.ScaleType.Fit
            }, tb)

            tb.InputBegan:Connect(function(input)
                if not isPointer(input) then return end
                local sp, si, moved = tb.Position, input.Position, false
                trackDrag(input, function(p)
                    local d = p - si
                    if d.Magnitude > 8 then moved = true end
                    if moved then
                        local dd = d / self.Scale
                        tb.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dd.X, sp.Y.Scale, sp.Y.Offset + dd.Y)
                    end
                end, function()
                    if not moved then self:Toggle() end
                end)
            end)
            self._toggleBtn = tb
        end
        table.insert(self._keybinds, {
            down = function(code)
                if code == self.ToggleKey then self:Toggle() end
            end,
        })
        if o.Scale then self:SetScale(o.Scale) end
        table.insert(Lib.Windows, self)
        return self
    end
    return Lib
end)()
local UI = DiamondUI
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local genv = (getgenv and getgenv()) or _G
local runId = os.clock()
genv.cm_run = runId
local function alive() return genv.cm_run == runId end
local SCRIPT_URL = "https://raw.githubusercontent.com/ricelp8-coder/diamondHub/main/script"
local AE = {queued = false, file = "CameramanTD/_autoexec.txt"}
AE.hasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
function AE.get()
    if not AE.hasFS then return genv.cm_ae_flag == true end
    local ok, v = pcall(function() return isfile(AE.file) and readfile(AE.file) or "" end)
    return ok and v == "1"
end
function AE.set(on)
    genv.cm_ae_flag = on and true or false
    if not AE.hasFS then return end
    pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("CameramanTD") then
            makefolder("CameramanTD")
        end
        writefile(AE.file, on and "1" or "0")
    end)
end
function AE.code()
    if SCRIPT_URL == "" then return nil, "SCRIPT_URL is empty" end
    local load = ("loadstring(game:HttpGet(%q))()"):format(SCRIPT_URL)
    return "if not game:IsLoaded() then game.Loaded:Wait() end "
        .. ("local ok, v = pcall(function() return isfile and isfile(%q) and readfile(%q) end) "):format(AE.file, AE.file)
        .. "if not ok or v ~= '1' then return end getgenv().cm_ae = true " .. load
end
function AE.queue()
    local q = (type(queue_on_teleport) == "function" and queue_on_teleport)
        or (type(syn) == "table" and type(syn.queue_on_teleport) == "function" and syn.queue_on_teleport)
        or (type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" and fluxus.queue_on_teleport)
    if not q then return false, "no queue_on_teleport in this executor" end
    if AE.queued then return true end
    local code, why = AE.code()
    if not code then return false, why end
    if not pcall(q, code) then return false, "queue_on_teleport failed" end
    AE.queued = true
    return true
end
local MODES = {"Easy", "Normal", "Hard", "Insane", "Nightmare"}
local SPEEDS = {1, 1.5, 2}
local function parseBarriers(txt)
    local set, list = {}, {}
    for num in tostring(txt or ""):gmatch("%d+") do
        local n = tonumber(num)
        if n and n > 0 and n <= 9999 and not set[n] then
            set[n] = true
            list[#list + 1] = n
        end
    end
    table.sort(list)
    return set, list
end
local function parseWave(txt)
    local n = tonumber(tostring(txt or ""):match("%d+"))
    if n and n > 0 and n <= 9999 then return n end
    return 0
end
local FARMS = {
    ["pumpkin farmer"] = true,
    ["scientist cameraman"] = true,
    ["popcorn cameraman"] = true,
}
local TARGETS = {"First", "Last", "Closest", "Strong", "Weak"}
local MAX_UNITS = 15
local UNIT_LIMITS = {
    ["scientist cameraman"] = 4,
    ["titan cameraman"] = 8,
}
local cfg = {
    autoSkip = false,
    autoVote = false,
    autoSpeed = false,
    autoPlayAgain = false,
    autoLeave = false,
    autoExecute = false,
    mode = "Insane",
    speed = 2,
    skipDelay = 0.1,
    skipRepeat = 1.0,
    skipBarriers = {},
    sellFarmWave = 0,
    placeAnywhere = false,
    playAgainDelay = 0.25,
    leaveDelay = 0.5,
    autoModifier = false,
    modHp = false,
    modSpeed = false,
    autoSummon1 = false,
    autoSummon10 = false,
    summonDelay = 0.15,
    autoTeleport = false,
    autoClaimQuests = false,
    autoClaimHalloween = false,
    hideName = false,
    hideUser = false,
    fpsBoost = false,
    autoBuyCrate = false,
    buyCrateAmount = 1,
    autoOpenCrate = false,
    openCrateName = "Exclusive Halloween Crate",
    openCrateAmount = 1,
    crateDelay = 2,
    teleportMap = "Cameraman HQ",
    language = "English",
}
local st = {
    farms = {},
    waveOn = false, cleared = false, nextSkip = 0, curSpeed = nil,
    inVote = false, voted = false, finalShown = false,
    matchStart = nil, matchMode = nil,
}
local R = {}
local mc = {
    ok = false, hook = false,
    rec = false, play = false, playing = false, running = false,
    replay = "Money", selected = nil,
    wave = 0, matchId = 0, ranMatch = nil, stepNo = 0,
    steps = {},
    queue = {},
    stamps = {TowerAdd = {}, TowerUpgrade = {}, TowerSell = {}, TowerTarget = {}},
    id2key = {}, id2raw = {}, k2id = {}, selfSell = {}, keyN = 0, hookBeat = 0, hookMiss = false,
    id2pos = {}, id2mode = {},
    waitPlace = nil, waitPlaceOk = false, placeFail = nil, upFail = false, upAck = {},
    initDone = false, finalSeen = false,
    id2name = {}, limits = {}, learned = false,
    settle = {}, ackSeen = false,
    id2lvl = {}, book = {}, mlog = {}, id2at = {},
}
local ctx = {mc = mc, R = R, st = st, mv = nil}
genv.cm_cur = ctx
local MAC = UI.MakeStore("CameramanTD/Macros", "cm_mac_mem")
local sanitize = UI.Sanitize
local Win
local recToggle, playToggle, macroDD, nameInput, macroStatus
local tgPlayAgain, tgLeave, finishRecording
local function flash(t, kind)
    UI:Notify({Title = "BeeZ Hub", Content = t, Duration = 2.5, Type = kind or "Info"})
end
local function money()
    local mv = ctx.mv
    return mv and mv.Value or 0
end
local GC = {clock = 0, at = os.clock(), speed = 1}
local function gameSpeed()
    local v = tonumber(workspace:GetAttribute("GameSpeed"))
    if v and v > 0 then return v end
    return tonumber(st.curSpeed) or 1
end
GC.speed = gameSpeed()
local function gameClock()
    local now = os.clock()
    GC.clock = GC.clock + math.max(0, now - GC.at) * GC.speed
    GC.at = now
    GC.speed = gameSpeed()
    return GC.clock
end
pcall(function()
    workspace:GetAttributeChangedSignal("GameSpeed"):Connect(function()
        if not alive() then return end
        gameClock()
    end)
end)
local function setSpeed(s)
    if not R.ChangeSpeed then return end
    task.spawn(function()
        local ok, res = pcall(function() return R.ChangeSpeed:InvokeServer(s) end)
        warn("[cm] ChangeSpeed(" .. tostring(s) .. ") -> " .. tostring(ok) .. " " .. tostring(res))
    end)
end
local function ensureSpeed()
    if not (cfg.autoSpeed and R.ChangeSpeed) then return end
    local target = tonumber(cfg.speed)
    if not target or st.curSpeed == target then return end
    if os.clock() - (st.speedLast or 0) < 3 then return end
    if (st.speedTries or 0) >= 3 then
        if not st.speedGaveUp then
            st.speedGaveUp = true
            flash("Auto Speed: no confirmation from the server, stopped retrying", "Warning")
        end
        return
    end
    st.speedTries = (st.speedTries or 0) + 1
    st.speedLast = os.clock()
    setSpeed(target)
end
local function fireLeave()
    local r = R.OnLeave
    if not r then
        flash("Auto Leave Lobby: OnLeave remote not found", "Error")
        return
    end
    if r:IsA("RemoteFunction") then
        task.spawn(function() pcall(function() r:InvokeServer() end) end)
    else
        r:FireServer()
    end
end
local function visible(o)
    while o and o ~= game do
        if o:IsA("LayerCollector") and not o.Enabled then return false end
        if o:IsA("GuiObject") and not o.Visible then return false end
        o = o.Parent
    end
    return true
end
local uiCache, uiMiss, uiDeep = {}, {}, {}
local function findUI(name)
    local o = uiCache[name]
    if o and o.Parent ~= nil and o:IsDescendantOf(pg) then return o end
    local now = os.clock()
    if uiMiss[name] and now - uiMiss[name] < 0.5 then return nil end
    local gui = pg:FindFirstChild("GameUI")
    o = gui and gui:FindFirstChild(name)
    if not o and now - (uiDeep[name] or -100) > 10 then
        uiDeep[name] = now
        o = pg:FindFirstChild(name, true)
    end
    uiCache[name] = o
    uiMiss[name] = (o == nil) and now or nil
    return o
end
local function votingOpen()
    local gv = findUI("GamemodeVoting")
    if not gv then return false end
    return visible(gv:FindFirstChild("MainFrame") or gv)
end
local function finalOpen()
    local f = findUI("FinalUI")
    return f ~= nil and visible(f)
end
local MAP_ELEVATORS = {
    ["Cameraman HQ"] = "Elevator11",
    ["Toilet City"] = "Elevator3",
    ["Desert"] = "Elevator8",
}
local MAP_LIST = {"Cameraman HQ", "Toilet City", "Desert"}
local MAP_PADS = {
    ["Cameraman HQ"] = Vector3.new(743.91, 308.39, 547.30),
    ["Toilet City"] = Vector3.new(743.86, 308.47, 588.13),
    ["Desert"] = Vector3.new(741.92, 308.42, 726.83),
}
local LB = {R = {}, elev = nil, teleporting = false, tpNext = 0, sumBusyUntil = 0, lastSummon = 0}
function LB.noFunds(msg)
    local low = tostring(msg):lower()
    if low:find("player", 1, true) then return false end
    return low:find("enough", 1, true) ~= nil or low:find("afford", 1, true) ~= nil
        or low:find("insufficient", 1, true) ~= nil
end
function LB.stopSummon()
    if not (cfg.autoSummon1 or cfg.autoSummon10) then return end
    cfg.autoSummon1, cfg.autoSummon10 = false, false
    if LB.tg1 then LB.tg1:Set(false, true) end
    if LB.tg10 then LB.tg10:Set(false, true) end
    flash("Auto Summon stopped: not enough money", "Warning")
end
function LB.moveToPad(pos)
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(pos)
    return true
end
function LB.inMatch()
    return st.inVote or mc.wave > 0 or finalOpen()
end
function LB.send(r, ...)
    if r:IsA("RemoteFunction") then
        local args = table.pack(...)
        task.spawn(function() pcall(r.InvokeServer, r, table.unpack(args, 1, args.n)) end)
    else
        pcall(r.FireServer, r, ...)
    end
end
function LB.summon(n)
    local r = LB.R.SummonTowers
    if not r then return end
    LB.lastSummon = os.clock()
    if r:IsA("RemoteFunction") then
        if os.clock() < LB.sumBusyUntil then return end
        LB.sumBusyUntil = os.clock() + 3
        task.spawn(function()
            local ok, a, b = pcall(r.InvokeServer, r, "Basic Crate", n)
            LB.sumBusyUntil = 0
            if ok then
                for _, v in ipairs({a, b}) do
                    if type(v) == "string" and LB.noFunds(v) then LB.stopSummon() end
                end
            end
        end)
    else
        pcall(r.FireServer, r, "Basic Crate", n)
    end
end
function LB.wantedMods()
    local list = {}
    if cfg.modHp then list[#list + 1] = "Hp_Mobs" end
    if cfg.modSpeed then list[#list + 1] = "Speed_Mobs" end
    return list
end
LB.elevMods, LB.modStarted, LB.modFinished = {}, nil, nil
local function hasAll(list, names)
    if type(list) ~= "table" then return false end
    local have = {}
    for _, v in pairs(list) do have[v] = true end
  for _, nm in ipairs(names) do
  if not have[nm] then return false end
  end
  local count = 0
  for _ in pairs(have) do count = count + 1 end
  return count == #names
  end
function LB.selectModifier(id)
    local r = LB.R.ElevatorSetModifiers
    if not r then return false end
    local names = LB.wantedMods()
    if #names == 0 then return true end
    local t0 = os.clock()
    while alive() and LB.elevMods[id] == nil and os.clock() - t0 < 1 do task.wait(0.05) end
    for _ = 1, 3 do
        if not (alive() and cfg.autoModifier and LB.elev == id) then return false end
        if hasAll(LB.elevMods[id], names) then return true end
        local list = {}
        for i, nm in ipairs(names) do list[i] = nm end
        LB.send(r, id, list)
        local t1 = os.clock()
        while alive() and os.clock() - t1 < 1 do
            if hasAll(LB.elevMods[id], names) then return true end
            task.wait(0.05)
        end
    end
    if hasAll(LB.elevMods[id], names) then return true end
    flash("Auto Modifier: no confirmation from the server", "Warning")
    return false
end
function LB.runModifier(id)
    LB.modStarted, LB.modFinished = id, nil
    task.spawn(function()
        LB.selectModifier(id)
        if LB.modStarted == id then LB.modFinished = id end
    end)
end
function LB.teleport()
    local id = MAP_ELEVATORS[cfg.teleportMap]
    local enter, start = LB.R.ElevatorEnter, LB.R.ElevatorStart
    if not (id and enter and start) then return 5 end
    if LB.elev ~= id then
        LB.elev, LB.modStarted, LB.modFinished = nil, nil, nil
        local pad = MAP_PADS[cfg.teleportMap]
        if pad then
            if not LB.moveToPad(pad) then return 2 end
            task.wait(0.25)
        end
        LB.send(enter, id)
        local t0 = os.clock()
        while alive() and cfg.autoTeleport and LB.elev ~= id and os.clock() - t0 < 4 do task.wait(0.05) end
        if LB.elev ~= id then return 1.5 end
    end
    if cfg.autoModifier and LB.R.ElevatorSetModifiers then
        if LB.modStarted ~= id then LB.runModifier(id) end
        local t1 = os.clock()
        while alive() and LB.modFinished ~= id and os.clock() - t1 < 3 do task.wait(0.05) end
    end
    local firstPress, presses, nextPress = nil, 0, 0
    local function answered() return firstPress ~= nil and LB.tpEventAt ~= nil and LB.tpEventAt >= firstPress end
    local t2 = os.clock()
    while alive() and cfg.autoTeleport and not answered() and os.clock() - t2 < 15 do
        if LB.elev ~= id then return 0.5 end
        if os.clock() >= nextPress then
            if presses >= 5 then
                LB.elev = nil
                return 0.5
            end
            firstPress = firstPress or os.clock()
            LB.send(start, id)
            presses = presses + 1
            nextPress = os.clock() + 0.8
        end
        task.wait(0.05)
    end
    if answered() then
        local t3 = os.clock()
        while alive() and os.clock() - t3 < 12 do task.wait(0.25) end
    end
    return 1
end
local INV = {
    replica = nil, scanAt = 0, gcAt = -100, sharedBusy = false, gcBusy = false,
    sold = nil, sellName = nil, sellLabels = {}, sellSig = "", refreshing = false,
    cratePend = nil, nextCrate = 0, crateSig = "", w = {},
}
function INV.path(root, path)
    local o = root
    for part in tostring(path):gmatch("[^/]+") do
        o = o and o:FindFirstChild(part)
    end
    return o
end
local function ownReplica(r)
    if type(r) ~= "table" then return false end
    local tags, data = rawget(r, "Tags"), rawget(r, "Data")
    if type(tags) ~= "table" or type(data) ~= "table" then return false end
    local uid = rawget(tags, "UserId") or rawget(tags, 1)
    return tonumber(uid) == lp.UserId and type(rawget(data, "Towers")) == "table"
end
function INV.scan()
    local found
    pcall(function()
        local rc = require(RS.ModuleLoader.Libs.ReplicaClient)
        for rep in pairs(rc.Test().TokenReplicas.Replication) do
            if ownReplica(rep) then
                found = rep
                break
            end
        end
    end)
    if found then
        INV.replica = found
        return
    end
    if not INV.sharedBusy then
        INV.sharedBusy = true
        task.spawn(function()
            local ok, rep = pcall(function() return shared.Modules.Replication.GetCurrentReplica() end)
            INV.sharedBusy = false
            if ok and ownReplica(rep) then INV.replica = rep end
        end)
    end
    if not INV.gcBusy and type(getgc) == "function" and os.clock() - INV.gcAt > 20 then
        INV.gcBusy, INV.gcAt = true, os.clock()
        task.spawn(function()
            local ok, list = pcall(getgc, true)
            if ok and type(list) == "table" then
                local t0 = os.clock()
                for i = 1, #list do
                    local v = list[i]
                    if type(v) == "table" and ownReplica(v) then
                        INV.replica = v
                        break
                    end
                    if os.clock() - t0 >= 0.002 then
                        task.wait()
                        t0 = os.clock()
                        if not alive() then break end
                    end
                end
            end
            INV.gcBusy = false
        end)
    end
end
function INV.get()
    local r = INV.replica
    if r then
        local d = rawget(r, "Data")
        local ok, active = pcall(function() return r:IsActive() end)
        if type(d) == "table" and (not ok or active) then return d end
        INV.replica = nil
    end
    if os.clock() < INV.scanAt then return nil end
    INV.scanAt = os.clock() + 2
    INV.scan()
    local d = INV.replica and rawget(INV.replica, "Data")
    return type(d) == "table" and d or nil
end

function INV.options()
    local data = INV.get()
    local counts, names = {}, {}
    for _, t in pairs((data and data.Towers) or {}) do
        if type(t) == "table" and type(t.Name) == "string" then
            if not counts[t.Name] then names[#names + 1] = t.Name end
            counts[t.Name] = (counts[t.Name] or 0) + 1
        end
    end
    table.sort(names)
    local list, byLabel = {"(select a unit)"}, {}
    for _, n in ipairs(names) do
        local label = "(x" .. counts[n] .. ") " .. n
        list[#list + 1] = label
        byLabel[label] = n
    end
    return list, byLabel, data ~= nil
end
function INV.sellPlan(name, mode)
    local data = INV.get()
    if not (data and type(data.Towers) == "table") then return nil, "Waiting for your inventory" end
    if type(name) ~= "string" or name == "" then return nil, "Select a unit first" end
    local ids, total = {}, 0
    for id, t in pairs(data.Towers) do
        if type(id) == "string" and type(t) == "table" and t.Name == name then
            total = total + 1
            if t.Equipped ~= true and (tonumber(t.Equipped) or 0) < 1 and t.Locked ~= true then
                ids[#ids + 1] = id
            end
        end
    end
    table.sort(ids)
    local want
    if mode == "All" then
        want = #ids
    elseif mode == "One" then
        want = math.min(#ids, 1)
    elseif mode == "KeepOne" then
        want = math.min(#ids, math.max(0, total - 1))
    else
        return nil, "Unknown sell mode"
    end
    while #ids > want do ids[#ids] = nil end
    return ids, nil, total
end
function INV.refreshSell(force)
    local list, byLabel, have = INV.options()
    INV.sellLabels = byLabel
    local label
    for l, n in pairs(byLabel) do
        if n == INV.sellName then label = l end
    end
    if INV.sellName and not label and have then INV.sellName = nil end
    local sig = table.concat(list, "\0")
    if INV.w.sellSel and (force or sig ~= INV.sellSig) then
        INV.sellSig = sig
        INV.refreshing = true
        pcall(function()
            INV.w.sellSel:SetOptions(list)
            INV.w.sellSel:Set(label or list[1], true)
        end)
        INV.refreshing = false
    end
    if INV.w.sellInfo then
        local text
        if not have then
            text = "Waiting for your inventory data..."
        elseif INV.sellName then
            local ids, _, total = INV.sellPlan(INV.sellName, "All")
            text = INV.sellName .. ": " .. tostring(total or 0) .. " copies, " .. tostring(ids and #ids or 0)
                .. " sellable (equipped and locked are skipped)"
        else
            text = "Select a unit, then choose an action. Equipped and locked copies are skipped."
        end
        INV.w.sellInfo:SetContent(text)
    end
end
function INV.checkSale()
    local p = INV.sold
    if not p then return end
    local data = INV.get()
    if not (data and type(data.Towers) == "table") then return end
    for _, id in ipairs(p.ids) do
        if data.Towers[id] ~= nil then
            if os.clock() - p.at > 20 and not p.warned then
                p.warned = true
                flash("Inventory: sale is not confirmed yet", "Warning")
            end
            return
        end
    end
    INV.sold = nil
    flash("Sold " .. #p.ids .. " " .. p.name .. " (confirmed)", "Success")
end
function INV.sell(mode)
    INV.checkSale()
    if INV.sold then
        flash("Inventory: waiting for the previous sale to confirm", "Warning")
        return
    end
    local r = LB.R.SellPart
    if not r then
        flash("Inventory: SellPart remote not found (lobby only)", "Error")
        return
    end
    local ids, why = INV.sellPlan(INV.sellName, mode)
    if not ids or #ids == 0 then
        flash(why or "Inventory: no sellable copies for this action", "Warning")
        return
    end
    INV.sold = {ids = ids, name = INV.sellName, at = os.clock()}
    LB.send(r, ids)
    flash("Selling " .. #ids .. " " .. INV.sellName, "Info")
end

function INV.setCrate(text)
    if INV.w.crateInfo then INV.w.crateInfo:SetContent(text) end
end
function INV.crateHud()
    local candy, towers, space
    local cl = INV.path(pg, "HUD/Currencies/Candy/CurrencyFrame/AmountLabel")
    if cl then candy = tonumber(tostring(cl.Text):gsub(",", ""):match("^%s*(%d+)%s*$")) end
    local ul = INV.path(pg, "Main/Main/Inventory/InventoryFrame/TopButtons/UnitLimit/UnitAmount")
    if ul then
        local a, b = tostring(ul.Text):gsub(",", ""):match("(%d+)%s*/%s*(%d+)")
        towers, space = tonumber(a), tonumber(b)
    end
    return candy, towers, space
end
function INV.crateInv(name)
    local data = INV.get()
    if not (data and type(data.Items) == "table") then return nil end
    local ids, owned = {}, 0
    for id, it in pairs(data.Items) do
        if type(id) == "string" and type(it) == "table" and it.Type == "Crate" and it.Name == name then
            ids[#ids + 1] = id
        end
    end
    for _ in pairs(data.Towers or {}) do owned = owned + 1 end
    table.sort(ids)
    local candy, hudOwned, hudSpace = INV.crateHud()
    return {
        ids = ids, count = #ids, towers = hudOwned or owned,
        space = hudSpace or tonumber(data.InventorySpace), candy = candy or tonumber(data.Candy),
    }
end
INV.NO_CRATES = "No crates in inventory"
function INV.crateOptions()
    local set = {}
    local data = INV.get()
    for _, it in pairs((data and data.Items) or {}) do
        if type(it) == "table" and it.Type == "Crate" and type(it.Name) == "string" then set[it.Name] = true end
    end
    local list = {}
    for n in pairs(set) do list[#list + 1] = n end
    table.sort(list)
    if #list == 0 then list[1] = INV.NO_CRATES end
    return list
end
function INV.refreshCrates(force)
    local sel = INV.w.crateSel
    if not sel then return end
    local list = INV.crateOptions()
    local sig = table.concat(list, "|")
    if force or sig ~= INV.crateSig then
        INV.crateSig = sig
        local chosen = INV.NO_CRATES
        for _, n in ipairs(list) do
            if n == cfg.openCrateName then chosen = n break end
        end
        if chosen == INV.NO_CRATES and list[1] ~= INV.NO_CRATES then chosen = list[1] end
        if chosen ~= INV.NO_CRATES then cfg.openCrateName = chosen end
        pcall(function()
            sel:SetOptions(list)
            sel:Set(chosen, true)
        end)
    end
end
function INV.cratePrice(n)
    local lbl = INV.path(pg, "Main/Main/Battlepass/BattlepassFrame/Shop/List/ScrollingFrame/Exclusive Halloween Crate/CrateInfo/BuyCrates/" .. n .. "/Price")
    local txt = lbl and tostring(lbl.Text) or ""
    if txt:match("^%s*$") then return ({[1] = 500, [3] = 1500, [10] = 5000})[n] end
    if not txt:lower():find("cand", 1, true) then return nil end
    local v = tonumber(txt:gsub(",", ""):match("%d+"))
    return (v and v > 0) and v or nil
end
function INV.crateRequest(kind, a, amount)
    local r = (kind == "Open") and LB.R.OpenCrate or LB.R.BuyCrate
    if not r then return false, (kind == "Open" and "OpenCrate" or "BuyCrate") .. " remote not found" end
    if r:IsA("RemoteFunction") then return pcall(r.InvokeServer, r, a, amount) end
    return pcall(r.FireServer, r, a, amount)
end
function INV.crateStep()
    local now = os.clock()
    local p = INV.cratePend
    if p then
        local inv = INV.crateInv(p.name)
        if not inv then
            INV.setCrate("Waiting for your crate inventory")
            return
        end
        local done
        if p.kind == "Buy" then
            done = inv.count >= p.count + p.amount and inv.candy ~= nil and inv.candy <= p.candy - p.price
        else
            done = inv.count <= p.count - p.amount
        end
        if done then
            INV.cratePend = nil
            INV.nextCrate = now + cfg.crateDelay
            INV.setCrate(p.kind .. " confirmed: " .. p.amount .. " " .. p.name)
        elseif now - p.at >= 45 then
            INV.cratePend = nil
            INV.nextCrate = now + cfg.crateDelay
            INV.setCrate(p.kind .. " was not confirmed in 45s, continuing")
        else
            if now - p.at >= 15 and not p.warned then
                p.warned = true
                INV.setCrate("Waiting for inventory confirmation, the request is not repeated")
            end
            return
        end
    end
    if now < INV.nextCrate then return end
    local kind, name, amount, inv, price, note
    if cfg.autoOpenCrate then
        name = cfg.openCrateName
        inv = INV.crateInv(name)
        if inv and inv.count > 0 and inv.space and inv.towers < inv.space then
            amount = (cfg.openCrateAmount == 10 and inv.count >= 10 and inv.space - inv.towers >= 10) and 10 or 1
            kind = "Open"
        elseif inv and inv.count > 0 and inv.space then
            note = "Tower inventory full: " .. inv.towers .. "/" .. inv.space
        end
    end
    if not kind and cfg.autoBuyCrate then
        name, amount = "Exclusive Halloween Crate", cfg.buyCrateAmount
        inv = INV.crateInv(name)
        price = INV.cratePrice(amount)
        if inv and price and inv.candy and inv.candy >= price then
            kind = "Buy"
        elseif inv and price and inv.candy then
            note = "Need " .. price .. " Candy | Available: " .. inv.candy
        end
    end
    if not kind then
        INV.setCrate(note or "Waiting for an available crate")
        return
    end
    INV.cratePend = {
        kind = kind, name = name, amount = amount, count = inv.count, candy = inv.candy or 0,
        price = price or 0, at = now,
    }
    INV.nextCrate = now + math.max(2, cfg.crateDelay)
    local ok, res = INV.crateRequest(kind, kind == "Buy" and name or inv.ids[1], amount)
    INV.cratePend.warned = (not ok) or res == false
    INV.setCrate(INV.cratePend.warned
        and (kind .. " request failed: " .. tostring(res):sub(1, 120))
        or (kind .. " sent, waiting for inventory confirmation"))
end
function INV.loop()
    task.spawn(function()
        local n = 0
        while alive() do
            task.wait(1)
            n = n + 1
            pcall(INV.checkSale)
            if n % 2 == 0 then
                pcall(INV.refreshSell)
                pcall(INV.refreshCrates)
            end
            if (cfg.autoBuyCrate or cfg.autoOpenCrate or INV.cratePend) and not LB.inMatch() then
                local ok, err = pcall(INV.crateStep)
                if not ok then INV.setCrate("Crate error: " .. tostring(err):sub(1, 100)) end
            end
        end
    end)
end

local function questDone(q)
    if type(q) ~= "table" or q.RewardClaimed == true then return false end
    local cur, goal = tonumber(q.CurrentProgress), tonumber(q.Progress)
    return q.Completed == true or q.State == "Completed" or (cur ~= nil and goal ~= nil and goal > 0 and cur >= goal)
end
LB.claims, LB.claimNext = {}, 0
function LB.questClaim(key, r, ...)
    local state = LB.claims[key]
    if state == true or (type(state) == "number" and os.clock() < state) then return false end
    if os.clock() < LB.claimNext then return false end
    LB.claimNext = os.clock() + 2
    if r:IsA("RemoteFunction") then
        local ok = pcall(r.InvokeServer, r, ...)
        LB.claims[key] = ok and true or (os.clock() + 30)
    else
        pcall(r.FireServer, r, ...)
        LB.claims[key] = os.clock() + 60
    end
    LB.claimNext = os.clock() + 2
    return true
end
local BP_ROOT = "Main/Main/Battlepass/BattlepassFrame/EventPass/"
function LB.tierClaimed(bp, tier, premium)
    local group = type(bp.ClaimedTiers) == "table" and bp.ClaimedTiers[premium and "Premium" or "Default"]
    if type(group) ~= "table" then return nil end
    if group[tier] == true or group[tostring(tier)] == true then return true end
    for _, v in pairs(group) do
        if type(v) ~= "boolean" and tonumber(v) == tier then return true end
    end
    local price = INV.path(pg, BP_ROOT .. "List/ScrollingFrame/Tier_" .. tier .. "/Holder/"
        .. (premium and "Premium" or "Free") .. "/TroopFrame/TroopsFrame/Price")
    if price and tostring(price.Text):lower() == "claimed" then return true end
    return false
end
function LB.tierAvailable(bp, tier, premium)
    local cur = tonumber(bp.CurrentTier) or 0
    if premium then return bp.Premium == true and tier <= cur end
    if tier <= cur then return true end
    if tier ~= (tonumber(bp.NextTier) or (cur + 1)) then return false end
    local frame = INV.path(pg, BP_ROOT .. "List/ScrollingFrame/Tier_" .. tier .. "/Holder/Free/TroopFrame/TroopsFrame")
    local priceLabel = frame and frame:FindFirstChild("Price")
    local priceText = priceLabel and tostring(priceLabel.Text):lower() or ""
    if priceText:find("claimed", 1, true) or priceText:find("away", 1, true) then return false end
    local button = frame and frame:FindFirstChild("ClaimButton")
    if button and button.Visible then return true end
    local info = INV.path(pg, BP_ROOT .. "Info/CurrentTier")
    local nextLabel = info and info:FindFirstChild("NextTier")
    local xpLabel = info and info:FindFirstChild("XP")
    local nextTier = nextLabel and tonumber(tostring(nextLabel.Text):match("%d+"))
    local need = xpLabel and tonumber((tostring(xpLabel.Text):gsub(",", "")):match("/%s*(%d+)%s*XP"))
    return nextTier == tier and need ~= nil and need > 0 and (tonumber(bp.EXP) or 0) >= need
end
function LB.claimTiers(bp)
    local rt = LB.R.ClaimTier
    local cur = tonumber(bp.CurrentTier)
    if not (rt and cur) then return end
    local top = math.min(500, math.max(cur, tonumber(bp.NextTier) or (cur + 1)))
    local pq = type(bp.PassQuests) == "table" and bp.PassQuests or nil
    local stamp = tostring(pq and pq.LastUpdate or 0)
    for tier = 1, top do
        for pass = 1, 2 do
            local premium = pass == 2
            local key = stamp .. "/Tier/" .. tier .. "/" .. tostring(premium)
            if LB.claims[key] ~= true and LB.tierAvailable(bp, tier, premium)
                and LB.tierClaimed(bp, tier, premium) == false then
                if LB.questClaim(key, rt, tier, premium) then return end
            end
        end
    end
end
function LB.guiQuests()
    local out = {}
    local list = INV.path(pg, "Main/Main/Quests/QuestsFrame/AllQuests/List")
    if not list then return out end
    for _, row in ipairs(list:GetChildren()) do
        if row.Name ~= "Template" then
            local amt = INV.path(row, "Progress/AmountDone")
            local btn = INV.path(row, "Progress/ClaimButton")
            local claimed = INV.path(row, "Progress/ClaimedText")
            local a, b
            if amt then a, b = tostring(amt.Text):match("(%d+)%s*/%s*(%d+)") end
            if a and tonumber(b) > 0 and tonumber(a) >= tonumber(b) and btn and btn.Visible
                and not (claimed and claimed.Visible) then
                out[#out + 1] = row.Name
            end
        end
    end
    table.sort(out)
    return out
end
function LB.claimQuests()
    if LB.questBusy then return end
    if not (cfg.autoClaimQuests or cfg.autoClaimHalloween) then return end
    if LB.inMatch() or LB.teleporting then return end
    LB.questBusy = true
    local ok, err = pcall(function()
        local data = INV.get()
        local rq = LB.R.CollectQuest
        if cfg.autoClaimQuests and rq then
            local active = data and data.ActiveQuests
            if type(active) == "table" then
                for kind, group in pairs(active) do
                    if type(kind) == "string" and type(group) == "table" and type(group.Quests) == "table" then
                        local stamp = tostring(group.LastUpdate or 0)
                        for _, q in pairs(group.Quests) do
                            if not cfg.autoClaimQuests then break end
                            if questDone(q) and type(q.Id) == "string" then
                                LB.questClaim(stamp .. "/" .. kind .. "/" .. q.Id, rq, q.Id, kind)
                            end
                        end
                    end
                end
            elseif not data then
                for _, id in ipairs(LB.guiQuests()) do
                    if not cfg.autoClaimQuests then break end
                    LB.questClaim("GUI/Daily/" .. id, rq, id, "Daily")
                end
            end
        end
        local rp = LB.R.CollectPassQuest
        local bp = data and type(data.Battlepass) == "table" and data.Battlepass or nil
        if cfg.autoClaimHalloween and bp then
            local pq = bp.PassQuests
            if rp and type(pq) == "table" and type(pq.Quests) == "table" then
                local stamp, ids = tostring(pq.LastUpdate or 0), {}
                for _, q in pairs(pq.Quests) do
                    if questDone(q) and type(q.Id) == "string" then ids[#ids + 1] = q.Id end
                end
                table.sort(ids)
                for _, id in ipairs(ids) do
                    if not cfg.autoClaimHalloween then break end
                    LB.questClaim(stamp .. "/Pass/" .. id, rp, id)
                end
            end
            if cfg.autoClaimHalloween then LB.claimTiers(bp) end
        end
    end)
    LB.questBusy = false
    if not ok then warn("[cm] quests: " .. tostring(err)) end
end
function LB.init(ev, fn)
    local wanted = {SummonTowers = true, ElevatorEnter = true, ElevatorStart = true, ElevatorEntered = true,
        ElevatorTeleporting = true, ElevatorSetModifiers = true, ElevatorModifiersUpdated = true,
        CollectQuest = true, CollectPassQuest = true, ClaimTier = true, SendPassQuestData = true,
        SellPart = true, BuyCrate = true, OpenCrate = true}
    local function adopt(r)
        if not wanted[r.Name] or LB.R[r.Name] then return end
        LB.R[r.Name] = r
        if not r:IsA("RemoteEvent") then return end
        if r.Name == "ElevatorEntered" then
            r.OnClientEvent:Connect(function(name, ok)
                if ok then
                    LB.elev = name
                    LB.elevMods[name] = nil
                    if cfg.autoModifier and LB.modStarted ~= name then LB.runModifier(name) end
                elseif LB.elev == name then
                    LB.elev = nil
                    LB.elevMods[name] = nil
                    if LB.modStarted == name then LB.modStarted, LB.modFinished = nil, nil end
                end
            end)
        elseif r.Name == "ElevatorModifiersUpdated" then
            r.OnClientEvent:Connect(function(name, list)
                LB.elevMods[name] = type(list) == "table" and list or {}
            end)
        elseif r.Name == "SendPassQuestData" then
            r.OnClientEvent:Connect(function()
                if cfg.autoClaimQuests or cfg.autoClaimHalloween then task.delay(0.5, LB.claimQuests) end
            end)
        elseif r.Name == "ElevatorTeleporting" then
            r.OnClientEvent:Connect(function()
                LB.teleporting = true
                LB.tpEventAt = os.clock()
                LB.modStarted, LB.modFinished = nil, nil
            end)
        end
    end
    for _, folder in ipairs({ev, fn}) do
        for _, r in ipairs(folder:GetChildren()) do adopt(r) end
        folder.ChildAdded:Connect(adopt)
    end
    LB.tpNext = os.clock() + 4
    INV.loop()
    task.spawn(function()
        while alive() do
            task.wait(1)
            if cfg.autoClaimQuests or cfg.autoClaimHalloween then pcall(LB.claimQuests) end
        end
    end)
    task.spawn(function()
        while alive() do
            task.wait(math.max(cfg.summonDelay, 0.05))
            if (cfg.autoSummon1 or cfg.autoSummon10) and not LB.inMatch() then
                LB.summon(cfg.autoSummon10 and 10 or 1)
            end
        end
    end)
    task.spawn(function()
        while alive() do
            task.wait(0.5)
            if cfg.autoTeleport and os.clock() >= LB.tpNext and not LB.inMatch() then
                local ok, delay = pcall(LB.teleport)
                LB.tpNext = os.clock() + ((ok and delay) or 3)
            end
        end
    end)
end
local function v2a(v) return {v.X, v.Y, v.Z} end
local function a2v(a) return Vector3.new(a[1], a[2], a[3]) end
local function syncToggles()
    if recToggle then recToggle:Set(mc.rec, true) end
    if playToggle then playToggle:Set(mc.play, true) end
end
local tdPrice
local cfgPriced = setmetatable({}, {__mode = "k"})
local tgAt = setmetatable({}, {__mode = "k"})
local function tid(t)
    if type(t) == "table" then
        local v = t.Id
        if v == nil then v = t.Index end
        if v == nil then return nil end
        return tostring(v), v
    end
    if t ~= nil then return tostring(t), t end
    return nil
end
local function waveTime()
    return st.waveStart and (os.clock() - st.waveStart) or nil
end
local function waveGameTime()
    return st.waveStartGame and (gameClock() - st.waveStartGame) or nil
end
local function pushStep(s)
    local ts = s.ts or 0
    local i = #mc.steps
    while i > 0 and (mc.steps[i].ts or 0) > ts do i = i - 1 end
    table.insert(mc.steps, i + 1, s)
end
local function forgetTower(id)
    mc.id2pos[id], mc.id2mode[id], mc.id2name[id] = nil, nil, nil
    mc.id2lvl[id], mc.id2key[id], mc.id2raw[id] = nil, nil, nil
    mc.id2at[id] = nil
end
local function clearStamps()
    mc.stamps = {TowerAdd = {}, TowerUpgrade = {}, TowerSell = {}, TowerTarget = {}}
    mc.settle = {}
end
local function resetRecorder()
    mc.steps = {}
    clearStamps()
    mc.id2key, mc.selfSell, mc.keyN = {}, {}, 0
    mc.hookMiss = not mc.hook
end
local POS_EPS = 0.35
local function idAt(p, name, skip)
    local best, bestD
    for id, pos in pairs(mc.id2pos) do
        if not (skip and skip[id]) and (not name or mc.id2name[id] == name) then
            local d = (pos - p).Magnitude
            if d < POS_EPS and (not bestD or d < bestD) then
                best, bestD = id, d
            end
        end
    end
    return best
end
local function towerModelAlive(id)
    local g = workspace:FindFirstChild("Game")
    local tw = g and g:FindFirstChild("Towers")
    if not tw then return true end
    return tw:FindFirstChild(tostring(id)) ~= nil
end
local function ownCount()
    local n = 0
    for _ in pairs(mc.id2pos) do n = n + 1 end
    return n
end
local function pruneGhosts()
    local g = workspace:FindFirstChild("Game")
    local tw = g and g:FindFirstChild("Towers")
    if not tw then return end
    local gone = {}
    local now = os.clock()
    for id in pairs(mc.id2pos) do
        if now - (mc.id2at[id] or 0) > 4 and not tw:FindFirstChild(tostring(id)) then
            gone[#gone + 1] = id
        end
    end
    for _, id in ipairs(gone) do forgetTower(id) end
end
local function noteMoney()
    local v = money()
    for _, list in pairs(mc.stamps) do
        for _, e in ipairs(list) do
            if e.lo and v < e.lo then e.lo = v end
        end
    end
    for _, e in ipairs(mc.settle) do
        if e.lo and v < e.lo then e.lo = v end
    end
end
task.spawn(function()
    local ls = lp:WaitForChild("leaderstats", 30)
    local mv = ls and ls:WaitForChild("Money", 30)
    if not mv then return end
    mv:GetPropertyChangedSignal("Value"):Connect(function()
        if alive() and mc.rec then noteMoney() end
    end)
end)
local function takeStamp(kind, match, newest)
    local list = mc.stamps[kind]
    local now = os.clock()
    for i = #list, 1, -1 do
        if now - list[i].ts > 15 then table.remove(list, i) end
    end
    local first, last, dir = 1, #list, 1
    if newest then first, last, dir = #list, 1, -1 end
    local pickI, pickD
    for i = first, last, dir do
        local ok, d = match(list[i])
        if ok and (not pickD or d < pickD - 1e-6) then pickI, pickD = i, d end
    end
    if pickI then return table.remove(list, pickI) end
    return nil
end
local function dropNewestStamp(kind)
    local list = mc.stamps[kind]
    for i = #list, 1, -1 do
        if os.clock() - list[i].ts < 2.5 then
            table.remove(list, i)
            return
        end
    end
end
local function measured(e, step)
    local drop = (e.m or 0) - (e.lo or e.m or 0)
    if drop <= 0 then return nil end
    for _, list in pairs(mc.stamps) do
        for _, o in ipairs(list) do
            if o ~= e and math.abs(o.ts - e.ts) < 0.9 then return nil end
        end
    end
    for _, o in ipairs(mc.settle) do
        if o ~= e and math.abs(o.ts - e.ts) < 0.9 then return nil end
    end
    for _, s in ipairs(mc.steps) do
        if s ~= step and s.ts and math.abs(s.ts - e.ts) < 0.9 then return nil end
    end
    return drop
end
local function tickStamps()
    local now = os.clock()
    for _, list in pairs(mc.stamps) do
        for i = #list, 1, -1 do
            if now - list[i].ts > 15 then table.remove(list, i) end
        end
    end
    for i = #mc.settle, 1, -1 do
        local e = mc.settle[i]
        if now - e.ts > 0.8 then
            table.remove(mc.settle, i)
            if not cfgPriced[e.step] then
                local c = measured(e, e.step)
                if c then e.step.c = c end
            end
        end
    end
end
local function recordStep(kind, key, pos, e, extra, level)
    local s = {
        t = kind, k = key, p = v2a(pos),
        m = e and e.m or money(),
        w = e and e.w or mc.wave,
        wt = e and e.wt or waveTime(),
        gt = e and e.gt or waveGameTime(),
        sp = e and e.sp or tonumber(st.curSpeed),
        ts = e and e.ts or os.clock(),
    }
    for k, v in pairs(extra) do s[k] = v end
    local buys = kind == "place" or kind == "upgrade"
    local cp = buys and tdPrice and s.n and tdPrice(s.n, level or 1)
    if cp then
        s.c = cp
        cfgPriced[s] = true
    end
    pushStep(s)
    if buys and e and e.lo then
        table.insert(mc.settle, {ts = e.ts, m = e.m, lo = e.lo, step = s})
    end
    return s
end
local function newMatch()
    if mc.rec and finishRecording then finishRecording("New match") end
    mc.matchId = mc.matchId + 1
    mc.wave = 0
    mc.id2pos, mc.id2mode, mc.upAck, mc.id2name, mc.id2lvl = {}, {}, {}, {}, {}
    clearStamps()
    mc.id2key, mc.id2raw, mc.k2id, mc.selfSell = {}, {}, {}, {}
    mc.claim = {}
    mc.id2at, mc.book, mc.limits, mc.mlog = {}, {}, {}, {}
    mc.upFail, mc.waitPlace, mc.placeFail = false, nil, nil
    st.waveStartGame = nil
    st.farms = {}
    mc.finalSeen = false
    st.curSpeed, st.waveOn, st.cleared = nil, false, false
    st.matchStart, st.matchMode = nil, nil
    if mc.rec then
        mc.rec = false
        syncToggles()
        flash("Recording stopped: new match")
    end
end
local WH = {url = "", enabled = false, onEnd = true}
local WH_HOSTS = {["discord.com"] = true, ["discordapp.com"] = true, ["ptb.discord.com"] = true, ["canary.discord.com"] = true}
function WH.clean(u)
    u = tostring(u or ""):gsub("%s+", "")
    return u
end
function WH.valid(u)
    local host = u:match("^https://([^/]+)/api/webhooks/%d+/[%w%-_]+")
    return host ~= nil and WH_HOSTS[host:lower()] == true
end
function WH.request()
    return (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
end
function WH.post(url, payload)
    local req = WH.request()
    if not req then return false, "this executor has no http request function" end
    local body = HttpService:JSONEncode(payload)
    for attempt = 1, 2 do
        local ok, res = pcall(req, {
            Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body,
        })
        if not ok then return false, tostring(res):sub(1, 60) end
        local code = type(res) == "table" and tonumber(res.StatusCode or res.status_code) or 0
        if code >= 200 and code < 300 then return true, code end
        if code == 429 and attempt == 1 then
            local wait = 2
            if type(res.Body) == "string" then
                local okj, d = pcall(function() return HttpService:JSONDecode(res.Body) end)
                if okj and type(d) == "table" and tonumber(d.retry_after) then wait = math.min(tonumber(d.retry_after), 10) end
            end
            task.wait(wait + 0.2)
        else
            return false, code
        end
    end
    return false, 429
end
function WH.fmtTime(sec)
    if not sec then return "-" end
    sec = math.max(0, math.floor(sec))
    if sec >= 3600 then return string.format("%d:%02d:%02d", math.floor(sec / 3600), math.floor(sec % 3600 / 60), sec % 60) end
    return string.format("%d:%02d", math.floor(sec / 60), sec % 60)
end
function WH.fmt(n)
    if n == nil then return "Unavailable" end
    local s = tostring(math.floor(n + 0.5))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (out:gsub("^,", ""))
end
function WH.num(label)
    if not (label and label:IsA("TextLabel") and visible(label)) then return nil end
    local t = tostring(label.Text or ""):gsub(",", ""):gsub("%s", "")
    return tonumber(t:match("%d+%.?%d*"))
end
function WH.finalText(path, strip)
    local f = findUI("FinalUI")
    local l = f and INV.path(f, path)
    if not (l and l:IsA("TextLabel")) then return nil end
    local t = tostring(l.Text or "")
    if strip then t = t:gsub(strip, "") end
    return t ~= "" and t or nil
end
function WH.rewards()
    local out = {Exp = 0, Crates = 0}
    local f = findUI("FinalUI")
    local stats = f and INV.path(f, "Content/Stats")
    if not (stats and visible(stats)) then return out end
    for _, row in ipairs(stats:GetChildren()) do
        if visible(row) then
            local amount = WH.num(INV.path(row:FindFirstChild("Holder") or row, "Template/CoinAmount"))
            if row.Name:match("^FrameMoney") or row.Name:match("^FrameCoins") then
                if amount then out.Coins = (out.Coins or 0) + amount end
            elseif row.Name:match("^FrameCandy") then
                if amount then out.Candy = (out.Candy or 0) + amount end
            end
            local shadow = INV.path(row, "MainShadow")
            for _, item in ipairs(shadow and shadow:GetChildren() or {}) do
                if visible(item) then
                    local a = WH.num(item:FindFirstChild("CoinAmount"))
                    local modeLabel = item:FindFirstChild("Mode")
                    local mode = modeLabel and tostring(modeLabel.Text):lower() or ""
                    if a and item.Name:lower():find("crate", 1, true) then
                        out.Crates = out.Crates + a
                    elseif a and mode:find("(exp)", 1, true) then
                        out.Exp = out.Exp + a
                    end
                end
            end
        end
    end
    return out
end
function WH.account()
    local d = INV.get()
    local coins = d and tonumber(d.Money)
    local candy = d and tonumber(d.Candy)
    if candy == nil then
        local l = INV.path(pg, "HUD/Currencies/Candy/CurrencyFrame/AmountLabel")
        local t = l and tostring(l.Text):gsub(",", "")
        candy = t and tonumber(t:match("^%s*(%d+)%s*$"))
    end
    return coins, candy
end
function WH.baseHp()
    local base = INV.path(workspace, "Game/Base")
    return base and (base:GetAttribute("Health") or base:GetAttribute("HP")) or nil
end
function WH.embed(won, info)
    local title, color = "Webhook test", 5793266
    if won == true then
        title, color = "Victory", 3066993
    elseif won == false then
        title, color = "Defeat", 15158332
    end
    local fields = {
        {name = "Mode", value = tostring(info.mode), inline = true},
        {name = "Wave", value = tostring(info.wave), inline = true},
        {name = "Time", value = WH.fmtTime(info.time), inline = true},
    }
    if info.map then table.insert(fields, 2, {name = "Map", value = tostring(info.map), inline = true}) end
    fields[#fields + 1] = {
        name = "Player Info",
        value = string.format("\240\159\145\164 Name: ||%s||\n\226\157\164\239\184\143 Base HP: %s", lp.Name, info.hp ~= nil and tostring(info.hp) or "Unavailable"),
        inline = false,
    }
    local r = info.rewards
    if r then
        fields[#fields + 1] = {
            name = "Match Rewards",
            value = string.format("\240\159\146\181 Coins: %s\n\226\173\144 EXP: %s\n\240\159\147\166 Crates: %s\n\240\159\141\172 Candy: %s",
                WH.fmt(r.Coins), WH.fmt(r.Exp), WH.fmt(r.Crates), WH.fmt(r.Candy)),
            inline = false,
        }
    end
    local coins, candy = WH.account()
    fields[#fields + 1] = {
        name = "Account Totals",
        value = string.format("\240\159\146\181 Total Coins: %s\n\240\159\141\172 Total Candy: %s", WH.fmt(coins), WH.fmt(candy)),
        inline = false,
    }
    return {
        username = "BeeZ Hub",
        allowed_mentions = {parse = {}},
        embeds = {{
            title = title, color = color, fields = fields,
            footer = {text = "BeeZ Hub | " .. lp.Name},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }
end
function WH.snapshot()
    local w = tonumber(workspace:GetAttribute("Wave")) or mc.wave
    return {
        mode = WH.finalText("Content/Mode", "^%s*Mode:%s*") or workspace:GetAttribute("Mode") or st.matchMode or "?",
        map = WH.finalText("Content/Map", "^%s*Map:%s*") or workspace:GetAttribute("Map"),
        wave = math.max(w or 0, mc.wave or 0),
        time = st.matchStart and (os.clock() - st.matchStart) or nil,
        hp = WH.baseHp(),
    }
end
function WH.send(won, info, quiet, done)
    local url = WH.clean(WH.url)
    if not WH.valid(url) then
        if not quiet then flash("Webhook: paste a valid Discord webhook link first", "Warning") end
        if done then done() end
        return
    end
    task.spawn(function()
        local ok, why = WH.post(url, WH.embed(won, info))
        if done then done() end
        if not alive() then return end
        if ok then
            if not quiet then flash("Webhook message sent", "Success") end
        else
            flash("Webhook failed: " .. tostring(why), "Error")
        end
    end)
end
function WH.matchEnd()
    if not (WH.enabled and WH.onEnd) then return end
    local info = WH.snapshot()
    WH.busy = true
    task.spawn(function()
        local function release() WH.busy = false end
        local msg = workspace:GetAttribute("Message")
        local t0 = os.clock()
        while msg ~= "You Won!" and msg ~= "You Lost!" and os.clock() - t0 < 3 and alive() do
            task.wait(0.1)
            msg = workspace:GetAttribute("Message")
        end
        if not alive() or (msg ~= "You Won!" and msg ~= "You Lost!") then return release() end
        local t1, sig, changedAt, rewards = os.clock(), nil, os.clock(), WH.rewards()
        while alive() do
            rewards = WH.rewards()
            local now = os.clock()
            local s = table.concat({tostring(rewards.Coins), tostring(rewards.Candy), tostring(rewards.Exp), tostring(rewards.Crates)}, "/")
            if s ~= sig then sig, changedAt = s, now end
            if now - t1 >= 3.5 or (now - t1 >= 0.75 and rewards.Coins ~= nil and now - changedAt >= 0.35) then break end
            task.wait(0.1)
        end
        if not alive() then return release() end
        local fresh = WH.snapshot()
        fresh.time = info.time
        fresh.wave = math.max(fresh.wave or 0, info.wave or 0)
        if info.hp ~= nil then fresh.hp = info.hp end
        fresh.rewards = rewards
        WH.send(msg == "You Won!", fresh, true, release)
    end)
end
local function matchEnded()
    if mc.finalSeen then return end
    mc.finalSeen = true
    WH.matchEnd()
    if mc.rec and finishRecording then finishRecording("Round ended") end
    mc.matchId = mc.matchId + 1
    mc.ranMatch = mc.matchId
end
local function onTowerAdd(t)
    if not alive() or type(t) ~= "table" or t.OwnerUserId ~= lp.UserId then return end
    local id, raw = tid(t)
    if not id then return end
    local pos = t.Pos
    if typeof(pos) ~= "Vector3" then return end
    if FARMS[string.lower(tostring(t.Name))] then st.farms[id] = true end
    for oid, p in pairs(mc.id2pos) do
        if oid ~= id and (p - pos).Magnitude < 0.05 and not towerModelAlive(oid) then
            forgetTower(oid)
        end
    end
    mc.id2pos[id] = pos
    mc.id2mode[id] = t.TargetMode
    mc.id2name[id] = t.Name
    mc.id2lvl[id] = tonumber(t.Level) or 1
    mc.id2raw[id] = raw
    mc.id2at[id] = os.clock()
    if mc.waitPlace and (pos - mc.waitPlace).Magnitude < 0.5 and (not mc.waitName or mc.waitName == t.Name) then
        mc.waitPlaceOk = true
        mc.waitPlaceId = id
    end
    if mc.rec and not mc.playing then
        local e = takeStamp("TowerAdd", function(o)
            if typeof(o.pos) ~= "Vector3" then return false end
            local d = (o.pos - pos).Magnitude
            if d > 2.5 then return false end
            if o.n and t.Name and o.n ~= t.Name then return false end
            return true, d
        end, true)
        if not e then mc.hookMiss = true end
        mc.keyN = mc.keyN + 1
        local key = "T" .. mc.keyN
        mc.id2key[id] = key
        recordStep("place", key, pos, e, {u = t.UnitId or (e and e.u), n = t.Name or (e and e.n)}, 1)
    end
end
local function onTowerRemove(t)
    if not alive() then return end
    local id = tid(t)
    if not id then return end
    st.farms[id] = nil
    local pos, key = mc.id2pos[id], mc.id2key[id]
    if pos and key and mc.rec and not mc.playing and not mc.selfSell[id] then
        local e = takeStamp("TowerSell", function(o) return o.id == id, 0 end)
        if e or mc.hookMiss then
            recordStep("sell", key, pos, e, {n = mc.id2name[id]})
        end
    end
    mc.selfSell[id] = nil
    forgetTower(id)
end
local function sellFarms(myMatch, wave)
    task.spawn(function()
        local ids = {}
        for id in pairs(st.farms) do ids[#ids + 1] = id end
        local total = #ids
        if total == 0 then return end
        local function standing()
            local n = 0
            for _, id in ipairs(ids) do
                if st.farms[id] then n = n + 1 end
            end
            return n
        end
        for _ = 1, 4 do
            for _, id in ipairs(ids) do
                if st.farms[id] then
                    mc.selfSell[id] = true
                    pcall(function() R.TowerSell:FireServer({Id = mc.id2raw[id] or id}) end)
                    task.wait(0.05)
                end
            end
            task.wait(0.4)
            if not alive() or mc.matchId ~= myMatch then return end
            if standing() == 0 then break end
        end
        local left = standing()
        flash(string.format("Auto Sell Farms: sold %d/%d on wave %d", total - left, total, wave),
            left == 0 and "Success" or "Warning")
    end)
end
local function checkFarmSell()
    local w = cfg.sellFarmWave
    if not w or w <= 0 or mc.wave < w or not R.TowerSell then return end
    if st.farmSoldMatch == mc.matchId then return end
    st.farmSoldMatch = mc.matchId
    sellFarms(mc.matchId, mc.wave)
end
local function onTowerTarget(t)
    if not alive() or type(t) ~= "table" or not t.TargetMode then return end
    local id = tid(t)
    if not id then return end
    local old = mc.id2mode[id]
    mc.id2mode[id] = t.TargetMode
    local pos, key = mc.id2pos[id], mc.id2key[id]
    if mc.rec and not mc.playing and pos and key and old ~= t.TargetMode then
        local e = takeStamp("TowerTarget", function(o) return o.id == id, 0 end)
        local last = mc.steps[#mc.steps]
        if last and last.t == "target" and last.k == key and tgAt[last] and os.clock() - tgAt[last] < 2.5 then
            last.mode = t.TargetMode
            tgAt[last] = os.clock()
        else
            local s = recordStep("target", key, pos, e, {mode = t.TargetMode})
            tgAt[s] = os.clock()
        end
    end
end
local function onTowerUpgrade(t)
    if not alive() or type(t) ~= "table" then return end
    local id = tid(t)
    if not id then return end
    mc.upAck[id] = os.clock()
    local pos = mc.id2pos[id]
    if not pos then return end
    mc.ackSeen = true
    local old = mc.id2lvl[id] or 1
    local new = tonumber(t.Level) or (old + 1)
    mc.id2lvl[id] = new
    local key = mc.id2key[id]
    if mc.rec and not mc.playing and key and new > old then
        local e = takeStamp("TowerUpgrade", function(o) return o.id == id, 0 end)
        recordStep("upgrade", key, pos, e, {n = mc.id2name[id], lv = new}, new)
    end
end
local function onNotify(msg)
    if not alive() or type(msg) ~= "string" then return end
    local sp = msg:match("changed the game speed to ([%d%.]+)")
    if sp then
        st.curSpeed = tonumber(sp)
        return
    end
    if LB.noFunds(msg) and os.clock() - LB.lastSummon < 4 and not LB.inMatch() then
        LB.stopSummon()
        return
    end
    if mc.waitPlace then
        local low = msg:lower()
        if low:find("enough money", 1, true) then
            mc.placeFail = "money"
        elseif not low:find("successfully placed", 1, true) and (low:find("place", 1, true)
            or low:find("limit", 1, true) or low:find("can't", 1, true) or low:find("cannot", 1, true)) then
            if low:find("limit", 1, true) or low:find("maximum", 1, true) or low:find("only place", 1, true) then
                mc.placeFail = "limit"
            else
                mc.placeFail = "other"
            end
        end
    end
    if msg:find("enough money to upgrade") then
        mc.upFail = true
        dropNewestStamp("TowerUpgrade")
    elseif msg:find("Wave Cleared") then
        st.waveOn = false
        st.cleared = true
        st.nextSkip = os.clock() + cfg.skipDelay
    elseif msg:find("started!") then
        local n = msg:match("Wave (%d+) started")
        if n == "1" and mc.finalSeen then newMatch() end
        if n == "1" then st.matchStart = os.clock() end
        st.waveOn = true
        st.cleared = false
        st.waveStart = os.clock()
        st.waveStartGame = gameClock()
        st.nextSkip = os.clock() + cfg.skipDelay
        if n then mc.wave = tonumber(n) end
        checkFarmSell()
        if n == "1" then st.speedTries, st.speedGaveUp = 0, false end
        ensureSpeed()
    end
end
local function onFire(self, kind, arg)
    if checkcaller and checkcaller() then return end
    mc.hookBeat = os.clock()
    if mc.playing or type(arg) ~= "table" then return end
    local v = money()
    local list = mc.stamps[kind]
    if #list >= 64 then table.remove(list, 1) end
    list[#list + 1] = {
        id = tid(arg), pos = arg.Pos, u = arg.UnitId, n = arg.Name,
        m = v, lo = v, w = mc.wave, wt = waveTime(), gt = waveGameTime(), sp = tonumber(st.curSpeed),
        ts = os.clock(),
    }
end
-- One process-wide __namecall router, installed only when Record is turned on.
-- The closure does a single table lookup for every unrelated call and never stacks on re-execution.
local function installHook()
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" then return false end
    local router = genv.cm_router
    if not router then
        router = {}
        genv.cm_router = router
        local wrap = newcclosure or function(f) return f end
        local oldNC
        local ok = pcall(function()
            oldNC = hookmetamethod(game, "__namecall", wrap(function(self, ...)
                local hub = router.hub
                local kind = hub and hub.mc.rec and hub.remotes[self]
                if kind and getnamecallmethod() == "FireServer" then
                    pcall(hub.onFire, self, kind, ...)
                    if setnamecallmethod then pcall(setnamecallmethod, "FireServer") end
                end
                return oldNC(self, ...)
            end))
        end)
        if not ok or not oldNC then
            genv.cm_router = nil
            return false
        end
    end
    local remotes = {}
    for _, n in ipairs({"TowerAdd", "TowerUpgrade", "TowerSell", "TowerTarget"}) do
        if R[n] then remotes[R[n]] = n end
    end
    router.hub = {mc = mc, remotes = remotes, onFire = onFire}
    return true
end
local function same(myMatch)
    return alive() and mc.play and mc.matchId == myMatch
end
local function sleep(t, myMatch)
    local t0 = os.clock()
    while os.clock() - t0 < t do
        if not same(myMatch) then return false end
        task.wait(0.05)
    end
    return same(myMatch)
end
local function waitUntil(cond, timeout, myMatch, step)
    local t0 = os.clock()
    while same(myMatch) do
        if cond() then return true end
        if os.clock() - t0 > timeout then return false end
        task.wait(step or 0.1)
    end
    return false
end
local function resolveUnit(name, saved)
    for i = 1, 5 do
        if lp:GetAttribute("Slot" .. i) == name then
            local id = lp:GetAttribute("Slot" .. i .. "Id")
            if id then return id end
        end
    end
    return saved
end
local function countName(name)
    local n = 0
    for _, nm in pairs(mc.id2name) do
        if nm == name then n = n + 1 end
    end
    return n
end
local function upgradeWait()
    local ok, ping = pcall(function() return lp:GetNetworkPing() end)
    if not ok or type(ping) ~= "number" then ping = 0.1 end
    return math.clamp(ping * 4 + 0.5, 0.8, 1.6)
end
local TD = {towers = nil}
local function loadTowerConfig()
    local ok, res = pcall(function()
        local ml = RS:WaitForChild("ModuleLoader", 10)
        local cf = ml and ml:WaitForChild("Configs", 10)
        local mod = cf and cf:WaitForChild("Config", 10)
        return mod and require(mod)
    end)
    if ok and type(res) == "table" and type(res.Towers) == "table" then
        TD.towers = res.Towers
        return true
    end
    return false
end
local function tdDef(name)
    return TD.towers and type(name) == "string" and TD.towers[name] or nil
end
function tdPrice(name, level)
    local d = tdDef(name)
    local u = d and type(d.Upgrades) == "table" and d.Upgrades[level]
    return u and tonumber(u.Price) or nil
end
local function tdMaxLevel(name)
    local d = tdDef(name)
    return d and type(d.Upgrades) == "table" and #d.Upgrades or nil
end
local function limitFor(name)
    if type(name) ~= "string" then return nil end
    local d = tdDef(name)
    return (d and tonumber(d.PlacementLimit)) or UNIT_LIMITS[name:lower()] or mc.limits[name]
end
local function fmtMoney(n)
    local str = tostring(math.floor(n + 0.5))
    local out = str:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (out:gsub("^,", ""))
end
local function bookKey(name, level)
    return tostring(name) .. "#" .. tostring(level)
end
local function needPrice(name, level, recorded)
    local b = mc.book[bookKey(name, level)]
    if b then return b end
    return tdPrice(name, level) or recorded
end
local function raiseBook(key, s, configPrice)
    local bump = math.max(1, math.floor((s.m or money()) * 0.02))
    local want = money() + bump
    if configPrice then want = math.min(want, math.max(configPrice * 2, money() + 1)) end
    mc.book[key] = math.max(mc.book[key] or 0, want)
    return mc.book[key]
end
local function pingSec()
    local ok, ping = pcall(function() return lp:GetNetworkPing() end)
    if not ok or type(ping) ~= "number" then return 0.1 end
    return ping
end
local function chargeVisible(since, price)
    local need = (price and price > 0) and price * 0.5 or 1
    for i = #mc.mlog, 1, -1 do
        local e = mc.mlog[i]
        if e.t < since then break end
        if e.d <= -need then return true end
    end
    return false
end
local function settleCap()
    return math.clamp(pingSec() * 3 + 0.2, 0.3, 0.8)
end
local function equipped(name)
    local any = false
    for i = 1, 5 do
        local v = lp:GetAttribute("Slot" .. i)
        if v ~= nil then any = true end
        if v == name then return true end
    end
    return not any
end
local function keepPrice(s, c, m0)
    if c <= 0 then return end
    local raise = not s.c or c > s.c + math.max(10, s.c * 0.1)
    local stale = s.c and m0 and m0 < s.c and c < s.c
    if raise or stale then
        s.c = c
        mc.learned = true
    end
end
local function ackWindow()
    return math.clamp(pingSec() * 6 + 1.5, 2, 5)
end
local function stepId(s)
    local mapped = s.k and mc.k2id[s.k]
    if mapped then
        return mc.id2pos[mapped] and mapped or nil
    end
    return idAt(a2v(s.p), s.n)
end
local function doPlace(s, myMatch)
    local p = a2v(s.p)
    mc.claim = mc.claim or {}
    local have = idAt(p, s.n, mc.claim)
    if have then
        mc.claim[have] = true
        return true, have
    end
    pruneGhosts()
    if ownCount() >= MAX_UNITS then
        flash("Unit limit reached (" .. MAX_UNITS .. "), step skipped", "Warning")
        return false
    end
    local lim = limitFor(s.n)
    if lim and countName(s.n) >= lim then
        flash(tostring(s.n) .. " limit (" .. lim .. ") reached, step skipped", "Warning")
        return false
    end
    local key = bookKey(s.n, 1)
    local misses = 0
    while same(myMatch) do
        local there = idAt(p, s.n, mc.claim)
        if there then
            mc.claim[there] = true
            return true, there
        end
        local unitId = resolveUnit(s.n, s.u)
        local price = needPrice(s.n, 1, s.c)
        if price and money() < price then
            waitUntil(function() return money() >= price end, 45, myMatch, 0.1)
            if not same(myMatch) then return false end
        end
        local m0 = money()
        local sentAt = os.clock()
        mc.waitPlace, mc.waitName, mc.waitPlaceOk, mc.waitPlaceId, mc.placeFail = p, s.n, false, nil, nil
        R.TowerAdd:FireServer({Pos = p, CFrame = CFrame.new(p), Name = s.n, UnitId = unitId})
        waitUntil(function() return mc.waitPlaceOk or mc.placeFail ~= nil end, ackWindow(), myMatch, 0.03)
        local ok, fail, nid = mc.waitPlaceOk, mc.placeFail, mc.waitPlaceId
        mc.waitPlace, mc.waitName = nil, nil
        if not ok and fail == nil and same(myMatch) then
            waitUntil(function()
                local late = idAt(p, s.n, mc.claim)
                if late then nid = late end
                return late ~= nil
            end, 1.0, myMatch, 0.05)
            ok = nid ~= nil
        end
        if ok then
            if nid then mc.claim[nid] = true end
            local lo = m0
            waitUntil(function()
                local mn = money()
                if mn < lo then lo = mn end
                return chargeVisible(sentAt, price)
            end, settleCap(), myMatch, 0.02)
            if lo < m0 then keepPrice(s, m0 - lo, m0) end
            if price and m0 < price then mc.book[key] = m0 end
            return true, nid
        end
        if not same(myMatch) then return false end
        if fail == "limit" then
            local n = countName(s.n)
            if n > 0 then mc.limits[s.n] = n end
            flash(tostring(s.n) .. " limit reached, step skipped", "Warning")
            return false
        elseif fail == "money" then
            local need = raiseBook(key, s, tdPrice(s.n, 1))
            if not waitUntil(function() return money() >= need end, math.huge, myMatch, 0.1) then return false end
        else
            misses = misses + 1
            if misses >= 8 then
                flash("Place failed, step skipped", "Warning")
                return false
            end
            if not sleep(0.4 * misses, myMatch) then return false end
        end
    end
    return false
end
local function doUpgrade(s, myMatch)
    local id = stepId(s)
    if not id then return false end
    local want = tonumber(s.lv) or ((mc.id2lvl[id] or 1) + 1)
    local silent, rounds = 0, 0
    while same(myMatch) do
        rounds = rounds + 1
        if rounds > 30 or not mc.id2pos[id] then return false end
        local name = mc.id2name[id]
        local level = mc.id2lvl[id] or 1
        if level >= want then return true end
        local maxL = tdMaxLevel(name)
        if maxL and level >= maxL then return true end
        local key = bookKey(name, level + 1)
        local price = needPrice(name, level + 1, (level + 1 == want) and s.c or nil)
        if price and money() < price then
            waitUntil(function() return money() >= price end, 45, myMatch, 0.1)
            if not same(myMatch) then return false end
        end
        mc.upFail = false
        local before = mc.upAck[id]
        local m0 = money()
        local lo = m0
        local sentAt = os.clock()
        R.TowerUpgrade:FireServer({Id = mc.id2raw[id] or id})
        local outcome = "silent"
        local t0, window = os.clock(), ackWindow()
        while same(myMatch) and os.clock() - t0 < window do
            if mc.upFail then
                outcome = "fail"
                break
            end
            local mn = money()
            if mn < lo then lo = mn end
            if lo < m0 or mc.upAck[id] ~= before then
                outcome = "ok"
                break
            end
            task.wait(0.02)
        end
        if not same(myMatch) then return false end
        if outcome == "ok" then
            waitUntil(function()
                local mn = money()
                if mn < lo then lo = mn end
                return chargeVisible(sentAt, price)
            end, settleCap(), myMatch, 0.02)
            if mc.upAck[id] == before then mc.id2lvl[id] = level + 1 end
            if lo < m0 and level + 1 == want then keepPrice(s, m0 - lo, m0) end
            if price and m0 < price then mc.book[key] = m0 end
            silent = 0
        elseif outcome == "silent" then
            if not mc.ackSeen then
                mc.id2lvl[id] = level + 1
            else
                silent = silent + 1
                if silent >= 3 then return false end
                waitUntil(function() return mc.upAck[id] ~= before or money() < m0 end, 1.0, myMatch, 0.02)
                if not same(myMatch) then return false end
                if mc.upAck[id] == before and money() < m0 then mc.id2lvl[id] = level + 1 end
            end
        else
            local need = raiseBook(key, s, tdPrice(name, level + 1))
            if not waitUntil(function() return money() >= need end, math.huge, myMatch, 0.1) then return false end
        end
    end
    return false
end
local function doSell(s, myMatch)
    local id = stepId(s)
    if not id then return false end
    for _ = 1, 4 do
        if not mc.id2pos[id] then return true end
        R.TowerSell:FireServer({Id = mc.id2raw[id] or id})
        if waitUntil(function() return mc.id2pos[id] == nil end, ackWindow(), myMatch, 0.03) then return true end
        if not same(myMatch) then return false end
    end
    return false
end
local function doTarget(s, myMatch)
    local id = stepId(s)
    if not id then return false end
    for _ = 1, 14 do
        if not same(myMatch) or not mc.id2pos[id] then return false end
        local cur = mc.id2mode[id]
        if cur == s.mode then return true end
        R.TowerTarget:FireServer({Id = mc.id2raw[id] or id})
        local moved = waitUntil(function() return mc.id2mode[id] ~= cur end, ackWindow(), myMatch, 0.03)
        if not moved and same(myMatch) then
            moved = sleep(0.4, myMatch) and mc.id2mode[id] ~= cur
        end
        if not same(myMatch) then return false end
        if moved then task.wait(0.05) end
    end
    return mc.id2mode[id] == s.mode
end
local function gate(s, myMatch)
    if s.t == "sell" then
        local w = s.w or 0
        if w > 0 then
            if not waitUntil(function() return mc.wave >= w end, math.huge, myMatch) then return false end
            if s.gt and st.waveStartGame then
                local reached = waitUntil(function()
                    return mc.wave > w or (st.waveStartGame ~= nil and gameClock() - st.waveStartGame >= s.gt)
                end, math.huge, myMatch)
                if not reached then return false end
            elseif s.wt then
                local due = math.min(s.wt * (s.sp or 1) / (tonumber(st.curSpeed) or 1), 900)
                local reached = waitUntil(function()
                    return mc.wave > w or (st.waveStart and os.clock() - st.waveStart >= due)
                end, math.huge, myMatch)
                if not reached then return false end
            end
        end
    end
    return same(myMatch)
end
local function runPlayback(myMatch)
    mc.playing = true
    mc.stepNo = 0
    mc.claim = {}
    mc.k2id = {}
    local sel, steps = mc.selected, mc.steps
    if not TD.towers then flash("Game config not found: prices come from the recorded steps", "Warning") end
    do
        local seen, missing = {}, {}
        for _, s0 in ipairs(steps) do
            if s0.t == "place" and s0.n and not seen[s0.n] then
                seen[s0.n] = true
                if not equipped(s0.n) then missing[#missing + 1] = s0.n end
            end
        end
        if #missing > 0 then flash("Not in your hotbar: " .. table.concat(missing, ", "), "Warning") end
    end
    for i, s in ipairs(mc.steps) do
        if not same(myMatch) then break end
        mc.stepNo = i
        if gate(s, myMatch) then
            if s.t == "place" then
                local ok, id = doPlace(s, myMatch)
                if ok and id and s.k then mc.k2id[s.k] = id end
            elseif s.t == "upgrade" then
                doUpgrade(s, myMatch)
            elseif s.t == "sell" then
                doSell(s, myMatch)
            elseif s.t == "target" then
                doTarget(s, myMatch)
            end
            task.wait(0.02)
        end
    end
    local finished = same(myMatch) and mc.stepNo >= #mc.steps
    mc.playing = false
    if mc.learned and sel and sel == mc.selected and steps == mc.steps then
        mc.learned = false
        if MAC.write(sel, {v = 3, replay = mc.replay, steps = mc.steps}) then
            flash("Macro calibrated: prices saved", "Success")
        end
    end
    if finished then flash("Macro finished, waiting for the next match", "Success") end
end
local function assignKeys(steps)
    local alive, lv, n = {}, {}, 0
    for _, s in ipairs(steps) do
        local p = a2v(s.p)
        if s.t == "place" then
            n = n + 1
            s.k = s.k or ("L" .. n)
            alive[s.k] = {pos = p, name = s.n}
            lv[s.k] = 1
        else
            if not s.k then
                local best, bestD
                for k, a in pairs(alive) do
                    local d = (a.pos - p).Magnitude
                    if d < POS_EPS and (not bestD or d < bestD) then best, bestD = k, d end
                end
                s.k = best
            end
            if s.k then
                if s.t == "upgrade" then
                    if s.lv then
                        lv[s.k] = s.lv
                    else
                        lv[s.k] = (lv[s.k] or 1) + 1
                        s.lv = lv[s.k]
                    end
                elseif s.t == "sell" then
                    alive[s.k] = nil
                end
            end
        end
    end
end
local function cleanSteps(arr)
    local out = {}
    if type(arr) ~= "table" then return out end
    for _, s in ipairs(arr) do
        if type(s) == "table" and type(s.t) == "string" and type(s.p) == "table"
            and type(s.p[1]) == "number" and type(s.p[2]) == "number" and type(s.p[3]) == "number" then
            table.insert(out, s)
        end
    end
    return out
end
local function macroPlan(steps)
    local total, unknown, towers = 0, 0, {}
    local function key(pp) return string.format("%.2f,%.2f,%.2f", pp[1], pp[2], pp[3]) end
    for _, st2 in ipairs(steps) do
        local k = key(st2.p)
        if st2.t == "place" then
            towers[k] = {name = st2.n, level = 1}
            local pr = tdPrice(st2.n, 1)
            if pr then total = total + pr else unknown = unknown + 1 end
        elseif st2.t == "upgrade" then
            local tw = towers[k]
            if tw then
                local mx = tdMaxLevel(tw.name)
                if not mx or tw.level < mx then
                    local pr = tdPrice(tw.name, tw.level + 1)
                    if pr then total = total + pr else unknown = unknown + 1 end
                    tw.level = tw.level + 1
                end
            else
                unknown = unknown + 1
            end
        elseif st2.t == "sell" then
            towers[k] = nil
        end
    end
    return total, unknown
end
local function refreshMacroList()
    if macroDD then macroDD:SetOptions(MAC.list()) end
end
local function loadMacro(name, silent)
    local d = MAC.read(name)
    local steps = d and cleanSteps(d.steps) or {}
    if #steps == 0 then
        if not silent then flash("Macro not found or empty: " .. tostring(name), "Error") end
        return false
    end
    assignKeys(steps)
    mc.steps = steps
    mc.selected = name
    MAC.setAuto(name)
    if macroDD then macroDD:Set(name, true) end
    if nameInput then nameInput:Set(name, true) end
    if not silent then
        local total = TD.towers and macroPlan(steps) or 0
        if total > 0 then
            flash("Loaded macro: " .. name .. " (" .. #steps .. " steps, about $" .. fmtMoney(total) .. ")", "Success")
        else
            flash("Loaded macro: " .. name .. " (" .. #steps .. " steps)", "Success")
        end
    end
    return true
end
local function saveMacro()
    local n = sanitize(nameInput:Get())
    if n == "" then
        flash("Enter a macro name first", "Warning")
        return
    end
    if #mc.steps == 0 then
        flash("Nothing to save: record a macro first", "Warning")
        return
    end
    if MAC.write(n, {v = 2, replay = mc.replay, steps = mc.steps}) then
        mc.selected = n
        MAC.setAuto(n)
        refreshMacroList()
        macroDD:Set(n, true)
        flash("Saved macro: " .. n .. " (" .. #mc.steps .. " steps)", "Success")
    else
        flash("Save failed", "Error")
    end
end
local function deleteMacro()
    local n = sanitize(nameInput:Get())
    if n == "" then n = mc.selected or "" end
    if n == "" or not MAC.exists(n) then
        flash("Pick a saved macro to delete", "Warning")
        return
    end
    if MAC.delete(n) then
        if mc.selected == n then
            mc.selected = nil
            MAC.setAuto(nil)
        end
        refreshMacroList()
        macroDD:Set(nil, true)
        flash("Deleted macro: " .. n, "Success")
    else
        flash("Delete failed", "Error")
    end
end
local function nextMacroName()
    local n = 1
    while MAC.exists("macro #" .. n) do n = n + 1 end
    return "macro #" .. n
end
finishRecording = function(why)
    if not mc.rec then return end
    clearStamps()
    mc.rec = false
    syncToggles()
    if #mc.steps == 0 then
        flash(why .. ": nothing was recorded", "Warning")
        return
    end
    if mc.autoSave == false then
        flash(why .. ": recording stopped, " .. #mc.steps .. " steps kept (press Save)")
        return
    end
    local name = sanitize(nameInput and nameInput:Get() or "")
    if name == "" then name = nextMacroName() end
    if MAC.write(name, {v = 2, replay = mc.replay, steps = mc.steps}) then
        mc.selected = name
        MAC.setAuto(name)
        refreshMacroList()
        if macroDD then macroDD:Set(name, true) end
        if nameInput then nameInput:Set(name, true) end
        flash(why .. ": macro saved as " .. name .. " (" .. #mc.steps .. " steps)", "Success")
    else
        flash("Auto-save failed", "Error")
    end
end
local I18N = {lang = "English"}
do
    local RU = {
        ["Status"] = "\208\161\209\130\208\176\209\130\209\131\209\129", ["Main"] = "\208\147\208\187\208\176\208\178\208\189\208\176\209\143", ["Macro"] = "\208\156\208\176\208\186\209\128\208\190", ["Misc"] = "\208\160\208\176\208\183\208\189\208\190\208\181", ["Settings"] = "\208\157\208\176\209\129\209\130\209\128\208\190\208\185\208\186\208\184",
        ["Ready"] = "\208\147\208\190\209\130\208\190\208\178\208\190", ["Starting..."] = "\208\151\208\176\208\191\209\131\209\129\208\186", ["Waiting for game remotes..."] = "\208\150\208\180\209\145\208\188 \209\128\208\181\208\188\208\190\209\131\209\130\209\139 \208\184\208\179\209\128\209\139",
        ["None"] = "\208\157\208\181\209\130", ["Search..."] = "\208\159\208\190\208\184\209\129\208\186",
        ["Webhook"] = "\208\146\208\181\208\177\209\133\209\131\208\186", ["Webhook URL"] = "\208\161\209\129\209\139\208\187\208\186\208\176 \208\178\208\181\208\177\209\133\209\131\208\186\208\176", ["Enable Webhook"] = "\208\146\208\186\208\187\209\142\209\135\208\184\209\130\209\140 \208\178\208\181\208\177\209\133\209\131\208\186",
        ["Notify On Match End"] = "\208\163\208\178\208\181\208\180\208\190\208\188\208\187\209\143\209\130\209\140 \208\190 \208\186\208\190\208\189\209\134\208\181 \208\188\208\176\209\130\209\135\208\176", ["Send Test Message"] = "\208\158\209\130\208\191\209\128\208\176\208\178\208\184\209\130\209\140 \209\130\208\181\209\129\209\130",
        ["Discord: channel settings > Integrations > Webhooks > New Webhook > Copy Webhook URL"] =
            "Discord: \208\189\208\176\209\129\209\130\209\128\208\190\208\185\208\186\208\184 \208\186\208\176\208\189\208\176\208\187\208\176 > \208\152\208\189\209\130\208\181\208\179\209\128\208\176\209\134\208\184\208\184 > \208\146\208\181\208\177\209\133\209\131\208\186\208\184 > \208\157\208\190\208\178\209\139\208\185 \208\178\208\181\208\177\209\133\209\131\208\186 > \208\154\208\190\208\191\208\184\209\128\208\190\208\178\208\176\209\130\209\140 URL",
        ["Turns Discord messages on or off"] = "\208\146\208\186\208\187\209\142\209\135\208\176\208\181\209\130 \208\184\208\187\208\184 \208\178\209\139\208\186\208\187\209\142\209\135\208\176\208\181\209\130 \209\129\208\190\208\190\208\177\209\137\208\181\208\189\208\184\209\143 \208\178 Discord",
        ["Sends the result of every match: victory or defeat, mode, wave and time"] =
            "\208\158\209\130\208\191\209\128\208\176\208\178\208\187\209\143\208\181\209\130 \208\184\209\130\208\190\208\179 \208\186\208\176\208\182\208\180\208\190\208\179\208\190 \208\188\208\176\209\130\209\135\208\176: \208\191\208\190\208\177\208\181\208\180\208\176 \208\184\208\187\208\184 \208\191\208\190\209\128\208\176\208\182\208\181\208\189\208\184\208\181, \209\128\208\181\208\182\208\184\208\188, \208\178\208\190\208\187\208\189\208\176 \208\184 \208\178\209\128\208\181\208\188\209\143",
        ["Webhook: paste a valid Discord webhook link first"] = "\208\146\208\181\208\177\209\133\209\131\208\186: \209\129\208\189\208\176\209\135\208\176\208\187\208\176 \208\178\209\129\209\130\208\176\208\178\209\140 \208\186\208\190\209\128\209\128\208\181\208\186\209\130\208\189\209\131\209\142 \209\129\209\129\209\139\208\187\208\186\209\131 Discord",
        ["Webhook message sent"] = "\208\161\208\190\208\190\208\177\209\137\208\181\208\189\208\184\208\181 \208\190\209\130\208\191\209\128\208\176\208\178\208\187\208\181\208\189\208\190",
        ["Copy discord server link"] = "\208\161\208\186\208\190\208\191\208\184\209\128\208\190\208\178\208\176\209\130\209\140 \209\129\239\191\189\239\191\189\209\139\208\187\208\186\209\131 \208\189\208\176 Discord",
        ["Server link copied"] = "\208\161\209\129\209\139\208\187\208\186\208\176 \208\189\208\176 \209\129\208\181\209\128\208\178\208\181\209\128 \209\129\208\186\208\190\208\191\208\184\209\128\208\190\208\178\208\176\208\189\208\176",
        ["Auto Skip"] = "\208\144\208\178\209\130\208\190\209\129\208\186\208\184\208\191", ["Skips every wave as soon as it starts"] = "\208\159\209\128\208\190\208\191\209\131\209\129\208\186\208\176\208\181\209\130 \208\186\208\176\208\182\208\180\209\131\209\142 \208\178\208\190\208\187\208\189\209\131 \209\129\209\128\208\176\208\183\209\131 \208\191\208\190\209\129\208\187\208\181 \208\181\209\145 \208\189\208\176\209\135\208\176\208\187\208\176",
        ["Auto Vote Mode"] = "\208\144\208\178\209\130\208\190\208\179\208\190\208\187\208\190\209\129\208\190\208\178\208\176\208\189\208\184\208\181 \208\183\208\176 \209\128\208\181\208\182\208\184\208\188", ["Votes for the selected mode on the vote screen"] = "\208\147\208\190\208\187\208\190\209\129\209\131\208\181\209\130 \208\183\208\176 \208\178\209\139\208\177\209\128\208\176\208\189\208\189\209\139\208\185 \209\128\208\181\208\182\208\184\208\188 \208\189\208\176 \209\141\208\186\209\128\208\176\208\189\208\181 \208\179\208\190\208\187\208\190\209\129\208\190\208\178\208\176\208\189\208\184\209\143",
        ["Auto Speed"] = "\208\144\208\178\209\130\208\190\209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140", ["Keeps the selected game speed on every wave"] = "\208\148\208\181\209\128\208\182\208\184\209\130 \208\178\209\139\208\177\209\128\208\176\208\189\208\189\209\131\209\142 \209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140 \208\184\208\179\209\128\209\139 \208\189\208\176 \208\186\208\176\208\182\208\180\208\190\208\185 \208\178\208\190\208\187\208\189\208\181",
        ["Auto Play Again"] = "\208\144\208\178\209\130\208\190\208\191\208\190\208\178\209\130\208\190\209\128", ["Presses Play Again on the result screen"] = "\208\157\208\176\208\182\208\184\208\188\208\176\208\181\209\130 Play Again \208\189\208\176 \209\141\208\186\209\128\208\176\208\189\208\181 \209\128\208\181\208\183\209\131\208\187\209\140\209\130\208\176\209\130\208\190\208\178",
        ["Auto Leave Lobby"] = "\208\144\208\178\209\130\208\190\208\178\209\139\209\133\208\190\208\180 \208\178 \208\187\208\190\208\177\208\177\208\184", ["Leaves to the lobby from the result screen (instead of Play Again)"] = "\208\146\209\139\209\133\208\190\208\180\208\184\209\130 \208\178 \208\187\208\190\208\177\208\177\208\184 \209\129 \209\141\208\186\209\128\208\176\208\189\208\176 \209\128\208\181\208\183\209\131\208\187\209\140\209\130\208\176\209\130\208\190\208\178 \208\178\208\188\208\181\209\129\209\130\208\190 \208\191\208\190\208\178\209\130\208\190\209\128\208\176 \208\188\208\176\209\130\209\135\208\176",
        ["Mode Vote"] = "\208\160\208\181\208\182\208\184\208\188 \208\179\208\190\208\187\208\190\209\129\208\190\208\178\208\176\208\189\208\184\209\143", ["Game Speed"] = "\208\161\208\186\208\190\209\128\208\190\209\129\209\130\209\140 \208\184\208\179\209\128\209\139",
        ["Auto Summon 1"] = "\208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 x1", ["Opens one crate at a time, nonstop (lobby only)"] = "\208\158\209\130\208\186\209\128\209\139\208\178\208\176\208\181\209\130 \208\191\208\190 \208\190\208\180\208\189\208\190\208\188\209\131 \209\143\209\137\208\184\208\186\209\131 \208\177\208\181\208\183 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\186\208\184, \209\130\208\190\208\187\209\140\208\186\208\190 \208\178 \208\187\208\190\208\177\208\177\208\184",
        ["Auto Summon 10"] = "\208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 x10", ["Opens ten crates per summon, nonstop (lobby only)"] = "\208\158\209\130\208\186\209\128\209\139\208\178\208\176\208\181\209\130 \208\191\208\190 \208\180\208\181\209\129\209\143\209\130\209\140 \209\143\209\137\208\184\208\186\208\190\208\178 \208\183\208\176 \209\128\208\176\208\183 \208\177\208\181\208\183 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\186\208\184, \209\130\208\190\208\187\209\140\208\186\208\190 \208\178 \208\187\208\190\208\177\208\177\208\184",
        ["Summon Delay"] = "\208\151\208\176\208\180\208\181\209\128\208\182\208\186\208\176 \208\191\209\128\208\184\208\183\209\139\208\178\208\176", ["Seconds between summon requests. Raise it if the server drops requests"] = "\208\161\208\186\208\190\208\187\209\140\208\186\208\190 \209\129\208\181\208\186\209\131\208\189\208\180 \208\191\209\128\208\190\209\133\208\190\208\180\208\184\209\130 \208\188\208\181\208\182\208\180\209\131 \208\183\208\176\208\191\209\128\208\190\209\129\208\176\208\188\208\184 \208\191\209\128\208\184\208\183\209\139\208\178\208\176. \208\163\208\178\208\181\208\187\208\184\209\135\209\140, \208\181\209\129\208\187\208\184 \209\129\208\181\209\128\208\178\208\181\209\128 \209\130\208\181\209\128\209\143\208\181\209\130 \208\183\208\176\208\191\209\128\208\190\209\129\209\139",
        ["Auto Claim Quests"] = "\208\144\208\178\209\130\208\190\209\129\208\177\208\190\209\128 \208\186\208\178\208\181\209\129\209\130\208\190\208\178", ["Claims finished quests as soon as the server reports them"] = "\208\151\208\176\208\177\208\184\209\128\208\176\208\181\209\130 \208\189\208\176\208\179\209\128\208\176\208\180\209\139 \208\183\208\176 \208\178\209\139\208\191\208\190\208\187\208\189\208\181\208\189\208\189\209\139\208\181 \208\186\208\178\208\181\209\129\209\130\209\139, \208\186\208\176\208\186 \209\130\208\190\208\187\209\140\208\186\208\190 \209\129\208\181\209\128\208\178\208\181\209\128 \208\184\209\133 \209\129\208\190\208\190\208\177\209\137\208\184\209\130",
  ["Auto Teleport To Map"] = "\208\144\208\178\209\130\208\190\209\130\208\181\208\187\208\181\208\191\208\190\209\128\209\130 \208\189\208\176 \208\186\208\176\209\128\209\130\209\131", ["Enters the selected map elevator and starts it (lobby only)"] = "\208\151\208\176\209\133\208\190\208\180\208\184\209\130 \208\178 \208\187\208\184\209\132\209\130 \208\178\209\139\208\177\209\128\208\176\208\189\208\189\208\190\208\185 \208\186\208\176\209\128\209\130\209\139 \208\184 \208\183\208\176\208\191\209\131\209\129\208\186\208\176\208\181\209\130 \208\181\208\179\208\190, \209\130\208\190\208\187\209\140\208\186\208\190 \208\178 \208\187\208\190\208\177\208\177\208\184",
        ["Map"] = "\208\154\208\176\209\128\209\130\208\176",
        ["Skip Barriers"] = "\208\145\208\176\209\128\209\140\208\181\209\128\209\139 \209\129\208\186\208\184\208\191\208\176",
        ["e.g. 10, 25, 40"] = "\208\189\208\176\208\191\209\128\208\184\208\188\208\181\209\128 10, 25, 40",
        ["Place Anywhere"] = "\208\161\209\130\208\176\208\178\208\184\209\130\209\140 \208\178\208\181\208\183\208\180\208\181",
        ["Lets you place units on any ground and inside other units. The server may still refuse some spots"] =
            "\208\159\208\190\208\183\208\178\208\190\208\187\209\143\208\181\209\130 \209\129\239\191\189\239\191\189\208\176\208\178\208\184\239\191\189\239\191\189\209\140 \209\142\208\189\208\184\209\130\208\190\208\178 \208\189\208\176 \208\187\209\142\208\177\209\131\209\142 \208\183\208\181\208\188\208\187\209\142 \208\184 \208\178\208\189\209\131\209\130\209\128\209\140 \208\180\209\128\209\131\208\179\208\184\209\133 \209\142\208\189\208\184\209\130\208\190\208\178. \208\161\208\181\209\128\208\178\208\181\209\128 \208\178\209\129\209\145 \209\128\208\176\208\178\208\189\208\190 \208\188\208\190\208\182\208\181\209\130 \208\190\209\130\208\186\208\176\208\183\208\176\209\130\209\140 \208\189\208\176 \208\189\208\181\208\186\208\190\209\130\208\190\209\128\209\139\209\133 \208\188\208\181\209\129\209\130\208\176\209\133",
        ["Auto Sell Farms"] = "\208\144\208\178\209\130\208\190\208\191\209\128\208\190\208\180\208\176\208\182\208\176 \209\132\208\181\209\128\208\188", ["e.g. 50"] = "\208\189\208\176\208\191\209\128\208\184\208\188\208\181\209\128 50",
        ["Sells every farm unit when this wave starts, so you get the refund and keep the cash. Empty = farms are never sold"] =
            "\208\159\209\128\208\190\208\180\208\176\209\145\209\130 \208\178\209\129\208\181 \209\132\208\181\209\128\208\188\209\139, \208\186\208\190\208\179\208\180\208\176 \208\189\208\176\209\135\208\184\208\189\208\176\208\181\209\130\209\129\209\143 \209\141\209\130\208\176 \208\178\208\190\208\187\208\189\208\176: \208\178\208\190\208\183\208\178\209\128\208\176\209\137\208\176\208\181\209\130\209\129\209\143 \209\129\209\130\208\190\208\184\208\188\208\190\209\129\209\130\209\140 \208\184 \208\180\208\181\208\189\209\140\208\179\208\184 \208\190\209\129\209\130\208\176\209\142\209\130\209\129\209\143 \209\131 \209\130\208\181\208\177\209\143. \208\159\209\131\209\129\209\130\208\190 \208\190\208\183\208\189\208\176\209\135\208\176\208\181\209\130 \209\132\208\181\209\128\208\188\209\139 \208\189\208\181 \208\191\209\128\208\190\208\180\208\176\209\142\209\130\209\129\209\143",
        ["Waves that Auto Skip will not touch, separated by commas. Each barrier wave and the pause after it play out on their own, skipping resumes on the next wave. Empty = no barriers"] =
            "\208\146\208\190\208\187\208\189\209\139, \208\186\208\190\209\130\208\190\209\128\209\139\208\181 \208\176\208\178\209\130\208\190\209\129\208\186\208\184\208\191 \208\189\208\181 \209\130\209\128\208\190\208\179\208\176\208\181\209\130, \209\135\208\181\209\128\208\181\208\183 \208\183\208\176\208\191\209\143\209\130\209\131\209\142. \208\146\208\190\208\187\208\189\208\176-\208\177\208\176\209\128\209\140\208\181\209\128 \208\184 \208\191\208\176\209\131\208\183\208\176 \208\191\208\190\209\129\208\187\208\181 \208\189\208\181\209\145 \208\191\209\128\208\190\209\133\208\190\208\180\209\143\209\130 \209\129\208\176\208\188\208\184, \209\129\208\186\208\184\208\191 \208\178\208\190\208\183\208\190\208\177\208\189\208\190\208\178\208\187\209\143\208\181\209\130\209\129\209\143 \209\129\208\190 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\181\208\185 \208\178\208\190\208\187\208\189\209\139. \208\159\209\131\209\129\209\130\208\190 \208\190\208\183\208\189\208\176\209\135\208\176\208\181\209\130 \208\177\208\181\208\183 \208\177\208\176\209\128\209\140\208\181\209\128\208\190\208\178",
        ["Record"] = "\208\151\208\176\208\191\208\184\209\129\209\140",
        ["Records the units you place, upgrade, sell and retarget by hand. Saved by itself when the round ends (macro #1, #2, ... or the typed name)"] =
            "\208\151\208\176\208\191\208\184\209\129\209\139\208\178\208\176\208\181\209\130 \209\142\208\189\208\184\209\130\208\190\208\178, \208\186\208\190\209\130\208\190\209\128\209\139\209\133 \209\130\209\139 \209\129\209\130\208\176\208\178\208\184\209\136\209\140, \209\131\208\187\209\131\209\135\209\136\208\176\208\181\209\136\209\140, \208\191\209\128\208\190\208\180\208\176\209\145\209\136\209\140 \208\184 \208\191\208\181\209\128\208\181\208\189\208\176\209\134\208\181\208\187\208\184\208\178\208\176\208\181\209\136\209\140 \208\178\209\128\209\131\209\135\208\189\209\131\209\142. \208\146 \208\186\208\190\208\189\209\134\208\181 \209\128\208\176\209\131\208\189\208\180\208\176 \208\183\208\176\208\191\208\184\209\129\209\140 \209\129\208\190\209\133\209\128\208\176\208\189\209\143\208\181\209\130\209\129\209\143 \209\129\208\176\208\188\208\176 \208\191\208\190\208\180 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\184\208\188 \208\189\208\190\208\188\208\181\209\128\208\190\208\188 \208\184\208\187\208\184 \208\191\208\190\208\180 \208\178\208\178\208\181\208\180\209\145\208\189\208\189\209\139\208\188 \208\189\208\176\208\183\208\178\208\176\208\189\208\184\208\181\208\188.",
        ["Play Macro"] = "\208\151\208\176\208\191\209\131\209\129\208\186 \208\188\208\176\208\186\209\128\208\190",
        ["Replays the selected macro in every match. Units are bought and upgraded the moment there is enough money, without waiting for a wave; only sells keep their wave and time. Saved in configs: autofarm starts by itself"] =
            "\208\159\208\190\208\178\209\130\208\190\209\128\209\143\208\181\209\130 \208\178\209\139\208\177\209\128\208\176\208\189\208\189\208\190\208\181 \208\188\208\176\208\186\209\128\208\190 \208\178 \208\186\208\176\208\182\208\180\208\190\208\188 \208\188\208\176\209\130\209\135\208\181. \208\174\208\189\208\184\209\130\209\139 \208\191\208\190\208\186\209\131\208\191\208\176\209\142\209\130\209\129\209\143 \208\184 \209\131\208\187\209\131\209\135\209\136\208\176\209\142\209\130\209\129\209\143, \208\186\208\176\208\186 \209\130\208\190\208\187\209\140\208\186\208\190 \209\133\208\178\208\176\209\130\208\176\208\181\209\130 \208\180\208\181\208\189\208\181\208\179, \208\177\208\181\208\183 \208\190\208\182\208\184\208\180\208\176\208\189\208\184\209\143 \208\178\208\190\208\187\208\189\209\139; \209\130\208\190\208\187\209\140\208\186\208\190 \208\191\209\128\208\190\208\180\208\176\208\182\208\184 \209\129\208\190\209\133\209\128\208\176\208\189\209\143\209\142\209\130 \209\129\208\178\208\190\209\142 \208\178\208\190\208\187\208\189\209\131 \208\184 \208\178\209\128\208\181\208\188\209\143. \208\161\208\190\209\129\209\130\208\190\209\143\208\189\208\184\208\181 \209\133\209\128\208\176\208\189\208\184\209\130\209\129\209\143 \208\178 \208\186\208\190\208\189\209\132\208\184\208\179\208\181, \208\191\208\190\209\141\209\130\208\190\208\188\209\131 \208\176\208\178\209\130\208\190\209\132\208\176\209\128\208\188 \208\183\208\176\208\191\209\131\209\129\208\186\208\176\208\181\209\130\209\129\209\143 \209\129\208\176\208\188",
        ["No hookmetamethod: steps are recorded from server echoes, timing is approximate"] = "\208\157\208\181\209\130 hookmetamethod: \209\136\208\176\208\179\208\184 \208\183\208\176\208\191\208\184\209\129\209\139\208\178\208\176\209\142\209\130\209\129\209\143 \208\191\208\190 \208\190\209\130\208\178\208\181\209\130\208\176\208\188 \209\129\208\181\209\128\208\178\208\181\209\128\208\176, \208\178\209\128\208\181\208\188\209\143 \208\191\209\128\208\184\208\177\208\187\208\184\208\183\208\184\209\130\208\181\208\187\209\140\208\189\208\190\208\181",
        ["Units already on the field are not recorded: start with an empty field"] = "\208\174\208\189\208\184\209\130\209\139, \209\131\208\182\208\181 \209\129\209\130\208\190\209\143\209\137\208\184\208\181 \208\189\208\176 \208\191\208\190\208\187\208\181, \208\189\239\191\189\239\191\189 \208\183\208\176\208\191\208\184\209\129\209\139\208\178\208\176\209\142\209\130\209\129\209\143: \208\189\208\176\209\135\208\184\208\189\208\176\208\185 \209\129 \208\191\209\131\209\129\209\130\239\191\189\239\191\189\208\179\208\190 \208\191\208\190\208\187\209\143",
        ["idle"] = "\208\191\209\128\208\190\209\129\209\130\208\190\208\185", ["Clear Steps"] = "\208\158\209\135\208\184\209\129\209\130\208\184\209\130\209\140 \209\136\208\176\208\179\208\184", ["Name"] = "\208\157\208\176\208\183\208\178\208\176\208\189\208\184\208\181", ["macro name"] = "\208\189\208\176\208\183\208\178\208\176\208\189\208\184\208\181 \208\188\208\176\208\186\209\128\208\190",
        ["Pick a saved macro: it is loaded right away, then press Play Macro"] = "\208\146\209\139\208\177\208\181\209\128\208\184 \209\129\208\190\209\133\209\128\208\176\208\189\209\145\208\189\208\189\208\190\208\181 \208\188\208\176\208\186\209\128\208\190, \208\190\208\189\208\190 \208\183\208\176\208\179\209\128\209\131\208\183\208\184\209\130\209\129\209\143 \209\129\209\128\208\176\208\183\209\131, \208\191\208\190\209\129\208\187\208\181 \209\135\208\181\208\179\208\190 \208\178\208\186\208\187\209\142\209\135\208\184 \208\151\208\176\208\191\209\131\209\129\208\186 \208\188\208\176\208\186\209\128\208\190",
        ["Anti AFK"] = "\208\151\208\176\209\137\208\184\209\130\208\176 \208\190\209\130 \208\144\208\164\208\154", ["Stops the game from kicking you for being idle"] = "\208\157\208\181 \208\180\208\176\209\145\209\130 \208\184\208\179\209\128\208\181 \208\178\209\139\208\186\208\184\208\189\209\131\209\130\209\140 \209\130\208\181\208\177\209\143 \208\183\208\176 \208\177\208\181\208\183\208\180\208\181\208\185\209\129\209\130\208\178\208\184\208\181",
        ["Unlock FPS"] = "\208\161\208\189\209\143\209\130\209\140 \208\187\208\184\208\188\208\184\209\130 FPS", ["Raises the FPS cap to the value of the slider below (needs setfpscap)"] = "\208\159\208\190\208\180\208\189\208\184\208\188\208\176\208\181\209\130 \208\187\208\184\208\188\208\184\209\130 \208\186\208\176\208\180\209\128\208\190\208\178 \208\180\208\190 \208\183\208\189\208\176\209\135\208\181\208\189\208\184\209\143 \208\189\208\176 \208\191\208\190\208\187\208\183\209\131\208\189\208\186\208\181 \208\189\208\184\208\182\208\181, \208\189\209\131\208\182\208\189\208\176 \209\132\209\131\208\189\208\186\209\134\208\184\209\143 setfpscap",
        ["FPS Limit"] = "\208\155\208\184\208\188\208\184\209\130 FPS",
        ["Auto Save After The Match Ends"] = "\208\144\208\178\209\130\208\190\209\129\208\190\209\133\209\128\208\176\208\189\208\181\208\189\208\184\208\181 \208\191\208\190\209\129\208\187\208\181 \208\186\208\190\208\189\209\134\208\176 \208\188\208\176\209\130\209\135\208\176",
        ["Saves the recording by itself when the round ends. When off, the steps stay loaded and you save them with the Save button"] =
            "\208\161\208\190\209\133\209\128\208\176\208\189\209\143\208\181\209\130 \208\183\208\176\208\191\208\184\209\129\209\140 \209\129\208\176\208\188\208\176, \208\186\208\190\208\179\208\180\208\176 \209\128\208\176\209\131\208\189\208\180 \208\183\208\176\208\186\208\176\208\189\209\135\208\184\208\178\208\176\208\181\209\130\209\129\209\143. \208\149\209\129\208\187\208\184 \208\178\209\139\208\186\208\187\209\142\209\135\208\184\209\130\209\140, \209\136\208\176\208\179\208\184 \208\190\209\129\209\130\208\176\208\189\209\131\209\130\209\129\209\143 \208\183\208\176\208\179\209\128\209\131\208\182\208\181\208\189\208\189\209\139\208\188\208\184, \208\176 \209\129\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\140 \208\184\209\133 \208\188\208\190\208\182\208\189\208\190 \208\186\208\189\208\190\208\191\208\186\208\190\208\185 \208\161\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\140.",
        ["Noclip"] = "\208\157\208\190\208\186\208\187\208\184\208\191", ["Walk through walls and other solid objects"] = "\208\159\208\190\208\183\208\178\208\190\208\187\209\143\208\181\209\130 \208\191\209\128\208\190\209\133\208\190\208\180\208\184\209\130\209\140 \209\129\208\186\208\178\208\190\208\183\209\140 \209\129\209\130\208\181\208\189\209\139 \208\184 \208\180\209\128\209\131\208\179\208\184\208\181 \209\130\208\178\209\145\209\128\208\180\209\139\208\181 \208\190\208\177\209\138\208\181\208\186\209\130\209\139",
        ["Speed"] = "\208\161\208\186\208\190\209\128\208\190\209\129\209\130\209\140", ["Overrides your walk speed with the value of the slider below"] = "\208\151\208\176\208\188\208\181\208\189\209\143\208\181\209\130 \209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140 \209\133\208\190\208\180\209\140\208\177\209\139 \208\183\208\189\208\176\209\135\208\181\208\189\208\184\208\181\208\188 \209\129 \208\191\208\190\208\187\208\183\209\131\208\189\208\186\208\176 \208\189\208\184\208\182\208\181",
        ["Walk Speed"] = "\208\161\208\186\208\190\209\128\208\190\209\129\209\130\209\140 \209\133\208\190\208\180\209\140\208\177\209\139",
        ["Fly"] = "\208\159\208\190\208\187\209\145\209\130", ["Flies like Infinite Yield: you move along the camera. W/A/S/D or the thumbstick to move, E or Space up, Q or Ctrl down. Combine with Noclip to pass through walls"] = "\208\159\208\190\208\187\209\145\209\130 \208\186\208\176\208\186 \208\178 Infinite Yield: \208\180\208\178\208\184\208\182\208\181\209\136\209\140\209\129\209\143 \208\178\208\180\208\190\208\187\209\140 \208\186\208\176\208\188\208\181\209\128\209\139. W/A/S/D \208\184\208\187\208\184 \209\129\209\130\208\184\208\186 \208\180\208\187\209\143 \208\180\208\178\208\184\208\182\208\181\239\191\189\239\191\189\239\191\189\208\184\209\143, E \208\184\208\187\208\184 \208\191\209\128\208\190\208\177\208\181\208\187 \208\178\208\178\208\181\209\128\209\133, Q \208\184\208\187\208\184 Ctrl \208\178\208\189\208\184\208\183. \208\146\208\188\208\181\209\129\209\130\208\181 \209\129 \208\157\208\190\208\186\208\187\208\184\208\191\208\190\208\188 \208\188\208\190\208\182\208\189\208\190 \208\191\209\128\208\190\208\187\208\181\209\130\208\176\209\130\209\140 \209\129\208\186\208\178\208\190\208\183\209\140 \209\129\209\130\208\181\208\189\209\139",
        ["Fly Speed"] = "\208\161\208\186\208\190\209\128\208\190\209\129\209\130\209\140 \208\191\208\190\208\187\209\145\209\130\208\176",
        ["No Fog"] = "\208\145\208\181\208\183 \209\130\209\131\208\188\208\176\208\189\208\176", ["Removes fog and atmosphere haze so you can see far. Does not change brightness"] = "\208\163\208\177\208\184\209\128\208\176\208\181\209\130 \209\130\209\131\208\188\208\176\208\189 \208\184 \208\180\209\139\208\188\208\186\209\131 \208\176\209\130\208\188\208\190\209\129\209\132\208\181\209\128\209\139, \208\178\208\184\208\180\208\189\208\190 \208\180\208\176\208\187\208\181\208\186\208\190. \208\175\209\128\208\186\208\190\209\129\209\130\209\140 \208\189\208\181 \208\188\208\181\208\189\209\143\208\181\209\130",
        ["Full Bright"] = "\208\159\208\190\208\187\208\189\208\176\209\143 \209\143\209\128\208\186\208\190\209\129\209\130\209\140", ["Removes darkness and fog so everything is lit"] = "\208\163\208\177\208\184\209\128\208\176\208\181\209\130 \209\130\208\181\208\188\208\189\208\190\209\130\209\131 \208\184 \209\130\209\131\208\188\208\176\208\189, \208\178\208\181\208\183\208\180\208\181 \209\129\209\130\239\191\189\239\191\189\208\189\208\190\208\178\208\184\209\130\209\129\209\143 \209\129\208\178\208\181\209\130\208\187\208\190",
        ["Auto Execute"] = "\208\144\208\178\209\130\208\190\208\183\208\176\208\191\209\131\209\129\208\186",
        ["Reruns the script after every teleport (Play Again, lobby and match)"] = "\208\159\208\181\209\128\208\181\208\183\208\176\208\191\209\131\209\129\208\186\208\176\208\181\209\130 \209\129\208\186\209\128\208\184\208\191\209\130 \208\191\208\190\209\129\208\187\208\181 \208\186\208\176\208\182\208\180\208\190\208\179\208\190 \209\130\208\181\208\187\208\181\208\191\208\190\209\128\209\130\208\176 (Play Again, \208\187\208\190\208\177\208\177\208\184 \208\184 \208\188\208\176\209\130\209\135)",
        ["Language"] = "\208\175\208\183\209\139\208\186",
        ["Save"] = "\208\161\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\140", ["Load"] = "\208\151\208\176\208\179\209\128\209\131\208\183\208\184\209\130\209\140", ["Delete"] = "\208\163\208\180\208\176\208\187\208\184\209\130\209\140",
        ["Save failed"] = "\208\157\208\181 \209\131\208\180\208\176\208\187\208\190\209\129\209\140 \209\129\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\140",
        ["Theme"] = "\208\162\208\181\208\188\208\176", ["Dark"] = "\208\162\209\145\208\188\208\189\208\176\209\143", ["Light"] = "\208\161\208\178\208\181\209\130\208\187\208\176\209\143", ["Midnight"] = "\208\159\208\190\208\187\208\189\208\190\209\135\209\140", ["Ocean"] = "\208\158\208\186\208\181\208\176\208\189",
        ["Accent Color"] = "\208\166\208\178\208\181\209\130 \208\176\208\186\209\134\208\181\208\189\209\130\208\176", ["Transparency"] = "\208\159\209\128\208\190\208\183\209\128\208\176\209\135\208\189\208\190\209\129\209\130\209\140", ["UI Scale"] = "\208\156\208\176\209\129\209\136\209\130\208\176\208\177 \208\184\208\189\209\130\208\181\209\128\209\132\208\181\208\185\209\129\208\176",
        ["Lock UI"] = "\208\151\208\176\208\186\209\128\208\181\208\191\208\184\209\130\209\140 \208\190\208\186\208\189\208\190", ["Disables dragging and resizing the window"] = "\208\151\208\176\208\191\209\128\208\181\209\137\208\176\208\181\209\130 \208\191\208\181\209\128\208\181\209\130\208\176\209\129\208\186\208\184\208\178\208\176\209\130\209\140 \208\190\208\186\208\189\208\190 \208\184 \208\188\208\181\208\189\209\143\209\130\209\140 \208\181\208\179\208\190 \209\128\208\176\208\183\208\188\208\181\209\128",
        ["Toggle UI Key"] = "\208\154\208\187\208\176\208\178\208\184\209\136\208\176 \208\188\208\181\208\189\209\142", ["Reset Window Position"] = "\208\161\208\177\209\128\208\190\209\129\208\184\209\130\209\140 \208\191\208\190\208\187\208\190\208\182\208\181\208\189\208\184\208\181 \208\190\208\186\208\189\208\176",
        ["Auto Leave Lobby: OnLeave remote not found"] = "\208\144\208\178\209\130\208\190\208\178\209\139\209\133\208\190\208\180 \208\178 \208\187\208\190\208\177\208\177\208\184 \208\189\208\181 \209\128\208\176\208\177\208\190\209\130\208\176\208\181\209\130, \209\128\208\181\208\188\208\190\209\131\209\130 OnLeave \208\189\208\181 \208\189\208\176\208\185\208\180\208\181\208\189",
        ["Auto Summon stopped: not enough money"] = "\208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\187\208\181\208\189, \208\189\208\181 \209\133\208\178\208\176\209\130\208\176\208\181\209\130 \208\180\208\181\208\189\208\181\208\179",
        ["Unknown tower: place towers after the script starts"] = "\208\157\208\181\208\184\208\183\208\178\208\181\209\129\209\130\208\189\208\176\209\143 \208\177\208\176\209\136\208\189\209\143. \208\161\209\130\208\176\208\178\209\140 \208\177\208\176\209\136\208\189\208\184 \209\130\208\190\208\187\209\140\208\186\208\190 \208\191\208\190\209\129\208\187\208\181 \208\183\208\176\208\191\209\131\209\129\208\186\208\176 \209\129\208\186\209\128\208\184\208\191\209\130\208\176",
        ["Placement rejected, not recorded"] = "\208\163\209\129\209\130\208\176\208\189\208\190\208\178\208\186\209\131 \208\190\209\130\208\186\208\187\208\190\208\189\208\184\208\187\208\184, \208\178 \208\183\208\176\208\191\208\184\209\129\209\140 \208\190\208\189\208\176 \208\189\208\181 \208\191\208\190\208\191\208\176\208\187\208\176",
        ["Recording stopped: new match"] = "\208\151\208\176\208\191\208\184\209\129\209\140 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\187\208\181\208\189\208\176, \208\189\208\176\209\135\208\176\208\187\209\129\209\143 \208\189\208\190\208\178\209\139\208\185 \208\188\208\176\209\130\209\135",
        ["Place failed, step skipped"] = "\208\157\208\181 \209\131\208\180\208\176\208\187\208\190\209\129\209\140 \208\191\208\190\209\129\209\130\208\176\208\178\208\184\209\130\209\140 \209\142\208\189\208\184\209\130\208\176, \209\136\208\176\208\179 \208\191\209\128\208\190\208\191\209\131\209\137\208\181\208\189",
        ["Auto Modifier"] = "\208\144\208\178\209\130\208\190 \208\188\208\190\208\180\208\184\209\132\208\184\208\186\208\176\209\130\208\190\209\128",
        ["Selects the ticked modifiers when you enter a map elevator, by hand or with Auto Teleport (lobby only)"] =
            "\208\146\209\139\208\177\208\184\209\128\208\176\208\181\209\130 \208\190\209\130\208\188\208\181\209\135\208\181\208\189\208\189\209\139\208\181 \208\188\208\190\208\180\208\184\209\132\208\184\208\186\208\176\209\130\208\190\209\128\209\139 \208\191\209\128\208\184 \208\178\209\133\208\190\208\180\208\181 \208\178 \208\187\208\184\209\132\209\130 \208\186\208\176\209\128\209\130\209\139, \208\178\209\128\209\131\209\135\208\189\209\131\209\142 \208\184\208\187\208\184 \239\191\189\239\191\189\208\181\209\128\208\181\208\183 \208\144\208\178\209\130\208\190 \209\130\208\181\208\187\208\181\208\191\208\190\209\128\209\130 (\209\130\208\190\208\187\209\140\208\186\208\190 \208\178 \208\187\208\190\208\177\208\177\208\184)",
        ["X2 Toilets HP"] = "X2 HP \209\130\209\131\208\176\208\187\208\181\209\130\208\190\208\178",
        ["X2 Toilets Speed"] = "X2 \209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140 \209\130\209\131\208\176\208\187\208\181\209\130\208\190\208\178",
        ["Modifier Hp_Mobs: toilets have twice the health"] = "\208\156\208\190\208\180\208\184\209\132\208\184\208\186\208\176\209\130\208\190\209\128 Hp_Mobs: \209\131 \209\130\209\131\208\176\208\187\208\181\209\130\208\190\208\178 \208\178\208\180\208\178\208\190\208\181 \208\177\208\190\208\187\209\140\209\136\208\181 \208\183\208\180\208\190\209\128\208\190\208\178\209\140\209\143",
        ["Modifier Speed_Mobs: toilets move twice as fast"] = "\208\156\208\190\208\180\208\184\209\132\208\184\208\186\208\176\209\130\208\190\209\128 Speed_Mobs: \209\130\209\131\208\176\208\187\208\181\209\130\209\139 \208\180\208\178\208\184\208\182\209\131\209\130\209\129\209\143 \208\178\208\180\208\178\208\190\208\181 \208\177\209\139\209\129\209\130\209\128\208\181\208\181",
        ["Auto Modifier: no confirmation from the server"] = "\208\144\208\178\209\130\208\190 \208\188\208\190\208\180\208\184\209\132\208\184\208\186\208\176\209\130\208\190\209\128: \209\129\208\181\209\128\208\178\208\181\209\128 \208\189\208\181 \208\191\208\190\208\180\209\130\208\178\208\181\209\128\208\180\208\184\208\187 \208\178\209\139\208\177\208\190\209\128",
        ["Game config not found: prices come from the recorded steps"] = "\208\154\208\190\208\189\209\132\208\184\208\179 \208\184\208\179\209\128\209\139 \208\189\208\181 \208\189\208\176\208\185\208\180\208\181\208\189, \209\134\208\181\208\189\209\139 \208\177\208\181\209\128\209\131\209\130\209\129\209\143 \208\184\208\183 \208\183\208\176\208\191\208\184\209\129\208\176\208\189\208\189\209\139\209\133 \209\136\208\176\208\179\208\190\208\178",
        ["Macro calibrated: prices saved"] = "\208\156\208\176\208\186\209\128\208\190 \208\190\209\130\208\186\208\176\208\187\208\184\208\177\209\128\208\190\208\178\208\176\208\189\208\190, \209\134\208\181\208\189\209\139 \209\129\208\190\209\133\209\128\208\176\208\189\208\181\208\189\209\139",
        ["Macro finished, waiting for the next match"] = "\208\156\208\176\208\186\209\128\208\190 \208\178\209\139\208\191\208\190\208\187\208\189\208\181\208\189\208\190, \208\182\208\180\209\145\208\188 \209\129\208\187\208\181\208\180\209\131\209\142\209\137\208\184\208\185 \208\188\208\176\209\130\209\135",
        ["Enter a macro name first"] = "\208\161\208\189\208\176\209\135\208\176\208\187\208\176 \208\178\208\178\208\181\208\180\208\184 \208\189\208\176\208\183\208\178\208\176\208\189\208\184\208\181 \208\188\208\176\208\186\209\128\208\190",
        ["Nothing to save: record a macro first"] = "\208\161\208\190\209\133\209\128\208\176\208\189\209\143\209\130\209\140 \208\189\208\181\209\135\208\181\208\179\208\190, \209\129\208\189\208\176\209\135\208\176\208\187\208\176 \208\183\208\176\208\191\208\184\209\136\208\184 \208\188\208\176\208\186\209\128\208\190",
        ["Pick a saved macro to delete"] = "\208\146\209\139\208\177\208\181\209\128\208\184 \209\129\208\190\209\133\209\128\208\176\208\189\209\145\208\189\208\189\208\190\208\181 \208\188\208\176\208\186\209\128\208\190, \208\186\208\190\209\130\208\190\209\128\208\190\208\181 \208\189\209\131\208\182\208\189\208\190 \209\131\208\180\208\176\208\187\208\184\209\130\209\140",
        ["Delete failed"] = "\208\157\208\181 \209\131\208\180\208\176\208\187\208\190\209\129\209\140 \209\131\208\180\208\176\208\187\208\184\209\130\209\140", ["Auto-save failed"] = "\208\157\208\181 \209\131\208\180\208\176\208\187\208\190\209\129\209\140 \209\129\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\140 \208\176\208\178\209\130\208\190\208\188\208\176\209\130\208\184\209\135\208\181\209\129\208\186\208\184",
        ["Auto Leave Lobby turned off: Play Again is on"] = "\208\144\208\178\209\130\208\190\208\178\209\139\209\133\208\190\208\180 \208\178 \208\187\208\190\208\177\208\177\208\184 \208\178\209\139\208\186\208\187\209\142\209\135\208\181\208\189, \208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \208\178\208\186\208\187\209\142\209\135\209\145\208\189 \208\144\208\178\209\130\208\190\208\191\208\190\208\178\209\130\208\190\209\128",
        ["Auto Play Again turned off: Leave Lobby is on"] = "\208\144\208\178\209\130\208\190\208\191\208\190\208\178\209\130\208\190\209\128 \208\178\209\139\208\186\208\187\209\142\209\135\208\181\208\189, \208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \208\178\208\186\208\187\209\142\209\135\209\145\208\189 \208\144\208\178\209\130\208\190\208\178\209\139\209\133\208\190\208\180 \208\178 \208\187\208\190\208\177\208\177\208\184",
        ["Auto Summon 10 turned off: Summon 1 is on"] = "\208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 x10 \208\178\209\139\208\186\208\187\209\142\209\135\208\181\208\189, \208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \208\178\208\186\208\187\209\142\209\135\209\145\208\189 \208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 x1",
        ["Auto Summon 1 turned off: Summon 10 is on"] = "\208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 x1 \208\178\209\139\208\186\208\187\209\142\209\135\208\181\208\189, \208\191\208\190\209\130\208\190\208\188\209\131 \209\135\209\130\208\190 \208\178\208\186\208\187\209\142\209\135\209\145\208\189 \208\144\208\178\209\130\208\190\208\191\209\128\208\184\208\183\209\139\208\178 x10",
        ["Macro unavailable: game remotes missing"] = "\208\156\208\176\208\186\209\128\208\190 \208\189\208\181\208\180\208\190\239\191\189\239\191\189\209\130\209\131\208\191\208\189\208\190, \208\178 \208\184\208\179\209\128\208\181 \208\189\208\181 \208\189\208\176\208\185\208\180\208\181\208\189\209\139 \208\189\209\131\208\182\208\189\209\139\208\181 \209\128\208\181\208\188\208\190\209\131\209\130\209\139",
        ["Recording needs hookmetamethod (not supported here)"] = "\208\148\208\187\209\143 \208\183\208\176\208\191\208\184\209\129\208\184 \208\189\209\131\208\182\208\189\208\176 \209\132\209\131\208\189\208\186\209\134\208\184\209\143 hookmetamethod, \208\176 \208\183\208\180\208\181\209\129\209\140 \208\181\209\145 \208\189\208\181\209\130",
        ["Turn Play Macro off first"] = "\208\161\208\189\208\176\209\135\208\176\208\187\208\176 \208\178\209\139\208\186\208\187\209\142\209\135\208\184 \208\151\208\176\208\191\209\131\209\129\208\186 \208\188\208\176\208\186\209\128\208\190",
        ["Turn Record off first"] = "\208\161\208\189\208\176\209\135\208\176\208\187\208\176 \208\178\209\139\208\186\208\187\209\142\209\135\208\184 \208\151\208\176\239\191\189\239\191\189\208\184\209\129\209\140",
        ["Turn Record / Play off first"] = "\208\161\208\189\208\176\209\135\208\176\208\187\208\176 \208\178\209\139\208\186\208\187\209\142\209\135\208\184 \208\151\208\176\208\191\208\184\209\129\209\140 \208\184 \208\151\208\176\208\191\209\131\209\129\208\186 \208\188\208\176\208\186\209\128\208\190",
        ["Recording: it is saved by itself when the round ends"] = "\208\152\208\180\209\145\209\130 \208\183\208\176\208\191\208\184\209\129\209\140, \208\190\208\189\208\176 \209\129\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\129\209\143 \209\129\208\176\208\188\208\176 \208\178 \208\186\208\190\208\189\209\134\208\181 \209\128\208\176\209\131\208\189\208\180\208\176",
        ["No steps: pick a saved macro or record one"] = "\208\168\208\176\208\179\208\190\208\178 \208\189\208\181\209\130. \208\146\209\139\208\177\208\181\209\128\208\184 \209\129\208\190\209\133\209\128\208\176\208\189\209\145\208\189\208\189\208\190\208\181 \208\188\208\176\208\186\209\128\208\190 \208\184\208\187\208\184 \208\183\208\176\208\191\208\184\209\136\208\184 \208\189\208\190\208\178\208\190\208\181",
        ["Macro armed: it replays every match"] = "\208\156\208\176\208\186\209\128\208\190 \208\178\208\186\208\187\209\142\209\135\208\181\208\189\208\190 \208\184 \208\177\209\131\208\180\208\181\209\130 \208\191\208\190\208\178\209\130\208\190\209\128\209\143\209\130\209\140\209\129\209\143 \208\178 \208\186\208\176\208\182\208\180\208\190\208\188 \208\188\208\176\209\130\209\135\208\181",
        ["Steps cleared"] = "\208\168\208\176\208\179\208\184 \208\190\209\135\208\184\209\137\208\181\208\189\209\139",
        ["No hookmetamethod: macro recording disabled"] = "\208\157\208\181\209\130 \209\132\209\131\208\189\208\186\209\134\208\184\208\184 hookmetamethod, \208\183\208\176\208\191\208\184\209\129\209\140 \208\188\208\176\208\186\209\128\208\190 \208\190\209\130\208\186\208\187\209\142\209\135\208\181\208\189\208\176",
        ["Macro disabled: missing game remotes"] = "\208\156\208\176\208\186\209\128\208\190 \208\190\209\130\208\186\208\187\209\142\209\135\208\181\208\189\208\190, \208\178 \208\184\208\179\209\128\208\181 \208\189\208\181 \208\189\208\176\208\185\208\180\208\181\208\189\209\139 \208\189\209\131\208\182\208\189\209\139\208\181 \209\128\208\181\208\188\208\190\209\131\209\130\209\139",
        ["Ready. RightShift or the diamond button hides the menu."] = "\208\147\208\190\209\130\208\190\208\178\208\190. \208\156\208\181\208\189\209\142 \209\129\208\186\209\128\209\139\208\178\208\176\208\181\209\130\209\129\209\143 \208\186\208\187\208\176\208\178\208\184\209\136\208\181\208\185 RightShift \208\184\208\187\208\184 \208\186\208\189\208\190\208\191\208\186\208\190\208\185 \209\129 \208\176\208\187\208\188\208\176\208\183\208\190\208\188.",
        ["All features are available"] = "\208\146\209\129\208\181 \209\132\209\131\208\189\208\186\209\134\208\184\208\184 \208\180\208\190\209\129\209\130\209\131\208\191\208\189\209\139", ["Some features are not available"] = "\208\167\208\176\209\129\209\130\209\140 \209\132\209\131\208\189\208\186\209\134\208\184\208\185 \208\189\208\181\208\180\208\190\209\129\209\130\209\131\208\191\208\189\208\176",
    }
    local SECTIONS = {
        ["Info"] = "\208\152\208\157\208\164\208\158\208\160\208\156\208\144\208\166\208\152\208\175", ["Executor checks"] = "\208\159\208\160\208\158\208\146\208\149\208\160\208\154\208\144 \208\173\208\154\208\161\208\159\208\155\208\158\208\153\208\162\208\144", ["Community"] = "\208\161\208\158\208\158\208\145\208\169\208\149\208\161\208\162\208\146\208\158",
        ["Inventory"] = "\208\152\208\157\208\146\208\149\208\157\208\162\208\144\208\160\208\172", ["Match"] = "\208\156\208\144\208\162\208\167", ["Game Options"] = "\208\157\208\144\208\161\208\162\208\160\208\158\208\153\208\154\208\152 \208\152\208\147\208\160\208\171", ["Lobby"] = "\239\191\189\239\191\189\239\191\189\239\191\189\208\145\208\145\208\152",
        ["Recorder"] = "\208\151\208\144\208\159\208\152\208\161\208\172", ["Saved Macros"] = "\208\161\208\158\208\165\208\160\208\144\208\157\208\129\208\157\208\157\208\171\208\149 \208\156\208\144\208\154\208\160\208\158",
        ["Language"] = "\208\175\208\151\208\171\208\154",
        ["Appearance"] = "\208\146\208\157\208\149\208\168\208\157\208\152\208\153 \208\146\208\152\208\148", ["Controls"] = "\208\163\208\159\208\160\208\144\208\146\208\155\208\149\208\157\208\152\208\149",
    }
    for en, ru in pairs(SECTIONS) do RU[string.upper(en)] = ru end
    local PATTERNS = {
        {"^Saved: (.+)$", "\208\161\208\190\209\133\209\128\208\176\208\189\208\181\208\189\208\190 %1"},
        {"^Auto Skip paused: barrier on wave (%d+)$", "\208\144\208\178\209\130\208\190\209\129\208\186\208\184\208\191 \208\189\208\176 \208\191\208\176\209\131\208\183\208\181: \208\177\208\176\209\128\209\140\208\181\209\128 \208\189\208\176 \208\178\208\190\208\187\208\189\208\181 %1"},
        {"^Auto Sell Farms: sold (%d+)/(%d+) on wave (%d+)$", "\208\144\208\178\209\130\208\190\208\191\209\128\208\190\208\180\208\176\208\182\239\191\189\239\191\189 \209\132\208\181\209\128\239\191\189\239\191\189: \208\191\209\128\208\190\208\180\208\176\208\189\208\190 %1/%2 \208\189\208\176 \208\178\208\190\208\187\208\189\208\181 %3"},
        {"^Loaded: (.+)$", "\208\151\208\176\208\179\209\128\209\131\208\182\208\181\208\189\208\190 %1"},
        {"^Deleted: (.+)$", "\208\163\208\180\208\176\208\187\208\181\208\189\208\190 %1"},
        {"^Report not sent: (.+)$", "\208\158\209\130\209\135\209\145\209\130 \208\189\208\181 \208\190\209\130\208\191\209\128\208\176\208\178\208\187\208\181\208\189, %1"},
        {"^Auto Speed: no confirmation from the server, stopped retrying$", "\208\144\208\178\209\130\208\190\209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140: \209\129\208\181\209\128\208\178\208\181\209\128 \208\189\208\181 \208\191\208\190\208\180\209\130\208\178\208\181\209\128\208\180\208\184\208\187, \208\191\208\190\208\178\209\130\208\190\209\128\209\139 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\187\208\181\208\189\209\139"},
        {"^Auto Execute: no queue_on_teleport in this executor$", "\208\144\208\178\209\130\208\190\208\183\208\176\208\191\209\131\209\129\208\186: \208\178 \209\141\209\130\208\190\208\188 \209\141\208\186\208\183\208\181\208\186\209\131\209\130\208\190\209\128\208\181 \208\189\208\181\209\130 queue_on_teleport"},
        {"^Auto Execute: SCRIPT_URL is empty$", "\208\144\208\178\209\130\208\190\208\183\208\176\208\191\209\131\209\129\208\186: SCRIPT_URL \208\191\209\131\209\129\209\130\208\190\208\185"},
        {"^Auto Execute: queue_on_teleport failed$", "\208\144\208\178\209\130\208\190\208\183\208\176\208\191\209\131\209\129\208\186: queue_on_teleport \208\189\208\181 \209\129\209\128\208\176\208\177\208\190\209\130\208\176\208\187"},
        {"^Auto Execute: script restarted after teleport$", "\208\144\208\178\209\130\208\190\208\183\208\176\208\191\209\131\209\129\208\186: \209\129\208\186\209\128\208\184\208\191\209\130 \208\191\208\181\209\128\208\181\208\183\208\176\208\191\209\131\209\137\208\181\208\189 \208\191\208\190\209\129\208\187\208\181 \209\130\208\181\239\191\189\239\191\189\208\181\208\191\208\190\209\128\209\130\208\176"},
        {"^Unit limit reached %((%d+)%), step skipped$", "\208\148\208\190\209\129\209\130\208\184\208\179\208\189\209\131\209\130 \208\187\208\184\208\188\208\184\209\130 \209\142\208\189\208\184\209\130\208\190\208\178 %1, \209\136\208\176\208\179 \208\191\209\128\208\190\208\191\209\131\209\137\208\181\208\189"},
        {"^(.+) limit %((%d+)%) reached, step skipped$", "\208\148\208\190\209\129\209\130\208\184\208\179\208\189\209\131\209\130 \208\187\208\184\208\188\208\184\209\130 %1 (%2), \209\136\208\176\208\179 \208\191\209\128\208\190\208\191\209\131\209\137\208\181\208\189"},
        {"^(.+) limit reached, step skipped$", "\208\148\208\190\209\129\209\130\208\184\208\179\208\189\209\131\209\130 \208\187\208\184\208\188\208\184\209\130 %1, \209\136\208\176\208\179 \208\191\209\128\208\190\208\191\209\131\209\137\208\181\208\189"},
        {"^Macro not found or empty: (.+)$", "\208\156\208\176\208\186\209\128\208\190 %1 \208\189\208\181 \208\189\208\176\208\185\208\180\208\181\208\189\208\190 \208\184\208\187\208\184 \208\191\209\131\209\129\209\130\208\190\208\181"},
        {"^Loaded macro: (.+) %((%d+) steps%)$", "\208\151\208\176\208\179\209\128\209\131\208\182\208\181\208\189\208\190 \208\188\208\176\208\186\209\128\208\190 %1, \209\136\208\176\208\179\208\190\208\178 %2"},
        {"^Loaded macro: (.+) %((%d+) steps, about %$([%d,]+)%)$", "\208\151\208\176\208\179\209\128\209\131\208\182\208\181\208\189\208\190 \208\188\208\176\208\186\209\128\208\190 %1, \209\136\208\176\208\179\208\190\208\178 %2, \208\191\209\128\208\184\208\188\208\181\209\128\208\189\208\190 $%3"},
        {"^Not in your hotbar: (.+)$", "\208\157\208\181\209\130 \208\178 \209\133\208\190\209\130\208\177\208\176\209\128\208\181: %1"},
        {"^Saved macro: (.+) %((%d+) steps%)$", "\208\161\208\190\209\133\209\128\208\176\208\189\208\181\208\189\208\190 \208\188\208\176\208\186\209\128\208\190 %1, \209\136\208\176\208\179\208\190\208\178 %2"},
        {"^Deleted macro: (.+)$", "\208\163\208\180\208\176\208\187\208\181\208\189\208\190 \208\188\208\176\208\186\209\128\208\190 %1"},
        {"^(.+): nothing was recorded$", "%1, \208\189\208\184\209\135\208\181\208\179\208\190 \208\189\208\181 \208\183\208\176\208\191\208\184\209\129\208\176\208\189\208\190"},
        {"^(.+): macro saved as (.+) %((%d+) steps%)$", "%1, \208\188\208\176\208\186\209\128\208\190 \209\129\208\190\209\133\209\128\208\176\208\189\208\181\208\189\208\190 \208\186\208\176\208\186 %2, \209\136\208\176\208\179\208\190\208\178 %3"},
        {"^(.+): recording stopped, (%d+) steps kept %(press Save%)$", "%1, \208\183\208\176\208\191\208\184\209\129\209\140 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\187\208\181\208\189\208\176, \209\136\208\176\208\179\208\190\208\178 \208\178 \208\191\208\176\208\188\209\143\209\130\208\184 %2, \209\129\208\190\209\133\209\128\208\176\208\189\208\184 \208\184\209\133 \208\186\208\189\208\190\208\191\208\186\208\190\208\185 \208\161\208\190\209\133\209\128\208\176\208\189\208\184\209\130\209\140"},
        {"^Recording stopped: (%d+) steps$", "\208\151\208\176\208\191\208\184\209\129\209\140 \208\190\209\129\209\130\208\176\208\189\208\190\208\178\208\187\208\181\208\189\208\176, \209\136\208\176\208\179\208\190\208\178 %1"},
        {"^Macro error: (.+)$", "\208\158\209\136\208\184\208\177\208\186\208\176 \208\188\208\176\208\186\209\128\208\190, %1"},
        {"^Missing remote: (.+)$", "\208\157\208\181 \208\189\208\176\208\185\208\180\208\181\208\189 \209\128\208\181\208\188\208\190\209\131\209\130 %1"},
        {"^Error: (.+)$", "\208\158\209\136\208\184\208\177\208\186\208\176, %1"},
        {"^Clipboard is not supported here: (.+)$", "\208\145\209\131\209\132\208\181\209\128 \208\190\208\177\208\188\208\181\208\189\208\176 \208\183\208\180\208\181\209\129\209\140 \208\189\208\181 \208\191\208\190\208\180\208\180\208\181\209\128\208\182\208\184\208\178\208\176\208\181\209\130\209\129\209\143, %1"},
        {"^Ready\nWave (%d+) | x(.+)$", "\208\147\208\190\209\130\208\190\208\178\208\190\n\208\146\208\190\208\187\208\189\208\176 %1, \209\129\208\186\208\190\209\128\208\190\209\129\209\130\209\140 x%2"},
    }
    local PHRASES = {
        {"Current executor: ", "\208\162\208\181\208\186\209\131\209\137\208\184\208\185 \209\141\208\186\209\129\208\191\208\187\208\190\208\185\209\130 "}, {"Executor status: ", "\208\161\209\130\208\176\209\130\209\131\209\129 \209\141\208\186\209\129\208\191\208\187\208\190\208\185\209\130\208\176 "}, {"User: ", "\208\159\208\190\208\187\209\140\208\183\208\190\208\178\208\176\209\130\208\181\208\187\209\140 "},
        {"Macro recording: ", "\208\151\208\176\208\191\208\184\209\129\209\140 \208\188\208\176\208\186\209\128\208\190 "}, {"Saving configs and macros: ", "\208\161\208\190\209\133\209\128\208\176\208\189\208\181\208\189\208\184\208\181 \208\186\208\190\208\189\209\132\208\184\208\179\208\190\208\178 \208\184 \208\188\208\176\208\186\209\128\208\190 "},
        {"Clipboard: ", "\208\145\209\131\209\132\208\181\209\128 \208\190\208\177\208\188\208\181\208\189\208\176 "}, {"Extras (optional): ", "\208\148\208\190\208\191\208\190\208\187\208\189\208\184\209\130\208\181\208\187\209\140\208\189\208\190 "},
        {"Not supported", "\208\157\208\181 \208\191\208\190\208\180\208\180\208\181\209\128\208\182\208\184\208\178\208\176\208\181\209\130\209\129\209\143"}, {">Supported<", ">\208\159\208\190\208\180\208\180\208\181\209\128\208\182\208\184\208\178\208\176\208\181\209\130\209\129\209\143<"}, {">not found<", ">\208\189\208\181\209\130<"}, {"Missing ", "\208\157\208\181 \208\189\208\176\208\185\208\180\208\181\208\189\208\190 "},
        {"Record is off, saved macros still play", "\208\151\208\176\208\191\208\184\209\129\209\140 \208\178\209\139\208\186\208\187\209\142\209\135\208\181\208\189\208\176, \208\189\208\190 \209\129\208\190\209\133\209\128\208\176\208\189\209\145\208\189\208\189\209\139\208\181 \208\188\208\176\208\186\209\128\208\190 \209\128\208\176\208\177\208\190\209\130\208\176\209\142\209\130"},
        {"Everything is kept only until you leave the game", "\208\146\209\129\209\145 \209\133\209\128\208\176\208\189\208\184\209\130\209\129\209\143 \209\130\208\190\208\187\209\140\208\186\208\190 \208\180\208\190 \208\178\209\139\209\133\208\190\208\180\208\176 \208\184\208\183 \208\184\208\179\209\128\209\139"},
        {"Copy buttons show the text instead", "\208\154\208\189\208\190\208\191\208\186\208\184 \208\186\208\190\208\191\208\184\209\128\208\190\208\178\208\176\208\189\208\184\209\143 \208\191\208\190\208\186\208\176\208\182\209\131\209\130 \209\130\208\181\208\186\209\129\209\130"},
        {"steps <b>", "\209\136\208\176\208\179\208\190\208\178 <b>"}, {"| wave <b>", ", \208\178\208\190\208\187\208\189\208\176 <b>"},
        {"PLAYING ", "\208\152\208\147\208\160\208\144\208\149\208\162 "}, {"ARMED (waits for a match)", "\208\147\208\158\208\162\208\158\208\146\208\158, \208\182\208\180\209\145\209\130 \208\188\208\176\209\130\209\135"}, {"RECORDING", "\208\152\208\148\208\129\208\162 \208\151\208\144\208\159\208\152\208\161\208\172"}, {"\nidle", "\n\208\191\209\128\208\190\209\129\209\130\208\190\208\185"},
    }
    local function plainReplace(s, a, b)
        local out, i = {}, 1
        while true do
            local x, y = s:find(a, i, true)
            if not x then
                out[#out + 1] = s:sub(i)
                break
            end
            out[#out + 1] = s:sub(i, x - 1)
            out[#out + 1] = b
            i = y + 1
        end
        return table.concat(out)
    end
    local function tr(s)
        if type(s) ~= "string" or s == "" then return s end
        local hit = RU[s]
        if hit then return hit end
        for _, p in ipairs(PATTERNS) do
            local r, n = s:gsub(p[1], p[2])
            if n > 0 then return r end
        end
        local out = s
        for _, p in ipairs(PHRASES) do out = plainReplace(out, p[1], p[2]) end
        return out
    end
    local orig, shown, origPH, shownPH = {}, {}, {}, {}
    for _, t in ipairs({orig, shown, origPH, shownPH}) do setmetatable(t, {__mode = "k"}) end
    local hooked = setmetatable({}, {__mode = "k"})
    local started = false
    local function russian() return I18N.lang == "\208\160\209\131\209\129\209\129\208\186\208\184\208\185" end
    local function paint(inst)
        if inst:IsA("TextBox") then
            local cur = inst.PlaceholderText
            if shownPH[inst] ~= cur then origPH[inst] = cur end
            local want = russian() and tr(origPH[inst]) or origPH[inst]
            if want ~= cur then inst.PlaceholderText = want end
            shownPH[inst] = want
        elseif inst:IsA("TextLabel") or inst:IsA("TextButton") then
            local cur = inst.Text
            if shown[inst] ~= cur then orig[inst] = cur end
            local want = russian() and tr(orig[inst]) or orig[inst]
            if want ~= cur then inst.Text = want end
            shown[inst] = want
        end
    end
    local function hook(inst)
        if hooked[inst] then return end
        local isBox = inst:IsA("TextBox")
        if not (isBox or inst:IsA("TextLabel") or inst:IsA("TextButton")) then return end
        hooked[inst] = true
        paint(inst)
        inst:GetPropertyChangedSignal(isBox and "PlaceholderText" or "Text"):Connect(function() paint(inst) end)
    end
    function I18N.tr(s) return russian() and tr(s) or s end
    function I18N.set(lang)
        I18N.lang = (lang == "\208\160\209\131\209\129\209\129\208\186\208\184\208\185") and "\208\160\209\131\209\129\209\129\208\186\208\184\208\185" or "English"
        if not Win then return end
        if not started and russian() then
            started = true
            Win.Gui.DescendantAdded:Connect(hook)
        end
        if started then
            for _, d in ipairs(Win.Gui:GetDescendants()) do hook(d) end
            for inst in pairs(hooked) do
                if inst.Parent then paint(inst) end
            end
        end
    end
    UI.Tr = function(s) return I18N.tr(s) end
end
Win = UI:CreateWindow({
    Title = "BeeZ Hub", Subtitle = "Cameraman TD", Theme = "Dark",
    Size = Vector2.new(540, 310), ConfigFolder = "CameramanTD", ToggleKey = Enum.KeyCode.RightShift,
})
do
    local DISCORD_LINK = "https://discord.gg/U7U2GanMSW"
    local GREEN = Color3.fromRGB(70, 210, 130)
    local RED = Color3.fromRGB(240, 85, 95)
    local GRAY = Color3.fromRGB(150, 152, 170)
    local function fn(f)
        return type(f) == "function"
    end
    local function esc(text)
        return (tostring(text):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
    end
    local function executorName()
        local ok, name = pcall(function()
            if type(identifyexecutor) == "function" then return (identifyexecutor()) end
            if type(getexecutorname) == "function" then return (getexecutorname()) end
            return nil
        end)
        if ok and name then
            local clean = tostring(name)
            clean = clean:gsub("%s*[%(%[].-[%)%]]", "")
            clean = clean:gsub("[%s%-_]+[vV]?%d[%w%.%-_]*", "")
            clean = clean:gsub("^%s+", ""):gsub("%s+$", "")
            if clean == "" then return "Unknown" end
            return clean
        end
        return "Unknown"
    end
    local function copyText(text)
        local fns = {}
        if fn(setclipboard) then table.insert(fns, setclipboard) end
        if fn(toclipboard) then table.insert(fns, toclipboard) end
        if type(Clipboard) == "table" and fn(Clipboard.set) then table.insert(fns, Clipboard.set) end
        for _, f in ipairs(fns) do
            if pcall(f, text) then return true end
        end
        return false
    end
    local function filesWork()
        return (pcall(function()
            local dir = "CameramanTD"
            if not isfolder(dir) then makefolder(dir) end
            local path = dir .. "/_check.txt"
            writefile(path, "ok")
            local back = readfile(path)
            delfile(path)
            local list = listfiles(dir)
            assert(back == "ok" and type(list) == "table")
        end))
    end
    local clipboardOk = fn(setclipboard) or fn(toclipboard) or (type(Clipboard) == "table" and fn(Clipboard.set))
    local rows = {
        {
            label = "Macro recording",
            funcs = {{"hookmetamethod", fn(hookmetamethod)}, {"getnamecallmethod", fn(getnamecallmethod)}},
            hint = "Record is off, saved macros still play",
        },
        {
            label = "Saving configs and macros",
            funcs = {
                {"writefile", fn(writefile)}, {"readfile", fn(readfile)}, {"listfiles", fn(listfiles)},
                {"delfile", fn(delfile)}, {"isfolder", fn(isfolder)}, {"makefolder", fn(makefolder)},
            },
            test = filesWork,
            hint = "Everything is kept only until you leave the game",
        },
        {
            label = "Clipboard",
            funcs = {{"setclipboard", clipboardOk}},
            hint = "Copy buttons show the text instead",
        },
    }
    local lines = {}
    local supported = true
    for _, r in ipairs(rows) do
        local missing = {}
        for _, f in ipairs(r.funcs) do
            if not f[2] then table.insert(missing, f[1]) end
        end
        local ok = #missing == 0
        if ok and r.test and not r.test() then
            ok = false
            missing = {"file test failed"}
        end
        if ok then
            table.insert(lines, r.label .. ": " .. UI.Rich("OK", GREEN))
        else
            supported = false
            table.insert(lines, r.label .. ": " .. UI.Rich("Missing " .. table.concat(missing, ", "), RED))
            table.insert(lines, UI.Rich(r.hint, GRAY))
        end
    end
    local extras = {}
    for _, e in ipairs({{"checkcaller", fn(checkcaller)}, {"newcclosure", fn(newcclosure)}, {"getgenv", fn(getgenv)}}) do
        table.insert(extras, e[1] .. " " .. (e[2] and UI.Rich("OK", GREEN) or UI.Rich("not found", GRAY)))
    end
    table.insert(lines, "Extras (optional): " .. table.concat(extras, ", "))
    local who = lp.Name
    if lp.DisplayName ~= lp.Name then who = lp.DisplayName .. " (@" .. lp.Name .. ")" end
    local statusWord = supported and UI.Rich("Supported", GREEN) or UI.Rich("Not supported", RED)
    local statusTab = Win:AddTab("Status", {Icon = "info"})
    local infoSec = statusTab:AddSection("Info")
    infoSec:AddLabel({
        Text = table.concat({
            "User: <b>" .. esc(who) .. "</b>",
            "Current executor: <b>" .. esc(executorName()) .. "</b>",
            "Executor status: <b>" .. statusWord .. "</b>",
        }, "\n"),
        Color = "Text",
    })
    local checkSec = statusTab:AddSection("Executor checks")
    checkSec:AddParagraph({
        Title = supported and UI.Rich("All features are available", GREEN) or UI.Rich("Some features are not available", RED),
        Content = table.concat(lines, "\n"),
    })
    local linkSec = statusTab:AddSection("Community")
    linkSec:AddButton({
        Name = "Copy discord server link", Style = "Accent",
        Callback = function()
            if copyText(DISCORD_LINK) then
                UI:Notify({Title = "Discord", Content = "Server link copied", Duration = 3, Type = "Success"})
            else
                UI:Notify({Title = "Discord", Content = "Clipboard is not supported here: " .. DISCORD_LINK, Duration = 6, Type = "Warning"})
            end
        end,
    })
    linkSec:AddLabel({Text = DISCORD_LINK})
end
local PE = {plane = nil, items = {}}
function PE.clear()
    if PE.plane then pcall(PE.plane.Destroy, PE.plane) end
    PE.plane = nil
    for _, it in ipairs(PE.items) do pcall(it.hb.Destroy, it.hb) end
    PE.items = {}
end
function PE.step()
    local game_ = workspace:FindFirstChild("Game")
    local area = game_ and game_:FindFirstChild("TowerArea")
    local ghosts = game_ and game_:FindFirstChild("PlacingTowers")
    if not area then return end
    if not (PE.plane and PE.plane.Parent == area) then
        local ref = area:FindFirstChildWhichIsA("BasePart")
        if ref then
            local top = ref.Position.Y + ref.Size.Y / 2
            local p = Instance.new("Part")
            p.Name = "DH_PlaceEverywhere"
            p.Anchored, p.CanCollide, p.CanTouch, p.CanQuery = true, false, false, true
            p.CastShadow = false
            p.Transparency = 1
            p.Size = Vector3.new(1500, 0.2, 1500)
            p.CFrame = CFrame.new(ref.Position.X, top - 0.1 + 0.03, ref.Position.Z)
            p.CollisionGroup = ref.CollisionGroup
            p.Parent = area
            PE.plane = p
        end
    end
    for i = #PE.items, 1, -1 do
        local it = PE.items[i]
        if not it.model.Parent or not it.hb.Parent then
            pcall(it.hb.Destroy, it.hb)
            table.remove(PE.items, i)
        end
    end
    if not ghosts then return end
    for _, model in ipairs(ghosts:GetChildren()) do
        local hb = model:FindFirstChild("SpawningHitbox", true)
        if hb and hb:IsA("BasePart") then
            for _, c in ipairs(hb:GetChildren()) do
                if c:IsA("WeldConstraint") then c:Destroy() end
            end
            hb.Anchored = true
            hb.Size = Vector3.new(1, 1, 1)
            hb.CFrame = CFrame.new(0, -10000, 0)
            hb.Parent = workspace.CurrentCamera
            PE.items[#PE.items + 1] = {hb = hb, model = model}
        end
    end
end
task.spawn(function()
    while alive() do
        task.wait(0.1)
        if cfg.placeAnywhere then
            pcall(PE.step)
        elseif PE.plane or #PE.items > 0 then
            pcall(PE.clear)
        end
    end
    pcall(PE.clear)
end)
local mainTab = Win:AddTab("Main", {Icon = "box"})
local autoSec = mainTab:AddSection("Match")
local autoGrid = autoSec:AddGrid({Columns = 2, CellHeight = 34})
autoGrid:AddToggle({
    Name = "Auto Skip", Flag = "autoSkip", Tooltip = "Skips every wave as soon as it starts",
    Callback = function(v) cfg.autoSkip = v end,
})
autoGrid:AddToggle({
    Name = "Auto Vote Mode", Flag = "autoVote", Tooltip = "Votes for the selected mode on the vote screen",
    Callback = function(v)
        cfg.autoVote = v
        st.voted = false
    end,
})
autoGrid:AddToggle({
    Name = "Auto Speed", Flag = "autoSpeed", Tooltip = "Keeps the selected game speed on every wave",
    Callback = function(v)
        cfg.autoSpeed = v
        st.speedTries, st.speedGaveUp = 0, false
        if v then ensureSpeed() end
    end,
})
autoGrid:AddToggle({
    Name = "Place Anywhere", Flag = "placeAnywhere",
    Tooltip = "Lets you place units on any ground and inside other units. The server may still refuse some spots",
    Callback = function(v) cfg.placeAnywhere = v end,
})
tgPlayAgain = autoGrid:AddToggle({
    Name = "Auto Play Again", Flag = "autoPlayAgain", Tooltip = "Presses Play Again on the result screen",
    Callback = function(v)
        cfg.autoPlayAgain = v
        if v and cfg.autoLeave then
            cfg.autoLeave = false
            if tgLeave then tgLeave:Set(false, true) end
            flash("Auto Leave Lobby turned off: Play Again is on")
        end
    end,
})
tgLeave = autoGrid:AddToggle({
    Name = "Auto Leave Lobby", Flag = "autoLeave", Tooltip = "Leaves to the lobby from the result screen (instead of Play Again)",
    Callback = function(v)
        cfg.autoLeave = v
        if v and cfg.autoPlayAgain then
            cfg.autoPlayAgain = false
            if tgPlayAgain then tgPlayAgain:Set(false, true) end
            flash("Auto Play Again turned off: Leave Lobby is on")
        end
    end,
})
local optSec = mainTab:AddSection("Game Options")
optSec:AddDropdown({
    Name = "Mode Vote", Flag = "mode", Options = MODES, Default = cfg.mode, Searchable = false,
    Callback = function(v)
        cfg.mode = v
        st.voted = false
    end,
})
optSec:AddDropdown({
    Name = "Game Speed", Flag = "speed", Options = SPEEDS, Default = cfg.speed, Searchable = false,
    Callback = function(v)
        cfg.speed = tonumber(v) or 1
        st.speedTries, st.speedGaveUp = 0, false
        ensureSpeed()
    end,
})
local skipBarrierInput
skipBarrierInput = optSec:AddInput({
    Name = "Skip Barriers", Flag = "skipBarriers", Placeholder = "e.g. 10, 25, 40",
    Tooltip = "Waves that Auto Skip will not touch, separated by commas. Each barrier wave and the pause after it play out on their own, skipping resumes on the next wave. Empty = no barriers",
    Callback = function(v)
        local set, list = parseBarriers(v)
        cfg.skipBarriers = set
        if skipBarrierInput then skipBarrierInput:Set(table.concat(list, ", "), true) end
    end,
})
local sellFarmInput
sellFarmInput = optSec:AddInput({
    Name = "Auto Sell Farms", Flag = "sellFarmWave", Placeholder = "e.g. 50",
    Tooltip = "Sells every farm unit when this wave starts, so you get the refund and keep the cash. Empty = farms are never sold",
    Callback = function(v)
        local w = parseWave(v)
        cfg.sellFarmWave = w
        if sellFarmInput then sellFarmInput:Set(w > 0 and tostring(w) or "", true) end
    end,
})
local lobbySec = mainTab:AddSection("Lobby")
local lobbyGrid = lobbySec:AddGrid({Columns = 2, CellHeight = 34})
LB.tg1 = lobbyGrid:AddToggle({
    Name = "Auto Summon 1", Flag = "autoSummon1", Tooltip = "Opens one crate at a time, nonstop (lobby only)",
    Callback = function(v)
        cfg.autoSummon1 = v
        if v and cfg.autoSummon10 then
            cfg.autoSummon10 = false
            if LB.tg10 then LB.tg10:Set(false, true) end
            flash("Auto Summon 10 turned off: Summon 1 is on")
        end
    end,
})
LB.tg10 = lobbyGrid:AddToggle({
    Name = "Auto Summon 10", Flag = "autoSummon10", Tooltip = "Opens ten crates per summon, nonstop (lobby only)",
    Callback = function(v)
        cfg.autoSummon10 = v
        if v and cfg.autoSummon1 then
            cfg.autoSummon1 = false
            if LB.tg1 then LB.tg1:Set(false, true) end
            flash("Auto Summon 1 turned off: Summon 10 is on")
        end
    end,
})
lobbySec:AddToggle({
    Name = "Auto Claim Quests", Flag = "autoClaimQuests", Tooltip = "Claims finished daily quests (lobby only)",
    Callback = function(v)
        cfg.autoClaimQuests = v
        if v then task.spawn(LB.claimQuests) end
    end,
})
lobbySec:AddToggle({
    Name = "Auto Claim Halloween Awards", Flag = "autoClaimHalloween", Tooltip = "Claims finished Halloween pass quests and reachable pass tier rewards, one request every 2s (lobby only)",
    Callback = function(v)
        cfg.autoClaimHalloween = v
        if v then task.spawn(LB.claimQuests) end
    end,
})
lobbySec:AddToggle({
    Name = "Auto Teleport To Map", Flag = "autoTeleport", Tooltip = "Enters the selected map elevator and starts it (lobby only)",
    Callback = function(v)
        cfg.autoTeleport = v
        if v then
            LB.tpNext, LB.teleporting, LB.elev = 0, false, nil
        end
    end,
})
lobbySec:AddDropdown({
    Name = "Map", Flag = "teleportMap", Options = MAP_LIST, Default = cfg.teleportMap, Searchable = false,
    Callback = function(v)
        cfg.teleportMap = v
        LB.tpNext = 0
    end,
})
local function refreshModifier()
    if cfg.autoModifier and LB.elev and LB.R.ElevatorSetModifiers then LB.runModifier(LB.elev) end
end
lobbySec:AddToggle({
    Name = "Auto Modifier", Flag = "autoModifier",
    Tooltip = "Selects the ticked modifiers when you enter a map elevator, by hand or with Auto Teleport (lobby only)",
    Callback = function(v)
        cfg.autoModifier = v
        if LB.modHpToggle then LB.modHpToggle:SetVisible(v) end
        if LB.modSpeedToggle then LB.modSpeedToggle:SetVisible(v) end
        if v then refreshModifier() end
    end,
})
LB.modHpToggle = lobbySec:AddToggle({
    Name = "X2 Toilets HP", Flag = "modHp", Default = cfg.modHp,
    Tooltip = "Modifier Hp_Mobs: toilets have twice the health",
    Callback = function(v)
        cfg.modHp = v
        refreshModifier()
    end,
})
LB.modSpeedToggle = lobbySec:AddToggle({
    Name = "X2 Toilets Speed", Flag = "modSpeed", Default = cfg.modSpeed,
    Tooltip = "Modifier Speed_Mobs: toilets move twice as fast",
    Callback = function(v)
        cfg.modSpeed = v
        refreshModifier()
    end,
})
LB.modHpToggle:SetVisible(cfg.autoModifier)
LB.modSpeedToggle:SetVisible(cfg.autoModifier)
local invSec = mainTab:AddSection("Inventory")
INV.w.sellInfo = invSec:AddParagraph({Title = "Unit sell", Content = "Select a unit, then choose an action. Equipped and locked copies are skipped."})
INV.w.sellSel = invSec:AddDropdown({
    Name = "Inventory Unit", Options = {"(select a unit)"}, Default = "(select a unit)", NoSave = true,
    Tooltip = "Units from your inventory with copy counts (lobby only)",
    Callback = function(v)
        if INV.refreshing then return end
        INV.sellName = INV.sellLabels[v]
        INV.refreshSell()
    end,
})
local sellGrid = invSec:AddGrid({Columns = 3, CellHeight = 34})
sellGrid:AddButton({Name = "Sell All", Style = "Danger", Callback = function() INV.sell("All") end})
sellGrid:AddButton({Name = "Sell x1", Style = "Danger", Callback = function() INV.sell("One") end})
sellGrid:AddButton({Name = "Keep One", Style = "Danger", Callback = function() INV.sell("KeepOne") end})
invSec:AddDivider()
INV.w.crateInfo = invSec:AddParagraph({Title = "Crates", Content = "Auto Buy / Open is off."})
invSec:AddDropdown({
    Name = "Buy Amount", Flag = "buyCrateAmount", Options = {"x1", "x3", "x10"}, Default = "x" .. cfg.buyCrateAmount, Searchable = false,
    Callback = function(v)
        local n = tonumber(tostring(v):match("%d+"))
        cfg.buyCrateAmount = (n == 3 or n == 10) and n or 1
    end,
})
invSec:AddToggle({
    Name = "Auto Buy Halloween Crate", Flag = "autoBuyCrate", Tooltip = "Buys with Candy when affordable (lobby only)",
    Callback = function(v) cfg.autoBuyCrate = v end,
})
INV.w.crateSel = invSec:AddDropdown({
    Name = "Open Crate", Flag = "openCrateName", Options = INV.crateOptions(), Default = INV.crateOptions()[1], Searchable = false,
    Callback = function(v)
        if v ~= INV.NO_CRATES then cfg.openCrateName = tostring(v) end
    end,
})
invSec:AddDropdown({
    Name = "Open Amount", Flag = "openCrateAmount", Options = {"x1", "x10"}, Default = "x" .. cfg.openCrateAmount, Searchable = false,
    Callback = function(v) cfg.openCrateAmount = (v == "x10") and 10 or 1 end,
})
invSec:AddToggle({
    Name = "Auto Open Crate", Flag = "autoOpenCrate", Tooltip = "Opens owned crates while the unit inventory has space (lobby only)",
    Callback = function(v) cfg.autoOpenCrate = v end,
})
local macroTab = Win:AddTab("Macro", {Icon = "circle-dot"})
local recSec = macroTab:AddSection("Recorder")
local recGrid = recSec:AddGrid({Columns = 2, CellHeight = 34})
recToggle = recGrid:AddToggle({
    Name = "Record", NoSave = true,
    Tooltip = "Records the units you place, upgrade, sell and retarget by hand. Saved by itself when the round ends (macro #1, #2, ... or the typed name)",
    Callback = function(v)
        if v then
            if not mc.ok then
                flash("Macro unavailable: game remotes missing", "Error")
                recToggle:Set(false, true)
                return
            end
            if mc.play then
                flash("Turn Play Macro off first", "Warning")
                recToggle:Set(false, true)
                return
            end
            if mc.hook then mc.hook = installHook() end
            if not mc.hook then
                flash("No hookmetamethod: steps are recorded from server echoes, timing is approximate", "Warning")
            end
            resetRecorder()
            mc.rec = true
            if ownCount() > 0 then
                flash("Units already on the field are not recorded: start with an empty field", "Warning")
            end
            local prev = mc.selected
            mc.selected = nil
            if macroDD then macroDD:Set(nil, true) end
            if prev and nameInput and sanitize(nameInput:Get()) == prev then nameInput:Set("", true) end
            flash("Recording: it is saved by itself when the round ends")
        else
            mc.rec = false
            clearStamps()
            flash("Recording stopped: " .. #mc.steps .. " steps")
        end
    end,
})
playToggle = recGrid:AddToggle({
    Name = "Play Macro", Flag = "playMacro",
    Tooltip = "Replays the selected macro in every match. Units are bought and upgraded the moment there is enough money, without waiting for a wave; only sells keep their wave and time. Saved in configs: autofarm starts by itself",
    Callback = function(v)
        if v then
            if mc.initDone and not mc.ok then
                flash("Macro unavailable: game remotes missing", "Error")
                playToggle:Set(false, true)
                return
            end
            if mc.rec then
                flash("Turn Record off first", "Warning")
                playToggle:Set(false, true)
                return
            end
            if #mc.steps == 0 then
                flash("No steps: pick a saved macro or record one", "Warning")
                playToggle:Set(false, true)
                return
            end
            mc.play = true
            mc.ranMatch = nil
            flash("Macro armed: it replays every match", "Success")
        else
            mc.play = false
        end
    end,
})
mc.autoSave = true
recSec:AddToggle({
    Name = "Auto Save After The Match Ends", Flag = "autoSaveRec", Default = true,
    Tooltip = "Saves the recording by itself when the round ends. When off, the steps stay loaded and you save them with the Save button",
    Callback = function(v) mc.autoSave = v end,
})
macroStatus = recSec:AddLabel({Text = "idle"})
recSec:AddButton({
    Name = "Clear Steps", Style = "Danger",
    Callback = function()
        if mc.play or mc.rec then
            flash("Turn Record / Play off first", "Warning")
            return
        end
        mc.steps = {}
        mc.selected = nil
        if macroDD then macroDD:Set(nil, true) end
        flash("Steps cleared")
    end,
})
local libSec = macroTab:AddSection("Saved Macros")
macroDD = libSec:AddDropdown({
    Name = "Macro", Flag = "macro", Options = MAC.list(),
    Tooltip = "Pick a saved macro: it is loaded right away, then press Play Macro",
    Callback = function(name)
        if mc.play or mc.rec then
            flash("Turn Record / Play off first", "Warning")
            macroDD:Set(mc.selected, true)
            return
        end
        loadMacro(name)
    end,
})
nameInput = libSec:AddInput({Name = "Name", Flag = "macroName", Placeholder = "macro name"})
local macGrid = libSec:AddGrid({Columns = 2, CellHeight = 34})
macGrid:AddButton({Name = "Save", Style = "Accent", Callback = saveMacro})
macGrid:AddButton({Name = "Delete", Style = "Danger", Callback = deleteMacro})
local PRIV = {
    nameOrig = setmetatable({}, {__mode = "k"}), nameWatched = setmetatable({}, {__mode = "k"}), nameConns = {},
    userSaved = {}, userGen = 0, fpsOrig = setmetatable({}, {__mode = "k"}), conns = {},
}
if genv.cm_privDestroy then pcall(genv.cm_privDestroy) end
PRIV.Lighting = game:GetService("Lighting")
PRIV.Workspace = game:GetService("Workspace")

function PRIV.nameRestore()
    for inst, props in pairs(PRIV.nameOrig) do
        pcall(function()
            for k, v in pairs(props) do inst[k] = v end
        end)
    end
    PRIV.nameOrig = setmetatable({}, {__mode = "k"})
end
function PRIV.ownText(s)
    s = tostring(s or ""):match("^%s*(.-)%s*$")
    return s == lp.Name or (lp.DisplayName ~= "" and s == lp.DisplayName) or s == "@" .. lp.Name
end
function PRIV.nameObject(o)
    if o:IsA("Humanoid") then
        if not PRIV.nameOrig[o] then
            PRIV.nameOrig[o] = {DisplayName = o.DisplayName, NameDisplayDistance = o.NameDisplayDistance}
        end
        o.NameDisplayDistance = 0
        o.DisplayName = ""
    elseif (o:IsA("TextLabel") or o:IsA("TextButton")) and o:FindFirstAncestorWhichIsA("BillboardGui") then
        local t = o.Text
        if t:find(lp.Name, 1, true) or (lp.DisplayName ~= "" and t:find(lp.DisplayName, 1, true)) then
            if not PRIV.nameOrig[o] then
                PRIV.nameOrig[o] = {Visible = o.Visible, TextTransparency = o.TextTransparency,
                    TextStrokeTransparency = o.TextStrokeTransparency}
            end
            o.Visible = false
            o.TextTransparency, o.TextStrokeTransparency = 1, 1
        end
    end
end
function PRIV.nameWatch(l)
    if PRIV.nameWatched[l] then return end
    if not (l:IsA("TextLabel") or l:IsA("TextButton")) then return end
    local g = l:FindFirstAncestorWhichIsA("ScreenGui")
    if g and g.Name:sub(1, 10) == "DiamondUI_" then return end
    PRIV.nameWatched[l] = true
    local function apply()
        local o = PRIV.nameOrig[l]
        if PRIV.ownText(l.Text) then
            if not o then
                o = {Visible = l.Visible, TextTransparency = l.TextTransparency,
                    TextStrokeTransparency = l.TextStrokeTransparency}
                PRIV.nameOrig[l] = o
            end
            l.Visible = false
            l.TextTransparency, l.TextStrokeTransparency = 1, 1
        elseif o then
            l.Visible, l.TextTransparency, l.TextStrokeTransparency = o.Visible, o.TextTransparency, o.TextStrokeTransparency
            PRIV.nameOrig[l] = nil
        end
    end
    table.insert(PRIV.nameConns, l:GetPropertyChangedSignal("Text"):Connect(apply))
    apply()
end
function PRIV.nameBind(char)
    for _, c in ipairs(PRIV.nameConns) do pcall(function() c:Disconnect() end) end
    PRIV.nameConns = {}
    PRIV.nameWatched = setmetatable({}, {__mode = "k"})
    PRIV.nameRestore()
    if not cfg.hideName then return end
    if char then
        for _, d in ipairs(char:GetDescendants()) do pcall(PRIV.nameObject, d) end
        table.insert(PRIV.nameConns, char.DescendantAdded:Connect(function(d)
            if alive() and cfg.hideName and lp.Character == char then pcall(PRIV.nameObject, d) end
        end))
    end
    local function watchRoot(root)
        for _, d in ipairs(root:GetDescendants()) do pcall(PRIV.nameWatch, d) end
        table.insert(PRIV.nameConns, root.DescendantAdded:Connect(function(d)
            if alive() and cfg.hideName then pcall(PRIV.nameWatch, d) end
        end))
    end
    watchRoot(pg)
    pcall(function() watchRoot(game:GetService("CoreGui")) end)
end
function PRIV.setName(v)
    cfg.hideName = v and true or false
    PRIV.nameBind(cfg.hideName and lp.Character or nil)
end

function PRIV.userClear()
    for inst, props in pairs(PRIV.userSaved) do
        pcall(function()
            for k, v in pairs(props) do inst[k] = v end
        end)
    end
    PRIV.userSaved = {}
end
function PRIV.userApply(char)
    PRIV.userGen = PRIV.userGen + 1
    local gen = PRIV.userGen
    if PRIV.userConn then
        PRIV.userConn:Disconnect()
        PRIV.userConn = nil
    end
    PRIV.userClear()
    if not (cfg.hideUser and char) then return end
    local RED = Color3.fromRGB(255, 0, 0)
    local function hit(i)
        if PRIV.userSaved[i] or not i:IsDescendantOf(char) then return end
        local set
        if i:IsA("Accessory") or i:IsA("Shirt") or i:IsA("Pants") or i:IsA("ShirtGraphic") or i:IsA("CharacterMesh") then
            set = {Parent = false}
        elseif i:IsA("BasePart") and i.Parent == char and i.Name ~= "HumanoidRootPart" then
            set = {Color = RED}
            if i:IsA("MeshPart") then set.TextureID = "" end
        elseif i:IsA("BodyColors") then
            set = {HeadColor3 = RED, TorsoColor3 = RED, LeftArmColor3 = RED, RightArmColor3 = RED,
                LeftLegColor3 = RED, RightLegColor3 = RED}
        elseif i:IsA("SpecialMesh") and i.Parent and i.Parent.Parent == char then
            set = {TextureId = ""}
        elseif i:IsA("SurfaceAppearance") and i.Parent and i.Parent.Parent == char then
            set = {Parent = false}
        end
        if not set then return end
        local saved = {}
        PRIV.userSaved[i] = saved
        for k, v in pairs(set) do
            pcall(function()
                saved[k] = i[k]
                if k == "Parent" then i.Parent = nil else i[k] = v end
            end)
        end
    end
    PRIV.userConn = char.DescendantAdded:Connect(function(d)
        task.defer(function()
            if alive() and cfg.hideUser and gen == PRIV.userGen then pcall(hit, d) end
        end)
    end)
    for _, d in ipairs(char:GetDescendants()) do pcall(hit, d) end
end
function PRIV.setUser(v)
    cfg.hideUser = v and true or false
    PRIV.userApply(cfg.hideUser and lp.Character or nil)
end

function PRIV.fpsSet(inst, prop, val)
    local o = PRIV.fpsOrig[inst]
    if not o then
        o = {}
        PRIV.fpsOrig[inst] = o
    end
    if o[prop] == nil then
        local ok, cur = pcall(function() return inst[prop] end)
        if ok then o[prop] = cur end
    end
    pcall(function() inst[prop] = val end)
end
function PRIV.fpsObject(o)
    if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Smoke") or o:IsA("Fire")
        or o:IsA("Sparkles") or o:IsA("PostEffect") then
        PRIV.fpsSet(o, "Enabled", false)
    elseif o:IsA("BasePart") then
        PRIV.fpsSet(o, "CastShadow", false)
        PRIV.fpsSet(o, "Material", Enum.Material.SmoothPlastic)
    elseif o:IsA("Decal") or o:IsA("Texture") then
        PRIV.fpsSet(o, "Transparency", 1)
    end
end
function PRIV.fpsEnqueue(inst)
    local q = PRIV.fpsQ
    if not q then
        q = {}
        PRIV.fpsQ = q
        task.defer(function()
            local i, t0 = 1, os.clock()
            while alive() and cfg.fpsBoost and PRIV.fpsQ == q and i <= #q do
                local o = q[i]
                if o.Parent then pcall(PRIV.fpsObject, o) end
                i = i + 1
                if i % 16 == 0 and os.clock() - t0 >= 0.002 then
                    task.wait()
                    t0 = os.clock()
                end
            end
            if PRIV.fpsQ == q then PRIV.fpsQ = nil end
        end)
    end
    q[#q + 1] = inst
end
function PRIV.setFps(on)
    cfg.fpsBoost = on and true or false
    PRIV.fpsGen = (PRIV.fpsGen or 0) + 1
    local gen = PRIV.fpsGen
    if cfg.fpsBoost then
        PRIV.fpsSet(PRIV.Lighting, "GlobalShadows", false)
        task.spawn(function()
            local t0, n = os.clock(), 0
            for _, root in ipairs({PRIV.Workspace, PRIV.Lighting}) do
                for _, d in ipairs(root:GetDescendants()) do
                    if not (alive() and cfg.fpsBoost and PRIV.fpsGen == gen) then return end
                    pcall(PRIV.fpsObject, d)
                    n = n + 1
                    if n % 16 == 0 and os.clock() - t0 >= 0.002 then
                        task.wait()
                        t0 = os.clock()
                    end
                end
            end
        end)
    else
        PRIV.fpsQ = nil
        local orig = PRIV.fpsOrig
        PRIV.fpsOrig = setmetatable({}, {__mode = "k"})
        task.spawn(function()
            local n = 0
            for inst, props in pairs(orig) do
                pcall(function()
                    for k, v in pairs(props) do inst[k] = v end
                end)
                n = n + 1
                if n % 200 == 0 then task.wait() end
            end
        end)
    end
end
table.insert(PRIV.conns, lp.CharacterAdded:Connect(function(c)
    if not alive() then return end
    if cfg.hideName then PRIV.nameBind(c) end
    if cfg.hideUser then PRIV.userApply(c) end
end))
for _, svc in ipairs({PRIV.Workspace, PRIV.Lighting}) do
    table.insert(PRIV.conns, svc.DescendantAdded:Connect(function(d)
        if alive() and cfg.fpsBoost then PRIV.fpsEnqueue(d) end
    end))
end
genv.cm_privDestroy = function()
    cfg.hideName, cfg.hideUser, cfg.fpsBoost = false, false, false
    pcall(PRIV.nameBind, nil)
    pcall(PRIV.userApply, nil)
    pcall(PRIV.setFps, false)
    for _, c in ipairs(PRIV.conns) do pcall(function() c:Disconnect() end) end
end
local MISC = {fpsCap = 60, fbSaved = {}, fbConns = {}, nfSaved = {}, nfConns = {}, nfAtmo = {}}
function MISC.antiAfk(on)
    if on then
        if MISC.afkConn then return end
        MISC.afkConn = lp.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    elseif MISC.afkConn then
        MISC.afkConn:Disconnect()
        MISC.afkConn = nil
    end
end
function MISC.applyFps()
    if type(setfpscap) ~= "function" then return end
    pcall(setfpscap, MISC.fpsOn and MISC.fpsCap or 60)
end
local FULLBRIGHT = {
    Brightness = 1,
    ClockTime = 12,
    FogEnd = 786543,
    GlobalShadows = false,
    Ambient = Color3.fromRGB(178, 178, 178),
}
function MISC.fullBright(on)
    local lighting = game:GetService("Lighting")
    if on then
        if MISC.fbOn then return end
        MISC.fbOn = true
        for prop, val in pairs(FULLBRIGHT) do
            MISC.fbSaved[prop] = lighting[prop]
            lighting[prop] = val
            MISC.fbConns[prop] = lighting:GetPropertyChangedSignal(prop):Connect(function()
                if lighting[prop] ~= val then
                    MISC.fbSaved[prop] = lighting[prop]
                    lighting[prop] = val
                end
            end)
        end
    else
        if not MISC.fbOn then return end
        MISC.fbOn = false
        for prop, conn in pairs(MISC.fbConns) do conn:Disconnect() end
        MISC.fbConns = {}
        for prop, val in pairs(MISC.fbSaved) do lighting[prop] = val end
        MISC.fbSaved = {}
    end
end
function MISC.noclip(on)
    if on then
        if MISC.ncConn then return end
        MISC.ncTouched = setmetatable({}, {__mode = "k"})
        MISC.ncConn = game:GetService("RunService").Stepped:Connect(function()
            local char = lp.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    MISC.ncTouched[part] = true
                    part.CanCollide = false
                end
            end
        end)
    elseif MISC.ncConn then
        MISC.ncConn:Disconnect()
        MISC.ncConn = nil
        for part in pairs(MISC.ncTouched) do
            if part.Parent then part.CanCollide = true end
        end
        MISC.ncTouched = nil
    end
end
MISC.walkSpeed = 32
function MISC.speed(on)
    if on then
        if MISC.spConn then return end
        MISC.spConn = game:GetService("RunService").Heartbeat:Connect(function()
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if not MISC.spBase then MISC.spBase = hum.WalkSpeed end
            if hum.WalkSpeed ~= MISC.walkSpeed then hum.WalkSpeed = MISC.walkSpeed end
        end)
    elseif MISC.spConn then
        MISC.spConn:Disconnect()
        MISC.spConn = nil
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = MISC.spBase or 16 end
        MISC.spBase = nil
    end
end
MISC.flySpeed = 60
function MISC.fly(on)
    local RS = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local K = Enum.KeyCode
    local function key(k) return UIS:IsKeyDown(k) end
    local function cleanup()
        if MISC.flyBV then MISC.flyBV:Destroy() MISC.flyBV = nil end
        if MISC.flyBG then MISC.flyBG:Destroy() MISC.flyBG = nil end
    end
    if on then
        if MISC.flyConn then return end
        MISC.flyCtl = false
        pcall(function()
            local pm = lp.PlayerScripts:FindFirstChild("PlayerModule")
            if pm then MISC.flyCtl = require(pm):GetControls() end
        end)
        MISC.flyConn = RS.RenderStepped:Connect(function()
            if not alive() then MISC.fly(false) return end
            local char = lp.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local cam = workspace.CurrentCamera
            if not (hum and root and cam) then return end
            if not MISC.flyBV or MISC.flyBV.Parent ~= root or not MISC.flyBG or MISC.flyBG.Parent ~= root then
                cleanup()
                local bg = Instance.new("BodyGyro")
                bg.Name = "DH_FlyGyro"
                bg.P = 9e4
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.CFrame = root.CFrame
                bg.Parent = root
                local bv = Instance.new("BodyVelocity")
                bv.Name = "DH_FlyVel"
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Velocity = Vector3.new(0, 0.1, 0)
                bv.Parent = root
                MISC.flyBG, MISC.flyBV = bg, bv
            end
            if not hum.PlatformStand then hum.PlatformStand = true end
            local mv
            if MISC.flyCtl then
                local ok, v = pcall(function() return MISC.flyCtl:GetMoveVector() end)
                if ok and typeof(v) == "Vector3" then mv = v end
            end
            if not mv then
                mv = Vector3.new((key(K.D) and 1 or 0) - (key(K.A) and 1 or 0), 0, (key(K.S) and 1 or 0) - (key(K.W) and 1 or 0))
            end
            local cf = cam.CFrame
            local dir = cf.RightVector * mv.X + cf.LookVector * (-mv.Z)
            if key(K.E) or key(K.Space) then dir = dir + Vector3.yAxis end
            if key(K.Q) or key(K.LeftControl) or key(K.LeftShift) then dir = dir - Vector3.yAxis end
            MISC.flyBG.CFrame = cf
            MISC.flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * MISC.flySpeed or Vector3.new(0, 0.1, 0)
        end)
    elseif MISC.flyConn then
        MISC.flyConn:Disconnect()
        MISC.flyConn = nil
        cleanup()
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum then hum.PlatformStand = false end
        if root then root.AssemblyLinearVelocity = Vector3.zero end
    end
end
local NOFOG = {FogEnd = 786543, FogStart = 786000}
function MISC.noFog(on)
    local lighting = game:GetService("Lighting")
    if on then
        if MISC.nfOn then return end
        MISC.nfOn = true
        for prop, val in pairs(NOFOG) do
            MISC.nfSaved[prop] = lighting[prop]
            lighting[prop] = val
            table.insert(MISC.nfConns, lighting:GetPropertyChangedSignal(prop):Connect(function()
                if lighting[prop] ~= val then
                    MISC.nfSaved[prop] = lighting[prop]
                    lighting[prop] = val
                end
            end))
        end
        local function clear(a)
            if not a:IsA("Atmosphere") then return end
            if not MISC.nfAtmo[a] then MISC.nfAtmo[a] = {Density = a.Density, Haze = a.Haze} end
            a.Density = 0
            a.Haze = 0
            for _, prop in ipairs({"Density", "Haze"}) do
                table.insert(MISC.nfConns, a:GetPropertyChangedSignal(prop):Connect(function()
                    if a[prop] ~= 0 then
                        MISC.nfAtmo[a][prop] = a[prop]
                        a[prop] = 0
                    end
                end))
            end
        end
        for _, c in ipairs(lighting:GetChildren()) do clear(c) end
        table.insert(MISC.nfConns, lighting.ChildAdded:Connect(clear))
    else
        if not MISC.nfOn then return end
        MISC.nfOn = false
        for _, c in ipairs(MISC.nfConns) do c:Disconnect() end
        MISC.nfConns = {}
        for prop, val in pairs(MISC.nfSaved) do lighting[prop] = val end
        MISC.nfSaved = {}
        for a, vals in pairs(MISC.nfAtmo) do
            if a.Parent then
                a.Density = vals.Density
                a.Haze = vals.Haze
            end
        end
        MISC.nfAtmo = {}
    end
end
local discordTab = Win:AddTab("Webhook", {Icon = "webhook"})
local whSec = discordTab:AddSection("Discord")
whSec:AddInput({
    Name = "Webhook URL", Flag = "whUrl", Placeholder = "https://discord.com/api/webhooks/...",
    Tooltip = "Discord: channel settings > Integrations > Webhooks > New Webhook > Copy Webhook URL",
    Callback = function(v) WH.url = WH.clean(v) end,
})
whSec:AddToggle({
    Name = "Enable Webhook", Flag = "whEnabled", Default = false,
    Tooltip = "Turns Discord messages on or off",
    Callback = function(v) WH.enabled = v end,
})
whSec:AddToggle({
    Name = "Notify On Match End", Flag = "whOnEnd", Default = true,
    Tooltip = "Sends the result of every match: victory or defeat, mode, wave, time, rewards and account totals",
    Callback = function(v) WH.onEnd = v end,
})
whSec:AddButton({
    Name = "Send Test Message", Style = "Accent",
    Callback = function() WH.send(nil, WH.snapshot(), false) end,
})
local miscTab = Win:AddTab("Misc", {Icon = "wrench"})
local miscSec = miscTab:AddSection(nil)
miscSec:AddToggle({
    Name = "Anti AFK", Flag = "antiAfk", Tooltip = "Stops the game from kicking you for being idle",
    Callback = function(v) MISC.antiAfk(v) end,
})
miscSec:AddToggle({
    Name = "Noclip", Flag = "noclip", Tooltip = "Walk through walls and other solid objects",
    Callback = function(v) MISC.noclip(v) end,
})
local speedSlider
miscSec:AddToggle({
    Name = "Speed", Flag = "speedHack", Tooltip = "Overrides your walk speed with the value of the slider below",
    Callback = function(v)
        if speedSlider then speedSlider:SetVisible(v) end
        MISC.speed(v)
    end,
})
speedSlider = miscSec:AddSlider({
    Name = "Walk Speed", Flag = "walkSpeed", Min = 16, Max = 200, Step = 1, Default = 32,
    Callback = function(v) MISC.walkSpeed = v end,
})
speedSlider:SetVisible(false)
local flySlider
miscSec:AddToggle({
    Name = "Fly", Flag = "fly", Tooltip = "Flies like Infinite Yield: you move along the camera. W/A/S/D or the thumbstick to move, E or Space up, Q or Ctrl down. Combine with Noclip to pass through walls",
    Callback = function(v)
        if flySlider then flySlider:SetVisible(v) end
        MISC.fly(v)
    end,
})
flySlider = miscSec:AddSlider({
    Name = "Fly Speed", Flag = "flySpeed", Min = 10, Max = 300, Step = 5, Default = 60,
    Callback = function(v) MISC.flySpeed = v end,
})
flySlider:SetVisible(false)
local fpsSlider
miscSec:AddToggle({
    Name = "Unlock FPS", Flag = "unlockFps", Tooltip = "Raises the FPS cap to the value of the slider below (needs setfpscap)",
    Callback = function(v)
        MISC.fpsOn = v
        if fpsSlider then fpsSlider:SetVisible(v) end
        MISC.applyFps()
    end,
})
fpsSlider = miscSec:AddSlider({
    Name = "FPS Limit", Flag = "fpsCap", Min = 30, Max = 360, Step = 5, Default = 60,
    Callback = function(v)
        MISC.fpsCap = v
        MISC.applyFps()
    end,
})
fpsSlider:SetVisible(false)
miscSec:AddToggle({
    Name = "Full Bright", Flag = "fullBright", Tooltip = "Removes darkness and fog so everything is lit",
    Callback = function(v) MISC.fullBright(v) end,
})
miscSec:AddToggle({
    Name = "No Fog", Flag = "noFog", Tooltip = "Removes fog and atmosphere haze so you can see far. Does not change brightness",
    Callback = function(v) MISC.noFog(v) end,
})
miscSec:AddToggle({
    Name = "Hide Name", Flag = "hideName", Tooltip = "Hides your name in character tags, tower info and the player list (local view)",
    Callback = function(v) PRIV.setName(v) end,
})
miscSec:AddToggle({
    Name = "Hide User", Flag = "hideUser", Tooltip = "Red body, no clothes or accessories (local view)",
    Callback = function(v) PRIV.setUser(v) end,
})
miscSec:AddToggle({
    Name = "FPS Boost", Flag = "fpsBoost", Tooltip = "Turns off particles, shadows and post effects, flattens materials",
    Callback = function(v) PRIV.setFps(v) end,
})
local tgAutoExec
local settingsTab = Win:AddSettingsTab("Settings")
local langSec = settingsTab:AddSection("Language")
langSec:AddDropdown({
    Name = "Language", Flag = "language", Options = {"English", "\208\160\209\131\209\129\209\129\208\186\208\184\208\185"}, Default = cfg.language, Searchable = false,
    Callback = function(v)
        cfg.language = v
        I18N.set(v)
    end,
})
local setSec = settingsTab:AddSection(nil)
tgAutoExec = setSec:AddToggle({
    Name = "Auto Execute", Flag = "autoExecute", NoSave = true,
    Tooltip = "Reruns the script after every teleport (Play Again, lobby and match)",
    Callback = function(v)
        cfg.autoExecute = v
        AE.set(v)
        if v then
            local ok, why = AE.queue()
            if not ok then
                cfg.autoExecute = false
                AE.set(false)
                if tgAutoExec then tgAutoExec:Set(false, true) end
                flash("Auto Execute: " .. why, "Error")
            end
        end
    end,
})
Win:SetLoadOrder({"macro", "playMacro"})
local function init()
    task.spawn(loadTowerConfig)
    task.spawn(function()
        local ls = lp:WaitForChild("leaderstats", 30)
        ctx.mv = ls and ls:WaitForChild("Money", 30)
        local mv = ctx.mv
        if mv then
            mc.mlast = mv.Value
            mv.Changed:Connect(function(v)
                if not alive() then return end
                local d = v - (mc.mlast or v)
                mc.mlast = v
                local log = mc.mlog
                log[#log + 1] = {t = os.clock(), d = d}
                if #log > 40 then table.remove(log, 1) end
            end)
        end
    end)
    local ev, fn
    while alive() do
        local ml = RS:FindFirstChild("ModuleLoader")
        local sh = ml and ml:FindFirstChild("Shared")
        local net = sh and sh:FindFirstChild("Network")
        ev = net and net:FindFirstChild("RemoteEvent")
        fn = net and net:FindFirstChild("RemoteFunction")
        if ev and fn then break end
        task.wait(1)
    end
    if not alive() then return end
    local okLobby, errLobby = pcall(LB.init, ev, fn)
    if not okLobby then warn("[cm] lobby: " .. tostring(errLobby)) end
    task.spawn(function()
        local nr = ev:WaitForChild("Notificate", 15)
        if nr and alive() then nr.OnClientEvent:Connect(onNotify) end
    end)
    for _, n in ipairs({"ModeVote", "Notificate", "WaveSkip", "PlayAgain"}) do
        R[n] = ev:WaitForChild(n, 10)
        if not R[n] then
            warn("[cm] missing remote: " .. n)
            return
        end
    end
    R.ChangeSpeed = fn:WaitForChild("ChangeSpeed", 10)
    ensureSpeed()
    R.OnLeave = ev:FindFirstChild("OnLeave") or fn:FindFirstChild("OnLeave")
    task.spawn(function()
        local macroOk = true
        for _, n in ipairs({"TowerAdd", "TowerUpgrade", "TowerSell", "TowerTarget", "TowerRemove"}) do
            R[n] = ev:FindFirstChild(n) or ev:WaitForChild(n, 10)
            if not R[n] then macroOk = false end
        end
        mc.ok = macroOk
        if macroOk then
            R.TowerAdd.OnClientEvent:Connect(onTowerAdd)
            R.TowerRemove.OnClientEvent:Connect(onTowerRemove)
            R.TowerTarget.OnClientEvent:Connect(onTowerTarget)
            R.TowerUpgrade.OnClientEvent:Connect(onTowerUpgrade)
            mc.hook = type(hookmetamethod) == "function" and type(getnamecallmethod) == "function"
            if not mc.hook then flash("No hookmetamethod: macro recording disabled", "Warning") end
        else
            flash("Macro disabled: missing game remotes", "Error")
        end
        mc.initDone = true
        if not macroOk and mc.play then
            mc.play = false
            syncToggles()
        end
    end)
    task.spawn(function()
        while alive() do
            task.wait(0.1)
            if cfg.autoSkip and (st.waveOn or st.cleared) and os.clock() >= st.nextSkip then
                local w = mc.wave
                if cfg.skipBarriers[w] then
                    if st.limMatch ~= mc.matchId then
                        st.limMatch = mc.matchId
                        st.limHit = {}
                    end
                    if not st.limHit[w] then
                        st.limHit[w] = true
                        flash("Auto Skip paused: barrier on wave " .. w, "Warning")
                    end
                else
                    R.WaveSkip:FireServer()
                    st.nextSkip = os.clock() + cfg.skipRepeat
                end
            end
        end
    end)
    task.spawn(function()
        while alive() do
            task.wait(0.1)
            local ok1, e1 = pcall(tickStamps)
            if not ok1 then warn("[cm] stamps: " .. tostring(e1)) end
            if mc.ok and mc.play and not mc.running and #mc.steps > 0
                and mc.ranMatch ~= mc.matchId and not st.inVote and not mc.finalSeen then
                mc.ranMatch = mc.matchId
                mc.running = true
                local myMatch = mc.matchId
                task.spawn(function()
                    local ok, err = pcall(runPlayback, myMatch)
                    if not ok then
                        flash("Macro error: " .. tostring(err):sub(1, 40), "Error")
                        warn("[cm] macro: " .. tostring(err))
                    end
                    mc.playing = false
                    mc.running = false
                end)
            end
        end
    end)
    task.spawn(function()
        local n = 0
        while alive() do
            task.wait(0.1)
            n = n + 1
            if votingOpen() then
                if not st.inVote then
                    st.inVote, st.voted = true, false
                    st.voteTries = 0
                    newMatch()
                end
                st.finalShown = false
                if cfg.autoVote then
                    local now = os.clock()
                    if not st.voted or ((st.voteTries or 0) < 3 and now - (st.voteLast or 0) > 1.5) then
                        st.voted = true
                        st.voteTries = (st.voteTries or 0) + 1
                        st.voteLast = now
                        st.matchMode = cfg.mode
                        R.ModeVote:FireServer(cfg.mode)
                    end
                end
            else
                st.inVote = false
                if finalOpen() then
                    matchEnded()
                    if (cfg.autoLeave or cfg.autoPlayAgain) and not st.finalShown then
                        st.finalShown = true
                        task.spawn(function()
                            local waited = os.clock()
                            while WH.busy and alive() and os.clock() - waited < 10 do task.wait(0.1) end
                            task.wait(cfg.autoLeave and cfg.leaveDelay or cfg.playAgainDelay)
                            if not alive() then return end
                            if cfg.autoLeave then
                                fireLeave()
                            elseif cfg.autoPlayAgain then
                                R.PlayAgain:FireServer()
                            end
                        end)
                    end
                else
                    st.finalShown = false
                end
            end
            ensureSpeed()
            if st.curSpeed == tonumber(cfg.speed) then st.speedTries, st.speedGaveUp = 0, false end
            if n % 10 == 0 then
                local line
                if mc.running then
                    line = string.format("PLAYING %d/%d", mc.stepNo, #mc.steps)
                elseif mc.play then
                    line = "ARMED (waits for a match)"
                elseif mc.rec then
                    line = "RECORDING"
                else
                    line = "idle"
                end
                macroStatus:SetText(string.format("steps <b>%d</b> | wave <b>%d</b> | $<b>%d</b>\n%s",
                    #mc.steps, mc.wave, math.floor(money()), line))
            end
        end
    end)
    refreshMacroList()
end
task.spawn(function()
    local ok, err = pcall(init)
    if not ok then warn("[cm] " .. tostring(err)) end
end)
local lastMacro = MAC.getAuto()
if lastMacro and MAC.exists(lastMacro) then loadMacro(lastMacro, true) end
Win:RestoreState()
local restartedByQueue = genv.cm_ae
genv.cm_ae = nil
if AE.get() then
    cfg.autoExecute = true
    if tgAutoExec then tgAutoExec:Set(true, true) end
    local ok, why = AE.queue()
    if restartedByQueue then
        if ok then flash("Auto Execute: script restarted after teleport", "Success")
        else flash("Auto Execute: " .. why, "Error") end
    end
else
    cfg.autoExecute = false
    if tgAutoExec then tgAutoExec:Set(false, true) end
end
UI:Notify({
    Title = "BeeZ Hub", Content = "Ready. RightShift or the diamond button hides the menu.", Duration = 4, Type = "Success",
})
