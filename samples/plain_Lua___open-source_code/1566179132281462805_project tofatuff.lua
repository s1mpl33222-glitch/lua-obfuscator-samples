do
        local v = pcall
        local v2 = error
        local v3 = type
        local v4 = typeof
        local v5 = select
        local v6 = ipairs

        local random = math and math.random or function()
                return 0
        end

        local str = "hduSjOT3xk44"

        local function fn()
                v2("[Panda] This script could not verify its runtime environment.", 0)
        end

        local tbl = {}

        tbl[#tbl + 1] = function()
                if v4(Enum.Material.Plastic) ~= "EnumItem" then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                local HttpService = game:GetService("HttpService")
                local json = HttpService:JSONEncode({ p = true })

                if v3(json) ~= "string" then
                        v2("x")
                end

                local data = HttpService:JSONDecode(json)

                if v3(data) ~= "table" or data.p ~= true then
                        v2("x")
                end

                local v7 = HttpService:GenerateGUID(false)

                if v3(v7) ~= "string" or #v7 ~= 36 or string.sub(v7, 9, 9) ~= "-" then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                local n = Vector3.new(1, 2, 3) + Vector3.one

                if v4(n) ~= "Vector3" then
                        v2("x")
                end

                if n.X ~= 2 or n.Y ~= 3 or n.Z ~= 4 then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                local Workspace_ = game:GetService("Workspace")

                if v4(Workspace_) ~= "Instance" then
                        v2("x")
                end

                if Workspace_:IsA("Workspace") ~= true then
                        v2("x")
                end

                if Workspace_:IsA("NC_" .. str) ~= false then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                if v(getfenv, 2147483647) then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                if v(function()
                        return game()
                end) then
                        v2("x")
                end

                if v(function()
                        for k in game, nil, nil do
                        end
                end) then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                local part, v7 = v(Instance.new, "Part")

                if not part or v4(v7) ~= "Instance" then
                        v2("x")
                end

                local name = "P_" .. str
                v7.Name = name

                if v7.Name ~= name then
                        v2("x")
                end

                if v(function()
                        return v7["NP_" .. str]
                end) then
                        v2("x")
                end

                v(function()
                        v7:Destroy()
                end)
        end

        tbl[#tbl + 1] = function()
                if v4(game) ~= "Instance" then
                        v2("x")
                end
        end

        tbl[#tbl + 1] = function()
                if v(Instance.new, "NC_" .. str .. tostring(random(1, 1000000))) then
                        v2("x")
                end
        end

        local flag = false

        for _, v7 in v6(tbl) do
                if not v(v7) then
                        flag = true
                end
        end

        local n = 0

        local function fn2(arg)
                if not v(arg) then
                        n += 1
                end
        end

        local tbl2 = {}

        tbl2[#tbl2 + 1] = function()
                local info = debug and debug.info
                if v3(info) ~= "function" then
                        return
                end
                local n2 = 0

                if info(v, "s") ~= "[C]" then
                        n2 = 1
                end

                if info(v3, "s") ~= "[C]" then
                        n2 += 1
                end

                if info(v4, "s") ~= "[C]" then
                        n2 += 1
                end

                if n2 >= 2 then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local info = debug and debug.info

                if v3(info) == "function" and info(print, "s") ~= "[C]" then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local n2 = 0

                local connection = game:GetService("RunService").Heartbeat:Connect(function()
                        n2 += 1
                end)

                local n3 = 0

                while true do
                        task.wait()
                        n3 += 1
                        if not (n2 >= 2 or n3 >= 8) then
                                continue
                        end
                        break
                end

                connection:Disconnect()

                if n2 < 2 then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local localPlayer = game:GetService("Players").LocalPlayer

                if v4(localPlayer) ~= "Instance" then
                        v2("x")
                end

                local userId = localPlayer.UserId

                if v3(userId) ~= "number" or userId <= 0 then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local count = collectgarbage("count")
                local tbl3 = {}

                for i = 1, 400 do
                        tbl3[i] = { i }
                end

                if collectgarbage("count") <= count then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local flag2 = false

                local function fn3(...)
                        if v5("#", ...) > 0 then
                                flag2 = true
                        end
                end

                fn3()

                if flag2 then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local tbl3 = {}

                local v7, v8 = v(function()
                        v2(tbl3)
                end)

                if v8 ~= tbl3 then
                        v2("x")
                end
        end

        tbl2[#tbl2 + 1] = function()
                local now = os.clock()
                task.wait()

                if os.clock() - now <= 0 then
                        v2("x")
                end
        end

        for _, v7 in v6(tbl2) do
                fn2(v7)
        end

        if flag or n >= 4 then
                fn()
        end
end

if getgenv().ScriptExecuted then
        return
end

if identifyexecutor() then
        identifyexecutor()
end

getgenv().ScriptExecuted = true
local flag
flag = false
local TweenService
TweenService = game:GetService("TweenService")
local RunService
RunService = game:GetService("RunService")
local flag2
flag2 = true

task.spawn(function()
        local tbl = { "ParticleEmitter", "Trail", "Beam", "Fire", "Smoke", "Sparkles", "Explosion", "Sound" }

        local tbl2 = {
                Thrown = true,
                Preload = true,
                Built = true,
                Benchs = true,
                ["Floor/Roads"] = true,
                GrassBottom = true,
                GrassTop = true,
                Stuff = true,
                Trash = true,
                Trees = true,
                Grass = true,
                Walls = true,
                Tunnel = true,
        }

        local function fn(arg)
                for _, v in tbl, nil, nil do
                        if arg:IsA(v) then
                                return true
                        end
                end

                if (arg:IsA("Folder") or arg:IsA("Model")) and tbl2[arg.Name] then
                        return true
                end
                return false
        end

        local function fn2(descendant)
                if fn(descendant) then
                        task.defer(function()
                                if descendant and descendant.Parent then
                                        descendant:Destroy()
                                end
                        end)
                end
        end

        workspace.DescendantAdded:Connect(fn2)

        for _, v in workspace:GetDescendants() do
                fn2(v)
        end

        print("[zkayreal] Super Fix Lag Activated!")
end)

local tbl

tbl = {
        "France",
        "Netherlands",
        "United States",
        "United Kingdom",
        "Australia",
        "Germany",
        "India",
        "Brazil",
        "Singapore",
        "Japan",
}

local tbl2 = {
        Background = Color3.fromRGB(17, 18, 23),
        Panel = Color3.fromRGB(26, 27, 34),
        PanelAlt = Color3.fromRGB(33, 34, 43),
        Stroke = Color3.fromRGB(50, 51, 63),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextDim = Color3.fromRGB(145, 146, 158),
        Amber = Color3.fromRGB(240, 170, 60),
        Teal = Color3.fromRGB(70, 200, 190),
        Rose = Color3.fromRGB(225, 95, 110),
        Lavender = Color3.fromRGB(150, 130, 235),
        FarmOn = Color3.fromRGB(70, 200, 130),
        FarmOff = Color3.fromRGB(200, 70, 80),
}

local flag3
flag3 = true
local HttpService
HttpService = game:GetService("HttpService")
local v, fn

do
        local str = "ZKAYHub/PublicFarm/" .. game:GetService("Players").LocalPlayer.Name
        local str2 = str .. "/settings.json"

        local function fn2()
                if not isfolder("ZKAYHub") then
                        makefolder("ZKAYHub")
                end

                if not isfolder(str) then
                        makefolder(str)
                end
        end

        v = table.clone({ country = tbl[1], webhookUrl = "" })

        fn = function()
                fn2()
                local ok, result = pcall(HttpService.JSONEncode, HttpService, v)

                if ok then
                        writefile(str2, result)
                else
                        warn("[Project Tofa] Failed to encode settings:", result)
                end
        end

        local function fn3()
                fn2()
                if not isfile(str2) then
                        return
                end
                local ok, result = pcall(readfile, str2)
                if not ok then
                        warn("[Project Tofa] Failed to read settings file:", result)
                        return
                end
                local ok2, result2 = pcall(HttpService.JSONDecode, HttpService, result)
                if not ok2 or type(result2) ~= "table" then
                        warn("[Project Tofa] Failed to decode settings file, using defaults")
                        return
                end

                for k, v2 in pairs(result2) do
                        v[k] = v2
                end
        end

        fn3()
end

getgenv().TimeFarmed = getgenv().TimeFarmed or 0
getgenv().session_start = getgenv().session_start or os.time()
getgenv().carriedKills = getgenv().carriedKills or 0
getgenv().emotes = getgenv().emotes or 0
local fn2

fn2 = function(arg, arg2, arg3, arg4, arg5)
        local tween = TweenService:Create(arg, TweenInfo.new(arg3, arg4 or Enum.EasingStyle.Quint, arg5 or Enum.EasingDirection.Out), arg2)
        tween:Play()
        return tween
end

local createUIGradient

createUIGradient = function(parent, arg, arg2, rotation)
        local uiGradient = Instance.new("UIGradient")
        uiGradient.Color = ColorSequence.new(arg, arg2)
        uiGradient.Rotation = rotation or 90
        uiGradient.Parent = parent
        return uiGradient
end

local fn3

fn3 = function(arg, arg2)
        Instance.new("UICorner", arg).CornerRadius = UDim.new(0, arg2 or 8)
end

local createUIStroke

createUIStroke = function(parent, color, thickness, transparency)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = color or Color3.fromRGB(255, 255, 255)
        uiStroke.Thickness = thickness or 1
        uiStroke.Transparency = transparency or 0.85
        uiStroke.Parent = parent
        return uiStroke
end

local frame, imageLabel, textLabel, n, n2, frame2
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProjectYieldingUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.IgnoreGuiInset = true
screenGui.Parent = game.CoreGui
frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.ZIndex = 100
frame.Parent = screenGui
fn3(frame, 20)
imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 150, 0, 150)
imageLabel.Position = UDim2.new(0.5, -75, 0.5, -100)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://114841766449074"
imageLabel.ImageTransparency = 1
imageLabel.ZIndex = 101
imageLabel.Parent = frame
fn3(imageLabel, 20)
textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(0, 300, 0, 50)
textLabel.Position = UDim2.new(0.5, -150, 0.5, 70)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Project Tofa"
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 28
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextTransparency = 1
textLabel.ZIndex = 101
textLabel.Parent = frame
createUIGradient(textLabel, Color3.fromRGB(255, 150, 200), Color3.fromRGB(255, 255, 255), 0)
n = 700
n2 = 394
frame2 = Instance.new("Frame")
frame2.Name = "Sigma"
frame2.Size = UDim2.new(0, 700, 0, 394)
frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
frame2.AnchorPoint = Vector2.new(0.5, 0.5)
frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame2.BackgroundTransparency = 0
frame2.BorderSizePixel = 0
frame2.Active = true
frame2.Draggable = true
frame2.ZIndex = 50
frame2.ClipsDescendants = true
frame2.Visible = false
frame2.Parent = screenGui
fn3(frame2, 18)

do
        local uiGradient = Instance.new("UIGradient")
        local colorSequence = ColorSequence.new
        local tbl3 = {}
        local v2 = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
        local v3 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 0, 0))
        local v4 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(48, 48, 58))
        local v5 = ColorSequenceKeypoint.new(0.65, Color3.fromRGB(0, 0, 0))
        local new = ColorSequenceKeypoint.new
        local color = Color3.fromRGB
        tbl3[1] = v2
        tbl3[2] = v3
        tbl3[3] = v4
        tbl3[4] = v5

        do
                local values = table.pack(new(1, color(0, 0, 0)))
                table.move(values, 1, values.n, 5, tbl3)
        end

        uiGradient.Color = colorSequence(tbl3)
        uiGradient.Rotation = 45
        uiGradient.Offset = Vector2.new(-1, 0)
        uiGradient.Parent = frame2

        task.spawn(function()
                local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

                while true do
                        local tween = TweenService:Create(uiGradient, tweenInfo, { Offset = Vector2.new(1, 0) })
                        tween:Play()
                        tween.Completed:Wait()
                        uiGradient.Offset = Vector2.new(-1, 0)
                end
        end)
end

do
        local frame3 = Instance.new("Frame")
        frame3.Size = UDim2.new(0, 180, 0, 32)
        frame3.Position = UDim2.new(0, 14, 0, 12)
        frame3.BackgroundTransparency = 1
        frame3.ZIndex = 51
        frame3.Parent = frame2
        local imageLabel2 = Instance.new("ImageLabel")
        imageLabel2.Size = UDim2.new(0, 28, 0, 28)
        imageLabel2.BackgroundTransparency = 1
        imageLabel2.Image = "rbxassetid://114841766449074"
        imageLabel2.ZIndex = 52
        imageLabel2.Parent = frame3
        fn3(imageLabel2, 8)
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(0, 140, 0, 16)
        textLabel2.Position = UDim2.new(0, 36, 0, 6)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "Project Tofa"
        textLabel2.Font = Enum.Font.GothamBold
        textLabel2.TextSize = 12
        textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.ZIndex = 52
        textLabel2.Parent = frame3
        createUIGradient(textLabel2, Color3.fromRGB(255, 140, 200), Color3.fromRGB(255, 255, 255), 0)
end

local frame3
frame3 = Instance.new("Frame")
frame3.Size = UDim2.new(1, -32, 1, -62)
frame3.Position = UDim2.new(0, 16, 0, 50)
frame3.BackgroundTransparency = 1
frame3.ZIndex = 51
frame3.Parent = frame2
local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, 0, 0, 30)
textLabel2.Position = UDim2.new(0, 0, 0, 0)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "Suiryu Farm"
textLabel2.Font = Enum.Font.GothamBold
textLabel2.TextSize = 24
textLabel2.TextColor3 = Color3.fromRGB(255, 200, 60)
textLabel2.TextXAlignment = Enum.TextXAlignment.Left
textLabel2.ZIndex = 52
textLabel2.Parent = frame3
createUIGradient(textLabel2, Color3.fromRGB(255, 220, 100), Color3.fromRGB(255, 160, 40), 0)

do
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 18)
        frame4.Position = UDim2.new(0, 0, 0, 30)
        frame4.BackgroundTransparency = 1
        frame4.ZIndex = 51
        frame4.Parent = frame3
        local textLabel3 = Instance.new("TextLabel")
        textLabel3.Size = UDim2.new(0, 110, 1, 0)
        textLabel3.BackgroundTransparency = 1
        textLabel3.Text = "Your current plan:"
        textLabel3.Font = Enum.Font.Gotham
        textLabel3.TextSize = 12
        textLabel3.TextColor3 = Color3.fromRGB(180, 180, 190)
        textLabel3.TextXAlignment = Enum.TextXAlignment.Left
        textLabel3.ZIndex = 52
        textLabel3.Parent = frame4
        local textLabel4 = Instance.new("TextLabel")
        textLabel4.Size = UDim2.new(0, 100, 1, 0)
        textLabel4.Position = UDim2.new(0, 108, 0, 0)
        textLabel4.BackgroundTransparency = 1
        textLabel4.Text = flag2 and "[Premium]" or "[Freemium]"
        textLabel4.Font = Enum.Font.GothamBold
        textLabel4.TextSize = 20
        textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel4.TextXAlignment = Enum.TextXAlignment.Left
        textLabel4.ZIndex = 52
        textLabel4.Parent = frame4
        local imageLabel2 = Instance.new("ImageLabel")
        imageLabel2.BackgroundTransparency = 1
        imageLabel2.Size = UDim2.new(0, 25, 0, 25)

        if flag2 then
                imageLabel2.Position = UDim2.new(0, 210, 0.5, -10)
                imageLabel2.Image = "rbxassetid://78108949720918"
        else
                imageLabel2.Position = UDim2.new(0, 215, 0.5, -10)
                imageLabel2.Image = "rbxassetid://137799393139541"
        end

        imageLabel2.ScaleType = Enum.ScaleType.Fit
        imageLabel2.ZIndex = 53
        imageLabel2.Parent = frame4
        local uiGradient = Instance.new("UIGradient")

        if flag2 then
                local colorSequence = ColorSequence.new
                local tbl3 = {}
                local v2 = ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 180, 255))
                local v3 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(140, 220, 255))
                local v4 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
                local v5 = ColorSequenceKeypoint.new(0.65, Color3.fromRGB(140, 220, 255))
                local new = ColorSequenceKeypoint.new
                local color = Color3.fromRGB
                tbl3[1] = v2
                tbl3[2] = v3
                tbl3[3] = v4
                tbl3[4] = v5

                do
                        local values = table.pack(new(1, color(80, 180, 255)))
                        table.move(values, 1, values.n, 5, tbl3)
                end

                uiGradient.Color = colorSequence(tbl3)
        else
                local colorSequence = ColorSequence.new
                local tbl3 = {}
                local v2 = ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 200, 100))
                local v3 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(100, 240, 140))
                local v4 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 255, 225))
                local v5 = ColorSequenceKeypoint.new(0.65, Color3.fromRGB(100, 240, 140))
                local new = ColorSequenceKeypoint.new
                local color = Color3.fromRGB
                tbl3[1] = v2
                tbl3[2] = v3
                tbl3[3] = v4
                tbl3[4] = v5

                do
                        local values = table.pack(new(1, color(60, 200, 100)))
                        table.move(values, 1, values.n, 5, tbl3)
                end

                uiGradient.Color = colorSequence(tbl3)
        end

        uiGradient.Rotation = 0
        uiGradient.Offset = Vector2.new(-1, 0)
        uiGradient.Parent = textLabel4
        createUIStroke(textLabel4, flag2 and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(100, 240, 140), 1, 0.5)

        task.spawn(function()
                local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

                while textLabel4.Parent do
                        local tween = TweenService:Create(uiGradient, tweenInfo, { Offset = Vector2.new(1, 0) })
                        tween:Play()
                        tween.Completed:Wait()
                        uiGradient.Offset = Vector2.new(-1, 0)
                        RunService.RenderStepped:Wait()
                end
        end)
end

local tbl3

