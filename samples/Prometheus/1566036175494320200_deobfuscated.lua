-- This file was generated at discord.gg/syncrypt

local H = {};
local v1 = {...};
local r1 = "g7q";
for p = 0, 9 do
    if p == 0 then
        if r1 ~= "g7q" then
            while true do end;
        end;
        r1 = true;
    else
        if p == 1 then
            if r1 == true then
            end;
        else
            if p == 2 then
                r1 = true;
            else
                if p == 3 then
                    if r1 == true then
                    else
                        while true do end;
                    end;
                else
                    if p == 4 then
                        r1 = true;
                    else
                        if p == 5 then
                            if r1 == true then
                            else
                                while true do end;
                            end;
                        else
                            if p == 6 then
                                r1 = false;
                            else
                                if p == 7 then
                                    if r1 == false then
                                    else
                                        while true do end;
                                    end;
                                else
                                    if p == 8 then
                                        r1 = true;
                                    else
                                        if p == 9 then
                                            if r1 == true then
                                            else
                                                while true do end;
                                            end;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end; 
end;
local r18 = math.floor;
local r20 = {};
local v2 = {};
for M = 1, 256 do
    v2[M] = M; 
end;
repeat
    M = table.remove(v2, math.random(1, #v2));
    O = r20;
    O[M] = string.char(M - 1);
until #v2 == 0;
local r23 = {};
local r15 = setmetatable({}, {
    ["__index"] = r23,
    ["__metatable"] = nil
});
local v3 = getgenv().Toolbox;
local v4 = true;
if not v3 or type(v3.RegisterCategories) ~= "function" then
    warn("Nightmare Circus: Toolbox is not loaded");
    return;
end;
local v5 = game;
local r24 = v5.GetService(v5, "Players").LocalPlayer;
local function r25(arg1_2, ...)
    v1 = arg1_2;
    v4 = workspace;
    K = v4;
    w = v4.WaitForChild(v4, "Section1", v1 or 8);
    if w then
        F = workspace;
        d = w.WaitForChild(w, "Games", v1 or 8);
    end;
    v4 = v4;
    return w; 
end;
local v6 = game;
local r26 = v6.GetService(v6, "ReplicatedStorage");
local v7 = game;
local r27 = v7.GetService(v7, "RunService");
local v8 = game;
local r28 = v8.GetService(v8, "Lighting");
local v9 = game;
v9.GetService(v9, "PhysicsService");
local r30 = Vector3.new(-135.193, 28.701, -50.983);
local r31 = Vector3.new(-523.016, 13.935, 489.681);
local function r32(...)
    d = workspace;
    if d.GetAttribute(d, "MimicHollowOptedOut") == true then
        return false;
    end;
    d = workspace;
    if d.GetAttribute(d, "MimicHollowSelected") == true then
        return true;
    end;
    d = workspace;
    return d.GetAttribute(d, "MimicEvent") == "TheHollow"; 
end;
local function r33(...)
    K = r32();
    if K then
        v1 = r31;
    end;
    v4 = true;
    if K then
        return K;
    else
        d = r30;
    end; 
end;
local v10 = _G;
v10.ToolboxCircusGetSafeZone = r33;
local function r36(arg1_4, ...)
    if r35 then
        v4 = r35;
        v4.Disconnect(v4);
    end;
    if arg1_4 then
        r34 = {
            ["Brightness"] = r28.Brightness,
            ["ClockTime"] = r28.ClockTime,
            ["FogEnd"] = r28.FogEnd,
            ["GlobalShadows"] = r28.GlobalShadows,
            ["Ambient"] = r28.Ambient,
            ["OutdoorAmbient"] = r28.OutdoorAmbient
        };
        local function w(...)
            v4 = r28;
            v4.Brightness = 3;
            v4 = r28;
            v4.ClockTime = 14;
            v4 = r28;
            v4.FogEnd = 1000000;
            v4 = r28;
            v4.GlobalShadows = false;
            v4 = r28;
            v4.Ambient = Color3.fromRGB(190, 190, 190);
            v4 = r28;
            v4.OutdoorAmbient = Color3.fromRGB(190, 190, 190); 
        end;
        w();
        v3 = r27.Heartbeat;
        r35 = v3.Connect(v3, w);
    else
        if r34 then
            F = r34;
            for x, F in pairs(F) do
                W = H[v8];
                W[x] = F; 
            end;
        end;
        return;
    end; 
end;
local r38 = {};
local r39 = false;
local function r40(arg1_5, ...)
    if r37 then
        v4 = r37;
        v4.Disconnect(v4);
    end;
    if arg1_5 then
        local function w(arg1_6, ...)
            v1 = arg1_6;
            if v1.IsA(v1, "ProximityPrompt") then
                if r38[v1] == nil then
                    v4 = r38;
                    v4[v1] = v1.HoldDuration;
                end;
                v1.HoldDuration = 0;
            end; 
        end;
        x = workspace;
        F = {
            x.GetDescendants(x)
        };
        for v5, F in ipairs(N(F)) do
            w(F); 
        end;
        d = workspace.DescendantAdded;
        r37 = d.Connect(d, w);
    else
        for v5, F in pairs(r38) do
            r42 = F;
            if "Parent" then
                pcall(function(...)
                    v4 = r41;
                    v4.HoldDuration = r42; 
                end);
            end; 
        end;
        table.clear(r38);
        return;
    end; 
end;
local r44 = false;
local function r46(arg1_7, ...)
    v1 = arg1_7;
    if r44 then
        r45();
    end;
    v3 = r24;
    K = "Character";
    w = v3[K];
    d = w;
    if w then
        r47 = w;
        v4 = r47;
        v3 = v4.WaitForChild(v4, "HumanoidRootPart");
        if r43 and (r43.root == v3 and (r43.force and r43.force.Parent)) then
            v3.AssemblyLinearVelocity = Vector3.new(v3.AssemblyLinearVelocity.v4, 0, v3.AssemblyLinearVelocity.v7);
            return r43;
        end;
        if r43 then
            v4 = r43.rotation;
            if v4 then
                v4 = r43.rotation;
                v4.Disconnect(v4);
            end;
            v4 = r43.noclip;
            if v4 then
                v4 = r43.noclip;
                v4.Disconnect(v4);
            end;
            v4 = r43.force;
            if v4 then
                v4 = r43.force;
                v4.Destroy(v4);
            end;
        end;
        K = Instance.new("BodyVelocity");
        K.Name = "ToolboxCircusFloatForce";
        K.MaxForce = Vector3.new(0, math.huge, 0);
        K.Velocity = Vector3.zero;
        K.P = 10000;
        K.Parent = v3;
        v4 = r27.Stepped;
        r43 = {
            ["root"] = v3,
            ["force"] = K,
            ["noclip"] = v4.Connect(v4, function(...)
                if not r47.Parent then
                    return;
                end;
                v3 = r47;
                v3 = "ipairs";
                for w, v5 in ipairs(v3.GetDescendants(v3)) do
                    K = w;
                    if v5.IsA(v5, "BasePart") then
                        v5.CanCollide = false;
                    end; 
                end; 
            end)
        };
        return r43;
    else
        w = r24.CharacterAdded;
        d = w.Wait(w);
    end; 
end;
local v12 = game;
local r48 = v12.GetService(v12, "UserInputService");
local r49 = 1;
local r50 = 200;
local r51 = false;
local r52 = false;
local r58 = {};
local function r45(...)
    r44 = false;
    r51 = false;
    r52 = false;
    if r55 then
        w = r55;
        w.Disconnect(w);
    end;
    if r53 then
        v3 = r53;
        v3.Destroy(v3);
    end;
    if r54 then
        K = r54;
        K.Destroy(K);
    end;
    if r57 then
        v5 = r57;
        v5.Destroy(v5);
    end;
    u = r58;
    for J, u in ipairs(u) do
        u.Disconnect(u);
        u, x = nil, J; 
    end;
    table.clear(r58);
    W = r56;
    if W then
        W = r56;
        x = W.FindFirstChildOfClass(W, "Humanoid");
    end;
    v4 = false;
    if W then
        x.PlatformStand = false;
    end; 
end;
local function r59(...)
    if r44 then
        return;
    end;
    v1 = r24.Character;
    d = v1;
    if v1 then
        r60 = d;
        v4 = r60;
        w = v4.FindFirstChild(v4, "HumanoidRootPart");
        v4 = r60;
        r61 = v4.FindFirstChildOfClass(v4, "Humanoid");
        if not w or not r61 then
            return;
        end;
        if r43 and r43.force then
            v4 = r43.force;
            v4.Destroy(v4);
            v4 = r43;
            v4.force = nil;
        end;
        r56 = r60;
        r44 = true;
        K = r61;
        K.PlatformStand = true;
        r53 = Instance.new("BodyGyro");
        K = r53;
        K.Name = "ToolboxFlyGyro";
        K = r53;
        K.P = 90000;
        K = r53;
        K.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000);
        K = r53;
        K.CFrame = w.CFrame;
        K = r53;
        K.Parent = w;
        r54 = Instance.new("BodyVelocity");
        K = r54;
        K.Name = "ToolboxFlyVelocity";
        K = r54;
        K.Velocity = Vector3.zero;
        K = r54;
        K.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000);
        K = r54;
        K.Parent = w;
        J = r48.InputBegan;
        table.insert(r58, J.Connect(J, function(arg1_8, arg2_8, ...)
            v1 = arg1_8;
            if arg2_8 then
                return;
            end;
            if v1.KeyCode == Enum.KeyCode.E or v1.KeyCode == Enum.KeyCode.Space then
                r51 = true;
            end;
            v4 = H[v1];
            if v1.KeyCode == Enum.KeyCode.Q or v1.KeyCode == Enum.KeyCode.LeftControl then
                r52 = true;
            end; 
        end));
        J = r48.InputEnded;
        table.insert(r58, J.Connect(J, function(arg1_9, ...)
            v1 = arg1_9;
            v3 = v1.KeyCode;
            if v3 == Enum.KeyCode.E or v3 == Enum.KeyCode.Space then
                r51 = false;
            end;
            v4 = H[v1];
            if v1.KeyCode == Enum.KeyCode.Q or v1.KeyCode == Enum.KeyCode.LeftControl then
                r52 = false;
            end; 
        end));
        K = r27.RenderStepped;
        r55 = K.Connect(K, function(...)
            if not r44 then
                return;
            end;
            v4 = r60;
            if not r60.Parent or (not v4.FindFirstChild(v4, "HumanoidRootPart") or (r61.Health <= 0 or (not r53 or not r54))) then
                r45();
                return;
            end;
            w = workspace.CurrentCamera;
            if not w then
                return;
            end;
            v3 = w.CFrame;
            v4 = r53;
            K = w.CFrame;
            K = r61.MoveDirection;
            v5 = r49 * r50;
            x = Vector3.zero;
            if K.Magnitude > .05 then
                v7 = "\xe3\x95l\x96\xb8h\xe2G\x17";
                if Vector3.new(v3.LookVector.v4, 0, v3.LookVector.v7).Magnitude > .001 then
                    v4 = Vector3.new(v3.LookVector.v4, 0, v3.LookVector[r15[v9]]).Unit;
                    J = v3.LookVector * K.Dot(K, v4) + v3.RightVector * K.Dot(K, Vector3.new(v3.RightVector.v4, 0, v3.RightVector.v7).Unit);
                    v6 = v4;
                    v7 = "Magnitude" > .01 and "Unit";
                    v4, u = v4, v7;
                    if v7 then
                        x, v4, J, W = v7 * r49 * r50, v4, nil, nil;
                        if r51 then
                            x = d + w.CFrame.UpVector * r49 * r50;
                        end;
                        if r52 then
                            x = d - w.CFrame.UpVector * r49 * r50;
                        end;
                        F = r54;
                        F.Velocity = x;
                        return;
                    else
                        u = r61.MoveDirection;
                    end;
                else
                    x = w.CFrame.LookVector * r49 * r50;
                end;
            end; 
        end);
        return;
    else
        v1 = r24.CharacterAdded;
        d = v1.Wait(v1);
    end; 
