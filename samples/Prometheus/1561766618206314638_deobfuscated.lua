-- This file was generated at discord.gg/syncrypt

local y = {};
local r23 = {};
local r15 = setmetatable({}, {
    ["__index"] = r23,
    ["__metatable"] = nil
});
local v1 = game;
local r24 = v1.GetService(v1, "Players");
local v2 = game;
v2.GetService(v2, "RunService");
local v4 = game;
local r25 = v4.GetService(v4, "ReplicatedStorage");
local v5 = game;
local r26 = v5.GetService(v5, "TextChatService");
local r27 = r24.LocalPlayer;
local r28 = {};
local r29 = {};
local r30 = false;
local r31 = false;
local v6 = getgenv();
v6.OldPos = nil;
local v7 = getgenv();
v7.FPDH = workspace.FallenPartsDestroyHeight;
local r32 = "Original";
local r34 = Color3.fromRGB(255, 65, 65);
local r35 = "";
local r36 = Instance.new("ScreenGui");
local v8 = r36;
v8.Name = "SimpleFling";
local v9 = r36;
v9.ResetOnSpawn = false;
local v10 = r36;
local v11 = game;
v10.Parent = v11.GetService(v11, "CoreGui");
local v12 = Instance.new("TextButton");
v12.Size = UDim2.new(0, 50, 0, 50);
v12.Position = UDim2.new(0, 10, 0.5, -25);
v12.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
v12.Text = "R";
v12.TextColor3 = r34;
v12.Font = Enum.Font.GothamBold;
v12.TextSize = 24;
v12.Parent = r36;
Instance.new("UICorner", v12);
v11.CornerRadius = UDim.new(1, 0);
Instance.new("UIStroke", v12);
Z.Thickness = 2;
Z.Color = r34;
local r37 = Instance.new("Frame");
local v13 = r37;
v13.Size = UDim2.new(0, 340, 0, 580);
local v14 = r37;
v14.Position = UDim2.new(0.5, -170, 0.5, -290);
local v15 = r37;
v15.BackgroundColor3 = Color3.fromRGB(18, 18, 18);
local v16 = r37;
v16.BorderSizePixel = 0;
local v17 = r37;
v17.Active = true;
local v18 = r37;
v18.Draggable = true;
local v19 = r37;
v19.Parent = r36;
Instance.new("UICorner", r37);
C.CornerRadius = UDim.new(0, 10);
Instance.new("UIStroke", r37);
dY.Thickness = 2;
dY.Color = r34;
dY.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
local v20 = Instance.new("Frame");
v20.Size = UDim2.new(1, 0, 0, 45);
v20.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
v20.BorderSizePixel = 0;
v20.Parent = r37;
Instance.new("UICorner", v20);
L.CornerRadius = UDim.new(0, 10);
Instance.new("TextLabel");
FY.Size = UDim2.new(1, -50, 1, 0);
FY.Position = UDim2.new(0, 15, 0, 0);
FY.BackgroundTransparency = 1;
FY.Text = "redzzyg's fling system";
FY.TextColor3 = r34;
FY.Font = Enum.Font.GothamBold;
FY.TextSize = 16;
FY.TextXAlignment = Enum.TextXAlignment.Left;
FY.Parent = v20;
YY.Size = UDim2.new(0, 30, 0, 30);
YY.Position = UDim2.new(1, -40, 0.5, -15);
YY.BackgroundTransparency = 1;
YY.Text = "\xc3\x97";
YY.TextColor3 = Color3.fromRGB(200, 200, 200);
YY.TextSize = 30;
YY.Font = Enum.Font.Gotham;
YY.Parent = v20;
local r38 = Instance.new("TextLabel");
local v21 = r38;
v21.Position = UDim2.new(0, 15, 0, 55);
local v22 = r38;
v22.Size = UDim2.new(1, -30, 0, 20);
local v23 = r38;
v23.BackgroundTransparency = 1;
local v24 = r38;
v24.Text = "Fling system disengaged";
local v25 = r38;
v25.TextColor3 = Color3.fromRGB(150, 150, 150);
local v26 = r38;
v26.Font = Enum.Font.GothamSemibold;
local v27 = r38;
v27.TextSize = 12;
local v28 = r38;
v28.TextXAlignment = Enum.TextXAlignment.Left;
local v29 = r38;
v29.Parent = r37;
local r39 = Instance.new("TextBox");
local v30 = r39;
v30.Size = UDim2.new(1, -20, 0, 30);
local v31 = r39;
v31.Position = UDim2.new(0, 10, 0, 80);
local v32 = r39;
v32.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
local v33 = r39;
v33.BorderSizePixel = 0;
local v34 = r39;
v34.PlaceholderText = "Search players...";
local v35 = r39;
v35.Text = "";
local v36 = r39;
v36.TextColor3 = Color3.fromRGB(255, 255, 255);
local v37 = r39;
v37.Font = Enum.Font.Gotham;
local v38 = r39;
v38.TextSize = 14;
local v39 = r39;
v39.Parent = r37;
Instance.new("UICorner", r39);
fY.CornerRadius = UDim.new(0, 6);
local r40 = Instance.new("ScrollingFrame");
local v40 = r40;
v40.Position = UDim2.new(0, 10, 0, 120);
local v41 = r40;
v41.Size = UDim2.new(1, -20, 0, 160);
local v42 = r40;
v42.BackgroundTransparency = 1;
local v43 = r40;
v43.BorderSizePixel = 0;
local v44 = r40;
v44.ScrollBarThickness = 2;
local v45 = r40;
v45.ScrollBarImageColor3 = r34;
local v46 = r40;
v46.Parent = r37;
local r41 = Instance.new("UIListLayout", r40);
local v47 = r41;
v47.Padding = UDim.new(0, 6);
local function v48(arg1_2, arg2_2, arg3_2, arg4_2, ...)
    v4 = Instance.new("TextButton");
    U = arg1_2;
    v4.Text = U;
    U = arg2_2;
    v4.Position = U;
    U = arg3_2;
    v4.Size = U;
    U = arg4_2;
    v4.BackgroundColor3 = U;
    v4.Font = Enum.Font.GothamBold;
    v4.TextColor3 = Color3.new(1, 1, 1);
    v4.TextSize = 12;
    v4.AutoButtonColor = true;
    v4.Parent = r37;
    R = Instance.new("UICorner", v4);
    R.CornerRadius = UDim.new(0, 6);
    n = Instance.new("UIStroke", v4);
    n.Thickness = 1.5;
    n.Color = r34;
    n.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    return v4; 
