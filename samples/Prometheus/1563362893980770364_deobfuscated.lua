-- This file was generated at discord.gg/syncrypt

local Env = getfenv();
local z = {};
local r23 = {};
local r15 = setmetatable({}, {
    ["__index"] = r23,
    ["__metatable"] = nil
});
local v1 = game;
local r24 = v1.GetService(v1, "Players");
local v2 = game;
local r25 = v2.GetService(v2, "RunService");
local v3 = game;
local r26 = v3.GetService(v3, "UserInputService");
local v4 = game;
local v5 = v4.GetService(v4, "GuiService");
local r27 = workspace.CurrentCamera;
local r28 = r24.LocalPlayer;
local v6 = r28;
v6.GetMouse(v6);
v5.GetGuiInset(v5);
local r29 = tostring(game.PlaceId);
local v7 = z[c];
if r29 ~= "14772802900" and r29 ~= "14939963714" then
    V = r28;
    if V then
        V = r28;
        V.Kick(V, "Wrong Game!\nLoad in Jailbird");
    end;
    return;
end;
local v8 = false;
Zh[1] = "NameESP";
Zh[2] = false;
Zh[3] = "DistanceESP";
Zh[5] = "ChamsEnabled";
Zh[4] = false;
Zh[6] = false;
Zh[8] = false;
Zh[12] = true;
Zh[14] = false;
Zh[16] = false;
Zh[20] = "Color3";
Zh[19] = Env[Zh[20]];
Zh[18] = Zh[19].fromRGB;
Zh[21] = 255;
Zh[22] = 120;
Zh[20] = 0;
Zh[19] = Zh[18](Zh[20], Zh[21], Zh[22]);
Zh[20] = true;
Zh[24] = false;
Zh[26] = false;
Zh[30] = "Color3";
Zh[29] = Env[Zh[30]];
Zh[28] = Zh[29].fromRGB;
Zh[30] = 180;
Zh[31] = 100;
Zh[32] = 255;
Zh[29] = Zh[28](Zh[30], Zh[31], Zh[32]);
Zh[30] = true;
Zh[34] = false;
Zh[36] = false;
Zh[38] = false;
Zh[40] = false;
Zh[42] = false;
Zh[44] = false;
Zh[46] = false;
Zh[50] = "Color3";
Zh[49] = Env[Zh[50]];
Zh[48] = Zh[49].fromRGB;
Zh[50] = 180;
Zh[52] = 255;
Zh[51] = 100;
Zh[49] = Zh[48](Zh[50], Zh[51], Zh[52]);
Zh[52] = "Color3";
Zh[51] = Env[Zh[52]];
Zh[50] = Zh[51].fromRGB;
Zh[53] = 100;
Zh[52] = 180;
Zh[54] = 255;
Zh[51] = Zh[50](Zh[52], Zh[53], Zh[54]);
Zh[54] = "Color3";
Zh[53] = Env[Zh[54]];
Zh[56] = 255;
Zh[52] = Zh[53].fromRGB;
Zh[55] = 100;
Zh[54] = 180;
Zh[53] = Zh[52](Zh[54], Zh[55], Zh[56]);
Zh[56] = "Color3";
Zh[55] = Env[Zh[56]];
Zh[58] = 255;
Zh[54] = Zh[55].fromRGB;
Zh[56] = 180;
Zh[57] = 100;
Zh[55] = Zh[54](Zh[56], Zh[57], Zh[58]);
Zh[58] = "Color3";
Zh[57] = Env[Zh[58]];
Zh[59] = 100;
Zh[56] = Zh[57].fromRGB;
Zh[58] = 180;
Zh[60] = 255;
Zh[57] = Zh[56](Zh[58], Zh[59], Zh[60]);
Zh[60] = "Color3";
Zh[59] = Env[Zh[60]];
Zh[58] = Zh[59].fromRGB;
Zh[61] = 255;
Zh[60] = 255;
Zh[62] = 255;
Zh[59] = Zh[58](Zh[60], Zh[61], Zh[62]);
Zh[62] = "Color3";
Zh[61] = Env[Zh[62]];
Zh[63] = 200;
Zh[64] = 200;
Zh[60] = Zh[61].fromRGB;
Zh[62] = 200;
Zh[61] = Zh[60](Zh[62], Zh[63], Zh[64]);
Zh[64] = "Color3";
Zh[63] = Env[Zh[64]];
Zh[65] = 60;
Zh[62] = Zh[63].fromRGB;
Zh[66] = 220;
Zh[64] = 140;
Zh[63] = Zh[62](Zh[64], Zh[65], Zh[66]);
Zh[64] = false;
Zh[66] = false;
Zh[68] = false;
Zh[70] = false;
Zh[72] = false;
Zh[74] = 1;
Zh[76] = false;
Zh[78] = false;
Zh[80] = false;
Zh[82] = 100;
Zh[84] = 100;
Zh[86] = false;
Zh[88] = 70;
Zh[90] = false;
Zh[92] = 10;
Zh[94] = false;
Zh[96] = false;
Zh[98] = 180;
Zh[100] = 0;
Zh[102] = false;
Zh[104] = 0;
Zh[106] = false;
Zh[110] = 0;
Zh[114] = 0;
Zh[118] = 0;
Zh[120] = 0;
Zh[122] = {};
Zh[124] = false;
Zh[126] = false;
Zh[128] = false;
Zh[130] = nil;
local r30 = {
    ["Toggled"] = true,
    ["ActiveTab"] = "Aimbot",
    ["AimbotEnabled"] = false,
    ["SilentAimEnabled"] = false,
    ["VisCheckEnabled"] = false,
    ["TriggerBotEnabled"] = false,
    ["TriggerDelay"] = 50,
    ["TriggerReaction"] = 30,
    ["_lastShotTime"] = 0,
    ["_targetFirstSeen"] = 0,
    ["_hadTargetLastFrame"] = false,
    ["AimbotFOV"] = 120,
    ["AimbotSmoothing"] = 5,
    ["AimbotBone"] = "Head",
    ["SilentAimBone"] = "Head",
    ["TriggerBone"] = "Head",
    ["SilentAimFOV"] = 120,
    ["FOVCircle"] = nil,
    ["_stickyTarget"] = nil,
    ["_stickyPlayer"] = nil,
    ["WatermarkVisible"] = true,
    ["TeamCheck"] = false,
    ["SpeedEnabled"] = false,
    ["SpeedValue"] = 16,
    ["SpeedMode"] = "Toggle",
    ["SpeedBind"] = "Z",
    ["FlightEnabled"] = false,
    ["FlightValue"] = 50,
    ["FlightMode"] = "Toggle",
    ["FlightBind"] = "F",
    ["InfJumpEnabled"] = false,
    ["NoclipEnabled"] = false,
    ["NoclipMode"] = "Toggle",
    ["NoclipBind"] = "N",
    ["ESPEnabled"] = false,
    ["SkeletonESP"] = false,
    ["HeadDot"] = false,
    ["CornerBox"] = false,
    [r15[r16("NameESP", Zh[2])]] = false,
    [r15[Zh[2]]] = v8,
    ["NameESP"] = Zh[2],
    ["DistanceESP"] = Zh[4],
    ["ChamsEnabled"] = Zh[6],
    ["FilledChams"] = Zh[8],
    ["ChamsMaterial"] = "Normal",
    ["ESPOutlines"] = Zh[12],
    ["GlowingESP"] = Zh[14],
    ["GunChamsEnabled"] = Zh[16],
    ["GunChamsColor"] = Zh[19],
    ["GunChamsFilled"] = Zh[20],
    ["GunChamsMaterial"] = "Normal",
    ["GunRainbowChams"] = Zh[24],
    ["ArmChamsEnabled"] = Zh[26],
    ["ArmChamsColor"] = Zh[29],
    ["ArmChamsFilled"] = Zh[30],
    ["ArmChamsMaterial"] = "Normal",
    ["ArmRainbowChams"] = Zh[34],
    ["NoVisualRecoil"] = Zh[36],
    ["BarbWireESP"] = Zh[38],
    ["FortShieldESP"] = Zh[40],
    ["MetalShieldESP"] = Zh[42],
    ["TripWireESP"] = Zh[44],
    ["NoViewBob"] = Zh[46],
    ["SkeletonColor"] = Zh[49],
    ["HeadDotColor"] = Zh[51],
    ["CornerBoxColor"] = Zh[53],
    ["Box2DColor"] = Zh[55],
    ["Box3DColor"] = Zh[57],
    ["NameColor"] = Zh[59],
    ["DistanceColor"] = Zh[61],
    ["ChamsColor"] = Zh[63],
    ["InfiniteReserve"] = Zh[64],
    ["InfiniteMag"] = Zh[66],
    ["RapidFire"] = Zh[68],
    ["NoSpread"] = Zh[70],
    ["FullAuto"] = Zh[72],
    ["BulletCount"] = Zh[74],
    ["InstantADS"] = Zh[76],
    ["BulletVelocity"] = Zh[78],
    ["NoRecoilEnabled"] = Zh[80],
    ["RecoilReductionV"] = Zh[82],
    ["RecoilReductionH"] = Zh[84],
    ["NoShadows"] = Zh[86],
    ["WorldFOV"] = Zh[88],
    ["ThirdPerson"] = Zh[90],
    ["ThirdPersonDist"] = Zh[92],
    ["RageSilentAim"] = Zh[94],
    ["RageAutoShoot"] = Zh[96],
    ["RageFOV"] = Zh[98],
    ["RageDelay"] = Zh[100],
    ["RageTeamCheck"] = Zh[102],
    ["_rageLastShot"] = Zh[104],
    ["AntiAimEnabled"] = Zh[106],
    ["AAYawMode"] = "Off",
    ["AAYawValue"] = Zh[110],
    ["AAPitchMode"] = "Off",
    ["AAPitchValue"] = Zh[114],
    ["AARollMode"] = "Off",
    ["AARollValue"] = Zh[118],
    ["_aaSpinAngle"] = Zh[120],
    ["ESPObjects"] = Zh[122],
    ["MenuAllowed"] = Zh[124],
    ["KeybindListVisible"] = Zh[126],
    ["AntiVoteKick"] = Zh[128],
    ["_antiVKConnection"] = Zh[130]
};
local r31 = {};
local r34 = {
    ["Background"] = Color3.fromRGB(15, 14, 20),
    ["Surface"] = Color3.fromRGB(15, 14, 20),
    ["SurfaceLight"] = Color3.fromRGB(22, 20, 30),
    ["SurfaceHover"] = Color3.fromRGB(35, 32, 48),
    ["Border"] = Color3.fromRGB(60, 50, 90),
    ["BorderAccent"] = Color3.fromRGB(140, 60, 255),
    ["Accent"] = Color3.fromRGB(150, 70, 255),
    ["AccentDim"] = Color3.fromRGB(110, 50, 200),
    ["AccentGlow"] = Color3.fromRGB(180, 120, 255),
    ["AccentBright"] = Color3.fromRGB(200, 150, 255),
    ["Text"] = Color3.fromRGB(235, 235, 245),
    ["TextDim"] = Color3.fromRGB(130, 125, 155),
    ["TextAccent"] = Color3.fromRGB(190, 140, 255),
    ["Toggle_On"] = Color3.fromRGB(150, 70, 255),
    ["Toggle_Off"] = Color3.fromRGB(40, 38, 55),
    ["SliderTrack"] = Color3.fromRGB(35, 32, 50),
    ["SliderFill"] = Color3.fromRGB(150, 70, 255),
    ["Transparency"] = 0,
    ["GlassTransparency"] = 0
};
local v9 = game.CoreGui;
local v10 = v9.FindFirstChild(v9, "SwagWare");
if v10 then
    v9 = game.CoreGui;
    v10 = v9.FindFirstChild(v9, "SwagWare");
    v10.Destroy(v10);
end;
local r35 = Instance.new("ScreenGui");
local v11 = r35;
v11.Name = "SwagWare";
local v12 = r35;
v12.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
local v13 = r35;
v13.ResetOnSpawn = false;
local v14 = r35;
v14.IgnoreGuiInset = true;
local function r36(...)
    v7 = gethui;
    if v7 then
        return gethui();
    end;
    if syn and syn.protect_gui then
        syn.protect_gui(r35);
        v7 = game;
        return v7.GetService(v7, "CoreGui");
    end;
    v7 = protectgui;
    if v7 then
        protectgui(r35);
        v7 = game;
        return v7.GetService(v7, "CoreGui");
    end;
    v7 = game;
    M = v7.GetService(v7, "CoreGui");
    if M.FindFirstChild(M, "RobloxGui") then
        M = game;
        return M.GetService(M, "CoreGui").RobloxGui;
    end;
    v7 = game;
    return v7.GetService(v7, "CoreGui"); 
end;
local v15 = r35;
v15.Parent = r36();
local function r37(arg1_2, arg2_2, ...)
    c = arg2_2;
    v3 = 27773334106756;
    v2 = v3[3];
    v3 = v3[1];
    for v2, v5 in v3, pairs(c) do
        if v2 ~= "Parent" then
            v1[v2] = v5;
        end; 
    end;
    if c.Parent then
        v1.Parent = c.Parent;
    end;
    return Instance[r15[v3]](arg1_2); 
end;
local function r38(arg1_3, arg2_3, ...)
    v7 = r37;
    K = r37;
    return v7("UICorner", {
        ["CornerRadius"] = UDim.new(0, arg2_3 or 8),
        ["Parent"] = arg1_3
    }); 
end;
local function r39(arg1_4, arg2_4, arg3_4, arg4_4, ...)
    c = arg2_4;
    v7 = r37;
    I = v7;
    if c then
        v7 = "Thickness";
        q = v7;
        return v7("UIStroke", {
            ["Color"] = c,
            ["Thickness"] = arg3_4 or 1,
            ["Transparency"] = arg4_4 or 0.5,
            ["Parent"] = arg1_4
        });
    else
        v5 = r34.Border;
    end; 
end;
local function r40(arg1_5, arg2_5, arg3_5, ...)
    v7 = r37;
    K = v7;
    Q = v7;
    E = v7("UIStroke", {
        ["Color"] = Color3.fromRGB(255, 255, 255),
        ["Thickness"] = arg2_5 or 1.2,
        ["Transparency"] = arg3_5 or .65,
        ["ApplyStrokeMode"] = Enum.ApplyStrokeMode.Border,
        ["Parent"] = arg1_5
    });
    r41 = r37("UIGradient", {
        ["Color"] = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 180, 255)),
            ColorSequenceKeypoint.new(.35, Color3.fromRGB(140, 50, 230)),
            ColorSequenceKeypoint.new(.7, Color3.fromRGB(200, 140, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 180, 255))
        }),
        ["Rotation"] = 0,
        ["Parent"] = E
    });
    task.spawn(function(...)
        y = 0;
        while true do
            M = r41;
            M.Rotation = (0 + task.wait() * 80) % 360; 
        end; 
    end);
    return E; 
end;
local function v16(arg1_6, arg2_6, arg3_6, arg4_6, arg5_6, ...)
    v7 = r37;
    v9 = r37;
    N = v7;
    A = v7;
    return v7("UIPadding", {
        ["PaddingTop"] = UDim.new(0, arg2_6 or 8),
        ["PaddingBottom"] = UDim.new(0, arg3_6 or 8),
        ["PaddingLeft"] = UDim.new(0, arg4_6 or 10),
        ["PaddingRight"] = UDim.new(0, arg5_6 or 10),
        ["Parent"] = arg1_6
    }); 
end;
local r43 = r37("Frame", {
    ["Name"] = "MainFrame",
    ["Size"] = UDim2.new(0, 580, 0, 560),
    ["Position"] = UDim2.new(0.5, -290, 0.5, -280),
    ["BackgroundColor3"] = r34.Background,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["Parent"] = r35
});
r38(r43, 10);
local r44 = r37("UIGradient", {
    ["Color"] = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 180, 255)),
        ColorSequenceKeypoint.new(.35, Color3.fromRGB(140, 50, 230)),
        ColorSequenceKeypoint.new(.7, Color3.fromRGB(200, 140, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 180, 255))
    }),
    ["Rotation"] = 0,
    ["Parent"] = r37("UIStroke", {
        ["Color"] = Color3.fromRGB(255, 255, 255),
        ["Thickness"] = 2.5,
        ["Transparency"] = .05,
        ["Parent"] = r43
    })
});
task.spawn(function(...)
    while true do
        M = r44;
        M.Rotation = (0 + task.wait() * 100) % 360; 
    end; 
end);
local r33 = r37("Frame", {
    ["Name"] = "KeybindFrame",
    ["Size"] = UDim2.new(0, 250, 0, 40),
    ["Position"] = UDim2.new(0, 20, 0.5, 0),
    ["BackgroundColor3"] = r34.Background,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["Visible"] = false,
    ["Parent"] = r35
});
r38(r33, 8);
r40(r33, 1.5, .35);
r37("Frame", {
    ["Size"] = UDim2.new(1, -20, 0, 1),
    ["Position"] = UDim2.new(0, 10, 0, 30),
    ["BackgroundColor3"] = r34.Border,
    ["BorderSizePixel"] = 0,
    ["Parent"] = r33
});
local r45 = r37("Frame", {
    ["Size"] = UDim2.new(1, 0, 1, -35),
    ["Position"] = UDim2.new(0, 0, 0, 35),
    ["BackgroundTransparency"] = 1,
    ["Parent"] = r33
});
r37("UIListLayout", {
    ["SortOrder"] = Enum.SortOrder.LayoutOrder,
    ["Padding"] = UDim.new(0, 4),
    ["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
    ["Parent"] = r45
});
v16(r45, 4, 4, 4, 4);
local v17 = r37("TextLabel", {
    ["Size"] = UDim2.new(1, 0, 0, 30),
    ["BackgroundTransparency"] = 1,
    ["Text"] = "Active Keybinds",
    ["TextColor3"] = r34.TextAccent,
    ["TextSize"] = 14,
    ["Font"] = Enum.Font.Arcade,
    ["Parent"] = r33
}).InputBegan;
v17.Connect(v17, function(arg1_9, ...)
    r49 = arg1_9;
    v1 = r49.UserInputType;
    if v1 == Enum.UserInputType.MouseButton1 or r49.UserInputType == Enum.UserInputType.Touch then
        r46 = true;
        r47 = r49.Position;
        r48 = r33.Position;
        v1 = r49.Changed;
        v1.Connect(v1, function(...)
            if r49.UserInputState == Enum.UserInputState.End then
                r46 = false;
            end; 
        end);
    end; 
end);
local v18 = r26.InputChanged;
v18.Connect(v18, function(arg1_10, ...)
    c = r46;
    y = arg1_10;
    if c then
        M = y.UserInputType == Enum.UserInputType.MouseMovement or y.UserInputType == Enum.UserInputType.Touch;
        v7 = z[c];
    end;
    if c then
        c = y.Position - r47;
        v7 = r33;
        v7.Position = UDim2.new(r48.v2.Scale, r48.v2.Offset + c.v2, r48.Y.Scale, r48.Y.Offset + c.Y);
    end; 
end);
local r50 = {};
local function v19(arg1_11, arg2_11, arg3_11, arg4_11, ...)
    v1 = arg3_11;
    E = arg4_11;
    c = arg2_11;
    y = arg1_11;
    v2 = r37("Frame", {
        ["Size"] = UDim2.new(1, -10, 0, 24),
        ["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
        ["BorderSizePixel"] = 0,
        ["Parent"] = r45
    });
    r38(v2, 4);
    v7 = r50;
    v7[y] = {
        ["Frame"] = v2,
        ["Label"] = r37("TextLabel", {
            ["Size"] = UDim2.new(1, 0, 1, 0),
            ["BackgroundTransparency"] = 1,
            ["Text"] = "{" .. c .. " - " .. tostring(v1) .. " - " .. tostring(E) .. "}",
            ["TextColor3"] = Color3.fromRGB(255, 255, 255),
            ["TextSize"] = 12,
            ["Font"] = Enum.Font.Arcade,
            ["TextStrokeTransparency"] = 0.5,
            ["Parent"] = v2
        }),
        ["Gradient"] = r37("UIGradient", {
            ["Rotation"] = 0,
            ["Parent"] = v2
        }),
        ["Name"] = c,
        ["Bind"] = v1,
        ["Mode"] = E
    };
    return r50[y]; 
end;
v19("Speed", "Speed", "Z", "Toggle");
v19("Flight", "Flight", "F", "Toggle");
v19("Noclip", "Noclip", "N", "Toggle");
v19("TriggerBot", "TriggerBot", "None", "Toggle");
task.spawn(function(...)
    while true do
        y = (0 + task.wait() * 100) % 360;
        M = r33;
        M.Size = UDim2.new(0, 250, 0, 40 + 4 * 28);
        v5 = "Noclip";
        v3 = v5[2];
        v2 = v5[1];
        for v6, I in pairs({
            ["Speed"] = {
                ["state"] = r30.SpeedEnabled,
                ["bind"] = r30.SpeedBind,
                ["mode"] = r30.SpeedMode
            },
            ["Flight"] = {
                ["state"] = r30.FlightEnabled,
                ["bind"] = r30.FlightBind,
                ["mode"] = r30.FlightMode
            },
            [v5] = {
                ["state"] = r30.NoclipEnabled,
                ["bind"] = r30.NoclipBind,
                ["mode"] = r30.NoclipMode
            },
            ["TriggerBot"] = {
                ["state"] = r30.TriggerBotEnabled,
                ["bind"] = "None",
                ["mode"] = "Toggle"
            }
        }) do
            if r50[v6] then
                M = K.Label;
                M.Text = "{" .. v6 .. " - " .. tostring(I.bind) .. " - " .. tostring(I.mode) .. "}";
                if I.state then
                    M = M.Gradient;
                    M.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 200)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 150, 200))
                    });
                    M = M.Gradient;
                    M.Rotation = v7;
                else
                    M = M.Gradient;
                    M.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 60)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 90))
                    });
                    M = M.Gradient;
                    M.Rotation = 90;
                end;
            end; 
        end; 
    end; 
