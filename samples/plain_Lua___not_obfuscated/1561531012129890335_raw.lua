const Players = cloneref(game:GetService("Players"))
const RunService = cloneref(game:GetService("RunService"))
const LocalPlayer = Players.LocalPlayer

local Target: Player? = nil
local SpawnPos: Vector3 = Vector3.new(0, 100, 0)

@native const function Child<T>(Parent: Instance?, Name: string): T?
    return (if Parent then Parent:FindFirstChild(Name) else nil) :: T?
end

const function Root(M: Model?): BasePart?
    return Child<<BasePart>>(M, "HumanoidRootPart")
end

const function Hum(M: Model?): Humanoid?
    return Child<<Humanoid>>(M, "Humanoid")
end

const function GetTarget(Input: string): Player?
    const query = Input:lower()
    if #query == 0 then return nil end
    
    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer then continue end
        
        const Name, Dispname = plr.Name:lower(), (plr.DisplayName or plr.Name):lower()
        if Name == query or Dispname == query or Name:sub(1, #query) == query or Dispname:sub(1, #query) == query then
            return plr
        end
    end
    return nil
end

const function attach(Part: BasePart, TargetPart: BasePart?)
    pcall(sethiddenproperty, Part, 'PhysicsRepRootRef', InstanceHandle.new(TargetPart or Part))
end

const Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
const Win = Rayfield:CreateWindow({Name = "Fling People and stuff hub", Theme = "Default"})
const Main = Win:CreateTab("Main", 0)

Main:CreateInput({
    Name = "Select Target",
    PlaceholderText = "Username / Display",
    Callback = function(T: string)
        Target = GetTarget(T)
        if Target then
            Rayfield:Notify({ 
                Title = "Target Selected", 
                Content = `{Target.DisplayName} (@{Target.Name})`, 
                Duration = 3 
            })
        end
    end
})

@native const function Mvmentbtn(Name: string, Offset: Vector3, IsFling: boolean)
    local Conn: RBXScriptConnection?
    local SavedCF: CFrame?
    
    Main:CreateToggle({Name = Name, Callback = function(State: boolean)
        if Conn then Conn:Disconnect(); Conn = nil end
        
        const LRoot = Root(LocalPlayer.Character)
        if not State then
            if LRoot and SavedCF then
                LRoot.CFrame = SavedCF
                LRoot.Velocity = Vector3.zero
                LRoot.RotVelocity = Vector3.zero
                SavedCF = nil
            end
            if LRoot then attach(LRoot, LRoot) end
            return
        end
        
        if LRoot then SavedCF = LRoot.CFrame end
        
        Conn = RunService.Heartbeat:Connect(function()
            const CurrentLRoot = Root(LocalPlayer.Character)
            const TRoot = Root(Target and Target.Character)
            if not (CurrentLRoot and TRoot) then return end
            
            CurrentLRoot.CFrame = CFrame.new(TRoot.Position + Offset) * CFrame.Angles(-math.pi/2, 0, 0)
            const Vel = if IsFling then Vector3.new(500, 500, 500) else Vector3.zero
            CurrentLRoot.Velocity = Vel
            CurrentLRoot.RotVelocity = Vel
            attach(CurrentLRoot, TRoot)
        end)
    end})
end

Mvmentbtn("Fling Player", Vector3.new(0, 0, 0), true)
Mvmentbtn("Fling 2.0", Vector3.new(0, -2.5, 0), true)
Mvmentbtn("Platform Fly", Vector3.new(0, -2.8, 0), false)
Mvmentbtn("Magic Carpet", Vector3.new(0, -3.1, 0), false)
Mvmentbtn("Elevator", Vector3.new(0, -2.6, 0), false)
Mvmentbtn("Anti Jump", Vector3.new(0, 3.5, 0), false)

@native const function Bind(Name: string, Offset: Vector3)
    local Conn: RBXScriptConnection?
    
    Main:CreateToggle({ Name = Name, Callback = function(State: boolean)
        if Conn then Conn:Disconnect(); Conn = nil end
        
        const LRoot = Root(LocalPlayer.Character)
        if not State then
            if LRoot then
                LRoot.Velocity = Vector3.zero
                attach(LRoot, LRoot)
            end
            return
        end
        
        Conn = RunService.Heartbeat:Connect(function()
            const CurrentLRoot = Root(LocalPlayer.Character)
            const TRoot = Root(Target and Target.Character)
            if CurrentLRoot and TRoot then
                CurrentLRoot.CFrame = TRoot.CFrame * CFrame.new(Offset)
                CurrentLRoot.Velocity = Vector3.zero
                attach(CurrentLRoot, TRoot)
            end
        end)
    end})
end

Bind("Infinite Jump", Vector3.new(0, -5.75, 0))
Bind("Speed Boost (slow)", Vector3.new(0, 0.7, 1))
Bind("Speed Boost (medium)", Vector3.new(0, 0.7, 0.5))
Bind("Speed Boost (fast)", Vector3.new(0, 0.7, 0.35))
Bind("Movement Breaker", Vector3.new(0, 0.7, -0.8))

@native const function CreateRocket(Name: string, Speed: number)
    local Conn: RBXScriptConnection?
    
    Main:CreateToggle({Name = Name, Callback = function(State: boolean)
        if Conn then Conn:Disconnect(); Conn = nil end
        if not State then return end
        
        const LRoot = Root(LocalPlayer.Character)
        const TRoot = Root(Target and Target.Character)
        if not (LRoot and TRoot) then return end
        
        const SavedCF = LRoot.CFrame
        Conn = RunService.Heartbeat:Connect(function()
            if not TRoot.Parent then return end
            const Pos = TRoot.Position + Vector3.new(0, -3, 0)
            LRoot.CFrame = CFrame.new(Pos, Pos + Vector3.new(0, 1, 0))
            LRoot.Velocity = Vector3.new(0, Speed, 0)
            LRoot.RotVelocity = Vector3.zero
            attach(LRoot, TRoot)
        end)
        
        task.delay(0.2, function()
            if Conn then Conn:Disconnect(); Conn = nil end
            LRoot.CFrame = SavedCF
            LRoot.Velocity = Vector3.zero
            LRoot.RotVelocity = Vector3.zero
            attach(LRoot, LRoot)
            pcall(function() Main:SetToggle(Name, false) end)
        end)
    end})
end

CreateRocket("Rocket Target", 50)
CreateRocket("GODSPEED", 5000)

local Flingin = false
Main:CreateButton({Name = "NaN Fling", Callback = function()
    if Flingin then return end
    
    const Char = LocalPlayer.Character
    const LRoot, LHum = Root(Char), Hum(Char)
    const TRoot = Root(Target and Target.Character)
    if not (LRoot and LHum and TRoot) then return end
    Flingin = true
    const SavedCF = LRoot.CFrame
    const SavedVel = LRoot.Velocity
    const SavedPlatform = LHum.PlatformStand
    const Vec = Vector3.new(0/0, 0/0, 0/0)
    
    LHum.PlatformStand = true
    local Conn: RBXScriptConnection?
    Conn = RunService.Heartbeat:Connect(function()
        LRoot.CFrame = TRoot.CFrame
        LRoot.AssemblyLinearVelocity = Vec
        LRoot.AssemblyAngularVelocity = Vec
        pcall(function() LHum:Move(Vec) end)
        attach(LRoot, TRoot)
    end)
    
    task.delay(1.5, function()
        if Conn then Conn:Disconnect() end
        LHum.PlatformStand = SavedPlatform
        LRoot.AssemblyLinearVelocity = Vector3.zero
        LRoot.AssemblyAngularVelocity = Vector3.zero
        LRoot.CFrame = SavedCF
        LRoot.Velocity = SavedVel
        LRoot.RotVelocity = Vector3.zero
        attach(LRoot, LRoot)
        Flingin = false
    end)
end})

const Other = Win:CreateTab("Other", 0)

local anflc: RBXScriptConnection?
Other:CreateToggle({
    Name = "Anti Fling",
    Callback = function(State: boolean)
        if anflc then anflc:Disconnect(); anflc = nil end
        if not State then return end
        local Bl: {[Player]: boolean} = {}
        anflc = RunService.RenderStepped:Connect(function()
            for _, plrs in Players:GetPlayers() do
                if plrs == LocalPlayer or Bl[plrs] then continue end
                const targethrp = Root(plrs.Character)
                if targethrp and targethrp.AssemblyLinearVelocity.Magnitude > 67 then
                    Bl[plrs] = true
                    for _, Part in plrs.Character:GetDescendants() do
                        if not Part:IsA("BasePart") then continue end
                        (Part :: BasePart).CanCollide = false
                    end
                end
            end
        end)
    end
})

LocalPlayer.CharacterAdded:Connect(function(Char: Model)
    const HRP = Char:WaitForChild("HumanoidRootPart", 5) :: BasePart?
    if HRP then SpawnPos = HRP.Position + Vector3.new(0, 5, 0) end
end)

if LocalPlayer.Character then
    const LRoot = Root(LocalPlayer.Character)
    if LRoot then SpawnPos = LRoot.Position + Vector3.new(0, 5, 0) end
end

local anti: RBXScriptConnection?
Other:CreateToggle({Name = "Anti-Void", Callback = function(s: boolean)
    if anti then anti:Disconnect(); anti = nil end
    if not s then return end
    anti = RunService.Heartbeat:Connect(function()
        const LRoot = Root(LocalPlayer.Character)
        if LRoot and LRoot.Position.Y < (workspace.FallenPartsDestroyHeight + 10) then
            LRoot.CFrame = CFrame.new(SpawnPos)
            LRoot.AssemblyLinearVelocity = Vector3.zero
            LRoot.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end})

setclipboard("https://discord.gg/xGucmFjGVD")