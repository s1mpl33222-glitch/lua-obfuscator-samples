-- This file was generated at discord.gg/syncrypt

local P = {};
local v2 = game;
local r24 = v2.GetService(v2, "TweenService");
local v3 = v2.GetService(v2, "Players").LocalPlayer;
if not v3 then
    return;
end;
local v4 = v3.WaitForChild(v3, "PlayerGui");
local r25 = {
    ["GuiName"] = "KeyAccessPanel",
    ["KeyUrl"] = "https://is.gd/LUrEFL",
    ["DemoKey"] = "asdasdada!",
    ["Colors"] = {
        ["Screen"] = Color3.fromRGB(9, 10, 15),
        ["Card"] = Color3.fromRGB(20, 22, 30),
        ["Raised"] = Color3.fromRGB(32, 36, 48),
        ["Input"] = Color3.fromRGB(12, 14, 21),
        ["Accent"] = Color3.fromRGB(104, 155, 255),
        ["AccentHot"] = Color3.fromRGB(137, 179, 255),
        ["MainText"] = Color3.fromRGB(245, 247, 255),
        ["SoftText"] = Color3.fromRGB(151, 160, 180),
        ["Edge"] = Color3.fromRGB(54, 63, 82),
        ["Okay"] = Color3.fromRGB(103, 222, 164),
        ["Nope"] = Color3.fromRGB(255, 105, 125)
    }
};
local r26 = r25.Colors;
local v5 = v4.FindFirstChild(v4, r25.GuiName);
if v5 then
    v5.Destroy(v5);
end;
local function r27(arg1_2, arg2_2, arg3_2, ...)
    s = Instance.new(arg1_2);
    v4 = "pairs";
    for v3, T in pairs(arg3_2) do
        s[v3] = T; 
    end;
    s.Parent = arg2_2;
    return s; 
end;
local function r28(arg1_3, arg2_3, ...)
    r27("UICorner", arg1_3, {
        ["CornerRadius"] = UDim.new(0, arg2_3)
    }); 
end;
local function r29(arg1_4, arg2_4, arg3_4, ...)
    i = r27;
    T = r27;
    return i("UIStroke", arg1_4, {
        ["Color"] = arg2_4,
        ["Transparency"] = arg3_4 or 0,
        ["Thickness"] = 1
    }); 
end;
local function r30(arg1_5, arg2_5, arg3_5, ...)
    i = r24;
    s = i.Create(i, arg1_5, TweenInfo.new(arg2_5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), arg3_5);
    s.Play(s);
    return s; 
end;
local function v6(arg1_6, arg2_6, arg3_6, arg4_6, arg5_6, arg6_6, arg7_6, arg8_6, ...)
    v5 = arg8_6;
    i = r27;
    S = i;
    if v5 then
        j = Enum.Font.GothamBold;
    end;
    i = i;
    if v5 then
        i = i;
        return i("TextLabel", arg1_6, {
            ["Name"] = arg2_6,
            ["Position"] = arg4_6,
            ["Size"] = arg5_6,
            ["BackgroundTransparency"] = 1,
            ["Font"] = v5,
            ["Text"] = arg3_6,
            ["TextColor3"] = arg7_6,
            ["TextSize"] = arg6_6,
            ["TextXAlignment"] = Enum.TextXAlignment.Left
        });
    else
        l = Enum.Font.Gotham;
    end; 