end);
local v20 = r43.InputBegan;
v20.Connect(v20, function(arg1_12, ...)
    r54 = arg1_12;
    v1 = r54.UserInputType;
    if v1 == Enum.UserInputType.MouseButton1 or r54.UserInputType == Enum.UserInputType.Touch then
        r51 = true;
        r52 = r54.Position;
        r53 = r43.Position;
        v1 = r54.Changed;
        v1.Connect(v1, function(...)
            if r54.UserInputState == Enum.UserInputState.End then
                r51 = false;
            end; 
        end);
    end; 
end);
local v21 = r26.InputChanged;
v21.Connect(v21, function(arg1_13, ...)
    c = r51;
    y = arg1_13;
    if c then
        v7 = z[c];
        M = y.UserInputType == Enum.UserInputType.MouseMovement or y.UserInputType == Enum.UserInputType.Touch;
    end;
    if c then
        c = y.Position - r52;
        v7 = r43;
        v7.Position = UDim2.new(r53.v2.Scale, r53.v2.Offset + c.v2, r53.Y.Scale, r53.Y.Offset + c.Y);
    end; 
end);
local v22 = r37("Frame", {
    ["Name"] = "TitleBar",
    ["Size"] = UDim2.new(1, 0, 0, 42),
    ["BackgroundColor3"] = r34.Surface,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["Parent"] = r43
});
r38(v22, 10);
r37("Frame", {
    ["Size"] = UDim2.new(1, 0, 0, 12),
    ["Position"] = UDim2.new(0, 0, 1, -12),
    ["BackgroundColor3"] = r34.Surface,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["Parent"] = v22
});
local v23 = Color3;
local v24 = v23.fromRGB;
local r55 = r37("UIGradient", {
    ["Color"] = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(.3, Color3.fromRGB(220, 180, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 60, 255)),
        ColorSequenceKeypoint.new(.7, e(v23)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }),
    ["Rotation"] = 0,
    ["Offset"] = Vector2.new(-1, 0),
    ["Parent"] = r37("TextLabel", {
        ["Size"] = UDim2.new(0, 220, 1, 0),
        ["Position"] = UDim2.new(0, 14, 0, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = "SwagWare",
        ["TextColor3"] = Color3.fromRGB(255, 255, 255),
        ["TextSize"] = 22,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["TextStrokeColor3"] = Color3.fromRGB(0, 0, 0),
        ["TextStrokeTransparency"] = .6,
        ["ZIndex"] = 2,
        ["Parent"] = v22
    })
});
task.spawn(function(...)
    y = -1;
    while true do
        y = -1 + task.wait() * 1.4;
        if y > 1 then
            y = -1;
        end;
        v1 = r55;
        v1.Offset = Vector2.new(y, 0); 
    end; 
end);
local v25 = Color3;
local v26 = v25.fromRGB;
local v27 = ColorSequenceKeypoint;
local v6 = v27.new;
local v28 = {
    Color3.fromRGB(255, 255, 255)
};
local r56 = r37("UIGradient", {
    ["Color"] = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.25, e(v27)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 60, 255)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(220, 180, 255)),
        e(v27)
    }),
    ["Rotation"] = 0,
    ["Offset"] = Vector2.new(-1, 0),
    ["Parent"] = r37("TextLabel", {
        ["Size"] = UDim2.new(0, 60, 0, 20),
        ["Position"] = UDim2.new(1, -72, 0.5, -10),
        ["BackgroundTransparency"] = 1,
        ["Text"] = "Beta",
        ["TextColor3"] = Color3.fromRGB(255, 255, 255),
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Right,
        ["TextStrokeColor3"] = Color3.fromRGB(0, 0, 0),
        ["TextStrokeTransparency"] = .6,
        ["ZIndex"] = 2,
        ["Parent"] = v22
    })
});
task.spawn(function(...)
    y = -1;
    while true do
        y = -1 + task.wait() * 1.2;
        if y > 1 then
            y = -1;
        end;
        v1 = r56;
        v1.Offset = Vector2.new(y, 0); 
    end; 
end);
local v29 = r37("Frame", {
    ["Name"] = "Sidebar",
    ["Size"] = UDim2.new(0, 120, 1, -50),
    ["Position"] = UDim2.new(0, 6, 0, 46),
    ["BackgroundColor3"] = r34.Surface,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["ClipsDescendants"] = true,
    ["Parent"] = r43
});
r38(v29, 8);
r37("UIListLayout", {
    ["SortOrder"] = Enum.SortOrder.LayoutOrder,
    ["Padding"] = UDim.new(0, 20),
    ["FillDirection"] = Enum.FillDirection.Vertical,
    ["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
    ["Parent"] = v29
});
v16(v29, 15, 15, 6, 6);
local v30 = r37("Frame", {
    ["Name"] = "ContentArea",
    ["Size"] = UDim2.new(1, -138, 1, -50),
    ["Position"] = UDim2.new(0, 132, 0, 46),
    ["BackgroundColor3"] = Color3.fromRGB(15, 14, 20),
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["ClipsDescendants"] = true,
    ["Parent"] = r43
});
r38(v30, 8);
local r57 = {};
local r58 = {};
local v31 = r15;
local v32 = r16;
local v33 = 29240500696368;
local v34 = "Rage Bot";
local r59 = {};
local function r60(arg1_14, ...)
    v7 = r30;
    y = arg1_14;
    c = y;
    v7.ActiveTab = c;
    v7 = game;
    c = v7.GetService(v7, "TweenService");
    v2 = r58;
    E = ("\x10\x87\xd4\x1e\xc6\xd1+8\xbb\x13Y4")[3];
    v1 = ("\x10\x87\xd4\x1e\xc6\xd1+8\xbb\x13Y4")[2];
    for E, v6 in pairs(M) do
        v6.Visible = E == y; 
    end;
    v2 = v6[3];
    E = v6[2];
    for v2, v6 in pairs(r57) do
        if v2 == y then
            v7 = c.Create(c, v6, TweenInfo.new(.2, Enum.EasingStyle.Quint), {
                ["BackgroundColor3"] = r34.Accent,
                ["BackgroundTransparency"] = .88
            });
            v7.Play(v7);
            v7 = c.Create(c, v6, TweenInfo.new(.2), {
                ["TextColor3"] = Color3.fromRGB(255, 255, 255),
                ["TextStrokeTransparency"] = 1
            });
            v7.Play(v7);
            if r59[v2] then
                v7 = c.Create(c, r59[v3], TweenInfo.new(.2), {
                    ["Transparency"] = .05
                });
                v7.Play(v7);
            end;
        end; 
    end; 
end;
local v35 = v34[1];
local v36 = v34[2];
for v26, v34 in ipairs({
    "Aimbot",
    "ESP",
    "Weapon",
    "Movement",
    "World",
    "Misc",
    v34
}), (68)(v31, e(v33)), v26(v31, v32, v33), v26(v31, v32, v33) do
    r61 = v34;
    r62 = r37("TextButton", {
        ["Name"] = r61 .. "Tab",
        ["Size"] = UDim2.new(1, 0, 0, 46),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0.5,
        ["BorderSizePixel"] = 0,
        ["Text"] = r61,
        ["TextColor3"] = r34.TextDim,
        ["TextSize"] = 15,
        ["Font"] = Enum.Font.Arcade,
        ["TextStrokeColor3"] = r34.Accent,
        ["TextStrokeTransparency"] = 1,
        ["LayoutOrder"] = v26,
        ["Parent"] = v29
    });
    r38(r62, 6);
    r63 = r40(r62, 1.5, .85);
    v33 = r59;
    v33[r61] = r63;
    v33 = r62.MouseEnter;
    v33.Connect(v33, function(...)
        v7 = r30.ActiveTab ~= r61;
        if v7 then
            v7 = game;
            M = v7.GetService(v7, "TweenService");
            v7 = M.Create(M, r62, TweenInfo.new(.12, Enum.EasingStyle.Quint), {
                ["BackgroundTransparency"] = .35
            });
            v7.Play(v7);
            v7 = game;
            M = v7.GetService(v7, "TweenService");
            v7 = M.Create(M, r63, TweenInfo.new(.12), {
                ["Transparency"] = 0.5
            });
            v7.Play(v7);
        end; 
    end);
    v33 = r62.MouseLeave;
    v33.Connect(v33, function(...)
        v7 = r30.ActiveTab ~= r61;
        if v7 then
            v7 = game;
            M = v7.GetService(v7, "TweenService");
            v7 = M.Create(M, r62, TweenInfo.new(.12, Enum.EasingStyle.Quint), {
                ["BackgroundTransparency"] = 0.5
            });
            v7.Play(v7);
            v7 = game;
            M = v7.GetService(v7, "TweenService");
            v7 = M.Create(M, r63, TweenInfo.new(.12), {
                ["Transparency"] = .85
            });
            v7.Play(v7);
        end; 
    end);
    v33 = r62.MouseButton1Click;
    v33.Connect(v33, function(...)
        r60(r61); 
    end);
    v33 = r57;
    v33[r61] = r62;
    r64 = r37("ScrollingFrame", {
        ["Name"] = r61 .. "Page",
        ["Size"] = UDim2.new(1, 0, 1, 0),
        ["BackgroundTransparency"] = 1,
        ["BorderSizePixel"] = 0,
        ["ScrollBarThickness"] = 3,
        ["ScrollBarImageColor3"] = r34.Accent,
        ["ScrollBarImageTransparency"] = .4,
        ["CanvasSize"] = UDim2.new(0, 0, 0, 0),
        ["AutomaticCanvasSize"] = Enum.AutomaticSize.Y,
        ["Visible"] = false,
        ["Parent"] = v30
    });
    v16(r64, 10, 10, 12, 12);
    r37("UIListLayout", {
        ["SortOrder"] = Enum.SortOrder.LayoutOrder,
        ["Padding"] = UDim.new(0, 6),
        ["Parent"] = r64
    });
    V6 = r64;
    V6.ScrollBarThickness = 4;
    task.spawn(function(...)
        while true do
            v1 = (math.sin((0 + task.wait() * 1.5) * 2) + 1) / 2;
            M = r64;
            M.ScrollBarImageColor3 = Color3.fromRGB(math.floor(150 + 105 * v1), math.floor(60 + 195 * v1), 255);
            M = r64;
            M.ScrollBarImageTransparency = .1 + .3 * (1 - v1); 
        end; 
    end);
    V6 = r58;
    V6[r61] = r64; 
end;
local v37 = game;
local function v38(arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15, arg7_15, arg8_15, ...)
    v2 = arg5_15;
    r65 = arg3_15;
    r66 = arg4_15;
    r67 = arg6_15;
    r68 = arg8_15;
    I = r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 48),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = arg7_15,
        ["Parent"] = arg1_15
    });
    r38(I, 7);
    r40(I, 1.5, .35);
    r37("TextLabel", {
        ["Size"] = UDim2.new(.6, 0, 0, 20),
        ["Position"] = UDim2.new(0, 10, 0, 4),
        ["BackgroundTransparency"] = 1,
        ["Text"] = arg2_15,
        ["TextColor3"] = r34.Text,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["Parent"] = I
    });
    r69 = r37("TextLabel", {
        ["Size"] = UDim2.new(.35, 0, 0, 20),
        ["Position"] = UDim2.new(.65, -12, 0, 4),
        ["BackgroundTransparency"] = 1,
        ["Text"] = tostring(v2),
        ["TextColor3"] = r34.TextAccent,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Right,
        ["Parent"] = I
    });
    r70 = r37("Frame", {
        ["Size"] = UDim2.new(1, -24, 0, 6),
        ["Position"] = UDim2.new(0, 12, 0, 32),
        ["BackgroundColor3"] = r34.SliderTrack,
        ["BorderSizePixel"] = 0,
        ["Parent"] = I
    });
    r38(r70, 3);
    r71 = r37("Frame", {
        ["Size"] = UDim2.new((v2 - r65) / (r66 - r65), 0, 1, 0),
        ["BackgroundColor3"] = r34.SliderFill,
        ["BorderSizePixel"] = 0,
        ["Parent"] = r70
    });
    r38(r71, 3);
    r38(r37("Frame", {
        ["Size"] = UDim2.new(0, 12, 0, 12),
        ["Position"] = UDim2.new(1, -6, 0.5, -6),
        ["BackgroundColor3"] = r34.AccentGlow,
        ["BorderSizePixel"] = 0,
        ["ZIndex"] = 3,
        ["Parent"] = r71
    }), 6);
    r72 = v2;
    r73 = false;
    B = r37("TextButton", {
        ["Size"] = UDim2.new(1, 0, 1, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = "",
        ["ZIndex"] = 5,
        ["Parent"] = r70
    });
    local function r74(arg1_16, ...)
        v2 = (r66 - r65) * math.clamp((arg1_16.Position.v2 - r70.AbsolutePosition.v2) / r70.AbsoluteSize.v2, 0, 1);
        v7 = r67;
        r72 = math.clamp(r65 + v2 and math.floor(v2 / r67 + 0.5) * r67, r65, r66);
        M = r71;
        M.Size = UDim2.new((r72 - r65) / (r66 - r65), 0, 1, 0);
        M = r69;
        M.Text = tostring(math.floor(r72 * 100) / 100);
        if r68 then
            r68(r72);
        end; 
    end;
    v7 = B.InputBegan;
    v7.Connect(v7, function(arg1_17, ...)
        y = arg1_17;
        if y.UserInputType == Enum.UserInputType.MouseButton1 or y.UserInputType == Enum.UserInputType.Touch then
            r73 = true;
            r74(y);
        end; 
    end);
    v7 = B.InputEnded;
    v7.Connect(v7, function(arg1_18, ...)
        y = arg1_18;
        if y.UserInputType == Enum.UserInputType.MouseButton1 or y.UserInputType == Enum.UserInputType.Touch then
            r73 = false;
        end; 
    end);
    v7 = r26.InputChanged;
    v7.Connect(v7, function(arg1_19, ...)
        c = r73;
        y = arg1_19;
        if c then
            v7 = M[A];
            M = y.UserInputType == Enum.UserInputType.MouseMovement or y.UserInputType == Enum.UserInputType.Touch;
        end;
        if c then
            r74(y);
        end; 
    end);
    return I, function(...)
        return r72; 
    end; 
end;
local r75 = v37.GetService(v37, "TweenService");
local function v39(arg1_20, arg2_20, arg3_20, ...)
    E = r37("TextLabel", {
        ["Size"] = UDim2.new(1, 0, 0, 26),
        ["BackgroundTransparency"] = 1,
        ["Text"] = arg2_20,
        ["TextColor3"] = r34.TextAccent,
        ["TextSize"] = 15,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["LayoutOrder"] = arg3_20,
        ["Parent"] = arg1_20
    });
    r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 1),
        ["Position"] = UDim2.new(0, 0, 1, -2),
        ["BackgroundColor3"] = r34.Accent,
        ["BackgroundTransparency"] = .65,
        ["BorderSizePixel"] = 0,
        ["Parent"] = E
    });
    return E; 
