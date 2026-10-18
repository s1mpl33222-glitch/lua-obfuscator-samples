-- This file was generated at discord.gg/syncrypt

local t1 = {}
_G.__PropHubPremiumKeyOK = nil
_G.__PropHubPremiumKeyFailed = nil
local t2 = {
	value1 = "i am LEAK://GOD717",
	value2 = "prophubpremiums_key_v9.txt",
	value3 = false,
	value4 = {
		["c00lful"] = true,
		["c00iful"] = true
	}
}
function t2.value5(p1)
    return p1 == t2.value1
end
function t2.value6()
    if t2.value3 then
        return false
    end

    local readfile_ = readfile

    if not readfile_ then
        if not readfile_ then
            return false
        end

        return
    end

    readfile_ = writefile

    if not readfile_ then
        if not readfile_ then
            return false
        end

        return
    end

    readfile_ = isfile

    if not readfile_ then
        return false
    end
end
function t2.value7()
    if t2.value3 then
        return
    end

    if not writefile then
        return
    end

    local function v4()
        writefile(t2.value2, t2.value1)
    end

    pcall(v4)
end
local function value4()
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local PropHubPremiumsKeyGate = PlayerGui:FindFirstChild("PropHubPremiumsKeyGate")

    if PropHubPremiumsKeyGate then
        PropHubPremiumsKeyGate:Destroy()
    end

    PropHubPremiumsKeyGate = Instance.new("ScreenGui")
    PropHubPremiumsKeyGate.Name = "PropHubPremiumsKeyGate"
    PropHubPremiumsKeyGate.ResetOnSpawn = false
    PropHubPremiumsKeyGate.IgnoreGuiInset = true
    PropHubPremiumsKeyGate.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    PropHubPremiumsKeyGate.Parent = PlayerGui
    PlayerGui = Instance.new("Frame", PropHubPremiumsKeyGate)
    PlayerGui.Size = UDim2.new(1, 0, 1, 0)
    PlayerGui.BackgroundColor3 = Color3.new(0, 0, 0)
    PlayerGui.BackgroundTransparency = 0.5
    PlayerGui.BorderSizePixel = 0
    PlayerGui.Active = true
    PlayerGui = Instance.new("Frame", PlayerGui)
    PlayerGui.Size = UDim2.new(0, 360, 0, 200)
    PlayerGui.Position = UDim2.new(0.5, -180, 0.5, -100)
    PlayerGui.BackgroundColor3 = Color3.fromRGB(35, 10, 10)
    PlayerGui.BorderSizePixel = 0
    Instance.new("UICorner", PlayerGui).CornerRadius = UDim.new(0, 10)

    local UIStroke = Instance.new("UIStroke", PlayerGui)

    UIStroke.Color = Color3.fromRGB(220, 40, 40)
    UIStroke.Thickness = 2
    UIStroke = Instance.new("TextLabel", PlayerGui)
    UIStroke.Size = UDim2.new(1, -20, 0, 40)
    UIStroke.Position = UDim2.new(0, 10, 0, 15)
    UIStroke.BackgroundTransparency = 1
    UIStroke.Text = "PROP HUB PREMIUMS \226\128\148 KEY REQUIRED"
    UIStroke.Font = Enum.Font.GothamBold
    UIStroke.TextSize = 18
    UIStroke.TextColor3 = Color3.fromRGB(255, 130, 130)
    UIStroke.TextStrokeTransparency = 0.6
    UIStroke = Instance.new("TextLabel", PlayerGui)
    UIStroke.Size = UDim2.new(1, -20, 0, 20)
    UIStroke.Position = UDim2.new(0, 10, 0, 55)
    UIStroke.BackgroundTransparency = 1
    UIStroke.Text = "Enter the key to continue"
    UIStroke.Font = Enum.Font.Gotham
    UIStroke.TextSize = 14
    UIStroke.TextColor3 = Color3.fromRGB(200, 180, 180)
    UIStroke = Instance.new("TextBox", PlayerGui)
    UIStroke.Size = UDim2.new(1, -40, 0, 40)
    UIStroke.Position = UDim2.new(0, 20, 0, 90)
    UIStroke.BackgroundColor3 = Color3.fromRGB(60, 25, 25)
    UIStroke.BorderSizePixel = 0
    UIStroke.Font = Enum.Font.Gotham
    UIStroke.TextSize = 16
    UIStroke.TextColor3 = Color3.new(1, 1, 1)
    UIStroke.PlaceholderText = "Key..."
    UIStroke.PlaceholderColor3 = Color3.fromRGB(180, 140, 140)
    UIStroke.Text = ""
    UIStroke.ClearTextOnFocus = false
    Instance.new("UICorner", UIStroke).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", UIStroke).Color = Color3.fromRGB(220, 40, 40)

    local TextLabel = Instance.new("TextLabel", PlayerGui)

    TextLabel.Size = UDim2.new(1, -20, 0, 20)
    TextLabel.Position = UDim2.new(0, 10, 0, 135)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = ""
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextSize = 13
    TextLabel.TextColor3 = Color3.fromRGB(255, 80, 80)

    local TextButton = Instance.new("TextButton", PlayerGui)

    TextButton.Size = UDim2.new(0, 140, 0, 32)
    TextButton.Position = UDim2.new(0.5, -70, 1, -45)
    TextButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    TextButton.BorderSizePixel = 0
    TextButton.Text = "Submit"
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 14
    TextButton.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 6)

    local n1 = 0

    PlayerGui = function()
        if t2.value5(UIStroke.Text) then
            TextLabel.Text = "Key accepted. Loading..."
            TextLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
            TextButton.Text = "Loading..."
            TextButton.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
            t2.value7()
            task.wait(0.6)
            PropHubPremiumsKeyGate:Destroy()
            _G.__PropHubPremiumKeyOK = true

            return
        else
            n1 = n1 + 1
            TextLabel.Text = "Invalid key. Attempt " .. n1
            TextLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
            UIStroke.Text = ""

            local Position = PlayerGui.Position

            for i = 1, 6 do
                PlayerGui.Position = Position + UDim2.new(0, i % 2 == 0 and 8 or -8, 0, 0)
                task.wait(0.03)
            end

            PlayerGui.Position = Position

            if not (n1 >= 5) then
                return
            end

            TextLabel.Text = "Too many attempts. Rejoin."
            TextButton.Text = "Locked"
            TextButton.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
            task.wait(2)
            PropHubPremiumsKeyGate:Destroy()
            _G.__PropHubPremiumKeyFailed = true

            return
        end
    end
    TextButton.MouseButton1Click:Connect(PlayerGui)
    UIStroke.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            return
        end

        PlayerGui()
    end)
    task.spawn(function()
        if not t2.value6() then
            return
        end

        TextLabel.Text = "Saved key found. Loading..."
        TextLabel.TextColor3 = Color3.fromRGB(80, 220, 120)
        task.wait(0.4)

        local Parent = PropHubPremiumsKeyGate

        if Parent then
            Parent = PropHubPremiumsKeyGate.Parent
        end

        if Parent then
            PropHubPremiumsKeyGate:Destroy()
        end

        _G.__PropHubPremiumKeyOK = true
    end)
