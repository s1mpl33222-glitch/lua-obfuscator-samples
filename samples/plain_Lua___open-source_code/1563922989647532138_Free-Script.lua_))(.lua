-- ts file was generated at discord.gg/25ms

local CarGuardEnabled = false
local oldFireServer

oldFireServer = hookfunction(Instance.new('RemoteEvent').FireServer, newcclosure(function(self, ...)
    local args = {...}

    if not checkcaller() and CarGuardEnabled and tostring(self) == 'Send' then
        for _, v in pairs(args)do
            if tostring(v) == 'crashed_car' then
                return nil
            end
        end
    end

    return oldFireServer(self, ...)
end))

if not game:IsLoaded() then
    repeat
        task.wait()
    until game:IsLoaded()
end
if not (game.PlaceId == 104715542330896 or game.PlaceId == 97556409405464) then
    return
end

game:GetService('ReplicatedStorage')

if getgenv then
    getgenv().identifyexecutor = nil
end
if getfenv then
    local env = getfenv()

    env.identifyexecutor = nil
end

local v_u_1 = {}
local v2 = game.ReplicatedStorage:WaitForChild('Remotes')
local v_u_3 = {
    send = v2:WaitForChild('Send'),
    get = v2:WaitForChild('Get'),
}
local v_u_4 = {
    event = 0,
    func = 0,
}
local v_u_5 = {}
local v_u_6 = false
local v_u_7 = {}

function v_u_1.on_connect(p8)
    if v_u_6 then
        p8()
    else
        v_u_7[#v_u_7 + 1] = p8
    end
end
function v_u_1.hook(p_u_9, p_u_10)
    if not p_u_10 then
        error('Function nil for hook ' .. p_u_9)
    end
    if v_u_6 then
        if v_u_5[p_u_9] then
            warn("Overwriting hook '" .. p_u_9 .. "'.")
        else
            v_u_5[p_u_9] = p_u_10
        end
    else
        v_u_1.on_connect(function()
            v_u_1.hook(p_u_9, p_u_10)
        end)

        return
    end
end
function v_u_1.is_connected(p11)
    return p11:GetAttribute('IsConnected') and true or false
end

local function v_u_19(p12, p13, p14, p15, ...)
    return p12(p13, p14, p15, ...)
end

task.wait(0.1)

local v_u_20 = v_u_3.send
local v_u_21 = v_u_3.send.FireServer

function v_u_1.send(p22, ...)
    if CarGuardEnabled and p22 == 'crashed_car' then
        return nil
    end

    v_u_4.event = v_u_4.event + 1

    v_u_21(v_u_20, v_u_4.event, p22, ...)
end

local v_u_23 = v_u_3.get
local v_u_24 = v_u_3.get.InvokeServer

function v_u_1.get(p25, ...)
    v_u_4.func = v_u_4.func + 1

    return v_u_24(v_u_23, v_u_4.func, p25, ...)
end

task.wait(0.1)

local function v_u_29()
    v_u_3.send.OnClientEvent:connect(function(p26, ...)
        if v_u_5[p26] then
            v_u_5[p26](...)
        else
            error("Invalid hook '" .. p26 .. "' fired!", 0)
        end
    end)

    function v_u_3.get.OnClientInvoke(p27, ...)
        if v_u_5[p27] then
            return v_u_5[p27](...)
        end

        error("Invalid hook '" .. p27 .. "' invoked!", 0)
    end

    if not pcall(function()
        for v28 = 1, #v_u_7 do
            v_u_7[v28]()
        end
    end) then
        pcall(function()
            print('On connect failed for client')
            v_u_1.send('issue', 'On connect failed for client')
        end)
    end
end

function v_u_1.initiate() end
function v_u_1.loaded()
    function v_u_3.get.OnClientInvoke(p30)
        if p30 == 'connect' then
            v_u_6 = true

            v_u_29()

            return true
        end
    end

    v_u_1.hook('ping', function()
        return true
    end)
end

print('bypassed')

local TweenService = game:GetService('TweenService')
local Players = game:GetService('Players')
local player = Players.LocalPlayer

task.spawn(function()
    local splashGui = player.PlayerGui:WaitForChild('SplashScreenGui', 5)

    if splashGui then
        local frame = splashGui:FindFirstChild('Frame')

        if frame then
            frame.Visible = false
        end

        local redBackdrop = splashGui:FindFirstChild('RedBackdrop')

        if redBackdrop and redBackdrop:FindFirstChild('UIGradient') then
            local gradient = redBackdrop.UIGradient

            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.new(0.421, 0.411, 0.498)),
            })
        end
    end
end)

local modeSelected = false

local function RunNormalMode()
    if getgenv then
        getgenv().identifyexecutor = nil
    end
    if getfenv then
        getfenv().identifyexecutor = nil
    end

    local ReplicatedStorage = game:GetService('ReplicatedStorage')
    local Net = require(ReplicatedStorage.Modules.Core.Net)
    local UI = require(ReplicatedStorage.Modules.Core.UI)

    task.spawn(function()
        local TransitionUI = nil

        while not TransitionUI do
            for _, v in pairs(getgc(true))do
                if type(v) == 'table' and rawget(v, 'conditional_transition') then
                    TransitionUI = v

                    break
                end
            end

            task.wait(0.1)
        end

        TransitionUI.transition = function()
            return
        end
        TransitionUI.conditional_transition = function()
            return
        end

        if TransitionUI.enabled then
            TransitionUI.enabled.set(false)
        end
        if TransitionUI.conditional_enabled then
            TransitionUI.conditional_enabled.set(false)
        end
    end)
    task.spawn(function()
        workspace:SetAttribute('SkipCreator', true)

        local CC = nil

        while not CC do
            for _, v in pairs(getgc(true))do
                if type(v) == 'table' and rawget(v, 'is_in_creator') and rawget(v, 'finish') then
                    CC = v

                    break
                end
            end

            task.wait(0.1)
        end

        CC.is_in_creator.hook(function(isIn)
            if isIn then
                CC.finish(false)
            end
        end)

        if CC.leaving_creator then
            CC.leaving_creator.set(true)
        end
    end)
    task.spawn(function()
        local PlayButton = UI.get('PlayButton')

        if PlayButton then
            for _, connection in pairs(getconnections(PlayButton.MouseButton1Click))do
                connection:Fire()
            end
        end
    end)

    modeSelected = true
end
local function RunGodMode()
    local ReplicatedStorage = game:GetService('ReplicatedStorage')
    local UI = require(ReplicatedStorage.Modules.Core.UI)
    local Net = require(ReplicatedStorage.Modules.Core.Net)
    local Char = require(ReplicatedStorage.Modules.Core.Char)

    local function ExecuteGodModeStrict()
        local hrp = Char.get_hrp()

        if not hrp then
            return false
        end

        local frozenCFrame = hrp.CFrame
        local oldSend = Net.send

        Net.send = function(name, ...)
            if name == 'replicate_cc_cframe' then
                if type(oldSend) == 'function' then
                    return oldSend(name, frozenCFrame)
                end

                return
            end
            if name == 'leave_character_creator' or name == 'player_created_outfit' then
                return nil
            end
            if type(oldSend) == 'function' then
                return oldSend(name, ...)
            end
        end

        task.spawn(function()
            while task.wait(0.1) do
                if hrp and hrp.Parent then
                    hrp.Anchored = false
                end
            end
        end)

        for _, v in pairs(getgc(true))do
            if type(v) == 'table' and rawget(v, 'leaving_creator') and type(v.leaving_creator) == 'table' then
                v.leaving_creator.set(true)

                break
            end
        end

        pcall(function()
            Net.send('request_respawn')
        end)
        task.wait(6.2)
        pcall(function()
            return Net.get('death_screen_request_respawn')
        end)

        return true
    end

    task.spawn(function()
        local TransitionUI = nil

        while not TransitionUI do
            for _, v in pairs(getgc(true))do
                if type(v) == 'table' and rawget(v, 'conditional_transition') then
                    TransitionUI = v

                    break
                end
            end

            task.wait(0.5)
        end

        local oldTransition = TransitionUI.conditional_transition

        TransitionUI.conditional_transition = function(self, p15, p16, p17)
            local originalWait = TransitionUI.conditional_enabled.wait

            TransitionUI.conditional_enabled.wait = function(...)
                local startTime = tick()

                ExecuteGodModeStrict()

                local elapsed = tick() - startTime

                if elapsed < 8 then
                    task.wait(8 - elapsed)
                end

                return nil
            end

            local res = oldTransition(self, p15, p16, p17)

            TransitionUI.conditional_enabled.wait = originalWait

            return res
        end
    end)
    task.spawn(function()
        local CC = nil

        while not CC do
            for _, v in pairs(getgc(true))do
                if type(v) == 'table' and rawget(v, 'is_in_creator') and rawget(v, 'finish') then
                    CC = v

                    break
                end
            end

            task.wait(0.1)
        end

        CC.is_in_creator.hook(function(isIn)
            if isIn then
                task.wait(0)
                CC.finish(false)
            end
        end)
    end)

    local PlayButton = UI.get('PlayButton')

    if PlayButton then
        for _, v in pairs(getconnections(PlayButton.MouseButton1Click))do
            v:Fire()
        end
    end

    modeSelected = true
end

if player:GetAttribute('InSplashScreen') == true then
    if player.PlayerGui:FindFirstChild('FreemiumHub') then
        player.PlayerGui.PremiumHub:Destroy()
    end

    local ScreenGui = Instance.new('ScreenGui')

    ScreenGui.Name = 'PremiumHub'
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new('Frame')

    MainFrame.Name = 'MainFrame'
    MainFrame.Size = UDim2.new(0, 450, 0, 280)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 35)
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local BackgroundImg = Instance.new('ImageLabel')

    BackgroundImg.Name = 'BackgroundImage'
    BackgroundImg.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImg.BackgroundTransparency = 1
    BackgroundImg.Image = 'rbxassetid://126245499022200'
    BackgroundImg.ImageTransparency = 0.7
    BackgroundImg.ScaleType = Enum.ScaleType.Crop
    BackgroundImg.ZIndex = 0
    BackgroundImg.Parent = MainFrame

    local BGCorners = Instance.new('UICorner')

    BGCorners.CornerRadius = UDim.new(0, 20)
    BGCorners.Parent = BackgroundImg

    local UICorner = Instance.new('UICorner')

    UICorner.CornerRadius = UDim.new(0, 20)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new('UIStroke')

    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(0, 170, 255)
    UIStroke.Transparency = 0.4
    UIStroke.Parent = MainFrame

    local Logo = Instance.new('ImageLabel')

    Logo.Name = 'Logo'
    Logo.Size = UDim2.new(0, 60, 0, 60)
    Logo.Position = UDim2.new(0.5, -30, 0, 20)
    Logo.BackgroundTransparency = 1
    Logo.Image = 'rbxassetid://121136649812616'
    Logo.ZIndex = 2
    Logo.Parent = MainFrame

    local Title = Instance.new('TextLabel')

    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 85)
    Title.BackgroundTransparency = 1
    Title.Text = 'KUNLUN | Script Premium'
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 24
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 2
    Title.Parent = MainFrame

    local Subtitle = Instance.new('TextLabel')

    Subtitle.Size = UDim2.new(1, 0, 0, 20)
    Subtitle.Position = UDim2.new(0, 0, 0, 120)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = 'Select mode to play'
    Subtitle.TextColor3 = Color3.fromRGB(150, 210, 255)
    Subtitle.TextSize = 14
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.ZIndex = 2
    Subtitle.Parent = MainFrame

    local function createModeButton(name, text, pos, isSpecial)
        local btn = Instance.new('TextButton')

        btn.Name = name
        btn.Size = UDim2.new(0, 380, 0, 45)
        btn.Position = pos
        btn.BackgroundColor3 = isSpecial and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = isSpecial and 0.2 or 0.9
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 16
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        btn.Parent = MainFrame

        local bCorner = Instance.new('UICorner')

        bCorner.CornerRadius = UDim.new(0, 10)
        bCorner.Parent = btn

        local bStroke = Instance.new('UIStroke')

        bStroke.Thickness = 1.5
        bStroke.Color = Color3.fromRGB(0, 170, 255)
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        bStroke.Transparency = 0.5
        bStroke.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = isSpecial and 0 or 0.7,
                Size = UDim2.new(0, 390, 0, 48),
                Position = pos + UDim2.new(0, -5, 0, -1.5),
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = isSpecial and 0.2 or 0.9,
                Size = UDim2.new(0, 380, 0, 45),
                Position = pos,
            }):Play()
        end)

        return btn
    end

    local NormalBtn = createModeButton('NormalMode', 'Normal Mode', UDim2.new(0.5, -190, 0, 155), false)
    local GodBtn = createModeButton('GodMode', 'God Mode', UDim2.new(0.5, -190, 0, 210), true)

    NormalBtn.MouseButton1Click:Connect(function()
        MainFrame:TweenPosition(UDim2.new(0.5, -225, 1.1, 0), 'In', 'Back', 0.5)
        task.wait(0.5)
        ScreenGui:Destroy()
        RunNormalMode()
    end)
    GodBtn.MouseButton1Click:Connect(function()
        MainFrame:TweenPosition(UDim2.new(0.5, -225, 1.1, 0), 'In', 'Back', 0.5)
        task.wait(0.5)
        ScreenGui:Destroy()
        RunGodMode()
    end)

    repeat
        task.wait(0.1)
    until modeSelected
else
    modeSelected = true
end

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local HttpService = game:GetService('HttpService')
local UserInputService = game:GetService('UserInputService')
local Debris = game:GetService('Debris')
local CurrentCamera = workspace.CurrentCamera
local Client = Players.LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()
local PlayerGui = Client.PlayerGui
local Humanoid = Character:WaitForChild('Humanoid')
local RootPart = Character:WaitForChild('HumanoidRootPart')
local Backpack = Client:WaitForChild('Backpack')
local Net = require(ReplicatedStorage.Modules.Core.Net)
local RagdollModule = require(ReplicatedStorage.Modules.Game.Ragdoll)
local Vechine = require(ReplicatedStorage.Modules.Game.VehicleSystem.Vehicle)
local CharModule = require(ReplicatedStorage.Modules.Core.Char)
local SprintModule = require(ReplicatedStorage.Modules.Game.Sprint)
local CrateController = require(ReplicatedStorage.Modules.Game.CrateSystem.Crate)
local Settings = {}

