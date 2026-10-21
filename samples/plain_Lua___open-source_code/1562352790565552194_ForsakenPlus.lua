-- Forsaken Plus Made by Naiko Scripts --
-- Copies of this script must contain the original credits and be open source --

if workspace.DistributedGameTime < 4 then
	task.wait(4 - workspace.DistributedGameTime)
end

if game.CoreGui:FindFirstChild("Plus") then
    return warn("Script already running")
elseif game.GameId == 6331902150 or game.GameId == 7464167604 or workspace:GetAttribute("ServerType") then
	Instance.new("BoolValue", game.CoreGui).Name = "Plus"
else
	return warn("Incorrect game")
end

game:GetService("Players").LocalPlayer.Idled:Connect(function()
	game:GetService("VirtualUser"):ClickButton2(Vector2.new())
end)

-- General Variables --

Version = "1.94"
Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
LocalCharacter = LocalPlayer.Character
LocalHumanoid = LocalCharacter and (LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid",2)) or nil
LocalHead = LocalCharacter and (LocalCharacter:FindFirstChild("Head") or LocalCharacter:WaitForChild("Head",2)) or nil
LocalRoot = LocalCharacter and ((LocalHumanoid and LocalHumanoid.RootPart) or LocalCharacter:FindFirstChild("HumanoidRootPart") or LocalCharacter:WaitForChild("HumanoidRootPart",2)) or nil
LocalAnimator = LocalHumanoid and (LocalHumanoid:FindFirstChildOfClass("Animator") or LocalHumanoid:WaitForChild("Animator",2)) or nil
SpeedMultipliers = LocalCharacter and (LocalCharacter:FindFirstChild("SpeedMultipliers")) or nil
ResistanceMultipliers = LocalCharacter and (LocalCharacter:FindFirstChild("ResistanceMultipliers")) or nil
FOVMultipliers = LocalCharacter and (LocalCharacter:FindFirstChild("FOVMultipliers")) or nil
CoreGui = game:GetService("CoreGui")
PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 20)
MainUI = PlayerGui:FindFirstChild("MainUI") or PlayerGui:WaitForChild("MainUI", 80)
PlayerData = LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:WaitForChild("PlayerData", 20)
PlusFolderSettings = Instance.new("Folder")
SideBar = MainUI:FindFirstChild("Sidebar") or MainUI:WaitForChild("Sidebar", 20)
Buttons = SideBar:FindFirstChild("Buttons") or SideBar:FindFirstChild("Middle") or SideBar:FindFirstChild("Stats",true) and SideBar:FindFirstChild("Stats",true).Parent or SideBar:WaitForChild("Buttons", 4) or SideBar:WaitForChild("Middle", 4) 
MainButton = Buttons:FindFirstChild("Settings") or Buttons:FindFirstChild("Stats") or Buttons:WaitForChild("Settings", 4) or Buttons:FindFirstChild("Stats") or Buttons:WaitForChild("Stats", 4)
SidePlusButton = MainButton and MainButton:Clone()
PlusButton = SidePlusButton and SidePlusButton:FindFirstChild("Button") or nil
PulloutFramePlus = SidePlusButton and SidePlusButton:FindFirstChild("PulloutHolder") and SidePlusButton.PulloutHolder:FindFirstChild("PulloutFrame")
NewUIVersion = not PulloutFramePlus
SettingsMenu = MainUI:FindFirstChild("SettingsScreen") or MainUI:WaitForChild("SettingsScreen", 20)
TempUI = PlayerGui:FindFirstChild("TemporaryUI") or PlayerGui:WaitForChild("TemporaryUI",5)
PlusMenu = SettingsMenu and SettingsMenu:Clone()
PlayersFolder = workspace:FindFirstChild("Players")
KillersFolder = PlayersFolder and PlayersFolder:FindFirstChild("Killers")
SurvivorsFolder = PlayersFolder and PlayersFolder:FindFirstChild("Survivors")
RagdollsFolder = workspace:FindFirstChild("Ragdolls")
Hitboxes = workspace:FindFirstChild("Hitboxes")
MarketplaceService = game:GetService("MarketplaceService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
UserInputService = game:GetService("UserInputService")
TextChatService = game:GetService("TextChatService")
PhysicsService = game:GetService("PhysicsService")
TweenService = game:GetService("TweenService")
GroupService = game:GetService("GroupService")
HttpService = game:GetService("HttpService")
LogService = game:GetService("LogService")
RunService = game:GetService("RunService")
StarterGui = game:GetService("StarterGui")
Lighting = game:GetService("Lighting")
Debris = game:GetService("Debris")
AssetsFolder = ReplicatedStorage:FindFirstChild("Assets") or ReplicatedStorage:WaitForChild("Assets",3)
SkinsAssets = AssetsFolder and AssetsFolder:FindFirstChild("Skins")
SurvivorAssets = AssetsFolder and AssetsFolder:FindFirstChild("Survivors")
KillerAssets = AssetsFolder and AssetsFolder:FindFirstChild("Killers")
MinigamesFolder = ReplicatedStorage:FindFirstChild("Minigames",true)
FlowGame = MinigamesFolder and MinigamesFolder:FindFirstChild("FlowGame",true) or MinigamesFolder:FindFirstChild("FlowBoard")
LockBoard = MinigamesFolder and MinigamesFolder:FindFirstChild("LockBoard")
ConnectBoard = MinigamesFolder and MinigamesFolder:FindFirstChild("ConnectBoard")
StatusEffects = ReplicatedStorage:FindFirstChild("StatusEffects",true)
Network = ReplicatedStorage:FindFirstChild("Modules") and (ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Network",true) and ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Network",true):FindFirstChild("Network")) or ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Network",true) or nil
InGame = workspace:FindFirstChild("Map") and workspace:FindFirstChild("Map"):FindFirstChild("Ingame")
GameMap = InGame and InGame:FindFirstChild("Map") or nil
RoundEvent = Instance.new("BindableEvent")
local BindableShouldStop = Instance.new("BindableEvent")
local UIScale = Instance.new("UIScale")
IsUnderground,IsFixingGenerator,WarnedAboutFilesCompatability = false,false,false
OverriddenAnimations,AllAnimations,Values = {},{["Default Roblox"] = {["Idle"] = "http://www.roblox.com/asset/?id=180435571",["Walk"] = "http://www.roblox.com/asset/?id=180426354",["Run"] = "http://www.roblox.com/asset/?id=180426354"}},{}
local ModulesOptions,LastTrack,NoliConfig,GetAnimationType,LastAnimOriginalUsed,UpdateAnim,CanPlayOverrideAnim,CurrentQTEAzure,TeleportSound,GetFunction
ColorPresets = {["White"] = Color3.fromRGB(255,255,255),["Teal"] = Color3.fromRGB(3,252,157),["Green"] = Color3.fromRGB(0,255,0),["Light Green"] = Color3.fromRGB(191, 255, 191),["Purple"] = Color3.fromRGB(158, 0, 179),["Red"] = Color3.fromRGB(255,0,0),["Blue"] = Color3.fromRGB(0,0,255),["Cyan"] = Color3.fromRGB(0,255,255),["Gold"] = Color3.fromRGB(255,215,0),["Orange"] = Color3.fromRGB(255,135,15)}
IgnoreKeybinds = {"W", "A", "S", "D"}
GameVersionForScript = "2026-20-10"
local FeatureLoadout; FeatureLoadout = {
    ["EnviromentFunctions"] = {
          ["TabAttributes"] = {
            ["DisplayTitle"] = "Script Made by Naiko Scripts | " .. tostring(Version),
            ["LayoutOrder"] = 666
        },
        ["hookmetamethod"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "hookmetamethod",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["getgc"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "getgc",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["require"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "require",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["files"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "files",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = true
        },
        ["OfficialGame"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Official Game",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = game.GameId == 6331902150 or game.GameId == 7464167604 or game.GameId == 7919224306,
            ["Requirement"] = true
        },
        ["PrivateServer"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Private Server",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = workspace:GetAttribute("ServerType") == "VIP",
            ["Requirement"] = true
        },
        ["PrivateServerOwner"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Private Server",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = workspace:GetAttribute("ServerOwnerID") == LocalPlayer.UserId,
            ["Requirement"] = true
        },
        ["NServer"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "N Server",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = game.PlaceId == 83645629621104,
            ["Requirement"] = true
        },
        ["Computer"] = {
            ["DisplayDescription"] = " ",
            ["DisplayTitle"] = "Computer",
            ["LayoutOrder"] = 666,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = UserInputService.KeyboardEnabled,
            ["Requirement"] = true,
            ["OnLoop"] = function(self)
                self.Instance.Value = UserInputService.KeyboardEnabled
            end
        },
    },

    ["Automation"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Automation",
            ["LayoutOrder"] = 1
        },
        ["AutoGeneratorPuzzle"] = {
            ["DisplayDescription"] = "Auto Completes Generator Puzzles",
            ["DisplayTitle"] = "Auto Generator(s)",
            ["LayoutOrder"] = 1,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["GenCheck"] = function(self)
                return not self.Solving or not LocalCharacter or not (GetValue("AutoGeneratorPuzzle"))
            end,
            ["GetDelay"] = function(self)
                local Cooldown = tonumber(GetValue("GeneratorCooldown")) or 2
                local CooldownInstance = GetValue("GeneratorCooldown",true)
                local IsNear = self:IsPlayersNear(32)
                local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and Cooldown > 2 and CooldownInstance and CooldownInstance:GetAttribute("MinValue")) or Cooldown
                GenCD = math.max(tonumber(GenCD) or Cooldown,0.25)
                return self.RNG:NextNumber(GenCD - 0.1 * GenCD,GenCD + 0.1 * GenCD)
            end,
            ["GetStepDelay"] = function(self)
                local CooldownInstance = GetValue("GeneratorCooldown",true)
                local Step = CooldownInstance and CooldownInstance:GetAttribute("CurrentSpeed")
                return math.max(tonumber(Step) or 0.05,0.01)
            end,
            ["IsAlive"] = function(self,Key)
                return self.Sessions ~= nil and self.Sessions[Key] ~= nil
            end,
            ["BlockInputs"] = function(self)
                self.InputBlockCount = (self.InputBlockCount or 0) + 1
                if self.InputBlocked then
                    return
                end
                self.InputBlocked = true
                local ContextActionService = self.ContextActionService
                if not ContextActionService then
                    ContextActionService = game:GetService("ContextActionService")
                    self.ContextActionService = ContextActionService
                end
                ContextActionService:BindActionAtPriority("GeneratorBlock",function()
                    return Enum.ContextActionResult.Sink
                end,false,10000,Enum.UserInputType.MouseButton1,Enum.UserInputType.Touch)
            end,
            ["UnblockInputs"] = function(self,Force)
                if Force then
                    self.InputBlockCount = 0
                else
                    self.InputBlockCount = math.max((self.InputBlockCount or 1) - 1,0)
                end
                if self.InputBlockCount > 0 or not self.InputBlocked then
                    return
                end
                self.InputBlocked = false
                local ContextActionService = self.ContextActionService
                if not ContextActionService then
                    return
                end
                ContextActionService:UnbindAction("GeneratorBlock")
            end,
            ["BlockInputObject"] = function(self,Input)
                if not Input or Input.__Blocked then
                    return
                end
                Input.__Blocked = true
                if typeof(Input.__disableConsole) == "function" then
                    Input:__disableConsole()
                end
                local Connections = Input.__connections
                if typeof(Connections) == "table" then
                    for i,Connection in Connections do
                        if typeof(Connection) == "RBXScriptConnection" then
                            Connection:Disconnect()
                        end
                    end
                    table.clear(Connections)
                end
            end,
            ["GetGearsCount"] = function(self)
                if not self.GearsHandler then
                    local Module = ReplicatedStorage:FindFirstChild("GearsClientHandler", true)
                    if not Module then
                        return nil
                    end
                    self.GearsHandler = require(Module)
                end
                return self.GearsHandler:Get()
            end,
            ["SetLoadState"] = function(self,State)
                local PuzzleUI = PlayerGui:FindFirstChild("PuzzleUI")
                local Container = PuzzleUI and PuzzleUI:FindFirstChild("Container")
                local Holder = Container and Container:FindFirstChild("GridHolder")
                local Overlay = Holder and Holder:FindFirstChild("load")
                if not Overlay then
                    return
                end
                local Label = Overlay:FindFirstChild("TextButton")
                local Folder = Overlay:FindFirstChild("Folder")
                if State == "NeedsGears" then
                    if Label then
                        Label.Text = "Gears Needed"
                        Label.Position = UDim2.new(0.5,0,0.5,0)
                    end
                    for i,v in Folder:GetChildren() do
                        v.Visible = false
                    end
                else
                    if Label then
                        Label.Text = "Completing"
                        Label.Position = UDim2.new(0.5,0,0.6,0)
                    end
                    for i,v in Folder:GetChildren() do
                        v.Visible = true
                    end
                end
            end,
            ["LegacyLoop"] = function(self)
                if GetValue("require") then
                    return
                end
                if self.Solving or not GameMap then
                    return
                end
                if not LocalRoot or LocalRoot.Anchored == true then
                    return
                end
                for i,Object in GameMap:QueryDescendants("Model#Generator:has(#Main)") do
                    local Main = Object:FindFirstChild("Main")
                    if Main and (Main.Position - LocalRoot.Position).Magnitude < 6.7 then
                        local Remotes = Object:FindFirstChild("Remotes")
                        local Progress = Remotes and Object:FindFirstChild("Progress")
                        local RemoteEvent = Progress and Remotes:FindFirstChildOfClass("RemoteEvent")
                        if RemoteEvent and PlayerGui:FindFirstChild("PuzzleUI") then
                            task.spawn(function()
                                self.Solving = true
                                self:BlockInputs()
                                while PlayerGui:FindFirstChild("PuzzleUI") and not self:GenCheck() do
                                    local IsNear = self:IsPlayersNear(32)
                                    local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and GetValue("GeneratorCooldown") > 2 and (GetValue("GeneratorCooldown",true):GetAttribute("MinValue"))) or GetValue("GeneratorCooldown")
                                    task.wait(self.RNG:NextNumber(GenCD - 0.1 * GenCD,GenCD + 0.1 * GenCD))
                                    if self:GenCheck() or not PlayerGui:FindFirstChild("PuzzleUI") then
                                        break
                                    end
                                    if not GetValue("require") then
                                        RemoteEvent:FireServer()
                                        PlaySound("puzzleDone",{["Parent"] = Object:FindFirstChild("Main")})
                                    end
                                end
                                self.Solving = false
                                self:UnblockInputs()
                            end)
                        end
                        break
                    end
                end
            end,
            ["FindSession"] = function(self,Name,SessionId)
                local Module = self.Controller:GetMinigame(Name)
                if not Module then
                    return nil
                end
                return Module:FromSessionId(SessionId)
            end,
            ["WaitSession"] = function(self,Name,SessionId,Timeout)
                local WaitUntil = os.clock() + (Timeout or 2)
                local Session = self:FindSession(Name,SessionId)
                while (not Session or not Session.__input) and os.clock() < WaitUntil do
                    task.wait(0.05)
                    Session = self:FindSession(Name,SessionId)
                end
                return Session
            end,
            ["BuildFlowSolution"] = function(self,Size,Pairs)
                if #Pairs == 0 then
                    return nil
                end
                local Rows,Cols = {},{}
                for Cell = 1,Size * Size do
                    Rows[Cell] = (Cell - 1) // Size + 1
                    Cols[Cell] = (Cell - 1) % Size + 1
                end
                local Dots = {}
                for i,Pair in Pairs do
                    Dots[Pair[1]] = true
                    Dots[Pair[2]] = true
                end
                local function FindPath(From,To,Blocked,WantPath)
                    local Queue = {From}
                    local Head = 1
                    local Seen = {[From] = true}
                    local Parent
                    local Depth
                    if WantPath then
                        Parent = {}
                    else
                        Depth = {[From] = 0}
                    end
                    while Head <= #Queue do
                        local Cell = Queue[Head]
                        Head = Head + 1
                        if Cell == To then
                            if not WantPath then
                                return Depth[Cell]
                            end
                            local Path = {}
                            local Current = To
                            while Current do
                                table.insert(Path,1,Current)
                                Current = Parent[Current]
                            end
                            for i,PathCell in Path do
                                Blocked[PathCell] = true
                            end
                            return Path
                        end
                        local Neighbors = {}
                        if Rows[Cell] > 1 then
                            table.insert(Neighbors,Cell - Size)
                        end
                        if Rows[Cell] < Size then
                            table.insert(Neighbors,Cell + Size)
                        end
                        if Cols[Cell] > 1 then
                            table.insert(Neighbors,Cell - 1)
                        end
                        if Cols[Cell] < Size then
                            table.insert(Neighbors,Cell + 1)
                        end
                        for i = #Neighbors,2,-1 do
                            local Swap = self.RNG:NextInteger(1,i)
                            Neighbors[i],Neighbors[Swap] = Neighbors[Swap],Neighbors[i]
                        end
                        for i,Next in Neighbors do
                            if not Seen[Next] and not Blocked[Next] and (not Dots[Next] or Next == To) then
                                Seen[Next] = true
                                if WantPath then
                                    Parent[Next] = Cell
                                else
                                    Depth[Next] = Depth[Cell] + 1
                                end
                                table.insert(Queue,Next)
                            end
                        end
                    end
                    return nil
                end
                local Order = {}
                for i = 1,#Pairs do
                    Order[i] = i
                end
                table.sort(Order,function(a,b)
                    local A = Pairs[a]
                    local B = Pairs[b]
                    return (math.abs(Rows[A[1]] - Rows[A[2]]) + math.abs(Cols[A[1]] - Cols[A[2]])) < (math.abs(Rows[B[1]] - Rows[B[2]]) + math.abs(Cols[B[1]] - Cols[B[2]]))
                end)
                for Try = 1,400 do
                    local Blocked = {}
                    local Solution = {}
                    local Solved = true
                    if Try <= 60 then
                        local Work = {}
                        for i,Index in Order do
                            Work[i] = Index
                        end
                        for i = #Work,2,-1 do
                            local Swap = self.RNG:NextInteger(1,i)
                            Work[i],Work[Swap] = Work[Swap],Work[i]
                        end
                        for i,Index in Work do
                            local Pair = Pairs[Index]
                            local Path = FindPath(Pair[1],Pair[2],Blocked,true)
                            if not Path then
                                Solved = false
                                break
                            end
                            Solution[Index] = Path
                        end
                    else
                        local Remaining = {}
                        for i = 1,#Pairs do
                            Remaining[i] = i
                        end
                        while #Remaining > 0 do
                            local BestDist
                            local Ties = {}
                            for k,Index in Remaining do
                                local Pair = Pairs[Index]
                                local Dist = FindPath(Pair[1],Pair[2],Blocked,false)
                                if Dist then
                                    if not BestDist or Dist < BestDist then
                                        BestDist = Dist
                                        Ties = {k}
                                    elseif Dist == BestDist then
                                        table.insert(Ties,k)
                                    end
                                end
                            end
                            if #Ties == 0 then
                                Solved = false
                                break
                            end
                            local Pick = Ties[self.RNG:NextInteger(1,#Ties)]
                            local Index = Remaining[Pick]
                            table.remove(Remaining,Pick)
                            local Pair = Pairs[Index]
                            local Path = FindPath(Pair[1],Pair[2],Blocked,true)
                            if not Path then
                                Solved = false
                                break
                            end
                            Solution[Index] = Path
                        end
                    end
                    if Solved then
                        return Solution
                    end
                end
                return nil
            end,
            ["BuildConnectSolution"] = function(self,Blobs)
                local Groups = {}
                for Blob,Color in Blobs do
                    if typeof(Blob) ~= "number" or typeof(Color) ~= "number" then
                        return nil
                    end
                    Groups[Color] = Groups[Color] or {}
                    table.insert(Groups[Color],Blob)
                end
                local Solution = {}
                local Total = 0
                for i,Group in Groups do
                    if #Group % 2 ~= 0 then
                        return nil
                    end
                    for i2 = 1,#Group,2 do
                        table.insert(Solution,{math.min(Group[i2],Group[i2 + 1]),math.max(Group[i2],Group[i2 + 1])})
                        Total = Total + 2
                    end
                end
                return Total > 0 and Solution or nil
            end,
            ["DrawFlow"] = function(self,Key,Input,Solution)
                local Board = Input.Board
                local Renderer = Input.Renderer
                local Sounds = self.SoundsModule
                if not Board or typeof(Board.Paths) ~= "table" then
                    return false
                end
                local Order = {}
                for i = 1,#Solution do
                    Order[i] = i
                end
                for i = #Order,2,-1 do
                    local Swap = self.RNG:NextInteger(1,i)
                    Order[i],Order[Swap] = Order[Swap],Order[i]
                end
                for i,Index in Order do
                    local Path = Solution[Index]
                    if Path and not Input.Ended then
                        Board.Paths[Index] = {}
                        if Sounds then
                            Sounds:Play("dragBegin")
                        end
                        for i2,Cell in Path do
                            if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                                return false
                            end
                            table.insert(Board.Paths[Index],Cell)
                            if typeof(Board.__rebuild) == "function" then
                                Board:__rebuild()
                            end
                            if Renderer and typeof(Renderer.Render) == "function" then
                                Renderer.Render(Renderer)
                            end
                            if Sounds then
                                if i2 >= #Path then
                                    Sounds:Play("lineConnect")
                                else
                                    Sounds:Play("lineDraw")
                                end
                            end
                            task.wait(self:GetStepDelay())
                        end
                        if Sounds then
                            Sounds:Play("dragEnd")
                        end
                        task.wait(0.15)
                    end
                end
                return true
            end,
            ["DrawConnect"] = function(self,Key,Input,Solution)
                local Board = Input.Board
                local Renderer = Input.Renderer
                local Sounds = self.SoundsModule
                if not Board or typeof(Board.Connect) ~= "function" then
                    return false
                end
                local Cooldown = tonumber(GetValue("GeneratorCooldown")) or 4
                local CooldownInstance = GetValue("GeneratorCooldown",true)
                local IsNear = self:IsPlayersNear(32)
                local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and Cooldown > 2 and CooldownInstance and CooldownInstance:GetAttribute("MinValue")) or Cooldown
                GenCD = math.max(tonumber(GenCD) or Cooldown,0.25)
                local PairDelay = math.max(GenCD / math.max(#Solution,1),0.1)
                for i,Pair in Solution do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return false
                    end
                    task.wait(PairDelay * 0.8)
                    if typeof(Board.GetLink) ~= "function" or not Board:GetLink(Pair[1]) then
                        if Sounds then
                            Sounds:Play("lineConnect")
                        end
                        Board:Connect(Pair[1],Pair[2])
                    end
                    if Renderer and typeof(Renderer.Render) == "function" then
                        Renderer.Render(Renderer)
                    end
                    task.wait(PairDelay * 0.2)
                end
                return true
            end,
            ["SolveFlow"] = function(self,Key,Index,SessionId,Properties)
                local Size = Properties:Get("GridSize")
                local Pairs = Properties:Get("Pairs")
                if typeof(Size) ~= "number" or typeof(Pairs) ~= "table" then
                    return
                end
                local Solution = self:BuildFlowSolution(Size,Pairs)
                local Round = 1
                while not Solution and Round < 3 do
                    Round = Round + 1
                    task.wait(0.25)
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    Solution = self:BuildFlowSolution(Size,Pairs)
                end
                if not Solution then
                    self.Controller:FireServer(Index,SessionId,"Leave")
                    return
                end
                for Attempt = 1,10 do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    local Session = self:WaitSession("FlowClientMinigame",SessionId,4)
                    local Input = Session and Session.__input
                    self:BlockInputObject(Input)
                    local Board = Input and Input.Board
                    local CanDraw = Input and Board and Board.Size == Size and not Input.Ended and typeof(Board.Paths) == "table"
                    if CanDraw then
                        self:DrawFlow(Key,Input,Solution)
                        task.wait(0.2)
                        if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                            return
                        end
                        Session = self:FindSession("FlowClientMinigame",SessionId)
                        Input = Session and Session.__input
                        Board = Input and Input.Board
                        local Solved = Board and typeof(Board.IsSolved) == "function" and Board:IsSolved()
                        if Solved then
                            if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                                return
                            end
                            local Export
                            if typeof(Board.Export) == "function" then
                                Export = Board:Export()
                            end
                            self.Controller:FireServer(Index,SessionId,"Submit",Export or Solution)
                            task.wait(0.4)
                        end
                    else
                        self.Controller:FireServer(Index,SessionId,"Submit",Solution)
                        task.wait(0.4)
                    end
                    if Attempt == 10 and self:IsAlive(Key) then
                        self.Controller:FireServer(Index,SessionId,"Submit",Solution)
                        task.wait(0.4)
                    end
                end
            end,
            ["SolveConnect"] = function(self,Key,Index,SessionId,Properties)
                local Blobs = Properties:Get("Blobs")
                if typeof(Blobs) ~= "table" then
                    return
                end
                local Solution = self:BuildConnectSolution(Blobs)
                if not Solution then
                    return
                end
                for Attempt = 1,10 do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    local Session = self:WaitSession("ConnectClientMinigame",SessionId,2)
                    local Input = Session and Session.__input
                    self:BlockInputObject(Input)
                    local Board = Input and Input.Board
                    if Input and Board and not Input.Ended and typeof(Board.Connect) == "function" then
                        self:DrawConnect(Key,Input,Solution)
                    end
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    Session = self:FindSession("ConnectClientMinigame",SessionId)
                    Input = Session and Session.__input
                    Board = Input and Input.Board
                    local Solved = Board and typeof(Board.IsSolved) == "function" and Board:IsSolved()
                    local Export
                    if Board and Solved and typeof(Board.Export) == "function" then
                        Export = Board:Export()
                    end
                    self.Controller:FireServer(Index,SessionId,"Submit",Export or Solution)
                    task.wait(0.4)
                end
            end,
            ["SolveLock"] = function(self,Key,Index,SessionId,Properties)
                local LockBoardModule = self.LockBoardModule
                if not LockBoardModule then
                    return
                end
                local Config = Properties:Get("Config")
                if typeof(Config) ~= "table" or typeof(Config.Seed) ~= "number" or typeof(Config.Speed) ~= "number" or typeof(Config.TargetSize) ~= "number" or typeof(Config.Hits) ~= "number" or typeof(Config.StartTime) ~= "number" then
                    return
                end
                local Session = self:WaitSession("LockClientMinigame",SessionId,2)
                local Input = Session and Session.__input
                self:BlockInputObject(Input)
                local OnPress
                local Callbacks = Input and Input.Callbacks
                if typeof(Callbacks) == "table" and typeof(Callbacks.OnPress) == "function" then
                    OnPress = Callbacks.OnPress
                end
                local Board = LockBoardModule.new(Config)
                local function ApplyState(State)
                    if typeof(State) == "table" and typeof(State.Presses) == "number" and State.Presses >= Board.State.Presses then
                        Board:Apply(State)
                    end
                end
                local Connection
                if typeof(Properties.Connect) == "function" then
                    Connection = Properties:Connect("State", ApplyState)
                end
                ApplyState(Properties:Get("State"))
                local PressedTarget
                local Attempts = 0
                local MaxAttempts = math.max(Config.Hits * 8,16)
                while self:IsAlive(Key) and Attempts < MaxAttempts do
                    ApplyState(Properties:Get("State"))
                    if GetValue("AutoGeneratorPuzzle") and not Board:IsBroken() then
                        local Now = workspace:GetServerTimeNow()
                        local Angle = Board:AngleAt(Now)
                        local State = Board.State
                        local Target = State.Target
                        local OnTarget = Board:IsOnTarget(Angle)
                        if not OnTarget then
                            PressedTarget = nil
                        elseif PressedTarget ~= Target then
                            PressedTarget = Target
                            Attempts += 1
                            local Diff = (Angle - Target) % 360
                            if Diff > 180 then
                                Diff = Diff - 360
                            end
                            local Tau = 0
                            if State.Direction ~= 0 and Config.Speed > 0 then
                                Tau = -Diff / (State.Direction * Config.Speed)
                            end
                            local HalfTol = 0
                            if Config.Speed > 0 then
                                HalfTol = (Config.TargetSize / 2) / Config.Speed
                            end
                            local PressAfter = Tau + self.RNG:NextNumber(-0.95,0.3) * HalfTol
                            if PressAfter < 0 or PressAfter > 1.4 then
                                PressAfter = 0
                            end
                            local PressesBefore = Board.State.Presses
                            if typeof(OnPress) == "function" then
                                if PressAfter > 0 and PressAfter < 1.5 then
                                    task.wait(PressAfter)
                                end
                                OnPress()
                            else
                                local PressTime = Now + PressAfter
                                if PressAfter > 0 and PressAfter < 1.5 then
                                    task.wait(PressAfter)
                                end
                                if Board:IsOnTarget(Board:AngleAt(PressTime)) then
                                    if Board:Press(PressTime) then
                                        self.Controller:FireServer(Index,SessionId,"Press",PressTime)
                                    end
                                end
                            end
                            local Timeout = os.clock() + 1
                            while os.clock() < Timeout and self:IsAlive(Key) do
                                local ServerState = Properties:Get("State")
                                if typeof(ServerState) == "table" and typeof(ServerState.Presses) == "number" and ServerState.Presses > PressesBefore then
                                    break
                                end
                                task.wait()
                            end
                            local ServerState = Properties:Get("State")
                            if typeof(ServerState) == "table" and typeof(ServerState.Presses) == "number" then
                                Board:Apply(ServerState)
                            end
                        end
                    end
                    task.wait()
                end
                if Connection and typeof(Connection.Disconnect) == "function" then
                    Connection:Disconnect()
                end
            end,
            ["SolveGear"] = function(self,Key,Index,SessionId,Properties)
                local Session = self:WaitSession("GearClientMinigame",SessionId,2)
                local Renderer = Session and Session.__renderer
                if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                    return
                end
                local Count = self:GetGearsCount()
                if Count and Count < 1 then
                    self:SetLoadState("NeedsGears")
                    return
                end
                local WaitUntil = os.clock() + 2
                while Renderer and os.clock() < WaitUntil do
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    if Renderer.__flying and not Renderer.__flight then
                        break
                    end
                    task.wait(0.05)
                end
                if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                    return
                end
                self:SetLoadState("Completing")
                self:BlockInputObject(Session and Session.__input)
                local Sounds = self.SoundsModule
                local Turns = math.max(tonumber(Properties:Get("Turns")) or 1,1) * 360
                if Renderer and typeof(Renderer.SetProgress) == "function" then
                    local Duration = math.clamp(Turns / 1080,1.2,3)
                    local ProgressValue = Instance.new("NumberValue")
                    if Renderer.UI then
                        ProgressValue.Parent = Renderer.UI
                    end
                    local LastProgress = 0
                    local Spun = 0
                    local LastTick = 0
                    local Connection = ProgressValue:GetPropertyChangedSignal("Value"):Connect(function()
                        local Current = ProgressValue.Value
                        local DeltaProgress = Current - LastProgress
                        LastProgress = Current
                        Renderer.SetProgress(Renderer,Current,DeltaProgress * Turns)
                        Spun = Spun + DeltaProgress * Turns
                        if Sounds and math.floor(Spun / 45) > math.floor(LastTick / 45) then
                            LastTick = Spun
                            Sounds:Play("tick")
                        end
                    end)
                    local Tween = TweenService:Create(ProgressValue,TweenInfo.new(Duration,Enum.EasingStyle.Linear),{Value = 1})
                    Tween:Play()
                    while Tween.PlaybackState == Enum.PlaybackState.Playing do
                        if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                            Tween:Cancel()
                            break
                        end
                        task.wait()
                    end
                    Connection:Disconnect()
                    ProgressValue:Destroy()
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    if typeof(Renderer.Spin) == "function" then
                        Renderer.Spin(Renderer)
                    end
                    if Sounds then
                        Sounds:Play("lineConnect")
                    end
                    self.Controller:FireServer(Index,SessionId,"Screwed")
                else
                    task.wait(self:GetDelay())
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        return
                    end
                    self.Controller:FireServer(Index,SessionId,"Screwed")
                end
            end,
            ["HandleSession"] = function(self,Index,SessionId,Properties)
                if typeof(Properties) ~= "table" then
                    return
                end
                if Properties:Get("FixerUserId") ~= LocalPlayer.UserId then
                    return
                end
                if self.Sessions == nil then
                    return
                end
                local Key = tostring(Index) .. "-" .. tostring(SessionId)
                if self.Sessions[Key] ~= nil then
                    return
                end
                self.Sessions[Key] = os.clock()
                task.spawn(function()
                    while self:IsAlive(Key) and not GetValue("AutoGeneratorPuzzle") do
                        task.wait(0.1)
                    end
                    if not self:IsAlive(Key) then
                        return
                    end
                    local Solver
                    local WaitUntil = os.clock() + 5
                    while not Solver and os.clock() < WaitUntil do
                        local Name
                        if typeof(self.Controller.GetMinigameIndex) == "function" then
                            for i,Value in {"FlowClientMinigame","ConnectClientMinigame","LockClientMinigame","GearClientMinigame"} do
                                if self.Controller:GetMinigameIndex(Value) == Index then
                                    Name = Value
                                    break
                                end
                            end
                        end
                        if Name == "FlowClientMinigame" then
                            Solver = self.SolveFlow
                        elseif Name == "ConnectClientMinigame" then
                            Solver = self.SolveConnect
                        elseif Name == "LockClientMinigame" then
                            Solver = self.SolveLock
                        elseif Name == "GearClientMinigame" then
                            Solver = self.SolveGear
                        end
                        if not Solver then
                            local Pairs = Properties:Get("Pairs")
                            local Blobs = Properties:Get("Blobs")
                            local Config = Properties:Get("Config")
                            local MaxGears = Properties:Get("MaxGears")
                            if typeof(Config) == "table" and typeof(Config.Seed) == "number" then
                                Solver = self.SolveLock
                            elseif typeof(Pairs) == "table" and #Pairs > 0 then
                                Solver = self.SolveFlow
                            elseif typeof(Blobs) == "table" and #Blobs > 0 then
                                Solver = self.SolveConnect
                            elseif typeof(MaxGears) == "number" and MaxGears > 0 then
                                Solver = self.SolveGear
                            end
                        end
                        if not Solver then
                            task.wait(0.05)
                        end
                    end
                    if not Solver or not self:IsAlive(Key) then
                        return
                    end
                    self.Solving = true
                    self:BlockInputs()
                    task.wait(0.35)
                    if not self:IsAlive(Key) or not GetValue("AutoGeneratorPuzzle") then
                        self.Solving = false
                        self:UnblockInputs()
                        return
                    end
                    Solver(self,Key,Index,SessionId,Properties)
                    self.Solving = false
                    self:UnblockInputs()
                end)
            end,
            ["Install"] = function(self)
                if self.Controller or self.Installing then
                    return false
                end
                if not GetValue("require") then
                    return false
                end
                self.Installing = true
                local ControllerInstance = ReplicatedStorage:FindFirstChild("MinigameController", true)
                if typeof(ControllerInstance) == "Instance" then
                    local Controller = require(ControllerInstance)
                    if typeof(Controller) == "table" and typeof(Controller.RegisterProperties) == "function" and typeof(Controller.UnregisterProperties) == "function" then
                        local LockBoardInstance = ReplicatedStorage:FindFirstChild("LockBoard", true)
                        self.LockBoardModule = LockBoardInstance and require(LockBoardInstance)
                        local SoundsInstance = ReplicatedStorage:FindFirstChild("Rendering", true)
                        SoundsInstance = SoundsInstance and SoundsInstance:FindFirstChild("Sounds")
                        if not (typeof(SoundsInstance) == "Instance" and SoundsInstance:IsA("ModuleScript")) then
                            SoundsInstance = ReplicatedStorage:FindFirstChild("Sounds", true)
                        end
                        if typeof(SoundsInstance) == "Instance" and SoundsInstance:IsA("ModuleScript") then
                            self.SoundsModule = require(SoundsInstance)
                        end
                        self.Sessions = {}
                        local OriginalRegister = Controller.RegisterProperties
                        Controller.RegisterProperties = function(ControllerSelf,Index,SessionId,Properties)
                            OriginalRegister(ControllerSelf,Index,SessionId,Properties)
                            self:HandleSession(Index,SessionId,Properties)
                        end
                        local OriginalUnregister = Controller.UnregisterProperties
                        Controller.UnregisterProperties = function(ControllerSelf,Index,SessionId)
                            if self.Sessions then
                                self.Sessions[tostring(Index) .. "-" .. tostring(SessionId)] = nil
                            end
                            return OriginalUnregister(ControllerSelf,Index,SessionId)
                        end
                        self.Controller = Controller
                        task.spawn(function()
                            task.wait(2)
                            for i,Name in {"FlowClientMinigame","ConnectClientMinigame","LockClientMinigame","GearClientMinigame"} do
                                if typeof(self.Controller.GetMinigame) == "function" then
                                    local Module = self.Controller:GetMinigame(Name)
                                    if Module and typeof(Module.FromSessionId) == "function" then
                                        for SessionId = 1,500 do
                                            if Module:FromSessionId(SessionId) then
                                                local Index
                                                if typeof(self.Controller.GetMinigameIndex) == "function" then
                                                    Index = self.Controller:GetMinigameIndex(Name)
                                                end
                                                if typeof(Index) ~= "number" and typeof(self.Controller.GetSession) == "function" then
                                                    for CheckIndex = 0,40 do
                                                        if self.Controller:GetSession(CheckIndex,SessionId) == Module then
                                                            Index = CheckIndex
                                                            break
                                                        end
                                                    end
                                                end
                                                if typeof(Index) == "number" then
                                                    local Session = Module:FromSessionId(SessionId)
                                                    local Network = Session and Session.Network
                                                    local Properties = Network and Network.Properties
                                                    if Properties then
                                                        self:HandleSession(Index,SessionId,Properties)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end
                self.Installing = false
                return self.Controller ~= nil
            end,
            ["ScriptFunction"] = function(self,Value)
                if Value then
                    task.spawn(function()
                        self:Install()
                    end)
                else
                    self:UnblockInputs(true)
                end
            end,
            ["Requirement"] = "require",
            ["IsPlayersNear"] = function(self,Distance)
                if LocalCharacter and LocalRoot then
                    for i,v in Players:GetPlayers() do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").Position-LocalRoot.Position).Magnitude < Distance  then
                            return true
                        end
                    end
                end
                return false
            end,
            ["RNG"] = Random.new(),
            ["OnLoop"] = function(self)
                if not GetValue("AutoGeneratorPuzzle") then
                    return
                end
                if self.Controller then
                    local Now = os.clock()
                    if self.Sessions then
                        for Key,At in self.Sessions do
                            if typeof(At) == "number" and Now - At > 600 then
                                self.Sessions[Key] = nil
                            end
                        end
                    end
                    local Active = self.Solving or (self.Sessions ~= nil and next(self.Sessions) ~= nil)
                    if not Active and self.InputBlocked then
                        self:UnblockInputs(true)
                    end
                    if Active then
                        self.OrphanPuzzleAt = nil
                        if Now - (self.ExtraUiAt or 0) > 2 then
                            self.ExtraUiAt = Now
                            local LastPuzzle
                            for i,Ui in PlayerGui:GetChildren() do
                                if Ui.Name == "PuzzleUI" then
                                    LastPuzzle = Ui
                                end
                            end
                            if LastPuzzle then
                                for i,Ui in PlayerGui:GetChildren() do
                                    if Ui.Name == "PuzzleUI" and Ui ~= LastPuzzle then
                                        Ui:Destroy()
                                    end
                                end
                            end
                        end
                    elseif PlayerGui:FindFirstChild("PuzzleUI") then
                        self.OrphanPuzzleAt = self.OrphanPuzzleAt or os.clock()
                        if os.clock() - self.OrphanPuzzleAt > 4 then
                            local AnyLive = true
                            if typeof(self.Controller.GetSession) == "function" then
                                AnyLive = false
                                for CheckIndex = 0,40 do
                                    for CheckId = 1,80 do
                                        if self.Controller:GetSession(CheckIndex,CheckId) then
                                            AnyLive = true
                                            break
                                        end
                                    end
                                    if AnyLive then
                                        break
                                    end
                                end
                            end
                            if AnyLive then
                                self.OrphanPuzzleAt = os.clock()
                            else
                                self.OrphanPuzzleAt = nil
                                for i,Orphan in PlayerGui:GetChildren() do
                                    if Orphan.Name == "PuzzleUI" then
                                        Orphan:Destroy()
                                    end
                                end
                            end
                        end
                    else
                        self.OrphanPuzzleAt = nil
                    end
                    return
                end
                if not self.Installing and os.clock() - (self.InstallAt or 0) >= 3 then
                    self.InstallAt = os.clock()
                    task.spawn(function()
                        self:Install()
                    end)
                end
                if self.UsesNewSystem == nil then
                    self.UsesNewSystem = ReplicatedStorage:FindFirstChild("MinigameController", true) ~= nil
                end
                if not self.UsesNewSystem then
                    self:LegacyLoop()
                end
            end,
            ["CustomSetup"] = function(self)
                task.spawn(function()
                    self:Install()
                end)
                local LoadUI = Instance.new("TextButton")
                local Folder = Instance.new("Folder")
                local Dot1 = Instance.new("TextLabel")
                local TextButton = Instance.new("TextLabel")

                LoadUI.Name = "load"
                LoadUI.BackgroundColor3 = Color3.new(0, 0, 0)
                LoadUI.BackgroundTransparency = 0.4
                LoadUI.BorderSizePixel = 0
                LoadUI.Active = true
                LoadUI.Interactable = true
                LoadUI.AutoButtonColor = false
                LoadUI.Size = UDim2.new(1, 0, 1, 0)
                LoadUI.ZIndex = 25
                LoadUI.Text = ""

                Folder.Parent = LoadUI

                Dot1.Name = "1"
                Dot1.Parent = Folder
                Dot1.AnchorPoint = Vector2.new(0.5, 0)
                Dot1.BackgroundColor3 = Color3.new(1, 1, 1)
                Dot1.BackgroundTransparency = 1
                Dot1.BorderSizePixel = 0
                Dot1.Position = UDim2.new(0.5, 0, -0.05, 0)
                Dot1.Size = UDim2.new(0.1, 0, 1, 0)
                Dot1.ZIndex = 4
                Dot1.Font = Enum.Font.Cartoon
                Dot1.Text = "."
                Dot1.TextColor3 = Color3.new(1, 1, 1)
                Dot1.TextSize = 50
                Dot1.TextScaled = true
                Dot1.TextStrokeTransparency = 0.9

                local Dot2 = Dot1:Clone()
                Dot2.Name = "2"
                Dot2.Parent = Folder

                local Dot3 = Dot1:Clone()
                Dot3.Name = "3"
                Dot3.Parent = Folder

                TextButton.Name = "TextButton"
                TextButton.Parent = LoadUI
                TextButton.BackgroundColor3 = Color3.new(1, 1, 1)
                TextButton.BackgroundTransparency = 1
                TextButton.BorderSizePixel = 0
                TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
                TextButton.Position = UDim2.new(0.5, 0, 0.6, 0)
                TextButton.Selectable = false
                TextButton.Size = UDim2.new(0.4, 0, 0.4, 0)
                TextButton.ZIndex = 7
                TextButton.Font = Enum.Font.SciFi
                TextButton.Text = "Completing"
                TextButton.TextColor3 = Color3.new(1, 1, 1)
                TextButton.TextSize = 20
                TextButton.TextScaled = true
                TextButton.TextStrokeTransparency = 0.9

                PlayerGui.ChildAdded:Connect(function(Child)
                    if Child.Name == "PuzzleUI" then
                        local ClonedLoadUI = LoadUI:Clone()
                        ClonedLoadUI.Parent = Child.Container.GridHolder
                        local InstanceAuto = GetValue("AutoGeneratorPuzzle",true)
                        ClonedLoadUI.Visible = InstanceAuto.Value
                        local ValueConnection = InstanceAuto:GetPropertyChangedSignal("Value"):Connect(function()
                            ClonedLoadUI.Visible = InstanceAuto.Value
                        end)
                        task.spawn(function()
                            while task.wait() and ClonedLoadUI.Parent and Child.Parent do
                                if ClonedLoadUI.Visible then
                                    for i = 1, 3 do
                                        ClonedLoadUI.Folder[i].Rotation = math.cos(tick() + i * 10) * 360
                                    end
                                else
                                    wait(0.1)
                                end
                            end
                            ValueConnection:Disconnect()
                        end)
                    end
                end)
            end
        },
        ["GeneratorCooldown"] = {
            ["DisplayDescription"] = "The cooldown in seconds before completing a generator",
            ["DisplayTitle"] = "Cooldown Between Auto Completions",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 4,
            ["Requirement"] = "AutoGeneratorPuzzle",
            ["ExtraData"] = {
                ["MaxValue"] = 8,
                ["MinValue"] = 1.5,
                ["Step"] = 0.25,
                ["CurrentSpeed"] = 0.4,
                ["CurrentGrid"] = 6
            },
            ["IsPlayersNear"] = function(self,Distance)
                if LocalCharacter and LocalRoot then
                    for i,v in Players:GetPlayers() do
                        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and (v.Character:FindFirstChild("HumanoidRootPart").Position-LocalRoot.Position).Magnitude < Distance  then
                            return true
                        end
                    end
                end
                return false
            end,
            ["OnLoop"] = function(self)
                if os.clock() - (self.LastUpdate or 0) < 0.25 then
                    return
                end
                self.LastUpdate = os.clock()
                local IsNear = self:IsPlayersNear(32)
                local CurrentGrid = self.Instance:GetAttribute("CurrentGrid") or 6
                if not self.RNG then
                    self.RNG = Random.new()
                end
                local GenCD = (not IsNear and GetValue("SpeedUpCooldown") and self.Instance:GetAttribute("MinValue")) or self.RNG:NextNumber(GetValue("GeneratorCooldown") - 0.1 * GetValue("GeneratorCooldown"),GetValue("GeneratorCooldown") + 0.1 * GetValue("GeneratorCooldown"))
                self.Instance:SetAttribute("CurrentSpeed",(GenCD / math.pow(CurrentGrid,2)))
            end
        },
        ["SpeedUpCooldown"] = {
            ["DisplayDescription"] = "Make the cooldown low when nobody is near to look at you",
            ["DisplayTitle"] = "Speed Up When Nobodys Near",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "AutoGeneratorPuzzle|GeneratorCooldown~1.5|GeneratorCooldown~1.75|GeneratorCooldown~2"
        },
        ["AutoPickup"] = {
            ["DisplayDescription"] = "Auto-Picks up <b>Items</b> near you",
            ["DisplayTitle"] = "Auto Pickup",
            ["LayoutOrder"] = 4,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["CustomSetup"] = function(self)
                if ReplicatedStorage:FindFirstChild("GearClientMinigame",true) then
                    self.DisplayDescription = "Auto-Picks up <b>Items</b> and <b>Gears</b> near you"
                end
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                         if Child:IsA("Tool") then
                            Child:SetAttribute("JustDropped", true)
                            task.delay(1.5, function()
                                if Child then
                                    Child:SetAttribute("JustDropped", nil)
                                end
                            end)
                        end
                    end)
                end
            end
        },
        ["AutoEscape"] = {
            ["DisplayDescription"] = "Auto-Escapes <b>Nosferatu's</b> Hook",
            ["DisplayTitle"] = "Auto Escape",
            ["LayoutOrder"] = 5,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Nosferatu"
        },
        ["EscapeCooldown"] = {
            ["DisplayDescription"] = "The cooldown in seconds before pressing a key",
            ["DisplayTitle"] = "Cooldown Between Auto Escape Presses",
            ["LayoutOrder"] = 6,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 0.5,
            ["Requirement"] = "Killer:Nosferatu|AutoEscape",
            ["ExtraData"] = {
                ["MaxValue"] = 1.2,
                ["MinValue"] = 0.2,
                ["Step"] = 0.1,
            },
            ["ScriptFunction"] = function(self, Value)
                if Value <= 0.3 then
                    GetValue("EscapeCooldown",true):SetAttribute("DisplayDescription",self["DisplayDescription"] .. " " .. RichTextGradientColor("(TOO FAST)",{Color3.fromRGB(251, 107, 43),Color3.fromRGB(251, 165, 43),Color3.fromRGB(251, 107, 43)}))
                else
                    GetValue("EscapeCooldown",true):SetAttribute("DisplayDescription",self["DisplayDescription"])
                end
            end,
            ["CustomSetup"] = function(self)
                TempUI.ChildAdded:Connect(function(UIElement)
                    if UIElement.Name:upper() == "QTE" and UIElement:FindFirstChildOfClass("UIAspectRatioConstraint") then
                        while UIElement and UIElement.Visible do
                            local Cooldown = GetValue("EscapeCooldown")
                            task.wait(Random.new():NextNumber(Cooldown - 0.2 * Cooldown,Cooldown + 0.2 * Cooldown))
                            if GetValue("AutoEscape") then
                                for i,v in KillersFolder:GetChildren() do
                                    if v.Name:lower() == "nosferatu" then
                                        local Player = Players:GetPlayerFromCharacter(v)
                                        if Player then
                                            Network:FindFirstChildOfClass("RemoteEvent"):FireServer(Player.Name.."NosHookQTE",{true})
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        },
        ["AutoDisarm"] = {
            ["DisplayDescription"] = "Auto-Disarms <b>Azure's</b> Traps Instantly",
            ["DisplayTitle"] = "Auto Disarm",
            ["LayoutOrder"] = 7,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Azure|require",
            ["HookInstalled"] = false,
            ["ScriptFunction"] = function(self, Value)
                if not Value then
                    return
                end
                if typeof(CurrentQTEAzure) == "table" and typeof(CurrentQTEAzure.AddProgress) == "function" then
                    CurrentQTEAzure:AddProgress(100)
                end
                CurrentQTEAzure = nil
            end,
            ["CustomSetup"] = function(self)
                if typeof(hookfunction) ~= "function" or not GetValue("require") then
                    return
                end
                local Time = workspace.DistributedGameTime
                while not self.HookInstalled and Time < workspace.DistributedGameTime + 5 do
                    local Azure = KillerAssets and (KillerAssets:FindFirstChild("Azure") or KillerAssets:FindFirstChild("!Azure"))
                    local AzureQTE = Azure and Azure:FindFirstChild("cl_ConstructQTE", true)
                    if AzureQTE then
                        local Got, RequiredModule = pcall(require, AzureQTE)
                        if Got and typeof(RequiredModule) == "table" and typeof(RequiredModule.new) == "function" then
                            local OriginalNew
                            OriginalNew = hookfunction(RequiredModule.new, function(selfArg, ...)
                                local QTEAzure = OriginalNew(selfArg, ...)
                                task.delay(0.05, function()
                                    if typeof(QTEAzure) == "table" and typeof(QTEAzure.AddProgress) == "function" then
                                        if GetValue("AutoDisarm") then
                                            QTEAzure:AddProgress(100)
                                        else
                                            CurrentQTEAzure = QTEAzure
                                        end
                                    end
                                end)
                                return QTEAzure
                            end)
                            if typeof(OriginalNew) == "function" then
                                self.HookInstalled = true
                            end
                        end
                    end
                    if not self.HookInstalled then
                        task.wait(0.5)
                    end
                end
            end
        },
    },

    ["Features"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Features",
            ["LayoutOrder"] = 3
        },
        ["Invincible"] = {
            ["DisplayDescription"] = "Makes you invisible & god mode (you can still use abilities)",
            ["DisplayTitle"] = "Invincible",
            ["LayoutOrder"] = 1,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = true--[["hookmetamethod|OfficialGame" FORSAKEN PATCHED]],
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("Invincible") == nil then
                    workspace:SetAttribute("Invincible", Value)
                    self.Instance.Value = Value
                    if Value then
                        GetValue("DisableToxicTrails",true).Value = true
                        GetValue("DisableFootprints",true).Value = true
                    end
                    task.delay(1.5, function()
                        workspace:SetAttribute("Invincible",nil)
                    end)
                    self:GoUnder(Value)
                else
                    self.Instance.Value = workspace:GetAttribute("Invincible")
                end
            end,
            ["IsHitboxNotNear"] = function(self,HitboxPart,Position)
                if HitboxPart and Position and LocalRoot then
                    local IsHitboxNotNearParams = OverlapParams.new()
                    IsHitboxNotNearParams.FilterType = Enum.RaycastFilterType.Include
                    IsHitboxNotNearParams.MaxParts = 1
                    IsHitboxNotNearParams.FilterDescendantsInstances = {HitboxPart}
                    local Result = workspace:GetPartBoundsInRadius(Position, 2.5, IsHitboxNotNearParams)
                    return #Result == 0
                else
                    ColoredPrint("HitboxPart/Position/HumanoidRootPart is nil while trying to check if near", "info", Color3.new(1,0.25,0))
                    return false
                end
            end,
            ["VelocityToPosition"] = function(self,target)
                local TimeLimit = workspace.DistributedGameTime + 7
                local OGCG = LocalRoot.CollisionGroup
                local AllParts = LocalCharacter:QueryDescendants("BasePart:not([CollisonGroup=Default])")
                for i,v in AllParts do
                    v.CollisionGroup = "None"
                end
                local Body = Instance.new("BodyVelocity")
                Body.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                Body.Velocity = Vector3.new(0, 0, 0)
                Body.Parent = LocalRoot
                while (LocalRoot.Position - target).Magnitude > 2 and not (workspace.DistributedGameTime >= TimeLimit) do
                    Body.Velocity = (target - LocalRoot.Position).Unit * 100
                    RunService.RenderStepped:Wait()
                end
                if workspace.DistributedGameTime >= TimeLimit then
                    warn("Failed to do in time")
                end
                Body:Destroy()
                for i,v in AllParts do
                    v.CollisionGroup = OGCG
                end
            end,
            ["GoUnder"] = function(self,Value)
                local Offset = 22
                if Value == nil then
                    IsUnderground = false
                    Value = GetValue("Invincible")
                end
                if Value and not SideBar:GetAttribute("WasVisible") and not IsUnderground then
                    IsUnderground = false
                    if not (LocalRoot and LocalHead and LocalHumanoid and MainUI.Enabled) then
                        repeat task.wait(0.25) until (LocalRoot and LocalHead and LocalHumanoid and MainUI.Enabled)
                    end
                    local MapName
                    if GameMap and GameMap:FindFirstChild("Config") and GetValue("require") then
                        local MapData = require(GameMap:FindFirstChild("Config"))
                        if MapData and MapData["DisplayName"] ~= nil then
                            MapName = MapData["DisplayName"]
                        end
                    end
                    local OldCFrame:CFrame = LocalRoot.CFrame
                    local UnderCFrame
                    if MapName == "Underground War" then
                        local SelfParams = OverlapParams.new()
                        SelfParams.FilterType = Enum.RaycastFilterType.Include
                        SelfParams.MaxParts = 1
                        SelfParams.FilterDescendantsInstances = {LocalRoot}
                        local BoxCheck = workspace:GetPartBoundsInBox(CFrame.new(-172,4444,-20,1,0,0,0,1,0,0,0,1),Vector3.new(230, 35, 300),SelfParams)
                        if #BoxCheck > 0 then
                            Offset = 50
                        end
                        local MapPart = GameMap:FindFirstChild("DirtSlabs",true) and GameMap:FindFirstChild("DirtSlabs",true):FindFirstChildWhichIsA("BasePart")
                        if MapPart then
                            UnderCFrame = CFrame.new(Vector3.new(OldCFrame.X + 0.5,MapPart.Position.Y - 7.5,OldCFrame.Z + 0.5))
                        else
                            UnderCFrame = OldCFrame * CFrame.new(0, -Offset, 0)
                        end
                    else
                        UnderCFrame = OldCFrame * CFrame.new(0, -Offset, 0)
                    end
                    LocalHumanoid.CameraOffset = Vector3.new(0, 12e12 ,0)
                    task.wait(0.1)
                    LocalRoot.CFrame = UnderCFrame
                    local Tries = 0
                    local TimerStop = workspace.DistributedGameTime + 3.5
                    repeat
                        Tries += 1
                        LocalRoot.Velocity = Vector3.zero
                        self:VelocityToPosition(UnderCFrame.Position)
                        LocalHead.Anchored = true
                        repeat task.wait() until self:IsHitboxNotNear(LocalCharacter:FindFirstChild("QueryHitbox"),OldCFrame.Position) or not LocalRoot or not LocalCharacter or TimerStop < workspace.DistributedGameTime
                        IsUnderground = true
                        task.wait()
                        LocalRoot.Velocity = Vector3.zero
                        LocalHead.Anchored = false
                        LocalRoot.CFrame = OldCFrame
                        RunService.Heartbeat:Wait()
                        LocalRoot.Velocity = Vector3.zero
                    until self:IsHitboxNotNear(LocalCharacter:FindFirstChild("QueryHitbox"),OldCFrame.Position) or Tries >= 3
                    if Tries >= 3 then
                        IsUnderground = false
                        workspace:SetAttribute("Invincible",nil)
                        GetValue("Invincible",true).Value = false
                        if GetValue("OfficialGame") then
                            StarterGui:SetCore("SendNotification",{
                                Title = "Fail",  Text = "Failed to become invincible, if this keeps happning please report this in the discord server",
                                Icon = "rbxasset://textures/DevConsole/Warning.png", Duration = 4.5
                            })
                        else
                            StarterGui:SetCore("SendNotification",{
                                Title = "Fail", Text = "Failed to become invincible, this feature is not supported here",
                                Icon = "rbxasset://textures/DevConsole/Warning.png", Duration = 4.5
                            })
                            GetValue("Invincible",true):SetAttribute("Requirement", true)
                        end
                        return ColoredPrint("Failed to go invincible! Tried 3 Times and still failed.", "info", Color3.new(1,0.25,0))
                    end
                else
                    IsUnderground = false
                end
            end,
            ["CharacterAdded"] = function(self)
                task.delay(1,self.GoUnder,self)
                if not LocalRoot then
                    repeat task.wait() until LocalRoot
                end
                LocalRoot:GetPropertyChangedSignal("Anchored"):Connect(function()
                    if not LocalRoot.Anchored then
                        task.delay(0.75,self.GoUnder,self)
                    end
                end)
            end,
            ["CustomSetup"] = function(self)
                if GetValue("OfficialGame") and GetValue("hookmetamethod") then
                    task.spawn(function()
                        export type DesyncHook = {DesyncNumber:number,BufferCorruption:buffer}
                        export type CorruptArguments = {Number:number,Table1:table,NilObject:any,Table2:table}
                        local hookmetamethod = GetFunction(hookmetamethod, hook_metamethod)
                        local HookSuccess, HookResult = pcall(function()
                            local UnreliableRemoteEvent = Network:WaitForChild("UnreliableRemoteEvent")
                            local newcclosure = GetFunction(newcclosure, new_cclosure)
                            local checkcaller = GetFunction(checkcaller, check_caller)
                            if not newcclosure or not checkcaller then
                                return
                            end
                            local FeatureInstance = GetValue("Invincible",true)
                            if not FeatureInstance.Value then
                                FeatureInstance:GetPropertyChangedSignal("Value"):Wait()
                            end
                            local TypeEnum = "invalidnumber"
                            local __namecall
                            __namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...): DesyncHook
                                if not checkcaller() and IsUnderground and getnamecallmethod() == "FireServer" and self == UnreliableRemoteEvent and FeatureInstance and FeatureInstance.Value then
                                    local Args: CorruptArguments = {...}
                                    if Args[1] == math.pow(#TypeEnum,0) then
                                        return function() return nil end
                                    end
                                end
                                return __namecall(self, ...)
                            end))
                            return __namecall
                        end)
                    end)
                end
            end
        },
        ["DisableKillerWalls"] = {
            ["DisplayDescription"] = "Disables Thin Killer Walls",
            ["DisplayTitle"] = "Disable Killer Walls",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["GetNearbyWalls"] = function(self, Selected)
                if not Selected or not GameMap then return {} end
                local Params = OverlapParams.new()
                Params.BruteForceAllSlow = true
                Params.IncludeInstances = {GameMap}
                local BoxSize = Selected.Size
                local Result = workspace:GetPartBoundsInBox(Selected.CFrame,Selected.Size,Params)
                local Walls = {}
                for i, v in Result do
                    if not(v == Selected or v.Parent.Name:find("Decoration") or v.CollisionGroup ~= "Killers" or v.Name:lower() == "inviisble") then
                        Walls[#Walls + 1] = v
                    end
                end
                return Walls
            end,
            ["GetNearbyDecoration"] = function(self, Selected)
                if not Selected or not GameMap or Selected.Name:lower() == "inviisble" then return {} end
                local Params = OverlapParams.new()
                Params.BruteForceAllSlow = true
                Params.IncludeInstances = GameMap:QueryDescendants("#KillerWallDetail,#KillerFrame")
                local Result = workspace:GetPartBoundsInBox(Selected.CFrame,Selected.Size,Params)
                local Decorations = {}
                for i, v in Result do
                    local MainDecoration = v:FindFirstAncestor("KillerWallDetail") or v:FindFirstAncestor("KillerFrame")
                    if MainDecoration and not table.find(Decorations, MainDecoration) then
                        table.insert(Decorations, MainDecoration)
                    end
                end
                return Decorations
            end,
            ["DefaultProperty"] = function(self,Object,Property)
                if not Object then return end
                if not Object:GetAttribute(Property) then
                    Object:SetAttribute(Property,Object[Property])
                end
            end,
            ["HandleDisableKillerWalls"] = function(self,MainValue,Tween)
                local function ColorBrightness(Color,Brightness)
                    local H, S, V = Color:ToHSV()
                    return Color3.fromHSV(H, S, math.clamp(V * Brightness, 0, 1))
                end
                if GameMap then
                    for i,v in GameMap:QueryDescendants("BasePart[CollisionGroup=Killers]") do
                        if math.min(v.Size.X,v.Size.Z) > 5 or (v.Size.Magnitude > 95 and #self:GetNearbyWalls(v) == 0) or v.Parent.Name:upper() == "GENERATOR" then continue end
                        self:DefaultProperty(v,"CanCollide")
                        self:DefaultProperty(v,"Color")
                        if not v:GetAttribute("WalkedThrough") then
                            v.CanTouch = true
                        end
                        local Value = not v:GetAttribute("WalkedThrough") and MainValue or false
                        local Color = Value and Color3.new(0,1,0) or v:GetAttribute("Color") or Color3.new(1,0,0)
                        local Mesh = v:FindFirstChildOfClass("SpecialMesh")
                        local NearbyDecorations = self:GetNearbyDecoration(v)
                        self:DefaultProperty(Mesh,"VertexColor")
                        local VertexColor = Value and Vector3.new(0,Mesh and Mesh.VertexColor.Magnitude or 255,0) or Mesh and Mesh:GetAttribute("VertexColor") or Vector3.new(255,0,0)
                        v.CanCollide = v:GetAttribute("CanCollide") ~= false and not Value or false
                        v.Color = Color
                        if Mesh then
                            Mesh.VertexColor = VertexColor
                        end
                        for i,SelectionBox:SelectionBox in v:QueryDescendants("> SelectionBox") do
                            self:DefaultProperty(SelectionBox,"Color3")
                            self:DefaultProperty(SelectionBox,"SurfaceColor3")
                            SelectionBox.Color3 = Value and Color or SelectionBox:GetAttribute("Color3")
                            SelectionBox.SurfaceColor3 = Value and Color or SelectionBox:GetAttribute("SurfaceColor3")
                        end
                        for i,v in NearbyDecorations do
                            for i,v2 in v:QueryDescendants("Texture") do
                                self:DefaultProperty(v2,"Color3")
                                v2.Color3 = Value and Color3.new(0,0,0) or v2:GetAttribute("Color3")
                            end
                            for i,v2 in v:QueryDescendants("ParticleEmitter") do
                                self:DefaultProperty(v2,"Color")
                                local H,S,V = v2.Color.Keypoints[1].Value:ToHSV()
                                v2.Color = (Value and ColorSequence.new(Color3.fromHSV(0.33, 1, V))) or v2:GetAttribute("Color")
                            end
                            if v:FindFirstChildOfClass("MeshPart") then
                                self:DefaultProperty(v:FindFirstChildOfClass("MeshPart"),"Color")
                                v:FindFirstChildOfClass("MeshPart").Color = Value and Color or v:FindFirstChildOfClass("MeshPart"):GetAttribute("Color")
                            end
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then
                    if GetValue("PrivateServer") then
                        self.Instance:SetAttribute("DisplayDescription",self.Instance:GetAttribute("DisplayDescription"):gsub("%s?<b>.-</b>", ""))
                    end
                end
                self:HandleDisableKillerWalls(Value)
            end,
            ["CharacterAdded"] = function(self)
                LocalRoot.CanTouch = true
                LocalRoot.Touched:Connect(function(Hit)
                    if Hit and Hit.Parent and Hit.CollisionGroup == "Killers" and Hit:IsDescendantOf(GameMap) and Hit.Name:lower() ~= "inviisble" and Hit:GetAttribute("WalkedThrough") == nil and Hit.CanQuery and Hit.Parent.Name:upper() ~= "GENERATOR" and GetValue("DisableKillerWalls") then
                        Hit:SetAttribute("WalkedThrough","Ignore")
                        local NearbyWalls = self:GetNearbyWalls(Hit)
                        for i,v in NearbyWalls do
                            v:SetAttribute("WalkedThrough","Ignore")
                        end
                        task.delay(0.3,function()
                            if Hit and Hit.Parent then
                                Hit:SetAttribute("WalkedThrough",true)
                                for i,v in NearbyWalls do
                                    v:SetAttribute("WalkedThrough",true)
                                end
                                task.wait()
                                self:HandleDisableKillerWalls(GetValue("DisableKillerWalls"),true)
                            end
                        end)
                        task.delay(4.5,function()
                            if Hit and Hit.Parent then
                                Hit:SetAttribute("WalkedThrough",nil)
                                for i,v in NearbyWalls do
                                    v:SetAttribute("WalkedThrough",nil)
                                end
                                task.wait()
                                self:HandleDisableKillerWalls(GetValue("DisableKillerWalls"),true)
                            end
                        end)
                    end
                end)
            end,
            ["CustomSetup"] = function(self)
                InGame.ChildAdded:Connect(function(Child)
                    if Child.Name == "Map" then
                        task.delay(2,self.HandleDisableKillerWalls,self,GetValue("DisableKillerWalls"))
                    end
                end)
            end
        },
        ["DisableToxicTrails"] = {
            ["DisplayDescription"] = "Disables damaging trails for john doe",
            ["DisplayTitle"] = "Disable <b>John Doe's</b> Trails",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:JohnDoe",
            ["ScriptFunction"] = function(self, Value)
                for i,v in InGame:GetChildren() do
                    if v:IsA("Folder") and (v.Name):find("JohnDoeTrail") then
                        for i,v2 in v:GetChildren() do
                            if v2:IsA("BasePart") then
                                v2.CanTouch = not Value
                            end
                        end
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                --self.DisplayTitle = self.DisplayTitle:gsub("John Doe's",RichTextGradientColor("John Doe's",{Color3.fromRGB(255, 190, 71), Color3.fromRGB(168, 3, 0),Color3.fromRGB(184, 171, 255)}))
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        if Child:IsA("Folder") and (Child.Name):find("JohnDoeTrail") then
                            task.wait()
                            for i,v in Child:GetChildren() do
                                if v:IsA("BasePart") then
                                    v.CanTouch = not GetValue("DisableToxicTrails")
                                end
                            end
                            if not Child:GetAttribute("Checked") then
                                Child:SetAttribute("Checked", true)
                                Child.ChildAdded:Connect(function(v)
                                    if v:IsA("BasePart") then
                                        v.CanTouch = not GetValue("DisableToxicTrails")
                                    end
                                end)
                            end
                        end
                    end)
                end
            end
        },
        ["DisableFootprints"] = {
            ["DisplayDescription"] = "Disables footprints made by john doe",
            ["DisplayTitle"] = "Disable <b>John Doe's</b> Footprints",
            ["LayoutOrder"] = 4,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:JohnDoe",
            ["ScriptFunction"] = function(self, Value)
                for i,v in InGame:GetChildren() do
                    if v:IsA("Folder") and (v.Name):find("Shadows") then
                        for i,v2 in v:GetChildren() do
                            if v2:IsA("BasePart") then
                                v2.CanTouch = not Value
                            end
                        end
                        if not v:GetAttribute("Checked") then
                            v:SetAttribute("Checked", true)
                            v.ChildAdded:Connect(function(GrandChild)
                                if GrandChild:IsA("BasePart") then
                                    GrandChild.CanTouch = not GetValue("DisableFootprints")
                                end
                            end)
                        end
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                --self.DisplayTitle = self.DisplayTitle:gsub("John Doe's",RichTextGradientColor("John Doe's",{Color3.fromRGB(255, 190, 71), Color3.fromRGB(168, 3, 0),Color3.fromRGB(184, 171, 255)}))
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        if Child:IsA("Folder") and (Child.Name):find("Shadows") then
                            task.wait()
                            for i,v in Child:GetChildren() do
                                if v:IsA("BasePart") then
                                    v.CanTouch = not GetValue("DisableFootprints")
                                end
                            end
                            if not Child:GetAttribute("Checked") then
                                Child:SetAttribute("Checked", true)
                                Child.ChildAdded:Connect(function(v)
                                    if v:IsA("BasePart") then
                                        v.CanTouch = not GetValue("DisableFootprints")
                                    end
                                end)
                            end
                        end
                    end)
                end
            end
        },
        ["SmallerSpikeCollisions"] = {
            ["DisplayDescription"] = "Makes spike collisions smaller for john doe's ability",
            ["DisplayTitle"] = "Smaller Spike Collisions",
            ["LayoutOrder"] = 5,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:JohnDoe",
            ["ScriptFunction"] = function(self, Value)
                for i,v in InGame:GetChildren() do
                    if v.Name == "SpikeCollision" then
                        v.Size = Value and Vector3.new(11,3.5,3.5) or Vector3.new(11, 5, 5)
                        v.Shape = Value and Enum.PartType.Cylinder or Enum.PartType.Block
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        if Child.Name == "SpikeCollision" then
                            task.delay(3.5,function()
                                Child.Size = GetValue("SmallerSpikeCollisions") and Vector3.new(11,3.5,3.5) or Vector3.new(11, 5, 5)
                                Child.Shape = GetValue("SmallerSpikeCollisions") and Enum.PartType.Cylinder or Enum.PartType.Block
                            end)
                        end
                    end)
                end
            end
        },
        ["EnableJumping"] = {
            ["DisplayDescription"] = "Enables Jumping for when its disabled",
            ["DisplayTitle"] = "Enable Jumping",
            ["LayoutOrder"] = 7,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["HandleAllowJumping"] = function(self,Value)
                if LocalHumanoid and not LocalHumanoid:GetAttribute("JumpingConnection") then
                    if Value then
                        if not LocalHumanoid:GetAttribute("JumpingConnection") then
                            LocalHumanoid:SetAttribute("JumpingConnection",LocalHumanoid.JumpPower)
                        else
                            return
                        end
                        local Connection;Connection = LocalHumanoid.StateChanged:Connect(function(old,new)
                            if LocalHumanoid.FloorMaterial == Enum.Material.Air then 
                                return
                            end
                            if not LocalCharacter.Parent.Name:lower():find("spectat") and new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall and LocalHumanoid.JumpPower > 0 and (GetValue("EnableJumping") or false) and not LocalHumanoid:GetAttribute("CDJump") then
                                if not(GetValue("EnableJumping")) then
                                    Connection:Disconnect()
                                    LocalHumanoid.JumpPower = LocalHumanoid:GetAttribute("JumpingConnection") or 0
                                    LocalHumanoid:SetAttribute("JumpingConnection",nil)
                                    return
                                end
                                LocalHumanoid:GetPropertyChangedSignal("FloorMaterial"):Wait()
                                if LocalHumanoid.FloorMaterial == Enum.Material.Air then
                                    LocalHumanoid.JumpPower = 0
                                else
                                    return
                                end
                                LocalHumanoid:SetAttribute("CDJump",true)
                                task.wait(1.25)
                                if GetValue("EnableJumping") then
                                    LocalHumanoid.JumpPower = 47
                                else
                                    Connection:Disconnect()
                                    LocalHumanoid.JumpPower = LocalHumanoid:GetAttribute("JumpingConnection") or 0
                                    LocalHumanoid:SetAttribute("JumpingConnection",nil)
                                end
                                LocalHumanoid:SetAttribute("CDJump",nil)
                            end
                        end)
                    end
                    LocalHumanoid.JumpPower = Value and 47 or 0
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                self:HandleAllowJumping(Value)
            end,
            ["CharacterAdded"] = function(self)
                task.delay(0.25,self.HandleAllowJumping,self,GetValue("EnableJumping"))
            end
        },
        ["StaminaPreset"] = {
            ["DisplayDescription"] = "Select a Stamina Preset",
            ["DisplayTitle"] = "Stamina Preset",
            ["LayoutOrder"] = 8,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Original",
            ["Requirement"] = "require",
            ["ExtraData"] = {
                ["Options"] = "Original|Realistic|Semi-Realistic|Infinite"
            },
            ["OnLoop"] = function()
                local StaminaPreset = GetValue("StaminaPreset")
                if StaminaPreset ~= "Original" and MainModule and MainModule.MaxStamina then
                    if StaminaPreset == "Infinite" then
                        rawset(MainModule, "Stamina", MainModule.MaxStamina)
                    else
                        local MaxStamina = MainModule.MaxStamina
                        if MainModule.Stamina < MaxStamina * 0.8 then
                            rawset(MainModule, "Stamina", math.min(MainModule.Stamina + MaxStamina * (StaminaPreset == "Semi-Realistic" and 0.005 or 0.0025), MaxStamina))
                        end
                    end
                end
            end,
            ["CharacterAdded"] = function(self)
                if TempUI then
                    task.spawn(function()
                        local AmountUI = (TempUI:FindFirstChild("PlayerInfo") or TempUI:WaitForChild("PlayerInfo")) and TempUI.PlayerInfo:FindFirstChild("Bars") and TempUI.PlayerInfo.Bars:FindFirstChild("Stamina") and TempUI.PlayerInfo.Bars.Stamina:FindFirstChild("Amount")
                        if AmountUI and MainModule then
                            local OriginalAmountUI = AmountUI
                            local InfiniteStaminaElement = OriginalAmountUI:Clone()
                            local CenterStaminaCounter = TempUI:FindFirstChild("CenterStaminaCounter")
                            local CenterDrainBar = TempUI:FindFirstChild("Drain")
                            if CenterStaminaCounter then
                                CenterStaminaCounter:SetAttribute("WasVisible", CenterStaminaCounter.Visible)
                                CenterStaminaCounter.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterStaminaCounter:GetAttribute("WasVisible")
                            end
                            if CenterDrainBar then
                                CenterDrainBar:SetAttribute("WasVisible", CenterDrainBar.Visible)
                                CenterDrainBar.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterDrainBar:GetAttribute("WasVisible")
                            end
                            InfiniteStaminaElement.Name = "InfiniteAmount"
                            InfiniteStaminaElement.Text = "∞"
                            InfiniteStaminaElement.Parent = OriginalAmountUI.Parent
                            InfiniteStaminaElement.Visible = GetValue("StaminaPreset") == "Infinite"
                            InfiniteStaminaElement.Size = UDim2.new(0.225,0,0.7,14)
                            OriginalAmountUI.Visible = GetValue("StaminaPreset") ~= "Infinite"
                            if not GetValue("StaminaPreset",true) then return end
                            local InfViewConnection;InfViewConnection = GetValue("StaminaPreset",true):GetPropertyChangedSignal("Value"):Connect(function()
                                if InfiniteStaminaElement and OriginalAmountUI then
                                    InfiniteStaminaElement.Visible = GetValue("StaminaPreset") == "Infinite"
                                    OriginalAmountUI.Visible = GetValue("StaminaPreset") ~= "Infinite"
                                    if CenterStaminaCounter then
                                        CenterStaminaCounter.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterStaminaCounter:GetAttribute("WasVisible")
                                    end
                                    if CenterDrainBar then
                                        CenterDrainBar.Visible = GetValue("StaminaPreset") ~= "Infinite" and CenterDrainBar:GetAttribute("WasVisible")
                                    end
                                else
                                    InfViewConnection:Disconnect()
                                end
                            end)
                            TempUI.Destroying:Once(function()
                                InfViewConnection:Disconnect()
                            end)
                        end
                    end)
                    for i,v in TempUI:QueryDescendants("#redFlash,#injuredVignette") do
                        v.Visible = not GetValue("HideInjury")
                    end
                end
            end
        },
        ["AntiSlowness"] = {
            ["DisplayDescription"] = "Removes all types of Slowness Effects",
            ["DisplayTitle"] = "Anti Slowness",
            ["LayoutOrder"] = 9,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Check"] = function(self,ValueInstance)
                if GetValue("AntiSlowness") then
                    if ValueInstance and ValueInstance.Name ~= "Sprinting" and ValueInstance.Name:lower() ~= "emoting" then
                        if ValueInstance.Name == "DirectionalMovement" or ValueInstance.Name == "FixingGenerator" or ValueInstance.Name:upper() == "ENRAGED" then
                            if ValueInstance.Value < 1 then
                                ValueInstance.Value = 1
                            end
                            ValueInstance:GetPropertyChangedSignal("Value"):Connect(function()
                                if ValueInstance.Value < 1 then
                                    ValueInstance.Value = 1
                                end
                            end)
                        elseif ValueInstance.Value > 0.03 and ValueInstance.Value < 1 then
                            ValueInstance:Destroy()
                        else
                            ValueInstance:GetPropertyChangedSignal("Value"):Connect(function()
                                if ValueInstance.Value > 0.03 and ValueInstance.Value < 1 then
                                    ValueInstance:Destroy()
                                end
                            end)
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self,Value)
                if not Value or not SpeedMultipliers then
                    return
                end
                for i,Child in SpeedMultipliers:GetChildren() do
                    self:Check(Child)
                end
            end,
            ["CharacterAdded"] = function(self)
                if SpeedMultipliers ~= nil and SpeedMultipliers.Parent ~= nil and typeof(SpeedMultipliers) == "Instance" then
                    SpeedMultipliers.ChildAdded:Connect(function(Child)
                        if not Child:IsA("NumberValue") or Child.Name == "Sprinting" or Child.Name:lower() == "emoting" then
                            return
                        end
                        self:Check(Child)
                    end)
                end
            end
        },
        ["AnimationChanger"] = {
            ["DisplayDescription"] = "Select a character/skin to override the animations",
            ["DisplayTitle"] = "Animation Changer",
            ["LayoutOrder"] = 10,
            ["Savable"] = false,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Original",
            ["Requirement"] = "require",
            ["ExtraData"] = {
                --["TemplateType"] = "Textbox", -- For testing animations
                ["StopOverride"] = false,
                ["Options"] = "Original|Jason|Jason IV|Slasher|Slasher IV|c00lkidd|c00lkidd IV|c0llabk1dd|John Doe|JohnDoe IV|Noli|Noli IV|1x1x1x1|1x1x1x1 IV|Nosferatu|Azure|Dusekkar|Civilian|Artful|Harken|Erlking|Herobrine|Medic|Sukuna|Retro|Gluttony|Gatito|Lovecore|Treachstone|Screamer|PH0NK1DD|Mafioso|Krystal|Pest|The Admin|Deceiver|VIP|Monster|Friend|The Pestilence|Celebration|P4rtyPwny|Content Creator|Narrator|Devesto|Alfred Drevis|Killer Kyle|Pursuer|TV TIME|c00lskeleton95|dragondudes3|Heaven Executioner|Timeless|Eye of The Abyss|White Pumpkin|Nerfed Demoman|Voidbound test|Sniper|Little Guy|Crouch|NPC Zombie|Default Roblox"
            },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then return end
                if Value == "Original" or self.Instance:GetAttribute("StopOverride") then
                    GetValue("ChangeInLobby",true).Value = Value ~= "Original"
                    if LocalAnimator then
                        local AllTracks = LocalAnimator:GetPlayingAnimationTracks()
                        for i,v in AllTracks do
                            v:Stop(0)
                        end
                    end
                    if LastAnimOriginalUsed then
                        LastAnimOriginalUsed:Play(0)
                    end
                else
                    if LocalAnimator and CanPlayOverrideAnim(LocalCharacter) then
                        local AllTracks = LocalAnimator:GetPlayingAnimationTracks()
                        for i,v in AllTracks do
                            v:Stop(0)
                        end
                        UpdateAnim(LocalHumanoid)
                    end
                end
            end,
            ["CharacterAdded"] = function(self)
                local SupportedOverrides = {"idle","walk","run"}
                OverriddenAnimations = {}
                if not LocalAnimator then return end
                LastAnimOriginalUsed = LocalAnimator:GetPlayingAnimationTracks()[1]
                SpeedMultipliers.ChildAdded:Connect(function(Speed)
                    if Speed.Name == "Emoting" and CanPlayOverrideAnim(LocalCharacter) then
                        self.Instance:SetAttribute("StopOverride",true)
                        self:ScriptFunction(self.Instance.Value)
                    end
                end)
                SpeedMultipliers.ChildRemoved:Connect(function(Speed)
                    if Speed.Name == "Emoting" and self.Instance.Value ~= "Original" then
                        self.Instance:SetAttribute("StopOverride",false)
                        self:ScriptFunction(self.Instance.Value)
                    end
                end)
                LocalAnimator.AnimationPlayed:Connect(function(Track)
                    if CanPlayOverrideAnim(LocalCharacter) and MainModule then
                        local Override = Track.Animation:GetAttribute("Overriden")
                        LastAnimOriginalUsed = not Override and Track or LastAnimOriginalUsed
                        local AnimType,CharName = GetAnimationType(tonumber(Track.Animation.AnimationId:match("%d+")))
                        if not Override then
                            for i,v in SupportedOverrides do
                                if AnimType and AnimType:lower():find(v:lower()) then
                                    Track:Stop(0)
                                elseif not AnimType and Track.Looped then
                                    Track:Stop(0)
                                end
                            end
                        end
                        local FoundAction = false
                        for i,v in LocalAnimator:GetPlayingAnimationTracks() do
                            task.spawn(function()
                                local AnimType,Char,Name = GetAnimationType(v.Animation.AnimationId)
                                local IsSupported = false
                                for i,v in SupportedOverrides do
                                    if AnimType and AnimType:lower():find(v:lower()) then
                                        IsSupported = true
                                    end
                                end
                                if v.IsPlaying and not IsSupported and not v:GetAttribute("Ignored") then
                                    FoundAction = v
                                end
                            end)
                        end
                        if FoundAction and Override then
                            Track:Stop(0.2)
                            task.wait(not FoundAction.Looped and FoundAction.Length * 0.95 or 0)
                            if FoundAction.Looped then
                                FoundAction.Stopped:Wait()
                            end
                            FoundAction:SetAttribute("Ignored",true)
                            task.delay(0.2,function()
                                FoundAction:SetAttribute("Ignored",nil)
                            end)
                            UpdateAnim(LocalHumanoid)
                        end
                    end
                end)
                local MoreThanZero = 0
                LocalHumanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                    if GetValue("AnimationChanger") ~= "Original" and MoreThanZero ~= (LocalHumanoid.MoveDirection.Magnitude == 0) then
                        MoreThanZero = (LocalHumanoid.MoveDirection.Magnitude == 0)
                        UpdateAnim(LocalHumanoid)
                    end
                end)
                task.delay(0.05,UpdateAnim,LocalHumanoid)
            end,
            ["CustomSetup"] = function(self)
                local function StartSprintDetection()
                    repeat task.wait(0.1) until MainModule["__sprintedEvent"]
                    MainModule["__sprintedEvent"].Event:Connect(function()
                        if GetValue("AnimationChanger") ~= "Original" then
                            UpdateAnim(LocalHumanoid)
                        end
                    end)
                    MainModule["__sprintedEvent"].Destroying:Once(function()
                        StartSprintDetection()
                    end)
                end
                if MainModule then
                    task.spawn(StartSprintDetection)
                end
            end
        },
        ["ChangeInLobby"] = {
            ["DisplayDescription"] = "If it should change the animation in the lobby too",
            ["DisplayTitle"] = "Change In Lobby",
            ["LayoutOrder"] = 12,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "AnimationChanger~Original",
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then return end
                local CanPlay = CanPlayOverrideAnim(LocalCharacter)
                if Value == true then
                    UpdateAnim(LocalHumanoid)
                else
                    if LocalAnimator then
                        local AllTracks = LocalAnimator:GetPlayingAnimationTracks()
                        for i,v in AllTracks do
                            v:Stop(0)
                        end
                        if LastAnimOriginalUsed then
                            LastAnimOriginalUsed:Play(0)
                        end
                        UpdateAnim(LocalHumanoid)
                    end
                end
            end
        },
        ["NoliControl"] = {
            ["DisplayDescription"] = "Allows you to have better control of Void Rush Ability",
            ["DisplayTitle"] = "Better Void Rush",
            ["LayoutOrder"] = 13,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Noli|require",
            ["ScriptFunction"] = function(self, Value, Starting)
                if not Value and Starting then return end
                if NoliConfig then
                    for i, Entry in {
                        {Name = "InitialTurnDuration", Value = 0.005, Default = 1.5},
                        {Name = "TurnSpeed", Value = 10000, Default = 1},
                        {Name = "InitialTurnMult", Value = 1000, Default = 6.6},
                    } do
                        local CurrentValue, Key, Parent = TableValueFind(NoliConfig, function(i, v) return type(i) == "string" and i:find(Entry.Name) and not i:find(Entry.Name .. "OG") end)
                        if Key and Parent then
                            if Value then
                                if not Parent[Key .. "OG"] then
                                    Parent[Key .. "OG"] = Parent[Key]
                                end
                                Parent[Key] = Entry.Value
                            else
                                Parent[Key] = Parent[Key .. "OG"] or Entry.Default
                            end
                        end
                    end
                    if LocalCharacter and LocalCharacter.Parent.Name == "Killers" and not workspace:GetAttribute("NotifCD") then
                        StarterGui:SetCore("SendNotification", {
                            Title = "Information",
                            Text = "Changes only apply the time you become the killer",
                            Duration = 5
                        })
                        workspace:SetAttribute("NotifCD", true)
                        task.delay(10, function()
                            workspace:SetAttribute("NotifCD", nil)
                        end)
                    end
                elseif not NoliConfig and not Starting then
                    self.Instance:SetAttribute("Requirement",true)
                    StarterGui:SetCore("SendNotification", {
                        Title = "Information",
                        Text = `Failed to find Noli's Config Module{GetValue("OfficialGame") and ". Please Report This issue!" or ""}`,
                        Duration = GetValue("OfficialGame") and 12 or 7
                    })
                end
            end
        },
        ["ControllableDash"] = {
            ["DisplayDescription"] = "Allows you to control where the dash goes just like Void Rush Ability",
            ["DisplayTitle"] = "Make Coolkidd's Dash Controllable",
            ["LayoutOrder"] = 14,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["Requirement"] = "Killer:c00lkidd",
            ["DefaultInstanceValue"] = false,
            ["ExtraData"] = {
                ["Responsiveness"] = 100,
            },
            ["CharacterAdded"] = function(self)
                LocalRoot.ChildAdded:Connect(function(Child:LinearVelocity?)
                    if Child:IsA("LinearVelocity") and LocalHumanoid and LocalCharacter.Parent.Name:lower():find("killer") and LocalCharacter.Name:lower():find("lkid") then
                        local OriginalVelocity = Child.LineDirection
                        local OriginalVelocityMag = Child.LineDirection.Magnitude
                        for i,v in SpeedMultipliers:GetChildren() do
                            if v.Name == "HinderedMovement" and GetValue("ControllableDash") and v.Value == 0 then
                                v.Value = 0.005
                            end
                        end
                        local function UpdateVelocity(Start)
                            if GetValue("ControllableDash") and (LocalCharacter.Name:gsub("0","O"):lower():find("coolkid")) and LocalHumanoid.MoveDirection ~= Vector3.zero then
                                Child.LineDirection = Child.LineDirection:Lerp(LocalHumanoid.MoveDirection * OriginalVelocityMag,self.Instance:GetAttribute("Responsiveness")/1000)
                            elseif GetValue("ControllableDash") and (LocalCharacter.Name:gsub("0","O"):lower():find("coolkid")) and workspace.CurrentCamera then
                                local CameraDirection = Vector3.new(workspace.CurrentCamera.CFrame.LookVector.X, 0, workspace.CurrentCamera.CFrame.LookVector.Z)
                                Child.LineDirection = Child.LineDirection:Lerp(CameraDirection.Unit * OriginalVelocityMag,self.Instance:GetAttribute("Responsiveness")/1000)
                                if Child.LineVelocity > 0 or Start then
                                    LocalRoot.CFrame = LocalRoot.CFrame:Lerp(CFrame.lookAt(LocalRoot.Position, LocalRoot.Position + CameraDirection),Start and 1 or 0.05)
                                end
                            else
                                Child.LineDirection = OriginalVelocity
                            end
                        end
                        UpdateVelocity()
                        local Connection1;Connection1 = LocalHumanoid:GetPropertyChangedSignal("MoveDirection"):Connect(UpdateVelocity)
                        local Connection2;Connection2 = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):Connect(UpdateVelocity)
                        Child.Destroying:Once(function()
                            if Connection1 then
                                Connection1:Disconnect()
                                Connection1 = nil
                            end
                            if Connection2 then
                                Connection2:Disconnect()
                                Connection2 = nil
                            end
                        end)
                    end
                end)
            end
        },
        ["AutoBlock"] = {
            ["DisplayDescription"] = "Uses the block ability automatically when about to get hit (REQUIRES GOOD PING)",
            ["DisplayTitle"] = '<stroke thickness="0.7">Guest1337</stroke> Auto Block',
            ["LayoutOrder"] = 15,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:Guest1337|require",
            ["ScriptFunction"] = function(self, Value)
                local BlockAbilityUI = MainUI and MainUI:FindFirstChild("AbilityContainer") and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Block")
                local AutoImage = BlockAbilityUI and BlockAbilityUI:FindFirstChild("AutoImage")
                if Value and AutoImage then
                    AutoImage.Visible = true
                elseif AutoImage then
                    AutoImage.Visible = false
                end
            end,
            ["HandleKiller"] = function(self,Killer)
                local BlockableAttacks = {"slash","enragedslash","stab","attack","punch",--[["behead",]]"swing","golemslash"}
                local CustomHitboxes = {
                    ["golemslash"] = {
                        Size = Vector3.new(6, 2, 7),
                        Offset = CFrame.new(0,0,-5.5)
                    },
                }
                local FireSignal = GetFunction(firesignal,FireSignal)
                local SelfParams = OverlapParams.new()
                SelfParams.MaxParts = 1
                SelfParams.BruteForceAllSlow = true
                local UseActorAbility = Network and Network:FindFirstChildOfClass("RemoteEvent")
                local ShowHitboxesSetting = PlayerData and PlayerData:FindFirstChild("Settings") and PlayerData.Settings:FindFirstChild("ShowHitboxes",true)
                local Humanoid = Killer:FindFirstChildOfClass("Humanoid") or Killer:WaitForChild("Humanoid")
                local QueryHitbox = Killer:FindFirstChild("QueryHitbox") or Killer:WaitForChild("QueryHitbox")
                local KillerAnimator = Humanoid:FindFirstChildOfClass("Animator")
                if KillerAnimator then
                    KillerAnimator.AnimationPlayed:Connect(function(Track)
                        if GetValue("AutoBlock") and Players:GetPlayerFromCharacter(Killer) then
                            local AnimType,KillerName = GetAnimationType(Track.Animation.AnimationId)
                            if AnimType and type(AnimType) == type("") and table.find(BlockableAttacks,AnimType:lower()) and LocalCharacter and LocalCharacter:FindFirstChild("QueryHitbox") and LocalCharacter.Parent == SurvivorsFolder and MainUI:FindFirstChild("AbilityContainer") and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Block") then
                                local CustomHitbox = CustomHitboxes[AnimType:lower()] or CustomHitboxes[Killer.Name:lower()]
                                for i = 1,12 do
                                    SelfParams.IncludeInstances = {LocalCharacter:FindFirstChild("QueryHitbox")}
                                    local Part = Instance.new("Part")
                                    Part.Name = "KillerDetectHitbox"
                                    Part.Color = BrickColor.new("Really black").Color
                                    Part.Size =  (CustomHitbox and CustomHitbox["Size"] or Vector3.new(5.2, 6, 5.65)) * 2.2
                                    Part.CFrame = QueryHitbox.CFrame * (CustomHitbox and CustomHitbox["Offset"] or CFrame.new(0,0,-3.5))
                                    Part.CanCollide = false
                                    Part.Anchored = true
                                    Part.CastShadow = false
                                    Part.Material = Enum.Material.ForceField
                                    Part.Transparency = ShowHitboxesSetting.Value and 0.1 or 1
                                    Part.Parent = Hitboxes
                                    Debris:AddItem(Part,0.4)
                                    local Hitbox = workspace:GetPartBoundsInBox(Part.CFrame,Part.Size,SelfParams)
                                    LogService:Info("HitboxCheck",Hitbox)
                                    if #Hitbox > 0 then
                                        if FireSignal and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Block") then
                                            FireSignal(MainUI.AbilityContainer.Block.MouseButton1Down)
                                            FireSignal(MainUI.AbilityContainer.Block.MouseButton1Click)
                                            break
                                        end
                                        if GetValue("OfficialGame") then
                                            UseActorAbility:FireServer("UseActorAbility",{"Block"})
                                        else
                                            UseActorAbility:FireServer("UseActorAbility","Block")
                                            UseActorAbility:FireServer("UseActorAbility",{"Block"})
                                        end
                                        break
                                    end
                                    task.wait(0.02)
                                end
                            end
                        end
                    end)
                end
            end,
            ["SetupUI"] = function(AbilityContainer)
                if AbilityContainer.Name == "AbilityContainer" then
                    if AbilityContainer:FindFirstChild("Block") and not AbilityContainer:FindFirstChild("Block"):FindFirstChild("AutoImage") then
                        local AutoImage = Instance.new("ImageLabel")
                        AutoImage.Name = "AutoImage"
                        AutoImage.Interactable = false
                        AutoImage.Parent = AbilityContainer:FindFirstChild("Block")
                        AutoImage.Image = "rbxassetid://114159864966636"
                        AutoImage.BackgroundTransparency = 1
                        AutoImage.Size = UDim2.fromScale(0.8,0.8)
                        AutoImage.Position = UDim2.fromScale(0.5,0)
                        AutoImage.AnchorPoint = Vector2.new(0.5,0.4)
                        AutoImage.Visible = GetValue("AutoBlock") and LocalCharacter.Parent.Name:find("Survi")
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("Guest1337",RichTextGradientColor("Guest1337",{Color3.fromRGB(16, 47, 185), Color3.fromRGB(146, 202, 93)}))
                if MainUI:FindFirstChild("AbilityContainer") then
                    self:SetupUI(MainUI:FindFirstChild("AbilityContainer"))
                end
                MainUI.ChildAdded:Connect(self.SetupUI)
                if KillersFolder then
                    KillersFolder.ChildAdded:Connect(function(Killer)
                        self:HandleKiller(Killer)
                    end)
                    for i,Killer in KillersFolder:GetChildren() do self:HandleKiller(Killer) end
                end
            end
        },
        ["AutoPunch"] = {
            ["DisplayDescription"] = "Uses the punch ability when you block successfully",
            ["DisplayTitle"] = '<stroke thickness="0.7">Guest1337</stroke> Auto Punch',
            ["LayoutOrder"] = 16,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:Guest1337",
            ["ExtraData"] = {
                ["Accuracy"] = 80
            },
            ["ScriptFunction"] = function(self, Value)
                local BlockAbilityUI = MainUI and MainUI:FindFirstChild("AbilityContainer") and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Punch")
                local AutoImage = BlockAbilityUI and BlockAbilityUI:FindFirstChild("AutoImage")
                if Value and AutoImage and LocalCharacter.Name:lower():find("guest") then
                    AutoImage.Visible = true
                elseif AutoImage then
                    AutoImage.Visible = false
                end
            end,
            ["SetupUI"] = function(AbilityContainer)
                if AbilityContainer.Name == "AbilityContainer" then
                    if AbilityContainer:FindFirstChild("Punch") and not AbilityContainer:FindFirstChild("Punch"):FindFirstChild("AutoImage") then
                        local AutoImage = Instance.new("ImageLabel")
                        AutoImage.Name = "AutoImage"
                        AutoImage.Interactable = false
                        AutoImage.Parent = AbilityContainer:FindFirstChild("Punch")
                        AutoImage.Image = "rbxassetid://114159864966636"
                        AutoImage.BackgroundTransparency = 1
                        AutoImage.Size = UDim2.fromScale(0.8,0.8)
                        AutoImage.Position = UDim2.fromScale(0.5,0)
                        AutoImage.AnchorPoint = Vector2.new(0.5,0.4)
                        AutoImage.Visible = GetValue("AutoPunch") and LocalCharacter.Parent.Name:find("Survi") and LocalCharacter.Name:lower():find("guest")
                    end
                end
            end,
            ["GetClosestKiller"] = function(self,Distance)
                Distance = Distance or 55
                local SelectedKiller
                for i,v in KillersFolder:GetChildren() do
                    if Players:GetPlayerFromCharacter(v) and LocalRoot and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and (v:FindFirstChild("HumanoidRootPart").Position - LocalRoot.Position).Magnitude < Distance then
                        Distance = (v:FindFirstChild("HumanoidRootPart").Position - LocalRoot.Position).Magnitude
                        SelectedKiller = v
                    end
                end
                return SelectedKiller,Distance
            end,
            ["CharacterAdded"] = function(self)
                local FireSignal = GetFunction(firesignal,FireSignal)
                local UseActorAbility = Network and Network:FindFirstChildOfClass("RemoteEvent")
                if not LocalHumanoid then return warn("no humanoid found") end
                LocalCharacter:GetAttributeChangedSignal("TimesHit"):Connect(function()
                    if GetValue("AutoPunch") and SpeedMultipliers:FindFirstChild("GuestBlocking") and LocalHumanoid:GetAttribute("Overheal") ~= nil and LocalHumanoid:GetAttribute("Overheal") >= 10 and (self:GetClosestKiller()) then
                        task.wait(0.08)
                        LocalCharacter:SetAttribute("DisableShiftLockMovement",true)
                        if FireSignal and MainUI:FindFirstChild("AbilityContainer"):FindFirstChild("Punch") then
                            FireSignal(MainUI.AbilityContainer.Punch.MouseButton1Down)
                            FireSignal(MainUI.AbilityContainer.Punch.MouseButton1Click)
                        else
                            if GetValue("OfficialGame") then
                                UseActorAbility:FireServer("UseActorAbility",{"Punch"})
                            else
                                UseActorAbility:FireServer("UseActorAbility","Punch")
                                UseActorAbility:FireServer("UseActorAbility",{"Punch"})
                            end
                        end
                        local Timeout = workspace.DistributedGameTime + 1.25
                        local CameraTarget 
                        local SelectedVelocity
                        CameraTarget = RunService.RenderStepped:Connect(function()
                            local ClosestKiller,Dis = self:GetClosestKiller()
                            if not ClosestKiller or not ClosestKiller:FindFirstChild("HumanoidRootPart") then return end
                            local KillerRootPos = ClosestKiller:FindFirstChild("HumanoidRootPart").Position
                            local SelectedPosition = Vector3.new(KillerRootPos.X,LocalRoot.Position.Y,KillerRootPos.Z)
                            local TargetCFrame = CFrame.new(LocalRoot.Position, SelectedPosition)
                            LocalCharacter:SetPrimaryPartCFrame(TargetCFrame)
                            if not SelectedVelocity then
                                LocalRoot.Velocity = TargetCFrame.LookVector * 32
                                SelectedVelocity = LocalRoot.Velocity
                            else
                                SelectedVelocity = LocalRoot.Velocity:Lerp(SelectedVelocity or LocalRoot.Velocity,GetValue("AutoPunch",true):GetAttribute("Accuracy")/100)
                                LocalRoot.Velocity = SelectedVelocity
                            end
                        end)
                        repeat
                            task.wait(0.1)
                        until FOVMultipliers:FindFirstChild("HitRegistered") or not SpeedMultipliers:FindFirstChild("PunchAbility") or workspace.DistributedGameTime > Timeout
                        CameraTarget:Disconnect()
                        task.wait(0.2)
                        LocalCharacter:SetAttribute("DisableShiftLockMovement",false)
                    end
                end)
            end,
            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("Guest1337",RichTextGradientColor("Guest1337",{Color3.fromRGB(16, 47, 185), Color3.fromRGB(146, 202, 93)}))
                if MainUI:FindFirstChild("AbilityContainer") then
                    self:SetupUI(MainUI:FindFirstChild("AbilityContainer"))
                end
                MainUI.ChildAdded:Connect(self.SetupUI)
            end
        },
        ["EnableOverride"] = {
            ["DisplayDescription"] = "Overrides the puzzle grid size of the generators",
            ["DisplayTitle"] = "Override Generator(s) Grid Size",
            ["LayoutOrder"] = 17,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "require",
            ["CustomSetup"] = function(self)
                if not (GetValue("require") and FlowGame and FlowGame.Name == "FlowGame") then
                    self.Requirement = true
                end
            end
        },
        ["GridSize"] = {
            ["DisplayDescription"] = "The Size to override for the Generator's Puzzle",
            ["DisplayTitle"] = "Generator(s) Grid Size",
            ["LayoutOrder"] = 18,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 6,
            ["Requirement"] = "require|EnableOverride",
            ["ExtraData"] = {
                ["MaxValue"] = 12,
                ["MinValue"] = 4,
                ["Step"] = 1,
            },
            ["HandlePuzzle"] = function(Data)
                PuzzleData = {}
                local function GetDirection(Row1,Col1,Row2,Col2)
                    if Row2 < Row1 then
                        return "up"
                    end
                    if Row2 > Row1 then
                        return "down"
                    end
                    if Col2 < Col1 then
                        return "left"
                    end
                    if Col2 > Col1 then
                        return "right"
                    end
                end
                local function GetPuzzleConnections(Last, New, Next)
                    local Connections = {}
                    if Last and New then
                        local Direction = GetDirection(New.row, New.col, Last.row, Last.col)
                        if Direction == "up" then
                            Direction = "down"
                        elseif Direction == "down" then
                            Direction = "up"
                        elseif Direction == "left" then
                            Direction = "right"
                        elseif Direction == "right" then
                            Direction = "left"
                        end
                        if Direction ~= "" and Direction then
                            Connections[Direction] = true
                        end
                    end
                    if Next and New then
                        local Direction = GetDirection(New.row, New.col, Next.row, Next.col)
                        if Direction ~= "" and Direction then
                            Connections[Direction] = true
                        end
                    end
                    return Connections
                end
                local function NearbyDirection(Row1, Col1, Row2, Col2)
                    if Row2 == Row1 - 1 and Col2 == Col1 then
                        return "up"
                    end
                    if Row2 == Row1 + 1 and Col2 == Col1 then
                        return "down"
                    end
                    if Row2 == Row1 and Col2 == Col1 - 1 then
                        return "left"
                    end
                    if Row2 == Row1 and Col2 == Col1 + 1 then
                        return "right"
                    end
                    return false
                end
                local function GetPlaceKey(Point)
                    return `{Point.row}-{Point.col}`
                end
                local function PathEndpoints(Path, endpoints)
                    if not Path or #Path == 0 then
                        return Path
                    end
                    local UniquePoint
                    for i, Point in endpoints or {} do
                        for i, v in Path do
                            if v.row == Point.row and v.col == Point.col then
                                UniquePoint = {row = Point.row,col = Point.col}
                                break
                            end
                        end
                        if UniquePoint then
                            break
                        end
                    end
                    if not UniquePoint then
                        local PointsInPath = {}
                        for i, Point in Path do
                            local TableKey = GetPlaceKey(Point)
                            PointsInPath[TableKey] = Point
                        end
                        for i, Point in Path do
                            local Nearby = 0
                            local Directions = {{Point.row - 1,Point.col}, {Point.row + 1,Point.col},{Point.row,Point.col - 1}, {Point.row,Point.col + 1}}
                            for i, Data in Directions do
                                local Row = Data[1]
                                local Col = Data[2]
                                local TableKey = `{Row}-{Col}`
                                if PointsInPath[TableKey] ~= nil then
                                    Nearby += 1
                                end
                            end
                            if Nearby == 1 then
                                UniquePoint = {row = Point.row,col = Point.col}
                                break
                            end
                        end
                    end
                    if not UniquePoint then
                        UniquePoint = {row = Path[1].row,col = Path[1].col}
                    end
                    local Remaining = {}
                    for i,Point in Path do
                        local TableKey = GetPlaceKey(Point)
                        local CurrentTableKey = {row = Point.row,col = Point.col}
                        Remaining[TableKey] = CurrentTableKey
                    end
                    local Ordered = {}
                    local CurrentTableKey = {row = UniquePoint.row,col = UniquePoint.col}
                    local ClonedTable = table.clone(CurrentTableKey)
                    setmetatable(ClonedTable, nil)
                    table.insert(Ordered, ClonedTable)
                    local TableKey = GetPlaceKey(CurrentTableKey)
                    Remaining[TableKey] = nil
                    while true do
                        local Size = 0
                        for i in Remaining do
                            Size += 1
                        end
                        if not (Size > 0) then
                            break
                        end
                        local foundNext = false
                        for key, Point in Remaining do
                            local Direction = NearbyDirection(CurrentTableKey.row,CurrentTableKey.col,Point.row,Point.col)
                            if Direction ~= "" and Direction then
                                local ClonedPoint = table.clone(Point)
                                setmetatable(ClonedPoint, nil)
                                table.insert(Ordered, ClonedPoint)
                                Remaining[key] = nil
                                CurrentTableKey = Point
                                foundNext = true
                                break
                            end
                        end
                        if not foundNext then
                            return Path
                        end
                    end
                    return Ordered
                end
                local function ActivatePuzzlePathfind(self, Puzzle, UI)
                    if not Puzzle or not Puzzle.Solution then
                        return nil
                    end
                    local TotalPaths = #Puzzle.Solution
                    local PuzzlePoints = {}
                    local CanIncrease = false
                    for i = 1,TotalPaths do
                        table.insert(PuzzlePoints, i)
                    end
                    for i = #PuzzlePoints-1, 2, -1 do
                        local RandomChoice = math.random(1,i)
                        local Temp = PuzzlePoints[i+1]
                        PuzzlePoints[i+1] = PuzzlePoints[RandomChoice+1]
                        PuzzlePoints[RandomChoice+1] = Temp
                    end
                    local IsActiveConnection
                    local function Restart()
                        if not GetValue("AutoGeneratorPuzzle") then return end
                        for i, Color in PuzzlePoints do
                            local Path = Puzzle.Solution[Color]
                            local endpoints = Puzzle.targetPairs[Color]
                            local CompletePath = PathEndpoints(Path, endpoints)
                            Puzzle.paths[Color] = {}
                            for i = 0, #CompletePath - 1 do
                                local Point = CompletePath[i + 1]
                                local ColorData = Puzzle.paths[Color]
                                local TableKey = {row = Point.row,col = Point.col}
                                table.insert(ColorData,TableKey)
                                local Last = CompletePath[i]
                                local Next = CompletePath[i + 2]
                                local PuzzleConnections = GetPuzzleConnections(Last, Point, Next)
                                Puzzle.gridConnections = Puzzle.gridConnections or {}
                                Puzzle.gridConnections[`{Point.row}-{Point.col}`] = PuzzleConnections
                                 if not GetValue("AutoGeneratorPuzzle") then
                                    break
                                elseif not UI or not UI.Parent then
                                    IsActiveConnection:Disconnect()
                                    break
                                end
                                Puzzle:updateGui()
                                task.wait(GetValue("GeneratorCooldown",true):GetAttribute("CurrentSpeed"))
                                if not GetValue("AutoGeneratorPuzzle") then
                                    break
                                elseif not UI or not UI.Parent then
                                    IsActiveConnection:Disconnect()
                                    break
                                end
                            end
                            if not GetValue("AutoGeneratorPuzzle") then
                                break
                            elseif not UI or not UI.Parent then
                                IsActiveConnection:Disconnect()
                                break
                            end
                            Puzzle:checkForWin()
                        end
                    end
                    IsActiveConnection = GetValue("AutoGeneratorPuzzle",true):GetPropertyChangedSignal("Value"):Connect(Restart)
                    Restart()
                end
                ActivatePuzzlePathfind(PuzzleData,Data[1],Data[2])
            end,
            ["CustomSetup"] = function(self)
                if GetValue("require") and FlowGame and FlowGame.Name == "FlowGame" then
                    if FlowGame:FindFirstChild("Settings") then
                        local SettingsModule = require(FlowGame:FindFirstChild("Settings"))
                        self.DefaultInstanceValue = SettingsModule and SettingsModule.DefaultGridSize or self.DefaultInstanceValue
                    end
                    local FlowGameFunctions = require(FlowGame)
                    local Original = FlowGameFunctions.new
                    function FlowGameFunctions.new(...)
                        local Args = {...}
                        if type(Args[2]) == type(0) or not Args[2] then
                            Args[2] = GetValue("EnableOverride") and GetValue("GridSize") or Args[2]
                            GetValue("GeneratorCooldown",true):SetAttribute("CurrentGrid",Args[2])
                            local Result = {Original(table.unpack(Args))}
                            task.delay(0.35,self.HandlePuzzle,{Result[1],Args[1]})
                            return Result[1]
                        else
                            self.Requirement = true
                            return Original(table.unpack(Args))
                        end
                    end
                else
                    self.Requirement = true
                end
            end
        },
        ["AutoHatchet"] = {
            ["DisplayDescription"] = "Uses the hatchet ability when a killer is near you",
            ["DisplayTitle"] = '<stroke thickness="0.7">Jane Doe</stroke> Auto Hatchet',
            ["LayoutOrder"] = 19,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:JaneDoe",
            ["Levels"] = ReplicatedStorage:FindFirstChild("Resonance",true) and ReplicatedStorage:FindFirstChild("Resonance",true):FindFirstChild("ParticleHolder",true),
            ["AbilityNames"] = {"Hatchet","Axe"},
            ["ExtraData"] = {
                ["Accuracy"] = 80,
                ["Range"] = 13
            },
            ["ScriptFunction"] = function(self, Value)
                local BlockAbilityUI = MainUI and MainUI:FindFirstChild("AbilityContainer")
                if not BlockAbilityUI then return end
                for i,v in BlockAbilityUI:GetChildren() do
                    if table.find(self.AbilityNames,v.Name) then
                       BlockAbilityUI = v
                    end
                end
                local AutoImage = BlockAbilityUI and BlockAbilityUI:FindFirstChild("AutoImage")
                if Value and AutoImage and LocalCharacter.Name:lower():find("jane") then
                    AutoImage.Visible = true
                elseif AutoImage then
                    AutoImage.Visible = false
                end
            end,
            ["SetupUI"] = function(self,AbilityContainer)
                if AbilityContainer.Name == "AbilityContainer" then
                    local Found
                    for i,v in AbilityContainer:GetChildren() do
                        if table.find(self.AbilityNames,v.Name) then
                            Found = v
                        end
                    end
                    if Found and not Found:FindFirstChild("AutoImage") then
                        local AutoImage = Instance.new("ImageLabel")
                        AutoImage.Name = "AutoImage"
                        AutoImage.Interactable = false
                        AutoImage.Parent = Found
                        AutoImage.Image = "rbxassetid://114159864966636"
                        AutoImage.BackgroundTransparency = 1
                        AutoImage.Size = UDim2.fromScale(0.8,0.8)
                        AutoImage.Position = UDim2.fromScale(0.5,0)
                        AutoImage.AnchorPoint = Vector2.new(0.5,0.4)
                        AutoImage.Visible = GetValue("AutoHatchet") and LocalCharacter.Parent.Name:find("Survi") and LocalCharacter.Name:lower():find("jane")
                    end
                end
            end,
            ["GetCharacterLevel"] = function(self, Character)
                if not Character then return 0 end
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local RootPart = Character:FindFirstChild("HumanoidRootPart") or Humanoid and Humanoid.RootPart
                if not RootPart or not self.Levels then return 0 end
                local Level = 0
                for i, Attachment in self.Levels:GetChildren() do
                    if Attachment:IsA("Attachment") then
                        local Number = tonumber(Attachment.Name:match("%d+"))
                        if Number and Number > Level then
                            local Matches = true
                            for i2, Effect in Attachment:GetChildren() do
                                if not RootPart:FindFirstChild(Effect.Name) then
                                    Matches = false
                                    break
                                end
                            end
                            if Matches then
                                Level = Number
                            end
                        end
                    end
                end
                return Level
            end,
            ["GetClosestKiller"] = function(self,Distance)
                Distance = Distance or 55
                local SelectedKiller
                for i,v in KillersFolder:GetChildren() do
                    if Players:GetPlayerFromCharacter(v) and LocalRoot and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and (v:FindFirstChild("HumanoidRootPart").Position - LocalRoot.Position).Magnitude < Distance then
                        Distance = (v:FindFirstChild("HumanoidRootPart").Position - LocalRoot.Position).Magnitude
                        SelectedKiller = v
                    end
                end
                return SelectedKiller,Distance
            end,
            ["OnLoop"] = function(self)
                local FireSignal = GetFunction(firesignal,FireSignal)
                local UseActorAbility = Network and Network:FindFirstChildOfClass("RemoteEvent")
                local AbilityContainer = MainUI and MainUI:FindFirstChild("AbilityContainer")
                local Ability
                if not AbilityContainer then return end
                for i,v in AbilityContainer:GetChildren() do
                    if table.find(self.AbilityNames,v.Name) then
                        Ability = v
                    end
                end
                if not LocalHumanoid or not LocalCharacter or LocalCharacter:GetAttribute("DisableShiftLockMovement") or LocalCharacter:GetAttribute("DoingActionPower") or not Ability or not Ability:FindFirstChild("Clipping") or Ability:FindFirstChild("Clipping").Visible == false or Ability:FindFirstChild("Clipping").Size.Y.Scale ~= 1 then return end
                if GetValue("AutoHatchet") and (self:GetClosestKiller(GetValue("AutoHatchet",true):GetAttribute("Range"))) and self:GetCharacterLevel(self:GetClosestKiller()) >= GetValue("AutoHatchetLevel") and self:GetClosestKiller():FindFirstChild("HumanoidRootPart") and not self:GetClosestKiller():FindFirstChild("HumanoidRootPart"):FindFirstChild("InvincibleFX") then
                    LocalCharacter:SetAttribute("DoingActionPower",true)
                    if FireSignal and Ability then
                        FireSignal(Ability.MouseButton1Down)
                        FireSignal(Ability.MouseButton1Click)
                    else
                        if GetValue("OfficialGame") then
                            for i,v in self.AbilityNames do
                                UseActorAbility:FireServer("UseActorAbility",{v})
                            end
                        else
                            for i,v in self.AbilityNames do
                                UseActorAbility:FireServer("UseActorAbility",v)
                                UseActorAbility:FireServer("UseActorAbility",{v})
                            end
                        end
                    end
                    local CameraTarget 
                    local SelectedVelocity
                    CameraTarget = RunService.RenderStepped:Connect(function()
                        local ClosestKiller,Dis = self:GetClosestKiller()
                        if not ClosestKiller or not ClosestKiller:FindFirstChild("HumanoidRootPart") then return end
                        local KillerRootPos = ClosestKiller:FindFirstChild("HumanoidRootPart").Position
                        local SelectedPosition = Vector3.new(KillerRootPos.X,LocalRoot.Position.Y,KillerRootPos.Z)
                        local TargetCFrame = CFrame.new(LocalRoot.Position, SelectedPosition)
                        LocalCharacter:SetPrimaryPartCFrame(TargetCFrame)
                        if not SelectedVelocity and LocalCharacter:GetAttribute("DisableShiftLockMovement") then
                            LocalRoot.Velocity = TargetCFrame.LookVector * 45
                            SelectedVelocity = LocalRoot.Velocity
                        elseif LocalCharacter:GetAttribute("DisableShiftLockMovement") then
                            SelectedVelocity = LocalRoot.Velocity:Lerp(SelectedVelocity or LocalRoot.Velocity,GetValue("AutoHatchet",true):GetAttribute("Accuracy")/100)
                            LocalRoot.Velocity = SelectedVelocity
                        end
                    end)
                    local Timeout = workspace.DistributedGameTime + 1
                    task.wait(0.6)
                    LocalCharacter:SetAttribute("DisableShiftLockMovement",true)
                    repeat
                        task.wait(0.05)
                    until FOVMultipliers:FindFirstChild("HitRegistered") or workspace.DistributedGameTime > Timeout
                    LocalRoot.Velocity = LocalRoot.Velocity * 0.15
                    CameraTarget:Disconnect()
                    task.wait(0.1)
                    LocalCharacter:SetAttribute("DisableShiftLockMovement",false)
                    task.wait(1.6)
                    LocalCharacter:SetAttribute("DoingActionPower",nil)
                end
            end,
            ["CustomSetup"] = function(self)
                self.DisplayTitle = self.DisplayTitle:gsub("Jane Doe",RichTextGradientColor("Jane Doe",{Color3.fromRGB(196, 171, 126),Color3.fromRGB(156, 107, 46),Color3.fromRGB(185, 96, 214)}))
                if MainUI:FindFirstChild("AbilityContainer") then
                    self:SetupUI(MainUI:FindFirstChild("AbilityContainer"))
                end
                MainUI.ChildAdded:Connect(function(Child)
                    self:SetupUI(Child)
                end)
            end
        },
        ["AutoHatchetLevel"] = {
            ["DisplayDescription"] = "The threshold that triggers auto hatchet",
            ["DisplayTitle"] = "Auto Hatchet Level Threshold",
            ["LayoutOrder"] = 20,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 2,
            ["Requirement"] = "Survivor:JaneDoe|AutoHatchet",
            ["ExtraData"] = {
                ["MaxValue"] = 3,
                ["MinValue"] = 0,
                ["Step"] = 1,
            },
            ["Levels"] = ReplicatedStorage:FindFirstChild("Resonance",true) and ReplicatedStorage:FindFirstChild("Resonance",true):FindFirstChild("ParticleHolder",true),
            ["CustomSetup"] = function(self)
                if self.Levels then
                    local AmountOfLevels = #self.Levels:QueryDescendants("Attachment")
                    self.Instance:SetAttribute("MaxValue",AmountOfLevels)
                    self.DefaultInstanceValue = AmountOfLevels - 1
                    self.Instance.Value = math.clamp(self.Instance.Value,0,AmountOfLevels)
                end
            end
        },
    },
    ["Visuals"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Visuals",
            ["LayoutOrder"] = 6
        },
        ["DisableNoliNPC"] = {
            ["DisplayDescription"] = "Disables Noli's Distracting NPC",
            ["DisplayTitle"] = "Disable Noli's NPC",
            ["LayoutOrder"] = 1,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Killer:Noli",
            ["HandleNoliNPC"] = function(self,Value)
                if Value then
                    for i,v in KillersFolder:GetChildren() do
                        if v.Name:lower() == "noli" and not Players:GetPlayerFromCharacter(v) then
                            v.Parent = Lighting
                            v:PivotTo(v:GetPivot() * CFrame.new(0,-100,0))
                        end
                    end
                    if workspace:FindFirstChild("Themes") then
                        for i,v in pairs(workspace.Themes:GetChildren()) do
                            if v.Name:find("FakeLayer") and v:IsA("Sound") then
                                v:Destroy()
                            end
                        end
                    end
                else
                    for i,v in Lighting:GetChildren() do
                        if v.Name:lower() == "noli" then
                            v.Parent = InGame
                            v:PivotTo(v:GetPivot() * CFrame.new(0,100,0))
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                self:HandleNoliNPC(Value)
            end,
            ["CustomSetup"] = function(self)
                if KillersFolder then
                    KillersFolder.ChildAdded:Connect(function(Child)
                        task.wait(0.5)
                        self:HandleNoliNPC(GetValue("DisableNoliNPC"))
                    end)
                end
            end
        },
        ["Disable007n7NPC"] = {
            ["DisplayDescription"] = "Disables 007n7's Distracting NPC",
            ["DisplayTitle"] = "Disable 007n7's NPC",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Survivor:007n7",
            ["Handle007n7NPC"] = function(self,Value)
                if Value then
                    for i,v in InGame:GetChildren() do
                        if v.Name:lower() == "007n7" and not Players:GetPlayerFromCharacter(v) then
                            v.Parent = Lighting
                            if v:FindFirstChild("HumanoidRootPart") then
                                v:FindFirstChild("HumanoidRootPart").ChildAdded:Connect(function(Child)
                                    if Child:IsA("Sound") and GetValue("Disable007n7NPC") then
                                        Child:Destroy()
                                    end
                                end)
                            end
                        end
                    end
                else
                    for i,v in Lighting:GetChildren() do
                        if v.Name:lower() == "007n7" then
                            v.Parent = InGame
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                self:Handle007n7NPC(Value)
            end,
            ["CustomSetup"] = function(self)
                if InGame then
                    InGame.ChildAdded:Connect(function(Child)
                        task.wait(0.02)
                        self:Handle007n7NPC(GetValue("Disable007n7NPC"))
                    end)
                end
            end
        },
        ["DisplayCorrectTime"] = {
            ["DisplayDescription"] = "Prevent's Noli's fake timer and always shows the timer",
            ["DisplayTitle"] = "Always Display Correct Timer",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["ScriptFunction"] = function(self,Value,Starting)
                if self.TimerUI and not Starting then
                    if Value then
                        self.TimerUI:SetAttribute("Self",true)
                    end
                    self.TimerUI.Text = Value and self:FormatSeconds(self.TimerValue:GetAttribute("TimeLeft")) or self.TimerUI:GetAttribute("Original") or ""
                end
            end,
            ["FormatSeconds"] = function(self,Number)
                if not Number or type(Number) ~= type(0) then return "0:00" end
                local Minutes = math.floor(Number%3600/60)
                local Seconds = math.floor(Number%60)
                return string.format("%d:%02d",Minutes,Seconds)
            end,
            ["CustomSetup"] = function(self)
                local TimerValue = ReplicatedStorage:FindFirstChild("RoundTimer")
                local TimerUI = PlayerGui:FindFirstChild("RoundTimer") and PlayerGui:FindFirstChild("RoundTimer"):FindFirstChild("Time",true)
                if not (TimerValue and TimerUI) then
                    self.Requirement = true
                    return
                end
                self.TimerUI = TimerUI
                self.TimerValue = TimerValue
                TimerUI:SetAttribute("Original",TimerUI.Text)
                TimerUI:GetPropertyChangedSignal("Text"):Connect(function()
                    if TimerUI:GetAttribute("Self") then
                        TimerUI:SetAttribute("Self",nil)
                    else
                        TimerUI:SetAttribute("Original",TimerUI.Text)
                    end
                    if GetValue("DisplayCorrectTime") then
                        TimerUI.Text = self:FormatSeconds(TimerValue:GetAttribute("TimeLeft"))
                    end
                end)
                TimerValue:GetAttributeChangedSignal("TimeLeft"):Connect(function()
                    if GetValue("DisplayCorrectTime") then
                        TimerUI:SetAttribute("Self",true)
                        TimerUI.Text = self:FormatSeconds(TimerValue:GetAttribute("TimeLeft"))
                    end
                end)
                if self.Instance.Value then
                    TimerUI:SetAttribute("Self",true)
                    TimerUI.Text = self:FormatSeconds(TimerValue:GetAttribute("TimeLeft"))
                end
            end
        },
        ["ESP"] = {
            ["DisplayDescription"] = "Track things in the game through walls",
            ["DisplayTitle"] = "ESP",
            ["LayoutOrder"] = 6,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["CheckHighlightDistance"] = function(self,Highlight,TargetRoot,Settings)
                local Camera = TargetRoot and workspace.CurrentCamera
                if not Camera or (Highlight:GetAttribute("Frozen") and not Settings.Instant) then return end
                local Distance = (Camera.CFrame.Position - TargetRoot.Position).Magnitude
                local MinDistance = Settings.MinDistance
                local ShouldHide = Distance < MinDistance or Distance > 1200
                if ShouldHide and Highlight.OutlineTransparency ~= 1 then
                    local Tween = TweenService:Create(Highlight,TweenInfo.new(Settings.Instant and 0 or 0.1),{
                        FillTransparency = 1,
                        OutlineTransparency = 1
                    })
                    Tween.Parent = Highlight
                    Tween:Play()
                    Debris:AddItem(Tween,0.2)
                    return
                end
                if not ShouldHide and Distance >= MinDistance and Distance < 1200 then
                    local TransparencyAmount = math.clamp(1 - math.clamp((Distance - MinDistance) / math.max(Settings.MaxDistance - MinDistance, 0.001),0,1),0.45,1)
                    if math.abs(Highlight.FillTransparency - TransparencyAmount) > 0 then
                        local Tween = TweenService:Create(Highlight,TweenInfo.new(Settings.Instant and 0 or 0.1),{
                            FillTransparency = math.clamp(TransparencyAmount + 0.05,0,1),
                            OutlineTransparency = TransparencyAmount <= 0.95 and TransparencyAmount - 0.05 or TransparencyAmount
                        })
                        Tween.Parent = Highlight
                        Tween:Play()
                        Debris:AddItem(Tween,0.2)
                    end
                end
            end,
            ["CheckTextDistance"] = function(self,Text,Image,TargetRoot,Settings)
                local Camera = TargetRoot and workspace.CurrentCamera
                if not Camera or (Text:GetAttribute("Frozen") and not Settings.Instant) then return end
                local Distance = (Camera.CFrame.Position - TargetRoot.Position).Magnitude
                local MinDistance = Settings.MinDistance
                if Distance > MinDistance and Distance < 1200 and Text.TextTransparency ~= 0 then
                    local Tween = TweenService:Create(Text,TweenInfo.new(Settings.Instant and 0 or 0.1),{TextTransparency = 0,TextStrokeTransparency = 0})
                    local Tween2 = TweenService:Create(Image,TweenInfo.new(Settings.Instant and 0 or 0.1),{ImageTransparency = 0})
                    Tween.Parent = TargetRoot
                    Tween2.Parent = TargetRoot
                    Tween:Play()
                    Tween2:Play()
                    Debris:AddItem(Tween,0.2)
                elseif Distance <= MinDistance or Distance >= 1200 and Text.TextTransparency ~= 1 then
                    local Tween = TweenService:Create(Text,TweenInfo.new(Settings.Instant and 0 or 0.1),{TextTransparency = 1,TextStrokeTransparency = 1})
                    local Tween2 = TweenService:Create(Image,TweenInfo.new(Settings.Instant and 0 or 0.1),{ImageTransparency = 1})
                    Tween.Parent = TargetRoot
                    Tween2.Parent = TargetRoot
                    Tween:Play()
                    Tween2:Play()
                    Debris:AddItem(Tween,0.2)
                end
            end,
            ["CreateDynamicHighlight"] = function(self,Enabled,ItemInstance,TargetRoot,Settings)
                Settings = type(Settings) == "table" and Settings or {["MaxDistance"] = 100,["MinDistance"] = 10,["Color"] = Color3.new(1,1,1)}
                local Highlight:Highlight? = ItemInstance:QueryDescendants("Highlight[$Dynamic]")
                local ExistingHighlights = ItemInstance:QueryDescendants("Highlight:not([$Dynamic])")
                if Enabled and GetValue("ESP") then
                    if not Highlight[1] then
                        Highlight = Instance.new("Highlight")
                        Highlight.Name = HttpService:GenerateGUID(false):sub(1,7)
                        Highlight.Archivable = false
                        local H, S, V = Settings.Color:ToHSV()
                        Highlight.FillColor = Color3.fromHSV(H, S, V * 0.8)
                        Highlight.OutlineColor = Color3.fromHSV(H, S, V * 1.1)
                        Highlight:SetAttribute("Dynamic",true)
                        Highlight.Parent = ItemInstance
                        Highlight.Adornee = ItemInstance
                        Highlight.FillTransparency = 1
                        Highlight.OutlineTransparency = 1
                        self:CheckHighlightDistance(Highlight, TargetRoot, Settings)
                        local Connection;Connection = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
                            if Highlight and Highlight.Parent then
                                for i,v in Highlight:GetChildren() do v:Cancel() end
                                Highlight.FillTransparency = 0.95
                                Highlight.OutlineTransparency = 0.95
                            else
                                Connection:Disconnect()
                            end
                        end)
                        Highlight.Destroying:Once(function()
                            if Connection then
                                Connection:Disconnect()
                            end
                        end)
                        Highlight.Parent:GetPropertyChangedSignal("Parent"):Once(function()
                            Highlight:Destroy()
                        end)
                    else
                        Highlight = Highlight[1]
                        local H, S, V = Settings.Color:ToHSV()
                        Highlight.FillColor = Color3.fromHSV(H, S, V * 0.8)
                        Highlight.OutlineColor = Color3.fromHSV(H, S, V * 1.1)
                        self:CheckHighlightDistance(Highlight, TargetRoot, Settings)
                    end
                    for i,v in ExistingHighlights do
                        v.Enabled = false
                    end
                elseif Highlight[1] then
                    for i,v in ExistingHighlights do
                        v.Enabled = true
                    end
                    Highlight[1]:Destroy()
                end
            end,
            ["CreateText"] = function(self,Enabled,ItemInstance,TargetRoot,Settings)
                Settings = type(Settings) == "table" and Settings or {["MinDistance"] = 10,["Color"] = Color3.new(1,1,1)}
                local BillboardGui = ItemInstance:QueryDescendants("BillboardGui[$Dynamic]")
                if Enabled and GetValue("ShowText") and GetValue("ESP") then
                    if not BillboardGui[1] then
                        BillboardGui = Instance.new("BillboardGui")
                        local TextLabel = Instance.new("TextLabel")
                        local ImageLabel = Instance.new("ImageLabel")
                        local AspectRatio = Instance.new("UIAspectRatioConstraint")
                        BillboardGui.Name = HttpService:GenerateGUID(false):sub(1,7)
                        BillboardGui.Archivable = false
                        BillboardGui.Size = ItemInstance:IsA("Tool") and UDim2.new(1.5, 30, 0.75, 30) or UDim2.new(1.5,60,0.75,25)
                        BillboardGui["StudsOffset"] = Settings.Size or ItemInstance:IsA("Tool") and Vector3.new(0,3,0) or Vector3.new(0,4,0)
                        BillboardGui.AlwaysOnTop = true
                        BillboardGui.ResetOnSpawn = true
                        BillboardGui.Adornee = TargetRoot
                        BillboardGui:SetAttribute("Dynamic",true)
                        TextLabel.Text = Settings.Text or "Unknown"
                        local H, S, V = Settings.Color:ToHSV()
                        TextLabel.TextColor3 = Color3.fromHSV(H, S, V * 1.1)
                        TextLabel.AnchorPoint = Vector2.new(0.5,0.5)
                        TextLabel.Position = UDim2.fromScale(0.5,0.5)
                        --TextLabel.AutomaticSize = Enum.AutomaticSize.XY
                        TextLabel.Size = UDim2.fromScale(1,1)
                        TextLabel.TextScaled = true
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.TextStrokeTransparency = 0
                        TextLabel.TextSize = 8
                        TextLabel.Parent = BillboardGui
                        ImageLabel.BackgroundTransparency = 1
                        ImageLabel.ImageColor3 = Settings.Color
                        ImageLabel.Position = UDim2.fromScale(0.5,0)
                        ImageLabel.Size = UDim2.fromScale(1,1)
                        ImageLabel.AnchorPoint = Vector2.new(0.5,0.65)
                        ImageLabel.Image = type(Settings.Image) == type(0) and "rbxassetid://" .. Settings.Image or Settings.Image or ""
                        ImageLabel.Parent = BillboardGui
                        AspectRatio.Parent = ImageLabel
                        BillboardGui:GetPropertyChangedSignal("Size"):Connect(function()
                            BillboardGui.Size = ItemInstance:IsA("Tool") and UDim2.new(1.5, 30, 0.75, 30) or UDim2.new(1.5,60,0.75,25)
                        end)
                        BillboardGui:GetPropertyChangedSignal("StudsOffset"):Connect(function()
                            BillboardGui["StudsOffset"] = Settings.Size or ItemInstance:IsA("Tool") and Vector3.new(0,3,0) or Vector3.new(0,4,0)
                        end)
                        BillboardGui.Parent = TargetRoot
                        self:CheckTextDistance(TextLabel,ImageLabel,TargetRoot,Settings)
                        local Connection;Connection = workspace.CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
                            if BillboardGui and BillboardGui.Parent then
                                for i,v in TextLabel:GetChildren() do v:Cancel() end
                                TextLabel.TextTransparency = 0.95
                                TextLabel.TextStrokeTransparency = 0.95
                            else
                                Connection:Disconnect()
                            end
                        end)
                        BillboardGui.Destroying:Once(function()
                            if Connection then
                                Connection:Disconnect()
                            end
                        end)
                        BillboardGui.Parent:GetPropertyChangedSignal("Parent"):Once(function()
                            BillboardGui:Destroy()
                        end)
                    else
                        BillboardGui = BillboardGui[1]
                        local H, S, V = Settings.Color:ToHSV()
                        local TextLabel = BillboardGui:FindFirstChild("TextLabel")
                        local Image = BillboardGui:FindFirstChild("ImageLabel")
                        TextLabel.TextColor3 = Color3.fromHSV(H, S, V * 1.1)
                        Image.ImageColor3 = Settings.Color
                        Image.Image = type(Settings.Image) == type(0) and "rbxassetid://" .. Settings.Image or Settings.Image or ""
                        self:CheckTextDistance(TextLabel,Image,TargetRoot,Settings)
                    end
                elseif BillboardGui[1] then
                    BillboardGui[1]:Destroy()
                end
            end,
            ["OnLoop"] = function(self)
                local fireprompt = fireproximityprompt or function(ProximityPrompt)
                    if ProximityPrompt then
                        ProximityPrompt:InputHoldBegin();ProximityPrompt:InputHoldEnd()
                    end
                end
                for i,v in PlayersFolder:QueryDescendants("#Killers > Instance,#Survivors > Instance") do
                    task.spawn(function()
                        local Player = v ~= LocalPlayer.Character and Players:GetPlayerFromCharacter(v)
                        if Player and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and MainUI.Enabled == true then
                            local FolderName = v.Parent.Name
                            local FeatureValue, ColorValue, TargetRoot = GetValue(FolderName.."ESP"), ColorPresets[GetValue(FolderName.."Color")], v:FindFirstChild("HumanoidRootPart")
                            self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, {MaxDistance = 100,MinDistance = 10,Color = ColorValue })
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = Player.Name,Color = ColorValue})
                        else
                            self:CreateDynamicHighlight(false, v)
                            self:CreateText(false, v)
                        end
                    end)
                end
                if InGame then
                    local ModelData = {
                        ["VineModel"] = {"Vine",ColorPresets["Purple"]},
                        ["GroundBulbModel"] = {"Bulb",ColorPresets["Purple"]},
                        ["SubspaceTripmine"] = {"Mine",ColorPresets["Orange"]},
                        ["PizzaDeliveryRig"] = {"NPC",ColorPresets["Orange"]},
                        ["TaphTripwire"] = {"Wire",ColorPresets["Light Green"]},
                        ["BuildermanDispenser"] = {"Dispenser",ColorPresets["Light Green"]},
                        ["BuildermanSentry"] = {"Sentry",ColorPresets["Red"]},
                        ["Document"] = {"Contract",ColorPresets["Red"]},
                        ["Gear"] = {"Gear",ColorPresets["White"]}
                    }
                    for i,v in InGame:QueryDescendants("#VineModel,Model#Gear:has(Highlight),#GroundBulbModel,#SubspaceTripmine,#BuildermanDispenser,#PizzaDeliveryRig:has(Humanoid),#BuildermanSentry,Model:has(BasePart#Wire)") do
                        task.spawn(function()
                            local FoundMatch
                            for i2,v2 in ModelData do
                                if v.Name:lower():find(i2:lower()) then
                                    FoundMatch = v2
                                    break
                                end
                            end
                            local FeatureValue, ColorValue, TargetRoot = GetValue("OtherESP"), FoundMatch and FoundMatch[2] or ColorPresets["White"], v:IsA("Model") and v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
                            self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, {MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = FoundMatch and FoundMatch[1] or v.Name, Color = FoundMatch and FoundMatch[2] or ColorValue})
                        end)
                    end
                    for i,v in workspace:GetChildren() do
                        if v:IsA("MeshPart") and v:FindFirstChild("Moving Outward Burst") then
                            local FeatureValue, ColorValue, TargetRoot = GetValue("OtherESP"), ModelData["Document"] and ModelData["Document"][2] or ColorPresets["White"], v
                            self:CreateDynamicHighlight(FeatureValue and not v:GetAttribute("Team") or v:GetAttribute("Team") ~= LocalCharacter.Parent.Name, v, TargetRoot, {MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = ModelData["Document"] and ModelData["Document"][1] or v.Name, Color = ColorValue})
                        end
                    end
                end
                if InGame and GameMap then
                    task.spawn(function()
                        local Tools = InGame:QueryDescendants("Tool:not(Flag)")
                        for i,v in Tools do
                            if v.Parent:IsA("Model") and v.Parent:FindFirstChildOfClass("Humanoid") then continue end
                            local FeatureValue, ColorValue, TargetRoot = GetValue("ItemsESP"), ColorPresets[GetValue("ItemsColor")], v:FindFirstChildWhichIsA("BasePart")
                            self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, {MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                            self:CreateText(FeatureValue, v, TargetRoot, {MinDistance = 25,Text = v:FindFirstChildWhichIsA("ProximityPrompt",true) and v:FindFirstChildWhichIsA("ProximityPrompt",true).ActionText or v.Name, Color = ColorValue})
                            if (not LocalCharacter:FindFirstChildOfClass("Tool") or LocalCharacter:FindFirstChildOfClass("Tool").Name ~= v.Name) and not (LocalPlayer:FindFirstChildOfClass("Backpack") and LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(v.Name)) and not v:GetAttribute("JustDropped") and GetValue("AutoPickup") then
                                local Param = OverlapParams.new()
                                Param.BruteForceAllSlow = true
                                Param.IncludeInstances = {v}
                                local Result = workspace:GetPartBoundsInRadius(LocalRoot.Position, 4.5, Param)
                                if LocalRoot and #Result > 0 and v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                    fireprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true))
                                end
                            end
                        end
                    end)
                    for i,v in GameMap:QueryDescendants("Model#Gear:has(#Root)") do
                        if GetValue("AutoPickup") then
                            local Param = OverlapParams.new()
                            Param.BruteForceAllSlow = true
                            Param.IncludeInstances = {v}
                            local Result = workspace:GetPartBoundsInRadius(LocalRoot.Position, 4.5, Param)
                            if LocalRoot and #Result > 0 and v:FindFirstChildWhichIsA("ProximityPrompt",true) then
                                fireprompt(v:FindFirstChildWhichIsA("ProximityPrompt",true))
                            end
                        end
                    end
                    local GeneratorImages = {["ConnectServerMinigame"] = 99080479259815,["GearServerMinigame"] = 81454811776080,["FlowServerMinigame"] = 110241164394153,["LockServerMinigame"] = 108612249774904}
                    for i,v in GameMap:QueryDescendants("Model#Generator:has(#Main)") do
                        local ProgressValue = v:FindFirstChild("BarUI",true) and v:FindFirstChild("BarUI",true):FindFirstChild("Bar") and v:FindFirstChild("BarUI",true):FindFirstChild("Bar").Size.X.Scale
                        task.spawn(function()
                            if (GetValue("GeneratorsCheck")) == true and ProgressValue and ProgressValue >= 1 then
                                self:CreateDynamicHighlight(false, v)
                                self:CreateText(false, v)
                            elseif ProgressValue then
                                local FeatureValue, ColorValue, TargetRoot = GetValue("GeneratorsESP"), ColorPresets[GetValue("GeneratorsColor")], v:FindFirstChild("Main") or v:WaitForChild("Main")
                                self:CreateDynamicHighlight(FeatureValue, v, TargetRoot, { MaxDistance = 100,MinDistance = 12,Color = ColorValue})
                                self:CreateText(FeatureValue, v, TargetRoot, { MinDistance = 25,Text = v.Name,Color = ColorValue,Image = v:GetAttribute("Puzzle") and GetValue("GeneratorPuzzleIcon") and GeneratorImages[v:GetAttribute("Puzzle")] or nil})
                            end
                        end)
                    end
                end
            end
        },
        ["ShowText"] = {
            ["DisplayDescription"] = "Show text over the highlighted objects",
            ["DisplayTitle"] = "Show Text",
            ["LayoutOrder"] = 7,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = "ESP",
            ["ScriptFunction"] = function(self,Value,Starting)
                if not Value and GetValue("GeneratorPuzzleIcon",true) and not Starting then
                    GetValue("GeneratorPuzzleIcon",true).Value = false
                end
            end
        },
        ["KillersESP"] = {
            ["DisplayDescription"] = "Enables ESP for the killer(s)",
            ["DisplayTitle"] = "Killer(s) (ESP)",
            ["LayoutOrder"] = 9,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
        },
        ["KillersColor"] = {
            ["DisplayDescription"] = "Select a Color for Killer(s) (ESP)",
            ["DisplayTitle"] = "Killer(s) Color",
            ["LayoutOrder"] = 10,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Red",
            ["Requirement"] = "ESP|KillersESP",
            ["ExtraData"] = {
                ["Options"] = "Red|Orange|Purple|Gold",
            },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then task.wait() end
                local Name = "Killer(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
            end
        },
        ["SurvivorsESP"] = {
            ["DisplayDescription"] = "Enables ESP for the survivor(s)",
            ["DisplayTitle"] = "Survivor(s) (ESP)",
            ["LayoutOrder"] = 11,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
            ["ScriptFunction"] = function(self, Value) end
        },
        ["SurvivorsColor"] = {
            ["DisplayDescription"] = "Select a Color for Survivor(s) (ESP)",
            ["DisplayTitle"] = "Survivor(s) Color",
            ["LayoutOrder"] = 12,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Green",
            ["Requirement"] = "ESP|SurvivorsESP",
            ["ExtraData"] = {
                ["Options"] = "Green|Orange|Purple|Gold",
            },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then task.wait() end
                local Name = "Survivor(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
            end
        },
        ["GeneratorsESP"] = {
            ["DisplayDescription"] = "Enables ESP for the Generator(s)",
            ["DisplayTitle"] = "Generator(s) (ESP)",
            ["LayoutOrder"] = 13,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
            ["ScriptFunction"] = function(self, Value) end
        },
        ["GeneratorsColor"] = {
            ["DisplayDescription"] = "Select a Color for Generator(s) (ESP)",
            ["DisplayTitle"] = "Generator(s) Color",
            ["LayoutOrder"] = 14,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Cyan",
            ["Requirement"] = "ESP|GeneratorsESP",
            ["ExtraData"] = {
                ["Options"] = "Cyan|Blue|Green|Orange|Purple|Gold",
            },
            ["ScriptFunction"] = function(self, Value, Starting)
                if Starting then task.wait() end
                local Name = "Generator(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                local ExtraSelected = {GetValue("GridSize",true),GetValue("AutoGeneratorPuzzle",true),GetValue("EnableOverride",true)}
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
                for i,v in ExtraSelected do
                    local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                    local FormattedName = Name:gsub("([%(%)])", "%%%1")
                    local CleanTitle = v:GetAttribute("DisplayTitle"):gsub("<[^>]->", "")
                    local ColoredText = CleanTitle:gsub(FormattedName, ColoredName, 1)
                    v:SetAttribute("DisplayTitle",ColoredText)
                end
            end
        },
        ["GeneratorsCheck"] = {
            ["DisplayDescription"] = "Hides Generator(s) That are Completed (ESP)",
            ["DisplayTitle"] = "Hide Completed Generator(s)",
            ["LayoutOrder"] = 15,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = "ESP|GeneratorsESP",
        },
        ["GeneratorPuzzleIcon"] = {
            ["DisplayDescription"] = "Shows Icons based on the Generator's Puzzle (ESP)",
            ["DisplayTitle"] = "Puzzle Icons Over Generator(s)",
            ["LayoutOrder"] = 16,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["Requirement"] = ConnectBoard and "ESP|GeneratorsESP" or true,
            ["ScriptFunction"] = function(self, Value, Starting)
                 if Value and ConnectBoard and GetValue("ShowText",true) and not Starting then
                    GetValue("ShowText",true).Value = true
                end
            end
        },
        ["ItemsESP"] = {
            ["DisplayDescription"] = "Enables ESP for the Item(s)",
            ["DisplayTitle"] = "Item(s) (ESP)",
            ["LayoutOrder"] = 20,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
            ["ScriptFunction"] = function(self, Value) end
        },
        ["ItemsColor"] = {
            ["DisplayDescription"] = "Select a Color for Item(s) (ESP)",
            ["DisplayTitle"] = "Item(s) Color",
            ["LayoutOrder"] = 22,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "Gold",
            ["Requirement"] = "ESP|ItemsESP",
            ["ExtraData"] = {
                ["Options"] = "Gold|Cyan|Purple|White",
            },
            ["ScriptFunction"] = function(self, Value,Starting)
                if Starting then task.wait() end
                local Name = "Item(s)"
                local H, S, V = ColorPresets[Value]:ToHSV()
                local Color = ColorPresets[Value]
                local DarkerColor = Color3.fromHSV(H, S, V * 0.7)
                for i,v in FeatureLoadout["Visuals"] do
                    if v["DisplayTitle"]:find(Name,1,true) then
                        local ColoredName = RichTextGradientColor(Name,{Color,DarkerColor})
                        local FormattedName = Name:gsub("([%(%)])", "%%%1")
                        local ColoredText = v["DisplayTitle"]:gsub(FormattedName, ColoredName, 1)
                        if v["Instance"] then
                            v["Instance"]:SetAttribute("DisplayTitle",ColoredText)
                        else
                            v["DisplayTitle"] = ColoredText
                        end
                    end
                end
                if ReplicatedStorage:FindFirstChild("GearClientMinigame",true) then
                    GetValue("AutoPickup",true):SetAttribute("DisplayDescription",string.format("Auto-Picks up <b>%s</b> and <b>Gears</b> near you",RichTextGradientColor("Items",{Color,DarkerColor})))
                else
                    GetValue("AutoPickup",true):SetAttribute("DisplayDescription",string.format("Auto-Picks up <b>%s</b> near you",RichTextGradientColor("Items",{Color,DarkerColor})))
                end
            end
        },
        ["OtherESP"] = {
            ["DisplayDescription"] = "Enables ESP for Other Objects",
            ["DisplayTitle"] = "Other ESPs",
            ["LayoutOrder"] = 25,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "ESP",
            ["ScriptFunction"] = function(self, Value) end
        },
    },
    ["Miscellaneous"] = {
        ["TabAttributes"] = {
            ["DisplayTitle"] = "Miscellaneous",
            ["LayoutOrder"] = 10
        },
        ["ExtendedFOV"] = {
            ["DisplayDescription"] = "A extended version of the FOV inside the normal settings",
            ["DisplayTitle"] = "Extended FOV",
            ["LayoutOrder"] = 1,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["FovSetting"] = PlayerData:FindFirstChild("FieldOfView",true) or PlayerData:FindFirstChild("FOV",true),
            ["DefaultInstanceValue"] = PlayerData:FindFirstChild("FieldOfView",true) and PlayerData:FindFirstChild("FieldOfView",true).Value or 70,
            ["ExtraData"] = {
                ["MaxValue"] = 120,
                ["MinValue"] = 10,
                ["Step"] = 5,
            },
            ["ScriptFunction"] = function(self, Value)
                if self.FovSetting then
                    self.FovSetting.Value = Value
                end
            end,
            ["CustomSetup"] = function(self)
                if self.FovSetting and self.FovSetting:IsA("NumberValue") then
                    self.FovSetting:GetPropertyChangedSignal("Value"):Connect(function()
                        self.Instance.Value = self.FovSetting.Value
                    end)
                end
            end
        },
        ["ExtendedZoom"] = {
            ["DisplayDescription"] = "Extends the Maximum Zoom Distance for the camera",
            ["DisplayTitle"] = "Extended Zoom Distance",
            ["LayoutOrder"] = 2,
            ["Savable"] = true,
            ["InstanceType"] = "NumberValue",
            ["DefaultInstanceValue"] = 10,
            ["ExtraData"] = {
                ["MaxValue"] = 100,
                ["MinValue"] = 0,
                ["Step"] = 5,
            },
            ["ScriptFunction"] = function(self, Value)
                LocalPlayer.CameraMaxZoomDistance = game:GetService("StarterPlayer").CameraMaxZoomDistance + (Value * 0.25)
            end
        },
        ["ShowChat"] = {
            ["DisplayDescription"] = "Shows the Full Chat while in the Round",
            ["DisplayTitle"] = "Show Chat",
            ["LayoutOrder"] = 3,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = not game:GetService("Chat"):CanUserChatAsync(LocalPlayer.UserId) and true or nil,
            ["ScriptFunction"] = function(self, Value)
                if not SideBar:GetAttribute("WasVisible") and TextChatService:FindFirstChildOfClass("ChatWindowConfiguration") then
                    TextChatService:FindFirstChildOfClass("ChatWindowConfiguration").Enabled = Value
                end
            end,
            ["CustomSetup"] = function(self)
                if TextChatService:FindFirstChildOfClass("ChatWindowConfiguration") then
                    TextChatService:FindFirstChildOfClass("ChatWindowConfiguration"):GetPropertyChangedSignal("Enabled"):Connect(function()
                        if GetValue("ShowChat") then
                            TextChatService:FindFirstChildOfClass("ChatWindowConfiguration").Enabled = true
                        end
                    end)
                end
            end
        },
        ["SpoofDevice"] = {
            ["DisplayDescription"] = "Spoofs the device in profiles",
            ["DisplayTitle"] = "Spoof Device",
            ["LayoutOrder"] = 4,
            ["Savable"] = true,
            ["InstanceType"] = "StringValue",
            ["ExtraData"] = {
                ["Options"] = "Original|PC|Mobile|Console|Nothing",
            },
            ["DefaultInstanceValue"] = "Original",
            ["ScriptFunction"] = function(self,Value,Starting)
                local InputDevices = {Keyboard = "PC", MouseButton1 = "PC", MouseButton2 = "PC", MouseMovement = "PC", Touch = "Mobile", Gamepad1 = "Console"}
                if Value == "Original" then
                    Value = InputDevices[UserInputService:GetLastInputType().Name] or "PC"
                elseif Value == "Nothing" and Starting then
                    return 
                elseif Value == "Nothing" then
                    Value = nil
                end
                if GetValue("OfficialGame") then
                    Network:FindFirstChildOfClass("RemoteEvent"):FireServer("SetDevice",{Value})
                else
                    Network:FindFirstChildOfClass("RemoteEvent"):FireServer("SetDevice",{Value})
                    Network:FindFirstChildOfClass("RemoteEvent"):FireServer("SetDevice",Value)
                end
            end,
            ["CustomSetup"] = function(self)
                LocalPlayer:GetAttributeChangedSignal("Device"):Connect(function()
                    if GetValue("SpoofDevice") ~= "Original" and GetValue("SpoofDevice") ~= "Nothing" and LocalPlayer:GetAttribute("Device") ~= GetValue("SpoofDevice") then
                        self:ScriptFunction(GetValue("SpoofDevice"))
                    end
                end)
            end
        },
        ["ShowPrivacy"] = {
            ["DisplayDescription"] = "Shows everyones privacy info",
            ["DisplayTitle"] = "Shows Privacy Info",
            ["LayoutOrder"] = 5,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["HandlePrivacySettings"] = function(self,Player)
                if Player then
                    local Data = Player:FindFirstChild("PlayerData")
                    if Data then
                    local PrivacySettings = Data:FindFirstChild("Privacy",true)
                        if PrivacySettings then
                            for i,v in PrivacySettings:GetChildren() do
                                if not v:GetAttribute("OriginalValue") and v:IsA("BoolValue") then
                                    v:SetAttribute("OriginalValue", v.Value)
                                    v:GetPropertyChangedSignal("Value"):Connect(function()
                                        local ShowPrivacy = FeatureLoadout["Miscellaneous"]["ShowPrivacy"]["Instance"]
                                        if ShowPrivacy and ShowPrivacy.Value then
                                            v.Value = false
                                        else
                                            v.Value = v:GetAttribute("OriginalValue")
                                        end
                                    end)
                                    local ShowPrivacy = FeatureLoadout["Miscellaneous"]["ShowPrivacy"]["Instance"]
                                    if ShowPrivacy and ShowPrivacy.Value then
                                        v.Value = false
                                    else
                                        v.Value = v:GetAttribute("OriginalValue")
                                    end
                                elseif v:IsA("BoolValue") then
                                    local ShowPrivacy = FeatureLoadout["Miscellaneous"]["ShowPrivacy"]["Instance"]
                                    if ShowPrivacy and ShowPrivacy.Value then
                                        v.Value = false
                                    else
                                        v.Value = v:GetAttribute("OriginalValue")
                                    end
                                end
                            end
                        end
                    end
                end
            end,
            ["HandleCheckForMod"] = function(self,Player)
                if not Player then return end
                if game.CreatorType ~= Enum.CreatorType.Group then return end
                local Rank = Player:GetRoleInGroupAsync(game.CreatorId)
                if Rank and (Rank:lower():find("mod") or Rank:lower():find("admin")) and not workspace:GetAttribute("ModFound") then
                    workspace:SetAttribute("ModFound",true)
                    StarterGui:SetCore("SendNotification",{
                        Title = "WARNING", Text = "A Moderator is in your server all features are now disabled",
                        Icon = "rbxasset://textures/DevConsole/Warning.png", Duration = 10
                    })
                    FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] = true
                    for i,v in FeatureLoadout do
                        if i ~= "EnviromentFunctions" then
                            if i ~= "TabAttributes" then
                                for i2,v2 in v do
                                    if v2["Instance"] and i2 ~= "DisableAllFeatures" then
                                        v2["Instance"].Value = v2["DefaultInstanceValue"]
                                    end
                                end
                            end
                        end
                    end
                end
            end,
            ["ScriptFunction"] = function(self, Value)
                for i,v in Players:GetPlayers() do
                    if v ~= LocalPlayer then
                        self:HandlePrivacySettings(v)
                    end
                end
            end,
            ["CustomSetup"] = function(self)
                task.spawn(function()
                    for i,v in Players:GetPlayers() do
                        if v ~= LocalPlayer then
                            self:HandlePrivacySettings(v)
                            self:HandleCheckForMod(v)
                        end
                    end
                end)
                Players.PlayerAdded:Connect(function(Player)
                    self:HandleCheckForMod(Player)
                    task.delay(2,self.HandlePrivacySettings,self,Player)
                end)
            end
        },
        ["HideInjury"] = {
            ["DisplayDescription"] = "Hides the injured screen and effects used when you are low health",
            ["DisplayTitle"] = "Hide Injured UI/Effects",
            ["LayoutOrder"] = 6,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["ScriptFunction"] = function(self, Value)
                for i,v in TempUI and TempUI:QueryDescendants("#redFlash,#injuredVignette") or {} do
                    v.Visible = not Value
                end
                if Lighting:FindFirstChild("HealthDesaturation") then
                    Lighting:FindFirstChild("HealthDesaturation").Enabled = not Value
                end
            end,
            ["CustomSetup"] = function(self)
                Lighting.ChildAdded:Connect(function(Child)
                    if Child.Name == "HealthDesaturation" then
                        Child.Enabled = not GetValue("HideInjury")
                    end
                end)
                if Lighting:FindFirstChild("HealthDesaturation") then
                    Lighting.HealthDesaturation.Enabled = not GetValue("HideInjury")
                end
            end
        },
        ["DisableBlindness"] = {
            ["DisplayDescription"] = "Disables the blindness effect",
            ["DisplayTitle"] = "Disable Blindness",
            ["LayoutOrder"] = 7,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = true,
            ["ScriptFunction"] = function(self, Value)
                for i,v in Lighting:QueryDescendants("#BlindnessBlur BlurEffect") do
                    v.Enabled = not Value
                end
            end,
            ["CustomSetup"] = function(self)
                Lighting.ChildAdded:Connect(function(Child)
                    if Child.Name == "BlindnessBlur" and Child:IsA("BlurEffect") then
                        Child.Enabled = not GetValue("DisableBlindness")
                    end
                end)
                if Lighting:FindFirstChild("BlindnessBlur") then
                    Lighting:FindFirstChild("BlindnessBlur").Enabled = not GetValue("DisableBlindness")
                end
            end
        },
        ["DeleteRagdolls"] = {
            ["DisplayDescription"] = "Deletes ALL Ragdolls regardless the type of ragdoll for performance",
            ["DisplayTitle"] = "Delete All Ragdolls",
            ["LayoutOrder"] = 8,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "PrivateServer",
            ["ScriptFunction"] = function(self, Value)
                if Value and RagdollsFolder then
                    RagdollsFolder:ClearAllChildren()
                elseif not RagdollsFolder then
                    self.Value = false
                    self.Instance:SetAttribute("Requirement",true)
                end
            end,
            ["CustomSetup"] = function(self)
                if RagdollsFolder then
                    RagdollsFolder.ChildAdded:Connect(function(Ragdoll)
                        if GetValue("DeleteRagdolls") and GetValue("PrivateServer") then
                            RagdollsFolder:ClearAllChildren()
                        else
                            for i,v in Ragdoll:QueryDescendants("Highlight[$Dynamic],BillboardGui[$Dynamic]") do
                                v:Destroy()
                            end
                        end
                    end)
                end
            end
        },
        ["PlayerSelectCrash"] = {
            ["DisplayDescription"] = "Select a player to crash",
            ["DisplayTitle"] = "Player to crash",
            ["LayoutOrder"] = 9,
            ["Savable"] = false,
            ["InstanceType"] = "StringValue",
            ["DefaultInstanceValue"] = "None",
            ["Requirement"] = "Effect:Nausea|PrivateServerOwner",
            ["UpdatePlayerCrashDrop"] = function(self)
                local OriginString = self.DefaultInstanceValue
                local CurrentPlayers = Players:GetPlayers()
                for i,v in CurrentPlayers do
                    if v ~= LocalPlayer then
                        OriginString ..= "|" .. v.Name
                    end
                end
                local PlayerCount = #CurrentPlayers
                if PlayerCount == 3 then
                    OriginString ..= "|Both"
                elseif PlayerCount > 3 then
                    OriginString ..= "|Everyone"
                end
                if GetValue("PlayerSelectCrash",true) then
                    GetValue("PlayerSelectCrash",true):SetAttribute("Options", OriginString)
                end
                if GetValue("PlayerSelectCrash") ~= self.DefaultInstanceValue and not Players:FindFirstChild(GetValue("PlayerSelectCrash")) then
                    self.Instance.Value = self.DefaultInstanceValue
                end
            end,
            ["ExtraData"] = {
                ["Options"] = "None",
            },
            ["CustomSetup"] = function(self)
                local function Upd()
                    self:UpdatePlayerCrashDrop()
                end
                Players.PlayerAdded:Connect(Upd)
                Players.PlayerRemoving:Connect(Upd)
                task.delay(0.5,Upd)
            end
        },
        ["CrashTheTarget"] = {
            ["DisplayDescription"] = "Crashes the selected target (Host Exclusive)",
            ["DisplayTitle"] = "Crash Target",
            ["LayoutOrder"] = 9,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Nausea|PlayerSelectCrash~None|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if Value then
                    self.Instance.Value = false
                    local PlayerName = GetValue("PlayerSelectCrash")
                    if PlayerName == "Everyone" or PlayerName == "Both" then
                        for i,Player in Players:GetPlayers() do
                            if Player ~= LocalPlayer then
                                local Name = Player.Name
                                task.spawn(function()
                                    repeat
                                        if GetValue("OfficialGame") then
                                            Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", Name, "Nausea", math.huge, 1})
                                        else
                                            Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", Name, "Nausea", math.huge, 1})
                                            Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus", Name, "Nausea", math.huge, 1)
                                        end
                                        task.wait(1.5)
                                    until not Players:FindFirstChild(Name)
                                end)
                            end
                        end
                    else
                        task.spawn(function()
                            repeat
                                if GetValue("OfficialGame") then
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", PlayerName, "Nausea", math.huge, 1})
                                else
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus", PlayerName, "Nausea", math.huge, 1})
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus", PlayerName, "Nausea", math.huge, 1)
                                end
                                task.wait(1.5)
                            until not Players:FindFirstChild(PlayerName)
                        end)
                    end
                end
            end
        },
        ["SkyGlitch"] = {
            ["DisplayDescription"] = "Gives sky glitching effect to everyone (Host Exclusive)",
            ["DisplayTitle"] = "Sky Glitch",
            ["LayoutOrder"] = 11,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Nausea|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if Value and not workspace:GetAttribute("EffectActive") then
                    workspace:SetAttribute("EffectActive",true)
                    self.Instance.Value = false
                    if PlayerData:FindFirstChild("EpilepsyMode",true) and PlayerData:FindFirstChild("EpilepsyMode",true).Value then
                        StarterGui:SetCore("SendNotification", {
                            Title = "Warning",
                            Text = "Disabled your Epilepsy Mode Temporarily for the effect to work",
                            Duration = 5
                        })
                        PlayerData:FindFirstChild("EpilepsyMode",true).Value = false
                        task.delay(10, function()
                            PlayerData:FindFirstChild("EpilepsyMode",true).Value = true
                        end)
                    end
                    if GetValue("OfficialGame") then
                        Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus","All","Nausea",-1e11,10})
                    else
                        Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus","All","Nausea",-1e11,10})
                        Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus","All","Nausea",-1e11,10)
                    end
                    task.delay(10, function()
                        workspace:SetAttribute("EffectActive",nil)
                        self.Instance.Value = false
                    end)
                elseif workspace:GetAttribute("EffectActive") then
                    self.Instance.Value = true
                end
            end
        },
        ["InstaKill"] = {
            ["DisplayDescription"] = "Allows you to instantly kill anyone (Host Exclusive)",
            ["DisplayTitle"] = "Instant Kill",
            ["LayoutOrder"] = 12,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = ReplicatedStorage:FindFirstChild("Weakness",true) and "PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("InstaKill") == nil then
                    workspace:SetAttribute("InstaKill", Value)
                    self.Instance.Value = Value
                    task.delay(1.5, function()
                        workspace:SetAttribute("InstaKill",nil)
                    end)
                    if Value then
                        repeat
                            if GetValue("OfficialGame") then
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Weakness",-1e11,2})
                            else
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Weakness",-1e11,2})
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus",LocalPlayer.Name,"Weakness",-1e11,2)
                            end
                            task.wait(1.25)
                        until not self.Instance.Value
                    end
                else
                    self.Instance.Value = workspace:GetAttribute("InstaKill")
                end
            end
        },
        ["DisableDamage"] = {
            ["DisplayDescription"] = "Disables dealing damage for everyone (Host Exclusive)",
            ["DisplayTitle"] = "Disable Damage",
            ["LayoutOrder"] = 13,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Strength|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("DisableDamage") == nil then
                    workspace:SetAttribute("DisableDamage", Value)
                    self.Instance.Value = Value
                    task.delay(2.25, function()
                        workspace:SetAttribute("DisableDamage",nil)
                    end)
                    if Value then
                        repeat
                            for i,v in Players:GetPlayers() do
                                if v.UserId == LocalPlayer.UserId and GetValue("InstaKill") then continue end
                                if GetValue("OfficialGame") then
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",v.Name,"Strength",-1e11,2})
                                else
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",v.Name,"Strength",-1e11,2})
                                    Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus",v.Name,"Strength",-1e11,2)
                                end
                            end
                            task.wait(1.25)
                        until not self.Instance.Value
                    end
                else
                    self.Instance.Value = workspace:GetAttribute("DisableDamage")
                end
            end
        },
        ["DisableAbilityCooldown"] = {
            ["DisplayDescription"] = "Disables the ability cooldown only for you (Host Exclusive)",
            ["DisplayTitle"] = "Disable Ability Cooldown",
            ["LayoutOrder"] = 14,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "Effect:Fatigue|PrivateServerOwner",
            ["ScriptFunction"] = function(self, Value)
                if workspace:GetAttribute("DisableAbilityCooldownSelf") == nil then
                    workspace:SetAttribute("DisableAbilityCooldownSelf", Value)
                    self.Instance.Value = Value
                    task.delay(1.5, function()
                        workspace:SetAttribute("DisableAbilityCooldownSelf",nil)
                    end)
                    if Value then
                        repeat
                            if GetValue("OfficialGame") then
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Fatigue",-1e8,2})
                            else
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand",{"GiveStatus",LocalPlayer.Name,"Fatigue",-1e8,2})
                                Network:WaitForChild("RemoteEvent"):FireServer("ExecuteCommand","GiveStatus",LocalPlayer.Name,"Fatigue",-1e8,2)
                            end
                            task.wait(1.25)
                        until not self.Instance.Value
                    end
                else
                    self.Instance.Value = workspace:GetAttribute("DisableAbilityCooldownSelf")
                end
            end
        },
        ["DisableAllFeatures"] = {
            ["DisplayDescription"] = "Disables all features when the script is outdated/not tested",
            ["DisplayTitle"] = "Disable Features When Outdated",
            ["LayoutOrder"] = 18,
            ["Savable"] = true,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "OfficialGame",
            ["ScriptFunction"] = function(self, Value) end
        },
        ["OfficialJoin"] = {
            ["DisplayDescription"] = "Makes you join the official forsaken game",
            ["DisplayTitle"] = "Join the official version",
            ["LayoutOrder"] = 19,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["Requirement"] = "OfficialGame~true",
            ["ScriptFunction"] = function(self, Value)
                if Value and not workspace:GetAttribute("LoadingTeleport") then
                    workspace:SetAttribute("LoadingTeleport",true)
                    local A = workspace:FindFirstChild("Sounds") and workspace.Sounds:ClearAllChildren()
                    local B = workspace:FindFirstChild("Themes") and workspace.Themes:ClearAllChildren()
                    TeleportSound.TimePosition = 0.4
                    TeleportSound.Volume = 4
                    TeleportSound.Playing = true
                    local OtherInstance = GetValue("Rejoin",true)
                    OtherInstance:SetAttribute("Requirement",true)
                    task.wait(0.5)
                    local FrequencyData = HttpService:JSONDecode(ReturnData("AccountType.txt", true))
                    local PlaceId = 83645629621104
                    if FrequencyData["New"] and FrequencyData["New"] < FrequencyData["Normal"] then
                        PlaceId = 18687417158
                    end
                    game:GetService("ExperienceService"):LaunchExperience({placeId = PlaceId})
                elseif workspace:GetAttribute("LoadingTeleport") then
                    self.Instance.Value = true
                end
            end
        },
        ["Rejoin"] = {
            ["DisplayDescription"] = "Makes you rejoin the exact same server",
            ["DisplayTitle"] = "Rejoin",
            ["LayoutOrder"] = 20,
            ["Savable"] = false,
            ["InstanceType"] = "BoolValue",
            ["DefaultInstanceValue"] = false,
            ["ScriptFunction"] = function(self, Value)
                if Value and not workspace:GetAttribute("LoadingTeleport") then
                    workspace:SetAttribute("LoadingTeleport",true)
                    local A = workspace:FindFirstChild("Sounds") and workspace.Sounds:ClearAllChildren()
                    local B = workspace:FindFirstChild("Themes") and workspace.Themes:ClearAllChildren()
                    TeleportSound.TimePosition = 0.4
                    TeleportSound.Volume = 4
                    TeleportSound.Playing = true
                    local OtherInstance = GetValue("OfficialJoin",true)
                    OtherInstance:SetAttribute("Requirement",true)
                    task.wait(0.25)
                    game:GetService("TeleportService").TeleportInitFailed:Once(function()
                        workspace:SetAttribute("LoadingTeleport",nil)
                        TeleportSound.Playing = false
                        warn("Failed to teleport, please try again. (Rejoin manually if it repeats)")
                        self.Instance.Value = false
                    end)
                    if workspace:GetAttribute("ServerType") == "VIP" then
                        game:GetService("TeleportService"):Teleport(game.PlaceId)
                    else
                        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId)
                    end
                elseif workspace:GetAttribute("LoadingTeleport") then
                    self.Instance.Value = true
                end
            end
        },
    }
}

