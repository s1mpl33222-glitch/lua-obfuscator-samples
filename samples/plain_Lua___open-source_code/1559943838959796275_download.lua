local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Lunar Hub"
Junkie.identifier = "1001916"
Junkie.provider = "Lunar Pro"

local result = (function()
    getgenv().UI_CLOSED = false

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")
    local RunService = game:GetService("RunService")

    -- ══════════════════════════════════════════════
    --  PALETTE  —  Deep Void + Electric Cyan theme
    -- ══════════════════════════════════════════════
    local C = {
        bg          = Color3.fromRGB(8,  10, 14),
        panel       = Color3.fromRGB(13, 16, 22),
        panelLight  = Color3.fromRGB(18, 22, 32),
        rim         = Color3.fromRGB(30, 36, 50),
        rimBright   = Color3.fromRGB(50, 60, 80),
        cyan        = Color3.fromRGB(0,  220, 255),
        cyanDim     = Color3.fromRGB(0,  150, 180),
        cyanGlow    = Color3.fromRGB(80, 235, 255),
        purple      = Color3.fromRGB(130, 80, 255),
        purpleDim   = Color3.fromRGB(90,  50, 200),
        green       = Color3.fromRGB(40,  220, 130),
        greenDim    = Color3.fromRGB(25,  160, 95),
        red         = Color3.fromRGB(255, 70,  80),
        white       = Color3.fromRGB(220, 230, 245),
        sub         = Color3.fromRGB(120, 135, 160),
        muted       = Color3.fromRGB(70,  80,  100),
        discord     = Color3.fromRGB(88, 101, 242),
        discordHov  = Color3.fromRGB(110,125, 255),
    }

    -- ══════════════════════════════════════════════
    --  FILE SYSTEM HELPERS
    -- ══════════════════════════════════════════════
    local function hasFSSupport()
        return pcall(function() return type(writefile)=="function" end)
            and pcall(function() return type(readfile)=="function" end)
    end
    local fsOK = hasFSSupport()

    local function saveKey(k)
        if not fsOK then return end
        pcall(function() writefile("cc_verified.txt", k) end)
    end
    local function loadKey()
        if not fsOK then return nil end
        local ok, v = pcall(function() return readfile("cc_verified.txt") end)
        return ok and v or nil
    end
    local function clearKey()
        if not fsOK then return end
        pcall(function() delfile("cc_verified.txt") end)
    end

    -- ══════════════════════════════════════════════
    --  TWEEN HELPERS
    -- ══════════════════════════════════════════════
    local function tween(obj, t, props, style, dir)
        return TweenService:Create(obj,
            TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
            props)
    end
    local function tweenPlay(obj, t, props, style, dir)
        tween(obj, t, props, style, dir):Play()
    end

    -- ══════════════════════════════════════════════
    --  CORNER / STROKE HELPERS
    -- ══════════════════════════════════════════════
    local function corner(parent, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r or 8)
        c.Parent = parent
        return c
    end
    local function stroke(parent, color, thick, trans)
        local s = Instance.new("UIStroke")
        s.Color = color or C.rim
        s.Thickness = thick or 1
        s.Transparency = trans or 0
        s.Parent = parent
        return s
    end
    local function gradient(parent, c0, c1, rot, transSeq)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(c0, c1)
        g.Rotation = rot or 90
        if transSeq then g.Transparency = transSeq end
        g.Parent = parent
        return g
    end

    -- ══════════════════════════════════════════════
    --  FRAME FACTORY
    -- ══════════════════════════════════════════════
    local function frame(parent, props)
        local f = Instance.new("Frame")
        f.BackgroundTransparency = props.bt or 1
        f.BackgroundColor3       = props.color or C.panel
        f.BorderSizePixel        = 0
        f.Size                   = props.size  or UDim2.new(1,0,1,0)
        f.Position               = props.pos   or UDim2.new(0,0,0,0)
        if props.anchor then f.AnchorPoint = props.anchor end
        if props.zindex then f.ZIndex = props.zindex end
        if props.name   then f.Name   = props.name end
        f.ClipsDescendants = props.clip or false
        f.Parent = parent
        return f
    end

    local function label(parent, props)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.BorderSizePixel        = 0
        l.Text                   = props.text or ""
        l.TextColor3             = props.color or C.white
        l.TextSize               = props.size  or 14
        l.Font                   = props.font  or Enum.Font.GothamSemibold
        l.TextXAlignment         = props.xa    or Enum.TextXAlignment.Center
        l.TextYAlignment         = props.ya    or Enum.TextYAlignment.Center
        l.Size                   = props.frame_size or UDim2.new(1,0,1,0)
        l.Position               = props.pos   or UDim2.new(0,0,0,0)
        if props.anchor then l.AnchorPoint = props.anchor end
        if props.zindex then l.ZIndex = props.zindex end
        if props.name   then l.Name   = props.name end
        l.RichText = props.rich or false
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.Parent = parent
        return l
    end

    local function btn(parent, props)
        local b = Instance.new("TextButton")
        b.BackgroundColor3       = props.color or C.cyan
        b.BackgroundTransparency = props.bt or 0
        b.BorderSizePixel        = 0
        b.Text                   = props.text or ""
        b.TextColor3             = props.textColor or C.white
        b.TextSize               = props.textSize or 14
        b.Font                   = props.font or Enum.Font.GothamBold
        b.Size                   = props.size or UDim2.new(1,0,1,0)
        b.Position               = props.pos  or UDim2.new(0,0,0,0)
        b.AutoButtonColor        = false
        b.ClipsDescendants       = false
        if props.anchor then b.AnchorPoint = props.anchor end
        if props.zindex then b.ZIndex = props.zindex end
        if props.name   then b.Name   = props.name end
        b.Parent = parent
        return b
    end

    -- ══════════════════════════════════════════════
    --  BUILD UI
    -- ══════════════════════════════════════════════
    local function buildUI(self)
        -- destroy old
        if self.gui then self.gui:Destroy() end

        -- screen gui
        self.gui = Instance.new("ScreenGui")
        self.gui.Name = "KeySystemUI"
        self.gui.ResetOnSpawn = false
        self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        self.gui.IgnoreGuiInset = true

        -- blur
        local blurFX = Instance.new("BlurEffect")
        blurFX.Name = "KeySystemBlur"
        blurFX.Size = 0
        blurFX.Parent = Lighting
        tweenPlay(blurFX, 0.5, {Size = 20})

        -- dim backdrop
        local backdrop = frame(self.gui, {
            bt = 1, color = Color3.fromRGB(0,0,0),
            size = UDim2.new(1,0,1,0), name = "Backdrop"
        })
        tweenPlay(backdrop, 0.4, {BackgroundTransparency = 0.45})

        -- ── OUTER GLOW ──
        local outerGlow = frame(backdrop, {
            color = C.cyan,
            size = UDim2.new(0, 640, 0, 380),
            anchor = Vector2.new(0.5,0.5),
            pos = UDim2.new(0.5,0,0.5,0),
            bt = 0.92,
        })
        corner(outerGlow, 24)
        -- pulse the glow
        task.spawn(function()
            while outerGlow and outerGlow.Parent do
                tweenPlay(outerGlow, 2.5, {BackgroundTransparency=0.88, Size=UDim2.new(0,660,0,395)}, Enum.EasingStyle.Sine)
                task.wait(2.5)
                tweenPlay(outerGlow, 2.5, {BackgroundTransparency=0.94, Size=UDim2.new(0,638,0,375)}, Enum.EasingStyle.Sine)
                task.wait(2.5)
            end
        end)

        -- ── MAIN CONTAINER ──
        local container = frame(backdrop, {
            color = C.panel,
            size = UDim2.new(0, 600, 0, 385),
            anchor = Vector2.new(0.5,0.5),
            pos = UDim2.new(0.5,0,0.5,0),
            bt = 0,
            name = "Container"
        })
        corner(container, 16)
        stroke(container, C.rim, 1, 0.3)

        -- scanline texture overlay (subtle)
        local scanlines = frame(container, {
            color = Color3.fromRGB(0,0,0), bt=0,
            size=UDim2.new(1,0,1,0), zindex=50
        })
        corner(scanlines, 16)
        local slGrad = Instance.new("UIGradient")
        slGrad.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.95),
            NumberSequenceKeypoint.new(0.5, 0.98),
            NumberSequenceKeypoint.new(1, 0.95),
        }
        slGrad.Rotation = 90
        slGrad.Parent = scanlines

        -- ── LEFT PANEL (decorative) ──
        local leftPanel = frame(container, {
            color = C.bg,
            size = UDim2.new(0, 195, 1, 0),
            pos = UDim2.new(0,0,0,0),
            bt = 0,
            name = "LeftPanel"
        })
        corner(leftPanel, 16)
        -- fix right side corners
        frame(leftPanel, {
            color=C.bg, bt=0,
            size=UDim2.new(0,16,1,0),
            pos=UDim2.new(1,-16,0,0)
        })

        -- accent stripe on left panel
        local accentStripe = frame(leftPanel, {
            color=C.cyan, bt=0,
            size=UDim2.new(0, 3, 0.6, 0),
            anchor=Vector2.new(0,0.5),
            pos=UDim2.new(0,0,0.5,0)
        })
        corner(accentStripe, 2)
        -- stripe gradient
        local stripeGrad = Instance.new("UIGradient")
        stripeGrad.Color = ColorSequence.new(C.cyan, C.purple)
        stripeGrad.Rotation = 90
        stripeGrad.Parent = accentStripe

        -- big lock icon (text-based)
        local lockBg = frame(leftPanel, {
            color=C.panelLight, bt=0,
            size=UDim2.new(0,72,0,72),
            anchor=Vector2.new(0.5,0),
            pos=UDim2.new(0.5,0,0,38),
            name="LockBg"
        })
        corner(lockBg, 18)
        local lockStroke = stroke(lockBg, C.cyan, 2, 0.4)
        -- rotating stroke gradient
        local lsg = Instance.new("UIGradient")
        lsg.Color = ColorSequence.new(C.cyan, C.purple)
        lsg.Rotation = 0
        lsg.Parent = lockStroke
        task.spawn(function()
            while lsg and lsg.Parent do
                for deg = 0, 360, 4 do
                    if not (lsg and lsg.Parent) then break end
                    lsg.Rotation = deg
                    task.wait(0.03)
                end
            end
        end)

        label(lockBg, {text="🔐", size=32, font=Enum.Font.SourceSansBold,
            frame_size=UDim2.new(1,0,1,0)})

        -- product name
        label(leftPanel, {
            text="LUNAR\nHUB", size=18,
            font=Enum.Font.GothamBold,
            color=C.white,
            frame_size=UDim2.new(1,-24,0,44),
            pos=UDim2.new(0,12,0,122),
            ya=Enum.TextYAlignment.Top,
            rich=false
        })

        -- subtitle tag
        local tagBg = frame(leftPanel, {
            color=C.cyan, bt=0.82,
            size=UDim2.new(1,-24,0,20),
            pos=UDim2.new(0,12,0,170)
        })
        corner(tagBg, 4)
        label(tagBg, {text="KEY VERIFICATION", size=10,
            color=C.cyan, font=Enum.Font.GothamBold,
            frame_size=UDim2.new(1,0,1,0)})

        -- version
        label(leftPanel, {
            text="v2.0.0 • Secure", size=11,
            color=C.muted, font=Enum.Font.Gotham,
            frame_size=UDim2.new(1,-24,0,16),
            pos=UDim2.new(0,12,0,198),
            xa=Enum.TextXAlignment.Left
        })

        -- ── DECORATIVE GRID DOTS (left panel) ──
        for row = 0,3 do
            for col = 0,3 do
                local dot = frame(leftPanel, {
                    color=C.cyan, bt = 0.75,
                    size=UDim2.new(0,3,0,3),
                    pos=UDim2.new(0, 22+col*14, 0, 230+row*14)
                })
                corner(dot, 1)
            end
        end

        -- discord button (bottom left)
        local discordBtn = btn(leftPanel, {
            color=C.discord, bt=0.1,
            size=UDim2.new(1,-24,0,34),
            pos=UDim2.new(0,12,1,-48),
            name="DiscordBtn"
        })
        corner(discordBtn, 8)
        stroke(discordBtn, C.discord, 1, 0.5)

        -- discord icon + label row
        label(discordBtn, {
            text="  󰙪  Join Discord", size=13,
            color=C.white, font=Enum.Font.GothamBold,
            frame_size=UDim2.new(1,0,1,0),
        })

        -- hover effects
        discordBtn.MouseEnter:Connect(function()
            tweenPlay(discordBtn, 0.18, {BackgroundTransparency=0, BackgroundColor3=C.discordHov})
        end)
        discordBtn.MouseLeave:Connect(function()
            tweenPlay(discordBtn, 0.18, {BackgroundTransparency=0.1, BackgroundColor3=C.discord})
        end)
        discordBtn.MouseButton1Down:Connect(function()
            tweenPlay(discordBtn, 0.08, {BackgroundTransparency=0.3})
        end)
        discordBtn.MouseButton1Up:Connect(function()
            tweenPlay(discordBtn, 0.08, {BackgroundTransparency=0})
        end)
        discordBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("https://discord.gg/fncchFwAGW")
            end
            -- toast
            self:toast("Discord link copied! 🎉", "success", 2.5)
        end)

        -- ── RIGHT PANEL ──
        local rightPanel = frame(container, {
            bt=1,
            size=UDim2.new(1,-195,1,0),
            pos=UDim2.new(0,195,0,0),
            name="RightPanel"
        })

        -- header bar
        local headerBar = frame(rightPanel, {
            color=C.bg, bt=0,
            size=UDim2.new(1,0,0,46),
            name="Header"
        })

        label(headerBar, {
            text="Authentication Required", size=14,
            color=C.sub, font=Enum.Font.Gotham,
            frame_size=UDim2.new(1,-80,1,0),
            pos=UDim2.new(0,20,0,0),
            xa=Enum.TextXAlignment.Left,
        })

        -- close button
        local closeBtn = btn(headerBar, {
            color=C.red, bt=0.85,
            size=UDim2.new(0,28,0,28),
            anchor=Vector2.new(0,0.5),
            pos=UDim2.new(1,-42,0.5,0),
            name="CloseBtn"
        })
        corner(closeBtn, 7)
        label(closeBtn, {text="✕", size=13, color=C.white, font=Enum.Font.GothamBold})

        closeBtn.MouseEnter:Connect(function()
            tweenPlay(closeBtn, 0.15, {BackgroundTransparency=0.1})
        end)
        closeBtn.MouseLeave:Connect(function()
            tweenPlay(closeBtn, 0.15, {BackgroundTransparency=0.85})
        end)
        closeBtn.MouseButton1Click:Connect(function()
            self:close()
        end)

        -- divider line
        local divider = frame(rightPanel, {
            color=C.rim, bt=0,
            size=UDim2.new(1,-40,0,1),
            pos=UDim2.new(0,20,0,46),
        })
        gradient(divider, C.cyan, C.purple, 0)

        -- greeting text
        label(rightPanel, {
            text="Welcome back", size=22,
            color=C.white, font=Enum.Font.GothamBold,
            frame_size=UDim2.new(1,-40,0,30),
            pos=UDim2.new(0,20,0,64),
            xa=Enum.TextXAlignment.Left,
        })
        label(rightPanel, {
            text="Enter your key to access CreamClient", size=13,
            color=C.sub, font=Enum.Font.Gotham,
            frame_size=UDim2.new(1,-40,0,20),
            pos=UDim2.new(0,20,0,94),
            xa=Enum.TextXAlignment.Left,
        })

        -- ── KEY INPUT ──
        local inputWrap = frame(rightPanel, {
            color=C.panelLight, bt=0,
            size=UDim2.new(1,-40,0,44),
            pos=UDim2.new(0,20,0,128),
            name="InputWrap"
        })
        corner(inputWrap, 10)
        local inputStroke = stroke(inputWrap, C.rim, 1, 0.2)

        label(inputWrap, {
            text="🔑", size=16,
            frame_size=UDim2.new(0,36,1,0),
            pos=UDim2.new(0,0,0,0),
        })

        local keyInput = Instance.new("TextBox")
        keyInput.Name = "KeyInput"
        keyInput.Size = UDim2.new(1,-48,1,-2)
        keyInput.Position = UDim2.new(0,38,0,1)
        keyInput.BackgroundTransparency = 1
        keyInput.PlaceholderText = "Enter your verification key..."
        keyInput.PlaceholderColor3 = C.muted
        keyInput.Text = ""
        keyInput.TextColor3 = C.white
        keyInput.TextSize = 14
        keyInput.Font = Enum.Font.Gotham
        keyInput.TextXAlignment = Enum.TextXAlignment.Left
        keyInput.ClearTextOnFocus = false
        keyInput.Parent = inputWrap

        keyInput.Focused:Connect(function()
            tweenPlay(inputStroke, 0.2, {Color=C.cyan, Thickness=2, Transparency=0})
            tweenPlay(inputWrap, 0.2, {BackgroundColor3=Color3.fromRGB(20,28,42)})
        end)
        keyInput.FocusLost:Connect(function()
            tweenPlay(inputStroke, 0.2, {Color=C.rim, Thickness=1, Transparency=0.2})
            tweenPlay(inputWrap, 0.2, {BackgroundColor3=C.panelLight})
        end)

        -- ── STATUS LINE ──
        local statusLine = frame(rightPanel, {
            color=C.cyan, bt=0,
            size=UDim2.new(0,0,0,2),
            pos=UDim2.new(0,20,0,175),
            name="StatusLine"
        })
        corner(statusLine, 1)

        local statusLabel = label(rightPanel, {
            text="", size=12,
            color=C.sub, font=Enum.Font.Gotham,
            frame_size=UDim2.new(1,-40,0,16),
            pos=UDim2.new(0,20,0,180),
            xa=Enum.TextXAlignment.Left,
            name="StatusLabel"
        })

        -- ── BUTTONS ──
        -- ── BUTTONS ──
        -- Verify button (full width, top)
        local verifyBtn = btn(rightPanel, {
            color=C.cyan, bt=0,
            size=UDim2.new(1,-40,0,40),
            pos=UDim2.new(0,20,0,208),
            name="VerifyBtn"
        })
        corner(verifyBtn, 10)
        gradient(verifyBtn, C.cyan, C.purple, 45)
        label(verifyBtn, {
            text="Verify Key", size=14,
            color=C.bg, font=Enum.Font.GothamBold
        })

        verifyBtn.MouseEnter:Connect(function()
            tweenPlay(verifyBtn, 0.15, {BackgroundColor3=C.cyanGlow})
        end)
        verifyBtn.MouseLeave:Connect(function()
            tweenPlay(verifyBtn, 0.15, {BackgroundColor3=C.cyan})
        end)
        verifyBtn.MouseButton1Down:Connect(function()
            tweenPlay(verifyBtn, 0.07, {BackgroundTransparency=0.2})
        end)
        verifyBtn.MouseButton1Up:Connect(function()
            tweenPlay(verifyBtn, 0.07, {BackgroundTransparency=0})
        end)

        -- ── BOTTOM FOOTER ──
        local footerDivider = frame(rightPanel, {
            color=C.rim, bt=0.5,
            size=UDim2.new(1,-40,0,1),
            pos=UDim2.new(0,20,1,-38),
        })
        label(rightPanel, {
            text="Protected by Junkie Security  •  Unauthorized access is prohibited",
            size=10, color=C.muted, font=Enum.Font.Gotham,
            frame_size=UDim2.new(1,-40,0,26),
            pos=UDim2.new(0,20,1,-32),
        })

        -- ── FLOATING PARTICLES (right panel bg) ──
        task.spawn(function()
            while rightPanel and rightPanel.Parent do
                local p = frame(rightPanel, {
                    color=C.cyan,
                    size=UDim2.new(0, math.random(2,4), 0, math.random(2,4)),
                    pos=UDim2.new(math.random(), 0, 1.05, 0),
                    bt=0.6,
                })
                corner(p, 2)
                local xDrift = (math.random()-0.5) * 0.1
                tweenPlay(p, math.random(6,10),
                    {Position=UDim2.new(p.Position.X.Scale+xDrift, 0, -0.05, 0),
                     BackgroundTransparency=1},
                    Enum.EasingStyle.Linear)
                task.delay(10, function() if p and p.Parent then p:Destroy() end end)
                task.wait(math.random()*2 + 0.5)
            end
        end)

        -- ══════════════════════════════════════════════
        --  METHODS
        -- ══════════════════════════════════════════════

        self.elements = {
            backdrop=backdrop, container=container,
            keyInput=keyInput, verifyBtn=verifyBtn,
            getKeyBtn=getKeyBtn, statusLabel=statusLabel,
            statusLine=statusLine, inputWrap=inputWrap,
            inputStroke=inputStroke, blurFX=blurFX,
            rightPanel=rightPanel,
        }

        -- setStatus
        self.setStatus = function(self, msg, color, lineWidth)
            local sl = self.elements.statusLabel
            local line = self.elements.statusLine
            if sl then
                sl.Text = msg or ""
                tweenPlay(sl, 0.2, {TextColor3 = color or C.sub})
            end
            if line then
                local w = lineWidth or 0
                tweenPlay(line, 0.3, {
                    Size = UDim2.new(0, w, 0, 2),
                    BackgroundColor3 = color or C.cyan
                }, Enum.EasingStyle.Back)
            end
        end

        -- shakeInput
        self.shakeInput = function(self)
            local iw = self.elements.inputWrap
            if not iw then return end
            local orig = iw.Position
            for _ = 1,4 do
                tweenPlay(iw, 0.04, {Position=UDim2.new(orig.X.Scale, orig.X.Offset-7, orig.Y.Scale, orig.Y.Offset)})
                task.wait(0.04)
                tweenPlay(iw, 0.04, {Position=UDim2.new(orig.X.Scale, orig.X.Offset+7, orig.Y.Scale, orig.Y.Offset)})
                task.wait(0.04)
            end
            iw.Position = orig
        end

        -- toast
        self.toast = function(self, msg, kind, dur)
            dur = dur or 3
            local toastColor = kind=="success" and C.green or kind=="error" and C.red or C.cyan

            local t = frame(self.gui, {
                color=C.panel, bt=0,
                size=UDim2.new(0,260,0,44),
                anchor=Vector2.new(1,1),
                pos=UDim2.new(1,-16,1,10),
                zindex=1000,
            })
            corner(t, 10)
            stroke(t, toastColor, 1, 0.3)
            -- left accent bar
            local bar = frame(t, {color=toastColor, bt=0, size=UDim2.new(0,3,0.7,0),
                anchor=Vector2.new(0,0.5), pos=UDim2.new(0,0,0.5,0)})
            corner(bar, 2)
            label(t, {text=msg, size=13, color=C.white, font=Enum.Font.GothamSemibold,
                frame_size=UDim2.new(1,-16,1,0), pos=UDim2.new(0,14,0,0),
                xa=Enum.TextXAlignment.Left})
            t.Parent = self.gui
            -- slide in
            tweenPlay(t, 0.35, {Position=UDim2.new(1,-16,1,-16)}, Enum.EasingStyle.Back)
            -- slide out
            task.delay(dur, function()
                if t and t.Parent then
                    tweenPlay(t, 0.25, {Position=UDim2.new(1,10,1,-16)})
                    task.wait(0.3)
                    if t and t.Parent then t:Destroy() end
                end
            end)
        end

        -- setLoading (overlay)
        self.setLoading = function(self, active, msg)
            local rp = self.elements.rightPanel
            local existing = rp:FindFirstChild("LoadingOverlay")
            if active then
                if existing then existing:Destroy() end
                local ov = frame(rp, {
                    color=C.panel, bt=0.05,
                    size=UDim2.new(1,0,1,0),
                    zindex=200, name="LoadingOverlay"
                })
                corner(ov, 0)
                -- spinner
                local spinRing = frame(ov, {
                    color=Color3.fromRGB(0,0,0), bt=1,
                    size=UDim2.new(0,56,0,56),
                    anchor=Vector2.new(0.5,0.5),
                    pos=UDim2.new(0.5,0,0.42,0),
                })
                local sp = stroke(spinRing, C.cyan, 4, 0)
                local spGrad = Instance.new("UIGradient")
                spGrad.Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0,0),
                    NumberSequenceKeypoint.new(0.6,0.2),
                    NumberSequenceKeypoint.new(1,1),
                }
                spGrad.Parent = sp
                corner(spinRing, 28)
                -- spin loop
                task.spawn(function()
                    while spinRing and spinRing.Parent do
                        spGrad.Rotation = (spGrad.Rotation + 6) % 360
                        task.wait(0.02)
                    end
                end)
                -- bounce the ring
                local bounce = tween(spinRing, 1,
                    {Size=UDim2.new(0,62,0,62)}, Enum.EasingStyle.Sine)
                -- just use rotation approach:
                task.spawn(function()
                    while spinRing and spinRing.Parent do
                        tweenPlay(spinRing, 1, {Size=UDim2.new(0,60,0,60)}, Enum.EasingStyle.Sine)
                        task.wait(1)
                        tweenPlay(spinRing, 1, {Size=UDim2.new(0,54,0,54)}, Enum.EasingStyle.Sine)
                        task.wait(1)
                    end
                end)

                label(ov, {
                    text=msg or "Verifying...",
                    size=15, color=C.white, font=Enum.Font.GothamBold,
                    frame_size=UDim2.new(1,-40,0,22),
                    anchor=Vector2.new(0.5,0),
                    pos=UDim2.new(0.5,0,0.42,44),
                })
                label(ov, {
                    text="Please wait a moment",
                    size=11, color=C.sub, font=Enum.Font.Gotham,
                    frame_size=UDim2.new(1,-40,0,16),
                    anchor=Vector2.new(0.5,0),
                    pos=UDim2.new(0.5,0,0.42,70),
                })
            else
                if existing then
                    tweenPlay(existing, 0.2, {BackgroundTransparency=1})
                    task.delay(0.22, function()
                        if existing and existing.Parent then existing:Destroy() end
                    end)
                end
            end
        end

        -- showSuccess overlay
        self.showSuccess = function(self, msg)
            local rp = self.elements.rightPanel
            local ov = frame(rp, {
                color=C.panel, bt=0.05,
                size=UDim2.new(1,0,1,0),
                zindex=300, name="SuccessOverlay"
            })
            corner(ov, 0)
            -- big check circle
            local circ = frame(ov, {
                color=C.green, bt=0.1,
                size=UDim2.new(0,0,0,0),
                anchor=Vector2.new(0.5,0.5),
                pos=UDim2.new(0.5,0,0.4,0),
            })
            corner(circ, 40)
            stroke(circ, C.green, 3, 0.3)
            label(circ, {text="✓", size=0, color=C.white,
                font=Enum.Font.GothamBold,
                frame_size=UDim2.new(1,0,1,0)})

            local checkLbl = circ:FindFirstChild("TextLabel") or circ:FindFirstChildOfClass("TextLabel")

            tweenPlay(circ, 0.4, {
                Size=UDim2.new(0,80,0,80),
                BackgroundTransparency=0.05
            }, Enum.EasingStyle.Back)

            task.wait(0.15)
            if checkLbl then
                tweenPlay(checkLbl, 0.3, {TextSize=38, TextTransparency=0}, Enum.EasingStyle.Back)
            end

            label(ov, {
                text=msg or "Verified!",
                size=18, color=C.white, font=Enum.Font.GothamBold,
                frame_size=UDim2.new(1,-40,0,24),
                anchor=Vector2.new(0.5,0),
                pos=UDim2.new(0.5,0,0.4,52),
            })
            label(ov, {
                text="Launching script...",
                size=12, color=C.sub, font=Enum.Font.Gotham,
                frame_size=UDim2.new(1,-40,0,18),
                anchor=Vector2.new(0.5,0),
                pos=UDim2.new(0.5,0,0.4,78),
            })

            task.wait(1.2)
        end

        -- close
        self.close = function(self)
            getgenv().UI_CLOSED = true
            local blur = Lighting:FindFirstChild("KeySystemBlur")
            if self.elements and self.elements.backdrop then
                tweenPlay(self.elements.backdrop, 0.25, {BackgroundTransparency=1})
            end
            if blur then
                tweenPlay(blur, 0.3, {Size=0})
            end
            task.wait(0.3)
            if blur and blur.Parent then blur:Destroy() end
            if self.gui then self.gui:Destroy() self.gui=nil end
        end

        -- handleGetKey
        self.handleGetKey = function(self)
            local link = Junkie.get_key_link and Junkie.get_key_link()
            if link then
                if setclipboard then
                    setclipboard(link)
                    self:toast("Key link copied to clipboard!", "success", 3)
                else
                    self:setStatus("Link: " .. tostring(link), C.cyan, 380)
                end
            else
                self:toast("Failed to get link", "error", 3)
            end
        end

        -- handleVerify
        self.handleVerify = function(self)
            local key = keyInput.Text:gsub("%s+","")
            if key == "" then
                self:setStatus("⚠  Please enter your key", C.red, 220)
                task.spawn(function() self:shakeInput() end)
                return
            end

            self:setLoading(true, "Verifying key...")
            self:setStatus("Contacting verification servers...", C.sub, 300)
            keyInput.Interactable = false

            local result = Junkie.check_key(key)

            self:setLoading(false)
            keyInput.Interactable = true

            if result and result.valid then
                saveKey(key)
                self:setStatus("✓  Key accepted", C.green, 130)
                task.spawn(function()
                    self:showSuccess("Key Verified ✓")
                    getgenv().SCRIPT_KEY = key
                    self:close()
                end)
            else
                self:setStatus("✕  Invalid or expired key", C.red, 210)
                task.spawn(function() self:shakeInput() end)
                self:toast("Invalid key — please try again", "error", 3)
            end
        end

        -- Get Key button (below verify)
        local getKeyBtn = btn(rightPanel, {
            color=C.panelLight, bt=0,
            size=UDim2.new(1,-40,0,34),
            pos=UDim2.new(0,20,0,256),
            name="GetKeyBtn"
        })
        corner(getKeyBtn, 10)
        stroke(getKeyBtn, C.cyan, 1, 0.5)
        label(getKeyBtn, {
            text="Get Key  →", size=13,
            color=C.cyan, font=Enum.Font.GothamBold
        })

        getKeyBtn.MouseEnter:Connect(function()
            tweenPlay(getKeyBtn, 0.15, {BackgroundColor3=Color3.fromRGB(0,50,65)})
            tweenPlay(getKeyBtn:FindFirstChildOfClass("UIStroke"), 0.15, {Transparency=0})
        end)
        getKeyBtn.MouseLeave:Connect(function()
            tweenPlay(getKeyBtn, 0.15, {BackgroundColor3=C.panelLight})
            tweenPlay(getKeyBtn:FindFirstChildOfClass("UIStroke"), 0.15, {Transparency=0.5})
        end)
        getKeyBtn.MouseButton1Down:Connect(function()
            tweenPlay(getKeyBtn, 0.07, {BackgroundTransparency=0.3})
        end)
        getKeyBtn.MouseButton1Up:Connect(function()
            tweenPlay(getKeyBtn, 0.07, {BackgroundTransparency=0})
        end)

        -- wire buttons
        getKeyBtn.MouseButton1Click:Connect(function()
            self:handleGetKey()
        end)
        verifyBtn.MouseButton1Click:Connect(function()
            self:handleVerify()
        end)
        keyInput.FocusLost:Connect(function(enter)
            if enter then self:handleVerify() end
        end)

        self.gui.Parent = game:GetService("CoreGui")
        self.gui.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
                local b = Lighting:FindFirstChild("KeySystemBlur")
                if b then b:Destroy() end
            end
        end)
    end

    -- ══════════════════════════════════════════════
    --  MAIN CONTROLLER
    -- ══════════════════════════════════════════════
    local UI = {}
    UI.__index = UI

    function UI.new()
        local self = setmetatable({}, UI)
        self.gui = nil
        self.elements = nil
        return self
    end

    local ui = UI.new()
    buildUI(ui)

    -- auto-check saved key
    if ui.setLoading then
        ui:setLoading(true, "Checking saved key...")
    end

    local savedKey = loadKey() or getgenv().SCRIPT_KEY
    local preResult = Junkie.check_key(savedKey)

    if preResult and preResult.valid then
        if preResult.message == "KEYLESS" then
            task.spawn(function()
                if ui.showSuccess then ui:showSuccess("Keyless Mode ✓") end
                getgenv().SCRIPT_KEY = "KEYLESS"
                ui:close()
            end)
        elseif preResult.message == "KEY_VALID" then
            task.spawn(function()
                if ui.showSuccess then ui:showSuccess("Saved Key Verified ✓") end
                getgenv().SCRIPT_KEY = savedKey
                ui:close()
            end)
        else
            clearKey()
            if ui.setLoading then ui:setLoading(false) end
        end
    else
        if savedKey then clearKey() end
        if ui.setLoading then ui:setLoading(false) end
    end

    while not getgenv().UI_CLOSED do
        task.wait(0.1)
    end

    return getgenv().SCRIPT_KEY
end)()

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Failed to load script, please try later again!";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("Key verification failed");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/94b933e069575683340baea39b5ebec8381b685d01842a273bef688c68c0e246?v=2",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h and(h=="LDR-DENIED" or h:match("^LDR%-DENIED:[A-Z_]+$"))then v("Key verification failed ("..h..")");return end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and string.sub(x.Body,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and string.sub(l,1,22)=="https://cdn.jnkie.com/" then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end