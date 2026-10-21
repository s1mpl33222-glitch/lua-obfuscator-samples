-- This file was generated at discord.gg/syncrypt

game:GetService("HttpService")
local v212 = game:GetService("Players").LocalPlayer
local up31 = v212
local v220 = {["the_j"] = {["AccessLevel"] = "Access", ["Expires"] = nil}}
local v219 = {}
local up32 = {["ValidKeys"] = v220, ["WhitelistedUsers"] = v219, ["SaveKeyEnabled"] = false, ["DiscordInvite"] = "https://discord.gg/wZkYuPMkdb", ["DiscordInviteCode"] = "wZkYuPMkdb"}
local up33 = function(arg3_1)
    local v75, v76, v78, v79
    local v73 = arg3_1
    local v74 = table.find(up32.WhitelistedUsers, up31.UserId)
    if v74 then
        v79 = true
        v74 = "Whitelisted User"
        v78 = "Access"
        return v79, v74, v78
    else
        v78 = (string.lower(v73))
        v75 = up32
        if v75.ValidKeys [v78] then
            v75 = up32.ValidKeys[v78]
            v76 = v75.Expires
            v74 = v76
            if v76 then
                v74 = (v75.Expires < (os.time()))
            end
            if v74 then
                v74 = "Key has expired!"
                v79 = false
                return v79, v74, nil
            else
                v79 = true
                v74 = "Valid Key"
                v76 = v75.AccessLevel
                return v79, v74, v76
            end
        else
            v79 = false
            v74 = "Invalid Key!"
            return v79, v74, nil
        end
    end