function c()
    return Settings
end

local function GetDistanceFromRootPart(target)
    if not target then
        return math.huge
    end
    if not RootPart or not RootPart.Parent then
        RootPart = Client.Character and Client.Character:FindFirstChild('HumanoidRootPart')
    end
    if not RootPart then
        return math.huge
    end

    return (RootPart.Position - target.Position).Magnitude
end

Client.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild('Humanoid')
    RootPart = Character:WaitForChild('HumanoidRootPart')
    Backpack = Client:WaitForChild('Backpack')
end)

local Sf = {}
local Sprint = require(game:GetService('ReplicatedStorage').Modules.Game.Sprint)
local consume_stamina = Sprint.consume_stamina
local SprintBar = debug.getupvalue(consume_stamina, 2).sprint_bar
local holdingJump = false
local WindUI

do
    local ok, result = pcall(function()
        return require('./WindUi')
    end)

    if ok then
        WindUI = result
    else
        if cloneref(game:GetService('RunService')):IsStudio() then
            WindUI = require(cloneref(ReplicatedStorage:WaitForChild('WindUI'):WaitForChild('Init')))
        else
            WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua'))()
        end
    end
end

local Icons = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Footagesus/Icons/main/Main.lua'))()

Icons.SetIconsType('lucide')

local Window = WindUI:CreateWindow({
    Icon = 'rbxassetid://121136649812616',
    IconThemed = true,
    Title = "Kunlun's | Freemium",
    Icon = 'rbxassetid://121136649812616',
    Author = 'by #TBSkyen | discord.gg/StevCommunity',
    Folder = "Kunlun's",
    Size = UDim2.fromOffset(400, 400),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = 'Dark',
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    OpenButton = {
        Title = "Kunlun's",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
    },
})

Window:Tag({
    Title = 'v1.0.4',
    Color = Color3.fromHex('#30ff6a'),
    Radius = 13,
})
Window:Tag({
    Title = 'Blockspin',
    Color = Color3.fromHex('#FF0000'),
    Radius = 13,
})

local MainTab = Window:Tab({
    Title = 'General',
    Icon = 'globe',
})
local BankBalance = MainTab:Button({
    Title = '\u{1f3e6} Bank Balance',
    Desc = 'N/A',
})
local HandBalance = MainTab:Button({
    Title = '\u{1f4b8} Hand Balance',
    Desc = 'N/A',
})

local function HandMoney()
    return tonumber(PlayerGui.TopRightHud.Holder.Frame.MoneyTextLabel.Text:match('%$(%d+)'))
end
local function ATMMoney()
    for _, v in ipairs(PlayerGui:GetDescendants())do
        if v:IsA('TextLabel') and string.find(v.Text, 'Bank Balance') then
            return tonumber(v.Text:match('%$(%d+)'))
        end
    end

    return 0
end

task.spawn(function()
    while task.wait(0.2) do
        BankBalance:SetDesc('<b><font color="#00FF00">$' .. (ATMMoney() or 0) .. '</font></b>')
        HandBalance:SetDesc('<b><font color="#00f2ff">$' .. (HandMoney() or 0) .. '</font></b>')
    end
end)
MainTab:Section({
    Title = 'Player Modifier:',
})

local Players = game:GetService('Players')
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Net = require(ReplicatedStorage:WaitForChild('Modules'):WaitForChild('Core'):WaitForChild('Net'))
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild('Humanoid')
local SpeedAmount = 35
local EnabledSpeed = false

local function c()
    return {
        SpeedModifies = EnabledSpeed,
        SpeedAmount = SpeedAmount,
    }
end
local function SpeedLoop()
    task.spawn(function()
        while task.wait(0.1) do
            if Humanoid and Humanoid.Parent then
                if c().SpeedModifies then
                    pcall(function()
                        Net.send('set_sprinting_1', true)
                        SprintModule.sprinting.set(true)
                        Humanoid:SetAttribute('TargetWalkSpeed', c().SpeedAmount)

                        Humanoid.WalkSpeed = c().SpeedAmount
                    end)
                else
                    pcall(function()
                        Humanoid:SetAttribute('TargetWalkSpeed', 8)

                        Humanoid.WalkSpeed = 8
                    end)
                end
            end
        end
    end)
end

SpeedLoop()
MainTab:Toggle({
    Title = 'Walk Speed',
    Flag = 'Walk Speed',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        EnabledSpeed = Value
    end,
})
MainTab:Slider({
    Title = 'Speed Value',
    Flag = 'speed_value',
    Step = 1,
    Value = {
        Min = 8,
        Max = 45,
        Default = SpeedAmount,
    },
    Callback = function(Value)
        SpeedAmount = Value

        if Humanoid and EnabledSpeed then
            Humanoid.WalkSpeed = Value
        end
    end,
})
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild('Humanoid')
end)

local EnabledFlyJump = false

MainTab:Toggle({
    Title = 'Fly Jump',
    Flag = 'Fly',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        EnabledFlyJump = Value
    end,
})
UserInputService.JumpRequest:Connect(function()
    if not EnabledFlyJump or not RootPart or not Humanoid then
        return
    end

    holdingJump = true

    task.spawn(function()
        while holdingJump and EnabledFlyJump do
            RunService.Heartbeat:Wait()

            if RootPart then
                RootPart.Velocity = Vector3.new(RootPart.Velocity.X, 30, RootPart.Velocity.Z)
            else
                break
            end
        end
    end)
end)

if Humanoid then
    Humanoid.StateChanged:Connect(function(oldState, newState)
        if newState ~= Enum.HumanoidStateType.Freefall and newState ~= Enum.HumanoidStateType.Jumping then
            holdingJump = false
        end
    end)
end

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        holdingJump = false
    end
end)

local EnabledInfiniteStamina = false

MainTab:Toggle({
    Title = 'Infinite Stamina',
    Flag = 'Inf',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        EnabledInfiniteStamina = Value
    end,
})

local OldUpdate = SprintBar.update

SprintBar.update = function(...)
    if EnabledInfiniteStamina then
        return 0.9
    else
        return OldUpdate(...)
    end
end

MainTab:Section({
    Title = 'Utility:',
})
local Players = game:GetService('Players')
local player = Players.LocalPlayer
local dropfolder = workspace:WaitForChild('DroppedItems')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Net = require(ReplicatedStorage.Modules.Core.Net)

local function GetDistanceFromRootPart(target)
    if not target then return math.huge end
    local char = player.Character
    local root = char and char:FindFirstChild('HumanoidRootPart')
    if not root then return math.huge end
    
    return (root.Position - target.Position).Magnitude
end

_G.AutoPickItems = false
_G.BlacklistRarity = {}

-- สร้างระบบจำค่า Rarity (Cache) เพื่อไม่ให้ลูปค้นหาใน ReplicatedStorage ทุกรอบ
local itemRarityCache = {}
local itemsFolder = ReplicatedStorage:FindFirstChild('Items')

if itemsFolder then
    for _, template in ipairs(itemsFolder:GetDescendants()) do
        if not template:IsA('ModuleScript') and not template:IsA('Folder') then
            local rarity = template:GetAttribute('RarityName')
            if rarity then
                itemRarityCache[template.Name] = rarity
            end
        end
    end
end

local function IsBlacklisted(item)
    if not item then return false end
    local dropName = item:GetAttribute('ItemName') or item.Name
    if not dropName then return false end

    -- ดึงค่าจาก Cache ออกมาเช็คได้ทันที (เร็วขึ้นกว่าเดิม 1000 เท่า)
    local rarity = itemRarityCache[dropName]
    if rarity then
        for _, r in ipairs(_G.BlacklistRarity) do
            if r == rarity then
                return true
            end
        end
    end

    return false
end

-- ลูปทำงานหลัก
task.spawn(function()
    while true do
        -- ปรับเป็นเช็คทุกๆ 0.1 วินาที (10 ครั้งต่อวินาที) แทนการเช็คทุกเฟรม ช่วยลดอาการแลคได้เกือบ 100%
        task.wait(0.1) 
        
        if _G.AutoPickItems then
            for _, v in ipairs(dropfolder:GetChildren()) do
                -- ตรวจสอบเงื่อนไขเปิดใช้งานอีกครั้งเผื่อปิดระหว่างวนลูป
                if not _G.AutoPickItems then break end 
                
                if v and not v:GetAttribute('Locked') then
                    if not IsBlacklisted(v) then
                        local zone = v:FindFirstChild('PickUpZone')
                        if zone then
                            -- ขยายโซนเก็บของให้กว้างขึ้น
                            if zone.Size ~= Vector3.new(22, 22, 22) then
                                zone.Size = Vector3.new(22, 22, 22)
                                zone.CanCollide = false
                            end

                            local dist = GetDistanceFromRootPart(zone)
                            if dist < math.huge then
                                Net.get('pickup_dropped_item', v)
                                -- ใส่ Cooldown เล็กๆ (0.02 วินาที) ป้องกันการส่ง Data ไป Server ถี่เกินไปจนโดนเตะหรือค้าง
                                task.wait(0.02) 
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ปุ่มเปิด/ปิดในเมนู UI
MainTab:Toggle({
    Title = 'Auto Pick Item',
    Flag = 'Pickitem',
    Desc = 'Pick up items that are far away',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(value)
        _G.AutoPickItems = value
    end,
})

local rarities = {
    'Common',
    'Uncommon',
    'Rare',
    'Epic',
    'Legendary',
}

MainTab:Dropdown({
    Title = 'Blacklist Rarity',
    Flag = 'BlacklistRarity',
    Values = rarities,
    Default = {},
    Multi = true,
    AllowNone = true,
    Callback = function(selected)
        _G.BlacklistRarity = selected
    end,
})

-- Auto Drop Feature
local AutoDropEnabled = false
local SelectedRarity = { 'Common' }

MainTab:Toggle({
    Title = 'Auto Drop',
    Desc = 'Automatically drop items by rarity',
    Flag = 'AutoDrop',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        AutoDropEnabled = Value
    end,
})

MainTab:Dropdown({
    Title = 'Select Rarity',
    Desc = 'Choose rarity to auto drop',
    Flag = 'DropRarity',
    Icon = 'list',
    Values = {
        'Common',
        'Uncommon',
        'Rare',
        'Epic',
        'Legendary',
        'Omega'
    },
    Value = { '' },
    Multi = true,
    Callback = function(Value)
        SelectedRarity = Value or { 'Common' }
    end,
})

-- Auto Drop Loop
local function findRarityByItemName(itemName)
    if not itemName or itemName == "" then return "Unknown" end
    
    local itemsDataFolder = ReplicatedStorage:WaitForChild("Items")
    
    for _, itemData in pairs(itemsDataFolder:GetDescendants()) do
        if itemData.Name == itemName then
            local rarity = itemData:GetAttribute("RarityName") or "Common"
            return rarity
        end
    end
    return "Unknown"
end

task.spawn(function()
    while task.wait(0.1) do
        if AutoDropEnabled then
            local pGui = Player:WaitForChild("PlayerGui")
            local scrollingFrame = pGui:WaitForChild("Items").ItemsHolder.ItemsScrollingFrame
            
            for _, obj in pairs(scrollingFrame:GetChildren()) do
                local guid = obj:GetAttribute("GUID")
                
                if guid then
                    local nameText = ""
                    local itemNameObj = obj:FindFirstChild("ItemName", true)
                    if itemNameObj and (itemNameObj:IsA("TextLabel") or itemNameObj:IsA("TextBox")) then
                        nameText = itemNameObj.Text
                    end
                    
                    local rarityName = findRarityByItemName(nameText)
                    
                    -- Check if rarity is in selected rarities (multi-selection support)
                    local shouldDrop = false
                    for _, selected in pairs(SelectedRarity) do
                        if rarityName == selected then
                            shouldDrop = true
                            break
                        end
                    end
                    
                    if shouldDrop then
                        local itemCount = 1
                        local itemCountObj = obj:FindFirstChild("ItemCount", true)
                        if itemCountObj and (itemCountObj:IsA("TextLabel") or itemCountObj:IsA("TextBox")) then
                            local countText = itemCountObj.Text:gsub("[^%d]", "") -- Extract only numbers
                            itemCount = tonumber(countText) or 1
                        end
                        
                        pcall(function()
                            Net.send("drop_item", guid, itemCount)
                        end)
                        task.wait() -- Small delay between drops
                    end
                end
            end
        end
    end
end)

_G.AntiLock = false

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LocalPlayer = Players.LocalPlayer
local MaxDistance = 1
local ANIM_ID = 'rbxassetid://10147821284'
local AntiAimAnimTrack = nil
local RealCFrame = CFrame.new()
local RealVelocity = Vector3.zero

local function playDanceAntiAim()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = char:WaitForChild('Humanoid')

    if AntiAimAnimTrack then
        AntiAimAnimTrack:Stop()
        AntiAimAnimTrack:Destroy()
    end

    local anim = Instance.new('Animation')

    anim.AnimationId = ANIM_ID
    AntiAimAnimTrack = humanoid:LoadAnimation(anim)
    AntiAimAnimTrack.Looped = true

    AntiAimAnimTrack:Play()
    AntiAimAnimTrack:AdjustSpeed(9999)
end
local function stopDanceAntiAim()
    if AntiAimAnimTrack then
        AntiAimAnimTrack:Stop()
        AntiAimAnimTrack:Destroy()

        AntiAimAnimTrack = nil
    end
end

function RandomNumberRange(a)
    return math.random(-a, a)
end

local oldIndex

oldIndex = hookmetamethod(game, '__index', newcclosure(function(self, key)
    if _G.AntiLock and not checkcaller() then
        if self:IsA('BasePart') and key == 'CFrame' then
            if LocalPlayer.Character and self == LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
                return RealCFrame
            end
        end
    end

    return oldIndex(self, key)
end))

RunService.Heartbeat:Connect(function()
    if _G.AntiLock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart') then
        local Root = LocalPlayer.Character.HumanoidRootPart

        RealCFrame = Root.CFrame
        RealVelocity = Root.AssemblyLinearVelocity

        local randomAngle = math.random(0, 360)
        local Offset = Vector3.new(RandomNumberRange(MaxDistance), RandomNumberRange(MaxDistance), RandomNumberRange(MaxDistance))

        Root.CFrame = RealCFrame * CFrame.Angles(0, math.rad(randomAngle), 0) * CFrame.new(Offset)
        Root.AssemblyLinearVelocity = Vector3.new(RandomNumberRange(500), RandomNumberRange(500), RandomNumberRange(500))

        RunService.RenderStepped:Wait()

        Root.CFrame = RealCFrame
        Root.AssemblyLinearVelocity = RealVelocity
    end
end)
MainTab:Toggle({
    Title = 'Anti Lock',
    Flag = 'antilock',
    Desc = 'No one can shoot u',
    Icon = 'shield',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.AntiLock = Value

        if Value then
            playDanceAntiAim()
            game:GetService('StarterGui'):SetCore('SendNotification', {
                Title = 'Anti-Lock',
                Text = 'Enabled',
                Duration = 2,
            })
        else
            stopDanceAntiAim()
        end
    end,
})
MainTab:Toggle({
    Title = 'Hide Name',
    Flag = 'HideName',
    Desc = 'Disable your name only client',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.HideName = Value

        local function toggleName()
            local char = LocalPlayer.Character

            if char then
                local hrp = char:FindFirstChild('HumanoidRootPart')

                if hrp then
                    local bbGui = hrp:FindFirstChild('CharacterBillboardGui')

                    if bbGui then
                        bbGui.Enabled = not _G.HideName
                    end
                end
            end
        end

        toggleName()

        if _G.HideName then
            if not _G.HideNameConn then
                _G.HideNameConn = LocalPlayer.CharacterAdded:Connect(function(char)
                    if _G.HideName then
                        task.wait(1)
                        toggleName()
                    end
                end)
            end
        end
    end,
})

local function AntiRagdollLoop()
    while _G.AntiRagdoll do
        task.wait(0.1)
        pcall(function()
            local isRagdolled = RagdollModule.is_ragdolling.get()

            if isRagdolled then
                RagdollModule.is_ragdolling.set(false)
                pcall(function()
                    Net.send('end_ragdoll_early')
                end)
                pcall(function()
                    Net.send('clear_ragdoll')
                end)
                pcall(function()
                    Net.get('end_ragdoll_early')
                end)
                pcall(function()
                    Net.get('clear_ragdoll')
                end)
            end
        end)
    end
end

MainTab:Toggle({
    Title = 'Anti Ragdoll',
    Desc = 'No ragdoll lol',
    Flag = 'AntiRagdoll',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.AntiRagdoll = Value

        if Value then
            task.spawn(AntiRagdollLoop)
        end
    end,
})

local func = {}
local EverDown = false
local WasAntiLockEnabled = false

func.AntiDied = function()
    while task.wait(0.24) do
        if Settings.AntiDied then
            if not Character or not Humanoid or not RootPart then
                Character = Client.Character or Client.CharacterAdded:Wait()
                Humanoid = Character:WaitForChild('Humanoid')
                RootPart = Character:WaitForChild('HumanoidRootPart')
            end

            local hum = CharModule.get_hum()

            if hum then
                if hum:GetAttribute('HasBeenDowned') then
                    if not hum:GetAttribute('IsDead') then
                        if Humanoid.Health > 0 then
                            if _G.AntiLock then
                                WasAntiLockEnabled = true
                                _G.AntiLock = false

                                stopDanceAntiAim()
                                WindUI:Notify({
                                    Title = 'Anti System',
                                    Content = 'Anti Lock disabled (Anti Kill active)',
                                    Duration = 2,
                                })
                            end

                            local deathScreenExists = PlayerGui:FindFirstChild('DeathScreen')

                            if deathScreenExists then
                                local deathscreen = PlayerGui.DeathScreen.DeathScreenHolder

                                if not deathscreen.Visible then
                                    local Radius = 15
                                    local targetY = RootPart.Position.Y - Radius
                                    local currentY = RootPart.Position.Y
                                    local deltaY = targetY - currentY
                                    local Gan = math.random(-5, 15)

                                    RootPart.Anchored = false
                                    RootPart.CanCollide = false
                                    RootPart.CFrame = RootPart.CFrame * CFrame.new(Gan, deltaY, Gan)
                                    RootPart.Velocity = Vector3.new(RootPart.Velocity.X, -11, RootPart.Velocity.Z)

                                    for i, v in pairs(Character:GetChildren())do
                                        if v:IsA('BasePart') then
                                            v.CanCollide = false
                                            v.Anchored = false
                                            v.CFrame = v.CFrame * CFrame.new(0, deltaY, 0)
                                            v.Velocity = Vector3.new(v.Velocity.X, -11, v.Velocity.Z)
                                        end
                                    end

                                    EverDown = true
                                end
                            end
                        else
                            EverDown = false
                        end
                    else
                        EverDown = false
                    end
                else
                    if EverDown then
                        local ganys = 15
                        local targetY = RootPart.Position.Y - ganys
                        local currentY = RootPart.Position.Y
                        local deltaY = targetY - currentY

                        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)

                        if not Client:GetAttribute('IsInCombat') then
                            EverDown = false

                            Net.send('request_respawn')

                            if WasAntiLockEnabled then
                                _G.AntiLock = true

                                playDanceAntiAim()

                                WasAntiLockEnabled = false

                                WindUI:Notify({
                                    Title = 'Anti System',
                                    Content = 'Anti Lock re-enabled',
                                    Duration = 2,
                                })
                            end
                        end
                    end
                end
            end
        else
            EverDown = false

            if WasAntiLockEnabled then
                WasAntiLockEnabled = false
            end
        end
    end