end;
local function v40(arg1_21, arg2_21, arg3_21, arg4_21, arg5_21, ...)
    v1 = arg3_21;
    r76 = arg5_21;
    v3 = r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 32),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = arg4_21,
        ["Parent"] = arg1_21
    });
    r38(v3, 7);
    v7 = r40;
    I = v7;
    q = v7;
    r77 = v7(v3, 1.5, v1 and .05 or .35);
    r37("TextLabel", {
        ["Size"] = UDim2.new(1, -60, 1, 0),
        ["Position"] = UDim2.new(0, 10, 0, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = arg2_21,
        ["TextColor3"] = r34.Text,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["Parent"] = v3
    });
    if v1 then
        A = r34.Toggle_On;
    end;
    v7 = v7;
    r78 = r37("Frame", {
        ["Size"] = UDim2.new(0, 38, 0, 19),
        ["Position"] = UDim2.new(1, -52, 0.5, -10),
        ["BackgroundColor3"] = v1 or r34.Toggle_Off,
        ["BorderSizePixel"] = 0,
        ["Parent"] = v3
    });
    r38(r78, 10);
    M = r37;
    q = "Frame";
    v9 = "Size";
    UDim2.new(0, 16, 0, 16);
    S = "Position";
    B = v7;
    if v1 then
        G = UDim2.new(1, -18, 0.5, -8);
    end;
    C = v1;
    v7 = v7;
    if v1 then
        v7 = v7;
        r79 = r37("Frame", {
            ["Size"] = UDim2[r15[r16("̒\x97", T)]](0, 16, 0, 16),
            [r15[r16("\xd8*;\xa4\xc0$\xa7\x88", l)]] = G,
            ["BackgroundColor3"] = Color3.fromRGB(255, 255, 255),
            ["BorderSizePixel"] = 0,
            ["Parent"] = r78
        });
        r38(r79, 8);
        r80 = v1;
        local function r81(...)
            v1 = r80;
            if v1 then
                y = UDim2.new(1, -18, 0.5, -8);
            end;
            M = v1;
            v7 = v7;
            if v1 then
                E = r80;
                y = y;
                if E then
                    c = r34.Toggle_On;
                end;
                v7 = c;
                v7 = r75;
                M = v7.Create(v7, r79, TweenInfo.new(.18, Enum.EasingStyle.Quint), {
                    ["Position"] = y
                });
                M.Play(M);
                v7 = r75;
                M = v7.Create(v7, r78, TweenInfo.new(.18, Enum.EasingStyle.Quint), {
                    ["BackgroundColor3"] = E or r34.Toggle_Off
                });
                M.Play(M);
                v7 = r75;
                v5 = v7;
                M = v7.Create(v7, r77, TweenInfo.new(.18), {
                    ["Transparency"] = r80 and .05 or .35
                });
                M.Play(M);
                return;
            else
                UDim2.new(0, 2, 0.5, -8);
            end; 
        end;
        M = r37("TextButton", {
            ["Size"] = UDim2.new(1, 0, 1, 0),
            ["BackgroundTransparency"] = 1,
            ["Text"] = "",
            ["Parent"] = v3
        }).MouseButton1Click;
        M.Connect(M, function(...)
            r80 = not r80;
            r81();
            if r76 then
                r76(r80);
            end; 
        end);
        return v3, function(...)
            return r80; 
        end, function(arg1_22, ...)
            r80 = arg1_22;
            r81(); 
        end;
    else
        C = UDim2.new(0, 2, 0.5, -8);
    end; 
end;
local r82 = {
    Color3.fromRGB(180, 100, 255),
    Color3.fromRGB(140, 60, 220),
    Color3.fromRGB(255, 80, 180),
    Color3.fromRGB(255, 50, 80),
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(255, 130, 0),
    Color3.fromRGB(255, 220, 50),
    Color3.fromRGB(100, 255, 100),
    Color3.fromRGB(0, 220, 120),
    Color3.fromRGB(0, 220, 255),
    Color3.fromRGB(80, 160, 255),
    Color3.fromRGB(50, 80, 255),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(200, 200, 200)
};
local function v41(arg1_23, arg2_23, arg3_23, arg4_23, arg5_23, ...)
    v1 = arg3_23;
    r83 = arg5_23;
    r84 = r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 32),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = arg4_23,
        ["ClipsDescendants"] = true,
        ["Parent"] = arg1_23
    });
    r38(r84, 7);
    r40(r84, 1.5, .35);
    r85 = r37("Frame", {
        ["Size"] = UDim2.new(0, 18, 0, 18),
        ["Position"] = UDim2.new(0, 10, 0, 7),
        ["BackgroundColor3"] = v1,
        ["BorderSizePixel"] = 0,
        ["Parent"] = r84
    });
    r38(r85, 4);
    r39(r85, r34.Border, 1, .4);
    r37("TextLabel", {
        ["Size"] = UDim2.new(1, -80, 0, 32),
        ["Position"] = UDim2.new(0, 36, 0, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = arg2_23,
        ["TextColor3"] = r34.Text,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["Parent"] = r84
    });
    r86 = false;
    r87 = v1;
    r88 = r37("TextButton", {
        ["Size"] = UDim2.new(0, 50, 0, 22),
        ["Position"] = UDim2.new(1, -60, 0, 5),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = "Edit",
        ["TextColor3"] = r34.TextDim,
        ["TextSize"] = 12,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = r84
    });
    r38(r88, 5);
    Q = r37("Frame", {
        ["Size"] = UDim2.new(1, -20, 0, 68),
        ["Position"] = UDim2.new(0, 10, 0, 36),
        ["BackgroundTransparency"] = 1,
        ["Parent"] = r84
    });
    C = "CellPadding";
    r37("UIGridLayout", {
        ["CellSize"] = UDim2.new(0, 24, 0, 24),
        [C] = UDim2.new(0, 6, 0, 6),
        ["SortOrder"] = Enum.SortOrder.LayoutOrder,
        ["Parent"] = Q
    });
    v7 = ipairs;
    N = r82;
    S = C[3];
    v9 = C[2];
    for S, B in v7(M) do
        r89 = B;
        G = r37("TextButton", {
            ["Size"] = UDim2.new(0, 24, 0, 24),
            ["BackgroundColor3"] = r89,
            ["BorderSizePixel"] = 0,
            ["Text"] = "",
            ["LayoutOrder"] = S,
            ["Parent"] = Q
        });
        r38(G, 4);
        r90 = r39(G, Color3.fromRGB(255, 255, 255), 1.5, .8);
        v7 = G.MouseEnter;
        v7.Connect(v7, function(...)
            v7 = r75;
            M = v7.Create(v7, r90, TweenInfo.new(.12), {
                ["Transparency"] = 0
            });
            M.Play(M); 
        end);
        v7 = G.MouseLeave;
        v7.Connect(v7, function(...)
            M = r87;
            if M ~= r89 then
                v7 = r75;
                M = v7.Create(v7, r90, TweenInfo.new(.12), {
                    ["Transparency"] = .8
                });
                M.Play(M);
            end; 
        end);
        v7 = G.MouseButton1Click;
        v7.Connect(v7, function(...)
            r87 = r89;
            M = r85;
            M.BackgroundColor3 = r89;
            M = r75;
            y = M.Create(M, r90, TweenInfo.new(.12), {
                ["Transparency"] = 0
            });
            y.Play(y);
            if r83 then
                r83(r89);
            end; 
        end); 
    end;
    v7 = r88.MouseButton1Click;
    v7.Connect(v7, function(...)
        v7 = not r86;
        r86 = v7;
        y = v7;
        E = r86;
        if E then
            c = UDim2.new(1, 0, 0, 112);
        end;
        v7 = v7;
        M = E;
        if E then
            y = "Text";
            M = r75;
            c = M.Create(M, r84, TweenInfo.new(.2, Enum.EasingStyle.Quint), {
                ["Size"] = y
            });
            c.Play(c);
            M = r88;
            v7 = v7;
            v7 = v7;
            M.Text = r86 and "Close" or "Edit";
            return;
        else
            M = UDim2.new(1, 0, 0, 32);
        end; 
    end);
    return r84; 
end;
local r91 = {
    "MB2",
    "MB1",
    "Q",
    "E",
    "X",
    "C",
    "V",
    "CapsLock",
    "LeftAlt",
    "RightAlt",
    "Insert"
};
local function v42(arg1_24, arg2_24, arg3_24, arg4_24, arg5_24, ...)
    r92 = arg5_24;
    v1 = arg3_24;
    v3 = r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 32),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = arg4_24,
        ["Parent"] = arg1_24
    });
    r38(v3, 7);
    r40(v3, 1.5, .35);
    q = UDim2.new(1, -90, 1, 0);
    r37("TextLabel", {
        ["Size"] = q,
        ["Position"] = UDim2.new(0, 10, 0, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = arg2_24,
        ["TextColor3"] = r34.Text,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["Parent"] = v3
    });
    r93 = 1;
    K = r91;
    I = q[3];
    K = q[1];
    for I, Q in K, ipairs(K) do
        q = I;
        if Q == v1 then
            r93 = I;
            break;
        end; 
    end;
    r94 = r37("TextLabel", {
        ["Size"] = UDim2.new(0, 50, 0, 22),
        ["Position"] = UDim2.new(1, -82, 0.5, -11),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = v1,
        ["TextColor3"] = r34.TextAccent,
        ["TextSize"] = 12,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v3
    });
    r38(r94, 5);
    K = r37("TextButton", {
        ["Size"] = UDim2.new(0, 18, 0, 22),
        ["Position"] = UDim2.new(1, -102, 0.5, -11),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = "<",
        ["TextColor3"] = r34.TextDim,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v3
    });
    r38(K, 4);
    q = r37("TextButton", {
        ["Size"] = UDim2.new(0, 18, 0, 22),
        ["Position"] = UDim2.new(1, -30, 0.5, -11),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = ">",
        ["TextColor3"] = r34.TextDim,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v3
    });
    r38(q, 4);
    I = K.MouseButton1Click;
    I.Connect(I, function(...)
        r93 = r93 - 1;
        if r93 < 1 then
            r93 = #r91;
        end;
        y = r94;
        y.Text = r91[r93];
        if r92 then
            r92(r91[r93]);
        end; 
    end);
    I = q.MouseButton1Click;
    I.Connect(I, function(...)
        r93 = r93 + 1;
        if r93 > #r91 then
            r93 = 1;
        end;
        y = r94;
        y.Text = r91[r93];
        if r92 then
            r92(r91[r93]);
        end; 
    end);
    r95 = false;
    I = r37("TextButton", {
        ["Size"] = UDim2.new(1, 0, 1, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = "",
        ["Parent"] = r94
    }).MouseButton1Click;
    I.Connect(I, function(...)
        if r95 then
            return;
        end;
        r95 = true;
        M = r94;
        M.Text = "...";
        M = r26.InputBegan;
        r96 = M.Connect(M, function(arg1_25, ...)
            y = arg1_25;
            if y.UserInputType == Enum.UserInputType.Keyboard or (y.UserInputType == Enum.UserInputType.MouseButton1 or (y.UserInputType == Enum.UserInputType.MouseButton2 or y.UserInputType == Enum.UserInputType.MouseButton3)) then
                v7 = r96;
                v7.Disconnect(v7);
                r95 = false;
                c = y.KeyCode.Name;
                if c == "Unknown" then
                    c = arg1_25.UserInputType.Name;
                end;
                if c == "MouseButton1" then
                    c = "MB1";
                end;
                if c == "MouseButton2" then
                    c = "MB2";
                end;
                if c == "MouseButton3" then
                    c = "MB3";
                end;
                v3 = r94;
                v3.Text = c;
                if r92 then
                    r92(c);
                end;
            end; 
        end); 
    end);
    return v3; 
end;
local function v43(arg1_26, arg2_26, arg3_26, arg4_26, arg5_26, arg6_26, ...)
    r97 = arg3_26;
    E = arg4_26;
    r98 = arg6_26;
    v6 = r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 32),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = arg5_26,
        ["Parent"] = arg1_26
    });
    r38(v6, 7);
    r40(v6, 1.5, .35);
    Q = UDim2.new(1, -120, 1, 0);
    r37("TextLabel", {
        ["Size"] = Q,
        ["Position"] = UDim2.new(0, 10, 0, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = arg2_26,
        ["TextColor3"] = r34.Text,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["TextXAlignment"] = Enum.TextXAlignment.Left,
        ["Parent"] = v6
    });
    r99 = 1;
    q = r97;
    K = Q[3];
    q = Q[1];
    for K, v9 in q, ipairs(q) do
        Q = K;
        if v9 == E then
            r99 = K;
            break;
        end; 
    end;
    r100 = r37("TextLabel", {
        ["Size"] = UDim2.new(0, 74, 0, 22),
        ["Position"] = UDim2.new(1, -94, 0.5, -11),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = E,
        ["TextColor3"] = r34.TextAccent,
        ["TextSize"] = 11,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v6
    });
    r38(r100, 5);
    q = r37("TextButton", {
        ["Size"] = UDim2.new(0, 18, 0, 22),
        ["Position"] = UDim2.new(1, -114, 0.5, -11),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = "<",
        ["TextColor3"] = r34.TextDim,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v6
    });
    r38(q, 4);
    Q = r37("TextButton", {
        ["Size"] = UDim2.new(0, 18, 0, 22),
        ["Position"] = UDim2.new(1, -18, 0.5, -11),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = ">",
        ["TextColor3"] = r34.TextDim,
        ["TextSize"] = 13,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v6
    });
    r38(Q, 4);
    K = q.MouseButton1Click;
    K.Connect(K, function(...)
        r99 = r99 - 1;
        if r99 < 1 then
            r99 = #r97;
        end;
        y = r100;
        y.Text = r97[r99];
        if r98 then
            r98(r97[r99]);
        end; 
    end);
    K = Q.MouseButton1Click;
    K.Connect(K, function(...)
        r99 = r99 + 1;
        if r99 > #r97 then
            r99 = 1;
        end;
        y = r100;
        y.Text = r97[r99];
        if r98 then
            r98(r97[r99]);
        end; 
    end);
    return v6; 
end;
local r101 = 0;
local v44 = Enum.SortOrder.LayoutOrder;
r37("UIListLayout", {
    ["FillDirection"] = Enum.FillDirection.Horizontal,
    ["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
    ["VerticalAlignment"] = Enum.VerticalAlignment.Center,
    ["SortOrder"] = v44,
    ["Padding"] = UDim.new(0, 8),
    ["Parent"] = r37("Frame", {
        ["Name"] = "SubTabBar",
        ["Size"] = UDim2.new(1, 0, 0, 36),
        ["BackgroundTransparency"] = 1,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = (function(...)
            r101 = r101 + 1;
            return r101; 
        end)(),
        ["Parent"] = r58.Aimbot
    })
});
local r102 = {};
local r103 = {};
local r104 = {};
local v45 = (25098691161511)[2];
local v46 = (25098691161511)[1];
for w6, o6 in ipairs({
    "Aimbot",
    "Silent Aim",
    "Triggerbot"
}) do
    u6 = r37;
    nh = "TextButton";
    bh = "Name";
    eh = o6 .. "SubBtn";
    gh = "Size";
    UDim2.new(.31, 0, 1, -6);
    mh = "BackgroundColor3";
    v7 = v7;
    sh = w6 == 1 and r34[r15[r16("E\x1d+\xe1", Zh[2])]] or r34.SurfaceLight;
    ch = v7;
    yh = v7;
    Zh[2] = 2110643667926;
    Mh = "BackgroundTransparency";
    zh = w6 == 1 and .88 or 0.5;
    yh = "BorderSizePixel";
    Dh = 0;
    Zh[3] = 1;
    Zh[1] = "\xfa\x80yh\xd0c\xfb\x18\xe5\x8c";
    ch = r15[r16("\xe9\x1c0\xde", Zh[1])];
    Zh[1] = v7;
    Jh = v7;
    xh = r15[r16(Zh[1], Zh[2])];
    Zh[2] = w6 == Zh[3];
    v8 = Zh[2];
    Eh = v8 and Zh[3];
    v7 = Zh[1];
    if v8 then
        Zh[5] = "Enum";
        Zh[4] = Env[Zh[5]];
        Zh[3] = Zh[4].Font;
        Zh[2] = Zh[3].Arcade;
        mh = v7;
        v44 = z[v15]("TextButton", {
            ["Name"] = o6 .. "SubBtn",
            ["Size"] = UDim2.new(.31, 0, 1, -6),
            ["BackgroundColor3"] = T6 == 1 and z[R][z[E][z[c]("Font", Zh[2])]] or z[R].SurfaceLight,
            ["BackgroundTransparency"] = T6 == 1 and .88 or 0.5,
            ["BorderSizePixel"] = 0,
            [z[E][z[c]("\xe9\x1c0\xde", "Font")]] = o6,
            [z[E][z[c]("Font", Zh[2])]] = v8 and "LayoutOrder",
            [r15[Zh[2]]] = 13,
            ["Font"] = Zh[2],
            ["LayoutOrder"] = w6,
            ["Parent"] = z[v15]("Frame", {
                ["Name"] = "SubTabBar",
                ["Size"] = UDim2.new(1, 0, 0, 36),
                ["BackgroundTransparency"] = 1,
                ["BorderSizePixel"] = 0,
                ["LayoutOrder"] = G6(),
                ["Parent"] = N6
            })
        });
        eh = v7;
        r38(v44, 6);
        u6 = r102;
        u6[o6] = v44;
        ah = r40(v44, 1.3, w6 == 1 and .05 or .85);
        u6 = r103;
        u6[o6] = ah;
        Zh[1] = r15;
        ah = r37("Frame", {
            ["Name"] = o6 .. "SubPage",
            ["Size"] = UDim2.new(1, 0, 0, 0),
            ["AutomaticSize"] = Enum[r15[r16("\x80{x\x00\x90\x1b\xfb=\xdb\x06)\xc2\x17", Zh[1])]].Y,
            ["BackgroundTransparency"] = 1,
            [r15[r16("\xb9\xd2\xd5^\\\xff\xfe\x1a\xd3\"\xb9", Zh[1])]] = (function(...)
                z[B6] = z[B6] + 1;
                return z[B6]; 
            end)(),
            ["Visible"] = w6 == 1,
            ["Parent"] = z[r6].Aimbot
        });
        r37("UIListLayout", {
            ["SortOrder"] = Enum.SortOrder.LayoutOrder,
            ["Padding"] = UDim.new(0, 6),
            ["Parent"] = ah
        });
        u6 = r104;
        u6[o6] = ah;
    else
        Zh[1] = r34;
        Eh = Zh[1].TextDim;
    end; 
end;
local function r105(arg1_27, ...)
    E = r104;
    y = arg1_27;
    v1 = (23)[3];
    E = (23)[1];
    for v1, v3 in E, pairs(E) do
        v3.Visible = v1 == y; 
    end;
    v1 = v3[2];
    E = v3[3];
    for E, v3 in pairs(r102) do
        if E == y then
            v7 = r75;
            v5 = v7.Create(v7, v3, TweenInfo.new(.18, Enum.EasingStyle.Quint), {
                ["BackgroundColor3"] = r34.Accent,
                ["BackgroundTransparency"] = .88,
                ["TextColor3"] = Color3.fromRGB(255, 255, 255)
            });
            v5.Play(v5);
            if r103[E] then
                v7 = r75;
                v5 = v7.Create(v7, r103[v2], TweenInfo.new(.18), {
                    ["Transparency"] = .05
                });
                v5.Play(v5);
            end;
        end; 
    end; 
end;
local v47 = r102;
local v48 = v44[3];
for v48, v47 in v44[1], pairs(v47) do
    r106 = v48;
    v44 = v47.MouseButton1Click;
    v44.Connect(v44, function(...)
        r105(r106); 
    end); 
end;
local v49 = r104.Aimbot;
local r107 = 0;
local function v50(...)
    r107 = r107 + 1;
    return r107; 
end;
v39(v49, "Aimbot Settings", v50());
v40(v49, "Enable Aimbot", false, v50(), function(arg1_28, ...)
    v7 = r30;
    v7.AimbotEnabled = arg1_28; 
end);
v43(v49, "Target Bone", {
    "Head",
    "Torso",
    "RootPart"
}, "Head", v50(), function(arg1_29, ...)
    v7 = r30;
    v7.AimbotBone = arg1_29; 
end);
v40(v49, "Visibility Check", false, v50(), function(arg1_30, ...)
    v7 = r30;
    v7.VisCheckEnabled = arg1_30; 
end);
v40(v49, "Team Check", false, v50(), function(arg1_31, ...)
    v7 = r30;
    v7.TeamCheck = arg1_31; 
end);
v40(v49, "Sticky Aim", false, v50(), function(arg1_32, ...)
    v7 = r30;
    y = arg1_32;
    v7.StickyAimEnabled = y;
    if not y then
        v7 = r30;
        v7._stickyTarget = nil;
        v7 = r30;
        v7._stickyPlayer = nil;
    end; 
end);
v38(v49, "FOV Radius", 10, 500, 120, 5, v50(), function(arg1_33, ...)
    v7 = r30;
    y = arg1_33;
    c = y;
    v7.AimbotFOV = c;
    c = "FOVCircle";
    if r30[c] then
        v7 = r30.FOVCircle;
        c = arg1_33;
        v7.Radius = c;
    end; 
end);
v38(v49, "Smoothness", 1, 20, 5, 0.5, v50(), function(arg1_34, ...)
    v7 = r30;
    v7.AimbotSmoothing = arg1_34; 
end);
v42(v49, "Aim Key", "MB2", v50(), function(arg1_35, ...)
    v7 = r30;
    v7.AimbotBind = arg1_35; 
end);
local v51 = r104["Silent Aim"];
local r108 = 0;
local function v52(...)
    r108 = r108 + 1;
    return r108; 
end;
v39(v51, "Silent Aim Settings", v52());
v40(v51, "Enable Silent Aim", false, v52(), function(arg1_36, ...)
    v7 = r30;
    v7.SilentAimEnabled = arg1_36; 
end);
v43(v51, "Target Bone", {
    "Head",
    "Torso",
    "RootPart"
}, "Head", v52(), function(arg1_37, ...)
    v7 = r30;
    v7.SilentAimBone = arg1_37; 
end);
v40(v51, "Visibility Check", false, v52(), function(arg1_38, ...)
    v7 = r30;
    v7.VisCheckEnabled = arg1_38; 
end);
v40(v51, "Team Check", false, v52(), function(arg1_39, ...)
    v7 = r30;
    v7.TeamCheck = arg1_39; 
end);
v38(v51, "Silent Aim FOV", 10, 500, 120, 5, v52(), function(arg1_40, ...)
    v7 = r30;
    y = arg1_40;
    c = y;
    v7.SilentAimFOV = c;
    c = r30.FOVCircle;
    if c and r30.SilentAimEnabled then
        v7 = r30.FOVCircle;
        c = arg1_40;
        v7.Radius = c;
    end; 
end);
v42(v51, "Aim Key", "MB2", v52(), function(arg1_41, ...)
    v7 = r30;
    v7.AimbotBind = arg1_41; 
end);
local v53 = r104.Triggerbot;
local r109 = 0;
local function v54(...)
    r109 = r109 + 1;
    return r109; 
end;
v39(v53, "Triggerbot Settings", v54());
v40(v53, "Enable Triggerbot", false, v54(), function(arg1_42, ...)
    v7 = r30;
    v7.TriggerBotEnabled = arg1_42; 
end);
v40(v53, "Visibility Check", false, v54(), function(arg1_43, ...)
    v7 = r30;
    v7.VisCheckEnabled = arg1_43; 
end);
v40(v53, "Team Check", false, v54(), function(arg1_44, ...)
    v7 = r30;
    v7.TeamCheck = arg1_44; 
end);
v43(v53, "Target Bone", {
    "Head",
    "Torso",
    "RootPart"
}, "Head", v54(), function(arg1_45, ...)
    v7 = r30;
    v7.TriggerBone = arg1_45; 
end);
v38(v53, "Delay Between Shots (ms)", 0, 500, 50, 10, v54(), function(arg1_46, ...)
    v7 = r30;
    v7.TriggerDelay = arg1_46; 
end);
v38(v53, "Reaction Time (ms)", 0, 500, 30, 10, v54(), function(arg1_47, ...)
    v7 = r30;
    v7.TriggerReaction = arg1_47; 
end);
local v55 = r58.ESP;
local r110 = 0;
local function v56(...)
    r110 = r110 + 1;
    return r110; 
end;
local v57 = r37("Frame", {
    ["Name"] = "ESPSubTabBar",
    ["Size"] = UDim2.new(1, 0, 0, 36),
    ["BackgroundTransparency"] = 1,
    ["BorderSizePixel"] = 0,
    ["LayoutOrder"] = v56(),
    ["Parent"] = v55
});
local v58 = Enum.VerticalAlignment.Center;
local v59 = Enum.SortOrder.LayoutOrder;
r37("UIListLayout", {
    ["FillDirection"] = Enum.FillDirection.Horizontal,
    ["HorizontalAlignment"] = Enum.HorizontalAlignment.Center,
    ["VerticalAlignment"] = v58,
    ["SortOrder"] = v59,
    ["Padding"] = UDim.new(0, 12),
    ["Parent"] = v57
});
local r111 = {};
local r112 = {};
local r113 = {};
local v60 = v58[1];
local v61 = v58[2];
for w6, v58 in ipairs({
    "ESP Options",
    "ESP Colors"
}) do
    Mh = v7;
    v7 = v7;
    yh = Mh;
    ch = Mh;
    Zh[3] = 1;
    Zh[1] = Mh;
    Zh[2] = w6 == Zh[3];
    if Zh[2] then
        Zh[4] = "Color3";
        Zh[3] = Env[Zh[4]];
        Zh[6] = 255;
        Zh[2] = Zh[3].fromRGB;
        Zh[4] = 255;
        Zh[5] = 255;
        Zh[3] = Zh[2](Zh[4], Zh[5], Zh[6]);
        v8 = Zh[3];
    end;
    v7 = Zh[1];
    v7 = "Parent";
    Zh[5] = "Enum";
    Zh[4] = Env[Zh[5]];
    Zh[3] = Zh[4].Font;
    Zh[2] = Zh[3].Arcade;
    v59 = r37("TextButton", {
        ["Name"] = v58 .. "SubBtn",
        ["Size"] = UDim2.new(.46, 0, 1, -6),
        ["BackgroundColor3"] = w6 == 1 and r34[r15[r16("Font", Zh[2])]] or r34.SurfaceLight,
        ["BackgroundTransparency"] = w6 == 1 and .88 or 0.5,
        ["BorderSizePixel"] = 0,
        ["Font"] = v58,
        [r15[r16("Font", Zh[2])]] = Zh[2] or ("Font")[Zh[2]],
        [r15[Zh[2]]] = 13,
        ["Font"] = Zh[2],
        ["LayoutOrder"] = w6,
        ["Parent"] = v57
    });
    r38(v59, 6);
    eh = v7;
    mh = v7;
    v52 = r111;
    v52[v58] = v59;
    v52 = r112;
    v52[v58] = r40(v59, 1.3, w6 == 1 and .05 or .85);
    Zh[1] = r15;
    v54 = r37("Frame", {
        ["Name"] = v58 .. "SubPage",
        ["Size"] = UDim2.new(1, 0, 0, 0),
        ["AutomaticSize"] = Enum[r15[r16("\x04\xba%6\xeaL\xbb\x02z6g\x04\"", Zh[1])]].Y,
        ["BackgroundTransparency"] = 1,
        [r15[r16("\x1b\x7fʀ}\xd6\xf1\x0c\xd2\xd0\xfe", Zh[1])]] = v56(),
        ["Visible"] = w6 == 1,
        ["Parent"] = v55
    });
    r37("UIListLayout", {
        ["SortOrder"] = Enum.SortOrder.LayoutOrder,
        ["Padding"] = UDim.new(0, 6),
        ["Parent"] = v54
    });
    v52 = r113;
    v52[v58] = v54; 
end;
local function r114(arg1_48, ...)
    E = r113;
    y = arg1_48;
    v1 = (23)[3];
    E = (23)[1];
    for v1, v3 in E, pairs(E) do
        v3.Visible = v1 == y; 
    end;
    E = v3[3];
    v1 = v3[2];
    for E, v3 in pairs(r111) do
        if E == y then
            v7 = r75;
            v5 = v7.Create(v7, v3, TweenInfo.new(.18, Enum.EasingStyle.Quint), {
                ["BackgroundColor3"] = r34.Accent,
                ["BackgroundTransparency"] = .88,
                ["TextColor3"] = Color3.fromRGB(255, 255, 255)
            });
            v5.Play(v5);
            if r112[E] then
                v7 = r75;
                v5 = v7.Create(v7, r112[v2], TweenInfo.new(.18), {
                    ["Transparency"] = .05
                });
                v5.Play(v5);
            end;
        end; 
    end; 
end;
local v62 = r111;
local v63 = v59[2];
local v64 = v59[1];
for v58, v62 in pairs(v62) do
    r115 = v58;
    v59 = v62.MouseButton1Click;
    v59.Connect(v59, function(...)
        r114(r115); 
    end); 
end;
local v65 = r113["ESP Options"];
local r116 = 0;
local function v66(...)
    r116 = r116 + 1;
    return r116; 
end;
v39(v65, "ESP Options", v66());
v40(v65, "Enable ESP", false, v66(), function(arg1_49, ...)
    v7 = r30;
    v7.ESPEnabled = arg1_49; 
end);
v40(v65, "Team Check", false, v66(), function(arg1_50, ...)
    v7 = r30;
    v7.TeamCheck = arg1_50; 
end);
v40(v65, "Skeleton ESP", false, v66(), function(arg1_51, ...)
    v7 = r30;
    v7.SkeletonESP = arg1_51; 
end);
v40(v65, "Head Dot", false, v66(), function(arg1_52, ...)
    v7 = r30;
    v7.HeadDot = arg1_52; 
end);
v40(v65, "Corner Box", false, v66(), function(arg1_53, ...)
    v7 = r30;
    v7.CornerBox = arg1_53; 
end);
v40(v65, "2D Box", false, v66(), function(arg1_54, ...)
    v7 = r30;
    v7.Box2D = arg1_54; 
end);
v40(v65, "3D Box", false, v66(), function(arg1_55, ...)
    v7 = r30;
    v7.Box3D = arg1_55; 
end);
v40(v65, "Name ESP", false, v66(), function(arg1_56, ...)
    v7 = r30;
    v7.NameESP = arg1_56; 
end);
v40(v65, "Distance ESP", false, v66(), function(arg1_57, ...)
    v7 = r30;
    v7.DistanceESP = arg1_57; 
end);
v40(v65, "Chams", false, v66(), function(arg1_58, ...)
    v7 = r30;
    v7.ChamsEnabled = arg1_58; 
end);
v40(v65, "Filled Chams", false, v66(), function(arg1_59, ...)
    v7 = r30;
    v7.FilledChams = arg1_59; 
end);
v43(v65, "Chams Material", {
    "Normal",
    "Wireframe",
    "Glass",
    "Material"
}, "Normal", v66(), function(arg1_60, ...)
    v7 = r30;
    v7.ChamsMaterial = arg1_60; 
end);
v40(v65, "ESP Outlines", true, v66(), function(arg1_61, ...)
    v7 = r30;
    v7.ESPOutlines = arg1_61; 
end);
v40(v65, "Glowing ESP", false, v66(), function(arg1_62, ...)
    v7 = r30;
    v7.GlowingESP = arg1_62; 
end);
v39(v65, "Viewmodel Chams", v66());
v40(v65, "Gun Chams", false, v66(), function(arg1_63, ...)
    v7 = r30;
    v7.GunChamsEnabled = arg1_63; 
end);
v40(v65, "Gun Rainbow", false, v66(), function(arg1_64, ...)
    v7 = r30;
    v7.GunRainbowChams = arg1_64; 
end);
v40(v65, "Gun Chams Filled", true, v66(), function(arg1_65, ...)
    v7 = r30;
    v7.GunChamsFilled = arg1_65; 
end);
v43(v65, "Gun Chams Material", {
    "Normal",
    "Animated",
    "Wireframe",
    "Glass",
    "Material"
}, "Normal", v66(), function(arg1_66, ...)
    v7 = r30;
    v7.GunChamsMaterial = arg1_66; 
end);
v40(v65, "Arm Chams", false, v66(), function(arg1_67, ...)
    v7 = r30;
    v7.ArmChamsEnabled = arg1_67; 
end);
v40(v65, "Arm Rainbow", false, v66(), function(arg1_68, ...)
    v7 = r30;
    v7.ArmRainbowChams = arg1_68; 
end);
v40(v65, "Arm Chams Filled", true, v66(), function(arg1_69, ...)
    v7 = r30;
    v7.ArmChamsFilled = arg1_69; 
end);
v43(v65, "Arm Chams Material", {
    "Normal",
    "Animated",
    "Wireframe",
    "Glass",
    "Material"
}, "Normal", v66(), function(arg1_70, ...)
    v7 = r30;
    v7.ArmChamsMaterial = arg1_70; 
end);
v39(v65, "Deployables ESP", v66());
v40(v65, "Barb Wire", false, v66(), function(arg1_71, ...)
    v7 = r30;
    v7.BarbWireESP = arg1_71; 
end);
v40(v65, "Fort Shield", false, v66(), function(arg1_72, ...)
    v7 = r30;
    v7.FortShieldESP = arg1_72; 
end);
v40(v65, "Metal Shield", false, v66(), function(arg1_73, ...)
    v7 = r30;
    v7.MetalShieldESP = arg1_73; 
end);
v40(v65, "Trip Wire", false, v66(), function(arg1_74, ...)
    v7 = r30;
    v7.TripWireESP = arg1_74; 
end);
local v67 = r113["ESP Colors"];
local r117 = 0;
local function v68(...)
    r117 = r117 + 1;
    return r117; 
end;
v39(v67, "ESP Colors", v68());
v41(v67, "Skeleton Color", r30.SkeletonColor, v68(), function(arg1_75, ...)
    v7 = r30;
    v7.SkeletonColor = arg1_75; 
end);
v41(v67, "Head Dot Color", r30.HeadDotColor, v68(), function(arg1_76, ...)
    v7 = r30;
    v7.HeadDotColor = arg1_76; 
end);
v41(v67, "Corner Box Color", r30.CornerBoxColor, v68(), function(arg1_77, ...)
    v7 = r30;
    v7.CornerBoxColor = arg1_77; 
end);
v41(v67, "2D Box Color", r30.Box2DColor, v68(), function(arg1_78, ...)
    v7 = r30;
    v7.Box2DColor = arg1_78; 
end);
v41(v67, "3D Box Color", r30.Box3DColor, v68(), function(arg1_79, ...)
    v7 = r30;
    v7.Box3DColor = arg1_79; 
end);
v41(v67, "Name Color", r30.NameColor, v68(), function(arg1_80, ...)
    v7 = r30;
    v7.NameColor = arg1_80; 
end);
v41(v67, "Distance Color", r30.DistanceColor, v68(), function(arg1_81, ...)
    v7 = r30;
    v7.DistanceColor = arg1_81; 
end);
v41(v67, "Chams Color", r30.ChamsColor, v68(), function(arg1_82, ...)
    v7 = r30;
    v7.ChamsColor = arg1_82; 
end);
v41(v67, "Gun Chams Color", r30.GunChamsColor, v68(), function(arg1_83, ...)
    v7 = r30;
    v7.GunChamsColor = arg1_83; 
end);
v41(v67, "Arm Chams Color", r30.ArmChamsColor, v68(), function(arg1_84, ...)
    v7 = r30;
    v7.ArmChamsColor = arg1_84; 
end);
local v69 = r58.Weapon;
local r118 = r37("UIGradient", {
    ["Color"] = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(.15, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(.35, Color3.fromRGB(255, 210, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(.65, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(.85, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 210, 40))
    }),
    ["Rotation"] = 0,
    ["Offset"] = Vector2.new(-1, 0),
    ["Parent"] = r37("TextLabel", {
        ["Size"] = UDim2.new(1, 0, 1, 0),
        ["BackgroundTransparency"] = 1,
        ["Text"] = "[ WIP! ]",
        ["TextColor3"] = Color3.fromRGB(255, 255, 255),
        ["TextSize"] = 18,
        ["Font"] = Enum.Font.Arcade,
        ["TextStrokeColor3"] = Color3.fromRGB(0, 0, 0),
        ["TextStrokeTransparency"] = 0.5,
        ["Parent"] = r37("Frame", {
            ["Size"] = UDim2.new(1, 0, 0, 34),
            ["BackgroundTransparency"] = 1,
            ["LayoutOrder"] = 0,
            ["Parent"] = v69
        })
    })
});
task.spawn(function(...)
    y = -1;
    while true do
        y = -1 + task.wait() * .7;
        if y > 1 then
            y = -1;
        end;
        v1 = r118;
        v1.Offset = Vector2.new(y, 0); 
    end; 
end);
v39(v69, "Ammo", 1);
v40(v69, "Infinite Reserve Ammo", false, 2, function(arg1_85, ...)
    v7 = r30;
    v7.InfiniteReserve = arg1_85; 
end);
v40(v69, "Infinite Magazine", false, 3, function(arg1_86, ...)
    v7 = r30;
    v7.InfiniteMag = arg1_86; 
end);
v39(v69, "Fire", 4);
v40(v69, "Rapid Fire", false, 5, function(arg1_87, ...)
    v7 = r30;
    v7.RapidFire = arg1_87; 
end);
v40(v69, "No Spread", false, 6, function(arg1_88, ...)
    v7 = r30;
    v7.NoSpread = arg1_88; 
end);
v40(v69, "Full Auto", false, 7, function(arg1_89, ...)
    v7 = r30;
    v7.FullAuto = arg1_89; 
end);
v38(v69, "Bullets", 0, 50, 1, 1, 8, function(arg1_90, ...)
    v7 = r30;
    v7.BulletCount = arg1_90; 
end);
v39(v69, "ADS / Ballistics", 9);
v40(v69, "Instant ADS", false, 10, function(arg1_91, ...)
    v7 = r30;
    v7.InstantADS = arg1_91; 
end);
v40(v69, "No Bullet Drop", false, 11, function(arg1_92, ...)
    v7 = r30;
    v7.NoBulletDrop = arg1_92; 
end);
v40(v69, "High Bullet Velocity", false, 12, function(arg1_93, ...)
    v7 = r30;
    v7.BulletVelocity = arg1_93; 
end);
v39(v69, "Recoil Control", 13);
v40(v69, "No Recoil", false, 14, function(arg1_94, ...)
    v7 = r30;
    v7.NoRecoilEnabled = arg1_94; 
end);
v38(v69, "Vertical Reduction %", 0, 100, 100, 5, 15, function(arg1_95, ...)
    v7 = r30;
    v7.RecoilReductionV = arg1_95; 
end);
v38(v69, "Horizontal Reduction %", 0, 100, 100, 5, 16, function(arg1_96, ...)
    v7 = r30;
    v7.RecoilReductionH = arg1_96; 
end);
v40(v69, "No Visual Recoil", false, 17, function(arg1_97, ...)
    v7 = r30;
    v7.NoVisualRecoil = arg1_97; 
end);
local v70 = r58.Movement;
local r119 = 0;
local function v71(...)
    r119 = r119 + 1;
    return r119; 
end;
v39(v70, "Speed", v71());
v40(v70, "Enable Speed", false, v71(), function(arg1_98, ...)
    v7 = r30;
    v7.SpeedEnabled = arg1_98; 
end);
v38(v70, "Speed Value", 16, 500, 16, 1, v71(), function(arg1_99, ...)
    v7 = r30;
    v7.SpeedValue = arg1_99; 
end);
v43(v70, "Speed Mode", {
    "Always",
    "Toggle",
    "Hold"
}, "Toggle", v71(), function(arg1_100, ...)
    v7 = r30;
    v7.SpeedMode = arg1_100; 
end);
v42(v70, "Speed Bind", "Z", v71(), function(arg1_101, ...)
    v7 = r30;
    v7.SpeedBind = arg1_101; 
end);
v39(v70, "Flight", v71());
v40(v70, "Enable Flight", false, v71(), function(arg1_102, ...)
    y = arg1_102;
    v7 = r30;
    v7.FlightEnabled = y;
    if not y and "Character" then
        v7 = ("Character").HumanoidRootPart;
        c = v7.FindFirstChild(v7, "SwagFlight");
        if c then
            c.Destroy(c);
        end;
    end; 
end);
v38(v70, "Flight Speed", 50, 500, 50, 5, v71(), function(arg1_103, ...)
    v7 = r30;
    v7.FlightValue = arg1_103; 
end);
v43(v70, "Flight Mode", {
    "Always",
    "Toggle",
    "Hold"
}, "Toggle", v71(), function(arg1_104, ...)
    v7 = r30;
    v7.FlightMode = arg1_104; 
end);
v42(v70, "Flight Bind", "F", v71(), function(arg1_105, ...)
    v7 = r30;
    v7.FlightBind = arg1_105; 
end);
v39(v70, "Noclip", v71());
v40(v70, "Enable Noclip", false, v71(), function(arg1_106, ...)
    v7 = r30;
    v7.NoclipEnabled = arg1_106; 
end);
v43(v70, "Noclip Mode", {
    "Always",
    "Toggle",
    "Hold"
}, "Toggle", v71(), function(arg1_107, ...)
    v7 = r30;
    v7.NoclipMode = arg1_107; 
end);
v42(v70, "Noclip Bind", "N", v71(), function(arg1_108, ...)
    v7 = r30;
    v7.NoclipBind = arg1_108; 
end);
v39(v70, "Infinite Jump", v71());
v40(v70, "Enable Infinite Jump", false, v71(), function(arg1_109, ...)
    v7 = r30;
    v7.InfJumpEnabled = arg1_109; 
end);
local v72 = r58.World;
local r120 = 0;
local function v73(...)
    r120 = r120 + 1;
    return r120; 
end;
v39(v72, "World Settings", v73());
v40(v72, "No Shadows", false, v73(), function(arg1_110, ...)
    v7 = r30;
    y = arg1_110;
    c = y;
    v7.NoShadows = c;
    v7 = game;
    M = v7.GetService(v7, "Lighting");
    M.GlobalShadows = not y; 
end);
v40(v72, "No View Bob", false, v73(), function(arg1_111, ...)
    v7 = r30;
    v7.NoViewBob = arg1_111; 
end);
v39(v72, "Camera", v73());
v38(v72, "Field Of View", 60, 140, 70, 1, v73(), function(arg1_112, ...)
    y = arg1_112;
    v7 = r30;
    c = y;
    v7.WorldFOV = c;
    v7 = workspace.CurrentCamera;
    v7.FieldOfView = y; 
end);
v40(v72, "Third Person", false, v73(), function(arg1_113, ...)
    y = arg1_113;
    v7 = r30;
    v7.ThirdPerson = y;
    if not y and r28 then
        v7 = r28;
        v7.CameraMinZoomDistance = 0.5;
        v7 = r28;
        v7.CameraMaxZoomDistance = 0.5;
        v7 = "Character";
        if v7 then
            v7 = "Character";
            c = v7.FindFirstChildOfClass(v7, "Humanoid");
            if c then
                c.CameraOffset = Vector3.new(0, 0, 0);
            end;
        end;
    end; 
end);
v38(v72, "Third Person Distance", 5, 50, 10, 1, v73(), function(arg1_114, ...)
    v7 = r30;
    v7.ThirdPersonDist = arg1_114; 
end);
local v74 = r58.Misc;
local r121 = 0;
local function v75(...)
    r121 = r121 + 1;
    return r121; 
end;
v39(v74, "Watermark & Overlay", v75());
v40(v74, "Show Watermark", true, v75(), function(arg1_115, ...)
    y = arg1_115;
    v7 = r30;
    c = y;
    v7.WatermarkVisible = c;
    if r32 then
        v7 = r32;
        c = arg1_115;
        v7.Visible = c;
    end; 
end);
v40(v74, "Show Keybind List", false, v75(), function(arg1_116, ...)
    v7 = r30;
    y = arg1_116;
    c = y;
    v7.KeybindListVisible = c;
    if r33 then
        v7 = r33;
        c = arg1_116;
        v7.Visible = c;
    end; 
end);
v39(v74, "Anti Vote Kick", v75());
v40(v74, "Anti Vote Kick", false, v75(), function(arg1_117, ...)
    v7 = r30;
    v7.AntiVoteKick = arg1_117; 
end);
v39(v74, "Unload", v75());
(function(arg1_118, arg2_118, arg3_118, arg4_118, ...)
    r122 = arg4_118;
    v2 = r37("Frame", {
        ["Size"] = UDim2.new(1, 0, 0, 34),
        ["BackgroundColor3"] = r34.SurfaceLight,
        ["BackgroundTransparency"] = 0,
        ["BorderSizePixel"] = 0,
        ["LayoutOrder"] = arg3_118,
        ["Parent"] = arg1_118
    });
    r38(v2, 7);
    r40(v2, 1.5, .35);
    r123 = r37("TextButton", {
        ["Size"] = UDim2.new(1, 0, 1, 0),
        ["BackgroundColor3"] = r34.SurfaceHover,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0,
        ["Text"] = arg2_118,
        ["TextColor3"] = r34.TextAccent,
        ["TextSize"] = 14,
        ["Font"] = Enum.Font.Arcade,
        ["Parent"] = v2
    });
    r38(r123, 7);
    v7 = r123.MouseEnter;
    v7.Connect(v7, function(...)
        v7 = r75;
        M = v7.Create(v7, r123, TweenInfo.new(.15, Enum.EasingStyle.Quint), {
            ["BackgroundColor3"] = r34.Accent,
            ["TextColor3"] = Color3.fromRGB(255, 255, 255)
        });
        M.Play(M); 
    end);
    v7 = r123.MouseLeave;
    v7.Connect(v7, function(...)
        v7 = r75;
        M = v7.Create(v7, r123, TweenInfo.new(.15, Enum.EasingStyle.Quint), {
            ["BackgroundColor3"] = r34.SurfaceHover,
            ["TextColor3"] = r34.TextAccent
        });
        M.Play(M); 
    end);
    v7 = r123.MouseButton1Click;
    v7.Connect(v7, function(...)
        if r122 then
            r122();
        end; 
    end);
    return v2; 
end)(v74, "Unload SwagWare", v75(), function(...)
    v7 = r30;
    v7.Toggled = false;
    if r43 then
        v7 = r43;
        v7.Visible = false;
    end;
    E = r30;
    v1 = E.ESPObjects;
    y = E[2];
    c = E[3];
    for c, v2 in pairs(M) do
        r124 = v2;
        E = c;
        pcall(function(...)
            v7 = z[v7].Box2D;
            v7.Remove(v7); 
        end);
        K = r124;
        v6 = K[2];
        v3 = K[1];
        for v5, K in ipairs(K.Corners) do
            I = v5;
            r125 = K;
            pcall(function(...)
                v7 = r125;
                v7.Remove(v7); 
            end); 
        end;
        pcall(function(...)
            v7 = r124.Name;
            v7.Remove(v7); 
        end);
        pcall(function(...)
            v7 = r124.Distance;
            v7.Remove(v7); 
        end);
        pcall(function(...)
            v7 = r124.HeadDot;
            v7.Remove(v7); 
        end);
        K = r124;
        v5 = K[3];
        v6 = K[2];
        for v5, K in ipairs(K.Skeleton) do
            I = v5;
            r126 = K;
            pcall(function(...)
                v7 = r126;
                v7.Remove(v7); 
            end); 
        end;
        K = r124;
        v5 = K[3];
        v6 = K[2];
        for v5, K in ipairs(K.Box3D) do
            I = v5;
            r127 = K;
            pcall(function(...)
                v7 = r127;
                v7.Remove(v7); 
            end); 
        end; 
    end;
    y = v2[1];
    c = v2[2];
    for v1, v2 in pairs(r31) do
        E = v1;
        r128 = v2;
        pcall(function(...)
            v7 = r128;
            v7.Destroy(v7); 
        end); 
    end;
    if r30.FOVCircle then
        pcall(function(...)
            v7 = r30.FOVCircle;
            v7.Remove(v7); 
        end);
    end;
    if r30.FOVCircleInner then
        pcall(function(...)
            v7 = r30.FOVCircleInner;
            v7.Remove(v7); 
        end);
    end;
    v7 = r35;
    if v7 then
        v7 = r35;
        v7.Destroy(v7);
    end; 
end);
local v76 = r58["Rage Bot"];
local r129 = 0;
local function v77(...)
    r129 = r129 + 1;
    return r129; 
end;
v39(v76, "Rage Bot", v77());
v40(v76, "Silent Aim", false, v77(), function(arg1_119, ...)
    v7 = r30;
    v7.RageSilentAim = arg1_119; 
end);
v40(v76, "Auto Shoot", false, v77(), function(arg1_120, ...)
    v7 = r30;
    v7.RageAutoShoot = arg1_120; 
end);
v38(v76, "FOV", 1, 500, 180, 1, v77(), function(arg1_121, ...)
    v7 = r30;
    v7.RageFOV = arg1_121; 
end);
v38(v76, "Delay (ms)", 0, 500, 0, 10, v77(), function(arg1_122, ...)
    v7 = r30;
    v7.RageDelay = arg1_122; 
end);
v40(v76, "Team Check", false, v77(), function(arg1_123, ...)
    v7 = r30;
    v7.RageTeamCheck = arg1_123; 
end);
v39(v76, "Anti Aim", v77());
v40(v76, "Enable Anti Aim", false, v77(), function(arg1_124, ...)
    v7 = r30;
    v7.AntiAimEnabled = arg1_124; 
end);
v39(v76, "Yaw", v77());
v43(v76, "Yaw Mode", {
    "Off",
    "Spin",
    "Jitter",
    "Static"
}, "Off", v77(), function(arg1_125, ...)
    v7 = r30;
    v7.AAYawMode = arg1_125; 
end);
v38(v76, "Yaw Value", -180, 180, 0, 1, v77(), function(arg1_126, ...)
    v7 = r30;
    v7.AAYawValue = arg1_126; 
end);
v39(v76, "Pitch", v77());
v43(v76, "Pitch Mode", {
    "Off",
    "Jitter",
    "Static"
}, "Off", v77(), function(arg1_127, ...)
    v7 = r30;
    v7.AAPitchMode = arg1_127; 
end);
v38(v76, "Pitch Value", -90, 90, 0, 1, v77(), function(arg1_128, ...)
    v7 = r30;
    v7.AAPitchValue = arg1_128; 
end);
v39(v76, "Roll", v77());
v43(v76, "Roll Mode", {
    "Off",
    "Jitter",
    "Spin",
    "Static"
}, "Off", v77(), function(arg1_129, ...)
    v7 = r30;
    v7.AARollMode = arg1_129; 
end);
v38(v76, "Roll Value", -180, 180, 0, 1, v77(), function(arg1_130, ...)
    v7 = r30;
    v7.AARollValue = arg1_130; 
end);
r60("Aimbot");
local v78 = r26.InputBegan;
v78.Connect(v78, function(arg1_131, arg2_131, ...)
    y = arg1_131;
    c = arg2_131;
    if not r30.MenuAllowed then
        return;
    end;
    if y.KeyCode == Enum.KeyCode.RightShift or y.KeyCode == Enum.KeyCode.Insert then
        v7 = r30;
        v7.Toggled = not r30.Toggled;
        v7 = r43;
        v7.Visible = r30.Toggled;
    end; 
end);
pcall(function(...)
    v7 = r30;
    v7.FOVCircle = Drawing.new("Circle");
    v7 = r30.FOVCircle;
    v7.Visible = false;
    v7 = r30.FOVCircle;
    v7.Radius = r30.AimbotFOV;
    v7 = r30.FOVCircle;
    v7.Color = r34.Accent;
    v7 = r30.FOVCircle;
    v7.Thickness = 1.5;
    v7 = r30.FOVCircle;
    v7.Transparency = .6;
    v7 = r30.FOVCircle;
    v7.Filled = false;
    v7 = r30.FOVCircle;
    v7.NumSides = 64;
    v7 = r30;
    v7.FOVCircleInner = Drawing.new("Circle");
    v7 = r30.FOVCircleInner;
    v7.Visible = false;
    v7 = r30.FOVCircleInner;
    v7.Radius = r30.AimbotFOV;
    v7 = r30.FOVCircleInner;
    v7.Color = r34.AccentGlow;
    v7 = r30.FOVCircleInner;
    v7.Thickness = .8;
    v7 = r30.FOVCircleInner;
    v7.Transparency = 0.75;
    v7 = r30.FOVCircleInner;
    v7.Filled = false;
    v7 = r30.FOVCircleInner;
    v7.NumSides = 64;
    v7 = r30;
    v7.RageFOVCircle = Drawing.new("Circle");
    v7 = r30.RageFOVCircle;
    v7.Visible = false;
    v7 = r30.RageFOVCircle;
    v7.Radius = r30.RageFOV;
    v7 = r30.RageFOVCircle;
    v7.Color = Color3.fromRGB(255, 50, 50);
    v7 = r30.RageFOVCircle;
    v7.Thickness = 1.5;
    v7 = r30.RageFOVCircle;
    v7.Transparency = 0.5;
    v7 = r30.RageFOVCircle;
    v7.Filled = false;
    v7 = r30.RageFOVCircle;
    v7.NumSides = 64;
    v7 = r30;
    v7.RageFOVCircleInner = Drawing.new("Circle");
    v7 = r30.RageFOVCircleInner;
    v7.Visible = false;
    v7 = r30.RageFOVCircleInner;
    v7.Radius = r30.RageFOV;
    v7 = r30.RageFOVCircleInner;
    v7.Color = Color3.fromRGB(255, 120, 120);
    v7 = r30.RageFOVCircleInner;
    v7.Thickness = .8;
    v7 = r30.RageFOVCircleInner;
    v7.Transparency = .7;
    v7 = r30.RageFOVCircleInner;
    v7.Filled = false;
    v7 = r30.RageFOVCircleInner;
    v7.NumSides = 64; 
end);
local function r130(arg1_132, ...)
    y = arg1_132;
    if not y then
        return false;
    end;
    c = r27.CFrame.Position;
    E = RaycastParams.new();
    E.FilterType = Enum.RaycastFilterType.Exclude;
    v2 = {};
    if "Character" then
        table.insert(v2, "Character");
    end;
    v5 = "\x05\xb6\xb5\xe9{b_ \xb2H\x90v\x95\xd0\x12\xa8\x86\x00Q\xb7|X\xac\n\xf6n";
    v6 = 1671477674762;
    E[r15[v6]] = v2;
    v7 = workspace;
    v3 = v7.Raycast(v7, c, y.Position - c, E);
    if v3 then
        v6 = v3.Instance;
        v5 = y.Parent;
        if v5 then
            M = v6.IsDescendantOf(v6, v5);
        end;
        if v5 then
            return true;
        end;
        return false;
    end;
    return true; 
end;
local function r131(...)
    y = r30.AimbotBind;
    v7 = y == "MB1";
    if v7 then
        v7 = r26;
        return v7.IsMouseButtonPressed(v7, Enum.UserInputType.MouseButton1);
    end;
    v7 = y == "MB2";
    if v7 then
        v7 = r26;
        return v7.IsMouseButtonPressed(v7, Enum.UserInputType.MouseButton2);
    end;
    v7 = Enum.KeyCode[y];
    if v7 then
        v7 = r26;
        return v7.IsKeyDown(v7, v7);
    end;
    return false; 
end;
local function r132(arg1_133, arg2_133, ...)
    c = arg2_133;
    y = arg1_133;
    if not y then
        return nil;
    end;
    M = c;
    if c then
        E = z[E];
        if c == "Head" then
            E = y.FindFirstChild(y, "Head");
            if E then
                return E;
            else
                M = y.FindFirstChild(y, "HumanoidRootPart");
            end;
        end;
        E = z[E];
        if c == "Torso" then
            E = y.FindFirstChild(y, "UpperTorso");
            if E then
                return E;
            else
                M = y.FindFirstChild(y, "Torso") or y.FindFirstChild(y, "HumanoidRootPart");
                v7 = v1 == M;
            end;
        end;
        E = c == "RootPart";
        if E or c == "HumanoidRootPart" then
            E = y.FindFirstChild(y, "HumanoidRootPart");
            if E then
                return E;
            else
                M = y.FindFirstChild(y, "Torso");
            end;
        end;
        E = y.FindFirstChild(y, "Head");
        if E then
            return E;
        else
            M = y.FindFirstChild(y, "HumanoidRootPart");
        end;
    else
        M = "Head";
    end; 
end;
local function r133(arg1_134, arg2_134, ...)
    y = arg1_134;
    c = arg2_134;
    M = c;
    if c then
        v2 = c;
        Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
        I = r24;
        v5 = I[3];
        v6 = I[2];
        I = "ipairs";
        for v5, q in ipairs(I.GetPlayers(I)) do
            K = v5;
            if q ~= r28 and q.Character then
                v9 = r30.TeamCheck;
                Q = v9 and (q.Team ~= nil and q.Team == "Team");
                if Q then
                else
                    Q = r132(q.Character, arg1_134);
                    v7 = q.Character;
                    v9 = v7.FindFirstChildOfClass(v7, "Humanoid");
                    if v9 then
                        S = v9.Health > 0 and Q;
                        v7 = q.Character;
                    end;
                    if v9 then
                        A = r16;
                        if r30.VisCheckEnabled and not r130(Q) then
                        else
                            v7 = r27;
                            A = {
                                v7.WorldToViewportPoint(v7, r132(q[r15[r16("\x97t\xee\x84u\xc3\xe2\x1c(", T)]], y).Position)
                            };
                            N = A[2];
                            S = v7.WorldToViewportPoint(v7, r132(q[r15[r16("\x97t\xee\x84u\xc3\xe2\x1c(", T)]], y).Position);
                            if N then
                                C = Vector2.new("X", "Y") - Vector2.new(r27.ViewportSize.v2 / 2, r27[r15[r16("H\xe2\xb7\xcfT\xfd\x88\x9e\n\xee\x18\xde", C)]][r15[v9]] / 2);
                                v7 = ("Magnitude" and C) < c;
                            end;
                        end;
                    end;
                end;
            end; 
        end;
        return nil, nil;
    else
        M = r30.AimbotFOV;
    end; 
end;
local function r137(arg1_137, ...)
    y = arg1_137;
    r138 = r30.ESPObjects[y];
    if not r138 then
        return;
    end;
    pcall(function(...)
        v7 = r138.Box2D;
        v7.Remove(v7); 
    end);
    v3 = r138;
    v2 = v3.Corners;
    v2 = v3[1];
    E = v3[3];
    for E, v6 in v2, ipairs(v2) do
        r139 = v6;
        v3 = E;
        pcall(function(...)
            v7 = z[v7];
            v7.Remove(v7); 
        end); 
    end;
    pcall(function(...)
        v7 = r138.Name;
        v7.Remove(v7); 
    end);
    pcall(function(...)
        v7 = r138.Distance;
        v7.Remove(v7); 
    end);
    pcall(function(...)
        v7 = r138.HeadDot;
        v7.Remove(v7); 
    end);
    v6 = r138;
    E = v6[2];
    v1 = v6[1];
    for v2, v6 in ipairs(v6.Skeleton) do
        v3 = v2;
        r140 = v6;
        pcall(function(...)
            v7 = z[v7];
            v7.Remove(v7); 
        end); 
    end;
    v6 = r138;
    E = v6[2];
    v2 = v6[3];
    for v2, v6 in ipairs(v6.Box3D) do
        v3 = v2;
        r141 = v6;
        pcall(function(...)
            v7 = z[v7];
            v7.Remove(v7); 
        end); 
    end;
    v7 = r30.ESPObjects;
    v7[y] = nil; 
end;
local function r142(arg1_138, ...)
    y = arg1_138;
    v7 = y.Box2D;
    v7.Visible = false;
    v7 = ipairs;
    v2 = {
        v7(y.Corners)
    };
    c = v2[2];
    E = v7(y.Corners);
    v1 = v2[3];
    v1, v3 = E(c, v1);
    if v1 then
        v7 = z[r30.AimbotFOV];
        while not (B and v9[2] == Q) do
            Q, v9 = K(q, Q);
            while Q do
                C = v9 ~= r28;
                if C then
                    S = v9.Character;
                end;
                v7 = v7;
                if C then
                    N = v7;
                    S = r30.TeamCheck and (v9.Team ~= nil and v9.Team == "Team");
                    if S then
                    else
                        S = r132(v9.Character, r30.TriggerBone);
                        C = v9.Character;
                        C = S;
                        N = C.FindFirstChildOfClass(C, "Humanoid");
                        B = N;
                        if S then
                            if N then
                                G = S.FindFirstChildOfClass(S, 5289567504799).Health > 0;
                            end;
                            v7 = N;
                            C = N;
                        end;
                    end;
                end; 
            end;
            if {
                v7(Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2)[r15[v5]])
            } then
                if not r30._hadTargetLastFrame then
                    v5 = r30;
                    v5._targetFirstSeen = v5();
                end;
                v5 = r30;
                v5._hadTargetLastFrame = true;
                Q = "}";
                v9 = v7;
                N = v7;
                if os.clock() - (r30._targetFirstSeen or 0) >= (r30.TriggerReaction or 30) / 1000 then
                    N = 0;
                    if v5() - (r30._lastShotTime or 0) >= (r30.TriggerDelay or 50) / 1000 then
                        Q = r30;
                        Q._lastShotTime = v5();
                        mouse1click();
                    end;
                end;
            else
                v5 = r30;
                v5._hadTargetLastFrame = false;
                v5 = r30;
                v5._targetFirstSeen = 0;
            end;
            if r30.RageAutoShoot then
                Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
                v9 = r24;
                q = v9[2];
                Q = v9[3];
                for Q, v9 in ipairs(v9.GetPlayers(v9)) do
                    v5 = Q;
                    v7 = v7;
                    if v9 ~= r28 and v9.Character then
                        S = r30.RageTeamCheck and (v9.Team ~= nil and v9.Team == "Team");
                        v7 = v7;
                        if S then
                        else
                            N = v9.Character;
                            S = N.FindFirstChildOfClass(N, "Humanoid");
                            if S then
                                N = "Health" > 0;
                            end;
                            v7 = N;
                            if S then
                                T = "Torso";
                                G = T[2];
                                l = T[3];
                                for l, T in ipairs({
                                    "Head",
                                    "UpperTorso",
                                    "LowerTorso",
                                    "HumanoidRootPart",
                                    T,
                                    "RightArm",
                                    "LeftArm",
                                    "RightLeg",
                                    "LeftLeg"
                                }) do
                                    b6 = "\xa6\xf5\xe6R\xbc\xa4\x8dK\t";
                                    R = v9.Character;
                                    v14 = R.FindFirstChild(R, T);
                                    if v14 then
                                        R = r27;
                                        b6 = {
                                            R.WorldToViewportPoint(R, v14.Position)
                                        };
                                        v15 = R.WorldToViewportPoint(R, v14.Position);
                                        if b6[2] then
                                            if (Vector2.new(v15.v2, v15.Y) - Vector2.new(r27.ViewportSize.v2 / 2, r27[r15[r16("\x00!\xdd1\xbf\xbd1j\xda(\x1c\xe8", l)]][r15[l]] / 2)).Magnitude <= r30.RageFOV then
                                                if r130(R.FindFirstChild(R, T)) then
                                                    (nil).FindFirstChild(nil, nil);
                                                end;
                                            end;
                                        end;
                                    end; 
                                end;
                            end;
                            if nil then
                            end;
                        end;
                    end; 
                end;
                if nil then
                    Q = r16;
                    S = v7;
                    if tick() - (r30._rageLastShot or 0) >= (r30.RageDelay or 0) / 1000 then
                        q = r30;
                        q._rageLastShot = tick();
                        mouse1click();
                    end;
                end;
            end;
            q = r24;
            v3 = q[1];
            v5 = q[2];
            for K, q in ipairs(q.GetPlayers(q)) do
                r143 = q;
                v2 = K;
                if r143 ~= r28 then
                    G = r16;
                    v7 = v7;
                    if r30.TeamCheck and (r143.Team ~= nil and r143.Team == "Team") then
                        Q = r30.ESPObjects[r143];
                        if Q then
                            r142(Q);
                        end;
                        if r31[r143] then
                            pcall(function(...)
                                local m = {
                                    192,
                                    40
                                };
                                v7 = z[m[13]][r143];
                                v7.Destroy(v7); 
                            end);
                            v9 = z[({
                                199,
                                201
                            })[13]];
                            v9[r143] = nil;
                        end;
                    else
                        G = {
                            pcall(function(...)
                                y = r143.Character;
                                c = y and y.FindFirstChild(y, "HumanoidRootPart");
                                v1 = y and y.FindFirstChild(y, "Head");
                                if y then
                                    M = y.FindFirstChildOfClass(y, "Humanoid");
                                end;
                                E = y;
                                v2 = not r30.ESPEnabled;
                                M = K;
                                if K then
                                end; 
                            end)
                        };
                        S = G[2];
                        if not pcall(function(...)
                            y = r143.Character;
                            c = y and y.FindFirstChild(y, "HumanoidRootPart");
                            v1 = y and y.FindFirstChild(y, "Head");
                            if y then
                                M = y.FindFirstChildOfClass(y, "Humanoid");
                            end;
                            E = y;
                            v2 = not r30.ESPEnabled;
                            M = K;
                            if K then
                            end; 
                        end) then
                            r137(r143);
                            if r31[r143] then
                                pcall(function(...)
                                    v7 = z[({
                                        199,
                                        201
                                    })[13]][r143];
                                    v7.Destroy(v7); 
                                end);
                                Q = z[({
                                    199,
                                    201
                                })[13]];
                                Q[r143] = nil;
                            end;
                        end;
                    end;
                end; 
            end;
            return; 
        end;
        C = r27;
        l = {
            C.WorldToViewportPoint(C, (190).Position)
        };
        B = C.WorldToViewportPoint(C, (190).Position);
        if l[2] then
            T = r15;
            if (Vector2.new(B.v2, B.Y) - Vector2.new(r27.ViewportSize.v2 / 2, r27[r15[r16("\xfe\xe2\xe1\xb6F\x00\x18\xe5\x90\xe3^\xc8", A)]][r15[C]] / 2)).Magnitude < 25 then
                T = not r30.VisCheckEnabled;
                if T then
                    v7 = z[r30.AimbotFOV];
                    if T then
                        v2 = true;
                    end;
                else
                    z[({
                        199,
                        201
                    })[8]](190);
                end;
            end;
        end;
    end;
    v3 = ".\xed\x8a1";
    v7 = y.Name;
    v7.Visible = false;
    v7 = y.Distance;
    v7.Visible = false;
    v7 = y.HeadDot;
    v7.Visible = false;
    v3 = "Skeleton";
    E = v3[3];
    v1 = v3[2];
    for E, v3 in ipairs(y[v3]) do
        v2 = E;
        v3.Visible = false; 
    end;
    v3 = "Box3D";
    v1 = v3[2];
    E = v3[3];
    for E, v3 in ipairs(y[v3]) do
        v2 = E;
        v3.Visible = false; 
    end; 
end;
local v79 = r25.RenderStepped;
v79.Connect(v79, function(...)
    r153 = workspace.CurrentCamera;
    if not r153 then
        return;
    end;
    if r30.WorldFOV and r30.WorldFOV ~= 70 then
        if r153.FieldOfView ~= r30.WorldFOV then
            v7 = r153;
            v7.FieldOfView = r30.WorldFOV;
        end;
        c = r153;
        if r152 ~= c then
            v7 = r151;
            if v7 then
                v7 = r151;
                v7.Disconnect(v7);
            end;
            r152 = r153;
            M = r153;
            c = M.GetPropertyChangedSignal(M, "FieldOfView");
            r151 = c.Connect(c, function(...)
                if r30.WorldFOV and r30.WorldFOV ~= 70 then
                    if r153.FieldOfView ~= r30.WorldFOV then
                        v7 = r153;
                        v7.FieldOfView = r30.WorldFOV;
                    end;
                end; 
            end);
        end;
    else
        if r151 then
            c = r151;
            c.Disconnect(c);
        end;
        return;
    end; 
end);
local v80 = r25.RenderStepped;
v80.Connect(v80, function(...)
    v7 = workspace.CurrentCamera;
    if v7 then
        r27 = workspace.CurrentCamera;
    end;
    y = Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
    c = r30.AimbotFOV;
    if r30.SilentAimEnabled then
        c = r30.SilentAimFOV;
    end;
    v7 = v7;
    v1 = (r30.AimbotEnabled or r30.SilentAimEnabled) and r30.MenuAllowed;
    v3 = "FOVCircle";
    if r30[v3] then
        E = r30.FOVCircle;
        v3 = (r30[r15[Q]] or r30.SilentAimEnabled) and r30.MenuAllowed;
        E.Visible = v3;
        E = r30.FOVCircle;
        v3 = Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
        E.Position = v3;
        E = r30.FOVCircle;
        v3 = r30.AimbotFOV;
        E.Radius = v3;
    end;
    if r30.FOVCircleInner then
        E = r30.FOVCircleInner;
        v3 = (r30[r15[Q]] or r30.SilentAimEnabled) and r30.MenuAllowed;
        E.Visible = v3;
        E = r30.FOVCircleInner;
        v3 = Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
        E.Position = v3;
        E = r30.FOVCircleInner;
        E.Radius = c - 2;
    end;
    E = (r30.RageSilentAim or r30.RageAutoShoot) and r30.MenuAllowed;
    v7 = v7;
    v7 = v7;
    if r30.RageFOVCircle then
        v2 = r30.RageFOVCircle;
        v6 = (r30[r15[v9]] or r30.RageAutoShoot) and r30.MenuAllowed;
        v2.Visible = v6;
        v2 = r30.RageFOVCircle;
        v6 = Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
        v2.Position = v6;
        v2 = r30.RageFOVCircle;
        v2.Radius = r30.RageFOV;
    end;
    if r30.RageFOVCircleInner then
        v2 = r30.RageFOVCircleInner;
        v6 = (r30[r15[v9]] or r30.RageAutoShoot) and r30.MenuAllowed;
        v2.Visible = v6;
        v2 = r30.RageFOVCircleInner;
        v6 = Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
        v2.Position = v6;
        v2 = r30.RageFOVCircleInner;
        v2.Radius = r30.RageFOV - 2;
    end;
    if r30.NoShadows then
        v2 = game;
        v3 = v2.GetService(v2, "Lighting");
        v3.GlobalShadows = false;
    end;
    v3 = v7;
    v7 = v3;
    if r30.ThirdPerson and r28 then
        v2 = r28;
        v2.CameraMaxZoomDistance = r30.ThirdPersonDist;
        v2 = r28;
        v2.CameraMinZoomDistance = r30.ThirdPersonDist;
        if "Character" then
            v2 = "Character";
            v3 = v2.FindFirstChildOfClass(v2, "Humanoid");
            v2 = "Character";
            v6 = v2.FindFirstChild(v2, "HumanoidRootPart");
            if v3 then
                v3.CameraOffset = Vector3.new(1.75, 0, 0);
            end;
            v7 = v7;
            if not r30.Toggled and r30.MenuAllowed then
                v2 = r26;
                v2.MouseBehavior = Enum.MouseBehavior.LockCenter;
                if v6 then
                    if v3 then
                        I = v2.FindFirstChildOfClass(v2, "Humanoid").Health > 0;
                    end;
                    v7 = v5;
                    v2 = v3;
                end;
                v7 = v7;
                if v6 then
                    v2 = r27.CFrame.LookVector;
                    v6.CFrame = CFrame.new("Position", "Position" + Vector3.new(v2.v2, 0, v2.Z));
                end;
            end;
        end;
    end;
    v7 = v7;
    if r30.AimbotEnabled and not r30.SilentAimEnabled then
        if r131() then
            v6 = r30.StickyAimEnabled and r30._stickyTarget;
            v7 = v3;
            if v6 then
                v6 = r30._stickyPlayer;
                K = v7;
                if v6 then
                    I = "Character" and r30._stickyTarget;
                    v7 = v7;
                end;
                v7 = K;
                if v6 then
                    I = "Character";
                    Q = r15;
                    K = I.FindFirstChildOfClass(I, "Humanoid");
                    if K then
                        I = K.Health > 0;
                    end;
                    if K then
                        q = K;
                        Q = not r30.VisCheckEnabled;
                        if Q then
                            if Q then
                                v2 = r30[q[v9]];
                            end;
                            if not nil then
                                K = r30;
                                K._stickyTarget = nil;
                                K = r30;
                                K._stickyPlayer = nil;
                            end;
                            if not nil then
                                v9 = {
                                    r133(r30.AimbotBone, r30.AimbotFOV)
                                };
                                v5 = r133(r30.AimbotBone, r30.AimbotFOV);
                                v2 = v5;
                                Q = v9;
                                v9 = r30.StickyAimEnabled;
                                if v9 then
                                    q = v9[1];
                                end;
                                v7 = v9;
                                if v9 then
                                    q = r30;
                                    v9 = v5;
                                    q._stickyTarget = v9;
                                    q = r30;
                                    v9 = v9[2];
                                    q._stickyPlayer = v9;
                                end;
                            end;
                            if nil then
                                v5 = r27;
                                Q = r27.CFrame;
                                v5.CFrame = Q.Lerp(Q, CFrame.new(r27.CFrame.Position, (nil).Position), 1 / r30.AimbotSmoothing);
                            end;
                            v9 = "}\xe4}8\x1fH\xf5\xdd7 \x0b\x00\xdf\xe2\x82Q\xf6";
                            v5 = "TriggerBotEnabled";
                            if r30[v5] then
                                C = 5289567504799;
                                Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
                                v2 = false;
                                v5 = ipairs;
                                v9 = r24;
                                K = v9[1];
                                q = v9[2];
                                for Q, v9 in v5(v9.GetPlayers(v9)) do
                                    C = v9 ~= r28;
                                    if C then
                                        S = v9.Character;
                                    end;
                                    v7 = v7;
                                    if C then
                                        N = v7;
                                        S = r30.TeamCheck and (v9.Team ~= nil and v9.Team == "Team");
                                        if C then
                                            S = v9.Team ~= nil and v9.Team == "Team";
                                            v7 = v7;
                                        end;
                                        if S then
                                        else
                                            S = r132(v9.Character, r30.TriggerBone);
                                            C = v9.Character;
                                            C = S;
                                            N = C.FindFirstChildOfClass(C, "Humanoid");
                                            B = N;
                                            if S then
                                                if N then
                                                    G = S.FindFirstChildOfClass(S, 5289567504799).Health > 0;
                                                end;
                                                v7 = N;
                                                C = N;
                                            end;
                                            v7 = z[r30.AimbotFOV];
                                            if B and v9[2] == Q then
                                                C = r27;
                                                l = {
                                                    C.WorldToViewportPoint(C, (190).Position)
                                                };
                                                B = C.WorldToViewportPoint(C, (190).Position);
                                                if l[2] then
                                                    T = r15;
                                                    if (Vector2.new(B.v2, B.Y) - Vector2.new(r27.ViewportSize.v2 / 2, r27[r15[r16("\xfe\xe2\xe1\xb6F\x00\x18\xe5\x90\xe3^\xc8", A)]][r15[C]] / 2)).Magnitude < 25 then
                                                        T = not r30.VisCheckEnabled;
                                                        if T then
                                                            v7 = z[r30.AimbotFOV];
                                                            if T then
                                                                v2 = true;
                                                            end;
                                                        else
                                                            z[({
                                                                199,
                                                                201
                                                            })[8]](190);
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end; 
                                end;
                                if {
                                    v7(Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2)[r15[v5]])
                                } then
                                    if not r30._hadTargetLastFrame then
                                        v5 = r30;
                                        v5._targetFirstSeen = v5();
                                    end;
                                    v5 = r30;
                                    v5._hadTargetLastFrame = true;
                                    Q = "}";
                                    v9 = v7;
                                    N = v7;
                                    if os.clock() - (r30._targetFirstSeen or 0) >= (r30.TriggerReaction or 30) / 1000 then
                                        N = 0;
                                        if v5() - (r30._lastShotTime or 0) >= (r30.TriggerDelay or 50) / 1000 then
                                            Q = r30;
                                            Q._lastShotTime = v5();
                                            mouse1click();
                                        end;
                                    end;
                                else
                                    v5 = r30;
                                    v5._hadTargetLastFrame = false;
                                    v5 = r30;
                                    v5._targetFirstSeen = 0;
                                end;
                            else
                                v2 = r30;
                                v2._hadTargetLastFrame = false;
                            end;
                            if r30.RageAutoShoot then
                                Vector2.new(r27.ViewportSize.v2 / 2, r27.ViewportSize.Y / 2);
                                v9 = r24;
                                q = v9[2];
                                Q = v9[3];
                                Q, v9 = K(q, Q);
                                while Q do
                                    v5 = Q;
                                    if r15 then
                                        S = v9.Character;
                                    end;
                                    v7 = v7;
                                    if v9 ~= r28 and v9.Character then
                                        S = r30.RageTeamCheck and (v9.Team ~= nil and v9.Team == "Team");
                                        if r15 then
                                            S = v9.Team ~= nil and v9.Team == "Team";
                                            v7 = v7;
                                        end;
                                        v7 = v7;
                                        if S then
                                        else
                                            N = v9.Character;
                                            S = N.FindFirstChildOfClass(N, "Humanoid");
                                            if S then
                                                N = "Health" > 0;
                                            end;
                                            v7 = N;
                                            if S then
                                                T = "Torso";
                                                G = T[2];
                                                l = T[3];
                                                l, T = B(G, l);
                                                while l do
                                                    b6 = "\xa6\xf5\xe6R\xbc\xa4\x8dK\t";
                                                    R = v9.Character;
                                                    v14 = R.FindFirstChild(R, T);
                                                    if v14 then
                                                        R = r27;
                                                        b6 = {
                                                            R.WorldToViewportPoint(R, v14.Position)
                                                        };
                                                        v15 = R.WorldToViewportPoint(R, v14.Position);
                                                        if b6[2] then
                                                            if (Vector2.new(v15.v2, v15.Y) - Vector2.new(r27.ViewportSize.v2 / 2, r27[r15[r16("\x00!\xdd1\xbf\xbd1j\xda(\x1c\xe8", l)]][r15[l]] / 2)).Magnitude <= r30.RageFOV then
                                                                if r130(R.FindFirstChild(R, T)) then
                                                                    (nil).FindFirstChild(nil, nil);
                                                                end;
                                                            end;
                                                        end;
                                                    end; 
                                                end;
                                            end;
                                            if nil then
                                            end;
                                        end;
                                    end; 
                                end;
                                if nil then
                                    Q = r16;
                                    S = v7;
                                    if tick() - (r30._rageLastShot or 0) >= (r30.RageDelay or 0) / 1000 then
                                        q = r30;
                                        q._rageLastShot = tick();
                                        mouse1click();
                                    end;
                                end;
                            end;
                            q = r24;
                            v3 = q[1];
                            v5 = q[2];
                            K, q = v3(v5, K);
                            while K do
                                r143 = q;
                                v2 = K;
                                if r143 ~= r28 then
                                    G = r16;
                                    if 34672790814481 then
                                        Q = z[q].Team ~= nil and z[q].Team == "Team";
                                        v7 = v7;
                                    end;
                                    v7 = v7;
                                    if r30.TeamCheck and (r143.Team ~= nil and r143.Team == "Team") then
                                        Q = r30.ESPObjects[r143];
                                        if Q then
                                            r142(Q);
                                        end;
                                        if r31[r143] then
                                            pcall(function(...)
                                                local m = {
                                                    192,
                                                    40
                                                };
                                                v7 = z[m[13]][r143];
                                                v7.Destroy(v7); 
                                            end);
                                            v9 = z[({
                                                199,
                                                201
                                            })[13]];
                                            v9[r143] = nil;
                                        end;
                                    else
                                        G = {
                                            pcall(function(...)
                                                y = r143.Character;
                                                c = y and y.FindFirstChild(y, "HumanoidRootPart");
                                                v1 = y and y.FindFirstChild(y, "Head");
                                                if y then
                                                    M = y.FindFirstChildOfClass(y, "Humanoid");
                                                end;
                                                E = y;
                                                v2 = not r30.ESPEnabled;
                                                M = K;
                                                if K then
                                                end; 
                                            end)
                                        };
                                        S = G[2];
                                        if not pcall(function(...)
                                            y = r143.Character;
                                            c = y and y.FindFirstChild(y, "HumanoidRootPart");
                                            v1 = y and y.FindFirstChild(y, "Head");
                                            if y then
                                                M = y.FindFirstChildOfClass(y, "Humanoid");
                                            end;
                                            E = y;
                                            v2 = not r30.ESPEnabled;
                                            M = K;
                                            if K then
                                            end; 
                                        end) then
                                            r137(r143);
                                            if r31[r143] then
                                                pcall(function(...)
                                                    v7 = z[({
                                                        199,
                                                        201
                                                    })[13]][r143];
                                                    v7.Destroy(v7); 
                                                end);
                                                Q = z[({
                                                    199,
                                                    201
                                                })[13]];
                                                Q[r143] = nil;
                                            end;
                                        end;
                                    end;
                                end; 
                            end;
                            return;
                        else
                            I = r130(r30[q[v9]]);
                        end;
                    end;
                end;
            end;
        else
            if r30.StickyAimEnabled then
            end;
        end;
    end; 
end);
local v81 = r24.PlayerRemoving;
v81.Connect(v81, function(arg1_145, ...)
    y = arg1_145;
    r137(y);
    if r31[y] then
        v7 = r31[y];
        v7.Destroy(v7);
        v7 = r31;
        v7[y] = nil;
    end; 
end);
local function r154(...)
    pcall(function(...)
        local m = {
            m[1],
            m[2],
            m[3]
        };
        y = (199)[1];
        v1 = next;
        for c, v2 in v1, getgc(v1) do
            E = c;
            v7 = next;
            if typeof(v2) == "table" and rawget(v2, "Ammo") then
                if z[m[3]].InfiniteMag then
                    rawset(v2, "AmmoInGun", math.huge);
                end;
                if z[m[3]].InfiniteReserve then
                    rawset(v2, "MaxStoredAmmo", math.huge);
                end;
                if z[m[3]].RapidFire then
                    rawset(v2, "ShootRate", math.huge);
                end;
                if z[m[3]].NoSpread then
                    rawset(v2, "MinSpread", 0);
                    rawset(v2, "MaxSpread", 0);
                end;
                if z[m[3]].FullAuto then
                    rawset(v2, "ShootType", 3);
                end;
                rawset(v2, "Bullets", z[m[3]].BulletCount);
                if z[m[3]].InstantADS then
                    rawset(v2, "ADS_Speed", 0);
                end;
                if z[m[3]].NoBulletDrop then
                    rawset(v2, "BulletDrop", 0);
                end;
                if z[m[3]].BulletVelocity then
                    rawset(v2, "MuzzleVelocity", 9e+99);
                end;
                if z[m[3]].NoRecoilEnabled then
                    v3 = 1 - z[m[3]].RecoilReductionV / 100;
                    v6 = 1 - z[m[3]].RecoilReductionH / 100;
                    Q = "camRecoil";
                    v5 = Q[1];
                    I = Q[2];
                    for K, Q in ipairs({
                        Q,
                        "gunRecoil",
                        "CamRecoil",
                        "GunRecoil"
                    }) do
                        q = K;
                        v9 = rawget(v2, Q);
                        if v9 then
                            M = typeof(v9) == "table";
                        end;
                        v7 = v3;
                        if v9 then
                            rawset(v2, Q, {
                                0,
                                0,
                                0,
                                0
                            });
                        end; 
                    end;
                    Q = "VerticalRecoil";
                    v5 = Q[1];
                    I = Q[2];
                    for K, Q in ipairs({
                        Q,
                        "verticalRecoil",
                        "RecoilUp",
                        "recoilUp",
                        "KickUp",
                        "kickUp",
                        "CameraKickUp",
                        "cameraKickUp",
                        "RecoilY",
                        "recoilY"
                    }) do
                        q = K;
                        if rawget(v2, Q) then
                            v9 = rawget(v2, Q);
                            if typeof(v9) == "number" then
                                rawset(v2, Q, v9 * (1 - z[m[3]].RecoilReductionV / 100));
                            end;
                        end; 
                    end;
                    Q = "HorizontalRecoil";
                    I = Q[2];
                    v5 = Q[1];
                    for K, Q in ipairs({
                        Q,
                        "horizontalRecoil",
                        "RecoilSide",
                        "recoilSide",
                        "KickSide",
                        "kickSide",
                        "CameraKickSide",
                        "cameraKickSide",
                        "RecoilX",
                        "recoilX"
                    }) do
                        q = "\x00\x84PB\x96\x8f\xc3`\xef\x00\xfa\x12";
                        if rawget(v2, nil) then
                            v9 = rawget(r30, nil);
                            if typeof(v9) == "number" then
                                rawset(r30, nil, v9 * (1 - r16.RecoilReductionH / 100));
                            end;
                        end; 
                    end;
                    Q = "RecoilMultiplier";
                    K = Q[3];
                    for K, Q in Q[1], ipairs({
                        Q,
                        "recoilMultiplier",
                        "Recoil",
                        "recoil",
                        "CameraRecoil",
                        "cameraRecoil",
                        "AimKick",
                        "aimKick"
                    }) do
                        q = K;
                        if rawget(v2, Q) then
                            if typeof(rawget(v2, Q)) == "number" then
                                rawset(v2, Q, 0);
                            end;
                        end; 
                    end;
                end;
                rawset(v2, "WalkMult", 1);
            end; 
        end; 
    end); 
end;
task.spawn(function(...)
    while task.wait(0.5) do
        y = r30.InfiniteReserve or (r30.InfiniteMag or (r30.RapidFire or (r30.NoSpread or (r30.FullAuto or (r30.InstantADS or (r30.NoBulletDrop or (r30.BulletVelocity or r30.NoRecoilEnabled)))))));
        if y then
            r154();
        end; 
    end; 
end);
local v82 = r26.InputBegan;
v82.Connect(v82, function(arg1_146, arg2_146, ...)
    v1 = not arg2_146;
    y = arg1_146;
    if v1 then
        v7 = v7;
        M = y.KeyCode == Enum.KeyCode.One or y.KeyCode == Enum.KeyCode.Two;
    end;
    if v1 then
        v1 = r30.InfiniteReserve or (r30.InfiniteMag or (r30.RapidFire or (r30.NoSpread or (r30.FullAuto or (r30.InstantADS or (r30.NoBulletDrop or (r30.BulletVelocity or (r30.NoRecoilEnabled or r30.BulletCount ~= 1))))))));
        if v1 then
            task.delay(.05, r154);
            task.delay(.15, r154);
        end;
    end; 
end);
local r155 = false;
local r156 = false;
local r157 = false;
local v83 = r26.InputBegan;
v83.Connect(v83, function(arg1_147, arg2_147, ...)
    if arg2_147 then
        return;
    end;
    v1 = arg1_147.KeyCode.Name;
    if r30.SpeedEnabled then
        if r30.SpeedMode == "Toggle" and v1 == r30.SpeedBind then
            r155 = not r155;
        else
            v7 = M[E];
            if r30.SpeedMode == "Hold" and y.KeyCode.Name == r30.SpeedBind then
                r155 = true;
            end;
        end;
    end;
    if r30.FlightEnabled then
        v7 = M.SpeedEnabled;
        if r30.FlightMode == "Toggle" and v1 == r30.FlightBind then
            r156 = not r156;
            v2 = not r156 and "Character";
            v7 = v2;
            if v2 then
                v2 = ("Character").HumanoidRootPart;
                v3 = v2.FindFirstChild(v2, "SwagFlight");
                if v3 then
                    v3.Destroy(v3);
                end;
            end;
        else
            v7 = v2;
            if r30.FlightMode == "Hold" and y.KeyCode.Name == r30.FlightBind then
                r156 = true;
            end;
        end;
    end;
    if r30.NoclipEnabled then
        v7 = M.SpeedEnabled;
        if r30.NoclipMode == "Toggle" and v1 == r30.NoclipBind then
            r157 = not r157;
        else
            v7 = v6;
            if r30.NoclipMode == "Hold" and y.KeyCode.Name == r30.NoclipBind then
                r157 = true;
            end;
        end;
    end; 
end);
local v84 = r26.InputEnded;
v84.Connect(v84, function(arg1_148, arg2_148, ...)
    if arg2_148 then
        return;
    end;
    v7 = arg1_148.KeyCode.Name;
    if r30.SpeedEnabled and (r30.SpeedMode == "Hold" and v7 == r30.SpeedBind) then
        r155 = false;
    end;
    E = v7;
    if r30.FlightEnabled and (r30.FlightMode == "Hold" and v7 == r30.FlightBind) then
        r156 = false;
        v3 = "Character";
        E = v3;
        if v3 then
            v3 = "Character";
            E = v3.FindFirstChild(v3, "HumanoidRootPart");
        end;
        v7 = E;
        if E then
            E = ("Character").HumanoidRootPart;
            v2 = E.FindFirstChild(E, "SwagFlight");
            if v2 then
                v2.Destroy(v2);
            end;
        end;
    end;
    v7 = E;
    if r30.NoclipEnabled and (r30.NoclipMode == "Hold" and v7 == r30.NoclipBind) then
        r157 = false;
    end; 
end);
local v85 = r26.JumpRequest;
v85.Connect(v85, function(...)
    if r30.InfJumpEnabled and "Character" then
        v7 = "Character";
        y = v7.FindFirstChildOfClass(v7, "Humanoid");
        if y then
            y.SetStateEnabled(y, Enum.HumanoidStateType.Jumping, true);
            y.ChangeState(y, Enum.HumanoidStateType.Jumping);
        end;
    end; 
end);
local v86 = r25.Stepped;
v86.Connect(v86, function(...)
    if r30.NoclipEnabled and r30.NoclipMode == "Always" then
        v1 = r16;
        if "Character" then
            v1 = "Character";
            c = v1[3];
            v1 = v1[1];
            for c, v2 in v1, ipairs(v1.GetDescendants(v1)) do
                E = c;
                if v2.IsA(v2, "BasePart") and v2.CanCollide then
                    v2.CanCollide = false;
                end; 
            end;
        end;
    end; 
end);
local v87 = r25.RenderStepped;
v87.Connect(v87, function(...)
    y = "Character";
    if not y then
        return;
    end;
    c = y.FindFirstChildOfClass(y, "Humanoid");
    E = r16;
    v2 = 10172366492288;
    v1 = y.FindFirstChild(y, "HumanoidRootPart");
    if c then
        v2 = r30;
        v5 = r16;
        I = 5289811757471;
        E = v2.SpeedEnabled;
        if E then
            repeat

            until v5(I, "\x00\x84PB\x96\x8f\xc3`\xef\x00\xfa\x12");
            q = "\x00\x84PB\x96\x8f\xc3`\xef\x00\xfa\x12";
            if rawget(v2, nil) then
                v9 = rawget(r30, nil);
                if typeof(v9) == "number" then
                    rawset(r30, nil, v9 * (1 - r16.RecoilReductionH / 100));
                end;
            end;
        end;
        if E then
            c.WalkSpeed = r30.SpeedValue;
        else
            if y.FindFirstChildOfClass(y, "Humanoid").WalkSpeed == r30.SpeedValue and r30.SpeedValue ~= 16 then
                c.WalkSpeed = 16;
            end;
        end;
    end;
    if v1 then
        M = y.FindFirstChildOfClass(y, "Humanoid");
    end;
    if v1 then
        v6 = r15;
        v5 = r16;
        if r30.FlightEnabled and r30.FlightMode == "Always" then
            v2 = r16;
            E = v1.FindFirstChild(v1, "SwagFlight");
            if not E then
                E = Instance.new("BodyVelocity");
                E.Name = "SwagFlight";
                E.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000);
                v2 = "Parent";
                E.Parent = v2;
            end;
            v2 = y.FindFirstChildOfClass(y, "Humanoid").MoveDirection;
            if v2.Magnitude > 0 then
                v3 = Vector3.new(0, 0, 0) + v2 * r30.FlightValue;
            end;
            v6 = r26;
            if v6.IsKeyDown(v6, Enum.KeyCode.Space) then
                v3 = Vector3.new(0, 0, 0) + Vector3.new(0, r30.FlightValue, 0);
            end;
            v5 = r26;
            if v5.IsKeyDown(v5, Enum.KeyCode.LeftShift) then
                v3 = Vector3.new(0, 0, 0) + Vector3.new(0, -r30.FlightValue, 0);
            end;
            E.Velocity = Vector3.new(0, 0, 0);
        else
            E = v7.FindFirstChild(v7, "SwagFlight");
            if E then
                E.Destroy(E);
            end;
        end;
    end; 
end);
Zh[3] = "Vector2";
Zh[2] = Env[Zh[3]];
Zh[1] = Zh[2].new;
Zh[3] = 0.5;
Zh[4] = 0;
Zh[2] = Zh[1](Zh[3], Zh[4]);
Zh[5] = "Color3";
Zh[4] = Env[Zh[5]];
Zh[3] = Zh[4].fromRGB;
Zh[6] = 10;
Zh[5] = 12;
Zh[7] = 18;
Zh[4] = Zh[3](Zh[5], Zh[6], Zh[7]);
Zh[5] = 0.25;
Zh[7] = 0;
Zh[10] = r30;
Zh[9] = Zh[10].WatermarkVisible;
Zh[11] = r35;
local r32 = r37("Frame", {
    ["Name"] = "Watermark",
    ["Size"] = UDim2[r15[r16("BackgroundColor3", Zh[2])]](0, 440, 0, 28),
    [r15[r16(";\xbd?\xb1\x1c\x8e\xdd\x057\x93\x0bۓ", "BackgroundColor3")]] = Enum[("BackgroundColor3").BackgroundTransparency][r15[Zh[2]]],
    [r15.BackgroundColor3] = BackgroundColor3.BackgroundColor3("BackgroundColor3", Zh[2], "BackgroundTransparency", Zh[4]),
    [("BackgroundColor3").BackgroundTransparency] = Zh[2],
    ["BackgroundColor3"] = Zh[4],
    ["BackgroundTransparency"] = Zh[5],
    ["BorderSizePixel"] = Zh[7],
    ["Visible"] = Zh[9],
    ["Parent"] = Zh[11]
});
r38(r32, 6);
r40(r32, 1.5, .05);
Zh[3] = "UDim";
Zh[2] = Env[Zh[3]];
Zh[1] = Zh[2].new;
Zh[3] = 0;
Zh[4] = 2;
Zh[2] = Zh[1](Zh[3], Zh[4]);
Zh[3] = r32;
r37("UIPadding", {
    ["PaddingLeft"] = UDim[r15[r16("Parent", Zh[2])]](0, 18),
    [r15[r16("\x1f\xe5\xec\xd6\xfd\xefjO\x9a\xdc\xcb\xf5", "Parent")]] = UDim[r15[Zh[2]]](0, 18),
    [r15.Parent] = Parent.Parent("Parent", Zh[2]),
    [("Parent")[Zh[3]]] = Zh[2],
    ["Parent"] = Zh[3]
});
Zh[1] = 1;
Zh[7] = "Color3";
Zh[6] = Env[Zh[7]];
Zh[5] = Zh[6].fromRGB;
Zh[8] = 255;
Zh[7] = 255;
Zh[9] = 255;
Zh[6] = Zh[5](Zh[7], Zh[8], Zh[9]);
Zh[7] = 14;
Zh[13] = "Color3";
Zh[12] = Env[Zh[13]];
Zh[11] = Zh[12].fromRGB;
Zh[14] = 0;
Zh[13] = 0;
Zh[15] = 0;
Zh[12] = Zh[11](Zh[13], Zh[14], Zh[15]);
Zh[13] = .2;
Zh[15] = r32;
Zh[8] = "\x84\xe9Y^\xd6\xd8w";
Zh[9] = 25195476708820;
local r158 = r37("TextLabel", {
    ["Name"] = "WatermarkText",
    ["E\x1d+\xe1"] = UDim2[r15.Text](0, 0, Zh[1], "Text"),
    [r15[Zh[1]]] = Zh[1].Text[Zh[1]],
    [Zh[1]["SwagWare | FPS: 60 | 12:00:00 | 05/07/2026"]] = Zh[1],
    ["Text"] = "SwagWare | FPS: 60 | 12:00:00 | 05/07/2026",
    ["TextColor3"] = Zh[6],
    ["TextSize"] = Zh[7],
    [Zh[8]] = Zh[9],
    ["TextStrokeColor3"] = Zh[12],
    ["TextStrokeTransparency"] = Zh[13],
    ["Parent"] = Zh[15]
});
Zh[4] = "Color3";
Zh[3] = Env[Zh[4]];
Zh[5] = 255;
Zh[2] = Zh[3].fromRGB;
Zh[4] = 255;
Zh[6] = 255;
Zh[3] = {
    Zh[2](Zh[4], Zh[5], Zh[6])
};
Zh[2] = "ColorSequenceKeypoint";
Zh[1] = Env[Zh[2]];
Zh[5] = "Color3";
Zh[4] = Env[Zh[5]];
Zh[2] = .3;
Zh[7] = 255;
Zh[3] = Zh[4].fromRGB;
Zh[5] = 220;
Zh[6] = 180;
Zh[4] = {
    Zh[3](Zh[5], Zh[6], Zh[7])
};
Zh[1] = Zh[1][Zh[2]](Zh[2], e(Zh[4]));
Zh[3] = "ColorSequenceKeypoint";
Zh[2] = Env[Zh[3]];
Zh[6] = "Color3";
Zh[3] = 0.5;
Zh[5] = Env[Zh[6]];
Zh[4] = Zh[5].fromRGB;
Zh[6] = 150;
Zh[8] = 255;
Zh[7] = 60;
Zh[5] = {
    Zh[4](Zh[6], Zh[7], Zh[8])
};
Zh[2] = Zh[2][Zh[3]](Zh[3], e(Zh[5]));
Zh[4] = "ColorSequenceKeypoint";
Zh[3] = Env[Zh[4]];
Zh[4] = .7;
Zh[7] = "Color3";
Zh[6] = Env[Zh[7]];
Zh[9] = 255;
Zh[5] = Zh[6].fromRGB;
Zh[8] = 180;
Zh[7] = 220;
Zh[6] = {
    Zh[5](Zh[7], Zh[8], Zh[9])
};
Zh[3] = Zh[3][Zh[4]](Zh[4], e(Zh[6]));
Zh[5] = "ColorSequenceKeypoint";
Zh[4] = Env[Zh[5]];
Zh[5] = 1;
Zh[8] = "Color3";
Zh[7] = Env[Zh[8]];
Zh[6] = Zh[7].fromRGB;
Zh[8] = 255;
Zh[9] = 255;
Zh[10] = 255;
Zh[7] = {
    Zh[6](Zh[8], Zh[9], Zh[10])
};
Zh[4] = {
    Zh[4][Zh[5]](Zh[5], e(Zh[7]))
};
Zh[2] = "Vector2";
Zh[1] = Env[Zh[2]];
Zh[3] = 0;
Zh[2] = -1;
Zh[1] = Zh[1][Zh[2]](Zh[2], Zh[3]);
Zh[3] = r16;
Zh[4] = 4047872935772;
Zh[2] = r158;
local r159 = r37("UIGradient", {
    ["Color"] = ColorSequence[r15[Zh[1]]]({
        Env[Zh[1]][Zh[1]](Zh[1], e(Zh[3])),
        Zh[1],
        Zh[2],
        Zh[3],
        e(Zh[4])
    }),
    [r15[r16(Zh[1], Zh[2])]] = 0,
    [r15[Zh[2]]] = Zh[1],
    ["Parent"] = Zh[2]
});
task.spawn(function(...)
    y = -1;
    while true do
        y = -1 + task.wait() * .6;
        if y > 1 then
            y = -1;
        end;
        v1 = r159;
        v1.Offset = Vector2.new(y, 0); 
    end; 
end);
task.spawn(function(...)
    r160 = 0;
    r161 = os.clock();
    r162 = 60;
    v7 = r25.RenderStepped;
    v7.Connect(v7, function(...)
        v7 = r160 + 1;
        r160 = v7;
        y = os.clock();
        if y - r161 >= 0.5 then
            r162 = math.floor(r160 / (y - r161));
            r160 = 0;
            r161 = y;
        end;
        v7 = v7;
        if r30.WatermarkVisible and (r30.MenuAllowed and r32) then
            E = r32;
            E.Visible = true;
            if r158 then
                E = r158;
                E.Text = string.format("SwagWare | FPS: %d | %s | %s", r162, os.date("%I:%M:%S %p"), os.date("%d/%m/%Y"));
            end;
        else
            if r32 then
                E = r32;
                E.Visible = false;
            end;
            return;
        end; 
    end); 
end);
local v88 = r25.Stepped;
v88.Connect(v88, function(...)
    if not r30.AntiAimEnabled then
        return;
    end;
    if not r28 or not "Character" then
        return;
    end;
    v7 = "Character";
    y = v7.FindFirstChild(v7, "HumanoidRootPart");
    if not y then
        return;
    end;
    v7 = y.CFrame;
    r163 = v7;
    M = r30;
    v2 = v7;
    M._aaSpinAngle = (r30._aaSpinAngle or 0) + 15;
    if r30._aaSpinAngle > 360 then
        M = r30;
        M._aaSpinAngle = 0;
    end;
    c = 0;
    if r30.AAYawMode == "Spin" then
        c = math.rad(r30._aaSpinAngle);
    else
        if r30.AAYawMode == "Jitter" then
            I = v7;
            v6 = v7;
            v5 = v7;
            c = math.rad((math.random() > 0.5 and 1 or -1) * (r30.AAYawValue or 0));
        else
            if r30.AAYawMode == "Static" then
                v6 = y.CFrame;
                c = math.rad(r30.AAYawValue or 0);
            end;
            v3 = 0;
            if r30.AAPitchMode == "Jitter" then
                K = v7;
                Q = v7;
                q = v7;
                v3 = math.rad((math.random() > 0.5 and 1 or -1) * (r30.AAPitchValue or 0));
            else
                if r30.AAPitchMode == "Static" then
                    K = y.CFrame;
                    v3 = math.rad(r30.AAPitchValue or 0);
                end;
                I = 0;
                if r30.AARollMode == "Spin" then
                    I = math.rad(r30._aaSpinAngle);
                else
                    if r30.AARollMode == "Jitter" then
                        S = v7;
                        C = v7;
                        N = v7;
                        I = math.rad((math.random() > 0.5 and 1 or -1) * (r30.AARollValue or 0));
                    else
                        if r30.AARollMode == "Static" then
                            S = y.CFrame;
                            I = math.rad(r30.AARollValue or 0);
                        end;
                        y.CFrame = r163 * CFrame.Angles(0, 0, 0);
                        return;
                    end;
                end;
            end;
        end;
    end; 
end);
local v89 = r25.RenderStepped;
v89.Connect(v89, function(...)
    if r163 and r30.AntiAimEnabled then
        if r28 and "Character" then
            v7 = "Character";
            y = v7.FindFirstChild(v7, "HumanoidRootPart");
            if y then
                y.CFrame = r163;
            end;
        end;
    end; 
end);
pcall(function(...)
    local function y(arg1_149, ...)
        E = game;
        v2 = E.GetService(E, "ReplicatedStorage");
        E = {
            v2.GetDescendants(v2)
        };
        c = v2[2];
        E = v2[1];
        for v1, v3 in ipairs(e(E)) do
            v2 = v1;
            if v3.IsA(v3, "ModuleScript") and v3.Name == arg1_149 then
                return v3;
            end; 
        end; 
    end;
    c = y("CameraShake") or y("CameraShaker");
    if not c then
        return;
    end;
    v1 = require(c);
    if v1.ShakeOnce then
        r164 = v1.ShakeOnce;
        v1.ShakeOnce = function(arg1_150, arg2_150, arg3_150, arg4_150, arg5_150, ...)
            v7 = r30.NoViewBob;
            if v7 then
                c = 0;
                v1 = 0;
            else
                if r30.NoRecoilEnabled then
                    Q = M[v6];
                    I = (1 - r30.RecoilReductionV / 100 + 1 - r30.RecoilReductionH / 100) / 2;
                    c = (arg2_150 or 0) * I;
                    v9 = v7;
                    v1 = (arg3_150 or 0) * I;
                end;
                return r164(arg1_150, arg2_150, arg3_150, arg4_150, arg5_150, select(0, ...));
            end; 
        end;
    end;
    if v1.ShakeSustain then
        r165 = v1.ShakeSustain;
        v1.ShakeSustain = function(arg1_151, arg2_151, ...)
            c = arg2_151;
            if c then
                M = typeof(c) == "table";
            end;
            if c then
                if r30.NoViewBob then
                    if c.Magnitude then
                        c.Magnitude = 0;
                    end;
                    if c.Roughness then
                        c.Roughness = 0;
                    end;
                else
                    if r30.NoRecoilEnabled then
                        E = 1 - (r30.RecoilReductionV + r30.RecoilReductionH) / 200;
                        if c.Magnitude then
                            c.Magnitude = c.Magnitude * E;
                        end;
                        if c.Roughness then
                            c.Roughness = c.Roughness * E;
                        end;
                    end;
                end;
            end;
            return r165(arg1_151, c, select(0, ...)); 
        end;
    end;
    if v1.StartShake then
        r166 = v1.StartShake;
        v1.StartShake = function(arg1_152, arg2_152, ...)
            c = arg2_152;
            if c then
                M = typeof(c) == "table";
            end;
            if c then
                if r30.NoViewBob then
                    if c.Magnitude then
                        c.Magnitude = 0;
                    end;
                    if c.Roughness then
                        c.Roughness = 0;
                    end;
                else
                    if r30.NoRecoilEnabled then
                        E = 1 - (r30.RecoilReductionV + r30.RecoilReductionH) / 200;
                        if c.Magnitude then
                            c.Magnitude = c.Magnitude * E;
                        end;
                        if c.Roughness then
                            c.Roughness = c.Roughness * E;
                        end;
                    end;
                end;
            end;
            return r166(arg1_152, c, select(0, ...)); 
        end;
    end;
    if v1.Shake then
        r167 = v1.Shake;
        v1.Shake = function(arg1_153, arg2_153, ...)
            c = arg2_153;
            if c then
                M = typeof(c) == "table";
            end;
            if c then
                if r30.NoViewBob then
                    if c.Magnitude then
                        c.Magnitude = 0;
                    end;
                    if c.Roughness then
                        c.Roughness = 0;
                    end;
                else
                    if r30.NoRecoilEnabled then
                        E = 1 - (r30.RecoilReductionV + r30.RecoilReductionH) / 200;
                        if c.Magnitude then
                            c.Magnitude = c.Magnitude * E;
                        end;
                        if c.Roughness then
                            c.Roughness = c.Roughness * E;
                        end;
                    end;
                end;
            end;
            return r167(arg1_153, c, select(0, ...)); 
        end;
    end; 
end);
pcall(function(...)
    c = (function(arg1_154, ...)
        E = game;
        v2 = E.GetService(E, "ReplicatedStorage");
        E = {
            v2.GetDescendants(v2)
        };
        v1 = v2[3];
        E = v2[1];
        for v1, v3 in E, ipairs(e(E)) do
            v2 = v1;
            if v3.IsA(v3, "ModuleScript") and v3.Name == arg1_154 then
                return v3;
            end; 
        end; 
    end)("CameraShakeInstance");
    if not c then
        return;
    end;
    v1 = require(c);
    if v1.new then
        r168 = v1.new;
        v1.new = function(arg1_155, arg2_155, arg3_155, arg4_155, ...)
            v7 = r30.NoRecoilEnabled;
            if v7 then
                v7 = 1 - (r30.RecoilReductionV + r30.RecoilReductionH) / 200;
                v6 = (arg1_155 or 0) * v7;
                v7 = (arg1_155 or 0) * v7;
                y = v7;
                I = v7;
                c = (arg2_155 or 0) * v7;
            end;
            return r168(arg1_155, arg2_155, arg3_155, arg4_155, select(0, ...)); 
        end;
    end; 
end);
pcall(function(...)
    y = game;
    c = y.GetService(y, "ReplicatedStorage");
    y = c.FindFirstChild(c, "GameEvents");
    y = y and y.FindFirstChild(y, "CameraShake");
    if y then
        v7 = y.OnClientEvent;
        v7.Connect(v7, function(...)
            if r30.NoRecoilEnabled then
                return;
            end; 
        end);
    end; 
end);
task.spawn(function(...)
    while task.wait(.3) do
        if r30.NoRecoilEnabled then
            pcall(function(...)
                if not getgc then
                    return;
                end;
                v7 = next;
                c = v1(v2, v3)[2];
                for c, v2 in getgc(v7) do
                    v7 = next;
                    if typeof(v2) == "table" and (rawget(v2, "Magnitude") and rawget(v2, "Roughness")) then
                        v3 = 1 - (r30.RecoilReductionV + r30.RecoilReductionH) / 200;
                        q = v3;
                        rawset(v2, "Magnitude", (rawget(v2, "Magnitude") or 0) * v3);
                        q = v7;
                        rawset(v2, "Roughness", (rawget(v2, "Roughness") or 0) * v3);
                    end; 
                end; 
            end);
        end; 
    end; 
end);
pcall(function(...)
    if not getgc then
        return;
    end;
    v1 = true;
    v1 = next;
    c = (199)[2];
    for c, v2 in getgc(v1) do
        E = c;
        r169 = v2;
        if typeof(r169) == "table" then
            v7 = next;
            if rawget(r169, "_shakeInstances") or rawget(r169, "_camShakeInstances") then
                task.spawn(function(...)
                    while task.wait(.1) do
                        if r30.NoRecoilEnabled then
                            pcall(function(...)
                                y = rawget(r169, "_shakeInstances") or rawget(r169, "_camShakeInstances");
                                if y then
                                    M = typeof(y) == "table";
                                end;
                                if y then
                                    c = E[2];
                                    v1 = E[3];
                                    E = "pairs";
                                    for v1, v3 in pairs(y) do
                                        v2 = v1;
                                        if typeof(v3) == "table" then
                                            if rawget(v3, "Magnitude") then
                                                rawset(v3, "Magnitude", 0);
                                            end;
                                            if rawget(v3, "Roughness") then
                                                rawset(v3, "Roughness", 0);
                                            end;
                                        end; 
                                    end;
                                end; 
                            end);
                        end; 
                    end; 
                end);
            end;
        end; 
    end; 
end);
local r170 = false;
local r171 = {};
local v90 = r26.InputBegan;
v90.Connect(v90, function(arg1_156, ...)
    if arg1_156.UserInputType == Enum.UserInputType.MouseButton1 then
        r170 = true;
        pcall(function(...)
            v7 = r27;
            y = v7.FindFirstChild(v7, "CameraModel");
            if not y then
                return;
            end;
            v3 = y.GetChildren;
            r171 = {};
            E = v3[3];
            for E, v3 in v3[1], ipairs(v3(y)) do
                v2 = E;
                if v3.IsA(v3, "Model") and v3.Name ~= "CameraModel" then
                    q = v3.GetDescendants;
                    I = q[3];
                    v5 = q[2];
                    for I, q in ipairs(q(v3)) do
                        K = I;
                        if q.IsA(q, "BasePart") then
                            M = r171;
                            M[q] = q.CFrame;
                        end; 
                    end;
                end; 
            end; 
        end);
    end; 
end);
local v91 = r26.InputEnded;
v91.Connect(v91, function(arg1_157, ...)
    if arg1_157.UserInputType == Enum.UserInputType.MouseButton1 then
        r170 = false;
        r171 = {};
    end; 
end);
local v92 = r25.RenderStepped;
v92.Connect(v92, function(...)
    E = r16;
    if not r30.NoVisualRecoil then
        return;
    end;
    if not r170 then
        return;
    end;
    pcall(function(...)
        v1 = r171;
        c = E[3];
        y = E[2];
        for c, v2 in pairs(M) do
            if c then
                v3 = c.Parent;
            end;
            if c then
                E.CFrame = v2;
            end; 
        end; 
    end); 
end);
local r172 = {};
Zh[2] = r15;
Zh[3] = r16;
local r173 = {
    r15[r16("\x12\xe6\x05\x0f%\x97N", "Right Arm")],
    r15[r16("Right Arm", Zh[2])],
    r15["Right Arm"],
    r15[Zh[2]],
    ("Right Arm")[Zh[3]],
    "Right Arm"
};
local function r174(arg1_158, arg2_158, arg3_158, arg4_158, ...)
    E = arg4_158;
    c = arg2_158;
    y = arg1_158;
    M = c;
    y.FillColor = M;
    y.OutlineColor = c;
    y.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    if arg3_158 then
        y.FillTransparency = 0.5;
        y.OutlineTransparency = 1;
    else
        y.FillTransparency = 1;
        y.OutlineTransparency = 0;
    end; 