-- UI Creation --

MainUI.DisplayOrder = 5

PlusFolderSettings.Name = "Plus"
PlusFolderSettings.Parent = PlayerData

SidePlusButton.Name = "Plus"
SidePlusButton.Parent = Buttons
SidePlusButton.LayoutOrder = MainButton.Name == "Settings" and MainButton.LayoutOrder - 1 or MainButton.LayoutOrder + 1
if NewUIVersion then
    PlusButton:FindFirstChild("Icon").ImageColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Icon").Image = "rbxassetid://118860705115878"
    PlusButton:FindFirstChild("Text"):FindFirstChild("Name").Text = "Plus"
    PlusButton:FindFirstChild("Line").ImageColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Highlight").ImageColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Text"):FindFirstChild("Name").TextColor3 = Color3.fromRGB(0, 170, 127)
    PlusButton:FindFirstChild("Texture").ImageColor3 = Color3.fromRGB(0, 170, 127)
    for i,v in PlusButton:FindFirstChild("Text"):GetChildren() do if v:IsA("ImageLabel") then v.ImageColor3 = Color3.fromRGB(0, 17, 13) end end
    PlusButton:FindFirstChild("BG").ImageColor3 = Color3.fromRGB(0, 17, 13)
    PlusButton:FindFirstChild("Grunge").ImageColor3 = Color3.fromRGB(0, 37, 24)
    PlusButton:FindFirstChild("Grunge").ImageTransparency = 0.2
    PlusButton:FindFirstChild("GrungeMain").ImageTransparency = 1
    UIScale.Parent = PlusButton
