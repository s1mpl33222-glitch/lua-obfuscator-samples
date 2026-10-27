local v8 = {
    ["KEY_LINK"] = "https://scriptix.live",
    ["VALID_KEYS"] = {
        "NEXUS-ABCD-1234-EFGH",
        "TEST-KEY-2025",
        "DEMO-KEY-FREE",
    },
    ["CALLBACK_ON_SUCCESS"] = function()
        print("[NEXUS] Key validated - loading payload...")
    end,
}
local v9 = game:GetService("Players")
local v10 = game:GetService("TweenService")
local v11 = game:GetService("UserInputService")
local v12 = v9.LocalPlayer
local v13 = {
    ["BG_VOID"] = Color3.fromRGB(17 - 12, 1554 - (647 + 902), 12),
    ["BG_PANEL"] = Color3.fromRGB(35 - 23, 247 - (85 + 148), 1315 - (426 + 863)),
    ["BG_CARD"] = Color3.fromRGB(16, 19, 34),
    ["BG_INPUT"] = Color3.fromRGB(8, 46 - 36, 1674 - (873 + 781)),
    ["BORDER_DIM"] = Color3.fromRGB(30, 46 - 11, 148 - 93),
    ["NEON_GREEN"] = Color3.fromRGB(0, 106 + 149, 517 - 377),
    ["NEON_LIME"] = Color3.fromRGB(171 - 51, 255, 201 - 133),
    ["NEON_RED"] = Color3.fromRGB(2202 - (414 + 1533), 44 + 6, 80),
    ["NEON_AMBER"] = Color3.fromRGB(255, 180, 555 - (443 + 112)),
    ["NEON_BLUE"] = Color3.fromRGB(1479 - (888 + 591), 170, 658 - 403),
    ["NEON_WHITE"] = Color3.fromRGB(200, 13 + 207, 790 - 580),
    ["TEXT_BRIGHT"] = Color3.fromRGB(210, 90 + 140, 107 + 113),
    ["TEXT_MID"] = Color3.fromRGB(13 + 107, 266 - 126, 130),
    ["TEXT_DIM"] = Color3.fromRGB(101 - 46, 1748 - (136 + 1542), 213 - 148),
    ["TEXT_MONO"] = Color3.fromRGB(0 + 0, 318 - 118, 80 + 30),
    ["SUCCESS"] = Color3.fromRGB(486 - (68 + 418), 691 - 436, 254 - 114),
    ["ERROR"] = Color3.fromRGB(221 + 34, 1142 - (770 + 322), 80),
}
local function v14(v75, v76, v77, v78, v79)
    local v80 = 0 + 0
    local v81
    while true do
        if (0 + 0) == v80 then
            v81 = v10:Create(
                v75,
                TweenInfo.new(v77 or (0.3 + 0), v78 or Enum.EasingStyle.Quint, v79 or Enum.EasingDirection.Out),
                v76
            )
            v81:Play()
            v80 = 1 - 0
            break
        end
        if v80 == (1 - 0) then
            return v81
        end
    end
end
local function v15(v82, v83)
    local v84 = 0 - 0
    local v85
    while true do
        if v84 == 0 then
            v85 = Instance.new(v82)
            for v188, v189 in pairs(v83 or {}) do
                if v188 ~= "Parent" then
                    pcall(function()
                        v85[v188] = v189
                    end)
                end
            end
            v84 = 3 - 2
        end
        if v84 == (1 + 0) then
            local v175 = 0 - 0
            while true do
                if v175 == (0 + 0) then
                    if v83 and v83.Parent then
                        v85.Parent = v83.Parent
                    end
                    return v85
                end
            end
        end
    end
end
local function v16(v86, v87)
    return v15("UICorner", {
        ["CornerRadius"] = UDim.new(0 + 0, v87 or (5 + 1)),
        ["Parent"] = v86,
    })
end
local function v17(v88, v89, v90, v91)
    return v15("UIStroke", {
        ["Color"] = v89 or v13.BORDER_DIM,
        ["Thickness"] = v90 or (3 - 2),
        ["Transparency"] = v91 or (0 - 0),
        ["Parent"] = v88,
    })
end
local function v18(v92, v93, v94, v95)
    local v96 = 0 + 0
    while true do
        if v96 == 1 then
            for v190 = 4 - 3, #v93 do
                local v191 = 0 - 0
                while true do
                    if v191 == 0 then
                        if not v92 or not v92.Parent then
                            return
                        end
                        v92.Text = v93:sub(1, v190)
                        v191 = 1 + 0
                    end
                    if v191 == (4 - 3) then
                        task.wait(v94 or (831.02 - (762 + 69)))
                        break
                    end
                end
            end
            break
        end
        if v96 == (0 - 0) then
            v92.Text = ""
            if v95 then
                v92.TextColor3 = v95
            end
            v96 = 1 + 0
        end
    end
end
local function v19(v97, v98)
    local v99 = 0 + 0
    while true do
        if v99 == (0 - 0) then
            local v177 = 0
            while true do
                if v177 == 0 then
                    if v97 >= v98 then
                        return v97
                    end
                    return math.random(v97, v98)
                end
            end
        end
    end
