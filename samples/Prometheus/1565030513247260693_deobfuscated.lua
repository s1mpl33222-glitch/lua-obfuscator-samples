-- This file was generated at discord.gg/syncrypt

local p = {};
local v2 = game;
local r24 = v2.GetService(v2, "TweenService");
local v3 = v2.GetService(v2, "Players").LocalPlayer;
if v3 == nil then
    return;
end;
local v4 = v3.WaitForChild(v3, "PlayerGui");
local r25 = {
    ["GuiName"] = "KeyAccessPanel",
    ["KeyUrl"] = "https://link-target.net/9156048/DQMbizAvcbFu",
    ["DemoKey"] = "asdasdada!",
    ["Colors"] = {
        ["Screen"] = Color3.fromRGB(11, 12, 18),
        ["Card"] = Color3.fromRGB(24, 25, 35),
        ["Raised"] = Color3.fromRGB(35, 35, 49),
        ["Input"] = Color3.fromRGB(15, 16, 25),
        ["Accent"] = Color3.fromRGB(242, 126, 166),
        ["AccentHot"] = Color3.fromRGB(255, 151, 188),
        ["MainText"] = Color3.fromRGB(247, 244, 250),
        ["SoftText"] = Color3.fromRGB(163, 158, 178),
        ["Edge"] = Color3.fromRGB(64, 58, 78),
        ["Okay"] = Color3.fromRGB(103, 222, 164),
        ["Nope"] = Color3.fromRGB(255, 105, 125)
    }
};
local r26 = r25.Colors;
local function r27(arg1_2, arg2_2, arg3_2, ...)
    U = Instance.new(arg1_2);
    v4 = "pairs";
    for v3, y in pairs(arg3_2) do
        U[v3] = y; 
    end;
    U.Parent = arg2_2;
    return U; 
end;
local function r28(arg1_3, arg2_3, ...)
    r27("UICorner", arg1_3, {
        ["CornerRadius"] = UDim.new(0, arg2_3)
    }); 
end;
local function r29(arg1_4, arg2_4, arg3_4, ...)
    B = r27;
    y = r27;
    return B("UIStroke", arg1_4, {
        ["Color"] = arg2_4,
        ["Transparency"] = arg3_4 or 0,
        ["Thickness"] = 1
    }); 
end;
local function r30(arg1_5, arg2_5, arg3_5, ...)
    B = r24;
    U = B.Create(B, arg1_5, TweenInfo.new(arg2_5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), arg3_5);
    U.Play(U);
    return U; 
end;
local function v5(arg1_6, arg2_6, arg3_6, arg4_6, arg5_6, arg6_6, arg7_6, arg8_6, ...)
    B = r27;
    Y = arg8_6;
    if Y then
        Q = Enum.Font.GothamBold;
    end;
    B = B;
    B = B;
    return B("TextLabel", arg1_6, {
        ["Name"] = arg2_6,
        ["Position"] = arg4_6,
        ["Size"] = arg5_6,
        ["BackgroundTransparency"] = 1,
        ["Font"] = Y or Enum.Font.Gotham,
        ["Text"] = arg3_6,
        ["TextColor3"] = arg7_6,
        ["TextSize"] = arg6_6,
        ["TextXAlignment"] = Enum.TextXAlignment.Left
    }); 
end;
local v6 = v4.FindFirstChild(v4, r25.GuiName);
if v6 then
    v6.Destroy(v6);