else
    SidePlusButton.Button.ImageColor3 = Color3.fromRGB(0, 170, 127)
    SidePlusButton.Icon.ImageColor3 = Color3.fromRGB(0, 170, 127)
    SidePlusButton.Icon.Image = "rbxassetid://118860705115878"
    if SidePlusButton:FindFirstChild("Inverted") then
        SidePlusButton.Inverted.ImageColor3 = Color3.fromRGB(105, 255, 212)
        SidePlusButton.Inverted.ImageTransparency = 1
    end
    if SidePlusButton:FindFirstChild("InvertedIcon") then
        SidePlusButton.InvertedIcon.ImageColor3 = Color3.fromRGB(105, 255, 212)
        SidePlusButton.InvertedIcon.Image = "rbxassetid://85001556314176"
        SidePlusButton.InvertedIcon.ImageTransparency = 1
    end
    PulloutFramePlus.Title.TextColor3 = Color3.fromRGB(0, 170, 127)
    PulloutFramePlus.Position = UDim2.fromScale(0,0.5)
    PulloutFramePlus.ArtAsset.ImageColor3 = Color3.fromRGB(0, 170, 127)
    PulloutFramePlus.ArtAsset.ImageTransparency = 0
    if PulloutFramePlus:FindFirstChild("Inverted") then
        PulloutFramePlus.Inverted.ImageColor3 = Color3.fromRGB(105, 255, 212)
        PulloutFramePlus.Inverted.ImageTransparency = 1
    end