end;
local function r175(arg1_159, arg2_159, arg3_159, ...)
    c = arg2_159;
    y = arg1_159;
    v1 = arg3_159;
    E = Enum.Material.SmoothPlastic;
    v2 = 0;
    v3 = 0;
    if c == "Animated" then
        E = Enum.Material.ForceField;
        v2 = 0;
        v3 = 0;
    else
        if c == "Wireframe" then
            E = Enum.Material.Neon;
            v2 = .8;
            v3 = 0;
        else
            if arg2_159 == "Glass" then
                E = Enum.Material.Glass;
                v3 = 0.5;
                v2 = 0.5;
            else
                if arg2_159 == "Material" then
                    E = Enum.Material.Neon;
                    v2 = 0;
                    v3 = 0;
                end;
                R = y.GetDescendants;
                T = {
                    R(y)
                };
                l = R[3];
                for l, T in R[1], ipairs(e(T)) do
                    B = l;
                    r176 = T;
                    R = r176;
                    v14 = R.IsA(R, "BasePart");
                    if v14 then
                        v14 = r176;
                        R = not v14.GetAttribute(v14, "OrigMaterial");
                        if R then
                            R = r176;
                            R.SetAttribute(R, "OrigMaterial", r176.Material.Name);
                            R = r176;
                            R.SetAttribute(R, "OrigTrans", r176.Transparency);
                            R = r176;
                            R.SetAttribute(R, "OrigReflect", r176.Reflectance);
                            R = r176;
                            R.SetAttribute(R, "OrigColor", r176.Color);
                        end;
                        R = r176;
                        v14 = R.GetAttribute(R, "OrigTrans");
                        if v14 then
                            R = v14 >= 1;
                        end;
                        v7 = c == M;
                        if v14 then
                        else
                            if arg2_159 == "Normal" then
                                R = r176;
                                o = 4430643300367;
                                r177 = R.GetAttribute(R, "OrigMaterial");
                                if r177 then
                                    pcall(function(...)
                                        v7 = r176;
                                        v7.Material = Enum.Material[r177]; 
                                    end);
                                    v15 = r176;
                                    b6 = v15;
                                    v15.Transparency = R.GetAttribute(R, t[b6]) or 0;
                                    v15 = r176;
                                    b6 = v15;
                                    o = r176;
                                    v15.Reflectance = o.GetAttribute(o, "OrigReflect") or 0;
                                    v15 = r176;
                                    o = r176;
                                    v7 = v15;
                                    v15.Color = o.GetAttribute(o, "OrigColor") or Color3.new(1, 1, 1);
                                end;
                            else
                                R = r176;
                                t = Enum.Material.SmoothPlastic;
                                R.Material = t;
                                R = r176;
                                t = 0;
                                R.Transparency = t;
                                R = r176;
                                t = 0;
                                R.Reflectance = t;
                                R = r176;
                                R.Color = arg3_159;
                            end;
                        end;
                    end; 
                end;
                return;
            end;
        end;
    end; 