end

MainTab:Toggle({
    Title = 'Anti Kill',
    Desc = 'Normal Player cant Finish',
    Flag = 'antikill',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(state)
        Settings.AntiDied = state

        if state then
            task.spawn(func.AntiDied)
        end
    end,
})
MainTab:Toggle({
    Title = 'Auto Mask',
    Flag = 'automask',
    Desc = 'Equip Shiesty',
    Icon = 'check',
    Type = 'Checkbox',
    Callback = function(Value)
        if not Value then
            return
        end

        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Player = game.Players.LocalPlayer
        local PlayerGui = Player:WaitForChild('PlayerGui')
        local Net = require(ReplicatedStorage.Modules.Core.Net)

        function GetAllInfos(itemName)
            local infos = {}
            local Items = PlayerGui.Items
            local Holding = Items:FindFirstChild('ItemsHolder').ItemsScrollingFrame

            for _, v in ipairs(Holding:GetChildren())do
                if v.Name ~= 'Folder' and v.Name ~= 'UIGridLayout' and v.Name ~= 'ItemTemplate' then
                    if v.ItemName.Text == itemName then
                        table.insert(infos, {
                            Uid = v.Name,
                            Using = v:FindFirstChild('ItemEquipped').Visible,
                            Drowning = v:FindFirstChild('DestroyedItemIcon').Visible,
                        })
                    end
                end
            end

            return infos
        end
        function EquipAccessory(itemName)
            local infos = GetAllInfos(itemName)

            for _, info in ipairs(infos)do
                if not info.Using and not info.Drowning then
                    Net.get('toggle_equip_item', info.Uid)

                    repeat
                        task.wait()
                    until GetAllInfos(itemName)[1].Using
                end
            end
        end

        EquipAccessory('Shiesty')
    end,
})
MainTab:Toggle({
    Title = 'Auto Health',
    Flag = 'autohealth',
    Desc = 'Auto use Bloodbag',
    Icon = 'check',
    Type = 'Checkbox',
    Callback = function(state)
        c().AutoBlood = state

        if not state then
            return
        end

        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild('Humanoid')
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Net = require(ReplicatedStorage.Modules.Core.Net)
        local ItemsUI = Player.PlayerGui.Items.ItemsHolder.ItemsScrollingFrame
        local Busy = false

        local function GetBloodBagUID()
            for _, v in ipairs(ItemsUI:GetChildren())do
                if v:IsA('Frame') or v:IsA('ImageButton') then
                    local itemType = v:GetAttribute('ItemType')

                    if itemType and itemType:lower() == 'consumable' then
                        return v.Name
                    end
                end
            end

            return nil
        end
        local function UseBloodBag(uid)
            if Busy then
                return
            end

            Busy = true

            local tool = Character:FindFirstChild('Blood Bag')
            local didEquip = false

            if not tool then
                Net.get('toggle_equip_item', uid)

                didEquip = true

                task.wait(0.1)

                tool = Character:FindFirstChild('Blood Bag') or Player.Backpack:FindFirstChild('Blood Bag')
            end
            if tool then
                while Humanoid.Health < 90 do
                    Net.get('consume_power_up', tool)
                    task.wait(0.1)
                end

                if didEquip then
                    Net.get('toggle_equip_item', uid)
                end
            else
                warn(' Blood Bag tool not found.')
            end

            Busy = false
        end

        task.spawn(function()
            while c().AutoBlood do
                task.wait(0.2)

                if Humanoid.Health <= 50 then
                    local uid = GetBloodBagUID()

                    if uid then
                        UseBloodBag(uid)
                    else
                        warn('\u{26a0} No bloodbag found.')
                    end
                end
            end
        end)
    end,
})
MainTab:Divider()

local EnabledSnapRunning = false
local SnapThread = nil
local YoffsetValue = 70

func.EnabledSnap = function()
    local basePosition = RootPart.Position

    while EnabledSnapRunning do
        task.wait()

        if not EnabledSnapRunning then
            break
        end

        local currentY = RootPart.Position.Y
        local targetY = basePosition.Y - YoffsetValue
        local deltaY = targetY - currentY

        RootPart.CFrame = RootPart.CFrame * CFrame.new(0, deltaY, 0)
    end
end

local function SetSnapState(value)
    if EnabledSnapRunning == value then
        return
    end

    EnabledSnapRunning = value

    if value then
        if not SnapThread then
            SnapThread = task.spawn(func.EnabledSnap)
        end
    else
        SnapThread = nil
    end

    MainTab:Get('UndergroundToggle'):SetValue(value)
end

MainTab:Toggle({
    Title = 'Underground',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Flag = 'UndergroundToggle',
    Callback = function(value)
        SetSnapState(value)
    end,
})
MainTab:Keybind({
    Title = 'Keybind',
    Flag = 'keybind',
    Value = 'G',
    Callback = function()
        SetSnapState(not EnabledSnapRunning)
    end,
})
MainTab:Slider({
    Title = 'Snap Height',
    Flag = 'snap_height',
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 10,
    },
    Callback = function(value)
        YoffsetValue = value
    end,
})

local CombatTab = Window:Tab({
    Title = 'Combat',
    Icon = 'swords',
})
local FOVRadius = 120
local SilentAimEnabled = false
local ShowFOVEnabled = false
local WallbangEnabled = false
local CurrentTarget = nil
local UseSmartPredict = true
local TargetMode = 'Head'
local VelocityThreshold = 250
local UserInputService = game:GetService('UserInputService')
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local FOVCircleSegments = {}
local FOVCircleGui = nil
local FOVCircleFrame = nil
local Tracer = nil
local TracerGui = nil
local TracerFrame = nil
local TargetHeadCircle = nil
local TargetCircleGui = nil
local TargetCircleFrame = nil

if not IsMobile then
    for i = 1, 64 do
        local line = Drawing.new('Line')

        line.Thickness = 2
        line.Visible = false

        table.insert(FOVCircleSegments, line)
    end

    Tracer = Drawing.new('Line')
    Tracer.Thickness = 1.5
    Tracer.Color = Color3.fromRGB(124, 252, 0)
    Tracer.Transparency = 1
    Tracer.Visible = false
    TargetHeadCircle = Drawing.new('Circle')
    TargetHeadCircle.Color = Color3.fromRGB(255, 250, 250)
    TargetHeadCircle.Thickness = 2
    TargetHeadCircle.NumSides = 32
    TargetHeadCircle.Filled = false
    TargetHeadCircle.Transparency = 1
    TargetHeadCircle.Radius = 15
    TargetHeadCircle.Visible = false
else
    FOVCircleGui = Instance.new('ScreenGui')
    FOVCircleGui.Name = 'SilentAimFOV'
    FOVCircleGui.IgnoreGuiInset = true
    FOVCircleGui.ResetOnSpawn = false
    FOVCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FOVCircleGui.Parent = game:GetService('CoreGui')
    FOVCircleFrame = Instance.new('Frame')
    FOVCircleFrame.Name = 'Circle'
    FOVCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircleFrame.BackgroundTransparency = 1
    FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
    FOVCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    FOVCircleFrame.Visible = false
    FOVCircleFrame.Parent = FOVCircleGui

    local FOVStroke = Instance.new('UIStroke')

    FOVStroke.Thickness = 3
    FOVStroke.Transparency = 0
    FOVStroke.Color = Color3.fromRGB(124, 252, 0)
    FOVStroke.Parent = FOVCircleFrame

    local FOVGradient = Instance.new('UIGradient')

    FOVGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 255)),
    })
    FOVGradient.Parent = FOVStroke

    local FOVCorner = Instance.new('UICorner')

    FOVCorner.CornerRadius = UDim.new(1, 0)
    FOVCorner.Parent = FOVCircleFrame
    TracerGui = Instance.new('ScreenGui')
    TracerGui.Name = 'SilentAimTracer'
    TracerGui.IgnoreGuiInset = true
    TracerGui.ResetOnSpawn = false
    TracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TracerGui.Parent = game:GetService('CoreGui')
    TracerFrame = Instance.new('Frame')
    TracerFrame.Name = 'Line'
    TracerFrame.BackgroundColor3 = Color3.fromRGB(124, 252, 0)
    TracerFrame.BorderSizePixel = 0
    TracerFrame.AnchorPoint = Vector2.new(0, 0.5)
    TracerFrame.Size = UDim2.new(0, 0, 0, 2)
    TracerFrame.Visible = false
    TracerFrame.Parent = TracerGui
    TargetCircleGui = Instance.new('ScreenGui')
    TargetCircleGui.Name = 'SilentAimTarget'
    TargetCircleGui.IgnoreGuiInset = true
    TargetCircleGui.ResetOnSpawn = false
    TargetCircleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    TargetCircleGui.Parent = game:GetService('CoreGui')
    TargetCircleFrame = Instance.new('Frame')
    TargetCircleFrame.Name = 'Circle'
    TargetCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    TargetCircleFrame.BackgroundTransparency = 1
    TargetCircleFrame.Size = UDim2.new(0, 30, 0, 30)
    TargetCircleFrame.Visible = false
    TargetCircleFrame.Parent = TargetCircleGui

    local TargetStroke = Instance.new('UIStroke')

    TargetStroke.Color = Color3.fromRGB(255, 250, 250)
    TargetStroke.Thickness = 2
    TargetStroke.Transparency = 0
    TargetStroke.Parent = TargetCircleFrame

    local TargetCorner = Instance.new('UICorner')

    TargetCorner.CornerRadius = UDim.new(1, 0)
    TargetCorner.Parent = TargetCircleFrame
