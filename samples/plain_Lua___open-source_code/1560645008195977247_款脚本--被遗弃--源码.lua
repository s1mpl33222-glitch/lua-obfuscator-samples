local LoaderEnvironment = (type(getgenv) == "function" and getgenv()) or _G
local LoaderGuard = LoaderEnvironment.__KRGuard

local function GuardLoader(stage)
    if LoaderEnvironment.__KRLoaderBlocked == true then
        error("loader_stopped", 0)
    end
    if type(LoaderGuard) == "function" then
        LoaderGuard(stage)
    end
end

local function GuardedHttpGet(url)
    GuardLoader("main_http_before")
    local body = game:HttpGet(url)
    GuardLoader("main_http_after")
    return body
end

local function GuardedRequest(options)
    GuardLoader("main_request_before")
    local requestFunction =
        (type(syn) == "table" and syn.request)
        or (type(fluxus) == "table" and fluxus.request)
        or (type(http) == "table" and http.request)
        or request
        or http_request

    if type(requestFunction) ~= "function" then
        error("request_unavailable", 0)
    end

    local response = requestFunction(options)
    GuardLoader("main_request_after")
    return response
end

local function GuardedCompile(source)
    if type(source) ~= "string" or source == "" then
        error("remote_source_invalid", 0)
    end

    GuardLoader("main_compile_before")
    local chunk = loadstring(source)
    source = nil
    GuardLoader("main_compile_after")

    if type(chunk) ~= "function" then
        error("remote_compile_failed", 0)
    end
    return chunk
end

local function LoadRemote(url)
    local body = GuardedHttpGet(url)
    local chunk = GuardedCompile(body)
    body = nil
    GuardLoader("main_execute_before")
    local result = chunk()
    GuardLoader("main_execute_after")
    return result
end

local function LoadRemoteRequest(options)
    local response = GuardedRequest(options)
    local body = type(response) == "table" and (response.Body or response.body) or nil
    local chunk = GuardedCompile(body)
    body = nil
    GuardLoader("main_execute_before")
    local result = chunk()
    GuardLoader("main_execute_after")
    return result
end

local success, library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/fgyhxrtm-ship-it/gghv/refs/heads/main/UI%20(1).lua"))()
end)

if not success then
    print("欢迎使用")  
    return
end

local function readWhitelistState()
    local environment = nil

    if type(getgenv) == "function" then
        local ok, result = pcall(getgenv)
        if ok and type(result) == "table" then
            environment = result
        end
    end

    local environmentAllowed = environment ~= nil and (
        rawget(environment, "isWhitelisted") == true
        or rawget(environment, "IsWhitelisted") == true
    )

    local globalAllowed = type(_G) == "table" and (
        rawget(_G, "isWhitelisted") == true
        or rawget(_G, "IsWhitelisted") == true
    )

    return environmentAllowed or globalAllowed
end

local isAuth = readWhitelistState()
local isLocked = not isAuth
local lockTitle = "付费功能 - 需要购买"

local Window = library:CreateWindow({
    Name = "款脚本",
    SubName = "欢迎使用此脚本",
    Keybind = Enum.KeyCode.RightShift,
    Logo = 83701039519151,
    Theme = "Dark"
})

Window.CurrentConfig = "None"

Window:TabDivider()

Window:CreateHomeTab({
    Name = "信息",
    Logo = "83701039519151",
    DiscordInvite = "",
    SupportedExecutors = { "Delta", "Synapse X", "Krnl", "Codex", "Arceus X" },
    UnsupportedExecutors = { "Roblox Studio" },
    Segments = {
        Details = { Text = "取消", Icon = "no" },
        Script = { Text = "更新日志", Icon = "no" },
    },
    Changelog = {
        { Title = "4.0版本", Description = "推出了被遗弃脚本😍， Ui界面优化🥰，添加了新的测试人员😛" },
    },
})

local FengYu = Window:Tab("内部人员", "83701039519151")

local Feng = FengYu:Section({
    Name = "开发人员",
    SubName = "款脚本团队",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

Feng:Video({
    Video = "rbxassetid://5608337069",
    Name = "视频哦",
    AutoPlay = true,
    Looped = true,
    Volume = 0.5,
    AspectRatio = "16:9",
    Radius = 8,
})

Feng:Social({
    Name = "款脚本创始人",
    SubName = "若白",
    SmlName = "QQ",
    copy = "2838596061",
    Cbn = "复制",
    Logo = "rbxassetid://133726756673211"
})

Feng:Social({ Name = "款脚本创始人", SubName = "若白", SmlName = "QQ", copy = "2838596061", Cbn = "复制", Logo = "rbxassetid://133726756673211" })
Feng:Social({ Name = "测试人员", SubName = " Pizza", SmlName = " QQ", copy = "3911763723", Cbn = "复制", Logo = "rbxassetid://74321980638899" })
Feng:Social({ Name = "测试人员", SubName = "菜鸟", SmlName = "快手号", copy = "4358864292", Cbn = "复制", Logo = "rbxassetid://101841794686409" })
Feng:Social({ Name = "测试人员", SubName = "noob", SmlName = " QQ", copy = "1289069071", Cbn = "复制", Logo = "rbxassetid://97440914928707" })
Feng:Social({ Name = "测试人员", SubName = "耄耋", SmlName = " 快手号", copy = "1420771195", Cbn = "复制", Logo = "rbxassetid://80607128221856" })
Feng:Social({ Name = "测试人员", SubName = "noob45", SmlName = " QQ", copy = "3295626426", Cbn = "复制", Logo = "rbxassetid://118907524255142" })
Feng:Social({ Name = "测试人员", SubName = "纾苇", SmlName = " QQ", copy = "3528796314", Cbn = "复制", Logo = "rbxassetid://77935840039458" })
Feng:Social({ Name = "测试人员", SubName = "嵩", SmlName = " QQ", copy = "3629335696", Cbn = "复制", Logo = "rbxassetid://71291793625126" })
Feng:Social({ Name = "测试人员", SubName = "林木", SmlName = " QQ", copy = "234667395", Cbn = "复制", Logo = "rbxassetid://93085584819970" })
Feng:Social({ Name = "款脚本前作者", SubName = "付款", SmlName = "QQ", copy = "1973873103", Cbn = "复制", Logo = "rbxassetid://81807176674671" })
Feng:Social({ Name = "款脚本群", SubName = "款脚本", SmlName = "QQ群", copy = "1056676792", Cbn = "复制", Logo = "rbxassetid://83701039519151" })
Feng:Social({ Name = "殺脚本作者(思师)", SubName = "风御 X", SmlName = "QQ", copy = "1926190957", Cbn = "复制", Logo = "rbxassetid://70554553650974" })
Feng:Social({ Name = "殺脚本群", SubName = "殺脚本", SmlName = "QQ群", copy = "958022428", Cbn = "复制", Logo = "rbxassetid://84830962019412" })

Window:TabDivider()

local FengYu = Window:Tab("服务器", "83701039519151")

local Feng = FengYu:Section({
    Name = "选择服务器",
    SubName = "你需要的服务器",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

Feng:Button({
    Name = "浏览器",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")

        local serverBrowserGui = Instance.new("ScreenGui")
        serverBrowserGui.Name = "ServerBrowserGui"
        serverBrowserGui.Parent = game.CoreGui

        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 400, 0, 300)
        mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        mainFrame.Parent = serverBrowserGui

        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 30)
        titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        titleBar.BorderSizePixel = 0
        titleBar.Parent = mainFrame

        local titleText = Instance.new("TextLabel")
        titleText.Size = UDim2.new(1, -30, 1, 0)
        titleText.Position = UDim2.new(0, 10, 0, 0)
        titleText.BackgroundTransparency = 1
        titleText.Text = "浏览器"
        titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleText.TextSize = 16
        titleText.Font = Enum.Font.SourceSansBold
        titleText.TextXAlignment = Enum.TextXAlignment.Left
        titleText.Parent = titleBar

        local closeButton = Instance.new("TextButton")
        closeButton.Size = UDim2.new(0, 20, 0, 20)
        closeButton.Position = UDim2.new(1, -25, 0, 5)
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeButton.Text = "X"
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeButton.Font = Enum.Font.SourceSansBold
        closeButton.TextSize = 14
        closeButton.Parent = titleBar

        local serverList = Instance.new("ScrollingFrame")
        serverList.Size = UDim2.new(1, -20, 1, -80)
        serverList.Position = UDim2.new(0, 10, 0, 40)
        serverList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        serverList.BorderSizePixel = 0
        serverList.ScrollBarThickness = 6
        serverList.CanvasSize = UDim2.new(0, 0, 0, 0)
        serverList.Parent = mainFrame

        local refreshButton = Instance.new("TextButton")
        refreshButton.Size = UDim2.new(0, 100, 0, 30)
        refreshButton.Position = UDim2.new(0, 10, 1, -35)
        refreshButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
        refreshButton.Text = "刷新"
        refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        refreshButton.Font = Enum.Font.SourceSansBold
        refreshButton.TextSize = 14
        refreshButton.Parent = mainFrame

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(0, 280, 0, 30)
        statusLabel.Position = UDim2.new(0, 120, 1, -35)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = "准备就绪"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        statusLabel.TextSize = 14
        statusLabel.Font = Enum.Font.SourceSans
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        statusLabel.Parent = mainFrame

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = serverList
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)

        local function createServerButton(serverInfo, index)
            local serverButton = Instance.new("Frame")
            serverButton.Size = UDim2.new(1, -10, 0, 50)
            serverButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            serverButton.BorderSizePixel = 0

            local playerCount = Instance.new("TextLabel")
            playerCount.Size = UDim2.new(0, 80, 1, 0)
            playerCount.BackgroundTransparency = 1
            playerCount.Text = serverInfo.playing .. "/" .. serverInfo.maxPlayers
            playerCount.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerCount.TextSize = 14
            playerCount.Font = Enum.Font.SourceSans
            playerCount.Parent = serverButton

            local idLabel = Instance.new("TextLabel")
            idLabel.Size = UDim2.new(0, 200, 0, 20)
            idLabel.Position = UDim2.new(0, 90, 0, 25)
            idLabel.BackgroundTransparency = 1
            idLabel.Text = "ID: " .. serverInfo.id
            idLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            idLabel.TextSize = 12
            idLabel.Font = Enum.Font.SourceSans
            idLabel.TextXAlignment = Enum.TextXAlignment.Left
            idLabel.Parent = serverButton

            local joinButton = Instance.new("TextButton")
            joinButton.Size = UDim2.new(0, 60, 0, 25)
            joinButton.Position = UDim2.new(1, -70, 0.5, -12.5)
            joinButton.BackgroundColor3 = Color3.fromRGB(70, 150, 70)
            joinButton.Text = "加入"
            joinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            joinButton.Font = Enum.Font.SourceSansBold
            joinButton.TextSize = 14
            joinButton.Parent = serverButton

            joinButton.MouseButton1Click:Connect(function()
                statusLabel.Text = "正在加入服务器..."
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverInfo.id)
            end)

            return serverButton
        end

        local function fetchServers()
            statusLabel.Text = "正在获取服务器..."
            for _, child in pairs(serverList:GetChildren()) do
                if child:IsA("Frame") then child:Destroy() end
            end

            local ok, result = pcall(function()
                return HttpService:JSONDecode(GuardedHttpGet(
                    "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
                ))
            end)

            if ok and result and result.data then
                for i, server in ipairs(result.data) do
                    local btn = createServerButton({
                        id = server.id,
                        playing = server.playing,
                        maxPlayers = server.maxPlayers,
                    }, i)
                    btn.Parent = serverList
                end
                serverList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                statusLabel.Text = "找到 " .. #result.data .. " 个服务器"
            else
                statusLabel.Text = "获取服务器失败"
            end
        end

        refreshButton.MouseButton1Click:Connect(fetchServers)
        closeButton.MouseButton1Click:Connect(function()
            serverBrowserGui:Destroy()
        end)
        fetchServers()
    end
})

Feng:Button({
    Name = "重新加入服务器",
    Callback = function()
        pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end)
    end
})

Feng:Button({
    Name = "加入延迟低服",
    Callback = function()
        local function findRandomServer()
            local ok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(
                    GuardedHttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                )
            end)
            if ok and data and data.data then
                local available = {}
                for _, srv in ipairs(data.data) do
                    if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                        table.insert(available, srv)
                    end
                end
                if #available > 0 then
                    return available[math.random(1, #available)].id
                end
            end
            return nil
        end
        local serverId = findRandomServer()
        if serverId then
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
            end)
        end
    end
})

Feng:Button({
    Name = "加入新手服",
    Callback = function()
        local function findSmallerServer()
            local ok, data = pcall(function()
                return game:GetService("HttpService"):JSONDecode(
                    GuardedHttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
                )
            end)
            if ok and data and data.data then
                table.sort(data.data, function(a, b) return a.playing < b.playing end)
                local currentPlayers = #game.Players:GetPlayers()
                for _, srv in ipairs(data.data) do
                    if srv.playing < currentPlayers and srv.id ~= game.JobId and srv.playing > 0 then
                        return srv.id
                    end
                end
                for _, srv in ipairs(data.data) do
                    if srv.id ~= game.JobId and srv.playing > 0 then
                        return srv.id
                    end
                end
            end
            return nil
        end
        local serverId = findSmallerServer()
        if serverId then
            pcall(function()
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverId, game.Players.LocalPlayer)
            end)
        end
    end
})

Window:TabDivider()
local FengYu = Window:Tab("通用", "83701039519151")