end;
local function r178(arg1_160, ...)
    y = arg1_160;
    v3 = y.GetChildren;
    v2 = {
        v3(y)
    };
    E = v3[3];
    v2 = v3[1];
    for E, v6 in v2, ipairs(e(v2)) do
        v3 = E;
        if v6.IsA(v6, "Model") and "Name" ~= "CameraModel" then
            v7 = ipairs;
            v9 = v6.GetDescendants;
            q = v9[3];
            K = v9[2];
            for q, v9 in v7(v9(v6)) do
                Q = q;
                if v9.IsA(v9, "BasePart") then
                    v5 = true;
                end; 
            end;
            if false then
                I = "Name" ~= "Left Arm" and ("Name" ~= "Right Arm" and ("Name" ~= "LeftArm" and "Name" ~= "RightArm"));
                v7 = ipairs;
            end;
            v7 = v7;
            if false then
                table.insert({}, v6);
            end;
        end; 
    end;
    return {}; 
end;
Zh[1] = function(...)
    r179 = {};
    while task.wait(.05) do
        pcall(function(...)
            b = r27;
            y = b.FindFirstChild(b, "CameraModel");
            if not y then
                return;
            end;
            x = r178(y);
            U = r15;
            E = r30.GunChamsEnabled;
            if E and #x > 0 then
                E = r30.GunRainbowChams;
                M = E and Color3.fromHSV(tick() % 5 / 5, 1, 1);
                b = r178;
                if E then
                    E = E and c;
                    U = r179;
                    f = k[3];
                    U = k[1];
                    for f, I in U, pairs(U) do
                        r180 = I;
                        if not table.find(b(y), f) then
                            if r180 then
                                pcall(function(...)
                                    b = r180;
                                    b.Destroy(b); 
                                end);
                            end;
                            b = r179;
                            b[f] = nil;
                        end; 
                    end;
                    f = k[2];
                    U = k[3];
                    for U, I in ipairs(b(y)) do
                        r181 = r179[I];
                        if not r181 or r181.Parent ~= I then
                            if r181 then
                                pcall(function(...)
                                    b = r181;
                                    b.Destroy(b); 
                                end);
                            end;
                            r181 = Instance.new("Highlight");
                            b = r181;
                            b.Name = "SwagGunChams";
                            b = r181;
                            b.Parent = I;
                            b = r179;
                            b[I] = r181;
                        end;
                        b = r181;
                        b.Enabled = true;
                        r174(r181, E, r30.GunChamsFilled, r30.GunChamsMaterial);
                        r175(I, r30.GunChamsMaterial, E); 
                    end;
                    if r30.ArmChamsEnabled then
                        f = k[3];
                        X = k[2];
                        for f, k in ipairs(r173) do
                            U = f;
                            I = y.FindFirstChild(y, k);
                            if I then
                                r182 = r172[k];
                                if not r182 or r182.Parent ~= I then
                                    if r182 then
                                        pcall(function(...)
                                            b = r182;
                                            b.Destroy(b); 
                                        end);
                                    end;
                                    r182 = Instance.new("Highlight");
                                    b = r182;
                                    b.Name = "SwagArmChams";
                                    b = r182;
                                    b.Parent = b;
                                    b = r172;
                                    b[k] = r182;
                                end;
                                b = r182;
                                b.Enabled = true;
                                S = r30.ArmRainbowChams;
                                V = S and Color3.fromHSV(tick() % 5 / 5, 1, 1);
                                b = b;
                                if S then
                                    r174(r182, V, r30.ArmChamsFilled, r30.ArmChamsMaterial);
                                    S = Instance.new("Model");
                                    I.Parent = S;
                                    r175(S, r30.ArmChamsMaterial, V);
                                    I.Parent = b.FindFirstChild(b, "CameraModel");
                                else
                                    V = r30.ArmChamsColor;
                                end;
                            end; 
                        end;
                    else
                        X = k[2];
                        f = k[3];
                        for f, k in ipairs(r173) do
                            U = f;
                            I = y.FindFirstChild(y, k);
                            if I then
                                K = Instance.new("Model");
                                I.Parent = K;
                                r175(K, "Normal", Color3.new(1, 1, 1));
                                I.Parent = b.FindFirstChild(b, "CameraModel");
                            end; 
                        end;
                        E = k[1];
                        X = k[2];
                        for f, k in pairs(r172) do
                            U = f;
                            if k then
                                k.Enabled = false;
                            end; 
                        end;
                        return;
                    end;
                else
                    M = r30.GunChamsColor;
                end;
            else
                U = r179;
                X = k[2];
                E = k[1];
                for f, k in pairs(U) do
                    U = f;
                    if k then
                        k.Enabled = false;
                    end; 
                end;
                X = U[2];
                E = U[1];
                for f, k in ipairs(x) do
                    U = f;
                    r175(k, "Normal", Color3.new(1, 1, 1)); 
                end;
            end; 
        end); 
    end; 