end
local function v20()
    local v100 = 0
    local v101
    local v102
    while true do
        if v100 == (0 + 0) then
            v101 = "0123456789ABCDEF"
            v102 = ""
            v100 = 1
        end
        if v100 == (1 + 0) then
            for v192 = 1, 31 - 23 do
                local v193 = 157 - (8 + 149)
                local v194
                while true do
                    if v193 == 0 then
                        v194 = math.random(1, #v101)
                        v102 = v102 .. v101:sub(v194, v194)
                        break
                    end
                end
            end
            return v102
        end
    end
end
pcall(function()
    if game:GetService("CoreGui"):FindFirstChild("NexusKeySystem") then
        game:GetService("CoreGui"):FindFirstChild("NexusKeySystem"):Destroy()
    end
end)
pcall(function()
    if v12:FindFirstChild("PlayerGui") and v12.PlayerGui:FindFirstChild("NexusKeySystem") then
        v12.PlayerGui.NexusKeySystem:Destroy()
    end
end)
local v21 = v15("ScreenGui", {
    ["Name"] = "NexusKeySystem",
    ["DisplayOrder"] = 2319 - (1199 + 121),
    ["IgnoreGuiInset"] = true,
    ["ResetOnSpawn"] = false,
    ["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling,
})
local v22 = pcall(function()
    v21.Parent = game:GetService("CoreGui")
end)
if not v22 then
    v21.Parent = v12:WaitForChild("PlayerGui")
end
local v23 = v15("Frame", {
    ["Name"] = "Backdrop",
    ["Size"] = UDim2.new(1 - 0, 0, 2 - 1, 0),
    ["Position"] = UDim2.new(0 + 0, 0 - 0, 0, 0),
    ["BackgroundColor3"] = v13.BG_VOID,
    ["BackgroundTransparency"] = 0.2 - 0,
    ["BorderSizePixel"] = 0 + 0,
    ["ZIndex"] = 1808 - (518 + 1289),
    ["Parent"] = v21,
})
local v24 = v15("Frame", {
    ["Name"] = "ScanBeam",
    ["Size"] = UDim2.new(1 - 0, 0 + 0, 0 - 0, 45 + 15),
    ["Position"] = UDim2.new(469 - (304 + 165), 0 + 0, -(160.1 - (54 + 106)), 1969 - (1618 + 351)),
    ["BackgroundColor3"] = v13.NEON_GREEN,
    ["BackgroundTransparency"] = 0.95 + 0,
    ["BorderSizePixel"] = 1016 - (10 + 1006),
    ["ZIndex"] = 1 + 1,
    ["Parent"] = v23,
})
task.spawn(function()
    while v21 and v21.Parent do
        local v156 = 0 + 0
        local v157
        while true do
            if (0 - 0) == v156 then
                v157 = 1033 - (912 + 121)
                while true do
                    if v157 == 0 then
                        v24.Position = UDim2.new(0 + 0, 1289 - (1140 + 149), -0.1, 0 + 0)
                        v14(v24, {
                            ["Position"] = UDim2.new(0 - 0, 0, 1.1, 0 + 0),
                        }, 13 - 9, Enum.EasingStyle.Linear)
                        v157 = 1
                    end
                    if 1 == v157 then
                        task.wait(5)
                        break
                    end
                end
                break
            end
        end
    end
end)
local v25 = v15("Frame", {
    ["Name"] = "Window",
    ["Size"] = UDim2.new(0 - 0, 70 + 330, 0, 480),
    ["Position"] = UDim2.new(0.5, -(694 - 494), 0.5, -240),
    ["BackgroundColor3"] = v13.BG_PANEL,
    ["BackgroundTransparency"] = 186 - (165 + 21),
    ["BorderSizePixel"] = 111 - (61 + 50),
    ["ZIndex"] = 10,
    ["Parent"] = v21,
})
v16(v25, 3 + 3)
local v26 = v17(v25, v13.NEON_GREEN, 1, 0.5 - 0)
local v27 = v15("Frame", {
    ["Name"] = "TitleBar",
    ["Size"] = UDim2.new(1 - 0, 0 + 0, 1460 - (1295 + 165), 10 + 30),
    ["Position"] = UDim2.new(0 + 0, 1397 - (819 + 578), 1402 - (331 + 1071), 0),
    ["BackgroundColor3"] = Color3.fromRGB(8, 753 - (588 + 155), 1300 - (546 + 736)),
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["ZIndex"] = 1957 - (1834 + 103),
    ["Parent"] = v25,
})
v16(v27, 6)
v15("Frame", {
    ["Name"] = "TitleBarFix",
    ["Size"] = UDim2.new(1, 0 + 0, 0 - 0, 1776 - (1536 + 230)),
    ["Position"] = UDim2.new(491 - (128 + 363), 0 + 0, 1, -10),
    ["BackgroundColor3"] = Color3.fromRGB(8, 24 - 14, 5 + 13),
    ["BackgroundTransparency"] = 0 - 0,
    ["BorderSizePixel"] = 0 - 0,
    ["ZIndex"] = 48 - 28,
    ["Parent"] = v27,
})
v15("Frame", {
    ["Name"] = "BottomLine",
    ["Size"] = UDim2.new(1 + 0, 1009 - (615 + 394), 0 + 0, 1),
    ["Position"] = UDim2.new(0 + 0, 0 - 0, 4 - 3, -(652 - (59 + 592))),
    ["BackgroundColor3"] = v13.NEON_GREEN,
    ["BackgroundTransparency"] = 0.5 - 0,
    ["BorderSizePixel"] = 0 - 0,
    ["ZIndex"] = 21,
    ["Parent"] = v27,
})
local v28 = {
    v13.NEON_RED,
    v13.NEON_AMBER,
    v13.NEON_GREEN,
}
for v104, v105 in ipairs(v28) do
    local v106 = 171 - (70 + 101)
    local v107
    while true do
        if v106 == 0 then
            v107 = v15("Frame", {
                ["Name"] = "Dot" .. v104,
                ["Size"] = UDim2.new(0 - 0, 9 + 3, 0, 12),
                ["Position"] = UDim2.new(0 - 0, 12 + ((v104 - 1) * 20), 241.5 - (123 + 118), -6),
                ["BackgroundColor3"] = v105,
                ["BackgroundTransparency"] = 0.2,
                ["BorderSizePixel"] = 0,
                ["ZIndex"] = 6 + 16,
                ["Parent"] = v27,
            })
            v16(v107, 6)
            break
        end
    end
end
v15("TextLabel", {
    ["Name"] = "TitleText",
    ["Size"] = UDim2.new(1 + 0, -(1539 - (653 + 746)), 1, 0 - 0),
    ["Position"] = UDim2.new(0 - 0, 214 - 134, 0 + 0, 0),
    ["BackgroundTransparency"] = 1 + 0,
    ["Text"] = "⚡ NEXUS // KEY_AUTH",
    ["TextSize"] = 13 + 1,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_GREEN,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["ZIndex"] = 3 + 19,
    ["Parent"] = v27,
})
local v29 = v15("TextButton", {
    ["Name"] = "CloseBtn",
    ["Size"] = UDim2.new(0 + 0, 73 - 43, 0 + 0, 30),
    ["Position"] = UDim2.new(1 - 0, -38, 1234.5 - (885 + 349), -(12 + 3)),
    ["BackgroundColor3"] = v13.NEON_RED,
    ["BackgroundTransparency"] = 0.8 - 0,
    ["BorderSizePixel"] = 0,
    ["Text"] = "×",
    ["TextColor3"] = v13.NEON_RED,
    ["TextSize"] = 20,
    ["Font"] = Enum.Font.Code,
    ["AutoButtonColor"] = false,
    ["ZIndex"] = 22,
    ["Parent"] = v27,
})
v16(v29, 11 - 7)
v29.MouseEnter:Connect(function()
    v14(v29, {
        ["BackgroundTransparency"] = 0.3,
        ["TextColor3"] = Color3.fromRGB(1223 - (915 + 53), 1056 - (768 + 33), 976 - 721),
    }, 0.15 - 0)
end)
v29.MouseLeave:Connect(function()
    v14(v29, {
        ["BackgroundTransparency"] = 328.8 - (287 + 41),
        ["TextColor3"] = v13.NEON_RED,
    }, 847.15 - (638 + 209))
end)
v29.MouseButton1Click:Connect(function()
    local v108 = 0
    local v109
    while true do
        if v108 == 0 then
            v109 = 0 + 0
            while true do
                if v109 == (1686 - (96 + 1590)) then
                    v14(v25, {
                        ["Size"] = UDim2.new(1672 - (741 + 931), 197 + 203, 0 - 0, 46 - 36),
                    }, 0.3, Enum.EasingStyle.Quint)
                    v14(v23, {
                        ["BackgroundTransparency"] = 1 + 0,
                    }, 0.3 + 0)
                    v109 = 1 + 0
                end
                if v109 == 1 then
                    task.wait(0.35 - 0)
                    v21:Destroy()
                    break
                end
            end
            break
        end
    end
end)
local v30 = false
local v31, v32, v33
v27.InputBegan:Connect(function(v110)
    if (v110.UserInputType == Enum.UserInputType.MouseButton1) or (v110.UserInputType == Enum.UserInputType.Touch) then
        local v163 = 0 + 0
        while true do
            if 1 == v163 then
                v33 = v25.Position
                v110.Changed:Connect(function()
                    if v110.UserInputState == Enum.UserInputState.End then
                        v30 = false
                    end
                end)
                break
            end
            if v163 == (0 + 0) then
                v30 = true
                v32 = v110.Position
                v163 = 1
            end
        end
    end
end)
v27.InputChanged:Connect(function(v111)
    if (v111.UserInputType == Enum.UserInputType.MouseMovement) or (v111.UserInputType == Enum.UserInputType.Touch) then
        v31 = v111
    end
end)
v11.InputChanged:Connect(function(v112)
    if (v112 == v31) and v30 then
        local v164 = 0 - 0
        local v165
        while true do
            if v164 == (0 + 0) then
                v165 = v112.Position - v32
                v25.Position = UDim2.new(v33.X.Scale, v33.X.Offset + v165.X, v33.Y.Scale, v33.Y.Offset + v165.Y)
                break
            end
        end
    end
end)
local v34 = v15("Frame", {
    ["Name"] = "Content",
    ["Size"] = UDim2.new(495 - (64 + 430), 0, 1 + 0, -40),
    ["Position"] = UDim2.new(363 - (106 + 257), 0 + 0, 721 - (496 + 225), 81 - 41),
    ["BackgroundColor3"] = v13.BG_PANEL,
    ["BackgroundTransparency"] = 0 - 0,
    ["BorderSizePixel"] = 1658 - (256 + 1402),
    ["ClipsDescendants"] = true,
    ["ZIndex"] = 1910 - (30 + 1869),
    ["Parent"] = v25,
})
local v35 = v15("Frame", {
    ["Name"] = "P1",
    ["Size"] = UDim2.new(1370 - (213 + 1156), -40, 1, -(228 - (96 + 92))),
    ["Position"] = UDim2.new(0 + 0, 919 - (142 + 757), 0 + 0, 20),
    ["BackgroundTransparency"] = 1,
    ["ZIndex"] = 5 + 7,
    ["Parent"] = v34,
})
local v36 = v15("Frame", {
    ["Name"] = "TermLog",
    ["Size"] = UDim2.new(80 - (32 + 47), 1977 - (1053 + 924), 0 + 0, 163 - 68),
    ["Position"] = UDim2.new(1648 - (685 + 963), 0 - 0, 0, 0 - 0),
    ["BackgroundColor3"] = v13.BG_INPUT,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["ZIndex"] = 13,
    ["Parent"] = v35,
})
v16(v36, 4)
v17(v36, v13.BORDER_DIM, 1710 - (541 + 1168), 1597.3 - (645 + 952))
local v37 = v15("Frame", {
    ["Name"] = "Inner",
    ["Size"] = UDim2.new(1, -(858 - (669 + 169)), 1, -(55 - 39)),
    ["Position"] = UDim2.new(0, 21 - 11, 0 + 0, 2 + 6),
    ["BackgroundTransparency"] = 766 - (181 + 584),
    ["ZIndex"] = 1409 - (665 + 730),
    ["Parent"] = v36,
})
v15("UIListLayout", {
    ["SortOrder"] = Enum.SortOrder.LayoutOrder,
    ["Padding"] = UDim.new(0 - 0, 3),
    ["Parent"] = v37,
})
local function v38(v113, v114, v115)
    local v116 = 0
    local v117
    while true do
        if v116 == (0 - 0) then
            v117 = v15("TextLabel", {
                ["Name"] = "Log" .. (v115 or 0),
                ["Size"] = UDim2.new(1351 - (540 + 810), 0 - 0, 0 - 0, 14),
                ["BackgroundTransparency"] = 1 + 0,
                ["Text"] = v113 or "",
                ["TextSize"] = 11,
                ["Font"] = Enum.Font.Code,
                ["TextColor3"] = v114 or v13.TEXT_MONO,
                ["TextXAlignment"] = Enum.TextXAlignment.Left,
                ["LayoutOrder"] = v115 or (203 - (166 + 37)),
                ["ZIndex"] = 15,
                ["Parent"] = v37,
            })
            return v117
        end
    end
end
local v39 = v15("Frame", {
    ["Name"] = "StatusRow",
    ["Size"] = UDim2.new(1882 - (22 + 1859), 1772 - (843 + 929), 262 - (30 + 232), 157 - 102),
    ["Position"] = UDim2.new(777 - (55 + 722), 0, 0, 103),
    ["BackgroundTransparency"] = 1 - 0,
    ["ZIndex"] = 1688 - (78 + 1597),
    ["Parent"] = v35,
})
local v40 = v15("Frame", {
    ["Name"] = "StatusPanel",
    ["Size"] = UDim2.new(0.48 + 0, 0 + 0, 1 + 0, 0),
    ["Position"] = UDim2.new(549 - (305 + 244), 0, 0, 0),
    ["BackgroundColor3"] = v13.BG_INPUT,
    ["BackgroundTransparency"] = 0 + 0,
    ["BorderSizePixel"] = 105 - (95 + 10),
    ["ZIndex"] = 14,
    ["Parent"] = v39,
})
v16(v40, 4)
v17(v40, v13.BORDER_DIM, 1 + 0, 0.5 - 0)
local v41 = v15("TextLabel", {
    ["Name"] = "Label",
    ["Size"] = UDim2.new(1, -(18 - 4), 763 - (592 + 170), -(34 - 24)),
    ["Position"] = UDim2.new(0 - 0, 4 + 3, 0, 5),
    ["BackgroundTransparency"] = 1 + 0,
    ["Text"] = "STATUS\n─────────\nAWAITING INPUT",
    ["TextSize"] = 10,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_AMBER,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["TextYAlignment"] = Enum.TextYAlignment.Top,
    ["ZIndex"] = 36 - 21,
    ["Parent"] = v40,
})
local v42 = v15("Frame", {
    ["Name"] = "SessionPanel",
    ["Size"] = UDim2.new(0.48, 0 + 0, 1 - 0, 507 - (353 + 154)),
    ["Position"] = UDim2.new(0.52 - 0, 0, 0 - 0, 0 + 0),
    ["BackgroundColor3"] = v13.BG_INPUT,
    ["BackgroundTransparency"] = 0 + 0,
    ["BorderSizePixel"] = 0,
    ["ZIndex"] = 10 + 4,
    ["Parent"] = v39,
})
v16(v42, 5 - 1)
v17(v42, v13.BORDER_DIM, 1, 0.5 - 0)
v15("TextLabel", {
    ["Name"] = "Label",
    ["Size"] = UDim2.new(2 - 1, -14, 1, -(96 - (7 + 79))),
    ["Position"] = UDim2.new(0 + 0, 7, 181 - (24 + 157), 5),
    ["BackgroundTransparency"] = 1 - 0,
    ["Text"] = "SESSION\n─────────\n" .. v20(),
    ["TextSize"] = 21 - 11,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_DIM,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["TextYAlignment"] = Enum.TextYAlignment.Top,
    ["ZIndex"] = 5 + 10,
    ["Parent"] = v42,
})
v15("TextLabel", {
    ["Name"] = "Divider",
    ["Size"] = UDim2.new(2 - 1, 380 - (262 + 118), 1083 - (1038 + 45), 16),
    ["Position"] = UDim2.new(0 - 0, 230 - (19 + 211), 113 - (88 + 25), 427 - 259),
    ["BackgroundTransparency"] = 1 + 0,
    ["Text"] = "── ENTER AUTHORIZATION KEY ──",
    ["TextSize"] = 10,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_DIM,
    ["ZIndex"] = 13 + 0,
    ["Parent"] = v35,
})
local v43 = v15("Frame", {
    ["Name"] = "InputWrap",
    ["Size"] = UDim2.new(1037 - (1007 + 29), 0, 0 + 0, 102 - 60),
    ["Position"] = UDim2.new(0 - 0, 0 + 0, 811 - (340 + 471), 483 - 291),
    ["BackgroundColor3"] = v13.BG_INPUT,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 589 - (276 + 313),
    ["ZIndex"] = 13,
    ["Parent"] = v35,
})
v16(v43, 9 - 5)
local v44 = v17(v43, v13.BORDER_DIM, 1, 0.2 + 0)
v15("TextLabel", {
    ["Name"] = "Prefix",
    ["Size"] = UDim2.new(0, 12 + 16, 1 + 0, 1972 - (495 + 1477)),
    ["Position"] = UDim2.new(0 - 0, 6 + 2, 403 - (342 + 61), 0 + 0),
    ["BackgroundTransparency"] = 1,
    ["Text"] = ">>",
    ["TextSize"] = 179 - (4 + 161),
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_GREEN,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["ZIndex"] = 9 + 5,
    ["Parent"] = v43,
})
local v45 = v15("TextBox", {
    ["Name"] = "KeyInput",
    ["Size"] = UDim2.new(3 - 2, -48, 2 - 1, 497 - (322 + 175)),
    ["Position"] = UDim2.new(0, 601 - (173 + 390), 0 + 0, 314 - (203 + 111)),
    ["BackgroundTransparency"] = 1 + 0,
    ["Text"] = "",
    ["PlaceholderText"] = "KEY_XXXX-XXXX-XXXX-XXXX",
    ["PlaceholderColor3"] = v13.TEXT_DIM,
    ["TextColor3"] = v13.NEON_GREEN,
    ["TextSize"] = 10 + 4,
    ["Font"] = Enum.Font.Code,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["ClearTextOnFocus"] = false,
    ["ZIndex"] = 40 - 26,
    ["Parent"] = v43,
})
v45.Focused:Connect(function()
    v14(v44, {
        ["Color"] = v13.NEON_GREEN,
        ["Transparency"] = 0 + 0,
    }, 706.15 - (57 + 649))
end)
v45.FocusLost:Connect(function()
    v14(v44, {
        ["Color"] = v13.BORDER_DIM,
        ["Transparency"] = 0.2,
    }, 0.2)
end)
local v46 = v15("TextLabel", {
    ["Name"] = "StatusMsg",
    ["Size"] = UDim2.new(385 - (328 + 56), 0 + 0, 0, 18),
    ["Position"] = UDim2.new(0, 512 - (433 + 79), 0 + 0, 194 + 46),
    ["BackgroundTransparency"] = 3 - 2,
    ["Text"] = "",
    ["TextSize"] = 51 - 40,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_MID,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["TextTransparency"] = 1,
    ["ZIndex"] = 10 + 3,
    ["Parent"] = v35,
})
local function v47(v118, v119, v120)
    local v121 = 0 + 0
    local v122
    while true do
        if v121 == (1036 - (562 + 474)) then
            v122 = 0 - 0
            while true do
                if v122 == 1 then
                    v14(v46, {
                        ["TextTransparency"] = 0,
                    }, 0.15 - 0)
                    if v120 then
                        task.delay(v120, function()
                            if v46 and v46.Parent then
                                v14(v46, {
                                    ["TextTransparency"] = 1,
                                }, 905.5 - (76 + 829))
                            end
                        end)
                    end
                    break
                end
                if (1673 - (1506 + 167)) == v122 then
                    v46.Text = v118
                    v46.TextColor3 = v119 or v13.TEXT_MID
                    v122 = 1
                end
            end
            break
        end
    end
end
local v48 = v15("Frame", {
    ["Name"] = "BtnRow",
    ["Size"] = UDim2.new(1 - 0, 266 - (58 + 208), 0 + 0, 44),
    ["Position"] = UDim2.new(0 + 0, 0 + 0, 0, 266),
    ["BackgroundTransparency"] = 3 - 2,
    ["ZIndex"] = 13,
    ["Parent"] = v35,
})
local v49 = v15("TextButton", {
    ["Name"] = "SubmitBtn",
    ["Size"] = UDim2.new(0.56, -(341 - (258 + 79)), 1 + 0, 0 - 0),
    ["Position"] = UDim2.new(1470 - (1219 + 251), 1671 - (1231 + 440), 58 - (34 + 24), 0 + 0),
    ["BackgroundColor3"] = Color3.fromRGB(0 - 0, 18 + 22, 22),
    ["BackgroundTransparency"] = 0 - 0,
    ["BorderSizePixel"] = 0,
    ["Text"] = "[ VERIFY KEY ]",
    ["TextSize"] = 14,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_GREEN,
    ["AutoButtonColor"] = false,
    ["ZIndex"] = 44 - 30,
    ["Parent"] = v48,
})
v16(v49, 10 - 6)
local v50 = v17(v49, v13.NEON_GREEN, 3 - 2, 0.3)
v49.MouseEnter:Connect(function()
    local v123 = 0 - 0
    while true do
        if v123 == (1589 - (877 + 712)) then
            v14(v49, {
                ["BackgroundColor3"] = Color3.fromRGB(0 + 0, 814 - (242 + 512), 73 - 38),
            }, 0.15)
            v14(v50, {
                ["Transparency"] = 627 - (92 + 535),
            }, 0.15)
            break
        end
    end
end)
v49.MouseLeave:Connect(function()
    local v124 = 0 + 0
    local v125
    while true do
        if v124 == (0 - 0) then
            v125 = 0 + 0
            while true do
                if v125 == (0 - 0) then
                    v14(v49, {
                        ["BackgroundColor3"] = Color3.fromRGB(0, 40 + 0, 22),
                    }, 0.15)
                    v14(v50, {
                        ["Transparency"] = 0.3,
                    }, 0.15 + 0)
                    break
                end
            end
            break
        end
    end
end)
local v51 = v15("TextButton", {
    ["Name"] = "GetKeyBtn",
    ["Size"] = UDim2.new(0.44, -(1 + 3), 1 - 0, 0 - 0),
    ["Position"] = UDim2.new(1785.56 - (1476 + 309), 4, 0, 1284 - (299 + 985)),
    ["BackgroundColor3"] = Color3.fromRGB(0, 25, 11 + 34),
    ["BackgroundTransparency"] = 0 - 0,
    ["BorderSizePixel"] = 0,
    ["Text"] = "[ GET KEY ]",
    ["TextSize"] = 14,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_BLUE,
    ["AutoButtonColor"] = false,
    ["ZIndex"] = 14,
    ["Parent"] = v48,
})
v16(v51, 4)
local v52 = v17(v51, v13.NEON_BLUE, 94 - (86 + 7), 0.3)
v51.MouseEnter:Connect(function()
    local v126 = 0 - 0
    while true do
        if v126 == (0 + 0) then
            v14(v51, {
                ["BackgroundColor3"] = Color3.fromRGB(0, 920 - (672 + 208), 65),
            }, 0.15)
            v14(v52, {
                ["Transparency"] = 0,
            }, 0.15 + 0)
            break
        end
    end
end)
v51.MouseLeave:Connect(function()
    local v127 = 0
    while true do
        if v127 == 0 then
            v14(v51, {
                ["BackgroundColor3"] = Color3.fromRGB(132 - (14 + 118), 470 - (339 + 106), 36 + 9),
            }, 0.15)
            v14(v52, {
                ["Transparency"] = 0.3,
            }, 0.15)
            break
        end
    end
end)
local v53 = v15("Frame", {
    ["Name"] = "ProgressWrap",
    ["Size"] = UDim2.new(1 + 0, 1395 - (440 + 955), 0 + 0, 10 - 4),
    ["Position"] = UDim2.new(0 + 0, 0, 0, 796 - 476),
    ["BackgroundColor3"] = v13.BORDER_DIM,
    ["BackgroundTransparency"] = 0 + 0,
    ["BorderSizePixel"] = 0,
    ["Visible"] = false,
    ["ZIndex"] = 366 - (260 + 93),
    ["Parent"] = v35,
})
v16(v53, 3 + 0)
local v54 = v15("Frame", {
    ["Name"] = "Fill",
    ["Size"] = UDim2.new(0 - 0, 0 - 0, 1975 - (1181 + 793), 0 + 0),
    ["BackgroundColor3"] = v13.NEON_GREEN,
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["ZIndex"] = 321 - (105 + 202),
    ["Parent"] = v53,
})
v16(v54, 3 + 0)
local v55 = v15("TextLabel", {
    ["Name"] = "Footer",
    ["Size"] = UDim2.new(811 - (352 + 458), 0 - 0, 0 - 0, 14 + 0),
    ["Position"] = UDim2.new(0 - 0, 949 - (438 + 511), 1384 - (1262 + 121), -(1088 - (728 + 340))),
    ["BackgroundTransparency"] = 1791 - (816 + 974),
    ["Text"] = "NEXUS v2.0 | SECURE",
    ["TextSize"] = 27 - 18,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_DIM,
    ["ZIndex"] = 46 - 33,
    ["Parent"] = v35,
})
task.spawn(function()
    while v21 and v21.Parent do
        local v158 = 0
        while true do
            if 0 == v158 then
                if v55 and v55.Parent then
                    v55.Text = "NEXUS v2.0 | " .. os.date("%H:%M:%S") .. " | SECURE"
                end
                task.wait(1)
                break
            end
        end
    end
end)
local v56 = v15("Frame", {
    ["Name"] = "P2",
    ["Size"] = UDim2.new(1, -(379 - (163 + 176)), 1, -40),
    ["Position"] = UDim2.new(1.2, 0 - 0, 0 - 0, 7 + 13),
    ["BackgroundTransparency"] = 1811 - (1564 + 246),
    ["ZIndex"] = 12,
    ["Visible"] = false,
    ["Parent"] = v34,
})
v15("TextLabel", {
    ["Name"] = "Header",
    ["Size"] = UDim2.new(1, 0, 345 - (124 + 221), 16 + 6),
    ["Position"] = UDim2.new(0, 0, 0, 451 - (115 + 336)),
    ["BackgroundTransparency"] = 1 - 0,
    ["Text"] = "⚡ KEY ACQUISITION PROTOCOL",
    ["TextSize"] = 3 + 11,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_BLUE,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["ZIndex"] = 13,
    ["Parent"] = v56,
})
v15("Frame", {
    ["Size"] = UDim2.new(47 - (45 + 1), 0, 0 + 0, 1991 - (1282 + 708)),
    ["Position"] = UDim2.new(1212 - (583 + 629), 0 + 0, 0 - 0, 15 + 13),
    ["BackgroundColor3"] = v13.NEON_BLUE,
    ["BackgroundTransparency"] = 1170.5 - (943 + 227),
    ["BorderSizePixel"] = 0 + 0,
    ["ZIndex"] = 13,
    ["Parent"] = v56,
})
local v57 = v15("Frame", {
    ["Name"] = "StepsList",
    ["Size"] = UDim2.new(1, 1631 - (1539 + 92), 0, 2176 - (706 + 1240)),
    ["Position"] = UDim2.new(258 - (81 + 177), 0 - 0, 0, 295 - (212 + 45)),
    ["BackgroundTransparency"] = 1,
    ["ZIndex"] = 43 - 30,
    ["Parent"] = v56,
})
v15("UIListLayout", {
    ["SortOrder"] = Enum.SortOrder.LayoutOrder,
    ["Padding"] = UDim.new(1946 - (708 + 1238), 1 + 4),
    ["Parent"] = v57,
})
local v58 = {
    {
        ["idx"] = "01",
        ["text"] = "Click [ COPY LINK ] below to copy URL",
        ["col"] = v13.NEON_GREEN,
    },
    {
        ["idx"] = "02",
        ["text"] = "Open any web browser on your device",
        ["col"] = v13.NEON_GREEN,
    },
    {
        ["idx"] = "03",
        ["text"] = "Paste URL into address bar and press ENTER",
        ["col"] = v13.NEON_GREEN,
    },
    {
        ["idx"] = "04",
        ["text"] = "Download software for key generation",
        ["col"] = v13.NEON_AMBER,
    },
    {
        ["idx"] = "05",
        ["text"] = "Copy the generated key from the software",
        ["col"] = v13.NEON_AMBER,
    },
    {
        ["idx"] = "06",
        ["text"] = "Return here and paste key then [ VERIFY ]",
        ["col"] = v13.NEON_BLUE,
    },
}
for v128, v129 in ipairs(v58) do
    local v130 = 0 - 0
    local v131
    local v132
    while true do
        if v130 == (1861 - (1541 + 318)) then
            v15("TextLabel", {
                ["Size"] = UDim2.new(1 + 0, 0, 1, 0 + 0),
                ["BackgroundTransparency"] = 1 + 0,
                ["Text"] = v129.idx,
                ["TextSize"] = 1762 - (1036 + 714),
                ["Font"] = Enum.Font.Code,
                ["TextColor3"] = v129.col,
                ["ZIndex"] = 16,
                ["Parent"] = v132,
            })
            v15("TextLabel", {
                ["Size"] = UDim2.new(1, -46, 1 + 0, 0),
                ["Position"] = UDim2.new(0, 23 + 17, 0, 1280 - (883 + 397)),
                ["BackgroundTransparency"] = 591 - (563 + 27),
                ["Text"] = v129.text,
                ["TextSize"] = 43 - 32,
                ["Font"] = Enum.Font.Code,
                ["TextColor3"] = v13.TEXT_BRIGHT,
                ["TextXAlignment"] = Enum.TextXAlignment.Left,
                ["TextWrapped"] = true,
                ["ZIndex"] = 2001 - (1369 + 617),
                ["Parent"] = v131,
            })
            break
        end
        if v130 == 1 then
            local v178 = 1487 - (85 + 1402)
            while true do
                if v178 == 0 then
                    v132 = v15("Frame", {
                        ["Name"] = "Badge",
                        ["Size"] = UDim2.new(0 + 0, 82 - 50, 403 - (274 + 129), 251 - (12 + 205)),
                        ["Position"] = UDim2.new(0, 0 + 0, 0, 0 - 0),
                        ["BackgroundColor3"] = v129.col,
                        ["BackgroundTransparency"] = 0.8 + 0,
                        ["BorderSizePixel"] = 384 - (27 + 357),
                        ["ZIndex"] = 495 - (91 + 389),
                        ["Parent"] = v131,
                    })
                    v16(v132, 301 - (90 + 207))
                    v178 = 1 + 0
                end
                if v178 == (862 - (706 + 155)) then
                    v130 = 1797 - (730 + 1065)
                    break
                end
            end
        end
        if v130 == 0 then
            v131 = v15("Frame", {
                ["Name"] = "Step" .. v128,
                ["Size"] = UDim2.new(1564 - (1339 + 224), 0 + 0, 0 + 0, 49 - 15),
                ["BackgroundColor3"] = v13.BG_INPUT,
                ["BackgroundTransparency"] = 843 - (268 + 575),
                ["BorderSizePixel"] = 0,
                ["LayoutOrder"] = v128,
                ["ZIndex"] = 1308 - (919 + 375),
                ["Parent"] = v57,
            })
            v16(v131, 10 - 6)
            v130 = 972 - (180 + 791)
        end
    end
end
local v59 = v15("TextButton", {
    ["Name"] = "CopyBtn",
    ["Size"] = UDim2.new(1, 1805 - (323 + 1482), 1918 - (1177 + 741), 3 + 41),
    ["Position"] = UDim2.new(0 - 0, 0, 0 + 0, 278),
    ["BackgroundColor3"] = Color3.fromRGB(0 - 0, 4 + 36, 131 - (96 + 13)),
    ["BackgroundTransparency"] = 1921 - (962 + 959),
    ["BorderSizePixel"] = 0 - 0,
    ["Text"] = "📋  [ COPY LINK ]",
    ["TextSize"] = 14,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_GREEN,
    ["AutoButtonColor"] = false,
    ["ZIndex"] = 3 + 11,
    ["Parent"] = v56,
})
v16(v59, 1355 - (461 + 890))
local v60 = v17(v59, v13.NEON_GREEN, 1 + 0, 0.2)
v59.MouseEnter:Connect(function()
    local v133 = 0 - 0
    while true do
        if v133 == (243 - (19 + 224)) then
            v14(v59, {
                ["BackgroundColor3"] = Color3.fromRGB(0, 55 + 5, 35),
            }, 198.15 - (37 + 161))
            v14(v60, {
                ["Transparency"] = 0 + 0,
            }, 0.15)
            break
        end
    end
end)
v59.MouseLeave:Connect(function()
    local v134 = 0
    local v135
    while true do
        if v134 == 0 then
            v135 = 0 + 0
            while true do
                if v135 == (0 + 0) then
                    v14(v59, {
                        ["BackgroundColor3"] = Color3.fromRGB(61 - (60 + 1), 40, 22),
                    }, 923.15 - (826 + 97))
                    v14(v60, {
                        ["Transparency"] = 0.2 + 0,
                    }, 0.15 - 0)
                    break
                end
            end
            break
        end
    end
end)
local v61 = v15("TextLabel", {
    ["Name"] = "CopyConfirm",
    ["Size"] = UDim2.new(1, 0 - 0, 685 - (375 + 310), 2015 - (1864 + 135)),
    ["Position"] = UDim2.new(0 - 0, 0, 0, 73 + 253),
    ["BackgroundTransparency"] = 1 + 0,
    ["Text"] = "✓ LINK COPIED TO CLIPBOARD",
    ["TextSize"] = 10,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.SUCCESS,
    ["TextTransparency"] = 2 - 1,
    ["ZIndex"] = 1145 - (314 + 817),
    ["Parent"] = v56,
})
local v62 = v15("TextButton", {
    ["Name"] = "BackBtn",
    ["Size"] = UDim2.new(1 + 0, 214 - (32 + 182), 0 + 0, 125 - 89),
    ["Position"] = UDim2.new(65 - (39 + 26), 144 - (54 + 90), 0, 348),
    ["BackgroundColor3"] = Color3.fromRGB(218 - (45 + 153), 14 + 8, 590 - (457 + 95)),
    ["BackgroundTransparency"] = 0,
    ["BorderSizePixel"] = 0,
    ["Text"] = "← RETURN TO AUTH",
    ["TextSize"] = 12,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_MID,
    ["AutoButtonColor"] = false,
    ["ZIndex"] = 14 + 0,
    ["Parent"] = v56,
})
v16(v62, 4)
v17(v62, v13.BORDER_DIM, 1 - 0, 0.4 - 0)
v62.MouseEnter:Connect(function()
    v14(v62, {
        ["BackgroundColor3"] = Color3.fromRGB(108 - 78, 15 + 18, 189 - 134),
        ["TextColor3"] = v13.TEXT_BRIGHT,
    }, 0.15)
end)
v62.MouseLeave:Connect(function()
    v14(v62, {
        ["BackgroundColor3"] = Color3.fromRGB(20, 66 - 44, 786 - (485 + 263)),
        ["TextColor3"] = v13.TEXT_MID,
    }, 707.15 - (575 + 132))
end)
local v63 = v15("Frame", {
    ["Name"] = "P3",
    ["Size"] = UDim2.new(1, -(901 - (750 + 111)), 1011 - (445 + 565), -(33 + 7)),
    ["Position"] = UDim2.new(0 + 0, 35 - 15, 1.2 + 0, 0),
    ["BackgroundTransparency"] = 311 - (189 + 121),
    ["ZIndex"] = 3 + 9,
    ["Visible"] = false,
    ["Parent"] = v34,
})
local v64 = v15("TextLabel", {
    ["Name"] = "Art",
    ["Size"] = UDim2.new(1348 - (634 + 713), 538 - (493 + 45), 968 - (493 + 475), 21 + 59),
    ["Position"] = UDim2.new(784 - (158 + 626), 0 + 0, 0 - 0, 20),
    ["BackgroundTransparency"] = 1,
    ["Text"] = "+-----------------------+\n|    ACCESS  GRANTED    |\n|   ==================  |\n+-----------------------+",
    ["TextSize"] = 13,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_GREEN,
    ["ZIndex"] = 3 + 10,
    ["Parent"] = v63,
})
local v65 = v15("TextLabel", {
    ["Name"] = "Msg",
    ["Size"] = UDim2.new(1 + 0, 1091 - (1035 + 56), 959 - (114 + 845), 9 + 13),
    ["Position"] = UDim2.new(0, 0 - 0, 0 + 0, 110),
    ["BackgroundTransparency"] = 1050 - (179 + 870),
    ["Text"] = "",
    ["TextSize"] = 12,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.NEON_GREEN,
    ["ZIndex"] = 17 - 4,
    ["Parent"] = v63,
})
local v66 = v15("TextLabel", {
    ["Name"] = "Detail",
    ["Size"] = UDim2.new(879 - (827 + 51), 0 - 0, 0 + 0, 70),
    ["Position"] = UDim2.new(0, 473 - (95 + 378), 0 + 0, 198 - 58),
    ["BackgroundTransparency"] = 1,
    ["Text"] = "",
    ["TextSize"] = 9 + 1,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_DIM,
    ["TextYAlignment"] = Enum.TextYAlignment.Top,
    ["TextXAlignment"] = Enum.TextXAlignment.Left,
    ["ZIndex"] = 13,
    ["Parent"] = v63,
})
local v67 = v15("Frame", {
    ["Name"] = "Bar",
    ["Size"] = UDim2.new(0.8, 0, 1011 - (334 + 677), 14 - 10),
    ["Position"] = UDim2.new(0.1, 1056 - (1049 + 7), 0 - 0, 432 - 202),
    ["BackgroundColor3"] = v13.BORDER_DIM,
    ["BackgroundTransparency"] = 0 + 0,
    ["BorderSizePixel"] = 0 - 0,
    ["ZIndex"] = 25 - 12,
    ["Parent"] = v63,
})
v16(v67, 1 + 1)
local v68 = v15("Frame", {
    ["Name"] = "Fill",
    ["Size"] = UDim2.new(1420 - (1004 + 416), 1957 - (1621 + 336), 1940 - (337 + 1602), 0),
    ["BackgroundColor3"] = v13.NEON_GREEN,
    ["BackgroundTransparency"] = 1517 - (1014 + 503),
    ["BorderSizePixel"] = 1015 - (446 + 569),
    ["ZIndex"] = 1 + 13,
    ["Parent"] = v67,
})
v16(v68, 5 - 3)
local v69 = v15("TextLabel", {
    ["Name"] = "BarLabel",
    ["Size"] = UDim2.new(1, 0 + 0, 0, 14),
    ["Position"] = UDim2.new(0 - 0, 0, 0 + 0, 745 - (223 + 282)),
    ["BackgroundTransparency"] = 1 + 0,
    ["Text"] = "INITIALIZING PAYLOAD...",
    ["TextSize"] = 13 - 4,
    ["Font"] = Enum.Font.Code,
    ["TextColor3"] = v13.TEXT_DIM,
    ["ZIndex"] = 18 - 5,
    ["Parent"] = v63,
})
local v70 = 671 - (623 + 47)
local function v71(v136)
    local v137 = 45 - (32 + 13)
    local v138
    local v139
    local v140
    local v141
    while true do
        if v137 == 0 then
            v138 = {
                v35,
                v56,
                v63,
            }
            v139 = v138[v70]
            v140 = v138[v136]
            v140.Visible = true
            v137 = 1 + 0
        end
        if v137 == 2 then
            v14(v140, {
                ["Position"] = UDim2.new(1801 - (1070 + 731), 20 + 0, 1404 - (1257 + 147), 8 + 12),
            }, 0.35 - 0, Enum.EasingStyle.Quint)
            task.delay(0.4, function()
                if v139 and v139.Parent then
                    v139.Visible = false
                end
            end)
            v70 = v136
            break
        end
        if v137 == (134 - (98 + 35)) then
            if v136 > v70 then
                v140.Position = UDim2.new(1.2 + 0, 0 - 0, 0 - 0, 20)
            else
                v140.Position = UDim2.new(-(1.2 + 0), 0 + 0, 0 + 0, 577 - (395 + 162))
            end
            v141 = nil
            if v136 > v70 then
                v141 = UDim2.new(-1.2, 0 + 0, 1941 - (816 + 1125), 20)
            else
                v141 = UDim2.new(1.2, 0, 0 - 0, 1168 - (701 + 447))
            end
            v14(v139, {
                ["Position"] = v141,
            }, 0.35 - 0, Enum.EasingStyle.Quint)
            v137 = 2 - 0
        end
    end
end
v51.MouseButton1Click:Connect(function()
    v71(1343 - (391 + 950))
end)
v62.MouseButton1Click:Connect(function()
    v71(2 - 1)
end)
v59.MouseButton1Click:Connect(function()
    local v142 = 0
    while true do
        if v142 == 1 then
            v59.TextColor3 = v13.SUCCESS
            v14(v61, {
                ["TextTransparency"] = 0,
            }, 0.15 - 0)
            v142 = 4 - 2
        end
        if v142 == (0 + 0) then
            pcall(function()
                if setclipboard then
                    setclipboard(v8.KEY_LINK)
                elseif toclipboard then
                    toclipboard(v8.KEY_LINK)
                end
            end)
            v59.Text = "✓  COPIED!"
            v142 = 1
        end
        if v142 == 2 then
            task.delay(2.5 + 0, function()
                if v59 and v59.Parent then
                    local v230 = 0 - 0
                    while true do
                        if v230 == 1 then
                            v14(v61, {
                                ["TextTransparency"] = 1,
                            }, 1522.4 - (251 + 1271))
                            break
                        end
                        if v230 == (0 + 0) then
                            v59.Text = "📋  [ COPY LINK ]"
                            v59.TextColor3 = v13.NEON_GREEN
                            v230 = 2 - 1
                        end
                    end
                end
            end)
            break
        end
    end
end)
v49.MouseButton1Click:Connect(function()
    local v143 = v45.Text
    v143 = v143:gsub("^%s+", ""):gsub("%s+$", "")
    if v143 == "" then
        local v166 = 0 - 0
        local v167
        while true do
            if v166 == (2 - 0) then
                return
            end
            if v166 == (1259 - (1147 + 112)) then
                v47("[ERR] No input detected", v13.NEON_RED, 1 + 2)
                v167 = v43.Position
                v166 = 1 - 0
            end
            if v166 == (1 + 0) then
                for v231 = 698 - (335 + 362), 5 + 0 do
                    local v232 = 0 - 0
                    while true do
                        if v232 == (0 - 0) then
                            v14(v43, {
                                ["Position"] = v167
                                    + UDim2.new(
                                        0 - 0,
                                        (24 - 19)
                                            * ((((v231 % (5 - 3)) == (566 - (237 + 329))) and (3 - 2)) or -(1 + 0)),
                                        0,
                                        0 + 0
                                    ),
                            }, 0.04)
                            task.wait(1124.04 - (408 + 716))
                            break
                        end
                    end
                end
                v14(v43, {
                    ["Position"] = v167,
                }, 0.04 - 0)
                v166 = 823 - (344 + 477)
            end
        end
    end
    v47("[...] Verifying key - please wait", v13.NEON_AMBER)
    v53.Visible = true
    v54.Size = UDim2.new(0 + 0, 0, 1762 - (1188 + 573), 0)
    v54.BackgroundColor3 = v13.NEON_GREEN
    v14(v54, {
        ["Size"] = UDim2.new(0.7 - 0, 0, 1 + 0, 0),
    }, 1.2, Enum.EasingStyle.Quad)
    v41.Text = "STATUS\n---------\nVERIFYING..."
    v41.TextColor3 = v13.NEON_AMBER
    task.wait(v19(32 - 22, 27 - 9) / 10)
    local v151 = false
    for v159, v160 in ipairs(v8.VALID_KEYS) do
        if v143 == v160 then
            v151 = true
            break
        end
    end
    if v151 then
        local v168 = 0 - 0
        local v169
        local v170
        local v171
        while true do
            if v168 == (1531 - (508 + 1021)) then
                v14(v26, {
                    ["Color"] = v13.SUCCESS,
                    ["Transparency"] = 0.2 + 0,
                }, 1166.3 - (228 + 938))
                task.wait(1)
                v53.Visible = false
                v168 = 688 - (332 + 353)
            end
            if v168 == 9 then
                v21:Destroy()
                v8.CALLBACK_ON_SUCCESS()
                break
            end
            if v168 == (8 - 1) then
                v171 = {
                    "INITIALIZING PAYLOAD...",
                    "LOADING MODULES...",
                    "INJECTING...",
                    "COMPLETE",
                }
                for v233, v234 in ipairs(v171) do
                    task.wait(0.6)
                    if v69 and v69.Parent then
                        local v243 = 0 + 0
                        while true do
                            if v243 == (0 - 0) then
                                v69.Text = v234
                                if v233 == #v171 then
                                    v69.TextColor3 = v13.SUCCESS
                                end
                                break
                            end
                        end
                    end
                end
                task.wait(424.2 - (18 + 405))
                v168 = 8
            end
            if v168 == 3 then
                local v208 = 0 + 0
                while true do
                    if v208 == (1 + 0) then
                        v18(v65, "Authorization complete. Welcome.", 0.03, v13.NEON_GREEN)
                        v168 = 5 - 1
                        break
                    end
                    if v208 == 0 then
                        v71(981 - (194 + 784))
                        task.wait(1770.4 - (694 + 1076))
                        v208 = 1
                    end
                end
            end
            if v168 == 4 then
                task.wait(1904.3 - (122 + 1782))
                v169 = ((#v143 > 8) and (v143:sub(1, 8 + 0) .. "........")) or v143
                v170 = "Key:     " .. v169 .. "\n"
                v168 = 5 + 0
            end
            if v168 == (1 + 0) then
                v41.Text = "STATUS\n---------\n+ VERIFIED"
                v41.TextColor3 = v13.SUCCESS
                v14(v44, {
                    ["Color"] = v13.SUCCESS,
                }, 0.2 + 0)
                v168 = 2
            end
            if v168 == (0 - 0) then
                v14(v54, {
                    ["Size"] = UDim2.new(1, 0, 1 + 0, 0),
                }, 1970.3 - (214 + 1756))
                v54.BackgroundColor3 = v13.SUCCESS
                v47("[OK] Key verified - access granted", v13.SUCCESS)
                v168 = 4 - 3
            end
            if v168 == (1 + 4) then
                v170 = v170 .. "User:    " .. v12.Name .. "\n"
                v170 = v170 .. "Time:    " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                v170 = v170 .. "Session: " .. v20()
                v168 = 1 + 5
            end
            if v168 == (593 - (217 + 368)) then
                local v214 = 0 - 0
                while true do
                    if v214 == 1 then
                        task.wait(0.4 + 0)
                        v168 = 7 + 2
                        break
                    end
                    if v214 == (0 + 0) then
                        v14(v25, {
                            ["Size"] = UDim2.new(889 - (844 + 45), 400, 284 - (242 + 42), 20 - 10),
                        }, 0.35, Enum.EasingStyle.Quint)
                        v14(v23, {
                            ["BackgroundTransparency"] = 1,
                        }, 0.35)
                        v214 = 1
                    end
                end
            end
            if v168 == (13 - 7) then
                v18(v66, v170, 1200.015 - (132 + 1068), v13.TEXT_DIM)
                task.wait(0.3 - 0)
                v14(v68, {
                    ["Size"] = UDim2.new(1624 - (214 + 1409), 0 + 0, 1, 1634 - (497 + 1137)),
                }, 2.5, Enum.EasingStyle.Quad)
                v168 = 947 - (9 + 931)
            end
        end
    else
        local v172 = 289 - (181 + 108)
        local v173
        while true do
            if v172 == 2 then
                v14(v26, {
                    ["Color"] = v13.NEON_RED,
                    ["Transparency"] = 0.3,
                }, 0.15 + 0)
                v173 = v43.Position
                for v235 = 1, 14 - 8 do
                    local v236 = 0
                    while true do
                        if v236 == 0 then
                            v14(v43, {
                                ["Position"] = v173
                                    + UDim2.new(
                                        0,
                                        7 * ((((v235 % (5 - 3)) == (0 + 0)) and (1 + 0)) or -(477 - (296 + 180))),
                                        1403 - (1183 + 220),
                                        0
                                    ),
                            }, 1265.04 - (1037 + 228))
                            task.wait(0.04 - 0)
                            break
                        end
                    end
                end
                v172 = 8 - 5
            end
            if v172 == 4 then
                v14(v26, {
                    ["Color"] = v13.NEON_GREEN,
                    ["Transparency"] = 0.5,
                }, 0.5 - 0)
                v53.Visible = false
                v41.Text = "STATUS\n---------\nAWAITING INPUT"
                v172 = 5
            end
            if (735 - (527 + 207)) == v172 then
                v41.Text = "STATUS\n---------\nX REJECTED"
                v41.TextColor3 = v13.ERROR
                v14(v44, {
                    ["Color"] = v13.ERROR,
                }, 527.15 - (187 + 340))
                v172 = 1872 - (1298 + 572)
            end
            if v172 == 5 then
                v41.TextColor3 = v13.NEON_AMBER
                break
            end
            if v172 == (6 - 3) then
                local v223 = 0
                local v224
                while true do
                    if v223 == (170 - (144 + 26)) then
                        v224 = 0 - 0
                        while true do
                            if v224 == (0 - 0) then
                                v14(v43, {
                                    ["Position"] = v173,
                                }, 0.04)
                                task.wait(1.5)
                                v224 = 1
                            end
                            if v224 == (1 + 0) then
                                v14(v44, {
                                    ["Color"] = v13.BORDER_DIM,
                                }, 0.3 - 0)
                                v172 = 9 - 5
                                break
                            end
                        end
                        break
                    end
                end
            end
            if (0 - 0) == v172 then
                local v225 = 0 + 0
                while true do
                    if v225 == (0 - 0) then
                        v14(v54, {
                            ["Size"] = UDim2.new(1 + 0, 0 + 0, 203 - (5 + 197), 686 - (339 + 347)),
                        }, 0.2)
                        v54.BackgroundColor3 = v13.ERROR
                        v225 = 2 - 1
                    end
                    if v225 == (3 - 2) then
                        v47("[FAIL] Invalid key - access denied", v13.ERROR, 380 - (365 + 11))
                        v172 = 1 + 0
                        break
                    end
                end
            end
        end
    end
end)
task.spawn(function()
    local v152 = 0 - 0
    local v153
    while true do
        if v152 == (4 - 2) then
            v14(v25, {
                ["Size"] = UDim2.new(924 - (837 + 87), 400, 0, 813 - 333),
                ["Position"] = UDim2.new(1670.5 - (837 + 833), -200, 0.5, -240),
            }, 0.5 + 0, Enum.EasingStyle.Quint)
            task.wait(1387.6 - (356 + 1031))
            v152 = 2 + 1
        end
        if 0 == v152 then
            v25.BackgroundTransparency = 1646 - (73 + 1573)
            v25.Size = UDim2.new(1388 - (1307 + 81), 634 - (7 + 227), 0 - 0, 172 - (90 + 76))
            v152 = 1
        end
        if v152 == 1 then
            v25.Position = UDim2.new(0.5, -(627 - 427), 0.5, -3)
            task.wait(0.1 + 0)
            v152 = 2 + 0
        end
        if v152 == (3 + 0) then
            v153 = {
                {
                    ["text"] = "[SYS] Establishing secure connection...",
                    ["color"] = v13.TEXT_DIM,
                },
                {
                    ["text"] = "[SYS] Protocol: AES-256-GCM",
                    ["color"] = v13.TEXT_DIM,
                },
                {
                    ["text"] = "[SYS] Connected to auth.nexus.io",
                    ["color"] = v13.NEON_GREEN,
                },
                {
                    ["text"] = "[>>>] Awaiting key input...",
                    ["color"] = v13.NEON_AMBER,
                },
            }
            for v195, v196 in ipairs(v153) do
                local v197 = 0
                local v198
                while true do
                    if v197 == (1 + 0) then
                        task.wait(0.15 + 0)
                        break
                    end
                    if v197 == (0 - 0) then
                        local v240 = 1369 - (618 + 751)
                        while true do
                            if v240 == (1 + 0) then
                                v197 = 1
                                break
                            end
                            if v240 == 0 then
                                v198 = v38("", v196.color, v195)
                                v18(v198, v196.text, 0.02, v196.color)
                                v240 = 1911 - (206 + 1704)
                            end
                        end
                    end
                end
            end
            break
        end
    end
end)
task.spawn(function()
    while v21 and v21.Parent do
        local v161 = 0 - 0
        while true do
            if v161 == 1 then
                v14(v26, {
                    ["Transparency"] = 0.7 - 0,
                }, 1 + 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(1277 - (155 + 1120))
                break
            end
            if v161 == (1506 - (396 + 1110)) then
                v14(v26, {
                    ["Transparency"] = 0.3,
                }, 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(4 - 2)
                v161 = 1
            end
        end
    end
end)
task.spawn(function()
    while v21 and v21.Parent do
        local v162 = 0
        while true do
            if v162 == 0 then
                v21.DisplayOrder = 326 + 673
                task.wait(2 + 0)
                break
            end
        end
    end
end)
print("[NEXUS] v2.0 Key system loaded | CoreGui | DisplayOrder 999")
