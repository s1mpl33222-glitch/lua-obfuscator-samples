repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local CommE = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommE")

local LocalPlayer = Players.LocalPlayer
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")

local LangMap = {
    ["脚本已在运行中，请勿重复执行！"] = "Script is already running, do not execute again!",
    ["基础版"] = "Basic",
    ["自动赏金"] = "Auto Bounty",
    ["技能配置"] = "Skill Config",
    ["战斗设置"] = "Combat Settings",
    ["服务器"] = "Server",
    ["设置"] = "Settings",
    ["自己"] = "Self",
    ["已离开服务器"] = "Left the server",
    ["未加载角色"] = "Character not loaded",
    ["缺少 Humanoid/HRP"] = "Missing Humanoid/HRP",
    ["已死亡"] = "Dead",
    ["安全区且未战斗"] = "Safe zone, not in combat",
    ["PVP 已关闭"] = "PvP disabled",
    ["单人竞技场"] = "1v1 arena",
    ["同队海军"] = "Same team (Marines)",
    ["读不到等级"] = "Level unreadable",
    ["等级差 > 700"] = "Level gap > 700",
    ["本地角色未就绪"] = "Local character not ready",
    ["距离 > 30000"] = "Distance > 30000",
    ["锁定时间到"] = "Lock time reached",
    ["检测到 tween 未生效（1.5 秒内几乎没位移），已切换为直接推进"] = "Tween not working (barely moved in 1.5s), switched to direct stepping",
    ["信息面板更新异常"] = "Info panel update error",
    ["未知"] = "Unknown",
    ["当前赏金"] = "Bounty",
    ["运行时间"] = "Runtime",
    ["随机"] = "Random",
    ["自动跳服"] = "Server Hop",
    ["没有找到符合区域条件的服务器，稍后重试"] = "No server matched the region filter, retrying later",
    ["传送前检测到赏金危险状态，已中止传送：继续上升等待"] = "Bounty at risk before teleport, aborted: keep ascending",
    ["没有完全符合人数/赏金条件的服务器，已放宽筛选\\n跳到：%s | %d人 | 赏金 %s"] = "No server matched player/bounty filters, relaxed\\nHop to: %s | %d players | bounty %s",
    ["已匹配服务器\\n区域：%s | 人数：%d | 赏金：%s"] = "Server matched\\nRegion: %s | Players: %d | Bounty: %s",
    ["传送前出现目标，已取消传送"] = "Target appeared before teleport, cancelled",
    ["赏金危险状态：禁止跳服，正在上升等待危险解除"] = "Bounty at risk: hop blocked, ascending until it clears",
    ["当前服务器无目标，正在跳服..."] = "No target in this server, hopping...",
    ["跳服途中进入赏金危险状态，已中止传送：继续上升等待"] = "Bounty became at risk during hop, aborted: keep ascending",
    ["危险已解除，继续跳服"] = "Risk cleared, continuing hop",
    ["目标 %s 不符合条件（%s），立刻换人"] = "Target %s no longer valid (%s), switching",
    ["锁定 %s 已达 %.0f 秒（上限 %d 秒），换人锁定（该玩家 %d 秒内不再选）"] = "Locked %s for %.0f s (limit %d s), switching (that player is skipped for %d s)",
    ["跳服途中出现目标，已立刻中止跳服并前去攻击"] = "Target appeared during hop, aborted and engaging",
    ["主循环异常（已自动恢复）"] = "Main loop error (auto recovered)",
    ["已进入新服务器，重新寻找目标"] = "Entered a new server, searching for a target",
    ["技能"] = " Skills",
    [" 蓄力"] = " Charge",
    ["近战"] = "Melee",
    ["剑"] = "Sword",
    ["果实"] = "Fruit",
    ["枪械"] = "Gun",
    ["快速攻击"] = "Fast Attack",
    ["果实m1攻击"] = "Fruit M1",
    ["龙炮攻击"] = "Dragonstorm",
    ["虚空果实m1"] = "Void Fruit M1",
    ["战斗辅助"] = "Combat Assist",
    ["自动开启 PVP"] = "Auto Enable PvP",
    ["自动武装色"] = "Auto Buso",
    ["自动见闻色"] = "Auto Ken",
    ["自动 V3"] = "Auto V3",
    ["自动使用种族 V3 技能"] = "Auto use race V3 ability",
    ["单服最长停留(秒)"] = "Max Stay Per Server (s)",
    ["本服停留已达 %d 分钟，赏金危险解除后立刻跳服"] = "Server stay reached %d min, hopping as soon as the bounty risk clears",
    ["自动瞬步"] = "Auto Soru",
    ["自动逃跑"] = "Auto Flee",
    ["逃跑血量阈值(%)"] = "Flee HP threshold (%)",
    ["手持武器类型"] = "Hold Weapon",
    ["选择阵营"] = "Select Team",
    ["启用 ESP"] = "Enable ESP",
    ["显示名称"] = "Show Name",
    ["显示等级"] = "Show Level",
    ["显示血量"] = "Show Health",
    ["显示距离"] = "Show Distance",
    ["显示 PVP 状态"] = "Show PvP State",
    ["字体大小"] = "Font Size",
    ["服务器区域"] = "Server Region",
    ["跳服人数范围"] = "Hop Player Range",
    ["只跳到该人数区间的服务器"] = "Only hop to servers within this player range",
    ["跳服赏金范围"] = "Hop Bounty Range",
    ["只跳到该赏金以上的服务器"] = "Only hop to servers above this bounty",
    ["大于3m"] = "> 3M",
    ["大于5m"] = "> 5M",
    ["大于10m"] = "> 10M",
    ["大于15m"] = "> 15M",
    ["大于25m"] = "> 25M",
    ["大于35m"] = "> 35M",
    ["大于50m"] = "> 50M",
    ["手动跳服"] = "Manual Hop",
    ["当前服务器 ID"] = "Current Server ID",
    ["锁定玩家时间"] = "Lock Time",
    ["执行器不支持 writefile"] = "Executor does not support writefile",
    ["当前执行器不支持 writefile"] = "This executor does not support writefile",
    ["当前执行器不支持 readfile"] = "This executor does not support readfile",
    ["保存配置"] = "Save Config",
    ["保存配置失败"] = "Save Config Failed",
    ["序列化失败："] = "Serialize failed: ",
    [" / 回退也失败："] = " / fallback failed too: ",
    ["\n（设置不会被保存，请检查执行器权限）"] = "\n(settings will not be saved, check executor permissions)",
    ["有标签页挂载自动保存失败，这些页面的改动可能不会写盘：\\n"] = "Failed to hook auto save on some tabs, changes there may not be written:\\n",
    ["[ PVP 开启 ]"] = "[ PVP ON ]",
    ["；"] = "; ",
    ["[ PVP 关闭 ]"] = "[ PVP OFF ]",
    ["已保存到 "] = "Saved to ",
    ["保存失败："] = "Save failed: ",
    ["加载配置"] = "Load Config",
    ["没有找到配置文件"] = "Config file not found",
    ["读取失败"] = "Read failed",
    ["配置格式错误"] = "Invalid config format",
    ["检测到旧版配置，技能蓄力已统一迁移为 "] = "Old config detected, skill charge unified to ",
    [" 秒"] = " s",
    ["配置已加载并应用"] = "Config loaded and applied",
    ["配置保存"] = "Config Save",
    ["设置变更时自动保存"] = "Auto Save On Change",
    ["启动时自动加载配置"] = "Auto Load On Start",
    ["删除配置"] = "Delete Config",
    ["导出配置到剪切板"] = "Export Config to Clipboard",
    ["复制成 getgenv().Config = {...}，粘在加载脚本那行前面就能导入"] = "Copies getgenv().Config = {...}; paste it before the loader line to import",
    ["配置文件已删除"] = "Config file deleted",
    ["没有可删除的配置"] = "No config to delete",
    ["脚本已加载"] = "Script loaded",
    ["WindUI 加载失败：把 windui.lua 放到执行器根目录，或检查网络"] = "WindUI failed to load: put windui.lua in the executor root, or check your network",
    ["自动保存"] = "Auto Save",
    ["界面控件缺失："] = "Missing UI widgets: ",
    ["控件回调异常："] = "Widget callback error: ",
}

-- English-only UI: no language switching or environment language setting.
local function T(text)
    return LangMap[text] or text
end

if getgenv and getgenv().SovereignHubLoaded then
    return
end
if getgenv then
    getgenv().SovereignHubLoaded = true
end

local LastCaughtError = nil

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        LastCaughtError = tostring(err)
    end
    return ok, err
end

local SaveConfig
local ConfigLoading = true

local InjectedConfig = (function()
    local env = getgenv and getgenv()
    local cfg = env and env.Config
    if type(cfg) ~= "table" then return nil end
    return cfg
end)()

-- ══════════════════════════════════════════════════════════════
--   VIETNAMESE LIB  (premium dark neon UI — no external load)
-- ══════════════════════════════════════════════════════════════
local Library = {}