end;
local function r62(arg1_10, arg2_10, ...)
    v3 = arg1_10.Parent;
    if v3.IsA(v3, "Attachment") then
        return v3.WorldPosition;
    end;
    if v3.IsA(v3, "BasePart") then
        return v3.Position;
    end;
    if v3.IsA(v3, "Model") then
        return v3.GetPivot(v3).Position;
    end;
    return arg2_10; 
end;
local function r64(arg1_13, arg2_13, ...)
    v1 = arg1_13;
    if not v1 then
        return false;
    end;
    if v1.GetAttribute(v1, "Playing") == true or (v1.GetAttribute(v1, "Active") == true or v1.GetAttribute(v1, "InProgress") == true) then
        return true;
    end;
    v3 = v1.GetAttribute(v1, "Phase");
    if v3 ~= nil and (v3 ~= "idle" and (v3 ~= "finished" and v3 ~= "complete")) then
        return true;
    end;
    if arg2_13 then
        for v5, W in ipairs("ipairs") do
            if v1.GetAttribute(v1, W) ~= arg2_13[W] then
                return true;
            end; 
        end;
    end;
    return false; 
end;
local function r65(arg1_14, arg2_14, arg3_14, ...)
    r66 = arg1_14;
    r67 = arg3_14;
    F = "Running";
    if not r67[F] or (not r66 or not F.IsA(F, "ProximityPrompt")) then
        return false;
    end;
    r68 = workspace.CurrentCamera;
    if not r68 then
        return false;
    end;
    r69 = r68.CameraType;
    r70 = r68.CameraSubject;
    r71 = r68.CFrame;
    r72 = r68.Focus;
    r73 = r62(r66, r68.CFrame.Position + r68.CFrame.LookVector * 10);
    r74 = false;
    r75 = false;
    local function r76(...)
        v4 = r68;
        v4.CameraType = Enum.CameraType.Scriptable;
        v4 = r68;
        v4.CFrame = CFrame.lookAt(r68.CFrame.Position, r73);
        v4 = r68;
        v4.Focus = CFrame.new(r73);
        v4 = r27.RenderStepped;
        v4.Wait(v4);
        task.wait(.15); 
    end;
    v9 = pcall(function(...)
        r76();
        if not r67.Running then
            return;
        end;
        v4 = r66;
        v4.InputHoldBegin(v4);
        r74 = true;
        task.wait(.1);
        d = r66;
        d.InputHoldEnd(d);
        r74 = false;
        if not r67.Running then
            return;
        end;
        task.wait(.15);
        r76();
        if not r67.Running then
            return;
        end;
        r75 = not r39;
        if r75 then
            r40(true);
        end;
        w = r66;
        w.InputHoldBegin(w);
        r74 = true;
        task.wait(.12);
        v3 = r66;
        v3.InputHoldEnd(v3);
        r74 = false;
        task.wait(.15); 
    end);
    if r74 then
        pcall(function(...)
            v4 = r66;
            v4.InputHoldEnd(v4); 
        end);
    end;
    if r75 then
        r40(false);
    end;
    pcall(function(...)
        v4 = r68;
        v4.CameraType = r69;
        v4 = r68;
        v4.CameraSubject = r70;
        v4 = r68;
        v4.CFrame = r71;
        v4 = r68;
        v4.Focus = r72; 
    end);
    if not v9 then
        warn("Nightmare Circus: prompt interaction failed for " .. arg2_14.Name .. ": " .. tostring(y[2]));
    end;
    return v9; 
