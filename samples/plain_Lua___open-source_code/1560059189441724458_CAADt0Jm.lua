local P, WS = game:GetService("Players"), game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = P.LocalPlayer

-- كلمة السر الحصرية المخفية
local SECRET_KEY = "MR"

local success, err = pcall(function()
    -- تنظيف أي واجهة قديمة لمنع التداخل
    if LP.PlayerGui:FindFirstChild("LegendaryUltimateEggGui") then
        LP.PlayerGui.LegendaryUltimateEggGui:Destroy()
    end

    local G = Instance.new("ScreenGui")
    G.Name = "LegendaryUltimateEggGui"
    G.ResetOnSpawn = false
    G.DisplayOrder = 99999
    G.Parent = LP:WaitForChild("PlayerGui")

    ---------------------------------------------------------
    -- نافذة إدخال كلمة السر مع التوقيع من الأعلى
    ---------------------------------------------------------
    local KeyGui = Instance.new("Frame", G)
    KeyGui.Size = UDim2.new(0, 340, 0, 210)
    KeyGui.Position = UDim2.new(0.5, -170, 0.5, -105)
    KeyGui.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
    KeyGui.Active, KeyGui.Draggable = true, true
    Instance.new("UICorner", KeyGui).CornerRadius = UDim.new(0, 12)
    local keyStroke = Instance.new("UIStroke", KeyGui)
    keyStroke.Color = Color3.fromRGB(255, 215, 0)
    keyStroke.Thickness = 1.5

    -- التوقيع من فوق بخط طبيعي
    local SigTopLabel = Instance.new("TextLabel", KeyGui)
    SigTopLabel.Size = UDim2.new(1, 0, 0, 25)
    SigTopLabel.Position = UDim2.new(0, 0, 0, 8)
    SigTopLabel.BackgroundTransparency = 1
    SigTopLabel.Text = "تم تصنيع هذا السكريبت من قبل المطور محمد"
    SigTopLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SigTopLabel.Font = Enum.Font.Gotham
    SigTopLabel.TextSize = 10

    local KeyTitle = Instance.new("TextLabel", KeyGui)
    KeyTitle.Size = UDim2.new(1, 0, 0, 30)
    KeyTitle.Position = UDim2.new(0, 0, 0, 35)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Text = "🔐 أدخل كلمة السر الخاصة"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.TextSize = 11

    local KeyBox = Instance.new("TextBox", KeyGui)
    KeyBox.Size = UDim2.new(0.85, 0, 0, 40)
    KeyBox.Position = UDim2.new(0.075, 0, 0.42, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    KeyBox.PlaceholderText = "اكتب كلمة السر هنا..."
    KeyBox.Text = ""
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 13
    KeyBox.ClearTextOnFocus = false
    KeyBox.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

    local SubmitBtn = Instance.new("TextButton", KeyGui)
    SubmitBtn.Size = UDim2.new(0.85, 0, 0, 40)
    SubmitBtn.Position = UDim2.new(0.075, 0, 0.72, 0)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 140)
    SubmitBtn.Text = "تفعيل الدخول 🚀"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.TextSize = 13
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

    ---------------------------------------------------------
    -- القائمة الرئيسية
    ---------------------------------------------------------
    local MainFrame = Instance.new("Frame", G)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 390, 0, 310)
    MainFrame.Position = UDim2.new(0.5, -195, 0.5, -155)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.Visible = false
    MainFrame.Active, MainFrame.Draggable = true, true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 215, 0)

    -- زر فتح القائمة عند التصغير (-) بالخط الطبيعي واسم المطور محمد
    local OpenBtn = Instance.new("TextButton", G)
    OpenBtn.Size = UDim2.new(0, 240, 0, 30)
    OpenBtn.Position = UDim2.new(0.5, -120, 0, 10)
    OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    OpenBtn.Text = "تم تصنيع هذا السكريبت من قبل المطور محمد"
    OpenBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    OpenBtn.Font = Enum.Font.Gotham
    OpenBtn.TextSize = 10
    OpenBtn.Visible = false
    OpenBtn.Active, OpenBtn.Draggable = true, true
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", OpenBtn).Color = Color3.fromRGB(255, 165, 0)

    -- الشريط العلوي
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    TopBar.Active, TopBar.Draggable = true, true
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "👑 <font color='#FFD700'>المطور محمد</font> | قناص البيض"
    Title.RichText = true
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 11
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- زر الناقص (-) للتصغير
    local MinimizeBtn = Instance.new("TextButton", TopBar)
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -65, 0.5, -13)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    MinimizeBtn.Text = "-"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 14
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

    -- زر الإغلاق (X)
    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 28, 0, 26)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 10
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    MinimizeBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        OpenBtn.Visible = true
    end)

    OpenBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        OpenBtn.Visible = false
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        G:Destroy()
    end)

    -- التحقق من كلمة السر MR
    SubmitBtn.MouseButton1Click:Connect(function()
        if KeyBox.Text == SECRET_KEY then
            KeyGui:Destroy()
            MainFrame.Visible = true
        else
            SubmitBtn.Text = "❌ كلمة السر خطأ!"
            task.wait(1.5)
            SubmitBtn.Text = "تفعيل الدخول 🚀"
        end
    end)

    -- زر حفظ البيت (Base)
    local SetBaseBtn = Instance.new("TextButton", MainFrame)
    SetBaseBtn.Size = UDim2.new(0.92, 0, 0, 45)
    SetBaseBtn.Position = UDim2.new(0.04, 0, 0.16, 0)
    SetBaseBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 140)
    SetBaseBtn.Text = "🏠 حفظ موقع بيتك الحالي (Base)"
    SetBaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SetBaseBtn.Font = Enum.Font.GothamBold
    SetBaseBtn.TextSize = 12
    Instance.new("UICorner", SetBaseBtn).CornerRadius = UDim.new(0, 8)

    -- خانة البحث
    local TargetBox = Instance.new("TextBox", MainFrame)
    TargetBox.Size = UDim2.new(0.92, 0, 0, 42)
    TargetBox.Position = UDim2.new(0.04, 0, 0.40, 0)
    TargetBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TargetBox.Text = "Egg"
    TargetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TargetBox.Font = Enum.Font.Gotham
    TargetBox.TextSize = 13
    Instance.new("UICorner", TargetBox).CornerRadius = UDim.new(0, 8)

    -- زر القنص والفتح الحقيقي (القديم الأصلي 100%)
    local SnipBtn = Instance.new("TextButton", MainFrame)
    SnipBtn.Size = UDim2.new(0.92, 0, 0, 52)
    SnipBtn.Position = UDim2.new(0.04, 0, 0.65, 0)
    SnipBtn.BackgroundColor3 = Color3.fromRGB(40, 190, 75)
    SnipBtn.Text = "🚀 انطلق، افتح البيضة، وارجع للبيت"
    SnipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SnipBtn.Font = Enum.Font.GothamBold
    SnipBtn.TextSize = 13
    Instance.new("UICorner", SnipBtn).CornerRadius = UDim.new(0, 8)

    local savedBasePos = nil

    SetBaseBtn.MouseButton1Click:Connect(function()
        local char = LP.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedBasePos = char.HumanoidRootPart.CFrame
            SetBaseBtn.Text = "✅ تم حفظ البيت بنجاح!"
            task.wait(1.5)
            SetBaseBtn.Text = "🏠 حفظ موقع بيتك الحالي (Base)"
        end
    end)

    SnipBtn.MouseButton1Click:Connect(function()
        local char = LP.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        if not savedBasePos then
            savedBasePos = hrp.CFrame
        end

        local searchKey = TargetBox.Text:lower()
        local targetPart = nil
        local foundPrompt = nil

        -- بحث السكريبت القديم الأصلي بالكامل
        for _, v in pairs(WS:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local parentName = v.Parent and v.Parent.Name:lower() or ""
                if parentName:match(searchKey) or parentName:match("egg") or parentName:match("phoenix") then
                    local pPart = v.Parent:IsA("Model") and (v.Parent.PrimaryPart or v.Parent:FindFirstChildWhichIsA("BasePart")) or (v.Parent:IsA("BasePart") and v.Parent)
                    if pPart then
                        targetPart = pPart
                        foundPrompt = v
                        break
                    end
                end
            end
        end

        if not targetPart then
            for _, v in pairs(WS:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("Model") then
                    local nameL = v.Name:lower()
                    if nameL:match(searchKey) or nameL:match("egg") or nameL:match("phoenix") or nameL:match("legendary") then
                        local pPart = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or (v:IsA("BasePart") and v)
                        if pPart then
                            targetPart = pPart
                            break
                        end
                    end
                end
            end
        end

        if targetPart and targetPart.Parent then
            SnipBtn.Text = "🚶‍♂️ جاري الانتقال للبيضة..."
            
            hrp.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
            task.wait(0.4)

            SnipBtn.Text = "🎯 محاولة فتح البيضة..."

            if foundPrompt then
                pcall(function()
                    fireproximityprompt(foundPrompt)
                end)
            end

            pcall(function()
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (remote.Name:lower():match("egg") or remote.Name:lower():match("open") or remote.Name:lower():match("buy")) then
                        remote:FireServer(targetPart.Parent)
                    end
                end
            end)

            task.wait(0.8)
            SnipBtn.Text = "🏠 جارِ العودة للبيت..."
            task.wait(0.4)

            if savedBasePos then
                hrp.CFrame = savedBasePos
            end

            SnipBtn.Text = "✅ تم الانتهاء والرجوع للبيت بنجاح!"
            task.wait(2)
            SnipBtn.Text = "🚀 انطلق، افتح البيضة، وارجع للبيت"
        else
            SnipBtn.Text = "❌ لم يتم العثور على البيضة حالياً!"
            task.wait(1.5)
            SnipBtn.Text = "🚀 انطلق، افتح البيضة، وارجع للبيت"
        end
    end)
end)

if not success then
    warn("Error: " .. tostring(err))
end