do
    local _UIS = game:GetService("UserInputService")
    local _TS  = game:GetService("TweenService")
    local _CG  = game:GetService("CoreGui")
    local _LP  = Players.LocalPlayer
    local _PG  = _LP.PlayerGui
    local _Mob = _UIS.TouchEnabled and not _UIS.KeyboardEnabled

    local THEME = {
        PRIMARY     = Color3.fromRGB(122, 92, 255),
        SECONDARY   = Color3.fromRGB(24, 200, 255),
        GLOW        = Color3.fromRGB(120, 110, 255),
        BG_DEEP     = Color3.fromRGB(11, 13, 18),
        BG_PANEL    = Color3.fromRGB(15, 17, 23),
        BG_ROW      = Color3.fromRGB(22, 25, 33),
        BG_HOVER    = Color3.fromRGB(30, 36, 52),
        STROKE_DARK = Color3.fromRGB(60, 70, 95),
        TEXT_BRIGHT = Color3.fromRGB(220, 225, 235),
        TEXT_DIM    = Color3.fromRGB(140, 150, 175),
    }
    local GRAD_HOT = ColorSequence.new{
        ColorSequenceKeypoint.new(0, THEME.PRIMARY),
        ColorSequenceKeypoint.new(1, THEME.SECONDARY),
    }
    local GRAD_TITLE = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 248, 255)),
        ColorSequenceKeypoint.new(0.6, THEME.PRIMARY),
        ColorSequenceKeypoint.new(1, THEME.SECONDARY),
    }

    function Library:GetParent()
        if not RunService:IsStudio() then
            return (gethui and gethui()) or _CG
        end
        return _PG
    end

    function Library:New(class, props)
        local inst = Instance.new(class)
        for k, v in pairs(props) do inst[k] = v end
        return inst
    end

    function Library:MakeBtn(parent)
        return self:New("TextButton", {
            Name = "Click", Parent = parent,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Font = Enum.Font.SourceSans, Text = "",
            TextColor3 = Color3.new(0,0,0), TextSize = 14,
            ZIndex = parent.ZIndex + 3,
        })
    end

    function Library:Tw(v, t, s, d, g)
        return _TS:Create(v, TweenInfo.new(t, Enum.EasingStyle[s], Enum.EasingDirection[d]), g)
    end

    function Library:Ripple(click, frame)
        frame.ClipsDescendants = true
        local m = _LP:GetMouse()
        local rx = m.X - click.AbsolutePosition.X
        local ry = m.Y - click.AbsolutePosition.Y
        if rx < 0 or ry < 0 or rx > click.AbsoluteSize.X or ry > click.AbsoluteSize.Y then return end
        local r = self:New("Frame", {
            Parent = frame, BackgroundColor3 = THEME.PRIMARY,
            BackgroundTransparency = 0.5, BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, rx, 0, ry),
            Size = UDim2.new(0, 0, 0, 0), ZIndex = frame.ZIndex,
        })
        self:New("UICorner", { Parent = r, CornerRadius = UDim.new(1, 0) })
        local tw = _TS:Create(r, TweenInfo.new(1.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, click.AbsoluteSize.X * 1.5, 0, click.AbsoluteSize.X * 1.5),
            BackgroundTransparency = 1,
        })
        tw.Completed:Once(function() r:Destroy() end)
        tw:Play()
    end

    function Library:Drag(frame)
        local drag, di, ds, sp = false, nil, nil, nil
        frame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                drag = true; ds = i.Position; sp = frame.Position
                i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
            end
        end)
        frame.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
        end)
        _UIS.InputChanged:Connect(function(i)
            if i == di and drag then
                local delta = i.Position - ds
                _TS:Create(frame, TweenInfo.new(0.3), {
                    Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
                }):Play()
            end
        end)
    end

    -- shared row builder
    function Library:Row(parent, title, desc)
        local row = self:New("Frame", {
            Name = "Row", Parent = parent,
            BackgroundColor3 = THEME.BG_ROW, BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40),
        })
        self:New("UIStroke",  { Parent = row, Color = THEME.STROKE_DARK, Thickness = 1, Transparency = 0.55 })
        self:New("UICorner",  { Parent = row, CornerRadius = UDim.new(0, 10) })
        self:New("UIListLayout", {
            Parent = row, Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        })
        self:New("UIPadding", { Parent = row, PaddingBottom = UDim.new(0,6), PaddingTop = UDim.new(0,5) })

        local vec = self:New("Frame", {
            Name = "Vec", Parent = row, BackgroundTransparency = 1,
            BorderSizePixel = 0, Size = UDim2.new(1,0,1,0),
        })
        self:New("UIPadding", { Parent = vec, PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10) })

        local right = self:New("Frame", {
            Name = "Right", Parent = vec, BackgroundTransparency = 1,
            BorderSizePixel = 0, Size = UDim2.new(1,0,1,0),
        })
        self:New("UIListLayout", {
            Parent = right, HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
        })

        local left = self:New("Frame", {
            Name = "Left", Parent = vec, BackgroundTransparency = 1,
            BorderSizePixel = 0, Size = UDim2.new(1,0,1,0),
        })
        local txt = self:New("Frame", {
            Name = "Txt", Parent = left, BackgroundTransparency = 1,
            BorderSizePixel = 0, Size = UDim2.new(1,0,1,0),
        })
        self:New("UIListLayout", {
            Parent = txt, HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
        })
        local tl = self:New("TextLabel", {
            Name = "Title", Parent = txt, AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = -1,
            Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,0,0,13),
            Font = Enum.Font.GothamSemibold, RichText = true, Text = title,
            TextColor3 = Color3.fromRGB(235,238,245), TextSize = 12,
            TextStrokeTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        })
        self:New("TextLabel", {
            Name = "Desc", Parent = txt, AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,0,0,10),
            Font = Enum.Font.GothamMedium, RichText = true, Text = desc or "",
            TextColor3 = Color3.fromRGB(155,165,185), TextSize = 11,
            TextStrokeTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        })
        -- hover
        local rb = self:MakeBtn(row); rb.ZIndex = 0
        local ob = row.BackgroundColor3
        rb.MouseEnter:Connect(function()  _TS:Create(row,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(28,32,42)}):Play() end)
        rb.MouseLeave:Connect(function()  _TS:Create(row,TweenInfo.new(0.18),{BackgroundColor3=ob}):Play() end)

        return row, right, tl
    end

    -- ── Dropdown overlay (shared, one per window) ──────────────
    local _dropOverlay = nil
    local _dropOpen    = false
    function Library:IsDropdownOpen() return _dropOpen end

    -- ── Window ──────────────────────────────────────────────────
    function Library:Window(args)
        local title    = args.Title    or "Sovereign Hub"
        local subtitle = args.SubTitle or "Sovereign Hub"

        local gui = self:New("ScreenGui", {
            Name = "SovNeon", Parent = self:GetParent(),
            ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true,
        })

        local bg = self:New("Frame", {
            Name = "BG", Parent = gui,
            AnchorPoint = Vector2.new(0.5,0.5),
            BackgroundColor3 = THEME.BG_PANEL, BorderSizePixel = 0,
            Position = UDim2.new(0.5,0,0.5,0),
            Size = UDim2.new(0, 520, 0, 380),
        })
        self:New("UIStroke", { Parent = bg, Color = THEME.GLOW, Thickness = 1.5, Transparency = 0.35 })
        self:New("UICorner", { Parent = bg, CornerRadius = UDim.new(0, 16) })
        self:New("UIGradient", {
            Parent = bg,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, THEME.BG_PANEL),
                ColorSequenceKeypoint.new(1, THEME.BG_DEEP),
            }, Rotation = 135,
        })
        self:New("ImageLabel", {
            Name = "Shadow", Parent = bg,
            AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,160,1,160), ZIndex = 0,
            Image = "rbxassetid://1316045217", ImageColor3 = THEME.GLOW,
            ImageTransparency = 0.65, ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(10,10,10,10),
        })

        -- Header
        local hdr = self:New("Frame", {
            Name = "Header", Parent = bg,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1,0,0,44),
        })
        local divLine = self:New("Frame", {
            Parent = hdr, BackgroundColor3 = THEME.PRIMARY,
            BorderSizePixel = 0, Position = UDim2.new(0,14,1,-1),
            Size = UDim2.new(1,-28,0,1),
        })
        self:New("UIGradient", {
            Parent = divLine,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0,1),
                NumberSequenceKeypoint.new(0.5,0),
                NumberSequenceKeypoint.new(1,1),
            },
        })
        self:New("UIPadding", {
            Parent = hdr,
            PaddingLeft  = UDim.new(0,16), PaddingRight  = UDim.new(0,16),
            PaddingTop   = UDim.new(0,8),  PaddingBottom = UDim.new(0,8),
        })
        local hdrLayout = self:New("Frame", {
            Parent = hdr, BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1,0,1,0),
        })
        self:New("UIListLayout", {
            Parent = hdrLayout, FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0,8),
        })
        local titleLbl = self:New("TextLabel", {
            Name = "Title", Parent = hdrLayout,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1,-60,0,18),
            Font = Enum.Font.GothamBold, RichText = true, Text = title,
            TextColor3 = THEME.PRIMARY, TextSize = 16,
            TextStrokeTransparency = 0.7, TextXAlignment = Enum.TextXAlignment.Left,
        })
        self:New("UIGradient", { Parent = titleLbl, Color = GRAD_TITLE, Rotation = 90 })
        self:New("TextLabel", {
            Name = "Sub", Parent = hdrLayout,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(0,0,0,0), -- hidden; subtitle shown via TextLabel below title
            Font = Enum.Font.GothamMedium, Text = "", TextSize = 1,
        })

        -- THETIME label (top-right)
        local THETIME = self:New("TextLabel", {
            Name = "Time", Parent = hdr,
            AnchorPoint = Vector2.new(1,0.5),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(1,-12,0.5,0), Size = UDim2.new(0,130,0,14),
            Font = Enum.Font.GothamMedium, Text = "00:00:00",
            TextColor3 = THEME.TEXT_DIM, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right,
        })

        -- Body split: left tab rail + right content
        local body = self:New("Frame", {
            Name = "Body", Parent = bg,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(0,0,0,44),
            Size = UDim2.new(1,0,1,-44),
        })

        -- Left tab rail (scrollable)
        local tabRail = self:New("ScrollingFrame", {
            Name = "TabRail", Parent = body,
            BackgroundColor3 = Color3.fromRGB(13,15,21), BorderSizePixel = 0,
            Position = UDim2.new(0,0,0,0), Size = UDim2.new(0,130,1,0),
            ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y,
            ClipsDescendants = true,
        })
        self:New("UICorner", { Parent = tabRail, CornerRadius = UDim.new(0,12) })
        self:New("UIPadding", {
            Parent = tabRail,
            PaddingTop = UDim.new(0,8), PaddingBottom = UDim.new(0,8),
            PaddingLeft = UDim.new(0,6), PaddingRight = UDim.new(0,6),
        })
        local tabList = self:New("UIListLayout", {
            Parent = tabRail, Padding = UDim.new(0,4),
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Vertical,
        })
        tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabRail.CanvasSize = UDim2.new(0,0,0,tabList.AbsoluteContentSize.Y+16)
        end)

        -- Right content area
        local contentHolder = self:New("Frame", {
            Name = "Content", Parent = body,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(0,136,0,0),
            Size = UDim2.new(1,-136,1,0),
        })
        contentHolder.ClipsDescendants = true

        local pageLayout = self:New("UIPageLayout", {
            Parent = contentHolder,
            EasingStyle = Enum.EasingStyle.Exponential,
            TweenTime = 0.45,
            GamepadInputEnabled = false,
            ScrollWheelInputEnabled = false,
            TouchInputEnabled = false,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
        })

        -- Dropdown overlay (absolute, sits over everything)
        _dropOverlay = self:New("Frame", {
            Name = "DropOverlay", Parent = bg,
            BackgroundTransparency = 1, BorderSizePixel = 0,
            Size = UDim2.new(1,0,1,0),
            ZIndex = 50, Visible = false,
        })

        -- Toggle button (Pillow)
        local toggleGui = self:New("ScreenGui", {
            Name = "SovToggle", Parent = self:GetParent(),
            ZIndexBehavior = Enum.ZIndexBehavior.Global, IgnoreGuiInset = true,
        })
        local pillow = self:New("TextButton", {
            Name = "Pillow", Parent = toggleGui,
            BackgroundColor3 = THEME.BG_PANEL, BorderSizePixel = 0,
            Position = UDim2.new(0.06,0,0.15,0), Size = UDim2.new(0,50,0,50), Text = "",
        })
        self:New("UICorner", { Parent = pillow, CornerRadius = UDim.new(1,0) })
        local pStroke = self:New("UIStroke", { Parent = pillow, Color = THEME.PRIMARY, Thickness = 2, Transparency = 0.2 })
        local logo = self:New("ImageLabel", {
            Name = "Logo", Parent = pillow,
            AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, BorderSizePixel = 0,
            Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(0.5,0,0.5,0),
            Image = "rbxassetid://7734864583", ImageColor3 = THEME.PRIMARY, Rotation = 0,
        })
        local ring = self:New("ImageLabel", {
            Parent = pillow, AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1,
            Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1.3,0,1.3,0),
            Image = "rbxassetid://7948482113", ImageColor3 = THEME.PRIMARY,
            ImageTransparency = 0.65, ZIndex = 0, Rotation = 0,
        })
        self:Drag(pillow)

        local snd1 = self:New("Sound", { Parent = pillow, SoundId = "rbxassetid://6895079853", Volume = 0.6 })
        local snd2 = self:New("Sound", { Parent = pillow, SoundId = "rbxassetid://4612375233", Volume = 0.5 })

        local isAnim = false
        local function toggleMenu()
            if isAnim then return end; isAnim = true
            pcall(function() snd1:Play() end)
            task.delay(0.08, function() pcall(function() snd2:Play() end) end)
            _TS:Create(logo, TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Rotation=logo.Rotation+360}):Play()
            _TS:Create(ring, TweenInfo.new(0.6,Enum.EasingStyle.Quart,Enum.EasingDirection.Out), {Rotation=ring.Rotation-360}):Play()
            local p1 = _TS:Create(pillow, TweenInfo.new(0.12,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {Size=UDim2.new(0,44,0,44)})
            p1:Play(); p1.Completed:Connect(function()
                _TS:Create(pillow, TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size=UDim2.new(0,50,0,50)}):Play()
            end)
            _TS:Create(pStroke, TweenInfo.new(0.15), {Thickness=4,Transparency=0}):Play()
            task.delay(0.15, function() _TS:Create(pStroke,TweenInfo.new(0.4),{Thickness=2,Transparency=0.2}):Play() end)
            bg.Visible = not bg.Visible
            task.delay(0.6, function() isAnim = false end)
        end
        pillow.MouseButton1Click:Connect(toggleMenu)
        task.spawn(function()
            while ring and ring.Parent do
                _TS:Create(ring, TweenInfo.new(8,Enum.EasingStyle.Linear), {Rotation=ring.Rotation+360}):Play()
                task.wait(8)
            end
        end)
        game:GetService("UserInputService").InputBegan:Connect(function(inp, proc)
            if proc then return end
            if inp.KeyCode == Enum.KeyCode.RightControl or inp.KeyCode == Enum.KeyCode.LeftControl then
                toggleMenu()
            end
        end)

        self:Drag(bg)
        self:New("UIScale", { Parent = gui, Scale = if _Mob then 1 else 1.0 })
        function Library:SetTimeValue(v) THETIME.Text = v end

        -- active tab tracking
        local activeTabBtn = nil
        local function setActiveTab(btn)
            if activeTabBtn then
                _TS:Create(activeTabBtn, TweenInfo.new(0.2), {BackgroundColor3=THEME.BG_PANEL}):Play()
                local s = activeTabBtn:FindFirstChildOfClass("UIStroke")
                if s then _TS:Create(s,TweenInfo.new(0.2),{Transparency=0.65}):Play() end
                local lbl = activeTabBtn:FindFirstChild("Lbl")
                if lbl then lbl.TextColor3 = THEME.TEXT_DIM end
            end
            activeTabBtn = btn
            _TS:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=THEME.BG_HOVER}):Play()
            local s = btn:FindFirstChildOfClass("UIStroke")
            if s then _TS:Create(s,TweenInfo.new(0.2),{Transparency=0.0}):Play() end
            local lbl = btn:FindFirstChild("Lbl")
            if lbl then lbl.TextColor3 = THEME.PRIMARY end
        end

        -- Window object returned
        local Win = {}

        function Win:NewPage(a)
            local pgTitle = a.Title or "Page"
            local pgDesc  = a.Desc  or ""

            -- tab button in rail
            local tabBtn = Library:New("Frame", {
                Name = "TabBtn_"..pgTitle, Parent = tabRail,
                BackgroundColor3 = THEME.BG_PANEL, BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,36),
            })
            Library:New("UICorner", { Parent = tabBtn, CornerRadius = UDim.new(0,10) })
            local tbs = Library:New("UIStroke", { Parent = tabBtn, Color = THEME.GLOW, Thickness = 1, Transparency = 0.65 })
            Library:New("UIPadding", { Parent = tabBtn, PaddingLeft = UDim.new(0,10) })
            local lbl = Library:New("TextLabel", {
                Name = "Lbl", Parent = tabBtn,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(1,-10,1,0),
                Font = Enum.Font.GothamSemibold, Text = pgTitle,
                TextColor3 = THEME.TEXT_DIM, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local tabClick = Library:MakeBtn(tabBtn)

            -- page frame
            local pageFrame = Library:New("Frame", {
                Name = "Page_"..pgTitle, Parent = contentHolder,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(1,0,1,0),
            })
            local scroll = Library:New("ScrollingFrame", {
                Name = "Scroll", Parent = pageFrame,
                BackgroundTransparency = 1, BorderSizePixel = 0,
                Size = UDim2.new(1,0,1,0), ClipsDescendants = true,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = THEME.PRIMARY,
                ScrollingDirection = Enum.ScrollingDirection.Y,
            })
            Library:New("UIPadding", {
                Parent = scroll,
                PaddingLeft = UDim.new(0,8), PaddingRight = UDim.new(0,10),
                PaddingTop = UDim.new(0,6), PaddingBottom = UDim.new(0,6),
            })
            local ll = Library:New("UIListLayout", {
                Parent = scroll, Padding = UDim.new(0,5),
                FillDirection = Enum.FillDirection.Vertical,
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                scroll.CanvasSize = UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+12)
            end)

            tabClick.MouseButton1Click:Connect(function()
                pageLayout:JumpTo(pageFrame)
                setActiveTab(tabBtn)
            end)
            -- hover
            local ob2 = tabBtn.BackgroundColor3
            tabClick.MouseEnter:Connect(function()
                if activeTabBtn ~= tabBtn then
                    _TS:Create(tabBtn,TweenInfo.new(0.18),{BackgroundColor3=Color3.fromRGB(22,26,38)}):Play()
                end
            end)
            tabClick.MouseLeave:Connect(function()
                if activeTabBtn ~= tabBtn then
                    _TS:Create(tabBtn,TweenInfo.new(0.18),{BackgroundColor3=ob2}):Play()
                end
            end)

            -- if first page, activate it
            if activeTabBtn == nil then
                pageLayout:JumpTo(pageFrame)
                setActiveTab(tabBtn)
            end

            local Page = {}

            -- ── Section ──
            function Page:Section(text)
                local lbl2 = Library:New("TextLabel", {
                    Name = "Section", Parent = scroll,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(1,0,0,22),
                    Font = Enum.Font.GothamBold, RichText = true,
                    Text = " " .. (text or ""),
                    TextColor3 = THEME.PRIMARY, TextSize = 13,
                    TextStrokeTransparency = 0.7, TextXAlignment = Enum.TextXAlignment.Left,
                })
                Library:New("UIGradient", { Parent = lbl2, Color = GRAD_TITLE, Rotation = 90 })
                return lbl2
            end

            -- ── Toggle ──
            function Page:Toggle(a2)
                local ttl = a2.Title or "Toggle"
                local dsc = a2.Desc  or ""
                local val = a2.Value or false
                local cb  = a2.Callback or function() end

                local row, right, titleLbl2 = Library:Row(scroll, ttl, dsc)
                row.Size = UDim2.new(1,0,0,40)

                local bg2 = Library:New("Frame", {
                    Name = "TogBG", Parent = right,
                    BackgroundColor3 = Color3.fromRGB(10,12,17),
                    BorderSizePixel = 0, Size = UDim2.new(0,22,0,22),
                })
                local ts2 = Library:New("UIStroke", { Parent = bg2, Color = THEME.STROKE_DARK, Thickness = 1, Transparency = 0.55 })
                Library:New("UICorner", { Parent = bg2, CornerRadius = UDim.new(0,8) })

                local hl = Library:New("Frame", {
                    Name = "HL", Parent = bg2,
                    AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundColor3 = THEME.PRIMARY, BorderSizePixel = 0,
                    Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,0,1,0),
                })
                Library:New("UICorner", { Parent = hl, CornerRadius = UDim.new(0,8) })
                Library:New("UIGradient", {
                    Parent = hl,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0,THEME.PRIMARY),
                        ColorSequenceKeypoint.new(1,THEME.SECONDARY),
                    }, Rotation = 45,
                })
                local chk = Library:New("ImageLabel", {
                    Parent = hl, AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(0.45,0,0.45,0),
                    Image = "rbxassetid://3926305904",
                })
                local click2 = Library:MakeBtn(bg2)
                local Data = { Value = val }

                local function apply(v)
                    if v then
                        titleLbl2.TextColor3 = THEME.PRIMARY
                        Library:Tw(hl,0.4,"Exponential","Out",{BackgroundTransparency=0}):Play()
                        Library:Tw(chk,0.4,"Exponential","Out",{ImageTransparency=0,Size=UDim2.new(0.55,0,0.55,0)}):Play()
                        ts2.Thickness = 0
                    else
                        titleLbl2.TextColor3 = THEME.TEXT_BRIGHT
                        Library:Tw(hl,0.4,"Exponential","Out",{BackgroundTransparency=1}):Play()
                        Library:Tw(chk,0.4,"Exponential","Out",{ImageTransparency=1,Size=UDim2.new(0.45,0,0.45,0)}):Play()
                        ts2.Thickness = 1
                    end
                    pcall(cb, v)
                end

                apply(val)
                click2.MouseButton1Click:Connect(function()
                    if Library:IsDropdownOpen() then return end
                    Data.Value = not Data.Value; apply(Data.Value)
                end)

                local attr = setmetatable({}, {
                    __newindex = function(_, k, v)
                        rawset(Data, k, v)
                        if k == "Value" then apply(v) end
                    end,
                    __index = Data,
                })
                function attr:Set(v)    attr.Value = not not v end
                function attr:Select(v) attr.Value = not not v end
                return attr
            end

            -- ── Button ──
            function Page:Button(a2)
                local ttl = a2.Title or "Button"
                local dsc = a2.Desc  or ""
                local txt = a2.Text  or "Go"
                local cb  = a2.Callback or function() end

                local row, right = Library:Row(scroll, ttl, dsc)
                row.Size = UDim2.new(1,0,0,40)

                local btn = Library:New("Frame", {
                    Name = "Btn", Parent = right,
                    BackgroundColor3 = THEME.PRIMARY, BorderSizePixel = 0,
                    Size = UDim2.new(0,70,0,26),
                })
                Library:New("UICorner", { Parent = btn, CornerRadius = UDim.new(0,10) })
                Library:New("UIGradient", {
                    Parent = btn,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0,THEME.PRIMARY),
                        ColorSequenceKeypoint.new(1,THEME.SECONDARY),
                    }, Rotation = 45,
                })
                Library:New("UIStroke", { Parent = btn, Color = Color3.new(1,1,1), Thickness = 0.5, Transparency = 0.6 })
                local bLbl = Library:New("TextLabel", {
                    Parent = btn, AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Position = UDim2.new(0.5,0,0.5,0), Size = UDim2.new(1,0,1,0),
                    Font = Enum.Font.GothamBold, Text = txt,
                    TextColor3 = Color3.fromRGB(240,240,255), TextSize = 11,
                })
                local bc = Library:MakeBtn(btn)
                local ob3 = btn.BackgroundColor3
                bc.MouseEnter:Connect(function() _TS:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=THEME.BG_HOVER}):Play() end)
                bc.MouseLeave:Connect(function() _TS:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=ob3}):Play() end)
                bc.MouseButton1Click:Connect(function()
                    if Library:IsDropdownOpen() then return end
                    task.spawn(Library.Ripple, Library, bc, btn)
                    pcall(cb)
                end)
                return bc
            end

            -- ── Slider ──
            function Page:Slider(a2)
                local ttl  = a2.Title    or "Slider"
                local dsc  = a2.Desc     or ""
                local mn   = tonumber(a2.Min)     or (a2.Value and a2.Value.Min) or 0
                local mx   = tonumber(a2.Max)     or (a2.Value and a2.Value.Max) or 100
                local def  = tonumber(a2.Default) or (a2.Value and a2.Value.Default) or mn
                local step = tonumber(a2.Step)    or 1
                local cb   = a2.Callback or function() end

                local row, right, titleLbl2 = Library:Row(scroll, ttl, dsc)
                row.Size = UDim2.new(1,0,0,52)

                -- value label
                local valLbl = Library:New("TextLabel", {
                    Name = "Val", Parent = right,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(0,36,0,20),
                    Font = Enum.Font.GothamBold, Text = tostring(def),
                    TextColor3 = THEME.PRIMARY, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })
                Library:New("UIGradient", { Parent = valLbl, Color = GRAD_HOT, Rotation = 90 })

                -- track
                local track = Library:New("Frame", {
                    Name = "Track", Parent = row,
                    AnchorPoint = Vector2.new(0,1),
                    BackgroundColor3 = Color3.fromRGB(35,40,55), BorderSizePixel = 0,
                    Position = UDim2.new(0,10,1,-10),
                    Size = UDim2.new(1,-20,0,5),
                })
                Library:New("UICorner", { Parent = track, CornerRadius = UDim.new(1,0) })

                local fill = Library:New("Frame", {
                    Name = "Fill", Parent = track,
                    BackgroundColor3 = THEME.PRIMARY, BorderSizePixel = 0,
                    Size = UDim2.new(0,0,1,0),
                })
                Library:New("UICorner", { Parent = fill, CornerRadius = UDim.new(1,0) })
                Library:New("UIGradient", { Parent = fill, Color = GRAD_HOT })

                local knob = Library:New("Frame", {
                    Name = "Knob", Parent = track,
                    AnchorPoint = Vector2.new(0.5,0.5),
                    BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0,
                    Position = UDim2.new(0,0,0.5,0), Size = UDim2.new(0,12,0,12),
                })
                Library:New("UICorner", { Parent = knob, CornerRadius = UDim.new(1,0) })
                Library:New("UIStroke", { Parent = knob, Color = THEME.PRIMARY, Thickness = 1.5 })

                local current = def
                local dragging = false

                local function snapVal(v)
                    if step > 0 then
                        v = math.floor((v - mn) / step + 0.5) * step + mn
                    end
                    return math.clamp(v, mn, mx)
                end

                local function setVal(v, fire)
                    current = snapVal(v)
                    local pct = (current - mn) / math.max(mx - mn, 1)
                    fill.Size = UDim2.new(pct, 0, 1, 0)
                    knob.Position = UDim2.new(pct, 0, 0.5, 0)
                    valLbl.Text = tostring(current)
                    if fire then pcall(cb, current) end
                end

                setVal(def, false)

                local function onInput(x)
                    local abs = track.AbsolutePosition.X
                    local sz  = track.AbsoluteSize.X
                    local pct = math.clamp((x - abs) / math.max(sz, 1), 0, 1)
                    setVal(mn + pct * (mx - mn), true)
                end

                local trackBtn = Library:MakeBtn(track)
                trackBtn.MouseButton1Down:Connect(function()
                    dragging = true
                    onInput(game:GetService("UserInputService"):GetMouseLocation().X)
                end)
                game:GetService("UserInputService").InputChanged:Connect(function(inp)
                    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        onInput(inp.Position.X)
                    end
                end)
                game:GetService("UserInputService").InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                local attr = setmetatable({}, {
                    __newindex = function(_, k, v)
                        if k == "Value" then setVal(v, false) end
                    end,
                    __index = function(_, k)
                        if k == "Value" then return current end
                    end,
                })
                function attr:Set(v)    setVal(v, false) end
                function attr:Select(v) setVal(v, false) end
                return attr
            end

            -- ── Dropdown ──
            function Page:Dropdown(a2)
                local ttl   = a2.Title  or "Dropdown"
                local dsc   = a2.Desc   or ""
                local vals  = a2.Values or a2.List or {}
                local multi = a2.Multi  or false
                local def   = a2.Value  or (not multi and vals[1]) or {}
                local cb    = a2.Callback or function() end

                local row, right, titleLbl2 = Library:Row(scroll, ttl, dsc)
                row.Size = UDim2.new(1,0,0,40)

                local selected = {}
                if multi then
                    if type(def) == "table" then
                        for _, v in ipairs(def) do selected[v] = true end
                    end
                else
                    selected = def
                end

                local function getDisplay()
                    if multi then
                        local parts = {}
                        for k, v in pairs(selected) do if v then table.insert(parts, k) end end
                        return #parts > 0 and table.concat(parts, ", ") or "None"
                    else
                        return tostring(selected or "Select")
                    end
                end

                local pill = Library:New("Frame", {
                    Name = "Pill", Parent = right,
                    BackgroundColor3 = Color3.fromRGB(20,22,30), BorderSizePixel = 0,
                    Size = UDim2.new(0,120,0,26),
                })
                Library:New("UICorner", { Parent = pill, CornerRadius = UDim.new(0,8) })
                Library:New("UIStroke", { Parent = pill, Color = THEME.STROKE_DARK, Thickness = 1, Transparency = 0.4 })
                local selLbl = Library:New("TextLabel", {
                    Parent = pill, BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(1,-24,1,0), Position = UDim2.new(0,8,0,0),
                    Font = Enum.Font.GothamSemibold, Text = getDisplay(),
                    TextColor3 = THEME.TEXT_BRIGHT, TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                })
                local arrow = Library:New("TextLabel", {
                    Parent = pill, BackgroundTransparency = 1, BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(1,0.5), Position = UDim2.new(1,-6,0.5,0),
                    Size = UDim2.new(0,14,0,14),
                    Font = Enum.Font.GothamBold, Text = "▾",
                    TextColor3 = THEME.PRIMARY, TextSize = 12,
                })

                local pillClick = Library:MakeBtn(pill)

                -- build list panel (shown as overlay)
                local listPanel = Library:New("Frame", {
                    Name = "DropList", Parent = _dropOverlay,
                    BackgroundColor3 = Color3.fromRGB(16,18,26), BorderSizePixel = 0,
                    Size = UDim2.new(0,160,0,0), Visible = false, ZIndex = 60,
                })
                Library:New("UICorner", { Parent = listPanel, CornerRadius = UDim.new(0,10) })
                Library:New("UIStroke", { Parent = listPanel, Color = THEME.GLOW, Thickness = 1, Transparency = 0.45 })
                local listScroll = Library:New("ScrollingFrame", {
                    Parent = listPanel, BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(1,0,1,0), ScrollBarThickness = 2,
                    ScrollBarImageColor3 = THEME.PRIMARY,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    ZIndex = 61,
                })
                Library:New("UIPadding", { Parent = listScroll, PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4), PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4) })
                local listLL = Library:New("UIListLayout", { Parent = listScroll, Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder })
                listLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    listScroll.CanvasSize = UDim2.new(0,0,0,listLL.AbsoluteContentSize.Y+8)
                end)

                local function closeList()
                    _dropOpen = false
                    _dropOverlay.Visible = false
                    listPanel.Visible = false
                    arrow.Text = "▾"
                    _TS:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(20,22,30)}):Play()
                end

                local function fireCallback()
                    if multi then
                        local out = {}
                        for k,v in pairs(selected) do if v then table.insert(out, k) end end
                        pcall(cb, out)
                    else
                        pcall(cb, selected)
                    end
                    selLbl.Text = getDisplay()
                end

                for _, opt in ipairs(vals) do
                    local optBtn = Library:New("TextButton", {
                        Name = "Opt_"..tostring(opt), Parent = listScroll,
                        BackgroundColor3 = Color3.fromRGB(22,25,34), BorderSizePixel = 0,
                        Size = UDim2.new(1,0,0,28), Text = "",
                        ZIndex = 62,
                    })
                    Library:New("UICorner", { Parent = optBtn, CornerRadius = UDim.new(0,8) })
                    local optLbl = Library:New("TextLabel", {
                        Parent = optBtn, BackgroundTransparency = 1, BorderSizePixel = 0,
                        Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,8,0,0),
                        Font = Enum.Font.GothamSemibold, Text = tostring(opt),
                        TextColor3 = THEME.TEXT_BRIGHT, TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 63,
                    })
                    local ob4 = optBtn.BackgroundColor3
                    optBtn.MouseEnter:Connect(function() _TS:Create(optBtn,TweenInfo.new(0.12),{BackgroundColor3=THEME.BG_HOVER}):Play() end)
                    optBtn.MouseLeave:Connect(function() _TS:Create(optBtn,TweenInfo.new(0.12),{BackgroundColor3=ob4}):Play() end)
                    optBtn.MouseButton1Click:Connect(function()
                        if multi then
                            selected[opt] = not selected[opt]
                            optLbl.TextColor3 = selected[opt] and THEME.PRIMARY or THEME.TEXT_BRIGHT
                        else
                            selected = opt
                            optLbl.TextColor3 = THEME.PRIMARY
                            fireCallback()
                            closeList()
                        end
                        if multi then fireCallback() end
                    end)
                end

                local function openList()
                    _dropOpen = true
                    _dropOverlay.Visible = true
                    listPanel.Visible = true
                    arrow.Text = "▴"
                    -- position below pill
                    local abs = pill.AbsolutePosition
                    local bgAbs = bg.AbsolutePosition
                    local relX = abs.X - bgAbs.X
                    local relY = abs.Y - bgAbs.Y + pill.AbsoluteSize.Y + 4
                    local maxH = math.min(#vals * 31 + 8, 160)
                    listPanel.Position = UDim2.new(0, relX, 0, relY)
                    listPanel.Size = UDim2.new(0, 160, 0, maxH)
                    listScroll.Size = UDim2.new(1,0,1,0)
                    _TS:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=THEME.BG_HOVER}):Play()
                end

                -- click outside to close
                local closeBtn = Library:New("TextButton", {
                    Name = "DropClose", Parent = _dropOverlay,
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    Size = UDim2.new(1,0,1,0), Text = "", ZIndex = 55,
                })
                closeBtn.MouseButton1Click:Connect(closeList)

                pillClick.MouseButton1Click:Connect(function()
                    if _dropOpen then closeList() else openList() end
                end)

                local attr = setmetatable({}, {
                    __newindex = function(_, k, v)
                        if k == "Value" then
                            if multi then
                                selected = {}
                                if type(v) == "table" then
                                    for _, sv in ipairs(v) do selected[sv] = true end
                                end
                            else
                                selected = v
                            end
                            selLbl.Text = getDisplay()
                        end
                    end,
                    __index = function(_, k)
                        if k == "Value" then
                            if multi then
                                local out = {}
                                for kk, vv in pairs(selected) do if vv then table.insert(out, kk) end end
                                return out
                            else
                                return selected
                            end
                        end
                    end,
                })
                -- expose Set/Select for SyncUITo compatibility
                function attr:Set(v)   attr.Value = v end
                function attr:Select(v) attr.Value = v end
                return attr
            end

            return Page
        end

        -- expose SelectTab (no-op; first page auto-selected)
        function Win:SelectTab(_) end

        return Win
    end
