do
    local K = _G;
    pcall(function() local R = type(getfenv); if R == "function" then K = getfenv(0); end; end);
    local R = K;
    pcall(function() local X = type(getgenv); if X == "function" then R = getgenv(); end; end);
    if type(K) ~= "table" then
        K = _G;
    end;
    if type(R) ~= "table" then
        R = K;
    end;
    local X, c = rawget(K, "sethiddenproperty") or(rawget(R, "sethiddenproperty")) or(rawget(K, "set_hidden_property")) or(rawget(R, "set_hidden_property")) or(rawget(K, "sethiddenprop")) or(rawget(R, "sethiddenprop")), rawget(K, "syn") or(rawget(R, "syn"));
    if type(X) ~= "function" and type(c) == "table" then
        X = rawget(c, "sethiddenproperty") or(rawget(c, "set_hidden_property"));
    end;
    if type(X) == "function" then
        pcall(function() rawset(K, "sethiddenproperty", X); end);
        pcall(function() rawset(R, "sethiddenproperty", X); end);
    end;
    local X = rawget(K, "setfpscap") or(rawget(R, "setfpscap")) or(rawget(K, "set_fps_cap")) or(rawget(R, "set_fps_cap")) or(rawget(K, "setfpslimit")) or(rawget(R, "setfpslimit"));
    X = if type(X) ~= "function" and type(c) == "table" then
        rawget(c, "setfpscap") or(rawget(c, "set_fps_cap"))
    else
        X;
        if type(X) == "function" then
            pcall(X, 9999);
        end;
    end;
    local K, R, X, c, i, Q, h, m, A = (function() local H, E = game:GetService("Players"), game:GetService("UserInputService"); local s = E.TouchEnabled; pcall(function() local b = E:GetPlatform(); s = E.TouchEnabled and(b == Enum.Platform.Android or b == Enum.Platform.IOS or not E.MouseEnabled); end); return H, E, game:GetService("TweenService"), game:GetService("RunService"), game:GetService("ReplicatedStorage"), game:GetService("Lighting"), game:GetService("HttpService"), H.LocalPlayer, s; end)();
    local H = "unknown";
    do
        local E = _G;
        pcall(function() local s = type(getgenv); if s == "function" then E = getgenv(); end; end);
        if type(E) ~= "table" then
            E = _G;
        end;
        local s = rawget(E, "identifyexecutor") or(rawget(E, "getexecutorname")) or type(_G) == "table" and(rawget(_G, "identifyexecutor") or(rawget(_G, "getexecutorname")));
        if type(s) == "function" then
            pcall(function() local E = s(); if E ~= nil then H = tostring(E); end; end);
        end;
    end;
    _G.__GhostDuelWaveSafeMode = string.find(string.lower(H), "wave", 1, true) ~= nil;
    do
        local H = {"GhostDuel_Panel", "GhostDuel", "GhostDuel_Panel", "DashEffectGui", "GhostDuelAutoGrabBar", "GhostDuelLaggerGUI", "GhostDuelBypassGUI", "GhostDuelMobileUI", "GhostDuelEnemyWidget"};
        pcall(function() local E = _G.GhostDuelBypass; if E then if E.Stop then E.Stop(); else if E.SetAutoOnSteal then E.SetAutoOnSteal(false); end; if E.SetBypass then E.SetBypass(false); end; end; end; end);
        pcall(function() local E = _G.GhostDuelLagger; if E then if E.Stop then E.Stop(); else if E.SetEnabled then E.SetEnabled(false); end; if E.SetLowEndEnabled then E.SetLowEndEnabled(false); end; end; end; end);
        if _G.__GhostDuel_STATE then
            _G.__GhostDuel_STATE.alive = false;
            pcall(function() for E, E in ipairs(_G.__GhostDuel_STATE.stoppers or {}) do pcall(E); end; for E, E in ipairs(_G.__GhostDuel_STATE.conns or {}) do pcall(function() E:Disconnect(); end); end; end);
        end;
        _G.__GhostDuel_STATE = nil;
        _G.__GhostDuelTrackConn = nil;
        _G.__GhostDuelTrackStopper = nil;
        pcall(function() if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil; end; end);
        pcall(function() if _G.__stopSpeedBoost then _G.__stopSpeedBoost (); end; end);
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge); end);
        pcall(function() local E, s = ipairs, {game:GetService("CoreGui"), m.PlayerGui}; for b, V in E(s) do for E, E in ipairs(H) do while true do b = V:FindFirstChild(E); if not b then break; end; b:Destroy(); end; end; end; end);
        pcall(function() for H, E in ipairs(K:GetPlayers()) do H = E.Character; if H then for E, E in ipairs(H:GetChildren()) do for H, H in ipairs(E:GetChildren()) do if H.Name == "GreenDuelsBB" or H.Name == "GhostDuelSpeedBill" or H.Name == "GhostDuelOverhead" or H.Name == "GhostDuelAimbotBodyLock" or H.Name == "GhostDuelAimbotBodyAttachment" or H.Name == "GhostDuelTPBatMarkerBodyLock" or H.Name == "GhostDuelTPBatMarkerAttachment" then H:Destroy(); end; end; end; end; end; end);
        _G.__GhostDuel_STATE = {conns = {}, stoppers = {}, alive = true};
        function _G.__GhostDuelTrackConn (H)
            if H then
                table.insert(_G.__GhostDuel_STATE.conns, H);
            end;
            return H;
        end;
        function _G.__GhostDuelTrackStopper (H)
            if H then
                table.insert(_G.__GhostDuel_STATE.stoppers, H);
            end;
        end;
        _G.__GhostDuelResetHooks = {};
        function _G.__GhostDuelOnNewInstance (H)
            if H then
                table.insert(_G.__GhostDuelResetHooks, H);
            end;
        end;
    end;
    local H = _G.__GhostDuel_STATE;
    do
        local E, s = {};
        local function b()
            if s then
                return;
            end;
            s = c.Heartbeat:Connect(function() local V = os.clock() + 8.0E-4; while E[1] and os.clock() < V do local V = E[1]; if V.cancelled or V["continue"] and not V["continue"]() then table.remove(E, 1); else local F = V.pending[#V.pending]; if not F then table.remove(E, 1); else V.pending[#V.pending] = nil; pcall(V.apply, F); local N, I = pcall(function() return F:GetChildren(); end); if N then for F, F in ipairs(I) do V.pending[#V.pending + 1] = F; end; end; if E[2] then table.remove(E, 1); E[#E + 1] = V; end; end; end; end; if not E[1] then s:Disconnect(); s = nil; end; end);
            _G.__GhostDuelTrackConn (s);
        end;
        function _G.__GhostDuelWalkDescendantsBatched (V, F, N)
            local I = {pending = {}, apply = F, ["continue"] = N, cancelled = false};
            for N, P in ipairs((if typeof(V) == "Instance" then {V} else V) or {}) do
                if P then
                    F, N = pcall(function() return P:GetChildren(); end);
                    if F then
                        for V, V in ipairs(N) do
                            I.pending[#I.pending + 1] = V;
                        end;
                    end;
                end;
            end;
            E[#E + 1] = I;
            b();
            return function()
                I.cancelled = true;
            end;
        end;
        _G.__GhostDuelTrackStopper (function() for b, b in ipairs(E) do b.cancelled = true; end; E = {}; if s then s:Disconnect(); s = nil; end; end);
    end;
    do
        local E, s = false, false;
        _G.__GhostDuelAntiDieGuiEnabled = nil;
        local b, V = {};
        local function F(N, I)
            local P = b[N];
            if P then
                if P.healthConn then
                    pcall(function() P.healthConn:Disconnect(); end);
                end;
                if P.diedConn then
                    pcall(function() P.diedConn:Disconnect(); end);
                end;
                if P.cleanupConn then
                    pcall(function() P.cleanupConn:Disconnect(); end);
                end;
                b[N] = nil;
            end;
            if I and N and N.Parent then
                pcall(function() local I = N:FindFirstChildOfClass("Humanoid"); if I then I.BreakJointsOnDeath = true; I:SetStateEnabled(Enum.HumanoidStateType.Dead, true); end; end);
            end;
        end;
        local function N(I)
            if not I or not I.Parent then
                return;
            end;
            local P = I:FindFirstChildOfClass("Humanoid");
            if not P then
                return;
            end;
            F(I, false);
            P.BreakJointsOnDeath = false;
            P:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
            local k;
            k = {humanoid = P, healthConn = P:GetPropertyChangedSignal("Health"):Connect(function() if E and b[I] == k and P.Health <= 0 then P.Health = P.MaxHealth; end; end), diedConn = P.Died:Connect(function() task.defer(function() if E and b[I] == k and P and P.Parent then P.BreakJointsOnDeath = false; P:SetStateEnabled(Enum.HumanoidStateType.Dead, false); P.Health = P.MaxHealth; end; end); end), cleanupConn = I.AncestryChanged:Connect(function() if not I.Parent then F(I, false); end; end)};
            b[I] = k;
        end;
        local function I(P)
            P = P == true;
            if P == E then
                return;
            end;
            E = P;
            if P then
                local P = V;
                if not P then
                    V = m.CharacterAdded:Connect(function(k) task.wait(0.2); if E and k and k.Parent then N(k); end; end);
                end;
                P = m.Character;
                if P and P.Parent and not b[P] then
                    N(P);
                end;
            else
                for P in pairs(b) do
                    F(P, true);
                end;
            end;
        end;
        local F = {toggle = false, autobat = false};
        local function P()
            if s then
                return;
            end;
            local k = F.toggle;
            I((if _G.__GhostDuelAntiDieGuiEnabled then _G.__GhostDuelAntiDieGuiEnabled () == true else k) or F.autobat);
        end;
        function _G.__GhostDuelAntiDieSource (k, x)
            if s or F[k] == nil then
                return;
            end;
            F[k] = x == true;
            P();
        end;
        function _G.__GhostDuelAntiDieSet (k)
            _G.__GhostDuelAntiDieSource ("autobat", k);
        end;
        function _G.__GhostDuelAntiDieIsEnabled ()
            return E;
        end;
        _G.__GhostDuelTrackStopper (function() s = true; F.toggle = false; F.autobat = false; I(false); end);
        local F, k = false, I;
        I = function(I)
            k(I);
            if V and not F then
                F = true;
                _G.__GhostDuelTrackConn (V);
            end;
        end;
        _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function() if s then return; end; P(); if not E then return; end; local E = m.Character; local s = E and E.Parent and(E:FindFirstChildOfClass("Humanoid")); if not s then return; end; local V = b[E]; if not V or V.humanoid ~= s then N(E); end; if s.BreakJointsOnDeath then s.BreakJointsOnDeath = false; end; if s:GetStateEnabled(Enum.HumanoidStateType.Dead) then s:SetStateEnabled(Enum.HumanoidStateType.Dead, false); end; if s.Health <= 0 then s.Health = s.MaxHealth; end; end));
    end;
    FeatureToggles = FeatureToggles or {};
    local E, s, b, V, F = {}, {Aimbot = true, ["Lagger Aimbot"] = true, Autoplay = true, Lagger = true}, {Aimbot = true, Drop = true, ["TP Down"] = true, Autoplay = true, ["ESP Players"] = true, ["Player Tracers"] = true}, {}, {};
    for N, I in pairs(b) do
        V[N] = false;
        F[N] = true;
    end;
    if featureName == "Toggle UI" then
        bindPill.Visible = true;
        bindPill.Position = UDim2.new(1,- 48, 0.5,- 10);
    end;
    local N, I, P, k, x, _, L, z, S, g, O, n, J, f, o, q, B, j = {NormalBoost = 59, NormalSteal = 29, LaggerBoost = 40, LaggerSteal = 20, DesyncBoost = 59, DesyncSteal = 29, BypassPower = 300000, BypassDepth = 296, MobileButtonScale = 1, FOV = 90, StretchIntensity = 0.75, CypherAimbotApproachSpeed = 55, AutoTPDownHeight = 20}, {}, {Radius = 65, Duration = 1.3}, "v1", "V1", "Normal", 1, 59, 30, 40, false, "v1", false, Vector3.new(0, 0, 0), {[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true, [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true}, {SelectNormalMode = nil, SelectLaggerMode = nil, Drop = nil, Autoplay = nil, ["Toggle UI"] = nil, Aimbot = nil, ["Anti Bat"] = nil, ["Carry Speed"] = nil, BypassToggle = nil, BypassAuto = nil, FuckerToggle = nil};
    local w, y, U, e, a, W, T, l, Z, p = {}, {}, {}, {}, false, FeaturePostToggle or {};
    _G = _G or {};
    _G.__GhostDuelDropMode = _G.__GhostDuelDropMode == "Jump Drop" and "Jump Drop" or "Stand Drop";
    _G._GhostDuel_UI_Data = _G._GhostDuel_UI_Data or {};
    local C, r = {}, {};
    _G.__GhostDuelButtonsSize = 1;
    _G.__GhostDuelGuiPositionResetters = {};
    _G.__GhostDuelResetButtonPositions = nil;
    _G.__GhostDuelGuiPositionsReset = false;
    function _G.__GhostDuelRoundPanelBackground (Y, v)
        local M = Instance.new("CanvasGroup");
        M.Name = "RoundedBackgroundMask";
        M.Size = UDim2.fromScale(1, 1);
        M.Position = UDim2.fromOffset(0, 0);
        M.BackgroundTransparency = 1;
        M.BorderSizePixel = 0;
        M.GroupTransparency = 0;
        M.ZIndex = Y.ZIndex;
        M.Parent = v;
        local u = v:FindFirstChildOfClass("UICorner");
        Instance.new("UICorner", M).CornerRadius = u and u.CornerRadius or(UDim.new(0, 16));
        u = Y:FindFirstChildOfClass("UICorner");
        if u then
            u:Destroy();
        end;
        Y.Parent = M;
    end;
    function _G.__GhostDuelFramePanelBackground (Y, v, v)
        Y.ScaleType = Enum.ScaleType.Crop;
        if v == "Bypass" then
            Y.Size = UDim2.new(1, 0, 1.02, 0);
            Y.Position = UDim2.fromScale(0,- 0.02);
        else
            Y.Size = UDim2.fromScale(1, 1);
            Y.Position = UDim2.fromScale(0, 0);
        end;
    end;
    function _G.__GhostDuelAddOriginalGui3Title (Y, v)
        if Y then
            Y.Text = string.upper(tostring(v or "GhostDuel"));
        end;
    end;
    local function Y(v, M, u, t, G, D, d)
        local Ki = workspace.CurrentCamera;
        local Ri = Ki and Ki.ViewportSize or(Vector2.new(1920, 1080));
        if Ri.X <= 0 or Ri.Y <= 0 then
            return M, t;
        end;
        d = d or 1;
        G *= d;
        D *= d;
        local d, Ki, Xi, ci =- Ri.X * v, Ri.X * (1 - v) - G,- Ri.Y * u, Ri.Y * (1 - u) - D;
        return math.clamp(M, d, if Ki < d then d else Ki), math.clamp(t, Xi, if ci < Xi then Xi else ci);
    end;
    local function v(M, u, t, G, D, d)
        local Ki, Ri = Y(u, t, G, D, M.Size.X.Offset, M.Size.Y.Offset, d);
        M.Position = UDim2.new(u, Ki, G, Ri);
        return Ki, Ri;
    end;
    local function Y()
        return false;
    end;
    local M = setmetatable({}, {__mode = "k"});
    _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(u) local t = M[u]; if not t then return; end; if u.UserInputType ~= Enum.UserInputType.Touch and u.UserInputType ~= Enum.UserInputType.MouseMovement then return; end; for G, G in ipairs(t) do if(u.Position - G.tapStart).Magnitude > 12 then G.tapMoved = true; end; end; end));
    _G.__GhostDuelTrackConn (R.InputEnded:Connect(function(u) local t = M[u]; if not t then return; end; M[u] = nil; for u, u in ipairs(t) do if not u.tapMoved and true then if not(u.scroll and u.scrollCanvasAtStart and math.abs(u.scroll.CanvasPosition.Y - u.scrollCanvasAtStart) > 5) then u.callback(); end; end; end; end));
    local function u(t, G)
        if Y() then
            return;
        end;
        t.InputBegan:Connect(function(t) if t.UserInputType ~= Enum.UserInputType.Touch and t.UserInputType ~= Enum.UserInputType.MouseButton1 then return; end; local D, d = Scroll, M[t]; if not d then d = {}; M[t] = d; end; table.insert(d, {tapStart = t.Position, tapMoved = false, scroll = D, scrollCanvasAtStart = D and D.CanvasPosition.Y or nil, callback = G}); end);
    end;
    local M, t, G, D, d = {["245,250,255"] = Color3.fromRGB(9, 24, 52), ["235,245,255"] = Color3.fromRGB(12, 34, 70), ["210,230,250"] = Color3.fromRGB(18, 48, 92), ["190,220,250"] = Color3.fromRGB(28, 78, 132), ["140,190,240"] = Color3.fromRGB(36, 108, 174), ["80,160,255"] = Color3.fromRGB(45, 140, 220), ["50,110,190"] = Color3.fromRGB(148, 220, 255), ["80,130,200"] = Color3.fromRGB(160, 225, 255), ["40,80,150"] = Color3.fromRGB(135, 210, 255), ["30,90,200"] = Color3.fromRGB(115, 200, 255), ["60,120,200"] = Color3.fromRGB(145, 215, 255), ["100,140,200"] = Color3.fromRGB(165, 225, 255)}, {"BackgroundColor3", "BorderColor3"}, {"BackgroundColor3", "TextColor3", "BorderColor3"}, {"TextColor3", "TextStrokeColor3", "TextStrokeTransparency"}, {[Enum.FontWeight.Thin] = Enum.FontWeight.ExtraLight, [Enum.FontWeight.ExtraLight] = Enum.FontWeight.Light, [Enum.FontWeight.Light] = Enum.FontWeight.Regular, [Enum.FontWeight.Regular] = Enum.FontWeight.Medium, [Enum.FontWeight.Medium] = Enum.FontWeight.SemiBold, [Enum.FontWeight.SemiBold] = Enum.FontWeight.Bold, [Enum.FontWeight.Bold] = Enum.FontWeight.ExtraBold};
    local function Ki(Ri)
        if not(Ri:IsA("TextLabel") or(Ri:IsA("TextButton")) or(Ri:IsA("TextBox"))) then
            return;
        end;
        if Ri:GetAttribute("GhostDuelSlightFontWeightApplied") or(Ri:GetAttribute("GhostDuelSlightFontWeightPending")) then
            return;
        end;
        Ri:SetAttribute("GhostDuelSlightFontWeightPending", true);
        task.defer(function() if not Ri.Parent or(Ri:GetAttribute("GhostDuelSlightFontWeightApplied")) then Ri:SetAttribute("GhostDuelSlightFontWeightPending", nil); return; end; local Xi = pcall(function() local ci = Ri.FontFace; local ii = d[ci.Weight]; if ii then Ri.FontFace = Font.new(ci.Family, ii, ci.Style); end; end); Ri:SetAttribute("GhostDuelSlightFontWeightPending", nil); if Xi then Ri:SetAttribute("GhostDuelSlightFontWeightApplied", true); end; end);
    end;
    local d;
    local Ri = setmetatable({}, {__mode = "k"});
    local function Xi(ci)
        local ii = ci;
        while ii and not ii:IsA("GuiButton") and not ii:GetAttribute("GhostDuelButtonThemeControl") do
            ii = ii.Parent;
        end;
        if not ii then
            return;
        end;
        ii = ci:IsA("UIStroke") and "Color" or ci:IsA("UIGradient") and "Color" or ci:IsA("GuiObject") and "BackgroundColor3";
        if not ii then
            return;
        end;
        local Qi = Ri[ci];
        if not Qi then
            Qi = {};
            Ri[ci] = Qi;
            _G.__GhostDuelTrackConn (ci:GetPropertyChangedSignal(ii):Connect(function() Xi(ci); end));
        end;
        if Qi.busy then
            return;
        end;
        local Ri = ci[ii];
        if Ri == Qi.applied and Qi.theme == _G.__GhostDuelGuiTheme then
            return;
        end;
        if Ri ~= Qi.applied then
            Qi.original = Ri;
        end;
        local hi = _G.__GhostDuelGuiTheme;
        local function mi(Ai)
            if hi ~= "GUI 2" and hi ~= "GUI 3" then
                return Ai;
            end;
            local Hi = math.max(Ai.R, Ai.G, Ai.B);
            return Color3.fromRGB(7, 22, 48):Lerp(Color3.fromRGB(125, 215, 255), Hi);
        end;
        local Ai = Qi.original;
        if ci:IsA("UIGradient") then
            if hi == "GUI 2" or hi == "GUI 3" then
                local Hi = {};
                for Ei, Ei in ipairs(Ai.Keypoints) do
                    table.insert(Hi, ColorSequenceKeypoint.new(Ei.Time, mi(Ei.Value)));
                end;
                Ai = (ColorSequence.new(Hi));
            end;
        else
            Ai = (mi(Ai));
        end;
        Qi.applied = Ai;
        Qi.theme = hi;
        if Ri ~= Ai then
            Qi.busy = true;
            ci[ii] = Ai;
            Qi.busy = false;
        end;
    end;
    d = function(Ri)
        if not Ri then
            return;
        end;
        local ci;
        if Ri:IsA("TextLabel") or(Ri:IsA("TextButton")) or(Ri:IsA("TextBox")) then
            Ki(Ri);
            ci = G;
        else
            ci = if Ri:IsA("GuiObject") then
                t
            else
                ci;
            end;
            if ci then
                for G, ii in ipairs(ci) do
                    G = Ri[ii];
                    local Qi = string.format("%d,%d,%d", math.floor(G.R * 255 + 0.5), math.floor(G.G * 255 + 0.5), math.floor(G.B * 255 + 0.5));
                    if M[Qi] then
                        Ri[ii] = M[Qi];
                    end;
                end;
            end;
            if Ri:IsA("UIStroke") then
                ci = Ri.Color;
                local G = string.format("%d,%d,%d", math.floor(ci.R * 255 + 0.5), math.floor(ci.G * 255 + 0.5), math.floor(ci.B * 255 + 0.5));
                if ci.B > ci.R + 12 and ci.B >= ci.G then
                    Ri.Color = Color3.fromRGB(0, 0, 0);
                elseif M[G] then
                    Ri.Color = M[G];
                end;
            end;
            if not _G.__GhostDuelModernGuiActive and not Ri:GetAttribute("GhostDuelDarkPaletteWatched") then
                Ri:SetAttribute("GhostDuelDarkPaletteWatched", true);
                local function M(G)
                    _G.__GhostDuelTrackConn (Ri:GetPropertyChangedSignal(G):Connect(function() d(Ri); end));
                end;
                if Ri:IsA("UIStroke") then
                    M("Color");
                elseif Ri:IsA("GuiObject") then
                    for G, G in ipairs(t) do
                        M(G);
                    end;
                    if Ri:IsA("TextLabel") or(Ri:IsA("TextButton")) or(Ri:IsA("TextBox")) then
                        for t, t in ipairs(D) do
                            M(t);
                        end;
                    end;
                end;
            end;
            Xi(Ri);
        end;
        _G.__GhostDuelThemeRoots = {};
        local M = setmetatable({}, {__mode = "k"});
        function _G.__GhostDuelRegisterThemeRoot (t)
            if not t then
                return;
            end;
            for G, G in ipairs(_G.__GhostDuelThemeRoots) do
                if G == t then
                    return;
                end;
            end;
            table.insert(_G.__GhostDuelThemeRoots, t);
            d(t);
            if M[t] then
                M[t]();
            end;
            M[t] = _G.__GhostDuelWalkDescendantsBatched (t, d, function() return t.Parent ~= nil; end);
            _G.__GhostDuelTrackConn (t.DescendantAdded:Connect(d));
        end;
        function _G.__GhostDuelApplyTheme ()
            for t, t in ipairs(_G.__GhostDuelThemeRoots) do
                if t and t.Parent then
                    d(t);
                    if M[t] then
                        M[t]();
                    end;
                    M[t] = _G.__GhostDuelWalkDescendantsBatched (t, d, function() return t.Parent ~= nil; end);
                end;
            end;
        end;
        function _G.__GhostDuelAddUnifiedPanelShade (M, t, G)
            local D = M and(M:FindFirstChild("UnifiedBackgroundShade"));
            if D then
                D:Destroy();
            end;
            D = M and(M:FindFirstChild("UnifiedPanelWhiteOutline"));
            if D then
                D:Destroy();
            end;
            D = M and(M:FindFirstChild("UnifiedPanelWhiteGlow"));
            if D then
                D:Destroy();
            end;
            D = Instance.new("Frame");
            D.Name = "UnifiedBackgroundShade";
            D.Size = UDim2.fromScale(1, 1);
            D.Position = UDim2.fromScale(0, 0);
            D.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            D.BackgroundTransparency = 0.68;
            D.BorderSizePixel = 0;
            D.Active = false;
            D.ZIndex = G or 1;
            D.Parent = M;
            Instance.new("UICorner", D).CornerRadius = UDim.new(0, t or 16);
            G = Instance.new("UIGradient", D);
            G.Rotation = 90;
            G.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.28), NumberSequenceKeypoint.new(0.55, 0.42), NumberSequenceKeypoint.new(1, 0.56)});
            return D;
        end;
        local M = {[Enum.UserInputType.Gamepad1] = true, [Enum.UserInputType.Gamepad2] = true, [Enum.UserInputType.Gamepad3] = true, [Enum.UserInputType.Gamepad4] = true, [Enum.UserInputType.Gamepad5] = true, [Enum.UserInputType.Gamepad6] = true, [Enum.UserInputType.Gamepad7] = true, [Enum.UserInputType.Gamepad8] = true};
        local function t(G)
            return G and G.KeyCode and G.KeyCode ~= Enum.KeyCode.Unknown and(G.UserInputType == Enum.UserInputType.Keyboard or M[G.UserInputType]);
        end;
        local function G(D)
            return D and D.UserInputType == Enum.UserInputType.Keyboard and D.KeyCode == Enum.KeyCode.RightControl;
        end;
        local D, d = {}, {MB3 = "Mouse3"};
        pcall(function() D[Enum.UserInputType.MouseButton3] = "MB3"; end);
        local function Ri(Xi)
            return Xi and D[Xi.UserInputType] ~= nil;
        end;
        local function Xi(ci)
            return D[ci.UserInputType];
        end;
        local function D(ci)
            if not ci then
                return "-";
            end;
            if type(ci) == "string" then
                return d[ci] or ci;
            end;
            return tostring(ci):match("KeyCode%.(.+)") or(tostring(ci));
        end;
        b = {["Inf Jump"] = false, ["Anti Bat"] = false, ["TP Down"] = false, ["Auto TP Down"] = false, ["Anti Ragdoll"] = false, ["Ragdoll Counter"] = false, ["Medusa Counter"] = false, Aimbot = false, ["Lagger Aimbot"] = false, Autoplay = false, Drop = false, ["auto steal"] = false, ["ESP Players"] = false, ["Player Tracers"] = false, ["Show Buttons"] = false, ["Lock Buttons"] = false, ["Show FPS"] = false, ["FPS Boost"] = false, ["Anti Lag"] = false, Optimizer = true, Lagger = false, Bypass = false, ["Speed Boost"] = true, ["Toggle UI"] = true, ["Auto Steal Speed"] = false, ["Auto Carry Speed"] = false, ["Carry Speed"] = false, Unwalk = false, ["Harder Hit Anim"] = false, Animaciones = false, ["Custom FOV"] = false, ["Stretchz Res"] = false, ["Sky Changer"] = false, ["Skin Changer"] = false, ["Headless Visual"] = false, ["Korblox Visual"] = false, ["Anti Die"] = false};
        for ci, ii in pairs(b) do
            E[ci] = ii;
        end;
        local ci, ii;
        local Qi = 0;
        local function hi(mi)
            if not mi or mi == ci then
                return;
            end;
            pcall(writefile, "GhostDuel_UI_Config.txt", mi);
            ci = mi;
        end;
        local function mi()
            local Ai = {};
            for Hi, Ei in pairs(E) do
                if not s[Hi] then
                    table.insert(Ai, "T:" .. Hi .. "=" .. tostring(Ei));
                end;
            end;
            for Hi, Ei in pairs(V) do
                table.insert(Ai, "S:" .. Hi .. "=" .. tostring(Ei));
            end;
            for Hi, Ei in pairs(F) do
                table.insert(Ai, "B:" .. Hi .. "=" .. tostring(Ei));
            end;
            for Hi, Ei in pairs(N) do
                table.insert(Ai, "V:" .. Hi .. "=" .. tostring(Ei));
            end;
            for Hi, Ei in pairs(P) do
                table.insert(Ai, "A:" .. Hi .. "=" .. tostring(Ei));
            end;
            for Hi, Hi in ipairs(I) do
                table.insert(Ai, "C:" .. Hi.name .. "=" .. Hi.boost .. "," .. Hi.steal);
            end;
            if _G.__GhostDuel_Anims then
                for Hi, Ei in pairs(_G.__GhostDuel_Anims) do
                    table.insert(Ai, "N:" .. Hi .. "=" .. Ei);
                end;
            end;
            table.insert(Ai, "M:selectedMode=" .. _);
            table.insert(Ai, "M:optimizerMode=Normal");
            table.insert(Ai, "M:autoplayMode=" .. (_G.__autoplayMode or "Full"));
            table.insert(Ai, "M:skyIndex=" .. tostring(_G.__skyGetIndex and(_G.__skyGetIndex ()) or 1));
            table.insert(Ai, "M:skyMode=" .. tostring(_G.__GhostDuelSkyChangerMode or "blue"));
            table.insert(Ai, "M:katanaIndex=" .. tostring(_G.__katanaGetIndex and(_G.__katanaGetIndex ()) or 1));
            table.insert(Ai, "M:autoStealMode=" .. (k == "v2" and "v2" or "v1"));
            table.insert(Ai, "M:carrySpeedMode=" .. (n or "v1"));
            table.insert(Ai, "M:dropMode=" .. (_G.__GhostDuelDropMode == "Jump Drop" and "Jump Drop" or "Stand Drop"));
            table.insert(Ai, "M:infJumpMode=" .. (_G.__GhostDuelInfJumpMode or "hold"));
            table.insert(Ai, "M:panelVisible=" .. tostring(_G.__GhostDuelPanelVisible ~= false));
            table.insert(Ai, "M:batVersion=" .. tostring(_G.__batVersion or 1));
            table.insert(Ai, "M:skinChangerMode=" .. x);
            table.insert(Ai, "M:buttonsSize=" .. tostring(_G.__GhostDuelButtonsSize or 1));
            table.insert(Ai, "M:tpBatV2Distance=" .. tostring(math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)));
            if _G.__GhostDuelAnimationPreset then
                table.insert(Ai, "M:animationPreset=" .. tostring(_G.__GhostDuelAnimationPreset));
            end;
            table.insert(Ai, "M:guiTheme=" .. tostring(_G.__GhostDuelGuiTheme or "GUI 1"));
            table.insert(Ai, "M:themePrimary=" .. (_G.__GhostDuelThemePrimary or "BLACK"));
            table.insert(Ai, "M:themeSecondary=" .. (_G.__GhostDuelThemeSecondary or "BLUE"));
            table.insert(Ai, "M:autoGrabExpanded=" .. tostring(_G._GhostDuel_UI_AutoGrabExpanded ~= false));
            for Hi, Ei in pairs(q) do
                if Ei then
                    local si = if type(Ei) == "string" then
                        Ei
                    else
                        tostring(Ei):match("KeyCode%.(.+)") or(tostring(Ei));
                        table.insert(Ai, "K:" .. Hi .. "=" .. si);
                    end;
                end;
                if _G._GhostDuel_UI_MenuPos then
                    local Hi = _G._GhostDuel_UI_MenuPos;
                    if Hi.x and Hi.y then
                        table.insert(Ai, "P:menuPos=" .. math.floor(Hi.x) .. "," .. math.floor(Hi.y));
                    end;
                end;
                table.insert(Ai, "M:introMusicIndex=" .. tostring(L));
                table.insert(Ai, "M:bgIndex=" .. tostring(_G._GhostDuel_UI_BgIndex or 1));
                if _G.__toggleBtn then
                    table.insert(Ai, "P:toggleBtn=" .. math.floor(_G.__toggleBtn.Position.X.Offset) .. "," .. math.floor(_G.__toggleBtn.Position.Y.Offset));
                end;
                for Hi, Ei in pairs(C) do
                    if Ei.x and Ei.y then
                        table.insert(Ai, "P:mobileBtn_" .. Hi .. "=" .. math.floor(Ei.x) .. "," .. math.floor(Ei.y) .. (if Ei.xs and Ei.ys then ":" .. Ei.xs .. ":" .. Ei.ys else ""));
                    end;
                end;
                for Hi, Ei in pairs(r) do
                    if Ei.x and Ei.y then
                        table.insert(Ai, "P:quickBtn_" .. Hi .. "=" .. math.floor(Ei.x) .. "," .. math.floor(Ei.y));
                    end;
                end;
                if _G._GhostDuel_UI_SpeedFramePos then
                    local Hi = _G._GhostDuel_UI_SpeedFramePos;
                    if Hi.x and Hi.y then
                        table.insert(Ai, "P:speedFrame=" .. math.floor(Hi.x) .. "," .. math.floor(Hi.y));
                    end;
                end;
                if _G._GhostDuel_EnemyWidget_SaveHook then
                    pcall(_G._GhostDuel_EnemyWidget_SaveHook);
                end;
                if _G._GhostDuel_UI_EnemyWidgetPos then
                    local Hi = _G._GhostDuel_UI_EnemyWidgetPos;
                    if Hi.x and Hi.y then
                        table.insert(Ai, "P:enemyWidget=" .. math.floor(Hi.x) .. "," .. math.floor(Hi.y));
                    end;
                end;
                if _G._GhostDuel_UI_AutoGrabBarPos then
                    local Hi = _G._GhostDuel_UI_AutoGrabBarPos;
                    if Hi.x and Hi.y then
                        table.insert(Ai, "P:autoGrabBar=" .. math.floor(Hi.x) .. "," .. math.floor(Hi.y));
                    end;
                end;
                if _G._GhostDuel_UI_AutoGrabBarSize then
                    table.insert(Ai, "P:autoGrabBarSize=" .. tostring(_G._GhostDuel_UI_AutoGrabBarSize));
                end;
                if _G._GhostDuel_UI_ModernMiniPos then
                    local Hi = _G._GhostDuel_UI_ModernMiniPos;
                    if Hi.x and Hi.y then
                        table.insert(Ai, "P:modernMini=" .. math.floor(Hi.x) .. "," .. math.floor(Hi.y));
                    end;
                end;
                local Hi = table.concat(Ai, "\10");
                if Hi == ci or Hi == ii then
                    return;
                end;
                ii = Hi;
                _G._GhostDuel_UI_Data = Hi;
                Qi += 1;
                local ci = Qi;
                task.delay(0.2, function() if ci ~= Qi or ii ~= Hi then return; end; ii = nil; hi(Hi); end);
            end;
            _G.__GhostDuelTrackStopper (function() if ii then hi(ii); ii = nil; end; end);
            function FeatureToggles.BypassAuto()
                if _G.GhostDuelBypass and _G.GhostDuelBypass.SetBypass and _G.GhostDuelBypass.IsEnabled then
                    local ci = _G.GhostDuelBypass.IsEnabled() == true;
                    pcall(_G.GhostDuelBypass.SetBypass, not ci);
                    pcall(function() if _G.__syncBypassVisual then _G.__syncBypassVisual (); end; end);
                else
                    if _G.__openBypassGUI then
                        _G.__openBypassGUI ();
                    end;
                    task.spawn(function() for ci = 1, 20, 1 do task.wait(0.1); if _G.GhostDuelBypass and _G.GhostDuelBypass.SetBypass and _G.GhostDuelBypass.IsEnabled then break; end; end; if _G.GhostDuelBypass and _G.GhostDuelBypass.SetBypass and _G.GhostDuelBypass.IsEnabled then local ci = _G.GhostDuelBypass.IsEnabled() == true; pcall(_G.GhostDuelBypass.SetBypass, not ci); end; pcall(function() if _G.__syncBypassVisual then _G.__syncBypassVisual (); end; end); end);
                end;
            end;
            local function ci(ii)
                local Qi, hi = {"Aimbot", "TP Bat"}, false;
                for Ai, Hi in ipairs(Qi) do
                    if Hi ~= ii and Hi ~= "TP Bat" and E[Hi] then
                        E[Hi] = false;
                        Ai = e[Hi];
                        if Ai then
                            pcall(Ai, false);
                        end;
                        if W[Hi] then
                            pcall(W[Hi], false);
                        end;
                        hi = true;
                    end;
                end;
                if hi then
                    mi();
                end;
            end;
            function _G.__deactivateBatExclusive (ii)
                local Qi, hi = {"Aimbot", "TP Bat"}, false;
                for Ai, Hi in ipairs(Qi) do
                    if Hi ~= ii and Hi ~= "TP Bat" and E[Hi] then
                        E[Hi] = false;
                        Ai = e[Hi];
                        if Ai then
                            pcall(Ai, false);
                        end;
                        if W[Hi] then
                            pcall(W[Hi], false);
                        end;
                        hi = true;
                    end;
                end;
                if hi then
                    mi();
                end;
            end;
            (function() local ii, Qi = pcall(readfile, "GhostDuel_UI_Config.txt"); local hi = if ii and Qi and #Qi > 0 then Qi else if _G._GhostDuel_UI_Data and #_G._GhostDuel_UI_Data > 0 then _G._GhostDuel_UI_Data else nil; if not hi then return; end; for Ai in hi:gmatch("[^\10]+") do local hi, Hi, Ei = Ai:sub(1, 2), Ai:sub(3):match("([^=]+)=(.+)"); if Hi and Ei then Hi, Ei = Hi:match("^%s*(.-)%s*$"), Ei:match("^%s*(.-)%s*$"); if hi == "T:" and E[Hi] ~= nil and not s[Hi] then E[Hi] = Ei == "true"; elseif hi == "S:" then V[Hi] = Ei == "true"; elseif hi == "B:" then F[Hi] = Ei == "true"; elseif hi == "V:" and N[Hi] ~= nil then Qi = tonumber(Ei); if Qi then N[Hi] = Qi; if Hi == "NormalBoost" then z = Qi; end; if Hi == "NormalSteal" then S = Qi; end; if Hi == "LaggerBoost" then g = Qi; end; end; elseif hi == "N:" then _G.__savedAnimations = _G.__savedAnimations or {}; _G.__savedAnimations [Hi] = Ei; elseif hi == "M:" then if Hi == "introMusicIndex" then L = tonumber(Ei) or 2; elseif Hi == "bgIndex" then _G._GhostDuel_UI_BgIndex = tonumber(Ei); elseif Hi == "selectedMode" then Ai = Ei == "Normal" or Ei == "Lagger" or Ei == "Desync"; if Ai then _ = Ei; end; elseif Hi == "autoplayMode" then if Ei == "Full" or Ei == "Semi" then _G.__autoplayMode = Ei; end; elseif Hi == "skyIndex" then _G.__savedSkyIndex = tonumber(Ei); elseif Hi == "skyMode" then if Ei == "day" or Ei == "blue" or Ei == "night" then _G.__GhostDuelSkyChangerMode = Ei; end; elseif Hi == "katanaIndex" then _G.__savedKatanaIndex = tonumber(Ei); elseif Hi == "autoStealMode" then if Ei == "v3" then Ei = "v1"; end; ii = Ei == "v1" or Ei == "v2"; if ii then k = Ei; end; elseif Hi == "carrySpeedMode" then local s = Ei == "v1" or Ei == "v2"; if s then n = Ei; end; elseif Hi == "optimizerMode" then if Ei == "Normal" or Ei == "Ultra" then _G.__optimizerMode = Ei; end; elseif Hi == "dropMode" then _G.__GhostDuelDropMode = Ei == "Jump Drop" and "Jump Drop" or "Stand Drop"; elseif Hi == "infJumpMode" then if Ei == "hold" or Ei == "manual" then _G.__GhostDuelInfJumpMode = Ei; end; elseif Hi == "autoGrabExpanded" then _G._GhostDuel_UI_AutoGrabExpanded = Ei == "true"; elseif Hi == "panelVisible" then _G.__GhostDuelPanelVisible = Ei == "true"; E["Toggle UI"] = _G.__GhostDuelPanelVisible; elseif Hi == "themePrimary" then if Ei == "BLACK" or Ei == "WHITE" then _G.__GhostDuelThemePrimary = Ei; end; elseif Hi == "themeSecondary" then if Ei == "BLUE" or Ei == "RED" or Ei == "CONTRAST" then _G.__GhostDuelThemeSecondary = Ei; end; elseif Hi == "buttonsSize" then local s = tonumber(Ei); if s and s == s and math.abs(s) < math.huge then _G.__GhostDuelButtonsSize = math.clamp(s, 0.5, 2); end; elseif Hi == "skinChangerMode" then x = (Ei == "V2" or Ei == "V3") and Ei or "V1"; elseif Hi == "batVersion" then _G.__batVersion = tonumber(Ei) == 2 and 2 or 1; if _G.__batVersionPill then _G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion or 1); end; elseif Hi == "tpBatV2Distance" then _G.__tpBatV2Distance = math.clamp(tonumber(Ei) or 8, 0, 100); elseif Hi == "animationPreset" then _G.__GhostDuelAnimationPreset = Ei; elseif Hi == "guiTheme" then _G.__GhostDuelGuiTheme = "GUI 1"; end; elseif hi == "A:" and P[Hi] ~= nil then local s = tonumber(Ei); if s then P[Hi] = s; end; elseif hi == "C:" then local s, V = Ei:match("([^,]+),([^,]+)"); if s and V then table.insert(I, {name = Hi, boost = tonumber(s) or 59, steal = tonumber(V) or 29}); end; elseif hi == "K:" then if d[Ei] then q[Hi] = Ei; else local s, V = pcall(function() return Enum.KeyCode[Ei]; end); if s then q[Hi] = V; end; end; elseif hi == "P:" then if Hi == "menuPos" then local s, V = Ei:match("(-?%d+),(-?%d+)"); if s and V then _G._GhostDuel_UI_MenuPos = {x = tonumber(s), y = tonumber(V)}; end; elseif Hi == "toggleBtn" then local s, V = Ei:match("(-?%d+),(-?%d+)"); if s and V then _G._GhostDuel_UI_BtnPos = {x = tonumber(s), y = tonumber(V)}; end; elseif Hi == "speedFrame" then local s, V = Ei:match("(-?%d+),(-?%d+)"); if s and V then _G._GhostDuel_UI_SpeedFramePos = {x = tonumber(s), y = tonumber(V)}; end; elseif Hi == "enemyWidget" then local s, V = Ei:match("(-?%d+),(-?%d+)"); if s and V then _G._GhostDuel_UI_EnemyWidgetPos = {x = tonumber(s), y = tonumber(V)}; end; elseif Hi == "autoGrabBar" then local s, V = Ei:match("(-?%d+),(-?%d+)"); if s and V then _G._GhostDuel_UI_AutoGrabBarPos = {x = tonumber(s), y = tonumber(V)}; end; elseif Hi == "autoGrabBarSize" then local s = tonumber(Ei); if s then _G._GhostDuel_UI_AutoGrabBarSize = s; end; elseif Hi == "modernMini" then local s, V = Ei:match("(-?%d+),(-?%d+)"); if s and V then _G._GhostDuel_UI_ModernMiniPos = {x = tonumber(s), y = tonumber(V)}; end; else local s = Hi:match("^quickBtn_(.+)$"); if s then local V, F = Ei:match("^(-?%d+),(-?%d+)"); if V and F then r[s] = {x = tonumber(V), y = tonumber(F)}; end; else local s = Hi:match("^mobileBtn_(.+)$"); if s then local V, F = Ei:match("^(-?%d+),(-?%d+)"); if V and F then _G._GhostDuel_UI_MobileBtnPos = _G._GhostDuel_UI_MobileBtnPos or {}; local L, ii, Qi = {x = tonumber(V), y = tonumber(F)}, Ei:match(":(-?%d+):(-?%d+)$"); if ii and Qi then L.xs = tonumber(ii); L.ys = tonumber(Qi); end; _G._GhostDuel_UI_MobileBtnPos [s] = L; end; end; end; end; end; end; end; end)();
            E["Speed Boost"] = true;
            b = {"Speed Boost", "auto steal", "Auto Carry Speed", "Inf Jump", "Unwalk", "Auto TP Down", "Anti Ragdoll", "Ragdoll Counter", "Medusa Counter", "Anti Die", "Anti Lag", "Optimizer", "ESP Players", "Player Tracers", "Stretchz Res", "Custom FOV", "Sky Changer", "Headless Visual", "Korblox Visual", "Show Buttons", "Lock Buttons", "Skin Changer", "Autoplay"};
            for s, s in ipairs(b) do
                q[s] = nil;
            end;
            mi();
            if type(_G.__GhostDuelPanelVisible) == "boolean" then
                E["Toggle UI"] = _G.__GhostDuelPanelVisible;
            else
                _G.__GhostDuelPanelVisible = E["Toggle UI"] ~= false;
                E["Toggle UI"] = _G.__GhostDuelPanelVisible;
            end;
            if k ~= "v1" and k ~= "v2" then
                k = "v1";
            end;
            _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1;
            _G.__tpBatV2Distance = math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100);
            J = _ == "Lagger";
            O = E["Carry Speed"];
            E["TP Bat"] = false;
            E.Korblox = false;
            pcall(function() local s = m.Character; if not s then return; end; for V, V in ipairs(s:GetChildren()) do if V.Name:find("^SkinChanger_") or V.Name == "Korblox_RightLeg" then V:Destroy(); end; end; local V = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}; for F, L in ipairs(V) do F = s:FindFirstChild(L); if F and(F:IsA("BasePart")) then F.Transparency = 0; F.CanCollide = true; end; end; end);
            E.Autoplay = false;
            E.Lagger = false;
            C = _G._GhostDuel_UI_MobileBtnPos or {};
            _G.__GhostDuelModernGuiActive = true;
            local s = game:GetService("CoreGui");
            b = m.PlayerGui:FindFirstChild("GhostDuel_Panel") or(s:FindFirstChild("GhostDuel_Panel"));
            if b then
                b:Destroy();
            end;
            local V = Instance.new("ScreenGui");
            V.Name = "GhostDuel";
            V.Enabled = false;
            V.ResetOnSpawn = false;
            V.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
            V.DisplayOrder = 9999999;
            V.IgnoreGuiInset = true;
            pcall(function() V.Parent = s; end);
            if not V.Parent then
                V.Parent = m.PlayerGui;
            end;
            local s = workspace.CurrentCamera.ViewportSize;
            GUI_METRICS = {sectionPad = A and 4 or 6, sectionGap = A and 4 or 6, sectionHeaderH = A and 16 or 20, toggleH = A and 44 or 62, compactRowH = A and 30 or 36, compactCardH = A and 28 or 32, toggleTextSize = A and 9 or 10, bindW = A and 34 or 40, bindH = A and 16 or 20, bindTextSize = A and 8 or 9};
            local F, L, C = A and(math.clamp(math.floor(s.X * 0.42), 165, 205)) or(math.min(340, math.floor(s.X * 0.52))), A and(math.clamp(math.floor(s.Y * 0.52), 200, 310)) or(math.min(520, math.floor(s.Y * 0.8))), Instance.new("Frame");
            C.Name = "Panel";
            C.Active = true;
            C.Size = UDim2.new(0, F, 0, L);
            b = _G._GhostDuel_UI_MenuPos;
            if b then
                local ii, Qi = v(C, 0, b.x, 0, b.y);
                C.Position = UDim2.new(0, ii, 0, Qi);
            else
                C.Position = UDim2.new(1,- F - 20, 0.5,- L / 2);
            end;
            C.BackgroundTransparency = 1;
            C.BorderSizePixel = 0;
            C.Visible = false;
            C.Parent = V;
            local ii = Instance.new("Frame");
            ii.Name = "LegacyHeaderStub";
            ii.BackgroundTransparency = 1;
            ii.Visible = false;
            ii.Parent = C;
            T = Instance.new("TextLabel");
            T.BackgroundTransparency = 1;
            T.Visible = false;
            T.Parent = ii;
            l = Instance.new("TextLabel");
            l.BackgroundTransparency = 1;
            l.Visible = false;
            l.Parent = ii;
            local Qi = Instance.new("Frame");
            Qi.Name = "LegacyContentStub";
            Qi.BackgroundTransparency = 1;
            Qi.Visible = false;
            Qi.Parent = C;
            local hi, Ai = {((function() local Hi; pcall(function() Hi = typeof(getcustomasset) == "function" and getcustomasset or typeof(getsynasset) == "function" and getsynasset; end); if not Hi or typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then return "rbxassetid://114056083769059"; end; local Ei = false; pcall(function() Ei = isfile("GhostDuel_42ym9r.jpg"); end); if not Ei then local Ei, si = pcall(function() return game:HttpGet("https://files.catbox.moe/42ym9r.jpg"); end); if not Ei or type(si) ~= "string" or #si < 100 then return "rbxassetid://114056083769059"; end; if not pcall(writefile, "GhostDuel_42ym9r.jpg", si) then return "rbxassetid://114056083769059"; end; end; local Ei, si = pcall(Hi, "GhostDuel_42ym9r.jpg"); if Ei and type(si) == "string" and si ~= "" then return si; end; return "rbxassetid://114056083769059"; end)())}, tonumber(_G._GhostDuel_UI_BgIndex) or 1;
            local Hi, Ei = type(Ai) ~= "number" or Ai < 1;
            if Hi then
                Ei = Hi;
            else
                ii = #hi;
                Ei = Ai > ii;
            end;
            if Ei then
                Ai = 1;
            end;
            local si = Instance.new("ImageLabel");
            si.Name = "LegacyBackgroundStub";
            si.BackgroundTransparency = 1;
            si.Image = hi[Ai];
            si.Visible = false;
            si.Parent = C;
            local bi = Instance.new("TextButton");
            bi.Name = "LegacyBackgroundButtonStub";
            bi.Visible = false;
            bi.Parent = C;
            do
                local Vi, Fi;
                local Ni, Ii = false;
                local function Pi(ki)
                    pcall(function() if _G.__GhostDuelPreserveOptimizerUI (ki) then return; end; local xi, _i = pcall(function() return ki:IsDescendantOf(game:GetService("Lighting")); end); if xi and _i then return; end; if ki:IsA("Sky") or(ki:IsA("Atmosphere")) or(ki:IsA("ColorCorrectionEffect")) or(ki:IsA("BloomEffect")) or(ki:IsA("BlurEffect")) or(ki:IsA("SunRaysEffect")) or(ki:IsA("DepthOfFieldEffect")) then return; end; _i, xi = pcall(function() local Li = ki; while Li and Li ~= workspace do if Li.Name == "Headless_Headless" or(Li.Name:find("^Korblox_")) then return true; end; Li = Li.Parent; end; return false; end); if _i and xi then return; end; if ki:IsA("Accessory") or(ki:IsA("Hat")) then ki:Destroy(); elseif ki:IsA("Shirt") or(ki:IsA("Pants")) or(ki:IsA("ShirtGraphic")) or(ki:IsA("BodyColors")) or(ki:IsA("CharacterMesh")) then ki:Destroy(); elseif ki:IsA("BasePart") then ki.Material = Enum.Material.Plastic; ki.Reflectance = 0; ki.CastShadow = false; elseif ki:IsA("Decal") or(ki:IsA("Texture")) then ki.Transparency = 1; elseif ki:IsA("ParticleEmitter") or(ki:IsA("Trail")) or(ki:IsA("Beam")) or(ki:IsA("Fire")) or(ki:IsA("Smoke")) or(ki:IsA("Sparkles")) then ki.Enabled = false; elseif ki:IsA("AnimationController") or(ki:IsA("Animator")) then _i = ki.Parent; while _i and _i ~= workspace do if _i:IsA("Model") and(K:GetPlayerFromCharacter(_i)) then return; end; _i = _i.Parent; end; for xi, xi in ipairs(ki:GetPlayingAnimationTracks()) do pcall(function() xi:Stop(0); end); end; end; end);
                end;
                local function ki()
                    if Ii then
                        Ii();
                    end;
                    Ii = _G.__GhostDuelWalkDescendantsBatched (workspace, Pi, function() return Ni; end);
                end;
                local function xi()
                    if Ni then
                        return;
                    end;
                    Ni = true;
                    if Vi then
                        Vi:Disconnect();
                    end;
                    Vi = workspace.DescendantAdded:Connect(function(_i) if Ni then Pi(_i); end; end);
                    ki();
                    if Fi then
                        Fi:Disconnect();
                    end;
                    Fi = m.CharacterAdded:Connect(function(ki) task.wait(0.5); if Ni then _G.__GhostDuelWalkDescendantsBatched (ki, Pi, function() return Ni; end); end; end);
                end;
                local function Pi()
                    if not Ni then
                        return;
                    end;
                    Ni = false;
                    if Ii then
                        Ii();
                        Ii = nil;
                    end;
                    if Vi then
                        Vi:Disconnect();
                        Vi = nil;
                    end;
                    if Fi then
                        Fi:Disconnect();
                        Fi = nil;
                    end;
                end;
                _G.__refreshFPSBoost = xi;
                _G.__stopFPSBoost = Pi;
                W["FPS Boost"] = function(Vi)
                    if Vi then
                        xi();
                    else
                        Pi();
                    end;
                end;
            end;
            (function() local Vi, Fi, Ni, Ii, Pi, ki, xi = false, 0, {}, setmetatable({}, {__mode = "k"}), {}, setmetatable({}, {__mode = "k"}), setmetatable({}, {__mode = "k"}); local _i; local function Li(zi, Si, gi) pcall(function() local Oi = zi[Si]; if Oi == gi then return; end; zi[Si] = gi; local gi = Ii[zi]; if not gi then gi = {}; Ii[zi] = gi; end; if not gi[Si] then gi[Si] = {value = Oi}; end; end); end; local function zi(Si) local gi = m.Character; if gi and(Si == gi or(Si:IsDescendantOf(gi))) then return true; end; gi = Si; while gi and gi ~= workspace do if gi:IsA("LayerCollector") or(gi:IsA("GuiObject")) or(gi:IsA("GuiBase2d")) then return true; end; local Oi = gi.Name or ""; if Oi:match("^GhostDuel") or(Oi:match("^__GhostDuel")) or(Oi:match("^GhostDuel")) or(Oi:match("^ESP_")) or(Oi:match("^SkinChanger_")) or(Oi:match("^Korblox_")) or Oi == "Headless_Headless" or Oi == "GreenDuelsBB" or Oi == "PredictionSphere" then return true; end; gi = gi.Parent; end; if E["Sky Changer"] and(Si == Q or(Si:IsDescendantOf(Q))) then return true; end; return false; end; local function Si(gi) if ki[gi] then return; end; local Oi = m.Character; if Oi and(gi:IsDescendantOf(Oi)) then return; end; ki[gi] = true; local Oi = Fi; local ni, Ji = pcall(function() return gi.AnimationPlayed:Connect(function(fi) if not Vi or Fi ~= Oi then return; end; task.defer(function() if Vi and Fi == Oi then pcall(function() fi:Stop(0); end); end; end); end); end); if ni then table.insert(Ni, Ji); end; pcall(function() for Oi, Oi in ipairs(gi:GetPlayingAnimationTracks()) do if Oi.IsPlaying then xi[Oi] = {animator = gi, time = Oi.TimePosition, speed = Oi.Speed}; Oi:Stop(0); end; end; end); end; local function gi(Oi) if not Vi or(zi(Oi)) then return; end; if Oi:IsA("Terrain") then Li(Oi, "Decoration", false); Li(Oi, "WaterWaveSize", 0); Li(Oi, "WaterWaveSpeed", 0); Li(Oi, "WaterReflectance", 0); Li(Oi, "WaterTransparency", 1); end; if Oi:IsA("BasePart") then Li(Oi, "Material", Enum.Material.Plastic); Li(Oi, "MaterialVariant", ""); Li(Oi, "Reflectance", 0); Li(Oi, "CastShadow", false); if Oi:IsA("MeshPart") then Li(Oi, "TextureID", ""); Li(Oi, "RenderFidelity", Enum.RenderFidelity.Performance); Li(Oi, "DoubleSided", false); elseif Oi:IsA("PartOperation") then Li(Oi, "RenderFidelity", Enum.RenderFidelity.Performance); end; elseif Oi:IsA("SpecialMesh") then Li(Oi, "TextureId", ""); elseif Oi:IsA("SurfaceAppearance") then Pi[Oi] = true; Li(Oi, "Parent", nil); elseif Oi:IsA("Decal") or(Oi:IsA("Texture")) then Li(Oi, "Transparency", 1); Li(Oi, "Texture", ""); elseif Oi:IsA("ParticleEmitter") then Li(Oi, "Enabled", false); Li(Oi, "Rate", 0); pcall(function() Oi:Clear(); end); elseif Oi:IsA("Trail") then Li(Oi, "Enabled", false); pcall(function() Oi:Clear(); end); elseif Oi:IsA("Beam") or(Oi:IsA("Fire")) or(Oi:IsA("Smoke")) or(Oi:IsA("Sparkles")) or(Oi:IsA("Light")) or(Oi:IsA("PostEffect")) or(Oi:IsA("Clouds")) then Li(Oi, "Enabled", false); elseif Oi:IsA("Atmosphere") then Li(Oi, "Density", 0); Li(Oi, "Haze", 0); Li(Oi, "Glare", 0); elseif Oi:IsA("Sky") then local zi = {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}; for ni, ni in ipairs(zi) do Li(Oi, ni, ""); end; Li(Oi, "StarCount", 0); Li(Oi, "CelestialBodiesShown", false); elseif Oi:IsA("Shirt") then Li(Oi, "ShirtTemplate", ""); elseif Oi:IsA("Pants") then Li(Oi, "PantsTemplate", ""); elseif Oi:IsA("ShirtGraphic") then Li(Oi, "Graphic", ""); elseif Oi:IsA("Animator") then Si(Oi); end; end; local function zi() if E["Sky Changer"] then return; end; Li(Q, "GlobalShadows", false); Li(Q, "EnvironmentDiffuseScale", 0); Li(Q, "EnvironmentSpecularScale", 0); Li(Q, "FogStart", 0); Li(Q, "FogEnd", 10000000000); end; local function Si() if not Vi then return; end; Vi = false; Fi += 1; if _i then _i (); _i = nil; end; for Oi, Oi in ipairs(Ni) do pcall(function() Oi:Disconnect(); end); end; Ni = {}; for Oi, ni in pairs(Ii) do for Ji, fi in pairs(ni) do pcall(function() Oi[Ji] = fi.value; end); end; end; Ii, Pi = setmetatable({}, {__mode = "k"}), {}; ki = setmetatable({}, {__mode = "k"}); for Ii, Pi in pairs(xi) do pcall(function() if Pi.animator.Parent and not Ii.IsPlaying then Ii:Play(0, 1, Pi.speed); Ii.TimePosition = Pi.time; end; end); end; xi = setmetatable({}, {__mode = "k"}); end; W["Anti Lag"] = function(Ii) if not Ii then Si(); return; end; if Vi then return; end; Vi = true; Fi += 1; local Pi = Fi; zi(); pcall(function() Li(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01); end); pcall(function() Li(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1); end); Ii = {workspace, Q}; for ki, ki in ipairs(Ii) do table.insert(Ni, ki.DescendantAdded:Connect(function(Ii) task.defer(function() if Vi and Fi == Pi then pcall(gi, Ii); end; end); end)); end; table.insert(Ni, Q.Changed:Connect(function(Ni) if Vi and(Ni == "GlobalShadows" or Ni == "EnvironmentDiffuseScale" or Ni == "EnvironmentSpecularScale" or Ni == "FogStart" or Ni == "FogEnd") then zi(); end; end)); if _i then _i (); end; _i = _G.__GhostDuelWalkDescendantsBatched ({workspace, Q}, gi, function() return Vi and Fi == Pi; end); end; _G.__GhostDuelTrackStopper (Si); end)();
            do
                local Vi, Fi, Ni, Ii = 0, 0, 0, 0;
                local function Pi()
                    local ki, xi = pcall(function() return m:GetNetworkPing() * 1000; end);
                    if ki and type(xi) == "number" then
                        return math.floor(xi);
                    end;
                    return 0;
                end;
                local function ki()
                    if T then
                        T.Text = tostring(Vi) .. " FPS";
                    end;
                    if l then
                        l.Text = tostring(Fi) .. " MS";
                    end;
                    if Z then
                        Z.Text = tostring(Vi) .. " FPS";
                    end;
                    if p then
                        p.Text = tostring(Fi) .. " MS";
                    end;
                end;
                Ni, Ii = 0, 0;
                _G.__GhostDuelTrackConn (c.RenderStepped:Connect(function(xi) Ii += 1; Ni += xi; if Ni >= 1 then Vi, Ii, Ni = math.floor(Ii / Ni + 0.5), 0, 0; Fi = Pi(); ki(); end; end));
            end;
            do
                local Vi;
                local Fi, Ni, Ii = false;
                local Pi = _G._GhostDuel_UI_EnemyWidgetPos or {x = 140, y =- 340};
                function _G.__GhostDuelGuiPositionResetters.EnemyWidget()
                    Fi, Pi = false, {x = 140, y =- 340};
                    _G._GhostDuel_UI_EnemyWidgetPos = nil;
                    if Vi and Vi.Parent then
                        Vi.Position = UDim2.fromOffset(Pi.x, Pi.y);
                    end;
                end;
                local ki, xi, _i = 0;
                local Li, zi, Si = false;
                local gi, Oi = "";
                function _G.__GhostDuelGetVisualEnemy ()
                    if xi and xi.Parent == K then
                        return xi;
                    end;
                    return nil;
                end;
                local function ni()
                    if Vi and Vi.Parent then
                        return Vi;
                    end;
                    Vi = Instance.new("Frame", V);
                    Vi.Name = "GhostDuelEnemyWidget";
                    Vi.Size = UDim2.new(0, 140, 0, 80);
                    Vi.Position = UDim2.new(0, Pi.x, 0, Pi.y);
                    _G.__enemyWidget = Vi;
                    _G.__GhostDuelRegisterThemeRoot (Vi);
                    Vi.BackgroundTransparency = 0.15;
                    Vi.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
                    Vi.ZIndex = 600;
                    Vi.Visible = false;
                    Instance.new("UICorner", Vi).CornerRadius = UDim.new(0, 8);
                    local Ji = Instance.new("UIStroke", Vi);
                    Ji.Color = Color3.fromRGB(0, 0, 0);
                    Ji.Thickness = 1;
                    Ji = Instance.new("TextLabel", Vi);
                    Ji.Name = "EWTitle";
                    Ji.Size = UDim2.new(1,- 10, 0, 14);
                    Ji.Position = UDim2.new(0, 8, 0, 4);
                    Ji.BackgroundTransparency = 1;
                    Ji.Text = "RIVAL";
                    Ji.Font = Enum.Font.GothamBold;
                    Ji.TextSize = 10;
                    Ji.TextColor3 = Color3.fromRGB(180, 180, 180);
                    Ji.TextXAlignment = Enum.TextXAlignment.Left;
                    Ji.ZIndex = 601;
                    Ji = Instance.new("ImageLabel", Vi);
                    Ji.Name = "EWAvatar";
                    Ji.Size = UDim2.new(0, 44, 0, 44);
                    Ji.Position = UDim2.new(0, 6, 0, 20);
                    Ji.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
                    Ji.BorderSizePixel = 0;
                    Ji.Image = "";
                    Ji.ZIndex = 601;
                    Instance.new("UICorner", Ji).CornerRadius = UDim.new(0, 6);
                    local fi = Instance.new("UIStroke", Ji);
                    fi.Color = Color3.fromRGB(180, 180, 180);
                    fi.Thickness = 1;
                    fi = Instance.new("TextLabel", Vi);
                    fi.Name = "EWName";
                    fi.Size = UDim2.new(1,- 60, 0, 18);
                    fi.Position = UDim2.new(0, 56, 0, 22);
                    fi.BackgroundTransparency = 1;
                    fi.Text = "---";
                    fi.Font = Enum.Font.GothamBold;
                    fi.TextSize = 13;
                    fi.TextColor3 = Color3.fromRGB(180, 180, 180);
                    fi.TextXAlignment = Enum.TextXAlignment.Left;
                    fi.TextScaled = false;
                    fi = Instance.new("TextLabel", Vi);
                    fi.Name = "EWTimer";
                    fi.Size = UDim2.new(1,- 60, 0, 20);
                    fi.Position = UDim2.new(0, 56, 0, 44);
                    fi.BackgroundTransparency = 1;
                    fi.Text = "";
                    fi.Font = Enum.Font.GothamBlack;
                    fi.TextSize = 16;
                    fi.TextColor3 = Color3.fromRGB(255, 221, 0);
                    fi.TextXAlignment = Enum.TextXAlignment.Left;
                    fi.ZIndex = 601;
                    Vi.InputBegan:Connect(function(Ji) if Ji.UserInputType == Enum.UserInputType.MouseButton1 or Ji.UserInputType == Enum.UserInputType.Touch then Fi = true; Ni = Ji.Position; Ii = Vi.Position; Ji.Changed:Connect(function() if Ji.UserInputState == Enum.UserInputState.End then Fi = false; Pi.x = Vi.Position.X.Offset; Pi.y = Vi.Position.Y.Offset; _G._GhostDuel_UI_EnemyWidgetPos = {x = Pi.x, y = Pi.y}; mi(); end; end); end; end);
                    _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(Ji) if not Fi then return; end; if Ji.UserInputType ~= Enum.UserInputType.MouseMovement and Ji.UserInputType ~= Enum.UserInputType.Touch then return; end; local Fi, fi = Ji.Position - Ni, workspace.CurrentCamera.ViewportSize; local Ni, Ji = math.clamp(Ii.X.Offset + Fi.X, 0, fi.X - Vi.AbsoluteSize.X), math.clamp(Ii.Y.Offset + Fi.Y, 0, fi.Y - Vi.AbsoluteSize.Y); Vi.Position = UDim2.new(0, Ni, 0, Ji); end));
                    return Vi;
                end;
                local function Fi(Ni)
                    local Ii = ni():FindFirstChild("EWAvatar");
                    if not Ii then
                        return;
                    end;
                    Ii.Image = "";
                    task.spawn(function() local Ji, fi = pcall(function() return K:GetUserThumbnailAsync(Ni, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48); end); if Ji and fi and Ii and Ii.Parent then Ii.Image = fi; end; end);
                end;
                local function Ni(Ii)
                    if Ii and xi and Ii.UserId == _i then
                        return;
                    end;
                    if not Ii and not xi then
                        return;
                    end;
                    xi, Li, Si = Ii, false, nil;
                    local Ji = ni();
                    local fi = Ji:FindFirstChild("EWName");
                    zi = Ji:FindFirstChild("EWTimer");
                    if Ii then
                        _i = Ii.UserId;
                        if fi then
                            fi.Text = Ii.Name;
                        end;
                        if zi then
                            zi.Text = "";
                            gi = "";
                        end;
                        Fi(Ii.UserId);
                        Ji.Visible = true;
                        Oi = true;
                    else
                        _i = nil;
                        if fi then
                            fi.Text = "---";
                        end;
                        if zi then
                            zi.Text = "";
                            gi = "";
                        end;
                        local Fi = Ji:FindFirstChild("EWAvatar");
                        if Fi then
                            Fi.Image = "";
                        end;
                        Ji.Visible = false;
                        Oi = false;
                    end;
                end;
                local function Fi(Ii)
                    local _i = ki;
                    if _i > 0 then
                        ki = math.max(0, ki - Ii);
                    end;
                    Ii = zi;
                    if not Ii or not Ii.Parent then
                        return;
                    end;
                    if ki > 0 then
                        _i = string.format("%.1fs", ki);
                        if _i ~= gi then
                            Ii.Text = _i;
                            Ii.TextColor3 = Color3.fromRGB(255, 221, 0);
                            gi = _i;
                        end;
                    elseif gi ~= "" then
                        Ii.Text = "";
                        gi = "";
                    end;
                end;
                local Ii, _i, zi = 0, A and 0.5 or 0.25, 0;
                _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function(gi) zi += gi or 0; if xi and zi >= 0.2 then Fi(zi); zi = 0; else gi = not xi and zi >= 0.2; if gi then zi = 0; end; end; gi = os.clock(); if gi - Ii < _i then return; end; Ii = gi; gi = m.Character; local Fi = gi and(gi:FindFirstChild("HumanoidRootPart")); if not Fi then return; end; local Ii, _i, zi = Fi.Position, math.huge; for Ji, fi in ipairs(K:GetPlayers()) do gi = fi ~= m and fi.Character; if gi then Fi = gi:FindFirstChild("HumanoidRootPart"); if Fi then Ji = Fi.Position; local oi, qi, Bi = Ii.X - Ji.X, Ii.Y - Ji.Y, Ii.Z - Ji.Z; local Ji = oi * oi + qi * qi + Bi * Bi; if Ji < _i then _i, zi = Ji, fi; end; end; end; end; if zi ~= xi then Ni(zi); end; Fi = Vi; if Fi and Fi.Parent then Ii = zi ~= nil; if Ii ~= Oi then Fi.Visible = Ii; Oi = Ii; end; end; if xi then _i = Fi and(Fi:FindFirstChild("EWName")); if _i then if xi:GetAttribute("Stealing") == true then _i.TextColor3 = Color3.fromRGB(255, 60, 60); else _i.TextColor3 = Color3.fromRGB(180, 180, 180); end; end; end; if xi and xi.Character then Fi = not Si or not Si.Parent; if Fi then Si = xi.Character:FindFirstChildOfClass("Humanoid"); end; if Si then zi = Si:GetState(); Ii = zi == Enum.HumanoidStateType.Physics or zi == Enum.HumanoidStateType.Ragdoll or zi == Enum.HumanoidStateType.FallingDown; _i = Ii and not Li; if _i then ki = 3; else gi = Ii and ki < 0.5; if gi then ki = 0.5; end; end; Li = Ii; end; end; end));
                function _G._GhostDuel_EnemyWidget_SaveHook ()
                    if Vi and Vi.Parent then
                        Pi.x = Vi.Position.X.Offset;
                        Pi.y = Vi.Position.Y.Offset;
                        _G._GhostDuel_UI_EnemyWidgetPos = {x = Pi.x, y = Pi.y};
                    end;
                end;
                ni();
            end;
            local function Vi(Fi, Ni)
                local Ii = Instance.new("Frame");
                Ii.Name = (Ni and(tostring(Ni)) or "Section") .. "SectionStub";
                Ii.BackgroundTransparency = 1;
                Ii.Visible = false;
                Ii.Parent = Fi;
                return Ii;
            end;
            local function Fi(Ni, Ii, Pi, ki)
                local xi = Instance.new("Frame");
                xi.Name = tostring(Pi or Ii or "Toggle") .. "Stub";
                xi.BackgroundTransparency = 1;
                xi.Visible = false;
                xi.Parent = Ni;
                if ki then
                    Ni = Instance.new("TextButton");
                    Ni.Text = "";
                    Ni.Parent = xi;
                    Ii = Instance.new("Frame");
                    Ii.BackgroundTransparency = 1;
                    Ii.Parent = xi;
                    ki(Ii);
                end;
                return xi;
            end;
            local function Ni(Ii, Pi, ki)
                local xi = Instance.new("Frame");
                xi.Name = tostring(ki or Pi or "Toggle") .. "Stub";
                xi.BackgroundTransparency = 1;
                xi.Visible = false;
                xi.Parent = Ii;
                return xi;
            end;
            local function Ii(Pi)
                E["Speed Boost"] = true;
                if _G.__refreshSpeedBoost then
                    pcall(_G.__refreshSpeedBoost);
                end;
                if _ == Pi then
                    if n == "v2" then
                        O = not O;
                        E["Carry Speed"] = O;
                        if U["Carry Speed"] then
                            U["Carry Speed"]();
                        end;
                        pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end);
                        mi();
                    end;
                    return;
                end;
                if _G.__GhostDuelResetSpeedDirection then
                    pcall(_G.__GhostDuelResetSpeedDirection);
                end;
                _, J = Pi, if Pi == "Lagger" then
                    true
                else
                    false;
                    for Pi, Pi in ipairs(_speedCardRefs) do
                        if Pi.updateVisual then
                            pcall(Pi.updateVisual);
                        end;
                    end;
                    mi();
                    pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end);
                end;
                FeatureToggles = FeatureToggles or {};
                function FeatureToggles.SelectNormalMode()
                    Ii("Normal");
                end;
                function FeatureToggles.SelectLaggerMode()
                    Ii("Lagger");
                end;
                function FeatureToggles.SelectDesyncMode()
                    Ii("Desync");
                end;
                FeatureToggles["Toggle UI"] = function()
                    if _G.__setPanelVisible then
                        _G.__setPanelVisible (not C.Visible);
                    else
                        panelVisible = not C.Visible;
                        C.Visible = panelVisible;
                        E["Toggle UI"] = panelVisible;
                    end;
                    if U["Toggle UI"] then
                        U["Toggle UI"]();
                    end;
                    mi();
                end;
                local function Pi()
                    if _ == "Lagger" or J then
                        return N.LaggerBoost or g;
                    elseif _ == "Desync" then
                        return N.DesyncBoost or z;
                    end;
                    for ki, ki in ipairs(I) do
                        if _ == ki.name then
                            return ki.boost;
                        end;
                    end;
                    return N.NormalBoost or z;
                end;
                local ki = {Enabled = false, Connection = nil, ResetCooldown = 0};
                local function xi()
                    if ki.Connection then
                        return;
                    end;
                    ki.Enabled = true;
                    ki.Connection = c.Heartbeat:Connect(function() if not E["Anti Ragdoll"] then return; end; local _i = m.Character; if not _i then return; end; local Li, zi = _i:FindFirstChildOfClass("Humanoid"), _i:FindFirstChild("HumanoidRootPart"); if not Li or not zi or Li.Health <= 0 then return; end; if _G.dropActive then return; end; local Si, gi = Li:GetState(), tick(); if Si == Enum.HumanoidStateType.Physics or Si == Enum.HumanoidStateType.Ragdoll or Si == Enum.HumanoidStateType.FallingDown then if gi - ki.ResetCooldown > 0.15 then ki.ResetCooldown = gi; pcall(function() Li:ChangeState(Enum.HumanoidStateType.GettingUp); zi.Velocity = Vector3.zero; zi.RotVelocity = Vector3.zero; zi.AssemblyLinearVelocity = Vector3.zero; zi.AssemblyAngularVelocity = Vector3.zero; for zi, zi in ipairs(_i:GetDescendants()) do if zi:IsA("Motor6D") then zi.Enabled = true; end; if zi:IsA("Constraint") then zi.Enabled = true; end; end; workspace.CurrentCamera.CameraSubject = Li; local _i = m.PlayerScripts:FindFirstChild("PlayerModule"); if _i then local zi = require(_i:FindFirstChild("ControlModule")); if zi then zi:Enable(); end; end; Li.AutoRotate = true; Li.PlatformStand = false; Li.Sit = false; end); end; end; end);
                end;
                local function _i ()
                    ki.Enabled = false;
                    if ki.Connection then
                        ki.Connection:Disconnect();
                        ki.Connection = nil;
                    end;
                end;
                _G.__GhostDuelTrackStopper (_i);
                W["Anti Ragdoll"] = function(Li)
                    if Li then
                        xi();
                    else
                        _i ();
                    end;
                end;
                _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(_i) task.wait(0.5); if E["Anti Ragdoll"] then if ki.Connection then ki.Connection:Disconnect(); ki.Connection = nil; end; xi(); end; end));
                if E["Anti Ragdoll"] then
                    xi();
                end;
                do
                    local ki = {Connection = nil, RagdollConnection = nil};
                    local function xi()
                        if ki.Connection then
                            ki.Connection:Disconnect();
                            ki.Connection = nil;
                        end;
                        if ki.RagdollConnection then
                            ki.RagdollConnection:Disconnect();
                            ki.RagdollConnection = nil;
                        end;
                    end;
                    local function _i ()
                        local Li = m.Character;
                        local zi = Li and(Li:FindFirstChild("HumanoidRootPart"));
                        if not zi then
                            return;
                        end;
                        if ki.Connection then
                            ki.Connection:Disconnect();
                        end;
                        ki.Connection = c.Heartbeat:Connect(function() if not E["Anti Bat"] or not zi.Parent then return; end; local Li = Vector3.new(zi.Velocity.X, 0, zi.Velocity.Z); zi.Velocity = Vector3.new(1000, zi.Velocity.Y, 1000); c.RenderStepped:Wait(); if zi.Parent then zi.Velocity = Vector3.new(Li.X, zi.Velocity.Y, Li.Z); end; end);
                    end;
                    local function Li()
                        if ki.RagdollConnection then
                            return;
                        end;
                        ki.RagdollConnection = c.Heartbeat:Connect(function() if not E["Anti Bat"] then return; end; local ki = m.Character; if not ki then return; end; local zi, Si = ki:FindFirstChildOfClass("Humanoid"), ki:FindFirstChild("HumanoidRootPart"); if zi then local gi = zi:GetState(); if gi == Enum.HumanoidStateType.Physics or gi == Enum.HumanoidStateType.Ragdoll or gi == Enum.HumanoidStateType.FallingDown then zi:ChangeState(Enum.HumanoidStateType.Running); workspace.CurrentCamera.CameraSubject = zi; pcall(function() local zi = m.PlayerScripts:FindFirstChild("PlayerModule"); if zi then require(zi:FindFirstChild("ControlModule")):Enable(); end; end); if Si then Si.Velocity = Vector3.new(0, 0, 0); Si.RotVelocity = Vector3.new(0, 0, 0); end; end; end; for zi, zi in ipairs(ki:GetDescendants()) do if zi:IsA("Motor6D") and not zi.Enabled then zi.Enabled = true; end; end; end);
                    end;
                    local function ki()
                        xi();
                        _i ();
                        Li();
                    end;
                    _G.__GhostDuelTrackStopper (xi);
                    W["Anti Bat"] = function(_i)
                        if _i then
                            ki();
                        else
                            xi();
                        end;
                    end;
                    _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() task.wait(0.3); if E["Anti Bat"] then ki(); end; end));
                    if E["Anti Bat"] then
                        ki();
                    end;
                end;
                local function ki()
                    if _ == "Lagger" or J then
                        return N.LaggerSteal or S;
                    elseif _ == "Desync" then
                        return N.DesyncSteal or S;
                    end;
                    for J, J in ipairs(I) do
                        if _ == J.name then
                            return J.steal;
                        end;
                    end;
                    return N.NormalSteal or S;
                end;
                local function J(xi)
                    return O or xi and E["Auto Carry Speed"];
                end;
                do
                    ii = _G.__GhostDuelSpeedSpoofState;
                    if type(ii) == "table" then
                        ii.enabled = false;
                    end;
                    local xi = _G.__GhostDuelS2SpeedState;
                    if type(xi) ~= "table" then
                        xi = {hooked = false};
                        _G.__GhostDuelS2SpeedState = xi;
                    end;
                    xi.enabled = false;
                    xi.root = nil;
                    xi.velChecked = setmetatable({}, {__mode = "k"});
                    local function _i (Li)
                        xi.velChecked = setmetatable({}, {__mode = "k"});
                        if not Li then
                            xi.root = nil;
                            return nil;
                        end;
                        local zi = Li:WaitForChild("HumanoidRootPart", 5);
                        if zi then
                            xi.root = zi;
                            xi.velChecked[zi] = true;
                        end;
                        return zi;
                    end;
                    local function Li(zi)
                        if not zi then
                            return;
                        end;
                        xi.root = zi;
                        xi.velChecked[zi] = true;
                        if xi.hooked then
                            return;
                        end;
                        if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
                            return;
                        end;
                        pcall(function() local zi = getrawmetatable(game); if not zi then return; end; local Si = rawget(zi, "__index"); if type(Si) ~= "function" and type(Si) ~= "table" then return; end; local gi = newcclosure(function(Oi, ni) local Ji = if type(Si) == "function" then(Si(Oi, ni)) else Si[ni]; if not checkcaller() and xi.velChecked[Oi] and(ni == "AssemblyLinearVelocity" or ni == "Velocity") and typeof(Ji) == "Vector3" and Ji.Magnitude > 20 then return Ji.Unit * 20; end; return Ji; end); setreadonly(zi, false); zi.__index = gi; xi.hooked = true; setreadonly(zi, true); end);
                    end;
                    local function zi()
                        f = Vector3.zero;
                        xi.enabled = false;
                    end;
                    function _G.__GhostDuelResetSpeedDirection ()
                        f = Vector3.zero;
                        local Si = m.Character;
                        local gi, Oi = Si and(Si:FindFirstChildOfClass("Humanoid")), Si and(Si:FindFirstChild("HumanoidRootPart"));
                        if gi and Oi and gi.MoveDirection.Magnitude <= 0.05 then
                            Oi.AssemblyLinearVelocity = Vector3.new(0, Oi.AssemblyLinearVelocity.Y, 0);
                        end;
                    end;
                    local function Si(gi)
                        if not gi then
                            return true;
                        end;
                        local Oi = gi:GetState();
                        return gi.PlatformStand or Oi == Enum.HumanoidStateType.Physics or Oi == Enum.HumanoidStateType.Ragdoll or Oi == Enum.HumanoidStateType.FallingDown;
                    end;
                    local function gi(Oi)
                        if J(Oi) then
                            return ki();
                        end;
                        return Pi();
                    end;
                    local function J()
                        if _G.__speedBoostConn then
                            _G.__speedBoostConn:Disconnect();
                            _G.__speedBoostConn = nil;
                        end;
                        zi();
                    end;
                    local function Oi(ni, Ji)
                        local fi = m.Character;
                        local oi, qi = fi and(fi:FindFirstChildOfClass("Humanoid")), fi and(fi:FindFirstChild("HumanoidRootPart"));
                        if not oi or not qi or oi.Health <= 0 then
                            return;
                        end;
                        if type(Ji) ~= "number" or Ji ~= Ji or Ji <= 0 or Ji == math.huge then
                            return;
                        end;
                        oi = qi.AssemblyLinearVelocity.Y;
                        if _G._ZurichHub_MovementBlocked == true or _G._GhostDuel_MovementBlocked == true then
                            qi.AssemblyLinearVelocity = Vector3.new(0, math.min(oi, 0), 0);
                            return;
                        end;
                        if ni and ni.Magnitude > 0.05 then
                            pcall(function() if qi.SetNetworkOwner then qi:SetNetworkOwner(m); end; end);
                            fi = ni.Unit;
                            qi.AssemblyLinearVelocity = Vector3.new(fi.X * Ji, oi, fi.Z * Ji);
                        else
                            qi.AssemblyLinearVelocity = Vector3.new(0, oi, 0);
                        end;
                    end;
                    local function ni()
                        J();
                        _G.__speedBoostConn = c.RenderStepped:Connect(function() if not E["Speed Boost"] then return; end; local Ji = m.Character; local fi, oi = Ji and(Ji:FindFirstChildOfClass("Humanoid")), Ji and(Ji:FindFirstChild("HumanoidRootPart")); if not fi or not oi or fi.Health <= 0 then return; end; if E.Autoplay or E["TP Bat"] or E.Aimbot or E["Lagger Aimbot"] or _G.dropActive or _G.IsDropping then zi(); return; end; if Si(fi) then f = Vector3.zero; return; end; if xi.root ~= oi or not xi.velChecked[oi] then f = Vector3.zero; _i (Ji); Li(oi); end; xi.enabled = true; oi = nil; if fi.MoveDirection.Magnitude > 0 then f = fi.MoveDirection; oi = fi.MoveDirection; elseif f.Magnitude > 0 then for Ji in pairs(o) do if R:IsKeyDown(Ji) then oi = f; break; end; end; end; Oi(oi, tonumber((gi(m:GetAttribute("Stealing") == true))) or 16); end);
                    end;
                    local function f()
                        if not E["Speed Boost"] then
                            return;
                        end;
                        local o = m.Character;
                        local Ji = o and(o:FindFirstChildOfClass("Humanoid"));
                        if not Ji or Ji.Health <= 0 or(Si(Ji)) then
                            return;
                        end;
                        Oi(Ji.MoveDirection.Magnitude > 0.05 and Ji.MoveDirection or nil, gi(m:GetAttribute("Stealing") == true));
                    end;
                    local function o()
                        E["Speed Boost"] = true;
                        ni();
                    end;
                    _G.__refreshSpeedBoost = o;
                    _G.__stopSpeedBoost = J;
                    _G.__GhostDuelTrackStopper (function() E["Speed Boost"] = false; J(); xi.root = nil; _G.__GhostDuelResetSpeedDirection = nil; end);
                    if m.Character then
                        Li((_i (m.Character)));
                    end;
                    if E["Speed Boost"] then
                        ni();
                    end;
                    _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(Si) task.wait(0.5); zi(); local zi = Si:WaitForChild("HumanoidRootPart", 5); if zi then _i (Si); Li(zi); end; if E["Speed Boost"] then ni(); end; end));
                    _G.__GhostDuelTrackConn (m.CharacterRemoving:Connect(function() J(); xi.root = nil; xi.velChecked = setmetatable({}, {__mode = "k"}); end));
                    FeatureToggles["Speed Boost"] = nil;
                    W["Speed Boost"] = function()
                        E["Speed Boost"] = true;
                        ni();
                    end;
                    FeatureToggles["Carry Speed"] = function()
                        E["Carry Speed"] = not E["Carry Speed"];
                        O = E["Carry Speed"];
                        E["Speed Boost"] = true;
                        ni();
                        f();
                        if U["Carry Speed"] then
                            U["Carry Speed"]();
                        end;
                        pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end);
                        mi();
                    end;
                    W["Carry Speed"] = function(J)
                        O = J;
                        if J or n == "v2" then
                            E["Speed Boost"] = true;
                            ni();
                            f();
                        end;
                        pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end);
                    end;
                    W["Auto Carry Speed"] = function(J)
                        E["Speed Boost"] = true;
                        if not _G.__speedBoostConn then
                            ni();
                        end;
                        pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end);
                    end;
                    local J, f, xi, _i = {}, setmetatable({}, {__mode = "k"}), ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 22, 48)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 215, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 22, 48))}), ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 22, 48)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 215, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 22, 48))});
                    local function Li(zi)
                        if _G.__GhostDuelGuiTheme == "GUI 3" then
                            return ColorSequence.new(Color3.fromRGB(7, 22, 48), Color3.fromRGB(125, 215, 255));
                        end;
                        if zi then
                            return _G.__GhostDuelGuiTheme == "GUI 2" and _i or xi;
                        end;
                        return ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 22, 48)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 215, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 22, 48))});
                    end;
                    local xi;
                    local function _i (zi)
                        local Si = zi.Character;
                        if not Si then
                            return "0";
                        end;
                        local Oi = Si:FindFirstChild("HumanoidRootPart");
                        if not Oi then
                            return "0";
                        end;
                        local ni = Oi.AssemblyLinearVelocity;
                        Oi = Vector3.new(ni.X, 0, ni.Z).Magnitude;
                        ni = Oi < 0.5 and 0 or(math.floor(Oi + 0.5));
                        if zi == m then
                            Oi = m:GetAttribute("Stealing") == true;
                            local zi, Ji = O or Oi and E["Auto Carry Speed"], Si:FindFirstChildOfClass("Humanoid");
                            return tostring(if E["Speed Boost"] and Ji and Ji.MoveDirection.Magnitude > 0.05 then(math.floor(gi(Oi) + 0.5)) else ni) .. " - " .. (zi and "CARRY" or "NORMAL");
                        end;
                        return tostring(ni);
                    end;
                    local function zi(Si, gi)
                        if not Si or not Si.Parent then
                            return;
                        end;
                        if J[Si] then
                            return;
                        end;
                        J[Si] = true;
                        task.spawn(function() xi(Si, gi); J[Si] = nil; end);
                    end;
                    xi = function(J, xi)
                        task.wait(0.3);
                        local Si = J:FindFirstChild("Head");
                        if not Si then
                            return;
                        end;
                        local gi = Si:FindFirstChild("GreenDuelsBB");
                        if gi then
                            gi:Destroy();
                        end;
                        gi = Si:FindFirstChild("GhostDuelSpeedBill");
                        if gi then
                            gi:Destroy();
                        end;
                        gi = Si:FindFirstChild("GhostDuelOverhead");
                        if gi then
                            gi:Destroy();
                        end;
                        gi = J:FindFirstChild("UpperTorso") or(J:FindFirstChild("HumanoidRootPart"));
                        if gi then
                            local Oi = gi:FindFirstChild("GreenDuelsBB");
                            if Oi then
                                Oi:Destroy();
                            end;
                        end;
                        gi = Instance.new("BillboardGui", Si);
                        gi.Name = "GreenDuelsBB";
                        gi:SetAttribute("GhostDuelThemeWorldAccent", true);
                        gi.Size = xi and(UDim2.fromOffset(190, 60)) or(UDim2.fromOffset(130, 42));
                        gi.StudsOffset = xi and(Vector3.new(0, 1.8, 0)) or(Vector3.new(0, 1.65, 0));
                        gi.AlwaysOnTop = true;
                        gi.LightInfluence = 0;
                        gi.MaxDistance = 0;
                        local function Oi(ni, Ji)
                            ni.Font = Enum.Font.GothamBlack;
                            ni.TextStrokeTransparency = 0;
                            if Ji then
                                ni.TextColor3 = Color3.fromRGB(125, 215, 255);
                                local Ji = Instance.new("UIStroke", ni);
                                Ji.Color = Color3.fromRGB(0, 0, 0);
                                Ji.Thickness = 1.75;
                                Ji.Transparency = 0.2;
                                Ji = Instance.new("UIGradient");
                                Ji.Name = "SpeedTextGradient";
                                Ji.Color = Li(true);
                                Ji.Parent = ni;
                            else
                                ni.TextColor3 = Color3.fromRGB(125, 215, 255);
                                local Ji = Instance.new("UIStroke", ni);
                                Ji.Color = Color3.fromRGB(0, 0, 0);
                                Ji.Thickness = 2.25;
                                Ji.Transparency = 0.1;
                                Ji = Instance.new("UIGradient");
                                Ji.Name = "SpeedTextGradient";
                                Ji.Color = Li(false);
                                Ji.Parent = ni;
                            end;
                        end;
                        Si = Instance.new("TextLabel", gi);
                        Si.Size = UDim2.new(1, 0, 0, xi and 28 or 22);
                        Si.Position = UDim2.new(0, 0, 0, 0);
                        Si.BackgroundTransparency = 1;
                        Si.Text = xi and ".gg/GhostDuel" or "";
                        Si.Visible = xi;
                        Si.TextScaled = false;
                        Si.TextSize = xi and 19 or 15;
                        Oi(Si, xi);
                        Si = Instance.new("TextLabel", gi);
                        Si.Name = "SpeedBillLbl";
                        Si.Size = UDim2.new(1, 0, 0, xi and 29 or 20);
                        Si.Position = UDim2.new(0, 0, 0, xi and 30 or 22);
                        Si.BackgroundTransparency = 1;
                        local ni = K:GetPlayerFromCharacter(J);
                        Si.Text = ni and(_i (ni)) or "0";
                        if ni then
                            f[ni] = Si;
                        end;
                        Si.TextScaled = false;
                        Si.TextSize = xi and 22 or 16;
                        Oi(Si, xi);
                        _G.__GhostDuelRegisterThemeRoot (gi);
                    end;
                    local function J(xi)
                        if xi.Character then
                            zi(xi.Character, xi == m);
                        end;
                        _G.__GhostDuelTrackConn (xi.CharacterAdded:Connect(function(Si) zi(Si, xi == m); end));
                    end;
                    for xi, xi in ipairs(K:GetPlayers()) do
                        if xi ~= m then
                            J(xi);
                        end;
                    end;
                    _G.__GhostDuelTrackConn (K.PlayerAdded:Connect(function(xi) J(xi); end));
                    if m.Character then
                        zi(m.Character, true);
                    end;
                    _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(J) O = E["Carry Speed"] == true; task.spawn(function() zi(J, true); pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end); end); end));
                    local J, xi, Si = 0, A and 0.5 or 0.25, {};
                    _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function(gi) J += gi or 0; if J < xi then return; end; J = 0; for J, xi in ipairs(K:GetPlayers()) do gi = xi.Character; if gi then J = f[xi]; if not J or not J.Parent then f[xi] = nil; zi(gi, xi == m); else local zi = _i (xi); if Si[xi.UserId] ~= zi then J.Text = zi; Si[xi.UserId] = zi; end; end; end; end; end));
                    function _G.__refreshSpeedBillboards ()
                        for J, xi in ipairs(K:GetPlayers()) do
                            J = xi.Character;
                            if not J then
                                continue;
                            end;
                            local zi, Si = J:FindFirstChild("HumanoidRootPart") or(J:FindFirstChild("UpperTorso")), J:FindFirstChild("Head");
                            local gi = J:FindFirstChild("UpperTorso") or zi;
                            if not zi and not Si then
                                continue;
                            end;
                            J = Si and(Si:FindFirstChild("GreenDuelsBB")) or gi and(gi:FindFirstChild("GreenDuelsBB"));
                            if not J then
                                continue;
                            end;
                            zi = J:FindFirstChild("SpeedBillLbl");
                            if not zi then
                                continue;
                            end;
                            f[xi] = zi;
                            zi.Text = _i (xi);
                            Si = Li(xi == m);
                            for f, f in ipairs(J:GetChildren()) do
                                if f:IsA("TextLabel") then
                                    xi = f:FindFirstChild("SpeedTextGradient");
                                    if xi then
                                        xi.Color = Si;
                                    end;
                                end;
                            end;
                        end;
                    end;
                    o();
                    local J, f = {Vector3.new(- 475.86,- 7, 91.97), Vector3.new(- 485.83,- 7, 97.37), Vector3.new(- 475.86,- 7, 91.97), Vector3.new(- 476.35,- 7, 27.88), Vector3.new(- 477.09,- 7, 19.85)}, {Vector3.new(- 475.84,- 7, 28.81), Vector3.new(- 486.04,- 7, 23.32), Vector3.new(- 475.51,- 7, 29.01), Vector3.new(- 476.43,- 7, 91.61), Vector3.new(- 476.27,- 7, 98.86)};
                    _G.__autoLeftWaypoints = J;
                    _G.__autoRightWaypoints = f;
                    local o, xi, _i, Li, zi = false, "none", 1, false;
                    _G.__autoplayMode = _G.__autoplayMode or "Full";
                    local function Si()
                        local gi = workspace:FindFirstChild("Plots");
                        if not gi then
                            return "left";
                        end;
                        for Oi, ni in ipairs(gi:GetChildren()) do
                            Oi = ni:FindFirstChild("PlotSign");
                            local gi = Oi and(Oi:FindFirstChild("YourBase"));
                            if gi and gi.Enabled then
                                Oi = ni:FindFirstChild("AnimalTarget", true);
                                local gi = Oi and Oi.Position;
                                if not gi then
                                    local Oi = ni:FindFirstChild("DeliveryHitbox");
                                    gi = Oi and Oi.Position;
                                end;
                                if gi then
                                    if type(J) == "table" and type(f) == "table" and J[1] and f[1] then
                                        return(gi - J[1]).Magnitude <= (gi - f[1]).Magnitude and "right" or "left";
                                    end;
                                end;
                                do
                                    local gi;
                                    if typeof(ni.GetPivot) == "function" then
                                        pcall(function() local Oi = ni:GetPivot(); if Oi then gi = Oi.Position; end; end);
                                    end;
                                    if gi then
                                        return gi.Z >= 60 and "right" or "left";
                                    else
                                        return m and m.Character and(m.Character:FindFirstChild("HumanoidRootPart")) and m.Character:FindFirstChild("HumanoidRootPart").Position.Z >= 60 and "right" or "left";
                                    end;
                                end;
                            end;
                        end;
                        return "left";
                    end;
                    (function() if _G.__ZurichSetFullNoPlayerCollision then pcall(_G.__ZurichSetFullNoPlayerCollision, false); end; local gi, Oi, ni, Ji = false, false, {}, setmetatable({}, {__mode = "k"}); local function fi() return E["TP Bat"] == true; end; local function oi(qi) if not qi:IsA("BasePart") then return; end; if Ji[qi] == nil then Ji[qi] = {CanCollide = qi.CanCollide, CanTouch = qi.CanTouch}; end; if qi.CanCollide then qi.CanCollide = false; end; if qi.CanTouch then qi.CanTouch = false; end; end; local function qi(Bi) if not Bi then return; end; for ji, ji in ipairs(Bi:GetDescendants()) do oi(ji); end; end; local function Bi(ji) if fi() then return; end; qi(ji); table.insert(ni, ji.DescendantAdded:Connect(function(ji) if gi and not Oi and not fi() then oi(ji); end; end)); end; local function oi(ji) if ji == m then return; end; if ji.Character then Bi(ji.Character); end; table.insert(ni, ji.CharacterAdded:Connect(function(ji) if gi and not Oi and not fi() then Bi(ji); end; end)); end; local function Bi() for ji, wi in pairs(Ji) do if ji and ji.Parent then pcall(function() ji.CanCollide = wi.CanCollide; ji.CanTouch = wi.CanTouch; end); end; end; Ji = setmetatable({}, {__mode = "k"}); end; local function Ji() if _G.dropActive or _G.IsDropping then return; end; local ji = m.Character; local wi, yi = ji and(ji:FindFirstChild("HumanoidRootPart")), ji and(ji:FindFirstChildOfClass("Humanoid")); if not wi or not yi or yi.Health <= 0 then return; end; yi = wi.AssemblyLinearVelocity; local Ui, ei, ai = Vector3.new(yi.X, 0, yi.Z), wi.AssemblyAngularVelocity, E["TP Bat"] == true or E.Aimbot == true or E["Lagger Aimbot"] == true or o == true; if(Ui.Magnitude > 375 or math.abs(yi.Y) > 300 or ei.Magnitude > 110) and not ai then for wi, wi in ipairs(ji:GetDescendants()) do if wi:IsA("BasePart") then wi.AssemblyLinearVelocity = Vector3.zero; wi.AssemblyAngularVelocity = Vector3.zero; end; end; end; end; local function ji() if gi then return; end; gi = true; Oi = fi(); if not Oi then for wi, wi in ipairs(K:GetPlayers()) do oi(wi); end; end; table.insert(ni, K.PlayerAdded:Connect(oi)); local oi = 0; table.insert(ni, c.Stepped:Connect(function(wi, wi) if not gi then return; end; if A then oi += wi or 0; if oi < 0.1 then return; end; oi = 0; end; if fi() then if not Oi then Oi = true; Bi(); end; return; end; Oi = Oi and false; for fi, fi in ipairs(K:GetPlayers()) do if fi ~= m and fi.Character then qi(fi.Character); end; end; end)); end; local function fi() if not gi then return; end; gi = false; for oi, oi in ipairs(ni) do pcall(function() oi:Disconnect(); end); end; ni = {}; Bi(); Oi = false; end; function _G.__ZurichSetFullNoPlayerCollision (Oi) if Oi then ji(); else fi(); end; end; _G.__setNoPlayerCollision = _G.__ZurichSetFullNoPlayerCollision; function _G.__getNoPlayerCollision () return gi; end; _G.__GhostDuelTrackStopper (fi); _G.__GhostDuelTrackConn (c.PostSimulation:Connect(Ji)); ji(); end)();
                    local function gi(Oi)
                        if not Oi or not Oi:IsA("BasePart") then
                            return;
                        end;
                        if Oi.CanCollide and(Oi.Transparency >= 0.9 or Oi.LocalTransparencyModifier >= 0.9) then
                            Oi.CanCollide = false;
                        end;
                    end;
                    local function Oi(ni, Ji)
                        if not ni then
                            return;
                        end;
                        for fi, fi in ipairs(workspace:GetPartBoundsInRadius(ni, Ji)) do
                            gi(fi);
                        end;
                    end;
                    _G.__killInvisibleNear = Oi;
                    _G.__GhostDuelTrackConn (workspace.DescendantAdded:Connect(function(ni) if not(E["ESP Players"] or E["Player Tracers"] or E["Stretchz Res"]) then return; end; gi(ni); end));
                    do
                        local ni, Ji, fi = 0, 0;
                        _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function(oi) if not(E["ESP Players"] or E["Player Tracers"] or E["Stretchz Res"]) then return; end; ni += oi or 0; Ji += oi or 0; if ni >= 2 then ni = 0; oi = m.Character; local ni = oi and(oi:FindFirstChild("HumanoidRootPart")); if ni then for qi, qi in ipairs(oi:GetDescendants()) do gi(qi); end; local oi = ni.AssemblyLinearVelocity; local qi = Vector3.new(oi.X, 0, oi.Z); oi = qi.Magnitude; local Bi = math.clamp(20 + oi * 0.2, 20, 40); Oi(ni.Position, Bi); if oi > 5 then Oi(ni.Position + qi * 0.35, Bi); end; end; end; if Ji >= 15 then Ji = 0; if fi then fi(); end; fi = _G.__GhostDuelWalkDescendantsBatched (workspace, gi, function() return E["ESP Players"] or E["Player Tracers"] or E["Stretchz Res"]; end); end; end));
                    end;
                    _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() awfLastRecovery = 0; end));
                    local gi = false;
                    local function Oi(ni)
                        if ni then
                            if E["Auto Carry Speed"] then
                                return;
                            end;
                            gi = true;
                        else
                            if not gi then
                                return;
                            end;
                            gi = false;
                        end;
                        E["Auto Carry Speed"] = ni;
                        local gi = e["Auto Carry Speed"];
                        if gi then
                            pcall(gi, ni);
                        end;
                        gi = W["Auto Carry Speed"];
                        if gi then
                            pcall(gi, ni);
                        end;
                        gi = U["Auto Carry Speed"];
                        if gi then
                            pcall(gi);
                        end;
                    end;
                    local function gi(ni)
                        E.Autoplay = ni;
                        local Ji = e.Autoplay;
                        if Ji then
                            pcall(Ji, ni);
                            return;
                        end;
                        ni = U.Autoplay;
                        if ni then
                            pcall(ni);
                        end;
                    end;
                    local function ni(Ji)
                        if o then
                            o, xi, _i, Li = false, "none", 1, false;
                            if zi then
                                zi:Disconnect();
                                zi = nil;
                            end;
                            local fi = m.Character and(m.Character:FindFirstChild("HumanoidRootPart"));
                            if fi then
                                fi.Velocity = Vector3.new(0, fi.Velocity.Y, 0);
                            end;
                        end;
                        Oi(false);
                        if Ji then
                            return;
                        end;
                        if E.Autoplay then
                            gi(false);
                            mi();
                        end;
                    end;
                    _G.__stopAutoplay = ni;
                    _G.__GhostDuelTrackStopper (ni);
                    local function gi()
                        if o then
                            ni(true);
                        end;
                        ci();
                        if E["TP Bat"] and _G.GhostDuelAutoBat then
                            _G.GhostDuelAutoBat.SetEnabled(false);
                        end;
                        xi, _i, Li, o = Si(), 1, false, true;
                        Oi(false);
                        if not _G.__autoplayMode or _G.__autoplayMode ~= "Full" and _G.__autoplayMode ~= "Semi" then
                            _G.__autoplayMode = "Full";
                        end;
                        if zi then
                            zi:Disconnect();
                        end;
                        zi = c.Heartbeat:Connect(function(zi) if not o then return; end; local Si = xi == "left" and J or f; local J, f = _G.__autoplayMode == "Semi" and 2 or #Si, Si[_i]; if not f then return; end; Si = m:GetAttribute("Stealing"); if Si == true then Li = true; end; Si = _i > 2 and Li; Oi(Si); local xi = m.Character; if not xi then return; end; local Ji = xi:FindFirstChild("HumanoidRootPart"); if not Ji then return; end; local fi, oi = Ji.Position, Vector3.new(f.X, 0, f.Z); xi = Vector3.new(fi.X, 0, fi.Z); fi = (oi - xi).Magnitude; if _i > 2 and not Li then Ji.Velocity = Vector3.new(0, Ji.Velocity.Y, 0); return; end; if fi <= 1.1 then Ji.Velocity = Vector3.new(0, Ji.Velocity.Y, 0); if _i >= J then if m:GetAttribute("Stealing") ~= true then ni(); end; return; end; _i += 1; else f = oi - xi; f = if f.Magnitude > 0.001 then f.Unit else f; local J = (Si and(ki()) or(Pi())) + 1; J = math.min(if fi < 1.5 then J * math.clamp(fi / 1.5, 0.6, 1) else J, fi / math.max(zi or 0.016666666666666666, 0.004166666666666667)); Ji.Velocity = Vector3.new(f.X * J, Ji.Velocity.Y, f.Z * J); end; end);
                    end;
                    _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() task.wait(0.5); if o then gi(); end; end));
                    W.Autoplay = function(J)
                        if J then
                            Oi(true);
                            _G.__checkAndAutoDrop (function() gi(); end);
                        else
                            ni();
                        end;
                    end;
                    function FeatureToggles.Autoplay()
                        E.Autoplay = not E.Autoplay;
                        if E.Autoplay then
                            Oi(true);
                            _G.__checkAndAutoDrop (function() gi(); end);
                        else
                            ni();
                        end;
                        if U.Autoplay then
                            U.Autoplay();
                        end;
                        mi();
                    end;
                    if E.Autoplay then
                        gi();
                    end;
                    do
                        local J, f, o, Pi = 0, false, 0, true;
                        local function ki()
                            o += 1;
                            f = false;
                        end;
                        _G.__GhostDuelTrackConn (m.CharacterRemoving:Connect(ki));
                        _G.__GhostDuelTrackStopper (function() Pi = false; ki(); end);
                        local function xi()
                            if not Pi or _G.dropActive or _G.IsDropping then
                                return;
                            end;
                            local Pi = 0.1 - (os.clock() - J);
                            if Pi > 0 then
                                if not f then
                                    f = true;
                                    local _i, Li = o, m.Character;
                                    task.delay(Pi, function() if _i ~= o or m.Character ~= Li then return; end; f = false; xi(); end);
                                end;
                                return;
                            end;
                            Pi = m.Character;
                            if not Pi then
                                return;
                            end;
                            local f = Pi:FindFirstChild("HumanoidRootPart");
                            if not f then
                                return;
                            end;
                            local o = Pi:FindFirstChildOfClass("Humanoid");
                            if not o or o.Health <= 0 or f.Anchored or o.Sit or o.SeatPart then
                                return;
                            end;
                            J = os.clock();
                            ki();
                            local J, J = f.CFrame:ToEulerAnglesYXZ();
                            pcall(function() f.CFrame = CFrame.new(f.Position.X,- 7, f.Position.Z) * CFrame.Angles(0, J, 0); f.AssemblyLinearVelocity = Vector3.zero; end);
                        end;
                        _G.ExecuteTPDown = xi;
                        FeatureToggles["TP Down"] = xi;
                        do
                            _G.__loadInstaReset = true;
                            local J, f, o = false;
                            local Pi, ki = false, false;
                            local function _i ()
                                if J then
                                    return;
                                end;
                                J, Pi, ki = true, false, false;
                                local Li = m.Character;
                                local zi = Li and(Li:FindFirstChildOfClass("Humanoid"));
                                if not Li or not zi then
                                    J = false;
                                    return;
                                end;
                                o = Li;
                                f = task.spawn(function() local Si, gi = zi.HipHeight, 0; while Li and Li.Parent and zi and zi.Health > 0 and m.Character == Li and not ki do pcall(function() zi.HipHeight = 1.0E30; zi.AutoRotate = true; local Oi = Li:FindFirstChild("HumanoidRootPart"); if Oi then Oi.CanCollide = false; end; for Oi, Oi in ipairs(Li:GetChildren()) do if Oi:IsA("BasePart") and Oi.Name ~= "HumanoidRootPart" then Oi.CanCollide = false; end; end; end); if not Li.Parent or zi.Health <= 0 or m.Character ~= Li then Pi = true; break; end; gi += 1; if gi >= 40 then break; end; task.wait(0.05); end; if not Pi and Li and Li.Parent and zi.Health > 0 and m.Character == Li then pcall(function() zi.Health = 0; end); task.wait(0.1); gi = not Li.Parent or zi.Health <= 0; if gi then Pi = true; end; end; if not Pi and Li and Li.Parent and zi then pcall(function() zi.HipHeight = Si; local zi = Li:FindFirstChild("HumanoidRootPart"); if zi then zi.CanCollide = true; end; for zi, zi in ipairs(Li:GetChildren()) do if zi:IsA("BasePart") and zi.Name ~= "HumanoidRootPart" then zi.CanCollide = true; end; end; end); end; J, f, o, ki = false, nil, nil, false; end);
                            end;
                            local function Li()
                                ki = true;
                                if f then
                                    pcall(task.cancel, f);
                                    f = nil;
                                end;
                                J, o = false, nil;
                            end;
                            FeatureToggles["Insta Reset"] = _i;
                            _G.__GhostDuelInstaReset = _i;
                            _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() Li(); Pi, ki = false, false; end));
                            _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function() if not f and not o and not J then return; end; local ki = m.Character; local _i = ki and(ki:FindFirstChildOfClass("Humanoid")); if _i and _i.Health <= 0 or o and ki ~= o then Pi = true; if f then pcall(task.cancel, f); f = nil; end; J, o = false, nil; end; end));
                            _G.__GhostDuelTrackStopper (function() Li(); end);
                        end;
                        local J, f, o = 0, false;
                        local Pi = RaycastParams.new();
                        Pi.FilterType = Enum.RaycastFilterType.Exclude;
                        pcall(function() Pi.RespectCanCollide = true; end);
                        W["Auto TP Down"] = function(ki)
                            if not ki then
                                J, f, o = 0, false, nil;
                            end;
                        end;
                        _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function(ki) if E["Auto TP Down"] ~= true then return; end; if _G.dropActive or _G.IsDropping then J = 0; return; end; J += ki or 0; if J < 0.1 then return; end; J = 0; ki = m.Character; local J, _i = ki and(ki:FindFirstChildOfClass("Humanoid")), ki and(ki:FindFirstChild("HumanoidRootPart")); if not _i or not J or J.Health <= 0 then f, o = false, nil; return; end; if _i ~= o then o, f = _i, false; end; J = math.clamp(tonumber(N.AutoTPDownHeight) or 20, 1, 1000); Pi.FilterDescendantsInstances = {ki}; ki = workspace:Raycast(_i.Position, Vector3.new(0,- 2048, 0), Pi); local o = ki and(math.max(0, _i.Position.Y - ki.Position.Y)) or nil; ki = o ~= nil and o >= J; if ki and not f then f = true; xi(); elseif not ki then f = false; end; end));
                    end;
                    do
                        local J, f = false;
                        local function o()
                            if J then
                                return;
                            end;
                            local Pi = m.Character;
                            if not Pi then
                                return;
                            end;
                            local ki = Pi:FindFirstChild("HumanoidRootPart");
                            if not ki then
                                return;
                            end;
                            if f then
                                f:Disconnect();
                                f = nil;
                            end;
                            local xi = ki.Position.Y;
                            J = true;
                            _G.dropActive = true;
                            _G.IsDropping = true;
                            local ki = tick();
                            f = c.Heartbeat:Connect(function() local _i = Pi and(Pi:FindFirstChild("HumanoidRootPart")); if not _i then f:Disconnect(); f, J = nil, false; _G.dropActive = false; _G.IsDropping = false; return; end; if tick() - ki >= 0.2 then f:Disconnect(); f = nil; local f, f = _i.CFrame:ToEulerAnglesYXZ(); _i.CFrame = CFrame.new(_i.Position.X, xi, _i.Position.Z) * CFrame.Angles(0, f, 0); _i.AssemblyLinearVelocity = Vector3.zero; pcall(function() _i.Velocity = Vector3.zero; end); J = false; _G.dropActive = false; _G.IsDropping = false; return; end; _i.AssemblyLinearVelocity = Vector3.new(_i.AssemblyLinearVelocity.X, 150, _i.AssemblyLinearVelocity.Z); end);
                        end;
                        FeatureToggles.Drop = o;
                        _G.doDrop = o;
                    end;
                    function _G.__checkAndAutoDrop (J)
                        a = true;
                        local function f()
                            a = false;
                        end;
                        if m:GetAttribute("Stealing") then
                            local o = m.Character;
                            if not o then
                                if J then
                                    J();
                                end;
                                f();
                                return;
                            end;
                            local Pi, ki = o:FindFirstChildOfClass("Humanoid"), o:FindFirstChild("HumanoidRootPart");
                            if not Pi or not ki then
                                if J then
                                    J();
                                end;
                                f();
                                return;
                            end;
                            if FeatureToggles.Drop then
                                FeatureToggles.Drop();
                                Pi = tick();
                                while m:GetAttribute("Stealing") and tick() - Pi < 5 do
                                    task.wait();
                                end;
                            end;
                            if J then
                                J();
                            end;
                            f();
                        else
                            if J then
                                J();
                            end;
                            f();
                        end;
                    end;
                end;
                local J, f = 0, {busy = false, data = {}};
                do
                    local o, Pi, ki, xi = m, workspace:WaitForChild("Plots"), {};
                    local _i, Li, zi, Si = {caches = {}, connections = {}}, {}, {};
                    local gi, Oi, ni, Ji = false, false, {};
                    local fi, oi, qi = 0, {AUTO_STEAL_ENABLED = false, HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.01, COOLDOWN = 0.05, STEAL_RANGE = 6, PRIME_RANGE = math.clamp(tonumber(P.Radius) or 65, 10, 150)}, setmetatable({}, {__mode = "k"});
                    local function Bi(ji)
                        if not ji then
                            return nil;
                        end;
                        local wi = qi[ji];
                        if wi and wi.Parent and(wi:IsA("ProximityPrompt")) and wi.ActionText and(wi.ActionText:find("Steal")) then
                            return wi;
                        end;
                        wi = ji:FindFirstChild("PromptAttachment");
                        for yi, yi in ipairs(wi and(wi:GetChildren()) or(ji:GetDescendants())) do
                            if yi:IsA("ProximityPrompt") and yi.ActionText and(yi.ActionText:find("Steal")) then
                                qi[ji] = yi;
                                return yi;
                            end;
                        end;
                        qi[ji] = nil;
                        return nil;
                    end;
                    local qi, ji = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0, totalSteals = 0, failedSteals = 0}, _G.__GhostDuelAutoStealState or {isStealing = false};
                    _G.__GhostDuelAutoStealState = ji;
                    local function wi(yi)
                        yi = yi == true;
                        if ji.isStealing == yi then
                            return;
                        end;
                        ji.isStealing = yi;
                    end;
                    local function ji()
                        if xi then
                            return true;
                        end;
                        return pcall(function() local yi, Ui = i:WaitForChild("Packages", 10), i:WaitForChild("Datas", 10); if not yi or not Ui then return; end; ki = require(Ui:WaitForChild("Animals")); Ui = yi:WaitForChild("Synchronizer"); xi = {channelFolder = Ui:WaitForChild("Channel"), routeRemote = Ui:WaitForChild("CommunicationRoute"), requestData = Ui:FindFirstChild("RequestData")}; end) and xi ~= nil;
                    end;
                    local function i(yi)
                        if typeof(yi) == "table" then
                            return yi;
                        end;
                        local Ui = {};
                        for ei in string.gmatch(tostring(yi), "[^%.]+") do
                            table.insert(Ui, tonumber(ei) or ei);
                        end;
                        return Ui;
                    end;
                    local function yi(Ui, ei)
                        local ai, Wi, Ti = ei;
                        for ei, ei in ipairs(i(Ui)) do
                            ai, Wi, Ti = ai and ai[ei] or nil, ai, ei;
                        end;
                        return ai, Wi, Ti;
                    end;
                    local function i(Ui, ei)
                        local ai = _i.caches[Ui];
                        if typeof(ai) ~= "table" then
                            return;
                        end;
                        local Ui, Wi, Ti, li = ei[1], ei[2], ei[3], ei[4];
                        local ei, Zi, pi = yi(Ui, ai);
                        if Wi == "Changed" then
                            if Zi ~= nil then
                                Zi[pi] = Ti;
                            end;
                        elseif Wi == "ArrayInsert" then
                            if ei ~= nil then
                                table.insert(ei, li, Ti);
                            end;
                        elseif Wi == "ArrayRemoved" then
                            if ei ~= nil then
                                table.remove(ei, li);
                            end;
                        elseif Wi == "DictionaryInsert" then
                            if ei ~= nil then
                                ei[li] = Ti;
                            end;
                        elseif Wi == "DictionaryRemoved" then
                            if ei ~= nil then
                                ei[li] = nil;
                            end;
                        end;
                    end;
                    local function yi(Ui)
                        if not xi or _i.connections[Ui] then
                            return;
                        end;
                        local ei = tostring(Ui.Name);
                        if not Pi:FindFirstChild(ei) then
                            return;
                        end;
                        if xi.requestData and _i.caches[ei] == nil then
                            local ai, Wi = pcall(function() return xi.requestData:InvokeServer(ei); end);
                            _i.caches[ei] = ai and typeof(Wi) == "table" and Wi or {};
                        elseif _i.caches[ei] == nil then
                            _i.caches[ei] = {};
                        end;
                        _i.connections[Ui] = Ui.OnClientEvent:Connect(function(Ui) for ai, ai in ipairs(Ui) do i(ei, ai); end; end);
                    end;
                    local function i(Ui)
                        for ei, ai in pairs(_i.connections) do
                            if tostring(ei.Name) == tostring(Ui) then
                                ai:Disconnect();
                                _i.connections[ei] = nil;
                                _i.caches[tostring(Ui)] = nil;
                                break;
                            end;
                        end;
                    end;
                    local function Ui()
                        if gi then
                            return true;
                        end;
                        if not ji() then
                            return false;
                        end;
                        if not xi or not xi.channelFolder then
                            return false;
                        end;
                        for ji, ji in ipairs(xi.channelFolder:GetChildren()) do
                            if ji:IsA("RemoteEvent") then
                                yi(ji);
                            end;
                        end;
                        xi.channelFolder.ChildAdded:Connect(function(ji) if ji:IsA("RemoteEvent") then yi(ji); end; end);
                        xi.routeRemote.OnClientEvent:Connect(function(ji) for ei, ei in ipairs(ji) do local ji, ai = ei[1], tostring(ei[2]); if Pi:FindFirstChild(ai) then if ji == "ListenerAdded" then ei = xi.channelFolder:FindFirstChild(ai); if ei and(ei:IsA("RemoteEvent")) then yi(ei); end; elseif ji == "ListenerRemoved" then i(ai); end; end; end; end);
                        gi = true;
                        return true;
                    end;
                    local function i(xi)
                        return _i.caches[xi];
                    end;
                    local function xi(_i)
                        local gi = Pi:FindFirstChild(_i.plot);
                        local ji = gi and(gi:FindFirstChild("AnimalPodiums"));
                        gi = ji and(ji:FindFirstChild(_i.slot));
                        return gi and gi:GetPivot().Position;
                    end;
                    local function _i (gi)
                        local ji = m.Character;
                        local yi = ji and(ji:FindFirstChild("HumanoidRootPart") or(ji:FindFirstChild("UpperTorso")));
                        if not yi then
                            return math.huge;
                        end;
                        ji = xi(gi);
                        if not ji then
                            return math.huge;
                        end;
                        return(yi.Position - ji).Magnitude;
                    end;
                    local function xi()
                        if not Pi then
                            return {};
                        end;
                        local gi = {};
                        for ji, yi in ipairs(Pi:GetChildren()) do
                            ji = i(yi.Name);
                            local i = ji and ji.AnimalList;
                            if typeof(i) == "table" then
                                for ei, ai in pairs(i) do
                                    if type(ai) == "table" then
                                        ji = ai.Index;
                                        local i = ki[ji];
                                        if i then
                                            table.insert(gi, {name = i.DisplayName or ji, plot = yi.Name, slot = tostring(ei), uid = yi.Name .. "_" .. tostring(ei)});
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        Li = gi;
                        return #Li;
                    end;
                    local function i(ki)
                        if zi[ki] then
                            return;
                        end;
                        local Li, gi, ji = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}, false;
                        if getconnections then
                            gi, ji = pcall(getconnections, ki.PromptButtonHoldBegan);
                        end;
                        if gi and type(ji) == "table" then
                            for yi, yi in ipairs(ji) do
                                if type(yi.Function) == "function" then
                                    table.insert(Li.holdCallbacks, yi.Function);
                                end;
                            end;
                        end;
                        ji, gi = false;
                        if getconnections then
                            ji, gi = pcall(getconnections, ki.Triggered);
                        end;
                        if ji and type(gi) == "table" then
                            for ji, ji in ipairs(gi) do
                                if type(ji.Function) == "function" then
                                    table.insert(Li.triggerCallbacks, ji.Function);
                                end;
                            end;
                        end;
                        if #Li.holdCallbacks > 0 or #Li.triggerCallbacks > 0 then
                            zi[ki] = Li;
                        end;
                    end;
                    local function ki(Li, gi)
                        local ji = zi[Li];
                        if not ji or not ji.ready then
                            return false;
                        end;
                        ji.ready = false;
                        local yi = gi and gi.name or "Animal";
                        qi.active = true;
                        qi.startTime = tick();
                        qi.phase = "holding";
                        qi.label = yi;
                        wi(false);
                        J = 0;
                        local ei = fi;
                        task.spawn(function() oi.HOLD_MIN = P.Duration or oi.HOLD_MIN; oi.HOLD_MAX = oi.HOLD_MIN + 1.3; for ai, ai in ipairs(ji.holdCallbacks) do task.spawn(ai); end; while tick() - qi.startTime < oi.HOLD_MIN do if ei ~= fi then ji.ready = true; return; end; if not oi.AUTO_STEAL_ENABLED or not Li.Parent then break; end; local ai = tick() - qi.startTime; J = math.clamp(ai / oi.HOLD_MAX, 0, 1); task.wait(0.05); end; qi.phase = "waitingRange"; local ai, Wi = gi and _i (gi) <= oi.STEAL_RANGE, false; while ei == fi and oi.AUTO_STEAL_ENABLED and Li.Parent do local Li = tick() - qi.startTime; J = math.clamp(Li / oi.HOLD_MAX, 0, 1); if Li > oi.HOLD_MAX then break; end; if gi and _i (gi) <= oi.STEAL_RANGE then if not ai then task.wait(oi.ENTRY_DELAY); end; for _i, _i in ipairs(ji.triggerCallbacks) do task.spawn(_i); end; Wi = true; break; end; task.wait(0.05); end; if ei ~= fi then ji.ready = true; return; end; if Wi then qi.totalSteals = qi.totalSteals + 1; qi.lastResult = "Stole " .. yi; qi.phase = "success"; wi(true); else qi.failedSteals = qi.failedSteals + 1; qi.lastResult = "Missed window: " .. yi; qi.phase = "failed"; end; qi.active = false; qi.lastResultTime = tick(); J = 1; task.wait(oi.COOLDOWN); J = 0; ji.ready = true; end);
                        return true;
                    end;
                    local function _i (Li, gi)
                        if not Li or not Li.Parent then
                            return false;
                        end;
                        i(Li);
                        return ki(Li, gi);
                    end;
                    local i, ki, Li = {busy = false, active = false, progress = 0, isStealing = false, currentTarget = nil, totalSteals = 0, failedSteals = 0, lastResult = "", generation = 0, phase = "idle", startTime = 0, data = {}}, {RADIUS = 65, HOLD_MIN = 1.3, HOLD_MAX = 2.6, NEAR_TARGET_RANGE = 20, ENTRY_DELAY = 0.3, FIRE_RANGE = 12, COOLDOWN = 0.45}, {prompt = nil, radius = 0, expiresAt = 0};
                    local function gi(ji)
                        local yi = math.max(0, tonumber(ji) or ki.RADIUS);
                        if Li.expiresAt > tick() and Li.radius == yi and Li.prompt and Li.prompt.Parent then
                            return Li.prompt;
                        end;
                        ji = m.Character;
                        local ei = ji and(ji:FindFirstChild("HumanoidRootPart") or(ji:FindFirstChild("UpperTorso")) or(ji:FindFirstChild("Torso")));
                        if not ei then
                            return nil;
                        end;
                        local ai, Wi, Ti = math.huge, yi * yi;
                        for li, Zi in ipairs(Pi:GetChildren()) do
                            ji = Zi:FindFirstChild("PlotSign");
                            li = ji and(ji:FindFirstChild("YourBase"));
                            if Zi:IsA("Model") and not(li and(li:IsA("BillboardGui")) and li.Enabled) then
                                local ji = Zi:FindFirstChild("AnimalPodiums");
                                if ji then
                                    for li, Zi in ipairs(ji:GetChildren()) do
                                        li = Zi:FindFirstChild("Base") and(Zi.Base:FindFirstChild("Spawn"));
                                        if li then
                                            Zi = li.Position - ei.Position;
                                            local ji = Zi:Dot(Zi);
                                            if ji <= Wi and ji < ai then
                                                local ei = Bi(li);
                                                if ei then
                                                    ai, Ti = ji, ei;
                                                end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                        Li.prompt = Ti;
                        Li.radius = yi;
                        Li.expiresAt = tick() + 0.12;
                        return Ti;
                    end;
                    function _G.__GhostDuelAutoGrabTargetInRadius (Li)
                        return gi(Li or 65) ~= nil;
                    end;
                    local function Li(Bi)
                        local ji = m.Character;
                        local yi = ji and(ji:FindFirstChild("HumanoidRootPart") or(ji:FindFirstChild("UpperTorso")) or(ji:FindFirstChild("Torso")));
                        if not yi then
                            return math.huge;
                        end;
                        ji = Bi.Parent;
                        ji = if ji and(ji:IsA("Attachment")) then
                            ji.Parent
                        else
                            ji;
                            if ji and(ji:IsA("BasePart")) then
                                return(ji.Position - yi.Position).Magnitude;
                            end;
                            local ji, ei = pcall(function() return Bi.Parent and Bi.Parent.WorldPosition; end);
                            if ji and ei then
                                return(ei - yi.Position).Magnitude;
                            end;
                            return math.huge;
                        end;
                        local function Bi(ji)
                            local yi = i.data[ji];
                            if yi then
                                return yi;
                            end;
                            yi = {hold = {}, trigger = {}, ready = true};
                            if getconnections then
                                for ei, ei in ipairs(getconnections(ji.PromptButtonHoldBegan)) do
                                    if ei.Function then
                                        table.insert(yi.hold, ei.Function);
                                    end;
                                end;
                                for ei, ei in ipairs(getconnections(ji.Triggered)) do
                                    if ei.Function then
                                        table.insert(yi.trigger, ei.Function);
                                    end;
                                end;
                            end;
                            i.data[ji] = yi;
                            return yi;
                        end;
                        local function ji(yi, ei)
                            if not yi or not yi.Parent then
                                return false;
                            end;
                            if m:GetAttribute("Stealing") == true then
                                return false;
                            end;
                            local ai = false;
                            for Wi, Wi in ipairs(ei.trigger) do
                                ai = if pcall(Wi) then
                                    true
                                else
                                    ai;
                                end;
                                ai = if not ai and m:GetAttribute("Stealing") ~= true and typeof(fireproximityprompt) == "function" then
                                    pcall(fireproximityprompt, yi) or ai
                                else
                                    ai;
                                    return if not ai and m:GetAttribute("Stealing") ~= true then
                                        (pcall(function() yi:InputHoldBegin(); task.wait(0.05); yi:InputHoldEnd(); end))
                                    else
                                        ai;
                                    end;
                                    local function yi(ei)
                                        if i.busy or not ei or not ei.Parent then
                                            return;
                                        end;
                                        if m:GetAttribute("Stealing") == true then
                                            return;
                                        end;
                                        local ai = Bi(ei);
                                        if #ai.trigger == 0 then
                                            i.data[ei] = nil;
                                            ai = Bi(ei);
                                        end;
                                        if not ai.ready then
                                            return;
                                        end;
                                        ai.ready = false;
                                        i.busy = true;
                                        i.active = true;
                                        i.isStealing = true;
                                        i.startTime = tick();
                                        i.progress = 0;
                                        i.phase = "holding";
                                        i.generation = i.generation + 1;
                                        local Bi = i.generation;
                                        wi(true);
                                        task.spawn(function() for Wi, Wi in ipairs(ai.hold) do task.spawn(Wi); end; local Wi = tick(); while i.busy and tick() - Wi < ki.HOLD_MIN do if Bi ~= i.generation then return; end; i.progress = math.clamp((tick() - Wi) / ki.HOLD_MIN, 0, 1); J = i.progress; task.wait(0.05); end; if Bi ~= i.generation then return; end; i.progress = 1; J = 1; i.phase = "waiting"; local Ti, li = Li(ei) <= ki.FIRE_RANGE, false; while Bi == i.generation and ei.Parent and oi.AUTO_STEAL_ENABLED and m:GetAttribute("Stealing") ~= true do i.progress = 1; J = 1; local Zi = Li(ei); if Zi > ki.NEAR_TARGET_RANGE and tick() - Wi > ki.HOLD_MAX then break; end; if Zi <= ki.FIRE_RANGE then if not Ti then task.wait(ki.ENTRY_DELAY); if Bi ~= i.generation or not ei.Parent or Li(ei) > ki.FIRE_RANGE then task.wait(0.05); continue; end; end; i.phase = "triggering"; if not ji(ei, ai) then i.phase = "waiting"; task.wait(0.05); continue; end; i.totalSteals = i.totalSteals + 1; qi.totalSteals = qi.totalSteals + 1; i.lastResult = "[OK] ROBADO!"; qi.lastResult = "Stole"; i.isStealing = true; i.phase = "success"; li = true; break; end; task.wait(0.05); end; if Bi ~= i.generation then return; end; i.active = false; i.isStealing = false; i.busy = false; ai.ready = true; wi(false); if not li then i.failedSteals = i.failedSteals + 1; i.lastResult = "[X] FALLO"; i.phase = "failed"; end; i.lastResultTime = tick(); qi.lastResultTime = tick(); task.wait(ki.COOLDOWN); if Bi ~= i.generation then return; end; i.progress = 0; J = 0; i.phase = "idle"; end);
                                    end;
                                    local ki, Bi = {busy = false, active = false, progress = 0, paused = false, pauseTime = nil, totalSteals = 0, failedSteals = 0, lastResult = "", generation = 0, phase = "idle", data = {}}, {STEAL_DURATION = 1.3, HOLD_TARGET = 0.8, TRIGGER_RADIUS = 10, PAUSE_TIMEOUT = 1.3, COOLDOWN = 0.05};
                                    local function ji(ei)
                                        local ai = ki.data[ei];
                                        if ai then
                                            return ai;
                                        end;
                                        ai = {hold = {}, trigger = {}, ready = true};
                                        if getconnections then
                                            pcall(function() for Wi, Wi in ipairs(getconnections(ei.PromptButtonHoldBegan)) do if Wi.Function then table.insert(ai.hold, Wi.Function); end; end; for Wi, Wi in ipairs(getconnections(ei.Triggered)) do if Wi.Function then table.insert(ai.trigger, Wi.Function); end; end; end);
                                        end;
                                        ki.data[ei] = ai;
                                        return ai;
                                    end;
                                    local function ei(ai)
                                        if ki.busy or not ai or not ai.Parent then
                                            return;
                                        end;
                                        if m:GetAttribute("Stealing") == true then
                                            return;
                                        end;
                                        local Wi = ji(ai);
                                        if not Wi.ready then
                                            return;
                                        end;
                                        Wi.ready = false;
                                        ki.busy = true;
                                        ki.active = true;
                                        ki.progress = 0;
                                        ki.paused = false;
                                        ki.pauseTime = nil;
                                        ki.phase = "holding";
                                        ki.generation = ki.generation + 1;
                                        local ji, Ti, li, Zi = ki.generation, tick(), true, false;
                                        qi.active = true;
                                        qi.startTime = Ti;
                                        qi.phase = "holding";
                                        J = 0;
                                        wi(true);
                                        task.spawn(function() for pi, pi in ipairs(Wi.hold) do task.spawn(function() pcall(pi); end); end; while ji == ki.generation and oi.AUTO_STEAL_ENABLED and k == "v2" and m:GetAttribute("Stealing") ~= true and ai.Parent do if ki.paused then if Li(ai) <= Bi.TRIGGER_RADIUS then ki.paused = false; ki.pauseTime = nil; ki.phase = "finishing"; Ti = tick() - Bi.HOLD_TARGET * Bi.STEAL_DURATION; else if not ki.pauseTime then ki.pauseTime = tick(); elseif tick() - ki.pauseTime >= Bi.PAUSE_TIMEOUT then break; end; ki.progress = Bi.HOLD_TARGET; J = ki.progress; qi.label = "80%"; task.wait(0.05); continue; end; end; local Li = math.clamp((tick() - Ti) / Bi.STEAL_DURATION, 0, 1); ki.progress = Li; J = Li; qi.label = math.floor(Li * 100 + 0.5) .. "%"; if li and Li >= Bi.HOLD_TARGET then li = false; ki.paused = true; ki.pauseTime = tick(); ki.progress = Bi.HOLD_TARGET; J = ki.progress; ki.phase = "waitingRange"; qi.phase = "waitingRange"; elseif Li >= 1 then ki.phase = "triggering"; for Li, Li in ipairs(Wi.trigger) do task.spawn(function() pcall(Li); end); end; Zi = true; break; end; task.wait(0.05); end; if ji ~= ki.generation then return; end; ki.active = false; ki.busy = false; ki.paused = false; ki.pauseTime = nil; Wi.ready = true; qi.active = false; qi.lastResultTime = tick(); wi(false); if Zi then ki.totalSteals = ki.totalSteals + 1; ki.lastResult = "Stole"; ki.phase = "success"; qi.totalSteals = qi.totalSteals + 1; qi.lastResult = "Stole"; else ki.failedSteals = ki.failedSteals + 1; ki.lastResult = "Missed window"; ki.phase = "failed"; qi.failedSteals = qi.failedSteals + 1; qi.lastResult = "Missed window"; end; task.wait(Bi.COOLDOWN); if ji == ki.generation then ki.progress = 0; J = 0; ki.phase = "idle"; end; end);
                                    end;
                                    local function Li()
                                        if Si then
                                            return;
                                        end;
                                        local Bi = 0;
                                        Si = c.Heartbeat:Connect(function(ji) Bi += ji or 0; if Bi < 0.15 then return; end; Bi = 0; if not oi.AUTO_STEAL_ENABLED then return; end; if m:GetAttribute("Stealing") == true then return; end; if _G.__GhostDuelAutoGrabRagdollBlocked == true then return; end; if qi.active or f.busy or i.busy or ki.busy then return; end; if k == "v2" then ji = gi(P.Radius); if ji then ei(ji); end; return; end; if k == "v1" then ji = gi(P.Radius); if ji then yi(ji); end; return; end; end);
                                    end;
                                    function _G.GhostDuelAutoStealRunCycle(gi, Bi)
                                        return _i (gi, Bi);
                                    end;
                                    local function _i ()
                                        if ni then
                                            for gi, gi in ipairs(ni) do
                                                pcall(function() gi:Disconnect(); end);
                                            end;
                                        end;
                                        ni = {};
                                        if Ji then
                                            task.cancel(Ji);
                                            Ji = nil;
                                        end;
                                    end;
                                    local function gi(Bi)
                                        _i ();
                                        local _i = Bi and(Bi:FindFirstChildOfClass("Humanoid"));
                                        if not _i then
                                            return;
                                        end;
                                        table.insert(ni, _i:GetPropertyChangedSignal("WalkSpeed"):Connect(function() wi(_i.WalkSpeed < 22); end));
                                        local function _i (ji)
                                            if not ji:IsA("ProximityPrompt") then
                                                return;
                                            end;
                                            table.insert(ni, ji.PromptButtonHoldBegan:Connect(function(yi) if yi ~= o then return; end; wi(true); if Ji then task.cancel(Ji); end; Ji = task.delay(oi.HOLD_MAX + 0.5, function() wi(false); end); end));
                                            table.insert(ni, ji.Triggered:Connect(function(Ji) if Ji ~= o then return; end; task.delay(0.2, function() wi(false); end); end));
                                        end;
                                        table.insert(ni, workspace.DescendantAdded:Connect(function(o) task.defer(_i, o); end));
                                        _G.__GhostDuelWalkDescendantsBatched (Pi, _i, function() return Bi.Parent ~= nil; end);
                                    end;
                                    local function o()
                                        if Oi then
                                            return;
                                        end;
                                        Oi = true;
                                        task.spawn(function() if Ui() then if oi.AUTO_STEAL_ENABLED then xi(); end; while H.alive do task.wait(5); if not H.alive then break; end; if oi.AUTO_STEAL_ENABLED then xi(); end; end; end; end);
                                    end;
                                    o();
                                    if m.Character then
                                        task.defer(gi, m.Character);
                                    end;
                                    _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(Pi) task.wait(0.5); gi(Pi); if E["auto steal"] then oi.AUTO_STEAL_ENABLED = false; if Si then Si:Disconnect(); Si = nil; end; oi.AUTO_STEAL_ENABLED = true; xi(); Li(); end; end));
                                    _G.GhostDuelAutoGrab = {GetMode = function() return k; end, SetMode = function(Pi) if Pi ~= "v1" and Pi ~= "v2" then return false; end; k = Pi; mi(); return true; end};
                                    local function Pi()
                                        o();
                                        xi();
                                        oi.AUTO_STEAL_ENABLED = true;
                                        Li();
                                    end;
                                    local function o()
                                        fi += 1;
                                        if Si then
                                            Si:Disconnect();
                                            Si = nil;
                                        end;
                                        oi.AUTO_STEAL_ENABLED = false;
                                        qi.active = false;
                                        qi.phase = "idle";
                                        wi(false);
                                        J, zi = 0, {};
                                        f.busy = false;
                                        f.data = {};
                                        if i then
                                            i.generation = i.generation + 1;
                                            i.busy = false;
                                            i.active = false;
                                            i.isStealing = false;
                                            i.progress = 0;
                                            i.phase = "idle";
                                            i.data = {};
                                        end;
                                        if ki then
                                            ki.generation = ki.generation + 1;
                                            ki.busy = false;
                                            ki.active = false;
                                            ki.paused = false;
                                            ki.pauseTime = nil;
                                            ki.progress = 0;
                                            ki.phase = "idle";
                                            ki.data = {};
                                        end;
                                    end;
                                    autoStealDisableInternal = o;
                                    _G.__GhostDuelTrackConn (m.CharacterRemoving:Connect(o));
                                    _G.__GhostDuelTrackStopper (o);
                                    (function() local i, ki, xi, _i = 0; local Li, zi, Si = false, false, 0; local function gi(Oi, ni) return Oi.PlatformStand or ni == Enum.HumanoidStateType.Physics or ni == Enum.HumanoidStateType.Ragdoll or ni == Enum.HumanoidStateType.FallingDown; end; local function Oi(ni) if not ni then return false; end; for Ji, fi in ipairs(ni:GetDescendants()) do if not fi:FindFirstAncestorOfClass("Tool") then Ji = fi.Name:lower(); if Ji:find("medusa") or(Ji:find("petrif")) or(Ji:find("gorgon")) or(Ji:find("stone")) then return true; end; for ni, Ji in pairs(fi:GetAttributes()) do local fi = tostring(ni):lower(); if Ji and(fi:find("medusa") or(fi:find("petrif")) or(fi:find("gorgon")) or(fi:find("stone"))) then return true; end; end; end; end; return false; end; local function ni(Ji) i += 1; local Ji = i; _G.__GhostDuelAutoGrabRagdollBlocked = true; zi = true; o(); task.delay(1, function() if Ji ~= i then return; end; zi = false; if not E["auto steal"] then return; end; _G.__GhostDuelAutoGrabRagdollBlocked = false; if not oi.AUTO_STEAL_ENABLED then Pi(); end; pcall(function() if _G.GhostDuelBypass and _G.GhostDuelBypass.IsAutoOnSteal and(_G.GhostDuelBypass.IsAutoOnSteal()) and _G.GhostDuelBypass.SetAutoOnSteal then pcall(_G.GhostDuelBypass.SetAutoOnSteal, true); end; end); end); end; local function Ji(fi) if ki then ki:Disconnect(); ki = nil; end; if xi then xi:Disconnect(); xi = nil; end; if _i then _i:Disconnect(); _i = nil; end; Li, Si = false, 0; local qi = fi and(fi:FindFirstChildOfClass("Humanoid") or(fi:WaitForChild("Humanoid", 5))); if not qi then return; end; local Bi = Oi; if Bi(fi) then Si = tick() + 5; end; _i = fi.DescendantAdded:Connect(function(_i) if _i:FindFirstAncestorOfClass("Tool") then return; end; local Bi = _i.Name:lower(); _i = Bi:find("medusa") or(Bi:find("petrif")) or(Bi:find("gorgon")) or(Bi:find("stone")); if _i then Si = tick() + 5; end; end); local function _i (Bi) local ji = Oi; if ji(fi) then Si = tick() + 5; end; ji = gi(qi, Bi); if ji and not Li then Li = true; ni(tick() <= Si); elseif not ji then Li = false; if not zi then _G.__GhostDuelAutoGrabRagdollBlocked = false; if E["auto steal"] and not oi.AUTO_STEAL_ENABLED then Pi(); end; end; end; end; ki = qi.StateChanged:Connect(function(ki, ki) _i (ki); end); xi = qi:GetPropertyChangedSignal("PlatformStand"):Connect(function() _i (qi:GetState()); end); end; if m.Character then task.defer(Ji, m.Character); end; _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(ki) i += 1; zi = false; _G.__GhostDuelAutoGrabRagdollBlocked = false; Ji(ki); end)); end)();
                                    W["auto steal"] = function(i)
                                        if i then
                                            if _G.__GhostDuelAutoGrabRagdollBlocked ~= true then
                                                Pi();
                                            end;
                                        else
                                            o();
                                        end;
                                    end;
                                    if E["auto steal"] then
                                        Pi();
                                    end;
                                end;
                                do
                                    do
                                        local function i(o, Pi)
                                            if E[o] == Pi then
                                                return;
                                            end;
                                            E[o] = Pi;
                                            if W[o] then
                                                W[o](Pi);
                                            end;
                                            if U[o] then
                                                U[o]();
                                            end;
                                            mi();
                                        end;
                                        local function o()
                                            i("Autoplay", false);
                                        end;
                                        local function i(Pi)
                                            if not Pi then
                                                return;
                                            end;
                                            local ki = os.clock();
                                            if _G._GhostDuelHitCountdownLast and ki - _G._GhostDuelHitCountdownLast < 0.15 then
                                                return;
                                            end;
                                            _G._GhostDuelHitCountdownLast = ki;
                                            local xi = (_G._GhostDuelHitCountdownGen or 0) + 1;
                                            _G._GhostDuelHitCountdownGen = xi;
                                            _G._GhostDuelHitCountdownActive = true;
                                            if _G._GhostDuelHitCountdownBB then
                                                pcall(function() _G._GhostDuelHitCountdownBB:Destroy(); end);
                                                _G._GhostDuelHitCountdownBB = nil;
                                            end;
                                            pcall(function() _G._GhostDuelShowStealCountdown = i; end);
                                            ki = Pi:FindFirstChild("LowerTorso") or(Pi:FindFirstChild("Torso")) or(Pi:FindFirstChild("UpperTorso")) or(Pi:FindFirstChild("HumanoidRootPart"));
                                            if not ki then
                                                _G._GhostDuelHitCountdownActive = false;
                                                return;
                                            end;
                                            local Pi = Instance.new("BillboardGui");
                                            Pi.Name = "GhostDuelHitCountdown";
                                            Pi.Adornee = ki;
                                            Pi.Size = UDim2.new(0, 120, 0, 56);
                                            Pi.StudsOffset = Vector3.new(0, 0.6, 0);
                                            Pi.AlwaysOnTop = true;
                                            Pi.LightInfluence = 0;
                                            Pi.Parent = m and(m:FindFirstChildOfClass("PlayerGui") or(game:GetService("CoreGui"))) or(game:GetService("CoreGui"));
                                            _G._GhostDuelHitCountdownBB = Pi;
                                            ki = Instance.new("Frame", Pi);
                                            ki.Size = UDim2.new(1, 0, 1, 0);
                                            ki.BackgroundTransparency = 1;
                                            ki.BorderSizePixel = 0;
                                            local _i = Instance.new("TextLabel", ki);
                                            _i.Size = UDim2.new(1, 0, 1, 0);
                                            _i.Position = UDim2.new(0, 0, 0, 6);
                                            _i.BackgroundTransparency = 1;
                                            _i.Text = "3";
                                            _i.TextScaled = false;
                                            _i.TextSize = 28;
                                            _i.Font = Enum.Font.GothamBlack;
                                            _i.TextColor3 = Color3.fromRGB(175, 180, 185);
                                            _i.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
                                            _i.TextStrokeTransparency = 0;
                                            _i.ZIndex = 10;
                                            _i.TextTransparency = 1;
                                            local function ki(Li, zi)
                                                _i.Text = Li;
                                                if zi then
                                                    _i.TextColor3 = zi;
                                                end;
                                                zi = Li == "STEAL!" and 1 or 0.76;
                                                for Li = 0, 6, 1 do
                                                    _i.TextTransparency = 1 - Li / 6;
                                                    task.wait(0.02);
                                                    if _G._GhostDuelHitCountdownGen ~= xi then
                                                        return false;
                                                    end;
                                                end;
                                                task.wait(zi);
                                                if _G._GhostDuelHitCountdownGen ~= xi then
                                                    return false;
                                                end;
                                                for Li = 0, 6, 1 do
                                                    _i.TextTransparency = Li / 6;
                                                    task.wait(0.02);
                                                    if _G._GhostDuelHitCountdownGen ~= xi then
                                                        return false;
                                                    end;
                                                end;
                                                return true;
                                            end;
                                            task.spawn(function() pcall(function() _i.TextStrokeTransparency = 0; _i.TextColor3 = Color3.fromRGB(175, 180, 185); for Li = 0, 24, 1 do local zi = 2.4 - 2.4 * Li / 24; _i.Text = zi <= 0.05 and "0" or(string.format("%.1f", zi)); _i.TextTransparency = 0; for Li = 0, 2, 1 do _i.TextTransparency = 0.18 * Li; task.wait(0.02); if _G._GhostDuelHitCountdownGen ~= xi then return; end; end; if _G._GhostDuelHitCountdownGen ~= xi then return; end; task.wait(0.08); if _G._GhostDuelHitCountdownGen ~= xi then return; end; end; if not ki("STEAL!", Color3.fromRGB(175, 180, 185)) then return; end; end); if _G._GhostDuelHitCountdownGen == xi then pcall(function() Pi:Destroy(); end); if _G._GhostDuelHitCountdownBB == Pi then _G._GhostDuelHitCountdownBB = nil; end; _G._GhostDuelHitCountdownActive = false; end; end);
                                        end;
                                        local function Pi(ki)
                                            local xi = ki:FindFirstChildOfClass("Humanoid");
                                            if not xi then
                                                return;
                                            end;
                                            local _i = xi.Health;
                                            xi.HealthChanged:Connect(function(Li) if Li < _i then o(); pcall(function() i(ki); end); end; _i = Li; end);
                                            if xi.StateChanged then
                                                xi.StateChanged:Connect(function(_i, _i) if _i == Enum.HumanoidStateType.Physics or _i == Enum.HumanoidStateType.Ragdoll or _i == Enum.HumanoidStateType.FallingDown then pcall(function() i(ki); end); end; end);
                                            end;
                                            pcall(function() xi:GetPropertyChangedSignal("PlatformStand"):Connect(function() if xi.PlatformStand then pcall(function() i(ki); end); end; end); end);
                                            xi.Died:Connect(function() o(); end);
                                        end;
                                        if m.Character then
                                            Pi(m.Character);
                                        end;
                                        _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(i) if i:WaitForChild("Humanoid", 5) then o(); Pi(i); else task.wait(0.5); o(); Pi(i); end; end));
                                    end;
                                    do
                                        local i = {generation = 0, animationConn = nil, animate = nil, disabledByUs = false};
                                        local function o()
                                            i.generation = i.generation + 1;
                                            if i.animationConn then
                                                i.animationConn:Disconnect();
                                                i.animationConn = nil;
                                            end;
                                        end;
                                        local function Pi(ki)
                                            local xi, _i = i.animate, i.disabledByUs;
                                            i.animate = nil;
                                            i.disabledByUs = false;
                                            if xi and xi.Parent and _i and(ki or not E.Unwalk) then
                                                pcall(function() xi.Disabled = false; end);
                                            end;
                                        end;
                                        local function ki(xi)
                                            local _i, Li = i.animate, i.disabledByUs;
                                            o();
                                            if not E.Unwalk or xi ~= m.Character then
                                                return;
                                            end;
                                            local zi, Si, gi = i.generation, xi:FindFirstChildOfClass("Humanoid") or(xi:WaitForChild("Humanoid", 5)), xi:FindFirstChild("Animate") or(xi:WaitForChild("Animate", 5));
                                            if not Si or not gi or zi ~= i.generation or not E.Unwalk then
                                                return;
                                            end;
                                            i.animate = gi;
                                            i.disabledByUs = _i == gi and Li or gi:IsA("LocalScript") and not gi.Disabled;
                                            if gi:IsA("LocalScript") then
                                                gi.Disabled = true;
                                            end;
                                            local function _i ()
                                                if zi ~= i.generation or not E.Unwalk or xi ~= m.Character or Si.Parent ~= xi then
                                                    return;
                                                end;
                                                for xi, xi in ipairs(Si:GetPlayingAnimationTracks()) do
                                                    pcall(function() xi:Stop(0); end);
                                                end;
                                            end;
                                            i.animationConn = Si.AnimationPlayed:Connect(function(xi) if zi ~= i.generation or not E.Unwalk then return; end; pcall(function() xi:Stop(0); end); end);
                                            _i ();
                                        end;
                                        W.Unwalk = function(i)
                                            if i then
                                                ki(m.Character);
                                            else
                                                o();
                                                Pi(false);
                                            end;
                                        end;
                                        _G.__GhostDuelTrackStopper (function() o(); Pi(true); end);
                                        _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(i) if not E.Unwalk then return; end; task.defer(function() ki(i); end); end));
                                        if E.Unwalk then
                                            task.defer(function() ki(m.Character); end);
                                        end;
                                    end;
                                    do
                                        local i;
                                        local o = false;
                                        local function Pi()
                                            local ki = m.Character;
                                            if not ki then
                                                return nil;
                                            end;
                                            local xi = ki:FindFirstChildOfClass("Tool");
                                            if xi and(xi.Name:lower():find("bat")) then
                                                return xi;
                                            end;
                                            xi = m:FindFirstChild("Backpack");
                                            if xi then
                                                local _i = ki:FindFirstChildOfClass("Humanoid");
                                                for Li, Li in ipairs(xi:GetChildren()) do
                                                    if Li:IsA("Tool") and(Li.Name:lower():find("bat")) then
                                                        if _i then
                                                            pcall(function() _i:EquipTool(Li); end);
                                                        end;
                                                        return ki:FindFirstChild(Li.Name) or Li;
                                                    end;
                                                end;
                                            end;
                                            return nil;
                                        end;
                                        local function ki(xi)
                                            local _i, Li = math.huge;
                                            for zi, Si in ipairs(K:GetPlayers()) do
                                                if Si ~= m and Si.Character then
                                                    local gi, Oi = Si.Character:FindFirstChild("HumanoidRootPart"), Si.Character:FindFirstChildOfClass("Humanoid");
                                                    if gi and Oi and Oi.Health > 0 then
                                                        zi = (xi.Position - gi.Position).Magnitude;
                                                        if zi < _i then
                                                            _i, Li = zi, gi;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            return Li, _i;
                                        end;
                                        local function xi()
                                            if a or not E["Ragdoll Counter"] then
                                                return;
                                            end;
                                            local _i = m.Character;
                                            local Li, zi = _i and(_i:FindFirstChildOfClass("Humanoid")), _i and(_i:FindFirstChild("HumanoidRootPart"));
                                            if not _i or not Li or not zi or Li.Health <= 0 then
                                                return;
                                            end;
                                            local _i, Si = ki(zi);
                                            if _i and Si <= 4 then
                                                local ki = Vector3.new(_i.Position.X, zi.Position.Y, _i.Position.Z);
                                                if(ki - zi.Position).Magnitude > 0.01 then
                                                    pcall(function() Li.AutoRotate = false; zi.CFrame = CFrame.lookAt(zi.Position, ki); end);
                                                end;
                                            end;
                                            local ki = Pi();
                                            if ki then
                                                pcall(function() ki:Activate(); end);
                                                local Pi = ki:FindFirstChildWhichIsA("RemoteEvent", true);
                                                if Pi then
                                                    pcall(function() Pi:FireServer(); end);
                                                end;
                                            end;
                                            task.defer(function() if Li.Parent then Li.AutoRotate = true; end; end);
                                        end;
                                        local function Pi()
                                            if i then
                                                return;
                                            end;
                                            local ki = m.Character;
                                            if not ki then
                                                return;
                                            end;
                                            local _i, Li = ki:FindFirstChildOfClass("Humanoid"), ki:FindFirstChild("HumanoidRootPart");
                                            if not _i or not Li then
                                                return;
                                            end;
                                            i = {};
                                            ki, Li = pcall(function() return _i.StateChanged:Connect(function(zi, Si) if a or not E["Ragdoll Counter"] then return; end; zi = Si == Enum.HumanoidStateType.Physics or Si == Enum.HumanoidStateType.Ragdoll or Si == Enum.HumanoidStateType.FallingDown; if zi and not o then o = true; pcall(function() xi(); end); else Si = not zi and o; if Si then o = false; end; end; end); end);
                                            if ki and Li then
                                                table.insert(i, Li);
                                            end;
                                            ki, Li = pcall(function() return _i:GetPropertyChangedSignal("PlatformStand"):Connect(function() if a or not E["Ragdoll Counter"] then return; end; if _i.PlatformStand and not o then o = true; pcall(function() xi(); end); else local a = _i.PlatformStand; if not a then o = false; end; end; end); end);
                                            if ki and Li then
                                                table.insert(i, Li);
                                            end;
                                        end;
                                        local function a()
                                            if i then
                                                for ki, ki in ipairs(i) do
                                                    pcall(function() ki:Disconnect(); end);
                                                end;
                                                i = nil;
                                            end;
                                            o = false;
                                        end;
                                        W["Ragdoll Counter"] = function(i)
                                            if i then
                                                Pi();
                                            else
                                                a();
                                            end;
                                        end;
                                        _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() task.wait(0.5); o = false; if E["Ragdoll Counter"] then a(); Pi(); end; end));
                                        if E["Ragdoll Counter"] then
                                            Pi();
                                        end;
                                    end;
                                    do
                                        local i, o, a, Pi = false, 0, false, {};
                                        local function ki()
                                            local xi = m.Character;
                                            if not xi then
                                                return nil;
                                            end;
                                            for _i, _i in ipairs(xi:GetChildren()) do
                                                if _i:IsA("Tool") and(_i.Name:lower():find("medusa") or(_i.Name:lower():find("head")) or(_i.Name:lower():find("stone"))) then
                                                    return _i;
                                                end;
                                            end;
                                            xi = m:FindFirstChild("Backpack");
                                            if xi then
                                                for _i, _i in ipairs(xi:GetChildren()) do
                                                    if _i:IsA("Tool") and(_i.Name:lower():find("medusa") or(_i.Name:lower():find("head")) or(_i.Name:lower():find("stone"))) then
                                                        return _i;
                                                    end;
                                                end;
                                            end;
                                            return nil;
                                        end;
                                        local function xi()
                                            if not a then
                                                return;
                                            end;
                                            if i then
                                                return;
                                            end;
                                            if tick() - o < 25 then
                                                return;
                                            end;
                                            local _i = m.Character;
                                            if not _i then
                                                return;
                                            end;
                                            i = true;
                                            local Li = ki();
                                            if not Li then
                                                i = false;
                                                return;
                                            end;
                                            if Li.Parent ~= _i then
                                                local ki = _i:FindFirstChildOfClass("Humanoid");
                                                if ki then
                                                    pcall(function() ki:EquipTool(Li); end);
                                                end;
                                                task.wait(0.05);
                                            end;
                                            pcall(function() Li:Activate(); end);
                                            o, i = tick(), false;
                                        end;
                                        local function i(o)
                                            return o:GetPropertyChangedSignal("Anchored"):Connect(function() if a and o.Anchored and o.Transparency == 1 then xi(); end; end);
                                        end;
                                        local function o(ki)
                                            for xi, xi in pairs(Pi) do
                                                pcall(function() xi:Disconnect(); end);
                                            end;
                                            Pi = {};
                                            if not ki then
                                                return;
                                            end;
                                            for xi, xi in ipairs(ki:GetDescendants()) do
                                                if xi:IsA("BasePart") then
                                                    table.insert(Pi, i(xi));
                                                end;
                                            end;
                                            table.insert(Pi, ki.DescendantAdded:Connect(function(ki) if ki:IsA("BasePart") then table.insert(Pi, i(ki)); end; end));
                                        end;
                                        local function i()
                                            a = true;
                                            if m.Character then
                                                o(m.Character);
                                            end;
                                        end;
                                        local function ki()
                                            a = false;
                                            for xi, xi in pairs(Pi) do
                                                pcall(function() xi:Disconnect(); end);
                                            end;
                                            Pi = {};
                                        end;
                                        _G.__GhostDuelTrackStopper (ki);
                                        W["Medusa Counter"] = function(Pi)
                                            if Pi then
                                                i();
                                            else
                                                ki();
                                            end;
                                        end;
                                        _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(Pi) task.wait(0.5); if a then o(Pi); end; end));
                                        if E["Medusa Counter"] then
                                            i();
                                        end;
                                    end;
                                    do
                                        local i = m;
                                        local function o()
                                            local a = i.Character;
                                            if a then
                                                local Pi = a:FindFirstChildOfClass("Tool");
                                                if Pi then
                                                    local a = Pi.Name:lower();
                                                    if a:find("bat", 1, true) or(a:find("slap", 1, true)) then
                                                        return Pi;
                                                    end;
                                                end;
                                                Pi = i:FindFirstChildOfClass("Backpack");
                                                if Pi then
                                                    for i, a in ipairs(Pi:GetChildren()) do
                                                        if a:IsA("Tool") then
                                                            i = a.Name:lower();
                                                            if i:find("bat", 1, true) or(i:find("slap", 1, true)) then
                                                                return a;
                                                            end;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            return nil;
                                        end;
                                        local i;
                                        _G.__GhostDuelAceNormalAimbot = _G.__GhostDuelAceNormalAimbot or {target = nil, swingCooldown = false, nextSwingAt = 0};
                                        local function a(Pi)
                                            if not Pi then
                                                return nil;
                                            end;
                                            local ki, xi, _i = Pi.CFrame, pcall(Pi.GetRenderCFrame, Pi);
                                            return if xi and _i then
                                                _i
                                            else
                                                ki;
                                            end;
                                            function _cypherStartFollowing (Pi)
                                                Pi = Pi or m.Character;
                                                local ki, xi = Pi and(Pi:FindFirstChildOfClass("Humanoid")), Pi and(Pi:FindFirstChild("HumanoidRootPart"));
                                                if not ki or not xi then
                                                    return;
                                                end;
                                                if i then
                                                    i:Disconnect();
                                                    i = nil;
                                                end;
                                                _G.__GhostDuelAceNormalAimbot.nextSwingAt = 0;
                                                _G.__GhostDuelAceNormalAimbot.swingCooldown = false;
                                                ki.AutoRotate = false;
                                                xi = Pi:FindFirstChildOfClass("Tool") or(o());
                                                if xi and xi.Parent ~= Pi then
                                                    pcall(ki.EquipTool, ki, xi);
                                                end;
                                                i = c.RenderStepped:Connect(function() if not E.Aimbot then return; end; local Pi = m.Character; if not Pi then return; end; local ki, xi = Pi:FindFirstChild("HumanoidRootPart"), Pi:FindFirstChildOfClass("Humanoid"); if not ki or not xi then return; end; if xi.AutoRotate then xi.AutoRotate = false; end; local _i = Pi:FindFirstChildOfClass("Tool") or(o()); if _i and _i.Parent ~= Pi then pcall(xi.EquipTool, xi, _i); end; xi = nil; if _G.__GhostDuelTPBatGetMarkerCFrame then local Li, zi = pcall(_G.__GhostDuelTPBatGetMarkerCFrame); xi = if Li then zi else xi; end; local Li, zi; Pi = _G.__GhostDuelGetVisualEnemy and(_G.__GhostDuelGetVisualEnemy ()); if Pi and Pi ~= m and Pi.Character then local Si, gi = Pi.Character:FindFirstChild("HumanoidRootPart"), Pi.Character:FindFirstChildOfClass("Humanoid"); if Si and gi and gi.Health > 0 then Li, zi = Si, (a(Si)); end; end; if not xi and(not Li or not zi) then return; end; _G.__GhostDuelAceNormalAimbot.target = xi or Li; Li, Pi = ki.Position, (xi or zi).Position; zi = Pi - Li; local a, xi, Si = Vector3.new(zi.X, 0, zi.Z), E["Lagger Aimbot"] and 34 or(_ == "Lagger" and 40 or 58), Vector3.zero; Si = if a.Magnitude >= 0.01 then a.Unit * xi else Si; xi = (Pi.Y - Li.Y) * 19.5; xi = math.clamp(xi,- 70, 110); ki.AssemblyLinearVelocity = Vector3.new(Si.X, xi, Si.Z); if(Pi - Li).Magnitude > 0.1 then zi = CFrame.lookAt(Li, Pi); xi, Si, a = (ki.CFrame:Inverse() * zi):ToEulerAnglesXYZ(); xi, Si, a = math.clamp(xi,- 2.5, 2.5), math.clamp(Si,- 2.5, 2.5), math.clamp(a,- 2.5, 2.5); ki.AssemblyAngularVelocity = ki.CFrame:VectorToWorldSpace(Vector3.new(xi * 42, Si * 42, a * 42)); end; Pi = tick(); if _i and Pi >= (_G.__GhostDuelAceNormalAimbot.nextSwingAt or 0) then _G.__GhostDuelAceNormalAimbot.nextSwingAt = Pi + 0.08; pcall(_i.Activate, _i); end; end);
                                            end;
                                            function _cypherStop ()
                                                if i then
                                                    i:Disconnect();
                                                    i = nil;
                                                end;
                                                if _G.__GhostDuelAceNormalAimbot then
                                                    _G.__GhostDuelAceNormalAimbot.target = nil;
                                                    _G.__GhostDuelAceNormalAimbot.swingCooldown = false;
                                                    _G.__GhostDuelAceNormalAimbot.nextSwingAt = 0;
                                                end;
                                                local i = m.Character;
                                                local a = i and(i:FindFirstChild("HumanoidRootPart"));
                                                if a then
                                                    a.AssemblyLinearVelocity = Vector3.zero;
                                                    a.AssemblyAngularVelocity = Vector3.zero;
                                                end;
                                                a = i and(i:FindFirstChildOfClass("Humanoid"));
                                                if a then
                                                    a.AutoRotate = true;
                                                end;
                                            end;
                                            _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(i) task.wait(0.5); if E.Aimbot then _cypherStartFollowing (i); end; end));
                                            W.Aimbot = function(i)
                                                if i then
                                                    if _G.__stopSpeedBoost then
                                                        _G.__stopSpeedBoost ();
                                                    end;
                                                    if autoplayActive or E.Autoplay then
                                                        _G.__stopAutoplay ();
                                                    end;
                                                    ci("Aimbot");
                                                    if _G.__deactivateBatExclusive then
                                                        _G.__deactivateBatExclusive ("Aimbot");
                                                    end;
                                                    _G.__checkAndAutoDrop (function() local i = m.Character; if i then _cypherStartFollowing (i); end; end);
                                                else
                                                    _cypherStop ();
                                                    if _G.__refreshSpeedBoost then
                                                        _G.__refreshSpeedBoost ();
                                                    end;
                                                end;
                                            end;
                                            do
                                                pcall(function() local i = workspace:FindFirstChild("PredictionSphere"); if i then i:Destroy(); end; end);
                                                local i, a, Pi = {targetPlayer = nil, lastTargetPos = nil, targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero, velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {}, verticalVelocityHistory = {}, previousDirection = nil, lastDirectionChangeTime = 0, airborneTime = 0, lastYVelocity = 0, lastJumpTime = 0, lastActivationTime = 0, currentPing = 0.1, realPingMs = 0}, {FOLLOW_SPEED = 55, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1, PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150, VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80, SERVER_TICKRATE = 0.016666666666666666, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25, ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12, QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8, AERIAL_VELOCITY_DECAY = 0.95, MIN_AIRBORNE_TIME = 0.08, FALLING_SPEED_THRESHOLD =- 15};
                                                local function ki(xi)
                                                    if #xi == 0 then
                                                        return Vector3.zero;
                                                    end;
                                                    local _i = Vector3.zero;
                                                    for Li, Li in ipairs(xi) do
                                                        _i += Li;
                                                    end;
                                                    return _i / #xi;
                                                end;
                                                local function xi(_i, Li, zi)
                                                    table.insert(_i, Li);
                                                    if #_i > zi then
                                                        table.remove(_i, 1);
                                                    end;
                                                end;
                                                local function _i ()
                                                    i.targetPlayer = nil;
                                                    i.lastTargetPos = nil;
                                                    i.targetVelocity = Vector3.zero;
                                                    i.smoothedVelocity = Vector3.zero;
                                                    i.velocityHistory = {};
                                                    i.accelerationHistory = {};
                                                    i.aerialVelocityHistory = {};
                                                    i.verticalVelocityHistory = {};
                                                    i.previousDirection = nil;
                                                    i.airborneTime = 0;
                                                    i.lastYVelocity = 0;
                                                end;
                                                local function Li(zi)
                                                    local Si, gi = math.huge;
                                                    for Oi, ni in ipairs(K:GetPlayers()) do
                                                        if ni ~= m and ni.Character then
                                                            local Ji, fi = ni.Character:FindFirstChild("HumanoidRootPart"), ni.Character:FindFirstChildOfClass("Humanoid");
                                                            if Ji and fi and fi.Health > 0 then
                                                                Oi = (zi.Position - Ji.Position).Magnitude;
                                                                if Oi < Si then
                                                                    Si, gi = Oi, ni;
                                                                end;
                                                            end;
                                                        end;
                                                    end;
                                                    return gi;
                                                end;
                                                local function zi(Si, gi)
                                                    if gi.Magnitude < 0.01 then
                                                        return;
                                                    end;
                                                    local Oi = Si.CFrame.LookVector:Cross(gi.Unit);
                                                    gi = math.asin(math.clamp(Oi.Magnitude,- 1, 1));
                                                    Si.AssemblyAngularVelocity = Oi.Magnitude > 0.01 and Oi.Unit * gi * 80 or Vector3.zero;
                                                end;
                                                local function Si()
                                                    local gi, Oi = pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue(); end);
                                                    if gi and type(Oi) == "number" then
                                                        i.realPingMs = math.floor(Oi);
                                                    end;
                                                    i.currentPing = math.clamp(i.realPingMs / 1000, a.MIN_PING_COMPENSATION, a.MAX_PING_COMPENSATION);
                                                end;
                                                task.spawn(function() while _G.__GhostDuel_STATE == H do pcall(Si); task.wait(0.5); end; end);
                                                local function Si()
                                                    if Pi then
                                                        Pi:Disconnect();
                                                        Pi = nil;
                                                    end;
                                                    local gi = m.Character;
                                                    local Oi, ni = gi and(gi:FindFirstChildOfClass("Humanoid")), gi and(gi:FindFirstChild("HumanoidRootPart"));
                                                    if Oi then
                                                        Oi.AutoRotate = true;
                                                    end;
                                                    if ni then
                                                        ni.AssemblyAngularVelocity = Vector3.zero;
                                                    end;
                                                    _i ();
                                                    i.lastActivationTime = 0;
                                                end;
                                                local function gi(Oi)
                                                    Oi = Oi or m.Character;
                                                    local ni, Ji = Oi and(Oi:FindFirstChildOfClass("Humanoid")), Oi and(Oi:FindFirstChild("HumanoidRootPart"));
                                                    if not ni or not Ji then
                                                        return;
                                                    end;
                                                    Si();
                                                    ni.AutoRotate = false;
                                                    local fi = o();
                                                    if fi and fi.Parent ~= Oi then
                                                        pcall(ni.EquipTool, ni, fi);
                                                    end;
                                                    Pi = c.RenderStepped:Connect(function(Pi) if not E.Aimbot then Si(); return; end; local Oi = m.Character; local oi, qi = Oi and(Oi:FindFirstChild("HumanoidRootPart")), Oi and(Oi:FindFirstChildOfClass("Humanoid")); if not oi or not qi or qi.Health <= 0 then return; end; qi.AutoRotate = false; Ji, ni = oi, qi; fi = Oi:FindFirstChildOfClass("Tool") or(o()); if fi and fi.Parent ~= Oi then pcall(qi.EquipTool, qi, fi); end; Oi = nil; if _G.__GhostDuelTPBatGetMarkerCFrame then oi, qi = pcall(_G.__GhostDuelTPBatGetMarkerCFrame); Oi = if oi then qi else Oi; end; if Oi then oi = Oi.Position - Ji.Position; if oi.Magnitude > 0.1 then zi(Ji, oi); end; if oi.Magnitude > a.MIN_FOLLOW_DISTANCE then qi = tonumber(N.CypherAimbotApproachSpeed) or a.FOLLOW_SPEED; Ji.AssemblyLinearVelocity = oi.Unit * math.clamp(qi, 1, 120); else Ji.AssemblyLinearVelocity = Vector3.zero; end; return; end; i.targetPlayer = Li(Ji); oi = i.targetPlayer and i.targetPlayer.Character; qi, Oi = oi and(oi:FindFirstChild("HumanoidRootPart")), oi and(oi:FindFirstChildOfClass("Humanoid")); if not qi or not Oi or Oi.Health <= 0 then _i (); return; end; local o, _i = qi.Position, math.max(Pi, 0.004166666666666667); if i.lastTargetPos then oi = (o - i.lastTargetPos) / _i; Pi = oi - i.targetVelocity; oi = if Pi.Magnitude > a.MAX_VELOCITY_CHANGE then i.targetVelocity + Pi.Unit * a.MAX_VELOCITY_CHANGE else oi; qi = Vector3.new(oi.X, 0, oi.Z); if qi.Magnitude > a.MAX_HORIZONTAL_VELOCITY then qi = qi.Unit * a.MAX_HORIZONTAL_VELOCITY; oi = (Vector3.new(qi.X, oi.Y, qi.Z)); end; xi(i.accelerationHistory, (oi - i.targetVelocity) / _i, 4); xi(i.velocityHistory, oi, 8); xi(i.verticalVelocityHistory, oi.Y, 5); i.targetVelocity = oi; i.smoothedVelocity = i.smoothedVelocity:Lerp(oi, a.VELOCITY_SMOOTHING); end; i.lastTargetPos = o; Pi = Oi.FloorMaterial == Enum.Material.Air; i.airborneTime = Pi and i.airborneTime + _i or 0; if Pi and i.airborneTime >= a.MIN_AIRBORNE_TIME then xi(i.aerialVelocityHistory, i.targetVelocity, 6); elseif not Pi then i.aerialVelocityHistory = {}; end; qi = i.smoothedVelocity; if Pi and #i.aerialVelocityHistory > 0 then Oi = ki(i.aerialVelocityHistory); qi = Vector3.new(Oi.X, i.targetVelocity.Y, Oi.Z) * a.AIR_CONTROL_FACTOR; end; _i, Oi = false, Vector3.new(i.targetVelocity.X, 0, i.targetVelocity.Z); if Oi.Magnitude > 5 then oi = Oi.Unit; if i.previousDirection and i.previousDirection:Dot(oi) < 0.5 then _i = tick() - i.lastDirectionChangeTime < a.DIRECTION_CHANGE_DETECTION_TIME; i.lastDirectionChangeTime = tick(); end; i.previousDirection = oi; end; oi = i.currentPing + a.SERVER_TICKRATE; local xi, Li = o + qi * (if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) + ki(i.accelerationHistory) * a.ACCELERATION_PREDICTION_WEIGHT * ((if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) * (if _i then oi * a.QUICK_DIRECTION_CHANGE_MULTIPLIER else oi) * 0.5), a.PREDICTION_TIME * 1.1; xi = if Pi then xi + qi * Li + Vector3.new(0,- 0.5 * a.GRAVITY * Li * Li, 0) else xi + qi * Li; Oi = Vector3.new(qi.X, 0, qi.Z); Pi = (if Oi.Magnitude > 1 then xi + Oi.Unit * a.PREDICT_AHEAD else xi) - Ji.Position; zi(Ji, Pi); if(o - Ji.Position).Magnitude <= a.ACTIVATE_DISTANCE and tick() - i.lastActivationTime >= 0.3 then if fi then pcall(fi.Activate, fi); end; i.lastActivationTime = tick(); end; if Pi.Magnitude > a.MIN_FOLLOW_DISTANCE then qi = math.clamp(tonumber(N.CypherAimbotApproachSpeed) or a.FOLLOW_SPEED, 1, 120); Ji.AssemblyLinearVelocity = Pi.Unit * qi; else Ji.AssemblyLinearVelocity = Vector3.new(0, Ji.AssemblyLinearVelocity.Y * 0.5, 0); end; end);
                                                end;
                                                _cypherStartFollowing = gi;
                                                _cypherStop = Si;
                                                W.Aimbot = function(i)
                                                    if i then
                                                        if _G.__stopSpeedBoost then
                                                            _G.__stopSpeedBoost ();
                                                        end;
                                                        if autoplayActive or E.Autoplay then
                                                            _G.__stopAutoplay ();
                                                        end;
                                                        ci("Aimbot");
                                                        if _G.__deactivateBatExclusive then
                                                            _G.__deactivateBatExclusive ("Aimbot");
                                                        end;
                                                        _G.__checkAndAutoDrop (function() gi(m.Character); end);
                                                    else
                                                        Si();
                                                        if _G.__refreshSpeedBoost then
                                                            _G.__refreshSpeedBoost ();
                                                        end;
                                                    end;
                                                end;
                                                _G.__GhostDuelTrackStopper (Si);
                                            end;
                                            W["Lagger Aimbot"] = function(i)
                                                if i then
                                                    _G.__GhostDuelLaggerAimbotPreviousMode = _;
                                                    _G.__GhostDuelLaggerAimbotPreviousAimbot = E.Aimbot == true;
                                                    _G.__GhostDuelLaggerAimbotPreviousLagger = nil;
                                                    if _ ~= "Lagger" then
                                                        Ii("Lagger");
                                                    end;
                                                    if _G.GhostDuelLagger and _G.GhostDuelLagger.SetEnabled and _G.GhostDuelLagger.IsEnabled then
                                                        _G.__GhostDuelLaggerAimbotPreviousLagger = _G.GhostDuelLagger.IsEnabled() == true;
                                                        pcall(_G.GhostDuelLagger.SetEnabled, true);
                                                    else
                                                        if _G.__openLaggerGUI then
                                                            pcall(_G.__openLaggerGUI, false);
                                                        end;
                                                        task.spawn(function() for i = 1, 30, 1 do if not E["Lagger Aimbot"] then return; end; if _G.GhostDuelLagger and _G.GhostDuelLagger.SetEnabled and _G.GhostDuelLagger.IsEnabled then _G.__GhostDuelLaggerAimbotPreviousLagger = _G.GhostDuelLagger.IsEnabled() == true; pcall(_G.GhostDuelLagger.SetEnabled, true); return; end; task.wait(0.1); end; end);
                                                    end;
                                                    if not E.Aimbot then
                                                        E.Aimbot = true;
                                                        if U.Aimbot then
                                                            pcall(U.Aimbot);
                                                        end;
                                                        if W.Aimbot then
                                                            pcall(W.Aimbot, true);
                                                        end;
                                                    end;
                                                else
                                                    if _ == "Lagger" and _G.__GhostDuelLaggerAimbotPreviousMode and _G.__GhostDuelLaggerAimbotPreviousMode ~= "Lagger" then
                                                        Ii(_G.__GhostDuelLaggerAimbotPreviousMode);
                                                    end;
                                                    if not _G.__GhostDuelLaggerAimbotPreviousAimbot and E.Aimbot then
                                                        E.Aimbot = false;
                                                        if U.Aimbot then
                                                            pcall(U.Aimbot);
                                                        end;
                                                        if W.Aimbot then
                                                            pcall(W.Aimbot, false);
                                                        end;
                                                    end;
                                                    if _G.__GhostDuelLaggerAimbotPreviousLagger == false and _G.GhostDuelLagger and _G.GhostDuelLagger.SetEnabled then
                                                        pcall(_G.GhostDuelLagger.SetEnabled, false);
                                                    end;
                                                    _G.__GhostDuelLaggerAimbotPreviousMode = nil;
                                                    _G.__GhostDuelLaggerAimbotPreviousAimbot = nil;
                                                    _G.__GhostDuelLaggerAimbotPreviousLagger = nil;
                                                end;
                                            end;
                                            if E.Aimbot then
                                                task.defer(function() if E.Aimbot and W.Aimbot then W.Aimbot(true); end; end);
                                            end;
                                        end;
                                        do
                                            local i, o, a = false, {};
                                            local Pi, ki, xi = workspace.CurrentCamera, Color3.fromRGB(139, 72, 246), Color3.fromRGB(48, 16, 92);
                                            local function _i (Li)
                                                if _G.__GhostDuelGuiTheme == "GUI 3" then
                                                    return Color3.fromRGB(255, 45, 45), Color3.fromRGB(255, 45, 45);
                                                end;
                                                if _G.__GhostDuelGuiTheme == "GUI 2" then
                                                    return ki, ki;
                                                end;
                                                return Li or _G.__GhostDuelThemeAccent or(Color3.fromRGB(245, 245, 250)), Color3.fromRGB(0, 0, 0);
                                            end;
                                            local function Li()
                                                local zi, Si = _i ();
                                                local gi = {Tracer = Drawing.new("Line"), Highlight = Instance.new("Highlight"), Lines = {}};
                                                gi.Tracer.Color = Si;
                                                gi.Tracer.Thickness = 3;
                                                gi.Tracer.Transparency = 1;
                                                gi.Tracer.ZIndex = 2;
                                                gi.Highlight.Name = "ESP_Highlight";
                                                gi.Highlight.FillColor = zi;
                                                gi.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0);
                                                gi.Highlight.FillTransparency = 0.12;
                                                gi.Highlight.OutlineTransparency = 0.18;
                                                gi.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                                                local Oi;
                                                local ni, Ji = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui"); end);
                                                if ni and Ji then
                                                    Oi = Ji;
                                                else
                                                    Oi = m:FindFirstChildOfClass("PlayerGui");
                                                end;
                                                if not Oi then
                                                    Oi = game:GetService("CoreGui");
                                                end;
                                                pcall(function() gi.Highlight.Parent = Oi; end);
                                                Ji = Instance.new("BillboardGui");
                                                Ji.Name = "ESP_Name";
                                                Ji.Size = UDim2.new(0, 170, 0, 28);
                                                Ji.StudsOffset = Vector3.new(0, 1.3, 0);
                                                Ji.AlwaysOnTop = true;
                                                Ji.Parent = Oi;
                                                ni = Instance.new("TextLabel");
                                                ni.Size = UDim2.new(0, 170, 0, 28);
                                                ni.AnchorPoint = Vector2.new(0.5, 0);
                                                ni.Position = UDim2.new(0.5, 0, 0, 2);
                                                ni.BackgroundTransparency = 1;
                                                ni.Text = tostring(currentPresetName or "");
                                                ni.TextColor3 = _G.__GhostDuelGuiTheme == "GUI 3" and(Color3.fromRGB(255, 45, 45)) or(_G.__GhostDuelGuiTheme == "GUI 2" and ki or(Color3.fromRGB(245, 245, 255)));
                                                ni.TextSize = 15;
                                                ni.Font = Enum.Font.GothamBold;
                                                ni.TextStrokeColor3 = _G.__GhostDuelGuiTheme == "GUI 2" and xi or(Color3.fromRGB(0, 0, 0));
                                                ni.TextStrokeTransparency = 0;
                                                ni.TextXAlignment = Enum.TextXAlignment.Center;
                                                ni.TextYAlignment = Enum.TextYAlignment.Center;
                                                ni.ZIndex = 5;
                                                ni.Parent = Ji;
                                                zi = Instance.new("UIStroke");
                                                zi.Color = _G.__GhostDuelGuiTheme == "GUI 2" and xi or(Color3.fromRGB(0, 0, 0));
                                                zi.Thickness = 2.2;
                                                zi.Transparency = 0.12;
                                                zi.Parent = ni;
                                                for Oi = 1, 14, 1 do
                                                    Oi = Drawing.new("Line");
                                                    Oi.Color = Si;
                                                    Oi.Thickness = 2;
                                                    Oi.Transparency = 1;
                                                    Oi.ZIndex = 3;
                                                    table.insert(gi.Lines, Oi);
                                                end;
                                                gi.NameTag = Ji;
                                                gi.NameLabel = ni;
                                                gi.NameOutline = zi;
                                                return gi;
                                            end;
                                            function _G.__GhostDuelRefreshESPTheme (zi, Si)
                                                local Si, gi = _i (zi);
                                                for zi, zi in pairs(o) do
                                                    if type(zi) == "table" and zi.esp then
                                                        local Oi = zi.esp;
                                                        if Oi.Tracer then
                                                            pcall(function() Oi.Tracer.Color = gi; end);
                                                        end;
                                                        if Oi.Highlight then
                                                            Oi.Highlight.FillColor = Si;
                                                            Oi.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0);
                                                        end;
                                                        if Oi.NameLabel then
                                                            Oi.NameLabel.TextColor3 = _G.__GhostDuelGuiTheme == "GUI 3" and(Color3.fromRGB(255, 45, 45)) or(_G.__GhostDuelGuiTheme == "GUI 2" and ki or(Color3.fromRGB(245, 245, 255)));
                                                            Oi.NameLabel.TextStrokeColor3 = _G.__GhostDuelGuiTheme == "GUI 2" and xi or(Color3.fromRGB(0, 0, 0));
                                                        end;
                                                        if Oi.NameOutline then
                                                            Oi.NameOutline.Color = _G.__GhostDuelGuiTheme == "GUI 2" and xi or(Color3.fromRGB(0, 0, 0));
                                                        end;
                                                        for zi, zi in ipairs(Oi.Lines or {}) do
                                                            pcall(function() zi.Color = gi; end);
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            local function zi(Si)
                                                local gi = o[Si];
                                                if gi then
                                                    if gi.esp.Tracer then
                                                        pcall(function() gi.esp.Tracer:Remove(); end);
                                                    end;
                                                    if gi.esp.Highlight then
                                                        pcall(function() gi.esp.Highlight:Destroy(); end);
                                                    end;
                                                    if gi.esp.NameTag then
                                                        pcall(function() gi.esp.NameTag:Destroy(); end);
                                                    end;
                                                    for Oi, Oi in ipairs(gi.esp.Lines) do
                                                        pcall(function() Oi:Remove(); end);
                                                    end;
                                                    if gi.loopConn then
                                                        pcall(function() gi.loopConn:Disconnect(); end);
                                                    end;
                                                    o[Si] = nil;
                                                end;
                                            end;
                                            local function Si(gi, Oi)
                                                if not i then
                                                    Oi.Tracer.Visible = false;
                                                    Oi.Highlight.Enabled = false;
                                                    for ni, ni in ipairs(Oi.Lines) do
                                                        ni.Visible = false;
                                                    end;
                                                    return;
                                                end;
                                                local ni = gi.Character;
                                                local Ji, fi = ni and(ni:FindFirstChildOfClass("Humanoid")), ni and(ni:FindFirstChild("HumanoidRootPart") or ni.PrimaryPart or(ni:FindFirstChild("UpperTorso")) or(ni:FindFirstChild("Torso")) or(ni:FindFirstChild("Head")));
                                                if ni and fi and(not Ji or Ji.Health > 0) then
                                                    Oi.Highlight.Adornee = ni;
                                                    Oi.Highlight.Enabled = E["ESP Players"] or false;
                                                    local ni, ni = Pi:WorldToViewportPoint(fi.Position);
                                                    if ni then
                                                        Oi.Tracer.Visible = false;
                                                    else
                                                        for Pi, Pi in ipairs(Oi.Lines) do
                                                            Pi.Visible = false;
                                                        end;
                                                    end;
                                                    if Oi.NameTag and Oi.NameLabel then
                                                        pcall(function() Oi.NameTag.Adornee = fi; Oi.NameTag.Enabled = E["ESP Players"] or false; Oi.NameLabel.Text = gi.Name or gi.DisplayName or ""; local Pi = _G.__GhostDuelGuiTheme == "GUI 2"; Oi.NameLabel.TextColor3 = _G.__GhostDuelGuiTheme == "GUI 3" and(Color3.fromRGB(255, 45, 45)) or(Pi and ki or(Color3.fromRGB(245, 245, 255))); Oi.NameLabel.TextStrokeColor3 = Pi and xi or(Color3.fromRGB(0, 0, 0)); if Oi.NameOutline then Oi.NameOutline.Color = Pi and xi or(Color3.fromRGB(0, 0, 0)); end; end);
                                                    end;
                                                else
                                                    Oi.Tracer.Visible = false;
                                                    Oi.Highlight.Enabled = false;
                                                    Oi.Highlight.Adornee = nil;
                                                    for Pi, Pi in ipairs(Oi.Lines) do
                                                        Pi.Visible = false;
                                                    end;
                                                    if Oi.NameTag and Oi.NameLabel then
                                                        pcall(function() Oi.NameTag.Enabled = false; end);
                                                    end;
                                                end;
                                            end;
                                            local function Pi(ki)
                                                if ki == m then
                                                    return;
                                                end;
                                                if o[ki] and o[ki].esp then
                                                    if o[ki].esp.NameTag then
                                                        pcall(function() o[ki].esp.NameTag.Enabled = E["ESP Players"] or false; end);
                                                    end;
                                                    return;
                                                end;
                                                zi(ki);
                                                o[ki] = {esp = Li()};
                                            end;
                                            local function ki()
                                                if i then
                                                    return;
                                                end;
                                                i = true;
                                                for xi, xi in pairs(K:GetPlayers()) do
                                                    if xi ~= m then
                                                        task.spawn(function() Pi(xi); end);
                                                    end;
                                                end;
                                                local xi = 0;
                                                if a then
                                                    a:Disconnect();
                                                end;
                                                a = c.Heartbeat:Connect(function(Li) xi += Li or 0; if xi < 0.5 then return; end; xi = 0; for xi, Li in pairs(o) do if typeof(xi) == "Instance" and(xi:IsA("Player")) and Li and Li.esp then pcall(function() Si(xi, Li.esp); end); end; end; end);
                                                local xi, Li = K.PlayerAdded:Connect(function(Si) if not i or Si == m then return; end; task.wait(0.3); Pi(Si); end), K.PlayerRemoving:Connect(function(Pi) zi(Pi); end);
                                                o._joinConn = xi;
                                                o._leaveConn = Li;
                                            end;
                                            local function Pi()
                                                i = false;
                                                if a then
                                                    a:Disconnect();
                                                    a = nil;
                                                end;
                                                if o._joinConn then
                                                    pcall(function() o._joinConn:Disconnect(); end);
                                                    o._joinConn = nil;
                                                end;
                                                if o._leaveConn then
                                                    pcall(function() o._leaveConn:Disconnect(); end);
                                                    o._leaveConn = nil;
                                                end;
                                                for i in pairs(o) do
                                                    if typeof(i) == "Instance" and(i:IsA("Player")) and i ~= m then
                                                        zi(i);
                                                    end;
                                                end;
                                            end;
                                            _G.__GhostDuelTrackStopper (Pi);
                                            W["ESP Players"] = function(i)
                                                if i then
                                                    ki();
                                                else
                                                    Pi();
                                                end;
                                            end;
                                            if E["ESP Players"] then
                                                ki();
                                            end;
                                            local i = _G.__GhostDuelPlayerTracerLine;
                                            if i then
                                                pcall(function() i:Remove(); end);
                                            end;
                                            local i = Instance.new("ScreenGui");
                                            i.Name = "GhostDuelPlayerTracerOverlay";
                                            i.IgnoreGuiInset = true;
                                            i.ResetOnSpawn = false;
                                            i.DisplayOrder = 1000;
                                            i.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                                            i.Parent = m:WaitForChild("PlayerGui");
                                            local o = Instance.new("Frame");
                                            o.Name = "ESPLine";
                                            o.AnchorPoint = Vector2.new(0.5, 0.5);
                                            o.BorderSizePixel = 0;
                                            o.Active = false;
                                            o.Visible = false;
                                            o.ZIndex = 1;
                                            o.Parent = i;
                                            Ei = Instance.new("UIStroke", o);
                                            Ei.Color = Color3.fromRGB(255, 255, 255);
                                            Ei.Thickness = 0.7;
                                            Ei.Transparency = 0.45;
                                            _G.__GhostDuelPlayerTracerLine = {Remove = function() i:Destroy(); end};
                                            _G.__GhostDuelTrackStopper (function() i:Destroy(); end);
                                            local i = {scanElapsed = math.huge, targetRoot = nil};
                                            _G.__GhostDuelTrackConn (c.RenderStepped:Connect(function(a) if not E["Player Tracers"] then if o.Visible then o.Visible = false; end; i.targetRoot = nil; i.scanElapsed = math.huge; return; end; if not pcall(function() local Ei, Pi = workspace.CurrentCamera, m.Character; local ki = Pi and(Pi:FindFirstChild("LowerTorso") or(Pi:FindFirstChild("HumanoidRootPart")) or(Pi:FindFirstChild("Torso"))); if not Ei or not ki then o.Visible = false; return; end; Pi = ki.Position; i.scanElapsed = i.scanElapsed + (a or 0); local a = i.targetRoot; local xi = a and a.Parent; local Li = xi and(xi:FindFirstChildOfClass("Humanoid")); xi = a and a.Parent and(not Li or Li.Health > 0); if i.scanElapsed >= 0.12 or not xi then i.scanElapsed = 0; Li, a = math.huge; for zi, Si in ipairs(K:GetPlayers()) do if Si ~= m then zi = Si.Character; local Si, gi = zi and(zi:FindFirstChildOfClass("Humanoid")), zi and(zi:FindFirstChild("HumanoidRootPart") or(zi:FindFirstChild("LowerTorso")) or(zi:FindFirstChild("Torso"))); if gi and(gi:IsA("BasePart")) and(not Si or Si.Health > 0) then local zi = gi.Position - Pi; local Si = zi:Dot(zi); if Si < Li then Li, a = Si, gi; end; end; end; end; i.targetRoot = a; end; Li = i.targetRoot; if not Li or not Li.Parent then o.Visible = false; return; end; a, xi = Li.Position, Ei:WorldToViewportPoint(Pi - Vector3.new(0, ki.Size.Y * 0.35, 0)); ki, Pi = Ei:WorldToViewportPoint(a); local i, zi, Si = Ei.ViewportSize, Vector2.new(xi.X, xi.Y), Vector2.new(ki.X, ki.Y); if not Pi or ki.Z <= 0 then a = i * 0.5; Ei = Si - a; Ei = if(if ki.Z <= 0 then- Ei else Ei).Magnitude < 0.001 then(Vector2.new(0,- 1)) else if ki.Z <= 0 then- Ei else Ei; Li = Vector2.new(math.max(8, a.X - 8), math.max(8, a.Y - 8)); local Pi, gi = Li.X / math.max(math.abs(Ei.X), 0.001), Li.Y / math.max(math.abs(Ei.Y), 0.001); Si = a + Ei * math.min(Pi, gi); end; zi = if xi.Z <= 0 or zi.X < 0 or zi.X > i.X or zi.Y < 0 or zi.Y > i.Y then(Vector2.new(i.X * 0.5, i.Y - 8)) else zi; a, ki = Si - zi, (zi + Si) * 0.5; o.Position = UDim2.fromOffset(ki.X, ki.Y); o.Size = UDim2.fromOffset(math.max(a.Magnitude, 1), 2); o.Rotation = math.deg(math.atan2(a.Y, a.X)); zi, a = _i (); o.BackgroundColor3 = a; o.Visible = true; end) then pcall(function() o.Visible = false; end); end; end));
                                        end;
                                        local function i(o, a, Ei)
                                            local Pi = Instance.new("Frame");
                                            Pi.Name = tostring(Ei or a or "Input") .. "Stub";
                                            Pi.BackgroundTransparency = 1;
                                            Pi.Visible = false;
                                            Pi.Parent = o;
                                            return {container = Pi, input = nil, activeRef = function() return E[Ei] == true; end};
                                        end;
                                        local o, a = {}, {"Movement", "Combat", "Visuals", "Animations"};
                                        local function Ei(Pi)
                                            local ki = Instance.new("ScrollingFrame", Qi);
                                            ki.Name = Pi .. "PageStub";
                                            ki.BackgroundTransparency = 1;
                                            ki.BorderSizePixel = 0;
                                            ki.ScrollBarThickness = 0;
                                            ki.Visible = false;
                                            o[Pi] = ki;
                                        end;
                                        for Qi, Qi in ipairs(a) do
                                            Ei(Qi);
                                        end;
                                        (function(Qi) if not o[Qi] then return; end; for Pi, ki in pairs(o) do ki.Visible = Pi == Qi; end; end)("Movement");
                                        _speedCardRefs = _speedCardRefs or {};
                                        local function Qi(Pi, ki, xi, _i, Li, Li)
                                            _i = Instance.new("Frame");
                                            _i.Name = tostring(xi or ki or "Speed") .. "SpeedStub";
                                            _i.BackgroundTransparency = 1;
                                            _i.Visible = false;
                                            _i.Parent = Pi;
                                            if Li then
                                                FeatureToggles[Li] = function()
                                                    Ii(xi);
                                                end;
                                            end;
                                            return _i;
                                        end;
                                        local Pi = Vi(o.Movement, "SPEED");
                                        Qi(Pi, "Normal Speed", "Normal", "NormalBoost", "NormalSteal", "SelectNormalMode");
                                        Qi(Pi, "Lagger Speed", "Lagger", "LaggerBoost", "LaggerSteal", "SelectLaggerMode");
                                        local function ki(xi)
                                            local _i, Li, zi = "SelectCustomMode_" .. xi.name, "CustomBoost_" .. xi.name, "CustomSteal_" .. xi.name;
                                            N[Li] = xi.boost;
                                            N[zi] = xi.steal;
                                            FeatureToggles[_i] = function()
                                                Ii(xi.name);
                                            end;
                                            local Si = Qi(Pi, xi.name, xi.name, Li, zi, _i);
                                            _i = Instance.new("TextButton", Si);
                                            _i.Size = UDim2.new(0, 18, 0, 18);
                                            _i.AnchorPoint = Vector2.new(1, 1);
                                            _i.Position = UDim2.new(1,- 8, 1,- 8);
                                            _i.ZIndex = 30;
                                            _i.BackgroundColor3 = Color3.fromRGB(240, 200, 200);
                                            _i.BorderSizePixel = 0;
                                            _i.Text = "x";
                                            _i.TextColor3 = Color3.fromRGB(180, 60, 60);
                                            _i.TextSize = 11;
                                            _i.Font = Enum.Font.GothamBold;
                                            _i.AutoButtonColor = false;
                                            _i.TextXAlignment = Enum.TextXAlignment.Center;
                                            _i.TextYAlignment = Enum.TextYAlignment.Center;
                                            Instance.new("UICorner", _i).CornerRadius = UDim.new(0, 4);
                                            u(_i, function() for Qi = #I, 1,- 1 do if I[Qi].name == xi.name then table.remove(I, Qi); break; end; end; if _ == xi.name then Ii("Normal"); end; pcall(function() Si:Destroy(); end); mi(); end);
                                            return Si;
                                        end;
                                        for Qi, Qi in ipairs(I) do
                                            pcall(function() ki(Qi); end);
                                        end;
                                        do
                                            ii = Instance.new("TextButton", Pi);
                                            ii.Size = UDim2.new(1,- 2, 0, 28);
                                            ii.BackgroundColor3 = Color3.fromRGB(235, 240, 245);
                                            ii.BackgroundTransparency = 0.55;
                                            ii.BorderSizePixel = 0;
                                            ii.Text = "+ Add Custom Speed";
                                            ii.TextColor3 = Color3.fromRGB(100, 140, 200);
                                            ii.TextSize = 11;
                                            ii.Font = Enum.Font.GothamBold;
                                            ii.AutoButtonColor = false;
                                            Instance.new("UICorner", ii).CornerRadius = UDim.new(0, 6);
                                            a = Instance.new("UIStroke", ii);
                                            a.Color = Color3.fromRGB(0, 0, 0);
                                            a.Thickness = 1;
                                            a.Transparency = 0.3;
                                            local Qi;
                                            u(ii, function() if Qi then pcall(function() Qi:Destroy(); end); Qi = nil; return; end; Qi = Instance.new("Frame", Pi); Qi.Size = UDim2.new(1,- 2, 0, 96); Qi.BackgroundColor3 = Color3.fromRGB(230, 238, 245); Qi.BorderSizePixel = 0; Instance.new("UICorner", Qi).CornerRadius = UDim.new(0, 6); local ii = Instance.new("UIStroke", Qi); ii.Color = Color3.fromRGB(0, 0, 0); ii.Thickness = 1; ii = Instance.new("TextLabel", Qi); ii.Size = UDim2.new(0, 40, 0, 14); ii.Position = UDim2.new(0, 8, 0, 6); ii.BackgroundTransparency = 1; ii.Text = "Name"; ii.TextColor3 = Color3.fromRGB(100, 140, 190); ii.TextSize = 9; ii.Font = Enum.Font.GothamBold; ii.TextXAlignment = Enum.TextXAlignment.Left; local Pi = Instance.new("TextBox", Qi); Pi.Size = UDim2.new(0, 120, 0, 20); Pi.Position = UDim2.new(0, 8, 0, 21); Pi.BackgroundColor3 = Color3.fromRGB(245, 247, 250); Pi.BorderSizePixel = 0; Pi.Text = ""; Pi.PlaceholderText = "My Speed"; Pi.Font = Enum.Font.GothamBold; Pi.TextSize = 11; Pi.TextColor3 = Color3.fromRGB(30, 90, 200); Pi.ClearTextOnFocus = false; Instance.new("UICorner", Pi).CornerRadius = UDim.new(0, 4); ii = Instance.new("UIStroke", Pi); ii.Color = Color3.fromRGB(0, 0, 0); ii.Thickness = 1; ii = Instance.new("TextLabel", Qi); ii.Size = UDim2.new(0, 50, 0, 14); ii.Position = UDim2.new(0, 140, 0, 6); ii.BackgroundTransparency = 1; ii.Text = "Boost"; ii.TextColor3 = Color3.fromRGB(100, 140, 190); ii.TextSize = 9; ii.Font = Enum.Font.GothamBold; ii.TextXAlignment = Enum.TextXAlignment.Left; local xi = Instance.new("TextBox", Qi); xi.Size = UDim2.new(0, 56, 0, 20); xi.Position = UDim2.new(0, 140, 0, 21); xi.BackgroundColor3 = Color3.fromRGB(220, 238, 255); xi.BorderSizePixel = 0; xi.Text = "59"; xi.Font = Enum.Font.GothamBold; xi.TextSize = 12; xi.TextColor3 = Color3.fromRGB(30, 90, 200); xi.TextXAlignment = Enum.TextXAlignment.Center; xi.ClearTextOnFocus = false; Instance.new("UICorner", xi).CornerRadius = UDim.new(0, 5); ii = Instance.new("UIStroke", xi); ii.Color = Color3.fromRGB(0, 0, 0); ii.Thickness = 1; ii = Instance.new("TextLabel", Qi); ii.Size = UDim2.new(0, 50, 0, 14); ii.Position = UDim2.new(0, 204, 0, 6); ii.BackgroundTransparency = 1; ii.Text = "Steal"; ii.TextColor3 = Color3.fromRGB(100, 140, 190); ii.TextSize = 9; ii.Font = Enum.Font.GothamBold; ii.TextXAlignment = Enum.TextXAlignment.Left; local _i = Instance.new("TextBox", Qi); _i.Size = UDim2.new(0, 56, 0, 20); _i.Position = UDim2.new(0, 204, 0, 21); _i.BackgroundColor3 = Color3.fromRGB(220, 238, 255); _i.BorderSizePixel = 0; _i.Text = "29"; _i.Font = Enum.Font.GothamBold; _i.TextSize = 12; _i.TextColor3 = Color3.fromRGB(30, 90, 200); _i.TextXAlignment = Enum.TextXAlignment.Center; _i.ClearTextOnFocus = false; Instance.new("UICorner", _i).CornerRadius = UDim.new(0, 5); ii = Instance.new("UIStroke", _i); ii.Color = Color3.fromRGB(0, 0, 0); ii.Thickness = 1; xi.InputChanged:Connect(function(Li) if Li.UserInputType == Enum.UserInputType.TextInput then xi.Text = xi.Text:gsub("[^0-9]", ""); end; end); _i.InputChanged:Connect(function(Li) if Li.UserInputType == Enum.UserInputType.TextInput then _i.Text = _i.Text:gsub("[^0-9]", ""); end; end); ii = Instance.new("TextButton", Qi); ii.Size = UDim2.new(1,- 16, 0, 24); ii.Position = UDim2.new(0, 8, 0, 50); ii.BackgroundColor3 = Color3.fromRGB(50, 130, 255); ii.BorderSizePixel = 0; ii.Text = "Add Speed"; ii.TextColor3 = Color3.fromRGB(255, 255, 255); ii.TextSize = 11; ii.Font = Enum.Font.GothamBold; ii.AutoButtonColor = false; Instance.new("UICorner", ii).CornerRadius = UDim.new(0, 5); local Li = Instance.new("TextLabel", Qi); Li.Size = UDim2.new(1,- 16, 0, 14); Li.Position = UDim2.new(0, 8, 0, 78); Li.BackgroundTransparency = 1; Li.Text = ""; Li.TextColor3 = Color3.fromRGB(200, 60, 60); Li.TextSize = 9; Li.Font = Enum.Font.GothamBold; Li.TextXAlignment = Enum.TextXAlignment.Left; u(ii, function() local ii, zi, Si = Pi.Text:match("^%s*(.-)%s*$"), tonumber(xi.Text), tonumber(_i.Text); if not ii or #ii < 1 then Li.Text = "Enter a name"; return; end; if not zi or zi < 1 or zi > 200 then Li.Text = "Boost: 1-200"; return; end; if not Si or Si < 1 or Si > 200 then Li.Text = "Steal: 1-200"; return; end; for Pi, Pi in ipairs(I) do if Pi.name == ii then Li.Text = "Name already exists"; return; end; end; if ii == "Normal" or ii == "Lagger" or ii == "Desync" then Li.Text = "Reserved name"; return; end; local Pi = {name = ii, boost = zi, steal = Si}; table.insert(I, Pi); pcall(function() ki(Pi); end); pcall(function() Qi:Destroy(); end); Qi = nil; mi(); end); end);
                                        end;
                                        for ii, ii in ipairs(_speedCardRefs) do
                                            if ii.updateVisual then
                                                pcall(ii.updateVisual);
                                            end;
                                        end;
                                        Hi = Vi(o.Movement, "MOVEMENT");
                                        a = nil;
                                        for ii, ii in ipairs(Fi(Hi, "Auto Play", "Autoplay"):GetChildren()) do
                                            if ii:IsA("TextButton") then
                                                a = ii;
                                                break;
                                            end;
                                        end;
                                        if a then
                                            Ei = Instance.new("TextButton", a);
                                            Ei.Name = "AutoplayModeButton";
                                            Ei.Size = UDim2.new(0, 56, 0, 20);
                                            Ei.Position = UDim2.new(1,- 120, 0.5,- 10);
                                            Ei.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                            Ei.BorderSizePixel = 0;
                                            Ei.Text = string.upper(_G.__autoplayMode or "Full");
                                            Ei.TextColor3 = Color3.fromRGB(225, 238, 255);
                                            Ei.TextSize = 10;
                                            Ei.Font = Enum.Font.GothamBold;
                                            Ei.AutoButtonColor = false;
                                            Ei.ZIndex = 10;
                                            Instance.new("UICorner", Ei).CornerRadius = UDim.new(0, 4);
                                            local ii = Instance.new("UIStroke", Ei);
                                            ii.Color = Color3.fromRGB(255, 255, 255);
                                            ii.Thickness = 1;
                                            ii.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                            Y();
                                        end;
                                        Ni(Hi, "Auto Carry Speed", "Auto Carry Speed");
                                        do
                                            local ii = Fi(Hi, "Carry Speed", "Carry Speed");
                                            local Qi;
                                            for Pi, Pi in ipairs(ii:GetChildren()) do
                                                if Pi:IsA("TextButton") then
                                                    Qi = Pi;
                                                    break;
                                                end;
                                            end;
                                            pcall(function() styleSmallToggle(ii); end);
                                            if Qi then
                                                local ii = Instance.new("TextButton", Qi);
                                                ii.Size = UDim2.new(0, 56, 0, 20);
                                                ii.Position = UDim2.new(1,- 120, 0.5,- 10);
                                                ii.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                ii.BorderSizePixel = 0;
                                                ii.Text = "V1";
                                                ii.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                ii.TextSize = 10;
                                                ii.Font = Enum.Font.GothamBold;
                                                ii.AutoButtonColor = false;
                                                ii.ZIndex = 10;
                                                Instance.new("UICorner", ii).CornerRadius = UDim.new(0, 4);
                                                Ei = Instance.new("UIStroke", ii);
                                                Ei.Color = Color3.fromRGB(255, 255, 255);
                                                Ei.Thickness = 1;
                                                Ei.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                local function Pi()
                                                    for ki, ki in ipairs(Qi:GetChildren()) do
                                                        if ki:IsA("TextButton") and ki ~= ii and ki.Size.X.Offset == 48 and ki.Position.X.Scale == 1 and ki.Position.X.Offset ==- 54 then
                                                            return ki;
                                                        end;
                                                    end;
                                                    return nil;
                                                end;
                                                local function Qi()
                                                    n = "v1";
                                                    ii.Text = "V1";
                                                    ii.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                    ii.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                    ii.Position = UDim2.new(1,- 120, 0.5,- 10);
                                                    local ki = Pi();
                                                    if ki then
                                                        ki.Visible = true;
                                                    end;
                                                end;
                                                local function ki()
                                                    n = "v2";
                                                    ii.Text = "V2";
                                                    ii.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                    ii.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                    ii.Position = UDim2.new(1,- 120, 0.5,- 10);
                                                    local ii = Pi();
                                                    if ii then
                                                        ii.Visible = true;
                                                    end;
                                                end;
                                                if n == "v2" then
                                                    ki();
                                                else
                                                    Qi();
                                                end;
                                                Y();
                                            end;
                                        end;
                                        pcall(function() if _G and _G.__setNoPlayerCollision then _G.__setNoPlayerCollision (true); end; end);
                                        local function Y(ii)
                                            if not ii then
                                                return;
                                            end;
                                            pcall(function() ii.Size = UDim2.new(1,- 2, 0, GUI_METRICS.compactCardH); for Qi, Pi in ipairs(ii:GetChildren()) do if Pi:IsA("TextButton") then Pi.Size = UDim2.new(1, 0, 0, GUI_METRICS.compactCardH); Pi.BackgroundColor3 = Color3.fromRGB(25, 31, 42); Pi.BackgroundTransparency = 0.35; Pi.BorderSizePixel = 0; Pi.ZIndex = 21; Qi = Pi:FindFirstChildOfClass("UICorner"); if Qi then Qi.CornerRadius = UDim.new(0, 5); else Instance.new("UICorner", Pi).CornerRadius = UDim.new(0, 5); end; local ii = Pi:FindFirstChildOfClass("UIStroke"); if ii then ii.Color = Color3.fromRGB(0, 0, 0); ii.Thickness = 1; ii.Transparency = 0; end; break; end; end; end);
                                        end;
                                        pcall(function() local ii = y and y.Autoplay; if ii and ii.card and ii.card.Parent then Y(ii.card.Parent); end; end);
                                        pcall(function() local ii = y and y["Carry Speed"]; if ii and ii.card and ii.card.Parent then Y(ii.card.Parent); end; end);
                                        pcall(function() local ii = y and y["TP Bat"]; if ii and ii.card and ii.card.Parent then Y(ii.card.Parent); end; end);
                                        _G.__GhostDuelInfJumpMode = _G.__GhostDuelInfJumpMode or "hold";
                                        Ni(Hi, "Unwalk", "Unwalk");
                                        Ei = Ni(Hi, "Inf Jump", "Inf Jump");
                                        if Ei then
                                            local ii = Instance.new("TextButton", Ei);
                                            ii.Name = "InfJumpModeBtn";
                                            ii.Size = UDim2.new(0, 66, 0, 20);
                                            ii.Position = UDim2.new(1,- 74, 0.5,- 10);
                                            ii.AnchorPoint = Vector2.new(0, 0);
                                            ii.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                            ii.BorderSizePixel = 0;
                                            ii.Text = _G.__GhostDuelInfJumpMode == "hold" and "HOLD" or "MANUAL";
                                            ii.TextColor3 = Color3.fromRGB(225, 238, 255);
                                            ii.Font = Enum.Font.GothamBold;
                                            ii.TextSize = 10;
                                            ii.AutoButtonColor = false;
                                            ii.ZIndex = 30;
                                            Instance.new("UICorner", ii).CornerRadius = UDim.new(0, 4);
                                            local Qi = Instance.new("UIStroke", ii);
                                            Qi.Color = Color3.fromRGB(255, 255, 255);
                                            Qi.Thickness = 1;
                                            Qi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                            local function Pi()
                                                ii.Text = _G.__GhostDuelInfJumpMode == "hold" and "HOLD" or "MANUAL";
                                                ii.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                ii.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                Qi.Color = Color3.fromRGB(255, 255, 255);
                                                Qi.Thickness = 1;
                                                ii.TextStrokeTransparency = 1;
                                            end;
                                            Pi();
                                            u(ii, function() _G.__GhostDuelInfJumpMode = _G.__GhostDuelInfJumpMode == "hold" and "manual" or "hold"; Pi(); if E["Inf Jump"] then if _G.__GhostDuelInfJumpMode == "hold" then startInfJump(); else stopInfJump(); end; end; end);
                                        end;
                                        local ii = Fi(Hi, "TP Down", "TP Down");
                                        pcall(function() Y(ii); end);
                                        i(Hi, "Auto TP Down", "Auto TP Down");
                                        Ei = Vi(o.Combat, "COMBAT");
                                        Fi(Ei, "Anti Bat", "Anti Bat");
                                        Ni(Ei, "Anti Ragdoll", "Anti Ragdoll");
                                        Ni(Ei, "Ragdoll Counter", "Ragdoll Counter");
                                        Ni(Ei, "Medusa Counter", "Medusa Counter");
                                        function _G.__GhostDuelAntiDieGuiEnabled ()
                                            return E["Anti Die"] == true;
                                        end;
                                        W["Anti Die"] = function(ii)
                                            pcall(function() if _G.__GhostDuelAntiDieSource then _G.__GhostDuelAntiDieSource ("toggle", ii); end; end);
                                        end;
                                        Ni(Ei, "Anti Die", "Anti Die");
                                        W["Anti Die"](E["Anti Die"] == true);
                                        do
                                            local ii = Fi(Ei, "Aimbot", "Aimbot");
                                            pcall(function() Y(ii); end);
                                        end;
                                        pcall(Y, (Fi(Ei, "Lagger Aimbot", "Lagger Aimbot")));
                                        do
                                            local ii = Fi(Ei, "TP Bat", "TP Bat", function(Qi) local Hi = Qi.Parent; local Pi = Hi and(Hi:FindFirstChildOfClass("TextButton")); if not Pi then return 28; end; local ki = Instance.new("TextButton", Pi); ki.Name = "BatVersionToggle"; ki.Size = UDim2.new(0, 64, 0, 22); ki.Position = UDim2.new(1,- 118, 0.5,- 11); ki.BackgroundColor3 = Color3.fromRGB(30, 30, 38); ki.BorderSizePixel = 0; ki.Text = "V" .. tostring(_G.__batVersion or 1); ki.TextColor3 = Color3.fromRGB(225, 238, 255); ki.Font = Enum.Font.GothamBold; ki.TextSize = 10; ki.AutoButtonColor = false; ki.Active = false; ki.Selectable = false; ki.Visible = false; ki.ZIndex = 30; Instance.new("UICorner", ki).CornerRadius = UDim.new(0, 4); local xi = Instance.new("UIStroke", ki); xi.Color = Color3.fromRGB(255, 255, 255); xi.Thickness = 1; xi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; local _i = Instance.new("TextButton", Pi); _i.Name = "BatConfigToggle"; _i.Size = UDim2.new(0, A and 50 or 64, 0, A and 18 or 22); _i.Position = UDim2.new(1, A and- 88 or- 118, 0.5, A and- 9 or- 11); _i.BackgroundColor3 = Color3.fromRGB(45, 48, 58); _i.BorderSizePixel = 0; _i.Text = ""; _i.AutoButtonColor = false; _i.ZIndex = 30; Instance.new("UICorner", _i).CornerRadius = UDim.new(0, 4); local Li = Instance.new("UIStroke", _i); Li.Color = Color3.fromRGB(160, 175, 195); Li.Thickness = 1; Li.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Pi = Instance.new("TextLabel", _i); Pi.Size = UDim2.new(0, 30, 1, 0); Pi.Position = UDim2.new(0, 5, 0, 0); Pi.BackgroundTransparency = 1; Pi.Text = "GUI"; Pi.TextColor3 = Color3.fromRGB(235, 240, 250); Pi.Font = Enum.Font.GothamBold; Pi.TextSize = 8; Pi.TextXAlignment = Enum.TextXAlignment.Left; Pi.ZIndex = 31; local zi = Instance.new("Frame", _i); zi.Size = UDim2.new(0, 24, 0, 12); zi.Position = UDim2.new(1,- 29, 0.5,- 6); zi.BackgroundColor3 = Color3.fromRGB(25, 27, 33); zi.BorderSizePixel = 0; zi.ZIndex = 31; Instance.new("UICorner", zi).CornerRadius = UDim.new(1, 0); local Si = Instance.new("Frame", zi); Si.Size = UDim2.new(0, 8, 0, 8); Si.Position = UDim2.new(0, 2, 0.5,- 4); Si.BackgroundColor3 = Color3.fromRGB(155, 165, 180); Si.BorderSizePixel = 0; Si.ZIndex = 32; Instance.new("UICorner", Si).CornerRadius = UDim.new(1, 0); Pi = Instance.new("Frame", Qi); Pi.Name = "BatV2DistanceConfig"; Pi.Size = UDim2.new(1,- 2, 0, 78); Pi.Position = UDim2.new(0, 1, 0, 4); Pi.BackgroundColor3 = Color3.fromRGB(25, 31, 42); Pi.BackgroundTransparency = 0.2; Pi.BorderSizePixel = 0; Pi.ZIndex = 22; Instance.new("UICorner", Pi).CornerRadius = UDim.new(0, 6); local gi = Instance.new("UIStroke", Pi); gi.Color = Color3.fromRGB(90, 130, 185); gi.Transparency = 0.25; gi.Thickness = 1; gi = Instance.new("TextLabel", Pi); gi.Size = UDim2.new(1,- 92, 0, 38); gi.Position = UDim2.new(0, 10, 0, 0); gi.BackgroundTransparency = 1; gi.Text = "DISTANCIA TP (STUDS)"; gi.TextColor3 = Color3.fromRGB(190, 210, 238); gi.Font = Enum.Font.GothamBold; gi.TextSize = 10; gi.TextXAlignment = Enum.TextXAlignment.Left; gi.ZIndex = 23; local Oi = Instance.new("TextBox", Pi); Oi.Name = "BatV2DistanceInput"; Oi.Size = UDim2.new(0, 70, 0, 26); Oi.Position = UDim2.new(1,- 80, 0, 6); Oi.BackgroundColor3 = Color3.fromRGB(15, 20, 29); Oi.BackgroundTransparency = 0.05; Oi.BorderSizePixel = 0; Oi.ClearTextOnFocus = false; Oi.Text = tostring(_G.__tpBatV2Distance or 8); Oi.TextColor3 = Color3.fromRGB(245, 248, 255); Oi.Font = Enum.Font.GothamBold; Oi.TextSize = 11; Oi.TextXAlignment = Enum.TextXAlignment.Center; Oi.ZIndex = 24; Instance.new("UICorner", Oi).CornerRadius = UDim.new(0, 4); gi = Instance.new("UIStroke", Oi); gi.Color = Color3.fromRGB(125, 170, 225); gi.Transparency = 0.2; gi.Thickness = 1; _G.__tpBatV2DistanceInput = Oi; gi = Instance.new("TextLabel", Pi); gi.Size = UDim2.new(1,- 92, 0, 34); gi.Position = UDim2.new(0, 10, 0, 40); gi.BackgroundTransparency = 1; gi.Text = "VERSION TP BAT"; gi.TextColor3 = Color3.fromRGB(190, 210, 238); gi.Font = Enum.Font.GothamBold; gi.TextSize = 10; gi.TextXAlignment = Enum.TextXAlignment.Left; gi.ZIndex = 23; gi.Visible = true; local gi = Instance.new("TextButton", Pi); gi.Name = "BatVersionInsideConfig"; gi.Size = UDim2.new(0, 70, 0, 26); gi.Position = UDim2.new(1,- 80, 0, 44); gi.BackgroundColor3 = Color3.fromRGB(28, 92, 165); gi.BorderSizePixel = 0; gi.Text = "V" .. tostring(_G.__batVersion or 1); gi.TextColor3 = Color3.fromRGB(245, 248, 255); gi.Font = Enum.Font.GothamBold; gi.TextSize = 11; gi.AutoButtonColor = false; gi.Active = true; gi.Visible = true; gi.ZIndex = 24; Instance.new("UICorner", gi).CornerRadius = UDim.new(0, 4); local Pi = Instance.new("UIStroke", gi); Pi.Color = Color3.fromRGB(110, 190, 255); Pi.Transparency = 0.15; Pi.Thickness = 1; local ni = false; local function Ji() local fi = ni; _i.Visible = true; _i.BackgroundColor3 = fi and(Color3.fromRGB(28, 92, 165)) or(Color3.fromRGB(45, 48, 58)); Li.Color = fi and(Color3.fromRGB(110, 190, 255)) or(Color3.fromRGB(160, 175, 195)); zi.BackgroundColor3 = fi and(Color3.fromRGB(45, 135, 225)) or(Color3.fromRGB(25, 27, 33)); Si.BackgroundColor3 = fi and(Color3.fromRGB(245, 248, 255)) or(Color3.fromRGB(155, 165, 180)); Si.Position = fi and(UDim2.new(1,- 10, 0.5,- 4)) or(UDim2.new(0, 2, 0.5,- 4)); Qi.Visible = fi; Qi.Size = UDim2.new(1, 0, 0, fi and 86 or 0); Hi.Size = UDim2.new(1,- 2, 0, fi and GUI_METRICS.toggleH + 86 or GUI_METRICS.toggleH); end; u(_i, function() ni = not ni; Ji(); end); Oi.FocusLost:Connect(function() _G.GhostDuelAutoBat.SetV2Distance(Oi.Text); end); _G.__batVersionPill = ki; _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1; local function _i () _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1; ki.Text = "V" .. tostring(_G.__batVersion or 1); ki.BackgroundColor3 = Color3.fromRGB(45, 48, 58); ki.TextColor3 = Color3.fromRGB(245, 248, 255); xi.Color = Color3.fromRGB(220, 225, 235); gi.Text = "V" .. tostring(_G.__batVersion or 1); gi.BackgroundColor3 = Color3.fromRGB(45, 48, 58); Pi.Color = Color3.fromRGB(220, 225, 235); Oi.TextEditable = true; Oi.Text = tostring(_G.__tpBatV2Distance or 8); Oi.BackgroundTransparency = 0.05; Oi.TextColor3 = Color3.fromRGB(245, 248, 255); Ji(); end; _G.__GhostDuelUpdateBatVersionButton = _i; _i (); u(ki, function() _G.GhostDuelAutoBat.SetVersion(_G.__batVersion == 1 and 2 or 1); end); u(gi, function() _G.GhostDuelAutoBat.SetVersion(_G.__batVersion == 1 and 2 or 1); end); Qi.Size = UDim2.new(1, 0, 0, 0); Qi.Visible = false; Hi.Size = UDim2.new(1,- 2, 0, GUI_METRICS.toggleH); task.defer(Ji); return 0; end);
                                            pcall(function() Y(ii); end);
                                        end;
                                        (function() pcall(function() local ii = workspace:FindFirstChild("GhostDuelTPBatLastPosition"); if ii then ii:Destroy(); end; end); local ii = {enabled = false, heartbeat = nil, target = nil, samples = {}, swingLocked = false, nextSwingAt = 0, lastSafeCFrame = nil, lastPosition = nil, lastSampleTime = 0, recoverUntil = 0, physicsPauseUntil = 0, previousAutoRotate = nil, lastTargetMarker = nil, markerLocked = false, markerTarget = nil, markerBodyLock = nil, markerBodyAttachment = nil}; _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1; local function Qi() local Hi = m.Character; if not Hi then return nil, nil, nil; end; return Hi, Hi:FindFirstChild("HumanoidRootPart"), Hi:FindFirstChildOfClass("Humanoid"); end; local function Hi(Pi) return Pi ~= nil and Pi.X == Pi.X and Pi.Y == Pi.Y and Pi.Z == Pi.Z and math.abs(Pi.X) < 10000000 and math.abs(Pi.Y) < 10000000 and math.abs(Pi.Z) < 10000000; end; local function Pi(ki, xi, _i, Li) local zi = Vector3.new(xi.X - ki.X, 0, xi.Z - ki.Z); if zi.Magnitude > 0.05 then return CFrame.lookAt(ki, ki + zi.Unit); end; zi = _i and(Vector3.new(_i.X, 0, _i.Z)) or nil; if zi and zi.Magnitude >= 0.01 then return CFrame.lookAt(ki, ki + zi.Unit); end; if Li then zi, _i = Li:ToEulerAnglesYXZ(); return CFrame.new(ki) * CFrame.Angles(0, _i, 0); end; return CFrame.new(ki); end; local function ki(xi, _i) if not xi or not _i then return nil; end; local Li = _i.Position; local zi = Vector3.new(xi.Position.X - Li.X, 0, xi.Position.Z - Li.Z); if zi.Magnitude <= 0.05 then local Si = _i.CFrame.LookVector; zi = (Vector3.new(- Si.X, 0,- Si.Z)); end; return Pi(Li + (if zi.Magnitude <= 0.05 then(Vector3.new(0, 0, 1)) else zi).Unit * 3, Li, _i.CFrame.LookVector, xi.CFrame); end; local function Pi() if ii.markerBodyLock then pcall(function() ii.markerBodyLock:Destroy(); end); ii.markerBodyLock = nil; end; if ii.markerBodyAttachment then pcall(function() ii.markerBodyAttachment:Destroy(); end); ii.markerBodyAttachment = nil; end; end; local function xi(_i, _i) Pi(); end; _G.__GhostDuelTPBatApplyMarkerBodyLock = xi; _G.__GhostDuelTPBatClearMarkerBodyLock = Pi; local function _i (Li, zi) if not Li or not zi then return false; end; local Si = ii and ii.lastTargetMarker; if Si and Si.Parent and Si.Transparency and Si.Transparency < 1 then return false; end; return(pcall(function() Li.AssemblyLinearVelocity = Vector3.zero; Li.AssemblyAngularVelocity = Vector3.zero; Li.CFrame = zi; Li.AssemblyLinearVelocity = Vector3.zero; Li.AssemblyAngularVelocity = Vector3.zero; end)); end; local Li, zi, Si, gi, Oi, ni =- 536.2,- 422,- 10, 75,- 71.8, 192.9; local function Ji(fi) if not fi then return false; end; return fi.X >= Li and fi.X <= zi and fi.Y >= Si and fi.Y <= gi and fi.Z >= Oi and fi.Z <= ni; end; _G.__GhostDuelTPBatIsInsideMap = Ji; local function Li(zi) if ii.markerLocked then return; end; local Si = ii.markerTarget; local gi = Si and Si.Parent == K and Si.Character; local Oi, ni = gi and(gi:FindFirstChild("HumanoidRootPart")), gi and(gi:FindFirstChildOfClass("Humanoid")); if not Oi or not ni or ni.Health <= 0 or not Hi(Oi.Position) or(Ji(Oi.Position)) then return; end; if not zi or not Ji(zi.Position) then return; end; gi, Si = CFrame.new(zi.Position.X,- 7, zi.Position.Z) * zi.Rotation, ii.lastTargetMarker; if not Si or not Si.Parent then Si = Instance.new("Part"); Si.Name = "GhostDuelTPBatLastPosition"; Si.Shape = Enum.PartType.Ball; Si.Size = Vector3.new(3, 3, 3); Si.Color = Color3.fromRGB(0, 110, 255); Si.Material = Enum.Material.Neon; Si.Anchored = true; Si.CanCollide = false; Si.CanTouch = false; Si.CanQuery = false; Si.CastShadow = false; Si.Parent = workspace; zi = Instance.new("SphereHandleAdornment"); zi.Name = "AlwaysOnTopSphere"; zi.Adornee = Si; zi.Radius = 1.55; zi.Color3 = Color3.fromRGB(0, 125, 255); zi.Transparency = 0.05; zi.AlwaysOnTop = true; zi.Visible = true; zi.ZIndex = 10; zi.Parent = Si; ni = Instance.new("Highlight"); ni.Name = "LastPositionHighlight"; ni.Adornee = Si; ni.FillColor = Color3.fromRGB(0, 110, 255); ni.FillTransparency = 0.15; ni.OutlineColor = Color3.fromRGB(120, 200, 255); ni.OutlineTransparency = 0; ni.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; ni.Enabled = true; ni.Parent = Si; Oi = Instance.new("BillboardGui"); Oi.Name = "LastPositionLabel"; Oi.Size = UDim2.new(0, 110, 0, 20); Oi.StudsOffset = Vector3.new(0, 2.1, 0); Oi.AlwaysOnTop = true; Oi.Adornee = Si; Oi.Parent = Si; local zi = Instance.new("TextLabel"); zi.Name = "Text"; zi.Size = UDim2.fromScale(1, 1); zi.BackgroundTransparency = 1; zi.Text = "ultima posicion"; zi.TextColor3 = Color3.fromRGB(220, 235, 255); zi.TextStrokeColor3 = Color3.fromRGB(0, 35, 90); zi.TextStrokeTransparency = 0.25; zi.TextSize = 11; zi.Font = Enum.Font.GothamMedium; zi.Parent = Oi; ii.lastTargetMarker = Si; end; Si.Transparency = 0; local zi = Si:FindFirstChild("AlwaysOnTopSphere"); if zi then zi.Visible = true; end; zi = Si:FindFirstChild("LastPositionHighlight"); if zi then zi.Enabled = true; end; zi = Si:FindFirstChild("LastPositionLabel"); if zi then zi.Enabled = true; end; Si.CFrame = gi; ii.markerLocked = true; end; local function zi() ii.markerLocked = false; Pi(); if ii.lastTargetMarker then pcall(function() ii.lastTargetMarker.Transparency = 1; local Si = ii.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere"); if Si then Si.Visible = false; end; Si = ii.lastTargetMarker:FindFirstChild("LastPositionHighlight"); if Si then Si.Enabled = false; end; Si = ii.lastTargetMarker:FindFirstChild("LastPositionLabel"); if Si then Si.Enabled = false; end; end); end; end; function _G.__GhostDuelTPBatGetMarkerCFrame () local Si = ii.lastTargetMarker; if ii.markerLocked and Si and Si.Parent and Si.Transparency < 1 then local gi = ii.markerTarget; local Oi = gi and gi.Character and(gi.Character:FindFirstChild("HumanoidRootPart")); if Oi and(Ji(Oi.Position)) then zi(); return nil; end; Oi, gi = Qi(); return ki(gi, Si) or Si.CFrame; end; return nil; end; function _G.__GhostDuelTPBatTrackTarget (ki) if ii.markerLocked then return ii.markerTarget; end; local Si = ii.markerTarget; local gi = Si and Si.Parent == K and Si.Character; local Oi, ni, fi = gi and(gi:FindFirstChildOfClass("Humanoid")), gi and(gi:FindFirstChild("HumanoidRootPart")), Si and ii.samples[Si]; if Si and Si.Parent == K then if Oi and Oi.Health > 0 and(ni and(Ji(ni.Position)) or fi and fi.safeCFrame) then return Si; end; if not Oi and fi and fi.safeCFrame then return Si; end; end; if ki and ki ~= m and ki.Parent == K then ii.markerTarget = ki; return ki; end; return ii.markerTarget; end; function _G.__GhostDuelTPBatClearMarkerTracking () ii.target = nil; end; local function ki(Si, gi) if not Si or Si.Parent ~= K or not Si.Character then return false; end; local gi, Oi = Si.Character:FindFirstChild("HumanoidRootPart"), Si.Character:FindFirstChildOfClass("Humanoid"); if not gi or not Oi or Oi.Health <= 0 or not Ji(gi.Position) then return false; end; return true; end; local function Si(gi, Oi) if not gi or not gi.history or #gi.history == 0 then return nil; end; local ni, fi = Oi - 0.2; for Oi, Oi in ipairs(gi.history) do if not(Oi.time <= ni) then break; end; fi = Oi; end; return fi or gi.history[1]; end; function _G.__GhostDuelTPBatForceMarker (gi, Oi) if gi and gi.Parent == K then ii.markerTarget = gi; end; local ni = gi and ii.samples[gi]; gi = Si(ni, tick()); local fi = gi and gi.safeCFrame or ni and ni.safeCFrame; fi = if not fi and Oi and(Ji(Oi.Position)) then Oi else fi; if fi then Li(fi); end; return _G.__GhostDuelTPBatGetMarkerCFrame (); end; local function gi() local Oi, Oi = Qi(); if not Oi then return; end; local Qi = ii.markerTarget; if Qi and Qi.Parent == K then local ni, fi, oi = Qi.Character and(Qi.Character:FindFirstChild("HumanoidRootPart")), Qi.Character and(Qi.Character:FindFirstChildOfClass("Humanoid")), ii.samples[Qi] or {}; ii.samples[Qi] = oi; if ni and fi and fi.Health > 0 and(Hi(ni.Position)) then if Ji(ni.Position) then local Hi = tick(); if ii.markerLocked then oi.history = {}; end; oi.history = oi.history or {}; table.insert(oi.history, {time = Hi, safePosition = ni.Position, safeCFrame = ni.CFrame}); while oi.history[1] and Hi - oi.history[1].time > 0.45 do table.remove(oi.history, 1); end; oi.safePosition = ni.Position; oi.safeCFrame = ni.CFrame; zi(); else local Hi = Si(oi, tick()); Li(Hi and Hi.safeCFrame or oi.safeCFrame); end; end; if fi and fi.Health <= 0 or not ni and not oi.safeCFrame then ii.markerTarget = nil; zi(); else return; end; end; local Hi, Li = math.huge; for Si, ni in ipairs(K:GetPlayers()) do if ni ~= m and(ki(ni)) then Qi = ni.Character:FindFirstChild("HumanoidRootPart").Position - Oi.Position; Si = Qi:Dot(Qi); if Si < Hi then Hi, Li = Si, ni; end; end; end; if Li then ii.markerTarget = Li; Hi, Oi = Li.Character:FindFirstChild("HumanoidRootPart"), ii.samples[Li] or {}; ii.samples[Li] = Oi; Oi.safePosition = Hi.Position; Oi.safeCFrame = Hi.CFrame; Oi.history = {{time = tick(), safePosition = Hi.Position, safeCFrame = Hi.CFrame}}; end; end; local Qi = 0; local Hi = c.Heartbeat:Connect(function(ki) Qi += ki or 0; ki = A and((E["TP Bat"] == true or E.Aimbot == true or E["Lagger Aimbot"] == true) and 0.03333333333333333 or 0.25) or 0.016666666666666666; if Qi < ki then return; end; Qi %= ki; gi(); end); _G.__GhostDuelTrackConn (Hi); local function Qi(Hi) local ki = _G.__GhostDuelTPBatGetMarkerCFrame (); if not ki then Pi(); return false; end; pcall(function() Hi.AssemblyLinearVelocity = Vector3.zero; Hi.AssemblyAngularVelocity = Vector3.zero; Hi.CFrame = ki; Hi.AssemblyLinearVelocity = Vector3.zero; Hi.AssemblyAngularVelocity = Vector3.zero; end); local ki = ii.lastTargetMarker; if ki then xi(Hi, ki); end; return true; end; _G.__GhostDuelTrackStopper (function() pcall(zi); end); do local ii = {enabled = false, heartbeat = nil, target = nil, samples = {}, swingLocked = false, nextSwingAt = 0, lastSafeCFrame = nil, lastPosition = nil, lastSampleTime = 0, recoverUntil = 0, physicsPauseUntil = 0, previousAutoRotate = nil, lastTargetMarker = nil, markerLocked = false, markerTarget = nil}; _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1; local Hi = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}; local function ki() local xi = m.Character; if not xi then return nil, nil, nil; end; return xi, xi:FindFirstChild("HumanoidRootPart"), xi:FindFirstChildOfClass("Humanoid"); end; local function xi(Li) local zi, Si, Si = ki(); if not zi then return nil; end; for gi, Oi in ipairs(Hi) do gi = zi:FindFirstChild(Oi); if gi and(gi:IsA("Tool")) then return gi; end; end; for gi, Oi in ipairs(zi:GetChildren()) do if Oi:IsA("Tool") then gi = Oi.Name:lower(); if gi:find("bat", 1, true) or(gi:find("slap", 1, true)) then return Oi; end; end; end; zi = m:FindFirstChildOfClass("Backpack"); if zi then local gi; for Oi, ni in ipairs(Hi) do Oi = zi:FindFirstChild(ni); if Oi and(Oi:IsA("Tool")) then gi = Oi; break; end; end; if not gi then for Hi, Oi in ipairs(zi:GetChildren()) do if Oi:IsA("Tool") then Hi = Oi.Name:lower(); if Hi:find("bat", 1, true) or(Hi:find("slap", 1, true)) then gi = Oi; break; end; end; end; end; if gi and Li and Si then pcall(function() Si:EquipTool(gi); end); end; return gi; end; return nil; end; local function Hi(Li) return Li.X == Li.X and Li.Y == Li.Y and Li.Z == Li.Z and math.abs(Li.X) < 10000000 and math.abs(Li.Y) < 10000000 and math.abs(Li.Z) < 10000000; end; local function Li(zi, Si, gi, Oi) local ni = Vector3.new(Si.X - zi.X, 0, Si.Z - zi.Z); if ni.Magnitude > 0.05 then return CFrame.lookAt(zi, zi + ni.Unit); end; ni = gi and(Vector3.new(gi.X, 0, gi.Z)) or nil; if ni and ni.Magnitude >= 0.01 then return CFrame.lookAt(zi, zi + ni.Unit); end; if Oi then gi, Si = Oi:ToEulerAnglesYXZ(); return CFrame.new(zi) * CFrame.Angles(0, Si, 0); end; return CFrame.new(zi); end; local function zi(Si) return Si ~= nil; end; local function Si() end; local function gi(Oi) if not Oi or Oi.Parent ~= K or not Oi.Character then return false; end; local ni, Ji = Oi.Character:FindFirstChild("HumanoidRootPart"), Oi.Character:FindFirstChildOfClass("Humanoid"); if not ni or not Ji or Ji.Health <= 0 or not Hi(ni.Position) then return false; end; Ji = ii.samples[Oi]; return _G.__GhostDuelTPBatIsInsideMap (ni.Position) or Ji ~= nil and Ji.safeCFrame ~= nil; end; local function Oi(ni, Ji) local fi = ni and ii.samples[ni]; ni = fi and fi.safeCFrame; if ni and(zi(ni.Position)) and(not Ji or(zi(ni.Position))) then return ni; end; return nil; end; local function zi(ni) local Ji = _G.__GhostDuelTPBatTrackTarget (ii.target); if gi(Ji) then ii.target = Ji; return Ji; end; if gi(ii.target) then return ii.target; end; local fi, oi = math.huge; for qi, Bi in ipairs(K:GetPlayers()) do if Bi ~= m and(gi(Bi)) then qi = Bi.Character:FindFirstChild("HumanoidRootPart"); if qi then Ji = (qi.Position - ni.Position).Magnitude; if Ji < fi then fi, oi = Ji, Bi; end; end; end; end; if oi then ii.target = oi; _G.__GhostDuelTPBatTrackTarget (oi); end; return oi; end; local function gi() local ni = tonumber(_G.__tpBatV2Distance); if not ni or ni ~= ni then return 8; end; return math.clamp(ni, 0, 100); end; local function ni() local Ji = tick(); if ii.swingLocked or Ji < ii.nextSwingAt then return; end; ii.swingLocked = true; ii.nextSwingAt = Ji + 0.014925373134328358; pcall(function() local Ji = m.Character; if not Ji then return; end; local fi = xi(true); if not fi then return; end; if fi.Parent ~= Ji then local oi = Ji:FindFirstChildOfClass("Humanoid"); if oi then oi:EquipTool(fi); end; end; fi:Activate(); local Ji = fi:FindFirstChildWhichIsA("RemoteEvent", true); if Ji then pcall(function() Ji:FireServer(); end); end; end); task.delay(0.014925373134328358, function() ii.swingLocked = false; end); end; local function Ji(fi) if sethiddenproperty then pcall(function() sethiddenproperty(fi, "PhysicsRepRootPart", fi); end); end; end; local function fi() if not ii.enabled then return; end; local oi, qi, Bi = ki(); if not oi or not qi or not Bi or Bi.Health <= 0 then return; end; if Qi(qi) then ni(); return; end; if ii.previousAutoRotate == nil then ii.previousAutoRotate = Bi.AutoRotate; end; Bi.AutoRotate = false; xi(true); oi = zi(qi); if oi then local xi, ji = oi.Character and(oi.Character:FindFirstChild("HumanoidRootPart")), Oi(oi, qi); if not xi or not Hi(xi.Position) then return; end; if not _G.__GhostDuelTPBatIsInsideMap (xi.Position) then _G.__GhostDuelTPBatForceMarker (oi, ji); if Qi(qi) then ni(); end; return; end; local ji, wi = xi.CFrame, ii.samples[oi] or {}; ii.samples[oi] = wi; wi.safeCFrame = xi.CFrame; wi.safePosition = xi.Position; wi, Bi = ji.Position + Vector3.new(0, 0.9, 0), ji.LookVector; if(qi.Position - wi).Magnitude > gi() then _i (qi, Li(wi, ji.Position, Bi, qi.CFrame)); else _i (qi, Li(qi.Position, ji.Position, Bi, qi.CFrame)); end; if sethiddenproperty then pcall(function() if xi then sethiddenproperty(qi, "PhysicsRepRootPart", xi); end; end); end; local xi = workspace.CurrentCamera; if xi then pcall(function() xi.CFrame = CFrame.new(xi.CFrame.Position, ji.Position); end); end; ni(); end; end; local function xi() if not ii.enabled then return; end; local oi, qi, Bi = ki(); if not oi or not qi or not Bi or Bi.Health <= 0 then return; end; if Qi(qi) then ni(); return; end; if ii.previousAutoRotate == nil then ii.previousAutoRotate = Bi.AutoRotate; end; Bi.AutoRotate = false; Bi = zi(qi); if not Bi then return; end; local zi, ji = Bi.Character and(Bi.Character:FindFirstChild("HumanoidRootPart")), Oi(Bi, qi); local Oi, wi, yi = zi and zi.CFrame or ji, not zi, false; if zi then oi = ii.samples[Bi] or {}; ii.samples[Bi] = oi; yi = zi.Position.Y <- 9 or not _G.__GhostDuelTPBatIsInsideMap (zi.Position) or not Hi(zi.Position); if Hi(zi.Position) and(_G.__GhostDuelTPBatIsInsideMap (zi.Position)) then oi.safeCFrame = zi.CFrame; oi.safePosition = zi.Position; else Oi, wi = ji, true; end; end; if not Oi then return; end; if wi and yi then _G.__GhostDuelTPBatForceMarker (Bi, Oi); if Qi(qi) then ni(); return; end; end; ji = Oi.Position; ji = if not wi then ji + Vector3.new(0, 0.9, 0) else ji; _i (qi, if(qi.Position - ji).Magnitude > gi() then(Li(ji, Oi.Position, Oi.LookVector, qi.CFrame)) else(Li(qi.Position, Oi.Position, Oi.LookVector, qi.CFrame))); if sethiddenproperty then pcall(function() if zi then sethiddenproperty(qi, "PhysicsRepRootPart", zi); end; end); end; local Qi = workspace.CurrentCamera; if Qi then pcall(function() Qi.CFrame = CFrame.new(Qi.CFrame.Position, Oi.Position); end); end; ni(); end; local function Qi() if _G.__batVersion == 2 then return xi(); end; return fi(); end; local function Hi() local xi, _i = ii.enabled, ii.returnGeneration; Pi(); ii.enabled = false; if ii.heartbeat then ii.heartbeat:Disconnect(); ii.heartbeat = nil; end; ii.target = nil; ii.samples = {}; ii.swingLocked = false; local Pi, Pi, Li = ki(); if Pi then Pi.AssemblyLinearVelocity = Vector3.zero; Pi.AssemblyAngularVelocity = Vector3.zero; Ji(Pi); end; if Li then Li.AutoRotate = ii.previousAutoRotate == nil and true or ii.previousAutoRotate; pcall(function() Li.PlatformStand = false; Li.Sit = false; local zi = Li:GetState(); if zi == Enum.HumanoidStateType.Physics or zi == Enum.HumanoidStateType.Ragdoll or zi == Enum.HumanoidStateType.FallingDown then Li:ChangeState(Enum.HumanoidStateType.GettingUp); Li:ChangeState(Enum.HumanoidStateType.Running); end; zi = workspace.CurrentCamera; if zi then zi.CameraSubject = Li; end; end); end; ii.previousAutoRotate = nil; if xi and Pi then task.spawn(function() for Li = 1, 12, 1 do c.Heartbeat:Wait(); if ii.enabled or ii.returnGeneration ~= _i then return; end; if _G.__GhostDuel_STATE ~= H then return; end; local Li, Li, zi = ki(); if Li ~= Pi or not zi or zi.Health <= 0 then return; end; Li.AssemblyLinearVelocity = Vector3.zero; Li.AssemblyAngularVelocity = Vector3.zero; Ji(Li); end; end); end; if xi then task.delay(0.4, function() if ii.enabled or ii.returnGeneration ~= _i then return; end; if _G.__GhostDuel_STATE ~= H then return; end; pcall(function() if _G.__GhostDuelAntiDieSet then _G.__GhostDuelAntiDieSet (false); end; end); end); else pcall(function() if _G.__GhostDuelAntiDieSet then _G.__GhostDuelAntiDieSet (false); end; end); end; end; local function Pi() if ii.enabled then return; end; ii.returnGeneration = (ii.returnGeneration or 0) + 1; if E.Autoplay and _G.__stopAutoplay then _G.__stopAutoplay (); end; ii.enabled = true; pcall(function() if _G.__GhostDuelAntiDieSet then _G.__GhostDuelAntiDieSet (true); end; end); ii.target = nil; ii.samples = {}; ii.swingLocked = false; ii.nextSwingAt = 0; ii.lastPosition = nil; ii.lastSampleTime = tick(); ii.recoverUntil = 0; ii.physicsPauseUntil = 0; ii.startingUntil = tick() + 0.35; local xi, xi, _i = ki(); if xi then Ji(xi); if xi.Position.Y >- 30 then ii.lastSafeCFrame = xi.CFrame; end; end; if _i then ii.previousAutoRotate = _i.AutoRotate; end; if ii.heartbeat then ii.heartbeat:Disconnect(); end; ii.heartbeat = c.Heartbeat:Connect(Qi); task.spawn(function() pcall(Qi); end); end; W["TP Bat"] = function(xi) if xi then ci("TP Bat"); _G.__deactivateBatExclusive ("TP Bat"); Pi(); else Hi(); end; end; _G.__GhostDuelTrackStopper (function() pcall(Hi); pcall(Si); end); _G.GhostDuelAutoBat = {GetVersion = function() return _G.__batVersion or 1; end, SetVersion = function(ci) _G.__batVersion = tonumber(ci) == 2 and 2 or 1; ii.samples = {}; ii.lastPosition = nil; ii.lastSampleTime = tick(); ii.recoverUntil = 0; ii.physicsPauseUntil = 0; if _G.__batVersionPill then _G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion); end; if _G.__GhostDuelUpdateBatVersionButton then _G.__GhostDuelUpdateBatVersionButton (); end; if _G.__GhostDuelRefreshVisibleTPBatConfig then _G.__GhostDuelRefreshVisibleTPBatConfig (); end; mi(); if ii.enabled then local ci, ci = ki(); if ci then Ji(ci); end; Qi(); end; return _G.__batVersion; end, GetV2Distance = gi, SetV2Distance = function(ci) local Pi = tonumber((tostring(ci):gsub(",", "."))); ci = Pi and Pi == Pi and math.abs(Pi) < math.huge; if ci then _G.__tpBatV2Distance = math.floor(math.clamp(Pi, 0, 100) * 100 + 0.5) / 100; end; if _G.__GhostDuelUpdateBatVersionButton then _G.__GhostDuelUpdateBatVersionButton (); end; if _G.__GhostDuelRefreshVisibleTPBatConfig then _G.__GhostDuelRefreshVisibleTPBatConfig (); end; if ci then mi(); if ii.enabled then Qi(); end; end; return gi(); end, SetEnabled = function(ci) ci = ci == true; E["TP Bat"] = ci; if e["TP Bat"] then pcall(e["TP Bat"], ci); end; W["TP Bat"](ci); if U["TP Bat"] then pcall(U["TP Bat"]); end; mi(); return ii.enabled; end, Toggle = function() return _G.GhostDuelAutoBat.SetEnabled(not(E["TP Bat"] == true)); end, Stop = function() pcall(Hi); end}; end; end)();
                                        local ci = Fi(Ei, "Drop", "Drop");
                                        pcall(function() Y(ci); end);
                                        local ci = Fi(Ei, "Auto Grab", "auto steal");
                                        pcall(function() Y(ci); end);
                                        do
                                            local Y = Instance.new("Frame", V);
                                            Y.Name = "GhostDuelAutoGrabBar";
                                            Y.AnchorPoint = Vector2.new(0, 0);
                                            local ci, ii = A and 230 or 310, A and 205 or 280;
                                            local Qi, Hi, Fi = math.floor((ci + ii) / 2), _G._GhostDuel_UI_AutoGrabBarSize, _G._GhostDuel_UI_AutoGrabExpanded ~= nil and _G._GhostDuel_UI_AutoGrabExpanded or true;
                                            a = tonumber(Hi);
                                            local Pi = (if a and a < ii then nil else a) and(math.clamp(if a and a < ii then nil else a, ii, ci)) or ci;
                                            if Hi and(tonumber(Hi)) and tonumber(Hi) <= ii then
                                                Fi = false;
                                            end;
                                            _G._GhostDuel_UI_AutoGrabExpanded = Fi;
                                            Y.Size = UDim2.new(0, Pi, 0, A and 44 or 56);
                                            ii = _G._GhostDuel_UI_AutoGrabBarPos;
                                            if ii and ii.x and ii.y then
                                                Y.Position = UDim2.fromOffset(ii.x, ii.y);
                                            else
                                                Y.Position = UDim2.new(0.5,- Pi / 2, 0.8, 0);
                                            end;
                                            Y.BackgroundColor3 = Color3.fromRGB(205, 205, 205);
                                            Y.BackgroundTransparency = 0;
                                            Y.BorderSizePixel = 0;
                                            Y.ZIndex = 500;
                                            Y.Active = true;
                                            Y.Draggable = false;
                                            Y.Visible = false;
                                            Instance.new("UICorner", Y).CornerRadius = UDim.new(1, 0);
                                            local ii = Instance.new("UIStroke", Y);
                                            ii.Color = Color3.fromRGB(145, 145, 145);
                                            ii.Thickness = 1.5;
                                            ii.Transparency = 0.08;
                                            ii.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                            Hi = Instance.new("UIGradient", Y);
                                            Hi.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)), ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190))});
                                            Hi.Rotation = 90;
                                            Ei = Instance.new("Frame", Y);
                                            Ei.Size = UDim2.new(0, A and 70 or 82, 1,- 4);
                                            Ei.Position = UDim2.new(1, A and- 72 or- 84, 0, 2);
                                            Ei.BackgroundTransparency = 1;
                                            Ei.Visible = true;
                                            Ei.ZIndex = 504;
                                            Hi = Instance.new("Frame", Ei);
                                            Hi.Name = "Divider";
                                            Hi.Size = UDim2.new(0, 1, 1,- 10);
                                            Hi.Position = UDim2.new(0, 0, 0, 5);
                                            Hi.BorderSizePixel = 0;
                                            Hi.BackgroundColor3 = Color3.fromRGB(155, 155, 155);
                                            Hi.BackgroundTransparency = 0.25;
                                            Hi.ZIndex = 505;
                                            Z = Instance.new("TextLabel", Ei);
                                            Z.Size = UDim2.new(1,- 10, 0, 14);
                                            Z.Position = UDim2.new(0, A and 7 or 9, 0, A and 6 or 9);
                                            Z.BackgroundTransparency = 1;
                                            Z.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            Z.Font = Enum.Font.GothamBold;
                                            Z.TextSize = A and 8 or 9;
                                            Z.TextXAlignment = Enum.TextXAlignment.Left;
                                            Z.ZIndex = 506;
                                            Z.Visible = true;
                                            p = Instance.new("TextLabel", Ei);
                                            p.Size = UDim2.new(1,- 10, 0, 14);
                                            p.Position = UDim2.new(0, A and 7 or 9, 0, A and 23 or 27);
                                            p.BackgroundTransparency = 1;
                                            p.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            p.Font = Enum.Font.GothamBold;
                                            p.TextSize = A and 8 or 9;
                                            p.TextXAlignment = Enum.TextXAlignment.Left;
                                            p.ZIndex = 506;
                                            p.Visible = true;
                                            local Z = Instance.new("TextLabel", Ei);
                                            Z.Size = UDim2.new(0, 54, 1, 0);
                                            Z.Position = UDim2.new(1,- 84, 0, 0);
                                            Z.BackgroundTransparency = 1;
                                            Z.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            Z.Font = Enum.Font.GothamBold;
                                            Z.TextSize = 11;
                                            Z.TextXAlignment = Enum.TextXAlignment.Right;
                                            Z.ZIndex = 502;
                                            Z.Visible = false;
                                            local p = Instance.new("TextButton", Y);
                                            p.Size = UDim2.new(0, 16, 0, 16);
                                            p.Position = UDim2.new(1,- 22, 0, 3);
                                            p.AnchorPoint = Vector2.new(0, 0);
                                            p.BackgroundTransparency = 0.2;
                                            p.BackgroundColor3 = Color3.fromRGB(110, 110, 110);
                                            p.TextColor3 = Color3.fromRGB(235, 240, 245);
                                            p.Font = Enum.Font.GothamBold;
                                            p.TextSize = 10;
                                            p.Text = Fi and "-" or "+";
                                            p.Visible = false;
                                            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0);
                                            p.ZIndex = 510;
                                            local ki;
                                            local function xi(_i)
                                                if not _i or tonumber(_i) == nil then
                                                    return;
                                                end;
                                                if pcall(function() if Y and Y.Size and Y.Size.Y then local Li = Y.Size.Y.Offset or(A and 44 or 56); Y.Size = UDim2.new(0, tonumber(_i), 0, Li); end; if ki and ki.Size then ki.Size = UDim2.new(1, A and- 76 or- 88, 1,- 4); end; end) then
                                                    _G._GhostDuel_UI_AutoGrabBarSize = tonumber(_i);
                                                    pcall(mi);
                                                end;
                                            end;
                                            if not Fi then
                                                xi(Qi);
                                            end;
                                            p.MouseButton1Click:Connect(function() Fi = not Fi; _G._GhostDuel_UI_AutoGrabExpanded = Fi; if Fi then xi(ci); p.Text = "-"; else xi(Qi); p.Text = "+"; end; end);
                                            ki = Instance.new("Frame", Y);
                                            ki.Size = UDim2.new(1, A and- 76 or- 88, 1,- 4);
                                            ki.Position = UDim2.new(0, 2, 0, 2);
                                            ki.BackgroundColor3 = Color3.fromRGB(170, 170, 170);
                                            ki.BorderSizePixel = 0;
                                            ki.ZIndex = 500;
                                            Instance.new("UICorner", ki).CornerRadius = UDim.new(1, 0);
                                            local p = Instance.new("Frame", ki);
                                            p.Size = UDim2.new(0, 0, 1, 0);
                                            p.Position = UDim2.new(0, 0, 0, 0);
                                            p.BorderSizePixel = 0;
                                            p.BackgroundColor3 = Color3.fromRGB(125, 125, 125);
                                            p.ClipsDescendants = true;
                                            p.ZIndex = 502;
                                            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0);
                                            local ci, Qi = Instance.new("UIGradient", p), Color3.fromRGB(62, 145, 255);
                                            local function Fi(xi)
                                                Qi = Color3.fromRGB(62, 145, 255);
                                                ci.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 210, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 100, 230))});
                                                p.BackgroundColor3 = Qi;
                                            end;
                                            _G.__GhostDuelApplyAutoStealBarTheme = Fi;
                                            Fi(_G.__GhostDuelGuiTheme or "GUI 1");
                                            local ci = Instance.new("TextLabel", Y);
                                            ci.Size = UDim2.new(1, A and- 76 or- 88, 1, 0);
                                            ci.Position = UDim2.new(0, 0, 0, 0);
                                            ci.BackgroundTransparency = 1;
                                            ci.Text = "AUTO STEAL  0%";
                                            ci.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            ci.TextStrokeTransparency = 1;
                                            ci.TextSize = A and 10 or 12;
                                            ci.Font = Enum.Font.GothamBold;
                                            ci.TextXAlignment = Enum.TextXAlignment.Center;
                                            ci.ZIndex = 503;
                                            ci.Visible = true;
                                            Hi = Instance.new("TextLabel", Y);
                                            Hi.Size = UDim2.new(0, 120, 0, 15);
                                            Hi.Position = UDim2.new(0, 15, 0, 29);
                                            Hi.BackgroundTransparency = 1;
                                            Hi.Text = "";
                                            Hi.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            Hi.TextSize = 9;
                                            Hi.Font = Enum.Font.GothamBold;
                                            Hi.TextXAlignment = Enum.TextXAlignment.Left;
                                            Hi.ZIndex = 503;
                                            Hi.Visible = false;
                                            local Hi = Instance.new("TextLabel", Y);
                                            Hi.Size = UDim2.new(0, 48, 0, 18);
                                            Hi.Position = UDim2.new(1,- 138, 0.5,- 9);
                                            Hi.BackgroundTransparency = 1;
                                            Hi.Text = "0%";
                                            Hi.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            Hi.TextStrokeTransparency = 1;
                                            Hi.TextSize = 11;
                                            Hi.Font = Enum.Font.GothamBold;
                                            Hi.TextXAlignment = Enum.TextXAlignment.Right;
                                            Hi.ZIndex = 504;
                                            Hi.Visible = false;
                                            local Fi = {v1 = "v1 . 100%", v2 = "v2 . 80%"};
                                            local function xi(_i)
                                                return Fi[_i] or Fi.v1;
                                            end;
                                            local Fi = Instance.new("TextLabel", Ei);
                                            Fi.Size = UDim2.new(0.65, 0, 1, 0);
                                            Fi.AnchorPoint = Vector2.new(0.5, 0);
                                            Fi.Position = UDim2.new(0.5, 0, 0, 0);
                                            Fi.BackgroundTransparency = 1;
                                            Fi.Text = "GhostDuel Auto Grab " .. xi(k);
                                            Fi.TextColor3 = Color3.fromRGB(0, 0, 0);
                                            Fi.Font = Enum.Font.GothamBold;
                                            Fi.TextSize = 11;
                                            Fi.TextXAlignment = Enum.TextXAlignment.Center;
                                            Fi.ZIndex = 504;
                                            Fi.Visible = false;
                                            local Ei, _i, Li = false;
                                            function _G.__GhostDuelGuiPositionResetters.AutoGrab()
                                                Ei, _i, Li = false, nil, nil;
                                                Y.AnchorPoint = Vector2.new(0, 0);
                                                Y.Position = UDim2.new(0.5,- Pi / 2, 0.8, 0);
                                                _G._GhostDuel_UI_AutoGrabBarPos = nil;
                                            end;
                                            Y.InputBegan:Connect(function(Pi) if Pi.UserInputType == Enum.UserInputType.MouseButton1 or Pi.UserInputType == Enum.UserInputType.Touch then Ei = true; _i = {pointer = Pi.Position, position = Y.AbsolutePosition}; local zi, Si = Pi.UserInputType, Enum.UserInputType.Touch; if zi == Si then Li = Pi; end; end; end);
                                            Y.InputChanged:Connect(function(Pi) local zi = Pi.UserInputType == Enum.UserInputType.MouseMovement or Pi.UserInputType == Enum.UserInputType.Touch; if zi then Li = Pi; end; end);
                                            _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(Pi) if not Ei or not _i or Pi ~= Li then return; end; if Pi.UserInputType ~= Enum.UserInputType.MouseMovement and Pi.UserInputType ~= Enum.UserInputType.Touch then return; end; local zi = Pi.Position - _i.pointer; local Pi, Si = _i.position.X + zi.X, _i.position.Y + zi.Y; Y.Position = UDim2.fromOffset(Pi, Si); end));
                                            _G.__GhostDuelTrackConn (R.InputEnded:Connect(function(Pi) if Ei and(Pi.UserInputType == Enum.UserInputType.MouseButton1 or Pi.UserInputType == Enum.UserInputType.Touch) then Ei = false; local Ei = Y.AbsolutePosition; Y.AnchorPoint = Vector2.new(0, 0); Y.Position = UDim2.fromOffset(Ei.X, Ei.Y); _G._GhostDuel_UI_AutoGrabBarPos = {x = Ei.X, y = Ei.Y}; _i, Li = nil, nil; mi(); end; end));
                                            local Ei = {displayProgress = 0, radiusProgress = 0, targetInRadius = false, radiusCheckElapsed = 0, uiElapsed = 0, lastVisible = nil, lastPercent = nil, lastActive = nil, lastMode = nil};
                                            _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function(Pi) Ei.uiElapsed = Ei.uiElapsed + (Pi or 0); if Ei.uiElapsed < 0.05 then return; end; Pi = Ei.uiElapsed; Ei.uiElapsed = 0; if Ei.lastMode ~= k then Ei.lastMode = k; Fi.Text = "GhostDuel Auto Grab " .. xi(k); end; if E["auto steal"] ~= true and(J or 0) <= 0 and Ei.displayProgress <= 0.001 then if Ei.lastVisible ~= false then Y.Visible = false; Ei.lastVisible = false; end; return; end; Ei.radiusCheckElapsed = Ei.radiusCheckElapsed + (Pi or 0); local xi = _G.__GhostDuelAutoGrabRagdollBlocked == true; if xi then Ei.targetInRadius = false; Ei.radiusProgress = 0; end; if Ei.radiusCheckElapsed >= 0.25 then Ei.radiusCheckElapsed = 0; Ei.targetInRadius = false; local _i = StealState and StealState.active or f and f.busy or V3New and V3New.busy or V2Grab and V2Grab.busy; if not xi and not _i and E["auto steal"] == true and _G.__GhostDuelAutoGrabTargetInRadius then local f = math.clamp(tonumber(P.Radius) or 65, 10, 150); local _i, Li = pcall(_G.__GhostDuelAutoGrabTargetInRadius, f); Ei.targetInRadius = _i and Li == true; end; end; local f = xi and 0 or(math.clamp(J or 0, 0, 1)); if Ei.targetInRadius then if f > 0 then Ei.radiusProgress = f; else xi = math.max(0.1, tonumber(P.Duration) or 1.3); Ei.radiusProgress = Ei.radiusProgress + (Pi or 0) / xi; if Ei.radiusProgress >= 1 then Ei.radiusProgress = 0; end; end; else Ei.radiusProgress = 0; end; local J, xi = math.max(f, Ei.radiusProgress), ki.AbsoluteSize.X; xi = if(if xi <= 0 then Y.AbsoluteSize.X - (A and 76 or 88) else xi) <= 0 then A and 192 or 222 else if xi <= 0 then Y.AbsoluteSize.X - (A and 76 or 88) else xi; local ki, _i, Li = math.clamp(J * xi, 0, xi), Ei.displayProgress * xi, J > Ei.displayProgress and 18 or 22; _i += (ki - _i) * math.min(Li * Pi, 1); _i = if math.abs(_i - ki) < 0.5 then ki else _i; Ei.displayProgress = xi > 0 and(math.clamp(_i / xi, 0, 1)) or 0; p.Size = UDim2.new(0, _i, 1, 0); Li = E["auto steal"] == true or J > 0; if Li ~= Ei.lastVisible then Y.Visible = Li; Ei.lastVisible = Li; end; Li = math.floor(J * 100); Li = math.clamp(Li, 0, 100); if Li ~= Ei.lastPercent then Z.Text = tostring(Li) .. "%"; Hi.Text = tostring(Li) .. "%"; ci.Text = "AUTO STEAL  " .. tostring(Li) .. "%"; Ei.lastPercent = Li; end; f = J > 0; if f and Ei.lastActive ~= true then p.BackgroundColor3 = Qi; ii.Color = Color3.fromRGB(92, 94, 100); ii.Transparency = 0.08; Fi.TextColor3 = Color3.fromRGB(255, 255, 255); end; Ei.lastActive = f; end));
                                        end;
                                        a = Vi(o.Visuals, "VISUALS");
                                        Ni(a, "anti lag", "Anti Lag");
                                        _G.__visualSection = a;
                                        Ni(a, "ESP Players", "ESP Players");
                                        Ni(a, "Player Tracers", "Player Tracers");
                                        local J, f;
                                        local Z = _G.__optimizerMode == "Ultra" and "Ultra" or "Normal";
                                        _G.__optimizerMode = Z;
                                        local p = Ni(a, "Optimizer", "Optimizer");
                                        local Y = p and(p:FindFirstChildOfClass("TextButton"));
                                        if Y then
                                            local ci = Instance.new("TextButton", Y);
                                            ci.Size = UDim2.new(0, 66, 0, 20);
                                            ci.Position = UDim2.new(1,- 74, 0.5,- 10);
                                            ci.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                            ci.BorderSizePixel = 0;
                                            ci.TextColor3 = Color3.fromRGB(225, 238, 255);
                                            ci.TextSize = 10;
                                            ci.Font = Enum.Font.GothamBold;
                                            ci.AutoButtonColor = false;
                                            ci.ZIndex = 30;
                                            Instance.new("UICorner", ci).CornerRadius = UDim.new(0, 4);
                                            p = Instance.new("UIStroke", ci);
                                            p.Color = Color3.fromRGB(255, 255, 255);
                                            p.Thickness = 1;
                                            p.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                            local function ii()
                                                ci.Text = string.upper(Z);
                                            end;
                                            ii();
                                            u(ci, function() Z = Z == "Normal" and "Ultra" or "Normal"; _G.__optimizerMode = Z; ii(); mi(); if E.Optimizer and W.Optimizer then W.Optimizer(false); W.Optimizer(true); end; end);
                                        end;
                                        do
                                            local ci, ii, Qi, Hi, Ei = false;
                                            local Fi, Pi, ki, xi, _i, Li, zi = 0, {}, {}, 0, 0, false, {{"DFIntConnectionMTUSize", "1400"}, {"DFIntRakNetResendBufferArrayLength", "1024"}, {"DFIntRaknetNakResendDelayMsMax", "1"}, {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"}, {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"}, {"DFIntServerFramesBetweenJoins", "1"}, {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"}, {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"}, {"DFIntWaitOnRecvFromLoopEndedMS", "100"}, {"DFIntLargePacketQueueSizeCutoffMB", "1000"}, {"DFIntSendRakNetStatsInterval", "2147483647"}, {"DFIntRakNetLoopMs", "1"}, {"DFIntRakNetSelectTimeoutMs", "1"}, {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"}, {"DFIntReplicationDataCacheNumParallelTasks", "8"}, {"DFIntMegaReplicatorNumParallelTasks", "16"}, {"DFIntMegaReplicatorNetworkQualityProcessorUnit", "10"}, {"DFIntMaxProcessPacketsStepsPerCyclic", "512"}, {"DFIntMaxProcessPacketsStepsAccumulated", "0"}, {"DFIntMaxProcessPacketsJobScaling", "1000"}, {"DFIntClientPacketMaxFrameMicroseconds", "200000"}, {"DFIntClientPacketExcessMicroseconds", "10000"}, {"DFIntClientPacketMinMicroseconds", "1"}, {"DFIntClientPacketMaxDelayMs", "1"}, {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"}, {"DFIntMaxFrameBufferSize", "4"}, {"DFIntBufferCompressionThreshold", "100"}, {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"}, {"DFIntTaskSchedulerJobInGameThreads", "8"}, {"FIntTaskSchedulerAutoThreadLimit", "16"}, {"DFIntTaskSchedulerJobInitThreads", "8"}, {"DFIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"}, {"DFIntRuntimeConcurrency", "16"}, {"FIntSimWorldTaskQueueParallelTasks", "20"}, {"DFIntHttpBatchLimit", "256"}, {"DFIntHttpCurlConnectionCacheSize", "512"}, {"FIntDefaultMeshCacheSizeMB", "512"}, {"DFIntMemCacheMaxCapacityMB", "256"}, {"DFIntNumAssetsMaxToPreload", "1"}, {"DFFlagEnableSoundPreloading", "false"}, {"FFlagSlimContentProvider", "true"}, {"DFIntTextureQualityOverride", "0"}, {"FIntDebugTextureManagerSkipMips", "7"}, {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"}, {"FFlagTM2SkipMipsForUnstreamable2", "true"}, {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"}, {"FFlagRenderUseTextureManager224", "false"}, {"DFIntDebugFRMQualityLevelOverride", "1"}, {"DFFlagDebugSkipMeshVoxelizer", "true"}, {"DFFlagDebugPauseVoxelizer", "true"}, {"FFlagFastGPULightCulling3", "true"}, {"FIntRenderLocalLightFadeInMs", "0"}, {"FIntRenderLocalLightUpdatesMax", "1"}, {"FIntRenderShadowmapBias", "0"}, {"FIntSSAOMipLevels", "0"}, {"FIntDebugForceMSAASamples", "1"}, {"FIntDebugFRMOptionalMSAALevelOverride", "0"}, {"FIntRobloxGuiBlurIntensity", "0"}, {"FIntFRMMinGrassDistance", "0"}, {"FIntFRMMaxGrassDistance", "0"}, {"DFFlagCoreScriptTelemetry2", "false"}, {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"}, {"FFlagPerfDataOnTelemetryV2", "false"}, {"FFlagSendRenderFidelityTelemetry2", "false"}, {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"}, {"DFIntTelemetryProfilerHundredthsPercentage", "0"}, {"FIntTelemetryProfilerFrequency", "0"}, {"FIntPerformanceTelemetryQueueProcessLimit", "0"}, {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"}};
                                            function _G.__GhostDuelPreserveOptimizerUI (Si)
                                                if not Si then
                                                    return false;
                                                end;
                                                local gi = Si;
                                                while gi and gi ~= workspace and gi ~= game do
                                                    if gi:IsA("BillboardGui") or(gi:IsA("SurfaceGui")) or(gi:IsA("ScreenGui")) or(gi:IsA("GuiObject")) or(gi:IsA("UIComponent")) then
                                                        return true;
                                                    end;
                                                    gi = gi.Parent;
                                                end;
                                                return false;
                                            end;
                                            local function Si(gi)
                                                local Oi = type(getgenv) == "function" and(getgenv()) or _G;
                                                local ni, Ji = rawget(Oi, "setfflag") or(rawget(_G, "set_fflag")), rawget(Oi, "getfflag") or(rawget(_G, "get_fflag"));
                                                if type(ni) ~= "function" then
                                                    return;
                                                end;
                                                for fi, oi in ipairs(zi) do
                                                    if not ci or gi ~= _i then
                                                        return;
                                                    end;
                                                    Oi = true;
                                                    if type(Ji) == "function" then
                                                        local zi, gi = pcall(Ji, oi[1]);
                                                        Oi = zi and gi ~= nil;
                                                    end;
                                                    if Oi then
                                                        pcall(ni, oi[1], oi[2]);
                                                    end;
                                                    if fi % 8 == 0 then
                                                        c.Heartbeat:Wait();
                                                    end;
                                                end;
                                            end;
                                            local function zi(gi)
                                                pcall(function() if _G.__GhostDuelPreserveOptimizerUI (gi) then return; end; local Oi = m.Character; if Oi and(gi == Oi or(gi:IsDescendantOf(Oi))) then return; end; if gi:IsDescendantOf(Q) then return; end; if gi:IsA("Sky") or(gi:IsA("Atmosphere")) or(gi:IsA("ColorCorrectionEffect")) or(gi:IsA("BloomEffect")) or(gi:IsA("BlurEffect")) or(gi:IsA("Sparkles")) or(gi:IsA("PostEffect")) then return; end; if not(Z == "Ultra") then if gi:IsA("ParticleEmitter") or(gi:IsA("Trail")) or(gi:IsA("Smoke")) or(gi:IsA("Fire")) or(gi:IsA("Sparkles")) or(gi:IsA("PostEffect")) then gi.Enabled = false; end; if tick() <= xi and(gi:IsA("Decal") or(gi:IsA("Texture"))) then gi.Transparency = 1; end; return; end; if gi:IsA("Accessory") or(gi:IsA("Hat")) or(gi:IsA("Clothing")) or(gi:IsA("Shirt")) or(gi:IsA("Pants")) or(gi:IsA("ShirtGraphic")) then gi:Destroy(); elseif gi:IsA("BasePart") then gi.Material = Enum.Material.Plastic; gi.Reflectance = 0; gi.CastShadow = false; elseif gi:IsA("Decal") or(gi:IsA("Texture")) then gi.Transparency = 1; elseif gi:IsA("ParticleEmitter") or(gi:IsA("Trail")) or(gi:IsA("Beam")) or(gi:IsA("Fire")) or(gi:IsA("Smoke")) or(gi:IsA("Sparkles")) then gi.Enabled = false; elseif gi:IsA("AnimationController") or(gi:IsA("Animator")) then for Oi, Oi in ipairs(gi:GetPlayingAnimationTracks()) do pcall(function() Oi:Stop(0); end); end; end; end);
                                            end;
                                            local function gi(Oi)
                                                if Ei then
                                                    Ei();
                                                end;
                                                local ni = Z == "Ultra" and {workspace} or {workspace, Q};
                                                Ei = _G.__GhostDuelWalkDescendantsBatched (ni, zi, function() return ci and Oi == Fi; end);
                                            end;
                                            local function Oi()
                                                if Pi.Brightness == nil then
                                                    Pi.Brightness, Pi.ClockTime, Pi.OutdoorAmbient = Q.Brightness, Q.ClockTime, Q.OutdoorAmbient;
                                                end;
                                                if ki.Decoration == nil then
                                                    local ni = workspace:FindFirstChildOfClass("Terrain");
                                                    if ni then
                                                        ki = {terrain = ni, Decoration = ni.Decoration, WaterWaveSize = ni.WaterWaveSize, WaterWaveSpeed = ni.WaterWaveSpeed, WaterReflectance = ni.WaterReflectance};
                                                    end;
                                                end;
                                                if Z == "Normal" then
                                                    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01; end);
                                                    pcall(function() Q.GlobalShadows = false; Q.EnvironmentDiffuseScale = 0; Q.EnvironmentSpecularScale = 0; end);
                                                else
                                                    pcall(function() Q.GlobalShadows = false; Q.FogEnd = 10000000000; Q.Brightness = 1; Q.EnvironmentDiffuseScale = 0; Q.EnvironmentSpecularScale = 0; end);
                                                end;
                                                local ni = ki.terrain;
                                                if ni then
                                                    pcall(function() ni.Decoration = false; ni.WaterWaveSize = 0; ni.WaterWaveSpeed = 0; ni.WaterReflectance = 0; end);
                                                end;
                                                for ni, ni in ipairs(Q:GetChildren()) do
                                                    if ni:IsA("PostEffect") then
                                                        pcall(function() ni.Enabled = false; end);
                                                    end;
                                                end;
                                            end;
                                            local function ni()
                                                pcall(function() if Pi.Brightness ~= nil then Q.Brightness = Pi.Brightness; Q.ClockTime = Pi.ClockTime; Q.OutdoorAmbient = Pi.OutdoorAmbient; end; Q.ExposureCompensation = 0; Q.GlobalShadows = true; Q.FogEnd = 100000; Q.EnvironmentDiffuseScale = 1; Q.EnvironmentSpecularScale = 1; end);
                                                local Pi = ki.terrain;
                                                if Pi then
                                                    pcall(function() Pi.Decoration = ki.Decoration; Pi.WaterWaveSize = ki.WaterWaveSize; Pi.WaterWaveSpeed = ki.WaterWaveSpeed; Pi.WaterReflectance = ki.WaterReflectance; end);
                                                end;
                                            end;
                                            local function Pi()
                                                if not ci then
                                                    return;
                                                end;
                                                ci, Li = false, false;
                                                Fi += 1;
                                                _i += 1;
                                                if Ei then
                                                    Ei();
                                                    Ei = nil;
                                                end;
                                                if ii then
                                                    ii:Disconnect();
                                                    ii = nil;
                                                end;
                                                if Qi then
                                                    Qi:Disconnect();
                                                    Qi = nil;
                                                end;
                                                if Hi then
                                                    Hi:Disconnect();
                                                    Hi = nil;
                                                end;
                                                ni();
                                            end;
                                            local function Ei()
                                                if ci then
                                                    return;
                                                end;
                                                ci, Li = true, true;
                                                Fi += 1;
                                                local ki = Fi;
                                                if Z == "Normal" then
                                                    xi = tick() + 1;
                                                    _i += 1;
                                                    local Z = _i;
                                                    task.spawn(function() Si(Z); end);
                                                end;
                                                Oi();
                                                gi(ki);
                                                ii = workspace.DescendantAdded:Connect(function(Z) if ci and ki == Fi then zi(Z); end; end);
                                                Qi = Q.DescendantAdded:Connect(function(Z) if ci and ki == Fi then zi(Z); end; end);
                                                Hi = m.CharacterAdded:Connect(function(Z) task.delay(0.5, function() if ci and ki == Fi then gi(ki); end; end); end);
                                                task.spawn(function() while ci and ki == Fi do task.wait(20); if ci and ki == Fi then gi(ki); end; end; end);
                                            end;
                                            W.Optimizer = function(Z)
                                                if Z then
                                                    Ei();
                                                else
                                                    Pi();
                                                end;
                                            end;
                                            _G.__GhostDuelTrackStopper (Pi);
                                        end;
                                        i(a, "FOV", "Custom FOV");
                                        do
                                            local Z, ci, ii = false;
                                            local function Qi()
                                                if Z then
                                                    return;
                                                end;
                                                Z = true;
                                                E["Custom FOV"] = true;
                                                if ci then
                                                    ci:Disconnect();
                                                end;
                                                local Hi = workspace.CurrentCamera;
                                                local Ei = Hi and ii == nil;
                                                if Ei then
                                                    ii = Hi.FieldOfView;
                                                end;
                                                ci = c.RenderStepped:Connect(function() if not Z then return; end; local Ei, Fi = workspace.CurrentCamera, N.FOV or 90; if Ei and math.abs(Ei.FieldOfView - Fi) > 0.01 then Ei.FieldOfView = Fi; end; end);
                                                if Hi then
                                                    Hi.FieldOfView = N.FOV or 90;
                                                end;
                                                task.defer(mi);
                                            end;
                                            local function Hi()
                                                if not Z then
                                                    return;
                                                end;
                                                Z = false;
                                                E["Custom FOV"] = false;
                                                if ci then
                                                    ci:Disconnect();
                                                    ci = nil;
                                                end;
                                                local Z = workspace.CurrentCamera;
                                                if Z then
                                                    Z.FieldOfView = ii or 90;
                                                end;
                                                ii = nil;
                                                task.defer(mi);
                                            end;
                                            W["Custom FOV"] = function(Z)
                                                if Z then
                                                    Qi();
                                                else
                                                    Hi();
                                                end;
                                            end;
                                            _G.__GhostDuelTrackStopper (Hi);
                                            if E["Custom FOV"] then
                                                task.defer(Qi);
                                            end;
                                        end;
                                        Ni(a, "Stretchz Res", "Stretchz Res");
                                        do
                                            local Z, ci = false;
                                            local function ii(Qi)
                                                local Hi = workspace.CurrentCamera;
                                                if Hi then
                                                    pcall(function() Hi.FieldOfView = Qi; end);
                                                end;
                                            end;
                                            local function Qi()
                                                if Z then
                                                    return;
                                                end;
                                                Z = true;
                                                E["Stretchz Res"] = true;
                                                local Hi = workspace.CurrentCamera;
                                                if not Hi then
                                                    return;
                                                end;
                                                if ci then
                                                    ci:Disconnect();
                                                end;
                                                ci = c.RenderStepped:Connect(function() if not Z then return; end; ii(90); pcall(function() Hi.CFrame = Hi.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1); end); end);
                                                ii(90);
                                                task.defer(mi);
                                            end;
                                            local function ii()
                                                Z = false;
                                                E["Stretchz Res"] = false;
                                                if ci then
                                                    ci:Disconnect();
                                                    ci = nil;
                                                end;
                                                local Z = workspace.CurrentCamera;
                                                if Z then
                                                    pcall(function() Z.FieldOfView = 90; end);
                                                end;
                                                task.defer(mi);
                                            end;
                                            W["Stretchz Res"] = function(Z)
                                                if Z then
                                                    Qi();
                                                else
                                                    ii();
                                                end;
                                            end;
                                            _G.__GhostDuelTrackStopper (ii);
                                            if E["Stretchz Res"] then
                                                task.defer(Qi);
                                            end;
                                        end;
                                        do
                                            local Z = _G.__GhostDuelSkinChangerState;
                                            if type(Z) ~= "table" or Z.version ~= 2 then
                                                if type(Z) == "table" and m.Character then
                                                    local ci, ii = Z.originals and Z.originals[m.Character], m.Character:FindFirstChildOfClass("Humanoid");
                                                    if typeof(ci) == "Instance" and ii then
                                                        pcall(function() ii:ApplyDescription(ci:Clone()); end);
                                                    end;
                                                end;
                                                Z = {version = 2, originals = setmetatable({}, {__mode = "k"}), templates = {}};
                                                _G.__GhostDuelSkinChangerState = Z;
                                            end;
                                            Z.isHair = function(ci)
                                                if not ci:IsA("Accessory") then
                                                    return false;
                                                end;
                                                local ii, Qi = pcall(function() return ci.AccessoryType == Enum.AccessoryType.Hair; end);
                                                return ii and Qi or ci:FindFirstChild("HairAttachment", true) ~= nil;
                                            end;
                                            Z.resolveTemplate = function(ci, ii, Qi)
                                                local Hi = ii .. ":" .. tostring(ci);
                                                if Z.templates[Hi] then
                                                    return Z.templates[Hi];
                                                end;
                                                local Ei = "rbxassetid://" .. tostring(ci);
                                                local Fi, Pi = pcall(function() return game:GetObjects(Ei); end);
                                                if Fi and Pi and Pi[1] then
                                                    local Fi = Pi[1];
                                                    ci = Fi:IsA(ii) and Fi or(Fi:FindFirstChildWhichIsA(ii, true));
                                                    if ci and ci[Qi] ~= "" then
                                                        Ei = ci[Qi];
                                                    end;
                                                    pcall(function() Fi:Destroy(); end);
                                                end;
                                                Z.templates[Hi] = Ei;
                                                return Ei;
                                            end;
                                            Z.removeChanged = function(ci)
                                                for ii, ii in ipairs(ci:GetChildren()) do
                                                    if ii:IsA("Shirt") or(ii:IsA("Pants")) or ii.Name == "GhostDuelSkinChanger_Hair" or(Z.isHair(ii)) then
                                                        pcall(function() ii:Destroy(); end);
                                                    end;
                                                end;
                                            end;
                                            Z.capture = function(ci)
                                                if Z.originals[ci] then
                                                    return;
                                                end;
                                                local ii = {items = {}};
                                                for Qi, Qi in ipairs(ci:GetChildren()) do
                                                    if Qi:IsA("Shirt") or(Qi:IsA("Pants")) or(Z.isHair(Qi)) then
                                                        table.insert(ii.items, Qi:Clone());
                                                    end;
                                                end;
                                                Z.originals[ci] = ii;
                                            end;
                                            Z.presets = {V1 = {shirt = 74707712629633, pants = 12405320750, hair = 140188532534398}, V2 = {shirt = 101796619834594, pants = 18975891159, hair = 115520061093937}, V3 = {shirt = 18552805597, pants = 5414143509, hair = 84008082880128}};
                                            Z.attachHair = function(ci, ii, Qi, Hi)
                                                local Ei, Fi = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(Qi)); end);
                                                if not Ei or not Fi or not Fi[1] then
                                                    warn("[Skin Changer] No se pudo cargar el pelo " .. tostring(Qi) .. ": " .. tostring(Fi));
                                                    return false;
                                                end;
                                                local Qi = Fi[1];
                                                Fi = Qi:IsA("Accessory") and Qi or(Qi:FindFirstChildWhichIsA("Accessory", true));
                                                if not Fi then
                                                    Qi:Destroy();
                                                    warn("[Skin Changer] El asset de pelo no contiene un Accessory");
                                                    return false;
                                                end;
                                                local Pi = Fi:Clone();
                                                Pi.Name = "GhostDuelSkinChanger_Hair";
                                                pcall(function() Qi:Destroy(); end);
                                                local Qi, ki = ci:FindFirstChild("Head"), Pi:FindFirstChild("Handle");
                                                if not Qi or not ki or not ki:IsA("BasePart") then
                                                    Pi:Destroy();
                                                    warn("[Skin Changer] Falta Head o Handle para colocar el pelo");
                                                    return false;
                                                end;
                                                if not E["Skin Changer"] or m.Character ~= ci or Z.generation ~= Hi then
                                                    Pi:Destroy();
                                                    return false;
                                                end;
                                                Ei, Fi = pcall(function() for Hi, Hi in ipairs(Pi:GetDescendants()) do if Hi:IsA("BasePart") then Hi.Anchored = false; Hi.CanCollide = false; Hi.Massless = true; Hi.LocalTransparencyModifier = 0; end; end; ki.Transparency = 0; pcall(function() ii:AddAccessory(Pi); end); Pi.Parent = ci; local ci, ii; for Hi, xi in ipairs(ki:GetChildren()) do if xi:IsA("Attachment") then Hi = Qi:FindFirstChild(xi.Name); if Hi and(Hi:IsA("Attachment")) then ci, ii = xi, Hi; break; end; end; end; local Hi, xi, _i = ci and ci.CFrame or Pi.AttachmentPoint, ii and ii.CFrame or(CFrame.new(0, Qi.Size.Y / 2, 0)), ki:FindFirstChild("AccessoryWeld"); if _i then _i:Destroy(); end; ki.CFrame = Qi.CFrame * xi * Hi:Inverse(); _i = Instance.new("Weld"); _i.Name = "AccessoryWeld"; _i.Part0 = ki; _i.Part1 = Qi; _i.C0 = Hi; _i.C1 = xi; _i.Parent = ki; end);
                                                if not Ei then
                                                    Pi:Destroy();
                                                    warn("[Skin Changer] No se pudo colocar el pelo: " .. tostring(Fi));
                                                end;
                                                return Ei;
                                            end;
                                            Z.apply = function(ci, ii)
                                                Z.generation = (Z.generation or 0) + 1;
                                                local Qi = Z.generation;
                                                ii = ii or m.Character;
                                                if not ii then
                                                    return false;
                                                end;
                                                local Hi = ii:FindFirstChildOfClass("Humanoid") or(ii:WaitForChild("Humanoid", 10));
                                                if not Hi then
                                                    return false;
                                                end;
                                                if Qi ~= Z.generation then
                                                    return false;
                                                end;
                                                if ci then
                                                    local ci = Z.presets[x] or Z.presets.V1;
                                                    local Ei, Fi = Z.resolveTemplate(ci.shirt, "Shirt", "ShirtTemplate"), Z.resolveTemplate(ci.pants, "Pants", "PantsTemplate");
                                                    if Qi ~= Z.generation or not E["Skin Changer"] or m.Character ~= ii then
                                                        return false;
                                                    end;
                                                    Z.capture(ii);
                                                    Z.removeChanged(ii);
                                                    local Pi = Instance.new("Shirt");
                                                    Pi.Name = "GhostDuelSkinChanger_Shirt";
                                                    Pi.ShirtTemplate = Ei;
                                                    Pi.Parent = ii;
                                                    Ei = Instance.new("Pants");
                                                    Ei.Name = "GhostDuelSkinChanger_Pants";
                                                    Ei.PantsTemplate = Fi;
                                                    Ei.Parent = ii;
                                                    return Z.attachHair(ii, Hi, ci.hair, Qi);
                                                end;
                                                Qi = Z.originals[ii];
                                                Z.removeChanged(ii);
                                                if not Qi then
                                                    return false;
                                                end;
                                                for ci, ci in ipairs(Qi.items) do
                                                    local Qi = ci:Clone();
                                                    if Qi:IsA("Accessory") then
                                                        pcall(function() Hi:AddAccessory(Qi); end);
                                                    else
                                                        Qi.Parent = ii;
                                                    end;
                                                end;
                                                return true;
                                            end;
                                            W["Skin Changer"] = function(ci)
                                                task.spawn(function() if ci ~= (E["Skin Changer"] == true) then return; end; Z.apply(ci == true, m.Character); end);
                                            end;
                                            _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(ci) if not E["Skin Changer"] then return; end; task.wait(0.75); if E["Skin Changer"] then Z.apply(true, ci); end; end));
                                            if E["Skin Changer"] then
                                                task.delay(0.5, Z.apply, true, m.Character);
                                            end;
                                        end;
                                        do
                                            local Z = _G.__GhostDuelVisualAppearanceState;
                                            if type(Z) ~= "table" or Z.version ~= 2 then
                                                Z = {version = 2, headless = setmetatable({}, {__mode = "k"}), korblox = setmetatable({}, {__mode = "k"})};
                                                _G.__GhostDuelVisualAppearanceState = Z;
                                            end;
                                            Z.setHeadless = function(ci, ii)
                                                ii = ii or m.Character;
                                                local Qi = ii and(ii:FindFirstChild("Head"));
                                                if not Qi or not Qi:IsA("BasePart") then
                                                    return false;
                                                end;
                                                if ci then
                                                    if not Z.headless[ii] then
                                                        local Hi = {headTransparency = Qi.Transparency, headLocalTransparency = Qi.LocalTransparencyModifier, faces = {}};
                                                        for Ei, Ei in ipairs(Qi:GetChildren()) do
                                                            if Ei:IsA("Decal") or(Ei:IsA("Texture")) then
                                                                table.insert(Hi.faces, {item = Ei, transparency = Ei.Transparency});
                                                            end;
                                                        end;
                                                        Z.headless[ii] = Hi;
                                                    end;
                                                    Qi.Transparency = 1;
                                                    Qi.LocalTransparencyModifier = 1;
                                                    for Hi, Hi in ipairs(Qi:GetChildren()) do
                                                        if Hi:IsA("Decal") or(Hi:IsA("Texture")) then
                                                            Hi.Transparency = 1;
                                                        end;
                                                    end;
                                                    return true;
                                                end;
                                                ci = Z.headless[ii];
                                                if not ci then
                                                    return false;
                                                end;
                                                Qi.Transparency = ci.headTransparency;
                                                Qi.LocalTransparencyModifier = ci.headLocalTransparency;
                                                for ii, ii in ipairs(ci.faces) do
                                                    if ii.item and ii.item.Parent then
                                                        ii.item.Transparency = ii.transparency;
                                                    end;
                                                end;
                                                return true;
                                            end;
                                            Z.setKorblox = function(ci, ii)
                                                ii = ii or m.Character;
                                                if not ii then
                                                    return false;
                                                end;
                                                local Qi = Z.korblox[ii];
                                                if not ci then
                                                    local Hi = ii:FindFirstChild("GhostDuelVisual_Korblox");
                                                    if Hi then
                                                        pcall(function() Hi:Destroy(); end);
                                                    end;
                                                    for Hi, Hi in ipairs(ii:GetChildren()) do
                                                        if Hi:IsA("CharacterMesh") and Hi.Name == "GhostDuelVisual_KorbloxCharacterMesh" then
                                                            pcall(function() Hi:Destroy(); end);
                                                        end;
                                                    end;
                                                    if not Qi then
                                                        return false;
                                                    end;
                                                    for Hi, Hi in ipairs(Qi.parts) do
                                                        if Hi.part and Hi.part.Parent then
                                                            Hi.part.Transparency = Hi.transparency;
                                                            Hi.part.LocalTransparencyModifier = Hi.localTransparency;
                                                        end;
                                                    end;
                                                    return true;
                                                end;
                                                ci = ii:FindFirstChild("LeftUpperLeg") or(ii:FindFirstChild("Left Leg"));
                                                if not ci or not ci:IsA("BasePart") then
                                                    return false;
                                                end;
                                                local Hi, Ei = pcall(function() return game:GetObjects("rbxassetid://139607673"); end);
                                                if not Hi or not Ei or not Ei[1] then
                                                    warn("GhostDuel Korblox: no se pudo cargar el asset 139607673");
                                                    return false;
                                                end;
                                                local Fi = ii:FindFirstChild("GhostDuelVisual_Korblox");
                                                if Fi then
                                                    pcall(function() Fi:Destroy(); end);
                                                end;
                                                for Fi, Fi in ipairs(ii:GetChildren()) do
                                                    if Fi:IsA("CharacterMesh") and Fi.Name == "GhostDuelVisual_KorbloxCharacterMesh" then
                                                        pcall(function() Fi:Destroy(); end);
                                                    end;
                                                end;
                                                Hi = Instance.new("Model");
                                                Hi.Name = "GhostDuelVisual_Korblox";
                                                for Fi, Fi in ipairs(Ei) do
                                                    Fi.Parent = Hi;
                                                end;
                                                Ei = {};
                                                for Fi, Fi in ipairs(Hi:GetDescendants()) do
                                                    if Fi:IsA("BasePart") then
                                                        table.insert(Ei, Fi);
                                                    end;
                                                end;
                                                local Fi = {};
                                                for Pi, Pi in ipairs(Hi:GetDescendants()) do
                                                    if Pi:IsA("CharacterMesh") then
                                                        table.insert(Fi, Pi);
                                                    end;
                                                end;
                                                if #Ei == 0 and #Fi == 0 then
                                                    Hi:Destroy();
                                                    warn("GhostDuel Korblox: el asset 139607673 no contiene piezas compatibles");
                                                    return false;
                                                end;
                                                if not Qi then
                                                    Qi = {parts = {}};
                                                    local Pi = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"};
                                                    for ki, xi in ipairs(Pi) do
                                                        ki = ii:FindFirstChild(xi);
                                                        if ki and(ki:IsA("BasePart")) then
                                                            table.insert(Qi.parts, {part = ki, transparency = ki.Transparency, localTransparency = ki.LocalTransparencyModifier});
                                                        end;
                                                    end;
                                                    Z.korblox[ii] = Qi;
                                                end;
                                                Hi.Parent = ii;
                                                if ii:FindFirstChild("LeftUpperLeg") ~= nil then
                                                    for Hi, Hi in ipairs(Qi.parts) do
                                                        if Hi.part and Hi.part.Parent then
                                                            Hi.part.Transparency = 1;
                                                            Hi.part.LocalTransparencyModifier = 1;
                                                        end;
                                                    end;
                                                end;
                                                for Hi, Pi in ipairs(Ei) do
                                                    Hi = ii:FindFirstChild(Pi.Name);
                                                    Hi = if not Hi or not Hi:IsA("BasePart") then
                                                        ci
                                                    else
                                                        Hi;
                                                        Pi.Anchored = false;
                                                        Pi.CanCollide = false;
                                                        Pi.Massless = true;
                                                        Pi.CFrame = Hi.CFrame;
                                                        Qi = Instance.new("WeldConstraint");
                                                        Qi.Part0 = Hi;
                                                        Qi.Part1 = Pi;
                                                        Qi.Parent = Pi;
                                                    end;
                                                    for ci, ci in ipairs(Fi) do
                                                        ci.Name = "GhostDuelVisual_KorbloxCharacterMesh";
                                                        ci.Parent = ii;
                                                    end;
                                                    return true;
                                                end;
                                                W["Headless Visual"] = function(ci)
                                                    Z.setHeadless(ci == true, m.Character);
                                                end;
                                                W["Korblox Visual"] = function(ci)
                                                    task.spawn(Z.setKorblox, ci == true, m.Character);
                                                end;
                                                _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(ci) task.wait(0.75); if E["Headless Visual"] then Z.setHeadless(true, ci); end; if E["Korblox Visual"] then Z.setKorblox(true, ci); end; end));
                                                if E["Headless Visual"] then
                                                    task.delay(0.5, Z.setHeadless, true, m.Character);
                                                end;
                                                if E["Korblox Visual"] then
                                                    task.delay(0.5, Z.setKorblox, true, m.Character);
                                                end;
                                            end;
                                            do
                                                local Z, ci = {Ambient = Q.Ambient, Brightness = Q.Brightness, ClockTime = Q.ClockTime, FogColor = Q.FogColor, FogEnd = Q.FogEnd, GlobalShadows = Q.GlobalShadows, EnvironmentDiffuseScale = Q.EnvironmentDiffuseScale, EnvironmentSpecularScale = Q.EnvironmentSpecularScale, OutdoorAmbient = Q.OutdoorAmbient};
                                                f = _G.__GhostDuelSkyChangerMode or "blue";
                                                local function ii()
                                                    if ci then
                                                        pcall(function() ci:Destroy(); end);
                                                        ci = nil;
                                                    end;
                                                end;
                                                local function Qi()
                                                    ii();
                                                    pcall(function() Q.Ambient = Z.Ambient; Q.Brightness = Z.Brightness; Q.ClockTime = Z.ClockTime; Q.FogColor = Z.FogColor; Q.FogEnd = Z.FogEnd; Q.GlobalShadows = Z.GlobalShadows; Q.EnvironmentDiffuseScale = Z.EnvironmentDiffuseScale; Q.EnvironmentSpecularScale = Z.EnvironmentSpecularScale; Q.OutdoorAmbient = Z.OutdoorAmbient; end);
                                                end;
                                                J = function(Z)
                                                    if Z == nil or Z == "none" then
                                                        Qi();
                                                        return;
                                                    end;
                                                    ii();
                                                    local ii = Instance.new("ColorCorrectionEffect");
                                                    ii.Parent = Q;
                                                    ci = ii;
                                                    if Z == "blue" then
                                                        Q.Ambient = Color3.fromRGB(30, 60, 120);
                                                        Q.FogColor = Color3.fromRGB(40, 80, 160);
                                                        ii.TintColor = Color3.fromRGB(140, 180, 255);
                                                        ii.Saturation = 0.4;
                                                        ii.Contrast = 0.1;
                                                    elseif Z == "night" then
                                                        Q.ClockTime = 0;
                                                        Q.Brightness = 0.2;
                                                        Q.Ambient = Color3.fromRGB(20, 20, 35);
                                                        ii.TintColor = Color3.fromRGB(180, 180, 220);
                                                        ii.Saturation =- 0.2;
                                                        ii.Contrast = 0.1;
                                                    elseif Z == "day" then
                                                        Q.ClockTime = 14;
                                                        Q.Brightness = 2;
                                                        Q.Ambient = Color3.fromRGB(140, 140, 140);
                                                        ii.TintColor = Color3.fromRGB(255, 255, 255);
                                                        ii.Saturation = 0.1;
                                                        ii.Contrast = 0;
                                                    end;
                                                end;
                                                W["Sky Changer"] = function(Q)
                                                    if Q then
                                                        J(f);
                                                    else
                                                        Qi();
                                                    end;
                                                end;
                                                i = Ni(a, "Sky Changer", "Sky Changer");
                                                if i then
                                                    local Q = Instance.new("TextButton", i);
                                                    Q.Name = "SkyModeBtn";
                                                    Q.Size = UDim2.new(0, 66, 0, 20);
                                                    Q.Position = UDim2.new(1,- 74, 0.5,- 10);
                                                    Q.AnchorPoint = Vector2.new(0, 0);
                                                    Q.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                    Q.BorderSizePixel = 0;
                                                    Q.Text = "BLUE";
                                                    Q.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                    Q.Font = Enum.Font.GothamBold;
                                                    Q.TextSize = 10;
                                                    Q.AutoButtonColor = false;
                                                    Q.ZIndex = 30;
                                                    Instance.new("UICorner", Q).CornerRadius = UDim.new(0, 4);
                                                    local Z = Instance.new("UIStroke", Q);
                                                    Z.Color = Color3.fromRGB(255, 255, 255);
                                                    Z.Thickness = 1;
                                                    Z.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                    local function ci()
                                                        Q.Text = f == "day" and "DAY" or f == "night" and "NIGHT" or "BLUE";
                                                        Q.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                        Q.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                        Z.Color = Color3.fromRGB(255, 255, 255);
                                                        Z.Thickness = 1;
                                                        Q.TextStrokeTransparency = 1;
                                                    end;
                                                    ci();
                                                    u(Q, function() f = if f == "day" then "blue" else if f == "blue" then "night" else "day"; _G.__GhostDuelSkyChangerMode = f; mi(); ci(); if E["Sky Changer"] then J(f); end; end);
                                                end;
                                                if E["Sky Changer"] then
                                                    task.delay(0.2, function() J(f); end);
                                                end;
                                            end;
                                            Ni(a, "Show Buttons", "Show Buttons");
                                            Ni(a, "Lock Buttons", "Lock Buttons");
                                            do
                                                i = Instance.new("Frame", a);
                                                i.Name = "MainThemesBtnContainer";
                                                i.Visible = false;
                                                i.Size = UDim2.new(1, 0, 0, 30);
                                                i.BackgroundTransparency = 1;
                                                i.BorderSizePixel = 0;
                                                i.ZIndex = 12;
                                                Y = Instance.new("TextButton", i);
                                                Y.Name = "MainThemesBtn";
                                                Y.AnchorPoint = Vector2.new(0.5, 0);
                                                Y.Size = UDim2.new(0, 150, 0, 30);
                                                Y.Position = UDim2.new(0.5, 0, 0, 0);
                                                Y.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                Y.BackgroundTransparency = 0.12;
                                                Y.AutoButtonColor = false;
                                                Y.Font = Enum.Font.GothamBold;
                                                Y.Text = "Themes";
                                                Y.TextColor3 = Color3.fromRGB(235, 240, 245);
                                                Y.TextSize = 11;
                                                Y.ZIndex = 12;
                                                Y.TextXAlignment = Enum.TextXAlignment.Center;
                                                Y.TextYAlignment = Enum.TextYAlignment.Center;
                                                Instance.new("UICorner", Y).CornerRadius = UDim.new(0, 8);
                                                p = Instance.new("UIStroke", Y);
                                                p.Color = Color3.fromRGB(255, 255, 255);
                                                p.Thickness = 1.2;
                                                p.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                p.Transparency = 0.15;
                                                local Q = Instance.new("Frame");
                                                Q.Name = "MainThemesPanel";
                                                Q.Size = UDim2.fromOffset(260, 268);
                                                Q.BackgroundColor3 = Color3.fromRGB(48, 92, 138);
                                                Q.BorderSizePixel = 0;
                                                Q.Visible = false;
                                                Q.ZIndex = 20;
                                                Q.Parent = V;
                                                local Z = Instance.new("UIGradient", Q);
                                                Z.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 75, 118)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(67, 120, 174)), ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 67, 108))});
                                                Z.Rotation = 35;
                                                local function ci()
                                                    if C then
                                                        local ii = C.Position.X.Offset + C.Size.X.Offset;
                                                        Q.Position = UDim2.new(C.Position.X.Scale, ii + 24, C.Position.Y.Scale, C.Position.Y.Offset + 6);
                                                    end;
                                                end;
                                                if C then
                                                    C:GetPropertyChangedSignal("Position"):Connect(function() if _G.__GhostDuelModernGuiActive or not Q.Parent then return; end; if Q.Visible then ci(); end; end);
                                                    C:GetPropertyChangedSignal("Size"):Connect(function() if _G.__GhostDuelModernGuiActive or not Q.Parent then return; end; if Q.Visible then ci(); end; end);
                                                    local ii = false;
                                                    C:GetPropertyChangedSignal("Visible"):Connect(function() if _G.__GhostDuelModernGuiActive or not Q.Parent then return; end; if not C.Visible then if Q.Visible then ii = true; Q.Visible = false; else ii = false; end; elseif ii then ci(); Q.Visible = true; end; end);
                                                end;
                                                Instance.new("UICorner", Q).CornerRadius = UDim.new(0, 12);
                                                Z = Instance.new("UIStroke", Q);
                                                Z.Color = Color3.fromRGB(0, 0, 0);
                                                Z.Thickness = 0;
                                                Z.Transparency = 1;
                                                local ii, Qi = Ai or 1, {};
                                                local function Hi()
                                                    for Ei, Fi in ipairs(Qi) do
                                                        local Pi, ki, xi, _i, Li, zi, Si, gi = Ei == ii, Fi.card, Fi.image, Fi.stroke, Fi.baseX, Fi.baseY, Fi.baseW, Fi.baseH;
                                                        _i.Color = Color3.fromRGB(255, 255, 255);
                                                        _i.Thickness = Pi and 2 or 1.5;
                                                        _i.Transparency = Pi and 0.25 or 0.7;
                                                        _i.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                        ki.Size = Pi and(UDim2.fromOffset(math.max(4, Si - 6), math.max(4, gi - 6))) or(UDim2.fromOffset(Si, gi));
                                                        ki.Position = Pi and(UDim2.new(0, Li + 3, 0, zi + 3)) or(UDim2.new(0, Li, 0, zi));
                                                        ki.BackgroundTransparency = 1;
                                                        xi.Size = UDim2.new(1, 0, 1, 0);
                                                        xi.Position = UDim2.new(0, 0, 0, 0);
                                                        xi.BackgroundTransparency = 1;
                                                    end;
                                                end;
                                                local function Ei()
                                                    if not Q or not Qi then
                                                        return;
                                                    end;
                                                    local Fi, Pi = Q.AbsoluteSize.X > 0 and Q.AbsoluteSize.X or Q.Size.X.Offset, Q.AbsoluteSize.Y > 0 and Q.AbsoluteSize.Y or Q.Size.Y.Offset;
                                                    local ki, xi = math.max(0, Fi - 24), math.max(0, Pi - 36 - 24);
                                                    Fi, Pi = math.floor((ki - 10) / 2), math.floor((xi - 10) / 2);
                                                    for _i, Li in ipairs(Qi) do
                                                        ki, xi = (_i - 1) % 2, math.floor((_i - 1) / 2);
                                                        local _i, zi = 12 + ki * (Fi + 10), 12 + xi * (Pi + 10);
                                                        Li.baseX = _i;
                                                        Li.baseY = zi;
                                                        Li.baseW = Fi;
                                                        Li.baseH = Pi;
                                                        Li.card.Size = UDim2.fromOffset(Fi, Pi);
                                                        Li.card.Position = UDim2.new(0, _i, 0, zi);
                                                        Li.image.Size = UDim2.new(1, 0, 1, 0);
                                                        Li.image.Position = UDim2.new(0, 0, 0, 0);
                                                    end;
                                                end;
                                                for Fi, Pi in ipairs(hi) do
                                                    Z = Instance.new("TextButton", Q);
                                                    Z.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                    Z.BackgroundTransparency = 1;
                                                    Z.BorderSizePixel = 0;
                                                    Z.Text = "";
                                                    Z.AutoButtonColor = false;
                                                    Z.ZIndex = 21;
                                                    Instance.new("UICorner", Z).CornerRadius = UDim.new(0, 7);
                                                    local ki = Instance.new("ImageLabel", Z);
                                                    ki.BackgroundTransparency = 1;
                                                    ki.Image = Pi;
                                                    ki.ScaleType = Enum.ScaleType.Crop;
                                                    ki.ZIndex = 21;
                                                    Instance.new("UICorner", ki).CornerRadius = UDim.new(0, 7);
                                                    Pi = Instance.new("TextLabel", Z);
                                                    Pi.Size = UDim2.new(1,- 12, 0, 12);
                                                    Pi.Position = UDim2.new(0, 6, 1,- 14);
                                                    Pi.BackgroundTransparency = 1;
                                                    Pi.Text = "GUI " .. tostring(Fi);
                                                    Pi.TextColor3 = Color3.fromRGB(235, 240, 245);
                                                    Pi.TextSize = 8;
                                                    Pi.Font = Enum.Font.GothamBold;
                                                    Pi.ZIndex = 23;
                                                    Pi.TextStrokeColor3 = Color3.fromRGB(5, 12, 25);
                                                    Pi.TextStrokeTransparency = 0.25;
                                                    Pi = Instance.new("UIStroke", Z);
                                                    Pi.Color = Color3.fromRGB(255, 255, 255);
                                                    Pi.Thickness = 0;
                                                    Pi.Transparency = 1;
                                                    Pi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                    table.insert(Qi, {card = Z, image = ki, stroke = Pi, baseX = 0, baseY = 0, baseW = 0, baseH = 0});
                                                    Z.Activated:Connect(function() ii = Fi; Hi(); end);
                                                end;
                                                Z = Instance.new("TextButton", Q);
                                                Z.Size = UDim2.new(1,- 24, 0, 28);
                                                Z.Position = UDim2.new(0, 12, 1,- 44);
                                                pcall(function() Ei(); end);
                                                Q:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() pcall(Ei); end);
                                                Z.BackgroundColor3 = Color3.fromRGB(120, 180, 240);
                                                Z.BorderSizePixel = 0;
                                                Z.Text = "Save Theme";
                                                Z.TextColor3 = Color3.fromRGB(235, 240, 245);
                                                Z.TextSize = 11;
                                                Z.Font = Enum.Font.GothamBold;
                                                Z.ZIndex = 21;
                                                Instance.new("UICorner", Z).CornerRadius = UDim.new(0, 7);
                                                Z.Activated:Connect(function() Ai = ii; if si then si.Image = hi[Ai]; end; Q.Visible = false; if bi then pcall(function() bi.Text = tostring(Ai) .. "/" .. tostring(#hi); end); end; _G._GhostDuel_UI_BgIndex = Ai; mi(); end);
                                                Y.Activated:Connect(function() ii = Ai; ci(); Q.Visible = not Q.Visible; Hi(); end);
                                                if bi then
                                                    pcall(function() bi.Visible = false; end);
                                                end;
                                            end;
                                            do
                                                local Q = _G.__GhostDuelQuickButtonsFrame;
                                                if Q then
                                                    pcall(function() Q:Destroy(); end);
                                                end;
                                                local Q = Instance.new("Frame");
                                                Q.Name = "GhostDuelQuickButtons";
                                                Q.Size = UDim2.new(1, 0, 1, 0);
                                                Q.Position = UDim2.new(0, 0, 0, 0);
                                                Q.BackgroundTransparency = 1;
                                                Q.BorderSizePixel = 0;
                                                Q.Active = false;
                                                Q.ZIndex = 750;
                                                Q.Visible = E["Show Buttons"] == true;
                                                Q.Parent = V;
                                                _G.__GhostDuelQuickButtonsFrame = Q;
                                                local function Z(ci, ii)
                                                    local Qi = Instance.new("TextButton");
                                                    Qi.Name = ci:gsub("%s+", "") .. "Button";
                                                    local Hi = Instance.new("UIScale", Qi);
                                                    Hi.Name = "QuickButtonSizeScale";
                                                    Hi.Scale = _G.__GhostDuelButtonsSize or 1;
                                                    Hi = A and 48 or 50;
                                                    Qi.Size = UDim2.new(0, Hi, 0, Hi);
                                                    local Ei, si = A and 72 or 81, A and 12 or 16;
                                                    if ii <= 3 then
                                                        Qi.Position = UDim2.new(0, si, 0, Ei + (ii - 1) * (Hi + 8));
                                                    else
                                                        local bi = ii - 4;
                                                        Qi.Position = UDim2.new(0, si + Hi + 8, 0, Ei + bi * (Hi + 8));
                                                    end;
                                                    Qi.LayoutOrder = ii;
                                                    Qi:SetAttribute("OriginalPosition", Qi.Position);
                                                    Qi.BackgroundColor3 = Color3.fromRGB(28, 32, 40);
                                                    Qi.BackgroundTransparency = 0.18;
                                                    Qi.BorderSizePixel = 0;
                                                    Qi.AutoButtonColor = false;
                                                    Qi.Active = true;
                                                    Qi.Draggable = false;
                                                    Qi.Font = Enum.Font.GothamBold;
                                                    Qi.Text = ci;
                                                    Qi.TextScaled = true;
                                                    Qi.TextWrapped = true;
                                                    Qi.TextColor3 = Color3.fromRGB(220, 230, 245);
                                                    Qi.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
                                                    Qi.TextStrokeTransparency = 0;
                                                    Qi.ZIndex = 751;
                                                    Qi.Parent = Q;
                                                    Instance.new("UICorner", Qi).CornerRadius = UDim.new(0, A and 10 or 12);
                                                    ci = Instance.new("UITextSizeConstraint");
                                                    ci.MinTextSize = A and 7 or 8;
                                                    ci.MaxTextSize = A and 9 or 10;
                                                    ci.Parent = Qi;
                                                    Hi = Instance.new("UIAspectRatioConstraint");
                                                    Hi.AspectRatio = 1;
                                                    Hi.Parent = Qi;
                                                    ii = Instance.new("UIStroke");
                                                    ii.Color = Color3.fromRGB(0, 0, 0);
                                                    ii.Thickness = 1;
                                                    ii.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                    ii.Transparency = 0.15;
                                                    ii.Parent = Qi;
                                                    return Qi, ii;
                                                end;
                                                local ci, ii = Z("AIMBOT", 1);
                                                local Qi, Hi = Z("BAT TP", 2);
                                                local Ei, si = Z("TP DOWN", 3);
                                                local bi, Fi = Z("DROP", 4);
                                                local Pi, ki = Z("CARRY SPEED", 5);
                                                local xi, _i = Z("LAGGER SPEED", 6);
                                                local Li, zi = Z("AUTO PLAY", 7);
                                                local Si = {custom = {}};
                                                i = Si.custom;
                                                i.button, Si.custom.stroke = Z("CUSTOM SPEED", 8);
                                                Si.custom.button.Visible = true;
                                                Si.custom.getByName = function(Z)
                                                    for gi, gi in ipairs(I) do
                                                        if gi.name == Z then
                                                            return gi;
                                                        end;
                                                    end;
                                                    return nil;
                                                end;
                                                Si.custom.getSelected = function()
                                                    local Z = Si.custom.getByName(_);
                                                    if Z then
                                                        Si.custom.lastName = Z.name;
                                                        return Z;
                                                    end;
                                                    return Si.custom.getByName(Si.custom.lastName) or I[1];
                                                end;
                                                local function Z(gi, Oi, ni)
                                                    gi.BackgroundColor3 = ni and(Color3.fromRGB(215, 220, 225)) or(Color3.fromRGB(28, 32, 40));
                                                    gi.TextColor3 = ni and(Color3.fromRGB(255, 255, 255)) or(Color3.fromRGB(220, 230, 245));
                                                    gi.TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
                                                    gi.TextStrokeTransparency = 0;
                                                    Oi.Color = Color3.fromRGB(0, 0, 0);
                                                    Oi.Thickness = ni and 1.5 or 1;
                                                    Oi.Transparency = 0.15;
                                                end;
                                                local function gi(Oi)
                                                    local ni = not(E[Oi] == true);
                                                    if ni and({})[Oi] and m:GetAttribute("Stealing") == true and not(_G._GhostDuel_BypassAuto == true) then
                                                        return;
                                                    end;
                                                    E[Oi] = ni;
                                                    if e[Oi] then
                                                        pcall(e[Oi], ni);
                                                    end;
                                                    if W[Oi] then
                                                        pcall(W[Oi], ni);
                                                    end;
                                                    mi();
                                                end;
                                                local e = {ci, Qi, Ei, bi, Pi, xi, Li, Si.custom.button};
                                                task.defer(function() for Oi, ni in ipairs(e) do Oi = r[ni.Name]; if Oi and Oi.x and Oi.y then local Ji, fi = v(ni, 0, Oi.x, 0, Oi.y, _G.__GhostDuelButtonsSize or 1); ni.Position = UDim2.new(0, Ji, 0, fi); r[ni.Name] = {x = Ji, y = fi}; else local Oi = ni.Position; v(ni, Oi.X.Scale, Oi.X.Offset, Oi.Y.Scale, Oi.Y.Offset, _G.__GhostDuelButtonsSize or 1); end; end; end);
                                                local Oi, ni, Ji, fi;
                                                local oi = false;
                                                function _G.__GhostDuelSetButtonsSize (qi)
                                                    local Bi = tonumber((tostring(qi):gsub(",", ".")));
                                                    if not Bi or Bi ~= Bi or math.abs(Bi) == math.huge then
                                                        return _G.__GhostDuelButtonsSize;
                                                    end;
                                                    Bi = math.floor(math.clamp(Bi, 0.5, 2) * 100 + 0.5) / 100;
                                                    _G.__GhostDuelButtonsSize = Bi;
                                                    Oi, ni, Ji, fi, oi = nil, nil, nil, nil, false;
                                                    for ji, ji in ipairs(e) do
                                                        ji.QuickButtonSizeScale.Scale = Bi;
                                                        qi = ji.Position;
                                                        local wi, yi = v(ji, qi.X.Scale, qi.X.Offset, qi.Y.Scale, qi.Y.Offset, Bi);
                                                        if r[ji.Name] then
                                                            r[ji.Name] = {x = wi, y = yi};
                                                        end;
                                                    end;
                                                    mi();
                                                    return Bi;
                                                end;
                                                Si.resetPositions = function()
                                                    if Oi then
                                                        local qi = Oi;
                                                        Si[qi] = true;
                                                        task.delay(0.2, function() Si[qi] = nil; end);
                                                    end;
                                                    Oi, ni, Ji, fi, oi = nil, nil, nil, nil, false;
                                                    table.clear(r);
                                                    for qi, Bi in ipairs(e) do
                                                        qi = Bi:GetAttribute("OriginalPosition");
                                                        v(Bi, qi.X.Scale, qi.X.Offset, qi.Y.Scale, qi.Y.Offset, _G.__GhostDuelButtonsSize or 1);
                                                    end;
                                                    _G.__GhostDuelGuiPositionsReset = true;
                                                    for qi, qi in pairs(_G.__GhostDuelGuiPositionResetters) do
                                                        qi();
                                                    end;
                                                    mi();
                                                end;
                                                _G.__GhostDuelResetButtonPositions = Si.resetPositions;
                                                local function qi()
                                                    return E["Lock Buttons"] == true;
                                                end;
                                                local function Bi(ji)
                                                    if not Oi or not ni or not Ji then
                                                        return;
                                                    end;
                                                    local wi = ji.Position - ni;
                                                    ji = wi.Magnitude;
                                                    if ji > 6 then
                                                        oi = true;
                                                    end;
                                                    local ji, yi = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or(Vector2.new(0, 0)), Oi.AbsoluteSize;
                                                    local Ui, ei = math.clamp(Ji.X.Offset + wi.X, 0, math.max(0, ji.X - yi.X)), math.clamp(Ji.Y.Offset + wi.Y, 0, math.max(0, ji.Y - yi.Y));
                                                    Oi.Position = UDim2.new(0, Ui, 0, ei);
                                                end;
                                                for ji, ji in ipairs(e) do
                                                    ji.InputBegan:Connect(function(e) if qi() then return; end; if e.UserInputType == Enum.UserInputType.MouseButton1 or e.UserInputType == Enum.UserInputType.Touch then Oi = ji; ni = e.Position; Ji, fi, oi = ji.Position, e, false; end; end);
                                                end;
                                                _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(e) if not Oi or(qi()) then return; end; if e.UserInputType == Enum.UserInputType.MouseMovement or e == fi then Bi(e); end; end));
                                                _G.__GhostDuelTrackConn (R.InputEnded:Connect(function(e) local qi = fi and fi.UserInputType == Enum.UserInputType.MouseButton1 and e.UserInputType == Enum.UserInputType.MouseButton1; if Oi and(e == fi or qi) then local e = Oi; local qi = e; Oi, ni, Ji, fi = nil, nil, nil, nil; if oi then r[qi.Name] = {x = qi.Position.X.Offset, y = qi.Position.Y.Offset}; mi(); Si[qi] = true; task.delay(0.2, function() Si[e] = nil; end); end; end; end));
                                                local function e(r, Oi)
                                                    r.Activated:Connect(function() if Si[r] then Si[r] = nil; return; end; Oi(); end);
                                                end;
                                                e(ci, function() gi("Aimbot"); end);
                                                e(Qi, function() if _G.GhostDuelAutoBat and _G.GhostDuelAutoBat.Toggle then pcall(_G.GhostDuelAutoBat.Toggle); else gi("TP Bat"); end; end);
                                                e(Ei, function() if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]); end; end);
                                                e(bi, function() if FeatureToggles.Drop then pcall(FeatureToggles.Drop, "button"); end; end);
                                                e(Pi, function() if n == "v2" then O = not O; E["Carry Speed"] = O; E["Speed Boost"] = true; if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost); end; if U["Carry Speed"] then U["Carry Speed"](); end; pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end); mi(); elseif FeatureToggles["Carry Speed"] then pcall(FeatureToggles["Carry Speed"]); else gi("Carry Speed"); end; end);
                                                e(xi, function() if _ == "Lagger" then if FeatureToggles.SelectNormalMode then pcall(FeatureToggles.SelectNormalMode); end; elseif FeatureToggles.SelectLaggerMode then pcall(FeatureToggles.SelectLaggerMode); end; end);
                                                e(Li, function() if FeatureToggles.Autoplay then pcall(FeatureToggles.Autoplay); end; end);
                                                e(Si.custom.button, function() local e = Si.custom.getSelected(); if e and _ ~= e.name then Ii(e.name); end; end);
                                                local e, r = 0, {};
                                                _G.__GhostDuelTrackConn (c.Heartbeat:Connect(function(gi) e += gi or 0; if e < 0.4 then return; end; e = 0; gi = E["Show Buttons"] == true; if r.show ~= gi then Q.Visible = gi; r.show = gi; end; if not gi then return; end; local Q, e, Oi, ni, Ji = E.Aimbot == true, E["TP Bat"] == true, E["Carry Speed"] == true, E.Autoplay == true, Si.custom.getByName(_); gi = Ji or(Si.custom.getSelected()); if r.carryVisible ~= true then Pi.Visible = true; r.carryVisible = true; end; if r.aimbot ~= Q then Z(ci, ii, Q); r.aimbot = Q; end; if r.autoBat ~= e then Z(Qi, Hi, e); r.autoBat = e; end; if r.carry ~= Oi then Z(Pi, ki, Oi); r.carry = Oi; end; if r.autoplay ~= ni then Z(Li, zi, ni); r.autoplay = ni; end; e = gi and gi.name or nil; if r.customName ~= e or r.customActive ~= (Ji ~= nil) then Si.custom.button.Text = e and "CUSTOM\10" .. string.upper(e) or "NO CUSTOM"; Z(Si.custom.button, Si.custom.stroke, Ji ~= nil); r.customName = e; r.customActive = Ji ~= nil; end; Oi = _ == "Lagger"; if r.lagger ~= Oi then xi.Text = Oi and "NORMAL SPEED" or "LAGGER SPEED"; Z(xi, _i, Oi); r.lagger = Oi; end; if r.actionsInitialized ~= true then Z(Ei, si, false); Z(bi, Fi, false); r.actionsInitialized = true; end; end));
                                            end;
                                            do
                                                i = Vi(o.Visuals, "PANELS");
                                                Y = Instance.new("Frame", i);
                                                Y.Size = UDim2.new(1,- 10, 0, 104);
                                                Y.Position = UDim2.new(0, 5, 0, 28);
                                                Y.BackgroundColor3 = Color3.fromRGB(20, 22, 31);
                                                Y.BackgroundTransparency = 0.12;
                                                Y.BorderSizePixel = 0;
                                                Instance.new("UICorner", Y).CornerRadius = UDim.new(0, 8);
                                                p = Instance.new("UIStroke", Y);
                                                p.Color = Color3.fromRGB(0, 0, 0);
                                                p.Thickness = 1.2;
                                                p.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                p.Transparency = 0.15;
                                                a = Instance.new("Frame", Y);
                                                a.Size = UDim2.new(1,- 18, 0, 30);
                                                a.Position = UDim2.new(0, 9, 0, 10);
                                                a.BackgroundTransparency = 1;
                                                local Q = Instance.new("TextButton", a);
                                                Q.Size = UDim2.new(0.5,- 4, 1, 0);
                                                Q.Position = UDim2.new(0, 0, 0, 0);
                                                Q.BackgroundColor3 = Color3.fromRGB(12, 34, 70);
                                                Q.BackgroundTransparency = 0.15;
                                                Q.BorderSizePixel = 0;
                                                Q.Text = "BYPASS";
                                                Q.TextColor3 = Color3.fromRGB(145, 215, 255);
                                                Q.TextSize = 11;
                                                Q.Font = Enum.Font.GothamBold;
                                                Q.AutoButtonColor = false;
                                                Instance.new("UICorner", Q).CornerRadius = UDim.new(0, 6);
                                                local e = Instance.new("UIStroke", Q);
                                                e.Color = Color3.fromRGB(0, 0, 0);
                                                e.Thickness = 1;
                                                e.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                local Z = Instance.new("TextButton", a);
                                                Z.Size = UDim2.new(0.5,- 4, 1, 0);
                                                Z.Position = UDim2.new(0.5, 4, 0, 0);
                                                Z.BackgroundColor3 = Color3.fromRGB(12, 34, 70);
                                                Z.BackgroundTransparency = 0.15;
                                                Z.BorderSizePixel = 0;
                                                Z.Text = "LAGGER";
                                                Z.TextColor3 = Color3.fromRGB(145, 215, 255);
                                                Z.TextSize = 11;
                                                Z.Font = Enum.Font.GothamBold;
                                                Z.AutoButtonColor = false;
                                                Instance.new("UICorner", Z).CornerRadius = UDim.new(0, 6);
                                                local r = Instance.new("UIStroke", Z);
                                                r.Color = Color3.fromRGB(0, 0, 0);
                                                r.Thickness = 1;
                                                r.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                local ci = false;
                                                local function ii()
                                                    Z.BackgroundColor3 = ci and(Color3.fromRGB(45, 140, 220)) or(Color3.fromRGB(12, 34, 70));
                                                    Z.TextColor3 = ci and(Color3.fromRGB(240, 250, 255)) or(Color3.fromRGB(145, 215, 255));
                                                    r.Color = ci and(Color3.fromRGB(160, 225, 255)) or(Color3.fromRGB(38, 94, 145));
                                                    r.Thickness = ci and 1.5 or 1;
                                                end;
                                                (function() local r, Qi, Hi = {Cartoon = {RunAnim = 742638842, WalkAnim = 742640026, JumpAnim = 742637942, FallAnim = 742637151, Swim = 742639220, SwimIdle = 742639812, ClimbAnim = 742636889, Idle = {742637544, 742638445, 885477856}}, ["Adidas Community"] = {WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Animation1 = 122257458498464, Animation2 = 102357151005774, ClimbAnim = 88763136693023}, ["Adidas Aura"] = {WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Animation1 = 110211186840347, Animation2 = 114191137265065, ClimbAnim = 97824616490448}, Zombie = {WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Animation1 = 10921344533, Animation2 = 10921345304, ClimbAnim = 10921343576}, ["Catwalk Glam"] = {WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, ClimbAnim = 119377220967554, Animation1 = 133806214992291, Animation2 = 94970088341563}, Toy = {WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, ClimbAnim = 10921300839, Animation1 = 10921301576}, ["Amazon Unboxed"] = {WalkAnim = 90478085024465, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, ClimbAnim = 121145883950231, Animation1 = 98281136301627}, Vampire = {WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, ClimbAnim = 10921314188, Animation1 = 10921315373}, Ninja = {RunAnim = 656118852, WalkAnim = 656121766, JumpAnim = 656117878, FallAnim = 656115606, Swim = 656119721, SwimIdle = 656121397, ClimbAnim = 656114359, Idle = {656117400, 656118341, 886742569}}}, {"Cartoon", "Adidas Community", "Adidas Aura", "Zombie", "Catwalk Glam", "Toy", "Amazon Unboxed", "Vampire", "Ninja"}, 1; local Ei = Qi[1]; local function si(bi) if not bi then return nil; end; if type(bi) == "number" then return "rbxassetid://" .. tostring(bi); end; if type(bi) == "string" then if string.sub(bi, 1, 11) == "rbxassetid://" then return bi; end; if string.match(bi, "^%d+$") then return "rbxassetid://" .. bi; end; return bi; end; return nil; end; local function bi(Fi) local Pi = Fi and Fi.Idle; return {idle1 = si(Fi and(Fi.Animation1 or Pi and Pi[1])), idle2 = si(Fi and(Fi.Animation2 or Pi and Pi[2])), walk = si(Fi and(Fi.WalkAnim or Fi.Walk)), run = si(Fi and(Fi.RunAnim or Fi.Run)), jump = si(Fi and(Fi.JumpAnim or Fi.Jump)), fall = si(Fi and(Fi.FallAnim or Fi.Fall)), climb = si(Fi and(Fi.ClimbAnim or Fi.Climb)), swim = si(Fi and(Fi.Swim or Fi.SwimAnim)), swimidle = si(Fi and(Fi.SwimIdle or Fi.SwimIdleAnim))}; end; local function si(Fi, Pi) if not Fi or not Pi then return false; end; local ki = Fi:FindFirstChild("Animate"); if not ki then ki = Instance.new("Animation"); ki.Name = "Animate"; ki.Parent = Fi; end; _G.__ZurichHub_OriginalAnims = _G.__ZurichHub_OriginalAnims or {}; local xi = tostring(m.UserId or "local"); if not _G.__ZurichHub_OriginalAnims [xi] then local _i, Li = {}, {"idle", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}; for zi, Si in ipairs(Li) do zi = ki:FindFirstChild(Si); if zi then for Li, Li in ipairs(zi:GetChildren()) do pcall(function() _i [Si .. "." .. Li.Name] = Li.AnimationId; end); end; end; end; _G.__ZurichHub_OriginalAnims [xi] = _i; end; local function xi(_i, Li) local zi = _i:FindFirstChild(Li); if not zi then zi = Instance.new("Animation"); zi.Name = Li; zi.Parent = _i; end; return zi; end; local function _i (Li, zi, Si) if not Si then return; end; local gi = Li:FindFirstChild(zi); if not gi then gi = Instance.new("Animation"); gi.Name = zi; gi.Parent = Li; end; gi.AnimationId = Si; end; local Li, zi, Si, gi, Oi, ni, Ji, fi = xi(ki, "idle"), xi(ki, "walk"), xi(ki, "run"), xi(ki, "jump"), xi(ki, "fall"), xi(ki, "climb"), xi(ki, "swim"), xi(ki, "swimidle"); _i (Li, "Animation1", Pi.idle1); _i (Li, "Animation2", Pi.idle2); _i (zi, "WalkAnim", Pi.walk); _i (Si, "RunAnim", Pi.run); _i (gi, "JumpAnim", Pi.jump); _i (Oi, "FallAnim", Pi.fall); _i (ni, "ClimbAnim", Pi.climb); _i (Ji, "Swim", Pi.swim); _i (fi, "SwimIdle", Pi.swimidle); _G.__ZurichHub_Anims = _G.__ZurichHub_Anims or {}; for ki, xi in pairs(Pi) do if xi then _G.__ZurichHub_Anims [ki] = xi; end; end; Pi = Fi:FindFirstChildOfClass("Humanoid"); if Pi then for Fi, Fi in ipairs(Pi:GetPlayingAnimationTracks()) do pcall(function() Fi:Stop(0); end); end; end; return true; end; local function Fi(Pi) if not Pi then return false; end; local ki = tostring(m.UserId or "local"); local xi = _G.__ZurichHub_OriginalAnims and _G.__ZurichHub_OriginalAnims [ki]; if not xi then return false; end; ki = Pi:FindFirstChild("Animate"); if not ki then return false; end; for _i, Li in pairs(xi) do Pi = string.find(_i, "%."); if Pi then local xi, zi = string.sub(_i, 1, Pi - 1), string.sub(_i, Pi + 1); local Pi = ki:FindFirstChild(xi); if not Pi then Pi = Instance.new("Animation"); Pi.Name = xi; Pi.Parent = ki; end; local ki = Pi:FindFirstChild(zi); if not ki then ki = Instance.new("Animation"); ki.Name = zi; ki.Parent = Pi; end; pcall(function() ki.AnimationId = Li; end); end; end; return true; end; local function Pi(ki) local xi = r[ki]; if not xi then return false; end; local _i, Li = bi(xi), m.Character; if Li then return si(Li, _i); else Ei = ki; _G.__pendingAnimationPreset = ki; return true; end; end; local ki = false; local function xi() local _i = Ei or Qi[Hi] or "Cartoon"; local Li = {presetIndex = Hi, presetName = _i, enabled = ki}; local _i, zi = pcall(function() return h:JSONEncode(Li); end); if _i then pcall(function() writefile("AnimationSelector_Config.txt", zi); end); end; end; local function _i () local Li, zi = pcall(function() return isfile("AnimationSelector_Config.txt"); end); if not Li or not zi then return false; end; local Si, gi = pcall(function() return readfile("AnimationSelector_Config.txt"); end); if not Si or not gi or gi == "" then return false; end; Li, zi = pcall(function() return h:JSONDecode(gi); end); if not Li or not zi then return false; end; if zi.presetName and r[zi.presetName] then Ei = zi.presetName; for Li, gi in ipairs(Qi) do if gi == zi.presetName then Hi = Li; break; end; end; elseif zi.presetIndex and zi.presetIndex >= 1 and zi.presetIndex <= #Qi then Hi = zi.presetIndex; Ei = Qi[Hi]; end; Si = Ei; if Si == nil then Ei = Qi[Hi or 1]; end; ki = false; return true; end; pcall(_i); if ki and Ei and r[Ei] then pcall(function() Pi(Ei); end); end; if ki and Ei and m.Character then pcall(function() Pi(Ei); end); end; local Li = Vi(o.Visuals, "ANIMATION PACK"); local zi = Li and Li.Parent; if zi then for Si, gi in ipairs(zi:GetChildren()) do if gi:IsA("Frame") then Si = gi:FindFirstChildOfClass("TextLabel"); if Si and Si.Text == "ANIMATION PACK" then for Si, Si in ipairs(gi:GetChildren()) do if Si:IsA("Frame") and Si.Size and Si.Size.Y and Si.Size.Y.Offset == 1 then Si:Destroy(); break; end; end; break; end; end; end; end; zi = Instance.new("Frame", Li); zi.Size = UDim2.new(1,- 10, 0, 68); zi.Position = UDim2.new(0, 5, 0, 30); zi.BackgroundColor3 = Color3.fromRGB(20, 22, 31); zi.BackgroundTransparency = 0.12; zi.BorderSizePixel = 0; zi.Parent = Li; Instance.new("UICorner", zi).CornerRadius = UDim.new(0, 8); Li = Instance.new("UIStroke", zi); Li.Color = Color3.fromRGB(0, 0, 0); Li.Thickness = 1.2; Li.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Li.Transparency = 0.15; Li = Instance.new("Frame", zi); Li.Size = UDim2.new(0, 72, 1,- 10); Li.Position = UDim2.new(0, 6, 0, 5); Li.BackgroundColor3 = Color3.fromRGB(32, 35, 42); Li.BackgroundTransparency = 0.08; Li.BorderSizePixel = 0; Instance.new("UICorner", Li).CornerRadius = UDim.new(0, 7); pcall(_i); if ki and Ei and r[Ei] then pcall(function() Pi(Ei); end); end; local _i = Instance.new("TextButton", Li); _i.Size = UDim2.new(1,- 8, 1,- 8); _i.Position = UDim2.new(0, 4, 0, 4); _i.BackgroundColor3 = Color3.fromRGB(50, 55, 64); _i.BorderSizePixel = 0; _i.Text = "OFF"; _i.TextColor3 = Color3.fromRGB(245, 247, 250); _i.TextSize = 10; _i.Font = Enum.Font.GothamBold; _i.AutoButtonColor = false; _i.TextWrapped = false; _i.ZIndex = 6; Instance.new("UICorner", _i).CornerRadius = UDim.new(0, 5); pcall(function(Si) local gi = Instance.new("UIStroke", Si); gi.Color = Color3.fromRGB(255, 255, 255); gi.Thickness = 0.8; gi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; end, _i); local function Si() _i.Text = ki and "ON" or "OFF"; _i.BackgroundColor3 = ki and(Color3.fromRGB(82, 140, 220)) or(Color3.fromRGB(52, 58, 68)); _i.TextColor3 = Color3.fromRGB(255, 255, 255); _i.Font = Enum.Font.GothamBold; end; _i.Activated:Connect(function() ki = not ki; Si(); if ki then Pi(Ei); elseif m.Character then Fi(m.Character); end; xi(); end); local _i = Instance.new("TextButton"); _i.Size = UDim2.new(0, 32, 0, 32); _i.Position = UDim2.new(0, 88, 0.5,- 16); _i.BackgroundColor3 = Color3.fromRGB(30, 30, 38); _i.BackgroundTransparency = 0.15; _i.BorderSizePixel = 0; _i.Text = "<"; _i.TextColor3 = Color3.fromRGB(240, 245, 255); _i.TextSize = 20; _i.Font = Enum.Font.GothamBold; _i.AutoButtonColor = false; _i.ZIndex = 5; _i.Parent = zi; pcall(function(gi) Instance.new("UICorner", gi).CornerRadius = UDim.new(0, 5); local Oi = Instance.new("UIStroke", gi); Oi.Color = Color3.fromRGB(255, 255, 255); Oi.Thickness = 0.8; Oi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; end, _i); Li = Instance.new("Frame"); Li.Name = "AnimationPackSelector"; Li.Size = UDim2.new(1,- 122, 0, 30); Li.Position = UDim2.new(0, 108, 0, 19); Li.BackgroundTransparency = 1; Li.Parent = zi; local zi = Instance.new("TextLabel"); zi.Size = UDim2.new(1,- 36, 1, 0); zi.BackgroundTransparency = 1; zi.Text = tostring(Ei or ""); zi.TextColor3 = Color3.fromRGB(240, 245, 255); zi.TextSize = 12; zi.Font = Enum.Font.GothamBold; zi.TextXAlignment = Enum.TextXAlignment.Center; zi.TextYAlignment = Enum.TextYAlignment.Center; zi.ZIndex = 5; zi.Parent = Li; zi.AnchorPoint = Vector2.new(0.5, 0.5); zi.Position = UDim2.new(0.5, 0, 0.5, 4); pcall(function(gi) local Oi = Instance.new("UIStroke", gi); Oi.Color = Color3.fromRGB(255, 255, 255); Oi.Thickness = 0.8; Oi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Oi.Transparency = 1; end, zi); local gi = Instance.new("TextButton"); gi.Size = UDim2.new(0, 32, 0, 32); gi.Position = UDim2.new(1,- 32, 0.5,- 16); gi.BackgroundColor3 = Color3.fromRGB(30, 30, 38); gi.BackgroundTransparency = 0.15; gi.BorderSizePixel = 0; gi.Text = ">"; gi.TextColor3 = Color3.fromRGB(240, 245, 255); gi.TextSize = 20; gi.Font = Enum.Font.GothamBold; gi.AutoButtonColor = false; gi.ZIndex = 5; gi.Parent = Li; pcall(function(Oi) Instance.new("UICorner", Oi).CornerRadius = UDim.new(0, 5); local ni = Instance.new("UIStroke", Oi); ni.Color = Color3.fromRGB(255, 255, 255); ni.Thickness = 0.8; ni.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; end, gi); local function Oi(ni, Ji) Ji = Ji or "next"; zi.Text = tostring(ni or ""); zi.TextTransparency = 1; zi.Position = UDim2.new(0.5, Ji == "next" and- 90 or 90, 0.5, 0); X:Create(zi, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.5, 0), TextTransparency = 0}):Play(); end; local function ni(Ji) local fi = Hi + (Ji == "next" and 1 or- 1); Hi = if(if fi < 1 then #Qi else fi) > #Qi then 1 else if fi < 1 then #Qi else fi; Ei = Qi[Hi]; Oi(Ei, Ji); if ki then Pi(Ei); elseif m.Character then Fi(m.Character); end; xi(); local Qi = Ji == "next" and gi or _i; X:Create(Qi, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0, 80, 180)}):Play(); task.delay(0.08, function() X:Create(Qi, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play(); end); end; _i.MouseButton1Click:Connect(function() ni("prev"); end); gi.MouseButton1Click:Connect(function() ni("next"); end); _i.Parent = Li; gi.Parent = Li; zi.Parent = Li; Si(); if ki and Ei then pcall(function() Pi(Ei); end); end; _i.Position = UDim2.new(0,- 8, 0.5,- 12); gi.Position = UDim2.new(1,- 24, 0.5,- 12); _i.MouseEnter:Connect(function() X:Create(_i, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play(); end); _i.MouseLeave:Connect(function() X:Create(_i, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240, 245, 255)}):Play(); end); gi.MouseEnter:Connect(function() X:Create(gi, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play(); end); gi.MouseLeave:Connect(function() X:Create(gi, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240, 245, 255)}):Play(); end); _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function(Qi) task.wait(0.5); if ki then si(Qi, (bi(r[Ei]))); end; end)); task.spawn(function() task.wait(0.5); if m.Character and ki then local Qi = bi(r[Ei]); si(m.Character, Qi); end; end); end)();
                                                function _G.__GhostDuelReadSavedPanelVisibility (r)
                                                    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
                                                        return false, false;
                                                    end;
                                                    local Qi, Hi = pcall(function() if not isfile(r) then return nil; end; return h:JSONDecode(readfile(r)); end);
                                                    if not Qi or type(Hi) ~= "table" then
                                                        return false, false;
                                                    end;
                                                    return true, Hi.visible == true;
                                                end;
                                                local function r(Qi)
                                                    if Qi == nil then
                                                        Qi = true;
                                                    end;
                                                    if Qi and _G.GhostDuelBypass and _G.GhostDuelBypass.SetVisible then
                                                        pcall(_G.GhostDuelBypass.SetVisible, false);
                                                    end;
                                                    local Hi = game:GetService("Players").LocalPlayer;
                                                    local Ei = Hi and(Hi:FindFirstChild("PlayerGui"));
                                                    if Ei and(Ei:FindFirstChild("GhostDuelLaggerGUI")) then
                                                        Hi = Ei:FindFirstChild("GhostDuelLaggerGUI");
                                                        if Hi and Qi then
                                                            Hi.Visible = true;
                                                        end;
                                                        if _G.GhostDuelLagger and _G.GhostDuelLagger.SetVisible then
                                                            _G.GhostDuelLagger.SetVisible(Qi);
                                                        end;
                                                        return;
                                                    end;
                                                    if _G._GhostDuelLaggerGUILoaded then
                                                        _G._GhostDuelLaggerGUILoaded = false;
                                                    end;
                                                    _G._GhostDuelLaggerGUILoaded = true;
                                                    _G.__openLaggerGUI = r;
                                                    task.spawn(function() pcall(function() local Hi = K.LocalPlayer:WaitForChild("PlayerGui"); local Ei = Hi:FindFirstChild("GhostDuelLaggerGUI"); if Ei then Ei:Destroy(); end; local si, bi, Fi, Pi, ki = {TableIncrease = 270, Tries = 1, LoopWaitTime = 0.3, LowEndTableIncrease = 265, LowEndLoopWaitTime = 0.8}, {Main = false, LowEnd = false}, {Main = nil, LowEnd = nil}; local function xi(_i) local Li, zi = {}, {{}}; local Si = zi[1]; for gi = 1, _i, 1 do gi = {}; table.insert(Si, gi); Si = gi; end; for Si = 1, math.min(499999 / (_i + 2), 1500), 1 do table.insert(Li, zi); end; return Li; end; local function _i (Li) if Pi ~= Li or not ki then Pi = Li; ki = xi(Li); end; pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(ki); end); end; local function Pi() if Fi.Main then return; end; Fi.Main = task.spawn(function() while bi.Main do local ki, xi, Li = A and 25000 or math.huge, A and(math.min(si.TableIncrease, si.LowEndTableIncrease)) or si.TableIncrease, A and si.LowEndLoopWaitTime or si.LoopWaitTime; pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(ki); end); _i (xi); task.wait(Li); end; end); end; local function ki() if Fi.LowEnd then return; end; Fi.LowEnd = task.spawn(function() while bi.LowEnd do pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(25000); end); _i (si.LowEndTableIncrease); task.wait(si.LowEndLoopWaitTime); end; end); end; local function xi(_i) if Fi[_i] then task.cancel(Fi[_i]); Fi[_i] = nil; end; end; local function _i () bi.Main = false; bi.LowEnd = false; xi("Main"); xi("LowEnd"); Fi.Payload = nil; Fi.PayloadAmount = nil; Fi.Remote = nil; pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge); end); end; _G.__GhostDuelTrackStopper (_i); local function Fi() bi.Main = not bi.Main; if bi.Main then if bi.LowEnd then bi.LowEnd = false; xi("LowEnd"); if _G.__updateSmallLaggerVisual then _G.__updateSmallLaggerVisual (); end; end; Pi(); else xi("Main"); if not bi.LowEnd then pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge); end); end; end; return bi.Main; end; local function Li() bi.LowEnd = not bi.LowEnd; if bi.LowEnd then if bi.Main then bi.Main = false; xi("Main"); end; ki(); else xi("LowEnd"); if not bi.Main then pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge); end); end; end; return bi.LowEnd; end; local function zi(Si) if type(Si) ~= "string" or #Si < 16 then return false; end; local gi, Oi, ni = Si:sub(1, 8) == "\137PNG\13\10\26\10", Si:sub(1, 2) == "\255\216" or Si:find("JFIF", 1, true) ~= nil or Si:find("Exif", 1, true) ~= nil, Si:sub(1, 4) == "RIFF" and Si:sub(9, 12) == "WEBP"; return gi or Oi or ni; end; local function Si() local gi; pcall(function() gi = typeof(getcustomasset) == "function" and getcustomasset or typeof(getsynasset) == "function" and getsynasset; end); if typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then return "https://files.catbox.moe/qn6x0d.jpg"; end; local Oi = false; pcall(function() Oi = isfile("GhostDuelLagger_qn6x0d.jpg"); end); if not Oi then local Oi, ni = pcall(function() return game:HttpGet("https://files.catbox.moe/qn6x0d.jpg"); end); if not Oi or not zi(ni) then warn("GhostDuel Lagger: no se pudo cargar el logo qn6x0d"); return "rbxassetid://88968171500964"; end; if not pcall(writefile, "GhostDuelLagger_qn6x0d.jpg", ni) then return "https://files.catbox.moe/qn6x0d.jpg"; end; end; if gi then local zi, Oi = pcall(gi, "GhostDuelLagger_qn6x0d.jpg"); if zi and type(Oi) == "string" and Oi ~= "" then return Oi; end; end; return "https://files.catbox.moe/qn6x0d.jpg"; end; local zi, gi, Oi, ni, Ji, fi = Color3.fromRGB(235, 248, 255), Enum.KeyCode.V, false; local oi, qi, Bi, ji, wi, yi, Ui, ei, ai, Wi, Ti, li, Zi, pi = false; local Ci = false; local function ri() return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"; end; local function Yi() if not ri() or not qi then return; end; local vi = {engineVersion = "legacy", mainEnabled = bi.Main, lowEndEnabled = bi.LowEnd, power = si.TableIncrease, keybind = gi and gi.Name or "V", visible = qi.Visible, minimized = Ci, position = {xScale = qi.Position.X.Scale, xOffset = qi.Position.X.Offset, yScale = qi.Position.Y.Scale, yOffset = qi.Position.Y.Offset}}; pcall(function() writefile("GhostDuelLagger_Settings.json", h:JSONEncode(vi)); end); end; local function vi() if not ri() then return nil; end; local ri, Mi = pcall(function() if isfile("GhostDuelLagger_Settings.json") then return h:JSONDecode(readfile("GhostDuelLagger_Settings.json")); end; return nil; end); return ri and Mi or nil; end; local ri = {ButtonA = "PAD A", ButtonB = "PAD B", ButtonX = "PAD X", ButtonY = "PAD Y", ButtonL1 = "PAD L1", ButtonR1 = "PAD R1", ButtonL2 = "PAD L2", ButtonR2 = "PAD R2", ButtonL3 = "PAD L3", ButtonR3 = "PAD R3", ButtonStart = "PAD START", ButtonSelect = "PAD SELECT", DPadUp = "DPAD UP", DPadDown = "DPAD DOWN", DPadLeft = "DPAD LEFT", DPadRight = "DPAD RIGHT"}; local function Mi(ui) return ui and ui.UserInputType and ui.UserInputType.Name:match("^Gamepad%d+$") ~= nil; end; local function ui(ti) return ri[ti.Name] or ti.Name; end; local function ri() if Ji then Ji.Text = ui(gi); Ji.TextColor3 = zi; Ji.BackgroundTransparency = 0.2; end; if fi then fi.Color = Color3.fromRGB(0, 0, 0); end; end; local function ti() Oi, oi = false, false; if ni then ni:Disconnect(); ni = nil; end; ri(); end; Ei = Instance.new("ScreenGui"); Ei.Name = "GhostDuelLaggerGUI"; Ei.ResetOnSpawn = false; Ei.IgnoreGuiInset = true; Ei.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; Ei.Parent = Hi; _G.__GhostDuelTrackConn (Ei.DescendantAdded:Connect(function(Gi) Ki(Gi); end)); qi = Instance.new("Frame"); qi.Name = "MainFrame"; qi.Size = UDim2.fromOffset(320, 328); qi.Position = UDim2.new(0.5,- 160, 0.5,- 164); qi.BackgroundColor3 = Color3.fromRGB(9, 24, 52); qi.BackgroundTransparency = 0.22; qi.BorderSizePixel = 0; qi.ClipsDescendants = true; qi.Active = true; qi.Parent = Ei; qi.Visible = false; Instance.new("UICorner", qi).CornerRadius = UDim.new(0, 18); local Ki, Gi = {bgDark = Color3.fromRGB(5, 16, 38), bgCard = Color3.fromRGB(9, 24, 52), stroke = Color3.fromRGB(38, 94, 145), accent = Color3.fromRGB(45, 140, 220), accentHover = Color3.fromRGB(85, 190, 245), accentDim = Color3.fromRGB(18, 48, 92), text = Color3.fromRGB(225, 245, 255), textMuted = Color3.fromRGB(145, 205, 235), white = Color3.fromRGB(240, 250, 255), toggleOff = Color3.fromRGB(12, 34, 70), toggleOn = Color3.fromRGB(45, 140, 220)}, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out); local function Di(di, Ks) Instance.new("UICorner", di).CornerRadius = UDim.new(0, Ks or 10); end; local function di(Ks, Rs, Xs) local cs = Instance.new("UIStroke", Ks); cs.Color = Rs or Ki.stroke; cs.Thickness = Xs or 1; cs.Transparency = 0.32; cs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; cs.LineJoinMode = Enum.LineJoinMode.Round; Xs = Instance.new("UIGradient", cs); Xs.Rotation = 90; Xs.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 215, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 22, 48))}); return cs; end; local function Ks(Rs, Xs, cs) Rs.MouseEnter:Connect(function() X:Create(Rs, Gi, {BackgroundColor3 = cs}):Play(); end); Rs.MouseLeave:Connect(function() X:Create(Rs, Gi, {BackgroundColor3 = Xs}):Play(); end); end; Hi = Instance.new("Frame"); Hi.Name = "Header"; Hi.Size = UDim2.new(1, 0, 0, 42); Hi.BackgroundColor3 = Ki.bgDark; Hi.BackgroundTransparency = 0.16; Hi.BorderSizePixel = 0; Hi.ZIndex = 3; Hi.Parent = qi; Di(Hi, 18); local Rs = Instance.new("ImageLabel", Hi); Rs.Name = "Logo"; Rs.Size = UDim2.fromOffset(24, 24); Rs.Position = UDim2.new(0, 12, 0.5,- 12); Rs.BackgroundTransparency = 1; Rs.Image = Si(); Rs.ScaleType = Enum.ScaleType.Fit; Rs.ZIndex = 4; Di(Rs, 6); Bi = Instance.new("TextLabel", Hi); Bi.Name = "Title"; Bi.Size = UDim2.fromOffset(140, 16); Bi.Position = UDim2.fromOffset(42, 6); Bi.BackgroundTransparency = 1; Bi.Font = Enum.Font.GothamBold; Bi.TextSize = 13; Bi.TextColor3 = Ki.text; Bi.TextXAlignment = Enum.TextXAlignment.Left; Bi.Text = "GhostDuel"; Bi.ZIndex = 4; ji = Instance.new("TextLabel", Hi); ji.Name = "LaggerLabel"; ji.Size = UDim2.fromOffset(140, 12); ji.Position = UDim2.fromOffset(42, 22); ji.BackgroundTransparency = 1; ji.Font = Enum.Font.Gotham; ji.TextSize = 10; ji.TextColor3 = Ki.textMuted; ji.TextXAlignment = Enum.TextXAlignment.Left; ji.Text = "Lagger Panel"; ji.ZIndex = 4; wi = Instance.new("TextButton", Hi); wi.Name = "Minimize"; wi.Size = UDim2.fromOffset(24, 24); wi.Position = UDim2.new(1,- 56, 0.5,- 12); wi.BackgroundColor3 = Ki.bgCard; wi.BorderSizePixel = 0; wi.Font = Enum.Font.GothamBold; wi.TextSize = 14; wi.TextColor3 = Ki.text; wi.Text = "-"; wi.AutoButtonColor = false; wi.ZIndex = 4; Di(wi, 6); Ks(wi, Ki.bgCard, Ki.accentDim); Si = Instance.new("TextButton", Hi); Si.Name = "Close"; Si.Size = UDim2.fromOffset(24, 24); Si.Position = UDim2.new(1,- 28, 0.5,- 12); Si.BackgroundColor3 = Ki.bgCard; Si.BorderSizePixel = 0; Si.Font = Enum.Font.GothamBold; Si.TextSize = 12; Si.TextColor3 = Ki.text; Si.Text = "X"; Si.AutoButtonColor = false; Si.ZIndex = 4; Di(Si, 6); Ks(Si, Ki.bgCard, Ki.accentHover); local Xs = Instance.new("Frame", qi); Xs.Name = "TabBar"; Xs.Size = UDim2.new(1,- 24, 0, 32); Xs.Position = UDim2.fromOffset(12, 50); Xs.BackgroundColor3 = Ki.bgDark; Xs.BackgroundTransparency = 0.14; Xs.BorderSizePixel = 0; Xs.ZIndex = 3; Di(Xs, 10); local cs = Instance.new("UIPadding", Xs); cs.PaddingLeft = UDim.new(0, 4); cs.PaddingRight = UDim.new(0, 4); cs.PaddingTop = UDim.new(0, 4); cs.PaddingBottom = UDim.new(0, 4); cs = Instance.new("UIListLayout", Xs); cs.FillDirection = Enum.FillDirection.Horizontal; cs.HorizontalAlignment = Enum.HorizontalAlignment.Center; cs.VerticalAlignment = Enum.VerticalAlignment.Center; cs.Padding = UDim.new(0, 4); local is = Instance.new("Frame", qi); is.Name = "Content"; is.Size = UDim2.new(1,- 24, 1,- 140); is.Position = UDim2.fromOffset(12, 90); is.BackgroundTransparency = 1; is.ZIndex = 3; local Qs, hs = {}, {}; local function ms(As) local Hs = Instance.new("TextButton", Xs); Hs.Size = UDim2.new(0.33,- 4, 1, 0); Hs.BackgroundColor3 = Ki.bgDark; Hs.BorderSizePixel = 0; Hs.Font = Enum.Font.GothamBold; Hs.TextSize = 11; Hs.TextColor3 = Ki.textMuted; Hs.Text = As; Hs.AutoButtonColor = false; Hs.ZIndex = 4; Di(Hs, 6); hs[As] = Hs; return Hs; end; local As, Hs, Es, ss = ms("Main"), ms("Keybind"), ms("Settings"), "Main"; local function bs(Vs) ss = Vs; for Fs, Ns in pairs(hs) do local hs = Fs == Vs; X:Create(Ns, Gi, {BackgroundColor3 = hs and Ki.accent or Ki.bgDark, TextColor3 = hs and Ki.white or Ki.textMuted}):Play(); end; for Gi, hs in pairs(Qs) do hs.Visible = Gi == Vs; end; end; As.Activated:Connect(function() bs("Main"); end); Hs.Activated:Connect(function() bs("Keybind"); end); Es.Activated:Connect(function() bs("Settings"); end); local function Gi(hs) local Vs = Instance.new("Frame", is); Vs.Name = hs .. "Page"; Vs.Size = UDim2.fromScale(1, 1); Vs.BackgroundTransparency = 1; Vs.ZIndex = 3; Qs[hs] = Vs; return Vs; end; Es, ms, As = Gi("Main"), Gi("Keybind"), Gi("Settings"); cs = Instance.new("UIListLayout", Es); cs.Padding = UDim.new(0, 10); cs.SortOrder = Enum.SortOrder.LayoutOrder; local function Qs(hs, Vs, Fs) local Ns = Instance.new("Frame", hs); Ns.Size = UDim2.new(1, 0, 0, Vs); Ns.BackgroundColor3 = Ki.bgCard; Ns.BackgroundTransparency = 0.2; Ns.BorderSizePixel = 0; Ns.LayoutOrder = Fs or 1; Ns.ZIndex = 3; Di(Ns, 12); di(Ns); return Ns; end; local function hs(Vs, Fs) local Ns = Instance.new("TextLabel", Vs); Ns.Size = UDim2.new(0.48, 0, 1, 0); Ns.Position = UDim2.fromOffset(14, 0); Ns.BackgroundTransparency = 1; Ns.Font = Enum.Font.GothamMedium; Ns.TextSize = 12; Ns.TextColor3 = Ki.text; Ns.TextXAlignment = Enum.TextXAlignment.Left; Ns.Text = Fs; Ns.ZIndex = 4; return Ns; end; cs = Qs(Es, 40, 1); hs(cs, "Device"); Hs = Instance.new("TextLabel", cs); Hs.Size = UDim2.fromOffset(90, 26); Hs.Position = UDim2.new(1,- 104, 0.5,- 13); Hs.BackgroundColor3 = Ki.bgDark; Hs.Font = Enum.Font.GothamBold; Hs.TextSize = 11; Hs.TextColor3 = Ki.text; Hs.Text = A and "Mobile" or "PC"; Hs.ZIndex = 4; Di(Hs, 6); Gi = Qs(Es, 40, 2); hs(Gi, "Intensity"); local Vs, Fs = {}, {{"LOW", 120}, {"MID", 210}, {"HARD", 270}}; for Ns, Is in ipairs(Fs) do Hs = Instance.new("TextButton", Gi); Hs.Size = UDim2.fromOffset(50, 26); Hs.Position = UDim2.new(1,- 170 + (Ns - 1) * 56, 0.5,- 13); Hs.BackgroundColor3 = Is[1] == "HARD" and Ki.accent or Ki.bgDark; Hs.BorderSizePixel = 0; Hs.Font = Enum.Font.GothamBold; Hs.TextSize = 10; Hs.TextColor3 = Is[1] == "HARD" and Ki.white or Ki.textMuted; Hs.Text = Is[1]; Hs.AutoButtonColor = false; Hs.ZIndex = 4; Di(Hs, 6); Vs[Is[1]] = {button = Hs, power = Is[2]}; end; Wi = Instance.new("TextButton", Es); Wi.Name = "ActivateButton"; Wi.Size = UDim2.new(1, 0, 0, 44); Wi.BackgroundColor3 = Ki.accent; Wi.BorderSizePixel = 0; Wi.Font = Enum.Font.GothamBold; Wi.TextSize = 15; Wi.TextColor3 = Ki.white; Wi.Text = "ACTIVATE"; Wi.AutoButtonColor = false; Wi.LayoutOrder = 3; Wi.ZIndex = 4; Di(Wi, 12); Ks(Wi, Ki.accent, Ki.accentHover); Hs = Qs(Es, 34, 4); hs(Hs, "Status"); Ui = Instance.new("TextLabel", Hs); Ui.Size = UDim2.fromOffset(92, 24); Ui.Position = UDim2.new(1,- 106, 0.5,- 12); Ui.BackgroundTransparency = 1; Ui.Font = Enum.Font.GothamBold; Ui.TextSize = 10; Ui.TextColor3 = Ki.textMuted; Ui.Text = "LAGGER: OFF"; Ui.ZIndex = 4; ei = Instance.new("Frame", Hs); ei.Size = UDim2.fromOffset(34, 18); ei.Position = UDim2.new(1,- 48, 0.5,- 9); ei.BackgroundColor3 = Ki.toggleOff; ei.BorderSizePixel = 0; ei.ZIndex = 4; Di(ei, 9); ai = Instance.new("Frame", ei); ai.Size = UDim2.fromOffset(12, 12); ai.Position = UDim2.new(0, 3, 0.5,- 6); ai.BackgroundColor3 = Ki.white; ai.BorderSizePixel = 0; ai.ZIndex = 5; Di(ai, 6); Gi = Instance.new("TextLabel", ms); Gi.Size = UDim2.new(1, 0, 0, 30); Gi.BackgroundTransparency = 1; Gi.Font = Enum.Font.GothamMedium; Gi.TextSize = 12; Gi.TextColor3 = Ki.textMuted; Gi.Text = "Press a key to set activate bind"; Gi.ZIndex = 4; Ji = Instance.new("TextButton", ms); Ji.Name = "KeybindButton"; Ji.Size = UDim2.new(1, 0, 0, 44); Ji.Position = UDim2.fromOffset(0, 40); Ji.BackgroundColor3 = Ki.bgCard; Ji.BackgroundTransparency = 0.2; Ji.BorderSizePixel = 0; Ji.Font = Enum.Font.GothamBold; Ji.TextSize = 14; Ji.TextColor3 = Ki.text; Ji.Text = ui(gi); Ji.AutoButtonColor = false; Ji.ZIndex = 4; Di(Ji, 12); fi = di(Ji); Gi = Instance.new("UIListLayout", As); Gi.Padding = UDim.new(0, 8); Gi.SortOrder = Enum.SortOrder.LayoutOrder; Fs = Qs(As, 48, 1); Fs.Name = "PowerControl"; hs(Fs, "Power").Size = UDim2.new(1,- 28, 0, 20); Ti = Instance.new("TextLabel", Fs); Ti.Size = UDim2.fromOffset(80, 20); Ti.Position = UDim2.new(1,- 94, 0, 0); Ti.BackgroundTransparency = 1; Ti.Font = Enum.Font.GothamBold; Ti.TextColor3 = Ki.text; Ti.TextSize = 10; Ti.TextXAlignment = Enum.TextXAlignment.Right; Ti.ZIndex = 4; li = Instance.new("Frame", Fs); li.Name = "Bar"; li.Size = UDim2.new(1,- 28, 0, 8); li.Position = UDim2.new(0, 14, 1,- 16); li.BackgroundColor3 = Ki.bgDark; li.BorderSizePixel = 0; li.ZIndex = 4; Di(li, 4); Zi = Instance.new("Frame", li); Zi.Name = "Fill"; Zi.Size = UDim2.fromScale(0, 1); Zi.BackgroundColor3 = Ki.accent; Zi.BorderSizePixel = 0; Zi.ZIndex = 5; Di(Zi, 4); pi = Instance.new("Frame", li); pi.Name = "Knob"; pi.AnchorPoint = Vector2.new(0.5, 0.5); pi.Size = UDim2.fromOffset(14, 14); pi.BackgroundColor3 = Ki.white; pi.BorderSizePixel = 0; pi.ZIndex = 6; Di(pi, 7); ms = Instance.new("TextButton", li); ms.Name = "PowerSlider"; ms.Size = UDim2.new(1, 12, 0, 24); ms.Position = UDim2.new(0,- 6, 0.5,- 12); ms.BackgroundTransparency = 1; ms.Text = ""; ms.ZIndex = 7; local ui, Gi, Ns = Instance.new("UIScale", qi), 100, Qs(As, 36, 2); hs(Ns, "GUI Size"); local Is = Instance.new("TextLabel", Ns); Is.Size = UDim2.fromOffset(50, 26); Is.Position = UDim2.new(1,- 86, 0.5,- 13); Is.BackgroundTransparency = 1; Is.Font = Enum.Font.GothamBold; Is.TextSize = 12; Is.TextColor3 = Ki.text; Is.Text = "100%"; Is.ZIndex = 4; Hs = Instance.new("TextButton", Ns); Hs.Size = UDim2.fromOffset(28, 26); Hs.Position = UDim2.new(1,- 118, 0.5,- 13); Hs.BackgroundColor3 = Ki.bgDark; Hs.TextColor3 = Ki.text; Hs.Text = "-"; Hs.ZIndex = 4; Di(Hs, 6); Fs = Instance.new("TextButton", Ns); Fs.Size = UDim2.fromOffset(28, 26); Fs.Position = UDim2.new(1,- 34, 0.5,- 13); Fs.BackgroundColor3 = Ki.bgDark; Fs.TextColor3 = Ki.text; Fs.Text = "+"; Fs.ZIndex = 4; Di(Fs, 6); local function Ps(ks) Gi = math.clamp(Gi + ks, 60, 140); Is.Text = tostring(Gi) .. "%"; ui.Scale = Gi / 100; end; Hs.Activated:Connect(function() Ps(- 10); end); Fs.Activated:Connect(function() Ps(10); end); cs = Qs(As, 36, 3); hs(cs, "Reset Position"); Ns = Instance.new("TextButton", cs); Ns.Size = UDim2.fromOffset(70, 26); Ns.Position = UDim2.new(1,- 84, 0.5,- 13); Ns.BackgroundColor3 = Ki.accent; Ns.BorderSizePixel = 0; Ns.Font = Enum.Font.GothamBold; Ns.TextSize = 11; Ns.TextColor3 = Ki.white; Ns.Text = "RESET"; Ns.AutoButtonColor = false; Ns.ZIndex = 4; Di(Ns, 6); Ks(Ns, Ki.accent, Ki.accentHover); Ns.Activated:Connect(function() qi.Position = UDim2.new(0.5,- 160, 0.5,- 164); Yi(); end); local ui = Instance.new("Frame", qi); ui.Name = "Footer"; ui.Size = UDim2.new(1, 0, 0, 36); ui.Position = UDim2.new(0, 0, 1,- 36); ui.BackgroundColor3 = Ki.bgDark; ui.BackgroundTransparency = 0.16; ui.BorderSizePixel = 0; ui.ZIndex = 3; Es = Instance.new("TextLabel", ui); Es.Size = UDim2.new(1,- 28, 1, 0); Es.Position = UDim2.fromOffset(14, 0); Es.BackgroundTransparency = 1; Es.Font = Enum.Font.GothamMedium; Es.TextSize = 11; Es.TextColor3 = Ki.textMuted; Es.TextXAlignment = Enum.TextXAlignment.Left; Es.Text = "discord.gg/GhostDuel"; Es.ZIndex = 4; yi = Instance.new("TextButton", Hi); yi.Name = "MinimizedToggle"; yi.Size = UDim2.fromOffset(72, 24); yi.Position = UDim2.new(1,- 136, 0.5,- 12); yi.BackgroundColor3 = Ki.bgCard; yi.BorderSizePixel = 0; yi.Font = Enum.Font.GothamBold; yi.TextSize = 11; yi.TextColor3 = Ki.text; yi.Text = "LAG: OFF"; yi.Visible = false; yi.ZIndex = 4; Di(yi, 6); di(yi); for Gi, Gi in ipairs(qi:GetDescendants()) do if Gi:IsA("GuiObject") then Gi.BorderSizePixel = 0; if(Gi:IsA("Frame") or(Gi:IsA("TextLabel")) or(Gi:IsA("TextButton")) or(Gi:IsA("TextBox")) or(Gi:IsA("ImageLabel"))) and Gi.BackgroundTransparency < 1 and not Gi:FindFirstChildOfClass("UICorner") then Di(Gi, 10); end; end; end; bs("Main"); local Gi = false; local function Di(di, Ks) di = math.clamp(math.floor((tonumber(di) or 0) + 0.5), 0, 290); si.TableIncrease = di; local cs = di / 290; Zi.Size = UDim2.fromScale(cs, 1); pi.Position = UDim2.new(cs, 0, 0.5, 0); Ti.Text = "POWER: " .. tostring(di); cs = di <= 165 and "LOW" or(di <= 240 and "MID" or "HARD"); for Ti, Zi in pairs(Vs) do di = Ti == cs; Zi.button.BackgroundColor3 = di and Ki.accent or Ki.bgDark; Zi.button.TextColor3 = di and Ki.white or Ki.textMuted; end; if Ks then Yi(); end; end; local function Ti(Zi) local pi = li.AbsoluteSize.X; if pi <= 0 then return; end; Di(math.clamp((Zi.Position.X - li.AbsolutePosition.X) / pi, 0, 1) * 290, false); end; Di(si.TableIncrease, false); for li, li in pairs(Vs) do li.button.Activated:Connect(function() Di(li.power, true); end); end; ms.InputBegan:Connect(function(li) if li.UserInputType == Enum.UserInputType.MouseButton1 or li.UserInputType == Enum.UserInputType.Touch then Gi = true; Ti(li); end; end); _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(li) if Gi and(li.UserInputType == Enum.UserInputType.MouseMovement or li.UserInputType == Enum.UserInputType.Touch) then Ti(li); end; end)); _G.__GhostDuelTrackConn (R.InputEnded:Connect(function(Ti) if Gi and(Ti.UserInputType == Enum.UserInputType.MouseButton1 or Ti.UserInputType == Enum.UserInputType.Touch) then Gi = false; Di(si.TableIncrease, true); end; end)); Ji.Activated:Connect(function() if Oi then return; end; Oi = true; Ji.Text = "..."; Ji.TextColor3 = zi; Ji.BackgroundTransparency = 0.6; if fi then fi.Color = Color3.fromRGB(0, 0, 0); end; ni = R.InputBegan:Connect(function(zi) if not Oi then return; end; local Ji = zi.UserInputType == Enum.UserInputType.Keyboard; if Ji or Mi(zi) then if zi.KeyCode == Enum.KeyCode.Unknown then return; end; if Ji and zi.KeyCode == Enum.KeyCode.Escape then ti(); return; end; gi, Oi, oi = zi.KeyCode, false, true; if ni then ni:Disconnect(); ni = nil; end; ri(); Yi(); task.delay(0.3, function() oi = false; end); end; end); task.delay(5, function() if Oi then ti(); end; end); end); local function zi(ni, Ji) local fi = ni and(UDim2.new(1,- 17, 0.5,- 6)) or(UDim2.new(0, 3, 0.5,- 6)); if Ji then X:Create(ai, TweenInfo.new(0.15), {Position = fi}):Play(); else ai.Position = fi; end; Ui.Text = ni and "LAGGER: ON" or "LAGGER: OFF"; Ui.TextColor3 = ni and Ki.white or Ki.textMuted; ei.BackgroundColor3 = ni and Ki.toggleOn or Ki.toggleOff; Wi.Text = ni and "DEACTIVATE" or "ACTIVATE"; yi.Text = ni and "LAG: ON" or "LAG: OFF"; yi.BackgroundColor3 = ni and Ki.accent or Ki.bgCard; yi.TextColor3 = Ki.white; end; Wi.MouseButton1Click:Connect(function() zi(Fi(), true); Yi(); end); yi.Activated:Connect(function() zi(Fi(), true); Yi(); end); Si.MouseButton1Click:Connect(function() qi.Visible = false; ci = false; ii(); Yi(); end); local Ki, Si = UDim2.fromOffset(320, 328), UDim2.fromOffset(320, 42); local function ni(Ji, fi) Ci = Ji == true; wi.Text = Ci and "+" or "-"; yi.Visible = Ci; Rs.Visible = not Ci; Bi.Visible = not Ci; ji.Visible = not Ci; Xs.Visible = not Ci; is.Visible = not Ci; ui.Visible = not Ci; Ji = Ci and Si or Ki; if fi then X:Create(qi, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Ji}):Play(); else qi.Size = Ji; end; if not Ci then bs(ss); end; end; wi.Activated:Connect(function() ni(not Ci, true); Yi(); end); _G.__GhostDuelTrackConn (R.InputBegan:Connect(function(Ki, Si) if Oi then return; end; if oi then return; end; local Oi = Mi(Ki); if Si and not Oi then return; end; if Ki.UserInputType ~= Enum.UserInputType.Keyboard and not Oi then return; end; if Ki.KeyCode ~= gi then return; end; zi(Fi(), true); Yi(); end)); local Ki = 0; qi:GetPropertyChangedSignal("Position"):Connect(function() Ki += 1; local Si = Ki; task.delay(0.3, function() if Si == Ki then Yi(); end; end); end); local Ki, Si, Oi = false; Hi.InputBegan:Connect(function(Hi) if Hi.UserInputType == Enum.UserInputType.MouseButton1 or Hi.UserInputType == Enum.UserInputType.Touch then Ki = true; Si = Hi.Position; Oi = qi.Position; end; end); _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(Hi) if not Ki then return; end; if Hi.UserInputType ~= Enum.UserInputType.MouseMovement and Hi.UserInputType ~= Enum.UserInputType.Touch then return; end; local Ji = Hi.Position - Si; qi.Position = UDim2.new(Oi.X.Scale, Oi.X.Offset + Ji.X, Oi.Y.Scale, Oi.Y.Offset + Ji.Y); end)); _G.__GhostDuelTrackConn (R.InputEnded:Connect(function(Hi) local Si = Hi.UserInputType == Enum.UserInputType.MouseButton1 or Hi.UserInputType == Enum.UserInputType.Touch; if Si then Ki = false; end; end)); local function Hi() local Si = vi(); if not Si then zi(false, false); ri(); qi.Visible = Qi == true; ci = qi.Visible; ii(); Yi(); return; end; if Si.keybind then local Oi = Enum.KeyCode[Si.keybind]; if Oi then gi = Oi; end; end; if Si.power ~= nil then local Oi = tonumber(Si.power); Di((if Si.engineVersion ~= "legacy" and Oi == 90 then 270 else Oi) or si.TableIncrease, false); end; ri(); if Si.mainEnabled ~= nil then bi.Main = Si.mainEnabled == true and not A; if bi.Main then Pi(); end; zi(bi.Main, false); end; if Si.lowEndEnabled ~= nil then bi.LowEnd = Si.lowEndEnabled == true and not A; if bi.LowEnd then ki(); end; end; if Si.position and not _G.__GhostDuelGuiPositionsReset then pcall(function() qi.Position = UDim2.new(Si.position.xScale, Si.position.xOffset, Si.position.yScale, Si.position.yOffset); end); end; ni(Si.minimized == true, false); if Si.visible ~= nil then qi.Visible = Qi == true and true or Si.visible and true or false; else qi.Visible = Qi == true; end; ci = qi.Visible; ii(); Yi(); end; for Qi, Qi in ipairs(Ei:GetDescendants()) do if Qi:IsA("TextLabel") or(Qi:IsA("TextButton")) or(Qi:IsA("TextBox")) then Qi:SetAttribute("GhostDuelKeepBlackText", true); Qi.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); Qi.TextStrokeTransparency = 0.2; end; end; Hi(); Yi(); _G.GhostDuelLagger = {Stop = function() _i (); end, ResetPosition = function() Ki = false; qi.Position = UDim2.new(0.5,- 160, 0.5,- 164); Yi(); end, IsEnabled = function() return bi.Main; end, IsLowEndEnabled = function() return bi.LowEnd; end, Toggle = function() local Ki = Fi(); zi(Ki, true); Yi(); return Ki; end, ToggleLowEnd = function() local Ki = Li(); Yi(); return Ki; end, SetEnabled = function(Ki) if bi.Main ~= Ki then bi.Main = Ki; if Ki then if bi.LowEnd then bi.LowEnd = false; xi("LowEnd"); end; Pi(); else xi("Main"); end; zi(bi.Main, true); Yi(); end; end, SetLowEndEnabled = function(Ki) if bi.LowEnd ~= Ki then bi.LowEnd = Ki; if Ki then if bi.Main then bi.Main = false; xi("Main"); zi(false, true); end; ki(); else xi("LowEnd"); end; Yi(); end; end, GetPower = function() return si.TableIncrease; end, SetPower = function(Ki) Di(Ki, true); end, GetKeybind = function() return gi; end, SetKeybind = function(Ki) local Qi = if typeof(Ki) == "string" then Enum.KeyCode[Ki] else if typeof(Ki) == "EnumItem" and Ki.EnumType == Enum.KeyCode then Ki else nil; if Qi then gi = Qi; ri(); Yi(); end; end, SetBackground = function() end, GetBackground = function() return 1; end, SetVisible = function(Ki) if qi then local Qi = Ki and true or false; qi.Visible = Qi; ci = Qi; ii(); Yi(); end; end, SaveSettings = function() Yi(); end}; end); end);
                                                end;
                                                _G.__openLaggerGUI = r;
                                                local function Ki()
                                                    ci = false;
                                                    ii();
                                                    if _G.GhostDuelLagger and _G.GhostDuelLagger.SetVisible then
                                                        _G.GhostDuelLagger.SetVisible(false);
                                                    end;
                                                    if _G.GhostDuelLagger and _G.GhostDuelLagger.SaveSettings then
                                                        _G.GhostDuelLagger.SaveSettings();
                                                    end;
                                                end;
                                                u(Z, function() ci = not ci; ii(); if ci then if _G._GhostDuelLaggerGUILoaded then if _G.GhostDuelLagger and _G.GhostDuelLagger.SetVisible then _G.GhostDuelLagger.SetVisible(true); end; if _G.GhostDuelLagger and _G.GhostDuelLagger.SaveSettings then _G.GhostDuelLagger.SaveSettings(); end; else r(true); end; else Ki(); end; end);
                                                local Z, Ki = _G.__GhostDuelReadSavedPanelVisibility ("GhostDuelLagger_Settings.json");
                                                ci = Z and Ki or false;
                                                ii();
                                                if Z then
                                                    r(false);
                                                end;
                                                local r = false;
                                                local function ci()
                                                    Q.BackgroundColor3 = r and(Color3.fromRGB(45, 140, 220)) or(Color3.fromRGB(12, 34, 70));
                                                    Q.TextColor3 = r and(Color3.fromRGB(240, 250, 255)) or(Color3.fromRGB(145, 215, 255));
                                                    e.Color = r and(Color3.fromRGB(160, 225, 255)) or(Color3.fromRGB(38, 94, 145));
                                                    e.Thickness = r and 1.5 or 1;
                                                end;
                                                function _G.__syncBypassVisual ()
                                                    ci();
                                                end;
                                                local function e(ii)
                                                    if ii == nil then
                                                        ii = true;
                                                    end;
                                                    if ii and _G.GhostDuelLagger and _G.GhostDuelLagger.SetVisible then
                                                        pcall(_G.GhostDuelLagger.SetVisible, false);
                                                    end;
                                                    local Qi = game:GetService("Players").LocalPlayer;
                                                    local Hi = Qi and(Qi:FindFirstChild("PlayerGui"));
                                                    if Hi and(Hi:FindFirstChild("GhostDuelBypassGUI")) then
                                                        if ii then
                                                            pcall(function() if _G.GhostDuelBypass and _G.GhostDuelBypass.SetVisible then _G.GhostDuelBypass.SetVisible(true); end; end);
                                                        end;
                                                        return;
                                                    end;
                                                    if _G._GhostDuelBypassGUILoaded then
                                                        _G._GhostDuelBypassGUILoaded = false;
                                                    end;
                                                    _G._GhostDuelBypassGUILoaded = true;
                                                    task.spawn(function() pcall(function() if not H.alive then return; end; local Qi, Hi = game:GetService("NetworkClient"), K.LocalPlayer; local Ei = Hi:WaitForChild("PlayerGui"); local si = Ei:FindFirstChild("GhostDuelBypassGUI"); if si then si:Destroy(); end; local bi, Fi, Pi, ki = {Power = 97000, PCPower = 97000, MobilePower = 72000, Mode = "PC", SpamDelay = 0.12, Version = "V1", DropPaused = false}, false; local function xi(_i) local Li, zi = {}, {{}}; local Si = zi[1]; for gi = 1, 186, 1 do gi = {}; table.insert(Si, gi); Si = gi; end; for Si = 1, math.floor(_i / 188), 1 do table.insert(Li, zi); end; return Li; end; local function _i (Li) local zi, Si = {}, {{}}; local gi = Si[1]; for Oi = 1, 296, 1 do Oi = {}; table.insert(gi, Oi); gi = Oi; end; for gi = 1, math.floor(Li / 298), 1 do table.insert(zi, Si); end; return zi; end; local function Li(zi) return bi.Version == "V1" and(xi(zi)) or(_i (zi)); end; local function xi() if Fi then return true; end; Fi = true; pcall(function() Qi:SetOutgoingKBPSLimit(math.huge); end); Pi = Li(bi.Power); local _i = game:FindFirstChild("RobloxReplicatedStorage"); local Li = _i and(_i:FindFirstChild("SetPlayerBlockList")); if not Li then Fi = false; return; end; ki = task.spawn(function() while Fi do if Pi then pcall(function() Li:FireServer(Pi); end); end; task.wait(bi.SpamDelay); end; end); return true; end; local function _i (Li) Fi = false; if ki then pcall(function() task.cancel(ki); ki = nil; end); end; Pi = nil; if not Li then pcall(function() Qi:SetOutgoingKBPSLimit(math.huge); end); end; end; local function Qi(Pi) local ki = bi.Mode == "PC" and 150000 or 100000; bi.Power = math.clamp(Pi, 10000, ki); if bi.Mode == "PC" then bi.PCPower = bi.Power; else bi.MobilePower = bi.Power; end; if Fi then _i (); task.wait(0.05); xi(); end; end; local function Pi(ki) if ki ~= "V1" and ki ~= "V2" then return; end; bi.Version = ki; bi.Power = ki == "V1" and 97000 or 100000; if bi.Mode == "PC" then bi.PCPower = bi.Power; else bi.MobilePower = bi.Power; end; if powerBox then powerBox.Text = tostring(bi.Power); end; if Fi then _i (); task.wait(0.05); xi(); end; end; local function ki(Li) if type(Li) ~= "string" or #Li < 16 then return false; end; local zi, Si, gi = Li:sub(1, 8) == "\137PNG\13\10\26\10", Li:sub(1, 2) == "\255\216" or Li:find("JFIF", 1, true) ~= nil or Li:find("Exif", 1, true) ~= nil, Li:sub(1, 4) == "RIFF" and Li:sub(9, 12) == "WEBP"; return zi or Si or gi; end; local Li, zi, Si = {((function() local gi; pcall(function() gi = typeof(getcustomasset) == "function" and getcustomasset or typeof(getsynasset) == "function" and getsynasset; end); if typeof(writefile) ~= "function" or typeof(isfile) ~= "function" then return "https://files.catbox.moe/clcelu.jpg"; end; local Oi = false; pcall(function() Oi = isfile("GhostDuelBypass_clcelu.jpg"); end); if not Oi then local Oi, ni = pcall(function() return game:HttpGet("https://files.catbox.moe/clcelu.jpg"); end); if not Oi or not ki(ni) then warn("GhostDuel Bypass: no se pudo descargar el fondo clcelu"); return "rbxassetid://94763047376005"; end; if not pcall(writefile, "GhostDuelBypass_clcelu.jpg", ni) then return "https://files.catbox.moe/clcelu.jpg"; end; end; if gi then local ki, Oi = pcall(gi, "GhostDuelBypass_clcelu.jpg"); if ki and type(Oi) == "string" and Oi ~= "" then return Oi; end; end; return "https://files.catbox.moe/clcelu.jpg"; end)())}, Color3.fromRGB(160, 225, 255), Color3.fromRGB(20, 70, 130); local ki, gi, Oi, ni, Ji, fi, oi, qi, Bi, ji, wi, yi, Ui; local ei, ai, Wi, Ti, li = false, 1, false, {}, Enum.UserInputType.Keyboard; Ti.inputType = li; li = Enum.KeyCode.Five; Ti.keyCode = li; local Zi = false; local function pi() return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"; end; local function Ci() if not pi() or not oi then return; end; local ri = Ti and {inputType = Ti.inputType.Name, keyCode = Ti.keyCode.Name} or nil; local Yi = {power = ki and ki.Text or "97000", pcPower = bi.PCPower, mobilePower = bi.MobilePower, mode = bi.Mode, autoOnSteal = Wi or false, keybind = ri, background = ai or 1, visible = oi.Visible, minimized = ei, position = {xScale = oi.Position.X.Scale, xOffset = oi.Position.X.Offset, yScale = oi.Position.Y.Scale, yOffset = oi.Position.Y.Offset}, bypassEnabled = Fi or false, manualOverride = Zi or false, bypassVersion = bi.Version or "V1"}; pcall(function() writefile("GhostDuelBypass_Settings.json", h:JSONEncode(Yi)); end); end; local function ri() if not pi() then return nil; end; local pi, Yi = pcall(function() if isfile("GhostDuelBypass_Settings.json") then return h:JSONDecode(readfile("GhostDuelBypass_Settings.json")); end; return nil; end); return pi and Yi or nil; end; local h = Instance.new("ScreenGui"); h.Name = "GhostDuelBypassGUI"; h.ResetOnSpawn = false; h.IgnoreGuiInset = true; h.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; if not H.alive then h:Destroy(); return; end; h.Parent = Ei; _G.__GhostDuelRegisterThemeRoot (h); oi = Instance.new("Frame"); oi.Name = "MainFrame"; oi.Size = UDim2.new(0, 320, 0, 160); oi.Position = UDim2.new(0.5,- 160, 0.5,- 80); oi.BackgroundColor3 = Color3.fromRGB(9, 24, 52); oi.BackgroundTransparency = 0; oi.BorderSizePixel = 0; oi.ClipsDescendants = true; oi.Active = true; oi.Draggable = false; oi.Parent = h; oi.Visible = false; local pi = Instance.new("UIAspectRatioConstraint"); pi.AspectRatio = 2; pi.Parent = oi; if A then li = Instance.new("UIScale"); li.Name = "MobilePanelScale"; li.Scale = 0.82; li.Parent = oi; end; Instance.new("UICorner", oi).CornerRadius = UDim.new(0, 16); local Yi = Instance.new("UIStroke", oi); Yi.Color = Color3.fromRGB(181, 181, 181); Yi.Thickness = 1.5; Yi.Transparency = 1; Yi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; qi = Instance.new("ImageLabel"); qi.Name = "BgImageLabel"; qi.Size = UDim2.new(1, 0, 1, 0); qi.BackgroundTransparency = 1; qi.Image = Li[1]; qi.ImageTransparency = 0; qi.ScaleType = Enum.ScaleType.Crop; qi.ZIndex = 0; qi.Parent = oi; qi.Visible = true; Instance.new("UICorner", qi).CornerRadius = UDim.new(0, 16); _G.__GhostDuelRoundPanelBackground (qi, oi); _G.__GhostDuelAddUnifiedPanelShade (oi, 16, 1); local vi = Instance.new("UIStroke", oi); vi.Name = "Glow"; vi.Color = Color3.fromRGB(191, 191, 191); vi.Thickness = 4; vi.Transparency = 1; vi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; local Mi = Instance.new("UIStroke", oi); Mi.Name = "Glow2"; Mi.Color = Color3.fromRGB(255, 255, 255); Mi.Thickness = 6; Mi.Transparency = 1; Mi.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; local ui = Instance.new("Frame"); ui.Size = UDim2.new(1, 0, 1, 0); ui.BackgroundTransparency = 1; ui.ZIndex = 3; ui.Parent = oi; local ti = Instance.new("TextButton"); ti.Name = "Minimize"; ti.Size = UDim2.fromOffset(28, 28); ti.Position = UDim2.new(1,- 36, 0, 8); ti.BackgroundColor3 = Color3.fromRGB(12, 34, 70); ti.BackgroundTransparency = 0.08; ti.BorderSizePixel = 0; ti.AutoButtonColor = false; ti.Text = "-"; ti.TextColor3 = zi; ti.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); ti.TextStrokeTransparency = 0.15; ti.TextSize = 18; ti.Font = Enum.Font.GothamBlack; ti.ZIndex = 12; ti.Parent = oi; Instance.new("UICorner", ti).CornerRadius = UDim.new(0, 7); Ei = Instance.new("UIStroke", ti); Ei.Color = Color3.fromRGB(0, 0, 0); Ei.Thickness = 1; local Gi = Instance.new("TextButton"); Gi.Name = "MinimizedToggle"; Gi.Size = UDim2.new(1,- 54, 0, 30); Gi.Position = UDim2.fromOffset(8, 7); Gi.BackgroundColor3 = Color3.fromRGB(18, 48, 92); Gi.BackgroundTransparency = 0.08; Gi.BorderSizePixel = 0; Gi.AutoButtonColor = false; Gi.Text = "ACTIVATE BYPASS"; Gi.TextColor3 = zi; Gi.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); Gi.TextStrokeTransparency = 0.15; Gi.TextSize = 11; Gi.Font = Enum.Font.GothamBold; Gi.Visible = false; Gi.ZIndex = 12; Gi.Parent = oi; Instance.new("UICorner", Gi).CornerRadius = UDim.new(0, 7); li = Instance.new("UIStroke", Gi); li.Color = Color3.fromRGB(0, 0, 0); li.Thickness = 1; local Di, di = UDim2.fromOffset(320, 160), UDim2.fromOffset(310, 44); local function Ks() Gi.Text = Fi and "DEACTIVATE BYPASS" or "ACTIVATE BYPASS"; Gi.BackgroundColor3 = Fi and(Color3.fromRGB(45, 140, 220)) or(Color3.fromRGB(18, 48, 92)); Gi.TextColor3 = zi; end; local function Rs(Xs, cs) ei = Xs == true; ti.Text = ei and "+" or "-"; ui.Visible = not ei; Gi.Visible = ei; if ei and Bi then Bi.Visible = false; end; pi.Parent = ei and nil or oi; Xs = ei and di or Di; if cs then X:Create(oi, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Xs}):Play(); else oi.Size = Xs; end; end; ti.Activated:Connect(function() Rs(not ei, true); Ci(); end); local ei = Instance.new("TextLabel"); ei.Size = UDim2.new(0, 110, 0, 20); ei.Position = UDim2.new(0, 16, 0, 7); ei.BackgroundTransparency = 1; ei.Font = Enum.Font.GothamBlack; ei.Text = ""; ei.TextColor3 = zi; ei.TextSize = 16; ei.TextXAlignment = Enum.TextXAlignment.Left; ei.ZIndex = 3; ei.Parent = ui; Ei = Instance.new("UIStroke", ei); Ei.Color = Color3.fromRGB(0, 0, 0); Ei.Thickness = 1.5; Ei.Transparency = 0.2; li = Instance.new("UIGradient"); li.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255))}); li.Parent = ei; li.Enabled = false; si = Instance.new("TextLabel"); si.Name = "BypassLabel"; si.Position = UDim2.new(0, 16, 0, 27); si.Size = UDim2.new(0, 110, 0, 18); si.BackgroundTransparency = 1; si.Text = ""; si.TextColor3 = zi; si.TextSize = 13; si.Font = Enum.Font.GothamBold; si.TextXAlignment = Enum.TextXAlignment.Left; si.ZIndex = 3; si.Parent = ui; ei.AnchorPoint = Vector2.new(0.5, 0); ei.Position = UDim2.new(0.5, 0, 0, 44); ei.Size = UDim2.fromOffset(224, 26); _G.__GhostDuelAddOriginalGui3Title (ei, "Bypass"); ei.Visible = false; local pi = Instance.new("TextLabel"); pi.Name = "TitleShadow"; pi.Size = UDim2.new(1, 0, 0, 50); pi.Position = UDim2.new(0,- 7, 0, 1); pi.BackgroundTransparency = 1; pi.Font = Enum.Font.GothamBlack; pi.Text = ""; pi.TextColor3 = Color3.fromRGB(20, 50, 100); pi.TextSize = 18; pi.TextXAlignment = Enum.TextXAlignment.Center; pi.ZIndex = 2; pi.Parent = ui; pi.Visible = false; fi = Instance.new("TextButton"); fi.AnchorPoint = Vector2.new(0.5, 0); fi.Size = UDim2.new(0, 90, 0, 20); fi.Position = UDim2.new(0.5, 0, 0, 38); fi.BackgroundColor3 = zi; fi.BackgroundTransparency = 0.55; fi.AutoButtonColor = false; fi.Font = Enum.Font.GothamBold; fi.Text = "Themes"; fi.Visible = true; fi.TextWrapped = false; fi.TextXAlignment = Enum.TextXAlignment.Center; fi.TextColor3 = Si; fi.TextSize = 10; fi.Parent = ui; fi.Visible = false; Instance.new("UICorner", fi).CornerRadius = UDim.new(0, 6); si = Instance.new("UIStroke", fi); si.Color = Color3.fromRGB(0, 0, 0); si.Thickness = 1; si.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; Bi = Instance.new("Frame"); Bi.Name = "ThemesPanel"; Bi.Size = UDim2.fromOffset(220, 180); Bi.BackgroundColor3 = Color3.fromRGB(45, 140, 220); Bi.BorderSizePixel = 0; Bi.Visible = false; Bi.ZIndex = 20; Bi.Parent = h; Ei = Instance.new("UIGradient", Bi); Ei.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 58, 58)), ColorSequenceKeypoint.new(0.48, Color3.fromRGB(92, 92, 92)), ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52))}); Ei.Rotation = 35; local function ti() Bi.Position = UDim2.new(oi.Position.X.Scale, oi.Position.X.Offset + oi.Size.X.Offset + 12, oi.Position.Y.Scale, oi.Position.Y.Offset); end; Instance.new("UICorner", Bi).CornerRadius = UDim.new(0, 12); si = Instance.new("UIStroke", Bi); si.Color = Yi.Color; si.Thickness = Yi.Thickness; local Di, di = ai, {}; local function Xs() for cs, is in ipairs(di) do local Qs = cs == Di; is.stroke.Color = zi; is.stroke.Thickness = Qs and 2 or 1.5; is.stroke.Transparency = Qs and 0.25 or 0.7; is.stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; local cs, hs, ms, As = is.baseX or is.Position.X.Offset, is.baseY or is.Position.Y.Offset, is.baseW or is.Size.X.Offset, is.baseH or is.Size.Y.Offset; is.card.Size = Qs and(UDim2.fromOffset(math.max(4, ms - 6), math.max(4, As - 6))) or(UDim2.fromOffset(ms, As)); is.card.Position = Qs and(UDim2.new(0, cs + 3, 0, hs + 3)) or(UDim2.new(0, cs, 0, hs)); is.image.Size = UDim2.new(1, 0, 1, 0); is.image.Position = UDim2.new(0, 0, 0, 0); end; end; for cs, is in ipairs(Li) do li, si, Ei = Instance.new("TextButton", Bi), 12 + (cs - 1) % 2 * 98, 12 + math.floor((cs - 1) / 2) * 62; li.Size = UDim2.fromOffset(88, 56); li.Position = UDim2.new(0, si, 0, Ei); li.BackgroundColor3 = zi; li.BorderSizePixel = 0; li.Text = ""; li.AutoButtonColor = false; li.ZIndex = 21; Instance.new("UICorner", li).CornerRadius = UDim.new(0, 7); local Qs = Instance.new("ImageLabel", li); Qs.Size = UDim2.new(1, 0, 1, 0); Qs.BackgroundTransparency = 1; Qs.Image = is; Qs.ScaleType = Enum.ScaleType.Crop; Qs.ZIndex = 21; Instance.new("UICorner", Qs).CornerRadius = UDim.new(0, 7); is = Instance.new("TextLabel", li); is.Size = UDim2.new(1,- 6, 0, 14); is.Position = UDim2.new(0, 3, 1,- 16); is.BackgroundTransparency = 1; is.Text = "GUI " .. tostring(cs); is.TextColor3 = zi; is.TextSize = 8; is.Font = Enum.Font.GothamBold; is.ZIndex = 23; is.TextStrokeColor3 = Color3.fromRGB(5, 12, 25); is.TextStrokeTransparency = 0.25; is = Instance.new("UIStroke", li); is.Color = Color3.fromRGB(0, 0, 0); is.Thickness = 1; is.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; table.insert(di, {card = li, stroke = is, image = Qs, baseX = si, baseY = Ei, baseW = 88, baseH = 56}); li.Activated:Connect(function() Di = cs; Xs(); end); end; si = Instance.new("TextButton", Bi); si.Size = UDim2.new(1,- 24, 0, 28); si.Position = UDim2.new(0, 12, 1,- 44); si.BackgroundColor3 = Color3.fromRGB(18, 48, 92); si.BorderSizePixel = 0; si.Text = "Save Theme"; si.TextColor3 = zi; si.TextSize = 11; si.Font = Enum.Font.GothamBold; si.ZIndex = 21; Instance.new("UICorner", si).CornerRadius = UDim.new(0, 7); si.Activated:Connect(function() ai = Di; qi.Image = Li[ai]; _G.__GhostDuelFramePanelBackground (qi, ai, "Bypass"); Yi.Transparency = ai == 1 and 1 or 0.448; vi.Transparency = ai == 1 and 1 or 0.782; Mi.Transparency = ai == 1 and 1 or 0.891; if Ui then Ui(); end; Bi.Visible = false; Ci(); end); fi.Activated:Connect(function() Di = ai; ti(); Bi.Visible = not Bi.Visible; Xs(); end); Ji = Instance.new("TextButton"); Ji.AnchorPoint = Vector2.new(0, 0); Ji.Size = UDim2.new(0, 44, 0, 22); Ji.Position = UDim2.new(0, 16, 0, 13); Ji.BackgroundColor3 = Color3.fromRGB(7, 22, 48); Ji.BackgroundTransparency = 0; Ji.AutoButtonColor = false; Ji.Font = Enum.Font.GothamBold; Ji.Text = "V1"; Ji.TextColor3 = Si; Ji.TextSize = 10; Ji.Parent = ui; Instance.new("UICorner", Ji).CornerRadius = UDim.new(0, 6); Ei = Instance.new("UIGradient", Ji); Ei.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 22, 48)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 215, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 22, 48))}); Ei.Rotation = 0; local Di = Instance.new("UIStroke", Ji); Di.Color = Color3.fromRGB(160, 225, 255); Di.Thickness = 1; Di.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; local function di() Ji.Text = bi.Version; Ji.TextColor3 = zi; Di.Color = Color3.fromRGB(160, 225, 255); end; Ji.Activated:Connect(function() Pi(bi.Version == "V1" and "V2" or "V1"); di(); Ci(); end); si = Instance.new("Frame"); si.Name = "PCToggleFrame"; si.AnchorPoint = Vector2.new(0.5, 0); si.Position = UDim2.new(0.5, 0, 0, 13); si.Size = UDim2.new(0, 100, 0, 22); si.BackgroundColor3 = Color3.fromRGB(12, 34, 70); si.BackgroundTransparency = 0.4; si.Parent = ui; Instance.new("UICorner", si).CornerRadius = UDim.new(0, 6); li = Instance.new("UIStroke", si); li.Color = Color3.fromRGB(38, 94, 145); li.Transparency = 0.3; ji = Instance.new("TextButton"); ji.Position = UDim2.new(0, 2, 0, 2); ji.Size = UDim2.new(0.5,- 2, 1,- 4); ji.BackgroundTransparency = 0.4; ji.Text = "PC"; ji.TextSize = 9; ji.Font = Enum.Font.GothamBold; ji.AutoButtonColor = false; ji.Parent = si; Instance.new("UICorner", ji).CornerRadius = UDim.new(0, 5); wi = Instance.new("TextButton"); wi.Position = UDim2.new(0.5, 2, 0, 2); wi.Size = UDim2.new(0.5,- 2, 1,- 4); wi.BackgroundTransparency = 0.4; wi.Text = "Mobile"; wi.TextSize = 9; wi.Font = Enum.Font.GothamBold; wi.AutoButtonColor = false; wi.Parent = si; Instance.new("UICorner", wi).CornerRadius = UDim.new(0, 5); li = Instance.new("Frame"); li.Name = "PowerRow"; li.Position = UDim2.new(0, 22, 0, 74); li.Size = UDim2.new(1,- 44, 0, 40); li.BackgroundColor3 = Color3.fromRGB(12, 34, 70); li.BackgroundTransparency = 0.4; li.Parent = ui; Instance.new("UICorner", li).CornerRadius = UDim.new(0, 10); si = Instance.new("UIStroke", li); si.Color = Color3.fromRGB(38, 94, 145); si.Transparency = 0.3; Ei = Instance.new("TextLabel"); Ei.Size = UDim2.new(0, 38, 1, 0); Ei.Position = UDim2.new(0, 8, 0, 0); Ei.BackgroundTransparency = 1; Ei.Text = "POWER"; Ei.TextColor3 = zi; Ei.TextTransparency = 0; Ei.TextSize = 8; Ei.Font = Enum.Font.GothamBold; Ei.TextXAlignment = Enum.TextXAlignment.Left; Ei.Parent = li; ki = Instance.new("TextBox"); ki.Size = UDim2.new(0, 60, 0, 24); ki.Position = UDim2.new(0, 46, 0, 8); ki.BackgroundColor3 = Color3.fromRGB(9, 24, 52); ki.BackgroundTransparency = 0.4; ki.Font = Enum.Font.GothamBold; ki.Text = "97000"; ki.PlaceholderText = "97000"; ki.TextColor3 = zi; ki.TextSize = 10; ki.ClearTextOnFocus = false; ki.ZIndex = 4; ki.Parent = li; Instance.new("UICorner", ki).CornerRadius = UDim.new(0, 6); Ei = Instance.new("UIStroke", ki); Ei.Color = Color3.fromRGB(0, 0, 0); Ei.Thickness = 1.2; Ei.Transparency = 0.2; ki:GetPropertyChangedSignal("Text"):Connect(function() local Di = ki.Text:gsub("%D", ""); if Di ~= ki.Text then ki.Text = Di; end; end); ki.FocusLost:Connect(function() local Di = tonumber(ki.Text); if Di then local Xs = bi.Mode == "PC" and 150000 or 100000; local cs = math.clamp(Di, 10000, Xs); ki.Text = tostring(cs); Qi(cs); else ki.Text = tostring(bi.Power); end; Ci(); end); si = Instance.new("TextLabel"); si.Size = UDim2.new(0.8, 0, 0, 20); si.Position = UDim2.new(0.1, 0, 0, 135); si.BackgroundTransparency = 1; si.Text = "KEYBIND"; si.TextColor3 = zi; si.TextTransparency = 0.25; si.TextSize = 10; si.Font = Enum.Font.Gotham; si.TextXAlignment = Enum.TextXAlignment.Left; si.Parent = ui; si.Visible = false; gi = Instance.new("TextButton"); gi.Size = UDim2.new(0, 30, 0, 24); gi.Position = UDim2.new(1,- 34, 0, 8); gi.BackgroundColor3 = Color3.fromRGB(9, 24, 52); gi.BackgroundTransparency = 0.4; gi.AutoButtonColor = false; gi.Font = Enum.Font.GothamBold; gi.Text = "5"; gi.TextColor3 = zi; gi.TextSize = 10; gi.ZIndex = 4; gi.Parent = li; Instance.new("UICorner", gi).CornerRadius = UDim.new(0, 6); si = Instance.new("UIStroke", gi); si.Color = Color3.fromRGB(0, 0, 0); si.Thickness = 1.2; si.Transparency = 0.2; Oi = Instance.new("TextButton"); Oi.AnchorPoint = Vector2.new(0, 0); Oi.Size = UDim2.new(1,- 150, 0, 32); Oi.Position = UDim2.new(0, 112, 0, 4); Oi.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Oi.BackgroundTransparency = 0.1; Oi.AutoButtonColor = false; Oi.Font = Enum.Font.GothamBold; Oi.Text = "ACTIVATE BYPASS"; Oi.TextColor3 = zi; Oi.TextSize = 9; Oi.Parent = li; Instance.new("UICorner", Oi).CornerRadius = UDim.new(0, 8); local Di = Instance.new("UIStroke", Oi); Di.Color = Color3.fromRGB(0, 0, 0); Di.Thickness = 1.2; Di.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; local Xs = Instance.new("UIGradient"); Xs.Color = ColorSequence.new(Color3.fromRGB(36, 108, 174), Color3.fromRGB(18, 48, 92)); Xs.Rotation = 90; Xs.Parent = Oi; Xs.Enabled = false; local cs = Instance.new("UIScale", Oi); cs.Scale = 1; li = Instance.new("Frame"); li.Size = UDim2.new(1,- 44, 0, 24); li.Position = UDim2.new(0, 22, 0, 118); li.BackgroundColor3 = Color3.fromRGB(12, 34, 70); li.BackgroundTransparency = 0.4; li.Parent = ui; Instance.new("UICorner", li).CornerRadius = UDim.new(0, 8); Ei = Instance.new("UIStroke", li); Ei.Color = Color3.fromRGB(38, 94, 145); Ei.Transparency = 0.3; ni = Instance.new("TextButton"); ni.Size = UDim2.new(0, 28, 0, 14); ni.Position = UDim2.new(1,- 38, 0.5,- 7); ni.BackgroundColor3 = Color3.fromRGB(12, 34, 70); ni.BackgroundTransparency = 0.4; ni.AutoButtonColor = false; ni.Text = ""; ni.Parent = li; Instance.new("UICorner", ni).CornerRadius = UDim.new(1, 0); local Ei = Instance.new("UIStroke", ni); Ei.Color = Color3.fromRGB(0, 0, 0); Ei.Thickness = 1.2; local ui = Instance.new("Frame"); ui.Size = UDim2.new(0, 10, 0, 10); ui.Position = UDim2.new(0, 2, 0.5,- 5); ui.BackgroundColor3 = Color3.fromRGB(85, 190, 245); ui.BorderSizePixel = 0; ui.Parent = ni; Instance.new("UICorner", ui).CornerRadius = UDim.new(1, 0); local is = Instance.new("TextLabel"); is.Size = UDim2.new(0.5, 0, 1, 0); is.Position = UDim2.new(0, 10, 0, 0); is.BackgroundTransparency = 1; is.Font = Enum.Font.GothamBold; is.Text = "Auto On Steal"; is.TextColor3 = Si; is.TextSize = 9; is.TextXAlignment = Enum.TextXAlignment.Left; is.TextYAlignment = Enum.TextYAlignment.Center; is.Parent = li; yi = function() local li = bi.Mode == "PC"; ji.BackgroundColor3 = li and(Color3.fromRGB(45, 140, 220)) or(Color3.fromRGB(5, 16, 38)); ji.TextColor3 = li and zi or(Color3.fromRGB(115, 190, 230)); wi.BackgroundColor3 = li and(Color3.fromRGB(5, 16, 38)) or(Color3.fromRGB(45, 140, 220)); wi.TextColor3 = li and(Color3.fromRGB(115, 190, 230)) or zi; gi.Visible = li; ki.Size = UDim2.new(0, 60, 0, 24); end; local function li(Qs) if Qs ~= "PC" and Qs ~= "Mobile" then return; end; if bi.Mode == Qs then return; end; local hs = Fi; if hs then _i (); end; bi.Mode = Qs; bi.Power = Qs == "PC" and bi.PCPower or bi.MobilePower; ki.Text = tostring(bi.Power); yi(); if hs then xi(); end; Ci(); end; ji.Activated:Connect(function() li("PC"); end); wi.Activated:Connect(function() li("Mobile"); end); yi(); Ui = function() ei.Visible = false; fi.TextColor3 = zi or Si; ei.TextColor3 = zi; pi.TextColor3 = zi or(Color3.fromRGB(20, 50, 100)); Ji.TextColor3 = zi or Si; Oi.TextColor3 = zi; is.TextColor3 = zi or Si; end; Ui(); local Si, fi = false, false; local function ji(wi, ei) wi = wi == true; if Fi == wi then Ks(); return; end; if wi then if not xi() then return; end; Oi.Text = "DEACTIVATE BYPASS"; Oi.TextColor3 = zi; Xs.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 225, 225)), ColorSequenceKeypoint.new(1, Color3.fromRGB(195, 195, 195))}); if ei then X:Create(Oi, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 140, 220)}):Play(); X:Create(Di, TweenInfo.new(0.2), {Color = Color3.fromRGB(160, 225, 255), Thickness = 1.8, Transparency = 0}):Play(); else Oi.BackgroundColor3 = Color3.fromRGB(45, 140, 220); Di.Color = Color3.fromRGB(160, 225, 255); Di.Thickness = 1.8; end; else _i (); Oi.Text = "ACTIVATE BYPASS"; Oi.TextColor3 = zi; Xs.Color = ColorSequence.new(Color3.fromRGB(36, 108, 174), Color3.fromRGB(18, 48, 92)); if ei then X:Create(Oi, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12, 34, 70)}):Play(); X:Create(Di, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 0, 0), Thickness = 1.2, Transparency = 0}):Play(); else Oi.BackgroundColor3 = Color3.fromRGB(12, 34, 70); Di.Color = Color3.fromRGB(0, 0, 0); Di.Thickness = 1.2; end; end; cs.Scale = 0.94; X:Create(cs, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play(); Ks(); Ci(); end; local function zi(wi) local ei, pi, Di, Ks = Wi and(Color3.fromRGB(45, 140, 220)) or(Color3.fromRGB(12, 34, 70)), Wi and(UDim2.new(0, 16, 0.5,- 5)) or(UDim2.new(0, 2, 0.5,- 5)), Wi and(Color3.fromRGB(160, 225, 255)) or(Color3.fromRGB(38, 94, 145)), Wi and 1.6 or 1.2; if wi then X:Create(ni, TweenInfo.new(0.2), {BackgroundColor3 = ei}):Play(); X:Create(ui, TweenInfo.new(0.2), {Position = pi, BackgroundColor3 = Wi and(Color3.fromRGB(45, 45, 45)) or(Color3.fromRGB(85, 190, 245))}):Play(); X:Create(Ei, TweenInfo.new(0.2), {Color = Di, Thickness = Ks}):Play(); else ni.BackgroundColor3 = ei; ui.Position = pi; ui.BackgroundColor3 = Wi and(Color3.fromRGB(45, 45, 45)) or(Color3.fromRGB(85, 190, 245)); Ei.Color = Di; Ei.Thickness = Ks; end; end; local function Ei() if not Hi then return false; end; return Hi:GetAttribute("Stealing") == true; end; local function wi(ei) local pi = Ei(); Si = pi; if Wi and not Zi and pi ~= Fi then ji(pi, ei); end; end; _G.__GhostDuelTrackConn (Hi:GetAttributeChangedSignal("Stealing"):Connect(function() local Ei = Hi:GetAttribute("Stealing"); if Ei == true then Zi = false; end; wi(true); end)); task.spawn(function() while h.Parent do wi(false); task.wait(1); end; end); local Hi = {[Enum.UserInputType.Gamepad1] = true, [Enum.UserInputType.Gamepad2] = true, [Enum.UserInputType.Gamepad3] = true, [Enum.UserInputType.Gamepad4] = true}; local function Ei(ei) local pi = ei.UserInputType; return pi == Enum.UserInputType.Keyboard or pi == Enum.UserInputType.MouseButton3 or Hi[pi] == true; end; local function Hi(ei) if ei.UserInputType == Enum.UserInputType.MouseButton3 then return "Mouse3"; end; return({Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9"})[ei.KeyCode.Name] or ei.KeyCode.Name; end; local function ei(pi) fi = pi; gi.Text = pi and "..." or(Ti and(Hi({UserInputType = Ti.inputType, KeyCode = Ti.keyCode})) or "None"); end; gi.Activated:Connect(function() ei(true); end); local function pi() Zi = true; ji(not Fi, true); Ci(); end; Oi.Activated:Connect(function() pi(); end); Gi.Activated:Connect(function() pi(); end); Oi.MouseEnter:Connect(function() if not Fi then X:Create(Oi, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play(); end; end); Oi.MouseLeave:Connect(function() if not Fi then X:Create(Oi, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(12, 34, 70)}):Play(); end; end); _G.__GhostDuelTrackConn (R.InputBegan:Connect(function(Oi, ui) if fi then if Oi.UserInputType == Enum.UserInputType.MouseButton1 then ei(false); return; end; if Ei(Oi) then Ti = {inputType = Oi.UserInputType, keyCode = Oi.KeyCode}; gi.Text = Hi(Oi); fi = false; Ci(); end; return; end; if ui then return; end; if Ti and Oi.UserInputType == Ti.inputType and Oi.KeyCode == Ti.keyCode then pi(); end; end)); ni.Activated:Connect(function() Wi = not Wi; _G._GhostDuel_BypassAuto = Wi; zi(true); if Wi then Zi = false; wi(true); end; Ci(); end); local Ei, Oi, ni, fi = false; local function ei(pi) local ui, Gi = oi.AbsolutePosition, oi.AbsoluteSize; return pi.X >= ui.X and pi.X <= ui.X + Gi.X and pi.Y >= ui.Y and pi.Y <= ui.Y + 48; end; _G.__GhostDuelTrackConn (R.InputBegan:Connect(function(pi) if pi.UserInputType ~= Enum.UserInputType.MouseButton1 and pi.UserInputType ~= Enum.UserInputType.Touch then return; end; if not oi.Visible or not ei(pi.Position) then return; end; Ei = true; Oi = pi.Position; ni, fi = oi.AbsolutePosition, pi; end)); _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(ei) if not Ei then return; end; if ei.UserInputType ~= Enum.UserInputType.MouseMovement and ei.UserInputType ~= Enum.UserInputType.Touch then return; end; local pi = ei.Position - Oi; local Oi, ei = ni.X + pi.X, ni.Y + pi.Y; oi.Position = UDim2.new(0, Oi, 0, ei); end)); _G.__GhostDuelTrackConn (R.InputEnded:Connect(function(Oi) local ni = fi and fi.UserInputType == Enum.UserInputType.MouseButton1 and Oi.UserInputType == Enum.UserInputType.MouseButton1; if not Ei or Oi ~= fi and not ni then return; end; Ei, fi = false, nil; Ci(); end)); for Oi, Oi in ipairs(h:GetDescendants()) do if Oi:IsA("TextLabel") or(Oi:IsA("TextButton")) or(Oi:IsA("TextBox")) then Oi:SetAttribute("GhostDuelKeepBlackText", true); Oi.TextStrokeColor3 = Color3.fromRGB(0, 0, 0); Oi.TextStrokeTransparency = 0.2; end; end; if Ui then Ui(); end; local Oi = ri(); if Oi then if Oi.visible ~= nil then oi.Visible = Oi.visible; end; if Oi.bypassVersion then bi.Version = Oi.bypassVersion; di(); else bi.Version = "V1"; di(); end; bi.Mode = Oi.mode == "Mobile" and "Mobile" or "PC"; si = tonumber(Oi.power); bi.PCPower = math.clamp(tonumber(Oi.pcPower) or bi.Mode == "PC" and si or 97000, 10000, 150000); bi.MobilePower = math.clamp(tonumber(Oi.mobilePower) or bi.Mode == "Mobile" and si or 72000, 10000, 150000); bi.Power = bi.Mode == "PC" and bi.PCPower or bi.MobilePower; ki.Text = tostring(bi.Power); yi(); if Oi.autoOnSteal ~= nil then Wi = Oi.autoOnSteal == true; _G._GhostDuel_BypassAuto = Wi; zi(false); end; if Oi.keybind and Oi.keybind.inputType and Oi.keybind.keyCode then pcall(function() local si, ni = Enum.UserInputType[Oi.keybind.inputType], Enum.KeyCode[Oi.keybind.keyCode]; if si and ni then Ti = {inputType = si, keyCode = ni}; gi.Text = Hi({UserInputType = si, KeyCode = ni}); end; end); end; if Oi.background then ai = math.clamp(Oi.background, 1, #Li); qi.Image = Li[ai]; _G.__GhostDuelFramePanelBackground (qi, ai, "Bypass"); Yi.Transparency = ai == 1 and 1 or 0.448; vi.Transparency = ai == 1 and 1 or 0.782; Mi.Transparency = ai == 1 and 1 or 0.891; end; if Ui then Ui(); end; if Oi.position and not _G.__GhostDuelGuiPositionsReset then pcall(function() oi.Position = UDim2.new(Oi.position.xScale, Oi.position.xOffset, Oi.position.yScale, Oi.position.yOffset); end); end; Rs(Oi.minimized == true, false); if Oi.manualOverride ~= nil then Zi = Oi.manualOverride; end; if Wi then wi(false); end; else bi.Version = "V1"; bi.Mode = "PC"; bi.PCPower = 97000; bi.MobilePower = 72000; bi.Power = 97000; ki.Text = "97000"; Ji.Text = "V1"; di(); yi(); Ci(); end; ai = 1; qi.Image = Li[ai]; _G.__GhostDuelFramePanelBackground (qi, ai, "Bypass"); Yi.Transparency = ai == 1 and 1 or 0.448; vi.Transparency = ai == 1 and 1 or 0.782; Mi.Transparency = ai == 1 and 1 or 0.891; if Ui then Ui(); end; Ci(); local Hi = 0; oi:GetPropertyChangedSignal("Position"):Connect(function() if Bi.Visible then ti(); end; Hi += 1; local si = Hi; task.delay(0.4, function() if si == Hi then Ci(); end; end); end); _G.GhostDuelBypass = {ResetPosition = function() Ei, fi = false, nil; oi.Position = UDim2.new(0.5,- 160, 0.5,- 80); Ci(); end, GetPower = function() return bi.Power; end, GetKeybind = function() return Ti; end, IsEnabled = function() return Fi; end, IsAutoOnSteal = function() return Wi; end, IsStealing = function() return Si; end, PauseForDrop = function() if bi.DropPaused then return true; end; bi.DropPaused = Fi == true; if bi.DropPaused then _i (true); end; return bi.DropPaused; end, ResumeAfterDrop = function() if not bi.DropPaused then return false; end; bi.DropPaused = false; return xi(); end, GetBackground = function() return ai; end, GetVersion = function() return bi.Version; end, GetMode = function() return bi.Mode; end, GetPosition = function() return {x = oi.Position.X.Offset, y = oi.Position.Y.Offset}; end, SetBackground = function(Hi) ai = math.clamp(Hi, 1, #Li); qi.Image = Li[ai]; _G.__GhostDuelFramePanelBackground (qi, ai, "Bypass"); Yi.Transparency = ai == 1 and 1 or 0.448; vi.Transparency = ai == 1 and 1 or 0.782; Mi.Transparency = ai == 1 and 1 or 0.891; if Ui then Ui(); end; Ci(); end, SetBypass = function(Hi) Zi = true; ji(Hi, true); Ci(); end, SetPower = function(Hi) local Ei = bi.Mode == "PC" and 150000 or 100000; local si = math.clamp(Hi, 10000, Ei); ki.Text = tostring(si); Qi(si); Ci(); end, SetMode = function(Qi) li(Qi); end, SetAutoOnSteal = function(Qi) Wi = Qi == true; _G._GhostDuel_BypassAuto = Wi; zi(true); if Wi then Zi = false; wi(true); end; Ci(); end, SetVisible = function(Qi) if oi then local Hi = Qi and true or false; oi.Visible = Hi; r = Hi; ci(); if not Hi and Bi then Bi.Visible = false; end; Ci(); end; end, SetVersion = function(Qi) if Qi ~= "V1" and Qi ~= "V2" then return; end; Pi(Qi); di(); Ci(); end, SetPosition = function(Qi, Hi) pcall(function() oi.Position = UDim2.new(oi.Position.X.Scale, Qi, oi.Position.Y.Scale, Hi); Ci(); end); end, Stop = function() _i (); end}; if not H.alive then _i (); pcall(function() h:Destroy(); end); return; end; _G.__GhostDuelTrackStopper (function() _i (); pcall(function() if h and h.Parent then h:Destroy(); end; end); _G.GhostDuelBypass = nil; _G._GhostDuelBypassGUILoaded = false; end); function _G.__setBypassAuto (h) pcall(function() Wi = h and true or false; _G._GhostDuel_BypassAuto = Wi; zi(true); Ci(); if Wi then Zi = false; wi(true); end; end); end; pcall(function() if ii and oi and not oi.Visible then oi.Visible = true; Ci(); end; end); end); end);
                                                end;
                                                _G.__openBypassGUI = e;
                                                local function h()
                                                    r = not r;
                                                    ci();
                                                    if r then
                                                        if _G._GhostDuelBypassGUILoaded then
                                                            if _G.GhostDuelBypass and _G.GhostDuelBypass.SetVisible then
                                                                _G.GhostDuelBypass.SetVisible(true);
                                                            end;
                                                            if _G.GhostDuelBypass and _G.GhostDuelBypass.SaveSettings then
                                                                _G.GhostDuelBypass.SaveSettings();
                                                            end;
                                                        else
                                                            e(true);
                                                        end;
                                                    else
                                                        if _G.GhostDuelBypass and _G.GhostDuelBypass.SetVisible then
                                                            _G.GhostDuelBypass.SetVisible(false);
                                                        end;
                                                        if _G.GhostDuelBypass and _G.GhostDuelBypass.SaveSettings then
                                                            _G.GhostDuelBypass.SaveSettings();
                                                        end;
                                                    end;
                                                    if _G.GhostDuelBypass and _G.GhostDuelBypass.SetVisible then
                                                        _G.GhostDuelBypass.SetVisible(r);
                                                    end;
                                                end;
                                                Q.Activated:Connect(function() pcall(function() if _G.GhostDuelBypass and _G.GhostDuelBypass.SetBypass and _G.GhostDuelBypass.IsEnabled then local Q = _G.GhostDuelBypass.IsEnabled() == true; _G.GhostDuelBypass.SetBypass(not Q); if _G.__syncBypassVisual then pcall(_G.__syncBypassVisual); end; end; end); h(); end);
                                                ci();
                                                Z, Ki = _G.__GhostDuelReadSavedPanelVisibility ("GhostDuelBypass_Settings.json");
                                                r = Z and Ki or false;
                                                ci();
                                                if Z then
                                                    e(false);
                                                end;
                                                _G.__GhostDuelReadSavedPanelVisibility = nil;
                                                Ki = Instance.new("Frame", Y);
                                                Ki.Size = UDim2.new(1,- 18, 0, 28);
                                                Ki.Position = UDim2.new(0, 9, 0, 68);
                                                Ki.BackgroundTransparency = 1;
                                                Ki.Visible = true;
                                                Z = Instance.new("TextLabel", Ki);
                                                Z.Size = UDim2.new(1,- 50, 0, 32);
                                                Z.Position = UDim2.new(0, 0, 0, 2);
                                                Z.BackgroundTransparency = 1;
                                                Z.Text = "Toggle UI";
                                                Z.TextColor3 = Color3.fromRGB(40, 80, 150);
                                                Z.TextSize = 10;
                                                Z.Font = Enum.Font.GothamBold;
                                                Z.TextXAlignment = Enum.TextXAlignment.Left;
                                                Z.TextYAlignment = Enum.TextYAlignment.Center;
                                                local Q = Instance.new("TextButton", Ki);
                                                Q.Size = UDim2.new(0, 40, 0, 20);
                                                Q.Position = UDim2.new(1,- 48, 0.5,- 10);
                                                Q.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                Q.BackgroundTransparency = 0.15;
                                                Q.BorderSizePixel = 0;
                                                Q.Text = q["Toggle UI"] and(D(q["Toggle UI"])) or "-";
                                                Q.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                Q.TextSize = 9;
                                                Q.Font = Enum.Font.GothamBold;
                                                Q.AutoButtonColor = false;
                                                Instance.new("UICorner", Q).CornerRadius = UDim.new(0, 4);
                                                Z = Instance.new("UIStroke", Q);
                                                Z.Color = Color3.fromRGB(255, 255, 255);
                                                Z.Thickness = 1;
                                                Z.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                                                u(Q, function() if B then B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.BackgroundTransparency = 1; B.Text = "-"; end; B, j = Q, "Toggle UI"; Q.Text = "..."; Q.BackgroundColor3 = Color3.fromRGB(4, 18, 42); Q.BackgroundTransparency = 0; end);
                                                table.insert(w, Q);
                                                if U["Toggle UI"] == nil then
                                                    U["Toggle UI"] = function()
                                                        Q.Text = q["Toggle UI"] and(D(q["Toggle UI"])) or "-";
                                                        Q.BackgroundColor3 = Color3.fromRGB(30, 30, 38);
                                                        Q.BackgroundTransparency = 0.15;
                                                        Q.TextColor3 = Color3.fromRGB(225, 238, 255);
                                                    end;
                                                end;
                                            end;
                                            local Q, h, H, e, Z = Vi(o.Animations, "ANIMATIONS"), {"Adidas Sports", "Adidas Community", "Adidas Aura", "Wicked Popular", "Elder", "Zombie", "Mage", "Catwalk Glam", "Astronaut", "Wicked \"Dancing Through Life\"", "Werewolf", "Superhero", "Toy", "No Boundaries", "NFL", "Amazon Unboxed", "Vampire", "Ninja", "Robot", "Levitation", "Stylish", "Bubbly", "Cartoon"}, {["Adidas Sports"] = {WalkAnim = 18537392113, RunAnim = 18537384940, JumpAnim = 18537380791, FallAnim = 18537367238, SwimIdle = 18537387180, Swim = 18537389531, Animation1 = 18537376492, Animation2 = 18537371272, ClimbAnim = 18537363391}, ["Adidas Community"] = {WalkAnim = 122150855457006, RunAnim = 82598234841035, JumpAnim = 75290611992385, FallAnim = 98600215928904, SwimIdle = 109346520324160, Swim = 133308483266208, Animation1 = 122257458498464, Animation2 = 102357151005774, ClimbAnim = 88763136693023}, ["Adidas Aura"] = {WalkAnim = 83842218823011, RunAnim = 118320322718866, JumpAnim = 109996626521204, FallAnim = 95603166884636, SwimIdle = 94922130551805, Swim = 134530128383903, Animation1 = 110211186840347, Animation2 = 114191137265065, ClimbAnim = 97824616490448}, ["Wicked Popular"] = {WalkAnim = 92072849924640, RunAnim = 72301599441680, JumpAnim = 104325245285198, FallAnim = 121152442762481, Animation1 = 118832222982049, ClimbAnim = 131326830509784, SwimIdle = 113199415118199, Swim = 99384245425157, Animation2 = 76049494037641}, Elder = {WalkAnim = 10921111375, RunAnim = 10921104374, JumpAnim = 10921107367, FallAnim = 10921105765, SwimIdle = 10921110146, Swim = 10921108971, ClimbAnim = 10921100400, Animation1 = 10921101664, Animation2 = 10921102574}, Zombie = {WalkAnim = 10921355261, RunAnim = 616163682, JumpAnim = 10921351278, FallAnim = 10921350320, SwimIdle = 10921353442, Swim = 10921352344, Animation1 = 10921344533, Animation2 = 10921345304, ClimbAnim = 10921343576}, Mage = {WalkAnim = 10921152678, RunAnim = 10921148209, JumpAnim = 10921149743, FallAnim = 10921148939, SwimIdle = 10921151661, Swim = 10921150788, ClimbAnim = 10921143404, Animation1 = 10921144709, Animation2 = 10921145797}, ["Catwalk Glam"] = {WalkAnim = 109168724482748, RunAnim = 81024476153754, JumpAnim = 116936326516985, FallAnim = 92294537340807, SwimIdle = 98854111361360, Swim = 134591743181628, ClimbAnim = 119377220967554, Animation1 = 133806214992291, Animation2 = 94970088341563}, Astronaut = {WalkAnim = 10921046031, RunAnim = 10921039308, JumpAnim = 10921042494, FallAnim = 10921040576, SwimIdle = 10921045006, Swim = 10921044000, ClimbAnim = 10921032124, Animation1 = 10921034824, Animation2 = 10921036806}, ["Wicked \"Dancing Through Life\""] = {WalkAnim = 73718308412641, RunAnim = 135515454877967, JumpAnim = 78508480717326, FallAnim = 78147885297412, SwimIdle = 129183123083281, Swim = 110657013921774, ClimbAnim = 129447497744818, Animation1 = 92849173543269, Animation2 = 132238900951109}, Werewolf = {WalkAnim = 10921342074, RunAnim = 10921336997, FallAnim = 10921337907, SwimIdle = 10921341319, Swim = 10921340419, ClimbAnim = 10921329322, Animation1 = 10921330408, Animation2 = 10921333667}, Superhero = {WalkAnim = 10921298616, RunAnim = 10921291831, JumpAnim = 10921294559, FallAnim = 10921293373, SwimIdle = 10921297391, Swim = 10921295495, ClimbAnim = 10921286911, Animation1 = 10921288909, Animation2 = 10921290167}, Toy = {WalkAnim = 10921312010, RunAnim = 10921306285, JumpAnim = 10921308158, FallAnim = 10921307241, SwimIdle = 10921310341, Swim = 10921309319, ClimbAnim = 10921300839, Animation1 = 10921301576}, ["No Boundaries"] = {WalkAnim = 18747074203, RunAnim = 18747070484, JumpAnim = 18747069148, FallAnim = 18747062535, SwimIdle = 18747071682, Swim = 18747073181, ClimbAnim = 18747060903, Animation1 = 18747067405, Animation2 = 18747063918}, NFL = {WalkAnim = 110358958299415, RunAnim = 117333533048078, JumpAnim = 119846112151352, FallAnim = 129773241321032, SwimIdle = 79090109939093, Swim = 132697394189921, ClimbAnim = 134630013742019, Animation1 = 92080889861410, Animation2 = 74451233229259}, ["Amazon Unboxed"] = {WalkAnim = 90478085024465, RunAnim = 134824450619865, JumpAnim = 121454505477205, FallAnim = 94788218468396, SwimIdle = 129126268464847, Swim = 105962919001086, ClimbAnim = 121145883950231, Animation1 = 98281136301627}, Vampire = {WalkAnim = 10921326949, RunAnim = 10921320299, JumpAnim = 10921322186, FallAnim = 10921321317, SwimIdle = 10921325443, Swim = 10921324408, ClimbAnim = 10921314188, Animation1 = 10921315373}, Ninja = {RunAnim = 656118852, WalkAnim = 656121766, JumpAnim = 656117878, FallAnim = 656115606, Swim = 656119721, SwimIdle = 656121397, ClimbAnim = 656114359, Idle = {656117400, 656118341, 886742569}}, Robot = {RunAnim = 616091570, WalkAnim = 616095330, JumpAnim = 616090535, FallAnim = 616087089, Swim = 616092998, SwimIdle = 616094091, ClimbAnim = 616086039, Idle = {616088211, 616089559, 885531463}}, Levitation = {RunAnim = 616010382, WalkAnim = 616013216, JumpAnim = 616008936, FallAnim = 616005863, Swim = 616011509, SwimIdle = 616012453, ClimbAnim = 616003713, Idle = {616006778, 616008087, 886862142}}, Stylish = {RunAnim = 616140816, WalkAnim = 616146177, JumpAnim = 616139451, FallAnim = 616134815, Swim = 616143378, SwimIdle = 616144772, ClimbAnim = 616133594, Idle = {616136790, 616138447, 886888594}}, Bubbly = {RunAnim = 910025107, WalkAnim = 910034870, JumpAnim = 910016857, FallAnim = 910001910, Swim = 910028158, SwimIdle = 910030921, ClimbAnim = 909997997, Idle = {910004836, 910009958, 1018536639}}, Cartoon = {RunAnim = 742638842, WalkAnim = 742640026, JumpAnim = 742637942, FallAnim = 742637151, Swim = 742639220, SwimIdle = 742639812, ClimbAnim = 742636889, Idle = {742637544, 742638445, 885477856}}}, {"idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}, {idle1 = "Idle 1", idle2 = "Idle 2", walk = "Walk", run = "Run", jump = "Jump", fall = "Fall", climb = "Climb", swim = "Swim", swimidle = "Swim Idle"};
                                            local function o(r)
                                                if not r then
                                                    return nil;
                                                end;
                                                if type(r) == "number" then
                                                    return "rbxassetid://" .. tostring(r);
                                                end;
                                                if type(r) == "string" then
                                                    local Ki = string.gsub(r, "^%s+", "");
                                                    Ki = string.gsub(Ki, "%s+$", "");
                                                    if Ki == "" then
                                                        return nil;
                                                    end;
                                                    if string.sub(Ki, 1, 11) == "rbxassetid://" then
                                                        return Ki;
                                                    end;
                                                    if string.match(Ki, "^%d+$") then
                                                        return "rbxassetid://" .. Ki;
                                                    end;
                                                    return Ki;
                                                end;
                                                return nil;
                                            end;
                                            local function r(Ki)
                                                local ci = Ki and Ki.Idle;
                                                return {idle1 = o(Ki and(Ki.Animation1 or ci and ci[1])), idle2 = o(Ki and(Ki.Animation2 or ci and ci[2])), walk = o(Ki and(Ki.WalkAnim or Ki.Walk)), run = o(Ki and(Ki.RunAnim or Ki.Run)), jump = o(Ki and(Ki.JumpAnim or Ki.Jump)), fall = o(Ki and(Ki.FallAnim or Ki.Fall)), climb = o(Ki and(Ki.ClimbAnim or Ki.Climb)), swim = o(Ki and(Ki.Swim or Ki.SwimAnim)), swimidle = o(Ki and(Ki.SwimIdle or Ki.SwimIdleAnim))};
                                            end;
                                            local o, Ki = {}, {idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://707897309", run = "rbxassetid://707861613", jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985", climb = "rbxassetid://116936326516985", swim = "rbxassetid://116936326516985", swimidle = "rbxassetid://116936326516985"};
                                            _G.__GhostDuel_Anims = Ki;
                                            local ci, ii = {}, {};
                                            for Qi, Hi in pairs(H) do
                                                p = r(Hi);
                                                for Ei, Ei in ipairs(e) do
                                                    Hi = p[Ei];
                                                    if Hi then
                                                        i = Qi .. " " .. Z[Ei];
                                                        if not ii[i] then
                                                            ii[i] = Hi;
                                                            ci[Hi] = i;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            local function Qi(Hi)
                                                if not Hi then
                                                    return "";
                                                end;
                                                if Hi == "rbxassetid://" then
                                                    return "Custom";
                                                end;
                                                return ci[Hi] or Hi;
                                            end;
                                            local ci = {};
                                            for Hi, Hi in ipairs(e) do
                                                ci[Hi] = {};
                                            end;
                                            for Hi, Ei in ipairs(h) do
                                                Hi = H[Ei];
                                                if Hi then
                                                    a = r(Hi);
                                                    for Hi, Hi in ipairs(e) do
                                                        ii = a[Hi];
                                                        if ii and not table.find(ci[Hi], ii) then
                                                            table.insert(ci[Hi], ii);
                                                        end;
                                                    end;
                                                end;
                                            end;
                                            local function a(Hi, Ei)
                                                local si = ci[Hi];
                                                if not si or not Ei then
                                                    return;
                                                end;
                                                local ci, bi = Ki[Hi], 1;
                                                for Vi, Fi in ipairs(si) do
                                                    if Fi == ci then
                                                        bi = Vi % #si + 1;
                                                        break;
                                                    end;
                                                end;
                                                Ki[Hi] = si[bi];
                                                Ei.Text = Qi(si[bi]);
                                                mi();
                                                if E["Harder Hit Anim"] and saveOriginalAnims then
                                                    si = m.Character;
                                                    if si then
                                                        saveOriginalAnims(si);
                                                        applyAnimPack(si);
                                                    end;
                                                end;
                                            end;
                                            local ci = h[1];
                                            local function Hi(Ei)
                                                local si = H[Ei];
                                                if not si then
                                                    return;
                                                end;
                                                local bi = r(si);
                                                ci = Ei;
                                                Ki.idle1 = bi.idle1 or Ki.idle1;
                                                Ki.idle2 = bi.idle2 or Ki.idle2;
                                                Ki.walk = bi.walk or Ki.walk;
                                                Ki.run = bi.run or Ki.run;
                                                Ki.jump = bi.jump or Ki.jump;
                                                Ki.fall = bi.fall or Ki.fall;
                                                Ki.climb = bi.climb or Ki.climb;
                                                Ki.swim = bi.swim or Ki.swim;
                                                Ki.swimidle = bi.swimidle or Ki.swimidle;
                                                if E["Harder Hit Anim"] and saveOriginalAnims and applyAnimPack then
                                                    bi = m.Character;
                                                    if bi then
                                                        saveOriginalAnims(bi);
                                                        applyAnimPack(bi);
                                                    end;
                                                end;
                                            end;
                                            local function Ei(si)
                                                local bi = H[si];
                                                if not bi then
                                                    return;
                                                end;
                                                local Vi = r(bi);
                                                for r, r in ipairs(e) do
                                                    bi = o[r];
                                                    if bi then
                                                        bi.Text = Qi(Vi[r] or "");
                                                    end;
                                                end;
                                                Hi(si);
                                            end;
                                            Ni(Q, "Animaciones (Master)", "Animaciones");
                                            W.Animaciones = function(r)
                                                if E["Harder Hit Anim"] == r then
                                                    return;
                                                end;
                                                E["Harder Hit Anim"] = r;
                                                if W["Harder Hit Anim"] then
                                                    W["Harder Hit Anim"](r);
                                                end;
                                                if U["Harder Hit Anim"] then
                                                    U["Harder Hit Anim"]();
                                                end;
                                                mi();
                                            end;
                                            local r = Instance.new("TextButton", Q);
                                            r.Size = UDim2.new(1, 0, 0, 34);
                                            r.BackgroundColor3 = Color3.fromRGB(22, 22, 28);
                                            r.BorderSizePixel = 0;
                                            r.Text = "Preset: " .. ci;
                                            r.TextColor3 = Color3.fromRGB(255, 255, 255);
                                            r.TextSize = 11;
                                            r.Font = Enum.Font.GothamBold;
                                            r.AutoButtonColor = false;
                                            Instance.new("UICorner", r).CornerRadius = UDim.new(0, 8);
                                            u(r, function() local u = 1; for Hi, si in ipairs(h) do if si == ci then u = Hi; break; end; end; local Hi = u + 1; u = h[if Hi > #h then 1 else Hi]; r.Text = "Preset: " .. u; Ei(u); mi(); end);
                                            local r = Instance.new("Frame", Q);
                                            r.Size = UDim2.new(1,- 2, 0, 0);
                                            r.BackgroundTransparency = 1;
                                            r.ClipsDescendants = false;
                                            local u = Instance.new("UIListLayout", r);
                                            u.Padding = UDim.new(0, 6);
                                            u.SortOrder = Enum.SortOrder.LayoutOrder;
                                            u:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() r.Size = UDim2.new(1,- 2, 0, u.AbsoluteContentSize.Y); end);
                                            for u, Hi in ipairs(e) do
                                                u = Instance.new("Frame", r);
                                                u.Size = UDim2.new(1, 0, 0, 30);
                                                u.BackgroundColor3 = Color3.fromRGB(16, 16, 20);
                                                u.BackgroundTransparency = 0.25;
                                                u.BorderSizePixel = 0;
                                                Instance.new("UICorner", u).CornerRadius = UDim.new(0, 8);
                                                ii = Instance.new("TextLabel", u);
                                                ii.Size = UDim2.new(0.48, 0, 1, 0);
                                                ii.Position = UDim2.new(0, 8, 0, 0);
                                                ii.BackgroundTransparency = 1;
                                                ii.Text = Z[Hi];
                                                ii.TextColor3 = Color3.fromRGB(220, 220, 230);
                                                ii.TextSize = 11;
                                                ii.Font = Enum.Font.GothamBold;
                                                ii.TextXAlignment = Enum.TextXAlignment.Left;
                                                local e = Instance.new("TextButton", u);
                                                e.Size = UDim2.new(0.5,- 10, 0, 20);
                                                e.Position = UDim2.new(0.5, 0, 0.5,- 10);
                                                e.BackgroundColor3 = Color3.fromRGB(20, 20, 24);
                                                e.BorderSizePixel = 0;
                                                e.Text = "";
                                                e.TextColor3 = Color3.fromRGB(255, 255, 255);
                                                e.TextSize = 10;
                                                e.Font = Enum.Font.Gotham;
                                                e.AutoButtonColor = false;
                                                Instance.new("UICorner", e).CornerRadius = UDim.new(0, 6);
                                                e.Activated:Connect(function() a(Hi, e); end);
                                                o[Hi] = e;
                                            end;
                                            Z = Instance.new("TextLabel", Q);
                                            Z.Size = UDim2.new(1, 0, 0, 24);
                                            Z.BackgroundTransparency = 1;
                                            Z.Text = "Master: activa/desactiva todas. Toca una animacion para pasar a la siguiente.";
                                            Z.TextColor3 = Color3.fromRGB(140, 180, 220);
                                            Z.TextSize = 10;
                                            Z.Font = Enum.Font.Gotham;
                                            Z.TextXAlignment = Enum.TextXAlignment.Left;
                                            Ei(ci);
                                            if _G.__savedAnimations then
                                                for e, a in pairs(_G.__savedAnimations) do
                                                    if Ki[e] ~= nil then
                                                        Ki[e] = a;
                                                        i = o[e];
                                                        if i then
                                                            i.Text = Qi(a);
                                                        end;
                                                    end;
                                                end;
                                                _G.__savedAnimations = nil;
                                            end;
                                            local o;
                                            _G.__toggleBtn = nil;
                                            local e = Instance.new("UIScale", C);
                                            e.Scale = 1;
                                            local a = E["Toggle UI"] ~= false;
                                            if type(_G.__GhostDuelPanelVisible) == "boolean" then
                                                a = _G.__GhostDuelPanelVisible;
                                            end;
                                            if E["Toggle UI"] ~= a then
                                                E["Toggle UI"] = a;
                                            end;
                                            if U["Toggle UI"] then
                                                U["Toggle UI"]();
                                            end;
                                            local r, u, Ki, Qi = false, false;
                                            function setPanelVisible(Hi)
                                                Hi = Hi == true;
                                                _G.__GhostDuelPanelVisible = Hi;
                                                E["Toggle UI"] = Hi;
                                                if C.Visible == Hi then
                                                    a = Hi;
                                                    if Ki then
                                                        Ki.Visible = not Hi;
                                                    end;
                                                    if Qi then
                                                        Qi.Visible = not Hi;
                                                    end;
                                                    mi();
                                                    return;
                                                end;
                                                if r or u then
                                                    return;
                                                end;
                                                u = true;
                                                task.delay(0.3, function() u = false; end);
                                                a = Hi;
                                                if Hi then
                                                    C.Visible = true;
                                                    if Ki then
                                                        Ki.Visible = false;
                                                    end;
                                                    if Qi then
                                                        Qi.Visible = false;
                                                    end;
                                                    e.Scale = 0.92;
                                                    C.BackgroundTransparency = 0.2;
                                                    X:Create(e, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play();
                                                    X:Create(C, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play();
                                                else
                                                    r = true;
                                                    X:Create(e, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.9}):Play();
                                                    X:Create(C, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.8}):Play();
                                                    task.delay(0.16, function() C.Visible = false; if Ki then Ki.Visible = true; end; if Qi then Qi.Visible = true; end; e.Scale = 1; C.BackgroundTransparency = 0.95; r = false; end);
                                                end;
                                                if U["Toggle UI"] then
                                                    U["Toggle UI"]();
                                                end;
                                                mi();
                                            end;
                                            C.Visible = false;
                                            _G.__setPanelVisible = setPanelVisible;
                                            FeatureToggles["Toggle UI"] = function()
                                                setPanelVisible(not C.Visible);
                                            end;
                                            b = _G._GhostDuel_UI_MenuPos;
                                            if b then
                                                i, Z, Y = Vector2.new, v(C, 0, b.x, 0, b.y);
                                                ii = i(Z, Y);
                                                C.Position = UDim2.new(0, ii.X, 0, ii.Y);
                                            else
                                                C.Position = UDim2.new(1,- F - 20, 0.5,- L / 2);
                                            end;
                                            C.Visible = false;
                                            E["Toggle UI"] = a;
                                            _G.__GhostDuelPanelVisible = a;
                                            if Ki then
                                                Q = not a;
                                                Ki.Visible = Q;
                                            end;
                                            if Qi then
                                                p = not a;
                                                Qi.Visible = p;
                                            end;
                                            (function() _G.__GhostDuelModernGuiActive = true; local i = V:FindFirstChild("MainThemesPanel"); if i then i:Destroy(); end; if T then T.Parent = V; end; if l then l.Parent = V; end; for Q, Q in ipairs(C:GetChildren()) do if Q ~= e then Q:Destroy(); end; end; if e then e.Scale = 1; end; if o then o:Destroy(); o = nil; _G.__toggleBtn = nil; end; if Ki then pcall(function() Ki:Destroy(); end); Ki, Qi = nil, nil; end; C.Name = "GhostDuelModernPanel"; local Q, b = {headerH = A and 50 or 62, pageGap = A and 4 or 6, sectionH = A and 24 or 28, inputH = A and 30 or 36, toggleH = A and 30 or 38, toggleBindH = A and 40 or 50, actionH = A and 34 or 42, textSize = A and 9 or 11, categoryH = A and 28 or 34}, workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or s; local s, F = A and(math.clamp(math.floor(b.X * 0.48), 210, 290)) or 400, A and(math.clamp(math.floor(b.Y * 0.62), 250, 390)) or 560; C.Size = UDim2.new(0, s, 0, F); F = _G._GhostDuel_UI_MenuPos; if F and F.x ~= nil and F.y ~= nil then C.Position = UDim2.new(F.xs or 0, F.x, F.ys or 0, F.y); else C.Position = UDim2.new(0, 6, 0, 54); end; C.BackgroundTransparency = 1; C.BorderSizePixel = 0; C.ClipsDescendants = false; C.Visible = a; local L = {bg = Color3.fromRGB(9, 24, 52), bgDark = Color3.fromRGB(5, 16, 38), row = Color3.fromRGB(12, 34, 70), accent = Color3.fromRGB(135, 220, 255), accentDim = Color3.fromRGB(36, 108, 174), text = Color3.fromRGB(125, 215, 255), textDim = Color3.fromRGB(90, 180, 230), textMuted = Color3.fromRGB(55, 130, 190), divider = Color3.fromRGB(38, 94, 145)}; local function o(e, a) local Z = Instance.new("UICorner"); Z.CornerRadius = UDim.new(0, a or 10); Z.Parent = e; return Z; end; local function e(a, Z, p) local r = Instance.new("UIStroke"); r.Color = Z or L.divider; r.Thickness = p or 1; r.Parent = a; return r; end; local a = setmetatable({}, {__mode = "k"}); local function Z(p, r, Y, u, Ki) if not p or not p.Parent then return nil; end; local ii = a[p]; if ii then pcall(function() ii:Cancel(); end); end; local ii = X:Create(p, TweenInfo.new(Y or 0.16, u or Enum.EasingStyle.Quart, Ki or Enum.EasingDirection.Out), r); a[p] = ii; ii:Play(); return ii; end; local function a(p, r) local Y, u, Ki, ii = false; p.Active = true; _G.__GhostDuelGuiPositionResetters [r.Name] = function() Y, u, Ki, ii = false, nil, nil, nil; r.Position = UDim2.fromOffset(6, 54); if r == C then _G._GhostDuel_UI_MenuPos = nil; else _G._GhostDuel_UI_ModernMiniPos = nil; end; end; p.InputBegan:Connect(function(Qi) if Qi.UserInputType == Enum.UserInputType.MouseButton1 or Qi.UserInputType == Enum.UserInputType.Touch then if Y then return; end; u, Y = Qi, true; Ki = Qi.Position; ii = r.Position; Qi.Changed:Connect(function() if Qi.UserInputState == Enum.UserInputState.End then Y = false; if r == C then _G._GhostDuel_UI_MenuPos = {x = r.Position.X.Offset, y = r.Position.Y.Offset, xs = r.Position.X.Scale, ys = r.Position.Y.Scale}; pcall(mi); elseif r.Name == "GhostDuelRestoreButton" then _G._GhostDuel_UI_ModernMiniPos = {x = r.Position.X.Offset, y = r.Position.Y.Offset}; pcall(mi); end; end; end); end; end); p.InputChanged:Connect(function(p) local Qi = Y and u.UserInputType ~= Enum.UserInputType.Touch and p.UserInputType == Enum.UserInputType.MouseMovement; if Qi then u = p; end; end); _G.__GhostDuelTrackConn (R.InputChanged:Connect(function(p) if Y and p == u then local Y = p.Position - Ki; v(r, ii.X.Scale, ii.X.Offset + Y.X, ii.Y.Scale, ii.Y.Offset + Y.Y); end; end)); end; local p = Instance.new("Frame"); p.Name = "Inner"; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundColor3 = L.bgDark; p.BackgroundTransparency = 0.18; p.BorderSizePixel = 0; p.Parent = C; o(p, 24); b = Instance.new("ImageLabel"); b.Name = "GhostDuelBackground"; b.Size = UDim2.fromScale(1, 1); b.Position = UDim2.fromScale(0, 0); b.BackgroundTransparency = 1; b.Image = hi[Ai]; b.ImageTransparency = 0.28; b.ScaleType = Enum.ScaleType.Crop; b.ZIndex = 0; b.Parent = p; o(b, 24); local r, Y, u, Ki = e(p, Color3.fromRGB(45, 45, 45), 1.5), {["GUI 1"] = true}, {["GUI 1"] = 1}, "GUI 1"; _G.__GhostDuelGuiTheme = Ki; local ii; local function Qi(hi) local Ai = u[hi] or 1; pcall(function() if _G.GhostDuelLagger and _G.GhostDuelLagger.SetBackground then _G.GhostDuelLagger.SetBackground(Ai); end; end); pcall(function() if _G.GhostDuelBypass and _G.GhostDuelBypass.SetBackground then _G.GhostDuelBypass.SetBackground(Ai); end; end); end; _G.__GhostDuelAddUnifiedPanelShade (p, 24, 1); (function(u) u = if not Y[u] then "GUI 1" else u; Ki = u; _G.__GhostDuelGuiTheme = u; if _G.__GhostDuelApplyTheme then _G.__GhostDuelApplyTheme (); end; p.BackgroundColor3 = L.bgDark; p.BackgroundTransparency = 0.18; local Y = p:FindFirstChild("UnifiedBackgroundShade"); if Y then Y.Visible = false; end; r.Transparency = 1; Qi(u); if _G.__GhostDuelApplyAutoStealBarTheme then pcall(_G.__GhostDuelApplyAutoStealBarTheme, u); end; if _G.__GhostDuelRefreshESPTheme then pcall(_G.__GhostDuelRefreshESPTheme, _G.__GhostDuelThemeAccent, Color3.fromRGB(0, 0, 0)); end; if _G.__refreshSpeedBillboards then pcall(_G.__refreshSpeedBillboards); end; if ii then ii(); end; end)(Ki); F = Instance.new("Frame"); F.Name = "HeaderFrame"; F.Size = UDim2.new(1, 0, 0, Q.headerH); F.BackgroundTransparency = 1; F.ZIndex = 10; F.Parent = p; a(F, C); i = Instance.new("Frame"); i.Name = "HeaderStats"; i.Position = UDim2.new(0, 14, 0, 8); i.Size = UDim2.new(0, 78, 0, 40); i.BackgroundColor3 = L.bgDark; i.BackgroundTransparency = 0.35; i.BorderSizePixel = 0; i.ZIndex = 12; i.Parent = F; i.Visible = false; o(i, 8); e(i, Color3.fromRGB(45, 45, 45), 1); if T then T.Parent = i; T.Position = UDim2.new(0, 7, 0, 3); T.Size = UDim2.new(1,- 14, 0, 16); T.BackgroundTransparency = 1; T.TextColor3 = L.text; T.TextSize = 9; T.Font = Enum.Font.GothamBold; T.TextXAlignment = Enum.TextXAlignment.Left; T.TextTransparency = 0; T.Visible = false; T.ZIndex = 13; end; if l then l.Parent = i; l.Position = UDim2.new(0, 7, 0, 20); l.Size = UDim2.new(1,- 14, 0, 16); l.BackgroundTransparency = 1; l.TextColor3 = L.textDim; l.TextSize = 9; l.Font = Enum.Font.GothamBold; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextTransparency = 0; l.Visible = false; l.ZIndex = 13; end; local T = Instance.new("ImageLabel"); T.Name = "UserAvatar"; T.Size = UDim2.fromOffset(A and 32 or 38, A and 32 or 38); T.Position = UDim2.new(0, 14, 0.5, A and- 16 or- 19); T.BackgroundColor3 = Color3.fromRGB(24, 24, 24); T.BackgroundTransparency = 0.15; T.BorderSizePixel = 0; T.Image = "rbxthumb://type=AvatarBust&id=" .. tostring(m.UserId) .. "&w=150&h=150"; T.ScaleType = Enum.ScaleType.Crop; T.ZIndex = 11; T.Parent = F; o(T, 999); task.spawn(function() local l, r = pcall(function() return K:GetUserThumbnailAsync(m.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size150x150); end); if l and r and T.Parent then T.Image = r; end; end); b = Instance.new("Frame"); b.Name = "GhostDuelTitleBackground"; b.Size = UDim2.fromOffset(A and 118 or 136, 28); b.Position = UDim2.new(0, A and 52 or 60, 0, (Q.headerH - 28) / 2); b.BackgroundColor3 = L.bgDark; b.BackgroundTransparency = 0.08; b.BorderSizePixel = 0; b.ZIndex = 19; b.Parent = p; o(b, 8); e(b, L.accentDim, 1); i = Instance.new("TextLabel"); i.Name = "HubTitle"; i:SetAttribute("GhostDuelKeepBlackText", true); i.AnchorPoint = Vector2.new(0, 0); i.Position = UDim2.new(0, 0, 0, 0); i.Size = UDim2.new(1, 0, 1, 0); i.BackgroundTransparency = 1; i.BorderSizePixel = 0; i.Text = "GhostDuel"; i.TextColor3 = L.accent; i.TextTransparency = 0; i.TextStrokeTransparency = 1; i.TextSize = A and 13 or 15; i.Font = Enum.Font.GothamBold; i.TextXAlignment = Enum.TextXAlignment.Center; i.TextYAlignment = Enum.TextYAlignment.Center; i.Visible = true; i.ZIndex = 20; i.Parent = b; s = Instance.new("TextButton"); s.Size = UDim2.new(0, 28, 0, 28); s.Position = UDim2.new(1,- 38, 0, 8); s.BackgroundColor3 = L.bgDark; s.BorderSizePixel = 0; s.Text = "-"; s.TextColor3 = L.textMuted; s.Font = Enum.Font.GothamBlack; s.TextSize = 22; s.ZIndex = 12; s.Parent = F; o(s, 7); e(s, Color3.fromRGB(45, 45, 45), 1); b = Instance.new("Frame"); b.Position = UDim2.new(0, 14, 0, Q.headerH); b.Size = UDim2.new(1,- 28, 0, 1); b.BackgroundColor3 = L.accent; b.BackgroundTransparency = 0.7; b.BorderSizePixel = 0; b.ZIndex = 9; b.Parent = p; b = Instance.new("Frame"); b.Name = "LeftPanel"; b.Size = UDim2.new(0, 85, 1,- 78); b.Position = UDim2.new(1,- 85, 0, 68); b.BackgroundColor3 = L.bgDark; b.BackgroundTransparency = 0.5; b.BorderSizePixel = 0; b.ZIndex = 5; b.Parent = p; o(b, 12); b.Visible = false; local K = Instance.new("Frame"); K.Size = UDim2.new(1,- 16, 0, Q.categoryH + 8); K.Position = UDim2.new(0, 8, 1,- (Q.categoryH + 12)); K.BackgroundColor3 = L.bgDark; K.BackgroundTransparency = 0.18; K.BorderSizePixel = 0; K.ZIndex = 12; K.Parent = p; o(K, 11); e(K, L.divider, 1); F = Instance.new("UIListLayout", K); F.SortOrder = Enum.SortOrder.LayoutOrder; F.FillDirection = Enum.FillDirection.Horizontal; F.HorizontalAlignment = Enum.HorizontalAlignment.Center; F.VerticalAlignment = Enum.VerticalAlignment.Center; F.Padding = UDim.new(0, A and 2 or 4); b = Instance.new("UIPadding", K); b.PaddingLeft = UDim.new(0, 4); b.PaddingRight = UDim.new(0, 4); b.PaddingTop = UDim.new(0, 4); b.PaddingBottom = UDim.new(0, 4); local T = Instance.new("Frame"); T.Name = "ContentFrame"; T.Size = UDim2.new(1,- 12, 1,- (Q.headerH + Q.categoryH + 24)); T.Position = UDim2.new(0, 6, 0, Q.headerH + 6); T.BackgroundTransparency = 1; T.ClipsDescendants = true; T.ZIndex = 4; T.Parent = p; local function l(r) r:SetAttribute("GhostDuelKeepBlackText", true); r.TextStrokeTransparency = 1; return r; end; for r, r in ipairs(p:GetDescendants()) do if r:IsA("TextLabel") or(r:IsA("TextButton")) or(r:IsA("TextBox")) then l(r); end; end; s.TextColor3 = L.textMuted; local p = {}; i.TextColor3 = L.accent; i.TextTransparency = 0; local function r(Y) local u = Instance.new("ScrollingFrame"); u.Name = Y .. "Page"; u.Size = UDim2.new(1, 0, 1, 0); u.BackgroundTransparency = 1; u.BorderSizePixel = 0; u.ScrollBarThickness = 2; u.ScrollBarImageColor3 = L.accent; u.ScrollBarImageTransparency = 0.28; u.ElasticBehavior = Enum.ElasticBehavior.Always; u.ScrollingDirection = Enum.ScrollingDirection.Y; u.AutomaticCanvasSize = Enum.AutomaticSize.Y; u.CanvasSize = UDim2.new(0, 0, 0, 0); u.Visible = Y == "Movement"; u.ZIndex = 5; u.Parent = T; local T = Instance.new("UIScale"); T.Name = "PageTransitionScale"; T.Scale = 1; T.Parent = u; p[Y] = T; Y = Instance.new("UIListLayout", u); Y.SortOrder = Enum.SortOrder.LayoutOrder; Y.Padding = UDim.new(0, Q.pageGap); T = Instance.new("UIPadding", u); T.PaddingLeft = UDim.new(0, 4); T.PaddingRight = UDim.new(0, 4); T.PaddingTop = UDim.new(0, A and 4 or 6); T.PaddingBottom = UDim.new(0, A and 4 or 6); return u; end; local T = {Movement = r("Movement"), Combat = r("Combat"), Visual = r("Visual"), Animations = r("Animations"), Keybinds = r("Keybinds")}; local function Y(u, Ki) if E[u] == true == Ki then return; end; local Qi = FeatureToggles[u]; if Qi then pcall(Qi); end; if E[u] ~= Ki then E[u] = Ki; Qi = W[u]; if Qi then pcall(Qi, Ki); end; end; Qi = U[u]; if Qi then pcall(Qi); end; pcall(mi); end; local function u(Ki, Qi) if B then B.Text = "-"; end; B, j = Ki, Qi; Ki.Text = "..."; end; local function Ki(Qi, hi, Ai) local Hi = Instance.new("Frame"); Hi.Size = UDim2.new(1, 0, 0, Q.sectionH); Hi.BackgroundColor3 = L.bgDark; Hi.BackgroundTransparency = 0.28; Hi.BorderSizePixel = 0; Hi.LayoutOrder = Ai; Hi.Parent = Qi; o(Hi, 8); e(Hi, L.divider, 1); Qi = Instance.new("Frame"); Qi.Name = "SectionAccent"; Qi.Size = UDim2.new(0, 3, 0, A and 12 or 16); Qi.Position = UDim2.new(0, 6, 0.5, A and- 6 or- 8); Qi.BackgroundColor3 = L.accent; Qi.BackgroundTransparency = 0.2; Qi.BorderSizePixel = 0; Qi.Parent = Hi; o(Qi, 2); Qi = l(Instance.new("TextLabel")); Qi.Size = UDim2.new(0.58,- 16, 1, 0); Qi.Position = UDim2.new(0, 15, 0, 0); Qi.BackgroundTransparency = 1; Qi.Text = hi; Qi.TextColor3 = L.textDim; Qi.TextSize = A and 8 or 10; Qi.Font = Enum.Font.GothamBold; Qi.TextXAlignment = Enum.TextXAlignment.Left; Qi.Parent = Hi; hi = Instance.new("Frame"); hi.Name = "SectionLine"; hi.Size = UDim2.new(0.42,- 14, 0, 1); hi.Position = UDim2.new(0.58, 4, 0.5, 0); hi.BackgroundColor3 = L.textMuted; hi.BackgroundTransparency = 0.35; hi.BorderSizePixel = 0; hi.Parent = Hi; end; local function Qi(hi, Ai, Hi) local Ei = l(Instance.new("TextButton")); Ei.Name = "ModeKeybind"; Ei.Size = UDim2.fromOffset(A and 38 or 44, A and 16 or 20); Ei.Position = Hi; Ei.BackgroundColor3 = L.accentDim; Ei.BackgroundTransparency = 0.25; Ei.BorderSizePixel = 0; Ei.TextColor3 = L.text; Ei.TextSize = A and 8 or 9; Ei.Font = Enum.Font.GothamBold; Ei.Text = q[Ai] and(D(q[Ai])) or "-"; Ei.ZIndex = 8; Ei.Parent = hi; o(Ei, 5); e(Ei, Color3.fromRGB(55, 55, 60), 1); Ei.MouseButton1Click:Connect(function() u(Ei, Ai); end); table.insert(w, Ei); local hi = U[Ai]; U[Ai] = function() if hi then pcall(hi); end; local hi = q[Ai]; Ei.Text = hi and(D(hi)) or "-"; Ei.BackgroundColor3 = L.accentDim; Ei.BackgroundTransparency = 0.25; Ei.TextColor3 = L.text; end; return Ei; end; local function hi(Ai, Hi, Ei, si, bi, Vi) local Fi = Instance.new("Frame"); Fi.Size = UDim2.new(1, 0, 0, Q.inputH); Fi.BackgroundColor3 = L.row; Fi.BackgroundTransparency = 0.5; Fi.BorderSizePixel = 0; Fi.LayoutOrder = si; Fi.Parent = Ai; o(Fi, 10); e(Fi, L.divider, 1); Ai = l(Instance.new("TextLabel")); Ai.Size = Vi and(UDim2.new(1, A and- 116 or- 142, 1, 0)) or(UDim2.new(0.65, 0, 1, 0)); Ai.Position = UDim2.new(0, A and 8 or 12, 0, 0); Ai.BackgroundTransparency = 1; Ai.Text = Hi; Ai.TextColor3 = L.text; Ai.TextSize = Q.textSize; Ai.Font = Enum.Font.GothamBold; Ai.TextXAlignment = Enum.TextXAlignment.Left; Ai.Parent = Fi; if Vi then Qi(Fi, Vi, UDim2.new(1, A and- 94 or- 116, 0.5, A and- 8 or- 10)); end; Hi = Instance.new("Frame"); Hi.Size = UDim2.new(0, A and 44 or 54, 0, A and 18 or 22); Hi.Position = UDim2.new(1, A and- 51 or- 64, 0.5, A and- 9 or- 11); Hi.BackgroundColor3 = L.row; Hi.BackgroundTransparency = 0.15; Hi.BorderSizePixel = 0; Hi.Parent = Fi; o(Hi, 6); e(Hi, Color3.fromRGB(55, 55, 60), 1); local Ai = l(Instance.new("TextBox")); Ai.Size = UDim2.new(1, 0, 1, 0); Ai.BackgroundTransparency = 1; Ai.Text = tostring(Ei); Ai.TextColor3 = L.text; Ai.TextSize = A and 9 or 11; Ai.Font = Enum.Font.GothamBold; Ai.ClearTextOnFocus = false; Ai.Parent = Hi; Ai.FocusLost:Connect(function() local Hi = tonumber(Ai.Text); if Hi then bi(Hi); Ai.Text = tostring(Hi); else Ai.Text = tostring(Ei); end; end); end; local function Ai(Hi, Ei, si) local bi = Instance.new("Frame"); bi.Name = "CustomSpeed_" .. Ei.name; bi.Size = UDim2.new(1, 0, 0, 58); bi.BackgroundColor3 = L.row; bi.BackgroundTransparency = 0.5; bi.BorderSizePixel = 0; bi.LayoutOrder = si; bi.Parent = Hi; o(bi, 10); e(bi, L.divider, 1); local si = Instance.new("Frame"); si.Size = UDim2.new(0, 3, 0, 36); si.Position = UDim2.new(0, 4, 0.5,- 18); si.BackgroundColor3 = L.accent; si.BorderSizePixel = 0; si.Parent = bi; o(si, 2); Hi = l(Instance.new("TextLabel")); Hi.Size = UDim2.new(0, 126, 0, 20); Hi.Position = UDim2.new(0, 12, 0, 4); Hi.BackgroundColor3 = L.accent; Hi.BackgroundTransparency = 1; Hi.BorderSizePixel = 0; Hi.Text = Ei.name; Hi.TextColor3 = L.text; Hi.TextSize = 11; Hi.Font = Enum.Font.GothamBold; Hi.TextXAlignment = Enum.TextXAlignment.Left; Hi.Parent = bi; local Vi = "SelectCustomMode_" .. Ei.name; Qi(bi, Vi, UDim2.new(0, 12, 0, 29)); local function Qi(Fi, Ni, Pi, ki) local xi = l(Instance.new("TextLabel")); xi.Size = UDim2.fromOffset(54, 14); xi.Position = UDim2.fromOffset(Pi, 5); xi.BackgroundTransparency = 1; xi.Text = Fi; xi.TextColor3 = L.textMuted; xi.TextSize = 8; xi.Font = Enum.Font.GothamBold; xi.TextXAlignment = Enum.TextXAlignment.Left; xi.Parent = bi; local Fi = l(Instance.new("TextBox")); Fi.Size = UDim2.fromOffset(54, 22); Fi.Position = UDim2.fromOffset(Pi, 24); Fi.BackgroundColor3 = L.bgDark; Fi.BorderSizePixel = 0; Fi.Text = tostring(Ni); Fi.TextColor3 = L.text; Fi.TextSize = 10; Fi.Font = Enum.Font.GothamBold; Fi.ClearTextOnFocus = false; Fi.Parent = bi; o(Fi, 5); e(Fi, Color3.fromRGB(55, 55, 60), 1); Fi.FocusLost:Connect(function() local Pi = tonumber(Fi.Text); if not Pi then Fi.Text = tostring(Ni); return; end; Pi = math.clamp(math.floor(Pi + 0.5), 1, 200); Ni = Pi; Fi.Text = tostring(Pi); ki(Pi); end); return Fi; end; Qi("NORMAL", Ei.boost, 158, function(Fi) Ei.boost = Fi; N["CustomBoost_" .. Ei.name] = Fi; mi(); pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end); end); Qi("CARRY", Ei.steal, 224, function(Qi) Ei.steal = Qi; N["CustomSteal_" .. Ei.name] = Qi; mi(); pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end); end); Hi = l(Instance.new("TextButton")); Hi.Size = UDim2.fromOffset(30, 24); Hi.Position = UDim2.new(1,- 40, 0.5,- 12); Hi.BackgroundColor3 = Color3.fromRGB(72, 34, 34); Hi.BorderSizePixel = 0; Hi.Text = "X"; Hi.TextColor3 = Color3.fromRGB(255, 180, 180); Hi.TextSize = 10; Hi.Font = Enum.Font.GothamBold; Hi.Parent = bi; o(Hi, 5); local function Qi() local Fi = _ == Ei.name; bi.BackgroundTransparency = Fi and 0.28 or 0.5; si.Visible = Fi; end; Hi.MouseButton1Click:Connect(function() for Hi = #I, 1,- 1 do if I[Hi] == Ei then table.remove(I, Hi); break; end; end; N["CustomBoost_" .. Ei.name] = nil; N["CustomSteal_" .. Ei.name] = nil; q[Vi] = nil; FeatureToggles[Vi] = nil; U[Vi] = nil; if _ == Ei.name then Ii("Normal"); end; bi:Destroy(); mi(); end); FeatureToggles[Vi] = function() Ii(Ei.name); end; table.insert(_speedCardRefs, {modeName = Ei.name, updateVisual = Qi}); Qi(); return bi; end; local function Qi(Hi, Ei, si) local bi = Instance.new("Frame"); bi.Name = "CustomSpeedForm"; bi.Size = UDim2.new(1, 0, 0, 112); bi.BackgroundColor3 = L.row; bi.BackgroundTransparency = 0.2; bi.BorderSizePixel = 0; bi.LayoutOrder = Ei; bi.Parent = Hi; o(bi, 10); e(bi, L.divider, 1); local function Ei(Vi, Fi, Ni) local Pi = l(Instance.new("TextLabel")); Pi.Size = UDim2.fromOffset(Ni, 14); Pi.Position = UDim2.fromOffset(Fi, 8); Pi.BackgroundTransparency = 1; Pi.Text = Vi; Pi.TextColor3 = L.textMuted; Pi.TextSize = 8; Pi.Font = Enum.Font.GothamBold; Pi.TextXAlignment = Enum.TextXAlignment.Left; Pi.Parent = bi; end; local function Vi(Fi, Ni, Pi) local ki = l(Instance.new("TextBox")); ki.Size = UDim2.fromOffset(Pi, 24); ki.Position = UDim2.fromOffset(Ni, 24); ki.BackgroundColor3 = L.bgDark; ki.BorderSizePixel = 0; ki.Text = Fi; ki.TextColor3 = L.text; ki.TextSize = 10; ki.Font = Enum.Font.GothamBold; ki.ClearTextOnFocus = false; ki.Parent = bi; o(ki, 5); e(ki, Color3.fromRGB(55, 55, 60), 1); return ki; end; Ei("NAME", 12, 150); Ei("NORMAL", 174, 70); Ei("CARRY", 256, 70); local Ei, Fi, Ni, Pi = Vi("Custom " .. tostring(#I + 1), 12, 150), Vi("59", 174, 70), Vi("29", 256, 70), l(Instance.new("TextLabel")); Pi.Size = UDim2.new(1,- 24, 0, 14); Pi.Position = UDim2.new(0, 12, 1,- 20); Pi.BackgroundTransparency = 1; Pi.Text = ""; Pi.TextColor3 = Color3.fromRGB(255, 150, 150); Pi.TextSize = 8; Pi.Font = Enum.Font.GothamBold; Pi.TextXAlignment = Enum.TextXAlignment.Left; Pi.Parent = bi; Hi = l(Instance.new("TextButton")); Hi.Size = UDim2.new(1,- 24, 0, 26); Hi.Position = UDim2.new(0, 12, 0, 62); Hi.BackgroundColor3 = L.accentDim; Hi.BorderSizePixel = 0; Hi.Text = "CREATE CUSTOM SPEED"; Hi.TextColor3 = L.text; Hi.TextSize = 10; Hi.Font = Enum.Font.GothamBold; Hi.Parent = bi; o(Hi, 6); Hi.MouseButton1Click:Connect(function() local Hi, Vi, ki = Ei.Text:match("^%s*(.-)%s*$"), tonumber(Fi.Text), tonumber(Ni.Text); if not Hi or #Hi < 1 then Pi.Text = "Escribe un nombre."; return; end; if Hi:find("[:,=]") then Pi.Text = "El nombre no puede contener : , o =."; return; end; if Hi == "Normal" or Hi == "Lagger" or Hi == "Desync" then Pi.Text = "Ese nombre esta reservado."; return; end; for Ei, Ei in ipairs(I) do if Ei.name == Hi then Pi.Text = "Ese nombre ya existe."; return; end; end; if not Vi or Vi < 1 or Vi > 200 then Pi.Text = "Normal: elige un valor entre 1 y 200."; return; end; if not ki or ki < 1 or ki > 200 then Pi.Text = "Carry: elige un valor entre 1 y 200."; return; end; local Ei = {name = Hi, boost = math.floor(Vi + 0.5), steal = math.floor(ki + 0.5)}; table.insert(I, Ei); N["CustomBoost_" .. Hi] = Ei.boost; N["CustomSteal_" .. Hi] = Ei.steal; mi(); bi:Destroy(); si(Ei); end); return bi; end; local function Hi(Ei, si, bi, Vi, Fi, Ni, Pi, ki) local xi = Instance.new("Frame"); xi:SetAttribute("GhostDuelButtonThemeControl", true); xi.Size = UDim2.new(1, 0, 0, Ni and Q.toggleBindH or Q.toggleH); xi.BackgroundColor3 = L.row; xi.BackgroundTransparency = 0.5; xi.BorderSizePixel = 0; xi.LayoutOrder = Fi; xi.Parent = Ei; o(xi, 10); e(xi, L.divider, 1); local Ei = Instance.new("UIScale", xi); Ei.Scale = 1; local Fi = l(Instance.new("TextLabel")); Fi.Size = UDim2.new(1, A and- 62 or- 72, 0, Ni and(A and 16 or 20) or Q.toggleH); Fi.Position = UDim2.new(0, A and 50 or 58, 0, Ni and(A and 2 or 3) or 0); Fi.BackgroundTransparency = 1; Fi.Text = si; Fi.TextColor3 = L.text; Fi.TextSize = Q.textSize; Fi.Font = Enum.Font.GothamBold; Fi.TextXAlignment = Enum.TextXAlignment.Left; Fi.Parent = xi; local _i = l(Instance.new("TextButton")); _i.Name = "ActiveMarker"; _i.Size = UDim2.fromOffset(A and 34 or 38, A and 18 or 20); _i.Position = UDim2.new(0, A and 8 or 10, 0.5, A and- 9 or- 10); _i.BackgroundColor3 = L.bgDark; _i.BackgroundTransparency = 0.08; _i.BorderSizePixel = 0; _i.Text = ""; _i.TextColor3 = L.bgDark; _i.TextSize = A and 12 or 14; _i.Font = Enum.Font.GothamBold; _i.AutoButtonColor = false; _i.ZIndex = 9; _i.Parent = xi; o(_i, 999); e(_i, L.textDim, 1); local Li = Instance.new("Frame"); Li.Name = "ToggleKnob"; local zi = A and 12 or 14; Li.Size = UDim2.fromOffset(zi, zi); Li.AnchorPoint = Vector2.new(0, 0.5); Li.Position = UDim2.new(0, 3, 0.5, 0); Li.BackgroundColor3 = L.text; Li.BorderSizePixel = 0; Li.ZIndex = 10; Li.Parent = _i; o(Li, 999); local Si = ki or bi; if Ni and Si then local Ni = l(Instance.new("TextButton")); Ni.Size = UDim2.new(0, A and 36 or 42, 0, A and 14 or 17); Ni.Position = UDim2.new(0, A and 8 or 12, 1, A and- 17 or- 21); Ni.BackgroundColor3 = L.accentDim; Ni.BackgroundTransparency = 0.35; Ni.BorderSizePixel = 0; si = q[Si]; Ni.Text = si and(D(si)) or "-"; Ni.TextColor3 = L.text; Ni.TextSize = A and 8 or 9; Ni.Font = Enum.Font.GothamBold; Ni.Parent = xi; o(Ni, 5); Ni.MouseButton1Click:Connect(function() u(Ni, Si); end); table.insert(w, Ni); end; local si, Ni = Vi == true, false; local function Vi(ki) si = ki == true; local ki, Si = si and(Color3.fromRGB(28, 28, 30)) or L.row, si and 0.22 or 0.5; Fi.TextColor3 = L.text; local Fi, gi = si and(UDim2.new(1,- zi - 3, 0.5, 0)) or(UDim2.new(0, 3, 0.5, 0)), si and L.bgDark or L.text; if Ni then Z(xi, {BackgroundColor3 = ki, BackgroundTransparency = Si}, 0.18); Z(_i, {BackgroundColor3 = si and L.accent or L.bgDark, BackgroundTransparency = si and 0.02 or 0.08}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out); Z(Li, {Position = Fi, BackgroundColor3 = gi}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out); else xi.BackgroundColor3 = ki; xi.BackgroundTransparency = Si; _i.BackgroundColor3 = si and L.accent or L.bgDark; _i.BackgroundTransparency = si and 0.02 or 0.08; Li.Position = Fi; Li.BackgroundColor3 = gi; Ni = true; end; end; Vi(si); _i.MouseButton1Click:Connect(function() Ei.Scale = 0.985; Z(Ei, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out); local Ei = not si; Pi(Ei); Vi(bi and E[bi] == true or Ei); end); if bi then local Ei = U[bi]; U[bi] = function() if Ei then pcall(Ei); end; Vi(E[bi] == true); end; end; return Vi, xi; end; local function Ei(si, bi, Vi) local Fi = l(Instance.new("TextButton")); Fi.Size = UDim2.new(0, A and 46 or 56, 0, A and 16 or 20); Fi.Position = UDim2.new(1, A and- 54 or- 68, 0.5, A and- 8 or- 10); Fi.BackgroundColor3 = L.accentDim; Fi.BackgroundTransparency = 0.25; Fi.BorderSizePixel = 0; Fi.Text = bi; Fi.TextColor3 = L.text; Fi.TextSize = A and 8 or 9; Fi.Font = Enum.Font.GothamBold; Fi.ZIndex = 8; Fi.Parent = si; o(Fi, 5); e(Fi, Color3.fromRGB(45, 45, 45), 1); local si = Instance.new("UIScale", Fi); si.Scale = 1; Fi.MouseButton1Click:Connect(function() si.Scale = 0.92; Z(si, {Scale = 1}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out); local si = Vi(); if si then Fi.Text = tostring(si); end; end); return Fi; end; local function si(bi, Vi, Fi, Ni, Pi, ki) Fi = Instance.new("Frame"); Fi:SetAttribute("GhostDuelButtonThemeControl", true); Fi.Size = UDim2.new(1, 0, 0, Q.actionH); Fi.BackgroundColor3 = L.row; Fi.BackgroundTransparency = 0.5; Fi.BorderSizePixel = 0; Fi.LayoutOrder = Ni; Fi.Parent = bi; o(Fi, 10); e(Fi, L.divider, 1); local Ni = Instance.new("UIScale", Fi); Ni.Scale = 1; bi = l(Instance.new(ki == false and "TextLabel" or "TextButton")); bi.Size = UDim2.new(1,- 24, 1, 0); bi.Position = UDim2.new(0, A and 8 or 12, 0, 0); bi.BackgroundTransparency = 1; bi.Text = Vi; bi.TextColor3 = L.text; bi.TextSize = Q.textSize; bi.Font = Enum.Font.GothamBold; bi.TextXAlignment = Enum.TextXAlignment.Left; bi.Parent = Fi; if ki ~= false then bi.Name = "ActionButton"; bi.AutoButtonColor = false; bi.MouseButton1Click:Connect(function() Ni.Scale = 0.985; Z(Ni, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out); Pi(); end); end; return Fi; end; local bi = T.Movement; Ki(bi, "SPEED CONFIGURATION", 0); hi(bi, "Normal Speed", N.NormalBoost, 1, function(Vi) N.NormalBoost = math.max(1, math.floor(Vi)); z = N.NormalBoost; mi(); end, "SelectNormalMode"); hi(bi, "Carry Speed", N.NormalSteal, 2, function(z) N.NormalSteal = math.max(1, math.floor(z)); S = N.NormalSteal; mi(); end, "Carry Speed"); Ki(bi, "LAGGER SPEED", 3); hi(bi, "Lagger Normal", N.LaggerBoost, 4, function(z) N.LaggerBoost = math.max(1, math.floor(z)); g = N.LaggerBoost; mi(); end, "SelectLaggerMode"); hi(bi, "Lagger Carry", N.LaggerSteal, 5, function(z) N.LaggerSteal = math.max(1, math.floor(z)); mi(); end); Ki(bi, "CUSTOM SPEEDS", 6); local z = {}; local function S(g) local Vi = Ai(bi, g, 10 + #z); table.insert(z, Vi); return Vi; end; for z, z in ipairs(I) do S(z); end; b = l(Instance.new("TextButton")); b.Size = UDim2.new(1, 0, 0, 38); b.BackgroundColor3 = L.row; b.BackgroundTransparency = 0.3; b.BorderSizePixel = 0; b.LayoutOrder = 50; b.Text = "+  ADD CUSTOM SPEED"; b.TextColor3 = L.text; b.TextSize = 10; b.Font = Enum.Font.GothamBold; b.Parent = bi; o(b, 10); e(b, L.divider, 1); local I; b.MouseButton1Click:Connect(function() if I and I.Parent then I:Destroy(); I = nil; return; end; I = Qi(bi, 51, function(z) I = nil; S(z); Ii(z.name); end); end); Ki(bi, "CONTROLS", 60); b, i = Hi(bi, "Auto Play", "Autoplay", E.Autoplay, 61, false, function(b) Y("Autoplay", b); end); Ei(i, string.upper(_G.__autoplayMode or "Full"), function() _G.__autoplayMode = _G.__autoplayMode == "Semi" and "Full" or "Semi"; mi(); return string.upper(_G.__autoplayMode); end); Hi(bi, "Auto Carry Speed", "Auto Carry Speed", E["Auto Carry Speed"], 62, false, function(b) Y("Auto Carry Speed", b); end); r, i = Hi(bi, "Carry Mode", "Carry Speed", E["Carry Speed"], 63, false, function(b) Y("Carry Speed", b); end); Ei(i, string.upper(n or "v1"), function() n = n == "v1" and "v2" or "v1"; mi(); return string.upper(n); end); Ki(bi, "MOVEMENT SETTINGS", 70); F, i = Hi(bi, "Infinite Jump", "Inf Jump", E["Inf Jump"], 71, false, function(b) Y("Inf Jump", b); end); Ei(i, string.upper(_G.__GhostDuelInfJumpMode or "hold"), function() _G.__GhostDuelInfJumpMode = (_G.__GhostDuelInfJumpMode or "hold") == "hold" and "manual" or "hold"; if E["Inf Jump"] then if _G.__GhostDuelInfJumpMode == "hold" and startInfJump then pcall(startInfJump); elseif stopInfJump then pcall(stopInfJump); end; end; mi(); return string.upper(_G.__GhostDuelInfJumpMode); end); Hi(bi, "Unwalk", "Unwalk", E.Unwalk, 72, false, function(b) Y("Unwalk", b); end); Ki(bi, "TP DOWN", 73); Hi(bi, "Auto TP Down", "Auto TP Down", E["Auto TP Down"], 75, false, function(b) Y("Auto TP Down", b); end); hi(bi, "Height (studs)", N.AutoTPDownHeight, 76, function(b) N.AutoTPDownHeight = math.clamp(math.floor(b + 0.5), 1, 1000); mi(); end); i = T.Combat; Ki(i, "BAT CONTROLS", 0); Hi(i, "Bat Aimbot", "Aimbot", E.Aimbot, 1, false, function(b) Y("Aimbot", b); end); Hi(i, "Lagger Aimbot", "Lagger Aimbot", E["Lagger Aimbot"], 2, false, function(b) Y("Lagger Aimbot", b); end); Hi(i, "Anti Bat", "Anti Bat", E["Anti Bat"], 3, false, function(b) Y("Anti Bat", b); end); Hi(i, "Ragdoll Counter", "Ragdoll Counter", E["Ragdoll Counter"], 4, false, function(b) Y("Ragdoll Counter", b); end); Ki(i, "RAGDOLL", 5); Hi(i, "Anti Ragdoll", "Anti Ragdoll", E["Anti Ragdoll"], 6, false, function(b) Y("Anti Ragdoll", b); end); Hi(i, "Medusa Counter", "Medusa Counter", E["Medusa Counter"], 7, false, function(b) Y("Medusa Counter", b); end); Hi(i, "Anti Die", "Anti Die", E["Anti Die"], 8, false, function(b) Y("Anti Die", b); end); Ki(i, "TP BAT", 9); local b, b = Hi(i, "TP Bat", "TP Bat", E["TP Bat"], 10, false, function(F) Y("TP Bat", F); end); b.ClipsDescendants = true; local F = l(Instance.new("TextButton")); F.Name = "TPBatConfigToggle"; F.Size = UDim2.new(0, A and 52 or 64, 0, A and 18 or 22); F.Position = UDim2.new(1, A and- 60 or- 76, 0, A and 5 or 7); F.BackgroundColor3 = L.accentDim; F.BackgroundTransparency = 0.2; F.BorderSizePixel = 0; F.Text = ""; F.AutoButtonColor = false; F.ZIndex = 12; F.Parent = b; o(F, 6); e(F, Color3.fromRGB(70, 75, 84), 1); local I = l(Instance.new("TextLabel")); I.Size = UDim2.new(0, 30, 1, 0); I.Position = UDim2.new(0, 5, 0, 0); I.BackgroundTransparency = 1; I.Text = "GUI"; I.TextColor3 = L.text; I.TextSize = 8; I.Font = Enum.Font.GothamBold; I.TextXAlignment = Enum.TextXAlignment.Left; I.ZIndex = 13; I.Parent = F; local z = Instance.new("Frame"); z.Size = UDim2.new(0, 24, 0, 12); z.Position = UDim2.new(1,- 29, 0.5,- 6); z.BackgroundColor3 = Color3.fromRGB(30, 31, 35); z.BorderSizePixel = 0; z.ZIndex = 13; z.Parent = F; o(z, 20); local S = Instance.new("Frame"); S.Size = UDim2.new(0, 8, 0, 8); S.Position = UDim2.new(0, 2, 0.5,- 4); S.BackgroundColor3 = Color3.fromRGB(155, 165, 180); S.BorderSizePixel = 0; S.ZIndex = 14; S.Parent = z; o(S, 20); local g = Instance.new("Frame"); g.Name = "TPBatConfigPanel"; g.Size = UDim2.new(1,- 16, 0, 78); g.Position = UDim2.new(0, 8, 0, A and 42 or 54); g.BackgroundColor3 = L.bgDark; g.BackgroundTransparency = 0.16; g.BorderSizePixel = 0; g.Visible = false; g.ZIndex = 8; g.Parent = b; o(g, 8); e(g, L.divider, 1); local function n(r, Qi) local Ai = l(Instance.new("TextLabel")); Ai.Size = UDim2.new(1,- 100, 0, 34); Ai.Position = UDim2.new(0, 10, 0, Qi); Ai.BackgroundTransparency = 1; Ai.Text = r; Ai.TextColor3 = L.textMuted; Ai.TextSize = 9; Ai.Font = Enum.Font.GothamBold; Ai.TextXAlignment = Enum.TextXAlignment.Left; Ai.ZIndex = 9; Ai.Parent = g; return Ai; end; n("DISTANCIA TP (STUDS)", 2); n("VERSION TP BAT", 40); local r = l(Instance.new("TextBox")); r.Size = UDim2.new(0, 72, 0, 26); r.Position = UDim2.new(1,- 82, 0, 6); r.BackgroundColor3 = L.row; r.BorderSizePixel = 0; r.ClearTextOnFocus = false; r.Text = tostring(_G.__tpBatV2Distance or 8); r.TextColor3 = L.text; r.TextSize = 10; r.Font = Enum.Font.GothamBold; r.TextXAlignment = Enum.TextXAlignment.Center; r.ZIndex = 10; r.Parent = g; o(r, 5); e(r, Color3.fromRGB(70, 85, 105), 1); local Qi = l(Instance.new("TextButton")); Qi.Size = UDim2.new(0, 72, 0, 26); Qi.Position = UDim2.new(1,- 82, 0, 44); Qi.BackgroundColor3 = L.accentDim; Qi.BorderSizePixel = 0; Qi.TextColor3 = L.text; Qi.TextSize = 10; Qi.Font = Enum.Font.GothamBold; Qi.ZIndex = 10; Qi.Parent = g; Qi.Visible = true; o(Qi, 5); e(Qi, Color3.fromRGB(70, 85, 105), 1); local function Ai() _G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1; Qi.Text = "V" .. tostring(_G.__batVersion or 1); Qi.BackgroundColor3 = L.accentDim; r.TextEditable = true; r.Text = tostring(_G.__tpBatV2Distance or 8); r.BackgroundTransparency = 0; r.TextColor3 = L.text; end; _G.__GhostDuelRefreshVisibleTPBatConfig = Ai; Ai(); local bi = false; local function Vi(Fi) bi = Fi == true; g.Visible = bi; b.Size = UDim2.new(1, 0, 0, bi and(A and 124 or 140) or Q.toggleH); F.BackgroundColor3 = bi and L.accent or L.accentDim; z.BackgroundColor3 = bi and L.accent or(Color3.fromRGB(30, 31, 35)); S.BackgroundColor3 = bi and(Color3.fromRGB(245, 248, 255)) or(Color3.fromRGB(155, 165, 180)); S.Position = bi and(UDim2.new(1,- 10, 0.5,- 4)) or(UDim2.new(0, 2, 0.5,- 4)); end; F.MouseButton1Click:Connect(function() Vi(not bi); end); r.FocusLost:Connect(function() _G.GhostDuelAutoBat.SetV2Distance(r.Text); end); Qi.MouseButton1Click:Connect(function() _G.GhostDuelAutoBat.SetVersion(_G.__batVersion == 1 and 2 or 1); Ai(); end); Ki(i, "AUTO STEAL", 15); I, n = Hi(i, "Auto Steal", "auto steal", E["auto steal"], 16, false, function(b) Y("auto steal", b); end); Ei(n, string.upper(k), function() k = k == "v2" and "v1" or "v2"; if E["auto steal"] and W["auto steal"] then pcall(W["auto steal"], false); pcall(W["auto steal"], true); end; mi(); return string.upper(k); end); hi(i, "Steal Radius", P.Radius, 17, function(b) P.Radius = math.clamp(math.floor(b), 10, 150); mi(); end); local b = T.Visual; Ki(b, "VISUAL",- 2); Hi(b, "anti lag", "Anti Lag", E["Anti Lag"],- 1, false, function(F) Y("Anti Lag", F); end); Hi(b, "ESP Players", "ESP Players", E["ESP Players"], 1, false, function(F) Y("ESP Players", F); end); Hi(b, "ESP Line", "Player Tracers", E["Player Tracers"], 2, false, function(F) Y("Player Tracers", F); end); Hi(b, "Optimizer", "Optimizer", E.Optimizer, 3, false, function(F) Y("Optimizer", F); end); Hi(b, "Stretch Rez", "Stretchz Res", E["Stretchz Res"], 4, false, function(F) Y("Stretchz Res", F); end); Ki(b, "FOV", 5); Hi(b, "Custom FOV", "Custom FOV", E["Custom FOV"], 6, false, function(F) Y("Custom FOV", F); end); hi(b, "FOV", N.FOV, 7, function(F) N.FOV = math.clamp(math.floor(F), 30, 120); Y("Custom FOV", true); if W["Custom FOV"] then pcall(W["Custom FOV"], true); end; F = workspace.CurrentCamera; if F then F.FieldOfView = N.FOV; end; mi(); end); Ki(b, "SKY", 8); hi, i = Hi(b, "Sky Themes", "Sky Changer", E["Sky Changer"], 9, false, function(F) Y("Sky Changer", F); end); Ei(i, string.upper(f or "blue"), function() f = if f == "day" then "blue" else if f == "blue" then "night" else "day"; _G.__GhostDuelSkyChangerMode = f; if E["Sky Changer"] then J(f); end; mi(); return string.upper(f); end); Ki(b, "SKIN CHANGER", 10); do local F = {}; F.update, F.row = Hi(b, "Skin Changer", "Skin Changer", E["Skin Changer"], 11, false, function(N) Y("Skin Changer", N); end); F.button = Ei(F.row, x, function() x = x == "V1" and "V2" or(x == "V2" and "V3" or "V1"); mi(); if E["Skin Changer"] then W["Skin Changer"](true); end; return x; end); F.refresh = function() F.update(E["Skin Changer"] == true); F.button.Text = x; end; U["Skin Changer"] = F.refresh; F.refresh(); end; n = {add = function(F, N, I) local P = {}; P.update, P.row = Hi(b, F, N, E[N], I, false, function(F) Y(N, F); end); P.refresh = function() P.update(E[N] == true); end; U[N] = P.refresh; P.refresh(); end}; n.add("Headless", "Headless Visual", 12); n.add("Korblox", "Korblox Visual", 13); Ki(b, "GUI", 14); Hi(b, "Quick Buttons", "Show Buttons", E["Show Buttons"], 16, false, function(F) Y("Show Buttons", F); end); do local F, N = si(b, "Buttons Size", nil, 16.5, function() end, false), l(Instance.new("TextBox")); N.Name = "ButtonsSizeInput"; N.Size = UDim2.fromOffset(64, A and 22 or 26); N.AnchorPoint = Vector2.new(1, 0.5); N.Position = UDim2.new(1,- 10, 0.5, 0); N.BackgroundColor3 = L.accentDim; N.BorderSizePixel = 0; N.TextColor3 = L.text; N.Font = Enum.Font.GothamBold; N.TextSize = 12; N.Text = tostring(_G.__GhostDuelButtonsSize or 1); N.PlaceholderText = "0.5 - 2"; N.ClearTextOnFocus = false; N.ZIndex = 8; N.Parent = F; o(N, 5); N.FocusLost:Connect(function() N.Text = tostring(_G.__GhostDuelSetButtonsSize (N.Text)); end); end; si(b, "reset butons pos.", nil, 17, function() _G.__GhostDuelResetButtonPositions (); if _G.GhostDuelLagger and _G.GhostDuelLagger.ResetPosition then _G.GhostDuelLagger.ResetPosition(); end; if _G.GhostDuelBypass and _G.GhostDuelBypass.ResetPosition then _G.GhostDuelBypass.ResetPosition(); end; end); Hi(b, "Lock Buttons", "Lock Buttons", E["Lock Buttons"], 18, false, function(F) Y("Lock Buttons", F); end); si(b, "Hide GUI Key", "Toggle UI", 19, function() C.Visible = false; end); Ki(b, "PANELS", 20); si(b, "Open Lagger", nil, 21, function() local F = m:FindFirstChild("PlayerGui") and(m.PlayerGui:FindFirstChild("GhostDuelLaggerGUI")); local N = F and(F:FindFirstChild("MainFrame")); if N then F = not N.Visible; if _G.GhostDuelLagger and _G.GhostDuelLagger.SetVisible then pcall(_G.GhostDuelLagger.SetVisible, F); else N.Visible = F; end; elseif _G.__openLaggerGUI then pcall(_G.__openLaggerGUI, true); end; end); si(b, "Open Bypass", nil, 22, function() local b = m:FindFirstChild("PlayerGui") and(m.PlayerGui:FindFirstChild("GhostDuelBypassGUI")); local F = b and(b:FindFirstChild("MainFrame")); if F then b = not F.Visible; if _G.GhostDuelBypass and _G.GhostDuelBypass.SetVisible then pcall(_G.GhostDuelBypass.SetVisible, b); else F.Visible = b; end; elseif _G.__openBypassGUI then pcall(_G.__openBypassGUI, true); end; end); n = T.Animations; Ki(n, "ANIMATION SOURCE", 0); local b = _G.__GhostDuelAnimationPreset; if not b or not H[b] then b = ci or h[1]; end; si = Instance.new("Frame"); si.Size = UDim2.new(1, 0, 0, 42); si.BackgroundColor3 = L.row; si.BackgroundTransparency = 0.5; si.BorderSizePixel = 0; si.LayoutOrder = 1; si.Parent = n; o(si, 10); e(si, L.divider, 1); i = l(Instance.new("TextButton")); i.Size = UDim2.new(0, 42, 1,- 8); i.Position = UDim2.new(0, 4, 0, 4); i.BackgroundColor3 = L.accentDim; i.BackgroundTransparency = 0.2; i.BorderSizePixel = 0; i.Text = "<"; i.TextColor3 = L.text; i.TextSize = 18; i.Font = Enum.Font.GothamBlack; i.Parent = si; o(i, 7); local F = l(Instance.new("TextLabel")); F.Size = UDim2.new(1,- 100, 1, 0); F.Position = UDim2.new(0, 50, 0, 0); F.BackgroundTransparency = 1; F.TextColor3 = L.text; F.TextSize = 10; F.TextWrapped = true; F.Font = Enum.Font.GothamBold; F.Parent = si; local N = l(Instance.new("TextButton")); N.Size = UDim2.new(0, 42, 1,- 8); N.Position = UDim2.new(1,- 46, 0, 4); N.BackgroundColor3 = L.accentDim; N.BackgroundTransparency = 0.2; N.BorderSizePixel = 0; N.Text = ">"; N.TextColor3 = L.text; N.TextSize = 18; N.Font = Enum.Font.GothamBlack; N.Parent = si; o(N, 7); local function I() F.Text = tostring(b); end; local function F(P) local k = 1; for x, z in ipairs(h) do if z == b then k = x; break; end; end; k += P; b = h[if(if k < 1 then #h else k) > #h then 1 else if k < 1 then #h else k]; I(); _G.__GhostDuelAnimationPreset = b; if E.Animaciones then W.Animaciones(true); else Y("Animaciones", true); end; pcall(mi); end; i.MouseButton1Click:Connect(function() F(- 1); end); N.MouseButton1Click:Connect(function() F(1); end); I(); local function h(F) if type(F) == "number" then return "rbxassetid://" .. tostring(F); end; if type(F) == "string" and(string.match(F, "^%d+$")) then return "rbxassetid://" .. F; end; return F; end; local F = _G.__GhostDuelOriginalAnimations; if type(F) ~= "table" then F = setmetatable({}, {__mode = "k"}); _G.__GhostDuelOriginalAnimations = F; end; local function I(P, k, x) x = x or {}; if next(x) == nil then for z, S in pairs(k) do if S then x[z] = S.AnimationId; end; end; end; local z = P:FindFirstChildOfClass("Humanoid"); local P, S = pcall(function() return z and(z:GetAppliedDescription()); end); if P and S then local function P(z, g) local J = tonumber(S[g]); if J and J > 0 and k[z] then x[z] = "rbxassetid://" .. tostring(J); end; end; P("idle1", "IdleAnimation"); P("idle2", "IdleAnimation"); P("walk", "WalkAnimation"); P("run", "RunAnimation"); P("jump", "JumpAnimation"); P("fall", "FallAnimation"); P("climb", "ClimbAnimation"); P("swim", "SwimAnimation"); P("swimidle", "SwimAnimation"); end; return x; end; local function P(k, x) local z = m.Character; local S = z and(z:FindFirstChild("Animate") or(z:WaitForChild("Animate", 3))); if not S then return false; end; local g = {idle1 = S:FindFirstChild("idle") and(S.idle:FindFirstChild("Animation1")), idle2 = S:FindFirstChild("idle") and(S.idle:FindFirstChild("Animation2")), walk = S:FindFirstChild("walk") and(S.walk:FindFirstChild("WalkAnim")), run = S:FindFirstChild("run") and(S.run:FindFirstChild("RunAnim")), jump = S:FindFirstChild("jump") and(S.jump:FindFirstChild("JumpAnim")), fall = S:FindFirstChild("fall") and(S.fall:FindFirstChild("FallAnim")), climb = S:FindFirstChild("climb") and(S.climb:FindFirstChild("ClimbAnim")), swim = S:FindFirstChild("swim") and(S.swim:FindFirstChild("Swim")), swimidle = S:FindFirstChild("swimidle") and(S.swimidle:FindFirstChild("SwimIdle"))}; if x then S = F[z]; if not S then return false; end; for J, f in pairs(S) do if g[J] then g[J].AnimationId = f; end; end; else local S = H[k]; if not S then return false; end; F[z] = I(z, g, F[z]); local H = S.Idle or {}; local F = {idle1 = S.Animation1 or H[1], idle2 = S.Animation2 or H[2], walk = S.WalkAnim, run = S.RunAnim, jump = S.JumpAnim, fall = S.FallAnim, climb = S.ClimbAnim, swim = S.Swim, swimidle = S.SwimIdle}; for H, I in pairs(F) do if g[H] and I then g[H].AnimationId = h(I); end; end; end; x = z:FindFirstChildOfClass("Humanoid"); if x then for h, h in ipairs(x:GetPlayingAnimationTracks()) do pcall(function() h:Stop(0); end); end; end; return true; end; function W.Animaciones(h) E["Harder Hit Anim"] = false; if h then _G.__GhostDuelAnimationPreset = b; pcall(P, b, false); else pcall(P, nil, true); end; if U["Harder Hit Anim"] then pcall(U["Harder Hit Anim"]); end; end; local h, H = Hi(n, "Animaciones", "Animaciones", E.Animaciones, 2, false, function(b) Y("Animaciones", b); end); H.Name = "AnimationsMasterToggle"; H.Visible = true; H.ZIndex = 8; local b = Ei(H, E.Animaciones and "ON" or "OFF", function() Y("Animaciones", not E.Animaciones); return E.Animaciones and "ON" or "OFF"; end); local function H() h(E.Animaciones == true); b.Text = E.Animaciones and "ON" or "OFF"; end; U.Animaciones = H; H(); _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() if not E.Animaciones or not _G.__GhostDuelAnimationPreset then return; end; task.wait(0.75); pcall(P, _G.__GhostDuelAnimationPreset, false); end)); if E.Animaciones and _G.__GhostDuelAnimationPreset then task.defer(function() task.wait(0.5); pcall(P, _G.__GhostDuelAnimationPreset, false); end); end; N = l(Instance.new("TextLabel")); N.Size = UDim2.new(1,- 8, 0, 30); N.BackgroundTransparency = 1; N.LayoutOrder = 4; N.Text = "Usa < y > para aplicar y guardar automaticamente. El toggle permite activar o desactivar."; N.TextColor3 = L.textDim; N.TextSize = 10; N.Font = Enum.Font.Gotham; N.TextWrapped = true; N.TextXAlignment = Enum.TextXAlignment.Left; N.Parent = n; local h, H, b = T.Keybinds, {}, 0; local function F(N, I, P, k) if H[I] then return H[I]; end; b += 1; P = Instance.new("Frame"); P.Name = "Keybind_" .. string.gsub(I, "[^%w_]", "_"); P.Size = UDim2.new(1, 0, 0, A and 36 or 42); P.BackgroundColor3 = L.row; P.BackgroundTransparency = 0.5; P.BorderSizePixel = 0; P.LayoutOrder = b; P.Parent = k or h; o(P, 10); e(P, L.divider, 1); k = l(Instance.new("TextLabel")); k.Size = UDim2.new(1, A and- 108 or- 132, 1, 0); k.Position = UDim2.new(0, A and 8 or 12, 0, 0); k.BackgroundTransparency = 1; k.Text = N; k.TextColor3 = L.text; k.TextSize = Q.textSize; k.Font = Enum.Font.GothamBold; k.TextXAlignment = Enum.TextXAlignment.Left; k.TextTruncate = Enum.TextTruncate.AtEnd; k.Parent = P; local b = l(Instance.new("TextButton")); b.Name = "BindButton"; b.Size = UDim2.fromOffset(A and 82 or 98, A and 24 or 28); b.Position = UDim2.new(1, A and- 90 or- 106, 0.5, A and- 12 or- 14); b.BackgroundColor3 = L.accent; b.BackgroundTransparency = 0.06; b.BorderSizePixel = 0; b.TextColor3 = L.bgDark; b.TextSize = A and 9 or 10; b.Font = Enum.Font.GothamBold; b.AutoButtonColor = false; b.Parent = P; o(b, 7); e(b, L.textDim, 1); local function N() local k = q[I]; b.Text = k and(D(k)) or "BIND"; b.BackgroundColor3 = L.accent; b.TextColor3 = L.bgDark; end; b.MouseButton1Click:Connect(function() u(b, I); end); table.insert(w, b); local b = U[I]; U[I] = function() if b then pcall(b); end; N(); end; H[I] = P; N(); return P; end; Ki(h, "KEYBINDS",- 100); i = {{"Bat Aimbot", "Aimbot"}, {"TP Bat", "TP Bat"}, {"Lagger Aimbot", "Lagger Aimbot"}, {"Anti Bat", "Anti Bat"}, {"Drop Brainrot", "Drop", true}, {"TP Down", "TP Down", true}, {"Insta Reset", "Insta Reset", true}, {"Toggle UI", "Toggle UI"}}; for h, h in ipairs(i) do F(h[1], h[2], h[3] == true); end; local h, H, b = "Movement", {Movement = "MAIN", Combat = "COMBAT", Visual = "VISUALS", Animations = "CONFIG", Keybinds = "KEYBINDS"}, {"Movement", "Combat", "Visual", "Animations", "Keybinds"}; for F, N in ipairs(b) do local b = l(Instance.new("TextButton")); b.Name = N .. "Button"; b.Size = UDim2.new(0.2, A and- 3 or- 5, 0, Q.categoryH); b.BackgroundColor3 = Color3.fromRGB(22, 22, 22); b.BackgroundTransparency = N == h and 0.2 or 0.3; b.BorderSizePixel = 0; b.Text = H[N] or(string.upper(N)); b.TextColor3 = L.text; b.TextSize = A and 8 or 10; b.Font = Enum.Font.GothamBold; b.LayoutOrder = F; b.Parent = K; o(b, 6); Ei = Instance.new("Frame"); Ei.Name = "Indicator"; Ei.Size = UDim2.new(0, 18, 0, 2); Ei.Position = UDim2.new(0.5,- 9, 1,- 2); Ei.BackgroundColor3 = L.accent; Ei.BackgroundTransparency = N == h and 0.3 or 1; Ei.BorderSizePixel = 0; Ei.Parent = b; b.MouseButton1Click:Connect(function() if h == N then return; end; h = N; for Q, H in pairs(T) do local F = Q == N; H.Visible = F; if F then H = p[Q]; if H then H.Scale = 0.975; Z(H, {Scale = 1}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out); end; end; end; for Q, H in ipairs(K:GetChildren()) do if H:IsA("TextButton") then Q = H.Name == N .. "Button"; Z(H, {TextColor3 = L.text, BackgroundTransparency = Q and 0.16 or 0.3}, 0.18); local F = H:FindFirstChild("Indicator"); if F then Z(F, {BackgroundTransparency = Q and 0.15 or 1, Size = UDim2.new(0, Q and 28 or 12, 0, 2), Position = UDim2.new(0.5, Q and- 14 or- 6, 1,- 2)}, 0.2); end; end; end; end); b.MouseEnter:Connect(function() if h ~= N then Z(b, {TextColor3 = L.text, BackgroundTransparency = 0.25}); end; end); b.MouseLeave:Connect(function() if h ~= N then Z(b, {TextColor3 = L.text, BackgroundTransparency = 0.3}); end; end); end; ii = function() for Q, Q in ipairs(K:GetChildren()) do if Q:IsA("TextButton") then Q.TextColor3 = L.text; end; end; end; ii(); local K = Instance.new("TextButton"); l(K); K.Name = "GhostDuelRestoreButton"; K.Size = UDim2.new(0, 120, 0, 30); i = _G._GhostDuel_UI_ModernMiniPos; K.Position = i and(UDim2.fromOffset(i.x or 6, i.y or 54)) or(UDim2.new(0, 6, 0, 54)); K.BackgroundColor3 = L.bgDark; K.BorderSizePixel = 0; K.Text = "GhostDuel"; K.TextColor3 = L.text; K.TextSize = 11; K.Font = Enum.Font.GothamBlack; K.Visible = not C.Visible; K.ZIndex = 900; K.Parent = V; o(K, 8); e(K, Color3.fromRGB(45, 45, 45), 1.2); a(K, K); s.MouseButton1Click:Connect(function() if _G.__setPanelVisible then _G.__setPanelVisible (false); else C.Visible = false; end; end); K.MouseButton1Click:Connect(function() if _G.__setPanelVisible then _G.__setPanelVisible (true); else C.Visible = true; end; end); C:GetPropertyChangedSignal("Visible"):Connect(function() _G.__GhostDuelPanelVisible = C.Visible; E["Toggle UI"] = C.Visible; K.Visible = not C.Visible; mi(); end); local function i() local Q = workspace.CurrentCamera; if not Q then return; end; local h = Q.ViewportSize; if h.X <= 0 or h.Y <= 0 then return; end; local H, s = math.max(1, h.X - 12), math.max(1, h.Y - 60); if A then C.Size = UDim2.new(0, math.min(H, math.clamp(math.floor(h.X * 0.48), 210, 290)), 0, math.min(s, math.clamp(math.floor(h.Y * 0.62), 250, 390))); else C.Size = UDim2.new(0, math.min(400, H), 0, math.min(560, s)); end; Q = {C, K}; for K, K in ipairs(Q) do H = K.Position; v(K, H.X.Scale, H.X.Offset, H.Y.Scale, H.Y.Offset); end; end; i(); local K; local function Q() if K then K:Disconnect(); K = nil; end; local h = workspace.CurrentCamera; if h then K = _G.__GhostDuelTrackConn (h:GetPropertyChangedSignal("ViewportSize"):Connect(function() task.defer(i); end)); end; task.defer(i); end; _G.__GhostDuelTrackConn (workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(Q)); Q(); end)();
                                            _G.__GhostDuelRegisterThemeRoot (V);
                                            task.spawn(function() local K = Instance.new("Frame"); K.Size = UDim2.new(1, 0, 1, 0); K.BackgroundColor3 = Color3.fromRGB(0, 0, 0); K.BackgroundTransparency = 1; K.BorderSizePixel = 0; K.ZIndex = 10000; K.Parent = V; X:Create(K, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.45}):Play(); task.wait(0.12); X:Create(K, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play(); task.wait(0.3); pcall(function() K:Destroy(); end); end);
                                            (function() local function K(X) if not X then return "..."; end; return D(X); end; _G.__GhostDuelTrackConn (R.InputBegan:Connect(function(X, i) if B and j then local Q, h = j, X.UserInputType == Enum.UserInputType.Touch or X.UserInputType == Enum.UserInputType.MouseButton1; if t(X) or h or(Ri(X)) then if h or X.KeyCode == Enum.KeyCode.Escape or G(X) and Q ~= "Toggle UI" then q[Q] = nil; local h = (B.Size.X.Offset == 42 or(B:GetAttribute("MiniUIBind"))) and "-" or "BIND"; B.Text = h; elseif Ri(X) then local h = Xi(X); q[Q] = h; B.Text = d[h] or h; else q[Q] = X.KeyCode; B.Text = K(X.KeyCode); end; B.BackgroundColor3 = Color3.fromRGB(210, 230, 250); B.TextColor3 = Color3.fromRGB(80, 130, 200); B, j = nil, nil; mi(); if Q and U[Q] then U[Q](); end; local h = y[Q]; if h and h.bindCircle then local A = q[Q]; h.bindCircle.Text = A and(K(A)) or "-"; end; return; end; end; if R:GetFocusedTextBox() then return; end; local K = q["Carry Speed"]; local Q, h = K ~= nil and(t(X) and X.KeyCode == K or Ri(X) and Xi(X) == K), q.SelectNormalMode; if h ~= nil and(t(X) and X.KeyCode == h or Ri(X) and Xi(X) == h) and _ ~= "Normal" then if FeatureToggles.SelectNormalMode then FeatureToggles.SelectNormalMode(); end; pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost (); end; end); pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards (); end; end); mi(); return; end; if Q then if FeatureToggles["Carry Speed"] then FeatureToggles["Carry Speed"](); else h = not E["Carry Speed"]; E["Carry Speed"] = h; O = h; if W["Carry Speed"] then W["Carry Speed"](h); end; if U["Carry Speed"] then U["Carry Speed"](); end; mi(); end; return; end; K = q.Drop; if K ~= nil and(t(X) and X.KeyCode == K or Ri(X) and Xi(X) == K) then if FeatureToggles.Drop then FeatureToggles.Drop("keybind"); end; return; end; if i and not M[X.UserInputType] then return; end; if t(X) then for A, H in pairs(q) do if X.KeyCode == H then if FeatureToggles[A] then if A == "Drop" then FeatureToggles[A]("keybind"); else FeatureToggles[A](); end; else Q = not E[A]; E[A] = Q; mi(); if W[A] then W[A](Q); end; if U[A] then U[A](); end; end; end; end; end; if Ri(X) then Q = Xi(X); for A, H in pairs(q) do if H == Q then if FeatureToggles[A] then if A == "Drop" then FeatureToggles[A]("keybind"); else FeatureToggles[A](); end; else h = not E[A]; E[A] = h; mi(); if W[A] then W[A](h); end; if U[A] then U[A](); end; end; end; end; end; if not i and not R:GetFocusedTextBox() then if Ri(X) then if Xi(X) == q.BypassAuto then if FeatureToggles.BypassAuto then FeatureToggles.BypassAuto(); end; return; end; else K = q.BypassAuto; if K and X.KeyCode == K then if FeatureToggles.BypassAuto then FeatureToggles.BypassAuto(); end; return; end; end; end; end)); end)();
                                            (function() local K = _G.__GhostDuelInfJumpState or {}; _G.__GhostDuelInfJumpState = K; K.conn = K.conn or nil; K.lastJumpTime = K.lastJumpTime or 0; K.manualLock = false; local function X() return false; end; local function i() if(_G.__GhostDuelInfJumpMode or "hold") ~= "manual" or K.manualLock then return; end; K.manualLock = true; local Q = m.Character; local h, A = Q and(Q:FindFirstChildOfClass("Humanoid")), Q and(Q:FindFirstChild("HumanoidRootPart")); if not h or not A then K.manualLock = false; return; end; h = tick(); if h - K.lastJumpTime < 0.08 then K.manualLock = false; return; end; K.lastJumpTime = h; A.Velocity = Vector3.new(A.Velocity.X, 55, A.Velocity.Z); task.delay(0.14, function() K.manualLock = false; end); end; _G.__GhostDuelTrackConn (R.InputBegan:Connect(function(Q, h) if h then return; end; if Q.KeyCode == Enum.KeyCode.Space or Q.KeyCode == Enum.KeyCode.ButtonA then if(_G.__GhostDuelInfJumpMode or "hold") == "manual" then i(); return; end; if not X() then K.lastJumpTime = tick() - 0.08; end; end; end)); function startInfJump() if K.conn then K.conn:Disconnect(); K.conn = nil; end; K.conn = c.Heartbeat:Connect(function() if not E["Inf Jump"] or(_G.__GhostDuelInfJumpMode or "hold") ~= "hold" then return; end; if X() then return; end; pcall(function() local X = m.Character; if not X then return; end; local c = X:FindFirstChildOfClass("Humanoid"); if not c then return; end; local i = X:FindFirstChild("HumanoidRootPart"); if not i then return; end; X = tick(); if(R:IsKeyDown(Enum.KeyCode.Space) or(R:IsKeyDown(Enum.KeyCode.ButtonA)) or c.Jump == true) and X - K.lastJumpTime >= 0.08 then K.lastJumpTime = X; local R = i.Velocity; i.Velocity = Vector3.new(R.X, 55, R.Z); end; end); end); end; function stopInfJump() if K.conn then K.conn:Disconnect(); K.conn = nil; end; end; _G.__GhostDuelTrackStopper (stopInfJump); W["Inf Jump"] = function(K) if K and(_G.__GhostDuelInfJumpMode or "hold") == "hold" then startInfJump(); else stopInfJump(); end; end; if E["Inf Jump"] and(_G.__GhostDuelInfJumpMode or "hold") == "hold" then startInfJump(); end; _G.__GhostDuelTrackConn (m.CharacterAdded:Connect(function() if E["Inf Jump"] and(_G.__GhostDuelInfJumpMode or "hold") == "hold" then task.wait(0.5); stopInfJump(); startInfJump(); end; end)); end)();
                                            V.Enabled = true;
                                            task.defer(function() local K = {"FPS Boost", "Anti Lag", "Optimizer"}; for R, R in ipairs(K) do if E[R] and W[R] then pcall(function() W[R](true); end); end; end; end);
                                        end
