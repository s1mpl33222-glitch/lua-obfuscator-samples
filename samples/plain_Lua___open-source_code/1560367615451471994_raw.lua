task.spawn(function()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    if CoreGui:FindFirstChild("TOP7_CleanKey") then
        CoreGui.TOP7_CleanKey:Destroy()
    end
    if CoreGui:FindFirstChild("TOP7_FullMain") then
        CoreGui.TOP7_FullMain:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TOP7_CleanKey"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    
    pcall(function()
        screenGui.Parent = CoreGui
    end)
    if not screenGui.Parent then
        screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 160)
    frame.Position = UDim2.new(0.5, -130, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0.85, 0, 0, 28)
    discordBtn.Position = UDim2.new(0.075, 0, 0, 20)
    discordBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    discordBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
    discordBtn.Text = "نسخ رابط الديسكورد للمفتاح"
    discordBtn.TextSize = 11
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = discordBtn

    discordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/top7")
        end
        discordBtn.Text = "تم النسخ!"
        task.wait(1.5)
        discordBtn.Text = "نسخ رابط الديسكورد للمفتاح"
    end)

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.85, 0, 0, 30)
    textBox.Position = UDim2.new(0.075, 0, 0, 56)
    textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderText = "اكتب المفتاح هنا..."
    textBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    textBox.Text = ""
    textBox.TextSize = 12
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = textBox

    local checkBtn = Instance.new("TextButton")
    checkBtn.Size = UDim2.new(0.85, 0, 0, 30)
    checkBtn.Position = UDim2.new(0.075, 0, 0, 92)
    checkBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkBtn.Text = "تحقق"
    checkBtn.TextSize = 12
    checkBtn.Font = Enum.Font.GothamBold
    checkBtn.Parent = frame

    local checkCorner = Instance.new("UICorner")
    checkCorner.CornerRadius = UDim.new(0, 6)
    checkCorner.Parent = checkBtn

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, 0, 0, 20)
    msg.Position = UDim2.new(0, 0, 0, 128)
    msg.BackgroundTransparency = 1
    msg.Text = ""
    msg.TextColor3 = Color3.fromRGB(255, 70, 70)
    msg.TextSize = 11
    msg.Font = Enum.Font.GothamBold
    msg.Parent = frame

    local CORRECT_KEY = "TOP7"

    local function openMain()
        screenGui:Destroy()

        local mainScreenGui = Instance.new("ScreenGui")
        mainScreenGui.Name = "TOP7_FullMain"
        mainScreenGui.ResetOnSpawn = false
        mainScreenGui.IgnoreGuiInset = true
        mainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        pcall(function()
            mainScreenGui.Parent = CoreGui
        end)
        if not mainScreenGui.Parent then
            mainScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        end

        -- تم تصغير حجم المربع الرئيسي هنا ليصبح مرتباً وغير مزعج على الشاشة
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 260, 0, 290)
        mainFrame.Position = UDim2.new(0.5, -130, 0.5, -145)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = mainScreenGui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = mainFrame

        local topCredits = Instance.new("TextLabel")
        topCredits.Size = UDim2.new(1, 0, 0, 25)
        topCredits.Position = UDim2.new(0, 0, 0, 4)
        topCredits.BackgroundTransparency = 1
        topCredits.Text = "TOP7DD"
        topCredits.TextColor3 = Color3.fromRGB(255, 255, 255)
        topCredits.TextTransparency = 0.4
        topCredits.TextSize = 14
        topCredits.Font = Enum.Font.GothamBold
        topCredits.Parent = mainFrame

        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 25, 0, 25)
        closeButton.Position = UDim2.new(1, -28, 0, 4)
        closeButton.BackgroundTransparency = 1
        closeButton.Text = "X"
        closeButton.TextColor3 = Color3.fromRGB(255, 70, 70)
        closeButton.TextSize = 16
        closeButton.Font = Enum.Font.GothamBold
        closeButton.Parent = mainFrame

        closeButton.MouseButton1Click:Connect(function()
            mainScreenGui:Destroy()
        end)

        local hideToggleButton = Instance.new("TextButton")
        hideToggleButton.Size = UDim2.new(0, 25, 0, 25)
        hideToggleButton.Position = UDim2.new(1, -56, 0, 4)
        hideToggleButton.BackgroundTransparency = 1
        hideToggleButton.Text = "-"
        hideToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        hideToggleButton.TextSize = 18
        hideToggleButton.Font = Enum.Font.GothamBold
        hideToggleButton.Parent = mainFrame

        local contentElements = {}

        local myTextBox = Instance.new("TextBox")
        myTextBox.Size = UDim2.new(0.85, 0, 0, 28)
        myTextBox.Position = UDim2.new(0.075, 0, 0, 32)
        myTextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        myTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        myTextBox.PlaceholderText = "اسمك الوهمي..."
        myTextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        myTextBox.Text = ""
        myTextBox.TextSize = 11
        myTextBox.Font = Enum.Font.Gotham
        myTextBox.Parent = mainFrame
        table.insert(contentElements, myTextBox)

        local boxCorner1 = Instance.new("UICorner")
        boxCorner1.CornerRadius = UDim.new(0, 6)
        boxCorner1.Parent = myTextBox

        local myLevelBox = Instance.new("TextBox")
        myLevelBox.Size = UDim2.new(0.85, 0, 0, 28)
        myLevelBox.Position = UDim2.new(0.075, 0, 0, 64)
        myLevelBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        myLevelBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        myLevelBox.PlaceholderText = "لفلك الوهمي (حد 500)..."
        myLevelBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        myLevelBox.Text = ""
        myLevelBox.TextSize = 11
        myLevelBox.Font = Enum.Font.Gotham
        myLevelBox.Parent = mainFrame
        table.insert(contentElements, myLevelBox)

        local boxCornerLevel1 = Instance.new("UICorner")
        boxCornerLevel1.CornerRadius = UDim.new(0, 6)
        boxCornerLevel1.Parent = myLevelBox

        local applyMyBtn = Instance.new("TextButton")
        applyMyBtn.Size = UDim2.new(0.85, 0, 0, 26)
        applyMyBtn.Position = UDim2.new(0.075, 0, 0, 96)
        applyMyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        applyMyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        applyMyBtn.Text = "تطبيق اسمك ولفلك"
        applyMyBtn.TextSize = 11
        applyMyBtn.Font = Enum.Font.GothamBold
        applyMyBtn.Parent = mainFrame
        table.insert(contentElements, applyMyBtn)

        local btnCorner3 = Instance.new("UICorner")
        btnCorner3.CornerRadius = UDim.new(0, 6)
        btnCorner3.Parent = applyMyBtn

        local toggleDropdownBtn = Instance.new("TextButton")
        toggleDropdownBtn.Size = UDim2.new(0.85, 0, 0, 28)
        toggleDropdownBtn.Position = UDim2.new(0.075, 0, 0, 126)
        toggleDropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleDropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleDropdownBtn.Text = "اختيار لاعب ∨"
        toggleDropdownBtn.TextSize = 11
        toggleDropdownBtn.Font = Enum.Font.GothamBold
        toggleDropdownBtn.Parent = mainFrame
        table.insert(contentElements, toggleDropdownBtn)

        local dropBtnCorner = Instance.new("UICorner")
        dropBtnCorner.CornerRadius = UDim.new(0, 6)
        dropBtnCorner.Parent = toggleDropdownBtn

        local selectedTargetPlayer = nil
        local isDropdownOpen = false

        local playersScroll = Instance.new("ScrollingFrame")
        playersScroll.Size = UDim2.new(0.85, 0, 0, 70)
        playersScroll.Position = UDim2.new(0.075, 0, 0, 158)
        playersScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        playersScroll.BorderSizePixel = 0
        playersScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        playersScroll.ScrollBarThickness = 4
        playersScroll.Visible = false
        playersScroll.Parent = mainFrame
        table.insert(contentElements, playersScroll)

        local scrollCorner = Instance.new("UICorner")
        scrollCorner.CornerRadius = UDim.new(0, 6)
        scrollCorner.Parent = playersScroll

        local uiList = Instance.new("UIListLayout")
        uiList.SortOrder = Enum.SortOrder.LayoutOrder
        uiList.Padding = UDim.new(0, 3)
        uiList.Parent = playersScroll

        local function updatePlayerList()
            for _, child in ipairs(playersScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            for _, p in ipairs(Players:GetPlayers()) do
                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, 0, 0, 24)
                pBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                pBtn.Text = "  " .. p.Name
                pBtn.TextXAlignment = Enum.TextXAlignment.Left
                pBtn.TextSize = 11
                pBtn.Font = Enum.Font.Gotham
                pBtn.Parent = playersScroll
                
                local btnC = Instance.new("UICorner")
                btnC.CornerRadius = UDim.new(0, 4)
                btnC.Parent = pBtn
                
                pBtn.MouseButton1Click:Connect(function()
                    selectedTargetPlayer = p
                    toggleDropdownBtn.Text = "اللاعب: " .. p.Name .. " ∨"
                    for _, b in ipairs(playersScroll:GetChildren()) do
                        if b:IsA("TextButton") then
                            b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        end
                    end
                    pBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
                end)
            end
            playersScroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 26)
        end

        updatePlayerList()

        local fakeOtherBox = Instance.new("TextBox")
        fakeOtherBox.Size = UDim2.new(0.85, 0, 0, 28)
        fakeOtherBox.Position = UDim2.new(0.075, 0, 0, 158)
        fakeOtherBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        fakeOtherBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        fakeOtherBox.PlaceholderText = "الاسم الوهمي للاعب..."
        fakeOtherBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        fakeOtherBox.Text = ""
        fakeOtherBox.TextSize = 11
        fakeOtherBox.Font = Enum.Font.Gotham
        fakeOtherBox.Parent = mainFrame
        table.insert(contentElements, fakeOtherBox)

        local boxCorner2 = Instance.new("UICorner")
        boxCorner2.CornerRadius = UDim.new(0, 6)
        boxCorner2.Parent = fakeOtherBox

        local fakeOtherLevelBox = Instance.new("TextBox")
        fakeOtherLevelBox.Size = UDim2.new(0.85, 0, 0, 28)
        fakeOtherLevelBox.Position = UDim2.new(0.075, 0, 0, 190)
        fakeOtherLevelBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        fakeOtherLevelBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        fakeOtherLevelBox.PlaceholderText = "لفل اللاعب الوهمي..."
        fakeOtherLevelBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
        fakeOtherLevelBox.Text = ""
        fakeOtherLevelBox.TextSize = 11
        fakeOtherLevelBox.Font = Enum.Font.Gotham
        fakeOtherLevelBox.Parent = mainFrame
        table.insert(contentElements, fakeOtherLevelBox)

        local boxCornerLevel2 = Instance.new("UICorner")
        boxCornerLevel2.CornerRadius = UDim.new(0, 6)
        boxCornerLevel2.Parent = fakeOtherLevelBox

        local applyOtherBtn = Instance.new("TextButton")
        applyOtherBtn.Size = UDim2.new(0.85, 0, 0, 26)
        applyOtherBtn.Position = UDim2.new(0.075, 0, 0, 222)
        applyOtherBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        applyOtherBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        applyOtherBtn.Text = "تطبيق على اللاعب"
        applyOtherBtn.TextSize = 11
        applyOtherBtn.Font = Enum.Font.GothamBold
        applyOtherBtn.Parent = mainFrame
        table.insert(contentElements, applyOtherBtn)

        local btnCorner4 = Instance.new("UICorner")
        btnCorner4.CornerRadius = UDim.new(0, 6)
        btnCorner4.Parent = applyOtherBtn

        local discordBtnMain = Instance.new("TextButton")
        discordBtnMain.Size = UDim2.new(0.85, 0, 0, 24)
        discordBtnMain.Position = UDim2.new(0.075, 0, 0, 254)
        discordBtnMain.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        discordBtnMain.TextColor3 = Color3.fromRGB(100, 180, 255)
        discordBtnMain.Text = "discord.gg/top7"
        discordBtnMain.TextSize = 10
        discordBtnMain.Font = Enum.Font.GothamBold
        discordBtnMain.Parent = mainFrame
        table.insert(contentElements, discordBtnMain)

        local discordCorner = Instance.new("UICorner")
        discordCorner.CornerRadius = UDim.new(0, 6)
        discordCorner.Parent = discordBtnMain

        discordBtnMain.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard("https://discord.gg/top7")
            end
            discordBtnMain.Text = "تم النسخ!"
            task.wait(1.5)
            discordBtnMain.Text = "discord.gg/top7"
        end)

        toggleDropdownBtn.MouseButton1Click:Connect(function()
            isDropdownOpen = not isDropdownOpen
            if isDropdownOpen then
                playersScroll.Visible = true
                toggleDropdownBtn.Text = "اختيار لاعب ∧"
                mainFrame.Size = UDim2.new(0, 260, 0, 365)
                fakeOtherBox.Position = UDim2.new(0.075, 0, 0, 232)
                fakeOtherLevelBox.Position = UDim2.new(0.075, 0, 0, 264)
                applyOtherBtn.Position = UDim2.new(0.075, 0, 0, 296)
                discordBtnMain.Position = UDim2.new(0.075, 0, 0, 328)
            else
                playersScroll.Visible = false
                toggleDropdownBtn.Text = "اختيار لاعب ∨"
                mainFrame.Size = UDim2.new(0, 260, 0, 290)
                fakeOtherBox.Position = UDim2.new(0.075, 0, 0, 158)
                fakeOtherLevelBox.Position = UDim2.new(0.075, 0, 0, 190)
                applyOtherBtn.Position = UDim2.new(0.075, 0, 0, 222)
                discordBtnMain.Position = UDim2.new(0.075, 0, 0, 254)
            end
        end)

        local isUIVisible = true
        hideToggleButton.MouseButton1Click:Connect(function()
            isUIVisible = not isUIVisible
            for _, elem in ipairs(contentElements) do
                elem.Visible = isUIVisible
            end
            if isUIVisible then
                hideToggleButton.Text = "-"
                if isDropdownOpen then
                    mainFrame.Size = UDim2.new(0, 260, 0, 365)
                else
                    mainFrame.Size = UDim2.new(0, 260, 0, 290)
                end
            else
                hideToggleButton.Text = "+"
                mainFrame.Size = UDim2.new(0, 260, 0, 35)
            end
        end)

        applyMyBtn.MouseButton1Click:Connect(function()
            local fakeName = myTextBox.Text
            local levelText = myLevelBox.Text
            local character = localPlayer.Character
            
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if fakeName ~= "" and humanoid then
                    humanoid.DisplayName = fakeName
                    for _, d in ipairs(character:GetDescendants()) do
                        if d:IsA("TextLabel") and tonumber(d.Text) == nil then
                            d.Text = fakeName
                        end
                    end
                end
                
                if levelText ~= "" then
                    local lvlNum = tonumber(levelText)
                    if lvlNum then
                        if lvlNum > 500 then lvlNum = 500 end
                        for _, d in ipairs(character:GetDescendants()) do
                            if d:IsA("TextLabel") then
                                local val = tonumber(d.Text)
                                if val ~= nil then
                                    d.Text = tostring(lvlNum)
                                end
                            end
                        end
                    end
                end
            end
        end)

        applyOtherBtn.MouseButton1Click:Connect(function()
            local fakeName = fakeOtherBox.Text
            local levelText = fakeOtherLevelBox.Text
            
            if selectedTargetPlayer and selectedTargetPlayer.Character then
                local char = selectedTargetPlayer.Character
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                if fakeName ~= "" and hum then
                    hum.DisplayName = fakeName
                    for _, d in ipairs(char:GetDescendants()) do
                        if d:IsA("TextLabel") and tonumber(d.Text) == nil then
                            d.Text = fakeName
                        end
                    end
                end
                
                if levelText ~= "" then
                    local lvlNum = tonumber(levelText)
                    if lvlNum then
                        if lvlNum > 500 then lvlNum = 500 end
                        for _, d in ipairs(char:GetDescendants()) do
                            if d:IsA("TextLabel") then
                                local val = tonumber(d.Text)
                                if val ~= nil then
                                    d.Text = tostring(lvlNum)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    checkBtn.MouseButton1Click:Connect(function()
        if textBox.Text == CORRECT_KEY then
            msg.TextColor3 = Color3.fromRGB(70, 255, 70)
            msg.Text = "تم التحقق بنجاح!"
            task.wait(0.4)
            openMain()
        else
            msg.TextColor3 = Color3.fromRGB(255, 70, 70)
            msg.Text = "المفتاح غير صحيح!"
        end
    end)
end)