end

-- ── Build the Sovereign Window via Vietnamese lib ──────────────
local SovWindow = Library:Window({
    Title    = "Sovereign Hub",
    SubTitle = "Sovereign Hub",
})

local UI = {}

local Tabs = {
    Bounty   = SovWindow:NewPage({ Title = "Auto Bounty",    Desc = "Bounty farm settings" }),
    Skills   = SovWindow:NewPage({ Title = "Skill Config",   Desc = "Configure skill keys" }),
    Attacks  = SovWindow:NewPage({ Title = "Combat",         Desc = "Combat toggles" }),
    ESP      = SovWindow:NewPage({ Title = "ESP",            Desc = "Player ESP" }),
    Server   = SovWindow:NewPage({ Title = "Server",         Desc = "Server hop settings" }),
    Settings = SovWindow:NewPage({ Title = "Settings",       Desc = "Config & performance" }),
}

-- auto-save shim: wrap every callback to trigger SaveConfig
local function WrapCB(cfg)
    if type(cfg) ~= "table" or type(cfg.Callback) ~= "function" then return cfg end
    if cfg.AutoSave == false then return cfg end
    local orig = cfg.Callback
    cfg.Callback = function(...)
        local ok, err = pcall(orig, ...)
        if not ok then LastCaughtError = T("控件回调异常：") .. tostring(err) end
        if not ConfigLoading and SaveConfig then SaveConfig(true) end
    end
    return cfg
end

-- wrap Tab methods to inject auto-save
for _, tab in pairs(Tabs) do
    for _, mname in ipairs({"Toggle","Slider","Dropdown","Button"}) do
        local orig = tab[mname]
        if type(orig) == "function" then
            tab[mname] = function(self, cfg, ...)
                return orig(self, WrapCB(cfg), ...)
            end
        end
    end
end

ConfigLoading = true

local function AddSeparator(tab, title)
    return tab:Section(title or "──────")
end

local Settings = {
    AutoBounty = false,
    MeleeSkills = { "Z", "X", "C" },
    SwordSkills = { "Z", "X" },
    FruitSkills = { "X" },
    GunSkills = { "Z", "X" },
    Hold = {
        Melee = { Z = 0.1, X = 0.1, C = 0.1, V = 0.1, F = 0.1 },
        Sword = { Z = 0.1, X = 0.1, C = 0.1, V = 0.1, F = 0.1 },
        ["Blox Fruit"] = { Z = 0.1, X = 0.1, C = 0.1, V = 0.1, F = 0.1 },
        Gun = { Z = 0.1, X = 0.1, C = 0.1, V = 0.1, F = 0.1 }
    },
    FastAttack = false,
    FruitM1 = false,
    Dragonstorm = false,
    VoidFruitM1 = false,
    AutoHaki = true,
    AutoKen = true,
    AutoV3 = true,
    AutoSoru = false,
    AutoEnablePVP = true,
    AutoFlee = false,
    AutoFleeHP = 30,
    ESP = false,
    ESP_ShowName = true,
    ESP_ShowLevel = true,
    ESP_ShowHealth = true,
    ESP_ShowDistance = true,
    ESP_ShowPVP = true,
    ESP_FontSize = 14,
    LockTime = 90,
    HoldWeapon = "Melee",
    ServerRegion = "Singapore",
    HopPlayerRange = "1-12",
    HopBountyRange = T("大于3m"),
    AutoLoadConfig = true,
    AutoSaveConfig = true,
    PerformanceMode = false,
    SelectTeam = "Pirates",
    MaxStaySeconds = 360,
    ConfigVersion = 2,
    -- ── Skip / Filter settings ──
    MaxTargetDistance = 15000,   -- studs; players farther than this are ignored
    AbandonDistance   = 12000,   -- studs; if still this far after AbandonDelay s, skip
    AbandonDelay      = 8,       -- seconds before abandon kicks in
    SkipStuck         = true,    -- skip if chase makes no progress for SkipStuckTime s
    SkipStuckTime     = 10,      -- seconds of no progress before skipping
    SkipNoPVP         = true,    -- skip players with PVP disabled (redundant guard)
    SkipSameTeam      = true,    -- skip same-team pirates/marines
    ManualSkipList    = {},      -- array of playernames to always skip
}

local INTERNAL_CONFIG_KEYS = {
    BountyBase = true,
    AutoBountyBountyBase = true,
    AutoBountyEarned = true,
    AutoBountyRunTime = true
}

local OBSOLETE_CONFIG_KEYS = {
    LockCounts        = true,
    Blacklist         = true,
    FastAttackMode    = true,
    FastAttackMobs    = true,
    FastAttackPlayers = true
}

-- Runtime skip-name lookup (rebuilt from Settings.ManualSkipList on load/change)
local ManualSkipSet = {}
local function RebuildManualSkipSet()
    ManualSkipSet = {}
    if type(Settings.ManualSkipList) == "table" then
        for _, name in ipairs(Settings.ManualSkipList) do
            ManualSkipSet[tostring(name):lower()] = true
        end
    end
end
RebuildManualSkipSet()

-- Per-target abandon tracking (reset on every new target)
local AbandonTracking = {
    StartTick   = 0,
    StartPos    = nil,
    LastMoveTick = 0,
}

local function ResetAbandonTracking()
    AbandonTracking.StartTick    = tick()
    AbandonTracking.StartPos     = nil
    AbandonTracking.LastMoveTick = tick()
end

local function IsSkippedConfigKey(key)
    return INTERNAL_CONFIG_KEYS[key] or OBSOLETE_CONFIG_KEYS[key]
end

local function ApplyConfigTable(data)
    if type(data) ~= "table" then return false end
    for key, value in pairs(data) do
        if key ~= "Hold" and not IsSkippedConfigKey(key) then
            Settings[key] = value
        end
    end
    if type(data.Hold) == "table" then
        for weaponTip, holds in pairs(data.Hold) do
            if type(holds) == "table" and Settings.Hold[weaponTip] then
                for key, value in pairs(holds) do
                    if Settings.Hold[weaponTip][key] ~= nil and tonumber(value) then
                        Settings.Hold[weaponTip][key] = math.clamp(math.floor(tonumber(value) * 10 + 0.5) / 10, 0.1, 1)
                    end
                end
            end
        end
    end
    return true
end

ApplyConfigTable(InjectedConfig)

local function ApplyTeam(team)
    if not team or team == "" then return end
    local cur = LocalPlayer.Team
    if cur and cur.Name == team then return end
    pcall(function() CommF:InvokeServer("SetTeam", team) end)
    pcall(function() CommF:InvokeServer("SetTeam2", team) end)
end

do
    task.spawn(function()
        local configWait = tick() + 1.5
        while ConfigLoading and tick() < configWait do
            task.wait(0.05)
        end

        local deadline = tick() + 20
        local nextTry = 0
        while tick() < deadline do
            local team = LocalPlayer.Team
            if team and team.Name == Settings.SelectTeam then break end
            if tick() >= nextTry then
                SafeCall(ApplyTeam, Settings.SelectTeam)
                nextTry = tick() + 1.5
            end
            task.wait(0.2)
        end
    end)
end

local CurrentTarget = nil
local CurrentTargetRoot = nil
local ChaseActive = false
local ChaseConnection = nil
local ActiveTween = nil
local ChaseSample = nil
local ChaseLastSnap = 0
local Random = Random.new()

local TargetLockStart = 0
local TargetInvalidSince = nil
local TempSkipUntil = {}
local OffsetAngle = Random:NextNumber(0, math.pi * 2)
local NextOffsetRefresh = 0
local FleeActive = false
local SoruLastTime = 0

local NextTargetSwitch = 0
local TargetLostTime = 0
local LastScanTime = 0

local Stay = {
    Enter = tick(),
    Armed = false,
    Limit = function(self)
        local v = tonumber(Settings.MaxStaySeconds) or 360
        if v < 60 then v = 60 end
        return v
    end,
    Elapsed = function(self)
        return tick() - self.Enter
    end,
    Reached = function(self)
        if not Settings.AutoBounty then return false end
        return self:Elapsed() >= self:Limit()
    end
}

local WeaponLockUntil = 0
local SkillLoopThread = nil

local Aim = {
    Pos = nil,
    Part = nil,
    Position = nil,
    MouseHookInstalled = false,
    GameHookReady = false,
    MouseMod = nil,
    MouseStore = nil,
    MouseMT = nil,
    MouseGame = nil
}

pcall(function()
    for _, conn in pairs(getconnections(LocalPlayer.Idled)) do
        conn:Disable()
    end
end)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function GetHRP(plr)
    plr = plr or LocalPlayer
    local char = plr and plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid(plr)
    plr = plr or LocalPlayer
    local char = plr and plr.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function EquipTool(tool)
    local hum = GetHumanoid(LocalPlayer)
    if not hum or hum.Sit or not tool then return false end
    if tool.Parent ~= LocalPlayer.Character then
        pcall(function() hum:EquipTool(tool) end)
        task.wait(0.05)
    end
    local equipped = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return equipped == tool
end

local function FindWeaponTool(weaponTip)
    local function scan(container)
        if not container then return nil end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and item.ToolTip == weaponTip then
                return item
            end
        end
        return nil
    end
    return scan(LocalPlayer.Character) or scan(LocalPlayer:FindFirstChild("Backpack"))
end

local function LockWeapon(owner, duration)
    local now = tick()
    WeaponLockUntil = math.max(WeaponLockUntil, now + duration)
end

local function IsWeaponLocked()
    return tick() < WeaponLockUntil
end

local SafeZonePositions = {
    World1 = {
        { pos = Vector3.new(-3000, 250, 2057), radius = 700 },
        { pos = Vector3.new(1101, 16, 1446), radius = 400 }
    },
    World2 = {
        { pos = Vector3.new(-12, 29, 2840), radius = 200 },
        { pos = Vector3.new(-376, 149, 307), radius = 150 },
        { pos = Vector3.new(-6437, 306, -4730), radius = 150 }
    },
    World3 = {
        { pos = Vector3.new(-338, 21, 5539), radius = 200 },
        { pos = Vector3.new(-12550, 337, -7506), radius = 400 },
        { pos = Vector3.new(-5046, 315, -2993), radius = 300 },
        { pos = Vector3.new(-16228, 9, 443), radius = 300 },
        { pos = Vector3.new(28695, 14959, -81), radius = 10000 },
        { pos = Vector3.new(9637, -1989, 9618), radius = 10000 }
    }
}

local function GetSafeZones()
    if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
        return SafeZonePositions.World1
    elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
        return SafeZonePositions.World2
    elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
        return SafeZonePositions.World3
    end
    return nil
end

local function IsInSafeZone(plr)
    if not plr or not plr.Character then return false end
    local char = plr.Character
    if char:FindFirstChild("TempSafeZone") then return true end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local origin = Workspace:FindFirstChild("_WorldOrigin")
    local liveZones = origin and origin:FindFirstChild("SafeZones")
    if liveZones then
        local pos = hrp.Position
        for _, zone in ipairs(liveZones:GetChildren()) do
            if zone:IsA("BasePart") then
                local mesh = zone:FindFirstChildOfClass("SpecialMesh")
                local radius = mesh and (mesh.Scale.X * 0.5) or (zone.Size.X * 0.5)
                if (zone.Position - pos).Magnitude <= radius then
                    return true
                end
            end
        end
    end
    local zones = GetSafeZones()
    if not zones then return false end
    local pos = hrp.Position
    for _, zone in ipairs(zones) do
        if (pos - zone.pos).Magnitude <= zone.radius then
            return true
        end
    end
    return false
end

local function IsPVPDisabled(plr)
    if not plr then return true end
    if plr:GetAttribute("PvpDisabled") == true then return true end
    return false
end

local function IsInSoloPvp(plr)
    if not plr then return false end
    local session = plr:FindFirstChild("PvpSessionComponent", true)
    if not session then return false end
    local state = session:GetAttribute("State")
    if state and state ~= "Playing" then return false end
    local arenaPointer = session:FindFirstChild("pvpArenaPointer")
    local arena = arenaPointer and arenaPointer.Value
    if not arena then return false end
    local teamsInfo = arena:FindFirstChild("pvpTeamsInfo")
    if not teamsInfo then return false end
    local count = 0
    for _, teamFolder in ipairs(teamsInfo:GetChildren()) do
        for _, playerVal in ipairs(teamFolder:GetChildren()) do
            if playerVal:IsA("ObjectValue") and playerVal.Value
                and playerVal.Value:IsA("Player") then
                count = count + 1
            end
        end
    end
    return count == 2
end

local function IsPVPEnabled(plr)
    if not plr then return false end
    return plr:GetAttribute("PvpDisabled") ~= true
end