do
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 68)
        frame4.Position = UDim2.new(0, 0, 0, 56)
        frame4.BackgroundTransparency = 1
        frame4.ZIndex = 51
        frame4.Parent = frame3
        local uiGridLayout = Instance.new("UIGridLayout")
        uiGridLayout.CellSize = UDim2.new(0.19, 0, 1, 0)
        uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiGridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        uiGridLayout.StartCorner = Enum.StartCorner.TopLeft
        uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiGridLayout.Parent = frame4
        local tbl4 = {}

        local tbl5 = {
                id = "timer",
                label = "SESSION",
                value = "00:00:00",
                accent = Color3.fromRGB(255, 200, 60),
                short = false,
        }

        local tbl6 = {
                id = "kills",
                label = "KILLS",
                value = "0",
                accent = Color3.fromRGB(226, 100, 100),
                short = true,
        }

        local tbl7 = {
                id = "kph",
                label = "KILLS/HR",
                value = "0",
                accent = Color3.fromRGB(120, 220, 140),
                short = true,
        }

        local tbl8 = {
                id = "emotes",
                label = "EMOTES",
                value = "0",
                accent = Color3.fromRGB(220, 160, 60),
                short = true,
        }

        local tbl9 = {
                id = "total",
                label = "TOTAL KILLS",
                value = "0",
                accent = Color3.fromRGB(180, 120, 255),
                short = true,
        }

        tbl4[1] = tbl5
        tbl4[2] = tbl6
        tbl4[3] = tbl7
        tbl4[4] = tbl8
        tbl4[5] = tbl9
        tbl3 = {}

        for i, v2 in ipairs(tbl4) do
                local frame5 = Instance.new("Frame")
                frame5.Size = UDim2.new(1, 0, 1, 0)
                frame5.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
                frame5.BorderSizePixel = 0
                frame5.LayoutOrder = i
                frame5.ZIndex = 52
                frame5.Parent = frame4
                fn3(frame5, 12)
                createUIStroke(frame5, Color3.fromRGB(80, 80, 90), 1, 0.8)
                local frame6 = Instance.new("Frame")
                frame6.Size = UDim2.new(1, 0, 0, 2)
                frame6.BackgroundColor3 = v2.accent
                frame6.BorderSizePixel = 0
                frame6.ZIndex = 53
                frame6.Parent = frame5
                fn3(frame6, 2)
                local textLabel3 = Instance.new("TextLabel")
                textLabel3.Size = UDim2.new(1, -10, 0, 10)
                textLabel3.Position = UDim2.new(0, 6, 0, 6)
                textLabel3.BackgroundTransparency = 1
                textLabel3.Text = v2.label
                textLabel3.Font = Enum.Font.Gotham
                textLabel3.TextSize = 7
                textLabel3.TextColor3 = Color3.fromRGB(120, 120, 130)
                textLabel3.TextXAlignment = Enum.TextXAlignment.Left
                textLabel3.ZIndex = 53
                textLabel3.Parent = frame5
                local textLabel4 = Instance.new("TextLabel")
                textLabel4.Size = UDim2.new(1, -10, 0, 28)
                textLabel4.Position = UDim2.new(0, 6, 0, 16)
                textLabel4.BackgroundTransparency = 1
                textLabel4.Text = v2.value
                textLabel4.Font = Enum.Font.GothamBold
                textLabel4.TextSize = v2.short and 15 or 18
                textLabel4.TextColor3 = Color3.fromRGB(245, 245, 250)
                textLabel4.TextXAlignment = Enum.TextXAlignment.Left
                textLabel4.ZIndex = 53
                textLabel4.Parent = frame5
                local frame7 = Instance.new("Frame")
                frame7.Size = UDim2.new(0, 6, 0, 6)
                frame7.Position = UDim2.new(1, -12, 0, 6)
                frame7.BackgroundColor3 = v2.accent
                frame7.BorderSizePixel = 0
                frame7.ZIndex = 53
                frame7.Parent = frame5
                fn3(frame7, 99)
                tbl3[v2.id] = textLabel4
        end
end

local doServerHop

do
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 42)
        frame4.Position = UDim2.new(0, 0, 0, 132)
        frame4.BackgroundTransparency = 1
        frame4.ZIndex = 51
        frame4.Parent = frame3
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 12)
        uiListLayout.Parent = frame4
        local frame5 = Instance.new("Frame")
        frame5.Size = UDim2.new(0.5, -6, 1, 0)
        frame5.BackgroundTransparency = 1
        frame5.LayoutOrder = 1
        frame5.ZIndex = 51
        frame5.Parent = frame4
        local textLabel3 = Instance.new("TextLabel")
        textLabel3.Size = UDim2.new(1, 0, 0, 12)
        textLabel3.BackgroundTransparency = 1
        textLabel3.Text = "REGION"
        textLabel3.Font = Enum.Font.GothamMedium
        textLabel3.TextSize = 9
        textLabel3.TextColor3 = Color3.fromRGB(140, 140, 150)
        textLabel3.TextXAlignment = Enum.TextXAlignment.Left
        textLabel3.ZIndex = 52
        textLabel3.Parent = frame5
        local textButton = Instance.new("TextButton")
        textButton.Size = UDim2.new(1, 0, 0, 26)
        textButton.Position = UDim2.new(0, 0, 0, 14)
        textButton.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        textButton.BorderSizePixel = 0
        textButton.Text = ""
        textButton.AutoButtonColor = false
        textButton.ZIndex = 52
        textButton.Parent = frame5
        fn3(textButton, 8)
        createUIStroke(textButton, Color3.fromRGB(80, 80, 90), 1, 0.7)
        local textLabel4 = Instance.new("TextLabel")
        textLabel4.Size = UDim2.new(1, -32, 1, 0)
        textLabel4.Position = UDim2.new(0, 12, 0, 0)
        textLabel4.BackgroundTransparency = 1
        textLabel4.Text = v.country or "Select..."
        textLabel4.Font = Enum.Font.Gotham
        textLabel4.TextSize = 12
        textLabel4.TextColor3 = Color3.fromRGB(230, 230, 235)
        textLabel4.TextXAlignment = Enum.TextXAlignment.Left
        textLabel4.ZIndex = 53
        textLabel4.Parent = textButton
        local textLabel5 = Instance.new("TextLabel")
        textLabel5.Size = UDim2.new(0, 22, 1, 0)
        textLabel5.Position = UDim2.new(1, -26, 0, 0)
        textLabel5.BackgroundTransparency = 1
        textLabel5.Text = "▾"
        textLabel5.Font = Enum.Font.GothamBold
        textLabel5.TextSize = 12
        textLabel5.TextColor3 = Color3.fromRGB(140, 140, 150)
        textLabel5.ZIndex = 53
        textLabel5.Parent = textButton
        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Size = UDim2.new(1, 0, 0, 0)
        scrollingFrame.Position = UDim2.new(0, 0, 0, 40)
        scrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        scrollingFrame.BorderSizePixel = 0
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollingFrame.ScrollBarThickness = 5
        scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(140, 140, 150)
        scrollingFrame.ClipsDescendants = true
        scrollingFrame.Visible = false
        scrollingFrame.ZIndex = 200
        scrollingFrame.Parent = frame5
        fn3(scrollingFrame, 8)
        createUIStroke(scrollingFrame, Color3.fromRGB(80, 80, 90), 1, 0.7)
        local uiListLayout2 = Instance.new("UIListLayout")
        uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout2.Parent = scrollingFrame
        local n3 = 26
        local flag4 = false

        local function fn4()
                flag4 = false
                scrollingFrame.Visible = false
                scrollingFrame.Size = UDim2.new(1, 0, 0, 0)
                textLabel5.Text = "v"
        end

        local function fn5()
                flag4 = true
                scrollingFrame.Visible = true
                textLabel5.Text = "^"
                scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #tbl * n3)
                scrollingFrame.Size = UDim2.new(1, 0, 0, math.min(#tbl, 5) * n3)
        end

        textButton.MouseButton1Click:Connect(function()
                if flag4 then
                        fn4()
                else
                        fn5()
                end
        end)

        for i, v2 in ipairs(tbl) do
                local textButton2 = Instance.new("TextButton")
                textButton2.Name = v2
                textButton2.LayoutOrder = i
                textButton2.Size = UDim2.new(1, 0, 0, 26)
                textButton2.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
                textButton2.AutoButtonColor = true
                textButton2.Font = Enum.Font.Gotham
                textButton2.Text = "   " .. v2
                textButton2.TextXAlignment = Enum.TextXAlignment.Left
                textButton2.TextColor3 = Color3.fromRGB(220, 220, 225)
                textButton2.TextSize = 12
                textButton2.ZIndex = 201
                textButton2.Parent = scrollingFrame

                textButton2.MouseButton1Click:Connect(function()
                        v.country = v2
                        textLabel4.Text = v2
                        fn4()
                        fn()
                end)
        end

        local frame6 = Instance.new("Frame")
        frame6.Size = UDim2.new(0.5, -6, 1, 0)
        frame6.BackgroundTransparency = 1
        frame6.LayoutOrder = 2
        frame6.ZIndex = 51
        frame6.Parent = frame4
        local textLabel6 = Instance.new("TextLabel")
        textLabel6.Size = UDim2.new(1, 0, 0, 12)
        textLabel6.BackgroundTransparency = 1
        textLabel6.Text = "SERVER HOP"
        textLabel6.Font = Enum.Font.GothamMedium
        textLabel6.TextSize = 9
        textLabel6.TextColor3 = Color3.fromRGB(140, 140, 150)
        textLabel6.TextXAlignment = Enum.TextXAlignment.Left
        textLabel6.ZIndex = 52
        textLabel6.Parent = frame6
        local textButton2 = Instance.new("TextButton")
        textButton2.Size = UDim2.new(1, 0, 0, 26)
        textButton2.Position = UDim2.new(0, 0, 0, 14)
        textButton2.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        textButton2.BorderSizePixel = 0
        textButton2.Text = "Serverhop: OFF"
        textButton2.Font = Enum.Font.GothamBold
        textButton2.TextSize = 11
        textButton2.TextColor3 = Color3.fromRGB(220, 220, 225)
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 52
        textButton2.Parent = frame6
        fn3(textButton2, 8)
        createUIStroke(textButton2, Color3.fromRGB(80, 80, 90), 1, 0.7)
        doServerHop = getgenv().DoServerHop

        if doServerHop == nil then
                doServerHop = true
        end

        local function fn6(arg)
                doServerHop = arg

                if arg then
                        textButton2.Text = "Serverhop: ON"
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(70, 200, 130) }, 0.18)
                else
                        textButton2.Text = "Serverhop: OFF"
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(20, 20, 26) }, 0.18)
                end
        end

        textButton2.MouseButton1Click:Connect(function()
                fn6(not doServerHop)
        end)

        fn6(doServerHop)
end

local textButton

do
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 30)
        frame4.Position = UDim2.new(0, 0, 0, 180)
        frame4.BackgroundTransparency = 1
        frame4.ZIndex = 51
        frame4.Parent = frame3
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 10)
        uiListLayout.Parent = frame4
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -128, 1, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        textBox.BorderSizePixel = 0
        textBox.Font = Enum.Font.Gotham
        textBox.PlaceholderText = "https://discord.com/api/webhooks/..."
        textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
        textBox.Text = v.webhookUrl or ""
        textBox.TextColor3 = Color3.fromRGB(220, 220, 225)
        textBox.TextSize = 11
        textBox.ClearTextOnFocus = false
        textBox.TextXAlignment = Enum.TextXAlignment.Left
        textBox.ClipsDescendants = true
        textBox.LayoutOrder = 1
        textBox.ZIndex = 52
        textBox.Parent = frame4
        fn3(textBox, 8)
        createUIStroke(textBox, Color3.fromRGB(80, 80, 90), 1, 0.7)

        textBox:GetPropertyChangedSignal("Text"):Connect(function()
                v.webhookUrl = textBox.Text
                fn()
        end)

        local uiPadding = Instance.new("UIPadding")
        uiPadding.PaddingLeft = UDim.new(0, 12)
        uiPadding.Parent = textBox
        textButton = Instance.new("TextButton")
        textButton.Size = UDim2.new(0, 118, 1, 0)
        textButton.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
        textButton.BorderSizePixel = 0
        textButton.Text = "Test Webhook"
        textButton.Font = Enum.Font.GothamMedium
        textButton.TextSize = 11
        textButton.TextColor3 = Color3.fromRGB(220, 220, 225)
        textButton.LayoutOrder = 2
        textButton.ZIndex = 52
        textButton.Parent = frame4
end

fn3(textButton, 8)
createUIStroke(textButton, Color3.fromRGB(80, 80, 90), 1, 0.7)

textButton.MouseEnter:Connect(function()
        fn2(textButton, { BackgroundColor3 = Color3.fromRGB(30, 30, 38) }, 0.15)
end)

textButton.MouseLeave:Connect(function()
        fn2(textButton, { BackgroundColor3 = Color3.fromRGB(20, 20, 26) }, 0.15)
end)

local fn4

do
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 34)
        frame4.Position = UDim2.new(0, 0, 0, 218)
        frame4.BackgroundTransparency = 1
        frame4.ZIndex = 51
        frame4.Parent = frame3
        local textButton2 = Instance.new("TextButton")
        textButton2.Size = UDim2.new(1, 0, 1, 0)
        textButton2.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
        textButton2.BorderSizePixel = 0
        textButton2.Text = "Stop Farm"
        textButton2.Font = Enum.Font.GothamBold
        textButton2.TextSize = 13
        textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
        textButton2.AutoButtonColor = false
        textButton2.ZIndex = 52
        textButton2.Parent = frame4
        fn3(textButton2, 9)

        fn4 = function(arg)
                flag3 = arg

                if arg then
                        textButton2.Text = "Stop Farm"
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(220, 80, 80) }, 0.2)
                else
                        textButton2.Text = "Start Farm"
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(50, 200, 120) }, 0.2)
                end
        end

        textButton2.MouseButton1Click:Connect(function()
                fn4(not flag3)
        end)

        textButton2.MouseEnter:Connect(function()
                if flag3 then
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(200, 60, 60) }, 0.15)
                else
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(70, 220, 140) }, 0.15)
                end
        end)

        textButton2.MouseLeave:Connect(function()
                if flag3 then
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(220, 80, 80) }, 0.15)
                else
                        fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(50, 200, 120) }, 0.15)
                end
        end)
end

fn4(flag3)
local textButton2

do
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 34)
        frame4.Position = UDim2.new(0, 0, 0, 260)
        frame4.BackgroundTransparency = 1
        frame4.ZIndex = 51
        frame4.Parent = frame3
        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 10)
        uiListLayout.Parent = frame4
        textButton2 = Instance.new("TextButton")
        textButton2.Size = UDim2.new(0.33333333333333331, -5, 1, 0)
        textButton2.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        textButton2.BorderSizePixel = 0
        textButton2.Text = "Hop Server"
        textButton2.Font = Enum.Font.GothamBold
        textButton2.TextSize = 13
        textButton2.TextColor3 = Color3.fromRGB(220, 220, 225)
        textButton2.AutoButtonColor = false
        textButton2.LayoutOrder = 1
        textButton2.ZIndex = 52
        textButton2.Parent = frame4
        fn3(textButton2, 9)
        createUIStroke(textButton2, Color3.fromRGB(80, 80, 90), 1, 0.7)

        textButton2.MouseEnter:Connect(function()
                fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(35, 35, 45) }, 0.15)
        end)

        textButton2.MouseLeave:Connect(function()
                fn2(textButton2, { BackgroundColor3 = Color3.fromRGB(25, 25, 32) }, 0.15)
        end)

        local textButton3 = Instance.new("TextButton")
        textButton3.Size = UDim2.new(0.33333333333333331, -5, 1, 0)
        textButton3.BackgroundColor3 = Color3.fromRGB(220, 90, 100)
        textButton3.BorderSizePixel = 0
        textButton3.Text = "Render: Off"
        textButton3.Font = Enum.Font.GothamBold
        textButton3.TextSize = 11
        textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
        textButton3.AutoButtonColor = false
        textButton3.LayoutOrder = 2
        textButton3.ZIndex = 52
        textButton3.Parent = frame4
        fn3(textButton3, 9)
        local renderEnabled = getgenv().renderEnabled ~= nil and getgenv().renderEnabled or false

        local function fn5(renderEnabled2)
                renderEnabled = renderEnabled2
                getgenv().renderEnabled = renderEnabled2

                if renderEnabled2 then
                        textButton3.Text = "Render: On"
                        fn2(textButton3, { BackgroundColor3 = Color3.fromRGB(25, 25, 32) }, 0.18)

                        pcall(function()
                                RunService:Set3dRenderingEnabled(true)
                        end)
                else
                        textButton3.Text = "Render: Off"
                        fn2(textButton3, { BackgroundColor3 = Color3.fromRGB(220, 90, 100) }, 0.18)

                        pcall(function()
                                RunService:Set3dRenderingEnabled(false)
                        end)
                end
        end

        textButton3.MouseButton1Click:Connect(function()
                fn5(not renderEnabled)
        end)

        fn5(getgenv().renderEnabled ~= nil and getgenv().renderEnabled or false)

        local textButton4 = Instance.new("TextButton")
        textButton4.Size = UDim2.new(0.33333333333333331, -5, 1, 0)
        textButton4.BackgroundColor3 = Color3.fromRGB(220, 90, 100)
        textButton4.BorderSizePixel = 0
        textButton4.Text = "Auto Exec: Off"
        textButton4.Font = Enum.Font.GothamBold
        textButton4.TextSize = 11
        textButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
        textButton4.AutoButtonColor = false
        textButton4.LayoutOrder = 3
        textButton4.ZIndex = 52
        textButton4.Parent = frame4
        fn3(textButton4, 9)

        local autoExecEnabled = getgenv().autoExecEnabled ~= nil and getgenv().autoExecEnabled or false

        local function fn6(autoExecEnabled2)
            autoExecEnabled = autoExecEnabled2
            getgenv().autoExecEnabled = autoExecEnabled2

            if autoExecEnabled2 then
                textButton4.Text = "Auto Exec: On"
                fn2(textButton4, { BackgroundColor3 = Color3.fromRGB(70, 200, 130) }, 0.18)
            else
                textButton4.Text = "Auto Exec: Off"
                fn2(textButton4, { BackgroundColor3 = Color3.fromRGB(220, 90, 100) }, 0.18)
            end
        end

        textButton4.MouseButton1Click:Connect(function()
            fn6(not autoExecEnabled)
        end)

        fn6(getgenv().autoExecEnabled ~= nil and getgenv().autoExecEnabled or false)
end

