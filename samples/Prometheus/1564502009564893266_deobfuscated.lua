-- This file was generated at discord.gg/syncrypt

local spilledValues1 = {}
local unpackValues = unpack or table.unpack

local v3736, v3737, v3739, v3740, v3744, v3745, v3746, v3747, v3748, v3749, v3750, v3751, v3752, v3753, v3754, v3755
local v3756, v3757, v3758, v3759, v3760
local v3761, v3762, v3763, v3764, v3765, v3766, v3767, v3768, v3769, v3770, v3771, v3772, v3773, v3774, v3775, v3776

local v3785, v3786, v3787, v3788, v3790, v3792, v3793, v3794, v3795, v3796, v3797, v3798, v3800, v3801, v3802, v3803






local v3741 = _G
if v3741["VelonexLoaded"] then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Velonex Hub", ["Text"] = "Script is already running!", ["Icon"] = "rbxassetid://11352463402", ["Duration"] = 5})
        return
    end)
    return
else
    spilledValues1.value1 = _G
    spilledValues1.value1.VelonexLoaded = true
    game:GetService("TweenService")
    game:GetService("RunService")
    game:GetService("HttpService")
    game:GetService("TeleportService")
    spilledValues1.value1 = {["Key"] = "VelonexQ4nP2gt67", ["UI_Title"] = "Velonex"}
    local up178 = spilledValues1.value1
    spilledValues1.value1 = _G
    spilledValues1.value1.VelonexLoaded = true
    spilledValues1.value1 = _G
    spilledValues1.value1.ScriptUnloaded = false
    spilledValues1.value1 = _G
    spilledValues1.value1.AutoCoinV3 = false
    spilledValues1.value1 = _G
    spilledValues1.value1.PlayerChamsActive = false
    spilledValues1.value1 = _G
    spilledValues1.value1.ChamsFillTransparency = 0.5
    spilledValues1.value1 = _G
    spilledValues1.value1.ChamsMode = "Textured"
    spilledValues1.value1 = _G
    spilledValues1.value1.RoleCache = {}
    spilledValues1.value1 = _G
    spilledValues1.value1.CachedGunDrop = nil
    spilledValues1.value1 = _G
    spilledValues1.value1.AutoKillAll = false
    spilledValues1.value1 = _G
    spilledValues1.value1.TargetPart = "HumanoidRootPart"
    spilledValues1.value1 = _G
    spilledValues1.value1.AimbotSmoothing = 1
    spilledValues1.value1 = _G
    spilledValues1.value1.DeadPlayers = {}
    spilledValues1.value1 = _G
    spilledValues1.value3 = Color3.fromRGB(255, 0, 0)
    spilledValues1.value1.RainbowColor = spilledValues1.value3
    spilledValues1.value1 = _G
    spilledValues1.value1.VisualsRainbow = false
    task.spawn(function()
        local v382, v384, v386
        local v383 = 0
        while true do
            task.wait(.03)
            v382 = ((v383 + 1) % 360)
            v384 = _G
            v383 = v382
            v386 = Color3.fromHSV((v383 / 360), 1, 1)
            v384.RainbowColor = v386
        end
    end)
    spilledValues1.value1 = _G
    spilledValues1.value5 = CFrame.new(28.25, 504.82, -26.08)
    spilledValues1.value6 = CFrame.new(14.43, 504.82, -37.03)
    spilledValues1.value7 = CFrame.new(3.25, 504.82, -24.8)
    spilledValues1.value8 = CFrame.new(14.44, 504.82, -10.91)
    spilledValues1.value4 = CFrame.new
    v3740 = {spilledValues1.value5, spilledValues1.value6, spilledValues1.value7, spilledValues1.value8, spilledValues1.value4(13.72, 507.17, 34.88)}
    spilledValues1.value7 = CFrame.new(64.03, 201.73, 9197.98)
    spilledValues1.value8 = CFrame.new(39.37, 207.98, 9233.83)
    spilledValues1.value9 = CFrame.new(-52.46, 207.98, 9253.48)
    spilledValues1.value11 = CFrame.new(-76.35, 207.93, 9091.36)
    spilledValues1.value12 = CFrame.new(-81.29, 207.98, 9232.56)
    spilledValues1.value10 = CFrame.new(-81.6, 207.98, 9100.81)
    v3737 = CFrame.new(-72.56, 207.93, 9068.64)
    v3736 = CFrame.new(-70.76, 235.74, 9062.89)
    v3739 = CFrame.new(-0.99, 233.26, 9030.38)
    v3745 = CFrame.new(20.66, 238.33, 9034.8)
    v3749 = CFrame.new(27.52, 237.53, 9110.28)
    v3744 = CFrame.new(104.76, 232.96, 9015.63)
    v3746 = CFrame.new(23.61, 222.83, 9181.67)
    v3747 = CFrame.new(55.69, 234.56, 9000.35)
    spilledValues1.value6 = CFrame.new
    spilledValues1.value5 = {spilledValues1.value7, spilledValues1.value8, spilledValues1.value9, spilledValues1.value11, spilledValues1.value12, spilledValues1.value10, v3737, v3736, v3739, v3745, v3749, v3744, v3746, v3747, spilledValues1.value6(15.87, 234.93, 9070.04)}
    spilledValues1.value9 = CFrame.new(-72.91, 274.1, 8949.22)
    spilledValues1.value11 = CFrame.new(-83.73, 258.15, 8892.7)
    spilledValues1.value12 = CFrame.new(-28.5, 258.15, 8964.66)
    spilledValues1.value10 = CFrame.new(-22.4, 279.05, 8895.37)
    v3737 = CFrame.new(-81.48, 275.95, 8999.07)
    v3736 = CFrame.new(29.76, 274.1, 9020.22)
    v3739 = CFrame.new(-61.16, 278.1, 9031.67)
    v3745 = CFrame.new(-52.01, 275.95, 9011.03)
    v3749 = CFrame.new(-70.65, 289.05, 8990.07)
    v3744 = CFrame.new(-86.71, 292.25, 8949.01)
    v3746 = CFrame.new(-62.87, 292.25, 8974.38)
    v3747 = CFrame.new(-62.65, 292.25, 8932.49)
    v3748 = CFrame.new(8.73, 278.32, 8992.82)
    v3750 = CFrame.new(-44.92, 290.25, 8995.01)
    spilledValues1.value8 = CFrame.new
    spilledValues1.value7 = {spilledValues1.value9, spilledValues1.value11, spilledValues1.value12, spilledValues1.value10, v3737, v3736, v3739, v3745, v3749, v3744, v3746, v3747, v3748, v3750, spilledValues1.value8(25.09, 280.25, 8897.74)}
    spilledValues1.value12 = CFrame.new(-21.56, 272.32, 9055.65)
    spilledValues1.value10 = CFrame.new(-60.29, 272.32, 8986.45)
    v3737 = CFrame.new(-60.34, 272.32, 9054.7)
    v3736 = CFrame.new(25.13, 272.32, 9015.52)
    v3739 = CFrame.new(-61.31, 272.32, 8950.45)
    v3745 = CFrame.new(53.43, 272.32, 9096.06)
    v3749 = CFrame.new(91.84, 277.92, 9054.92)
    v3744 = CFrame.new(76.01, 277.92, 8996.76)
    v3746 = CFrame.new(20.36, 272.32, 9035.48)
    v3747 = CFrame.new(-52.13, 272.32, 9019.19)
    v3748 = CFrame.new(-7.49, 272.32, 8960.2)
    v3750 = CFrame.new(-21.75, 272.32, 8969.22)
    v3751 = CFrame.new(-21.12, 272.32, 9035.4)
    v3752 = CFrame.new(25.45, 272.32, 9054.38)
    spilledValues1.value11 = CFrame.new
    spilledValues1.value9 = {spilledValues1.value12, spilledValues1.value10, v3737, v3736, v3739, v3745, v3749, v3744, v3746, v3747, v3748, v3750, v3751, v3752, spilledValues1.value11(49.95, 272.32, 9004.36)}
    v3737 = CFrame.new(-24.98, 300.11, 8948.02)
    v3736 = CFrame.new(-59.51, 300.11, 9013.89)
    v3739 = CFrame.new(-22.62, 284.11, 9009.48)
    v3745 = CFrame.new(28.65, 284.26, 9013.47)
    v3749 = CFrame.new(-0.34, 284.11, 8976.69)
    v3744 = CFrame.new(23.29, 299.11, 8917.24)
    spilledValues1.value10 = CFrame.new
    spilledValues1.value12 = {v3737, v3736, v3739, v3745, v3749, v3744, spilledValues1.value10(33.98, 300.11, 8959.56)}
    v3739 = CFrame.new(-49.21, 292.1, 8924.47)
    v3745 = CFrame.new(-117.84, 292.1, 8958.31)
    v3749 = CFrame.new(-97.84, 292.3, 9009.7)
    v3744 = CFrame.new(-9.77, 302.1, 9028.52)
    v3746 = CFrame.new(5.3, 292.1, 8981.55)
    v3747 = CFrame.new(-8.16, 302.1, 9122.57)
    v3748 = CFrame.new(-63.18, 302.1, 9152.76)
    v3750 = CFrame.new(-47.62, 302.1, 9003.5)
    v3751 = CFrame.new(12.33, 302.9, 9086.26)
    v3752 = CFrame.new(10.14, 288.1, 9028.48)
    v3753 = CFrame.new(-48.54, 302.1, 9079.29)
    v3754 = CFrame.new(-62.41, 302.1, 9119.43)
    v3755 = CFrame.new(-104.95, 297.1, 9118.54)
    v3756 = CFrame.new(-82.42, 288.26, 9061.59)
    v3736 = CFrame.new
    v3737 = {v3739, v3745, v3749, v3744, v3746, v3747, v3748, v3750, v3751, v3752, v3753, v3754, v3755, v3756, v3736(-48.96, 314.48, 9037.25)}
    v3749 = CFrame.new(28.39, 277.6, 9012)
    v3744 = CFrame.new(57.93, 293.6, 9012.06)
    v3746 = CFrame.new(44.99, 309.8, 8990.24)
    v3747 = CFrame.new(-91.06, 310.1, 8974.57)
    v3748 = CFrame.new(-6.82, 309.8, 8995.86)
    v3750 = CFrame.new(-85.96, 294.8, 8989.57)
    v3751 = CFrame.new(-77.79, 294.8, 9032.37)
    v3752 = CFrame.new(30.9, 294.8, 9010.12)
    v3753 = CFrame.new(-85.45, 277.6, 9010.35)
    v3754 = CFrame.new(34.75, 294.8, 8983.84)
    v3755 = CFrame.new(-45.22, 294.8, 9018.36)
    v3756 = CFrame.new(106.04, 281.6, 9010.89)
    v3757 = CFrame.new(11.48, 294.8, 9016.01)
    v3758 = CFrame.new(9, 309.8, 9020.85)
    v3745 = CFrame.new
    v3739 = {v3749, v3744, v3746, v3747, v3748, v3750, v3751, v3752, v3753, v3754, v3755, v3756, v3757, v3758, v3745(-43.6, 309.8, 9015.8)}
    v3746 = CFrame.new(636.88, 297.47, 9754.8)
    v3747 = CFrame.new(690.74, 286.27, 9755.51)
    v3748 = CFrame.new(606.6, 297.47, 9817.56)
    v3750 = CFrame.new(668.07, 297.47, 9848.15)
    v3751 = CFrame.new(638.42, 297.47, 9873.64)
    v3752 = CFrame.new(636.11, 297.47, 9690.45)
    v3753 = CFrame.new(572.83, 269.07, 9643.27)
    v3754 = CFrame.new(550.94, 284.07, 9677.2)
    v3755 = CFrame.new(540.58, 284.07, 9693.87)
    v3756 = CFrame.new(554.26, 284.07, 9753.85)
    v3757 = CFrame.new(535.01, 297.27, 9891.61)
    v3744 = CFrame.new
    v3749 = {v3746, v3747, v3748, v3750, v3751, v3752, v3753, v3754, v3755, v3756, v3757, v3744(517.62, 284.47, 9847.78)}
    v3748 = CFrame.new(-18.97, 256.5, 8987.2)
    v3750 = CFrame.new(-11.01, 261.7, 8959.6)
    v3751 = CFrame.new(-21.47, 247.7, 8952.57)
    v3752 = CFrame.new(-13.93, 250.9, 8929.06)
    v3753 = CFrame.new(-42.27, 268.9, 8920.65)
    v3754 = CFrame.new(-9.96, 268.9, 8920.91)
    v3755 = CFrame.new(49.48, 269.56, 8934.51)
    v3756 = CFrame.new(30.25, 269.5, 8953.78)
    v3757 = CFrame.new(52.21, 269.56, 8930.37)
    v3758 = CFrame.new(37.13, 266.35, 8994.72)
    v3759 = CFrame.new(16.39, 266.3, 9060.26)
    v3760 = CFrame.new(39.02, 264.5, 9057.43)
    v3761 = CFrame.new(56.82, 266.3, 9046.97)
    v3762 = CFrame.new(38.49, 266.35, 9037.54)
    v3747 = CFrame.new
    v3746 = {v3748, v3750, v3751, v3752, v3753, v3754, v3755, v3756, v3757, v3758, v3759, v3760, v3761, v3762, v3747(-2.25, 266.3, 9006.01)}
    v3751 = CFrame.new(-10.58, 304.66, 8944.82)
    v3752 = CFrame.new(-0.93, 304.75, 8967.85)
    v3753 = CFrame.new(-38.22, 304.75, 8928.7)
    v3754 = CFrame.new(-98.66, 304.75, 8944.76)
    v3755 = CFrame.new(-92.84, 304.65, 9005.47)
    v3756 = CFrame.new(-32.41, 304.75, 9031.39)
    v3757 = CFrame.new(2.76, 304.66, 9020.02)
    v3758 = CFrame.new(11.4, 304.65, 9049.04)
    v3759 = CFrame.new(-6.43, 304.65, 9049.51)
    v3760 = CFrame.new(-39.68, 317.25, 9072.48)
    v3761 = CFrame.new(-49.65, 304.75, 9075.87)
    v3762 = CFrame.new(-28.08, 304.66, 9005.25)
    v3763 = CFrame.new(-41.49, 304.75, 8961.22)
    v3764 = CFrame.new(-84.67, 304.66, 8975.27)
    v3750 = CFrame.new
    v3748 = {v3751, v3752, v3753, v3754, v3755, v3756, v3757, v3758, v3759, v3760, v3761, v3762, v3763, v3764, v3750(-49.29, 304.75, 8980.11)}
    v3753 = CFrame.new(-53.3, 274.25, 9029.4)
    v3754 = CFrame.new(-43.41, 274.25, 8973.83)
    v3755 = CFrame.new(-29.07, 289.21, 8957.72)
    v3756 = CFrame.new(13.14, 289.25, 8925.36)
    v3757 = CFrame.new(28.99, 274.25, 9004.99)
    v3758 = CFrame.new(60.38, 275.45, 9032.68)
    v3759 = CFrame.new(55.78, 274.25, 9043.08)
    v3760 = CFrame.new(59.17, 274.25, 9059.56)
    v3761 = CFrame.new(32.67, 275.85, 9078.11)
    v3762 = CFrame.new(-16.26, 274.25, 9079.8)
    v3763 = CFrame.new(-44.58, 259.25, 9022.26)
    v3764 = CFrame.new(-37.36, 249.45, 9075.92)
    v3765 = CFrame.new(-59.8, 249.85, 9023.42)
    v3766 = CFrame.new(-31.35, 259.25, 8954.64)
    v3752 = CFrame.new
    v3751 = {v3753, v3754, v3755, v3756, v3757, v3758, v3759, v3760, v3761, v3762, v3763, v3764, v3765, v3766, v3752(-29.84, 291.05, 8911.32)}
    v3755 = CFrame.new(-0.3, 295.43, 8953.9)
    v3756 = CFrame.new(-40.98, 295.43, 8979.85)
    v3757 = CFrame.new(-35.16, 295.43, 9020.22)
    v3758 = CFrame.new(-17.21, 295.43, 9053.69)
    v3759 = CFrame.new(29.51, 279.43, 9036.99)
    v3760 = CFrame.new(33.89, 279.43, 9058.45)
    v3761 = CFrame.new(35.51, 295.43, 8977.72)
    v3762 = CFrame.new(11.49, 297.43, 8939.26)
    v3763 = CFrame.new(10.26, 311.43, 9035.92)
    v3764 = CFrame.new(-51.95, 297.43, 9000.76)
    v3765 = CFrame.new(8.33, 290.56, 9051.26)
    v3766 = CFrame.new(-16.7, 295.43, 9053.1)
    v3767 = CFrame.new(16.54, 295.43, 9035.63)
    v3768 = CFrame.new(-16.1, 295.43, 8972.89)
    v3754 = CFrame.new
    v3753 = {v3755, v3756, v3757, v3758, v3759, v3760, v3761, v3762, v3763, v3764, v3765, v3766, v3767, v3768, v3754(16.47, 295.43, 8976.65)}
    v3757 = CFrame.new(-65.31, 291.76, 9016.91)
    v3758 = CFrame.new(-51.29, 291.75, 8947.06)
    v3759 = CFrame.new(-4, 291.77, 8981.64)
    v3760 = CFrame.new(16.8, 291.75, 8948.87)
    v3761 = CFrame.new(10.99, 291.78, 8933.89)
    v3762 = CFrame.new(-32.71, 291.75, 9046.21)
    v3763 = CFrame.new(32.35, 291.78, 9066.5)
    v3764 = CFrame.new(68.44, 291.79, 9041.04)
    v3765 = CFrame.new(46.99, 291.79, 9048.05)
    v3766 = CFrame.new(12.38, 291.75, 9027.78)
    v3767 = CFrame.new(7.24, 291.75, 9017)
    v3768 = CFrame.new(-39.34, 291.75, 9030.36)
    v3769 = CFrame.new(46.94, 291.75, 8953.94)
    v3770 = CFrame.new(63.63, 291.75, 9001.2)
    v3756 = CFrame.new
    v3755 = {v3757, v3758, v3759, v3760, v3761, v3762, v3763, v3764, v3765, v3766, v3767, v3768, v3769, v3770, v3756(11.44, 291.75, 9044.04)}
    spilledValues1.value1.MapCoordinates = {["Lobby"] = v3740, ["Mil Base"] = spilledValues1.value5, ["Factory"] = spilledValues1.value7, ["Mansion 2"] = spilledValues1.value9, ["Hospital 3"] = spilledValues1.value12, ["Research Facility"] = v3737, ["Hotel 2"] = v3739, ["Bio Lab"] = v3749, ["House 2"] = v3746, ["Office 3"] = v3748, ["Police Station"] = v3751, ["Bank 2"] = v3753, ["Workplace"] = v3755}
    spilledValues1.value2 = function()
        return
    end
    local up179 = {["Notify"] = spilledValues1.value2}
    spilledValues1.value1 = function()
        local v394
        local v393 = gethui and (gethui())
        local v395 = v393
        if not (v393) then
            v394 = game:GetService("CoreGui")
            v393 = v394
            if not (v394) then
                v393 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
            end
            v395 = v393
        end
        v393 = v395
        local v401 = (v393:FindFirstChild("MM2PremiumKey"))
        if v401 then
            v401:Destroy()
        end
        v395 = Instance.new("BindableEvent")
        local up1 = v395
        v395 = game:GetService("TweenService")
        local up2 = v395
        local v399 = (game:GetService("UserInputService"))
        v395 = game:GetService("Players")
        local up3 = v395
        v395 = Instance.new("ScreenGui")
        local up4 = v395
        up4.Name = "MM2PremiumKey"
        up4.Parent = v393
        up4.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        up4.IgnoreGuiInset = true
        v395 = game:GetService("UserInputService")
        v395.MouseIconEnabled = true
        v395 = Instance.new("Frame")
        local up5 = v395
        up5.Size = UDim2.new(1, 0, 1, 0)
        up5.BackgroundColor3 = Color3.fromRGB(4, 4, 10)
        up5.BackgroundTransparency = 1
        up5.BorderSizePixel = 0
        up5.Parent = up4
        v395 = Instance.new("BlurEffect")
        local up6 = v395
        up6.Size = 0
        up6.Parent = game.Lighting
        local v402 = up2
        local v405 = up5
        local v406 = TweenInfo.new(.9, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
        v402:Create(v405, v406, {["BackgroundTransparency"] = .35}):Play()
        v402 = up2
        v405 = up6
        local v404 = TweenInfo.new
        local v408 = Enum.EasingStyle.Cubic
        v402:Create(v405, (v404(.9, v408, Enum.EasingDirection.Out)), {["Size"] = 18}):Play()
        local up7 = 700
        local up8 = 380
        v395 = Instance.new("Frame")
        local up9 = v395
        up9.Name = "MainFrame"
        up9.Size = UDim2.new(0, up7, 0, up8)
        up9.Position = UDim2.new(0.5, ((-up7) / 2), .6, ((-up8) / 2))
        up9.BackgroundTransparency = 1
        up9.BorderSizePixel = 0
        up9.Parent = up4
        v395 = Instance.new("CanvasGroup")
        local up10 = v395
        up10.Name = "Content"
        up10.Size = UDim2.new(1, 0, 1, 0)
        up10.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
        up10.BackgroundTransparency = .05
        up10.BorderSizePixel = 0
        up10.Parent = up9
        v395 = Instance.new("UICorner", up10)
        v395.CornerRadius = UDim.new(0, 18)
        v402 = up2
        v408 = up9
        local v411 = TweenInfo.new
        local v412 = Enum.EasingStyle.Back
        local v414 = Enum.EasingDirection
        v395 = v402.Create
        local v407 = v411(0.75, v412, v414.Out)
        local v413 = UDim2.new(0.5, ((-up7) / 2), 0.5, ((-up8) / 2))
        v395 = v395(v402, v408, v407, {["Position"] = v413})
        v395:Play()
        v408 = (Instance.new("UIStroke"))
        v408.Color = Color3.fromRGB(95, 45, 255)
        v408.Transparency = .2
        v408.Thickness = 2.2
        v408.Parent = up10
        v411 = (Instance.new("ImageLabel"))
        v411.Size = UDim2.new(1, 80, 1, 80)
        v411.Position = UDim2.new(0, -40, 0, -40)
        v411.BackgroundTransparency = 1
        v411.Image = "rbxassetid://6015667104"
        v411.ImageColor3 = Color3.fromRGB(100, 60, 255)
        v411.ImageTransparency = .55
        v411.ZIndex = -1
        v411.Parent = up9
        v407 = (Instance.new("Frame"))
        v407.Size = UDim2.new(0.5, 0, 1, 0)
        v407.Position = UDim2.new(0, 0, 0, 0)
        v407.BackgroundTransparency = 1
        v407.Parent = up10
        local v415 = (Instance.new("ImageLabel"))
        v415.Size = UDim2.new(1, 0, .55, 0)
        v415.BackgroundTransparency = 1
        v415.Image = "rbxassetid://7152226834"
        v415.ImageColor3 = Color3.fromRGB(90, 50, 200)
        v415.ImageTransparency = .72
        v415.ZIndex = 0
        v415.Parent = v407
        v412 = (Instance.new("Frame"))
        v412.Size = UDim2.new(0, 38, 0, 38)
        v412.Position = UDim2.new(0, 22, 0, 22)
        v412.BackgroundColor3 = Color3.fromRGB(95, 45, 255)
        v412.BackgroundTransparency = .15
        v412.Parent = v407
        v395 = Instance.new("UICorner", v412)
        v395.CornerRadius = UDim.new(0, 10)
        v413 = (Instance.new("UIStroke"))
        v413.Color = Color3.fromRGB(160, 110, 255)
        v413.Thickness = 1.5
        v413.Parent = v412
        v414 = (Instance.new("TextLabel"))
        v414.Size = UDim2.new(1, 0, 1, 0)
        v414.BackgroundTransparency = 1
        v414.Font = Enum.Font.GothamBold
        v414.Text = "V"
        v414.TextColor3 = Color3.fromRGB(255, 255, 255)
        v414.TextSize = 21
        v414.Parent = v412
        local v410 = (Instance.new("TextLabel"))
        v410.Size = UDim2.new(1, -80, 0, 22)
        v410.Position = UDim2.new(0, 70, 0, 22)
        v410.BackgroundTransparency = 1
        v410.Font = Enum.Font.GothamBold
        v410.Text = up178.UI_Title or "VELONEX"
        v410.TextColor3 = Color3.fromRGB(255, 255, 255)
        v410.TextSize = 17
        v410.TextXAlignment = Enum.TextXAlignment.Left
        v410.Parent = v407
        local v409 = (Instance.new("TextLabel"))
        v409.Size = UDim2.new(1, -25, 0, 22)
        v409.Position = UDim2.new(0, 0, 0, 22)
        v409.BackgroundTransparency = 1
        v409.Font = Enum.Font.GothamBold
        v395 = tostring
        local v417 = identifyexecutor and (identifyexecutor()) or "Unknown"
        v409.Text = v395(v417)
        v409.TextColor3 = Color3.fromRGB(180, 150, 255)
        v409.TextSize = 17
        v409.TextXAlignment = Enum.TextXAlignment.Right
        v409.Parent = v407
        local v416 = (Instance.new("TextLabel"))
        v416.Size = UDim2.new(1, -80, 0, 15)
        v416.Position = UDim2.new(0, 70, 0, 45)
        v416.BackgroundTransparency = 1
        v416.Font = Enum.Font.Gotham
        v416.Text = "Key System"
        v416.TextColor3 = Color3.fromRGB(140, 130, 175)
        v416.TextSize = 11
        v416.TextXAlignment = Enum.TextXAlignment.Left
        v416.Parent = v407
        v395 = Instance.new("TextButton")
        local up11 = v395
        up11.Name = "CloseBtn"
        up11.Size = UDim2.new(0, 30, 0, 30)
        up11.Position = UDim2.new(1, -40, 0, 18)
        up11.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
        up11.BackgroundTransparency = .4
        up11.ZIndex = 10
        up11.Font = Enum.Font.GothamBold
        up11.Text = "X"
        up11.TextColor3 = Color3.fromRGB(255, 255, 255)
        up11.TextSize = 14
        up11.Parent = up10
        v395 = Instance.new("UICorner", up11)
        v395.CornerRadius = UDim.new(0, 8)
        v402 = up11.MouseEnter
        local v418 = function()
            up2:Create(up11, (TweenInfo.new(0.25)), {["BackgroundTransparency"] = .15}):Play()
            return
        end
        v402:Connect(v418)
        v402 = up11.MouseLeave
        v418 = function()
            local v2620 = up2
            local v2621 = up11
            local v2622 = TweenInfo.new(0.25)
            local v2628 = {["BackgroundTransparency"] = .4}
            v2620:Create(v2621, v2622, v2628):Play()
            return
        end
        v402:Connect(v418)
        v418 = (Instance.new("Frame"))
        v418.Size = UDim2.new(1, -44, 0, 1)
        v418.Position = UDim2.new(0, 22, 0, 72)
        v418.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        v418.BackgroundTransparency = .88
        v418.BorderSizePixel = 0
        v418.Parent = v407
        v395 = Instance.new("ImageLabel")
        local up12 = v395
        up12.Size = UDim2.new(0, 52, 0, 52)
        up12.Position = UDim2.new(0.5, -26, 0, 108)
        up12.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
        up12.BorderSizePixel = 0
        up12.Parent = v407
        v395 = Instance.new("UICorner", up12)
        v395.CornerRadius = UDim.new(1, 0)
        local v420 = (Instance.new("UIStroke"))
        v420.Color = Color3.fromRGB(150, 100, 255)
        v420.Thickness = 2
        v420.Parent = up12
        local v421 = function()
            local v2629 = up12
            local v2630 = up3
            local v2632 = up3.LocalPlayer.UserId
            local v2639 = Enum.ThumbnailType.HeadShot
            v2629.Image = v2630:GetUserThumbnailAsync(v2632, v2639, Enum.ThumbnailSize.Size150x150)

            return
        end
        pcall(v421)
        v421 = (Instance.new("TextLabel"))
        v421.Size = UDim2.new(1, -20, 0, 18)
        v421.Position = UDim2.new(0, 10, 0, 165)
        v421.BackgroundTransparency = 1
        v421.Font = Enum.Font.GothamMedium
        local v423 = up3.LocalPlayer.DisplayName
        v421.Text = ("Welcome, " .. v423)
        v421.TextColor3 = Color3.fromRGB(220, 220, 235)
        v421.TextSize = 13
        v421.Parent = v407
        local v422 = (Instance.new("Frame"))
        v422.Size = UDim2.new(1, -44, 0, 46)
        v422.Position = UDim2.new(0, 22, 0, 195)
        v422.BackgroundColor3 = Color3.fromRGB(8, 6, 14)
        v422.Parent = v407
        v395 = Instance.new("UICorner", v422)
        v395.CornerRadius = UDim.new(0, 11)
        v395 = Instance.new("UIStroke")
        local up13 = v395
        up13.Color = Color3.fromRGB(75, 65, 115)
        up13.Thickness = 1.5
        up13.Parent = v422
        local v424 = (Instance.new("TextLabel"))
        v424.Size = UDim2.new(0, 44, 0, 46)
        v424.BackgroundTransparency = 1
        v424.Font = Enum.Font.Gotham
        v424.Text = "?"
        v424.TextColor3 = Color3.fromRGB(255, 255, 255)
        v424.TextSize = 17
        v424.Parent = v422
        v395 = Instance.new("TextBox")
        local up14 = v395
        up14.Size = UDim2.new(1, -50, 1, 0)
        up14.Position = UDim2.new(0, 42, 0, 0)
        up14.BackgroundTransparency = 1
        up14.Font = Enum.Font.GothamMedium
        up14.PlaceholderText = "Paste your license key..."
        up14.PlaceholderColor3 = Color3.fromRGB(100, 90, 130)
        up14.Text = ""
        up14.TextColor3 = Color3.fromRGB(255, 255, 255)
        up14.TextSize = 13
        up14.TextXAlignment = Enum.TextXAlignment.Left
        up14.ClearTextOnFocus = false
        up14.Parent = v422
        v402 = v422.MouseEnter
        local v426 = function()
            local v2642 = up2
            local v2643 = up13
            local v2644 = TweenInfo.new(.3)
            local v2646 = Color3.fromRGB
            local v2645 = v2642.Create
            local v2647 = v2646(150, 100, 255)
            v2645 = v2645(v2642, v2643, v2644, {["Color"] = v2647})
            v2645:Play()
            return
        end
        v402:Connect(v426)
        v426 = function()
            local v2654, v2656, v2657, v2658, v2659
            local v2655 = up14:IsFocused()
            if (not v2655) then
                v2656 = up2
                v2655 = up13
                v2657 = TweenInfo.new(.3)
                v2658 = Color3.fromRGB
                v2654 = v2656.Create
                v2659 = v2658(75, 65, 115)
                v2654 = v2654(v2656, v2655, v2657, {["Color"] = v2659})
                v2654:Play()
            end
            return
        end
        v422.MouseLeave :Connect(v426)
        v402 = up14.Focused
        v426 = function()
            local v2666 = up2
            local v2667 = up13
            local v2668 = TweenInfo.new(.3)
            local v2670 = Color3.fromRGB(200, 150, 255)
            local v2673 = {["Color"] = v2670}
            v2666:Create(v2667, v2668, v2673):Play()
            return
        end
        v402:Connect(v426)
        v402 = up14.FocusLost
        v426 = function()
            local v2678 = up2
            local v2679 = up13
            local v2680 = TweenInfo.new(.3)
            local v2681 = v2678.Create
            local v2683 = Color3.fromRGB(75, 65, 115)
            v2681 = v2681(v2678, v2679, v2680, {["Color"] = v2683})
            v2681:Play()
            return
        end
        v402:Connect(v426)
        v395 = Instance.new("TextButton")
        local up15 = v395
        up15.Size = UDim2.new(1, -44, 0, 42)
        up15.Position = UDim2.new(0, 22, 0, 253)
        up15.BackgroundColor3 = Color3.fromRGB(110, 45, 220)
        up15.AutoButtonColor = false
        up15.Font = Enum.Font.GothamBold
        up15.Text = "Verify Key"
        up15.TextColor3 = Color3.fromRGB(255, 255, 255)
        up15.TextSize = 14
        up15.Parent = v407
        v395 = Instance.new("UICorner", up15)
        v395.CornerRadius = UDim.new(0, 11)
        v395 = Instance.new("UIGradient")
        local up16 = v395
        v402 = up16
        local v428 = ColorSequence.new
        local v432 = ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 65, 255))
        v402.Color = v428({v432, ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 30, 200))})
        up16.Parent = up15
        v402 = up15.MouseEnter
        v428 = function()
            local v2690 = up2
            local v2691 = up15
            local v2692 = TweenInfo.new(0.25)
            local v2694 = UDim2.new(1, -40, 0, 44)
            local v2698 = UDim2
            local v2701 = v2690.Create
            v2698 = v2698.new(0, 20, 0, 252)
            v2701 = v2701(v2690, v2691, v2692, {["Size"] = v2694, ["Position"] = v2698})
            v2701:Play()
            return
        end
        v402:Connect(v428)
        v402 = up15.MouseLeave
        v428 = function()
            local v2704 = up2
            local v2705 = up15
            local v2706 = TweenInfo.new(0.25)
            local v2708 = UDim2.new(1, -44, 0, 42)
            local v2710 = v2704.Create
            local v2713 = UDim2.new(0, 22, 0, 253)
            v2710 = v2710(v2704, v2705, v2706, {["Size"] = v2708, ["Position"] = v2713})
            v2710:Play()
            return
        end
        v402:Connect(v428)
        v428 = (Instance.new("TextLabel"))
        v428.Size = UDim2.new(1, -44, 0, 16)
        v428.Position = UDim2.new(0, 22, 0, 303)
        v428.BackgroundTransparency = 1
        v428.Font = Enum.Font.Gotham
        v428.Text = ""
        v428.TextColor3 = Color3.fromRGB(110, 100, 145)
        v428.TextSize = 10
        v428.Parent = v407
        local v429 = (Instance.new("Frame"))
        v429.Size = UDim2.new(0.5, 0, 1, 0)
        v429.Position = UDim2.new(0.5, 0, 0, 0)
        v429.BackgroundTransparency = 1
        v429.ClipsDescendants = true
        v429.Parent = up10
        local v430 = (Instance.new("ImageLabel"))
        v430.Size = UDim2.new(1, 0, 1, 0)
        v430.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
        v430.BorderSizePixel = 0
        v430.Image = "rbxthumb://type=GameThumbnail&id=142823291&w=768&h=432"
        v430.ImageTransparency = .05
        v430.ScaleType = Enum.ScaleType.Crop
        v430.Parent = v429
        local v431 = (Instance.new("Frame"))
        v431.Size = UDim2.new(1, 0, 1, 0)
        v431.BackgroundColor3 = Color3.fromRGB(4, 3, 12)
        v431.BackgroundTransparency = .45
        v431.BorderSizePixel = 0
        v431.Parent = v429
        v432 = (Instance.new("TextLabel"))
        v432.Size = UDim2.new(1, 0, 0, 36)
        v432.Position = UDim2.new(0, 0, 0, 60)
        v432.BackgroundTransparency = 1
        v432.Font = Enum.Font.GothamBold
        v432.Text = "Murder Mystery 2"
        v432.TextColor3 = Color3.fromRGB(255, 255, 255)
        v432.TextSize = 24
        v432.TextXAlignment = Enum.TextXAlignment.Center
        v432.Parent = v429
        local v433 = (Instance.new("Frame"))
        v433.Size = UDim2.new(0, 180, 0, 2)
        v433.Position = UDim2.new(0.5, -90, 0, 100)
        v433.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        v433.BorderSizePixel = 0
        v433.Parent = v429
        local v434 = (Instance.new("TextLabel"))
        v434.Size = UDim2.new(1, -15, 0, 16)
        v434.Position = UDim2.new(0, 8, 1, -26)
        v434.BackgroundTransparency = 1
        v434.Font = Enum.Font.Gotham
        v434.Text = ""
        v434.TextColor3 = Color3.fromRGB(80, 75, 110)
        v434.TextSize = 10
        v434.TextXAlignment = Enum.TextXAlignment.Right
        v434.Parent = v429
        local up19
        local up18
        local up17
        up9.InputBegan:Connect(function(arg225_1)
            local v2718 = arg225_1
            local v2723 = v2718.UserInputType
            local v2719 = Enum.UserInputType
            if (v2723 == v2719.MouseButton1 ) then
                up19 = true
                up18 = v2718.Position
                up17 = up9.Position
            end
            return
        end)
        v402 = v399.InputChanged
        local v435 = function(arg226_1)
            local v2734, v2739
            local v2728 = up19
            local v2729 = v2728
            local v2730 = arg226_1
            if v2728 then
                v2729 = (v2730.UserInputType == Enum.UserInputType.MouseMovement)
            end
            if v2729 then
                v2728 = (v2730.Position - up18)
                v2739 = up9
                v2734 = UDim2.new(up17.X.Scale, (up17.X.Offset + v2728.X), up17.Y.Scale, (up17.Y .Offset + v2728.Y))
                v2739.Position = v2734
            end
            return
        end
        v402:Connect(v435)
        v402 = v399.InputEnded
        v435 = function(arg227_1)
            local v2749 = arg227_1.UserInputType
            local v2745 = Enum.UserInputType
            if (v2749 == v2745["MouseButton1"]) then
            end
            return
        end
        v402:Connect(v435)
        local up21 = function()
            local v2754 = up2
            local v2755 = up9
            local v2756 = TweenInfo.new(.55, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
            local v2757 = UDim2.new
            local v2765 = ((-up7) / 2)
            local v2764 = (-up8)
            local v2767 = v2754.Create
            local v2758 = v2757(0.5, v2765, .65, (v2764 / 2))
            v2767 = v2767(v2754, v2755, v2756, {["Position"] = v2758})
            v2767:Play()
            v2754 = up2
            v2755 = up10
            v2756 = TweenInfo.new(.55)
            v2754:Create(v2755, v2756, {["BackgroundTransparency"] = 1}):Play()
            v2754 = up2
            v2755 = up5
            v2756 = TweenInfo.new(.55)
            v2754:Create(v2755, v2756, {["BackgroundTransparency"] = 1}):Play()
            v2754 = up2
            v2755 = up6
            v2756 = TweenInfo.new(.55)
            v2754:Create(v2755, v2756, {["Size"] = 0}):Play()
            task.wait(.55)
            up4:Destroy()
            up6:Destroy()
            return
        end
        local up20 = false
        v402 = up11.MouseButton1Click
        local v440 = function()
            local v2769, v2770, v2772, v2773, v2776, v2781
            if (not up20) then
                up20 = true
                v2769 = up11
                v2769.Text = "Sure?"
                v2769 = up2
                v2770 = up11
                v2772 = TweenInfo.new(.3, Enum.EasingStyle.Back)
                v2776 = UDim2.new(0, 65, 0, 30)
                v2781 = UDim2
                v2773 = v2769.Create
                v2781 = v2781.new(1, -75, 0, 18)
                v2773 = v2773(v2769, v2770, v2772, {["Size"] = v2776, ["Position"] = v2781})
                v2773:Play()
                task.delay(3, function()
                    local v3692, v3693, v3695, v3696, v3699, v3700, v3701
                    if up20 then
                        v3692 = up11
                        v3692.Text = "X"
                        v3692 = up2
                        v3693 = up11
                        v3695 = TweenInfo.new(.3)
                        v3699 = UDim2.new(0, 30, 0, 30)
                        v3700 = UDim2.new
                        v3696 = v3692.Create
                        v3701 = v3700(1, -40, 0, 18)
                        v3696 = v3696(v3692, v3693, v3695, {["Size"] = v3699, ["Position"] = v3701})
                        v3696:Play()
                    end
                    return
                end)
            else
                v2769 = _G
                v2769.VelonexLoaded = false
                up21()
                up1:Fire(false)
            end
            return
        end
        v402:Connect(v440)
        v402 = up15.MouseButton1Click
        v440 = function()
            local v2790, v2794
            local v2784 = Instance.new("Frame")
            local up125 = v2784
            up125.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            up125.BackgroundTransparency = 0.5
            up125.Size = UDim2.new(0, 0, 0, 0)
            up125.Position = UDim2.new(0.5, 0, 0.5, 0)
            up125.AnchorPoint = Vector2.new(0.5, 0.5)
            v2784 = Instance.new("UICorner", up125)
            v2784.CornerRadius = UDim.new(1, 0)
            up125.Parent = up15
            local v2788 = up2
            local v2785 = up125
            local v2787 = TweenInfo.new(.4)
            local v2791 = UDim2
            v2784 = v2788.Create
            v2791 = v2791.new (0, 220, 0, 220)
            v2784 = v2784(v2788, v2785, v2787, {["Size"] = v2791, ["BackgroundTransparency"] = 1})
            v2784:Play()
            v2784 = task
            local v2786 = function()
                up125:Destroy()
                return
            end
            v2784.delay (.4, v2786)
            v2784 = up14.Text:gsub("%s+", "")
            v2786 = up178
            if (v2784 == v2786["Key"]) then
                v2788 = up15
                v2788.Text = "AUTHENTICATED"
                v2788 = up16
                v2787 = ColorSequence.new(Color3.fromRGB(35, 190, 90))
                v2788.Color = v2787
                task.wait (.7)
                up21()
                up1:Fire(true)
            else
                v2788 = up15
                v2788.Text = "INVALID LICENSE"
                v2788 = up16
                v2787 = ColorSequence.new(Color3.fromRGB(210, 45, 45))
                v2788.Color = v2787
                task.wait(1.2)
                v2788 = up15
                v2788.Text = "Verify Key"
                v2788 = up16
                v2786 = ColorSequence.new
                v2791 = ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 55, 255))
                v2790 = ColorSequenceKeypoint.new
                v2794 = Color3.fromRGB
                v2787 = v2786({v2791, v2790(1, v2794(75, 25, 195))})
                v2788.Color = v2787
            end
            return
        end
        v402:Connect(v440)

        return up1.Event:Wait()
    end
    Instance.new("BindableEvent")
    v3740 = game:GetService("Players")
    local up180 = v3740
    game:GetService("ReplicatedStorage")
    spilledValues1.value5 = game:GetService("TweenService")
    local up181 = spilledValues1.value5
    game:GetService("RunService")
    game:GetService("UserInputService")
    game:GetService("Lighting")
    spilledValues1.value5 = up180.LocalPlayer
    spilledValues1.value9 = workspace
    spilledValues1.value11 = _G
    spilledValues1.value11.ChamsFillTransparency = 0.5
    spilledValues1.value11 = _G
    spilledValues1.value11.ChamsMode = "Textured"
    local up182 = 1
    spilledValues1.value11 = _G
    v3737 = function(arg20_1)
        local v447, v448, v452, v453, v454, v455, v456, v457, v458, v459, v460, v461, v463, v464, v465, v466
        local v444 = arg20_1
        local v451 = game.Players.LocalPlayer
        local v446 = "Character"
        local v445 = v451
        local v449 = v445[v446]
        local v450 = v449
        if v449 then
            v450 = (v445.Character:FindFirstChild("HumanoidRootPart"))
        end
        v449 = v450
        if (not v449) then
            v451 = false
            return v451
        else
            v446 = "None"
            v447 = (workspace:FindFirstChild("Normal"))
            v450 = _G
            if v450["MapCoordinates"] then
                v451 = pairs
                v454 = _G
                for v452, v458 in v451(v454.MapCoordinates ) do
                    v454 = v452
                    if (v454 ~= "Lobby") then
                        v457 = workspace:FindFirstChild(v454)
                        v455 = v457
                        if not (v457) then
                            v455 = v447 and (v447:FindFirstChild(v454))
                        end
                        if v455 then
                            v446 = v454
                            break
                        end
                    end
                end
            end
            if (v446 == "None") then
                v452 = workspace:FindFirstChild("CoinContainer", true)
                v448 = v452
                if v452 then
                    v455 = v452.Parent
                    v454 = v455
                    if v455 then
                        v457 = (v452.Parent.Name ~= "Lobby")
                        v455 = v457
                        if v457 then
                            v460 = (v452.Parent.Name ~= "Workspace")
                            v457 = v460
                            if v460 then
                                v457 = (v452.Parent.Name ~= "Normal")
                            end
                            v455 = v457
                        end
                        v454 = v455
                    end
                    v448 = v454
                end
                if v448 then
                    v446 = v452.Parent.Name
                else
                    if v447 then
                        v457 = v447.GetChildren
                        for v455, v456 in ipairs(v457(v447)) do
                            v460 = (v456:IsA("Model")) or (v456:IsA("Folder"))
                            v457 = v460
                            if v460 then
                                v461 = (v456.Name ~= "Lobby")
                                v460 = v461
                                if v461 then
                                    v463 = (v456.Name ~= "Spawns")
                                    v461 = v463
                                    if v463 then
                                        v466 = (v456.Name ~= "CoinContainer")
                                        v463 = v466
                                        if v466 then
                                            v463 = (v456.Name ~= "GLight")
                                        end
                                        v461 = v463
                                    end
                                    v460 = v461
                                end
                                v457 = v460
                            end
                            if v457 then
                                v446 = v456.Name
                            else
                                continue
                            end
                            break
                        end
                    end
                end
            end
            v452 = (v446 ~= "None") and (v446 ~= "Lobby")
            if v452 then
                v452 = nil
                v458 = _G.MapCoordinates
                v453 = v458
                if v458 then
                    v453 = _G.MapCoordinates[v446]
                end
                if v453 then
                    v452 = v446
                else
                    v458 = _G
                    if v458["MapCoordinates"] then
                        v458 = v446:lower():gsub("%s+", "")
                        v454 = pairs
                        v464 = _G
                        for v459, v460 in v454(v464.MapCoordinates) do
                            v454 = v459
                            v461 = v454:lower():gsub("%s+", "")
                            v463 = (v461 == v458)
                            v464 = v463
                            if not (v463) then
                                v464 = (v458:find(v461)) or (v461:find(v458))
                            end
                            if v464 then
                                v452 = v454
                            else
                                continue
                            end
                            break
                        end
                    end
                end
                v454 = v452
                if v452 then
                    v454 = _G.MapCoordinates[v452]
                end
                if v454 then
                    v454 = _G.MapCoordinates[v452]
                    up182 = ((up182 % (#v454)) + 1)
                    v456 = (v454[up182] + (Vector3.new(0, 3, 0)))
                    v449.CFrame = v456
                    if v444 then
                        v455 = up179
                        v463 = string.format
                        v456 = v455.Notify
                        v465 = v463("Teleported to %s (Spot %d)", v452, up182)
                        v456(v455, {["Title"] = "Map Teleport", ["Content"] = v465, ["Duration"] = 2})
                    end
                    return true
                else
                    v459 = workspace:FindFirstChild(v446)
                    v454 = v459
                    if not (v459) then
                        v454 = v447 and (v447:FindFirstChild(v446))
                    end
                    if v454 then
                        v455 = v454:FindFirstChildWhichIsA("BasePart", true)
                        if v455 then
                            v459 = (v455.CFrame + (Vector3.new(0, 10, 0)))
                            v449.CFrame = v459
                            if v444 then
                                v456 = up179
                                v465 = ("Teleported to " .. v446)
                                v456:Notify({["Title"] = "Map Teleport", ["Content"] = v465, ["Duration"] = 2})
                            end
                            return true
                        end
                    end
                end
            end
            if v444 then
                up179:Notify({["Title"] = "Teleport", ["Content"] = "Map not detected yet. Round might not have started.", ["Duration"] = 3})
            end
            return false
        end
    end
    spilledValues1.value11.TeleportToMap = v3737
    spilledValues1.value10 = game:GetService("TweenService")
    local up183 = spilledValues1.value10
    v3737 = game:GetService("RunService")
    spilledValues1.value10 = _G
    v3739 = function()
        pcall(function()
            local v1552 = (Instance.new("Sound"))
            v1552.SoundId = "rbxassetid://6895079853"
            v1552.Volume = 4
            v1552.Parent = game:GetService("SoundService")
            v1552:Play()
            game:GetService("Debris"):AddItem(v1552, 1)

            return
        end)

        return
    end
    spilledValues1.value10.PlayUISound = v3739
    spilledValues1.value10 = function(arg22_1)
        local v475, v477
        v475, v477 = pcall(arg22_1)
        return v475, v477
    end
    v3736 = function(arg23_1, arg23_2)
        local up22 = arg23_1
        local up23 = arg23_2
        local v479 = function()
            local v3294 = up179
            local v3297 = up22
            local v3299 = up23 and "ENABLED" or "DISABLED"
            v3294:Notify({["Title"] = v3297, ["Content"] = v3299, ["Duration"] = 2})

            return
        end
        pcall(v479)

        return
    end
    v3739 = _G
    v3739.RoleCache = {}
    v3739 = function()
        local v483 = function()
            local v362, v363, v365, v368, v369
            local v366 = (game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true))
            if v366 then
                v363 = (v366:InvokeServer())
                if v363 then
                    v362 = pairs
                    for v365, v368 in v362(v363) do
                        v362 = _G.RoleCache
                        v369 = v368.Role
                        v362[v365] = v369
                    end
                end
            end
            return
        end
        pcall(v483)

        return
    end
    v3749 = Instance.new("ScreenGui")
    v3744 = Instance.new("TextLabel")
    local up184 = v3744
    v3749.Name = "VelonexRoleLeak"
    v3747 = game:GetService("CoreGui")
    v3749.Parent = v3747
    v3749.IgnoreGuiInset = true
    v3744 = up184
    v3744.Name = "RoleLabel"
    v3744 = up184
    v3744.Parent = v3749
    v3744 = up184
    v3748 = Color3.fromRGB(0, 0, 0)
    v3744.BackgroundColor3 = v3748
    v3744 = up184
    v3744.BackgroundTransparency = 1
    v3744 = up184
    v3748 = UDim2.new(0.5, -150, 0, 20)
    v3744.Position = v3748
    v3744 = up184
    v3748 = UDim2.new(0, 300, 0, 40)
    v3744.Size = v3748
    v3744 = up184
    v3747 = Enum.Font.GothamBold
    v3744.Font = v3747
    v3744 = up184
    v3744.Text = ""
    v3744 = up184
    v3748 = Color3.fromRGB(255, 255, 255)
    v3744.TextColor3 = v3748
    v3744 = up184
    v3744.TextSize = 24
    v3744 = up184
    v3744.TextStrokeTransparency = 0.5
    v3744 = up184
    v3744.Visible = false
    v3744 = task.spawn
    v3747 = function()
        local v488
        local up24 = ""
        while true do
            v488 = function()
                local v2001, v2002, v2003, v2005, v2007, v2008, v2009, v2013, v2014
                local v2004 = (game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true))
                if v2004 then
                    v2001 = (v2004:InvokeServer())
                    if v2001 then
                        v2002 = false
                        for v2005, v2007 in pairs(v2001) do
                            v2008 = v2005
                            v2013 = v2007.Role
                            v2014 = v2013
                            if v2013 then
                                v2009 = (v2007.Role ~= "")
                                v2013 = v2009
                                if v2009 then
                                    v2013 = (v2007.Role ~= "Innocent")
                                end
                                v2014 = v2013
                            end
                            if v2014 then
                                v2002 = true
                            end
                            v2014 = _G.RoleCache
                            v2013 = v2007.Role
                            v2014[v2008] = v2013
                        end
                        v2003 = v2001[game.Players.LocalPlayer.Name ]
                        v2005 = v2003
                        if v2003 then
                            v2005 = (v2003.Role ~= "")
                        end
                        if v2005 then
                            v2005 = v2003.Role
                            if (v2005 ~= up24) then
                                up24 = v2005
                                v2008 = up184
                                v2014 = v2005:upper()
                                v2008.Text = v2014
                                if (v2005 == "Murderer") then
                                    v2008 = up184
                                    v2013 = Color3.fromRGB(255, 60, 60)
                                    v2008.TextColor3 = v2013
                                else
                                    v2008 = (v2005 == "Sheriff") or (v2005 == "Hero")
                                    if v2008 then
                                        v2008 = up184
                                        v2013 = Color3.fromRGB(60, 150, 255)
                                        v2008.TextColor3 = v2013
                                    else
                                        v2008 = up184
                                        v2013 = Color3.fromRGB(60, 255, 120)
                                        v2008.TextColor3 = v2013
                                    end
                                end
                                v2008 = up184
                                v2008.Visible = true
                                task.delay(15, function()
                                    up184.Visible = false
                                    return
                                end)
                            end
                        else
                            if (not v2002) then
                                up24 = ""
                                v2008 = _G
                                v2008.RoleCache = {}
                                v2008 = up184
                                v2008.Visible = false
                            end
                        end
                        if (not v2002) then
                            task.wait(0.5)
                        else
                            task.wait(8)
                        end
                    else
                        task.wait(2)
                    end
                else
                    task.wait(2)
                end
                return
            end
            pcall(v488)
        end
    end
    v3744(v3747)
    v3746 = function(arg26_1)
        local v497, v498
        local up25 = arg26_1
        local v490 = up25
        local v491 = v490
        if v490 then
            v491 = up25.Parent
        end
        if (not v491) then
            return
        else
            v497 = pcall
            v498 = function()
                local v3615, v3616, v3617, v3618, v3619, v3620, v3622, v3624, v3625, v3626, v3628, v3629
                local v3621 = _G.RoleCache[up25.Name]
                if (v3621 == "Murderer") then
                    return
                else
                    v3618 = up25.Character
                    v3619 = up25:FindFirstChild("Backpack")
                    v3621 = function(arg280_1)
                        local v3339, v3343, v3345, v3346, v3347, v3349, v3350
                        local v3338 = arg280_1
                        if (not v3338) then
                            v3339 = nil
                            return v3339
                        else
                            v3339 = pairs
                            for v3343, v3345 in v3339(v3338:GetChildren()) do
                                v3339 = v3345:IsA("Tool")
                                if v3339 then
                                    v3349 = v3345.Name:lower()
                                    v3347 = (v3349 == "knife")
                                    v3346 = v3347
                                    if not (v3347) then
                                        v3350 = (v3349 == "murdererknife")
                                        v3347 = v3350
                                        if not (v3350) then
                                            v3347 = (v3349:find("blade"))
                                        end
                                        v3346 = v3347
                                    end
                                    if v3346 then
                                        v3339 = "Murderer"
                                        return v3339
                                    else
                                        v3347 = (v3349 == "gun")
                                        v3346 = v3347
                                        if not (v3347) then
                                            v3346 = (v3349 == "revolver") or (v3349 == "sheriffgun")
                                        end
                                        if v3346 then
                                            v3339 = "Sheriff"
                                            return v3339
                                        end
                                    end
                                end
                            end
                            v3339 = nil
                            return v3339
                        end
                    end
                    v3615 = v3619
                    v3616 = v3621
                    v3617 = (v3616(v3618)) or (v3616(v3615))
                    if v3617 then
                        if (v3617 == "Sheriff") then
                            v3621 = pairs
                            v3624 = _G
                            for v3622, v3628 in v3621(v3624.RoleCache) do
                                v3629 = up25
                                v3624 = v3622
                                v3626 = (v3624 ~= v3629.Name)
                                v3625 = v3626
                                if v3626 then
                                    v3625 = (v3628 == "Sheriff") or (v3628 == "Hero")
                                end
                                if v3625 then
                                    v3621 = _G.RoleCache
                                    v3621[v3624] = "Innocent"
                                end
                            end
                        end
                        v3621 = _G.RoleCache
                        v3620 = up25.Name
                        v3621[v3620] = v3617
                    end
                    return
                end
            end
            v497(v498)            return
        end
    end
    local up185 = v3746
    v3746 = _G
    v3748 = _G.LastRoleScan or {}
    v3746.LastRoleScan = v3748
    local up186
    v3748 = function()
        local v3155, v3156, v3157, v3159, v3160, v3161, v3162, v3163, v3164, v3165
        local v3154 = _G
        if v3154["IsCollectingGun"] then
            return
        else
            v3160 = game.Players.LocalPlayer
            local up138 = v3160
            v3155 = (not up138.Character)
            v3154 = v3155
            if not (v3155) then
                v3157 = (not (up138.Character:FindFirstChild("Humanoid")))
                v3155 = v3157
                if not (v3157) then
                    v3155 = (up138.Character.Humanoid.Health <= 0)
                end
                v3154 = v3155
            end
            if v3154 then
                return
            else
                v3155 = (up186(up138))
                v3156 = (v3155 == "Murderer")
                v3154 = v3156
                if not (v3156) then
                    v3154 = (v3155 == "Sheriff") or (v3155 == "Hero")
                end
                if v3154 then
                    return
                else
                    v3157 = up138.Character:FindFirstChild("Gun")
                    v3154 = v3157
                    if not (v3157) then
                        v3154 = (up138.Backpack:FindFirstChild("Gun"))
                    end
                    if v3154 then
                        return
                    else
                        v3157 = workspace:FindFirstChild("GunDrop", true)
                        v3154 = v3157
                        if not (v3157) then
                            v3154 = (workspace:FindFirstChild("Gun Drop", true))
                        end
                        local up139 = v3154
                        v3159 = up139
                        v3154 = v3159
                        if v3159 then
                            v3154 = up139.Parent
                        end
                        if (not v3154) then
                            return
                        else
                            v3160 = _G
                            v3159 = v3160
                            v3157 = _G.IgnoredGuns or {}
                            v3160 = v3159
                            v3160.IgnoredGuns = v3157
                            v3157 = _G
                            if v3157["IgnoredGuns"][up139] then
                                return
                            else
                                v3159 = up138.Character
                                v3154 = v3159
                                if v3159 then
                                    v3154 = (up138.Character:FindFirstChild("HumanoidRootPart"))
                                end
                                if (not v3154) then
                                    return
                                else
                                    v3160 = _G
                                    v3160.IsCollectingGun = true
                                    v3157 = up138.Character.HumanoidRootPart
                                    v3159 = v3157.CFrame
                                    v3164 = up139:IsA("Model")
                                    v3161 = v3164
                                    if v3164 then
                                        v3161 = up139:GetPivot().Position
                                    end
                                    v3154 = v3161
                                    if not (v3161) then
                                        v3154 = up139.Position
                                    end
                                    v3161 = v3154
                                    v3162 = (CFrame.new((v3161 + (Vector3.new(0, 1.2, 0)))))
                                    v3157.CFrame = v3162
                                    if firetouchinterest then
                                        v3164 = up139:FindFirstChild("Handle")
                                        v3154 = v3164
                                        if not (v3164) then
                                            v3165 = (up139:IsA("BasePart")) and up139
                                            v3163 = v3165
                                            if not (v3165) then
                                                v3163 = (up139:FindFirstChildWhichIsA("BasePart", true))
                                            end
                                            v3154 = v3163
                                        end
                                        v3163 = v3154
                                        if v3163 then
                                            firetouchinterest(v3157, v3163, 0)
                                            firetouchinterest(v3157, v3163, 1)
                                        end
                                    end
                                    task.wait()
                                    v3157.CFrame = v3159
                                    task.delay(0, function()
                                        local v3462
                                        local v3464 = up186(up138)
                                        local v3465 = up138
                                        local v3463 = v3464
                                        v3465 = v3465.Character:FindFirstChild("Gun")
                                        v3464 = v3465
                                        if not (v3465) then
                                            v3464 = (up138.Backpack:FindFirstChild("Gun"))
                                        end
                                        local v3470 = v3464
                                        v3465 = (v3463 ~= "Sheriff")
                                        v3464 = v3465
                                        if v3465 then
                                            v3464 = (v3463 ~= "Hero") and (not v3470)
                                        end
                                        if v3464 then
                                            v3462 = _G.IgnoredGuns
                                            v3464 = up139
                                            v3462[v3464] = true
                                        end
                                        _G.IsCollectingGun = false
                                        return
                                    end)

                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    v3747 = function(arg267_1)
        local v3176, v3177, v3178, v3179, v3180, v3181, v3182, v3183, v3185, v3186, v3187, v3188, v3189
        local v3173 = arg267_1
        local v3174 = v3173 and v3173.Parent
        if (not v3174) then
            v3181 = "Innocent"
            return v3181
        else
            v3181 = v3173.Name
            v3179 = _G
            v3180 = v3181
            v3179 = v3179.RoleCache[v3180]
            if (v3179 == "Murderer") then
                v3181 = "Murderer"
                return v3181
            else
                v3174 = tick()
                v3177 = _G
                v3178 = v3174
                if ((v3178 - (v3177["LastRoleScan"][v3180] or 0)) < .3) then
                    v3174 = v3179 or "Innocent"
                    return v3174
                else
                    v3174 = _G.LastRoleScan
                    v3174[v3180] = v3178
                    v3176 = v3173.Character
                    v3177 = (v3173:FindFirstChild("Backpack"))
                    v3185 = function(arg149_1)
                        local v1840, v1844, v1846, v1847, v1848, v1850, v1851, v1853, v1855, v1857
                        local v1839 = arg149_1
                        if (not v1839) then
                            v1840 = nil
                            return v1840
                        else
                            v1840 = ipairs
                            for v1844, v1846 in v1840(v1839:GetChildren()) do
                                v1840 = v1846:IsA("Tool")
                                if v1840 then
                                    v1850 = v1846.Name:lower()
                                    v1848 = v1850:find("knife")
                                    v1847 = v1848
                                    if not (v1848) then
                                        v1851 = v1850:find("blade")
                                        v1848 = v1851
                                        if not (v1851) then
                                            v1853 = v1850:find("saw")
                                            v1851 = v1853
                                            if not (v1853) then
                                                v1855 = v1850:find("scythe")
                                                v1853 = v1855
                                                if not (v1855) then
                                                    v1857 = v1850:find("axe")
                                                    v1855 = v1857
                                                    if not (v1857) then
                                                        v1855 = (v1850:find("bat"))
                                                    end
                                                    v1853 = v1855
                                                end
                                                v1851 = v1853
                                            end
                                            v1848 = v1851
                                        end
                                        v1847 = v1848
                                    end
                                    if v1847 then
                                        v1840 = "Murderer"
                                        return v1840
                                    else
                                        v1848 = v1850:find("gun")
                                        v1847 = v1848
                                        if not (v1848) then
                                            v1851 = v1850:find("revolver")
                                            v1848 = v1851
                                            if not (v1851) then
                                                v1853 = v1850:find("sheriffgun")
                                                v1851 = v1853
                                                if not (v1853) then
                                                    v1855 = v1850:find("blaster")
                                                    v1853 = v1855
                                                    if not (v1855) then
                                                        v1853 = (v1850:find("pistol"))
                                                    end
                                                    v1851 = v1853
                                                end
                                                v1848 = v1851
                                            end
                                            v1847 = v1848
                                        end
                                        if v1847 then
                                            v1840 = "Sheriff"
                                            return v1840
                                        end
                                    end
                                end
                            end
                            v1840 = nil
                            return v1840
                        end
                    end
                    v3183 = v3176 and (v3185(v3176))
                    v3174 = v3183
                    if not (v3183) then
                        v3174 = v3177 and (v3185(v3177))
                    end
                    v3182 = v3174
                    if v3182 then
                        v3174 = _G.RoleCache
                        v3174[v3180] = v3182
                        if (v3182 == "Sheriff") then
                            v3174 = pairs
                            v3188 = _G
                            v3187 = v3188.RoleCache
                            for v3186, v3188 in v3174(v3187) do
                                v3187 = v3186
                                v3189 = (v3187 ~= v3180)
                                v3174 = v3189
                                if v3189 then
                                    v3174 = (v3188 == "Sheriff") or (v3188 == "Hero")
                                end
                                if v3174 then
                                    v3174 = _G.RoleCache
                                    v3174[v3187] = "Innocent"
                                end
                            end
                        end
                        return v3182
                    else
                        v3174 = v3179 or "Innocent"
                        return v3174
                    end
                end
            end
        end
    end
    v3752 = function(arg268_1)
        local up140 = arg268_1
        up185(up140)
        local v3199 = up140
        local v3198 = function(arg275_1)
            local up142 = arg275_1
            up185(up140)
            local v3308 = up142.ChildAdded
            local v3309 = function()
                up185(up140)
                return
            end
            v3308:Connect(v3309)
            v3308 = up142.ChildRemoved
            v3309 = function()
                up185(up140)
                return
            end
            v3308:Connect(v3309)
            v3309 = function()
                local v3548, v3549, v3550, v3553
                local v3552 = (up142:WaitForChild("Humanoid", 5))
                if v3552 then
                    v3548 = _G.DeadPlayers
                    v3553 = up140.UserId
                    v3550 = v3552.Health
                    v3548[v3553] = (v3550 <= 0)
                    v3548 = v3552.HealthChanged
                    v3549 = function(arg127_1)
                        local v1561 = _G.DeadPlayers
                        local v1556 = up140.UserId
                        v1561[v1556] = (arg127_1 <= 0)

                        return
                    end
                    v3548:Connect(v3549)
                    v3549 = function()
                        local v1568 = _G.DeadPlayers
                        local v1563 = up140.UserId
                        v1568[v1563] = true
                        return
                    end
                    v3552.Died:Connect(v3549)
                end
                return
            end
            pcall(v3309)

            return
        end
        v3199.CharacterAdded:Connect(v3198)
        v3199 = up140
        if v3199["Character"] then
            v3198(up140.Character)
        end
        local v3197 = function(arg134_1)
            up185(up140)
            local v1675 = function()
                up185(up140)
                return
            end
            arg134_1.ChildAdded :Connect(v1675)
            v1675 = function()
                up185(up140)
                return
            end
            arg134_1.ChildRemoved :Connect(v1675)

            return
        end
        local up141 = v3197
        v3197 = up140.ChildAdded
        local v3200 = function(arg135_1)
            local v1683 = arg135_1
            local v1684 = v1683:IsA("Backpack")
            local v1685 = v1684
            if not (v1684) then
                v1685 = (v1683.Name == "Backpack")
            end
            if v1685 then
                up141(v1683)
            end
            return
        end
        v3197:Connect(v3200)
        v3200 = (up140:FindFirstChild("Backpack"))
        if v3200 then
            up141(v3200)
        end
        return
    end
    up186 = v3747
    v3751 = function(arg269_1)
        local v3207, v3208, v3209, v3210, v3212, v3213, v3215, v3216, v3217, v3219, v3220, v3222, v3224, v3226, v3228
        local v3206 = arg269_1
        if (not v3206) then
            v3207 = nil
            return v3207
        else
            v3208 = v3206.Character
            v3209 = nil
            if v3208 then
                v3212 = v3208.GetChildren
                v3207 = pairs
                for v3213, v3215 in v3207(v3212(v3208)) do
                    v3207 = v3215:IsA("Tool")
                    if v3207 then
                        v3219 = v3215.Name:lower()
                        v3217 = v3219:find("knife")
                        v3216 = v3217
                        if not (v3217) then
                            v3220 = v3219:find("blade")
                            v3217 = v3220
                            if not (v3220) then
                                v3222 = v3219:find("saw")
                                v3220 = v3222
                                if not (v3222) then
                                    v3224 = v3219:find("scythe")
                                    v3222 = v3224
                                    if not (v3224) then
                                        v3222 = (v3219:find("axe")) or (v3219:find("bat"))
                                    end
                                    v3220 = v3222
                                end
                                v3217 = v3220
                            end
                            v3216 = v3217
                        end
                        if v3216 then
                            return v3215
                        else
                            v3209 = v3215
                        end
                    end
                end
            end
            v3210 = v3206:FindFirstChild("Backpack")
            if v3210 then
                v3213 = pairs
                v3216 = v3210.GetChildren
                for v3215, v3219 in v3213(v3216(v3210)) do
                    v3216 = v3219:IsA("Tool")
                    if v3216 then
                        v3217 = v3219.Name:lower()
                        v3220 = v3217:find("knife")
                        v3216 = v3220
                        if not (v3220) then
                            v3222 = v3217:find("blade")
                            v3220 = v3222
                            if not (v3222) then
                                v3224 = v3217:find("saw")
                                v3222 = v3224
                                if not (v3224) then
                                    v3226 = v3217:find("scythe")
                                    v3224 = v3226
                                    if not (v3226) then
                                        v3228 = v3217:find("axe")
                                        v3226 = v3228
                                        if not (v3228) then
                                            v3226 = (v3217:find("bat"))
                                        end
                                        v3224 = v3226
                                    end
                                    v3222 = v3224
                                end
                                v3220 = v3222
                            end
                            v3216 = v3220
                        end
                        if v3216 then
                            return v3219
                        else
                            if (not v3209) then
                                v3209 = v3219
                            end
                        end
                    end
                end
            end
            return v3209
        end
    end
    local up187 = v3748
    GetPlayerAbility = function(arg270_1)
        local v3235, v3237, v3238
        local v3234 = arg270_1
        local v3236 = (game:GetService("ReplicatedStorage"):FindFirstChild("PlayerData"))
        local v3233 = v3236
        if v3236 then
            v3238 = v3234.Name
            v3233 = (v3236:FindFirstChild(v3238))
        end
        if v3233 then
            v3237 = v3236[v3234.Name]
            v3238 = (v3237:FindFirstChild("EquippedAbility")) or (v3237:FindFirstChild("EquippedAbilityV2"))
            v3233 = v3238 and v3238.Value or "None"
            return v3233
        else
            v3235 = "Unknown"
            return v3235
        end
    end
    GetPlayerPerk = function(arg271_1)
        local v3249, v3252
        local v3247 = arg271_1
        local v3250 = (game:GetService("ReplicatedStorage"):FindFirstChild("PlayerData"))
        local v3248 = v3250
        if v3250 then
            v3252 = v3247.Name
            v3248 = (v3250:FindFirstChild(v3252))
        end
        if v3248 then
            v3252 = (v3250[v3247.Name]:FindFirstChild("EquippedPerk"))
            v3248 = v3252 and v3252.Value or "None"
            return v3248
        else
            v3249 = "Unknown"
            return v3249
        end
    end
    local up188 = function()
        return ((up186(game.Players.LocalPlayer)) == "Murderer")
    end
    local up189 = v3751
    v3751 = function(arg273_1)
        local v3272, v3273, v3274, v3275, v3277, v3279, v3280, v3281, v3282, v3283, v3284, v3285, v3286, v3287, v3289
        local v3271 = arg273_1
        if (not v3271) then
            v3272 = nil
            return v3272
        else
            v3273 = v3271.Character
            if v3273 then
                v3277 = v3273.GetChildren
                v3272 = pairs
                for v3275, v3279 in v3272(v3277(v3273)) do
                    v3272 = v3279:IsA("Tool")
                    if v3272 then
                        v3283 = v3279.Name:lower()
                        v3281 = v3283:find("gun")
                        v3280 = v3281
                        if not (v3281) then
                            v3284 = v3283:find("revolver")
                            v3281 = v3284
                            if not (v3284) then
                                v3286 = v3283:find("blaster")
                                v3284 = v3286
                                if not (v3286) then
                                    v3284 = (v3283:find("laser")) or (v3283:find("pistol"))
                                end
                                v3281 = v3284
                            end
                            v3280 = v3281
                        end
                        if v3280 then
                            return v3279
                        end
                    end
                end
            end
            v3274 = (v3271:FindFirstChild("Backpack"))
            if v3274 then
                v3272 = pairs
                v3283 = v3274.GetChildren
                for v3277, v3283 in v3272(v3283(v3274)) do
                    v3272 = v3283:IsA("Tool")
                    if v3272 then
                        v3280 = v3283.Name:lower()
                        v3282 = v3280:find("gun")
                        v3281 = v3282
                        if not (v3282) then
                            v3285 = v3280:find("revolver")
                            v3282 = v3285
                            if not (v3285) then
                                v3287 = v3280:find("blaster")
                                v3285 = v3287
                                if not (v3287) then
                                    v3289 = v3280:find("laser")
                                    v3287 = v3289
                                    if not (v3289) then
                                        v3287 = (v3280:find("pistol"))
                                    end
                                    v3285 = v3287
                                end
                                v3282 = v3285
                            end
                            v3281 = v3282
                        end
                        if v3281 then
                            return v3283
                        end
                    end
                end
            end
            v3272 = nil
            return v3272
        end
    end
    v3753 = pairs
    v3757 = game.Players
    v3759 = v3757.GetPlayers
    for v3756, v3757 in v3753(v3759(v3757)) do
        task.spawn(v3752, v3757)
    end
    game.Players.PlayerAdded:Connect(v3752)
    v3753 = workspace.CurrentCamera
    local up190 = v3753
    v3755 = workspace:GetPropertyChangedSignal("CurrentCamera")
    v3756 = function()
        up190 = workspace.CurrentCamera
        return
    end
    v3755:Connect(v3756)
    game.Players:GetPlayers()
    task.spawn(function()
        local v2335
        while true do
            v2335 = _G
            if v2335.ScriptUnloaded then
                break
            else
                game.Players:GetPlayers()
                task.wait(0.5)
            end
        end
        return
    end);
    (function()
        local v2346 = workspace:FindFirstChild("GunDrop", true)
        local v2347 = v2346
        if not (v2346) then
            v2347 = (workspace:FindFirstChild("Gun Drop", true))
        end
        _G.CachedGunDrop = v2347
        return
    end)()
    v3756 = workspace.DescendantAdded
    v3758 = function(arg194_1)
        local v2357, v2360
        local v2351 = arg194_1
        local v2355 = (v2351.Name == "GunDrop")
        local v2356 = v2355
        if not (v2355) then
            v2356 = (v2351.Name == "Gun Drop")
        end
        if v2356 then
            v2357 = _G
            v2357.CachedGunDrop = v2351
            v2356 = _G
            if v2356["AutoGetGunNotify"] then
                v2357 = up179
                v2360 = function()
                    _G.PlayUISound()
                    up187()
                    return
                end
                v2355 = {["Title"] = "GUN DROPPED", ["Content"] = "A gun has been dropped! Click here to collect it instantly.", ["Duration"] = 8, ["Callback"] = v2360}
                v2357:Notify(v2355)
            end
        end
        return
    end
    v3756:Connect(v3758)
    v3757 = function()
        local v2364, v2365, v2366, v2370, v2371, v2372, v2374, v2375, v2376, v2377, v2378, v2379
        local v2369 = game.Players.LocalPlayer
        local v2367 = _G
        local v2363 = v2369
        if (not v2367["AutoNotifyRoles"]) then
            v2369 = pairs
            v2365 = game.Players
            v2370 = v2365.GetPlayers
            for v2364, v2370 in v2369(v2370(v2365)) do
                v2372 = v2370.Character
                v2371 = v2372
                if v2372 then
                    v2375 = v2370.Character:FindFirstChild("Head")
                    v2372 = v2375
                    if v2375 then
                        v2372 = (v2370.Character.Head:FindFirstChild("RoleLabel"))
                    end
                    v2371 = v2372
                end
                if v2371 then
                    v2370.Character.Head.RoleLabel:Destroy()
                end
            end
            return
        else
            v2369 = pairs
            v2370 = game
            v2366 = v2370.Players
            v2371 = v2366.GetPlayers
            for v2365, v2370 in v2369(v2371(v2366)) do
                if (v2370 ~= v2363) then
                    v2372 = v2370.Character
                    v2371 = v2372
                    if v2372 then
                        v2371 = (v2370.Character:FindFirstChild("Head"))
                    end
                    if v2371 then
                        v2371 = up186(v2370)
                        v2372 = v2370.Character:FindFirstChild("RoleLabel", true)
                        if (v2371 ~= "Innocent") then
                            if (not v2372) then
                                v2372 = (Instance.new("BillboardGui"))
                                v2372.Name = "RoleLabel"
                                v2375 = v2370.Character:FindFirstChild("Head")
                                v2372.Adornee = v2375
                                v2375 = UDim2.new(4, 0, 1, 0)
                                v2372.Size = v2375
                                v2375 = Vector3.new(0, 3, 0)
                                v2372.StudsOffset = v2375
                                v2372.AlwaysOnTop = true
                                v2374 = Instance.new("TextLabel")
                                v2374.Name = "TextLabel"
                                v2374.Parent = v2372
                                v2374.AutoLocalize = false
                                v2374.BackgroundTransparency = 1
                                v2376 = UDim2.new(1, 0, 1, 0)
                                v2374.Size = v2376
                                v2375 = Enum.Font.GothamBold
                                v2374.Font = v2375
                                v2374.TextSize = 8
                                v2374.TextStrokeTransparency = 0
                                v2374.TextTransparency = 0
                                v2376 = v2370.Character:FindFirstChild("Head")
                                v2372.Parent = v2376
                                v2375 = game:GetService("TweenService")
                                v2377 = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out )
                                v2375:Create(v2374, v2377, {["TextTransparency"] = 0, ["TextStrokeTransparency"] = 0}):Play()
                            end
                            v2374 = Color3.fromRGB(255, 255, 255)
                            v2375 = ""
                            if (v2371 == "Murderer") then
                                v2376 = GetPlayerAbility(v2370)
                                v2377 = GetPlayerPerk(v2370)
                                v2378 = (v2376 ~= "None") or (v2377 ~= "None")
                                if v2378 then
                                    v2375 = (string.format("\n[%s | %s]", v2376, v2377))
                                end
                            end
                            v2369 = v2372.TextLabel
                            v2379 = v2371:upper()
                            v2369.Text = (v2379 .. v2375)
                            v2369 = v2372.TextLabel
                            v2369.TextColor3 = v2374
                        else
                            if v2372 then
                                v2372:Destroy()
                            end
                        end
                    end
                end
            end
            return
        end
    end
    local up192 = v3757
    v3757 = function(arg196_1)
        local v2389
        local up98 = arg196_1
        local v2388 = gethui and (gethui())
        local v2390 = v2388
        if not (v2388) then
            v2389 = game:GetService("CoreGui")
            v2388 = v2389
            if not (v2389) then
                v2388 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
            end
            v2390 = v2388
        end
        v2388 = v2390
        local v2397 = v2388:FindFirstChild("MM2MenuBtnGui")
        if v2397 then
            v2388.MM2MenuBtnGui:Destroy()
        end
        v2390 = Instance.new("ScreenGui")
        local up99 = v2390
        up99.Name = "MM2MenuBtnGui"
        up99.Parent = v2388
        up99.IgnoreGuiInset = true
        v2390 = Instance.new("Frame")
        local up100 = v2390
        up100.Name = "Main"
        up100.Parent = up99
        up100.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        up100.BackgroundTransparency = .05
        up100.Position = UDim2.new(0, 15, 0.5, -23)
        up100.Size = UDim2.new(0, 46, 0, 46)
        up100.ZIndex = 100
        v2389 = (Instance.new("UICorner"))
        v2389.CornerRadius = UDim.new(1, 0)
        v2389.Parent = up100
        local v2394 = (Instance.new("UIGradient"))
        v2394.Rotation = 90
        v2390 = ColorSequence.new
        local v2395 = ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 50, 255))
        v2394.Color = v2390({v2395, ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))})
        v2394.Parent = up100
        v2390 = Instance.new("UIStroke")
        local up101 = v2390
        up101.Thickness = 2.5
        up101.Color = Color3.fromRGB(255, 255, 255)
        up101.Transparency = .8
        up101.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        up101.Parent = up100
        v2390 = Instance.new("ImageLabel")
        local up102 = v2390
        up102.Name = "Shadow"
        up102.Parent = up100
        up102.BackgroundTransparency = 1
        up102.Position = UDim2.new(0, -18, 0, -18)
        up102.Size = UDim2.new(1, 36, 1, 36)
        up102.ZIndex = -1
        up102.Image = "rbxassetid://6015667104"
        up102.ImageColor3 = Color3.fromRGB(180, 50, 255)
        up102.ImageTransparency = 0.5
        v2390 = Instance.new("TextLabel")
        local up103 = v2390
        up103.Name = "VelonexLabel"
        up103.Parent = up100
        up103.AnchorPoint = Vector2.new(0.5, 0.5)
        up103.Position = UDim2.new(0.5, 0, 0.5, 0)
        up103.Size = UDim2.new(1, 0, 1, 0)
        up103.BackgroundTransparency = 1
        up103.Font = Enum.Font.FredokaOne
        up103.Text = "V"
        up103.TextColor3 = Color3.fromRGB(255, 255, 255)
        up103.TextSize = 22
        up103.ZIndex = 110
        v2395 = (Instance.new("UIStroke"))
        v2395.Thickness = 1.5
        v2395.Color = Color3.fromRGB(0, 0, 0)
        v2395.Transparency = 0.5
        v2395.Parent = up103
        local v2398 = (Instance.new("TextButton"))
        v2398.Size = UDim2.new(1, 0, 1, 0)
        v2398.BackgroundTransparency = 1
        v2398.Text = ""
        v2398.Parent = up100
        local up105
        local up106
        local up104
        v2397 = up100.Position
        local up107 = v2397
        v2398.InputBegan:Connect(function(arg258_1)
            local v3049 = arg258_1
            local v3057 = (v3049.UserInputType == Enum.UserInputType.MouseButton1)
            local v3058 = v3057
            if not (v3057) then
                v3058 = (v3049.UserInputType == Enum.UserInputType.Touch)
            end
            if v3058 then
                up105 = true
                up106 = v3049.Position
                up104 = up100.Position
            end
            return
        end)
        v2397 = game:GetService("UserInputService").InputChanged
        local v2403 = function(arg259_1)
            local v3071
            local v3060 = arg259_1
            local v3061 = up105
            local v3062 = v3061
            if v3061 then
                v3071 = (v3060.UserInputType == Enum.UserInputType.MouseMovement)
                v3061 = v3071
                if not (v3071) then
                    v3061 = (v3060.UserInputType == Enum.UserInputType.Touch)
                end
                v3062 = v3061
            end
            if v3062 then
                v3061 = (v3060.Position - up106)
                up107 = (UDim2.new(up104.X.Scale, (up104.X.Offset + v3061.X), up104.Y.Scale, (up104.Y .Offset + v3061.Y)))
            end
            return
        end
        v2397:Connect(v2403)
        game:GetService("UserInputService").InputEnded:Connect(function(arg260_1)
            local v3077 = arg260_1
            local v3084 = (v3077.UserInputType == Enum.UserInputType.MouseButton1)
            local v3085 = v3084
            if not (v3084) then
                v3085 = (v3077.UserInputType == Enum.UserInputType.Touch)
            end
            if v3085 then
            end
            return
        end)
        v2397 = game:GetService("RunService").Heartbeat
        v2403 = function()
            local v3087, v3090, v3095
            local v3088 = (not up99)
            local v3089 = v3088
            if not (v3088) then
                v3089 = (not up99.Parent)
            end
            if v3089 then
                return
            else
                v3095 = up100
                v3088 = up100.Position
                v3090 = up107
                v3087 = v3088:Lerp(v3090, .22)
                v3095.Position = v3087
                return
            end
        end
        v2397:Connect(v2403)
        v2390 = game:GetService("TweenService")
        local up108 = v2390
        local v2404 = function()
            local v3096 = function()
                local v2805, v2808, v2810, v2812
                local v2803 = up98
                local v2804 = v2803
                if v2803 then
                    v2810 = ((typeof(up98)) == "table")
                    v2803 = v2810
                    if v2810 then
                        v2803 = up98.Minimize
                    end
                    v2804 = v2803
                end
                if v2804 then
                    up98:Minimize()
                else
                    v2803 = (game:GetService("VirtualInputManager"))
                    v2804 = true
                    v2805 = ((typeof(up98)) == "EnumItem") and up98
                    v2812 = v2805
                    if not (v2805) then
                        v2812 = Enum.KeyCode.Insert
                    end
                    v2805 = game
                    v2803:SendKeyEvent(v2804, v2812, false, v2805)
                    task.wait()
                    v2808 = typeof
                    v2804 = false
                    v2805 = ((v2808(up98)) == "EnumItem") and up98
                    v2812 = v2805
                    if not (v2805) then
                        v2812 = Enum.KeyCode.Insert
                    end
                    v2805 = game
                    v2803:SendKeyEvent(v2804, v2812, false, v2805)
                end
                return
            end
            pcall(v3096)
            local v3098 = up108
            v3096 = up100
            local v3099 = TweenInfo.new(.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local v3101 = UDim2
            local v3097 = v3098.Create
            v3101 = v3101.new (0, 40, 0, 40)
            v3097 = v3097(v3098, v3096, v3099, {["Size"] = v3101})
            v3097:Play()
            task.wait(.1)
            v3098 = up108
            v3096 = up100
            local v3104 = TweenInfo.new
            local v3100 = Enum.EasingStyle.Back
            local v3108 = Enum
            v3097 = v3098.Create
            v3099 = v3104(.2, v3100, v3108.EasingDirection.Out)
            v3101 = UDim2.new(0, 46, 0, 46)
            v3097 = v3097(v3098, v3096, v3099, {["Size"] = v3101})
            v3097:Play()
            return
        end
        v2398.MouseButton1Click :Connect(v2404)
        v2398.MouseEnter:Connect(function()
            local v3110 = up108
            local v3112 = up100
            local v3113 = TweenInfo.new(.3)
            local v3111 = v3110.Create
            local v3115 = UDim2.new(0, 52, 0, 52)
            v3111 = v3111(v3110, v3112, v3113, {["Size"] = v3115})
            v3111:Play()
            v3110 = up108
            v3112 = up101
            v3113 = TweenInfo.new(.3)
            v3110:Create(v3112, v3113, {["Transparency"] = 0.5, ["Thickness"] = 3}):Play()
            v3110 = up108
            v3112 = up102
            v3113 = TweenInfo.new(.3)
            local v3119 = Color3.fromRGB(255, 255, 255)
            v3110:Create(v3112, v3113, {["ImageTransparency"] = .1, ["ImageColor3"] = v3119}):Play()
            v3110 = up108
            v3112 = up103
            v3113 = TweenInfo.new(.3)
            v3110:Create(v3112, v3113, {["TextSize"] = 26}):Play()
            return
        end)
        v2397 = v2398.MouseLeave
        v2404 = function()
            local v3124 = up108
            local v3126 = up100
            local v3127 = TweenInfo.new(.3)
            local v3125 = v3124.Create
            local v3129 = UDim2.new(0, 46, 0, 46)
            v3125 = v3125(v3124, v3126, v3127, {["Size"] = v3129})
            v3125:Play()
            v3124 = up108
            v3126 = up101
            v3127 = TweenInfo.new(.3)
            v3124:Create(v3126, v3127, {["Transparency"] = .8, ["Thickness"] = 2.5}):Play()
            v3124 = up108
            v3126 = up102
            v3127 = TweenInfo.new(.3)
            local v3133 = Color3.fromRGB(180, 50, 255)
            v3124:Create(v3126, v3127, {["ImageTransparency"] = 0.5, ["ImageColor3"] = v3133}):Play()
            v3124 = up108
            v3126 = up103
            v3127 = TweenInfo.new(.3)
            v3124:Create(v3126, v3127, {["TextSize"] = 22}):Play()
            return
        end
        v2397:Connect(v2404)
        task.spawn(function()
            local v3138, v3139, v3144, v3145, v3148, v3150
            while true do
                v3138 = up99
                v3139 = v3138
                if v3138 then
                    v3139 = up99.Parent
                end
                if v3139 then
                    v3145 = up108
                    v3138 = up102
                    v3144 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    v3150 = UDim2.new(1, 40, 1, 40)
                    v3148 = UDim2.new(0, -20, 0, -20)
                    v3145:Create(v3138, v3144, {["ImageTransparency"] = .3, ["Size"] = v3150, ["Position"] = v3148}):Play()
                    task.wait(2)
                    v3145 = up108
                    v3138 = up102
                    v3144 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                    v3139 = v3145.Create
                    v3150 = UDim2.new(1, 36, 1, 36)
                    v3148 = UDim2.new(0, -18, 0, -18)
                    v3139 = v3139(v3145, v3138, v3144, {["ImageTransparency"] = 0.5, ["Size"] = v3150, ["Position"] = v3148})
                    v3139:Play()
                    task.wait(2)
                else
                    break
                end
            end
            return
        end)

        return
    end
    v3758 = _G
    v3758.DashboardEnabled = false
    v3758 = spilledValues1.value1()
    if (not v3758) then
        return
    else
        v3759 = task.spawn
        v3761 = function()
            local v1791, v1793
            local v1790 = game.Players.LocalPlayer
            local v1789 = gethui and (gethui())
            local v1794 = v1789
            if not (v1789) then
                v1793 = game:GetService("CoreGui")
                v1789 = v1793
                if not (v1793) then
                    v1789 = (v1790:WaitForChild("PlayerGui"))
                end
                v1794 = v1789
            end
            local up79 = v1794
            v1794 = up79:FindFirstChild("VelonexWatermark")
            if v1794 then
                v1791 = function()
                    up79.VelonexWatermark:Destroy()
                    return
                end
                pcall(v1791)
            end
            v1791 = (Instance.new("ScreenGui"))
            v1791.Name = "VelonexWatermark"
            v1791.Parent = up79
            v1791.DisplayOrder = 9999
            local v1792 = (Instance.new("Frame"))
            v1792.Name = "Main"
            v1792.Size = UDim2.new(0, 150, 0, 26)
            v1792.Position = UDim2.new(1, -165, 0, 15)
            v1792.BackgroundTransparency = 1
            v1792.BorderSizePixel = 0
            v1792.Parent = v1791
            v1794 = Instance.new("TextLabel")
            local up80 = v1794
            up80.Size = UDim2.new(1, 0, 1, 0)
            up80.Position = UDim2.new(0, 0, 0, 0)
            up80.BackgroundTransparency = 1
            up80.Font = Enum.Font.GothamMedium
            up80.TextColor3 = Color3.fromRGB(200, 200, 200)
            up80.TextSize = 10
            up80.TextStrokeTransparency = .8
            up80.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            up80.TextXAlignment = Enum.TextXAlignment.Left
            up80.Text = "MAP: SCANNING..."
            up80.Parent = v1792
            local up81
            local up82 = ""
            local v1795 = function()
                local v1927, v1931
                local up89 = "LOBBY"
                local v1929 = function()
                    local v1818, v1819, v1820, v1821, v1822, v1824, v1825, v1827, v1828, v1829, v1830, v1837
                    local v1816 = up81
                    local v1817 = v1816
                    if v1816 then
                        v1817 = up81.Parent
                    end
                    if v1817 then
                        up89 = (up81.Name:upper())
                    else
                        up81 = nil
                        v1818 = workspace:FindFirstChild("Normal")
                        if v1818 then
                            for v1820, v1821 in ipairs(v1818:GetChildren()) do
                                v1829 = v1821:IsA("Model")
                                v1830 = v1829
                                if not (v1829) then
                                    v1830 = (v1821:IsA("Folder"))
                                end
                                v1824 = v1830
                                if v1830 then
                                    v1829 = (v1821.Name ~= "Lobby")
                                    v1830 = v1829
                                    if v1829 then
                                        v1825 = (v1821.Name ~= "Spawns")
                                        v1829 = v1825
                                        if v1825 then
                                            v1827 = (v1821.Name ~= "CoinContainer")
                                            v1825 = v1827
                                            if v1827 then
                                                v1825 = (v1821.Name ~= "GLight")
                                            end
                                            v1829 = v1825
                                        end
                                        v1830 = v1829
                                    end
                                    v1824 = v1830
                                end
                                if v1824 then
                                    up81 = v1821
                                    up89 = (v1821.Name:upper())
                                else
                                    continue
                                end
                                break
                            end
                        end
                        v1819 = (not up81)
                        v1816 = v1819
                        if v1819 then
                            v1816 = _G.MapCoordinates
                        end
                        if v1816 then
                            v1816 = pairs
                            v1837 = _G
                            for v1820, v1821 in v1816(v1837.MapCoordinates) do
                                v1816 = v1820
                                if (v1816 ~= "Lobby") then
                                    v1828 = workspace:FindFirstChild(v1816)
                                    v1837 = v1828
                                    if not (v1828) then
                                        v1837 = v1818 and (v1818:FindFirstChild(v1816))
                                    end
                                    if v1837 then
                                        up81 = v1837
                                        up89 = (v1816:upper())

                                        break
                                    end
                                end
                            end
                        end
                        if (not up81) then
                            v1822 = workspace:FindFirstChild("CoinContainer", true)
                            v1816 = v1822
                            if v1822 then
                                v1837 = v1822.Parent
                                v1820 = v1837
                                if v1837 then
                                    v1825 = (v1822.Parent.Name ~= "Lobby")
                                    v1837 = v1825
                                    if v1825 then
                                        v1827 = (v1822.Parent.Name ~= "Workspace")
                                        v1825 = v1827
                                        if v1827 then
                                            v1825 = (v1822.Parent.Name ~= "Normal")
                                        end
                                        v1837 = v1825
                                    end
                                    v1820 = v1837
                                end
                                v1816 = v1820
                            end
                            if v1816 then
                                v1816 = v1822.Parent
                                up89 = (v1822.Parent.Name:upper())
                            end
                        end
                    end
                    return
                end
                pcall(v1929)
                if (up89 ~= up82) then
                    v1927 = up80
                    v1931 = ("MAP: " .. up89)
                    v1927.Text = v1931
                end
                return
            end
            local up83 = v1795
            task.spawn(function()
                local v1936
                while true do
                    v1936 = _G
                    if not (not v1936.ScriptUnloaded ) then
                        break
                    end
                    up83()
                    task.wait(.1)
                end
                return
            end)

            return
        end
        v3759(v3761)
        v3762 = function()
            up179 = (loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))())

            return
        end
        v3760, v3761 = pcall(v3762)
        v3759 = (not v3760) or (not up179)
        if v3759 then
            warn(("Fluent UI failed to load: " .. (tostring(v3761))))
            game:GetService("StarterGui"):SetCore("SendNotification", {["Title"] = "Velonex Error", ["Text"] = "UI Library failed to load. Please rejoin.", ["Duration"] = 10})
            return
        else
            v3762 = Instance.new("ScreenGui")
            v3762.Name = "VelonexNotifications"
            v3759 = "Parent"
            v3765 = gethui and (gethui())
            v3763 = v3765
            if not (v3765) then
                v3768 = game:GetService("CoreGui")
                v3765 = v3768
                if not (v3768) then
                    v3765 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                end
                v3763 = v3765
            end
            v3762[v3759] = v3763
            v3762.DisplayOrder = 9999
            v3763 = Instance.new("Frame")
            local up193 = v3763
            v3763 = up193
            v3763.Name = "Container"
            v3763 = up193
            v3763.Parent = v3762
            v3763 = up193
            v3766 = UDim2.new(0, 260, 1, -40)
            v3763.Size = v3766
            v3763 = up193
            v3766 = UDim2.new(1, -20, 1, -20)
            v3763.Position = v3766
            v3763 = up193
            v3766 = Vector2.new(1, 1)
            v3763.AnchorPoint = v3766
            v3763 = up193
            v3763.BackgroundTransparency = 1
            v3764 = Instance.new("UIListLayout")
            v3764.Parent = up193
            v3765 = Enum.VerticalAlignment.Bottom
            v3764.VerticalAlignment = v3765
            v3765 = Enum.HorizontalAlignment.Right
            v3764.HorizontalAlignment = v3765
            v3766 = UDim.new(0, 12)
            v3764.Padding = v3766
            v3765 = Enum.SortOrder.LayoutOrder
            v3764.SortOrder = v3765
            v3763 = _G
            v3763.ActiveNotifications = {}
            v3763 = function(arg142_1, arg142_2)
                local v1768, v1772, v1773, v1774, v1778, v1779
                local v1766 = arg142_2
                local v1771 = v1766.Title or "SYSTEM"
                local up74 = v1771
                v1771 = v1766.Content or ""
                local up75 = v1771
                local v1765 = v1766.Duration
                local up76 = (v1765 or 5)
                v1771 = v1766.Callback
                local up77 = v1771
                v1768, v1772, v1773 = ipairs(_G.ActiveNotifications)
                while true do
                    v1773, v1774 = v1768(v1772, v1773)
                    if not v1773 then
                        break
                    end
                    v1779 = v1773
                    v1778 = (v1774:FindFirstChild("TitleLabel", true))
                    v1771 = v1778 and (v1778.Text == up74)
                    if v1771 then
                        table.remove(_G.ActiveNotifications, v1779)
                        v1774:Destroy()
                    else
                        continue
                    end
                    break
                end
                v1773 = _G
                if ((#v1773["ActiveNotifications"]) >= 5) then
                    v1768 = table.remove(_G.ActiveNotifications, 1)
                    v1771 = v1768 and v1768.Parent
                    if v1771 then
                        v1768:Destroy()
                    end
                end
                v1768 = Instance.new("CanvasGroup")
                local up78 = v1768
                up78.Size = UDim2.new(1, 0, 0, 0)
                up78.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
                up78.BackgroundTransparency = .2
                up78.BorderSizePixel = 0
                up78.GroupTransparency = 1
                up78.Parent = up193
                table.insert(_G.ActiveNotifications, up78)
                v1771 = task.spawn
                v1773 = function()
                    local v1580, v1581, v1583, v1597, v1598
                    local v1577 = (Color3.fromRGB(0, 200, 255))
                    local v1579 = (up74:upper())
                    local v1578 = (v1579:find("SUCCESS")) or (v1579:find("LOADED"))
                    if v1578 then
                        v1577 = (Color3.fromRGB(0, 255, 150))
                    else
                        v1580 = (v1579:find("ERROR")) or (v1579:find("FAILED"))
                        if v1580 then
                            v1577 = (Color3.fromRGB(255, 60, 60))
                        else
                            v1583 = v1579:find("WARNING")
                            v1581 = v1583
                            if not (v1583) then
                                v1581 = (v1579:find("ALERT"))
                            end
                            if v1581 then
                                v1577 = (Color3.fromRGB(255, 180, 0))
                            else
                                v1583 = (v1579:find("GUN")) or (v1579:find("SHERIFF"))
                                if v1583 then
                                    v1577 = (Color3.fromRGB(255, 200, 0))
                                end
                            end
                        end
                    end
                    local v1584 = Instance.new("UICorner")
                    v1584.CornerRadius = UDim.new(0, 12)
                    v1584.Parent = up78
                    local v1585 = Instance.new("UIStroke")
                    v1585.Thickness = 1.8
                    v1585.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    v1585.Parent = up78
                    local v1586 = Instance.new("UIGradient")
                    local up65 = v1586
                    local v1582 = up65
                    local v1588 = ColorSequence.new
                    local v1591 = ColorSequenceKeypoint.new(0, v1577)
                    local v1592 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 30))
                    v1582.Color = v1588({v1591, v1592, ColorSequenceKeypoint.new(1, v1577)})
                    up65.Parent = v1585
                    task.spawn(function()
                        local v2884, v2885
                        local v2883 = 0
                        while true do
                            v2884 = up78
                            v2885 = v2884
                            if v2884 then
                                v2885 = up78.Parent
                            end
                            if v2885 then
                                v2883 = ((v2883 + 4) % 360)
                                v2885 = up65
                                v2885.Rotation = v2883
                                task.wait()
                            else
                                break
                            end
                        end
                        return
                    end)
                    v1586 = Instance.new("TextLabel")
                    v1586.Size = UDim2.new(1, 0, 0, 22)
                    v1586.Position = UDim2.new(0, 0, 0, 14)
                    v1586.BackgroundTransparency = 1
                    v1586.Font = Enum.Font.GothamBold
                    v1586.Text = up74:upper()
                    v1586.TextColor3 = v1577
                    v1586.TextSize = 15
                    v1586.TextXAlignment = Enum.TextXAlignment.Center
                    v1586.Parent = up78
                    v1588 = Instance.new("UIStroke")
                    v1588.Color = v1577
                    v1588.Thickness = 0.5
                    v1588.Transparency = 0.5
                    v1588.Parent = v1586
                    local v1589 = Instance.new("Frame")
                    v1589.Size = UDim2.new(1, 0, 0, 3)
                    v1589.Position = UDim2.new(0, 0, 0, 42)
                    v1589.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                    v1589.BorderSizePixel = 0
                    v1589.Parent = up78
                    local v1590 = Instance.new("Frame")
                    v1590.Size = UDim2.new(1, 0, 1, 0)
                    local v1595 = v1579:find("GUN")
                    v1592 = v1595
                    if v1595 then
                        v1592 = (Color3.fromRGB(255, 200, 0))
                    end
                    local v1593 = v1592
                    if not (v1592) then
                        v1593 = (Color3.fromRGB(180, 100, 255))
                    end
                    v1590.BackgroundColor3 = v1593
                    v1590.BorderSizePixel = 0
                    v1590.Parent = v1589
                    v1593 = Instance.new("Frame")
                    v1593.Name = "Content"
                    v1593.Size = UDim2.new(1, -30, 0, 0)
                    v1593.Position = UDim2.new(0, 15, 0, 55)
                    v1593.BackgroundTransparency = 1
                    v1593.AutomaticSize = Enum.AutomaticSize.Y
                    v1593.Parent = up78
                    v1591 = Instance.new("UIListLayout")
                    v1591.HorizontalAlignment = Enum.HorizontalAlignment.Center
                    v1591.SortOrder = Enum.SortOrder.LayoutOrder
                    v1591.Padding = UDim.new(0, 12)
                    v1591.Parent = v1593
                    v1592 = Instance.new("TextLabel")
                    v1592.LayoutOrder = 1
                    v1592.Size = UDim2.new(1, 0, 0, 0)
                    v1592.BackgroundTransparency = 1
                    v1592.Font = Enum.Font.GothamMedium
                    v1592.TextColor3 = Color3.fromRGB(220, 220, 230)
                    v1592.TextSize = 12
                    v1592.Text = up75
                    v1592.TextXAlignment = Enum.TextXAlignment.Center
                    v1592.TextWrapped = true
                    local v1596 = Enum
                    v1592.AutomaticSize = v1596.AutomaticSize.Y
                    v1592.Parent = v1593
                    v1582 = nil
                    local up66 = v1582
                    if up77 then
                        up66 = (Instance.new("TextButton"))
                        v1582 = up66
                        v1582.Name = "ActionBtn"
                        v1582 = up66
                        v1582.LayoutOrder = 2
                        v1582 = up66
                        v1598 = UDim2.new(0, 130, 0, 30)
                        v1582.Size = v1598
                        v1582 = up66
                        v1582.BackgroundColor3 = v1577
                        v1582 = up66
                        v1582.BackgroundTransparency = .2
                        v1582 = up66
                        v1597 = Enum.Font.GothamBold
                        v1582.Font = v1597
                        v1582 = up66
                        v1582.Text = "COLLECT"
                        v1582 = up66
                        v1598 = Color3.new(1, 1, 1)
                        v1582.TextColor3 = v1598
                        v1582 = up66
                        v1582.TextSize = 11
                        v1582 = up66
                        v1582.Parent = v1593
                        v1596 = Instance.new("UICorner")
                        v1598 = UDim.new(0, 6)
                        v1596.CornerRadius = v1598
                        v1596.Parent = up66
                        v1597 = Instance.new("UIStroke")
                        v1597.Color = v1577
                        v1597.Thickness = 1.5
                        v1597.Transparency = 0.5
                        v1598 = up66
                        v1597.Parent = v1598
                    end
                    task.wait(.05)
                    v1596 = ((55 + v1593.AbsoluteSize.Y) + 20)
                    v1582 = up183
                    v1598 = up78
                    local v1600 = TweenInfo.new(.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local v1603 = UDim2.new(1, 0, 0, v1596)
                    v1582:Create(v1598, v1600, {["Size"] = v1603, ["GroupTransparency"] = 0}):Play()
                    _G.PlayUISound()
                    v1582 = up183
                    local v1599 = TweenInfo.new(up76, Enum.EasingStyle.Linear)
                    v1597 = v1582.Create
                    local v1602 = UDim2.new(0, 0, 1, 0)
                    v1597 = v1597(v1582, v1590, v1599, {["Size"] = v1602})
                    v1597:Play()
                    local up68 = false
                    local up67 = function()
                        local v1660, v1661, v1662, v1663, v1664, v1666, v1667, v1668, v1669
                        if up68 then
                            return
                        else
                            up68 = true
                            v1661 = ipairs
                            v1662 = _G
                            for v1669, v1662 in v1661(v1662.ActiveNotifications) do
                                v1661 = (v1662 == up78)
                                v1667 = v1669
                                if v1661 then
                                    table.remove(_G.ActiveNotifications, v1667)
                                else
                                    continue
                                end
                                break
                            end
                            v1661 = up183
                            v1668 = up78
                            v1669 = TweenInfo.new
                            v1666 = Enum.EasingStyle.Quart
                            v1664 = Enum.EasingDirection
                            v1660 = v1661.Create
                            v1667 = v1669(0.5, v1666, v1664.In )
                            v1663 = UDim2.new (1, 0, 0, 0)
                            v1660 = v1660(v1661, v1668, v1667, {["Size"] = v1663, ["GroupTransparency"] = 1})
                            v1660:Play()
                            task.delay(0.5, function()
                                local v3432 = up78
                                local v3433 = v3432
                                if v3432 then
                                    v3433 = up78.Parent
                                end
                                if v3433 then
                                    up78:Destroy()
                                end
                                return
                            end)

                            return
                        end
                    end
                    v1599 = up77 and up66
                    if v1599 then
                        task.spawn(function()
                            local v2991, v2992, v2994, v3000
                            local v2986 = up76
                            local v2988 = 1
                            local v2989 = -1
                            for v2987 = v2986, v2988, v2989 do
                                v2992 = up68
                                v2991 = v2987
                                v2986 = v2992
                                if not (v2992) then
                                    v2994 = (not up66)
                                    v2992 = v2994
                                    if not (v2994) then
                                        v2992 = (not up66.Parent)
                                    end
                                    v2986 = v2992
                                end
                                if not (v2986) then
                                    v3000 = up66
                                    v3000.Text = ("COLLECT (" .. (v2991 .. "s)"))
                                    task.wait(1)

                                    continue
                                end
                                break
                            end
                            return
                        end)
                        v1582 = up66.MouseButton1Click
                        v1600 = function()
                            local v3004, v3006, v3007, v3009
                            if (not up68) then
                                task.spawn(up77)
                                v3007 = up183
                                v3006 = up66
                                v3004 = TweenInfo.new(.2)
                                v3009 = UDim2.new (0, 110, 0, 25)
                                v3007:Create(v3006, v3004, {["Size"] = v3009, ["BackgroundTransparency"] = 1}):Play()
                                task.wait (.1)
                                up67()
                            end
                            return
                        end
                        v1582:Connect(v1600)
                    end
                    task.delay(up76, up67)

                    return
                end
                v1771(v1773)

                return
            end
            up179.Notify = v3763
            v3765 = Instance.new("ScreenGui")
            v3765.Name = "BottomLeftNotifications"
            v3763 = "Parent"
            v3768 = gethui and (gethui())
            v3766 = v3768
            if not (v3768) then
                v3771 = game:GetService("CoreGui")
                v3768 = v3771
                if not (v3771) then
                    v3768 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                end
                v3766 = v3768
            end
            v3765[v3763] = v3766
            v3765.DisplayOrder = 10001
            v3765.IgnoreGuiInset = true
            v3766 = Instance.new("Frame")
            local up194 = v3766
            v3766 = up194
            v3766.Name = "Container"
            v3766 = up194
            v3766.Parent = v3765
            v3766 = up194
            v3769 = UDim2.new(0, 240, 0, 400)
            v3766.Size = v3769
            v3766 = up194
            v3769 = UDim2.new(0, 20, 1, -20)
            v3766.Position = v3769
            v3766 = up194
            v3769 = Vector2.new(0, 1)
            v3766.AnchorPoint = v3769
            v3766 = up194
            v3766.BackgroundTransparency = 1
            v3767 = Instance.new("UIListLayout")
            v3767.Parent = up194
            v3768 = Enum.VerticalAlignment.Bottom
            v3767.VerticalAlignment = v3768
            v3769 = UDim.new(0, 8)
            v3767.Padding = v3769
            v3768 = Enum.SortOrder.LayoutOrder
            v3767.SortOrder = v3768
            v3766 = _G
            v3766.ActiveKeybindNotifs = {}
            v3768 = _G
            v3766 = function(arg318_1, arg318_2)
                local up153
                local up154
                local v3707 = function()
                    local v1879
                    local v1874 = _G
                    if ((#v1874["ActiveKeybindNotifs"]) >= 4) then
                        v1879 = table.remove(_G.ActiveKeybindNotifs, 1)
                        local up85 = v1879
                        v1874 = up85
                        v1879 = v1874
                        if v1874 then
                            v1879 = up85.Parent
                        end
                        if v1879 then
                            v1874 = function()
                                up85:Destroy()
                                return
                            end
                            pcall(v1874)
                        end
                    end
                    v1879 = Instance.new("CanvasGroup")
                    local up86 = v1879
                    up86.Size = UDim2.new(0, 0, 0, 32)
                    up86.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
                    up86.BackgroundTransparency = .1
                    up86.BorderSizePixel = 0
                    up86.GroupTransparency = 1
                    up86.Parent = up194
                    table.insert(_G.ActiveKeybindNotifs, up86)
                    v1874 = (Instance.new("UICorner"))
                    v1874.CornerRadius = UDim.new(0, 8)
                    v1874.Parent = up86
                    local v1880 = (Instance.new("UIStroke"))
                    v1880.Thickness = 1.5
                    v1880.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    v1880.Parent = up86
                    local v1877 = up154
                    local v1875 = v1877
                    if v1877 then
                        v1875 = (Color3.fromRGB(0, 255, 150))
                    end
                    v1879 = v1875
                    if not (v1875) then
                        v1879 = (Color3.fromRGB(255, 60, 60))
                    end
                    v1875 = v1879
                    local v1876 = (Instance.new("UIGradient"))
                    v1879 = ColorSequence.new
                    local v1884 = ColorSequenceKeypoint.new(0, v1875)
                    v1876.Color = v1879({v1884, ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 30, 80))})
                    v1876.Parent = v1880
                    v1877 = (Instance.new("Frame"))
                    v1877.Size = UDim2.new(0, 3, 0, 18)
                    v1877.Position = UDim2.new(0, 0, 0.5, -9)
                    v1877.BackgroundColor3 = v1875
                    v1877.BorderSizePixel = 0
                    v1877.Parent = up86
                    v1879 = Instance.new("UICorner", v1877)
                    v1879.CornerRadius = UDim.new(0, 2)
                    local v1882 = (Instance.new("TextLabel"))
                    v1882.Size = UDim2.new(1, -30, 1, 0)
                    v1882.Position = UDim2.new(0, 15, 0, 0)
                    v1882.BackgroundTransparency = 1
                    v1882.Font = Enum.Font.GothamBold
                    v1879 = string.format
                    local v1886 = up153:upper()
                    local v1885 = up154 and "ENABLED" or "DISABLED"
                    v1882.Text = v1879("%s: %s", v1886, v1885)
                    v1882.TextColor3 = Color3.fromRGB(255, 255, 255)
                    v1882.TextSize = 10
                    v1882.TextXAlignment = Enum.TextXAlignment.Left
                    v1882.Parent = up86
                    v1879 = game:GetService("TweenService")
                    local up87 = v1879
                    local v1881 = up87
                    v1884 = up86
                    v1886 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local v1889 = UDim2.new(1, 0, 0, 32)
                    v1881:Create(v1884, v1886, {["Size"] = v1889, ["GroupTransparency"] = 0}):Play()
                    task.delay(2.8, function()
                        local v1900, v1901, v1902, v1903
                        local v1896 = up86
                        local v1897 = v1896
                        if v1896 then
                            v1897 = up86.Parent
                        end
                        if v1897 then
                            v1903 = up87
                            v1896 = up86
                            v1902 = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In )
                            v1901 = UDim2.new (0, 0, 0, 32)
                            v1896 = (v1903:Create(v1896, v1902, {["Size"] = v1901, ["GroupTransparency"] = 1}))
                            v1896:Play()
                            v1896.Completed:Wait()
                            v1903 = ipairs
                            v1900 = _G
                            for v1902, v1901 in v1903(v1900.ActiveKeybindNotifs ) do
                                v1903 = (v1901 == up86)
                                v1900 = v1902
                                if v1903 then
                                    table.remove(_G.ActiveKeybindNotifs, v1900)
                                else
                                    continue
                                end
                                break
                            end
                            up86:Destroy()
                        end
                        return
                    end)

                    return
                end
                up153 = arg318_1
                up154 = arg318_2
                pcall(v3707)

                return
            end
            v3768.KeybindNotify = v3766
            v3768 = Instance.new("ScreenGui")
            v3768.Name = "TopLeftNotifications"
            v3766 = "Parent"
            v3771 = gethui and (gethui())
            v3769 = v3771
            if not (v3771) then
                v3774 = game:GetService("CoreGui")
                v3771 = v3774
                if not (v3774) then
                    v3771 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                end
                v3769 = v3771
            end
            v3768[v3766] = v3769
            v3768.DisplayOrder = 10000
            v3769 = Instance.new("Frame")
            local up195 = v3769
            v3769 = up195
            v3769.Name = "Container"
            v3769 = up195
            v3769.Parent = v3768
            v3769 = up195
            v3772 = UDim2.new(0, 220, 0, 400)
            v3769.Size = v3772
            v3769 = up195
            v3772 = UDim2.new(0, 15, 0, 15)
            v3769.Position = v3772
            v3769 = up195
            v3769.BackgroundTransparency = 1
            v3770 = Instance.new("UIListLayout")
            v3770.Parent = up195
            v3772 = UDim.new(0, 6)
            v3770.Padding = v3772
            v3771 = Enum.SortOrder.LayoutOrder
            v3770.SortOrder = v3771
            v3769 = _G
            v3769.ActiveTopNotifs = {}
            v3769 = function(arg201_1, arg201_2)
                local up109 = arg201_1
                local up110 = arg201_2
                local v2455 = function()
                    local v2868
                    local v2864 = up110 and "ON" or "OFF"
                    local v2863 = _G
                    if ((#v2863["ActiveTopNotifs"]) >= 2) then
                        v2868 = table.remove(_G.ActiveTopNotifs, 1)
                        local up127 = v2868
                        v2863 = up127
                        v2868 = v2863
                        if v2863 then
                            v2868 = up127.Parent
                        end
                        if v2868 then
                            pcall(function()
                                up127:Destroy()
                                return
                            end)
                        end
                    end
                    v2868 = Instance.new("Frame")
                    local up128 = v2868
                    up128.Size = UDim2.new(1, 0, 0, 28)
                    up128.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
                    up128.BackgroundTransparency = .2
                    up128.BorderSizePixel = 0
                    up128.Parent = up195
                    v2863 = (Instance.new("UICorner"))
                    v2863.CornerRadius = UDim.new(0, 6)
                    v2863.Parent = up128
                    v2868 = Instance.new("UIStroke")
                    local up129 = v2868
                    up129.Thickness = 1.2
                    local v2871 = up129
                    local v2873 = up110
                    local v2870 = v2873
                    if v2873 then
                        v2870 = (Color3.fromRGB(0, 255, 150))
                    end
                    local v2866 = v2870
                    if not (v2870) then
                        v2866 = (Color3.fromRGB(255, 60, 60))
                    end
                    v2871.Color = v2866
                    up129.Transparency = .4
                    up129.Parent = up128
                    v2868 = Instance.new("TextLabel")
                    local up130 = v2868
                    up130.Size = UDim2.new(1, -20, 1, 0)
                    up130.Position = UDim2.new(0, 10, 0, 0)
                    up130.BackgroundTransparency = 1
                    up130.Font = Enum.Font.GothamBold
                    up130.Text = string.format("%s: %s", (up109:upper()), v2864)
                    v2870 = up130
                    local v2874 = up110
                    local v2872 = v2874
                    if v2874 then
                        v2872 = (Color3.fromRGB(0, 255, 150))
                    end
                    local v2867 = v2872
                    if not (v2872) then
                        v2867 = (Color3.fromRGB(255, 60, 60))
                    end
                    v2870.TextColor3 = v2867
                    up130.TextSize = 11
                    up130.TextXAlignment = Enum.TextXAlignment.Left
                    up130.Parent = up128
                    table.insert(_G.ActiveTopNotifs, up128)
                    up128.Position = UDim2.new(-1, 0, 0, 0)
                    v2868 = game:GetService("TweenService")
                    v2867 = up128
                    v2872 = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
                    v2874 = UDim2.new
                    v2871 = v2868.Create
                    local v2878 = v2874(0, 0, 0, 0)
                    v2871 = v2871(v2868, v2867, v2872, {["Position"] = v2878})
                    v2871:Play()
                    task.delay(2.5, function()
                        local v2170, v2171, v2172, v2174, v2175
                        local v2168 = up128
                        local v2169 = v2168
                        if v2168 then
                            v2169 = up128.Parent
                        end
                        if v2169 then
                            v2169, v2168, v2170 = ipairs(_G.ActiveTopNotifs )
                            v2174 = v2169
                            while true do
                                v2170, v2172 = v2174(v2168, v2170)
                                if not v2170 then
                                    break
                                end
                                v2175 = (v2172 == up128)
                                v2171 = v2170
                                if v2175 then
                                    table.remove(_G.ActiveTopNotifs, v2171)
                                else
                                    continue
                                end
                                break
                            end
                            pcall(function()
                                local v2068 = game:GetService("TweenService")
                                local v2073 = up128
                                local v2071 = TweenInfo.new(0.5)
                                v2068:Create(v2073, v2071, {["Transparency"] = 1, ["BackgroundTransparency"] = 1}):Play()
                                v2068 = game:GetService("TweenService")
                                v2073 = up130
                                v2071 = TweenInfo
                                local v2069 = v2068.Create
                                v2071 = v2071.new (0.5)
                                v2069 = v2069(v2068, v2073, v2071, {["TextTransparency"] = 1})
                                v2069:Play()
                                v2068 = game:GetService("TweenService")
                                v2073 = up129
                                v2071 = TweenInfo.new(0.5)
                                local v2070 = {["Transparency"] = 1}
                                v2068:Create(v2073, v2071, v2070):Play()
                                return
                            end)
                            task.wait(0.5)
                            v2170 = up128
                            v2168 = v2170
                            if v2170 then
                                v2168 = up128.Parent
                            end
                            if v2168 then
                                pcall(function()
                                    up128:Destroy()
                                    return
                                end)
                            end
                        end
                        return
                    end)

                    return
                end
                pcall(v2455)

                return
            end
            v3769 = up179
            spilledValues1.value18 = UDim2
            v3771 = v3769.CreateWindow
            spilledValues1.value18 = spilledValues1.value18.fromOffset(580, 460)
            spilledValues1.value20 = Enum.KeyCode.Insert
            v3771 = v3771(v3769, {["Title"] = "MURDER MYSTERY 2", ["SubTitle"] = "", ["TabWidth"] = 160, ["Size"] = spilledValues1.value18, ["Theme"] = "Amethyst", ["MinimizeKey"] = spilledValues1.value20})
            local up196 = v3771
            v3757(up196)
            v3771 = task.spawn
            v3773 = function()
                local v2462, v2464, v2465, v2466, v2467, v2470, v2471, v2473, v2474
                local v2461 = gethui and (gethui())
                local v2463 = v2461
                if not (v2461) then
                    v2462 = game:GetService("CoreGui")
                    v2461 = v2462
                    if not (v2462) then
                        v2461 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                    end
                    v2463 = v2461
                end
                local v2469 = (v2463:WaitForChild("Fluent", 5))
                if v2469 then
                    v2470 = v2469:WaitForChild("Main", 5)
                    local up111 = v2470
                    if up111 then
                        v2467 = up111:FindFirstChild("CanvasGroup")
                        if v2467 then
                        end
                        v2467 = up111.Size
                        v2470 = up111
                        v2465 = UDim2.fromOffset((v2467.X.Offset * .7), (v2467.Y.Offset * .7))
                        v2470.Size = v2465
                        v2470 = up111
                        v2470.GroupTransparency = 1
                        v2470 = up183
                        v2464 = up111
                        v2465 = TweenInfo.new
                        v2471 = Enum.EasingStyle.Back
                        v2473 = Enum.EasingDirection
                        v2470:Create(v2464, (v2465(.8, v2471, v2473.Out )), {["Size"] = v2467}):Play()
                        v2470 = up183
                        v2464 = up111
                        v2465 = TweenInfo.new
                        v2471 = Enum.EasingStyle.Quart
                        v2474 = Enum
                        v2470:Create(v2464, (v2465(.6, v2471, v2474.EasingDirection.Out)), {["GroupTransparency"] = 0}):Play()
                        v2463 = Instance.new("ImageLabel")
                        local up112 = v2463
                        v2470 = up112
                        v2470.Name = "BreathingGlow"
                        v2470 = up112
                        v2470.BackgroundTransparency = 1
                        v2470 = up112
                        v2466 = UDim2.new(0, -20, 0, -20)
                        v2470.Position = v2466
                        v2470 = up112
                        v2466 = UDim2.new(1, 40, 1, 40)
                        v2470.Size = v2466
                        v2470 = up112
                        v2470.ZIndex = -1
                        v2470 = up112
                        v2470.Image = "rbxassetid://6015667104"
                        v2470 = up112
                        v2466 = Color3.fromRGB (0, 120, 255)
                        v2470.ImageColor3 = v2466
                        v2470 = up112
                        v2470.ImageTransparency = .8
                        v2470 = up112
                        v2470.Parent = up111
                        task.spawn(function()
                            local v3594, v3595, v3598, v3599, v3600, v3602
                            while true do
                                v3594 = up111
                                if not v3594.Parent then
                                    break
                                end
                                v3598 = up183
                                v3599 = up112
                                v3595 = TweenInfo.new
                                v3600 = Enum.EasingStyle.Sine
                                v3602 = Enum.EasingDirection
                                v3598:Create(v3599, (v3595(2, v3600, v3602.InOut)), {["ImageTransparency"] = .4}):Play()
                                task.wait(2)
                                v3598 = up183
                                v3599 = up112
                                v3595 = TweenInfo.new
                                v3600 = Enum.EasingStyle.Sine
                                v3602 = Enum.EasingDirection
                                v3598:Create(v3599, (v3595(2, v3600, v3602.InOut)), {["ImageTransparency"] = .8}):Play()
                                task.wait(2)
                            end
                            return
                        end)
                    end
                end
                return
            end
            v3771(v3773)
            v3771 = task.spawn
            v3773 = function()
                local v2483, v2488, v2491, v2492, v2493, v2494, v2495, v2496, v2497, v2498, v2499
                local v2485 = game.Players.LocalPlayer
                local up113 = v2485
                local v2479 = gethui and (gethui())
                local v2484 = v2479
                if not (v2479) then
                    v2483 = game:GetService("CoreGui")
                    v2479 = v2483
                    if not (v2483) then
                        v2479 = (up113:WaitForChild("PlayerGui"))
                    end
                    v2484 = v2479
                end
                local v2481 = function(arg281_1, arg281_2)
                    local v3357, v3360, v3362, v3363, v3364, v3365
                    local v3355 = arg281_1
                    local v3356 = (not v3355)
                    local up143 = arg281_2
                    if v3356 then
                        v3356 = nil
                        return v3356
                    else
                        v3357 = v3355.GetDescendants
                        v3356 = pairs
                        for v3360, v3362 in v3356(v3357(v3355)) do
                            local up144 = v3362
                            v3363 = function()
                                return up143(up144)
                            end
                            v3364, v3365 = pcall(v3363)
                            v3363 = (v3364 and v3365)
                            if v3363 then
                                v3356 = up144
                                return v3356
                            else
                                v3362 = nil
                            end
                        end
                        v3356 = nil
                        return v3356
                    end
                end
                v2479 = v2484
                v2483 = 30
                local v2489 = 1
                for v2482 = 1, v2483, v2489 do
                    task.wait(1)
                    v2488 = (v2479:FindFirstChild("Fluent"))
                    if v2488 then
                        local up114 = (v2481(v2488, function(arg284_1)
                            local v3382, v3385
                            local v3383 = arg284_1
                            local v3387 = (v3383.Name == "Main")
                            local v3388 = v3387
                            if not (v3387) then
                                v3385 = v3383:IsA("Frame")
                                v3387 = v3385
                                if v3385 then
                                    v3382 = (v3383.Size.X.Offset > 500)
                                    v3385 = v3382
                                    if v3382 then
                                        v3385 = (v3383.Size.Y.Offset > 400)
                                    end
                                    v3387 = v3385
                                end
                                v3388 = v3387
                            end
                            return v3388
                        end))
                        if up114 then
                            v2491 = (v2481(up114, function(arg237_1)
                                local v2851 = arg237_1
                                local v2854 = v2851:IsA("ScrollingFrame")
                                local v2857 = v2854
                                if v2854 then
                                    v2857 = (v2851.AbsolutePosition.X < (up114.AbsolutePosition.X + 80))
                                end
                                return v2857
                            end))
                            if v2491 then
                                v2491 = v2491.Parent
                                if v2491 then
                                    v2493 = up114:FindFirstChild("UserProfileCard")
                                    if (not v2493) then
                                        v2492 = Instance.new("Frame")
                                        v2492.Name = "UserProfileCard"
                                        v2492.Parent = up114
                                        v2494 = Color3.fromRGB(20, 20, 25)
                                        v2492.BackgroundColor3 = v2494
                                        v2492.BackgroundTransparency = .2
                                        v2494 = UDim2.new(0, 10, 1, -70)
                                        v2492.Position = v2494
                                        v2494 = UDim2.new(0, 140, 0, 54)
                                        v2492.Size = v2494
                                        v2492.ZIndex = 5000
                                        v2493 = Instance.new("UICorner")
                                        v2495 = UDim.new(0, 10)
                                        v2493.CornerRadius = v2495
                                        v2493.Parent = v2492
                                        v2494 = Instance.new("UIStroke")
                                        v2496 = Color3.fromRGB(0, 255, 255)
                                        v2494.Color = v2496
                                        v2494.Transparency = 0.5
                                        v2494.Thickness = 1.5
                                        v2494.Parent = v2492
                                        v2495 = Instance.new("ImageLabel")
                                        local up115 = v2495
                                        v2484 = up115
                                        v2484.Name = "Avatar"
                                        v2484 = up115
                                        v2484.Parent = v2492
                                        v2484 = up115
                                        v2484.BackgroundTransparency = 1
                                        v2484 = up115
                                        v2498 = UDim2.new(0, 8, 0.5, -18)
                                        v2484.Position = v2498
                                        v2484 = up115
                                        v2498 = UDim2.new(0, 36, 0, 36)
                                        v2484.Size = v2498
                                        v2497 = function()
                                            local v1515 = up115
                                            local v1516 = game.Players
                                            local v1518 = up113.UserId
                                            local v1520 = Enum.ThumbnailType.HeadShot
                                            v1515.Image = v1516:GetUserThumbnailAsync(v1518, v1520, Enum.ThumbnailSize.Size150x150 )

                                            return
                                        end
                                        pcall(v2497)
                                        v2495 = Instance.new("UICorner")
                                        v2498 = UDim.new(1, 0)
                                        v2495.CornerRadius = v2498
                                        v2495.Parent = up115
                                        v2497 = Instance.new("TextLabel")
                                        v2497.Name = "Name"
                                        v2497.Parent = v2492
                                        v2497.BackgroundTransparency = 1
                                        v2499 = UDim2.new(0, 52, 0, 18)
                                        v2497.Position = v2499
                                        v2499 = UDim2.new(1, -55, 0, 18)
                                        v2497.Size = v2499
                                        v2498 = Enum.Font.FredokaOne
                                        v2497.Font = v2498
                                        v2498 = up113.DisplayName
                                        v2497.Text = v2498
                                        v2499 = Color3.fromRGB(255, 255, 255)
                                        v2497.TextColor3 = v2499
                                        v2497.TextSize = 13
                                        v2498 = Enum.TextXAlignment.Left
                                        v2497.TextXAlignment = v2498
                                    end
                                    v2492 = (v2491:FindFirstChildOfClass("ScrollingFrame"))
                                    v2484 = v2492 and (not (v2491:FindFirstChild("SidebarFooter")))
                                    if v2484 then
                                        v2493 = (v2481(v2492, function(arg200_1)
                                            local v2445 = (arg200_1:FindFirstChild("Title", true))
                                            local v2449 = v2445
                                            if v2445 then
                                                v2449 = (string.find((v2445.Text:upper()), "SETTING"))
                                            end
                                            return v2449
                                        end))
                                        if v2493 then
                                            v2494 = Instance.new("Frame")
                                            v2494.Name = "SidebarFooter"
                                            v2494.Parent = v2491
                                            v2494.BackgroundTransparency = 1
                                            v2496 = UDim2.new(0, 0, 1, -45)
                                            v2494.Position = v2496
                                            v2496 = UDim2.new(1, 0, 0, 40)
                                            v2494.Size = v2496
                                            v2494.ZIndex = 5000
                                            v2495 = Instance.new("Frame")
                                            v2495.Name = "CyanIndicator"
                                            v2495.Parent = v2494
                                            v2497 = Color3.fromRGB(0, 255, 255)
                                            v2495.BackgroundColor3 = v2497
                                            v2495.BorderSizePixel = 0
                                            v2497 = UDim2.new(0, 4, .2, 0)
                                            v2495.Position = v2497
                                            v2497 = UDim2.new(0, 3, .6, 0)
                                            v2495.Size = v2497
                                            v2495.ZIndex = 5100
                                            v2496 = Instance.new("UICorner")
                                            v2498 = UDim.new(1, 0)
                                            v2496.CornerRadius = v2498
                                            v2496.Parent = v2495
                                            v2493.Parent = v2494
                                            v2498 = UDim2.new(0, 5, 0, 0)
                                            v2493.Position = v2498
                                            v2498 = UDim2.new(1, -10, 1, 0)
                                            v2493.Size = v2498
                                            v2498 = UDim2.new(1, 0, 1, -130)
                                            v2492.Size = v2498
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return
            end
            v3771(v3773)
            v3774 = up196:AddTab({["Title"] = "Character", ["Icon"] = "user"})
            v3776 = up196:AddTab({["Title"] = "Visuals", ["Icon"] = "users"})
            spilledValues1.value14 = up196:AddTab({["Title"] = "Murderer", ["Icon"] = "skull"})
            spilledValues1.value16 = up196:AddTab({["Title"] = "Sheriff", ["Icon"] = "shield"})
            spilledValues1.value17 = up196:AddTab({["Title"] = "Auto Farm", ["Icon"] = "coins"})
            spilledValues1.value20 = up196:AddTab({["Title"] = "Teleport", ["Icon"] = "map-pin"})
            v3786 = up196:AddTab({["Title"] = "Settings", ["Icon"] = "settings"})
            v3771 = {["Me"] = v3774, ["Player"] = v3776, ["Murder"] = spilledValues1.value14, ["Sheriff"] = spilledValues1.value16, ["AutoFarm"] = spilledValues1.value17, ["Teleport"] = spilledValues1.value20, ["Settings"] = v3786}
            v3772 = _G
            v3772.SnowingActive = false
            ApplySnowToChar = function(arg204_1)
                return
            end
            ToggleSnow = function(arg205_1)
                local v2511, v2512
                _G.SnowingActive = arg205_1
                local v2510 = game.Players.LocalPlayer.Character
                if arg205_1 then
                    if v2510 then
                        ApplySnowToChar(v2510)
                    end
                else
                    if v2510 then
                        v2511 = (v2510:FindFirstChild("HumanoidRootPart"))
                        if v2511 then
                            v2512 = (v2511:FindFirstChild("VelonexSnowAtt"))
                            if v2512 then
                                v2512:Destroy()
                            end
                        end
                    end
                end
                return
            end
            v3772 = game.Players.LocalPlayer.CharacterAdded
            v3774 = function(arg206_1)
                local v2515 = arg206_1
                local v2518 = v2515:WaitForChild("Humanoid", 10)
                local v2520 = task
                local v2516 = v2518
                v2520.wait(1)
                v2520 = _G
                if v2520["SnowingActive"] then
                    ApplySnowToChar(v2515)
                end
                if v2516 then
                    v2516.WalkSpeed = 16
                end
                return
            end
            v3772:Connect(v3774)
            v3772 = _G
            v3772.LastPrintedMurderer = nil
            v3772 = _G
            v3772.LastPrintedSheriff = nil
            v3772 = _G
            v3774 = function()
                local v2524, v2527, v2528, v2530, v2531, v2533, v2534, v2538
                up192()
                local v2525
                local v2526
                v2524, v2533, v2534 = pairs(game.Players:GetPlayers())
                local v2532 = v2524
                while true do
                    v2534, v2531 = v2532(v2533, v2534)
                    if not v2534 then
                        break
                    end
                    v2528 = up186(v2531)
                    if (v2528 == "Murderer") then
                        v2525 = v2531.Name
                    else
                        if (v2528 == "Sheriff") then
                            v2526 = v2531.Name
                        end
                    end
                end
                v2533 = v2525
                if v2525 then
                    v2533 = (_G.LastHasMurderer ~= v2525)
                end
                if v2533 then
                    v2533 = _G
                    v2533.LastHasMurderer = v2525
                    _G.PlayUISound()
                    v2534 = game.Players:FindFirstChild(v2525)
                    v2533 = v2534 and (GetPlayerAbility(v2534)) or "None"
                    v2532 = v2534 and (GetPlayerPerk(v2534)) or "None"
                    v2527 = up179
                    v2531 = v2527.Notify
                    v2538 = string.format("%s is the Murderer!\nAbility: %s\nPower: %s", v2525, v2533, v2532)
                    v2531(v2527, {["Title"] = "🔪 Murderer Identified", ["Content"] = v2538, ["Duration"] = 10})
                else
                    if (not v2525) then
                        v2533 = _G
                        v2533.LastHasMurderer = nil
                    end
                end
                v2533 = v2526
                if v2526 then
                    v2533 = (_G.LastHasSheriff ~= v2526)
                end
                if v2533 then
                    v2533 = _G
                    v2533.LastHasSheriff = v2526
                    _G.PlayUISound()
                    v2533 = up179
                    v2530 = (v2526 .. " is the Sheriff!")
                    v2532 = {["Title"] = "🛡️ Sheriff", ["Content"] = v2530, ["Duration"] = 7}
                    v2533:Notify(v2532)
                else
                    if (not v2526) then
                        v2533 = _G
                        v2533.LastHasSheriff = nil
                    end
                end
                return
            end
            v3772.ShowRolesHelper = v3774
            v3772 = _G
            v3772.XrayActive = false
            v3772 = _G
            v3772.XrayCache = {}
            RestoreXray = function()
                local v2550
                _G.XrayActive = false
                local v2544 = pairs
                local v2548 = _G
                local v2552 = "XrayCache"
                for v2546, v2552 in v2544(v2548[v2552]) do
                    local up116 = v2546
                    local up117 = v2552
                    v2550 = function()
                        local v1547
                        local v1540 = up116
                        local v1541 = v1540
                        if v1540 then
                            v1541 = up116.Parent
                        end
                        if v1541 then
                            v1547 = up116
                            v1540 = up117
                            v1547.Transparency = v1540
                        end
                        return
                    end
                    v2552 = nil
                    pcall(v2550)
                end
                table.clear(_G.XrayCache)
                v2544 = pairs
                v2552 = game
                for v2547, v2552 in v2544(v2552.Players:GetPlayers()) do
                    local up118 = v2552
                    v2550 = function()
                        local v565
                        local v561 = up118
                        if v561.Character then
                            v565 = (up118.Character:FindFirstChild("XrayHighlight"))
                            if v565 then
                                v565:Destroy()
                            end
                        end
                        return
                    end
                    pcall(v2550)
                    v2552 = nil
                end
                return
            end
            ApplyXray = function(arg209_1)
                local up119 = arg209_1
                local v2554 = _G
                if (not v2554.XrayActive ) then
                    return
                else
                    v2554 = function()
                        local v1970, v1975, v1976, v1978, v1979, v1984
                        local v1974 = game.Players.LocalPlayer
                        local v1972 = up119
                        local v1968 = v1974
                        local v1969 = v1972:IsA("BasePart")
                        local v1973 = v1969
                        if v1969 then
                            v1970 = (up119.ClassName ~= "Terrain")
                            v1972 = v1970
                            if v1970 then
                                v1976 = up119
                                v1984 = v1968.Character
                                v1978 = v1984
                                if not (v1984) then
                                    v1978 = (Instance.new("Folder"))
                                end
                                v1975 = (not (v1976:IsDescendantOf(v1978)))
                                v1970 = v1975
                                if v1975 then
                                    v1976 = up119
                                    v1979 = workspace
                                    v1970 = (not (v1976:IsDescendantOf(v1979.CurrentCamera)))
                                end
                                v1972 = v1970
                            end
                            v1973 = v1972
                        end
                        if v1973 then
                            v1969 = up119.Parent:FindFirstChildOfClass("Humanoid")
                            v1973 = v1969
                            if not (v1969) then
                                v1970 = up119.Parent.Parent
                                v1972 = v1970
                                if v1970 then
                                    v1972 = (up119.Parent .Parent:FindFirstChildOfClass("Humanoid"))
                                end
                                v1973 = v1972
                            end
                            if (not v1973) then
                                v1970 = _G
                                if (not v1970.XrayCache [up119]) then
                                    v1974 = _G.XrayCache
                                    v1973 = up119
                                    v1969 = up119.Transparency
                                    v1974[v1973] = v1969
                                end
                                v1974 = up119
                                v1974.Transparency = .8
                            end
                        end
                        return
                    end
                    pcall(v2554)
                    return
                end
            end
            v3772 = function()
                local v2566
                local v2561 = _G
                if (not v2561["XrayActive"]) then
                    return
                else
                    v2566 = _G
                    v2566.XrayActive = true
                    v2566 = task.spawn
                    v2561 = function()
                        local v1742, v1744, v1745, v1746, v1747, v1749, v1750, v1751, v1755, v1756, v1757
                        while true do
                            v1742 = _G
                            if not v1742["XrayActive"] then
                                break
                            end
                            v1746 = game.Players.LocalPlayer
                            v1742 = v1746 and v1746.Character
                            local up71 = v1742
                            v1744 = 0
                            v1742, v1745, v1747 = pairs(workspace:GetDescendants())
                            v1749 = v1742
                            while true do
                                v1747, v1750 = v1749(v1745, v1747)
                                if not v1747 then
                                    break
                                end
                                local up72 = v1750
                                v1751 = _G
                                if not ((not v1751["XrayActive"]))then
                                    v1751 = function()
                                        local v1528, v1529, v1531, v1533, v1539
                                        local v1530 = up72:IsA("BasePart")
                                        local v1534 = v1530
                                        if v1530 then
                                            v1534 = (up72.ClassName ~= "Terrain")
                                        end
                                        if v1534 then
                                            v1533 = up71
                                            v1528 = v1533
                                            if v1533 then
                                                v1533 = up72
                                                v1531 = up71
                                                v1528 = (v1533:IsDescendantOf(v1531))
                                            end
                                            v1534 = v1528
                                            if not (v1528) then
                                                v1528 = up72
                                                v1529 = workspace
                                                v1534 = (v1528:IsDescendantOf(v1529.CurrentCamera))
                                            end
                                            if (not v1534) then
                                                v1533 = up72.Parent:FindFirstChildOfClass("Humanoid")
                                                v1534 = v1533
                                                if not (v1533) then
                                                    v1529 = up72.Parent.Parent
                                                    v1530 = v1529
                                                    if v1529 then
                                                        v1530 = (up72.Parent.Parent:FindFirstChildOfClass("Humanoid"))
                                                    end
                                                    v1534 = v1530
                                                end
                                                v1533 = (not v1534)
                                                v1534 = v1533
                                                if v1533 then
                                                    v1534 = (up72.Transparency < 1)
                                                end
                                                if v1534 then
                                                    v1529 = _G
                                                    if (not v1529["XrayCache"][up72]) then
                                                        v1539 = _G.XrayCache
                                                        v1534 = up72
                                                        v1533 = up72.Transparency
                                                        v1539[v1534] = v1533
                                                    end
                                                    v1539 = up72
                                                    v1539.Transparency = .8
                                                end
                                            end
                                        end
                                        return
                                    end
                                    pcall(v1751)
                                    v1744 = (v1744 + 1)
                                    if ((v1744 % 300) == 0) then
                                        task.wait()
                                    end
                                    continue
                                end
                                break
                            end
                            v1747, v1749, v1757 = pairs(game.Players:GetPlayers())
                            while true do
                                v1757, v1750 = v1747(v1749, v1757)
                                if not v1757 then
                                    break
                                end
                                local up73 = v1750
                                v1756 = (up73 ~= v1746)
                                v1755 = v1756
                                if v1756 then
                                    v1755 = up73.Character
                                end
                                if v1755 then
                                    v1756 = function()
                                        local v3033, v3034, v3035
                                        local v3032 = up73.Character:FindFirstChild("XrayHighlight")
                                        if (not v3032) then
                                            v3033 = (Instance.new("Highlight"))
                                            v3033.Name = "XrayHighlight"
                                            v3032 = Enum.HighlightDepthMode.AlwaysOnTop
                                            v3033.DepthMode = v3032
                                            v3033.FillTransparency = .3
                                            v3033.OutlineTransparency = 0
                                            v3034 = (up186(up73))
                                            if (v3034 == "Murderer") then
                                                v3035 = Color3.fromRGB(255, 30, 30)
                                                v3033.FillColor = v3035
                                                v3035 = Color3.fromRGB(255, 80, 80)
                                                v3033.OutlineColor = v3035
                                            else
                                                v3032 = (v3034 == "Sheriff") or (v3034 == "Hero")
                                                if v3032 then
                                                    v3035 = Color3.fromRGB(30, 120, 255)
                                                    v3033.FillColor = v3035
                                                    v3035 = Color3.fromRGB(80, 160, 255)
                                                    v3033.OutlineColor = v3035
                                                else
                                                    v3035 = Color3.fromRGB(30, 220, 80)
                                                    v3033.FillColor = v3035
                                                    v3035 = Color3.fromRGB(80, 255, 120)
                                                    v3033.OutlineColor = v3035
                                                end
                                            end
                                            v3032 = up73.Character
                                            v3033.Parent = v3032
                                        end
                                        return
                                    end
                                    pcall(v1756)
                                end
                            end
                            v1749 = _G
                            if not ((not v1749["XrayActive"]))then
                                task.wait(3)

                                continue
                            end
                            break
                        end
                        return
                    end
                    v2566(v2561)
                    return
                end
            end
            StartXray = v3772
            v3772 = function(arg211_1)
                local v2574, v2577
                local v2569 = game
                local v2570 = arg211_1
                local v2575 = v2569.Players.LocalPlayer
                local up120 = v2575
                v2575 = up120.Character
                local up121 = v2575
                if (not up121) then
                    return
                else
                    v2574 = up189(up120)
                    local up122 = v2574
                    if (not up122) then
                        return
                    else
                        v2574 = up122:FindFirstChild("Handle")
                        local up123 = v2574
                        if (not up123) then
                            return
                        else
                            local up124 = v2570.Character
                            if (not up124) then
                                return
                            else
                                v2574 = up124:FindFirstChild("HumanoidRootPart")
                                if (not v2574) then
                                    return
                                else
                                    v2577 = function()
                                        local v2183, v2184, v2186, v2188
                                        local v2189 = (up122.Parent == up120.Backpack)
                                        local up96 = v2189
                                        if up96 then
                                            v2189 = up122
                                            v2186 = up121
                                            v2189.Parent = v2186
                                        end
                                        if firetouchinterest then
                                            v2189 = pairs
                                            v2184 = up124
                                            v2188 = v2184.GetChildren
                                            for v2183, v2188 in v2189(v2188(v2184)) do
                                                v2189 = v2188:IsA("BasePart")
                                                if v2189 then
                                                    firetouchinterest(up123, v2188, 0)
                                                    firetouchinterest(up123, v2188, 1)
                                                end
                                            end
                                        end
                                        task.defer(function()
                                            local v3683, v3689
                                            local v3681 = up96
                                            local v3682 = v3681
                                            if v3681 then
                                                v3683 = up122
                                                v3681 = v3683
                                                if v3683 then
                                                    v3681 = up122.Parent
                                                end
                                                v3682 = v3681
                                            end
                                            if v3682 then
                                                v3689 = up122
                                                v3681 = up120.Backpack
                                                v3689.Parent = v3681
                                            end
                                            return
                                        end)

                                        return
                                    end
                                    pcall(v2577)
                                    return
                                end
                            end
                        end
                    end
                end
            end
            v3773 = task.spawn
            v3775 = function()
                local v2580, v2583, v2584, v2586, v2587, v2590, v2591, v2592, v2593
                while true do
                    task.wait (1)
                    v2580 = pairs
                    v2584 = workspace
                    v2586 = v2584.GetDescendants
                    for v2583, v2586 in v2580(v2586(v2584)) do
                        v2592 = (v2586.Name == "Trap")
                        v2593 = v2592
                        if v2592 then
                            v2590 = v2586:IsA("Model")
                            v2592 = v2590
                            if not (v2590) then
                                v2592 = (v2586:IsA("BasePart"))
                            end
                            v2593 = v2592
                        end
                        if v2593 then
                            v2580 = v2586:IsA("Model")
                            if v2580 then
                                v2587 = v2586.GetDescendants
                                v2580 = pairs
                                for v2591, v2587 in v2580(v2587(v2586)) do
                                    v2580 = v2587:IsA("BasePart")
                                    if v2580 then
                                        v2587.CanTouch = false
                                        v2587.Transparency = 0.5
                                    end
                                end
                            else
                                v2586.CanTouch = false
                                v2586.Transparency = 0.5
                            end
                            v2593 = v2586:FindFirstChild("TrapLabel")
                            if (not v2593) then
                                v2592 = ((v2586:IsA("BasePart")) and v2586)
                                v2593 = v2592
                                if not (v2592) then
                                    v2593 = (v2586:FindFirstChildWhichIsA("BasePart", true))
                                end
                                if v2593 then
                                    v2592 = Instance.new("BillboardGui")
                                    v2592.Name = "TrapLabel"
                                    v2592.Adornee = v2593
                                    v2590 = UDim2.new(4, 0, 1, 0)
                                    v2592.Size = v2590
                                    v2590 = Vector3.new(0, 2, 0)
                                    v2592.StudsOffset = v2590
                                    v2592.AlwaysOnTop = true
                                    v2592.Parent = v2586
                                    v2591 = Instance.new("TextLabel")
                                    v2591.BackgroundTransparency = 1
                                    v2587 = UDim2.new(1, 0, 1, 0)
                                    v2591.Size = v2587
                                    v2590 = Enum.Font.GothamBold
                                    v2591.Font = v2590
                                    v2591.Text = "TRAP"
                                    v2587 = Color3.fromRGB(255, 120, 0)
                                    v2591.TextColor3 = v2587
                                    v2591.TextSize = 14
                                    v2591.TextStrokeTransparency = 0
                                    v2591.Parent = v2592
                                end
                                v2592 = Instance.new("Highlight")
                                v2592.Name = "TrapHighlight"
                                v2590 = Color3.fromRGB(255, 120, 0)
                                v2592.FillColor = v2590
                                v2590 = Color3.fromRGB(255, 255, 255)
                                v2592.OutlineColor = v2590
                                v2592.FillTransparency = .4
                                v2592.Parent = v2586
                            end
                        end
                    end
                end
            end
            v3773(v3775)
            local up197 = {}
            v3775 = Instance.new("ScreenGui")
            local up198 = v3775
            v3776 = Instance.new("Frame")
            spilledValues1.value13 = Instance.new("UICorner")
            spilledValues1.value14 = Instance.new("UIGradient")
            spilledValues1.value15 = Instance.new("TextLabel")
            spilledValues1.value16 = Instance.new("TextLabel")
            local up199 = spilledValues1.value16
            spilledValues1.value18 = Instance.new("UIStroke")
            spilledValues1.value16 = up198
            spilledValues1.value16.Name = "CoinWatermark"
            spilledValues1.value16 = up198
            spilledValues1.value17 = "Parent"
            v3785 = gethui and (gethui())
            spilledValues1.value19 = v3785
            if not (v3785) then
                v3787 = game:GetService("CoreGui")
                v3785 = v3787
                if not (v3787) then
                    v3785 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                end
                spilledValues1.value19 = v3785
            end
            spilledValues1.value16[spilledValues1.value17] = spilledValues1.value19
            spilledValues1.value16 = up198
            spilledValues1.value16.ResetOnSpawn = false
            v3776.Name = "MainFrame"
            v3776.Parent = up198
            spilledValues1.value19 = Color3.fromRGB(20, 20, 25)
            v3776.BackgroundColor3 = spilledValues1.value19
            v3776.BackgroundTransparency = .15
            spilledValues1.value19 = UDim2.new(.05, 0, .15, 0)
            v3776.Position = spilledValues1.value19
            spilledValues1.value19 = UDim2.new(0, 220, 0, 85)
            v3776.Size = spilledValues1.value19
            v3776.Active = true
            v3776.Draggable = true
            spilledValues1.value19 = UDim.new(0, 10)
            spilledValues1.value13.CornerRadius = spilledValues1.value19
            spilledValues1.value13.Parent = v3776
            spilledValues1.value17 = ColorSequence.new
            v3786 = ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 45, 255))
            v3785 = ColorSequenceKeypoint.new
            v3788 = Color3.fromRGB
            spilledValues1.value19 = spilledValues1.value17({v3786, v3785(1, v3788(130, 80, 255))})
            spilledValues1.value14.Color = spilledValues1.value19
            spilledValues1.value14.Parent = v3776
            spilledValues1.value18.Thickness = 1.5
            spilledValues1.value19 = Color3.fromRGB(95, 45, 255)
            spilledValues1.value18.Color = spilledValues1.value19
            spilledValues1.value17 = Enum.ApplyStrokeMode.Border
            spilledValues1.value18.ApplyStrokeMode = spilledValues1.value17
            spilledValues1.value18.Parent = v3776
            spilledValues1.value15.Name = "TitleLabel"
            spilledValues1.value15.Parent = v3776
            spilledValues1.value15.BackgroundTransparency = 1
            spilledValues1.value19 = UDim2.new(0, 10, 0, 5)
            spilledValues1.value15.Position = spilledValues1.value19
            spilledValues1.value19 = UDim2.new(1, -20, 0, 25)
            spilledValues1.value15.Size = spilledValues1.value19
            spilledValues1.value17 = Enum.Font.GothamBold
            spilledValues1.value15.Font = spilledValues1.value17
            spilledValues1.value15.Text = "COIN FARM HUD"
            spilledValues1.value19 = Color3.fromRGB(255, 255, 255)
            spilledValues1.value15.TextColor3 = spilledValues1.value19
            spilledValues1.value15.TextSize = 14
            spilledValues1.value17 = Enum.TextXAlignment.Left
            spilledValues1.value15.TextXAlignment = spilledValues1.value17
            spilledValues1.value16 = up199
            spilledValues1.value16.Name = "StatsLabel"
            spilledValues1.value16 = up199
            spilledValues1.value16.Parent = v3776
            spilledValues1.value16 = up199
            spilledValues1.value16.BackgroundTransparency = 1
            spilledValues1.value16 = up199
            spilledValues1.value20 = UDim2.new(0, 10, 0, 30)
            spilledValues1.value16.Position = spilledValues1.value20
            spilledValues1.value16 = up199
            spilledValues1.value20 = UDim2.new(1, -20, 0, 50)
            spilledValues1.value16.Size = spilledValues1.value20
            spilledValues1.value16 = up199
            spilledValues1.value19 = Enum.Font.GothamMedium
            spilledValues1.value16.Font = spilledValues1.value19
            spilledValues1.value16 = up199
            spilledValues1.value16.Text = "Coins: 0 / 50\nStatus: Teleporting..."
            spilledValues1.value16 = up199
            spilledValues1.value20 = Color3.fromRGB(235, 235, 255)
            spilledValues1.value16.TextColor3 = spilledValues1.value20
            spilledValues1.value16 = up199
            spilledValues1.value16.TextSize = 13
            spilledValues1.value16 = up199
            spilledValues1.value19 = Enum.TextXAlignment.Left
            spilledValues1.value16.TextXAlignment = spilledValues1.value19
            spilledValues1.value16 = up199
            spilledValues1.value19 = Enum.TextYAlignment.Top
            spilledValues1.value16.TextYAlignment = spilledValues1.value19
            spilledValues1.value16 = up198
            spilledValues1.value16.Enabled = false
            spilledValues1.value17 = function(arg52_1, arg52_2)
                local v880 = up199
                local v881 = arg52_1
                local v882 = string.format
                local v878 = arg52_2
                if not (arg52_2) then
                    v878 = "Farming"
                end
                v880.Text = v882("Coins: %d / 50\nStatus: %s", v881, v878)

                return
            end
            local up200 = spilledValues1.value17
            spilledValues1.value19 = function(arg53_1)
                local v894, v895
                local up35 = arg53_1
                local v890 = _G
                if v890["XrayActive"] then
                    task.spawn(StartXray)
                end
                if up197[up35] then
                    return
                else
                    up197[up35] = true
                    v895 = up198
                    v895.Enabled = true
                    v895 = task.spawn
                    v894 = function()
                        local v2033, v2034, v2035, v2037, v2038, v2039, v2040, v2041, v2042, v2043, v2044, v2045, v2046, v2047, v2048, v2049
                        local v2050, v2051, v2052, v2053
                        local v2054, v2055, v2056, v2057, v2058, v2059, v2060, v2061, v2063, v2064
                        local v2036 = game.Players.LocalPlayer
                        local up91 = v2036
                        local v2030 = (game:GetService("RunService"))
                        v2036 = workspace.CurrentCamera
                        while true do
                            v2033 = _G.AutoCoinV3
                            v2035 = v2033
                            if v2033 then
                                v2035 = up35.Parent
                            end
                            if v2035 then
                                v2036 = up91.Character
                                local up92 = v2036
                                v2034 = up92
                                v2035 = v2034
                                if v2034 then
                                    v2039 = up92:FindFirstChild("HumanoidRootPart")
                                    v2034 = v2039
                                    if v2039 then
                                        v2041 = up92:FindFirstChild("Humanoid")
                                        v2038 = v2041
                                        if v2041 then
                                            v2043 = up92
                                            v2038 = (v2043.Humanoid.Health > 0)
                                        end
                                        v2034 = v2038
                                    end
                                    v2035 = v2034
                                end
                                if v2035 then
                                    v2036 = up92.HumanoidRootPart
                                    local up93 = v2036
                                    v2037 = {}
                                    v2035, v2038, v2039 = pairs(up35:GetChildren())
                                    v2040 = v2035
                                    while true do
                                        v2039, v2042 = v2040(v2038, v2039)
                                        if not v2039 then
                                            break
                                        end
                                        v2043 = (v2042.Name == "Coin_Server") and (v2042:IsA("BasePart"))
                                        if v2043 then
                                            v2043 = table
                                            v2043.insert(v2037, v2042)
                                        end
                                    end
                                    table.sort(v2037, function(arg234_1, arg234_2)
                                        local v2839 = (up93.Position - arg234_1.Position).Magnitude
                                        local v2832 = up93.Position
                                        return (v2839 < (v2832 - arg234_2.Position).Magnitude)
                                    end)
                                    if ((#v2037) == 0) then
                                        v2036 = _G
                                        v2036.AutoCoinV3 = false
                                        v2038 = _G
                                        if v2038["AutoFarmCoinToggle"] then
                                            v2039 = function()
                                                _G.AutoFarmCoinToggle:SetValue(false)
                                                return
                                            end
                                            pcall(v2039)
                                        end
                                        pcall(function()
                                            up179:Notify({["Title"] = "Auto Farm", ["Content"] = "No coins left. Teleporting to Lobby...", ["Duration"] = 3})
                                            return
                                        end)
                                        v2039 = _G.MapCoordinates
                                        v2038 = v2039
                                        if v2039 then
                                            v2038 = _G.MapCoordinates.Lobby
                                        end
                                        if v2038 then
                                            v2036 = up93
                                            v2043 = _G
                                            v2039 = (v2043.MapCoordinates.Lobby[1] + (Vector3.new(0, 3, 0)))
                                            v2036.CFrame = v2039
                                        else
                                            v2036 = up93
                                            v2040 = CFrame.new(-108.5, 143, 15)
                                            v2036.CFrame = v2040
                                        end
                                        break
                                    else
                                        for v2041, v2043 in ipairs(v2037) do
                                            v2045 = (not _G.AutoCoinV3)
                                            v2044 = v2045
                                            if not (v2045) then
                                                v2047 = (not up35.Parent)
                                                v2045 = v2047
                                                if not (v2047) then
                                                    v2045 = (up92.Humanoid.Health <= 0)
                                                end
                                                v2044 = v2045
                                            end
                                            if not (v2044) then
                                                while true do
                                                    v2045 = _G.IsCollectingGun
                                                    v2044 = v2045
                                                    if v2045 then
                                                        v2044 = _G.AutoCoinV3
                                                    end
                                                    if v2044 then
                                                        task.wait(0.5)
                                                    else
                                                        break
                                                    end
                                                end
                                                if v2043["Parent"] then
                                                    v2044 = (up93.Position - v2043.Position).Magnitude
                                                    v2046 = math.clamp((v2044 / 25), .2, 10)
                                                    v2036 = v2030.Stepped
                                                    v2048 = function()
                                                        local v3570, v3571, v3572, v3574, v3580
                                                        if up92 then
                                                            v3570 = pairs
                                                            v3571 = up92
                                                            v3572 = v3571.GetDescendants
                                                            for v3574, v3572 in v3570(v3572(v3571)) do
                                                                v3580 = (v3572:IsA("BasePart")) and v3572.CanCollide
                                                                if v3580 then
                                                                    v3572.CanCollide = false
                                                                end
                                                            end
                                                        end
                                                        return
                                                    end
                                                    v2047 = v2036:Connect(v2048)
                                                    v2048 = Instance.new("BodyVelocity")
                                                    v2050 = Vector3.new(0, 0, 0)
                                                    v2048.Velocity = v2050
                                                    v2050 = Vector3.new(100000, 100000, 100000)
                                                    v2048.MaxForce = v2050
                                                    v2048.Parent = up93
                                                    v2049 = Instance.new("BodyGyro")
                                                    v2051 = Vector3.new(math.huge, math.huge, math.huge)
                                                    v2049.MaxTorque = v2051
                                                    v2049.P = 1000000
                                                    v2049.D = 100
                                                    v2051 = CFrame.new(up93.Position)
                                                    v2049.CFrame = v2051
                                                    v2049.Parent = up93
                                                    v2050 = CFrame.new((v2043.Position + (Vector3.new(0, -5.5, 0))))
                                                    v2051 = TweenInfo.new(v2046, Enum.EasingStyle.Linear)
                                                    v2036 = up181
                                                    v2053 = up93
                                                    v2052 = v2036:Create(v2053, v2051, {["CFrame"] = v2050})
                                                    v2052:Play()
                                                    v2053 = 0
                                                    v2054 = false
                                                    while true do
                                                        v2055 = (v2052.PlaybackState == Enum.PlaybackState.Playing) and (v2053 < v2046)
                                                        if v2055 then
                                                            v2056 = (not _G.AutoCoinV3)
                                                            v2055 = v2056
                                                            if not (v2056) then
                                                                v2055 = (up92.Humanoid.Health <= 0)
                                                            end
                                                            if v2055 then
                                                                v2052:Cancel()
                                                                v2054 = true
                                                            else
                                                                if (not v2043["Parent"]) then
                                                                    v2052:Cancel()
                                                                else
                                                                    v2057 = (up93.Position - v2050.Position)
                                                                    if (v2057["Magnitude"] < 3) then
                                                                        v2057 = firetouchinterest
                                                                        v2055 = v2057
                                                                        if v2057 then
                                                                            v2055 = (v2043:IsA("BasePart"))
                                                                        end
                                                                        if v2055 then
                                                                            firetouchinterest(up93, v2043, 0)
                                                                            firetouchinterest(up93, v2043, 1)
                                                                        end
                                                                        task.wait (.3)
                                                                        v2055 = v2043 and (v2043.Parent == up35)
                                                                        if v2055 then
                                                                            v2055 = _G
                                                                            v2058 = (_G.FailedCoinCount or 0)
                                                                            v2055.FailedCoinCount = (v2058 + 1)
                                                                            v2057 = _G
                                                                            if (v2057["FailedCoinCount"] >= 20) then
                                                                                v2055 = _G
                                                                                v2055.FailedCoinCount = 0
                                                                                v2054 = true
                                                                            end
                                                                        else
                                                                            v2056 = _G
                                                                            v2056.FailedCoinCount = 0
                                                                        end
                                                                    else
                                                                        task.wait (.01)
                                                                        v2053 = (v2053 + .01)

                                                                        continue
                                                                    end
                                                                end
                                                            end
                                                        end
                                                        break
                                                    end
                                                    if v2047 then
                                                        v2047:Disconnect()
                                                    end
                                                    v2057 = v2048 and v2048.Parent
                                                    if v2057 then
                                                        v2048:Destroy()
                                                    end
                                                    v2057 = v2049 and v2049.Parent
                                                    if v2057 then
                                                        v2049:Destroy()
                                                    end
                                                    v2059 = up92
                                                    v2057 = v2059
                                                    if v2059 then
                                                        v2057 = (up92:FindFirstChild("Humanoid"))
                                                    end
                                                    if v2057 then
                                                        v2057 = up92.Humanoid
                                                        v2057.PlatformStand = false
                                                        v2057 = pairs
                                                        v2061 = up92
                                                        v2063 = v2061.GetDescendants
                                                        for v2060, v2061 in v2057(v2063(v2061)) do
                                                            local up94 = v2061
                                                            v2063 = up94:IsA("BasePart")
                                                            if v2063 then
                                                                v2064 = function()
                                                                    up94.CanCollide = true
                                                                    return
                                                                end
                                                                pcall(v2064)
                                                            end
                                                            v2061 = nil
                                                        end
                                                    end
                                                    if v2054 then
                                                        break
                                                    else
                                                        task.wait(.15)
                                                    end
                                                end
                                                continue
                                            end
                                            break
                                        end
                                    end
                                end
                                local up95
                                v2039 = function()
                                    local v2410, v2412, v2414, v2416, v2418
                                    local v2413 = up91:FindFirstChild("PlayerGui")
                                    local v2415 = v2413
                                    if v2413 then
                                        v2415 = (up91.PlayerGui:FindFirstChild("MainGUI"))
                                    end
                                    local v2409 = v2415
                                    v2415 = v2409
                                    if v2409 then
                                        v2410 = v2409:FindFirstChild("Game")
                                        v2413 = v2410
                                        if v2410 then
                                            v2416 = v2409.Game:FindFirstChild("CashBag")
                                            v2410 = v2416
                                            if v2416 then
                                                v2418 = v2409.Game.CashBag:FindFirstChild("Container")
                                                v2412 = v2418
                                                if v2418 then
                                                    v2412 = (v2409.Game.CashBag.Container:FindFirstChild("Amount"))
                                                end
                                                v2410 = v2412
                                            end
                                            v2413 = v2410
                                        end
                                        v2415 = v2413
                                    end
                                    v2413 = v2415
                                    v2415 = v2413 and (v2413:IsA("TextLabel"))
                                    if v2415 then
                                        v2414 = v2413.Text
                                        v2410 = (tonumber(v2414:match("(%d+)")))
                                        if v2410 then
                                            up95 = v2410
                                            return
                                        end
                                    end
                                    local v2411 = up91:FindFirstChild("CoinData")
                                    v2415 = v2411
                                    if not (v2411) then
                                        v2415 = (up91.Backpack:FindFirstChild("CoinData"))
                                    end
                                    v2414 = v2415
                                    v2415 = v2414
                                    if v2414 then
                                        v2416 = v2414:IsA("IntValue")
                                        v2411 = v2416
                                        if not (v2416) then
                                            v2411 = (v2414:IsA("NumberValue"))
                                        end
                                        v2415 = v2411
                                    end
                                    if v2415 then
                                        up95 = v2414.Value
                                        return
                                    else
                                        v2410 = game:GetService("ReplicatedStorage"):FindFirstChild("PlayerData")
                                        v2411 = v2410
                                        if v2410 then
                                            v2418 = up91
                                            v2411 = (v2410:FindFirstChild(v2418.Name))
                                        end
                                        if v2411 then
                                            v2411 = v2410[up91.Name]
                                            v2412 = (v2411:FindFirstChild("CoinData")) or (v2411:FindFirstChild("Coins"))
                                            v2416 = v2412
                                            if v2412 then
                                                v2416 = (v2412:IsA("IntValue")) or (v2412:IsA("NumberValue"))
                                            end
                                            if v2416 then
                                                up95 = v2412.Value
                                                return
                                            end
                                        end
                                        return
                                    end
                                end
                                up95 = 0
                                pcall(v2039)
                                pcall(function()
                                    up200(up95, "Farming...")

                                    return
                                end)
                                v2039 = function()
                                    local v2438
                                    local v2437 = up91.PlayerGui:FindFirstChild("MainGUI")
                                    local v2433 = v2437
                                    if v2437 then
                                        v2433 = v2437.Game.CashBag.Container.Max.Visible
                                    end
                                    if v2433 then
                                        v2438 = _G
                                        v2438.MaxBagReached = true
                                    end
                                    return
                                end
                                pcall(v2039)
                                v2034 = _G.MaxBagReached or (up95 >= 50)
                                if v2034 then
                                    v2034 = _G
                                    v2034.FailedCoinCount = 0
                                    v2034 = _G
                                    v2034.MaxBagReached = false
                                    pcall(function()
                                        up200(up95, "Bag Full! Safe Exit.")

                                        return
                                    end)
                                    up179:Notify({["Title"] = "Farm Info", ["Content"] = "Bag Full! Teleporting to Lobby...", ["Duration"] = 5})
                                    v2039 = up91.Character
                                    v2034 = v2039
                                    if v2039 then
                                        v2034 = (up91.Character:FindFirstChild("HumanoidRootPart"))
                                    end
                                    if v2034 then
                                        v2040 = _G.MapCoordinates
                                        v2037 = v2040
                                        if v2040 then
                                            v2037 = _G.MapCoordinates.Lobby
                                        end
                                        if v2037 then
                                            v2039 = _G.MapCoordinates.Lobby[1]
                                            v2034.CFrame = v2039
                                        else
                                            v2040 = CFrame.new(-108.5, 143, 15)
                                            v2034.CFrame = v2040
                                        end
                                        v2037 = _G
                                        v2037.AutoCoinV3 = false
                                        v2039 = _G
                                        if v2039["AutoFarmCoinToggle"] then
                                            _G.AutoFarmCoinToggle:SetValue(false)
                                        end
                                        up179:Notify({["Title"] = "Safe Exit", ["Content"] = "Bag full. Auto-Farm disabled.", ["Duration"] = 10})

                                        break
                                    end
                                end
                                task.wait(.1)

                                continue
                            end
                            break
                        end
                        v2037 = function()
                            up198.Enabled = false
                            return
                        end
                        pcall(v2037)
                        v2037 = (not up35.Parent)
                        v2033 = v2037
                        if v2037 then
                            v2033 = _G.AutoCoinV3
                        end
                        if v2033 then
                            v2033 = _G
                            v2033.AutoCoinV3 = false
                            v2034 = _G
                            if v2034["AutoFarmCoinToggle"] then
                                _G.AutoFarmCoinToggle:SetValue(false)
                            end
                        end
                        up197[up35] = nil
                        return
                    end
                    v895(v894)
                    return
                end
            end
            local up201 = spilledValues1.value19
            spilledValues1.value19 = workspace.DescendantAdded
            v3785 = function(arg54_1)
                local v901, v903
                local v898 = arg54_1
                local v902 = v898.Name
                if (v902 == "CoinContainer") then
                    v903 = _G
                    v903.RoleCache = {}
                    v903 = _G
                    v903.LastHasMurderer = nil
                    v903 = _G
                    v903.LastHasSheriff = nil
                    v901 = function()
                        local v3023
                        local v3021 = pairs
                        local v3027 = game.Players
                        local v3026 = v3027.GetPlayers
                        for v3029, v3026 in v3021(v3026(v3027)) do
                            if v3026["Character"] then
                                v3023 = v3026.Character:FindFirstChild("PlayerChams")
                                if v3023 then
                                    v3023:Destroy()
                                end
                            end
                        end
                        return
                    end
                    pcall(v901)
                    v902 = _G
                    if v902["AutoCoinV3"] then
                        up201(v898)
                    end
                end
                return
            end
            spilledValues1.value19:Connect(v3785)
            spilledValues1.value19 = workspace.DescendantRemoving
            v3785 = function(arg55_1)
                local v909
                local v908 = arg55_1.Name
                if (v908 == "CoinContainer") then
                    v909 = _G
                    v909.RoleCache = {}
                    v909 = _G
                    v909.LastHasMurderer = nil
                    v909 = _G
                    v909.LastHasSheriff = nil
                    pcall(function()
                        local v303
                        local v301 = pairs
                        local v307 = game.Players
                        local v306 = v307.GetPlayers
                        for v309, v306 in v301(v306(v307)) do
                            if v306.Character then
                                v303 = v306.Character:FindFirstChild("PlayerChams")
                                if v303 then
                                    v303:Destroy()
                                end
                            end
                        end
                        return
                    end)
                end
                return
            end
            spilledValues1.value19:Connect(v3785)
            task.spawn(function()
                local v912
                local v910 = game:GetService("VirtualUser")
                local up36 = v910
                while true do
                    task.wait(55)
                    v910 = game.Players
                    if v910.LocalPlayer then
                        v912 = function()
                            up36:CaptureController()
                            up36:ClickButton2(Vector2.new (0, 0))
                            return
                        end
                        pcall(v912)
                    end
                end
            end)
            spilledValues1.value19 = task.spawn
            v3785 = function()
                local v918, v919, v923
                while true do
                    task.wait(2)
                    v919 = _G
                    if v919["ScriptUnloaded"] then
                        break
                    else
                        v918 = pcall
                        v923 = function()
                            local v3476, v3477, v3479, v3481, v3483, v3484, v3486, v3487, v3488, v3489, v3493
                            local v3474 = game.Players.LocalPlayer
                            local v3473 = (v3474:FindFirstChild("PlayerGui"))
                            if v3473 then
                                v3479 = pairs
                                for v3476, v3481 in v3479(v3473:GetChildren()) do
                                    v3487 = (v3481:IsA("ScreenGui")) and v3481.Enabled
                                    if v3487 then
                                        v3479 = pairs
                                        v3483 = v3481.GetChildren
                                        for v3486, v3483 in v3479(v3483(v3481)) do
                                            local up149 = v3483
                                            v3489 = up149:IsA("Frame")
                                            v3484 = v3489
                                            if v3489 then
                                                v3493 = (up149.Name == "Fade")
                                                v3488 = v3493
                                                if not (v3493) then
                                                    v3488 = (up149.Name:find("BlackScreen"))
                                                end
                                                v3484 = v3488
                                            end
                                            if v3484 then
                                                v3488 = up149.Visible
                                                v3484 = v3488
                                                if v3488 then
                                                    v3484 = (up149.BackgroundTransparency < .1)
                                                end
                                                if v3484 then
                                                    task.delay(3, function()
                                                        pcall(function()
                                                            local v1508, v1514
                                                            local v1509 = up149.Parent
                                                            local v1510 = v1509
                                                            if v1509 then
                                                                v1508 = up149.Visible
                                                                v1509 = v1508
                                                                if v1508 then
                                                                    v1509 = (up149.BackgroundTransparency < .1)
                                                                end
                                                                v1510 = v1509
                                                            end
                                                            if v1510 then
                                                                v1514 = up149
                                                                v1514.Visible = false
                                                                v1514 = up149
                                                                v1514.BackgroundTransparency = 1
                                                            end
                                                            return
                                                        end)

                                                        return
                                                    end)
                                                end
                                            end
                                            v3483 = nil
                                        end
                                    end
                                end
                            end
                            v3476 = game.Lighting
                            if (v3476["ExposureCompensation"] < -2) then
                                v3479 = game.Lighting
                                v3479.ExposureCompensation = 0
                            end
                            v3476 = game.Lighting
                            if (v3476["Brightness"] < .2) then
                                v3479 = game.Lighting
                                v3479.Brightness = 2
                            end
                            local v3475 = _G
                            if v3475["GodMode"] then
                                v3475 = v3474.Character
                                v3476 = v3475
                                if v3475 then
                                    v3476 = (v3475:FindFirstChildOfClass("Humanoid"))
                                end
                                v3477 = v3476
                                if v3476 then
                                    v3477 = (workspace.CurrentCamera.CameraSubject ~= v3476)
                                end
                                if v3477 then
                                    v3479 = workspace.CurrentCamera
                                    v3479.CameraSubject = v3476
                                end
                            end
                            return
                        end
                        v918(v923)
                    end
                end
                return
            end
            spilledValues1.value19(v3785)
            spilledValues1.value20 = v3771.Me:AddSection("Movement")
            spilledValues1.value19 = _G
            spilledValues1.value19.WalkSpeedValue = 16
            spilledValues1.value19 = spilledValues1.value20.AddSlider
            v3797 = function(arg58_1)
                local v924 = ((tonumber(arg58_1)) or 16)
                _G.WalkSpeedValue = v924
                _G.SpeedEnabled = (v924 > 16)

                return
            end
            spilledValues1.value19(spilledValues1.value20, "WalkSpeed", {["Title"] = "WalkSpeed", ["Default"] = 16, ["Min"] = 16, ["Max"] = 35, ["Rounding"] = 0, ["Callback"] = v3797})
            spilledValues1.value19 = _G
            spilledValues1.value19.InfJumpActive = false
            spilledValues1.value19 = v3771.Me
            v3785 = spilledValues1.value19.AddToggle
            v3793 = function(arg59_1)
                _G.InfJumpActive = arg59_1
                _G.KeybindNotify("Infinite Jump", arg59_1)
                return
            end
            v3785(spilledValues1.value19, "InfJump", {["Title"] = "Infinite Jump", ["Default"] = false, ["Callback"] = v3793})
            spilledValues1.value19 = _G
            spilledValues1.value19.GodMode = false
            spilledValues1.value19 = _G
            v3786 = function()
                local v937 = function()
                    local v538, v540, v542, v543, v544, v545, v546, v547, v548, v549, v550, v551, v553, v554
                    local v536 = game.Players.LocalPlayer
                    local v541 = v536.Character
                    local up26 = v541
                    if (not up26) then
                        return
                    else
                        local up27 = {}
                        v538 = (up26:FindFirstChildOfClass("Humanoid"))
                        v540 = v538
                        if v538 then
                            v540 = (not (up26:FindFirstChild("GodHumanoid")))
                        end
                        if v540 then
                            local up28 = (v538:Clone())
                            v541 = up28
                            v541.Name = "Humanoid"
                            v542 = (Instance.new("BoolValue"))
                            v542.Name = "GodHumanoid"
                            v542.Parent = up26
                            v541 = up28
                            v541.Parent = up26
                            v541 = up28
                            v541.MaxHealth = 9999
                            v541 = up28
                            v541.Health = 9999
                            v541 = up28
                            v541.UseJumpPower = true
                            v541 = up28
                            v541.JumpPower = 50
                            v541 = up28
                            v543 = Enum.HumanoidHealthDisplayType.AlwaysOff
                            v541.HealthDisplayType = v543
                            v541 = up28
                            v543 = Enum.HumanoidDisplayDistanceType.None
                            v541.DisplayDistanceType = v543
                            v538:Destroy()
                            v541 = workspace.CurrentCamera
                            v541.CameraSubject = up28
                            v543 = (v536:FindFirstChildOfClass("Backpack"))
                            if v543 then
                                v547 = (up26:FindFirstChildOfClass("Tool"))
                                v544 = {}
                                v541 = pairs
                                v548 = up26
                                v550 = v548.GetChildren
                                for v546, v550 in v541(v550(v548)) do
                                    v541 = v550:IsA("Tool")
                                    if v541 then
                                        table.insert(v544, v550)
                                    end
                                end
                                v545, v546, v548 = pairs(v543:GetChildren())
                                while true do
                                    v548, v550 = v545(v546, v548)
                                    if not v548 then
                                        break
                                    end
                                    v541 = v550:IsA("Tool")
                                    if v541 then
                                        table.insert(v544, v550)
                                    end
                                end
                                for v548, v550 in pairs(v544) do
                                    v550.Parent = v543
                                end
                                task.wait(.3)
                                v545 = v547 and (v547.Parent == v543)
                                if v545 then
                                    up28:EquipTool(v547)
                                end
                            end
                            v547 = up26:FindFirstChild("Animate")
                            if v547 then
                                v547.Disabled = true
                                task.wait (.1)
                                v547.Disabled = false
                            end
                            v541 = pairs
                            v548 = up26
                            v550 = v548.GetChildren
                            for v546, v549 in v541(v550(v548)) do
                                local up29 = v549
                                v550 = up29:IsA("LocalScript")
                                if v550 then
                                    v550 = up29.Name:lower()
                                    v551 = (v550 == "die")
                                    v554 = v551
                                    if not (v551) then
                                        v553 = (v550 == "died")
                                        v551 = v553
                                        if not (v553) then
                                            v551 = (v550 == "clientkilled") or (v550 == "killscript")
                                        end
                                        v554 = v551
                                    end
                                    if v554 then
                                        v541 = up29
                                        v541.Disabled = true
                                        task.delay(.1, function()
                                            pcall(function()
                                                up29:Destroy()
                                                return
                                            end)

                                            return
                                        end)
                                    end
                                end
                                v549 = nil
                            end
                            v541 = function()
                                local v2263
                                local v2255 = (not up26)
                                local v2256 = v2255
                                if not (v2255) then
                                    v2263 = (not up26.Parent)
                                    v2255 = v2263
                                    if not (v2263) then
                                        v2255 = (not _G.GodMode)
                                    end
                                    v2256 = v2255
                                end
                                if v2256 then
                                    return
                                else
                                    v2255 = function()
                                        local v1994
                                        local v1990 = up28
                                        if (v1990["Health"] < 9999) then
                                            v1994 = up28
                                            v1994.Health = 9999
                                        end
                                        up28.MaxHealth = 9999
                                        v1994 = up28
                                        v1990 = Enum.HumanoidStateType.Dead
                                        v1994:SetStateEnabled(v1990, false)
                                        v1990 = up28:GetState()
                                        local v1995 = Enum.HumanoidStateType
                                        if (v1990 == v1995["Dead"]) then
                                            v1994 = up28
                                            v1995 = Enum.HumanoidStateType
                                            v1994:ChangeState(v1995.Running)
                                        end
                                        return
                                    end
                                    pcall(v2255)                                    return
                                end
                            end
                            v541 = up28.HealthChanged
                            v546 = function(arg185_1)
                                local v2274
                                local v2265 = _G
                                local v2268 = arg185_1
                                local v2272 = (not v2265.GodMode)
                                local v2273 = v2272
                                if not (v2272) then
                                    v2273 = (not up28.Parent)
                                end
                                if v2273 then
                                    return
                                else
                                    if (v2268 < 9999) then
                                        v2274 = up28
                                        v2274.Health = 9999
                                    end
                                    return
                                end
                            end
                            v545 = v541:Connect(v546)
                            table.insert(up27, v545)
                            v546 = up28.Died:Connect(function()
                                local v2281 = (not _G.GodMode)
                                local v2282 = v2281
                                if not (v2281) then
                                    v2282 = (not up28.Parent)
                                end
                                if v2282 then
                                    return
                                else
                                    task.wait(.05)
                                    pcall(function()
                                        up28.Health = 9999
                                        up28:ChangeState(Enum.HumanoidStateType.Running)
                                        return
                                    end)
                                    return
                                end
                            end)
                            table.insert(up27, v546)
                            v541 = function()
                                local v2293
                                local v2285 = (not up26)
                                local v2286 = v2285
                                if not (v2285) then
                                    v2293 = (not up26.Parent)
                                    v2285 = v2293
                                    if not (v2293) then
                                        v2285 = (not _G.GodMode)
                                    end
                                    v2286 = v2285
                                end
                                if v2286 then
                                    return
                                else
                                    v2285 = function()
                                        local v316
                                        local v312 = up28
                                        if (v312["Health"] < 9999) then
                                            v316 = up28
                                            v316.Health = 9999
                                        end
                                        up28.MaxHealth = 9999
                                        v316 = up28
                                        v312 = Enum.HumanoidStateType.Dead
                                        v316:SetStateEnabled(v312, false)
                                        v316 = up28
                                        v316:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                                        up28:SetStateEnabled(Enum.HumanoidStateType.Freefall , true)
                                        v312 = up28:GetState()
                                        local v317 = Enum.HumanoidStateType
                                        if (v312 == v317["Dead"]) then
                                            v316 = up28
                                            v317 = Enum.HumanoidStateType
                                            v316:ChangeState(v317.Running)
                                        end
                                        return
                                    end
                                    pcall(v2285)                                    return
                                end
                            end
                            local up30 = v541
                            v549 = game:GetService("RunService")
                            table.insert(up27, v549.Heartbeat:Connect(up30))
                            task.spawn(function()
                                local v2299, v2300, v2301
                                while true do
                                    v2300 = _G.GodMode
                                    v2301 = v2300
                                    if v2300 then
                                        v2299 = up26
                                        v2300 = v2299
                                        if v2299 then
                                            v2300 = up26.Parent
                                        end
                                        v2301 = v2300
                                    end
                                    if v2301 then
                                        up30()
                                        task.wait(0.5)
                                    else
                                        break
                                    end
                                end
                                return
                            end)
                            task.spawn(function()
                                local v2309, v2310, v2311, v2314
                                while true do
                                    v2310 = _G.GodMode
                                    v2311 = v2310
                                    if v2310 then
                                        v2309 = up26
                                        v2310 = v2309
                                        if v2309 then
                                            v2310 = up26.Parent
                                        end
                                        v2311 = v2310
                                    end
                                    if v2311 then
                                        up30()
                                        v2310 = workspace.CurrentCamera
                                        if (v2310.CameraSubject ~= up28) then
                                            v2314 = workspace.CurrentCamera
                                            v2310 = up28
                                            v2314.CameraSubject = v2310
                                        end
                                        task.wait(.1)
                                    else
                                        break
                                    end
                                end
                                for v2305, v2307 in pairs(up27) do
                                    v2307:Disconnect()
                                end
                                return
                            end)
                        end
                        return
                    end
                end
                pcall(v937)

                return
            end
            spilledValues1.value19.ApplyGod = v3786
            spilledValues1.value19 = game.Players.LocalPlayer.CharacterAdded
            v3786 = function()
                local v939 = _G
                if v939["GodMode"] then
                    task.wait(0.5)
                    _G.ApplyGod()
                end
                return
            end
            spilledValues1.value19:Connect(v3786)
            spilledValues1.value19 = _G
            v3786 = v3771.Me
            v3790 = v3786.AddToggle
            v3795 = function(arg62_1)
                local v947, v950
                local v945 = _G.GodMode
                _G.GodMode = arg62_1
                _G.KeybindNotify("God Mode", arg62_1)
                if arg62_1 then
                    _G.ApplyGod()
                else
                    if v945 then
                        v947 = function()
                            local v3635, v3636, v3638, v3641
                            local v3639 = game.Players.LocalPlayer.Character
                            local v3640 = v3639 and (v3639:FindFirstChildOfClass("Humanoid"))
                            local up152 = v3640
                            if up152 then
                                v3638 = (v3639:FindFirstChild("GodHumanoid"))
                                if v3638 then
                                    v3638:Destroy()
                                end
                                v3641 = up152
                                v3635 = Enum.HumanoidStateType.Dead
                                v3641:SetStateEnabled(v3635, true)
                                v3640 = task
                                v3636 = function()
                                    local v347 = function()
                                        local v2245
                                        local v2241 = _G
                                        if (not v2241["GodMode"]) then
                                            v2245 = up152
                                            v2245.Health = 0
                                        end
                                        return
                                    end
                                    pcall(v347)

                                    return
                                end
                                v3640.delay(.1, v3636)
                            end
                            return
                        end
                        pcall(v947)
                        v950 = up179
                        v947 = {["Title"] = "God Mode", ["Content"] = "God Mode kapatıldı, karakter resetleniyor...", ["Duration"] = 3}
                        v950:Notify(v947)
                    end
                end
                return
            end
            v3790 = v3790(v3786, "GodMode", {["Title"] = "God Mode", ["Default"] = false, ["Callback"] = v3795})
            spilledValues1.value19.GodModeToggleObj = v3790
            task.spawn(function()
                local v957 = game:GetService("RunService")
                local up37
                v957 = v957.Stepped:Connect(function()
                    local v381
                    local v376 = _G
                    if v376.ScriptUnloaded then
                        up37:Disconnect()
                        return
                    else
                        v381 = function()
                            local v2222, v2224, v2225, v2226, v2227, v2228, v2230, v2231, v2232, v2233, v2234, v2238
                            local v2221 = _G
                            if v2221.Flinging then
                                return
                            else
                                v2225 = game.Players.LocalPlayer
                                v2222 = v2225.Character
                                v2221 = v2222
                                if v2222 then
                                    v2221 = (v2222:FindFirstChild("HumanoidRootPart"))
                                end
                                local up97 = v2221
                                if up97 then
                                    v2224 = (up97.AssemblyLinearVelocity.Magnitude > 75)
                                    v2221 = v2224
                                    if not (v2224) then
                                        v2221 = (up97.AssemblyAngularVelocity.Magnitude > 75)
                                    end
                                    if v2221 then
                                        v2227 = up97
                                        v2226 = Vector3.new(0, 0, 0)
                                        v2227.AssemblyLinearVelocity = v2226
                                        v2227 = up97
                                        v2226 = Vector3.new (0, 0, 0)
                                        v2227.AssemblyAngularVelocity = v2226
                                        pcall(function()
                                            up97.Velocity = Vector3.new(0, 0, 0)
                                            up97.RotVelocity = Vector3.new(0, 0, 0)

                                            return
                                        end)
                                    end
                                    v2227 = pairs
                                    v2228 = game.Players
                                    v2233 = v2228.GetPlayers
                                    for v2226, v2233 in v2227(v2233(v2228)) do
                                        v2231 = (v2233 ~= v2225)
                                        v2230 = v2231
                                        if v2231 then
                                            v2238 = v2233.Character
                                            v2231 = v2238
                                            if v2238 then
                                                v2231 = (v2233.Character:FindFirstChild("HumanoidRootPart"))
                                            end
                                            v2230 = v2231
                                        end
                                        if v2230 then
                                            v2227 = v2233.Character.HumanoidRootPart
                                            v2232 = (up97.Position - v2227.Position)
                                            if (v2232.Magnitude < 25) then
                                                v2227 = pairs
                                                for v2238, v2234 in v2227(v2233.Character:GetChildren()) do
                                                    v2227 = v2234:IsA("BasePart")
                                                    if v2227 then
                                                        v2234.CanCollide = false
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                return
                            end
                        end
                        pcall(v381)
                        return
                    end
                end)
                up37 = v957
                return
            end)
            spilledValues1.value19 = _G
            spilledValues1.value19.XrayActive = false
            spilledValues1.value19 = v3771.Me
            v3794 = function(arg64_1)
                local up38
                local v965 = function()
                    local v868
                    local v863 = _G
                    if (v863["XrayActive"] == up38) then
                        return
                    else
                        v868 = _G
                        v868.XrayActive = up38
                        _G.KeybindNotify("Xray", up38)
                        if up38 then
                            StartXray()
                        else
                            RestoreXray()
                        end
                        return
                    end
                end
                up38 = arg64_1
                pcall(v965)

                return
            end
            local up202 = (spilledValues1.value19:AddToggle("Xray", {["Title"] = "Xray", ["Default"] = false, ["Callback"] = v3794}))
            spilledValues1.value19 = _G
            spilledValues1.value19.NoclipActive = false
            local up204
            spilledValues1.value19 = v3771.Me
            v3788 = spilledValues1.value19.AddToggle
            v3803 = function(arg65_1)
                local up39
                local v967 = function()
                    local v1916, v1918, v1920, v1921, v1922, v1926
                    local v1913 = _G
                    if (v1913["NoclipActive"] == up39) then
                        return
                    else
                        v1918 = _G
                        v1918.NoclipActive = up39
                        _G.KeybindNotify("Noclip", up39)
                        if up39 then
                            if up204 then
                                up204:Disconnect()
                            end
                            v1918 = game:GetService("RunService").Stepped
                            v1913 = function()
                                local v502, v504, v505, v506
                                local v500 = _G
                                if (not v500["NoclipActive"]) then
                                    v504 = up204
                                    v504:Disconnect()
                                    up204 = v504
                                    return
                                else
                                    v500 = game.Players.LocalPlayer.Character
                                    if v500 then
                                        v505 = pairs
                                        v506 = v500.GetDescendants
                                        for v502, v506 in v505(v506(v500)) do
                                            v505 = (v506:IsA("BasePart")) and v506.CanCollide
                                            if v505 then
                                                v506.CanCollide = false
                                            end
                                        end
                                    end
                                    return
                                end
                            end
                            up204 = (v1918:Connect(v1913))
                        else
                            if up204 then
                                up204:Disconnect()
                            end
                            v1913 = game.Players.LocalPlayer.Character
                            if v1913 then
                                v1921 = v1913.GetDescendants
                                for v1916, v1920 in pairs(v1921(v1913)) do
                                    local up88 = v1920
                                    v1922 = up88:IsA("BasePart")
                                    if v1922 then
                                        v1926 = function()
                                            up88.CanCollide = true
                                            return
                                        end
                                        pcall(v1926)
                                    end
                                    v1920 = nil
                                end
                            end
                        end
                        return
                    end
                end
                up39 = arg65_1
                pcall(v967)

                return
            end
            v3788 = v3788(spilledValues1.value19, "Noclip", {["Title"] = "Noclip", ["Default"] = false, ["Callback"] = v3803})
            local up203 = v3788
            v3771.Me:AddSection("Flight Controls")
            spilledValues1.value19 = v3771.Me
            v3792 = spilledValues1.value19.AddToggle
            spilledValues1.value22 = function(arg66_1)
                local up40 = arg66_1
                local v971 = function()
                    local v2020, v2021, v2022, v2023, v2024
                    local v2018 = _G
                    if (v2018["FlyActive"] == up40) then
                        return
                    else
                        v2023 = _G
                        v2023.FlyActive = up40
                        _G.KeybindNotify("Fly", up40)
                        v2024 = game.Players.LocalPlayer.Character
                        v2022 = v2024
                        if v2024 then
                            v2022 = (v2024:FindFirstChild("Humanoid"))
                        end
                        if v2022 then
                            if (not up40) then
                                v2023 = v2024:FindFirstChild("HumanoidRootPart")
                                local up90 = v2023
                                if up90 then
                                    v2020 = function()
                                        local v3397 = up90:FindFirstChild("MM2_Bypass_V")
                                        if v3397 then
                                            up90.MM2_Bypass_V:Destroy()
                                        end
                                        return
                                    end
                                    pcall(v2020)
                                    v2020 = function()
                                        local v3403 = up90:FindFirstChild("MM2_Bypass_G")
                                        if v3403 then
                                            up90.MM2_Bypass_G:Destroy()
                                        end
                                        return
                                    end
                                    pcall(v2020)
                                end
                                v2023 = v2024.Humanoid
                                v2023.PlatformStand = false
                                v2023 = v2024.Humanoid
                                v2021 = Enum.HumanoidStateType
                                v2023:ChangeState(v2021.Running)
                                v2023 = v2024.Humanoid
                                v2020 = Enum.HumanoidStateType.Jumping
                                v2023:SetStateEnabled(v2020, true)
                            end
                        end
                        return
                    end
                end
                pcall(v971)

                return
            end
            v3792 = v3792(spilledValues1.value19, "Fly", {["Title"] = "Fly", ["Default"] = false, ["Callback"] = spilledValues1.value22})
            local up205 = v3792
            spilledValues1.value19 = _G
            spilledValues1.value19.FlySpeed = 30
            spilledValues1.value19 = v3771.Me
            v3793 = spilledValues1.value19.AddSlider
            v3801 = function(arg67_1)
                _G.FlySpeed = arg67_1
                return
            end
            v3793(spilledValues1.value19, "FlySpeed", {["Title"] = "Fly Speed", ["Default"] = 30, ["Min"] = 30, ["Max"] = 300, ["Rounding"] = 0, ["Callback"] = v3801})
            v3793 = function(arg68_1)
                local v987, v989, v991, v993, v995, v996
                local v978 = arg68_1
                local v985 = game:GetService("Players").LocalPlayer.Character
                local up41 = v985
                local v980 = up41
                local v979 = v980
                if v980 then
                    v979 = (up41:FindFirstChildOfClass("Humanoid"))
                end
                local up42 = v979
                local v981 = up42
                v979 = v981
                if v981 then
                    v979 = up42.RootPart
                end
                local up43 = v979
                local v986 = up41
                v979 = v986
                if v986 then
                    v979 = up42 and up43
                end
                if (not v979) then
                    return
                else
                    v985 = v978.Character
                    local up44 = v985
                    v986 = up44
                    v979 = v986
                    if v986 then
                        v979 = (up44:FindFirstChildOfClass("Humanoid"))
                    end
                    local up45 = v979
                    v987 = up45
                    v979 = v987
                    if v987 then
                        v979 = up45.RootPart
                    end
                    local up46 = v979
                    v989 = up44
                    v979 = v989
                    if v989 then
                        v979 = up45 and up46
                    end
                    if (not v979) then
                        return
                    else
                        v985 = _G
                        v985.Flinging = true
                        v985 = up43.CFrame
                        local up47 = v985
                        v979 = up43
                        v985 = v979.AssemblyLinearVelocity
                        local up49 = v985
                        local up48 = (tick())
                        v985 = up42
                        v985.PlatformStand = true
                        v985 = up42.StateChanged
                        v991 = function(arg178_1, arg178_2)
                            local v2200
                            local v2199 = Enum.HumanoidStateType
                            if (arg178_2 == v2199["Dead"]) then
                                v2200 = up42
                                v2199 = Enum.HumanoidStateType.Physics
                                v2200:ChangeState(v2199)
                            end
                            return
                        end
                        v979 = v985:Connect(v991)
                        local up50 = v979
                        v979 = Instance.new("BodyVelocity")
                        local up51 = v979
                        v985 = up51
                        v993 = Vector3.new(math.huge, math.huge, math.huge)
                        v985.MaxForce = v993
                        v985 = up51
                        v993 = Vector3.new(95000, 95000, 95000)
                        v985.Velocity = v993
                        v985 = up51
                        v985.Parent = up43
                        v979 = Instance.new("BodyAngularVelocity")
                        local up52 = v979
                        v985 = up52
                        v995 = Vector3.new(math.huge, math.huge, math.huge)
                        v985.MaxTorque = v995
                        v985 = up52
                        v995 = Vector3.new(95000, 95000, 95000)
                        v985.AngularVelocity = v995
                        v985 = up52
                        v993 = up43
                        v985.Parent = v993
                        local up53
                        v985 = game:GetService("RunService").Heartbeat
                        v979 = v985.Connect
                        v995 = function()
                            local v2203, v2204, v2205, v2208, v2213, v2214, v2217
                            local v2206 = (((tick()) - up48) > 1.8)
                            local v2207 = v2206
                            if not (v2206) then
                                v2203 = (not up44)
                                v2206 = v2203
                                if not (v2203) then
                                    v2214 = (not up44.Parent)
                                    v2203 = v2214
                                    if not (v2214) then
                                        v2208 = (up45.Health <= 0)
                                        v2214 = v2208
                                        if not (v2208) then
                                            v2214 = (up42.Health <= 0)
                                        end
                                        v2203 = v2214
                                    end
                                    v2206 = v2203
                                end
                                v2207 = v2206
                            end
                            if v2207 then
                                up53:Disconnect()
                                return
                            else
                                v2206 = function()
                                    local v515 = ipairs
                                    local v516 = up44
                                    local v517 = v516.GetDescendants
                                    for v519, v517 in v515(v517(v516)) do
                                        v515 = v517:IsA("BasePart")
                                        if v515 then
                                            v517.CanCollide = true
                                        end
                                    end
                                    return
                                end
                                pcall(v2206)
                                pcall(function()
                                    local v533
                                    local v525 = ipairs
                                    local v526 = up41
                                    local v527 = v526.GetDescendants
                                    for v529, v527 in v525(v527(v526)) do
                                        v525 = v527:IsA("BasePart")
                                        if v525 then
                                            v533 = v527.Name
                                            if (v533 == "HumanoidRootPart") then
                                                v527.CanCollide = true
                                            else
                                                v527.CanCollide = false
                                            end
                                        end
                                    end
                                    return
                                end)
                                v2206 = (Vector3.new(95000, 95000, 95000))
                                v2203 = tick()
                                if ((v2203 % .2) < .1) then
                                    v2206 = (Vector3.new(-95000, -95000, -95000))
                                end
                                v2217 = up51
                                v2217.Velocity = v2206
                                v2217 = up43
                                v2217.AssemblyLinearVelocity = v2206
                                v2217 = up43
                                v2217.Velocity = v2206
                                v2217 = up43
                                v2204 = Vector3.new(95000, 95000, 95000)
                                v2217.AssemblyAngularVelocity = v2204
                                v2217 = up43
                                v2204 = Vector3.new(95000, 95000, 95000)
                                v2217.RotVelocity = v2204
                                v2205 = (((tick()) * 120) % (math.pi * 2))
                                v2203 = (.8 + ((math.sin(((tick()) * 40))) * .8))
                                v2204 = Vector3.new(((math.cos(v2205)) * v2203), .2, ((math.sin(v2205)) * v2203))
                                v2217 = up43
                                v2213 = (up46.CFrame * (CFrame.new(v2204)))
                                v2217.CFrame = v2213
                                return
                            end
                        end
                        v979 = v979(v985, v995)
                        up53 = v979
                        v985 = (not up53.Connected)
                        while true do
                            task.wait()
                            v996 = up53
                            if (not v996["Connected"]) then
                                break
                            end
                        end
                        pcall(function()
                            up50:Disconnect()
                            return
                        end)
                        pcall(function()
                            up51:Destroy()
                            up52:Destroy()
                            up42.PlatformStand = false
                            up43.AssemblyLinearVelocity = up49
                            local v334 = up43
                            local v337 = Vector3.new(0, 0, 0)
                            v334.AssemblyAngularVelocity = v337
                            local v336 = function()
                                up43.Velocity = up49
                                up43.RotVelocity = Vector3.new(0, 0, 0)

                                return
                            end
                            pcall(v336)
                            up43.CFrame = up47
                            v334 = pairs
                            local v338 = up41
                            local v340 = v338.GetDescendants
                            for v337, v340 in v334(v340(v338)) do
                                v334 = v340:IsA("BasePart")
                                if v334 then
                                    v340.CanCollide = true
                                end
                            end
                            _G.Flinging = false
                            return
                        end)

                        return
                    end
                end
            end
            local up206 = v3793
            v3771.Me:AddSection("Fling")
            v3793 = v3771.Me
            spilledValues1.value21 = function()
                pcall(function()
                    local v2822, v2825, v2826
                    for v2821, v2819 in pairs(up180:GetPlayers()) do
                        local up126 = v2819
                        v2822 = function()
                            return up186(up126)
                        end
                        v2826 = (pcall(v2822)) and (up186(up126)) or ""
                        v2825 = (up126 ~= up180.LocalPlayer) and (v2826 == "Murderer")
                        if v2825 then
                            task.spawn(function()
                                pcall(up206, up126)
                                return
                            end)
                        else
                            continue
                        end
                        break
                    end
                    return
                end)

                return
            end
            v3793:AddButton({["Title"] = "Fling Murderer", ["Callback"] = spilledValues1.value21})
            v3793 = v3771.Me
            spilledValues1.value21 = function()
                pcall(function()
                    local v3532, v3535, v3536, v3537
                    for v3531, v3529 in pairs(up180:GetPlayers()) do
                        local up151 = v3529
                        v3532 = function()
                            return up186(up151)
                        end
                        v3536 = (pcall(v3532)) and (up186(up151)) or ""
                        v3537 = (up151 ~= up180.LocalPlayer)
                        v3535 = v3537
                        if v3537 then
                            v3535 = (v3536 == "Sheriff") or (v3536 == "Hero")
                        end
                        if v3535 then
                            task.spawn(function()
                                pcall(up206, up151)
                                return
                            end)
                        else
                            continue
                        end
                        break
                    end
                    return
                end)

                return
            end
            v3793:AddButton({["Title"] = "Fling Sheriff", ["Callback"] = spilledValues1.value21})
            v3793 = v3771.Me
            v3794 = v3793.AddButton
            spilledValues1.value21 = function()
                pcall(function()
                    local v3517, v3518
                    local v3511 = up180.LocalPlayer
                    local v3508 = v3511.Character
                    local v3507 = v3508
                    if v3508 then
                        v3507 = (v3511.Character:FindFirstChild("HumanoidRootPart"))
                    end
                    local v3509 = math
                    v3508 = v3507
                    v3507 = v3509.huge
                    local v3510 = v3507
                    local up150
                    for v3514, v3516 in pairs(up180:GetPlayers()) do
                        v3518 = (v3516 ~= v3511) and v3516.Character
                        if v3518 then
                            v3518 = v3516.Character:FindFirstChild("HumanoidRootPart")
                            v3517 = (v3518 and v3508)
                            if v3517 then
                                v3517 = (v3518.Position - v3508.Position).Magnitude
                                if (v3517 < v3510) then
                                    v3510 = v3517
                                    up150 = v3516
                                end
                            end
                        end
                    end
                    if up150 then
                        task.spawn(function()
                            pcall(up206, up150)
                            return
                        end)
                    end
                    return
                end)

                return
            end
            v3794(v3793, {["Title"] = "Fling Nearest", ["Callback"] = spilledValues1.value21})
            v3794 = v3771.Me:AddSection("Keybinds")
            v3795 = function(arg72_1, arg72_2)
                local v1022
                local v1013 = arg72_2
                local v1014 = arg72_1
                local v1017 = _G.FlyKeybindObj
                local v1015 = v1017
                if v1017 then
                    v1015 = _G.FlyKeybindObj.Value
                end
                local v1020 = _G
                local v1023 = v1020.NoclipKeybindObj
                v1017 = v1023
                if v1023 then
                    v1017 = _G.NoclipKeybindObj.Value
                end
                local v1021 = _G.XrayKeybindObj
                v1023 = v1021
                if v1021 then
                    v1023 = _G.XrayKeybindObj.Value
                end
                v1015 = {["Fly"] = v1015, ["Noclip"] = v1017, ["Xray"] = v1023}
                local v1025 = pairs
                for v1017, v1020 in v1025(v1015) do
                    v1022 = (v1017 ~= v1013)
                    v1021 = v1022
                    if v1022 then
                        v1021 = (v1020 == v1014) and (v1014 ~= "None")
                    end
                    if v1021 then
                        v1025 = true
                        return v1025
                    end
                end
                return false
            end
            local up207 = v3795
            v3795 = _G
            v3803 = v3794.AddKeybind
            v3801 = function(arg73_1)
                local up54
                local v1031 = function()
                    local v567 = _G
                    if (v567["FlyActive"] == up54) then
                        return
                    else
                        up205:SetValue(up54)
                        return
                    end
                end
                up54 = arg73_1
                pcall(v1031)

                return
            end
            v3803 = v3803(v3794, "FlyKey", {["Title"] = "Fly Keybind", ["Mode"] = "Toggle", ["Default"] = "Q", ["Callback"] = v3801})
            v3795.FlyKeybindObj = v3803
            v3795 = _G
            v3803 = v3794.AddKeybind
            v3801 = function(arg74_1)
                local up55 = arg74_1
                local v1035 = function()
                    local v1868
                    local v1864 = _G
                    if (v1864["NoclipActive"] == up55) then
                        return
                    else
                        v1868 = up203
                        v1864 = up55
                        v1868:SetValue(v1864)
                        return
                    end
                end
                pcall(v1035)

                return
            end
            v3803 = v3803(v3794, "NoclipKey", {["Title"] = "Noclip Keybind", ["Mode"] = "Toggle", ["Default"] = "E", ["Callback"] = v3801})
            v3795.NoclipKeybindObj = v3803
            v3795 = _G
            v3803 = v3794.AddKeybind
            v3801 = function(arg75_1)
                local up56
                local v1040 = function()
                    local v3430
                    local v3426 = _G
                    if (v3426["XrayActive"] == up56) then
                        return
                    else
                        v3430 = up202
                        v3426 = up56
                        v3430:SetValue(v3426)
                        return
                    end
                end
                up56 = arg75_1
                pcall(v1040)

                return
            end
            v3803 = v3803(v3794, "XrayKey", {["Title"] = "Xray Keybind", ["Mode"] = "Toggle", ["Default"] = "R", ["Callback"] = v3801})
            v3795.XrayKeybindObj = v3803
            v3795 = _G.FlyKeybindObj
            v3803 = function()
                up207(_G.FlyKeybindObj.Value, "Fly")

                return
            end
            v3795:OnChanged(v3803)
            v3795 = _G.NoclipKeybindObj
            v3803 = function()
                up207(_G.NoclipKeybindObj.Value, "Noclip")

                return
            end
            v3795:OnChanged(v3803)
            _G.XrayKeybindObj:OnChanged(function()
                up207(_G.XrayKeybindObj.Value, "Xray")

                return
            end)
            v3802 = v3771.Player:AddSection("ESP & Visuals")
            v3795 = _G
            v3795.NamesESP = false
            v3795 = v3802.AddToggle
            spilledValues1.value23 = function(arg79_1)
                _G.NamesESP = arg79_1
                return
            end
            v3795(v3802, "NamesToggle", {["Title"] = "Players Names", ["Default"] = false, ["Callback"] = spilledValues1.value23})
            v3795 = v3802.AddToggle
            spilledValues1.value23 = function(arg80_1)
                local v1077, v1078, v1079, v1081, v1082, v1084
                local v1076 = _G
                v1076.PlayerChamsActive = arg80_1
                if (not arg80_1) then
                    v1076 = pairs
                    v1079 = game.Players
                    v1084 = v1079.GetPlayers
                    for v1078, v1084 in v1076(v1084(v1079)) do
                        v1082 = v1084.Character
                        v1081 = v1082
                        if v1082 then
                            v1081 = (v1084.Character:FindFirstChild("PlayerChams"))
                        end
                        if v1081 then
                            v1084.Character.PlayerChams:Destroy()
                        end
                    end
                    v1078 = _G.CachedGunDrop
                    v1077 = v1078
                    if v1078 then
                        v1077 = (_G.CachedGunDrop:FindFirstChild("GunChams"))
                    end
                    if v1077 then
                        _G.CachedGunDrop.GunChams:Destroy()
                    end
                end
                return
            end
            v3795(v3802, "PlayerChamsActive", {["Title"] = "Players Chams", ["Default"] = false, ["Callback"] = spilledValues1.value23})
            v3795 = v3802.AddDropdown
            v3800 = {"Bloom", "Textured"}
            spilledValues1.value25 = function(arg81_1)
                local v1089 = arg81_1
                local v1091 = _G
                v1091.ChamsMode = v1089
                if (v1089 == "Bloom") then
                    v1091 = _G
                    v1091.ChamsFillTransparency = 0.5
                else
                    if (v1089 == "Textured") then
                        v1091 = _G
                        v1091.ChamsFillTransparency = .8
                    end
                end
                return
            end
            v3795(v3802, "ChamsMode", {["Title"] = "Chams Mode", ["Values"] = v3800, ["Default"] = "Textured", ["Callback"] = spilledValues1.value25})
            v3795 = _G
            v3795.BoxESP = false
            v3795 = _G
            v3795.BoxStyle = "Corners"
            v3795 = v3802.AddToggle
            spilledValues1.value23 = function(arg82_1)
                _G.BoxESP = arg82_1
                return
            end
            v3795(v3802, "Box", {["Title"] = "Players Box", ["Default"] = false, ["Callback"] = spilledValues1.value23})
            v3800 = {"Default", "Corners"}
            v3795 = v3802.AddDropdown
            spilledValues1.value25 = function(arg83_1)
                _G.BoxStyle = arg83_1
                return
            end
            v3795(v3802, "BoxStyle", {["Title"] = "Box Mode", ["Values"] = v3800, ["Default"] = "Corners", ["Callback"] = spilledValues1.value25})
            task.spawn(function()
                local v1106
                while true do
                    task.wait(1)
                    v1106 = _G
                    if v1106.ScriptUnloaded then
                        break
                    else
                        pcall(up192)
                    end
                end
                return
            end)
            v3803 = v3771.Murder:AddSection("Elimination")
            v3800 = function()
                _G.ExecuteKillAll()
                return
            end
            v3803:AddButton({["Title"] = "Kill All", ["Callback"] = v3800})
            local up208 = function(arg86_1, arg86_2, arg86_3)
                local v1122, v1124, v1126
                local v1117 = arg86_1
                local v1118 = v1117
                local up58 = arg86_2
                local up57 = arg86_3
                if v1117 then
                    v1118 = v1117.Character and up58
                end
                if (not v1118) then
                    return
                else
                    v1118 = up58:FindFirstChild("Handle")
                    local up59 = v1118
                    v1118 = up59 and firetouchinterest
                    if (not v1118) then
                        return
                    else
                        v1126 = v1117.Character:FindFirstChild("Torso")
                        v1118 = v1126
                        if not (v1126) then
                            v1122 = v1117.Character:FindFirstChild("UpperTorso")
                            v1124 = v1122
                            if not (v1122) then
                                v1124 = (v1117.Character:FindFirstChild("HumanoidRootPart"))
                            end
                            v1118 = v1124
                        end
                        local up60 = v1118
                        v1126 = (v1117.Character:FindFirstChild("Humanoid"))
                        v1122 = up60
                        v1118 = v1122
                        if v1122 then
                            v1118 = v1126 and (v1126.Health > 0)
                        end
                        if (not v1118) then
                            return
                        else
                            pcall(function()
                                local v3452, v3457
                                local v3455 = game.Players.LocalPlayer.Character
                                local v3450 = v3455:FindFirstChild("Right Arm")
                                local v3456 = v3450
                                if not (v3450) then
                                    v3456 = (v3455:FindFirstChild("RightHand"))
                                end
                                v3450 = v3456
                                v3456 = v3450
                                if v3450 then
                                    v3456 = (v3450:FindFirstChild("RightGrip"))
                                end
                                local v3454 = v3456
                                local v3451 = up59.CFrame
                                up58:Activate()
                                if v3454 then
                                    v3454.Parent = nil
                                end
                                if up57 then
                                    v3457 = up59
                                    v3452 = up60.CFrame
                                    v3457.CFrame = v3452
                                else
                                    v3457 = up59
                                    v3452 = up60.CFrame
                                    v3457.CFrame = v3452
                                end
                                firetouchinterest(up59, up60, 0)
                                firetouchinterest(up59, up60, 1)
                                up59.CFrame = v3451
                                if v3454 then
                                    v3454.Parent = v3450
                                end
                                return
                            end)
                            return
                        end
                    end
                end
            end
            v3797 = _G
            spilledValues1.value22 = function()
                local v1135, v1136, v1137, v1138, v1141, v1142, v1144, v1145, v1146
                local v1139 = game.Players.LocalPlayer
                local v1134 = v1139
                local up61 = (up189(v1134))
                if (not up61) then
                    up179:Notify({["Title"] = "Kill All", ["Content"] = "Envanterde bıçak bulunamadı!", ["Duration"] = 3})

                    return
                else
                    v1135 = v1134.Character
                    v1138 = v1135
                    if v1135 then
                        v1138 = (v1135:FindFirstChildOfClass("Humanoid"))
                    end
                    v1136 = v1138
                    v1138 = v1135
                    if v1135 then
                        v1138 = v1136 and (v1136.Health > 0)
                    end
                    if (not v1138) then
                        return
                    else
                        v1137 = up61
                        if (v1137["Parent"] ~= v1135) then
                            v1136:EquipTool(up61)
                            task.wait(.15)
                        end
                        local up62 = 0
                        v1139 = ipairs
                        v1142 = game.Players
                        v1144 = v1142.GetPlayers
                        for v1141, v1144 in v1139(v1144(v1142)) do
                            local up63 = v1144
                            v1146 = (up63 ~= v1134)
                            v1145 = v1146
                            if v1146 then
                                v1145 = up63.Character
                            end
                            if v1145 then
                                v1145 = up63.Character:FindFirstChildOfClass("Humanoid")
                                v1146 = v1145 and (v1145.Health > 0)
                                if v1146 then
                                    pcall(function()
                                        up208(up63, up61, true)
                                        up62 = (up62 + 1)

                                        return
                                    end)
                                    task.wait(.02)
                                end
                            end
                            v1144 = nil
                        end
                        v1139 = up179
                        v1145 = (up62 .. " oyuncu yok edildi!")
                        v1141 = {["Title"] = "Kill All", ["Content"] = v1145, ["Duration"] = 3}
                        v1139:Notify(v1141)

                        return
                    end
                end
            end
            v3797.ExecuteKillAll = spilledValues1.value22
            v3797 = _G
            v3797.KillAura = false
            v3797 = _G
            v3797.KillAuraRange = 15
            v3797 = v3803.AddToggle
            spilledValues1.value25 = function(arg88_1)
                local v1156
                local v1154 = _G
                v1154.KillAura = arg88_1
                _G.KeybindNotify("Kill Aura", arg88_1)
                if arg88_1 then
                    v1154 = _G
                    v1156 = tick()
                    v1154.KillAuraToggleTime = v1156
                end
                return
            end
            v3797 = v3797(v3803, "KillAura", {["Title"] = "Kill Aura", ["Default"] = false, ["Callback"] = spilledValues1.value25})
            local up209 = v3797
            v3797 = v3803.AddSlider
            spilledValues1.value31 = function(arg89_1)
                _G.KillAuraRange = arg89_1
                _G.KillAuraToggleTime = tick()
                return
            end
            v3797(v3803, "KillAuraRange", {["Title"] = "Aura Range", ["Default"] = 15, ["Min"] = 15, ["Max"] = 200, ["Rounding"] = 0, ["Callback"] = spilledValues1.value31})
            spilledValues1.value22 = v3771.Murder:AddSection("Silent Kill")
            v3797 = spilledValues1.value22.AddToggle
            spilledValues1.value26 = function(arg90_1)
                _G.SilentAimMurderer = arg90_1
                return
            end
            v3797(spilledValues1.value22, "SilentAimMurdererToggle", {["Title"] = "Knife Throw", ["Default"] = false, ["Callback"] = spilledValues1.value26})
            v3797 = spilledValues1.value22.AddToggle
            spilledValues1.value26 = function(arg91_1)
                _G.SilentAimMurdererVisible = arg91_1
                return
            end
            v3797(spilledValues1.value22, "SilentAimMurdererVisible", {["Title"] = "Visible Only", ["Default"] = true, ["Callback"] = spilledValues1.value26})
            task.spawn(function()
                local v1174, v1175, v1176, v1177, v1179
                while true do
                    task.wait(.1)
                    v1175 = _G
                    if v1175.ScriptUnloaded then
                        break
                    else
                        v1179 = game.Players.LocalPlayer
                        v1176 = (up186(v1179))
                        v1175 = _G.KillAura and (v1176 ~= "Murderer")
                        if v1175 then
                            v1177 = tick()
                            v1175 = _G.KillAuraToggleTime or (tick())
                            if ((v1177 - v1175) > 3) then
                                v1174 = _G
                                v1174.KillAura = false
                                pcall(function()
                                    if up209 then
                                        up209:SetValue(false)
                                    end
                                    return
                                end)
                            end
                        end
                    end
                end
                return
            end)
            v3797 = {"None"}
            local up210
            v3800 = function()
                local v1194
                table.clear(up210)
                table.insert(up210, "None")
                local v1191 = pairs
                local v1189 = game.Players
                local v1192 = v1189.GetPlayers
                for v1188, v1192 in v1191(v1192(v1189)) do
                    v1194 = game.Players
                    if (v1192 ~= v1194["LocalPlayer"]) then
                        table.insert(up210, v1192.Name)
                    end
                end
                table.sort(up210)

                return up210
            end
            up210 = v3797
            local up211 = v3800
            v3771.Murder:AddSection("Target Players")
            v3800 = _G
            v3800.MurderTarget = "None"
            v3800 = v3771.Murder
            v3798 = up211()
            spilledValues1.value23 = v3800.AddDropdown
            v3796 = function(arg94_1)
                _G.MurderTarget = arg94_1
                return
            end
            spilledValues1.value23 = spilledValues1.value23(v3800, "MurderTarget", {["Title"] = "Select Target", ["Values"] = v3798, ["Default"] = "None", ["Callback"] = v3796})
            local up212 = spilledValues1.value23
            spilledValues1.value23 = v3771.Murder
            spilledValues1.value29 = function()
                local v1205, v1207, v1208, v1211, v1214, v1216
                local v1206 = up188()
                if (not v1206) then
                    up179:Notify({["Title"] = "Combat", ["Content"] = "You must be the Murderer!", ["Duration"] = 2})

                    return
                else
                    v1206 = (game.Players:FindFirstChild(_G.MurderTarget ))
                    if v1206 then
                        v1211 = game.Players.LocalPlayer
                        v1208 = (up189(v1211))
                        if (not v1208) then
                            return
                        else
                            v1205 = v1208.Parent
                            if (v1205 ~= v1211["Character"]) then
                                v1211.Character.Humanoid:EquipTool(v1208)
                                task.wait(.05)
                            end
                            up208(v1206, v1208)
                            v1207 = up179
                            v1216 = v1206.Name
                            v1205 = v1207.Notify
                            v1214 = ("Silently killed: " .. v1216)
                            v1205(v1207, {["Title"] = "Combat", ["Content"] = v1214, ["Duration"] = 2})
                        end
                    end
                    return
                end
            end
            spilledValues1.value23:AddButton({["Title"] = "Kill Selected Player", ["Callback"] = spilledValues1.value29})
            spilledValues1.value23 = v3771.Murder
            spilledValues1.value29 = function()
                local v1221 = up212
                local v1224 = {up211()}
                v1221:SetValues(unpackValues(v1224))

                return
            end
            spilledValues1.value23:AddButton({["Title"] = "Refresh Player List", ["Callback"] = spilledValues1.value29})
            task.spawn(function()
                local v1225, v1226, v1227, v1230, v1231, v1233
                while true do
                    v1226 = _G
                    if v1226.ScriptUnloaded then
                        break
                    else
                        v1227 = game.Players.LocalPlayer.Character
                        if v1227 then
                            v1226 = (v1227:FindFirstChild("Humanoid"))
                        end
                        v1225 = _G
                        v1231 = _G.roleTickCount
                        v1225.roleTickCount = ((v1231 or 0) + 1)
                        v1226 = _G
                        v1230 = (_G.listTickCount or 0)
                        v1226.listTickCount = (v1230 + 1)
                        v1233 = _G
                        if (v1233.roleTickCount >= 3) then
                            v1226 = _G
                            v1226.roleTickCount = 0
                            v1233 = function()
                                local v2966 = ipairs
                                local v2972 = game.Players
                                local v2971 = v2972.GetPlayers
                                for v2974, v2971 in v2966(v2971(v2972)) do
                                    up185(v2971)
                                end
                                return
                            end
                            pcall(v1233)
                        end
                        v1233 = _G
                        if (v1233.listTickCount >= 15) then
                            v1226 = _G
                            v1226.listTickCount = 0
                            pcall(function()
                                local v3581 = up212
                                local v3583 = {up211()}
                                v3581:SetValues(unpackValues(v3583))

                                return
                            end)
                        end
                        task.wait(0.5)
                    end
                end
                return
            end)
            spilledValues1.value24 = v3771.Sheriff:AddSection("Kill Murderer")
            spilledValues1.value31 = function(arg98_1)
                _G.SilentAimSheriff = arg98_1
                return
            end
            spilledValues1.value24:AddToggle("SilentAimSheriffToggle", {["Title"] = "Silent Aim (Sheriff)", ["Default"] = false, ["Callback"] = spilledValues1.value31})
            spilledValues1.value31 = function(arg99_1)
                _G.SilentAimSheriffVisible = arg99_1
                return
            end
            spilledValues1.value24:AddToggle("SilentAimSheriffVisible", {["Title"] = "Visible Only", ["Default"] = true, ["Callback"] = spilledValues1.value31})
            spilledValues1.value25 = v3771.Sheriff:AddSection("Get Gun")
            spilledValues1.value23 = _G
            spilledValues1.value23.AutoGetGunNotify = true
            spilledValues1.value23 = spilledValues1.value25.AddToggle
            v3796 = function(arg100_1)
                _G.AutoGetGun = arg100_1
                return
            end
            spilledValues1.value23(spilledValues1.value25, "AutoGetGun", {["Title"] = "Auto Dropped Gun", ["Default"] = false, ["Callback"] = v3796})
            spilledValues1.value23 = spilledValues1.value25.AddKeybind
            spilledValues1.value32 = function(arg101_1)
                local v1258, v1261
                if arg101_1 then
                    v1258 = workspace:FindFirstChild("GunDrop", true)
                    v1261 = v1258
                    if not (v1258) then
                        v1261 = (workspace:FindFirstChild("Gun Drop", true))
                    end
                    if v1261 then
                        up187()
                    else
                        up179:Notify({["Title"] = "Error", ["Content"] = "No dropped gun found in workspace.", ["Duration"] = 3})
                    end
                end
                return
            end
            spilledValues1.value23 = spilledValues1.value23(spilledValues1.value25, "GetGunKeybind", {["Title"] = "Get Dropped Gun", ["Mode"] = "Toggle", ["Default"] = "G", ["Callback"] = spilledValues1.value32})
            local up213 = spilledValues1.value23
            spilledValues1.value23 = spilledValues1.value25.AddButton
            spilledValues1.value30 = function()
                local v1268 = function()
                    up213:SetValue("G", "Toggle")
                    return
                end
                pcall(v1268)

                return
            end
            spilledValues1.value23(spilledValues1.value25, {["Title"] = "Reset Get Gun Keybind", ["Callback"] = spilledValues1.value30})
            v3771.AutoFarm:AddSection("Automated Farming")
            spilledValues1.value23 = _G
            spilledValues1.value29 = v3771.AutoFarm
            v3798 = spilledValues1.value29.AddToggle
            spilledValues1.value34 = function(arg103_1)
                local v1270, v1272, v1273
                _G.AutoCoinV3 = arg103_1
                if arg103_1 then
                    v1273 = workspace:FindFirstChild("CoinContainer", true)
                    v1270 = v1273
                    if not (v1273) then
                        v1270 = (workspace:FindFirstChild("Coins", true))
                    end
                    v1272 = v1270
                    if v1272 then
                        up201(v1272)
                    end
                else
                    pcall(function()
                        local v2975
                        if up198 then
                            v2975 = up198
                            v2975.Enabled = false
                        end
                        return
                    end)
                end
                return
            end
            v3798 = v3798(spilledValues1.value29, "AutoFarmCoin", {["Title"] = "Auto Coin Farm", ["Default"] = false, ["Callback"] = spilledValues1.value34})
            spilledValues1.value23.AutoFarmCoinToggle = v3798
            spilledValues1.value27 = function()
                local v1283 = workspace:FindFirstChild("CoinContainer", true)
                local v1284 = v1283
                if not (v1283) then
                    v1284 = (workspace:FindFirstChild("Coins", true))
                end
                return v1284
            end
            task.spawn(function()
                local v1286, v1287
                while true do
                    task.wait(.05)
                    v1286 = _G
                    if v1286.ScriptUnloaded then
                        break
                    else
                        v1287 = game.Players.LocalPlayer.Character
                        if v1287 then
                            v1287:FindFirstChild("HumanoidRootPart")
                        end
                    end
                end
                return
            end)
            task.spawn(function()
                local v1296, v1297, v1300
                while true do
                    task.wait(2)
                    v1296 = _G
                    if v1296.ScriptUnloaded then
                        break
                    else
                        v1296 = _G
                        if v1296.AutoCoinV3 then
                            v1297 = workspace:FindFirstChild("CoinContainer", true)
                            v1296 = v1297
                            if not (v1297) then
                                v1296 = (workspace:FindFirstChild("Coins", true))
                            end
                            v1300 = v1296
                            v1296 = v1300
                            if v1300 then
                                v1296 = v1300.Parent and (not up197[v1300])
                            end
                            if v1296 then
                                up201(v1300)
                            end
                        end
                    end
                end
                return
            end)
            spilledValues1.value29 = v3771.Teleport:AddSection("Location Teleports")
            local up215 = 1
            spilledValues1.value27 = spilledValues1.value29.AddButton
            spilledValues1.value32 = function()
                local v1306, v1307, v1308, v1313, v1316
                local v1305 = game.Players.LocalPlayer
                local v1309 = v1305.Character
                local v1310 = v1309
                if v1309 then
                    v1310 = (v1305.Character:FindFirstChild("HumanoidRootPart"))
                end
                v1309 = v1310
                if (not v1309) then
                    return
                else
                    v1306 = _G.MapCoordinates
                    v1310 = v1306
                    if v1306 then
                        v1310 = _G.MapCoordinates.Lobby
                    end
                    if v1310 then
                        v1306 = _G.MapCoordinates.Lobby
                        up215 = ((up215 % (#v1306)) + 1)
                        v1308 = v1306[up215]
                        v1313 = Vector3.new(0, 3, 0)
                        v1309.CFrame = (v1308 + v1313)
                        v1310 = up179
                        v1307 = v1310.Notify
                        v1316 = string.format("Teleported to Lobby (Spot %d)", up215)
                        v1307(v1310, {["Title"] = "Lobby Teleport", ["Content"] = v1316, ["Duration"] = 2})
                    else
                        v1307 = CFrame.new(-108.5, 143, 15)
                        v1309.CFrame = v1307
                        up179:Notify({["Title"] = "Warning", ["Content"] = "Lobby coordinates not found. Using fallback.", ["Duration"] = 2})
                    end
                    return
                end
            end
            spilledValues1.value27(spilledValues1.value29, {["Title"] = "Teleport to Lobby", ["Callback"] = spilledValues1.value32})
            spilledValues1.value27 = spilledValues1.value29.AddButton
            spilledValues1.value32 = function()
                _G.TeleportToMap(true)
                return
            end
            spilledValues1.value27(spilledValues1.value29, {["Title"] = "Teleport to Map", ["Callback"] = spilledValues1.value32})
            spilledValues1.value30 = v3771.Teleport:AddSection("Entity Teleports")
            spilledValues1.value27 = spilledValues1.value30.AddButton
            spilledValues1.value33 = function()
                local v1328, v1329, v1333, v1334, v1335, v1336, v1337, v1338, v1339, v1343
                local v1327 = game.Players.LocalPlayer
                local v1331 = (not v1327.Character)
                local v1332 = v1331
                if not (v1331) then
                    v1332 = (not (v1327.Character:FindFirstChild("HumanoidRootPart")))
                end
                if v1332 then
                    return
                else
                    v1333 = pairs
                    v1329 = game.Players
                    v1334 = v1329.GetPlayers
                    for v1328, v1334 in v1333(v1334(v1329)) do
                        v1336 = (v1334 ~= v1327)
                        v1335 = v1336
                        if v1336 then
                            v1343 = ((up186(v1334)) == "Murderer")
                            v1336 = v1343
                            if v1343 then
                                v1339 = v1334.Character
                                v1343 = v1339
                                if v1339 then
                                    v1343 = (v1334.Character:FindFirstChild("HumanoidRootPart"))
                                end
                                v1336 = v1343
                            end
                            v1335 = v1336
                        end
                        if v1335 then
                            v1333 = v1327.Character.HumanoidRootPart
                            v1337 = v1334.Character.HumanoidRootPart.CFrame
                            v1338 = CFrame.new(0, 0, 3)
                            v1333.CFrame = (v1337 * v1338)
                            v1333 = up179
                            v1339 = ("Teleported behind Murderer (" .. (v1334.Name .. ")"))
                            v1336 = {["Title"] = "Successful", ["Content"] = v1339, ["Duration"] = 3}
                            v1333:Notify(v1336)

                            return
                        end
                    end
                    up179:Notify({["Title"] = "Failed", ["Content"] = "Murderer not found or not alive!", ["Duration"] = 3})

                    return
                end
            end
            spilledValues1.value27(spilledValues1.value30, {["Title"] = "Teleport to Murderer", ["Callback"] = spilledValues1.value33})
            spilledValues1.value27 = spilledValues1.value30.AddButton
            spilledValues1.value33 = function()
                local v1349, v1350, v1354, v1355, v1356, v1357, v1358, v1359, v1360, v1364
                local v1348 = game.Players.LocalPlayer
                local v1352 = (not v1348.Character)
                local v1353 = v1352
                if not (v1352) then
                    v1353 = (not (v1348.Character:FindFirstChild("HumanoidRootPart")))
                end
                if v1353 then
                    return
                else
                    v1354 = pairs
                    v1350 = game.Players
                    v1355 = v1350.GetPlayers
                    for v1349, v1355 in v1354(v1355(v1350)) do
                        v1357 = (v1355 ~= v1348)
                        v1356 = v1357
                        if v1357 then
                            v1364 = ((up186(v1355)) == "Sheriff")
                            v1357 = v1364
                            if v1364 then
                                v1360 = v1355.Character
                                v1364 = v1360
                                if v1360 then
                                    v1364 = (v1355.Character:FindFirstChild("HumanoidRootPart"))
                                end
                                v1357 = v1364
                            end
                            v1356 = v1357
                        end
                        if v1356 then
                            v1354 = v1348.Character.HumanoidRootPart
                            v1358 = v1355.Character.HumanoidRootPart.CFrame
                            v1359 = CFrame.new(0, 0, 3)
                            v1354.CFrame = (v1358 * v1359)
                            v1354 = up179
                            v1360 = ("Teleported behind Sheriff (" .. (v1355.Name .. ")"))
                            v1354:Notify({["Title"] = "Successful", ["Content"] = v1360, ["Duration"] = 3})

                            return
                        end
                    end
                    up179:Notify({["Title"] = "Failed", ["Content"] = "Sheriff not found or not alive!", ["Duration"] = 3})

                    return
                end
            end
            spilledValues1.value27(spilledValues1.value30, {["Title"] = "Teleport to Sheriff", ["Callback"] = spilledValues1.value33})
            spilledValues1.value31 = v3771.Teleport:AddSection("Player Teleport")
            local up216
            spilledValues1.value35 = {}
            spilledValues1.value27 = spilledValues1.value31.AddDropdown
            spilledValues1.value39 = function(arg111_1)
                up216 = arg111_1
                return
            end
            spilledValues1.value27 = spilledValues1.value27(spilledValues1.value31, "PlayerDropdown", {["Title"] = "Select Player", ["Values"] = spilledValues1.value35, ["Default"] = nil, ["Callback"] = spilledValues1.value39})
            local up217 = spilledValues1.value27
            task.spawn(function()
                local v1370, v1371, v1372, v1374, v1375, v1378, v1380
                while true do
                    task.wait(3)
                    v1372 = _G
                    v1371 = "ScriptUnloaded"
                    if v1372[v1371] then
                        break
                    else
                        local up64 = {}
                        v1370 = pairs
                        v1375 = game.Players
                        v1380 = v1375.GetPlayers
                        for v1374, v1380 in v1370(v1380(v1375)) do
                            v1378 = game.Players
                            if (v1380 ~= v1378.LocalPlayer ) then
                                table.insert(up64, v1380.Name)
                            end
                        end
                        v1374 = function()
                            up217:SetValues(up64)
                            return
                        end
                        pcall(v1374)
                    end
                end
                return
            end)
            spilledValues1.value27 = spilledValues1.value31.AddButton
            spilledValues1.value35 = function()
                local v1385, v1386, v1387, v1388, v1389, v1390, v1391, v1394
                if up216 then
                    v1385 = (game.Players:FindFirstChild(up216))
                    v1386 = v1385
                    if v1385 then
                        v1389 = v1385.Character
                        v1387 = v1389
                        if v1389 then
                            v1387 = (v1385.Character:FindFirstChild("HumanoidRootPart"))
                        end
                        v1386 = v1387
                    end
                    if v1386 then
                        v1390 = game.Players.LocalPlayer.Character.HumanoidRootPart
                        v1388 = v1385.Character.HumanoidRootPart.CFrame
                        v1394 = CFrame.new(0, 3, 0)
                        v1390.CFrame = (v1388 * v1394)
                        v1390 = up179
                        v1391 = ("Teleported to " .. up216)
                        v1390:Notify({["Title"] = "Successful", ["Content"] = v1391, ["Duration"] = 2})
                    else
                        up179:Notify({["Title"] = "Error", ["Content"] = "Player not found or dead!", ["Duration"] = 2})
                    end
                else
                    up179:Notify({["Title"] = "Error", ["Content"] = "Please select a player first!", ["Duration"] = 2})
                end
                return
            end
            spilledValues1.value27(spilledValues1.value31, {["Title"] = "Teleport to Selected Player", ["Callback"] = spilledValues1.value35})
            spilledValues1.value27 = game:GetService("UserInputService").JumpRequest
            spilledValues1.value33 = function()
                local v1398, v1399, v1401, v1403
                local v1397 = _G
                if v1397["InfJumpActive"] then
                    v1401 = game.Players.LocalPlayer
                    v1398 = v1401.Character
                    v1397 = v1398
                    if v1398 then
                        v1397 = (v1401.Character:FindFirstChild("Humanoid"))
                    end
                    if v1397 then
                        v1403 = v1401.Character.Humanoid
                        v1399 = Enum.HumanoidStateType
                        v1403:ChangeState(v1399.Jumping)
                    end
                end
                return
            end
            spilledValues1.value27:Connect(spilledValues1.value33)
            Vector3.new(0, 0, 0)
            spilledValues1.value28 = function(arg115_1)
                local v1409, v1410, v1411, v1414, v1415, v1416, v1417, v1418, v1419, v1420
                local v1407 = arg115_1
                local v1408 = _G
                if v1408["ScriptUnloaded"] then
                    return
                else
                    v1409 = game.Players.LocalPlayer.Character
                    v1408 = v1409
                    if v1409 then
                        v1418 = v1409:FindFirstChild("HumanoidRootPart")
                        v1411 = v1418
                        if v1418 then
                            v1411 = (v1409:FindFirstChild("Humanoid"))
                        end
                        v1408 = v1411
                    end
                    if (not v1408) then
                        return
                    else
                        v1410 = v1409.HumanoidRootPart
                        v1411 = v1409.Humanoid
                        v1414 = workspace.CurrentCamera
                        game:GetService("UserInputService")
                        v1419 = _G.FlyActive
                        v1408 = v1419
                        if not (v1419) then
                            v1408 = _G.AutoCoinV3
                        end
                        if v1408 then
                            v1419 = Vector3.new(0, 0, 0)
                            v1410.Velocity = v1419
                            v1419 = Vector3.new(0, 0, 0)
                            v1410.RotVelocity = v1419
                        else
                            v1419 = _G.SpeedEnabled
                            v1408 = v1419
                            if v1419 then
                                v1408 = (_G.WalkSpeedValue > 16)
                            end
                            if v1408 then
                                v1419 = v1411.MoveDirection
                                if (v1419["Magnitude"] > 0) then
                                    v1419 = Vector3.new((v1411.MoveDirection.X * 16), v1410.Velocity.Y, (v1411.MoveDirection.Z * 16))
                                    v1410.Velocity = v1419
                                else
                                    v1419 = Vector3.new(0, v1410.Velocity.Y, 0)
                                    v1410.Velocity = v1419
                                end
                                v1419 = Vector3.new(0, 0, 0)
                                v1410.RotVelocity = v1419
                            end
                        end
                        v1419 = _G.SpeedEnabled
                        v1408 = v1419
                        if v1419 then
                            v1416 = (_G.WalkSpeedValue > 16)
                            v1419 = v1416
                            if v1416 then
                                v1420 = (not _G.FlyActive)
                                v1416 = v1420
                                if v1420 then
                                    v1416 = (not _G.AutoCoinV3)
                                end
                                v1419 = v1416
                            end
                            v1408 = v1419
                        end
                        if v1408 then
                            v1419 = v1411.MoveDirection
                            if (v1419["Magnitude"] > 0) then
                                v1419 = (_G.WalkSpeedValue - 16)
                                v1408 = (v1410.CFrame + ((v1411.MoveDirection * v1419) * v1407))
                                v1410.CFrame = v1408
                            end
                            v1411.WalkSpeed = 16
                        else
                            v1419 = (not _G.FlyActive)
                            v1408 = v1419
                            if v1419 then
                                v1408 = (not _G.AutoCoinV3)
                            end
                            if v1408 then
                                v1411.WalkSpeed = 16
                            end
                        end
                        v1408 = _G
                        if v1408["NoclipActive"] then
                            v1417 = v1409.GetDescendants
                            v1414 = pairs
                            for v1415, v1420 in v1414(v1417(v1409)) do
                                v1414 = v1420:IsA("BasePart")
                                if v1414 then
                                    v1420.CanCollide = false
                                end
                            end
                        end
                        return
                    end
                end
            end
            v3737.Heartbeat :Connect(spilledValues1.value28)
            spilledValues1.value33 = v3771.Settings:AddSection("Server Hop")
            spilledValues1.value37 = function()
                local v1427 = up196
                local v1438 = function()
                    local v3366 = game:GetService("TeleportService")
                    local up145 = v3366
                    v3366 = game:GetService("HttpService")
                    local up146 = v3366
                    local v3367 = game.PlaceId
                    local up147 = v3367
                    v3367 = game.JobId
                    local up148 = v3367
                    up179:Notify({["Title"] = "Server Hop", ["Content"] = "Searching for a suitable server...", ["Duration"] = 3})
                    task.spawn(function()
                        local v1947, v1948, v1950, v1951, v1952, v1954, v1955, v1956, v1957, v1958
                        local v1946 = function()
                            local v3558 = game
                            local v3566 = ("https://games.roblox.com/v1/games/" .. (up147 .. "/servers/Public?sortOrder=Desc&limit=100"))
                            return v3558:HttpGet(v3566)
                        end
                        local v1949 = {}
                        v1947, v1950 = pcall(v1946)
                        if v1947 then
                            v1951 = (up146:JSONDecode(v1950))
                            v1947 = v1951 and v1951.data
                            if v1947 then
                                for v1955, v1954 in ipairs(v1951.data) do
                                    v1958 = (v1954.id ~= up148)
                                    v1957 = v1958
                                    if v1958 then
                                        v1957 = (v1954.playing < (v1954.maxPlayers - 2)) and (v1954.playing > 5)
                                    end
                                    if v1957 then
                                        table.insert(v1949, v1954)
                                    end
                                end
                            end
                        end
                        if ((#v1949) > 0) then
                            v1951 = v1949[(math.random(1, (#v1949)))]
                            v1948 = up179
                            v1957 = ("Joining server with " .. (v1951.playing .. " players"))
                            v1948:Notify({["Title"] = "Teleporting", ["Content"] = v1957, ["Duration"] = 3})
                            v1948 = up145
                            v1955 = up147
                            v1952 = v1951.id
                            v1954 = game.Players
                            v1948:TeleportToPlaceInstance(v1955, v1952, v1954.LocalPlayer)
                        else
                            up179:Notify({["Title"] = "Fallback", ["Content"] = "No small servers found. Using standard teleport.", ["Duration"] = 3})
                            v1948 = up145
                            v1956 = up147
                            v1952 = game.Players
                            v1948:Teleport(v1956, v1952.LocalPlayer)
                        end
                        return
                    end)

                    return
                end
                local v1434 = {["Title"] = "Confirm", ["Callback"] = v1438}
                local v1440 = v1427.Dialog
                local v1439 = function()
                    return
                end
                local v1435 = {["Title"] = "Cancel", ["Callback"] = v1439}
                local v1433 = {v1434, v1435}
                v1440(v1427, {["Title"] = "Confirm Server Hop", ["Content"] = "Are you sure you want to change servers? This will disconnect you from the current game.", ["Buttons"] = v1433})

                return
            end
            spilledValues1.value33:AddButton({["Title"] = "Server Hop", ["Callback"] = spilledValues1.value37})
            spilledValues1.value27 = spilledValues1.value33.AddButton
            spilledValues1.value37 = function()
                local v1444 = up196
                local v1455 = function()
                    local v256 = (game:GetService("TeleportService"))
                    local v253 = (game:GetService("Players"))
                    local v254 = v253.LocalPlayer
                    local v255 = v253:GetPlayers()
                    if ((#v255) <= 1) then
                        v255 = game
                        v256:Teleport(v255.PlaceId, v254)
                    else
                        v255 = game
                        v256:TeleportToPlaceInstance(v255.PlaceId, game.JobId, v254)
                    end
                    return
                end
                local v1451 = {["Title"] = "Confirm", ["Callback"] = v1455}
                local v1452 = {["Title"] = "Cancel"}
                local v1458 = v1444.Dialog
                local v1450 = {v1451, v1452}
                v1458(v1444, {["Title"] = "Confirm Rejoin", ["Content"] = "Are you sure you want to rejoin the current server?", ["Buttons"] = v1450})

                return
            end
            spilledValues1.value27(spilledValues1.value33, {["Title"] = "Rejoin", ["Callback"] = spilledValues1.value37})
            spilledValues1.value27 = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
            spilledValues1.value27:SetLibrary(up179)
            spilledValues1.value27:SetFolder("MM2Hub")
            spilledValues1.value34 = v3771.Settings
            spilledValues1.value27:BuildInterfaceSection(spilledValues1.value34)
            up196:SelectTab(1)
            spilledValues1.value28 = task.spawn
            spilledValues1.value35 = function()
                local v1460, v1461, v1462, v1463, v1464, v1465, v1466, v1467, v1468, v1469, v1470, v1471, v1472, v1473, v1474, v1475
                local v1477, v1480
                while true do
                    v1461 = (task.wait())
                    v1462 = _G
                    if v1462["ScriptUnloaded"] then
                        break
                    else
                        v1463 = game.Players.LocalPlayer
                        v1464 = _G.FlyActive
                        v1462 = v1464
                        if v1464 then
                            v1466 = v1463.Character
                            v1464 = v1466
                            if v1466 then
                                v1469 = v1463.Character:FindFirstChild("HumanoidRootPart")
                                v1466 = v1469
                                if v1469 then
                                    v1466 = (v1463.Character:FindFirstChild("Humanoid"))
                                end
                                v1464 = v1466
                            end
                            v1462 = v1464
                        end
                        if v1462 then
                            v1464 = v1463.Character.HumanoidRootPart
                            v1465 = v1463.Character.Humanoid
                            v1466 = workspace.CurrentCamera
                            v1467 = (game:GetService("UserInputService"))
                            v1465.PlatformStand = true
                            v1468 = v1464:FindFirstChild("FlyLock")
                            v1462 = v1468
                            if not (v1468) then
                                v1462 = (Instance.new("BodyVelocity"))
                            end
                            v1468 = v1462
                            if (not v1468["Parent"]) then
                                v1468.Name = "FlyLock"
                                v1469 = Vector3.new(9000000000, 9000000000, 9000000000)
                                v1468.MaxForce = v1469
                                v1469 = Vector3.new(0, 0, 0)
                                v1468.Velocity = v1469
                                v1468.Parent = v1464
                            end
                            v1462 = Vector3.new(0, 0, 0)
                            v1471 = Enum
                            v1469 = v1462
                            v1470 = v1471.KeyCode
                            v1460 = v1467:IsKeyDown(v1470.W)
                            if v1460 then
                                v1469 = (v1469 + v1466.CFrame.LookVector)
                            end
                            v1470 = Enum.KeyCode.S
                            v1462 = v1467:IsKeyDown(v1470)
                            if v1462 then
                                v1469 = (v1469 - v1466.CFrame.LookVector)
                            end
                            v1471 = Enum.KeyCode.A
                            v1470 = v1467:IsKeyDown(v1471)
                            if v1470 then
                                v1469 = (v1469 - v1466.CFrame.RightVector)
                            end
                            v1473 = Enum.KeyCode
                            v1471 = v1467:IsKeyDown(v1473.D)
                            if v1471 then
                                v1469 = (v1469 + v1466.CFrame.RightVector)
                            end
                            v1474 = Enum.KeyCode
                            v1472 = v1467:IsKeyDown(v1474.Space)
                            if v1472 then
                                v1469 = (v1469 + (Vector3.new(0, 1, 0)))
                            end
                            v1475 = Enum.KeyCode
                            v1473 = v1467:IsKeyDown(v1475.LeftControl)
                            if v1473 then
                                v1469 = (v1469 - (Vector3.new(0, 1, 0)))
                            end
                            v1474 = (_G.FlySpeed or 50)
                            v1475 = v1464.Position
                            if (v1469["Magnitude"] > 0) then
                                v1475 = (v1464.Position + ((v1469.Unit * v1474) * v1461))
                            end
                            v1477 = (v1475 + v1466.CFrame.LookVector)
                            v1480 = CFrame.new(v1475, Vector3.new(v1477.X, v1475.Y, v1477.Z))
                            v1464.CFrame = v1480
                            v1480 = Vector3.new(0, 0, 0)
                            v1464.Velocity = v1480
                            v1480 = Vector3.new(0, 0, 0)
                            v1464.RotVelocity = v1480
                        else
                            v1464 = (not _G.FlyActive) and v1463.Character
                            if v1464 then
                                v1465 = v1463.Character:FindFirstChild("Humanoid")
                                v1466 = v1463.Character:FindFirstChild("HumanoidRootPart")
                                v1464 = v1465 and v1465.PlatformStand
                                if v1464 then
                                    v1465.PlatformStand = false
                                    v1468 = Enum.HumanoidStateType
                                    v1465:ChangeState(v1468.Running)
                                end
                                v1464 = v1466
                                if v1466 then
                                    v1464 = (v1466:FindFirstChild("FlyLock"))
                                end
                                if v1464 then
                                    v1466.FlyLock:Destroy()
                                end
                            end
                        end
                    end
                end
                return
            end
            spilledValues1.value28(spilledValues1.value35)
            workspace.DescendantAdded:Connect(function(arg119_1)
                local v1490 = arg119_1
                local v1491 = _G
                if v1491.XrayActive then
                    ApplyXray(v1490)
                end
                return
            end)
            spilledValues1.value28 = _G
            spilledValues1.value28.PlayerIsDead = false
            spilledValues1.value34 = function(arg120_1)
                local v1498
                local v1496 = (arg120_1:WaitForChild("Humanoid", 5))
                if v1496 then
                    v1498 = function()
                        _G.PlayerIsDead = true
                        _G.IsCollectingGun = false
                        return
                    end
                    v1496.Died:Connect(v1498)
                end
                return
            end
            local up218 = spilledValues1.value34
            spilledValues1.value35 = game.Players.LocalPlayer
            if spilledValues1.value35["Character"] then
                up218(game.Players.LocalPlayer.Character)
            end
            spilledValues1.value34 = game.Players.LocalPlayer.CharacterAdded
            spilledValues1.value36 = function(arg241_1)
                _G.PlayerIsDead = false
                _G.IsCollectingGun = false
                up218(arg241_1)
                return
            end
            spilledValues1.value34:Connect(spilledValues1.value36)
            spilledValues1.value35 = task
            spilledValues1.value38 = function()
                local v2910, v2911, v2913, v2914
                v2910, v2913 = pcall(function()
                    return Drawing.new("Square")
                end)
                v2910 = (v2910 and v2913)
                if v2910 then
                    v2913.Visible = false
                    v2914 = Color3.fromRGB(255, 255, 255)
                    v2913.Color = v2914
                    v2913.Thickness = 1
                    v2913.Transparency = 1
                    v2913.Filled = false
                    return v2913
                else
                    v2911 = nil
                    return v2911
                end
            end
            spilledValues1.value34 = spilledValues1.value35.spawn
            spilledValues1.value36 = function()
                local v2930, v2931, v2932, v2934
                local v2925 = Instance.new("Folder")
                local up131 = v2925
                up131.Name = "KillAuraVisuals"
                local up133 = 30
                local up132 = {}
                local v2924 = up133
                local v2921 = 1
                for v2928 = 1, v2924, v2921 do
                    v2934 = (Instance.new("Part"))
                    v2934.Name = ("Segment_" .. v2928)
                    v2925 = Enum.PartType.Block
                    v2934.Shape = v2925
                    v2925 = Enum.Material.Neon
                    v2934.Material = v2925
                    v2931 = Color3.fromRGB(255, 255, 255)
                    v2934.Color = v2931
                    v2934.Transparency = 1
                    v2934.Anchored = true
                    v2934.CanCollide = false
                    v2934.CastShadow = false
                    v2931 = (Instance.new("SelectionBox"))
                    v2932 = Color3.fromRGB(255, 255, 255)
                    v2931.Color3 = v2932
                    v2931.LineThickness = 0
                    v2931.SurfaceTransparency = 1
                    v2934.Parent = up131
                    table.insert(up132, v2934)
                end
                local up134 = false
                v2925 = game:GetService("TweenService")
                local up135 = v2925
                local v2929
                while true do
                    task.wait()
                    v2925 = _G
                    v2930 = "ScriptUnloaded"
                    if v2925[v2930] then
                        break
                    else
                        v2925 = game.Players
                        local up136 = v2925.LocalPlayer
                        v2934 = function()
                            local v1691, v1694, v1695, v1696, v1697, v1698, v1699, v1700, v1701, v1702, v1703, v1704, v1705, v1707, v1711
                            local v1692 = up136.Character
                            local v1689 = v1692 and (v1692:FindFirstChild("Humanoid"))
                            local v1688 = v1692
                            if v1692 then
                                v1688 = (v1692:FindFirstChild("HumanoidRootPart"))
                            end
                            local v1690 = v1688
                            v1688 = v1692
                            if v1692 then
                                v1691 = v1689
                                if v1689 then
                                    v1691 = v1690 and (v1689.Health > 0)
                                end
                                v1688 = v1691
                            end
                            if v1688 then
                                v1691 = (up188())
                                v1688 = _G
                                if v1688["KillAura"] then
                                    v1688 = (_G.KillAuraRange or 15)
                                    v1695 = up134
                                    v1694 = v1688
                                    if (not v1695) then
                                        up134 = true
                                        v1695 = up131
                                        v1702 = workspace.CurrentCamera
                                        v1695.Parent = v1702
                                        v1695 = ipairs
                                        v1700 = up132
                                        for v1701, v1700 in v1695(v1700) do
                                            v1697 = up135
                                            v1703 = TweenInfo.new(.4)
                                            v1698 = v1697.Create
                                            v1699 = {["Transparency"] = .2}
                                            v1698 = v1698(v1697, v1700, v1703, v1699)
                                            v1698:Play()
                                        end
                                    end
                                    v1696 = up131
                                    if v1696["Parent"] then
                                        v1695 = (v1690.Position - (Vector3.new(0, ((v1690.Size.Y / 2) - .1), 0)))
                                        v1702 = Color3.fromRGB(255, 255, 255)
                                        v1700 = up133
                                        v1697 = 1
                                        for v1701 = 1, v1700, v1697 do
                                            v1696 = v1701
                                            v1699 = up132[v1696]
                                            if v1699 then
                                                v1703 = (((v1696 / up133) * math.pi) * 2)
                                                v1707 = ((math.cos(v1703)) * v1694)
                                                v1704 = ((math.sin(v1703)) * v1694)
                                                v1711 = Vector3.new(((((2 * math.pi) * v1694) / up133) * .55), .2, .2)
                                                v1699.Size = v1711
                                                v1711 = CFrame.new((v1695 + (Vector3.new(v1707, 0, v1704))), v1695)
                                                v1699.CFrame = v1711
                                                v1699.Color = v1702
                                            end
                                        end
                                    end
                                    if v1691 then
                                        v1696 = up189(up136)
                                        if v1696 then
                                            if (v1696["Parent"] ~= v1692) then
                                                if v1689 then
                                                    v1689:EquipTool(v1696)
                                                end
                                            end
                                            v1695 = _G
                                            v1701 = _G.KillAuraCooldowns or {}
                                            v1695.KillAuraCooldowns = v1701
                                            v1695 = pairs
                                            v1697 = game.Players
                                            v1699 = v1697.GetPlayers
                                            for v1700, v1697 in v1695(v1699(v1697)) do
                                                v1707 = up136
                                                v1703 = (v1697 ~= v1707)
                                                v1698 = v1703
                                                if v1703 then
                                                    v1704 = v1697.Character
                                                    v1703 = v1704
                                                    if v1704 then
                                                        v1703 = (v1697.Character:FindFirstChild("HumanoidRootPart"))
                                                    end
                                                    v1698 = v1703
                                                end
                                                if v1698 then
                                                    v1699 = v1697.Character:FindFirstChild("HumanoidRootPart")
                                                    v1703 = v1697.Character:FindFirstChild("Humanoid")
                                                    v1698 = v1703 and (v1703.Health > 0)
                                                    if v1698 then
                                                        v1707 = (v1699.Position - v1690.Position)
                                                        if (v1707["Magnitude"] <= v1694) then
                                                            v1707 = (_G.KillAuraCooldowns[v1697.UserId ] or 0)
                                                            v1711 = tick()
                                                            if ((v1711 - v1707) >= .4) then
                                                                v1704 = _G.KillAuraCooldowns
                                                                v1705 = v1697.UserId
                                                                v1711 = tick()
                                                                v1704[v1705] = v1711
                                                                up208(v1697, v1696)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    if up134 then
                                        v1702 = function()
                                            local v282, v288
                                            local v283 = (up189(up136))
                                            local v284 = v283 and (v283:FindFirstChild("Handle"))
                                            if v284 then
                                                v282 = v283.Handle
                                                v288 = Vector3.new(1, 1, 1)
                                                v282.Size = v288
                                            end
                                            return
                                        end
                                        up134 = false
                                        pcall(v1702)
                                        v1695 = ipairs
                                        v1700 = up132
                                        for v1701, v1700 in v1695(v1700) do
                                            v1697 = up135
                                            v1703 = TweenInfo.new(.3)
                                            v1698 = v1697.Create
                                            v1699 = {["Transparency"] = 1}
                                            v1698 = v1698(v1697, v1700, v1703, v1699)
                                            v1698:Play()
                                        end
                                        v1696 = task
                                        v1701 = function()
                                            local v350
                                            if (not up134) then
                                                v350 = up131
                                                v350.Parent = nil
                                            end
                                            return
                                        end
                                        v1696.delay(.35, v1701)
                                    end
                                end
                            end
                            return
                        end
                        pcall(v2934)
                    end
                end
                if up131 then
                    up131:Destroy()
                end
                if v2929 then
                    v2929:Disconnect()
                end
                return
            end
            spilledValues1.value34(spilledValues1.value36)
            spilledValues1.value36 = function()
                local v2939, v2940, v2941, v2942
                local v2938 = function()
                    return Drawing.new("Circle")
                end
                v2939, v2941 = pcall(v2938)
                v2939 = (v2939 and v2941)
                if v2939 then
                    v2941.Visible = false
                    v2942 = Color3.fromRGB(0, 0, 0)
                    v2941.Color = v2942
                    v2941.Thickness = 1
                    v2941.Transparency = 1
                    v2941.Filled = false
                    return v2941
                else
                    v2940 = nil
                    return v2940
                end
            end
            spilledValues1.value37 = function()
                local v2947, v2949, v2950, v2951
                local v2948 = function()
                    return Drawing.new("Text")
                end
                v2947, v2950 = pcall(v2948)
                v2947 = (v2947 and v2950)
                if v2947 then
                    v2950.Visible = false
                    v2950.Center = true
                    v2950.Outline = true
                    v2951 = Color3.new(0, 0, 0)
                    v2950.OutlineColor = v2951
                    v2950.Font = 2
                    v2950.Size = 13
                    v2951 = Color3.new(1, 1, 1)
                    v2950.Color = v2951
                    return v2950
                else
                    v2949 = nil
                    return v2949
                end
            end
            local up219 = function()
                local v2957, v2958, v2959, v2960
                local v2956 = function()
                    return Drawing.new("Line")
                end
                v2957, v2959 = pcall(v2956)
                v2957 = (v2957 and v2959)
                if v2957 then
                    v2959.Visible = false
                    v2960 = Color3.fromRGB(0, 0, 0)
                    v2959.Color = v2960
                    v2959.Thickness = 1
                    v2959.Transparency = .6
                    return v2959
                else
                    v2958 = nil
                    return v2958
                end
            end
            local up221 = spilledValues1.value36
            local up222 = spilledValues1.value37
            local up223 = spilledValues1.value38
            local up220 = {}
            spilledValues1.value40 = up219()
            local up224 = spilledValues1.value40
            spilledValues1.value41 = up219()
            local up225 = spilledValues1.value41
            if up225 then
                spilledValues1.value41 = up225
                spilledValues1.value44 = Color3.fromRGB(255, 215, 0)
                spilledValues1.value41.Color = spilledValues1.value44
                spilledValues1.value41 = up225
                spilledValues1.value41.Thickness = 1
                spilledValues1.value41 = up225
                spilledValues1.value41.Transparency = 0.5
            end
            spilledValues1.value42 = {"Head", "UpperTorso"}
            spilledValues1.value43 = {"UpperTorso", "LowerTorso"}
            spilledValues1.value44 = {"UpperTorso", "LeftUpperArm"}
            spilledValues1.value45 = {"LeftUpperArm", "LeftLowerArm"}
            spilledValues1.value46 = {"LeftLowerArm", "LeftHand"}
            spilledValues1.value47 = {"UpperTorso", "RightUpperArm"}
            spilledValues1.value48 = {"RightUpperArm", "RightLowerArm"}
            spilledValues1.value49 = {"RightLowerArm", "RightHand"}
            spilledValues1.value50 = {"LowerTorso", "LeftUpperLeg"}
            spilledValues1.value51 = {"LeftUpperLeg", "LeftLowerLeg"}
            spilledValues1.value52 = {"LeftLowerLeg", "LeftFoot"}
            spilledValues1.value53 = {"LowerTorso", "RightUpperLeg"}
            spilledValues1.value54 = {"RightUpperLeg", "RightLowerLeg"}
            spilledValues1.value55 = {"RightLowerLeg", "RightFoot"}
            spilledValues1.value56 = {"Head", "Torso"}
            spilledValues1.value57 = {"Torso", "Left Arm"}
            spilledValues1.value58 = {"Torso", "Right Arm"}
            spilledValues1.value59 = {"Torso", "Left Leg"}
            spilledValues1.value60 = {"Torso", "Right Leg"}
            local up226 = {spilledValues1.value42, spilledValues1.value43, spilledValues1.value44, spilledValues1.value45, spilledValues1.value46, spilledValues1.value47, spilledValues1.value48, spilledValues1.value49, spilledValues1.value50, spilledValues1.value51, spilledValues1.value52, spilledValues1.value53, spilledValues1.value54, spilledValues1.value55, spilledValues1.value56, spilledValues1.value57, spilledValues1.value58, spilledValues1.value59, spilledValues1.value60}
            spilledValues1.value41 = task.spawn
            spilledValues1.value44 = function()
                local v1722, v1723, v1724, v1725, v1730
                local v1721 = 0
                while true do
                    v1722 = tick()
                    v1723 = (v1722 - v1721)
                    v1724 = _G
                    v1721 = v1722
                    if v1724["ScriptUnloaded"] then
                        break
                    else
                        v1730 = game.Players
                        local up69 = v1730.LocalPlayer
                        if up69 then
                            v1725 = function()
                                local v1615, v1617, v1618, v1619, v1620, v1621, v1622, v1623, v1624, v1625, v1626, v1629, v1630, v1631, v1632, v1633
                                local v1634, v1636
                                local v1610 = game.Players:GetPlayers()
                                local v1612 = up69.Character
                                local v1611 = v1612
                                if v1612 then
                                    v1611 = (v1612:FindFirstChild("HumanoidRootPart"))
                                end
                                local v1613 = v1611
                                local v1616 = v1613 and v1613.Position
                                if not (v1616) then
                                    v1616 = workspace.CurrentCamera.CFrame.Position
                                end
                                v1611 = _G
                                if v1611["PlayerChamsActive"] then
                                    v1611, v1617, v1618 = ipairs(v1610)
                                    v1622 = v1611
                                    while true do
                                        v1618, v1620 = v1622(v1617, v1618)
                                        if not v1618 then
                                            break
                                        end
                                        v1621 = (v1620 ~= up69) and v1620.Character
                                        if v1621 then
                                            v1621 = v1620.Character
                                            v1623 = (v1621:FindFirstChildOfClass("Humanoid"))
                                            v1615 = v1621:FindFirstChild("PlayerChams")
                                            v1625 = v1623
                                            v1624 = v1615
                                            if v1623 then
                                                v1625 = (v1623.Health > 0)
                                            end
                                            if v1625 then
                                                v1625 = up186(v1620)
                                                v1626 = Color3.fromRGB(30, 220, 80)
                                                if (v1625 == "Murderer") then
                                                    v1626 = (Color3.fromRGB(255, 30, 30))
                                                else
                                                    v1631 = (v1625 == "Sheriff") or (v1625 == "Hero")
                                                    if v1631 then
                                                        v1626 = (Color3.fromRGB(30, 120, 255))
                                                    end
                                                end
                                                if (not v1624) then
                                                    v1624 = (Instance.new("Highlight"))
                                                    v1624.Name = "PlayerChams"
                                                    v1629 = Enum.HighlightDepthMode.AlwaysOnTop
                                                    v1624.DepthMode = v1629
                                                    v1624.Parent = v1621
                                                end
                                                v1624.Enabled = true
                                                v1624.FillColor = v1626
                                                v1624.OutlineColor = v1626
                                                v1632 = _G.ChamsFillTransparency
                                                v1624.FillTransparency = (v1632 or 0.5)
                                                v1624.OutlineTransparency = 0
                                            else
                                                if v1624 then
                                                    v1624.Enabled = false
                                                end
                                            end
                                        end
                                    end
                                    v1618 = _G
                                    if v1618["CachedGunDrop"] then
                                        v1618 = _G.CachedGunDrop:FindFirstChild("GunChams")
                                        if (not v1618) then
                                            v1618 = (Instance.new("Highlight"))
                                            v1618.Name = "GunChams"
                                            v1619 = _G.CachedGunDrop
                                            v1618.Parent = v1619
                                        end
                                        v1618.Enabled = true
                                        v1617 = "FillColor"
                                        v1624 = _G.VisualsRainbow
                                        v1621 = v1624
                                        if v1624 then
                                            v1621 = _G.RainbowColor
                                        end
                                        v1619 = v1621
                                        if not (v1621) then
                                            v1619 = (Color3.fromRGB(0, 255, 255))
                                        end
                                        v1618[v1617] = v1619
                                        v1620 = Color3.fromRGB(255, 255, 255)
                                        v1618.OutlineColor = v1620
                                        v1618.FillTransparency = .2
                                        v1618.OutlineTransparency = 0
                                        v1619 = Enum.HighlightDepthMode.AlwaysOnTop
                                        v1618.DepthMode = v1619
                                    end
                                else
                                    for v1620, v1621 in ipairs(v1610) do
                                        if v1621["Character"] then
                                            v1624 = v1621.Character:FindFirstChild("PlayerChams")
                                            if v1624 then
                                                v1624.Enabled = false
                                            end
                                        end
                                    end
                                    v1618 = _G
                                    if v1618["CachedGunDrop"] then
                                        v1618 = _G.CachedGunDrop:FindFirstChild("GunChams")
                                        if v1618 then
                                            v1618.Enabled = false
                                        end
                                    end
                                end
                                v1617 = up69.Character
                                v1618 = v1617 and (v1617:FindFirstChild("Humanoid"))
                                v1621 = _G.AutoGetGun
                                v1619 = v1621
                                if v1621 then
                                    v1624 = _G.CachedGunDrop
                                    v1621 = v1624
                                    if v1624 then
                                        v1632 = _G.IgnoredGuns
                                        v1629 = v1632
                                        if v1632 then
                                            v1629 = _G.IgnoredGuns[_G.CachedGunDrop]
                                        end
                                        v1626 = (not v1629)
                                        v1624 = v1626
                                        if v1626 then
                                            v1630 = (not _G.IsCollectingGun)
                                            v1626 = v1630
                                            if v1630 then
                                                v1633 = (not (up188()))
                                                v1630 = v1633
                                                if v1633 then
                                                    v1630 = v1618 and (v1618.Health > 0)
                                                end
                                                v1626 = v1630
                                            end
                                            v1624 = v1626
                                        end
                                        v1621 = v1624
                                    end
                                    v1619 = v1621
                                end
                                if v1619 then
                                    v1621 = _G
                                    v1619 = true
                                    if v1621["SafeAutoCollect"] then
                                        v1626 = _G.CachedGunDrop:IsA("Model")
                                        v1623 = v1626
                                        if v1626 then
                                            v1623 = _G.CachedGunDrop :GetPivot().Position
                                        end
                                        v1620 = v1623
                                        if not (v1623) then
                                            v1620 = _G.CachedGunDrop.Position
                                        end
                                        for v1625, v1626 in ipairs(v1610) do
                                            v1632 = (v1626 ~= up69)
                                            v1629 = v1632
                                            if v1632 then
                                                v1634 = ((up186(v1626)) == "Murderer")
                                                v1632 = v1634
                                                if v1634 then
                                                    v1636 = v1626.Character
                                                    v1634 = v1636
                                                    if v1636 then
                                                        v1634 = (v1626.Character:FindFirstChild("HumanoidRootPart"))
                                                    end
                                                    v1632 = v1634
                                                end
                                                v1629 = v1632
                                            end
                                            if v1629 then
                                                v1632 = (v1626.Character.HumanoidRootPart.Position - v1620)
                                                if (v1632["Magnitude"] < 35) then
                                                    v1619 = false
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    if v1619 then
                                        task.spawn(up187)
                                    end
                                end
                                return
                            end
                            pcall(v1725)
                            v1725 = function()
                                local v1644, v1646, v1647, v1648, v1650, v1652
                                local v1643
                                v1644, v1646, v1647 = ipairs(allPlayers)
                                local v1645 = v1644
                                while true do
                                    v1647, v1648 = v1645(v1646, v1647)
                                    if not v1647 then
                                        break
                                    end
                                    v1650 = up186(v1648)
                                    if (v1650 == "Murderer") then
                                        v1643 = v1648
                                    else
                                        continue
                                    end
                                    break
                                end
                                v1646 = v1643 and v1643.Character
                                if v1646 then
                                    v1647 = v1643.Character:FindFirstChild("Head")
                                    v1645 = v1647 and (v1647.Transparency > .8)
                                    if v1645 then
                                        v1648 = _G
                                        if (not v1648["InternalGhostState"]) then
                                            v1645 = _G
                                            v1645.InternalGhostState = true
                                            v1645 = up179
                                            v1652 = (v1643.Name .. " ACTIVATED GHOST!")
                                            v1645:Notify({["Title"] = "⚠️ MURDERER ALERT", ["Content"] = v1652, ["Duration"] = 5})
                                            _G.PlayUISound()
                                        end
                                    else
                                        v1645 = _G
                                        v1645.InternalGhostState = false
                                    end
                                end
                                return
                            end
                            pcall(v1725)
                            task.wait(.1)
                        end
                    end
                end
                return
            end
            spilledValues1.value41(spilledValues1.value44)
            spilledValues1.value43 = function(arg138_1)
                local v1731
                local up70 = arg138_1
                if (not up70) then
                    return
                else
                    v1731 = function()
                        local v2317, v2318, v2321, v2323
                        local v2315 = up70
                        v2315.Visible = false
                        local v2319 = up70
                        if v2319["Head"] then
                            v2315 = up70.Head
                            v2315.Visible = false
                        end
                        v2319 = up70
                        if v2319["Box"] then
                            v2315 = up70.Box
                            v2315.Visible = false
                            v2315 = up70.Box
                            v2317 = Vector2.new(-1000, -1000)
                            v2315.Position = v2317
                            v2315 = up70.Box
                            v2317 = Vector2.new(0, 0)
                            v2315.Size = v2317
                        end
                        v2319 = up70
                        if v2319["Tracer"] then
                            v2315 = up70.Tracer
                            v2315.Visible = false
                        end
                        v2319 = up70
                        if v2319["NameText"] then
                            v2315 = up70.NameText
                            v2315.Visible = false
                            v2315 = up70.NameText
                            v2317 = Vector2.new(-1000, -1000)
                            v2315.Position = v2317
                        end
                        v2319 = up70
                        if v2319["PowerText"] then
                            v2315 = up70.PowerText
                            v2315.Visible = false
                            v2315 = up70.PowerText
                            v2317 = Vector2.new(-1000, -1000)
                            v2315.Position = v2317
                        end
                        v2319 = up70
                        if v2319["DistText"] then
                            v2315 = up70.DistText
                            v2315.Visible = false
                            v2315 = up70.DistText
                            v2317 = Vector2.new(-1000, -1000)
                            v2315.Position = v2317
                        end
                        v2319 = up70
                        if v2319["Lines"] then
                            for v2317, v2321 in pairs(up70.Lines) do
                                if v2321 then
                                    v2321.Visible = false
                                end
                            end
                        end
                        local v2316 = up70
                        if v2316["Corners"] then
                            v2315 = pairs
                            v2321 = up70
                            for v2318, v2321 in v2315(v2321.Corners) do
                                if v2321 then
                                    v2321.Visible = false
                                    v2323 = Vector2.new(-1000, -1000)
                                    v2321.From = v2323
                                    v2323 = Vector2.new(-1000, -1000)
                                    v2321.To = v2323
                                end
                            end
                        end
                        return
                    end
                    pcall(v1731)

                    return
                end
            end
            local up227 = spilledValues1.value43
            spilledValues1.value44 = _G
            if spilledValues1.value44["ESPConnection"] then
                _G.ESPConnection:Disconnect()
            end
            spilledValues1.value44 = function()
                local v573, v576, v577, v578, v579, v580, v587, v588, v589
                v573, v576, v577 = pairs(up220)
                local v575 = v573
                while true do
                    v577, v578 = v575(v576, v577)
                    if not v577 then
                        break
                    end
                    v579 = function(arg256_1)
                        local up137 = arg256_1
                        if up137 then
                            pcall(function()
                                up137:Remove()
                                return
                            end)
                        end
                        return
                    end
                    v587, v588, v589 = pairs(v578.Lines or {})
                    while true do
                        v589, v580 = v587(v588, v589)
                        if not v589 then
                            break
                        end
                        v579(v580)
                    end
                    v580 = pairs
                    for v589, v580 in v580(v578.Corners or {}) do
                        v579(v580)
                    end
                    v579(v578.Head)
                    v579(v578.Tracer)
                    v579(v578.DistText)
                    v579(v578.NameText)
                    v579(v578.PowerText)
                    v579(v578.Box)
                end
                up220 = {}
                if up224 then
                    v575 = function()
                        up224:Remove()
                        return
                    end
                    pcall(v575)
                end
                if up225 then
                    v575 = function()
                        up225:Remove()
                        return
                    end
                    pcall(v575)
                end
                return
            end
            local up228 = spilledValues1.value44
            spilledValues1.value45 = _G
            spilledValues1.value47 = v3737.RenderStepped
            spilledValues1.value49 = function()
                local v591, v592, v593, v594, v595, v596, v597, v598, v599, v600, v601, v602, v603, v604, v605, v606
                local v607, v608, v609, v610, v611, v612, v613
                local v614, v615, v616, v618, v619, v620, v621, v622, v623, v624, v625, v626, v627, v628, v629, v630
                local v631, v632, v633, v634, v635, v636, v637
                local v638, v639, v640, v642, v643, v644, v645
                local v590 = _G
                if v590["ScriptUnloaded"] then
                    up228()
                    v590 = _G
                    if v590["ESPConnection"] then
                        _G.ESPConnection:Disconnect()
                    end
                    return
                else
                    v590 = _G
                    if v590["StealthMode"] then
                        up228()
                        return
                    else
                        v591 = _G.NamesESP
                        v590 = v591
                        if not (v591) then
                            v590 = _G.BoxESP
                        end
                        if (not v590) then
                            for v591, v596 in pairs(up220) do
                                up227(v596)
                            end
                            return
                        else
                            v595 = workspace.CurrentCamera
                            v591 = v595.ViewportSize
                            v592 = Vector2.new((v591.X / 2), v591.Y )
                            v594 = pairs
                            v598 = up220
                            for v597, v599 in v594(v598) do
                                local up31 = v599
                                v598 = v597
                                v600 = (not v598) or (not v598.Parent)
                                if v600 then
                                    up227(up31)
                                    v601 = function()
                                        local v3412, v3415, v3422
                                        local v3411 = up31
                                        if v3411["Head"] then
                                            up31.Head:Remove()
                                        end
                                        v3411 = up31
                                        if v3411["Box"] then
                                            up31.Box:Remove()
                                        end
                                        v3411 = up31
                                        if v3411["NameText"] then
                                            up31.NameText:Remove()
                                        end
                                        v3411 = up31
                                        if v3411["PowerText"] then
                                            up31.PowerText:Remove()
                                        end
                                        v3411 = up31
                                        if v3411["DistText"] then
                                            up31.DistText:Remove()
                                        end
                                        v3411 = up31
                                        if v3411["Tracer"] then
                                            up31.Tracer:Remove()
                                        end
                                        v3411, v3415, v3412 = pairs(up31.Lines or {})
                                        local v3413 = v3411
                                        while true do
                                            v3412, v3422 = v3413(v3415, v3412)
                                            if not v3412 then
                                                break
                                            end
                                            v3422:Remove()
                                        end
                                        v3422 = pairs
                                        for v3413, v3422 in v3422(up31.Corners or {}) do
                                            v3422:Remove()
                                        end
                                        return
                                    end
                                    pcall(v601)
                                    v594 = up220
                                    v594[v598] = nil
                                end
                                v599 = nil
                            end
                            v593 = game.Players.LocalPlayer
                            v596 = v595.CFrame.Position
                            v598 = v593.Character
                            v597 = v598
                            if v598 then
                                v597 = (v593.Character:FindFirstChild("HumanoidRootPart"))
                            end
                            v598, v599, v600 = ipairs(game.Players:GetPlayers())
                            while true do
                                v600, v606 = v598(v599, v600)
                                if not v600 then
                                    break
                                end
                                if (v606 ~= v593) then
                                    v605 = up220[v606]
                                    if (not v605) then
                                        v603 = {}
                                        v608 = {}
                                        v610 = up221()
                                        v612 = up222()
                                        v614 = up222()
                                        v616 = up222()
                                        v618 = up223()
                                        v620 = up219()
                                        v605 = {["Lines"] = v603, ["Corners"] = v608, ["Head"] = v610, ["DistText"] = v612, ["NameText"] = v614, ["PowerText"] = v616, ["Box"] = v618, ["Tracer"] = v620}
                                        v604 = (#up226)
                                        v608 = 1
                                        for v603 = 1, v604, v608 do
                                            v609 = v605.Lines
                                            v611 = up219()
                                            v609[v603] = v611
                                        end
                                        v604 = 8
                                        v608 = 1
                                        for v603 = 1, v604, v608 do
                                            v609 = v605.Corners
                                            v611 = up219()
                                            v609[v603] = v611
                                        end
                                        v602 = up220
                                        v602[v606] = v605
                                    end
                                    v602 = v606.Character
                                    v603 = v602
                                    if v602 then
                                        v603 = (v602:FindFirstChild("HumanoidRootPart"))
                                    end
                                    v604 = v602
                                    if v602 then
                                        v604 = (v602:FindFirstChildOfClass("Humanoid"))
                                    end
                                    v608 = v602
                                    if v602 then
                                        v609 = v603
                                        if v603 then
                                            v609 = v604 and (v604.Health > 0)
                                        end
                                        v608 = v609
                                    end
                                    Vector3.new()
                                    v607 = false
                                    v610 = 0
                                    if v608 then
                                        v613 = v603.Position
                                        v622, v623 = v595:WorldToViewportPoint(v613)
                                        v607 = v623
                                        v610 = (v596 - v603.Position ).Magnitude
                                    end
                                    v614 = v608
                                    if v608 then
                                        v614 = v607 and (v610 <= 1200)
                                    end
                                    if v614 then
                                        v615 = up186(v606)
                                        v616 = Color3.fromRGB(30, 220, 80)
                                        if (v615 == "Murderer") then
                                            v616 = (Color3.fromRGB(255, 30, 30))
                                        else
                                            v614 = (v615 == "Sheriff") or (v615 == "Hero")
                                            if v614 then
                                                v616 = (Color3.fromRGB(30, 120, 255))
                                            end
                                        end
                                        v619 = _G
                                        if v619["NamesESP"] then
                                            v614 = v602:FindFirstChild("Head")
                                            v625 = v614
                                            if v614 then
                                                v625 = (v614.Position + (Vector3.new(0, 2.5, 0)))
                                            end
                                            v621 = v625
                                            if not (v625) then
                                                v621 = (v603.Position + (Vector3.new(0, 4, 0)))
                                            end
                                            v619, v620 = v595:WorldToViewportPoint(v621)
                                            v621 = v620 and (v619.Z > 0)
                                            if v621 then
                                                v621 = v605.NameText
                                                v625 = v606.DisplayName or v606.Name
                                                v621.Text = v625
                                                v621 = v605.NameText
                                                v634 = Vector2.new(v619.X, v619.Y)
                                                v621.Position = v634
                                                v621 = v605.NameText
                                                v621.Visible = true
                                                if (v615 == "Murderer") then
                                                    v621 = ""
                                                    v624 = v602:GetChildren()
                                                    v634, v633, v630 = ipairs(v624)
                                                    while true do
                                                        v630, v629 = v634(v633, v630)
                                                        if not v630 then
                                                            break
                                                        end
                                                        v628 = v629:IsA("Tool")
                                                        v626 = v628
                                                        if v628 then
                                                            v632 = (v629.Name == "Ghost")
                                                            v628 = v632
                                                            if not (v632) then
                                                                v636 = (v629.Name == "Trap")
                                                                v632 = v636
                                                                if not (v636) then
                                                                    v638 = (v629.Name == "Decoy")
                                                                    v636 = v638
                                                                    if not (v638) then
                                                                        v636 = (v629.Name == "Fake Gun")
                                                                    end
                                                                    v632 = v636
                                                                end
                                                                v628 = v632
                                                            end
                                                            v626 = v628
                                                        end
                                                        if v626 then
                                                            v621 = v629.Name
                                                        else
                                                            continue
                                                        end
                                                        break
                                                    end
                                                    if (v621 ~= "") then
                                                        v625 = v605.PowerText
                                                        v625.Text = ("[" .. (v621 .. "]"))
                                                        v625 = v605.PowerText
                                                        v630 = Vector2.new(v619.X, (v619.Y + 14))
                                                        v625.Position = v630
                                                        v625 = v605.PowerText
                                                        v625.Visible = true
                                                    else
                                                        v625 = v605.PowerText
                                                        v625.Visible = false
                                                    end
                                                else
                                                    v621 = v605.PowerText
                                                    v621.Visible = false
                                                end
                                            else
                                                v621 = v605.NameText
                                                v621.Visible = false
                                                v621 = v605.PowerText
                                                v621.Visible = false
                                            end
                                        else
                                            v614 = v605.NameText
                                            v614.Visible = false
                                            v614 = v605.PowerText
                                            v614.Visible = false
                                        end
                                        v619 = _G
                                        if v619["BoxESP"] then
                                            v614 = v602:FindFirstChild("HumanoidRootPart")
                                            v619 = v602:FindFirstChild("Head")
                                            v620 = (v614 and v619)
                                            if v620 then
                                                v620 = v619.Position
                                                v621 = v614.Position
                                                v625 = Vector3.new(v621.X, (v620.Y + 0.5), v621.Z)
                                                v634 = Vector3.new(v621.X, (v621.Y - 3), v621.Z)
                                                v624, v633 = v595:WorldToViewportPoint(v625)
                                                v644, v645 = v595:WorldToViewportPoint(v634)
                                                v630 = v644
                                                v627 = (v624.Z > 0) and (v630.Z > 0)
                                                if v627 then
                                                    v628 = math.abs((v624.Y - v630.Y))
                                                    v627 = (v628 / 1.7)
                                                    v631 = (v624.X - (v627 / 2))
                                                    v632 = v624.Y
                                                    v636 = _G.BoxStyle
                                                    if (v636 == "Corners") then
                                                        v635 = (v627 / 4)
                                                        v636 = v605.Corners
                                                        v637 = v636[1]
                                                        v639 = v636[1]
                                                        v642 = Vector2.new(v631, v632)
                                                        v643 = Vector2.new((v631 + v635), v632)
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[2]
                                                        v639 = v636[2]
                                                        v642 = Vector2.new(v631, v632)
                                                        v643 = Vector2.new(v631, (v632 + v635))
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[3]
                                                        v639 = v636[3]
                                                        v642 = Vector2.new((v631 + v627), v632)
                                                        v643 = Vector2.new(((v631 + v627) - v635), v632)
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[4]
                                                        v639 = v636[4]
                                                        v642 = Vector2.new((v631 + v627), v632)
                                                        v643 = Vector2.new((v631 + v627), (v632 + v635))
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[5]
                                                        v639 = v636[5]
                                                        v642 = Vector2.new(v631, (v632 + v628))
                                                        v643 = Vector2.new((v631 + v635), (v632 + v628))
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[6]
                                                        v639 = v636[6]
                                                        v642 = Vector2.new(v631, (v632 + v628))
                                                        v643 = Vector2.new(v631, ((v632 + v628) - v635))
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[7]
                                                        v639 = v636[7]
                                                        v642 = Vector2.new((v631 + v627), (v632 + v628))
                                                        v643 = Vector2.new(((v631 + v627) - v635), (v632 + v628))
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v637 = v636[8]
                                                        v639 = v636[8]
                                                        v642 = Vector2.new((v631 + v627), (v632 + v628))
                                                        v643 = Vector2.new((v631 + v627), ((v632 + v628) - v635))
                                                        v637.From = v642
                                                        v639.To = v643
                                                        v639 = 8
                                                        v640 = 1
                                                        for v638 = 1, v639, v640 do
                                                            v642 = v636[v638]
                                                            v642.Color = v616
                                                            v642 = v636[v638]
                                                            v642.Visible = true
                                                        end
                                                        v637 = v605.Box
                                                        v637.Visible = false
                                                    else
                                                        v637 = 8
                                                        v638 = 1
                                                        for v636 = 1, v637, v638 do
                                                            v640 = v605.Corners [v636]
                                                            v640.Visible = false
                                                        end
                                                        v635 = v605.Box
                                                        v638 = Vector2.new(v627, v628)
                                                        v635.Size = v638
                                                        v635 = v605.Box
                                                        v638 = Vector2.new(v631, v632)
                                                        v635.Position = v638
                                                        v635 = v605.Box
                                                        v635.Color = v616
                                                        v635 = v605.Box
                                                        v635.Visible = true
                                                    end
                                                else
                                                    v627 = v605.Box
                                                    v627.Visible = false
                                                    v631 = 8
                                                    v632 = 1
                                                    for v628 = 1, v631, v632 do
                                                        v636 = v605.Corners [v628]
                                                        v636.Visible = false
                                                    end
                                                end
                                            else
                                                v620 = v605.Box
                                                v620.Visible = false
                                                v624 = 8
                                                v625 = 1
                                                for v621 = 1, v624, v625 do
                                                    v633 = v605.Corners [v621]
                                                    v633.Visible = false
                                                end
                                            end
                                        else
                                            v614 = v605.Box
                                            v614.Visible = false
                                            v620 = 8
                                            v621 = 1
                                            for v619 = 1, v620, v621 do
                                                v625 = v605.Corners [v619]
                                                v625.Visible = false
                                            end
                                        end
                                    else
                                        up227(v605)
                                    end
                                end
                            end
                            v600 = _G.AutoCoinV3
                            v598 = v600
                            if v600 then
                                v606 = _G.TargetCoin
                                v600 = v606
                                if v606 then
                                    v600 = _G.TargetCoin.Parent and up225
                                end
                                v598 = v600
                            end
                            if v598 then
                                v600 = _G.TargetCoin.Position
                                v598, v599 = v595:WorldToViewportPoint(v600)
                                v600 = v592
                                v601 = true
                                if v597 then
                                    v602 = v597.Position
                                    v606, v605 = v595:WorldToViewportPoint(v602)
                                    v603 = Vector2.new(v606.X, v606.Y)
                                    v601 = v605
                                    v600 = v603
                                end
                                v606 = (v599 and v601)
                                if v606 then
                                    v606 = up225
                                    v606.From = v600
                                    v606 = up225
                                    v608 = Vector2.new(v598.X, v598.Y)
                                    v606.To = v608
                                    v606 = up225
                                    v606.Visible = true
                                else
                                    v606 = up225
                                    v606.Visible = false
                                end
                            else
                                if up225 then
                                    v598 = up225
                                    v598.Visible = false
                                end
                            end
                            return
                        end
                    end
                end
            end
            spilledValues1.value48 = spilledValues1.value47:Connect(spilledValues1.value49)
            spilledValues1.value45.ESPConnection = spilledValues1.value48
            spilledValues1.value45 = game.Players .PlayerRemoving
            spilledValues1.value47 = function(arg35_1)
                local v651, v652, v653, v654, v660, v661, v662, v663
                local v650 = arg35_1
                if up220[v650] then
                    v653 = up220[v650]
                    up227(v653)
                    v654 = function(arg152_1)
                        local v1870
                        local up84 = arg152_1
                        if up84 then
                            v1870 = function()
                                up84:Remove()
                                return
                            end
                            pcall(v1870)
                        end
                        return
                    end
                    v651, v662, v663 = pairs(v653.Lines or {})
                    v661 = v651
                    while true do
                        v663, v660 = v661(v662, v663)
                        if not v663 then
                            break
                        end
                        v654(v660)
                    end
                    v660 = pairs
                    for v661, v660 in v660(v653.Corners or {}) do
                        v654(v660)
                    end
                    v654(v653.Head)
                    v654(v653.Tracer)
                    v654(v653.DistText)
                    v654(v653.NameText)
                    v654(v653.PowerText)
                    v654(v653.Box)
                    v652 = up220
                    v652[v650] = nil
                end
                return
            end
            spilledValues1.value45:Connect(spilledValues1.value47)
            spilledValues1.value45 = game
            spilledValues1.value46 = spilledValues1.value45:GetService("UserInputService")
            local up229 = true
            local up231
            local up230
            spilledValues1.value51 = game:GetService("TweenService")
            local up232 = spilledValues1.value51
            spilledValues1.value52 = function()
                local v668, v670, v671, v672, v673, v674, v675, v677, v678, v679, v682, v684
                up229 = (not up229)
                local v669 = gethui and (gethui())
                local v665 = v669
                if not (v669) then
                    v670 = game:GetService("CoreGui")
                    v669 = v670
                    if not (v670) then
                        v669 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                    end
                    v665 = v669
                end
                v669 = (v665:FindFirstChild("Fluent"))
                v665 = v669
                if v669 then
                    v665 = (v669:FindFirstChild("Main"))
                end
                local up32 = v665
                if up32 then
                    v670 = up231
                    v665 = v670
                    if not (v670) then
                        v665 = up32.Size
                    end
                    up231 = v665
                    v668 = (up32:FindFirstChild("CanvasGroup")) or up32
                    if up230 then
                        up230:Cancel()
                    end
                    if up229 then
                        v670 = up32
                        v670.Visible = true
                        v670 = up32
                        v672 = UDim2.fromOffset((up231.X.Offset * .7), (up231.Y.Offset * .7))
                        v670.Size = v672
                        v670 = v668:IsA("CanvasGroup")
                        if v670 then
                            v668.GroupTransparency = 1
                        end
                        v670 = up232
                        v671 = up32
                        v672 = TweenInfo.new
                        v677 = Enum.EasingStyle.Quart
                        v682 = Enum.EasingDirection
                        v674 = v670.Create
                        v673 = v672(.6, v677, v682.Out)
                        v677 = up231
                        v674 = v674(v670, v671, v673, {["Size"] = v677})
                        up230 = v674
                        up230:Play()
                        v670 = v668:IsA("CanvasGroup")
                        if v670 then
                            v670 = up232
                            v673 = TweenInfo.new(0.5)
                            v672 = {["GroupTransparency"] = 0}
                            v670:Create(v668, v673, v672):Play()
                        end
                    else
                        v670 = up232
                        v672 = up32
                        v675 = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
                        v678 = UDim2.fromOffset
                        v679 = (up231.X.Offset * .7)
                        v684 = up231
                        v671 = v670.Create
                        v682 = v678(v679, (v684.Y.Offset * .7))
                        v671 = v671(v670, v672, v675, {["Size"] = v682})
                        up230 = v671
                        up230:Play()
                        v670 = v668:IsA("CanvasGroup")
                        if v670 then
                            v670 = up232
                            v675 = TweenInfo.new(.4)
                            v673 = {["GroupTransparency"] = 1}
                            v670:Create(v668, v675, v673):Play()
                        end
                        local up33
                        v670 = up230.Completed
                        v675 = function()
                            local v848
                            if (not up229) then
                                v848 = up32
                                v848.Visible = false
                            end
                            up33:Disconnect()
                            return
                        end
                        up33 = (v670:Connect(v675))
                    end
                end
                v670 = game:GetService("UserInputService")
                v670.MouseIconEnabled = true
                return
            end
            local up233 = spilledValues1.value52
            spilledValues1.value52 = _G
            spilledValues1.value52.StealthMode = false
            spilledValues1.value53 = function()
                local v695, v696, v697, v698, v699, v700, v701, v702
                local v690 = _G
                local v692 = _G.StealthMode
                v690.StealthMode = (not v692)
                local v691 = gethui and (gethui())
                local v689 = v691
                if not (v691) then
                    v697 = game:GetService("CoreGui")
                    v691 = v697
                    if not (v697) then
                        v691 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                    end
                    v689 = v691
                end
                v691 = v689
                v692 = v691:FindFirstChild("Fluent")
                if v692 then
                    v689 = (not _G.StealthMode)
                    v692.Enabled = v689
                end
                local v693 = v691:FindFirstChild("MM2MenuBtnGui")
                if v693 then
                    v689 = (not _G.StealthMode)
                    v693.Enabled = v689
                end
                v697 = (v691:FindFirstChild("VelonexSpectators"))
                if v697 then
                    v689 = (not _G.StealthMode)
                    v697.Enabled = v689
                end
                local v694 = (v691:FindFirstChild("MM2PremiumKey"))
                if v694 then
                    v689 = (not _G.StealthMode)
                    v694.Enabled = v689
                end
                v689 = _G
                if v689["StealthMode"] then
                    up228()
                    v695 = _G.CachedGunDrop
                    v689 = v695
                    if v695 then
                        v689 = (_G.CachedGunDrop:FindFirstChild("GunChams"))
                    end
                    if v689 then
                        v690 = _G.CachedGunDrop.GunChams
                        v690.Enabled = false
                    end
                    v690 = pairs
                    v698 = game.Players
                    v700 = v698.GetPlayers
                    for v696, v700 in v690(v700(v698)) do
                        v702 = v700.Character
                        v701 = v702
                        if v702 then
                            v701 = (v700.Character:FindFirstChild("PlayerChams"))
                        end
                        if v701 then
                            v690 = v700.Character.PlayerChams
                            v690.Enabled = false
                        end
                    end
                else
                    v690 = pairs
                    v700 = game
                    v699 = v700.Players
                    v701 = v699.GetPlayers
                    for v698, v700 in v690(v701(v699)) do
                        v702 = v700.Character
                        v701 = v702
                        if v702 then
                            v701 = (v700.Character:FindFirstChild("PlayerChams"))
                        end
                        if v701 then
                            v690 = v700.Character.PlayerChams
                            v702 = (_G.PlayerChamsActive or false)
                            v690.Enabled = v702
                        end
                    end
                end
                v695 = v691:FindFirstChild("BottomLeftNotifGui")
                if v695 then
                    v698 = (not _G.StealthMode)
                    v695.Enabled = v698
                end
                v696 = v691:FindFirstChild("TopNotifGui")
                if v696 then
                    v699 = (not _G.StealthMode)
                    v696.Enabled = v699
                end
                v700 = function()
                    local v262 = _G
                    if v262["PlayUISound"] then
                        _G.PlayUISound()
                    end
                    return
                end
                pcall(v700)
                v699 = _G
                if v699["StealthMode"] then
                    v700 = function()
                        up179:Notify({["Title"] = "STEALTH ACTIVE", ["Content"] = "Press Delete again to restore.", ["Duration"] = 2.5})
                        return
                    end
                    pcall(v700)
                end
                return
            end
            local up234 = spilledValues1.value53
            spilledValues1.value53 = spilledValues1.value46.InputBegan
            spilledValues1.value55 = function(arg38_1, arg38_2)
                local v711, v719, v720
                local v710 = arg38_1
                if (not arg38_2) then
                    v719 = ((typeof(up196.MinimizeKey)) == "EnumItem")
                    v720 = v719
                    if v719 then
                        v720 = (v710.KeyCode == up196.MinimizeKey)
                    end
                    if v720 then
                        up233()
                    else
                        v720 = v710.KeyCode
                        v711 = Enum.KeyCode
                        if (v720 == v711["Delete"]) then
                            up234()
                        end
                    end
                end
                return
            end
            spilledValues1.value53:Connect(spilledValues1.value55)
            spilledValues1.value56 = function(arg39_1)
                local v727
                local v722 = arg39_1
                local v723 = v722.Backpack
                local v724 = v722.Character
                if v723 then
                    v727 = v723:FindFirstChild("Knife")
                    if v727 then
                        v727 = "Murder"
                        return v727
                    else
                        v727 = v723:FindFirstChild("Gun")
                        if v727 then
                            v727 = "Sheriff"
                            return v727
                        end
                    end
                end
                if v724 then
                    v727 = v724:FindFirstChild("Knife")
                    if v727 then
                        v727 = "Murder"
                        return v727
                    else
                        v727 = v724:FindFirstChild("Gun")
                        if v727 then
                            v727 = "Sheriff"
                            return v727
                        end
                    end
                end
                local v726 = v722:GetAttribute("Alive")
                if (v726 == false) then
                    v727 = "Dead"
                    return v727
                else
                    v727 = "Innocent"
                    return v727
                end
            end
            local up235
            local up236
            local up237 = spilledValues1.value56
            spilledValues1.value57 = RaycastParams.new()
            local up238 = spilledValues1.value57
            spilledValues1.value57 = up238
            spilledValues1.value59 = Enum.RaycastFilterType.Exclude
            spilledValues1.value57.FilterType = spilledValues1.value59
            spilledValues1.value57 = up238
            spilledValues1.value61 = function()
                local v733
                local v736 = game.Players.LocalPlayer.Backpack
                local v738 = game.Players.LocalPlayer.Character
                local v737 = up237
                local v731 = v738
                local v735 = v737(game.Players.LocalPlayer)
                if (v735 == "Murder") then
                    v737 = v736
                    if v736 then
                        v737 = (v736:FindFirstChild("Knife"))
                    end
                    if v737 then
                        v738 = v736:FindFirstChild("Knife")
                        v735 = "KnifeThrown"
                        v733 = v738.FindFirstChild
                        return v733(v738, v735, true)
                    else
                        v737 = v731
                        if v731 then
                            v737 = (v731:FindFirstChild("Knife"))
                        end
                        if v737 then
                            v738 = v731:FindFirstChild("Knife")
                            v735 = "KnifeThrown"
                            v733 = v738.FindFirstChild
                            return v733(v738, v735, true)
                        end
                    end
                else
                    v735 = up237(game.Players.LocalPlayer)
                    if (v735 == "Sheriff") then
                        v737 = v736
                        if v736 then
                            v737 = (v736:FindFirstChild("Gun"))
                        end
                        if v737 then
                            v738 = v736:FindFirstChild("Gun")
                            v735 = "Shoot"
                            v733 = v738.FindFirstChild
                            return v733(v738, v735, true)
                        else
                            v737 = v731
                            if v731 then
                                v737 = (v731:FindFirstChild("Gun"))
                            end
                            if v737 then
                                v738 = v731:FindFirstChild("Gun")
                                v735 = "Shoot"
                                v733 = v738.FindFirstChild
                                return v733(v738, v735, true)
                            end
                        end
                    end
                end
                return
            end
            spilledValues1.value57.IgnoreWater = true
            spilledValues1.value58 = function(arg41_1, arg41_2)
                local v745, v746, v747, v748, v749, v751, v752
                local v743 = arg41_2
                local v744 = arg41_1
                local v750 = game.Players.LocalPlayer.Character
                if (not v750) then
                    v752 = false
                    return v752
                else
                    v745 = {v750}
                    v749 = v744.Parent
                    v751 = v749
                    if v749 then
                        v748 = v744.Parent:FindFirstChild("HumanoidRootPart")
                        v749 = v748
                        if v748 then
                            v749 = (v744.Name ~= "HumanoidRootPart")
                        end
                        v751 = v749
                    end
                    if v751 then
                        table.insert(v745, v744.Parent.HumanoidRootPart)
                    end
                    v752 = up238
                    v752.FilterDescendantsInstances = v745
                    v749 = (v744.Position - v743.Position)
                    v752 = workspace
                    v746 = v743.Position
                    v747 = (v749.Unit * (v749.Magnitude + 1))
                    v748 = up238
                    v746 = (v752:Raycast(v746, v747, v748))
                    if v746 then
                        v747 = (v746.Instance:FindFirstAncestorWhichIsA("Model"))
                        v751 = v747
                        if v747 then
                            v751 = (game.Players:GetPlayerFromCharacter(v747))
                        end
                        if v751 then
                            v752 = true
                            return v752
                        else
                            v752 = false
                            return v752
                        end
                    else
                        v752 = true
                        return v752
                    end
                end
            end
            local up239 = spilledValues1.value58
            local up240
            spilledValues1.value60 = function()
                local v764, v766, v768, v769, v770, v771, v772, v773, v774, v775, v776, v777, v780, v781
                local v759 = math.huge
                local v761
                local v762 = workspace.CurrentCamera
                local v763 = (up237(game.Players.LocalPlayer))
                local v760 = (v763 == "Innocent") or (v763 == "Dead")
                if v760 then
                    v764 = nil
                    return v764
                else
                    v764 = pairs
                    v770 = game.Players
                    v768 = v770.GetPlayers
                    for v766, v768 in v764(v768(v770)) do
                        v771 = game.Players
                        if not ((v768 == v771["LocalPlayer"]))then
                            v769 = (up237(v768))
                            v781 = (v763 == "Sheriff")
                            v775 = v781
                            if v781 then
                                v775 = (v769 == "Innocent") or (v769 == "Dead")
                            end
                            if not (v775) then
                                v775 = (v763 == "Murder") and (v769 == "Dead")
                                if not (v775) then
                                    v771 = v768.Character
                                    if not ((not v771))then
                                        v772 = true
                                        v781 = (v763 == "Sheriff")
                                        v775 = v781
                                        if v781 then
                                            v775 = (_G.SilentAimSheriffVisible == false)
                                        end
                                        if v775 then
                                            v772 = false
                                        else
                                            v780 = (v763 == "Murder")
                                            v775 = v780
                                            if v780 then
                                                v775 = (_G.SilentAimMurdererVisible == false)
                                            end
                                            if v775 then
                                                v772 = false
                                            end
                                        end
                                        v776 = (up240(v771, v762, v772))
                                        if not ((not v776))then
                                            v777 = v776.Position
                                            v781, v780 = v762:WorldToViewportPoint(v777)
                                            v773 = v781
                                            v774 = v780
                                            if (v763 == "Murder") then
                                                v781 = (v776.Position - v762.CFrame.Position).Magnitude
                                                if (v781 < v759) then
                                                    v759 = v781
                                                    v761 = v776
                                                end
                                            else
                                                if v774 then
                                                    v781 = ((Vector2.new(v773.X, v773.Y )) - (v762.ViewportSize / 2)).Magnitude
                                                    if (v781 < v759) then
                                                        v761 = v776
                                                        v759 = v781
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    return v761
                end
            end
            up240 = function(arg43_1, arg43_2, arg43_3)
                local v800, v801
                local v789 = arg43_3
                local v791 = arg43_1
                local v795 = arg43_2
                local v796 = "Left Arm"
                local v799 = "Right Leg"
                local v790 = {"Head", "Torso", "UpperTorso", "LowerTorso", v796, "Right Arm", "Left Leg", v799}
                local v792 = v791:FindFirstChild("HumanoidRootPart")
                local v794 = v792
                if not (v792) then
                    v796 = v791:FindFirstChild("Head")
                    v792 = v796
                    if not (v796) then
                        v792 = (v791:FindFirstChildWhichIsA("BasePart"))
                    end
                    v794 = v792
                end
                local v803 = (not v789)
                v792 = v794
                if v803 then
                    return v792
                else
                    for v796, v799 in ipairs(v790) do
                        v800 = (v791:FindFirstChild(v799))
                        v801 = v800
                        if v800 then
                            v801 = (up239(v800, v795.CFrame))
                        end
                        if v801 then
                            return v800
                        end
                    end
                    v803 = nil
                    return v803
                end
            end
            local up241 = spilledValues1.value60
            local up242 = spilledValues1.value61
            spilledValues1.value61 = game:GetService("RunService").RenderStepped
            spilledValues1.value63 = function()
                local v811, v812, v813, v817, v818, v819, v820, v821, v822, v823, v824, v825, v827
                local v810 = _G
                if v810["ScriptUnloaded"] then
                    return
                else
                    v818 = (up237(game.Players.LocalPlayer))
                    v811 = false
                    v812 = (v818 == "Murder")
                    v810 = v812
                    if v812 then
                        v810 = _G.SilentAimMurderer
                    end
                    if v810 then
                        v811 = true
                    else
                        v813 = (v818 == "Sheriff")
                        v810 = v813
                        if v813 then
                            v810 = _G.SilentAimSheriff
                        end
                        if v810 then
                            v811 = true
                        end
                    end
                    if v811 then
                        up235 = (up241())
                        up236 = (up242())
                        v812 = pairs
                        v820 = game.Players
                        v825 = v820.GetPlayers
                        for v819, v820 in v812(v825(v820)) do
                            v822 = game.Players
                            if not ((v820 == v822["LocalPlayer"]))then
                                v821 = v820.Character
                                if not ((not v821))then
                                    v825 = (v821:FindFirstChild("HumanoidRootPart"))
                                    if not ((not v825))then
                                        if (v818 == "Murder") then
                                            v824 = Vector3.new(8, 8, 8)
                                            v825.Size = v824
                                        else
                                            v824 = Vector3.new(2, 2, 1)
                                            v825.Size = v824
                                        end
                                    end
                                end
                            end
                        end
                    else
                        up235 = nil
                        up236 = nil
                        v817 = pairs
                        v825 = game.Players
                        v823 = v825.GetPlayers
                        for v821, v825 in v817(v823(v825)) do
                            v824 = game.Players
                            if not ((v825 == v824["LocalPlayer"]))then
                                v822 = v825.Character
                                if v822 then
                                    v823 = v822:FindFirstChild("HumanoidRootPart")
                                    if v823 then
                                        v827 = Vector3.new(2, 2, 1)
                                        v823.Size = v827
                                    end
                                end
                            end
                        end
                    end
                    return
                end
            end
            spilledValues1.value61:Connect(spilledValues1.value63)
            pcall(function()
                local up34
                up34 = (hookmetamethod(game, "__namecall", function(arg240_1, ...)
                    local v2891, v2897, v2903, v2904
                    local v2892 = checkcaller()
                    local v2893 = arg240_1
                    local v2894 = (not v2892)
                    local v2895 = v2894
                    if v2894 then
                        v2892 = up236
                        v2894 = v2892
                        if v2892 then
                            v2897 = (v2893 == up236)
                            v2892 = v2897
                            if v2897 then
                                v2892 = (not _G.ScriptUnloaded)
                            end
                            v2894 = v2892
                        end
                        v2895 = v2894
                    end
                    if v2895 then
                        v2894 = (getnamecallmethod())
                        v2895 = (v2894 == "FireServer") or (v2894 == "InvokeServer")
                        if v2895 then
                            if up235 then
                                v2891 = {...}
                                v2895 = (up235.CFrame + (up235.AssemblyLinearVelocity * .12))
                                v2891[2] = v2895
                                v2903 = up34
                                v2904 = unpack
                                return v2903(v2893, v2904(v2891))
                            end
                        end
                    end
                    return up34(v2893, ...)
                end))

                return
            end)
            game:GetService("RunService").RenderStepped:Connect(function()
                local v841, v844, v847
                local v840 = _G
                if v840.ScriptUnloaded then
                    return
                else
                    v841 = workspace:FindFirstChild("GunDrop", true)
                    v840 = v841
                    if not (v841) then
                        v840 = (workspace:FindFirstChild("Gun Drop", true))
                    end
                    v844 = v840
                    v847 = _G
                    v847.CachedGunDrop = v844
                    return
                end
            end)
            spilledValues1.value62 = Instance.new("ScreenGui")
            local up243 = spilledValues1.value62
            spilledValues1.value62 = up243
            spilledValues1.value62.Name = "VelonexSpectators"
            spilledValues1.value62 = up243
            spilledValues1.value63 = "Parent"
            spilledValues1.value66 = gethui and (gethui())
            spilledValues1.value64 = spilledValues1.value66
            if not (spilledValues1.value66) then
                spilledValues1.value69 = game:GetService("CoreGui")
                spilledValues1.value66 = spilledValues1.value69
                if not (spilledValues1.value69) then
                    spilledValues1.value66 = (game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
                end
                spilledValues1.value64 = spilledValues1.value66
            end
            spilledValues1.value62[spilledValues1.value63] = spilledValues1.value64
            spilledValues1.value62 = up243
            spilledValues1.value64 = Enum.ZIndexBehavior.Sibling
            spilledValues1.value62.ZIndexBehavior = spilledValues1.value64
            spilledValues1.value62 = up243
            spilledValues1.value62.IgnoreGuiInset = true
            spilledValues1.value63 = Instance.new("Frame")
            local up244 = spilledValues1.value63
            spilledValues1.value63 = up244
            spilledValues1.value63.Name = "MainFrame"
            spilledValues1.value63 = up244
            spilledValues1.value66 = UDim2.new(0, 220, 0, 35)
            spilledValues1.value63.Size = spilledValues1.value66
            spilledValues1.value63 = up244
            spilledValues1.value66 = UDim2.new(1, -240, 0, 20)
            spilledValues1.value63.Position = spilledValues1.value66
            spilledValues1.value63 = up244
            spilledValues1.value66 = Color3.fromRGB(12, 12, 20)
            spilledValues1.value63.BackgroundColor3 = spilledValues1.value66
            spilledValues1.value63 = up244
            spilledValues1.value63.BackgroundTransparency = .4
            spilledValues1.value63 = up244
            spilledValues1.value63.BorderSizePixel = 0
            spilledValues1.value63 = up244
            spilledValues1.value63.Parent = up243
            spilledValues1.value64 = Instance.new("UICorner", up244)
            spilledValues1.value66 = UDim.new(0, 12)
            spilledValues1.value64.CornerRadius = spilledValues1.value66
            spilledValues1.value64 = Instance.new("UIStroke")
            spilledValues1.value66 = Color3.fromRGB(255, 255, 255)
            spilledValues1.value64.Color = spilledValues1.value66
            spilledValues1.value64.Transparency = 0.5
            spilledValues1.value64.Thickness = 1.5
            spilledValues1.value64.Parent = up244
            spilledValues1.value65 = Instance.new("UIGradient")
            spilledValues1.value66 = ColorSequence.new
            spilledValues1.value72 = ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 110, 255))
            spilledValues1.value69 = ColorSequenceKeypoint.new
            spilledValues1.value71 = Color3.fromRGB
            spilledValues1.value67 = spilledValues1.value66({spilledValues1.value72, spilledValues1.value69(1, spilledValues1.value71(80, 50, 200))})
            spilledValues1.value65.Color = spilledValues1.value67
            spilledValues1.value65.Parent = spilledValues1.value64
            spilledValues1.value66 = Instance.new("TextLabel")
            local up245 = spilledValues1.value66
            spilledValues1.value66 = up245
            spilledValues1.value69 = UDim2.new(1, 0, 0, 30)
            spilledValues1.value66.Size = spilledValues1.value69
            spilledValues1.value66 = up245
            spilledValues1.value66.BackgroundTransparency = 1
            spilledValues1.value66 = up245
            spilledValues1.value68 = Enum.Font.GothamBold
            spilledValues1.value66.Font = spilledValues1.value68
            spilledValues1.value66 = up245
            spilledValues1.value66.Text = "SPECTATORS"
            spilledValues1.value66 = up245
            spilledValues1.value69 = Color3.fromRGB(255, 255, 255)
            spilledValues1.value66.TextColor3 = spilledValues1.value69
            spilledValues1.value66 = up245
            spilledValues1.value66.TextSize = 14
            spilledValues1.value66 = up245
            spilledValues1.value66.Parent = up244
            spilledValues1.value67 = Instance.new("Frame")
            spilledValues1.value69 = UDim2.new(1, -20, 0, 1)
            spilledValues1.value67.Size = spilledValues1.value69
            spilledValues1.value69 = UDim2.new(0, 10, 0, 30)
            spilledValues1.value67.Position = spilledValues1.value69
            spilledValues1.value69 = Color3.fromRGB(255, 255, 255)
            spilledValues1.value67.BackgroundColor3 = spilledValues1.value69
            spilledValues1.value67.BackgroundTransparency = .8
            spilledValues1.value67.BorderSizePixel = 0
            spilledValues1.value67.Parent = up244
            spilledValues1.value68 = Instance.new("ScrollingFrame")
            local up246 = spilledValues1.value68
            spilledValues1.value68 = up246
            spilledValues1.value70 = UDim2.new(1, -10, 1, -40)
            spilledValues1.value68.Size = spilledValues1.value70
            spilledValues1.value68 = up246
            spilledValues1.value70 = UDim2.new(0, 5, 0, 35)
            spilledValues1.value68.Position = spilledValues1.value70
            spilledValues1.value68 = up246
            spilledValues1.value68.BackgroundTransparency = 1
            spilledValues1.value68 = up246
            spilledValues1.value68.BorderSizePixel = 0
            spilledValues1.value68 = up246
            spilledValues1.value68.ScrollBarThickness = 2
            spilledValues1.value68 = up246
            spilledValues1.value70 = UDim2.new(0, 0, 0, 0)
            spilledValues1.value68.CanvasSize = spilledValues1.value70
            spilledValues1.value68 = up246
            spilledValues1.value68.Parent = up244
            spilledValues1.value69 = Instance.new("UIListLayout")
            spilledValues1.value72 = Enum.SortOrder.LayoutOrder
            spilledValues1.value69.SortOrder = spilledValues1.value72
            spilledValues1.value70 = UDim.new (0, 2)
            spilledValues1.value69.Padding = spilledValues1.value70
            spilledValues1.value72 = up246
            spilledValues1.value69.Parent = spilledValues1.value72
            local up247
            local up248
            local up249
            spilledValues1.value70 = up244.InputBegan
            spilledValues1.value73 = function(arg170_1)
                local v2079 = arg170_1
                local v2084 = v2079.UserInputType
                local v2080 = Enum.UserInputType
                if (v2084 == v2080["MouseButton1"]) then
                    up247 = true
                    up248 = v2079.Position
                    up249 = up244.Position
                end
                return
            end
            spilledValues1.value70:Connect(spilledValues1.value73)
            spilledValues1.value70 = game:GetService("UserInputService").InputChanged
            spilledValues1.value73 = function(arg171_1)
                local v2095, v2100
                local v2089 = arg171_1
                local v2090 = up247
                local v2091 = v2090
                if v2090 then
                    v2091 = (v2089.UserInputType == Enum.UserInputType.MouseMovement)
                end
                if v2091 then
                    v2090 = (v2089.Position - up248)
                    v2100 = up244
                    v2095 = UDim2.new(up249.X.Scale, (up249.X.Offset + v2090.X), up249.Y.Scale, (up249.Y .Offset + v2090.Y))
                    v2100.Position = v2095
                end
                return
            end
            spilledValues1.value70:Connect(spilledValues1.value73)
            spilledValues1.value70 = game:GetService("UserInputService").InputEnded
            spilledValues1.value73 = function(arg172_1)
                local v2110 = arg172_1.UserInputType
                local v2106 = Enum.UserInputType
                if (v2110 == v2106["MouseButton1"]) then
                end
                return
            end
            spilledValues1.value70:Connect(spilledValues1.value73)
            spilledValues1.value71 = function()
                local v2116, v2120, v2121, v2123, v2124, v2125, v2126, v2133, v2134
                local v2117 = game
                local v2119 = {}
                v2117 = v2117.Players.LocalPlayer
                local v2115 = v2117.Character
                local v2118 = (not v2115)
                local v2122 = v2118
                if not (v2118) then
                    v2121 = (not (v2115:FindFirstChild("Humanoid")))
                    v2118 = v2121
                    if not (v2121) then
                        v2118 = (v2115.Humanoid.Health <= 0)
                    end
                    v2122 = v2118
                end
                if v2122 then
                    return v2119
                else
                    v2116 = pairs
                    v2121 = game.Players
                    v2126 = v2121.GetPlayers
                    for v2120, v2126 in v2116(v2126(v2121)) do
                        if (v2126 ~= v2117) then
                            v2123 = v2126.Character
                            v2125 = (not v2123)
                            v2124 = v2125
                            if not (v2125) then
                                v2134 = (not (v2123:FindFirstChild("HumanoidRootPart")))
                                v2125 = v2134
                                if not (v2134) then
                                    v2133 = v2123:FindFirstChild("Humanoid")
                                    v2134 = v2133
                                    if v2133 then
                                        v2134 = (v2123.Humanoid.Health <= 0)
                                    end
                                    v2125 = v2134
                                end
                                v2124 = v2125
                            end
                            if v2124 then
                                table.insert(v2119, v2126.Name)
                            end
                        end
                    end
                    return v2119
                end
            end
            local up250 = spilledValues1.value71
            spilledValues1.value71 = task.spawn
            spilledValues1.value74 = function()
                local v2138, v2139, v2140, v2141, v2142, v2143, v2144, v2145, v2146, v2147, v2148, v2149, v2151, v2152
                while true do
                    task.wait(1)
                    v2139 = _G
                    if v2139["ScriptUnloaded"] then
                        break
                    else
                        v2138 = pairs
                        v2144 = up246
                        v2145 = v2144.GetChildren
                        for v2147, v2145 in v2138(v2145(v2144)) do
                            v2138 = v2145:IsA("TextLabel")
                            if v2138 then
                                v2145:Destroy()
                            end
                        end
                        v2146 = up250()
                        v2138 = up245
                        v2143 = v2146
                        v2145 = (#v2143)
                        v2152 = (v2145 .. "]")
                        v2138.Text = ("SPECTATORS [" .. v2152)
                        for v2144, v2145 in ipairs(v2143) do
                            v2151 = Instance.new("TextLabel")
                            v2149 = UDim2.new(1, -10, 0, 20)
                            v2151.Size = v2149
                            v2149 = UDim2.new(0, 10, 0, 0)
                            v2151.Position = v2149
                            v2151.BackgroundTransparency = 1
                            v2148 = Enum.Font.GothamSemibold
                            v2151.Font = v2148
                            v2151.Text = ("👁 " .. v2145)
                            v2149 = Color3.fromRGB(220, 220, 220)
                            v2151.TextColor3 = v2149
                            v2151.TextSize = 12
                            v2148 = Enum.TextXAlignment.Left
                            v2151.TextXAlignment = v2148
                            v2148 = up246
                            v2151.Parent = v2148
                        end
                        v2138 = up246
                        v2144 = UDim2.new(0, 0, 0, ((#v2143) * 22))
                        v2138.CanvasSize = v2144
                        v2140 = (35 + ((#v2143) * 22))
                        v2141 = (math.clamp(v2140, 35, 250))
                        v2142 = (game:GetService("TweenService"))
                        v2146 = up244
                        v2144 = TweenInfo.new(.2)
                        v2151 = UDim2
                        v2138 = v2142.Create
                        v2151 = v2151.new(0, 220, 0, v2141)
                        v2138 = v2138(v2142, v2146, v2144, {["Size"] = v2151})
                        v2138:Play()
                    end
                end
                up243:Destroy()
                return
            end
            spilledValues1.value71(spilledValues1.value74)

            return
        end
    end
end