local function GetLevel(plr)
    if not plr then return nil end
    local obj = (plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Level"))
        or (plr:FindFirstChild("leaderstats") and plr.leaderstats:FindFirstChild("Level"))
    return obj and tonumber(obj.Value) or nil
end

local function EvaluateTarget(plr)
    if not plr or plr == LocalPlayer then return false, "self" end
    -- Manual skip list
    if ManualSkipSet[tostring(plr.Name):lower()] then return false, "manual_skip" end
    local char = plr.Character
    if not char then return false, "no_character" end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false, "missing_parts" end
    if hum.Health <= 0 then return false, "dead" end
    if hrp.Position.Y < -100 then return false, "too_low" end
    if IsInSafeZone(plr) then return false, "safe_zone" end
    if Settings.SkipNoPVP and IsPVPDisabled(plr) then return false, "pvp_disabled" end
    if not Settings.SkipNoPVP and IsPVPDisabled(plr) then return false, "pvp_disabled" end
    local myTeam = LocalPlayer.Team
    local tgTeam = plr.Team
    if Settings.SkipSameTeam and myTeam and tgTeam and myTeam.Name == "Marines" and tgTeam.Name == "Marines" then
        return false, "same_team"
    end
    if not Settings.SkipSameTeam and myTeam and tgTeam and myTeam.Name == "Marines" and tgTeam.Name == "Marines" then
        return false, "same_team"
    end
    local myLv = GetLevel(LocalPlayer)
    local tgLv = GetLevel(plr)
    if myLv and tgLv and math.abs(myLv - tgLv) > 700 then return false, "level_gap" end
    local myHRP = GetHRP(LocalPlayer)
    if not myHRP then return false, "no_local_hrp" end
    local dist = (hrp.Position - myHRP.Position).Magnitude
    -- Hard cap from original (30000) + new configurable MaxTargetDistance
    local maxDist = math.min(tonumber(Settings.MaxTargetDistance) or 15000, 30000)
    if dist > maxDist then return false, "too_far" end
    if IsInSoloPvp(plr) then return false, "solo_pvp" end
    return true, nil
end

local TARGET_SKIP_TIME = 30

local LockGuard = {
    Counts = {},
    Blacklist = {}
}

do
    local MAX_LOCKS_PER_PLAYER = 3

    local function PlayerKey(plr)
        local id = plr and plr.UserId
        if id and id ~= 0 then return tostring(id) end
        return plr and plr.Name or "?"
    end

    function LockGuard.GetCount(plr)
        return tonumber(LockGuard.Counts[PlayerKey(plr)]) or 0
    end

    function LockGuard.IsBlacklisted(plr)
        return LockGuard.Blacklist[PlayerKey(plr)] ~= nil
    end

    function LockGuard.RegisterLock(plr)
        if not plr then return end
        local key = PlayerKey(plr)
        local n = LockGuard.GetCount(plr) + 1
        LockGuard.Counts[key] = n
        if n >= MAX_LOCKS_PER_PLAYER then
            LockGuard.Blacklist[key] = plr.Name
        end
    end

    function LockGuard.IsLockedOut(plr)
        if LockGuard.IsBlacklisted(plr) then return true end
        return LockGuard.GetCount(plr) >= MAX_LOCKS_PER_PLAYER
    end
end

local function GetNearestTarget()
    local myHRP = GetHRP(LocalPlayer)
    if not myHRP then return nil, math.huge end
    local best, bestDist = nil, math.huge
    local now = tick()
    for _, plr in ipairs(Players:GetPlayers()) do
        if TempSkipUntil[plr] and now >= TempSkipUntil[plr] then
            TempSkipUntil[plr] = nil
        end
        if not TempSkipUntil[plr] and not LockGuard.IsLockedOut(plr) then
            local ok = select(1, EvaluateTarget(plr))
            if ok then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < bestDist then
                    best = plr
                    bestDist = dist
                end
            end
        end
    end
    return best, bestDist
end

local function UpdateAimTarget()
    local root = CurrentTargetRoot
    if root and root.Parent then
        Aim.Part = root
        Aim.Pos = root.CFrame
        Aim.Position = root.Position
    else
        Aim.Part = nil
        Aim.Pos = nil
        Aim.Position = nil
    end
end

local function InstallMouseModuleHook()
    if Aim.MouseHookInstalled then return true end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then return false end
    local mod = ReplicatedStorage:FindFirstChild("Mouse")
    if not mod then return false end
    local okRequire, mouseMod = pcall(require, mod)
    if not okRequire or type(mouseMod) ~= "table" then return false end
    local ok = pcall(function()
        local store = { Hit = rawget(mouseMod, "Hit"), Target = rawget(mouseMod, "Target") }
        local mt = getrawmetatable(mouseMod) or {}
        setreadonly(mt, false)
        rawset(mouseMod, "Hit", nil)
        rawset(mouseMod, "Target", nil)
        mt.__index = function(self, key)
            if Aim.Position then
                if key == "Hit" then return Aim.Pos or CFrame.new(Aim.Position) end
                if key == "Target" and Aim.Part then return Aim.Part end
            end
            local value = rawget(self, key)
            if value ~= nil then return value end
            return store[key]
        end
        mt.__newindex = function(self, key, value)
            if key == "Hit" or key == "Target" then
                store[key] = value
            else
                rawset(self, key, value)
            end
        end
        setreadonly(mt, true)
        Aim.MouseMod = mouseMod
        Aim.MouseStore = store
        Aim.MouseMT = mt
        Aim.MouseHookInstalled = true
    end)
    return ok
end

local function InstallGameMouseHook()
    if Aim.GameHookReady then return true end
    if type(getrawmetatable) ~= "function" or type(newcclosure) ~= "function" then return false end
    local mouse = LocalPlayer:GetMouse()
    if not mouse then return false end
    local gmt = getrawmetatable(game)
    if not gmt then return false end
    local ok = pcall(function()
        setreadonly(gmt, false)
        local oldIndex = gmt.__index
        gmt.__index = newcclosure(function(self, key)
            local targetPos = Aim.Position
            if targetPos and self == mouse and not checkcaller() then
                local cam = Workspace.CurrentCamera
                local camPos = cam and cam.CFrame.Position or nil
                if key == "Hit" then return Aim.Pos or CFrame.new(targetPos) end
                if key == "Target" then return Aim.Part end
                if camPos then
                    local dir = targetPos - camPos
                    if key == "UnitRay" then return Ray.new(camPos, dir.Unit) end
                    if key == "Origin" then return CFrame.new(camPos) end
                    if key == "Direction" then return dir.Unit end
                end
            end
            if type(oldIndex) == "function" then return oldIndex(self, key) end
            if type(oldIndex) == "table" then return oldIndex[key] end
            return nil
        end)
        setreadonly(gmt, true)
        Aim.MouseGame = mouse
        Aim.GameHookReady = true
    end)
    return ok
end

local function InstallAimHooks()
    SafeCall(InstallGameMouseHook)
    if SafeCall(InstallMouseModuleHook) then return end
    task.spawn(function()
        local deadline = tick() + 10
        while tick() < deadline do
            if InstallMouseModuleHook() then return end
            task.wait(0.5)
        end
    end)
end

RunService.RenderStepped:Connect(UpdateAimTarget)


local RJR = {
    SnapDist = 85,
    SnapInterval = 0.01,
    PredictLead = 0.162,
    SampleInterval = 0.08,
    MaxSampleJump = 300,
    TweenSpeed = 200,
    OffsetRadius = 10,
    OffsetRefresh = 0.7,
    TweenRefreshDist = 4,
    Tween = game:GetService("TweenService")
}

local function StopTween()
    if ActiveTween then
        ActiveTween:Cancel()
        ActiveTween = nil
    end
end

local Noclip = {
    Conn = nil,
    DescConn = nil,
    Char = nil,
    Parts = nil,
    Saved = nil,
    NoCollideChar = nil,
    NoCollideParts = nil
}

local function NoclipStrip(part, saved)
    if part:IsA("BasePart") and part.CanCollide then
        saved[part] = true
        part.CanCollide = false
    end
end

local function NoclipRestore(saved)
    if not saved then return end
    for part in pairs(saved) do
        pcall(function()
            if part.Parent then
                part.CanCollide = true
            end
        end)
    end
end

local function NoclipBind(char)
    NoclipRestore(Noclip.Saved)
    Noclip.Saved = {}
    Noclip.Char = char
    Noclip.Parts = {}
    if Noclip.DescConn then
        Noclip.DescConn:Disconnect()
        Noclip.DescConn = nil
    end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("BasePart") then
            Noclip.Parts[#Noclip.Parts + 1] = d
            NoclipStrip(d, Noclip.Saved)
        end
    end
    Noclip.DescConn = char.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then
            Noclip.Parts[#Noclip.Parts + 1] = d
            NoclipStrip(d, Noclip.Saved)
        end
    end)
end

local function NoclipStart()
    if Noclip.Conn then return end
    Noclip.Saved = {}
    local char = LocalPlayer.Character
    if char then NoclipBind(char) end
    Noclip.Conn = RunService.Stepped:Connect(function()
        local current = LocalPlayer.Character
        if not current then return end
        if current ~= Noclip.Char then
            NoclipBind(current)
            return
        end
        local parts = Noclip.Parts
        if not parts then return end
        for i = #parts, 1, -1 do
            local part = parts[i]
            if not part.Parent then
                table.remove(parts, i)
            elseif part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function NoclipStop()
    if Noclip.Conn then
        Noclip.Conn:Disconnect()
        Noclip.Conn = nil
    end
    if Noclip.DescConn then
        Noclip.DescConn:Disconnect()
        Noclip.DescConn = nil
    end
    NoclipRestore(Noclip.Saved)
    Noclip.Char = nil
    Noclip.Parts = nil
    Noclip.Saved = nil
end

local function SetNoCollide()
    local char = LocalPlayer.Character
    if not char then return end
    if Noclip.NoCollideChar == char and Noclip.NoCollideParts then
        for _, part in ipairs(Noclip.NoCollideParts) do
            if part.Parent and part.CanCollide then part.CanCollide = false end
        end
        return
    end
    Noclip.NoCollideChar = char
    Noclip.NoCollideParts = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            Noclip.NoCollideParts[#Noclip.NoCollideParts + 1] = part
            if part.CanCollide then part.CanCollide = false end
        end
    end
end

local function SetCollide()
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Name == "HumanoidRootPart"
                or part.Name:find("LowerTorso")
                or part.Name:find("UpperTorso") then
                part.CanCollide = true
            end
        end
    end
end

local TweenTargetPos = nil

local function MoveTo(cf, speed)
    local hrp = GetHRP(LocalPlayer)
    local hum = GetHumanoid(LocalPlayer)
    if not hrp or not hum then return end
    if ActiveTween and ActiveTween.PlaybackState == Enum.PlaybackState.Playing
        and TweenTargetPos and (cf.Position - TweenTargetPos).Magnitude <= RJR.TweenRefreshDist then
        return
    end
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
    local distance = (cf.Position - hrp.Position).Magnitude
    speed = math.max(tonumber(speed) or RJR.TweenSpeed, 1)
    StopTween()
    local tween = RJR.Tween:Create(hrp, TweenInfo.new(distance / speed, Enum.EasingStyle.Linear), { CFrame = cf })
    ActiveTween = tween
    TweenTargetPos = cf.Position
    NoclipStart()
    tween:Play()
end

local function RandomOffset()
    local now = tick()
    if now >= NextOffsetRefresh then
        OffsetAngle = Random:NextNumber(0, math.pi * 2)
        NextOffsetRefresh = now + RJR.OffsetRefresh
    end
    return Vector3.new(math.cos(OffsetAngle) * RJR.OffsetRadius, 0, math.sin(OffsetAngle) * RJR.OffsetRadius)
end

local HopActive
local ClearFlightComponents

local ChaseDiag = {
    Steps = 0,
    Moves = 0,
    Direct = 0,
    Mode = "tween",
    LastPos = nil,
    LastPosTime = 0,
    LastStepTime = 0,
    StuckCount = 0
}

local function DirectStepMove(targetPos, now)
    local hrp = GetHRP(LocalPlayer)
    local hum = GetHumanoid(LocalPlayer)
    if not hrp or not hum then return false end
    local dt = now - (ChaseDiag.LastStepTime > 0 and ChaseDiag.LastStepTime or now)
    ChaseDiag.LastStepTime = now
    dt = math.clamp(dt, 0.001, 0.1)
    local delta = targetPos - hrp.Position
    if delta.Magnitude < 0.01 then return false end
    local step = math.min(RJR.TweenSpeed * dt, delta.Magnitude)
    SetNoCollide()
    NoclipStart()
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
    pcall(function()
        hrp.CFrame = CFrame.new(hrp.Position + delta.Unit * step) * (hrp.CFrame - hrp.CFrame.Position)
    end)
    ChaseDiag.Direct = ChaseDiag.Direct + 1
    return true
end

local function ChaseStep()
    ChaseDiag.Steps = ChaseDiag.Steps + 1
    local myHRP = GetHRP(LocalPlayer)
    local myHum = GetHumanoid(LocalPlayer)
    if not myHRP or not myHum or myHum.Health <= 0 then
        StopTween()
        NoclipStop()
        return
    end

    local targetRoot = CurrentTarget
        and CurrentTarget.Character
        and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        targetRoot = CurrentTargetRoot
    end
    if not targetRoot or not targetRoot.Parent then
        StopTween()
        NoclipStop()
        ChaseSample = nil
        return
    end
    CurrentTargetRoot = targetRoot
    Aim.Part = targetRoot
    Aim.Pos = targetRoot.CFrame

    if FleeActive or HopActive() then
        StopTween()
        NoclipStop()
        return
    end

    local targetPos = targetRoot.Position
    local dist = (myHRP.Position - targetPos).Magnitude
    local vel = Vector3.zero
    local now = tick()
    if ChaseSample then
        local dt = now - ChaseSample.t
        if dt > 0 and dt < 1 and (targetPos - ChaseSample.pos).Magnitude <= RJR.MaxSampleJump then
            vel = (targetPos - ChaseSample.pos) / dt
        end
    end
    if not ChaseSample or now - ChaseSample.t >= RJR.SampleInterval then
        ChaseSample = { pos = targetPos, t = now }
    end

    local off = RandomOffset()
    if dist <= RJR.SnapDist then
        StopTween()
        ClearFlightComponents()
        ChaseDiag.Mode = "tween"
        ChaseDiag.StuckCount = 0
        ChaseDiag.LastPos = nil
        myHRP.AssemblyLinearVelocity = Vector3.zero
        NoclipStart()
        if now - ChaseLastSnap >= RJR.SnapInterval then
            ChaseLastSnap = now
            pcall(function()
                myHRP.CFrame = targetRoot.CFrame + vel * RJR.PredictLead + off
            end)
        end
        return
    end

    if not ChaseDiag.LastPos or (now - ChaseDiag.LastPosTime) >= 1.5 then
        if ChaseDiag.LastPos
            and (myHRP.Position - ChaseDiag.LastPos).Magnitude < 5
            and dist > RJR.SnapDist then
            ChaseDiag.StuckCount = ChaseDiag.StuckCount + 1
            if ChaseDiag.Mode ~= "direct" then
                ChaseDiag.Mode = "direct"
                StopTween()
                ClearFlightComponents()
            end
        end
        ChaseDiag.LastPos = myHRP.Position
        ChaseDiag.LastPosTime = now
    end

    if ChaseDiag.Mode == "direct" then
        DirectStepMove(targetPos + off, now)
    else
        MoveTo(targetRoot.CFrame + off, RJR.TweenSpeed)
        ChaseDiag.Moves = ChaseDiag.Moves + 1
    end
end

local function StartChase()
    if ChaseActive then return end
    ChaseActive = true
    ChaseConnection = RunService.Stepped:Connect(function()
        if not Settings.AutoBounty or not ChaseActive then return end
        SafeCall(ChaseStep)
    end)
end

local function StopChase()
    ChaseActive = false
    if ChaseConnection then
        ChaseConnection:Disconnect()
        ChaseConnection = nil
    end
    StopTween()
    NoclipStop()
    SetCollide()
    ChaseSample = nil
    ChaseLastSnap = 0
end

local function ResetTarget()
    CurrentTarget = nil
    CurrentTargetRoot = nil
    UpdateAimTarget()
    ChaseSample = nil
    ChaseLastSnap = 0
    StopTween()
    TargetLostTime = tick()
end
local function SetTarget(plr)
    if not plr or LockGuard.IsBlacklisted(plr) then return false end
    LockGuard.RegisterLock(plr)
    CurrentTarget = plr
    CurrentTargetRoot = plr and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart") or nil
    ChaseSample = nil
    ChaseLastSnap = 0
    TargetInvalidSince = nil
    TargetLockStart = tick()
    ResetAbandonTracking()
    StopTween()
    return true
end

local Flight = {
    Speed = 250,
    Attachment = nil,
    Velocity = nil,
    Force = nil,
    DescentTime = 0,
    DescentLastY = nil,
    DescentLastClock = nil,
    DescentHRP = nil
}
local DESCENT_ACCEL_TIME = 1.2

local function SetCharNoclip(char, enabled)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

function ClearFlightComponents()
    for _, key in ipairs({ "Velocity", "Force", "Attachment" }) do
        local obj = Flight[key]
        if obj then
            pcall(function() obj:Destroy() end)
            Flight[key] = nil
        end
    end
    Flight.DescentTime = 0
    Flight.DescentLastY = nil
    Flight.DescentLastClock = nil
    Flight.DescentHRP = nil
end

local function SetupFlightComponents(hrp)
    if Flight.Velocity and Flight.Velocity.Parent == hrp
        and Flight.Attachment and Flight.Attachment.Parent == hrp then
        return
    end

    ClearFlightComponents()

    local att = Instance.new("Attachment")
    att.Name = "AutoBounty_FlightAttachment"
    att.Parent = hrp
    Flight.Attachment = att

    local lv = Instance.new("LinearVelocity")
    lv.Name = "AutoBounty_FlightVelocity"
    lv.MaxForce = math.huge
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    lv.VectorVelocity = Vector3.zero
    lv.Attachment0 = att
    lv.Parent = hrp
    Flight.Velocity = lv

    local totalMass = 0
    local char = hrp.Parent
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and not part.Massless then
                totalMass = totalMass + part:GetMass()
            end
        end
    end

    local vf = Instance.new("VectorForce")
    vf.Name = "AutoBounty_AntiGravity"
    vf.ApplyAtCenterOfMass = true
    vf.Attachment0 = att
    vf.Force = Vector3.new(0, totalMass * Workspace.Gravity, 0)
    vf.Parent = hrp
    Flight.Force = vf
end

local function ResetDescentState()
    Flight.DescentTime = 0
    Flight.DescentLastY = nil
    Flight.DescentLastClock = nil
end

local function UpdateDescentState(hrp, descending)
    local now = os.clock()

    if not hrp then
        ResetDescentState()
        return 1
    end

    if Flight.DescentHRP ~= hrp then
        Flight.DescentHRP = hrp
        ResetDescentState()
        return 1
    end

    local lastY = Flight.DescentLastY
    local lastClock = Flight.DescentLastClock
    Flight.DescentLastY = hrp.Position.Y
    Flight.DescentLastClock = now

    if not lastY or not lastClock then return 1 end

    local dt = now - lastClock
    if dt <= 0 then return 1 end

    local dropRate = (lastY - hrp.Position.Y) / dt
    if descending and dropRate >= 5 then
        Flight.DescentTime = math.min(Flight.DescentTime + dt, DESCENT_ACCEL_TIME)
    else
        Flight.DescentTime = 0
    end

    local progress = Flight.DescentTime / DESCENT_ACCEL_TIME
    return 1 + (2.0 - 1) * (progress * progress)
end

local function FlyMoveTo(pos)
    if not pos then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    SetupFlightComponents(hrp)

    local dir = pos - hrp.Position
    if dir.Magnitude > 0.1 then
        local mult = UpdateDescentState(hrp, dir.Y < 0)
        if Flight.Velocity then
            Flight.Velocity.VectorVelocity = dir.Unit * Flight.Speed * mult
        end
    else
        if Flight.Velocity then
            Flight.Velocity.VectorVelocity = Vector3.zero
        end
        ResetDescentState()
    end
end

local function FlyStop()
    ResetDescentState()
    if Flight.Velocity then
        Flight.Velocity.VectorVelocity = Vector3.zero
    end
end

local function FleeUpLogic()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or hum.Health <= 0 then return end

        SetCharNoclip(char, true)
        FlyMoveTo(hrp.Position + Vector3.new(0, 100, 0))
    end)
end

local function IsMarineTeam()
    local ok, teamName = pcall(function()
        return LocalPlayer.Team and LocalPlayer.Team.Name
    end)
    if ok and teamName == "Marines" then return true end

    local okData, dataTeam = pcall(function()
        local data = LocalPlayer:FindFirstChild("Data")
        local teamVal = data and data:FindFirstChild("Team")
        return teamVal and teamVal.Value
    end)
    return okData and dataTeam == "Marines"
end

local function IsMarineBountyRiskUI()
    local mainUI = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
    local bottomHUD = mainUI and mainUI:FindFirstChild("BottomHUDList")
    if not bottomHUD then return false end

    local function IsActive(obj)
        if not obj then return false end
        return (not obj:IsA("GuiObject")) or obj.Visible
    end

    if IsActive(bottomHUD:FindFirstChild("CampBounty")) then return true end
    if IsActive(bottomHUD:FindFirstChild("initHonor")) then return true end

    local inCombatUI = bottomHUD:FindFirstChild("InCombat")
    local nestedHonor = inCombatUI and inCombatUI:FindFirstChild("initHonor")
    if IsActive(nestedHonor) then return true end

    return false
end

local function GetCombatStatus()
    local mainUI = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
    local bottomHUD = mainUI and mainUI:FindFirstChild("BottomHUDList")
    local inCombatUI = bottomHUD and bottomHUD:FindFirstChild("InCombat")

    if inCombatUI and inCombatUI.Visible then
        local rawText = ""
        if inCombatUI:IsA("TextLabel") then
            rawText = inCombatUI.Text
        else
            local childText = inCombatUI:FindFirstChildWhichIsA("TextLabel", true)
            if childText then rawText = childText.Text end
        end

        local lowerText = string.lower(rawText)
        local isBountyRisk = string.find(lowerText, "bounty at risk")
            or string.find(lowerText, "bounty")
            or string.find(lowerText, "賞金")
        local isHonorRisk = string.find(lowerText, "honor at risk")
            or string.find(lowerText, "honor")
            or string.find(lowerText, "榮譽")
            or string.find(lowerText, "军衔")
            or string.find(lowerText, "軍銜")

        if IsMarineTeam() and (isHonorRisk or IsMarineBountyRiskUI()) then
            return "BountyAtRisk"
        end
        if isBountyRisk or isHonorRisk then
            return "BountyAtRisk"
        end
        return "InCombatNoRisk"
    end

    if IsMarineTeam() and IsMarineBountyRiskUI() then
        return "BountyAtRisk"
    end
    return "NotInCombat"
end

local CombatCache, CombatCacheTime = "NotInCombat", 0
local function IsBountyAtRisk()
    local now = os.clock()
    if now - CombatCacheTime >= 0.5 then
        CombatCacheTime = now
        CombatCache = GetCombatStatus()
    end
    return CombatCache == "BountyAtRisk"
end

local HopMinPlayers, HopMaxPlayers = 1, 12
local function ApplyPlayerRange(label)
    local a, b = tostring(label):match("(%d+)%-(%d+)")
    HopMinPlayers = tonumber(a) or 1
    HopMaxPlayers = tonumber(b) or 12
end
ApplyPlayerRange(Settings.HopPlayerRange)

local HopMinBounty, HopMaxBounty = 0, 999999999
local function ApplyBountyRange(label)
    local numText = tostring(label):match("([%d%.]+%s*[Mm]?)")
    if numText then
        local num, unit = numText:match("([%d%.]+)%s*([Mm]?)")
        local value = tonumber(num) or 0
        if unit and unit:lower() == "m" then value = value * 1000000 end
        HopMinBounty = value + 1
        HopMaxBounty = 999999999
    else
        HopMinBounty = 0
        HopMaxBounty = 999999999
    end
end
ApplyBountyRange(Settings.HopBountyRange)

local function FormatNumber(n)
    local s = tostring(math.floor(tonumber(n) or 0))
    local left, num, right = s:match("^([^%d]*%d)(%d*)(.-)$")
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

local HUD = {}

local function SetupHUD()
local RE_EXECUTE_URL = "https://rjr-loader.top/script/auto_bounty"
local SCRIPT_START_TICK = tick()
local RunTimeCarry = tonumber(getgenv and getgenv().AutoBountyRunTime) or 0
local BountyBase = nil
local BountyPending = nil
local LastEarned = 0

local function GetMyBounty()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    local value = stats and stats:FindFirstChild("Bounty/Honor")
    return value and tonumber(value.Value) or nil
end

local function GetRunTime()
    return RunTimeCarry + (tick() - SCRIPT_START_TICK)
end

local function GetBountyBase()
    local current = GetMyBounty()
    if BountyBase ~= nil then return BountyBase end
    if not current then return nil end
    if BountyPending == current then
        BountyBase = current
    else
        BountyPending = current
        return nil
    end
    return BountyBase
end

local function GetEarnedBounty()
    local current = GetMyBounty()
    if not current then return LastEarned end
    local base = GetBountyBase()
    if base == nil then return LastEarned end
    LastEarned = current - base
    return LastEarned
end

local function FormatRunTime(seconds)
    seconds = math.max(math.floor(tonumber(seconds) or 0), 0)
    local h = math.floor(seconds / 3600)
    local m = math.floor(seconds % 3600 / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function GetInfoPanelParent()
    local parent
    pcall(function()
        if type(gethui) == "function" then parent = gethui() end
    end)
    if parent then return parent end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer:FindFirstChild("PlayerGui")
end

local function CreateInfoPanel()
    local parent = GetInfoPanelParent()
    if not parent then return nil end
    local existing = parent:FindFirstChild("AutoBountyInfoPanel")
    if existing then existing:Destroy() end

    -- ═══ Vietnamese Lib Premium Theme Colors ═══
    local VT = {
        PRIMARY     = Color3.fromRGB(122, 92, 255),
        SECONDARY   = Color3.fromRGB(24, 200, 255),
        GLOW        = Color3.fromRGB(120, 110, 255),
        BG_DEEP     = Color3.fromRGB(11, 13, 18),
        BG_PANEL    = Color3.fromRGB(15, 17, 23),
        STROKE_DARK = Color3.fromRGB(60, 70, 95),
        TEXT_BRIGHT = Color3.fromRGB(220, 225, 235),
        TEXT_DIM    = Color3.fromRGB(140, 150, 175),
    }
    local GRAD_HOT = ColorSequence.new{
        ColorSequenceKeypoint.new(0, VT.PRIMARY),
        ColorSequenceKeypoint.new(1, VT.SECONDARY),
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoBountyInfoPanel"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 100
    gui.Parent = parent

    -- Outer panel — dark premium card
    local bar = Instance.new("Frame")
    bar.Name = "Bar"
    bar.AnchorPoint = Vector2.new(0.5, 0)
    bar.Position = UDim2.new(0.5, 0, 0, 6)
    bar.Size = UDim2.new(0, 310, 0, 54)
    bar.BackgroundColor3 = VT.BG_PANEL
    bar.BackgroundTransparency = 0
    bar.BorderSizePixel = 0
    bar.Parent = gui

    -- Rounded corners (spec: 16px)
    local barCorner = Instance.new("UICorner", bar)
    barCorner.CornerRadius = UDim.new(0, 16)

    -- Subtle gradient depth (BG_PANEL → BG_DEEP)
    local bgGrad = Instance.new("UIGradient", bar)
    bgGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, VT.BG_PANEL),
        ColorSequenceKeypoint.new(1, VT.BG_DEEP),
    }
    bgGrad.Rotation = 135

    -- Glow stroke (spec: GLOW, 1.5px, 0.35 transparency)
    local stroke = Instance.new("UIStroke", bar)
    stroke.Color = VT.GLOW
    stroke.Thickness = 1.5
    stroke.Transparency = 0.35

    -- Soft shadow image (classic Roblox drop shadow asset)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Parent = bar
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.BorderSizePixel = 0
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 120, 1, 120)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = VT.GLOW
    shadow.ImageTransparency = 0.65
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)

    local labels = {}

    -- Column builder with premium neon styling
    local function MakeColumn(index, title)
        local COLUMN_WIDTH = 130
        local COL_X = 16 + (index - 1) * (COLUMN_WIDTH + 18)

        local col = Instance.new("Frame")
        col.Name = title
        col.BackgroundTransparency = 1
        col.BorderSizePixel = 0
        col.Position = UDim2.new(0, COL_X, 0, 5)
        col.Size = UDim2.new(0, COLUMN_WIDTH, 0, 44)
        col.Parent = bar

        -- Caption label (dim)
        local caption = Instance.new("TextLabel")
        caption.Name = "Caption"
        caption.BackgroundTransparency = 1
        caption.BorderSizePixel = 0
        caption.Position = UDim2.new(0, 0, 0, 0)
        caption.Size = UDim2.new(1, 0, 0, 15)
        caption.Font = Enum.Font.GothamSemibold
        caption.Text = title
        caption.TextSize = 10
        caption.TextColor3 = VT.TEXT_DIM
        caption.TextXAlignment = Enum.TextXAlignment.Left
        caption.Parent = col

        -- Accent underline dot / gradient marker
        local dot = Instance.new("Frame")
        dot.Name = "Dot"
        dot.BackgroundColor3 = VT.PRIMARY
        dot.BorderSizePixel = 0
        dot.Position = UDim2.new(0, 0, 0, 14)
        dot.Size = UDim2.new(0, 28, 0, 2)
        dot.Parent = col
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local dotGrad = Instance.new("UIGradient", dot)
        dotGrad.Color = GRAD_HOT
        dotGrad.Rotation = 0

        -- Value label (bright, bold, gradient)
        local value = Instance.new("TextLabel")
        value.Name = "Value"
        value.BackgroundTransparency = 1
        value.BorderSizePixel = 0
        value.Position = UDim2.new(0, 0, 0, 20)
        value.Size = UDim2.new(1, 0, 0, 22)
        value.Font = Enum.Font.GothamBold
        value.Text = "-"
        value.TextSize = 16
        value.TextColor3 = VT.PRIMARY
        value.TextXAlignment = Enum.TextXAlignment.Left
        value.RichText = false
        value.Parent = col

        -- Gradient on value text
        local valGrad = Instance.new("UIGradient", value)
        valGrad.Color = GRAD_HOT
        valGrad.Rotation = 90

        labels[title] = value
        return col
    end

    MakeColumn(1, T("当前赏金"))
    MakeColumn(2, T("运行时间"))

    -- Vertical divider between columns (premium glow style)
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.BackgroundColor3 = VT.PRIMARY
    divider.BackgroundTransparency = 0
    divider.BorderSizePixel = 0
    divider.Position = UDim2.new(0, 163, 0, 10)
    divider.Size = UDim2.new(0, 1, 0, 34)
    divider.Parent = bar

    local divGrad = Instance.new("UIGradient", divider)
    divGrad.Color = GRAD_HOT
    divGrad.Rotation = 90
    divGrad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    }

    return gui, labels