end
if _G.__PropHubPremiumKeyOK then
    loadstring = loadstring or load

    function t1.value4(p2)
        for _, v in ipairs({
			{
				["name"] = "request",
				["fn"] = function()
            local t3 = {
						["Url"] = p2,
						["Method"] = "GET"
					}

            return request(t3).Body
        end
			},
			{
				["name"] = "http_request",
				["fn"] = function()
            local t4 = {
						["Url"] = p2,
						["Method"] = "GET"
					}

            return http_request(t4).Body
        end
			},
			{
				["name"] = "game:HttpGet",
				["fn"] = function()
            return game:HttpGet(p2)
        end
			},
			{
				["name"] = "syn.request",
				["fn"] = function()
            local t5 = {
						["Url"] = p2,
						["Method"] = "GET"
					}

            return syn.request(t5).Body
        end
			},
			{
				["name"] = "http.request",
				["fn"] = function()
            local t6 = {
						["Url"] = p2,
						["Method"] = "GET"
					}

            return http.request(t6).Body
        end
			}
		}) do
            local ok, result = pcall(v.fn)

            if ok then
                if type(result) == "string" then
                    ok = #result > 0
                else
                    ok = false
                end
            end

            if ok then
                return result, v.name
            end
        end

        return nil, nil
    end

    t2.value8 = t1.value4
    t1.value4 = {
		"MLModelDeliveryService",
		"PartyEmulatorService",
		"OmniRecommendationsService",
		"PlatformFriendsService"
	}
    t2.value9 = t1.value4
    t2.value10 = nil

    function t2.value10(p3)
        if type(p3) ~= "string" then
            return p3
        end

        local v23 = p3 .. "\n"
        local t7 = {}

        for match in v23:gmatch("([^\n]*)\n") do
            local v26, v27, v28 = ipairs(t2.value9)
            local v29 = false

            while true do
                local v30

                v28, v30 = v26(v27, v28)

                if not v28 then
                    break
                end

                if string.find(match, v30, 1, true) then
                    v29 = true

                    break
                end
            end

            if not v29 then
                t7[#t7 + 1] = match
            end
        end

        v23 = table.concat(t7, "\n")
        v23 = string.gsub(v23, "while%s+true%s+do%s*end", "do end")
        v23 = string.gsub(v23, "while%s+true%s+do%s*task%.wait%b()%s*end", "do end")
        v23 = string.gsub(v23, "while%s+true%s+do%s*wait%b()%s*end", "do end")

        return string.gsub(v23, "while%s+true%s+do%s*task%.wait%b()%s*task%.wait%b()%s*end", "do end")
    end

    t2.value11 = nil

    function t2.value11(p4, ...)
        local chunk, result = t2.value8(p4)

        if chunk then
            chunk = t2.value10(chunk)
            print("[Prop Hub Premiums] Fetched via " .. tostring(result) .. " (" .. #chunk .. " bytes, stripped)")

            if loadstring then
                chunk, result = loadstring(chunk)

                if chunk then
                    chunk, result = pcall(chunk, ...)

                    if chunk then
                        print("[Prop Hub Premiums] Executed OK")

                        return
                    else
                        warn("[Prop Hub Premiums] Runtime error: " .. tostring(result))

                        return
                    end

                    return
                else
                    warn("[Prop Hub Premiums] Compile failed: " .. tostring(result))

                    return
                end

                return
            else
                warn("[Prop Hub Premiums] loadstring unavailable")

                return
            end

            return
        else
            warn("[Prop Hub Premiums] All HTTP methods failed: " .. p4)

            return
        end
    end
    function t2.value12(p5)
        local v33, result = t2.value8(p5)

        if v33 then
            v33 = t2.value10(v33)
            print("[Prop Hub Premiums] Fetched via " .. tostring(result) .. " (" .. #v33 .. " bytes, stripped)")

            if loadstring then
                v33 = "local error = function() return nil end\n" .. v33
                v33, result = loadstring(v33)

                if v33 then
                    v33, result = pcall(v33)

                    if v33 then
                        print("[Prop Hub Premiums] Executed OK (patched)")

                        return
                    else
                        warn("[Prop Hub Premiums] Runtime error: " .. tostring(result))

                        return
                    end

                    return
                else
                    warn("[Prop Hub Premiums] Compile failed: " .. tostring(result))

                    return
                end

                return
            else
                warn("[Prop Hub Premiums] loadstring unavailable")

                return
            end

            return
        else
            warn("[Prop Hub Premiums] All HTTP methods failed: " .. p5)

            return
        end
    end

    t2.value13 = game:GetService("UserInputService")
    t1 = game.Players.LocalPlayer
    Folder = t1:WaitForChild("PlayerGui")
    t2.value14 = nil
    t2.value15 = nil
    t2.value16 = nil
    t2.value17 = nil
    t2.value18 = nil
    t2.value19 = nil
    t2.value20 = nil
    t2.value21 = nil
    t2.value22 = nil
    t2.value23 = nil
    t2.value24 = nil
    t2.value25 = nil
    t2.value26 = nil
    t2.value27 = nil
    t2.value28 = nil
    t2.value29 = nil
    t2.value30 = nil
    t2.value31 = nil
    t2.value32 = nil
    t2.value33 = Instance.new("IntValue")
    t2.value33.Value = 0
    Instance.new("IntValue").Value = 0
    t2.value34 = Instance.new("IntValue")
    t2.value34.Value = 0
    t2.value35 = Instance.new("IntValue")
    t2.value35.Value = 0
    t2.value36 = UDim2.new(0, 0, 0, 0)
    t2.value37 = Color3.new(0.62745098039216, 0.07843137254902, 0.07843137254902)

    function Execute(p6)
        local thread = coroutine.create(p6)
        local v36, v37 = coroutine.resume(thread)

        if v36 then
            return thread
        end

        warn("[Prop Hub Premiums] Execute: " .. tostring(v37))

        return thread
    end
    function PlaySFX(p7, p8, p9, p10)
        t2.value18 = Instance.new("Sound", workspace)
        t2.value18.PlayOnRemove = true
        t2.value18.SoundId = "rbxassetid://" .. p7
        t2.value18.Volume = p8
        t2.value18.Pitch = p9
        t2.value18.Looped = p10

        if p10 then
            t2.value18:Play()

            return t2.value18
        end

        t2.value18.Ended:Connect(function()
            local value18 = t2.value18

            if value18 then
                value18 = t2.value18.Parent
            end

            if not value18 then
                return
            end

            t2.value18:Destroy()
        end)
        t2.value18:Play()

        return t2.value18
    end
    function Frame(p11, p12, p13)
        t2.value19 = Instance.new("Frame", p11)
        t2.value19.Size = p12
        t2.value19.Position = p13

        return t2.value19
    end
    function ScrollFrame(p14, p15, p16)
        t2.value19 = Instance.new("ScrollingFrame", p14)
        t2.value19.Size = p15
        t2.value19.Position = p16
        t2.value19.ScrollBarThickness = 10

        return t2.value19
    end
    function Label(p17, p18, p19, p20, p21)
        t2.value20 = Instance.new("TextLabel", p17)
        t2.value20.Size = p19
        t2.value20.Position = p20
        t2.value20.Text = p18
        t2.value20.BackgroundTransparency = 1
        t2.value20.Font = Enum.Font.Legacy
        t2.value20.TextColor3 = Color3.new(1, 1, 1)
        t2.value20.TextStrokeTransparency = 0.5
        t2.value20.TextWrapped = true

        if p21 == nil then
            return t2.value20
        end

        if p21 == 1 then
            t2.value20.Size = UDim2.new(1, -10, 0, 35)
        end

        t2.value20.Position = UDim2.new(0, 0, 0, 35 * p21.Value)
        t2.value20.BackgroundColor3 = t2.value37
        t2.value20.BackgroundTransparency = 0.85
        t2.value20.BorderSizePixel = 0
        p21.Value = p21.Value + 1

        return t2.value20
    end
    function Button(p22, p23, p24, p25, p26, p27)
        t2.value20 = Instance.new("TextButton", p22)
        t2.value20.Size = p24
        t2.value20.Position = p25
        t2.value20.Text = p23
        t2.value20.Style = Enum.ButtonStyle.RobloxButton
        t2.value20.Font = Enum.Font.Legacy
        t2.value20.TextColor3 = Color3.new(1, 1, 1)
        t2.value20.TextStrokeTransparency = 0.5
        t2.value20.TextWrapped = true
        t2.value20.MouseButton1Click:Connect(function()
            local function v39()
                PlaySFX(156785206, 0.75, 1.25)
                p26()
            end

            pcall(v39)
        end)

        if p27 == nil then
            return t2.value20
        end

        if p24 == t2.value36 then
            t2.value20.Size = UDim2.new(1, -10, 0, 35)
        end

        t2.value20.Position = UDim2.new(0, 0, 0, 35 * p27.Value)
        t2.value20.Style = Enum.ButtonStyle.Custom
        t2.value20.BackgroundColor3 = t2.value37
        t2.value20.BackgroundTransparency = 0.85
        t2.value20.BorderSizePixel = 0
        p27.Value = p27.Value + 1

        return t2.value20
    end
    function ImageLabel(p28, p29, p30, p31)
        t2.value20 = Instance.new("ImageLabel", p28)
        t2.value20.Image = "rbxassetid://" .. p29
        t2.value20.Size = p30
        t2.value20.Position = p31
        t2.value20.BackgroundTransparency = 1

        return t2.value20
    end
    function ToggleMenu()
        if t2.value32 == true then
            PlaySFX(243152215, 0.85, 1)

            local value23 = t2.value23
            local UDim2_ = UDim2

            value23:TweenPosition(UDim2_.new(0.5, -250, -0.5, -175), "Out", "Quad", 0.5, true)
            PlaySFX(145487017, 0.85, 1.1)
            t2.value29:TweenPosition(UDim2.new(0, 0, 1, -50), "Out", "Quad", 0.25, true)
            t2.value32 = false

            return
        else
            PlaySFX(243152215, 0.85, 1)
            t2.value23:TweenPosition(UDim2.new(0.5, -250, 0.5, -175), "Out", "Quad", 0.5, true)
            PlaySFX(145487017, 0.85, 1.1)
            t2.value29:TweenPosition(UDim2.new(0, -50, 1, -50), "Out", "Quad", 0.25, true)
            t2.value32 = true

            return
        end
    end
    function AddTab(p32, p33, p34, p35)
        if p35 == nil then
            return
        end

        t2.value21 = Frame(p33, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
        t2.value21.BackgroundTransparency = 1
        t2.value21.BorderSizePixel = 0
        t2.value21.Name = p34
        t2.value21.Visible = false

        if p35.Value == 0 then
            t2.value21.Visible = true
        end

        Instance.new("IntValue", t2.value21).Name = "IsATab"
        t2.value20 = Button(p32, p34, UDim2.new(1, -10, 0, 35), UDim2.new(0, 5, 0, 5 + 40 * p35.Value), function()
            local v42 = p33

            for _, child in pairs(v42:GetChildren()) do
                child.Visible = child.Name == p34
            end
        end)
        t2.value20.Style = Enum.ButtonStyle.Custom
        t2.value20.BackgroundColor3 = t2.value37
        t2.value20.BackgroundTransparency = 0.85
        t2.value20.BorderSizePixel = 0
        Instance.new("IntValue", t2.value20).Name = "IsATabButton"
        p35.Value = p35.Value + 1

        if p32.Parent.ClassName ~= "ScrollingFrame" then
            return t2.value21
        end

        p32.Parent.CanvasSize = UDim2.new(0, 0, 0, 5 + 40 * p35.Value)

        return t2.value21
    end
    function AddHotkey(p36, p37)
        t2.value13.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then
                return
            end

            if input.KeyCode ~= p36 then
                return
            end

            p37()
        end)
    end
    function t2.value38()
        t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Mickey-Chat-85762")
    end
    function t2.value39()
        t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Slayer-Hub-246319")
    end
    function t2.value40()
        t2.value11("https://pastefy.app/IEtQc2AG/raw")
    end
    function t2.value41()
        t2.value11("https://pastefy.app/5DHZpKqu/raw")
    end
    function t2.value42()
        t2.value11("https://pastefy.app/CQJxqTMV/raw")
    end
    function t2.value43()
        t2.value11("https://pastebin.com/raw/BnuJki8Z")
    end
    function t2.value44()
        t2.value11("https://raw.githubusercontent.com/mowl3767/rc7old/refs/heads/main/67")
    end
    function t2.value45()
        t2.value11("https://pastefy.app/xZEAQvWp/raw")
    end
    function t2.value46()
        local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local DraggableGui = PlayerGui:FindFirstChild("DraggableGui")

        if DraggableGui then
            DraggableGui:Destroy()
        end

        DraggableGui = Instance.new("ScreenGui")
        DraggableGui.Name = "DraggableGui"
        DraggableGui.ResetOnSpawn = false
        DraggableGui.IgnoreGuiInset = true
        DraggableGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        DraggableGui.Parent = PlayerGui
        PlayerGui = Instance.new("Frame")
        PlayerGui.Name = "MainFrame"
        PlayerGui.Size = UDim2.fromOffset(160, 200)
        PlayerGui.Position = UDim2.new(0, 40, 0, 40)
        PlayerGui.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
        PlayerGui.BorderSizePixel = 0
        PlayerGui.Active = true
        PlayerGui.ClipsDescendants = true
        PlayerGui.Parent = DraggableGui
        DraggableGui = Instance.new("UIStroke")
        DraggableGui.Color = Color3.fromRGB(255, 255, 255)
        DraggableGui.Thickness = 2
        DraggableGui.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        DraggableGui.Parent = PlayerGui
        DraggableGui = Instance.new("ImageLabel")
        DraggableGui.Name = "Background"
        DraggableGui.Size = UDim2.fromScale(1, 1)
        DraggableGui.Position = UDim2.fromScale(0, 0)
        DraggableGui.BackgroundTransparency = 1
        DraggableGui.Image = "rbxassetid://77020598491913"
        DraggableGui.ScaleType = Enum.ScaleType.Stretch
        DraggableGui.ZIndex = 1
        DraggableGui.Parent = PlayerGui
        DraggableGui = Instance.new("Frame")
        DraggableGui.Name = "TitleBar"
        DraggableGui.Size = UDim2.new(1, 0, 0, 22)
        DraggableGui.Position = UDim2.new(0, 0, 0, 0)
        DraggableGui.BackgroundTransparency = 1
        DraggableGui.BorderSizePixel = 0
        DraggableGui.ZIndex = 2
        DraggableGui.Parent = PlayerGui

        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = "Title"
        TextLabel.Size = UDim2.fromScale(1, 1)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "terry hub"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.Font = Enum.Font.GothamBold
        TextLabel.TextSize = 16
        TextLabel.TextStrokeTransparency = 1
        TextLabel.ZIndex = 3
        TextLabel.Parent = DraggableGui
        DraggableGui = Instance.new("Frame")
        DraggableGui.Name = "ButtonHolder"
        DraggableGui.Size = UDim2.new(1, 0, 1, -22)
        DraggableGui.Position = UDim2.new(0, 0, 0, 22)
        DraggableGui.BackgroundTransparency = 1
        DraggableGui.ZIndex = 2
        DraggableGui.Parent = PlayerGui
        TextLabel = Instance.new("UIListLayout")
        TextLabel.FillDirection = Enum.FillDirection.Vertical
        TextLabel.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TextLabel.VerticalAlignment = Enum.VerticalAlignment.Center
        TextLabel.Padding = UDim.new(0, 6)
        TextLabel.SortOrder = Enum.SortOrder.LayoutOrder
        TextLabel.Parent = DraggableGui
        DraggableGui = function(p38, p39, p40, p41)
            local TextButton = Instance.new("TextButton")

            TextButton.Name = p38
            TextButton.Size = UDim2.new(1, -20, 0, 32)
            TextButton.BackgroundTransparency = 1
            TextButton.BorderSizePixel = 0
            TextButton.Text = p39
            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.Font = Enum.Font.GothamBold
            TextButton.TextSize = 13
            TextButton.TextStrokeTransparency = 1
            TextButton.AutoButtonColor = false
            TextButton.LayoutOrder = p40
            TextButton.ZIndex = 3
            TextButton.Parent = DraggableGui

            local UIStroke = Instance.new("UIStroke")

            UIStroke.Color = Color3.fromRGB(255, 255, 255)
            UIStroke.Thickness = 1
            UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            UIStroke.Parent = TextButton
            TextButton.MouseButton1Click:Connect(p41)

            return TextButton
        end
        DraggableGui("PropHubV3", "Prop Hub V3", 1, function()
            pcall(function()
                t2.value11("https://pastefy.app/w5FYqDgg/raw")
            end)
        end)
        DraggableGui("CurseHand", "Curse Hand", 2, function()
            local function v50()
                t2.value11("https://pastefy.app/rpXEbmwm/raw")
            end

            pcall(v50)
        end)
        DraggableGui("AllSeeingHand", "All Seeing Hand", 3, function()
            local function v51()
                t2.value11("https://pastefy.app/cYwNpzjP/raw")
            end

            pcall(v51)
        end)

        local u52 = false

        PlayerGui.InputBegan:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                return
            end

            u52 = true

            local Position = input.Position

            Position = PlayerGui.Position
        end)
        t2.value13.InputChanged:Connect(function(input)
            local v54 = u52

            if v54 then
                v54 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
            end

            if not v54 then
                return
            end

            v54 = input.Position - nil
            PlayerGui.Position = UDim2.new((nil).X.Scale, (nil).X.Offset + v54.X, (nil).Y.Scale, (nil).Y.Offset + v54.Y)
        end)
        t2.value13.InputEnded:Connect(function(input)
            local _ = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
        end)
    end

    t2.value47 = {
		{ "Wing Prop2", function()
        t2.value11("https://pastefy.app/RM1MkrT4/raw")
    end },
		{ "Wing Prop", function()
        t2.value11("https://pastefy.app/IJHHtWR6/raw")
    end },
		{ "Shark Prop", function()
        t2.value11("https://pastefy.app/thWRWou1/raw")
    end },
		{ "B2 Spirit Prop", function()
        t2.value11("https://pastefy.app/b0JRIsKj/raw")
    end },
		{ "Avarice Scythe", function()
        t2.value11("https://pastefy.app/oneTZn9W/raw")
    end },
		{ "Gojo Controller", function()
        t2.value11("https://pastefy.app/3MShESQ2/raw")
    end },
		{ "Wither Prop", function()
        t2.value11("https://pastefy.app/q4Js0TjY/raw")
    end },
		{ "Wither Storm", function()
        t2.value11("https://pastefy.app/5NOFcoUP/raw")
    end },
		{ "Wither Prop2", function()
        t2.value11("https://pastefy.app/6jvLhYaS/raw")
    end },
		{ "B2-Spirit2", function()
        t2.value11("https://pastefy.app/we9aonad/raw")
    end },
		{ "Wither3", function()
        t2.value11("https://pastefy.app/0eGHRHNp/raw")
    end },
		{ "Wither Storm2", function()
        t2.value11("https://pastefy.app/r4nWQYzg/raw")
    end },
		{ "Verity Prop", function()
        t2.value11("https://pastefy.app/x1BOck3z/raw")
    end },
		{ "Godzilla Prop", function()
        t2.value11("https://raw.githubusercontent.com/Johan319/Fe-Godzilla-Obfuscator/refs/heads/main/godzilla")
    end },
		{ "Raiden (Dyton Security)", function()
        t2.value11("https://encrypt-x.pages.dev/Scripts?Id=raidenmaru", "raidenmaru")
    end },
		{ "Nothing Panel (Mecha)", function()
        t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Nothing-Panel-223707")
    end },
		{ "Wing Prop3", function()
        t2.value11("https://pastefy.app/6ZVZWkbb/raw")
    end },
		{ "Ender Dragon", function()
        t2.value11("https://pastefy.app/knN2ER4f/raw")
    end },
		{ "Radar Terror", function()
        t2.value11("https://pastefy.app/lXwhhrxw/raw")
    end },
		{ "B2 Spirit Prop3", function()
        t2.value11("https://pastefy.app/J35BTsjO/raw")
    end },
		{ "Rodan Prop", function()
        t2.value11("https://pastefy.app/MeSs5ehk/raw")
    end },
		{ "Dual Spider Engine", function()
        t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Engine-spider-props-use-sit-props-243775")
    end },
		{ "Spear Prop", function()
        t2.value11("https://pastefy.app/pDY43Jvl/raw")
    end },
		{ "Curse Engine", function()
        t2.value11("https://pastefy.app/LCb15eUP/raw")
    end },
		{ "Sukuna", function()
        t2.value11("https://pastefy.app/XvOVpQB0/raw")
    end },
		{ "SCMD Prop (Key Xiandi)", function()
        t2.value11("https://rawscripts.net/raw/Brookhaven-RP-Wings-cmback-use-prop-Brookhaven-key-xiandi-211092")
    end },
		{ "Avarice Prop", function()
        t2.value11("https://rawscripts.net/raw/Brookhaven-RP-AVARICE-WINGS-BY-NIZAM-217994")
    end },
		{ "Eryx (Key: ErYxOnToP)", function()
        t2.value11("https://rawscripts.net/raw/Universal-Script-ErYx-Prop-Animations-by-vansh-238691")
    end },
		{ "TXR Prop", function()
        t2.value11("https://rawscripts.net/raw/Universal-Script-TXR-ASHU-ROBOT-POWERFULL-TROLL-SCRIPT-241380")
    end },
		{ "Reptile", function()
        t2.value11("https://pastefy.app/vtA0dM2D/raw")
    end },
		{ "Wings Prop V4", function()
        t2.value11("https://rawscripts.net/raw/Universal-Script-Wings-By-yanzz-227428")
    end },
		{ "Immortal Demon", function()
        t2.value11("https://pastefy.app/50yM3llG/raw")
    end },
		{ "Leviathan", function()
        t2.value11("https://pastefy.app/tPvt3Uv8/raw")
    end },
		{ "Hand Prop", function()
        t2.value11("https://pastefy.app/8oXtJqyl/raw")
    end },
		{ "Soul Revenger", function()
        t2.value11("https://pastefy.app/DyTYj5Yu/raw")
    end },
		{ "Siren Head The Nightmare Stalker (Dyton Security)", function()
        t2.value12("https://api.rubis.app/v2/scrap/sOHDXpo9eskJoAu4/raw")
    end },
		{ "Susano", function()
        t2.value11("https://pastefy.app/90HgaYmZ/raw")
    end },
		{ "Susano 2", function()
        t2.value11("https://pastefy.app/QSpPmcOu/raw")
    end },
		{ "plane prop", function()
        t2.value11("https://pastefy.app/1cxYPFnt/raw?part=Phi%20c%C6%A1%20brookhaven")
    end },
		{ "Wither Storm 3", function()
        t2.value11("https://pastefy.app/l4ELsID8/raw")
    end },
		{ "All Seeing Hand", function()
        t2.value11("https://pastefy.app/cYwNpzjP/raw")
    end },
		{ "Join Discord", function()
        local discord = "https://discord.gg/jFJQj22gjt"

        if setclipboard then
            setclipboard(discord)
            print("Discord link copied!")

            return
        else
            print("Discord: " .. discord)

            return
        end
    end }
	}

    function GeneratePropTab()
        local v57 = AddTab(t2.value30, t2.value31, "Prop", t2.value33)

        v57.Size = UDim2.new(1, 10, 1, 0)
        v57.ClipsDescendants = true

        local IntValue = Instance.new("IntValue", v57)

        IntValue.Value = 1

        local value = #t2.value47
        local uDim2 = UDim2.new(0.5, -75, 0.5, -75)
        local uDim22 = UDim2.new(0, 150, 0, 150)
        local uDim23 = UDim2.new(0, 75, 0, 75)
        local Frame_ = Instance.new("Frame", v57)

        Frame_.Size = UDim2.new(1, 0, 1, 0)
        Frame_.BackgroundTransparency = 1
        Frame_.ClipsDescendants = true

        local TextBox = Instance.new("TextBox", Frame_)

        TextBox.BackgroundColor3 = t2.value37
        TextBox.BackgroundTransparency = 0.85
        TextBox.BorderSizePixel = 0
        TextBox.Position = UDim2.new(0.5, -100, 0, 5)
        TextBox.Size = UDim2.new(0, 200, 0, 20)
        TextBox.Font = Enum.Font.Legacy
        TextBox.TextColor3 = Color3.new(1, 1, 1)
        TextBox.TextStrokeTransparency = 0.5
        TextBox.Text = "Search..."
        TextBox.ClearTextOnFocus = true
        TextBox.ZIndex = 5
        TextBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed then
                return
            end

            local v65 = string.lower(TextBox.Text)

            for _, child in pairs(Frame_:GetChildren()) do
                local v68 = child.Name == "Cube"

                if v68 then
                    v68 = child:FindFirstChild("Title")

                    if v68 then
                        v68 = child:FindFirstChild("Id")
                    end
                end

                if v68 and string.find(string.lower(child.Title.Text), v65, 1, true) then
                    IntValue.Value = child.Id.Value

                    return
                end
            end
        end)
        TextBox = function(p42, p43, p44, p45)
            local Frame_2 = Instance.new("Frame", p42)

            Frame_2.BorderSizePixel = 0
            Frame_2.Name = "Cube"
            Frame_2.BackgroundTransparency = 0.85
            Frame_2.BackgroundColor3 = t2.value37

            local IntValue2 = Instance.new("IntValue", Frame_2)

            IntValue2.Name = "Id"
            IntValue2.Value = p44
            IntValue2 = Instance.new("TextLabel", Frame_2)
            IntValue2.Text = "  ID: " .. p44
            IntValue2.BackgroundTransparency = 1
            IntValue2.Size = UDim2.new(0, 100, 0, 20)
            IntValue2.Font = Enum.Font.Legacy
            IntValue2.TextColor3 = Color3.new(1, 1, 1)
            IntValue2.TextStrokeTransparency = 0.5
            IntValue2.TextXAlignment = Enum.TextXAlignment.Left
            IntValue2.ZIndex = 2
            IntValue2 = Instance.new("TextLabel", Frame_2)
            IntValue2.Text = p43
            IntValue2.BackgroundTransparency = 1
            IntValue2.Size = UDim2.new(1, 0, 0.1, 0)
            IntValue2.Position = UDim2.new(0, 0, 0.15, 0)
            IntValue2.Font = Enum.Font.Legacy
            IntValue2.TextScaled = true
            IntValue2.TextColor3 = Color3.new(1, 1, 1)
            IntValue2.TextStrokeTransparency = 0.5
            IntValue2.Name = "Title"
            IntValue2.ZIndex = 2
            IntValue2 = Instance.new("TextButton", Frame_2)
            IntValue2.Text = "Execute"
            IntValue2.BackgroundColor3 = t2.value37
            IntValue2.BackgroundTransparency = 0.85
            IntValue2.Size = UDim2.new(0.75, 0, 0.2, 0)
            IntValue2.Position = UDim2.new(0.125, 0, 0.75, 0)
            IntValue2.Font = Enum.Font.Legacy
            IntValue2.TextScaled = true
            IntValue2.TextColor3 = Color3.new(1, 1, 1)
            IntValue2.TextStrokeTransparency = 0.5
            IntValue2.BorderSizePixel = 0
            IntValue2.ZIndex = 2
            IntValue2.MouseButton1Click:Connect(function()
                PlaySFX(156785206, 0.75, 1.25)
                pcall(p45)
            end)

            return Frame_2
        end

        for i, v in ipairs(t2.value47) do
            TextBox(Frame_, v[1], i, v[2])
        end

        TextBox = function()
            PlaySFX(156785206, 0.75, 1.25)

            if IntValue.Value > 1 then
                IntValue.Value = IntValue.Value - 1

                return
            else
                IntValue.Value = value

                return
            end
        end

        local TextButton = Instance.new("TextButton", Frame_)

        TextButton.Size = UDim2.new(0, 50, 1, 0)
        TextButton.Text = "<"
        TextButton.BackgroundTransparency = 0.85
        TextButton.BackgroundColor3 = t2.value37
        TextButton.BorderSizePixel = 0
        TextButton.Font = Enum.Font.Legacy
        TextButton.TextStrokeTransparency = 0.5
        TextButton.TextColor3 = Color3.new(1, 1, 1)
        TextButton.ZIndex = 3
        TextButton.MouseButton1Click:Connect(TextBox)
        TextButton = Instance.new("TextButton", Frame_)
        TextButton.Size = UDim2.new(0, 50, 1, 0)
        TextButton.Position = UDim2.new(1, -50, 0, 0)
        TextButton.BackgroundTransparency = 0.85
        TextButton.BackgroundColor3 = t2.value37
        TextButton.BorderSizePixel = 0
        TextButton.Text = ">"
        TextButton.Font = Enum.Font.Legacy
        TextButton.TextStrokeTransparency = 0.5
        TextButton.TextColor3 = Color3.new(1, 1, 1)
        TextButton.ZIndex = 3
        TextButton.MouseButton1Click:Connect(function()
            PlaySFX(156785206, 0.75, 1.25)

            if IntValue.Value < value then
                IntValue.Value = IntValue.Value + 1

                return
            else
                IntValue.Value = 1

                return
            end
        end)
        AddHotkey(Enum.KeyCode.Q, function()
            local value32 = t2.value32

            if value32 then
                value32 = v57.Visible
            end

            if not value32 then
                return
            end

            TextBox()
        end)
        AddHotkey(Enum.KeyCode.E, function()
            local value32 = t2.value32

            if value32 then
                value32 = v57.Visible
            end

            if not value32 then
                return
            end

            PlaySFX(156785206, 0.75, 1.25)

            if IntValue.Value < value then
                IntValue.Value = IntValue.Value + 1

                return
            end

            IntValue.Value = 1
        end)
        v57 = function()
            local v76 = Frame_

            for _, child in pairs(v76:GetChildren()) do
                local v79 = child.Name == "Cube"

                if v79 then
                    v79 = child:FindFirstChild("Id")
                end

                if v79 then
                    if child.Id.Value == IntValue.Value then
                        child:TweenSizeAndPosition(uDim22, uDim2, "Out", "Quad", 0.75, true)
                    elseif child.Id.Value > IntValue.Value then
                        if child.Id.Value > IntValue.Value + 1 then
                            child:TweenSizeAndPosition(uDim23, UDim2.new(1.5, -37.5, 0.25, -75), "Out", "Quad", 0.75, true)
                        else
                            child:TweenSizeAndPosition(uDim23, UDim2.new(0.75, -37.5, 0.25, 0), "Out", "Quad", 0.75, true)
                        end
                    elseif child.Id.Value < IntValue.Value then
                        if child.Id.Value < IntValue.Value - 1 then
                            child:TweenSizeAndPosition(uDim23, UDim2.new(-0.5, -37.5, 0.25, -75), "Out", "Quad", 0.75, true)
                        else
                            v79 = uDim23

                            local UDim2_ = UDim2

                            child:TweenSizeAndPosition(v79, UDim2_.new(0.25, -37.5, 0.25, 0), "Out", "Quad", 0.75, true)
                        end
                    end
                end
            end
        end
        IntValue.Changed:Connect(v57)
        task.wait()
        v57()
    end
    function GenerateTrollTab()
        local v81 = AddTab(t2.value30, t2.value31, "Troll", t2.value33)

        v81.Size = UDim2.new(1, 10, 1, 0)
        v81 = ScrollFrame(v81, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
        v81.BackgroundTransparency = 1
        v81.BorderSizePixel = 0
        v81.CanvasSize = UDim2.new(0, 0, 0, 0)

        local t8 = {
			{ "Mickey Chat", t2.value38 },
			{ "Slayer Hub", t2.value39 },
			{ "Kill Player", t2.value40 },
			{ "Quantum", t2.value41 },
			{ "Report Script", t2.value42 }
		}

        for _, v in ipairs(t8) do
            local Button_ = Button
            local v86 = v[1]
            local v87 = v[2]

            Button_(v81, v86, t2.value36, t2.value36, v87, t2.value34)
            v81.CanvasSize = UDim2.new(0, 0, 0, 35 * t2.value34.Value)
        end
    end
    function GenerateExtraTab()
        local v88 = AddTab(t2.value30, t2.value31, "Extra", t2.value33)

        v88.Size = UDim2.new(1, 10, 1, 0)
        v88 = ScrollFrame(v88, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
        v88.BackgroundTransparency = 1
        v88.BorderSizePixel = 0
        v88.CanvasSize = UDim2.new(0, 0, 0, 0)

        local t9 = {
			{ "Prop Gui (not mine)", t2.value43 },
			{ "Rc7", t2.value44 },
			{ "Prop Panel", t2.value45 },
			{ "Terry Hub", t2.value46 }
		}

        for _, v in ipairs(t9) do
            local Button_ = Button
            local v93 = v[1]
            local v94 = v[2]

            Button_(v88, v93, t2.value36, t2.value36, v94, t2.value35)
            v88.CanvasSize = UDim2.new(0, 0, 0, 35 * t2.value35.Value)
        end
    end
    function GenerateMenu(p46)
        t2.value23 = Frame(p46, UDim2.new(0, 475, 0, 20), UDim2.new(0.5, -250, -0.5, -175))
        t2.value23.Style = Enum.FrameStyle.RobloxRound
        t2.value23.Draggable = true
        t2.value23.Active = true
        t2.value23.ZIndex = 2
        t2.value21 = Frame(t2.value23, UDim2.new(0, 500, 0, 350), UDim2.new(0, -20, 0, -20))
        t2.value21.Style = Enum.FrameStyle.RobloxRound
        t2.value22 = Label(t2.value23, "Prop Hub Premiums", UDim2.new(0.5, 0, 1, 0), UDim2.new(0, 15, 0, 0))
        t2.value22.FontSize = Enum.FontSize.Size12
        t2.value22.TextXAlignment = Enum.TextXAlignment.Left
        t2.value22.ZIndex = 3
        t2.value22 = Button(t2.value23, "x", UDim2.new(0, 20, 0, 20), UDim2.new(1, -15, 0, -9), function()
            ToggleMenu()
        end)
        t2.value22.FontSize = Enum.FontSize.Size12
        t2.value22.Style = Enum.ButtonStyle.Custom
        t2.value22.BackgroundTransparency = 1
        t2.value22.ZIndex = 3
        t2.value24 = Frame(t2.value21, UDim2.new(1, -10, 1, -35), UDim2.new(0, 5, 0, 30))
        t2.value24.Name = "Main"
        t2.value24.Style = Enum.FrameStyle.RobloxRound
        t2.value25 = ImageLabel(t2.value21, "79148306484407", UDim2.new(0, 100, 0, 100), UDim2.new(0, -50, 0, -50))
        t2.value25.ZIndex = 4

        local function v95()
            local function v96()
                local v97 = true

                while task.wait(0.0025) do
                    if v97 == false then
                        t2.value25.Rotation = t2.value25.Rotation + 1
                        v97 = t2.value25.Rotation >= 10 and true or v97
                    else
                        t2.value25.Rotation = t2.value25.Rotation - 1

                        if t2.value25.Rotation <= -10 then
                            v97 = false
                        end
                    end
                end
            end

            Execute(v96)
        end

        pcall(v95)
        t2.value26 = Frame(t2.value24, UDim2.new(0, 5, 1, 0), UDim2.new(0, 110, 0, 0))
        t2.value26.BackgroundColor3 = t2.value37
        t2.value26.BackgroundTransparency = 0.5
        t2.value26.BorderSizePixel = 0
        t2.value26 = Frame(t2.value24, UDim2.new(0, 10, 1, 0), UDim2.new(0, 100, 0, 0))
        t2.value26.BackgroundColor3 = t2.value37
        t2.value26.BackgroundTransparency = 0.75
        t2.value26.BorderSizePixel = 0
        t2.value26 = Frame(t2.value24, UDim2.new(0, 10, 1, 0), UDim2.new(1, -10, 0, 0))
        t2.value26.BackgroundColor3 = t2.value37
        t2.value26.BackgroundTransparency = 0.75
        t2.value26.BorderSizePixel = 0
        t2.value27 = ScrollFrame(t2.value24, UDim2.new(0, 110, 1, 0), UDim2.new(0, 0, 0, 0))
        t2.value27.BackgroundColor3 = t2.value37
        t2.value27.BackgroundTransparency = 0.75
        t2.value27.BorderSizePixel = 0
        t2.value28 = Frame(t2.value24, UDim2.new(1, -115, 1, 0), UDim2.new(0, 115, 0, 0))
        t2.value28.BackgroundColor3 = t2.value37
        t2.value28.BackgroundTransparency = 0.75
        t2.value28.BorderSizePixel = 0
        t2.value29 = Button(p46, "SHOW", UDim2.new(0, 50, 0, 50), UDim2.new(0, -50, 1, -50), function()
            ToggleMenu()
        end)
        t2.value29.TextWrapped = false
        t2.value30 = Frame(t2.value27, UDim2.new(0, 100, 0, 0), UDim2.new(0, 0, 0, 0))
        t2.value30.BackgroundTransparency = 1
        t2.value31 = Frame(t2.value28, UDim2.new(1, -10, 1, 0), UDim2.new(0, 0, 0, 0))
        t2.value31.BackgroundTransparency = 1
        GeneratePropTab()
        GenerateTrollTab()
        GenerateExtraTab()

        return t2.value21
    end
    function PlayIntro(p47)
        t2.value14 = Frame(p47, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0))
        t2.value14.Style = Enum.FrameStyle.RobloxRound
        ImageLabel(t2.value14, "79148306484407", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
        PlaySFX(145487017, 1, 0.75)
        t2.value14:TweenSizeAndPosition(UDim2.new(0, 300, 0, 300), UDim2.new(0.5, -150, 0.5, -150), "Out", "Bounce", 0.5, true)
        task.wait(1)
        PlaySFX(145487017, 0.75, 1.25)
        t2.value14:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Bounce", 0.5, true)
        task.wait(0.75)
        t2.value14:Destroy()
        t2.value15 = Frame(p47, UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0))
        t2.value15.Style = Enum.FrameStyle.RobloxRound
        t2.value16 = Label(t2.value15, "Prop Hub Premiums", UDim2.new(1, 10, 0.5, 10), UDim2.new(0, -5, 0, -5))
        t2.value16.FontSize = Enum.FontSize.Size24
        t2.value17 = Label(t2.value15, "Made by c00lful", UDim2.new(1, 10, 0.4, 0), UDim2.new(0, -5, 0.5, 5))
        t2.value17.FontSize = Enum.FontSize.Size14
        PlaySFX(145487017, 1, 0.75)
        t2.value15:TweenSizeAndPosition(UDim2.new(0, 300, 0, 300), UDim2.new(0.5, -150, 0.5, -150), "Out", "Bounce", 0.5, true)
        task.wait(1)
        PlaySFX(145487017, 0.75, 1.25)
        t2.value15:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "Out", "Bounce", 0.5, true)
        task.wait(0.75)
        t2.value15:Destroy()
    end

    t2.value48 = "PHANN_"
    t2.value49 = 5
    t2.value50 = 180
    t2.value51 = Instance.new("ScreenGui")
    t2.value51.Name = "PropHubAnnouncements"
    t2.value51.ResetOnSpawn = false
    t2.value51.IgnoreGuiInset = false
    t2.value51.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    t2.value51.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    t2.value52 = nil
    t2.value53 = nil

    function t2.value53(p48, p49)
        task.spawn(function()
            local function v98()
                return game:GetService("Players"):GetUserThumbnailAsync(p48, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end

            local result

            v98, result = pcall(v98)

            if not (v98 and result) then
                return
            end

            p49(result)
        end)
    end

    t2.value54 = nil

    function t2.value54(_, p50)
        if t2.value4[string.lower(p50 or "")] ~= true then
            return
        end
    end
    function t2.value55(p51)
        local Name = game.Players.LocalPlayer.Name

        if t2.value4[string.lower(Name or "")] ~= true then
            warn("[Prop Hub] Not authorized to announce")

            return
        end

        if not p51 or #p51 == 0 then
            return
        end

        if #p51 > t2.value50 then
            Name = t2.value50
            p51 = string.sub(p51, 1, Name) .. "..."
        end

        Name = t2.value48 .. p51

        if pcall(function()
            local TextChatService = game:GetService("TextChatService")
            local TextChannels = TextChatService.TextChannels

            if not TextChannels then
                if TextChannels then
                    TextChannels:SendAsync(Name)

                    return true
                else
                    return false
                end

                return
            end

            TextChannels = TextChatService.TextChannels:FindFirstChild("RBXGeneral")

            if TextChannels then
                TextChannels:SendAsync(Name)

                return true
            else
                return false
            end
        end) then
            t2.value54(p51, game.Players.LocalPlayer.Name)

            return
        end

        pcall(function()
            local DefaultChatSystemChatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            local SayMessageRequest

            if DefaultChatSystemChatEvents then
                SayMessageRequest = DefaultChatSystemChatEvents.SayMessageRequest
            else
                SayMessageRequest = DefaultChatSystemChatEvents
            end

            if not SayMessageRequest then
                return
            end

            DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Name, "All")
        end)
        t2.value54(p51, game.Players.LocalPlayer.Name)
    end
    function t2.value56()
        local Name = game.Players.LocalPlayer.Name

        if t2.value4[string.lower(Name or "")] == true then
            if not t2.value23 then
                return
            end

            return
        else
            return
        end
    end

    (function()
        local function v106()
            game:GetService("TextChatService").MessageReceived:Connect(function(p52)
                local Text = p52.Text or ""
                local v108 = #t2.value48

                if string.sub(Text, 1, v108) ~= t2.value48 then
                    return
                end

                v108 = #t2.value48 + 1
                Text = string.sub(Text, v108)
                v108 = p52.TextSource

                if v108 then
                    v108 = p52.TextSource.Name
                end

                v108 = v108 or "unknown"

                if v108 == game.Players.LocalPlayer.Name then
                    return
                end

                t2.value54(Text, v108)
            end)
        end

        pcall(v106)
        pcall(function()
            local DefaultChatSystemChatEvents = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            local OnMessageDoneFiltering

            if DefaultChatSystemChatEvents then
                OnMessageDoneFiltering = DefaultChatSystemChatEvents.OnMessageDoneFiltering
            else
                OnMessageDoneFiltering = DefaultChatSystemChatEvents
            end

            if not OnMessageDoneFiltering then
                return
            end

            DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(p53)
                local Message = p53.Message or ""
                local v112 = #t2.value48

                if string.sub(Message, 1, v112) ~= t2.value48 then
                    return
                end

                v112 = #t2.value48 + 1
                Message = string.sub(Message, v112)
                v112 = p53.FromSpeaker or "unknown"

                if v112 == game.Players.LocalPlayer.Name then
                    return
                end

                t2.value54(Message, v112)
            end)
        end)
    end)()
    pcall(function()
        local TextChatService = game:GetService("TextChatService")

        if not TextChatService.OnIncomingMessage then
            return
        end

        local OnIncomingMessage = TextChatService.OnIncomingMessage

        function TextChatService.OnIncomingMessage(p54)
            local Text = p54.Text or ""
            local v116 = #t2.value48

            if string.sub(Text, 1, v116) == t2.value48 then
                Text = Instance.new("TextChatMessageProperties")
                Text.TextTransparency = 1

                return Text
            else
                if OnIncomingMessage then
                    return OnIncomingMessage(p54)
                else
                    return nil
                end

                return
            end
        end
    end)
    t2.value57 = Instance.new("ScreenGui", Folder)
    t2.value57.Name = "PropHubPremiums"
    t2.value57.ResetOnSpawn = false
    Execute(function()
        local function v117()
            task.wait(0.25)
            PlayIntro(t2.value57)
            GenerateMenu(t2.value57)
            t2.value56()
            task.wait(0.25)
            PlaySFX(145487017, 0.85, 1.1)
            t2.value29:TweenPosition(UDim2.new(0, 0, 1, -50), "Out", "Bounce", 1, true)
        end

        pcall(v117)
    end)
    print("[Prop Hub Premiums] Loaded \226\128\148 c00lful + c00Iful")
    print("[Prop Hub Premiums] Prop (42) | Troll (5) | Extra (4)")
    print("[Prop Hub Premiums] Owners: c00lful, c00Iful | No name tags")

    return
end
value4()
t1.value2 = 0
while true do
    t1.value4 = not _G.__PropHubPremiumKeyOK
    t1.value3 = t1.value4

    if t1.value4 then
        t1.value5 = t1.value1
        value4 = not _G.__PropHubPremiumKeyFailed

        if value4 then
            value4 = t1.value2 < 120
        end

        t1.value4 = value4
        value4 = t1.value5

        local value42 = t1.value4

        t1.value1 = value4
        t1.value3 = value42
    end

    if not t1.value3 then
        break
    end

    task.wait(0.25)
    t1.value2 = t1.value2 + 0.25
end
t1.value5 = _G.__PropHubPremiumKeyFailed
value4 = t1.value5
if t1.value5 then
    if value4 then
        return
    end

    return
end
value4 = not _G.__PropHubPremiumKeyOK
if value4 then
    return
end