local Feng = FengYu:Section({
    Name = "通用功能",
    SubName = "修改",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local localPlayer = game:GetService("Players").LocalPlayer

    Feng:Button({
        Name = "自杀",
        Callback = function()
            local char = localPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    })
end

do
    local localPlayer = game:GetService("Players").LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local Ragdolls = require(
        ReplicatedStorage:WaitForChild("Modules")
            :WaitForChild("Rendering")
            :WaitForChild("Ragdolls")
    )

    local function RagdollEnable()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not hum then return end
        hum.PlatformStand = true
        Ragdolls.EnableRagdoll(char)
    end

    local function RagdollDisable()
        local char = localPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if not hum then return end
        hum.PlatformStand = false
        Ragdolls.DisableRagdoll(char)
    end

    localPlayer.CharacterAdded:Connect(function()
        RagdollDisable()
    end)

    Feng:Toggle({
        Name = "布娃娃",
        Value = false,
        Callback = function(state)
            if state then RagdollEnable() else RagdollDisable() end
        end
    })
end

Feng:Button({
    Name = "翻译过的Dex",
    Callback = function()
        LoadRemote("https://gitee.com/cmbhbh/cmbh/raw/master/Bex.lua")
    end
})

do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local InvisEnabled = false
    local OriginalSerialize = nil
    local HookedSerialize = nil

    local ok, CharRepl = pcall(function()
        return require(
            ReplicatedStorage:WaitForChild("Systems")
                :WaitForChild("Player")
                :WaitForChild("Game")
                :WaitForChild("CharacterReplication")
        )
    end)

    if ok and CharRepl and CharRepl.Serialize then
        OriginalSerialize = CharRepl.Serialize
        HookedSerialize = hookfunction(OriginalSerialize, newcclosure(function(...)
            if not InvisEnabled then return HookedSerialize(...) end
            local args = { ... }
            if typeof(args[1]) ~= "CFrame" then return HookedSerialize(...) end
            if typeof(args[2]) ~= "Vector3" then return HookedSerialize(...) end
            return HookedSerialize(args[1], args[2] + Vector3.new(0, 5000, 0))
        end))
    end

    Feng:Toggle({
        Name = "隐身",
        Value = false,
        Callback = function(value)
            InvisEnabled = value
            if HookedSerialize and not value and OriginalSerialize then
                restorefunction(OriginalSerialize)
                HookedSerialize = hookfunction(OriginalSerialize, newcclosure(function(...)
                    if not InvisEnabled then return HookedSerialize(...) end
                    local args = { ... }
                    if typeof(args[1]) ~= "CFrame" then return HookedSerialize(...) end
                    if typeof(args[2]) ~= "Vector3" then return HookedSerialize(...) end
                    return HookedSerialize(args[1], args[2] + Vector3.new(0, 5000, 0))
                end))
            end
        end
    })
end

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local localPlayer = Players.LocalPlayer

    local sidebarVisibilityEnabled = false
    local sidebarHandler
    local playerInfo

    task.spawn(function()
        local ok, module = pcall(function()
            return require(
                ReplicatedStorage:WaitForChild("Systems")
                    :WaitForChild("Player")
                    :WaitForChild("UI")
                    :WaitForChild("SidebarHandler")
            )
        end)
        if ok then sidebarHandler = module end
    end)

    task.spawn(function()
        while localPlayer do
            local playerGui = localPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                local tempUI = playerGui:FindFirstChild("TemporaryUI")
                if tempUI then
                    local info = tempUI:FindFirstChild("PlayerInfo")
                    if info then playerInfo = info end
                    if not tempUI:GetAttribute("CatsakenSidebarHook") then
                        tempUI:SetAttribute("CatsakenSidebarHook", true)
                        tempUI.ChildAdded:Connect(function(child)
                            if child.Name == "PlayerInfo" then playerInfo = child end
                        end)
                    end
                end
            end
            task.wait(0.5)
        end
    end)

    task.spawn(function()
        while task.wait() do
            if sidebarVisibilityEnabled and sidebarHandler then
                if sidebarHandler.MenusHidden then
                    if playerInfo then
                        playerInfo.Position = UDim2.new(0, 100, 1, -70)
                    end
                    pcall(function() sidebarHandler:ToggleSidebarButtons(true) end)
                end
            end
        end
    end)

    Feng:Toggle({
        Name = "显示侧边栏",
        Value = false,
        Callback = function(value)
            sidebarVisibilityEnabled = value
            if not value then
                if playerInfo then
                    playerInfo.Position = UDim2.new(0, 20, 1, -20)
                end
                if sidebarHandler then
                    pcall(function() sidebarHandler:ToggleSidebarButtons(false) end)
                end
            end
        end
    })
end

do
    local antiBlindFreezeEnabled = false

    game:GetService("RunService").RenderStepped:Connect(function()
        if antiBlindFreezeEnabled then
            local Lighting = game:GetService("Lighting")
            for _, effect in pairs(Lighting:GetChildren()) do
                if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                    effect.Enabled = false
                end
            end
            local camera = workspace.CurrentCamera
            if camera then
                for _, effect in pairs(camera:GetChildren()) do
                    if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") then
                        effect.Enabled = false
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait() do
            if antiBlindFreezeEnabled then
                pcall(function()
                    local playersFolder = workspace:FindFirstChild("Players")
                    if playersFolder then
                        local killersFolder = playersFolder:FindFirstChild("Killers")
                        if killersFolder then
                            for _, killerModel in ipairs(killersFolder:GetChildren()) do
                                local speedMults = killerModel:FindFirstChild("SpeedMultipliers")
                                if speedMults then
                                    local stun = speedMults:FindFirstChild("Stunned")
                                    if stun then stun.Value = 1 end
                                end
                            end
                        end
                        local survivorsFolder = playersFolder:FindFirstChild("Survivors")
                        if survivorsFolder then
                            for _, survModel in ipairs(survivorsFolder:GetChildren()) do
                                local speedMults = survModel:FindFirstChild("SpeedMultipliers")
                                if speedMults then
                                    local stun = speedMults:FindFirstChild("Stunned")
                                    if stun then stun.Value = 1 end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    Feng:Toggle({
        Name = "防眩晕",
        Value = false,
        Callback = function(value) antiBlindFreezeEnabled = value end
    })
end

do
    local speedBoostEnabled = false
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    Feng:Toggle({
        Name = "速度提升",
        Value = false,
        Callback = function(value)
            speedBoostEnabled = value
            if value then
                task.spawn(function()
                    while speedBoostEnabled do
                        local char = localPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChildOfClass("Humanoid")
                        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                            hrp:TranslateBy(hum.MoveDirection * 7 * RunService.RenderStepped:Wait())
                        else
                            RunService.RenderStepped:Wait()
                        end
                    end
                end)
            end
        end
    })
end

do
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local TimerPos = { side = "Middle" }

    local function applyTimerPos()
        local rt = localPlayer.PlayerGui:FindFirstChild("RoundTimer")
        local m = rt and rt:FindFirstChild("Main")
        if not m then return end
        local x = (TimerPos.side == "Middle") and 0.5 or 0.9
        m.Position = UDim2.new(x, 0, m.Position.Y.Scale, m.Position.Y.Offset)
    end

    applyTimerPos()
    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyTimerPos()
    end)

    Feng:Dropdown({
        Name = "计时器",
        Values = { "中间", "右侧" },
        Value = "中间",
        Callback = function(selected)
            TimerPos.side = (selected == "中间") and "Middle" or "Right"
            applyTimerPos()
        end
    })
end

do
    local TextChatService = game:GetService("TextChatService")

    local function setChatVisible(v)
        local cfg = TextChatService:FindFirstChildOfClass("ChatWindowConfiguration")
        if cfg then cfg.Enabled = v end
    end

    Feng:Toggle({
        Name = "显示聊天",
        Value = false,
        Callback = function(value) setChatVisible(value) end
    })
end

do
    local Players = game:GetService("Players")

    local Privacy = {
        enabled = false,
        originals = {},
        keys = { "HideKillerWins", "HidePlaytime", "HideSurvivorWins" },
        conn = nil,
    }

    local function getPrivacy(player)
        local pd = player:FindFirstChild("PlayerData")
        local st = pd and pd:FindFirstChild("Settings")
        return st and st:FindFirstChild("Privacy")
    end

    local function saveOriginals(player)
        local privacy = getPrivacy(player)
        if not privacy then return end
        Privacy.originals[player.UserId] = Privacy.originals[player.UserId] or {}
        for _, key in ipairs(Privacy.keys) do
            local v = privacy:FindFirstChild(key)
            if v then Privacy.originals[player.UserId][key] = v.Value end
        end
    end

    local function reveal(player)
        local privacy = getPrivacy(player)
        if not privacy then return end
        for _, key in ipairs(Privacy.keys) do
            local v = privacy:FindFirstChild(key)
            if v then v.Value = false end
        end
    end

    local function restore(player)
        local privacy = getPrivacy(player)
        local saved = Privacy.originals[player.UserId]
        if not privacy or not saved then return end
        for key, val in pairs(saved) do
            local v = privacy:FindFirstChild(key)
            if v then v.Value = val end
        end
    end

    local function applyAll(enable)
        for _, player in ipairs(Players:GetPlayers()) do
            if enable then
                saveOriginals(player)
                reveal(player)
            else
                restore(player)
            end
        end
    end

    Feng:Toggle({
        Name = "看到隐藏",
        Value = false,
        Callback = function(value)
            Privacy.enabled = value
            applyAll(value)
            if value then
                if not Privacy.conn then
                    Privacy.conn = Players.PlayerAdded:Connect(function(player)
                        task.wait(1)
                        if Privacy.enabled then
                            saveOriginals(player)
                            reveal(player)
                        end
                    end)
                end
            else
                if Privacy.conn then
                    Privacy.conn:Disconnect()
                    Privacy.conn = nil
                end
            end
        end
    })
end

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local localPlayer = Players.LocalPlayer

    local Fly = { enabled = false, speed = 50, conn = nil, gyro = nil, vel = nil }

    local function stopFly()
        if Fly.conn then Fly.conn:Disconnect() Fly.conn = nil end
        if Fly.gyro then Fly.gyro:Destroy() Fly.gyro = nil end
        if Fly.vel then Fly.vel:Destroy() Fly.vel = nil end
        local char = localPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end

    local function startFly()
        local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local root = char:WaitForChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum.AutoRotate = false
        Fly.gyro = Instance.new("BodyGyro")
        Fly.gyro.P = 30000
        Fly.gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        Fly.gyro.CFrame = root.CFrame
        Fly.gyro.Parent = root
        Fly.vel = Instance.new("BodyVelocity")
        Fly.vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        Fly.vel.Velocity = Vector3.zero
        Fly.vel.Parent = root
        Fly.conn = RunService.Heartbeat:Connect(function()
            local cam = workspace.CurrentCamera
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local move = hum.MoveDirection
            local forwardAmt = move:Dot(Vector3.new(look.X, 0, look.Z).Unit)
            local rightAmt = move:Dot(Vector3.new(right.X, 0, right.Z).Unit)
            local upAmt = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then upAmt = 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then upAmt = -1 end
            local velocity = look * forwardAmt + right * rightAmt + Vector3.new(0, upAmt, 0)
            if velocity.Magnitude > 1 then velocity = velocity.Unit end
            Fly.vel.Velocity = velocity * Fly.speed
            Fly.gyro.CFrame = CFrame.lookAt(root.Position, root.Position + look, cam.CFrame.UpVector)
        end)
    end

    Feng:Toggle({
        Name = "飞行",
        Value = false,
        Callback = function(value)
            Fly.enabled = value
            if value then startFly() else stopFly() end
        end
    })

    Feng:Slider({
        Name = "飞行速度",
        Value = { Min = 5, Max = 150, Default = 50 },
        Callback = function(value) Fly.speed = value end
    })
end

local Feng = FengYu:Section({
    Name = "保存点",
    SubName = "标记位置并传送",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    local FOLDER_NAME = Window.RootFolder or "DoomsenseForsaken"
    local WAYPOINTS_FILE = FOLDER_NAME .. "/Waypoints.json"

    pcall(function()
        if isfolder and makefolder and not isfolder(FOLDER_NAME) then
            makefolder(FOLDER_NAME)
        end
    end)

    local Waypoints = {}
    local wpDropdownObj = nil
    local WP_Name_Value = ""
    local WP_Selected_Val = nil

    local function GetRoot(char)
        if not char or typeof(char) ~= "Instance" then return nil end
        return char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char.PrimaryPart
    end

    local function SaveWaypoints()
        pcall(function()
            local data = {}
            for name, cf in pairs(Waypoints) do
                data[name] = { cf:GetComponents() }
            end
            writefile(WAYPOINTS_FILE, HttpService:JSONEncode(data))
        end)
    end

    local function LoadWaypoints()
        pcall(function()
            if isfile and isfile(WAYPOINTS_FILE) then
                local data = HttpService:JSONDecode(readfile(WAYPOINTS_FILE))
                if data then
                    for name, comps in pairs(data) do
                        if type(comps) == "table" and #comps == 12 then
                            Waypoints[name] = CFrame.new(unpack(comps))
                        end
                    end
                end
            end
        end)
    end

    LoadWaypoints()

    local function GetWaypointsList()
        local list = {}
        for name, _ in pairs(Waypoints) do table.insert(list, name) end
        table.sort(list)
        if #list == 0 then table.insert(list, "") end
        return list
    end

    local function RefreshWPList()
        if wpDropdownObj then
            pcall(function() wpDropdownObj.Refresh(GetWaypointsList()) end)
        end
    end

    Feng:Textbox({
        Name = "路径点名称",
        Placeholder = "输入路径点名称",
        Callback = function(val) WP_Name_Value = tostring(val or "") end
    })

    wpDropdownObj = Feng:Dropdown({
        Name = "已保存路径点",
        Options = GetWaypointsList(),
        Callback = function(val) WP_Selected_Val = val end
    })

    Feng:Button({
        Name = "保存位置",
        Callback = function()
            local name = tostring(WP_Name_Value or "")
            if name == "" then return end
            local root = GetRoot(LocalPlayer.Character)
            if root then
                Waypoints[name] = root.CFrame
                SaveWaypoints()
                RefreshWPList()
                WP_Selected_Val = name
            end
        end
    })

    Feng:Button({
        Name = "传送到该点",
        Callback = function()
            local name = WP_Selected_Val
            if not name or name == "" or not Waypoints[name] then return end
            local root = GetRoot(LocalPlayer.Character)
            if root then root.CFrame = Waypoints[name] end
        end
    })

    Feng:Button({
        Name = "删除该点",
        Callback = function()
            local name = WP_Selected_Val
            if not name or name == "" or not Waypoints[name] then return end
            Waypoints[name] = nil
            SaveWaypoints()
            WP_Selected_Val = nil
            RefreshWPList()
        end
    })

    RefreshWPList()
end

local Feng = FengYu:Section({
    Name = "场景设置",
    SubName = "地图上的视觉效果",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local _env = { Brightness = 0, GlobalShadows = false, NoFog = false, Fullbright = false }

    if not game.Lighting:GetAttribute("FogStart") then
        game.Lighting:SetAttribute("FogStart", game.Lighting.FogStart)
    end
    if not game.Lighting:GetAttribute("FogEnd") then
        game.Lighting:SetAttribute("FogEnd", game.Lighting.FogEnd)
    end

    local originalFogDensity = nil
    local fog = game.Lighting:FindFirstChildOfClass("Atmosphere")
    if fog and not fog:GetAttribute("Density") then
        fog:SetAttribute("Density", fog.Density)
        originalFogDensity = fog.Density
    end

    local lightingConnection = nil

    local function updateLighting()
        game.Lighting.FogStart = _env.NoFog and 0 or game.Lighting:GetAttribute("FogStart")
        game.Lighting.FogEnd = _env.NoFog and math.huge or game.Lighting:GetAttribute("FogEnd")
        local fog = game.Lighting:FindFirstChildOfClass("Atmosphere")
        if fog then
            if not fog:GetAttribute("Density") then
                fog:SetAttribute("Density", fog.Density)
            end
            fog.Density = _env.NoFog and 0 or fog:GetAttribute("Density")
        end
        if _env.Fullbright then
            game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            game.Lighting.Brightness = _env.Brightness or 0
            game.Lighting.GlobalShadows = not _env.GlobalShadows
        else
            game.Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 55)
            game.Lighting.Brightness = 0
            game.Lighting.GlobalShadows = true
        end
    end

    local function toggleLightingLoop(enabled)
        if enabled then
            if lightingConnection then lightingConnection:Disconnect() end
            lightingConnection = game:GetService("RunService").RenderStepped:Connect(updateLighting)
        else
            if lightingConnection then
                lightingConnection:Disconnect()
                lightingConnection = nil
            end
            game.Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 55)
            game.Lighting.Brightness = 0
            game.Lighting.GlobalShadows = true
            game.Lighting.FogStart = game.Lighting:GetAttribute("FogStart") or 0
            game.Lighting.FogEnd = game.Lighting:GetAttribute("FogEnd") or math.huge
            if fog then
                fog.Density = fog:GetAttribute("Density") or originalFogDensity
            end
        end
    end

    Feng:Slider({
        Name = "亮度修改",
        Value = { Min = 0, Max = 3, Default = 0 },
        Callback = function(value) _env.Brightness = value end
    })

    Feng:Toggle({
        Name = "除阴影",
        Value = false,
        Callback = function(state) _env.GlobalShadows = state end
    })

    Feng:Toggle({
        Name = "除雾",
        Value = false,
        Callback = function(state) _env.NoFog = state end
    })

    Feng:Toggle({
        Name = "亮度开关",
        Value = false,
        Callback = function(state)
            _env.Fullbright = state
            toggleLightingLoop(state)
        end
    })
end

local FengYu = Window:Tab("渲染", "83701039519151")

local Feng = FengYu:Section({
    Name = "碰撞材质",
    SubName = "直接变板砖🤓",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local HitboxVisual = {
        Enabled = false,
        Material = "Plastic",
        Color = Color3.fromRGB(255, 64, 64),
        HitColor = Color3.fromRGB(128, 255, 128),
        Transparency = 1,
        HitTransparency = 1,
    }

    Feng:Toggle({
        Name = "启用可视化修改",
        Value = false,
        Callback = function(v) HitboxVisual.Enabled = v end
    })

    local materialList = {}
    for _, m in ipairs(Enum.Material:GetEnumItems()) do
        materialList[#materialList + 1] = tostring(m):split(".")[3]
    end
    table.sort(materialList)

    Feng:Dropdown({
        Name = "材质",
        Values = materialList,
        Value = "Plastic",
        Callback = function(v) HitboxVisual.Material = v end
    })

    Feng:Colorpicker({
        Name = "碰撞箱颜色",
        Default = HitboxVisual.Color,
        Transparency = 0.2,
        Callback = function(color) HitboxVisual.Color = color end
    })

    Feng:Colorpicker({
        Name = "碰撞箱颜色 (命中)",
        Default = HitboxVisual.HitColor,
        Transparency = 0.2,
        Callback = function(color) HitboxVisual.HitColor = color end
    })

    Feng:Slider({
        Name = "碰撞箱透明度",
        Value = { Min = 0, Max = 1, Default = 1 },
        Rounding = 2,
        Callback = function(v) HitboxVisual.Transparency = v end
    })

    Feng:Slider({
        Name = "碰撞箱透明度 (命中)",
        Value = { Min = 0, Max = 1, Default = 1 },
        Rounding = 2,
        Callback = function(v) HitboxVisual.HitTransparency = v end
    })

    task.spawn(function()
        local hitboxesFolder = workspace:WaitForChild("Hitboxes", 30)
        if not hitboxesFolder then return end
        hitboxesFolder.ChildAdded:Connect(function(part)
            if not HitboxVisual.Enabled then return end
            local mat = Enum.Material[HitboxVisual.Material]
            local originColor = part.Color
            while part and part.Parent do
                part.Material = mat
                if originColor.R ~= 1 then
                    part.Color = HitboxVisual.HitColor
                    part.Transparency = HitboxVisual.HitTransparency
                else
                    part.Color = HitboxVisual.Color
                    part.Transparency = HitboxVisual.Transparency
                end
                task.wait()
            end
        end)
    end)
end

Window:TabDivider()

local FengYu = Window:Tab("体力", "83701039519151")

local Feng = FengYu:Section({
    Name = "体力修改",
    SubName = "黑客速度",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
    {
        Key = "ph",
        Name = "体力设置",
    },
    {
        Key = "vu",
        Name = "兄弟原来是大佬",
    },
})

do
    local originalDefaults = {}
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
    local function GetModule() return require(SprintingModule) end

    local function CaptureDefaults()
        local m = GetModule()
        originalDefaults.MaxStamina = m.MaxStamina
        originalDefaults.StaminaGain = m.StaminaGain
        originalDefaults.StaminaLoss = m.StaminaLoss
        originalDefaults.SprintSpeed = m.SprintSpeed
    end
    CaptureDefaults()

    local StaminaSettings = {
        MaxStamina = 100,
        StaminaGain = 25,
        StaminaLoss = 10,
        SprintSpeed = 28,
        InfiniteGain = 9999
    }

    local SettingToggles = {
        MaxStamina = false,
        StaminaGain = false,
        StaminaLoss = false,
        SprintSpeed = false
    }

    local bai = { Spr = false }
    local connection = nil

    task.spawn(function()
        while true do
            local m = GetModule()
            for key, value in pairs(StaminaSettings) do
                if SettingToggles[key] then m[key] = value end
            end
            task.wait(0.5)
        end
    end)

    Feng.ph:Toggle({
        Name = "无限体力",
        Value = false,
        Callback = function(state)
            bai.Spr = state
            local Sprinting = GetModule()
            if state then
                Sprinting.StaminaLoss = 0
                Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
                if connection then connection:Disconnect() end
                connection = RunService.Heartbeat:Connect(function()
                    if not bai.Spr then return end
                    Sprinting.StaminaLoss = 0
                    Sprinting.StaminaGain = StaminaSettings.InfiniteGain or 9999
                end)
            else
                Sprinting.StaminaLoss = originalDefaults.StaminaLoss
                Sprinting.StaminaGain = originalDefaults.StaminaGain
                if connection then connection:Disconnect() connection = nil end
            end
        end
    })

    Feng.ph:Toggle({
        Name = "启用体力大小",
        Value = false,
        Callback = function(v)
            SettingToggles.MaxStamina = v
            if not v then
                local m = GetModule()
                m.MaxStamina = originalDefaults.MaxStamina
            end
        end
    })

    Feng.ph:Slider({
        Name = "体力大小",
        Value = { Min = 0, Max = 99999, Default = 100 },
        Callback = function(v) StaminaSettings.MaxStamina = v end
    })

    Feng.ph:Toggle({
        Name = "启用体力恢复",
        Value = false,
        Callback = function(v)
            SettingToggles.StaminaGain = v
            if not v then
                local m = GetModule()
                m.StaminaGain = originalDefaults.StaminaGain
            end
        end
    })

    Feng.ph:Slider({
        Name = "体力恢复",
        Value = { Min = 0, Max = 250, Default = 25 },
        Callback = function(v) StaminaSettings.StaminaGain = v end
    })

    Feng.ph:Toggle({
        Name = "启用体力消耗",
        Value = false,
        Callback = function(v)
            SettingToggles.StaminaLoss = v
            if not v then
                local m = GetModule()
                m.StaminaLoss = originalDefaults.StaminaLoss
            end
        end
    })

    Feng.ph:Slider({
        Name = "体力消耗",
        Value = { Min = 0, Max = 100, Default = 10 },
        Callback = function(v) StaminaSettings.StaminaLoss = v end
    })

    Feng.ph:Toggle({
        Name = "启用奔跑速度",
        Value = false,
        Callback = function(v)
            SettingToggles.SprintSpeed = v
            if not v then
                local m = GetModule()
                m.SprintSpeed = originalDefaults.SprintSpeed
            end
        end
    })

    Feng.ph:Slider({
        Name = "奔跑速度",
        Value = { Min = 0, Max = 200, Default = 28 },
        Callback = function(v) StaminaSettings.SprintSpeed = v end
    })
end

do
    local LP = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local SprintingModule = ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
    local function GetSprinting() return require(SprintingModule) end

    local function HasAbility(name)
        local playerGui = LP:FindFirstChild("PlayerGui")
        if not playerGui then return false end
        local mainUI = playerGui:FindFirstChild("MainUI")
        if not mainUI then return false end
        local abilityContainer = mainUI:FindFirstChild("AbilityContainer")
        if not abilityContainer then return false end
        return abilityContainer:FindFirstChild(name) ~= nil
    end

    local autoUnsprintEnabled = false
    Feng.vu:Toggle({
        Name = "自动停止冲刺",
        Value = false,
        Callback = function(state)
            autoUnsprintEnabled = state
            if state then
                task.spawn(function()
                    while autoUnsprintEnabled do
                        local sprinting = GetSprinting()
                        if sprinting and sprinting.Stamina < 3 then
                            sprinting.IsSprinting = false
                            if sprinting.__sprintedEvent then
                                sprinting.__sprintedEvent:Fire(false)
                            end
                        end
                        task.wait()
                    end
                end)
            end
        end
    })

    local autoSprintEnabled = false
    Feng.vu:Toggle({
        Name = "始终启用冲刺",
        Value = false,
        Callback = function(state)
            autoSprintEnabled = state
            if state then
                task.spawn(function()
                    while autoSprintEnabled do
                        local sprinting = GetSprinting()
                        if sprinting then
                            if autoUnsprintEnabled and sprinting.Stamina ~= 100 then
                                task.wait()
                                continue
                            end
                            if not sprinting.IsSprinting then
                                sprinting.IsSprinting = true
                                if sprinting.__sprintedEvent then
                                    sprinting.__sprintedEvent:Fire(true)
                                end
                            end
                        end
                        task.wait()
                    end
                end)
            end
        end
    })

    local noSprintTweenEnabled = false
    local hookedNamecall = false
    Feng.vu:Toggle({
        Name = "无冲刺过渡",
        Value = false,
        Callback = function(state)
            noSprintTweenEnabled = state
            if state and not hookedNamecall then
                hookedNamecall = true
                local oldNamecall
                oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                    local method = getnamecallmethod()
                    if noSprintTweenEnabled and not checkcaller() and self == TweenService and method == "Create" then
                        local args = {...}
                        local sprinting = GetSprinting()
                        if sprinting and args[1] == sprinting.__speedMultiplier then
                            args[2] = TweenInfo.new(0)
                        end
                        return oldNamecall(self, unpack(args))
                    end
                    return oldNamecall(self, ...)
                end)
            end
        end
    })

    local noSlowdownEnabled = false
    Feng.vu:Toggle({
        Name = "无减速",
        Value = false,
        Callback = function(state)
            noSlowdownEnabled = state
            if state then
                task.spawn(function()
                    while noSlowdownEnabled do
                        local char = LP.Character
                        if char then
                            local speedMultipliers = char:FindFirstChild("SpeedMultipliers")
                            if speedMultipliers then
                                for _, v in ipairs(speedMultipliers:GetChildren()) do
                                    if v:IsA("NumberValue") and not HasAbility(v.Name) and v.Value < 1 then
                                        v.Value = 1
                                    end
                                end
                            end
                        end
                        task.wait()
                    end
                end)
            end
        end
    })

    local noAbilitySlowdownEnabled = false
    Feng.vu:Toggle({
        Name = "无技能减速",
        Value = false,
        Callback = function(state)
            noAbilitySlowdownEnabled = state
            if state then
                task.spawn(function()
                    while noAbilitySlowdownEnabled do
                        local char = LP.Character
                        if char then
                            local speedMultipliers = char:FindFirstChild("SpeedMultipliers")
                            if speedMultipliers then
                                for _, v in ipairs(speedMultipliers:GetChildren()) do
                                    if v:IsA("NumberValue") and HasAbility(v.Name) and v.Value < 1 then
                                        v.Value = 1
                                    end
                                end
                            end
                        end
                        task.wait()
                    end
                end)
            end
        end
    })
end

Window:TabDivider()
local FengYu = Window:Tab("透视区", "83701039519151")

local Feng = FengYu:Section({
    Name = "发电机透视",
    SubName = "透视发电机",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local _Players           = game:GetService("Players")
    local _RunService        = game:GetService("RunService")
    local _Workspace         = game:GetService("Workspace")
    local _ReplicatedStorage = game:GetService("ReplicatedStorage")
    local _LP                = _Players.LocalPlayer

    local GenConfig = {
        Enabled     = false,
        ShowPercent = true,
        ShowDist    = true,
        FilterFakes = true,
        Color       = Color3.fromRGB(0, 200, 255),
    }

    local GenCache       = {}
    local GeneratorsList = {}
    local lastScanTime   = 0
    local activeGens     = {}

    local function GetGeneratorAccurateProgress(genModel)
        if not genModel or not genModel.Parent then return 0 end

        local attr = genModel:GetAttribute("Progress")
            or genModel:GetAttribute("RepairProgress")
            or genModel:GetAttribute("Percent")
            or genModel:GetAttribute("CurrentProgress")
        if attr and type(attr) == "number" then
            return attr <= 1 and math.floor(attr * 100) or math.floor(attr)
        end

        for _, desc in ipairs(genModel:GetDescendants()) do
            if desc:IsA("SurfaceGui") or desc:IsA("BillboardGui") then
                for _, bar in ipairs(desc:GetDescendants()) do
                    if (bar:IsA("Frame") or bar:IsA("ImageLabel"))
                        and bar.Size.X.Scale > 0 and bar.Size.X.Scale <= 1 then
                        if bar.BackgroundColor3.G > 0.5 and bar.BackgroundColor3.R < 0.5 then
                            return math.floor(bar.Size.X.Scale * 100)
                        end
                    end
                end
            end
        end

        local objStorage = _Workspace:FindFirstChild("ObjectiveStorage")
            or _ReplicatedStorage:FindFirstChild("ObjectiveStorage")
        if objStorage then
            local match = objStorage:FindFirstChild(genModel.Name)
            if not match then
                for _, val in ipairs(objStorage:GetChildren()) do
                    if val.Name:find(genModel.Name)
                        or (genModel:GetAttribute("ID")
                            and tostring(val.Name):find(tostring(genModel:GetAttribute("ID")))) then
                        match = val
                        break
                    end
                end
            end
            if match and (match:IsA("IntValue") or match:IsA("NumberValue")) then
                local v = match.Value
                return v <= 1 and math.floor(v * 100) or math.floor(v)
            end
        end

        return 0
    end

    local function UpdateGeneratorsList()
        local genList = {}
        local map = _Workspace:FindFirstChild("Map") and _Workspace.Map:FindFirstChild("Ingame")

        if map then
            for _, obj in ipairs(map:GetDescendants()) do
                if obj:IsA("Model")
                    and (obj.Name == "Generator" or obj.Name:match("^SetupGenerators")) then

                    local isFake = obj:FindFirstChild("FakeGenerator") ~= nil
                        or obj:GetAttribute("Fake") == true
                        or obj.Name:lower():find("fake") ~= nil

                    local pVal = GetGeneratorAccurateProgress(obj)
                    local rootPart = obj:FindFirstChild("Main")
                        or obj.PrimaryPart
                        or obj:FindFirstChildOfClass("BasePart")

                    if rootPart then
                        table.insert(genList, {
                            Model    = obj,
                            Root     = rootPart,
                            IsFake   = isFake,
                            Progress = pVal,
                        })
                    end
                end
            end
        end

        GeneratorsList = genList
    end

    local SafeGuiRoot = (gethui and gethui()) or game:GetService("CoreGui")

    local GenVisualGUI = Instance.new("Folder")
    GenVisualGUI.Name   = "Doomsense_Gen_ESP"
    GenVisualGUI.Parent = SafeGuiRoot

    local function GetCamera()
        return _Workspace.CurrentCamera or _Workspace:FindFirstChildOfClass("Camera")
    end

    _RunService.Heartbeat:Connect(function()
        local cam = GetCamera()
        if not cam then return end

        if not GenConfig.Enabled then
            for _, bg in pairs(GenCache) do
                if bg.Gui then bg.Gui.Enabled = false end
            end
            return
        end

        local now = tick()
        if now - lastScanTime >= 0.5 then
            lastScanTime = now
            UpdateGeneratorsList()
        end

        activeGens = {}

        for _, gen in ipairs(GeneratorsList) do
            if gen.Root and gen.Model and gen.Model.Parent then
                local distStuds = (cam.CFrame.Position - gen.Root.Position).Magnitude
                local bg        = GenCache[gen.Model]

                if GenConfig.FilterFakes and gen.IsFake then
                    if bg then bg.Gui.Enabled = false; bg.Gui.Adornee = nil end
                elseif distStuds <= 800 then
                    activeGens[gen.Model] = true

                    if not bg or not bg.Gui.Parent then
                        local bGui = Instance.new("BillboardGui")
                        bGui.Name            = "Doom_Gen_ESP"
                        bGui.Size            = UDim2.fromOffset(200, 20)
                        bGui.AlwaysOnTop     = true
                        bGui.LightInfluence  = 0
                        bGui.StudsOffset     = Vector3.new(0, 2.0, 0)
                        bGui.Parent          = GenVisualGUI

                        local lbl = Instance.new("TextLabel", bGui)
                        lbl.Size                   = UDim2.fromScale(1, 1)
                        lbl.BackgroundTransparency = 1
                        lbl.Font                   = Enum.Font.GothamBold
                        lbl.TextSize               = 12
                        lbl.TextStrokeTransparency = 0
                        lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)

                        GenCache[gen.Model] = { Gui = bGui, Label = lbl }
                        bg = GenCache[gen.Model]
                    end

                    bg.Gui.Enabled  = true
                    bg.Gui.Adornee  = gen.Root
                    local distM     = math.floor(distStuds / 3.57)

                    local str = gen.IsFake and "[假发电机]" or "发电机"
                    if GenConfig.ShowPercent and not gen.IsFake then
                        str = str .. " [" .. math.floor(gen.Progress) .. "%]"
                    end
                    if GenConfig.ShowDist then
                        str = str .. " • " .. distM .. "m"
                    end

                    bg.Label.Text      = str
                    bg.Label.TextColor3 = gen.IsFake
                        and Color3.fromRGB(255, 50, 50)
                        or  GenConfig.Color
                else
                    if bg then bg.Gui.Enabled = false; bg.Gui.Adornee = nil end
                end
            end
        end

        for model, bg in pairs(GenCache) do
            if not activeGens[model] then
                if bg.Gui then bg.Gui.Enabled = false; bg.Gui.Adornee = nil end
                if not model.Parent then
                    pcall(function() bg.Gui:Destroy() end)
                    GenCache[model] = nil
                end
            end
        end
    end)

    task.spawn(function()
        local lastIngame = nil
        while true do
            task.wait(1)
            local map       = _Workspace:FindFirstChild("Map")
            local curIngame = map and map:FindFirstChild("Ingame")
            if curIngame ~= lastIngame then
                lastIngame = curIngame
                for _, bg in pairs(GenCache) do
                    if bg.Gui then pcall(function() bg.Gui:Destroy() end) end
                end
                table.clear(GenCache)
                GeneratorsList = {}
            end
        end
    end)

    Feng:Toggle({
        Name = "启用发电机透视",
        Value = false,
        Callback = function(v) GenConfig.Enabled = v end
    })

    Feng:Toggle({
        Name = "显示进度 %",
        Value = true,
        Callback = function(v) GenConfig.ShowPercent = v end
    })

    Feng:Toggle({
        Name = "显示距离",
        Value = true,
        Callback = function(v) GenConfig.ShowDist = v end
    })

    Feng:Toggle({
        Name = "过滤假发电机",
        Value = true,
        Callback = function(v) GenConfig.FilterFakes = v end
    })

    Feng:Colorpicker({
        Name = "透视颜色",
        Default = Color3.fromRGB(0, 200, 255),
        Transparency = 0.2,
        Callback = function(color) GenConfig.Color = color end
    })
end

local Feng = FengYu:Section({
    Name = "幸存者透视",
    SubName = "幸存者 Survivor",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
    {
        Key = "ma",
        Name = "透视基本要素",
    },
    {
        Key = "se",
        Name = "透视设置",
    },
})

do
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace  = game:GetService("Workspace")
    local LP         = Players.LocalPlayer

    local Vis = {
        S_Enabled = false,
        S_Style   = {},
        S_Fill    = Color3.fromRGB(40, 255, 120),
        S_Out     = Color3.fromRGB(255, 255, 255),
        S_LF      = 2,
        S_LO      = 0,

        Box_WOffset     = 0,
        Box_HOffset     = 0,
        Tags_GlobalLimp = 0,

        Surv_Box_Tog       = false,
        Surv_Box_Fill      = Color3.fromRGB(40, 255, 120),
        Surv_Box_Out       = Color3.fromRGB(255, 255, 255),
        Surv_Box_Limp_Fill = 4,
        Surv_Box_Limp_Out  = 0,

        Surv_Role_Tog = false, Surv_Role_Dir = "顶部",    Surv_Role_Fill = Color3.fromRGB(60, 255, 120),  Surv_Role_Out = Color3.fromRGB(0, 0, 0), Surv_Role_Limp = 0,
        Surv_Name_Tog = false, Surv_Name_Dir = "顶部",    Surv_Name_Fill = Color3.fromRGB(255, 255, 255), Surv_Name_Out = Color3.fromRGB(0, 0, 0), Surv_Name_Limp = 0,
        Surv_Skin_Tog = false, Surv_Skin_Dir = "顶部",    Surv_Skin_Fill = Color3.fromRGB(150, 255, 200), Surv_Skin_Out = Color3.fromRGB(0, 0, 0), Surv_Skin_Limp = 0,
        Surv_Login_Tog= false, Surv_Login_Dir= "顶部",    Surv_Login_Fill= Color3.fromRGB(200, 200, 200), Surv_Login_Out= Color3.fromRGB(0, 0, 0), Surv_Login_Limp= 0,
        Surv_HP_Tog   = false, Surv_HP_Dir   = "顶部",    Surv_HP_Fill   = Color3.fromRGB(60, 255, 120),  Surv_HP_Out   = Color3.fromRGB(0, 0, 0), Surv_HP_Limp   = 0,
        Surv_Status_Tog=false, Surv_Status_Dir="顶部",    Surv_Status_Fill=Color3.fromRGB(255, 180, 0),   Surv_Status_Out=Color3.fromRGB(0, 0, 0), Surv_Status_Limp=0,
        Surv_Dist_Tog = false, Surv_Dist_Dir = "底部",    Surv_Dist_Fill = Color3.fromRGB(255, 255, 255), Surv_Dist_Out = Color3.fromRGB(0, 0, 0), Surv_Dist_Limp = 0,
    }

    local function GetRoot(char)
        if not char or typeof(char) ~= "Instance" then return nil end
        return char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char.PrimaryPart
    end

    local function GetCamera()
        return Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
    end

    local function IsPlayerAlive(char)
        if not char then return false end
        local ragFolder = Workspace:FindFirstChild("Ragdolls")
        if ragFolder and char:IsDescendantOf(ragFolder) then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0 and char:GetAttribute("Dead") ~= true
    end

    local function GetTrans(sliderVal, isEnabled)
        if not isEnabled or type(sliderVal) ~= "number" then return 1 end
        return math.clamp(sliderVal / 5, 0, 1)
    end

    local function GetCombatState(char)
        if not char or typeof(char) ~= "Instance" then
            return { DisplayName = "未知", Username = "未知", SkinName = "默认", RealHP = 100, MaxHP = 100, Overheal = 0, TotalHP = 100, IsSlateskin = false }
        end

        local hum    = char:FindFirstChildOfClass("Humanoid")
        local realHP = hum and hum.Health or 100
        local maxHP  = (hum and hum.MaxHealth > 0) and hum.MaxHealth or 100
        local overHP = (char:GetAttribute("Overheal") or 0)

        local dName  = char:GetAttribute("ActorDisplayName")
        local uName  = char:GetAttribute("Username")
        local sName  = char:GetAttribute("SkinNameDisplay") or char:GetAttribute("SkinName")

        local p = Players:GetPlayerFromCharacter(char) or Players:FindFirstChild(char.Name)
        local fallbackName = p and p.DisplayName or char.Name
        local fallbackUser = p and p.Name or char.Name
        local finalName = (dName and tostring(dName) ~= "" and tostring(dName)) or fallbackName

        local isNoobChar  = (finalName:lower() == "noob" or char.Name:lower():find("noob") ~= nil)
        local hasSlateskin= isNoobChar and (char:GetAttribute("Slateskin") == true or char:GetAttribute("SlateskinHP") ~= nil)

        return {
            IsInvincible = char:GetAttribute("Invincible") == true,
            IsStunned    = (char:GetAttribute("IsStunned") == true),
            IsFixingGen  = char:GetAttribute("FixingGenerator") == true,
            IsHelpless   = char:GetAttribute("AbilitiesDisabled") == true or char:GetAttribute("Helpless") == true,
            IsShielded   = char:GetAttribute("DusekkarProtected") ~= nil or char:GetAttribute("ShatterpointHP") ~= nil,
            IsSlateskin  = hasSlateskin,
            Overheal     = overHP,
            TotalHP      = realHP + overHP,
            RealHP       = realHP,
            MaxHP        = maxHP,
            DisplayName  = finalName,
            SkinName     = (sName and tostring(sName) ~= "" and tostring(sName)) or "默认",
            Username     = (uName and tostring(uName) ~= "" and tostring(uName)) or fallbackUser,
        }
    end

    local SafeGuiRoot = (gethui and gethui()) or game:GetService("CoreGui")

    local VisualGUI = Instance.new("Folder")
    VisualGUI.Name   = "Doomsense_Survivor_Visuals"
    VisualGUI.Parent = SafeGuiRoot

    local VisualsGui = Instance.new("ScreenGui")
    VisualsGui.Name           = "Doomsense_Survivor_2D"
    VisualsGui.ResetOnSpawn   = false
    VisualsGui.IgnoreGuiInset = true
    VisualsGui.DisplayOrder   = 999
    VisualsGui.Enabled        = true
    VisualsGui.Parent         = SafeGuiRoot

    local Highlights = {}
    local function GetHighlight(model)
        if not Highlights[model] then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = VisualGUI
            Highlights[model] = hl
        end
        return Highlights[model]
    end

    local function ApplyHighlightESP(model)
        local isEnabled = Vis.S_Enabled
        local hl = GetHighlight(model)

        if isEnabled then
            hl.Enabled  = true
            hl.Adornee  = model

            local styleDict = Vis.S_Style or {}
            local hasFill = (styleDict["内框"] == true) or (table.find(styleDict, "内框") ~= nil)
            local hasOut  = (styleDict["外框"] == true) or (table.find(styleDict, "外框") ~= nil)

            hl.FillColor    = Vis.S_Fill
            hl.OutlineColor = Vis.S_Out
            hl.FillTransparency    = hasFill and ((tonumber(Vis.S_LF) or 2) / 5) or 1
            hl.OutlineTransparency = hasOut  and ((tonumber(Vis.S_LO) or 0) / 5) or 1
        else
            hl.Enabled = false
            hl.Adornee = nil
        end
    end

    local TagCache = {}

    local function GetTags(model)
        if not TagCache[model] or not TagCache[model].BoxFrame or not TagCache[model].BoxFrame.Parent then
            local boxFrame = Instance.new("Frame")
            boxFrame.Name                   = "Doom_2D_Box"
            boxFrame.BackgroundTransparency = 1
            boxFrame.BorderSizePixel        = 0
            boxFrame.Visible                = false
            boxFrame.ClipsDescendants       = false
            boxFrame.Position               = UDim2.fromOffset(-5000, -5000)
            boxFrame.Size                   = UDim2.fromOffset(0, 0)
            boxFrame.ZIndex                 = 100
            boxFrame.Parent                 = VisualsGui

            local boxStroke = Instance.new("UIStroke", boxFrame)
            boxStroke.Name         = "BoxStroke"
            boxStroke.Thickness    = 1.5
            boxStroke.Transparency = 1

            local function MakeHolder(name, anchor, pos, hAlign, vAlign)
                local h = Instance.new("Frame", boxFrame)
                h.Name                   = name
                h.BackgroundTransparency = 1
                h.AnchorPoint            = anchor
                h.Position               = pos
                h.Size                   = UDim2.new(0, 260, 0, 0)
                h.AutomaticSize          = Enum.AutomaticSize.Y
                h.ClipsDescendants       = false
                h.ZIndex                 = 101

                local layout = Instance.new("UIListLayout", h)
                layout.SortOrder           = Enum.SortOrder.LayoutOrder
                layout.HorizontalAlignment = hAlign
                layout.VerticalAlignment   = vAlign
                layout.Padding             = UDim.new(0, 1)
                return h
            end

            local topHolder   = MakeHolder("TopHolder",    Vector2.new(0.5, 1), UDim2.new(0.5, 0, 0, -3), Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Bottom)
            local botHolder   = MakeHolder("BottomHolder", Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, 3),  Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
            local leftHolder  = MakeHolder("LeftHolder",   Vector2.new(1, 0),   UDim2.new(0, -4, 0, 0),    Enum.HorizontalAlignment.Right,  Enum.VerticalAlignment.Top)
            local rightHolder = MakeHolder("RightHolder",  Vector2.new(0, 0),   UDim2.new(1, 4, 0, 0),     Enum.HorizontalAlignment.Left,   Enum.VerticalAlignment.Top)

            local function CreateTagLabel(name)
                local lbl = Instance.new("TextLabel")
                lbl.Name                   = name
                lbl.Text                   = ""
                lbl.BackgroundTransparency = 1
                lbl.Font                   = Enum.Font.GothamBold
                lbl.TextSize               = 12
                lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
                lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
                lbl.TextStrokeTransparency = 0
                lbl.TextTransparency       = 0
                lbl.Size                   = UDim2.new(1, 0, 0, 14)
                lbl.Visible                = false
                lbl.ZIndex                 = 102
                return lbl
            end

            TagCache[model] = {
                BoxFrame  = boxFrame,
                BoxStroke = boxStroke,
                Holders   = { Top = topHolder, Bottom = botHolder, Left = leftHolder, Right = rightHolder },
                SURV = {
                    Role   = CreateTagLabel("SURV_Role"),
                    Name   = CreateTagLabel("SURV_Name"),
                    Skin   = CreateTagLabel("SURV_Skin"),
                    Login  = CreateTagLabel("SURV_Login"),
                    HP     = CreateTagLabel("SURV_HP"),
                    Status = CreateTagLabel("SURV_Status"),
                    Dist   = CreateTagLabel("SURV_Dist"),
                }
            }
        end
        return TagCache[model]
    end

    local function ClearAllEntityTags(tData)
        if not tData then return end
        tData.BoxFrame.Visible  = false
        tData.BoxFrame.Position = UDim2.fromOffset(-5000, -5000)
        tData.BoxFrame.Size     = UDim2.fromOffset(0, 0)
        tData.BoxStroke.Enabled = false
        for _, l in pairs(tData.SURV) do
            l.Visible = false
            l.Text    = ""
        end
    end

    local function GetHolderKey(dir)
        if dir == "顶部" then return "Top"
        elseif dir == "底部" then return "Bottom"
        elseif dir == "左侧" then return "Left"
        elseif dir == "右侧" then return "Right"
        else return "Top" end
    end

    RunService.Heartbeat:Connect(function()
        local cam = GetCamera()
        if not cam then return end

        local myChar = LP.Character
        local renderedThisFrame = {}

        local playersFolder   = Workspace:FindFirstChild("Players")
        local survivorsFolder = playersFolder and playersFolder:FindFirstChild("Survivors")

        local candidates = {}
        if survivorsFolder then
            for _, c in ipairs(survivorsFolder:GetChildren()) do
                if c:IsA("Model") and c ~= myChar then
                    table.insert(candidates, c)
                end
            end
        end

        local MAX_ENTITY_DIST = 900

        for _, char in ipairs(candidates) do
            if IsPlayerAlive(char) then
                local root = GetRoot(char)
                local hum  = char:FindFirstChildOfClass("Humanoid")

                if root and hum and hum.Health > 0 then
                    local distStuds = (cam.CFrame.Position - root.Position).Magnitude
                    if distStuds <= MAX_ENTITY_DIST then
                        ApplyHighlightESP(char)

                        local rootPos = root.Position
                        local root2D, onScreen = cam:WorldToViewportPoint(rootPos)

                        if onScreen and root2D.Z > 0 then
                            local topWorld = rootPos + Vector3.new(0, 2.5, 0)
                            local botWorld = rootPos - Vector3.new(0, 3.0, 0)
                            local top2D = cam:WorldToViewportPoint(topWorld)
                            local bot2D = cam:WorldToViewportPoint(botWorld)

                            if top2D.Z > 0 and bot2D.Z > 0 then
                                local boxHeight = math.max(math.abs(bot2D.Y - top2D.Y), 10)
                                local boxWidth  = math.floor(boxHeight * 0.62)

                                local minX = math.floor(root2D.X - (boxWidth / 2))
                                local minY = math.floor(math.min(top2D.Y, bot2D.Y))
                                local maxX = minX + boxWidth
                                local maxY = minY + boxHeight

                                minX = minX - (tonumber(Vis.Box_WOffset) or 0)
                                maxX = maxX + (tonumber(Vis.Box_WOffset) or 0)
                                minY = minY - (tonumber(Vis.Box_HOffset) or 0)
                                maxY = maxY + (tonumber(Vis.Box_HOffset) or 0)

                                if distStuds > 3.5 and minX < maxX and minY < maxY then
                                    local tData  = GetTags(char)
                                    local combat = GetCombatState(char)

                                    local hpStr = math.floor(combat.RealHP) .. " / " .. math.floor(combat.MaxHP) .. " 生命"
                                    if combat.Overheal > 0 then
                                        hpStr = hpStr .. " (+" .. math.floor(combat.Overheal) .. " 过量治疗)"
                                    end

                                    local distM   = math.floor(distStuds / 3.57)
                                    local distStr = math.floor(distStuds) .. " 格 (" .. distM .. "米)"

                                    local statusBadges = {}
                                    if combat.IsFixingGen  then table.insert(statusBadges, "[修复中]") end
                                    if combat.IsStunned    then table.insert(statusBadges, "[眩晕]")   end
                                    if combat.IsInvincible then table.insert(statusBadges, "[无敌]")   end
                                    if combat.IsShielded   then table.insert(statusBadges, "[护盾]")   end
                                    if combat.IsHelpless   then table.insert(statusBadges, "[无助]")   end
                                    if combat.IsSlateskin  then table.insert(statusBadges, "[板岩皮肤]") end
                                    local statusStr = table.concat(statusBadges, " ")

                                    local function applyTag(lbl, isTog, dir, order, fillCol, outCol, limpVal, textStr)
                                        if not lbl then return end
                                        if isTog and textStr and tostring(textStr) ~= "" then
                                            local holder = tData.Holders[GetHolderKey(dir)] or tData.Holders.Top
                                            if lbl.Parent ~= holder then lbl.Parent = holder end
                                            lbl.Text = tostring(textStr)

                                            if dir == "左侧" then lbl.TextXAlignment = Enum.TextXAlignment.Right
                                            elseif dir == "右侧" then lbl.TextXAlignment = Enum.TextXAlignment.Left
                                            else lbl.TextXAlignment = Enum.TextXAlignment.Center end

                                            lbl.TextColor3       = fillCol
                                            lbl.TextStrokeColor3 = outCol
                                            local dT = math.clamp((tonumber(Vis.Tags_GlobalLimp) or 0) / 5, 0, 1)
                                            if type(limpVal) == "number" and limpVal > 0 then
                                                dT = math.max(dT, math.clamp(limpVal / 5, 0, 1))
                                            end
                                            lbl.TextTransparency       = dT
                                            lbl.TextStrokeTransparency = dT
                                            lbl.LayoutOrder            = tonumber(order) or 1
                                            lbl.Visible                = true
                                        else
                                            lbl.Visible = false
                                            lbl.Text    = ""
                                        end
                                    end

                                    applyTag(tData.SURV.Role,   Vis.Surv_Role_Tog,   Vis.Surv_Role_Dir,   1, Vis.Surv_Role_Fill,   Vis.Surv_Role_Out,   Vis.Surv_Role_Limp,   "[幸存者]")
                                    applyTag(tData.SURV.Name,   Vis.Surv_Name_Tog,   Vis.Surv_Name_Dir,   2, Vis.Surv_Name_Fill,   Vis.Surv_Name_Out,   Vis.Surv_Name_Limp,   combat.DisplayName)
                                    applyTag(tData.SURV.Skin,   Vis.Surv_Skin_Tog,   Vis.Surv_Skin_Dir,   3, Vis.Surv_Skin_Fill,   Vis.Surv_Skin_Out,   Vis.Surv_Skin_Limp,   "[" .. combat.SkinName .. "]")
                                    applyTag(tData.SURV.Login,  Vis.Surv_Login_Tog,  Vis.Surv_Login_Dir,  4, Vis.Surv_Login_Fill,  Vis.Surv_Login_Out,  Vis.Surv_Login_Limp,  "@" .. combat.Username)
                                    applyTag(tData.SURV.HP,     Vis.Surv_HP_Tog,     Vis.Surv_HP_Dir,     5, Vis.Surv_HP_Fill,     Vis.Surv_HP_Out,     Vis.Surv_HP_Limp,     hpStr)
                                    applyTag(tData.SURV.Status, Vis.Surv_Status_Tog, Vis.Surv_Status_Dir, 6, Vis.Surv_Status_Fill, Vis.Surv_Status_Out, Vis.Surv_Status_Limp, statusStr)
                                    applyTag(tData.SURV.Dist,   Vis.Surv_Dist_Tog,   Vis.Surv_Dist_Dir,   1, Vis.Surv_Dist_Fill,   Vis.Surv_Dist_Out,   Vis.Surv_Dist_Limp,   distStr)

                                    local fillTransp = GetTrans(Vis.Surv_Box_Limp_Fill, Vis.Surv_Box_Tog)
                                    local outTransp  = GetTrans(Vis.Surv_Box_Limp_Out,  Vis.Surv_Box_Tog)

                                    tData.BoxFrame.Position               = UDim2.fromOffset(minX, minY)
                                    tData.BoxFrame.Size                   = UDim2.fromOffset(maxX - minX, maxY - minY)
                                    tData.BoxFrame.BackgroundColor3       = Vis.Surv_Box_Fill
                                    tData.BoxFrame.BackgroundTransparency = fillTransp
                                    tData.BoxStroke.Color                 = Vis.Surv_Box_Out
                                    tData.BoxStroke.Transparency          = outTransp
                                    tData.BoxStroke.Enabled               = Vis.Surv_Box_Tog
                                    tData.BoxFrame.Visible                = true

                                    renderedThisFrame[char] = true
                                else
                                    if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                                end
                            else
                                if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                            end
                        else
                            if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                        end
                    else
                        local hl = Highlights[char]
                        if hl then hl.Enabled = false; hl.Adornee = nil end
                        if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                    end
                else
                    local hl = Highlights[char]
                    if hl then hl.Enabled = false; hl.Adornee = nil end
                    if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                end
            else
                if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
            end
        end

        for model, tData in pairs(TagCache) do
            if not renderedThisFrame[model] then
                ClearAllEntityTags(tData)
                local hl = Highlights[model]
                if hl then
                    hl.Enabled = false
                    hl.Adornee = nil
                end
                if not model or not model.Parent then
                    pcall(function()
                        if tData.BoxFrame and tData.BoxFrame.Parent then
                            tData.BoxFrame:Destroy()
                        end
                    end)
                    TagCache[model] = nil
                end
            end
        end

        for model, hl in pairs(Highlights) do
            if not renderedThisFrame[model] then
                hl.Enabled = false
                hl.Adornee = nil
                if not model or not model.Parent then
                    pcall(function() hl:Destroy() end)
                    Highlights[model] = nil
                end
            end
        end
    end)

    Feng.ma:Toggle({
        Name = "启用幸存者透视",
        Value = false,
        Callback = function(v) Vis.S_Enabled = v end
    })

    Feng.ma:Toggle({
        Name = "启动2D框",
        Value = false,
        Callback = function(v) Vis.Surv_Box_Tog = v end
    })

    Feng.ma:Divider({ Name = "显示状态" })

    Feng.ma:Toggle({
        Name = "显示幸存者标签",
        Value = false,
        Callback = function(v) Vis.Surv_Role_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示角色名称",
        Value = false,
        Callback = function(v) Vis.Surv_Name_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示皮肤名称",
        Value = false,
        Callback = function(v) Vis.Surv_Skin_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示用户名",
        Value = false,
        Callback = function(v) Vis.Surv_Login_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示生命值",
        Value = false,
        Callback = function(v) Vis.Surv_HP_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示状态",
        Value = false,
        Callback = function(v) Vis.Surv_Status_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示距离",
        Value = false,
        Callback = function(v) Vis.Surv_Dist_Tog = v end
    })

    Feng.se:Dropdown({
        Name = "样式",
        Values = { "外框", "内框" },
        Multi = true,
        Default = {},
        Callback = function(v) Vis.S_Style = v end
    })

    Feng.se:Colorpicker({
        Name = "外框颜色",
        Default = Vis.S_Out,
        Transparency = 0.2,
        Callback = function(color) Vis.S_Out = color end
    })

    Feng.se:Colorpicker({
        Name = "内框颜色",
        Default = Vis.S_Fill,
        Transparency = 0.2,
        Callback = function(color) Vis.S_Fill = color end
    })

    Feng.se:Slider({
        Name = "外框透明度",
        Value = { Min = 0, Max = 5, Default = 0 },
        Rounding = 1,
        Callback = function(v) Vis.S_LO = v end
    })

    Feng.se:Slider({
        Name = "内框透明度",
        Value = { Min = 0, Max = 5, Default = 2 },
        Rounding = 1,
        Callback = function(v) Vis.S_LF = v end
    })

    Feng.se:Divider({ Name = "2D框颜色系统" })

    Feng.se:Colorpicker({
        Name = "内框颜色",
        Default = Vis.Surv_Box_Fill,
        Transparency = 0.2,
        Callback = function(color) Vis.Surv_Box_Fill = color end
    })

    Feng.se:Colorpicker({
        Name = "外框颜色",
        Default = Vis.Surv_Box_Out,
        Transparency = 0.2,
        Callback = function(color) Vis.Surv_Box_Out = color end
    })

    Feng.se:Divider({ Name = "标签系统" })

    Feng.se:Slider({
        Name = "全局文字透明度",
        Value = { Min = 0, Max = 5, Default = 0 },
        Rounding = 1,
        Callback = function(v) Vis.Tags_GlobalLimp = v end
    })

    Feng.se:Slider({
        Name = "框宽度偏移",
        Value = { Min = -15, Max = 15, Default = 0 },
        Rounding = 1,
        Callback = function(v) Vis.Box_WOffset = v end
    })

    Feng.se:Slider({
        Name = "框高度偏移",
        Value = { Min = -15, Max = 15, Default = 0 },
        Rounding = 1,
        Callback = function(v) Vis.Box_HOffset = v end
    })

    Feng.se:Divider({ Name = "位置系统" })

    local DirValues = { "顶部", "底部", "左侧", "右侧" }

    Feng.se:Dropdown({
        Name = "幸存者标签方向",
        Values = DirValues, Value = "顶部",
        Callback = function(v) Vis.Surv_Role_Dir = v end
    })

    Feng.se:Dropdown({
        Name = "角色名称标签方向",
        Values = DirValues, Value = "顶部",
        Callback = function(v) Vis.Surv_Name_Dir = v end
    })

    Feng.se:Dropdown({
        Name = "皮肤名称标签方向",
        Values = DirValues, Value = "顶部",
        Callback = function(v) Vis.Surv_Skin_Dir = v end
    })

    Feng.se:Dropdown({
        Name = "用户名标签方向",
        Values = DirValues, Value = "顶部",
        Callback = function(v) Vis.Surv_Login_Dir = v end
    })

    Feng.se:Dropdown({
        Name = "生命值标签方向",
        Values = DirValues, Value = "顶部",
        Callback = function(v) Vis.Surv_HP_Dir = v end
    })

    Feng.se:Dropdown({
        Name = "状态徽章标签方向",
        Values = DirValues, Value = "顶部",
        Callback = function(v) Vis.Surv_Status_Dir = v end
    })

    Feng.se:Dropdown({
        Name = "距离标签方向",
        Values = DirValues, Value = "底部",
        Callback = function(v) Vis.Surv_Dist_Dir = v end
    })
end
local Feng = FengYu:Section({
    Name = "杀手透视",
    SubName = "杀手 Killer",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
    {
        Key = "ma",
        Name = "透视基本要素",
    },
    {
        Key = "se",
        Name = "透视设置",
    },
})

do
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace  = game:GetService("Workspace")
    local LP         = Players.LocalPlayer

    local KVis = {
        K_Enabled = false,
        K_Style   = {},
        K_Fill    = Color3.fromRGB(255, 40, 40),
        K_Out     = Color3.fromRGB(255, 255, 255),
        K_LF      = 2,
        K_LO      = 0,

        Box_WOffset     = 0,
        Box_HOffset     = 0,
        Tags_GlobalLimp = 0,

        Killer_Box_Tog       = false,
        Killer_Box_Fill      = Color3.fromRGB(255, 40, 40),
        Killer_Box_Out       = Color3.fromRGB(255, 255, 255),
        Killer_Box_Limp_Fill = 4,
        Killer_Box_Limp_Out  = 0,

        Killer_Role_Tog = false, Killer_Role_Dir = "顶部",
        Killer_Name_Tog = false, Killer_Name_Dir = "顶部",
        Killer_Skin_Tog = false, Killer_Skin_Dir = "顶部",
        Killer_Login_Tog= false, Killer_Login_Dir= "顶部",
        Killer_HP_Tog   = false, Killer_HP_Dir   = "顶部",
        Killer_Status_Tog=false, Killer_Status_Dir="顶部",
        Killer_Dist_Tog = false, Killer_Dist_Dir = "底部",
    }

    local Killer_Role_Fill   = Color3.fromRGB(255, 60, 60)
    local Killer_Role_Out    = Color3.fromRGB(0, 0, 0)
    local Killer_Role_Limp   = 0
    local Killer_Name_Fill   = Color3.fromRGB(255, 255, 255)
    local Killer_Name_Out    = Color3.fromRGB(0, 0, 0)
    local Killer_Name_Limp   = 0
    local Killer_Skin_Fill   = Color3.fromRGB(255, 150, 150)
    local Killer_Skin_Out    = Color3.fromRGB(0, 0, 0)
    local Killer_Skin_Limp   = 0
    local Killer_Login_Fill  = Color3.fromRGB(255, 180, 180)
    local Killer_Login_Out   = Color3.fromRGB(0, 0, 0)
    local Killer_Login_Limp  = 0
    local Killer_HP_Fill     = Color3.fromRGB(255, 60, 60)
    local Killer_HP_Out      = Color3.fromRGB(0, 0, 0)
    local Killer_HP_Limp     = 0
    local Killer_Status_Fill = Color3.fromRGB(255, 220, 0)
    local Killer_Status_Out  = Color3.fromRGB(0, 0, 0)
    local Killer_Status_Limp = 0
    local Killer_Dist_Fill   = Color3.fromRGB(255, 60, 60)
    local Killer_Dist_Out    = Color3.fromRGB(0, 0, 0)
    local Killer_Dist_Limp   = 0

    local function GetRoot(char)
        if not char or typeof(char) ~= "Instance" then return nil end
        return char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char.PrimaryPart
    end

    local function GetCamera()
        return Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
    end

    local function IsPlayerAlive(char)
        if not char then return false end
        local ragFolder = Workspace:FindFirstChild("Ragdolls")
        if ragFolder and char:IsDescendantOf(ragFolder) then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0 and char:GetAttribute("Dead") ~= true
    end

    local function GetTrans(sliderVal, isEnabled)
        if not isEnabled or type(sliderVal) ~= "number" then return 1 end
        return math.clamp(sliderVal / 5, 0, 1)
    end

    local function GetCombatState(char)
        if not char or typeof(char) ~= "Instance" then
            return { DisplayName = "未知", Username = "未知", SkinName = "默认", RealHP = 100, MaxHP = 100, Overheal = 0, TotalHP = 100, IsSlateskin = false }
        end

        local hum    = char:FindFirstChildOfClass("Humanoid")
        local realHP = hum and hum.Health or 100
        local maxHP  = (hum and hum.MaxHealth > 0) and hum.MaxHealth or 100
        local overHP = (char:GetAttribute("Overheal") or 0)

        local dName  = char:GetAttribute("ActorDisplayName")
        local uName  = char:GetAttribute("Username")
        local sName  = char:GetAttribute("SkinNameDisplay") or char:GetAttribute("SkinName")

        local p = Players:GetPlayerFromCharacter(char) or Players:FindFirstChild(char.Name)
        local fallbackName = p and p.DisplayName or char.Name
        local fallbackUser = p and p.Name or char.Name
        local finalName = (dName and tostring(dName) ~= "" and tostring(dName)) or fallbackName

        local isNoobChar  = (finalName:lower() == "noob" or char.Name:lower():find("noob") ~= nil)
        local hasSlateskin= isNoobChar and (char:GetAttribute("Slateskin") == true or char:GetAttribute("SlateskinHP") ~= nil)

        return {
            IsInvincible = char:GetAttribute("Invincible") == true,
            IsStunned    = (char:GetAttribute("IsStunned") == true),
            IsFixingGen  = char:GetAttribute("FixingGenerator") == true,
            IsHelpless   = char:GetAttribute("AbilitiesDisabled") == true or char:GetAttribute("Helpless") == true,
            IsShielded   = char:GetAttribute("DusekkarProtected") ~= nil or char:GetAttribute("ShatterpointHP") ~= nil,
            IsSlateskin  = hasSlateskin,
            Overheal     = overHP,
            TotalHP      = realHP + overHP,
            RealHP       = realHP,
            MaxHP        = maxHP,
            DisplayName  = finalName,
            SkinName     = (sName and tostring(sName) ~= "" and tostring(sName)) or "默认",
            Username     = (uName and tostring(uName) ~= "" and tostring(uName)) or fallbackUser,
        }
    end

    local SafeGuiRoot = (gethui and gethui()) or game:GetService("CoreGui")

    local KillerVisualGUI = Instance.new("Folder")
    KillerVisualGUI.Name   = "Doomsense_Killer_Visuals"
    KillerVisualGUI.Parent = SafeGuiRoot

    local KillerVisualsGui = Instance.new("ScreenGui")
    KillerVisualsGui.Name           = "Doomsense_Killer_2D"
    KillerVisualsGui.ResetOnSpawn   = false
    KillerVisualsGui.IgnoreGuiInset = true
    KillerVisualsGui.DisplayOrder   = 999
    KillerVisualsGui.Enabled        = true
    KillerVisualsGui.Parent         = SafeGuiRoot

    local Highlights = {}
    local function GetHighlight(model)
        if not Highlights[model] then
            local hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = KillerVisualGUI
            Highlights[model] = hl
        end
        return Highlights[model]
    end

    local function ApplyHighlightESP(model)
        local isEnabled = KVis.K_Enabled
        local hl = GetHighlight(model)

        if isEnabled then
            hl.Enabled  = true
            hl.Adornee  = model

            local styleDict = KVis.K_Style or {}
            local hasFill = (styleDict["内框"] == true) or (table.find(styleDict, "内框") ~= nil)
            local hasOut  = (styleDict["外框"] == true) or (table.find(styleDict, "外框") ~= nil)

            hl.FillColor    = KVis.K_Fill
            hl.OutlineColor = KVis.K_Out
            hl.FillTransparency    = hasFill and ((tonumber(KVis.K_LF) or 2) / 5) or 1
            hl.OutlineTransparency = hasOut  and ((tonumber(KVis.K_LO) or 0) / 5) or 1
        else
            hl.Enabled = false
            hl.Adornee = nil
        end
    end

    local TagCache = {}

    local function GetTags(model)
        if not TagCache[model] or not TagCache[model].BoxFrame or not TagCache[model].BoxFrame.Parent then
            local boxFrame = Instance.new("Frame")
            boxFrame.Name                   = "Doom_Killer_2D_Box"
            boxFrame.BackgroundTransparency = 1
            boxFrame.BorderSizePixel        = 0
            boxFrame.Visible                = false
            boxFrame.ClipsDescendants       = false
            boxFrame.Position               = UDim2.fromOffset(-5000, -5000)
            boxFrame.Size                   = UDim2.fromOffset(0, 0)
            boxFrame.ZIndex                 = 100
            boxFrame.Parent                 = KillerVisualsGui

            local boxStroke = Instance.new("UIStroke", boxFrame)
            boxStroke.Name         = "BoxStroke"
            boxStroke.Thickness    = 1.5
            boxStroke.Transparency = 1

            local function MakeHolder(name, anchor, pos, hAlign, vAlign)
                local h = Instance.new("Frame", boxFrame)
                h.Name                   = name
                h.BackgroundTransparency = 1
                h.AnchorPoint            = anchor
                h.Position               = pos
                h.Size                   = UDim2.new(0, 260, 0, 0)
                h.AutomaticSize          = Enum.AutomaticSize.Y
                h.ClipsDescendants       = false
                h.ZIndex                 = 101

                local layout = Instance.new("UIListLayout", h)
                layout.SortOrder           = Enum.SortOrder.LayoutOrder
                layout.HorizontalAlignment = hAlign
                layout.VerticalAlignment   = vAlign
                layout.Padding             = UDim.new(0, 1)
                return h
            end

            local topHolder   = MakeHolder("TopHolder",    Vector2.new(0.5, 1), UDim2.new(0.5, 0, 0, -3), Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Bottom)
            local botHolder   = MakeHolder("BottomHolder", Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, 3),  Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
            local leftHolder  = MakeHolder("LeftHolder",   Vector2.new(1, 0),   UDim2.new(0, -4, 0, 0),    Enum.HorizontalAlignment.Right,  Enum.VerticalAlignment.Top)
            local rightHolder = MakeHolder("RightHolder",  Vector2.new(0, 0),   UDim2.new(1, 4, 0, 0),     Enum.HorizontalAlignment.Left,   Enum.VerticalAlignment.Top)

            local function CreateTagLabel(name)
                local lbl = Instance.new("TextLabel")
                lbl.Name                   = name
                lbl.Text                   = ""
                lbl.BackgroundTransparency = 1
                lbl.Font                   = Enum.Font.GothamBold
                lbl.TextSize               = 12
                lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
                lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
                lbl.TextStrokeTransparency = 0
                lbl.TextTransparency       = 0
                lbl.Size                   = UDim2.new(1, 0, 0, 14)
                lbl.Visible                = false
                lbl.ZIndex                 = 102
                return lbl
            end

            TagCache[model] = {
                BoxFrame  = boxFrame,
                BoxStroke = boxStroke,
                Holders   = { Top = topHolder, Bottom = botHolder, Left = leftHolder, Right = rightHolder },
                KILLER = {
                    Role   = CreateTagLabel("KILLER_Role"),
                    Name   = CreateTagLabel("KILLER_Name"),
                    Skin   = CreateTagLabel("KILLER_Skin"),
                    Login  = CreateTagLabel("KILLER_Login"),
                    HP     = CreateTagLabel("KILLER_HP"),
                    Status = CreateTagLabel("KILLER_Status"),
                    Dist   = CreateTagLabel("KILLER_Dist"),
                }
            }
        end
        return TagCache[model]
    end

    local function ClearAllEntityTags(tData)
        if not tData then return end
        tData.BoxFrame.Visible  = false
        tData.BoxFrame.Position = UDim2.fromOffset(-5000, -5000)
        tData.BoxFrame.Size     = UDim2.fromOffset(0, 0)
        tData.BoxStroke.Enabled = false
        for _, l in pairs(tData.KILLER) do
            l.Visible = false
            l.Text    = ""
        end
    end

    local function GetHolderKey(dir)
        if dir == "顶部" then return "Top"
        elseif dir == "底部" then return "Bottom"
        elseif dir == "左侧" then return "Left"
        elseif dir == "右侧" then return "Right"
        else return "Top" end
    end

    RunService.Heartbeat:Connect(function()
        local cam = GetCamera()
        if not cam then return end

        local myChar = LP.Character
        local renderedThisFrame = {}

        local playersFolder = Workspace:FindFirstChild("Players")
        local killersFolder = playersFolder and playersFolder:FindFirstChild("Killers")

        local candidates = {}
        if killersFolder then
            for _, c in ipairs(killersFolder:GetChildren()) do
                if c:IsA("Model") and c ~= myChar then
                    table.insert(candidates, c)
                end
            end
        end

        local MAX_ENTITY_DIST = 900

        for _, char in ipairs(candidates) do
            if IsPlayerAlive(char) then
                local root = GetRoot(char)
                local hum  = char:FindFirstChildOfClass("Humanoid")

                if root and hum and hum.Health > 0 then
                    local distStuds = (cam.CFrame.Position - root.Position).Magnitude
                    if distStuds <= MAX_ENTITY_DIST then
                        ApplyHighlightESP(char)

                        local rootPos = root.Position
                        local root2D, onScreen = cam:WorldToViewportPoint(rootPos)

                        if onScreen and root2D.Z > 0 then
                            local topWorld = rootPos + Vector3.new(0, 2.5, 0)
                            local botWorld = rootPos - Vector3.new(0, 3.0, 0)
                            local top2D = cam:WorldToViewportPoint(topWorld)
                            local bot2D = cam:WorldToViewportPoint(botWorld)

                            if top2D.Z > 0 and bot2D.Z > 0 then
                                local boxHeight = math.max(math.abs(bot2D.Y - top2D.Y), 10)
                                local boxWidth  = math.floor(boxHeight * 0.62)

                                local minX = math.floor(root2D.X - (boxWidth / 2))
                                local minY = math.floor(math.min(top2D.Y, bot2D.Y))
                                local maxX = minX + boxWidth
                                local maxY = minY + boxHeight

                                minX = minX - (tonumber(KVis.Box_WOffset) or 0)
                                maxX = maxX + (tonumber(KVis.Box_WOffset) or 0)
                                minY = minY - (tonumber(KVis.Box_HOffset) or 0)
                                maxY = maxY + (tonumber(KVis.Box_HOffset) or 0)

                                if distStuds > 3.5 and minX < maxX and minY < maxY then
                                    local tData  = GetTags(char)
                                    local combat = GetCombatState(char)

                                    local hpStr = math.floor(combat.RealHP) .. " / " .. math.floor(combat.MaxHP) .. " 生命"
                                    if combat.Overheal > 0 then
                                        hpStr = hpStr .. " (+" .. math.floor(combat.Overheal) .. " 过量治疗)"
                                    end

                                    local distM   = math.floor(distStuds / 3.57)
                                    local distStr = math.floor(distStuds) .. " 格 (" .. distM .. "米)"

                                    local statusBadges = {}
                                    if combat.IsFixingGen  then table.insert(statusBadges, "[修复中]") end
                                    if combat.IsStunned    then table.insert(statusBadges, "[眩晕]")   end
                                    if combat.IsInvincible then table.insert(statusBadges, "[无敌]")   end
                                    if combat.IsShielded   then table.insert(statusBadges, "[护盾]")   end
                                    if combat.IsHelpless   then table.insert(statusBadges, "[无助]")   end
                                    if combat.IsSlateskin  then table.insert(statusBadges, "[板岩皮肤]") end
                                    local statusStr = table.concat(statusBadges, " ")

                                    local function applyTag(lbl, isTog, dir, order, fillCol, outCol, limpVal, textStr)
                                        if not lbl then return end
                                        if isTog and textStr and tostring(textStr) ~= "" then
                                            local holder = tData.Holders[GetHolderKey(dir)] or tData.Holders.Top
                                            if lbl.Parent ~= holder then lbl.Parent = holder end
                                            lbl.Text = tostring(textStr)

                                            if dir == "左侧" then lbl.TextXAlignment = Enum.TextXAlignment.Right
                                            elseif dir == "右侧" then lbl.TextXAlignment = Enum.TextXAlignment.Left
                                            else lbl.TextXAlignment = Enum.TextXAlignment.Center end

                                            lbl.TextColor3       = fillCol
                                            lbl.TextStrokeColor3 = outCol
                                            local dT = math.clamp((tonumber(KVis.Tags_GlobalLimp) or 0) / 5, 0, 1)
                                            if type(limpVal) == "number" and limpVal > 0 then
                                                dT = math.max(dT, math.clamp(limpVal / 5, 0, 1))
                                            end
                                            lbl.TextTransparency       = dT
                                            lbl.TextStrokeTransparency = dT
                                            lbl.LayoutOrder            = tonumber(order) or 1
                                            lbl.Visible                = true
                                        else
                                            lbl.Visible = false
                                            lbl.Text    = ""
                                        end
                                    end

                                    applyTag(tData.KILLER.Role,   KVis.Killer_Role_Tog,   KVis.Killer_Role_Dir,   1, Killer_Role_Fill,   Killer_Role_Out,   Killer_Role_Limp,   "[杀手]")
                                    applyTag(tData.KILLER.Name,   KVis.Killer_Name_Tog,   KVis.Killer_Name_Dir,   2, Killer_Name_Fill,   Killer_Name_Out,   Killer_Name_Limp,   combat.DisplayName)
                                    applyTag(tData.KILLER.Skin,   KVis.Killer_Skin_Tog,   KVis.Killer_Skin_Dir,   3, Killer_Skin_Fill,   Killer_Skin_Out,   Killer_Skin_Limp,   "[" .. combat.SkinName .. "]")
                                    applyTag(tData.KILLER.Login,  KVis.Killer_Login_Tog,  KVis.Killer_Login_Dir,  4, Killer_Login_Fill,  Killer_Login_Out,  Killer_Login_Limp,  "@" .. combat.Username)
                                    applyTag(tData.KILLER.HP,     KVis.Killer_HP_Tog,     KVis.Killer_HP_Dir,     5, Killer_HP_Fill,     Killer_HP_Out,     Killer_HP_Limp,     hpStr)
                                    applyTag(tData.KILLER.Status, KVis.Killer_Status_Tog, KVis.Killer_Status_Dir, 6, Killer_Status_Fill, Killer_Status_Out, Killer_Status_Limp, statusStr)
                                    applyTag(tData.KILLER.Dist,   KVis.Killer_Dist_Tog,   KVis.Killer_Dist_Dir,   1, Killer_Dist_Fill,   Killer_Dist_Out,   Killer_Dist_Limp,   distStr)

                                    local fillTransp = GetTrans(KVis.Killer_Box_Limp_Fill, KVis.Killer_Box_Tog)
                                    local outTransp  = GetTrans(KVis.Killer_Box_Limp_Out,  KVis.Killer_Box_Tog)

                                    tData.BoxFrame.Position               = UDim2.fromOffset(minX, minY)
                                    tData.BoxFrame.Size                   = UDim2.fromOffset(maxX - minX, maxY - minY)
                                    tData.BoxFrame.BackgroundColor3       = KVis.Killer_Box_Fill
                                    tData.BoxFrame.BackgroundTransparency = fillTransp
                                    tData.BoxStroke.Color                 = KVis.Killer_Box_Out
                                    tData.BoxStroke.Transparency          = outTransp
                                    tData.BoxStroke.Enabled               = KVis.Killer_Box_Tog
                                    tData.BoxFrame.Visible                = true

                                    renderedThisFrame[char] = true
                                else
                                    if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                                end
                            else
                                if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                            end
                        else
                            if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                        end
                    else
                        local hl = Highlights[char]
                        if hl then hl.Enabled = false; hl.Adornee = nil end
                        if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                    end
                else
                    local hl = Highlights[char]
                    if hl then hl.Enabled = false; hl.Adornee = nil end
                    if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
                end
            else
                if TagCache[char] then ClearAllEntityTags(TagCache[char]) end
            end
        end

        for model, tData in pairs(TagCache) do
            if not renderedThisFrame[model] then
                ClearAllEntityTags(tData)
                local hl = Highlights[model]
                if hl then
                    hl.Enabled = false
                    hl.Adornee = nil
                end
                if not model or not model.Parent then
                    pcall(function()
                        if tData.BoxFrame and tData.BoxFrame.Parent then
                            tData.BoxFrame:Destroy()
                        end
                    end)
                    TagCache[model] = nil
                end
            end
        end

        for model, hl in pairs(Highlights) do
            if not renderedThisFrame[model] then
                hl.Enabled = false
                hl.Adornee = nil
                if not model or not model.Parent then
                    pcall(function() hl:Destroy() end)
                    Highlights[model] = nil
                end
            end
        end
    end)

    Feng.ma:Toggle({
        Name = "启用杀手透视",
        Value = false,
        Callback = function(v) KVis.K_Enabled = v end
    })

    Feng.ma:Toggle({
        Name = "启动2D框",
        Value = false,
        Callback = function(v) KVis.Killer_Box_Tog = v end
    })

    Feng.ma:Divider({ Name = "显示状态" })

    Feng.ma:Toggle({
        Name = "显示杀手标签",
        Value = false,
        Callback = function(v) KVis.Killer_Role_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示角色名称",
        Value = false,
        Callback = function(v) KVis.Killer_Name_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示皮肤名称",
        Value = false,
        Callback = function(v) KVis.Killer_Skin_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示用户名",
        Value = false,
        Callback = function(v) KVis.Killer_Login_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示生命值",
        Value = false,
        Callback = function(v) KVis.Killer_HP_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示状态",
        Value = false,
        Callback = function(v) KVis.Killer_Status_Tog = v end
    })

    Feng.ma:Toggle({
        Name = "显示距离",
        Value = false,
        Callback = function(v) KVis.Killer_Dist_Tog = v end
    })

    Feng.se:Dropdown({
        Name = "样式",
        Values = { "外框", "内框" },
        Multi = true,
        Default = {},
        Callback = function(v) KVis.K_Style = v end
    })

    Feng.se:Colorpicker({
        Name = "外框颜色",
        Default = KVis.K_Out,
        Transparency = 0.2,
        Callback = function(color) KVis.K_Out = color end
    })

    Feng.se:Colorpicker({
        Name = "内框颜色",
        Default = KVis.K_Fill,
        Transparency = 0.2,
        Callback = function(color) KVis.K_Fill = color end
    })

    Feng.se:Slider({
        Name = "外框透明度",
        Value = { Min = 0, Max = 5, Default = 0 },
        Rounding = 1,
        Callback = function(v) KVis.K_LO = v end
    })

    Feng.se:Slider({
        Name = "内框透明度",
        Value = { Min = 0, Max = 5, Default = 2 },
        Rounding = 1,
        Callback = function(v) KVis.K_LF = v end
    })

    Feng.se:Divider({ Name = "2D框颜色系统" })

    Feng.se:Colorpicker({
        Name = "内框颜色",
        Default = KVis.Killer_Box_Fill,
        Transparency = 0.2,
        Callback = function(color) KVis.Killer_Box_Fill = color end
    })

    Feng.se:Colorpicker({
        Name = "外框颜色",
        Default = KVis.Killer_Box_Out,
        Transparency = 0.2,
        Callback = function(color) KVis.Killer_Box_Out = color end
    })

    Feng.se:Divider({ Name = "标签系统" })

    Feng.se:Slider({
        Name = "全局文字透明度",
        Value = { Min = 0, Max = 5, Default = 0 },
        Rounding = 1,
        Callback = function(v) KVis.Tags_GlobalLimp = v end
    })

    Feng.se:Slider({
        Name = "框宽度偏移",
        Value = { Min = -15, Max = 15, Default = 0 },
        Rounding = 1,
        Callback = function(v) KVis.Box_WOffset = v end
    })

    Feng.se:Slider({
        Name = "框高度偏移",
        Value = { Min = -15, Max = 15, Default = 0 },
        Rounding = 1,
        Callback = function(v) KVis.Box_HOffset = v end
    })

    Feng.se:Divider({ Name = "位置系统" })

    local DirValues = { "顶部", "底部", "左侧", "右侧" }

    Feng.se:Dropdown({ Name = "杀手标签方向",       Values = DirValues, Value = "顶部", Callback = function(v) KVis.Killer_Role_Dir = v end })
    Feng.se:Dropdown({ Name = "角色名称标签方向",   Values = DirValues, Value = "顶部", Callback = function(v) KVis.Killer_Name_Dir = v end })
    Feng.se:Dropdown({ Name = "皮肤名称标签方向",   Values = DirValues, Value = "顶部", Callback = function(v) KVis.Killer_Skin_Dir = v end })
    Feng.se:Dropdown({ Name = "用户名标签方向",     Values = DirValues, Value = "顶部", Callback = function(v) KVis.Killer_Login_Dir = v end })
    Feng.se:Dropdown({ Name = "生命值标签方向",     Values = DirValues, Value = "顶部", Callback = function(v) KVis.Killer_HP_Dir = v end })
    Feng.se:Dropdown({ Name = "状态徽章标签方向",   Values = DirValues, Value = "顶部", Callback = function(v) KVis.Killer_Status_Dir = v end })
    Feng.se:Dropdown({ Name = "距离标签方向",       Values = DirValues, Value = "底部", Callback = function(v) KVis.Killer_Dist_Dir = v end })
end

local Feng = FengYu:Section({
    Name = "物品透视",
    SubName = "物品 Item",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local Players    = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace  = game:GetService("Workspace")
    local LP         = Players.LocalPlayer

    local ItemConfig = {
        Enabled  = false,
        ShowDist = true,
        Color    = Color3.fromRGB(255, 200, 50),
    }

    local ItemCache  = {}
    local ItemsList  = {}
    local seenItems  = {}
    local lastScan   = 0
    local lastIngame = nil

    local SafeGuiRoot = (gethui and gethui()) or game:GetService("CoreGui")

    local ItemVisualGUI = Instance.new("Folder")
    ItemVisualGUI.Name   = "Doomsense_Item_ESP"
    ItemVisualGUI.Parent = SafeGuiRoot

    local function GetRoot(char)
        if not char or typeof(char) ~= "Instance" then return nil end
        return char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("Torso")
            or char:FindFirstChild("UpperTorso")
            or char.PrimaryPart
    end

    local function UpdateItemsList()
        local itmList = {}
        local seen = {}

        local map = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Ingame")
        local pFolder = Workspace:FindFirstChild("Players")

        local scanFolders = { Workspace }
        if map then table.insert(scanFolders, map) end

        for _, folder in ipairs(scanFolders) do
            for _, obj in ipairs(folder:GetChildren()) do
                if obj.Name ~= "Players" and obj.Name ~= "Ragdolls" and obj.Name ~= "ItemLocations" then
                    local toolCandidate = obj:IsA("Tool") and obj or obj:FindFirstChildWhichIsA("Tool")
                    if toolCandidate and not seen[toolCandidate] then
                        local isEquipped = (pFolder and toolCandidate:IsDescendantOf(pFolder))
                            or toolCandidate:FindFirstAncestorOfClass("Player")
                            or (toolCandidate.Parent and toolCandidate.Parent:FindFirstChildOfClass("Humanoid"))

                        if not isEquipped then
                            local itemRoot = toolCandidate:FindFirstChild("ItemRoot")
                                or toolCandidate:FindFirstChild("Handle")
                                or toolCandidate:FindFirstChildWhichIsA("MeshPart")
                                or toolCandidate:FindFirstChildWhichIsA("BasePart")

                            local prompt = toolCandidate:FindFirstChildOfClass("ProximityPrompt", true)
                            local nameLower = toolCandidate.Name:lower()

                            local isFake = nameLower:find("fake") ~= nil
                                or toolCandidate:GetAttribute("Fake") == true
                                or toolCandidate:GetAttribute("Trap") == true

                            local itemType = nil
                            if nameLower:find("cola") or nameLower:find("bloxiade") then
                                itemType = "Bloxy Cola"
                            elseif nameLower:find("medkit") then
                                itemType = isFake and "Fake Medkit" or "Medkit"
                            end

                            if itemType and itemRoot then
                                seen[toolCandidate] = true
                                table.insert(itmList, {
                                    Instance = toolCandidate,
                                    Root     = itemRoot,
                                    Prompt   = prompt,
                                    Name     = itemType,
                                    IsFake   = isFake,
                                })
                            end
                        end
                    end
                end
            end
        end

        ItemsList = itmList
    end

    local function ClearAllItemVisuals()
        for _, bg in pairs(ItemCache) do
            if bg.Gui then pcall(function() bg.Gui:Destroy() end) end
        end
        table.clear(ItemCache)
        ItemsList = {}
    end

    RunService.Heartbeat:Connect(function()
        local cam = Workspace.CurrentCamera or Workspace:FindFirstChildOfClass("Camera")
        if not cam then return end

        local map = Workspace:FindFirstChild("Map")
        local curIngame = map and map:FindFirstChild("Ingame")
        if curIngame ~= lastIngame then
            lastIngame = curIngame
            ClearAllItemVisuals()
        end

        if not ItemConfig.Enabled then
            for _, bg in pairs(ItemCache) do
                if bg.Gui then
                    bg.Gui.Enabled = false
                    bg.Gui.Adornee = nil
                end
            end
            return
        end

        local now = tick()
        if now - lastScan >= 0.5 then
            lastScan = now
            UpdateItemsList()
        end

        local myRoot    = LP.Character and GetRoot(LP.Character)
        local originPos = myRoot and myRoot.Position or cam.CFrame.Position
        local activeItems = {}

        for _, itm in ipairs(ItemsList) do
            if itm.Root and itm.Root.Parent and itm.Instance and itm.Instance.Parent then
                local distStuds = (originPos - itm.Root.Position).Magnitude
                if distStuds <= (200 * 3.57) then
                    activeItems[itm.Instance] = true

                    local bg = ItemCache[itm.Instance]
                    if not bg or not bg.Gui.Parent then
                        local bGui = Instance.new("BillboardGui")
                        bGui.Name            = "Doom_Item_ESP"
                        bGui.Size            = UDim2.fromOffset(200, 20)
                        bGui.AlwaysOnTop     = true
                        bGui.LightInfluence  = 0
                        bGui.StudsOffset     = Vector3.new(0, 1.4, 0)
                        bGui.ResetOnSpawn    = false
                        bGui.Parent          = ItemVisualGUI

                        local lbl = Instance.new("TextLabel", bGui)
                        lbl.Size                   = UDim2.fromScale(1, 1)
                        lbl.BackgroundTransparency = 1
                        lbl.Font                   = Enum.Font.GothamBold
                        lbl.TextSize               = 12
                        lbl.TextStrokeTransparency = 0
                        lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)

                        ItemCache[itm.Instance] = { Gui = bGui, Label = lbl }
                        bg = ItemCache[itm.Instance]
                    end

                    bg.Gui.Enabled = true
                    bg.Gui.Adornee = itm.Root

                    local mainColor
                    if itm.IsFake then
                        mainColor = Color3.fromRGB(255, 50, 50)
                    elseif itm.Name == "Bloxy Cola" then
                        mainColor = Color3.fromRGB(255, 195, 45)
                    else
                        mainColor = ItemConfig.Color
                    end

                    local distM = math.floor(distStuds / 3.57)
                    local displayName = itm.Name
                    if displayName == "Bloxy Cola" then displayName = "可乐"
                    elseif displayName == "Medkit" then displayName = "医疗包"
                    elseif displayName == "Fake Medkit" then displayName = "假医疗包"
                    end

                    local textStr = "[" .. displayName:upper() .. "]"
                    if ItemConfig.ShowDist then
                        textStr = textStr .. " • " .. distM .. "m"
                    end

                    bg.Label.TextColor3 = mainColor
                    bg.Label.Text       = textStr
                end
            end
        end

        for inst, cacheObj in pairs(ItemCache) do
            if not activeItems[inst] then
                if cacheObj.Gui then
                    cacheObj.Gui.Enabled = false
                    cacheObj.Gui.Adornee = nil
                end
                if not inst.Parent or not inst:FindFirstChild("ItemRoot") then
                    if cacheObj.Gui then pcall(function() cacheObj.Gui:Destroy() end) end
                    ItemCache[inst] = nil
                end
            end
        end
    end)

    Feng:Toggle({
        Name = "启用物品透视",
        Value = false,
        Callback = function(v)
            ItemConfig.Enabled = v
            if not v then
                for _, bg in pairs(ItemCache) do
                    if bg.Gui then
                        bg.Gui.Enabled = false
                        bg.Gui.Adornee = nil
                    end
                end
            end
        end
    })

    Feng:Toggle({
        Name = "显示距离",
        Value = true,
        Callback = function(v) ItemConfig.ShowDist = v end
    })

    Feng:Colorpicker({
        Name = "物品透视颜色",
        Default = Color3.fromRGB(255, 200, 50),
        Transparency = 0.2,
        Callback = function(color) ItemConfig.Color = color end
    })
end

local FengYu = Window:Tab("物品区", "83701039519151")

local Feng = FengYu:Section({
    Name = "物品互动",
    SubName = "瞬移这一块",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local autoTeleportMedkitEnabled = false
    local teleportMedkitThread = nil

    Feng:Toggle({
        Name = "医疗包传送并互动",
        Value = false,
        Callback = function(state)
            autoTeleportMedkitEnabled = state

            if autoTeleportMedkitEnabled then
                teleportMedkitThread = task.spawn(function()
                    while autoTeleportMedkitEnabled and task.wait(0.5) do
                        local character = game.Players.LocalPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local humanoidRootPart = character.HumanoidRootPart
                            local medkit = workspace:FindFirstChild("Map", true)
                            if medkit then
                                medkit = medkit:FindFirstChild("Ingame", true)
                                if medkit then
                                    medkit = medkit:FindFirstChild("Medkit", true)
                                    if medkit then
                                        local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                        if itemRoot then
                                            itemRoot.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 3
                                            local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                            if prompt then fireproximityprompt(prompt) end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif teleportMedkitThread then
                task.cancel(teleportMedkitThread)
                teleportMedkitThread = nil
            end
        end
    })

    local autoTeleportColaEnabled = false
    local teleportColaThread = nil

    Feng:Toggle({
        Name = "可乐传送并互动",
        Value = false,
        Callback = function(state)
            autoTeleportColaEnabled = state

            if autoTeleportColaEnabled then
                teleportColaThread = task.spawn(function()
                    while autoTeleportColaEnabled and task.wait(0.5) do
                        local character = game.Players.LocalPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            local humanoidRootPart = character.HumanoidRootPart
                            local cola = workspace:FindFirstChild("Map", true)
                            if cola then
                                cola = cola:FindFirstChild("Ingame", true)
                                if cola then
                                    cola = cola:FindFirstChild("BloxyCola", true)
                                    if cola then
                                        local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                        if itemRoot then
                                            itemRoot.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.LookVector * 3
                                            local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                            if prompt then fireproximityprompt(prompt) end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif teleportColaThread then
                task.cancel(teleportColaThread)
                teleportColaThread = nil
            end
        end
    })

    local autoMedkitEnabled = false
    local medkitThread = nil

    Feng:Toggle({
        Name = "自动互动医疗包",
        Value = false,
        Callback = function(state)
            autoMedkitEnabled = state

            if autoMedkitEnabled then
                medkitThread = task.spawn(function()
                    while autoMedkitEnabled and task.wait(0.5) do
                        local medkit = workspace:FindFirstChild("Map", true)
                        if medkit then
                            medkit = medkit:FindFirstChild("Ingame", true)
                            if medkit then
                                medkit = medkit:FindFirstChild("Medkit", true)
                                if medkit then
                                    local itemRoot = medkit:FindFirstChild("ItemRoot", true)
                                    if itemRoot then
                                        local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                        if prompt then fireproximityprompt(prompt) end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif medkitThread then
                task.cancel(medkitThread)
                medkitThread = nil
            end
        end
    })

    local autoColaEnabled = false
    local colaThread = nil

    Feng:Toggle({
        Name = "自动互动可乐",
        Value = false,
        Callback = function(state)
            autoColaEnabled = state

            if autoColaEnabled then
                colaThread = task.spawn(function()
                    while autoColaEnabled and task.wait(0.5) do
                        local cola = workspace:FindFirstChild("Map", true)
                        if cola then
                            cola = cola:FindFirstChild("Ingame", true)
                            if cola then
                                cola = cola:FindFirstChild("BloxyCola", true)
                                if cola then
                                    local itemRoot = cola:FindFirstChild("ItemRoot", true)
                                    if itemRoot then
                                        local prompt = itemRoot:FindFirstChild("ProximityPrompt", true)
                                        if prompt then fireproximityprompt(prompt) end
                                    end
                                end
                            end
                        end
                    end
                end)
            elseif colaThread then
                task.cancel(colaThread)
                colaThread = nil
            end
        end
    })
end

local sectionItem = FengYu:Section({
    Name = "道具功能",
    SubName = "各种道具相关",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local _Players = game:GetService("Players")
    local _RunService = game:GetService("RunService")
    local _ReplicatedStorage = game:GetService("ReplicatedStorage")
    local _localPlayer = _Players.LocalPlayer
    local _assets = _ReplicatedStorage:FindFirstChild("Assets") or _ReplicatedStorage:WaitForChild("Assets", 10)
    local _modules = _ReplicatedStorage:FindFirstChild("Modules") or _ReplicatedStorage:WaitForChild("Modules", 10)

    local _remoteEvent = nil
    if _modules then
        local _network = _modules:FindFirstChild("Network") or _modules:WaitForChild("Network", 10)
        if _network then
            _remoteEvent = _network:FindFirstChild("RemoteEvent")
                or _modules:FindFirstChild("RemoteEvent", true)
        end
    end

    local TrollState = { InfiniteCola = false }

    local tbl21 = {
        Level      = buffer.fromstring(string.pack("<Bd", 2, 2)),
        Duration   = buffer.fromstring(string.pack("<Bd", 2, 10)),
        MaxLevel   = buffer.fromstring(string.pack("<Bd", 2, 10)),
        SpeedName  = buffer.fromstring(string.pack("<Bs4", 3, "Speed")),
        ColaName   = buffer.fromstring(string.pack("<Bs4", 3, "BloxyCola")),
        Desc       = buffer.fromstring(string.pack("<Bs4", 3,
            "Increases your movement speed.\nEvery level of this status increases speed by 10%.")),
        Stackable  = buffer.fromstring("\1\0"),
        Applied    = buffer.fromstring("\0"),
        TimePast   = buffer.fromstring("\2\0\0\0\0\0\0\0\0"),
    }

    local flag4 = false

    local function fn21()
        if flag4 then return end

        local ok, result = pcall(function()
            return require(_assets.Items.BloxyCola.Behavior)
        end)

        if not ok then
            local bloxyCola = _assets.Items:FindFirstChild("BloxyCola")
            bloxyCola = bloxyCola and bloxyCola:FindFirstChild("Behavior")
            if bloxyCola then
                ok, result = pcall(require, bloxyCola)
            end
        end

        if not (ok and type(result) == "table" and type(result.Activated) == "function") then
            return
        end

        local activated = result.Activated

        result.Activated = function(arg, ...)
            if _RunService:IsServer() or not TrollState.InfiniteCola then
                return activated(arg, ...)
            end

            activated(arg, ...)
            local drinkTime = arg.Config and arg.Config.DrinkTime or 1.5

            task.spawn(function()
                task.wait(drinkTime - 0.5)
                if not TrollState.InfiniteCola then return end

                if firesignal then
                    firesignal(_remoteEvent.OnClientEvent, 3, {
                        tbl21.SpeedName,
                        {
                            Removed = tbl21.Applied,
                            Data = {
                                MaxLevel    = tbl21.MaxLevel,
                                Description = tbl21.Desc,
                                Duration    = tbl21.Duration,
                                Level       = tbl21.Level,
                                AppliedFrom = tbl21.ColaName,
                                Stackable   = tbl21.Stackable,
                            },
                            Character    = _localPlayer.Character,
                            Player       = _localPlayer,
                            TimePast     = tbl21.TimePast,
                            Applied      = tbl21.Applied,
                            Level        = tbl21.Level,
                            AppliedFrom  = tbl21.ColaName,
                            TimeRequired = tbl21.Duration,
                        },
                        {
                            MaxLevel    = tbl21.MaxLevel,
                            Description = tbl21.Desc,
                            Duration    = tbl21.Duration,
                            Level       = tbl21.Level,
                            AppliedFrom = tbl21.ColaName,
                            Stackable   = tbl21.Stackable,
                        },
                    })
                end

                local character = _localPlayer.Character
                character = character and character:FindFirstChildOfClass("Humanoid")
                if character then
                    character:UnequipTools()
                end
            end)
        end

        flag4 = true
    end

    sectionItem:Toggle({
        Name = "无限喝可乐",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(infiniteCola)
            TrollState.InfiniteCola = infiniteCola
            if infiniteCola then
                fn21()
            end
        end,
    })
end

Window:TabDivider()
local FengYu = Window:Tab("发电机", "83701039519151")

local Feng = FengYu:Section({
    Name = "发电机系统",
    SubName = "闪电速度",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
    {
        Key = "ge",
        Name = "基础发电机功能",
    },
    {
        Key = "se",
        Name = "发电机设置",
    },
})

local vu2 = { autoRepairActive = false }
local vu4 = { repairCheckInterval = 1.5 }

Feng.ge:Toggle({
    Name = "（旧）自动修复发电机",
    Value = false,
    Callback = function(value) vu2.autoRepairActive = value end
})

do
    local function findNearestGenerator()
        local character = game.Players.LocalPlayer.Character
        if not character then return nil end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return nil end

        local generators = {}
        local map = workspace:FindFirstChild("Map")
        if map then
            local ingame = map:FindFirstChild("Ingame")
            if ingame then
                local mapFolder = ingame:FindFirstChild("Map")
                if mapFolder then
                    for _, obj in pairs(mapFolder:GetChildren()) do
                        if obj.Name == "Generator" then
                            table.insert(generators, obj)
                        end
                    end
                end
            end
        end

        local nearest, nearestDist = nil, math.huge
        for _, gen in pairs(generators) do
            local part = gen:FindFirstChildWhichIsA("BasePart")
            if part then
                local dist = (root.Position - part.Position).Magnitude
                if dist < nearestDist then
                    nearest, nearestDist = gen, dist
                end
            end
        end
        return nearest
    end

    local function repairGenerator(generator)
        if not generator then return false end
        local remotes = generator:FindFirstChild("Remotes")
        if remotes then
            local re = remotes:FindFirstChild("RE")
            if re and re:IsA("RemoteEvent") then
                re:FireServer()
                return true
            end
        end
        return false
    end

    spawn(function()
        while wait() do
            if vu2.autoRepairActive then
                local generator = findNearestGenerator()
                if generator then
                    repairGenerator(generator)
                    wait(vu4.repairCheckInterval)
                end
            end
            wait(0.1)
        end
    end)
end

do
    local Players           = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace         = game:GetService("Workspace")
    local LocalPlayer       = Players.LocalPlayer

    local GameState       = 0
    local RoundGenerators = {}
    local CurrentPuzzle   = nil
    local CompletingAll   = false

    local Config = {
        AutoCompleteGenerators  = false,
        GeneratorHelper         = false,
        InstantlyEnterGenerator = false,
        AutoGeneratorFarm       = false,
        PuzzleDelay             = 0.08,
        LegitPuzzles            = false,
        LegitPuzzleDelay        = 0.08,
        SelectedGenerator       = 1,
    }

    local function IsKiller()
        local char = LocalPlayer.Character
        if not char then return false end
        local pf = Workspace:FindFirstChild("Players")
        local kf = pf and pf:FindFirstChild("Killers")
        return kf ~= nil and char.Parent == kf
    end

    local function GetPlayersFolder() return Workspace:FindFirstChild("Players") end
    local function GetSurvivorsFolder()
        local pf = GetPlayersFolder()
        return pf and pf:FindFirstChild("Survivors")
    end
    local function GetKillersFolder()
        local pf = GetPlayersFolder()
        return pf and pf:FindFirstChild("Killers")
    end

    local function GetGameMap()
        local map    = Workspace:FindFirstChild("Map")
        local ingame = map and map:FindFirstChild("Ingame")
        return ingame and ingame:FindFirstChild("Map")
    end

    local function UpdateGenerators()
        local gameMap = GetGameMap()
        if not gameMap then RoundGenerators = {} return end
        local gens = {}
        for _, obj in ipairs(gameMap:GetChildren()) do
            if obj.Name == "Generator" then table.insert(gens, obj) end
        end
        RoundGenerators = gens
    end

    task.spawn(function()
        while task.wait(0.3) do UpdateGenerators() end
    end)

    local function WaitGenerators(timeout)
        local t0 = tick()
        timeout = timeout or 15
        while tick() - t0 < timeout do
            if #RoundGenerators >= 5 then return true end
            task.wait(0.3)
        end
        return #RoundGenerators > 0
    end

    local function GetClosestGenerator(returnIndex)
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        for i, gen in ipairs(RoundGenerators) do
            local pos    = gen:FindFirstChild("Positions")
            local center = pos and pos:FindFirstChild("Center")
            if center and (center.Position - root.Position).Magnitude <= 7 then
                return returnIndex and i or gen
            end
        end
        return nil
    end

    local function IsPlayerNearGenerator(gen)
        if not gen then return false end
        local pos    = gen:FindFirstChild("Positions")
        local center = pos and pos:FindFirstChild("Center")
        if not center then return false end
        local function scan(folder)
            if not folder then return false end
            for _, p in ipairs(folder:GetChildren()) do
                if p:GetAttribute("Username") ~= LocalPlayer.Name then
                    local root = p:FindFirstChild("HumanoidRootPart")
                    if root and (center.Position - root.Position).Magnitude <= 40 then
                        return true
                    end
                end
            end
            return false
        end
        return scan(GetSurvivorsFolder()) or scan(GetKillersFolder())
    end

    task.spawn(function()
        while task.wait(0.3) do
            local pf = GetPlayersFolder()
            local spec = pf and pf:FindFirstChild("Spectating")
            if spec and spec:FindFirstChild(LocalPlayer.Name) then
                GameState = 0
            elseif LocalPlayer.Character and LocalPlayer.Character.Parent then
                GameState = 1
            end
        end
    end)

    local function IsNeighbour(r1, c1, r2, c2)
        return (r2 == r1 - 1 and c2 == c1) or (r2 == r1 + 1 and c2 == c1)
            or (r2 == r1 and c2 == c1 - 1) or (r2 == r1 and c2 == c1 + 1)
    end

    local function KeyOf(p) return p.row .. '-' .. p.col end

    local function OrderPath(path, startPair)
        if not path or #path == 0 then return path end
        local start = (startPair and startPair[1]) or path[1]
        local lookup = {}
        for _, p in ipairs(path) do
            lookup[KeyOf(p)] = { row = p.row, col = p.col }
        end
        local ordered = {}
        local cur = { row = start.row, col = start.col }
        table.insert(ordered, cur)
        lookup[KeyOf(cur)] = nil
        while next(lookup) do
            local advanced = false
            for k, v in pairs(lookup) do
                if IsNeighbour(cur.row, cur.col, v.row, v.col) then
                    table.insert(ordered, v)
                    lookup[k] = nil
                    cur = v
                    advanced = true
                    break
                end
            end
            if not advanced then break end
        end
        return ordered
    end

    local function AutoGenerator(puzzle, force)
        if not puzzle or not puzzle.Solution then return end
        for i = 1, #puzzle.Solution do
            local path       = puzzle.Solution[i]
            local targetPair = puzzle.targetPairs and puzzle.targetPairs[i]
            local ordered    = OrderPath(path, targetPair)
            puzzle.paths[i]  = {}
            for _, p in ipairs(ordered) do
                if not force and not Config.AutoCompleteGenerators then return end
                table.insert(puzzle.paths[i], { row = p.row, col = p.col })
                pcall(function() puzzle:updateGui() end)
                if Config.LegitPuzzles then
                    local g = GetClosestGenerator()
                    if g and IsPlayerNearGenerator(g) then
                        task.wait(Config.LegitPuzzleDelay)
                    else
                        task.wait(Config.PuzzleDelay)
                    end
                else
                    task.wait(Config.PuzzleDelay)
                end
            end
            pcall(function() puzzle:checkForWin() end)
        end
    end

    local function DrawSolutions(puzzle)
        local gridFrame = puzzle.gridFrame
        if not gridFrame then return end
        local overlay = Instance.new("Frame", gridFrame.Parent)
        overlay.ZIndex                 = 6
        overlay.BackgroundTransparency = 1
        overlay.Size                   = gridFrame.Size
        overlay.AnchorPoint            = Vector2.new(0.5, 0.5)
        overlay.Position               = UDim2.fromScale(0.5, 0.5)
        local cellSize = 0.1
        pcall(function()
            cellSize = LocalPlayer.PlayerGui.PuzzleUI.Container.GridHolder.Grid.UIGridLayout.CellSize.X.Scale
        end)
        for i = 1, #puzzle.Solution do
            local path       = puzzle.Solution[i]
            local targetPair = puzzle.targetPairs and puzzle.targetPairs[i]
            local ordered    = OrderPath(path, targetPair)
            for _, p in ipairs(ordered) do
                local cell = Instance.new("Frame", overlay)
                cell.BorderSizePixel        = 0
                cell.BackgroundTransparency = 0.7
                cell.Size                   = UDim2.fromScale(cellSize, cellSize)
                cell.ZIndex                 = 7
                local col = (puzzle.colors and puzzle.colors[i]) or Color3.new(1, 1, 1)
                cell.BackgroundColor3       = Color3.new(col.R / 1.2, col.G / 1.2, col.B / 1.2)
                cell.Position               = UDim2.fromScale(cellSize * (p.col - 1), cellSize * (p.row - 1))
            end
            pcall(function() puzzle:checkForWin() end)
        end
    end

    pcall(function()
        local FlowGameMod = require(ReplicatedStorage.Modules.Minigames.FlowGameManager.FlowGame)
        local original    = FlowGameMod.new
        local hooked
        hooked = hookfunction(original, newcclosure(function(...)
            local puzzle  = hooked(...)
            CurrentPuzzle = puzzle
            if Config.GeneratorHelper then
                pcall(DrawSolutions, puzzle)
            end
            if Config.AutoCompleteGenerators then
                task.spawn(function()
                    pcall(AutoGenerator, puzzle)
                end)
            end
            return puzzle
        end))
    end)

    task.spawn(function()
        while task.wait(0.1) do
            for _, gen in ipairs(RoundGenerators) do
                local main   = gen:FindFirstChild("Main")
                local prompt = main and main:FindFirstChild("Prompt")
                if prompt then
                    prompt.HoldDuration = Config.InstantlyEnterGenerator and 0 or 0.25
                end
            end
        end
    end)

    local function CompleteGenerators()
        if CompletingAll then return end
        if IsKiller() then return end
        CompletingAll = true
        task.spawn(function()
            WaitGenerators(20)
            if #RoundGenerators == 0 then
                CompletingAll = false
                return
            end
            for _, gen in ipairs(RoundGenerators) do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                local function occupied(pos)
                    local surv = GetSurvivorsFolder()
                    if not surv then return false end
                    for _, p in ipairs(surv:GetChildren()) do
                        local pr = p:FindFirstChild("HumanoidRootPart")
                        if pr and p ~= char and (pr.Position - pos).Magnitude <= 6 then
                            return true
                        end
                    end
                    return false
                end
                task.wait(0.3)
                local prog = gen:FindFirstChild("Progress")
                if not prog or prog.Value == 100 then continue end
                local main   = gen:FindFirstChild("Main")
                local prompt = main and main:FindFirstChild("Prompt")
                if not prompt then continue end
                local t0  = tick()
                local pos = gen:FindFirstChild("Positions")
                if not pos then continue end
                local occC = occupied(pos.Center.Position)
                local occR = occupied(pos.Right.Position)
                local occL = occupied(pos.Left.Position)
                if occC and occR and occL then continue end
                if not occC then
                    root.CFrame = pos.Center.CFrame
                elseif not occR then
                    root.CFrame = pos.Right.CFrame
                else
                    root.CFrame = pos.Left.CFrame
                end
                char.Humanoid:MoveTo(main.Position)
                repeat
                    fireproximityprompt(prompt)
                    task.wait(0.5)
                until tick() - t0 >= 7 or LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")
                if tick() - t0 >= 7 then continue end
                task.wait(0.4)
                local puzzleUI = LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI")
                if not (puzzleUI and puzzleUI.Enabled) then continue end
                task.spawn(function()
                    local lastPuzzle
                    while task.wait() and gen:FindFirstChild("Progress")
                          and gen.Progress.Value ~= 100
                          and LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI") do
                        if CurrentPuzzle == lastPuzzle then continue end
                        lastPuzzle = CurrentPuzzle
                        if not Config.AutoCompleteGenerators then
                            pcall(AutoGenerator, CurrentPuzzle, true)
                        end
                    end
                end)
                repeat task.wait() until
                    (not gen:FindFirstChild("Progress"))
                    or gen.Progress.Value == 100
                    or (not LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI"))
            end
            CompletingAll = false
        end)
    end

    Feng.ge:Toggle({
        Name = "自动绘制修机",
        Value = false,
        Callback = function(v) Config.AutoCompleteGenerators = v end
    })

    Feng.ge:Toggle({
        Name = "发电机助手",
        Value = false,
        Callback = function(v) Config.GeneratorHelper = v end
    })

    Feng.ge:Toggle({
        Name = "瞬间进入发电机",
        Value = false,
        Callback = function(v) Config.InstantlyEnterGenerator = v end
    })

    Feng.ge:Toggle({
        Name = "自动完成所有发电机",
        Value = false,
        Callback = function(v)
            Config.AutoGeneratorFarm = v
            if v then CompleteGenerators() end
        end
    })

    Feng.ge:Button({
        Name = "完成当前发电机",
        Callback = function()
            if not LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI") then return end
            task.spawn(function()
                local gen = GetClosestGenerator()
                if not gen then return end
                local lastPuzzle
                while task.wait() and gen:FindFirstChild("Progress")
                      and gen.Progress.Value ~= 100
                      and LocalPlayer.PlayerGui:FindFirstChild("PuzzleUI") do
                    if CurrentPuzzle == lastPuzzle then continue end
                    lastPuzzle = CurrentPuzzle
                    if not Config.AutoCompleteGenerators then
                        pcall(AutoGenerator, CurrentPuzzle, true)
                    end
                end
            end)
        end
    })

    local pf = GetPlayersFolder()
    local survConn
    local function bindSurv()
        local surv = pf and pf:FindFirstChild("Survivors")
        if surv and not survConn then
            survConn = surv.ChildAdded:Connect(function(c)
                if c:GetAttribute("Username") ~= LocalPlayer.Name then return end
                task.spawn(function()
                    WaitGenerators(15)
                    if Config.AutoGeneratorFarm then CompleteGenerators() end
                end)
            end)
        end
    end
    if pf then
        bindSurv()
        pf.ChildAdded:Connect(function(c)
            if c.Name == "Survivors" then bindSurv() end
        end)
    end

    Feng.ge:Divider({ Name = "传送" })

    Feng.ge:Dropdown({
        Name = "选择发电机",
        Values = { "1", "2", "3", "4", "5" },
        Value = "1",
        Callback = function(v)
            Config.SelectedGenerator = tonumber(tostring(v):sub(1, 1)) or 1
        end
    })

    Feng.ge:Button({
        Name = "传送到发电机",
        Callback = function()
            local gen  = RoundGenerators[Config.SelectedGenerator]
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if gen and root then
                local pos    = gen:FindFirstChild("Positions")
                local center = pos and pos:FindFirstChild("Center")
                if center then root.CFrame = center.CFrame end
            end
        end
    })

    Feng.se:Slider({
        Name = "解谜速度",
        Value = { Min = 0.02, Max = 1, Default = 0.07 },
        Rounding = 2,
        Callback = function(v) Config.PuzzleDelay = v end
    })

    Feng.se:Toggle({
        Name = "玩家在附近时使用正常延迟",
        Value = false,
        Callback = function(v) Config.LegitPuzzles = v end
    })

    Feng.se:Slider({
        Name = "（正常）解谜速度",
        Value = { Min = 0.02, Max = 2, Default = 0.1 },
        Rounding = 2,
        Callback = function(v) Config.LegitPuzzleDelay = v end
    })
end

local FengYu = Window:Tab("幸存者", "83701039519151")

local Feng = FengYu:Section({
    Name = "机会",
    SubName = "机会瞄准",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local CoinflipSettings = { Enabled = false, TargetCharge = 3 }
    local lastCoinflipTime = 0
    local coinflipCooldown = 2

    local function readCoinflipChargesText()
        local ok, txt = pcall(function()
            local mainUI = game.Players.LocalPlayer:FindFirstChild("PlayerGui") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("MainUI")
            if not mainUI then return nil end
            local abil = mainUI:FindFirstChild("AbilityContainer")
            if not abil then return nil end
            local coin = abil:FindFirstChild("Reroll")
            if not coin then return nil end
            local chargesLabel = coin:FindFirstChild("Charges")
            if not chargesLabel then return nil end
            return tostring(chargesLabel.Text)
        end)
        if ok then return txt end
        return nil
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if not CoinflipSettings.Enabled then continue end
            local now = tick()
            if now - lastCoinflipTime < coinflipCooldown then continue end

            local isChance = false
            local playersFolder = workspace:FindFirstChild("Players")
            local survFolder = playersFolder and playersFolder:FindFirstChild("Survivors")
            if survFolder then
                for _, surv in ipairs(survFolder:GetChildren()) do
                    if surv:GetAttribute("Username") == game.Players.LocalPlayer.Name and surv.Name == "Chance" then
                        isChance = true
                        break
                    end
                end
            end
            if not isChance then continue end

            local charges = tonumber(readCoinflipChargesText())
            if charges and charges < CoinflipSettings.TargetCharge then
                lastCoinflipTime = now
                pcall(function()
                    local args = {
                        "UseActorAbility",
                        { buffer.fromstring("\003\b\000\000\000CoinFlip") }
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                end)
            end
        end
    end)

    local ChanceAimbot = { Enabled = false, Prediction = false, Range = 100 }
    local oneShootAnims = {"73921036900313", "111384272984267", "90499469533503", "133491532453922"}

    local function isFlintlockVisible(char)
        if not char then return false end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and (string.lower(tool.Name):find("flintlock") or string.lower(tool.Name):find("revolver") or string.lower(tool.Name):find("gun")) then
            return true
        end
        local flint = char:FindFirstChild("Flintlock", true)
        if not flint then return false end
        if not (flint:IsA("BasePart") or flint:IsA("MeshPart") or flint:IsA("UnionOperation")) then
            flint = flint:FindFirstChildWhichIsA("BasePart", true)
            if not flint then return false end
        end
        return flint.Transparency < 1
    end

    local chanceKillersCache = {}
    local function updateChanceKillers()
        local playersFolder = workspace:FindFirstChild("Players")
        if playersFolder then
            local kFolder = playersFolder:FindFirstChild("Killers")
            if kFolder then
                local list = {}
                for _, k in ipairs(kFolder:GetChildren()) do
                    if k:GetAttribute("Username") then table.insert(list, k) end
                end
                chanceKillersCache = list
            end
        end
    end

    task.spawn(function()
        while true do
            updateChanceKillers()
            task.wait(0.25)
        end
    end)

    local function isLocalPlayerChance()
        local char = game.Players.LocalPlayer.Character
        if not char then return false end
        local survivorsFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
        if not survivorsFolder then return false end
        for _, surv in ipairs(survivorsFolder:GetChildren()) do
            if surv == char and surv.Name == "Chance" then return true end
        end
        return false
    end

    local function isOneShootAnimating(char)
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local id = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                if id then
                    for _, animId in ipairs(oneShootAnims) do
                        if id == animId then return true end
                    end
                end
            end
        end
        return false
    end

    task.spawn(function()
        while true do
            task.wait(0.05)
            if not ChanceAimbot.Enabled then continue end
            local lp = game.Players.LocalPlayer
            local char = lp.Character
            if not char then continue end
            if not isLocalPlayerChance() then continue end

            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then continue end

            local isShooting = isOneShootAnimating(char) or isFlintlockVisible(char)
            if not isShooting then continue end

            local target = nil
            local shortestDist = ChanceAimbot.Range
            for _, killer in ipairs(chanceKillersCache) do
                local kRoot = killer:FindFirstChild("HumanoidRootPart")
                if kRoot then
                    local dist = (kRoot.Position - root.Position).Magnitude
                    if dist <= shortestDist then
                        shortestDist = dist
                        target = kRoot
                    end
                end
            end

            if target then
                local targetPos = target.Position
                if ChanceAimbot.Prediction then
                    local velocity = target.Velocity or target.AssemblyLinearVelocity
                    if velocity then
                        local ping = 0
                        pcall(function() ping = lp:GetNetworkPing() end)
                        local dist = (target.Position - root.Position).Magnitude
                        local raycastSpeed = 1000
                        local raycastDelay = dist / raycastSpeed
                        local totalDelay = ping + raycastDelay
                        local dropoff = math.clamp(dist / ChanceAimbot.Range, 0.1, 1)
                        local distanceBoost = 1 + (dist / ChanceAimbot.Range) * 0.25
                        local predictionFactor = totalDelay * 1.2 * dropoff * distanceBoost
                        targetPos = targetPos + (velocity * predictionFactor)
                    end
                end
                root.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
            end
        end
    end)

    Feng:Toggle({
        Name = "启用机会射击自瞄",
        Value = false,
        Callback = function(v) ChanceAimbot.Enabled = v end
    })

    Feng:Toggle({
        Name = "瞄准预测",
        Value = false,
        Callback = function(v) ChanceAimbot.Prediction = v end
    })

    Feng:Slider({
        Name = "射击半径",
        Value = { Min = 20, Max = 1000, Default = 100 },
        Callback = function(v) ChanceAimbot.Range = v end
    })

    Feng:Divider()

    Feng:Toggle({
        Name = "自动抛硬币翻转",
        Value = false,
        Callback = function(v) CoinflipSettings.Enabled = v end
    })

    Feng:Dropdown({
        Name = "硬币充能层数",
        Values = {"1", "2", "3"},
        Value = "3",
        Multi = false,
        Callback = function(val) CoinflipSettings.TargetCharge = tonumber(val) end
    })
end

local Feng = FengYu:Section({
    Name = "两次",
    SubName = "背刺",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local DEFAULT_PROXIMITY   = 8
    local DEFAULT_DURATION    = 0.45
    local BEHIND_DISTANCE     = 3.5
    local CHECK_INTERVAL      = 0.05
    local COOLDOWN            = 5
    local LERP_SPEED          = 0.55
    local BEHIND_CONE_DEGREES = 70
    local REMOTE_FIRE_DELAY   = 0.0
    local AIM_SNAP_DELAY      = 0.25
    local DEBUG_LINE          = true

    local isRunning     = true
    local enabled       = false
    local daggerEnabled = false
    local rangeMode     = "Behind"
    local backstabType  = "Lerp"
    local proximity     = DEFAULT_PROXIMITY
    local lastTrigger   = 0
    local aimRefCount   = 0
    local debugBeam     = nil

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local clientPlayer = Players.LocalPlayer

    local function getCharacter()
        return clientPlayer.Character or clientPlayer.CharacterAdded:Wait()
    end

    local function getDaggerButton()
        local pg = clientPlayer:FindFirstChild("PlayerGui")
        if not pg then return nil end
        local mainUI = pg:FindFirstChild("MainUI")
        if not mainUI then return nil end
        local container = mainUI:FindFirstChild("AbilityContainer")
        if not container then return nil end
        return container:FindFirstChild("Dagger")
    end

    local function getDaggerCooldown()
        local btn = getDaggerButton()
        if not btn then return nil end
        return btn:FindFirstChild("CooldownTime") or btn:FindFirstChild("Cooldown") or
               btn:FindFirstChildWhichIsA("NumberValue") or btn:FindFirstChildWhichIsA("StringValue") or
               btn:FindFirstChild("CooldownLabel") or btn:FindFirstChild("Timer") or btn:FindFirstChild("CD")
    end

    local function readCooldownValue(cdObj)
        if not cdObj then return nil end
        if cdObj:IsA("NumberValue")  then return cdObj.Value end
        if cdObj:IsA("StringValue")  then return tonumber(cdObj.Value) end
        if cdObj:IsA("TextLabel") or cdObj:IsA("TextBox") then return tonumber(cdObj.Text) end
        if type(cdObj.Value) == "number" then return cdObj.Value end
        if type(cdObj.Value) == "string" then return tonumber(cdObj.Value) end
        if cdObj.Text ~= nil then return tonumber(cdObj.Text) end
        return nil
    end

    local function getKillersFolder()
        local playersFolder = Workspace:FindFirstChild("Players")
        if not playersFolder then return nil end
        return playersFolder:FindFirstChild("Killers")
    end

    local function isValidKillerModel(model)
        if not model then return false end
        local hrp      = model:FindFirstChild("HumanoidRootPart")
        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
        return hrp and humanoid and humanoid.Health and humanoid.Health > 0
    end

    local function tryActivateButton(btn)
        if not btn then return false end
        pcall(function() if btn.Activate then btn:Activate() end end)
        local ok, conns = pcall(function()
            if type(getconnections) == "function" and btn.MouseButton1Click then
                return getconnections(btn.MouseButton1Click)
            end
            return nil
        end)
        if ok and conns then
            for _, conn in ipairs(conns) do
                pcall(function()
                    if conn.Function then conn.Function()
                    elseif conn.func  then conn.func()
                    elseif conn.Fire  then conn.Fire() end
                end)
            end
        end
        pcall(function() if btn.Activated then btn.Activated:Fire() end end)
        return true
    end

    local function setAutoRotate(value)
        local char = clientPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then pcall(function() hum.AutoRotate = value end) end
    end

    local function isPlayerBehindKiller(hrp, khrp, dist)
        if dist > proximity or dist < 0.01 then return false end
        local toPlayer = (hrp.Position - khrp.Position).Unit
        local killerBack = -khrp.CFrame.LookVector
        local dot = toPlayer:Dot(killerBack)
        local threshold = math.cos(math.rad(BEHIND_CONE_DEGREES))
        return dot >= threshold
    end

    local function removeDebugLine()
        if debugBeam then
            pcall(function() debugBeam:Destroy() end)
            debugBeam = nil
        end
    end

    local function drawDebugLine(hrp, khrp, isValid)
        if not DEBUG_LINE then removeDebugLine(); return end
        pcall(function()
            local att0 = hrp:FindFirstChild("__BSAtt0") or Instance.new("Attachment", hrp)
            att0.Name = "__BSAtt0"
            att0.Position = Vector3.zero

            local att1 = khrp:FindFirstChild("__BSAtt1") or Instance.new("Attachment", khrp)
            att1.Name = "__BSAtt1"
            att1.Position = Vector3.zero

            if not debugBeam then
                local b = Instance.new("Beam")
                b.Name           = "__BSBeam"
                b.Attachment0    = att0
                b.Attachment1    = att1
                b.FaceCamera     = true
                b.Width0         = 0.08
                b.Width1         = 0.08
                b.Segments       = 1
                b.LightEmission  = 1
                b.LightInfluence = 0
                b.Parent         = hrp
                debugBeam = b
            end

            debugBeam.Attachment0 = att0
            debugBeam.Attachment1 = att1
            debugBeam.Color = isValid
                and ColorSequence.new(Color3.fromRGB(50, 220, 100))
                or  ColorSequence.new(Color3.fromRGB(220, 80, 60))
        end)
    end

    local function activateForKiller(killerModel, duration)
        if not killerModel or not isRunning then return end
        local char     = getCharacter()
        local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
        local hrp      = char and char:FindFirstChild("HumanoidRootPart")
        local khrp     = killerModel:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp or not khrp then return end

        aimRefCount = aimRefCount + 1
        if aimRefCount == 1 then pcall(function() humanoid.AutoRotate = false end) end

        local function finishAiming()
            aimRefCount = math.max(0, aimRefCount - 1)
            if aimRefCount == 0 then setAutoRotate(true) end
        end

        local function computeBehindCFrame()
            local kCF       = khrp.CFrame
            local behindPos = kCF.Position - (kCF.LookVector.Unit * BEHIND_DISTANCE)
            behindPos = Vector3.new(behindPos.X, kCF.Position.Y, behindPos.Z)
            return CFrame.new(behindPos, behindPos + kCF.LookVector.Unit)
        end

        if backstabType == "Lerp" then
            local t0 = os.clock()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not isRunning or os.clock() - t0 >= duration then
                    conn:Disconnect(); finishAiming(); return
                end
                if khrp and hrp then
                    hrp.CFrame = hrp.CFrame:Lerp(computeBehindCFrame(), LERP_SPEED)
                end
            end)
        elseif backstabType == "Teleport" then
            pcall(function() hrp.CFrame = computeBehindCFrame() end)
            task.delay(duration, finishAiming)
        elseif backstabType == "Aim" then
            local t0 = os.clock()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not isRunning or os.clock() - t0 >= duration then
                    conn:Disconnect(); finishAiming(); return
                end
                if khrp and hrp then
                    local stabTarget = khrp.Position + khrp.CFrame.LookVector * 2
                    local aimPos     = Vector3.new(stabTarget.X, hrp.Position.Y, stabTarget.Z)
                    hrp.CFrame = hrp.CFrame:Lerp(
                        CFrame.new(hrp.Position, aimPos),
                        LERP_SPEED * 1.8
                    )
                end
            end)
        end
    end

    task.spawn(function()
        while isRunning do
            task.wait(CHECK_INTERVAL)
            if not enabled or not isRunning then continue end

            local killersFolder = getKillersFolder()
            if not killersFolder then continue end

            local char = getCharacter()
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            local triggered = false

            for _, killer in pairs(killersFolder:GetChildren()) do
                if triggered then break end
                if not isValidKillerModel(killer) then continue end

                local khrp = killer:FindFirstChild("HumanoidRootPart")
                local dist = (khrp.Position - hrp.Position).Magnitude

                if dist <= proximity then
                    local valid = isPlayerBehindKiller(hrp, khrp, dist)
                    drawDebugLine(hrp, khrp, valid)

                    if valid and rangeMode ~= "Around" and os.clock() - lastTrigger >= COOLDOWN then
                        local cdNum = readCooldownValue(getDaggerCooldown())
                        if not (cdNum and cdNum > 0.1) then
                            lastTrigger = os.clock()
                            triggered   = true

                            task.spawn(function()
                                activateForKiller(killer, DEFAULT_DURATION)
                                if REMOTE_FIRE_DELAY > 0 then task.wait(REMOTE_FIRE_DELAY) end
                                if daggerEnabled then tryActivateButton(getDaggerButton()) end
                                if AIM_SNAP_DELAY > 0 then
                                    task.wait(AIM_SNAP_DELAY)
                                    if not isRunning then return end
                                    local khrp2 = killer:FindFirstChild("HumanoidRootPart")
                                    local char2 = getCharacter()
                                    local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")
                                    if khrp2 and hrp2 then
                                        local behindPos = khrp2.CFrame.Position - (khrp2.CFrame.LookVector.Unit * BEHIND_DISTANCE)
                                        behindPos = Vector3.new(behindPos.X, hrp2.Position.Y, behindPos.Z)
                                        hrp2.CFrame = CFrame.new(behindPos, behindPos + khrp2.CFrame.LookVector.Unit)
                                    end
                                end
                            end)
                        end
                    end
                elseif DEBUG_LINE then
                    removeDebugLine()
                end

                if rangeMode == "Around" and dist <= proximity and os.clock() - lastTrigger >= COOLDOWN and not triggered then
                    local cdNum = readCooldownValue(getDaggerCooldown())
                    if not (cdNum and cdNum > 0.1) then
                        lastTrigger = os.clock()
                        triggered   = true
                        task.spawn(function()
                            activateForKiller(killer, DEFAULT_DURATION)
                            if REMOTE_FIRE_DELAY > 0 then task.wait(REMOTE_FIRE_DELAY) end
                            if daggerEnabled then tryActivateButton(getDaggerButton()) end
                            if AIM_SNAP_DELAY > 0 then
                                task.wait(AIM_SNAP_DELAY)
                                if not isRunning then return end
                                local khrp2 = killer:FindFirstChild("HumanoidRootPart")
                                local char2 = getCharacter()
                                local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")
                                if khrp2 and hrp2 then
                                    local tp = Vector3.new(khrp2.Position.X, hrp2.Position.Y, khrp2.Position.Z)
                                    hrp2.CFrame = CFrame.new(hrp2.Position, tp)
                                end
                            end
                        end)
                    end
                end
            end

            if not triggered then removeDebugLine() end
        end
    end)

    Feng:Toggle({
        Name = "自动背刺",
        Value = false,
        Callback = function(state) enabled = state end
    })

    Feng:Toggle({
        Name = "背刺时自动攻击",
        Value = false,
        Callback = function(state) daggerEnabled = state end
    })

    Feng:Toggle({
        Name = "调试射线",
        Value = true,
        Callback = function(state)
            DEBUG_LINE = state
            if not state then removeDebugLine() end
        end
    })

    Feng:Dropdown({
        Name = "背刺类型",
        Values = { "缓动位移", "瞬移", "锁定瞄准" },
        Value   = "缓动位移",
        Callback = function(value)
            if value == "缓动位移" then backstabType = "Lerp"
            elseif value == "瞬移" then backstabType = "Teleport"
            elseif value == "锁定瞄准" then backstabType = "Aim" end
        end
    })

    Feng:Dropdown({
        Name = "范围模式",
        Values = {"全范围", "背后"},
        Value = "背后",
        Callback = function(value)
            if value == "全范围" then rangeMode = "Around"
            else rangeMode = "Behind" end
        end
    })

    Feng:Slider({
        Name = "检测范围",
        Value = { Min = 1, Max = 30, Default = DEFAULT_PROXIMITY },
        Callback = function(value) proximity = value end
    })

    Feng:Slider({
        Name = "背后瞬移距离",
        Value = { Min = 0.5, Max = 10, Default = BEHIND_DISTANCE },
        Callback = function(value) BEHIND_DISTANCE = value end
    })

    Feng:Slider({
        Name = "背后判定锥角",
        Value = { Min = 10, Max = 180, Default = BEHIND_CONE_DEGREES },
        Callback = function(value) BEHIND_CONE_DEGREES = value end
    })

    Feng:Slider({
        Name = "远程触发延迟",
        Value = { Min = 0.00, Max = 0.50, Default = REMOTE_FIRE_DELAY },
        Callback = function(value) REMOTE_FIRE_DELAY = value end
    })

    Feng:Slider({
        Name = "瞄准硬锁定延迟",
        Value = { Min = 0.00, Max = 0.30, Default = AIM_SNAP_DELAY },
        Callback = function(value) AIM_SNAP_DELAY = value end
    })
end

Feng:Toggle({
    Name = "自动格挡",
Locked = isLocked,
TextLocked = lockTitle,
    Value = AutoBlockEnabled,
    Callback = function(value)
        AutoBlockEnabled = value
        if value then EnableAutoBlock() else DisableAutoBlock() end
    end
})

do
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer

    local AutoBlockEnabled = false
    local ShowHitboxVisual = true
    local HitboxScale = 1.0
    local HitboxOffset = -1.4
    local HitboxDuration = 1.5
    local AutoPunchEnabled = false
    local AimPunchEnabled = false
    local AimPunchMode = "CamChar"

    local BaseHitboxSize = Vector3.new(4.5, 6, 7.5)
    local HitboxColor = Color3.fromRGB(255, 255, 255)
    local ShowOutline = true
    local OutlineThickness = 0.01
    local HitboxTransparency = 0.5

    local AutoBlockConnections = {}
    local BlockHitboxData = {}

    local MainUI, KillersFolder, SurvivorsFolder, Hitboxes

    local function GetObjects()
        MainUI = LP.PlayerGui:FindFirstChild("MainUI")
        local playersFolder = Workspace:FindFirstChild("Players")
        KillersFolder = playersFolder and playersFolder:FindFirstChild("Killers")
        SurvivorsFolder = playersFolder and playersFolder:FindFirstChild("Survivors")
        Hitboxes = Workspace:FindFirstChild("Hitboxes") or Instance.new("Folder", Workspace)
        Hitboxes.Name = "Hitboxes"
    end
    GetObjects()

    local function getActionButton(name)
        if not MainUI then return nil end
        local container = MainUI:FindFirstChild("AbilityContainer")
        if not container then return nil end
        return container:FindFirstChild(name)
    end

    local function getBlockButton() return getActionButton("Block") or getActionButton("Guard") end
    local function getPunchButton() return getActionButton("Punch") or getActionButton("Attack") or getActionButton("Slap") end

    local function pressButton(btn)
        if not btn then return false end
        local cd = btn:FindFirstChild("CooldownTime")
        if cd and cd.Text ~= "" then return false end
        pcall(function() btn:Activate() end)
        local conns = nil
        pcall(function() conns = getconnections(btn.MouseButton1Click) end)
        if conns then
            for _, conn in ipairs(conns) do
                pcall(function() conn:Fire() end)
            end
        end
        return true
    end

    local function pressBlock() return pressButton(getBlockButton()) end
    local function pressPunch() return pressButton(getPunchButton()) end

    local function CreateBlockHitboxVisual()
        local part = Instance.new("Part")
        part.Name = "AttackHitboxVisual"
        part.Size = BaseHitboxSize * HitboxScale
        part.Color = HitboxColor
        part.Material = Enum.Material.ForceField
        part.Transparency = 1 - HitboxTransparency
        part.Anchored = true
        part.CanCollide = false
        part.CastShadow = false
        part.Parent = Hitboxes
        if ShowOutline then
            local outline = Instance.new("SelectionBox")
            outline.Adornee = part
            outline.Color3 = HitboxColor
            outline.LineThickness = OutlineThickness
            outline.Transparency = 0.1
            outline.Visible = ShowHitboxVisual
            outline.Parent = part
        end
        return part
    end

    local function UpdateBlockHitboxPosition(part, queryHitbox)
        if part and queryHitbox then
            part.CFrame = queryHitbox.CFrame * CFrame.new(0, 0, HitboxOffset)
            part.Size = BaseHitboxSize * HitboxScale
            part.Color = HitboxColor
            part.Transparency = 1 - HitboxTransparency
            local outline = part:FindFirstChildOfClass("SelectionBox")
            if outline then
                outline.Color3 = HitboxColor
                outline.LineThickness = OutlineThickness
                outline.Visible = ShowOutline and ShowHitboxVisual
            end
        end
    end

    local function ClearKillerBlockHitbox(Killer)
        local data = BlockHitboxData[Killer]
        if data then
            if data.visualPart then data.visualPart:Destroy() end
            if data.visualConnection then data.visualConnection:Disconnect() end
            if data.heartbeatConnection then data.heartbeatConnection:Disconnect() end
            BlockHitboxData[Killer] = nil
        end
    end

    local OverlapParamsObj = OverlapParams.new()
    OverlapParamsObj.MaxParts = 1
    OverlapParamsObj.FilterType = Enum.RaycastFilterType.Include

    local function StartBlockDetection(Killer, queryHitbox)
        ClearKillerBlockHitbox(Killer)
        local visualPart = CreateBlockHitboxVisual()
        UpdateBlockHitboxPosition(visualPart, queryHitbox)

        local visualConnection = RunService.Heartbeat:Connect(function()
            if visualPart and visualPart.Parent and queryHitbox and queryHitbox.Parent then
                UpdateBlockHitboxPosition(visualPart, queryHitbox)
            else
                visualConnection:Disconnect()
            end
        end)

        local data = {
            visualPart = visualPart,
            visualConnection = visualConnection,
            heartbeatConnection = nil
        }
        BlockHitboxData[Killer] = data

        local localChar = LP.Character
        if not localChar or not SurvivorsFolder or localChar.Parent ~= SurvivorsFolder then
            task.delay(HitboxDuration, function() ClearKillerBlockHitbox(Killer) end)
            return
        end
        local localQuery = localChar:FindFirstChild("QueryHitbox")
        if not localQuery then
            task.delay(HitboxDuration, function() ClearKillerBlockHitbox(Killer) end)
            return
        end

        local hitboxSize = BaseHitboxSize * HitboxScale
        local startTime = tick()

        local heartbeatPart = Instance.new("Part")
        heartbeatPart.Size = hitboxSize
        heartbeatPart.CanCollide = false
        heartbeatPart.Anchored = true
        heartbeatPart.Transparency = 1
        heartbeatPart.Parent = Hitboxes

        local heartbeatConn
        heartbeatConn = RunService.Heartbeat:Connect(function()
            if not AutoBlockEnabled then
                heartbeatConn:Disconnect()
                heartbeatPart:Destroy()
                ClearKillerBlockHitbox(Killer)
                return
            end
            if tick() - startTime > HitboxDuration then
                heartbeatConn:Disconnect()
                heartbeatPart:Destroy()
                ClearKillerBlockHitbox(Killer)
                return
            end
            if not queryHitbox or not queryHitbox.Parent then
                heartbeatConn:Disconnect()
                heartbeatPart:Destroy()
                ClearKillerBlockHitbox(Killer)
                return
            end

            heartbeatPart.CFrame = queryHitbox.CFrame * CFrame.new(0, 0, HitboxOffset)
            OverlapParamsObj.FilterDescendantsInstances = { localQuery }
            local hits = Workspace:GetPartsInPart(heartbeatPart, OverlapParamsObj)
            if #hits > 0 then
                pressBlock()
                heartbeatConn:Disconnect()
                heartbeatPart:Destroy()
                ClearKillerBlockHitbox(Killer)
            end
        end)
        data.heartbeatConnection = heartbeatConn
    end

    local function HandleKiller_Attribute(Killer)
        if not Players:GetPlayerFromCharacter(Killer) then return end
        local queryHitbox = Killer:FindFirstChild("QueryHitbox")
        if not queryHitbox then return end
        local blockLocked = false
        local abilityConn, abilitiessConn

        local function doBlock()
            if AutoBlockEnabled then
                StartBlockDetection(Killer, queryHitbox)
            end
        end

        abilityConn = Killer:GetAttributeChangedSignal("AbilityLastUsed"):Connect(function()
            if not blockLocked then doBlock() else blockLocked = false end
        end)
        abilitiessConn = Killer:GetAttributeChangedSignal("AbilitiesUsed"):Connect(function()
            blockLocked = true
        end)

        table.insert(AutoBlockConnections, {
            Disconnect = function()
                abilityConn:Disconnect()
                abilitiessConn:Disconnect()
            end
        })
    end

    local function EnableAutoBlock()
        if AutoBlockEnabled then
            for _, con in ipairs(AutoBlockConnections) do pcall(con.Disconnect, con) end
            AutoBlockConnections = {}
            GetObjects()
            if KillersFolder then
                for _, killer in ipairs(KillersFolder:GetChildren()) do HandleKiller_Attribute(killer) end
                local childCon = KillersFolder.ChildAdded:Connect(HandleKiller_Attribute)
                table.insert(AutoBlockConnections, { Disconnect = function() childCon:Disconnect() end })
            end
        end
    end

    local function DisableAutoBlock()
        for _, con in ipairs(AutoBlockConnections) do pcall(con.Disconnect, con) end
        AutoBlockConnections = {}
        for killer, data in pairs(BlockHitboxData) do
            if data.visualPart then data.visualPart:Destroy() end
            if data.visualConnection then data.visualConnection:Disconnect() end
            if data.heartbeatConnection then data.heartbeatConnection:Disconnect() end
        end
        BlockHitboxData = {}
    end

    local autoPunchRunning = true
    task.spawn(function()
        while autoPunchRunning do
            task.wait(0.1)
            if AutoPunchEnabled then
                pcall(function()
                    local char = LP.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    local kFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
                    if hrp and kFolder then
                        local killerInRange = false
                        for _, killer in ipairs(kFolder:GetChildren()) do
                            if killer:IsA("Model") and killer:FindFirstChild("HumanoidRootPart") then
                                local kHRP = killer.HumanoidRootPart
                                local dist = (kHRP.Position - hrp.Position).Magnitude
                                if dist <= 10 then
                                    killerInRange = true
                                    break
                                end
                            end
                        end
                        if killerInRange then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            else
                                pressPunch()
                            end
                        end
                    end
                end)
            end
        end
    end)

    local AimPunch = {
        Distance = 100,
        Duration = 0.6,
        Mode = AimPunchMode,
        Connection = nil,
        Aiming = false,
    }
    local triggerModules = {}

    local function registerTriggerModule(name, enableFunc, disableFunc)
        triggerModules[name] = { enabled = false, enable = enableFunc, disable = disableFunc }
    end

    local function toggleModule(name, state)
        local mod = triggerModules[name]
        if not mod then return end
        if state and not mod.enabled then
            mod.enable()
            mod.enabled = true
        elseif not state and mod.enabled then
            mod.disable()
            mod.enabled = false
        end
    end

    local PUNCH_ANIM_IDS = {
        ["108911997126897"] = true,
        ["82137285150006"] = true,
        ["129843313690921"] = true,
        ["140703210927645"] = true,
        ["136007065400978"] = true,
        ["86096387000557"] = true,
        ["87259391926321"] = true,
        ["86709774283672"] = true,
        ["108807732150251"] = true,
        ["138040001965654"] = true
    }

    local function getPredictLead(velocity)
        local horiz = Vector3.new(velocity.X, 0, velocity.Z)
        local speed = horiz.Magnitude
        local t = math.clamp(0.08 + speed * 0.014, 0.08, 0.42)
        return horiz * t
    end

    local function getClosestTarget(maxDist)
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end

        local kFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
        if not kFolder then return nil end

        local closest, closestDist = nil, maxDist
        for _, model in ipairs(kFolder:GetChildren()) do
            if model:IsA("Model") and model ~= char then
                local targetHRP = model:FindFirstChild("HumanoidRootPart")
                local targetHum = model:FindFirstChildOfClass("Humanoid")
                if targetHRP and targetHum and targetHum.Health > 0 then
                    local dist = (targetHRP.Position - hrp.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = targetHRP
                    end
                end
            end
        end
        return closest
    end

    local function aimAtTargetWithPrediction(targetHRP, duration)
        if AimPunch.Aiming then return end
        AimPunch.Aiming = true

        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then AimPunch.Aiming = false return end

        hum.AutoRotate = false
        local cam = Workspace.CurrentCamera
        local startTime = tick()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            if elapsed >= duration or not targetHRP or not targetHRP.Parent or not hrp.Parent then
                if hum and hum.Parent then hum.AutoRotate = true end
                AimPunch.Aiming = false
                connection:Disconnect()
                return
            end

            local lead = getPredictLead(targetHRP.AssemblyLinearVelocity)
            local predictedPos = targetHRP.Position + lead
            local bodyPos = predictedPos + Vector3.new(0, 1.2, 0)
            local aimFlat = Vector3.new(bodyPos.X, hrp.Position.Y, bodyPos.Z)
            local charCF = CFrame.lookAt(hrp.Position, aimFlat)
            hrp.CFrame = hrp.CFrame:Lerp(charCF, 0.55)

            if AimPunch.Mode == "CamChar" and cam then
                local camPos = cam.CFrame.Position
                local camLook = CFrame.lookAt(camPos, bodyPos)
                cam.CFrame = cam.CFrame:Lerp(camLook, 0.4)
            end
        end)
    end

    local function setupAimPunchListener(character)
        if AimPunch.Connection then
            AimPunch.Connection:Disconnect()
            AimPunch.Connection = nil
        end

        local hum = character:WaitForChild("Humanoid", 5)
        local animator = hum and hum:WaitForChild("Animator", 5)
        if not animator then return end

        AimPunch.Connection = animator.AnimationPlayed:Connect(function(track)
            if not AimPunchEnabled then return end
            local animId = track.Animation and track.Animation.AnimationId:match("%d+")
            if animId and PUNCH_ANIM_IDS[animId] then
                local targetHRP = getClosestTarget(AimPunch.Distance)
                if targetHRP then
                    aimAtTargetWithPrediction(targetHRP, AimPunch.Duration)
                end
            end
        end)
    end

    registerTriggerModule("Punch",
        function()
            if LP.Character then setupAimPunchListener(LP.Character) end
        end,
        function()
            if AimPunch.Connection then
                AimPunch.Connection:Disconnect()
                AimPunch.Connection = nil
            end
            AimPunch.Aiming = false
        end
    )

    local function onCharacterAdded(newChar)
        if AimPunchEnabled then
            toggleModule("Punch", false)
            task.wait(0.1)
            toggleModule("Punch", true)
        end
    end

    if LP.Character then
        task.spawn(function() onCharacterAdded(LP.Character) end)
    end
    LP.CharacterAdded:Connect(onCharacterAdded)

    local autoBlockMonitor = true
    task.spawn(function()
        while autoBlockMonitor do
            task.wait(1)
            if not AutoBlockEnabled then continue end
            local pf = Workspace:FindFirstChild("Players")
            local kf = pf and pf:FindFirstChild("Killers")
            if kf and kf ~= KillersFolder then
                KillersFolder = kf
                DisableAutoBlock()
                EnableAutoBlock()
            end
        end
    end)

Feng:Toggle({
    Name = "自动格挡",
Locked = isLocked,
TextLocked = lockTitle,
    Value = AutoBlockEnabled,
    Callback = function(value)
        AutoBlockEnabled = value
        if value then EnableAutoBlock() else DisableAutoBlock() end
    end
})

    Feng:Toggle({
        Name = "显示碰撞箱",
        Value = ShowHitboxVisual,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value) ShowHitboxVisual = value end
    })

    Feng:Slider({
        Name = "碰撞箱缩放",
        Value = { Min = 0.1, Max = 5, Default = HitboxScale },
Locked = isLocked,
TextLocked = lockTitle,
        Rounding = 2,
        Callback = function(value) HitboxScale = value end
    })

    Feng:Slider({
        Name = "碰撞箱Z偏移",
        Value = { Min = -5, Max = 5, Default = HitboxOffset },
Locked = isLocked,
TextLocked = lockTitle,
        Rounding = 2,
        Callback = function(value) HitboxOffset = value end
    })

    Feng:Slider({
        Name = "碰撞箱持续时间",
        Value = { Min = 0.1, Max = 5, Default = HitboxDuration },
Locked = isLocked,
TextLocked = lockTitle,
        Rounding = 2,
        Callback = function(value) HitboxDuration = value end
    })

    Feng:Toggle({
        Name = "自动出拳",
        Value = AutoPunchEnabled,    
        Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value) AutoPunchEnabled = value end
    })

    Feng:Toggle({
        Name = "瞄准出拳",
        Value = AimPunchEnabled,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            AimPunchEnabled = value
            toggleModule("Punch", value)
        end
    })

    Feng:Dropdown({
        Name = "瞄准模式",
        Values = { "相机+角色", "角色" },
        Value = (AimPunchMode == "CamChar") and "相机+角色" or "角色",
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            AimPunchMode = (value == "相机+角色") and "CamChar" or "Character"
            AimPunch.Mode = AimPunchMode
        end
    })
end

local Feng = FengYu:Section({
    Name = "维罗妮卡",
    SubName = "滑滑板",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
    {
        Key = "ma",
        Name = "主要功能",
    },
    {
        Key = "se",
        Name = "设置",
    },
})

do
    local Players             = game:GetService("Players")
    local ReplicatedStorage   = game:GetService("ReplicatedStorage")
    local Workspace           = game:GetService("Workspace")
    local RunService          = game:GetService("RunService")
    local UserInputService    = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local localPlayer = Players.LocalPlayer

    local VeeronicaConfig   = require(ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Config"))
    local VeeronicaBehavior = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Survivors"):WaitForChild("Veeronica"):WaitForChild("Behavior")

    local module
    pcall(function()
        module = require(VeeronicaBehavior)
    end)

    local Util
    pcall(function()
        Util = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Utilities"):WaitForChild("Util"))
    end)

    local remoteEvent
    pcall(function()
        local netModule = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network")
        remoteEvent = netModule:FindFirstChild("RemoteEvent")
            or netModule:FindFirstChild("RemoteEvent", true)
    end)

    local _hooks     = {}
    local _installed = false

    local function addHook(fn)
        table.insert(_hooks, fn)
        return function()
            for i, v in ipairs(_hooks) do
                if v == fn then
                    table.remove(_hooks, i)
                    break
                end
            end
        end
    end

    local function installNamecall()
        if _installed then return end
        _installed = true
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" or method == "InvokeServer" then
                local args = { ... }
                for _, hook in ipairs(_hooks) do
                    local ok, result = pcall(hook, self, method, args)
                    if ok then
                        if result == false then
                            return
                        elseif type(result) == "table" then
                            args = result
                        end
                    end
                end
                return oldNamecall(self, table.unpack(args))
            end
            return oldNamecall(self, ...)
        end)
    end

    local tbl = {
        AutoTrick             = false,
        VeeronicaControl      = false,
        AntiRebound           = false,
        Sk8Speed              = 1.15,
        Sk8TrickAirborneSpeed = 1.42,
        Sk8BumpPower          = 11.9,
        Sk8TrickStamina       = 4,
        Sk8TrickCooldown      = 1,
    }

    local function fn20(key, value)
        if module then
            module[key] = value
        end
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "DisplayName") == "Veeronica" then
                v[key] = value
            end
        end
    end

    local function fn21(sk8TurnControl)
        if module then
            module.Sk8TurnControl = sk8TurnControl
        end
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "Sk8TurnControl") ~= nil then
                v.Sk8TurnControl = sk8TurnControl
            end
        end
        if VeeronicaConfig then
            VeeronicaConfig.Sk8TurnControl = sk8TurnControl
        end
    end

    local function VerronicaIsSkating()
        local char = localPlayer.Character
        if not char then return false end
        if char.Name ~= 'Veeronica' then return false end
        if not VeeronicaBehavior:FindFirstChild('Highlight') then return false end
        if VeeronicaBehavior.Highlight.Adornee ~= char then return false end
        return true
    end

    local function PressKeycode(keyCode)
        for i = 1, 2 do
            VirtualInputManager:SendKeyEvent(i < 2, keyCode, false, game)
            task.wait()
        end
    end

    local autoTrickEnabled = false

    Feng.ma:Toggle({
        Name = "自动特技",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            autoTrickEnabled = state
            if state then
                task.spawn(function()
                    while autoTrickEnabled do
                        if VerronicaIsSkating() then
                            PressKeycode(Enum.KeyCode.Space)
                        end
                        task.wait()
                    end
                end)
            end
        end
    })

    Feng.ma:Toggle({
        Name = "滑板控制",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            tbl.VeeronicaControl = state
            fn21(state and 6.5 or 0.65)
        end,
    })

    local antiReboundInstalled = false
    local function installAntiRebound()
        if antiReboundInstalled then return end
        antiReboundInstalled = true
        addHook(function(self, method, args)
            if not tbl.AntiRebound then return true end
            if method ~= "FireServer" then return true end
            if not remoteEvent or self ~= remoteEvent then return true end

            local first = tostring(args[1])
            local name  = localPlayer.Name

            if first == name .. "SkateRebound" then
                return false
            end

            if first == name .. "StopSkate" and type(args[2]) == "table" then
                for _, v in ipairs(args[2]) do
                    if typeof(v) == "Instance" then
                        remoteEvent:FireServer(
                            name .. "StopSkate",
                            { buffer.fromstring('"Manual"') }
                        )
                        return false
                    end
                end
            end
            return true
        end)
        installNamecall()
    end

    Feng.ma:Toggle({
        Name = "防反弹",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            tbl.AntiRebound = state
            if state then
                installAntiRebound()
            end
        end,
    })

    local autoFarmSk8Thread
    local autoFarmSk8Flag = false
    local function installAutoFarmSk8()
        if autoFarmSk8Thread then return end
        autoFarmSk8Thread = task.spawn(function()
            while true do
                if autoFarmSk8Flag then
                    if remoteEvent then
                        remoteEvent:FireServer(localPlayer.Name .. "SkateTrick", {})
                    end
                    task.wait(0.5)
                else
                    task.wait(0.1)
                end
            end
        end)
    end

    Feng.ma:Toggle({
        Name = "自动刷滑板",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            autoFarmSk8Flag = state
            if state then
                installAutoFarmSk8()
            end
        end,
    })

    local customStatsEnabled = false

    local function applyCustomStats()
        if customStatsEnabled then
            fn20("Sk8Speed",              tbl.Sk8Speed)
            fn20("Sk8SpeedExhaust",       tbl.Sk8Speed)
            fn20("Sk8TrickAirborneSpeed", tbl.Sk8TrickAirborneSpeed)
            fn20("Sk8BumpPower",          tbl.Sk8BumpPower)
            fn20("Sk8BumpChargedPower",   tbl.Sk8BumpPower + 3)
            fn20("Sk8TrickStamina",       tbl.Sk8TrickStamina)
            fn20("Sk8TrickStaminaNerfed", tbl.Sk8TrickStamina)
            fn20("Sk8TrickCooldown",      tbl.Sk8TrickCooldown)
        else
            fn20("Sk8Speed",              1.15)
            fn20("Sk8SpeedExhaust",       1.15)
            fn20("Sk8TrickAirborneSpeed", 1.42)
            fn20("Sk8BumpPower",          11.9)
            fn20("Sk8BumpChargedPower",   15)
            fn20("Sk8TrickStamina",       10)
            fn20("Sk8TrickStaminaNerfed", 4)
            fn20("Sk8TrickCooldown",      1)
        end
    end

    Feng.se:Toggle({
        Name = "启用自定义属性",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            customStatsEnabled = state
            applyCustomStats()
        end,
    })

    Feng.se:Slider({
        Name = "滑板速度",
        Value = { Min = 1, Max = 10, Default = 1.15 },
        Rounding = 2,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            tbl.Sk8Speed = value
            if customStatsEnabled then
                fn20("Sk8Speed", value)
                fn20("Sk8SpeedExhaust", value)
            end
        end,
    })

    Feng.se:Slider({
        Name = "技巧加速速度",
        Value = { Min = 1, Max = 15, Default = 1.42 },
        Rounding = 2,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            tbl.Sk8TrickAirborneSpeed = value
            if customStatsEnabled then
                fn20("Sk8TrickAirborneSpeed", value)
            end
        end,
    })

    Feng.se:Slider({
        Name = "撞击击退力度",
        Value = { Min = 10, Max = 150, Default = 11.9 },
        Rounding = 1,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            tbl.Sk8BumpPower = value
            if customStatsEnabled then
                fn20("Sk8BumpPower", value)
                fn20("Sk8BumpChargedPower", value)
            end
        end,
    })

    Feng.se:Slider({
        Name = "每次技巧体力",
        Value = { Min = 0, Max = 100, Default = 4 },
        Rounding = 0,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            tbl.Sk8TrickStamina = value
            if customStatsEnabled then
                fn20("Sk8TrickStamina", value)
                fn20("Sk8TrickStaminaNerfed", value)
            end
        end,
    })

    Feng.se:Slider({
        Name = "技巧冷却",
        Value = { Min = 0, Max = 5, Default = 1 },
        Rounding = 1,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(value)
            tbl.Sk8TrickCooldown = value
            if customStatsEnabled then
                fn20("Sk8TrickCooldown", value)
            end
        end,
    })
end
Window:TabDivider()

local FengYu = Window:Tab("幸存者综合", "83701039519151")

local Feng = FengYu:Section({
    Name = "其他功能",
    SubName = "幸存者",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local AutoClearPopups = false
    local popupConn = nil

    local function GetTemporaryUI()
        local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
        return playerGui and playerGui:FindFirstChild("TemporaryUI")
    end

    local function Check()
        if not AutoClearPopups then return end
        local P = GetTemporaryUI()
        if not P then return end
        for _, child in ipairs(P:GetChildren()) do
            if child.Name == "1x1x1x1Popup" then
                child:Destroy()
            end
        end
    end

    local function BindChildAdded()
        local P = GetTemporaryUI()
        if not P then return false end
        if popupConn then popupConn:Disconnect() end
        popupConn = P.ChildAdded:Connect(function(child)
            if AutoClearPopups and child.Name == "1x1x1x1Popup" then
                child:Destroy()
            end
        end)
        return true
    end

    if not BindChildAdded() then
        local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        playerGui.ChildAdded:Connect(function(child)
            if child.Name == "TemporaryUI" then
                BindChildAdded()
                Check()
            end
        end)
    end

    Feng:Toggle({
        Name = "自动移除1×4弹窗",
        Value = false,
        Callback = function(state)
            AutoClearPopups = state
            if state then Check() end
        end
    })
end

do
    local AutoEscapeEnabled = false
    local EscapeCooldown = 0.5

    Feng:Toggle({
        Name = "吸血鬼自动挣脱",
        Value = false,
        Callback = function(state) AutoEscapeEnabled = state end
    })

    Feng:Slider({
        Name = "间隔",
        Value = { Min = 0.1, Max = 1.5, Default = 0.5 },
        Rounding = 1,
        Callback = function(val) EscapeCooldown = val end
    })

    local function setupQTEListener()
        local player = game.Players.LocalPlayer
        if not player then return end
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then return end

        local tempUI = playerGui:FindFirstChild("TemporaryUI")
        if not tempUI then
            playerGui.ChildAdded:Connect(function(child)
                if child.Name == "TemporaryUI" then
                    setupQTEListener()
                end
            end)
            return
        end

        tempUI.ChildAdded:Connect(function(uiElement)
            if uiElement.Name:upper() == "QTE" and uiElement:FindFirstChildOfClass("UIAspectRatioConstraint") then
                task.spawn(function()
                    while uiElement and uiElement.Visible and AutoEscapeEnabled do
                        local cooldown = EscapeCooldown
                        local halfRange = cooldown * 0.2
                        local waitTime = math.random() * (cooldown + halfRange - (cooldown - halfRange)) + (cooldown - halfRange)
                        task.wait(waitTime)

                        if not AutoEscapeEnabled then break end

                        local playersFolder = workspace:FindFirstChild("Players")
                        if playersFolder then
                            local killersFolder = playersFolder:FindFirstChild("Killers")
                            if killersFolder then
                                for _, killer in ipairs(killersFolder:GetChildren()) do
                                    if killer.Name:lower() == "nosferatu" then
                                        local killerPlayer = game.Players:GetPlayerFromCharacter(killer)
                                        if killerPlayer then
                                            local network = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
                                            if network then
                                                network = network:FindFirstChild("Network")
                                                if network then
                                                    network = network:FindFirstChild("Network")
                                                    if network then
                                                        local remoteEvent = network:FindFirstChild("RemoteEvent")
                                                        if remoteEvent then
                                                            remoteEvent:FireServer(killerPlayer.Name .. "NosHookQTE", {true})
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
                end)
            end
        end)
    end

    task.spawn(function()
        local player = game.Players.LocalPlayer
        if player and player:FindFirstChild("PlayerGui") then
            local tempUI = player.PlayerGui:FindFirstChild("TemporaryUI")
            if tempUI then
                setupQTEListener()
            else
                player.PlayerGui.ChildAdded:Connect(function(child)
                    if child.Name == "TemporaryUI" then
                        setupQTEListener()
                    end
                end)
            end
        end
    end)
end

do
    local DisableToxicTrails = false
    local InGame = nil

    local function HandleDisableToxicTrails(Value)
        if not InGame then return end
        for _, child in ipairs(InGame:GetChildren()) do
            if child:IsA("Folder") and (child.Name):find("JohnDoeTrail") then
                for _, part in ipairs(child:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanTouch = not Value
                    end
                end
                if not child:GetAttribute("Checked") then
                    child:SetAttribute("Checked", true)
                    child.ChildAdded:Connect(function(newPart)
                        if newPart:IsA("BasePart") then
                            newPart.CanTouch = not DisableToxicTrails
                        end
                    end)
                end
            end
        end
    end

    local function UpdateInGame()
        local map = workspace:FindFirstChild("Map")
        if map then InGame = map:FindFirstChild("Ingame") else InGame = nil end
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)
            UpdateInGame()
            if DisableToxicTrails then HandleDisableToxicTrails(true) end
        end
    end)

    task.spawn(function()
        UpdateInGame()
        if DisableToxicTrails then HandleDisableToxicTrails(true) end
    end)

    local function WatchInGame()
        if not InGame then return end
        InGame.ChildAdded:Connect(function(child)
            if child:IsA("Folder") and (child.Name):find("JohnDoeTrail") then
                task.wait(0.1)
                HandleDisableToxicTrails(DisableToxicTrails)
            end
        end)
    end

    task.spawn(function()
        UpdateInGame()
        if InGame then
            WatchInGame()
        else
            local map = workspace:FindFirstChild("Map")
            if map then
                map.ChildAdded:Connect(function(child)
                    if child.Name == "Ingame" then
                        InGame = child
                        WatchInGame()
                        if DisableToxicTrails then HandleDisableToxicTrails(true) end
                    end
                end)
            end
        end
    end)

    Feng:Toggle({
        Name = "禁用约翰.多脚气伤害",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            DisableToxicTrails = state
            UpdateInGame()
            HandleDisableToxicTrails(state)
        end
    })
end

do
    local DisableFootprints = false
    local InGame = nil

    local function HandleDisableFootprints(Value)
        if not InGame then return end
        for _, child in ipairs(InGame:GetChildren()) do
            if child:IsA("Folder") and (child.Name):find("Shadows") then
                for _, part in ipairs(child:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanTouch = not Value
                    end
                end
                if not child:GetAttribute("Checked") then
                    child:SetAttribute("Checked", true)
                    child.ChildAdded:Connect(function(newPart)
                        if newPart:IsA("BasePart") then
                            newPart.CanTouch = not DisableFootprints
                        end
                    end)
                end
            end
        end
    end

    local function UpdateInGame()
        local map = workspace:FindFirstChild("Map")
        if map then InGame = map:FindFirstChild("Ingame") else InGame = nil end
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)
            UpdateInGame()
            if DisableFootprints then HandleDisableFootprints(true) end
        end
    end)

    task.spawn(function()
        UpdateInGame()
        if DisableFootprints then HandleDisableFootprints(true) end
    end)

    local function WatchInGame()
        if not InGame then return end
        InGame.ChildAdded:Connect(function(child)
            if child:IsA("Folder") and (child.Name):find("Shadows") then
                task.wait(0.1)
                HandleDisableFootprints(DisableFootprints)
            end
        end)
    end

    task.spawn(function()
        UpdateInGame()
        if InGame then
            WatchInGame()
        else
            local map = workspace:FindFirstChild("Map")
            if map then
                map.ChildAdded:Connect(function(child)
                    if child.Name == "Ingame" then
                        InGame = child
                        WatchInGame()
                        if DisableFootprints then HandleDisableFootprints(true) end
                    end
                end)
            end
        end
    end)

    Feng:Toggle({
        Name = "禁用约翰.多脚印大规模伤害",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            DisableFootprints = state
            UpdateInGame()
            HandleDisableFootprints(state)
        end
    })
end

do
    local DisableKillerWallsEnabled = false
    local GameMap = nil

    local function HandleDisableKillerWalls(Value, Tween)
        if not GameMap then return end
        local KillerDoorsFolder = GameMap:FindFirstChild("KillerDoors", true) or GameMap:FindFirstChild("Killer Doors", true)
        local KillerCollisions = GameMap:FindFirstChild("KillerOnly", true)
        if not KillerDoorsFolder then return end

        local MainTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        local TweenService = game:GetService("TweenService")

        for _, v in ipairs(KillerDoorsFolder:GetChildren()) do
            if v:IsA("BasePart") then
                if math.min(v.Size.X, v.Size.Z) > 5 then continue end
                v.CanTouch = true

                local Color = Value and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                local VertexColor = Value and Vector3.new(0, 255, 0) or Vector3.new(255, 0, 0)

                if Tween then
                    TweenService:Create(v, MainTweenInfo, { Color = Color }):Play()
                else
                    v.Color = Color
                end

                if v:GetAttribute("OriginalCanCollide") == nil then
                    v:SetAttribute("OriginalCanCollide", v.CanCollide)
                end
                v.CanCollide = v:GetAttribute("OriginalCanCollide") ~= false and not Value or false

                local mesh = v:FindFirstChildOfClass("SpecialMesh")
                if mesh then
                    if Tween then
                        TweenService:Create(mesh, MainTweenInfo, { VertexColor = VertexColor }):Play()
                    else
                        mesh.VertexColor = VertexColor
                    end
                end

                if KillerCollisions then
                    local Params = OverlapParams.new()
                    Params.FilterType = Enum.RaycastFilterType.Include
                    Params.FilterDescendantsInstances = { KillerCollisions }
                    local Params2 = OverlapParams.new()
                    Params2.FilterType = Enum.RaycastFilterType.Include
                    Params2.FilterDescendantsInstances = { KillerDoorsFolder:QueryDescendants("#KillerWallDetail") }

                    local Hitbox = workspace:GetPartBoundsInRadius(v.Position, 25, Params)
                    local DecorationHitbox = workspace:GetPartBoundsInRadius(v.Position, 25, Params2)

                    for _, part in ipairs(Hitbox) do
                        part.CanCollide = not Value
                    end

                    for _, detailPart in ipairs(DecorationHitbox) do
                        local MainDecoration = detailPart:FindFirstAncestor("KillerWallDetail")
                        if not MainDecoration then continue end
                        local FloorSpikes = MainDecoration:FindFirstChildOfClass("MeshPart")
                        if FloorSpikes then
                            if Tween then
                                TweenService:Create(FloorSpikes, MainTweenInfo, { Color = Color3.fromRGB(110, 110, 110) }):Play()
                            else
                                FloorSpikes.Color = Value and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
                            end
                            for _, tex in ipairs(FloorSpikes:QueryDescendants("Texture")) do
                                if Tween then
                                    TweenService:Create(tex, MainTweenInfo, { Color3 = Value and Color3.new(0,0,0) or Color3.new(1,1,1) }):Play()
                                else
                                    tex.Color3 = Value and Color3.new(0,0,0) or Color3.new(1,1,1)
                                end
                            end
                        end
                        for _, emitter in ipairs(MainDecoration:QueryDescendants("ParticleEmitter")) do
                            if not emitter:GetAttribute("OGColor") then
                                emitter:SetAttribute("OGColor", emitter.Color)
                            end
                            emitter.Color = (Value and ColorSequence.new(Color3.new(0,1,0))) or emitter:GetAttribute("OGColor")
                        end
                    end
                end
            end
        end
    end

    local function UpdateGameMap()
        local map = workspace:FindFirstChild("Map")
        if map then
            local ingame = map:FindFirstChild("Ingame")
            if ingame then
                GameMap = ingame:FindFirstChild("Map") or map
            else
                GameMap = map
            end
        end
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            UpdateGameMap()
            if DisableKillerWallsEnabled then HandleDisableKillerWalls(true, false) end
        end
    end)

    task.spawn(function()
        UpdateGameMap()
        if DisableKillerWallsEnabled then HandleDisableKillerWalls(true, false) end
    end)

    Feng:Toggle({
        Name = "禁用杀手墙",
        Value = false,
        Callback = function(state)
            DisableKillerWallsEnabled = state
            UpdateGameMap()
            HandleDisableKillerWalls(state, false)
        end
    })
end
local FengYu = Window:Tab("杀手功能包", "83701039519151")

local Feng = FengYu:Section({
    Name = "碰撞箱修改",
    SubName = "碰撞攻击",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
    {
        Key = "ex",
        Name = "扩展",
    },
    {
        Key = "tr",
        Name = "追踪",
    },
})

do
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local hitboxExtender = { enabled = false, range = 10 }

    local function studsToPower(studs) return studs * 6 end

    task.spawn(function()
        while true do
            RunService.Heartbeat:Wait()
            if hitboxExtender.enabled then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then continue end

                local myHitboxDetected = false
                local hitboxesFolder = Workspace:FindFirstChild("Hitboxes")
                local myUsername = char:GetAttribute("Username") or LP.Name
                local myHitboxName = myUsername .. "Hitbox"

                if hitboxesFolder and char then
                    for _, part in ipairs(hitboxesFolder:GetChildren()) do
                        if part.Name == myHitboxName then
                            if hrp and (part.Position - hrp.Position).Magnitude <= 15 then
                                myHitboxDetected = true
                            end
                            break
                        end
                    end
                end

                if myHitboxDetected and char and hrp and hrp.Parent then
                    local velocity = hrp.AssemblyLinearVelocity
                    if velocity.Magnitude > 0.5 then
                        local distance = studsToPower(hitboxExtender.range)
                        local moveDir = velocity.Magnitude > 0 and velocity.Unit or hrp.CFrame.LookVector
                        local newVelocity = velocity + (moveDir * distance)
                        hrp.AssemblyLinearVelocity = Vector3.new(newVelocity.X, velocity.Y, newVelocity.Z)
                        RunService.RenderStepped:Wait()
                        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                            LP.Character.HumanoidRootPart.AssemblyLinearVelocity = velocity
                        end
                    end
                end
            end
        end
    end)

    Feng.ex:Toggle({
        Name = "启用碰撞箱扩展",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(v) hitboxExtender.enabled = v end
    })

    Feng.ex:Slider({
        Name = "碰撞箱长度",
        Value = { Min = 0, Max = 50, Default = 10 },
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(v) hitboxExtender.range = math.floor(v) end
    })
end

do
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local Stats = game:GetService("Stats")
    local Random = Random.new()

    local hitboxTracker = { enabled = false, range = 60 }

    local character = LP.Character or LP.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    LP.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = newCharacter:WaitForChild("Humanoid")
        humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    end)

    task.spawn(function()
        while task.wait() do
            if hitboxTracker.enabled and humanoidRootPart then
                local isAttacking = false
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    if track.Animation and track.Animation.AnimationId and (track.TimePosition / track.Length < 0.75) then
                        isAttacking = true
                        break
                    end
                end
                if isAttacking then
                    local closestTarget
                    local closestDistance = hitboxTracker.range
                    local function scanGroup(group)
                        for _, model in ipairs(group) do
                            if model ~= character and model:FindFirstChild("HumanoidRootPart") and model:FindFirstChild("Humanoid") and model:FindFirstChild("Humanoid").Health > 0 then
                                local distance = (model.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestTarget = model
                                end
                            end
                        end
                    end
                    scanGroup(Workspace.Players:GetDescendants())
                    local npcsFolder = Workspace:FindFirstChild("Map", true) and Workspace.Map:FindFirstChild("NPCs", true)
                    if npcsFolder then scanGroup(npcsFolder:GetChildren()) end
                    if closestTarget then
                        local ping = tonumber(Stats.PerformanceStats.Ping:GetValue()) / 1000
                        local randomOffset = Vector3.new(Random:NextNumber(-1.5, 1.5), 0, Random:NextNumber(-1.5, 1.5))
                        local targetPosition = closestTarget.HumanoidRootPart.Position + randomOffset + (closestTarget.HumanoidRootPart.Velocity * (ping * 1.25))
                        local newVelocity = (targetPosition - humanoidRootPart.Position) / (ping * 2)
                        local originalVelocity = humanoidRootPart.Velocity
                        humanoidRootPart.Velocity = newVelocity
                        RunService.RenderStepped:Wait()
                        humanoidRootPart.Velocity = originalVelocity
                    end
                end
            end
        end
    end)

    Feng.tr:Toggle({
        Name = "启用碰撞箱追踪",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(v) hitboxTracker.enabled = v end
    })

    Feng.tr:Slider({
        Name = "追踪距离",
        Value = { Min = 10, Max = 200, Default = 60 },
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(v) hitboxTracker.range = math.floor(v) end
    })
end

local Feng = FengYu:Section({
    Name = "汽车拐弯",
    SubName = "打开[准心]才有效果",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local dashTurn = {
        sixer = false,
        coolkid = false,
        noli = false,
        noliActive = false,
        noliOrigWalkSpeed = nil,
        noliConn = nil,
    }

    local function getCameraInputDir()
        local cam = Camera
        local cf = cam.CFrame
        local camFwd = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
        local camRight = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
        local x, z = 0, 0
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then z = z - 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then z = z + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then x = x - 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then x = x + 1 end
        local dir = camFwd * -z + camRight * x
        if dir.Magnitude > 0.01 then return dir.Unit end
        if camFwd.Magnitude > 0.01 then return camFwd.Unit end
        return Vector3.new(0, 0, -1)
    end

    local function sixerAirStrafeStep()
        if not dashTurn.sixer then return end
        local char = LP.Character
        if not char then return end
        if char:GetAttribute("PursuitState") ~= "Dashing" then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        local cam = Camera
        local flat = cam.CFrame.LookVector * Vector3.new(1, 0, 1)
        if flat.Magnitude < 0.01 then return end
        flat = flat.Unit
        local vel = hrp.AssemblyLinearVelocity
        local hVel = Vector3.new(vel.X, 0, vel.Z)
        local hSpeed = hVel.Magnitude
        if hSpeed < 0.1 then return end
        local newH = hVel:Lerp(flat * hSpeed, 1)
        hrp.AssemblyLinearVelocity = Vector3.new(newH.X, vel.Y, newH.Z)
    end

    local function coolkidDashTurnStep(dt)
        if not dashTurn.coolkid then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hrp then return end
        if char:GetAttribute("FootstepsMuted") ~= true then return end
        local dir = getCameraInputDir()
        local lv = hrp:FindFirstChildWhichIsA("LinearVelocity")
        if lv then lv.LineDirection = dir end
        if dir.Magnitude > 0.01 then
            local targetRot = CFrame.new(hrp.Position, hrp.Position + dir).Rotation
            hrp.CFrame = CFrame.new(hrp.Position) * hrp.CFrame.Rotation:Lerp(targetRot, math.min(dt * 16, 1))
        end
    end

    local function noliStopOverride()
        if not dashTurn.noliActive then return end
        dashTurn.noliActive = false
        if dashTurn.noliConn then
            dashTurn.noliConn:Disconnect()
            dashTurn.noliConn = nil
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = dashTurn.noliOrigWalkSpeed or 16
            hum.AutoRotate = true
            pcall(function() hum:Move(Vector3.new(0, 0, 0)) end)
        end
        dashTurn.noliOrigWalkSpeed = nil
    end

    local function noliStartOverride()
        if dashTurn.noliActive then return end
        dashTurn.noliActive = true
        dashTurn.noliConn = RunService.RenderStepped:Connect(function()
            if not dashTurn.noli then noliStopOverride() return end
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end
            if not dashTurn.noliOrigWalkSpeed then dashTurn.noliOrigWalkSpeed = hum.WalkSpeed end
            hum.WalkSpeed = 60
            hum.AutoRotate = false
            local horiz = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
            if horiz.Magnitude > 0 then hum:Move(horiz.Unit) end
        end)
    end

    RunService:BindToRenderStep("SixerAirStrafe", Enum.RenderPriority.Character.Value + 2, sixerAirStrafeStep)

    local coolkidConn = nil
    local function updateCoolkidDash()
        if coolkidConn then coolkidConn:Disconnect() end
        coolkidConn = RunService.RenderStepped:Connect(function(dt)
            coolkidDashTurnStep(dt)
        end)
    end
    updateCoolkidDash()

    LP.CharacterAdded:Connect(function() noliStopOverride() end)

    RunService.RenderStepped:Connect(function()
        if not dashTurn.noli then
            if dashTurn.noliActive then noliStopOverride() end
            return
        end
        local char = LP.Character
        if not char then return end
        if char:GetAttribute("VoidRushState") == "Dashing" then
            noliStartOverride()
        else
            noliStopOverride()
        end
    end)

    Feng:Toggle({
        Name = "访客666 - 空中控制",
        Value = false,
        Callback = function(state) dashTurn.sixer = state end
    })

    Feng:Toggle({
        Name = "酷小孩 - 冲刺控制",
        Value = false,
        Callback = function(state) dashTurn.coolkid = state end
    })

    Feng:Toggle({
        Name = "诺利 - 冲刺控制",
        Value = false,
        Callback = function(state)
            dashTurn.noli = state
            if not state then noliStopOverride() end
        end
    })
end

local Feng = FengYu:Section({
    Name = "自瞄",
    SubName = "靠近幸存者自动瞄准",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LP = Players.LocalPlayer

    local aim = {
        on = false,
        cooldown = 0.3,
        lockTime = 0.4,
        maxDist = 30,
        smooth = 0.35,
        targeting = false,
        target = nil,
        deathConn = nil,
        autoRotate = nil,
        lastFired = 0,
        hum = nil,
        hrp = nil,
        cache = {},
        cacheTime = 0,
        cacheLife = 0.5,
    }

    local function aimIsKiller()
        local char = LP.Character
        if not char then return false end
        local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
        return killersFolder and char:IsDescendantOf(killersFolder)
    end

    local function aimRefreshChar(ch)
        aim.hum = ch and ch:FindFirstChildOfClass("Humanoid")
        aim.hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    end

    local function aimRefreshTargets()
        local now = tick()
        if now - aim.cacheTime < aim.cacheLife then return end
        aim.cacheTime = now
        aim.cache = {}
        local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
        if not survivorsFolder then return end
        for _, model in ipairs(survivorsFolder:GetChildren()) do
            if model ~= LP.Character and model:IsA("Model") then
                local h = model:FindFirstChildOfClass("Humanoid")
                local r = model:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    table.insert(aim.cache, r)
                end
            end
        end
    end

    local function aimNearest()
        aimRefreshTargets()
        if not aim.hrp or #aim.cache == 0 then return nil end
        local best, bestDist = nil, math.huge
        for _, r in ipairs(aim.cache) do
            local d = (r.Position - aim.hrp.Position).Magnitude
            if d < bestDist and d <= aim.maxDist then
                bestDist = d
                best = r
            end
        end
        return best
    end

    local function aimUnlock()
        if not aim.targeting then return end
        if aim.deathConn then aim.deathConn:Disconnect(); aim.deathConn = nil end
        if aim.autoRotate ~= nil and aim.hum then
            aim.hum.AutoRotate = aim.autoRotate
        end
        aim.targeting = false
        aim.target = nil
    end

    local function aimLock(rootPart)
        if not rootPart or not rootPart.Parent or not aim.hum or not aim.hrp then return end
        if aim.targeting and aim.target == rootPart then return end
        aimUnlock()
        aim.target = rootPart
        aim.targeting = true
        aim.autoRotate = aim.hum.AutoRotate
        aim.hum.AutoRotate = false
        local targetHumanoid = rootPart.Parent:FindFirstChildOfClass("Humanoid")
        if targetHumanoid then
            aim.deathConn = targetHumanoid.Died:Connect(aimUnlock)
        end
        task.delay(aim.lockTime, function()
            if aim.target == rootPart then aimUnlock() end
        end)
    end

    local function setupAimbotTrigger()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Modules")
            and game.ReplicatedStorage.Modules:FindFirstChild("Network")
            and game.ReplicatedStorage.Modules.Network:FindFirstChild("Network")
            and game.ReplicatedStorage.Modules.Network.Network:FindFirstChild("RemoteEvent")
        if not remote then return end

        remote.OnClientEvent:Connect(function(...)
            if not aim.on then return end
            local args = {...}
            if type(args[1]) ~= "string" then return end
            local abilityName = args[1]
            if abilityName:match("Ability") or abilityName:match("[QER]") or
               abilityName == "Slash" or abilityName == "Dagger" or abilityName == "Charge" or
               abilityName == "Stab" or abilityName == "Punch" then
                if tick() - aim.lastFired < aim.cooldown then return end
                aim.lastFired = tick()
                if aimIsKiller() then
                    local target = aimNearest()
                    if target then aimLock(target) end
                end
            end
        end)
    end

    LP.CharacterAdded:Connect(function(ch)
        task.wait(0.5)
        aimRefreshChar(ch)
    end)
    if LP.Character then
        aimRefreshChar(LP.Character)
    end

    RunService.RenderStepped:Connect(function()
        if not aim.on or not aim.targeting or not aim.hrp or not aim.target then return end
        if not aim.target.Parent then aimUnlock(); return end
        local targetHumanoid = aim.target.Parent:FindFirstChildOfClass("Humanoid")
        if not targetHumanoid or targetHumanoid.Health <= 0 then aimUnlock(); return end
        local flat = Vector3.new(
            aim.target.Position.X - aim.hrp.Position.X,
            0,
            aim.target.Position.Z - aim.hrp.Position.Z
        ).Unit
        if flat.Magnitude > 0 then
            aim.hrp.CFrame = aim.hrp.CFrame:Lerp(
                CFrame.new(aim.hrp.Position, aim.hrp.Position + flat),
                aim.smooth
            )
        end
    end)

    setupAimbotTrigger()

    Feng:Toggle({
        Name = "使用自瞄",
        Value = aim.on,
        Callback = function(state)
            aim.on = state
            if not state then aimUnlock() end
        end
    })

    Feng:Slider({
        Name = "冷却时间 (秒)",
        Value = { Min = 0.1, Max = 2.0, Default = aim.cooldown },
        Rounding = 1,
        Callback = function(val) aim.cooldown = val end
    })

    Feng:Slider({
        Name = "锁定时间 (秒)",
        Value = { Min = 0.1, Max = 3.0, Default = aim.lockTime },
        Rounding = 1,
        Callback = function(val) aim.lockTime = val end
    })

    Feng:Slider({
        Name = "最大距离",
        Value = { Min = 5, Max = 100, Default = aim.maxDist },
        Callback = function(val) aim.maxDist = val end
    })

    Feng:Slider({
        Name = "旋转平滑度",
        Value = { Min = 0.05, Max = 1.0, Default = aim.smooth },
        Rounding = 2,
        Callback = function(val) aim.smooth = val end
    })
end

local Feng = FengYu:Section({
    Name = "防背刺",
    SubName = "防住两次",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local abs = {
        on = false,
        range = 40,
        duration = 1.5,
        locked = false,
        soundConn = nil,
        scanThread = nil,
        rings = {}
    }
    local absTriggerSounds = { ["86710781315432"] = true, ["99820161736138"] = true }

    local function absAddRing(model)
        pcall(function()
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if not hrp or abs.rings[model] then return end
            local ring = Instance.new("Part")
            ring.Name = "AbsRing"
            ring.Shape = Enum.PartType.Cylinder
            ring.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
            ring.Color = Color3.fromRGB(220, 50, 50)
            ring.Material = Enum.Material.ForceField
            ring.Transparency = 0.5
            ring.CanCollide = false
            ring.CanTouch = false
            ring.CFrame = hrp.CFrame * CFrame.Angles(0, 0, math.rad(90))
            ring.Parent = hrp
            local w = Instance.new("WeldConstraint")
            w.Part0 = hrp
            w.Part1 = ring
            w.Parent = ring
            abs.rings[model] = ring
        end)
    end

    local function absRemoveRing(model)
        pcall(function()
            local r = abs.rings[model]
            if r then r:Destroy() end
            abs.rings[model] = nil
        end)
    end

    local function absResizeRings()
        pcall(function()
            for _, r in pairs(abs.rings) do
                if r and r.Parent then
                    r.Size = Vector3.new(0.1, abs.range * 2, abs.range * 2)
                end
            end
        end)
    end

    local function absCleanRings()
        pcall(function()
            for m in pairs(abs.rings) do absRemoveRing(m) end
        end)
    end

    local function absFindTwoTime()
        local players = workspace:FindFirstChild("Players")
        if not players then return nil end
        for _, folder in ipairs(players:GetChildren()) do
            local tt = folder:FindFirstChild("TwoTime")
            if tt then return tt end
        end
        return nil
    end

    local function absTrigger()
        pcall(function()
            if abs.locked then return end
            local lp = game.Players.LocalPlayer
            local ch = lp.Character
            local myRoot = ch and ch:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            local ttModel = absFindTwoTime()
            if not ttModel then return end
            local ttRoot = ttModel:FindFirstChild("HumanoidRootPart")
            if not ttRoot then return end
            if (myRoot.Position - ttRoot.Position).Magnitude > abs.range then return end
            abs.locked = true
            task.spawn(function()
                local deadline = tick() + abs.duration
                while tick() < deadline do
                    if not abs.on then break end
                    local ch2 = lp.Character
                    local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
                    if not r2 or not ttRoot.Parent then break end
                    r2.CFrame = CFrame.lookAt(r2.Position, Vector3.new(ttRoot.Position.X, r2.Position.Y, ttRoot.Position.Z))
                    game:GetService("RunService").RenderStepped:Wait()
                end
                abs.locked = false
            end)
        end)
    end

    local function absHookSounds()
        pcall(function()
            if abs.soundConn then abs.soundConn:Disconnect(); abs.soundConn = nil end
            local function checkSound(obj)
                if not abs.on or not obj:IsA("Sound") then return end
                local id = obj.SoundId:match("%d+")
                if id and absTriggerSounds[id] then absTrigger() end
            end
            abs.soundConn = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("Sound") then
                    checkSound(obj)
                    obj:GetPropertyChangedSignal("SoundId"):Connect(function() checkSound(obj) end)
                end
            end)
        end)
    end

    local function absStartScan()
        if abs.scanThread then return end
        abs.scanThread = task.spawn(function()
            while abs.on do
                pcall(function()
                    local players = workspace:FindFirstChild("Players")
                    if players then
                        for _, folder in ipairs(players:GetChildren()) do
                            for _, model in ipairs(folder:GetChildren()) do
                                if model.Name == "TwoTime" then absAddRing(model) end
                            end
                        end
                    end
                    for m in pairs(abs.rings) do
                        if not m.Parent then absRemoveRing(m) end
                    end
                end)
                task.wait(1)
            end
            abs.scanThread = nil
        end)
    end

    local function absStart()
        pcall(function()
            absHookSounds()
            absStartScan()
        end)
    end

    local function absStop()
        pcall(function()
            abs.on = false
            if abs.soundConn then
                abs.soundConn:Disconnect()
                abs.soundConn = nil
            end
            if abs.scanThread then
                task.cancel(abs.scanThread)
                abs.scanThread = nil
            end
            absCleanRings()
            abs.locked = false
        end)
    end

    local lp = game.Players.LocalPlayer
    lp.CharacterAdded:Connect(function()
        pcall(function()
            abs.locked = false
            if abs.on then absStart() end
        end)
    end)

    task.spawn(function()
        while true do
            task.wait(10)
            pcall(function()
                local deadRings = {}
                for model, ring in pairs(abs.rings) do
                    if not model or not model.Parent or not ring or not ring.Parent then
                        table.insert(deadRings, model)
                    end
                end
                for _, model in ipairs(deadRings) do
                    abs.rings[model] = nil
                end
            end)
        end
    end)

    Feng:Toggle({
        Name = "启用防背刺",
        Value = abs.on,
        Callback = function(state)
            pcall(function()
                abs.on = state
                if state then absStart() else absStop() end
            end)
        end
    })

    Feng:Slider({
        Name = "检测范围",
        Value = { Min = 10, Max = 120, Default = abs.range },
        Callback = function(value)
            pcall(function()
                abs.range = value
                absResizeRings()
            end)
        end
    })

    Feng:Slider({
        Name = "注视时间",
        Value = { Min = 0.3, Max = 5.0, Default = abs.duration },
        Callback = function(value)
            pcall(function() abs.duration = value end)
        end
    })
end

Window:TabDivider()

local FengYu = Window:Tab("杀手综合功能", "83701039519151")

local Feng = FengYu:Section({
    Name = "干掉他们",
    SubName = "杀掉所有人",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local u2 = { killAllActive = false, killAllFly = false, killAllTeleport = false, flying = false }
    local u4 = { flySpeed = 50 }
    local u5 = { currentTarget = nil }
    local u6 = { killAllConnection = nil, flightConn = nil, bodyGyro = nil, bodyVel = nil }

    local function u69()
        game:GetService("ContextActionService"):UnbindAction('SNT_Flight_Up')
        game:GetService("ContextActionService"):UnbindAction('SNT_Flight_Down')
        u2.flying = false
    end

    local function u83()
        if u2.flying then return end
        u2.flying = true
        local _LocalPlayer = game.Players.LocalPlayer
        local v71 = _LocalPlayer.Character or _LocalPlayer.CharacterAdded:Wait()
        local _HumanoidRootPart = v71:WaitForChild('HumanoidRootPart')
        local _Humanoid = v71:FindFirstChildOfClass('Humanoid')

        if _Humanoid then
            _Humanoid.AutoRotate = false
            u6.bodyGyro = Instance.new('BodyGyro')
            u6.bodyGyro.P = 90000
            u6.bodyGyro.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
            u6.bodyGyro.CFrame = _HumanoidRootPart.CFrame
            u6.bodyGyro.Parent = _HumanoidRootPart

            u6.bodyVel = Instance.new('BodyVelocity')
            u6.bodyVel.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
            u6.bodyVel.Velocity = Vector3.zero
            u6.bodyVel.Parent = _HumanoidRootPart

            u6.flightConn = game:GetService("RunService").Heartbeat:Connect(function()
                local _CurrentCamera = workspace.CurrentCamera
                local _LookVector = _CurrentCamera.CFrame.LookVector
                local _RightVector = _CurrentCamera.CFrame.RightVector
                local _MoveDirection = _Humanoid.MoveDirection
                local v78 = _MoveDirection:Dot(Vector3.new(_LookVector.X, 0, _LookVector.Z).Unit)
                local v79 = _MoveDirection:Dot(Vector3.new(_RightVector.X, 0, _RightVector.Z).Unit)
                local v80 = _MoveDirection.Magnitude <= 0 and 0 or _LookVector.Y * v78
                local v81 = _LookVector * v78 + _RightVector * v79
                local v82 = Vector3.new(v81.X, v80, v81.Z)
                if v82.Magnitude > 1 then v82 = v82.Unit end
                u6.bodyVel.Velocity = v82 * u4.flySpeed
                u6.bodyGyro.CFrame = CFrame.lookAt(_HumanoidRootPart.Position, _HumanoidRootPart.Position + _LookVector, _CurrentCamera.CFrame.UpVector)
            end)
        end
    end

    local function u85()
        if u2.flying then
            u2.flying = false
            u69()
            if u6.flightConn then u6.flightConn:Disconnect(); u6.flightConn = nil end
            if u6.bodyGyro then u6.bodyGyro:Destroy(); u6.bodyGyro = nil end
            if u6.bodyVel then u6.bodyVel:Destroy(); u6.bodyVel = nil end
            local _Character = game.Players.LocalPlayer.Character
            if _Character then
                local hum = _Character:FindFirstChildOfClass('Humanoid')
                if hum then hum.AutoRotate = true end
            end
        end
    end

    local function getNearestSurvivor()
        local _Character9 = game.Players.LocalPlayer.Character
        if not _Character9 then return nil end
        local _HumanoidRootPart9 = _Character9:FindFirstChild('HumanoidRootPart')
        if not _HumanoidRootPart9 then return nil end
        local _Survivors5 = workspace.Players:FindFirstChild('Survivors')
        if not _Survivors5 then return nil end

        local bestDist = math.huge
        local bestTarget = nil
        for _, v562 in ipairs(_Survivors5:GetChildren()) do
            if v562:IsA('Model') and v562:FindFirstChild('Humanoid') and v562.Humanoid.Health > 0 then
                local _HumanoidRootPart10 = v562:FindFirstChild('HumanoidRootPart')
                if _HumanoidRootPart10 then
                    local dist = (_HumanoidRootPart10.Position - _HumanoidRootPart9.Position).Magnitude
                    if dist < bestDist then
                        bestTarget = v562
                        bestDist = dist
                    end
                end
            end
        end
        return bestTarget
    end

    local function moveToTarget(p566)
        if p566 and p566:FindFirstChild('HumanoidRootPart') then
            local _Character10 = game.Players.LocalPlayer.Character
            if _Character10 then
                local _HumanoidRootPart11 = _Character10:FindFirstChild('HumanoidRootPart')
                if _HumanoidRootPart11 then
                    local _HumanoidRootPart12 = p566.HumanoidRootPart
                    if u2.killAllTeleport then
                        local _LookVector2 = _HumanoidRootPart12.CFrame.LookVector
                        local v571 = _HumanoidRootPart12.Position - _LookVector2 * 2.7 + Vector3.new(0, 1.5, 0)
                        _HumanoidRootPart11.CFrame = CFrame.new(v571)
                        _HumanoidRootPart11.CFrame = CFrame.lookAt(v571, _HumanoidRootPart12.Position)
                    elseif u2.killAllFly then
                        if not u2.flying then u83() end
                        local _Unit = (_HumanoidRootPart12.Position - _HumanoidRootPart11.Position).Unit
                        _Character10.Humanoid:MoveTo(_HumanoidRootPart11.Position + _Unit * 10)
                    else
                        _Character10.Humanoid:MoveTo(_HumanoidRootPart12.Position)
                    end
                end
            end
        end
    end

    local function startKillAll()
        if not u2.killAllActive then
            u2.killAllActive = true
            u6.killAllConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if u2.killAllActive then
                    if u5.currentTarget and (not u5.currentTarget.Parent or not u5.currentTarget:FindFirstChild('Humanoid') or u5.currentTarget.Humanoid.Health <= 0) then
                        u5.currentTarget = nil
                    end
                    if not u5.currentTarget then
                        u5.currentTarget = getNearestSurvivor()
                        if not u5.currentTarget then return end
                    end
                    moveToTarget(u5.currentTarget)
                end
            end)
        end
    end

    local function stopKillAll()
        if u2.killAllActive then
            u2.killAllActive = false
            if u6.killAllConnection then
                pcall(function() u6.killAllConnection:Disconnect() end)
                u6.killAllConnection = nil
            end
            u5.currentTarget = nil
            local _Character17 = game.Players.LocalPlayer.Character
            if _Character17 and _Character17:FindFirstChildOfClass('Humanoid') then
                pcall(function() _Character17.Humanoid:MoveTo(_Character17.HumanoidRootPart.Position) end)
            end
            if u2.flying then u85() end
        end
    end

    Feng:Toggle({
        Name = "击杀模式",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(val)
            if val then startKillAll() else stopKillAll() end
        end
    })

    Feng:Toggle({
        Name = "传送模式",
        Value = false,
        
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(val)
            u2.killAllTeleport = val
            if val then u2.killAllFly = false end
        end
    })

    Feng:Button({
        Name = "切换目标",
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function() u5.currentTarget = getNearestSurvivor() end
    })

    game.Players.LocalPlayer.CharacterAdded:Connect(function()
        if u2.killAllActive then stopKillAll() end
    end)

    game.Players.LocalPlayer.CharacterRemoving:Connect(function()
        if u2.flying then u85() end
    end)
end

local Feng = FengYu:Section({
    Name = "吸力",
    SubName = "变成磁铁吸在幸存者上",
    ...
})

do
    local LP = game.Players.LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local suction = {
        enabled = false,
        strength = 50,
        maxDist = 100,
        cache = {},
        cacheTime = 0,
        cacheLife = 0.3,
        conn = nil,
    }

    local function isKiller()
        local char = LP.Character
        if not char then return false end
        local killers = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
        return killers and char:IsDescendantOf(killers)
    end

    local function getNearestSurvivor()
        local now = tick()
        if now - suction.cacheTime < suction.cacheLife and suction.cache.target and suction.cache.target.Parent then
            return suction.cache.target
        end
        suction.cacheTime = now
        suction.cache = {}

        local survivors = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
        if not survivors then return nil end

        local char = LP.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end

        local best, bestDist = nil, math.huge
        for _, model in ipairs(survivors:GetChildren()) do
            if model ~= char and model:IsA("Model") then
                local hum = model:FindFirstChildOfClass("Humanoid")
                local root = model:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < bestDist and d <= suction.maxDist then
                        bestDist = d
                        best = root
                    end
                end
            end
        end
        suction.cache.target = best
        return best
    end

    local function pushToTarget(targetRoot)
        if not targetRoot or not targetRoot.Parent then return end
        local killerChar = LP.Character
        if not killerChar then return end
        local killerHRP = killerChar:FindFirstChild("HumanoidRootPart")
        if not killerHRP then return end
        local direction = (targetRoot.Position - killerHRP.Position)
        if direction.Magnitude < 0.1 then return end
        direction = direction.Unit
        local currentVel = killerHRP.AssemblyLinearVelocity
        local pushForce = direction * suction.strength
        local newVel = currentVel:Lerp(currentVel + pushForce, 0.3)
        killerHRP.AssemblyLinearVelocity = newVel
    end

    local function startSuction()
        if suction.conn then return end
        suction.conn = RunService.RenderStepped:Connect(function()
            if not suction.enabled then return end
            if not isKiller() then return end
            local target = getNearestSurvivor()
            if target then pushToTarget(target) end
        end)
    end

    local function stopSuction()
        if suction.conn then
            suction.conn:Disconnect()
            suction.conn = nil
        end
        suction.cache = {}
    end

    Feng:Toggle({
        Name = "冲向幸存者",
        Value = false,
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(state)
            suction.enabled = state
            if state then startSuction() else stopSuction() end
        end
    })

    Feng:Slider({
        Name = "吸力强度",
        Value = { Min = 5, Max = 100, Default = 50 },
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(v) suction.strength = v end
    })

    Feng:Slider({
        Name = "最大搜索距离",
        Value = { Min = 20, Max = 200, Default = 100 },
Locked = isLocked,
TextLocked = lockTitle,
        Callback = function(v) suction.maxDist = v end
    })

    LP.CharacterAdded:Connect(function()
        if suction.enabled then
            stopSuction()
            startSuction()
        end
    end)
end
local Feng = FengYu:Section({
    Name = "斩首者格挡",
    SubName = "设置",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local autoBlockTriggerAnims = {
        ["124269076578545"] = true, ["126830014841198"] = true, ["18885909645"] = true, ["105458270463374"] = true,
        ["83829782357897"] = true, ["125403313786645"] = true, ["118298475669935"] = true, ["82113744478546"] = true,
        ["70371667919898"] = true, ["109230267448394"] = true, ["139835501033932"] = true, ["109667959938617"] = true,
        ["126681776859538"] = true, ["129976080405072"] = true, ["121293883585738"] = true, ["81639435858902"] = true,
        ["137314737492715"] = true, ["92173139187970"] = true, ["122709416391"] = true, ["879895330952"] = true,
        ["84069821282466"] = true, ["114506382930939"] = true, ["88451353906104"] = true, ["133066252175737"] = true,
        ["99824350842479"] = true, ["132243194360714"] = true, ["91341171001824"] = true, ["120307951"] = true,
        ["124705663396411"] = true, ["122709416391891"] = true, ["106131211773069"] = true, ["81299297965542"] = true,
        ["138938529389204"] = true, ["70483423693126"] = true, ["114126519127454"] = true, ["130958529065375"] = true,
        ["81803417290685"] = true, ["90620531468240"] = true, ["82691533602949"] = true, ["99829427721752"] = true,
        ["93366464803829"] = true, ["107032335460679"] = true, ["112135252467978"] = true, ["77375846492436"] = true,
        ["127245564598429"] = true
    }

    local autoBlockTriggerSounds = {
        ["89004992452376"] = true, ["80516583309685"] = true, ["102228729296384"] = true, ["140242176732868"] = true,
        ["112809109188560"] = true, ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
        ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true, ["95079963655241"] = true,
        ["101199185291628"] = true, ["119942598489800"] = true, ["84307400688050"] = true, ["113037804008732"] = true,
        ["105200830849301"] = true, ["75330693422988"] = true, ["82221759983649"] = true, ["81702359653578"] = true,
        ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true, ["109348678063422"] = true,
        ["85853080745515"] = true, ["12222216"] = true, ["105840448036441"] = true, ["114742322778642"] = true,
        ["119583605486352"] = true, ["79980897195554"] = true, ["71805956520207"] = true, ["79391273191671"] = true,
        ["101553872555606"] = true, ["101698569375359"] = true, ["106300477136129"] = true, ["116581754553533"] = true,
        ["117231507259853"] = true, ["119089145505438"] = true, ["121954639447247"] = true, ["125213046326879"] = true,
        ["131406927389838"] = true, ["71834552297085"] = true, ["805165833096"] = true, ["823363523051"] = true,
        ["120059928759346"] = true, ["82336352305186"] = true, ["104625283622511"] = true, ["126131675979001"] = true,
        ["98675142200448"] = true
    }

    local localPunchAnims = {"87259391926321", "86096387000557", "86709774283672", "140703210927645", "136007065400978", "129843313690921", "108807732150251", "138040001965654"}
    local oneShootAnims = {"73921036900313", "111384272984267", "90499469533503", "133491532453922"}
    local twoTimeTriggerAnims = {
        ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true,
        ["100725497418533"] = true, ["107640065977686"] = true, ["112902284724598"] = true,
        ["106086955212611"] = true, ["77119710693654"] = true
    }

    local slasherParryAnims = {
        ["121255898612475"] = true, ["105614318732282"] = true, ["116618003477002"] = true,
        ["111918351126361"] = true, ["98031287364865"] = true, ["119462383658044"] = true,
        ["87259391926321"] = true, ["86096387000557"] = true, ["86709774283672"] = true,
        ["140703210927645"] = true, ["136007065400978"] = true, ["129843313690921"] = true,
        ["108807732150251"] = true, ["138040001965654"] = true,
        ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true,
        ["100725497418533"] = true, ["107640065977686"] = true, ["112902284724598"] = true,
        ["106086955212611"] = true, ["77119710693654"] = true,
        ["73921036900313"] = true, ["111384272984267"] = true, ["90499469533503"] = true,
        ["133491532453922"] = true
    }

    local slasherParrySounds = {
        ["92445809840331"] = true, ["140258770018994"] = true, ["12222225"] = true,
        ["118234760889759"] = true, ["81714228693719"] = true, ["114486446625838"] = true,
        ["5569523548"] = true, ["119675090901934"] = true, ["132596270805754"] = true,
        ["127324570265084"] = true, ["129249459631748"] = true, ["12222208"] = true,
        ["104632327472742"] = true, ["110279274881589"] = true
    }

    local SlasherSettings = {
        EnragedEnabled    = false,
        EnragedMultiplier = 2.111,
        AutoParry         = false,
        ParryRange        = 15,
        ParryVis          = false,
    }

    local LP = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")

    local function isFakeKiller(killerModel)
        if not killerModel then return true end
        local name = killerModel.Name
        if string.match(name, "^Fake") or string.match(name, "Fake$") then return true end
        local workspacePlayers = Workspace:FindFirstChild("Players")
        local killersFolder = workspacePlayers and workspacePlayers:FindFirstChild("Killers")
        if not killersFolder or not killerModel:IsDescendantOf(killersFolder) then return true end
        return false
    end

    local function ShouldParry(myRoot, parryRange)
        local shouldParry = false
        local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
        if not survivorsFolder then return false end

        for _, survModel in ipairs(survivorsFolder:GetChildren()) do
            local sHrp = survModel:FindFirstChild("HumanoidRootPart")
            if sHrp then
                local dist = (sHrp.Position - myRoot.Position).Magnitude
                if dist <= (parryRange * 3) then
                    local isStandardRange = dist <= parryRange
                    local hum = survModel:FindFirstChildOfClass("Humanoid")
                    local animator = hum and hum:FindFirstChildOfClass("Animator")

                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            local id = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                            if id then
                                local isGuestPunch = table.find(localPunchAnims, id)
                                local isOneShoot = table.find(oneShootAnims, id)
                                local validDist = false
                                if isOneShoot and dist <= (parryRange * 3) then
                                    validDist = true
                                elseif (slasherParryAnims[id] or autoBlockTriggerAnims[id] or isGuestPunch or twoTimeTriggerAnims[id]) and isStandardRange then
                                    validDist = true
                                end
                                if validDist then
                                    if track.TimePosition <= 0.45 then
                                        shouldParry = true
                                        break
                                    end
                                end
                            end
                        end
                    end

                    if not shouldParry and isStandardRange then
                        for _, desc in ipairs(survModel:GetDescendants()) do
                            if desc:IsA("Sound") and desc.IsPlaying then
                                local soundId = tostring(desc.SoundId):match("%d+")
                                if soundId and (autoBlockTriggerSounds[soundId] or slasherParrySounds[soundId]) then
                                    shouldParry = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if shouldParry then break end
        end
        return shouldParry
    end

    local function getSlasherRagingPaceCD()
        local playerGui = LP:FindFirstChild("PlayerGui")
        local mainUI = playerGui and playerGui:FindFirstChild("MainUI")
        local abilityContainer = mainUI and mainUI:FindFirstChild("AbilityContainer")
        local ragingPaceFrame = abilityContainer and abilityContainer:FindFirstChild("RagingPace")
        if ragingPaceFrame then
            local cdTime = ragingPaceFrame:FindFirstChild("CooldownTime")
            if cdTime and cdTime.Visible and cdTime.Text ~= "" then
                return tonumber(cdTime.Text) or 0
            end
        end
        return 0
    end

    local lastSlasherParryTime = 0

    task.spawn(function()
        while task.wait(0.1) do
            if not SlasherSettings.EnragedEnabled then continue end

            local playersFolder = Workspace:FindFirstChild("Players")
            if playersFolder then
                local killersFolder = playersFolder:FindFirstChild("Killers")
                if killersFolder then
                    for _, killerModel in ipairs(killersFolder:GetChildren()) do
                        if isFakeKiller(killerModel) then continue end
                        local speedMults = killerModel:FindFirstChild("SpeedMultipliers")
                        if speedMults then
                            local enraged = speedMults:FindFirstChild("ENRAGED")
                            if enraged then
                                enraged.Value = SlasherSettings.EnragedMultiplier
                            end
                        end
                    end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local myChar = LP.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local isSlasher = string.find(myChar.Name, "Slasher") and myChar:GetAttribute("Username") == LP.Name
        if not isSlasher then return end

        if SlasherSettings.AutoParry then
            local shouldParry = ShouldParry(myRoot, SlasherSettings.ParryRange)
            local cd = getSlasherRagingPaceCD()
            local now = tick()
            if shouldParry and cd <= 0 and (now - lastSlasherParryTime) >= 0.5 then
                lastSlasherParryTime = now
                task.spawn(function()
                    local args = {
                        "UseActorAbility",
                        { buffer.fromstring("\003\n\000\000\000RagingPace") }
                    }
                    for i = 1, 3 do
                        pcall(function() RemoteEvent:FireServer(unpack(args)) end)
                    end
                    task.wait(0.05)
                    for i = 1, 3 do
                        pcall(function() RemoteEvent:FireServer(unpack(args)) end)
                    end
                end)
            end
        end

        local parryVis = myRoot:FindFirstChild("ParryRangeVis")
        if SlasherSettings.ParryVis then
            if not parryVis then
                parryVis = Instance.new("CylinderHandleAdornment")
                parryVis.Name = "ParryRangeVis"
                parryVis.Adornee = myRoot
                parryVis.Height = 0.05
                parryVis.Color3 = Color3.fromRGB(255, 140, 0)
                parryVis.Transparency = 0.6
                parryVis.ZIndex = 1
                parryVis.Parent = myRoot
            end
            parryVis.Radius = SlasherSettings.ParryRange
            parryVis.InnerRadius = math.max(0, SlasherSettings.ParryRange - 0.5)
            parryVis.CFrame = CFrame.new(0, -myRoot.Size.Y/2, 0) * CFrame.Angles(math.rad(90), 0, 0)
            parryVis.Visible = true
        elseif parryVis then
            parryVis.Visible = false
        end
    end)

    Feng:Toggle({
        Name = "狂暴速度",
        Value = SlasherSettings.EnragedEnabled,
        Callback = function(val) SlasherSettings.EnragedEnabled = val end
    })

    Feng:Slider({
        Name = "狂暴速度倍率",
        Value = { Min = 2.111, Max = 3.4, Default = SlasherSettings.EnragedMultiplier },
        Rounding = 3,
        Callback = function(val) SlasherSettings.EnragedMultiplier = val end
    })

    Feng:Toggle({
        Name = "自动狂暴速度格挡",
        Value = SlasherSettings.AutoParry,
        Callback = function(val) SlasherSettings.AutoParry = val end
    })

    Feng:Slider({
        Name = "狂暴速度格挡范围",
        Value = { Min = 5, Max = 40, Default = SlasherSettings.ParryRange },
        Callback = function(val) SlasherSettings.ParryRange = val end
    })

    Feng:Toggle({
        Name = "(可视化)狂暴速度范围",
        Value = SlasherSettings.ParryVis,
        Callback = function(val) SlasherSettings.ParryVis = val end
    })
end

local Feng = FengYu:Section({
    Name = "约翰.多格挡",
    SubName = "设置",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

do
    local autoBlockTriggerAnims = {
        ["124269076578545"] = true, ["126830014841198"] = true, ["18885909645"] = true, ["105458270463374"] = true,
        ["83829782357897"] = true, ["125403313786645"] = true, ["118298475669935"] = true, ["82113744478546"] = true,
        ["70371667919898"] = true, ["109230267448394"] = true, ["139835501033932"] = true, ["109667959938617"] = true,
        ["126681776859538"] = true, ["129976080405072"] = true, ["121293883585738"] = true, ["81639435858902"] = true,
        ["137314737492715"] = true, ["92173139187970"] = true, ["122709416391"] = true, ["879895330952"] = true,
        ["84069821282466"] = true, ["114506382930939"] = true, ["88451353906104"] = true, ["133066252175737"] = true,
        ["99824350842479"] = true, ["132243194360714"] = true, ["91341171001824"] = true, ["120307951"] = true,
        ["124705663396411"] = true, ["122709416391891"] = true, ["106131211773069"] = true, ["81299297965542"] = true,
        ["138938529389204"] = true, ["70483423693126"] = true, ["114126519127454"] = true, ["130958529065375"] = true,
        ["81803417290685"] = true, ["90620531468240"] = true, ["82691533602949"] = true, ["99829427721752"] = true,
        ["93366464803829"] = true, ["107032335460679"] = true, ["112135252467978"] = true, ["77375846492436"] = true,
        ["127245564598429"] = true
    }

    local autoBlockTriggerSounds = {
        ["89004992452376"] = true, ["80516583309685"] = true, ["102228729296384"] = true, ["140242176732868"] = true,
        ["112809109188560"] = true, ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
        ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true, ["95079963655241"] = true,
        ["101199185291628"] = true, ["119942598489800"] = true, ["84307400688050"] = true, ["113037804008732"] = true,
        ["105200830849301"] = true, ["75330693422988"] = true, ["82221759983649"] = true, ["81702359653578"] = true,
        ["108610718831698"] = true, ["112395455254818"] = true, ["109431876587852"] = true, ["109348678063422"] = true,
        ["85853080745515"] = true, ["12222216"] = true, ["105840448036441"] = true, ["114742322778642"] = true,
        ["119583605486352"] = true, ["79980897195554"] = true, ["71805956520207"] = true, ["79391273191671"] = true,
        ["101553872555606"] = true, ["101698569375359"] = true, ["106300477136129"] = true, ["116581754553533"] = true,
        ["117231507259853"] = true, ["119089145505438"] = true, ["121954639447247"] = true, ["125213046326879"] = true,
        ["131406927389838"] = true, ["71834552297085"] = true, ["805165833096"] = true, ["823363523051"] = true,
        ["120059928759346"] = true, ["82336352305186"] = true, ["104625283622511"] = true, ["126131675979001"] = true,
        ["98675142200448"] = true
    }

    local localPunchAnims = {"87259391926321", "86096387000557", "86709774283672", "140703210927645", "136007065400978", "129843313690921", "108807732150251", "138040001965654"}
    local oneShootAnims = {"73921036900313", "111384272984267", "90499469533503", "133491532453922"}
    local twoTimeTriggerAnims = {
        ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true,
        ["100725497418533"] = true, ["107640065977686"] = true, ["112902284724598"] = true,
        ["106086955212611"] = true, ["77119710693654"] = true
    }
    local slasherParryAnims = {
        ["121255898612475"] = true, ["105614318732282"] = true, ["116618003477002"] = true,
        ["111918351126361"] = true, ["98031287364865"] = true, ["119462383658044"] = true,
        ["87259391926321"] = true, ["86096387000557"] = true, ["86709774283672"] = true,
        ["140703210927645"] = true, ["136007065400978"] = true, ["129843313690921"] = true,
        ["108807732150251"] = true, ["138040001965654"] = true,
        ["119434518007321"] = true, ["115194624791339"] = true, ["89448354637442"] = true,
        ["100725497418533"] = true, ["107640065977686"] = true, ["112902284724598"] = true,
        ["106086955212611"] = true, ["77119710693654"] = true,
        ["73921036900313"] = true, ["111384272984267"] = true, ["90499469533503"] = true,
        ["133491532453922"] = true
    }
    local slasherParrySounds = {
        ["92445809840331"] = true, ["140258770018994"] = true, ["12222225"] = true,
        ["118234760889759"] = true, ["81714228693719"] = true, ["114486446625838"] = true,
        ["5569523548"] = true, ["119675090901934"] = true, ["132596270805754"] = true,
        ["127324570265084"] = true, ["129249459631748"] = true, ["12222208"] = true,
        ["104632327472742"] = true, ["110279274881589"] = true
    }

    local JohnDoeSettings = { AutoParry = false, ParryRange = 15, ParryVis = false }

    local LP = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("Network"):WaitForChild("RemoteEvent")

    local function ShouldParry(myRoot, parryRange)
        local shouldParry = false
        local survivorsFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Survivors")
        if not survivorsFolder then return false end

        for _, survModel in ipairs(survivorsFolder:GetChildren()) do
            local sHrp = survModel:FindFirstChild("HumanoidRootPart")
            if sHrp then
                local dist = (sHrp.Position - myRoot.Position).Magnitude
                if dist <= (parryRange * 3) then
                    local isStandardRange = dist <= parryRange
                    local hum = survModel:FindFirstChildOfClass("Humanoid")
                    local animator = hum and hum:FindFirstChildOfClass("Animator")

                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            local id = tostring(track.Animation and track.Animation.AnimationId or ""):match("%d+")
                            if id then
                                local isGuestPunch = table.find(localPunchAnims, id)
                                local isOneShoot = table.find(oneShootAnims, id)
                                local validDist = false
                                if isOneShoot and dist <= (parryRange * 3) then
                                    validDist = true
                                elseif (slasherParryAnims[id] or autoBlockTriggerAnims[id] or isGuestPunch or twoTimeTriggerAnims[id]) and isStandardRange then
                                    validDist = true
                                end
                                if validDist then
                                    if track.TimePosition <= 0.45 then
                                        shouldParry = true
                                        break
                                    end
                                end
                            end
                        end
                    end

                    if not shouldParry and isStandardRange then
                        for _, desc in ipairs(survModel:GetDescendants()) do
                            if desc:IsA("Sound") and desc.IsPlaying then
                                local soundId = tostring(desc.SoundId):match("%d+")
                                if soundId and (autoBlockTriggerSounds[soundId] or slasherParrySounds[soundId]) then
                                    shouldParry = true
                                    break
                                end
                            end
                        end
                    end
                end
            end
            if shouldParry then break end
        end
        return shouldParry
    end

    local function get404ErrorCooldown()
        local playerGui = LP:FindFirstChild("PlayerGui")
        local mainUI = playerGui and playerGui:FindFirstChild("MainUI")
        local abilityContainer = mainUI and mainUI:FindFirstChild("AbilityContainer")
        local errorFrame = abilityContainer and abilityContainer:FindFirstChild("404Error")
        if errorFrame then
            local cdTime = errorFrame:FindFirstChild("CooldownTime")
            if cdTime and cdTime.Visible and cdTime.Text ~= "" then
                return tonumber(cdTime.Text) or 0
            end
        end
        return 0
    end

    local lastJohnDoeParryTime = 0

    RunService.Heartbeat:Connect(function()
        local myChar = LP.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local isJohnDoe = string.find(myChar.Name, "JohnDoe") and myChar:GetAttribute("Username") == LP.Name
        if not isJohnDoe then return end

        if JohnDoeSettings.AutoParry then
            local shouldParry = ShouldParry(myRoot, JohnDoeSettings.ParryRange)
            local cd = get404ErrorCooldown()
            local now = tick()
            if shouldParry and cd <= 0 and (now - lastJohnDoeParryTime) >= 2.0 then
                lastJohnDoeParryTime = now
                task.spawn(function()
                    local args = {
                        "UseActorAbility",
                        { buffer.fromstring("\003\b\000\000\000404Error") }
                    }
                    pcall(function() RemoteEvent:FireServer(unpack(args)) end)
                end)
            end
        end

        local jdParryVis = myRoot:FindFirstChild("JDParryRangeVis")
        if JohnDoeSettings.ParryVis then
            if not jdParryVis then
                jdParryVis = Instance.new("CylinderHandleAdornment")
                jdParryVis.Name = "JDParryRangeVis"
                jdParryVis.Adornee = myRoot
                jdParryVis.Height = 0.05
                jdParryVis.Color3 = Color3.fromRGB(0, 0, 0)
                jdParryVis.Transparency = 0.6
                jdParryVis.ZIndex = 1
                jdParryVis.Parent = myRoot
            end
            jdParryVis.Radius = JohnDoeSettings.ParryRange
            jdParryVis.InnerRadius = math.max(0, JohnDoeSettings.ParryRange - 0.5)
            jdParryVis.CFrame = CFrame.new(0, -myRoot.Size.Y/2, 0) * CFrame.Angles(math.rad(90), 0, 0)
            jdParryVis.Visible = true
        elseif jdParryVis then
            jdParryVis.Visible = false
        end
    end)

    Feng:Toggle({
        Name = "自动404错误格挡",
        Value = JohnDoeSettings.AutoParry,
        Callback = function(val) JohnDoeSettings.AutoParry = val end
    })

    Feng:Slider({
        Name = "404错误格挡范围",
        Value = { Min = 5, Max = 40, Default = JohnDoeSettings.ParryRange },
        Callback = function(val) JohnDoeSettings.ParryRange = val end
    })

    Feng:Toggle({
        Name = "(可视化)404错误范围",
        Value = JohnDoeSettings.ParryVis,
        Callback = function(val) JohnDoeSettings.ParryVis = val end
    })
end

local FengYu = Window:Tab("娱乐区", "83701039519151")
local Feng = FengYu:Section({
    Name = "权限设置",
    SubName = "修改权限",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

Feng:Button({
    Name = "获取皮肤",
Locked = isLocked,
TextLocked = lockTitle,
    Callback = function()
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local purchased = player:WaitForChild("PlayerData"):WaitForChild("Purchased")

            local killersFolder = purchased:FindFirstChild("Killers") or Instance.new("Folder", purchased)
            killersFolder.Name = "Killers"
            local survivorsFolder = purchased:FindFirstChild("Survivors") or Instance.new("Folder", purchased)
            survivorsFolder.Name = "Survivors"
            local skinsFolder = purchased:FindFirstChild("Skins") or Instance.new("Folder", purchased)
            skinsFolder.Name = "Skins"

            for _, killer in ipairs(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Killers"):GetChildren()) do
                if not killersFolder:FindFirstChild(killer.Name) then
                    Instance.new("StringValue", killersFolder).Name = killer.Name
                end
            end

            for _, survivor in ipairs(game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Survivors"):GetChildren()) do
                if not survivorsFolder:FindFirstChild(survivor.Name) then
                    Instance.new("StringValue", survivorsFolder).Name = survivor.Name
                end
            end

            local skinsRoot = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Skins")
            for _, skin in ipairs(skinsRoot:GetDescendants()) do
                if (skin:IsA("Folder") or skin:IsA("Model")) and not skinsFolder:FindFirstChild(skin.Name) then
                    Instance.new("StringValue", skinsFolder).Name = skin.Name
                end
            end
        end)
    end
})

Feng:Button({
    Name = "解锁所有动作",
Locked = isLocked,
TextLocked = lockTitle,
    Callback = function()
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local purchased = player:WaitForChild("PlayerData"):WaitForChild("Purchased")

            local emotesFolder = purchased:FindFirstChild("Emotes") or Instance.new("Folder", purchased)
            emotesFolder.Name = "Emotes"

            local emotesAssets = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Emotes")
            for _, module in ipairs(emotesAssets:GetDescendants()) do
                if module:IsA("ModuleScript") and not emotesFolder:FindFirstChild(module.Name) then
                    Instance.new("StringValue", emotesFolder).Name = module.Name
                end
            end
        end)
    end
})

Feng:Button({
    Name = "解锁VIP权限",
Locked = isLocked,
TextLocked = lockTitle,
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        localPlayer:SetAttribute("VIP", true)

        local pData = localPlayer:WaitForChild("PlayerData")
        local vVal = pData:FindFirstChild("VIP")
        if not vVal then
            vVal = Instance.new("BoolValue")
            vVal.Name = "VIP"
            vVal.Parent = pData
        end
        vVal.Value = true
    end
})

local Feng = FengYu:Section({
    Name = "修改系统",
    SubName = "视觉VIP",
    Logo = "83701039519151",
    Collapsible = true,
    Collapsed = true,
})

local statsFields = {
    Money = "钱",
    NetWorth = "净资产",
    KillerChance = "杀手几率",
    TimePlayed = "游玩时间",
    KillerWins = "杀手胜利",
    Kills = "击杀数",
    SurvivorWins = "幸存者胜利",
    ObjectivesCompleted = "任务完成数"
}

for statName, displayName in pairs(statsFields) do
    Feng:Input({
        Name = "设置 " .. displayName,
Locked = isLocked,
TextLocked = lockTitle,
        Placeholder = "输入数值",
        Callback = function(value)
            pcall(function()
                local localPlayer = game.Players.LocalPlayer
                local stats = localPlayer:FindFirstChild("PlayerData") and localPlayer.PlayerData:FindFirstChild("Stats")
                if not stats then return end
                local statObj = stats:FindFirstChild(statName, true)
                if statObj and (statObj:IsA("NumberValue") or statObj:IsA("IntValue") or statObj:IsA("FloatValue")) then
                    local num = tonumber(value)
                    if num then statObj.Value = num end
                end
            end)
        end
    })
end