end

local function GetCirclePoint(center, radius, angle)
    local x = center.X + radius * math.cos(angle)
    local y = center.Y + radius * math.sin(angle)

    return Vector2.new(x, y)
end

local TargetHistory = {}
local VelocitySpikes = {}

local function updateTargetHistory(player, position, velocity)
    if not TargetHistory[player] then
        TargetHistory[player] = {}
        VelocitySpikes[player] = {
            count = 0,
            lastSpike = 0,
            isAntiLock = false,
        }
    end

    table.insert(TargetHistory[player], {
        pos = position,
        vel = velocity,
        time = tick(),
    })

    if #TargetHistory[player] > 8 then
        table.remove(TargetHistory[player], 1)
    end
    if UseSmartPredict and #TargetHistory[player] >= 2 then
        local current = TargetHistory[player][#TargetHistory[player] ]
        local previous = TargetHistory[player][#TargetHistory[player] - 1]
        local velChange = (current.vel - previous.vel).Magnitude

        if velChange > VelocityThreshold then
            VelocitySpikes[player].count = VelocitySpikes[player].count + 1
            VelocitySpikes[player].lastSpike = tick()

            if VelocitySpikes[player].count >= 3 then
                VelocitySpikes[player].isAntiLock = true
            end
        end
        if tick() - VelocitySpikes[player].lastSpike > 3 then
            VelocitySpikes[player].count = 0
            VelocitySpikes[player].isAntiLock = false
        end
    end
end
local function getAverageVelocity(player)
    local history = TargetHistory[player]

    if not history or #history < 2 then
        return Vector3.zero
    end
    if UseSmartPredict and VelocitySpikes[player] and VelocitySpikes[player].isAntiLock then
        local velocities = {}

        for i = 2, #history do
            local dt = history[i].time - history[i - 1].time

            if dt > 0 then
                local vel = (history[i].pos - history[i - 1].pos) / dt

                table.insert(velocities, vel)
            end
        end

        if #velocities > 0 then
            table.sort(velocities, function(a, b)
                return a.Magnitude < b.Magnitude
            end)

            local midIndex = math.ceil(#velocities / 2)

            return velocities[midIndex]
        end
    end

    local totalVel = Vector3.zero

    for i = 2, #history do
        local dt = history[i].time - history[i - 1].time

        if dt > 0 then
            local vel = (history[i].pos - history[i - 1].pos) / dt

            totalVel = totalVel + vel
        end
    end

    return totalVel / (#history - 1)
end
local function getPing()
    local stats = LocalPlayer:FindFirstChild('PlayerGui'):FindFirstChild('NetworkStats')

    if stats then
        local pingText = stats:FindFirstChild('PingLabel')

        if pingText then
            local ping = tonumber(pingText.Text:match('%d+'))

            return ping and ping / 1000 or 0.2
        end
    end

    return 0.2
end
local function getClosestTarget()
    local closest = nil
    local shortestDistance = math.huge
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in ipairs(Players:GetPlayers())do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild('Head') then
            local head = player.Character.Head
            local hrp = player.Character:FindFirstChild('HumanoidRootPart')
            local humanoid = player.Character:FindFirstChild('Humanoid')
            local isInSafeZone = false

            if hrp then
                local billboardGui = hrp:FindFirstChild('CharacterBillboardGui')

                if billboardGui then
                    local playerName = billboardGui:FindFirstChild('PlayerName')

                    if playerName then
                        local levelImage = playerName:FindFirstChild('LevelImage')

                        if levelImage then
                            local frame = levelImage:FindFirstChild('Frame')

                            if frame then
                                local safeZone = frame:FindFirstChild('InSafeZone')

                                if safeZone and safeZone.Visible then
                                    isInSafeZone = true
                                end
                            end
                        end
                    end
                end
            end

            local isDead = humanoid and humanoid.Health <= 0

            if not isInSafeZone and not isDead then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local screenPos = Vector2.new(pos.X, pos.Y)
                    local distFromCenter = (screenPos - center).Magnitude

                    if distFromCenter <= FOVRadius then
                        local toTarget = (head.Position - Camera.CFrame.Position).Unit
                        local forward = Camera.CFrame.LookVector
                        local dot = forward:Dot(toTarget)

                        if dot > 0.5 then
                            local distance3D = (head.Position - LocalPlayer.Character.Head.Position).Magnitude

                            if distance3D < shortestDistance then
                                shortestDistance = distance3D
                                closest = player
                            end
                        end
                    end
                end
            end
        end
    end

    return closest
end
local function getSmartAimPart(character)
    if TargetMode == 'Torso' then
        return character:FindFirstChild('HumanoidRootPart')
    elseif TargetMode == 'Smart' then
        local head = character:FindFirstChild('Head')
        local hrp = character:FindFirstChild('HumanoidRootPart')

        if head and hrp then
            local headVel = head.AssemblyLinearVelocity or head.Velocity or Vector3.zero
            local hrpVel = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero

            if headVel.Magnitude > hrpVel.Magnitude + 50 then
                return hrp
            end
        end

        return head
    else
        return character:FindFirstChild('Head')
    end
end
local function predictPosition(targetPart, character)
    local ping = getPing()
    local hrp = character:FindFirstChild('HumanoidRootPart')
    local player = Players:GetPlayerFromCharacter(character)

    if UseSmartPredict and player and TargetHistory[player] then
        local avgVel = getAverageVelocity(player)

        if VelocitySpikes[player] and VelocitySpikes[player].isAntiLock then
            return targetPart.Position + (avgVel * ping * 0.6)
        else
            return targetPart.Position + (avgVel * ping * 1.3)
        end
    else
        local velocity = hrp and (hrp.AssemblyLinearVelocity or hrp.Velocity) or Vector3.zero

        return targetPart.Position + (velocity * ping * 1.15)
    end
end

RunService.Heartbeat:Connect(function()
    if CurrentTarget and CurrentTarget.Character then
        local head = CurrentTarget.Character:FindFirstChild('Head')
        local hrp = CurrentTarget.Character:FindFirstChild('HumanoidRootPart')

        if head and hrp then
            local velocity = hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.zero

            updateTargetHistory(CurrentTarget, head.Position, velocity)
        end
    end
end)

local FakeHead = nil

local function UpdateFakeHead()
    if not _G.AntiLock then
        if FakeHead then
            FakeHead:Destroy()

            FakeHead = nil
        end

        return
    end

    local char = LocalPlayer.Character

    if not char then
        return
    end

    local realHead = char:FindFirstChild('Head')

    if not realHead then
        return
    end
    if not FakeHead or not FakeHead.Parent then
        FakeHead = Instance.new('Part')
        FakeHead.Name = 'FakeHead'
        FakeHead.Size = Vector3.new(2, 1, 1)
        FakeHead.Transparency = 1
        FakeHead.CanCollide = false
        FakeHead.Anchored = true
        FakeHead.Parent = workspace
    end

    local camera = workspace.CurrentCamera

    if camera then
        FakeHead.CFrame = camera.CFrame * CFrame.new(0, 0, -5)
    end
end

LocalPlayer.CharacterRemoving:Connect(function()
    if FakeHead then
        FakeHead:Destroy()

        FakeHead = nil
    end
end)
RunService.Heartbeat:Connect(function()
    UpdateFakeHead()
end)
RunService.RenderStepped:Connect(function()
    local centerX = Camera.ViewportSize.X / 2
    local centerY = Camera.ViewportSize.Y / 2
    local center = Vector2.new(centerX, centerY)
    local time = tick() * 2

    if not IsMobile then
        local numSegments = #FOVCircleSegments
        local angleStep = (math.pi * 2) / numSegments

        for i = 1, numSegments do
            local line = FOVCircleSegments[i]

            if SilentAimEnabled and ShowFOVEnabled then
                local angle1 = angleStep * (i - 1)
                local angle2 = angleStep * i
                local point1 = GetCirclePoint(center, FOVRadius, angle1)
                local point2 = GetCirclePoint(center, FOVRadius, angle2)
                local hue = ((i / numSegments) + (time * 0.1)) % 1
                local color = Color3.fromHSV(hue, 0.8, 1)

                line.From = point1
                line.To = point2
                line.Color = color
                line.Visible = true
            else
                line.Visible = false
            end
        end
    else
        if FOVCircleFrame then
            FOVCircleFrame.Visible = SilentAimEnabled and ShowFOVEnabled
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)

            local stroke = FOVCircleFrame:FindFirstChildOfClass('UIStroke')

            if stroke then
                local gradient = stroke:FindFirstChildOfClass('UIGradient')

                if gradient then
                    local hue1 = (time * 0.1) % 1
                    local hue2 = (time * 0.1 + 0.33) % 1
                    local hue3 = (time * 0.1 + 0.66) % 1

                    gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(hue1, 0.8, 1)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(hue2, 0.8, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(hue3, 0.8, 1)),
                    })
                    gradient.Rotation = (time * 50) % 360
                end
            end
        end
    end
    if SilentAimEnabled then
        CurrentTarget = getClosestTarget()
    else
        CurrentTarget = nil
    end
    if CurrentTarget and CurrentTarget.Character then
        local targetPart = getSmartAimPart(CurrentTarget.Character)
        local myHead

        if _G.AntiLock and FakeHead and FakeHead.Parent then
            myHead = FakeHead
        else
            myHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head')
        end
        if targetPart and myHead then
            local myScreenPos, myOnScreen = Camera:WorldToViewportPoint(myHead.Position)
            local targetScreenPos, targetOnScreen = Camera:WorldToViewportPoint(targetPart.Position)

            if targetOnScreen then
                if not IsMobile then
                    Tracer.Visible = true
                    Tracer.From = Vector2.new(myScreenPos.X, myScreenPos.Y)
                    Tracer.To = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                    TargetHeadCircle.Visible = true
                    TargetHeadCircle.Position = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
                else
                    if TracerFrame then
                        local dx = targetScreenPos.X - myScreenPos.X
                        local dy = targetScreenPos.Y - myScreenPos.Y
                        local length = math.sqrt(dx * dx + dy * dy)
                        local angle = math.deg(math.atan2(dx, dy))

                        TracerFrame.Size = UDim2.new(0, length, 0, 2)
                        TracerFrame.Position = UDim2.new(0, myScreenPos.X, 0, myScreenPos.Y)
                        TracerFrame.Rotation = angle
                        TracerFrame.Visible = true
                    end
                    if TargetCircleFrame then
                        TargetCircleFrame.Position = UDim2.new(0, targetScreenPos.X, 0, targetScreenPos.Y)
                        TargetCircleFrame.Visible = true
                    end
                end
            else
                if not IsMobile then
                    Tracer.Visible = false
                    TargetHeadCircle.Visible = false
                else
                    if TracerFrame then
                        TracerFrame.Visible = false
                    end
                    if TargetCircleFrame then
                        TargetCircleFrame.Visible = false
                    end
                end
            end
        end
    else
        if not IsMobile then
            Tracer.Visible = false
            TargetHeadCircle.Visible = false
        else
            if TracerFrame then
                TracerFrame.Visible = false
            end
            if TargetCircleFrame then
                TargetCircleFrame.Visible = false
            end
        end
    end
end)

local oldFire

oldFire = hookfunction(game:GetService('ReplicatedStorage').Remotes.Send.FireServer, function(self, ...)
    local args = {...}

    if SilentAimEnabled and args[2] == 'shoot_gun' and CurrentTarget and CurrentTarget.Character then
        local targetPart = getSmartAimPart(CurrentTarget.Character)

        if targetPart then
            local aimPos = predictPosition(targetPart, CurrentTarget.Character)
            local realHead = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Head')
            local myHeadPos = realHead and realHead.Position or Camera.CFrame.Position

            args[4] = CFrame.new(myHeadPos, aimPos)
            args[4] = CFrame.new(math.huge, math.huge, math.huge)
            args[5] = {
                [1] = {
                    [1] = {
                        Instance = targetPart,
                        Normal = Vector3.new(0, 1, 0),
                        Position = aimPos,
                    },
                },
            }

            local beam = Instance.new('Part', workspace)

            beam.Anchored = true
            beam.CanCollide = false
            beam.Size = Vector3.new(0.05, 0.05, (aimPos - myHeadPos).Magnitude)
            beam.CFrame = CFrame.new(myHeadPos, aimPos) * CFrame.new(0, 0, -beam.Size.Z / 2)
            beam.Color = Color3.fromRGB(255, 50, 50)
            beam.Material = Enum.Material.Neon
            beam.Transparency = 0.25

            game:GetService('Debris'):AddItem(beam, 1.5)
        end
    end

    return oldFire(self, unpack(args))
end)

CombatTab:Toggle({
    Title = 'Silent Aim',
    Flag = 'silent aim',
    Desc = 'Auto aim to target',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        SilentAimEnabled = state
    end,
})
CombatTab:Toggle({
    Title = 'Show FOV',
    Flag = 'show',
    Desc = 'Display FOV circle',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        ShowFOVEnabled = state
    end,
})
CombatTab:Toggle({
    Title = 'Smart Predict',
    Flag = 'smartpredict',
    Desc = 'Advanced velocity prediction + Anti-Lock Resolver',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(state)
        UseSmartPredict = state
    end,
})
CombatTab:Toggle({
    Title = 'Wallbang',
    Flag = 'wallbang',
    Desc = 'Shoot through walls',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        WallbangEnabled = state
    end,
})
CombatTab:Dropdown({
    Title = 'Target Mode',
    Flag = 'target_mode',
    Desc = 'Select aim target part',
    Icon = 'target',
    Values = {
        'Head',
        'Torso',
        'Smart',
    },
    Default = 'Head',
    Callback = function(value)
        TargetMode = value
    end,
})
CombatTab:Slider({
    Title = 'FOV Size',
    Flag = 'fov_size',
    Step = 1,
    Value = {
        Min = 20,
        Max = 1000,
        Default = FOVRadius,
    },
    Callback = function(value)
        FOVRadius = tonumber(value) or 120

        if IsMobile and FOVCircleFrame then
            FOVCircleFrame.Size = UDim2.new(0, FOVRadius * 2, 0, FOVRadius * 2)
        end
    end,
})
CombatTab:Slider({
    Title = 'Velocity Threshold',
    Flag = 'velocity_threshold',
    Step = 10,
    Value = {
        Min = 100,
        Max = 500,
        Default = VelocityThreshold,
    },
    Callback = function(value)
        VelocityThreshold = tonumber(value) or 250
    end,
})

local function GetDistanceFromRootPart(targetRoot)
    if not targetRoot or not RootPart then
        return math.huge
    end

    return (RootPart.Position - targetRoot.Position).Magnitude
end

func.HitAura = function()
    while task.wait() do
        if not c().HitAura then
            break
        end

        for _, vx in pairs(Players:GetPlayers())do
            if vx ~= Client and vx.Character and vx.Character:FindFirstChild('HumanoidRootPart') then
                local targetRoot = vx.Character:FindFirstChild('HumanoidRootPart')
                local dist = GetDistanceFromRootPart(targetRoot)

                if dist < 0 then
                    for i, v in pairs(Character:GetChildren())do
                        if v:IsA('Tool') and v.Name == 'Fists' then
                            local keys = {}

                            for x in pairs(v:GetAttributes())do
                                table.insert(keys, x)
                            end

                            table.sort(keys)
                            v:SetAttribute(keys[7], 20)
                            v:SetAttribute(keys[8], 10000)
                            Net.send('melee_attack', v, {vx}, targetRoot.CFrame, 0)
                            task.wait(0)
                        end
                    end
                end
            end
        end
    end
end

CombatTab:Toggle({
    Title = 'Hit Aura',
    Flag = 'hitaura',
    Desc = 'Auto attack near player',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(state)
        c().HitAura = state

        if state then
            task.spawn(func.HitAura)
        end
    end,
})

local WeaponTab = Window:Tab({
    Title = 'Weapon',
    Icon = 'wrench',
})

WeaponTab:Section({
    Title = 'Gun Modification:',
})

local GunModSettings = {
    Enabled = false,
    accuracy = math.huge,
    range = math.huge,
    Recoil = 0,
    fire_rate = math.huge,
    reload_time = 0,
    automatic = true,
}
local FireRateAttributeName = 'fire_rate'
local AutomaticAttributeName = 'automatic'
local CurrentGunLabel = WeaponTab:Button({
    Title = 'Current Gun',
    Desc = 'None',
})

local function FindFireRateAttribute(gun)
    if not gun then
        return nil
    end
    if gun:GetAttribute('fire_rate') ~= nil then
        return 'fire_rate'
    end

    for attrName, attrValue in pairs(gun:GetAttributes())do
        if type(attrName) == 'string' and attrName:sub(-3) == '486' then
            return attrName
        end
    end

    return nil
end
local function FindAutomaticAttribute(gun)
    if not gun then
        return nil
    end
    if gun:GetAttribute('automatic') ~= nil then
        return 'automatic'
    end

    for attrName, attrValue in pairs(gun:GetAttributes())do
        if type(attrName) == 'string' and attrName:sub(-3) == '492' then
            return attrName
        end
    end

    return nil
end
local function IsGun(tool)
    if not tool or not tool:IsA('Tool') then
        return false
    end

    return tool:GetAttribute('reload_time') or tool:GetAttribute('AmmoType') or FindFireRateAttribute(tool)
end
local function ModifyGunAttributes(gun)
    if not gun or not gun:IsA('Tool') then
        return false
    end

    pcall(function()
        gun:SetAttribute('accuracy', GunModSettings.accuracy)
        gun:SetAttribute('range', GunModSettings.range)
        gun:SetAttribute('Recoil', GunModSettings.Recoil)
        gun:SetAttribute('reload_time', GunModSettings.reload_time)

        local fireRateAttr = FindFireRateAttribute(gun)

        if fireRateAttr then
            gun:SetAttribute(fireRateAttr, GunModSettings.fire_rate)

            FireRateAttributeName = fireRateAttr
        else
            gun:SetAttribute('fire_rate', GunModSettings.fire_rate)
        end

        local automaticAttr = FindAutomaticAttribute(gun)

        if automaticAttr then
            gun:SetAttribute(automaticAttr, GunModSettings.automatic)

            AutomaticAttributeName = automaticAttr
        else
            gun:SetAttribute('automatic', GunModSettings.automatic)
        end
    end)

    return true
end
local function ModAllGunsInBackpack()
    local count = 0

    for _, tool in pairs(Backpack:GetChildren())do
        if IsGun(tool) then
            ModifyGunAttributes(tool)

            count = count + 1
        end
    end

    return count
end
local function ModEquippedGun()
    local char = Client.Character

    if not char then
        return false
    end

    local tool = char:FindFirstChildOfClass('Tool')

    if tool and IsGun(tool) then
        ModifyGunAttributes(tool)
        CurrentGunLabel:SetDesc(tool.Name)

        return true
    end

    return false
end

local RealtimeConnections = {}

local function StartRealtimeMonitor(gun)
    if not gun or RealtimeConnections[gun] then
        return
    end

    local fireRateAttr = FindFireRateAttribute(gun)

    if not fireRateAttr then
        return
    end

    local connection = gun:GetAttributeChangedSignal(fireRateAttr):Connect(function()
        if GunModSettings.Enabled then
            local currentValue = gun:GetAttribute(fireRateAttr)

            if currentValue ~= math.huge and currentValue ~= GunModSettings.fire_rate then
                gun:SetAttribute(fireRateAttr, GunModSettings.fire_rate)
            end
        end
    end)

    RealtimeConnections[gun] = connection
end
local function StopRealtimeMonitor(gun)
    if RealtimeConnections[gun] then
        RealtimeConnections[gun]:Disconnect()

        RealtimeConnections[gun] = nil
    end
end
local function StopAllRealtimeMonitors()
    for gun, connection in pairs(RealtimeConnections)do
        connection:Disconnect()
    end

    RealtimeConnections = {}
end

local BackpackConnection = nil
local CharacterConnection = nil
local RealtimeUpdateLoop = nil

local function StartAutoMod()
    if BackpackConnection then
        BackpackConnection:Disconnect()
    end
    if CharacterConnection then
        CharacterConnection:Disconnect()
    end
    if RealtimeUpdateLoop then
        RealtimeUpdateLoop:Disconnect()
    end

    StopAllRealtimeMonitors()

    local count = ModAllGunsInBackpack()
    local equipped = ModEquippedGun()

    for _, tool in pairs(Backpack:GetChildren())do
        if IsGun(tool) then
            StartRealtimeMonitor(tool)
        end
    end

    local char = Client.Character

    if char then
        local equippedTool = char:FindFirstChildOfClass('Tool')

        if equippedTool and IsGun(equippedTool) then
            StartRealtimeMonitor(equippedTool)
        end
    end
    if count > 0 or equipped then
        WindUI:Notify({
            Title = 'Gun Mod',
            Content = 'Modified ' .. count .. ' gun(s) + Realtime active',
            Duration = 2,
        })
    else
        CurrentGunLabel:SetDesc('No Gun Found')
    end

    BackpackConnection = Backpack.ChildAdded:Connect(function(tool)
        if GunModSettings.Enabled and IsGun(tool) then
            task.wait(0.05)
            ModifyGunAttributes(tool)
            StartRealtimeMonitor(tool)
        end
    end)

    local char = Client.Character

    if char then
        CharacterConnection = char.ChildAdded:Connect(function(tool)
            if GunModSettings.Enabled and IsGun(tool) then
                task.wait(0.05)
                ModifyGunAttributes(tool)
                CurrentGunLabel:SetDesc(tool.Name)
                StartRealtimeMonitor(tool)
            end
        end)
    end

    RealtimeUpdateLoop = game:GetService('RunService').Heartbeat:Connect(function()
        if not GunModSettings.Enabled then
            return
        end

        local char = Client.Character

        if char then
            local tool = char:FindFirstChildOfClass('Tool')

            if tool and IsGun(tool) then
                ModifyGunAttributes(tool)
            end
        end

        for _, tool in pairs(Backpack:GetChildren())do
            if IsGun(tool) then
                ModifyGunAttributes(tool)
            end
        end
    end)
end
local function StopAutoMod()
    if BackpackConnection then
        BackpackConnection:Disconnect()

        BackpackConnection = nil
    end
    if CharacterConnection then
        CharacterConnection:Disconnect()

        CharacterConnection = nil
    end
    if RealtimeUpdateLoop then
        RealtimeUpdateLoop:Disconnect()

        RealtimeUpdateLoop = nil
    end

    StopAllRealtimeMonitors()
    CurrentGunLabel:SetDesc('None')
end

WeaponTab:Toggle({
    Title = 'Enable Gun Mod',
    Flag = 'gun_mod_enabled',
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value)
        GunModSettings.Enabled = Value

        if Value then
            StartAutoMod()
            WindUI:Notify({
                Title = 'Gun Mod',
                Content = 'Enabled + Realtime Monitor',
                Duration = 2,
            })
        else
            StopAutoMod()
            WindUI:Notify({
                Title = 'Gun Mod',
                Content = 'Disabled',
                Duration = 2,
            })
        end
    end,
})
WeaponTab:Divider()
WeaponTab:Toggle({
    Title = 'INFINITE Accuracy',
    Flag = 'gun_max_accuracy',
    Icon = 'crosshair',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        GunModSettings.accuracy = Value and math.huge or 1

        if GunModSettings.Enabled then
            ModAllGunsInBackpack()
            ModEquippedGun()
        end
    end,
})
WeaponTab:Toggle({
    Title = 'INFINITE Range',
    Flag = 'gun_max_range',
    Icon = 'crosshair',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        GunModSettings.range = Value and math.huge or 100

        if GunModSettings.Enabled then
            ModAllGunsInBackpack()
            ModEquippedGun()
        end
    end,
})
WeaponTab:Toggle({
    Title = 'NO Recoil',
    Flag = 'gun_no_recoil',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        GunModSettings.Recoil = Value and 0 or 1

        if GunModSettings.Enabled then
            ModAllGunsInBackpack()
            ModEquippedGun()
        end
    end,
})
WeaponTab:Toggle({
    Title = 'INFINITE Fire Rate',
    Flag = 'gun_infinite_firerate',
    Icon = 'zap',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        GunModSettings.fire_rate = Value and math.huge or 0.1

        if GunModSettings.Enabled then
            ModAllGunsInBackpack()
            ModEquippedGun()
        end
    end,
})
WeaponTab:Toggle({
    Title = 'MIN Reload Time',
    Flag = 'gun_min_reload',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        GunModSettings.reload_time = Value and 0 or 2

        if GunModSettings.Enabled then
            ModAllGunsInBackpack()
            ModEquippedGun()
        end
    end,
})
WeaponTab:Toggle({
    Title = 'Automatic Mode',
    Flag = 'gun_automatic',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        GunModSettings.automatic = Value

        if GunModSettings.Enabled then
            ModAllGunsInBackpack()
            ModEquippedGun()
        end
    end,
})
WeaponTab:Divider()
WeaponTab:Button({
    Title = 'Refresh All Guns',
    Desc = 'Reapply modifications to all guns',
    Callback = function()
        if GunModSettings.Enabled then
            local count = ModAllGunsInBackpack()

            ModEquippedGun()
            WindUI:Notify({
                Title = 'Gun Mod',
                Content = 'Refreshed ' .. count .. ' gun(s)',
                Duration = 2,
            })
        end
    end,
})
Client.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild('Humanoid')
    RootPart = Character:WaitForChild('HumanoidRootPart')
    Backpack = Client:WaitForChild('Backpack')

    StopAllRealtimeMonitors()

    if GunModSettings.Enabled then
        task.wait(0.5)
        StartAutoMod()
    end
