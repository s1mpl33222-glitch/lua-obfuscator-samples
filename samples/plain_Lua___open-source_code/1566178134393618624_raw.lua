do
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local player = Players.LocalPlayer
    local parent

    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok then parent = result end
    end
    if not parent then
        local ok, result = pcall(function() return game:GetService("CoreGui") end)
        if ok then parent = result end
    end
    if not parent and player then
        parent = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 5)
    end
    if not parent then
        warn("[VoidedX] This vault was removed or deleted. Contact the owner for support.")
        return
    end

    local oldGui = parent:FindFirstChild("VoidedXRemovedVaultWarning")
    if oldGui then oldGui:Destroy() end

    local EASE_OUT = Enum.EasingStyle.Quint
    local EASE_BACK = Enum.EasingStyle.Back
    local COL_INK = Color3.fromRGB(9, 11, 17)
    local COL_CARD = Color3.fromRGB(13, 16, 24)
    local COL_LINE = Color3.fromRGB(45, 52, 70)
    local COL_MUTED = Color3.fromRGB(148, 163, 184)
    local COL_TEXT = Color3.fromRGB(248, 250, 252)
    local COL_WARN = Color3.fromRGB(248, 113, 113)
    local COL_AMBER = Color3.fromRGB(245, 158, 11)

    local gui = Instance.new("ScreenGui")
    gui.Name = "VoidedXRemovedVaultWarning"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local shade = Instance.new("Frame")
    shade.Name = "Shade"
    shade.Size = UDim2.fromScale(1, 1)
    shade.BackgroundColor3 = Color3.fromRGB(3, 6, 12)
    shade.BackgroundTransparency = 1
    shade.BorderSizePixel = 0
    shade.Parent = gui

    local card = Instance.new("Frame")
    card.Name = "WarningCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0.88, 0, 0, 250)
    card.BackgroundColor3 = COL_CARD
    card.BorderSizePixel = 0
    card.Parent = shade

    local sizeLimit = Instance.new("UISizeConstraint")
    sizeLimit.MaxSize = Vector2.new(430, 250)
    sizeLimit.Parent = card

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 18)
    cardCorner.Parent = card

    local outline = Instance.new("UIStroke")
    outline.Color = COL_LINE
    outline.Thickness = 1
    outline.Transparency = 0.15
    outline.Parent = card

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 3)
    accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accent.BorderSizePixel = 0
    accent.Parent = card
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 18)
    accentCorner.Parent = accent
    local accentGradient = Instance.new("UIGradient")
    accentGradient.Color = ColorSequence.new(COL_WARN, COL_AMBER)
    accentGradient.Parent = accent

    local brand = Instance.new("Frame")
    brand.Size = UDim2.new(0, 38, 0, 38)
    brand.Position = UDim2.new(0, 20, 0, 22)
    brand.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    brand.BorderSizePixel = 0
    brand.Parent = card
    local brandCorner = Instance.new("UICorner")
    brandCorner.CornerRadius = UDim.new(0, 12)
    brandCorner.Parent = brand
    local brandGradient = Instance.new("UIGradient")
    brandGradient.Rotation = 45
    brandGradient.Color = ColorSequence.new(COL_WARN, COL_AMBER)
    brandGradient.Parent = brand
    local brandLetter = Instance.new("TextLabel")
    brandLetter.Size = UDim2.fromScale(1, 1)
    brandLetter.BackgroundTransparency = 1
    brandLetter.Text = "!"
    brandLetter.TextColor3 = COL_INK
    brandLetter.Font = Enum.Font.GothamBold
    brandLetter.TextSize = 20
    brandLetter.Parent = brand

    local eyebrow = Instance.new("TextLabel")
    eyebrow.Size = UDim2.new(1, -96, 0, 12)
    eyebrow.Position = UDim2.new(0, 70, 0, 22)
    eyebrow.BackgroundTransparency = 1
    eyebrow.Text = "VOIDEDX // SECURE ACCESS"
    eyebrow.TextColor3 = COL_WARN
    eyebrow.Font = Enum.Font.GothamBold
    eyebrow.TextSize = 8
    eyebrow.TextXAlignment = Enum.TextXAlignment.Left
    eyebrow.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -96, 0, 24)
    title.Position = UDim2.new(0, 70, 0, 35)
    title.BackgroundTransparency = 1
    title.Text = "VAULT OFFLINE"
    title.TextColor3 = COL_TEXT
    title.Font = Enum.Font.GothamBold
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.Parent = card

    local chip = Instance.new("Frame")
    chip.AnchorPoint = Vector2.new(1, 0)
    chip.Position = UDim2.new(1, -20, 0, 26)
    chip.Size = UDim2.new(0, 78, 0, 20)
    chip.BackgroundColor3 = Color3.fromRGB(69, 26, 26)
    chip.BackgroundTransparency = 0.35
    chip.BorderSizePixel = 0
    chip.Parent = card
    local chipCorner = Instance.new("UICorner")
    chipCorner.CornerRadius = UDim.new(0, 6)
    chipCorner.Parent = chip
    local chipDot = Instance.new("Frame")
    chipDot.Position = UDim2.new(0, 8, 0.5, -3)
    chipDot.Size = UDim2.new(0, 6, 0, 6)
    chipDot.BackgroundColor3 = COL_WARN
    chipDot.BorderSizePixel = 0
    chipDot.Parent = chip
    local chipDotCorner = Instance.new("UICorner")
    chipDotCorner.CornerRadius = UDim.new(1, 0)
    chipDotCorner.Parent = chipDot
    local chipLabel = Instance.new("TextLabel")
    chipLabel.Position = UDim2.new(0, 19, 0, 0)
    chipLabel.Size = UDim2.new(1, -24, 1, 0)
    chipLabel.BackgroundTransparency = 1
    chipLabel.Text = "OFFLINE"
    chipLabel.TextColor3 = COL_WARN
    chipLabel.Font = Enum.Font.GothamBold
    chipLabel.TextSize = 9
    chipLabel.TextXAlignment = Enum.TextXAlignment.Left
    chipLabel.Parent = chip

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -44, 0, 64)
    message.Position = UDim2.new(0, 22, 0, 78)
    message.BackgroundTransparency = 1
    message.Text = "This vault was removed or deleted by its owner, so this loader can no longer deliver its script."
    message.TextColor3 = COL_MUTED
    message.Font = Enum.Font.Gotham
    message.TextSize = 13
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.Parent = card

    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -44, 0, 16)
    hint.Position = UDim2.new(0, 22, 0, 150)
    hint.BackgroundTransparency = 1
    hint.Text = "Contact the owner for a new link."
    hint.TextColor3 = COL_TEXT
    hint.Font = Enum.Font.GothamSemibold
    hint.TextSize = 11
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.TextTruncate = Enum.TextTruncate.AtEnd
    hint.Parent = card

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -44, 0, 1)
    divider.Position = UDim2.new(0, 22, 0, 178)
    divider.BackgroundColor3 = COL_LINE
    divider.BackgroundTransparency = 0.45
    divider.BorderSizePixel = 0
    divider.Parent = card

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(1, -44, 0, 38)
    close.Position = UDim2.new(0, 22, 0, 192)
    close.BackgroundColor3 = Color3.fromRGB(28, 33, 45)
    close.BorderSizePixel = 0
    close.Text = "DISMISS"
    close.TextColor3 = COL_TEXT
    close.Font = Enum.Font.GothamBold
    close.TextSize = 11
    close.AutoButtonColor = false
    close.Parent = card
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = close
    local closeStroke = Instance.new("UIStroke")
    closeStroke.Color = COL_LINE
    closeStroke.Transparency = 0.25
    closeStroke.Parent = close
    local closeScale = Instance.new("UIScale")
    closeScale.Parent = close

    local footer = Instance.new("TextLabel")
    footer.Size = UDim2.new(1, -44, 0, 10)
    footer.Position = UDim2.new(0, 22, 0, 234)
    footer.BackgroundTransparency = 1
    footer.Text = "PROTECTED BY VOIDEDX ARMOR"
    footer.TextColor3 = COL_MUTED
    footer.Font = Enum.Font.GothamBold
    footer.TextSize = 8
    footer.Parent = card

    local introTexts = { brandLetter, eyebrow, title, chipLabel, message, hint, close, footer }
    for _, textObject in ipairs(introTexts) do
        textObject.TextTransparency = 1
    end

    local uiScale = Instance.new("UIScale")
    uiScale.Scale = 0.92
    uiScale.Parent = card
    TweenService:Create(uiScale, TweenInfo.new(0.42, EASE_BACK), { Scale = 1 }):Play()
    TweenService:Create(shade, TweenInfo.new(0.3, EASE_OUT), { BackgroundTransparency = 0.35 }):Play()
    TweenService:Create(outline, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.45 }):Play()

    task.spawn(function()
        task.wait(0.1)
        for _, textObject in ipairs(introTexts) do
            if textObject.Parent then
                TweenService:Create(textObject, TweenInfo.new(0.22, EASE_OUT), { TextTransparency = 0 }):Play()
            end
            task.wait(0.04)
        end
    end)

    close.MouseEnter:Connect(function()
        TweenService:Create(closeScale, TweenInfo.new(0.14, EASE_OUT), { Scale = 1.015 }):Play()
        TweenService:Create(closeStroke, TweenInfo.new(0.14, EASE_OUT), { Color = COL_WARN, Transparency = 0 }):Play()
    end)
    close.MouseLeave:Connect(function()
        TweenService:Create(closeScale, TweenInfo.new(0.14, EASE_OUT), { Scale = 1 }):Play()
        TweenService:Create(closeStroke, TweenInfo.new(0.14, EASE_OUT), { Color = COL_LINE, Transparency = 0.25 }):Play()
    end)
    close.Activated:Connect(function()
        close.Active = false
        TweenService:Create(uiScale, TweenInfo.new(0.2, EASE_OUT), { Scale = 0.94 }):Play()
        TweenService:Create(card, TweenInfo.new(0.22, EASE_OUT), { Position = UDim2.new(0.5, 0, 0.5, 14) }):Play()
        TweenService:Create(shade, TweenInfo.new(0.24, EASE_OUT), { BackgroundTransparency = 1 }):Play()
        task.wait(0.2)
        gui:Destroy()
    end)

    gui.Parent = parent
end