local frame4 = Instance.new("Frame")
frame4.Size = UDim2.new(1, 0, 0, 1)
frame4.Position = UDim2.new(0, 0, 0, 300)
frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame4.BackgroundTransparency = 0.9
frame4.BorderSizePixel = 0
frame4.ZIndex = 51
frame4.Parent = frame3
local textLabel3 = Instance.new("TextLabel")
textLabel3.Size = UDim2.new(1, 0, 0, 18)
textLabel3.Position = UDim2.new(0, 0, 0, 306)
textLabel3.BackgroundTransparency = 1
textLabel3.Text = "Credit to  :  Tofa (tf3m)"
textLabel3.Font = Enum.Font.GothamMedium
textLabel3.TextSize = 10
textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel3.TextXAlignment = Enum.TextXAlignment.Center
textLabel3.TextScaled = false
textLabel3.ZIndex = 51
textLabel3.Parent = frame3
createUIGradient(textLabel3, Color3.fromRGB(255, 150, 210), Color3.fromRGB(190, 150, 255), 0)

for _, descendant in ipairs(frame2:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                descendant.TextTransparency = 1
        end
end

task.spawn(function()
        fn2(frame, { BackgroundTransparency = 0 }, 0.5)
        task.wait(0.05)
        fn2(imageLabel, { ImageTransparency = 0 }, 0.4)
        task.wait(0.15)
        fn2(textLabel, { TextTransparency = 0 }, 0.4)
        task.wait(0.6)
        task.wait(0.5)
        local v2 = fn2(frame, { BackgroundTransparency = 1 }, 0.4)
        fn2(imageLabel, { ImageTransparency = 1 }, 0.3)
        fn2(textLabel, { TextTransparency = 1 }, 0.3)
        v2.Completed:Wait()
        frame.Visible = false
        frame2.Visible = true
        frame2.BackgroundTransparency = 0
        frame2.Size = UDim2.new(0, 0, 0, 0)
        fn2(frame2, { Size = UDim2.new(0, 700, 0, 394) }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.45)
        local tbl4 = {}

        for _, descendant in ipairs(frame2:GetDescendants()) do
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        table.insert(tbl4, descendant)
                end
        end

        for i, v3 in ipairs(tbl4) do
                task.spawn(function()
                        task.wait((i - 1) * 0.015)
                        fn2(v3, { TextTransparency = 0 }, 0.35)
                end)
        end

        task.wait(0.6)
        frame:Destroy()
end)

do
        local uiScale = Instance.new("UIScale")
        uiScale.Parent = frame2
        local n3 = 0.62

        local function fn5()
                local currentCamera = workspace.CurrentCamera
                if not currentCamera then
                        return
                end
                local viewportSize = currentCamera.ViewportSize
                uiScale.Scale = math.min(viewportSize.X * n3 / n, viewportSize.Y * n3 / n2, 1)
        end

        fn5()

        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                fn5()

                if workspace.CurrentCamera then
                        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn5)
                end
        end)

        if workspace.CurrentCamera then
                workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn5)
        end
end

local function fn5()
        local CoreGui = game:GetService("CoreGui")
        local StarterGui = game:GetService("StarterGui")

        for _, v2 in ipairs({ "CaptureManager", "CaptureOverlay", "PlayerList" }) do
                pcall(function()
                        local v3 = CoreGui:FindFirstChild(v2)

                        if v3 then
                                v3:Destroy()
                        end
                end)
        end

        pcall(function()
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
        end)
end

task.spawn(function()
        fn5()

        while true do
                pcall(function()
                        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
                        local playerList = game:GetService("CoreGui"):FindFirstChild("PlayerList")

                        if playerList then
                                playerList:Destroy()
                        end
                end)

                task.wait(0.3)
        end
end)

fn5()

if not getgenv().TimeFarmed then
        getgenv().TimeFarmed = 0
end

local savedCarriedKills
savedCarriedKills = getgenv().SavedCarriedKills or 0
local savedEmotes
savedEmotes = getgenv().SavedEmotes or 0
local savedSessionStart
savedSessionStart = getgenv().SavedSessionStart or os.time()
local n3
n3 = 0
local n4
n4 = 0
local n5
n5 = 0
local n6
n6 = 0
local n7
n7 = 0
local flag4
flag4 = false
local cFrame
cFrame = nil
local v2
v2 = nil
local flag5
flag5 = false
local flag6
flag6 = false
local flag7
flag7 = false
local flag8, n8, TeleportService, Players, VirtualInputManager, localPlayer, currentCamera, fn6, fn7