end;
Env["E\x1d+\xe1"]["E\x1d+\xe1"]("E\x1d+\xe1");
local r183 = {};
local function r184(arg1_161, arg2_161, ...)
    y = arg1_161;
    if not y.IsA(y, "Model") and not y.IsA(y, "BasePart") then
        return false;
    end;
    return string.find(string.lower(y.Name), arg2_161) ~= nil; 
end;
local function r185(arg1_162, arg2_162, arg3_162, arg4_162, ...)
    v1 = arg3_162;
    r186 = arg1_162;
    if arg2_162 then
        r187 = r183[r186];
        if not r187 or r187.highlight.Parent ~= r186 then
            if r187 then
                pcall(function(...)
                    v7 = r187.highlight;
                    v7.Destroy(v7); 
                end);
                pcall(function(...)
                    v7 = r187.billboard;
                    v7.Destroy(v7); 
                end);
            end;
            v3 = Instance.new("Highlight");
            v3.Name = "SwagDeployableESP_HL";
            v3.Parent = r186;
            v6 = Instance.new("BillboardGui");
            v6.Name = "SwagDeployableESP_BB";
            v6.Size = UDim2.new(0, 150, 0, 30);
            v6.StudsOffset = Vector3.new(0, 1.5, 0);
            v6.AlwaysOnTop = true;
            v6.Parent = r186;
            v5.Size = UDim2.new(1, 0, 1, 0);
            v5.BackgroundTransparency = 1;
            v5.TextSize = 14;
            v5.Font = Enum.Font.Code;
            v5.TextStrokeTransparency = 0;
            v5.Parent = v6;
            r187 = {
                ["highlight"] = v3,
                ["billboard"] = v6,
                ["text"] = Instance.new("TextLabel")
            };
            M = r183;
            M[r186] = r187;
        end;
        M = r187.highlight;
        M.Enabled = true;
        M = r187.highlight;
        M.FillTransparency = 1;
        M = r187.highlight;
        M.OutlineTransparency = 0;
        M = r187.highlight;
        v6 = v1;
        M.OutlineColor = v6;
        M = r187.highlight;
        M.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
        M = r187.billboard;
        M.Enabled = true;
        M = r187.text;
        v6 = arg4_162;
        M.Text = v6;
        M = r187.text;
        M.TextColor3 = v1;
    else
        if r183[r186] then
            pcall(function(...)
                v7 = r183[r186].highlight;
                v7.Destroy(v7); 
            end);
            pcall(function(...)
                v7 = r183[r186].billboard;
                v7.Destroy(v7); 
            end);
            M = z[yh];
            M[r186] = nil;
        end;
        return;
    end; 
