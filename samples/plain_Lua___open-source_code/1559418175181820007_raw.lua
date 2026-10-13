do
    local Players = game:GetService("Players")
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
    shade.BackgroundTransparency = 0.35
    shade.BorderSizePixel = 0
    shade.Parent = gui

    local card = Instance.new("Frame")
    card.Name = "WarningCard"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.Size = UDim2.new(0.88, 0, 0, 208)
    card.BackgroundColor3 = Color3.fromRGB(15, 18, 27)
    card.BorderSizePixel = 0
    card.Parent = shade

    local sizeLimit = Instance.new("UISizeConstraint")
    sizeLimit.MaxSize = Vector2.new(420, 240)
    sizeLimit.Parent = card

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = card

    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(55, 65, 81)
    outline.Thickness = 1
    outline.Parent = card

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 4)
    accent.BackgroundColor3 = Color3.fromRGB(245, 158, 11)
    accent.BorderSizePixel = 0
    accent.Parent = card

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 14)
    accentCorner.Parent = accent

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 20, 0, 22)
    icon.BackgroundColor3 = Color3.fromRGB(74, 52, 13)
    icon.Text = "!"
    icon.TextColor3 = Color3.fromRGB(251, 191, 36)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 18
    icon.Parent = card
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -92, 0, 34)
    title.Position = UDim2.new(0, 60, 0, 20)
    title.BackgroundTransparency = 1
    title.Text = "VAULT REMOVED"
    title.TextColor3 = Color3.fromRGB(248, 250, 252)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 17
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -40, 0, 72)
    message.Position = UDim2.new(0, 20, 0, 68)
    message.BackgroundTransparency = 1
    message.Text = "This vault has been removed or deleted. Contact the owner for support."
    message.TextColor3 = Color3.fromRGB(190, 200, 216)
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Left
    message.TextYAlignment = Enum.TextYAlignment.Top
    message.Parent = card

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(1, -40, 0, 38)
    close.Position = UDim2.new(0, 20, 1, -54)
    close.BackgroundColor3 = Color3.fromRGB(31, 41, 55)
    close.BorderSizePixel = 0
    close.Text = "CLOSE"
    close.TextColor3 = Color3.fromRGB(248, 250, 252)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    close.AutoButtonColor = true
    close.Parent = card

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = close
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    gui.Parent = parent
end