end

local Arrow = ReplicatedStorage:FindFirstChild("DropdownArrow",true):Clone()
Arrow.ImageColor3 = Color3.fromRGB(0, 170, 127)
Arrow.Parent = SidePlusButton
Arrow.Position = UDim2.fromScale(1.6,0.5)
Arrow.AnchorPoint = Vector2.new(0.5,0.5)
Arrow.Rotation = 90
Arrow.Size = UDim2.fromScale(0.67,0.67)
Arrow.Visible = false
Arrow.Active = false

PlusMenu.Name = "PlusScreen"
PlusMenu.Parent = MainUI
PlusMenu.Visible = false
PlusMenu.Size = UDim2.new(1,-20,0,0)
PlusMenu.SettingsContainer.ImageColor3 = Color3.fromRGB(0, 170, 127)
PlusMenu.SettingsContainer.BackgroundTransparency = 1
PlusMenu.SettingsContainer.Contents.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 127)
PlusMenu.SettingsContainer.Contents.Size = UDim2.fromScale(0.95,0.935)
PlusMenu.SettingsContainer.Contents.Position = UDim2.fromScale(0.5,0.035)
PlusMenu.ZIndex += 25
PlusMenu:GetPropertyChangedSignal("Visible"):Connect(function()
    PlusMenu.Visible = PlusMenu:GetAttribute("Visible") and true or false
end)
for i,v in PlusMenu.SettingsContainer:GetChildren() do if not (v:IsA("UIAspectRatioConstraint") or v.Name == "Contents") then v:Destroy() end end
for i,v in PlusMenu.SettingsContainer.Contents:QueryDescendants("Frame,ImageLabel") do v:Destroy() end