end;
task.spawn(function(...)
    while task.wait(1) do
        pcall(function(...)
            v1 = r183;
            y = E[2];
            v1 = "E\x1d+\xe1";
            for c, v2 in pairs(v1) do
                r188 = v2;
                if not c or not c.Parent then
                    pcall(function(...)
                        v7 = z[v7].highlight;
                        v7.Destroy(v7); 
                    end);
                    pcall(function(...)
                        v7 = z[v7].billboard;
                        v7.Destroy(v7); 
                    end);
                    v7 = r16;
                    v7[c] = nil;
                end; 
            end;
            E = workspace;
            v2 = {
                E.GetDescendants(E)
            };
            y = E[1];
            c = E[2];
            for v1, v2 in ipairs(e(v2)) do
                E = v1;
                if r184(v2, "barb%s*wire") then
                    r185(v2, r30.BarbWireESP, Color3.fromRGB(255, 0, 0), "Barb Wire");
                else
                    if r184(v2, "fort%s*shield") then
                        r185(v2, r30.FortShieldESP, Color3.fromRGB(0, 100, 255), "Fort Shield");
                    else
                        if r184(v2, "metal%s*shield") then
                            r185(v2, r30.MetalShieldESP, Color3.fromRGB(150, 150, 150), "Metal Shield");
                        else
                            if r184(v2, "trip%s*wire") then
                                r185(v2, r30.TripWireESP, Color3.fromRGB(255, 100, 0), "Trip Wire");
                            end;
                        end;
                    end;
                end; 
            end; 
        end); 
    end; 
end);
local r189 = Drawing.new("Line");
local v93 = r189;
v93.Thickness = 1;
local v94 = r189;
v94.Visible = false;
local v95 = r189;
v95.Color = Color3.fromRGB(255, 255, 255);
local v96 = r189;
local v97 = r26;
v96.From = v97.GetMouseLocation(v97);
GetClosestSilentTarget = function(...)
    c = math.huge;
    M = r24;
    E = M.GetPlayers[2];
    for E, U in next(M) do
        f = E;
        if U == r24.LocalPlayer then
        end;
        B = b;
        N = b;
        b = B;
        b = N;
        k = r30.RageSilentAim and r30.RageTeamCheck or r30.TeamCheck;
        if k then
            M = "Team" == r24.LocalPlayer.Team;
        end;
        b = b;
        if k then
        else
            B = r24.LocalPlayer.Character;
            b = b;
            if not B or not B.FindFirstChild(B, "Head") then
            else
                C = r15;
                I = "Character";
                if not I then
                else
                    K = I.FindFirstChildOfClass(I, "Humanoid");
                    C = not K;
                    N = N;
                    if C then
                        b = N;
                        if C then
                        else
                            N = N;
                            G = N;
                            b = N;
                            b = N;
                            q = I.FindFirstChild(I, r30.SilentAimBone or "Head") or I.FindFirstChild(I, "Head");
                            if not q then
                            else
                                M = workspace.CurrentCamera;
                                G = {
                                    M.WorldToViewportPoint(M, q.Position)
                                };
                                Q = M.WorldToViewportPoint(M, q.Position);
                                if not G[2] then
                                else
                                    N = b;
                                    B = r26;
                                    if (Vector2.new("X", "Y") - B.GetMouseLocation(B)).Magnitude > (r30.SilentAimFOV or 200) then
                                    else
                                        if r30.VisCheckEnabled then
                                            N = workspace.CurrentCamera;
                                            if #N.GetPartsObscuringTarget(N, {
                                                workspace.CurrentCamera.CFrame.Position,
                                                (C or I.FindFirstChild(I, "Head")).Position
                                            }, {
                                                r24.LocalPlayer.Character,
                                                U[N]
                                            }) > 0 then
                                            end;
                                        end;
                                        A = r24.LocalPlayer.Character;
                                        if (q.Position - A.FindFirstChild(A, "Head").Position).Magnitude < math[x[r16(f, 21379440322275)]] then
                                            y = q;
                                            A = r24.LocalPlayer.Character;
                                            c = (q.Position - A.FindFirstChild(A, "Head").Position).Magnitude;
                                        end;
                                    end;
                                end;
                            end;
                        end;
                    else
                        M = K.Health <= 0;
                    end;
                end;
            end;
        end; 
    end;
    return nil; 
end;
pcall(function(...)
    v1 = true;
    c = (199)[2];
    v1 = next;
    for c, v2 in getgc(v1) do
        v7 = next;
        if typeof(v2) == "function" and (not isexecutorclosure(v2) and not iscclosure(v2)) then
            if debug.getinfo(v2).name == "BulletRayCast" then
                r190 = hookfunction(v2, newcclosure(function(...)
                    if r30.RageSilentAim then
                        v1 = r133("Head", r30.RageFOV);
                        if v1 then
                            c[2] = (v1.Position - select(-1, ...)).Unit;
                        end;
                    else
                        if r30.SilentAimEnabled then
                            v1 = GetClosestSilentTarget();
                            if v1 then
                                c[2] = (v1.Position - select(-1, ...)).Unit;
                            end;
                        end;
                        return r190(table.unpack(c));
                    end; 
                end));
            end;
        end; 
    end; 
end);
local v98 = r25.Heartbeat;
v98.Connect(v98, function(...)
    if r30.SilentAimEnabled then
        v7 = r189;
        E = "\x84\x14\xbc\x01";
        y = r26;
        v7[r15[r16(E, 27254893851027)]] = y.GetMouseLocation(y);
        v7 = GetClosestSilentTarget;
        y = v7();
        if y then
            v7 = workspace.CurrentCamera;
            E = {
                v7.WorldToViewportPoint(v7, y.Position)
            };
            v1 = v7.WorldToViewportPoint(v7, y.Position);
            if E[2] then
                v7 = r189;
                v7.Visible = true;
                v7 = r189;
                v7.To = Vector2.new(v1.v2, v1.Y);
            else
                v7 = r189;
                v7.Visible = false;
            end;
        else
            v7 = r189;
            v7.Visible = false;
        end;
    else
        v7 = r189;
        v7.Visible = false;
    end; 
end);
local v99 = r43;
v99.Visible = false;
if r32 then
    v99 = r32;
    v99.Visible = false;
end;
Zh[3] = "UDim2";
Zh[2] = Env[Zh[3]];
Zh[4] = 420;
Zh[1] = Zh[2].new;
Zh[5] = 0;
Zh[6] = 220;
Zh[3] = 0;
Zh[2] = Zh[1](Zh[3], Zh[4], Zh[5], Zh[6]);
Zh[5] = "UDim2";
Zh[4] = Env[Zh[5]];
Zh[8] = -110;
Zh[3] = Zh[4].new;
Zh[6] = -210;
Zh[5] = 0.5;
Zh[7] = 0.5;
Zh[4] = Zh[3](Zh[5], Zh[6], Zh[7], Zh[8]);
Zh[6] = r34;
Zh[5] = Zh[6].Background;
Zh[7] = 0;
Zh[9] = 0;
Zh[11] = r35;
Zh[8] = 7670292549107;
Zh[6] = "\x87kP\xf2\x85\x1aX";
Zh[2] = 21647181408096;
local r191 = r37(r15[r16("\x97m\xe7@\x00", "Position")], {
    [r15.Position] = r15[Zh[2]],
    [("Position").BackgroundColor3] = Zh[2],
    ["Position"] = Zh[4],
    ["BackgroundColor3"] = Zh[5],
    [Zh[6]] = Zh[7],
    [Zh[8]] = Zh[9],
    ["Parent"] = Zh[11]
});
r38(r191, 10);
Zh[2] = "Color3";
Zh[1] = Env[Zh[2]];
Zh[4] = 255;
Zh[3] = 255;
Zh[2] = 255;
Zh[1] = Zh[1][Zh[2]](Zh[2], Zh[3], Zh[4]);
Zh[3] = "ColorSequence";
Zh[2] = Env[Zh[3]];
Zh[3] = "new";
Zh[1] = Zh[2].new;
Zh[6] = "ColorSequenceKeypoint";
Zh[5] = Env[Zh[6]];
Zh[9] = "Color3";
Zh[4] = Zh[5].new;
Zh[6] = 0;
Zh[8] = Env[Zh[9]];
Zh[11] = 255;
Zh[7] = Zh[8].fromRGB;
Zh[9] = 230;
Zh[10] = 180;
Zh[8] = {
    Zh[7](Zh[9], Zh[10], Zh[11])
};
Zh[7] = "ColorSequenceKeypoint";
Zh[5] = Zh[4](Zh[6], e(Zh[8]));
Zh[6] = Env[Zh[7]];
Zh[4] = Zh[6].new;
Zh[7] = .35;
Zh[10] = "Color3";
Zh[9] = Env[Zh[10]];
Zh[11] = 50;
Zh[12] = 230;
Zh[8] = Zh[9].fromRGB;
Zh[10] = 140;
Zh[9] = {
    Zh[8](Zh[10], Zh[11], Zh[12])
};
Zh[6] = Zh[4](Zh[7], e(Zh[9]));
Zh[8] = "ColorSequenceKeypoint";
Zh[7] = Env[Zh[8]];
Zh[4] = Zh[7].new;
Zh[8] = .7;
Zh[11] = "Color3";
Zh[10] = Env[Zh[11]];
Zh[12] = 140;
Zh[13] = 255;
Zh[9] = Zh[10].fromRGB;
Zh[11] = 200;
Zh[10] = {
    Zh[9](Zh[11], Zh[12], Zh[13])
};
Zh[9] = "ColorSequenceKeypoint";
Zh[7] = Zh[4](Zh[8], e(Zh[10]));
Zh[8] = Env[Zh[9]];
Zh[4] = Zh[8].new;
Zh[9] = 1;
Zh[12] = "Color3";
Zh[11] = Env[Zh[12]];
Zh[14] = 255;
Zh[10] = Zh[11].fromRGB;
Zh[13] = 180;
Zh[12] = 230;
Zh[11] = {
    Zh[10](Zh[12], Zh[13], Zh[14])
};
Zh[8] = {
    Zh[4](Zh[9], e(Zh[11]))
};
Zh[3] = {
    Zh[5],
    Zh[6],
    Zh[7],
    e(Zh[8])
};
Zh[2] = Zh[1](Zh[3]);
Zh[3] = 0;
Zh[5] = r15;
Zh[6] = r16;
local r192 = r37(r15.Rotation, {
    [("Rotation")[Zh[3]]] = Zh[2],
    ["Rotation"] = Zh[3],
    ["Parent"] = r37(r15[r16("Rotation", Zh[2])], {
        [r15[Zh[2]]] = "Rotation",
        [Zh[2].Parent] = Zh[2],
        [Zh[3]] = "Parent",
        [Zh[5]] = Zh[6]
    })
});
local r193 = true;
task.spawn(function(...)
    while r193 do
        M = r192;
        M.Rotation = (0 + task.wait() * 100) % 360; 
    end; 
end);
Zh[5] = "UDim2";
Zh[4] = Env[Zh[5]];
Zh[7] = 0;
Zh[6] = 0;
Zh[3] = Zh[4].new;
Zh[5] = 1;
Zh[8] = 40;
Zh[4] = Zh[3](Zh[5], Zh[6], Zh[7], Zh[8]);
Zh[7] = "UDim2";
Zh[6] = Env[Zh[7]];
Zh[10] = 25;
Zh[5] = Zh[6].new;
Zh[7] = 0;
Zh[8] = 0;
Zh[9] = 0;
Zh[6] = Zh[5](Zh[7], Zh[8], Zh[9], Zh[10]);
Zh[13] = "Color3";
Zh[12] = Env[Zh[13]];
Zh[11] = Zh[12].fromRGB;
Zh[15] = 255;
Zh[13] = 255;
Zh[14] = 255;
Zh[12] = Zh[11](Zh[13], Zh[14], Zh[15]);
Zh[19] = "Color3";
Zh[18] = Env[Zh[19]];
Zh[21] = 0;
Zh[20] = 0;
Zh[17] = Zh[18].fromRGB;
Zh[19] = 0;
Zh[18] = Zh[17](Zh[19], Zh[20], Zh[21]);
Zh[2] = r15;
Zh[6] = "ColorSequence";
Zh[5] = Env[Zh[6]];
Zh[6] = "new";
Zh[4] = Zh[5].new;
Zh[9] = "ColorSequenceKeypoint";
Zh[8] = Env[Zh[9]];
Zh[12] = "Color3";
Zh[7] = Zh[8].new;
Zh[11] = Env[Zh[12]];
Zh[9] = 0;
Zh[10] = Zh[11].fromRGB;
Zh[13] = 255;
Zh[12] = 255;
Zh[14] = 255;
Zh[11] = {
    Zh[10](Zh[12], Zh[13], Zh[14])
};
Zh[8] = Zh[7](Zh[9], e(Zh[11]));
Zh[10] = "ColorSequenceKeypoint";
Zh[9] = Env[Zh[10]];
Zh[7] = Zh[9].new;
Zh[10] = .3;
Zh[13] = "Color3";
Zh[12] = Env[Zh[13]];
Zh[14] = 180;
Zh[11] = Zh[12].fromRGB;
Zh[13] = 220;
Zh[15] = 255;
Zh[12] = {
    Zh[11](Zh[13], Zh[14], Zh[15])
};
Zh[9] = Zh[7](Zh[10], e(Zh[12]));
Zh[11] = "ColorSequenceKeypoint";
Zh[10] = Env[Zh[11]];
Zh[14] = "Color3";
Zh[7] = Zh[10].new;
Zh[11] = 0.5;
Zh[13] = Env[Zh[14]];
Zh[12] = Zh[13].fromRGB;
Zh[15] = 60;
Zh[16] = 255;
Zh[14] = 150;
Zh[13] = {
    Zh[12](Zh[14], Zh[15], Zh[16])
};
Zh[10] = Zh[7](Zh[11], e(Zh[13]));
Zh[12] = "ColorSequenceKeypoint";
Zh[11] = Env[Zh[12]];
Zh[7] = Zh[11].new;
Zh[12] = .7;
Zh[15] = "Color3";
Zh[14] = Env[Zh[15]];
Zh[17] = 255;
Zh[13] = Zh[14].fromRGB;
Zh[15] = 220;
Zh[16] = 180;
Zh[14] = {
    Zh[13](Zh[15], Zh[16], Zh[17])
};
Zh[13] = "ColorSequenceKeypoint";
Zh[11] = Zh[7](Zh[12], e(Zh[14]));
Zh[12] = Env[Zh[13]];
Zh[16] = "Color3";
Zh[7] = Zh[12].new;
Zh[15] = Env[Zh[16]];
Zh[13] = 1;
Zh[14] = Zh[15].fromRGB;
Zh[16] = 255;
Zh[17] = 255;
Zh[18] = 255;
Zh[15] = {
    Zh[14](Zh[16], Zh[17], Zh[18])
};
Zh[12] = {
    Zh[7](Zh[13], e(Zh[15]))
};
Zh[6] = {
    Zh[8],
    Zh[9],
    Zh[10],
    Zh[11],
    e(Zh[12])
};
Zh[5] = Zh[4](Zh[6]);
Zh[8] = "Vector2";
Zh[7] = Env[Zh[8]];
Zh[6] = Zh[7].new;
Zh[8] = -1;
Zh[9] = 0;
Zh[7] = Zh[6](Zh[8], Zh[9]);
Zh[2] = {
    ["Color"] = Zh[5],
    ["Offset"] = Zh[7],
    ["Parent"] = r37(("UIGradient").Color, "UIGradient")
};
Zh[1] = 84;
local r194 = r37(Zh[1], Zh[2]);
Zh[3] = "task";
z[Zh[1]] = true;
Zh[2] = Env[Zh[3]];
Zh[3] = "spawn";
Zh[3] = function(...)
    y = -1;
    while z["E\x1d+\xe1"] do
        y = -1 + task.wait() * 1.4;
        if y > 1 then
            y = -1;
        end;
        x = r194;
        x.Offset = Vector2.new(y, 0); 
    end; 
