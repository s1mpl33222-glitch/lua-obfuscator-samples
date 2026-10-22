-- Recovered Luau source by ZeroVector
local lib = loadstring(game:HttpGet("https://script.panduhub.com/PanduUiLibrary.lua"))()
local v, Players, localPlayer, RunService, UserInputService, VirtualInputManager, ReplicatedStorage, CoreGui, playerGui, currentCamera, CollectionService, HttpService, tbl, tbl2, tbl3, flag, tbl4, fn, fn2, fn3
local fn4, fn5, fn6, fn7, fn8, v2, fn9, fn10, fn11

do
    lib.Scheme.AccentColor = Color3.fromRGB(255, 255, 255)
    lib.Scheme.BackgroundColor = Color3.fromRGB(10, 10, 12)
    lib.Scheme.MainColor = Color3.fromRGB(16, 16, 18)
    lib.Scheme.OutlineColor = Color3.fromRGB(255, 255, 255)
    lib.Scheme.FontColor = Color3.fromRGB(235, 235, 240)
    lib.Scheme.SubTextColor = Color3.fromRGB(140, 140, 150)
    lib.Scheme.HoverColor = Color3.fromRGB(22, 22, 26)

    v = lib:CreateWindow({
        Title = "OXio Hub",
        Subtitle = "Violance District",
        SubtitleColor = Color3.fromRGB(190, 140, 255),
        Logo = "rbxassetid://118755181202304",
        LogoSize = 32,
        SphereText = false,
        SphereWords = "ZX",
        SphereImage = "rbxassetid://118755181202304",
        SphereIconSize = 38,
        Watermark = true,
        WatermarkText = "OXIO",
        WatermarkIcon = "rbxassetid://118755181202304",
    })

    Players = game:GetService("Players")
    localPlayer = Players.LocalPlayer
    RunService = game:GetService("RunService")
    UserInputService = game:GetService("UserInputService")
    VirtualInputManager = game:GetService("VirtualInputManager")
    local GuiService = game:GetService("GuiService")
    ReplicatedStorage = game:GetService("ReplicatedStorage")
    CoreGui = game:GetService("CoreGui")
    playerGui = localPlayer:WaitForChild("PlayerGui")
    currentCamera = workspace.CurrentCamera
    CollectionService = game:GetService("CollectionService")
    HttpService = game:GetService("HttpService")
    game:GetService("TeleportService")
    local TweenService = game:GetService("TweenService")
    _G.Ox = {}
    _G.Ox.AntiBlindEnabled = false
    _G.Ox.GotBlindedRemote = nil
    _G.Ox.NoSlowdownEnabled = false
    _G.Ox.BypassLeapEnabled = false
    _G.Ox.InfAbyssalEnabled = false
    _G.Ox.KILLER_SilentAimFlask = false
    _G.Ox.KILLER_FlaskLaser = false
    _G.Ox.NEX_CureFlaskLaserThread = nil
    _G.Ox.NEX_CureFlaskLaserPart = nil
    _G.Ox.InfiniteLungeEnabled = false

    local tbl5 = {
        ["122812055447896"] = "Veil lunge",
        ["133963973694098"] = "Mayers Basic",
        ["117042998468241"] = "Mayers lunge",
        ["135002183282873"] = "cure lunge",
        ["121216847022485"] = "cure Basic",
        ["132817836308238"] = "Jeff Basic",
        ["129784271201071"] = "Jeff lunge",
        ["82666958311998"] = "Jeff Frenzy",
        ["78432063483146"] = "Abyssal Basic",
        ["118907603246885"] = "Abyssal lunge",
        ["139369275981139"] = "Jason Basic",
        ["110355011987939"] = "Jason lunge",
        ["111920872708571"] = "Masked Basic",
        ["105374834496520"] = "Masked lunge",
        ["138720291317243"] = "Masked Tony",
        ["106871536134254"] = "Masked Alex",
        ["130593238885843"] = "Masked Cobra",
        ["115244153053858"] = "Masked Cobra lunge",
        ["74968262036854"] = "Hidden Basic",
        ["113255068724446"] = "Hidden lunge",
        ["98163597193511"] = "Hidden S1",
        ["80411309607666"] = "Abyssal S1",
    }

    _G.Ox.ParryConfig = {
        AutoParry = false,
        ParrySafety = false,
        ParryAggressive = false,
        ParryCircle = true,
        ParryRadius = 15,
        ParryFace = 0.7,
        AutoCrouch = false,
        Ignored_Skills = {},
    }

    _G.Ox.ParryV2 = {
        Enabled = false,
        SafetyParry = false,
        Mode = "Legit",
        Trigger = "Remote",
        Range = 12,
        KillerFace = 0.6,
        ShowCircle = true,
        IsOnCooldown = false,
        IsResolving = false,
        CooldownToken = 0,
        CooldownThread = nil,
        Attached = {},
        Gradients = {},
        Icon = nil,
        LockConnection = nil,
        ParryTrack = nil,
        RangeAdornment = nil,
        BtnCache = nil,
    }

    _G.Ox.ParryV2Anim = {
        Default = "rbxassetid://109133187196613",
        Shield = "rbxassetid://75939529748815",
        Robot = "rbxassetid://126894569253341",
        Katana = "rbxassetid://127096285501517",
        Fish = "rbxassetid://123307242865945",
        Watcher = "rbxassetid://81793464499285",
        Enten = "rbxassetid://127096285501517",
        BloodShield = "rbxassetid://75939529748815",
        Fih = "rbxassetid://123307242865945",
        Feedbacker = "rbxassetid://126894569253341",
        StopWatch = "rbxassetid://81793464499285",
    }

    _G.Ox.ParryV2AttackAnims = {
        ["rbxassetid://78432063483146"] = true,
        ["rbxassetid://121216847022485"] = true,
        ["rbxassetid://74968262036854"] = true,
        ["rbxassetid://132817836308238"] = true,
        ["rbxassetid://82666958311998"] = true,
        ["rbxassetid://111920872708571"] = true,
        ["rbxassetid://106871536134254"] = true,
        ["rbxassetid://109402730355822"] = true,
        ["rbxassetid://130593238885843"] = true,
        ["rbxassetid://138720291317243"] = true,
        ["rbxassetid://139369275981139"] = true,
        ["rbxassetid://133963973694098"] = true,
        ["rbxassetid://78935059863801"] = true,
        ["rbxassetid://118907603246885"] = true,
        ["rbxassetid://135002183282873"] = true,
        ["rbxassetid://113255068724446"] = true,
        ["rbxassetid://129784271201071"] = true,
        ["rbxassetid://105374834496520"] = true,
        ["rbxassetid://117070354890871"] = true,
        ["rbxassetid://115244153053858"] = true,
        ["rbxassetid://110355011987939"] = true,
        ["rbxassetid://117042998468241"] = true,
        ["rbxassetid://122812055447896"] = true,
    }

    _G.Ox._V2RayParams = RaycastParams.new()
    _G.Ox._V2RayParams.FilterType = Enum.RaycastFilterType.Exclude
    _G.Ox._V2ParryRangeRay = RaycastParams.new()
    _G.Ox._V2ParryRangeRay.FilterType = Enum.RaycastFilterType.Exclude
    _G.Ox._V2ParryLastRadius = -1
    _G.Ox._V2ParryLastRoot = nil
    _G.Ox.AttachedParry = {}

    if not _G.Ox.State then
        _G.Ox.State = {}
    end

    _G.Ox.State.ParryCooldown = false
    _G.Ox.State.ParryCooldownTime = 60
    _G.Ox.State.AutoParryAdornment = nil
    _G.Ox.State.ParryCooldownThread = nil
    _G.Ox.AutoParryCustom = {Gui = nil, IsActive = false, GuiVisible = false}
    local ox = _G.Ox
    local parryHUD = _G.Ox.ParryHUD
    local v3 = parryHUD

    if not parryHUD then
        local tbl6 = {}
        v3 = tbl6
        tbl6.gradients = {}
        tbl6.icon = nil
        tbl6.rescanConn = nil
        tbl6.cachedIconColor = nil
    end

    ox.ParryHUD = v3
    ParryHUD = _G.Ox.ParryHUD

    IsDowned = function(arg)
        if not arg then
            return false
        end
        local flag2 = arg:GetAttribute("Knocked") == true or arg:GetAttribute("IsHooked") == true
        return flag2
    end

    IsKiller = function(arg)
        local flag2 = arg and arg.Team and arg.Team.Name == "Killer"
        return flag2
    end

    TriggerCrouch = function()
        pcall(function()
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

            for match in string.gmatch("Survivor-mob.Controls.crouch.icon", "[^%.]+") do
                if playerGui2 then
                    playerGui2 = playerGui2:FindFirstChild(match)
                end
            end

            if playerGui2 and playerGui2:IsA("GuiObject") and playerGui2.Visible and playerGui2.Parent and playerGui2.Parent:IsA("GuiButton") then
                local parent = playerGui2.Parent

                if UserInputService.TouchEnabled and type(firesignal) == "function" then
                    firesignal(parent.MouseButton1Click)
                    task.wait(1.4)
                    firesignal(parent.MouseButton1Click)
                else
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                    task.wait(1.4)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
                end
            else
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
                task.wait(1.4)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
            end
        end)
    end

    IsSafeToParry = function(arg)
        if not _G.Ox.ParryConfig.ParrySafety then
            return true
        end

        if not arg then
            return false
        end
        local checkInterractable = arg:FindFirstChild("CheckInterractable")

        if checkInterractable then
            if checkInterractable:GetAttribute("isVaulting") == true then
                return false
            end

            if checkInterractable:GetAttribute("isRepairing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isUnhooking") == true then
                return false
            end

            if checkInterractable:GetAttribute("isHealing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isSliding") == true then
                return false
            end
        end

        return true
    end

    tapMobileParryButton = function()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end
        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")
        local guiMob = survivorMob and survivorMob:FindFirstChild("Controls") and survivorMob.Controls:FindFirstChild("Gui-mob")

        if guiMob and guiMob.Visible then
            if firesignal then
                pcall(function()
                    firesignal(guiMob.MouseButton1Down)
                    task.wait(0.01)
                    firesignal(guiMob.MouseButton1Up)
                end)
            end
        else
            pcall(function()
                if not mouse2click then
                    if mouse2press and mouse2release then
                        mouse2press()
                        task.wait(0.01)
                        mouse2release()
                        return
                    end

                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                    return
                end

                mouse2click()
            end)
        end
    end

    ExecuteParry = function()
        if _G.Ox.State.ParryCooldown then
            return
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local items = remotes and remotes:FindFirstChild("Items")
        local parryingDagger = items and items:FindFirstChild("Parrying Dagger")
        local parry = parryingDagger and parryingDagger:FindFirstChild("parry")

        if parry then
            for i = 1, 8 do
                parry:FireServer()
            end
        end

        task.spawn(tapMobileParryButton)
    end

    ParryHUD.Scan = function()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return false
        end
        table.clear(ParryHUD.gradients)
        ParryHUD.icon = nil

        for i, v4 in ipairs({"Survivor", "Survivor-con"}) do
            local v5 = playerGui2:FindFirstChild(v4)

            if v5 then
                local gen = v5:FindFirstChild("Gen")
                local itemFrame = gen and gen:FindFirstChild("ItemFrame")

                if itemFrame then
                    local gui = itemFrame:FindFirstChild("Gui")
                    local bar = gui and gui:FindFirstChild("Bar")
                    local uiGradient = bar and bar:FindFirstChild("UIGradient")

                    if uiGradient then
                        table.insert(ParryHUD.gradients, uiGradient)
                    end

                    local icon = itemFrame:FindFirstChild("icon")

                    if icon then
                        ParryHUD.icon = icon
                    end
                end
            end
        end

        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")
        local controls = survivorMob and survivorMob:FindFirstChild("Controls")

        if controls then
            for i, child in ipairs(controls:GetChildren()) do
                if child:IsA("ImageButton") and child.Name == "Gui-mob" then
                    local bar = child:FindFirstChild("Bar")
                    local uiGradient = bar and bar:FindFirstChild("UIGradient")

                    if uiGradient then
                        table.insert(ParryHUD.gradients, uiGradient)
                    end
                end
            end
        end

        local flag2 = #ParryHUD.gradients > 0 or ParryHUD.icon ~= nil
        return flag2
    end

    ParryHUD.SetColor = function(cachedIconColor)
        if #ParryHUD.gradients == 0 and not ParryHUD.icon then
            ParryHUD.Scan()
        end

        ParryHUD.cachedIconColor = cachedIconColor

        for i, gradient in ipairs(ParryHUD.gradients) do
            if gradient and gradient.Parent and gradient.Parent.Parent then
                local icon = gradient.Parent.Parent:FindFirstChild("icon")

                if icon then
                    icon.ImageColor3 = cachedIconColor
                end

                local gui = gradient.Parent.Parent:FindFirstChild("Gui")

                if gui then
                    gui.ImageColor3 = cachedIconColor
                end
            end
        end

        if ParryHUD.icon then
            ParryHUD.icon.ImageColor3 = cachedIconColor
        end
    end

    ParryHUD.Tween = function(arg)
        if #ParryHUD.gradients == 0 then
            ParryHUD.Scan()
        end

        for i, gradient in ipairs(ParryHUD.gradients) do
            if gradient and gradient.Parent then
                gradient.Offset = Vector2.new(0, 0.75)
                local tween = TweenService:Create(gradient, TweenInfo.new(arg, Enum.EasingStyle.Linear), {Offset = Vector2.new(0, 0.25)})
                tween:Play()

                tween.Completed:Connect(function()
                    if not _G.Ox.State.ParryCooldown then
                        ParryHUD.SetColor(Color3.fromRGB(255, 255, 255))
                    end
                end)
            end
        end
    end

    ParryHUD.Reset = function()
        ParryHUD.SetColor(Color3.fromRGB(255, 255, 255))

        for i, gradient in ipairs(ParryHUD.gradients) do
            if gradient and gradient.Parent then
                gradient.Offset = Vector2.new(0, 0.25)
            end
        end
    end

    ParryHUD.SetupWatcher = function()
        if ParryHUD.rescanConn then
            ParryHUD.rescanConn:Disconnect()
        end

        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end

        ParryHUD.rescanConn = playerGui2.ChildAdded:Connect(function(child)
            local name = child.Name

            if name == "Survivor" or name == "Survivor-con" or name == "Survivor-mob" then
                task.wait(0.3)
                ParryHUD.Scan()

                if _G.Ox.State.ParryCooldown and ParryHUD.cachedIconColor then
                    ParryHUD.SetColor(ParryHUD.cachedIconColor)
                end
            end
        end)

        task.spawn(function()
            local n = 0

            while n < 10 and not ParryHUD.Scan() do
                task.wait(0.5)
                n = n + 0.5
            end
        end)
    end

    ParryHUD.SetupWatcher()

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)
        ParryHUD.Scan()

        if _G.Ox.State.ParryCooldown and ParryHUD.cachedIconColor then
            ParryHUD.SetColor(ParryHUD.cachedIconColor)
        end
    end)

    ListenToParryResult = function()
        task.spawn(function()
            local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
            local parryingDagger = remotes and remotes:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
            local parryResult = parryingDagger and parryingDagger:WaitForChild("parryResult", 5)

            if parryResult then
                parryResult.OnClientEvent:Connect(function(arg, arg2)
                    local num = tonumber(arg2)
                    local n = num or (arg == true and 90 or 60)
                    _G.Ox.State.ParryCooldown = true

                    if _G.Ox.State.ParryCooldownThread then
                        task.cancel(_G.Ox.State.ParryCooldownThread)
                    end

                    ParryHUD.SetColor(Color3.fromRGB(77, 77, 77))
                    ParryHUD.Tween(n)

                    _G.Ox.State.ParryCooldownThread = task.delay(n, function()
                        _G.Ox.State.ParryCooldown = false
                        ParryHUD.SetColor(Color3.fromRGB(255, 255, 255))
                    end)
                end)
            end
        end)
    end

    ListenToParryResult()

    IsInKillerPOV = function(arg, arg2, arg3)
        if not arg or not arg2 then
            return false
        end
        local n = arg2.Position - arg.Position
        local vector = Vector3.new(n.X, 0, n.Z)
        if vector.Magnitude < 0.15 then
            return true
        end
        local vector2 = Vector3.new(arg.CFrame.LookVector.X, 0, arg.CFrame.LookVector.Z)
        if vector2.Magnitude < 0.05 then
            return false
        end
        local v4 = vector2.Unit:Dot(vector.Unit)
        local n2 = arg3 or 0.35
        local flag2 = n2 <= v4
        return flag2
    end

    AttachParrySensor = function(arg)
        if not arg or _G.Ox.AttachedParry[arg] then
            return
        end
        _G.Ox.AttachedParry[arg] = true
        local humanoid = arg:WaitForChild("Humanoid", 5)
        if not humanoid then
            return
        end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        local animator2 = animator or humanoid:WaitForChild("Animator", 5)
        if not animator2 then
            return
        end

        humanoid.ChildAdded:Connect(function(child)
            if child:IsA("Animator") then
                _G.Ox.AttachedParry[arg] = nil
                AttachParrySensor(arg)
            end
        end)

        arg.AncestryChanged:Connect(function(child, parent)
            if not parent then
                _G.Ox.AttachedParry[arg] = nil
            end
        end)

        animator2.AnimationPlayed:Connect(function(arg2)
            local animation = arg2.Animation
            local animationId = animation and arg2.Animation.AnimationId or ""
            local match = animationId:match("%d+")
            local v4 = tbl5[match]
            if not v4 then
                return
            end

            if match == "80411309607666" and _G.Ox.ParryConfig.AutoCrouch then
                local character = localPlayer.Character
                if IsDowned(character) then
                    return
                end
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart and humanoidRootPart2 and (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= 40 then
                    TriggerCrouch()
                end

                return
            end

            if not _G.Ox.ParryConfig.AutoParry then
                return
            end

            if _G.Ox.State.ParryCooldown then
                return
            end

            if _G.Ox.ParryConfig.Ignored_Skills and _G.Ox.ParryConfig.Ignored_Skills[v4] then
                return
            end
            local character = localPlayer.Character
            if IsDowned(character) or not IsSafeToParry(character) then
                return
            end
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart or not humanoidRootPart2 then
                return
            end
            local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
            local parryFace = _G.Ox.ParryConfig.ParryFace

            if parryFace < 0.2 then
                parryFace = 0.35
            end

            if _G.Ox.ParryConfig.ParryAggressive then
                if _G.Ox.ParryConfig.ParryRadius + 5 < magnitude then
                    return
                end

                local function fn12()
                    if _G.Ox.State.ParryCooldown or IsDowned(character) then
                        return true
                    end

                    if not humanoidRootPart or not humanoidRootPart2 or not humanoidRootPart.Parent or not humanoidRootPart2.Parent then
                        return true
                    end

                    if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > 12 or not IsInKillerPOV(humanoidRootPart2, humanoidRootPart, parryFace) then
                        return false
                    end
                    ExecuteParry()
                    return true
                end

                if fn12() then
                    return
                end
                local connection = nil
                local now = os.clock()

                connection = RunService.Heartbeat:Connect(function()
                    if (os.clock() - now >= 0.85 or fn12()) and connection then
                        connection:Disconnect()
                    end
                end)
            else
                local n = _G.Ox.ParryConfig.ParryRadius + 2
                if _G.Ox.ParryConfig.ParryRadius + 6 < magnitude then
                    return
                end

                if magnitude <= n and IsInKillerPOV(humanoidRootPart2, humanoidRootPart, parryFace) then
                    ExecuteParry()
                    return
                end
                local now = os.clock()
                local connection = nil

                connection = RunService.Heartbeat:Connect(function()
                    if os.clock() - now < 0.28 and not _G.Ox.State.ParryCooldown and humanoidRootPart and humanoidRootPart2 and humanoidRootPart.Parent and humanoidRootPart2.Parent and not IsDowned(character) then
                        if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= n and IsInKillerPOV(humanoidRootPart2, humanoidRootPart, parryFace) then
                            ExecuteParry()

                            if connection then
                                connection:Disconnect()
                            end
                        end

                        return
                    end

                    if connection then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end

    TryAttachParry = function(arg)
        if arg ~= localPlayer and IsKiller(arg) and arg.Character then
            AttachParrySensor(arg.Character)
        end
    end

    SetupPlayerParry = function(arg)
        if arg == localPlayer then
            return
        end

        arg.CharacterAdded:Connect(function()
            TryAttachParry(arg)
        end)

        arg:GetPropertyChangedSignal("Team"):Connect(function()
            TryAttachParry(arg)
        end)

        if arg.Character then
            TryAttachParry(arg)
        end
    end

    for i, player in ipairs(Players:GetPlayers()) do
        SetupPlayerParry(player)
    end

    Players.PlayerAdded:Connect(SetupPlayerParry)

    V2_HasParryingDagger = function()
        local character = localPlayer.Character
        if not character then
            return false
        end

        if character:FindFirstChild("Parrying Dagger") then
            return true
        end

        for i, child in ipairs(character:GetChildren()) do
            if child.Name == "Parrying Dagger" and (child:IsA("Tool") or child:IsA("Accessory") or child:IsA("Model")) then
                return true
            end
        end

        return false
    end

    V2_IsBusy = function()
        local character = localPlayer.Character
        if not character then
            return true
        end

        if localPlayer:GetAttribute("IsDead") then
            return true
        end

        if character:GetAttribute("IsCarried") then
            return true
        end

        if character:GetAttribute("IsHooked") then
            return true
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart and CollectionService:HasTag(humanoidRootPart, "doing action") then
            return true
        end

        if IsDowned(character) then
            return true
        end
        local checkInterractable = character:FindFirstChild("CheckInterractable")

        if checkInterractable then
            if checkInterractable:GetAttribute("isVaulting") then
                return true
            end

            if checkInterractable:GetAttribute("isSliding") then
                return true
            end

            if checkInterractable:GetAttribute("isDroppingPallet") then
                return true
            end

            if checkInterractable:GetAttribute("isRepairing") then
                return true
            end

            if checkInterractable:GetAttribute("isHealing") then
                return true
            end

            if checkInterractable:GetAttribute("isUnhooking") then
                return true
            end

            if checkInterractable:GetAttribute("isExiting") then
                return true
            end
        end

        return false
    end

    V2_IsLowHealth = function()
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return true
        end
        local flag2 = humanoid.Health < humanoid.MaxHealth * 0.5
        return flag2
    end

    V2_CanParry = function()
        local parryV2 = _G.Ox.ParryV2
        if not parryV2.Enabled then
            return false
        end

        if not V2_HasParryingDagger() then
            return false
        end

        if parryV2.IsOnCooldown then
            return false
        end

        if parryV2.IsResolving then
            return false
        end

        if parryV2.SafetyParry and V2_IsBusy() then
            return false
        end

        if not V2_IsLowHealth() then
            return true
        end
        return false
    end

    V2_HasLOS = function(arg)
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoidRootPart2 = arg and arg:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart or not humanoidRootPart2 then
            return false
        end
        local position = humanoidRootPart2.Position
        local n = humanoidRootPart.Position - position
        local magnitude = n.Magnitude
        if magnitude < 0.1 then
            return true
        end
        _G.Ox._V2RayParams.FilterDescendantsInstances = {arg, character}
        local flag2

        if workspace:Raycast(position, n.Unit * magnitude, _G.Ox._V2RayParams) then
            flag2 = false
        else
            flag2 = true
        end

        return flag2
    end

    V2_IsBtnValid = function(arg)
        if not arg or not arg.Parent then
            return false
        end

        local ok, result = pcall(function()
            if not arg:IsA("GuiButton") and not arg:IsA("ImageButton") and not arg:IsA("TextButton") then
                return false
            end

            if arg.Visible == false then
                return false
            end

            if arg.AbsoluteSize.X < 4 or arg.AbsoluteSize.Y < 4 then
                return false
            end
            local parent = arg.Parent
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

            while parent and parent ~= playerGui2 do
                if parent:IsA("GuiObject") and parent.Visible == false then
                    return false
                end
                parent = parent.Parent
            end

            return true
        end)

        local flag2 = ok and result == true
        return flag2
    end

    V2_FindParryButton = function()
        local parryV2 = _G.Ox.ParryV2
        if parryV2.BtnCache and V2_IsBtnValid(parryV2.BtnCache) then
            return parryV2.BtnCache
        end
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return nil
        end

        local v4, v5, v6 = ipairs({
            {"Survivor-mob", "Controls", "Gui-mob"},
            {"SurvivorMob", "Controls", "GuiMob"},
            {"Survivor-mob", "Controls", "GuiMob"},
        })

        local v7 = v6
        local v8 = v4
        local v9 = v5

        while true do
            local v10, v11 = v8(v9, v7)
            if v10 == nil then
                break
            end
            local v12 = playerGui2

            for i, v13 in ipairs(v11) do
                local v14 = v12 and v12:FindFirstChild(v13)
                v12 = v14
            end

            v7 = v10
            if v12 and V2_IsBtnValid(v12) then
                parryV2.BtnCache = v12
                return v12
            end
        end

        return nil
    end

    V2_TriggerByButton = function()
        local v4 = V2_FindParryButton()

        if not v4 then
            pcall(function()
                local mouseLocation = UserInputService:GetMouseLocation()
                VirtualInputManager:SendMouseButtonEvent(mouseLocation.X, mouseLocation.Y, 1, true, game, 0)

                task.delay(0.06, function()
                    local mouseLocation2 = UserInputService:GetMouseLocation()
                    VirtualInputManager:SendMouseButtonEvent(mouseLocation2.X, mouseLocation2.Y, 1, false, game, 0)
                end)
            end)

            return false
        end

        pcall(function()
            if type(firesignal) == "function" then
                firesignal(v4.MouseButton1Down)

                task.delay(0.06, function()
                    pcall(function()
                        firesignal(v4.MouseButton1Up)

                        if v4.MouseButton1Click then
                            firesignal(v4.MouseButton1Click)
                        end
                    end)
                end)
            else
                local absolutePosition = v4.AbsolutePosition
                local absoluteSize = v4.AbsoluteSize
                local guiInset = GuiService:GetGuiInset()
                local n = absolutePosition.X + absoluteSize.X / 2 + guiInset.X
                local n2 = absolutePosition.Y + absoluteSize.Y / 2 + guiInset.Y
                local n3 = 9901 + math.random(1, 400)
                VirtualInputManager:SendTouchEvent(n3, 0, n, n2)

                task.delay(0.06, function()
                    pcall(function()
                        VirtualInputManager:SendTouchEvent(n3, 2, n, n2)
                    end)
                end)
            end
        end)

        return true
    end

    V2_SetIconsColor = function(imageColor3)
        local parryV2 = _G.Ox.ParryV2

        if #parryV2.Gradients == 0 then
            if ParryHUD and ParryHUD.Scan then
                ParryHUD.Scan()
            end

            local v4 = ParryHUD
            local gradients = v4 and ParryHUD.gradients or {}
            parryV2.Gradients = gradients
            local v5 = ParryHUD
            local icon = v5 and ParryHUD.icon or nil
            parryV2.Icon = icon
        end

        for i, gradient in ipairs(parryV2.Gradients) do
            if gradient and gradient.Parent and gradient.Parent.Parent then
                local icon = gradient.Parent.Parent:FindFirstChild("icon")

                if icon then
                    icon.ImageColor3 = imageColor3
                end

                local gui = gradient.Parent.Parent:FindFirstChild("Gui")

                if gui then
                    gui.ImageColor3 = imageColor3
                end
            end
        end

        if parryV2.Icon then
            parryV2.Icon.ImageColor3 = imageColor3
        end
    end

    V2_PlayCooldownTween = function(arg)
        local parryV2 = _G.Ox.ParryV2

        if #parryV2.Gradients == 0 then
            if ParryHUD and ParryHUD.Scan then
                ParryHUD.Scan()
            end

            local v4 = ParryHUD
            local gradients = v4 and ParryHUD.gradients or {}
            parryV2.Gradients = gradients
        end

        for i, gradient in ipairs(parryV2.Gradients) do
            if gradient and gradient.Parent then
                gradient.Offset = Vector2.new(0, 0.75)
                local tween = TweenService:Create(gradient, TweenInfo.new(arg, Enum.EasingStyle.Linear), {Offset = Vector2.new(0, 0.25)})
                tween:Play()

                tween.Completed:Connect(function()
                    if not parryV2.IsOnCooldown then
                        V2_SetIconsColor(Color3.fromRGB(255, 255, 255))
                    end
                end)
            end
        end
    end

    V2_StartCooldown = function(arg)
        local parryV2 = _G.Ox.ParryV2
        parryV2.CooldownToken = parryV2.CooldownToken + 1
        local cooldownToken = parryV2.CooldownToken
        parryV2.IsResolving = false
        parryV2.IsOnCooldown = true
        V2_SetIconsColor(Color3.fromRGB(77, 77, 77))
        V2_PlayCooldownTween(arg)

        if parryV2.CooldownThread then
            task.cancel(parryV2.CooldownThread)
        end

        parryV2.CooldownThread = task.delay(arg, function()
            if parryV2.CooldownToken == cooldownToken then
                parryV2.IsOnCooldown = false
                V2_SetIconsColor(Color3.fromRGB(255, 255, 255))
                parryV2.CooldownThread = nil
            end
        end)
    end

    V2_ResetCooldown = function()
        local parryV2 = _G.Ox.ParryV2

        if parryV2.CooldownThread then
            task.cancel(parryV2.CooldownThread)
            parryV2.CooldownThread = nil
        end

        parryV2.IsOnCooldown = false
        parryV2.IsResolving = false
        V2_SetIconsColor(Color3.fromRGB(255, 255, 255))
    end

    V2_FaceLookDirection = function()
        local currentCamera2 = workspace.CurrentCamera
        if not currentCamera2 then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart or not humanoidRootPart.Parent then
            return
        end
        local character2 = localPlayer.Character
        local humanoid = character2 and localPlayer.Character:FindFirstChildOfClass("Humanoid")
        local lookVector = currentCamera2.CFrame.LookVector
        local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
        if vector.Magnitude <= 0 then
            return
        end
        local cframe = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + vector.Unit)
        TweenService:Create(humanoidRootPart, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = cframe}):Play()

        if humanoid then
            humanoid.AutoRotate = false
        end

        local parryV2 = _G.Ox.ParryV2

        if parryV2.LockConnection then
            parryV2.LockConnection:Disconnect()
        end

        local now = tick()

        parryV2.LockConnection = RunService.Heartbeat:Connect(function()
            if tick() - now >= 0.8 then
                if parryV2.LockConnection then
                    parryV2.LockConnection:Disconnect()
                    parryV2.LockConnection = nil
                end

                if humanoid then
                    humanoid.AutoRotate = true
                end

                return
            end

            if humanoidRootPart and humanoidRootPart.Parent then
                humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + vector.Unit)
            elseif parryV2.LockConnection then
                parryV2.LockConnection:Disconnect()
                parryV2.LockConnection = nil
            end
        end)
    end

    V2_MatchParrySkin = function(arg)
        if type(arg) ~= "string" or arg == "" then
            return nil
        end
        local parryV2Anim = _G.Ox.ParryV2Anim
        if not parryV2Anim then
            return nil
        end

        if parryV2Anim[arg] then
            return parryV2Anim[arg]
        end
        local str = string.lower(arg):gsub("^equippedskin[_%-]?", ""):gsub("^skin[_%-]?", ""):gsub("[_%-]?parrying[_%-]?dagger", ""):gsub("[_%-]?dagger", ""):gsub("%s+", "")

        for k, v4 in pairs(parryV2Anim) do
            local v5 = string.lower(k)
            if v5 == str or string.find(str, v5, 1, true) or string.find(v5, str, 1, true) then
                return v4
            end
        end

        return nil
    end

    V2_ScanSkinFromInstance = function(arg)
        if not arg then
            return nil
        end

        for i, v4 in ipairs({
            "EquippedSkin_Parrying_Dagger",
            "EquippedSkin_ParryingDagger",
            "EquippedSkin",
            "ParryingDaggerSkin",
            "ParrySkin",
            "Skin",
            "SkinName",
            "CurrentSkin",
            "EquippedSkinName",
        }) do
            local attribute = arg:GetAttribute(v4)
            local v5 = V2_MatchParrySkin(attribute)
            if v5 then
                return v5
            end
        end

        local ok, result = pcall(function()
            return arg:GetAttributes()
        end)

        if ok and type(result) == "table" then
            for k, v4 in pairs(result) do
                if type(k) == "string" and type(v4) == "string" then
                    local v5 = string.lower(k)
                    if not v5:find("skin") and not v5:find("parry") then
                        continue
                    end
                    local v6 = V2_MatchParrySkin(v4)
                    if v6 then
                        return v6
                    end
                end
            end
        end

        return nil
    end

    V2_ResolveAnimId = function()
        local character = localPlayer.Character

        if character then
            local v4 = V2_ScanSkinFromInstance(character)
            if v4 then
                return v4
            end
            local parryingDagger = character:FindFirstChild("Parrying Dagger")
            local parryingDagger2 = parryingDagger or character:FindFirstChild("ParryingDagger") or character:FindFirstChild("parrying dagger")

            if parryingDagger2 then
                local v5 = V2_ScanSkinFromInstance(parryingDagger2)
                if v5 then
                    return v5
                end

                for i, descendant in ipairs(parryingDagger2:GetDescendants()) do
                    if not descendant:IsA("StringValue") and (not descendant:IsA("ValueBase") or type(descendant.Value) ~= "string") then
                        continue
                    end
                    local v6 = V2_MatchParrySkin(tostring(descendant.Value))
                    if v6 then
                        return v6
                    end
                end
            end

            local backpack = localPlayer:FindFirstChild("Backpack")

            if backpack then
                local parryingDagger3 = backpack:FindFirstChild("Parrying Dagger")
                local parryingDagger4 = parryingDagger3 or backpack:FindFirstChild("ParryingDagger")

                if parryingDagger4 then
                    local v5 = V2_ScanSkinFromInstance(parryingDagger4)
                    if v5 then
                        return v5
                    end
                end
            end
        end

        local v4 = V2_ScanSkinFromInstance(localPlayer)
        if not v4 then
            return _G.Ox.ParryV2Anim.Default
        end
        return v4
    end

    V2_PlayParryAnim = function()
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end
        local parryV2 = _G.Ox.ParryV2

        if parryV2.ParryTrack then
            pcall(function()
                parryV2.ParryTrack:Stop(0.05)
            end)
        end

        pcall(function()
            local animation = Instance.new("Animation")
            animation.AnimationId = V2_ResolveAnimId()
            parryV2.ParryTrack = animator:LoadAnimation(animation)
            parryV2.ParryTrack.Priority = Enum.AnimationPriority.Action4
            parryV2.ParryTrack:Play()
        end)
    end

    V2_DoParry = function()
        if not V2_CanParry() then
            return
        end
        local parryV2 = _G.Ox.ParryV2
        parryV2.IsResolving = true
        V2_SetIconsColor(Color3.fromRGB(77, 77, 77))
        local trigger = parryV2.Trigger
        local str = trigger or "Remote"
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")

        if str == "Button" then
            V2_TriggerByButton()
        else
            local parryingDagger = remotes and remotes:FindFirstChild("Items") and remotes.Items:FindFirstChild("Parrying Dagger")
            local parry = parryingDagger and parryingDagger:FindFirstChild("parry")

            if parry then
                pcall(function()
                    parry:FireServer()
                end)
            end

            V2_FaceLookDirection()
            local character = localPlayer.Character
            local humanoid = character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.AutoRotate = false
            end

            V2_PlayParryAnim()
            local character2 = localPlayer.Character
            local humanoidRootPart = character2 and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                pcall(function()
                    CollectionService:AddTag(humanoidRootPart, "doing action")
                end)
            end

            local slow = remotes and remotes:FindFirstChild("Mechanics") and remotes.Mechanics:FindFirstChild("Slow")

            if slow then
                pcall(function()
                    slow:Fire(0, 1, 0)
                end)
            end
        end

        task.delay(2, function()
            if parryV2.IsResolving then
                parryV2.IsResolving = false
                local n = parryV2.Trigger == "Button" and 1.2 or 60
                V2_StartCooldown(n)
                local character = localPlayer.Character
                local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    pcall(function()
                        CollectionService:RemoveTag(humanoidRootPart, "doing action")
                    end)
                end
            end
        end)
    end

    task.spawn(function()
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 8)
        local items = remotes and remotes:WaitForChild("Items", 5)
        local parryingDagger = items and items:WaitForChild("Parrying Dagger", 5)
        local parryResult = parryingDagger and parryingDagger:WaitForChild("parryResult", 5)
        if not parryResult then
            return
        end

        parryResult.OnClientEvent:Connect(function(arg, arg2)
            local parryV2 = _G.Ox.ParryV2
            if not parryV2.IsResolving then
                return
            end
            parryV2.IsResolving = false
            local num = tonumber(arg2)

            if num and num > 0 then
                V2_StartCooldown(num)
            elseif arg == true then
                V2_StartCooldown(90)
            else
                V2_StartCooldown(60)
            end

            local character = localPlayer.Character
            local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                pcall(function()
                    CollectionService:RemoveTag(humanoidRootPart, "doing action")
                end)
            end
        end)
    end)

    local cylinderHandleAdornment = Instance.new("CylinderHandleAdornment")
    cylinderHandleAdornment.Name = "OXIO_ParryRange_V2"
    local range = _G.Ox.ParryV2.Range
    local radius = range or 12
    cylinderHandleAdornment.Radius = radius
    local max = math.max
    local range2 = _G.Ox.ParryV2.Range
    local n = range2 or 12
    cylinderHandleAdornment.InnerRadius = max(0.1, n - 0.15)
    cylinderHandleAdornment.Height = 0.01
    cylinderHandleAdornment.Color3 = Color3.fromRGB(80, 80, 80)
    cylinderHandleAdornment.AlwaysOnTop = false
    cylinderHandleAdornment.Transparency = 1
    cylinderHandleAdornment.Adornee = workspace:FindFirstChildOfClass("Terrain")

    pcall(function()
        cylinderHandleAdornment.Parent = CoreGui
    end)

    if not cylinderHandleAdornment.Parent then
        pcall(function()
            cylinderHandleAdornment.Parent = localPlayer:WaitForChild("PlayerGui")
        end)
    end

    _G.Ox.ParryV2.RangeAdornment = cylinderHandleAdornment

    V2_UpdateRangeCircle = function()
        local parryV2 = _G.Ox.ParryV2
        local rangeAdornment = parryV2.RangeAdornment
        if not rangeAdornment then
            return
        end

        if parryV2.Enabled and parryV2.ShowCircle then
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if not humanoidRootPart then
                if rangeAdornment.Transparency ~= 1 then
                    rangeAdornment.Transparency = 1
                end

                return
            end

            local range3 = parryV2.Range
            local v2ParryLastRadius = range3 or 12
            if humanoidRootPart == _G.Ox._V2ParryLastRoot and v2ParryLastRadius == _G.Ox._V2ParryLastRadius then
                return
            end
            _G.Ox._V2ParryLastRoot = humanoidRootPart
            _G.Ox._V2ParryLastRadius = v2ParryLastRadius
            rangeAdornment.Transparency = 0.4
            rangeAdornment.Radius = v2ParryLastRadius
            rangeAdornment.InnerRadius = math.max(0.1, v2ParryLastRadius - 0.15)
            local v2ParryRangeRay = _G.Ox._V2ParryRangeRay
            v2ParryRangeRay.FilterDescendantsInstances = {character}
            local hit = workspace:Raycast(humanoidRootPart.Position, Vector3.new(0, -15, 0), v2ParryRangeRay)
            local position = hit and hit.Position or humanoidRootPart.Position - Vector3.new(0, 3, 0)
            rangeAdornment.CFrame = CFrame.new(position + Vector3.new(0, 0.05, 0)) * CFrame.Angles(math.pi / 2, 0, 0)
            return
        end

        if rangeAdornment.Transparency ~= 1 then
            rangeAdornment.Transparency = 1
        end
    end

    V2_AttachParrySensor = function(arg)
        if not arg or _G.Ox.ParryV2.Attached[arg] then
            return
        end
        _G.Ox.ParryV2.Attached[arg] = true
        local humanoid = arg:FindFirstChild("Humanoid")
        local v4 = humanoid

        if not humanoid then
            local humanoid2 = arg:WaitForChild("Humanoid", 5)
            v4 = humanoid2
            if not humanoid2 then
                return
            end
        end

        local animator = v4:FindFirstChildOfClass("Animator")
        local v5 = animator

        if not animator then
            local animator2 = v4:WaitForChild("Animator", 5)
            v5 = animator2
            if not animator2 then
                return
            end
        end

        v4.ChildAdded:Connect(function(child)
            if child:IsA("Animator") then
                _G.Ox.ParryV2.Attached[arg] = nil
                V2_AttachParrySensor(arg)
            end
        end)

        arg.AncestryChanged:Connect(function(child, parent)
            if not parent then
                _G.Ox.ParryV2.Attached[arg] = nil
            end
        end)

        v5.AnimationPlayed:Connect(function(arg2)
            local animation = arg2.Animation
            local animationId = animation and arg2.Animation.AnimationId or ""
            if not _G.Ox.ParryV2AttackAnims[animationId] then
                return
            end
            local parryV2 = _G.Ox.ParryV2
            if not parryV2.Enabled then
                return
            end

            if not V2_HasParryingDagger() then
                return
            end

            if parryV2.IsOnCooldown or parryV2.IsResolving then
                return
            end
            local character = localPlayer.Character
            if not character then
                return
            end
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoidRootPart2 = arg:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart or not humanoidRootPart2 then
                return
            end
            local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
            local mode = parryV2.Mode
            local str = mode or "Legit"
            local range3 = parryV2.Range
            local n2 = range3 or 12

            if str == "Aggressive" then
                if n2 + 3 < magnitude then
                    return
                end
                local num = tonumber(parryV2.KillerFace)
                local n3 = num or 0.6
                local n4 = math.clamp(n3, -1, 1)

                local function fn12()
                    local n5 = humanoidRootPart.Position - humanoidRootPart2.Position
                    local vector = Vector3.new(n5.X, 0, n5.Z)
                    if vector.Magnitude < 0.05 then
                        return true
                    end
                    local vector2 = Vector3.new(humanoidRootPart2.CFrame.LookVector.X, 0, humanoidRootPart2.CFrame.LookVector.Z)
                    if vector2.Magnitude < 0.05 then
                        return false
                    end
                    local v6 = vector2.Unit:Dot(vector.Unit)
                    local flag2 = n4 <= v6
                    return flag2
                end

                local function fn13()
                    if parryV2.IsOnCooldown or parryV2.IsResolving or not humanoidRootPart or not humanoidRootPart2 or not humanoidRootPart.Parent or not humanoidRootPart2.Parent then
                        return true
                    end

                    if (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > n2 or not fn12() then
                        return false
                    end
                    V2_DoParry()
                    return true
                end

                if fn13() then
                    return
                end
                local connection = nil
                local now = os.clock()

                connection = RunService.Heartbeat:Connect(function()
                    if (os.clock() - now >= 1.5 or fn13()) and connection then
                        connection:Disconnect()
                    end
                end)
            else
                if n2 < magnitude then
                    return
                end

                if not V2_HasLOS(arg) then
                    return
                end
                local n3 = Vector3.new(humanoidRootPart.Position.X, 0, humanoidRootPart.Position.Z) - Vector3.new(humanoidRootPart2.Position.X, 0, humanoidRootPart2.Position.Z)

                if n3.Magnitude > 0 then
                    local unit = n3.Unit
                    local vector = Vector3.new(humanoidRootPart2.CFrame.LookVector.X, 0, humanoidRootPart2.CFrame.LookVector.Z)

                    if vector.Magnitude > 0 then
                        local unit2 = vector.Unit
                        local num = tonumber(parryV2.KillerFace)
                        local n4 = num or 0.6
                        local n5 = math.clamp(n4, -1, 1)
                        if unit2:Dot(unit) < n5 then
                            return
                        end
                    end

                    if str == "Strict" then
                        local currentCamera2 = workspace.CurrentCamera
                        local vector2 = nil

                        if currentCamera2 then
                            vector2 = Vector3.new(currentCamera2.CFrame.LookVector.X, 0, currentCamera2.CFrame.LookVector.Z)
                        end

                        if not vector2 or vector2.Magnitude < 0.05 then
                            vector2 = Vector3.new(humanoidRootPart.CFrame.LookVector.X, 0, humanoidRootPart.CFrame.LookVector.Z)
                        end

                        if vector2.Magnitude > 0 and vector2.Unit:Dot(-unit) < 0.5 then
                            return
                        end
                    end
                end

                V2_DoParry()
            end
        end)
    end

    V2_TryAttach = function(arg)
        if arg ~= localPlayer and arg.Team and arg.Team.Name == "Killer" and arg.Character then
            V2_AttachParrySensor(arg.Character)
        end
    end

    V2_SetupPlayer = function(arg)
        if arg == localPlayer then
            return
        end

        arg.CharacterAdded:Connect(function()
            V2_TryAttach(arg)
        end)

        arg:GetPropertyChangedSignal("Team"):Connect(function()
            V2_TryAttach(arg)
        end)

        if arg.Character then
            V2_TryAttach(arg)
        end
    end

    for k, player in pairs(Players:GetPlayers()) do
        V2_SetupPlayer(player)
    end

    Players.PlayerAdded:Connect(V2_SetupPlayer)

    RunService.Heartbeat:Connect(function()
        if _G.Ox.ParryV2 and _G.Ox.ParryV2.Enabled and _G.Ox.ParryV2.ShowCircle then
            _G.Ox._V2ParryLastRoot = nil
            V2_UpdateRangeCircle()
        elseif _G.Ox.ParryV2 and _G.Ox.ParryV2.RangeAdornment and _G.Ox.ParryV2.RangeAdornment.Transparency ~= 1 then
            _G.Ox.ParryV2.RangeAdornment.Transparency = 1
        end
    end)

    UpdateCustomParryGUI = function(arg)
        if not _G.Ox.AutoParryCustom.Gui then
            return
        end
        local frame = _G.Ox.AutoParryCustom.Gui:FindFirstChild("Frame")
        if not frame then
            return
        end
        local actionButton = frame:FindFirstChild("ActionButton")
        local uiStroke = frame:FindFirstChild("UIStroke")

        if arg then
            if actionButton then
                actionButton.Text = "PARRY [ON]"
                actionButton.TextColor3 = Color3.fromRGB(180, 255, 180)
                actionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end

            if uiStroke then
                uiStroke.Color = Color3.fromRGB(100, 200, 100)
            end
        else
            if actionButton then
                actionButton.Text = "PARRY [OFF]"
                actionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                actionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            end

            if uiStroke then
                uiStroke.Color = Color3.fromRGB(90, 90, 95)
            end
        end
    end

    ToggleParryStatus = function()
        local parryConfig = _G.Ox.ParryConfig
        local autoParry

        if _G.Ox.ParryConfig.AutoParry then
            autoParry = false
        else
            autoParry = true
        end

        parryConfig.AutoParry = autoParry
        _G.Ox.AutoParryCustom.IsActive = _G.Ox.ParryConfig.AutoParry
        UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)
        local notify = lib.Notify
        local tbl6 = {Title = "Auto Parry"}
        local autoParry2 = _G.Ox.ParryConfig.AutoParry
        local description = autoParry2 and "Aktif" or "Nonaktif"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    CreateCustomParryGUI = function()
        if _G.Ox.AutoParryCustom.Gui then
            _G.Ox.AutoParryCustom.Gui:Destroy()
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AutoParryCustomGui"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = CoreGui
        screenGui.Enabled = false
        _G.Ox.AutoParryCustom.Gui = screenGui
        _G.Ox.AutoParryCustom.GuiVisible = false
        local frame = Instance.new("Frame", screenGui)
        frame.Name = "Frame"
        frame.Size = UDim2.fromOffset(110, 36)
        frame.Position = UDim2.fromScale(0.85, 0.35)
        frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        frame.BackgroundTransparency = 0.1
        frame.Active = true
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local uiStroke = Instance.new("UIStroke", frame)
        uiStroke.Name = "UIStroke"
        uiStroke.Color = Color3.fromRGB(90, 90, 95)
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.2
        local textButton = Instance.new("TextButton", frame)
        textButton.Name = "ActionButton"
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.Text = "PARRY [OFF]"
        textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 12
        textButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        textButton.BorderSizePixel = 0
        textButton.AutoButtonColor = false
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
        local flag2 = false
        local flag3 = false
        local flag4 = false
        local position = nil
        local position2 = nil
        local thread = nil

        update = function(arg)
            if not flag2 or not flag4 or not position or not position2 then
                return
            end
            local n2 = arg.Position - position

            if not flag3 and (math.abs(n2.X) > 18 or math.abs(n2.Y) > 18) then
                flag3 = true
            end

            if flag3 then
                frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n2.X, position2.Y.Scale, position2.Y.Offset + n2.Y)
            end
        end

        textButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag2 = true
                flag3 = false
                flag4 = false
                position = input.Position
                position2 = frame.Position

                if thread then
                    task.cancel(thread)
                end

                thread = task.delay(0.18, function()
                    if flag2 then
                        flag4 = true
                    end
                end)
            end
        end)

        textButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if thread then
                    task.cancel(thread)
                end

                if flag2 and not flag3 then
                    ToggleParryStatus()
                end

                flag2 = false
                flag3 = false
                flag4 = false
                position = nil
                position2 = nil
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag2 and flag4 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)

        if _G.Ox.AutoParryCustom._statusConn then
            _G.Ox.AutoParryCustom._statusConn:Disconnect()
        end

        _G.Ox.AutoParryCustom._statusConn = RunService.Heartbeat:Connect(function()
            if _G.Ox.AutoParryCustom.Gui and _G.Ox.AutoParryCustom.Gui.Parent then
                if _G.Ox.AutoParryCustom.IsActive ~= _G.Ox.ParryConfig.AutoParry then
                    _G.Ox.AutoParryCustom.IsActive = _G.Ox.ParryConfig.AutoParry
                    UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)
                end

                return
            end

            if _G.Ox.AutoParryCustom._statusConn then
                _G.Ox.AutoParryCustom._statusConn:Disconnect()
            end
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.AutoParryCustom.GuiVisible and _G.Ox.AutoParryCustom.Gui then
            _G.Ox.AutoParryCustom.Gui.Enabled = true
            UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)
        end
    end)

    task.spawn(function()
        task.wait(1.5)
        CreateCustomParryGUI()
    end)

    _G.Ox.InstantTPGate = {
        Enabled = false,
        GateClientModule = nil,
        oldGateNew = nil,
        oldGateCanUse = nil,
    }

    _G.Ox.KorlessMorph = {Enabled = false, Connection = nil}
    _G.Ox.SelfHeal = {Enabled = false}
    _G.Ox.FlowstateNoCD = {Enabled = false, Connection = nil, CharAddedConn = nil}
    _G.Ox.NoFall = {Enabled = false}
    _G.Ox.BulletBlockConfig = {Enabled = false}
    _G.Ox.BypassGate = {Enabled = false}
    _G.Ox.NextKiller = {Enabled = false, IndicatorGui = nil}

    _G.Ox.CounterParry = {
        Enabled = false,
        Distance = 15,
        Interval = 0.3,
        AnimId = "rbxassetid://117042998468241",
        Thread = nil,
        Track = nil,
    }

    _G.Ox.AutoStalk = {Enabled = false, Range = 150, Conn = nil, LastFire = 0}

    _G.Ox.Crosshair = {
        Enabled = false,
        Size = 8,
        Thickness = 2,
        Color = Color3.fromRGB(255, 255, 255),
        Style = "Dot",
        OffsetX = 0,
        OffsetY = 0,
    }

    _G.Ox.Spectator = {Enabled = false, Gui = nil, Label = nil}

    _G.Ox.Moonwalk = {
        Enabled = false,
        GuiVisible = false,
        Gui = nil,
        IsActive = false,
    }

    _G.Ox.CrosshairGui = nil
    _G.Ox.CrosshairElements = {}
    _G.Ox.CrosshairCreated = false
    _G.Ox.LastCrosshairStyle = nil
    local ox2 = _G.Ox
    local config = _G.Ox.Config
    local config2 = config or {}
    ox2.Config = config2
    _G.Ox.Config.Surv_PerfectVault = false
    _G.Ox.autoVaultEnabled = false
    _G.Ox.autoPalletSlideEnabled = false
    _G.Ox.lastActionTime = 0
    _G.Ox.COOLDOWN = 1.5
    _G.Ox.StreamerMode = {Enabled = false, SpooferConns = {}}
    _G.Ox.InfinityZoom = {Enabled = false}
    _G.Ox.StretchRes = {Enabled = false, Amount = 0.67, Conn = nil}
    _G.Ox.CameraFOV = {Enabled = false, Value = 90, Connection = nil}
    _G.Ox.Auto = {SkillCheck = false, SkillCheckMode = "Legit"}
    _G.Ox.MapPredict = {Enabled = false}
    _G.Ox.KillerPerks = {Enabled = false, Gui = nil, Minimized = false}

    _G.Ox.Stun = {
        Enabled = false,
        Data = {},
        HitSoundEnabled = false,
        HitSoundVolume = 1,
        HitSoundId = "rbxassetid://106225491596534",
        HitSoundCooldown = 0.3,
        HitSoundLastTime = 0,
    }

    _G.Ox.GodMode = false
    _G.Ox.BypassGenEnabled = false
    _G.Ox.BypassGenMode = "Manual Repair"
    _G.Ox.RepairAnimTrack = nil
    _G.Ox.ProcessedGens = {}
    _G.Ox.AutoRepairEnabled = false
    _G.Ox.AutoRepairThread = nil
    _G.Ox.AutoCurrentPoint = nil
    _G.Ox.AutoCurrentGenModel = nil
    _G.Ox.LastFireTime = 0
    _G.Ox.AutoFireInterval = 0.5
    _G.Ox.ScriptAlive = true
    _G.Ox.BypassToggleValue = false
    _G.Ox.UnlimitedVaultEnabled = false
    local ox3 = _G.Ox
    local state = _G.Ox.State
    local state2 = state or {}
    ox3.State = state2
    _G.Ox.State.busy = false
    _G.Ox.State.RandomMode_IsNormal = false
    _G.Ox.Connections = {SkillHeartbeat = nil}
    _G.Ox.Speed = {Enabled = false, Value = 0.1, Connection = nil, Loop = nil}
    _G.Ox.AutoRun = {PC = false, Mobile = false, MobileThread = nil}

    _G.Ox.Utility = {
        InvisEnabled = false,
        BandageEnabled = false,
        BandageSpeed = 50,
    }

    _G.Ox.AntiHook = {
        Enabled = false,
        OffsetY = -250,
        Hz = 44,
        Interval = 0.022727272727272728,
        Remote = nil,
        Connection = nil,
        Accumulator = 0,
        SendCounter = 0,
        LastCounterTime = os.clock(),
    }

    _G.Ox.ConfigData = {Surv_SkillFrequency = 10, Surv_SkillSpeed = 1}

    _G.Ox.Teleport = {
        GenIndex = 1,
        HookIndex = 1,
        GateIndex = 1,
        PalletIndex = 1,
        WindowIndex = 1,
    }

    tbl = {
        Generators = {},
        Hooks = {},
        Gates = {},
        Pallets = {},
        Windows = {},
    }

    tbl2 = {Enabled = false, Conn = nil}

    if not _G.Ox.State then
        _G.Ox.State = {}
    end

    _G.Ox.State.ThirdPersonConn = nil

    tbl3 = {
        ["Left Arm"] = true,
        ["Right Arm"] = true,
        LeftHand = true,
        RightHand = true,
        LeftLowerArm = true,
        RightLowerArm = true,
        LeftUpperArm = true,
        RightUpperArm = true,
    }

    _G.Ox.FakePerks = {
        QuickRecoveryEnabled = false,
        PerfectLandingEnabled = false,
        FlowstateEnabled = false,
        FakeAdrenalineRush = false,
        PerkCooldown = 10,
        boostActive = false,
        perfectLandingBoostActive = false,
        fsOnCooldown = false,
        lastQRTime = 0,
        lastPLTime = 0,
        lastFSTime = 0,
        qrConnection = nil,
        plConnection = nil,
        fsConnection = nil,
        fsAnimConnection = nil,
        adrenalineOn = false,
        adrenalineConns = {},
        lastARTime = 0,
    }

    _G.Ox.AutoPallet = {
        Enabled = false,
        Safety = true,
        Distance = 10,
        Cooldown = 2.5,
        LastDrop = 0,
        UsedPallets = {},
        Connection = nil,
    }

    _G.Ox.FullBright = false
    _G.Ox.NoFog = false
    _G.Ox.NoShadow = false
    _G.Ox.TimeOfDayValue = 14

    _G.Ox.LowGFX = {
        Enabled = false,
        Textures = true,
        VisualEffects = true,
        Particles = true,
        Parts = true,
        Sky = false,
        Saved = {},
    }

    _G.Ox.AimConfig = {
        Aim_SilentVeilV2 = false,
        Veil_ShowFOV = true,
        SpearSmart_enable = false,
        Veil_FOV = 150,
        SPEAR_Speed = 165,
        SPEAR_Gravity = 103,
        SPEAR_AuraSpeed = 165,
        SPEAR_AuraGravity = 96.5,
        SPEAR_MaxDist = 500,
        Veil_LeadMultiplier = 1.4,
        AIM_TargetPart = "Torso",
        Pistol_BlockKnocked = false,
        LockAim = false,
        Flash_Silent = false,
        Flash_YOffset = 1.5,
    }

    _G.Ox.SurvivorFOVFrame = nil
    _G.Ox.SurvivorFOVGui = nil
    _G.Ox.isAimbotHolding = false
    _G.Ox.lockedAimbotTarget = nil
    _G.Ox.survivorAimbotHighlight = nil
    _G.Ox.isKillerAimbotHolding = false
    _G.Ox.lockedKillerAimbotTarget = nil
    _G.Ox.killerAimbotHighlight = nil

    _G.Ox.Config = {
        SpearSmart_enable = false,
        Surv_Aimbot_Enabled = false,
        Surv_Aimbot_ShowFOV = true,
        Surv_Aimbot_Radius = 150,
        Surv_Aimbot_MaxDist = 300,
        Surv_Aimbot_Smoothness = 0.5,
        Surv_Aimbot_Predict = 0.01,
        Killer_Aimbot_Enabled = false,
        Killer_Aimbot_MaxDist = 12,
        Killer_Aimbot_Smoothness = 0.5,
    }

    local flag2 = false
    local flag3 = false
    flag = false

    _G.Ox.ESPConfig = {
        Master = false,
        Player = false,
        Killer = false,
        Outline = false,
        Name = false,
        Distance = false,
        KillerWarn = false,
        ItemIcon = false,
        Generator = false,
        GeneratorName = true,
        Pallet = false,
        Hook = false,
        Gate = false,
        Window = false,
        SCP = false,
        HookCount = false,
        Status = false,
        MaxDistance = 1000,
    }

    _G.Ox.ESPColors = {
        Player = Color3.fromRGB(60, 255, 60),
        Killer = Color3.fromRGB(255, 60, 60),
        Generator = Color3.fromRGB(255, 255, 0),
        GeneratorDone = Color3.fromRGB(0, 255, 0),
        Pallet = Color3.fromRGB(60, 255, 255),
        Hook = Color3.fromRGB(255, 105, 180),
        Gate = Color3.fromRGB(255, 255, 255),
        Window = Color3.fromRGB(60, 255, 255),
        SCP = Color3.fromRGB(255, 0, 255),
        Injured = Color3.fromRGB(255, 140, 0),
        Downed = Color3.fromRGB(255, 40, 40),
        Hooked = Color3.fromRGB(240, 240, 255),
    }

    tbl4 = {
        Generators = {},
        Windows = {},
        Pallets = {},
        Hooks = {},
        Gates = {},
        SCPs = {},
    }

    GetRole = function()
        if not localPlayer.Team then
            return "Unknown"
        end
        local name = localPlayer.Team.Name
        if name == "Killer" then
            return "Killer"
        end

        if name == "Survivors" then
            return "Survivor"
        end
        return "Spectator"
    end

    GetDistance = function(arg)
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return math.huge
        end
        return (arg - humanoidRootPart.Position).Magnitude
    end

    fn = function(arg, arg2)
        if arg and type(arg.SetValue) == "function" then
            pcall(function()
                arg:SetValue(arg2)
            end)
        end
    end

    ClearCrosshair = function()
        if _G.Ox.CrosshairGui then
            _G.Ox.CrosshairGui:Destroy()
            _G.Ox.CrosshairGui = nil
        end

        _G.Ox.CrosshairElements = {}
        _G.Ox.CrosshairCreated = false
        _G.Ox.LastCrosshairStyle = nil
    end

    DrawCrosshair = function()
        if not _G.Ox.Crosshair.Enabled then
            if _G.Ox.CrosshairGui then
                _G.Ox.CrosshairGui.Enabled = false
            end

            return
        end

        if _G.Ox.CrosshairGui then
            _G.Ox.CrosshairGui.Enabled = true
        end

        if _G.Ox.LastCrosshairStyle ~= _G.Ox.Crosshair.Style or not _G.Ox.CrosshairGui then
            ClearCrosshair()
            _G.Ox.LastCrosshairStyle = _G.Ox.Crosshair.Style
        end

        if not _G.Ox.CrosshairCreated then
            _G.Ox.CrosshairCreated = true
            _G.Ox.CrosshairGui = Instance.new("ScreenGui")
            _G.Ox.CrosshairGui.Name = "CrosshairUI"
            _G.Ox.CrosshairGui.IgnoreGuiInset = true
            _G.Ox.CrosshairGui.ResetOnSpawn = false
            _G.Ox.CrosshairGui.DisplayOrder = 999
            _G.Ox.CrosshairGui.Parent = CoreGui

            local function createFrame(size, position)
                local frame = Instance.new("Frame")
                frame.BackgroundColor3 = _G.Ox.Crosshair.Color
                frame.BorderSizePixel = 0
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Size = size
                frame.Position = position
                frame.Parent = _G.Ox.CrosshairGui
                return frame
            end

            local udim2 = UDim2.new(0.5, _G.Ox.Crosshair.OffsetX, 0.5, _G.Ox.Crosshair.OffsetY)

            if _G.Ox.Crosshair.Style == "Plus" then
                _G.Ox.CrosshairElements[1] = createFrame(UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Thickness), udim2)
                _G.Ox.CrosshairElements[2] = createFrame(UDim2.new(0, _G.Ox.Crosshair.Thickness, 0, _G.Ox.Crosshair.Size * 2), udim2)
            elseif _G.Ox.Crosshair.Style == "Dot" then
                local frame = Instance.new("Frame")
                frame.BackgroundColor3 = _G.Ox.Crosshair.Color
                frame.BorderSizePixel = 0
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Size = UDim2.new(0, _G.Ox.Crosshair.Size, 0, _G.Ox.Crosshair.Size)
                frame.Position = udim2
                Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
                frame.Parent = _G.Ox.CrosshairGui
                _G.Ox.CrosshairElements[1] = frame
            elseif _G.Ox.Crosshair.Style == "Circle" then
                local frame = Instance.new("Frame")
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.Size = UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Size * 2)
                frame.Position = udim2
                frame.Parent = _G.Ox.CrosshairGui
                local uiStroke = Instance.new("UIStroke")
                uiStroke.Color = _G.Ox.Crosshair.Color
                uiStroke.Thickness = _G.Ox.Crosshair.Thickness
                uiStroke.Parent = frame
                Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
                _G.Ox.CrosshairElements[1] = frame
            end
        end

        local udim2 = UDim2.new(0.5, _G.Ox.Crosshair.OffsetX, 0.5, _G.Ox.Crosshair.OffsetY)

        if _G.Ox.Crosshair.Style == "Plus" then
            if _G.Ox.CrosshairElements[1] then
                _G.Ox.CrosshairElements[1].Size = UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Thickness)
                _G.Ox.CrosshairElements[1].Position = udim2
                _G.Ox.CrosshairElements[1].BackgroundColor3 = _G.Ox.Crosshair.Color
            end

            if _G.Ox.CrosshairElements[2] then
                _G.Ox.CrosshairElements[2].Size = UDim2.new(0, _G.Ox.Crosshair.Thickness, 0, _G.Ox.Crosshair.Size * 2)
                _G.Ox.CrosshairElements[2].Position = udim2
                _G.Ox.CrosshairElements[2].BackgroundColor3 = _G.Ox.Crosshair.Color
            end
        elseif _G.Ox.Crosshair.Style == "Dot" then
            if _G.Ox.CrosshairElements[1] then
                _G.Ox.CrosshairElements[1].Size = UDim2.new(0, _G.Ox.Crosshair.Size, 0, _G.Ox.Crosshair.Size)
                _G.Ox.CrosshairElements[1].Position = udim2
                _G.Ox.CrosshairElements[1].BackgroundColor3 = _G.Ox.Crosshair.Color
            end
        elseif _G.Ox.Crosshair.Style == "Circle" and _G.Ox.CrosshairElements[1] then
            _G.Ox.CrosshairElements[1].Size = UDim2.new(0, _G.Ox.Crosshair.Size * 2, 0, _G.Ox.Crosshair.Size * 2)
            _G.Ox.CrosshairElements[1].Position = udim2
            local uiStroke = _G.Ox.CrosshairElements[1]:FindFirstChildOfClass("UIStroke")

            if uiStroke then
                uiStroke.Color = _G.Ox.Crosshair.Color
                uiStroke.Thickness = _G.Ox.Crosshair.Thickness
            end
        end
    end

    local function fn12()
        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and (not player.Team or player.Team.Name ~= "Survivors") then
                local character = player.Character
                if not character then
                    continue
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    return humanoidRootPart
                end
            end
        end

        return nil
    end

    local function fn13(arg)
        if not _G.Ox.AutoPallet.Safety then
            return true
        end

        if not arg then
            return false
        end

        if arg:GetAttribute("Knocked") == true then
            return false
        end

        if arg:GetAttribute("IsCarried") == true then
            return false
        end

        if arg:GetAttribute("IsHooked") == true then
            return false
        end
        local checkInterractable = arg:FindFirstChild("CheckInterractable")

        if checkInterractable then
            if checkInterractable:GetAttribute("isVaulting") == true then
                return false
            end

            if checkInterractable:GetAttribute("isRepairing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isUnhooking") == true then
                return false
            end

            if checkInterractable:GetAttribute("isHealing") == true then
                return false
            end

            if checkInterractable:GetAttribute("isSliding") == true then
                return false
            end

            if checkInterractable:GetAttribute("isCarrying") == true then
                return false
            end
        end

        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            return false
        end
        return true
    end

    local function fn14(arg)
        local v4 = nil
        local distance = _G.Ox.AutoPallet.Distance
        local v5 = ipairs
        local pallets = tbl4.Pallets
        local tbl6 = pallets or {}

        for k, v6 in v5(tbl6) do
            if v6 and v6.Parent and not _G.Ox.AutoPallet.UsedPallets[v6] then
                local primaryPartPallet = v6:FindFirstChild("PrimaryPartPallet")
                local palletPoint = primaryPartPallet or v6:FindFirstChild("PalletPoint") or v6:FindFirstChild("PalletPointSlide") or v6:FindFirstChildWhichIsA("BasePart")

                if palletPoint then
                    local ok, result = pcall(function()
                        return palletPoint.Position
                    end)

                    if ok and result then
                        local magnitude = (arg.Position - result).Magnitude

                        if magnitude < distance then
                            distance = magnitude
                            v4 = v6
                        end
                    end
                end
            end
        end

        return v4
    end

    local function fn15(arg)
        if not arg then
            return false
        end
        local palletPointSlide = arg:FindFirstChild("PalletPointSlide")
        local palletPoint = palletPointSlide or arg:FindFirstChild("PalletPoint") or arg:FindFirstChildWhichIsA("BasePart")
        if not palletPoint then
            return false
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletDropEvent = remotes and remotes:FindFirstChild("Pallet") and remotes.Pallet:FindFirstChild("PalletDropEvent")
        if not palletDropEvent then
            return false
        end

        pcall(function()
            palletDropEvent:FireServer(palletPoint)
        end)

        _G.Ox.AutoPallet.UsedPallets[arg] = true
        _G.Ox.AutoPallet.LastDrop = tick()
        return true
    end

    StartAutoPallet = function()
        if _G.Ox.AutoPallet.Connection then
            return
        end

        _G.Ox.AutoPallet.Connection = task.spawn(function()
            while _G.Ox.AutoPallet.Enabled do
                task.wait(0.3)

                if GetRole() == "Survivor" and tick() - _G.Ox.AutoPallet.LastDrop >= _G.Ox.AutoPallet.Cooldown then
                    pcall(function()
                        local character = localPlayer.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
                            return
                        end

                        if not fn13(character) then
                            return
                        end
                        local v4 = fn12()
                        if not v4 then
                            return
                        end

                        if _G.Ox.AutoPallet.Distance < (humanoidRootPart.Position - v4.Position).Magnitude then
                            return
                        end
                        local v5 = fn14(humanoidRootPart)

                        if v5 then
                            fn15(v5)
                        end
                    end)
                end
            end
        end)
    end

    StopAutoPallet = function()
        if _G.Ox.AutoPallet.Connection then
            task.cancel(_G.Ox.AutoPallet.Connection)
            _G.Ox.AutoPallet.Connection = nil
        end

        _G.Ox.AutoPallet.UsedPallets = {}
    end

    ToggleAutoPallet = function(enabled)
        _G.Ox.AutoPallet.Enabled = enabled

        if enabled then
            if GetRole() ~= "Survivor" then
                lib:Notify({
                    Title = "Auto Drop Pallet",
                    Description = "Kamu harus Survivor!",
                    Duration = 3,
                })

                _G.Ox.AutoPallet.Enabled = false

                if AutoPalletToggle then
                    fn(AutoPalletToggle, false)
                end

                return
            end

            _G.Ox.AutoPallet.UsedPallets = {}
            StartAutoPallet()

            lib:Notify({
                Title = "Auto Drop Pallet",
                Description = "AKTIF",
                Duration = 2,
            })
        else
            StopAutoPallet()

            lib:Notify({
                Title = "Auto Drop Pallet",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        _G.Ox.AutoPallet.UsedPallets = {}
        _G.Ox.AutoPallet.LastDrop = 0
    end)

    DropAllPallets = function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local palletDropEvent = remotes and remotes:FindFirstChild("Pallet") and remotes.Pallet:FindFirstChild("PalletDropEvent")

        if not palletDropEvent then
            lib:Notify({
                Title = "Drop All Pallet",
                Description = "Remote tidak ditemukan!",
                Duration = 2,
            })

            return
        end

        local tbl6 = {}
        local map = workspace:FindFirstChild("Map")

        if not map then
            lib:Notify({
                Title = "Drop All Pallet",
                Description = "Map tidak ditemukan!",
                Duration = 2,
            })

            return
        end

        for i, descendant in ipairs(map:GetDescendants()) do
            if descendant.Name == "PalletPoint" and descendant:IsA("BasePart") then
                local model = descendant:FindFirstAncestorWhichIsA("Model")

                if model then
                    if not tbl6[model] then
                        tbl6[model] = {}
                    end

                    table.insert(tbl6[model], descendant)
                end
            end
        end

        local n2 = 0
        local v4, v5, v6 = pairs(tbl6)
        local v7 = v6
        local v8 = v4
        local v9 = v5

        while true do
            local v10, v11 = v8(v9, v7)
            if v10 == nil then
                break
            end

            for i, v12 in ipairs(v11) do
                pcall(function()
                    palletDropEvent:FireServer(v12)
                    n2 = n2 + 1
                end)
            end

            v7 = v10
        end

        lib:Notify({
            Title = "Drop All Pallet",
            Description = string.format("Berhasil menjatuhkan %d pallet!", n2),
            Duration = 3,
        })
    end

    local n2 = 0

    fn2 = function(arg)
        if not arg and tick() - n2 < 2 then
            return
        end
        n2 = tick()
        table.clear(tbl.Generators)
        table.clear(tbl.Windows)
        table.clear(tbl.Pallets)
        table.clear(tbl.Hooks)
        table.clear(tbl.Gates)
        table.clear(tbl4.Generators)
        table.clear(tbl4.Windows)
        table.clear(tbl4.Pallets)
        table.clear(tbl4.Hooks)
        table.clear(tbl4.Gates)
        table.clear(tbl4.SCPs)
        local map = workspace:FindFirstChild("Map")
        local v4 = map or workspace
        local descendants = v4:GetDescendants()

        for i, descendant in ipairs(descendants) do
            if i % 200 == 0 then
                task.wait()
            end

            if descendant:IsA("Model") then
                local v5 = string.lower(descendant.Name)

                if v5 == "generator" then
                    local generatorBody = descendant:FindFirstChild("GeneratorBody")
                    local basePart = generatorBody or descendant:FindFirstChildWhichIsA("BasePart")

                    if basePart then
                        local tbl6 = {model = descendant, part = basePart}
                        table.insert(tbl.Generators, tbl6)
                        table.insert(tbl4.Generators, tbl6)
                    end
                elseif v5 == "hook" and descendant:FindFirstChild("HookPoint") then
                    table.insert(tbl.Hooks, descendant)
                    table.insert(tbl4.Hooks, descendant)
                elseif v5 == "gate" and descendant:FindFirstChild("ExitLever") then
                    table.insert(tbl.Gates, descendant)
                    table.insert(tbl4.Gates, descendant)
                elseif v5 == "window" then
                    table.insert(tbl.Windows, descendant)
                    table.insert(tbl4.Windows, descendant)
                end
            elseif descendant:IsA("BasePart") and descendant.Name == "PrimaryPartPallet" then
                local parent = descendant.Parent

                if parent and not table.find(tbl.Pallets, parent) then
                    table.insert(tbl.Pallets, parent)
                    table.insert(tbl4.Pallets, parent)
                end
            end
        end

        local descendants2 = workspace:GetDescendants()

        for i, v5 in ipairs(descendants2) do
            if i % 200 == 0 then
                task.wait()
            end

            if v5:IsA("Model") and string.match(string.lower(v5.Name), "^scp") and not table.find(tbl4.SCPs, v5) then
                table.insert(tbl4.SCPs, v5)
            end
        end
    end

    fn3 = function(arg)
        if not arg then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local vector = Vector3.new(0, 3, 0)

            if arg:IsA("BasePart") then
                humanoidRootPart.CFrame = arg.CFrame + vector
            elseif arg:IsA("Model") then
                local basePart = arg:FindFirstChildWhichIsA("BasePart")

                if basePart then
                    humanoidRootPart.CFrame = basePart.CFrame + vector
                end
            end

            lib:Notify({
                Title = "Teleport",
                Description = "Berhasil!",
                Duration = 1,
            })
        end
    end

    ApplyFullBright = function()
        local Lighting = game:GetService("Lighting")
        if not Lighting then
            return
        end

        if _G.Ox.FullBright then
            Lighting.Brightness = 2.8
            Lighting.ClockTime = _G.Ox.TimeOfDayValue
            Lighting.FogEnd = 100000
            Lighting.Ambient = Color3.fromRGB(200, 200, 200)
            Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
        end
    end

    ApplyNoFog = function()
        local Lighting = game:GetService("Lighting")
        if not Lighting then
            return
        end

        if _G.Ox.NoFog then
            Lighting.FogStart = 0
            Lighting.FogEnd = 100000
            Lighting.FogColor = Color3.fromRGB(255, 255, 255)
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

            if atmosphere then
                atmosphere.Density = 0
                atmosphere.Offset = 0
                atmosphere.Glare = 0
                atmosphere.Haze = 0
            end
        end
    end

    ApplyNoShadow = function()
        local Lighting = game:GetService("Lighting")
        if not Lighting then
            return
        end
        local globalShadows

        if _G.Ox.NoShadow then
            globalShadows = false
        else
            globalShadows = true
        end

        Lighting.GlobalShadows = globalShadows
    end

    ReapplyPerformance = function()
        ApplyFullBright()
        ApplyNoFog()
        ApplyNoShadow()
    end

    ReapplyPerformanceDelayed = function()
        task.spawn(function()
            ReapplyPerformance()
            task.wait(1.2)
            ReapplyPerformance()
            task.wait(2)
            ReapplyPerformance()
            task.wait(3)
            ReapplyPerformance()
        end)
    end

    StartLightingGuard = function()
        if _G.Ox.LightingGuardConn then
            return
        end
        local n3 = 0

        _G.Ox.LightingGuardConn = RunService.Heartbeat:Connect(function()
            if not _G.Ox.FullBright and not _G.Ox.NoFog and not _G.Ox.NoShadow then
                return
            end
            local now = tick()
            if now - n3 < 0.4 then
                return
            end
            n3 = now
            ReapplyPerformance()
        end)
    end

    StopLightingGuard = function()
        if _G.Ox.FullBright or _G.Ox.NoFog or _G.Ox.NoShadow then
            return
        end

        if _G.Ox.LightingGuardConn then
            _G.Ox.LightingGuardConn:Disconnect()
            _G.Ox.LightingGuardConn = nil
        end
    end

    if not _G.Ox.LightingChildConn then
        _G.Ox.LightingChildConn = game:GetService("Lighting").ChildAdded:Connect(function(child)
            if not _G.Ox.FullBright and not _G.Ox.NoFog then
                return
            end

            task.defer(function()
                if child:IsA("Atmosphere") and _G.Ox.NoFog then
                    child.Density = 0
                    child.Offset = 0
                    child.Glare = 0
                    child.Haze = 0
                end

                ReapplyPerformance()
            end)
        end)
    end

    local function fn16(arg, arg2, arg3)
        table.insert(_G.Ox.LowGFX.Saved, {obj = arg, kind = arg2, extra = arg3})
    end

    LowGFX_ProcessOne = function(arg)
        if not _G.Ox.LowGFX.Enabled or not arg then
            return
        end
        local lowGFX = _G.Ox.LowGFX

        if lowGFX.Parts and (arg:IsA("BasePart") or arg:IsA("UnionOperation") or arg:IsA("MeshPart")) and arg.Material ~= Enum.Material.SmoothPlastic then
            fn16(arg, "Part", arg.Material)
            arg.Material = Enum.Material.SmoothPlastic
        end

        if lowGFX.Particles and (arg:IsA("ParticleEmitter") or arg:IsA("Smoke") or arg:IsA("Explosion") or arg:IsA("Sparkles") or arg:IsA("Fire")) and arg.Enabled ~= false then
            fn16(arg, "Particle", true)
            arg.Enabled = false
        end

        if lowGFX.VisualEffects and (arg:IsA("BloomEffect") or arg:IsA("BlurEffect") or arg:IsA("DepthOfFieldEffect") or arg:IsA("SunRaysEffect") or arg:IsA("ColorCorrectionEffect")) and arg.Enabled ~= false then
            fn16(arg, "VFX", true)
            arg.Enabled = false
        end

        if lowGFX.Textures and (arg:IsA("Decal") or arg:IsA("Texture")) and arg.Texture ~= "" then
            fn16(arg, "Texture", arg.Texture)
            arg.Texture = ""
        end

        if lowGFX.Sky and arg:IsA("Sky") then
            fn16(arg, "Sky", arg.Parent)
            arg.Parent = nil
        end
    end

    ApplyLowGFX = function()
        if not _G.Ox.LowGFX.Enabled then
            return
        end
        local tbl6 = {workspace, game:GetService("Lighting")}
        local v4, v5, v6 = ipairs(tbl6)
        local v7 = v6
        local v8 = v4
        local v9 = v5

        while true do
            local v10, v11 = v8(v9, v7)
            if v10 == nil then
                break
            end
            local descendants = v11:GetDescendants()

            for i, descendant in ipairs(descendants) do
                if i % 250 == 0 then
                    task.wait()
                end

                LowGFX_ProcessOne(descendant)
            end

            v7 = v10
        end
    end

    RestoreLowGFX = function()
        for i, v4 in ipairs(_G.Ox.LowGFX.Saved) do
            local obj = v4.obj

            if obj and obj.Parent then
                pcall(function()
                    if v4.kind == "Part" then
                        obj.Material = v4.extra
                    elseif v4.kind ~= "Particle" and v4.kind ~= "VFX" then
                        if v4.kind == "Texture" then
                            obj.Texture = v4.extra
                        elseif v4.kind == "Sky" and v4.extra then
                            obj.Parent = v4.extra
                        end
                    else
                        obj.Enabled = v4.extra
                    end
                end)
            end
        end

        table.clear(_G.Ox.LowGFX.Saved)
    end

    ToggleLowGFX = function(enabled)
        _G.Ox.LowGFX.Enabled = enabled

        if enabled then
            task.spawn(ApplyLowGFX)

            lib:Notify({
                Title = "Remove Texture",
                Description = "AKTIF - Low GFX",
                Duration = 2,
            })
        else
            RestoreLowGFX()

            lib:Notify({
                Title = "Remove Texture",
                Description = "NONAKTIF - texture dikembalikan",
                Duration = 2,
            })
        end
    end

    if not _G.Ox.LowGFX.StreamConn then
        _G.Ox.LowGFX.StreamConn = workspace.DescendantAdded:Connect(function(descendant)
            if not _G.Ox.LowGFX.Enabled then
                return
            end

            task.defer(function()
                LowGFX_ProcessOne(descendant)
            end)
        end)
    end

    CreateSpectatorUI = function()
        if _G.Ox.Spectator.Gui then
            _G.Ox.Spectator.Gui:Destroy()
            _G.Ox.Spectator.Gui = nil
        end

        _G.Ox.Spectator.Gui = Instance.new("ScreenGui")
        _G.Ox.Spectator.Gui.Name = "SpectatorCounter"
        _G.Ox.Spectator.Gui.ResetOnSpawn = false
        _G.Ox.Spectator.Gui.Parent = localPlayer:WaitForChild("PlayerGui")
        local frame = Instance.new("Frame")
        frame.Name = "MainBox"
        frame.AnchorPoint = Vector2.new(0.5, 1)
        frame.Position = UDim2.new(0.5, 0, 0, -10)
        frame.Size = UDim2.new(0, 68, 0, 22)
        frame.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
        frame.BackgroundTransparency = 0.25
        frame.BorderSizePixel = 0
        frame.Parent = _G.Ox.Spectator.Gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local uiGradient = Instance.new("UIGradient")

        uiGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.4),
            NumberSequenceKeypoint.new(1, 1),
        })

        uiGradient.Parent = frame
        local uiListLayout = Instance.new("UIListLayout", frame)
        uiListLayout.FillDirection = Enum.FillDirection.Horizontal
        uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uiListLayout.Padding = UDim.new(0, 6)
        local imageLabel = Instance.new("ImageLabel", frame)
        imageLabel.Size = UDim2.new(0, 15, 0, 15)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://13321848320"
        imageLabel.ImageColor3 = Color3.fromRGB(225, 225, 225)
        _G.Ox.Spectator.Label = Instance.new("TextLabel", frame)
        _G.Ox.Spectator.Label.BackgroundTransparency = 1
        _G.Ox.Spectator.Label.Font = Enum.Font.GothamMedium
        _G.Ox.Spectator.Label.Text = "0"
        _G.Ox.Spectator.Label.TextColor3 = Color3.fromRGB(240, 240, 240)
        _G.Ox.Spectator.Label.TextSize = 13
        _G.Ox.Spectator.Label.AutomaticSize = Enum.AutomaticSize.X
    end

    UpdateSpectatorCount = function()
        if not _G.Ox.Spectator.Enabled or not _G.Ox.Spectator.Label then
            return
        end
        local n3 = 0

        for i, player in ipairs(Players:GetPlayers()) do
            if player.Team and player.Team.Name == "Spectator" then
                n3 = n3 + 1
            end
        end

        _G.Ox.Spectator.Label.Text = tostring(n3)
        local gui = _G.Ox.Spectator.Gui
        local mainBox = gui and _G.Ox.Spectator.Gui:FindFirstChild("MainBox")

        if mainBox then
            local udim2 = UDim2.new
            local n4 = n3 >= 10 and 8 or 0
            local n5 = 55 + n4
            local n6 = n3 >= 100 and 8 or 0
            mainBox.Size = udim2(0, n5 + n6, 0, 22)
        end
    end

    StartSpectatorInfo = function()
        if _G.Ox.Spectator.Enabled then
            return
        end
        _G.Ox.Spectator.Enabled = true
        CreateSpectatorUI()
        UpdateSpectatorCount()

        task.spawn(function()
            while _G.Ox.Spectator.Enabled do
                UpdateSpectatorCount()
                task.wait(1.2)
            end
        end)

        lib:Notify({
            Title = "Spectator Info",
            Description = "✅ Display aktif di pojok atas",
            Duration = 3,
        })
    end

    StopSpectatorInfo = function()
        _G.Ox.Spectator.Enabled = false

        if _G.Ox.Spectator.Gui then
            _G.Ox.Spectator.Gui:Destroy()
            _G.Ox.Spectator.Gui = nil
            _G.Ox.Spectator.Label = nil
        end

        lib:Notify({
            Title = "Spectator Info",
            Description = "Display dimatikan",
            Duration = 2,
        })
    end

    fn4 = function(arg)
        if arg then
            StartSpectatorInfo()
        else
            StopSpectatorInfo()
        end
    end

    ScanMapESP = function(arg)
        fn2(arg)
    end

    ForceRefreshMap = function()
        fn2(true)

        if _G.Ox.ESPConfig.Master then
            ClearAllESP()
            task.wait(0.1)
            UpdatePlayerESP()
            UpdateSCPESP()
            UpdateStaticESP()
        end
    end

    task.spawn(function()
        task.wait(2)
        ScanMapESP()
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)
        ScanMapESP()

        if _G.Ox.ESPConfig.Master then
            task.spawn(function()
                task.wait(0.5)
                ClearAllESP()
                task.wait(0.2)
                UpdatePlayerESP()
                UpdateSCPESP()
                UpdateStaticESP()
            end)
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)
            ScanMapESP(true)

            if _G.Ox.ESPConfig.Master then
                pcall(UpdatePlayerESP)
                pcall(UpdateSCPESP)
                pcall(UpdateStaticESP)
            end

            ReapplyPerformanceDelayed()

            if _G.Ox.LowGFX.Enabled then
                table.clear(_G.Ox.LowGFX.Saved)
                task.wait(1.5)
                ApplyLowGFX()
                task.wait(2.5)

                if _G.Ox.LowGFX.Enabled then
                    ApplyLowGFX()
                end
            end
        end
    end)

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(40)

            if _G.Ox.ESPConfig.Master then
                ScanMapESP()

                if _G.Ox.ESPConfig.Master then
                    pcall(UpdateStaticESP)
                    pcall(UpdatePlayerESP)
                    pcall(UpdateSCPESP)
                end
            end
        end
    end)

    local function fn17()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return nil
        end
        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")
        if not survivorMob then
            return nil
        end
        local controls = survivorMob:FindFirstChild("Controls")
        if not controls then
            return nil
        end
        local sprint = controls:FindFirstChild("sprint")
        if not sprint then
            return nil
        end

        if sprint:IsA("GuiButton") then
            return sprint
        end
        local icon = sprint:FindFirstChild("icon")
        if icon and icon:IsA("GuiButton") then
            return icon
        end

        if icon and icon.Parent and icon.Parent:IsA("GuiButton") then
            return icon.Parent
        end

        if sprint.Parent and sprint.Parent:IsA("GuiButton") then
            return sprint.Parent
        end
        return sprint
    end

    local function fn18()
        local v4 = fn17()
        if not v4 then
            return false
        end

        pcall(function()
            if type(firesignal) == "function" then
                firesignal(v4.MouseButton1Click)
                firesignal(v4.MouseButton1Down)
                task.wait(0.04)
                firesignal(v4.MouseButton1Up)
            else
                local absolutePosition = v4.AbsolutePosition
                local absoluteSize = v4.AbsoluteSize
                local guiInset = GuiService:GetGuiInset()
                local n3 = absolutePosition.X + absoluteSize.X / 2 + guiInset.X
                local n4 = absolutePosition.Y + absoluteSize.Y / 2 + guiInset.Y
                VirtualInputManager:SendTouchEvent(9901, 0, n3, n4)
                task.wait(0.04)
                VirtualInputManager:SendTouchEvent(9901, 2, n3, n4)
            end
        end)

        return true
    end

    local function fn19()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end

        if humanoid.MoveDirection.Magnitude > 0.12 then
            return true
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
            if Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude > 1.5 then
                return true
            end
        end

        return false
    end

    local function fn20()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local flag4 = character:GetAttribute("Crouching") == true or character:GetAttribute("Crouchingserver") == true
        return flag4
    end

    local function fn21()
        local character = localPlayer.Character
        if not character then
            return false
        end
        local flag4 = character:GetAttribute("Sprinting") == true or character:GetAttribute("IsRunning") == true
        return flag4
    end

    fn5 = function()
        if _G.Ox.AutoRun.MobileThread then
            return
        end

        _G.Ox.AutoRun.MobileThread = task.spawn(function()
            while _G.Ox.AutoRun.Mobile do
                local v4 = fn19()
                local v5 = fn20()
                local v6 = fn21()

                if v5 then
                    if v6 then
                        fn18()
                    end
                elseif v4 and not v6 then
                    fn18()
                elseif not v4 and v6 then
                    fn18()
                end

                task.wait(0.12)
            end

            _G.Ox.AutoRun.MobileThread = nil
        end)
    end

    fn6 = function()
        _G.Ox.AutoRun.Mobile = false

        if _G.Ox.AutoRun.MobileThread then
            task.cancel(_G.Ox.AutoRun.MobileThread)
            _G.Ox.AutoRun.MobileThread = nil
        end

        if fn21() then
            fn18()
        end
    end

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(0.1)
            if not _G.Ox.ScriptAlive then
                break
            end

            if not UserInputService.TouchEnabled and tick() - _G.Ox.lastActionTime >= _G.Ox.COOLDOWN then
                local autoVaultEnabled = _G.Ox.autoVaultEnabled
                local autoPalletSlideEnabled = _G.Ox.autoPalletSlideEnabled

                if autoVaultEnabled or autoPalletSlideEnabled then
                    local pcprompts = playerGui:FindFirstChild("pcprompts")
                    local frame = pcprompts and pcprompts:FindFirstChild("Frame")

                    if frame then
                        local vaultPromptGui = frame:FindFirstChild("VaultPromptGui")
                        local palletSlidePromptGui = frame:FindFirstChild("PalletSlidePromptGui")
                        local visible = vaultPromptGui and vaultPromptGui.Visible
                        local visible2 = palletSlidePromptGui and palletSlidePromptGui.Visible

                        if autoVaultEnabled and visible or autoPalletSlideEnabled and visible2 then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            task.wait(0.01)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                            _G.Ox.lastActionTime = tick()
                        end
                    end
                end
            end
        end
    end)

    local function fn22()
        if not UserInputService.TouchEnabled then
            return
        end
        local survivorMob = playerGui:FindFirstChild("Survivor-mob")
        local survivorMob2 = survivorMob or playerGui:WaitForChild("Survivor-mob", 8)
        if not survivorMob2 then
            return
        end
        local controls = survivorMob2:FindFirstChild("Controls")
        local controls2 = controls or survivorMob2:WaitForChild("Controls", 5)
        local action = controls2

        if controls2 then
            local action2 = controls2:FindFirstChild("action")
            action = action2 or controls2:WaitForChild("action", 5)
        end

        if not action then
            return
        end

        local tbl6 = {
            vault = true,
            palletvault = true,
            palletslide = true,
            slide = true,
        }

        local function fn23(arg)
            if not arg:IsA("ImageLabel") and not arg:IsA("ImageButton") then
                return
            end
            local str = arg.Name:lower()
            if not tbl6[str] then
                return
            end

            arg:GetPropertyChangedSignal("Visible"):Connect(function()
                if not arg.Visible then
                    return
                end

                if tick() - _G.Ox.lastActionTime < _G.Ox.COOLDOWN then
                    return
                end
                local pos = str:find("vault")
                local flag4 = pos

                if pos then
                    if str:find("pallet") then
                        flag4 = false
                    else
                        flag4 = true
                    end
                end

                local pos2 = str:find("pallet")
                local pos3 = pos2 or str:find("slide")

                if flag4 and _G.Ox.autoVaultEnabled or pos3 and _G.Ox.autoPalletSlideEnabled then
                    pcall(function()
                        firesignal(action.MouseButton1Down)
                        task.wait(0.01)
                        firesignal(action.MouseButton1Up)
                    end)

                    _G.Ox.lastActionTime = tick()
                end
            end)
        end

        for k, child in pairs(action:GetChildren()) do
            fn23(child)
        end

        action.ChildAdded:Connect(function(child)
            task.wait()
            fn23(child)
        end)
    end

    task.spawn(fn22)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(2)
        fn22()
    end)

    playerGui.ChildAdded:Connect(function(child)
        if child.Name == "Survivor-mob" then
            task.wait(1)
            fn22()
        end
    end);

    (function()
        task.spawn(function()
            local remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
            local killerPerks = remotes and remotes:WaitForChild("KillerPerks", 5)
            local kingscourge = killerPerks and killerPerks:WaitForChild("kingscourge", 5)
            local kingScourgeStart = kingscourge and kingscourge:WaitForChild("KingScourgeStart", 5)

            if kingScourgeStart then
                kingScourgeStart.OnClientEvent:Connect(function()
                    if _G.Ox.Auto.SkillCheckMode == "Random" then
                        _G.Ox.State.RandomMode_IsNormal = true
                    end
                end)
            end
        end)
    end)()

    local function fn23()
        if not playerGui then
            return nil
        end
        local survivorMob = playerGui:FindFirstChild("Survivor-mob")
        if not survivorMob then
            return nil
        end
        local controls = survivorMob:FindFirstChild("Controls")
        if not controls then
            return nil
        end
        local action = controls:FindFirstChild("action")
        local check = action or controls:FindFirstChild("check")
        return check
    end

    local function fn24()
        local v4 = fn23()

        if v4 and v4:IsA("GuiObject") and v4.Visible and type(firesignal) == "function" then
            pcall(function()
                firesignal(v4.MouseButton1Down)
                task.wait(0.005)
                firesignal(v4.MouseButton1Up)
            end)

            return true
        end

        if v4 and v4:IsA("GuiObject") and v4.Visible then
            pcall(function()
                local absolutePosition = v4.AbsolutePosition
                local absoluteSize = v4.AbsoluteSize
                local guiInset = GuiService:GetGuiInset()
                local n3 = 8822 + math.random(1, 9999)
                VirtualInputManager:SendTouchEvent(n3, 0, absolutePosition.X + absoluteSize.X / 2 + guiInset.X, absolutePosition.Y + absoluteSize.Y / 2 + guiInset.Y)
                task.wait(0.005)
                VirtualInputManager:SendTouchEvent(n3, 2, absolutePosition.X + absoluteSize.X / 2 + guiInset.X, absolutePosition.Y + absoluteSize.Y / 2 + guiInset.Y)
            end)

            return true
        end

        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.005)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)

        return true
    end

    fn7 = function()
        if _G.Ox.Connections.SkillHeartbeat then
            _G.Ox.Connections.SkillHeartbeat:Disconnect()
            _G.Ox.Connections.SkillHeartbeat = nil
        end

        _G.Ox.Connections.SkillHeartbeat = RunService.Heartbeat:Connect(function()
            if not _G.Ox.Auto.SkillCheck or _G.Ox.State.busy then
                return
            end
            local skillCheckPromptGui = playerGui:FindFirstChild("SkillCheckPromptGui")
            if not skillCheckPromptGui then
                return
            end
            local check = skillCheckPromptGui:FindFirstChild("Check")

            if check and check.Visible then
                local line = check:FindFirstChild("Line")
                local goal = check:FindFirstChild("Goal")
                if not line or not goal then
                    return
                end
                local flag4 = _G.Ox.Auto.SkillCheckMode == "Instant"

                if not flag4 then
                    flag4 = _G.Ox.Auto.SkillCheckMode == "Random"

                    if flag4 then
                        if _G.Ox.State.RandomMode_IsNormal then
                            flag4 = false
                        else
                            flag4 = true
                        end
                    end
                end

                if flag4 then
                    line.Rotation = goal.Rotation + 109
                    _G.Ox.State.busy = true

                    task.spawn(function()
                        fn24()
                        task.wait(0.05)
                        _G.Ox.State.busy = false
                    end)
                else
                    local randomModeIsNormal = _G.Ox.Auto.SkillCheckMode == "Normal" or _G.Ox.Auto.SkillCheckMode == "Random" and _G.Ox.State.RandomMode_IsNormal
                    local n3 = line.Rotation % 360
                    local n4 = goal.Rotation % 360
                    local n5, n6

                    if randomModeIsNormal then
                        n5 = (n4 + 116) % 360
                        n6 = (n4 + 140) % 360
                    else
                        n5 = (n4 + 102) % 360
                        n6 = (n4 + 116) % 360
                    end

                    local v4

                    if n6 < n5 then
                        local flag5 = n5 <= n3 or n3 <= n6
                        v4 = flag5
                    else
                        local flag5 = n5 <= n3 and n3 <= n6
                        v4 = flag5
                    end

                    if v4 then
                        _G.Ox.State.busy = true

                        task.spawn(function()
                            fn24()
                            task.wait(0.05)
                            _G.Ox.State.busy = false
                        end)
                    end
                end

                return
            end

            _G.Ox.State.RandomMode_IsNormal = false
        end)
    end

    local repairEvent = game:GetService("ReplicatedStorage").Remotes.Generator.RepairEvent
    local tbl6 = {}
    local n3 = 0

    GetAllGenerators = function()
        local now = tick()
        if now - n3 < 5 then
            return tbl6
        end
        tbl6 = {}
        n3 = now
        local map = workspace:FindFirstChild("Map")
        if not map then
            return tbl6
        end

        pcall(function()
            for k, descendant in pairs(map:GetDescendants()) do
                if descendant:IsA("Model") and descendant.Name == "Generator" then
                    local flag4 = descendant:GetAttribute("RepairProgress") ~= nil or descendant:GetAttribute("kickcount") ~= nil or descendant:GetAttribute("ProgressRepair") ~= nil

                    if flag4 then
                        table.insert(tbl6, descendant)
                    end
                end
            end
        end)

        return tbl6
    end

    _G.Ox.PlayRepairAnim = function()
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        if _G.Ox.RepairAnimTrack and _G.Ox.RepairAnimTrack.IsPlaying then
            return
        end

        pcall(function()
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://92960319113695"
            _G.Ox.RepairAnimTrack = animator:LoadAnimation(animation)
            _G.Ox.RepairAnimTrack.Priority = Enum.AnimationPriority.Action
            _G.Ox.RepairAnimTrack:Play()
        end)
    end

    _G.Ox.StopRepairAnim = function()
        if _G.Ox.RepairAnimTrack and _G.Ox.RepairAnimTrack.IsPlaying then
            pcall(function()
                _G.Ox.RepairAnimTrack:Stop()
            end)
        end

        _G.Ox.RepairAnimTrack = nil
    end

    GetGeneratorPoints = function(arg)
        local tbl7 = {}

        pcall(function()
            for k, child in pairs(arg:GetChildren()) do
                if child.Name:find("GeneratorPoint") and child:IsA("BasePart") then
                    table.insert(tbl7, child)
                end
            end
        end)

        return tbl7
    end

    _G.Ox.StopAutoRepair = function()
        _G.Ox.StopRepairAnim()
        local autoCurrentPoint = _G.Ox.AutoCurrentPoint
        _G.Ox.AutoCurrentPoint = nil

        if autoCurrentPoint then
            pcall(function()
                repairEvent:FireServer(autoCurrentPoint, false)
            end)
        end
    end

    _G.Ox.StartAutoRepairLoop = function(autoCurrentGenModel)
        _G.Ox.AutoCurrentGenModel = autoCurrentGenModel

        if _G.Ox.AutoRepairThread then
            task.cancel(_G.Ox.AutoRepairThread)
            _G.Ox.AutoRepairThread = nil
        end

        _G.Ox.StopAutoRepair()

        _G.Ox.AutoRepairThread = task.spawn(function()
            while _G.Ox.AutoRepairEnabled and _G.Ox.BypassGenEnabled do
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then
                    task.wait(0.1)
                    continue
                end
                local v4 = nil
                local v5, v6, v7 = pairs(GetAllGenerators())
                local v8 = v7
                local v9 = v5
                local v10 = v6
                local v11, v12

                repeat
                    v11, v12 = v9(v10, v8)
                    if v11 == nil then
                        break
                    end

                    for k, v13 in pairs(GetGeneratorPoints(v12)) do
                        if (humanoidRootPart.Position - v13.Position).Magnitude <= 5 then
                            v4 = v13
                            break
                        end
                    end

                    v8 = v11
                until v4

                if v4 then
                    _G.Ox.AutoCurrentPoint = v4
                    local now = tick()

                    if _G.Ox.AutoFireInterval <= now - _G.Ox.LastFireTime then
                        _G.Ox.PlayRepairAnim()

                        pcall(function()
                            repairEvent:FireServer(v4, true)
                        end)

                        _G.Ox.LastFireTime = now
                    end
                elseif _G.Ox.AutoCurrentPoint then
                    _G.Ox.StopAutoRepair()
                    _G.Ox.AutoRepairEnabled = false

                    if _G.Ox.AutoCurrentGenModel then
                        _G.Ox.ProcessedGens[_G.Ox.AutoCurrentGenModel] = nil
                        _G.Ox.AutoCurrentGenModel = nil
                    end

                    break
                end

                task.wait(0.1)
            end

            _G.Ox.StopAutoRepair()
        end)
    end

    waitForRepairing = function(arg, arg2)
        local now = tick()

        while true do
            local n4 = tick() - now
            local n5 = arg2 or 1
            if n4 >= n5 then
                break
            end

            if arg:GetAttribute("IsRepairing") == true then
                return true
            end
            task.wait(0.05)
        end

        return false
    end

    RecreateBypassButton = function()
        local bypassGenUI = CoreGui:FindFirstChild("BypassGenUI")

        if bypassGenUI then
            bypassGenUI:Destroy()
        end

        _G.Ox.BypassUI = Instance.new("ScreenGui")
        _G.Ox.BypassUI.Name = "BypassGenUI"
        _G.Ox.BypassUI.ResetOnSpawn = false
        _G.Ox.BypassUI.IgnoreGuiInset = true
        _G.Ox.BypassUI.Parent = CoreGui
        _G.Ox.BypassButton = Instance.new("ImageButton")
        _G.Ox.BypassButton.Name = "BypassGenButton"
        _G.Ox.BypassButton.Size = UDim2.new(0, 55, 0, 55)
        _G.Ox.BypassButton.Position = UDim2.new(0.88, 0, 0.55, 0)
        _G.Ox.BypassButton.AnchorPoint = Vector2.new(0.5, 0.5)
        _G.Ox.BypassButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        _G.Ox.BypassButton.BackgroundTransparency = 0.15
        _G.Ox.BypassButton.AutoButtonColor = true
        _G.Ox.BypassButton.Visible = false
        _G.Ox.BypassButton.ZIndex = 10
        _G.Ox.BypassButton.Parent = _G.Ox.BypassUI
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(1, 0)
        uiCorner.Parent = _G.Ox.BypassButton
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = Color3.fromRGB(255, 255, 255)
        uiStroke.Thickness = 1.5
        uiStroke.Transparency = 0.4
        uiStroke.Parent = _G.Ox.BypassButton
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "GEN"
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.GothamBold
        textLabel.ZIndex = 11
        textLabel.Parent = _G.Ox.BypassButton
        local bypassButton = _G.Ox.BypassButton
        local bypassToggleValue = _G.Ox.BypassToggleValue
        local touchEnabled = bypassToggleValue and UserInputService.TouchEnabled

        if touchEnabled then
            if UserInputService.KeyboardEnabled then
                touchEnabled = false
            else
                touchEnabled = true
            end
        end

        bypassButton.Visible = touchEnabled
    end

    RecreateBypassButton()

    _G.Ox.DoMultiRepairPlain = function(arg)
        local parent = arg.Parent
        if _G.Ox.ProcessedGens[parent] then
            return
        end
        _G.Ox.ProcessedGens[parent] = true
        local v4 = GetGeneratorPoints(parent)
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            _G.Ox.ProcessedGens[parent] = nil
            return
        end
        local cFrame = humanoidRootPart.CFrame

        pcall(function()
            for k, v5 in pairs(v4) do
                if v5 ~= arg and v5.Parent then
                    humanoidRootPart.Anchored = true
                    humanoidRootPart.CFrame = v5.CFrame
                    task.wait(0.15)

                    pcall(function()
                        repairEvent:FireServer(v5, true)
                    end)

                    if not waitForRepairing(v5, 0.8) then
                        pcall(function()
                            repairEvent:FireServer(v5, false)
                        end)

                        task.wait(0.1)
                        humanoidRootPart.CFrame = v5.CFrame
                        task.wait(0.15)

                        pcall(function()
                            repairEvent:FireServer(v5, true)
                        end)

                        waitForRepairing(v5, 0.5)
                    end

                    humanoidRootPart.Anchored = false
                    task.wait(0.05)
                end
            end
        end)

        pcall(function()
            if humanoidRootPart and humanoidRootPart.Parent then
                humanoidRootPart.Anchored = false
                humanoidRootPart.CFrame = cFrame
            end
        end)

        task.wait(0.1)

        if _G.Ox.BypassGenMode == "Manual Repair" then
            pcall(function()
                repairEvent:FireServer(arg, false)
            end)
        elseif _G.Ox.BypassGenMode == "Auto Repair" then
            _G.Ox.AutoRepairEnabled = true
            _G.Ox.StartAutoRepairLoop(parent)
        end
    end

    _G.Ox.BypassButton.MouseButton1Click:Connect(function()
        if not _G.Ox.BypassGenEnabled then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        local v4 = nil
        local huge = math.huge
        local v5, v6, v7 = pairs(GetAllGenerators())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end

            for k, v13 in pairs(GetGeneratorPoints(v12)) do
                local magnitude = (humanoidRootPart.Position - v13.Position).Magnitude

                if magnitude < huge then
                    huge = magnitude
                    v4 = v13
                end
            end

            v8 = v11
        end

        if v4 and huge <= 8 then
            _G.Ox.DoMultiRepairPlain(v4)
        else
            lib:Notify({
                Title = "Gen Boost",
                Description = "Ga deket generator manapun!",
                Duration = 2,
            })
        end
    end)

    isGeneratorPromptVisible = function()
        local ok, result = pcall(function()
            return localPlayer.PlayerGui.pcprompts.Frame.GeneratorRepair
        end)

        local visible = ok and result and result.Visible
        return visible
    end

    getNearestGenPoint = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local v4 = nil
        local huge = math.huge
        local v5, v6, v7 = pairs(GetAllGenerators())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end

            for k, v13 in pairs(GetGeneratorPoints(v12)) do
                local magnitude = (humanoidRootPart.Position - v13.Position).Magnitude

                if magnitude < huge then
                    huge = magnitude
                    v4 = v13
                end
            end

            v8 = v11
        end

        return v4, huge
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        if not _G.Ox.BypassGenEnabled then
            return
        end

        if not isGeneratorPromptVisible() then
            return
        end
        local v4, v5 = getNearestGenPoint()
        if not v4 or v5 > 8 then
            return
        end

        if _G.Ox.ProcessedGens[v4.Parent] then
            return
        end
        _G.Ox.DoMultiRepairPlain(v4)
    end)

    startProcessedGensWatcher = function()
        task.spawn(function()
            local character, humanoidRootPart, v4, v5, v6, v7, v8, v9, v10, flag4, v11, v12, v13, v14, v15, v16, v17, v18, v19, n4
            n4 = 1

            while true do
                if n4 == 1 then
                    if _G.Ox.ScriptAlive then
                        n4 = 2
                    else
                        n4 = 16
                    end
                elseif n4 == 2 then
                    task.wait(2)

                    if _G.Ox.ScriptAlive then
                        n4 = 3
                    else
                        n4 = 16
                    end
                elseif n4 == 3 then
                    character = localPlayer.Character
                    humanoidRootPart = character

                    if character then
                        n4 = 4
                    else
                        n4 = 5
                    end
                elseif n4 == 4 then
                    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    n4 = 5
                elseif n4 == 5 then
                    if humanoidRootPart then
                        n4 = 6
                    else
                        n4 = 1
                    end
                elseif n4 == 6 then
                    v4, v5, v6 = pairs(_G.Ox.ProcessedGens)
                    v7 = v6
                    v8 = v4
                    v9 = v5
                    n4 = 7
                elseif n4 == 7 then
                    v10 = v8(v9, v7)

                    if v10 == nil then
                        n4 = 1
                    else
                        n4 = 8
                    end
                elseif n4 == 8 then
                    v7 = v10

                    if v10 and v10.Parent then
                        n4 = 10
                    else
                        n4 = 9
                    end
                elseif n4 == 9 then
                    _G.Ox.ProcessedGens[v10] = nil
                    n4 = 7
                elseif n4 == 10 then
                    flag4 = false
                    v11 = GetGeneratorPoints(v10)
                    v12, v13, v14 = pairs(v11)
                    v15 = v8
                    v16 = v9
                    v17 = v14
                    n4 = 11
                elseif n4 == 11 then
                    v18, v19 = v12(v13, v17)

                    if v18 == nil then
                        n4 = 14
                    else
                        n4 = 12
                    end
                elseif n4 == 12 then
                    v17 = v18

                    if v19.Parent and (humanoidRootPart.Position - v19.Position).Magnitude <= 10 then
                        n4 = 13
                    else
                        n4 = 11
                    end
                elseif n4 == 13 then
                    flag4 = true
                    n4 = 14
                elseif n4 == 14 then
                    v7 = v10
                    v8 = v15
                    v9 = v16

                    if flag4 then
                        n4 = 7
                    else
                        n4 = 15
                    end
                elseif n4 == 15 then
                    _G.Ox.ProcessedGens[v10] = nil
                    n4 = 7
                elseif n4 == 16 then
                    return
                end
            end
        end)
    end

    startProcessedGensWatcher()
    INVIS_URL = "https://script.panduhub.com/invisibility.lua"
    local v4 = nil
    local flag4 = false
    local touchEnabled = UserInputService.TouchEnabled
    local flag5 = touchEnabled

    if touchEnabled then
        if UserInputService.KeyboardEnabled then
            flag5 = false
        else
            flag5 = true
        end
    end

    local function fn25()
        if flag4 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet(INVIS_URL))()
        end)

        if not ok or not result then
            return false
        end
        v4 = result
        flag4 = true
        return true
    end

    fn8 = function(arg)
        if arg then
            if not flag4 then
                fn25()
            end

            if v4 then
                if flag5 then
                    v4.ShowGUI()
                else
                    v4.Enable()
                end
            end
        elseif v4 then
            if flag5 then
                v4.HideGUI()
            end

            v4.Disable()
        end
    end

    v2 = nil
    local flag6 = false

    local function fn26()
        if flag6 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://script.panduhub.com/BoostBandage.lua"))()
        end)

        if not ok or not result then
            return false
        end
        v2 = result
        flag6 = true
        return true
    end

    fn9 = function(arg)
        if arg then
            if not flag6 then
                fn26()
            end

            if v2 then
                if flag5 then
                    v2.ShowGUI()
                elseif not v2.Start() then
                    _G.Ox.Utility.BandageEnabled = false
                end
            end
        elseif v2 then
            if flag5 then
                v2.HideGUI()
            end

            v2.Stop()
        end
    end

    local v5 = nil
    local flag7 = false

    local function fn27()
        if flag7 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://pastefy.app/Pu94U00g/raw"))()
        end)

        if not ok or not result then
            return false
        end
        v5 = result
        flag7 = true
        return true
    end

    fn10 = function(arg)
        if arg then
            if not flag7 then
                fn27()
            end

            if v5 then
                if flag5 then
                    v5.ShowGUI()
                else
                    v5.Enable()
                end

                lib:Notify({
                    Title = "Dash Lock",
                    Description = "AKTIF - Klik kanan untuk lock",
                    Duration = 3,
                })
            end
        elseif v5 then
            if flag5 then
                v5.HideGUI()
            end

            v5.Disable()

            lib:Notify({
                Title = "Dash Lock",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    task.spawn(function()
        task.wait(2)
        fn27()
    end)

    local v6 = nil
    local flag8 = false

    local function fn28()
        if flag8 then
            return true
        end

        local ok, result = pcall(function()
            return loadstring(game:HttpGet("https://pastefy.app/NKuKyY5i/raw"))()
        end)

        if not ok or not result then
            return false
        end
        v6 = result
        flag8 = true
        return true
    end

    fn11 = function(arg)
        if arg then
            if not fn28() then
                lib:Notify({
                    Title = "Mask GUI",
                    Description = "Gagal load script!",
                    Duration = 3,
                })

                return
            end

            local v7, v8 = v6.Toggle(true)

            if v7 then
                local notify = lib.Notify
                local tbl7 = {Title = "Mask GUI"}
                local description = v8 or "Dimuat! (Tombol M)"
                tbl7.Description = description
                tbl7.Duration = 3
                notify(lib, tbl7)
            else
                local notify = lib.Notify
                local tbl7 = {Title = "Mask GUI"}
                local description = v8 or "Kamu bukan The Masked!"
                tbl7.Description = description
                tbl7.Duration = 3
                notify(lib, tbl7)
            end
        elseif flag8 and v6 then
            v6.Toggle(false)

            lib:Notify({
                Title = "Mask GUI",
                Description = "Disembunyikan",
                Duration = 2,
            })
        end
    end

    task.spawn(function()
        task.wait(2)
        fn28()
    end)

    getTargetPartObject = function(arg)
        if _G.Ox.AimConfig.AIM_TargetPart == "Head" then
            return arg:FindFirstChild("Head")
        end

        if _G.Ox.AimConfig.AIM_TargetPart == "Root" or _G.Ox.AimConfig.AIM_TargetPart == "HumanoidRootPart" then
            return arg:FindFirstChild("HumanoidRootPart")
        end
        local torso = arg:FindFirstChild("Torso")
        local upperTorso = torso or arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("HumanoidRootPart")
        return upperTorso
    end

    getClosestSurvivor = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local veilFov = _G.Ox.AimConfig.Veil_FOV
        local v7 = nil
        local currentCamera2 = workspace.CurrentCamera
        local vector2 = Vector2.new(currentCamera2.ViewportSize.X / 2, currentCamera2.ViewportSize.Y / 2)

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local character2 = player.Character
                local humanoid = character2:FindFirstChildOfClass("Humanoid")
                local v8 = getTargetPartObject(character2)

                if humanoid and humanoid.Health > 0 and v8 and (v8.Position - humanoidRootPart.Position).Magnitude <= _G.Ox.AimConfig.SPEAR_MaxDist then
                    local v9, v10 = currentCamera2:WorldToViewportPoint(v8.Position)

                    if v10 then
                        local magnitude = (Vector2.new(v9.X, v9.Y) - vector2).Magnitude

                        if magnitude <= veilFov then
                            veilFov = magnitude
                            v7 = v8
                        end
                    end
                end
            end
        end

        return v7
    end

    getBestAimbotTarget = function()
        local v7 = nil
        local v8 = GetRole()
        local survAimbotRadius = _G.Ox.Config.Surv_Aimbot_Radius
        local huge = math.huge
        local vector2 = Vector2.new(currentCamera.ViewportSize.X / 2, currentCamera.ViewportSize.Y / 2)

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local flag9 = false

                if v8 == "Survivor" and _G.Ox.Config.Surv_Aimbot_Enabled and IsKiller(player) then
                    flag9 = true
                elseif v8 == "Killer" and _G.Ox.Config.Killer_Aimbot_Enabled and not IsKiller(player) then
                    local humanoid = player.Character:FindFirstChild("Humanoid")

                    if humanoid and humanoid.Health > 0 and not IsDowned(player.Character) then
                        flag9 = true
                    end
                end

                if flag9 then
                    local humanoidRootPart = player.Character.HumanoidRootPart
                    local v9 = GetDistance(humanoidRootPart.Position)

                    if v8 == "Survivor" and v9 <= _G.Ox.Config.Surv_Aimbot_MaxDist then
                        local v10, v11 = currentCamera:WorldToViewportPoint(humanoidRootPart.Position)

                        if v11 then
                            local magnitude = (Vector2.new(v10.X, v10.Y) - vector2).Magnitude

                            if magnitude < survAimbotRadius then
                                survAimbotRadius = magnitude
                                v7 = humanoidRootPart
                            end
                        end
                    elseif v8 == "Killer" and v9 <= _G.Ox.Config.Killer_Aimbot_MaxDist and v9 < huge then
                        huge = v9
                        v7 = humanoidRootPart
                    end
                end
            end
        end

        return v7
    end

    getBestKillerAimbotTarget = function()
        local v7 = nil
        local huge = math.huge
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoid.Health > 0 and humanoidRootPart2 and not IsDowned(player.Character) then
                    local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                    if magnitude < huge and magnitude <= _G.Ox.Config.Killer_Aimbot_MaxDist then
                        huge = magnitude
                        v7 = humanoidRootPart2
                    end
                end
            end
        end

        return v7
    end

    getKillerTargetForFlash = function()
        local v7 = nil
        local huge = math.huge
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoid.Health > 0 and humanoidRootPart2 and not IsDowned(player.Character) then
                    local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v7 = humanoidRootPart2
                    end
                end
            end
        end

        return v7
    end

    NEX_UpdateCureFlaskLaser = function()
        local character = localPlayer.Character
        if not character then
            return
        end
        local position = nil
        local v7 = nil
        local v8 = nil
        local huge = math.huge
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart then
            local leftHand = character:FindFirstChild("LeftHand")
            local leftArm = leftHand or character:FindFirstChild("Left Arm")
            local position2 = leftArm and leftArm.Position or humanoidRootPart.Position
            v7 = position2

            for k, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not IsKiller(player) then
                    local magnitude = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v8 = player
                    end
                end
            end
        end

        if v8 then
            position = v8.Character.HumanoidRootPart.Position
        end

        local flag9 = false

        for k, child in pairs(character:GetChildren()) do
            if child:IsA("LocalScript") and child:GetAttribute("action") == true then
                flag9 = true
                break
            end
        end

        if v7 and position and flag9 then
            if not _G.Ox.NEX_CureFlaskLaserPart then
                local part = Instance.new("Part")
                part.Name = "FlaskSilentAimLaser"
                part.Anchored = true
                part.CanCollide = false
                part.CanTouch = false
                part.CastShadow = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 50, 50)
                part.Transparency = 0
                part.Parent = workspace
                _G.Ox.NEX_CureFlaskLaserPart = part
            end

            local magnitude = (position - v7).Magnitude

            if magnitude > 0.1 then
                local nexCureFlaskLaserPart = _G.Ox.NEX_CureFlaskLaserPart
                nexCureFlaskLaserPart.Size = Vector3.new(0.16, 0.16, magnitude)
                nexCureFlaskLaserPart.CFrame = CFrame.new((v7 + position) / 2, position)
                nexCureFlaskLaserPart.Transparency = 0
            end
        elseif _G.Ox.NEX_CureFlaskLaserPart then
            _G.Ox.NEX_CureFlaskLaserPart.Transparency = 1
        end
    end

    NEX_StartCureFlaskLaser = function()
        if _G.Ox.NEX_CureFlaskLaserThread then
            return
        end

        _G.Ox.NEX_CureFlaskLaserThread = RunService.RenderStepped:Connect(function()
            if not _G.Ox.KILLER_FlaskLaser then
                if _G.Ox.NEX_CureFlaskLaserPart then
                    pcall(function()
                        _G.Ox.NEX_CureFlaskLaserPart:Destroy()
                    end)

                    _G.Ox.NEX_CureFlaskLaserPart = nil
                end

                if _G.Ox.NEX_CureFlaskLaserThread then
                    _G.Ox.NEX_CureFlaskLaserThread:Disconnect()
                    _G.Ox.NEX_CureFlaskLaserThread = nil
                end

                return
            end

            pcall(NEX_UpdateCureFlaskLaser)
        end)
    end

    setupSpearInterceptor = function()
        if flag3 then
            return
        end

        if not getrawmetatable or not setreadonly then
            return
        end
        local spearthrow = nil

        pcall(function()
            spearthrow = ReplicatedStorage.Remotes.Killers.Veil.Spearthrow
        end)

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local fall = remotes and ReplicatedStorage.Remotes:FindFirstChild("Mechanics") and ReplicatedStorage.Remotes.Mechanics:FindFirstChild("Fall")

        local function fn29(arg, arg2, arg3, arg4)
            local n4 = math.max(arg3, 0.1)
            local n5 = arg * arg
            local n6 = n5 * n5 - arg2 * (arg2 * n4 * n4 + 2 * arg4 * n5)
            local n7 = n6

            if n6 < 0 then
                n7 = 0
            end

            local n8 = (n5 - math.sqrt(n7)) / (arg2 * n4)
            local v7 = math.atan(n8)
            return v7, n4 / (arg * math.cos(v7))
        end

        local v7 = getrawmetatable(game)
        setreadonly(v7, false)
        local namecall = v7.__namecall

        v7.__namecall = newcclosure(function(arg, ...)
            local v8 = getnamecallmethod()
            local flag9 = v8 == "FireServer" or v8 == "fireServer" or v8 == "InvokeServer"

            if flag9 and not checkcaller() and typeof(arg) == "Instance" then
                if _G.Ox.NoFall.Enabled and fall and arg == fall then
                    local tbl7 = {...}
                    tbl7[1] = 0
                    return namecall(arg, unpack(tbl7))
                end

                if _G.Ox.AntiBlindEnabled and _G.Ox.GotBlindedRemote and arg == _G.Ox.GotBlindedRemote and localPlayer.Team and localPlayer.Team.Name == "Killer" then
                    return nil
                end

                if _G.Ox.BulletBlockConfig.Enabled and arg.Name == "Fire" then
                    local parent = arg.Parent
                    if parent and parent.Name == "Twist of Fate" then
                        return nil
                    end
                end

                if _G.Ox.KILLER_SilentAimFlask and arg.Name == "ThrowFlask" then
                    local tbl7 = {...}
                    local v9 = nil
                    local huge = math.huge
                    local character = localPlayer.Character
                    local position = character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position

                    if position then
                        for k, player in pairs(Players:GetPlayers()) do
                            if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not IsKiller(player) then
                                local magnitude = (player.Character.HumanoidRootPart.Position - position).Magnitude

                                if magnitude < huge then
                                    huge = magnitude
                                    v9 = player
                                end
                            end
                        end
                    end

                    if v9 and tbl7[2] and typeof(tbl7[2]) == "Vector3" then
                        tbl7[1] = (v9.Character.HumanoidRootPart.Position - tbl7[2]).Unit
                        setnamecallmethod(v8)
                        return namecall(arg, unpack(tbl7))
                    end
                end

                if v8 == "FireServer" and typeof(arg) == "Instance" and string.lower(tostring(arg.Name)) == "updatecharacterlook" then
                    local ox4 = _G.Ox
                    local invisEnabled = ox4 and _G.Ox.Utility and _G.Ox.Utility.InvisEnabled

                    if invisEnabled then
                        local tbl7 = {}

                        for i, v9 in ipairs({...}) do
                            if typeof(v9) == "CFrame" then
                                tbl7[i] = v9 * CFrame.new(0, 5000, 0)
                            else
                                tbl7[i] = v9
                            end
                        end

                        return namecall(arg, unpack(tbl7))
                    end
                end

                if arg.ClassName == "RemoteEvent" and arg.Name == "Spearthrow" and _G.Ox.AimConfig.Aim_SilentVeilV2 and not flag2 then
                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    local v9 = character

                    if character then
                        local head = character:FindFirstChild("Head")
                        v9 = head or humanoidRootPart
                    end

                    local flag10 = character and character:GetAttribute("special") == true
                    local v10, v11

                    if flag10 then
                        local spearAuraSpeed = _G.Ox.AimConfig.SPEAR_AuraSpeed
                        local n4 = spearAuraSpeed or 165
                        v10 = n4
                        local spearAuraGravity = _G.Ox.AimConfig.SPEAR_AuraGravity
                        local n5 = spearAuraGravity or 96.5
                        v11 = n5
                    else
                        local spearSpeed = _G.Ox.AimConfig.SPEAR_Speed
                        local n4 = spearSpeed or 165
                        v10 = n4
                        local spearGravity = _G.Ox.AimConfig.SPEAR_Gravity
                        local n5 = spearGravity or 103
                        v11 = n5
                    end

                    local v12 = v10
                    local value = (select(3, ...))

                    if not (select(3, ...)) then
                        local spearSmartEnable = _G.Ox.Config.SpearSmart_enable
                        value = spearSmartEnable and humanoidRootPart and humanoidRootPart.Position
                    end

                    if not value then
                        value = v9 and v9.Position
                    end

                    local v13 = value
                    local n4 = (...)
                    local v14 = getClosestSurvivor()

                    if v14 and v13 then
                        local isModel = v14:IsA("Model")
                        local humanoidRootPart2 = isModel and v14:FindFirstChild("HumanoidRootPart") or v14
                        local position = humanoidRootPart2.Position
                        local vector = Vector3.new(0, 0, 0)
                        local parent = v14.Parent
                        local humanoid = parent and v14.Parent:FindFirstChildOfClass("Humanoid")

                        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                            vector = humanoid.MoveDirection * humanoid.WalkSpeed
                        elseif humanoidRootPart2:IsA("BasePart") then
                            vector = humanoidRootPart2.AssemblyLinearVelocity
                        end

                        local vector2 = Vector3.new(vector.X, 0, vector.Z)
                        local n5 = position - v13
                        local magnitude = n5.Magnitude
                        local magnitude2 = Vector3.new(n5.X, 0, n5.Z).Magnitude
                        local y = n5.Y

                        if magnitude > 0.1 then
                            local spearMaxDist = _G.Ox.AimConfig.SPEAR_MaxDist
                            local n6 = spearMaxDist or 1000

                            if magnitude <= n6 then
                                local veilLeadMultiplier = _G.Ox.AimConfig.Veil_LeadMultiplier
                                local n7 = veilLeadMultiplier or 1.4
                                local v15, v16 = fn29(v10, v11, magnitude2, y)

                                if _G.Ox.Config.SpearSmart_enable and vector2.Magnitude > 0.5 then
                                    local n8 = vector2 * (v16 * n7)
                                    local n9 = n8
                                    local n10 = math.clamp(magnitude * 0.6, 3, 45)

                                    if n10 < n8.Magnitude then
                                        n9 = n8.Unit * n10
                                    end

                                    local n11 = position + n9 - v13
                                    local magnitude3 = Vector3.new(n11.X, 0, n11.Z).Magnitude
                                    local value2 = select(1, fn29(v10, v11, math.max(magnitude3, 0.1), n11.Y))

                                    if magnitude3 > 0.001 then
                                        n4 = Vector3.new(n11.X, 0, n11.Z).Unit * math.cos(value2) + Vector3.new(0, math.sin(value2), 0)
                                    else
                                        n4 = n11.Unit
                                    end
                                else
                                    local value2 = select(1, fn29(v10, v11, math.max(magnitude2, 0.1), y))

                                    if magnitude2 > 0.001 then
                                        n4 = Vector3.new(n5.X, 0, n5.Z).Unit * math.cos(value2) + Vector3.new(0, math.sin(value2), 0)
                                    else
                                        n4 = n5.Unit
                                    end
                                end
                            end
                        end
                    end

                    flag2 = true

                    pcall(function()
                        if spearthrow then
                            spearthrow:FireServer(n4, v12, v13)
                        else
                            arg:FireServer(n4, v12, v13)
                        end
                    end)

                    flag2 = false
                    return
                end
            end

            return namecall(arg, ...)
        end)

        setreadonly(v7, true)
        flag3 = true
    end

    local function fn29()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local items = remotes and ReplicatedStorage.Remotes:FindFirstChild("Items")
        local flashlight = items and items:FindFirstChild("Flashlight")

        if flashlight then
            _G.Ox.GotBlindedRemote = flashlight:FindFirstChild("GotBlinded")
        end
    end

    task.spawn(function()
        task.wait(1)
        fn29()
        setupSpearInterceptor()
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        fn29()
    end)
end

local tbl5, fn12, fn13, fn14, fn15, fn16, fn17, fn18, fn19, fn20, fn21, fn22

do
    local v3 = Connections
    tbl5 = v3 or {}

    fn12 = function()
        if tbl5.LeapBypass then
            task.cancel(tbl5.LeapBypass)
            tbl5.LeapBypass = nil
        end

        tbl5.LeapBypass = task.spawn(function()
            local v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23
            local v24, v25, v26, v27, v28, n
            n = 1

            while true do
                if n == 1 then
                    v4 = nil
                    v5 = nil
                    v6, v7, v8 = pairs(getgc(true))
                    v9 = v8
                    n = 2
                elseif n == 2 then
                    v10, v11 = v6(v7, v9)

                    if v10 == nil then
                        n = 9
                    else
                        n = 3
                    end
                elseif n == 3 then
                    v9 = v10

                    if type(v11) == "function" and islclosure(v11) then
                        n = 4
                    else
                        n = 2
                    end
                elseif n == 4 then
                    v12 = debug.getinfo(v11)

                    if v12.name == "tryActivate" then
                        n = 5
                    else
                        n = 6
                    end
                elseif n == 5 then
                    v4 = v11
                    n = 6
                elseif n == 6 then
                    if v12.name == "playM2Animation" then
                        n = 7
                    else
                        n = 8
                    end
                elseif n == 7 then
                    v5 = v11
                    n = 8
                elseif n == 8 then
                    if v4 and v5 then
                        n = 9
                    else
                        n = 2
                    end
                elseif n == 9 then
                    if not v4 and not v5 then
                        n = 20
                    else
                        n = 10
                    end
                elseif n == 10 then
                    if task.wait(0.1) and _G.Ox.BypassLeapEnabled then
                        n = 12
                    else
                        n = 11
                    end
                elseif n == 11 then
                    return
                elseif n == 12 then
                    v13, v14, v15 = pairs({v4, v5})
                    v16 = v15
                    v17 = v13
                    v18 = v14
                    n = 13
                elseif n == 13 then
                    v19, v20 = v17(v18, v16)

                    if v19 == nil then
                        n = 10
                    else
                        n = 14
                    end
                elseif n == 14 then
                    v16 = v19

                    if v20 then
                        n = 15
                    else
                        n = 13
                    end
                elseif n == 15 then
                    v21, v22, v23 = pairs(debug.getupvalues(v20))
                    v24 = v17
                    v25 = v18
                    v26 = v23
                    n = 16
                elseif n == 16 then
                    v27, v28 = v21(v22, v26)

                    if v27 == nil then
                        n = 19
                    else
                        n = 17
                    end
                elseif n == 17 then
                    v26 = v27

                    if type(v28) == "boolean" and v28 == true then
                        n = 18
                    else
                        n = 16
                    end
                elseif n == 18 then
                    debug.setupvalue(v20, v27, false)
                    n = 16
                elseif n == 19 then
                    v16 = v19
                    v17 = v24
                    v18 = v25
                    n = 13
                elseif n == 20 then
                    warn("[BypassLeap] Function tidak ditemukan.")
                    return
                end
            end
        end)
    end

    local flag2 = false

    local function fn23()
        if GetRole() ~= "Killer" then
            return
        end
        local selectedKiller = localPlayer:FindFirstChild("SelectedKiller")
        local attribute = selectedKiller and selectedKiller.Value or localPlayer:GetAttribute("SelectedKiller")

        if attribute and string.find(string.lower(tostring(attribute)), "abyss") then
            pcall(function()
                local corrupt = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Killers"):FindFirstChild("Abysswalker"):FindFirstChild("corrupt")

                if corrupt then
                    corrupt:FireServer()
                end
            end)
        end
    end

    local function fn24()
        if flag2 then
            return
        end
        flag2 = true

        task.spawn(function()
            while flag2 and _G.Ox.InfAbyssalEnabled and GetRole() == "Killer" do
                fn23()
                task.wait(0.5)
            end
        end)
    end

    fn13 = function()
        flag2 = false
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        if _G.Ox.InfAbyssalEnabled and input.KeyCode == Enum.KeyCode.Q then
            fn24()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Q then
            fn13()
        end
    end)

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(0.5)
            if not _G.Ox.ScriptAlive then
                break
            end

            if _G.Ox.InfAbyssalEnabled and GetRole() == "Killer" then
                local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

                if playerGui2 then
                    local v4 = nil

                    for k, child in pairs(playerGui2:GetChildren()) do
                        if string.sub(child.Name, -4) == "-mob" and child.Name ~= "Survivor-mob" then
                            v4 = child
                            break
                        end
                    end

                    if v4 then
                        local controls = v4:FindFirstChild("Controls")

                        if controls then
                            local move2 = controls:FindFirstChild("move2")

                            if move2 and move2.Visible then
                                fn24()
                            else
                                fn13()
                            end
                        end
                    end
                end
            else
                fn13()
            end
        end
    end)

    EnableInfiniteLunge = function()
        _G.Ox.InfiniteLungeEnabled = true
        local character = localPlayer.Character

        if character then
            character:SetAttribute("lungeboost", 999)

            if _G.Ox.InfLungeAttrConn then
                _G.Ox.InfLungeAttrConn:Disconnect()
            end

            _G.Ox.InfLungeAttrConn = character:GetAttributeChangedSignal("lungeboost"):Connect(function()
                if _G.Ox.InfiniteLungeEnabled and character:GetAttribute("lungeboost") ~= 999 then
                    character:SetAttribute("lungeboost", 999)
                end
            end)
        end

        lib:Notify({
            Title = "Infinite Lunge",
            Description = "AKTIF (999x)",
            Duration = 3,
        })
    end

    DisableInfiniteLunge = function()
        _G.Ox.InfiniteLungeEnabled = false

        if _G.Ox.InfLungeAttrConn then
            _G.Ox.InfLungeAttrConn:Disconnect()
            _G.Ox.InfLungeAttrConn = nil
        end

        local character = localPlayer.Character

        if character then
            character:SetAttribute("lungeboost", 1)
        end

        lib:Notify({
            Title = "Infinite Lunge",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end

    localPlayer.CharacterAdded:Connect(function(character)
        task.wait(0.8)

        if _G.Ox.InfiniteLungeEnabled and character then
            character:SetAttribute("lungeboost", 999)
        end
    end)

    StopCounterParry = function()
        _G.Ox.CounterParry.Enabled = false

        if _G.Ox.CounterParry.Thread then
            task.cancel(_G.Ox.CounterParry.Thread)
            _G.Ox.CounterParry.Thread = nil
        end

        if _G.Ox.CounterParry.Track then
            pcall(function()
                _G.Ox.CounterParry.Track:Stop()
            end)

            _G.Ox.CounterParry.Track = nil
        end
    end

    StartCounterParry = function()
        if _G.Ox.CounterParry.Thread then
            return
        end

        _G.Ox.CounterParry.Thread = task.spawn(function()
            local character, humanoid, animator, humanoidRootPart, animation, ok, track, flag3, distance, v4, v5, v6, v7, v8, v9, character2, humanoidRootPart2, n
            n = 1

            while true do
                if n == 1 then
                    if _G.Ox.CounterParry.Enabled and _G.Ox.ScriptAlive then
                        n = 3
                    else
                        n = 2
                    end
                elseif n == 2 then
                    _G.Ox.CounterParry.Thread = nil
                    return
                elseif n == 3 then
                    character = localPlayer.Character

                    if character and character.Parent and GetRole() == "Killer" then
                        n = 5
                    else
                        n = 4
                    end
                elseif n == 4 then
                    task.wait(0.4)
                    n = 1
                elseif n == 5 then
                    humanoid = character:FindFirstChildOfClass("Humanoid")
                    animator = humanoid

                    if humanoid then
                        n = 6
                    else
                        n = 7
                    end
                elseif n == 6 then
                    animator = humanoid:FindFirstChildOfClass("Animator")
                    n = 7
                elseif n == 7 then
                    humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                    if animator and humanoidRootPart then
                        n = 9
                    else
                        n = 8
                    end
                elseif n == 8 then
                    task.wait(0.3)
                    n = 1
                elseif n == 9 then
                    if _G.Ox.CounterParry.Track and _G.Ox.CounterParry.Track.Parent ~= nil then
                        n = 13
                    else
                        n = 10
                    end
                elseif n == 10 then
                    animation = Instance.new("Animation")
                    animation.AnimationId = _G.Ox.CounterParry.AnimId

                    ok, track = pcall(function()
                        return animator:LoadAnimation(animation)
                    end)

                    if ok and track then
                        n = 12
                    else
                        n = 11
                    end
                elseif n == 11 then
                    task.wait(0.5)
                    n = 1
                elseif n == 12 then
                    _G.Ox.CounterParry.Track = track
                    n = 13
                elseif n == 13 then
                    flag3 = false
                    distance = _G.Ox.CounterParry.Distance
                    v4, v5, v6 = ipairs(Players:GetPlayers())
                    v7 = v6
                    n = 14
                elseif n == 14 then
                    v8, v9 = v4(v5, v7)

                    if v8 == nil then
                        n = 20
                    else
                        n = 15
                    end
                elseif n == 15 then
                    v7 = v8

                    if v9 ~= localPlayer and v9.Team and v9.Team.Name == "Survivors" then
                        n = 16
                    else
                        n = 14
                    end
                elseif n == 16 then
                    character2 = v9.Character
                    humanoidRootPart2 = character2

                    if character2 then
                        n = 17
                    else
                        n = 18
                    end
                elseif n == 17 then
                    humanoidRootPart2 = v9.Character:FindFirstChild("HumanoidRootPart")
                    n = 18
                elseif n == 18 then
                    if humanoidRootPart2 and (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude <= distance then
                        n = 19
                    else
                        n = 14
                    end
                elseif n == 19 then
                    flag3 = true
                    n = 20
                elseif n == 20 then
                    if flag3 and _G.Ox.CounterParry.Track then
                        n = 21
                    else
                        n = 22
                    end
                elseif n == 21 then
                    pcall(function()
                        _G.Ox.CounterParry.Track:Play()
                        _G.Ox.CounterParry.Track:AdjustWeight(0)
                    end)

                    task.wait(0.05)

                    pcall(function()
                        _G.Ox.CounterParry.Track:Stop()
                    end)

                    n = 22
                elseif n == 22 then
                    task.wait(_G.Ox.CounterParry.Interval)
                    n = 1
                end
            end
        end)
    end

    ToggleCounterParry = function(arg)
        if arg then
            if GetRole() ~= "Killer" then
                lib:Notify({
                    Title = "Counter Auto Parry",
                    Description = "Khusus Killer!",
                    Duration = 3,
                })

                _G.Ox.CounterParry.Enabled = false

                if CounterParryToggle then
                    fn(CounterParryToggle, false)
                end

                return
            end

            _G.Ox.CounterParry.Enabled = true
            StartCounterParry()

            lib:Notify({
                Title = "Counter Auto Parry",
                Description = "AKTIF",
                Duration = 2,
            })
        else
            StopCounterParry()

            lib:Notify({
                Title = "Counter Auto Parry",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        _G.Ox.CounterParry.Track = nil
        task.wait(1)

        if _G.Ox.CounterParry.Enabled then
            StartCounterParry()
        end
    end)

    local function fn25()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local killers = remotes and remotes:FindFirstChild("Killers")
        local stalker = killers and killers:FindFirstChild("Stalker")
        local startStalking = stalker and stalker:FindFirstChild("StartStalking")
        return startStalking
    end

    local function fn26()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local v4 = nil
        local huge = math.huge
        local range = _G.Ox.AutoStalk.Range

        for i, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                if humanoid and humanoidRootPart2 and humanoid.Health > 30 then
                    local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                    if magnitude <= range and magnitude < huge then
                        huge = magnitude
                        v4 = player
                    end
                end
            end
        end

        return v4
    end

    StopAutoStalk = function()
        _G.Ox.AutoStalk.Enabled = false

        if _G.Ox.AutoStalk.Conn then
            _G.Ox.AutoStalk.Conn:Disconnect()
            _G.Ox.AutoStalk.Conn = nil
        end
    end

    StartAutoStalk = function()
        if _G.Ox.AutoStalk.Conn then
            return
        end

        _G.Ox.AutoStalk.Conn = RunService.Heartbeat:Connect(function()
            if not _G.Ox.AutoStalk.Enabled or not _G.Ox.ScriptAlive then
                return
            end

            if GetRole() ~= "Killer" then
                return
            end
            local now = tick()
            local lastFire = _G.Ox.AutoStalk.LastFire
            local n = lastFire or 0
            if now - n < 0.35 then
                return
            end
            local v4 = fn26()
            if not v4 or not v4.Character then
                return
            end
            local v5 = fn25()

            if v5 then
                _G.Ox.AutoStalk.LastFire = now

                pcall(function()
                    v5:FireServer(v4)
                end)
            end
        end)
    end

    ToggleAutoStalk = function(arg)
        if arg then
            if GetRole() ~= "Killer" then
                lib:Notify({
                    Title = "Auto Stalk",
                    Description = "Khusus Killer!",
                    Duration = 3,
                })

                _G.Ox.AutoStalk.Enabled = false

                if AutoStalkToggle then
                    fn(AutoStalkToggle, false)
                end

                return
            end

            _G.Ox.AutoStalk.Enabled = true
            StartAutoStalk()
            lib:Notify({Title = "Auto Stalk", Description = "AKTIF", Duration = 2})
        else
            StopAutoStalk()

            lib:Notify({
                Title = "Auto Stalk",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FOVCircleGui_Standalone"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = CoreGui
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    frame.Visible = false
    frame.Parent = screenGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
    local uiStroke = Instance.new("UIStroke", frame)
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 1.5
    local highlight = Instance.new("Highlight")
    highlight.Name = "VD_VeilTarget"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    local v4 = nil

    local function fn27()
        if v4 then
            pcall(function()
                v4:Destroy()
            end)

            v4 = nil
        end
    end

    local function fn28(arg, arg2)
        if arg and arg2 then
            local magnitude = (arg2 - arg).Magnitude

            if magnitude < 0.2 then
                if v4 then
                    v4.Transparency = 1
                end

                return
            end

            if not v4 then
                local part = Instance.new("Part")
                part.Name = "VeilTrackerLine"
                part.Anchored = true
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
                part.CastShadow = false
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(255, 255, 255)
                part.Parent = workspace
                v4 = part
            end

            local vector = Vector3.new(0.08, 0.08, magnitude)
            v4.Size = vector
            local cframe = CFrame.new((arg + arg2) / 2, arg2)
            v4.CFrame = cframe
            v4.Transparency = 0.15
            return
        end

        if v4 then
            v4.Transparency = 1
        end
    end

    _G.Ox.SurvivorFOVGui = Instance.new("ScreenGui")
    _G.Ox.SurvivorFOVGui.Name = "SurvivorAimbotFOV"
    _G.Ox.SurvivorFOVGui.ResetOnSpawn = false
    _G.Ox.SurvivorFOVGui.IgnoreGuiInset = true
    _G.Ox.SurvivorFOVGui.Parent = CoreGui
    _G.Ox.SurvivorFOVFrame = Instance.new("Frame")
    _G.Ox.SurvivorFOVFrame.BackgroundTransparency = 1
    _G.Ox.SurvivorFOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _G.Ox.SurvivorFOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    _G.Ox.SurvivorFOVFrame.Visible = false
    _G.Ox.SurvivorFOVFrame.Parent = _G.Ox.SurvivorFOVGui
    Instance.new("UICorner", _G.Ox.SurvivorFOVFrame).CornerRadius = UDim.new(1, 0)
    local uiStroke2 = Instance.new("UIStroke", _G.Ox.SurvivorFOVFrame)
    uiStroke2.Color = Color3.fromRGB(255, 255, 255)
    uiStroke2.Thickness = 1.5
    uiStroke2.Transparency = 0.5
    _G.Ox.survivorAimbotHighlight = Instance.new("Highlight")
    _G.Ox.survivorAimbotHighlight.Name = "SurvivorAimbotTarget"
    _G.Ox.survivorAimbotHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    _G.Ox.survivorAimbotHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    _G.Ox.survivorAimbotHighlight.FillTransparency = 0.4
    _G.Ox.survivorAimbotHighlight.OutlineTransparency = 0.2
    _G.Ox.killerAimbotHighlight = Instance.new("Highlight")
    _G.Ox.killerAimbotHighlight.Name = "KillerAimbotTarget"
    _G.Ox.killerAimbotHighlight.FillColor = Color3.fromRGB(255, 0, 0)
    _G.Ox.killerAimbotHighlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    _G.Ox.killerAimbotHighlight.FillTransparency = 0.4
    _G.Ox.killerAimbotHighlight.OutlineTransparency = 0.2

    StopMoonwalk = function()
        _G.Ox.Moonwalk.Enabled = false
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.AutoRotate = true
        end
    end

    StartMoonwalk = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoidRootPart or not humanoid then
            return
        end
        humanoid.AutoRotate = false
        _G.Ox.Moonwalk.Enabled = true
    end

    UpdateMoonwalkGUI = function(arg)
        if not _G.Ox.Moonwalk.Gui then
            return
        end
        local frame2 = _G.Ox.Moonwalk.Gui:FindFirstChild("Frame")
        if not frame2 then
            return
        end
        local actionButton = frame2:FindFirstChild("ActionButton")
        local uiStroke3 = frame2:FindFirstChild("UIStroke")

        if arg then
            if actionButton then
                actionButton.Text = "MOON [ON]"
                actionButton.TextColor3 = Color3.fromRGB(180, 255, 180)
                actionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end

            if uiStroke3 then
                uiStroke3.Color = Color3.fromRGB(100, 200, 100)
            end
        else
            if actionButton then
                actionButton.Text = "MOON [OFF]"
                actionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                actionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            end

            if uiStroke3 then
                uiStroke3.Color = Color3.fromRGB(90, 90, 95)
            end
        end
    end

    ToggleMoonwalkStatus = function()
        if _G.Ox.Moonwalk.Enabled then
            StopMoonwalk()
        else
            StartMoonwalk()
        end

        _G.Ox.Moonwalk.IsActive = _G.Ox.Moonwalk.Enabled
        UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)

        if MoonwalkPCToggle then
            fn(MoonwalkPCToggle, _G.Ox.Moonwalk.Enabled)
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Moonwalk"}
        local enabled = _G.Ox.Moonwalk.Enabled
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    CreateMoonwalkGUI = function()
        if _G.Ox.Moonwalk.Gui then
            _G.Ox.Moonwalk.Gui:Destroy()
        end

        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "MoonwalkCustomGui"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui2.Parent = CoreGui
        screenGui2.Enabled = false
        _G.Ox.Moonwalk.Gui = screenGui2
        _G.Ox.Moonwalk.GuiVisible = false
        local frame2 = Instance.new("Frame", screenGui2)
        frame2.Name = "Frame"
        frame2.Size = UDim2.fromOffset(110, 36)
        frame2.Position = UDim2.fromScale(0.85, 0.45)
        frame2.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        frame2.BackgroundTransparency = 0.1
        frame2.Active = true
        frame2.BorderSizePixel = 0
        Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 8)
        local uiStroke3 = Instance.new("UIStroke", frame2)
        uiStroke3.Name = "UIStroke"
        uiStroke3.Color = Color3.fromRGB(90, 90, 95)
        uiStroke3.Thickness = 1.5
        uiStroke3.Transparency = 0.2
        local textButton = Instance.new("TextButton", frame2)
        textButton.Name = "ActionButton"
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.Text = "MOON [OFF]"
        textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 12
        textButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        textButton.BorderSizePixel = 0
        textButton.AutoButtonColor = false
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
        local flag3 = false
        local flag4 = false
        local flag5 = false
        local position = nil
        local position2 = nil
        local thread = nil

        local function fn29(arg)
            if not flag3 or not flag5 or not position or not position2 then
                return
            end
            local n = arg.Position - position

            if not flag4 and (math.abs(n.X) > 18 or math.abs(n.Y) > 18) then
                flag4 = true
            end

            if flag4 then
                frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
            end
        end

        textButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag3 = true
                flag4 = false
                flag5 = false
                position = input.Position
                position2 = frame2.Position

                if thread then
                    task.cancel(thread)
                end

                thread = task.delay(0.18, function()
                    if flag3 then
                        flag5 = true
                    end
                end)
            end
        end)

        textButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if thread then
                    task.cancel(thread)
                end

                if flag3 and not flag4 then
                    ToggleMoonwalkStatus()
                end

                flag3 = false
                flag4 = false
                flag5 = false
                position = nil
                position2 = nil
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if flag3 and flag5 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                fn29(input)
            end
        end)

        if _G.Ox.Moonwalk._statusConn then
            _G.Ox.Moonwalk._statusConn:Disconnect()
        end

        _G.Ox.Moonwalk._statusConn = RunService.Heartbeat:Connect(function()
            if _G.Ox.Moonwalk.Gui and _G.Ox.Moonwalk.Gui.Parent then
                if _G.Ox.Moonwalk.IsActive ~= _G.Ox.Moonwalk.Enabled then
                    _G.Ox.Moonwalk.IsActive = _G.Ox.Moonwalk.Enabled
                    UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)
                end

                return
            end

            if _G.Ox.Moonwalk._statusConn then
                _G.Ox.Moonwalk._statusConn:Disconnect()
            end
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.Moonwalk.Enabled then
            StartMoonwalk()
        end

        if _G.Ox.Moonwalk.GuiVisible and _G.Ox.Moonwalk.Gui then
            _G.Ox.Moonwalk.Gui.Enabled = true
            UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)
        end
    end)

    task.spawn(function()
        task.wait(1.5)
        CreateMoonwalkGUI()
    end)

    RunService.RenderStepped:Connect(function(deltaTime)
        if not _G.Ox.Speed.Enabled and not _G.Ox.Moonwalk.Enabled and not _G.Ox.Crosshair.Enabled and not _G.Ox.StretchRes.Enabled and not _G.Ox.Config.Surv_Aimbot_Enabled and (not _G.Ox.Config.Killer_Aimbot_Enabled or not _G.Ox.isKillerAimbotHolding) and not _G.Ox.AimConfig.Aim_SilentVeilV2 and (not flag or not _G.Ox.AimConfig.Flash_Silent) then
            return
        end

        if _G.Ox.Crosshair.Enabled then
            DrawCrosshair()
        end

        if _G.Ox.Speed.Enabled then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    local moveDirection = humanoid.MoveDirection

                    if moveDirection.Magnitude > 0 then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            local n = (_G.Ox.Speed.Value - 0.1) * 10

                            if n > 0 then
                                humanoidRootPart.CFrame = humanoidRootPart.CFrame + moveDirection * n * deltaTime
                            end
                        end
                    end
                end
            end
        end

        if _G.Ox.Moonwalk.Enabled then
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local currentCamera2 = workspace.CurrentCamera

            if humanoidRootPart and humanoid and currentCamera2 then
                if humanoid.AutoRotate ~= false then
                    humanoid.AutoRotate = false
                end

                local vector = Vector3.new(currentCamera2.CFrame.LookVector.X, 0, currentCamera2.CFrame.LookVector.Z)
                local unit = vector
                local vector2 = Vector3.new(currentCamera2.CFrame.RightVector.X, 0, currentCamera2.CFrame.RightVector.Z)
                local unit2 = vector2

                if vector.Magnitude > 0.001 then
                    unit = vector.Unit
                end

                if vector2.Magnitude > 0.001 then
                    unit2 = vector2.Unit
                end

                local v5 = math.sin(tick() * 35)
                local n = CFrame.Angles(0, math.rad(30 * v5), 0) * unit
                humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + n)
                humanoid:Move(-unit * 1.2 + unit2 * (v5 * 1.05), false)
            end
        end

        if _G.Ox.StretchRes.Enabled and currentCamera then
            currentCamera.CFrame = currentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, _G.Ox.StretchRes.Amount, 0, 0, 0, 1)
        end

        if flag and _G.Ox.AimConfig.Flash_Silent then
            local v5 = getKillerTargetForFlash()

            if v5 then
                local character = localPlayer.Character
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local n = v5.Position + Vector3.new(0, _G.Ox.AimConfig.Flash_YOffset, 0)
                local currentCamera2 = workspace.CurrentCamera
                currentCamera2.CFrame = currentCamera2.CFrame:Lerp(CFrame.lookAt(currentCamera2.CFrame.Position, n), 0.5)

                if humanoidRootPart then
                    local cframe = CFrame.lookAt(humanoidRootPart.Position, Vector3.new(n.X, humanoidRootPart.Position.Y, n.Z))
                    humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(cframe, 0.5)
                end
            end
        end

        if _G.Ox.Config.Surv_Aimbot_Enabled then
            if GetRole() == "Survivor" then
                if _G.Ox.Config.Surv_Aimbot_ShowFOV then
                    _G.Ox.SurvivorFOVFrame.Visible = true
                    _G.Ox.SurvivorFOVFrame.Size = UDim2.new(0, _G.Ox.Config.Surv_Aimbot_Radius * 2, 0, _G.Ox.Config.Surv_Aimbot_Radius * 2)
                else
                    _G.Ox.SurvivorFOVFrame.Visible = false
                end

                local v5 = getBestAimbotTarget()

                if v5 then
                    _G.Ox.survivorAimbotHighlight.Parent = v5.Parent
                    local position = v5.Position
                    local n = position
                    local v6 = GetDistance(position)

                    if v6 < 100 then
                        n = position + currentCamera.CFrame.RightVector * ((100 - v6) * _G.Ox.Config.Surv_Aimbot_Predict)
                    end

                    local cframe = CFrame.new(currentCamera.CFrame.Position, n)
                    currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, _G.Ox.Config.Surv_Aimbot_Smoothness)
                    local character = localPlayer.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart then
                        local cframe2 = CFrame.new(humanoidRootPart.Position, Vector3.new(n.X, humanoidRootPart.Position.Y, n.Z))
                        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(cframe2, _G.Ox.Config.Surv_Aimbot_Smoothness)
                    end
                else
                    _G.Ox.survivorAimbotHighlight.Parent = nil
                end
            end
        else
            _G.Ox.SurvivorFOVFrame.Visible = false
            _G.Ox.survivorAimbotHighlight.Parent = nil
        end

        if _G.Ox.Config.Killer_Aimbot_Enabled and _G.Ox.isKillerAimbotHolding then
            if GetRole() == "Killer" then
                if _G.Ox.lockedKillerAimbotTarget then
                    local parent = _G.Ox.lockedKillerAimbotTarget.Parent
                    local humanoid = parent and parent:FindFirstChild("Humanoid")

                    if not humanoid or humanoid.Health <= 0 or IsDowned(parent) then
                        _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()
                    end

                    if _G.Ox.lockedKillerAimbotTarget then
                        local position = _G.Ox.lockedKillerAimbotTarget.Position
                        local v5 = GetDistance(position)

                        if _G.Ox.Config.Killer_Aimbot_MaxDist < v5 then
                            _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()
                        else
                            _G.Ox.killerAimbotHighlight.Parent = parent
                            local cframe = CFrame.new(currentCamera.CFrame.Position, position)
                            currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, _G.Ox.Config.Killer_Aimbot_Smoothness)
                            local character = localPlayer.Character
                            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                            if humanoidRootPart then
                                local cframe2 = CFrame.new(humanoidRootPart.Position, Vector3.new(position.X, humanoidRootPart.Position.Y, position.Z))
                                humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(cframe2, _G.Ox.Config.Killer_Aimbot_Smoothness)
                            end
                        end
                    end
                else
                    _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()
                end
            end
        elseif _G.Ox.killerAimbotHighlight then
            _G.Ox.killerAimbotHighlight.Parent = nil
        end

        local character = localPlayer.Character
        local flag3 = character and character:GetAttribute("spearmode") == true
        local aimSilentVeilV2 = _G.Ox.AimConfig.Aim_SilentVeilV2
        local v5 = aimSilentVeilV2 and flag3
        local veilShowFOV = v5 and _G.Ox.AimConfig.Veil_ShowFOV

        if veilShowFOV then
            frame.Visible = true
            frame.Size = UDim2.new(0, _G.Ox.AimConfig.Veil_FOV * 2, 0, _G.Ox.AimConfig.Veil_FOV * 2)
        else
            frame.Visible = false
        end

        if veilShowFOV then
            local v6 = getClosestSurvivor()

            if v6 and v6.Parent then
                highlight.Parent = v6.Parent
                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                local v7 = character

                if character then
                    local head = character:FindFirstChild("Head")
                    v7 = head or humanoidRootPart
                end

                local position = v7 and v7.Position
                fn28(position, v6.Position)
            else
                highlight.Parent = nil
                fn28(nil, nil)
            end
        else
            highlight.Parent = nil
            fn28(nil, nil)

            if not v5 then
                fn27()
            end
        end
    end)

    local n = 0

    RunService.Heartbeat:Connect(function()
        if _G.Ox.ParryConfig.ParryCircle and _G.Ox.ParryConfig.AutoParry then
            local character = localPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                if not _G.Ox.State.AutoParryAdornment or _G.Ox.State.AutoParryAdornment.Parent ~= humanoidRootPart then
                    if _G.Ox.State.AutoParryAdornment then
                        _G.Ox.State.AutoParryAdornment:Destroy()
                    end

                    _G.Ox.State.AutoParryAdornment = Instance.new("CylinderHandleAdornment")
                    _G.Ox.State.AutoParryAdornment.Name = "AutoParryCircleESP"
                    _G.Ox.State.AutoParryAdornment.Height = 0.05
                    _G.Ox.State.AutoParryAdornment.Transparency = 0.3
                    _G.Ox.State.AutoParryAdornment.Adornee = humanoidRootPart
                    _G.Ox.State.AutoParryAdornment.Parent = humanoidRootPart
                    _G.Ox.State.AutoParryAdornment.ZIndex = 0
                    _G.Ox.State.AutoParryAdornment.AlwaysOnTop = false
                end

                local parryRadius = _G.Ox.ParryConfig.ParryRadius
                _G.Ox.State.AutoParryAdornment.Radius = parryRadius
                _G.Ox.State.AutoParryAdornment.InnerRadius = math.max(0.1, parryRadius - 0.15)
                _G.Ox.State.AutoParryAdornment.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(math.rad(90), 0, 0)

                if _G.Ox.State.ParryCooldown then
                    _G.Ox.State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 128, 0)
                elseif _G.Ox.ParryConfig.ParryAggressive then
                    _G.Ox.State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 0, 0)
                else
                    _G.Ox.State.AutoParryAdornment.Color3 = Color3.fromRGB(255, 255, 255)
                end
            elseif _G.Ox.State.AutoParryAdornment then
                _G.Ox.State.AutoParryAdornment:Destroy()
                _G.Ox.State.AutoParryAdornment = nil
            end
        elseif _G.Ox.State.AutoParryAdornment then
            _G.Ox.State.AutoParryAdornment:Destroy()
            _G.Ox.State.AutoParryAdornment = nil
        end

        if _G.Ox.GodMode then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end

        if _G.Ox.AutoPallet.Enabled then
            for k in pairs(_G.Ox.AutoPallet.UsedPallets) do
                if not k or not k.Parent then
                    _G.Ox.AutoPallet.UsedPallets[k] = nil
                end
            end
        end

        if _G.Ox.CameraFOV.Enabled then
            currentCamera.FieldOfView = _G.Ox.CameraFOV.Value
        end

        if _G.Ox.NoSlowdownEnabled then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid and GetRole() == "Killer" and humanoid.WalkSpeed < 16 then
                    humanoid.WalkSpeed = 16
                end
            end
        end

        if _G.Ox.ESPConfig.Master and tick() - n >= 2 then
            n = tick()
            UpdatePlayerESP()
            UpdateSCPESP()
            UpdateStaticESP()
        end
    end)

    local items = ReplicatedStorage:WaitForChild("Items", 5)

    extractAssetId = function(arg)
        return tostring(arg):match("%d+")
    end

    getItemIcon = function(arg)
        if not items then
            return nil
        end
        local v5 = items:FindFirstChild(arg)
        if not v5 then
            return nil
        end
        local v6 = nil

        pcall(function()
            local texture = v5.Texture
            local image = texture or v5.Image
            v6 = image
        end)

        if v6 and v6 ~= "" then
            local v7 = extractAssetId(v6)
            if v7 then
                return string.format("rbxthumb://type=Asset&id=%s&w=420&h=420", v7)
            end
        end

        return nil
    end

    CreateModernESP = function(parent, name, arg)
        if not parent then
            return
        end
        local name2 = arg.name
        local str = name2 or ""
        local flag3 = str ~= ""
        local flag4 = name ~= "PE_Text"

        if not flag4 then
            if flag3 then
                flag4 = false
            else
                flag4 = true
            end
        end

        local str2 = flag4 and "single" or "multi"
        local infoRich = arg.infoRich
        local text = infoRich or ""

        if text == "" then
            local tbl6 = {}

            if arg.subtext and arg.subtext ~= "" then
                table.insert(tbl6, tostring(arg.subtext))
            end

            if arg.distance then
                table.insert(tbl6, tostring(arg.distance) .. "m")
            end

            text = table.concat(tbl6, " <font color=\"#888888\">·</font> ")
        end

        local v5 = parent:FindFirstChild(name)
        local v6 = v5

        if v5 and v5:GetAttribute("Layout") ~= str2 then
            v5:Destroy()
            v6 = nil
        end

        if not v6 then
            local billboardGui = Instance.new("BillboardGui")
            v6 = billboardGui
            billboardGui.Name = name
            billboardGui.AlwaysOnTop = true
            billboardGui:SetAttribute("Layout", str2)
            local udim2 = flag4 and UDim2.new(0, 220, 0, 22) or UDim2.new(0, 220, 0, 34)
            billboardGui.Size = udim2
            local vector = Vector3.new
            local offsetY = arg.offsetY
            local n2 = offsetY or 4
            billboardGui.StudsOffset = vector(0, n2, 0)
            billboardGui.Parent = parent
            local frame2 = Instance.new("Frame")
            frame2.Name = "Box"
            frame2.BackgroundTransparency = 1
            frame2.Size = UDim2.new(1, 0, 1, 0)
            frame2.AnchorPoint = Vector2.new(0.5, 0.5)
            frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
            frame2.Parent = billboardGui

            if arg.noDistScale then
                billboardGui:SetAttribute("NoDistScale", true)
            else
                local uiScale = Instance.new("UIScale")
                uiScale.Name = "DistScale"
                uiScale.Scale = 1
                uiScale.Parent = frame2
            end

            if flag4 then
                local uiListLayout = Instance.new("UIListLayout", frame2)
                uiListLayout.FillDirection = Enum.FillDirection.Horizontal
                uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                uiListLayout.Padding = UDim.new(0, 4)
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Name = "Icon"
                imageLabel.BackgroundTransparency = 1
                imageLabel.Size = UDim2.new(0, 14, 0, 14)
                imageLabel.Visible = false
                imageLabel.Parent = frame2
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "Text"
                textLabel.BackgroundTransparency = 1
                textLabel.AutomaticSize = Enum.AutomaticSize.XY
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 12
                textLabel.TextWrapped = false
                textLabel.TextYAlignment = Enum.TextYAlignment.Center
                textLabel.RichText = true
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.Parent = frame2
            else
                local uiListLayout = Instance.new("UIListLayout", frame2)
                uiListLayout.FillDirection = Enum.FillDirection.Vertical
                uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                uiListLayout.Padding = UDim.new(0, 0)
                local frame3 = Instance.new("Frame")
                frame3.Name = "Row1"
                frame3.BackgroundTransparency = 1
                frame3.AutomaticSize = Enum.AutomaticSize.XY
                frame3.Size = UDim2.new(0, 0, 0, 16)
                frame3.Parent = frame2
                local uiListLayout2 = Instance.new("UIListLayout", frame3)
                uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
                uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
                uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
                uiListLayout2.Padding = UDim.new(0, 4)
                local imageLabel = Instance.new("ImageLabel")
                imageLabel.Name = "Icon"
                imageLabel.BackgroundTransparency = 1
                imageLabel.Size = UDim2.new(0, 14, 0, 14)
                imageLabel.Visible = false
                imageLabel.Parent = frame3
                local textLabel = Instance.new("TextLabel")
                textLabel.Name = "Name"
                textLabel.BackgroundTransparency = 1
                textLabel.AutomaticSize = Enum.AutomaticSize.XY
                textLabel.Font = Enum.Font.GothamBold
                textLabel.TextSize = 12
                textLabel.TextWrapped = false
                textLabel.TextYAlignment = Enum.TextYAlignment.Center
                textLabel.TextStrokeTransparency = 0
                textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel.Parent = frame3
                local textLabel2 = Instance.new("TextLabel")
                textLabel2.Name = "Info"
                textLabel2.BackgroundTransparency = 1
                textLabel2.AutomaticSize = Enum.AutomaticSize.XY
                textLabel2.Font = Enum.Font.GothamBold
                textLabel2.TextSize = 11
                textLabel2.TextWrapped = false
                textLabel2.TextYAlignment = Enum.TextYAlignment.Center
                textLabel2.RichText = true
                textLabel2.TextStrokeTransparency = 0
                textLabel2.TextStrokeColor3 = Color3.new(0, 0, 0)
                textLabel2.Parent = frame2
            end
        end

        local box = v6:FindFirstChild("Box")

        if flag4 then
            local text2 = box and box:FindFirstChild("Text")
            local icon = box and box:FindFirstChild("Icon")

            if text2 then
                local str3 = "#FFFFFF"

                if arg.color then
                    str3 = string.format("#%02X%02X%02X", math.floor(arg.color.R * 255), math.floor(arg.color.G * 255), math.floor(arg.color.B * 255))
                end

                local v7 = tostring
                local str4 = str or ""
                local str5 = v7(str4):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                local text3 = ""

                if flag3 then
                    text3 = string.format("<font color=\"%s\">%s</font>", str3, str5)
                end

                if text ~= "" then
                    if text3 == "" then
                        text3 = text
                    elseif arg.noSeparator then
                        text3 = text3 .. " " .. text
                    else
                        text3 = text3 .. " <font color=\"#888888\">·</font> " .. text
                    end
                end

                text2.Text = text3
            end

            if icon then
                if arg.icon and arg.icon ~= "" then
                    icon.Image = arg.icon
                    icon.Visible = true
                else
                    icon.Visible = false
                end
            end
        else
            local row1 = box and box:FindFirstChild("Row1")
            local name3 = row1 and row1:FindFirstChild("Name")
            local icon = row1 and row1:FindFirstChild("Icon")
            local info = box and box:FindFirstChild("Info")

            if name3 then
                name3.Text = tostring(str):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                local color = arg.color
                local color2 = color or Color3.new(1, 1, 1)
                name3.TextColor3 = color2
            end

            if icon then
                if arg.icon and arg.icon ~= "" then
                    icon.Image = arg.icon
                    icon.Visible = true
                else
                    icon.Visible = false
                end
            end

            if info then
                if text == "" then
                    info.Visible = false
                else
                    info.Visible = true
                    info.Text = text
                end
            end
        end
    end

    local function fn29()
        local team = localPlayer.Team
        local flag3 = team and localPlayer.Team.Name == "Survivors"
        return flag3
    end

    local function fn30(arg)
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return false
        end

        for i, v5 in ipairs(animator:GetPlayingAnimationTracks()) do
            if v5.Animation and string.find(tostring(v5.Animation.AnimationId), "126081405469607") then
                return true
            end
        end

        return false
    end

    local function fn31(arg)
        if not _G.Ox.FakePerks.QuickRecoveryEnabled then
            return
        end

        if not fn29() then
            return
        end

        if _G.Ox.FakePerks.boostActive then
            return
        end

        if tick() - _G.Ox.FakePerks.lastQRTime < _G.Ox.FakePerks.PerkCooldown then
            return
        end
        _G.Ox.FakePerks.boostActive = true
        _G.Ox.FakePerks.lastQRTime = tick()
        local now = tick()

        task.spawn(function()
            while _G.Ox.FakePerks.QuickRecoveryEnabled and tick() - now < 3 do
                if arg and arg.Parent then
                    arg:SetAttribute("speedboost", 1.4)
                end

                task.wait()
            end

            if arg and arg.Parent then
                arg:SetAttribute("speedboost", 1)
            end

            _G.Ox.FakePerks.boostActive = false
        end)
    end

    local function fn32(arg)
        if _G.Ox.FakePerks.qrConnection then
            _G.Ox.FakePerks.qrConnection:Disconnect()
            _G.Ox.FakePerks.qrConnection = nil
        end

        if not arg then
            return
        end

        _G.Ox.FakePerks.qrConnection = arg:GetAttributeChangedSignal("isvaulting"):Connect(function()
            if arg:GetAttribute("isvaulting") == true then
                task.spawn(function()
                    task.wait(0.05)
                    local v5 = fn30(arg)
                    local v6 = v5

                    if not v5 then
                        task.wait(0.05)
                        v6 = fn30(arg)
                    end

                    if not v6 and arg:GetAttribute("isvaulting") == true then
                        fn31(arg)
                    end
                end)
            end
        end)
    end

    ToggleQuickRecovery = function(quickRecoveryEnabled)
        _G.Ox.FakePerks.QuickRecoveryEnabled = quickRecoveryEnabled

        if quickRecoveryEnabled and localPlayer.Character then
            fn32(localPlayer.Character)
        elseif not quickRecoveryEnabled and _G.Ox.FakePerks.qrConnection then
            _G.Ox.FakePerks.qrConnection:Disconnect()
            _G.Ox.FakePerks.qrConnection = nil
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Fake Quick Recovery"}
        local description = quickRecoveryEnabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local function fn33(arg)
        if not _G.Ox.FakePerks.PerfectLandingEnabled then
            return
        end

        if not fn29() then
            return
        end

        if _G.Ox.FakePerks.perfectLandingBoostActive then
            return
        end

        if tick() - _G.Ox.FakePerks.lastPLTime < _G.Ox.FakePerks.PerkCooldown then
            return
        end
        _G.Ox.FakePerks.perfectLandingBoostActive = true
        _G.Ox.FakePerks.lastPLTime = tick()
        local now = tick()

        task.spawn(function()
            while _G.Ox.FakePerks.perfectLandingBoostActive and tick() - now < 3 do
                if arg and arg.Parent then
                    arg:SetAttribute("speedboost", 1.4)
                end

                task.wait()
            end

            if arg and arg.Parent then
                arg:SetAttribute("speedboost", 1)
            end

            _G.Ox.FakePerks.perfectLandingBoostActive = false
        end)
    end

    local function fn34(arg)
        if _G.Ox.FakePerks.plConnection then
            _G.Ox.FakePerks.plConnection:Disconnect()
            _G.Ox.FakePerks.plConnection = nil
        end

        if not arg then
            return
        end

        _G.Ox.FakePerks.plConnection = arg:GetAttributeChangedSignal("speedboost"):Connect(function()
            if not fn29() then
                return
            end

            if arg:GetAttribute("speedboost") == 0.625 then
                fn33(arg)
            end
        end)
    end

    TogglePerfectLanding = function(perfectLandingEnabled)
        _G.Ox.FakePerks.PerfectLandingEnabled = perfectLandingEnabled

        if perfectLandingEnabled then
            if localPlayer.Character then
                fn34(localPlayer.Character)
            end
        else
            if _G.Ox.FakePerks.plConnection then
                _G.Ox.FakePerks.plConnection:Disconnect()
                _G.Ox.FakePerks.plConnection = nil
            end

            if _G.Ox.FakePerks.perfectLandingBoostActive and localPlayer.Character then
                localPlayer.Character:SetAttribute("speedboost", 1)
                _G.Ox.FakePerks.perfectLandingBoostActive = false
            end
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Fake Perfect Landing"}
        local description = perfectLandingEnabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local function fn35(arg)
        if _G.Ox.FakePerks.fsConnection then
            _G.Ox.FakePerks.fsConnection:Disconnect()
            _G.Ox.FakePerks.fsConnection = nil
        end

        if _G.Ox.FakePerks.fsAnimConnection then
            _G.Ox.FakePerks.fsAnimConnection:Disconnect()
            _G.Ox.FakePerks.fsAnimConnection = nil
        end

        if not arg then
            return
        end
        local humanoid = arg:WaitForChild("Humanoid", 3)
        if not humanoid then
            return
        end
        local animator = humanoid:WaitForChild("Animator", 3)
        if not animator then
            return
        end

        _G.Ox.FakePerks.fsAnimConnection = animator.AnimationPlayed:Connect(function(arg2)
            if not arg2.Animation then
                return
            end

            if arg2.Animation.AnimationId ~= "rbxassetid://136962284480779" then
                return
            end
            local connection = nil

            connection = arg2.Stopped:Connect(function()
                if connection then
                    connection:Disconnect()
                end

                _G.Ox.FakePerks.lastFSTime = tick()
                _G.Ox.FakePerks.fsOnCooldown = true

                if arg and arg.Parent then
                    arg:SetAttribute("Flowstate", false)
                end

                task.delay(_G.Ox.FakePerks.PerkCooldown, function()
                    _G.Ox.FakePerks.fsOnCooldown = false

                    if _G.Ox.FakePerks.FlowstateEnabled and arg and arg.Parent then
                        arg:SetAttribute("Flowstate", true)
                    end
                end)
            end)
        end)

        _G.Ox.FakePerks.fsConnection = arg:GetAttributeChangedSignal("Flowstate"):Connect(function()
            if not _G.Ox.FakePerks.FlowstateEnabled then
                return
            end

            if not fn29() then
                return
            end
            local attribute = arg:GetAttribute("Flowstate")

            if attribute == true then
                if _G.Ox.FakePerks.fsOnCooldown or tick() - _G.Ox.FakePerks.lastFSTime < _G.Ox.FakePerks.PerkCooldown then
                    arg:SetAttribute("Flowstate", false)
                end
            elseif attribute == false and not _G.Ox.FakePerks.fsOnCooldown then
                local n2 = tick() - _G.Ox.FakePerks.lastFSTime

                if _G.Ox.FakePerks.PerkCooldown <= n2 then
                    arg:SetAttribute("Flowstate", true)
                end
            end
        end)

        task.wait(0.5)

        if _G.Ox.FakePerks.FlowstateEnabled and arg and arg.Parent then
            arg:SetAttribute("Flowstate", true)
        end
    end

    ToggleFlowstate = function(flowstateEnabled)
        _G.Ox.FakePerks.FlowstateEnabled = flowstateEnabled

        if flowstateEnabled then
            if localPlayer.Character then
                fn35(localPlayer.Character)
            end
        else
            if _G.Ox.FakePerks.fsConnection then
                _G.Ox.FakePerks.fsConnection:Disconnect()
                _G.Ox.FakePerks.fsConnection = nil
            end

            if _G.Ox.FakePerks.fsAnimConnection then
                _G.Ox.FakePerks.fsAnimConnection:Disconnect()
                _G.Ox.FakePerks.fsAnimConnection = nil
            end

            if localPlayer.Character then
                localPlayer.Character:SetAttribute("Flowstate", false)
            end
        end

        local notify = lib.Notify
        local tbl6 = {Title = "Fake Flowstate"}
        local description = flowstateEnabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local function fn36()
        local adrenalineConns = _G.Ox.FakePerks.adrenalineConns
        if not adrenalineConns then
            return
        end

        for i, adrenalineConn in ipairs(adrenalineConns) do
            pcall(function()
                adrenalineConn:Disconnect()
            end)
        end

        _G.Ox.FakePerks.adrenalineConns = {}
    end

    local function fn37(arg)
        if not _G.Ox.FakePerks.FakeAdrenalineRush then
            return
        end

        if not fn29() then
            return
        end

        if not arg or not arg.Parent then
            return
        end

        if _G.Ox.FakePerks.boostActive then
            return
        end
        local now = tick()
        local lastARTime = _G.Ox.FakePerks.lastARTime
        local n2 = lastARTime or 0
        if now - n2 < _G.Ox.FakePerks.PerkCooldown then
            return
        end
        _G.Ox.FakePerks.boostActive = true
        _G.Ox.FakePerks.lastARTime = tick()
        local now2 = tick()

        task.spawn(function()
            while _G.Ox.FakePerks.FakeAdrenalineRush and tick() - now2 < 5 do
                if arg and arg.Parent then
                    arg:SetAttribute("speedboost", 1.4)
                end

                task.wait()
            end

            if arg and arg.Parent then
                arg:SetAttribute("speedboost", 1)
            end

            _G.Ox.FakePerks.boostActive = false
        end)
    end

    local function fn38(arg)
        if not arg then
            return
        end
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        local humanoid2 = humanoid or arg:WaitForChild("Humanoid", 5)
        if not humanoid2 then
            return
        end
        local health = humanoid2.Health

        table.insert(_G.Ox.FakePerks.adrenalineConns, humanoid2.HealthChanged:Connect(function(health2)
            if not _G.Ox.FakePerks.FakeAdrenalineRush then
                return
            end

            if health2 < health and health2 <= 50 and health2 > 0 then
                fn37(arg)
            end

            health = health2
        end))
    end

    SetupFakeAdrenalineRush = function(arg)
        local fakePerks = _G.Ox.FakePerks
        local fakeAdrenalineRush = arg == true
        fakePerks.FakeAdrenalineRush = fakeAdrenalineRush
        local fakePerks2 = _G.Ox.FakePerks
        local adrenalineOn = arg == true
        fakePerks2.adrenalineOn = adrenalineOn
        fn36()

        if not arg then
            lib:Notify({
                Title = "Fake Perks",
                Description = "Adrenaline Rush OFF",
                Duration = 2,
            })

            return
        end

        fn38(localPlayer.Character)

        table.insert(_G.Ox.FakePerks.adrenalineConns, localPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.3)

            if _G.Ox.FakePerks.FakeAdrenalineRush then
                fn38(character)
            end
        end))

        lib:Notify({
            Title = "Fake Perks",
            Description = "Adrenaline Rush ON",
            Duration = 3,
        })
    end

    local function fn39(character)
        task.wait(0.5)

        if _G.Ox.FakePerks.QuickRecoveryEnabled then
            fn32(character)
        end

        if _G.Ox.FakePerks.PerfectLandingEnabled then
            fn34(character)
        end

        if _G.Ox.FakePerks.FlowstateEnabled then
            fn35(character)
        end

        if _G.Ox.FakePerks.FakeAdrenalineRush then
            fn38(character)
        end
    end

    if localPlayer.Character then
        fn39(localPlayer.Character)
    end

    localPlayer.CharacterAdded:Connect(fn39)

    local function fn40()
        if not _G.Ox.StreamerMode.Enabled then
            return
        end
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end

        local function fn41(arg)
            if not arg:IsA("TextLabel") and not arg:IsA("TextButton") and not arg:IsA("TextBox") then
                if arg:IsA("ImageLabel") or arg:IsA("ImageButton") then
                    local function fn42()
                        if not _G.Ox.StreamerMode.Enabled then
                            return
                        end
                        local image = arg.Image
                        local flag3 = false

                        for i, player in ipairs(Players:GetPlayers()) do
                            if string.find(image, tostring(player.UserId)) then
                                if not arg:GetAttribute("OriginalImage") then
                                    arg:SetAttribute("OriginalImage", image)
                                end

                                flag3 = true
                                break
                            end

                            continue
                        end

                        if flag3 and arg.Image ~= "rbxassetid://118755181202304" then
                            arg.Image = "rbxassetid://118755181202304"
                        end
                    end

                    fn42()
                    local connection = arg:GetPropertyChangedSignal("Image"):Connect(fn42)
                    table.insert(_G.Ox.StreamerMode.SpooferConns, connection)
                end
            else
                local function fn42()
                    if not _G.Ox.StreamerMode.Enabled then
                        return
                    end
                    local text = arg.Text
                    local v5 = text
                    local flag3 = false

                    if not arg:GetAttribute("OriginalText") then
                        arg:SetAttribute("OriginalText", text)
                    end

                    for i, player in ipairs(Players:GetPlayers()) do
                        if string.find(v5, player.Name) or string.find(v5, player.DisplayName) then
                            local v6 = string.gsub(v5, player.Name, "OXIO")
                            v5 = string.gsub(v6, player.DisplayName, "OXIO")
                            flag3 = true
                        end
                    end

                    if flag3 and arg.Text ~= v5 then
                        arg.Text = v5
                    end
                end

                fn42()
                local connection = arg:GetPropertyChangedSignal("Text"):Connect(fn42)
                table.insert(_G.Ox.StreamerMode.SpooferConns, connection)
            end
        end

        for i, descendant in ipairs(playerGui2:GetDescendants()) do
            fn41(descendant)
        end

        local connection = playerGui2.DescendantAdded:Connect(function(descendant)
            task.defer(function()
                fn41(descendant)
            end)
        end)

        table.insert(_G.Ox.StreamerMode.SpooferConns, connection)
    end

    local function fn41()
        for i, spooferConn in ipairs(_G.Ox.StreamerMode.SpooferConns) do
            if spooferConn.Connected then
                spooferConn:Disconnect()
            end
        end

        table.clear(_G.Ox.StreamerMode.SpooferConns)
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

        if playerGui2 then
            for i, descendant in ipairs(playerGui2:GetDescendants()) do
                if not descendant:IsA("TextLabel") and not descendant:IsA("TextButton") and not descendant:IsA("TextBox") then
                    if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                        local attribute = descendant:GetAttribute("OriginalImage")

                        if attribute then
                            descendant.Image = attribute
                            descendant:SetAttribute("OriginalImage", nil)
                        end
                    end
                else
                    local attribute = descendant:GetAttribute("OriginalText")

                    if attribute then
                        descendant.Text = attribute
                        descendant:SetAttribute("OriginalText", nil)
                    end
                end
            end
        end
    end

    local function fn42(enabled)
        _G.Ox.StreamerMode.Enabled = enabled

        if enabled then
            fn40()

            lib:Notify({
                Title = "Streamer Mode",
                Description = "AKTIF - Nama player disembunyikan",
                Duration = 3,
            })
        else
            fn41()

            lib:Notify({
                Title = "Streamer Mode",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.StreamerMode.Enabled then
            fn41()
            fn27()
            task.wait(0.5)
            fn40()
        end
    end)

    playerGui.ChildAdded:Connect(function()
        task.wait(0.5)

        if _G.Ox.StreamerMode.Enabled then
            fn40()
        end
    end)

    local function fn43(enabled)
        _G.Ox.StretchRes.Enabled = enabled
        local notify = lib.Notify
        local tbl6 = {Title = "Stretch Res"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl6.Description = description
        tbl6.Duration = 2
        notify(lib, tbl6)
    end

    local tbl6 = {}

    UpdateHookData = function()
        for k, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" then
                local attribute = player:GetAttribute("HookCount")
                local n2 = attribute or 0
                tbl6[player.Name] = n2
            end
        end
    end

    CreateHookESP = function(parent, arg)
        if not _G.Ox.ESPConfig.HookCount then
            return
        end
        local name = "HookESP_" .. parent.Name
        local v5 = parent:FindFirstChild(name)

        if v5 then
            v5:Destroy()
        end

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = name
        billboardGui.Parent = parent
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 40, 0, 14)
        billboardGui.StudsOffset = Vector3.new(0, 5.5, 0)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 11
        textLabel.TextScaled = true
        textLabel.Text = string.format("Hooked %d", arg)
        textLabel.TextXAlignment = Enum.TextXAlignment.Center
        textLabel.TextYAlignment = Enum.TextYAlignment.Center
        textLabel.Parent = billboardGui

        if arg >= 3 then
            textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        elseif arg >= 2 then
            textLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
        else
            textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end

        local uiStroke3 = Instance.new("UIStroke")
        uiStroke3.Color = Color3.fromRGB(0, 0, 0)
        uiStroke3.Thickness = 2
        uiStroke3.Transparency = 0.5
        uiStroke3.Parent = textLabel
    end

    local tbl7 = {
        "rbxassetid://120434965879067",
        "rbxassetid://81511619438196",
        "rbxassetid://130571419892864",
    }

    CreateHookUICounter = function(parent, arg)
        if not parent then
            return
        end
        local num = tonumber(arg)
        local n2 = num or 0
        local v5 = n2
        local oXioHookCounter = parent:FindFirstChild("OXio_HookCounter")
        local v6 = oXioHookCounter

        if v5 <= 0 then
            if oXioHookCounter then
                oXioHookCounter:Destroy()
            end

            return
        end

        local v7 = tbl7[math.clamp(v5, 1, 3)]
        if not v7 then
            return
        end

        if not oXioHookCounter then
            local imageLabel = Instance.new("ImageLabel")
            v6 = imageLabel
            imageLabel.Name = "OXio_HookCounter"
            imageLabel.BackgroundTransparency = 1
            local zIndex = parent.ZIndex
            local n3 = zIndex or 1
            imageLabel.ZIndex = n3 + 1
            imageLabel.Parent = parent
        end

        v6.Size = UDim2.new(0.509, 0, 0.51, 0)
        v6.Position = UDim2.new(0.91, 0, 0.18, 0)
        v6.AnchorPoint = Vector2.new(0.5, 0.5)
        v6.Image = v7
        v6.ScaleType = Enum.ScaleType.Fit
    end

    UpdateHookUICounter = function()
        if GetRole() == "Killer" then
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
            if not playerGui2 then
                return
            end

            local function fn44(arg)
                if arg and type(arg) == "string" then
                    return tonumber(arg:match("id=(%d+)"))
                end
                return nil
            end

            local v5, v6, v7 = ipairs(playerGui2:GetChildren())
            local v8 = v7
            local v9 = v5
            local v10 = v6

            while true do
                local v11, v12 = v9(v10, v8)
                if v11 == nil then
                    break
                end
                v8 = v11

                if typeof(v12) == "Instance" then
                    local frame2 = v12:FindFirstChild("Frame")

                    if frame2 and frame2:IsA("Frame") then
                        for i, child in ipairs(frame2:GetChildren()) do
                            local imageLabel = child:FindFirstChild("ImageLabel")

                            if imageLabel then
                                local attribute = child:GetAttribute("UserId")
                                local v13 = attribute or fn44(imageLabel.Image)
                                local playerByUserId = v13 and Players:GetPlayerByUserId(tonumber(v13)) or nil

                                if playerByUserId and playerByUserId ~= localPlayer and playerByUserId.Team and playerByUserId.Team.Name == "Survivors" then
                                    local v14 = tbl6[playerByUserId.Name]
                                    local attribute2 = v14 or playerByUserId:GetAttribute("HookCount") or 0
                                    CreateHookUICounter(imageLabel, attribute2)
                                else
                                    local oXioHookCounter = imageLabel:FindFirstChild("OXio_HookCounter")

                                    if oXioHookCounter then
                                        oXioHookCounter:Destroy()
                                    end
                                end
                            end
                        end

                        v8 = v11
                    end
                end
            end

            return
        end

        ClearHookUICounter()
    end

    ClearHookUICounter = function()
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        if not playerGui2 then
            return
        end
        local v5, v6, v7 = ipairs(playerGui2:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if typeof(v12) == "Instance" then
                local frame2 = v12:FindFirstChild("Frame")

                if frame2 and frame2:IsA("Frame") then
                    for i, child in ipairs(frame2:GetChildren()) do
                        local imageLabel = child:FindFirstChild("ImageLabel")
                        local oXioHookCounter = imageLabel and imageLabel:FindFirstChild("OXio_HookCounter")

                        if oXioHookCounter then
                            oXioHookCounter:Destroy()
                        end
                    end

                    v8 = v11
                end
            end
        end
    end

    UpdateHookESP = function()
        if not _G.Ox.ESPConfig.HookCount then
            ClearHookESP()
        end
    end

    ClearHookESP = function()
        local v5, v6, v7 = pairs(Players:GetPlayers())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12.Character then
                for k, child in pairs(v12.Character:GetChildren()) do
                    if string.match(child.Name, "^HookESP_") then
                        child:Destroy()
                    end
                end

                v8 = v11
            end
        end
    end

    ClearESP = function(arg)
        if arg == "Player" then
            for k, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    if player.Character:FindFirstChild("PEH") then
                        player.Character.PEH:Destroy()
                    end

                    if player.Character:FindFirstChild("PE_Text") then
                        player.Character.PE_Text:Destroy()
                    end
                end
            end
        elseif arg == "Killer" then
            for k, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    if player.Character:FindFirstChild("KEH") then
                        player.Character.KEH:Destroy()
                    end

                    if player.Character:FindFirstChild("KE_Text") then
                        player.Character.KE_Text:Destroy()
                    end
                end
            end
        elseif arg == "Generator" then
            for k, generator in pairs(tbl4.Generators) do
                if generator.model and generator.model.Parent and generator.model:FindFirstChild("GEH") then
                    generator.model.GEH:Destroy()
                end

                if generator.part and generator.part.Parent and generator.part:FindFirstChild("GE_Text") then
                    generator.part.GE_Text:Destroy()
                end
            end
        elseif arg == "Pallet" then
            for k, pallet in pairs(tbl4.Pallets) do
                if pallet and pallet.Parent and pallet:FindFirstChild("PalletEH") then
                    pallet.PalletEH:Destroy()
                end
            end
        elseif arg == "Hook" then
            for k, hook in pairs(tbl4.Hooks) do
                if hook and hook.Parent and hook:FindFirstChild("HookEH") then
                    hook.HookEH:Destroy()
                end
            end
        elseif arg == "Window" then
            for k, window in pairs(tbl4.Windows) do
                if window and window.Parent and window:FindFirstChild("WindowEH") then
                    window.WindowEH:Destroy()
                end
            end
        elseif arg == "Gate" then
            for k, gate in pairs(tbl4.Gates) do
                if gate and gate.Parent and gate:FindFirstChild("GateEH") then
                    gate.GateEH:Destroy()
                end
            end
        elseif arg == "SCP" then
            for k, scP in pairs(tbl4.SCPs) do
                if scP and scP.Parent and scP:FindFirstChild("SCPEH") then
                    scP.SCPEH:Destroy()
                end
            end
        end
    end

    ClearAllESP = function()
        ClearESP("Player")
        ClearESP("Killer")
        ClearESP("Generator")
        ClearESP("Pallet")
        ClearESP("Hook")
        ClearESP("Gate")
        ClearESP("SCP")
        ClearESP("Window")
        ClearHookESP()
    end

    GetSurvivorStatus = function(arg)
        if not arg then
            return nil, nil
        end

        if arg:GetAttribute("IsHooked") == true then
            return "HOOKED", _G.Ox.ESPColors.Hooked
        end

        if arg:GetAttribute("Knocked") == true then
            return "DOWN", _G.Ox.ESPColors.Downed
        end
        local humanoid = arg:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 and humanoid.Health < humanoid.MaxHealth then
            return "INJURED", _G.Ox.ESPColors.Injured
        end
        return nil, nil
    end

    buildInfoRich = function(arg, arg2, arg3, arg4, arg5)
        local tbl8 = {}

        if arg and arg ~= "" then
            local str = "#FFFFFF"

            if arg == "INJURED" then
                str = "#FF8C00"
            elseif arg == "DOWN" then
                str = "#FF2828"
            elseif arg == "HOOKED" then
                str = "#F0F0FF"
            end

            table.insert(tbl8, string.format("<font color=\"%s\">%s</font>", str, arg))
        end

        if arg3 then
            table.insert(tbl8, string.format("<font color=\"#FFFFFF\">%dm</font>", arg3))
        end

        if not arg5 and arg4 and arg ~= "HOOKED" then
            local str = "#C8C8C8"

            if arg4 >= 3 then
                str = "#FF3232"
            elseif arg4 >= 2 then
                str = "#FFC832"
            end

            table.insert(tbl8, string.format("<font color=\"%s\">Hooked %d</font>", str, arg4))
        end

        return table.concat(tbl8, " <font color=\"#888888\">·</font> ")
    end

    UpdatePlayerESP = function()
        if not _G.Ox.ESPConfig.Master then
            return
        end
        local character = localPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

        if _G.Ox.ESPConfig.KillerWarn and humanoidRootPart and GetRole() == "Survivor" then
            local killerWarn = humanoidRootPart:FindFirstChild("KillerWarn")
            local v5 = killerWarn
            local huge = math.huge

            for k, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Team and player.Team.Name == "Killer" and player.Character then
                    local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

                    if humanoidRootPart2 then
                        local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

                        if magnitude < huge then
                            huge = magnitude
                        end
                    end
                end
            end

            if huge <= 80 then
                if not killerWarn then
                    local billboardGui = Instance.new("BillboardGui")
                    v5 = billboardGui
                    billboardGui.Name = "KillerWarn"
                    billboardGui.Size = UDim2.new(0, 30, 0, 30)
                    billboardGui.AlwaysOnTop = true
                    billboardGui.StudsOffset = Vector3.new(0, 4, 0)
                    billboardGui.Parent = humanoidRootPart
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Name = "WarnText"
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextScaled = true
                    textLabel.TextStrokeTransparency = 0
                    textLabel.Font = Enum.Font.GothamBlack
                    textLabel.Parent = billboardGui
                end

                local warnText = v5:FindFirstChild("WarnText")

                if warnText then
                    if huge <= 40 then
                        warnText.Text = "!!"
                        warnText.TextColor3 = Color3.fromRGB(255, 0, 0)
                    else
                        warnText.Text = "!"
                        warnText.TextColor3 = Color3.fromRGB(255, 255, 0)
                    end
                end
            elseif killerWarn then
                killerWarn:Destroy()
            end
        else
            local killerWarn = humanoidRootPart and humanoidRootPart:FindFirstChild("KillerWarn")

            if killerWarn then
                killerWarn:Destroy()
            end
        end

        local v5, v6, v7 = pairs(Players:GetPlayers())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12 ~= localPlayer and v12.Character then
                local humanoidRootPart2 = v12.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart2 and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - humanoidRootPart2.Position).Magnitude then
                    for i, v13 in ipairs({"PE_Text", "KE_Text", "PEH", "KEH"}) do
                        local v14 = v12.Character:FindFirstChild(v13)

                        if v14 then
                            v14:Destroy()
                        end
                    end

                    v8 = v11
                else
                    local team = v12.Team
                    local flag3 = team and v12.Team.Name == "Killer"
                    local killer

                    if flag3 then
                        killer = _G.Ox.ESPConfig.Killer
                    else
                        local player = _G.Ox.ESPConfig.Player
                        local hookCount = player or _G.Ox.ESPConfig.HookCount
                        killer = hookCount
                    end

                    local str = flag3 and "KE_Text" or "PE_Text"
                    local name = flag3 and "KEH" or "PEH"
                    local killer2 = flag3 and _G.Ox.ESPColors.Killer or _G.Ox.ESPColors.Player
                    local v13 = nil
                    local v14 = nil

                    if not flag3 and _G.Ox.ESPConfig.Status then
                        local v15, v16 = GetSurvivorStatus(v12.Character)

                        if v15 then
                            v13 = v15
                            v14 = v16
                        end
                    end

                    if killer then
                        local v15, v16, v17 = ipairs({"PE_Text", "KE_Text"})
                        local v18 = v9
                        local v19 = v10

                        for k, v20 in v15, v16, v17 do
                            if v20 ~= str then
                                local v21 = v12.Character:FindFirstChild(v20)

                                if v21 then
                                    v21:Destroy()
                                end
                            end
                        end

                        for i, v20 in ipairs({"PEH", "KEH"}) do
                            if v20 ~= name then
                                local v21 = v12.Character:FindFirstChild(v20)

                                if v21 then
                                    v21:Destroy()
                                end
                            end
                        end

                        v8 = v11
                        v9 = v18
                        v10 = v19

                        if flag3 then
                            for i, child in ipairs(v12.Character:GetChildren()) do
                                if string.match(child.Name, "^HookESP_") then
                                    child:Destroy()
                                end
                            end

                            v8 = v11
                            v9 = v18
                            v10 = v19
                        end

                        local humanoidRootPart3 = v12.Character:FindFirstChild("HumanoidRootPart")
                        local n2 = humanoidRootPart3 and math.floor(GetDistance(humanoidRootPart3.Position)) or nil
                        local v20 = v12.Character:FindFirstChild(name)
                        local v21 = v20

                        if not v20 then
                            local highlight2 = Instance.new("Highlight")
                            v21 = highlight2
                            highlight2.Name = name
                            highlight2.Parent = v12.Character
                        end

                        v21.FillColor = killer2
                        v21.OutlineColor = killer2
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v21.FillTransparency = fillTransparency
                        v21.OutlineTransparency = 0
                        local name2 = nil
                        local v22 = nil

                        if _G.Ox.ESPConfig.Name then
                            name2 = v12.Name

                            if flag3 then
                                local attribute = v12:GetAttribute("SelectedKiller")

                                if not attribute then
                                    local selectedKiller = v12:FindFirstChild("SelectedKiller")

                                    if selectedKiller then
                                        pcall(function()
                                            attribute = selectedKiller.Value
                                        end)
                                    end
                                end

                                if attribute and tostring(attribute) ~= "" then
                                    name2 = tostring(attribute)
                                end
                            end

                            if _G.Ox.ESPConfig.ItemIcon and not flag3 then
                                local attribute = v12:GetAttribute("EquippedItem")

                                if attribute and attribute ~= "" then
                                    v22 = getItemIcon(attribute)
                                end
                            end
                        end

                        local v23 = nil

                        if not flag3 and _G.Ox.ESPConfig.HookCount then
                            local v24 = tbl6[v12.Name]
                            local attribute = v24 or v12:GetAttribute("HookCount") or 0
                            v23 = attribute
                        end

                        local v24 = buildInfoRich
                        local distance = _G.Ox.ESPConfig.Distance
                        local v25 = distance and n2 or nil
                        local v26 = v24(v13, v14, v25, v23, flag3)

                        if not name2 and v26 == "" then
                            local v27 = v12.Character:FindFirstChild(str)

                            if v27 then
                                v27:Destroy()
                            end
                        else
                            local v27 = CreateModernESP
                            local character2 = v12.Character
                            local tbl8 = {}
                            local name3 = name2 or ""
                            tbl8.name = name3
                            tbl8.infoRich = v26
                            tbl8.color = killer2
                            tbl8.icon = v22
                            tbl8.offsetY = 4
                            v27(character2, str, tbl8)
                        end
                    else
                        local v15 = v12.Character:FindFirstChild(name)

                        if v15 then
                            v15:Destroy()
                        end

                        local v16 = v12.Character:FindFirstChild(str)

                        if v16 then
                            v16:Destroy()
                        end
                    end
                end
            end
        end
    end

    UpdateSCPESP = function()
        if not _G.Ox.ESPConfig.Master then
            return
        end

        if _G.Ox.ESPConfig.SCP then
            for i, scP in ipairs(tbl4.SCPs) do
                if scP and scP.Parent then
                    local humanoid = scP:FindFirstChildOfClass("Humanoid")
                    local humanoidRootPart = scP:FindFirstChild("HumanoidRootPart")
                    local torso = humanoidRootPart or scP:FindFirstChild("Torso") or scP.PrimaryPart

                    if torso and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - torso.Position).Magnitude then
                        local scpeh = scP:FindFirstChild("SCPEH")

                        if scpeh then
                            scpeh:Destroy()
                        end
                    elseif humanoid and torso and humanoid.Health > 0 and math.floor(humanoid.WalkSpeed) == 9 then
                        local scp = _G.Ox.ESPColors.SCP
                        local scpeh = scP:FindFirstChild("SCPEH")
                        local v5 = scpeh

                        if not scpeh then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "SCPEH"
                            highlight2.Parent = scP
                        end

                        v5.FillColor = scp
                        v5.OutlineColor = scp
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    else
                        local scpeh = scP:FindFirstChild("SCPEH")

                        if scpeh then
                            scpeh:Destroy()
                        end
                    end
                end
            end
        else
            ClearESP("SCP")
        end
    end

    UpdateStaticESP = function()
        if not _G.Ox.ESPConfig.Master then
            return
        end

        if _G.Ox.ESPConfig.Generator then
            for k, generator in pairs(tbl4.Generators) do
                local model = generator.model

                if model and model.Parent then
                    local part = generator.part
                    local basePart = part or model:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local geh = model:FindFirstChild("GEH")

                        if geh then
                            geh:Destroy()
                        end

                        local geText = model:FindFirstChild("GE_Text")

                        if geText then
                            geText:Destroy()
                        end
                    else
                        local floor = math.floor
                        local attribute = model:GetAttribute("RepairProgress")
                        local n2 = attribute or 0
                        local v5 = floor(n2)
                        local n3 = math.clamp(v5 / 100, 0, 1)
                        local v6 = _G.Ox.ESPColors.Generator:Lerp(_G.Ox.ESPColors.GeneratorDone, n3)
                        local geh = model:FindFirstChild("GEH")
                        local v7 = geh

                        if not geh then
                            local highlight2 = Instance.new("Highlight")
                            v7 = highlight2
                            highlight2.Name = "GEH"
                            highlight2.Parent = model
                        end

                        v7.FillColor = v6
                        v7.OutlineColor = v6
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v7.FillTransparency = fillTransparency
                        v7.OutlineTransparency = 0

                        if _G.Ox.ESPConfig.GeneratorName then
                            local str

                            if v5 >= 100 then
                                str = "DONE"
                            else
                                str = string.format("%d%%", v5)
                            end

                            local generator2 = _G.Ox.ESPColors.Generator
                            local part2 = generator.part
                            local v8 = part2 or model
                            local n4

                            if v8:IsA("BasePart") then
                                n4 = v8.Size.Y / 2 + 1
                            else
                                n4 = model:GetExtentsSize().Y / 2 + 1
                            end

                            CreateModernESP(v8, "GE_Text", {
                                name = "GEN",
                                infoRich = string.format("<font color=\"%s\">%s</font>", "#FF8000", str),
                                color = generator2,
                                icon = nil,
                                offsetY = n4,
                                noSeparator = true,
                                noDistScale = true,
                            })
                        else
                            local geText = model:FindFirstChild("GE_Text")

                            if geText then
                                geText:Destroy()
                            end
                        end
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Pallet then
            for k, pallet in pairs(tbl4.Pallets) do
                if pallet and pallet.Parent then
                    local basePart = pallet:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local palletEH = pallet:FindFirstChild("PalletEH")

                        if palletEH then
                            palletEH:Destroy()
                        end
                    else
                        local palletEH = pallet:FindFirstChild("PalletEH")
                        local v5 = palletEH

                        if not palletEH then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "PalletEH"
                            highlight2.Parent = pallet
                        end

                        v5.Adornee = pallet
                        v5.FillColor = _G.Ox.ESPColors.Pallet
                        v5.OutlineColor = _G.Ox.ESPColors.Pallet
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Window then
            for i, window in ipairs(tbl4.Windows) do
                if window and window.Parent then
                    local bottom = window:FindFirstChild("Bottom")
                    local basePart = bottom or window:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local windowEH = window:FindFirstChild("WindowEH")

                        if windowEH then
                            windowEH:Destroy()
                        end
                    elseif basePart then
                        local windowEH = window:FindFirstChild("WindowEH")
                        local v5 = windowEH

                        if not windowEH then
                            local boxHandleAdornment = Instance.new("BoxHandleAdornment")
                            v5 = boxHandleAdornment
                            boxHandleAdornment.Name = "WindowEH"
                            boxHandleAdornment.Parent = window
                            boxHandleAdornment.AlwaysOnTop = true
                            boxHandleAdornment.ZIndex = 5
                        end

                        v5.Adornee = basePart
                        v5.Size = basePart.Size
                        v5.Color3 = _G.Ox.ESPColors.Window
                        local outline = _G.Ox.ESPConfig.Outline
                        local transparency = outline and 0.8 or 0.4
                        v5.Transparency = transparency
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Hook then
            for i, hook in ipairs(tbl4.Hooks) do
                if hook and hook.Parent then
                    local hookPoint = hook:FindFirstChild("HookPoint")
                    local basePart = hookPoint or hook:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local hookEH = hook:FindFirstChild("HookEH")

                        if hookEH then
                            hookEH:Destroy()
                        end
                    else
                        local hookEH = hook:FindFirstChild("HookEH")
                        local v5 = hookEH

                        if not hookEH then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "HookEH"
                            highlight2.Parent = hook
                        end

                        v5.FillColor = _G.Ox.ESPColors.Hook
                        v5.OutlineColor = _G.Ox.ESPColors.Hook
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    end
                end
            end
        end

        if _G.Ox.ESPConfig.Gate then
            for i, gate in ipairs(tbl4.Gates) do
                if gate and gate.Parent then
                    local basePart = gate:FindFirstChildWhichIsA("BasePart")

                    if basePart and _G.Ox.ESPConfig.MaxDistance < (currentCamera.CFrame.Position - basePart.Position).Magnitude then
                        local gateEH = gate:FindFirstChild("GateEH")

                        if gateEH then
                            gateEH:Destroy()
                        end
                    else
                        local gateEH = gate:FindFirstChild("GateEH")
                        local v5 = gateEH

                        if not gateEH then
                            local highlight2 = Instance.new("Highlight")
                            v5 = highlight2
                            highlight2.Name = "GateEH"
                            highlight2.Parent = gate
                        end

                        v5.Adornee = gate
                        v5.FillColor = _G.Ox.ESPColors.Gate
                        v5.OutlineColor = _G.Ox.ESPColors.Gate
                        local outline = _G.Ox.ESPConfig.Outline
                        local fillTransparency = outline and 1 or 0.5
                        v5.FillTransparency = fillTransparency
                        v5.OutlineTransparency = 0
                    end
                end
            end
        end
    end

    task.spawn(function()
        local currentCamera2, v5, v6, v7, v8, v9, v10, v11, v12, humanoidRootPart, magnitude, scale, n2, v13, v14, v15, v16, v17, v18, v19
        local v20, v21, box, distScale, v22, v23, v24, v25, v26, v27, model, basePart, magnitude2, scale2, n3, geText, box2, distScale2, n4
        n4 = 1

        while true do
            if n4 == 1 then
                if _G.Ox.ScriptAlive then
                    n4 = 2
                else
                    n4 = 26
                end
            elseif n4 == 2 then
                task.wait(0.1)
                currentCamera2 = workspace.CurrentCamera

                if currentCamera2 then
                    n4 = 3
                else
                    n4 = 1
                end
            elseif n4 == 3 then
                v5, v6, v7 = ipairs(Players:GetPlayers())
                v8 = v7
                v9 = v5
                v10 = v6
                n4 = 4
            elseif n4 == 4 then
                v11, v12 = v9(v10, v8)

                if v11 == nil then
                    n4 = 16
                else
                    n4 = 5
                end
            elseif n4 == 5 then
                v8 = v11

                if v12 ~= localPlayer and v12.Character then
                    n4 = 6
                else
                    n4 = 4
                end
            elseif n4 == 6 then
                humanoidRootPart = v12.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                    n4 = 7
                else
                    n4 = 4
                end
            elseif n4 == 7 then
                magnitude = (currentCamera2.CFrame.Position - humanoidRootPart.Position).Magnitude
                scale = math.clamp(40 / math.max(magnitude, 5), 0.8, 1)
                n2 = 4 + math.clamp((magnitude - 40) * 0.05, 0, 6)
                v13, v14, v15 = ipairs({"PE_Text", "KE_Text"})
                v16 = v9
                v17 = v10
                v18 = v15
                n4 = 8
            elseif n4 == 8 then
                v19, v20 = v13(v14, v18)

                if v19 == nil then
                    n4 = 15
                else
                    n4 = 9
                end
            elseif n4 == 9 then
                v18 = v19
                v21 = v12.Character:FindFirstChild(v20)

                if v21 and not v21:GetAttribute("NoDistScale") then
                    n4 = 10
                else
                    n4 = 8
                end
            elseif n4 == 10 then
                box = v21:FindFirstChild("Box")
                distScale = box

                if box then
                    n4 = 11
                else
                    n4 = 12
                end
            elseif n4 == 11 then
                distScale = box:FindFirstChild("DistScale")
                n4 = 12
            elseif n4 == 12 then
                if distScale then
                    n4 = 13
                else
                    n4 = 14
                end
            elseif n4 == 13 then
                distScale.Scale = scale
                n4 = 14
            elseif n4 == 14 then
                v21.StudsOffset = Vector3.new(0, n2, 0)
                n4 = 8
            elseif n4 == 15 then
                v8 = v11
                v9 = v16
                v10 = v17
                n4 = 4
            elseif n4 == 16 then
                v22, v23, v24 = pairs(tbl4.Generators)
                v25 = v24
                n4 = 17
            elseif n4 == 17 then
                v26, v27 = v22(v23, v25)

                if v26 == nil then
                    n4 = 1
                else
                    n4 = 18
                end
            elseif n4 == 18 then
                v25 = v26
                model = v27.model

                if model and model.Parent then
                    n4 = 19
                else
                    n4 = 17
                end
            elseif n4 == 19 then
                basePart = model:FindFirstChildWhichIsA("BasePart")

                if basePart then
                    n4 = 20
                else
                    n4 = 17
                end
            elseif n4 == 20 then
                magnitude2 = (currentCamera2.CFrame.Position - basePart.Position).Magnitude
                scale2 = math.clamp(40 / math.max(magnitude2, 5), 0.8, 1)
                n3 = 4 + math.clamp((magnitude2 - 40) * 0.05, 0, 6)
                geText = model:FindFirstChild("GE_Text")

                if geText and not geText:GetAttribute("NoDistScale") then
                    n4 = 21
                else
                    n4 = 17
                end
            elseif n4 == 21 then
                box2 = geText:FindFirstChild("Box")
                distScale2 = box2

                if box2 then
                    n4 = 22
                else
                    n4 = 23
                end
            elseif n4 == 22 then
                distScale2 = box2:FindFirstChild("DistScale")
                n4 = 23
            elseif n4 == 23 then
                if distScale2 then
                    n4 = 24
                else
                    n4 = 25
                end
            elseif n4 == 24 then
                distScale2.Scale = scale2
                n4 = 25
            elseif n4 == 25 then
                geText.StudsOffset = Vector3.new(0, n3, 0)
                n4 = 17
            elseif n4 == 26 then
                return
            end
        end
    end)

    SetupHookDetection = function()
        for k, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                player:GetAttributeChangedSignal("HookCount"):Connect(function()
                    local name = player.Name
                    local attribute = player:GetAttribute("HookCount")
                    local n2 = attribute or 0
                    tbl6[name] = n2

                    if _G.Ox.ESPConfig.HookCount then
                        UpdateHookESP()
                        UpdateHookUICounter()
                    end
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        player:GetAttributeChangedSignal("HookCount"):Connect(function()
            local name = player.Name
            local attribute = player:GetAttribute("HookCount")
            local n2 = attribute or 0
            tbl6[name] = n2

            if _G.Ox.ESPConfig.HookCount then
                UpdateHookESP()
                UpdateHookUICounter()
            end
        end)
    end)

    task.spawn(function()
        task.wait(2)
        SetupHookDetection()
    end)

    local flag3 = false

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(1)

            if _G.Ox.ESPConfig.HookCount then
                flag3 = true
                UpdateHookData()
                UpdatePlayerESP()
                UpdateHookUICounter()
            elseif flag3 then
                ClearHookESP()
                ClearHookUICounter()
                UpdatePlayerESP()
                flag3 = false
            end
        end
    end)

    local function fn44(enabled)
        _G.Ox.InfinityZoom.Enabled = enabled

        if enabled then
            localPlayer.CameraMaxZoomDistance = math.huge
            localPlayer.CameraMinZoomDistance = 0

            lib:Notify({
                Title = "Infinity Zoom",
                Description = "AKTIF - Zoom out tanpa batas",
                Duration = 2,
            })
        else
            localPlayer.CameraMaxZoomDistance = 12
            localPlayer.CameraMinZoomDistance = 0.5

            lib:Notify({
                Title = "Infinity Zoom",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function fn45(enabled)
        _G.Ox.CameraFOV.Enabled = enabled

        if not enabled then
            currentCamera.FieldOfView = 70
        end

        local notify = lib.Notify
        local tbl8 = {Title = "Camera FOV"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end

    local function fn46(value)
        _G.Ox.CameraFOV.Value = value

        if _G.Ox.CameraFOV.Enabled then
            currentCamera.FieldOfView = value
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)

        if _G.Ox.CameraFOV.Enabled then
            currentCamera.FieldOfView = _G.Ox.CameraFOV.Value
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)

            if _G.Ox.CameraFOV.Enabled then
                currentCamera.FieldOfView = _G.Ox.CameraFOV.Value
            end
        end
    end)

    pcall(function()
        _G.Ox.InstantTPGate.GateClientModule = require(game:GetService("ReplicatedStorage").Modules.Items.GateClient)
    end)

    local function fn47(arg)
        for k, v5 in getgc(true) do
            if typeof(v5) == "table" and rawget(v5, "gateDuration") and rawget(v5, "gateRemote") then
                rawset(v5, "gateDuration", arg)
            end
        end
    end

    local function fn48()
        if not _G.Ox.InstantTPGate.GateClientModule then
            return
        end

        if not _G.Ox.InstantTPGate.oldGateNew then
            _G.Ox.InstantTPGate.oldGateNew = _G.Ox.InstantTPGate.GateClientModule.new

            _G.Ox.InstantTPGate.GateClientModule.new = function(...)
                local v5 = _G.Ox.InstantTPGate.oldGateNew(...)

                if _G.Ox.InstantTPGate.Enabled then
                    v5.gateDuration = 0
                end

                return v5
            end
        end

        if not _G.Ox.InstantTPGate.oldGateCanUse then
            _G.Ox.InstantTPGate.oldGateCanUse = _G.Ox.InstantTPGate.GateClientModule.CanUse

            _G.Ox.InstantTPGate.GateClientModule.CanUse = function(arg)
                if not _G.Ox.InstantTPGate.Enabled then
                    return _G.Ox.InstantTPGate.oldGateCanUse(arg)
                end

                if arg.isSilenced or arg.isBuffering then
                    return false
                end
                local n2 = os.clock() - arg.lastUse
                local flag4 = arg.currentCooldown <= n2
                return flag4
            end
        end
    end

    local function fn49()
        if not _G.Ox.InstantTPGate.GateClientModule then
            return
        end

        if _G.Ox.InstantTPGate.oldGateNew then
            _G.Ox.InstantTPGate.GateClientModule.new = _G.Ox.InstantTPGate.oldGateNew
            _G.Ox.InstantTPGate.oldGateNew = nil
        end

        if _G.Ox.InstantTPGate.oldGateCanUse then
            _G.Ox.InstantTPGate.GateClientModule.CanUse = _G.Ox.InstantTPGate.oldGateCanUse
            _G.Ox.InstantTPGate.oldGateCanUse = nil
        end
    end

    local function fn50(enabled)
        _G.Ox.InstantTPGate.Enabled = enabled

        if enabled then
            fn47(0)
            fn48()

            lib:Notify({
                Title = "Instant TP Gate",
                Description = "AKTIF",
                Duration = 2,
            })
        else
            fn47(1.5)
            fn49()

            lib:Notify({
                Title = "Instant TP Gate",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)

        if _G.Ox.InstantTPGate.Enabled then
            fn47(0)
            fn48()
        end
    end)

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(0.5)

            if _G.Ox.InstantTPGate.Enabled then
                fn47(0)
                fn48()
            end
        end
    end)

    ResetAllTransparency = function()
        local v5, v6, v7 = pairs(currentCamera:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12 ~= localPlayer.Character then
                for k, descendant in pairs(v12:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = 0
                            descendant.Transparency = 0
                        end)
                    end
                end

                v8 = v11
            end
        end
    end

    SetWorldTransparency = function(localTransparencyModifier)
        local v5, v6, v7 = pairs(currentCamera:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12 ~= localPlayer.Character then
                for k, descendant in pairs(v12:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = localTransparencyModifier
                            descendant.Transparency = localTransparencyModifier
                        end)
                    end
                end

                v8 = v11
            end
        end
    end

    SetCharacterTransparency = function(arg, localTransparencyModifier)
        if not arg then
            return
        end
        local v5, v6, v7 = pairs(arg:GetChildren())
        local v8 = v7
        local v9 = v5
        local v10 = v6

        while true do
            local v11, v12 = v9(v10, v8)
            if v11 == nil then
                break
            end
            v8 = v11

            if v12.Name == "Hat" then
                for k, descendant in pairs(v12:GetDescendants()) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = localTransparencyModifier
                            descendant.Transparency = localTransparencyModifier
                        end)
                    end
                end

                v8 = v11
            end

            if v12:IsA("BasePart") and tbl3[v12.Name] then
                pcall(function()
                    v12.LocalTransparencyModifier = localTransparencyModifier
                    v12.Transparency = localTransparencyModifier
                end)
            end

            if v12:IsA("Tool") or v12:IsA("Model") then
                local isBasePart = v12:IsA("BasePart")
                local descendants = isBasePart

                if isBasePart then
                    local tbl8 = {}
                    descendants = tbl8
                    tbl8[1] = v12
                end

                if not descendants then
                    descendants = v12:GetDescendants()
                end

                for k, descendant in pairs(descendants) do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        pcall(function()
                            descendant.LocalTransparencyModifier = localTransparencyModifier
                            descendant.Transparency = localTransparencyModifier
                        end)
                    end
                end
            end
        end
    end

    ResetCharacterTransparency = function(arg)
        if not localPlayer.Character then
            return
        end

        if arg then
            local v5, v6, v7 = pairs(localPlayer.Character:GetChildren())
            local v8 = v7
            local v9 = v5
            local v10 = v6

            while true do
                local v11, v12 = v9(v10, v8)
                if v11 == nil then
                    break
                end
                v8 = v11

                if v12.Name == "Hat" then
                    for k, descendant in pairs(v12:GetDescendants()) do
                        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                            pcall(function()
                                descendant.LocalTransparencyModifier = 1
                                descendant.Transparency = 1
                            end)
                        end
                    end

                    v8 = v11
                end

                if v12:IsA("BasePart") and tbl3[v12.Name] then
                    pcall(function()
                        v12.LocalTransparencyModifier = 1
                        v12.Transparency = 1
                    end)
                end

                if v12:IsA("Tool") or v12:IsA("Model") then
                    local isBasePart = v12:IsA("BasePart")
                    local descendants = isBasePart

                    if isBasePart then
                        local tbl8 = {}
                        descendants = tbl8
                        tbl8[1] = v12
                    end

                    if not descendants then
                        descendants = v12:GetDescendants()
                    end

                    for k, descendant in pairs(descendants) do
                        if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                            pcall(function()
                                descendant.LocalTransparencyModifier = 1
                                descendant.Transparency = 1
                            end)
                        end
                    end
                end
            end
        else
            SetCharacterTransparency(localPlayer.Character, 0)
        end
    end

    local function fn51()
        pcall(function()
            localPlayer.CameraMode = Enum.CameraMode.Classic

            if _G.Ox.InfinityZoom and _G.Ox.InfinityZoom.Enabled then
                localPlayer.CameraMinZoomDistance = 0
                localPlayer.CameraMaxZoomDistance = math.huge
            else
                localPlayer.CameraMinZoomDistance = 0.5
                localPlayer.CameraMaxZoomDistance = 128
            end
        end)

        ResetAllTransparency()

        if localPlayer.Character then
            ResetCharacterTransparency(false)
        end
    end

    local function fn52(enabled)
        local team = localPlayer.Team
        local flag4 = team and localPlayer.Team.Name == "Killer"

        if enabled and not flag4 then
            lib:Notify({
                Title = "Akses Ditolak",
                Description = "Fitur ini khusus Killer!",
                Duration = 3,
            })

            tbl2.Enabled = false
            fn(ThirdPersonToggle, false)
            return
        end

        tbl2.Enabled = enabled

        if not enabled then
            if _G.Ox.State.ThirdPersonConn then
                _G.Ox.State.ThirdPersonConn:Disconnect()
                _G.Ox.State.ThirdPersonConn = nil
            end

            fn51()

            lib:Notify({
                Title = "Third Person",
                Description = "NONAKTIF",
                Duration = 2,
            })

            return
        end

        localPlayer.CameraMode = Enum.CameraMode.Classic
        localPlayer.CameraMinZoomDistance = 7
        localPlayer.CameraMaxZoomDistance = 128
        SetWorldTransparency(1)

        if _G.Ox.State.ThirdPersonConn then
            _G.Ox.State.ThirdPersonConn:Disconnect()
            _G.Ox.State.ThirdPersonConn = nil
        end

        _G.Ox.State.ThirdPersonConn = RunService.RenderStepped:Connect(function()
            if not tbl2.Enabled then
                return
            end

            if localPlayer.Team and localPlayer.Team.Name == "Killer" then
                localPlayer.CameraMode = Enum.CameraMode.Classic
                localPlayer.CameraMinZoomDistance = 7
                localPlayer.CameraMaxZoomDistance = 128

                if localPlayer.Character then
                    SetCharacterTransparency(localPlayer.Character, 0)
                end

                return
            end

            tbl2.Enabled = false

            if _G.Ox.State.ThirdPersonConn then
                _G.Ox.State.ThirdPersonConn:Disconnect()
                _G.Ox.State.ThirdPersonConn = nil
            end

            fn51()
            fn(ThirdPersonToggle, false)
        end)

        lib:Notify({
            Title = "Third Person",
            Description = "AKTIF - Khusus Killer",
            Duration = 3,
        })
    end

    localPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        local team = localPlayer.Team
        local name = team and localPlayer.Team.Name

        if name ~= "Killer" then
            if tbl2.Enabled then
                fn52(false)
                fn(ThirdPersonToggle, false)
            else
                fn51()
            end
        end
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.8)

        if tbl2.Enabled and localPlayer.Team and localPlayer.Team.Name == "Killer" then
            localPlayer.CameraMode = Enum.CameraMode.Classic
            localPlayer.CameraMinZoomDistance = 7
            localPlayer.CameraMaxZoomDistance = 128
        else
            fn51()
        end
    end)

    EnableUnlimitedVault = function()
        if _G.Ox.UnlimitedVaultEnabled then
            return
        end
        _G.Ox.UnlimitedVaultEnabled = true

        if _G.Ox.UnlimitedVaultConn then
            _G.Ox.UnlimitedVaultConn:Disconnect()
            _G.Ox.UnlimitedVaultConn = nil
        end

        for i, v5 in ipairs(CollectionService:GetTagged("Blocked")) do
            CollectionService:RemoveTag(v5, "Blocked")
        end

        _G.Ox.UnlimitedVaultConn = CollectionService:GetInstanceAddedSignal("Blocked"):Connect(function(arg)
            CollectionService:RemoveTag(arg, "Blocked")
        end)

        lib:Notify({
            Title = "Unlimited Vault",
            Description = "AKTIF",
            Duration = 3,
        })
    end

    DisableUnlimitedVault = function()
        _G.Ox.UnlimitedVaultEnabled = false

        if _G.Ox.UnlimitedVaultConn then
            _G.Ox.UnlimitedVaultConn:Disconnect()
            _G.Ox.UnlimitedVaultConn = nil
        end

        lib:Notify({
            Title = "Unlimited Vault",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end

    local function fn53(arg)
        if arg then
            EnableUnlimitedVault()
        else
            DisableUnlimitedVault()
        end
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1)

        if _G.Ox.UnlimitedVaultEnabled then
            for i, v5 in ipairs(CollectionService:GetTagged("Blocked")) do
                CollectionService:RemoveTag(v5, "Blocked")
            end
        end
    end)

    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end

        local v5 = nil
        local n2 = 0

        while not v5 and n2 < 10 do
            n2 = n2 + 1

            local ok, result = pcall(function()
                local modules = ReplicatedStorage:WaitForChild("Modules", 5)
                if not modules then
                    return nil
                end
                local survivors = modules:WaitForChild("Survivors", 5)
                if not survivors then
                    return nil
                end
                local survivorAnimationsController = survivors:WaitForChild("SurvivorAnimationsController", 5)
                if not survivorAnimationsController then
                    return nil
                end
                return require(survivorAnimationsController)
            end)

            if ok and result then
                v5 = result
            else
                task.wait(1)
            end
        end

        if not v5 then
            return
        end
        local isFacingStraightEnough = v5._isFacingStraightEnough

        v5._isFacingStraightEnough = function(arg, arg2, arg3, arg4)
            if not _G.Ox.Config.Surv_PerfectVault then
                return isFacingStraightEnough(arg, arg2, arg3, arg4)
            end
            arg.characterspeed = 20
            return true, 0
        end

        local onVaultAnimation = v5._onVaultAnimation

        v5._onVaultAnimation = function(arg, arg2, arg3)
            if not _G.Ox.Config.Surv_PerfectVault then
                return onVaultAnimation(arg, arg2, arg3)
            end
            return onVaultAnimation(arg, arg2, true)
        end
    end)

    local function fn54(arg)
        if not arg then
            return
        end
        arg:SetAttribute("Flowstate", true)

        if _G.Ox.FlowstateNoCD.Connection then
            _G.Ox.FlowstateNoCD.Connection:Disconnect()
            _G.Ox.FlowstateNoCD.Connection = nil
        end

        _G.Ox.FlowstateNoCD.Connection = arg:GetAttributeChangedSignal("Flowstate"):Connect(function()
            if not _G.Ox.FlowstateNoCD.Enabled then
                return
            end

            if arg:GetAttribute("Flowstate") == false then
                task.wait(0.05)
                arg:SetAttribute("Flowstate", true)
            end
        end)
    end

    local function fn55(enabled)
        _G.Ox.FlowstateNoCD.Enabled = enabled

        if _G.Ox.FlowstateNoCD.Connection then
            _G.Ox.FlowstateNoCD.Connection:Disconnect()
            _G.Ox.FlowstateNoCD.Connection = nil
        end

        if _G.Ox.FlowstateNoCD.CharAddedConn then
            _G.Ox.FlowstateNoCD.CharAddedConn:Disconnect()
            _G.Ox.FlowstateNoCD.CharAddedConn = nil
        end

        if not enabled then
            local character = localPlayer.Character

            if character then
                character:SetAttribute("Flowstate", false)
            end

            lib:Notify({
                Title = "Flowstate No CD",
                Description = "NONAKTIF",
                Duration = 2,
            })

            return
        end

        fn54(localPlayer.Character)

        _G.Ox.FlowstateNoCD.CharAddedConn = localPlayer.CharacterAdded:Connect(function(character)
            if not _G.Ox.FlowstateNoCD.Enabled then
                return
            end
            task.wait(1)
            fn54(character)
        end)

        lib:Notify({
            Title = "Flowstate No CD",
            Description = "AKTIF",
            Duration = 2,
        })
    end

    fn14 = function(enabled)
        _G.Ox.NoFall.Enabled = enabled
        local notify = lib.Notify
        local tbl8 = {Title = "No Fall Damage"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end

    local function fn56()
        local tbl8 = {}
        local map = workspace:FindFirstChild("Map")
        if not map then
            return tbl8
        end

        for k, descendant in pairs(map:GetDescendants()) do
            if descendant.Name == "Gate" then
                table.insert(tbl8, descendant)
            end
        end

        return tbl8
    end

    fn15 = function(enabled)
        _G.Ox.BypassGate.Enabled = enabled
        local v5 = fn56()

        for k, v6 in pairs(v5) do
            local leftGate = v6:FindFirstChild("LeftGate")
            local rightGate = v6:FindFirstChild("RightGate")
            local leftGateEnd = v6:FindFirstChild("LeftGate-end")
            local leftGateEnd2 = leftGateEnd or v6:FindFirstChild("LeftGate-end2")
            local rightGateEnd = v6:FindFirstChild("RightGate-end")
            local rightGateEnd2 = rightGateEnd or v6:FindFirstChild("RightGate-end2")
            local box = v6:FindFirstChild("Box")

            if enabled then
                if leftGate then
                    leftGate.Transparency = 1
                    leftGate.CanCollide = false
                end

                if rightGate then
                    rightGate.Transparency = 1
                    rightGate.CanCollide = false
                end

                if leftGateEnd2 then
                    leftGateEnd2.Transparency = 0
                end

                if rightGateEnd2 then
                    rightGateEnd2.Transparency = 0
                end

                if box then
                    box.CanCollide = false
                end
            else
                if leftGate then
                    leftGate.Transparency = 0
                    leftGate.CanCollide = true
                end

                if rightGate then
                    rightGate.Transparency = 0
                    rightGate.CanCollide = true
                end

                if leftGateEnd2 then
                    leftGateEnd2.Transparency = 1
                end

                if rightGateEnd2 then
                    rightGateEnd2.Transparency = 1
                end

                if box then
                    box.CanCollide = true
                end
            end
        end

        local notify = lib.Notify
        local tbl8 = {Title = "Bypass Gate"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end

    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Map" then
            task.wait(1)

            if _G.Ox.BypassGate.Enabled then
                fn15(true)
            end
        end
    end)

    local connection = nil

    local function fn57()
        if connection then
            return
        end
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return
        end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        connection = animator.AnimationPlayed:Connect(function(arg)
            if arg.Animation and arg.Animation.AnimationId:find("95836365038528") then
                arg:Stop(0)
            end
        end)
    end

    local function fn58()
        if connection then
            pcall(function()
                connection:Disconnect()
            end)

            connection = nil
        end
    end

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            task.wait(3)
            if not _G.Ox.ScriptAlive then
                break
            end

            if _G.Ox.SelfHeal.Enabled and localPlayer.Team and localPlayer.Team.Name ~= "Killer" then
                local character = localPlayer.Character

                if character then
                    local checkInterractable = character:FindFirstChild("CheckInterractable")
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    local flag4 = false

                    if checkInterractable and (checkInterractable:GetAttribute("isVaulting") or checkInterractable:GetAttribute("isRepairing") or checkInterractable:GetAttribute("isUnhooking") or checkInterractable:GetAttribute("isHealing") or checkInterractable:GetAttribute("isSliding")) then
                        flag4 = true
                    end

                    if not flag4 and humanoidRootPart and humanoid and humanoid.Health < humanoid.MaxHealth then
                        pcall(function()
                            local remotes = ReplicatedStorage:FindFirstChild("Remotes")

                            if remotes and remotes:FindFirstChild("Healing") then
                                remotes.Healing.HealEvent:FireServer(humanoidRootPart, true)
                            end
                        end)
                    end
                end
            end
        end
    end)

    localPlayer.CharacterRemoving:Connect(function()
        fn58()
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(5)

        if _G.Ox.SelfHeal.Enabled then
            fn57()
        end
    end)

    fn16 = function(enabled)
        _G.Ox.SelfHeal.Enabled = enabled

        if enabled then
            if localPlayer.Team and localPlayer.Team.Name == "Killer" then
                lib:Notify({
                    Title = "Self Heal",
                    Description = "Kamu harus Survivor!",
                    Duration = 3,
                })

                _G.Ox.SelfHeal.Enabled = false

                if SelfHealToggle then
                    fn(SelfHealToggle, false)
                end

                return
            end

            fn57()

            lib:Notify({
                Title = "Self Heal",
                Description = "AKTIF (Tanpa Animasi)",
                Duration = 2,
            })
        else
            fn58()

            lib:Notify({
                Title = "Self Heal",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    fn17 = function()
        local function fn59()
            repeat
                task.wait()
            until localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChild("Right Leg")

            task.wait(0.1)
            local character = localPlayer.Character

            pcall(function()
                character.Head.Transparency = 1
                local face = character.Head:FindFirstChild("face")

                if face then
                    face:Destroy()
                end

                character["Right Leg"].Transparency = 1
                local meshPart = Instance.new("MeshPart")
                meshPart.Name = "KorlessHead"
                meshPart.Size = Vector3.new(0.85, 0.85, 0.85)
                meshPart.CanCollide = false
                meshPart.MeshId = "rbxassetid://902942096"
                meshPart.TextureID = "rbxassetid://902843398"
                meshPart.CFrame = character["Right Leg"].CFrame * CFrame.new(0, 0.7, 0)
                meshPart.Parent = character
                local weldConstraint = Instance.new("WeldConstraint")
                weldConstraint.Part0 = character["Right Leg"]
                weldConstraint.Part1 = meshPart
                weldConstraint.Parent = meshPart
            end)
        end

        fn59()

        if _G.Ox.KorlessMorph.Connection then
            _G.Ox.KorlessMorph.Connection:Disconnect()
        end

        _G.Ox.KorlessMorph.Connection = localPlayer.CharacterAdded:Connect(function()
            task.wait(1)
            fn59()
        end)
    end

    fn18 = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        local v5 = nil

        for i, descendant in ipairs(workspace:GetDescendants()) do
            if string.lower(descendant.Name) == "fininshline" and descendant:IsA("BasePart") then
                v5 = descendant
                break
            end
        end

        if not v5 then
            lib:Notify({
                Title = "Instan Escape",
                Description = "Finish line tidak ditemukan!",
                Duration = 2,
            })

            return
        end

        humanoidRootPart.CFrame = v5.CFrame + Vector3.new(0, 5, 0)

        lib:Notify({
            Title = "Instan Escape",
            Description = "Berhasil!",
            Duration = 2,
        })
    end

    SetupNextKillerIndicator = function()
        if _G.Ox.NextKiller.IndicatorGui then
            _G.Ox.NextKiller.IndicatorGui:Destroy()
        end

        _G.Ox.NextKiller.IndicatorGui = Instance.new("ScreenGui")
        _G.Ox.NextKiller.IndicatorGui.Name = "NextKillerIndicator"
        _G.Ox.NextKiller.IndicatorGui.ResetOnSpawn = false
        _G.Ox.NextKiller.IndicatorGui.Parent = localPlayer:WaitForChild("PlayerGui")
    end

    StartNextKiller = function()
        if _G.Ox.NextKiller.IndicatorGui then
            return
        end
        SetupNextKillerIndicator()

        task.spawn(function()
            while _G.Ox.NextKiller.Enabled and _G.Ox.NextKiller.IndicatorGui do
                local nextKillerDisplay = _G.Ox.NextKiller.IndicatorGui:FindFirstChild("NextKillerDisplay")
                local v5 = nextKillerDisplay

                if not nextKillerDisplay then
                    local textLabel = Instance.new("TextLabel")
                    v5 = textLabel
                    textLabel.Name = "NextKillerDisplay"
                    textLabel.Size = UDim2.new(0, 150, 0, 22)
                    textLabel.Position = UDim2.new(0.5, 0, 0, 10)
                    textLabel.AnchorPoint = Vector2.new(0.5, 0)
                    textLabel.BackgroundTransparency = 0.15
                    textLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
                    textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
                    textLabel.Font = Enum.Font.GothamMedium
                    textLabel.TextSize = 11
                    textLabel.RichText = true
                    textLabel.Parent = _G.Ox.NextKiller.IndicatorGui
                    local uiCorner = Instance.new("UICorner")
                    uiCorner.CornerRadius = UDim.new(0, 6)
                    uiCorner.Parent = textLabel
                    local uiStroke3 = Instance.new("UIStroke")
                    uiStroke3.Thickness = 1
                    uiStroke3.Color = Color3.fromRGB(60, 60, 70)
                    uiStroke3.Transparency = 0.3
                    uiStroke3.Parent = textLabel
                end

                local players = Players:GetPlayers()

                table.sort(players, function(arg, arg2)
                    local attribute = arg:GetAttribute("AllowKiller")
                    local flag4 = attribute or false
                    local attribute2 = arg2:GetAttribute("AllowKiller")
                    local flag5 = attribute2 or false
                    if flag4 ~= flag5 then
                        return flag4
                    end
                    local attribute3 = arg:GetAttribute("KillerChance")
                    local n2 = attribute3 or 0
                    local attribute4 = arg2:GetAttribute("KillerChance")
                    local n3 = attribute4 or 0
                    local flag6 = n3 < n2
                    return flag6
                end)

                local v6 = players[1]

                if v6 then
                    local name = v6 == localPlayer and "<font color='#ff5555'>KAMU</font>" or v6.Name
                    v5.Text = "Next Killer: " .. name
                else
                    v5.Text = "Next Killer: <font color='#888888'>Waiting...</font>"
                end

                task.wait(1.5)
            end
        end)
    end

    StopNextKiller = function()
        if _G.Ox.NextKiller.IndicatorGui then
            _G.Ox.NextKiller.IndicatorGui:Destroy()
            _G.Ox.NextKiller.IndicatorGui = nil
        end
    end

    fn19 = function(enabled)
        _G.Ox.NextKiller.Enabled = enabled

        if enabled then
            StartNextKiller()

            lib:Notify({
                Title = "Next Killer Display",
                Description = "AKTIF - Menampilkan prediksi killer selanjutnya",
                Duration = 3,
            })
        else
            StopNextKiller()

            lib:Notify({
                Title = "Next Killer Display",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function fn59()
        local mapPredictUI = CoreGui:FindFirstChild("MapPredictUI")

        if mapPredictUI then
            mapPredictUI:Destroy()
        end
    end

    local function createScreenGui()
        local mapPredictUI = CoreGui:FindFirstChild("MapPredictUI")
        if mapPredictUI then
            return mapPredictUI
        end
        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "MapPredictUI"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.Parent = CoreGui
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "NextMapDisplay"
        textLabel.Size = UDim2.new(0, 220, 0, 22)
        textLabel.Position = UDim2.new(0.5, 0, 0, 36)
        textLabel.AnchorPoint = Vector2.new(0.5, 0)
        textLabel.BackgroundTransparency = 0.15
        textLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        textLabel.Font = Enum.Font.GothamMedium
        textLabel.TextSize = 11
        textLabel.RichText = true
        textLabel.Text = "Next Map: <font color='#888888'>Waiting...</font>"
        textLabel.Parent = screenGui2
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 6)
        uiCorner.Parent = textLabel
        local uiStroke3 = Instance.new("UIStroke")
        uiStroke3.Thickness = 1
        uiStroke3.Color = Color3.fromRGB(60, 60, 70)
        uiStroke3.Transparency = 0.3
        uiStroke3.Parent = textLabel
        return screenGui2
    end

    local function fn60()
        local map = workspace:FindFirstChild("Map")
        if not map then
            return nil
        end

        if map:FindFirstChild("random shakes") or map:FindFirstChild("SCP-173 Room") or map:FindFirstChild("SCP-205 Room") then
            return "Site 68"
        end

        if map:FindFirstChild("HooksMeat") then
            return "BLOODBATH! Club"
        end

        if map:FindFirstChild("Gate") and map.Gate:FindFirstChild("vfx") then
            return "Firelink Shrine"
        end

        if map:FindFirstChild("Bldg_Addon_RooftopUnit_A") or map:FindFirstChild("Rooftop") then
            return "Mercy Hospital Rooftop"
        end

        if map:FindFirstChild("White Armored Car") then
            return "Mount Massive Asylum"
        end

        if map:FindFirstChild("Dumbster") then
            return "The Bay Harbor"
        end

        if map:FindFirstChild("water pump") then
            return "Valdelobos Village"
        end

        if not map:FindFirstChild("LargeBoulder01") then
            return nil
        end
        return "Woodview Cabin"
    end

    fn20 = function(enabled)
        _G.Ox.MapPredict.Enabled = enabled

        if enabled then
            task.spawn(function()
                local v5 = nil
                local flag4 = false

                while _G.Ox.MapPredict.Enabled do
                    local v6 = createScreenGui()
                    local nextMapDisplay = v6:FindFirstChild("NextMapDisplay")
                    local enabled2 = false

                    pcall(function()
                        local team = localPlayer.Team
                        local flag5 = team and localPlayer.Team.Name == "Spectator"
                        enabled2 = flag5
                    end)

                    v6.Enabled = enabled2

                    if enabled2 and nextMapDisplay then
                        local flag5 = workspace:FindFirstChild("Map") ~= nil
                        local nextMap = fn60()

                        if flag4 and not flag5 then
                            local nextMap2 = v5 or "Unknown"
                            nextMapDisplay.Text = "Next Map: " .. nextMap2
                        elseif flag5 and nextMap then
                            v5 = nextMap
                            nextMapDisplay.Text = "Next Map: " .. nextMap
                        elseif flag5 and not nextMap then
                            nextMapDisplay.Text = "Next Map: Unknown"
                        else
                            nextMapDisplay.Text = "Next Map: <font color='#888888'>Waiting...</font>"
                        end

                        flag4 = flag5
                    end

                    task.wait(0.5)
                end

                fn59()
            end)

            lib:Notify({
                Title = "Next Map Prediction",
                Description = "AKTIF - Menampilkan prediksi map selanjutnya",
                Duration = 3,
            })
        else
            fn59()

            lib:Notify({
                Title = "Next Map Prediction",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local function fn61(arg)
        local v5 = tostring
        local str = arg or ""
        return v5(str):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
    end

    local function fn62(arg)
        local v5 = tostring
        local str = arg or ""
        local match, v6 = v5(str):match("^(.+)%s+(%d+)$")
        if not match then
            return nil
        end
        local str2 = match:gsub("^%s+", ""):gsub("%s+$", "")
        if str2 == "" then
            return nil
        end

        if not ({
            head = true,
            torso = true,
            humanoid = true,
            humanoidrootpart = true,
            ["left arm"] = true,
            ["right arm"] = true,
            ["left leg"] = true,
            ["right leg"] = true,
        })[str2:lower()] then
            return str2, v6
        end

        return nil
    end

    local function fn63()
        for i, player in ipairs(Players:GetPlayers()) do
            local team = player.Team
            local name = team and player.Team.Name
            if name and name:lower():find("killer") then
                return player
            end
        end

        return nil
    end

    local function fn64(arg)
        if not arg then
            return {}
        end
        local character = arg.Character
        local v5 = character or workspace:FindFirstChild(arg.Name) or workspace:FindFirstChild(arg.DisplayName)
        if not v5 then
            return {}
        end
        local tbl8 = {}
        local tbl9 = {}

        for i, child in ipairs(v5:GetChildren()) do
            local v6, v7 = fn62(child.Name)

            if v6 and not tbl9[v6] then
                tbl9[v6] = true
                table.insert(tbl8, {Name = v6, Level = v7})
            end
        end

        table.sort(tbl8, function(arg2, arg3)
            local flag4 = tostring(arg2.Name) < tostring(arg3.Name)
            return flag4
        end)

        return tbl8
    end

    local function fn65()
        local v5 = fn63()
        local name = v5

        if v5 then
            local displayName = v5.DisplayName
            name = displayName or v5.Name
        end

        if not name then
            name = "Unknown"
        end

        local v6 = fn64(v5)
        local v7 = v6

        if #v6 == 0 then
            for i, player in ipairs(Players:GetPlayers()) do
                local v8 = fn64(player)

                if #v8 > 0 then
                    local displayName = player.DisplayName
                    local name2 = displayName or player.Name
                    name = name2
                    v7 = v8
                    break
                end
            end
        end

        local tbl8 = {
            "Killer Perks [<font color=\"rgb(255,80,80)\">" .. fn61(name) .. "</font>]",
        }

        if #v7 == 0 then
            table.insert(tbl8, "<font color=\"rgb(200,200,200)\">- Waiting for perk data...</font>")
        else
            for i = 1, math.min(#v7, 4) do
                local v8 = v7[i]
                local level = v8.Level
                local str = level and " lvl " .. tostring(v8.Level) or ""
                table.insert(tbl8, "<font color=\"rgb(200,200,200)\">- " .. fn61(v8.Name .. str) .. "</font>")
            end
        end

        return table.concat(tbl8, "\n"), #v7
    end

    local function fn66()
        if _G.Ox.KillerPerks.Gui then
            pcall(function()
                _G.Ox.KillerPerks.Gui:Destroy()
            end)

            _G.Ox.KillerPerks.Gui = nil
        end

        if not _G.Ox.KillerPerks.Enabled then
            return
        end
        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "NEX_KillerPerksGui"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.Parent = CoreGui
        local frame2 = Instance.new("Frame")
        frame2.Name = "Holder"
        frame2.Size = UDim2.new(0, 180, 0, 85)
        frame2.Position = UDim2.new(0.08, 0, 0.22, 0)
        frame2.BackgroundTransparency = 1
        frame2.Active = true
        frame2.Parent = screenGui2
        local frame3 = Instance.new("Frame")
        frame3.Name = "Panel"
        frame3.Size = UDim2.new(1, 0, 1, 0)
        frame3.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
        frame3.BackgroundTransparency = 0.15
        frame3.BorderSizePixel = 0
        frame3.Parent = frame2
        Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 6)
        local uiStroke3 = Instance.new("UIStroke")
        uiStroke3.Color = Color3.fromRGB(60, 60, 70)
        uiStroke3.Thickness = 1
        uiStroke3.Transparency = 0.3
        uiStroke3.Parent = frame3
        local frame4 = Instance.new("Frame")
        frame4.Size = UDim2.new(1, 0, 0, 24)
        frame4.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        frame4.BorderSizePixel = 0
        frame4.Parent = frame3
        Instance.new("UICorner", frame4).CornerRadius = UDim.new(0, 6)
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -60, 1, 0)
        textLabel.Position = UDim2.new(0, 8, 0, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.GothamSemibold
        textLabel.Text = "Killer Perks Info"
        textLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
        textLabel.TextSize = 11
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame4

        local function createTextButton(text, arg, arg2)
            local textButton = Instance.new("TextButton")
            textButton.Size = UDim2.new(0, 26, 0, 16)
            textButton.Position = UDim2.new(1, arg, 0, 4)
            local color = arg2 or Color3.fromRGB(25, 25, 30)
            textButton.BackgroundColor3 = color
            textButton.BorderSizePixel = 0
            textButton.Font = Enum.Font.GothamMedium
            textButton.Text = text
            textButton.TextColor3 = Color3.fromRGB(200, 200, 210)
            textButton.TextSize = 9
            textButton.Parent = frame4
            Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 4)
            return textButton
        end

        local Minimize = createTextButton("Minimize", -54, Color3.fromRGB(30, 30, 40))
        local Close = createTextButton("Close", -28, Color3.fromRGB(40, 25, 25))
        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Name = "KillerPerksText"
        textLabel2.Size = UDim2.new(1, -14, 1, -32)
        textLabel2.Position = UDim2.new(0, 8, 0, 28)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Font = Enum.Font.GothamMedium
        textLabel2.RichText = true
        textLabel2.TextXAlignment = Enum.TextXAlignment.Left
        textLabel2.TextYAlignment = Enum.TextYAlignment.Top
        textLabel2.TextColor3 = Color3.fromRGB(220, 220, 230)
        textLabel2.TextSize = 11
        textLabel2.TextWrapped = false
        textLabel2.Parent = frame3

        Minimize.MouseButton1Click:Connect(function()
            local killerPerks = _G.Ox.KillerPerks
            local minimized

            if _G.Ox.KillerPerks.Minimized then
                minimized = false
            else
                minimized = true
            end

            killerPerks.Minimized = minimized
            local visible

            if _G.Ox.KillerPerks.Minimized then
                visible = false
            else
                visible = true
            end

            textLabel2.Visible = visible
            local minimized2 = _G.Ox.KillerPerks.Minimized
            local text = minimized2 and "Show" or "Minimize"
            Minimize.Text = text
            local minimized3 = _G.Ox.KillerPerks.Minimized
            local udim2 = minimized3 and UDim2.new(0, 180, 0, 24) or UDim2.new(0, 180, 0, 85)
            frame2.Size = udim2
        end)

        Close.MouseButton1Click:Connect(function()
            _G.Ox.KillerPerks.Enabled = false

            if _G.Ox.KillerPerks.Gui then
                pcall(function()
                    _G.Ox.KillerPerks.Gui:Destroy()
                end)

                _G.Ox.KillerPerks.Gui = nil
            end

            if KillerPerksToggle then
                fn(KillerPerksToggle, false)
            end
        end)

        local flag4 = false
        local position = nil
        local position2 = nil

        frame2.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag4 = true
                position = input.Position
                position2 = frame2.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        flag4 = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not flag4 or not position or not position2 then
                return
            end

            if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local n2 = input.Position - position
            frame2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n2.X, position2.Y.Scale, position2.Y.Offset + n2.Y)
        end)

        screenGui2.Parent = CoreGui
        _G.Ox.KillerPerks.Gui = screenGui2

        task.spawn(function()
            while _G.Ox.KillerPerks.Enabled and _G.Ox.KillerPerks.Gui do
                if not _G.Ox.KillerPerks.Minimized then
                    local v5, v6 = fn65()
                    textLabel2.Text = v5
                    local n2 = math.max(2, math.min(v6 + 1, 5))
                    frame2.Size = UDim2.new(0, 180, 0, math.max(65, 28 + n2 * 15))
                end

                task.wait(1)
            end
        end)
    end

    fn21 = function(enabled)
        _G.Ox.KillerPerks.Enabled = enabled

        if enabled then
            fn66()

            lib:Notify({
                Title = "Killer Perks Display",
                Description = "AKTIF - Menampilkan perk killer yang digunakan",
                Duration = 3,
            })
        else
            if _G.Ox.KillerPerks.Gui then
                pcall(function()
                    _G.Ox.KillerPerks.Gui:Destroy()
                end)

                _G.Ox.KillerPerks.Gui = nil
            end

            lib:Notify({
                Title = "Killer Perks Display",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    PlayHitSound = function()
        if not _G.Ox.Stun.HitSoundEnabled then
            return
        end
        local now = tick()
        if now - _G.Ox.Stun.HitSoundLastTime < _G.Ox.Stun.HitSoundCooldown then
            return
        end
        _G.Ox.Stun.HitSoundLastTime = now

        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = _G.Ox.Stun.HitSoundId
            sound.Volume = _G.Ox.Stun.HitSoundVolume
            sound.PlayOnRemove = true
            local currentCamera2 = workspace.CurrentCamera
            local v5 = currentCamera2 or workspace
            sound.Parent = v5
            sound:Play()

            task.delay(sound.TimeLength + 0.1, function()
                if sound and sound.Parent then
                    sound:Destroy()
                end
            end)
        end)
    end

    local function fn67(arg)
        local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        local stunRingUI = humanoidRootPart:FindFirstChild("StunRingUI")

        if stunRingUI then
            stunRingUI:Destroy()
        end

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "StunRingUI"
        billboardGui.Adornee = humanoidRootPart
        billboardGui.AlwaysOnTop = true
        billboardGui.Size = UDim2.new(0, 40, 0, 40)
        billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 4.5, 0)
        billboardGui.ResetOnSpawn = false
        billboardGui.LightInfluence = 0
        billboardGui.Parent = humanoidRootPart
        local imageLabel = Instance.new("ImageLabel", billboardGui)
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.Position = UDim2.new(0, 0, 0, 0)
        imageLabel.BackgroundTransparency = 1
        imageLabel.Image = "rbxassetid://129594563448607"
        imageLabel.ScaleType = Enum.ScaleType.Fit
        billboardGui.Enabled = false

        return billboardGui, task.spawn(function()
            local n2 = 0
            local currentCamera2 = workspace.CurrentCamera

            while billboardGui and billboardGui.Parent do
                if billboardGui.Enabled then
                    local rotation = (n2 + 6) % 360
                    n2 = rotation
                    imageLabel.Rotation = rotation
                    local n3 = math.clamp(math.floor(600 / (currentCamera2.CFrame.Position - humanoidRootPart.Position).Magnitude), 22, 44)
                    billboardGui.Size = UDim2.new(0, n3, 0, n3)
                end

                task.wait(0.1)
            end
        end)
    end

    local function fn68(arg)
        if not arg or _G.Ox.Stun.Data[arg] then
            return
        end
        local v5, v6 = fn67(arg)
        if not v5 then
            return
        end

        local tbl8 = {
            stunRing = v5,
            stunSpinThread = v6,
            _stunTimer = nil,
            extraConns = {},
        }

        _G.Ox.Stun.Data[arg] = tbl8

        local function fn69(arg2)
            if not tbl8.stunRing then
                return
            end
            tbl8.stunRing.Enabled = true

            if tbl8._stunTimer then
                task.cancel(tbl8._stunTimer)
            end

            tbl8._stunTimer = task.delay(arg2, function()
                if tbl8.stunRing then
                    tbl8.stunRing.Enabled = false
                end
            end)
        end

        local connection2 = arg:GetAttributeChangedSignal("IsStunned"):Connect(function()
            if arg:GetAttribute("IsStunned") == true then
                fn69(2.2)
            end
        end)

        local connection3 = arg:GetAttributeChangedSignal("Immobile"):Connect(function()
            if arg:GetAttribute("Immobile") == true then
                fn69(2.2)
            end
        end)

        table.insert(tbl8.extraConns, connection2)
        table.insert(tbl8.extraConns, connection3)
    end

    local function fn69(arg)
        local v5 = _G.Ox.Stun.Data[arg]

        if v5 then
            if v5._stunTimer then
                task.cancel(v5._stunTimer)
            end

            if v5.stunSpinThread then
                task.cancel(v5.stunSpinThread)
            end

            if v5.stunRing then
                v5.stunRing:Destroy()
            end

            if v5.extraConns then
                for i, extraConn in ipairs(v5.extraConns) do
                    pcall(function()
                        extraConn:Disconnect()
                    end)
                end
            end

            _G.Ox.Stun.Data[arg] = nil
        end
    end

    local function fn70()
        if not _G.Ox.Stun.Enabled then
            return
        end

        for i, player in ipairs(Players:GetPlayers()) do
            if IsKiller(player) and player.Character then
                fn68(player.Character)
            end
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if not _G.Ox.Stun.Enabled then
            return
        end

        player.CharacterAdded:Connect(function(character)
            task.wait(0.5)

            if _G.Ox.Stun.Enabled and IsKiller(player) then
                fn68(character)
            end
        end)

        task.wait(0.5)

        if _G.Ox.Stun.Enabled and IsKiller(player) and player.Character then
            fn68(player.Character)
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        player:GetPropertyChangedSignal("Team"):Connect(function()
            if not _G.Ox.Stun.Enabled then
                return
            end
            task.wait(0.5)

            if IsKiller(player) and player.Character then
                fn69(player.Character)
                task.wait(0.1)
                fn68(player.Character)
            end
        end)
    end)

    Players.PlayerAdded:Connect(function(player)
        task.wait(0.5)

        if _G.Ox.Stun.Enabled then
            fn70()
        end
    end)

    localPlayer.CharacterAdded:Connect(function()
        task.wait(1.5)

        if _G.Ox.Stun.Enabled then
            fn70()
        end
    end)

    task.spawn(function()
        local v5, v6, v7, v8, v9, v10, humanoidRootPart, n2
        n2 = 1

        while true do
            if n2 == 1 then
                if _G.Ox.ScriptAlive then
                    n2 = 2
                else
                    n2 = 9
                end
            elseif n2 == 2 then
                task.wait(5)

                if _G.Ox.ScriptAlive then
                    n2 = 3
                else
                    n2 = 9
                end
            elseif n2 == 3 then
                if _G.Ox.Stun.Enabled then
                    n2 = 4
                else
                    n2 = 1
                end
            elseif n2 == 4 then
                v5, v6, v7 = ipairs(Players:GetPlayers())
                v8 = v7
                n2 = 5
            elseif n2 == 5 then
                v9, v10 = v5(v6, v8)

                if v9 == nil then
                    n2 = 1
                else
                    n2 = 6
                end
            elseif n2 == 6 then
                v8 = v9

                if IsKiller(v10) and v10.Character then
                    n2 = 7
                else
                    n2 = 5
                end
            elseif n2 == 7 then
                humanoidRootPart = v10.Character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart and not humanoidRootPart:FindFirstChild("StunRingUI") then
                    n2 = 8
                else
                    n2 = 5
                end
            elseif n2 == 8 then
                fn68(v10.Character)
                n2 = 5
            elseif n2 == 9 then
                return
            end
        end
    end)

    fn22 = function(enabled)
        _G.Ox.Stun.Enabled = enabled

        if enabled then
            for k in pairs(_G.Ox.Stun.Data) do
                fn69(k)
            end

            _G.Ox.Stun.Data = {}
            task.wait(0.5)
            fn70()

            lib:Notify({
                Title = "Stun Indicator",
                Description = "AKTIF - Menampilkan stun pada killer",
                Duration = 3,
            })
        else
            for k in pairs(_G.Ox.Stun.Data) do
                fn69(k)
            end

            _G.Ox.Stun.Data = {}

            lib:Notify({
                Title = "Stun Indicator",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    AntiHook_GetRemote = function()
        if _G.Ox.AntiHook.Remote and _G.Ox.AntiHook.Remote.Parent then
            return _G.Ox.AntiHook.Remote
        end
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local game_ = remotes and remotes:FindFirstChild("Game")
        local updateCharacterLook = game_ and game_:FindFirstChild("UpdateCharacterLook")
        _G.Ox.AntiHook.Remote = updateCharacterLook
        return updateCharacterLook
    end

    AntiHook_SendRemoteUpdate = function()
        if not localPlayer.Character then
            return
        end
        local v5 = AntiHook_GetRemote()
        if not v5 then
            return
        end
        local cframe = CFrame.new(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        local cframe2 = CFrame.new(0, _G.Ox.AntiHook.OffsetY, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1)

        pcall(function()
            v5:FireServer(cframe, cframe2, cframe2, cframe2, cframe2)
            local antiHook = _G.Ox.AntiHook
            antiHook.SendCounter = antiHook.SendCounter + 1
        end)
    end

    AntiHook_Update = function(arg)
        if not _G.Ox.AntiHook.Enabled then
            return
        end
        local character = localPlayer.Character
        if not character then
            _G.Ox.AntiHook.Accumulator = 0
            return
        end

        if character:GetAttribute("IsCarried") == true then
            local accumulator = _G.Ox.AntiHook.Accumulator + arg
            local interval = _G.Ox.AntiHook.Interval

            if interval <= accumulator then
                local accumulator2 = accumulator - interval
                AntiHook_SendRemoteUpdate()

                if interval <= accumulator2 then
                    local accumulator3 = accumulator2 - interval
                    AntiHook_SendRemoteUpdate()

                    if interval <= accumulator3 then
                        AntiHook_SendRemoteUpdate()
                        _G.Ox.AntiHook.Accumulator = accumulator3 - interval
                        return
                    end

                    _G.Ox.AntiHook.Accumulator = accumulator3
                    return
                end

                _G.Ox.AntiHook.Accumulator = accumulator2
                return
            end

            _G.Ox.AntiHook.Accumulator = accumulator
            return
        end

        _G.Ox.AntiHook.Accumulator = 0
    end

    StartAntiHook = function()
        if _G.Ox.AntiHook.Connection then
            return
        end
        _G.Ox.AntiHook.Accumulator = 0
        _G.Ox.AntiHook.Connection = RunService.Heartbeat:Connect(AntiHook_Update)
    end

    StopAntiHook = function()
        if _G.Ox.AntiHook.Connection then
            _G.Ox.AntiHook.Connection:Disconnect()
            _G.Ox.AntiHook.Connection = nil
        end

        _G.Ox.AntiHook.Accumulator = 0
    end

    task.spawn(function()
        while true do
            task.wait(1)
            local now = os.clock()
            local n2 = now - _G.Ox.AntiHook.LastCounterTime
            local sendCounter = _G.Ox.AntiHook.SendCounter

            if _G.Ox.AntiHook.Enabled and n2 > 0 and sendCounter > 0 then
                print(string.format("[AntiHook] Actual rate: %.2f Hz (%d sends in %.2fs)", sendCounter / n2, sendCounter, n2))
            end

            _G.Ox.AntiHook.SendCounter = 0
            _G.Ox.AntiHook.LastCounterTime = now
        end
    end)

    ToggleAntiHook = function(enabled)
        _G.Ox.AntiHook.Enabled = enabled

        if enabled then
            StartAntiHook()
            lib:Notify({Title = "Anti Hook", Description = "AKTIF", Duration = 2})
        else
            StopAntiHook()

            lib:Notify({
                Title = "Anti Hook",
                Description = "NONAKTIF",
                Duration = 2,
            })
        end
    end

    local Main = v:CreateTab("Main", false, false)
    MainTab = Main
    local Main2 = MainTab:CreatePage("Main")
    M_Page = Main2
    local Movement = M_Page:CreateSection("Movement", "move")
    MovementCard = Movement

    local v5 = MovementCard:AddToggle("Auto Vault", false, function(autoVaultEnabled)
        _G.Ox.autoVaultEnabled = autoVaultEnabled
        local notify = lib.Notify
        local tbl8 = {Title = "Auto Vault"}
        local description = autoVaultEnabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "AutoVault"})

    AutoVaultToggle = v5
    AutoVaultToggle:AddKeyPicker("None")

    local v6 = MovementCard:AddToggle("Auto Pallet Slide", false, function(autoPalletSlideEnabled)
        _G.Ox.autoPalletSlideEnabled = autoPalletSlideEnabled
        local notify = lib.Notify
        local tbl8 = {Title = "Auto Pallet Slide"}
        local description = autoPalletSlideEnabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "AutoPalletSlide"})

    AutoSlideToggle = v6
    AutoSlideToggle:AddKeyPicker("None")

    local v7 = MovementCard:AddToggle("Auto Run PC", false, function(pc)
        _G.Ox.AutoRun.PC = pc

        if pc then
            task.spawn(function()
                while _G.Ox.AutoRun.PC do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, localPlayer:GetMouse())
                    task.wait(0.1)
                end
            end)
        else
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, localPlayer:GetMouse())
        end
    end, {Flag = "AutoRunPc"})

    AutoRunPCToggle = v7

    local v8 = MovementCard:AddToggle("Auto Run Mobile", false, function(mobile)
        _G.Ox.AutoRun.Mobile = mobile

        if mobile then
            fn5()
        else
            fn6()
        end
    end, {Flag = "AutoRunMobile"})

    AutoRunMobileToggle = v8

    local v9 = MovementCard:AddToggle("Enable Speed Boost", false, function(enabled)
        _G.Ox.Speed.Enabled = enabled
        local notify = lib.Notify
        local tbl8 = {Title = "Speed Boost"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "SpeedBoost"})

    SpeedToggle = v9

    SpeedToggle:AddKeyPicker("SpeedBoostKey", {
        Default = "None",
        Text = "Toggle Speed Boost",
        Mode = "Toggle",
        Callback = function(enabled)
            _G.Ox.Speed.Enabled = enabled

            if SpeedToggle then
                fn(SpeedToggle, enabled)
            end
        end,
    })

    MovementCard:AddSlider("SpeedAmount", 0.1, 3, 0.1, function(value)
        _G.Ox.Speed.Value = value
    end, {Increment = 0.1, Flag = "SpeedAmount"})

    _G.Ox.SkipEndscreen = false
    local v10 = M_Page:CreateSection("Server Utility", "server-cog")
    ServerUtilityCard = v10

    local v11 = ServerUtilityCard:AddToggle("Skip Endscreen", false, function(skipEndscreen)
        _G.Ox.SkipEndscreen = skipEndscreen
        local notify = lib.Notify
        local tbl8 = {Title = "Skip Endscreen"}
        local description = skipEndscreen and "AKTIF - Endscreen otomatis dilewati" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "SkipEndscreen"})

    SkipEndscreenToggle = v11

    SkipEndscreenToggle:AddKeyPicker("SkipEndKey", {
        Default = "None",
        Text = "Toggle Skip Endscreen",
        Mode = "Toggle",
        Callback = function(skipEndscreen)
            _G.Ox.SkipEndscreen = skipEndscreen

            if SkipEndscreenToggle then
                SkipEndscreenToggle:SetValue(skipEndscreen)
            end
        end,
    })

    task.spawn(function()
        while _G.Ox.ScriptAlive do
            if _G.Ox.SkipEndscreen then
                pcall(function()
                    local map = workspace:FindFirstChild("Map")

                    if map then
                        local endscreen = map:FindFirstChild("endscreen", true)

                        if endscreen then
                            for i, descendant in ipairs(endscreen:GetDescendants()) do
                                if descendant:IsA("LocalScript") then
                                    descendant.Disabled = true
                                end
                            end

                            endscreen:Destroy()
                        end
                    end

                    local results = playerGui:FindFirstChild("Results")

                    if results then
                        local frame2 = results:FindFirstChild("Frame")

                        if frame2 then
                            local close = frame2:FindFirstChild("Close")

                            if close and frame2.Visible and close.Visible then
                                pcall(function()
                                    firesignal(close.MouseButton1Click)
                                end)
                            end
                        end
                    end
                end)
            end

            task.wait(1)
        end
    end)

    local v12 = M_Page:CreateSection("Fake Perks", "sparkles")
    FakePerksCard = v12

    local v13 = FakePerksCard:AddToggle("Quick Recovery", false, function(arg)
        ToggleQuickRecovery(arg)
    end, {Flag = "FakeQR"})

    QR_Toggle = v13
    QR_Toggle:AddKeyPicker("None")

    local v14 = FakePerksCard:AddToggle("Perfect Landing", false, function(arg)
        TogglePerfectLanding(arg)
    end, {Flag = "FakePL"})

    PL_Toggle = v14
    PL_Toggle:AddKeyPicker("None")

    local Flowstate = FakePerksCard:AddToggle("Flowstate", false, function(arg)
        ToggleFlowstate(arg)
    end, {Flag = "FakeFS"})

    FS_Toggle = Flowstate
    FS_Toggle:AddKeyPicker("None")

    local v15 = FakePerksCard:AddToggle("Adrenaline Rush", false, function(arg)
        SetupFakeAdrenalineRush(arg)
    end, {Flag = "FakeAR"})

    AR_Toggle = v15
    AR_Toggle:AddKeyPicker("None")

    FakePerksCard:AddSlider("Perk Cooldown", 0, 180, 10, function(perkCooldown)
        _G.Ox.FakePerks.PerkCooldown = perkCooldown
    end, {Increment = 1, Flag = "FakePerkColdown"})

    local v16 = M_Page:CreateSection("Camera Settings", "camera")
    CameraCard = v16

    local v17 = CameraCard:AddToggle("Enable Stretch Res", false, function(arg)
        fn43(arg)
    end, {Flag = "SretchRes"})

    StretchToggle = v17
    StretchToggle:AddKeyPicker("None")

    CameraCard:AddSlider("Stretch Amount", 0.4, 1, 0.67, function(amount)
        _G.Ox.StretchRes.Amount = amount
    end, {Increment = 0.01, Flag = "StretchAmount"})

    local v18 = CameraCard:AddToggle("Third Person (Killer)", false, function(arg)
        fn52(arg)
    end, {Flag = "ThirdPerson"})

    ThirdPersonToggle = v18

    local v19 = CameraCard:AddToggle("Infinity Zoom Out", false, function(arg)
        fn44(arg)
    end, {Flag = "InfinityZoom"})

    InfinityToggle = v19

    local v20 = CameraCard:AddToggle("Camera FOV", false, function(arg)
        fn45(arg)
    end, {Flag = "CameraFov"})

    FOVToggle = v20

    CameraCard:AddSlider("FOV Value", 60, 120, 90, function(arg)
        fn46(arg)
    end, {Increment = 0, Flag = "FOVValue"})

    local v21 = M_Page:CreateSection("Camera DBD", "camera")
    DbdCard = v21

    _G.Ox.DBD = {
        Enabled = false,
        Distance = 13,
        Height = 4.2,
        RunSmooth = 0.1,
        LookSmooth = 0.28,
        Sens = 0.55,
        PitchMin = -0.55,
        PitchMax = 0.45,
        FOV = 70,
        yaw = 0,
        pitch = 0.12,
        lookInput = nil,
        lastPos = nil,
        conn = nil,
        chg = nil,
        beg = nil,
        endc = nil,
        oldFOV = nil,
    }

    DBD_isLookTouch = function(arg)
        local flag4 = currentCamera.ViewportSize.X * 0.22 < arg.X
        return flag4
    end

    DBD_initYaw = function()
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        local n2 = humanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

        if n2.Magnitude > 0.05 then
            _G.Ox.DBD.yaw = math.atan2(-n2.X, -n2.Z)
        end
    end

    DBD_Stop = function()
        local dbd = _G.Ox.DBD

        if dbd.conn then
            dbd.conn:Disconnect()
            dbd.conn = nil
        end

        if dbd.chg then
            dbd.chg:Disconnect()
            dbd.chg = nil
        end

        if dbd.beg then
            dbd.beg:Disconnect()
            dbd.beg = nil
        end

        if dbd.endc then
            dbd.endc:Disconnect()
            dbd.endc = nil
        end

        currentCamera.CameraType = Enum.CameraType.Custom

        if dbd.oldFOV then
            currentCamera.FieldOfView = dbd.oldFOV
        end

        dbd.lookInput = nil
        dbd.lastPos = nil
    end

    DBD_Start = function()
        DBD_Stop()
        local dbd = _G.Ox.DBD
        if not dbd.Enabled then
            return
        end
        DBD_initYaw()
        dbd.oldFOV = currentCamera.FieldOfView
        currentCamera.CameraType = Enum.CameraType.Scriptable
        currentCamera.FieldOfView = dbd.FOV
        local character = localPlayer.Character
        local humanoid = character and localPlayer.Character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid.AutoRotate = true
        end

        dbd.chg = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end

            if input ~= dbd.lookInput then
                return
            end
            local position = input.Position

            if dbd.lastPos then
                dbd.yaw = dbd.yaw - (position.X - dbd.lastPos.X) * 0.011 * dbd.Sens
                dbd.pitch = math.clamp(dbd.pitch - (position.Y - dbd.lastPos.Y) * 0.011 * dbd.Sens, dbd.PitchMin, dbd.PitchMax)
            end

            dbd.lastPos = position
        end)

        dbd.beg = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and DBD_isLookTouch(input.Position) then
                dbd.lookInput = input
                dbd.lastPos = input.Position
            end
        end)

        dbd.endc = UserInputService.InputEnded:Connect(function(input)
            if input == dbd.lookInput then
                dbd.lookInput = nil
                dbd.lastPos = nil
            end
        end)

        dbd.conn = RunService.RenderStepped:Connect(function(deltaTime)
            if not dbd.Enabled then
                return
            end
            local character2 = localPlayer.Character
            local humanoidRootPart = character2 and localPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then
                return
            end
            local vector = Vector3.new(math.sin(dbd.yaw) * math.cos(dbd.pitch), math.sin(dbd.pitch), math.cos(dbd.yaw) * math.cos(dbd.pitch))
            local n2 = humanoidRootPart.Position + Vector3.new(0, 1.6, 0)
            local n3 = n2 - vector * dbd.Distance + Vector3.new(0, dbd.Height - 1.6, 0)
            local cframe = CFrame.lookAt(n3, n2)
            local lookInput = dbd.lookInput
            local lookSmooth = lookInput and dbd.LookSmooth or dbd.RunSmooth
            local n4 = 1 - math.pow(1 - lookSmooth, deltaTime * 60)
            currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, n4)
        end)
    end

    localPlayer.CharacterAdded:Connect(function()
        task.wait(0.6)

        if _G.Ox.DBD.Enabled then
            DBD_Start()
        end
    end)

    DbdCard:AddToggle("DBD Camera", false, function(enabled)
        _G.Ox.DBD.Enabled = enabled

        if enabled then
            if _G.Ox.CameraFOV then
                _G.Ox.CameraFOV.Enabled = false
            end

            DBD_Start()
        else
            DBD_Stop()
        end

        local notify = lib.Notify
        local tbl8 = {Title = "DBD Camera"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "DBDCamera"})

    DbdCard:AddSlider("DBD Distance", 6, 20, 13, function(distance)
        _G.Ox.DBD.Distance = distance
    end, {Increment = 0.1, Flag = "DBDDistance"})

    DbdCard:AddSlider("DBD Height", 1, 8, 4.2, function(height)
        _G.Ox.DBD.Height = height
    end, {Increment = 0.1, Flag = "DBDHeight"})

    DbdCard:AddSlider("DBD Run Smooth", 0.03, 0.35, 0.1, function(runSmooth)
        _G.Ox.DBD.RunSmooth = runSmooth
    end, {Increment = 0.01, Flag = "DBDRunSmooth"})

    DbdCard:AddSlider("DBD Look Smooth", 0.08, 0.6, 0.28, function(lookSmooth)
        _G.Ox.DBD.LookSmooth = lookSmooth
    end, {Increment = 0.01, Flag = "DBDLookSmooth"})

    DbdCard:AddSlider("DBD Sensitivity", 0.15, 1.2, 0.55, function(sens)
        _G.Ox.DBD.Sens = sens
    end, {Increment = 0.01, Flag = "DBDSens"})

    DbdCard:AddSlider("DBD Pitch Min", -1.2, 0, -0.55, function(pitchMin)
        _G.Ox.DBD.PitchMin = pitchMin
    end, {Increment = 0.01, Flag = "DBDPitchMin"})

    DbdCard:AddSlider("DBD Pitch Max", 0, 1.2, 0.45, function(pitchMax)
        _G.Ox.DBD.PitchMax = pitchMax
    end, {Increment = 0.01, Flag = "DBDPitchMax"})

    DbdCard:AddSlider("DBD FOV", 50, 90, 70, function(fov)
        _G.Ox.DBD.FOV = fov

        if _G.Ox.DBD.Enabled then
            currentCamera.FieldOfView = fov
        end
    end, {Increment = 1, Flag = "DBDFOV"})

    local v22 = M_Page:CreateSection("Streamer Mode", "eye-off")
    StreamerCard = v22

    local v23 = StreamerCard:AddToggle("Streamer Mode", false, function(arg)
        fn42(arg)
    end, {Flag = "StreamerMode"})

    StreamerToggle = v23
    StreamerToggle:AddKeyPicker("None")
    local v24 = M_Page:CreateSection("Players Utility", "user-cog")
    UtilityCard = v24

    local v25 = UtilityCard:AddToggle("Invisibility [OP]", false, function(invisEnabled)
        _G.Ox.Utility.InvisEnabled = invisEnabled
        fn8(invisEnabled)
    end)

    InvisToggle = v25

    local v26 = UtilityCard:AddToggle("Fast Bandage", false, function(bandageEnabled)
        _G.Ox.Utility.BandageEnabled = bandageEnabled
        fn9(bandageEnabled)
    end)

    BandageToggle = v26

    UtilityCard:AddSlider("BandageSpeed", 10, 200, 50, function(bandageSpeed)
        _G.Ox.Utility.BandageSpeed = bandageSpeed

        if v2 and v2.Config then
            v2.Config.PreClicksCount = bandageSpeed
        end
    end, {Increment = 1, Flag = "BandageSpeed"})

    local v27 = UtilityCard:AddToggle("Moonwalk GUI", false, function(arg)
        if arg then
            if not _G.Ox.Moonwalk.Gui then
                CreateMoonwalkGUI()
            end

            _G.Ox.Moonwalk.Gui.Enabled = true
            _G.Ox.Moonwalk.GuiVisible = true
            UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)

            lib:Notify({
                Title = "Moonwalk GUI",
                Description = "Gui Dimuat",
                Duration = 2,
            })
        else
            if _G.Ox.Moonwalk.Enabled then
                StopMoonwalk()

                if MoonwalkPCToggle then
                    fn(MoonwalkPCToggle, false)
                end
            end

            if _G.Ox.Moonwalk.Gui then
                _G.Ox.Moonwalk.Gui.Enabled = false
                _G.Ox.Moonwalk.GuiVisible = false
            end

            lib:Notify({
                Title = "Moonwalk GUI",
                Description = "Gui Disembunyikan",
                Duration = 2,
            })
        end
    end, {Flag = "MoonwalkGui"})

    MoonwalkGUIToggle = v27

    local v28 = UtilityCard:AddToggle("Moonwalk PC", false, function(arg)
        if arg then
            StartMoonwalk()
        else
            StopMoonwalk()
        end

        UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)
        local notify = lib.Notify
        local tbl8 = {Title = "Moonwalk PC"}
        local description = arg and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "MoonwalkPC"})

    MoonwalkPCToggle = v28

    MoonwalkPCToggle:AddKeyPicker("MoonwalkPCKey", {
        Default = "None",
        Text = "Toggle Moonwalk",
        Mode = "Toggle",
        Callback = function(arg)
            if arg then
                StartMoonwalk()
            else
                StopMoonwalk()
            end

            UpdateMoonwalkGUI(_G.Ox.Moonwalk.Enabled)

            if MoonwalkPCToggle then
                fn(MoonwalkPCToggle, arg)
            end
        end,
    })

    UtilityCard:AddButton("Fly GUI", function()
        local flag4 = false

        for k, child in pairs(game.CoreGui:GetChildren()) do
            if child.Name:lower():find("fly") then
                flag4 = true
            end
        end

        if flag4 then
            lib:Notify({
                Title = "Fly GUI",
                Description = "Fly GUI sudah terbuka",
                Duration = 2,
            })
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

            lib:Notify({
                Title = "Fly GUI",
                Description = "Fly GUI Dimuat",
                Duration = 3,
            })
        end
    end)

    local Crosshair = M_Page:CreateSection("Crosshair", "crosshair")
    CrosshairBox = Crosshair

    local v29 = CrosshairBox:AddToggle("Enable Crosshair", false, function(enabled)
        _G.Ox.Crosshair.Enabled = enabled

        if not enabled then
            ClearCrosshair()
        end

        local notify = lib.Notify
        local tbl8 = {Title = "Crosshair"}
        local description = enabled and "AKTIF" or "NONAKTIF"
        tbl8.Description = description
        tbl8.Duration = 2
        notify(lib, tbl8)
    end, {Flag = "Crosshair"})

    CrosshairToggle = v29

    CrosshairToggle:AddKeyPicker("CrosshairKey", {
        Default = "None",
        Text = "Toggle Crosshair",
        Mode = "Toggle",
        Callback = function(enabled)
            _G.Ox.Crosshair.Enabled = enabled

            if not enabled then
                ClearCrosshair()
            end
        end,
    })

    CrosshairToggle:AddColorPicker(_G.Ox.Crosshair.Color, {
        Flag = "Crosshair_Color",
        Title = "Crosshair Color",
        Callback = function(color)
            _G.Ox.Crosshair.Color = color
        end,
    })

    CrosshairBox:AddDropdown("Style", {"Plus", "Dot", "Circle"}, false, function(style)
        _G.Ox.Crosshair.Style = style
        ClearCrosshair()
        _G.Ox.CrosshairCreated = false
    end, {Flag = "CrosshairStyle"})

    CrosshairBox:AddSlider("Size", 2, 30, 8, function(size)
        _G.Ox.Crosshair.Size = size
    end, {Increment = 1, Flag = "CrosshairSize"})

    CrosshairBox:AddSlider("Thickness", 1, 5, 2, function(thickness)
        _G.Ox.Crosshair.Thickness = thickness
    end, {Increment = 1, Flag = "CrosshairThickness"})

    CrosshairBox:AddSlider("Position X", -100, 100, 0, function(offsetX)
        _G.Ox.Crosshair.OffsetX = offsetX
    end, {Increment = 1, Flag = "CrosshairX"})

    CrosshairBox:AddSlider("Position Y", -100, 100, 0, function(offsetY)
        _G.Ox.Crosshair.OffsetY = offsetY
    end, {Increment = 1, Flag = "CrosshairY"})

    local v30 = M_Page:CreateSection("Copy Avatar", "shirt")
    FakeAvatarSection = v30

    Pandu_RANDOM_IDS = {
        978663613,
        5261700291,
        1846241644,
        4993456331,
        424866237,
        4312175249,
    }

    Pandu_CURRENT_AVATAR = nil
    Pandu_ORIGINAL_ID = localPlayer.UserId
    Pandu_FAVORITES = {}
    Pandu_Applying = false
    Pandu_RespawnConnection = nil
    Pandu_SelectedFav = nil
    Pandu_FakeThumbUserId = nil
    Pandu_ThumbConn = nil
    Pandu_ThumbPropConns = {}

    Pandu_ThumbUrl = function(arg, arg2, arg3)
        local n2 = arg2 or 150
        local v31 = n2
        local n3 = arg3 or 150
        local v32 = n3
        local format = string.format
        local num = tonumber(arg)
        local n4 = num or 0
        return format("rbxthumb://type=AvatarHeadShot&id=%d&w=%d&h=%d", n4, v31, v32)
    end

    Pandu_ExtractThumbUserId = function(arg)
        if type(arg) == "string" and arg ~= "" then
            return tonumber(arg:match("rbxthumb://[^%s]*id=(%d+)"))
        end
        return nil
    end

    Pandu_IsAvatarThumb = function(arg)
        if type(arg) ~= "string" then
            return false
        end
        local flag4 = arg:find("rbxthumb://", 1, true) ~= nil

        if flag4 then
            local pos = arg:find("AvatarHeadShot", 1, true)
            flag4 = pos or arg:find("AvatarBust", 1, true) or arg:find("type=Avatar", 1, true)
        end

        return flag4
    end

    Pandu_IsOurCurrentThumb = function(arg)
        if not arg:IsA("ImageLabel") and not arg:IsA("ImageButton") then
            return false
        end

        if arg:GetAttribute("PanduFakeThumb") == true then
            return true
        end
        local v31 = Pandu_ExtractThumbUserId(arg.Image)
        if not v31 or not Pandu_IsAvatarThumb(arg.Image) then
            return false
        end
        local flag4 = v31 == Pandu_ORIGINAL_ID
        return flag4
    end

    Pandu_ForceSetThumb = function(arg, arg2)
        if not arg or not arg2 then
            return
        end

        if not arg:IsA("ImageLabel") and not arg:IsA("ImageButton") then
            return
        end

        if not Pandu_IsOurCurrentThumb(arg) then
            return
        end

        if not arg:GetAttribute("PanduOrigThumb") then
            arg:SetAttribute("PanduOrigThumb", arg.Image)
        end

        local match, v31 = tostring(arg.Image):match("w=(%d+).*h=(%d+)")
        local v32 = Pandu_ThumbUrl
        local num = tonumber(match)
        local n2 = num or 150
        local num2 = tonumber(v31)
        local n3 = num2 or 150
        local v33 = v32(arg2, n2, n3)
        arg:SetAttribute("PanduFakeThumb", true)
        arg:SetAttribute("PanduFakeThumbId", tonumber(arg2))

        if arg.Image ~= v33 then
            arg.Image = v33
        end

        if Pandu_ThumbPropConns[arg] then
            return
        end

        Pandu_ThumbPropConns[arg] = arg:GetPropertyChangedSignal("Image"):Connect(function()
            if Pandu_FakeThumbUserId and arg.Parent then
                local v34 = Pandu_ExtractThumbUserId(arg.Image)

                if v34 and v34 ~= Pandu_ORIGINAL_ID and v34 ~= Pandu_FakeThumbUserId then
                    arg:SetAttribute("PanduFakeThumb", nil)
                    arg:SetAttribute("PanduFakeThumbId", nil)
                    arg:SetAttribute("PanduOrigThumb", nil)

                    if Pandu_ThumbPropConns[arg] then
                        Pandu_ThumbPropConns[arg]:Disconnect()
                        Pandu_ThumbPropConns[arg] = nil
                    end

                    return
                end

                local match2, v35 = tostring(arg.Image):match("w=(%d+).*h=(%d+)")
                local v36 = Pandu_ThumbUrl
                local v37 = Pandu_FakeThumbUserId
                local num3 = tonumber(match2)
                local n4 = num3 or 150
                local num4 = tonumber(v35)
                local n5 = num4 or 150
                local v38 = v36(v37, n4, n5)

                if arg.Image ~= v38 then
                    arg.Image = v38
                end

                return
            end

            if Pandu_ThumbPropConns[arg] then
                Pandu_ThumbPropConns[arg]:Disconnect()
                Pandu_ThumbPropConns[arg] = nil
            end
        end)
    end

    Pandu_RestoreThumb = function(arg)
        if not arg then
            return
        end

        if not arg:IsA("ImageLabel") and not arg:IsA("ImageButton") then
            return
        end

        if arg:GetAttribute("PanduFakeThumb") ~= true then
            return
        end
        local attribute = arg:GetAttribute("PanduOrigThumb")
        local image = type(attribute) == "string" and attribute ~= "" and attribute or Pandu_ThumbUrl(Pandu_ORIGINAL_ID)
        arg.Image = image
        arg:SetAttribute("PanduFakeThumb", nil)
        arg:SetAttribute("PanduFakeThumbId", nil)
        arg:SetAttribute("PanduOrigThumb", nil)

        if Pandu_ThumbPropConns[arg] then
            Pandu_ThumbPropConns[arg]:Disconnect()
            Pandu_ThumbPropConns[arg] = nil
        end
    end

    Pandu_SweepSetThumb = function(arg)
        local tbl8 = {CoreGui, localPlayer:FindFirstChild("PlayerGui")}
        local v31, v32, v33 = ipairs(tbl8)
        local v34 = v33
        local v35 = v31
        local v36 = v32

        while true do
            local v37, v38 = v35(v36, v34)
            if v37 == nil then
                break
            end
            v34 = v37

            if v38 then
                for i, descendant in ipairs(v38:GetDescendants()) do
                    if Pandu_IsOurCurrentThumb(descendant) then
                        pcall(Pandu_ForceSetThumb, descendant, arg)
                    end
                end

                v34 = v37
            end
        end
    end

    Pandu_SweepRestoreThumb = function()
        local tbl8 = {CoreGui, localPlayer:FindFirstChild("PlayerGui")}
        local v31, v32, v33 = ipairs(tbl8)
        local v34 = v33
        local v35 = v31
        local v36 = v32

        while true do
            local v37, v38 = v35(v36, v34)
            if v37 == nil then
                break
            end
            v34 = v37

            if v38 then
                for i, descendant in ipairs(v38:GetDescendants()) do
                    pcall(Pandu_RestoreThumb, descendant)
                end

                v34 = v37
            end
        end
    end

    Pandu_SetFakeDisplayPicture = function(arg)
        local num = tonumber(arg)
        if not num then
            return
        end
        Pandu_FakeThumbUserId = num
        Pandu_SweepSetThumb(num)

        task.delay(0.4, function()
            if Pandu_FakeThumbUserId == num then
                Pandu_SweepSetThumb(num)
            end
        end)

        task.delay(1.2, function()
            if Pandu_FakeThumbUserId == num then
                Pandu_SweepSetThumb(num)
            end
        end)

        if Pandu_ThumbConn then
            Pandu_ThumbConn:Disconnect()
            Pandu_ThumbConn = nil
        end

        local connection2 = CoreGui.DescendantAdded:Connect(function(descendant)
            if not Pandu_FakeThumbUserId then
                return
            end

            task.defer(function()
                if Pandu_IsOurCurrentThumb(descendant) then
                    pcall(Pandu_ForceSetThumb, descendant, Pandu_FakeThumbUserId)
                end
            end)
        end)

        Pandu_ThumbConn = connection2
    end

    Pandu_ClearFakeDisplayPicture = function()
        Pandu_SweepRestoreThumb()
        task.delay(0.3, Pandu_SweepRestoreThumb)
        Pandu_FakeThumbUserId = nil

        if Pandu_ThumbConn then
            Pandu_ThumbConn:Disconnect()
            Pandu_ThumbConn = nil
        end

        for k, v31 in pairs(Pandu_ThumbPropConns) do
            pcall(function()
                v31:Disconnect()
            end)

            Pandu_ThumbPropConns[k] = nil
        end
    end

    Pandu_FakeDisplayName = nil
    Pandu_OriginalDisplayName = localPlayer.DisplayName
    Pandu_NameCharConn = nil

    Pandu_SetCharacterDisplayName = function(displayName)
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid and displayName then
            humanoid.DisplayName = displayName
        end
    end

    Pandu_LooksLikeOurName = function(arg)
        if type(arg) ~= "string" or arg == "" then
            return false
        end
        local flag4 = arg == localPlayer.Name or arg == localPlayer.DisplayName or arg == Pandu_OriginalDisplayName
        return flag4
    end

    Pandu_ApplyNameToLabel = function(arg, text)
        if not arg or not text then
            return
        end

        if not arg:IsA("TextLabel") and not arg:IsA("TextButton") then
            return
        end

        if arg:GetAttribute("PanduFakeName") == true or Pandu_LooksLikeOurName(arg.Text) then
            if not arg:GetAttribute("PanduOrigName") then
                arg:SetAttribute("PanduOrigName", arg.Text)
            end

            arg:SetAttribute("PanduFakeName", true)
            arg.Text = text
        end
    end

    Pandu_RestoreNameLabel = function(arg)
        if not arg then
            return
        end

        if not arg:IsA("TextLabel") and not arg:IsA("TextButton") then
            return
        end

        if arg:GetAttribute("PanduFakeName") ~= true then
            return
        end
        local attribute = arg:GetAttribute("PanduOrigName")

        if type(attribute) == "string" and attribute ~= "" then
            arg.Text = attribute
        else
            arg.Text = Pandu_OriginalDisplayName
        end

        arg:SetAttribute("PanduFakeName", nil)
        arg:SetAttribute("PanduOrigName", nil)
    end

    Pandu_SweepNames = function(arg)
        if not arg then
            return
        end
        local tbl8 = {CoreGui, localPlayer:FindFirstChild("PlayerGui")}
        local v31, v32, v33 = ipairs(tbl8)
        local v34 = v33
        local v35 = v31
        local v36 = v32

        while true do
            local v37, v38 = v35(v36, v34)
            if v37 == nil then
                break
            end
            v34 = v37

            if v38 then
                for i, descendant in ipairs(v38:GetDescendants()) do
                    pcall(Pandu_ApplyNameToLabel, descendant, arg)
                end

                v34 = v37
            end
        end
    end

    Pandu_SweepRestoreNames = function()
        local tbl8 = {CoreGui, localPlayer:FindFirstChild("PlayerGui")}
        local v31, v32, v33 = ipairs(tbl8)
        local v34 = v33
        local v35 = v31
        local v36 = v32

        while true do
            local v37, v38 = v35(v36, v34)
            if v37 == nil then
                break
            end
            v34 = v37

            if v38 then
                for i, descendant in ipairs(v38:GetDescendants()) do
                    pcall(Pandu_RestoreNameLabel, descendant)
                end

                v34 = v37
            end
        end
    end

    Pandu_SetFakeDisplayName = function(arg)
        if not arg or arg == "" then
            return
        end
        Pandu_FakeDisplayName = arg
        Pandu_SetCharacterDisplayName(arg)
        Pandu_SweepNames(arg)

        task.delay(0.3, function()
            if Pandu_FakeDisplayName == arg then
                Pandu_SetCharacterDisplayName(arg)
                Pandu_SweepNames(arg)
            end
        end)

        task.delay(1, function()
            if Pandu_FakeDisplayName == arg then
                Pandu_SetCharacterDisplayName(arg)
                Pandu_SweepNames(arg)
            end
        end)

        if Pandu_NameCharConn then
            Pandu_NameCharConn:Disconnect()
            Pandu_NameCharConn = nil
        end

        local connection2 = localPlayer.CharacterAdded:Connect(function(character)
            task.wait(0.5)

            if Pandu_FakeDisplayName then
                local humanoid = character:WaitForChild("Humanoid", 5)

                if humanoid then
                    humanoid.DisplayName = Pandu_FakeDisplayName
                end
            end
        end)

        Pandu_NameCharConn = connection2
    end

    Pandu_ClearFakeDisplayName = function()
        Pandu_FakeDisplayName = nil
        Pandu_SetCharacterDisplayName(Pandu_OriginalDisplayName)
        Pandu_SweepRestoreNames()
        task.delay(0.3, Pandu_SweepRestoreNames)

        if Pandu_NameCharConn then
            Pandu_NameCharConn:Disconnect()
            Pandu_NameCharConn = nil
        end
    end

    Pandu_LoadAssetKeKarakter = function(arg, parent, parent2)
        local tbl8 = {}
        local v31 = nil
        local v32 = nil
        local v33 = nil
        local v34 = nil
        local tbl9 = {};

        (function(arg2)
            for k, child in pairs(arg2:GetChildren()) do
                if child:IsA("CharacterMesh") then
                    table.insert(tbl8, child)
                elseif child:IsA("BodyColors") then
                    v31 = child
                elseif child:IsA("Shirt") then
                    v32 = child
                elseif child:IsA("Pants") then
                    v33 = child
                elseif child:IsA("ShirtGraphic") then
                    v34 = child
                elseif child:IsA("Accessory") then
                    table.insert(tbl9, child)
                elseif child:IsA("SpecialMesh") then
                    table.insert(tbl8, child)
                elseif child:IsA("Decal") and child.Name == "face" then
                    table.insert(tbl8, child)
                elseif child:IsA("Folder") or child:IsA("Model") then
                    (nil)(child)
                end
            end
        end)(arg)

        if v31 then
            local bodyColors = parent:FindFirstChildOfClass("BodyColors")
            local bodyColors2 = bodyColors or parent:FindFirstChild("Body Colors")

            if bodyColors2 then
                bodyColors2:Destroy()
            end

            v31:Clone().Parent = parent
        end

        if v32 then
            local shirt = parent:FindFirstChildOfClass("Shirt")

            if shirt then
                shirt:Destroy()
            end

            v32:Clone().Parent = parent
        end

        if v33 then
            local pants = parent:FindFirstChildOfClass("Pants")

            if pants then
                pants:Destroy()
            end

            v33:Clone().Parent = parent
        end

        if v34 then
            local shirtGraphic = parent:FindFirstChildOfClass("ShirtGraphic")

            if shirtGraphic then
                shirtGraphic:Destroy()
            end

            v34:Clone().Parent = parent
        end

        for k, v35 in pairs(tbl8) do
            if v35:IsA("CharacterMesh") then
                pcall(function()
                    v35:Clone().Parent = parent
                end)
            end
        end

        if parent2 then
            for k, v35 in pairs(tbl8) do
                if v35:IsA("SpecialMesh") then
                    pcall(function()
                        local specialMesh = parent2:FindFirstChildOfClass("SpecialMesh")

                        if specialMesh then
                            specialMesh:Destroy()
                        end

                        v35:Clone().Parent = parent2
                    end)
                elseif v35:IsA("Decal") and v35.Name == "face" then
                    pcall(function()
                        local face = parent2:FindFirstChild("face")

                        if face then
                            face:Destroy()
                        end

                        v35:Clone().Parent = parent2
                    end)
                end
            end
        end

        if #tbl9 > 0 then
            task.spawn(function()
                for k, v35 in pairs(tbl9) do
                    pcall(function()
                        local clone = v35:Clone()
                        local handle = clone:FindFirstChild("Handle")

                        if handle then
                            handle.CanCollide = false
                            handle.Massless = true
                            local attachment = handle:FindFirstChildOfClass("Attachment")

                            if attachment then
                                local v36 = parent:FindFirstChild(attachment.Name, true)

                                if v36 and v36.Parent then
                                    local weld = Instance.new("Weld")
                                    weld.Part0 = handle
                                    weld.Part1 = v36.Parent
                                    weld.C0 = attachment.CFrame
                                    weld.C1 = v36.CFrame
                                    weld.Parent = handle
                                end
                            end

                            clone.Parent = parent
                        else
                            clone.Parent = parent
                        end
                    end)
                end
            end)
        end
    end

    Pandu_ApplyFakeAvaAppearance = function(arg)
        local character = localPlayer.Character
        if not character or not arg then
            return false
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return false
        end

        local ok, result = pcall(function()
            return Players:GetCharacterAppearanceAsync(arg)
        end)

        if ok and result then
            for k, child in pairs(character:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("BodyColors") or child:IsA("CharacterMesh") or child.Name == "Body Colors" then
                    child:Destroy()
                end
            end

            local head = character:FindFirstChild("Head")

            if head then
                local specialMesh = head:FindFirstChildOfClass("SpecialMesh")

                if specialMesh then
                    specialMesh:Destroy()
                end

                local face = head:FindFirstChild("face")

                if face then
                    face:Destroy()
                end
            end

            local v31 = nil

            local ok2, result2 = pcall(function()
                return Players:GetCharacterAppearanceInfoAsync(arg)
            end)

            if ok2 and result2 then
                v31 = result2
            end

            if v31 and v31.scales then
                for k, scale in pairs(v31.scales) do
                    local v32 = humanoid:FindFirstChild(k)
                    local v33 = v32

                    if not v32 then
                        local numberValue = Instance.new("NumberValue")
                        v33 = numberValue
                        numberValue.Name = k
                        numberValue.Parent = humanoid
                    end

                    v33.Value = scale
                end
            end

            task.wait(0.2)
            Pandu_LoadAssetKeKarakter(result, character, head)

            if v31 and v31.assets and head then
                task.spawn(function()
                    for k, asset in pairs(v31.assets) do
                        if asset.assetType and asset.assetType.name == "Face" then
                            local face = head:FindFirstChild("face")

                            if face then
                                face:Destroy()
                            end

                            pcall(function()
                                local decal = Instance.new("Decal")
                                decal.Name = "face"
                                decal.Texture = "rbxassetid://" .. asset.id
                                decal.Face = Enum.NormalId.Front
                                decal.Parent = head
                            end)

                            break
                        end
                    end
                end)
            end

            pcall(function()
                result:Destroy()
            end)

            return true
        end

        lib:Notify({
            Title = "Error",
            Description = "Gagal load appearance",
            Duration = 3,
        })

        return false
    end

    Pandu_ResolveUser = function(arg)
        local str = tostring(arg):gsub("%s+", ""):gsub("^@", "")
        local num = tonumber(str)

        if num then
            local ok, result = pcall(function()
                return Players:GetNameFromUserIdAsync(num)
            end)

            if ok and result then
                return num, result
            end
        else
            local ok, result = pcall(function()
                return Players:GetUserIdFromNameAsync(str)
            end)

            if ok and result then
                local ok2, result2 = pcall(function()
                    return Players:GetNameFromUserIdAsync(result)
                end)

                if ok2 and result2 then
                    return result, result2
                end
            end
        end

        return nil, nil
    end

    Pandu_ApplyAvatar = function(arg)
        if Pandu_Applying then
            return
        end
        Pandu_Applying = true

        task.spawn(function()
            local v31, v32 = Pandu_ResolveUser(arg)

            if not v31 then
                lib:Notify({
                    Title = "Error",
                    Description = "User tidak ditemukan",
                    Duration = 3,
                })

                Pandu_Applying = false
                return
            end

            Pandu_CURRENT_AVATAR = {id = v31, name = v32}

            if Pandu_RespawnConnection then
                Pandu_RespawnConnection:Disconnect()
                Pandu_RespawnConnection = nil
            end

            local flag4 = false

            if localPlayer.Character then
                flag4 = Pandu_ApplyFakeAvaAppearance(v31)
            end

            Pandu_SetFakeDisplayPicture(v31)
            Pandu_SetFakeDisplayName(v32)

            local connection2 = localPlayer.CharacterAdded:Connect(function()
                task.wait(1)

                if Pandu_CURRENT_AVATAR then
                    Pandu_ApplyFakeAvaAppearance(Pandu_CURRENT_AVATAR.id)
                    Pandu_SetFakeDisplayPicture(Pandu_CURRENT_AVATAR.id)
                    Pandu_SetFakeDisplayName(Pandu_CURRENT_AVATAR.name)
                end
            end)

            Pandu_RespawnConnection = connection2
            local notify = lib.Notify
            local tbl8 = {Title = "Copy Avatar"}
            local description = flag4 and "Berhasil copy " .. v32 or "Gagal apply " .. v32
            tbl8.Description = description
            tbl8.Duration = 3
            notify(lib, tbl8)
            Pandu_Applying = false
        end)
    end

    Pandu_LoadFavorites = function()
        Pandu_FAVORITES = {}

        pcall(function()
            if not isfolder("PanduCopyAvatar") then
                makefolder("PanduCopyAvatar")
            end

            if isfile("PanduCopyAvatar/favorites.json") then
                local data = HttpService:JSONDecode(readfile("PanduCopyAvatar/favorites.json"))
                Pandu_FAVORITES = data
            end
        end)
    end

    Pandu_SaveFavorites = function()
        pcall(function()
            if not isfolder("PanduCopyAvatar") then
                makefolder("PanduCopyAvatar")
            end

            writefile("PanduCopyAvatar/favorites.json", HttpService:JSONEncode(Pandu_FAVORITES))
        end)
    end

    Pandu_LoadFavorites()

    Pandu_ResetAvatar = function()
        Pandu_CURRENT_AVATAR = nil

        if Pandu_RespawnConnection then
            Pandu_RespawnConnection:Disconnect()
            Pandu_RespawnConnection = nil
        end

        Pandu_ClearFakeDisplayPicture()
        Pandu_ClearFakeDisplayName()

        task.spawn(function()
            local v31 = Pandu_ApplyFakeAvaAppearance(Pandu_ORIGINAL_ID)
            local notify = lib.Notify
            local tbl8 = {Title = "Reset Avatar"}
            local description = v31 and "Avatar direset" or "Gagal reset"
            tbl8.Description = description
            tbl8.Duration = 3
            notify(lib, tbl8)
        end)
    end

    Pandu_AvatarList = {
        "Self Avatar",
        "Random 1",
        "Random 2",
        "Random 3",
        "Random 4",
        "Random 5",
        "Random 6",
        "Random 7",
        "WoozyNate",
        "Nicholas",
        "yvlyf",
        "traevp",
        "J0LLY",
        "LucashDev",
        "CEOofIsaac",
        "Stealthy",
        "Wildes",
        "Talon",
        "Relukt",
        "Sammy",
        "Diesel",
        "S4ans03",
        "Aura",
        "iJava",
        "White Guy",
        "Purple King",
        "Mpruyyy",
    }

    Pandu_AvatarIDs = {
        ["Self Avatar"] = localPlayer.UserId,
        ["Random 1"] = 2888298851,
        ["Random 2"] = 10074747755,
        ["Random 3"] = 5209567453,
        ["Random 4"] = 8991982843,
        ["Random 5"] = 5796319029,
        ["Random 6"] = 9744452117,
        ["Random 7"] = 8476755006,
        WoozyNate = 146089324,
        Nicholas = 909635,
        yvlyf = 181751703,
        traevp = 471607078,
        J0LLY = 1073847038,
        LucashDev = 2525651744,
        CEOofIsaac = 63238912,
        Stealthy = 56602747,
        Wildes = 40397833,
        Talon = 75974130,
        Relukt = 65042011,
        Sammy = 2678001507,
        Diesel = 9123921576,
        S4ans03 = 35439794,
        Aura = 2275806428,
        iJava = 276557820,
        ["White Guy"] = 8843268357,
        ["Purple King"] = 9070758608,
        Mpruyyy = 8340163775,
    }

    Pandu_GetFavoritesList = function()
        local tbl8 = {}

        for i, v31 in ipairs(Pandu_FAVORITES) do
            table.insert(tbl8, v31.name)
        end

        return tbl8
    end

    Pandu_SelectedAvatarOption = "Self Avatar"

    FakeAvatarSection:AddDropdown("Pilih Avatar", Pandu_AvatarList, false, function(arg)
        Pandu_SelectedAvatarOption = arg
    end)

    Pandu_UsernameInput = ""

    FakeAvatarSection:AddTextbox("Username / ID", "Masukkan username atau ID...", function(arg)
        local str = arg:gsub("^@", "")
        Pandu_UsernameInput = str
    end)

    FakeAvatarSection:AddButton("Apply Avatar", function()
        if Pandu_UsernameInput == "" then
            if Pandu_SelectedAvatarOption and Pandu_SelectedAvatarOption ~= "" then
                local v31 = Pandu_AvatarIDs[Pandu_SelectedAvatarOption]

                if v31 then
                    Pandu_ApplyAvatar(v31)
                else
                    lib:Notify({
                        Title = "Error",
                        Description = "Pilih avatar atau masukkan username!",
                        Duration = 3,
                    })
                end
            else
                lib:Notify({
                    Title = "Error",
                    Description = "Pilih avatar atau masukkan username!",
                    Duration = 3,
                })
            end
        else
            Pandu_ApplyAvatar(Pandu_UsernameInput)
        end
    end)

    FakeAvatarSection:AddButton("Random Avatar", function()
        Pandu_ApplyAvatar(Pandu_RANDOM_IDS[math.random(1, #Pandu_RANDOM_IDS)])
    end)

    FakeAvatarSection:AddButton("Reset Avatar", function()
        Pandu_ResetAvatar()
    end)

    FakeAvatarSection:AddButton("Add to Favorite", function()
        if not Pandu_CURRENT_AVATAR then
            lib:Notify({
                Title = "Error",
                Description = "Tidak ada avatar",
                Duration = 3,
            })

            return
        end

        for i, v31 in ipairs(Pandu_FAVORITES) do
            if tonumber(v31.id) == tonumber(Pandu_CURRENT_AVATAR.id) then
                lib:Notify({
                    Title = "Info",
                    Description = "Sudah ada di favorite",
                    Duration = 2,
                })

                return
            end
        end

        table.insert(Pandu_FAVORITES, {
            id = Pandu_CURRENT_AVATAR.id,
            name = Pandu_CURRENT_AVATAR.name,
        })

        Pandu_SaveFavorites()
        Pandu_FavDropdown.SetValues(Pandu_GetFavoritesList())

        lib:Notify({
            Title = "Favorite",
            Description = "Ditambahkan ke favorite",
            Duration = 2,
        })
    end)

    local Favorites = FakeAvatarSection:AddDropdown("Favorites", Pandu_GetFavoritesList(), false, function(arg)
        for i, v31 in ipairs(Pandu_FAVORITES) do
            if v31.name == arg then
                Pandu_SelectedFav = v31.id
                Pandu_ApplyAvatar(v31.id)
                break
            end
        end
    end)

    Pandu_FavDropdown = Favorites

    FakeAvatarSection:AddButton("Delete Favorite", function()
        if not Pandu_SelectedFav then
            lib:Notify({
                Title = "Error",
                Description = "Pilih favorite dulu",
                Duration = 3,
            })

            return
        end

        for i, v31 in ipairs(Pandu_FAVORITES) do
            if tonumber(v31.id) == tonumber(Pandu_SelectedFav) then
                table.remove(Pandu_FAVORITES, i)
                break
            end
        end

        Pandu_SaveFavorites()
        Pandu_FavDropdown.SetValues(Pandu_GetFavoritesList())
        Pandu_SelectedFav = nil

        lib:Notify({
            Title = "Favorite",
            Description = "Favorite dihapus",
            Duration = 2,
        })
    end)

    localPlayer.CharacterAdded:Connect(function(character)
        task.wait(1)

        if Pandu_CURRENT_AVATAR then
            Pandu_ApplyFakeAvaAppearance(Pandu_CURRENT_AVATAR.id)
            Pandu_SetFakeDisplayPicture(Pandu_CURRENT_AVATAR.id)
            Pandu_SetFakeDisplayName(Pandu_CURRENT_AVATAR.name)
        end
    end)

    local Survivor = v:CreateTab("Survivor", false, false)
    SurvivorTab = Survivor
    local Survivor2 = SurvivorTab:CreatePage("Survivor")
    S_Page = Survivor2
    local v31 = S_Page:CreateSection("Generator Settings", "plug-zap")
    GenCard = v31

    local v32 = GenCard:AddToggle("Auto Skill Check", false, function(skillCheck)
        _G.Ox.Auto.SkillCheck = skillCheck

        if skillCheck then
            fn7()
        elseif _G.Ox.Connections.SkillHeartbeat then
            _G.Ox.Connections.SkillHeartbeat:Disconnect()
            _G.Ox.Connections.SkillHeartbeat = nil
        end
    end, {Flag = "AutoSkillCheck"})

    SkillCheckToggle = v32
    SkillCheckToggle:AddKeyPicker("None")

    GenCard:AddDropdown("Skill Check Mode", {"Legit", "Instant", "Normal", "Random"}, false, function(skillCheckMode)
        _G.Ox.Auto.SkillCheckMode = skillCheckMode
        _G.Ox.State.RandomMode_IsNormal = false
    end, {Flag = "SkillCheckMode"})

    GenCard:AddDropdown("Gen Boost Mode", {"Manual Repair", "Auto Repair"}, false, function(bypassGenMode)
        _G.Ox.BypassGenMode = bypassGenMode
    end, {Flag = "GenBoostMode"})

    local v33 = GenCard:AddToggle("Gen Boost (Multi-Repair)", false, function(bypassToggleValue)
        _G.Ox.BypassToggleValue = bypassToggleValue
        _G.Ox.BypassGenEnabled = bypassToggleValue
        local bypassButton = _G.Ox.BypassButton
        local touchEnabled = bypassToggleValue and UserInputService.TouchEnabled

        if touchEnabled then
            if UserInputService.KeyboardEnabled then
                touchEnabled = false
            else
                touchEnabled = true
            end
        end

        bypassButton.Visible = touchEnabled

        if not bypassToggleValue then
            _G.Ox.ProcessedGens = {}
            _G.Ox.AutoRepairEnabled = false
            _G.Ox.AutoCurrentGenModel = nil

            if _G.Ox.AutoRepairThread then
                task.cancel(_G.Ox.AutoRepairThread)
                _G.Ox.AutoRepairThread = nil
            end

            _G.Ox.StopAutoRepair()
        end
    end)

    GenBoostToggle = v33
    local fire = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Items")["Twist of Fate"].Fire
    local flag4 = false
    local flag5 = false
    local flag6 = true
    local flag7 = false
    local flag8 = false
    local connection2 = nil
    local part = nil
    local str = "Killer"
    UDim2.new(0.5, -120, 0, 110)
    local tbl8 = {}

    local tbl9 = {
        PredictionEfficiency = 0.85,
        LerpSmoothness = 0.4,
        EnableJitter = false,
        MaxJitterStuds = 0,
    }

    getGunObject = function()
        local character = localPlayer.Character
        if not character then
            return nil
        end
        local twistOfFate = character:FindFirstChild("Twist of Fate", true)
        if not twistOfFate then
            return nil
        end
        local rightArm = twistOfFate:FindFirstChild("Right Arm")

        if rightArm then
            local gun = rightArm:FindFirstChild("gun")
            if gun then
                return gun
            end
            local emperorGun = rightArm:FindFirstChild("EmperorGun")
            if emperorGun then
                return emperorGun
            end
        end

        return twistOfFate
    end

    isTargetVisible = function(arg, arg2, arg3)
        local n2 = arg2 - arg
        local magnitude = n2.Magnitude
        if magnitude < 0.1 then
            return true
        end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local filterDescendantsInstances = {}
        local character = localPlayer.Character

        if character then
            table.insert(filterDescendantsInstances, character)
        end

        if arg3 and arg3 ~= character then
            table.insert(filterDescendantsInstances, arg3)
        end

        if part then
            table.insert(filterDescendantsInstances, part)
        end

        raycastParams.FilterDescendantsInstances = filterDescendantsInstances
        local flag9 = workspace:Raycast(arg, n2.Unit * magnitude, raycastParams) == nil
        return flag9
    end

    local tbl10 = {}
    local n2 = 0

    GetSCPs = function()
        if tick() - n2 < 0.5 then
            return tbl10
        end
        local tbl11 = {}
        local map = workspace:FindFirstChild("Map")

        if map then
            for k, descendant in pairs(map:GetDescendants()) do
                if descendant:IsA("Model") then
                    local attributes = descendant:GetAttributes()

                    if descendant:GetAttribute("CorpseCreated0492") or next(attributes) ~= nil then
                        local humanoidRootPart = descendant:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart then
                            table.insert(tbl11, humanoidRootPart)
                        end
                    end
                end
            end
        end

        tbl10 = tbl11
        n2 = tick()
        return tbl10
    end

    local function fn71(arg)
        local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return Vector3.zero
        end
        local position = humanoidRootPart.Position
        local v34 = tbl8[arg]

        if v34 then
            local n3 = tick() - v34.time

            if n3 > 0.001 and n3 < 0.1 then
                local v35 = v34.vel:Lerp((position - v34.pos) / n3, tbl9.LerpSmoothness)
                local tbl11 = {pos = position, vel = v35, time = tick()}
                tbl8[arg] = tbl11
                return v35
            end
        end

        local tbl11 = {pos = position, vel = humanoidRootPart.Velocity, time = tick()}
        tbl8[arg] = tbl11
        return humanoidRootPart.Velocity
    end

    local function fn72(arg, arg2, arg3, arg4)
        local n3 = arg4 or 500
        local v34 = n3
        local position = arg2.Position
        if (position - arg).Magnitude < 8 then
            return position
        end
        local v35 = fn71(arg3)
        local n4 = position - arg
        local n5 = v35:Dot(v35) - v34 * v34
        local n6 = 2 * n4:Dot(v35)
        local v36 = n4:Dot(n4)
        local n7 = nil

        if math.abs(n5) < 0.01 then
            if math.abs(n6) > 0.01 then
                n7 = -v36 / n6
            end
        else
            local n8 = n6 * n6 - 4 * n5 * v36

            if n8 >= 0 then
                local v37 = math.sqrt(n8)
                local n9 = (-n6 - v37) / (2 * n5)
                local n10 = (-n6 + v37) / (2 * n5)

                if n9 > 0.001 then
                    n7 = n9
                elseif n10 > 0.001 then
                    n7 = n10
                end
            end
        end

        local n8 = position

        if n7 then
            local n9 = position + v35 * tbl9.PredictionEfficiency * n7
            n8 = n9

            if tbl9.EnableJitter then
                n8 = n9 + Vector3.new((math.random() - 0.5) * tbl9.MaxJitterStuds, (math.random() - 0.5) * (tbl9.MaxJitterStuds / 2), (math.random() - 0.5) * tbl9.MaxJitterStuds)
            end
        end

        return n8
    end

    getTargetPosition = function()
        local currentCamera2 = workspace.CurrentCamera
        local v34 = getGunObject()
        local character = localPlayer.Character
        if not v34 or not character then
            return nil, nil, nil, nil
        end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil, nil, nil, nil
        end
        local position = humanoidRootPart.Position
        local n3 = nil

        if character:GetAttribute("IsCarried") then
            n3 = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 2
        else
            pcall(function()
                local isBasePart = v34:IsA("BasePart")
                local position2 = isBasePart and v34.Position

                if not position2 then
                    local basePart = v34:FindFirstChildOfClass("BasePart")
                    position2 = basePart and v34:FindFirstChildOfClass("BasePart").Position
                end

                n3 = position2
            end)

            local vector = n3 or Vector3.new(position.X, position.Y + 1.5, position.Z)
            n3 = vector
        end

        local function fn73(arg, arg2)
            local position2 = arg.Position
            if flag7 and not isTargetVisible(n3, position2, arg2) then
                return nil, nil, nil, nil
            end
            local v35 = getGunObject()
            local position3 = n3

            pcall(function()
                if v35 and v35:IsA("BasePart") then
                    position3 = v35.Position
                elseif v35 then
                    local basePart = v35:FindFirstChildOfClass("BasePart")

                    if basePart then
                        position3 = basePart.Position
                    end
                end
            end)

            if (position2 - position3).Magnitude < 8 then
                return (position2 - position3).Unit, v35, position3, position2
            end

            if not flag5 then
                return (position2 - position3).Unit, v35, position3, position2
            end
            local v36 = fn72(position3, arg, arg2, 500)
            return (v36 - position3).Unit, v35, position3, v36
        end

        if str == "Killer" then
            local v35 = nil
            local character2 = nil
            local huge = math.huge

            for i, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer then
                    local team = player.Team
                    local flag9 = team and player.Team.Name == "Killer"

                    if flag9 and player.Character then
                        local torso = player.Character:FindFirstChild("Torso")

                        if torso then
                            local magnitude = (position - torso.Position).Magnitude

                            if magnitude < huge then
                                huge = magnitude
                                v35 = torso
                                character2 = player.Character
                            end
                        end
                    end
                end
            end

            if not v35 then
                return nil, nil, nil, nil
            end
            return fn73(v35, character2)
        end

        if str == "Survivors" then
            local v35 = nil
            local character2 = nil
            local n4 = -math.huge
            local currentCamera3 = workspace.CurrentCamera
            local lookVector = currentCamera3.CFrame.LookVector

            for i, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Team and player.Team.Name == "Survivors" and player.Character then
                    local torso = player.Character:FindFirstChild("Torso")

                    if torso then
                        local v36 = lookVector:Dot((torso.Position - currentCamera3.CFrame.Position).Unit)

                        if v36 > 0.5 and n4 < v36 then
                            n4 = v36
                            v35 = torso
                            character2 = player.Character
                        end
                    end
                end
            end

            if not v35 then
                return nil, nil, nil, nil
            end
            return fn73(v35, character2)
        end

        if str ~= "Zombie" then
            return nil, nil, nil, nil
        end
        local v35 = nil
        local v36 = GetSCPs()
        local n4 = -math.huge
        local currentCamera3 = workspace.CurrentCamera
        local lookVector = currentCamera3.CFrame.LookVector

        for i, v37 in ipairs(v36) do
            if v37 and v37.Parent then
                local v38 = lookVector:Dot((v37.Position - currentCamera3.CFrame.Position).Unit)

                if v38 > 0.5 and n4 < v38 then
                    n4 = v38
                    v35 = v37
                end
            end
        end

        if not v35 then
            return nil, nil, nil, nil
        end
        return fn73(v35, v35.Parent)
    end

    updateLaser = function(arg, arg2)
        if not part then
            part = Instance.new("Part")
            part.Name = "ToFLaser"
            part.Anchored = true
            part.CanCollide = false
            part.CanTouch = false
            part.CastShadow = false
            part.Material = Enum.Material.Neon
            local color = Color3.fromRGB(255, 50, 50)
            part.Color = color
            part.Parent = workspace
        end

        local vector = Vector3.new(0.05, 0.05, (arg2 - arg).Magnitude)
        part.Size = vector
        local cframe = CFrame.new((arg + arg2) / 2, arg2)
        part.CFrame = cframe
        part.Transparency = 0
    end

    clearLaser = function()
        if part then
            part:Destroy()
            part = nil
        end
    end

    local tbl11 = {}

    local function fn73()
        local attribute = localPlayer:GetAttribute("EquippedSkin_Twist_of_Fate")
        local str2 = attribute or ""
        if str2:find("AWP") or str2:find("Awp") or str2:find("awp") then
            return "rbxassetid://119691839016468"
        end

        if not str2:find("SCP") and not str2:find("3108") then
            return "rbxassetid://124735239320776"
        end
        return "rbxassetid://116394362601423"
    end

    local function fn74()
        for i, v34 in ipairs(tbl11) do
            v34:Disconnect()
        end

        tbl11 = {}
        local character = localPlayer.Character
        if not character then
            return
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            return
        end

        local function fn75()
            local attribute = character:GetAttribute("IsCarried")
            local attribute2 = attribute or character:GetAttribute("Knocked")
            return attribute2
        end

        local function fn76()
            local tbl12 = {}
            tbl12[fn73()] = true
            tbl12["rbxassetid://111824163160605"] = true
            tbl12["rbxassetid://72749744367268"] = true
            return tbl12
        end

        table.insert(tbl11, animator.AnimationPlayed:Connect(function(arg)
            if not fn75() then
                return
            end

            if not arg.Animation then
                return
            end

            if fn76()[arg.Animation.AnimationId] then
                arg:Stop(0)
            end
        end))

        table.insert(tbl11, character:GetAttributeChangedSignal("IsCarried"):Connect(function()
            if not fn75() then
                return
            end
            local v34 = fn76()

            for i, v35 in ipairs(animator:GetPlayingAnimationTracks()) do
                if v35.Animation and v34[v35.Animation.AnimationId] then
                    v35:Stop(0)
                end
            end
        end))

        table.insert(tbl11, character:GetAttributeChangedSignal("Knocked"):Connect(function()
            if not fn75() then
                return
            end
            local v34 = fn76()

            for i, v35 in ipairs(animator:GetPlayingAnimationTracks()) do
                if v35.Animation and v34[v35.Animation.AnimationId] then
                    v35:Stop(0)
                end
            end
        end))
    end

    task.defer(fn74)

    localPlayer.CharacterAdded:Connect(function()
        task.defer(function()
            task.wait(0.25)
            fn74()
        end)
    end)

    doShoot = function()
        if not flag4 or not flag8 then
            return
        end
        local character = localPlayer.Character
        if character and _G.Ox.AimConfig.Pistol_BlockKnocked and IsDowned(character) then
            return
        end
        local v34, v35, v36, v37 = getTargetPosition()
        if not v34 or not v35 or not v37 or not v36 then
            return
        end
        local unit = (v37 - v36).Unit

        pcall(function()
            fire:FireServer(v35, unit)
        end)
    end

    startConnection = function()
        if connection2 then
            return
        end

        connection2 = RunService.Heartbeat:Connect(function()
            if flag8 and flag4 then
                local v34, v35, v36, v37 = getTargetPosition()

                if v34 and v35 and v37 then
                    pcall(function()
                        local character = localPlayer.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

                        if humanoidRootPart and not character:GetAttribute("IsCarried") then
                            humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, Vector3.new(v37.X, humanoidRootPart.Position.Y, v37.Z))
                        end
                    end)

                    if _G.Ox.AimConfig.LockAim then
                        local cframe = CFrame.lookAt(currentCamera.CFrame.Position, v37)
                        currentCamera.CFrame = currentCamera.CFrame:Lerp(cframe, 0.15)
                    end

                    if flag6 and v36 and v37 then
                        updateLaser(v36, v37)
                    end
                elseif part then
                    part.Transparency = 1
                end
            elseif part then
                part.Transparency = 1
            end
        end)
    end

    stopConnection = function()
        if connection2 then
            connection2:Disconnect()
            connection2 = nil
        end

        clearLaser()
    end

    local udim2 = UDim2.new(0.5, -82, 0, 30)
    local v34 = nil
    local connection3 = nil

    local tbl12 = {
        {
            internal = "Killer",
            display = "Killer (K)",
            activeColor = Color3.fromRGB(180, 45, 45),
            activeTxt = Color3.fromRGB(255, 180, 180),
        },
        {
            internal = "Survivors",
            display = "Survivors (J)",
            activeColor = Color3.fromRGB(25, 80, 150),
            activeTxt = Color3.fromRGB(160, 210, 255),
        },
        {
            internal = "Zombie",
            display = "Zombie (L)",
            activeColor = Color3.fromRGB(120, 80, 10),
            activeTxt = Color3.fromRGB(255, 210, 100),
        },
    }

    createTargetSelectorUI = function()
        if not CoreGui then
            return
        end

        if v34 and v34.Parent then
            return
        end
        local toFTargetSelector = CoreGui:FindFirstChild("ToFTargetSelector")

        if toFTargetSelector then
            toFTargetSelector:Destroy()
        end

        local screenGui2 = Instance.new("ScreenGui")
        screenGui2.Name = "ToFTargetSelector"
        screenGui2.ResetOnSpawn = false
        screenGui2.IgnoreGuiInset = true
        screenGui2.Parent = CoreGui
        local frame2 = Instance.new("Frame")
        frame2.Name = "Main"
        frame2.Size = UDim2.new(0, 165, 0, 32)
        frame2.Position = udim2
        frame2.BackgroundTransparency = 1
        frame2.Active = true
        frame2.Parent = screenGui2
        local visible = false
        local textButton = Instance.new("TextButton")
        textButton.Size = UDim2.new(1, 0, 1, 0)
        textButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        textButton.BackgroundTransparency = 0.25
        textButton.BorderSizePixel = 0
        textButton.Font = Enum.Font.GothamBold
        textButton.TextSize = 11
        textButton.TextColor3 = Color3.fromRGB(240, 240, 240)
        textButton.Parent = frame2
        Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 8)
        local uiStroke3 = Instance.new("UIStroke", textButton)
        uiStroke3.Color = Color3.fromRGB(100, 100, 110)
        uiStroke3.Thickness = 1.2
        uiStroke3.Transparency = 0.3
        local frame3 = Instance.new("Frame")
        frame3.Size = UDim2.new(1, 0, 0, 0)
        frame3.Position = UDim2.new(0, 0, 1, 5)
        frame3.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        frame3.BackgroundTransparency = 0.25
        frame3.BorderSizePixel = 0
        frame3.ClipsDescendants = true
        frame3.Visible = false
        frame3.AutomaticSize = Enum.AutomaticSize.Y
        frame3.Parent = frame2
        Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 8)
        local uiStroke4 = Instance.new("UIStroke", frame3)
        uiStroke4.Color = Color3.fromRGB(80, 80, 90)
        uiStroke4.Thickness = 1.2
        uiStroke4.Transparency = 0.4
        local uiListLayout = Instance.new("UIListLayout", frame3)
        uiListLayout.FillDirection = Enum.FillDirection.Vertical
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Padding = UDim.new(0, 4)
        local uiPadding = Instance.new("UIPadding", frame3)
        uiPadding.PaddingTop = UDim.new(0, 4)
        uiPadding.PaddingBottom = UDim.new(0, 4)
        uiPadding.PaddingLeft = UDim.new(0, 4)
        uiPadding.PaddingRight = UDim.new(0, 4)
        local tbl13 = {}

        local function fn75()
            local str2 = "Unknown"

            for i, v35 in ipairs(tbl12) do
                if v35.internal == str then
                    str2 = v35.internal
                    break
                end
            end

            local v35 = visible
            local str3 = v35 and "v" or ">"
            textButton.Text = string.format("Target: %s   %s", str2, str3)
            frame3.Visible = visible

            for i, v36 in ipairs(tbl12) do
                local v37 = tbl13[v36.internal]

                if v37 then
                    if v36.internal == str then
                        v37.BackgroundColor3 = v36.activeColor
                        v37.TextColor3 = v36.activeTxt
                    else
                        v37.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
                        v37.TextColor3 = Color3.fromRGB(150, 150, 150)
                    end
                end
            end
        end

        for i, v35 in ipairs(tbl12) do
            local textButton2 = Instance.new("TextButton")
            textButton2.Size = UDim2.new(1, 0, 0, 26)
            textButton2.BorderSizePixel = 0
            textButton2.Font = Enum.Font.GothamBold
            textButton2.TextSize = 10
            textButton2.Text = v35.display
            textButton2.LayoutOrder = i
            textButton2.Parent = frame3
            Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 6)

            local function fn76()
                str = v35.internal
                visible = false
                fn75()
            end

            textButton2.MouseButton1Click:Connect(fn76)

            textButton2.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    fn76()
                end
            end)

            tbl13[v35.internal] = textButton2
        end

        fn75()
        local flag9 = false
        local flag10 = false
        local v35 = nil
        local position = nil
        local position2 = nil

        textButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                flag9 = true
                flag10 = false
                v35 = input
                position = input.Position
                position2 = frame2.Position
            end
        end)

        textButton.InputEnded:Connect(function(input)
            if input == v35 then
                flag9 = false

                if not flag10 then
                    local flag11

                    if visible then
                        flag11 = false
                    else
                        flag11 = true
                    end

                    visible = flag11
                    fn75()
                end

                v35 = nil
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if not flag9 then
                return
            end
            local flag11 = false

            if input.UserInputType == Enum.UserInputType.Touch and input == v35 then
                flag11 = true
            elseif input.UserInputType == Enum.UserInputType.MouseMovement and v35.UserInputType == Enum.UserInputType.MouseButton1 then
                flag11 = true
            end

            if flag11 then
                local n3 = input.Position - position

                if math.abs(n3.X) > 4 or math.abs(n3.Y) > 4 then
                    flag10 = true
                end

                if flag10 then
                    local udim22 = UDim2.new(position2.X.Scale, position2.X.Offset + n3.X, position2.Y.Scale, position2.Y.Offset + n3.Y)
                    frame2.Position = udim22
                    udim2 = udim22
                end
            end
        end)

        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        connection3 = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not flag4 then
                return
            end

            if gameProcessed or input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end
            local str2 = nil

            if input.KeyCode == Enum.KeyCode.K then
                str2 = "Killer"
                lib:Notify({Title = "Target Mode", Description = "Killer", Time = 1})
            elseif input.KeyCode == Enum.KeyCode.J then
                str2 = "Survivors"
                lib:Notify({Title = "Target Mode", Description = "Survivors", Time = 1})
            elseif input.KeyCode == Enum.KeyCode.L then
                str2 = "Zombie"
                lib:Notify({Title = "Target Mode", Description = "Zombie", Time = 1})
            end

            if str2 and str2 ~= str then
                str = str2
                fn75()
            end
        end)

        v34 = screenGui2
    end

    destroyTargetSelectorUI = function()
        if connection3 then
            connection3:Disconnect()
            connection3 = nil
        end

        if v34 then
            v34:Destroy()
            v34 = nil
        end
    end

    local v35 = S_Page:CreateSection("Silent Aim (Pistol)", "crosshair")
    PistolSection = v35

    local v36 = PistolSection:AddToggle("Silent Aim Twist Of Fate", false, function(arg)
        flag4 = arg

        if arg then
            createTargetSelectorUI()
            startConnection()
        else
            destroyTargetSelectorUI()
            stopConnection()
        end
    end)

    SilentAimToggle = v36

    local v37 = PistolSection:AddToggle("Predict Aim ToF", false, function(arg)
        flag5 = arg
        local notify = lib.Notify
        local tbl13 = {Title = "Predict Aim"}
        local description = arg and "Enabled" or "Disabled"
        tbl13.Description = description
        tbl13.Duration = 2
        notify(lib, tbl13)
    end, {Flag = "Pistol_Predict"})

    PredictToggle = v37

    local v38 = PistolSection:AddCheckbox("Block aim Knocked", false, function(pistolBlockKnocked)
        _G.Ox.AimConfig.Pistol_BlockKnocked = pistolBlockKnocked
    end, {Flag = "Pistol_BlockKnocked"})

    BlockKnockedToggle = v38

    local v39 = PistolSection:AddToggle("Block Peluru (TOF)", false, function(enabled)
        _G.Ox.BulletBlockConfig.Enabled = enabled
        local notify = lib.Notify
        local tbl13 = {Title = "Block Peluru"}
        local description = enabled and "AKTIF - Peluru tidak keluar" or "NONAKTIF"
        tbl13.Description = description
        tbl13.Duration = 3
        notify(lib, tbl13)
    end, {Flag = "Pistol_BlockPeluru"})

    BulletBlockToggle = v39

    local v40 = PistolSection:AddToggle("Lock Aim (Twist Of Fate)", false, function(lockAim)
        _G.Ox.AimConfig.LockAim = lockAim
    end, {Flag = "Pistol_LockAim"})

    LockAimToggle = v40

    local Wallcheck = PistolSection:AddToggle("Wallcheck", false, function(arg)
        flag7 = arg
    end, {Flag = "Pistol_Wallcheck"})

    WallCheckToggle = Wallcheck

    local v41 = PistolSection:AddToggle("Enable Laser Effect", true, function(arg)
        flag6 = arg

        if not arg then
            clearLaser()
        end
    end, {Flag = "Pistol_Laser"})

    LaserToggle = v41

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        local flag9 = input.UserInputType == Enum.UserInputType.Touch
        if gameProcessed and not flag9 then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            flag8 = true

            if _G.Ox.AimConfig.Flash_Silent then
                flag = true
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            doShoot()
        end
    end)

    PistolSection:AddToggle("Silent Aim Flashlight", false, function(flashSilent)
        _G.Ox.AimConfig.Flash_Silent = flashSilent
        local notify = lib.Notify
        local tbl13 = {Title = "Flash Silent Aim"}
        local description = flashSilent and "AKTIF" or "NONAKTIF"
        tbl13.Description = description
        tbl13.Duration = 2
        notify(lib, tbl13)
    end)

    PistolSection:AddSlider("FlashHeadOffset", 0, 15, 1.5, function(flashYOffset)
        _G.Ox.AimConfig.Flash_YOffset = flashYOffset
    end, {Increment = 0.1, Flag = "Flash_YOffset"})

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            flag8 = false
            flag = false

            if part then
                part.Transparency = 1
            end
        end
    end)

    local connection4 = nil

    hookMobileButtons = function(arg)
        task.wait(0.5)
        local controls = arg:WaitForChild("Controls", 10)
        if not controls then
            return
        end
        local guiMob = controls:WaitForChild("Gui-mob", 5)
        if not guiMob then
            return
        end

        guiMob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                flag8 = true

                if _G.Ox.AimConfig.Flash_Silent then
                    flag = true
                end
            end
        end)

        guiMob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                doShoot()
                flag8 = false
                flag = false

                if part then
                    part.Transparency = 1
                end
            end
        end)
    end

    setupMobileButton = function()
        local playerGui2 = localPlayer:WaitForChild("PlayerGui", 10)
        if not playerGui2 then
            return
        end
        local survivorMob = playerGui2:FindFirstChild("Survivor-mob")

        if survivorMob then
            task.spawn(hookMobileButtons, survivorMob)
        end

        if connection4 then
            connection4:Disconnect()
            connection4 = nil
        end

        connection4 = playerGui2.ChildAdded:Connect(function(child)
            if child.Name == "Survivor-mob" then
                task.spawn(hookMobileButtons, child)
            end
        end)
    end

    setupMobileButton()

    localPlayer.CharacterAdded:Connect(function(character)
        clearLaser()
        tbl8 = {}
        tbl10 = {}
        n2 = 0
        flag8 = false
        character:WaitForChild("HumanoidRootPart", 5)
        setupMobileButton()

        if flag4 then
            stopConnection()
            task.wait(0.2)
            startConnection()
            createTargetSelectorUI()
        end
    end)

    playerGui.ChildRemoved:Connect(function(child)
        if not flag4 then
            return
        end
        task.wait(0.5)
        if not flag4 then
            return
        end

        if child.Name == "ToFTargetSelector" then
            createTargetSelectorUI()
        end
    end)

    local v42 = S_Page:CreateSection("Anti Hook", "shield")
    AntiHookCard = v42

    local v43 = AntiHookCard:AddToggle("Anti Hook", false, function(arg)
        ToggleAntiHook(arg)
    end)

    AntiHookToggle = v43

    AntiHookCard:AddSlider("Offset", 50, 1000, 250, function(arg)
        _G.Ox.AntiHook.OffsetY = -arg
    end, {Increment = 50, Flag = "AntiHookOffsetY"})

    AntiHookCard:AddSlider("Send HZ", 1, 60, 44, function(hz)
        _G.Ox.AntiHook.Hz = hz
        _G.Ox.AntiHook.Interval = 1 / hz
    end, {Increment = 1, Flag = "AntiHookHz"})

    local v44 = S_Page:CreateSection("Survivor Ability", "zap")
    AbilityCard = v44

    local v45 = AbilityCard:AddToggle("Instant TP Gate", false, function(arg)
        fn50(arg)
    end, {Flag = "InstanTPGate"})

    InstantTPToggle = v45
    InstantTPToggle:AddKeyPicker("None")

    AbilityCard:AddToggle("Auto Crouch (Dodge S1)", false, function(autoCrouch)
        _G.Ox.ParryConfig.AutoCrouch = autoCrouch
    end, {Flag = "AutoCrouch"})

    local v46 = AbilityCard:AddToggle("Unlimited Vault", false, function(arg)
        fn53(arg)
    end, {Flag = "UnlimitedVault"})

    UnlimitedVaultToggle = v46
    UnlimitedVaultToggle:AddKeyPicker("None")

    local v47 = AbilityCard:AddToggle("Anti Slow Vault", false, function(survPerfectVault)
        _G.Ox.Config.Surv_PerfectVault = survPerfectVault
        local notify = lib.Notify
        local tbl13 = {Title = "Anti Slow Vault"}
        local description = survPerfectVault and "AKTIF" or "NONAKTIF"
        tbl13.Description = description
        tbl13.Duration = 2
        notify(lib, tbl13)
    end, {Flag = "AntiSlowVault"})

    AntiSlowVaultToggle = v47
    AntiSlowVaultToggle:AddKeyPicker("None")

    local v48 = AbilityCard:AddToggle("Flowstate No CD", false, function(arg)
        fn55(arg)
    end, {Flag = "FlowstateNoCD"})

    FlowstateToggle = v48
    FlowstateToggle:AddKeyPicker("None")
end

local v3 = AbilityCard:AddToggle("No Fall Damage", false, function(arg)
    fn14(arg)
end, {Flag = "NoFallDamage"})

NoFallToggle = v3
NoFallToggle:AddKeyPicker("None")

local v4 = AbilityCard:AddToggle("Bypass Exit Gate", false, function(arg)
    fn15(arg)
end, {Flag = "BypassExiteGate"})

BypassGateToggle = v4

local v5 = AbilityCard:AddToggle("Self Heal", false, function(arg)
    fn16(arg)
end, {Flag = "SelfHeal"})

SelfHealToggle = v5
SelfHealToggle:AddKeyPicker("None")

local v6 = AbilityCard:AddToggle("God Mode (Anti Knockdown)", false, function(godMode)
    _G.Ox.GodMode = godMode
    local notify = lib.Notify
    local tbl6 = {Title = "God Mode"}
    local description = godMode and "AKTIF - HP tidak akan berkurang" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 3
    notify(lib, tbl6)
end, {Flag = "GodMode"})

GodModeToggle = v6

GodModeToggle:AddKeyPicker("GodModeKey", {
    Default = "None",
    Text = "Toggle God Mode",
    Mode = "Toggle",
    Callback = function(godMode)
        _G.Ox.GodMode = godMode
    end,
})

AbilityCard:AddButton("Apply Korless", function()
    fn17()

    lib:Notify({
        Title = "Korless",
        Description = "Korless Morph Applied!",
        Duration = 3,
    })
end)

AbilityCard:AddButton("Instan Escape", function()
    fn18()
end)

local v7 = S_Page:CreateSection("Survivor Aimbot", "crosshair")
AimbotCard = v7

local v8 = AimbotCard:AddToggle("Enable Aimbot", false, function(survAimbotEnabled)
    _G.Ox.Config.Surv_Aimbot_Enabled = survAimbotEnabled

    if not survAimbotEnabled then
        if _G.Ox.survivorAimbotHighlight then
            _G.Ox.survivorAimbotHighlight.Parent = nil
        end

        if _G.Ox.SurvivorFOVFrame then
            _G.Ox.SurvivorFOVFrame.Visible = false
        end
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Survivor Aimbot"}
    local description = survAimbotEnabled and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end, {Flag = "SurvAimbot"})

AimbotToggle = v8

AimbotToggle:AddKeyPicker("SurvivorAimbotKey", {
    Default = "None",
    Text = "Toggle Aimbot",
    Mode = "Toggle",
    Callback = function(survAimbotEnabled)
        _G.Ox.Config.Surv_Aimbot_Enabled = survAimbotEnabled

        if not survAimbotEnabled then
            if _G.Ox.survivorAimbotHighlight then
                _G.Ox.survivorAimbotHighlight.Parent = nil
            end

            if _G.Ox.SurvivorFOVFrame then
                _G.Ox.SurvivorFOVFrame.Visible = false
            end
        end
    end,
})

AimbotCard:AddToggle("Show FOV Circle", true, function(survAimbotShowFOV)
    _G.Ox.Config.Surv_Aimbot_ShowFOV = survAimbotShowFOV

    if not survAimbotShowFOV and _G.Ox.SurvivorFOVFrame then
        _G.Ox.SurvivorFOVFrame.Visible = false
    end
end, {Flag = "SurvAimbotFOV"})

AimbotCard:AddSlider("FOV Radius", 30, 500, 150, function(survAimbotRadius)
    _G.Ox.Config.Surv_Aimbot_Radius = survAimbotRadius
end, {Increment = 1, Flag = "SurvAimbotRadius"})

AimbotCard:AddSlider("Max Distance", 50, 1000, 300, function(survAimbotMaxDist)
    _G.Ox.Config.Surv_Aimbot_MaxDist = survAimbotMaxDist
end, {Increment = 10, Flag = "SurvAimbotMaxDist"})

AimbotCard:AddSlider("Smoothness", 0.1, 1, 0.5, function(survAimbotSmoothness)
    _G.Ox.Config.Surv_Aimbot_Smoothness = survAimbotSmoothness
end, {Increment = 0.05, Flag = "SurvAimbotSmoot"})

AimbotCard:AddSlider("Predict Offset", 0, 0.1, 0.01, function(survAimbotPredict)
    _G.Ox.Config.Surv_Aimbot_Predict = survAimbotPredict
end, {Increment = 0.001, Flag = "SurvAimbotPredict"})

AimbotCard:AddDropdown("Target Part", {"Torso", "Head", "Root"}, false, function(survAimbotTargetPart)
    _G.Ox.Config.Surv_Aimbot_TargetPart = survAimbotTargetPart
end, {Flag = "SurvAimbotTarget"})

local v9 = S_Page:CreateSection("Auto Parry V1", "sword")
ParryCardV1 = v9

local v10 = ParryCardV1:AddToggle("Auto Parry V1", false, function(autoParry)
    _G.Ox.ParryConfig.AutoParry = autoParry

    if not autoParry then
        _G.Ox.State.ParryCooldown = false

        if _G.Ox.State.ParryCooldownThread then
            task.cancel(_G.Ox.State.ParryCooldownThread)
            _G.Ox.State.ParryCooldownThread = nil
        end

        if ParryHUD and ParryHUD.Reset then
            ParryHUD.Reset()
        end
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Auto Parry V1"}
    local description = autoParry and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end, {Flag = "AutoParryV1"})

AutoParryToggle = v10
AutoParryToggle:AddKeyPicker("None")

local v11 = ParryCardV1:AddToggle("Custom GUI (V1)", false, function(arg)
    if arg then
        if not _G.Ox.AutoParryCustom.Gui then
            CreateCustomParryGUI()
        end

        _G.Ox.AutoParryCustom.Gui.Enabled = true
        _G.Ox.AutoParryCustom.GuiVisible = true
        UpdateCustomParryGUI(_G.Ox.ParryConfig.AutoParry)

        lib:Notify({
            Title = "Auto Parry GUI",
            Description = "Gui Dimuat",
            Duration = 2,
        })
    else
        if _G.Ox.ParryConfig.AutoParry then
            _G.Ox.ParryConfig.AutoParry = false
            _G.Ox.AutoParryCustom.IsActive = false
            fn(AutoParryToggle, false)
        end

        if _G.Ox.AutoParryCustom.Gui then
            _G.Ox.AutoParryCustom.Gui.Enabled = false
            _G.Ox.AutoParryCustom.GuiVisible = false
        end

        lib:Notify({
            Title = "Auto Parry GUI",
            Description = "Gui Disembunyikan",
            Duration = 2,
        })
    end
end, {Flag = "AutoParryGuiV1"})

CustomParryToggle = v11

ParryCardV1:AddCheckbox("Safety Parry", false, function(parrySafety)
    _G.Ox.ParryConfig.ParrySafety = parrySafety
end, {Flag = "ParrySafetyV1"})

ParryCardV1:AddToggle("Aggressive Mode", false, function(parryAggressive)
    _G.Ox.ParryConfig.ParryAggressive = parryAggressive
end, {Flag = "ParryAggressiveV1"})

ParryCardV1:AddToggle("Show Range Circle", true, function(parryCircle)
    _G.Ox.ParryConfig.ParryCircle = parryCircle
end, {Flag = "ParryCircleV1"})

ParryCardV1:AddSlider("Parry Radius", 5, 25, 15, function(parryRadius)
    _G.Ox.ParryConfig.ParryRadius = parryRadius
end, {Increment = 1, Flag = "ParryRadiusV1"})

ParryCardV1:AddSlider("Face Sensitivity", -10, 10, 7, function(arg)
    _G.Ox.ParryConfig.ParryFace = arg / 10
end, {Increment = 1, Flag = "ParryFaceV1"})

local v12 = S_Page:CreateSection("Auto Parry V2", "sword")
ParryCardV2 = v12

local v13 = ParryCardV2:AddToggle("Auto Parry V2", false, function(enabled)
    _G.Ox.ParryV2.Enabled = enabled

    if not enabled then
        V2_ResetCooldown()
        _G.Ox._V2ParryLastRoot = nil
        _G.Ox._V2ParryLastRadius = -1

        if _G.Ox.ParryV2.RangeAdornment then
            _G.Ox.ParryV2.RangeAdornment.Transparency = 1
        end
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Auto Parry V2"}
    local description = enabled and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end, {Flag = "AutoParryV2"})

ParryV2Toggle = v13
ParryV2Toggle:AddKeyPicker("None")

ParryCardV2:AddCheckbox("Safety Parry", false, function(safetyParry)
    _G.Ox.ParryV2.SafetyParry = safetyParry
end, {Flag = "ParrySafetyV2"})

ParryCardV2:AddDropdown("Mode", {"Legit", "Strict", "Aggressive"}, false, function(arg)
    local parryV2 = _G.Ox.ParryV2
    local mode = arg or "Legit"
    parryV2.Mode = mode
end, {Flag = "ParryModeV2"})

ParryCardV2:AddDropdown("Trigger", {"Remote", "Button"}, false, function(arg)
    local parryV2 = _G.Ox.ParryV2
    local trigger = arg or "Remote"
    parryV2.Trigger = trigger
end, {Flag = "ParryTriggerV2"})

ParryCardV2:AddSlider("Killer Face", -1, 1, 0.6, function(killerFace)
    _G.Ox.ParryV2.KillerFace = killerFace
end, {Increment = 0.1, Flag = "ParryKillerFaceV2"})

ParryCardV2:AddToggle("Show Range Circle", true, function(showCircle)
    _G.Ox.ParryV2.ShowCircle = showCircle

    if not showCircle and _G.Ox.ParryV2.RangeAdornment then
        _G.Ox.ParryV2.RangeAdornment.Transparency = 1
    end
end, {Flag = "ParryCircleV2"})

ParryCardV2:AddSlider("Parry Radius", 2, 20, 12, function(range)
    _G.Ox.ParryV2.Range = range
    _G.Ox._V2ParryLastRadius = -1

    if _G.Ox.ParryV2.RangeAdornment then
        _G.Ox.ParryV2.RangeAdornment.Radius = range
        _G.Ox.ParryV2.RangeAdornment.InnerRadius = math.max(0.1, range - 0.15)
    end
end, {Increment = 0.5, Flag = "ParryRadiusV2"})

local v14 = S_Page:CreateSection("Auto Drop Pallet", "fence")
PalletCard = v14

local v15 = PalletCard:AddToggle("Auto Drop Pallet", false, function(arg)
    ToggleAutoPallet(arg)
end, {Flag = "AutoDropPallet"})

AutoPalletToggle = v15

AutoPalletToggle:AddKeyPicker("AutoPalletKey", {
    Default = "None",
    Text = "Toggle Auto Drop Pallet",
    Mode = "Toggle",
    Callback = function(arg)
        ToggleAutoPallet(arg)
    end,
})

PalletCard:AddCheckbox("Safety", true, function(safety)
    _G.Ox.AutoPallet.Safety = safety
end, {Flag = "PalletSafety"})

PalletCard:AddSlider("Trigger Distance", 5, 30, 10, function(distance)
    _G.Ox.AutoPallet.Distance = distance
end, {Increment = 1, Flag = "PalletDistance"})

PalletCard:AddButton("Drop All Pallets", function()
    DropAllPallets()
end)

local Killer = v:CreateTab("Killer", false, false)
KillerTab = Killer
local Killer2 = KillerTab:CreatePage("Killer")
K_Page = Killer2
local v16 = K_Page:CreateSection("Killer Aimbot", "swords")
KillerAimbotCard = v16

local v17 = KillerAimbotCard:AddToggle("Enable Aimbot (Melee)", false, function(killerAimbotEnabled)
    _G.Ox.Config.Killer_Aimbot_Enabled = killerAimbotEnabled

    if not killerAimbotEnabled and _G.Ox.killerAimbotHighlight then
        _G.Ox.killerAimbotHighlight.Parent = nil
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Killer Aimbot"}
    local description = killerAimbotEnabled and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end)

KillerAimbotToggle = v17

KillerAimbotCard:AddSlider("Max Distance", 5, 30, 12, function(killerAimbotMaxDist)
    _G.Ox.Config.Killer_Aimbot_MaxDist = killerAimbotMaxDist
end, {Increment = 1, Flag = "AimbotKillerMaxDist"})

KillerAimbotCard:AddSlider("Smoothness", 0.1, 1, 0.5, function(killerAimbotSmoothness)
    _G.Ox.Config.Killer_Aimbot_Smoothness = killerAimbotSmoothness
end, {Increment = 0.05, Flag = "AimbotKillerSmoothness"})

local v18 = K_Page:CreateSection("Silent Veil", "arrow-up-right")
VeilCard = v18

local v19 = VeilCard:AddToggle("Silent Veil", false, function(aimSilentVeilV2)
    _G.Ox.AimConfig.Aim_SilentVeilV2 = aimSilentVeilV2
    local notify = lib.Notify
    local tbl6 = {Title = "Silent Veil"}
    local description = aimSilentVeilV2 and "ON" or "OFF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end)

VeilTog = v19

VeilCard:AddToggle("Auto Predict", false, function(spearSmartEnable)
    _G.Ox.Config.SpearSmart_enable = spearSmartEnable
end, {Flag = "SpearSmartVeil"})

VeilCard:AddToggle("Show FOV", true, function(veilShowFOV)
    _G.Ox.AimConfig.Veil_ShowFOV = veilShowFOV
end, {Flag = "VeilShowFOV"})

VeilCard:AddSlider("Lead", 0.5, 5, 1.4, function(veilLeadMultiplier)
    _G.Ox.AimConfig.Veil_LeadMultiplier = veilLeadMultiplier
end, {Increment = 0.1, Flag = "VeilLeadMulti"})

VeilCard:AddSlider("Spear Speed", 50, 200, 165, function(spearSpeed)
    _G.Ox.AimConfig.SPEAR_Speed = spearSpeed
end, {Increment = 1, Flag = "VeilSpearSpeed"})

VeilCard:AddSlider("Spear Gravity", 10, 200, 103, function(spearGravity)
    _G.Ox.AimConfig.SPEAR_Gravity = spearGravity
end, {Increment = 1, Flag = "VeilSpearGravity"})

VeilCard:AddSlider("Aura Speed", 50, 200, 165, function(spearAuraSpeed)
    _G.Ox.AimConfig.SPEAR_AuraSpeed = spearAuraSpeed
end, {Increment = 1, Flag = "VeilSpearAuraSpeed"})

VeilCard:AddSlider("Aura Gravity", 10, 200, 96.5, function(spearAuraGravity)
    _G.Ox.AimConfig.SPEAR_AuraGravity = spearAuraGravity
end, {Increment = 1, Flag = "VeilSpearAuraGravity"})

VeilCard:AddSlider("FOV", 50, 500, 150, function(veilFov)
    _G.Ox.AimConfig.Veil_FOV = veilFov
end, {Increment = 1, Flag = "VeilFOV"})

VeilCard:AddSlider("Max Dist", 50, 1000, 500, function(spearMaxDist)
    _G.Ox.AimConfig.SPEAR_MaxDist = spearMaxDist
end, {Increment = 10, Flag = "SpearMaxDist"})

local v20 = K_Page:CreateSection("Killer Ability", "zap")
AntiBlindSection = v20

local v21 = AntiBlindSection:AddToggle("Anti Blind (Flashlight)", false, function(antiBlindEnabled)
    _G.Ox.AntiBlindEnabled = antiBlindEnabled
    local notify = lib.Notify
    local tbl6 = {Title = "Anti Blind"}
    local description = antiBlindEnabled and "AKTIF - Immune dari flashlight" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 3
    notify(lib, tbl6)
end, {Flag = "AntiBlind"})

AntiBlindToggle = v21

AntiBlindToggle:AddKeyPicker("AntiBlindKey", {
    Default = "None",
    Text = "Toggle Anti Blind",
    Mode = "Toggle",
    Callback = function(antiBlindEnabled)
        _G.Ox.AntiBlindEnabled = antiBlindEnabled
    end,
})

local v22 = AntiBlindSection:AddToggle("Anti Parry", false, function(arg)
    ToggleCounterParry(arg)
end)

CounterParryToggle = v22

local v23 = AntiBlindSection:AddToggle("Infinite Lunge", false, function(arg)
    if arg then
        EnableInfiniteLunge()
    else
        DisableInfiniteLunge()
    end
end, {Flag = "InfiniteLunge"})

InfLungeToggle = v23

InfLungeToggle:AddKeyPicker("InfLungeKey", {
    Default = "None",
    Text = "Toggle Infinite Lunge",
    Mode = "Toggle",
    Callback = function(arg)
        if arg then
            EnableInfiniteLunge()
        else
            DisableInfiniteLunge()
        end
    end,
})

local v24 = AntiBlindSection:AddToggle("Auto Stalk", false, function(arg)
    ToggleAutoStalk(arg)
end, {Flag = "AutoStalk"})

AutoStalkToggle = v24

AutoStalkToggle:AddKeyPicker("AutoStalkKey", {
    Default = "None",
    Text = "Toggle Auto Stalk",
    Mode = "Toggle",
    Callback = function(arg)
        ToggleAutoStalk(arg)
    end,
})

local v25 = AntiBlindSection:AddToggle("No Slowdown Killer", false, function(noSlowdownEnabled)
    _G.Ox.NoSlowdownEnabled = noSlowdownEnabled

    if noSlowdownEnabled then
        local character = localPlayer.Character

        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end

        lib:Notify({
            Title = "No Slowdown Killer",
            Description = "AKTIF - WalkSpeed dikunci 16",
            Duration = 3,
        })
    else
        lib:Notify({
            Title = "No Slowdown Killer",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "NoSlowdown"})

AntiSlowdownToggle = v25

AntiSlowdownToggle:AddKeyPicker("NoSlowdownKey", {
    Default = "None",
    Text = "Toggle No Slowdown",
    Mode = "Toggle",
    Callback = function(noSlowdownEnabled)
        _G.Ox.NoSlowdownEnabled = noSlowdownEnabled

        if noSlowdownEnabled then
            local character = localPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end,
})

local v26 = AntiBlindSection:AddToggle("Skill Hidden No CD", false, function(bypassLeapEnabled)
    _G.Ox.BypassLeapEnabled = bypassLeapEnabled

    if bypassLeapEnabled then
        fn12()

        lib:Notify({
            Title = "Skill Hidden No CD",
            Description = "AKTIF - Cooldown skill Hidden dihilangkan",
            Duration = 3,
        })
    else
        if tbl5.LeapBypass then
            task.cancel(tbl5.LeapBypass)
            tbl5.LeapBypass = nil
        end

        lib:Notify({
            Title = "Skill Hidden No CD",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "BypassSkilHidden"})

BypassLeapToggle = v26

BypassLeapToggle:AddKeyPicker("BypassLeapKey", {
    Default = "None",
    Text = "Toggle Hidden No CD",
    Mode = "Toggle",
    Callback = function(bypassLeapEnabled)
        _G.Ox.BypassLeapEnabled = bypassLeapEnabled

        if bypassLeapEnabled then
            fn12()
        elseif tbl5.LeapBypass then
            task.cancel(tbl5.LeapBypass)
            tbl5.LeapBypass = nil
        end
    end,
})

local v27 = AntiBlindSection:AddToggle("Infinite Corrupt (Abyssal)", false, function(infAbyssalEnabled)
    _G.Ox.InfAbyssalEnabled = infAbyssalEnabled

    if not infAbyssalEnabled then
        fn13()
    end

    local notify = lib.Notify
    local tbl6 = {Title = "Infinite Corrupt"}
    local description = infAbyssalEnabled and "AKTIF - Tekan Q (PC) atau tombol skill (Mobile)" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 3
    notify(lib, tbl6)
end, {Flag = "InfinityCorrupt"})

InfAbyssalToggle = v27

InfAbyssalToggle:AddKeyPicker("InfAbyssalKey", {
    Default = "None",
    Text = "Toggle Infinite Corrupt",
    Mode = "Toggle",
    Callback = function(infAbyssalEnabled)
        _G.Ox.InfAbyssalEnabled = infAbyssalEnabled

        if not infAbyssalEnabled then
            fn13()
        end
    end,
})

local v28 = AntiBlindSection:AddToggle("Dash Lock (Hidden)", false, function(arg)
    fn10(arg)
end, {Flag = "DashLockHidden"})

DashLockToggle = v28

DashLockToggle:AddKeyPicker("DashKey", {
    Default = "V",
    Text = "Toggle Dash Lock",
    Mode = "Toggle",
    Callback = function(arg)
        fn10(arg)
    end,
})

local v29 = AntiBlindSection:AddToggle("Mask Selection GUI", false, function(arg)
    fn11(arg)
end, {Flag = "MaskSelectGui"})

MaskToggle = v29
MaskToggle:AddKeyPicker("None")

AntiBlindSection:AddButton("Aim Lock Toggle", function()
    if pcall(function()
        loadstring(game:HttpGet("https://pastefy.app/5zsm8N7G/raw"))()
    end) then
        lib:Notify({
            Title = "Aim Lock",
            Description = "Aim Lock berhasil dimuat!",
            Duration = 3,
        })
    else
        lib:Notify({
            Title = "Error",
            Description = "Gagal memuat Aim Lock!",
            Duration = 3,
        })
    end
end)

local v30 = K_Page:CreateSection("Silent Aim Flask (Cure)", "flask-conical")
FlaskCard = v30

local v31 = FlaskCard:AddToggle("Silent Aim Flask", false, function(killerSilentAimFlask)
    _G.Ox.KILLER_SilentAimFlask = killerSilentAimFlask
    local notify = lib.Notify
    local tbl6 = {Title = "Silent Aim Flask"}
    local description = killerSilentAimFlask and "AKTIF" or "NONAKTIF"
    tbl6.Description = description
    tbl6.Duration = 2
    notify(lib, tbl6)
end)

FlaskToggle = v31

local v32 = FlaskCard:AddToggle("Flask Laser", false, function(killerFlaskLaser)
    _G.Ox.KILLER_FlaskLaser = killerFlaskLaser

    if killerFlaskLaser then
        pcall(NEX_StartCureFlaskLaser)

        lib:Notify({
            Title = "Flask Laser",
            Description = "AKTIF - Laser merah muncul",
            Duration = 2,
        })
    else
        if _G.Ox.NEX_CureFlaskLaserThread then
            _G.Ox.NEX_CureFlaskLaserThread:Disconnect()
            _G.Ox.NEX_CureFlaskLaserThread = nil
        end

        if _G.Ox.NEX_CureFlaskLaserPart then
            pcall(function()
                _G.Ox.NEX_CureFlaskLaserPart:Destroy()
            end)

            _G.Ox.NEX_CureFlaskLaserPart = nil
        end

        lib:Notify({
            Title = "Flask Laser",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "LaserFlask"})

FlaskLaserToggle = v32

FlaskLaserToggle:AddKeyPicker("FlaskLaserKey", {
    Default = "None",
    Text = "Toggle Flask Laser",
    Mode = "Toggle",
    Callback = function(killerFlaskLaser)
        _G.Ox.KILLER_FlaskLaser = killerFlaskLaser

        if killerFlaskLaser then
            pcall(NEX_StartCureFlaskLaser)
        else
            if _G.Ox.NEX_CureFlaskLaserThread then
                _G.Ox.NEX_CureFlaskLaserThread:Disconnect()
                _G.Ox.NEX_CureFlaskLaserThread = nil
            end

            if _G.Ox.NEX_CureFlaskLaserPart then
                pcall(function()
                    _G.Ox.NEX_CureFlaskLaserPart:Destroy()
                end)

                _G.Ox.NEX_CureFlaskLaserPart = nil
            end
        end
    end,
})

local v33 = K_Page:CreateSection("Anti Looping", "repeat")
AntiLoopingSection = v33

local v34 = AntiLoopingSection:AddToggle("Block Vault & Pallets", false, function(blockPalletEnabled)
    _G.Ox.BlockPalletEnabled = blockPalletEnabled

    if not blockPalletEnabled then
        local vaultCompleteEvent = game:GetService("ReplicatedStorage").Remotes.Window.VaultCompleteEvent
        local palletSlideCompleteEvent = game:GetService("ReplicatedStorage").Remotes.Pallet.PalletSlideCompleteEvent
        local map = workspace:FindFirstChild("Map")

        if map then
            for k, descendant in pairs(map:GetDescendants()) do
                if descendant.Name == "VaultPointInUse" then
                    pcall(function()
                        vaultCompleteEvent:FireServer(descendant.Parent, false)
                    end)
                elseif descendant.Name == "PalletPointSlideInUse" then
                    pcall(function()
                        palletSlideCompleteEvent:FireServer(descendant.Parent, false)
                    end)
                end
            end
        end

        return
    end

    local vaultEvent = game:GetService("ReplicatedStorage").Remotes.Window.VaultEvent
    local palletSlideEvent = game:GetService("ReplicatedStorage").Remotes.Pallet.PalletSlideEvent
    local map = workspace:FindFirstChild("Map")

    if map then
        for k, descendant in pairs(map:GetDescendants()) do
            if descendant.Name == "VaultTrigger" then
                pcall(function()
                    vaultEvent:FireServer(descendant, true)
                end)
            end

            if descendant.Name == "PalletPointSlide" and descendant:IsA("BasePart") then
                pcall(function()
                    palletSlideEvent:FireServer(descendant, true)
                end)
            end
        end
    end

    task.spawn(function()
        local map2 = workspace:FindFirstChild("Map")
        if not map2 then
            return
        end
        local tbl6 = {}

        watchPallet = function(arg)
            if arg:IsA("BasePart") and arg.Name == "PalletPoint" then
                local connection = arg:GetPropertyChangedSignal("Name"):Connect(function()
                    if not _G.Ox.BlockPalletEnabled then
                        return
                    end

                    if arg.Name == "PalletPointSlide" then
                        task.wait(0.1)

                        pcall(function()
                            palletSlideEvent:FireServer(arg, true)
                        end)
                    end
                end)

                table.insert(tbl6, connection)
            end
        end

        for k, descendant in pairs(map2:GetDescendants()) do
            watchPallet(descendant)
        end

        local connection = map2.DescendantAdded:Connect(function(descendant)
            watchPallet(descendant)
        end)

        table.insert(tbl6, connection)

        while _G.Ox.BlockPalletEnabled do
            task.wait(0.5)
        end

        for k, v34 in pairs(tbl6) do
            v34:Disconnect()
        end

        tbl6 = {}
    end)

    lib:Notify({
        Title = "Anti Looping",
        Description = "✅ Aktif!",
        Duration = 2,
    })
end)

AntiLoopingToggle = v34
local Visual = v:CreateTab("Visual", false, false)
EspTab = Visual
local esp = EspTab:CreatePage("ESP")
EspPage = esp
local v35 = EspPage:CreateSection("ESP Settings", "eye")
EspMasterCard = v35

local v36 = EspMasterCard:AddToggle("Enable ESP", false, function(master)
    _G.Ox.ESPConfig.Master = master

    if master then
        ForceRefreshMap()
        lib:Notify({Title = "ESP", Description = "AKTIF", Duration = 2})
    else
        ClearAllESP()
        lib:Notify({Title = "ESP", Description = "NONAKTIF", Duration = 2})
    end
end, {Flag = "EnableEspMaster"})

EspMasterToggle = v36
EspMasterToggle:AddKeyPicker("EspKey", {Default = "None", Text = "ESP Key", Mode = "Toggle"})

EspMasterCard:AddSlider("ESP Max Distance", 100, 5000, 1000, function(maxDistance)
    _G.Ox.ESPConfig.MaxDistance = maxDistance
end, {Increment = 100, Flag = "EspMaxDistance"})

local v37 = EspMasterCard:AddCheckbox("Player ESP", false, function(player)
    _G.Ox.ESPConfig.Player = player

    if _G.Ox.ESPConfig.Master then
        if player then
            ScanMapESP()
        else
            ClearESP("Player")
        end
    end
end, {Flag = "PlayerEsp"})

PlayerToggle = v37

PlayerToggle:AddColorPicker(_G.Ox.ESPColors.Player, {
    Flag = "EspPlayer_Color",
    Title = "Warna Player ESP",
    Callback = function(player)
        _G.Ox.ESPColors.Player = player

        if _G.Ox.ESPConfig.Master then
            UpdatePlayerESP()
        end
    end,
})

local v38 = EspMasterCard:AddCheckbox("Killer ESP", false, function(killer)
    _G.Ox.ESPConfig.Killer = killer

    if _G.Ox.ESPConfig.Master then
        if killer then
            ScanMapESP()
        else
            ClearESP("Killer")
        end
    end
end, {Flag = "KillerEsp"})

KillerToggle = v38

KillerToggle:AddColorPicker(_G.Ox.ESPColors.Killer, {
    Flag = "EspKiller_Color",
    Title = "Warna Killer ESP",
    Callback = function(killer)
        _G.Ox.ESPColors.Killer = killer

        if _G.Ox.ESPConfig.Master then
            UpdatePlayerESP()
        end
    end,
})

local v39 = EspMasterCard:AddCheckbox("ESP Name", false, function(name)
    _G.Ox.ESPConfig.Name = name

    if _G.Ox.ESPConfig.Master then
        ScanMapESP()
    else
        ClearAllESP()
    end
end, {Flag = "EspName"})

NameToggle = v39

local v40 = EspMasterCard:AddCheckbox("ESP Distance", false, function(distance)
    _G.Ox.ESPConfig.Distance = distance

    if _G.Ox.ESPConfig.Master then
        UpdatePlayerESP()
    end
end, {Flag = "EspDistancw"})

DistToggle = v40

local v41 = EspMasterCard:AddCheckbox("ESP Status survivors", false, function(status)
    _G.Ox.ESPConfig.Status = status

    if _G.Ox.ESPConfig.Master then
        UpdatePlayerESP()
    end
end, {Flag = "EspStatus"})

StatusToggle = v41

local v42 = EspMasterCard:AddCheckbox("ESP Item Icon", false, function(itemIcon)
    _G.Ox.ESPConfig.ItemIcon = itemIcon

    if _G.Ox.ESPConfig.Master then
        UpdatePlayerESP()
    end
end, {Flag = "EspItemIcon"})

IconToggle = v42

local v43 = EspMasterCard:AddCheckbox("ESP Killer Warn", false, function(killerWarn)
    _G.Ox.ESPConfig.KillerWarn = killerWarn

    if not killerWarn then
        local character = localPlayer.Character
        local humanoidRootPart = character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

        if humanoidRootPart and humanoidRootPart:FindFirstChild("KillerWarn") then
            humanoidRootPart.KillerWarn:Destroy()
        end
    end
end, {Flag = "KillerWarn"})

WarnToggle = v43

local v44 = EspMasterCard:AddCheckbox("ESP Outline Mode", false, function(outline)
    _G.Ox.ESPConfig.Outline = outline
end, {Flag = "EspOutlineMode"})

OutlineToggle = v44

local v45 = EspMasterCard:AddCheckbox("ESP Hook Count", false, function(hookCount)
    _G.Ox.ESPConfig.HookCount = hookCount

    if hookCount then
        UpdateHookData()
        UpdatePlayerESP()
        UpdateHookUICounter()
        lib:Notify({Title = "Hook ESP", Description = "AKTIF", Duration = 2})
    else
        ClearHookESP()
        ClearHookUICounter()
        UpdatePlayerESP()
        lib:Notify({Title = "Hook ESP", Description = "NONAKTIF", Duration = 2})
    end
end, {Flag = "EspHookCount"})

HookCountToggle = v45
local v46 = EspPage:CreateSection("World Effects", "flashlight")
PerfCard = v46

local v47 = PerfCard:AddToggle("Full Bright", false, function(fullBright)
    _G.Ox.FullBright = fullBright
    local Lighting = game:GetService("Lighting")
    if not Lighting then
        return
    end

    if fullBright then
        StartLightingGuard()
        ReapplyPerformanceDelayed()
        lib:Notify({Title = "Full Bright", Description = "AKTIF", Duration = 2})
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000
        Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        StopLightingGuard()

        lib:Notify({
            Title = "Full Bright",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "FullBright"})

FullBrightToggle = v47

PerfCard:AddSlider("Time Of Day", 0, 24, 14, function(timeOfDayValue)
    _G.Ox.TimeOfDayValue = timeOfDayValue

    if _G.Ox.FullBright then
        local Lighting = game:GetService("Lighting")

        if Lighting then
            Lighting.ClockTime = timeOfDayValue
        end
    end
end, {Increment = 1, Flag = "TimeOfDay"})

local v48 = PerfCard:AddToggle("No Fog", false, function(noFog)
    _G.Ox.NoFog = noFog

    if noFog then
        StartLightingGuard()
        ApplyNoFog()

        lib:Notify({
            Title = "No Fog",
            Description = "AKTIF - Kabut hilang",
            Duration = 3,
        })
    else
        local Lighting = game:GetService("Lighting")

        if Lighting then
            Lighting.FogStart = 0
            Lighting.FogEnd = 1000
            local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

            if atmosphere then
                atmosphere.Density = 0.35
            end
        end

        StopLightingGuard()
        lib:Notify({Title = "No Fog", Description = "NONAKTIF", Duration = 2})
    end
end, {Flag = "NoFog"})

NoFogToggle = v48

local v49 = PerfCard:AddToggle("No Shadow", false, function(noShadow)
    _G.Ox.NoShadow = noShadow

    if noShadow then
        StartLightingGuard()
        ApplyNoShadow()

        lib:Notify({
            Title = "No Shadow",
            Description = "AKTIF - Shadow hilang",
            Duration = 2,
        })
    else
        ApplyNoShadow()
        StopLightingGuard()

        lib:Notify({
            Title = "No Shadow",
            Description = "NONAKTIF",
            Duration = 2,
        })
    end
end, {Flag = "NoShadow"})

NoShadowToggle = v49

local v50 = PerfCard:AddToggle("Remove Texture (Low GFX)", false, function(arg)
    ToggleLowGFX(arg)
end, {Flag = "RemoveTexture"})

LowGFXToggle = v50
LowGFXToggle:AddKeyPicker("None")
local v51 = EspPage:CreateSection("Map ESP", "map")
MapCard = v51

local v52 = MapCard:AddCheckbox("Generator ESP", false, function(generator)
    _G.Ox.ESPConfig.Generator = generator

    if _G.Ox.ESPConfig.Master then
        if generator then
            ScanMapESP()
        else
            ClearESP("Generator")
        end
    end
end, {Flag = "GeneratorEsp"})

GenToggle = v52

GenToggle:AddColorPicker(_G.Ox.ESPColors.Generator, {
    Flag = "Generator_Color",
    Title = "Warna Generator",
    Callback = function(generator)
        _G.Ox.ESPColors.Generator = generator

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v53 = MapCard:AddCheckbox("Generator Name & Progress", true, function(generatorName)
    _G.Ox.ESPConfig.GeneratorName = generatorName

    if _G.Ox.ESPConfig.Master then
        ScanMapESP()
    end
end, {Flag = "GeneratorName"})

GenNameToggle = v53

MapCard:AddColorPicker("Gen Done Color", _G.Ox.ESPColors.GeneratorDone, {
    Flag = "GeneratorDone_Color",
    Title = "Warna Generator Selesai",
    Callback = function(generatorDone)
        _G.Ox.ESPColors.GeneratorDone = generatorDone

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v54 = MapCard:AddCheckbox("Pallet ESP", false, function(pallet)
    _G.Ox.ESPConfig.Pallet = pallet

    if _G.Ox.ESPConfig.Master then
        if pallet then
            ScanMapESP()
        else
            ClearESP("Pallet")
        end
    end
end, {Flag = "EspPallet"})

PalletToggle = v54

PalletToggle:AddColorPicker(_G.Ox.ESPColors.Pallet, {
    Flag = "Pallet_Color",
    Title = "Warna Pallet",
    Callback = function(pallet)
        _G.Ox.ESPColors.Pallet = pallet

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v55 = MapCard:AddCheckbox("Window ESP", false, function(window)
    _G.Ox.ESPConfig.Window = window

    if _G.Ox.ESPConfig.Master then
        if window then
            ScanMapESP()
        else
            ClearESP("Window")
        end
    end
end, {Flag = "EspWindow"})

WindowToggle = v55

WindowToggle:AddColorPicker(_G.Ox.ESPColors.Window, {
    Flag = "Window_Color",
    Title = "Warna Window",
    Callback = function(window)
        _G.Ox.ESPColors.Window = window

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v56 = MapCard:AddCheckbox("Hook ESP", false, function(hook)
    _G.Ox.ESPConfig.Hook = hook

    if _G.Ox.ESPConfig.Master then
        if hook then
            ScanMapESP()
        else
            ClearESP("Hook")
        end
    end
end, {Flag = "HookEsp"})

HookToggle = v56

HookToggle:AddColorPicker(_G.Ox.ESPColors.Hook, {
    Flag = "Hook_Color",
    Title = "Warna Hook",
    Callback = function(hook)
        _G.Ox.ESPColors.Hook = hook

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v57 = MapCard:AddCheckbox("Gate ESP", false, function(gate)
    _G.Ox.ESPConfig.Gate = gate

    if _G.Ox.ESPConfig.Master then
        if gate then
            ScanMapESP()
        else
            ClearESP("Gate")
        end
    end
end, {Flag = "GateEsp"})

GateToggle = v57

GateToggle:AddColorPicker(_G.Ox.ESPColors.Gate, {
    Flag = "Gate_Color",
    Title = "Warna Gate",
    Callback = function(gate)
        _G.Ox.ESPColors.Gate = gate

        if _G.Ox.ESPConfig.Master then
            UpdateStaticESP()
        end
    end,
})

local v58 = MapCard:AddCheckbox("SCP ESP", false, function(scp)
    _G.Ox.ESPConfig.SCP = scp

    if _G.Ox.ESPConfig.Master then
        if scp then
            ScanMapESP()
        else
            ClearESP("SCP")
        end
    end
end, {Flag = "EspScp"})

SCPToggle = v58

SCPToggle:AddColorPicker(_G.Ox.ESPColors.SCP, {
    Flag = "ScpEsp_Color",
    Title = "Warna SCP",
    Callback = function(scp)
        _G.Ox.ESPColors.SCP = scp

        if _G.Ox.ESPConfig.Master then
            UpdateSCPESP()
        end
    end,
})

MapCard:AddButton("Refresh Map", function()
    ForceRefreshMap()
    lib:Notify({Title = "Map", Description = "Refreshed!", Duration = 2})
end)

local Information = EspPage:CreateSection("Information", "info")
NextKillerCard = Information

local v59 = NextKillerCard:AddToggle("Next Killer Display", false, function(arg)
    fn19(arg)
end, {Flag = "NextKillerDisplay"})

NextKillerToggle = v59

local v60 = NextKillerCard:AddToggle("Next Map Prediction", false, function(arg)
    fn20(arg)
end, {Flag = "NextMapPredict"})

MapPredictToggle = v60

local v61 = NextKillerCard:AddToggle("Killer Perks Display", false, function(arg)
    fn21(arg)
end, {Flag = "KillerPerkDisplay"})

KillerPerksToggle = v61

local v62 = NextKillerCard:AddToggle("Killer Stun Indicator", false, function(arg)
    fn22(arg)
end, {Flag = "KillerStunIndicator"})

StunToggle = v62

local v63 = NextKillerCard:AddToggle("Spectator info", false, function(arg)
    fn4(arg)
end, {Flag = "SpectatorInfo"})

SpectatorToggle = v63
local Teleport = v:CreateTab("Teleport", false, false)
TeleportTab = Teleport
local Teleport2 = TeleportTab:CreatePage("Teleport")
T_Page = Teleport2
local v64 = T_Page:CreateSection("Teleport Map", "map")
TeleportMapCard = v64

TeleportMapCard:AddButton("Refresh Map Cache", function()
    fn2()
    _G.Ox.Teleport.GenIndex = 1
    _G.Ox.Teleport.HookIndex = 1
    _G.Ox.Teleport.GateIndex = 1
    _G.Ox.Teleport.PalletIndex = 1
    _G.Ox.Teleport.WindowIndex = 1

    lib:Notify({
        Title = "Refresh",
        Description = "Cache map di-refresh!",
        Duration = 2,
    })
end)

TeleportMapCard:AddButton("Teleport ke Generator", function()
    if #tbl.Generators == 0 then
        fn2()
    end

    if #tbl.Generators < _G.Ox.Teleport.GenIndex then
        _G.Ox.Teleport.GenIndex = 1
    end

    local v65 = tbl.Generators[_G.Ox.Teleport.GenIndex]

    if v65 and v65.part then
        fn3(v65.part)

        lib:Notify({
            Title = "TP Generator",
            Description = "Generator " .. _G.Ox.Teleport.GenIndex,
            Duration = 1.2,
        })
    else
        lib:Notify({
            Title = "TP Generator",
            Description = "Generator tidak ditemukan!",
            Duration = 2,
        })
    end

    _G.Ox.Teleport.GenIndex = _G.Ox.Teleport.GenIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Hook", function()
    if #tbl.Hooks == 0 then
        fn2()
    end

    if #tbl.Hooks < _G.Ox.Teleport.HookIndex then
        _G.Ox.Teleport.HookIndex = 1
    end

    local v65 = tbl.Hooks[_G.Ox.Teleport.HookIndex]
    local basePart = v65

    if v65 then
        local hookPoint = v65:FindFirstChild("HookPoint")
        basePart = hookPoint or v65:FindFirstChildWhichIsA("BasePart")
    end

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Hook",
            Description = "Hook " .. _G.Ox.Teleport.HookIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.HookIndex = _G.Ox.Teleport.HookIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Gate", function()
    if #tbl.Gates == 0 then
        fn2()
    end

    if #tbl.Gates < _G.Ox.Teleport.GateIndex then
        _G.Ox.Teleport.GateIndex = 1
    end

    local v65 = tbl.Gates[_G.Ox.Teleport.GateIndex]
    local basePart = v65 and v65:FindFirstChildWhichIsA("BasePart")

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Gate",
            Description = "Gate " .. _G.Ox.Teleport.GateIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.GateIndex = _G.Ox.Teleport.GateIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Pallet", function()
    if #tbl.Pallets == 0 then
        fn2()
    end

    if #tbl.Pallets < _G.Ox.Teleport.PalletIndex then
        _G.Ox.Teleport.PalletIndex = 1
    end

    local v65 = tbl.Pallets[_G.Ox.Teleport.PalletIndex]
    local basePart = v65

    if v65 then
        local primaryPartPallet = v65:FindFirstChild("PrimaryPartPallet")
        basePart = primaryPartPallet or v65:FindFirstChildWhichIsA("BasePart")
    end

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Pallet",
            Description = "Pallet " .. _G.Ox.Teleport.PalletIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.PalletIndex = _G.Ox.Teleport.PalletIndex + 1
end)

TeleportMapCard:AddButton("Teleport ke Window", function()
    if #tbl.Windows == 0 then
        fn2()
    end

    if #tbl.Windows < _G.Ox.Teleport.WindowIndex then
        _G.Ox.Teleport.WindowIndex = 1
    end

    local v65 = tbl.Windows[_G.Ox.Teleport.WindowIndex]
    local basePart = v65

    if v65 then
        local bottom = v65:FindFirstChild("Bottom")
        basePart = bottom or v65:FindFirstChildWhichIsA("BasePart")
    end

    if basePart then
        fn3(basePart)

        lib:Notify({
            Title = "TP Window",
            Description = "Window " .. _G.Ox.Teleport.WindowIndex,
            Duration = 1.2,
        })
    end

    _G.Ox.Teleport.WindowIndex = _G.Ox.Teleport.WindowIndex + 1
end)

local v65 = T_Page:CreateSection("Teleport Player", "users")
PlayerCard = v65
local v66 = nil
local tbl6 = {}

local function fn23()
    tbl6 = {}

    for k, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            table.insert(tbl6, player.Name)
        end
    end

    table.sort(tbl6)
end

fn23()

local v67 = PlayerCard:AddDropdown("Pilih Player", tbl6, false, function(arg)
    v66 = arg
end)

PlayerDropdown = v67

PlayerCard:AddButton("Refresh Player List", function()
    fn23()

    pcall(function()
        if PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(tbl6)
        elseif PlayerDropdown.SetValues then
            PlayerDropdown:SetValues(tbl6)
        elseif PlayerDropdown.SetOptions then
            PlayerDropdown:SetOptions(tbl6)
        elseif PlayerDropdown.Update then
            PlayerDropdown:Update(tbl6)
        end
    end)

    lib:Notify({
        Title = "Refresh",
        Description = "List player di-refresh! (" .. #tbl6 .. " player)",
        Duration = 2,
    })
end)

Players.PlayerAdded:Connect(function()
    task.wait(0.3)
    fn23()

    pcall(function()
        if PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(tbl6)
        end
    end)
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    fn23()

    pcall(function()
        if PlayerDropdown.Refresh then
            PlayerDropdown:Refresh(tbl6)
        end
    end)
end)

PlayerCard:AddButton("Teleport ke Player", function()
    if v66 and v66 ~= "" then
        local v68 = Players:FindFirstChild(v66)

        if v68 and v68.Character and v68.Character:FindFirstChild("HumanoidRootPart") then
            local character = localPlayer.Character

            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = v68.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)

                lib:Notify({
                    Title = "Teleport",
                    Description = "Ke " .. v66,
                    Duration = 2,
                })
            end
        else
            lib:Notify({
                Title = "Error",
                Description = "Target tidak valid!",
                Duration = 2,
            })
        end

        return
    end

    lib:Notify({
        Title = "Error",
        Description = "Pilih pemain terlebih dulu!",
        Duration = 3,
    })
end)

local Settings = v:CreateTab("Settings", false, false)
SettingsTab = Settings
local Settings2 = SettingsTab:CreatePage("Settings")
S_Page1 = Settings2
local v68 = S_Page1:CreateSection("UI Config", "sliders-vertical")
AppearanceCard = v68

AppearanceCard:AddKeybind("Menu Keybind", "RightShift", function(arg)
    v:SetMenuKey(arg)
end, {Flag = "MenuKeybing"})

AppearanceCard:AddToggle("Transparency Toggle", false, function(arg)
    local setTransparency = v.SetTransparency
    local n = arg and 0.2 or 0
    setTransparency(v, n)
end, {Flag = "ToggleTransparancy"})

AppearanceCard:AddToggle("Lock GUI", false, function(arg)
    v:SetLocked(arg)
end, {Flag = "LockGui"})

AppearanceCard:AddToggle("Watermark", true, function(arg)
    lib:SetWatermark({Enabled = arg})
end, {Flag = "Watermark"})

local Config = S_Page1:CreateSection("Config", "sliders-vertical")
SavesCard = Config
SavesCard:AddConfigManager("OxioHub/Configs")

task.spawn(function()
    task.wait(2)
    fn2()
end)

localPlayer.CharacterAdded:Connect(function()
    _G.Ox.State.busy = false
    _G.Ox.State.RandomMode_IsNormal = false

    if _G.Ox.Auto.SkillCheck then
        task.wait(1)
        fn7()
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)

    if _G.Ox.NoSlowdownEnabled then
        local character = localPlayer.Character

        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)

    if _G.Ox.BypassLeapEnabled then
        fn12()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 and _G.Ox.Config.Surv_Aimbot_Enabled and GetRole() == "Survivor" then
        _G.Ox.isAimbotHolding = true
        _G.Ox.lockedAimbotTarget = getBestAimbotTarget()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.Ox.isAimbotHolding = false
        _G.Ox.lockedAimbotTarget = nil

        if _G.Ox.survivorAimbotHighlight then
            _G.Ox.survivorAimbotHighlight.Parent = nil
        end
    end
end)

task.spawn(function()
    while _G.Ox.ScriptAlive do
        task.wait(1)
        if not _G.Ox.ScriptAlive then
            break
        end

        if _G.Ox.Config.Surv_Aimbot_Enabled and GetRole() == "Survivor" and UserInputService.TouchEnabled then
            local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

            if playerGui2 then
                local survivorMob = playerGui2:FindFirstChild("Survivor-mob")

                if survivorMob then
                    local controls = survivorMob:FindFirstChild("Controls")

                    if controls then
                        local attack = controls:FindFirstChild("attack")
                        local guiMob = attack or controls:FindFirstChild("Gui-mob")

                        if guiMob and guiMob.Visible then
                            if not _G.Ox.isAimbotHolding then
                                _G.Ox.isAimbotHolding = true
                                _G.Ox.lockedAimbotTarget = getBestAimbotTarget()
                            end
                        elseif _G.Ox.isAimbotHolding then
                            _G.Ox.isAimbotHolding = false
                            _G.Ox.lockedAimbotTarget = nil

                            if _G.Ox.survivorAimbotHighlight then
                                _G.Ox.survivorAimbotHighlight.Parent = nil
                            end
                        end
                    end
                end
            end
        elseif _G.Ox.isAimbotHolding and UserInputService.TouchEnabled then
            _G.Ox.isAimbotHolding = false
            _G.Ox.lockedAimbotTarget = nil

            if _G.Ox.survivorAimbotHighlight then
                _G.Ox.survivorAimbotHighlight.Parent = nil
            end
        end
    end
end)

local v69 = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local flag2 = input.UserInputType == Enum.UserInputType.Touch
    local v70 = GetRole()

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if gameProcessed then
            return
        end

        if v70 == "Killer" and _G.Ox.Config.Killer_Aimbot_Enabled then
            _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()

            if _G.Ox.lockedKillerAimbotTarget then
                _G.Ox.isKillerAimbotHolding = true
            end
        end
    end

    if flag2 and v70 == "Killer" and _G.Ox.Config.Killer_Aimbot_Enabled then
        local playerGui2 = localPlayer:FindFirstChild("PlayerGui")
        local v71 = nil

        if playerGui2 then
            for k, child in pairs(playerGui2:GetChildren()) do
                if string.sub(child.Name, -4) == "-mob" and child.Name ~= "Survivor-mob" then
                    v71 = child
                    break
                end
            end
        end

        local attack = v71 and v71:FindFirstChild("Controls") and v71.Controls:FindFirstChild("attack")

        if attack and attack.Visible then
            local position = input.Position
            local absolutePosition = attack.AbsolutePosition
            local absoluteSize = attack.AbsoluteSize

            if absolutePosition.X <= position.X and position.X <= absolutePosition.X + absoluteSize.X and absolutePosition.Y <= position.Y and position.Y <= absolutePosition.Y + absoluteSize.Y then
                _G.Ox.lockedKillerAimbotTarget = getBestKillerAimbotTarget()

                if _G.Ox.lockedKillerAimbotTarget then
                    _G.Ox.isKillerAimbotHolding = true
                    v69 = input
                end
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        _G.Ox.isKillerAimbotHolding = false
        _G.Ox.lockedKillerAimbotTarget = nil

        if _G.Ox.killerAimbotHighlight then
            _G.Ox.killerAimbotHighlight.Parent = nil
        end
    end

    if input.UserInputType == Enum.UserInputType.Touch and input == v69 then
        _G.Ox.isKillerAimbotHolding = false
        _G.Ox.lockedKillerAimbotTarget = nil
        v69 = nil

        if _G.Ox.killerAimbotHighlight then
            _G.Ox.killerAimbotHighlight.Parent = nil
        end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    ReapplyPerformanceDelayed()
end)

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        ReapplyPerformanceDelayed()
    end
end)

task.spawn(function()
    task.wait(2)
    ReapplyPerformanceDelayed()
end)

lib:Notify({Title = "OXio Hub", Description = "Loaded", Duration = 3})