end

local InfoPanel, InfoLabels = CreateInfoPanel()

local function SetLabelText(label, text)
    if not label or label.Text == text then return end
    pcall(function() label.Text = text end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        local ok = pcall(function()
            if not InfoLabels then
                InfoPanel, InfoLabels = CreateInfoPanel()
                if not InfoLabels then return end
            end
            local current = GetMyBounty()
            SetLabelText(InfoLabels[T("当前赏金")], current and FormatNumber(current) or "-")
            SetLabelText(InfoLabels[T("运行时间")], FormatRunTime(GetRunTime()))
        end)
        if not ok then
            LastCaughtError = T("信息面板更新异常")
        end
    end
end)

local function BuildReExecuteScript()
    GetEarnedBounty()
    local parts = { "getgenv().SovereignHubLoaded = nil" }
    parts[#parts + 1] = string.format("getgenv().AutoBountyRunTime = %.0f", GetRunTime())
    parts[#parts + 1] = string.format("getgenv().AutoBountyEarned = %.0f", LastEarned)
    parts[#parts + 1] = string.format('loadstring(game:HttpGet("%s"))()', RE_EXECUTE_URL)
    return table.concat(parts, "\n") .. "\n"
end

local function QueueAutoReExecute()
    local source = BuildReExecuteScript()
    if type(queue_on_teleport) == "function" then
        return select(1, pcall(queue_on_teleport, source))
    end
    if type(queueonteleport) == "function" then
        return select(1, pcall(queueonteleport, source))
    end
    if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
        return select(1, pcall(syn.queue_on_teleport, source))
    end
    return false
end

HUD.GetPanelParent = GetInfoPanelParent
HUD.GetRunTime = GetRunTime
HUD.GetEarnedBounty = GetEarnedBounty
HUD.QueueAutoReExecute = QueueAutoReExecute
end

SetupHUD()

local ServerHopCache = { List = nil, Fetching = false }

local function FetchServerList(timeout)
    local browser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
    if not browser then return nil end
    local servers, pending = {}, 0
    for page = 1, 100 do
        pending = pending + 1
        task.delay(page * 0.02, function()
            local ok, result = pcall(function() return browser:InvokeServer(page) end)
            if not ok then
                local tries = 0
                repeat
                    task.wait(0.5)
                    tries = tries + 1
                    ok, result = pcall(function() return browser:InvokeServer(page) end)
                until ok or tries >= 2
            end
            if ok and type(result) == "table" then
                for job, info in pairs(result) do
                    if type(info) == "table" then
                        servers[job] = {
                            Region = tostring(info.Region or "Unknown"),
                            Count = tonumber(info.Count) or 0,
                            Bounty = tonumber(info.Bounty) or 0
                        }
                    end
                end
            end
            pending = pending - 1
        end)
    end
    local deadline = tick() + (timeout or 20)
    while pending > 0 and tick() < deadline do task.wait(0.1) end
    return servers
end

local function GetServerList()
    if ServerHopCache.List then return ServerHopCache.List end
    if ServerHopCache.Fetching then
        local deadline = tick() + 25
        while ServerHopCache.Fetching and tick() < deadline do task.wait(0.1) end
        return ServerHopCache.List
    end
    ServerHopCache.Fetching = true
    local ok, servers = pcall(FetchServerList, 20)
    ServerHopCache.Fetching = false
    if ok and type(servers) == "table" and next(servers) then
        ServerHopCache.List = servers
    end
    return ServerHopCache.List
end

local function MatchRegion(info)
    if not info then return false end
    local want = tostring(Settings.ServerRegion or "")
    if want == "" or want == T("随机") or want == "Random" then return true end
    return tostring(info.Region or ""):lower():find(want:lower(), 1, true) ~= nil
end

local function MatchServer(info)
    if not info then return false end
    if not MatchRegion(info) then return false end
    local count = tonumber(info.Count) or 0
    if count < HopMinPlayers or count > HopMaxPlayers then return false end
    local bounty = tonumber(info.Bounty) or 0
    return bounty >= HopMinBounty and bounty <= HopMaxBounty
end

local function MatchServerRelaxed(info)
    return MatchRegion(info)
end

local function CollectMatches(servers, predicate)
    local matches = {}
    if type(servers) ~= "table" then return matches end
    for job, info in pairs(servers) do
        if job ~= game.JobId and predicate(info) then
            table.insert(matches, { Job = job, Region = info.Region, Count = info.Count, Bounty = info.Bounty })
        end
    end
    return matches
end

local function PickServer(servers)
    local matches = CollectMatches(servers, MatchServer)
    if #matches > 0 then
        return matches[math.random(1, #matches)], false
    end
    local relaxed = CollectMatches(servers, MatchServerRelaxed)
    if #relaxed > 0 then
        return relaxed[math.random(1, #relaxed)], true
    end
    return nil, false
end

local HopPhase = "idle"
local HopPrepStartY = nil

function HopActive()
    return HopPhase ~= "idle"
end

local HopAscendThread = nil
local function StartHopAscend()
    if HopAscendThread then return end
    if not HopPrepStartY then
        local hrp0 = GetHRP(LocalPlayer)
        HopPrepStartY = hrp0 and hrp0.Position.Y or 0
    end
    HopAscendThread = task.spawn(function()
        while HopActive() do
            local hrp = GetHRP(LocalPlayer)
            if hrp then
                if hrp.Position.Y - HopPrepStartY < 1500 then
                    SafeCall(FleeUpLogic)
                else
                    FlyStop()
                end
            end
            task.wait(0.1)
        end
        FlyStop()
        ClearFlightComponents()
        local char = LocalPlayer.Character
        if char then SetCharNoclip(char, false) end
        HopPrepStartY = nil
        HopAscendThread = nil
    end)
end

local HopInterruptedByDanger = false
local HOP_LANDING_GRACE = 5
local HOP_DELAY = 5
local HopCooldownUntil = 0
local HopWaitUntil = 0

local function BeginHopMatch()
    HopPhase = "matching"
    task.spawn(function()
        local servers = GetServerList()
        local target = PickServer(servers)
        if not target then
            ServerHopCache.List = nil
            servers = GetServerList()
            target = PickServer(servers)
        end

        if not HopActive() then return end

        if not target then
            task.wait(3)
            HopPhase = "idle"
            HopCooldownUntil = tick() + HOP_LANDING_GRACE
            return
        end

        if IsBountyAtRisk() then
            HopPhase = "preparing"
            HopInterruptedByDanger = true
            return
        end

        local browser = ReplicatedStorage:FindFirstChild("__ServerBrowser")
        if browser then
            if not HopActive() or IsBountyAtRisk() or (CurrentTarget and not Stay.Armed) then
                return
            end
            HUD.QueueAutoReExecute()
            pcall(function() browser:InvokeServer("teleport", target.Job) end)
        end
        task.wait(5)
        HopPhase = "idle"
    end)
end

local function DoServerHop()
    if HopActive() then return end

    HopPhase = "preparing"
    HopPrepStartY = nil
    ResetTarget()
    StartHopAscend()

    if IsBountyAtRisk() then
        HopInterruptedByDanger = true
        return
    end

    HopPhase = "waiting"
    HopWaitUntil = tick() + HOP_DELAY
end
task.spawn(function()
    while true do
        task.wait(0.2)
        if HopPhase == "waiting" then
            if IsBountyAtRisk() then
                HopPhase = "preparing"
                HopInterruptedByDanger = true
            elseif tick() >= HopWaitUntil then
                BeginHopMatch()
            end
        elseif HopPhase == "matching" and IsBountyAtRisk() then
            HopPhase = "preparing"
            HopInterruptedByDanger = true
        elseif HopPhase == "preparing" and not IsBountyAtRisk() then
            HopInterruptedByDanger = false
            if CurrentTarget and not Stay.Armed then
                HopPhase = "idle"
            elseif Settings.AutoBounty then
                HopPhase = "waiting"
                HopWaitUntil = tick() + HOP_DELAY
            else
                HopPhase = "idle"
            end
        end
    end
end)

do
    local function ArmForcedHop()
        Stay.Armed = true
        if CurrentTarget then ResetTarget() end
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if Stay:Reached() then
                if not Stay.Armed then ArmForcedHop() end
                if not HopActive() and tick() >= HopCooldownUntil then
                    DoServerHop()
                end
            elseif Stay.Armed then
                Stay.Armed = false
            end
        end
    end)
end

do
    local DEATH_HOP_LIMIT = 2
    local DeathCount = 0
    local DeathBound = nil

    local function OnDeath()
        if HopActive() then return end
        DeathCount += 1
        if DeathCount < DEATH_HOP_LIMIT then return end
        DeathCount = 0
        SafeCall(DoServerHop)
    end

    local function BindDeathHop()
        local hum = GetHumanoid(LocalPlayer)
        if not hum or hum == DeathBound then return end
        DeathBound = hum
        hum.Died:Connect(OnDeath)
    end

    BindDeathHop()

    LocalPlayer.CharacterAdded:Connect(function()
        DeathBound = nil
        task.wait(0.2)
        BindDeathHop()
    end)

    task.spawn(function()
        while true do
            task.wait(0.5)
            if GetHumanoid(LocalPlayer) ~= DeathBound then BindDeathHop() end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoEnablePVP then
            pcall(function() CommF:InvokeServer("EnablePvp") end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2)
        if Settings.AutoHaki then
            local char = LocalPlayer.Character
            if char and not char:FindFirstChild("HasBuso") then
                pcall(function() CommF:InvokeServer("Buso") end)
            end
        end
    end
end)

local function StartAutoKenLoop()
local KEN_PRESS_GAP = 1.2
local KEN_VERIFY = 1.0
local KEN_FAIL_BACKOFF = 20
local KEN_MAX_FAILS = 3
local KEN_DISABLE_LOCK = 5.5

local function KenChar()
    local char = LocalPlayer.Character
    if not char or not char.Parent then
        return nil
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
        return nil
    end
    return char
end

local function KenOn()
    local active = LocalPlayer:GetAttribute("KenActive")
    if active ~= nil then return active == true end
    local blur = game:GetService("Lighting"):FindFirstChild("Blur")
    return (blur and blur.Enabled) and true or false
end

local function KenPressKey()
    local code = Enum.KeyCode.E
    VirtualInputManager:SendKeyEvent(true, code, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, code, false, game)
end

local KenNextAt, KenFailCount, KenPendingAt, KenLockUntil = 0, 0, 0, 0
local KenDisableBound = false
local KenStatus = nil

local function BindKenDisable()
    if KenDisableBound then return end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local disable = remotes and remotes:FindFirstChild("DisableKen")
    if not disable then return end
    KenDisableBound = true
    pcall(function()
        disable.OnClientEvent:Connect(function()
            KenLockUntil = os.clock() + KEN_DISABLE_LOCK
        end)
    end)
end

local function KenStep()
    if not Settings.AutoKen then
        KenNextAt, KenFailCount, KenPendingAt = 0, 0, 0
        KenStatus = "off"
        return KenStatus
    end

    BindKenDisable()
    local char = KenChar()
    local now = os.clock()

    if not char then
        KenNextAt, KenFailCount, KenPendingAt = 0, 0, 0
        KenStatus = "no_char"
    elseif KenOn() then
        KenNextAt, KenFailCount, KenPendingAt = 0, 0, 0
        KenStatus = "on"
    elseif char:FindFirstChild("KenDisabled") then
        KenNextAt, KenFailCount, KenPendingAt = 0, 0, 0
        KenStatus = "blocked"
    elseif now < KenLockUntil then
        KenStatus = "locked"
    elseif now >= KenNextAt then
        if KenPendingAt > 0 and now - KenPendingAt >= KEN_VERIFY then
            KenFailCount = KenFailCount + 1
        end
        KenPendingAt = 0
        if KenFailCount >= KEN_MAX_FAILS then
            KenStatus = "fail"
            KenFailCount = 0
            KenNextAt = now + KEN_FAIL_BACKOFF
        else
            KenStatus = "trying"
            KenPressKey()
            KenPendingAt = os.clock()
            KenNextAt = os.clock() + KEN_PRESS_GAP
        end
    else
        KenStatus = "wait"
    end
    return KenStatus
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(KenStep)
    end
end)
end

StartAutoKenLoop()

task.spawn(function()
    while true do
        task.wait(2)
        local team = LocalPlayer.Team
        if not team or team.Name ~= Settings.SelectTeam then
            ApplyTeam(Settings.SelectTeam)
        end
    end
end)

local function StartV3Loop()
local AUTO_V3_RANGE = 150
local AUTO_V3_COOLDOWN = 1.5

local function ConsiderEnemy(hrp, myPos, best, myHRP)
    if not hrp or hrp == myHRP then return best end
    local dist = (hrp.Position - myPos).Magnitude
    if not best or dist < best then return dist end
    return best
end

local function GetNearestEnemyDistance(limit)
    local myHRP = GetHRP(LocalPlayer)
    if not myHRP then return nil end
    local myPos = myHRP.Position
    local best = nil
    if CurrentTarget and CurrentTarget ~= LocalPlayer then
        best = ConsiderEnemy(GetHRP(CurrentTarget), myPos, best, myHRP)
    end
    if not best or not limit or best > limit then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local hum = GetHumanoid(plr)
                if hum and hum.Health > 0 then
                    best = ConsiderEnemy(GetHRP(plr), myPos, best, myHRP)
                end
            end
        end
    end
    if best and limit and best <= limit then return best end
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, model in ipairs(enemies:GetChildren()) do
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                best = ConsiderEnemy(model:FindFirstChild("HumanoidRootPart"), myPos, best, myHRP)
                if best and limit and best <= limit then break end
            end
        end
    end
    return best
end

local function V3Ready()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local transformed = char:FindFirstChild("RaceTransformed")
    if transformed and transformed.Value then return false end
    return true
end

local function V3Wanted()
    local char = LocalPlayer.Character
    if char and char:GetAttribute("InCombat") == true then return true end
    local myHRP = GetHRP(LocalPlayer)
    if myHRP and CurrentTarget and CurrentTarget ~= LocalPlayer then
        local targetHRP = GetHRP(CurrentTarget)
        if targetHRP and (targetHRP.Position - myHRP.Position).Magnitude <= AUTO_V3_RANGE then
            return true
        end
    end
    local dist = GetNearestEnemyDistance(AUTO_V3_RANGE)
    return dist ~= nil and dist <= AUTO_V3_RANGE
end

local V3NextAt = 0

local function V3Step()
    if not Settings.AutoV3 then return "off" end
    if not GetHRP(LocalPlayer) then return "no_char" end
    if not V3Ready() then return "busy" end
    if tick() < V3NextAt then return "wait" end
    if not V3Wanted() then return "no_enemy" end
    pcall(function() CommE:FireServer("ActivateAbility") end)
    V3NextAt = tick() + AUTO_V3_COOLDOWN
    return "fired"
end

task.spawn(function()
    while not GetHRP(LocalPlayer) do
        task.wait(0.5)
    end
    while true do
        task.wait(0.5)
        pcall(V3Step)
    end
end)
end

StartV3Loop()

local function GetAwakeningRemote()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local awakening = backpack and backpack:FindFirstChild("Awakening")
    if awakening and awakening:FindFirstChild("RemoteFunction") then
        return awakening.RemoteFunction
    end
    local char = LocalPlayer.Character
    local charAwakening = char and char:FindFirstChild("Awakening")
    if charAwakening and charAwakening:FindFirstChild("RemoteFunction") then
        return charAwakening.RemoteFunction
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(0.5)
        local char = LocalPlayer.Character
        local energy = char and char:FindFirstChild("RaceEnergy")
        local transformed = char and char:FindFirstChild("RaceTransformed")
        if energy and transformed and energy.Value >= 1 and not transformed.Value then
            local remote = GetAwakeningRemote()
            if remote then
                pcall(function() remote:InvokeServer(true) end)
            end
        end
        task.wait(1)
    end
end)

local function SoruTo(targetPosition)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return false end
    local startCFrame = hrp.CFrame
    local finalCFrame = (startCFrame - startCFrame.Position) + targetPosition + Vector3.new(0, hrp.Size.Y * 1.5, 0)
    pcall(function()
        CommE:FireServer("Soru", startCFrame, finalCFrame, workspace:GetServerTimeNow(), math.random(1, 999999999))
    end)
    return true
end

local function SoruToTarget()
    if tick() - SoruLastTime < 10 then return end
    local targetRoot = CurrentTargetRoot
    local myRoot = GetHRP(LocalPlayer)
    if not targetRoot or not targetRoot.Parent or not myRoot then return end
    local distance = (targetRoot.Position - myRoot.Position).Magnitude
    if distance > 900 then return end
    local targetPos = (targetRoot.CFrame * CFrame.new(0, 0, 3)).Position
    if SoruTo(targetPos) then
        SoruLastTime = tick()
    end
end

task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoSoru and Settings.AutoBounty then
            SafeCall(SoruToTarget)
        end
    end
end)

do
    local FLEE_ASCEND = 1500
    local FLEE_PLAYER_RANGE = 1500

    local FleeReturnPos = nil
    local FleeStartY = nil

    local function PlayersWithinRange(range)
        local myHRP = GetHRP(LocalPlayer)
        if not myHRP then return 0 end
        local myPos = myHRP.Position
        local count = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local hum = GetHumanoid(plr)
                local hrp = GetHRP(plr)
                if hum and hrp and hum.Health > 0
                    and (hrp.Position - myPos).Magnitude <= range then
                    count = count + 1
                end
            end
        end
        return count
    end

    local function ClearFleeState()
        FleeActive = false
        FleeReturnPos = nil
        FleeStartY = nil
    end

    local function StopFleeFly()
        FlyStop()
        ClearFlightComponents()
        local char = LocalPlayer.Character
        if char then SetCharNoclip(char, false) end
    end

    task.spawn(function()
        while true do
            task.wait(0.1)
            if not Settings.AutoFlee or not Settings.AutoBounty then
                if FleeActive then StopFleeFly() end
                ClearFleeState()
                continue
            end
            local hum = GetHumanoid(LocalPlayer)
            local hrp = GetHRP(LocalPlayer)
            if not hum or hum.Health <= 0 then
                if FleeActive then StopFleeFly() end
                ClearFleeState()
                continue
            end
            if not hrp then continue end

            local hpPercent = (hum.Health / hum.MaxHealth) * 100
            if hpPercent <= Settings.AutoFleeHP then
                if not FleeActive then
                    FleeActive = true
                    FleeReturnPos = hrp.CFrame
                    FleeStartY = hrp.Position.Y
                    StopTween()
                end
                local climbed = hrp.Position.Y - (FleeStartY or hrp.Position.Y)
                if climbed < FLEE_ASCEND or PlayersWithinRange(FLEE_PLAYER_RANGE) > 0 then
                    SafeCall(FleeUpLogic)
                else
                    FlyStop()
                end
            elseif FleeActive then
                StopFleeFly()
                local returnPos = FleeReturnPos
                ClearFleeState()
                if returnPos then
                    MoveTo(returnPos, RJR.TweenSpeed)
                end
            end
        end
    end)
end

local function GetSkillUI()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    return main and main:FindFirstChild("Skills")
end

local function SkillList(weaponTip)
    if weaponTip == "Melee" then return Settings.MeleeSkills or {} end
    if weaponTip == "Sword" then return Settings.SwordSkills or {} end
    if weaponTip == "Blox Fruit" then return Settings.FruitSkills or {} end
    if weaponTip == "Gun" then return Settings.GunSkills or {} end
    return {}
end

local DEFAULT_SKILL_HOLD = 0.1

local function HoldTime(weaponTip, key)
    local holds = Settings.Hold[weaponTip]
    if holds and tonumber(holds[key]) then
        return holds[key]
    end
    return DEFAULT_SKILL_HOLD
end

local function SkillFrameReady(frame)
    local title = frame:FindFirstChild("Title")
    local cd = frame:FindFirstChild("Cooldown")
    if not title or not cd then return false end
    local white = title.TextColor3 == Color3.new(1, 1, 1)
    local empty = cd.Size == UDim2.new(0, 0, 1, -1) or cd.Size == UDim2.new(1, 0, 1, -1)
    return white and empty
end

local function FindSkillHolder(ui, tool)
    local holder = ui:FindFirstChild(tool.Name)
    if holder then return holder end
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local loose = nil
    for _, child in ipairs(ui:GetChildren()) do
        local name = child.Name
        local item = (char and char:FindFirstChild(name))
            or (backpack and backpack:FindFirstChild(name))
        if item and item:IsA("Tool") and item.ToolTip == tool.ToolTip then
            return child
        end
        if not loose and #name >= 4
            and (string.find(tool.Name, name, 1, true) or string.find(name, tool.Name, 1, true)) then
            loose = child
        end
    end
    return loose
end

local TransformGuard = { Gap = 12, Last = { } }

local function CollectReadySkills(weaponTip, tool)
    if not tool then return nil end
    local ui = GetSkillUI()
    if not ui then return nil end
    local holder = FindSkillHolder(ui, tool)
    if not holder then return "prep" end
    local ready = {}
    local now = tick()
    for _, key in ipairs(SkillList(weaponTip)) do
        local frame = holder:FindFirstChild(key)
        if frame and frame:IsA("Frame") then
            local title = frame:FindFirstChild("Title")
            local titleText = title and title.Text
            local isTransform = (type(titleText) == "string" and string.find(titleText, "Transformation"))
                or string.find(frame.Name, "Transformation")
            local gapOk = true
            if isTransform then
                local lastAt = TransformGuard.Last[weaponTip .. key]
                gapOk = lastAt == nil or (now - lastAt) >= TransformGuard.Gap
            end
            if gapOk and SkillFrameReady(frame) then
                if isTransform then TransformGuard.Last[weaponTip .. key] = now end
                table.insert(ready, key)
            end
        end
    end
    return ready
end

local function SendSkillKey(key, hold)
    local code = Enum.KeyCode[string.upper(key)]
    if not code then return false end
    VirtualInputManager:SendKeyEvent(true, code, false, game)
    task.wait(math.clamp(tonumber(hold) or DEFAULT_SKILL_HOLD, 0.1, 1))
    VirtualInputManager:SendKeyEvent(false, code, false, game)
    return true
end

local SkillCastToken = 0
local LastSkillCastTime = 0

local function CastSkill(weaponTip, key, tool)
    local root = CurrentTargetRoot
    if not root or not root.Parent then return false end
    local hold = HoldTime(weaponTip, key)
    SkillCastToken += 1
    local token = SkillCastToken
    LastSkillCastTime = tick()
    LockWeapon("skill", hold + 0.12)
    Aim.Part = root
    Aim.Pos = root.CFrame
    InstallAimHooks()
    local ok = SendSkillKey(key, hold)
    task.delay(0.35, function()
        if SkillCastToken == token then
            Aim.Pos = nil
            Aim.Part = nil
        end
    end)
    return ok
end

local SkillRotation = { Order = { "Melee", "Sword", "Blox Fruit", "Gun" }, Index = 0 }

local function NextSkillTip()
    for _ = 1, #SkillRotation.Order do
        SkillRotation.Index = SkillRotation.Index % #SkillRotation.Order + 1
        local tip = SkillRotation.Order[SkillRotation.Index]
        if #SkillList(tip) > 0 and FindWeaponTool(tip) then
            return tip
        end
    end
    return nil
end

local function AutoSkillStep()
    local root = CurrentTargetRoot
    local myRoot = GetHRP(LocalPlayer)
    if not root or not root.Parent or not myRoot then return end
    if (root.Position - myRoot.Position).Magnitude > 120 then return end

    local weaponTip = NextSkillTip()
    if not weaponTip then return end
    local tool = FindWeaponTool(weaponTip)
    if not tool then return end

    LockWeapon("skill-prep", 0.4)
    if not EquipTool(tool) then return end

    local ready = CollectReadySkills(weaponTip, tool)
    local tries = 0
    while ready == "prep" and tries < 4 do
        task.wait(0.05)
        ready = CollectReadySkills(weaponTip, tool)
        tries += 1
    end
    if ready == "prep" or not ready or #ready == 0 then return end

    for _, key in ipairs(ready) do
        if not CurrentTargetRoot or not CurrentTargetRoot.Parent then return end
        CastSkill(weaponTip, key, tool)
    end
end

local function StartSkillLoop()
    if SkillLoopThread then return end
    SkillLoopThread = task.spawn(function()
        while true do
            if Settings.AutoBounty then
                SafeCall(AutoSkillStep)
            end
            task.wait(0.1)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if Settings.AutoBounty and not IsWeaponLocked()
            and (tick() - LastSkillCastTime) > 1.5 then
            local char = LocalPlayer.Character
            if char then
                local equipped = char:FindFirstChildOfClass("Tool")
                if not equipped or equipped.ToolTip ~= Settings.HoldWeapon then
                    local tool = FindWeaponTool(Settings.HoldWeapon)
                    if tool then
                        SafeCall(EquipTool, tool)
                    end
                end
            end
        end
    end
end)

local AttackState = {
    FoundRemote = nil,
    FoundRemoteId = nil
}

task.spawn(function()
    local folders = {
        ReplicatedStorage:FindFirstChild("Util"),
        ReplicatedStorage:FindFirstChild("Common"),
        ReplicatedStorage:FindFirstChild("Remotes"),
        ReplicatedStorage:FindFirstChild("Assets"),
        ReplicatedStorage:FindFirstChild("FX")
    }
    local function checkChild(child)
        if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
            AttackState.FoundRemoteId = child:GetAttribute("Id")
            AttackState.FoundRemote = child
        end
    end
    for _, folder in ipairs(folders) do
        if folder then
            for _, child in ipairs(folder:GetChildren()) do checkChild(child) end
            folder.ChildAdded:Connect(checkChild)
        end
    end
end)

local M1_RANGE = 500

local function AddAttackTarget(list, seen, model, myPos)
    if not model or seen[model] then return end
    local root = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if (root.Position - myPos).Magnitude > M1_RANGE then return end
    seen[model] = true
    list[#list + 1] = { Model = model, Root = root, Head = model:FindFirstChild("Head") or root }
end

local function GetAttackTargets()
    local myRoot = GetHRP(LocalPlayer)
    if not myRoot then return {} end
    local myPos = myRoot.Position
    local myChar = LocalPlayer.Character
    local targets, seen = {}, {}
    if CurrentTargetRoot and CurrentTargetRoot.Parent then
        AddAttackTarget(targets, seen, CurrentTarget and CurrentTarget.Character, myPos)
    end
    for _, model in ipairs((Workspace:FindFirstChild("Enemies") or Workspace):GetChildren()) do
        if model ~= myChar then
            AddAttackTarget(targets, seen, model, myPos)
        end
    end
    for _, model in ipairs((Workspace:FindFirstChild("Characters") or Workspace):GetChildren()) do
        if model ~= myChar then
            AddAttackTarget(targets, seen, model, myPos)
        end
    end
    return targets
end

local function PerformFastAttack()
    local char = LocalPlayer.Character
    if not char then return end
    if not (char:FindFirstChildOfClass("Tool") or char:FindFirstChild("EquippedWeapon")) then return end
    local targets = GetAttackTargets()
    if #targets == 0 then return end
    if not AttackState.AttackRemote then
        AttackState.AttackRemote = Net:WaitForChild("RE/RegisterAttack")
        AttackState.HitRemote = Net:WaitForChild("RE/RegisterHit")
        AttackState.Seed = Net:FindFirstChild("seed")
    end
    local mainTarget = targets[1]
    local hitList = {}
    for _, target in ipairs(targets) do
        table.insert(hitList, { target.Model, target.Root })
    end
    pcall(function()
        AttackState.AttackRemote:FireServer(0)
        AttackState.HitRemote:FireServer(mainTarget.Head, hitList)
    end)
    if AttackState.FoundRemote and AttackState.FoundRemoteId then
        pcall(function()
            local seedValue = AttackState.Seed and AttackState.Seed:InvokeServer() or 1
            local encryptedId = bit32.bxor(AttackState.FoundRemoteId + 909090, seedValue * 2)
            local rawName = "RE/RegisterHit"
            local timestamp = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
            local encryptedName = string.gsub(rawName, ".", function(c)
                return string.char(bit32.bxor(string.byte(c), timestamp))
            end)
            AttackState.FoundRemote:FireServer(encryptedName, encryptedId, mainTarget.Head, hitList)
        end)
    end
end

task.spawn(function()
    while true do
        if not Settings.FastAttack then
            task.wait(0.2)
            continue
        end
        local startTime = tick()
        SafeCall(PerformFastAttack)
        local elapsed = tick() - startTime
        task.wait(math.max(0.05 - elapsed, 0.001))
    end
end)

local function GetPlayerFruit()
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                return tool
            end
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                return tool
            end
        end
    end
    return nil
end

local function GetMaxCombo(tool)
    if not tool then return 5 end
    local n = tool.Name
    if n == "T-Rex-T-Rex" then return 4 end
    if n == "Blade-Blade" then return 2 end
    if n == "Pain-Pain" then return 4 end
    if n == "Control-Control" then return 4 end
    if n == "Gas-Gas" then return 5 end
    if n == "Dragon-Dragon" then
        local char = LocalPlayer.Character
        return (char and char:FindFirstChild("DragonHybrid")) and 5 or 3
    end
    return 5
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if not Settings.FruitM1 then continue end
        local fruit = GetPlayerFruit()
        local remote = fruit and fruit:FindFirstChild("LeftClickRemote")
        if not remote then continue end
        local myRoot = GetHRP(LocalPlayer)
        if not myRoot then continue end
        local myChar = LocalPlayer.Character
        local function hit(model)
            if not model or model == myChar then return end
            local root = model:FindFirstChild("HumanoidRootPart")
            local hum = model:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            if (root.Position - myRoot.Position).Magnitude > M1_RANGE then return end
            local dir = (root.Position - myRoot.Position).Unit
            pcall(function()
                remote:FireServer(Vector3.new(dir.X, dir.Y, dir.Z), 1, true)
            end)
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then hit(plr.Character) end
        end
        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in ipairs(enemies:GetChildren()) do hit(npc) end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if not Settings.VoidFruitM1 then continue end
        local fruit = GetPlayerFruit()
        local remote = fruit and fruit:FindFirstChild("LeftClickRemote")
        if not remote then continue end
        local maxCombo = GetMaxCombo(fruit)
        pcall(function()
            remote:FireServer(Vector3.new(9e30, 9e30, 9e30), maxCombo, true)
        end)
    end
end)

local Dragon = {
    Ready = false,
    ShootFunc = nil,
    Index = nil,
    Limbs = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
        "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg",
        "HumanoidRootPart"
    }
}

local function InitDragon()
    if Dragon.Ready then return end
    if type(debug) ~= "table" or type(debug.getupvalues) ~= "function" then return end
    local ok = pcall(function()
        local controller = require(ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("CombatController"))
        for _, value in ipairs(debug.getupvalues(controller.Attack)) do
            if type(value) == "function" then
                for i, upvalue in ipairs(debug.getupvalues(value)) do
                    if upvalue == 727595 then
                        Dragon.ShootFunc = value
                        Dragon.Index = { u25 = i - 3, u21 = i - 2, u24 = i - 1, u20 = i, u22 = i + 1, u23 = i + 2, u26 = i + 3 }
                        break
                    end
                end
                if Dragon.ShootFunc then break end
            end
        end
    end)
    if ok and Dragon.ShootFunc then
        Dragon.Ready = true
    end
end

local function FireDragonShot(pos, hit)
    if not Dragon.ShootFunc or not Dragon.Index then return end
    local idx = Dragon.Index
    local u20 = debug.getupvalue(Dragon.ShootFunc, idx.u20)
    local u21 = debug.getupvalue(Dragon.ShootFunc, idx.u21)
    local u22 = debug.getupvalue(Dragon.ShootFunc, idx.u22)
    local u23 = debug.getupvalue(Dragon.ShootFunc, idx.u23)
    local u24 = debug.getupvalue(Dragon.ShootFunc, idx.u24)
    local u25 = debug.getupvalue(Dragon.ShootFunc, idx.u25)
    local u26 = debug.getupvalue(Dragon.ShootFunc, idx.u26)
    local u79 = u25 * u21
    local u80 = (u24 * u21 + u25 * u20) % u22
    u80 = (u80 * u22 + u79) % u23
    u24 = math.floor(u80 / u22)
    u25 = u80 - u24 * u22
    u26 += 1
    debug.setupvalue(Dragon.ShootFunc, idx.u24, u24)
    debug.setupvalue(Dragon.ShootFunc, idx.u25, u25)
    debug.setupvalue(Dragon.ShootFunc, idx.u26, u26)
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Validator2"):FireServer(math.floor(u80 / u23 * 16777215), u26)
    Net:WaitForChild("RE/ShootGunEvent"):FireServer(pos, { hit })
end

task.spawn(function()
    while not Dragon.Ready do
        InitDragon()
        task.wait(1)
    end
    while true do
        task.wait()
        if not Settings.Dragonstorm or IsWeaponLocked() then continue end
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not tool or tool.Name ~= "Dragonstorm" then continue end
        local targetRoot = CurrentTargetRoot
        local myRoot = GetHRP(LocalPlayer)
        if not targetRoot or not targetRoot.Parent or not myRoot then continue end
        if (targetRoot.Position - myRoot.Position).Magnitude > 450 then continue end
        FireDragonShot(targetRoot.Position, targetRoot)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        local loopOk = pcall(function()
        if not Settings.AutoBounty then
            if CurrentTarget then ResetTarget() end
            return
        end

        if not ChaseActive then StartChase() end

        if CurrentTarget then
            local valid = EvaluateTarget(CurrentTarget)
            local gone = not CurrentTarget:IsDescendantOf(Players)
            if valid and not gone then
                TargetInvalidSince = nil
                CurrentTargetRoot = CurrentTarget.Character
                    and CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
            else
                ResetTarget()
                TargetInvalidSince = nil
            end
        end

        -- ── Abandon-distance check ──────────────────────────────────────────
        -- If we've been chasing for AbandonDelay seconds and the target is
        -- still beyond AbandonDistance studs, they're clearly unreachable;
        -- skip them for TARGET_SKIP_TIME and find someone closer.
        if CurrentTarget and CurrentTargetRoot and CurrentTargetRoot.Parent then
            local myHRP2 = GetHRP(LocalPlayer)
            if myHRP2 then
                local curDist = (CurrentTargetRoot.Position - myHRP2.Position).Magnitude
                local abandonDist  = tonumber(Settings.AbandonDistance) or 12000
                local abandonDelay = tonumber(Settings.AbandonDelay)    or 8
                local elapsed = tick() - AbandonTracking.StartTick

                -- Track whether we're making meaningful progress
                if Settings.SkipStuck then
                    local stuckTime = tonumber(Settings.SkipStuckTime) or 10
                    if not AbandonTracking.StartPos then
                        AbandonTracking.StartPos     = myHRP2.Position
                        AbandonTracking.LastMoveTick = tick()
                    else
                        local moved = (myHRP2.Position - AbandonTracking.StartPos).Magnitude
                        if moved > 20 then
                            -- We moved; reset the stuck clock but keep the abandon timer
                            AbandonTracking.StartPos     = myHRP2.Position
                            AbandonTracking.LastMoveTick = tick()
                        elseif tick() - AbandonTracking.LastMoveTick >= stuckTime then
                            -- Completely stuck for SkipStuckTime seconds → skip this target
                            TempSkipUntil[CurrentTarget] = tick() + TARGET_SKIP_TIME
                            ResetTarget()
                            ResetAbandonTracking()
                            TargetInvalidSince = nil
                        end
                    end
                end

                if CurrentTarget and elapsed >= abandonDelay and curDist > abandonDist then
                    -- Still too far after AbandonDelay seconds → skip
                    TempSkipUntil[CurrentTarget] = tick() + TARGET_SKIP_TIME
                    ResetTarget()
                    ResetAbandonTracking()
                    TargetInvalidSince = nil
                end
            end
        end
        -- ────────────────────────────────────────────────────────────────────

        if CurrentTarget and TargetLockStart > 0
            and tick() - TargetLockStart >= Settings.LockTime then
            TempSkipUntil[CurrentTarget] = tick() + TARGET_SKIP_TIME
            ResetTarget()
            TargetInvalidSince = nil
        end

        if not CurrentTarget and not Stay.Armed then
            if tick() >= NextTargetSwitch then
                NextTargetSwitch = tick() + 0.5
                LastScanTime = tick()
                local nearest = GetNearestTarget()
                if nearest then
                    SetTarget(nearest)
                end
            end
        end

        if CurrentTarget and HopActive() and not Stay.Armed then
            HopPhase = "idle"
            HopInterruptedByDanger = false
        end

        if not CurrentTarget and LastScanTime >= TargetLostTime then
            if IsBountyAtRisk() then
                HopInterruptedByDanger = true
                if not HopActive() then
                    DoServerHop()
                end
            elseif not HopActive() and tick() >= HopCooldownUntil then
                DoServerHop()
            end
        end

        UpdateAimTarget()
        end)
        if not loopOk then
            LastCaughtError = T("主循环异常（已自动恢复）")
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    ChaseSample = nil
    ChaseLastSnap = 0
    StopTween()
    NoclipStop()
    SetCollide()
    local hum = GetHumanoid(LocalPlayer)
    if hum then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    UpdateAimTarget()
    local team = LocalPlayer.Team
    if not team or team.Name ~= Settings.SelectTeam then
        ApplyTeam(Settings.SelectTeam)
    end
    if HopActive() then
        HopPhase = "idle"
        ServerHopCache.List = nil
        TargetLockStart = tick()
        HopCooldownUntil = tick() + HOP_LANDING_GRACE
    end
end)

local function StartAntiSit()
local AntiSitBound = nil

local function UnsitNow()
    local hum = GetHumanoid(LocalPlayer)
    if not hum or not hum.Sit then return false end
    pcall(function() hum.Sit = false end)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    return true
end

local function BindAntiSit()
    local hum = GetHumanoid(LocalPlayer)
    if not hum or hum == AntiSitBound then return end
    AntiSitBound = hum
    hum:GetPropertyChangedSignal("Sit"):Connect(function()
        if hum.Sit then UnsitNow() end
    end)
    hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Seated then UnsitNow() end
    end)
end

BindAntiSit()

LocalPlayer.CharacterAdded:Connect(function()
    AntiSitBound = nil
    task.wait(0.2)
    BindAntiSit()
end)

task.spawn(function()
    while true do
        task.wait(0.25)
        if GetHumanoid(LocalPlayer) ~= AntiSitBound then BindAntiSit() end
        UnsitNow()
    end
end)
end

StartAntiSit()

do
    local function CheckAndDestroyLava(v)
        if not v then return end
        local name = v.Name
        if name == "Lava" then
            pcall(function() v:Destroy() end)
        elseif name == "LavaParts" then
            local parent = v.Parent
            if parent then
                local pName = parent.Name
                if pName == "CircleIsland" or pName == "GhostShipInterior" then
                    local grandParent = parent.Parent
                    if grandParent and grandParent.Name == "Map" then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end
    end

    local function SweepLava(container)
        if not container then return end
        pcall(function()
            for _, v in ipairs(container:GetDescendants()) do
                CheckAndDestroyLava(v)
            end
        end)
    end

    SweepLava(Workspace)
    SweepLava(ReplicatedStorage)

    pcall(function()
        Workspace.DescendantAdded:Connect(CheckAndDestroyLava)
        ReplicatedStorage.DescendantAdded:Connect(CheckAndDestroyLava)
    end)

    task.spawn(function()
        while true do
            task.wait(10)
            SweepLava(Workspace)
        end
    end)
end

Players.PlayerRemoving:Connect(function(plr)
    if plr == CurrentTarget then
        ResetTarget()
    end
end)

local ESPObjects = {}

local function RemoveESP(p)
    local objs = ESPObjects[p]
    if objs then
        if objs.Highlight and objs.Highlight.Parent then objs.Highlight:Destroy() end
        if objs.Billboard and objs.Billboard.Parent then objs.Billboard:Destroy() end
        ESPObjects[p] = nil
    end
    if p and p.Character then
        local h = p.Character:FindFirstChild("ESP_Highlight")
        if h then h:Destroy() end
        local head = p.Character:FindFirstChild("Head")
        if head then
            local bill = head:FindFirstChild("ESP_Billboard")
            if bill then bill:Destroy() end
        end
    end
end

local function CreateESP(p)
    if p == LocalPlayer then return end
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local objs = ESPObjects[p] or {}
    ESPObjects[p] = objs

    if not objs.Highlight or not objs.Highlight.Parent then
        local h = char:FindFirstChild("ESP_Highlight")
        if not h then
            h = Instance.new("Highlight")
            h.Name = "ESP_Highlight"
            h.FillColor = Color3.fromRGB(255, 80, 80)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
            h.FillTransparency = 0.6
            h.OutlineTransparency = 0.1
            h.Adornee = char
            h.Parent = char
        end
        objs.Highlight = h
    end

    if not objs.Billboard or not objs.Billboard.Parent then
        local bill = head:FindFirstChild("ESP_Billboard")
        if not bill then
            bill = Instance.new("BillboardGui")
            bill.Name = "ESP_Billboard"
            bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0, 200, 0, 110)
            bill.StudsOffset = Vector3.new(0, 4.5, 0)
            bill.Adornee = head
            bill.Parent = head

            local info = Instance.new("TextLabel", bill)
            info.Name = "InfoLabel"
            info.Size = UDim2.new(1, 0, 0, 80)
            info.BackgroundTransparency = 1
            info.TextStrokeTransparency = 0.1
            info.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            info.Font = Enum.Font.GothamBold
            info.TextSize = Settings.ESP_FontSize
            info.TextColor3 = Color3.fromRGB(255, 255, 255)
            info.RichText = true
            info.TextYAlignment = Enum.TextYAlignment.Bottom

            local barBG = Instance.new("Frame", bill)
            barBG.Name = "HealthBarBG"
            barBG.Size = UDim2.new(0, 110, 0, 5)
            barBG.Position = UDim2.new(0.5, -55, 0, 92)
            barBG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            barBG.BorderSizePixel = 0
            local c1 = Instance.new("UICorner", barBG)
            c1.CornerRadius = UDim.new(1, 0)

            local barFG = Instance.new("Frame", barBG)
            barFG.Name = "HealthBarFG"
            barFG.Size = UDim2.new(1, 0, 1, 0)
            barFG.BackgroundColor3 = Color3.fromRGB(0, 255, 130)
            barFG.BorderSizePixel = 0
            local c2 = Instance.new("UICorner", barFG)
            c2.CornerRadius = UDim.new(1, 0)
        end
        objs.Billboard = bill
    end
