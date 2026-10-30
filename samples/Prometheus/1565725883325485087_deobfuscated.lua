-- This file was generated at discord.gg/syncrypt

local U = {};
local v1 = {...};
local r1 = "a6unAFKIm";
for Z = 0, 1 do
    if Z == 0 then
        if r1 ~= "a6unAFKIm" then
            while true do end;
        end;
        r1 = true;
    else
        if Z == 1 then
            if r1 == true then
            end;
        end;
    end; 
end;
local r18 = math.floor;
local r20 = {};
local v2 = {};
for l = 1, 256 do
    v2[l] = l; 
end;
while not 256 do
    l = table.remove(v2, math.random(1, #v2));
    B = r20;
    B[l] = string.char(l - 1);
    B = #v2 == 0; 
end;
local r23 = {};
local r16 = setmetatable({}, {
    ["__index"] = r23,
    ["__metatable"] = nil
});
local v4 = game;
local r24 = v4.GetService(v4, "TweenService");
local v5 = v4.GetService(v4, "Players").LocalPlayer;
if not v5 then
    return;
end;
local v6 = v5.WaitForChild(v5, "PlayerGui");
local r25 = {
    ["Name"] = "Sentinel",
    ["KeyUrl"] = "https://link-hub.net/9156048/yyLUCzvhWMr7",
    ["DemoKey"] = "asdasdada!"
};
local r26 = {
    ["bg"] = Color3.fromRGB(4, 2, 4),
    ["panel"] = Color3.fromRGB(9, 5, 8),
    ["card"] = Color3.fromRGB(15, 9, 13),
    ["card2"] = Color3.fromRGB(21, 13, 17),
    ["input"] = Color3.fromRGB(6, 3, 6),
    ["white"] = Color3.fromRGB(255, 245, 240),
    ["muted"] = Color3.fromRGB(130, 110, 120),
    ["border"] = Color3.fromRGB(55, 18, 28),
    ["primary"] = Color3.fromRGB(255, 0, 60),
    ["secondary"] = Color3.fromRGB(255, 150, 15),
    ["accent"] = Color3.fromRGB(255, 70, 25),
    ["hot"] = Color3.fromRGB(255, 0, 110),
    ["success"] = Color3.fromRGB(40, 255, 90),
    ["danger"] = Color3.fromRGB(255, 15, 35)
};
local v7 = v6.FindFirstChild(v6, r25.Name);
if v7 then
    v7.Destroy(v7);
end;
local function r27(arg1_2, arg2_2, arg3_2, ...)
    a = Instance.new(arg1_2);
    v6 = "pairs";
    for v5, w in pairs(arg3_2) do
        a[v5] = w; 
    end;
    a.Parent = arg2_2;
    return a; 
end;
local function r28(arg1_3, arg2_3, ...)
    r27("UICorner", arg1_3, {
        ["CornerRadius"] = UDim.new(0, arg2_3)
    }); 
end;
local function r29(arg1_4, arg2_4, arg3_4, arg4_4, ...)
    Y = r27;
    y = r27;
    i = Y;
    return Y("UIStroke", arg1_4, {
        ["Color"] = arg2_4,
        ["Transparency"] = arg3_4 or 0,
        ["Thickness"] = arg4_4 or 1
    }); 
end;
local function r30(arg1_5, arg2_5, arg3_5, arg4_5, ...)
    v4 = arg3_5;
    a, L, v1 = arg4_5, arg2_5, arg1_5;
    v7 = r24;
    if a then
        Y = Enum.EasingDirection.Out;
        K = Y.Create(Y, arg1_5, TweenInfo.new(arg2_5, a, Enum.EasingDirection.Out), arg3_5);
        K.Play(K);
        return;
    else
        v6 = Enum.EasingStyle.Quad;
    end; 
end;
local function v8(arg1_6, arg2_6, arg3_6, arg4_6, arg5_6, arg6_6, arg7_6, arg8_6, arg9_6, ...)
    v4, v5, N, w, a, L, v7, v1 = arg3_6, arg6_6, arg5_6, arg9_6, arg4_6, arg2_6, arg8_6, arg1_6;
    v6 = arg7_6;
    y = "TextLabel";
    i = "Name";
    l = "Position";
    B = "Size";
    d = "BackgroundTransparency";
    v8 = 1;
    X = "Text";
    M = "TextColor3";
    t = "Font";
    g, H = v7, r27;
    if v7 then
        Y = Y;
        k = Y;
        if w then
            Y = Y;
            return Y("TextLabel", arg1_6, {
                ["Name"] = arg2_6,
                ["Position"] = arg4_6,
                ["Size"] = arg5_6,
                ["BackgroundTransparency"] = 1,
                ["Text"] = arg3_6,
                ["TextColor3"] = arg7_6,
                [r16[p]] = v7,
                ["TextSize"] = arg6_6,
                ["TextXAlignment"] = w,
                ["TextYAlignment"] = Enum.TextYAlignment.Center,
                ["TextWrapped"] = true
            });
        else
            s = Enum.TextXAlignment.Left;
        end;
    else
        g = Enum.Font.Gotham;
    end; 
end;
local function r31(arg1_7, arg2_7, arg3_7, arg4_7, ...)
    Y = r27;
    v2 = Y;
    return Y("UIGradient", arg1_7, {
        ["Color"] = ColorSequence.new({
            ColorSequenceKeypoint.new(0, arg2_7),
            ColorSequenceKeypoint.new(1, arg3_7)
        }),
        ["Rotation"] = arg4_7 or 0
    }); 
end;
local function v9(arg1_8, ...)
    w = UDim2;
    v6 = w.fromOffset;
    v6 = {
        UDim2.new(1, -12, 0, 0),
        UDim2.fromOffset(12, 1.5)
    };
    w = "ipairs";
    for v7, v2 in ipairs({
        {
            UDim2.fromOffset(0, 0),
            UDim2.fromOffset(12, 1.5)
        },
        {
            UDim2.fromOffset(0, 0),
            S(w)
        },
        v6,
        {
            UDim2.new(1, -1.5, 0, 0),
            UDim2.fromOffset(1.5, 12)
        },
        {
            UDim2.new(0, 0, 1, -1.5),
            UDim2.fromOffset(12, 1.5)
        },
        {
            UDim2.new(0, 0, 1, -12),
            UDim2.fromOffset(1.5, 12)
        },
        {
            UDim2.new(1, -12, 1, -1.5),
            UDim2.fromOffset(12, 1.5)
        },
        {
            UDim2.new(1, -1.5, 1, -12),
            UDim2.fromOffset(1.5, 12)
        }
    }), v6(1.5, 12) do
        y = v7;
        r27("Frame", arg1_8, {
            ["Position"] = v2[1],
            ["Size"] = v2[2],
            ["BackgroundColor3"] = r26.primary,
            ["BackgroundTransparency"] = .4,
            ["BorderSizePixel"] = 0
        }); 
    end; 
end;
local r36 = r27("ScreenGui", v6, {
    ["Name"] = r25.Name,
    ["IgnoreGuiInset"] = true,
    ["ResetOnSpawn"] = false,
    ["DisplayOrder"] = 100,
    ["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
});
local v10 = "BackgroundColor3";
local v11 = r27("Frame", r36, {
    ["Size"] = UDim2.fromScale(1, 1),
    [v10] = r26.bg,
    ["BackgroundTransparency"] = .15,
    ["BorderSizePixel"] = 0
});
local v12 = "pos";
UDim2.new(0.5, -280, 0.5, -200);
local v14 = r26.primary;
local v15 = "size";
UDim2.fromOffset(200, 160);
local v16 = "col";
for Yk, vk in ipairs(vk), v16 do
    E = Yk;
    r28(r27("Frame", v11, {
        ["Position"] = vk.pos,
        ["Size"] = vk.size,
        ["BackgroundColor3"] = vk.col,
        ["BackgroundTransparency"] = .85,
        ["BorderSizePixel"] = 0,
        ["ZIndex"] = 0
    }), 100); 
end;
local r37 = r27("Frame", v11, {
    ["AnchorPoint"] = Vector2.new(0.5, 0.5),
    ["Position"] = UDim2.fromScale(0.5, .53),
    ["Size"] = UDim2.fromOffset(590, 405),
    ["BackgroundColor3"] = r26.panel,
    ["BorderSizePixel"] = 0,
    ["ClipsDescendants"] = true
});
r28(r37, 12);
r29(r37, r26.border, .3, 1);
r27("Frame", r37, {
    ["Position"] = UDim2.fromOffset(12, 0),
    ["Size"] = UDim2.new(1, -24, 0, 1),
    ["BackgroundColor3"] = r26.white,
    ["BackgroundTransparency"] = .85,
    ["BorderSizePixel"] = 0
});
local function v17(arg1_10, arg2_10, arg3_10, arg4_10, ...)
    v1, L = arg1_10, arg2_10;
    Y = Vector2.new;
    v7 = Y;
    v5 = Y;
    w = Y;
    v6 = Y;
    N = Y(arg3_10 and 1 or 0, arg4_10 and 1 or 0);
    r27("Frame", r37, {
        ["AnchorPoint"] = N,
        ["Position"] = UDim2.fromOffset(v1, L),
        ["Size"] = UDim2.fromOffset(18, 2),
        ["BackgroundColor3"] = r26.primary,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0
    });
    r27("Frame", r37, {
        ["AnchorPoint"] = N,
        ["Position"] = UDim2.fromOffset(v1, L),
        ["Size"] = UDim2.fromOffset(2, 18),
        ["BackgroundColor3"] = r26.primary,
        ["BackgroundTransparency"] = .3,
        ["BorderSizePixel"] = 0
    }); 
end;
v17(0, 0, false, false);
v17(590, 0, true, false);
v17(0, 405, false, true);
v17(590, 405, true, true);
local r38 = r27("UIScale", r37, {
    ["Scale"] = 1
});
local r39 = workspace.CurrentCamera;
local function v18(...)
    if not r39 then
        return;
    end;
    v1 = r39.ViewportSize;
    Y = r38;
    Y.Scale = math.min(1, (v1.X - 24) / 590, (v1.Y - 24) / 405); 
end;
v18();
if r39 then
    v10 = r39;
    v12 = v10.GetPropertyChangedSignal(v10, "ViewportSize");
    v12.Connect(v12, v18);
end;
local v19 = r27("Frame", r37, {
    ["Position"] = UDim2.fromOffset(18, 10),
    ["Size"] = UDim2.new(1, -36, 0, 2),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0
});
r31(v19, r26.primary, r26.secondary, 0);
local r40 = r27("Frame", v19, {
    ["Position"] = UDim2.new(0, 0, 0, -1),
    ["Size"] = UDim2.fromOffset(30, 4),
    ["BackgroundColor3"] = r26.white,
    ["BackgroundTransparency"] = 0.5,
    ["BorderSizePixel"] = 0
});
r28(r40, 2);
task.spawn(function(...)
    while r40.Parent do
        r30(r40, 2.2, {
            ["Position"] = UDim2.new(1, -30, 0, -1)
        }, Enum.EasingStyle.Linear);
        task.wait(2.5);
        if not r40.Parent then
            break;
        else
            Y = r40;
            Y.Position = UDim2.new(0, 0, 0, -1);
        end; 
    end; 
end);
local r41 = r27("Frame", r37, {
    ["Position"] = UDim2.new(0, 0, 0, 0),
    ["Size"] = UDim2.new(1, 0, 0, 1),
    ["BackgroundColor3"] = r26.primary,
    ["BackgroundTransparency"] = .92,
    ["BorderSizePixel"] = 0
});
task.spawn(function(...)
    while r41.Parent do
        r30(r41, 3.5, {
            ["Position"] = UDim2.new(0, 0, 1, -1)
        }, Enum.EasingStyle.Linear);
        task.wait(4.3);
        if not r41.Parent then
            break;
        else
            Y = r41;
            Y.Position = UDim2.new(0, 0, 0, 0);
        end; 
    end; 
end);
local r42 = {};
for Kk = 1, 8 do
    Y = true;
    Zk = r27("Frame", r37, {
        ["Position"] = UDim2.new(math.random(10, 85) / 100, 0, math.random(10, 85) / 100, 0),
        ["Size"] = UDim2.fromOffset(math.random(2, 4), math.random(2, 4)),
        ["BackgroundColor3"] = v15 % 2 == 0 and r26.primary or r26.accent,
        ["BackgroundTransparency"] = math.random(50, 80) / 100,
        ["BorderSizePixel"] = 0
    });
    r28(Zk, 3);
    Lk = r42;
    Lk[v15] = Zk; 
end;
task.spawn(function(...)
    while r37.Parent do
        v4 = r42;
        for L, N in ipairs(K) do
            if N.Parent then
                r30(N, math.random(20, 50) / 10, {
                    ["Position"] = UDim2.new(math.random(5, 90) / 100, 0, math.random(5, 90) / 100, 0)
                }, Enum.EasingStyle.Sine);
            end; 
        end;
        task.wait(5); 
    end; 
end);
local v20 = r27("Frame", r37, {
    ["Name"] = "BrandBar",
    ["Position"] = UDim2.fromOffset(22, 28),
    ["Size"] = UDim2.fromOffset(3, 30),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0
});
r31(v20, r26.primary, r26.hot, 90);
r28(v20, 2);
local r43 = v8(r37, "Brand", "SENTINEL", UDim2.fromOffset(34, 26), UDim2.fromOffset(170, 22), 17, r26.white, Enum.Font.GothamBlack);
task.spawn(function(...)
    task.wait(1.5);
    while r43.Parent do
        for L = 1, math.random(2, 4) do
            Y = r43;
            N = L;
            Y.Position = UDim2.fromOffset(34 + math.random(-2, 2), 26 + math.random(-1, 1));
            Y = r43;
            Y = Y;
            Y.TextColor3 = math.random() > 0.5 and r26.primary or r26.white;
            task.wait(.05); 
        end;
        Y = r43;
        Y.Position = UDim2.fromOffset(34, 26);
        Y = r43;
        Y.TextColor3 = r26.white;
        task.wait(math.random(20, 60) / 10); 
    end; 
end);
v8(r37, "Sub", "PROTOCOL v2", UDim2.fromOffset(35, 48), UDim2.fromOffset(170, 14), 9, r26.muted, Enum.Font.GothamMedium);
local v21 = r27("Frame", r37, {
    ["Name"] = "LockBadge",
    ["AnchorPoint"] = Vector2.new(1, 0),
    ["Position"] = UDim2.new(1, -55, 0, 32),
    ["Size"] = UDim2.fromOffset(82, 24),
    ["BackgroundColor3"] = r26.card2,
    ["BorderSizePixel"] = 0
});
r28(v21, 5);
r29(v21, r26.border, .3, 1);
local r44 = r27("Frame", v21, {
    ["Position"] = UDim2.fromOffset(10, 9),
    ["Size"] = UDim2.fromOffset(7, 7),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0
});
r28(r44, 4);
local r45 = v8(v21, "BadgeText", "LOCKED", UDim2.fromOffset(23, 0), UDim2.new(1, -25, 1, 0), 9, r26.white, Enum.Font.GothamBold);
local r46 = false;
local r47 = r27("TextButton", r37, {
    ["Name"] = "Close",
    ["AnchorPoint"] = Vector2.new(1, 0),
    ["Position"] = UDim2.new(1, -17, 0, 32),
    ["Size"] = UDim2.fromOffset(26, 24),
    ["BackgroundColor3"] = r26.card,
    ["BorderSizePixel"] = 0,
    ["AutoButtonColor"] = false,
    ["Text"] = "×",
    ["TextColor3"] = r26.muted,
    ["Font"] = Enum.Font.Gotham,
    ["TextSize"] = 16,
    ["Active"] = false
});
r28(r47, 5);
local v22 = r47.MouseEnter;
v22.Connect(v22, function(...)
    if r46 then
        r30(r47, .1, {
            ["BackgroundColor3"] = r26.danger,
            ["TextColor3"] = r26.white
        });
    end; 
end);
local v23 = r47.MouseLeave;
v23.Connect(v23, function(...)
    if r46 then
        r30(r47, .1, {
            ["BackgroundColor3"] = r26.card,
            ["TextColor3"] = r26.muted
        });
    end; 
end);
local v24 = r47.Activated;
v24.Connect(v24, function(...)
    if not r46 then
        return;
    end;
    r30(r37, .15, {
        ["Position"] = UDim2.fromScale(0.5, .54),
        ["BackgroundTransparency"] = 1
    });
    task.wait(.16);
    Y = r36.Parent;
    if Y then
        Y = r36;
        Y.Destroy(Y);
    end; 
end);
local v25 = r27("Frame", r37, {
    ["Position"] = UDim2.fromOffset(18, 78),
    ["Size"] = UDim2.new(1, -36, 0, 100),
    ["BackgroundColor3"] = r26.card,
    ["BorderSizePixel"] = 0
});
r28(v25, 8);
r29(v25, r26.border, .15);
v9(v25);
r31(r27("Frame", v25, {
    ["Position"] = UDim2.fromOffset(12, 14),
    ["Size"] = UDim2.fromOffset(2, 72),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0
}), r26.primary, r26.hot, 90);
v8(v25, "Eyebrow", "INITIALIZE", UDim2.fromOffset(26, 12), UDim2.fromOffset(200, 14), 9, r26.accent, Enum.Font.GothamBold);
v8(v25, "Title", "Unlock your script", UDim2.fromOffset(26, 28), UDim2.fromOffset(270, 28), 23, r26.white, Enum.Font.GothamBold);
v8(v25, "Desc", "Enter your key below to get started.", UDim2.fromOffset(27, 58), UDim2.fromOffset(270, 18), 11, r26.muted);
r27("Frame", v25, {
    ["Position"] = UDim2.new(.57, 0, 0, 16),
    ["Size"] = UDim2.new(0, 1, 1, -32),
    ["BackgroundColor3"] = r26.border,
    ["BorderSizePixel"] = 0
});
v8(v25, "F1", "▸  Quick Key Check", UDim2.new(.61, 0, 0, 15), UDim2.new(.36, -8, 0, 18), 10, r26.white);
v8(v25, "F2", "▸  Easy To Use", UDim2.new(.61, 0, 0, 40), UDim2.new(.36, -8, 0, 18), 10, r26.white);
v8(v25, "F3", "▸  Have Fun & Enjoy", UDim2.new(.61, 0, 0, 65), UDim2.new(.36, -8, 0, 18), 10, r26.white);
local v26 = r27("Frame", r37, {
    ["Position"] = UDim2.fromOffset(18, 188),
    ["Size"] = UDim2.new(1, -36, 0, 84),
    ["BackgroundColor3"] = r26.card,
    ["BorderSizePixel"] = 0
});
r28(v26, 8);
r29(v26, r26.border, .15);
v9(v26);
v8(v26, "KeyLabel", "ACCESS KEY", UDim2.fromOffset(14, 8), UDim2.fromOffset(140, 15), 9, r26.muted, Enum.Font.GothamBold);
local r48 = r27("Frame", v26, {
    ["Position"] = UDim2.fromOffset(14, 28),
    ["Size"] = UDim2.new(1, -238, 0, 42),
    ["BackgroundColor3"] = r26.input,
    ["BorderSizePixel"] = 0
});
r28(r48, 6);
local r49 = r29(r48, r26.border, 0, 1);
local r50 = r27("TextBox", r48, {
    ["Position"] = UDim2.fromOffset(12, 0),
    ["Size"] = UDim2.new(1, -24, 1, 0),
    ["BackgroundTransparency"] = 1,
    ["ClearTextOnFocus"] = false,
    ["Text"] = "",
    ["PlaceholderText"] = "Paste your key here...",
    ["PlaceholderColor3"] = r26.muted,
    ["TextColor3"] = r26.white,
    ["Font"] = Enum.Font.Gotham,
    ["TextSize"] = 12,
    ["TextXAlignment"] = Enum.TextXAlignment.Left
});
local v27 = r50.Focused;
v27.Connect(v27, function(...)
    r30(r49, .15, {
        ["Color"] = r26.primary,
        ["Transparency"] = 0
    }); 
end);
local v28 = r50.FocusLost;
v28.Connect(v28, function(...)
    r30(r49, .15, {
        ["Color"] = r26.border,
        ["Transparency"] = 0
    }); 
end);
local function v29(arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11, arg7_11, arg8_11, ...)
    r51 = arg6_11;
    r52 = arg7_11;
    r53 = arg8_11;
    Y = r27;
    w = "TextButton";
    v2 = "Name";
    i = "Position";
    l = "Size";
    B = "BackgroundColor3";
    Y = Y;
    d = r51 and r52 or r26.card2;
    v8 = "BorderSizePixel";
    s = Y;
    k = r51;
    Y = Y;
    if k then
        Y = Y;
        r54 = Y("TextButton", arg1_11, {
            ["Name"] = arg2_11,
            ["Position"] = arg4_11,
            ["Size"] = arg5_11,
            ["BackgroundColor3"] = U[v5] and U[v6] or r26.card2,
            ["BorderSizePixel"] = 0,
            ["AutoButtonColor"] = false,
            ["Text"] = arg3_11,
            ["TextColor3"] = k and Color3.fromRGB(8, 3, 5),
            ["Font"] = Enum.Font.GothamBold,
            ["TextSize"] = 11
        });
        r28(r54, 6);
        if r51 then
            r55 = r31(r54, r52 or r26.primary, r53 or r26.secondary, 0);
            task.spawn(function(...)
                while r54.Parent do
                    if true then
                        L, Y = r53 or r26.secondary, K[L];
                    end;
                    Y, K = K[L], v1;
                    if v1 then
                        L = L;
                        if true then
                            Y, v4 = v4, r52 or r26.primary;
                        end;
                        Y = Y;
                        r30(r55, 1.8, {
                            ["Color"] = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, L),
                                ColorSequenceKeypoint.new(1, v1 or (r53 or r26.secondary))
                            })
                        });
                        v1 = not true;
                        task.wait(1.8);
                    else
                        Y, K = Y, r52 or r26.primary;
                    end; 
                end; 
            end);
            r56 = r27("Frame", arg1_11, {
                ["Position"] = arg4_11 + UDim2.fromOffset(-3, -3),
                ["Size"] = arg5_11 + UDim2.fromOffset(6, 6),
                ["BackgroundColor3"] = r52 or r26.primary,
                ["BackgroundTransparency"] = .7,
                ["BorderSizePixel"] = 0,
                ["ZIndex"] = 0
            });
            r28(r56, 9);
            task.spawn(function(...)
                Y = r54.Parent;
                while Y do
                    Y = r30;
                    v6 = Y;
                    Y(r56, 1.2, {
                        ["BackgroundTransparency"] = true and .85 or 0.5
                    });
                    v1 = not true;
                    task.wait(1.2); 
                end; 
            end);
        else
            r29(r54, r26.border, .1, 1);
        end;
        r57 = r54.Size;
        Y = r54.MouseEnter;
        Y.Connect(Y, function(...)
            Y = r30;
            v5, v7 = Y, v5;
            Y = v7;
            Y = v5;
            Y(r54, .1, {
                ["BackgroundColor3"] = r51 and r26.secondary or r26.card
            }); 
        end);
        Y = r54.MouseLeave;
        Y.Connect(Y, function(...)
            Y = r30;
            v7 = v5;
            v5 = Y;
            Y = v7;
            Y = v5;
            Y(r54, .1, {
                ["BackgroundColor3"] = r51 and r52 or r26.card2
            }); 
        end);
        Y = r54.Activated;
        Y.Connect(Y, function(...)
            r30(r54, .05, {
                ["Size"] = UDim2.new(r57.X.Scale, r57.X.Offset, r57.Y.Scale, r57.Y.Offset - 2)
            });
            task.delay(.06, function(...)
                if r54.Parent then
                    r30(r54, .08, {
                        ["Size"] = r57
                    });
                end; 
            end); 
        end);
        return r54;
    else
        v9 = r26.white;
    end; 