end;
Zh[2] = Zh[2][Zh[3]](Zh[3]);
Zh[3] = "TextLabel";
Zh[8] = "UDim2";
Zh[7] = Env[Zh[8]];
Zh[6] = Zh[7].new;
Zh[8] = 1;
Zh[9] = 0;
Zh[10] = 0;
Zh[11] = 22;
Zh[7] = Zh[6](Zh[8], Zh[9], Zh[10], Zh[11]);
Zh[10] = "UDim2";
Zh[9] = Env[Zh[10]];
Zh[8] = Zh[9].new;
Zh[13] = 72;
Zh[11] = 0;
Zh[10] = 0;
Zh[12] = 0;
Zh[9] = Zh[8](Zh[10], Zh[11], Zh[12], Zh[13]);
Zh[10] = 1;
Zh[15] = r34;
Zh[14] = Zh[15].TextDim;
Zh[16] = 14;
Zh[21] = "Enum";
Zh[20] = Env[Zh[21]];
Zh[19] = Zh[20].Font;
Zh[18] = Zh[19].Arcade;
Zh[20] = r191;
Zh[4] = {
    ["Size"] = Zh[7],
    ["Position"] = Zh[9],
    ["BackgroundTransparency"] = Zh[10],
    ["Text"] = "Loading...",
    ["TextColor3"] = Zh[14],
    ["TextSize"] = Zh[16],
    ["Font"] = Zh[18],
    ["Parent"] = Zh[20]
};
Zh[2] = r37("TextLabel", Zh[4]);
local r195 = Zh[2];
Zh[2] = r37;
Zh[4] = "Frame";
Zh[9] = "UDim2";
Zh[8] = Env[Zh[9]];
Zh[11] = 0;
Zh[7] = Zh[8].new;
Zh[9] = 0.75;
Zh[12] = 10;
Zh[10] = 0;
Zh[8] = Zh[7](Zh[9], Zh[10], Zh[11], Zh[12]);
Zh[11] = "UDim2";
Zh[10] = Env[Zh[11]];
Zh[14] = 120;
Zh[13] = 0;
Zh[12] = 0;
Zh[9] = Zh[10].new;
Zh[11] = 0.125;
Zh[10] = Zh[9](Zh[11], Zh[12], Zh[13], Zh[14]);
Zh[12] = r34;
Zh[11] = Zh[12].SliderTrack;
Zh[13] = 0;
Zh[15] = 0;
Zh[17] = r191;
Zh[5] = {
    ["Size"] = Zh[8],
    ["Position"] = Zh[10],
    ["BackgroundColor3"] = Zh[11],
    ["BackgroundTransparency"] = Zh[13],
    ["BorderSizePixel"] = Zh[15],
    ["Parent"] = Zh[17]
};
Zh[6] = .3;
Zh[3] = Zh[2]("Frame", Zh[5]);
Zh[2] = r38;
Zh[5] = 5;
Zh[4] = Zh[2](Zh[3], Zh[5]);
Zh[5] = 1.2;
Zh[2] = r40;
Zh[4] = Zh[2](Zh[3], Zh[5], Zh[6]);
Zh[2] = r37;
Zh[5] = "Frame";
Zh[10] = "UDim2";
Zh[9] = Env[Zh[10]];
Zh[8] = Zh[9].new;
Zh[11] = 0;
Zh[10] = 0;
Zh[13] = 0;
Zh[12] = 1;
Zh[9] = Zh[8](Zh[10], Zh[11], Zh[12], Zh[13]);
Zh[12] = "Color3";
Zh[11] = Env[Zh[12]];
Zh[10] = Zh[11].fromRGB;
Zh[13] = 255;
Zh[14] = 255;
Zh[12] = 255;
Zh[11] = Zh[10](Zh[12], Zh[13], Zh[14]);
Zh[12] = 0;
Zh[14] = 0;
Zh[6] = {
    ["Size"] = Zh[9],
    ["BackgroundColor3"] = Zh[11],
    ["BackgroundTransparency"] = Zh[12],
    ["BorderSizePixel"] = Zh[14],
    ["Parent"] = Zh[3]
};
Zh[4] = Zh[2]("Frame", Zh[6]);
Zh[7] = 5;
Zh[2] = 87;
z[Zh[2]] = Zh[4];
Zh[4] = r38;
Zh[6] = z[Zh[2]];
Zh[5] = Zh[4](Zh[6], Zh[7]);
Zh[4] = r37;
Zh[11] = "ColorSequence";
Zh[10] = Env[Zh[11]];
Zh[11] = "new";
Zh[9] = Zh[10].new;
Zh[14] = "ColorSequenceKeypoint";
Zh[13] = Env[Zh[14]];
Zh[12] = Zh[13].new;
Zh[17] = "Color3";
Zh[14] = 0;
Zh[16] = Env[Zh[17]];
Zh[15] = Zh[16].fromRGB;
Zh[18] = 60;
Zh[19] = 255;
Zh[17] = 150;
Zh[16] = {
    Zh[15](Zh[17], Zh[18], Zh[19])
};
Zh[15] = "ColorSequenceKeypoint";
Zh[13] = Zh[12](Zh[14], e(Zh[16]));
Zh[14] = Env[Zh[15]];
Zh[12] = Zh[14].new;
Zh[18] = "Color3";
Zh[17] = Env[Zh[18]];
Zh[15] = .3;
Zh[16] = Zh[17].fromRGB;
Zh[19] = 140;
Zh[20] = 255;
Zh[18] = 200;
Zh[17] = {
    Zh[16](Zh[18], Zh[19], Zh[20])
};
Zh[14] = Zh[12](Zh[15], e(Zh[17]));
Zh[16] = "ColorSequenceKeypoint";
Zh[15] = Env[Zh[16]];
Zh[12] = Zh[15].new;
Zh[19] = "Color3";
Zh[16] = 0.5;
Zh[18] = Env[Zh[19]];
Zh[17] = Zh[18].fromRGB;
Zh[21] = 255;
Zh[19] = 230;
Zh[20] = 180;
Zh[18] = {
    Zh[17](Zh[19], Zh[20], Zh[21])
};
Zh[15] = Zh[12](Zh[16], e(Zh[18]));
Zh[17] = "ColorSequenceKeypoint";
Zh[16] = Env[Zh[17]];
Zh[20] = "Color3";
Zh[12] = Zh[16].new;
Zh[17] = .7;
Zh[19] = Env[Zh[20]];
Zh[18] = Zh[19].fromRGB;
Zh[21] = 220;
Zh[22] = 255;
Zh[20] = 245;
Zh[19] = {
    Zh[18](Zh[20], Zh[21], Zh[22])
};
Zh[18] = "ColorSequenceKeypoint";
Zh[16] = Zh[12](Zh[17], e(Zh[19]));
Zh[17] = Env[Zh[18]];
Zh[12] = Zh[17].new;
Zh[18] = 1;
Zh[21] = "Color3";
Zh[20] = Env[Zh[21]];
Zh[22] = 255;
Zh[19] = Zh[20].fromRGB;
Zh[21] = 255;
Zh[23] = 255;
Zh[20] = {
    Zh[19](Zh[21], Zh[22], Zh[23])
};
Zh[17] = {
    Zh[12](Zh[18], e(Zh[20]))
};
Zh[11] = {
    Zh[13],
    Zh[14],
    Zh[15],
    Zh[16],
    e(Zh[17])
};
Zh[10] = Zh[9](Zh[11]);
Zh[11] = 0;
Zh[15] = "Vector2";
Zh[14] = Env[Zh[15]];
Zh[13] = Zh[14].new;
Zh[15] = -1;
Zh[16] = 0;
Zh[14] = Zh[13](Zh[15], Zh[16]);
Zh[15] = z[Zh[2]];
Zh[7] = {
    ["Color"] = Zh[10],
    ["Rotation"] = Zh[11],
    ["Offset"] = Zh[14],
    ["Parent"] = Zh[15]
};
Zh[5] = Zh[4]("UIGradient", Zh[7]);
Zh[6] = 88;
Zh[4] = 89;
Zh[8] = "task";
z[Zh[4]] = Zh[5];
Zh[5] = true;
z[Zh[6]] = Zh[5];
Zh[7] = Env[Zh[8]];
Zh[8] = "spawn";
Zh[5] = Zh[7].spawn;
Zh[8] = function(...)
    while z[Zh[6]] do
        M = z[Zh[4]];
        M.Offset = Vector2.new(math.sin((0 + task.wait() * .6) * math.pi), 0); 
    end; 
end;
Zh[7] = Zh[5](Zh[8]);
Zh[5] = r37;
Zh[13] = "UDim2";
Zh[12] = Env[Zh[13]];
Zh[14] = 0;
Zh[15] = 0;
Zh[16] = 22;
Zh[11] = Zh[12].new;
Zh[13] = 1;
Zh[12] = Zh[11](Zh[13], Zh[14], Zh[15], Zh[16]);
Zh[15] = "UDim2";
Zh[14] = Env[Zh[15]];
Zh[13] = Zh[14].new;
Zh[16] = 0;
Zh[17] = 0;
Zh[18] = 140;
Zh[15] = 0;
Zh[14] = Zh[13](Zh[15], Zh[16], Zh[17], Zh[18]);
Zh[15] = 1;
Zh[20] = r34;
Zh[19] = Zh[20].TextAccent;
Zh[21] = 13;
Zh[26] = "Enum";
Zh[25] = Env[Zh[26]];
Zh[24] = Zh[25].Font;
Zh[23] = Zh[24].Arcade;
Zh[25] = r191;
Zh[9] = {
    ["Size"] = Zh[12],
    ["Position"] = Zh[14],
    ["BackgroundTransparency"] = Zh[15],
    ["Text"] = "0%",
    ["TextColor3"] = Zh[19],
    ["TextSize"] = Zh[21],
    ["Font"] = Zh[23],
    ["Parent"] = Zh[25]
};
Zh[7] = Zh[5]("TextLabel", Zh[9]);
Zh[5] = 90;
z[Zh[5]] = Zh[7];
Zh[7] = {
    "Initializing...",
    "Loading modules...",
    "Hooking functions...",
    "Applying patches...",
    "Finalizing..."
};
Zh[8] = 91;
Zh[10] = "task";
z[Zh[8]] = Zh[7];
Zh[9] = Env[Zh[10]];
Zh[10] = "spawn";
Zh[7] = Zh[9].spawn;
Zh[10] = function(...)
    y = 0;
    c = math.random(8, 14);
    for f = 1, c do
        b = f == c;
        if b then
            b = 1;
            x[f] = b;
        else
            K = E * math.random(10, 35) / 100;
            x[f] = K;
            E = E - K;
        end; 
    end;
    k = 27672486654550;
    I = 1;
    I = 0;
    U = {};
    K = 1;
    for k = c, I, I do
        table.insert(U, k); 
    end;
    for I = 1, math.min(math.random(3, 7), #U) do
        Q = I;
        V = math.random(1, #U);
        f[U[V]] = true;
        table.remove(U, V); 
    end;
    I = (1)[3];
    K = (1)[1];
    for I, Q in K, ipairs({}) do
        V = math.min(0 + Q, 1);
        S = .15 + math.random() * .35;
        while 0 < S do
            l = 0 + (V - 0) * (1 - (1 - math.clamp((0 + task.wait()) / S, 0, 1)) ^ 2);
            T = z[Zh[2]];
            T.Size = UDim2.new(l, 0, 1, 0);
            T = z[Zh[5]];
            T.Text = tostring(math.floor(l * 100)) .. "%";
            T = r195;
            T.Text = z[Zh[8]][math.clamp(math.floor(l * #z[Zh[8]]) + 1, 1, #z[Zh[8]])]; 
        end;
        G = z[Zh[2]];
        G.Size = UDim2.new(V, 0, 1, 0);
        G = z[Zh[5]];
        G.Text = tostring(math.floor(V * 100)) .. "%";
        if ({})[I] then
            task.wait(.4 + math.random() * .7);
        else
            task.wait(.03 + math.random() * .08);
        end; 
    end;
    k = z[Zh[2]];
    k.Size = UDim2.new(1, 0, 1, 0);
    k = z[Zh[5]];
    k.Text = "100%";
    k = r195;
    k.Text = "Done!";
    task.wait(.4);
    r193 = false;
    z[Zh[1]] = false;
    z[Zh[6]] = false;
    q = r191;
    q.Destroy(q);
    S = r15;
    if r29 == "14772802900" then
        q = r30;
        q.Toggled = false;
        q = r30;
        q.MenuAllowed = false;
        q = r43;
        q.Visible = false;
        if r32 then
            q = r32;
            q.Visible = false;
        end;
        r196 = r37("Frame", {
            ["Name"] = "LobbyFrame",
            ["Size"] = UDim2.new(0, 480, 0, 300),
            ["Position"] = UDim2.new(0.5, -240, 0.5, -150),
            ["BackgroundColor3"] = r34.Background,
            ["BackgroundTransparency"] = 0,
            ["BorderSizePixel"] = 0,
            ["Parent"] = r35
        });
        r38(r196, 10);
        r197 = r37("UIGradient", {
            ["Color"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 180, 255)),
                ColorSequenceKeypoint.new(.35, Color3.fromRGB(140, 50, 230)),
                ColorSequenceKeypoint.new(.7, Color3.fromRGB(200, 140, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 180, 255))
            }),
            ["Rotation"] = 0,
            ["Parent"] = r37("UIStroke", {
                ["Color"] = Color3.fromRGB(255, 255, 255),
                ["Thickness"] = 2.5,
                ["Transparency"] = .05,
                ["Parent"] = r196
            })
        });
        task.spawn(function(...)
            y = 0;
            c = r196;
            M = c;
            while not c do
                if M then
                    M = r197;
                    y = (y + task.wait() * 100) % 360;
                    E = (y + task.wait() * 100) % 360;
                    M.Rotation = E;
                end;
                return; 
            end;
            M = r196.Parent; 
        end);
        C = r196.InputBegan;
        C.Connect(C, function(arg1_163, ...)
            r201 = arg1_163;
            x = r201.UserInputType;
            if x == Enum.UserInputType.MouseButton1 or r201.UserInputType == Enum.UserInputType.Touch then
                r198 = true;
                r199 = r201.Position;
                r200 = r196.Position;
                x = r201.Changed;
                x.Connect(x, function(...)
                    if r201.UserInputState == Enum.UserInputState.End then
                        r198 = false;
                    end; 
                end);
            end; 
        end);
        C = r26.InputChanged;
        C.Connect(C, function(arg1_164, ...)
            y = arg1_164;
            if r198 and y.UserInputType == Enum.UserInputType.MouseMovement then
                c = y.Position - r199;
                b = r196;
                b.Position = UDim2.new(r200.X.Scale, r200.X.Offset + c.X, r200.Y.Scale, r200.Y.Offset + c.Y);
            end; 
        end);
        r202 = r37("TextLabel", {
            ["Size"] = UDim2.new(1, 0, 0, 40),
            ["Position"] = UDim2.new(0, 0, 0, 15),
            ["BackgroundTransparency"] = 1,
            ["Text"] = "SwagWare",
            ["TextColor3"] = Color3.fromRGB(255, 255, 255),
            ["TextSize"] = 24,
            ["Font"] = Enum.Font.Arcade,
            ["TextStrokeColor3"] = Color3.fromRGB(0, 0, 0),
            ["TextStrokeTransparency"] = 0.5,
            ["Parent"] = r196
        });
        r203 = r37("UIGradient", {
            ["Color"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(.3, Color3.fromRGB(220, 180, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 60, 255)),
                ColorSequenceKeypoint.new(.7, Color3.fromRGB(220, 180, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }),
            ["Offset"] = Vector2.new(-1, 0),
            ["Parent"] = r202
        });
        task.spawn(function(...)
            y = -1;
            c = r202;
            M = c;
            while not c do
                if M then
                    y = y + task.wait() * 1.4;
                    if y > 1 then
                        y = -1;
                    end;
                    x = r203;
                    x.Offset = Vector2.new(y, 0);
                end;
                return; 
            end;
            M = r202.Parent; 
        end);
        r204 = r37("TextLabel", {
            ["Size"] = UDim2.new(.85, 0, 0, 80),
            ["Position"] = UDim2.new(.075, 0, .32, 0),
            ["BackgroundTransparency"] = 1,
            ["Text"] = "Load after loading\ninto a Match!",
            ["TextColor3"] = Color3.fromRGB(255, 255, 255),
            ["TextSize"] = 26,
            ["Font"] = Enum.Font.Arcade,
            ["TextStrokeColor3"] = Color3.fromRGB(0, 0, 0),
            ["TextStrokeTransparency"] = .3,
            ["TextWrapped"] = true,
            ["Parent"] = r196
        });
        r205 = r37("UIGradient", {
            ["Color"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(.3, Color3.fromRGB(220, 180, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 60, 255)),
                ColorSequenceKeypoint.new(.7, Color3.fromRGB(220, 180, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            }),
            ["Offset"] = Vector2.new(-1, 0),
            ["Parent"] = r204
        });
        task.spawn(function(...)
            y = -1;
            c = r204;
            M = c;
            while not c do
                if M then
                    y = y + task.wait() * .8;
                    if y > 1 then
                        y = -1;
                    end;
                    x = r205;
                    x.Offset = Vector2.new(y, 0);
                end;
                return; 
            end;
            M = r204.Parent; 
        end);
        r206 = r37("TextButton", {
            ["Size"] = UDim2.new(0, 160, 0, 40),
            ["Position"] = UDim2.new(0.5, -80, .72, 0),
            ["BackgroundColor3"] = r34.SurfaceLight,
            ["BackgroundTransparency"] = 0,
            ["BorderSizePixel"] = 0,
            ["Text"] = "Close",
            ["TextColor3"] = Color3.fromRGB(255, 255, 255),
            ["TextSize"] = 16,
            ["Font"] = Enum.Font.Arcade,
            ["Parent"] = r196
        });
        r38(r206, 8);
        r40(r206, 1.5, .05);
        l = r206.MouseEnter;
        l.Connect(l, function(...)
            b = r75;
            M = b.Create(b, r206, TweenInfo.new(.15, Enum.EasingStyle.Quint), {
                ["BackgroundColor3"] = r34.Accent
            });
            M.Play(M); 
        end);
        l = r206.MouseLeave;
        l.Connect(l, function(...)
            b = r75;
            M = b.Create(b, r206, TweenInfo.new(.15, Enum.EasingStyle.Quint), {
                ["BackgroundColor3"] = r34.SurfaceLight
            });
            M.Play(M); 
        end);
        l = r206.MouseButton1Click;
        l.Connect(l, function(...)
            b = r196;
            b.Destroy(b); 
        end);
    else
        if r29 == "14939963714" then
            q = r30;
            q.MenuAllowed = true;
            q = r43;
            q.Visible = true;
            q = r30;
            q.Toggled = true;
            if r32 then
                q = r32;
                q.Visible = r30.WatermarkVisible;
            end;
        end;
        print("[SwagWare] Loaded | Right Shift / Insert to close/open");
        V = game;
        S = V.GetService(V, "ReplicatedStorage");
        V = S.FindFirstChild(S, "GameEvents");
        if V then
            S = game;
            V = S.GetService(S, "ReplicatedStorage").GameEvents;
            q = V.FindFirstChild(V, "VoteKick");
        end;
        b = ipairs;
        r207 = V;
        if r207 then
            q = r30;
            S = r207.OnClientEvent;
            q._antiVKConnection = S.Connect(S, function(...)
                y = {
                    s(1, e(g))
                };
                if r30.AntiVoteKick then
                    return;
                end; 
            end);
            b = ipairs;
            if hookmetamethod or getrawmetatable then
                V = getrawmetatable(game);
                if V then
                    r208 = V.__namecall;
                    q = checkcaller and setreadonly(V, true);
                    b = V;
                    setreadonly(V, false);
                    V.__namecall = newcclosure(function(arg1_165, ...)
                        y = arg1_165;
                        if r30.AntiVoteKick then
                            b = getnamecallmethod;
                            x = b();
                            b = b;
                            if (x == "FireServer" or x == "fireServer") and y == r207 then
                                return;
                            end;
                        end;
                        return r208(y, ...); 
                    end);
                    setreadonly(V, true);
                end;
            end;
            task.spawn(function(...)
                while task.wait(1) do
                    if r30.AntiVoteKick then
                        pcall(function(...)
                            b = r28;
                            y = b.WaitForChild(b, "PlayerGui", 1);
                            if not y then
                                return;
                            end;
                            c = y.FindFirstChild(y, "GameHUD");
                            if not c then
                                return;
                            end;
                            x = c.FindFirstChild(c, "PlayersTab");
                            if not x then
                                return;
                            end;
                            E = x.FindFirstChild(x, "ProfileFrame");
                            if not E then
                                return;
                            end;
                            X = E.FindFirstChild(E, "Scroller");
                            if not X then
                                return;
                            end;
                            f = X.FindFirstChild(X, "Kick");
                            if f then
                                f.Visible = false;
                            end; 
                        end);
                        pcall(function(...)
                            b = r28;
                            y = b.WaitForChild(b, "PlayerGui", 1);
                            if not y then
                                return;
                            end;
                            c = y.FindFirstChild(y, "VoteKick");
                            if c then
                                c.Enabled = false;
                            end; 
                        end);
                    end; 
                end; 
            end);
        else
            warn("[SwagWare] VoteKick RemoteEvent not found – anti-VK unavailable");
        end;
        return;
    end; 
end;
Zh[9] = Zh[7](Zh[10]);