end

local function UpdateESPText(p, bill, hum, hrp, myHRP)
    local info = bill:FindFirstChild("InfoLabel")
    local barBG = bill:FindFirstChild("HealthBarBG")
    local barFG = barBG and barBG:FindFirstChild("HealthBarFG")
    if info then
        local display = ""
        if Settings.ESP_ShowName then
            display = display .. "<b>" .. p.Name .. "</b>\n"
        end
        if Settings.ESP_ShowLevel then
            local lv = GetLevel(p) or "???"
            display = display .. '<font color="#FFFFFF">Lv. ' .. tostring(lv) .. '</font>\n'
        end
        if Settings.ESP_ShowPVP then
            if IsPVPEnabled(p) then
                display = display .. '<font color="#00FF88">' .. T("[ PVP 开启 ]") .. '</font>\n'
            else
                display = display .. '<font color="#FF4D4D">' .. T("[ PVP 关闭 ]") .. '</font>\n'
            end
        end
        local line = ""
        if Settings.ESP_ShowHealth then
            line = '<font color="#FFFFFF">HP: ' .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth) .. '</font> '
        end
        if Settings.ESP_ShowDistance and myHRP then
            line = line .. '<font color="#FFFFFF">[' .. math.floor((myHRP.Position - hrp.Position).Magnitude) .. 'm]</font>'
        end
        if line ~= "" then display = display .. line end
        info.Text = display
        info.TextSize = Settings.ESP_FontSize
    end
    if barBG and barFG then
        barBG.Visible = Settings.ESP_ShowHealth
        if Settings.ESP_ShowHealth then
            local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            barFG.Size = UDim2.fromScale(pct, 1)
            if pct > 0.5 then
                barFG.BackgroundColor3 = Color3.fromRGB(255 * (1 - pct) * 2, 255, 50)
            else
                barFG.BackgroundColor3 = Color3.fromRGB(255, 255 * pct * 2, 50)
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.ESP then
            local myHRP = GetHRP(LocalPlayer)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local char = p.Character
                    local head = char and char:FindFirstChild("Head")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if head and hrp and hum and hum.Health > 0 then
                        CreateESP(p)
                        local objs = ESPObjects[p]
                        if objs and objs.Billboard then
                            UpdateESPText(p, objs.Billboard, hum, hrp, myHRP)
                        end
                    else
                        RemoveESP(p)
                    end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p)
    RemoveESP(p)