-- Functions --

function ColoredPrint(Text, Icon, Color)
    task.spawn(function()
        task.spawn(function()
            if not _G.Initialized and not _G.Initizalling then
                _G.Initizalling = true
                _G.PrintedData = {}
                local CoreGuiConnection 
                local function Handle(child)
                    if child.Name == "DevConsoleMaster" then
                        CoreGuiConnection:Disconnect()
                        local DevConsoleMaster = child
                        local DevConsoleUI = DevConsoleMaster:FindFirstChild("DevConsoleUI",true) or DevConsoleMaster:WaitForChild("DevConsoleWindow",999999):WaitForChild("DevConsoleUI",999999)
                        local IconData = {
                            ["error"] = {"rbxasset://textures/DevConsole/Error.png","rbxassetid://97467062933153",Color3.fromRGB(215,90,74)},
                            ["information"] = {"rbxasset://textures/DevConsole/Info.png","rbxassetid://98895588220731",Color3.fromRGB(0,162,255)},
                            ["warning"] = {"rbxasset://textures/DevConsole/Warning.png","rbxassetid://129253285072281",Color3.fromRGB(255,218,68)},
                            ["plus"] = {"rbxassetid://127360009371476","rbxassetid://127360009371476",Color3.fromRGB(255,255,255)},
                            ["success"] = {"rbxassetid://75097763556603","rbxassetid://87889653826033",Color3.fromRGB(105,215,74)},
                        }
                        local function GetIcon(Icon)
                            if type(Icon) == "string" then
                                local iconLower = Icon:lower()
                                for i,v in pairs(IconData) do
                                    if string.lower(string.sub(i, 1, #iconLower)) == iconLower then
                                        return v
                                    end
                                end
                            end
                            return IconData["information"]
                        end
                        local function RunChecks(ins)
                            local Log = ins:FindFirstChild("ClientLog")
                            local function RunChecks2(ins2,Log)
                                local TextLabel = ins2:FindFirstChildWhichIsA("TextLabel")
                                local Image = ins2:FindFirstChildWhichIsA("ImageLabel")
                                if TextLabel then
                                    local function Update()
                                        local ID = string.sub(TextLabel.Text, -7, -1)
                                        if _G.PrintedData[ID] then
                                            local Data = _G.PrintedData[ID]
                                            local Icon = Data[1] or nil
                                            local Color = Data[2] or nil
                                            local ImageColored = false
                                            TextLabel.RichText = true
                                            if type(Icon) ~= type("") and typeof(Color) ~= typeof(Color3.new()) then
                                                Icon = GetIcon("info")[1]
                                                ImageColored = false
                                                Color = Color3.new(1,1,1)
                                            elseif type(Icon) == type("") and typeof(Color) ~= typeof(Color3.new()) then
                                                Color = GetIcon(Icon)[3]
                                                ImageColored = false
                                                Icon = GetIcon(Icon)[1]
                                            elseif type(Icon) ~= type("") and typeof(Color) == typeof(Color3.new()) then
                                                Icon = ""
                                                ImageColored = false
                                            elseif type(Icon) == type("") and typeof(Color) == typeof(Color3.new()) then
                                                ImageColored = true
                                                Icon = GetIcon(Icon)[2]
                                            end
                                            local OriginalText = TextLabel.Text
                                            local function Update2()
                                                TextLabel.Text = string.format("<font color='#%s' size='15'>%s</font>",Color:ToHex(),string.gsub(OriginalText,ID,""))
                                                if Image then
                                                    Image.Image = Icon
                                                    if ImageColored then
                                                        Image.ImageColor3 = Color
                                                    end
                                                end
                                            end
                                            Update2()
                                        else
                                            Image.ImageColor3 = Color3.new(1,1,1)
                                            Image.Image = TextLabel.TextColor3 == Color3.fromRGB(255,218,68) and GetIcon("warning")[1] or TextLabel.TextColor3 == Color3.fromRGB(215,90,74) and GetIcon("error")[1] or TextLabel.TextColor3 == Color3.fromRGB(0,162,255) and GetIcon("info")[1]  or ""
                                        end
                                        TextLabel:GetPropertyChangedSignal("Text"):Once(Update)
                                    end
                                    Update()
                                end
                            end
                            if Log then
                                for i,ins2 in pairs(Log:GetChildren()) do
                                    RunChecks2(ins2, Log)
                                end
                                Log.ChildAdded:Connect(function(ins2)
                                    RunChecks2(ins2, Log)
                                end)
                            end
                            ins.ChildAdded:Connect(function(Log)
                                if Log.Name == "ClientLog" then
                                    for i,ins2 in pairs(Log:GetChildren()) do
                                        RunChecks2(ins2, Log)
                                    end
                                    Log.ChildAdded:Connect(function(ins2)
                                        RunChecks2(ins2, Log)
                                    end)
                                end
                            end)
                        end
                        if DevConsoleUI:FindFirstChild("MainView") then
                            RunChecks(DevConsoleUI:FindFirstChild("MainView"))
                        end
                        DevConsoleUI.ChildAdded:Connect(function(ins)
                            if ins.Name == "MainView" then
                                RunChecks(ins)
                            end
                        end)
                        _G.Initialized = true
                        _G.Initizalling = nil
                    end
                end
                CoreGuiConnection = game:GetService("CoreGui").ChildAdded:Connect(Handle)
                if game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster") then
                    Handle(game:GetService("CoreGui"):FindFirstChild("DevConsoleMaster"))
                end
            end
        end)
        local UniqueID = string.sub(game:GetService("HttpService"):GenerateGUID(false), 1, 7)
        
        game:GetService("LogService"):Output((type(Text) == "string" and Text or "") .. UniqueID)
        _G.PrintedData[UniqueID] = {Icon,Color}
    end)
end

function PlaySound(SoundName,Settings,KeepPlaying)
    local Sound = typeof(SoundName) == "string" and AssetsFolder.Sounds:FindFirstChild(SoundName,true) or (typeof(SoundName) == "Instance" and SoundName) or nil
    if Sound then
        task.spawn(function()
            Sound = Sound:Clone()
            Sound.Parent = workspace:FindFirstChild("Sounds") or workspace
            if type(Settings) == "table" then
                for i,v in Settings do
                    Sound[i] = v
                end
            end
            if KeepPlaying then
                Sound.Playing = true
            else
                Sound:Play()
            end
            Debris:AddItem(Sound, Sound.TimeLength + 1)
            return Sound
        end)
    else
        warn("Failed to play sound: ".. tostring(SoundName))
    end
end

local function SetButtonState(Active)
    task.spawn(function()
        local u4 = {}
        local BGData = {
            ["Active"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 170, 127)
            },
            ["Inactive"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 17, 13)
            }
        }
        u4.BG = BGData
        local GrungeMainData = {
            ["Active"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 37, 24)
            },
            ["Inactive"] = {
                ["ImageColor3"] = Color3.fromRGB(80, 80, 80)
            }
        }
        u4.GrungeMain = GrungeMainData
        local GrungeData = {
            ["Active"] = {
                ["ImageTransparency"] = 0,
                ["ImageColor3"] = Color3.fromRGB(0, 229, 171)
            },
            ["Inactive"] = {
                ["ImageTransparency"] = 0.2,
                ["ImageColor3"] = Color3.fromRGB(0, 37, 24)
            }
        }
        u4.Grunge = GrungeData
        local HighlightData = {
            ["Active"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 37, 24)
            },
            ["Inactive"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 170, 127)
            }
        }
        u4.Highlight = HighlightData
        local IconData = {
            ["Active"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 37, 24)
            },
            ["Inactive"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 170, 127)
            }
        }
        u4.Icon = IconData
        local LineData = {
            ["Active"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 37, 24)
            },
            ["Inactive"] = {
                ["ImageColor3"] = Color3.fromRGB(0, 170, 127)
            }
        }
        u4.Line = LineData
        local TextLabelUI = PlusButton:FindFirstChild("Text")
        for i, Child in TextLabelUI and TextLabelUI:GetChildren() or {} do
            if Child:IsA("TextLabel") then
                TweenService:Create(Child, TweenInfo.new(0.25), {
                    ["TextColor3"] = Active and Color3.fromRGB(0, 37, 24) or Color3.fromRGB(0, 170, 127)
                }):Play()
            elseif Child:IsA("ImageLabel") then
                TweenService:Create(Child, TweenInfo.new(0.25), {
                    ["ImageColor3"] = Active and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(0, 17, 13)
                }):Play()
            end
        end
        local v28 = Active and "Active" or "Inactive"
        for v29, v30 in u4 do
            local v31 = PlusButton:FindFirstChild(v29)
            if v31 then
                TweenService:Create(v31, TweenInfo.new(0.25), v30[v28]):Play()
            end
        end
    end)