end;
local r31 = r27("ScreenGui", v4, {
    ["Name"] = r25.GuiName,
    ["ResetOnSpawn"] = false,
    ["IgnoreGuiInset"] = true,
    ["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
});
local v7 = r27("Frame", r27("Frame", r31, {
    ["Name"] = "ScreenShade",
    ["Size"] = UDim2.fromScale(1, 1),
    ["BackgroundColor3"] = r26.Screen,
    ["BackgroundTransparency"] = .2,
    ["BorderSizePixel"] = 0
}), {
    ["Name"] = "MainCard",
    ["AnchorPoint"] = Vector2.new(0.5, 0.5),
    ["Position"] = UDim2.fromScale(0.5, .53),
    ["Size"] = UDim2.fromOffset(400, 294),
    ["BackgroundColor3"] = r26.Card,
    ["BorderSizePixel"] = 0
});
r28(v7, 15);
r29(v7, r26.Edge, .15);
r28(r27("Frame", v7, {
    ["Name"] = "Accent",
    ["Position"] = UDim2.fromOffset(20, 18),
    ["Size"] = UDim2.new(1, -40, 0, 3),
    ["BackgroundColor3"] = r26.Accent,
    ["BorderSizePixel"] = 0
}), 4);
local v8 = r27("Frame", v7, {
    ["Name"] = "IconTile",
    ["Position"] = UDim2.fromOffset(24, 36),
    ["Size"] = UDim2.fromOffset(46, 46),
    ["BackgroundColor3"] = r26.Raised,
    ["BorderSizePixel"] = 0
});
r28(v8, 12);
r29(v8, r26.Edge, 0.25);
r27("TextLabel", v8, {
    ["Name"] = "IconText",
    ["Size"] = UDim2.fromScale(1, 1),
    ["BackgroundTransparency"] = 1,
    ["Font"] = Enum.Font.GothamBold,
    ["Text"] = "KA",
    ["TextColor3"] = r26.Accent,
    ["TextSize"] = 14
});
v5(v7, "Section", "MEMBER AREA", UDim2.fromOffset(84, 39), UDim2.new(1, -108, 0, 14), 9, r26.Accent, true);
v5(v7, "Heading", "Access your panel", UDim2.fromOffset(84, 57), UDim2.new(1, -108, 0, 25), 18, r26.MainText, true);
v5(v7, "Instruction", "Enter your key in the field below.", UDim2.fromOffset(24, 100), UDim2.new(1, -48, 0, 18), 11, r26.SoftText, false);
v5(v7, "FieldCaption", "ACCESS KEY", UDim2.fromOffset(24, 130), UDim2.new(1, -48, 0, 14), 9, r26.SoftText, true);
local v9 = r27("Frame", v7, {
    ["Name"] = "InputShell",
    ["Position"] = UDim2.fromOffset(24, 151),
    ["Size"] = UDim2.new(1, -48, 0, 42),
    ["BackgroundColor3"] = r26.Input,
    ["BorderSizePixel"] = 0
});
r28(v9, 8);
local r32 = r29(v9, r26.Edge, 0);
local r33 = r27("TextBox", v9, {
    ["Name"] = "KeyField",
    ["Position"] = UDim2.fromOffset(12, 0),
    ["Size"] = UDim2.new(1, -24, 1, 0),
    ["BackgroundTransparency"] = 1,
    ["ClearTextOnFocus"] = false,
    ["Font"] = Enum.Font.Gotham,
    ["PlaceholderText"] = "Paste your key...",
    ["PlaceholderColor3"] = r26.SoftText,
    ["Text"] = "",
    ["TextColor3"] = r26.MainText,
    ["TextSize"] = 12,
    ["TextXAlignment"] = Enum.TextXAlignment.Left
});
local v10 = r33.Focused;
v10.Connect(v10, function(...)
    r30(r32, .13, {
        ["Color"] = r26.Accent
    }); 
end);
local v11 = r33.FocusLost;
v11.Connect(v11, function(...)
    r30(r32, .13, {
        ["Color"] = r26.Edge
    }); 
end);
local r34 = r27("Frame", v7, {
    ["Name"] = "StateDot",
    ["Position"] = UDim2.fromOffset(26, 208),
    ["Size"] = UDim2.fromOffset(7, 7),
    ["BackgroundColor3"] = r26.SoftText,
    ["BorderSizePixel"] = 0
});
r28(r34, 5);
local r35 = v5(v7, "StateLabel", "Waiting for key...", UDim2.fromOffset(40, 201), UDim2.new(1, -64, 0, 20), 10, r26.SoftText, false);
local function r36(arg1_7, arg2_7, ...)
    d = arg2_7;
    v2 = r26.SoftText and r26.Okay;
    B = d == true;
    if d == false then
        v2 = r26.Nope;
    end;
    U = r35;
    v3 = arg1_7;
    U.Text = v3;
    U = r35;
    c, v3 = nil, r26.SoftText and r26.Okay;
    U.TextColor3 = v3;
    U = r34;
    U.BackgroundColor3 = v2; 
end;
local function v12(arg1_8, arg2_8, arg3_8, arg4_8, arg5_8, arg6_8, ...)
    v3 = arg6_8;
    if v3 then
        v4 = r26.Accent;
    end;
    r37 = v3 or r26.Raised;
    if v3 then
        Y = r26.AccentHot;
    end;
    B, h = true, v3;
    if v3 then
        r38 = h;
        B = r27;
        if v3 then
            v8 = Color3.fromRGB(40, 18, 29);
        end;
        B = B;
        B = B;
        r39 = B("TextButton", arg1_8, {
            ["Name"] = arg2_8,
            ["Position"] = arg4_8,
            ["Size"] = arg5_8,
            ["BackgroundColor3"] = r37,
            ["BorderSizePixel"] = 0,
            ["AutoButtonColor"] = false,
            ["Font"] = Enum.Font.GothamBold,
            ["Text"] = arg3_8,
            ["TextColor3"] = v3 or r26.MainText,
            ["TextSize"] = 10
        });
        r28(r39, 8);
        B = r29;
        Z = r39;
        m = B;
        if v3 then
            k = r26.Accent;
        end;
        B, J = B, v3;
        if v3 then
            B = B;
            B(p[y], k, 0.25);
            B = r39.MouseEnter;
            B.Connect(B, function(...)
                r30(r39, .12, {
                    ["BackgroundColor3"] = r38
                }); 
            end);
            B = r39.MouseLeave;
            B.Connect(B, function(...)
                r30(r39, .12, {
                    ["BackgroundColor3"] = r37
                }); 
            end);
            return r39;
        else
            J = r26.Edge;
        end;
    else
        h = Color3.fromRGB(47, 46, 64);
    end; 
end;
local r40 = v12(v7, "SubmitButton", "VERIFY KEY", UDim2.new(0.5, 6, 0, 237), UDim2.new(0.5, -30, 0, 38), true);
local v13 = v12(v7, "LinkButton", "SHOW KEY LINK", UDim2.fromOffset(24, 237), UDim2.new(0.5, -30, 0, 38), false).Activated;
v13.Connect(v13, function(...)
    B = r33;
    B.Text = r25.KeyUrl;
    B = r33;
    B.CaptureFocus(B);
    B = r33;
    B.CursorPosition = #r33.Text + 1;
    r36("Select the link and copy it.", true); 
end);
local r41 = false;
local function r42(...)
    if r41 then
        return;
    end;
    if r33.Text ~= r25.DemoKey then
        r36("That key is not valid.", false);
        return;
    end;
    r41 = true;
    h = r40;
    h.Text = "ACCEPTED";
    r36("Key accepted.", true);
    task.wait(.45);
    h = r31.Parent;
    if h then
        h = r31;
        h.Destroy(h);
    end; 
end;
local v14 = r40.Activated;
v14.Connect(v14, r42);
local v15 = r33.FocusLost;
v15.Connect(v15, function(arg1_9, ...)
    if arg1_9 then
        r42();
    end; 
end);
v7.BackgroundTransparency = 1;
v7.Position = UDim2.fromScale(0.5, .56);
r30(v7, .3, {
    ["BackgroundTransparency"] = 0,
    ["Position"] = UDim2.fromScale(0.5, .53)
});