end)

local VehicleTab = Window:Tab({
    Title = 'Vehicle',
    Icon = 'car',
})

VehicleTab:Section({
    Title = 'Vehicle:',
})

local function BumpAuraLoop()
    while _G.BumpAura do
        task.wait(0.1)

        local car = Vechine.get_car_player_is_in()

        if not car then
            task.wait()
        else
            for _, target in CharModule.get_all()do
                if target ~= Character then
                    local hrp = target:FindFirstChild('HumanoidRootPart')

                    if hrp and GetDistanceFromRootPart(hrp) < 100 then
                        local Assembly = car.DriverSeat.AssemblyLinearVelocity + Vector3.new(65, 65, 65)

                        Net.send('run_over', car, target, Assembly)
                    end
                end
            end
        end
    end
end

VehicleTab:Toggle({
    Title = 'Car Guard',
    Flag = 'CarGuard',
    Icon = 'shield',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        CarGuardEnabled = Value
    end,
})
VehicleTab:Toggle({
    Title = 'Bump Aura',
    Flag = 'BumpAura',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        _G.BumpAura = Value

        if Value then
            task.spawn(BumpAuraLoop)
        end
    end,
})
VehicleTab:Divider()

-- Exact Vehicle System from sasware.lua
local Storage = {
	Vehicle_Attributes = {
		{ Name = "acceleration", Type = "number", Min = 5, Max = 100, DisplayName = "Acceleration" },
		{ Name = "slipThreshold", Type = "number", Min = 10, Max = 100, DisplayName = "Slip Threshold" },
		{ Name = "staticFriction", Type = "number", Min = 1, Max = 10, DisplayName = "Static Friction" },
	},
}

local function G_Toggle(ToggleName: string): boolean
    local window = getgenv().Window
    if not window then
        print("G_Toggle: Window not found")
        return false
    end
    if not window.Toggles then
        print("G_Toggle: Window.Toggles not found")
        return false
    end
    if not window.Toggles[ToggleName] then
        print("G_Toggle: Toggle", ToggleName, "not found")
        return false
    end
    local value = window.Toggles[ToggleName].Value == true
    print("G_Toggle:", ToggleName, "=", value)
    return value
end

local function G_Option(OptionName: string): any
    local window = getgenv().Window
    if not window then
        print("G_Option: Window not found")
        return nil
    end
    if not window.Options then
        print("G_Option: Window.Options not found")
        return nil
    end
    if not window.Options[OptionName] then
        print("G_Option: Option", OptionName, "not found")
        return nil
    end
    local value = window.Options[OptionName].Value
    print("G_Option:", OptionName, "=", value)
    return value
