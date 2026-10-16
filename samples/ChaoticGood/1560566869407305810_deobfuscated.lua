local v8 = "EnygmaLoader-UPD"
local v9 = game.Players.LocalPlayer
local v10 = Instance.new("ScreenGui", v9:WaitForChild("PlayerGui"))
local v11 = Instance.new("Frame", v10)
v11.Size = UDim2.new(0 + 0, 238 + 82, 0 + 0, 319 - 139)
v11.Position = UDim2.new(1080.5 - (1020 + 60), -(1583 - (630 + 793)), 0.5 - 0, -(11 + 79))
v11.BackgroundColor3 = Color3.fromRGB(222 - (14 + 188), 94 - 74, 695 - (534 + 141))
v11.Active = true
Instance.new("UICorner", v11).CornerRadius = UDim.new(0 + 0, 9 + 1)
local v17 = Instance.new("UIStroke", v11)
v17.Color = Color3.fromRGB(877 - 622, 126 - 66, 1807 - (760 + 987))
local v19 = Instance.new("Frame", v11)
v19.Size = UDim2.new(1914 - (1789 + 124), 0, 0 + 0, 796 - (745 + 21))
v19.BackgroundTransparency = 1
local v22 = Instance.new("TextLabel", v19)
v22.Size = UDim2.new(1 + 0, -(110 - 70), 3 - 2, 0 - 0)
v22.Position = UDim2.new(0 - 0, 877 - (550 + 317), 0 + 0, 0 + 0)
v22.Text = "🔐 EnygmaLoader Key System"
v22.TextColor3 = Color3.fromRGB(358 - 103, 255, 1310 - (87 + 968))
v22.BackgroundTransparency = 4 - 3
v22.Font = Enum.Font.GothamBold
v22.TextSize = 300 - (134 + 151)
v22.TextXAlignment = Enum.TextXAlignment.Left
local v33 = Instance.new("TextButton", v19)
v33.Size = UDim2.new(0, 28 + 2, 1, 0 - 0)
v33.Position = UDim2.new(1414 - (447 + 966), -(82 - 52), 1817 - (1703 + 114), 701 - (376 + 325))
v33.Text = "X"
v33.BackgroundTransparency = 1 - 0
v33.TextColor3 = Color3.fromRGB(417 - 162, 246 - 166, 23 + 57)
v33.MouseButton1Click:Connect(function()
    v10:Destroy()
end)
local v39 = Instance.new("TextBox", v11)
v39.Size = UDim2.new(1824.85 - (1195 + 629), 0 - 0, 241 - (187 + 54), 49 - (9 + 5))
v39.Position = UDim2.new(376.075 - (85 + 291), 1265 - (243 + 1022), 0 + 0, 209 - 154)
v39.PlaceholderText = "Enter key..."
v39.BackgroundColor3 = Color3.fromRGB(29 + 6, 1215 - (1123 + 57), 29 + 6)
v39.TextColor3 = Color3.new(1 - 0, 1 + 0, 255 - (163 + 91))
Instance.new("UICorner", v39)
local v45 = Instance.new("TextLabel", v11)
v45.Size = UDim2.new(1931 - (1869 + 61), 0 + 0, 0 - 0, 31 - 11)
v45.Position = UDim2.new(0 - 0, 0 - 0, 0 + 0, 13 + 82)
v45.BackgroundTransparency = 1 - 0
v45.Text = ""
local v50 = Instance.new("TextButton", v11)
v50.Size = UDim2.new(341.4 - (218 + 123), 1581 - (1535 + 46), 0 - 0, 33 + 2)
v50.Position = UDim2.new(1474.08 - (1329 + 145), 971 - (140 + 831), 1851 - (1409 + 441), -(610 - (306 + 254)))
v50.Text = "Check"
v50.BackgroundColor3 = Color3.fromRGB(13 + 187, 758 - (15 + 703), 19 + 21)
v50.TextColor3 = Color3.new(439 - (262 + 176), 1722 - (345 + 1376), 689 - (198 + 490))
Instance.new("UICorner", v50)
local v56 = Instance.new("TextButton", v11)
v56.Size = UDim2.new(0.4, 0, 0 - 0, 154 - 119)
v56.Position = UDim2.new(0.52 - 0, 1206 - (696 + 510), 1 - 0, -(1506 - (282 + 1174)))
v56.Text = "Get Key"
v56.BackgroundColor3 = Color3.fromRGB(1462 - (1091 + 171), 7 + 33, 115 - 75)
v56.TextColor3 = Color3.new(1 + 0, 3 - 2, 1025 - (706 + 318))
Instance.new("UICorner", v56)
local v62 = game:GetService("UserInputService")
local v63, v64, v65, v66
v19.InputBegan:Connect(function(v70)
    if v70.UserInputType == Enum.UserInputType.MouseButton1 then
        v63 = true
        v65 = v70.Position
        v66 = v11.Position
        v70.Changed:Connect(function()
            if v70.UserInputState == Enum.UserInputState.End then
                v63 = false
            end
        end)
    end
end)
v19.InputChanged:Connect(function(v71)
    if v71.UserInputType == Enum.UserInputType.MouseMovement then
        v64 = v71
    end
end)
v62.InputChanged:Connect(function(v72)
    if (v72 == v64) and v63 then
        local v78 = 1251 - (721 + 530)
        local v79
        while true do
            if (0 - 0) == v78 then
                v79 = v72.Position - v65
                v11.Position = UDim2.new(v66.X.Scale, v66.X.Offset + v79.X, v66.Y.Scale, v66.Y.Offset + v79.Y)
                break
            end
        end
    end
end)
v50.MouseButton1Click:Connect(function()
    if v39.Text == v8 then
        v45.Text = "✔ Correct"
        v45.TextColor3 = Color3.fromRGB(0, 637 - 382, 134 + 16)
        task.wait(701 - (271 + 429))
        v10:Destroy()
        loadstring(game:HttpGet("https://pastebin.com/raw/BZHiyF17"))()
    else
        local v82 = 0 + 0
        while true do
            if (1500 - (1408 + 92)) == v82 then
                v45.Text = "✖ Invalid"
                v45.TextColor3 = Color3.fromRGB(629 - (123 + 251), 397 - 317, 80)
                break
            end
        end
    end
end)
v56.MouseButton1Click:Connect(function()
    setclipboard("https://link-hub.net/4656550/rej2cQRPsLo4")
    v45.Text = "Copied!"
    v45.TextColor3 = Color3.fromRGB(14 + 241, 80, 778 - (208 + 490))
end)