end;
local r31 = r27("ScreenGui", v4, {
    ["Name"] = r25.GuiName,
    ["ResetOnSpawn"] = false,
    ["IgnoreGuiInset"] = true,
    ["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
});
r27("Frame", r31, {
    ["Name"] = "ScreenShade",
    ["Size"] = UDim2.fromScale(1, 1),
    ["BackgroundColor3"] = r26.Screen,
    ["BackgroundTransparency"] = .2,
    ["BorderSizePixel"] = 0
});
local r32 = r27("Frame", r31, {
    ["Name"] = "MainCard",
    ["AnchorPoint"] = Vector2.new(0.5, 0.5),
    ["Position"] = UDim2.fromScale(0.5, .56),
    ["Size"] = UDim2.fromOffset(400, 294),
    ["BackgroundColor3"] = r26.Card,
    ["BackgroundTransparency"] = 1,
    ["BorderSizePixel"] = 0
});
r28(r32, 12);
r29(r32, r26.Edge, .1);
r30(r32, .3, {
    ["BackgroundTransparency"] = 0,
    ["Position"] = UDim2.fromScale(0.5, .53)
});
r27("Frame", r32, {
    ["Name"] = "Accent",
    ["Position"] = UDim2.fromOffset(0, 0),
    ["Size"] = UDim2.new(1, 0, 0, 3),
    ["BackgroundColor3"] = r26.Accent,
    ["BorderSizePixel"] = 0
});
local v7 = r27("Frame", r32, {
    ["Name"] = "IconTile",
    ["Position"] = UDim2.fromOffset(24, 36),
    ["Size"] = UDim2.fromOffset(46, 46),
    ["BackgroundColor3"] = r26.Raised,
    ["BorderSizePixel"] = 0
});
r28(v7, 10);
r29(v7, r26.Edge, .2);
r27("TextLabel", v7, {
    ["Name"] = "IconText",
    ["Size"] = UDim2.fromScale(1, 1),
    ["BackgroundTransparency"] = 1,
    ["Font"] = Enum.Font.GothamBold,
    ["Text"] = "KA",
    ["TextColor3"] = r26.Accent,
    ["TextSize"] = 14
});
v6(r32, "Section", "SECURE ACCESS", UDim2.fromOffset(84, 39), UDim2.new(1, -108, 0, 14), 9, r26.Accent, true);
v6(r32, "Heading", "Welcome back", UDim2.fromOffset(84, 57), UDim2.new(1, -108, 0, 25), 18, r26.MainText, true);
v6(r32, "Instruction", "Enter your access key to continue.", UDim2.fromOffset(24, 100), UDim2.new(1, -48, 0, 18), 11, r26.SoftText, false);
v6(r32, "FieldCaption", "ACCESS KEY", UDim2.fromOffset(24, 130), UDim2.new(1, -48, 0, 14), 9, r26.SoftText, true);
local v8 = r27("Frame", r32, {
    ["Name"] = "InputShell",
    ["Position"] = UDim2.fromOffset(24, 151),
    ["Size"] = UDim2.new(1, -48, 0, 42),
    ["BackgroundColor3"] = r26.Input,
    ["BorderSizePixel"] = 0
});
r28(v8, 7);
local r33 = r29(v8, r26.Edge, 0);
local r34 = r27("TextBox", v8, {
    ["Name"] = "KeyField",
    ["Position"] = UDim2.fromOffset(12, 0),
    ["Size"] = UDim2.new(1, -24, 1, 0),
    ["BackgroundTransparency"] = 1,
    ["ClearTextOnFocus"] = false,
    ["Font"] = Enum.Font.Gotham,
    ["PlaceholderText"] = "Enter your key here...",
    ["PlaceholderColor3"] = r26.SoftText,
    ["Text"] = "",
    ["TextColor3"] = r26.MainText,
    ["TextSize"] = 12,
    ["TextXAlignment"] = Enum.TextXAlignment.Left
});
local v9 = r34.Focused;
v9.Connect(v9, function(...)
    r30(r33, .13, {
        ["Color"] = r26.Accent
    }); 
end);
local v10 = r34.FocusLost;
v10.Connect(v10, function(...)
    r30(r33, .13, {
        ["Color"] = r26.Edge
    }); 
end);
local r35 = r27("Frame", r32, {
    ["Name"] = "StateDot",
    ["Position"] = UDim2.fromOffset(26, 208),
    ["Size"] = UDim2.fromOffset(7, 7),
    ["BackgroundColor3"] = r26.SoftText,
    ["BorderSizePixel"] = 0
});
r28(r35, 5);
local r36 = v6(r32, "StateLabel", "Waiting for key...", UDim2.fromOffset(40, 201), UDim2.new(1, -64, 0, 20), 10, r26.SoftText, false);
local function r37(arg1_7, arg2_7, ...)
    X = arg1_7;
    v2 = r26.SoftText;
    if arg2_7 == true then
        v2 = r26.Okay;
    else
        if arg2_7 == false then
            v2 = r26.Nope;
        end;
        s = r36;
        v3, I = arg1_7, nil;
        s.Text = v3;
        s = r36;
        v3 = v2;
        s.TextColor3 = v3;
        s = r35;
        s.BackgroundColor3 = v2;
        return;
    end; 
end;
local function v11(arg1_8, arg2_8, arg3_8, arg4_8, arg5_8, ...)
    v2, I, s, E = arg3_8, arg2_8, arg4_8, arg5_8;
    X = arg1_8;
    if E then
        v3 = r26.Accent;
    end;
    r38 = E or r26.Raised;
    if E then
        v4 = r26.AccentHot;
    end;
    i = true;
    if E then
        r39 = E;
        i = r27;
        v5 = "TextButton";
        T = r32;
        u = "Name";
        m = "Position";
        k = "Size";
        v8 = i;
        if E then
            K = Color3.fromRGB(12, 20, 36);
        end;
        i = i;
        if E then
            i = i;
            r40 = i("TextButton", r32, {
                ["Name"] = arg1_8,
                ["Position"] = arg3_8,
                ["Size"] = arg4_8,
                ["BackgroundColor3"] = r38,
                ["BorderSizePixel"] = 0,
                ["AutoButtonColor"] = false,
                ["Font"] = Enum.Font.GothamBold,
                ["Text"] = arg2_8,
                ["TextColor3"] = E,
                ["TextSize"] = 10
            });
            r28(r40, 7);
            i = r29;
            T = r40;
            u = i;
            m = arg5_8;
            V, i = m and r26.Accent, i;
            if m then
                i = i;
                i(P[v5], m and r26.Accent, 0.25);
                i = r40.MouseEnter;
                i.Connect(i, function(...)
                    r30(r40, .12, {
                        ["BackgroundColor3"] = r39
                    }); 
                end);
                i = r40.MouseLeave;
                i.Connect(i, function(...)
                    r30(r40, .12, {
                        ["BackgroundColor3"] = r38
                    }); 
                end);
                return r40;
            else
                V = r26.Edge;
            end;
        else
            v7 = r26.MainText;
        end;
    else
        v = Color3.fromRGB(44, 49, 64);
    end; 
end;
local r41 = v11("SubmitButton", "VERIFY KEY", UDim2.new(0.5, 6, 0, 237), UDim2.new(0.5, -30, 0, 38), true);
local v12 = v11("LinkButton", "SHOW KEY LINK", UDim2.fromOffset(24, 237), UDim2.new(0.5, -30, 0, 38), false).Activated;
v12.Connect(v12, function(...)
    i = r34;
    i.Text = r25.KeyUrl;
    i = r34;
    i.CaptureFocus(i);
    i = r34;
    i.CursorPosition = #r34.Text + 1;
    r37("Select the link and copy it."); 
end);
local r42 = false;
local function r43(...)
    if r42 then
        return;
    end;
    if r34.Text ~= r25.DemoKey then
        r37("That key is not valid.", false);
        return;
    end;
    r42 = true;
    v = r41;
    v.Text = "ACCEPTED";
    r37("Key accepted.", true);
    task.wait(.45);
    v = r31.Parent;
    if v then
        v = r31;
        v.Destroy(v);
    end; 
end;
local v13 = r41.Activated;
v13.Connect(v13, r43);
local v14 = r34.FocusLost;
v14.Connect(v14, function(arg1_9, ...)
    if arg1_9 then
        r43();
    end; 
end);