end

function GetValue(FeatureName,InstanceOnly)
    local FeatureInstance = Values[FeatureName]
    if not FeatureInstance then
        FeatureInstance = PlusFolderSettings:FindFirstChild(FeatureName,true)
        Values[FeatureName] = FeatureInstance
    end
    if InstanceOnly then
        return FeatureInstance
    else
        return FeatureInstance and FeatureInstance.Value
    end
end

function GetFunction(Function1, Function2)
    return typeof(Function1) == "function" and Function1 or (typeof(Function2) == "function" and Function2) or nil
end

function RichTextGradientColor(Text:string,Colors)
	local Count = 0
    for Char in Text:gmatch(utf8.charpattern) do
        if Char ~= " " then
			Count += 1
		end
	end
	if Count == 0 then return Text end
	local MaxIndex = math.max(1,Count-1)
	local Segments = #Colors-1
	local Result,Used = "",0
    for Char in Text:gmatch(utf8.charpattern) do
		if Char == " " then
			Result..=Char
		elseif Char:byte() >= 128 then
		else
			local T = Used/MaxIndex
			Used += 1
			local Segment= math.min(math.floor(T*Segments),Segments-1)
			Result..=('<font color="#%s">%s</font>'):format(Colors[Segment+1]:Lerp(Colors[Segment+2],T*Segments-Segment):ToHex(),Char)
		end
	end
	return Result
end

local function collidewith(gui1,gui2)
	local gui1_topLeft,gui1_bottomRight = gui1.AbsolutePosition, gui1.AbsolutePosition + gui1.AbsoluteSize
	local gui2_topLeft,gui2_bottomRight = gui2.AbsolutePosition, gui2.AbsolutePosition + gui2.AbsoluteSize
	return ((gui1_topLeft.x < gui2_bottomRight.x and gui1_bottomRight.x > gui2_topLeft.x) and (gui1_topLeft.y < gui2_bottomRight.y and gui1_bottomRight.y > gui2_topLeft.y))
end

function TableValueFind(Table, MatchFn, Seen)
    if type(Table) ~= "table" or type(MatchFn) ~= "function" then
        return nil
    end
    Seen = Seen or {}
    if Seen[Table] then
        return nil
    end
    Seen[Table] = true

    for Key, Value in Table do
        if MatchFn(Key, Value) then
            return Value, Key, Table
        elseif type(Value) == "table" then
            local FoundValue, FoundKey, FoundParent = TableValueFind(Value, MatchFn, Seen)
            if FoundKey ~= nil then
                return FoundValue, FoundKey, FoundParent
            end
        end
    end
    return nil
end

function CanPlayOverrideAnim(Character)
    return Character and Character.Parent and GetValue("AnimationChanger") ~= "Original" and not GetValue("AnimationChanger",true):GetAttribute("StopOverride") and ((GetValue("ChangeInLobby") and Character.Parent.Name == "Spectating") or Character.Parent.Name ~= "Spectating")
end

function GetAnimationType(ID)
    for i,v in AllAnimations do
        for animtype,animId in v do
            if type(animId) == "table" then
                for i2,v2 in animId do
                    if type(v2) == "string" and v2:find(tostring(ID)) then
                        return animtype,i,i2
                    end
                end
            else
                if type(animId) == "string" and animId:find(tostring(ID)) then
                    return animtype,i
                end
            end
        end
    end
end

local function AddOverridenAnimation(ID)
    if LocalCharacter and ID then
        if OverriddenAnimations[ID] then
            return table.unpack(OverriddenAnimations[ID])
        end
        local OverrideFolder = LocalCharacter:FindFirstChild("OverrideAnimation") or Instance.new("Folder", LocalCharacter)
        OverrideFolder.Name = "OverrideAnimation"
        local AnimType,CharName = GetAnimationType(ID) or "Unknown"
        local Animation = Instance.new("Animation")
        Animation.Name = AnimType .. tostring(ID)
        Animation.AnimationId = tostring(ID):find("id") and tostring(ID) or "http://www.roblox.com/asset/?id=" .. tostring(ID)
        Animation.Parent = OverrideFolder
        Animation:SetAttribute("Overriden",true)
        if LocalAnimator then
            local Track = LocalAnimator:LoadAnimation(Animation)
            OverriddenAnimations[ID] = {Track,Animation}
            return Track,Animation
        end
    else
        return
    end
end

local SupportedOverrides = {"idle","walk","run"}
function UpdateAnim(Humanoid)
    local AnimSelected = GetValue("AnimationChanger")
    if not CanPlayOverrideAnim(LocalCharacter) then return end
    local AnimString
    local Type
    if MainModule["IsSprinting"] and Humanoid.MoveDirection ~= Vector3.zero then
        AnimString = AllAnimations[AnimSelected] and AllAnimations[AnimSelected]["Run"]
        Type = "Run"
    elseif Humanoid.MoveDirection ~= Vector3.zero then
        AnimString = AllAnimations[AnimSelected] and AllAnimations[AnimSelected]["Walk"]
        Type = "Walk"
    else
        AnimString = AllAnimations[AnimSelected] and AllAnimations[AnimSelected]["Idle"]
        Type = "Idle"
    end
    if AnimString then
        local FoundAction = false
        for i,v in Humanoid:GetPlayingAnimationTracks() do
            if v.Animation and v.Animation:GetAttribute("Overriden") then
                v:Stop(0.2)
                continue
            end
            if not v.IsPlaying then
                continue
            end
                local AnimType,Char,Name = GetAnimationType(v.Animation.AnimationId)
                local IsSupported = false
                for i,v in SupportedOverrides do
                    if AnimType and AnimType:lower():find(v:lower()) then
                        IsSupported = true
                    end
                end
                if not IsSupported then
                    FoundAction = v
                end
        end
        local OverrideTrack,Animation = AddOverridenAnimation(AnimString)
        if OverrideTrack and CanPlayOverrideAnim(LocalCharacter) then
            OverrideTrack:Play(not FoundAction and 0.1 or 0.3)
        end
    end
end

function DefaultData(Path, Option)
	if isfile("NaikoScript/ForsakenPlus/" .. Path) then
		ColoredPrint("Option already exists", "info", Color3.fromRGB(252, 210, 150))
	else
		writefile("NaikoScript/ForsakenPlus/" .. Path, Option)
		ColoredPrint("Set default data", "success", Color3.fromRGB(125, 230, 75))
	end
    return
end

function ChangeData(Path, Option, WithFolder)
	if WithFolder == false then
		if isfile(Path) then
			writefile(Path,Option)
		end
	else
		if isfile("NaikoScript/ForsakenPlus/" .. Path) then
			writefile("NaikoScript/ForsakenPlus/" .. Path, Option)
		end
	end
end

function ReturnData(Path, WithFolder)
	if WithFolder == false then
		if isfile(Path) ~= false then
			return readfile(Path)
		end
	else
		if isfile("NaikoScript/ForsakenPlus/" .. Path) ~= false then
			return readfile("NaikoScript/ForsakenPlus/" .. Path)
		end
		return nil
	end
end

-- General Scripting --

if not (game.GameId == 6331902150 or game.GameId == 7464167604) then
    FeatureLoadout["Unofficial"] = {
          ["TabAttributes"] = {
            ["DisplayTitle"] = '<font color="rgb(255,166,0)">⚠</font>' .. RichTextGradientColor(" SOME FEATURES MAY NOT WORK HERE ",{Color3.fromRGB(255, 166, 0), Color3.fromRGB(243, 227, 0)}) .. '<font color="rgb(243, 227, 0)">⚠</font>',
            ["LayoutOrder"] = -1
        }
    }
    ColoredPrint("This is not the official game which means some of the features may not work as expected.", "warning", Color3.fromRGB(255, 166, 0))
end

FeatureLoadout["EnviromentFunctions"]["TabAttributes"]["DisplayTitle"] = string.format(
    "Script Made by %s | %s    ",
    RichTextGradientColor("N‎aiko Sc‎ripts",{Color3.fromRGB(0, 255, 128),Color3.fromRGB(0, 102, 255)}),
    RichTextGradientColor("V"..Version,{Color3.fromRGB(87, 160, 255),Color3.fromRGB(0, 132, 255)})
) -- Tryna edit something here?? i can see that... you ain taking that you know..

FeatureLoadout["Visuals"]["DisableNoliNPC"]["DisplayTitle"] = string.format("Disable %s NPC", RichTextGradientColor("Noli's",{Color3.fromRGB(130, 72, 255), Color3.fromRGB(77, 0, 185)}))
FeatureLoadout["Visuals"]["Disable007n7NPC"]["DisplayTitle"] = string.format("Disable %s NPC", RichTextGradientColor("007n7's",{Color3.fromRGB(117, 161, 255), Color3.fromRGB(13, 70, 175)}))
FeatureLoadout["Features"]["NoliControl"]["DisplayTitle"] = string.format("Better %s", RichTextGradientColor("Void Rush",{Color3.fromRGB(240, 90, 253), Color3.fromRGB(141, 0, 197)}))
FeatureLoadout["Features"]["ControllableDash"]["DisplayTitle"] = string.format("Make %s Dash Controllable", RichTextGradientColor("Coolkidd's",{Color3.fromRGB(255, 22, 22), Color3.fromRGB(175, 13, 13)}))
FeatureLoadout["Automation"]["AutoEscape"]["DisplayDescription"] = string.format("Auto-Escapes <b>%s</b> Hook",RichTextGradientColor("Nosferatu's",{Color3.fromRGB(192, 15, 24), Color3.fromRGB(108, 20, 9)}))
FeatureLoadout["Automation"]["AutoDisarm"]["DisplayDescription"] = string.format("Auto-Disarms <b>%s</b> Traps",RichTextGradientColor("Azure's",{Color3.fromRGB(130, 72, 255), Color3.fromRGB(49, 0, 228)}))

local ThreadBindable = Instance.new("BindableEvent")
local CharacterAddedBindable = Instance.new("BindableEvent")
task.spawn(function()
    while task.wait(0.1) do
        ThreadBindable:Fire()
    end
end)

InGame.ChildAdded:Connect(function(Child)
    if Child.Name == "Map" then
        GameMap = Child
    end
end)

if MainUI:FindFirstChild("ClassicSidebar") then
    MainUI:FindFirstChild("ClassicSidebar"):Destroy()
end

local InputDeviceType = {Keyboard = "PC", MouseButton1 = "PC", MouseButton2 = "PC", MouseMovement = "PC", Touch = "Mobile", Gamepad1 = "Console"}
local Device = InputDeviceType[UserInputService:GetLastInputType().Name]
local getgc = GetFunction(getgc, get_gc)
local IsRequireSupported = false

task.spawn(function()
    local generaltest,result = pcall(function()
        return require(LocalPlayer:FindFirstChildOfClass("PlayerScripts"):FindFirstChild("PlayerModule"))
    end)
    local s,Err = pcall(function()
        LogService:Info("",result)
    end)
    local Success,Result
    if tostring(Err):find("cyclic") or s then
        if s then
            --ColoredPrint("Require does not function completely correctly some features could bug out!","warn", Color3.new(1,0.25,0))
        end 
        if Device == "PC" then
            Success, Result = pcall(function()
                local Module = require(ReplicatedStorage:WaitForChild("Systems",4):WaitForChild("Character",4):WaitForChild("Game",4):WaitForChild("Sprinting",4))
                if Module and type(Module) == "table" and Module["StaminaChanged"] then
                    IsRequireSupported = true
                    return Module
                end
            end)
        else
            Success, Result = pcall(function()
                for i,Object in getgc(true) do
                    if type(Object) == "table" then
                        if rawget(Object, "Stamina") and rawget(Object, "StaminaChanged") then
                            return Object
                        end
                    end
                end
            end)
        end
    end
    if not (Success and type(Result) == "table") then
        FeatureLoadout["EnviromentFunctions"]["require"]["DefaultInstanceValue"] = false
    else
        IsRequireSupported = true
        MainModule = Result
    end
    local AnimationPreset = FeatureLoadout["Features"]["AnimationChanger"]
    if IsRequireSupported and KillerAssets and SurvivorAssets and SkinsAssets then
        if ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Util",true) then
            --UtilModule = require(ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("Util",true))
        end
        local AllAssets = {}
        for i,v in KillerAssets:QueryDescendants("ModuleScript#Config") do
            table.insert(AllAssets,v)
        end
        for i,v in SurvivorAssets:QueryDescendants("ModuleScript#Config") do
            table.insert(AllAssets,v)
        end
        for i,v in SkinsAssets:QueryDescendants("ModuleScript#Config") do
            table.insert(AllAssets,v)
        end
        for i,ConfigModule in AllAssets do
            if ConfigModule.Parent:IsA("Model") then continue end
            local ConfigData = require(ConfigModule)
            local AnimationData = ConfigData and ConfigData.Animations
            if ConfigModule.Parent.Name == "Noli" and ConfigData and TableValueFind(ConfigData, function(Key, Value) return type(Key) == "string" and Key:find("InitialTurnMult") end) then
                NoliConfig = ConfigData
            end
            if ConfigModule.Parent.Name == "TwoTime" and AnimationData and TableValueFind(AnimationData, function(Key, Value) return type(Key) == "string" and Key:find("CrouchIdle") end) then
                AllAnimations["Crouch"] = {["Idle"] = AnimationData["CrouchIdle"],["Walk"] = AnimationData["CrouchWalk"],["Run"] = AnimationData["CrouchRun"]}
            end
            if ConfigModule.Parent.Name == "1x1x1x1" and AnimationData and TableValueFind(ConfigData, function(Key, Value) return type(Key) == "string" and Key:find("ZombieAnimations") end) then
                AllAnimations["NPC Zombie"] = TableValueFind(ConfigData, function(Key, Value) return type(Key) == "string" and Key:find("ZombieAnimations") end)
            end
            if not AnimationData or not ConfigData.DisplayName then continue end
            local ChosenName = ConfigData.DisplayName:find("Milestone") and string.format("%s %s",ConfigModule.Parent.Parent.Name,ConfigData.DisplayName:gsub("Milestone ","")) or ConfigData.DisplayName
            AnimationData["OriginalCharacter"] = ConfigModule.Parent
            AllAnimations[ChosenName] = AnimationData
        end
        for i,v in string.split(AnimationPreset["ExtraData"]["Options"], "|") do
            if v ~= "Original" then
                if not AllAnimations[v] or not AllAnimations[v]["Idle"] then
                    AnimationPreset["ExtraData"]["Options"] = AnimationPreset["ExtraData"]["Options"]:gsub("|" .. v, "",1)
                end
            end
        end
        if AnimationPreset["ExtraData"]["Options"]:gsub("|Default Roblox","") == "Original" then
            AnimationPreset["Requirement"] = true
        end
        --[[if UtilModule then
            local AllPlayersSideUI = MainUI:FindFirstChild(LocalPlayer.Name,true) and MainUI:FindFirstChild(LocalPlayer.Name,true).Parent
            local function HandlePlayerForUI(Player)
                if AllPlayersSideUI:FindFirstChild(Player.Name) then
                    local PlayersUI = AllPlayersSideUI:FindFirstChild(Player.Name)
                    local PlayersData = Player:FindFirstChild("PlayerData")
                    local Settings = PlayersData and PlayersData:FindFirstChild("Settings")
                    local Pron = Settings and Settings:FindFirstChild("Pronouns",true)
                    if Pron and Pron.Value == "discord.gg/Fs47aNrdGF" then
                        local NoChat = PlayersUI:FindFirstChild("NoChat")
                        if NoChat then
                            NoChat.Visible = false
                        end
                        local ClonedUI = ReplicatedStorage:FindFirstChild("NoChat",true) and ReplicatedStorage:FindFirstChild("NoChat",true):Clone()
                        if ClonedUI then
                            ClonedUI.Name = "FSUser"
                            ClonedUI.Image = "rbxassetid://118860705115878"
                            ClonedUI.Parent = PlayersUI
                            ClonedUI.Visible = true
                            ClonedUI.AnchorPoint = Vector2.new(0.5,0.425)
                            ClonedUI.MouseEnter:Connect(function()
                                UtilModule:CreateTooltip("This is a Forsaken Plus user.")
                            end)
                            ClonedUI.MouseLeave:Connect(function()
                                UtilModule:CreateTooltip("")
                            end)
                            if ClonedUI:FindFirstChildOfClass("UIAspectRatioConstraint") then
                                ClonedUI:FindFirstChildOfClass("UIAspectRatioConstraint").AspectRatio = 1
                            end
                        end
                    end
                end
            end
            if AllPlayersSideUI then
                for i,v in Players:GetPlayers() do
                    HandlePlayerForUI(v)
                end
                Players.PlayerAdded:Connect(function(v)
                    task.delay(1.5,function() HandlePlayerForUI(v) end)
                end)
            else
                ColoredPrint("Failed to find PlayerList UI","error")
            end
        end]]
    else
        AnimationPreset["Requirement"] = true
    end
    if not NoliConfig then
        FeatureLoadout["Features"]["NoliControl"]["Requirement"] = true
    end
end)





local function ActionOnCharacter(Character)
    task.spawn(SetButtonState,false)
    LocalCharacter = Character
    LocalHumanoid = LocalCharacter and (LocalCharacter:FindFirstChildOfClass("Humanoid") or LocalCharacter:WaitForChild("Humanoid",2)) or nil
    LocalHead = LocalCharacter and (LocalCharacter:FindFirstChild("Head") or LocalCharacter:WaitForChild("Head",2)) or nil
    LocalRoot = LocalCharacter and ((LocalHumanoid and LocalHumanoid.RootPart) or LocalCharacter:FindFirstChild("HumanoidRootPart") or LocalCharacter:WaitForChild("HumanoidRootPart",2)) or nil
    LocalAnimator = LocalHumanoid and (LocalHumanoid:FindFirstChildOfClass("Animator") or LocalHumanoid:WaitForChild("Animator",2)) or nil
    SpeedMultipliers = LocalCharacter and (Character:FindFirstChild("SpeedMultipliers") or Character:WaitForChild("SpeedMultipliers",5)) or nil
    ResistanceMultipliers = LocalCharacter and (Character:FindFirstChild("ResistanceMultipliers") or Character:WaitForChild("ResistanceMultipliers",5)) or nil
    FOVMultipliers = LocalCharacter and (Character:FindFirstChild("FOVMultipliers") or Character:WaitForChild("FOVMultipliers",5)) or nil
    CharacterAddedBindable:Fire()
end



if not MainModule then
    ColoredPrint("Failed to load required modules, some features may be hidden.\n use a different executor that supports 'require' and 'getgc'", "warn", Color3.new(1,0.25,0))
    FeatureLoadout["EnviromentFunctions"]["getgc"]["DefaultInstanceValue"] = false
end

if FeatureLoadout["EnviromentFunctions"]["getgc"]["DefaultInstanceValue"] then
    task.spawn(function()
        if game.GameId ~= 6331902150 then
            task.wait(0.5)
            if IsRequireSupported then
                for i,v in getgc(true) do
                    if type(v) == type({}) then
                        if not rawget(v,"Idle") or not rawget(v,"Run") then if i%250 == 0 then task.wait() end continue end
                        local num = 0
                        for i,v in v do
                            num += 1
                        end
                        if num > 3 then
                            AllAnimations[HttpService:GenerateGUID(false):sub(1,5)] = v
                        end
                    end
                end
            end
        end
    end)
end


--local readfile = GetFunction(readfile, read_file)
--local writefile = GetFunction(writefile, write_file)
--local isfolder = GetFunction(isfolder, is_folder)
--local isfile = GetFunction(isfile, is_file)
--local makefolder = GetFunction(makefolder, make_folder)
local UserType = 1
if not (readfile and writefile and isfolder and isfile) then
    FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] = false
else
    if not isfolder("NaikoScript") and not isfolder("NaikoScript/ForsakenPlus") then
        makefolder("NaikoScript")
        makefolder("NaikoScript/ForsakenPlus")
        UserType = 1
    elseif isfolder("NaikoScript") and not isfolder("NaikoScript/ForsakenPlus") then
        UserType = 2
        makefolder("NaikoScript/ForsakenPlus")
    elseif isfolder("NaikoScript") and isfolder("NaikoScript/ForsakenPlus") then
        UserType = 3
    end
    DefaultData("Data.txt", "{}")
    DefaultData("AccountType.txt","{}")
    makefolder("NaikoScript/ForsakenPlus/Plugins")
end

if UserType < 3 then
    task.spawn(function()
        Arrow.Visible = true
        local MovingTween = TweenService:Create(Arrow, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Position = UDim2.fromScale(1.4, 0.5)})
        MovingTween:Play()
        SidePlusButton.Button.MouseEnter:Wait()
        local DisappearTween = TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1.6, 0.5),Size = UDim2.fromScale(0.2, 0.2),ImageTransparency = 1})
        MovingTween:Pause()
        MovingTween:Cancel()
        DisappearTween:Play()
        DisappearTween.Completed:Wait()
        Arrow.Visible = false
    end)
end

if not hookmetamethod and not (getrawmetatable and setreadonly) or not getnamecallmethod then
    FeatureLoadout["EnviromentFunctions"]["hookmetamethod"]["DefaultInstanceValue"] = false
end

if GetValue("OfficialGame") then
    task.spawn(function()
        local FrequencyData = HttpService:JSONDecode(ReturnData("AccountType.txt", true))
        FrequencyData["Normal"] = FrequencyData["Normal"] or 0
        FrequencyData["New"] = FrequencyData["New"] or 0
        ChangeData("AccountType.txt",HttpService:JSONEncode(FrequencyData),true)
        if GetValue("PrivateServer") then return end
        for i,v in Players:GetPlayers() do if v:IsFriendsWithAsync(LocalPlayer.UserId) then return end end
        if UserType < 3 then
            task.wait(26)
            if PlayerGui:FindFirstChild("LoadingGui") then return end
            if game.PlaceId ~= 83645629621104 then
                FrequencyData["Normal"] = 3
            else
                FrequencyData["New"] = 5
            end
        else
            task.wait(18)
            if PlayerGui:FindFirstChild("LoadingGui") then return end
            if game.PlaceId ~= 83645629621104 then
                FrequencyData["Normal"] += 2
                FrequencyData["New"] -= 1
            else
                FrequencyData["New"] += 2
                FrequencyData["Normal"] -= 1
            end
        end
        ChangeData("AccountType.txt",HttpService:JSONEncode(FrequencyData),true)
    end)