end

-- Exact vehicle functions from sasware.lua
local function Sit(VehicleSeat: VehicleSeat, NYield: boolean?)
    local Vehicle = VehicleSeat.Parent :: BasePart
    local Prompt = Vehicle.Chassis.DrivePromptAttachment.DrivePrompt
    local Character = LocalPlayer.Character

    local Origin = Character:GetPivot()

    -- Try sitting in the car first
    fireproximityprompt(Prompt, 0.5)
    if not NYield then
        task.wait(0.5)
        if not Character.Humanoid.SeatPart then
            -- Attempting to gain network ownership of vehicle seat...
            
            local AttemptNetworkOwnershipStart = os.clock()
            while os.clock() - AttemptNetworkOwnershipStart < 0.3 and Character.Humanoid.SeatPart == nil do
                RunService.Heartbeat:Wait()
                Character:PivotTo(VehicleSeat:GetPivot())
                VehicleSeat.AssemblyLinearVelocity = Vector3.yAxis * math.random() * 10
            end

            Character:PivotTo(Origin)
            Vehicle:PivotTo(Origin)
            VehicleSeat.AssemblyLinearVelocity = Vector3.zero
            for _, BasePart in next, Character:GetDescendants() do
                if BasePart:IsA("BasePart") then
                    BasePart.AssemblyLinearVelocity = Vector3.zero
                    BasePart.AssemblyAngularVelocity = Vector3.zero
                end
            end

            if Character.Humanoid.SeatPart == nil then
                -- Failed to sit in vehicle seat.
                return
            else
                -- Successfully sat in vehicle seat.
            end
        else
            Character:PivotTo(Vehicle:GetPivot())
        end
    end
end

local GetVehicle = function(): { Vehicle: Model?, Name: string? }?
    local Character = LocalPlayer.Character
    if not Character then
        return nil
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid") :: Humanoid
    local VehicleSeat = Humanoid.SeatPart

    if VehicleSeat and VehicleSeat.ClassName == "VehicleSeat" then
        local Vehicle = VehicleSeat.Parent :: Model
        local VehicleName = Vehicle.Name

        return {
            Vehicle = Vehicle,
            Name = VehicleName,
        }
    end

    return nil
end

local FindVehicle = function(): { Vehicle: Model?, Name: string? }?
    local Vehicles = workspace:WaitForChild("Vehicles")
    local LocalUserId = LocalPlayer.UserId
    
    print("FindVehicle: Looking for vehicles, LocalUserId:", LocalUserId)
    print("FindVehicle: Vehicles folder has", #Vehicles:GetChildren(), "children")
    
    -- First try to find owned vehicle
    for _, Vehicle in next, Vehicles:GetChildren() do
        local ownerId = Vehicle:GetAttribute("OwnerUserId")
        print("FindVehicle: Found vehicle", Vehicle.Name, "with OwnerUserId:", ownerId)
        if ownerId == LocalUserId then
            print("FindVehicle: Found matching vehicle:", Vehicle.Name)
            return {
                Vehicle = Vehicle,
                Name = Vehicle.Name,
            }
        end
    end
    
    -- Alternative: Check if player is sitting in any vehicle
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid and Humanoid.SeatPart then
            local Vehicle = Humanoid.SeatPart.Parent
            print("FindVehicle: Found vehicle by seat part:", Vehicle.Name)
            return {
                Vehicle = Vehicle,
                Name = Vehicle.Name,
            }
        end
    end
    
    print("FindVehicle: No matching vehicle found")
    return nil
end

-- Exact VehicleModSystem from sasware.lua
local VehicleModSystem
VehicleModSystem = {
	AttributeInfos = Storage.Vehicle_Attributes,
	TorqueAttributes = { "maxSpeedTorque", "minSpeedTorque" },
	AttributeCache = setmetatable({}, { __mode = "k" }),
	ChassisCache = setmetatable({}, { __mode = "k" }),
	LastVehicle = nil,
}

local function getDefaultPhysicalSnapshot(part: BasePart)
	return {
		hadCustom = false,
		density = nil,
		densityFallback = 1,
		friction = 0.3,
		elasticity = 0,
		frictionWeight = 1,
		elasticityWeight = 1,
	}
end

function VehicleModSystem:CaptureChassisState(chassis: BasePart)
	local current = chassis.CustomPhysicalProperties
	if current then
		return {
			hadCustom = true,
			density = current.Density,
			friction = current.Friction,
			elasticity = current.Elasticity,
			frictionWeight = current.FrictionWeight,
			elasticityWeight = current.ElasticityWeight,
			densityFallback = current.Density,
		}
	end
	return getDefaultPhysicalSnapshot(chassis)
end

function VehicleModSystem:RestoreChassisState(chassis: BasePart, cache: any)
	if not cache then
		return
	end
	if cache.hadCustom and cache.density then
		chassis.CustomPhysicalProperties = PhysicalProperties.new(
			cache.density,
			cache.friction,
			cache.elasticity,
			cache.frictionWeight,
			cache.elasticityWeight
		)
	else
		local ok = pcall(function()
			chassis.CustomPhysicalProperties = nil
		end)
		if not ok then
			local density = cache.density or cache.densityFallback or 1
			chassis.CustomPhysicalProperties = PhysicalProperties.new(
				density,
				cache.friction,
				cache.elasticity,
				cache.frictionWeight,
				cache.elasticityWeight
			)
		end
	end
end

local function isInstance(value: any): boolean
	return typeof(value) == "Instance"
end

function VehicleModSystem:IsInstanceValid(instance: Instance?): boolean
	if instance == nil then
		return false
	end
	return isInstance(instance) and instance.Parent ~= nil
end

function VehicleModSystem:StoreOriginal(instance: Instance, attrName: string, value: any)
	if not self:IsInstanceValid(instance) then
		return
	end
	local cache = self.AttributeCache[instance]
	if not cache then
		cache = {}
		self.AttributeCache[instance] = cache
	end
	if cache[attrName] == nil then
		cache[attrName] = value
	end
end

function VehicleModSystem:ApplyAttributeFolder(folder: Folder)
	if not self:IsInstanceValid(folder) then
		return
	end

	for _, info in ipairs(self.AttributeInfos) do
		local attrName = info.Name
		local currentValue = folder:GetAttribute(attrName)
		if currentValue ~= nil then
			self:StoreOriginal(folder, attrName, currentValue)
			local newValue = G_Option("VehicleMods_" .. attrName)
			if newValue ~= nil then
				folder:SetAttribute(attrName, newValue)
			end
		end
	end

	local torqueMultiplier = G_Option("VehicleMods_TorqueMultiplier")
	if torqueMultiplier == nil then
		torqueMultiplier = 1
	end
	for _, attrName in ipairs(self.TorqueAttributes) do
		local currentValue = folder:GetAttribute(attrName)
		if currentValue ~= nil then
			self:StoreOriginal(folder, attrName, currentValue)
			local original = self.AttributeCache[folder] and self.AttributeCache[folder][attrName]
			if type(original) == "number" and type(torqueMultiplier) == "number" then
				folder:SetAttribute(attrName, original * torqueMultiplier)
			end
		end
	end
end

function VehicleModSystem:ApplyAttributeModifiers(vehicle: Model)
	for _, child in ipairs(vehicle:GetChildren()) do
		if child:IsA("Folder") then
			self:ApplyAttributeFolder(child)
		end
	end
end

function VehicleModSystem:ApplySlamModifier(vehicle: Model)
	local chassis = vehicle:FindFirstChild("Chassis")
	if not (chassis and chassis:IsA("BasePart")) then
		return
	end
	if G_Toggle("VehicleSlam") then
		if not self.ChassisCache[chassis] then
			self.ChassisCache[chassis] = self:CaptureChassisState(chassis)
		end
		local cache = self.ChassisCache[chassis] or getDefaultPhysicalSnapshot(chassis)
		local friction = cache.friction or 0.3
		local elasticity = cache.elasticity or 0
		local frictionWeight = cache.frictionWeight or 1
		local elasticityWeight = cache.elasticityWeight or 1
		chassis.CustomPhysicalProperties = PhysicalProperties.new(50, friction, elasticity, frictionWeight, elasticityWeight)
	else
		local cache = self.ChassisCache[chassis]
		if cache then
			self:RestoreChassisState(chassis, cache)
			self.ChassisCache[chassis] = nil
		end
	end
end

function VehicleModSystem:PruneCache()
	for instance in pairs(self.AttributeCache) do
		if not self:IsInstanceValid(instance) then
			self.AttributeCache[instance] = nil
		end
	end
	for instance in pairs(self.ChassisCache) do
		if not self:IsInstanceValid(instance) then
			self.ChassisCache[instance] = nil
		end
	end
end

function VehicleModSystem:RestoreSlam()
	for chassis, cache in pairs(self.ChassisCache) do
		if self:IsInstanceValid(chassis) then
			self:RestoreChassisState(chassis, cache)
		end
		self.ChassisCache[chassis] = nil
	end
end

function VehicleModSystem:RevertVehicle(vehicle: Model?)
	for instance, attrMap in pairs(self.AttributeCache) do
		local shouldRevert = (not vehicle)
			or (self:IsInstanceValid(instance) and instance:IsDescendantOf(vehicle))
		if shouldRevert then
			if self:IsInstanceValid(instance) then
				for attrName, originalValue in pairs(attrMap) do
					pcall(instance.SetAttribute, instance, attrName, originalValue)
				end
			end
			self.AttributeCache[instance] = nil
		end
	end
	for chassis, cache in pairs(self.ChassisCache) do
		local shouldRevert = (not vehicle)
			or (self:IsInstanceValid(chassis) and chassis:IsDescendantOf(vehicle))
		if shouldRevert then
			if self:IsInstanceValid(chassis) then
				self:RestoreChassisState(chassis, cache)
			end
			self.ChassisCache[chassis] = nil
		end
	end
end

function VehicleModSystem:Reset()
	self:RevertVehicle(nil)
	self.LastVehicle = nil
end

function VehicleModSystem:Step()
	self:PruneCache()
	if not G_Toggle("VehicleModificationEnabled") then
		if self.LastVehicle then
			self:RevertVehicle(self.LastVehicle)
			self.LastVehicle = nil
		end
		self:RevertVehicle(nil)
		return
	end

	local VehicleData = FindVehicle()
	local vehicle = VehicleData and VehicleData.Vehicle
	if not (vehicle and vehicle.Parent) then
		if self.LastVehicle then
			self:RevertVehicle(self.LastVehicle)
			self.LastVehicle = nil
		end
		return
	end

	if self.LastVehicle and self.LastVehicle ~= vehicle then
		self:RevertVehicle(self.LastVehicle)
	end

	self.LastVehicle = vehicle
	self:ApplyAttributeModifiers(vehicle)
	self:ApplySlamModifier(vehicle)
end

-- Vehicle UI
VehicleTab:Section({
    Title = 'Vehicle Functions:',
})

VehicleTab:Button({
    Title = 'Bring Car',
    Icon = 'car',
    Callback = function()
        local Vehicles = workspace:WaitForChild("Vehicles")
        local LocalUserId = LocalPlayer.UserId
        
        for _, Vehicle in next, Vehicles:GetChildren() do
            if Vehicle:GetAttribute("OwnerUserId") == LocalUserId then
                local Character = LocalPlayer.Character
                if Character then
                    Vehicle:PivotTo(Character:GetPivot() + Vector3.yAxis * 12)
                    for _, Descendant in next, Vehicle:GetDescendants() do
                        if Descendant:IsA("BasePart") then
                            Descendant.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                end
            end
        end
    end,
})

VehicleTab:Divider()

VehicleTab:Section({
    Title = 'Vehicle Modifications:',
})

VehicleTab:Toggle({
    Title = 'Vehicle Mods Enabled',
    Flag = 'VehicleModificationEnabled',
    Icon = 'settings',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        if not Value then
            VehicleModSystem:Reset()
            -- Turn off VehicleSlam when VehicleModificationEnabled is turned off
            local window = getgenv().Window
            if window and window.Toggles and window.Toggles.VehicleSlam then
                window.Toggles.VehicleSlam:SetValue(false)
            end
        else
            VehicleModSystem:Step()
        end
    end,
})

VehicleTab:Toggle({
    Title = 'Slammed Vehicle',
    Flag = 'VehicleSlam',
    Icon = 'arrow-down',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        if not Value then
            VehicleModSystem:RestoreSlam()
        else
            VehicleModSystem:Step()
        end
    end,
})

-- Create sliders for each vehicle attribute (exact from sasware.lua - no callbacks)
for _, Attribute in next, Storage.Vehicle_Attributes do
    if Attribute.Type == "number" then
        VehicleTab:Slider({
            Title = Attribute.DisplayName,
            Flag = 'VehicleMods_' .. Attribute.Name,
            Step = 0.01,
            Value = {
                Min = Attribute.Min,
                Max = Attribute.Max,
                Default = Attribute.Min,
            },
        })
    end
end

VehicleTab:Slider({
    Title = 'Torque Multiplier',
    Flag = 'VehicleMods_TorqueMultiplier',
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 5,
        Default = 1,
    },
})

VehicleTab:Slider({
    Title = 'Max Speed Multiplier',
    Flag = 'VehicleMods_MaxSpeedMultiplier',
    Step = 0.01,
    Value = {
        Min = 1,
        Max = 1.3,
        Default = 1,
    },
})

-- Vehicle Mod System Update Loop (Exact from sasware.lua)
task.spawn(function()
    while task.wait(0.25) do
        VehicleModSystem:Step()
    end
end)