do
        local flag9 = false
        flag8 = false
        n8 = 0
        TeleportService = game:GetService("TeleportService")
        Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        VirtualInputManager = game:GetService("VirtualInputManager")
        localPlayer = Players.LocalPlayer
        currentCamera = workspace.CurrentCamera
        local leaderstats

        if not localPlayer:FindFirstChild("leaderstats") or not localPlayer.leaderstats:FindFirstChild("Total Kills") then
                leaderstats = localPlayer
        else
                leaderstats = localPlayer.leaderstats
        end

        fn6 = function()
                local name = localPlayer and localPlayer.Name or "Unknown"
                local v3 = n3
                local v4 = savedEmotes
                local v5 = n6
                local v6 = n4
                local text = tbl3.timer and tbl3.timer.Text

                local tbl4 = {
                        embeds = {
                                {
                                        title = "Project Tofa Public Farm",
                                        color = 0,
                                        description = string.format([[**User:** ||%s||
**Kills farmed:** %s
**Emotes unlocked:** %s
**Total kills:** %s
**Kill / hr:** %s
**Time farmed:** %s]], name, tostring(v3), tostring(v4), tostring(v5), tostring(v6), text),
                                        timestamp = DateTime.now():ToIsoDate(),
                                },
                        },
                }

                local ok, result = pcall(function()
                        return request({
                                Url = v.webhookUrl,
                                Method = "POST",
                                Headers = { ["Content-Type"] = "application/json" },
                                Body = HttpService:JSONEncode(tbl4),
                        })
                end)

                if not ok then
                        warn("Webhook request failed: " .. tostring(result))
                end

                return ok, result
        end

        -- Sends a webhook notification when a staff member is detected and the
        -- force-hop system is about to teleport/kick the local player.
        -- `info` is a string describing the staff member (name, userid, reason).
        notifyStaffHop = function(info)
                if not v or not v.webhookUrl or v.webhookUrl == "" then return end
                local name = localPlayer and localPlayer.Name or "Unknown"
                local tbl4 = {
                        embeds = {
                                {
                                        title = "Project Tofa — Staff Detected, Hopping Servers",
                                        color = 16711680,  -- red
                                        description = string.format([[**User:** ||%s||
**Reason:** Staff member joined the server
**Staff info:** %s
**Action:** Teleporting to another server (kick as fallback)]], name, info or "Unknown"),
                                        timestamp = DateTime.now():ToIsoDate(),
                                },
                        },
                }
                pcall(function()
                        return request({
                                Url = v.webhookUrl,
                                Method = "POST",
                                Headers = { ["Content-Type"] = "application/json" },
                                Body = HttpService:JSONEncode(tbl4),
                        })
                end)
        end

        textButton.MouseButton1Click:Connect(fn6)
        workspace.FallenPartsDestroyHeight = (0/0)

        workspace:GetPropertyChangedSignal("FallenPartsDestroyHeight"):Connect(function()
                local fallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight

                if fallenPartsDestroyHeight == fallenPartsDestroyHeight then
                        workspace.FallenPartsDestroyHeight = (0/0)
                end
        end)

        local part = Instance.new("Part", workspace)
        part.CFrame = CFrame.new(0, -10008, 0)
        part.Anchored = true
        part.Size = Vector3.new(2048, 10, 2048)
        part.Transparency = 0.5
        part.CanCollide = true
        part.Name = game:GetService("HttpService"):GenerateGUID()
        local health = 100
        local connection = nil
        local connection2 = nil

        local function fn8(arg)
                if not arg then
                        return
                end
                local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 3)
                local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:WaitForChild("HumanoidRootPart", 3)
                if not humanoid or not humanoidRootPart then
                        return
                end
                health = humanoid.Health

                if connection then
                        connection:Disconnect()
                        connection = nil
                end

                if connection2 then
                        connection2:Disconnect()
                        connection2 = nil
                end

                connection2 = RunService.RenderStepped:Connect(function()
                        local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart2 then
                                health = humanoid.Health
                                part.CFrame = CFrame.new(humanoidRootPart2.Position.X, -10008, humanoidRootPart2.Position.Z)
                        end
                end)

                connection = humanoid.HealthChanged:Connect(function(health2)
                        local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")

                        if health2 <= 0 and humanoidRootPart2 and humanoidRootPart2.CFrame.Y <= 0 then
                                humanoid.Health = health
                        end
                end)
        end

        fn8(localPlayer.Character)

        localPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.1)
                fn8(character)
        end)

        local tbl4 = {}
        local obj = setmetatable({}, { __mode = "k" })

        local function createFolder(parent)
                if not parent then
                        return nil
                end
                local movingExclusion = parent:FindFirstChild("MovingExclusion")
                if movingExclusion then
                        return movingExclusion
                end
                local folder = Instance.new("Folder")
                folder.Name = "MovingExclusion"

                pcall(function()
                        folder:SetAttribute("ZKAYOwned", true)
                end)

                folder.Parent = parent
                obj[folder] = true
                return folder
        end

        local function fn9(arg)
                if not arg then
                        return
                end
                createFolder(arg)

                local connection3 = arg.ChildRemoved:Connect(function(child)
                        if child.Name == "MovingExclusion" then
                                task.defer(createFolder, arg)
                        end
                end)

                table.insert(tbl4, connection3)
        end

        fn9(localPlayer.Character)

        table.insert(tbl4, localPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.1)
                fn9(character)
        end))

        local flag10 = false
        local v3 = nil
        local v4 = nil
        local v5 = nil
        local tbl5 = {}
        local model = Instance.new("Model", workspace)
        local humanoid = Instance.new("Humanoid", model)
        local part2 = Instance.new("Part", model)
        part2.Name = "HumanoidRootPart"
        part2.CanCollide = false
        part2.Transparency = 1
        part2.Anchored = true
        part2.Size = Vector3.new(2, 2, 1)
        getgenv().InvisHumanoid = humanoid
        getgenv().InvisPart30 = part2
        local flag11 = false

        local function fn10()
                if not flag11 then
                        return
                end
                flag11 = false
                getgenv().InvisActive = false
                flag10 = false

                if v3 then
                        pcall(function()
                                if v3.IsPlaying then
                                        v3:Stop()
                                end
                        end)

                        v3 = nil
                end

                v4 = nil
                local character = localPlayer.Character

                if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart and v5 then
                                pcall(function()
                                        humanoidRootPart.CFrame = v5
                                end)
                        end

                        v5 = nil
                        local humanoid2 = character:FindFirstChildOfClass("Humanoid")

                        if humanoid2 then
                                pcall(function()
                                        workspace.CurrentCamera.CameraSubject = humanoid2
                                end)
                        end

                        pcall(function()
                                character:SetAttribute("NoHeadLerp", false)
                        end)

                        for _, v6 in pairs(tbl5) do
                                pcall(function()
                                        v6:Disconnect()
                                end)
                        end

                        tbl5 = {}

                        for _, descendant in pairs(character:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                                        descendant.LocalTransparencyModifier = 0
                                end
                        end
                end
        end

        local function fn11()
                if v3 then
                        pcall(function()
                                if v3.IsPlaying then
                                        v3:Stop()
                                end
                        end)

                        v3 = nil
                end

                v4 = nil
                v5 = nil
                flag10 = false
        end

        local function fn12(arg)
                if not arg:IsA("BasePart") then
                        return
                end

                if arg.Name == "HumanoidRootPart" then
                        return
                end

                if arg.Transparency == 1 then
                        return
                end

                if arg.Name:lower():find("hitbox") then
                        return
                end
                arg.LocalTransparencyModifier = 0.5

                local connection3 = arg:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
                        if not flag11 then
                                return
                        end

                        if arg.LocalTransparencyModifier ~= 0.5 then
                                arg.LocalTransparencyModifier = 0.5
                        end
                end)

                table.insert(tbl5, connection3)
        end

        local function fn13(arg)
                for _, descendant in pairs(arg:GetDescendants()) do
                        fn12(descendant)
                end

                local connection3 = arg.DescendantAdded:Connect(function(descendant)
                        if flag11 then
                                fn12(descendant)
                        end
                end)

                table.insert(tbl5, connection3)
        end

        local function fn14()
                if flag11 then
                        fn10()
                        return
                end
                local character = localPlayer.Character
                if not character then
                        return
                end
                local humanoid2 = character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoid2 or not humanoidRootPart then
                        return
                end
                flag11 = true
                getgenv().InvisActive = true
                flag10 = false
                local character2 = localPlayer.Character

                if character2 then
                        fn13(character2)
                end
        end

        RunService.Heartbeat:Connect(function()
                if not flag3 then
                        return
                end

                if flag6 or flag8 then
                        getgenv().desync = nil
                end

                local flag12 = getgenv().desync ~= nil
                if not flag11 and not flag12 then
                        return
                end

                if flag10 then
                        return
                end
                flag10 = true
                local character = localPlayer.Character
                local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not character or not humanoid2 or not humanoidRootPart then
                        flag10 = false
                        return
                end

                if humanoid2.Health <= 0 then
                        if flag11 then
                                task.spawn(fn11)
                        end

                        flag10 = false
                        return
                end

                local cFrame2 = humanoidRootPart.CFrame
                local velocity = humanoidRootPart.Velocity
                v5 = cFrame2
                local currentCamera2 = workspace.CurrentCamera
                local flag13 = flag12 and not localPlayer.Character:FindFirstChild("AbsoluteImmortal")
                local cFrame3 = nil

                if flag13 then
                        cFrame3 = getgenv().desync.CFrame
                        cFrame3 = cFrame3 or nil
                end

                if cFrame3 then
                        local flag14

                        if currentCamera2 then
                                flag14 = not (flag11 and not flag12)
                        else
                                flag14 = currentCamera2
                        end

                        if flag14 then
                                character:SetAttribute("NoHeadLerp", true)
                                currentCamera2.CameraSubject = humanoid
                        end

                        if flag4 and cFrame then
                                part2.CFrame = cFrame
                        else
                                part2.CFrame = cFrame2
                        end

                        humanoidRootPart.CFrame = cFrame3
                end

                local v6 = nil

                if flag11 then
                        if v4 ~= humanoid2 then
                                if v3 then
                                        pcall(function()
                                                if v3.IsPlaying then
                                                        v3:Stop()
                                                end

                                                v3:Destroy()
                                        end)

                                        v3 = nil
                                end

                                v4 = humanoid2
                        end

                        local animator = humanoid2:FindFirstChildOfClass("Animator")

                        if animator then
                                if not v3 or v3.Parent == nil then
                                        local animation = Instance.new("Animation")
                                        animation.AnimationId = "rbxassetid://71181015443030"
                                        v3 = animator:LoadAnimation(animation)
                                        v3.Priority = Enum.AnimationPriority.Action4
                                        v3:Play()
                                        v3:AdjustSpeed(0)
                                        v3:AdjustWeight(2e9)
                                end

                                v6 = v3
                                v6.TimePosition = 13.45
                        end
                end

                RunService.RenderStepped:Wait()
                humanoid.CameraOffset = humanoid2.CameraOffset

                if v6 and v6.IsPlaying then
                        pcall(function()
                                v6:Stop()
                        end)
                end

                if cFrame3 then
                        if flag4 and cFrame then
                                humanoidRootPart.CFrame = cFrame
                        else
                                local flag14 = currentCamera2 and UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter and not flag12

                                if flag14 then
                                        flag14 = not (flag11 and not flag12)
                                end

                                if flag14 then
                                        local lookVector = currentCamera2.CFrame.LookVector
                                        local vector = Vector3.new(lookVector.X, 0, lookVector.Z)

                                        if vector.Magnitude > 0.001 then
                                                humanoidRootPart.CFrame = CFrame.new(cFrame2.Position, cFrame2.Position + vector)
                                        else
                                                humanoidRootPart.CFrame = cFrame2
                                        end
                                else
                                        humanoidRootPart.CFrame = cFrame2
                                end
                        end
                end

                humanoidRootPart.Velocity = velocity
                flag10 = false
        end)

        fn14()

        task.spawn(function()
                local function fn15(arg)
                        while true do
                                task.wait()
                                if not (localPlayer.Character == arg and arg:FindFirstChild("HumanoidRootPart") and arg:FindFirstChildOfClass("Humanoid")) then
                                        continue
                                end
                                break
                        end

                        if localPlayer.Character ~= arg then
                                return
                        end
                        local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")

                        task.spawn(function()
                                while task.wait() and (not localPlayer.Character or localPlayer.Character == arg) do
                                        if getgenv().desync and not arg:FindFirstChild("AbsoluteImmortal") then
                                                local tbl6 = {}

                                                local ok, result = pcall(function()
                                                        return ReplicatedStorage.Resources.NinjaUlt.Afterimage_Despawn:Clone()
                                                end)

                                                local ok2, result2 = pcall(function()
                                                        return ReplicatedStorage.Resources.VanishingKick.tpthing:Clone()
                                                end)

                                                if ok and result then
                                                        result.Parent = humanoidRootPart
                                                        tbl6[1] = result

                                                        for _, child in pairs(result:GetChildren()) do
                                                                if child:IsA("ParticleEmitter") then
                                                                        child.Enabled = true
                                                                        child.Rate = 100
                                                                end
                                                        end
                                                end

                                                if ok2 and result2 then
                                                        result2.Parent = humanoidRootPart
                                                        tbl6[2] = result2
                                                        result2.Enabled = true
                                                        result2.Rate = 100
                                                end

                                                while true do
                                                        if tbl6[1] and tbl6[1].Parent then
                                                                tbl6[1].CFrame = humanoidRootPart.CFrame
                                                        end

                                                        RunService.RenderStepped:Wait()
                                                        if not (not getgenv().desync or arg:FindFirstChild("AbsoluteImmortal")) then
                                                                continue
                                                        end
                                                        break
                                                end

                                                for _, v6 in pairs(tbl6) do
                                                        pcall(function()
                                                                v6:Destroy()
                                                        end)
                                                end
                                        end
                                end
                        end)

                        task.spawn(function()
                                for _, descendant in pairs(arg:GetDescendants()) do
                                        if descendant:IsA("BasePart") and descendant ~= humanoidRootPart and descendant.Transparency ~= 1 and not descendant.Name:lower():find("hitbox") then
                                                task.spawn(function()
                                                        while task.wait() and (not localPlayer.Character or localPlayer.Character == arg) do
                                                                if descendant and (flag11 or getgenv().desync and not arg:FindFirstChild("AbsoluteImmortal")) then
                                                                        descendant.Transparency = 0.5

                                                                        while true do
                                                                                RunService.RenderStepped:Wait()
                                                                                local flag12 = not flag11
                                                                                local absoluteImmortal

                                                                                if flag12 then
                                                                                        absoluteImmortal = not getgenv().desync or arg:FindFirstChild("AbsoluteImmortal")
                                                                                else
                                                                                        absoluteImmortal = flag12
                                                                                end

                                                                                absoluteImmortal = absoluteImmortal or localPlayer.Character and localPlayer.Character ~= arg
                                                                                if not absoluteImmortal then
                                                                                        continue
                                                                                end
                                                                                break
                                                                        end

                                                                        descendant.Transparency = 0
                                                                end
                                                        end
                                                end)
                                        end
                                end
                        end)
                end

                if localPlayer.Character then
                        task.spawn(fn15, localPlayer.Character)
                end

                localPlayer.CharacterAdded:Connect(function(character)
                        task.spawn(fn15, character)
                end)
        end)

        local Lighting = game:GetService("Lighting")
        local Workspace_ = game:GetService("Workspace")
        local terrain = Workspace:FindFirstChildOfClass("Terrain")

        local function fn15(arg, arg2)
                pcall(function()
                        arg:Connect(arg2)
                end)
        end

        local tbl6 = {
                function()
                        local color = Color3.fromRGB(0, 85, 190)

                        local function fn16(arg)
                                if arg:IsA("Trail") then
                                        arg.Color = ColorSequence.new(color)
                                        arg.Texture = ""
                                        arg.LightEmission = 0.8
                                elseif arg:IsA("ParticleEmitter") then
                                        arg.Color = ColorSequence.new(color)
                                        arg.LightEmission = 0.75
                                end
                        end

                        local function fn17(arg)
                                for _, descendant in ipairs(arg:GetDescendants()) do
                                        if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                                                fn16(descendant)
                                        end
                                end

                                fn15(arg.DescendantAdded, function(arg2)
                                        if arg2:IsA("Trail") or arg2:IsA("ParticleEmitter") then
                                                fn16(arg2)
                                        end
                                end)
                        end

                        if localPlayer.Character then
                                fn17(localPlayer.Character)
                        end

                        fn15(localPlayer.CharacterAdded, fn17)
                end,
                function()
                        local tbl6 = {
                                Bk = 92959017845968,
                                Ft = 129304841254693,
                                Lf = 129249062260004,
                                Rt = 117319232583147,
                                Up = 121193772599100,
                                Dn = 115022734343595,
                        }

                        for _, child in ipairs(Lighting:GetChildren()) do
                                if child:IsA("Sky") then
                                        child:Destroy()
                                end
                        end

                        local sky = Instance.new("Sky")

                        for k, v6 in pairs(tbl6) do
                                sky["Skybox" .. k] = "rbxassetid://" .. v6
                        end

                        sky.Parent = Lighting
                end,
                function()
                        Lighting.ClockTime = 12
                        Lighting.GlobalShadows = false
                        Lighting.Brightness = 0.8
                        Lighting.ExposureCompensation = -0.2
                        local v6 = Lighting
                        Lighting.FogStart = 9e9
                        v6.FogEnd = 9e9

                        for _, child in ipairs(Lighting:GetChildren()) do
                                if child:IsA("PostEffect") or child:IsA("SunRaysEffect") then
                                        child.Enabled = false
                                end
                        end
                end,
                function()
                        fn15(Workspace_.DescendantAdded, function(arg)
                                if arg:IsA("Smoke") then
                                        arg:Destroy()
                                elseif arg:IsA("ParticleEmitter") then
                                        local model2 = arg:FindFirstAncestorOfClass("Model")

                                        if not (model2 and model2:FindFirstChild("Class") and model2.Class.Value == "Hero Hunter") then
                                                arg:Destroy()
                                        end
                                end
                        end)
                end,
                function()
                        if not terrain then
                                return
                        end

                        for _, child in ipairs(terrain:GetChildren()) do
                                if child:IsA("Clouds") then
                                        child.Enabled = false
                                end
                        end

                        fn15(terrain.ChildAdded, function(arg)
                                if arg:IsA("Clouds") then
                                        arg.Enabled = false
                                end
                        end)
                end,
                function()
                        local function fn16()
                                local sky = Lighting:FindFirstChildOfClass("Sky")

                                if sky then
                                        sky.SunAngularSize = 0
                                        sky.SunTextureId = ""
                                        sky.MoonAngularSize = 0
                                        sky.MoonTextureId = ""
                                end
                        end

                        fn16()
                        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

                        if atmosphere then
                                atmosphere.Density = 0
                                atmosphere.Haze = 0
                                atmosphere.Glare = 0
                        end

                        fn15(Lighting.ChildAdded, function(arg)
                                if arg:IsA("Sky") then
                                        task.wait()
                                        fn16()
                                elseif arg:IsA("Atmosphere") then
                                        arg.Density = 0
                                        arg.Haze = 0
                                        arg.Glare = 0
                                end
                        end)
                end,
        }

        task.spawn(function()
                local tbl7 = { 1, 2, 3, 4, 5, 6 }

                while #tbl7 > 0 do
                        local n9 = math.random(#tbl7)
                        pcall(tbl6[tbl7[n9]])
                        table.remove(tbl7, n9)
                end
        end)

        pcall(function()
                local level01 = Enum.QualityLevel.Level01
                v().Rendering.QualityLevel = level01
        end)

        local flag12 = false

        local function fn16(arg)
                if typeof(arg) == "Instance" then
                        if arg:IsA("Player") then
                                return arg.Character
                        end

                        if arg:IsA("Model") then
                                return arg
                        end
                end

                return nil
        end

        local function fn17(arg)
                return arg and arg:FindFirstChild("HumanoidRootPart") or nil
        end

        local function fn18(arg)
                return arg and arg:FindFirstChildOfClass("Humanoid") or nil
        end

        local function fn19()
                local players = Players:GetPlayers()
                local v6 = table.find(players, localPlayer)

                if v6 then
                        table.remove(players, v6)
                end

                return players
        end

        local function fn20(arg, arg2)
                if not arg then
                        return false
                end

                for _, v6 in pairs(arg:GetPlayingAnimationTracks()) do
                        if v6.Animation.AnimationId:match(arg2) then
                                return true
                        end
                end

                return false
        end

        fn7 = function()
                local huge = math.huge
                local v6 = nil

                for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= localPlayer then
                                if player ~= v2 then
                                        local character = player.Character

                                        if character then
                                                if character:FindFirstChild("HumanoidRootPart") then
                                                        local humanoid2 = character:FindFirstChildOfClass("Humanoid")

                                                        if humanoid2 then
                                                                if humanoid2.Health then
                                                                        local torso = character:FindFirstChild("Torso")

                                                                        if not (not torso or torso.Transparency == 1) then
                                                                                if not fn20(humanoid2, "15128849047") then
                                                                                        if not character:FindFirstChildWhichIsA("ForceField") then
                                                                                                if not (character:GetAttribute("Ulted") and (character:GetAttribute("Character") == "Batter" or character:GetAttribute("Character") == "Bald") or character:FindFirstChild("Counter")) then
                                                                                                        local position = character.HumanoidRootPart.Position

                                                                                                        if position.X >= -500 and position.X <= 800 and position.Z >= -600 and position.Z <= 700 then
                                                                                                                local health2 = humanoid2.Health

                                                                                                                if health2 > 0 and health2 < huge then
                                                                                                                        huge = health2
                                                                                                                        v6 = player
                                                                                                                end
                                                                                                        end
                                                                                                end
                                                                                        end
                                                                                end
                                                                        end
                                                                end
                                                        end
                                                end
                                        end
                                end
                        end
                end

                return v6
        end

        local function fn21(arg)
                local humanoid2 = arg:WaitForChild("Humanoid")

                arg.DescendantAdded:Connect(function(descendant)
                        if descendant.Name == "Ragdoll" or descendant.Name == "RagdollSim" then
                                if not flag12 and humanoid2.Health > 0 and not arg:FindFirstChild("ExtraHitbox") then
                                        task.spawn(function()
                                                while true do
                                                        flag12 = true
                                                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                        task.wait()
                                                        if not (descendant.Parent ~= arg or humanoid2.Health <= 0) then
                                                                continue
                                                        end
                                                        break
                                                end

                                                flag12 = false
                                                getgenv().desync = nil
                                        end)
                                end
                        end
                end)

                task.spawn(function()
                        local playerGui = localPlayer:WaitForChild("PlayerGui")
                        if not playerGui then
                                return
                        end
                        local hotbar = playerGui:WaitForChild("Hotbar")
                        if not hotbar then
                                return
                        end
                        local backpack = hotbar:WaitForChild("Backpack")
                        if not backpack then
                                return
                        end
                        local hotbar2 = backpack:WaitForChild("Hotbar")
                        if not hotbar2 then
                                return
                        end
                        local n22 = hotbar2:WaitForChild("2")
                        if not n22 then
                                return
                        end
                        local base = n22:WaitForChild("Base")
                        if not base then
                                return
                        end

                        base.ChildAdded:Connect(function(child)
                                if child.Name == "Cooldown" and localPlayer.Character:GetAttribute("Ulted") then
                                        task.spawn(function()
                                                flag9 = true
                                                task.wait(0.05)
                                                flag9 = false
                                        end)
                                end
                        end)
                end)

                local tbl7 = { ["18464351556"] = true, ["18464372850"] = true, ["136370737633649"] = true }

                humanoid2.AnimationPlayed:Connect(function(arg2)
                        local animationId = arg2.Animation.AnimationId
                        if tbl7[animationId:match("%d+")] then
                                v2 = fn7()
                                return
                        end

                        local function fn22(arg3)
                                if not arg3 or not arg3:IsA("Player") then
                                        return false
                                end
                                local attribute = fn16(arg3)
                                attribute = attribute and attribute:GetAttribute("Character")
                                if type(attribute) ~= "string" then
                                        return false
                                end
                                local str = attribute:lower()
                                return str == "hunter" or str == "blade" or str:find("zombie", 1, true) ~= nil
                        end

                        local function fn23(arg3)
                                local v6 = nil

                                return (RunService.Heartbeat:Connect(function()
                                        if not arg3() then
                                                v6:Disconnect()
                                                return
                                        end
                                        local v7 = fn17(fn16(localPlayer))

                                        if v7 then
                                                v7.AssemblyLinearVelocity = Vector3.new()
                                                v7.AssemblyAngularVelocity = Vector3.new()
                                        end
                                end))
                        end

                        local connection3 = nil
                        local connection4 = nil
                        local v6 = nil
                        local v7 = nil
                        local flag13 = false

                        local function fn24()
                                if connection3 then
                                        connection3:Disconnect()
                                        connection3 = nil
                                end

                                if connection4 then
                                        connection4:Disconnect()
                                        connection4 = nil
                                end

                                if sethiddenproperty then
                                        if v6 and v6.Parent then
                                                pcall(function()
                                                        sethiddenproperty(v6, "PhysicsRepRootPart", nil)
                                                end)
                                        end

                                        if v7 and v7.Parent then
                                                pcall(function()
                                                        sethiddenproperty(v7, "PhysicsRepRootPart", nil)
                                                end)
                                        end
                                end

                                if v6 and v6.Parent then
                                        v6.CFrame = CFrame.new(v6.Position)
                                        v6.AssemblyLinearVelocity = Vector3.zero
                                        v6.AssemblyAngularVelocity = Vector3.zero

                                        pcall(function()
                                                v6.Velocity = Vector3.zero
                                        end)

                                        pcall(function()
                                                v6.RotVelocity = Vector3.zero
                                        end)

                                        local humanoid3 = v6.Parent:FindFirstChildOfClass("Humanoid")

                                        if humanoid3 then
                                                pcall(function()
                                                        humanoid3.AutoRotate = true
                                                end)
                                        end
                                end

                                v6 = nil
                                v7 = nil
                        end

                        local function fn25()
                                fn24()
                        end

                        local function fn26(arg3, arg4)
                                if flag13 then
                                        return
                                end

                                if connection3 then
                                        connection3:Disconnect()
                                        connection3 = nil
                                end

                                if v6 and v6.Parent then
                                        v6.AssemblyLinearVelocity = Vector3.zero
                                        v6.AssemblyAngularVelocity = Vector3.zero

                                        pcall(function()
                                                v6.Velocity = Vector3.zero
                                        end)

                                        pcall(function()
                                                v6.RotVelocity = Vector3.zero
                                        end)
                                end

                                if not arg3 or not arg4 then
                                        return
                                end
                                v6 = arg3
                                v7 = arg4

                                if connection4 then
                                        connection4:Disconnect()
                                        connection4 = nil
                                end

                                local humanoid3 = arg3.Parent and arg3.Parent:FindFirstChildOfClass("Humanoid")

                                if humanoid3 then
                                        connection4 = RunService.RenderStepped:Connect(function()
                                                if humanoid3 and humanoid3.Parent then
                                                        pcall(function()
                                                                humanoid3.AutoRotate = false
                                                        end)
                                                end
                                        end)
                                end

                                arg3.CFrame = CFrame.new(0, 0, 5)
                                arg3.AssemblyLinearVelocity = Vector3.zero
                                arg3.AssemblyAngularVelocity = Vector3.zero

                                if sethiddenproperty then
                                        pcall(function()
                                                sethiddenproperty(arg3, "PhysicsRepRootPart", arg3)
                                        end)

                                        pcall(function()
                                                sethiddenproperty(arg3, "PhysicsRepRootPart", arg4)
                                        end)
                                end

                                local v8 = nil

                                connection3 = RunService.Heartbeat:Connect(function()
                                        if not arg3 or not arg3.Parent or not arg4 or not arg4.Parent then
                                                v8:Disconnect()

                                                if connection3 == v8 then
                                                        connection3 = nil
                                                end

                                                if sethiddenproperty then
                                                        if arg3 and arg3.Parent then
                                                                pcall(function()
                                                                        sethiddenproperty(arg3, "PhysicsRepRootPart", nil)
                                                                end)
                                                        end

                                                        if arg4 and arg4.Parent then
                                                                pcall(function()
                                                                        sethiddenproperty(arg4, "PhysicsRepRootPart", nil)
                                                                end)
                                                        end
                                                end

                                                if arg3 and arg3.Parent then
                                                        arg3.AssemblyLinearVelocity = Vector3.zero
                                                        arg3.AssemblyAngularVelocity = Vector3.zero

                                                        pcall(function()
                                                                arg3.Velocity = Vector3.zero
                                                        end)

                                                        pcall(function()
                                                                arg3.RotVelocity = Vector3.zero
                                                        end)
                                                end

                                                return
                                        end

                                        arg3.CFrame = CFrame.new(0, 0, 5)
                                        arg3.AssemblyLinearVelocity = Vector3.zero
                                        arg3.AssemblyAngularVelocity = Vector3.zero

                                        if sethiddenproperty then
                                                pcall(function()
                                                        sethiddenproperty(arg3, "PhysicsRepRootPart", arg4)
                                                end)
                                        end
                                end)
                        end

                        if animationId:match("18896229321") then
                                task.wait(0.01)
                                if not flag9 then
                                        return
                                end
                                flag13 = false
                                getgenv().desync = nil
                                flag8 = true

                                task.spawn(function()
                                        local v8 = fn16(localPlayer)
                                        if not v8 then
                                                return
                                        end

                                        if v8:GetAttribute("Character") ~= "Purple" then
                                                return
                                        end
                                        local n9 = tick() + 3
                                        local flag14 = true
                                        local now = tick()
                                        local n10 = 70
                                        local n11 = 30

                                        local function fn27(arg3)
                                                return arg3:match("%d+")
                                        end

                                        local function fn28()
                                                for _, v9 in ipairs(localPlayer.Character.Humanoid.Animator:GetPlayingAnimationTracks()) do
                                                        if fn27(v9.Animation.AnimationId) == "18896229321" then
                                                                return v9
                                                        end
                                                end

                                                return nil
                                        end

                                        local v9 = fn28()

                                        while not v9 do
                                                task.wait()
                                                v9 = fn28()
                                        end

                                        task.spawn(function()
                                                while true do
                                                        task.wait()
                                                        v9 = fn28()
                                                        local flag15 = not v9 or v9.TimePosition >= n10 / n11

                                                        if not flag15 then
                                                                local n12 = now + 2.2
                                                                flag15 = tick() >= n12
                                                        end

                                                        if not flag15 then
                                                                continue
                                                        end
                                                        break
                                                end

                                                flag13 = true
                                                if not fn16(localPlayer) then
                                                        return
                                                end

                                                pcall(function()
                                                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(150, 441, 32)
                                                end)

                                                pcall(function()
                                                        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(150, -10000, 32)
                                                end)

                                                task.wait(1.5)
                                                flag8 = false
                                        end)

                                        fn23(function()
                                                return flag14
                                        end)

                                        local tbl8 = {}
                                        local v10 = nil
                                        local now2 = tick()
                                        local v11 = fn16(localPlayer)

                                        if v11 and fn17(v11) then
                                        end

                                        local function fn29(arg3)
                                                if not arg3 then
                                                        return nil
                                                end

                                                if arg3:IsA("Player") then
                                                        return fn16(arg3)
                                                end
                                                return nil
                                        end

                                        local function fn30(arg3)
                                                return fn18(fn29(arg3))
                                        end

                                        local function fn31(arg3)
                                                return fn17(fn29(arg3))
                                        end

                                        local function fn32(arg3)
                                                if not arg3 then
                                                        return false
                                                end

                                                if arg3:FindFirstChild("ForceField") then
                                                        return true
                                                end

                                                if arg3:FindFirstChild("AbsoluteImmortal") then
                                                        return true
                                                end

                                                if arg3:FindFirstChild("BeingGrabbed") then
                                                        return true
                                                end

                                                if arg3:FindFirstChild("HunterCounter") then
                                                        return true
                                                end

                                                if arg3:FindFirstChild("AtomicCounter") then
                                                        return true
                                                end

                                                if arg3:FindFirstChild("forcefield") then
                                                        return true
                                                end
                                                return false
                                        end

                                        local function fn33(arg3)
                                                local v12 = fn29(arg3)
                                                local v13 = v12 and fn18(v12)
                                                local v14 = v12 and fn17(v12)
                                                if not v12 or not v13 or not v14 then
                                                        return true
                                                end

                                                if v13.Health <= 0 then
                                                        return true
                                                end

                                                if arg3:IsA("Player") then
                                                        if fn32(v12) then
                                                                return true
                                                        end

                                                        if v12:FindFirstChild("Counter") then
                                                                return true
                                                        end

                                                        if fn20(v13, "15128849047") then
                                                                return true
                                                        end

                                                        if v12:GetAttribute("Ulted") and v12:GetAttribute("Character") == "Batter" then
                                                                return true
                                                        end
                                                end

                                                local position = v12.HumanoidRootPart.Position
                                                if not (position.X >= -500 and position.X <= 800 and position.Z >= -600 and position.Z <= 700) then
                                                        return true
                                                end
                                                return false
                                        end

                                        local function fn34(arg3)
                                                local v12 = fn30(arg3)
                                                local v13

                                                if v12 then
                                                        v13 = fn20(v12, "18896222853") or fn20(v12, "137434257516014")
                                                else
                                                        v13 = v12
                                                end

                                                return v13
                                        end

                                        local function fn35(arg3)
                                                if not arg3 or not arg3:IsA("Player") then
                                                        return false
                                                end
                                                local v12 = fn16(arg3)
                                                local v13 = v12 and fn18(v12)
                                                if not v12 or not v13 then
                                                        return false
                                                end

                                                if v13.Health <= 0 then
                                                        return false
                                                end

                                                if fn20(v13, "15128849047") then
                                                        return false
                                                end
                                                return fn32(v12)
                                        end

                                        local function fn36()
                                                local weakestDummy = workspace.Live:FindFirstChild("Weakest Dummy")
                                                if not weakestDummy then
                                                        return nil
                                                end
                                                local v12 = fn18(weakestDummy)
                                                if not v12 or v12.Health <= 0 then
                                                        return nil
                                                end
                                                return weakestDummy
                                        end

                                        local function fn37(arg3)
                                                local tbl9 = {}
                                                local tbl10 = {}

                                                for _, v12 in pairs(fn19()) do
                                                        if not (v12 == arg3 or tbl8[v12]) then
                                                                local v13 = fn31(v12)

                                                                if not fn33(v12) and not fn34(v12) and v13 then
                                                                        if fn22(v12) then
                                                                                table.insert(tbl9, v12)
                                                                        else
                                                                                table.insert(tbl10, v12)
                                                                        end
                                                                end
                                                        end
                                                end

                                                if #tbl9 > 0 then
                                                        return tbl9[math.random(1, #tbl9)]
                                                end

                                                if #tbl10 > 0 then
                                                        return tbl10[math.random(1, #tbl10)]
                                                end
                                                local v12 = fn36()
                                                if v12 and v12 ~= arg3 and not tbl8[v12] then
                                                        return v12
                                                end
                                                return nil
                                        end

                                        local function fn38()
                                                local v12 = fn16(localPlayer)
                                                local v13 = v12 and fn18(v12)

                                                if v13 then
                                                        pcall(function()
                                                                v13.AutoRotate = true
                                                        end)
                                                end
                                        end

                                        local function fn39()
                                                for _, v12 in pairs(fn19()) do
                                                        if tbl8[v12] then
                                                                continue
                                                        end

                                                        if fn35(v12) then
                                                                return true
                                                        end
                                                end

                                                return false
                                        end

                                        local flag15 = false

                                        local function fn40()
                                                if flag15 then
                                                        return
                                                end
                                                flag15 = true
                                                fn24()
                                                fn38()

                                                if _ffWatchConn then
                                                        pcall(function()
                                                                _ffWatchConn:Disconnect()
                                                        end)
                                                end

                                                if _dummyRespawnConn then
                                                        pcall(function()
                                                                _dummyRespawnConn:Disconnect()
                                                        end)
                                                end

                                                if _currentTargetAnimConn then
                                                        pcall(function()
                                                                _currentTargetAnimConn:Disconnect()
                                                        end)

                                                        _currentTargetAnimConn = nil
                                                end

                                                flag14 = false
                                                fn25()
                                        end

                                        local connection5 = nil
                                        local fn41 = nil

                                        fn41 = function(arg3)
                                                if connection5 then
                                                        pcall(function()
                                                                connection5:Disconnect()
                                                        end)

                                                        connection5 = nil
                                                end

                                                fn24()
                                                v10 = arg3
                                                now2 = tick()

                                                if arg3 then
                                                        local v12 = fn16(localPlayer)
                                                        v12 = v12 and fn17(v12)
                                                        local v13 = fn31(arg3)

                                                        if v12 and v13 then
                                                                fn26(v12, v13)
                                                                local v14 = fn30(arg3)

                                                                if v14 then
                                                                        local animator = v14:FindFirstChildOfClass("Animator")

                                                                        connection5 = (animator and animator.AnimationPlayed or v14.AnimationPlayed):Connect(function(arg4)
                                                                                local animationId2 = arg4.Animation.AnimationId

                                                                                if animationId2:match("18896222853") or animationId2:match("137434257516014") then
                                                                                        if not flag14 then
                                                                                                return
                                                                                        end
                                                                                        local v15 = v10
                                                                                        if not v15 then
                                                                                                return
                                                                                        end
                                                                                        tbl8[v15] = true
                                                                                        fn24()
                                                                                        local v16 = fn37(v15)

                                                                                        if v16 then
                                                                                                fn41(v16)

                                                                                                if fn37(v16) == nil and not fn39() then
                                                                                                        task.wait(0.1)
                                                                                                        tbl8[v16] = true
                                                                                                        _everybodyDone = true
                                                                                                        fn40()
                                                                                                end
                                                                                        elseif fn39() then
                                                                                                fn24()
                                                                                                v10 = nil
                                                                                        else
                                                                                                _everybodyDone = true
                                                                                                fn40()
                                                                                        end
                                                                                end
                                                                        end)
                                                                end
                                                        end
                                                end
                                        end

                                        workspace.Live.ChildAdded:Connect(function(child)
                                                if child.Name == "Weakest Dummy" then
                                                        tbl8[child] = nil
                                                end
                                        end)

                                        RunService.RenderStepped:Connect(function()
                                                for _, v12 in pairs(fn19()) do
                                                        if tbl8[v12] then
                                                                local v13 = fn16(v12)
                                                                local v14 = v13 and fn18(v13)

                                                                if v13 and v14 and v14.Health > 0 and not fn32(v13) then
                                                                        tbl8[v12] = nil

                                                                        if not v10 then
                                                                                fn41(v12)
                                                                        end
                                                                end
                                                        end
                                                end
                                        end)

                                        local v12 = fn37(nil)

                                        if v12 then
                                                fn41(v12)

                                                if fn37(v12) == nil then
                                                        task.wait(0.1)
                                                        tbl8[v12] = true
                                                        fn40()
                                                        return
                                                end
                                        end

                                        while true do
                                                if arg2.IsPlaying and tick() < n9 then
                                                        if flag13 then
                                                                fn40()
                                                                break
                                                        else
                                                                RunService.Heartbeat:Wait()
                                                                local now3 = tick()
                                                                local flag16

                                                                if not v10 then
                                                                        flag16 = true
                                                                elseif fn33(v10) then
                                                                        if not fn35(v10) then
                                                                                tbl8[v10] = true
                                                                        end

                                                                        flag16 = true
                                                                else
                                                                        flag16 = false

                                                                        if now3 - now2 >= 0.8 then
                                                                                tbl8[v10] = true
                                                                                flag16 = true
                                                                        end
                                                                end

                                                                if flag16 then
                                                                        local v13 = fn37(v10)

                                                                        if not v13 then
                                                                                if fn39() then
                                                                                        fn24()
                                                                                        v10 = nil
                                                                                        continue
                                                                                else
                                                                                        fn40()
                                                                                        break
                                                                                end
                                                                        else
                                                                                fn41(v13)

                                                                                if fn37(v13) == nil and not fn39() then
                                                                                        task.wait(0.1)
                                                                                        tbl8[v13] = true
                                                                                        fn40()
                                                                                        break
                                                                                else
                                                                                        continue
                                                                                end
                                                                        end
                                                                else
                                                                        continue
                                                                end
                                                        end
                                                end

                                                break
                                        end

                                        fn40()
                                end)
                        end
                end)
        end

        task.spawn(function()
                local totalKills = leaderstats:WaitForChild("Total Kills")
                local attribute = localPlayer:GetAttribute("LastEmoteSpin")
                local value = totalKills.Value
                n5 = totalKills.Value - savedCarriedKills

                while true do
                        task.wait(0.25)
                        n6 = totalKills.Value
                        n3 = n6 - n5
                        n7 = n6 - value
                        local attribute2 = localPlayer:GetAttribute("LastEmoteSpin")

                        if attribute2 ~= attribute then
                                savedEmotes += 1
                                attribute = attribute2
                        end

                        n4 = math.floor(n3 / math.max(os.time() - savedSessionStart, 1) / 3600)
                        tbl3.kills.Text = tostring(n3)
                        tbl3.kph.Text = tostring(n4)
                        tbl3.emotes.Text = tostring(savedEmotes)
                        tbl3.total.Text = tostring(n6)
                end
        end)

        task.spawn(function()
                while true do
                        if flag3 then
                                local genv = getgenv()
                                genv.TimeFarmed = genv.TimeFarmed + 1
                        end

                        local timeFarmed = getgenv().TimeFarmed
                        tbl3.timer.Text = string.format("%02d:%02d:%02d", math.floor(timeFarmed / 3600), math.floor(timeFarmed % 3600 / 60), timeFarmed % 60)
                        task.wait(1)
                end
        end)

        localPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.5)
                fn21(character)

                character:GetAttributeChangedSignal("Ulted"):Connect(function()
                        if localPlayer.Character:GetAttribute("Ulted") then
                                n8 += 1
                                print("[Project Tofa] Ulted detected, time ulted: " .. tostring(n8))
                        end
                end)
        end)

        if localPlayer.Character then
                fn21(localPlayer.Character)

                localPlayer.Character:GetAttributeChangedSignal("Ulted"):Connect(function()
                        if localPlayer.Character:GetAttribute("Ulted") then
                                n8 += 1
                                print("[Project Tofa] Ulted detected, time ulted: " .. tostring(n8))
                        end
                end)
        end
end

do
        local tbl4 = {
                {
                        QueryV2 = true,
                        Page = 1,
                        Filters = {
                                Countries = { [v.country] = true },
                                Tags = {},
                                HideFull = true,
                                HideTagged = false,
                                FriendsOnly = false,
                                HidePassword = false,
                        },
                        limit = 60,
                        Category = "Server List",
                        Region = v.country,
                        Sort = { Keys = { { By = "kills", Dir = "low" } } },
                        Search = "",
                        notFull = false,
                },
        }

        local function fn8()
                local autoExecScript = ""
                if getgenv().autoExecEnabled then
                        autoExecScript = [[task.wait(5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/kaasbolletje10-lab/project-tofa/refs/heads/main/project%20tofatuff.lua"))()]]
                end
                local str = string.format([[getgenv().TimeFarmed=%d
getgenv().SavedCarriedKills=%d
getgenv().SavedEmotes=%d
getgenv().SavedSessionStart=%d
getgenv().renderEnabled=%s
getgenv().autoExecEnabled=%s
%s
]], getgenv().TimeFarmed, n3, savedEmotes, savedSessionStart, tostring(getgenv().renderEnabled or false), tostring(getgenv().autoExecEnabled or false), autoExecScript)

                pcall(queue_on_teleport, str)
        end

        local function fn9(arg)
                local tbl5 = {}

                for _, server in ipairs(arg.servers) do
                        local players = server.players

                        if players and players >= 10 and players <= 13 and server.id ~= game.JobId then
                                table.insert(tbl5, server)
                        end
                end

                if #tbl5 == 0 then
                        return nil
                end
                return tbl5[math.random(1, #tbl5)]
        end

        local flag9 = false
        local flag10 = false
        local flag11 = false
        local staffHopInfo = nil  -- description of the staff member that triggered force-hop

        doHopServer = function()
                local flag12 = not flag11 and not flag10

                if flag12 then
                        flag12 = not (doServerHop and flag3)
                end

                if flag12 then
                        return
                end

                if flag9 then
                        return
                end
                flag9 = true

                while true do
                        task.wait()
                        if not (not flag6 and not flag8) then
                                continue
                        end
                        break
                end

                fn8()
                local response = game:GetService("ReplicatedStorage"):WaitForChild("Ranked"):WaitForChild("GetServerBrowserData"):InvokeServer(unpack(tbl4))
                task.wait(2)
                flag = false

                if getgenv().PBF_WS then
                        pcall(function()
                                getgenv().PBF_WS:Close()
                        end)

                        getgenv().PBF_WS = nil
                end

                if flag11 then
                        -- Staff detected: send webhook, then keep trying to TELEPORT to another server.
                        -- NO KICK — just keep retrying teleport forever until it works.
                        pcall(notifyStaffHop, staffHopInfo)

                        -- Keep trying to teleport until we leave the server
                        task.spawn(function()
                                while true do
                                        local v3OK, v3 = pcall(fn9, response)
                                        if v3OK and v3 then
                                                if stafforcehop then
                                                        pcall(function()
                                                                TeleportService:TeleportToPlaceInstance(game.PlaceId, v3.id, localPlayer)
                                                        end)
                                                else
                                                        pcall(function()
                                                                game:GetService("ReplicatedStorage"):WaitForChild("Ranked"):WaitForChild("CustomServerHandler"):InvokeServer({
                                                                        Action = "JoinServer",
                                                                        JobId = v3.id,
                                                                        ServerCode = v3.serverCode or "",
                                                                        JoinCode = v3.joinCode or "",
                                                                        Password = nil,
                                                                })
                                                        end)
                                                end
                                        end
                                        -- Wait 3 seconds between attempts (also gives teleport time to work)
                                        task.wait(3)
                                end
                        end)
                        return  -- Don't run the infinite hop loop below — staff case is handled
                end

                task.spawn(function()
                        while true do
                                print("[Project Tofa] Hopping ...")

                                if not flag11 then
                                        response = game:GetService("ReplicatedStorage"):WaitForChild("Ranked"):WaitForChild("GetServerBrowserData"):InvokeServer(unpack(tbl4))
                                end

                                local v3 = fn9(response)

                                if v3 then
                                        if stafforcehop then
                                                pcall(function()
                                                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v3.id, localPlayer)
                                                end)
                                        else
                                                pcall(function()
                                                        game:GetService("ReplicatedStorage"):WaitForChild("Ranked"):WaitForChild("CustomServerHandler"):InvokeServer({
                                                                Action = "JoinServer",
                                                                JobId = v3.id,
                                                                ServerCode = v3.serverCode or "",
                                                                JoinCode = v3.joinCode or "",
                                                                Password = nil,
                                                        })
                                                end)
                                        end
                                end

                                task.wait(3)
                        end
                end)
        end

        textButton2.MouseButton1Click:Connect(function()
                print("[Project Tofa] Hop server manually...")
                flag10 = true
                doHopServer()
        end)

        local tbl5 = {
                422755031,
                198131804,
                681405668,
                3414432341,
                339633571,
                430966809,
                2039323684,
                117723419,
                1015595932,
                263944298,
                112905203,
                2284964418,
                1266437961,
                3120648134,
                1148139861,
                1633233654,
                3350014406,
                971193650,
                661273560,
                66105529,
                77342385,
                167343092,
                2055306963,
                141984224,
                438917845,
                1391134999,
                1796550069,
                255671730,
                3162123826,
                1059541187,
                1259898795,
                31070091,
                1041867508,
                994994173,
                1446694201,
                77525605,
                1001242712,
                2533866869,
                4983064295,
        }

        local function fn10(arg)
                if arg == localPlayer then
                        return
                end

                local ok, result = pcall(function()
                        return arg:IsInGroup(12013007)
                end)

                if ok and result then
                        local ok2, result2 = pcall(function()
                                return arg:GetRoleInGroup(12013007)
                        end)

                        local v3 = ok2 and result2
                        local flag12 = false

                        if v3 then
                                local str = result2:lower()
                                flag12 = str:find("moderator") or str:find("developer") or str:find("contributor") or str:find("tester") or str:find("owner") or str:find("anomaly player")
                        end

                        if flag12 then
                                fn4(false)
                                staffHopInfo = arg.Name .. " (UserId " .. arg.UserId .. ", group role: " .. tostring(result2) .. ")"
                                flag11 = true
                                doHopServer()
                                return
                        end
                end

                for _, v3 in ipairs(tbl5) do
                        if arg.UserId == v3 then
                                fn4(false)
                                staffHopInfo = arg.Name .. " (UserId " .. arg.UserId .. " in hardcoded staff list)"
                                flag11 = true
                                doHopServer()
                                return
                        end
                end

                local tbl6 = {}

                for _, v3 in ipairs(tbl5) do
                        local ok2, result2 = pcall(function()
                                return arg:IsFriendsWith(v3)
                        end)

                        if ok2 and result2 then
                                local ok3, result3 = pcall(function()
                                        return Players:GetNameFromUserIdAsync(v3)
                                end)

                                if ok3 then
                                        local displayName = result3

                                        pcall(function()
                                                local userInfosByUserIdsAsync = game:GetService("UserService"):GetUserInfosByUserIdsAsync({ v3 })

                                                if userInfosByUserIdsAsync and userInfosByUserIdsAsync[1] then
                                                        displayName = userInfosByUserIdsAsync[1].DisplayName
                                                end
                                        end)

                                        tbl6[#tbl6 + 1] = displayName .. "(@" .. result3 .. ")"
                                end
                        end
                end

                if #tbl6 > 0 then
                        fn4(false)
                        staffHopInfo = arg.Name .. " (UserId " .. arg.UserId .. ", friend of staff: " .. table.concat(tbl6, ", ") .. ")"
                        flag11 = true
                        doHopServer()
                        return
                end

                local leaderstats = arg:FindFirstChild("leaderstats")
                local totalKills

                if leaderstats then
                        totalKills = leaderstats:FindFirstChild("Total Kills")
                else
                        totalKills = arg:FindFirstChild("Total Kills")
                end

                if totalKills and totalKills.Value >= 30000 then
                        doHopServer()
                        return true
                end

                if not totalKills then
                        local connection = nil

                        connection = arg.ChildAdded:Connect(function(child)
                                if child.Name == "leaderstats" then
                                        connection:Disconnect()
                                        local connection2 = nil

                                        connection2 = child.ChildAdded:Connect(function(child2)
                                                if child2.Name == "Total Kills" then
                                                        connection2:Disconnect()
                                                        if child2.Value >= 30000 then
                                                                doHopServer()
                                                                return
                                                        end
                                                        local connection3 = nil

                                                        connection3 = child2:GetPropertyChangedSignal("Value"):Connect(function()
                                                                if child2.Value >= 30000 then
                                                                        connection3:Disconnect()
                                                                        doHopServer()
                                                                end
                                                        end)
                                                end
                                        end)
                                end
                        end)

                        return
                end

                local connection = nil

                connection = totalKills:GetPropertyChangedSignal("Value"):Connect(function()
                        if totalKills.Value >= 30000 then
                                connection:Disconnect()
                                doHopServer()
                        end
                end)
        end

        Players.PlayerAdded:Connect(function(player)
                task.spawn(pcall, fn10, player)
        end)

        for _, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                        task.spawn(pcall, fn10, player)
                end
        end

        local str = "undefined"

        pcall(function()
                if type(gethwid) == "function" then
                        str = gethwid() or "none"
                elseif type(getfingerprintid) == "function" then
                        str = getfingerprintid() or "none"
                elseif type(getdeviceid) == "function" then
                        str = getdeviceid() or "none"
                end
        end)

        local name = localPlayer.Name
        local str2 = "wss://pbf-websocket.baovq-tiger.workers.dev/?" .. "serverid=" .. game.JobId .. "&service=publicfarm" .. "&ispremium=" .. tostring(flag2) .. "&username=" .. name .. "&hwid=" .. str

        if getgenv().PBF_WS then
                pcall(function()
                        getgenv().PBF_WS:Close()
                end)

                getgenv().PBF_WS = nil
        end

        local n9 = 10
        local n10 = 2
        local flag12 = false

        local function fn11(arg)
                local ok, result = pcall(function()
                        return game:GetService("HttpService"):JSONDecode(arg)
                end)

                if not ok or not result then
                        return
                end

                if result.command == "server_hop" then
                        flag = false

                        if getgenv().PBF_WS then
                                pcall(function()
                                        getgenv().PBF_WS:Close()
                                end)

                                getgenv().PBF_WS = nil
                        end

                        print("[Project Tofa] Received hop server command for: " .. name)
                        flag10 = true
                        doHopServer()
                end

                if result.command == "kill_dup_session" then
                        flag = false
                        flag12 = true

                        if getgenv().PBF_WS then
                                pcall(function()
                                        getgenv().PBF_WS:Close()
                                end)

                                getgenv().PBF_WS = nil
                        end

                        game.Players.LocalPlayer:Kick("[Project Tofa] You got kicked because of duplicate session!")
                        task.wait(2)
                        game:Shutdown()
                end

                if result.command == "kill_session" then
                        flag = false
                        flag12 = true

                        if getgenv().PBF_WS then
                                pcall(function()
                                        getgenv().PBF_WS:Close()
                                end)

                                getgenv().PBF_WS = nil
                        end

                        game.Players.LocalPlayer:Kick("[Project Tofa] You got kicked by an admin!")
                        task.wait(2)
                        game:Shutdown()
                end
        end

        local function fn12()
                local ok, result = pcall(function()
                        getgenv().PBF_WS = WebSocket.connect(str2)
                end)

                if not ok or not getgenv().PBF_WS then
                        return false, tostring(result)
                end
                flag = true
                print("[Project Tofa] Server connected")
                getgenv().PBF_WS.OnMessage:Connect(fn11)

                getgenv().PBF_WS.OnClose:Connect(function()
                        flag = false
                        print("[Project Tofa] Server closed")
                end)

                return true
        end

        task.spawn(function()
                local n11 = 0
                local n12 = 2

                while not flag12 do
                        n11 += 1
                        print("[Project Tofa] Connecting... (attempt " .. n11 .. ")")
                        local flag13, flag14

                        if fn12() then
                                while flag do
                                        task.wait(1)
                                end

                                if not flag12 then
                                        print("[Project Tofa] Disconnected, reconnecting in " .. n10 .. "s...")
                                        task.wait(2)
                                        n12 = 2
                                        flag13 = n11 >= n9
                                        flag14 = flag13 and not flag

                                        if flag14 then
                                                warn("[Project Tofa] Max retries reached, giving up")
                                                break
                                        else
                                                continue
                                        end
                                end
                        else
                                warn("[Project Tofa] Connect failed (attempt " .. n11 .. "), retrying in " .. n12 .. "s...")
                                task.wait(n12)
                                n12 = math.min(n12 * 2, 30)
                                flag13 = n11 >= n9
                                flag14 = flag13 and not flag

                                if flag14 then
                                        warn("[Project Tofa] Max retries reached, giving up")
                                        break
                                else
                                        continue
                                end
                        end

                        break
                end
        end)

        local Players2 = game:GetService("Players")

        local function fn13()
                local players = Players2:GetPlayers()
                local tbl6 = {}

                for _, player in ipairs(players) do
                        local function fn14(arg)
                                local match = arg:match("^([^_]+)_")
                                return match and match:lower() or nil
                        end

                        local v3 = fn14(player.Name)
                        local v4 = fn14(player.DisplayName)

                        local function fn15(arg, arg2)
                                if not arg then
                                        return
                                end

                                if not tbl6[arg] then
                                        tbl6[arg] = {}
                                end

                                table.insert(tbl6[arg], { player = player, source = arg2, original = arg2 == "username" and player.Name or player.DisplayName })
                        end

                        fn15(v3, "username")
                        fn15(v4, "displayname")
                end

                local tbl7 = {}

                for k, v3 in pairs(tbl6) do
                        local tbl8 = {}
                        local tbl9 = {}

                        for _, v4 in ipairs(v3) do
                                if not tbl8[v4.player.UserId] then
                                        tbl8[v4.player.UserId] = true
                                        table.insert(tbl9, v4)
                                end
                        end

                        if #tbl9 >= 2 then
                                tbl7[k] = tbl9
                        end
                end

                return tbl7
        end

        local function fn14(arg)
                local flag13 = false

                for k, v3 in pairs(arg) do
                        print("[ZKClanScan] Clan detected: [" .. k .. "] — " .. #v3 .. " members")

                        for _, v4 in ipairs(v3) do
                                print("  - " .. v4.player.Name .. " (" .. v4.player.DisplayName .. ") matched via " .. v4.source .. ": " .. v4.original)
                        end

                        flag13 = true
                end

                if not flag13 then
                        print("[ZKClanScan] No clans detected")
                else
                        print("[ZKClanScan] Clans detected, hop server...")
                        flag10 = true
                        doHopServer()
                end
        end

        task.spawn(function()
                print("[ZKClanScan] Scanning server...")
                local v3 = fn13()
                fn14(v3)

                Players2.PlayerAdded:Connect(function()
                        task.wait(1)
                        print("[ZKClanScan] New player joined, rescanning...")
                        local v4 = fn13()
                        fn14(v4)
                end)
        end)
end

deathCounterConns = {}
deathCounterDebounce = {}
hookedChars = {}

do
        local flag9 = false

        local function fn8()
                return 0
        end

        local function fn9(arg)
                return arg:IsA("Accessory") and arg.Name == "Counter"
        end

        local flag10 = false
        local connection = nil

        local function fn10(cFrame2)
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not (character and humanoidRootPart) then
                        return
                end

                task.spawn(function()
                        RunService.RenderStepped:Once(function()
                                humanoidRootPart.Velocity = Vector3.new()
                                RunService.Heartbeat:Wait()
                                humanoidRootPart.Velocity = Vector3.new()
                        end)

                        RunService.Heartbeat:Once(function()
                                humanoidRootPart.CFrame = cFrame2
                        end)
                end)
        end

        local function fn11()
                local character = localPlayer.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                if character and humanoid and workspace.CurrentCamera then
                        local cFrame2 = workspace.CurrentCamera.CFrame
                        workspace.CurrentCamera:Destroy()
                        local camera = Instance.new("Camera", workspace)
                        currentCamera = camera
                        camera.CameraType = Enum.CameraType.Custom
                        camera.CameraSubject = humanoid
                        camera.CFrame = cFrame2
                        localPlayer.CameraMode = Enum.CameraMode.Classic
                        local head = character:FindFirstChild("Head")

                        if head then
                                head.Anchored = false
                        end
                end
        end

        local function fn12(arg)
                local ok, result = pcall(function()
                        return arg.DisplayName
                end)

                if not ok or not result or result == "" then
                        return arg.Name
                end

                for _, player in pairs(Players:GetPlayers()) do
                        if player ~= arg and player.DisplayName == result then
                                return arg.Name
                        end
                end

                return result
        end

        local function fn13(arg)
                if connection then
                        connection:Disconnect()
                        connection = nil
                end

                if not arg then
                        return
                end

                connection = arg.AnimationPlayed:Connect(function(arg2)
                        if not arg2.Animation.AnimationId:match("11343250001") then
                                return
                        end
                        flag9 = true

                        task.spawn(function()
                                task.wait(0.2)
                                local v3 = fn8()
                                local flag11 = v3 <= 0

                                if v3 <= 0 then
                                        pcall(function()
                                                arg2:Stop()
                                        end)
                                end

                                task.spawn(fn11)
                                local character = localPlayer.Character
                                character:WaitForChild("AbsoluteImmortal", 1)
                                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                local cFrame2 = humanoidRootPart.CFrame
                                local v4 = nil

                                for _, player in pairs(Players:GetPlayers()) do
                                        if player ~= localPlayer then
                                                local character2 = player.Character
                                                local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
                                                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

                                                if character2 and humanoidRootPart2 and humanoid then
                                                        for _, v5 in pairs(humanoid:GetPlayingAnimationTracks()) do
                                                                if v5.Animation.AnimationId:match("11343318134") and (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= 15 then
                                                                        v4 = player
                                                                end
                                                        end
                                                end
                                        end
                                end

                                local character2

                                if v4 then
                                        character2 = v4.Character
                                        character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
                                        fn12(v4)
                                else
                                        local model = Instance.new("Model")
                                        local humanoid = Instance.new("Humanoid", model)
                                        humanoid.Health = 100
                                        character2 = humanoid

                                        task.delay(v3 + 2, function()
                                                humanoid.Health = 0
                                        end)
                                end

                                if v3 > 0 then
                                        task.wait(v3)
                                        character = localPlayer.Character
                                        local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
                                        if not (character and humanoidRootPart2) then
                                                return
                                        end
                                end

                                local cameraSubject = workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject

                                if workspace.CurrentCamera then
                                        workspace.CurrentCamera.CameraSubject = nil
                                end

                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                local n9 = CFrame.new(0, -10000, 0) * CFrame.Angles(1.5707963267948966, 0, 0)
                                local now = tick()

                                while true do
                                        fn10(n9)

                                        if v3 > 0 and not flag11 then
                                                pcall(function()
                                                        arg2:Stop()
                                                end)

                                                flag11 = true
                                        end

                                        RunService.RenderStepped:Wait()
                                        if not (character2 and character2.Health <= 0 or humanoid and humanoid.Health <= 0 or tick() >= now + 10) then
                                                continue
                                        end
                                        break
                                end

                                if workspace.CurrentCamera then
                                        workspace.CurrentCamera.CameraSubject = cameraSubject
                                end

                                fn10(cFrame2)
                                task.wait(1)
                                local character3 = localPlayer.Character

                                if character3 then
                                        local freeze = character3:FindFirstChild("Freeze")
                                        local noRotate = character3:FindFirstChild("NoRotate")

                                        if freeze then
                                                freeze:Destroy()
                                        end

                                        if noRotate then
                                                noRotate:Destroy()
                                        end
                                end

                                task.spawn(fn11)
                                flag9 = false
                        end)
                end)
        end

        local function fn14(arg)
                if not arg then
                        return
                end
                local humanoid = arg:FindFirstChildOfClass("Humanoid")

                if humanoid then
                        fn13(humanoid)
                else
                        task.spawn(function()
                                local humanoid2 = arg:WaitForChild("Humanoid", 5)

                                if humanoid2 then
                                        fn13(humanoid2)
                                end
                        end)
                end
        end

        fn14(localPlayer.Character)

        localPlayer.CharacterAdded:Connect(function(character)
                task.wait(0.1)
                fn14(character)
        end)

        local function fn15(arg, arg2)
                if not arg or not arg2 or arg2 == localPlayer then
                        return
                end

                if hookedChars[arg] then
                        return
                end
                hookedChars[arg] = true

                for _, child in pairs(arg:GetChildren()) do
                        if fn9(child) then
                                local flag11 = false

                                if flag10 then
                                        flag11 = not deathCounterDebounce[arg2]
                                end

                                if flag11 then
                                        deathCounterDebounce[arg2] = true
                                end
                        end
                end

                local connection2 = arg.ChildAdded:Connect(function(child)
                        if not flag10 then
                                return
                        end

                        if not fn9(child) then
                                return
                        end

                        if deathCounterDebounce[arg2] then
                                return
                        end
                        deathCounterDebounce[arg2] = true
                end)

                table.insert(deathCounterConns, connection2)
        end

        local function fn16(arg)
                if arg == localPlayer then
                        return
                end

                if arg.Character then
                        task.spawn(fn15, arg.Character, arg)
                end

                local connection2 = arg.CharacterAdded:Connect(function(character)
                        if not flag10 then
                                return
                        end
                        task.wait(0.1)
                        fn15(character, arg)
                end)

                table.insert(deathCounterConns, connection2)
        end

        for _, v3 in pairs(deathCounterConns) do
                pcall(v3.Disconnect, v3)
        end

        for _, player in pairs(Players:GetPlayers()) do
                fn16(player)
        end

        table.insert(deathCounterConns, Players.PlayerAdded:Connect(function(player)
                if flag10 then
                        fn16(player)
                end
        end))

        local tbl4 = {}
        local tbl5 = {}

        localPlayer.CharacterAdded:Connect(function()
                getgenv().desync = nil
        end)

        isCountering = function(arg)
                if not arg then
                        return false
                end
                local model = arg:FindFirstAncestorWhichIsA("Model")
                if model and model:FindFirstChild("Counter") then
                        return true
                end

                for _, v3 in pairs(arg:GetPlayingAnimationTracks()) do
                        local animationId = v3.Animation.AnimationId
                        if animationId:match("13726226905") or animationId:match("13726235415") then
                                return true
                        end
                end

                return false
        end

        local function fn17(arg, arg2)
                if not arg2 then
                        return
                end

                if tbl4[arg] then
                        pcall(function()
                                tbl4[arg]:Disconnect()
                        end)

                        tbl4[arg] = nil
                end

                while true do
                        task.wait()
                        if not (not arg2.Parent or arg2:FindFirstChild("HumanoidRootPart") and arg2:FindFirstChildOfClass("Humanoid")) then
                                continue
                        end
                        break
                end

                if not arg2.Parent then
                        return
                end
                local humanoidRootPart = arg2:FindFirstChild("HumanoidRootPart")
                local humanoid = arg2:FindFirstChildOfClass("Humanoid")
                if not (humanoidRootPart and humanoid) then
                        return
                end

                local function fn18(arg3, arg4)
                        local match = tostring(arg4):match("%d+")

                        for _, v3 in pairs(arg3:GetPlayingAnimationTracks()) do
                                if v3.Animation.AnimationId:match(match) then
                                        return v3
                                end
                        end

                        return nil
                end

                tbl4[arg] = humanoid.AnimationPlayed:Connect(function(arg3)
                        local animationId = arg3.Animation.AnimationId
                        local character = localPlayer.Character
                        local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
                        if not (character and humanoidRootPart2) then
                                return
                        end

                        task.spawn(function()
                                if arg3.WeightTarget == 0 or arg3.Speed == 0 then
                                        return
                                end
                                local cframe = CFrame.new(9e9, 9e9, 9e9)
                                local v3 = character
                                local humanoid2

                                if character then
                                        humanoid2 = character:FindFirstChildOfClass("Humanoid")
                                else
                                        humanoid2 = v3
                                end

                                local function fn19(arg4)
                                        pcall(function()
                                                repeat
                                                        local desync = { CFrame = cframe }
                                                        getgenv().desync = desync
                                                        task.wait()
                                                        local character2 = localPlayer.Character
                                                        local humanoidRootPart3 = character2 and character2:FindFirstChild("HumanoidRootPart")
                                                        local humanoid3 = character2 and character2:FindFirstChildOfClass("Humanoid")
                                                        if not (character2 and humanoidRootPart3 and humanoid3) then
                                                                return
                                                        end
                                                        humanoidRootPart2 = humanoidRootPart3
                                                        humanoid2 = humanoid3
                                                until arg4()
                                        end)

                                        getgenv().desync = nil

                                        if sethiddenproperty then
                                                local humanoidRootPart3 = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

                                                if humanoidRootPart3 then
                                                        pcall(function()
                                                                sethiddenproperty(humanoidRootPart3, "PhysicsRepRootPart", nil)
                                                        end)
                                                end
                                        end
                                end

                                local function fn20(arg4)
                                        if not arg4 then
                                                return false
                                        end
                                        local model = arg4:FindFirstAncestorWhichIsA("Model")
                                        return model and model:FindFirstChild("Counter") and true or false
                                end

                                local function fn21(size)
                                        local part = Instance.new("Part", workspace)
                                        part.Anchored = true
                                        part.Size = size
                                        part.CanCollide = false
                                        part.Transparency = 1
                                        local flag11 = false

                                        local connection2 = part.Touched:Connect(function(hit)
                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                        flag11 = true
                                                end
                                        end)

                                        local connection3 = part.TouchEnded:Connect(function(hit)
                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                        flag11 = false
                                                end
                                        end)

                                        return part, function()
                                                return flag11
                                        end, function()
                                                pcall(function()
                                                        part:Destroy()
                                                end)

                                                connection2:Disconnect()
                                                connection3:Disconnect()
                                        end
                                end

                                local function fn22()
                                        local invisPart30 = getgenv().InvisPart30
                                        if getgenv().InvisActive and invisPart30 then
                                                return invisPart30.Position
                                        end
                                        return humanoidRootPart2.Position
                                end

                                if animationId:match("12983333733") and arg2:GetAttribute("Ulted") ~= nil then
                                        task.delay(1, function()
                                                if arg2:FindFirstChild("AbsoluteImmortal", true) and arg2:FindFirstChild("Freeze") then
                                                        task.wait(4.25)
                                                        local now = tick()

                                                        fn19(function()
                                                                local position = humanoidRootPart.Position
                                                                local flag11 = (fn22() - position).Magnitude > 150
                                                                local flag12

                                                                if flag11 then
                                                                        flag12 = flag11
                                                                else
                                                                        local n9 = now + 2
                                                                        flag12 = tick() >= n9
                                                                end

                                                                return flag12 or not arg3.IsPlaying
                                                        end)
                                                end
                                        end)
                                end

                                if animationId:match("11365563255") and arg2:GetAttribute("Ulted") ~= nil then
                                        task.delay(1, function()
                                                if arg2:FindFirstChild("AbsoluteImmortal", true) and arg2:FindFirstChild("Freeze") then
                                                        task.wait(3)
                                                        local now = tick()

                                                        fn19(function()
                                                                local n9 = now + 2.5
                                                                return tick() >= n9
                                                        end)
                                                end
                                        end)
                                end

                                if animationId:match("13927612951") and arg2:GetAttribute("Ulted") ~= nil then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 150
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 2.5
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("12342141464") then
                                        task.wait(3.5)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 125
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1.25
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("12463072679") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 25
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 0.75
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("13603396939") then
                                        local now = tick()

                                        fn19(function()
                                                local cFrame2 = humanoidRootPart.CFrame
                                                local flag11 = (fn22() - (cFrame2 * CFrame.new(0, 0, -1)).Position).Magnitude > 7.5 or isCountering(humanoid)

                                                if not flag11 then
                                                        local n9 = now + 2.5
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11
                                        end)
                                end

                                if animationId:match("12460977270") then
                                        local v4, v5, v6 = fn21(Vector3.new(12.5, 5, 12.5))
                                        local now = tick()

                                        while true do
                                                v4.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -6.25)

                                                if v5() and not isCountering(humanoid) then
                                                        getgenv().desync = { CFrame = cframe }
                                                else
                                                        getgenv().desync = nil
                                                end

                                                RunService.RenderStepped:Wait()
                                                if not (tick() >= now + 1.85 or not arg3.IsPlaying) then
                                                        continue
                                                end
                                                break
                                        end

                                        getgenv().desync = nil
                                        v6()
                                end

                                if animationId:match("14057231976") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 10
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 0.5
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)

                                        task.wait(0.5)
                                        local now2 = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 10 or isCountering(humanoid)

                                                if not flag11 then
                                                        local n9 = now2 + 1.25
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11
                                        end)
                                end

                                if animationId:match("13630786846") then
                                        local v4, v5, v6 = fn21(Vector3.new(25, 10, 75))
                                        local now = tick()

                                        while true do
                                                v4.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -37.5)

                                                if v5() and not isCountering(humanoid) then
                                                        getgenv().desync = { CFrame = cframe }
                                                else
                                                        getgenv().desync = nil
                                                end

                                                RunService.RenderStepped:Wait()
                                                if not (tick() >= now + 1.5 or not arg3.IsPlaying) then
                                                        continue
                                                end
                                                break
                                        end

                                        getgenv().desync = nil
                                        v6()
                                end

                                if animationId:match("72451715583225") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 15
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 0.75
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("13813955149") then
                                        local position = humanoidRootPart.Position

                                        if (fn22() - position).Magnitude <= 25 then
                                                getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                task.wait(0.75)
                                                getgenv().desync = nil
                                        end

                                        local connection2 = nil

                                        connection2 = workspace.Thrown.ChildAdded:Connect(function(child)
                                                if child:IsA("MeshPart") and child.Name:lower() == "trash can" then
                                                        connection2:Disconnect()
                                                        local now = tick()

                                                        fn19(function()
                                                                local position2 = child.Position
                                                                local flag11 = (fn22() - position2).Magnitude > 25
                                                                local flag12

                                                                if flag11 then
                                                                        flag12 = flag11
                                                                else
                                                                        local n9 = now + 2
                                                                        flag12 = tick() >= n9
                                                                end

                                                                return flag12
                                                        end)
                                                end
                                        end)
                                end

                                if animationId:match("15128849047") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 100 or fn18(humanoid, "15123665491")

                                                if not flag11 then
                                                        local n9 = now + 3
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11
                                        end)
                                end

                                if animationId:match("15391323441") then
                                        task.wait(5.5)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 125
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("16082123712") then
                                        task.wait(2.5)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1.5
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("14719290328") then
                                        local position = humanoidRootPart.Position

                                        if (fn22() - position).Magnitude <= 50 then
                                                getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                        end

                                        task.wait(0.5)

                                        if arg3.IsPlaying then
                                                local now = tick()

                                                fn19(function()
                                                        local position2 = humanoidRootPart.Position
                                                        local flag11 = (fn22() - position2).Magnitude > 50 or fn20(humanoid2)

                                                        if not flag11 then
                                                                local n9 = now + 3.5
                                                                flag11 = tick() >= n9
                                                        end

                                                        return flag11 or not arg3.IsPlaying
                                                end)
                                        end
                                end

                                if animationId:match("15520132233") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50 or fn20(humanoid2)

                                                if not flag11 then
                                                        local n9 = now + 3.3
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11 or not arg3.IsPlaying
                                        end)

                                        repeat
                                                task.wait()
                                        until now + 5.5 <= tick()

                                        local now2 = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 100 or fn20(humanoid2)

                                                if not flag11 then
                                                        local n9 = now2 + 1
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11 or not arg3.IsPlaying
                                        end)
                                end

                                if animationId:match("15676072469") then
                                        local v4, v5, v6 = fn21(Vector3.new(50, 10, 150))
                                        local now = tick()

                                        while true do
                                                v4.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -75)

                                                if v5() and not fn20(humanoid2) then
                                                        getgenv().desync = { CFrame = cframe }
                                                else
                                                        getgenv().desync = nil
                                                end

                                                RunService.RenderStepped:Wait()
                                                if not (tick() >= now + 2 or not arg3.IsPlaying) then
                                                        continue
                                                end
                                                break
                                        end

                                        getgenv().desync = nil
                                        v6()
                                end

                                if animationId:match("16057411888") then
                                        task.wait(4.25)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 2
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("18435535291") then
                                        task.wait(4.25)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 100
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1.25
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("17857788598") then
                                        task.wait(0.65)

                                        if arg3.IsPlaying then
                                                local part = Instance.new("Part", workspace)
                                                part.Anchored = true
                                                part.Size = Vector3.new(35, 2048, 35)
                                                part.CanCollide = false
                                                part.Transparency = 1
                                                local flag11 = false

                                                local connection2 = part.Touched:Connect(function(hit)
                                                        if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                flag11 = true
                                                        end
                                                end)

                                                local connection3 = part.TouchEnded:Connect(function(hit)
                                                        if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                flag11 = false
                                                        end
                                                end)

                                                local now = tick()

                                                while true do
                                                        part.CFrame = humanoidRootPart.CFrame

                                                        if flag11 and not fn18(humanoid, "15128849047") then
                                                                getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                        else
                                                                getgenv().desync = nil
                                                        end

                                                        RunService.RenderStepped:Wait()
                                                        if not (tick() >= now + 0.85 or not arg3.IsPlaying) then
                                                                continue
                                                        end
                                                        break
                                                end

                                                getgenv().desync = nil
                                                connection2:Disconnect()
                                                connection3:Disconnect()

                                                pcall(function()
                                                        part:Destroy()
                                                end)
                                        end
                                end

                                if animationId:match("129651400898906") then
                                        task.wait(0.5)
                                        local cFrame2 = humanoidRootPart.CFrame
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 75

                                                if not flag11 then
                                                        local n9 = now + 1.25
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11 or not arg3.IsPlaying
                                        end)

                                        task.wait(1)
                                        local now2 = tick()

                                        fn19(function()
                                                local position = cFrame2.Position
                                                local flag11 = (fn22() - position).Magnitude > 75
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now2 + 1.75
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("18896229321") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 15 or isCountering(humanoid)
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 3.5
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12 or not arg3.IsPlaying
                                        end)

                                        task.wait(1)

                                        if arg3.IsPlaying then
                                                local position = humanoidRootPart.Position

                                                if (fn22() - position).Magnitude <= 25 then
                                                        local now2 = tick()

                                                        fn19(function()
                                                                local position2 = humanoidRootPart.Position
                                                                local flag11 = (fn22() - position2).Magnitude > 25
                                                                local flag12

                                                                if flag11 then
                                                                        flag12 = flag11
                                                                else
                                                                        local n9 = now2 + 2
                                                                        flag12 = tick() >= n9
                                                                end

                                                                return flag12 or not arg3.IsPlaying
                                                        end)
                                                end
                                        end
                                end

                                if animationId:match("18897119503") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1.5
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("106755459092436") or animationId:match("75502010126640") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 2
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("16515850153") then
                                        task.spawn(function()
                                                local position = humanoidRootPart.Position

                                                if (fn22() - position).Magnitude <= 15 then
                                                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                end

                                                local dotted = workspace.Thrown:WaitForChild("Dotted", 1)

                                                if dotted then
                                                        local dots = dotted:WaitForChild("Dots", 1)
                                                        if not dots then
                                                                getgenv().desync = nil
                                                                return
                                                        end
                                                        local now = tick()
                                                        local position2 = dots.Position

                                                        if (fn22() - position2).Magnitude > 20 then
                                                                getgenv().desync = nil
                                                        end

                                                        fn19(function()
                                                                local position3 = dots.Position
                                                                local flag11 = (fn22() - position3).Magnitude > 20 or fn20(humanoid2)
                                                                local flag12

                                                                if flag11 then
                                                                        flag12 = flag11
                                                                else
                                                                        local n9 = now + 4.25
                                                                        flag12 = tick() >= n9
                                                                end

                                                                return flag12
                                                        end)
                                                else
                                                        getgenv().desync = nil
                                                end
                                        end)
                                end

                                if animationId:match("16431491215") then
                                        local now = tick()

                                        while true do
                                                task.wait()
                                                local cFrame2 = humanoidRootPart.CFrame
                                                if not ((fn22() - (cFrame2 * CFrame.new(0, 0, -25)).Position).Magnitude <= 25 or fn18(humanoid, "15128849047") or tick() >= now + 0.75) then
                                                        continue
                                                end
                                                break
                                        end

                                        if not fn18(humanoid, "15128849047") then
                                                fn19(function()
                                                        local cFrame2 = humanoidRootPart.CFrame
                                                        local flag11 = (fn22() - (cFrame2 * CFrame.new(0, 0, -20)).Position).Magnitude > 25 or fn18(humanoid, "15128849047")

                                                        if not flag11 then
                                                                local n9 = now + 0.75
                                                                flag11 = tick() >= n9
                                                        end

                                                        return flag11
                                                end)
                                        end
                                end

                                if animationId:match("16597912086") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 15 or isCountering(humanoid)
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 0.75
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("17275150809") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("17278415853") and arg2:GetAttribute("Character") == "Esper" then
                                        task.wait(11)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 100
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 6
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("16734584478") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 75
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 5.75
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12
                                        end)
                                end

                                if animationId:match("13376869471") then
                                        local part = Instance.new("Part", workspace)
                                        part.Anchored = true
                                        part.Size = Vector3.new(10, 7.5, 60)
                                        part.CanCollide = false
                                        part.Transparency = 1
                                        local flag11 = false

                                        local connection2 = part.Touched:Connect(function(hit)
                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                        flag11 = true
                                                end
                                        end)

                                        local connection3 = part.TouchEnded:Connect(function(hit)
                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                        flag11 = false
                                                end
                                        end)

                                        local now = tick()

                                        while true do
                                                part.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -part.Size.Z / 2)
                                                RunService.RenderStepped:Wait()
                                                if not (flag11 or tick() >= now + 3 or not arg3.IsPlaying) then
                                                        continue
                                                end
                                                break
                                        end

                                        if flag11 then
                                                local now2 = tick()

                                                fn19(function()
                                                        local flag12 = not flag11

                                                        if not flag12 then
                                                                local n9 = now2 + 1
                                                                flag12 = tick() >= n9
                                                        end

                                                        return flag12 or not arg3.IsPlaying
                                                end)
                                        end

                                        connection2:Disconnect()
                                        connection3:Disconnect()

                                        pcall(function()
                                                part:Destroy()
                                        end)
                                end

                                if animationId:match("13294790250") then
                                        task.wait(0.5)
                                        local now = tick()

                                        fn19(function()
                                                local cFrame2 = humanoidRootPart.CFrame
                                                local flag11 = (fn22() - (cFrame2 * CFrame.new(0, 0, -2.5)).Position).Magnitude > 10 or isCountering(humanoid)

                                                if not flag11 then
                                                        local n9 = now + 0.75
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11
                                        end)
                                end

                                if animationId:match("13632347366") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 75 or fn20(humanoid2)
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 1.75
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12 or not arg3.IsPlaying
                                        end)
                                end

                                if animationId:match("13723174078") then
                                        task.wait(0.5)
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 50
                                                local flag12

                                                if flag11 then
                                                        flag12 = flag11
                                                else
                                                        local n9 = now + 2
                                                        flag12 = tick() >= n9
                                                end

                                                return flag12 or not arg3.IsPlaying
                                        end)
                                end

                                if animationId:match("13881335713") then
                                        task.wait(0.75)

                                        if arg3.IsPlaying then
                                                local part = Instance.new("Part", workspace)
                                                part.Anchored = true
                                                part.Size = Vector3.new(35, 5, 60)
                                                part.CanCollide = false
                                                part.Transparency = 1
                                                local flag11 = false

                                                local connection2 = part.Touched:Connect(function(hit)
                                                        if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                flag11 = true
                                                        end
                                                end)

                                                local connection3 = part.TouchEnded:Connect(function(hit)
                                                        if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                flag11 = false
                                                        end
                                                end)

                                                local now = tick()

                                                while true do
                                                        part.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -part.Size.Z / 2)
                                                        RunService.RenderStepped:Wait()
                                                        if not (flag11 or tick() >= now + 3 or not arg3.IsPlaying) then
                                                                continue
                                                        end
                                                        break
                                                end

                                                if flag11 then
                                                        local now2 = tick()

                                                        fn19(function()
                                                                local flag12 = not flag11

                                                                if not flag12 then
                                                                        local n9 = now2 + 1
                                                                        flag12 = tick() >= n9
                                                                end

                                                                return flag12 or not arg3.IsPlaying
                                                        end)
                                                end

                                                connection2:Disconnect()
                                                connection3:Disconnect()

                                                pcall(function()
                                                        part:Destroy()
                                                end)
                                        end
                                end

                                if animationId:match("14721837245") then
                                        local now = tick()

                                        fn19(function()
                                                local position = humanoidRootPart.Position
                                                local flag11 = (fn22() - position).Magnitude > 25 or fn18(humanoid, "15128849047")

                                                if not flag11 then
                                                        local n9 = now + 1.5
                                                        flag11 = tick() >= n9
                                                end

                                                return flag11 or not arg3.IsPlaying
                                        end)

                                        if now + 1.5 <= tick() then
                                                task.wait(1)
                                                local now2 = tick()

                                                fn19(function()
                                                        local position = humanoidRootPart.Position
                                                        local flag11 = (fn22() - position).Magnitude > 100
                                                        local flag12

                                                        if flag11 then
                                                                flag12 = flag11
                                                        else
                                                                local n9 = now2 + 1.5
                                                                flag12 = tick() >= n9
                                                        end

                                                        return flag12 or not arg3.IsPlaying
                                                end)
                                        end
                                end

                                if animationId:match("13083332742") then
                                        task.wait(1)
                                        local part = Instance.new("Part", workspace)
                                        part.Anchored = true
                                        part.Size = Vector3.new(12.5, 5, 1000)
                                        part.CanCollide = false
                                        part.Transparency = 1

                                        task.delay(0.25, function()
                                                part.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -part.Size.Z / 2)
                                        end)

                                        local flag11 = false

                                        local connection2 = part.Touched:Connect(function(hit)
                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                        flag11 = true
                                                end
                                        end)

                                        local connection3 = part.TouchEnded:Connect(function(hit)
                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                        flag11 = false
                                                end
                                        end)

                                        local now = tick()

                                        while true do
                                                if flag11 and not fn20(humanoid2) then
                                                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                else
                                                        getgenv().desync = nil
                                                end

                                                RunService.RenderStepped:Wait()
                                                if not (tick() >= now + 4 or not arg3.IsPlaying) then
                                                        continue
                                                end
                                                break
                                        end

                                        getgenv().desync = nil
                                        connection2:Disconnect()
                                        connection3:Disconnect()

                                        pcall(function()
                                                part:Destroy()
                                        end)
                                end

                                if animationId:match("13146710762") then
                                        task.wait(3.25)

                                        if arg3.IsPlaying then
                                                local tbl6 = {}
                                                local tbl7 = {}
                                                local n9 = CFrame.new(50, 0, -200) * CFrame.Angles(0, -0.26179938779914941, 0)
                                                local n10 = CFrame.new(-50, 0, -200) * CFrame.Angles(0, 0.26179938779914941, 0)
                                                local cframe2 = CFrame.new
                                                tbl7[1] = n9
                                                tbl7[2] = n10

                                                do
                                                        local values = table.pack(cframe2(0, 0, -200))
                                                        table.move(values, 1, values.n, 3, tbl7)
                                                end

                                                local flag11 = false
                                                local tbl8 = {}

                                                for _, v4 in ipairs(tbl7) do
                                                        local part = Instance.new("Part", workspace)
                                                        part.Anchored = true
                                                        part.Size = Vector3.new(100, 75, 400)
                                                        part.CanCollide = false
                                                        part.Transparency = 1
                                                        part.CFrame = humanoidRootPart.CFrame * v4
                                                        table.insert(tbl6, part)

                                                        table.insert(tbl8, part.Touched:Connect(function(hit)
                                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                        flag11 = true
                                                                end
                                                        end))

                                                        table.insert(tbl8, part.TouchEnded:Connect(function(hit)
                                                                if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                        flag11 = false
                                                                end
                                                        end))
                                                end

                                                local now = tick()

                                                while true do
                                                        if flag11 and not fn20(humanoid2) then
                                                                getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                        else
                                                                getgenv().desync = nil
                                                        end

                                                        RunService.RenderStepped:Wait()
                                                        if not (tick() >= now + 6 or not arg3.IsPlaying) then
                                                                continue
                                                        end
                                                        break
                                                end

                                                getgenv().desync = nil

                                                for _, v4 in ipairs(tbl8) do
                                                        v4:Disconnect()
                                                end

                                                for _, v4 in ipairs(tbl6) do
                                                        pcall(function()
                                                                v4:Destroy()
                                                        end)
                                                end
                                        end
                                end

                                if animationId:match("11343318134") then
                                        task.wait(7.5)
                                        if not arg3.IsPlaying then
                                                return
                                        end
                                        local tbl6 = {}
                                        local tbl7 = {}
                                        local n9 = CFrame.new(60, 0, -250) * CFrame.Angles(0, -0.26179938779914941, 0)
                                        local n10 = CFrame.new(-60, 0, -250) * CFrame.Angles(0, 0.26179938779914941, 0)
                                        local cframe2 = CFrame.new
                                        tbl7[1] = n9
                                        tbl7[2] = n10

                                        do
                                                local values = table.pack(cframe2(0, 0, -250))
                                                table.move(values, 1, values.n, 3, tbl7)
                                        end

                                        local tbl8 = { false, false, false }
                                        local tbl9 = {}

                                        for i in ipairs(tbl7) do
                                                local part = Instance.new("Part", workspace)
                                                part.Anchored = true
                                                part.Size = Vector3.new(125, 5, 500)
                                                part.CanCollide = false
                                                part.Transparency = 1
                                                table.insert(tbl6, part)
                                                local v4 = i

                                                table.insert(tbl9, part.Touched:Connect(function(hit)
                                                        if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                tbl8[v4] = true
                                                        end
                                                end))

                                                table.insert(tbl9, part.TouchEnded:Connect(function(hit)
                                                        if hit == humanoidRootPart2 or hit == getgenv().InvisPart30 then
                                                                tbl8[v4] = false
                                                        end
                                                end))
                                        end

                                        local now = tick()

                                        while true do
                                                for i, v4 in ipairs(tbl6) do
                                                        v4.CFrame = humanoidRootPart.CFrame * tbl7[i]
                                                end

                                                if tbl8[1] or tbl8[2] or tbl8[3] then
                                                        getgenv().desync = { CFrame = CFrame.new(9e9, 9e9, 9e9) }
                                                else
                                                        getgenv().desync = nil
                                                end

                                                RunService.RenderStepped:Wait()
                                                if not (tick() >= now + 2.5 or not arg3.IsPlaying) then
                                                        continue
                                                end
                                                break
                                        end

                                        getgenv().desync = nil

                                        for _, v4 in ipairs(tbl9) do
                                                v4:Disconnect()
                                        end

                                        for _, v4 in ipairs(tbl6) do
                                                pcall(function()
                                                        v4:Destroy()
                                                end)
                                        end
                                end
                        end)
                end)
        end

        local function fn18(arg)
                if arg == localPlayer then
                        return
                end

                if arg.Character then
                        task.spawn(fn17, arg, arg.Character)
                end

                tbl5[arg] = arg.CharacterAdded:Connect(function(character)
                        task.spawn(fn17, arg, character)
                end)
        end

        for _, player in pairs(Players:GetPlayers()) do
                task.spawn(fn18, player)
        end

        Players.PlayerAdded:Connect(function(player)
                if player == localPlayer then
                        return
                end

                task.spawn(function()
                        local now = tick()

                        while true do
                                RunService.RenderStepped:Wait()
                                if not (player:GetAttribute("PreloadDone") or tick() >= now + 30) then
                                        continue
                                end
                                break
                        end

                        if player and player.Parent then
                                if player.Character then
                                        task.spawn(fn17, player, player.Character)
                                end

                                tbl5[player] = player.CharacterAdded:Connect(function(character)
                                        task.spawn(fn17, player, character)
                                end)
                        end
                end)
        end)

        Players.PlayerRemoving:Connect(function(player)
                if tbl4[player] then
                        pcall(function()
                                tbl4[player]:Disconnect()
                        end)

                        tbl4[player] = nil
                end

                if tbl5[player] then
                        pcall(function()
                                tbl5[player]:Disconnect()
                        end)

                        tbl5[player] = nil
                end
        end)

        local function fn19()
                local character = localPlayer.Character

                if sethiddenproperty then
                        if character and character.Parent then
                                pcall(function()
                                        sethiddenproperty(character.HumanoidRootPart, "PhysicsRepRootPart", nil)
                                end)
                        end
                end

                if character and character.Parent then
                        pcall(function()
                                if currentCamera then
                                        character:SetAttribute("NoHeadLerp", false)

                                        if character.Humanoid then
                                                currentCamera.CameraSubject = character.Humanoid
                                        end
                                end
                        end)

                        local now = tick()

                        repeat
                                pcall(function()
                                        character.HumanoidRootPart.CFrame = CFrame.new(character.HumanoidRootPart.Position)
                                end)

                                RunService.Heartbeat:Wait()
                        until tick() - now > 0.15

                        pcall(function()
                                character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
                        end)

                        pcall(function()
                                character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
                        end)

                        pcall(function()
                                character.HumanoidRootPart.Velocity = Vector3.zero
                        end)

                        pcall(function()
                                character.HumanoidRootPart.RotVelocity = Vector3.zero
                        end)

                        local humanoid = character:FindFirstChildOfClass("Humanoid")

                        if humanoid then
                                pcall(function()
                                        humanoid.AutoRotate = true
                                end)
                        end
                end
        end

        local function fn20()
                local now = nil
                local tbl6 = { { Goal = "LeftClick", MousePos = CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) } }
                local tbl7 = { { Goal = "LeftClickRelease" } }
                local tbl8 = { { Mobile = true, Goal = "LeftClick", MousePos = CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) } }

                local tbl9 = {
                        {
                                Dash = Enum.KeyCode.W,
                                Key = Enum.KeyCode.Q,
                                Goal = "KeyPress",
                                MousePos = CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                        },
                }

                local tbl10 = {
                        "17799224866",
                        "17838006839",
                        "17838619895",
                        "17857788598",
                        "17857880283",
                        "18179181663",
                        "18182425133",
                        "18464351556",
                        "18464356233",
                        "18464372850",
                        "18464362124",
                        "136370737633649",
                        "130301810149072",
                        "17889290569",
                        "10479335397",
                        "18896229321",
                }

                local function fn21(arg)
                        if not arg then
                                return false
                        end

                        for _, v3 in pairs(arg:GetPlayingAnimationTracks()) do
                                local animationId = v3.Animation.AnimationId

                                for _, v4 in ipairs(tbl10) do
                                        if animationId:match(v4) then
                                                flag5 = true
                                                return true
                                        end
                                end
                        end

                        flag5 = false
                        return false
                end

                local function fn22(arg)
                        if not arg then
                                return false
                        end

                        for _, v3 in pairs(arg:GetPlayingAnimationTracks()) do
                                local animationId = v3.Animation.AnimationId
                                if animationId:match("18435535291") or animationId:match("18435383478") then
                                        return true
                                end
                        end

                        return false
                end

                local flag11 = false

                RunService.Heartbeat:Connect(function()
                        if not flag3 then
                                return
                        end

                        if flag11 then
                                return
                        end

                        if getgenv().desync then
                                return
                        end

                        if flag7 then
                                return
                        end

                        if flag6 then
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                task.wait(0.001)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                task.wait(0.05)
                                local character = localPlayer.Character
                                if not character then
                                        return
                                end
                                local humanoid = character:FindFirstChildOfClass("Humanoid")
                                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                                if not humanoid or not humanoidRootPart then
                                        return
                                end

                                if fn22(humanoid) or humanoidRootPart.Anchored == true then
                                        return
                                end
                                local playerGui = localPlayer:FindFirstChild("PlayerGui")
                                if not playerGui then
                                        return
                                end
                                local hotbar = playerGui:FindFirstChild("Hotbar")
                                if not hotbar then
                                        return
                                end
                                local backpack = hotbar:FindFirstChild("Backpack")
                                if not backpack then
                                        return
                                end
                                local hotbar2 = backpack:FindFirstChild("Hotbar")
                                if not hotbar2 then
                                        return
                                end
                                local n22 = hotbar2:FindFirstChild("2")

                                if n22 then
                                        local base = n22:FindFirstChild("Base")

                                        if base then
                                                if base:FindFirstChild("Cooldown") == nil or base:FindFirstChild("Cooldown").Size.Y.Scale >= -0.2 then
                                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                                                        task.wait(0.001)
                                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                                                        task.wait(0.05)
                                                end
                                        end
                                end
                        else
                                if not v2 then
                                        return
                                end
                                local character = v2.Character
                                local character2 = localPlayer.Character
                                if not character or not character2 then
                                        return
                                end

                                if character:FindFirstChildWhichIsA("ForceField") then
                                        return
                                end

                                if character:FindFirstChild("AbsoluteImmortal") then
                                        return
                                end

                                if character:FindFirstChild("BeingGrabbed") then
                                        return
                                end

                                if character:FindFirstChild("HunterCounter") then
                                        return
                                end

                                if character:FindFirstChild("AtomicCounter") then
                                        return
                                end
                                local humanoid = character2:FindFirstChildOfClass("Humanoid")
                                if fn21(humanoid) then
                                        return
                                end
                                local humanoid2 = character:FindFirstChildOfClass("Humanoid")
                                local torso = character:FindFirstChild("Torso")
                                if not humanoid2 or not torso or torso.Transparency == 1 then
                                        return
                                end
                                flag11 = true
                                local communicate = character2:FindFirstChild("Communicate")
                                if not communicate then
                                        flag11 = false
                                        return
                                end

                                if not character2:GetAttribute("HoldingSpace") then
                                        local communicate2 = character2:FindFirstChild("Communicate")

                                        pcall(communicate2.FireServer, communicate2, {
                                                Goal = "KeyPress",
                                                Key = Enum.KeyCode.Space,
                                                MousePos = CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
                                        })
                                end

                                if character2:FindFirstChild("Ragdoll") or character2:FindFirstChild("RagdollSim") then
                                        communicate:FireServer({ Dash = Enum.KeyCode.S, Key = Enum.KeyCode.Q, Goal = "KeyPress" })
                                end

                                if character:FindFirstChild("Ragdoll") or character:FindFirstChild("RagdollSim") or humanoid2.Health <= 10 then
                                        if character2:GetAttribute("HoldingM1") then
                                                communicate:FireServer(unpack(tbl7))
                                                task.wait(0.1)
                                        end

                                        print("spaming moves")

                                        if not (humanoid2.Health <= 10) then
                                                if not now or tick() - now >= 7 then
                                                        communicate:FireServer(unpack(tbl9))
                                                        now = tick()
                                                end
                                        end

                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
                                        task.wait(0.001)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
                                        task.wait(0.05)
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                                        task.wait(0.001)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                                        task.wait(0.05)
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
                                        task.wait(0.001)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
                                        task.wait(0.05)
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Four, false, game)
                                        task.wait(0.001)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Four, false, game)
                                else
                                        task.wait(0.1)
                                        print("spaming m1")

                                        if character2:GetAttribute("mobile") then
                                                communicate:FireServer(unpack(tbl8))
                                        else
                                                communicate:FireServer(unpack(tbl6))
                                        end

                                        task.wait(0.1)
                                        communicate:FireServer(unpack(tbl7))
                                        task.wait(0.1)
                                end
                        end

                        flag11 = false
                end)
        end

        local function fn21(arg, arg2, arg3)
                local cframe = CFrame.new(0, 0, 0)
                local v3, v4 = cframe:ToEulerAnglesYXZ()
                local cframe2 = CFrame.fromEulerAnglesYXZ(0, v4, 0)
                return CFrame.new((CFrame.new(cframe.Position) * cframe2 * CFrame.new(0, arg2, arg3)).Position) * cframe2
        end

        local function fn22()
                local now = nil
                v2 = fn7()

                RunService.Heartbeat:Connect(function()
                        if not flag3 then
                                if flag4 then
                                        flag4 = false
                                        fn19()
                                        v2 = fn7()
                                end

                                return
                        end

                        if flag9 then
                                return
                        end

                        if not v2 then
                                flag4 = false
                                fn19()
                                v2 = fn7()
                                return
                        end

                        local character = v2.Character
                        local character2 = localPlayer.Character
                        if not character2 then
                                return
                        end

                        if localPlayer.PlayerGui.Bar.MagicHealth.Health.Bar.Size.X == UDim.new(1, 0) and not character2:FindFirstChildWhichIsA("ForceField") then
                                if not flag7 then
                                        if flag4 then
                                                flag4 = false
                                        end

                                        fn19()
                                        flag7 = true

                                        task.spawn(function()
                                                local now2 = tick()

                                                while true do
                                                        pcall(function()
                                                                localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(150, -10000, 32)
                                                        end)

                                                        RunService.RenderStepped:Wait()
                                                        if not (tick() - now2 >= 1 or not flag7) then
                                                                continue
                                                        end
                                                        break
                                                end
                                        end)

                                        task.wait(0.5)
                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)
                                        task.wait(0.001)
                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.G, false, game)
                                        flag7 = false
                                end

                                return
                        end

                        if character2:GetAttribute("Ulted") then
                                flag6 = true
                                flag4 = false
                                return
                        end

                        flag6 = false
                        if flag8 then
                                return
                        end

                        if not character then
                                if flag4 then
                                        flag4 = false
                                end

                                fn19()
                                v2 = fn7()
                                return
                        end

                        if character:GetAttribute("Ulted") or character:FindFirstChild("Counter") then
                                if flag4 then
                                        flag4 = false
                                end

                                fn19()
                                v2 = fn7()
                                return
                        end

                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
                        local humanoid2 = character2:FindFirstChildOfClass("Humanoid")

                        if not humanoidRootPart or not humanoid or not humanoidRootPart2 or not humanoid2 then
                                if flag4 then
                                        flag4 = false
                                end

                                fn19()
                                v2 = fn7()
                                return
                        end

                        if character:FindFirstChild("AbsoluteImmortal") then
                                if humanoid.Health <= 20 then
                                        fn19()
                                        v2 = fn7()
                                        return
                                end

                                if not now then
                                        now = tick()
                                elseif tick() - now >= 5 or character:FindFirstChildOfClass("Humanoid") and character.Humanoid.Health <= 10 then
                                        now = nil

                                        if flag4 then
                                                flag4 = false
                                        end

                                        fn19()
                                        v2 = fn7()
                                        return
                                end
                        end

                        if humanoid.Health <= 0 then
                                if flag4 then
                                        flag4 = false
                                end

                                fn19()
                                v2 = fn7()
                                return
                        end

                        local torso = character:FindFirstChild("Torso")

                        if not torso or torso.Transparency == 1 then
                                if flag4 then
                                        flag4 = false
                                end

                                fn19()
                                v2 = fn7()
                                return
                        end

                        if not flag4 then
                                print("[Project Tofa] Targeting: " .. v2.Name)
                                flag4 = true
                                humanoid2.AutoRotate = false
                        end

                        humanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
                        humanoidRootPart2.AssemblyAngularVelocity = Vector3.zero

                        if currentCamera then
                                character2:SetAttribute("NoHeadLerp", true)
                                currentCamera.CameraSubject = humanoid
                        end

                        if not getgenv().desync then
                                humanoidRootPart2.CFrame = fn21(humanoidRootPart, 0, 5)
                                cFrame = humanoidRootPart2.CFrame
                        else
                                cFrame = fn21(humanoidRootPart, 0, 5)
                        end

                        if sethiddenproperty then
                                sethiddenproperty(humanoidRootPart2, "PhysicsRepRootPart", humanoidRootPart)
                        end
                end)
        end

        local function fn23()
                local VirtualUser = game:GetService("VirtualUser")

                localPlayer.Idled:Connect(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                end)
        end

        task.spawn(function()
                while true do
                        local character = localPlayer.Character
                        local attribute = character and character:GetAttribute("Character")
                        character = character and character:FindFirstChild("Communicate")

                        if character and attribute ~= "Purple" then
                                pcall(character.FireServer, character, { Goal = "Change Character", Character = "Purple" })
                        end

                        task.wait(1)
                end
        end)

        task.spawn(function()
                local thrown = workspace:FindFirstChild("Thrown")

                if thrown then
                        for _, child in pairs(thrown:GetChildren()) do
                                if child.Name:lower():find("debris") or child.Name:lower() == "part" then
                                        task.spawn(pcall, _deleteNew, child)
                                end
                        end

                        thrown.ChildAdded:Connect(function(child)
                                if child.Name:lower():find("debris") or child.Name:lower() == "part" then
                                        task.spawn(pcall, _deleteNew, child)
                                end
                        end)
                end
        end)

        task.wait(1)
        fn20()
        fn22()
        fn23()
end

task.spawn(function()
        task.wait(1)

        while true do
                if v.webhookUrl then
                        pcall(fn6)
                        task.wait(300)
                end
        end
end)

task.spawn(function()
        while true do
                if getgenv().desync then
                        local now = tick()

                        repeat
                                task.wait()
                        until tick() - now >= 20 or not getgenv().desync

                        getgenv().desync = nil
                end

                RunService.RenderStepped:Wait()
        end
end)

task.spawn(function()
        while task.wait(0.25) do
                local character = localPlayer.Character
                local communicate = character and character:FindFirstChild("Communicate")

                if communicate then
                        pcall(communicate.FireServer, communicate, { Goal = "Emote Spin" })
                end
        end
end)

task.spawn(function()
        while true do
                if (#Players:GetPlayers() <= 7 or n8 >= 7) and not flag6 and not flag8 then
                        doHopServer()
                end

                task.wait(1)
        end
end)