end

LocalPlayer.CharacterAdded:Connect(ActionOnCharacter)

TeleportSound = Instance.new("Sound")
TeleportSound.Name = "TeleportSound"
TeleportSound.SoundId = "rbxassetid://130359426691991"
TeleportSound.Parent = CoreGui
TeleportSound.Volume = 0.001
TeleportSound:Play()

RoundEvent.Event:Connect(function(Data)
    IsUnderground = false
end)

local Graf2 = workspace:FindFirstChild("Graf2",true)
if Graf2 and math.round(Graf2.Position.X) == -3600 and Graf2:FindFirstChildWhichIsA("ImageLabel",true) then
    Graf2.Position = Vector3.new(-3600, 19.25, 232.5)
    Graf2.Size = Vector3.new(4.25, 1.5, 0.13)
    Graf2.Rotation = Vector3.new(7, 90, 0)
    Graf2:FindFirstChildWhichIsA("ImageLabel",true).Image = "rbxassetid://86461599034861"
    Graf2:FindFirstChildWhichIsA("ImageLabel",true).ImageTransparency = 0.2
end

local BaseTweenInfo = TweenInfo.new(0.25)
local MenuData
if NewUIVersion then
    local suc,err
    if IsRequireSupported then
        suc,err = pcall(function()
            MenuData = require(ReplicatedStorage.Systems.Player:FindFirstChild("SidebarHandler",true))
        end)
    end
    if not suc or not MenuData then
        IsRequireSupported = false
        FeatureLoadout["EnviromentFunctions"]["require"]["DefaultInstanceValue"] = false
    end
    local UseFallbackUI = NewUIVersion
    if UseFallbackUI then
    	local FallbackSignal = {}
    	FallbackSignal.__index = FallbackSignal
    	function FallbackSignal.new()
    		local self = setmetatable({}, FallbackSignal)
    		local Bindable = Instance.new("BindableEvent")
    		self._bindable = Bindable
    		self.Event = Bindable.Event
    		function self:Fire(...)
    			self._bindable:Fire(...)
    		end
    		function self:Connect(...)
    			return self._bindable.Event:Connect(...)
    		end
    		return self
    	end
    	local FallbackTween = TweenInfo.new(0.25)
    	local FallbackSizes = {
    		["Middle"] = {
    			["Enter"] = UDim2.fromScale(0.985, 0.25),
    			["Exit"] = UDim2.fromScale(0.95, 0.22)
    		},
    		["Bottom"] = {
    			["Enter"] = UDim2.fromScale(0.645, 0.18),
    			["Exit"] = UDim2.fromScale(0.606, 0.149)
    		}
    	}
    	local FallbackLook = {
    		["BG"] = {["Active"] = {["ImageColor3"] = Color3.fromRGB(198, 198, 198)}, ["Inactive"] = {["ImageColor3"] = Color3.fromRGB(8, 8, 8)}},
    		["GrungeMain"] = {["Active"] = {["ImageColor3"] = Color3.fromRGB(0, 0, 0)}, ["Inactive"] = {["ImageColor3"] = Color3.fromRGB(80, 80, 80)}},
    		["Grunge"] = {["Active"] = {["ImageColor3"] = Color3.fromRGB(255, 255, 255)}, ["Inactive"] = {["ImageColor3"] = Color3.fromRGB(0, 0, 0)}},
    		["Highlight"] = {["Active"] = {["ImageColor3"] = Color3.fromRGB(0, 0, 0)}, ["Inactive"] = {["ImageColor3"] = Color3.fromRGB(255, 255, 255)}},
    		["Icon"] = {["Active"] = {["ImageColor3"] = Color3.fromRGB(0, 0, 0)}, ["Inactive"] = {["ImageColor3"] = Color3.fromRGB(255, 255, 255)}},
    		["Line"] = {["Active"] = {["ImageColor3"] = Color3.fromRGB(0, 0, 0)}, ["Inactive"] = {["ImageColor3"] = Color3.fromRGB(255, 255, 255)}}
    	}
    	local FallbackButton = {}
    	FallbackButton.__index = FallbackButton
    	function FallbackButton.new(ButtonFrame, Section)
    		local self = setmetatable({}, FallbackButton)
    		self.Instance = ButtonFrame
    		self.onClick = FallbackSignal.new()
    		ButtonFrame.MouseEnter:Connect(function()
    			local Sizes = FallbackSizes[Section]
    			if Sizes then
    				TweenService:Create(ButtonFrame, FallbackTween, {["Size"] = Sizes.Enter}):Play()
    			end
    			PlaySound("hover")
    		end)
    		ButtonFrame.MouseLeave:Connect(function()
    			local Sizes = FallbackSizes[Section]
    			if Sizes then
    				TweenService:Create(ButtonFrame, FallbackTween, {["Size"] = Sizes.Exit}):Play()
    			end
    			PlaySound("hoverEnd")
    		end)
    		return self
    	end
    	function FallbackButton.LoadMenu(self, MenuTable)
    		self.Menu = MenuTable
    		self.Instance.Button.MouseButton1Click:Connect(function()
    			self.onClick:Fire()
    			self.Menu:ToggleMenu()
    		end)
    	end
    	function FallbackButton.SetAppearanceState(self, State)
    		local Text = self.Instance.Button:FindFirstChild("Text")
    		for i, v in Text and Text:GetChildren() or {} do
    			if v:IsA("TextLabel") then
    				TweenService:Create(v, FallbackTween, {["TextColor3"] = State and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)}):Play()
    			elseif v:IsA("ImageLabel") then
    				TweenService:Create(v, FallbackTween, {["ImageColor3"] = State and Color3.fromRGB(224, 224, 224) or Color3.fromRGB(0, 0, 0)}):Play()
    			end
    		end
    		local Key = State and "Active" or "Inactive"
    		for i, v in FallbackLook do
    			local Target = self.Instance.Button:FindFirstChild(i)
    			if Target then
    				TweenService:Create(Target, FallbackTween, v[Key]):Play()
    			end
    		end
    	end
    	MenuData = {
    		["SidebarMenus"] = {},
    		["SidebarButtons"] = {},
    		["PendingSidebarMenus"] = {},
    		["TogglingMenus"] = nil,
    		["MenusHidden"] = false,
    		["onTransitionState"] = FallbackSignal.new(),
    		["onMenuSwitched"] = FallbackSignal.new(),
    		["CashDisplay"] = MainUI:FindFirstChild("CashDisplay", true),
    		["Sidebar"] = SideBar
    	}
    	MenuData.__index = MenuData
    	local function LoadFallbackButton(Name, MenuTable)
    		local Stored = MenuData.SidebarButtons[Name]
    		if not Stored then
    			MenuData.PendingSidebarMenus[Name] = MenuTable
    			return false
    		end
    		Stored.onClick:Connect(function()
    			MenuData.onMenuSwitched:Fire(Name)
    		end)
    		local suc, err = pcall(function()
    			Stored:LoadMenu(MenuTable)
    		end)
    		if not suc then
    			warn(`Failed to load Sidebar Menu '{Name}' | Button: {err}`)
    			return false
    		end
    		MenuTable.Button = Stored
    		MenuData.PendingSidebarMenus[Name] = nil
    		return true
    	end
    	local function CloseFallbackMenu(MenuEntry)
    		MenuEntry.Toggled:Fire(false)
    		local Blur = Lighting:FindFirstChild("ShopBlur")
    		if Blur then
    			TweenService:Create(Blur, FallbackTween, {["Size"] = 0}):Play()
    			Debris:AddItem(Blur, 0.25)
    		end
    		local Zoom = FOVMultipliers:FindFirstChild("ShopZoom")
    		if Zoom and Zoom:IsA("ValueBase") then
    			TweenService:Create(Zoom, FallbackTween, {["Value"] = 1}):Play()
    			Debris:AddItem(Zoom, 0.25)
    		end
    		if MenuEntry.MenuName == "Shop" or MenuEntry.MenuName == "UpdateLog" then
    			MenuEntry.Menu.Visible = false
    			MenuEntry.Menu:SetAttribute("Visible", false)
    		else
    		TweenService:Create(MenuEntry.Menu, FallbackTween, {["Size"] = UDim2.new(1, -20, 0, 0)}):Play()
    		task.delay(0.25, function()
    			MenuEntry.Menu.Visible = false
                MenuEntry.Menu:SetAttribute("Visible", false)
    		end)
    		end
    		if MenuEntry.Button and MenuEntry.MenuName ~= "Plus" then
    			MenuEntry.Button:SetAppearanceState(false)
    		end
    	end
    	local function OpenFallbackMenu(MenuEntry)
    		MenuEntry.Toggled:Fire(true)
    		MenuEntry.Menu.Visible = true
            MenuEntry.Menu:SetAttribute("Visible", true)
    		TweenService:Create(MenuEntry.Menu, FallbackTween, {["Size"] = UDim2.new(1, -20, 1, -20)}):Play()
    		if MenuEntry.Button and MenuEntry.MenuName ~= "Plus" then
    			MenuEntry.Button:SetAppearanceState(true)
    		end
    	end
    	function MenuData.ToggleMenu(selfdata, OnlyOpen)
    		local DataSideBar = selfdata._sidebar
    		if DataSideBar.TogglingMenus then
    			return
    		elseif DataSideBar.MenusHidden and selfdata.SidebarButton then
    			return
    		elseif OnlyOpen and selfdata.Menu.Visible then
    			return
    		end
    		DataSideBar.TogglingMenus = true
    		SidePlusButton.Parent.Interactable = false
            task.delay(0.35, function()
                SidePlusButton.Parent.Interactable = true
            end)
    		local VisibleUI = selfdata.Menu.Visible
    		PlaySound("select")
    		local SideBarMenu
    		for i, v in DataSideBar.SidebarMenus do
    			if v.Menu ~= selfdata.Menu or VisibleUI then
    				if v.Menu ~= selfdata.Menu and v.Menu.Visible then
    					SideBarMenu = v
    				end
    				if v.Menu.Visible then
    					CloseFallbackMenu(v)
    					SetButtonState(false)
    				end
    			end
    		end
    		task.delay(0.3 + (SideBarMenu and 0.125 or 0), function()
    			DataSideBar.TogglingMenus = nil
    		end)
    		if SideBarMenu then
    			task.wait(0.125)
    			if DataSideBar.MenusHidden then
    				DataSideBar.TogglingMenus = nil
    				return
    			end
    		end
    		if not VisibleUI then
    			OpenFallbackMenu(selfdata)
    			SetButtonState(true)
    		else
    			SetButtonState(false)
    		end
    	end
    	function MenuData.ToggleButtons(self, State)
    		MenuData.onTransitionState:Fire(State)
    		SetButtonState(false)
    		for i, v in MenuData.SidebarMenus do
    			CloseFallbackMenu(v)
    			if v.Button then
    				v.Button:SetAppearanceState(false)
    			end
    			task.delay(0.25, function()
    				v.Menu.Visible = false
                    v.Menu:SetAttribute("Visible", false)
    			end)
    		end
    	end
    	function MenuData.ToggleSidebarButtons(self, State)
    		MenuData.MenusHidden = not State
    		MenuData.Sidebar.Visible = State
    		if State then
    			return
    		end
    		self:ToggleButtons(State)
    	end
    	function MenuData.CreateSidebarMenu(self, MenuName, MenuScreen)
    		local Metaverse = setmetatable({}, MenuData)
    		Metaverse.Menu = MenuScreen:Clone()
    		Metaverse.Toggled = FallbackSignal.new()
    		Metaverse.Button = nil
    		Metaverse.MenuName = MenuName
    		Metaverse.Menu.Visible = false
    		Metaverse.Menu.Size = UDim2.fromScale()
    		Metaverse.Menu.Parent = MainUI
    		for i, v in Metaverse.Menu:QueryDescendants("ScrollingFrame") do
    			v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    				v.ScrollBarThickness = v.AbsoluteSize.X / 44
    			end)
    		end
    		Metaverse._sidebar = self
    		Metaverse.SidebarButton = SideBar:FindFirstChild(MenuName, true)
    		MenuData.SidebarMenus[MenuName] = Metaverse
    		LoadFallbackButton(MenuName, Metaverse)
    		return Metaverse
    	end
    	for i, v in SideBar:GetChildren() do
    		for i, v2 in v:GetChildren() do
    			if v2:IsA("Frame") then
    				MenuData.SidebarButtons[v2.Name] = FallbackButton.new(v2, v.Name)
    				local Waiting = MenuData.PendingSidebarMenus[v2.Name]
    				if Waiting then
    					LoadFallbackButton(v2.Name, Waiting)
    				end
    			end
    		end
    	end
    end
    else
    MenuData = {
        ["SidebarMenus"] = {},
        ["Sidebars"] = {
            ["Sidebar"] = MainUI.Sidebar,
            ["Bottombar"] = MainUI.Sidebar:FindFirstChild("Bottombar") or nil
        }
    }
    MenuData.__index = MenuData
    function MenuData.CreateSidebarMenu(self, ButtonName, Menu, Bottom)
        local Data = setmetatable({}, MenuData)
        Data.Menu = Menu
        Data.Menu.Visible = false
        Data.Menu.Size = UDim2.fromScale()
        Data.Menu.Parent = MainUI
        Data.SidebarButton = Buttons:FindFirstChild(ButtonName)
        local BindableEvent = Instance.new("BindableEvent")
        BindableEvent.Parent = Data.Menu
        Data.Toggled = BindableEvent.Event
        Data.__toggleEvent = BindableEvent
        for i,v in pairs(Data.Menu:QueryDescendants("ScrollingFrame")) do
            v:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                v.ScrollBarThickness = v.AbsoluteSize.X / 44
            end)
        end
        self.SidebarMenus[ButtonName] = Data
        return Data
    end
    function MenuData.ToggleMenu(UIData, p24)
        if MenuData.TogglingMenus then
            return
        elseif MenuData.MenusHidden and UIData.SidebarButton then
            return
        elseif not (p24 and UIData.Menu.Visible) then
            MenuData.TogglingMenus = true
            PlaySound("select")
            local Visible = UIData.Menu.Visible
            SidePlusButton.Parent.Interactable = false
            task.delay(0.35, function()
                SidePlusButton.Parent.Interactable = true
            end)
            for i,Menu in pairs(MenuData.SidebarMenus) do
                if Menu.Menu ~= UIData.Menu or Visible then
                    if Menu.Menu.Visible then
                        Menu.__toggleEvent:Fire(false)
                        
                        TweenService:Create(Menu.Menu, BaseTweenInfo, {["Size"] = UDim2.new(1, -20, 0, 0)}):Play()
                        if Menu.SidebarButton then
                            if Menu.SidebarButton:FindFirstChild("Inverted") then
                                TweenService:Create(Menu.SidebarButton.Inverted, BaseTweenInfo, {["ImageTransparency"] = 1}):Play()
                            end
                            if Menu.SidebarButton:FindFirstChild("InvertedIcon") then
                                TweenService:Create(Menu.SidebarButton.InvertedIcon, BaseTweenInfo, {["ImageTransparency"] = 1}):Play()
                            end
                            if Menu.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Inverted") then
                                TweenService:Create(Menu.SidebarButton.PulloutHolder.PulloutFrame.Inverted, BaseTweenInfo, {["ImageTransparency"] = 1}):Play()
                            end
                            if Menu.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Title") then
                                TweenService:Create(Menu.SidebarButton.PulloutHolder.PulloutFrame.Title, BaseTweenInfo, {
                                    ["TextColor3"] = Menu.Menu.Name == "PlusScreen" and Color3.fromRGB(0, 170, 127) or Color3.new(1,1,1)
                                }):Play()
                            end
                        end
                        task.delay(0.25, function()
                            Menu.Menu:SetAttribute("Visible", false)
                            Menu.Menu.Visible = false
                        end)
                    end
                end
            end
            task.delay(0.3, function()
                MenuData.TogglingMenus = nil
            end)
            if MenuData.MenusHidden then
                return
            end
            if not Visible then
                UIData.__toggleEvent:Fire(true)
                UIData.Menu:SetAttribute("Visible", true)
                UIData.Menu.Visible = true
                TweenService:Create(UIData.Menu, BaseTweenInfo, {["Size"] = UDim2.new(1, -20, 1, -20)}):Play()
                if UIData.SidebarButton then
                    if UIData.SidebarButton:FindFirstChild("Inverted") then
                        TweenService:Create(UIData.SidebarButton.Inverted, BaseTweenInfo, {["ImageTransparency"] = 0}):Play()
                    end
                    if UIData.SidebarButton:FindFirstChild("InvertedIcon") then
                        TweenService:Create(UIData.SidebarButton.InvertedIcon, BaseTweenInfo, {["ImageTransparency"] = 0}):Play()
                    end
                    if UIData.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Inverted") then
                        TweenService:Create(UIData.SidebarButton.PulloutHolder.PulloutFrame.Inverted, BaseTweenInfo, {["ImageTransparency"] = 0}):Play()
                    end
                    if UIData.SidebarButton.PulloutHolder.PulloutFrame:FindFirstChild("Title") then
                        TweenService:Create(UIData.SidebarButton.PulloutHolder.PulloutFrame.Title, BaseTweenInfo, {["TextColor3"] = Color3.fromRGB(0, 170, 127)}):Play()
                    end
                end
            end
        end
    end
end
ModulesOptions = {
    ["Textbox"] = [=[
        local u1 = {}
        u1.__index = u1
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u2, p3, u4)
            if not u2 then
                u2 = Instance.new("StringValue")
                u2.Name = "SettingValue"
            end
            local v6 = u1
            local u7 = setmetatable({
                ["SettingValue"] = u2
            }, v6)
            u7.Value = u2.Value
            u7.Instance = p3 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.Textbox.Textbox:Clone()
            u7.Instance.TextboxBackground.Textbox.Focused:Connect(function()
                PlaySound("click")
            end)
            u7.Instance.TextboxBackground.Textbox.FocusLost:Connect(function()
                if u2.Name == "SettingValue" or u2.Name == "Value" then
                    u7.Value = u7.Instance.TextboxBackground.Textbox.Text
                    u7:OnUpdate()
                    if u4 then
                        u4(u7.Value)
                    end
                else
                    u2.Value = u7.Instance.TextboxBackground.Textbox.Text
                end
                PlaySound("click")
            end)
            return u7
        end
        function u1.OnUpdate(p8)
            p8.Instance.TextboxBackground.Textbox.Text = p8.Value or ""
        end
        return u1
    ]=],
    ["String"] = [=[
        local u1 = {}
        u1.__index = u1
        local u2 = 200
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u3, p4, u5)
            if not u3 then
                u3 = Instance.new("StringValue")
                u3.Name = "SettingValue"
            end
            local v7 = u1
            local u8 = setmetatable({
                ["SettingValue"] = u3
            }, v7)
            u8.Value = u3.Value
            u8.Instance = p4 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.String.Dropdown:Clone()
            u8.DropdownVisible = false
            local UIListLayout = u8.Instance.DropdownFrame.Options:FindFirstChildOfClass("UIListLayout") or Instance.new("UIListLayout")
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Parent = u8.Instance.DropdownFrame.Options
            u8.Instance.DropdownFrame.MouseButton1Click:Connect(function()
                PlaySound("click")
                local MainZIndex = u8.Instance.LayoutOrder
                u8.DropdownVisible = not u8.DropdownVisible
                u8.Instance.DropdownFrame.DropdownArrow.Rotation = u8.DropdownVisible and 180 or 0
                u8.Instance.DropdownFrame.Options.Visible = u8.DropdownVisible
                u8.Instance.ZIndex = 50000 - (MainZIndex * 2) 
                for i, v9 in pairs(u8.Instance.DropdownFrame.Options:GetChildren()) do
                    if v9:IsA("GuiObject") then
                        v9:Destroy()
                    end
                end
                local function Update()
                    local v10 = u3:GetAttribute("Options")
                    if v10 then
                        v10 = string.split(u3:GetAttribute("Options"), "|")
                    end
                    for i, v9 in pairs(u8.Instance.DropdownFrame.Options:GetChildren()) do
                        if v9:IsA("GuiObject") then
                            v9:Destroy()
                        end
                    end
                    for v11, u12 in pairs(v10 or {}) do
                        local v13 = game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.String.DropdownOption:Clone()
                        v13.Name = u12
                        v13.LayoutOrder = v11
                        v13.Title.Text = v13.Name
                        v13.Parent = u8.Instance.DropdownFrame.Options
                        v13.MouseButton1Click:Connect(function()
                            if u3.Name == "SettingValue" or u3.Name == "Value" then
                                u8.Value = u12
                                u8:OnUpdate()
                                if u5 then
                                    u5(u8.Value)
                                end
                            else
                                u3.Value = u12
                            end
                            PlaySound("switch0".. tostring(math.random(1,4)))
                        end)
                    end
                end
                Update()
                u3:GetAttributeChangedSignal("Options"):Connect(Update)
            end)
            return u8
        end
        function u1.OnUpdate(p14)
            p14.Instance.DropdownFrame.ChosenValue.Title.Text = p14.Value
            p14.Instance.DropdownFrame.Options.Visible = false
            p14.Instance.DropdownFrame.DropdownArrow.Rotation = 0
            p14.DropdownVisible = false
        end
        return u1
    ]=],
    ["Number"] = [=[
        local u1 = {}
        u1.__index = u1
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u2, p3, u4)
            if not u2 then
                u2 = Instance.new("NumberValue")
                u2.Name = "SettingValue"
            end
            local v6 = u1
            local u7 = setmetatable({
                ["SettingValue"] = u2
            }, v6)
            u7.Instance = p3 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.Number.Slider:Clone()
            u7.Value = u2.Value
            local u8 = u7.Instance.DragBar
            local u9 = u8.Dragger
            local u10 = game.Players.LocalPlayer:GetMouse()
            local u11 = u2:GetAttribute("MinValue")
            u2:GetAttributeChangedSignal("MinValue"):Connect(function()
                u11 = u2:GetAttribute("MinValue")
            end)
            local u12 = u2:GetAttribute("MaxValue")
            u2:GetAttributeChangedSignal("MaxValue"):Connect(function()
                u12 = u2:GetAttribute("MaxValue")
            end)
            local u13 = u2:GetAttribute("Step")
            u2:GetAttributeChangedSignal("Step"):Connect(function()
                u13 = u2:GetAttribute("Step")
            end)
            u7.__displayValue = Instance.new("NumberValue")
            u7.__displayValue.Name = "__displayValue"
            u7.__displayValue.Value = u2.Value
            u7.__displayValue.Parent = u7.Instance
            u7.__displayValue:GetPropertyChangedSignal("Value"):Connect(function()
                local v14 = u9.Title
                local v15 = u7.__displayValue.Value
                local v16 = tonumber(string.format("%.10g", math.floor((v15/u13) + 0.5) * u13))
                v14.Text = v16
            end)
            local v17 = u9.Title
            local v18 = u7.__displayValue.Value
            local v19 = tonumber(string.format("%.10g", math.floor((v18/u13) + 0.5) * u13))
            v17.Text = tostring(v19)
            u9.MouseButton1Down:Connect(function()
                u7.Dragging = true
                PlaySound("switch0" .. tostring(math.random(1, 4)))
                while task.wait() and u7.Dragging do
                    local v20 = u10.X
                    local v21 = u8.AbsoluteSize.X
                    local v22 = (v20 - u8.AbsolutePosition.X) / v21
                    local v23 = u11
                    local v24 = u12
                    local v25 = v23 + (v24 - v23) * v22
                    local v26 = math.clamp(v25, v23, v24)
                    local RoundedNumber = tonumber(string.format("%.10g", math.floor((v26/u13) + 0.5) * u13))
                    local v27 = u13
                    if v27 ~= 0 or not v26 then
                        local v28 = (v26 + v27 / 2) / v27
                        v26 = math.floor(v28) * v27
                    end
                    if u7.Value ~= RoundedNumber then
                        PlaySound("tick0"..tostring(math.random(1,3)), {
                            ["Volume"] = 0.025
                        })
                        u7.Value = RoundedNumber
                        u7:OnUpdate()
                        if u7.__updatedEvent then
                            u7.__updatedEvent:Fire()
                        end
                    end
                end
            end)
            game.UserInputService.InputEnded:Connect(function(p29)
                if u7.Dragging then
                    if p29.UserInputType == Enum.UserInputType.MouseButton1 or (p29.UserInputType == Enum.UserInputType.Touch or p29.UserInputType == Enum.UserInputType.Gamepad1 and p29.KeyCode == Enum.KeyCode.ButtonR2) then
                        u7.Dragging = false
                        PlaySound("switch0".. tostring(math.random(1,4)))
                        if u2.Name ~= "SettingValue" and u2.Name ~= "Value" then
                            u2.Value = u7.Value
                        end
                        u7:OnUpdate()
                        if u4 then
                            u4(u7.Value)
                        end
                    end
                end
            end)
            return u7
        end
        function u1.OnUpdate(p30)
            local v31 = p30.SettingValue:GetAttribute("MinValue")
            local v32 = p30.SettingValue:GetAttribute("MaxValue")
            local v33 = (p30.Value - v31) / (v32 - v31)
            local v34 = math.clamp(v33, 0, 1)
            local v35 = p30.Instance.DragBar.Dragger
            local v36 = math.clamp(v34, 0, 1)
            game.TweenService:Create(v35, TweenInfo.new(0.1), {
                ["Position"] = UDim2.fromScale(v36, 0.5)
            }):Play()
            game.TweenService:Create(p30.__displayValue, TweenInfo.new(0.1), {
                ["Value"] = p30.Value
            }):Play()
        end
        return u1
    ]=],
    ["Keybind"] = [=[
        local u1 = {}
        u1.__index = u1
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u2, p3)
            if not u2 then
                u2 = Instance.new("StringValue")
                u2.Name = "SettingValue"
            end
            local v6 = u1
            local u7 = setmetatable({
                ["SettingValue"] = u2
            }, v6)
            u7.Instance = p3 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.Keybind.KeybindFrame:Clone()
            u7.IsKeybind = true
            local u8 = {
                "None",
                "Unknown",
                "MouseMovement",
                "Focus",
                "Accelerometer",
                "TextInput"
            }
            u7.Instance.KeybindButton.MouseButton1Click:Connect(function()
                PlaySound("click")
                if u1.__currentConnection then
                    return
                elseif not u7.__debounce then
                    u7.__debounce = true
                    task.delay(0.25, function()
                        u7.__debounce = nil
                    end)
                    task.wait(0.05)
                    u7.Instance.KeybindButton.CurrentBind.Title.Text = "..."
                    u1.__currentConnection = game.UserInputService.InputEnded:Connect(function(p9)
                        if u1.__currentConnection then
                            local v10 = p9.KeyCode == Enum.KeyCode.Unknown and p9.UserInputType.Name or p9.KeyCode.Name
                            if table.find(u8, v10) or p9.KeyCode == Enum.KeyCode.Unknown and u2:GetAttribute("KeycodeOnly") then
                                PlaySound("error")
                                return
                            end
                            local v11 = require(game.ReplicatedStorage.Initializer)
                            for v12, v13 in pairs(v11.PlayerSettings) do
                                if v13.IsKeybind and (v13.Value == v10 and v12 ~= u2.Name) then
                                    PlaySound("error")
                                    return
                                end
                            end
                            u2.Value = v10
                            PlaySound("switch0".. tostring(math.random(1,4)))
                            if u1.__currentConnection then
                                u1.__currentConnection:Disconnect()
                                u1.__currentConnection = nil
                            end
                            u7.Instance.KeybindButton.CurrentBind.Title.Text = v10
                        end
                    end)
                end
            end)
            local function v15()
                local v14 = "PC"
                if v14 == "Console" and u2.Name:find("~Console") then
                    u7.Instance.Visible = true
                    return
                elseif v14 == "PC" and not u2.Name:find("~Console") then
                    u7.Instance.Visible = true
                else
                    u7.Instance.Visible = false
                end
            end
            v15()
            return u7
        end
        function u1.OnUpdate(p16)
            p16.Instance.KeybindButton.CurrentBind.Title.Text = p16.Value
        end
        return u1
    ]=],
    ["Bool"] = [=[
        local u1 = {}
        u1.__index = u1
        local PlaySound = ({...})[1]
        function u1.CreateSettingUI(_, u2, p3)
            if not u2 then
                u2 = Instance.new("BoolValue")
                u2.Name = "SettingValue"
            end
            local v4 = u1
            local u5 = setmetatable({
                ["SettingValue"] = u2
            }, v4)
            u5.isDebounce = false
            u5.Instance = p3 or game:GetService("ReplicatedStorage").Systems.Player.UI.Menus.Settings.Templates.Bool.Checkbox:Clone()
            u5.Instance.CheckboxButton.MouseButton1Click:Connect(function()
                if not u5.isDebounce then
                    u5.isDebounce = true
                    task.delay(0.25, function()
                        u5.isDebounce = false
                    end)
                    PlaySound("switch0".. tostring(math.random(1,4)))
                    u2.Value = not u2.Value
                end
            end)
            return u5
        end
        function u1.OnUpdate(p6)
            p6.Value = p6.SettingValue.Value
            p6.Instance.CheckboxButton.Checked.Visible = p6.Value
        end
        return u1
    ]=]
}

local SettingsData
local Contents
local Templates