end;
local function r77(arg1_15, arg2_15, arg3_15, arg4_15, ...)
    r78 = arg1_15;
    r79 = arg2_15;
    r80 = arg3_15;
    r81 = arg4_15;
    if r29 then
        v4 = r29;
        v4.Running = false;
        if r29.StopAutomation then
            pcall(r29.StopAutomation);
        end;
        v5 = r29;
        while not v5 do
            if d then
                task.wait();
            end;
            r82 = {
                ["Running"] = true
            };
            v4 = r82;
            r29 = v4;
            F = xpcall(function(...)
                r46(r82);
                F = 32401793399536;
                K = "Character";
                w = r24[K];
                d = w;
                if w then
                    v3 = d.WaitForChild(d, "HumanoidRootPart");
                    K = r25(8);
                    if not K then
                        error("Section1 Games is not loaded yet");
                    end;
                    v5 = K.WaitForChild(K, r79, 10);
                    x = v5 and v5.WaitForChild(v5, r80, 10);
                    F = x and x.FindFirstChild(x, "ProximityPrompt", true);
                    if not F then
                        error("Missing ProximityPrompt for " .. r79);
                    end;
                    v3.CFrame = CFrame.new(r78);
                    v3.AssemblyLinearVelocity = Vector3.zero;
                    task.wait(0.5);
                    r83 = false;
                    task.spawn(function(...)
                        r84 = xpcall(function(...)
                            r81(r82); 
                        end, debug.traceback);
                        r85 = K[2];
                        r83 = true; 
                    end);
                    r65(F, v5, r82);
                    if not r64(v5) and v5.GetAttribute(v5, "Complete") ~= true then
                        warn("Nightmare Circus: start not confirmed for " .. r79 .. "; automation is still running");
                    end;
                    v6 = r82.Running;
                    d = not r83;
                    while not v6 do
                        if d then
                            task.wait(.1);
                        end;
                        if r83 and not r84 then
                            error(tostring(r85));
                            break;
                        end;
                        return; 
                    end;
                    d = not r83;
                else
                    w = r24.CharacterAdded;
                    d = w.Wait(w);
                end; 
            end, debug.traceback);
            J = r25(.1);
            u = v4;
            if F then
                d, v4 = J and J.FindFirstChild(J, r79) ~= nil, H[v5];
            end;
            if F then
                d = H[M] == r82;
            end;
            v4 = u;
            if u then
                v6 = r24.Character;
                if v6 then
                    d = v6.FindFirstChild(v6, "HumanoidRootPart");
                end;
                v4 = v6;
                v7 = v6;
                if v7 then
                    v7.CFrame = CFrame.new(r33());
                    v7.AssemblyLinearVelocity = Vector3.zero;
                end;
            end;
            d = r82;
            d.Running = false;
            d = r82;
            d.Cleaned = true;
            if r29 == r82 then
                H[M] = nil;
            end;
            if not F then
                warn("Nightmare Circus: " .. tostring(v6[2]));
                break;
            end;
            return; 
        end;
        d = not r29.Cleaned;
    end; 
