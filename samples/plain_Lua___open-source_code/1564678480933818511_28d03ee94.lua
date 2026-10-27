local _slug = "28d03ee94"
local _t = "[ KeyGuard blocked unauthorized Script ]"
pcall(function() warn(_t .. " SCRIPT_UNAVAILABLE") end)
pcall(function()
    local exec, hwid, name = "Unknown", "none", "Unknown"
    pcall(function()
        if type(identifyexecutor) == "function" then exec = identifyexecutor() or "Unknown"
        elseif type(getexecutorname) == "function" then exec = getexecutorname() or "Unknown" end
    end)
    pcall(function()
        if type(gethwid) == "function" then hwid = gethwid() or "none"
        elseif type(getfingerprintid) == "function" then hwid = getfingerprintid() or "none"
        elseif type(getdeviceid) == "function" then hwid = getdeviceid() or "none" end
    end)
    pcall(function() name = game:GetService("Players").LocalPlayer.Name end)
    local gui = Instance.new("ScreenGui")
    gui.Name = game:GetService("HttpService"):GenerateGUID(false)
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 2147483647
    if type(protectgui) == "function" then pcall(protectgui, gui) end
    local parent
    pcall(function() if type(gethui) == "function" then parent = gethui() end end)
    gui.Parent = parent or game:GetService("CoreGui")
    local back = Instance.new("Frame")
    back.Size = UDim2.new(1, 0, 1, 0)
    back.BackgroundColor3 = Color3.new(0, 0, 0)
    back.BorderSizePixel = 0
    back.Active = true
    back.Parent = gui
    local col = Instance.new("Frame")
    col.AnchorPoint = Vector2.new(0.5, 0.5)
    col.Position = UDim2.new(0.5, 0, 0.5, 0)
    col.Size = UDim2.new(1, -32, 0, 0)
    col.AutomaticSize = Enum.AutomaticSize.Y
    col.BackgroundTransparency = 1
    col.Parent = back
    local list = Instance.new("UIListLayout")
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 6)
    list.Parent = col
    local lines = {
        "Executor Name: " .. tostring(exec),
        "Game ID: " .. tostring(game.PlaceId),
        "Slug ID: " .. _slug,
        "UUID: " .. tostring(hwid) .. "_" .. tostring(name),
        "",
        _t,
    }
    for i, t in ipairs(lines) do
        local l = Instance.new("TextLabel")
        l.LayoutOrder = i
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 0, 0)
        l.AutomaticSize = Enum.AutomaticSize.Y
        l.Font = Enum.Font.Code
        l.Text = t
        l.TextColor3 = (t == _t) and Color3.fromRGB(232, 86, 86) or Color3.fromRGB(220, 220, 220)
        l.TextSize = 16
        l.TextWrapped = true
        l.Parent = col
    end
end)