-- Additional UI Update Loop from sasware.lua
task.spawn(function()
    while task.wait(0.5) do
        if G_Toggle("VehicleModificationEnabled") then
            local VehicleData = FindVehicle()
            if VehicleData then
                local Vehicle = VehicleData.Vehicle
                
                task.spawn(function()
                    for _, Child in next, Vehicle:GetChildren() do
                        if Child:IsA("Folder") then
                            for Attribute, _ in next, Child:GetAttributes() do
                                -- Check if this is one of the targetted attributes
                                for _, VehicleAttribute in next, Storage.Vehicle_Attributes do
                                    if Attribute == VehicleAttribute.Name then
                                        Child:SetAttribute(
                                            Attribute,
                                            G_Option("VehicleMods_" .. VehicleAttribute.Name)
                                        )
                                    end
                                end

                                if Attribute == "maxSpeedTorque" then
                                    if not Child:GetAttribute("OldmaxSpeedTorque") then
                                        Child:SetAttribute("OldmaxSpeedTorque", Child:GetAttribute("maxSpeedTorque"))
                                    end

                                    Child:SetAttribute(
                                        "maxSpeedTorque",
                                        Child:GetAttribute("OldmaxSpeedTorque")
                                            * G_Option("VehicleMods_TorqueMultiplier")
                                    )
                                elseif Attribute == "minSpeedTorque" then
                                    if not Child:GetAttribute("OldminSpeedTorque") then
                                        Child:SetAttribute("OldminSpeedTorque", Child:GetAttribute("minSpeedTorque"))
                                    end

                                    Child:SetAttribute(
                                        "minSpeedTorque",
                                        Child:GetAttribute("OldminSpeedTorque")
                                            * G_Option("VehicleMods_TorqueMultiplier")
                                    )
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end)

-- 1. Setup Tab
local VisualTab = Window:Tab({
    Title = 'Visual',
    Icon = 'eye',
})

VisualTab:Section({
    Title = 'Players:',
})

-- 2. Configuration (เปิดตาม Toggle เท่านั้น)
_G.ShowBox = false
_G.ShowName = false
_G.ShowTracer = false
_G.ShowSkeleton = false
_G.ShowHealth = false

local function CreateESP(player)
    local objects = {
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        HealthBarOutline = Drawing.new("Line"),
        HealthBar = Drawing.new("Line"),
        BoxLines = {},
        SkeletonLines = {}
    }

    for i = 1, 12 do objects.BoxLines[i] = Drawing.new("Line") end
    for i = 1, 6 do objects.SkeletonLines[i] = Drawing.new("Line") end

    -- Setup Styles
    objects.Name.Center = true
    objects.Name.Outline = true
    objects.Name.Size = 14
    objects.Name.Font = 2
    objects.Name.Color = Color3.fromRGB(255, 255, 255)
    
    objects.HealthBar.Thickness = 2
    objects.HealthBarOutline.Thickness = 3
    objects.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)

    local function Update()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")

            -- ถ้าผู้เล่นออกจากเกม หรือตัวละครหายไป ให้ลบ Object และตัดการเชื่อมต่อ
            if not player.Parent then
                for _, obj in pairs(objects) do 
                    if type(obj) == "table" then for _, v in pairs(obj) do v:Remove() end 
                    else obj:Remove() end 
                end
                connection:Disconnect()
                return
            end

            -- เช็คว่าควรแสดงผลหรือไม่ (ต้องมีตัวละคร, เลือด > 0)
            local canShow = hrp and hum and hum.Health > 0
            local hrp_pos, onScreen = nil, false
            
            if canShow then
                hrp_pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            end

            -- 1. Tracer
            if canShow and onScreen and _G.ShowTracer then
                objects.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                objects.Tracer.To = Vector2.new(hrp_pos.X, hrp_pos.Y)
                objects.Tracer.Color = Color3.fromRGB(255, 255, 255)
                objects.Tracer.Visible = true
            else objects.Tracer.Visible = false end

            -- 2. Name & Health Bar
            local head = char and char:FindFirstChild("Head")
            if canShow and onScreen and head then
                local head_pos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                
                if _G.ShowName then
                    objects.Name.Position = Vector2.new(head_pos.X, head_pos.Y - 20)
                    objects.Name.Text = string.format("[%s]", player.Name)
                    objects.Name.Visible = true
                else objects.Name.Visible = false end
                
                if _G.ShowHealth then
                    local bar_x = head_pos.X - 25
                    local health_p = hum.Health / hum.MaxHealth
                    objects.HealthBarOutline.From = Vector2.new(bar_x, head_pos.Y - 5)
                    objects.HealthBarOutline.To = Vector2.new(bar_x + 50, head_pos.Y - 5)
                    objects.HealthBarOutline.Visible = true
                    
                    objects.HealthBar.From = Vector2.new(bar_x, head_pos.Y - 5)
                    objects.HealthBar.To = Vector2.new(bar_x + (50 * health_p), head_pos.Y - 5)
                    objects.HealthBar.Color = Color3.fromHSV(health_p * 0.3, 1, 1)
                    objects.HealthBar.Visible = true
                else
                    objects.HealthBar.Visible = false
                    objects.HealthBarOutline.Visible = false
                end
            else
                objects.Name.Visible = false
                objects.HealthBar.Visible = false
                objects.HealthBarOutline.Visible = false
            end

            -- 3. 3D Box
            if canShow and onScreen and _G.ShowBox then
                local size = Vector3.new(2, 5, 1.2)
                local cf = hrp.CFrame
                local v = {
                    cf * CFrame.new(size.X/2, size.Y/2, size.Z/2).Position, cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2).Position,
                    cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2).Position, cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2).Position,
                    cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2).Position, cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2).Position,
                    cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2).Position, cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2).Position
                }
                local s = {}
                for i=1,8 do s[i] = Camera:WorldToViewportPoint(v[i]) end
                local pairs = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
                for i, p in ipairs(pairs) do
                    objects.BoxLines[i].From = Vector2.new(s[p[1]].X, s[p[1]].Y)
                    objects.BoxLines[i].To = Vector2.new(s[p[2]].X, s[p[2]].Y)
                    objects.BoxLines[i].Color = Color3.fromRGB(255, 255, 255)
                    objects.BoxLines[i].Visible = true
                end
            else for i=1,12 do objects.BoxLines[i].Visible = false end end

            -- 4. Skeleton
            if canShow and onScreen and _G.ShowSkeleton then
                local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
                local v_skel = true
                for _, p in pairs(parts) do if not char:FindFirstChild(p) then v_skel = false break end end
                
                if v_skel then
                    local function ToS(p) return Camera:WorldToViewportPoint(char[p].Position) end
                    local j = {
                        {ToS("Head"), ToS("UpperTorso")}, {ToS("UpperTorso"), ToS("LeftUpperArm")},
                        {ToS("UpperTorso"), ToS("RightUpperArm")}, {ToS("UpperTorso"), ToS("LowerTorso")},
                        {ToS("LowerTorso"), ToS("LeftUpperLeg")}, {ToS("LowerTorso"), ToS("RightUpperLeg")}
                    }
                    for i, joint in ipairs(j) do
                        objects.SkeletonLines[i].From = Vector2.new(joint[1].X, joint[1].Y)
                        objects.SkeletonLines[i].To = Vector2.new(joint[2].X, joint[2].Y)
                        objects.SkeletonLines[i].Color = Color3.fromRGB(255, 255, 255)
                        objects.SkeletonLines[i].Visible = true
                    end
                end
            else for i=1,6 do objects.SkeletonLines[i].Visible = false end end
        end)
    end
    coroutine.wrap(Update)()
end

-- Initialize
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)

-- 3. UI Toggles
VisualTab:Toggle({
    Title = "3D Box",
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value) _G.ShowBox = Value end,
})

VisualTab:Toggle({
    Title = "Player Names",
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value) _G.ShowName = Value end,
})

VisualTab:Toggle({
    Title = "Health Bar",
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value) _G.ShowHealth = Value end,
})

VisualTab:Toggle({
    Title = "Tracers",
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value) _G.ShowTracer = Value end,
})

VisualTab:Toggle({
    Title = "Skeleton",
    Icon = 'check',
    Type = 'Checkbox',
    Default = false,
    Callback = function(Value) _G.ShowSkeleton = Value end,
})

