-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
}
do
    local value1 = t1.value1
    local uDim2 = UDim2.fromOffset(720, 600)
    local CreateWindow = value1.CreateWindow
    local RightControl = Enum.KeyCode.RightControl

    t1.value2 = CreateWindow(value1, {
		Title = "NovoAprendiz",
		Icon = "sword",
		Theme = "Dark",
		Size = uDim2,
		ToggleKey = RightControl
	})
end
local v8, v9, v10
do
    local v6 = t1.value2:Tab({
		Title = "Polichinelos",
		Icon = "activity"
	})
    local v7 = t1.value2:Tab({
		Title = "Invasão",
		Icon = "sword"
	})

    v8 = t1.value2:Tab({
		Title = "Parkour",
		Icon = "zap"
	})
    v9 = t1.value2:Tab({
		Title = "Pvp",
		Icon = "crosshair"
	})
    v10 = t1.value2:Tab({
		Title = "Main",
		Icon = "settings"
	})
    t1.value3 = 0.1
    t1.value4 = false
    v6:Toggle({
		Title = "Auto polichinelo",
		Value = false,
		Callback = function(p1)
        t1.value4 = p1

        if t1.value4 then
            task.spawn(function()
                while t1.value4 do
                    pcall(function()
                        local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

                        if not PlayerGui then
                            return
                        end

                        local v531 = PlayerGui:FindFirstChild("Polichinelos") and PlayerGui.Polichinelos:FindFirstChild("Screen")
                        local v532 = v531 and v531:FindFirstChild("InputTemplate")

                        if v532 then
                            local TextLabel = v532:FindFirstChildOfClass("TextLabel")

                            if TextLabel and TextLabel.Text ~= "" then
                                local ok, result = pcall(function()
                                    return Enum.KeyCode[string.upper(TextLabel.Text)]
                                end)

                                if ok and result then
                                    local VirtualInputManager = game:GetService("VirtualInputManager")

                                    VirtualInputManager:SendKeyEvent(true, result, false, game)
                                    task.wait(0.02)
                                    VirtualInputManager:SendKeyEvent(false, result, false, game)

                                    if keypress then
                                        pcall(function()
                                            local byte = string.byte(string.lower(TextLabel.Text))

                                            keypress(byte)
                                            task.wait(0.02)
                                            keyrelease(byte)
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(t1.value3)
                end
            end)
        end
    end
	})

    local t2 = {
		Default = 0.1,
		Min = 0.05,
		Max = 2
	}

    v6:Slider({
		Title = "Intervalo (segundos)",
		Value = t2,
		Step = 0.01,
		Callback = function(p2)
        t1.value3 = p2
    end
	})
    t1.value5 = false
    t1.value6 = nil
    t1.value7 = nil
    t1.value8 = nil

    function t1.value9()
        local s1 = ""

        for _ = 1, math.random(8, 14) do
            local v391 = math.random(1, 62)

            s1 ..= ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"):sub(v391, v391)
        end

        return s1
    end
    function t1.value10(p3)
        local u396 = p3
        pcall(function()
            if t1.value6 and t1.value6.Parent then
                t1.value6:Destroy()
            end

            local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

            if not PlayerGui then
                return
            end

            local ScreenGui = Instance.new("ScreenGui")

            ScreenGui.Name = t1.value9()
            ScreenGui.ResetOnSpawn = false
            ScreenGui.DisplayOrder = 999999
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            ScreenGui.Parent = PlayerGui

            local Frame = Instance.new("Frame")

            Frame.Name = t1.value9()
            Frame.Size = UDim2.new(1, 0, 1, 0)
            Frame.Position = UDim2.new(0, 0, 0, 0)
            Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            Frame.BackgroundTransparency = 0
            Frame.BorderSizePixel = 0
            Frame.ZIndex = 999999
            Frame.Parent = ScreenGui

            local TextLabel = Instance.new("TextLabel")

            TextLabel.Name = t1.value9()
            TextLabel.Size = UDim2.new(1, 0, 0, 50)
            TextLabel.Position = UDim2.new(0, 0, 0.5, -25)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = u396 or "Aguarde..."
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 22
            TextLabel.Font = Enum.Font.GothamBold
            TextLabel.TextXAlignment = Enum.TextXAlignment.Center
            TextLabel.ZIndex = 999999
            TextLabel.Parent = Frame
            t1.value6 = ScreenGui
        end)
    end
    function t1.value11()
        t1.value5 = false
        task.wait(0.15)
        pcall(function()
            if t1.value6 and t1.value6.Parent then
                t1.value6:Destroy()
                t1.value6 = nil
            end
        end)
    end
    function t1.value12(p4)
        local Humanoid = p4:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart")

        if Humanoid then
            Humanoid.AutoRotate = false
            Humanoid.PlatformStand = true
        end

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = true
        end
    end
    function t1.value13(p5)
        local Humanoid = p5:FindFirstChildOfClass("Humanoid")
        local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.Anchored = false
        end

        if Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.AutoRotate = true
        end
    end
    function t1.value14(p6, p7)
        local Character = game.Players.LocalPlayer.Character

        if not Character then
            return false
        end

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

        if not HumanoidRootPart then
            return false
        end

        local HumanoidRootPartPosition = HumanoidRootPart.Position
        local Magnitude = (p6 - HumanoidRootPartPosition).Magnitude

        if Magnitude < 0.5 then
            return true
        end

        local v384 = math.max(1, (math.floor(Magnitude / p7 * 20)))
        local v385 = false
        local n1 = 0

        while true do
            n1 += 1

            if (not v385 or not (v384 <= n1)) and (v385 or not (n1 <= v384)) then
                break
            end

            if not HumanoidRootPart.Parent then
                return false
            end

            local v387 = HumanoidRootPartPosition:Lerp(p6, n1 / v384)
            local v388 = p6 - v387

            if v388.Magnitude > 0.1 then
                HumanoidRootPart.CFrame = CFrame.lookAt(v387, v387 + v388)
            else
                HumanoidRootPart.CFrame = CFrame.new(v387)
            end

            task.wait(0.05)
        end

        if HumanoidRootPart.Parent then
            HumanoidRootPart.CFrame = CFrame.new(p6)

            return true
        end

        return false
    end

    local function v12()
        local Character = game.Players.LocalPlayer.Character

        if not Character or not Character:FindFirstChild("HumanoidRootPart") then
            return
        end

        local Map = workspace:FindFirstChild("Map")

        if not Map then
            return
        end

        t1.value7 = Map:GetChildren()[494]

        if not t1.value7 or not t1.value7:IsA("BasePart") then
            return
        end

        t1.value8 = t1.value7.Size
        t1.value5 = true

        local s2 = "Invadindo base..."

        task.spawn(function()
            while t1.value5 do
                t1.value10(s2)
                task.wait(0.1)
            end

            pcall(function()
                if t1.value6 and t1.value6.Parent then
                    t1.value6:Destroy()
                end
            end)
        end)
        t1.value12(Character)
        t1.value14(Vector3.new(119, 3, -494), 999)
        pcall(function()
            t1.value7.Size = Vector3.new(0, 0, 0)
            t1.value7.CanCollide = false
        end)
        t1.value14(Vector3.new(109, 3, -502), 999)
        pcall(function()
            if t1.value7 and (t1.value7.Parent and t1.value8) then
                t1.value7.Size = t1.value8
                t1.value7.CanCollide = true
            end
        end)
        t1.value13(game.Players.LocalPlayer.Character or Character)
        t1.value11()
    end

    v7:Button({
		Title = "Invadir Base Militar",
		Callback = function()
        task.spawn(v12)
    end
	})
end
t1.value15 = false
t1.value16 = nil
t1.value17 = {}
do
    local t3

    do
        local vector3 = Vector3.new(185.03, 5.04, -661.62)
        local vector3_2 = Vector3.new(4, 0.5, 16)

        t3 = {
			pos = vector3,
			size = vector3_2
		}
    end

    local t4, t5

    do
        local vector3 = Vector3.new(185.39, 13.26, -661.39)
        local vector3_3 = Vector3.new(4, 0.5, 16)

        t4 = {
			pos = vector3,
			size = vector3_3
		}

        local vector3_4 = Vector3.new(185.11, 21.28, -661.68)
        local vector3_5 = Vector3.new(4, 0.5, 16)

        t5 = {
			pos = vector3_4,
			size = vector3_5
		}
    end

    local t6, t7

    do
        local vector3 = Vector3.new(185.3, 29.29, -661.72)
        local vector3_6 = Vector3.new(4, 0.5, 16)

        t6 = {
			pos = vector3,
			size = vector3_6
		}

        local vector3_7 = Vector3.new(186.08, 37.36, -661.76)
        local vector3_8 = Vector3.new(4, 0.5, 16)

        t7 = {
			pos = vector3_7,
			size = vector3_8
		}
    end

    local t8, t9

    do
        local vector3 = Vector3.new(186.08, 45.36, -661.76)
        local vector3_9 = Vector3.new(4, 0.5, 16)

        t8 = {
			pos = vector3,
			size = vector3_9
		}

        local vector3_10 = Vector3.new(186.25, 53.36, -661.86)
        local vector3_11 = Vector3.new(4, 0.5, 16)

        t9 = {
			pos = vector3_10,
			size = vector3_11
		}
    end

    local t10, t11

    do
        local vector3 = Vector3.new(185.82, 61.36, -662)
        local vector3_12 = Vector3.new(4, 0.5, 16)

        t10 = {
			pos = vector3,
			size = vector3_12
		}

        local vector3_13 = Vector3.new(185.6, 69.4, -661.98)
        local vector3_14 = Vector3.new(4, 0.5, 16)

        t11 = {
			pos = vector3_13,
			size = vector3_14
		}
    end

    local t12, t13

    do
        local vector3 = Vector3.new(185.71, 77.42, -661.9)
        local vector3_15 = Vector3.new(4, 0.5, 15)

        t12 = {
			pos = vector3,
			size = vector3_15
		}

        local vector3_16 = Vector3.new(185.28, 85.44, -662.14)
        local vector3_17 = Vector3.new(4, 0.5, 16)

        t13 = {
			pos = vector3_16,
			size = vector3_17
		}
    end

    local t14, t15

    do
        local vector3 = Vector3.new(185.42, 93.48, -662.05)
        local vector3_18 = Vector3.new(4, 0.5, 16)

        t14 = {
			pos = vector3,
			size = vector3_18
		}

        local vector3_19 = Vector3.new(185.94, 101.46, -661.8)
        local vector3_20 = Vector3.new(4, 0.5, 15)

        t15 = {
			pos = vector3_19,
			size = vector3_20
		}
    end

    local t16, t17

    do
        local vector3 = Vector3.new(185.94, 109.48, -661.78)
        local vector3_21 = Vector3.new(4, 0.5, 17)

        t16 = {
			pos = vector3,
			size = vector3_21
		}

        local vector3_22 = Vector3.new(185.08, 5.26, -618.66)
        local vector3_23 = Vector3.new(4, 0.5, 16)

        t17 = {
			pos = vector3_22,
			size = vector3_23
		}
    end

    local t18, t19

    do
        local vector3 = Vector3.new(185.36, 13.28, -618.65)
        local vector3_24 = Vector3.new(4, 0.5, 15)

        t18 = {
			pos = vector3,
			size = vector3_24
		}

        local vector3_25 = Vector3.new(185.32, 21.29, -618.7)
        local vector3_26 = Vector3.new(4, 0.5, 16)

        t19 = {
			pos = vector3_25,
			size = vector3_26
		}
    end

    local t20, t21

    do
        local vector3 = Vector3.new(185.65, 29.34, -618.67)
        local vector3_27 = Vector3.new(4, 0.5, 16)

        t20 = {
			pos = vector3,
			size = vector3_27
		}

        local vector3_28 = Vector3.new(186.12, 37.36, -618.43)
        local vector3_29 = Vector3.new(4, 0.5, 15)

        t21 = {
			pos = vector3_28,
			size = vector3_29
		}
    end

    local t22, t23

    do
        local vector3 = Vector3.new(186.3, 45.34, -617.87)
        local vector3_30 = Vector3.new(5, 0.5, 16)

        t22 = {
			pos = vector3,
			size = vector3_30
		}

        local vector3_31 = Vector3.new(185.41, 53.36, -618.05)
        local vector3_32 = Vector3.new(4, 0.5, 15)

        t23 = {
			pos = vector3_31,
			size = vector3_32
		}
    end

    local t24, t25

    do
        local vector3 = Vector3.new(185.62, 61.4, -617.79)
        local vector3_33 = Vector3.new(4, 0.5, 16)

        t24 = {
			pos = vector3,
			size = vector3_33
		}

        local vector3_34 = Vector3.new(185.58, 69.4, -617.79)
        local vector3_35 = Vector3.new(4, 0.5, 17)

        t25 = {
			pos = vector3_34,
			size = vector3_35
		}
    end

    local t26, t27

    do
        local vector3 = Vector3.new(185.87, 77.42, -618.33)
        local vector3_36 = Vector3.new(4, 0.5, 15)

        t26 = {
			pos = vector3,
			size = vector3_36
		}

        local vector3_37 = Vector3.new(185.73, 85.44, -618.62)
        local vector3_38 = Vector3.new(4, 0.5, 16)

        t27 = {
			pos = vector3_37,
			size = vector3_38
		}
    end

    local t28, t29

    do
        local vector3 = Vector3.new(185.68, 93.48, -618.49)
        local vector3_39 = Vector3.new(4, 0.5, 15)

        t28 = {
			pos = vector3,
			size = vector3_39
		}

        local vector3_40 = Vector3.new(185.83, 101.46, -617.76)
        local vector3_41 = Vector3.new(4, 0.5, 16)

        t29 = {
			pos = vector3_40,
			size = vector3_41
		}
    end

    local t30, t31

    do
        local vector3 = Vector3.new(185.57, 109.48, -618.45)
        local vector3_42 = Vector3.new(4, 0.5, 15)

        t30 = {
			pos = vector3,
			size = vector3_42
		}

        local vector3_43 = Vector3.new(270.22, 4.24, -661.72)
        local vector3_44 = Vector3.new(5, 0.5, 5)

        t31 = {
			pos = vector3_43,
			size = vector3_44
		}
    end

    local t32, t33

    do
        local vector3 = Vector3.new(277.86, 4.24, -655.56)
        local vector3_45 = Vector3.new(5, 0.5, 5)

        t32 = {
			pos = vector3,
			size = vector3_45
		}

        local vector3_46 = Vector3.new(269.8, 4.24, -649.96)
        local vector3_47 = Vector3.new(5, 0.5, 5)

        t33 = {
			pos = vector3_46,
			size = vector3_47
		}
    end

    local t34, t35

    do
        local vector3 = Vector3.new(284.45, 4.24, -660.72)
        local vector3_48 = Vector3.new(5, 0.5, 5)

        t34 = {
			pos = vector3,
			size = vector3_48
		}

        local vector3_49 = Vector3.new(284.59, 4.24, -650.23)
        local vector3_50 = Vector3.new(5, 0.5, 5)

        t35 = {
			pos = vector3_49,
			size = vector3_50
		}
    end

    local t36, t37

    do
        local vector3 = Vector3.new(267.14, 5.04, -627.94)
        local vector3_51 = Vector3.new(4, 0.5, 32)

        t36 = {
			pos = vector3,
			size = vector3_51
		}

        local vector3_52 = Vector3.new(288.33, 5.04, -627.86)
        local vector3_53 = Vector3.new(4, 0.5, 31)

        t37 = {
			pos = vector3_52,
			size = vector3_53
		}
    end

    local t38, t39

    do
        local vector3 = Vector3.new(277.48, 7.63, -591.97)
        local vector3_54 = Vector3.new(4, 0.5, 27)

        t38 = {
			pos = vector3,
			size = vector3_54
		}

        local vector3_55 = Vector3.new(271.76, 7.64, -569.98)
        local vector3_56 = Vector3.new(5, 0.5, 5)

        t39 = {
			pos = vector3_55,
			size = vector3_56
		}
    end

    local t40, t41

    do
        local vector3 = Vector3.new(279.08, 7.64, -567.95)
        local vector3_57 = Vector3.new(5, 0.5, 5)

        t40 = {
			pos = vector3,
			size = vector3_57
		}

        local vector3_58 = Vector3.new(265.48, 7.64, -564.93)
        local vector3_59 = Vector3.new(5, 0.5, 5)

        t41 = {
			pos = vector3_58,
			size = vector3_59
		}
    end

    local t42, t43

    do
        local vector3 = Vector3.new(271.34, 7.64, -559.7)
        local vector3_60 = Vector3.new(5, 0.5, 5)

        t42 = {
			pos = vector3,
			size = vector3_60
		}

        local vector3_61 = Vector3.new(259.46, 7.64, -561.92)
        local vector3_62 = Vector3.new(5, 0.5, 5)

        t43 = {
			pos = vector3_61,
			size = vector3_62
		}
    end

    local t44, t45

    do
        local vector3 = Vector3.new(260.5, 7.64, -554.72)
        local vector3_63 = Vector3.new(5, 0.5, 5)

        t44 = {
			pos = vector3,
			size = vector3_63
		}

        local vector3_64 = Vector3.new(250.93, 7.64, -561.91)
        local vector3_65 = Vector3.new(5, 0.5, 5)

        t45 = {
			pos = vector3_64,
			size = vector3_65
		}
    end

    local t46, t47

    do
        local vector3 = Vector3.new(248.66, 7.64, -554.6)
        local vector3_66 = Vector3.new(5, 0.5, 5)

        t46 = {
			pos = vector3,
			size = vector3_66
		}

        local vector3_67 = Vector3.new(243.06, 7.64, -565.74)
        local vector3_68 = Vector3.new(5, 0.5, 5)

        t47 = {
			pos = vector3_67,
			size = vector3_68
		}
    end

    local t48, t49

    do
        local vector3 = Vector3.new(235.96, 7.64, -560.93)
        local vector3_69 = Vector3.new(5, 0.5, 5)

        t48 = {
			pos = vector3,
			size = vector3_69
		}

        local vector3_70 = Vector3.new(240.08, 7.64, -592.47)
        local vector3_71 = Vector3.new(4, 0.5, 27)

        t49 = {
			pos = vector3_70,
			size = vector3_71
		}
    end

    local t50, t51

    do
        local vector3 = Vector3.new(394.19, 5.06, -850.78)
        local vector3_72 = Vector3.new(5, 0.5, 5)

        t50 = {
			pos = vector3,
			size = vector3_72
		}

        local vector3_73 = Vector3.new(389.19, 7.45, -855.82)
        local vector3_74 = Vector3.new(5, 0.5, 5)

        t51 = {
			pos = vector3_73,
			size = vector3_74
		}
    end

    local t52, t53

    do
        local vector3 = Vector3.new(392.91, 5.06, -861.09)
        local vector3_75 = Vector3.new(5, 0.5, 5)

        t52 = {
			pos = vector3,
			size = vector3_75
		}

        local vector3_76 = Vector3.new(384.07, 10.15, -855.95)
        local vector3_77 = Vector3.new(5, 0.5, 5)

        t53 = {
			pos = vector3_76,
			size = vector3_77
		}
    end

    local t54, t55

    do
        local vector3 = Vector3.new(377.51, 12.94, -855.73)
        local vector3_78 = Vector3.new(5, 0.5, 5)

        t54 = {
			pos = vector3,
			size = vector3_78
		}

        local vector3_79 = Vector3.new(370.87, 14.68, -855.83)
        local vector3_80 = Vector3.new(5, 0.5, 5)

        t55 = {
			pos = vector3_79,
			size = vector3_80
		}
    end

    local t56, t57

    do
        local vector3 = Vector3.new(365.12, 16.2, -856.03)
        local vector3_81 = Vector3.new(5, 0.5, 5)

        t56 = {
			pos = vector3,
			size = vector3_81
		}

        local vector3_82 = Vector3.new(358.5, 17.61, -855.96)
        local vector3_83 = Vector3.new(5, 0.5, 5)

        t57 = {
			pos = vector3_82,
			size = vector3_83
		}
    end

    local t58, t59

    do
        local vector3 = Vector3.new(351.76, 19.27, -856.05)
        local vector3_84 = Vector3.new(5, 0.5, 5)

        t58 = {
			pos = vector3,
			size = vector3_84
		}

        local vector3_85 = Vector3.new(345.37, 20.53, -855.83)
        local vector3_86 = Vector3.new(5, 0.5, 5)

        t59 = {
			pos = vector3_85,
			size = vector3_86
		}
    end

    local t60, t61

    do
        local vector3 = Vector3.new(339, 21.54, -855.95)
        local vector3_87 = Vector3.new(5, 0.5, 5)

        t60 = {
			pos = vector3,
			size = vector3_87
		}

        local vector3_88 = Vector3.new(334.51, 21.54, -850.11)
        local vector3_89 = Vector3.new(5, 0.5, 5)

        t61 = {
			pos = vector3_88,
			size = vector3_89
		}
    end

    local t62, t63

    do
        local vector3 = Vector3.new(328.83, 21.54, -855.97)
        local vector3_90 = Vector3.new(5, 0.5, 5)

        t62 = {
			pos = vector3,
			size = vector3_90
		}

        local vector3_91 = Vector3.new(335, 21.54, -861.7)
        local vector3_92 = Vector3.new(5, 0.5, 5)

        t63 = {
			pos = vector3_91,
			size = vector3_92
		}
    end

    local t64, t65

    do
        local vector3 = Vector3.new(324.43, 21.54, -861.35)
        local vector3_93 = Vector3.new(5, 0.5, 5)

        t64 = {
			pos = vector3,
			size = vector3_93
		}

        local vector3_94 = Vector3.new(324.69, 21.54, -850.36)
        local vector3_95 = Vector3.new(5, 0.5, 5)

        t65 = {
			pos = vector3_94,
			size = vector3_95
		}
    end

    local t66, t67

    do
        local vector3 = Vector3.new(318.73, 21.54, -855.7)
        local vector3_96 = Vector3.new(5, 0.5, 5)

        t66 = {
			pos = vector3,
			size = vector3_96
		}

        local vector3_97 = Vector3.new(313.47, 21.54, -861.9)
        local vector3_98 = Vector3.new(5, 0.5, 5)

        t67 = {
			pos = vector3_97,
			size = vector3_98
		}
    end

    local t68, t69

    do
        local vector3 = Vector3.new(308.27, 21.54, -855.88)
        local vector3_99 = Vector3.new(5, 0.5, 5)

        t68 = {
			pos = vector3,
			size = vector3_99
		}

        local vector3_100 = Vector3.new(314.49, 21.54, -850.04)
        local vector3_101 = Vector3.new(5, 0.5, 5)

        t69 = {
			pos = vector3_100,
			size = vector3_101
		}
    end

    local t70, t71

    do
        local vector3 = Vector3.new(303.58, 21.54, -861.59)
        local vector3_102 = Vector3.new(5, 0.5, 5)

        t70 = {
			pos = vector3,
			size = vector3_102
		}

        local vector3_103 = Vector3.new(303.61, 21.54, -850.61)
        local vector3_104 = Vector3.new(5, 0.5, 5)

        t71 = {
			pos = vector3_103,
			size = vector3_104
		}
    end

    local t72, t73

    do
        local vector3 = Vector3.new(298.5, 21.54, -856.16)
        local vector3_105 = Vector3.new(5, 0.5, 5)

        t72 = {
			pos = vector3,
			size = vector3_105
		}

        local vector3_106 = Vector3.new(393.87, 2.87, -892.93)
        local vector3_107 = Vector3.new(5, 0.5, 5)

        t73 = {
			pos = vector3_106,
			size = vector3_107
		}
    end

    local t74, t75

    do
        local vector3 = Vector3.new(394.65, 2.87, -902.16)
        local vector3_108 = Vector3.new(5, 0.5, 5)

        t74 = {
			pos = vector3,
			size = vector3_108
		}

        local vector3_109 = Vector3.new(389.37, 5.04, -892.4)
        local vector3_110 = Vector3.new(5, 0.5, 5)

        t75 = {
			pos = vector3_109,
			size = vector3_110
		}
    end

    local t76, t77

    do
        local vector3 = Vector3.new(389.57, 5.04, -903.24)
        local vector3_111 = Vector3.new(5, 0.5, 5)

        t76 = {
			pos = vector3,
			size = vector3_111
		}

        local vector3_112 = Vector3.new(383.37, 7.79, -892.63)
        local vector3_113 = Vector3.new(5, 0.5, 5)

        t77 = {
			pos = vector3_112,
			size = vector3_113
		}
    end

    local t78, t79

    do
        local vector3 = Vector3.new(383.64, 7.79, -903.27)
        local vector3_114 = Vector3.new(5, 0.5, 5)

        t78 = {
			pos = vector3,
			size = vector3_114
		}

        local vector3_115 = Vector3.new(378.64, 9.35, -892.48)
        local vector3_116 = Vector3.new(5, 0.5, 5)

        t79 = {
			pos = vector3_115,
			size = vector3_116
		}
    end

    local t80, t81

    do
        local vector3 = Vector3.new(378.64, 9.35, -903.24)
        local vector3_117 = Vector3.new(5, 0.5, 5)

        t80 = {
			pos = vector3,
			size = vector3_117
		}

        local vector3_118 = Vector3.new(373.27, 11.53, -892.9)
        local vector3_119 = Vector3.new(5, 0.5, 5)

        t81 = {
			pos = vector3_118,
			size = vector3_119
		}
    end

    local t82, t83

    do
        local vector3 = Vector3.new(372.82, 11.53, -903.33)
        local vector3_120 = Vector3.new(5, 0.5, 5)

        t82 = {
			pos = vector3,
			size = vector3_120
		}

        local vector3_121 = Vector3.new(368.47, 11.53, -892.69)
        local vector3_122 = Vector3.new(5, 0.5, 5)

        t83 = {
			pos = vector3_121,
			size = vector3_122
		}
    end

    local t84, t85

    do
        local vector3 = Vector3.new(367.91, 11.53, -903.02)
        local vector3_123 = Vector3.new(5, 0.5, 5)

        t84 = {
			pos = vector3,
			size = vector3_123
		}

        local vector3_124 = Vector3.new(362.88, 11.53, -894.04)
        local vector3_125 = Vector3.new(4, 0.5, 7)

        t85 = {
			pos = vector3_124,
			size = vector3_125
		}
    end

    local t86, t87

    do
        local vector3 = Vector3.new(358.03, 11.53, -901.74)
        local vector3_126 = Vector3.new(4, 0.5, 6)

        t86 = {
			pos = vector3,
			size = vector3_126
		}

        local vector3_127 = Vector3.new(352.36, 11.53, -894.75)
        local vector3_128 = Vector3.new(4, 0.5, 6)

        t87 = {
			pos = vector3_127,
			size = vector3_128
		}
    end

    local t88, t89

    do
        local vector3 = Vector3.new(347.47, 11.53, -899.21)
        local vector3_129 = Vector3.new(4, 0.5, 6)

        t88 = {
			pos = vector3,
			size = vector3_129
		}

        local vector3_130 = Vector3.new(333.21, 11.53, -897.81)
        local vector3_131 = Vector3.new(5, 0.5, 12)

        t89 = {
			pos = vector3_130,
			size = vector3_131
		}
    end

    local t90, t91

    do
        local vector3 = Vector3.new(325.73, 11.53, -898.53)
        local vector3_132 = Vector3.new(5, 0.5, 12)

        t90 = {
			pos = vector3,
			size = vector3_132
		}

        local vector3_133 = Vector3.new(318.25, 11.53, -897.79)
        local vector3_134 = Vector3.new(5, 0.5, 11)

        t91 = {
			pos = vector3_133,
			size = vector3_134
		}
    end

    local t92, t93

    do
        local vector3 = Vector3.new(310.71, 11.53, -898.95)
        local vector3_135 = Vector3.new(5, 0.5, 12)

        t92 = {
			pos = vector3,
			size = vector3_135
		}

        local vector3_136 = Vector3.new(303.1, 11.53, -898.29)
        local vector3_137 = Vector3.new(5, 0.5, 12)

        t93 = {
			pos = vector3_136,
			size = vector3_137
		}
    end

    local t94, t95

    do
        local vector3 = Vector3.new(295.54, 11.53, -898.01)
        local vector3_138 = Vector3.new(5, 0.5, 12)

        t94 = {
			pos = vector3,
			size = vector3_138
		}

        local vector3_139 = Vector3.new(288.21, 11.53, -898.79)
        local vector3_140 = Vector3.new(5, 0.5, 12)

        t95 = {
			pos = vector3_139,
			size = vector3_140
		}
    end

    local t96, t97

    do
        local vector3 = Vector3.new(149.54, 1.04, -856)
        local vector3_141 = Vector3.new(3, 0.5, 13)

        t96 = {
			pos = vector3,
			size = vector3_141
		}

        local vector3_142 = Vector3.new(148.21, 7.5, -855.93)
        local vector3_143 = Vector3.new(4, 0.5, 13)

        t97 = {
			pos = vector3_142,
			size = vector3_143
		}
    end

    local t98, t99

    do
        local vector3 = Vector3.new(148.27, 13.38, -856.27)
        local vector3_144 = Vector3.new(4, 0.5, 13)

        t98 = {
			pos = vector3,
			size = vector3_144
		}

        local vector3_145 = Vector3.new(162.71, 13.7, -859.82)
        local vector3_146 = Vector3.new(8, 0.5, 5)

        t99 = {
			pos = vector3_145,
			size = vector3_146
		}
    end

    local t100, t101

    do
        local vector3 = Vector3.new(170.73, 13.7, -852.89)
        local vector3_147 = Vector3.new(8, 0.5, 5)

        t100 = {
			pos = vector3,
			size = vector3_147
		}

        local vector3_148 = Vector3.new(181.41, 13.7, -859.17)
        local vector3_149 = Vector3.new(8, 0.5, 5)

        t101 = {
			pos = vector3_148,
			size = vector3_149
		}
    end

    local t102, t103

    do
        local vector3 = Vector3.new(190.97, 13.7, -853.25)
        local vector3_150 = Vector3.new(8, 0.5, 5)

        t102 = {
			pos = vector3,
			size = vector3_150
		}

        local vector3_151 = Vector3.new(217.92, 11.53, -848.28)
        local vector3_152 = Vector3.new(32, 0.5, 4)

        t103 = {
			pos = vector3_151,
			size = vector3_152
		}
    end

    local t104, t105

    do
        local vector3 = Vector3.new(217.99, 12.04, -863.62)
        local vector3_153 = Vector3.new(29, 0.5, 4)

        t104 = {
			pos = vector3,
			size = vector3_153
		}

        local vector3_154 = Vector3.new(243.52, 12.04, -855.57)
        local vector3_155 = Vector3.new(14, 0.5, 3)

        t105 = {
			pos = vector3_154,
			size = vector3_155
		}
    end

    local t106, t107

    do
        local vector3 = Vector3.new(150.43, 5.27, -897.87)
        local vector3_156 = Vector3.new(4, 0.5, 16)

        t106 = {
			pos = vector3,
			size = vector3_156
		}

        local vector3_157 = Vector3.new(150.71, 13.28, -898.27)
        local vector3_158 = Vector3.new(4, 0.5, 17)

        t107 = {
			pos = vector3_157,
			size = vector3_158
		}
    end

    local t108, t109

    do
        local vector3 = Vector3.new(150.28, 21.29, -898.42)
        local vector3_159 = Vector3.new(4, 0.5, 15)

        t108 = {
			pos = vector3,
			size = vector3_159
		}

        local vector3_160 = Vector3.new(150.45, 29.3, -898.11)
        local vector3_161 = Vector3.new(4, 0.5, 16)

        t109 = {
			pos = vector3_160,
			size = vector3_161
		}
    end

    local t110, t111

    do
        local vector3 = Vector3.new(150.52, 37.31, -898.44)
        local vector3_162 = Vector3.new(4, 0.5, 15)

        t110 = {
			pos = vector3,
			size = vector3_162
		}

        local vector3_163 = Vector3.new(150.56, 45.32, -897.73)
        local vector3_164 = Vector3.new(4, 0.5, 15)

        t111 = {
			pos = vector3_163,
			size = vector3_164
		}
    end

    local t112, t113

    do
        local vector3 = Vector3.new(150.95, 53.33, -898.02)
        local vector3_165 = Vector3.new(4, 0.5, 16)

        t112 = {
			pos = vector3,
			size = vector3_165
		}

        local vector3_166 = Vector3.new(167.23, 53.26, -903.84)
        local vector3_167 = Vector3.new(5, 0.5, 5)

        t113 = {
			pos = vector3_166,
			size = vector3_167
		}
    end

    local t114, t115

    do
        local vector3 = Vector3.new(172.9, 53.26, -900.06)
        local vector3_168 = Vector3.new(5, 0.5, 5)

        t114 = {
			pos = vector3,
			size = vector3_168
		}

        local vector3_169 = Vector3.new(167.09, 53.26, -890.73)
        local vector3_170 = Vector3.new(5, 0.5, 5)

        t115 = {
			pos = vector3_169,
			size = vector3_170
		}
    end

    local t116, t117

    do
        local vector3 = Vector3.new(181.65, 53.26, -902)
        local vector3_171 = Vector3.new(5, 0.5, 5)

        t116 = {
			pos = vector3,
			size = vector3_171
		}

        local vector3_172 = Vector3.new(180.48, 53.26, -893.06)
        local vector3_173 = Vector3.new(5, 0.5, 5)

        t117 = {
			pos = vector3_172,
			size = vector3_173
		}
    end

    local t118, t119

    do
        local vector3 = Vector3.new(199.1, 53.33, -897.28)
        local vector3_174 = Vector3.new(5, 0.5, 5)

        t118 = {
			pos = vector3,
			size = vector3_174
		}

        local vector3_175 = Vector3.new(210.5, 53.33, -897.85)
        local vector3_176 = Vector3.new(5, 0.5, 5)

        t119 = {
			pos = vector3_175,
			size = vector3_176
		}
    end

    local vector3 = Vector3.new(223.52, 53.33, -898.25)
    local vector3_177 = Vector3.new(5, 0.5, 5)
    local t120 = {
		pos = vector3,
		size = vector3_177
	}
    local vector3_178 = Vector3.new(235.61, 53.33, -897.82)
    local vector3_179 = Vector3.new(5, 0.5, 5)

    t1.value18 = {
		t3,
		t4,
		t5,
		t6,
		t7,
		t8,
		t9,
		t10,
		t11,
		t12,
		t13,
		t14,
		t15,
		t16,
		t17,
		t18,
		t19,
		t20,
		t21,
		t22,
		t23,
		t24,
		t25,
		t26,
		t27,
		t28,
		t29,
		t30,
		t31,
		t32,
		t33,
		t34,
		t35,
		t36,
		t37,
		t38,
		t39,
		t40,
		t41,
		t42,
		t43,
		t44,
		t45,
		t46,
		t47,
		t48,
		t49,
		t50,
		t51,
		t52,
		t53,
		t54,
		t55,
		t56,
		t57,
		t58,
		t59,
		t60,
		t61,
		t62,
		t63,
		t64,
		t65,
		t66,
		t67,
		t68,
		t69,
		t70,
		t71,
		t72,
		t73,
		t74,
		t75,
		t76,
		t77,
		t78,
		t79,
		t80,
		t81,
		t82,
		t83,
		t84,
		t85,
		t86,
		t87,
		t88,
		t89,
		t90,
		t91,
		t92,
		t93,
		t94,
		t95,
		t96,
		t97,
		t98,
		t99,
		t100,
		t101,
		t102,
		t103,
		t104,
		t105,
		t106,
		t107,
		t108,
		t109,
		t110,
		t111,
		t112,
		t113,
		t114,
		t115,
		t116,
		t117,
		t118,
		t119,
		t120,
		{
			pos = vector3_178,
			size = vector3_179
		}
	}
end
function t1.value19()
    for _, v in ipairs(t1.value18) do
        local Part = Instance.new("Part", workspace)

        Part.Name = "CS_Hitbox"
        Part.Size = v.size
        Part.Position = v.pos
        Part.Anchored = true
        Part.Transparency = 0.5
        Part.BrickColor = BrickColor.new("Bright blue")
        Part.Material = Enum.Material.Neon
        table.insert(t1.value17, Part)
    end

    t1.value16 = game:GetService("RunService").Heartbeat:Connect(function()
        local Character = game.Players.LocalPlayer.Character
        local v512 = Character and Character:FindFirstChild("HumanoidRootPart")

        if not v512 then
            return
        end

        local AssemblyLinearVelocityY = v512.AssemblyLinearVelocity.Y

        for _, v in pairs(t1.value17) do
            v.CanCollide = AssemblyLinearVelocityY <= 0.5 and v512.Position.Y > v.Position.Y + v.Size.Y / 2 - 1
        end
    end)
end
local function v369()
    if t1.value16 then
        t1.value16:Disconnect()
    end

    for _, v in pairs(t1.value17) do
        if v and v.Parent then
            v:Destroy()
        end
    end
end
v8:Toggle({
	Title = "Active parkour suporte",
	Value = false,
	Callback = function(p8)
    t1.value15 = p8

    if t1.value15 then
        t1.value19()
        t1.value1:Notify({
				Title = "Parkour",
				Content = "Ativado!",
				Duration = 2
			})

        return
    end

    v369()
    t1.value1:Notify({
			Title = "Parkour",
			Content = "Desativado!",
			Duration = 2
		})
end
})
t1.value20 = game:GetService("Players")
t1.value21 = t1.value20.LocalPlayer
t1.value22 = game:GetService("RunService")
t1.value23 = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")

t1.value24 = false
t1.value25 = nil
t1.value26 = ReplicatedStorage:WaitForChild("GunAssets"):WaitForChild("Events"):WaitForChild("Reload")
t1.value27 = {
	BERETTA = true,
	DEAGLE = true,
	HK416 = true,
	G36C = true,
	M4A1 = true,
	["AK-47"] = true,
	M16 = true,
	MP5 = true,
	MP40 = true,
	FAMAS = true,
	SKS = true,
	P90 = true
}
function t1.value28()
    if t1.value25 then
        t1.value25:Disconnect()
    end
end
local Toggle = v9.Toggle
local t121 = {
	Title = "Inf Ammo",
	Value = false,
	Callback = function(p9)
    t1.value24 = p9

    if t1.value24 then
        t1.value22.Heartbeat:Connect(function()
            local Character = t1.value21.Character

            if not Character then
                return
            end

            for k in pairs(t1.value27) do
                local k2 = Character:FindFirstChild(k)

                if k2 then
                    t1.value26:FireServer(k2)

                    return
                end
            end
        end)
        t1.value1:Notify({
				Title = "Inf Ammo",
				Content = "Ativado!",
				Duration = 2
			})

        return
    end

    t1.value28()
    t1.value1:Notify({
			Title = "Inf Ammo",
			Content = "Desativado!",
			Duration = 2
		})
end
}
t1.value29 = nil
Toggle(v9, t121)
t1.value30 = false
t1.value29 = nil
function t1.value31()
    local Character = t1.value21.Character

    if not Character then
        return
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid then
        return
    end

    t1.value29 = t1.value22.Heartbeat:Connect(function()
        if not t1.value30 then
            return
        end

        if not Humanoid or not Humanoid.Parent then
            local Character2 = t1.value21.Character

            if Character2 then
                Humanoid = Character2:FindFirstChildOfClass("Humanoid")
            end

            if not Humanoid then
                return
            end
        end

        if Humanoid:GetState() ~= Enum.HumanoidStateType.Jumping and Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
function t1.value32()
    if t1.value29 then
        t1.value29:Disconnect()
        t1.value29 = nil
    end
end
v9:Toggle({
	Title = "Auto Jump",
	Value = false,
	Callback = function(p10)
    t1.value30 = p10

    if t1.value30 then
        t1.value31()
        t1.value1:Notify({
				Title = "Auto Jump",
				Content = "Ativado!",
				Duration = 2
			})

        return
    end

    t1.value32()
    t1.value1:Notify({
			Title = "Auto Jump",
			Content = "Desativado!",
			Duration = 2
		})
end
})
t1.value33 = nil
t1.value34 = false
t1.value35 = {}
t1.value33 = {}
t1.value36 = nil
t1.value37 = nil
function t1.value37(p11)
    if not p11 then
        return Color3.fromRGB(255, 0, 0)
    end

    if p11.Team and p11.TeamColor then
        return p11.TeamColor.Color
    end

    local leaderstats = p11:FindFirstChild("leaderstats")

    if leaderstats then
        for _, v in ipairs({
			"Time",
			"Team",
			"Equipe",
			"Faction",
			"Clan",
			"Grupo",
			"Squad",
			"Group"
		}) do
            local v2 = leaderstats:FindFirstChild(v)

            if v2 and v2:FindFirstChild("TeamColor") then
                return v2.TeamColor.Color
            end
        end
    end

    local TeamColor = p11:GetAttribute("TeamColor")

    if TeamColor then
        if typeof(TeamColor) == "Color3" then
            return TeamColor
        end

        if typeof(TeamColor) == "BrickColor" then
            return TeamColor.Color
        end
    end

    if p11.Team then
        local v417 = p11.Team.Name:lower()

        if v417:find("red") or v417:find("vermelho") then
            return Color3.fromRGB(255, 0, 0)
        end

        if v417:find("blue") or v417:find("azul") then
            return Color3.fromRGB(0, 100, 255)
        end

        if v417:find("green") or v417:find("verde") then
            return Color3.fromRGB(0, 255, 0)
        end

        if v417:find("yellow") or v417:find("amarelo") then
            return Color3.fromRGB(255, 255, 0)
        end

        if v417:find("white") or v417:find("branco") then
            return Color3.fromRGB(255, 255, 255)
        end

        if v417:find("black") or v417:find("preto") then
            return Color3.fromRGB(50, 50, 50)
        end
    end

    math.randomseed(p11.UserId)

    return Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
end
function t1.value38(p12)
    if p12 == t1.value21 then
        return
    end

    if t1.value35[p12] then
        return
    end

    local v431 = t1.value37(p12)
    local drawing = Drawing.new("Square")

    drawing.Visible = false
    drawing.Thickness = 1.5
    drawing.Color = v431
    drawing.Transparency = 1
    drawing.Filled = false

    local drawing2 = Drawing.new("Text")

    drawing2.Visible = false
    drawing2.Size = 14
    drawing2.Color = Color3.fromRGB(255, 255, 255)
    drawing2.Transparency = 1
    drawing2.Center = true
    drawing2.Outline = true
    drawing2.OutlineColor = Color3.fromRGB(0, 0, 0)
    t1.value35[p12] = drawing
    t1.value33[p12] = drawing2
end
function t1.value39(p13)
    if t1.value35[p13] then
        t1.value35[p13]:Remove()
        t1.value35[p13] = nil
    end

    if t1.value33[p13] then
        t1.value33[p13]:Remove()
        t1.value33[p13] = nil
    end
end
function t1.value40()
    for k, v in pairs(t1.value35) do
        local v421 = k

        if not v421.Character or not v421.Parent then
            v.Visible = false

            if t1.value33[v421] then
                t1.value33[v421].Visible = false
            end
        else
            local HumanoidRootPart = v421.Character:FindFirstChild("HumanoidRootPart")
            local Head = v421.Character:FindFirstChild("Head")

            if not HumanoidRootPart or not Head then
                v.Visible = false

                if t1.value33[v421] then
                    t1.value33[v421].Visible = false
                end
            else
                local v424, v425 = t1.value23:WorldToViewportPoint(HumanoidRootPart.Position)
                local v426 = t1.value23:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
                local v427 = t1.value23:WorldToViewportPoint(HumanoidRootPart.Position - Vector3.new(0, 3, 0))

                if v425 then
                    v.Color = t1.value37(v421)

                    local v428 = math.abs(v426.Y - v427.Y)
                    local v429 = v428 * 0.5

                    v.Size = Vector2.new(v429, v428)
                    v.Position = Vector2.new(v424.X - v429 / 2, v424.Y - v428 / 2)
                    v.Visible = true

                    if t1.value33[v421] then
                        t1.value33[v421].Text = v421.Name
                        t1.value33[v421].Position = Vector2.new(v424.X, v424.Y - v428 / 2 - 16)
                        t1.value33[v421].Visible = true
                    end
                else
                    v.Visible = false

                    if t1.value33[v421] then
                        t1.value33[v421].Visible = false
                    end
                end
            end
        end
    end
end
v9:Toggle({
	Title = "ESP",
	Value = false,
	Callback = function(p14)
    t1.value34 = p14

    if t1.value34 then
        for _, player in ipairs(t1.value20:GetPlayers()) do
            t1.value38(player)
        end

        if t1.value36 then
            t1.value36:Disconnect()
        end

        t1.value36 = t1.value22.RenderStepped:Connect(t1.value40)

        return
    end

    if t1.value36 then
        t1.value36:Disconnect()
    end

    for k, _ in pairs(t1.value35) do
        t1.value39(k)
    end
end
})
t1.value20.PlayerAdded:Connect(function(player)
    if t1.value34 then
        t1.value38(player)
    end
end)
t1.value20.PlayerRemoving:Connect(function(player)
    t1.value39(player)
end)
t1.value41 = nil
t1.value42 = nil
t1.value42 = false
t1.value41 = nil
function t1.value43()
    t1.value41 = game:GetService("RunService").Heartbeat:Connect(function()
        if not t1.value42 then
            return
        end

        pcall(function()
            local v537 = workspace:FindFirstChild("Map") and (workspace.Map:FindFirstChild("ScannerDeArmas") and workspace.Map.ScannerDeArmas:FindFirstChild("Scanner"))

            if v537 and v537:FindFirstChild("Scan") then
                local Scan = v537.Scan

                if Scan and Scan:IsA("BasePart") then
                    Scan:Destroy()
                end
            end
        end)
    end)
end
function t1.value44()
    if t1.value41 then
        t1.value41:Disconnect()
        t1.value41 = nil
    end
end
v10:Toggle({
	Title = "Anti Scan",
	Value = false,
	Callback = function(p15)
    t1.value42 = p15

    if t1.value42 then
        t1.value43()
        t1.value1:Notify({
				Title = "Anti Scan",
				Content = "Ativado!",
				Duration = 2
			})

        return
    end

    t1.value44()
    t1.value1:Notify({
			Title = "Anti Scan",
			Content = "Desativado!",
			Duration = 2
		})
end
})
t1.value45 = false
t1.value46 = {}
t1.value47 = nil
t1.value48 = {}
function t1.value49()
    local t122 = {}
    local Map = workspace:FindFirstChild("Map")

    if not Map then
        return t122
    end

    local function v446(p16)
        if p16 and p16:IsA("BasePart") or (p16:IsA("UnionOperation") or p16:IsA("MeshPart")) then
            t122[p16] = true
        end
    end

    v446(Map:FindFirstChild("BaseNeve"))

    local children = Map:GetChildren()

    v446(children[576])
    v446(children[880])
    v446(children[418])
    v446(children[391])

    local ConfigurationFolder = Map:FindFirstChild("ConfigurationFolder")

    if ConfigurationFolder then
        local DetalhesV2 = ConfigurationFolder:FindFirstChild("DetalhesV2")

        if DetalhesV2 then
            local children2 = DetalhesV2:GetChildren()

            if children2[7] then
                v446(children2[7]:GetChildren()[2])
            end

            local Model = DetalhesV2:FindFirstChild("Model")

            if Model then
                v446(Model:GetChildren()[2])
            end
        end
    end

    return t122
end
t1.value50 = nil
function t1.value50(p17, p18, p19)
    if not p17:IsA("BasePart") and (not p17:IsA("UnionOperation") and not p17:IsA("MeshPart")) then
        return
    end

    if p19[p17] then
        return
    end

    if p18 then
        if not t1.value46[p17] then
            local value46 = t1.value46
            local CanCollide = p17.CanCollide
            local CanQuery = p17.CanQuery
            local CanTouch = p17.CanTouch
            local p17Transparency = p17.Transparency

            value46[p17] = {
				CanCollide = CanCollide,
				CanQuery = CanQuery,
				CanTouch = CanTouch,
				Transparency = p17Transparency
			}
        end

        p17.CanCollide = false
        p17.CanQuery = false
        p17.CanTouch = false
        p17.Transparency = 0.7
        t1.value48[p17] = true

        return
    end

    local v460 = t1.value46[p17]

    if v460 then
        p17.CanCollide = v460.CanCollide
        p17.CanQuery = v460.CanQuery
        p17.CanTouch = v460.CanTouch
        p17.Transparency = v460.Transparency
    end

    t1.value48[p17] = nil
end
function t1.value51()
    local v461 = t1.value49()
    for v464 in pairs(v461) do

        if not t1.value46[v464] then
            local value46 = t1.value46
            local CanCollide = v464.CanCollide
            local CanQuery = v464.CanQuery
            local CanTouch = v464.CanTouch
            local Transparency = v464.Transparency
            local Size = v464.Size

            value46[v464] = {
				CanCollide = CanCollide,
				CanQuery = CanQuery,
				CanTouch = CanTouch,
				Transparency = Transparency,
				Size = Size
			}
        end

        v464.Size = Vector3.new(2048, v464.Size.Y, 2048)
        t1.value48[v464] = true
    end
    for _, descendant in ipairs(workspace:GetDescendants()) do
        t1.value50(descendant, true, v461)
    end
    t1.value47 = workspace.DescendantAdded:Connect(function(descendant)
        if t1.value45 then
            t1.value50(descendant, true, v461)
        end
    end)
end
function t1.value52()
    if t1.value47 then
        t1.value47:Disconnect()
    end

    for k in pairs(t1.value48) do
        local v474 = k

        if v474 and v474.Parent then
            local v475 = t1.value46[v474]

            if v475 then
                v474.CanCollide = v475.CanCollide
                v474.CanQuery = v475.CanQuery
                v474.CanTouch = v475.CanTouch
                v474.Transparency = v475.Transparency

                if v475.Size then
                    v474.Size = v475.Size
                end
            end
        end
    end
end
v10:Toggle({
	Title = "Ghost Form",
	Value = false,
	Callback = function(p20)
    t1.value45 = p20

    if t1.value45 then
        t1.value51()
        t1.value1:Notify({
				Title = "Ghost Form",
				Content = "Ativado!",
				Duration = 2
			})

        return
    end

    t1.value52()
    t1.value1:Notify({
			Title = "Ghost Form",
			Content = "Desativado!",
			Duration = 2
		})
end
})
v10:Input({
	Title = "Informe o saldo",
	Value = "0",
	Callback = function(p21)
    local num = tonumber(p21)

    if num then
        local Dinheiro = game:GetService("Players").LocalPlayer.leaderstats:FindFirstChild("Dinheiro")

        if Dinheiro then
            Dinheiro.Value = num

            local value1 = t1.value1
            local v481 = "Saldo alterado para: " .. num

            value1:Notify({
					Title = "Money",
					Content = v481,
					Duration = 2
				})

            return
        end

        t1.value1:Notify({
				Title = "Erro",
				Content = "Leaderstats 'Dinheiro' não encontrado",
				Duration = 2
			})

        return
    end

    t1.value1:Notify({
			Title = "Erro",
			Content = "Valor inválido",
			Duration = 2
		})
end
})
v10:Input({
	Title = "Informe o level",
	Value = "0",
	Callback = function(p22)
    local num = tonumber(p22)

    if num then
        local Level = game:GetService("Players").LocalPlayer.leaderstats:FindFirstChild("Level")

        if Level then
            Level.Value = num

            local value1 = t1.value1
            local v486 = "Level alterado para: " .. num

            value1:Notify({
					Title = "Level",
					Content = v486,
					Duration = 2
				})

            return
        end

        t1.value1:Notify({
				Title = "Erro",
				Content = "Leaderstats 'Level' não encontrado",
				Duration = 2
			})

        return
    end

    t1.value1:Notify({
			Title = "Erro",
			Content = "Valor inválido",
			Duration = 2
		})
end
})
t1.value53 = false
function t1.value54()
    pcall(function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
    end)
    pcall(function()
        local ChatWindowConfiguration = game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration")

        if ChatWindowConfiguration then
            ChatWindowConfiguration.Enabled = true
        end
    end)

    local PlayerGui = t1.value21:FindFirstChild("PlayerGui")

    if PlayerGui then
        local GetDescendants = PlayerGui.GetDescendants

        for _, v in ipairs(GetDescendants(PlayerGui)) do
            if v:IsA("GuiObject") then
                local v491 = v.Name:lower()

                if v491:find("chat") and (not v491:find("button") and not v491:find("toggle")) then
                    v.Visible = true
                    v.ZIndex = 999
                end
            end
        end
    end
end
function t1.value55()
    local PlayerGui = t1.value21:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return
    end

    if PlayerGui:FindFirstChild("CustomChat") then
        return
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "CustomChat"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")

    Frame.Size = UDim2.new(0, 340, 0, 210)
    Frame.Position = UDim2.new(0, 8, 0, 8)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 100
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, 0, 0, 22)
    TextLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextLabel.Text = " CHAT"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = Frame
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 6)

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Messages"
    ScrollingFrame.Size = UDim2.new(1, -8, 1, -55)
    ScrollingFrame.Position = UDim2.new(0, 4, 0, 26)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.ScrollBarThickness = 3
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.Parent = Frame
    Instance.new("UIListLayout", ScrollingFrame).Padding = UDim.new(0, 3)

    local TextBox = Instance.new("TextBox")

    TextBox.Size = UDim2.new(1, -8, 0, 22)
    TextBox.Position = UDim2.new(0, 4, 1, -26)
    TextBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "Digite aqui..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    TextBox.TextSize = 12
    TextBox.Font = Enum.Font.Gotham
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = Frame
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

    local TextButton = Instance.new("TextButton")

    TextButton.Size = UDim2.new(0, 36, 0, 36)
    TextButton.Position = UDim2.new(0, 8, 0, 225)
    TextButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextButton.Text = ""
    TextButton.TextSize = 18
    TextButton.Parent = ScreenGui
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(1, 0)

    local TextLabel2 = Instance.new("TextLabel")

    TextLabel2.Size = UDim2.new(1, 0, 1, 0)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = ""
    TextLabel2.TextSize = 18
    TextLabel2.Parent = TextButton
    TextButton.MouseButton1Click:Connect(function()
        Frame.Visible = not Frame.Visible
        TextLabel2.Text = not Frame.Visible and "" or ""
    end)

    local TextButton2 = Instance.new("TextButton")

    TextButton2.Size = UDim2.new(0, 22, 0, 22)
    TextButton2.Position = UDim2.new(1, -24, 0, 0)
    TextButton2.BackgroundTransparency = 1
    TextButton2.Text = "X"
    TextButton2.TextColor3 = Color3.fromRGB(255, 80, 80)
    TextButton2.TextSize = 12
    TextButton2.Parent = TextLabel
    TextButton2.MouseButton1Click:Connect(function()
        Frame.Visible = false
        TextLabel2.Text = ""
    end)

    local function v501(p23, p24)
        local TextLabel3 = Instance.new("TextLabel")

        TextLabel3.Size = UDim2.new(1, -4, 0, 16)
        TextLabel3.BackgroundTransparency = 1
        TextLabel3.Text = p23

        if not p24 then
            p24 = Color3.fromRGB(220, 220, 220)
        end

        TextLabel3.TextColor3 = p24
        TextLabel3.TextSize = 11
        TextLabel3.Font = Enum.Font.Gotham
        TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel3.TextWrapped = true
        TextLabel3.AutomaticSize = Enum.AutomaticSize.Y
        TextLabel3.Parent = ScrollingFrame
        task.delay(0.05, function()
            ScrollingFrame.CanvasPosition = Vector2.new(0, ScrollingFrame.AbsoluteCanvasSize.Y)
        end)
    end

    pcall(function()
        game:GetService("TextChatService").MessageReceived:Connect(function(p25)
            local TextSource = p25.TextSource
            local v541 = TextSource and TextSource.Name or "Sistema"
            local v542 = TextSource and (TextSource.UserId == t1.value21.UserId and Color3.fromRGB(100, 200, 255)) or Color3.fromRGB(220, 220, 220)

            v501("[" .. v541 .. ("]: " .. p25.Text or ""), v542)
        end)
    end)
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            enterPressed = TextBox.Text ~= ""
        end

        if enterPressed then
            pcall(function()
                local RBXGeneral = game:GetService("TextChatService").TextChannels:FindFirstChild("RBXGeneral")

                if RBXGeneral then
                    RBXGeneral:SendAsync(TextBox.Text)

                    return
                end

                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(TextBox.Text, "All")
            end)
            TextBox.Text = ""
        end
    end)
    v501("Chat ativado!", Color3.fromRGB(0, 255, 100))
end
v10:Toggle({
	Title = "Show chat",
	Value = false,
	Callback = function(p26)
    t1.value53 = p26

    if t1.value53 then
        t1.value54()
        t1.value55()
        task.spawn(function()
            while t1.value53 do
                t1.value54()
                task.wait(2)
            end
        end)

        return
    end

    local PlayerGui = t1.value21:FindFirstChild("PlayerGui")

    if PlayerGui then
        local CustomChat = PlayerGui:FindFirstChild("CustomChat")

        if CustomChat then
            CustomChat:Destroy()
        end
    end
end
})
t1.value56 = true
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.K then
        t1.value56 = not t1.value56
        t1.value2:ToggleVisibility()
    end
end)