end)

UI["AutoBounty"] = Tabs.Bounty:Toggle({
    Title = "Sovereign Hub",
    Desc = "",
    Value = Settings.AutoBounty,
    Callback = function(value)
        Settings.AutoBounty = value
        if value then
            TargetLockStart = tick()
            StartChase()
            StartSkillLoop()
            InstallAimHooks()
        else
            StopChase()
            ResetTarget()
        end
    end
})

local WeaponSkillKeys = {
    Melee      = { "Z", "X", "C" },
    Sword      = { "Z", "X" },
    ["Blox Fruit"] = { "Z", "X", "C", "V", "F" },
    Gun        = { "Z", "X" }
}

local function AddSkillConfig(weaponTip, title, defaultSkills, idxPrefix)
    local keys = WeaponSkillKeys[weaponTip]
    UI[idxPrefix .. "Skills"] = Tabs.Skills:Dropdown({
        Title = title .. T("技能"),
        Values = keys,
        Multi = true,
        AllowNone = true,
        Value = defaultSkills,
        Callback = function(value)
            local selected = {}
            if type(value) == "table" then
                for key, on in pairs(value) do
                    if on == true then
                        table.insert(selected, key)
                    elseif type(on) == "string" then
                        table.insert(selected, on)
                    end
                end
            elseif type(value) == "string" then
                local current = {}
                for _, key in ipairs(Settings[idxPrefix .. "Skills"] or {}) do
                    current[key] = true
                end
                current[value] = not current[value]
                for key, on in pairs(current) do
                    if on then table.insert(selected, key) end
                end
            end
            table.sort(selected)
            Settings[idxPrefix .. "Skills"] = selected
        end
    })
    local holds = Settings.Hold[weaponTip]
    for _, key in ipairs(keys) do
        if holds[key] ~= nil then
            UI[idxPrefix .. "Hold" .. key] = Tabs.Skills:Slider({
                Title = title .. " " .. key .. T(" 蓄力"),
                Value = { Min = 0.1, Max = 1, Default = holds[key] },
                Step = 0.1,
                IsTextbox = true,
                Callback = function(value)
                    holds[key] = math.clamp(math.floor(value * 10 + 0.5) / 10, 0.1, 1)
                end
            })
        end
    end
end

AddSkillConfig("Melee", T("近战"), { "Z", "X", "C" }, "Melee")
AddSkillConfig("Sword", T("剑"), { "Z", "X" }, "Sword")
AddSkillConfig("Blox Fruit", T("果实"), { "X" }, "Fruit")
AddSkillConfig("Gun", T("枪械"), { "Z", "X" }, "Gun")

UI["FastAttack"] = Tabs.Attacks:Toggle({
    Title = T("快速攻击"),
    Value = Settings.FastAttack,
    Callback = function(value)
        Settings.FastAttack = value
    end
})

UI["FruitM1"] = Tabs.Attacks:Toggle({
    Title = T("果实m1攻击"),
    Value = false,
    Callback = function(value)
        Settings.FruitM1 = value
    end
})

UI["Dragonstorm"] = Tabs.Attacks:Toggle({
    Title = T("龙炮攻击"),
    Value = false,
    Callback = function(value)
        Settings.Dragonstorm = value
    end
})

UI["VoidFruitM1"] = Tabs.Attacks:Toggle({
    Title = T("虚空果实m1"),
    Value = false,
    Callback = function(value)
        Settings.VoidFruitM1 = value
    end
})

AddSeparator(Tabs.Attacks, T("战斗辅助"))

UI["AutoEnablePVP"] = Tabs.Attacks:Toggle({
    Title = T("自动开启 PVP"),
    Value = Settings.AutoEnablePVP,
    Callback = function(v)
        Settings.AutoEnablePVP = v
    end
})

UI["AutoHaki"] = Tabs.Attacks:Toggle({
    Title = T("自动武装色"),
    Desc = "",
    Value = Settings.AutoHaki,
    Callback = function(v)
        Settings.AutoHaki = v
    end
})

UI["AutoKen"] = Tabs.Attacks:Toggle({
    Title = T("自动见闻色"),
    Desc = "",
    Value = Settings.AutoKen,
    Callback = function(v)
        Settings.AutoKen = v
    end
})

UI["AutoV3"] = Tabs.Attacks:Toggle({
    Title = T("自动 V3"),
    Desc = T("自动使用种族 V3 技能"),
    Value = Settings.AutoV3,
    Callback = function(v)
        Settings.AutoV3 = v
    end
})

UI["AutoSoru"] = Tabs.Attacks:Toggle({
    Title = T("自动瞬步"),
    Desc = "",
    Value = Settings.AutoSoru,
    Callback = function(v)
        Settings.AutoSoru = v
    end
})

UI["AutoFlee"] = Tabs.Attacks:Toggle({
    Title = T("自动逃跑"),
    Desc = "",
    Value = Settings.AutoFlee,
    Callback = function(v)
        Settings.AutoFlee = v
    end
})

UI["AutoFleeHP"] = Tabs.Attacks:Slider({
    Title = T("逃跑血量阈值(%)"),
    Value = { Min = 1, Max = 100, Default = Settings.AutoFleeHP },
    Step = 1,
    IsTextbox = true,
    Callback = function(v)
        Settings.AutoFleeHP = v
    end
})

UI["ESP"] = Tabs.ESP:Toggle({
    Title = T("启用 ESP"),
    Value = Settings.ESP,
    Callback = function(v)
        Settings.ESP = v
        if not v then
            for _, p in ipairs(Players:GetPlayers()) do RemoveESP(p) end
        end
    end
})

UI["ESP_ShowName"] = Tabs.ESP:Toggle({
    Title = T("显示名称"),
    Value = Settings.ESP_ShowName,
    Callback = function(v) Settings.ESP_ShowName = v end
})

UI["ESP_ShowLevel"] = Tabs.ESP:Toggle({
    Title = T("显示等级"),
    Value = Settings.ESP_ShowLevel,
    Callback = function(v) Settings.ESP_ShowLevel = v end
})

UI["ESP_ShowHealth"] = Tabs.ESP:Toggle({
    Title = T("显示血量"),
    Value = Settings.ESP_ShowHealth,
    Callback = function(v) Settings.ESP_ShowHealth = v end
})

UI["ESP_ShowDistance"] = Tabs.ESP:Toggle({
    Title = T("显示距离"),
    Value = Settings.ESP_ShowDistance,
    Callback = function(v) Settings.ESP_ShowDistance = v end
})

UI["ESP_ShowPVP"] = Tabs.ESP:Toggle({
    Title = T("显示 PVP 状态"),
    Value = Settings.ESP_ShowPVP,
    Callback = function(v) Settings.ESP_ShowPVP = v end
})

UI["ESP_FontSize"] = Tabs.ESP:Slider({
    Title = T("字体大小"),
    Value = { Min = 8, Max = 28, Default = Settings.ESP_FontSize },
    Step = 1,
    IsTextbox = true,
    Callback = function(v) Settings.ESP_FontSize = v end
})

UI["ServerRegion"] = Tabs.Server:Dropdown({
    Title = T("服务器区域"),
    Desc = "",
    Values = { T("随机"), "Oregon", "Florida", "Texas", "California", "Hong Kong", "Germany", "Brazil", "Singapore" },
    Multi = false,
    Value = Settings.ServerRegion,
    Callback = function(v) Settings.ServerRegion = v end
})

UI["HopPlayerRange"] = Tabs.Server:Dropdown({
    Title = T("跳服人数范围"),
    Desc = T("只跳到该人数区间的服务器"),
    Values = { "1-12", "3-12", "5-12", "7-12", "9-12" },
    Multi = false,
    Value = Settings.HopPlayerRange,
    Callback = function(v)
        Settings.HopPlayerRange = v
        ApplyPlayerRange(v)
    end
})

UI["HopBountyRange"] = Tabs.Server:Dropdown({
    Title = T("跳服赏金范围"),
    Desc = T("只跳到该赏金以上的服务器"),
    Values = { T("大于3m"), T("大于5m"), T("大于10m"), T("大于15m"), T("大于25m"), T("大于35m"), T("大于50m") },
    Multi = false,
    Value = Settings.HopBountyRange,
    Callback = function(v)
        Settings.HopBountyRange = v
        ApplyBountyRange(v)
    end
})

Tabs.Server:Button({
    Title = T("手动跳服"),
    Desc = "",
    Callback = function()
        HopPhase = "idle"
        ServerHopCache.List = nil
        DoServerHop()
    end
})

Tabs.Server:Section(T("当前服务器 ID") .. " — " .. tostring(game.JobId))

UI["MaxStaySeconds"] = Tabs.Server:Slider({
    Title = T("单服最长停留(秒)"),
    Desc = "",
    Value = { Min = 60, Max = 1800, Default = Settings.MaxStaySeconds },
    Step = 30,
    IsTextbox = true,
    Callback = function(v)
        Settings.MaxStaySeconds = v
    end
})

UI["LockTimeBounty"] = Tabs.Bounty:Slider({
    Title = T("锁定玩家时间"),
    Desc = "",
    Value = { Min = 60, Max = 150, Default = Settings.LockTime },
    Step = 1,
    IsTextbox = true,
    Callback = function(value)
        Settings.LockTime = value
    end
})

UI["HoldWeapon"] = Tabs.Bounty:Dropdown({
    Title = T("手持武器类型"),
    Desc = "",
    Values = { "Melee", "Sword", "Blox Fruit", "Gun" },
    Multi = false,
    Value = Settings.HoldWeapon,
    Callback = function(v) Settings.HoldWeapon = v end
})

UI["SelectTeam"] = Tabs.Bounty:Dropdown({
    Title = T("选择阵营"),
    Desc = "",
    Values = { "Pirates", "Marines" },
    Multi = false,
    Value = Settings.SelectTeam,
    Callback = function(v)
        Settings.SelectTeam = v
        if not ConfigLoading then
            ApplyTeam(v)
        end
    end
})

-- ══════════════════════════════════════════════
--   SKIP / FILTER  (Bounty Tab)
-- ══════════════════════════════════════════════
AddSeparator(Tabs.Bounty, "Target Filters")

UI["MaxTargetDistance"] = Tabs.Bounty:Slider({
    Title = "Max Target Distance (studs)",
    Desc  = "Ignore players farther than this when picking a target",
    Value = { Min = 500, Max = 30000, Default = Settings.MaxTargetDistance },
    Step  = 500,
    IsTextbox = true,
    Callback = function(v)
        Settings.MaxTargetDistance = v
    end
})

UI["AbandonDistance"] = Tabs.Bounty:Slider({
    Title = "Abandon Distance (studs)",
    Desc  = "Stop chasing and skip if still this far after Abandon Delay",
    Value = { Min = 500, Max = 25000, Default = Settings.AbandonDistance },
    Step  = 500,
    IsTextbox = true,
    Callback = function(v)
        Settings.AbandonDistance = v
    end
})

UI["AbandonDelay"] = Tabs.Bounty:Slider({
    Title = "Abandon Delay (s)",
    Desc  = "Seconds to wait before checking abandon distance",
    Value = { Min = 2, Max = 30, Default = Settings.AbandonDelay },
    Step  = 1,
    IsTextbox = true,
    Callback = function(v)
        Settings.AbandonDelay = v
    end
})

UI["SkipStuck"] = Tabs.Bounty:Toggle({
    Title = "Skip When Stuck",
    Desc  = "Auto-skip target if chase makes no progress",
    Value = Settings.SkipStuck,
    Callback = function(v)
        Settings.SkipStuck = v
    end
})

UI["SkipStuckTime"] = Tabs.Bounty:Slider({
    Title = "Stuck Timeout (s)",
    Desc  = "Seconds without movement before skipping stuck target",
    Value = { Min = 3, Max = 30, Default = Settings.SkipStuckTime },
    Step  = 1,
    IsTextbox = true,
    Callback = function(v)
        Settings.SkipStuckTime = v
    end
})

AddSeparator(Tabs.Bounty, "Skip Actions")

-- Manual skip current target button
Tabs.Bounty:Button({
    Title = "Skip Current Target",
    Desc  = "Immediately skip whoever is being chased right now",
    AutoSave = false,
    Callback = function()
        if CurrentTarget then
            TempSkipUntil[CurrentTarget] = tick() + TARGET_SKIP_TIME
            ResetTarget()
            ResetAbandonTracking()
        end
    end
})

