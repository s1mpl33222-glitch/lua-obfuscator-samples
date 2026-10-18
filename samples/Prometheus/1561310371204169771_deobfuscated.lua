-- This file was generated at discord.gg/syncrypt

local t1 = {
	value1 = game:GetService("HttpService"),
	value2 = game:GetService("MarketplaceService"),
	value3 = game:GetService("TweenService"),
	value4 = game:GetService("RunService"),
	value5 = game:GetService("SoundService"),
	value6 = game:GetService("CoreGui"),
	value7 = game:GetService("Players"),
	value8 = game:GetService("StarterGui"),
	value9 = game:GetService("UserInputService"),
	value10 = game:GetService("TeleportService"),
	value11 = game:GetService("VirtualUser"),
	value12 = game:GetService("Lighting"),
	value13 = game:GetService("Stats")
}
t1.value14 = t1.value7.LocalPlayer
local s1 = "NexbyteHub"
t1.value15 = s1 .. "/GameCache_v3.json"
t1.value16 = s1 .. "/LoaderConfig.json"
t1.value17 = "https://raw.githubusercontent.com/Axrex664/NexbyteLoader/main/games/"
t1.value18 = "https://api.github.com/repos/Axrex664/NexbyteLoader/contents/games?ref=main"
local isfolder_ = isfolder
if isfolder_ then
    isfolder_ = not isfolder(s1)
end
if isfolder_ then
    makefolder(s1)
end
s1 = game.PlaceId
t1.value19 = tostring(s1)
t1.value20 = "No errors reported."
function t1.value21(p1)
    task.spawn(function()
        local soundId = p1 == "success" and "rbxassetid://6895079853" or (p1 == "error" and "rbxassetid://9069609268" or (p1 == "notify" and "rbxassetid://6042053626" or "rbxassetid://6042053626"))
        local Sound = Instance.new("Sound")

        Sound.SoundId = soundId
        Sound.Volume = 0.4
        Sound.Parent = t1.value5
        Sound:Play()
        Sound.Ended:Connect(function()
            Sound:Destroy()
        end)
    end)
end
t1.value22 = {}
function t1.value22.Notify(p2, p3, p4, p5, p6)
    t1.value21("notify")

    if p6 then
        p6:Notify({
			["Title"] = p2,
			["Content"] = p3,
			["Icon"] = p5 or "info",
			["Duration"] = p4 or 3
		})

        return
    else
        local value8 = t1.value8

        value8:SetCore("SendNotification", {
			["Title"] = p2,
			["Text"] = p3,
			["Duration"] = p4 or 3
		})

        return
    end
end
t1.value23 = {
	["Gui"] = nil,
	["Connection"] = nil
}
function t1.value23.Create()
    if t1.value23.Gui then
        return
    end
end
t1.value24 = nil
function t1.value23.Remove()
    if t1.value23.Connection then
        t1.value23.Connection:Disconnect()
        t1.value23.Connection = nil
    end

    if not t1.value23.Gui then
        return
    end

    t1.value23.Gui:Destroy()
    t1.value23.Gui = nil
end
t1.value25 = {
	["Gui"] = nil,
	["Connection"] = nil
}
function t1.value25.Create()
    if t1.value25.Gui then
        return
    end
end
function t1.value25.Remove()
    if t1.value25.Connection then
        t1.value25.Connection:Disconnect()
        t1.value25.Connection = nil
    end

    if not t1.value25.Gui then
        return
    end

    t1.value25.Gui:Destroy()
    t1.value25.Gui = nil