local function SetupSettingUI(SettingInstance, TabSectionFolder,TableFeature)
        local LayoutOrder = SettingInstance:GetAttribute("LayoutOrder")
        local DisplayTitle = SettingInstance:GetAttribute("DisplayTitle")
        if LayoutOrder and DisplayTitle then
            if SettingInstance:IsA("Folder") then
                local Seperator = Templates.Seperator:Clone()
                Seperator.Name = SettingInstance.Name
                Seperator.LayoutOrder = LayoutOrder * 100 + (TabSectionFolder and TabSectionFolder:GetAttribute("LayoutOrder") * 100 or 0)
                SettingInstance:GetAttributeChangedSignal("LayoutOrder"):Connect(function()
                    if SettingInstance.Name ~= "EnviromentFunctions" then
                        Seperator.LayoutOrder = SettingInstance:GetAttribute("LayoutOrder") * 100 + (TabSectionFolder and TabSectionFolder:GetAttribute("LayoutOrder") * 100 or 0)
                    end
                end)
                Seperator.Title.Text = DisplayTitle
                SettingInstance:GetAttributeChangedSignal("DisplayTitle"):Connect(function()
                    if SettingInstance.Name ~= "EnviromentFunctions" then
                        Seperator.Title.Text = SettingInstance:GetAttribute("DisplayTitle")
                    end
                end)
                Seperator.Parent = Contents
            elseif SettingInstance:IsA("ValueBase") then
                local SettingType = Templates:FindFirstChild(SettingInstance:GetAttribute("TemplateType") or string.gsub(SettingInstance.ClassName, "Value", ""))
                for i,Child in pairs(Templates:GetChildren()) do
                    if SettingInstance.Parent.Name:find(Child.Name) then
                        SettingType = Child
                    end
                end
                if SettingType then
                    local ModuleType = ModulesOptions[tostring(SettingType.Name)]
                    SettingType = loadstring(tostring(ModuleType))(PlaySound)
                end
                if SettingType and SettingType.CreateSettingUI then
                    local SettingUI = SettingType:CreateSettingUI(SettingInstance)
                    SettingUI.Instance.Name = SettingInstance.Name
                    TabSectionFolder = SettingInstance.Parent
                    SettingUI.Instance.LayoutOrder = LayoutOrder + (TabSectionFolder and TabSectionFolder:GetAttribute("LayoutOrder") * 100 or 0)
                    TabSectionFolder:GetAttributeChangedSignal("LayoutOrder"):Connect(function()
                        SettingUI.Instance.LayoutOrder = SettingInstance:GetAttribute("LayoutOrder") + (TabSectionFolder and TabSectionFolder:GetAttribute("LayoutOrder") * 100 or 0)
                    end)
                    SettingUI.Instance.Parent = Contents
                    local Requirement = SettingInstance:GetAttribute("Requirement")
                    local BindableCallCheckRequirement = Instance.new("BindableEvent")
                    local Requirements = {}
                    BindableCallCheckRequirement.Event:Connect(function()
                        local AllTrue = true                            
                        for i,v in pairs(Requirements) do
                            if not v then
                                AllTrue = false
                                break
                            end
                        end
                        if AllTrue then
                            SettingUI.Instance.Visible = true
                        else
                            SettingUI.Instance.Visible = false
                        end
                    end)
                    if type(Requirement) == "string" and Requirement:find("|") then
                        for i,v in (string.split(Requirement, "|")) do
                            Requirements[v] = false
                        end
                    else
                        Requirements = Requirement and {[Requirement] = false} or {}
                    end
                    for Requirement,v in pairs(Requirements) do
                        Requirements[Requirement] = false
                        local InstanceValue = type(Requirement) == "string" and PlusFolderSettings:FindFirstChild(Requirement, true) or nil
                        if InstanceValue and Requirement ~= true then
                            Requirements[Requirement] = InstanceValue.Value
                            InstanceValue:GetPropertyChangedSignal("Value"):Connect(function()
                                Requirements[Requirement] = InstanceValue.Value
                                BindableCallCheckRequirement:Fire()
                            end)
                        elseif Requirement == true then
                            Requirements[Requirement] = false
                            BindableCallCheckRequirement:Fire()
                        elseif Requirement:find("=") then
                            local SplitData = string.split(Requirement, "=")
                            local Value = SplitData[2]
                            local function BindChecker(CheckerInstance)
                                local function Update()
                                    if tostring(CheckerInstance.Value) == Value or tostring(CheckerInstance.Value):lower() == "both" or tostring(CheckerInstance.Value):lower() == "all" then
                                        Requirements[Requirement] = true
                                    else
                                        Requirements[Requirement] = false
                                    end
                                    BindableCallCheckRequirement:Fire()
                                end
                                Update()
                                CheckerInstance:GetPropertyChangedSignal("Value"):Connect(Update)
                            end
                            local CheckerInstance = PlusFolderSettings:FindFirstChild(SplitData[1], true)
                            if CheckerInstance then
                                BindChecker(CheckerInstance)
                            else
                                PlusFolderSettings.DescendantAdded:Connect(function(Child)
                                    if Child.Name == SplitData[1] and Child:IsA("ValueBase") then
                                        BindChecker(Child)
                                    end
                                end)
                            end
                        elseif Requirement:find("~") then
                            local SplitData = string.split(Requirement, "~")
                            local Value = SplitData[2]
                            local function BindChecker(CheckerInstance)
                                local function Update()
                                    if tostring(CheckerInstance.Value) ~= Value then
                                        Requirements[Requirement] = true
                                    else
                                        Requirements[Requirement] = false
                                    end
                                    BindableCallCheckRequirement:Fire()
                                end
                                Update()
                                CheckerInstance:GetPropertyChangedSignal("Value"):Connect(Update)
                            end
                            local CheckerInstance = PlusFolderSettings:FindFirstChild(SplitData[1], true)
                            if CheckerInstance then
                                BindChecker(CheckerInstance)
                            else
                                PlusFolderSettings.DescendantAdded:Connect(function(Child)
                                    if Child.Name == SplitData[1] and Child:IsA("ValueBase") then
                                        BindChecker(Child)
                                    end
                                end)
                            end
                        elseif Requirement:find(":") then
                            local SplitData = string.split(Requirement, ":")
                            local Value = SplitData[2]
                            local ToCheck = SplitData[1]
                            if ToCheck:lower():find("killer") then
                                Requirements[Requirement] = KillerAssets and (KillerAssets:FindFirstChild(Value) or KillerAssets:FindFirstChild("!"..Value)) and true or false
                            elseif ToCheck:lower():find("survivor") then
                                Requirements[Requirement] = SurvivorAssets and (SurvivorAssets:FindFirstChild(Value) or SurvivorAssets:FindFirstChild("!"..Value)) and true or false
                            elseif ToCheck:lower():find("gameid") then
                                Requirements[Requirement] = Value:gsub("[^%d]","") ~= "" and game.GameId == tonumber(Value:gsub("[^%d]",""))
                            elseif ToCheck:lower():find("placeid") then
                                Requirements[Requirement] = Value:gsub("[^%d]","") ~= "" and game.PlaceId == tonumber(Value:gsub("[^%d]",""))
                            elseif ToCheck:lower():find("status") or ToCheck:lower():find("effect") then
                                Requirements[Requirement] = StatusEffects and StatusEffects:FindFirstChild(Value,true) and true or false
                            end
                            BindableCallCheckRequirement:Fire()
                        end
                    end
                    PlusFolderSettings.DescendantAdded:Connect(function(Child)
                        if not Child:IsA("ValueBase") then
                            return
                        end
                        for Requirement,v in pairs(Requirements) do
                            if type(Requirement) == "string" and not Requirement:find("=") and not Requirement:find("~") and not Requirement:find(":") and Requirement == Child.Name then
                                Requirements[Requirement] = Child.Value
                                Child:GetPropertyChangedSignal("Value"):Connect(function()
                                    Requirements[Requirement] = Child.Value
                                    BindableCallCheckRequirement:Fire()
                                end)
                                BindableCallCheckRequirement:Fire()
                            end
                        end
                    end)
                    BindableCallCheckRequirement:Fire()
                    SettingInstance:GetAttributeChangedSignal("Requirement"):Connect(function()
                        Requirement = SettingInstance:GetAttribute("Requirement")
                        Requirements = {}
                        if type(Requirement) == "string" and Requirement:find("|") then
                            for i,v in (string.split(Requirement, "|")) do
                                Requirements[v] = false
                            end
                        else
                            Requirements = Requirement and {[Requirement] = false} or {}
                        end
                        BindableCallCheckRequirement:Fire()
                    end)
                    local SettingFeature = TableFeature
                    local ResetButton = Templates.Reset:Clone()
                    ResetButton.Parent = SettingUI.Instance
                    ResetButton.MouseButton1Click:Connect(function()
                        SettingInstance.Value = SettingFeature["DefaultInstanceValue"]
                        PlaySound("switch0".. tostring(math.random(1,4)))
                    end)
                    ResetButton.MouseEnter:Connect(function()
                        PlaySound("hover")
                    end)
                    ResetButton.MouseLeave:Connect(function()
                        PlaySound("hoverEnd")
                    end)
                    SettingUI.Instance:FindFirstChild("SettingName", true).Text = (DisplayTitle or "")
                    SettingInstance:GetAttributeChangedSignal("DisplayTitle"):Connect(function()
                        SettingUI.Instance:FindFirstChild("SettingName", true).Text = (SettingInstance:GetAttribute("DisplayTitle") or "")
                    end)
                    SettingUI.Instance:FindFirstChild("SettingDesc", true).Text = (SettingInstance:GetAttribute("DisplayDescription") or "")
                    SettingInstance:GetAttributeChangedSignal("DisplayDescription"):Connect(function()
                        SettingUI.Instance:FindFirstChild("SettingDesc", true).Text = (SettingInstance:GetAttribute("DisplayDescription") or "")
                    end)
                    SettingUI.__updatedEvent = Instance.new("BindableEvent", SettingUI.Instance)
                    SettingUI.Updated = SettingUI.__updatedEvent.Event
                    if SettingFeature then
                        if SettingFeature.CustomSetup then
                            task.spawn(SettingFeature.CustomSetup,SettingFeature)
                        end
                        SettingUI.Updated:Connect(function(Starting)
                            if SettingFeature.ScriptFunction and SettingUI.Value ~= nil then
                                SettingFeature:ScriptFunction(SettingUI.Value,Starting or false)
                            end
                        end)
                        CharacterAddedBindable.Event:Connect(function()
                            if SettingFeature.CharacterAdded then
                                task.spawn(SettingFeature.CharacterAdded,SettingFeature)
                            end
                        end)
                        if SettingFeature.OnLoop then
                            ThreadBindable.Event:Connect(function()
                                SettingFeature:OnLoop(SettingFeature)
                            end)
                        end
                    end
                    SettingUI.Value = SettingInstance.Value
                    if SettingUI.OnUpdate then
                        SettingUI:OnUpdate()
                    end
                    SettingUI.__updatedEvent:Fire(true)
                    SettingInstance:GetPropertyChangedSignal("Value"):Connect(function()
                        SettingUI.Value = SettingInstance.Value
                        if SettingUI.OnUpdate then
                            SettingUI:OnUpdate()
                        end
                        SettingUI.__updatedEvent:Fire()
                    end)
                    SettingsData.PlayerSettings[SettingInstance.Name] = SettingUI
                    task.wait()
                end
            end
        else
            return
        end
    end

local function HandleUIFeatures(TabName,TabContents)
    local Folder = Instance.new("Folder")
    Folder.Name = TabName
    Folder.Parent = PlusFolderSettings
    if not TabContents["TabAttributes"] then
        Folder:Destroy()
        warn(`Failed to create section : {TabName}\nERROR: There is no TabAttributes attached to the section`)
        return
    end
    for Attribute, Value in TabContents["TabAttributes"] do
        Folder:SetAttribute(Attribute, Value)
    end
    for SettingName, SettingData in TabContents do
        task.spawn(function()
            if SettingName == "TabAttributes" then
                return
            end
            local NewInstance = Instance.new(SettingData.InstanceType)
            local TableEvent = table.clone(SettingData)
            table.clear(SettingData)
            setmetatable(SettingData,{
                __index = TableEvent,
                __newindex = function(Table,i,v)
                    TableEvent[i] = v
                    if i == "DisplayDescription" or i == "DisplayTitle" or i == "LayoutOrder" then
                        NewInstance:SetAttribute("DisplayDescription",type(TableEvent["DisplayDescription"]) == type("") and TableEvent["DisplayDescription"] or "")
                        NewInstance:SetAttribute("DisplayTitle",type(TableEvent["DisplayTitle"]) == type("") and TableEvent["DisplayTitle"] or "Untitled Feature")
                        NewInstance:SetAttribute("LayoutOrder",type(TableEvent["LayoutOrder"]) == type(1) and TableEvent["LayoutOrder"] or #NewInstance:GetAttribute("DisplayTitle"))
                    end
                    if i == "Requirement" then
                        NewInstance:SetAttribute("Requirement",(type(TableEvent["Requirement"]) == type(true) or TableEvent["Requirement"] == type("") and TableEvent["Requirement"]))
                    end
                end
            })
            NewInstance.Name = SettingName
            NewInstance.Value = SettingData.DefaultInstanceValue
            local TableData = HttpService:JSONDecode(ReturnData("Data.txt", true))
            if SettingData["Savable"] and FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] then
                if TableData[SettingName] ~= nil and NewInstance:GetAttribute("Requirement") ~= true then
                    NewInstance.Value = TableData[SettingName]
                end
                NewInstance:GetPropertyChangedSignal("Value"):Connect(function()
                    if NewInstance:GetAttribute("Requirement") == true or not SettingData["Savable"] then
                        return
                    end
                    local TableData2 = HttpService:JSONDecode(ReturnData("Data.txt", true))
                    TableData2[SettingName] = SettingData.DefaultInstanceValue == NewInstance.Value and nil or NewInstance.Value
                    if FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] then
                        ChangeData("Data.txt",HttpService:JSONEncode(TableData2),true)
                    end
                end)
            elseif not FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] and SettingData["Savable"] and not WarnedAboutFilesCompatability then
                WarnedAboutFilesCompatability = true
                ColoredPrint("Failed to load a savable feature.\nIf this bothers you then you should use a different executor that supports 'writefile' and 'readfile'", "info", Color3.new(1,0.25,0))
            end
            if SettingData["DisplayDescription"] then
                SettingData.DisplayDescription = SettingData.DisplayDescription:gsub("%(NO FUNCTIONALITY%)", RichTextGradientColor("(NO FUNCTIONALITY)",{Color3.fromRGB(255, 83, 53), Color3.fromRGB(255, 123, 0),Color3.fromRGB(255, 83, 53)}))
            end
            SettingData["Instance"] = NewInstance
            NewInstance:SetAttribute("DisplayDescription",SettingData["DisplayDescription"] or "")
            NewInstance:SetAttribute("DisplayTitle",SettingData["DisplayTitle"] or "Untitled Feature")
            NewInstance:SetAttribute("LayoutOrder",SettingData["LayoutOrder"] or #NewInstance:GetAttribute("DisplayTitle"))
            NewInstance:SetAttribute("Requirement",SettingData["Requirement"])
            if SettingData["ExtraData"] then
                for ExtraDataIndex, ExtraDataValue in SettingData.ExtraData do
                    NewInstance:SetAttribute(ExtraDataIndex, ExtraDataValue)
                end
            end
            NewInstance.Parent = Folder
            SetupSettingUI(NewInstance,Folder,SettingData)
        end)
    end
    SetupSettingUI(Folder)
    return Folder
end



local Initializer = {}
function Initializer.Start()
    SettingsData = {}
    SettingsData.PlayerSettings = {}
    Initializer.SettingsMenu = MenuData:CreateSidebarMenu("Plus", PlusMenu)
    if NewUIVersion then
        PlusMenu:Destroy()
        PlusMenu = Initializer.SettingsMenu.Menu
    end
    Contents = Initializer.SettingsMenu.Menu.SettingsContainer.Contents
    Templates = ReplicatedStorage.Systems.Player.UI.Menus.Settings.Templates
    local PluginsFolderDir = "NaikoScript/ForsakenPlus/Plugins"
    local FilterDir = PluginsFolderDir:gsub("/","\\") .. "\\"
    local PluginDefaultSettings = {
        PluginVersion = "1.0",
        PluginName = "Plugin",
        PluginCredits = "Someone", 
        HidePluginInfoTab = false
    }
    if FeatureLoadout["EnviromentFunctions"]["files"]["DefaultInstanceValue"] then
        local PluginFiles = isfolder(PluginsFolderDir) and listfiles(PluginsFolderDir) or nil
        if PluginFiles then
            local StartTime = workspace.DistributedGameTime
            for i,v in PluginFiles do
                local PluginFileData = ReturnData(v,false)
                local FeatureErrors = 0
                if string.gsub(PluginFileData,"[\n ]",""):sub(1,7) == "return{" then
                    local Plugin,err = loadstring(PluginFileData)
                    local Success,Features,PluginSettings
                    if Plugin == nil then
                        task.spawn(error,`Failed to load Plugin : {v:gsub(FilterDir,"")}\n{err}`,5)
                        continue
                    end
                    local suc,err = pcall(function()
                        setfenv(Plugin, getfenv())
                        Features,PluginSettings = Plugin()
                    end)
                    if not suc then 
                        task.spawn(error,`Failed to load Plugin : {v:gsub(FilterDir,"")}\n{err}`,5)
                        continue
                    end
                    if typeof(Features) == typeof({}) then
                        for TabName, TabContents in Features do
                            if type(TabName) == type("") and typeof(TabContents) == typeof({}) then
                                FeatureLoadout[TabName] = FeatureLoadout[TabName] or {}
                                for FeatureName,FeatureData in TabContents do
                                    if FeatureName == "TabAttributes" and TabName == "EnviromentFunctions" then continue end
                                    if (FeatureLoadout[TabName][FeatureName] and FeatureData.InstanceType == FeatureLoadout[TabName][FeatureName].InstanceType) or not FeatureLoadout[TabName][FeatureName] then
                                        FeatureLoadout[TabName][FeatureName] = FeatureData
                                    else
                                        FeatureErrors += 1
                                        warn(`Failed to load {TabName} from {v:gsub(FilterDir,"")}\nERROR: to override the InstanceType must be the same as the original feature`)
                                    end
                                end
                            else
                                FeatureErrors += 1
                                warn(`Failed to load {TabName} from {v:gsub(FilterDir,"")}\nERROR: Tab Name is not a string or Tab Contents is not a table`)
                            end
                        end
                        if PluginSettings and type(PluginSettings) == type({}) then
                            for i,v in PluginDefaultSettings do
                                PluginSettings[i] = PluginSettings[i] or v
                            end
                            if not PluginSettings["HidePluginInfoTab"] then
                                FeatureLoadout[PluginSettings["PluginName"] .. HttpService:GenerateGUID(false):sub(1,7)] = {
                                    ["TabAttributes"] = {
                                        ["DisplayTitle"] = string.format(
                                            "%s Made by %s | %s",
                                            PluginSettings["PluginName"],
                                            PluginSettings["PluginCredits"],
                                            RichTextGradientColor("V"..PluginSettings["PluginVersion"],{Color3.fromRGB(87, 160, 255),Color3.fromRGB(0, 132, 255)})
                                        ),
                                        ["LayoutOrder"] = 1000
                                    }
                                }
                            end
                        end
                    else
                        warn(`Failed to load Plugin : {v:gsub(FilterDir,"")}\nERROR: The features returned is not a table value`)
                        continue
                    end
                else
                    warn(`Failed to load Plugin : {v:gsub(FilterDir,"")} | This is for security. If you made this plugin please read the documentation.\nERROR: Return is not at the start of the first line without anything behind it and make sure it is infact correct`)
                    continue
                end
                local LoadDelay = workspace.DistributedGameTime - StartTime
                if FeatureErrors > 0 then
                    ColoredPrint(`Loaded Plugin : <b>{v:gsub(FilterDir,"")}</b> with {FeatureErrors} Feature Error(s)`,"info",Color3.fromRGB(251, 109, 43))
                else
                    ColoredPrint(`Loaded Plugin : <b>{v:gsub(FilterDir,"")}</b> successfully`,"suc",Color3.fromRGB(193,251,43))
                end
            end
        else
            --warn("No Plugins found or directory/folder is removed")
        end
    end
    for TabName, TabContents in FeatureLoadout do
        task.spawn(HandleUIFeatures,TabName,TabContents)
    end

    task.spawn(function()
        if game.GameId == 6331902150 then
            local JsonVersionData
            task.delay(5,function()
                if not JsonVersionData then
                    ColoredPrint("Getting game version info is taking longer than usual.\nRovalra API has not responded in expected time.","warn")
                end
                task.wait(12)
                if not JsonVersionData then
                    ColoredPrint(`Since it still has not gotten a response API still (after 17 seconds)\nYou can Manually check if the game has updated before the script has!\n(Last Script Update/Test : {GameVersionForScript})`,"info")
                end
            end)
            JsonVersionData = (game:HttpGet("https://apis.rovalra.com/v1/games/history?place_id=18687417158"))
            if not JsonVersionData then
                ColoredPrint(`Failed to get game version info.\n Automatic update check failed.\n `)
                return
            end
            local Success,TableVersionData = pcall(function() return HttpService:JSONDecode(tostring(JsonVersionData)) end)
            local CurrentGameVersion = (Success and TableVersionData and type(TableVersionData) == "table" and TableVersionData["history"] and TableVersionData["history"][1] and TableVersionData["history"][1]["first_seen"]) or GameVersionForScript
            CurrentGameVersion = CurrentGameVersion:sub(1,10)
            local y,m,d = GameVersionForScript:match("(%d+)-(%d+)-(%d+)")
            local ThenTime = os.time{year=y, month=m, day=d}
            y,m,d = CurrentGameVersion:match("(%d+)-(%d+)-(%d+)")
            local CurrentTime = os.time{year=y, month=m, day=d}
            local DaysSinceScriptUpdate = math.floor(math.abs(ThenTime - os.time()) / 86400)
            local DaysSinceGameUpdate = math.floor(math.abs(CurrentTime - os.time()) / 86400)
            if ThenTime < CurrentTime and DaysSinceScriptUpdate > 1 then
                ColoredPrint("Days since last script update: " .. DaysSinceScriptUpdate,"info", Color3.fromRGB(236, 48, 120))
                ColoredPrint("Days since game update: " .. DaysSinceGameUpdate,"info", Color3.fromRGB(236, 48, 120))
                FeatureLoadout["Outdated"] = {
                    ["TabAttributes"] = {
                        ["DisplayTitle"] = '<font color="rgb(255,166,0)">⚠</font>' .. RichTextGradientColor(" SCRIPT ISN'T TESTED FOR THIS GAME VERSION ",{Color3.fromRGB(255, 166, 0), Color3.fromRGB(243, 227, 0)}) .. '<font color="rgb(243, 227, 0)">⚠</font>',
                        ["LayoutOrder"] = -10
                    }
                }
                local Folder = HandleUIFeatures("Outdated",FeatureLoadout["Outdated"])
                ColoredPrint(`The game has updated and it has been detected that the script has not been tested/updated for this version.\n{GetValue("DisableAllFeatures") and "All features have been disabled by default to prevent from you possibly getting detected.\n" or ""}Use the features with caution or wait for a update from the script.`, "warning", Color3.fromRGB(255, 166, 0))
                if GetValue("DisableAllFeatures") then
                    print("Disabling all features")
                    for i,v in FeatureLoadout do
                        for i2,v2 in v do
                            if i2 == "DisableAllFeatures" then continue end
                            v2["Savable"] = false
                            if type(v2["DefaultInstanceValue"]) == "boolean" and v2["Instance"] and i ~= "Outdated" and i ~= "EnviromentFunctions" then
                                v2["DefaultInstanceValue"] = false
                                v2["Instance"].Value = false
                            elseif type(v2["DefaultInstanceValue"]) ~= "boolean" and v2["Instance"] and i ~= "Outdated" and i ~= "EnviromentFunctions" then
                                v2["Instance"].Value = v2["DefaultInstanceValue"]
                            end
                        end
                    end
                end
            end
        end
    end)
end

Initializer.Start()

if SidePlusButton:IsA("Frame") then
    task.spawn(function()
        local Menu = MenuData.SidebarMenus[SidePlusButton.Name]
        if NewUIVersion then
            for i, v in MainUI:GetChildren() do
                if v ~= PlusMenu and (v.Name):find("Screen") or v.Name == "Shop" or v.Name == "SwitchServer" then
                    local ButtonName = v.Name:gsub("Screen", "")
                    if ButtonName == "Update" then ButtonName = "UpdateLog" end
                    if ButtonName == "SwitchServer" then ButtonName = "ServerList" end
                    if MenuData.SidebarMenus[ButtonName] == nil then
                        local ToggleEvent = Instance.new("BindableEvent")
                        MenuData.SidebarMenus[ButtonName] = {
                            ["Menu"] = v,
                            ["MenuName"] = ButtonName,
                            ["SidebarButton"] = SideBar:FindFirstChild(ButtonName, true),
                            ["Button"] = MenuData.SidebarButtons[ButtonName],
                            ["Toggled"] = ToggleEvent,
                            ["_sidebar"] = MenuData
                        }
                    end
                end
            end
        end
        if NewUIVersion then
            local CountingMod = false
            if Menu then
                SidePlusButton.Button.MouseButton1Click:Connect(function()
                    MenuData.SidebarMenus["Plus"]["_sidebar"]["MenusHidden"] = false
                    if not PlusMenu.Visible then
                        for i,v in MainUI:GetChildren() do
                        if v ~= PlusMenu and (v.Name):find("Screen") or v.Name == "Shop" or v.Name == "SwitchServer" then
                            local ButtonName = v.Name:gsub("Screen","")
                            if ButtonName == "Update" then ButtonName = "UpdateLog" end
                            if ButtonName == "SwitchServer" then ButtonName = "ServerList" end
                                local Button = SideBar:FindFirstChild(ButtonName,true)
                                if not Button and ButtonName ~= "Mod" then continue end
                                if (MenuData.SidebarMenus[ButtonName] and not MenuData.SidebarMenus[ButtonName]["Checked"]) or (ButtonName == "Mod" and not CountingMod) then
                                    if ButtonName == "Mod" then
                                        CountingMod = true
                                    else
                                        MenuData.SidebarMenus[ButtonName]["Checked"] = true
                                    end
                                    if Button then
                                        Button.Button.MouseButton1Click:Connect(function()
                                            if PlusMenu.Visible and MenuData.TogglingMenus == nil then
                                                MenuData.TogglingMenus = true
                                                local PlusEntry = MenuData.SidebarMenus["Plus"]
                                                if PlusEntry then
                                                    PlusEntry.Toggled:Fire(false)
                                                    TweenService:Create(PlusMenu, BaseTweenInfo, {["Size"] = UDim2.new(1, -20, 0, 0)}):Play()
                                                    task.delay(0.25, function()
                                                        PlusMenu.Visible = false
                                                        PlusMenu:SetAttribute("Visible", false)
                                                    end)
                                                    if PlusEntry.Button then
                                                        PlusEntry.Button:SetAppearanceState(false)
                                                    end
                                                end
                                                SetButtonState(false)
                                                task.delay(0.3, function()
                                                    MenuData.TogglingMenus = nil
                                                end)
                                            end
                                        end)
                                    elseif ButtonName == "Mod" and PlayerGui.TopbarStandard.Holders.Left:FindFirstChild("Widget") then
                                        local TopMod
                                        for i,v in PlayerGui.TopbarStandard.Holders.Left:GetChildren() do
                                            if v:FindFirstChildWhichIsA("TextLabel",true) and v:FindFirstChildWhichIsA("TextLabel",true).Text == "Command Panel" then
                                                TopMod = v
                                                break
                                            end
                                        end
                                        if TopMod then
                                            TopMod.IconButton.Menu.IconSpot.ClickRegion.MouseButton1Click:Connect(function()
                                                if PlusMenu.Visible and MenuData.TogglingMenus == nil then
                                                    MenuData.TogglingMenus = true
                                                    local PlusEntry = MenuData.SidebarMenus["Plus"]
                                                    if PlusEntry then
                                                        PlusEntry.Toggled:Fire(false)
                                                        TweenService:Create(PlusMenu, BaseTweenInfo, {["Size"] = UDim2.new(1, -20, 0, 0)}):Play()
                                                        task.delay(0.25, function()
                                                            PlusMenu.Visible = false
                                                            PlusMenu:SetAttribute("Visible", false)
                                                        end)
                                                        if PlusEntry.Button then
                                                            PlusEntry.Button:SetAppearanceState(false)
                                                        end
                                                    end
                                                    SetButtonState(false)
                                                    task.delay(0.3, function()
                                                        MenuData.TogglingMenus = nil
                                                    end)
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        else
            if Menu then
            SidePlusButton.Button.MouseButton1Click:Connect(function()
                if not PlusMenu.Visible then
                    for i,v in MainUI:GetChildren() do
                        if v ~= PlusMenu and (v.Name):find("Screen") then
                            local ButtonName = v.Name:gsub("Screen","")
                            local Button = Buttons:FindFirstChild(ButtonName) or (SideBar:FindFirstChild("Bottombar") and SideBar.Bottombar.Buttons:FindFirstChild(ButtonName)) or nil
                            if not Button and ButtonName ~= "Mod" then continue end
                            local Event = v:FindFirstChildOfClass("BindableEvent")
                            if MenuData.SidebarMenus[ButtonName] == nil then
                                if Button then
                                    Button.Button.MouseButton1Click:Connect(function()
                                        if PlusMenu.Visible and MenuData.TogglingMenus == nil then
                                            Menu:ToggleMenu()
                                        end
                                    end)
                                elseif v.Name == "ModScreen" and PlayerGui.TopbarStandard.Holders.Left:FindFirstChild("Widget") then
                                    PlayerGui.TopbarStandard.Holders.Left.Widget.IconButton.Menu.IconSpot.ClickRegion.MouseButton1Click:Connect(function()
                                        if PlusMenu.Visible and MenuData.TogglingMenus == nil then
                                            Menu:ToggleMenu()
                                        end
                                    end)
                                end
                                MenuData.SidebarMenus[ButtonName] = {
                                    ["Toggled"] = Event and Event.Event or nil,
                                    ["SidebarButton"] = Buttons:FindFirstChild(ButtonName) or nil,
                                    ["Menu"] = MainUI:FindFirstChild(v.Name),
                                    ["__toggleEvent"] = Event or nil
                                }
                            end
                        end
                    end
                end
                if MenuData.TogglingMenus == nil then
                    Menu:ToggleMenu()
                end
            end)
        end
        end
    end)
    if NewUIVersion then
        local OriginalSize = SidePlusButton.Size
        SidePlusButton.MouseEnter:Connect(function()
            TweenService:Create(SidePlusButton, BaseTweenInfo, {
                ["Size"] = UDim2.fromScale(OriginalSize.X.Scale * 1.1, OriginalSize.Y.Scale * 1.13)
            }):Play()
            PlaySound("hover")
        end)
        SidePlusButton.MouseLeave:Connect(function()
            TweenService:Create(SidePlusButton, BaseTweenInfo, {
                ["Size"] = OriginalSize
            }):Play()
            PlaySound("hoverEnd")
        end)
    else
        local IsBottomBar = SidePlusButton.Parent.Parent.Name == "Bottombar"
        local PulloutHolder = SidePlusButton.PulloutHolder
        PulloutHolder.Parent = IsBottomBar and (MenuData.Sidebars.Bottombar.Pullouts or SidePlusButton) or SidePlusButton
        local PulloutFrame = PulloutHolder.PulloutFrame
        PulloutFrame.Title.Text = SidePlusButton.Name
        SidePlusButton.MouseEnter:Connect(function()
            if SidePlusButton.Button.ImageTransparency <= 0.1 then
                TweenService:Create(SidePlusButton, BaseTweenInfo, {
                    ["Size"] = UDim2.fromScale(1.05, IsBottomBar and 1.15 or 0.25)
                }):Play()
                if IsBottomBar then
                    TweenService:Create(PulloutHolder, BaseTweenInfo, {["Position"] = UDim2.fromScale(0.65, 0.85),["Size"] = UDim2.fromScale(0.35, 0.75)}):Play()
                    TweenService:Create(PulloutFrame.Display, BaseTweenInfo, {["ImageTransparency"] = 0}):Play()
                    TweenService:Create(PulloutFrame.Title, BaseTweenInfo, {["TextTransparency"] = 0}):Play()
                else
                    TweenService:Create(PulloutFrame, BaseTweenInfo, {["Position"] = UDim2.new(0.225, PulloutFrame.Title.AbsoluteSize.X ^ 1.03, 0.5, 0)}):Play()
                end
                PlaySound("hover")
            end
        end)
        SidePlusButton.MouseLeave:Connect(function()
            TweenService:Create(SidePlusButton, BaseTweenInfo, {["Size"] = UDim2.fromScale(1, IsBottomBar and 1 or 0.2)}):Play()
            if IsBottomBar then
                TweenService:Create(PulloutHolder, BaseTweenInfo, {["Position"] = UDim2.fromScale(0.65, 1),["Size"] = UDim2.fromScale(0.15, 0.45)}):Play()
                TweenService:Create(PulloutFrame.Display, BaseTweenInfo, {["ImageTransparency"] = 1}):Play()
                TweenService:Create(PulloutFrame.Title, BaseTweenInfo, {["TextTransparency"] = 1}):Play()
            else
                TweenService:Create(PulloutFrame, BaseTweenInfo, {["Position"] = UDim2.fromScale(0, 0.5)}):Play()
            end
            if SidePlusButton.Button.ImageTransparency <= 0.1 then
                PlaySound("hoverEnd")
            end
        end)
    end
end

local function UICheck()
    local Status = SideBar:GetAttribute("WasVisible")
    SetButtonState(false)
    local LayoutInstance = Buttons and Buttons:FindFirstChildOfClass("UIListLayout") or Buttons and Buttons:FindFirstChildOfClass("UIGridLayout")
    if not LayoutInstance:GetAttribute("VerticalAlignment") then
        LayoutInstance:SetAttribute("VerticalAlignment", LayoutInstance.VerticalAlignment)
    end
    if Status then
        if not NewUIVersion then
            if LayoutInstance then
                LayoutInstance.VerticalAlignment = LayoutInstance:GetAttribute("VerticalAlignment")
            end
        else
            SideBar:FindFirstChildOfClass("UIPadding").PaddingRight = UDim.new(0.2,0)
            SideBar:FindFirstChildOfClass("UIPadding").PaddingLeft = UDim.new(0,0)
            UIScale.Scale = 1
        end
        PlusMenu.SettingsContainer.ImageTransparency = 0
        PlusMenu.SettingsContainer.Contents.ScrollBarImageTransparency = 0
        if SideBar:IsA("ImageLabel") then
            SideBar.ImageTransparency = 0
        end
        for i,v in PlusMenu.SettingsContainer.Contents:GetChildren() do
            if v:IsA("ImageLabel") then
                v.ImageTransparency = 0
            elseif v:IsA("Frame") then
                for i,v in v:GetChildren() do
                    if v:IsA("ImageLabel") or v:IsA("ImageButton") then
                        v.ImageTransparency = 0
                    end
                end
            end
        end
    else
        if NewUIVersion then
            MenuData.SidebarMenus["Plus"]["_sidebar"]["MenusHidden"] = false
            task.delay(0.5,function()
                MenuData.SidebarMenus["Plus"]["_sidebar"]["MenusHidden"] = false
            end)
            SideBar:FindFirstChildOfClass("UIPadding").PaddingRight = UDim.new(0,0)
            SideBar:FindFirstChildOfClass("UIPadding").PaddingLeft = UDim.new(0.2,0)
            UIScale.Scale = 1.3
        end
        if LayoutInstance then
            LayoutInstance.VerticalAlignment = Enum.VerticalAlignment.Center
        end
        PlusMenu.SettingsContainer.ImageTransparency = 0.3
        PlusMenu.SettingsContainer.Contents.ScrollBarImageTransparency = 0.45
        if SideBar:IsA("ImageLabel") then
            SideBar.ImageTransparency = 1
        end
        for i,v in PlusMenu.SettingsContainer.Contents:GetChildren() do
            if v:IsA("ImageLabel") then
                v.ImageTransparency = 0.4
            elseif v:IsA("Frame") then
                for i,v in v:GetChildren() do
                    if v:IsA("ImageLabel") or v:IsA("ImageButton") then
                        v.ImageTransparency = 0.3
                    end
                end
            end
        end
    end
    for i,v in SideBar:QueryDescendants(`#Bottom > Frame, > ImageLabel , #Bottombar , #{Buttons.Name} > Frame {((not NewUIVersion) and false and ":not(#Credits)" or "")} :not(#TesterUi)`) do
        if not v:GetAttribute("Visibility") and (not v.Name:lower():find("credit") or v.Parent ~= SidePlusButton.Parent) then
            v:SetAttribute("Visibility",v.Visible)
        end
        v.Visible = Status and v:GetAttribute("Visibility") or false
    end
    SidePlusButton.Visible = true
        if NewUIVersion then
            local PlusEntry = MenuData.SidebarMenus["Plus"]
            if PlusEntry and PlusMenu.Visible then
                PlusEntry.Toggled:Fire(false)
                TweenService:Create(PlusMenu, BaseTweenInfo, {["Size"] = UDim2.new(1, -20, 0, 0)}):Play()
                task.delay(0.25, function()
                PlusMenu.Visible = false
                PlusMenu:SetAttribute("Visible", false)
                end)
            end
        end
    if not Status then
        RoundEvent:Fire("Start")
    else
        RoundEvent:Fire("End")
    end
end

MainUI.ChildAdded:Connect(function(Child)
    if Child.Name == "AbilityContainer" then
        SideBar:SetAttribute("WasVisible", false)
        UICheck()
    end
end)
MainUI.ChildRemoved:Connect(function(Child)
    if Child.Name == "AbilityContainer" then
        SideBar:SetAttribute("WasVisible", true)
        UICheck()
    end
end)
SideBar:GetPropertyChangedSignal("Visible"):Connect(function()
    SideBar.Visible = true
end)
SideBar:SetAttribute("WasVisible",(MainUI:FindFirstChild("AbilityContainer") == nil))
UICheck()
SideBar.Visible = true
task.spawn(ActionOnCharacter,LocalCharacter or LocalPlayer.Character)

ColoredPrint("Forsaken plus has loaded successfully","success",Color3.fromRGB(0, 200, 125))