end;
local r58 = v29(v26, "CheckBtn", "CHECK KEY  →", UDim2.new(1, -200, 0, 28), UDim2.fromOffset(186, 42), true, r26.primary, r26.accent);
local v30 = r27("Frame", r37, {
    ["Position"] = UDim2.fromOffset(18, 282),
    ["Size"] = UDim2.new(0.5, -22, 0, 68),
    ["BackgroundColor3"] = r26.card,
    ["BorderSizePixel"] = 0
});
r28(v30, 8);
r29(v30, r26.border, .15);
v9(v30);
local v31 = r27("Frame", v30, {
    ["Position"] = UDim2.fromOffset(12, 12),
    ["Size"] = UDim2.fromOffset(32, 32),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0
});
r28(v31, 7);
r31(v31, r26.primary, r26.hot, 45);
v8(v31, "Arrow", "↗", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 16, Color3.fromRGB(8, 3, 5), Enum.Font.GothamBold, Enum.TextXAlignment.Center);
v8(v30, "Title", "GET KEY LINK", UDim2.fromOffset(52, 8), UDim2.new(1, -62, 0, 17), 10, r26.white, Enum.Font.GothamBold);
v8(v30, "Desc", "Open the link to get your key.", UDim2.fromOffset(52, 26), UDim2.new(1, -62, 0, 16), 9, r26.muted);
local v32 = r27("Frame", r37, {
    ["Position"] = UDim2.new(0.5, 4, 0, 282),
    ["Size"] = UDim2.new(0.5, -22, 0, 68),
    ["BackgroundColor3"] = r26.card,
    ["BorderSizePixel"] = 0
});
r28(v32, 8);
r29(v32, r26.border, .15);
v9(v32);
local r59 = r27("Frame", v32, {
    ["Position"] = UDim2.fromOffset(14, 15),
    ["Size"] = UDim2.fromOffset(7, 7),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0
});
r28(r59, 4);
v8(v32, "Title", "STATUS", UDim2.fromOffset(28, 8), UDim2.fromOffset(100, 17), 10, r26.white, Enum.Font.GothamBold);
local r60 = v8(v32, "Msg", "Waiting for key...", UDim2.fromOffset(14, 28), UDim2.new(1, -24, 0, 16), 10, r26.muted);
r27("Frame", v32, {
    ["Position"] = UDim2.fromOffset(14, 48),
    ["Size"] = UDim2.new(1, -28, 0, 1),
    ["BackgroundColor3"] = r26.border,
    ["BorderSizePixel"] = 0
});
v8(v32, "Foot", "KEY REQUIRED TO CONTINUE", UDim2.fromOffset(14, 51), UDim2.new(1, -24, 0, 12), 7, r26.muted);
r27("Frame", r37, {
    ["Position"] = UDim2.fromOffset(18, 370),
    ["Size"] = UDim2.new(1, -36, 0, 1),
    ["BackgroundColor3"] = r26.border,
    ["BorderSizePixel"] = 0
});
v8(r37, "FootL", "SENTINEL  /  PROTOCOL", UDim2.fromOffset(20, 375), UDim2.fromOffset(230, 16), 8, r26.muted, Enum.Font.GothamMedium);
v8(r37, "FootR", "SCRIPT PANEL", UDim2.new(1, -148, 0, 375), UDim2.fromOffset(126, 16), 8, r26.muted, Enum.Font.GothamMedium, Enum.TextXAlignment.Right);
local function r61(arg1_12, arg2_12, ...)
    L = arg2_12;
    Y = r60;
    v4 = arg1_12;
    Y.Text = v4;
    v4 = r26.muted;
    Y = L == "ok";
    if Y then
        v4 = r26.success;
    end;
    if L == "err" then
        v4 = r26.danger;
    end;
    a = r60;
    v5 = r26.muted;
    a.TextColor3 = v5;
    r30(r59, .15, {
        ["BackgroundColor3"] = v4
    });
    r30(r44, .15, {
        ["BackgroundColor3"] = v4
    });
    a = r45;
    v6 = Y;
    N = "Text";
    v7 = L == "ok" and "UNLOCKED";
    Y = Y;
    v5 = v7;
    if v7 then
    end; 