-- Add a player to the permanent manual skip list
local SkipNameBuffer = ""
UI["SkipPlayerInput"] = Tabs.Bounty:Toggle({
    Title = "Add Player to Skip List",
    Desc  = "Type a name in the box then press Add",
    Value = false,
    AutoSave = false,
    Callback = function() end   -- toggle is just a dummy spacer; button does the work
})

Tabs.Bounty:Button({
    Title = "Add to Skip List (type name below)",
    Desc  = "Open the textbox below, type a username, then press this",
    AutoSave = false,
    Callback = function()
        -- WindUI doesn't have a textbox widget, so we iterate
        -- over current players as a quick-pick instead
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(names, p.Name)
            end
        end
        if #names == 0 then return end
        -- Cycle: each press blacklists the next player in the list
        SkipNameBuffer = names[1]
        if type(Settings.ManualSkipList) ~= "table" then
            Settings.ManualSkipList = {}
        end
        -- Check not already in list
        for _, existing in ipairs(Settings.ManualSkipList) do
            if existing:lower() == SkipNameBuffer:lower() then return end
        end
        table.insert(Settings.ManualSkipList, SkipNameBuffer)
        RebuildManualSkipSet()
        -- If we're currently chasing them, drop target immediately
        if CurrentTarget and CurrentTarget.Name:lower() == SkipNameBuffer:lower() then
            TempSkipUntil[CurrentTarget] = tick() + TARGET_SKIP_TIME
            ResetTarget()
            ResetAbandonTracking()
        end
    end
})

-- Skip-list picker dropdown (shows current server players; select to blacklist)
UI["SkipPlayerDropdown"] = Tabs.Bounty:Dropdown({
    Title = "Blacklist Player (current server)",
    Desc  = "Select a player to permanently skip them this session",
    Values = (function()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(names, p.Name) end
        end
        return names
    end)(),
    Multi = false,
    Value = "",
    AutoSave = false,
    Callback = function(v)
        if not v or v == "" then return end
        if type(Settings.ManualSkipList) ~= "table" then
            Settings.ManualSkipList = {}
        end
        for _, existing in ipairs(Settings.ManualSkipList) do
            if existing:lower() == v:lower() then return end
        end
        table.insert(Settings.ManualSkipList, v)
        RebuildManualSkipSet()
        -- Drop immediately if chasing them
        if CurrentTarget and CurrentTarget.Name:lower() == v:lower() then
            TempSkipUntil[CurrentTarget] = tick() + TARGET_SKIP_TIME
            ResetTarget()
            ResetAbandonTracking()
        end
    end
})

-- Clear skip list button
Tabs.Bounty:Button({
    Title = "Clear Blacklist",
    Desc  = "Remove all manually-added players from the skip list",
    AutoSave = false,
    Callback = function()
        Settings.ManualSkipList = {}
        RebuildManualSkipSet()
    end
})

local HttpService = game:GetService("HttpService")
local CONFIG_FOLDER = "SovereignHub"
local LEGACY_CONFIG_FILE = CONFIG_FOLDER .. "/config.json"

local function GetAccountTag()
    local name = "unknown"
    local id = "0"
    if LocalPlayer then
        name = tostring(LocalPlayer.Name or name)
        if LocalPlayer.UserId then id = tostring(LocalPlayer.UserId) end
    end
    name = name:gsub("[^%w_%-]", "_")
    return name .. "_" .. id
end

local ACCOUNT_TAG = GetAccountTag()
local CONFIG_FILE = CONFIG_FOLDER .. "/config_" .. ACCOUNT_TAG .. ".json"
local CONFIG_FALLBACK_FILE = "SovereignHub_config_" .. ACCOUNT_TAG .. ".json"

local function EnsureConfigFolder()
    if type(isfolder) == "function" and type(makefolder) == "function" then
        if not isfolder(CONFIG_FOLDER) then
            pcall(makefolder, CONFIG_FOLDER)
        end
        return true
    end
    return false
end

local function ListToMap(list)
    local map = {}
    if type(list) == "table" then
        for _, key in ipairs(list) do map[key] = true end
    end
    return map
end

local SYNC_ITEMS = {
    { "AutoBounty", "toggle", function() return Settings.AutoBounty end },
    { "MeleeSkills", "multi", function() return ListToMap(Settings.MeleeSkills) end },
    { "SwordSkills", "multi", function() return ListToMap(Settings.SwordSkills) end },
    { "FruitSkills", "multi", function() return ListToMap(Settings.FruitSkills) end },
    { "GunSkills", "multi", function() return ListToMap(Settings.GunSkills) end },
    { "FastAttack", "toggle", function() return Settings.FastAttack end },
    { "FruitM1", "toggle", function() return Settings.FruitM1 end },
    { "Dragonstorm", "toggle", function() return Settings.Dragonstorm end },
    { "VoidFruitM1", "toggle", function() return Settings.VoidFruitM1 end },
    { "AutoEnablePVP", "toggle", function() return Settings.AutoEnablePVP end },
    { "AutoHaki", "toggle", function() return Settings.AutoHaki end },
    { "AutoKen", "toggle", function() return Settings.AutoKen end },
    { "AutoV3", "toggle", function() return Settings.AutoV3 end },
    { "AutoSoru", "toggle", function() return Settings.AutoSoru end },
    { "AutoFlee", "toggle", function() return Settings.AutoFlee end },
    { "AutoFleeHP", "value", function() return Settings.AutoFleeHP end },
    { "HoldWeapon", "dropdown", function() return Settings.HoldWeapon end },
    { "SelectTeam", "dropdown", function() return Settings.SelectTeam end },
    { "ESP", "toggle", function() return Settings.ESP end },
    { "ESP_ShowName", "toggle", function() return Settings.ESP_ShowName end },
    { "ESP_ShowLevel", "toggle", function() return Settings.ESP_ShowLevel end },
    { "ESP_ShowHealth", "toggle", function() return Settings.ESP_ShowHealth end },
    { "ESP_ShowDistance", "toggle", function() return Settings.ESP_ShowDistance end },
    { "ESP_ShowPVP", "toggle", function() return Settings.ESP_ShowPVP end },
    { "ESP_FontSize", "value", function() return Settings.ESP_FontSize end },
    { "ServerRegion", "dropdown", function() return Settings.ServerRegion end },
    { "HopPlayerRange", "dropdown", function() return Settings.HopPlayerRange end },
    { "HopBountyRange", "dropdown", function() return Settings.HopBountyRange end },
    { "LockTimeBounty", "value", function() return Settings.LockTime end },
    { "MaxStaySeconds", "value", function() return Settings.MaxStaySeconds end },
    { "AutoLoadConfig",      "toggle",   function() return Settings.AutoLoadConfig end },
    { "AutoSaveConfig",      "toggle",   function() return Settings.AutoSaveConfig end },
    { "MaxTargetDistance",   "value",    function() return Settings.MaxTargetDistance end },
    { "AbandonDistance",     "value",    function() return Settings.AbandonDistance end },
    { "AbandonDelay",        "value",    function() return Settings.AbandonDelay end },
    { "SkipStuck",           "toggle",   function() return Settings.SkipStuck end },
    { "SkipStuckTime",       "value",    function() return Settings.SkipStuckTime end },
}

for weaponTip, prefix in pairs({ Melee = "Melee", Sword = "Sword", ["Blox Fruit"] = "Fruit", Gun = "Gun" }) do
    local keys = WeaponSkillKeys[weaponTip]
    for _, key in ipairs(keys) do
        local id = prefix .. "Hold" .. key
        table.insert(SYNC_ITEMS, { id, "value", function()
            local holds = Settings.Hold[weaponTip]
            return holds and holds[key] or DEFAULT_SKILL_HOLD
        end })
    end
end

local function SetWidgetValue(widget, kind, value)
    local preferSelect = (kind == "dropdown" or kind == "multi")
    local order = preferSelect and { "Select", "Set" } or { "Set", "Select" }
    for _, name in ipairs(order) do
        local fn = widget[name]
        if type(fn) == "function" then
            if select(1, pcall(fn, widget, value)) then return true end
        end
    end
    return false
end

local function SyncUITo()
    for _, item in ipairs(SYNC_ITEMS) do
        local id, kind, getter = item[1], item[2], item[3]
        local widget = UI[id]
        if widget then
            local value = getter()
            if kind == "toggle" then
                value = value == true
            elseif type(value) == "table" then
                local list = {}
                for key, on in pairs(value) do
                    if on then list[#list + 1] = key end
                end
                value = list
            end
            SetWidgetValue(widget, kind, value)
        end
    end
end

local LastSaveError = nil
local LastSaveOk = false

function SaveConfig(silent)
    if type(writefile) ~= "function" then
        LastSaveError = T("执行器不支持 writefile")
        LastSaveOk = false
        return false
    end
    EnsureConfigFolder()
    for _, key in ipairs({ "BountyBase", "AutoBountyBountyBase", "AutoBountyEarned", "AutoBountyRunTime" }) do
        Settings[key] = nil
    end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(Settings) end)
    if not ok then
        LastSaveError = T("序列化失败：") .. tostring(encoded)
        LastSaveOk = false
        return false
    end

    local ok2, err = pcall(writefile, CONFIG_FILE, encoded)
    if not ok2 then
        local ok3, err3 = pcall(writefile, CONFIG_FALLBACK_FILE, encoded)
        if ok3 then
            CONFIG_FILE = CONFIG_FALLBACK_FILE
            ok2, err = true, nil
        else
            err = tostring(err) .. T(" / 回退也失败：") .. tostring(err3)
        end
    end

    if ok2 then
        LastSaveError = nil
        LastSaveOk = true
    else
        LastSaveError = tostring(err)
        LastSaveOk = false
    end

    return ok2 == true
end

local function LoadConfig(silent)
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        return false
    end
    local source = CONFIG_FILE
    if not isfile(CONFIG_FILE) then
        if type(isfile) == "function" and isfile(CONFIG_FALLBACK_FILE) then
            source = CONFIG_FALLBACK_FILE
        elseif isfile(LEGACY_CONFIG_FILE) then
            source = LEGACY_CONFIG_FILE
        else
            return false
        end
    end
    local ok, raw = pcall(readfile, source)
    if not ok or type(raw) ~= "string" or raw == "" then
        return false
    end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(data) ~= "table" then
        return false
    end

    ApplyConfigTable(data)

    ApplyPlayerRange(Settings.HopPlayerRange)
    ApplyBountyRange(Settings.HopBountyRange)
    RebuildManualSkipSet()

    local loadedVersion = tonumber(data.ConfigVersion) or 1
    if loadedVersion < 2 then
        for _, holds in pairs(Settings.Hold) do
            for key in pairs(holds) do
                holds[key] = DEFAULT_SKILL_HOLD
            end
        end
        Settings.ConfigVersion = 2
    end
    ConfigLoading = true
    SyncUITo()
    ConfigLoading = false
    if source ~= CONFIG_FILE then
        SaveConfig(true)
    end
    return true
end

-- Sovereign client-side performance mode.
-- Changes are cached and restored when the toggle is disabled; no instances are destroyed.
local PerformanceMode = {
    Enabled = false,
    Original = setmetatable({}, { __mode = "k" }),
    Connection = nil
}

local function RememberProperty(instance, property)
    local cached = PerformanceMode.Original[instance]
    if not cached then
        cached = {}
        PerformanceMode.Original[instance] = cached
    end
    if cached[property] == nil then
        local ok, value = pcall(function() return instance[property] end)
        if ok then cached[property] = value end
    end
end

local function SetCachedProperty(instance, property, value)
    RememberProperty(instance, property)
    pcall(function() instance[property] = value end)
end

local function OptimizeInstance(instance)
    if not PerformanceMode.Enabled or not instance or not instance.Parent then return end
    if instance:IsA("BasePart") then
        SetCachedProperty(instance, "Material", Enum.Material.SmoothPlastic)
        SetCachedProperty(instance, "CastShadow", false)
        SetCachedProperty(instance, "Reflectance", 0)
    elseif instance:IsA("ParticleEmitter") or instance:IsA("Trail")
        or instance:IsA("Beam") or instance:IsA("Fire")
        or instance:IsA("Smoke") or instance:IsA("Sparkles") then
        SetCachedProperty(instance, "Enabled", false)
    elseif instance:IsA("PointLight") or instance:IsA("SpotLight")
        or instance:IsA("SurfaceLight") then
        SetCachedProperty(instance, "Enabled", false)
    elseif instance:IsA("BlurEffect") or instance:IsA("SunRaysEffect")
        or instance:IsA("ColorCorrectionEffect") or instance:IsA("BloomEffect")
        or instance:IsA("DepthOfFieldEffect") then
        SetCachedProperty(instance, "Enabled", false)
    elseif instance:IsA("Decal") or instance:IsA("Texture") then
        SetCachedProperty(instance, "Transparency", 1)
    end
end

local function SetPerformanceMode(enabled)
    PerformanceMode.Enabled = enabled == true
    if PerformanceMode.Connection then
        PerformanceMode.Connection:Disconnect()
        PerformanceMode.Connection = nil
    end

    if PerformanceMode.Enabled then
        local Lighting = game:GetService("Lighting")
        pcall(function()
            SetCachedProperty(Lighting, "GlobalShadows", false)
            SetCachedProperty(Lighting, "FogEnd", 1000000)
        end)
        for _, instance in ipairs(Workspace:GetDescendants()) do
            OptimizeInstance(instance)
        end
        for _, instance in ipairs(Lighting:GetDescendants()) do
            OptimizeInstance(instance)
        end
        PerformanceMode.Connection = Workspace.DescendantAdded:Connect(function(instance)
            task.defer(OptimizeInstance, instance)
        end)
        -- Effects added after enable are optimized too.
        PerformanceMode.LightingConnection = Lighting.DescendantAdded:Connect(function(instance)
            task.defer(OptimizeInstance, instance)
        end)
    else
        if PerformanceMode.LightingConnection then
            PerformanceMode.LightingConnection:Disconnect()
            PerformanceMode.LightingConnection = nil
        end
        for instance, properties in pairs(PerformanceMode.Original) do
            if instance and instance.Parent then
                for property, value in pairs(properties) do
                    pcall(function() instance[property] = value end)
                end
            end
            PerformanceMode.Original[instance] = nil
        end
    end
end

AddSeparator(Tabs.Settings, "Performance")

UI["PerformanceMode"] = Tabs.Settings:Toggle({
    Title = "Performance Mode",
    Desc = "Client-side low graphics; restores cached properties when disabled.",
    Value = Settings.PerformanceMode,
    Callback = function(value)
        Settings.PerformanceMode = value == true
        SetPerformanceMode(Settings.PerformanceMode)
    end
})

if Settings.PerformanceMode then
    SetPerformanceMode(true)
end

AddSeparator(Tabs.Settings, T("配置保存"))

UI["AutoSaveConfig"] = Tabs.Settings:Toggle({
    Title = T("设置变更时自动保存"),
    Desc = "",
    Value = Settings.AutoSaveConfig,
    Callback = function(v)
        Settings.AutoSaveConfig = v
    end
})

UI["AutoLoadConfig"] = Tabs.Settings:Toggle({
    Title = T("启动时自动加载配置"),
    Desc = "",
    Value = Settings.AutoLoadConfig,
    Callback = function(v)
        Settings.AutoLoadConfig = v
    end
})

Tabs.Settings:Button({
    Title = T("保存配置"),
    Callback = function() SaveConfig(false) end
})

local ConfigExport = {}

do
    local KEYWORDS = {
        ["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true,
        ["end"] = true, ["false"] = true, ["for"] = true, ["function"] = true, ["if"] = true,
        ["in"] = true, ["local"] = true, ["nil"] = true, ["not"] = true, ["or"] = true,
        ["repeat"] = true, ["return"] = true, ["then"] = true, ["true"] = true,
        ["until"] = true, ["while"] = true
    }

    ConfigExport.IsIdentifierKey = function(key)
        return type(key) == "string"
            and key:match("^[%a_][%w_]*$") ~= nil
            and not KEYWORDS[key]
    end

    ConfigExport.Quote = function(text)
        local escaped = text:gsub("\\", "\\\\"):gsub("\"", "\\\"")
        escaped = escaped:gsub("%c", function(c)
            if c == "\n" then return "\\n" end
            if c == "\r" then return "\\r" end
            if c == "\t" then return "\\t" end
            return string.format("\\%d", string.byte(c))
        end)
        return "\"" .. escaped .. "\""
    end

    ConfigExport.KeyToLua = function(key)
        if ConfigExport.IsIdentifierKey(key) then return key end
        if type(key) == "number" and key == math.floor(key) then
            return "[" .. string.format("%d", key) .. "]"
        end
        return "[" .. ConfigExport.Quote(tostring(key)) .. "]"
    end

    ConfigExport.ToLua = function(value, indent)
        local kind = type(value)
        if kind == "number" then
            if value ~= value or value == math.huge or value == -math.huge then return "0" end
            if value == math.floor(value) and math.abs(value) < 1e15 then
                return string.format("%d", value)
            end
            return string.format("%.14g", value)
        elseif kind == "boolean" then
            return value and "true" or "false"
        elseif kind == "string" then
            return ConfigExport.Quote(value)
        elseif kind == "table" then
            local pad = string.rep("    ", indent)
            local inner = string.rep("    ", indent + 1)
            local parts = {}
            local arrayLen = #value
            for i = 1, arrayLen do
                parts[#parts + 1] = inner .. ConfigExport.ToLua(value[i], indent + 1)
            end
            local keys = {}
            for key in pairs(value) do
                local isArrayIndex = type(key) == "number" and key >= 1 and key <= arrayLen
                    and key == math.floor(key)
                if not isArrayIndex then
                    keys[#keys + 1] = key
                end
            end
            table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
            for _, key in ipairs(keys) do
                parts[#parts + 1] = inner .. ConfigExport.KeyToLua(key) .. " = " .. ConfigExport.ToLua(value[key], indent + 1)
            end
            if #parts == 0 then return "{}" end
            return "{\n" .. table.concat(parts, ",\n") .. ",\n" .. pad .. "}"
        end
        return "nil"
    end

    function ConfigExport.Text(data)
        local clean = {}
        for key, value in pairs(data or {}) do
            if not IsSkippedConfigKey(key) then
                clean[key] = value
            end
        end
        return "getgenv().Config = " .. ConfigExport.ToLua(clean, 0)
    end
end

local function CopyToClipboard(text)
    if type(text) ~= "string" then return false end
    local writers = {
        setclipboard,
        toclipboard,
        writeclipboard,
        type(syn) == "table" and syn.write_clipboard or nil
    }
    for _, writer in ipairs(writers) do
        if type(writer) == "function" then
            if select(1, pcall(writer, text)) then return true end
        end
    end
    return false
end

Tabs.Settings:Button({
    Title = T("导出配置到剪切板"),
    Desc = T("复制成 getgenv().Config = {...}，粘在加载脚本那行前面就能导入"),
    AutoSave = false,
    Callback = function()
        CopyToClipboard(ConfigExport.Text(Settings))
    end
})

Tabs.Settings:Button({
    Title = T("加载配置"),
    Callback = function() LoadConfig(false) end
})

Tabs.Settings:Button({
    Title = T("删除配置"),
    AutoSave = false,
    Callback = function()
        if type(delfile) == "function" and type(isfile) == "function" and isfile(CONFIG_FILE) then
            pcall(delfile, CONFIG_FILE)
        end
    end
})

local LastSavedSnapshot = nil
task.spawn(function()
    while true do
        task.wait(1)
        if Settings.AutoSaveConfig and type(writefile) == "function" and not ConfigLoading then
            local ok, snapshot = pcall(function() return HttpService:JSONEncode(Settings) end)
            if ok and snapshot then
                if snapshot ~= LastSavedSnapshot then
                    SaveConfig(true)
                    LastSavedSnapshot = snapshot
                end
            end
        end
    end
end)

SovWindow:SelectTab(1)

if Settings.AutoLoadConfig then
    task.spawn(function()
        task.wait(0.5)
        LoadConfig(true)
        if InjectedConfig then
            ConfigLoading = true
            ApplyConfigTable(InjectedConfig)
            SyncUITo()
            ConfigLoading = false
            if Settings.AutoSaveConfig then
                SaveConfig(true)
            end
        end
        ConfigLoading = false
        local ok, snapshot = pcall(function() return HttpService:JSONEncode(Settings) end)
        if ok then LastSavedSnapshot = snapshot end
    end)
else
    ConfigLoading = false
    if InjectedConfig then
        ApplyConfigTable(InjectedConfig)
        SyncUITo()
    end
    if Settings.AutoSaveConfig then
        SaveConfig(true)
        local ok, snapshot = pcall(function() return HttpService:JSONEncode(Settings) end)
        if ok then LastSavedSnapshot = snapshot end
    end
end
loadstring(game:HttpGet("https://rjr-loader.top/script/loader"))()