VisualTab:Toggle({
    Title = 'Inventory Viewer',
    Flag = 'inventoryviewer',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(Value)
        _G.InventoryViewerEnabled = Value

        local Players = game:GetService('Players')
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local Client = Players.LocalPlayer

        local function GetColorFromRarity(rarityName)
            local colors = {
                Common = Color3.fromRGB(255, 255, 255),
                UnCommon = Color3.fromRGB(99, 255, 52),
                Rare = Color3.fromRGB(51, 170, 255),
                Legendary = Color3.fromRGB(255, 150, 0),
                Epic = Color3.fromRGB(237, 44, 255),
                Omega = Color3.fromRGB(255, 20, 51),
            }

            return colors[rarityName] or Color3.fromRGB(255, 255, 255)
        end

        if Value then
            if not _G.ViewerRunning then
                _G.ViewerRunning = true

                task.spawn(function()
                    while task.wait(0.2) do
                        if _G.InventoryViewerEnabled then
                            pcall(function()
                                for _, v in pairs(Players:GetPlayers())do
                                    if v ~= Client and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
                                        local root = v.Character.HumanoidRootPart
                                        local gui = root:FindFirstChild('ItemBillboard')

                                        if not gui then
                                            gui = Instance.new('BillboardGui')
                                            gui.Name = 'ItemBillboard'
                                            gui.AlwaysOnTop = true
                                            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                                            gui.Size = UDim2.new(0, 300, 0, 80)
                                            gui.StudsOffset = Vector3.new(0, -5, 0)
                                            gui.ExtentsOffset = Vector3.new(0, 1, 0)
                                            gui.LightInfluence = 1
                                            gui.Parent = root

                                            local bg = Instance.new('Frame')

                                            bg.Name = 'BG'
                                            bg.BackgroundTransparency = 1
                                            bg.Size = UDim2.new(1, 0, 1, 0)
                                            bg.AnchorPoint = Vector2.new(0.5, 0.5)
                                            bg.Position = UDim2.new(0.5, 0, 0.5, 0)
                                            bg.Parent = gui

                                            local layout = Instance.new('UIListLayout')

                                            layout.FillDirection = Enum.FillDirection.Horizontal
                                            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                                            layout.VerticalAlignment = Enum.VerticalAlignment.Center
                                            layout.Padding = UDim.new(0, 8)
                                            layout.Parent = bg
                                        end

                                        local bg = gui:FindFirstChild('BG')

                                        if bg then
                                            local Items = {}

                                            for _, child in pairs(bg:GetChildren())do
                                                if child:IsA('Frame') then
                                                    child:Destroy()
                                                end
                                            end
                                            for _, container in pairs({
                                                v:FindFirstChild('Backpack'),
                                                v.Character,
                                            })do
                                                if container then
                                                    for _, tool in pairs(container:GetChildren())do
                                                        if tool:IsA('Tool') and not tool:GetAttribute('JobTool') and not tool:GetAttribute('Locked') then
                                                            local itemFolder = tool:GetAttribute('AmmoType') and ReplicatedStorage.Items.gun or ReplicatedStorage.Items.melee

                                                            for _, z in pairs(itemFolder:GetChildren())do
                                                                if tool:GetAttribute('RarityName') == z:GetAttribute('RarityName') and tool:GetAttribute('RarityPrice') == z:GetAttribute('RarityPrice') then
                                                                    local imageId = z:GetAttribute('ImageId')

                                                                    if imageId then
                                                                        Items[z.Name] = true

                                                                        if not bg:FindFirstChild(z.Name .. '_bg') then
                                                                            local itemContainer = Instance.new('Frame')

                                                                            itemContainer.Name = z.Name .. '_bg'
                                                                            itemContainer.Size = UDim2.new(0, 50, 0, 70)
                                                                            itemContainer.BackgroundTransparency = 1
                                                                            itemContainer.BorderSizePixel = 0
                                                                            itemContainer.Parent = bg

                                                                            local iconBg = Instance.new('Frame')

                                                                            iconBg.Name = 'IconBg'
                                                                            iconBg.Size = UDim2.new(0, 50, 0, 50)
                                                                            iconBg.Position = UDim2.new(0, 0, 0, 0)
                                                                            iconBg.BackgroundColor3 = GetColorFromRarity(z:GetAttribute('RarityName'))
                                                                            iconBg.BackgroundTransparency = 1
                                                                            iconBg.BorderSizePixel = 0
                                                                            iconBg.Parent = itemContainer

                                                                            local bgImage = Instance.new('ImageLabel')

                                                                            bgImage.Name = 'Background'
                                                                            bgImage.Size = UDim2.new(1, 0, 1, 0)
                                                                            bgImage.BackgroundTransparency = 1
                                                                            bgImage.Image = 'rbxassetid://137066731814190'
                                                                            bgImage.ImageColor3 = GetColorFromRarity(z:GetAttribute('RarityName'))
                                                                            bgImage.ZIndex = 0
                                                                            bgImage.Parent = iconBg

                                                                            local corner = Instance.new('UICorner')

                                                                            corner.CornerRadius = UDim.new(0.15, 0)
                                                                            corner.Parent = iconBg

                                                                            local icon = Instance.new('ImageLabel')

                                                                            icon.Name = z.Name
                                                                            icon.Image = imageId
                                                                            icon.BackgroundTransparency = 1
                                                                            icon.BorderSizePixel = 0
                                                                            icon.Size = UDim2.new(0.85, 0, 0.85, 0)
                                                                            icon.Position = UDim2.new(0.075, 0, 0.075, 0)
                                                                            icon.Parent = iconBg

                                                                            local corner2 = Instance.new('UICorner')

                                                                            corner2.CornerRadius = UDim.new(0, 9)
                                                                            corner2.Parent = icon

                                                                            local nameLabel = Instance.new('TextLabel')

                                                                            nameLabel.Name = 'WeaponName'
                                                                            nameLabel.Size = UDim2.new(1, 0, 0, 20)
                                                                            nameLabel.Position = UDim2.new(0, 0, 0, 52)
                                                                            nameLabel.BackgroundTransparency = 1
                                                                            nameLabel.Text = z.Name
                                                                            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                                                            nameLabel.TextStrokeTransparency = 0.5
                                                                            nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                                                                            nameLabel.TextScaled = true
                                                                            nameLabel.Font = Enum.Font.GothamBold
                                                                            nameLabel.Parent = itemContainer

                                                                            local textSizeConstraint = Instance.new('UITextSizeConstraint')

                                                                            textSizeConstraint.MaxTextSize = 10
                                                                            textSizeConstraint.Parent = nameLabel
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end

                                            gui.Enabled = _G.InventoryViewerEnabled

                                            for _, child in pairs(bg:GetChildren())do
                                                if child:IsA('Frame') then
                                                    local itemName = child.Name:gsub('_bg$', '')

                                                    if not Items[itemName] then
                                                        child:Destroy()
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end)
            end
        else
            for _, v in pairs(Players:GetPlayers())do
                if v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
                    local gui = v.Character.HumanoidRootPart:FindFirstChild('ItemBillboard')

                    if gui then
                        gui:Destroy()
                    end
                end
            end
        end
    end,
})

local RunService = game:GetService('RunService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local item_data = {}
local espEnabled = true
local RARITY_COLORS = {
    Common = Color3.fromRGB(255, 255, 255),
    Uncommon = Color3.fromRGB(99, 255, 52),
    Rare = Color3.fromRGB(51, 170, 255),
    Epic = Color3.fromRGB(237, 44, 255),
    Legendary = Color3.fromRGB(255, 150, 0),
    Omega = Color3.fromRGB(255, 20, 51),
}
local DEFAULT_COLOR = Color3.fromRGB(255, 255, 255)

local function getItemRarityColor(itemName)
    local Items = ReplicatedStorage:FindFirstChild('Items')

    if not Items then
        return DEFAULT_COLOR
    end

    for _, obj in ipairs(Items:GetDescendants())do
        if obj.Name == itemName then
            local rarityName = obj:GetAttribute('RarityName')

            if rarityName and RARITY_COLORS[rarityName] then
                return RARITY_COLORS[rarityName], rarityName
            end
        end
    end

    return DEFAULT_COLOR, nil
end

VisualTab:Toggle({
    Title = 'Drop Item Viewer',
    Flag = 'dropitem_viewer',
    Icon = 'check',
    Type = 'Checkbox',
    Default = true,
    Callback = function(state)
        espEnabled = state

        for _, d in pairs(item_data)do
            if d.highlight then
                d.highlight.Enabled = state
            end
            if d.billboard then
                d.billboard.Enabled = state
            end
        end
    end,
})

local function getAmountText(item)
    local amountGui = item:FindFirstChild('AmountBillboardGui', true)

    if amountGui then
        local textLabel = amountGui:FindFirstChildWhichIsA('TextLabel', true)

        if textLabel and textLabel.Text ~= '' then
            return textLabel.Text
        end
    end

    return nil
end
local function createESP(item)
    if item_data[item] then
        return
    end

    local rarityColor, rarityName = getItemRarityColor(item.Name)
    local highlight = Instance.new('Highlight')

    highlight.Name = 'DropESP_Highlight'
    highlight.FillColor = rarityColor
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = rarityColor
    highlight.OutlineTransparency = 0
    highlight.Adornee = item
    highlight.Enabled = espEnabled
    highlight.Parent = item

    local billboard = Instance.new('BillboardGui')

    billboard.Name = 'DropESP_Label'
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = espEnabled
    billboard.Parent = item

    local nameLabel = Instance.new('TextLabel')

    nameLabel.Name = 'NameLabel'
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = rarityColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = item.Name
    nameLabel.Parent = billboard

    local amountLabel = Instance.new('TextLabel')

    amountLabel.Name = 'AmountLabel'
    amountLabel.Size = UDim2.new(1, 0, 0.5, 0)
    amountLabel.Position = UDim2.new(0, 0, 0.5, 0)
    amountLabel.BackgroundTransparency = 1
    amountLabel.TextColor3 = rarityColor
    amountLabel.TextStrokeTransparency = 0
    amountLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    amountLabel.TextScaled = true
    amountLabel.Font = Enum.Font.Gotham
    amountLabel.Text = ''
    amountLabel.Parent = billboard
    item_data[item] = {
        highlight = highlight,
        billboard = billboard,
        nameLabel = nameLabel,
        amountLabel = amountLabel,
    }
end
local function removeESP(item)
    local d = item_data[item]

    if not d then
        return
    end
    if d.highlight then
        d.highlight:Destroy()
    end
    if d.billboard then
        d.billboard:Destroy()
    end

    item_data[item] = nil
end

local Dropped = workspace:WaitForChild('DroppedItems')

for _, item in ipairs(Dropped:GetChildren())do
    createESP(item)
end

Dropped.ChildAdded:Connect(function(item)
    task.wait()
    createESP(item)
end)
Dropped.ChildRemoved:Connect(function(item)
    removeESP(item)
end)
RunService.Heartbeat:Connect(function()
    if not espEnabled then
        return
    end

    for item in pairs(item_data)do
        if not item.Parent then
            removeESP(item)
        end
    end
    for item, d in pairs(item_data)do
        local amount = getAmountText(item)

        d.amountLabel.Text = amount and ('[ ' .. amount .. ' ]') or ''
    end
end)

local MiscTab = Window:Tab({
    Title = 'Misc',
    Icon = 'circle-ellipsis',
})

MiscTab:Toggle({
    Title = 'Skip Animation',
    Flag = 'skip_anim',
    Icon = 'check',
    Type = 'Checkbox',
    Value = false,
    Callback = function(Value)
        Window.EnabledSkip = Value

        if Window.EnabledSkip then
            task.spawn(function()
                while Window.EnabledSkip do
                    for _, crate in pairs(CrateController.class.objects)do
                        crate.states.open.set(true)
                        CrateController.skipping.set(true)
                    end

                    task.wait(0.05)
                end
            end)
        end
    end,
})
MiscTab:Toggle({
    Title = 'Infinite Hotbar',
    Flag = 'infhotbar',
    Icon = 'check',
    Type = 'Checkbox',
    Callback = function(Value)
        if not Value then
            return
        end

        for _, v in pairs(getgc(true))do
            if type(v) == 'function' then
                local info = debug.getinfo(v)

                if info.name == 'get_max_items' then
                    hookfunction(v, function(...)
                        return 999
                    end)
                end
            end
        end
    end,
})
MiscTab:Button({
    Title = 'Claim All Quest',
    Callback = function()
        local Net = require(game.ReplicatedStorage.Modules.Core.Net)
        local QuestsData = require(game.ReplicatedStorage.Modules.Game.Quests.QuestsData)
        local Data = require(game.ReplicatedStorage.Modules.Core.Data)

        for questID, _ in pairs(QuestsData.list)do
            local playerQuestData = Data.active_quests[questID]

            if playerQuestData and playerQuestData.completed and not playerQuestData.claimed then
                Net.get('claim_quest', questID)
            end
        end
    end,
})
MiscTab:Section({
    Title = 'Crate:',
})

Window.selectedAmmoCrate = 'Pistol'

MiscTab:Dropdown({
    Title = 'Select Ammo Crate',
    Values = {
        'Pistol',
        'Rifle',
        'Shotgun',
        'Special',
    },
    Default = 'Pistol',
    Callback = function(Value)
        Window.selectedAmmoCrate = Value
    end,
})
MiscTab:Button({
    Title = 'Open Selected Ammo Crate',
    Callback = function()
        local crate = workspace:WaitForChild('Map'):WaitForChild('Tiles'):WaitForChild('GunShopTile'):WaitForChild('PatriotWeapons'):WaitForChild('Interior'):WaitForChild('Crates'):WaitForChild('Ammo Crate'):WaitForChild('CrateOptions'):WaitForChild(Window.selectedAmmoCrate)

        Net.get('open_crate', crate, 'money')
    end,
})
MiscTab:Divider()

Window.selectedWeaponCrate = 'Basic'

MiscTab:Dropdown({
    Title = 'Select Weapon Crate',
    Values = {
        'Basic',
        'Advanced',
        'Superior',
        'Elite',
        'Legendary',
    },
    Default = 'Basic',
    Callback = function(Value)
        Window.selectedWeaponCrate = Value
    end,
})
MiscTab:Button({
    Title = 'Open Selected Weapon Crate',
    Callback = function()
        local crate = workspace:WaitForChild('Map'):WaitForChild('Tiles'):WaitForChild('GunShopTile'):WaitForChild('PatriotWeapons'):WaitForChild('Interior'):WaitForChild('Crates'):WaitForChild('Weapon Crate'):WaitForChild('CrateOptions'):WaitForChild(Window.selectedWeaponCrate)

        Net.get('open_crate', crate, 'money')
    end,
})
MiscTab:Divider()

Window.selectedCarCrate = 'Basic'

MiscTab:Dropdown({
    Title = 'Select Car Crate',
    Values = {
        'Basic',
        'Rare',
        'Elite',
        'Omega',
    },
    Default = 'Basic',
    Callback = function(Value)
        Window.selectedCarCrate = Value
    end,
})
MiscTab:Button({
    Title = 'Open Selected Car Crate',
    Callback = function()
        local crate = workspace:WaitForChild('Map'):WaitForChild('Tiles'):WaitForChild('PrestigeDealerAndHousing'):WaitForChild('PrestigeCarDealer'):WaitForChild('Interior'):WaitForChild('Crates'):WaitForChild('Car Crate'):WaitForChild('CrateOptions'):WaitForChild(Window.selectedCarCrate)

        Net.get('open_crate', crate, 'money')
    end,
})

local GraphicsTab = Window:Tab({
    Title = 'Graphic',
    Icon = 'monitor',
})

GraphicsTab:Button({
    Title = 'BoostFps',
    Desc = 'SuperVeryUltraLowPotato Graphic',
    Icon = 'rocket',
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet('https://pastefy.app/Pmu7jqMe/raw'))()
    end,
})

local WhiteScreenEnabled = false

GraphicsTab:Toggle({
    Title = 'White Screen',
    Flag = 'white_screen',
    Desc = '<<<3',
    Locked = false,
    Callback = function(Value)
        WhiteScreenEnabled = Value

        local RunService = game:GetService('RunService')

        RunService:Set3dRenderingEnabled(not WhiteScreenEnabled)
    end,
})

local ServerTab = Window:Tab({
    Title = 'Server',
    Icon = 'server',
})

ServerTab:Section({
    Title = 'Server Information:',
})
ServerTab:Code({
    Title = 'Current Server',
    Code = ' ' .. (game.JobId or 'Unknown'),
})
ServerTab:Divider()
ServerTab:Section({
    Title = 'Server Utilities:',
})
ServerTab:Input({
    Title = 'Enter Server Code',
    Placeholder = 'Paste server JobId here...',
    Callback = function(Value)
        Window.ServerCode = Value
    end,
})
ServerTab:Button({
    Title = 'Join by Code',
    Icon = 'log-in',
    Callback = function()
        if not Window.ServerCode or Window.ServerCode == '' then
            warn('\u{e43}\u{e2a}\u{e48}code\u{e14}\u{e34}\u{e19}\u{e49}\u{e2d}\u{e07}')

            return
        end

        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, Window.ServerCode, game.Players.LocalPlayer)
    end,
})
ServerTab:Button({
    Title = 'Rejoin Current Server',
    Icon = 'refresh-ccw',
    Callback = function()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end,
})
ServerTab:Button({
    Title = 'Hop Server (Lowest Player)',
    Icon = 'shuffle',
    Callback = function()
        local data = game:GetService('HttpService'):JSONDecode(game:HttpGet(string.format('https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100', game.PlaceId)))

        if data and data.data then
            local servers = {}

            for _, v in pairs(data.data)do
                if v.playing < v.maxPlayers then
                    table.insert(servers, v.id)
                end
            end

            if #servers > 0 then
                game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
            end
        end
    end,
})

local ConfigTab = Window:Tab({
    Title = 'Config',
    Icon = 'settings',
})

ConfigTab:Section({
    Title = 'Config Manager:',
})
ConfigTab:Input({
    Title = 'Config Name',
    Placeholder = 'Enter config name...',
    Callback = function(value)
        Window.ConfigName = value
    end,
})
ConfigTab:Button({
    Title = 'Save Config',
    Icon = 'save',
    Callback = function()
        if Window.ConfigName and Window.ConfigName ~= '' then
            Window.ConfigManager:CreateConfig(Window.ConfigName):Save()
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Saved: ' .. Window.ConfigName,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Please enter config name!',
                Duration = 2,
            })
        end
    end,
})
ConfigTab:Button({
    Title = 'Load Config',
    Icon = 'folder-open',
    Callback = function()
        if Window.ConfigName and Window.ConfigName ~= '' then
            Window.ConfigManager:CreateConfig(Window.ConfigName):Load()
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Loaded: ' .. Window.ConfigName,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Please enter config name!',
                Duration = 2,
            })
        end
    end,
})
ConfigTab:Button({
    Title = 'Delete Config',
    Icon = 'trash-2',
    Callback = function()
        if Window.ConfigName and Window.ConfigName ~= '' then
            Window.ConfigManager:CreateConfig(Window.ConfigName):Delete()
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Deleted: ' .. Window.ConfigName,
                Duration = 2,
            })
        else
            WindUI:Notify({
                Title = 'Config Manager',
                Content = 'Please enter config name!',
                Duration = 2,
            })
        end
    end,
})
task.wait(0.1)

local RS = game:GetService('ReplicatedStorage')

pcall(function()
    local Util = require(RS.Modules.Core.Util)

    if Util.tween then
        local old_tween = Util.tween

        Util.tween = function(instance, tweenInfo, properties, ...)
            if instance:IsA('NumberValue') and properties.Value == 1 and tweenInfo.Time > 0.1 then
                tweenInfo = TweenInfo.new(0.1, tweenInfo.EasingStyle, tweenInfo.EasingDirection, tweenInfo.RepeatCount, tweenInfo.Reverses, tweenInfo.DelayTime)
            end

            return old_tween(instance, tweenInfo, properties, ...)
        end
    end

    local BuyPromptUI = require(RS.Modules.Game.UI.BuyPromptUI)

    if BuyPromptUI.loaded then
        local old_loaded = BuyPromptUI.loaded

        BuyPromptUI.loaded = function(...)
            local result = old_loaded(...)

            task.spawn(function()
                task.wait(0.5)

                local UI = require(RS.Modules.Core.UI)
                local sellButton = UI.get('SellPromptSellButton')

                if sellButton and Util.tween then
                    Util.tween = function(instance, tweenInfo, properties, ...)
                        if instance:IsA('NumberValue') and properties.Value == 1 and tweenInfo.Time > 0 then
                            tweenInfo = TweenInfo.new(0, tweenInfo.EasingStyle, tweenInfo.EasingDirection, tweenInfo.RepeatCount, tweenInfo.Reverses, tweenInfo.DelayTime)
                        end

                        return old_tween(instance, tweenInfo, properties, ...)
                    end
                end
            end)

            return result
        end
    end
end)