end;
local r62 = r27("Frame", v11, {
    ["AnchorPoint"] = Vector2.new(0.5, 0.5),
    ["Position"] = UDim2.fromScale(0.5, 0.5),
    ["Size"] = UDim2.fromOffset(390, 160),
    ["BackgroundColor3"] = r26.panel,
    ["BorderSizePixel"] = 0,
    ["Visible"] = false,
    ["ZIndex"] = 10
});
r28(r62, 10);
r29(r62, r26.border, 0, 1);
v9(r62);
r31(r27("Frame", r62, {
    ["Position"] = UDim2.fromOffset(14, 10),
    ["Size"] = UDim2.new(1, -28, 0, 2),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0,
    ["ZIndex"] = 11
}), r26.primary, r26.secondary, 0);
v8(r62, "PTitle", "GET YOUR KEY", UDim2.fromOffset(18, 18), UDim2.new(1, -60, 0, 22), 15, r26.white, Enum.Font.GothamBold);
wk.ZIndex = 11;
v8(r62, "PInfo", "Copy this link and open it in your browser.", UDim2.fromOffset(19, 43), UDim2.new(1, -38, 0, 17), 10, r26.muted);
hk.ZIndex = 11;
NS[1] = 18684054282748;
local r63 = r27("TextBox", r62, {
    ["Position"] = UDim2.fromOffset(16, 70),
    ["Size"] = UDim2.new(1, -32, 0, 38),
    ["BackgroundColor3"] = r26.input,
    ["BorderSizePixel"] = 0,
    ["ClearTextOnFocus"] = false,
    ["TextEditable"] = false,
    ["Selectable"] = true,
    ["Text"] = r25.KeyUrl,
    ["TextColor3"] = r26.white,
    ["Font"] = Enum.Font.Gotham,
    ["TextSize"] = 11,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["ZIndex"] = 11
});
r28(r63, 6);
r29(r63, r26.border, .1, 1);
local r64 = r27("TextButton", r62, {
    ["Position"] = UDim2.new(1, -100, 0, 116),
    ["Size"] = UDim2.fromOffset(83, 24),
    ["BackgroundColor3"] = r26.primary,
    ["BorderSizePixel"] = 0,
    ["AutoButtonColor"] = false,
    ["Text"] = "COPY LINK",
    ["TextColor3"] = Color3.fromRGB(8, 3, 5),
    ["Font"] = Enum.Font.GothamBold,
    ["TextSize"] = 9,
    ["ZIndex"] = 11
});
r28(r64, 5);
r31(r64, r26.primary, r26.secondary, 0);
local r65 = v8(r62, "Hint", "Select the link above if copying is blocked.", UDim2.fromOffset(18, 116), UDim2.new(1, -130, 0, 24), 9, r26.muted);
local v33 = r65;
v33.ZIndex = 11;
local v34 = r64.Activated;
v34.Connect(v34, function(...)
    Y = r63;
    Y.CaptureFocus(Y);
    Y = r63;
    Y.SelectionStart = 1;
    Y = r63;
    Y.CursorPosition = #r63.Text + 1;
    Y = r64;
    Y.Text = "SELECTED";
    Y = r65;
    Y.Text = "Press Ctrl+C to copy.";
    Y = r65;
    Y.TextColor3 = r26.accent; 
end);
local v35 = r27("TextButton", r62, {
    ["AnchorPoint"] = Vector2.new(1, 0),
    ["Position"] = UDim2.new(1, -10, 0, 15),
    ["Size"] = UDim2.fromOffset(22, 22),
    ["BackgroundColor3"] = r26.card2,
    ["BorderSizePixel"] = 0,
    ["Text"] = "×",
    ["TextColor3"] = r26.muted,
    ["Font"] = Enum.Font.Gotham,
    ["TextSize"] = 15,
    ["ZIndex"] = 11
});
r28(v35, 5);
local v36 = v35.Activated;
v36.Connect(v36, function(...)
    Y = r62;
    Y.Visible = false; 
end);
local v37 = v29(v30, "OpenBtn", "OPEN LINK  ↗", UDim2.fromOffset(10, 46), UDim2.new(1, -20, 0, 16), false).Activated;
v37.Connect(v37, function(...)
    Y = r62;
    Y.Visible = true;
    Y = r63;
    Y.CaptureFocus(Y);
    Y = r63;
    Y.SelectionStart = 1;
    Y = r63;
    Y.CursorPosition = #r63.Text + 1;
    r61("Copy the link above.", "ok"); 
end);
local r66 = false;
local function r67(...)
    if r66 then
        return;
    end;
    if r50.Text ~= r25.DemoKey then
        r61("Invalid key.", "err");
        return;
    end;
    r66 = true;
    r46 = true;
    v1 = r58;
    v1.Text = "KEY ACCEPTED  ✓";
    r61("Welcome!", "ok");
    r30(r58, .18, {
        ["BackgroundColor3"] = r26.success
    });
    v1 = r47;
    v1.Active = true;
    r30(r47, .2, {
        ["TextColor3"] = r26.white
    });
    task.wait(.6);
    v1 = r36.Parent;
    if v1 then
        v1 = r36;
        v1.Destroy(v1);
    end; 
end;
local v38 = r58.Activated;
v38.Connect(v38, r67);
local v39 = r50.FocusLost;
v39.Connect(v39, function(arg1_13, ...)
    if arg1_13 then
        r67();
    end; 
end);
local v40 = r37;
v40.Position = UDim2.fromScale(0.5, .535);
local v41 = r37;
v41.BackgroundTransparency = .05;
r30(r37, .15, {
    ["Position"] = UDim2.fromScale(0.5, 0.5),
    ["BackgroundTransparency"] = 0
});