end;
local r42 = v48("FLING ALL: OFF", UDim2.new(0, 10, 0, 385), UDim2.new(1, -20, 0, 35), Color3.fromRGB(30, 30, 30));
local r43 = v48("RETURN MODE: ORIGINAL", UDim2.new(0, 10, 0, 430), UDim2.new(1, -20, 0, 35), Color3.fromRGB(30, 30, 30));
local r44 = v48("SET MANUAL POSITION", UDim2.new(0, 10, 0, 475), UDim2.new(1, -20, 0, 35), Color3.fromRGB(30, 30, 30));
local v49 = r44;
v49.Visible = false;
local v50 = v48("LOAD INFINITE YIELD", UDim2.new(0, 10, 0, 520), UDim2.new(1, -20, 0, 35), Color3.fromRGB(30, 30, 30)).MouseButton1Click;
v50.Connect(v50, function(...)
    u = game;
    loadstring(u.HttpGet(u, "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
    F = r38;
    F.Text = "SYSTEM: Infinite Yield loaded"; 
end);
local v51 = r43.MouseButton1Click;
v51.Connect(v51, function(...)
    if r32 == "Original" then
        r32 = "Manual";
        U = r43;
        U.Text = "RETURN MODE: MANUAL";
        U = r44;
        U.Visible = true;
    else
        if r32 == "Manual" then
            r32 = "Target";
            u = r43;
            u.Text = "RETURN MODE: TARGET";
            u = r44;
            u.Visible = false;
        else
            r32 = "Original";
            k = r43;
            k.Text = "RETURN MODE: ORIGINAL";
            k = r44;
            k.Visible = false;
        end;
        return;
    end; 
end);
local v52 = r44.MouseButton1Click;
v52.Connect(v52, function(...)
    u = r27.Character;
    if u then
        u = r27.Character;
        U = u.FindFirstChild(u, "HumanoidRootPart");
    end;
    if u then
        r33 = r27.Character.HumanoidRootPart.CFrame;
        U = r38;
        U.Text = "SYSTEM: Return point saved";
    end; 
end);
local function r49(...)
    if r30 then
        return;
    end;
    v4 = {
        pairs(r28)
    };
    o = pairs(r28);
    v1 = o(v4[2], v4[3]);
    while v1 do
        v4 = v1;
        u = 0 + 1; 
    end;
    if 0 == 0 then
        return;
    end;
    r30 = true;
    v1 = r38;
    v1.Text = "ACTIVE: Target count " .. 0;
    task.spawn(function(...)
        while r30 do
            F = pairs;
            o = r28;
            v1 = v4[3];
            o = v4[1];
            for v1, R in o, F(o) do
                v4 = v1;
                if not r30 then
                else
                    if R then
                        F = not n;
                        n = R.Parent and R.Character;
                    end;
                    if R then
                        r38(R);
                        u = true;
                    end;
                end; 
            end;
            F = F;
            if not false or getgenv().SinglePass then
                r30 = false;
                break;
            else
                task.wait(.1);
            end; 
        end;
        r30 = false;
        o = getgenv();
        o.SinglePass = false;
        v1 = r38;
        v1.Text = "Fling system disengaged"; 
    end); 
end;
local function r50(...)
    r30 = false;
    r31 = false;
    u = r42;
    u.Text = "FLING ALL: OFF";
    u = r42;
    u.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    getgenv();
    k.SinglePass = false;
    u = r38;
    u.Text = "Fling system disengaged"; 
end;
local function r51(...)
    r31 = not r31;
    if r31 then
        U = r42;
        U.Text = "FLING ALL: ON";
        U = r42;
        U.BackgroundColor3 = Color3.fromRGB(40, 130, 80);
        r28 = {};
        v4 = r24;
        v1 = v4[2];
        o = v4[3];
        for o, v4 in pairs(v4.GetPlayers(v4)) do
            u = o;
            F = not r31;
            if v4 ~= r27 and not r29[v4[r15[r16("\x98\xe0\xbd\"", y[k])]]] then
                R = r28;
                R[v4.Name] = v4;
            end; 
        end;
        getgenv();
        k.SinglePass = false;
        r49();
    else
        r50();
        r28 = {};
        RefreshList();
    end; 
end;
local v53 = r42.MouseButton1Click;
v53.Connect(v53, r51);
local v54 = r24.PlayerAdded;
v54.Connect(v54, function(arg1_4, ...)
    u = arg1_4;
    if r31 then
        F = u.CharacterAdded;
        F.Wait(F);
        task.wait(1.5);
        F = r28;
        F[u.Name] = u;
        if not r30 then
            r49();
        end;
    end; 
end);
local function r52(arg1_5, ...)
    u = arg1_5;
    F = r26.ChatVersion == Enum.ChatVersion.TextChatService;
    if F then
        k = r26.TextChannels.RBXGeneral;
        k.SendAsync(k, u);
    else
        F = r25.DefaultChatSystemChatEvents.SayMessageRequest;
        F.FireServer(F, u, "All");
    end; 
end;
local function r53(arg1_6, arg2_6, ...)
    u = arg1_6;
    if not r29[arg2_6.Name] then
        return;
    end;
    v1 = u.split(u, " ");
    F = v1[1];
    o = F.lower(F);
    if o == ".fling" and v1[2] then
        N = 9375490019597;
        F = v1[2];
        if F.lower(F) == "all" then
            r50();
            task.wait(.1);
            r28 = {};
            K = r24;
            N = {
                K.GetPlayers(K)
            };
            v5 = K[3];
            for v5, N in K[1], pairs(Y(N)) do
                K = v5;
                if N ~= r27 and N ~= arg2_6 then
                    U = r28;
                end; 
            end;
            R = getgenv();
            R.SinglePass = true;
            r49();
        else
            N = r24;
            G = {
                N.GetPlayers(N)
            };
            K = N[3];
            for K, G in N[1], pairs(Y(G)) do
                N = K;
                a = G.Name;
                v7 = a.lower(a);
                F = v4 == U;
                if v7.sub(v7, 1, #v4) == v4 or v7.sub(v7, 1, #v4) == v4 then
                    R = G;
                end; 
            end;
            if nil then
                F = v4 == U;
                n = nil ~= r27 and nil ~= arg2_6;
            end;
            F = v4 == U;
            if nil then
                r50();
                task.wait(.1);
                r28 = {
                    [(nil).Name] = nil
                };
                K = getgenv();
                K.SinglePass = true;
                r49();
            end;
        end;
    else
        R = v1[1];
        F = R;
        if o == ".loopfling" and v1[2] then
            v4 = u.split(u, " ")[2];
            if v4.lower(v4) == "all" then
                if not r31 then
                    r51();
                end;
            else
                W = r24;
                G = W[3];
                for G, W in W[1], pairs(W.GetPlayers(W)) do
                    v5 = G;
                    e = W.Name;
                    D = e.lower(e);
                    F = R;
                    if D.sub(D, 1, #R) == R or D.sub(D, 1, #R) == R then
                        v4 = W;
                    end; 
                end;
                if nil then
                    v5 = nil ~= r27 and nil ~= arg2_6;
                    F = R;
                end;
                F = R;
                if nil then
                    r50();
                    task.wait(.1);
                    r28 = {
                        [(nil).Name] = nil
                    };
                    getgenv();
                    N.SinglePass = false;
                    r49();
                end;
            end;
        else
            R = R;
            N = R;
            R = R;
            R = R;
            F = R;
            F = R;
            if o == ".unloopfling" and v1[2] == "all" or (o == ".stopfling" and v1[2] == "all" or o == ".unfling") then
                if r31 then
                    r51();
                end;
            else
                F = F;
                if o == ".unfling" or o == ".unloopfling" then
                    r50();
                end;
                return;
            end;
        end;
    end; 
end;
local v55 = v4.GetService(v4, "UserInputService").InputBegan;
v55.Connect(v55, function(arg1_7, arg2_7, ...)
    if arg2_7 then
        return;
    end;
    if arg1_7.KeyCode == Enum.KeyCode.RightControl then
        F = r37;
        F.Visible = not r37.Visible;
    end; 
end);
RefreshList = function(...)
    l = r40;
    u = l[2];
    l = l[1];
    for k, x in pairs(l.GetChildren(l)) do
        o = k;
        if x.IsA(x, "Frame") then
            x.Destroy(x);
        end; 
    end;
    F = pairs;
    o = r24;
    R = o.GetPlayers;
    x = {
        R(o)
    };
    u = o[1];
    k = o[2];
    for l, x in F(Y(x)) do
        r54 = x;
        o = l;
        F = r54.DisplayName;
        R = F.lower(F);
        F = r54.Name;
        F.lower(F);
        G = r27;
        M = r54 ~= G and R.find(R, r35);
        if M then
            M = Instance.new("Frame");
            M.Size = UDim2.new(1, -8, 0, 50);
            F = "BackgroundColor3";
            N = F;
            G = r28[r54.Name];
            K = G and Color3.fromRGB(40, 25, 25);
            F = F;
            if G then
                M[F] = G and Color3.fromRGB(40, 25, 25);
                M.BorderSizePixel = 0;
                M.Parent = r40;
                K = Instance.new("UICorner", M);
                S = "\xb3\x03`\x06";
                K.CornerRadius = UDim.new(0, 6);
                N = Instance.new("UIStroke", M);
                N.Thickness = 1;
                if r28[r54.Name] then
                    N.Color = Color3.fromRGB(150, 0, 0);
                else
                    if r29[r54.Name] then
                        N.Color = Color3.fromRGB(0, 255, 120);
                    else
                        N.Color = Color3.fromRGB(40, 40, 40);
                    end;
                    r55 = Instance.new("ImageLabel");
                    F = r55;
                    F.Size = UDim2.new(0, 40, 0, 40);
                    F = r55;
                    F.Position = UDim2.new(0, 5, 0.5, -20);
                    F = r55;
                    F.BackgroundColor3 = Color3.fromRGB(20, 20, 20);
                    pcall(function(...)
                        F = r55;
                        u = r24;
                        F.Image = u.GetUserThumbnailAsync(u, r54.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48); 
                    end);
                    F = r55;
                    F.Parent = M;
                    G = Instance.new("UICorner", r55);
                    G.CornerRadius = UDim.new(1, 0);
                    G = Instance.new("TextLabel");
                    G.Size = UDim2.new(1, -95, 1, 0);
                    G.Position = UDim2.new(0, 52, 0, 0);
                    G.BackgroundTransparency = 1;
                    G.RichText = true;
                    G.TextColor3 = Color3.new(1, 1, 1);
                    G.Font = Enum.Font.Gotham;
                    G.TextSize = 13;
                    G.TextXAlignment = Enum.TextXAlignment.Left;
                    G.Parent = M;
                    G.Text = r54.DisplayName .. "\n<font color='#AAAAAA'>@" .. r54.Name .. "</font>";
                    s = Instance.new("TextButton");
                    s.Size = UDim2.new(0, 40, 0, 30);
                    s.Position = UDim2.new(1, -45, 0.5, -15);
                    F = "BackgroundColor3";
                    S = r29[r54.Name];
                    m = F;
                    if S then
                        e = Color3.fromRGB(0, 150, 70);
                    end;
                    F = F;
                    a = S;
                    if S then
                        s[F] = e;
                        s.Text = "W";
                        s.TextColor3 = Color3.new(1, 1, 1);
                        s.Font = Enum.Font.GothamBold;
                        s.Parent = M;
                        a = Instance.new("UICorner", s);
                        a.CornerRadius = UDim.new(0, 6);
                        F = s.MouseButton1Click;
                        F.Connect(F, function(...)
                            M = 34378796383880;
                            F = r29[r54.Name];
                            if F then
                                F = r29;
                                F[r54.Name] = nil;
                            else
                                F = r29;
                                F[r54.Name] = true;
                                r56 = Instance.new("Frame");
                                F = r56;
                                F.Size = UDim2.new(0, 280, 0, 140);
                                F = r56;
                                F.Position = UDim2.new(0.5, -140, 0.5, -70);
                                F = r56;
                                F.BackgroundColor3 = Color3.fromRGB(25, 25, 25);
                                F = r56;
                                F.Parent = r36;
                                Instance.new("UICorner", r56);
                                k = Instance.new("TextLabel");
                                k.Size = UDim2.new(.9, 0, .6, 0);
                                k.Position = UDim2.new(.05, 0, 0, 0);
                                k.BackgroundTransparency = 1;
                                k.Text = r54.DisplayName .. " has been given control over your fling script.\n\nWould you like to send a tutorial to the user?";
                                k.TextColor3 = Color3.new(1, 1, 1);
                                k.Font = Enum.Font.GothamBold;
                                k.TextSize = 14;
                                k.TextWrapped = true;
                                k.Parent = r56;
                                l = Instance.new("TextButton");
                                l.Size = UDim2.new(.35, 0, 0.25, 0);
                                l.Position = UDim2.new(.1, 0, .65, 0);
                                l.Text = "YES";
                                l.BackgroundColor3 = Color3.fromRGB(40, 130, 80);
                                l.Font = Enum.Font.GothamBold;
                                l.TextColor3 = Color3.new(1, 1, 1);
                                l.Parent = r56;
                                Instance.new("UICorner", l);
                                F = l.MouseButton1Click;
                                F.Connect(F, function(...)
                                    r52("Hello " .. r54.DisplayName .. "! Whitelisted. Cmds: .fling (user/all), .loopfling (user/all), .unfling, .unloopfling all.");
                                    F = r56;
                                    F.Destroy(F); 
                                end);
                                o = Instance.new("TextButton");
                                o.Size = UDim2.new(.35, 0, 0.25, 0);
                                o.Position = UDim2.new(.55, 0, .65, 0);
                                o.Text = "NO";
                                o.BackgroundColor3 = Color3.fromRGB(160, 40, 40);
                                o.Font = Enum.Font.GothamBold;
                                o.TextColor3 = Color3.new(1, 1, 1);
                                o.Parent = r56;
                                Instance.new("UICorner", o);
                                F = o.MouseButton1Click;
                                F.Connect(F, function(...)
                                    F = r56;
                                    F.Destroy(F); 
                                end);
                            end;
                            RefreshList(); 
                        end);
                        a = Instance.new("TextButton");
                        a.Size = UDim2.new(1, -50, 1, 0);
                        a.BackgroundTransparency = 1;
                        a.Text = "";
                        a.Parent = M;
                        F = a.MouseButton1Click;
                        F.Connect(F, function(...)
                            if r28[r54.Name] then
                                F = r28;
                                F[r54.Name] = nil;
                            else
                                F = r28;
                                F[r54.Name] = r54;
                            end;
                            RefreshList(); 
                        end);
                    else
                        a = Color3.fromRGB(40, 40, 40);
                    end;
                end;
            else
                K = Color3.fromRGB(28, 28, 28);
            end;
        end; 
    end;
    F = r40;
    F.CanvasSize = UDim2.new(0, 0, 0, r41.AbsoluteContentSize.Y); 
end;
local v56 = r39;
local v57 = v56.GetPropertyChangedSignal(v56, "Text");
v57.Connect(v57, function(...)
    F = r39.Text;
    r35 = F.lower(F);
    RefreshList(); 
end);
local v58 = v48("START FLING", UDim2.new(0, 10, 0, 290), UDim2.new(0.5, -15, 0, 40), Color3.fromRGB(40, 130, 80)).MouseButton1Click;
v58.Connect(v58, r49);
local v59 = v48("STOP FLING", UDim2.new(0.5, 5, 0, 290), UDim2.new(0.5, -15, 0, 40), Color3.fromRGB(160, 40, 40)).MouseButton1Click;
v59.Connect(v59, r50);
local v60 = Instance.new("TextButton").MouseButton1Click;
v60.Connect(v60, function(...)
    r50();
    F = r36;
    F.Destroy(F); 
end);
local v61 = v12.MouseButton1Click;
v61.Connect(v61, function(...)
    F = r37;
    F.Visible = not r37.Visible; 
end);
local v62 = v48("SELECT ALL", UDim2.new(0, 10, 0, 340), UDim2.new(0.5, -15, 0, 35), Color3.fromRGB(45, 45, 45)).MouseButton1Click;
v62.Connect(v62, function(...)
    v1 = r24;
    u = v1[2];
    k = v1[3];
    v1 = "pairs";
    for k, v4 in pairs(v1.GetPlayers(v1)) do
        o = k;
        if v4 ~= r27 then
            F = r28;
            F[v4.Name] = v4;
        end; 
    end;
    RefreshList(); 
end);
local v63 = v48("DESELECT ALL", UDim2.new(0.5, 5, 0, 340), UDim2.new(0.5, -15, 0, 35), Color3.fromRGB(45, 45, 45)).MouseButton1Click;
v63.Connect(v63, function(...)
    r28 = {};
    r50();
    RefreshList(); 
end);
local v64 = r24;
local v65 = {
    v64.GetPlayers(v64)
};
local v66 = v64[3];
local v67 = v64[2];
for v66, v64 in pairs(Y(v65)) do
    r57 = v64;
    v63 = v66;
    v65 = r57.Chatted;
    v65.Connect(v65, function(arg1_8, ...)
        r53(arg1_8, r57); 
    end); 
end;
local v68 = r24.PlayerAdded;
v68.Connect(v68, function(arg1_9, ...)
    r58 = arg1_9;
    F = r58.Chatted;
    F.Connect(F, function(arg1_10, ...)
        r53(arg1_10, r58); 
    end);
    RefreshList(); 
end);
RefreshList();