end
v220 = function()
    local v86 = Instance.new("ScreenGui")
    local up1 = v86
    up1.Name = "ScriptOfJKey"
    up1.Parent = game:GetService("CoreGui")
    up1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local v87 = (Instance.new("Frame"))
    v87.Size = UDim2.new(1, 0, 1, 0)
    v87.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v87.BackgroundTransparency = .6
    v87.Parent = up1
    local v88 = (Instance.new("Frame"))
    v88.Size = UDim2.new(0, 450, 0, 450)
    v88.Position = UDim2.new(0.5, -225, 0.5, -225)
    v88.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    v88.BorderSizePixel = 0
    v88.Parent = up1
    local v89 = (Instance.new("UICorner"))
    v89.CornerRadius = UDim.new(0, 15)
    v89.Parent = v88
    local v92 = (Instance.new("UIGradient"))
    v86 = ColorSequence.new
    local v96 = ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 100, 255))
    v92.Color = v86({v96, ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 30, 100))})
    v92.Rotation = 45
    v92.Parent = v88
    local v93 = (Instance.new("TextLabel"))
    v93.Size = UDim2.new(1, 0, 0, 60)
    v93.Position = UDim2.new(0, 0, 0, 30)
    v93.Text = "\240\159\148\183 Script Of J"
    v93.TextColor3 = Color3.fromRGB(255, 255, 255)
    v93.Font = Enum.Font.GothamBlack
    v93.TextSize = 28
    v93.BackgroundTransparency = 1
    v93.Parent = v88
    local v94 = (Instance.new("TextLabel"))
    v94.Size = UDim2.new(1, 0, 0, 30)
    v94.Position = UDim2.new(0, 0, 0, 90)
    v94.Text = "Script Of J Key System"
    v94.TextColor3 = Color3.fromRGB(100, 150, 255)
    v94.Font = Enum.Font.Gotham
    v94.TextSize = 18
    v94.BackgroundTransparency = 1
    v94.Parent = v88
    v86 = Instance.new("TextBox")
    local up2 = v86
    up2.Size = UDim2.new(1, -60, 0, 50)
    up2.Position = UDim2.new(0, 30, 0, 140)
    up2.PlaceholderText = "Enter your key..."
    up2.Text = ""
    up2.TextColor3 = Color3.fromRGB(255, 255, 255)
    up2.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    up2.Font = Enum.Font.Gotham
    up2.TextSize = 16
    up2.Parent = v88
    v96 = (Instance.new("UICorner"))
    v96.CornerRadius = UDim.new(0, 8)
    v96.Parent = up2
    v86 = Instance.new("TextButton")
    local up3 = v86
    up3.Size = UDim2.new(1, -60, 0, 50)
    up3.Position = UDim2.new(0, 30, 0, 200)
    up3.Text = "\226\156\147 Activate"
    up3.TextColor3 = Color3.fromRGB(255, 255, 255)
    up3.BackgroundColor3 = Color3.fromRGB(30, 60, 150)
    up3.Font = Enum.Font.GothamBold
    up3.TextSize = 18
    up3.Parent = v88
    local v98 = (Instance.new("UICorner"))
    v98.CornerRadius = UDim.new(0, 8)
    v98.Parent = up3
    local v91 = up3.MouseEnter
    local v99 = function()
        up3.BackgroundColor3 = Color3.fromRGB(40, 80, 180)

        return
    end
    v91:Connect(v99)
    v91 = up3.MouseLeave
    v99 = function()
        up3.BackgroundColor3 = Color3.fromRGB(30, 60, 150)

        return
    end
    v91:Connect(v99)
    v86 = Instance.new("TextButton")
    local up4 = v86
    up4.Size = UDim2.new(1, -60, 0, 50)
    up4.Position = UDim2.new(0, 30, 0, 260)
    up4.Text = "\240\159\147\177 Join the Discord for the Key"
    up4.TextColor3 = Color3.fromRGB(255, 255, 255)
    up4.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    up4.Font = Enum.Font.GothamBold
    up4.TextSize = 16
    up4.Parent = v88
    up4.AutoButtonColor = false
    local v100 = (Instance.new("UICorner"))
    v100.CornerRadius = UDim.new(0, 8)
    v100.Parent = up4
    v91 = up4.MouseEnter
    local v101 = function()
        up4.BackgroundColor3 = Color3.fromRGB(98, 111, 252)

        return
    end
    v91:Connect(v101)
    v91 = up4.MouseLeave
    v101 = function()
        up4.BackgroundColor3 = Color3.fromRGB(88, 101, 242)

        return
    end
    v91:Connect(v101)
    v86 = Instance.new("TextLabel")
    local up5 = v86
    up5.Size = UDim2.new(1, -60, 0, 40)
    up5.Position = UDim2.new(0, 30, 0, 320)
    up5.Text = ""
    up5.TextColor3 = Color3.fromRGB(255, 255, 255)
    up5.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    up5.Font = Enum.Font.Gotham
    up5.TextSize = 14
    up5.Visible = false
    up5.Parent = v88
    up5.TextWrapped = true
    local v102 = (Instance.new("UICorner"))
    v102.CornerRadius = UDim.new(0, 5)
    v102.Parent = up5
    up4.MouseButton1Click:Connect(function()
        local v166, v168, v169, v170
        local v171 = up32.DiscordInvite
        v170, v166 = v171, "setclipboard"
        if setclipboard then
            setclipboard(v170)
            v171 = StatusLabel
            v171.Text = "Discord link copied to clipboard!"
            v171 = StatusLabel
            v168 = Color3.fromRGB(100, 255, 100)
            v171.TextColor3 = v168
        else
            v171 = StatusLabel
            v169 = up32.DiscordInviteCode
            v171.Text = ("Join: discord.gg/" .. v169)
            v171 = StatusLabel
            v168 = Color3.fromRGB(100, 255, 100)
            v171.TextColor3 = v168
        end
        up5.Text = v170
        up5.Visible = true
        up5.TextColor3 = Color3.fromRGB(100, 255, 100)
        up4.Text = "\226\156\147 Link Copied!"
        up4.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        wait(2)
        up4.Text = "\240\159\147\177 Join the Discord for the Key"
        up4.BackgroundColor3 = Color3.fromRGB(88, 101, 242)

        return
    end)
    v86 = Instance.new("TextLabel")
    local up6 = v86
    up6.Size = UDim2.new(1, 0, 0, 30)
    up6.Position = UDim2.new(0, 0, 0, 370)
    up6.Text = ""
    up6.TextColor3 = Color3.fromRGB(255, 100, 100)
    up6.Font = Enum.Font.Gotham
    up6.TextSize = 14
    up6.BackgroundTransparency = 1
    up6.Parent = v88
    local v104 = (Instance.new("TextLabel"))
    v104.Size = UDim2.new(1, 0, 0, 20)
    v104.Position = UDim2.new(0, 0, 0, 420)
    v104.Text = "v1.0 | Script Of J"
    v104.TextColor3 = Color3.fromRGB(100, 100, 100)
    v104.Font = Enum.Font.Gotham
    v104.TextSize = 12
    v104.BackgroundTransparency = 1
    v104.Parent = v88
    local up7 = function(arg13_1)
        local v178, v179, v181, v182, v184
        local v177 = arg13_1
        if (v177 == "") then
            v181 = up6
            v181.Text = "Please enter a key!"
            v181 = up6
            v179 = Color3.fromRGB(255, 150, 50)
            v181.TextColor3 = v179
            return
        else
            v182, v178, v179 = up33(v177)
            if v182 then
                v181 = up6
                v181.Text = ("\226\156\147 " .. (v178 .. " - Access Granted"))
                v181 = up6
                v184 = Color3.fromRGB(100, 255, 100)
                v181.TextColor3 = v184
                v181 = up3
                v181.Text = "\226\156\147 Activated!"
                v181 = up3
                v184 = Color3.fromRGB(50, 200, 50)
                v181.BackgroundColor3 = v184
                wait(0.5)
                up1:Destroy()
                LoadMainScript(v179)
            else
                v181 = up6
                v181.Text = ("\226\156\151 " .. v178)
                v181 = up6
                v184 = Color3.fromRGB(255, 100, 100)
                v181.TextColor3 = v184
                v181 = up3
                v181.Text = "\226\156\151 Failed"
                v181 = up3
                v184 = Color3.fromRGB(200, 50, 50)
                v181.BackgroundColor3 = v184
                wait(0.5)
                v181 = up3
                v181.Text = "\226\156\147 Activate"
                v181 = up3
                v184 = Color3.fromRGB(30, 60, 150)
                v181.BackgroundColor3 = v184
            end
            return
        end
    end
    v91 = up3.MouseButton1Click
    local v106 = function()
        up7(up2.Text)

        return
    end
    v91:Connect(v106)
    v91 = up2.FocusLost
    v106 = function(arg15_1)
        if arg15_1 then
            up7(up2.Text)
        end
        return
    end
    v91:Connect(v106)

    return
end
LoadMainScript = function(arg5_1)
    print("Access Granted")
    print("Loading Script...")
    loadstring(game:HttpGet("https://pastebin.com/raw/xbYLu9w4"))()
    return
end
v220()
return