end
function t1.value26()
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "NexbyteSplash"
    ScreenGui.DisplayOrder = 9999

    local gethui_ = gethui

    if gethui_ then
        gethui_ = gethui()
    end

    ScreenGui.Parent = gethui_ or (t1.value6 or t1.value14:WaitForChild("PlayerGui"))
    gethui_ = Instance.new("Frame")
    gethui_.Size = UDim2.fromOffset(260, 60)
    gethui_.Position = UDim2.new(0.5, -130, 0.5, -30)
    gethui_.BackgroundColor3 = Color3.fromHex("#0d0b14")
    gethui_.BackgroundTransparency = 1
    gethui_.BorderSizePixel = 0
    gethui_.ClipsDescendants = true
    gethui_.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = gethui_
    UICorner = Instance.new("UIStroke")
    UICorner.Color = Color3.fromHex("#8b5cf6")
    UICorner.Transparency = 1
    UICorner.Thickness = 1.5
    UICorner.Parent = gethui_

    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.Size = UDim2.fromOffset(24, 24)
    ImageLabel.Position = UDim2.new(0, 15, 0.5, -12)
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = "rbxassetid://10709791437"
    ImageLabel.ImageColor3 = Color3.fromHex("#c4b5fd")
    ImageLabel.ImageTransparency = 1
    ImageLabel.Parent = gethui_

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Size = UDim2.new(1, -50, 1, 0)
    TextLabel.Position = UDim2.new(0, 48, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Loading Nexbyte Hub..."
    TextLabel.TextColor3 = Color3.fromHex("#f8fafc")
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextTransparency = 1
    TextLabel.Parent = gethui_

    local connection = t1.value4.RenderStepped:Connect(function(dt)
        ImageLabel.Rotation = ImageLabel.Rotation + dt * 250
    end)

    t1.value3:Create(gethui_, TweenInfo.new(0.4), {
		["BackgroundTransparency"] = 0
	}):Play()

    local value3 = t1.value3
    local TweenInfo_ = TweenInfo

    value3.Create(value3, UICorner, TweenInfo_.new(0.4), {
		["Transparency"] = 0.5
	}):Play()
    t1.value3:Create(ImageLabel, TweenInfo.new(0.4), {
		["ImageTransparency"] = 0
	}):Play()
    t1.value3:Create(TextLabel, TweenInfo.new(0.4), {
		["TextTransparency"] = 0
	}):Play()
    task.wait(1.4)

    if not connection then
        gethui_ = t1.value3:Create(gethui_, TweenInfo.new(0.4), {
			["BackgroundTransparency"] = 1
		})
        connection = t1.value3
        value3 = TweenInfo
        connection.Create(connection, UICorner, value3.new(0.4), {
			["Transparency"] = 1
		}):Play()
        t1.value3:Create(ImageLabel, TweenInfo.new(0.4), {
			["ImageTransparency"] = 1
		}):Play()
        t1.value3:Create(TextLabel, TweenInfo.new(0.4), {
			["TextTransparency"] = 1
		}):Play()
        gethui_:Play()
        gethui_.Completed:Wait()
        ScreenGui:Destroy()

        return
    end

    connection:Disconnect()
    gethui_ = t1.value3:Create(gethui_, TweenInfo.new(0.4), {
		["BackgroundTransparency"] = 1
	})
    connection = t1.value3
    value3 = TweenInfo
    connection.Create(connection, UICorner, value3.new(0.4), {
		["Transparency"] = 1
	}):Play()
    t1.value3:Create(ImageLabel, TweenInfo.new(0.4), {
		["ImageTransparency"] = 1
	}):Play()
    t1.value3:Create(TextLabel, TweenInfo.new(0.4), {
		["TextTransparency"] = 1
	}):Play()
    gethui_:Play()
    gethui_.Completed:Wait()
    ScreenGui:Destroy()
end
t1.value27 = nil
function t1.value27(p7)
    local request_ = request

    if request_ then
        if request_ then
            return request_(p7)
        else
            return nil
        end

        return
    end

    request_ = http_request

    if request_ then
        if request_ then
            return request_(p7)
        else
            return nil
        end

        return
    end

    request_ = syn

    if not request_ then
        if request_ then
            return request_(p7)
        else
            return nil
        end

        return
    end

    request_ = syn.request

    if request_ then
        return request_(p7)
    else
        return nil
    end
end
function t1.value28(p8)
    local Body
    local ok, result = pcall(function()
        local t2 = {
			["Url"] = p8,
			["Method"] = "GET"
		}

        t2 = t1.value27(t2)

        local Body2

        if t2 then
            Body2 = t2.Body
        else
            Body2 = t2
        end

        if Body2 then
            Body = t2.Body

            return
        else
            Body = (cloneref and cloneref(game) or game):HttpGet(p8, true)

            return
        end
    end)

    return ok, Body, result
end
function t1.value29()
    local identifyexecutor_ = identifyexecutor

    if not identifyexecutor_ then
        return identifyexecutor_ or (getexecutorname and getexecutorname() or "Unknown Executor")
    end

    identifyexecutor_ = identifyexecutor()

    return identifyexecutor_ or (getexecutorname and getexecutorname() or "Unknown Executor")
end
function t1.value30()
    local writefile_ = writefile

    writefile_ = type(writefile_) == "function"

    local readfile_ = readfile

    readfile_ = type(readfile_) == "function"

    local value27 = t1.value27

    value27 = type(value27({})) == "function"

    local setclipboard_ = setclipboard

    return {
		["writefile"] = writefile_,
		["readfile"] = readfile_,
		["request"] = value27,
		["clipboard"] = type(setclipboard_) == "function"
	}
end
function t1.value31(p9)
    local writefile_ = writefile
    writefile_ = { "writefile", type(writefile_) == "function" }
    local readfile_ = readfile
    readfile_ = { "readfile", type(readfile_) == "function" }
    local value27 = t1.value27
    value27 = { "request / http_request", type(value27({})) == "function" }
    local setclipboard_ = setclipboard
    setclipboard_ = { "setclipboard", type(setclipboard_) == "function" }
    local getgc_ = getgc
    getgc_ = { "getgc", type(getgc_) == "function" }
    local hookmetamethod_ = hookmetamethod
    hookmetamethod_ = { "hookmetamethod", type(hookmetamethod_) == "function" }
    local firetouchinterest_ = firetouchinterest
    firetouchinterest_ = { "firetouchinterest", type(firetouchinterest_) == "function" }
    local gethui_ = gethui
    gethui_ = { "gethui", type(gethui_) == "function" }
    local cloneref_ = cloneref
    cloneref_ = type(cloneref_) == "function"
    writefile_ = {
		writefile_,
		readfile_,
		value27,
		setclipboard_,
		getgc_,
		hookmetamethod_,
		firetouchinterest_,
		gethui_,
		{ "cloneref", cloneref_ },
		{ "getgenv", type(getgenv) == "function" }
	}
    setclipboard_ = 0
    getgc_ = "Executor Compatibility Report:\n"
    for _, v in ipairs(writefile_) do
        firetouchinterest_ = v[1]

        if v[2] then
            setclipboard_ = setclipboard_ + 1
            getgc_ = getgc_ .. string.format("\226\156\133 %s: Supported\n", firetouchinterest_)
        else
            getgc_ = getgc_ .. string.format("\226\157\140 %s: Missing\n", firetouchinterest_)
        end
    end
    readfile_ = setclipboard_ / #writefile_ * 100
    readfile_ = math.floor(readfile_)
    local v39 = getgc_ .. string.format("\nOverall Score: %d%% (%d/%d Passed)", readfile_, setclipboard_, #writefile_)
    writefile_ = {
		["Title"] = "Executor Test (" .. t1.value29() .. ")",
		["Content"] = v39,
		["Buttons"] = {
			{
				["Title"] = "Copy Report",
				["Callback"] = function()
        if not setclipboard then
            return
        end

        setclipboard(v39)
        t1.value22.Notify("Report Copied", "Report copied to clipboard.", 2, "check", nil)
    end
			},
			{
				["Title"] = "Close"
			}
		}
	}
    p9:Dialog(writefile_)
end
function t1.value32(p10, p11, p12, p13)
    t1.value21("error")
    t1.value20 = string.format("[%s] %s\nTime: %s", p10, p11, os.date("%X"))

    if not p12 then
        return
    end

    t1.value22.Notify("Error " .. p10, p11, 6, "alert-circle", p13)
end
function t1.value33(p14)
    local v40 = p14:lower()

    return (v40:find("fruit") or (v40:find("blox") or (v40:find("sword") or v40:find("blade")))) and "swords" or ((v40:find("bed") or (v40:find("wars") or (v40:find("tower") or v40:find("defense")))) and "shield-alert" or ((v40:find("sim") or (v40:find("clicker") or v40:find("tycoon"))) and "mouse-pointer" or ((v40:find("gun") or (v40:find("shoot") or (v40:find("arsenal") or v40:find("fps")))) and "crosshair" or "gamepad-2")))
end
t1.value24 = nil
function t1.value34(p15)
    if p15 then
        if t1.value24 then
            return
        end

        return
    end

    if not t1.value24 then
        return
    end

    t1.value24:Disconnect()
    t1.value24 = nil
end
function t1.value35()
    pcall(function()
        settings().Rendering.QualityLevel = 1
        t1.value12.GlobalShadows = false
        t1.value12.FogEnd = 9000000000

        local ipairs_ = ipairs
        local game_ = game

        for _, descendant in ipairs_(game_:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.Material = Enum.Material.SmoothPlastic
                descendant.Reflectance = 0
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant:Destroy()
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                descendant.Enabled = false
            end
        end
    end)
end
function t1.value36(p16)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NexbyteToggleWidget"
    ScreenGui.DisplayOrder = 999
    local gethui_ = gethui
    if gethui_ then
        gethui_ = gethui()
    end
    ScreenGui.Parent = gethui_ or (t1.value6 or t1.value14:WaitForChild("PlayerGui"))
    gethui_ = Instance.new("ImageButton")
    gethui_.Size = UDim2.fromOffset(45, 45)
    gethui_.Position = UDim2.new(0, 15, 0.5, -22)
    gethui_.BackgroundColor3 = Color3.fromHex("#1a1625")
    gethui_.Image = "rbxassetid://10709791437"
    gethui_.ImageColor3 = Color3.fromHex("#c4b5fd")
    gethui_.AutoButtonColor = true
    gethui_.Parent = ScreenGui
    ScreenGui = Instance.new("UICorner")
    ScreenGui.CornerRadius = UDim.new(0, 12)
    ScreenGui.Parent = gethui_
    ScreenGui = Instance.new("UIStroke")
    ScreenGui.Color = Color3.fromHex("#8b5cf6")
    ScreenGui.Thickness = 1.5
    ScreenGui.Parent = gethui_
    local u47 = false
    local Position
    local Position2
    gethui_.InputBegan:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u47 = true
        Position = input.Position
        Position2 = gethui_.Position
    end)
    gethui_.InputEnded:Connect(function(input)
        if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            return
        end

        u47 = false
    end)
    t1.value9.InputChanged:Connect(function(input)
        local v50 = u47

        if v50 then
            v50 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
        end

        if not v50 then
            return
        end

        v50 = input.Position - Position
        gethui_.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v50.X, Position2.Y.Scale, Position2.Y.Offset + v50.Y)
    end)
    gethui_.MouseButton1Click:Connect(function()
        t1.value21("notify")

        if not p16 then
            return
        end

        p16:Toggle()
    end)
end
t1.value37 = nil
function t1.value37(p17)
    if getgenv().NexbyteExecuted then
        return
    end

    getgenv().NexbyteExecuted = true

    if not p17 then
        t1.value26()
    end

    local t3 = {}
    local isfile_ = isfile

    if isfile_ then
        isfile_ = isfile(t1.value16)
    end

    if not isfile_ then
        isfile_, v74 = t1.value28("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")

        if isfile_ and v74 then
            isfile_, v74 = loadstring(v74)

            if type(isfile_) ~= "function" then
                t1.value32("ERR_101", "WindUI Syntax Error: " .. tostring(v74), true, nil)
                getgenv().NexbyteExecuted = false

                return
            end

            return
        else
            t1.value32("ERR_101", "Failed to download WindUI library.", true, nil)
            getgenv().NexbyteExecuted = false

            return
        end

        return
    end

    isfile_ = function()
        t3 = t1.value1:JSONDecode(readfile(t1.value16))
    end
    pcall(isfile_)

    local v53

    isfile_, v53 = t1.value28("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")

    if isfile_ and v53 then
        isfile_, v53 = loadstring(v53)

        if type(isfile_) ~= "function" then
            t1.value32("ERR_101", "WindUI Syntax Error: " .. tostring(v53), true, nil)
            getgenv().NexbyteExecuted = false

            return
        end

        return
    else
        t1.value32("ERR_101", "Failed to download WindUI library.", true, nil)
        getgenv().NexbyteExecuted = false

        return
    end
end
t1.value37(false)