end;
local r86 = {};
local v13 = r86;
v13[1] = "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")\n\nlocal Packet = require(\n    ReplicatedStorage:WaitForChild(\"modules\"):WaitForChild(\"Packet\")\n)\n\nlocal Basketball = workspace\n    :WaitForChild(\"Section1\")\n    :WaitForChild(\"Games\")\n    :WaitForChild(\"Basketball\")\n\nif _G.AutoBasketballStop then\n    _G.AutoBasketballStop()\nend\n\nlocal Controller = {\n    Running = true,\n    Active = false,\n    Completed = false\n}\n\n_G.AutoBasketball = Controller\n\nlocal PerfectTime = 1\nlocal CheckDelay = 0.01\nlocal Connections = {}\n\nlocal function IsComplete()\n    return Basketball:GetAttribute(\"Complete\") == true\nend\n\nfunction Controller.Stop()\n    if not Controller.Running then\n        return\n    end\n\n    Controller.Running = false\n    Controller.Active = false\n\n    for _, Connection in ipairs(Connections) do\n        Connection:Disconnect()\n    end\n\n    table.clear(Connections)\nend\n\n_G.AutoBasketballStop = Controller.Stop\n\nlocal function CheckCompletion()\n    if IsComplete() then\n        Controller.Completed = true\n        Controller.Stop()\n    end\nend\n\ntable.insert(\n    Connections,\n    Basketball:GetAttributeChangedSignal(\"Complete\"):Connect(\n        CheckCompletion\n    )\n)\n\nlocal function GetPhase()\n    return Basketball:GetAttribute(\"Phase\")\nend\n\nlocal function WaitForPhaseChange(OldPhase, Timeout)\n    local Start = os.clock()\n\n    while Controller.Running\n        and not IsComplete()\n        and GetPhase() == OldPhase\n        and os.clock() - Start < Timeout do\n        task.wait(CheckDelay)\n    end\nend\n\nlocal function WaitForIdle(Timeout)\n    local Start = os.clock()\n\n    while Controller.Running\n        and not IsComplete()\n        and GetPhase() ~= \"idle\"\n        and os.clock() - Start < Timeout do\n        task.wait(CheckDelay)\n    end\nend\n\nCheckCompletion()\n\ntask.spawn(function()\n    while Controller.Running do\n        if IsComplete() then\n            CheckCompletion()\n            break\n        end\n\n        if GetPhase() ~= \"idle\" then\n            Controller.Active = false\n            task.wait(CheckDelay)\n            continue\n        end\n\n        Controller.Active = true\n\n        local Success = pcall(function()\n            Packet.send.Section1.BasketballHold()\n        end)\n\n        if not Success then\n            task.wait(0.1)\n            continue\n        end\n\n        local StartTime = os.clock()\n\n        while Controller.Running\n            and not IsComplete()\n            and os.clock() - StartTime < PerfectTime do\n            task.wait()\n        end\n\n        if not Controller.Running or IsComplete() then\n            break\n        end\n\n        local Duration = os.clock() - StartTime\n\n        pcall(function()\n            Packet.send.Section1.BasketballRelease(Duration)\n        end)\n\n        WaitForPhaseChange(\"idle\", 0.5)\n        WaitForIdle(2)\n    end\n\n    Controller.Stop()\nend)\n\n";
local v14 = r86;
v14[2] = "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")\nlocal Packet = require(ReplicatedStorage:WaitForChild(\"modules\"):WaitForChild(\"Packet\"))\nlocal Game = workspace:WaitForChild(\"Section1\"):WaitForChild(\"Games\"):WaitForChild(\"PopTheBalloon\")\nlocal Balloons = Game:WaitForChild(\"Balloons\")\nif _G.AutoDartsStop then _G.AutoDartsStop() end\n\nlocal Controller = {Running = true, Active = false, Completed = false}\n_G.AutoDarts = Controller\n\nlocal THROW_DELAY = 0.05\nlocal CHECK_DELAY = 0.03\nlocal IDLE_DELAY = 0.1\n\nlocal Targets = {\n    {-0.8302127029982302, 0.858834508939232},\n    {-0.34659015274423904, 0.827476804554531},\n    {-0.014494814317703903, 0.8364363212223435},\n    {0.423985455702752, 0.9484285482390907},\n    {0.8044402336831856, 0.9529078636743922},\n    {-0.8560072541585854, 0.08384543182541498},\n    {-0.42074475654122223, 0.04352810508118887},\n    {-0.06286139171218387, 0.030089008748793566},\n    {0.49169604382818577, 0.039048203308529886},\n    {0.9011664245043618, 0.012169799260314236},\n    {-0.862456138268471, -0.8927305054917737},\n    {-0.38850114739818375, -0.8120959828597274},\n    {-0.05641298575249203, -0.8031367882999911},\n    {0.5594041977344515, -0.8389746133901842},\n    {0.8495776699292469, -0.888250948475415}\n}\n\nlocal Connections = {}\nlocal function IsComplete()\n    return Game:GetAttribute(\"Complete\") == true\nend\n\nfunction Controller.Stop()\n    if not Controller.Running then return end\n    Controller.Running = false\n    Controller.Active = false\n    for _, Connection in ipairs(Connections) do Connection:Disconnect() end\n    table.clear(Connections)\nend\n_G.AutoDartsStop = Controller.Stop\n\nlocal function CheckCompletion()\n    if IsComplete() then\n        Controller.Completed = true\n        Controller.Stop()\n    end\nend\n\ntable.insert(Connections, Game:GetAttributeChangedSignal(\"Complete\"):Connect(CheckCompletion))\n\nlocal function GetOrderedBalloons()\n    local List = {}\n    for _, Balloon in ipairs(Balloons:GetChildren()) do\n        if Balloon:IsA(\"BasePart\") then table.insert(List, Balloon) end\n    end\n    table.sort(List, function(A, B)\n        if math.abs(A.Position.Y - B.Position.Y) > 1 then\n            return A.Position.Y > B.Position.Y\n        end\n        return A.Position.X < B.Position.X\n    end)\n    return List\nend\n\nlocal function HasUnpoppedBalloons(List)\n    for _, Balloon in ipairs(List) do\n        if Balloon.Parent and Balloon:GetAttribute(\"Popped\") ~= true then return true end\n    end\n    return false\nend\n\nlocal function ThrowAt(Target)\n    if not Controller.Running or IsComplete() then return end\n    pcall(function()\n        Packet.send.Section1.DartsThrow(Target[1], Target[2])\n    end)\nend\n\nCheckCompletion()\ntask.spawn(function()\n    while Controller.Running do\n        if IsComplete() then CheckCompletion() break end\n        local Ordered = GetOrderedBalloons()\n        if not HasUnpoppedBalloons(Ordered) then\n            Controller.Active = false\n            task.wait(IDLE_DELAY)\n            continue\n        end\n        Controller.Active = true\n        for Index, Balloon in ipairs(Ordered) do\n            if not Controller.Running or IsComplete() then break end\n            if Balloon.Parent and Balloon:GetAttribute(\"Popped\") ~= true then\n                local Target = Targets[Index]\n                if Target then ThrowAt(Target) task.wait(THROW_DELAY) end\n            end\n        end\n        task.wait(CHECK_DELAY)\n    end\n    Controller.Stop()\nend)\n\n";
local v15 = r86;
v15[3] = "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")\n\nlocal Remote = ReplicatedStorage\n    :WaitForChild(\"modules\")\n    :WaitForChild(\"Packet\")\n    :WaitForChild(\"Reliable\")\n\nlocal DunkBooth = workspace\n    :WaitForChild(\"Section1\")\n    :WaitForChild(\"Games\")\n    :WaitForChild(\"DunkBooth\")\n\nif _G.AutoDunkStop then\n    _G.AutoDunkStop()\nend\n\nlocal Controller = {\n    Running = true,\n    Active = false,\n    Completed = false\n}\n\n_G.AutoDunk = Controller\n\nlocal THROW_DELAY = 0.55\nlocal CHECK_DELAY = 0.05\n\nlocal Connections = {}\n\nlocal function IsComplete()\n    return DunkBooth:GetAttribute(\"Complete\") == true\nend\n\nfunction Controller.Stop()\n    if not Controller.Running then\n        return\n    end\n\n    Controller.Running = false\n    Controller.Active = false\n\n    for _, Connection in ipairs(Connections) do\n        Connection:Disconnect()\n    end\n\n    table.clear(Connections)\nend\n\n_G.AutoDunkStop = Controller.Stop\n\nlocal function CheckCompletion()\n    if IsComplete() then\n        Controller.Completed = true\n        Controller.Stop()\n    end\nend\n\ntable.insert(\n    Connections,\n    DunkBooth:GetAttributeChangedSignal(\"Complete\"):Connect(\n        CheckCompletion\n    )\n)\n\nCheckCompletion()\n\ntask.spawn(function()\n    while Controller.Running do\n        if IsComplete() then\n            CheckCompletion()\n            break\n        end\n\n        Controller.Active = true\n\n        Remote:FireServer(\n            \"Section1/DunkThrow\",\n            0,\n            0\n        )\n\n        local Start = os.clock()\n\n        while Controller.Running\n            and not IsComplete()\n            and os.clock() - Start < THROW_DELAY do\n            task.wait(CHECK_DELAY)\n        end\n    end\n\n    Controller.Stop()\nend)\n\n";
local v16 = r86;
v16[4] = "local RS = game:GetService(\"ReplicatedStorage\")\n\nlocal Packet = require(\n    RS:WaitForChild(\"modules\"):WaitForChild(\"Packet\")\n)\n\nlocal Golf = workspace\n    :WaitForChild(\"Section1\")\n    :WaitForChild(\"Games\")\n    :WaitForChild(\"MiniGolf\")\n\nlocal Ball = Golf:WaitForChild(\"GolfBall\")\nlocal Hole = Golf:WaitForChild(\"Hole\")\n\nif _G.AutoMiniGolfStop then\n    _G.AutoMiniGolfStop()\nend\n\nlocal Controller = {\n    Running = true,\n    Active = false,\n    Completed = false\n}\n\n_G.AutoMiniGolf = Controller\n\nlocal LastShot = 0\nlocal Connections = {}\n\nlocal function IsComplete()\n    return Golf:GetAttribute(\"Complete\") == true\nend\n\nfunction Controller.Stop()\n    if not Controller.Running then\n        return\n    end\n\n    Controller.Running = false\n    Controller.Active = false\n\n    for _, Connection in ipairs(Connections) do\n        Connection:Disconnect()\n    end\n\n    table.clear(Connections)\nend\n\n_G.AutoMiniGolfStop = Controller.Stop\n\nlocal function CheckCompletion()\n    if IsComplete() then\n        Controller.Completed = true\n        Controller.Stop()\n    end\nend\n\ntable.insert(\n    Connections,\n    Golf:GetAttributeChangedSignal(\"Complete\"):Connect(\n        CheckCompletion\n    )\n)\n\nlocal function shoot()\n    if not Controller.Running or IsComplete() then\n        return\n    end\n\n    local difference = Hole.Position - Ball.Position\n\n    local direction = Vector3.new(\n        difference.X,\n        0,\n        difference.Z\n    )\n\n    if direction.Magnitude < 0.05 then\n        return\n    end\n\n    direction = direction.Unit\n\n    local distance = (\n        Vector3.new(Hole.Position.X, 0, Hole.Position.Z)\n        - Vector3.new(Ball.Position.X, 0, Ball.Position.Z)\n    ).Magnitude\n\n    local power = math.clamp(distance / 60, 0.1, 1)\n\n    Ball.AssemblyLinearVelocity = direction * (power * 100)\n\n    Packet.send.Section1.MiniGolfShot(direction, power)\nend\n\nCheckCompletion()\n\ntask.spawn(function()\n    while Controller.Running do\n        if IsComplete() then\n            CheckCompletion()\n            break\n        end\n\n        Controller.Active = true\n\n        if os.clock() - LastShot >= 0.5 then\n            LastShot = os.clock()\n            pcall(shoot)\n        end\n\n        task.wait(0.05)\n    end\n\n    Controller.Stop()\nend)\n\n";
local v17 = r86;
v17[5] = "local Players = game:GetService(\"Players\")\nlocal ReplicatedStorage = game:GetService(\"ReplicatedStorage\")\nlocal Player = Players.LocalPlayer\nlocal Remote = ReplicatedStorage:WaitForChild(\"modules\"):WaitForChild(\"Packet\"):WaitForChild(\"Reliable\")\nlocal Packet = require(ReplicatedStorage:WaitForChild(\"modules\"):WaitForChild(\"Packet\"))\nlocal Section1 = workspace:WaitForChild(\"Section1\")\nlocal HighStriker = Section1:WaitForChild(\"Games\"):WaitForChild(\"High Striker\")\nlocal Prompt = HighStriker:WaitForChild(\"ProxPart\"):WaitForChild(\"ProximityPrompt\")\n\nif _G.AutoHighStrikerStop then _G.AutoHighStrikerStop() end\n\nlocal Controller = {Running=true, Active=false, Avoiding=false, Completed=false}\n_G.AutoHighStriker = Controller\n\nlocal BOOTH_POSITION = Vector3.new(-31.978, 32.859, 28.214)\nlocal function GetSafePosition()\n    return _G.ToolboxCircusGetSafeZone and _G.ToolboxCircusGetSafeZone()\n        or Vector3.new(-135.193, 28.701, -50.983)\nend\nlocal DANGER_DISTANCE = 40\nlocal RESUME_DISTANCE = 60\nlocal CLICK_DELAY = 0.05\nlocal CHECK_DELAY = 0.05\nlocal TELEPORT_DELAY = 0.4\nlocal START_TIMEOUT = 8\nlocal Connections = {}\n\nlocal function GetRoot()\n    local character=Player.Character\n    return character and character:FindFirstChild(\"HumanoidRootPart\")\nend\nlocal function IsComplete()\n    return HighStriker:GetAttribute(\"Complete\")==true\nend\nlocal function GetRonniePosition()\n    local monster=Section1:FindFirstChild(\"Monster\")\n    local ronnie=monster and monster:FindFirstChild(\"Ronnie\")\n    if not ronnie then return nil end\n    if ronnie:IsA(\"BasePart\") then return ronnie.Position end\n    if ronnie:IsA(\"Model\") then\n        local part=ronnie:FindFirstChild(\"HumanoidRootPart\")\n            or ronnie.PrimaryPart\n            or ronnie:FindFirstChildWhichIsA(\"BasePart\",true)\n        return part and part.Position\n    end\nend\nlocal function RonnieDistance(position)\n    local monsterPosition=GetRonniePosition()\n    return monsterPosition and (monsterPosition-position).Magnitude or math.huge\nend\nlocal function IsDangerous()\n    local root=GetRoot()\n    if not root then return true end\n    return RonnieDistance(root.Position)<=DANGER_DISTANCE\n        or RonnieDistance(BOOTH_POSITION)<=DANGER_DISTANCE\nend\nlocal function IsSafeToResume()\n    return RonnieDistance(BOOTH_POSITION)>=RESUME_DISTANCE\nend\nlocal function Teleport(position)\n    local root=GetRoot()\n    if not root then return false end\n    root.CFrame=CFrame.new(position)\n    root.AssemblyLinearVelocity=Vector3.zero\n    root.AssemblyAngularVelocity=Vector3.zero\n    return true\nend\nlocal function WaitFor(seconds)\n    local started=os.clock()\n    while Controller.Running and not IsComplete() and os.clock()-started<seconds do\n        task.wait(CHECK_DELAY)\n    end\n    return Controller.Running and not IsComplete()\nend\nfunction Controller.Stop()\n    if not Controller.Running then return end\n    Controller.Running=false\n    Controller.Active=false\n    Controller.Avoiding=false\n    for _,connection in ipairs(Connections) do connection:Disconnect() end\n    table.clear(Connections)\nend\n_G.AutoHighStrikerStop=Controller.Stop\n\nlocal function CheckCompletion()\n    if IsComplete() then\n        Controller.Completed=true\n        Teleport(GetSafePosition())\n        Controller.Stop()\n    end\nend\nlocal function ExitMinigame()\n    Controller.Active=false\n    local section=Packet.send and Packet.send.Section1\n    local leave=section and section.HighStrikerLeave\n    if type(leave)==\"function\" then pcall(leave) end\nend\nlocal function Retreat()\n    if not Controller.Running then return end\n    Controller.Avoiding=true\n    ExitMinigame()\n    Teleport(GetSafePosition())\nend\nlocal function WaitUntilSafe()\n    Retreat()\n    while Controller.Running and not IsComplete() do\n        if IsSafeToResume() then\n            Controller.Avoiding=false\n            return true\n        end\n        task.wait(CHECK_DELAY)\n    end\n    return false\nend\nlocal function IsActivePhase()\n    local phase=HighStriker:GetAttribute(\"Phase\")\n    return phase==\"idle\" or phase==\"windup\" or phase==\"slam\"\nend\nlocal function StartMinigame()\n    if IsDangerous() then return false end\n    if not Teleport(BOOTH_POSITION) then return false end\n    if not WaitFor(TELEPORT_DELAY) then return false end\n    if IsDangerous() then Retreat() return false end\n    if not IsActivePhase() then\n        pcall(function()\n            local previous = Prompt.HoldDuration\n            Prompt.HoldDuration = 0\n            Prompt:InputHoldBegin()\n            task.wait(0.12)\n            Prompt:InputHoldEnd()\n            Prompt.HoldDuration = previous\n        end)\n    end\n    local started=os.clock()\n    while Controller.Running and not IsComplete() and os.clock()-started<START_TIMEOUT do\n        if IsDangerous() then Retreat() return false end\n        if IsActivePhase() then return true end\n        task.wait(CHECK_DELAY)\n    end\n    return false\nend\ntable.insert(Connections,HighStriker:GetAttributeChangedSignal(\"Complete\"):Connect(CheckCompletion))\nCheckCompletion()\n\ntask.spawn(function()\n    while Controller.Running do\n        if IsComplete() then CheckCompletion() break end\n        if IsDangerous() and not WaitUntilSafe() then break end\n        if not Controller.Running then break end\n        local started=StartMinigame()\n        if started then\n            Controller.Active=true\n            local lastActive=os.clock()\n            while Controller.Running and not IsComplete() do\n                if IsDangerous() then Retreat() break end\n                local phase=HighStriker:GetAttribute(\"Phase\")\n                if IsActivePhase() then lastActive=os.clock() end\n                if phase==nil or os.clock()-lastActive>3 then\n                    Controller.Active=false\n                    break\n                end\n                if phase==\"idle\" or phase==\"windup\" then\n                    pcall(function() Remote:FireServer(\"Section1/HighStrikerClick\") end)\n                end\n                task.wait(CLICK_DELAY)\n            end\n        end\n        Controller.Active=false\n        if not WaitFor(0.3) then break end\n    end\n    Controller.Stop()\nend)\n\n";
local v18 = r86;
v18[6] = "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")\n\nlocal Reliable = ReplicatedStorage\n    :WaitForChild(\"modules\")\n    :WaitForChild(\"Packet\")\n    :WaitForChild(\"Reliable\")\n\nlocal RingToss = workspace\n    :WaitForChild(\"Section1\")\n    :WaitForChild(\"Games\")\n    :WaitForChild(\"RingToss\")\n\nlocal Bottles = RingToss:WaitForChild(\"Bottles\")\n\nif _G.AutoRingTossStop then\n    _G.AutoRingTossStop()\nend\n\nlocal Controller = {\n    Running = true,\n    Completed = false,\n    Throws = 0,\n    Remaining = 0\n}\n\n_G.AutoRingToss = Controller\n\nlocal Targets = {\n    {-0.7599205563588964, 0.05620804191990332},\n    {-0.33349659719571545, 0.05176755345680496},\n    {0.02020419993316347, 0.05844950845295732},\n    {0.48298954213791445, 0.08154461498964916},\n    {0.6383536509072825, 0.055650840090079735},\n    {-0.009546382510995599, 0.31133286824280565}\n}\n\nlocal THROW_DELAY = 1\nlocal CHECK_DELAY = 0.05\n\nfunction Controller.Stop()\n    Controller.Running = false\nend\n\n_G.AutoRingTossStop = Controller.Stop\n\nlocal function IsComplete()\n    return RingToss:GetAttribute(\"Complete\") == true\nend\n\nlocal function GetRemainingBottles()\n    local Remaining = {}\n\n    for _, Bottle in ipairs(Bottles:GetChildren()) do\n        if Bottle:IsA(\"BasePart\")\n            and Bottle:GetAttribute(\"Ringed\") ~= true then\n\n            table.insert(Remaining, Bottle)\n        end\n    end\n\n    Controller.Remaining = #Remaining\n\n    return Remaining\nend\n\nlocal function WaitFor(Seconds)\n    local Start = os.clock()\n\n    while Controller.Running\n        and os.clock() - Start < Seconds do\n\n        task.wait(CHECK_DELAY)\n    end\n\n    return Controller.Running\nend\n\ntask.spawn(function()\n    while Controller.Running do\n        if IsComplete() then\n            Controller.Completed = true\n            break\n        end\n\n        local Remaining = GetRemainingBottles()\n\n        if #Remaining == 0 then\n            if not WaitFor(0.5) then\n                break\n            end\n\n            if IsComplete() then\n                Controller.Completed = true\n                break\n            end\n        else\n            for _, Target in ipairs(Targets) do\n                if not Controller.Running or IsComplete() then\n                    break\n                end\n\n                Remaining = GetRemainingBottles()\n\n                if #Remaining == 0 then\n                    break\n                end\n\n                Reliable:FireServer(\n                    \"Section1/RingThrow\",\n                    Target[1],\n                    Target[2]\n                )\n\n                Controller.Throws += 1\n\n                if not WaitFor(THROW_DELAY) then\n                    break\n                end\n            end\n        end\n    end\n\n    Controller.Running = false\nend)\n\n";
local v19 = r86;
v19[7] = "local ReplicatedStorage = game:GetService(\"ReplicatedStorage\")\n\nlocal Remote = ReplicatedStorage\n    :WaitForChild(\"modules\")\n    :WaitForChild(\"Packet\")\n    :WaitForChild(\"Reliable\")\n\nlocal WhackGame = workspace\n    :WaitForChild(\"Section1\")\n    :WaitForChild(\"Games\")\n    :WaitForChild(\"WhackAClown\")\n\nlocal Clowns = WhackGame:WaitForChild(\"Clowns\")\n\nif _G.AutoWhackStop then\n    _G.AutoWhackStop()\nend\n\nlocal Controller = {\n    Running = true,\n    Active = false,\n    Completed = false\n}\n\n_G.AutoWhack = Controller\n\nlocal HIT_DELAY = 0.13\nlocal CHECK_DELAY = 0.03\nlocal IDLE_DELAY = 0.1\n\nlocal LastHit = {}\nlocal Connections = {}\n\nlocal function IsComplete()\n    return WhackGame:GetAttribute(\"Complete\") == true\nend\n\nfunction Controller.Stop()\n    if not Controller.Running then\n        return\n    end\n\n    Controller.Running = false\n    Controller.Active = false\n\n    for _, Connection in ipairs(Connections) do\n        Connection:Disconnect()\n    end\n\n    table.clear(Connections)\nend\n\n_G.AutoWhackStop = Controller.Stop\n\nlocal function CheckCompletion()\n    if IsComplete() then\n        Controller.Completed = true\n        Controller.Stop()\n    end\nend\n\ntable.insert(\n    Connections,\n    WhackGame:GetAttributeChangedSignal(\"Complete\"):Connect(\n        CheckCompletion\n    )\n)\n\nlocal function HitClown(Clown)\n    if not Controller.Running\n        or IsComplete()\n        or not Clown.Parent\n        or Clown:GetAttribute(\"Active\") ~= true then\n        return\n    end\n\n    local Now = os.clock()\n\n    if Now - (LastHit[Clown] or -math.huge) < HIT_DELAY then\n        return\n    end\n\n    LastHit[Clown] = Now\n\n    Remote:FireServer(\n        \"Section1/Whack\",\n        Clown\n    )\nend\n\nlocal function CheckClowns()\n    local FoundActive = false\n\n    for _, Clown in ipairs(Clowns:GetChildren()) do\n        if not Controller.Running or IsComplete() then\n            break\n        end\n\n        if Clown:IsA(\"Model\")\n            and Clown:GetAttribute(\"Active\") == true then\n\n            FoundActive = true\n            HitClown(Clown)\n        end\n    end\n\n    return FoundActive\nend\n\nCheckCompletion()\n\ntask.spawn(function()\n    while Controller.Running do\n        Controller.Active = CheckClowns()\n\n        if Controller.Active then\n            task.wait(CHECK_DELAY)\n        else\n            task.wait(IDLE_DELAY)\n        end\n    end\n\n    Controller.Stop()\nend)\n\n";
local function r99(arg1_25, ...)
    v1 = arg1_25;
    v4 = workspace;
    K = v4;
    w = v4.WaitForChild(v4, "Section2", v1 or 8);
    if w then
        F = workspace;
        d = w.WaitForChild(w, "MainObjective", v1 or 8);
    end;
    v4 = v4;
    return w; 
end;
local r100 = 0;
local function r101(arg1_26, ...)
    v1 = arg1_26;
    w = r24.Character;
    d = w;
    if w then
        v3 = w.WaitForChild(w, "HumanoidRootPart");
        v3.CFrame = CFrame.new(arg1_26);
        v3.AssemblyLinearVelocity = Vector3.zero;
        return;
    else
        w = r24.CharacterAdded;
        d = w.Wait(w);
    end; 
end;
local function r102(arg1_27, arg2_27, arg3_27, arg4_27, arg5_27, ...)
    r103 = arg1_27;
    r104 = arg2_27;
    r105 = arg3_27;
    r106 = arg4_27;
    r107 = arg5_27;
    task.spawn(function(...)
        if r29 then
            v4 = r29;
            v4.Running = false;
            if r29.StopAutomation then
                pcall(r29.StopAutomation);
            end;
            v1 = r29;
            d = v1;
            while not v1 do
                if d then
                    task.wait();
                end;
                r100 = r100 + 1;
                r108 = {
                    ["Running"] = true,
                    ["Cleaned"] = false
                };
                r29 = r108;
                w = r99(8);
                if not w then
                    warn("Circus Tent: Section2 MainObjective is not loaded yet");
                    d = r108;
                    d.Cleaned = true;
                    if r29 == r108 then
                        break;
                    end;
                    return;
                end;
                r109 = w.WaitForChild(w, r103, 8);
                if not r109 then
                    warn("Circus Tent: " .. r103 .. " is not loaded yet");
                    v3 = r108;
                    v3.Cleaned = true;
                    if r29 == r108 then
                        break;
                    end;
                    return;
                end;
                v5 = r108;
                v5.StopAutomation = function(...)
                    if r106 and type(_G[r106]) == "function" then
                        pcall(_G[r106]);
                    end; 
                end;
                W = r109;
                v5 = W.GetAttribute(W, "Complete") == true;
                W = r108;
                W.Running = false;
                r108.StopAutomation();
                W = r108;
                W.Cleaned = true;
                if r29 == r108 then
                end;
                if not xpcall(function(...)
                    r46(r108);
                    r101(r104);
                    task.wait(0.5);
                    v4 = r109;
                    v1 = v4.WaitForChild(v4, "PromptPart", 10);
                    w = v1 and v1.FindFirstChildWhichIsA(v1, "ProximityPrompt", true);
                    if not w then
                        error("Missing " .. r103 .. " ProximityPrompt");
                    end;
                    v3 = r105 and r105(r108, r109);
                    r65(w, r109, r108);
                    if v3 then
                        v3();
                    end;
                    if r107 then
                        return;
                    end;
                    K = r108.Running;
                    d = r109.Parent;
                    while not K do
                        if d then
                            d = r109;
                            if d.GetAttribute(d, "Complete") == true then
                                break;
                            else
                                task.wait(.05);
                            end;
                        end;
                        return; 
                    end;
                    d = r109.Parent; 
                end, debug.traceback) then
                    warn("Circus Tent " .. r103 .. ": " .. tostring(u[2]));
                    break;
                end;
                return; 
            end;
            d = not r29.Cleaned;
        end; 
    end); 
end;
local function r110(arg1_28, arg2_28, arg3_28, arg4_28, ...)
    r111 = arg1_28;
    r112 = arg2_28;
    r113 = arg3_28;
    r114 = arg4_28;
    return function(arg1_29, arg2_29, ...)
        r115 = arg1_29;
        r116 = arg2_29;
        if type(_G[r112]) == "function" then
            pcall(_G[r112]);
        end;
        r117 = {
            ["Running"] = true,
            ["Completed"] = false
        };
        v4 = _G;
        v4[r111] = r117;
        v4 = _G;
        v4[r112] = function(...)
            v4 = r117;
            v4.Running = false; 
        end;
        return function(...)
            local n = {
                n[1],
                n[2],
                n[3],
                1,
                136,
                124,
                125,
                2
            };
            task.spawn(function(...)
                local n = {
                    n[3],
                    n[1],
                    n[2],
                    1,
                    136,
                    124,
                    125,
                    2
                };
                v1 = H[n[2]];
                w = v1.WaitForChild(v1, "modules");
                r118 = require(w.WaitForChild(w, "Packet"));
                w = not r115.Running;
                d = not r117.Running;
                while w do
                    if d then
                        break;
                    else
                        if pcall(function(...)
                            r118.send.Section2[r113](); 
                        end) then
                            v4 = r117;
                            v4.Completed = true;
                        end;
                        K = r114;
                        if not K or K.GetAttribute(K, "Complete") == true then
                            break;
                        else
                            task.wait(0.5);
                            if not r115.Running or not r117.Running then
                                v4 = r117;
                                v4.Running = false;
                                return;
                            end;
                        end;
                    end; 
                end;
                d = not r117.Running; 
            end); 
        end; 
    end; 
end;
local function r119(arg1_30, arg2_30, ...)
    r120 = arg1_30;
    w = arg2_30;
    if type(_G.AutoEyePuzzleStop) == "function" then
        pcall(_G.AutoEyePuzzleStop);
    end;
    v3 = w.WaitForChild(w, "Mirrors");
    r121 = w.WaitForChild(w, "EyeStatues");
    r122 = 0.5;
    r123 = .15;
    r124 = 2;
    v6 = r32();
    if v6 then
    end;
    v4 = 2;
    r125 = v6 or nil;
    r126 = {
        ["Running"] = true,
        ["Recording"] = true,
        ["Solving"] = false,
        ["Completed"] = false,
        ["Sequence"] = {},
        ["CurrentStep"] = 0,
        ["CurrentStatue"] = nil
    };
    v4 = _G;
    v4.AutoEyePuzzle = r126;
    r127 = {};
    r128 = {};
    r129 = {};
    r130 = {};
    r132 = 0;
    local function r133(arg1_31, ...)
        v4 = r121;
        return v4.FindFirstChild(v4, "Eye" .. arg1_31); 
    end;
    local function r134(arg1_32, ...)
        v1 = arg1_32;
        for w = 1, 4 do
            F = r133(w);
            if F then
                W = r130[w];
                if not W or not W.Parent then
                    W = Instance.new("Highlight");
                    W.Name = "AutoEyeHighlight";
                    J = d;
                    W.FillColor = Color3.fromRGB(255, 255, 0);
                    W.OutlineColor = Color3.fromRGB(255, 255, 0);
                    W.FillTransparency = .6;
                    W.OutlineTransparency = 0;
                    W.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                    W.Parent = F;
                    v4 = r130;
                    v4[w] = W;
                end;
                W.Enabled = w == arg1_32;
            end; 
        end; 
    end;
    local function r135(...)
        if r131 then
            v4 = r131;
            v4.Disconnect(v4);
        end; 
    end;
    d = r126;
    d.Stop = function(...)
        v4 = r126;
        v4.Running = false;
        v4 = r126;
        v4.Recording = false;
        r135();
        d = ("q\xaeA\x8d\x1c\x87Ҧm")[1];
        for w, v5 in ipairs(r127) do
            K = w;
            v5.Disconnect(v5); 
        end;
        table.clear(r127);
        for v3, v5 in pairs(r130) do
            K = v3;
            if v5 then
                x = "Parent";
            end;
            if v5 then
                v5.Destroy(v5);
            end; 
        end;
        table.clear(r130); 
    end;
    v4 = _G;
    v4.AutoEyePuzzleStop = r126.Stop;
    local function r136(...)
        r135();
        r134(nil);
        v4 = r126;
        v4.Solving = false;
        v4 = r126;
        v4.Completed = true;
        v4 = r126;
        v4.CurrentStep = 0;
        v4 = r126;
        v4.CurrentStatue = nil;
        v4 = r126;
        v4.Recording = true;
        table.clear(r126.Sequence);
        table.clear(r129); 
    end;
    local function r137(...)
        if not r126.Running or (not r120.Running or not r126.Solving) then
            return;
        end;
        r135();
        v4 = r126;
        d = "CurrentStep";
        v4[d] = v4[d] + 1;
        if r126.CurrentStep > #r126.Sequence then
            r136();
            return;
        end;
        w = r125[r126.Sequence[r126.CurrentStep]];
        v4 = r126;
        v4.CurrentStatue = w;
        r134(w);
        v3 = r133(w);
        K = v3 and v3.FindFirstChildWhichIsA(v3, "ProximityPrompt", true);
        if not K then
            warn("Missing ProximityPrompt for Eye" .. tostring(w));
            return;
        end;
        r138 = false;
        r139 = r126.CurrentStep;
        v4 = "Triggered";
        r131 = v4.Connect(v4, function(...)
            if r138 or (not r126.Running or (not r120.Running or (not r126.Solving or r126.CurrentStep ~= r139))) then
                return;
            end;
            r138 = true;
            task.defer(function(...)
                if r126.Running and r120.Running then
                    r137();
                end; 
            end); 
        end); 
    end;
    local function r140(arg1_33, ...)
        v1 = arg1_33;
        if not r126.Running or (not r126.Recording or r126.Solving) then
            return;
        end;
        v4 = os.clock;
        K, w = w - (r129[v1] or 0) < r123, v4();
        if w - (r129[v1] or 0) < r123 then
            return;
        end;
        d = r129;
        d[v1] = w;
        r132 = w;
        print("Mirror", v1, "flashed");
        table.insert(r126.Sequence, v1); 
    end;
    for P = 1, 4 do
        r141 = P;
        V6 = 18751857222172;
        v = v3.FindFirstChild(v3, "Mirror" .. r141);
        if v then
            d = v.FindFirstChild(v, "Eye");
        end;
        if v then
            d = v.FindFirstChild(v, "Part");
        end;
        r142 = E;
        i = r142;
        if i then
            i = r142;
            d = i.IsA(i, "BasePart");
        end;
        local function v4(...)
            if not r126.Running or (not r120.Running or not r126.Solving) then
                return;
            end;
            H[Y]();
            v4 = r126;
            d = "CurrentStep";
            v4[d] = v4[d] + 1;
            if r126.CurrentStep > #r126.Sequence then
                H[l]();
                return;
            end;
            w = r125[r126.Sequence[r126.CurrentStep]];
            v4 = r126;
            v4.CurrentStatue = w;
            H[O](w);
            v3 = H[M](w);
            K = v3 and v3.FindFirstChildWhichIsA(v3, "ProximityPrompt", true);
            if not K then
                warn("Missing ProximityPrompt for Eye" .. tostring(w));
                return;
            end;
            r138 = false;
            r139 = r126.CurrentStep;
            v4 = "Triggered";
            r131 = v4.Connect(v4, function(...)
                if r138 or (not r126.Running or (not r120.Running or (not r126.Solving or r126.CurrentStep ~= r139))) then
                    return;
                end;
                r138 = true;
                task.defer(function(...)
                    if r126.Running and r120.Running then
                        H[L]();
                    end; 
                end); 
            end); 
        end;
        if i then
            d = r128;
            d[r141] = r142.Transparency < r122;
            e6 = r142;
            V6 = e6.GetPropertyChangedSignal(e6, "Transparency");
            table.insert(r127, V6.Connect(V6, function(...)
                if not r126.Running then
                    return;
                end;
                v1 = r142.Transparency < r122;
                if v1 then
                    d = not r128[r141];
                end;
                if v1 then
                    r140(r141);
                end;
                v4 = r128;
                v4[r141] = v1; 
            end));
        end; 
    end;
    return function(...)
        task.spawn(function(...)
            v1 = r120.Running;
            d = r126.Running;
            while not v1 do
                if v1 then
                    if r126.Recording and (#r126.Sequence > 0 and os.clock() - r132 >= r124) then
                        v4 = r126;
                        v4.Recording = false;
                        v4 = r126;
                        v4.Solving = true;
                        v4 = r126;
                        v4.Completed = false;
                        v4 = r126;
                        v4.CurrentStep = 0;
                        r137();
                    end;
                    task.wait(.05);
                end;
                r126.Stop();
                return; 
            end;
            d = r126.Running; 
        end); 
    end; 
end;
ok[2], v20 = 5465413028337, nil;
ok[3], ok[1] = "ե\xff\xd6\r凮", "e%\x18_\xa2n\xcc\xd0x\xb7\xf4\xb5";
ok[2] = "UT%\x02\x18\x8f:4b\xc9$\xcf";
ok[1] = 9604880454008;
ok[1] = function(arg1_34, ...)
    r36(arg1_34); 
end;
v3.RegisterCategories(v3, {
    {
        ["name"] = "Auto MiniGames",
        ["items"] = {
            v20("Auto Basketball", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(65.986, 38.742, -84.227), "Basketball", "PromptPart", function(arg1_35, ...)
                        return H[46](arg1_35); 
                    end); 
                end); 
            end),
            v20("Auto Balloon Dart", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(-255.939, 14.934, -103.819), "PopTheBalloon", "Camera", function(arg1_36, ...)
                        return H[47](arg1_36); 
                    end); 
                end); 
            end),
            v20("Auto DunkBall", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(-87.302, 16.232, 101.158), "DunkBooth", "ProxPart", function(arg1_37, ...)
                        return H[48](arg1_37); 
                    end); 
                end); 
            end),
            v20("Auto MiniGolf", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(24.744, 9.068, 115.494), "MiniGolf", "ProxPart", function(arg1_38, ...)
                        return H[49](arg1_38); 
                    end); 
                end); 
            end),
            v20("Auto Highstriker", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(-31.978, 32.859, 28.214), "High Striker", "ProxPart", function(arg1_39, ...)
                        return H[51](arg1_39); 
                    end); 
                end); 
            end),
            v20("Auto Ringtoss", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(-325.75, 17.284, 141.52), "RingToss", "ring", function(arg1_40, ...)
                        return H[52](arg1_40); 
                    end); 
                end); 
            end),
            v20("Auto Whack a Clown", function(...)
                task.spawn(function(...)
                    r77(Vector3.new(-63.946, 17.123, -150.882), "WhackAClown", "Hammer", function(arg1_41, ...)
                        return H[53](arg1_41); 
                    end); 
                end); 
            end)
        }
    },
    {
        ["name"] = "Circus Tent",
        ["items"] = {
            v20("Auto Star Puzzle", function(...)
                r102("Puzzle1", Vector3.new(1575.572, -43.723, 4276.123), r110("AutoStarPuzzle", "AutoStarPuzzleStop", "StarPuzzleComplete", false), "AutoStarPuzzleStop"); 
            end),
            v20("Auto Moon Puzzle", function(...)
                r102("Puzzle3", Vector3.new(1683.405, -45.787, 4499.757), r110("AutoMoonPuzzle", "AutoMoonPuzzleStop", "MoonPuzzleComplete", true), "AutoMoonPuzzleStop"); 
            end),
            v20("Auto Faith Puzzle", function(...)
                r102("Puzzle4", Vector3.new(1830.749, -63.622, 4599.413), r110("AutoTarotPuzzle", "AutoTarotPuzzleStop", "TarotPuzzleComplete", false), "AutoTarotPuzzleStop"); 
            end),
            v20("Eye Puzzle Helper", function(...)
                r102("Puzzle2", Vector3.new(1818.316, -67.9, 4526.75), r119, "AutoEyePuzzleStop"); 
            end),
            v20("Blue Ball", function(...)
                r102("CrystalBallWish", Vector3.new(1848.402, -65.07, 4345.935), nil, nil, true); 
            end)
        }
    },
    {
        ["name"] = "Arena",
        ["items"] = {
            {
                ["label"] = "God of War",
                ["type"] = "one_time_action",
                ["enabled"] = false,
                ["has_shortcut"] = false,
                [r15[r16(ok[1], ok[2])]] = function(...)
                    if _G.DimitraKillAuraStop then
                        _G.DimitraKillAuraStop();
                    end;
                    v4 = game;
                    v1 = v4.GetService(v4, "CollectionService");
                    v4 = game;
                    v3 = r26;
                    K = v3.WaitForChild(v3, "modules");
                    r143 = require(K.WaitForChild(K, "Packet"));
                    r144 = 15;
                    r145 = .01;
                    r146 = .01;
                    r147 = 3;
                    r148 = true;
                    r149 = 0;
                    r150 = 0;
                    r151 = {
                        "PlayerHitbox",
                        "LeftArmHitbox",
                        "RightArmHitbox"
                    };
                    r152 = {
                        "Hitbox",
                        "KILL_BOX",
                        "HitBox"
                    };
                    r153 = {};
                    r154 = {};
                    r155 = {};
                    local function r156(arg1_42, arg2_42, ...)
                        w, v1 = arg2_42, arg1_42;
                        if w.IsA(w, "Model") then
                            v1[w] = true;
                        end; 
                    end;
                    local function r157(arg1_43, arg2_43, ...)
                        v1 = arg1_43;
                        v1[arg2_43] = nil; 
                    end;
                    g = "AI_DimitraBoss";
                    Y, d = g[2], g[1];
                    for l, P in ipairs(v1.GetTagged(v1, g)) do
                        r156(r153, P);
                        g, P = l, nil; 
                    end;
                    for L, P in ipairs(v1.GetTagged(v1, "AI_DimitraShadow")) do
                        g = L;
                        r156(r154, P); 
                    end;
                    L = v1.GetInstanceAddedSignal(v1, "AI_DimitraBoss");
                    table.insert(r155, L.Connect(L, function(arg1_44, ...)
                        r156(r153, arg1_44); 
                    end));
                    L = v1.GetInstanceRemovedSignal(v1, "AI_DimitraBoss");
                    table.insert(r155, L.Connect(L, function(arg1_45, ...)
                        r157(r153, arg1_45); 
                    end));
                    L = v1.GetInstanceAddedSignal(v1, "AI_DimitraShadow");
                    table.insert(r155, L.Connect(L, function(arg1_46, ...)
                        r156(r154, arg1_46); 
                    end));
                    L = v1.GetInstanceRemovedSignal(v1, "AI_DimitraShadow");
                    table.insert(r155, L.Connect(L, function(arg1_47, ...)
                        r157(r154, arg1_47); 
                    end));
                    local function r158(...)
                        v1 = r24.Character;
                        if not v1 then
                            return nil;
                        end;
                        w = v1.FindFirstChildOfClass(v1, "Humanoid");
                        if not w or w.Health <= 0 then
                            return nil;
                        end;
                        return v1.FindFirstChild(v1, "HumanoidRootPart"); 
                    end;
                    local function r159(...)
                        v1 = r24.Character;
                        if v1 then
                            d = v1.FindFirstChild(v1, "MagicAxe") ~= nil;
                        end;
                        return v1; 
                    end;
                    local function r160(arg1_48, arg2_48, arg3_48, ...)
                        v3, v1 = arg3_48, arg1_48;
                        if not v1 or not v1.Parent then
                            return false;
                        end;
                        x = "ipairs";
                        for v5, W in ipairs(arg2_48) do
                            J = v1.FindFirstChild(v1, W, true);
                            if J then
                                u = J.IsA(J, "BasePart");
                            end;
                            if J then
                                if (J.GetClosestPointOnSurface(J, v3) - v3).Magnitude <= r144 then
                                    return true;
                                end;
                            end; 
                        end;
                        return false; 
                    end;
                    local function r161(arg1_49, ...)
                        if os.clock() - r149 < r145 then
                            return;
                        end;
                        x = {
                            pairs(r153)
                        };
                        K = pairs(r153)(x[2], x[3]);
                        while K do
                            if r160(x, r151, arg1_49) then
                                r149 = os[r15[r16("\xcf}3\xe8\xe8", F)]]();
                                r143.send.MagicAxe.SwingHit();
                                return;
                            end; 
                        end; 
                    end;
                    local function r162(arg1_50, ...)
                        w = os.clock();
                        if w - r150 < r145 then
                            return;
                        end;
                        F = {
                            pairs(r154)
                        };
                        K = F[2];
                        v5 = pairs(r154)(K, F[3]);
                        while v5 do
                            if r160(F, r152, arg1_50) then
                                r143.send.MagicAxe.SlashShadow(F);
                                v3 = true;
                            end; 
                        end;
                        if false then
                            K = os.clock();
                        end; 
                    end;
                    local function r163(...)
                        if not r159() then
                            return;
                        end;
                        v1 = r158();
                        if not v1 then
                            return;
                        end;
                        r161(v1.Position);
                        r162(v1.Position); 
                    end;
                    local function r164(...)
                        v1 = r24.Character;
                        if not v1 then
                            return nil;
                        end;
                        w = v1.FindFirstChildOfClass(v1, "Humanoid");
                        K = not w;
                        v3 = v1.FindFirstChild(v1, "HumanoidRootPart");
                        if K then
                            if K then
                                return nil;
                            end;
                            return v1, w, v3;
                        else
                            v1.FindFirstChild(v1, r15[v5]);
                            d = w.Health <= 0 or not v3;
                        end; 
                    end;
                    v = v4.GetService(v4, "RunService").Heartbeat;
                    table.insert(r155, v.Connect(v, function(...)
                        if not r148 then
                            return;
                        end;
                        v3 = {
                            r164()
                        };
                        w = v3[3];
                        v3 = r164();
                        if not w then
                            return;
                        end;
                        K = v3[2].MoveDirection;
                        if K.Magnitude > .01 then
                            w.CFrame = w.CFrame + K * r147;
                        end; 
                    end));
                    task.spawn(function(...)
                        while r148 do
                            pcall(r163);
                            task.wait(r146); 
                        end; 
                    end);
                    v4 = _G;
                    v4.DimitraKillAuraStop = function(...)
                        r148 = false;
                        for v3, v5 in ipairs(r155) do
                            K = v3;
                            v5.Disconnect(v5); 
                        end;
                        table.clear(r155);
                        table.clear(r153);
                        table.clear(r154);
                        d = _G;
                        d.DimitraKillAuraStop = nil; 
                    end; 
                end
            }
        }
    },
    {
        ["name"] = "Misc",
        ["items"] = {
            {
                ["label"] = "Fly",
                ["type"] = "toggle",
                ["enabled"] = false,
                [r15[r16("V|\xbc>F\x1f\x9a\xd7\x1f\n\xc2\xec", ok[1])]] = false,
                [r15[ok[1]]] = function(arg1_51, ...)
                    if arg1_51 then
                        r59();
                    else
                        r45();
                    end; 
                end
            },
            {
                ["label"] = "Instant Proximity Prompts",
                ["type"] = "toggle",
                ["enabled"] = false,
                [r15[r16(ok[1], ok[2])]] = false,
                [r15[ok[2]]] = function(arg1_52, ...)
                    v1 = arg1_52;
                    r39 = v1;
                    r40(v1); 
                end
            },
            {
                ["label"] = "Fullbright",
                ["type"] = "toggle",
                [r15[r16("\xfa\x97B\xf8\xf5*-", ok[1])]] = false,
                [r15[ok[1]]] = false,
                ["callback"] = ok[1]
            }
        }
    }
});
v3.Refresh(v3);