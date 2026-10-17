if not game:IsLoaded() then
    game.Loaded:Wait()
end

if Library then
	Library:Unload()
end
if getgenv().LoadingScriptSlap then return end
getgenv().LoadingScriptSlap = true
pcall(function()
Fixed = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/Fix.lua"))()
fireclickdetector = fireclickdetector or Fixed.fireclickdetector
fireproximityprompt = fireproximityprompt or Fixed.fireproximityprompt
end)

function getAttributes(object, name)
	if not (object and object.Parent) then
		return
	end
	name = name:lower()
	for i, v in pairs(object:GetAttributes()) do
		if i:lower():find(name) then
			return v
		end
	end
end

BlackList = {"stevebody", "rock", "Counterd", "Mirage", "Reversed", "Digging"}
allowedPlaces = {
    [6403373529] = true,
    [136802962479827] = true,
    [127174121130060] = true,
    [11520107397] = true,
    [124596094333302] = true,
    [2380077519] = true,
    [9015014224] = true,
}

----========== Script Start ===========----

local repo = "https://raw.githubusercontent.com/tanhoangviet/Obsidian-UI-Modded/main/"
local repoCacheKey = tostring(os.time())
local function RepoAsset(Path)
    return repo .. Path .. "?v=" .. repoCacheKey
end

local Library = loadstring(game:HttpGet(RepoAsset("Library.lua")))()
local ThemeManager = loadstring(game:HttpGet(RepoAsset("addons/ThemeManager.lua")))()
local SaveManager = loadstring(game:HttpGet(RepoAsset("addons/SaveManager.lua")))()
local Options = Library.Options
local Toggles = Library.Toggles

local Loading = Library:CreateLoading({
    Title = "Azusa Article Hub",
    Icon = 83462777349222,
    TotalSteps = 5
})
Loading:SetMessage("Initializing...")
Loading:SetDescription("Loading game data...")
Loading:ShowSidebarPage(true)
local LoadingData = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoadingIndicator", true)
if LoadingData and LoadingData.Visible then
	local Timeout = os.clock() + 12
	repeat
		task.wait(0.1)
	until not LoadingData.Parent or not LoadingData.Visible or os.clock() > Timeout
end
Loading:SetCurrentStep(1)
Loading:SetDescription("Loading configuration...")
task.wait(3)
_G.ConnectFun = {}
function Create(className: string?, props: table?, children: table?)
	local obj = Instance.new(className)
	if props then
		for k, v in pairs(props) do
			pcall(function()
				obj[k] = v
			end)
		end
	end
	if children then
		for _, child in ipairs(children) do
			if typeof(child) == "Instance" then
				child.Parent = obj
			end
		end
	end
	return obj
end
function VectorTween(Tween)
	Tween = Tween or {}
	Tween.Part = Tween.Part or nil
	Tween.Place = Tween.Place or nil
	Tween.Speed = Tween.Speed or 80
	
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local movePart = Tween.Part or hrp
	local bv = movePart:FindFirstChild("FreezeBV")
	if not bv then
		bv = Create("BodyVelocity", {
			Name = "FreezeBV",
			P = 10000,
			MaxForce = Vector3.new(1e9, 1e9, 1e9),
			Velocity = Vector3.zero,
			Parent = movePart
		})
	end
	repeat task.wait()
		local direction = Tween.Place - movePart.Position
		local distance = direction.Magnitude
		if distance > 0 then
			bv.Velocity = direction.Unit * Tween.Speed
		else
			bv.Velocity = Vector3.zero
		end
	until (movePart.Position - Tween.Place).Magnitude < 5
	bv.Velocity = Vector3.zero
	bv:Destroy()
end
function CreateFreezeBV(FreezeBV)
	FreezeBV = FreezeBV or {}
	FreezeBV.Name = FreezeBV.Name or "FreezeBV"
	FreezeBV.Remove = FreezeBV.Remove or false
	FreezeBV.Velocity = FreezeBV.Velocity or Vector3.zero
	FreezeBV.MaxForce = FreezeBV.MaxForce or Vector3.new(1e9,1e9,1e9)
	
	local player = game.Players.LocalPlayer
	local character = player.Character
	if not character then return nil end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	local nameBV = FreezeBV.Name
	local velocityBV = typeof(FreezeBV.MaxForce) == "Vector3" and FreezeBV.Velocity
	local maxForceBV = typeof(FreezeBV.Velocity) == "Vector3" and FreezeBV.MaxForce
	local existing = hrp:FindFirstChild(nameBV)
	if FreezeBV.Remove then
		if existing then
			existing:Destroy()
		end
		return nil
	end
	if not existing then
		return Create("BodyVelocity", {
			Name = nameBV,
			Parent = hrp,
			P = 10000,
			MaxForce = maxForceBV,
			Velocity = velocityBV
		})
	end
	return existing
end
function FoundPlr(name, notification)
	local PlayerTarget
	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Name:lower():find(name:lower()) then
			PlayerTarget = v
			break
		end
	end
	if notification and PlayerTarget then
		Notification("Found Player [ "..PlayerTarget.Name.." ]", _G.TimeNotify)
	else
		if notification then
			Notification("Can't find player", _G.TimeNotify)
		end
	end
	return PlayerTarget
end
function InsideBox(pos, box)
	local relative = box.CFrame:PointToObjectSpace(pos.Position)
	local size = box.Size / 2
	return math.abs(relative.X) <= size.X + 1.2 and math.abs(relative.Y) <= size.Y and math.abs(relative.Z) <= size.Z + 1.2
end
function TimeCountdown(duration, callback)
	local startTime = os.time()
	local lastSecond = -1
	local connection
	connection = game:GetService("RunService").Heartbeat:Connect(function()
		local currentTime = os.time()
		local elapsedTime = currentTime - startTime
		local remaining = math.max(0, duration - elapsedTime)
		if remaining ~= lastSecond then
			lastSecond = remaining
			local hours = math.floor(remaining / 3600)
			local minutes = math.floor((remaining % 3600) / 60)
			local seconds = math.floor(remaining % 60)
			local formatted = string.format("%02d:%02d:%02d", hours, minutes, seconds)
			if callback then
				callback(formatted, remaining)
			end
		end
		if connection and remaining <= 0 then
			connection:Disconnect()
		end
	end)
	return connection
end

local function IsCallable(Value)
	return typeof(Value) == "function"
end

local function ResolveExecutorName()
	local ok, result = false, nil

	if IsCallable(identifyexecutor) then
		ok, result = pcall(identifyexecutor)
		if ok and result then
			return tostring(result)
		end
	end

	if IsCallable(getexecutorname) then
		ok, result = pcall(getexecutorname)
		if ok and result then
			return tostring(result)
		end
	end

	return "Unknown"
end

local UNC = {
	["namecall hook"] = hookmetamethod and getnamecallmethod,
	["newcclosure"] = newcclosure,
	["queue on teleport"] = queueonteleport or queue_on_teleport,
	["click detector fire"] = fireclickdetector,
	["touch interest fire"] = firetouchinterest,
	["proximity prompt fire"] = fireproximityprompt,
	["clipboard"] = setclipboard or toclipboard,
	["custom asset images"] = getcustomasset,
	["write file"] = writefile and isfile,
	["get connections"] = getconnections,
	["fire signal"] = firesignal,
}

local Passed, Total = 0, 0
for Label, Func in pairs(UNC) do
	Total += 1
	local Success = typeof(Func) == "function" or Func == true
	if Success then Passed += 1 end
	task.wait(0.3)
	Loading.Sidebar:AddLabel(Label .. ": " .. (Success and "Success" or "Fail"))
end

ExecutorSupport = UNC
ExecutorSupport.Name = ResolveExecutorName()
ExecutorSupport.Summary = string.format("%s (%d/%d core APIs)", ExecutorSupport.Name, Total, Passed)
ExecutorSupport.Labels = FeatureLabels

if Loading then
	Loading:SetCurrentStep(2)
	Loading:SetDescription(ExecutorSupport.Summary)
	task.wait(0.25)
end

--- Bypass Skibidi ---

Loading.Sidebar:AddLabel("Bypass Anticheat...")
local total, pass, fail = 0, 0, 0
if allowedPlaces[game.PlaceId] or getAttributes(workspace, "no_one_shot") or getAttributes(workspace, "killstreak") then
    place = "Slap Battles"
elseif game.PlaceId == 9431156611 then
    place = "Slap Royale"
end

if place and type(place) == "string" then
    local yasss = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/NewNexer/NexerHub/refs/heads/main/SB/Modules/CleanClientAntiCheat.luau"))(place)
	end)
    if yasss then
        successbypass = true
    end
end

if successbypass then
    Loading.Sidebar:AddLabel("Check UNC...")
    task.wait(1.3)
    if ExecutorSupport["get connections"] then
        Loading.Sidebar:AddLabel("Test Bypass Anti Cheat...")
        task.wait(0.5)
        local RemotesToCheck = {
            "SetApiEnv", "ToggleApiMode", "Ban", "AdminGUI", "SpecialGloveAccess", 
            "PlaySoundRemote", "GRAB", "LegacyBan", "WalkSpeedChanged", 
            "LegacyAntiCheatFunction", "KickedBind"
        }
        for _, v in ipairs(RemotesToCheck) do
            local remoteSkibidi = game.ReplicatedStorage:FindFirstChild(v, true)
            if remoteSkibidi then
                total += 1
                local hasFunction = false
                if remoteSkibidi:IsA("RemoteFunction") then
                    local ok, isBound = pcall(function()
                        return remoteSkibidi.OnClientInvoke ~= nil
                    end)
                    if ok and isBound then
                        hasFunction = true
                    end
                elseif remoteSkibidi:IsA("RemoteEvent") then
                    pcall(function()
                        for _, conn in ipairs(getconnections(remoteSkibidi.OnClientEvent)) do
                            if conn.Function or (conn.Enabled and typeof(conn.ForeignState) ~= "nil") then
                                hasFunction = true
                                break
                            end
                        end
                    end)
                end
                if hasFunction then
                    fail += 1
                    Loading.Sidebar:AddLabel(v .. " UNSAFE")
                else
                    pass += 1
                    Loading.Sidebar:AddLabel(v .. " SAFE")
                end
            end
        end
    end
end

if Loading then
	Loading:SetCurrentStep(3)
	Loading:SetDescription("There are "..total.." anti-cheat systems, bypass success: "..pass..", fail: "..fail)
	task.wait(1.78)
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
MobileOn = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())

if game.CoreGui:FindFirstChild("Cooldown Script") == nil then
local gui = Create("ScreenGui", {Name = "Cooldown Script", IgnoreGuiInset = true, Parent = game.CoreGui})
local ImageLabel = Create("ImageLabel", {
    Size = UDim2.new(0.215, 0, 0.059, 0),
    Position = UDim2.new(1.01, 0, 0.305, -50),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Image = "rbxassetid://17253889398",
    ImageColor3 = Color3.fromRGB(255,255,255),
    Visible = false,
    ClipsDescendants = true,
    Parent = gui
}, {
    Create("UIAspectRatioConstraint", {
        AspectRatio = 6.438,
        AspectType = Enum.AspectType.FitWithinMaxSize
    })
})

local FrameBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0.98, 0),
    Position = UDim2.new(0, 0, 0.5, 0),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0, 0.5),
    ClipsDescendants = true,
    Parent = ImageLabel
}, {
    Create("ImageLabel", {
        Size = UDim2.new(0, 161, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://17253892073",
        ImageColor3 = Color3.fromRGB(255,255,255),
        AutoLocalize = true,
        Interactable = true
    })
})

local TextLabel = Create("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    TextScaled = true,
    Text = "",
    Rotation = 15,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundTransparency = 1,
    Font = Enum.Font.FredokaOne,
    ZIndex = 2,
    Parent = ImageLabel
}, {
    Create("UIPadding", {
        PaddingBottom = UDim.new(0.15, 0),
        PaddingLeft = UDim.new(0.05, 0),
        PaddingRight = UDim.new(0.05, 0),
        PaddingTop = UDim.new(0.15, 0),
    }),
    Create("UIStroke", {
        Thickness = 0.84,
        StrokeSizingMode = Enum.StrokeSizingMode.FixedSize,
        Color = Color3.new(0, 0, 0)
    })
})
end
function SpringText(label, startRotation)
	local rotation = startRotation or 10
	local velocity = 0
	local target = 0
	local stiffness = 169
	local damping = 8
	local conn
	conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
		velocity += (target - rotation) * stiffness * dt
		velocity *= math.exp(-damping * dt)
		rotation += velocity * dt
		label.Rotation = rotation
		if math.abs(rotation) < 0.01 and math.abs(velocity) < 0.01 then
			label.Rotation = 0
			conn:Disconnect()
		end
	end)
end

function Cooldown(time, text)
	if game.CoreGui:FindFirstChild("Cooldown Script") then
		if game.CoreGui["Cooldown Script"].ImageLabel.Visible then return end
		spawn(function()
			local BarTween = TweenService:Create(game.CoreGui["Cooldown Script"].ImageLabel.Frame, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0.001, 0, 0.98, 0)})
			BarTween:Play()
			BarTween.Completed:Wait()
			game.CoreGui["Cooldown Script"].ImageLabel.Visible = false
			game.CoreGui["Cooldown Script"].ImageLabel.Frame.Size = UDim2.new(1, 0, 0.98, 0)
			game.CoreGui["Cooldown Script"].ImageLabel.TextLabel.Rotation = 15
			TweenService:Create(game.CoreGui["Cooldown Script"].ImageLabel, TweenInfo.new(0.06, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(1.01, 0, 0.305, -50)}):Play()
		end)
		spawn(function()
			game.CoreGui["Cooldown Script"].ImageLabel.TextLabel.Text = text
			game.CoreGui["Cooldown Script"].ImageLabel.Visible = true
			TweenService:Create(game.CoreGui["Cooldown Script"].ImageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.98, 0, 0.3, -50)}):Play()
			SpringText(game.CoreGui["Cooldown Script"].ImageLabel.TextLabel, 20)
		end)
	end
end
function CheckCooldown()
	return game.CoreGui:FindFirstChild("Cooldown Script") and game.CoreGui["Cooldown Script"]:FindFirstChild("ImageLabel") and game.CoreGui["Cooldown Script"].ImageLabel.Visible
end
if game.CoreGui:FindFirstChild("Gui Button Script") == nil then
local gui = Create("ScreenGui", {Name = "Gui Button Script", Enabled = false, Parent = game.CoreGui})

function CreatedButton(edit)
edit.ButtonName = edit.ButtonName or "U"
edit.ButtonPosition = edit.ButtonPosition or UDim2.new(0.175, 0, 0.175, 0)
edit.ButtonSize = edit.ButtonSize or UDim2.new(0.65, 0, 0.65, 0)
edit.ButtonImage = edit.ButtonImage or "rbxassetid://82648533253503"
edit.Callback = edit.Callback or function() end

local Frame = Create("Frame", {
    Name = edit.ButtonName.."AbilityFrame",
    Size = UDim2.new(0.3, 0, 0.5, 0),
    Position = UDim2.new(0.65, 0, 0.5, 0),
    BackgroundTransparency = 1,
    ZIndex = 1,
    Parent = gui
})

local FrameB = Create("ImageButton", {
    Name = "Button"..edit.ButtonName,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0.45, 0, 0.45, 0),
    Position = UDim2.new(0.7, -25, -0.25, -25),
    BackgroundTransparency = 1,
    ZIndex = 1,
    Draggable = true,
    Parent = Frame
}, {
    Create("UIAspectRatioConstraint", {
        AspectType = Enum.AspectType.FitWithinMaxSize,
        AspectRatio = 1,
        DominantAxis = "Width"
    })
})

local UButton = Create("ImageLabel", {
    Name = edit.ButtonName.."Button",
    Position = UDim2.new(0.175, 0, 0.175, 0),
    Size = UDim2.new(0.65, 0, 0.65, 0),
    BackgroundTransparency = 1,
    Image = edit.ButtonImage,
    ImageColor3 = Color3.fromRGB(255, 255, 255),
    ZIndex = 1,
    Parent = FrameB
})

local DefaultSize = FrameB.Size
local function PlayHoverSound(id)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://"..id
    sound.Volume = 2
    sound.PlaybackSpeed = 1
    sound.Parent = workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 2)
end

FrameB.MouseEnter:Connect(function()
    PlayHoverSound(10066942189)
    TweenService:Create(UButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        ImageColor3 = Color3.fromRGB(115, 115, 115),
    }):Play()
end)

FrameB.MouseLeave:Connect(function()
    TweenService:Create(UButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

FrameB.MouseButton1Click:Connect(function()
	PlayHoverSound(10066936758)
	UButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	if CheckCooldown() then return end
	local suc, error = pcall(edit.Callback)
	if not suc then
		print(error)
	end
end)
end
end

if MobileOn and CreatedButton then
CreatedButton({
	Callback = function()
		if not AnimationRoll then
			AnimationRoll = Instance.new("Animation")
			AnimationRoll.AnimationId = "rbxassetid://16299510063"
		end
	    local LocalPlr = game:GetService("Players").LocalPlayer
	    if LocalPlr.Character and LocalPlr.Character:FindFirstChild("Humanoid") and LocalPlr.Character.Humanoid.Health > 0 and not LocalPlr.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FreezeBV") then
	        Cooldown(2, "Roll Script")
	        local humanoid = LocalPlr.Character:WaitForChild("Humanoid")
	        local hrp = LocalPlr.Character:WaitForChild("HumanoidRootPart")
	        humanoid.Animator:LoadAnimation(AnimationRoll):Play()
	        local BV = CreateFreezeBV({Velocity = hrp.CFrame.LookVector * 100, MaxForce = Vector3.new(1e6, 0, 1e6)})
	        game:GetService("Debris"):AddItem(BV, 0.17)
	        for _, v in pairs(LocalPlr.Character:GetDescendants()) do
	            if v:IsA("BasePart") then
	                v.Massless = true
	            end
	        end
	        task.delay(0.6, function()
	            if LocalPlr.Character then
	                for _, v in pairs(LocalPlr.Character:GetChildren()) do
	                    if v:IsA("BasePart") then
	                        v.Massless = false
	                    end
	                end
	            end
	        end)
	    end
	end
})
end

if not game.CoreGui:FindFirstChild("Keybind Script") then
local gui = Create("ScreenGui", {Name = "Keybind Script", Enabled = false, IgnoreGuiInset = true, Parent = game.CoreGui})

function CreatedKeybind(edit)
edit.Name = edit.Name or "U"
edit.Key = edit.Key or Enum.KeyCode.U
edit.Text = edit.Text or "Keybind"
edit.Callback = edit.Callback or function() end

local Frame = Create("Frame", {
    Size = UDim2.new(0.198, 0, 0.094, 0),
    Position = UDim2.new(0.98, 0, 0.6, -50),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Visible = true,
    Parent = gui
}, {
    Create("UIAspectRatioConstraint", {
        AspectRatio = 6.07,
        AspectType = Enum.AspectType.FitWithinMaxSize
    }),
	Create("UIListLayout", {
        Padding = Vector2.new(0.25, 0),
		SortOrder = "LayoutOrder",
		VerticalAlignment = "Bottom",
    })
})

local Button = Create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0),
    Visible = true,
    Parent = Frame
})

local Folder = Create("Folder", {Parent = Button}, {
	Create("TextLabel", {
	    Size = UDim2.new(0.167, 0, 0.759, 0),
	    Position = UDim2.new(0.051, 0, 0.001, 0),
	    BackgroundTransparency = 1,
		TextColor3 = Color3.new(255,255,255),
		Font = "FredokaOne",
		Text = edit.Name,
		TextScaled = true,
		ZIndex = 2,
	    Visible = true
	}, {
		Create("UIStroke", {
		    Thickness = 1.296
		})
	})
})

local ButtonTop = Create("ImageLabel", {
	Size = UDim2.new(0.17, 0, 1, 0),
    Position = UDim2.new(0.049, 0, -0.054, 0),
    BackgroundTransparency = 1,
    Image = "rbxassetid://132237752209803",
    ImageColor3 = Color3.fromRGB(47,47,47),
	Parent = Button
}, {
	Create("ImageLabel", {
		Size = UDim2.new(0.9, 0, 0.9, 0),
	    Position = UDim2.new(0.5, 0, 0, 0),
	    BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0),
	    Image = "rbxassetid://94740529495833",
	    ImageColor3 = Color3.fromRGB(84,84,84),
	})
})

local ButtonName = Create("TextLabel", {
	Size = UDim2.new(0.703, 0, 0.619, 0),
    Position = UDim2.new(0.288, 0, 0.055, 0),
    BackgroundTransparency = 1,
	TextColor3 = Color3.new(255,255,255),
	Font = "FredokaOne",
	Text = edit.Text,
	TextScaled = true,
    Visible = true,
	Parent = Button
}, {
	Create("UIStroke", {
	    Thickness = 1.232
	})
})

local textLabel = Folder:FindFirstChildOfClass("TextLabel")
local innerImage = ButtonTop:FindFirstChildOfClass("ImageLabel")
local TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
table.insert(_G.ConnectFun, UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == edit.Key then
		TweenService:Create(textLabel, TweenInfo, {Position = UDim2.new(0.051,0,0.001,0)}):Play()
		TweenService:Create(innerImage, TweenInfo, {Position = UDim2.new(0.5,0,0,0), ImageColor3 = Color3.fromRGB(84,84,84)}):Play()
	end
end))

table.insert(_G.ConnectFun, UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if CheckCooldown() and (game.CoreGui:FindFirstChild("Keybind Script") and game.CoreGui:FindFirstChild("Keybind Script").Enabled) or (game.CoreGui:FindFirstChild("Gui Roll Script") and not game.CoreGui:FindFirstChild("Gui Roll Script").Enabled) then return end
	if input.KeyCode == edit.Key then
		TweenService:Create(textLabel, TweenInfo, {Position = UDim2.new(0.05,0,0.001,3)}):Play()
		TweenService:Create(innerImage, TweenInfo, {Position = UDim2.new(0.5,0,0,4), ImageColor3 = Color3.fromRGB(122,122,122)}):Play()
		pcall(edit.Callback)
	end
end))
end
end

if not MobileOn and CreatedKeybind then
CreatedKeybind({
	Text = "Roll Script",
	Callback = function()
		local Players = game:GetService("Players")
		local AnimationRoll = Instance.new("Animation")
		AnimationRoll.AnimationId = "rbxassetid://16299510063"
		local LocalPlr = Players.LocalPlayer
	    if LocalPlr.Character and LocalPlr.Character:FindFirstChild("Humanoid") and LocalPlr.Character.Humanoid.Health > 0 and not LocalPlr.Character:FindFirstChild("HumanoidRootPart"):FindFirstChild("FreezeBV") then
			Cooldown(2, "Roll Script")
	        local humanoid = LocalPlr.Character:WaitForChild("Humanoid")
	        local hrp = LocalPlr.Character:WaitForChild("HumanoidRootPart")
	        humanoid.Animator:LoadAnimation(AnimationRoll):Play()
	        local BV = CreateFreezeBV({Velocity = hrp.CFrame.LookVector * 100, MaxForce = Vector3.new(1e6, 0, 1e6)})
	        game:GetService("Debris"):AddItem(BV, 0.17)
	        for _, v in pairs(LocalPlr.Character:GetDescendants()) do
	            if v:IsA("BasePart") then
	                v.Massless = true
	            end
	        end
	        task.delay(0.6, function()
	            if LocalPlr.Character then
	                for _, v in pairs(LocalPlr.Character:GetChildren()) do
	                    if v:IsA("BasePart") then
	                        v.Massless = false
	                    end
	                end
	            end
	        end)
	    end
	end
})
end

function ShowButtonU(show)
	if MobileOn then
		if game.CoreGui:FindFirstChild("Gui Button Script") then
			game.CoreGui:FindFirstChild("Gui Button Script").Enabled = show
		end
	else
		if game.CoreGui:FindFirstChild("Keybind Script") then
			game.CoreGui:FindFirstChild("Keybind Script").Enabled = show
		end
	end
end

if not game.CoreGui:FindFirstChild("Gui Track") then
    local gui = Create("ScreenGui", {Name = "Gui Track", Enabled = false, Parent = game.CoreGui})
    local Frame = Create("Frame", {
        Size = UDim2.new(0.2, 0, 0.1, 0),
        Position = UDim2.new(0.02, 0, 0.87, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 1,
        Active = true,
        BackgroundTransparency = 0,
        Parent = gui
    }, {
        Create("UIStroke", {
            Color = Color3.new(0, 0, 0),
            Thickness = 2.5
        }),
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        })
    })

    local Frame1 = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 1,
        Active = true,
        BackgroundTransparency = 0.3,
        Parent = Frame
    }, {
        Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        })
    })
    
    local Frame2 = Create("Frame", {
        Name = "Frame1",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = Frame1
    })

    local Frame3 = Create("Frame", {
        Name = "FrameTo",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 255, 0),
        BackgroundTransparency = 0.15,
        Parent = Frame2
    }, {
		Create("UICorner", {
            CornerRadius = UDim.new(0, 8)
        })
	})

    local TextLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 1,
        Text = "",
        TextSize = 16,
        ZIndex = 5,
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(0, 0, 0),
        Font = Enum.Font.Code,
        TextWrapped = true,
        Parent = Frame
    }, {
        Create("UITextSizeConstraint", {
            MaxTextSize = 35
        })
    })
end
function GuiTrackUpdate(enabled, update)
	update = update or {}
	update.Text = update.Text or "Bruh"
	update.Size = update.Size or 1
	if update.Size > 1 then
		update.Size = 1
	end
	local enabledGui = enabled or false
	if not enabledGui then
		game.CoreGui["Gui Track"].Frame:FindFirstChild("TextLabel").Text = "Nah"
		game.CoreGui["Gui Track"].Frame.Frame.Frame1.Size = UDim2.new(0, 0, 1, 0)
	end
	if game.CoreGui:FindFirstChild("Gui Track") then
		game.CoreGui["Gui Track"].Enabled = enabledGui
		if game.CoreGui["Gui Track"].Enabled then
			game.CoreGui["Gui Track"].Frame:FindFirstChild("TextLabel").Text = update.Text
			local TweenBar = game:GetService("TweenService"):Create(game.CoreGui["Gui Track"].Frame.Frame.Frame1, TweenInfo.new(1.5), {Size = UDim2.new(update.Size, 0, 1, 0)})
			TweenBar:Play()
		end
	end
end
pcall(function()
	if require then
		ControlMove = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	end
end)
ctrl = {f = 0, b = 0, l = 0, r = 0}
ctrlCould = {f = 0, b = 0, l = 0, r = 0}
table.insert(_G.ConnectFun, UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if not _G.SetSpeedFlyCloud then
		_G.SetSpeedFlyCloud = 0
	elseif not _G.SetSpeedFly then
		_G.SetSpeedFly = 0
	end
	if input.KeyCode == Enum.KeyCode.W then
		ctrl.f = _G.SetSpeedFly
		ctrlCould.f = _G.SetSpeedFlyCloud
	elseif input.KeyCode == Enum.KeyCode.S then
		ctrl.b = -_G.SetSpeedFly
		ctrlCould.b = -_G.SetSpeedFlyCloud
	elseif input.KeyCode == Enum.KeyCode.A then
		ctrl.l = -_G.SetSpeedFly
		ctrlCould.l = -_G.SetSpeedFlyCloud
	elseif input.KeyCode == Enum.KeyCode.D then
		ctrl.r = _G.SetSpeedFly
		ctrlCould.r = _G.SetSpeedFlyCloud
	end
end))
table.insert(_G.ConnectFun, UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.W then
		ctrl.f = 0
		ctrlCould.f = 0
	elseif input.KeyCode == Enum.KeyCode.S then
		ctrl.b = 0
		ctrlCould.b = 0
	elseif input.KeyCode == Enum.KeyCode.A then
		ctrl.l = 0
		ctrlCould.l = 0
	elseif input.KeyCode == Enum.KeyCode.D then
		ctrl.r = 0
		ctrlCould.r = 0
	end
end))
_G.SetSpeedFly = 50
function Fly(Value)
_G.StartFly = Value
if _G.StartFly == false then
	if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
		game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler:Destroy()
		game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	end
end
while _G.StartFly do
	pcall(function()
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9,9e9,9e9)
			game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9,9e9,9e9)
			game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
			game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, game.Players.LocalPlayer.Character.HumanoidRootPart.Position + game.Workspace.CurrentCamera.CFrame.LookVector)
			game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new()
			local RequireMove = ControlMove and ControlMove:GetMoveVector()
			local VectorBVRoot = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity
			if MobileOn then
				if RequireMove and RequireMove.X > 0 then
					VectorBVRoot = VectorBVRoot + game.Workspace.CurrentCamera.CFrame.RightVector * (RequireMove.X * _G.SetSpeedFly)
				end
				if RequireMove and RequireMove.X < 0 then
					VectorBVRoot = VectorBVRoot + game.Workspace.CurrentCamera.CFrame.RightVector * (RequireMove.X * _G.SetSpeedFly)
				end
				if RequireMove and RequireMove.Z > 0 then
					VectorBVRoot = VectorBVRoot - game.Workspace.CurrentCamera.CFrame.LookVector * (RequireMove.Z * _G.SetSpeedFly)
				end
				if RequireMove and RequireMove.Z < 0 then
					VectorBVRoot = VectorBVRoot - game.Workspace.CurrentCamera.CFrame.LookVector * (RequireMove.Z * _G.SetSpeedFly)
				end
			else
				VectorBVRoot = VectorBVRoot + (game.Workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + (game.Workspace.CurrentCamera.CFrame.RightVector * (ctrl.r + ctrl.l))
			end
			game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = VectorBVRoot
		elseif game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and (game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil or game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") == nil) then
			if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
				local bv = Create("BodyVelocity", {
					Name = "VelocityHandler",
					Parent = game.Players.LocalPlayer.Character.HumanoidRootPart,
					MaxForce = Vector3.new(0,0,0),
					Velocity = Vector3.new(0,0,0),
				})
			end
			if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") == nil then
				local bg = Create("BodyGyro", {
					Name = "GyroHandler",
					Parent = game.Players.LocalPlayer.Character.HumanoidRootPart,
					MaxTorque = Vector3.new(0,0,0),
					P = 1000,
					D = 50,
				})
			end
		end
	end)
	task.wait()
	end
end
_G.TimeNotify = 5
if allowedPlaces[game.PlaceId] or getAttributes(workspace, "no_one_shot") or getAttributes(workspace, "killstreak") then

AnimationSlapHit = {
	["134954960138305"] = true,
	["98790126694213"] = true,
	["113677335266712"] = true,
	["16102850016"] = true,
	["86093582820019"] = true,
	["97212410160106"] = true,
	["92696348598076"] = true,
	["12666659393201"] = true,
	["126666659393201"] = true,
	["82224515307861"] = true,
	["13526158494"] = true,
	["13526154547"] = true,
	["16102722988"] = true,
	["135557283152371"] = true,
	["90524879630106"] = true,
	["16294032647"] = true,
	["109511274923523"] = true,
	["133068451086106"] = true,
	["116559255414365"] = true
}

_G.GetPotion = {
	  ["Idiot"] = {"Cake Mix"},
      ["Grug"] = {"Mushroom"},
      ["Nightmare"] = {"Dark Root","Dark Root","Dark Root"},
      ["Confusion"] = {"Red Crystal","Blue Crystal","Glowing Mushroom"},
      ["Power"] = {"Dire Flower","Red Crystal","Wild Vine"},
      ["Paralyzing"] = {"Plane Flower","Plane Flower"},
      ["Haste"] = {"Autumn Sprout","Jade Stone"},
      ["Invisibility"] = {"Hazel Lily","Hazel Lily","Blue Crystal"},
      ["Explosion"] = {"Red Crystal","Fire Flower","Fire Flower"},
      ["Invincible"] = {"Elder Wood","Mushroom","Mushroom"},
      ["Toxic"] = {"Dark Root","Dark Root","Blood Rose","Red Crystal"},
      ["Freeze"] = {"Winter Rose","Winter Rose","Wild Vine","Blue Crystal","Glowing Mushroom"},
      ["Feather"] = {"Mushroom","Hazel Lily"},
      ["Speed"] = {"Mushroom","Mushroom","Plane Flower","Hazel Lily","Blue Crystal"},
      ["Lethal"] = {"Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Blood Rose","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root","Dark Root"},
      ["Slow"] = {"Mushroom","Mushroom","Blue Crystal","Blue Crystal","Jade Stone","Plane Flower"},
      ["Antitoxin"] = {"Blue Crystal","Glowing Mushroom","Plane Flower","Plane Flower","Elder Wood"},
      ["Corrupted Vine"] = {"Wild Vine","Wild Vine","Wild Vine","Blood Rose","Dark Root","Elder Wood","Jade Stone"},
      ["Corrupted Field"] = {"Hazel Lily","Plane Flower","Plane Flower"},
      ["Lost"] = {"Blue Crystal","Elder Wood","Elder Wood","Elder Wood","Red Crystal"}
}

--- Script ---

spawn(function()
	repeat task.wait()
		local success, network = pcall(function()
			return require(game:GetService("ReplicatedStorage").BACKEND.Lib.Network)
		end)
		if success then
			_G.Network = network
		end
	until _G.Network
end)

spawn(function()
	repeat task.wait()
		local success, gloves = pcall(function()
			return require(game:GetService("ReplicatedStorage").Common.Gloves)
		end)
		if success then
			_G.Gloves = gloves
		end
	until _G.Gloves
end)

local data = game:GetService("ReplicatedStorage").PlayerData:FindFirstChild(game.Players.LocalPlayer.Name)
local masteryProgress = data and data:FindFirstChild("GloveMasteryProgress")
function UpdateMasteryProgress()
	local success, mastery = pcall(function()
		return game:GetService("HttpService"):JSONDecode(masteryProgress.Value)
	end)
	if success and mastery then
		_G.MasteryGlove = mastery
	end
end

UpdateMasteryProgress()
masteryProgress:GetPropertyChangedSignal("Value"):Connect(function()
	UpdateMasteryProgress()
end)

if not game.CoreGui:FindFirstChild("MasteryGui") then
	Create("ScreenGui", {
	    Name = "MasteryGui",
	    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	    Parent = game.CoreGui
	}, {
	    Create("Frame", {
	        Name = "Main",
	        Active = true,
	        BorderSizePixel = 0,
			Visible = false,
	        BackgroundColor3 = Color3.fromRGB(113, 113, 113),
	        Size = UDim2.new(0.27766, 0, 0.36659, 0),
	        Position = UDim2.new(0.65, 0, 0, 0),
	        BackgroundTransparency = 0.3
	    }, {
	        Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
	        Create("UIStroke", { Transparency = 0.3, Thickness = 1.5 }),
	        Create("UIDragDetector", {}),
	        Create("UIAspectRatioConstraint", { AspectRatio = 1.77612 }),
	        Create("Frame", {
	            Name = "InfoMastery",
	            BorderSizePixel = 0,
	            BackgroundColor3 = Color3.fromRGB(166, 166, 166),
	            Size = UDim2.new(0, 0, 1, 0),
	            Position = UDim2.new(0, 0, 0, 0), 
	            Visible = false,
	            BackgroundTransparency = 0.2
	        }, {
	            Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
	            Create("UIStroke", { Transparency = 0.3, Thickness = 1.5 }),
	            Create("TextButton", {
	                Name = "Close",
	                TextWrapped = true,
	                BorderSizePixel = 0,
	                TextScaled = true,
	                BackgroundColor3 = Color3.fromRGB(204, 204, 204),
	                FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	                Size = UDim2.new(0.85, 0, 0.13433, 0),
	                Position = UDim2.new(0, 6, 0, 4),
					TextColor3 = Color3.fromRGB(0, 0, 0),
	                Text = "Close"
	            }, {
	                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
	                Create("UIStroke", { Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	            }),
	            Create("TextLabel", {
	                Name = "Info",
	                TextWrapped = true,
	                BorderSizePixel = 0,
	                TextScaled = true,
	                BackgroundColor3 = Color3.fromRGB(187, 187, 187),
	                FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	                BackgroundTransparency = 0.2,
	                Size = UDim2.new(0.85, 0, 0.76119, 0),
	                Position = UDim2.new(0, 6, 0, 26),
					TextColor3 = Color3.fromRGB(0, 0, 0),
	                Text = "Select a task info"
	            }, {
	                Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
	                Create("UIStroke", { Transparency = 0.3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	            })
	        }),
	        Create("Frame", {
	            Name = "masteryGlove",
	            BorderSizePixel = 0,
	            BackgroundColor3 = Color3.fromRGB(139, 139, 139),
	            Size = UDim2.new(0.94958, 0, 0.9403, 0),
	            Position = UDim2.new(0.02521, 0, 0.02985, 0),
	            BackgroundTransparency = 0.2
	        }, {
	            Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
	            Create("ScrollingFrame", {
	                Name = "Progress",
	                Active = true,
	                BorderSizePixel = 0,
	                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	                ScrollBarImageTransparency = 1,
	                AutomaticCanvasSize = Enum.AutomaticSize.Y,
	                Size = UDim2.new(0.9292, 0, 0.88889, 0),
	                Position = UDim2.new(0.0354, 0, 0.04762, 0),
	                ScrollBarThickness = 0,
	                BackgroundTransparency = 1
	            }, {
	                Create("UIListLayout", {
	                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
	                    Padding = UDim.new(0, 2)
	                }),
	                Create("Folder", { Name = "TaskHere" }, {
	                    Create("Frame", {
	                        Name = "Task [???]",
	                        BorderSizePixel = 0,
							Visible = false,
	                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	                        Size = UDim2.new(1, 0, 0.32143, 0),
	                        BackgroundTransparency = 0.2
	                    }, {
	                        Create("UICorner", { CornerRadius = UDim.new(0, 5) }),
	                        Create("ImageButton", {
	                            Name = "Info [???]",
	                            BorderSizePixel = 0,
	                            BackgroundTransparency = 1,
	                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	                            Image = "rbxassetid://108984542249016",
	                            Size = UDim2.new(0.09524, 0, 0.77778, 0),
								ImageColor3 = Color3.fromRGB(0, 0, 0),
	                            Position = UDim2.new(0, 4, 0, 4)
	                        }),
	                        Create("TextLabel", {
	                            Name = "ProgressTask",
	                            TextWrapped = true,
	                            BorderSizePixel = 0,
	                            TextSize = 10,
	                            TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
	                            TextScaled = true,
	                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	                            FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
	                            TextColor3 = Color3.fromRGB(0, 0, 0),
	                            BackgroundTransparency = 1,
	                            Size = UDim2.new(0.69524, 0, 0.77778, 0),
	                            Position = UDim2.new(0.02857, 24, 0.11111, 0),
	                            Text = "Soon"
	                        }),
	                        Create("ImageLabel", {
	                            Name = "TaskUnComplete",
	                            BorderSizePixel = 0,
	                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	                            Image = "rbxassetid://100988669582287",
	                            Size = UDim2.new(0.10476, 0, 0.61111, 0),
	                            BackgroundTransparency = 1,
	                            Position = UDim2.new(0.8619, 0, 0.18, 0)
	                        }, {
	                            Create("ImageLabel", {
	                                Name = "Complete",
	                                BorderSizePixel = 0,
	                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	                                Image = "rbxassetid://88066926099934",
	                                Size = UDim2.new(1.27273, 0, 1.18182, 0),
	                                Visible = false,
	                                BackgroundTransparency = 1,
	                                Position = UDim2.new(0, 0, -0.18182, 0)
	                            })
	                        })
	                    })
	                })
	            })
	        })
	    })
	})
end

local TweenService = game:GetService("TweenService")
local masteryGloveGui = game.CoreGui:FindFirstChild("MasteryGui")
local mainPanel = masteryGloveGui and masteryGloveGui:FindFirstChild("Main")
local infoMastery = mainPanel and mainPanel:FindFirstChild("InfoMastery")
local infoLabel = infoMastery and infoMastery:FindFirstChild("Info")
local closeButton = infoMastery and infoMastery:FindFirstChild("Close")
local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local isTweening = false
local lastGloveName = ""
local function ToggleInfoPanel(open, text)
	if not infoMastery then return end
	if text and infoLabel then infoLabel.Text = text end
	if open then
		infoMastery.Visible = true
		local openTween = TweenService:Create(infoMastery, tweenInfo, {
			Size = UDim2.new(0.336, 0, 1, 0),
			Position = UDim2.new(0, -88, 0, 2)
		})
		openTween:Play()
	else
		local closeTween = TweenService:Create(infoMastery, tweenInfo, {
			Size = UDim2.new(0, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 2)
		})
		closeTween:Play()
		closeTween.Completed:Connect(function()
			if infoMastery.Size.X.Offset == 0 and infoMastery.Size.X.Scale == 0 then
				infoMastery.Visible = false
			end
		end)
	end
end

if closeButton then
	closeButton.MouseButton1Click:Connect(function()
		ToggleInfoPanel(false)
	end)
end

function ShowMasteryGui(show)
	if mainPanel then
		mainPanel.Visible = show
		if not show then ToggleInfoPanel(false) end
	end
end

function UpdateTaskGloveMastery()
	local taskGlove = {}
	if not _G.MasteryGlove then return taskGlove end
	local function findMastery(name)
		for gloveName, gloveData in pairs(_G.MasteryGlove) do
			if gloveName:lower() == CheckGlove():lower() then
				for statName, statValue in pairs(gloveData) do
					if statName:lower() == name:lower() then 
						return tonumber(statValue)
					end
				end
			end
		end
		return 0
	end
	local currentGlove = CheckGlove():lower()
	if _G.Gloves then
		for i, v in pairs(_G.Gloves) do
			if i:lower() == currentGlove and v.MasteryInfo and v.MasteryInfo.MasteryChallenges then
				local taskGloveN = 0
				for j, b in pairs(v.MasteryInfo.MasteryChallenges) do
					taskGloveN += 1
					local current = tonumber(findMastery(j)) or 0
					local max = tonumber(b.ProgressMaxQuantity) or 1
					taskGlove[taskGloveN] = {Text = b.Name, Max = max, Current = current, Info = b.HoverTip, Percent = math.clamp(math.floor((current / max) * 100), 0, 100)}
				end
			end
		end
	end
	if #taskGlove == 0 then
		taskGlove[1] = {Text = "No "..(CheckGlove and CheckGlove() or "Unknown").." glove mastery or soon", IsFallback = true, Info = "You should change to a glove with mastery."}
	else
		for _, task in ipairs(taskGlove) do
			task.Percent = math.min(math.floor((task.Current / task.Max) * 100), 100)
		end
	end
	return taskGlove
end

local currentTaskDataCache = {}
table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
	if not mainPanel or not mainPanel.Visible then return end
	local currentGlove = CheckGlove() or "Unknown"
	if lastGloveName ~= "" and lastGloveName ~= currentGlove then
		ToggleInfoPanel(false)
	end
	lastGloveName = currentGlove 
	local masteryFrame = mainPanel:FindFirstChild("masteryGlove")
	local progress = masteryFrame and masteryFrame:FindFirstChild("Progress")
	local taskFolder = progress and progress:FindFirstChild("TaskHere")
	if not taskFolder then return end
	local update = UpdateTaskGloveMastery()
	currentTaskDataCache = update
	local template = taskFolder:FindFirstChild("Task [???]") or taskFolder:FindFirstChildOfClass("Frame")
	for _, v in ipairs(progress:GetChildren()) do
		if v.Name:match("^Task %[%d+%]$") then
			v.Visible = false
		end
	end
	for index, taskData in ipairs(update) do
		local taskName = "Task [" .. index .. "]"
		local infoName = "Info [" .. index .. "]"
		local frame = progress:FindFirstChild(taskName)
		if not frame and template then
			frame = template:Clone()
			frame.Name = taskName
			frame.Visible = true
			frame.Parent = progress
			local infoButton = frame:FindFirstChild("Info [???]")
			if infoButton then
				infoButton.Name = infoName
				infoButton.MouseButton1Click:Connect(function()
					local liveData = currentTaskDataCache[index]
					if liveData then
						ToggleInfoPanel(true, "Task "..index..": "..liveData.Info)
					end
				end)
			end
		end
		if frame then
			local textlabel = frame:FindFirstChild("ProgressTask")
			local complete = frame:FindFirstChild("TaskUnComplete") and frame.TaskUnComplete:FindFirstChild("Complete")
			if textlabel and textlabel:IsA("TextLabel") then
				if taskData.IsFallback then
					textlabel.Text = taskData.Text
					if complete then complete.Visible = false end
				else
					textlabel.Text = string.format("%s (%d/%d) (%d%%)", taskData.Text, taskData.Current, taskData.Max, taskData.Percent)
					if complete then
						complete.Visible = (taskData.Current >= taskData.Max)
					end
				end
				frame.Visible = true
			end
		end
	end
end))

function EquipGloveRemote(Value)
	if _G.Network and _G.Network.fireServer then
		_G.Network.fireServer("SelectGlove", Value)
	end
end
function CheckUnlockGlove(Value)
	return game.Players.LocalPlayer:FindFirstChild("_unlockedGloves") and game.Players.LocalPlayer._unlockedGloves:FindFirstChild(Value)
end
function CheckGlove()
	return game.Players.LocalPlayer:FindFirstChild("leaderstats") and game.Players.LocalPlayer.leaderstats:FindFirstChild("Glove") and game.Players.LocalPlayer.leaderstats.Glove.Value
end
function CheckSlap()
	local stats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
	local slaps = stats and stats:FindFirstChild("Slaps")
	if not slaps then return 0 end
	return tonumber(slaps.Value) or 0
end
local function CheckBadge(id)
	local success, hasBadge = pcall(function()
		return game:GetService("BadgeService"):UserHasBadgeAsync(game:GetService("Players").LocalPlayer.UserId, id)
	end)
	return success and hasBadge or false
end

function IsNetworkOwner(Part)
    return Part.ReceiveAge == 0
end
function couldfound()
	GetCloudYour = nil
	for i,v in pairs(game.Workspace:GetChildren()) do
	    if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("VehicleSeat") then
	        GetCloudYour = v
	    end
	end
	return GetCloudYour
end
function notSlap(part, list)
    if not part then return false end
    for _, v in ipairs(part:GetChildren()) do
        local childName = v.Name:lower()
        for _, b in ipairs(list) do
            if childName:find(b:lower()) then
                return false
            end
        end
    end
    return true
end
function TargetPlayers(skipfriends)
	local target, targetroot, distance = nil, nil, math.huge
	for i,v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
			if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and notSlap(v.Character, BlackList) then
				if v.Character.Head:FindFirstChild("UnoReverseCard") == nil and v:FindFirstChild("leaderstats"):FindFirstChild("Glove") and v.leaderstats.Glove.Value:lower() ~= "parry" then
					local distanceTarget = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
					if distanceTarget and distanceTarget <= distance then
						if not skipfriends or not game.Players.LocalPlayer:IsFriendsWith(v.UserId) then
							target, targetroot, distance = v.Character, v.Character:FindFirstChild("HumanoidRootPart"), distanceTarget
						end
					end
				end
			end
		end
	end
	return target, targetroot, distance
end

local function GetHookGloveName()
	return tostring(EquipGlove or "Default"):lower()
end

local function ShouldPatchMethodGlove(remoteName, gloveName)
	if MethodGlove ~= true then return false end
	return (remoteName == "GoldenHit" and gloveName:find("golden"))
		or (
			remoteName == "GeneralHit"
			and (
				gloveName:find("glovel")
				or gloveName:find("mace")
				or gloveName:find("charge")
				or gloveName:find("stalker")
				or gloveName:find("mutation")
			)
		)
end

local function PatchMethodGloveArgs(self, args)
	local remoteName = tostring(self)
	local gloveName = GetHookGloveName()
	if not ShouldPatchMethodGlove(remoteName, gloveName) then return false end

	if not gloveName:find("stalker") then
		args[2] = gloveName:find("mace") and 200 or true
	else
		args[3] = 48
	end

	return true
end

local function PatchFrostbiteArgs(self, args)
	if tostring(self) ~= "GeneralAbility" or MethodGlove ~= true then return false end
	if not GetHookGloveName():find("frostbite") then return false end
	if not tonumber(args[1]) or tonumber(args[2]) then return false end

	args[1] = 3
	args[2] = 2
	return true
end

local function ShouldBlockFireServer(self, args)
	local remoteName = tostring(self)
	return (remoteName == "GeneralAbility" and args[1] == "antispam" and getgenv().AntiSpamBypass)
		or (remoteName == "Piano" and getgenv().AntiPiano)
end

local function TrackReplicaRoll(self, args)
	if tostring(self) == "Duplicate" and args[1] == true then
		ReplicaCount += 1
	end
end

local function PatchPsychokinesisArgs(self, args)
	if tostring(self) ~= "Psychokinesis" or MethodGlove ~= true then return false end
	if typeof(args[1]) ~= "table" or typeof(args[1]["throwbackAlpha"]) ~= "number" then return false end

	args[1]["throwbackAlpha"] = math.huge
	return true
end

local function ShouldBlockClientSignal(self, args)
	local remoteName = tostring(self)
	if remoteName == "Confuse" and getgenv().AntiConfuse then return true end
	return remoteName == "VFX" and args[1] == "NightmareEffect" and getgenv().AntiNightmare
end

local function InstallNamecallHook()
	if CheckExecutorSupport and not CheckExecutorSupport("namecall_hook", nil, true) then
		getgenv().HookDisabled = true
		return false
	end

	if getgenv().HookNamecallInstalled then
		getgenv().HookDisabled = false
		return true
	end

	local OriginalNamecall
	local HookClosure = function(self, ...)
		if not OriginalNamecall then return end
		if getgenv().HookDisabled then
			return OriginalNamecall(self, ...)
		end

		local args = { ... }
		local methodcall = getnamecallmethod()

		if methodcall == "FireServer" then
			if PatchMethodGloveArgs(self, args) or PatchFrostbiteArgs(self, args) then
				return OriginalNamecall(self, unpack(args))
			end
			if ShouldBlockFireServer(self, args) then
				return
			end
			TrackReplicaRoll(self, args)
		elseif methodcall == "InvokeServer" then
			if PatchPsychokinesisArgs(self, args) then
				return OriginalNamecall(self, unpack(args))
			end
		elseif methodcall == "FireClient" or methodcall == "FireAllClients" then
			if ShouldBlockClientSignal(self, args) then
				return
			end
		end

		return OriginalNamecall(self, ...)
	end

	if newcclosure then
		HookClosure = newcclosure(HookClosure)
	end

	OriginalNamecall = hookmetamethod(game, "__namecall", HookClosure)
	getgenv().HookFun = OriginalNamecall
	getgenv().HookNamecallInstalled = true
	getgenv().HookDisabled = false
	return true
end

local function RefreshNamecallHook()
	local ShouldEnableHook = MethodGlove == true
		or getgenv().AntiSpamBypass == true
		or getgenv().AntiPiano == true
		or getgenv().AntiConfuse == true
		or getgenv().AntiNightmare == true

	if ShouldEnableHook then
		if not InstallNamecallHook() then
			MethodGlove = false
			getgenv().AntiSpamBypass = false
			getgenv().AntiPiano = false
			getgenv().AntiConfuse = false
			getgenv().AntiNightmare = false
			if CheckExecutorSupport then
				CheckExecutorSupport("namecall_hook")
			end
			return false
		end
	elseif getgenv().HookNamecallInstalled then
		getgenv().HookDisabled = true
	end

	return true
end

if not loadingGetOut then
	loadingGetOut = true
	MethodGlove, EquipGlove, ReplicaCount = false, "Default", 0
end

if MethodGlove == nil then MethodGlove = false end
if EquipGlove == nil then EquipGlove = "Default" end
if ReplicaCount == nil then ReplicaCount = 0 end

getgenv().InstallSlapNamecallHook = InstallNamecallHook
getgenv().RefreshSlapNamecallHook = RefreshNamecallHook
RefreshNamecallHook()

local function combinations(list, n)
	local result = {}
	local function recurse(start, combo)
		if #combo == n then
			table.insert(result, table.clone(combo))
			return
		end
		for i = start, #list do
			table.insert(combo, list[i])
			recurse(i + 1, combo)
			table.remove(combo)
		end
	end
	recurse(1, {})
	return result
end

function findGroup(maxDist, groupSize)
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		for _, v in ipairs(combinations(players, groupSize)) do
			local allClose = true
			for i = 1, #v do
				for j = i+1, #v do
					local c1 = v[i].Character
					local c2 = v[j].Character
					if not (c1 and c1:FindFirstChild("HumanoidRootPart") and c2 and c2:FindFirstChild("HumanoidRootPart")) then
						allClose = false
						break
					end
					local p1 = c1.HumanoidRootPart.Position
					local p2 = c2.HumanoidRootPart.Position
					if (p1 - p2).Magnitude >= maxDist then
						allClose = false
						break
					end
				end
				if not allClose then break end
			end
			if allClose then
				return v
			end
		end
	end
	return nil
end

function equipglove(name)
	if CheckGlove():lower() ~= name:lower() then
		EquipGloveRemote(name)
		local tickEquip = tick()
		repeat task.wait() until tick() - tickEquip <= 0.8 or CheckGlove():lower() == name:lower()
		if CheckGlove():lower() ~= name:lower() then
			local click = workspace.Lobby:FindFirstChild(tostring(name)) and workspace.Lobby[tostring(name)]:FindFirstChildOfClass("ClickDetector")
			if click and fireclickdetector then
				fireclickdetector(click)
			end
		end
	end
end

function slapglove(obj)
	local current = CheckGlove()
	local arg
	if gloveHits[current] then
		gloveHits[current]:FireServer(obj)
	else
		if current then
			if current:lower() == "stalker" then
				arg = {obj, false, 45}
			elseif current:lower() == "glovel" or current:lower() == "mutation" then
				arg = {obj, true}
			elseif current:lower() == "mace" then
				arg = {obj, 100}
			else
				arg = {obj}
			end
			gloveHits["All"]:FireServer(unpack(arg))
		end
	end
end

---SafeSpotSpace---

if not workspace:FindFirstChild("SafeBoxSpace") then
	Create("Part", {
		Name = "SafeBoxSpace",
		Anchored = true,
		CanCollide = true,
		Transparency = 0.5,
		Position = Vector3.new(0, 15000, 0),
		Size = Vector3.new(150, 5, 150),
		Parent = workspace
	})
end

---SafeBox---

if not workspace:FindFirstChild("SafeBox") then
	local SafeBox = Create("Part", {
		Name = "SafeBox",
		Anchored = true,
		CanCollide = true,
		Transparency = 0.5,
		Position = Vector3.new(-5500, -5000, -5000),
		Size = Vector3.new(21, 5, 21),
		Parent = workspace
	}, {
		Create("Part", {
			Name = "S1",
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5,
			Position = Vector3.new(-5499.91, -4991.5, -4989.09),
			Size = Vector3.new(20, 13, 2)
		}),
		Create("Part", {
			Name = "S2",
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5,
			Size = Vector3.new(21, 14, 2),
			CFrame = CFrame.new(-5510.27979, -4991.5, -5000.08984) * CFrame.Angles(0, math.rad(-90), 0),
		}),
		Create("Part", {
			Name = "S3",
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5,
			Position = Vector3.new(-5499.3, -4991.5, -5011.12),
			Size = Vector3.new(21, 13, 2)
		}),
		Create("Part", {
			Name = "S4",
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5,
			Size = Vector3.new(22, 13, 2),
			CFrame = CFrame.new(-5489.97559, -4991.5, -4999.52637) * CFrame.Angles(0, math.rad(-90), 0)
		}),
		Create("Part", {
			Name = "S5",
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5,
			Position = Vector3.new(-5499.39, -4984, -5000.07),
			Size = Vector3.new(24, 3, 24)
		})
	})

	for _, v in ipairs(workspace.SafeBox:GetChildren()) do
		if v:IsA("BasePart") and v ~= workspace.SafeBox then
			Create("WeldConstraint", {Part0 = workspace.SafeBox, Part1 = v, Name = v.Name.." (Weld)", Parent = workspace.SafeBox})
			v.Anchored = false
		end
	end
end

---Bed---

if not workspace:FindFirstChild("Bed") then
	local Bed = Create("Part", {
		Name = "Bed",
		Anchored = true,
		CanCollide = false,
		Transparency = 1,
		Position = Vector3.new(-100019.5, 104, -1500),
		Size = Vector3.new(0.01, 0.01, 0.01),
		Parent = workspace
	}, {
		Create("Part", {
			Name = "Bed1",
			Anchored = true,
			Position = Vector3.new(-100025, 104, -1500),
			Size = Vector3.new(1, 6, 7),
			BrickColor = BrickColor.new("Burnt Sienna")
		}),
		Create("Part", {
			Name = "Bed2",
			Anchored = true,
			Position = Vector3.new(-100023, 104.5, -1500),
			Size = Vector3.new(2, 1, 6),
			BrickColor = BrickColor.new("Mid gray")
		}),
		Create("Part", {
			Name = "Bed3",
			Anchored = true,
			Position = Vector3.new(-100019, 104, -1500),
			Size = Vector3.new(11, 1, 7),
			BrickColor = BrickColor.new("Crimson")
		}),
		Create("Part", {
			Name = "Bed4",
			Anchored = true,
			Position = Vector3.new(-100013, 104, -1500),
			Size = Vector3.new(1, 6, 7),
			BrickColor = BrickColor.new("Burnt Sienna")
		}),
		Create("Part", {
			Name = "Bed5",
			Anchored = true,
			Position = Vector3.new(-100019, 103, -1500),
			Size = Vector3.new(11, 1, 7),
			BrickColor = BrickColor.new("Dark orange")
		})
	})
	
	for _, v in ipairs(workspace.Bed:GetChildren()) do
		if v:IsA("BasePart") and v ~= workspace.Bed then
			Create("WeldConstraint", {Part0 = workspace.Bed, Part1 = v, Name = v.Name.." (Weld)", Parent = workspace.Bed})
			v.Anchored = false
		end
	end
end

---SafeSpot---

if not workspace:FindFirstChild("Safespot") then
	local Safespot = Create("Part", {
		Name = "Safespot",
		Position = Vector3.new(10000,-50,10000),
		Size = Vector3.new(500,10,500),
		Anchored = true,
		CanCollide = true,
		Transparency = 0.5,
		Parent = workspace
	}, {
		Create("Part", {
			Name = "DefendPart",
			Position = Vector3.new(10000.2, 13, 9752.45),
			Size = Vector3.new(500, 117, 5),
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5
		}),
		Create("Part", {
			Name = "DefendPart1",
			Position = Vector3.new(10248.2, 13, 10002.4),
			Size = Vector3.new(5, 117, 496),
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5
		}),
		Create("Part", {
			Name = "DefendPart2",
			Position = Vector3.new(9998.13, 13, 10247.2),
			Size = Vector3.new(497, 117, 6),
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5
		}),
		Create("Part", {
			Name = "DefendPart3",
			Position = Vector3.new(9752.71, 13, 9999.28),
			Size = Vector3.new(7, 117, 490),
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5
		}),
		Create("Part", {
			Name = "DefendPart4",
			Position = Vector3.new(10001.1, 76, 9999.66),
			Size = Vector3.new(491, 10, 491),
			Anchored = true,
			CanCollide = true,
			Transparency = 0.5
		})
	})
	
	for _, v in ipairs(workspace.Safespot:GetChildren()) do
		if v:IsA("BasePart") and v ~= workspace.Safespot then
			Create("WeldConstraint", {Part0 = workspace.Safespot, Part1 = v, Name = v.Name.." (Weld)", Parent = workspace.Safespot})
			v.Anchored = false
		end
	end
end

---AntiVoidBadge---

if not workspace:FindFirstChild("Psycho") then
	Create("Part", {
		Name = "Psycho",
		Size = Vector3.new(2000,1,2000),
		Anchored = true,
		Transparency = 1,
		CanCollide = false,
		Rotation = Vector3.new(0, 0, 0),
		CFrame = CFrame.new(17800.9082, 2947, -226.017517),
		Parent = workspace
	}, {
		Create("Part", {
			Name = "Kraken",
			Size = Vector3.new(2000,1,2000),
			Anchored = true,
			Transparency = 1,
			CanCollide = false,
			Position = Vector3.new(221,29,-12632)
		}),
		Create("Part", {
			Name = "Retro1",
			Size = Vector3.new(2000,1,2000),
			Anchored = true,
			Transparency = 1,
			CanCollide = false,
			Position = Vector3.new(-16643.6289,770.0464,4707.8193)
		}, {
			Create("Part", {
				Name = "Retro2",
				Size = Vector3.new(2000,1,2000),
				Anchored = true,
				Transparency = 1,
				CanCollide = false,
				Position = Vector3.new(-16862.7910,-7.87957,4791.5551)
			}),
			Create("Part", {
				Name = "Retro3",
				Size = Vector3.new(2000,1,2000),
				Anchored = true,
				Transparency = 1,
				CanCollide = false,
				Position = Vector3.new(-28023.3046,-219.9238,4906.6015)
			})
		})
	})
end

---Anti Void---

if workspace:FindFirstChild("BobWalk1") == nil then
	local BobWalk1 = Create("Part", {
		CanCollide = false,
		Anchored = true,
		CFrame = CFrame.new(23.2798462, -19.8447475, 1.83554196, -1, 0, 0, 0, -1, 0, 0, 0, 1),
		Size = Vector3.new(1139.2593994140625, 1.5, 2048),
		Name = "BobWalk1",
		Transparency = 1,
		Parent = workspace
	})
	
	local ExtraWedges = {
		{
			CFrame = CFrame.new(-458.458344, -9.25, 1.83554196, -1, 0, 0, 0, -1, 0, 0, 0, 1),
			Size = Vector3.new(1139.2593994140625, 1.5, 2048),
			Name = "BobWalk2"
		},
		{
			CFrame = CFrame.new(-690.65979, 47.25, 1.83554196, -1, 0, 0, 0, -1, 0, 0, 0, 1),
			Size = Vector3.new(674.8563232421875, 0.6048492789268494, 2048),
			Name = "BobWalk3"
		},
		{
			CFrame = CFrame.new(402.964996, 29.25, 222.310089, -1, 0, 0, 0, -1, 0, 0, 0, 1),
			Size = Vector3.new(379.88922119140625, 1.5, 160.8837127685547),
			Name = "BobWalk4"
		},
		{
			CFrame = CFrame.new(178.719162, -18.9417267, 1.83554196, -0.989596844, -0.143868446, 0, 0.143868446, -0.989596844, 0, 0, 0, 1),
			Size = Vector3.new(143.94830322265625, 1.5, 2048),
			Name = "BobWalk5"
		},
		{
			CFrame = CFrame.new(-309.152832, 15.4761791, 1.83554196, -0.816968799, -0.576681912, 0, 0.576681912, -0.816968799, 0, 0, 0, 1),
			Size = Vector3.new(110.13511657714844, 2.740000009536743, 2048),
			Name = "BobWalk6"
		},
		{
			CFrame = CFrame.new(174.971924, 5.34897423, 222.310089, -0.838688731, 0.544611216, 0, -0.544611216, -0.838688731, 0, 0, 0, 1),
			Size = Vector3.new(89.76103210449219, 1.5, 160.8837127685547),
			Name = "BobWalk7",
		},
		{
			CFrame = CFrame.new(402.965027, 5.49165154, 74.8157959, 2.98023224e-05, -1.14142895e-05, -1, -0.668144584, -0.744031429, -1.14142895e-05, -0.744031489, 0.668144584, -2.98023224e-05),
			Size = Vector3.new(74.23055267333984, 1, 379.88922119140625),
			Name = "BobWalk8"
		},
		{
			Size = Vector3.new(379.88922119140625, 1.5, 39.77305603027344),
			CFrame = CFrame.new(402.964996, 29.9136467, 121.981705, -1,0,0,0,-1,0,0,0,1),
			Name = "BobWalk9"
		},
		{
			Size = Vector3.new(1, 88.66793823242188, 34.42972946166992),
			CFrame = CFrame.new(134.084229, -17.8583984, 94.3953705, 0.541196942, -0.354067981, 0.762719929, -0.840263784, -0.192543149, 0.506837189, -0.0325982571, -0.915184677, -0.401714325),
			Name = "BobWalk10"
		},
		{
			CFrame = CFrame.new(168.441879, 2.46393585, 125.815231, -0.350553155, -0.534268022, 0.769201458, -0.198098332, 0.845035911, 0.496660322, -0.915352523, 0.0217281878, -0.402067661),
			Size = Vector3.new(1, 0.9999924302101135, 82.1865463256836),
			Name = "BobWalk11"
		},
		{
			Name = "BobWalk12",
			Size = Vector3.new(1, 13.53612232208252, 9.847718238830566),
			CFrame = CFrame.new(206.315063, 26.9295502, 105.471031, 0.534210563, -0.415855825, -0.73599112, -0.845072925, -0.285055399, -0.452321947, -0.021697551, 0.863601387, -0.503708005)
		},
		{
			Name = "BobWalk13",
			Size = Vector3.new(1, 13.53612232208252, 99.8001480102539),
			CFrame = CFrame.new(165.965088, 2.12955856, 77.8575592, -0.53421092, -0.415855944, 0.735991359, 0.845073164, -0.285055757, 0.452322066, 0.0216975808, 0.863601625, 0.503708005)
		},
		{
			Name = "BobWalk14",
			Size = Vector3.new(1, 74.23055267333984, 80.699951171875),
			CFrame = CFrame.new(172.67041, 5.49164963, 74.8157959, -4.58955765e-05, 2.05039978e-05, 1, 0.743987858, 0.668193102, 2.05039978e-05, -0.668193102, 0.743987858, -4.58955765e-05)
		},
		{
			Name = "BobWalk15",
			Size = Vector3.new(1, 0.8520558476448059, 39.773048400878906),
			CFrame = CFrame.new(212.753906, 30.0632439, 121.981705, -0.283976078, -0.95883137, 0, 0.95883137, -0.283976078, 0, 0, 0, 1)
		},
		{
			Name = "BobWalk16",
			Size = Vector3.new(1, 36.08900451660156, 16.739320755004883),
			CFrame = CFrame.new(212.884216, 30.1233234, 121.984734, 0.544644356, 0.33412537, -0.769235253, -0.838644743, 0.223680317, -0.496630788, 0.00612583756, 0.915602207, 0.402038693)
		},
		{
			Name = "BobWalk17",
			Size = Vector3.new(1, 36.08900451660156, 82.1865463256836),
			CFrame = CFrame.new(174.83577, 5.55865097, 141.871262, -0.544644356, 0.33412537, 0.769235253, 0.838644743, 0.223680317, 0.496630788, -0.00612583756, 0.915602207, -0.402038693)
		},
		{
			Name = "BobWalk18",
			Size = Vector3.new(1, 88.66793823242188, 47.76289749145508),
			CFrame = CFrame.new(165.427338, 2.97219658, 77.884697, -0.541196942, -0.354067981, -0.762719929, 0.840263784, -0.192543149, -0.506837189, 0.0325982571, -0.915184677, 0.401714325)
		}
	}

	for _, data in ipairs(ExtraWedges) do
		Create("Part", {
			Name = data.Name,
			Size = data.Size,
			CFrame = data.CFrame,
			Anchored = true,
			CanCollide = false,
			Transparency = 1,
			Parent = BobWalk1
		})
	end
	for _, v in ipairs(workspace.BobWalk1:GetChildren()) do
		if v:IsA("BasePart") and v ~= workspace.BobWalk1 then
			Create("WeldConstraint", {Part0 = workspace.BobWalk1, Part1 = v, Name = v.Name.." (Weld)", Parent = workspace.BobWalk1})
			v.Anchored = false
		end
	end
end

if workspace:FindFirstChild("VoidPart") == nil then
local VoidPart = Create("Part", {
	Position = Vector3.new(-80.5, -10.005, -246.5),
	Name = "VoidPart",
	Size = Vector3.new(2048, 1, 2048),
	Anchored = true,
	Transparency = 1,
	CanCollide = false,
	Parent = workspace
}, {
	Create("Part", {
		Name = "TAntiVoid",
		Size = Vector3.new(2048, 15, 2048),
		Position = Vector3.new(3393, 228, 97),
		Anchored = true,
		Transparency = 1,
		CanCollide = false,
	})
})
end
end
Loading:SetCurrentStep(4)
task.wait(1)
local ESPLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/bocaj111004/ESPLibrary/refs/heads/main/Library.lua"))()
function Notification(Message, Time)
	if _G.ChooseNotify == "Obsidian" then
		Library:Notify(Message, Time or 5)
	elseif _G.ChooseNotify == "Roblox" then
		game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = Message,Icon = "rbxassetid://7733658504",Duration = Time or 5})
	end
	if _G.NotificationSound then
	    local sound = Instance.new("Sound", workspace)
	    sound.SoundId = "rbxassetid://4590662766"
	    sound.Volume = _G.VolumeTime or 2
	    sound.PlayOnRemove = true
	    sound:Destroy()
	end
end
local tanhoangviet = "https://raw.githubusercontent.com/tanhoangviet/ToolForLua/refs/heads/main/"
local tpx = loadstring(game:HttpGet(tanhoangviet.."TopbarPlus_Extended.lua"))()
local Ex = tpx.Ex
local Pre = tpx.Presets
local wminfo = Ex.watermark({
    realtime = true,
    interval = 1,
    color = Color3.fromRGB(180, 220, 255),
})

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
FrameCounter += 1
if (tick() - FrameTimer) >= 1 then
    FPS = FrameCounter
    FrameTimer = tick()
    FrameCounter = 0
end
local t = workspace.DistributedGameTime
local hours = math.floor(t / 3600)
local minutes = math.floor((t % 3600) / 60)
local seconds = math.floor(t % 60)
wminfo.setText(("FPS: %s | %s MS | [%s] | %02d Hour / %02d Minute / %02d Second"):format(
    math.floor(FPS),
    math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()),
    os.date("%X"),
    hours, minutes, seconds
))
end))

Loading:SetCurrentStep(5)
Loading:SetMessage("Done!")
Loading:SetDescription("Really!")
task.wait(1)
Loading:Continue()
Window = Library:CreateWindow({
	Footer = "Azusa Article Hub Version: 2.0.3",
	Icon = 83462777349222,
    NotifySide = "Right",
    MenuFadeTime = 0,
    SidebarCompacted = true,
    MobileButtonsMode = "Normal",
    BackgroundImage = "rbxassetid://94107130237217",
    DynamicIsland = true,
    DynamicIslandAsset = 83462777349222,
    DynamicIslandText = "Azusa Article Hub",
    DynamicIslandClosedText = "Open UI",
    DynamicIslandOpenText = "Close UI",
    DynamicIslandTopOffset = 12,
    DynamicIslandGlow = true,
    DynamicIslandGlowColor = "WhiteColor",
    DynamicIslandGlowTransparency = 0.5,
    DynamicIslandShadow = true,
    DynamicIslandIdleDelay = 2.2,
    DynamicIslandIdleTransparency = 0.56,
    DynamicIslandHoldDuration = 0.45,
    CornerRadius = 2,
    BorderColor = Color3.fromHex("#ACFFF1"),
    BorderThickness = 1.5,
    Size = UDim2.new(0,500,0,500),
    TabsMode = "Sidebar",
    FullscreenBackground = true,
    FullscreenBackgroundTransparency = 1,
})
if allowedPlaces[game.PlaceId] or getAttributes(workspace, "no_one_shot") or getAttributes(workspace, "killstreak") then
Window:ChangeTitle("Slap Battles 👏")
Tabs = {
	Tab = Window:AddTab("Info", "rbxassetid://7734053426"),
    Tab1 = Window:AddTab("Script", "rbxassetid://8997387937"),
    Tab2 = Window:AddTab("Anti", "rbxassetid://7734056608"),
    Tab3 = Window:AddTab("Badges", "rbxassetid://7733673987"),
    Tab4 = Window:AddTab("Local", "rbxassetid://4335489011"),
    Tab5 = Window:AddTab("Misc", "rbxassetid://4370318685"),
    Tab6 = Window:AddTab("Gloves Optional", "rbxassetid://7733955740"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local InfoServer1Group = Tabs.Tab:AddLeftGroupbox("Server")

CanYouFps = InfoServer1Group:AddLabel("Your Fps [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]", true)
CanYouPing = InfoServer1Group:AddLabel("Your Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]", true)
ServerPlayer = InfoServer1Group:AddLabel("Player In Server [ "..#game.Players:GetPlayers().." / "..game.Players.MaxPlayers.." ]", true)
TimeServer = InfoServer1Group:AddLabel("Server Time [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]", true)
TimeNow = InfoServer1Group:AddLabel("Now Time [ "..os.date("%X").." ]", true)
if tonumber(os.date("%H")) >= 5 and tonumber(os.date("%H")) < 12 then
AlarmTime = InfoServer1Group:AddLabel("Good Morning [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 12 and tonumber(os.date("%H")) < 17 then
AlarmTime = InfoServer1Group:AddLabel("Good Afternoon [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 17 and tonumber(os.date("%H")) < 21 then
AlarmTime = InfoServer1Group:AddLabel("Good Evening [ "..tonumber(os.date("%H")).." Hour ]", true)
else
AlarmTime = InfoServer1Group:AddLabel("Good Night [ "..tonumber(os.date("%H")).." Hour ]", true)
end
AgeAccYou = InfoServer1Group:AddLabel("You Account Age [ "..game.Players.LocalPlayer.AccountAge.." ]", true)
if game.Workspace:FindFirstChild("RoomsFolder") then
PocketSpawn = {}
for i,v in pairs(game.Workspace.RoomsFolder:GetChildren()) do
if string.find(v.Name, "'s Room") then
table.insert(PocketSpawn, v)
end
end
end
if #PocketSpawn == 0 then
PocketKeypad = InfoServer1Group:AddLabel("Pocket Room [ No ]", true)
elseif #PocketSpawn > 0 then
PocketKeypad = InfoServer1Group:AddLabel("Pocket Room [ Yes ] [ "..#PocketSpawn.." ]", true)
end
if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health == 0 then
ResetTime = InfoServer1Group:AddLabel("Time Spawn [ "..game.Players.RespawnTime.." ]", true)
else
ResetTime = InfoServer1Group:AddLabel("Time Spawn [ Not Dead ]", true)
end
CodeKeypad = InfoServer1Group:AddLabel("Code Keypad [ "..tostring((#game.Players:GetPlayers()) * 25 + 1100 - 7).." ]", true)
if not game.Workspace:FindFirstChild("Keypad") then
KeypadSpawn = InfoServer1Group:AddLabel("Keypad Spawn [ No ]", true)
else
KeypadSpawn = InfoServer1Group:AddLabel("Keypad Spawn [ Yes ]", true)
end
if not game.Workspace:FindFirstChild("Toolbox") then
ToolboxSpawn = InfoServer1Group:AddLabel("Player Spawn Toolbox [ No ]", true)
else
ToolboxSpawn = InfoServer1Group:AddLabel("Player Spawn Toolbox [ Yes ]", true)
end
if not game.Workspace:FindFirstChild("Gravestone") then
GravestoneSpawn = InfoServer1Group:AddLabel("Gravestone Spawn [ No ]", true)
else
GravestoneSpawn = InfoServer1Group:AddLabel("Gravestone Spawn [ Yes ]", true)
end
if not game.Workspace:FindFirstChild("Gift") then
GiftSpawn = InfoServer1Group:AddLabel("Player Spawn Gift [ No ]", true)
else
GiftSpawn = InfoServer1Group:AddLabel("Player Spawn Gift [ Yes ]", true)
end
if workspace.Arena.island5.Slapples:FindFirstChild("GoldenSlapple") and workspace.Arena.island5.Slapples.GoldenSlapple:FindFirstChild("Glove") and workspace.Arena.island5.Slapples.GoldenSlapple.Glove.Transparency == 1 then
GoldenSlappleSpawn = InfoServer1Group:AddLabel("Golden Slapple Spawn [ No ]", true)
else
GoldenSlappleSpawn = InfoServer1Group:AddLabel("Golden Slapple Spawn [ Yes ]", true)
end
if game.Workspace:FindFirstChild("JetOrb") then
OrbSpawn = InfoServer1Group:AddLabel("Spawn Orb [ Jet ]", true)
elseif game.Workspace:FindFirstChild("PhaseOrb") then
OrbSpawn = InfoServer1Group:AddLabel("Spawn Orb [ Phase ]", true)
elseif game.Workspace:FindFirstChild("SiphonOrb") then
OrbSpawn = InfoServer1Group:AddLabel("Spawn Orb [ Siphon ]", true)
elseif game.Workspace:FindFirstChild("MATERIALIZEOrb") then
OrbSpawn = InfoServer1Group:AddLabel("Spawn Orb [ MATERIALIZE ]", true)
else
OrbSpawn = InfoServer1Group:AddLabel("Spawn Orb [ No ]", true)
end
CheckNullShards = InfoServer1Group:AddLabel("Check Null Shard [ "..game.ReplicatedStorage.PlayerData[game.Players.LocalPlayer.Name].NullShards.Value.." ]", true)
CheckTournamentWins = InfoServer1Group:AddLabel("Check Tournament Win [ "..game.ReplicatedStorage.PlayerData[game.Players.LocalPlayer.Name].TournamentWins.Value.." ]", true)
CheckSlap = InfoServer1Group:AddLabel("Check Slap [ "..CheckSlap().." ]", true)
Glove = {}
for i,v in pairs(game.Workspace.Lobby.GloveStands:GetChildren()) do
if v.Name ~= "Unknown" then
table.insert(Glove, v)
end
end
InfoServer1Group:AddLabel("Much Glove [ "..#Glove.." ]", true)
GloveCheck = InfoServer1Group:AddLabel("You're Using Glove [ "..CheckGlove().." ]", true)
PlateTime = InfoServer1Group:AddLabel("Plate Time [ 0 ]", true)
GravityYou = InfoServer1Group:AddLabel("Gravity [ "..game.Workspace.Gravity.." ]")
PositionYou = InfoServer1Group:AddLabel("Position In Your [ "..tostring(math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X)..", ".. math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y)..", "..math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)).." ]", true)
local InfoServer3Group = Tabs.Tab:AddLeftGroupbox("Glove Badge / Slap")

local BadgeSuccess = {}
local BadgeFailure = {}
for i, v in pairs(game.Players.LocalPlayer._unlockedGloves:GetChildren()) do
if v.Value == true then
table.insert(BadgeSuccess, v)
end
if v.Value == false then
table.insert(BadgeFailure , v)
end
end

InfoServer3Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.CheckGlovePlayer = FoundPlr(Value, false)
if _G.CheckGlovePlayer then
	PlayersCheck:SetText("Player Check [ ✅ ] [ ".._G.CheckGlovePlayer.Name.." ]", _G.TimeNotify)
else
	PlayersCheck:SetText("Player Check [ ❌ ]", _G.TimeNotify)
end
    end
})

GeneralBadge = InfoServer3Group:AddLabel("General Glove / Badge [ ✅ - "..(#BadgeSuccess == 0 and "Nah" or #BadgeSuccess).." / ❌ - "..(#BadgeFailure == 0 and "Nah" or #BadgeFailure).." ]", true)
PlayersCheck = InfoServer3Group:AddLabel("Player Check [ User ]", true)

InfoServer3Group:AddButton({
    Text = "Check Glove / Badge",
    Func = function()
local BadgeSuccess = {}
local BadgeFailure = {}
local PlayerTarg = game.Players:FindFirstChild(_G.CheckGlovePlayer) or game.Players.LocalPlayer
local UnlockedGloves = PlayerTarg:FindFirstChild("_unlockedGloves")
for i, v in pairs(UnlockedGloves:GetChildren()) do
if v.Value == true then
table.insert(BadgeSuccess, v)
end
if v.Value == false then
table.insert(BadgeFailure , v)
end
end
GeneralBadge:SetText("General Glove / Badge [ ✅ - "..(#BadgeSuccess == 0 and "Nah" or #BadgeSuccess).." / ❌ - "..(#BadgeFailure == 0 and "Nah" or #BadgeFailure).." ]", true)
for i, v in pairs(UnlockedGloves:GetChildren()) do
GloveBadges["Check "..v.Name]:SetText(v.Name.." - "..(v.Value == true and "✅" or "❌"), true)
end
    end
})

GloveBadges = {}
for i, v in pairs(game.Players.LocalPlayer._unlockedGloves:GetChildren()) do
GloveBadges["Check "..v.Name] = InfoServer3Group:AddLabel(v.Name.." - "..(v.Value == true and "✅" or "❌"), true)
end

local InfoServer2Group = Tabs.Tab:AddRightGroupbox("Toggle Return")

InfoServer2Group:AddToggle("Toggle Set", {
    Text = "Toggle Return",
    Default = false,
    Callback = function(Value)
_G.AutoSetInfo = Value
    end
})
table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
if not _G.AutoSetInfo then return end
pcall(function()
CanYouFps:SetText("Your Fps [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]")
CanYouPing:SetText("Your Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]")
ServerPlayer:SetText("Player In Server [ "..#game.Players:GetPlayers().." / "..game.Players.MaxPlayers.." ]", true)
TimeServer:SetText("Server Time [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]")
TimeNow:SetText("Now Time [ "..os.date("%X").." ]")
if tonumber(os.date("%H")) >= 5 and tonumber(os.date("%H")) < 12 then
AlarmTime:SetText("Good Morning [ "..tonumber(os.date("%H")).." Hour ]")
elseif tonumber(os.date("%H")) >= 12 and tonumber(os.date("%H")) < 17 then
AlarmTime:SetText("Good Afternoon [ "..tonumber(os.date("%H")).." Hour ]")
elseif tonumber(os.date("%H")) >= 17 and tonumber(os.date("%H")) < 21 then
AlarmTime:SetText("Good Evening [ "..tonumber(os.date("%H")).." Hour ]")
else
AlarmTime:SetText("Good Night [ "..tonumber(os.date("%H")).." Hour ]")
end
if game.Workspace:FindFirstChild("RoomsFolder") then
PocketSpawn = {}
for i,v in pairs(game.Workspace.RoomsFolder:GetChildren()) do
if string.find(v.Name, "'s Room") then
table.insert(PocketSpawn, v)
end
end
end
if #PocketSpawn == 0 then
PocketKeypad:SetText("Pocket Room [ No ]")
elseif #PocketSpawn > 0 then
PocketKeypad:SetText("Pocket Room [ Yes ] [ "..#PocketSpawn.." ]")
end
AgeAccYou:SetText("You Account Age [ "..game.Players.LocalPlayer.AccountAge.." ]")
if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health == 0 then
ResetTime:SetText("Time Spawn [ "..game.Players.RespawnTime.." ]")
else
ResetTime:SetText("Time Spawn [ Not Dead ]")
end
CodeKeypad:SetText("Code Keypad [ "..tostring((#game.Players:GetPlayers()) * 25 + 1100 - 7).." ]")
if not game.Workspace:FindFirstChild("Keypad") then
KeypadSpawn:SetText("Keypad Spawn [ No ]")
else
KeypadSpawn:SetText("Keypad Spawn [ Yes ]")
end
if not game.Workspace:FindFirstChild("Toolbox") then
ToolboxSpawn:SetText("Player Spawn Toolbox [ No ]")
else
ToolboxSpawn:SetText("Player Spawn Toolbox [ Yes ]")
end
if not game.Workspace:FindFirstChild("Gravestone") then
GravestoneSpawn:SetText("Gravestone Spawn [ No ]")
else
GravestoneSpawn:SetText("Gravestone Spawn [ Yes ]")
end
if not game.Workspace:FindFirstChild("Gift") then
GiftSpawn:SetText("Player Spawn Gift [ No ]")
else
GiftSpawn:SetText("Player Spawn Gift [ Yes ]")
end
if workspace.Arena.island5.Slapples:FindFirstChild("GoldenSlapple") and workspace.Arena.island5.Slapples.GoldenSlapple:FindFirstChild("Glove") and workspace.Arena.island5.Slapples.GoldenSlapple.Glove.Transparency == 1 then
GoldenSlappleSpawn:SetText("Golden Slapple Spawn [ No ]")
else
GoldenSlappleSpawn:SetText("Golden Slapple Spawn [ Yes ]")
end
if game.Workspace:FindFirstChild("JetOrb") then
OrbSpawn:SetText("Spawn Orb [ Jet ]")
elseif game.Workspace:FindFirstChild("PhaseOrb") then
OrbSpawn:SetText("Spawn Orb [ Phase ]")
elseif game.Workspace:FindFirstChild("SiphonOrb") then
OrbSpawn:SetText("Spawn Orb [ Siphon ]")
elseif game.Workspace:FindFirstChild("MATERIALIZEOrb") then
OrbSpawn:SetText("Spawn Orb [ MATERIALIZE ]")
else
OrbSpawn:SetText("Spawn Orb [ No ]")
end
CheckNullShards:SetText("Check Null Shard [ "..game.ReplicatedStorage.PlayerData[game.Players.LocalPlayer.Name].NullShards.Value.." ]")
CheckTournamentWins:SetText("Check Tournament Win [ "..game.ReplicatedStorage.PlayerData[game.Players.LocalPlayer.Name].TournamentWins.Value.." ]")
CheckSlap:SetText("Check Slap [ "..game.Players.LocalPlayer.leaderstats.Slaps.Value.." ]")
GloveCheck:SetText("You're Using Glove [ "..CheckGlove().." ]")
PlateTime:SetText("Plate Time [ "..(game.Players.LocalPlayer.Character:FindFirstChild("PlateCounter") and game.Players.LocalPlayer.Character:FindFirstChild("PlateCounter").Value or "0").." ]")
GravityYou:SetText("Gravity [ "..game.Workspace.Gravity.." ]", true)
PositionYou:SetText("Position In Your [ "..tostring(math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X)..", ".. math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y)..", "..math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)).." ]")
end)
end))

InfoServer2Group:AddButton("Copy Position", function()
    if setclipboard then
        setclipboard(tostring(math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X)..", ".. math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y)..", "..math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)))
        Notification("Copied Success", _G.TimeNotify)
    else
        Notification(tostring(math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X)..", ".. math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y)..", "..math.round(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)), _G.TimeNotify)
    end
end)

local InfoServer4Group = Tabs.Tab:AddRightGroupbox("Search Glove Player")

InfoServer4Group:AddInput("GlovePlayers", {
    Default = "",
    Numeric = false,
    Text = "Search Glove",
    Finished = false,
    Placeholder = "Glove",
    Callback = function(Value)
local GlovePlayer = Value
local Glove
for _, v in pairs(game.Workspace.Lobby.GloveStands:GetChildren()) do
if string.sub(v.Name, 1, #GlovePlayer):lower() == GlovePlayer:lower() then
Glove = v
break
end
end
if Glove then
_G.GlovePlayer = Glove.Name
TagGlove:SetText("Glove Check [ ✅ ] [ "..Glove.Name.." ]", _G.TimeNotify)
else
TagGlove:SetText("Glove Check [ ❌ ]", _G.TimeNotify)
end
    end
})

TagGlove = InfoServer4Group:AddLabel("Glove Search [ Nah ]", true)

InfoServer4Group:AddButton({
    Text = "Search Glove",
    Func = function()
_G.GloveSearch = {}
_G.PlayerOwner = {}
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer then
for i, b in pairs(v._unlockedGloves:GetChildren()) do
if b.Name == _G.GlovePlayer and b.Value == true then
table.insert(_G.GloveSearch, b)
_G.PlayerOwner[#_G.PlayerOwner + 1] = (v.Name == v.DisplayName and " • "..v.Name or " • "..v.Name.." ("..v.DisplayName..")")
OwnerPlayer:SetText("Owner [\n"..(_G.PlayerOwner == 0 and "Nah" or (table.concat(_G.PlayerOwner, ",\n"))).."\n]")
end
end
end
end
if #_G.GloveSearch > 0 then
SearchPlayer:SetText("Player Owner [ "..(#_G.GloveSearch == 0 and "Nah" or #_G.GloveSearch).." ]")
elseif #_G.GloveSearch == 0 then
SearchPlayer:SetText("Player Owner [ Nah ]")
OwnerPlayer:SetText("Owner [ Nah ]")
end
    end
})

InfoServer4Group:AddToggle("Search Glove", {
    Text = "Auto Search Glove",
    Default = false,
    Callback = function(Value)
_G.AutoSearchGlove = Value
while _G.AutoSearchGlove do
_G.GloveSearch = {}
_G.PlayerOwner = {}
for i, v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer then
for i, b in pairs(v._unlockedGloves:GetChildren()) do
if b.Name == _G.GlovePlayer and b.Value == true then
table.insert(_G.GloveSearch, b)
_G.PlayerOwner[#_G.PlayerOwner + 1] = (v.Name == v.DisplayName and " • "..v.Name or " • "..v.Name.." ("..v.DisplayName..")")
OwnerPlayer:SetText("Owner [\n"..(_G.PlayerOwner == 0 and "Nah" or (table.concat(_G.PlayerOwner, ",\n"))).."\n]")
end
end
end
end
if #_G.GloveSearch > 0 then
SearchPlayer:SetText("Player Owner [ "..(#_G.GloveSearch == 0 and "Nah" or #_G.GloveSearch).." ]")
elseif #_G.GloveSearch == 0 then
SearchPlayer:SetText("Player Owner [ Nah ]")
OwnerPlayer:SetText("Owner [ Nah ]")
end
task.wait()
end
    end
})

SearchPlayer = InfoServer4Group:AddLabel("Player Owner [ Nah ]", true)
OwnerPlayer = InfoServer4Group:AddLabel("Owner [ Nah ]", true)

local InfoServer5Group = Tabs.Tab:AddRightGroupbox("Check")

InfoServer5Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.CheckPlayer = FoundPlr(Value, false)
if _G.CheckPlayer then
	PlayersCheck1:SetText("Player Check [ ✅ ] [ ".._G.CheckPlayer.Name.." ]")
else
	PlayersCheck1:SetText("Player Check [ ❌ ]")
end
    end
})

PlayersCheck1 = InfoServer5Group:AddLabel("Player Check [ Nah ]", true)

InfoServer5Group:AddToggle("Toggle Set", {
    Text = "Toggle Return",
    Default = false,
    Callback = function(Value)
_G.AutosetCheckPlayer = Value
    end
})

table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
if not _G.AutosetCheckPlayer then return end
pcall(function()
	if _G.CheckPlayer.Character and game.ReplicatedStorage.PlayerData:FindFirstChild(_G.CheckPlayer.Name) then
		CheckNullShardsPlayer:SetText("Check Null Shard [ "..game.ReplicatedStorage.PlayerData[_G.CheckPlayer.Name].NullShards.Value.." ]")
		CheckTournamentWinsPlayer:SetText("Check Tournament Win [ "..game.ReplicatedStorage.PlayerData[_G.CheckPlayer.Name].TournamentWins.Value.." ]")
		CheckSlapPlayer:SetText("Check Slap [ "..game.Players[_G.CheckPlayer.Name].leaderstats.Slaps.Value.." ]")
		GloveCheckPlayer:SetText("Using Glove [ "..game.Players[_G.CheckPlayer.Name].leaderstats.Glove.Value.." ]")
		if game.Players[_G.CheckPlayer].Character ~= nil and game.Players[_G.CheckPlayer.Name].Character:FindFirstChild("HumanoidRootPart") ~= nil then
			PositionPlayer:SetText("Position [ "..tostring(math.round(game.Players[_G.CheckPlayer.Name].Character.HumanoidRootPart.Position.X)..", ".. math.round(game.Players[_G.CheckPlayer].Character.HumanoidRootPart.Position.Y)..", "..math.round(game.Players[_G.CheckPlayer].Character.HumanoidRootPart.Position.Z)).." ]")
		else
			PositionPlayer:SetText("Position [ Nah ]")
		end
	else
		CheckNullShardsPlayer:SetText("Check Null Shard [ Nah ]")
		CheckTournamentWinsPlayer:SetText("Check Tournament Win [ Nah ]")
		CheckSlapPlayer:SetText("Check Slap [ Nah ]")
		GloveCheckPlayer:SetText("Using Glove [ Nah ]")
		PositionPlayer:SetText("Position [ Nah ]")
	end
end)
end))

CheckNullShardsPlayer = InfoServer5Group:AddLabel("Check Null Shard [ Nah ]", true)
CheckTournamentWinsPlayer = InfoServer5Group:AddLabel("Check Tournament Win [ Nah ]", true)
CheckSlapPlayer = InfoServer5Group:AddLabel("Check Slap [ Nah ]", true)
GloveCheckPlayer = InfoServer5Group:AddLabel("Using Glove [ Nah ]", true)
PositionPlayer = InfoServer5Group:AddLabel("Position [ Nah ]", true)

local Script1Group = Tabs.Tab1:AddLeftGroupbox("Script Basic")

Script1Group:AddButton({
    Text = "Execute | Ui Library",
    Func = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/Executor.lua"))()
    end
})

Script1Group:AddButton({
    Text = "Keyboard",
    Func = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt", true))()
    end
})

Script1Group:AddButton({
    Text = "Inf yield Delta",
    Func = function()
loadstring(game:HttpGet("https://gist.githubusercontent.com/lxnnydev/c533c374ca4c1dcef4e1e10e33fa4a0c/raw/03e74f184f801dad77d3ebe1e2f18c6ac87ca612/delta___IY.gistfile1.txt.lua",true))()
    end
})

Script1Group:AddButton({
    Text = "Inf yield",
    Func = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
    end
})

local Script2Group = Tabs.Tab1:AddRightGroupbox("Script")

Script2Group:AddButton({
    Text = "Position Gui",
    Func = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/Position.lua", true))()
    end
})

Script2Group:AddButton({
    Text = "Dex V2",
    Func = function()
loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
wait(2)
repeat task.wait()
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Dex") and game.Players.LocalPlayer.PlayerGui.Dex.ResetOnSpawn == true then
game.Players.LocalPlayer.PlayerGui.Dex.ResetOnSpawn = false
end
until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Dex") and game.Players.LocalPlayer.PlayerGui.Dex.ResetOnSpawn == false
    end
})

Script2Group:AddButton({
    Text = "Dex V3",
    Func = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
    end
})

Script2Group:AddButton({
    Text = "Dex V4",
    Func = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/Dex-v4.lua"))()
    end
})

Script2Group:AddButton({
    Text = "Simple Spy",
    Func = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/SimpleSpy/SourceBeta.lua"))()
    end
})

local Anti1Group = Tabs.Tab2:AddLeftGroupbox("Toggle All")

_G.AntiToggles = {}
if game.Workspace:FindFirstChild("NoChanged") == nil then
	Create("BoolValue", {Name = "NoChanged", Parent = workspace})
end
_G.AntiToggles["Toggle Anti"] = Anti1Group:AddToggle("Toggle Anti", {
    Text = "Toggle Anti",
    Default = false,
    Callback = function(Value)
game.Workspace.NoChanged.Value = Value
    end
}):AddKeyPicker("ToggleAnti", {
   Default = "X",
   Text = "Toggle Anti",
   Mode = "Toggle" ,
   SyncToggleState = true
})

local Anti2Group = Tabs.Tab2:AddRightGroupbox("Anti")

Anti2Group:AddSlider("Transparency Anti Void", {
    Text = "Transparency Anti Void",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.Transparency = Value
    end
})

Anti2Group:AddDropdown("Choose Anti Void", {
    Text = "Choose Anti Void",
    Values = {"Normal","Retro","Water","Psycho","Bob","Fall"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AntiVoidChoose = Value
    end
})

local AntiDependencyBox = Anti2Group:AddDependencyBox()

AntiDependencyBox:AddButton({
    Text = "Set Fall Pos",
    Visible = false,
    Func = function()
if LoadSetFallPos then return end
LoadSetFallPos = true
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
if Character and Character:FindFirstChild("HumanoidRootPart") then
	for _, v in pairs(workspace:GetChildren()) do
		if v.Name == "Old Fall (Yourself)" then
			v:Destroy()
		end
	end
	if not workspace:FindFirstChild("Old Fall (Yourself)") then
		local desc = Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
		local Yourself = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R6)
		Yourself.Name = "Old Fall (Yourself)"
		Yourself.Parent = workspace
		local Root = Character.HumanoidRootPart
		local Position = Root.Position
		Yourself:SetPrimaryPartCFrame(CFrame.new(Position))
		Yourself.Humanoid:ApplyDescription(desc)
	end
end
task.wait(0.3)
LoadSetFallPos = false
    end
})

table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
	if workspace:FindFirstChild("Old Fall (Yourself)") then
		for i, v in pairs(workspace:FindFirstChild("Old Fall (Yourself)"):GetChildren()) do
			if v:IsA("BasePart") then
				v.Anchored = true
				v.CanCollide = false
				v.Transparency = _G.Transparency or 0.7
			end
		end
	end
end))

AntiDependencyBox:AddButton({
    Text = "Destroy Fall Pos",
    Visible = false,
    Func = function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name == "Old Fall (Yourself)" then
			v:Destroy()
		end
	end
end
    end
})

AntiDependencyBox:SetupDependencies({
	{Options["Choose Anti Void"], "Fall"}
})

function partapply(part, enable)
	part.CanCollide = enable and true or false
	part.Transparency = enable and _G.Transparency or 1
	for _, v in ipairs(part:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = enable and true or false
			v.Transparency = enable and _G.Transparency or 1
		end
	end
end
function disable(part)
	if part:IsA("BasePart") then
		part.CanCollide = false
		part.Transparency = 1
	end
end
function disableChildren(obj)
	for _, v in ipairs(obj:GetDescendants()) do
		if v:IsA("BasePart") then
			disable(v)
		end
	end
end

_G.AntiToggles["Anti Void"] = Anti2Group:AddToggle("Anti Void", {
    Text = "Anti Void",
    Default = false,
    Callback = function(Value)
_G.AntiVoid = Value
while _G.AntiVoid do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y < -30 then
	if _G.AntiVoidChoose == "Fall" then
		if workspace:FindFirstChild("Old Fall (Yourself)") and workspace["Old Fall (Yourself)"]:FindFirstChild("HumanoidRootPart") then
			FallCFrame = workspace["Old Fall (Yourself)"].HumanoidRootPart.CFrame
		else
			FallCFrame = game.Workspace.Origo.CFrame * CFrame.new(0,-5,0)
		end
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(FallCFrame)
	end
end
for _, v in ipairs(workspace:GetChildren()) do
	if v.Name == "BobWalk1" and v:IsA("BasePart") then
		partapply(v, _G.AntiVoidChoose:lower():find("bob"))
	end
	if v.Name == "Psycho" and v:IsA("BasePart") then
		partapply(v, _G.AntiVoidChoose:lower():find("psycho"))
		if v:FindFirstChild("Kraken") then
			partapply(v.Kraken, _G.AntiVoidChoose:lower():find("water"))
		end
		if v:FindFirstChild("Retro1") then
			partapply(v.Retro1, _G.AntiVoidChoose:lower():find("retro"))
		end
	end
	if v.Name == "VoidPart" then
		partapply(v, _G.AntiVoidChoose == "Normal")
		if v:FindFirstChild("TAntiVoid") then
			partapply(v.TAntiVoid, _G.AntiVoidChoose:lower():find("normal") or _G.AntiVoidChoose:lower():find("bob"))
		end
	end
end
task.wait()
end
for _, v in ipairs(workspace:GetChildren()) do
	if v.Name == "BobWalk1" then
		disable(v)
		disableChildren(v)
	end
	if v.Name == "Psycho" then
		disable(v)
		if v:FindFirstChild("Kraken") then
			disable(v.Kraken)
		end
		if v:FindFirstChild("Retro1") then
			disable(v.Retro1)
			disableChildren(v.Retro1)
		end
	end
	if v.Name == "VoidPart" then
		disable(v)
		if v:FindFirstChild("TAntiVoid") then
			disable(v.TAntiVoid)
		end
	end
end
    end
})

_G.AntiToggles["Anti Portal"] = Anti2Group:AddToggle("Anti Portal", {
    Text = "Anti Portal",
    Default = false,
    Callback = function(Value)
_G.AntiPortal = Value
if _G.AntiPortal == true then
workspace.Lobby.Teleport2.CanTouch = false
workspace.Lobby.Teleport3.CanTouch = false
workspace.Lobby.Teleport4.CanTouch = false
workspace.Lobby.Teleport6.CanTouch = false
else
workspace.Lobby.Teleport2.CanTouch = true
workspace.Lobby.Teleport3.CanTouch = true
workspace.Lobby.Teleport4.CanTouch = true
workspace.Lobby.Teleport6.CanTouch = true
end
    end
})

_G.AntiToggles["Anti Admin"] = Anti2Group:AddToggle("Anti Admin", {
    Text = "Anti Admin",
    Default = false,
    Callback = function(Value)
_G.AntiMods = Value
while _G.AntiMods do
for i,v in pairs(game.Players:GetChildren()) do
        if v:GetRankInGroupAsync(9950771) >= 2 then
         _G.AntiKick = false
     game.Players.LocalPlayer:Kick("High Rank Player Detected.".." [ "..v.Name.." ]")
   break
     end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Kick"] = Anti2Group:AddToggle("Anti Kick", {
    Text = "Anti Kick",
    Default = false,
    Callback = function(Value)
_G.AntiKick = Value
while _G.AntiKick do
for i,v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetDescendants()) do
                    if v.Name == "ErrorPrompt" then
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
                    end
                end
task.wait()
end
    end
})

_G.AntiToggles["Anti Afk"] = Anti2Group:AddToggle("Anti Afk", {
    Text = "Anti Afk",
    Default = false,
    Callback = function(Value)
_G.AntiAfk = Value
if getconnections then
	for i,v in next, getconnections(game.Players.LocalPlayer.Idled) do
		if _G.AntiAfk then
			v:Disable()
		else
			v:Enable()
		end
	end
end
if not getconnections then
	if not AntiAfkConnect then
		AntiAfkConnect = game.Players.LocalPlayer.Idled:Connect(function()
			if _G.AntiAfk then
				game:GetService("VirtualUser"):CaptureController()
				game:GetService("VirtualUser"):ClickButton2(Vector2.new())
			end
		end)
	end
end
    end
})

_G.AntiToggles["Anti Obby"] = Anti2Group:AddToggle("Anti Obby", {
    Text = "Anti Obby",
    Default = false,
    Callback = function(Value)
_G.AntiObby = Value
while _G.AntiObby do
for _, v in pairs(game.Workspace:GetChildren()) do
          if string.find(v.Name, "Lava") then
             if v.CanTouch == true then
                 v.CanTouch = false
             end
         end
     end
task.wait()
end
if _G.AntiObby == false then
for _, v in pairs(game.Workspace:GetChildren()) do
          if string.find(v.Name, "Lava") then
              if v.CanTouch == false then
                  v.CanTouch = true
             end
         end
    end
end
    end
})

_G.AntiToggles["Anti Megarock"] = Anti2Group:AddToggle("Anti Megarock", {
    Text = "Anti Megarock | Custom",
    Default = false,
    Callback = function(Value)
_G.AntiRock = Value
while _G.AntiRock do
for _,v in pairs(game.Players:GetChildren()) do
                    if v.Character and v.Character:FindFirstChild("rock") then
                        v.Character.rock.CanTouch = false
                        v.Character.rock.CanQuery = false
                    end
                end
task.wait()
end
    end
})

_G.AntiToggles["Anti Cherry"] = Anti2Group:AddToggle("Anti Cherry", {
    Text = "Anti Cherry",
    Default = false,
    Callback = function(Value)
_G.AntiCherry = Value
while _G.AntiCherry do
if workspace:FindFirstChild("cherry_storage") then
for i, v in pairs(workspace.cherry_storage:GetChildren()) do
if not v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("clone_remote") and v:FindFirstChild("HumanoidRootPart") then
slapglove(v:FindFirstChild("HumanoidRootPart"))
end
end
end
task.wait()
end
    end
})

if hookmetamethod then
	_G.AntiToggles["Anti Spam Bypass"] = Anti2Group:AddToggle("Anti Spam Bypass", {
	    Text = "Anti Spam Bypass (Chainsaw)",
	    Default = false,
	    Callback = function(Value)
	getgenv().AntiSpamBypass = Value
	    end
	})
end

_G.AntiToggles["Anti Piano"] = Anti2Group:AddToggle("Anti Piano", {
    Text = "Anti Piano",
    Default = false,
    Callback = function(Value)
if hookmetamethod then getgenv().AntiPiano = Value end
if not hookmetamethod then
	local Piano = game:GetService("ReplicatedStorage"):FindFirstChild("Piano") or game:GetService("ReplicatedStorage"):FindFirstChild("_Piano_")
	if Piano then
		Piano.Name = Value and "_Piano_" or "Piano"
	end
end
    end
})

_G.AntiToggles["Anti Boss Guide"] = Anti2Group:AddToggle("Anti Boss Guide", {
    Text = "Anti Join Boss Guide",
    Default = false,
    Callback = function(Value)
_G.AntiJoinBossGuide = Value
while _G.AntiJoinBossGuide do
for i, v in pairs(workspace.BountyHunterRoom.Build:GetChildren()) do
if v.Name == "Model" and v:FindFirstChild("Meshes/boxshadow_Cube.005") and v["Meshes/boxshadow_Cube.005"]:FindFirstChild("Hitbox") then
v["Meshes/boxshadow_Cube.005"].Hitbox.CanTouch = false
end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Snowball"] = Anti2Group:AddToggle("Anti Snowball", {
    Text = "Anti Snowball",
    Default = false,
    Callback = function(Value)
_G.AntiSnowball = Value
while _G.AntiSnowball do
for i, v in pairs(workspace:GetChildren()) do
if v.Name == "Snowball" then
v:Destroy()
end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Ball Baller"] = Anti2Group:AddToggle("Anti Ball Baller", {
    Text = "Anti Ball Baller",
    Default = false,
    Callback = function(Value)
_G.AntiBallBaller = Value
while _G.AntiBallBaller do
for i,v in pairs(game.Workspace:GetChildren()) do
    if v.Name == "ClonedBall" then
        v:Destroy()
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Venom Infected"] = Anti2Group:AddToggle("Anti Venom Infected", {
    Text = "Anti Is Ice",
    Default = false,
    Callback = function(Value)
_G.AntiVenomInfected = Value
while _G.AntiVenomInfected do
for i, v in pairs(game.Workspace:GetChildren()) do
    if v.Name == "is_ice" then
        v.CanTouch = false
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Ghost Player"] = Anti2Group:AddToggle("Anti Ghost Player", {
    Text = "Anti Ghost Player",
    Default = false,
    Callback = function(Value)
_G.AntiGhostPlayer = Value
while _G.AntiGhostPlayer do
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer.Name and game.Workspace:FindFirstChild(v.Name.."_Body") and game.Workspace[v.Name.."_Body"]:FindFirstChild("Part") then
slapglove(game.Workspace[v.Name.."_Body"].Part)
end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Trap"] = Anti2Group:AddToggle("Anti Trap", {
    Text = "Anti Trap",
    Default = false,
    Callback = function(Value)
_G.AntiTrap = Value
while _G.AntiTrap do
for i, v in pairs(game.Workspace:GetChildren()) do
if v.Name == "BearTrap" and v:FindFirstChild("HitBox") then
v.HitBox.CanTouch = false
v.HitBox.CanQuery = false
end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Paint Splash"] = Anti2Group:AddToggle("Anti Paint Splash", {
    Text = "Anti Paint Splash",
    Default = false,
    Callback = function(Value)
_G.AntiPaintSplash = Value
while _G.AntiPaintSplash do
for i,v in pairs(game.Workspace:GetChildren()) do
    if string.find(v.Name:lower(), "paint") then
        v.CanTouch = false
        v.CanQuery = false
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Tycoon Mastery"] = Anti2Group:AddToggle("Anti Tycoon Mastery", {
    Text = "Anti Tycoon Kill Brick",
    Default = false,
    Callback = function(Value)
_G.AntiTycoonMatery = Value
while _G.AntiTycoonMatery do
for i,v in pairs(game.Workspace:GetChildren()) do
    if string.find(v.Name:lower(), "tycoon") and not v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("Building") then
	    for _, j in pairs(v:GetDescendants()) do
			if j.Name:lower():find("killbrick") or j.Name:lower():find("doorbeam") then
				j.CanTouch = false
				j.CanQuery = false
			end
		end
    end
end
task.wait(0.3)
end
    end
})

_G.AntiToggles["Anti Lure"] = Anti2Group:AddToggle("Anti Lure", {
    Text = "Anti Lure",
    Default = false,
    Callback = function(Value)
_G.AntiLure = Value
while _G.AntiLure do
local function foundlurechar()
	local lure
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	    if v.Name:lower():find("lure") then
	        lure = v
	    end
	end
	return lure
end
for i,v in pairs(game.Workspace:GetChildren()) do
    if string.find(v.Name, "_lure") and v:FindFirstChild("Root") and v:FindFirstChild("watercircle") and foundlurechar() then
        local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Root.CFrame
        wait(0.5)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
        wait(0.5)
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Mail"] = Anti2Group:AddToggle("Anti Mail", {
    Text = "Anti Mail",
    Default = false,
    Callback = function(Value)
game.Players.LocalPlayer.Character.YouHaveGotMail.Disabled = Value
_G.AntiMail = Value
while _G.AntiMail do
if game.Players.LocalPlayer.Character:FindFirstChild("YouHaveGotMail") then
game.Players.LocalPlayer.Character.YouHaveGotMail.Disabled = true
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Water"] = Anti2Group:AddToggle("Anti Water", {
    Text = "Anti Water",
    Default = false,
    Callback = function(Value)
_G.AntiWater = Value
while _G.AntiWater do
if game.Workspace:FindFirstChild("puddles") then
   for i,v in pairs(game.Workspace.puddles:GetChildren()) do
          if v.Name == "puddle" then
             v.CanTouch = false
         end
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Jail Admin"] = Anti2Group:AddToggle("Anti Jail Admin", {
    Text = "Anti Jail Admin",
    Default = false,
    Callback = function(Value)
_G.AntiJailAdmin = Value
while _G.AntiJailAdmin do
for i,v in pairs(game.Workspace:GetChildren()) do
	if v.Name == "jail" then
		for i,h in pairs(v:GetChildren()) do
			if h:IsA("BasePart") then
	            h.CanCollide = false
			end
        end
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Mitten Blind"] = Anti2Group:AddToggle("Anti Mitten Blind", {
    Text = "Anti Mitten Blind",
    Default = false,
    Callback = function(Value)
_G.AntiMittenBlind = Value
while _G.AntiMittenBlind do
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("MittenBlind") then
game.Players.LocalPlayer.PlayerGui:FindFirstChild("MittenBlind"):Destroy()
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Knockoff"] = Anti2Group:AddToggle("Anti Knockoff", {
    Text = "Anti Knockoff",
    Default = false,
    Callback = function(Value)
_G.AntiKnock = Value
while _G.AntiKnock do
if game.Workspace.CurrentCamera and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Workspace.CurrentCamera.CameraSubject ~= game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Workspace.CurrentCamera.CameraSubject == game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s_falsehead") then
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Hallow"] = Anti2Group:AddToggle("Anti Hallow", {
    Text = "Anti Hallow - Jack",
    Default = false,
    Callback = function(Value)
if game.Players.LocalPlayer:FindFirstChild("PlayerScripts"):FindFirstChild("LegacyClient") and game.Players.LocalPlayer.PlayerScripts.LegacyClient:FindFirstChild("HallowJackAbilities") then
	game.Players.LocalPlayer.PlayerScripts.LegacyClient.HallowJackAbilities.Disabled = Value
end
    end
})

_G.AntiToggles["Anti Booster"] = Anti2Group:AddToggle("Anti Booster", {
    Text = "Anti Booster",
    Default = false,
    Callback = function(Value)
_G.AntiBooster = Value
while _G.AntiBooster do
for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
    if v.Name == "BoosterObject" then
        v:Destroy()
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Squid"] = Anti2Group:AddToggle("Anti Squid", {
    Text = "Anti Squid",
    Default = false,
    Callback = function(Value)
_G.AntiSquid = Value
if _G.AntiSquid == false then
game.Players.LocalPlayer.PlayerGui.SquidInk.Enabled = true
end
while _G.AntiSquid do
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("SquidInk") then
game.Players.LocalPlayer.PlayerGui.SquidInk.Enabled = false
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Lamp"] = Anti2Group:AddToggle("Anti Lamp", {
    Text = "Anti Lamp",
    Default = false,
    Callback = function(Value)
_G.AntiLamp = Value
while _G.AntiLamp do
for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
	if v.Name:find("whiteframe") then
		v.Enabled = false
	end
end
for i, v in pairs(game.Lighting:GetChildren()) do
	if v.Name:find("lampcc") then
		v.Enabled = false
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Pie"] = Anti2Group:AddToggle("Anti Pie", {
    Text = "Anti Pie",
    Default = false,
    Callback = function(Value)
_G.AntiPie = Value
while _G.AntiPie do
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("PieSplash") then
game.Players.LocalPlayer.PlayerGui:FindFirstChild("PieSplash"):Destroy()
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Conveyor"] = Anti2Group:AddToggle("Anti Conveyor", {
    Text = "Anti Conveyor",
    Default = false,
    Callback = function(Value)
if game.Players.LocalPlayer:FindFirstChild("PlayerScripts"):FindFirstChild("LegacyClient") and game.Players.LocalPlayer.PlayerScripts.LegacyClient:FindFirstChild("ConveyorVictimized") then
	game.Players.LocalPlayer.PlayerScripts.LegacyClient.ConveyorVictimized.Disabled = Value
end
    end
})

_G.AntiToggles["Anti Ice"] = Anti2Group:AddToggle("Anti Ice", {
    Text = "Anti Ice",
    Default = false,
    Callback = function(Value)
_G.AntiIce = Value
while _G.AntiIce do
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	if v.Name == "Icecube" then
	    v:Destroy()
		if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
		    game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
		end
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Time Stop"] = Anti2Group:AddToggle("Anti Time Stop", {
    Text = "Anti Time Stop",
    Default = false,
    Callback = function(Value)
_G.AntiTimestop = Value
while _G.AntiTimestop do
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v.ClassName == "Part" then
        v.Anchored = false
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Null"] = Anti2Group:AddToggle("Anti Null", {
    Text = "Anti Null",
    Default = false,
    Callback = function(Value)
_G.AntiNull = Value
while _G.AntiNull do
for i,v in pairs(game.Workspace:GetChildren()) do
	if v.Name == "Imp" and v:FindFirstChild("Body") then
        slapglove(v:FindFirstChild("Body"))
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Run"] = Anti2Group:AddToggle("Anti Run", {
    Text = "Anti Run",
    Default = false,
    Callback = function(Value)
_G.AutoExit = Value
while _G.AutoExit do
if game.Players.LocalPlayer.Character:FindFirstChild("InLabyrinth") then
for i, v in pairs(workspace:GetChildren()) do
    if string.find(v.Name, "Labyrinth") and v:FindFirstChild("Doors") then
        for i, y in ipairs(v.Doors:GetChildren()) do
            if y:FindFirstChild("Hitbox") and y.Hitbox:FindFirstChild("TouchInterest") then
	            y.Hitbox.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Record"] = Anti2Group:AddToggle("Anti Record", {
    Text = "Anti Record (Chat)",
    Default = false,
    Callback = function(Value)
_G.AntiRecord = Value
    end
})
local function findRec(p)
	if p ~= game.Players.LocalPlayer then
		p.Chatted:Connect(function(message)
			Words = message:split(" ")
			if _G.AntiRecord == true then
				for i, v in pairs(Words) do
					if v:lower():match("recording") or v:lower():match(" rec") or v:lower():match("record") or v:lower():match("discor") or v:lower():match(" disco") or v:lower():match(" disc") or v:lower():match("ticket") or v:lower():match("tickets") or v:lower():match(" ds") or v:lower():match(" dc") or v:lower():match("dizzy") or v:lower():match("dizzycord") or v:lower():match(" clip") or v:lower():match("proof") or v:lower():match("evidence") then
						Toggles["Anti Kick"]:SetValue(false)
						game.Players.LocalPlayer:Kick("Possible player recording detected.".." [ "..p.Name.." ] [ "..message.." ]")
					end
				end
			end
		end)
	end
end
for i,p in pairs(game.Players:GetChildren()) do
findRec(p)
end
game.Players.PlayerAdded:Connect(function(p)
findRec(p)
end)

_G.AntiToggles["Anti REDACTED"] = Anti2Group:AddToggle("Anti REDACTED", {
    Text = "Anti [REDACTED]",
    Default = false,
    Callback = function(Value)
if game.Players.LocalPlayer:FindFirstChild("PlayerScripts"):FindFirstChild("LegacyClient") and game.Players.LocalPlayer.PlayerScripts.LegacyClient:FindFirstChild("Well") then
	game.Players.LocalPlayer.PlayerScripts.LegacyClient.Well.Disabled = Value
end
    end
})

_G.AntiToggles["Anti Brazil"] = Anti2Group:AddToggle("Anti Brazil", {
    Text = "Anti Brazil",
    Default = false,
    Callback = function(Value)
_G.AntiBrazil = Value
while _G.AntiBrazil do
for i,v in pairs(game.workspace.Lobby.brazil:GetChildren()) do
	if v:IsA("BasePart") and v.CanTouch == true then
		v.CanTouch = false
	end
end
task.wait()
end
if _G.AntiBrazil == false then
	for i,v in pairs(game.workspace.Lobby.brazil:GetChildren()) do
		if v:IsA("BasePart") and v.CanTouch == false then
			v.CanTouch = true
		end
	end
end
    end
})

_G.AntiToggles["Anti Za Hando"] = Anti2Group:AddToggle("Anti Za Hando", {
    Text = "Anti Za Hando",
    Default = false,
    Callback = function(Value)
_G.AntiZaHando = Value
while _G.AntiZaHando do
for i,v in pairs(game.Workspace:GetChildren()) do
    if v.Name == "Part" and not (v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound")) then
        v:Destroy()
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Bob"] = Anti2Group:AddToggle("Anti Bob", {
    Text = "Anti Bob",
    Default = false,
    Callback = function(Value)
_G.AntiBob = Value
while _G.AntiBob do
for i, v in pairs(game.Workspace:GetChildren()) do
	if string.find(v.Name:lower(), "bob_") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Target") and v.Target.Value == game.Players.LocalPlayer.Name then
		if IsNetworkOwner(v.HumanoidRootPart) then
			if firetouchinterest then
	            firetouchinterest(v.HumanoidRootPart, workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"], 0)
	            firetouchinterest(v.HumanoidRootPart, workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"], 1)
	        end
	        v.HumanoidRootPart:PivotTo(workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CFrame)
		end
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Iceskate"] = Anti2Group:AddToggle("Anti Iceskate", {
    Text = "Anti Ice Skate",
    Default = false,
    Callback = function(Value)
_G.AntiIceskate = Value
while _G.AntiIceskate do 
if workspace:FindFirstChild("IceBin") then
    for i, v in pairs(workspace.IceBin:GetChildren()) do
        if v:IsA("BasePart") then
	        v:Destroy()
        end
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Mouse Trap"] = Anti2Group:AddToggle("Anti Iceskate", {
    Text = "Anti Mouse Trap",
    Default = false,
    Callback = function(Value)
_G.AntiMouseTrap = Value
while _G.AntiMouseTrap do 
for i, v in pairs(workspace:GetChildren()) do
	if v.Name:lower() == "mouse trap" and v:FindFirstChild("Hitbox") then
		v:FindFirstChild("Hitbox").CanTouch = false
		v:FindFirstChild("Hitbox").CanQuery = false
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Fort"] = Anti2Group:AddToggle("Anti Fort", {
    Text = "Anti Fort",
    Default = false,
    Callback = function(Value)
_G.AntiFort = Value
while _G.AntiFort do
for i,v in pairs(game.Workspace:GetChildren()) do
    if v.Name == "Part" and v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound") then
        v.CanCollide = false
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Pusher"] = Anti2Group:AddToggle("Anti Pusher", {
    Text = "Anti Pusher",
    Default = false,
    Callback = function(Value)
_G.AntiPusher = Value
while _G.AntiPusher do
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == "wall" then
                        v.CanCollide = false
                    end
                end
task.wait()
end
    end
})

_G.AntiToggles["Anti Defend"] = Anti2Group:AddToggle("Anti Defend", {
    Text = "Anti Defend",
    Default = false,
    Callback = function(Value)
_G.NoclipBarrier = Value
if _G.NoclipBarrier == false then
	for i,v in pairs(game.Workspace:GetChildren()) do
		if string.find(v.Name, "ÅBarrier") and v.CanCollide == false then
			v.CanCollide = true
		end
	end
end
while _G.NoclipBarrier do
for i,v in pairs(game.Workspace:GetChildren()) do
	if string.find(v.Name, "ÅBarrier") and v.CanCollide == true then
		v.CanCollide = false
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Bubble"] = Anti2Group:AddToggle("Anti Bubble", {
    Text = "Anti Bubble",
    Default = false,
    Callback = function(Value)
_G.AntiBubble = Value
while _G.AntiBubble do
for i,v in pairs(workspace:GetChildren()) do
	if v.Name == "BubbleObject" and v:FindFirstChildOfClass("Weld") then
	    v:FindFirstChildOfClass("Weld"):Destroy()
	end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Pylon"] = Anti2Group:AddToggle("Anti Pylon", {
    Text = "Anti Pylon",
    Default = false,
    Callback = function(Value)
_G.AntiPylon = Value
while _G.AntiPylon do
for i,v in pairs(workspace:GetChildren()) do
    if v.Name == "Pylon" and v:FindFirstChild("OwningPlayer") and v.OwningPlayer.Value ~= game.Players.LocalPlayer.Name then
	    if v:FindFirstChild("Hitbox") then
	        v:FindFirstChild("Hitbox"):Destroy()
		end
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Pile"] = Anti2Group:AddToggle("Anti Pile", {
    Text = "Anti Pile",
    Default = false,
    Callback = function(Value)
_G.AntiPile = Value
while _G.AntiPile do
for i,v in pairs(workspace:GetChildren()) do
    if v.Name:find("Pile") and v.CanTouch == true then
	    v.CanTouch = false
    end
end
task.wait()
end
    end
})

_G.AntiToggles["Anti Stun"] = Anti2Group:AddToggle("Anti Stun", {
    Text = "Anti Stun",
    Default = false,
    Callback = function(Value)
_G.AntiStun = Value
while _G.AntiStun do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Workspace:FindFirstChild("Shockwave") and game.Players.LocalPlayer.Character.Ragdolled.Value == false then
game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
end
task.wait()
end
    end
})

_G.AntiToggles["Anti COD"] = Anti2Group:AddToggle("Anti COD", {
    Text = "Anti Cube Of Death",
    Default = false,
    Callback = function(Value)
_G.AntiCod = Value
while _G.AntiCod do
if game.Workspace:FindFirstChild("the cube of death(i heard it kills)", 1) and game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("Part") then
game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].CanTouch = false
game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CanTouch = false
end
task.wait()
end
if game.Workspace:FindFirstChild("the cube of death(i heard it kills)", 1) and game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("Part") then
game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].CanTouch = true
game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CanTouch = true
end
    end
})

_G.AntiToggles["Anti Death Barriers"] = Anti2Group:AddToggle("Anti Death Barriers", {
    Text = "Anti Death Barriers",
    Default = false,
    Callback = function(Value)
_G.AntiDead = Value
while _G.AntiDead do
if game.Workspace:FindFirstChild("DEATHBARRIER") then
workspace.DEATHBARRIER.CanTouch = not Value
for i,v in pairs(game.Workspace.DEATHBARRIER:GetChildren()) do
    if v.ClassName == "Part" and v.Name == "BLOCK" then
        v.CanTouch = not Value
    end
end
end
workspace.DEATHBARRIER2.CanTouch = not Value 
workspace.dedBarrier.CanTouch = not Value
workspace.ArenaBarrier.CanTouch = not Value
workspace.AntiDefaultArena.CanTouch = not Value
task.wait()
end
if game.Workspace:FindFirstChild("DEATHBARRIER") then
workspace.DEATHBARRIER.CanTouch = true
for i,v in pairs(game.Workspace.DEATHBARRIER:GetChildren()) do
    if v.ClassName == "Part" and v.Name == "BLOCK" then
        v.CanTouch = true
    end
end
end
workspace.DEATHBARRIER2.CanTouch = true
workspace.dedBarrier.CanTouch = true
workspace.ArenaBarrier.CanTouch = true
workspace.AntiDefaultArena.CanTouch = true
    end
})

Anti2Group:AddDropdown("Anti RagdollV", {
    Text = "Anti Ragdoll",
    Values = {"V0.5", "V1", "V2", "V3"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AntiRagdolledV = Value
    end
})

_G.AntiToggles["Anti Ragdoll"] = Anti2Group:AddToggle("Anti Ragdoll", {
    Text = "Anti Ragdoll",
    Default = false,
    Callback = function(Value)
_G.AntiRagdoll = Value
if Value == false then
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiRagBV") then
		game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiRagBV"):Destroy()
	end
	if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
		game.Players.LocalPlayer.Character.Torso.Anchored = false
	end
end
    end
})
table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
if _G.AntiRagdoll then
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		if game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled") and game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == true then
			for i, v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
				if v:IsA("BodyVelocity") or v:IsA("VectorForce") or v:IsA("LinearVelocity") or v:IsA("BodyGyro") or v:IsA("BodyAngularVelocity") then
					if not (v.Name == "AntiRagBV" or v.Name == "GyroHandler" or v.Name == "VelocityHandler" or v.Name == "FreezeBV" or v.Name == "HelpMasteryFreezeBv") then
						v:Destroy()
					end
				end
			end
			if _G.AntiRagdolledV == "V1" then
				if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
					game.Players.LocalPlayer.Character.Torso.Anchored = true
				end
			end
			if _G.AntiRagdolledV == "V2" then
				if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiRagBV") == nil then
					CreateFreezeBV({Name = "AntiRagBV"})
				end
			end
			if _G.AntiRagdolledV == "V3" then
				local MoveDarTo = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.MoveDirection
		        if MoveDarTo and MoveDarTo.Magnitude > 0 then
		            game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):Move(MoveDarTo, false)
		        end
				if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
					game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running)
				end
				for i, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		            if v:IsA("Motor6D") then
		                v.Enabled = true
		            elseif v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
		                v.Enabled = false
		            end
		        end
			end
		elseif game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == false then
			CreateFreezeBV({Remove = true, Name = "AntiRagBV"})
			if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
				game.Players.LocalPlayer.Character.Torso.Anchored = false
			end
		end
	end
end
end))

local Badge3Group = Tabs.Tab3:AddLeftGroupbox("Teleport / Show")

Badge3Group:AddDropdown("Teleport Safe", {
    Text = "Teleport Safe",
    Values = {"SafeSpotBox 1.0", "SafeSpotBox 2.0", "Bed"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "SafeSpotBox 1.0" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
elseif Value == "SafeSpotBox 2.0" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
elseif Value == "Bed" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Bed"].Bed3.CFrame * CFrame.new(0,0,-1)
end
    end
})

Badge3Group:AddDropdown("Retro Obby", {
    Text = "Retro Obby",
    Values = {"Get Badge", "Show All", "Off Show All", "Teleport Spawn 1", "Teleport Spawn 2", "Teleport Spawn 3", "Click Button"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "Get Badge" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.FinishDoor_Retro.Part.CFrame
elseif Value == "Show All" then
if game.ReplicatedStorage.Assets:FindFirstChild("Retro") then
game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
end
elseif Value == "Off Show All" then
if game.Workspace:FindFirstChild("Retro") then
game.Workspace.Retro.Parent = game.ReplicatedStorage:FindFirstChild("Assets")
end
elseif Value == "Teleport Spawn 1" then
if game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map") and game.Workspace.Retro.Map:FindFirstChild("RetroObbyMap") and game.Workspace.Retro.Map.RetroObbyMap:FindFirstChild("Spawn") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Retro.Map.RetroObbyMap.Spawn.CFrame
end
elseif Value == "Teleport Spawn 2" then
if game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map") and game.Workspace.Retro.Map:FindFirstChild("RetroObbyMap") and game.Workspace.Retro.Map.RetroObbyMap:FindFirstChild("Spawn_stage2") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Retro.Map.RetroObbyMap.Spawn_stage2.CFrame
end
elseif Value == "Teleport Spawn 3" then
if game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map") and game.Workspace.Retro.Map:FindFirstChild("RetroObbyMap") and game.Workspace.Retro.Map.RetroObbyMap:FindFirstChild("Spawn_stage3") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Retro.Map.RetroObbyMap.Spawn_stage3.CFrame
end
elseif Value == "Click Button" then
repeat task.wait()
if game.ReplicatedStorage:FindFirstChild("Assets") and game.ReplicatedStorage.Assets:FindFirstChild("Retro") then
game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
end
until game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map")
wait(1.5)
if game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map") then
for i, v in pairs(workspace.Retro.Map.RetroObbyMap:GetChildren()) do
if v.Name == "Model" and v:FindFirstChild("StaffApp") and v.StaffApp:FindFirstChild("Button") and v.StaffApp.Button:FindFirstChild("ClickDetector") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.StaffApp.Button.CFrame
wait(0.3)
fireclickdetector(v.StaffApp.Button.ClickDetector)
end
end
end
end
    end
})

Badge3Group:AddDropdown("Repressed Memory", {
    Text = "Repressed Memory",
    Values = {"Show All","Off Show All","Teleport Enter","Teleport Portal","Teleport Bob Plushie","Click Bob Plushie"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "Show All" then
if game.ReplicatedStorage:FindFirstChild("RepressedMemoriesMap") then
game.ReplicatedStorage.RepressedMemoriesMap.Parent = game.Workspace
end
elseif Value == "Off Show All" then
if game.Workspace:FindFirstChild("RepressedMemoriesMap") then
game.Workspace.RepressedMemoriesMap.Parent = game.ReplicatedStorage
end
elseif Value == "Teleport Enter" then
if game.Workspace:FindFirstChild("RepressedMemoriesMap") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories.Limbo.CFrame * CFrame.new(0,-5,0)
end
elseif Value == "Teleport Portal" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories.SimonSaysGate.Portal.CFrame
elseif Value == "Teleport Bob Plushie" then
if game.Workspace:FindFirstChild("RepressedMemoriesMap") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories._ugcQuestObjectBobPlushie.Handle.CFrame
elseif game.ReplicatedStorage:FindFirstChild("RepressedMemoriesMap") then
game.ReplicatedStorage.RepressedMemoriesMap.Parent = game.Workspace
wait(1.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories._ugcQuestObjectBobPlushie.Handle.CFrame
end
elseif Value == "Click Bob Plushie" then
repeat task.wait()
if game.ReplicatedStorage:FindFirstChild("RepressedMemoriesMap") then
game.ReplicatedStorage.RepressedMemoriesMap.Parent = game.Workspace
end
until game.Workspace:FindFirstChild("RepressedMemoriesMap")
wait(1)
if game.Workspace:FindFirstChild("RepressedMemoriesMap") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.RepressedMemories._ugcQuestObjectBobPlushie.Handle.CFrame
wait(0.5)
fireclickdetector(workspace.RepressedMemories._ugcQuestObjectBobPlushie.ClickDetector)
end
wait(2)
if game.Workspace:FindFirstChild("RepressedMemoriesMap") then
game.Workspace.RepressedMemoriesMap.Parent = game.ReplicatedStorage
end
end
    end
})

Badge3Group:AddDropdown("Map Kraken", {
    Text = "Map Kraken",
    Values = {"Show All","Off Show All", "Teleport Enter"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "Show All" then
if game.ReplicatedStorage:FindFirstChild("AbyssAssets") and game.ReplicatedStorage.AbyssAssets:FindFirstChild("Abyss") then
game.ReplicatedStorage.AbyssAssets.Abyss.Parent = game.Workspace
end
elseif Value == "Off Show All" then
if game.Workspace:FindFirstChild("Abyss") then
game.Workspace.Abyss.Parent = game.ReplicatedStorage:FindFirstChild("AbyssAssets")
end
elseif Value == "Teleport Enter" then
if game.Workspace:FindFirstChild("Abyss") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Abyss.Spawn.CFrame * CFrame.new(0,10,0)
end
end
    end
})

local Badge1Group = Tabs.Tab3:AddLeftGroupbox("Badge Auto")

Badge1Group:AddDropdown("Map Kraken", {
    Text = "Badge Auto Get",
    Values = {"Boxing", "Doorkeeper", "Bind", "Lotus", "Conker", "FrostBite", "Plate", "Plunger", "Admin", "Chain", "Riftshot", "Fan", "Reflect", "Fight Guide", "Counter + Elude", "Summer"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AutoGetBadgeGlove = Value
    end
})

Badge1Group:AddButton({
    Text = "Auto Get Badge",
    Func = function()
local teleportFunc = queueonteleport or queue_on_teleport
if teleportFunc then
local CodeGetBadge = [[
if not game:IsLoaded() then
    game.Loaded:Wait()
end
repeat task.wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
_G.AutoGetBadgeGlove = "__Glove__"
task.wait(2)
pcall(function()
    Fixed = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/Fix.lua"))()
    fireclickdetector = fireclickdetector or Fixed.fireclickdetector
    fireproximityprompt = fireproximityprompt or Fixed.fireproximityprompt
end)
local Players = game:GetService("Players")
local Virtual = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local Backpack = LocalPlayer.Backpack
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Root = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Root = Character:WaitForChild("HumanoidRootPart")
end)

local function TP(cf)
    if Root then
        Root.CFrame = cf
    end
end

local function fire(object, data)
    local datafire = {
        fireclick = data.fireclick or false,
        firetouch = data.firetouch or false,
        fireprompt = data.fireprompt or false,
    }
        
    if datafire.fireclick and fireclickdetector then
        local objectFindClick = object:IsA("ClickDetector") and object or object:FindFirstChildWhichOfClass("ClickDetector", true)
        if objectFindClick then
            fireclickdetector(objectFindClick, 0)
            fireclickdetector(objectFindClick, 1)
        end
    end
    if datafire.firetouch and firetouchinterest then
        local objectFindTouch = ((object:IsA("TouchTransmitter") or object:IsA("TouchInterest")) and object.Parent) or (object:IsA("BasePart") and object)
        if objectFindTouch and Root then
            firetouchinterest(Root, objectFindTouch, 0)
            firetouchinterest(Root, objectFindTouch, 1)
        end
    end
    if datafire.fireprompt and fireproximityprompt then
        local objectFindProximity = object:IsA("ProximityPrompt") and object or object:FindFirstChildWhichOfClass("ProximityPrompt", true)
        if objectFindProximity then
            fireproximityprompt(objectFindProximity, 0)
            fireproximityprompt(objectFindProximity, 1)
        end
    end
end

if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    if _G.AutoGetBadgeGlove == "Boxing" then
        if game.Workspace:FindFirstChild("BoxingGloves") == nil then
            TP(game.Workspace.Buildings.house:FindFirstChild("TP").CFrame * CFrame.new(0,10,0))
        end
        repeat task.wait() until game.Workspace:FindFirstChild("BoxingGloves")
        task.wait(0.6)
        if game.Workspace:FindFirstChild("BoxingGloves") then
            for i,v in pairs(game.Workspace:GetChildren()) do
                if v.Name == "BoxingGloves" and v:FindFirstChild("ClickDetector") then
                    fire(v.ClickDetector, {fireclick = true})
                    TP(v.CFrame)
                end
            end
        end
    elseif _G.AutoGetBadgeGlove == "Doorkeeper" then
        local OpenedDoors = {}
        while true and task.wait() do
            if workspace:FindFirstChild("Hallways") then
                for i, v in pairs(workspace.Hallways:GetChildren()) do
                    local HallwayDoor = v:FindFirstChild("Doors")
                    if HallwayDoor then
                        for j, b in pairs(HallwayDoor:GetChildren()) do
                            if b:IsA("Model") and tonumber(b.Name) then
                                if OpenedDoors[b] then 
                                    continue 
                                end
                                local DoorHitbox = b:FindFirstChild("Hitbox")
                                local Click = DoorHitbox and DoorHitbox:FindFirstChild("ClickDetector")
                                if DoorHitbox then
                                    repeat task.wait()
                                        fire(Click, {fireclick = true})
                                        TP(DoorHitbox.CFrame * CFrame.new(0, 0, -5))
                                    until b:GetAttribute("Open")
                                    OpenedDoors[b] = true
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif _G.AutoGetBadgeGlove == "Bind" then
        if game.Workspace:FindFirstChild("Orb") and game.Workspace.Orb:FindFirstChild("Meshes/rock chain glove_defaultglove_cell.001") then
            fire(game.Workspace.Orb.ClickDetector, {fireclick = true})
            TP(workspace.Orb["Meshes/rock chain glove_defaultglove_cell.001"].CFrame)
        end
    elseif _G.AutoGetBadgeGlove == "Lotus" then
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Lotus2Complete"):FireServer()
        if PlayerGui:FindFirstChild("Akari") then
            PlayerGui.Akari:Destroy()
        end
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Minigames"):WaitForChild("Complete"):FireServer()
        task.wait(0.5)
        for i, v in pairs(workspace:GetChildren()) do
            if v:IsA("Folder") and v.Name:find("Lotus") and v:FindFirstChild("Lotus") and v.Lotus:FindFirstChild("Primary") and v.Lotus.Primary:FindFirstChild("ClickDetector") then
                for j, b in pairs(v.Lotus:GetChildren()) do
                    if b:IsA("BasePart") and not b.Name:find("Primary") and b.Transparency < 1 then
                        TP(v.Lotus.Primary.CFrame * CFrame.new(0, 5, 0))
                        fire(v.Lotus.Primary.ClickDetector, {fireclick = true})
                        repeat task.wait() until b.Transparency >= 1
                        break
                    end
                end
            end
        end
    elseif _G.AutoGetBadgeGlove == "Conker" then
        ReplicatedStorage.Remotes.Dialogue.FinishedNPCDialogue:FireServer()
        repeat task.wait() until workspace:FindFirstChild("Map"):FindFirstChild("Props"):FindFirstChild("BasketCollection") and workspace.Map.Props.BasketCollection:FindFirstChild("Basket")
        fire(workspace.Map.Props.BasketCollection.Basket.ClickDetector, {fireclick = true})
        repeat task.wait() until Character:FindFirstChild("ConkerHoldVisual")
        task.wait(2.8)
        TP(workspace.Map.CoreAssets.Bowl["Sphere.002"].CFrame)
        
        task.spawn(function()
            workspace.NPCs.DescendantAdded:Connect(function(s)
                if s.Name == "squirrel" then
                    pcall(function()
                        while task.wait() and s do
                            if s:FindFirstChild("HumanoidRootPart") then
                                ReplicatedStorage.Remotes.tool.use:FireServer("slap")
                                ReplicatedStorage.Remotes.tool.hit:FireServer("slap", {Instance = s.HumanoidRootPart})
                            end
                        end
                    end)
                end
            end)
            workspace.DescendantAdded:Connect(function(n)
                if n.Name == "Conker" then
                    if n:FindFirstChildOfClass("TouchTransmitter") then
                        TP(n.CFrame)
                        fire(n, {firetouch = true})
                        task.delay(0.1, function()
                            TP(workspace.Map.CoreAssets.Bowl["Sphere.002"].CFrame)
                            task.wait(0.5)
                            workspace.Map.CoreAssets.Bowl.ProximityPrompt.HoldDuration = 0
                            fire(workspace.Map.CoreAssets.Bowl.ProximityPrompt, {fireprompt = true})
                            pcall(function()
                                workspace.Map.CoreAssets.Bowl.ProximityPrompt:InputHoldBegin()
                                workspace.Map.CoreAssets.Bowl.ProximityPrompt:InputHoldEnd()
                            end)
                        end)
                    end
                end
            end)
        end)
    elseif _G.AutoGetBadgeGlove == "FrostBite" then
        TP(CFrame.new(-554, 177, 56))
        task.wait(0.7)
        for i,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if v.ClassName == "ProximityPrompt" then
                v.HoldDuration = 0
                fire(v, {fireprompt = true})
            end
        end
    elseif _G.AutoGetBadgeGlove == "Plate" then
        repeat task.wait() until workspace:FindFirstChild("Obstacles")
        if workspace:FindFirstChild("Obstacles") then workspace.Obstacles:Destroy() end
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Bypass plate obstacles",Icon = "rbxassetid://7733658504",Duration = 5})
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Wait in until glove appear",Icon = "rbxassetid://7733658504",Duration = 5})
        workspace:GetAttributeChangedSignal("Completed"):Connect(function()
            if workspace:GetAttribute("Completed") == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Done Bro",Icon = "rbxassetid://7733658504",Duration = 5})
                while task.wait() do
                    if workspace:FindFirstChild("Glove Model"):FindFirstChild("Hand") then
                        TP(workspace["Glove Model"].Hand.CFrame)
                    end
                end
            end
        end)
    elseif _G.AutoGetBadgeGlove == "Plunger" then
        local Plunger = workspace:FindFirstChild("plunger glove")
        if Plunger and Plunger:FindFirstChild("plungerglove") then
            Plunger:FindFirstChild("plungerglove").CFrame = Root.CFrame
            fire(Plunger:FindFirstChildOfClass("ClickDetector"), {fireclick = true})
        end
    elseif _G.AutoGetBadgeGlove == "Admin" then
        task.wait(10)
        TP(CFrame.new(502, 76, 59))
        if getconnections then
            for i,v in next, getconnections(LocalPlayer.Idled) do
                v:Disable() 
            end
        end
        if not getconnections then
            LocalPlayer.Idled:Connect(function()
                Virtual:CaptureController()
                Virtual:ClickButton2(Vector2.new())
            end)
        end
    elseif _G.AutoGetBadgeGlove == "Chain" then
        repeat task.wait() until game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("CodeBrick")
        local Code = {}
        if game.Workspace.Map.CodeBrick.SurfaceGui:FindFirstChild("IMGTemplate") then
		Code = {}
		for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
			if v.Name == "IMGTemplate" then
			    if v.Image == "http://www.roblox.com/asset/?id=9648769161" then
					    table.insert(Code, "4")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648765536" then
					    table.insert(Code, "2")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648762863" then
					    table.insert(Code, "3")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648759883" then
					    table.insert(Code, "9")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648755440" then
					    table.insert(Code, "8")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648752438" then
					    table.insert(Code, "2")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648749145" then
					    table.insert(Code, "8")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648745618" then
					    table.insert(Code, "3")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648742013" then
					    table.insert(Code, "7")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648738553" then
					    table.insert(Code, "8")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648734698" then
					    table.insert(Code, "2")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648730082" then
					    table.insert(Code, "6")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648723237" then
					    table.insert(Code, "3")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648718450" then
					    table.insert(Code, "6")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648715920" then
					    table.insert(Code, "6")
					elseif v.Image == "http://www.roblox.com/asset/?id=9648712563" then
					    table.insert(Code, "2")
					end
			    end
			end
		end
        if #Code ~= 0 then
            for i, v in pairs(game.Workspace.Map.OriginOffice:GetChildren()) do
                if v.Name:lower():find("codedoor") and v:FindFirstChild("Door") and v.Door:FindFirstChild("Keypad") and v.Door.Keypad:FindFirstChild("Buttons") then
                    fire(v.Door.Keypad.Buttons.Reset.ClickDetector, {fireclick = true})
                    task.wait(0.25)
                    for i = 1, #Code do
                        local CodeNah = Code[i]
                        fire(v.Door.Keypad.Buttons[CodeNah].ClickDetector, {fireclick = true})
                        task.wait(0.25)
                    end
                    task.wait(0.25)
                    fire(v.Door.Keypad.Buttons.Enter.ClickDetector, {fireclick = true})
                end
            end
        end
        game:GetService("TeleportService"):Teleport(6403373529)
    elseif _G.AutoGetBadgeGlove == "Counter + Elude" then
        Time = 121
        task.wait(0.4)
        game.Workspace.CounterLever.ClickDetector.MouseClick:Connect(function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,100,0)
            task.wait(0.2)
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
            for i = 1, Time do
                Time = Time - 1
                game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "You wait time [ "..i.." ] receive.",Icon = "rbxassetid://7733658504",Duration = 1})
                task.wait(1)
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            for i, v in pairs(workspace.Maze:GetChildren()) do
                if v.Name == "Part" and v:FindFirstChild("A0") and v:FindFirstChild("ClickDetector") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,-20,0)
                    v.ClickDetector.MouseClick:Connect(function()
                        game.Workspace.Ruins.Elude.Glove.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end)
                end
            end
        end)
        task.wait(0.7)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.CounterLever.Main.CFrame
        pcall(function()
            fireclickdetector(game.Workspace.CounterLever.ClickDetector)
            repeat task.wait() until Time == 0
            for i, v in pairs(workspace.Maze:GetChildren()) do
                if v.Name == "Part" and v:FindFirstChild("A0") and v:FindFirstChild("ClickDetector") then
                    fireclickdetector(v.ClickDetector)
                end
            end
        end)
    elseif _G.AutoGetBadgeGlove == "Riftshot" or _G.AutoGetBadgeGlove == "Fan" then
        task.spawn(function()
            while true do
                Dialogue = game.Workspace:FindFirstChild("DialoguePrompts")
                NPC = game.Workspace:FindFirstChild("NPCS")
                Buildings = game.Workspace:FindFirstChild("Buildings")
                task.wait()
            end
        end)
        if _G.AutoGetBadgeGlove == "Riftshot" then
            task.wait(0.4)
            if Dialogue and Dialogue:FindFirstChild("Sharpshooter Sam") and Dialogue["Sharpshooter Sam"]:FindFirstChildOfClass("ProximityPrompt") then
                TP(Dialogue["Sharpshooter Sam"].CFrame)
                repeat task.wait() until (Root.Position - Dialogue["Sharpshooter Sam"].Position).Magnitude <= 10
            end
            game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "Bypass Success, bomb will bring you, your job is to shoot the bomb (Goodluck!)",Icon = "rbxassetid://7733658504",Duration = 5})
            task.wait(0.3)
            for i,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if v.Name:find("Sharpshooter Sam's") then
                    SharpshooterTarget = v
                end
            end
            task.wait(0.3)
            while true do
                if Character:FindFirstChild("HumanoidRootPart") then
                    if SharpshooterTarget then
                        for i, v in pairs(SharpshooterTarget:GetChildren()) do
                            if v.Name:find("bomb") and v:FindFirstChild("Handle") then
                                v.Handle.CFrame = Root.CFrame * CFrame.new(0, 0, -7)
                            end
                        end
                    end
                end
                task.wait()
            end
        elseif _G.AutoGetBadgeGlove == "Fan" then
            for i = 1, 2 do
                if Dialogue and Dialogue:FindFirstChild("PabloPinkyPoo") and Dialogue.PabloPinkyPoo:FindFirstChildOfClass("ProximityPrompt") then
                    TP(Dialogue.PabloPinkyPoo.CFrame * CFrame.new(0, 0, -5))
                    repeat task.wait() until (Root.Position - Dialogue.PabloPinkyPoo.Position).Magnitude <= 10
                    task.wait(0.2)
                    repeat task.wait()
                        fire(Dialogue.PabloPinkyPoo:FindFirstChildOfClass("ProximityPrompt"), {fireprompt = true})
                    until PlayerGui:FindFirstChild("Dialogues"):FindFirstChild("DialogueFrame") and PlayerGui.Dialogues.DialogueFrame.Visible == true
                    task.wait(0.5)
                end
                task.wait(0.1)
                repeat task.wait() until PlayerGui:FindFirstChild("Dialogues"):FindFirstChild("DialogueFrame") and PlayerGui.Dialogues.DialogueFrame.Visible == false
                task.wait(0.6)
            end
            task.wait(0.5)
            if game.Workspace.QuestStuff:FindFirstChild("Key") and game.Workspace.QuestStuff.Key.Transparency == 0 then
                TP(game.Workspace.QuestStuff.Key.CFrame)
                repeat task.wait() until (Root.Position - game.Workspace.QuestStuff.Key.Position).Magnitude <= 10
                task.wait(0.3)
                if game.Workspace.QuestStuff.Key:FindFirstChild("ClickDetector") then
                    fire(game.Workspace.QuestStuff.Key.ClickDetector, {fireclick = true})
                end
                repeat task.wait() until game.Workspace.QuestStuff:FindFirstChild("Key") and game.Workspace.QuestStuff.Key.Transparency ~= 0
                task.wait(0.3)
            end
            task.wait(2.6)
            if Buildings and Buildings:FindFirstChild("oog's cage") and Buildings["oog's cage"]:FindFirstChild("Door") then
                TP(Buildings["oog's cage"].Door.Door.CFrame * CFrame.new(-3,0,0))
                repeat task.wait() until (Root.Position - Buildings["oog's cage"].Door.Door.Position).Magnitude <= 10
                task.wait(0.3)
                fire(Buildings["oog's cage"].Door.ClickDetector, {fireclick = true})
            end
            task.wait(0.3)
            if Dialogue and Dialogue:FindFirstChild("PabloPinkyPoo") and Dialogue.PabloPinkyPoo:FindFirstChildOfClass("ProximityPrompt") then
                TP(Dialogue.PabloPinkyPoo.CFrame * CFrame.new(0, 0, -5))
                repeat task.wait() until (Root.Position - Dialogue.PabloPinkyPoo.Position).Magnitude <= 10
                task.wait(0.2)
                repeat task.wait()
                    fire(Dialogue.PabloPinkyPoo:FindFirstChildOfClass("ProximityPrompt"), {fireprompt = true})
                until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Dialogues"):FindFirstChild("DialogueFrame") and game:GetService("Players").LocalPlayer.PlayerGui.Dialogues.DialogueFrame.Visible == true
            end
        end
    elseif _G.AutoGetBadgeGlove == "Reflect" then
        local Stage1 = workspace:FindFirstChild("Stage1")
        if workspace:FindFirstChild("Stage1") then
            repeat task.wait() 
                if Stage1:FindFirstChild("Lobby") and Stage1.Lobby.Portals:FindFirstChild("normal") then
                    fire(Stage1.Lobby.Portals.normal.Teleport1, {firetouch = true})
                end
                if Stage1:FindFirstChild("glove") then
                    TP(Stage1.glove:FindFirstChild("Touch").CFrame)
                end
            until Character:FindFirstChild("Evolg") or Backpack:FindFirstChild("Evolg")
            local GloveEvolg = Character:FindFirstChild("Evolg") or Backpack:FindFirstChild("Evolg")
            if GloveEvolg and GloveEvolg:FindFirstChild("Glove") and GloveEvolg.Glove:FindFirstChild("HitParticles") then
                GloveEvolg.Glove:FindFirstChild("HitParticles"):Destroy()
            end
            repeat task.wait()
                if Backpack:FindFirstChild("Evolg") then
                    Backpack:FindFirstChild("Evolg").Parent = Character
                end
                if Character:FindFirstChild("Evolg") and Character.Evolg:FindFirstChild("Network") then
                    for i, v in pairs(workspace:GetChildren()) do
                        if v.Name:find("shadow") and v:FindFirstChild("HumanoidRootPart") then
                            Character:WaitForChild("Evolg"):WaitForChild("Network"):FireServer("Hit",v.HumanoidRootPart)
                        end
                    end
                end
            until Stage1:FindFirstChild("Mirror") and Stage1.Mirror:FindFirstChild("Touch") and Stage1.Mirror.Touch:FindFirstChild("TouchInterest")
            task.wait(0.5)
            TP(Stage1.Mirror:FindFirstChild("Touch").CFrame)
        end
        repeat task.wait() until workspace:FindFirstChild("Stage2")
        task.wait(4)
        if workspace:FindFirstChild("Stage2") then
            local Stage2 = workspace:FindFirstChild("Stage2")
            if Stage2:FindFirstChild("Lobby") and Stage2.Lobby.Portals:FindFirstChild("normal") then
                TP(Stage2.Lobby.Portals.normal.Teleport1.CFrame)
            end
            task.wait(0.5)
            repeat task.wait()
                if Stage2:FindFirstChild("spinner") and Stage2.spinner:FindFirstChild("Part") and Stage2.spinner.Part.Transparency < 0.5 then
                    TP(Stage2.spinner:FindFirstChild("Part").CFrame * CFrame.new(0, 60, 0))
                    task.wait(0.3)
                    Root.Anchored = true
                end
            until Stage2:FindFirstChild("Mirror") and Stage2.Mirror:FindFirstChild("Touch") and Stage2.Mirror.Touch:FindFirstChild("TouchInterest")
            task.wait(0.4)
            Root.Anchored = false
            TP(Stage2.Mirror:FindFirstChild("Touch").CFrame)
            task.wait(4)
        end
        repeat task.wait() until workspace:FindFirstChild("Stage3")
        task.wait(0.3)
        if workspace:FindFirstChild("Stage3") then
            task.wait(5)
            local Stage3 = workspace:FindFirstChild("Stage3")
            if Stage3:FindFirstChild("Lobby") and Stage3.Lobby.Portals:FindFirstChild("default") then
                TP(Stage3.Lobby.Portals.default.Teleport2.CFrame)
            end
        end
        repeat task.wait() until workspace:FindFirstChild("BossArena")
        if workspace:FindFirstChild("BossAttackDebris") then
            workspace.BossAttackDebris:Destroy()
        end
        local Boss = workspace:FindFirstChild("BossArena")
        if Boss:FindFirstChild("Arena") and Boss.Arena:FindFirstChild("startTrigger") then
            TP(Boss.Arena:FindFirstChild("startTrigger").CFrame)
        end
        repeat task.wait()
            if Boss:FindFirstChild("Arena"):FindFirstChild("mirrors") then
                for i, v in pairs(Boss.Arena.mirrors:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Meshes/Mirror1_Plane.008") and v["Meshes/Mirror1_Plane.008"].Transparency < 0.5 then
                        TP(v:FindFirstChild("Meshes/Mirror1_Plane.008").CFrame)
                    end
                end
            end
        until workspace:FindFirstChild("Rig") and workspace.Rig:FindFirstChild("Humanoid").Health <= 0
    elseif _G.AutoGetBadgeGlove == "Fight Guide" then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "You wait time [ 10 second ].",Icon = "rbxassetid://7733658504",Duration = 1})
        task.wait(10)
        TP(CFrame.new(3260, -70, 823))
        task.wait(2)
        for i,v in pairs(game.Workspace:GetDescendants()) do
            if v.Name == "ShackLever" and v:FindFirstChild("ClickDetector") then
                fire(v.ClickDetector, {fireclick = true})
            end
        end
        repeat task.wait() until workspace.Map.Components:FindFirstChild("GuideNPC") ~= nil
        task.wait(0.56)
        TP(CFrame.new(595, 120, -330))
        task.wait(0.3)
        Root.Anchored = true
        while true do
            for i,v in pairs(game.Workspace:GetChildren()) do
                if v.Name == "TrackGloveMissile" or v.Name == "golem" or v.Name == "DungeonGolem" or v.Name == "ReplicaNPC" or v.Name == "GuideNPC" then
                    if game.Players.LocalPlayer.Backpack:FindFirstChild("Lantern") then
                        game.Players.LocalPlayer.Backpack:FindFirstChild("Lantern").Parent = game.Players.LocalPlayer.Character
                    elseif game.Players.LocalPlayer.Character:FindFirstChild("Lantern") then
                        if game.Players.LocalPlayer.Character:FindFirstChild("Lantern") then
                            game.Players.LocalPlayer.Character:FindFirstChild("Lantern"):Activate()
                            if game.Players.LocalPlayer.Character:FindFirstChild("Lantern") and game.Players.LocalPlayer.Character.Lantern:FindFirstChild("Network") then
                                game:GetService("Players").LocalPlayer.Character.Lantern.Network:FireServer("Hit", v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Hitbox") or v:FindFirstChild("Cube.001") or v)
                            end
                        end
                    end
                end
            end
            task.wait()
        end
    elseif _G.AutoGetBadgeGlove == "Summer" then
	    task.wait(3)
	    if workspace:FindFirstChild("ObjectSpawner_Objects") then
			workspace.ObjectSpawner_Objects:Destroy()
		end
		local Dialogue
		for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
			if v:IsA("ScreenGui") and v:FindFirstChild("Dialogue") then
				Dialogue = v.Dialogue
			end
		end
		if Dialogue and Dialogue.Parent and (not Dialogue.Visible or not Dialogue.Parent.Enabled) then
			TP(Workspace.Island["John Surfboard"].Head.CFrame * CFrame.new(0, 5, 0))
			task.wait(0.36)
			fire(workspace.Island["John Surfboard"].Head:FindFirstChildOfClass("ProximityPrompt"), {fireprompt = true})
			wait(0.5)
			repeat task.wait() until Dialogue.Visible or Dialogue.Parent.Enabled
			task.wait(0.35)
			repeat task.wait()
				game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Common"):WaitForChild("Dialogue"):WaitForChild("Remotes"):WaitForChild("ResondToDialogue"):FireServer(0)
			until not Dialogue.Visible or not Dialogue.Parent.Enabled
			workspace.Camera.CameraSubject = game:GetService("Players").LocalPlayer.Character
		end
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/File-Script/Slap_Battles.lua"))()
    end
end]]

CodeGetBadge = CodeGetBadge:gsub("__Glove__", tostring(_G.AutoGetBadgeGlove))
teleportFunc(CodeGetBadge)
elseif not teleportFunc then
	Notification("Bruh, Not only executor you autoexe", _G.TimeNotify)
end
local TPS = game:GetService("TeleportService")
if _G.AutoGetBadgeGlove == "Riftshot" or _G.AutoGetBadgeGlove == "OOG" or _G.AutoGetBadgeGlove == "Boxing" then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Lobby.brazil.portal.CFrame
elseif _G.AutoGetBadgeGlove == "Doorkeeper" then
	TPS:Teleport(125845699717230)
elseif _G.AutoGetBadgeGlove == "Bind" then
	TPS:Teleport(74169485398268)
elseif _G.AutoGetBadgeGlove == "Lotus" then
	TPS:Teleport(93981091811742)
elseif _G.AutoGetBadgeGlove == "Conker" then
	TPS:Teleport(101113181694564)
elseif _G.AutoGetBadgeGlove == "FrostBite" then
	TPS:Teleport(17290438723)
elseif _G.AutoGetBadgeGlove == "Plate" then
	TPS:Teleport(106620300132058)
elseif _G.AutoGetBadgeGlove == "Chain" then
	TPS:Teleport(9431156611)
elseif _G.AutoGetBadgeGlove == "Summer" then
	TPS:Teleport(122902713960550)
elseif _G.AutoGetBadgeGlove == "Counter + Elude" then
	TPS:Teleport(11828384869)
elseif _G.AutoGetBadgeGlove == "Plunger" then
	if workspace:FindFirstChild("BountyHunterRoom") and workspace.BountyHunterRoom:FindFirstChild("PlungerMain") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom:FindFirstChild("PlungerMain").CFrame
		if fireclickdetector then
			fireclickdetector(workspace.BountyHunterRoom.PlungerMain:FindFirstChildOfClass("ClickDetector"))
		end
	end
	repeat task.wait() until workspace:FindFirstChild("plungers") and workspace.plungers:FindFirstChild("ToiletPlunger").Transparency < 1
	wait(0.4)
	if workspace:FindFirstChild("plungers") and workspace.plungers:FindFirstChild("ToiletPlunger") and workspace.plungers.ToiletPlunger:FindFirstChildOfClass("ClickDetector") then
		if fireclickdetector then
			fireclickdetector(workspace.plungers.ToiletPlunger:FindFirstChildOfClass("ClickDetector"))
		end
	end
elseif _G.AutoGetBadgeGlove == "Admin" then
	repeat task.wait()
		if game.ReplicatedStorage:FindFirstChild("Assets") and game.ReplicatedStorage.Assets:FindFirstChild("Retro") then
			game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
		end
	until game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map")
	wait(1.5)
	if game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map") then
		for i, v in pairs(workspace.Retro.Map.RetroObbyMap:GetChildren()) do
			if v.Name == "Model" and v:FindFirstChild("StaffApp") and v.StaffApp:FindFirstChild("Button") and v.StaffApp.Button:FindFirstChild("ClickDetector") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.StaffApp.Button.CFrame
			wait(0.3)
			fireclickdetector(v.StaffApp.Button.ClickDetector)
			end
		end
	end
elseif _G.AutoGetBadgeGlove == "Reflect" then
	if workspace:FindFirstChild("BountyHunterRoom"):FindFirstChild("QuestObjects"):FindFirstChild("ShatteredRealityMirror"):FindFirstChild("Meshes/Mirror1_Plane.007") then
		if workspace.BountyHunterRoom.QuestObjects.ShatteredRealityMirror["Meshes/Mirror1_Plane.007"].Transparency <= 0 then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.QuestObjects.ShatteredRealityMirror["Meshes/Mirror1_Plane.007"].CFrame
			wait(0.4)
			fireproximityprompt(workspace.BountyHunterRoom.QuestObjects.ShatteredRealityMirror["Meshes/Mirror1_Plane.007"].ProximityPrompt)
		else
			Notification("You have complete 4 quest hitman (2 quest easy, 2 quest hard)", _G.TimeNotify)
		end
	end
elseif _G.AutoGetBadgeGlove == "Fight Guide" then
	for i, v in pairs(workspace.BountyHunterRoom.Build:GetChildren()) do
		if v.Name == "Model" and v:FindFirstChild("Meshes/boxshadow_Cube.005") and v["Meshes/boxshadow_Cube.005"]:FindFirstChild("Hitbox") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v["Meshes/boxshadow_Cube.005"].Hitbox.CFrame
		end
	end
end
    end
})

local Badge2Group = Tabs.Tab3:AddRightGroupbox("Badge")

Badge2Group:AddButton({
    Text = "Get Glove Kinetic",
    Func = function()
if CheckGlove() == "Stun" then
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value >= 666 then
		equipglove("Ghost")
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
		repeat task.wait() until CheckGlove():lower() == "ghost"
		game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
		equipglove("Stun")
		task.wait(1)
		for i,v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = 0
			end
		end
	end
	wait(0.6)
	if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		repeat task.wait()
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.Teleport1.CFrame)
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	end
	local NotifyStun = Library:Notify({Title = "Counter Stun", Description = "Stun Players: 0", Persist = true})
	spawn(function()
		repeat task.wait()
			if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("EMPStunBadgeCounter") then
				NotifyStun:ChangeDescription("Stun Players: "..game.Players.LocalPlayer.Character:FindFirstChild("EMPStunBadgeCounter").Value)
			end
		until game.Players.LocalPlayer.Character:FindFirstChild("EMPStunBadgeCounter") and game.Players.LocalPlayer.Character.EMPStunBadgeCounter.Value >= 50
		if NotifyStun then NotifyStun:Destroy() end
	end)
	repeat task.wait()
		game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = -99})
	until game.Players.LocalPlayer.Character:WaitForChild("KineticSlappedBadgeCounter").Value >= 100
	wait(1.5)
	repeat task.wait()
		if game.Players.LocalPlayer.Character.Humanoid.Health <= 0 or game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then break end
		if game.Players.LocalPlayer.Backpack:FindFirstChild("Stun") then
			game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Stun)
		end
		wait(0.5)
		local Target, RootPart = TargetPlayers(true)
		if Target and RootPart then
			if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
				game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RootPart.CFrame * CFrame.new(0,-20,0))
				wait(0.25)
				game.ReplicatedStorage.StunR:FireServer(game.Players.LocalPlayer.Character.Stun)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
				if game.Players.LocalPlayer.Character:FindFirstChild("Stun") then
					game.Players.LocalPlayer.Character.Stun.Parent = game.Players.LocalPlayer.Backpack
				end
				wait(12.3)
			end
		end
	until game.Players.LocalPlayer.Character:FindFirstChild("EMPStunBadgeCounter") and game.Players.LocalPlayer.Character.EMPStunBadgeCounter.Value >= 50
else
	Notification("You don't have Stun equipped", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Auto Win Kraken",
    Func = function()
if game.Workspace:FindFirstChild("Abyss") ~= nil then
	Notification("When the kraken stops attack, click to hit.", _G.TimeNotify)
	repeat task.wait()
		if game.Workspace:FindFirstChild("Abyss") and game.Workspace.Abyss:FindFirstChild("Ship") and game.Workspace.Abyss.Ship:FindFirstChild("Ghost_Ship") and game.Workspace.Abyss.Ship.Ghost_Ship:FindFirstChild("Wall") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Abyss.Ship.Ghost_Ship.Wall.CFrame * CFrame.new(0,10,0)
		else break end
		for i,v in pairs(game.Workspace:GetChildren()) do
			if v.Name == "kraken_hurtbox" then
				v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			end
		end
	until game.Workspace:FindFirstChild("Abyss") == nil
else
	Notification("You have enter Map Abyss [ don't show all, not work ]", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Glove Bomb",
    Func = function()
if CheckGlove() == "Warp" and not CheckBadge(2124919840) then
	OldTouch = workspace.DEATHBARRIER.CanTouch
	local Target, RootPart = TargetPlayers(true)
	if Target and RootPart then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = RootPart
		task.wait(0.2)
		game.ReplicatedStorage.WarpHt:FireServer(Target.Character:WaitForChild("HumanoidRootPart"))
		task.wait(0.15)
		workspace.DEATHBARRIER.CanTouch = true
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").DEATHBARRIER.CFrame
		wait(0.1)
		game:GetService("ReplicatedStorage").WLOC:FireServer()
		wait(0.2)
		workspace.DEATHBARRIER.CanTouch = OldTouch
	end
else
Notification("You don't have Warp equipped, or you have owner badge", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Glove Plank",
    Func = function()
if CheckGlove() == "Fort" and not CheckBadge(4031317971987872) then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SafeBoxSpace.CFrame * CFrame.new(0,60,0)
	wait(0.3)
	game:GetService("ReplicatedStorage").Fortlol:FireServer()
	wait(0.7)
	local startFort = tick()
	repeat task.wait()
		for i, v in pairs(workspace:GetChildren()) do
			if v.Name == "Part" and v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 200 then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 25, 0)
			end
		end
	until startFort - tick() >= 0.2
else
Notification("You don't have Fort equipped, or you have Owner Badge", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Glove Pyscho (Win Obby)",
    Func = function()
if game.Workspace:FindFirstChild("RepressedMemoriesMap") then
	local OldPlayerCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
	local PsychokiTrigger = workspace:FindFirstChild("RepressedMemoriesMap") and workspace.RepressedMemoriesMap:FindFirstChild("Psychokinesis"):FindFirstChild("Triggers")
	local Start = PsychokiTrigger and PsychokiTrigger:FindFirstChild("StartPsychoEvent")
	local Stop = PsychokiTrigger and PsychokiTrigger:FindFirstChild("StopPsychoEvent")
	
	if Start and Stop then
		VectorTween({Place = Start.Position, Speed = 80})
		VectorTween({Place = Stop.Position, Speed = 40})
		VectorTween({Place = OldPlayerCF.Position, Speed = 130})
	end
else
Notification("You have enter limbo [ don't show all, not work ]", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Answer Recall",
    Func = function()
local rm = workspace:FindFirstChild("RepressedMemories")
local npc = rm and rm:FindFirstChild("RepressedMemoriesNPC")
local head = npc and npc:FindFirstChild("Head")
local dialog = head and head:FindFirstChild("Dialog")
if rm and dialog then
    for i, v in pairs(dialog:GetDescendants()) do
        if v:IsA("DialogChoice") then
            if v:FindFirstChild("RightChoice") then
                v.UserDialog = "Uhhh, idk"
            end
            if v:FindFirstChild("FailChoice") then
                v:Destroy()
            end
        end
    end
else
Notification("You have enter limbo [ don't show all, not work ]", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Glove Blasphemy",
    Func = function()
if CheckGlove() == "bus" and not CheckBadge(3335299217032061) then
	if Toggles["Anti Ragdoll"] then
		_G.AntiRagdolledV = "V3"
		Toggles["Anti Ragdoll"]:SetValue(true)
	end
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value >= 666 then
		equipglove("Ghost")
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
		repeat task.wait() until CheckGlove():lower() == "ghost"
		game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
		equipglove("bus")
		task.wait(1)
		for i,v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				v.Transparency = 0
			end
		end
	end
	wait(0.6)
	if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		repeat task.wait()
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.Teleport1.CFrame)
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	end
	wait(0.59)
	repeat task.wait()
		if game.Players.LocalPlayer.Character.Humanoid.Health == 0 or game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then break end
		if game.Players.LocalPlayer.Character:FindFirstChild("bus") then
			game.Players.LocalPlayer.Character.bus.Parent = game.Players.LocalPlayer.Backpack
		end
		if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
			local Target, RootPart = TargetPlayers(true)
			if Target and RootPart then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = RootPart
				task.wait(0.34)
				game:GetService("ReplicatedStorage").busmoment:FireServer()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
				repeat task.wait()
					for i,v in pairs(game.Workspace:GetChildren()) do
						if v.Name == "BusModel" then
							v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
						end
					end
				until game.Workspace:FindFirstChild("BusModel") == nil
			end
		end
		wait(5.5)
	until CheckBadge(3335299217032061)
else
	Notification("You don't have bus equipped, or you have owner badge", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Auto Quests Chest All Glove",
    Func = function()
if workspace.Arena.CannonIsland.TreasureSpots:FindFirstChild("_treasureSpot5").Decal.Transparency == 0 then
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.TreasureSpots:FindFirstChild("_treasureSpot5").CFrame
game:GetService("ReplicatedStorage").DigEvent:FireServer({["index"] = 2, ["cf"] = CFrame.new()})
until game.Workspace:FindFirstChild("TreasureChestFolder") and game.Workspace.TreasureChestFolder:FindFirstChild("TreasureChest")
wait(1)
if game.Workspace:FindFirstChild("TreasureChestFolder") and game.Workspace.TreasureChestFolder:FindFirstChild("TreasureChest") and game.Workspace.TreasureChestFolder.TreasureChest:FindFirstChild("OpenRemote") then
game.Workspace.TreasureChestFolder.TreasureChest.OpenRemote:FireServer()
end
game:GetService("Players").LocalPlayer.Reset:FireServer()
wait(0.2)
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
wait(0.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._configPart.CFrame * CFrame.new(-5,0,0)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Glove [Redacted]",
    Func = function()
if CheckUnlockGlove("[REDACTED]").Value == false then
for i, v in pairs(workspace.PocketDimension.Doors:GetChildren()) do
if CheckUnlockGlove("[REDACTED]").Value == false then
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
task.wait(0.5)
end
end
else
Notification("you have owner [REDACTED]", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Voodoo + Fish + Trap Farm",
    Func = function()
if CheckGlove() == "Ghost" and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
local NotifyTime = Library:Notify({Title = "Time get badge", Description = "Yeah are you really?", Persist = true})
game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
equipglove("ZZZZZZZ")
wait(0.2)
game:GetService("ReplicatedStorage").ZZZZZZZSleep:FireServer()
equipglove("Brick")
wait(0.2)
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.Teleport1.CFrame)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
wait(0.2)
local TimeGetBadge = TimeCountdown(3600, function(time)
	NotifyTime:ChangeDescription(time)
end)
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
if game.Players.LocalPlayer.Backpack:FindFirstChild("Brick") then
	game.Players.LocalPlayer.Backpack:FindFirstChild("Brick").Parent = game.Players.LocalPlayer.Character
end
if game.Players.LocalPlayer.Character:FindFirstChild("Brick") then
	game:GetService("ReplicatedStorage").lbrick:FireServer()
end
until (game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health <= 0) or game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil or CheckUnlockGlove("Trap") == true
if TimeGetBadge then TimeGetBadge:Disconnect() end
if NotifyTime then NotifyTime:Destroy() end
else
Notification("You don't have Ghost equipped, or You have go to lobby", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Duck & Orange & Knife Badge",
    Func = function()
if not CheckBadge(2124760907) or not CheckBadge(2124919840) or not CheckBadge(2124760916) then
fireclickdetector(game.Workspace.Lobby.Scene.knofe.ClickDetector)
fireclickdetector(game.Workspace.Arena.island5.Orange.ClickDetector) 
fireclickdetector(game.Workspace.Arena["default island"]["Rubber Ducky"].ClickDetector)
else
Notification("You have Owner 3 badge", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Free Ice Skate",
    Func = function()
if not CheckBadge(2906002612987222) then
game:GetService("ReplicatedStorage").IceSkate:FireServer("Freeze")
else
Notification("You have Owner badge", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Free Lamp",
    Func = function()
if CheckGlove() == "ZZZZZZZ" and not CheckBadge(490455814138437) then
for i = 1, 5 do
game:GetService("ReplicatedStorage").nightmare:FireServer("LightBroken")
end
else
Notification("You don't have ZZZZZZZ equipped, or Owner badge", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Free Camera",
    Func = function()
if workspace:FindFirstChild("Camera_Obtainment_PNGS") then
	local OldC = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	CreateFreezeBV()
	for _, v in pairs(workspace.Camera_Obtainment_PNGS:GetChildren()) do
		if v:IsA("BasePart") then
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v.CFrame)
			task.wait(0.4)
			game:GetService("ReplicatedStorage"):FindFirstChild("Assets"):FindFirstChild("Obtainments"):FindFirstChild("Camera"):FindFirstChild("Remotes"):FindFirstChild("IsPhotoValid"):InvokeServer(v)
		end
	end
	game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(OldC)
	CreateFreezeBV({Remove = true})
end
    end
})

Badge2Group:AddButton({
    Text = "Get Free Recall",
    Func = function()
repeat task.wait()
game:GetService("ReplicatedStorage").RecallReset:FireServer(nil, true)
until game:GetService("ReplicatedStorage").RecallLastInteractionSteps:InvokeServer(false):lower() == "simon says walk through the portal to collect your reward"
task.wait(2)
game.Players.LocalPlayer.Character.HumanoidRootPart:PivotTo(workspace.RepressedMemories.Portal.CFrame)
    end
})

Badge2Group:AddButton({
    Text = "Get The Schlop",
    Func = function()
if CheckGlove() == "fish" then
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	repeat task.wait()
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.Teleport1.CFrame)
	until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
wait(0.3)
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.Teleport1.CFrame)
wait(0.8)
CreateFreezeBV({Name = "GetBadge_Schlop"})
wait(0.4)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(0.5)
CreateFreezeBV({Name = "GetBadge_Schlop", Remove = true})
repeat task.wait()
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v.ClassName == "Part" and v.Name ~= "Humanoid" then
			v.CFrame = game.workspace.Arena.Plate.CFrame
		end
	end
end
until game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == false
else
Notification("You don't have equiped Cloud | Badge Fish | You are in the lobby.", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Auto Get Megarock",
    Func = function()
if CheckGlove() == "Diamond" then
	local NotifyTime = Library:Notify({Title = "Time get badge", Description = "Yeah are you really?", Persist = true})
	wait(0.8)
	if not game.Players.LocalPlayer.Character:FindFirstChild("entered") then
		repeat task.wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lobby.Teleport1.CFrame 
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	end
	wait(0.3)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
	wait(0.3)
	game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
	local TimeGetBadge = TimeCountdown(36000, function(time)
		NotifyTime:ChangeDescription(time)
	end)
	while game.Players.LocalPlayer.Character:FindFirstChild("rock") and task.wait(1) do end
	if TimeGetBadge then TimeGetBadge:Disconnect() end
	if NotifyTime then NotifyTime:Destroy() end
else
	Notification("You don't have Diamond equipped", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Undead",
    Func = function()
if CheckGlove() == "Clock" then
	Notification("Ok, you have wait until revival you", _G.TimeNotify)
	if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		repeat task.wait()
			firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
			firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	end
	wait(0.4)
	game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(17952.8671875, -125.5584487915039, -3477.072021484375))
	CreateFreezeBV()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,30,0)
	wait(0.2)
	repeat task.wait()
		if workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s clock") and game.Players.LocalPlayer.Character:GetAttribute("CurrentAbility") and game.Players.LocalPlayer.Character:GetAttribute("CurrentAbility") == 7 then
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Clock"):FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
		end
	until game.Players.LocalPlayer.Character:FindFirstChild("RevivalCharm") and game.Players.LocalPlayer.Character:FindFirstChild("RevivalCharm"):GetAttribute("clock")
	wait(0.3)
	repeat task.wait() until not game.Players.LocalPlayer.Character:FindFirstChild("RevivalCharm")
	wait(0.1)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").DEATHBARRIER.CFrame
else
Notification("You don't have Clock", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Debug",
    Func = function()
if workspace:FindFirstChild("Debug Room") then
    local code = {"_", "_", "_", "7"}
    local Room = workspace:FindFirstChild("Debug Room")
    local Glove = Room:FindFirstChild("UncollectedGloves")
    local Keypad = Room:FindFirstChild("Keypad")
    local ButtonKey = Keypad and Keypad:FindFirstChild("Buttons")
    local Backpiece = Keypad and Keypad:FindFirstChild("Backpiece")

    local DuckT = Room:FindFirstChild("DuckTable")
    local DuckC = DuckT and DuckT:FindFirstChild("DuckTable")
    local DuckValue = DuckC and DuckC:FindFirstChild("Duckies")

    local MazeNumber = Room:FindFirstChild("MazeNumber", true)
    local CodeAdmin = Room:FindFirstChild("AdminNumber", true)

    if DuckValue and MazeNumber and CodeAdmin then
        code[1] = tostring(DuckValue.Value)
        code[2] = tostring(CodeAdmin.Text)
        code[3] = tostring(MazeNumber.Text)
    end
    task.wait(0.1)
    if Glove then
        for _, v in pairs(Glove:GetChildren()) do
            if v:IsA("Model") then
                local click = v:FindFirstChildOfClass("ClickDetector")
                if click then
                    fireclickdetector(click)
                end
                local touch = v:FindFirstChildWhichIsA("TouchTransmitter")
                if touch then
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, touch.Parent, 0)
                    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, touch.Parent, 1)
                end
            end
        end
    end    
    task.wait(0.3)
    codeglove = table.concat(code)
    Notification("OK, you got code: "..codeglove)
    task.wait(0.3)
    if ButtonKey then
        for i = 1, #codeglove do
			local Code = codeglove:sub(i, i)
			if ButtonKey:FindFirstChild(Code) and ButtonKey[Code]:FindFirstChild("ClickDetector") then
				fireclickdetector(ButtonKey[Code].ClickDetector)
				wait(0.3)
			end
		end
		wait(0.5)
		if ButtonKey:FindFirstChild("Enter") and ButtonKey.Enter:FindFirstChild("ClickDetector") then
			fireclickdetector(ButtonKey.Enter.ClickDetector)
		end
    end
end
    end
})

Badge2Group:AddButton({
    Text = "Get Lag",
    Func = function()
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
Notification("If you get glove lag you can reset", 5)
CreateFreezeBV()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,30,0)
else
Notification("You aren't in the arena", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Get Join Cheese",
    Func = function()
if CheckGlove() == "el gato" and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,2,35)
wait(0.37)
workspace.Cheese.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
if fireclickdetector then
fireclickdetector(workspace.Cheese.ClickDetector)
end
else
Notification("You don't have el gato equipped, or you aren't in the arena", _G.TimeNotify)
end
    end
})

if workspace:FindFirstChild("Arena") and workspace.Arena:FindFirstChild("XmasSnowPeeps") then
Badge2Group:AddButton({
    Text = "Get Join Boss Jerry",
    Func = function()
for i, v in pairs(workspace.Arena.XmasSnowPeeps:GetChildren()) do
	if v:IsA("BasePart") then
		local FireClick = v:FindFirstChild("ClickDetector", true)
		if FireClick then
			if fireclickdetector then
				fireclickdetector(FireClick)
			end
		end
	end
end
repeat task.wait() until workspace:FindFirstChild("XmasIsland") and workspace.XmasIsland:FindFirstChild("Portal") and workspace.XmasIsland.Portal.Transparency == 0
wait(0.3)
game.Players.LocalPlayer.Character:PivotTo(workspace.XmasIsland.Portal.CFrame * CFrame.new(0, 5, 0))
    end
})
end

Badge2Group:AddButton({
    Text = "Get Join Retro",
    Func = function()
if CheckGlove() == "Retro" then
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace.Arena:FindFirstChild("CannonIsland") and workspace.Arena.CannonIsland:FindFirstChild("Cannon Island [OLD]") then
for i, v in pairs(workspace.Arena.CannonIsland:FindFirstChild("Cannon Island [OLD]"):GetChildren()) do
if v.Name == "Model" and v:FindFirstChild("Towers") and v.Towers:FindFirstChild("RevealHitbox") and v.Towers:FindFirstChild("TeleportSFHitbox") then
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Towers.RevealHitbox.CFrame * CFrame.new(3, 0, 0) * CFrame.Angles(math.rad(0), math.rad(50), math.rad(0))
wait(0.2)
game:GetService("ReplicatedStorage").RetroAbility:FireServer("Ban Hammer")
until v.Towers:FindFirstChild("Ring of Fire") ~= nil
wait(0.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Towers:FindFirstChild("Ring of Fire").CFrame
end
end
end
end
else
Notification("You don't have Retro equip", 5)
end
    end
})

Badge2Group:AddButton({
    Text = "Join Map Slenderman",
    Func = function()
if CheckGlove() == "Balloony" and CheckUnlockGlove("Pocket").Value == true and (workspace:FindFirstChild("TapeRecorder") and workspace.TapeRecorder:FindFirstChild("Front")) then
if workspace:FindFirstChild("TapeRecorder") and workspace.TapeRecorder:FindFirstChild("Front") then
_G.Code = {}
Soon = {}
if workspace.TapeRecorder:FindFirstChild("PowerButton").Color ~= Color3.fromRGB(0, 255, 0) then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.TapeRecorder:FindFirstChild("PowerButton").CFrame * CFrame.new(0, 0, -5)
wait(0.5)
if fireproximityprompt then
fireproximityprompt(workspace.TapeRecorder.Front:FindFirstChild("ProximityPrompt"))
end
end
repeat task.wait()
if workspace.TapeRecorder:FindFirstChild("PowerButton").Color == Color3.fromRGB(0, 255, 0) then
	for i, v in pairs(workspace.TapeRecorder.Front:FindFirstChild("DigitsSFX"):GetChildren()) do
		if v:IsA("Sound") and v.Playing == true and not Soon[v.Name] then
			table.insert(_G.Code, v.Name)
			Soon[v.Name] = true
		end
	end
end
until workspace.TapeRecorder:FindFirstChild("PowerButton").Color == Color3.fromRGB(255, 0, 0)
wait(0.3)
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
game:GetService("Players").LocalPlayer.Reset:FireServer()
wait(0.3)
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
end
wait(0.13)
equipglove("Pocket")
wait(0.2)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,0,35))
wait(0.2)
repeat task.wait() until workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Pocket") and workspace[game.Players.LocalPlayer.Name.."'s Pocket"]:FindFirstChild("Hitbox") and workspace[game.Players.LocalPlayer.Name.."'s Pocket"]:FindFirstChild("ProximityPrompt")
wait(0.3)
repeat task.wait()
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
wait(0.3)
if workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Pocket"):FindFirstChild("Hitbox") then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace[game.Players.LocalPlayer.Name.."'s Pocket"].Hitbox.CFrame
	wait(0.4)
	fireproximityprompt(workspace[game.Players.LocalPlayer.Name.."'s Pocket"].ProximityPrompt)
end
wait(5)
if game.Workspace:FindFirstChild("RoomsFolder") then
for i,v in pairs(game.Workspace.RoomsFolder:GetChildren()) do
if v.Name == (game.Players.LocalPlayer.Name.."'s Room") and v:FindFirstChild("PocketKeypad") then
fireclickdetector(v.PocketKeypad.Buttons:FindFirstChild("Reset"):FindFirstChild("ClickDetector"))
wait(0.2)
for _, b in ipairs(_G.Code) do
fireclickdetector(v.PocketKeypad.Buttons:FindFirstChild(b):FindFirstChild("ClickDetector"))
wait(0.46)
end
task.wait(0.15)
fireclickdetector(v.PocketKeypad.Buttons:FindFirstChild("Enter"):FindFirstChild("ClickDetector"))
end
end
end
wait(0.3)
game:GetService("Players").LocalPlayer.Reset:FireServer()
wait(0.3)
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
wait(0.3)
for i, v in pairs(workspace.BountyHunterRoom:FindFirstChild("BountyHunterMysteryRoom"):FindFirstChild("Pages"):GetChildren()) do
if v:IsA("BasePart") and v:FindFirstChild("ClickDetector") then
fireclickdetector(v:FindFirstChild("ClickDetector"))
end
end
wait(0.3)
repeat task.wait() until workspace:FindFirstChild("BountyHunterRoom") and workspace.BountyHunterRoom:FindFirstChild("BountyHunterLever") and workspace.BountyHunterRoom.BountyHunterLever:FindFirstChild("Root")
wait(0.15)
if workspace:FindFirstChild("BountyHunterRoom") and workspace.BountyHunterRoom:FindFirstChild("BountyHunterLever") and workspace.BountyHunterRoom.BountyHunterLever:FindFirstChild("Root") then
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.BountyHunterLever.Root.CFrame
wait(0.4)
if fireproximityprompt then
	fireproximityprompt(workspace.BountyHunterRoom.BountyHunterLever.Root:FindFirstChild("ProximityPrompt"))
end
repeat task.wait() until workspace.Lobby:FindFirstChild("Clothesline Model") and workspace.Lobby["Clothesline Model"]:FindFirstChild("Part") and workspace.Lobby["Clothesline Model"].Part:FindFirstChild("jerma").Texture == "rbxassetid://16591849948"
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lobby["Clothesline Model"]:FindFirstChild("Part").CFrame
wait(0.3)
if fireclickdetector then
	fireclickdetector(workspace.Lobby["Clothesline Model"].Part:FindFirstChild("ClickDetector"))
end
end
end
else
Notification("You don't have Balloon or not owner glove Pocket, or you have equip Pocket spawn Tape Recorder", _G.TimeNotify)
end
    end
})

Badge2Group:AddButton({
    Text = "Join Job Application",
    Func = function()
equipglove("Extended")
wait(0.3)
if workspace:FindFirstChild("JobApplication") and workspace.JobApplication:FindFirstChild("paper") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.JobApplication.paper.CFrame
wait(0.3)
fireclickdetector(workspace.JobApplication.paper.ClickDetector)
end
    end
})

Badge2Group:AddButton({
    Text = "Join Map Egger",
    Func = function()
if workspace:FindFirstChild("EasterHuntEggs") == nil then
Notification("You have get Hitman quest", _G.TimeNotify)
repeat task.wait() until workspace:FindFirstChild("EasterHuntEggs")
end
if workspace:FindFirstChild("EasterHuntEggs") then
for i, v in pairs(workspace.EasterHuntEggs:GetChildren()) do
v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
end
wait(0.5)
if workspace:FindFirstChild("EggTeleport") == nil then
repeat task.wait() until workspace:FindFirstChild("EggTeleport")
end
if workspace:FindFirstChild("EggTeleport") and workspace.EggTeleport:FindFirstChild("ClickDetector") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace:FindFirstChild("EggTeleport").CFrame
if fireclickdetector then
fireclickdetector(workspace.EggTeleport.ClickDetector)
end
end
    end
})

Badge2Group:AddButton({
    Text = "Join Map Plunger",
    Func = function()
if workspace:FindFirstChild("BountyHunterRoom") and workspace.BountyHunterRoom:FindFirstChild("PlungerMain") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom:FindFirstChild("PlungerMain").CFrame
if fireclickdetector then
fireclickdetector(workspace.BountyHunterRoom.PlungerMain:FindFirstChildOfClass("ClickDetector"))
end
end
repeat task.wait() until workspace:FindFirstChild("plungers") and workspace.plungers:FindFirstChild("ToiletPlunger").Transparency < 1
wait(0.4)
if workspace:FindFirstChild("plungers") and workspace.plungers:FindFirstChild("ToiletPlunger") and workspace.plungers.ToiletPlunger:FindFirstChildOfClass("ClickDetector") then
if fireclickdetector then
fireclickdetector(workspace.plungers.ToiletPlunger:FindFirstChildOfClass("ClickDetector"))
end
end
    end
})

Badge2Group:AddButton({
    Text = "Join Map Pim Boss",
    Func = function()
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	repeat task.wait()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Lobby.Teleport1.CFrame 
	until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
if not workspace:FindFirstChild("PortalMask") then
	if workspace:FindFirstChild("Arena"):FindFirstChild("island5") then
		for i, v in pairs(workspace.Arena.island5:GetChildren()) do
			if v.Name == "Union" and v:FindFirstChild("C") and v.C:FindFirstChild("ClickDetector") then
				click = v.C.ClickDetector
				break
			end
		end
		if click and click.Parent then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = click.Parent.CFrame * CFrame.new(0, 5, 0)
			click.Parent.Transparency = 0
			wait(0.7)
			if fireclickdetector then
				fireclickdetector(click, 0)
				fireclickdetector(click, 1)
			end
		end
	end
	repeat task.wait() until workspace:FindFirstChild("PortalMask") and workspace.PortalMask:FindFirstChild("Main") and workspace.PortalMask.Main:FindFirstChild("ProximityPrompt")
	wait(2)
end
local PPMain = workspace.PortalMask.Main:FindFirstChild("ProximityPrompt")
if PPMain and PPMain.Enabled and PPMain.Parent then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = PPMain.Parent.CFrame * CFrame.new(0, 5, 0)
end
wait(1)
Notification("if server bug, you can't enter the boss fight, please wait 4 seconds before entering the fighter boss fight.", _G.TimeNotify)
local start = tick()
while tick() - start < 4 and task.wait() do end
game:GetService("TeleportService"):Teleport(77963332815593)
    end
})

Badge2Group:AddToggle("Friday the 13th", {
    Text = "Auto Join Friday the 13th",
    Default = false, 
    Callback = function(Value) 
_G.Fridayth = Value
while _G.Fridayth do
if game.Players.LocalPlayer.Character:FindFirstChild("InLabyrinth") then
for i, v in pairs(workspace:GetChildren()) do
    if string.find(v.Name, "Labyrinth") and v:FindFirstChild("PaintingModel") and v.PaintingModel:FindFirstChild("HitBox") then
        if v.PaintingModel.HitBox:FindFirstChild("TouchInterest") then
	        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.PaintingModel:FindFirstChild("HitBox").CFrame
        end
    end
end
end
task.wait()
end
    end
})

if hookmetamethod then
local BobChance = Badge2Group:AddLabel("Glove Replica", true)
table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
	local Chance = (1 - (1 - (1 / 7500))^ReplicaCount) * 100
	if BobChance then
		if CheckGlove():lower():find("replica") then
			BobChance:SetText(string.format("Spawn Replica: %d | Rate: 1/7500 | Chance: %.2f%%", ReplicaCount, Chance))
		else
			BobChance:SetText("Replica reset, The reason is because you changed gloves ["..CheckGlove().."]")
			ReplicaCount = 0
		end
	end
end))
end

Badge2Group:AddDropdown("Farm Bob", {
    Text = "Farm Bob",
    Values = {"Walk", "Teleport"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BobFarmCh = Value
    end
})

Badge2Group:AddToggle("Bob", {
    Text = "Bob Farm",
    Default = false, 
    Callback = function(Value) 
_G.BobFarm = Value
if CheckGlove() ~= "Replica" and Value == true then
Notification("You don't have Replica equipped", 5)
wait(0.05)
Toggles["Bob"]:SetValue(false)
end
    end
})

local isProcessing = false 
local lastActionTime = 0
table.insert(_G.ConnectFun, game:GetService("RunService").Heartbeat:Connect(function()
    if _G.BobFarm and CheckGlove() == "Replica" then
        if isProcessing and (os.clock() - lastActionTime > 5) then
            isProcessing = false
        end
        if isProcessing then return end 
        local success, err = pcall(function()
            local char = game:GetService("Players").LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            if hrp and hum and hum.Health > 0 then
                if not char:FindFirstChild("entered") then
                    local ArenaLobby = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1")
                    if ArenaLobby then
                        if _G.BobFarmCh == "Walk" then
                            hum:MoveTo(ArenaLobby.Position)
                        else
                            firetouchinterest(hrp, ArenaLobby, 0)
                            firetouchinterest(hrp, ArenaLobby, 1)
                        end
                    end
                else
                    isProcessing = true 
                    lastActionTime = os.clock()
                    if _G.BobFarmCh == "Walk" then
                        hum:MoveTo(hrp.Position)
                    end
                    task.wait(0.19)
                    game:GetService("ReplicatedStorage").Duplicate:FireServer(true)
                    task.wait(0.2)
                    game:GetService("Players").LocalPlayer.Reset:FireServer()
                    repeat task.wait() 
                        char = game:GetService("Players").LocalPlayer.Character or nil
                    until char and not char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart")
                    task.wait(0.5) 
                    isProcessing = false
                end
            end
        end)
        if not success then
            isProcessing = false
        end
    end
end))


Badge2Group:AddToggle("Bus Stab", {
    Text = "Bus Stab",
    Default = false, 
    Callback = function(Value) 
_G.BusStab = Value
while _G.BusStab do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	for i,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "BusModel" then
			v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end
task.wait()
end
    end
})

Badge2Group:AddToggle("Toolbox Farm", {
    Text = "Toolbox Farm",
    Default = false, 
    Callback = function(Value) 
_G.Toolboxfarm = Value
while _G.Toolboxfarm do
if game.Workspace:FindFirstChild("Toolbox") then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == "Toolbox" then
if v:FindFirstChild("Main") then
v.Main.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(-5, -1.63, 0)
end
if fireclickdetector and v:FindFirstChild("ClickDetector") then
fireclickdetector(v.ClickDetector, 0)
fireclickdetector(v.ClickDetector, 1)
                    end
                end
                end
            end
task.wait()
end
    end
})

Badge2Group:AddToggle("Hallow Jack Farm", {
    Text = "Hallow Jack Farm",
    Default = false, 
    Callback = function(Value) 
_G.HallowJackFarm = Value
while _G.HallowJackFarm do
if workspace:FindFirstChild("Gravestone") then
	for i,v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "Gravestone" and v:FindFirstChild("ClickDetector") then
			if game.Players.LocalPlayer.Character:FindFirstChild("KillstreakLevel") and game.Players.LocalPlayer.Character.KillstreakLevel.Value > 9 then
				for _, s in pairs(v:GetChildren()) do
					if s:IsA("BasePart") then
						s.CFrame = game.Players.LocalPlayer.Character.Head.CFrame * CFrame.new(0, 1, 0)
					end
				end
				if fireclickdetector then
					fireclickdetector(v.ClickDetector, 0)
					fireclickdetector(v.ClickDetector, 1)
				end
			end
		end
	end
elseif workspace:FindFirstChild("Gravestone") == nil and game.Players.LocalPlayer.Character:FindFirstChild("KillstreakLevel") and game.Players.LocalPlayer.Character:FindFirstChild("KillstreakLevel").Value > 9 then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Safespot"].CFrame * CFrame.new(0,10,0)
end
task.wait()
end
    end
})

Badge2Group:AddDropdown("OrbFarm", {
    Text = "Orb Farm",
    Values = {"Phase", "Jet", "MATERIALIZE", "Siphon", "Glitch"},
    Default = {"Phase", "Jet"},
    Multi = true
})

Badge2Group:AddToggle("Orb Farm", {
    Text = "Auto Orb Farm",
    Default = false, 
    Callback = function(Value) 
_G.FarmOrbTP = Value
while _G.FarmOrbTP do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	local ChooseOrbFarm = Options.OrbFarm and Options.OrbFarm.Value or nil
	if ChooseOrbFarm then
		for i,v in pairs(game.Workspace:GetChildren()) do
	        if (ChooseOrbFarm["Jet"] and v.Name == "JetOrb") or (ChooseOrbFarm["Phase"] and v.Name == "PhaseOrb") or (ChooseOrbFarm["MATERIALIZE"] and v.Name == "MATERIALIZEOrb") or (ChooseOrbFarm["Siphon"] and v.Name == "SiphonOrb") or (ChooseOrbFarm["Glitch"] and v.Name:find("Orb") and v:FindFirstChild("Attachment") and v.Attachment:FindFirstChild("OrbGlitchEffect")) then
				local CFOld = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
				game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v.CFrame
				wait(0.37)
				game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFOld
				wait(0.7)
	        end
	    end
	end
end
task.wait()
end
    end
})

Badge2Group:AddToggle("Phase Or Jet Glitch", {
    Text = "Phase & Jet Glitch",
    Default = false, 
    Callback = function(Value) 
_G.Glitchfarm = Value
while _G.Glitchfarm do
if CheckGlove() == "Error" then
	for i,v in pairs(game.Workspace:GetChildren()) do
		if v.Name == "JetOrb" or v.Name == "PhaseOrb" then
			game.ReplicatedStorage.Errorhit:FireServer(v)
	    end
    end
end
task.wait()
end
    end
})

Badge2Group:AddToggle("Gift Farm", {
    Text = "Gift Farm",
    Default = false, 
    Callback = function(Value) 
_G.Giftfarm = Value
while _G.Giftfarm do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	for i,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "Gift" then
			v.CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
        end
    end
end
task.wait()
end
    end
})

Badge2Group:AddToggle("AutoFram Brick", {
    Text = "AutoFram Brick",
    Default = false, 
    Callback = function(Value) 
_G.Brickfarm = Value
if CheckGlove() == "Brick" then
while _G.Brickfarm do
if game.Players.LocalPlayer.Character:FindFirstChild("Brick") then
	game:GetService("ReplicatedStorage").lbrick:FireServer()
end
task.wait()
end
elseif Brickfarm == true then
Notification("You don't have Brick equipped", _G.TimeNotify)
wait(0.05)
Toggles["AutoFram Brick"]:SetValue(false)
end
    end
})

Badge2Group:AddToggle("Get Tycoon", {
    Text = "Get Tycoon",
    Default = false, 
    Callback = function(Value) 
_G.AutoTpPlate = Value
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and #game.Players:GetPlayers() >= 7 then
while _G.AutoTpPlate do
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and #game.Players:GetPlayers() >= 7 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Arena.Plate.CFrame
end
task.wait()
end
elseif _G.AutoTpPlate == true then
Notification("You need enter erane, or 7 people the server", _G.TimeNotify)
wait(0.05)
Toggles["Get Tycoon"]:SetValue(false)
end
    end
})

TabBoxMastery = Tabs.Tab3:AddRightTabbox()
local Badge3Group = TabBoxMastery:AddTab("Mastery")

Badge3Group:AddDropdown("Farm Mastery", {
    Text = "Farm Mastery",
    Values = {"Replica", "Baller", "Null"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.FarmMastery = Value
    end
})

function MasteryPlayers(glove, ghost)
	local player = game.Players.LocalPlayer
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	
	local function enterporter(tp)
		if not char then return end
		if not char:FindFirstChild("entered") then
			local portal = workspace.Lobby[tp].TouchInterest.Parent
			repeat task.wait()
				if firetouchinterest then
					firetouchinterest(char.Head,portal, 0)
					firetouchinterest(char.Head,portal, 1)
				else
					char.HumanoidRootPart.CFrame = portal.CFrame
				end
			until char:FindFirstChild("entered")
		end
	end

	player.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	wait(0.5)
	if ghost == true then
		if char:FindFirstChild("entered") == nil and game.Players.LocalPlayer:FindFirstChild("leaderstats"):FindFirstChild("Slaps").Value >= 666 then
			equipglove("Ghost")
			repeat task.wait() until CheckGlove():lower() == "ghost"
			game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
			equipglove(glove)
			task.wait(1)
			for i,v in pairs(char:GetChildren()) do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
					v.Transparency = 0
				end
			end
		end
	end
	enterporter("Teleport1")
	wait(0.35)
	player.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	wait(0.3)
	if char:FindFirstChild("entered") then
		local players = {}
		for i, v in pairs(game.Players:GetChildren()) do
			if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
				table.insert(players, v)
			end
		end
		if #players ~= 0 then
			return players[math.random(#players)]
		end
	end
	return nil
end

function SpawnFarmMastery()
	local player = game.Players.LocalPlayer
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local oldglove = CheckGlove()
	local gloveEquip
	if _G.FarmMastery then
		if _G.FarmMastery:lower() == "baller" then
			gloveEquip = "Baller"
		elseif _G.FarmMastery:lower() == "null" then
			gloveEquip = "Null"
		else
			gloveEquip = "Replica"
		end
	else
		gloveEquip = "Replica"
	end

	local function abilityspawn()
		local g = CheckGlove():lower()
		if g == "baller" then
			game.ReplicatedStorage.GeneralAbility:FireServer()
		elseif g == "null" then
			game.ReplicatedStorage.NullAbility:FireServer()
		else
			game.ReplicatedStorage.Duplicate:FireServer(true)
		end
	end
	
	local function enterporter(tp)
		if not char then return end
		if not char:FindFirstChild("entered") then
			local portal = workspace.Lobby[tp].TouchInterest.Parent
			repeat task.wait()
				if firetouchinterest then
					firetouchinterest(char.Head,portal, 0)
					firetouchinterest(char.Head,portal, 1)
				else
					char.HumanoidRootPart.CFrame = portal.CFrame
				end
			until char:FindFirstChild("entered")
		end
	end
	equipglove(gloveEquip)
	task.wait(0.3)
	if gloveEquip:lower() ~= "null" then
		enterporter("Teleport2")
	end
	wait(0.3)
	char.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	if gloveEquip:lower() == "null" then
		char.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.Build.Union.CFrame * CFrame.new(0,0,5)
	end
	task.wait(0.6)
	if gloveEquip:lower() ~= "null" then
		abilityspawn()
	else
		repeat task.wait()
			abilityspawn()
		until gloveEquip:lower() ~= "null" or (workspace:FindFirstChild("Imp") and workspace.Imp:FindFirstChild("Body"))
	end
	if gloveEquip:lower() ~= "null" then
		player.Reset:FireServer()
		repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not player.Character:FindFirstChild("entered")
	end
	equipglove(oldglove)
	task.wait(0.3)
	enterporter("Teleport1")
	char.HumanoidRootPart.CFrame = workspace.SafeBox.CFrame * CFrame.new(0,5,0)
end

Badge3Group:AddDropdown("Spring Mastery", {
    Text = "Spring Mastery",
    Values = {"Jump Over Player", "Evade Player", "Jump Land 2 Sec Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.SpringMastery = Value
    end
})

Badge3Group:AddToggle("Auto Spring Mastery", {
    Text = "Auto Spring Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoSpringMastery = Value
if CheckGlove() == "Spring" then
while _G.AutoSpringMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), false)
if RandomPlayer then
	CreateFreezeBV()
	for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
	if _G.SpringMastery == "Jump Over Player" then
		game:GetService("ReplicatedStorage"):WaitForChild("SpringJump"):FireServer()
		wait(0.56)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, -6, 5))
		repeat task.wait() until _G.AutoSpringMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.HumanoidRootPart)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(2.7)
	elseif _G.SpringMastery == "Evade Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, -6, 5))
		repeat task.wait() until _G.AutoSpringMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.HumanoidRootPart)
			task.wait()
		end
		game:GetService("ReplicatedStorage"):WaitForChild("SpringJump"):FireServer()
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(2.7)
	elseif _G.SpringMastery == "Jump Land 2 Sec Player" then
		game:GetService("ReplicatedStorage"):WaitForChild("SpringJump"):FireServer()
		task.wait(1.4)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, -6, 5))
		repeat task.wait() until _G.AutoSpringMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.HumanoidRootPart)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(4.6)
	end
end
task.wait()
end
elseif _G.AutoSpringMastery == true then
Notification("You don't have Spring equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Spring Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Acrobat Mastery", {
    Text = "Acrobat Mastery",
    Values = {"Roll Slap Player", "Slap Roll Player", "Combo Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AcrobatMastery = Value
    end
})

Badge3Group:AddToggle("Auto Acrobat Mastery", {
    Text = "Auto Acrobat Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoAcrobatMastery = Value
if CheckGlove() == "Acrobat" then
while _G.AutoAcrobatMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	CreateFreezeBV()
	if _G.AcrobatMastery == "Roll Slap Player" then
		game:GetService("ReplicatedStorage").Roll:FireServer()
		wait(0.8)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoAcrobatMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(2.7)
	elseif _G.AcrobatMastery == "Slap Roll Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoAcrobatMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			game:GetService("ReplicatedStorage").Roll:FireServer()
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(2.7)
	elseif _G.AcrobatMastery == "Combo Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoAcrobatMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		game:GetService("ReplicatedStorage").Roll:FireServer()
		repeat task.wait() until _G.AutoAcrobatMastery == false or RandomPlayer.Character:FindFirstChild("Ragdolled").Value == false
		wait(0.15)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoAcrobatMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(4.4)
	end
end
task.wait()
end
elseif _G.AutoAcrobatMastery == true then
Notification("You don't have Acrobat equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Acrobat Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Phantom Mastery", {
    Text = "Phantom Mastery",
    Values = {"Jumpscare Player", "Combo Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PhantomMastery = Value
    end
})

Badge3Group:AddToggle("Auto Phantom Mastery", {
    Text = "Auto Phantom Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoPhantomMastery = Value
if CheckGlove() == "Phantom" then
while _G.AutoPhantomMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	CreateFreezeBV()
	PhantomTool = (game.Players.LocalPlayer.Character:FindFirstChild(CheckGlove()) or game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove())) or nil
	if _G.PlankMastery == "Jumpscare Player" then
		repeat task.wait()
			if PhantomTool then
				game:GetService("ReplicatedStorage").PhantomDash:InvokeServer(PhantomTool) 
			end
		until _G.AutoPhantomMastery == false or game.Players.LocalPlayer.Character:GetAttribute("phantom")
		wait(0.4)
		repeat task.wait() until _G.AutoPhantomMastery == false or not game.Players.LocalPlayer.Character:GetAttribute("phantom")
		wait(0.3)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoPhantomMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 5 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(0.65)
	elseif _G.PlankMastery == "Combo Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoPhantomMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(0.35)
		repeat task.wait()
			if PhantomTool then
				game:GetService("ReplicatedStorage").PhantomDash:InvokeServer(PhantomTool) 
			end
		until _G.AutoPhantomMastery == false or game.Players.LocalPlayer.Character:GetAttribute("phantom")
		wait(0.4)
		repeat task.wait() until _G.AutoPhantomMastery == false or not game.Players.LocalPlayer.Character:GetAttribute("phantom")
		task.wait(0.1)
		local RandomPlayer = players[math.random(#players)]
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoPhantomMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(4.4)
	end
end
task.wait()
end
elseif _G.AutoPhantomMastery == true then
Notification("You don't have Phantom equipped, or you have 19k+ slap", _G.TimeNotify)
wait(0.05)
Toggles["Auto Phantom Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Plank Mastery", {
    Text = "Plank Mastery",
    Values = {"Ambush Player", "Plank Hit Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PlankMastery = Value
    end
})

Badge3Group:AddToggle("Auto Plank Mastery", {
    Text = "Auto Plank Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoPlankMastery = Value
if CheckGlove() == "Plank" then
while _G.AutoPlankMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	CreateFreezeBV()
	if _G.PlankMastery == "Ambush Player" then
		if not workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank") or workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank"):GetAttribute("collect") then
			game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(0, 0, 0), Vector3.new(math.huge, 0, 0))
			wait(1.7)
		end
		if workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank") and not workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank"):GetAttribute("collect") then
			CreateFreezeBV({Remove = true})
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank").CFrame * CFrame.new(0, 0, 3) * CFrame.Angles(math.rad(60), math.rad(0), math.rad(0)))
			wait(1.7)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank").CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(60), math.rad(0), math.rad(0)))
		end
		wait(2.5)
		CreateFreezeBV()
		wait(0.25)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoPlankMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 5 do
			slapglove(RandomPlayer.Character.Head)
			task.wait()
		end
		wait(0.2)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		task.wait(4.5)
	elseif _G.PlankMastery == "Plank Hit Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, 6))
		repeat task.wait() until _G.AutoPlankMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(0, 0, 0), Vector3.new(math.huge, 0, 0))
		wait(0.3)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(3.7)
	end
end
task.wait()
end
elseif _G.AutoPlankMastery == true then
Notification("You don't have Plank equipped, or you have 19k+ slap", _G.TimeNotify)
wait(0.05)
Toggles["Auto Plank Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Moon Mastery", {
    Text = "Moon Mastery",
    Values = {"Unequip + Ragdoll Time", "Slap Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.MoonMastery = Value
    end
})

Badge3Group:AddToggle("Auto Moon Mastery", {
    Text = "Auto Moon Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoMoonMastery = Value
if not _G.AutoMoonMastery then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "Moon" then
while _G.AutoMoonMastery do
if _G.MoonMastery == "Slap Player" then
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	CreateFreezeBV()
	game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
	repeat task.wait() until _G.AutoMoonMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
	wait(0.3)
	for i = 1, 3 do
		slapglove(RandomPlayer.Character:FindFirstChild("Head"))
		wait(0.2)
	end
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	task.wait(4.5)
end
elseif _G.MoonMastery == "Unequip + Ragdoll Time" then
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		repeat task.wait()
		firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
		firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
		wait(0.3)
	end
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	CreateFreezeBV()
	game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = -99})
	if game.Players.LocalPlayer.Character:FindFirstChild("Moon") then
		game.Players.LocalPlayer.Character:FindFirstChild("Moon").Parent = game.Players.LocalPlayer.Backpack
	end
	if game.Players.LocalPlayer.Backpack:FindFirstChild("Moon") then
		game.Players.LocalPlayer.Backpack:FindFirstChild("Moon").Parent = game.Players.LocalPlayer.Character
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Moon equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Moon Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Eggler Mastery", {
    Text = "Eggler Mastery",
    Values = {"Unegg Slap Player", "Deny Slap Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.EgglerMastery = Value
    end
})

Badge3Group:AddToggle("Auto Eggler Mastery", {
    Text = "Auto Eggler Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoEgglerMastery = Value
if not _G.AutoEgglerMastery then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "Eggler" then
while _G.AutoEgglerMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	CreateFreezeBV()
	if _G.EgglerMastery == "Deny Slap Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoEgglerMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(random.Character:FindFirstChild("Head"))
			task.wait(0.2)
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		repeat task.wait()
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
		until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("isEgg")
		repeat task.wait()
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
		until game.Players.LocalPlayer.Character and not game.Players.LocalPlayer.Character:GetAttribute("isEgg")
	elseif _G.EgglerMastery == "Unegg Slap Player" then
		repeat task.wait()
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
		until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:GetAttribute("isEgg")
		repeat task.wait()
			game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
		until game.Players.LocalPlayer.Character and not game.Players.LocalPlayer.Character:GetAttribute("isEgg")
		wait(0.3)
		for i = 1, 3 do
			slapglove(random.Character:FindFirstChild("Head"))
			task.wait(0.2)
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	end
	task.wait(4.5)
end
task.wait()
end
elseif Value == true then
Notification("You don't have Eggler equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Eggler Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Thanos Mastery", {
    Text = "Thanos Mastery",
    Values = {"Ambush Player", "Combo Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ThanosMastery = Value
    end
})

Badge3Group:AddToggle("Auto Thanos Mastery", {
    Text = "Auto Thanos Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoThanosMastery = Value
if not _G.AutoThanosMastery then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "Thanos" then
while _G.AutoThanosMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	CreateFreezeBV()
	if _G.ThanosMastery == "Ambush Player" then
		game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(2)
		task.wait(1.9)
		for i = 1, 3 do
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
			repeat task.wait() until _G.AutoThanosMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
			wait(0.3)
			slapglove(RandomPlayer.Character:FindFirstChild("Head"))
			task.wait(0.8)
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	elseif _G.ThanosMastery == "Combo Player" then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoThanosMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		wait(0.3)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character:FindFirstChild("Head"))
			task.wait(0.2)
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(2)
		task.wait(1.9)
		for i = 1, 3 do
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
			repeat task.wait() until _G.AutoThanosMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
			wait(0.3)
			slapglove(RandomPlayer.Character:FindFirstChild("Head"))
			task.wait(0.9)
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	end
	task.wait(5.8)
end
task.wait()
end
elseif Value == true then
Notification("You don't have Thanos equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Thanos Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Chain Mastery", {
    Text = "Chain Mastery",
    Values = {"Arc lightning", "Lightning 3 player", "Lightning 6 player (7 player)", "Slap (No player group)"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ChainMastery = Value
    end
})

Badge3Group:AddToggle("Auto Chain Mastery", {
    Text = "Auto Chain Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoChainMastery = Value
if not _G.AutoChainMastery then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "Chain" then
while _G.AutoChainMastery do
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if _G.ChainMastery:find("lightning") or _G.ChainMastery:find("Lightning") then
	if _G.ChainMastery == "Arc lightning" then
		numberPlayers = 2 
	elseif _G.ChainMastery == "Lightning 3 player" then
		numberPlayers = 3
	elseif _G.ChainMastery == "Lightning 6 player (7 player)" then
		numberPlayers = 7
	end
	local GroupPlayer = findGroup(20, (numberPlayers or 2))
	if GroupPlayer then
		local random = GroupPlayer[math.random(1, #GroupPlayer)]
		if random.Character and random.Character:FindFirstChild("HumanoidRootPart") and random.Character:FindFirstChild("Head") and random.Character:FindFirstChild("Ragdolled") and not random.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and random.Character.Ragdolled.Value == false and random.Character.isInArena.Value == true and notSlap(random.Character, BlackList) then
			CreateFreezeBV()
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(random.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
			repeat task.wait() until _G.AutoChainMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - random.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
			wait(0.26)
			for i = 1, 3 do
				slapglove(random.Character:FindFirstChild("Head"))
				task.wait(0.2)
			end
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
			wait(0.4)
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			wait(0.2)
		end
	end
elseif _G.ChainMastery:find("Slap") then
	if RandomPlayer then
		CreateFreezeBV()
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoChainMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		task.wait(0.25)
		for i = 1, 3 do
			slapglove(RandomPlayer.Character:FindFirstChild("Head"))
			wait(0.2)
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(0.4)
		game:GetService("Players").LocalPlayer.Reset:FireServer()
		wait(0.3)
		repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		wait(0.2)
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Chain equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Chain Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Obby Mastery", {
    Text = "Obby Mastery",
    Values = {"Spam Obby", "Slap Entity"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ObbyMastery = Value
    end
})

Badge3Group:AddToggle("Auto Obby Mastery", {
    Text = "Auto Obby Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoObbyMastery = Value
if CheckGlove() == "Obby" then
while _G.AutoObbyMastery do
if _G.ObbyMastery:match("Entity") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoObbyMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				if v:FindFirstChild("Body") then
					slapglove(v:FindFirstChild("Body"))
				end
			until v:FindFirstChild("Body") == nil or _G.AutoObbyMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoObbyMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
elseif _G.ObbyMastery == "Spam Obby" then
	if not workspace:FindFirstChild("ObbyItem"..game.Players.LocalPlayer.Name.."LavaBlock") then
		repeat task.wait()
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
				equipglove("Fort")
				repeat task.wait() until not _G.AutoObbyMastery or CheckGlove() == "Fort"
				wait(0.3)
				repeat task.wait()
					if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
					end
				until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered")
				task.wait(0.6)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
				task.wait(0.5)
				game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 20))
				task.wait(4)
				game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
				CreateFreezeBV({Name = "SpamObby"})
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(209, -28006, 1)
				wait(0.8)
				for i = 1, 2 do
					game:GetService("ReplicatedStorage").Fortlol:FireServer()
					wait(3.6)
				end
				game:GetService("Players").LocalPlayer.Reset:FireServer()
				wait(0.3)
				repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				wait(0.5)
				equipglove("Obby")
				repeat task.wait() until not _G.AutoObbyMastery or CheckGlove() == "Obby"
				wait(0.4)
				repeat task.wait()
					if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
					end
				until game.Players.LocalPlayer.Character:FindFirstChild("entered")
				task.wait(0.6)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
				task.wait(0.5)
				game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 0, 20))
				task.wait(4)
				game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
				CreateFreezeBV({Name = "SpamObby"})
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(209, -28006, 1)
				wait(0.8)
				for i, v in pairs(workspace:GetChildren()) do
					if v.Name == "Part" and v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound") and (root.Position - v.Position).Magnitude <= 50 then
						FortWall = v
						break
					end
				end
				if FortWall then
					local WallSize = FortWall.Size
					local NEWY = FortWall.Position.Y + (WallSize.Y/2) + 0.4
					game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(FortWall.Position.X, NEWY, FortWall.Position.Z) * CFrame.Angles(math.rad(0), 55, 0), 1)
				end
				task.wait(4)
			end
		until not _G.AutoObbyMastery or workspace:FindFirstChild("ObbyItem"..game.Players.LocalPlayer.Name.."LavaBlock")
		task.wait(5.3)
	end
	if workspace:FindFirstChild("ObbyItem"..game.Players.LocalPlayer.Name.."LavaBlock") then
		game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(workspace:FindFirstChild("ObbyItem"..game.Players.LocalPlayer.Name.."LavaBlock").CFrame, 1)
	end
	task.wait(4.3)
end
task.wait()
end
elseif Value == true then
Notification("You don't have Obby equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Obby Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Bonk Mastery", {
    Text = "BONK Mastery",
    Values = {"BONK Player", "BONK + Slap"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BonkMastery = Value
    end
})

Badge3Group:AddToggle("Auto Bonk Mastery", {
    Text = "Auto BONK Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoBonkMastery = Value
if not _G.AutoBonkMastery then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "BONK" then
while _G.AutoBonkMastery do
if _G.BonkMastery:match("BONK") then
	local RandomPlayer = MasteryPlayers(CheckGlove(), true)
	if RandomPlayer then
		CreateFreezeBV()
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
		repeat task.wait() until _G.AutoBonkMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		task.wait(0.25)
		game:GetService("ReplicatedStorage"):WaitForChild("BONK"):FireServer()
		if _G.BonkMastery == "BONK + Slap" then
			wait(0.2)
			for i = 1, 3 do
				slapglove(RandomPlayer.Character:FindFirstChild("Head"))
				wait(0.2)
			end
		end
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		wait(0.4)
		game:GetService("Players").LocalPlayer.Reset:FireServer()
		wait(0.3)
		repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have BONK equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Bonk Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Voodoo Mastery", {
    Text = "Voodoo Mastery",
    Values = {"Farm Voodoo", "Voodoo Slap 20 Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.VoodooMastery = Value
    end
})

Badge3Group:AddToggle("Auto Voodoo Mastery", {
    Text = "Auto Voodoo Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoVoodooMastery = Value
if not _G.AutoVoodooMastery then
	for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
end
if CheckGlove() == "Voodoo" then
while _G.AutoVoodooMastery do
if _G.VoodooMastery:match("Voodoo") then
	local RandomPlayer = MasteryPlayers(CheckGlove(), true)
	if RandomPlayer then
		CreateFreezeBV()
		for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, -6, 5))
		repeat task.wait() until _G.AutoVoodooMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		task.wait(0.25)
		slapglove(RandomPlayer.Character:FindFirstChild("Head"))
		wait(0.2)
		repeat task.wait() until RandomPlayer.Character:FindFirstChild("DOLLPART")
		wait(0.1)
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("DOLLPART"))
		wait(0.2)
		slapglove(RandomPlayer.Character:FindFirstChild("DOLLPART"))
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		if _G.VoodooMastery == "Farm Voodoo" then
			wait(0.4)
			game:GetService("Players").LocalPlayer.Reset:FireServer()
			wait(0.3)
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		end
		if _G.VoodooMastery == "Farm Voodoo" then task.wait(7) end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Voodoo equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Voodoo Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Car Mastery", {
    Text = "Car Mastery",
    Values = {"Farm Exp (Clone)", "Farm Exp (Player)", "Upgrade All"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.CarMastery = Value
    end
})

Badge3Group:AddToggle("Auto Car Mastery", {
    Text = "Auto Car Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoCarMastery = Value
if CheckGlove() == "Car Keys" then
while _G.AutoCarMastery do
if _G.CarMastery == "Farm Exp (Clone)" then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					if game.Players.LocalPlayer.Character:FindFirstChild("CarKeysCar") then
						v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.CarKeysCar.Front:FindFirstChild("BumperHitbox").CFrame * CFrame.new(0, 10, 0)
						game.Players.LocalPlayer.Character.CarKeysCar:FindFirstChild("VehicleSeat").CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,55,0) * CFrame.Angles(math.rad(-90), 0, 0)
					end
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoCarMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoCarMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
elseif _G.CarMastery == "Farm Exp (Player)" then
if game.Players.LocalPlayer.Character:FindFirstChild("CarKeysCar") == nil then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
wait(0.3)
repeat task.wait() until _G.AutoCarMastery == false or game.Players.LocalPlayer.Character:FindFirstChild("CarKeysCar") and game.Players.LocalPlayer.Character.CarKeysCar:FindFirstChild("VehicleSeat")
wait(3)
else
if game.Players.LocalPlayer.Character:FindFirstChild("CarKeysCar") then
game.Players.LocalPlayer.Character.CarKeysCar.Front:FindFirstChild("BumperHitbox").Size = Vector3.new(25, 25, 25)
game.Players.LocalPlayer.Character.CarKeysCar.Front:FindFirstChild("BumperHitbox").CanCollide = false
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.CarKeysCar.Front:FindFirstChild("BumperHitbox").CFrame * CFrame.new(0, 10, 0)
game.Players.LocalPlayer.Character.CarKeysCar:FindFirstChild("VehicleSeat").CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,55,0) * CFrame.Angles(math.rad(-90), 0, 0)
end
end
end
end
end
end
elseif _G.CarMastery == "Upgrade All" then
for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
if v.Name == "CarKeysGUI" and v:FindFirstChild("CarKeysAttributes") then
for j, b in pairs(v.CarKeysAttributes:GetChildren()) do
if b.ClassName == "ImageLabel" then
game:GetService("ReplicatedStorage").CarKeysUpgrade:FireServer(b.Name)
wait(0.15)
end
end
end
end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Car Keys equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Car Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Defense Mastery", {
    Text = "Defense Mastery",
    Values = {"Slap 20 Player", "Slap Player From Cude (Walk)", "Slap Player From Cude (TP)", "Cude Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.DefenseMastery = Value
    end
})

Badge3Group:AddToggle("Auto Defense Mastery", {
    Text = "Auto Defense Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoDefenseMastery = Value
if CheckGlove() == "Defense" then
while _G.AutoDefenseMastery do
if _G.DefenseMastery == "Slap 20 Player" then
local Target, Huge = nil, math.huge
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
if (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < Huge then
Target = v.Character
end
end
end
end
end
if Target then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.HumanoidRootPart.CFrame)
task.wait(0.3)
slapglove(Target.HumanoidRootPart)
wait(0.25)
end
elseif _G.DefenseMastery:match("Slap Player From Cude") then
local Target = nil
if game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."ÅBarrier") then
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
if (v.Character.HumanoidRootPart.Position - game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."ÅBarrier").Position).Magnitude < 20 then
Target = v.Character
end
end
end
end
end
end
if Target then
if _G.DefenseMastery == "Slap Player From Cude (TP)" then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.HumanoidRootPart.CFrame)
wait(0.3)
slapglove(Target.HumanoidRootPart)
wait(0.3)
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."ÅBarrier").CFrame)
elseif _G.DefenseMastery == "Slap Player From Cude (Walk)" then
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v:IsA("Tool") and v:FindFirstChild("Glove") then
if (v:FindFirstChild("Glove").Position - Target.HumanoidRootPart.Position).Magnitude <= 5 then
game:GetService("VirtualUser"):ClickButton1(Vector2.new(200, 200))
else
game.Players.LocalPlayer.Character.Humanoid:MoveTo(Target.HumanoidRootPart.Position)
end
end
end
end
end
else
if game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."ÅBarrier") then
if _G.DefenseMastery == "Slap Player From Cude (TP)" then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."ÅBarrier").CFrame)
elseif _G.DefenseMastery == "Slap Player From Cude (Walk)" then
game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."ÅBarrier").Position)
end
end
end
elseif _G.DefenseMastery == "Cude Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
repeat task.wait() until _G.AutoDefenseMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 6
wait(0.22)
game:GetService("ReplicatedStorage").Barrier:FireServer(1)
wait(0.05)
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
task.wait(3.5)
end
end
end
end
end
end
end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Defense equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Defense Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Tycoon Mastery", {
    Text = "Tycoon Mastery",
    Values = {"15k Point Die", "Defense Tycoon (Walk)", "Defense Tycoon (TP)", "Kill Player (Tycoon God)"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.TycoonMastery = Value
    end
})

Badge3Group:AddToggle("Auto Tycoon Mastery", {
    Text = "Auto Tycoon Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoTycoonMastery = Value
if CheckGlove() == "Tycoon" then
while _G.AutoTycoonMastery do
if _G.TycoonMastery == "15k Point Die" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") < 15000 then
for _,v in pairs(game.Workspace:GetChildren()) do
if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("Click") then
fireclickdetector(v.Click.ClickDetector, 0)
fireclickdetector(v.Click.ClickDetector, 1)
end
end
GuiTrackUpdate(true, {
	Text = "Tycoon Your Point\n"..game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):GetAttribute("LastCount").." / 15000",
	Size = game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):GetAttribute("LastCount") / 15000
})
elseif game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) == nil then
game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(17894, -26.257728576660156, -3579.11279296875, 0.9996822476387024, -1.1041408759515647e-10, 0.02520809881389141, 2.8899729831444176e-10, 1, -7.080715569429685e-09, -0.02520809881389141, 7.085750652890965e-09, 0.9996822476387024))
spawn(function()
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
until (game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") >= 15000) or (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0)
end)
wait(1)
end
if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") >= 15000 then
GuiTrackUpdate(false)
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
end
end
elseif _G.TycoonMastery:match("Defense Tycoon") then
if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) then
local Target = nil
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
if (v.Character.HumanoidRootPart.Position - game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):FindFirstChild("End").Position).Magnitude < 30 then
Target = v.Character
end
if _G.TycoonMastery == "Defense Tycoon (Walk)" then
if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):FindFirstChild("End").Position).Magnitude > 45 then
local DstancePlayer = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
if DstancePlayer < 75 then
Target = v.Character
end
end
end
end
end
end
end
if Target then
if _G.TycoonMastery == "Defense Tycoon (Walk)" then
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v:IsA("Tool") and v:FindFirstChild("Glove") then
if (v:FindFirstChild("Glove").Position - Target.HumanoidRootPart.Position).Magnitude <= 5 then
game:GetService("VirtualUser"):ClickButton1(Vector2.new(200, 200))
else
game.Players.LocalPlayer.Character.Humanoid:MoveTo(Target.HumanoidRootPart.Position)
end
end
end
end
elseif _G.TycoonMastery == "Defense Tycoon (TP)" then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(Target.HumanoidRootPart.CFrame)
wait(0.3)
for i = 1, 1000 do
slapglove(Target.HumanoidRootPart)
end
end
else
if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):FindFirstChild("End") then
if _G.TycoonMastery == "Defense Tycoon (Walk)" then
game.Players.LocalPlayer.Character.Humanoid:MoveTo(game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):FindFirstChild("End").Position)
elseif _G.TycoonMastery == "Defense Tycoon (TP)" then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):FindFirstChild("End").CFrame)
end
end
end
end
elseif _G.TycoonMastery == "Kill Player (Tycoon God)" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") < 5000 then
for _,v in pairs(game.Workspace:GetChildren()) do
if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("Click") then
fireclickdetector(v.Click.ClickDetector, 0)
fireclickdetector(v.Click.ClickDetector, 1)
end
end
GuiTrackUpdate(true, {
	Text = "Tycoon Your Point\n"..game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):GetAttribute("LastCount").." / 5000",
	Size = game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):GetAttribute("LastCount") / 5000
})
elseif game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) == nil then
game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(17894, -26.257728576660156, -3579.11279296875, 0.9996822476387024, -1.1041408759515647e-10, 0.02520809881389141, 2.8899729831444176e-10, 1, -7.080715569429685e-09, -0.02520809881389141, 7.085750652890965e-09, 0.9996822476387024))
spawn(function()
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
until (game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") >= 5000) or (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0)
end)
wait(1)
end
if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") >= 5000 then
GuiTrackUpdate(false)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v.Character:FindFirstChild("HumanoidRootPart").CFrame)
repeat task.wait() until _G.AutoTycoonMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 6
wait(0.35)
slapglove(v.Character:FindFirstChild("HumanoidRootPart"))
wait(0.05)
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
task.wait(7)
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
task.wait()
end
GuiTrackUpdate(false)
elseif Value == true then
Notification("You don't have Tycoon equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Tycoon Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Phase Mastery", {
    Text = "Phase Mastery",
    Values = {"200 Second Island", "Slap + Ability", "Ability + Slap (2 Sec)"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PhaceMastery = Value
    end
})

Badge3Group:AddToggle("Auto Phase Mastery", {
    Text = "Auto Phase Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoPhaseMastery = Value
if CheckGlove() == "Phase" then
while _G.AutoPhaseMastery do
if _G.PhaceMastery == "200 Second Island" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if not _G.PlaceTp then
_G.PlaceTp = {
	["Island 1"] = workspace.Arena.island4:FindFirstChild("moyai").CFrame * CFrame.new(0, 0, -30),
	["Island 2"] = game.workspace:FindFirstChild("Origo").CFrame * CFrame.new(0, -5, 0),
	["Island 3"] = workspace.Arena["Sakura Tree"]["petal pile"].CFrame * CFrame.new(0, 5, 0),
	["Island 4"] = workspace.Arena.island2["Sakura Tree"]["petal pile"].CFrame * CFrame.new(0, 5, 0),
	["Island 5"] = workspace.Arena.island3["Sakura Tree"]["petal pile"].CFrame * CFrame.new(0, 5, 0),
	["Island 6"] = workspace.Arena.island5:FindFirstChild("Union").CFrame * CFrame.new(0, 3.25, 0),
	["Island 7"] = workspace.Arena.CannonIsland.Cannon:FindFirstChild("Base").CFrame * CFrame.new(0, 0, 35),
	["Island 8"] = workspace.Arena.Fort:FindFirstChild("Floor").CFrame * CFrame.new(0, 5, 0)
}
end
for i, v in pairs(_G.PlaceTp) do
if _G.AutoPhaseMastery == true then
game:GetService("ReplicatedStorage").PhaseA:FireServer()
wait(0.3)
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v)
end
until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BlackheartREAL") == nil
task.wait(1)
end
end
end
elseif _G.PhaceMastery:match("Ability") then
local RandomPlayer = MasteryPlayers(CheckGlove(), true)
if RandomPlayer then
	if _G.AutoPhaseMastery == true then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character.HumanoidRootPart.CFrame)
		repeat task.wait() until _G.AutoPhaseMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character.HumanoidRootPart.Position).Magnitude < 6
		wait(0.35)
		if _G.PhaceMastery == "Slap + Ability" then
			slapglove(RandomPlayer.Character.HumanoidRootPart)
			game:GetService("ReplicatedStorage").PhaseA:FireServer()
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
			wait(0.2)
			repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BlackheartREAL") == nil
		elseif _G.PhaceMastery == "Ability + Slap (2 Sec)" then
			game:GetService("ReplicatedStorage").PhaseA:FireServer()
			task.wait(0.2)
			repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BlackheartREAL") == nil
			task.wait(0.1)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v.Character:FindFirstChild("HumanoidRootPart").CFrame)
			repeat task.wait() until _G.AutoPhaseMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character.HumanoidRootPart.Position).Magnitude < 6
			task.wait(0.25)
			slapglove(RandomPlayer.Character.HumanoidRootPart)
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
		end
		task.wait(3)
	end
end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Phase equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Phase Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Shard Mastery", {
    Text = "Shard Mastery",
    Values = {"Aimbot Overkill", "Get Slap", "Aimbot Character"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ShardMastery = Value
    end
})

Badge3Group:AddToggle("Auto Shard Mastery", {
    Text = "Auto Shard Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoShardMastery = Value
if CheckGlove() == "Shard" then
while _G.AutoShardMastery do
if _G.ShardMastery == "Aimbot Overkill" then
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.leaderstats.Glove.Value == "OVERKILL" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled").Value == false then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(v.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, v.Character.HumanoidRootPart.Position.Z))
end
end
end
end
end
elseif _G.ShardMastery == "Get Slap" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.6)
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoShardMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				if v:FindFirstChild("Body") then
					slapglove(v:FindFirstChild("Body"))
				end
			until v:FindFirstChild("Body") == nil or _G.AutoShardMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoShardMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
elseif _G.ShardMastery == "Aimbot Character" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local Distance, TargetCharacter = math.huge, nil
for i,v in pairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
if v.Character.Head:FindFirstChild("UnoReverseCard") == nil then
local DistancePlayer = (game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character.HumanoidRootPart.Position).Magnitude
if DistancePlayer < Distance then
Distance, TargetCharacter = DistancePlayer, v
end
end
end
end
end
if TargetCharacter then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled").Value == false then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(TargetCharacter.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y, TargetCharacter.Character.HumanoidRootPart.Position.Z))
end
end
end
end
task.wait()
end
elseif _G.AutoShardMastery == true then
Notification("You don't have Shard equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Shard Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Space Mastery", {
    Text = "Space Mastery",
    Values = {"Place Time", "Complete On Island Slapple"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.SpaceMastery = Value
    end
})

Badge3Group:AddToggle("Auto Space Mastery", {
    Text = "Auto Space Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoSpaceMastery = Value
if CheckGlove() == "Space" then
while _G.AutoSpaceMastery do
if _G.SpaceMastery == "Place Time" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
task.wait(1)
game:GetService("ReplicatedStorage").ZeroGSound:FireServer()
game:GetService("Players").LocalPlayer.Reset:FireServer()
repeat wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
wait(0.3)
elseif _G.SpaceMastery == "Complete On Island Slapple" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
repeat task.wait() until game.Players.LocalPlayer.Character
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
end
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
wait(0.25)
for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
            if v.ClassName == "ProximityPrompt" then
                fireproximityprompt(v)
            end
        end
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled") and game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == true
wait(0.3)
if game.Players.LocalPlayer.Backpack:FindFirstChild("Space") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Space").Parent = game.Players.LocalPlayer.Character
end
wait(0.2)
game:GetService("ReplicatedStorage").ZeroGSound:FireServer()
wait(1)
repeat task.wait()
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v.ClassName == "Part" and v.Name ~= "Humanoid" then
v.CFrame = game.workspace.Arena.island5.Union.CFrame * CFrame.new(0,3.25,0)
end
end
end
until game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled") and game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == false
wait(1)
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.workspace.Arena.island5.Union.CFrame * CFrame.new(0,3.25,0))
task.wait(6)
end
task.wait()
end
elseif _G.AutoSpaceMastery == true then
Notification("You don't have Space equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Space Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Flash Mastery", {
    Text = "Flash Mastery",
    Values = {"Time + Slap", "Ambush"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.FlashMastery = Value
    end
})

Badge3Group:AddToggle("Auto Flash Mastery", {
    Text = "Auto Flash Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoFlashMastery = Value
if CheckGlove() == "Flash" then
while _G.AutoFlashMastery do
if _G.FlashMastery == "Time + Slap" then
for i = 1, 9000 do
spawn(function() game:GetService("ReplicatedStorage").FlashTeleport:FireServer() end)
end
elseif _G.FlashMastery == "Ambush" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.6)
	game:GetService("ReplicatedStorage").FlashTeleport:FireServer()
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			spawn(function()
				repeat
					if CheckGlove() == "Flash" and v:FindFirstChild("HumanoidRootPart") then
						game:GetService("ReplicatedStorage").FlashTeleport:FireServer()
					end
					task.wait(2.3)
				until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoFlashMastery == false
			end)
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoFlashMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				if v:FindFirstChild("Body") then
					slapglove(v:FindFirstChild("Body"))
				end
			until v:FindFirstChild("Body") == nil or _G.AutoFlashMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoFlashMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
end
task.wait()
end
elseif _G.AutoFlashMastery == true then
Notification("You don't have Flash equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Flash Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Fort Mastery", {
    Text = "Fort Mastery",
    Values = {"Build", "Build + Break"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.FortMastery = Value
    end
})

Badge3Group:AddToggle("Auto Fort Mastery", {
    Text = "Auto Fort Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoFortMastery = Value
if CheckGlove() == "Fort" then
spawn(function()
	while _G.AutoFortMastery do
		if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
			game:GetService("ReplicatedStorage").Fortlol:FireServer()
		end
		wait(3.4)
	end
end)
while _G.AutoFortMastery do
if _G.FortMastery == "Build + Break" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
end
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
end
if game.Players.LocalPlayer.Backpack:FindFirstChild("Fort") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Fort)
end
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
for i, v in pairs(game.Workspace:GetChildren()) do
if v.Name == "Part" and v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound") and 200 >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude then
if v.CanCollide == true then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(v.CFrame)
task.wait(0.05)
if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Ragdolled") and game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == false then
game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = -99})
end
end
end
end
until _G.AutoFortMastery == false or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
end
elseif _G.FortMastery == "Build" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
end
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
end
if game.Players.LocalPlayer.Backpack:FindFirstChild("Fort") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Fort)
end
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
until _G.AutoFortMastery == false or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
end
end
task.wait()
end
elseif _G.AutoFortMastery == true then
Notification("You don't have Fort equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Fort Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Rob Mastery", {
    Text = "Rob Mastery",
    Values = {"Studs", "Get Kill"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.RobMastery = Value
    end
})

local TweenRob = 1
Badge3Group:AddToggle("Auto Rob Mastery", {
    Text = "Auto Rob Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoRobMastery = Value
if CheckGlove() == "rob" then
while _G.AutoRobMastery do
if _G.RobMastery == "Studs" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
local TweenPlayRob = {
	CFrame.new(9762, 38, 10237),
	CFrame.new(9763, 38, 9761),
	CFrame.new(10241, 38, 9758),
	CFrame.new(10236, 38, 10236)
}
function NextTweenRob()
    local RobFarm = TweenPlayRob[TweenRob]
    TweenRob = TweenRob + 1
    if TweenRob > #TweenPlayRob then
        TweenRob = 1
    end
    return RobFarm
end
game:GetService("ReplicatedStorage").rob:FireServer()
for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
	if v.Name == "whiteframe" then
		v:Destroy()
	end
end
repeat task.wait() until _G.AutoRobMastery == false or game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 and game.Players.LocalPlayer.Character:FindFirstChild("Head").Transparency == 1
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	local TweenRobTag = NextTweenRob()
		if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(TweenRobTag)
		end
	end
end
elseif _G.RobMastery == "Get Kill" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	CreateFreezeBV()
	local function AbilityRob()
		game:GetService("ReplicatedStorage").rob:FireServer()
		for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
			if v.Name == "whiteframe" then
				v:Destroy()
			end
		end
	end
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				AbilityRob()
				if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character.Head.Transparency >= 1 then
					if v:FindFirstChild("HumanoidRootPart") then
						v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					end
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or (v:FindFirstChild("Head") and v.Head.Transparency >= 1) or _G.AutoRobMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				AbilityRob()
				if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character.Head.Transparency >= 1 then
					if v:FindFirstChild("Body") then
						v:FindFirstChild("Body").CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					end
				end
			until v:FindFirstChild("Body") == nil or _G.AutoRobMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoRobMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
end
task.wait()
end
elseif _G.AutoRobMastery == true then
Notification("You don't have Rob equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Rob Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Cloud Mastery", {
    Text = "Cloud Mastery",
    Values = {"Studs (200k Fly)", "Afk (200 Min)", "Pickup Player (100 Player)"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.CloudMastery = Value
    end
})

local TweenGet = 1
_G.GetPlayerSit = {}
Badge3Group:AddToggle("Auto Cloud Mastery", {
    Text = "Auto Cloud Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoCloudMastery = Value
if CheckGlove() == "Cloud" then
while _G.AutoCloudMastery do
if _G.CloudMastery == "Studs (200k Fly)" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
local GetCloudYour = couldfound()
local TweenPlay = {
	CFrame.new(730, 128, -600),
	CFrame.new(-680, 22, 500)
}
function NextTween()
    local TweenNextGo = TweenPlay[TweenGet]
    TweenGet = TweenGet + 1
    if TweenGet > #TweenPlay then
        TweenGet = 1
    end
    return TweenNextGo
end
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.Sit == true then
    if GetCloudYour and GetCloudYour:FindFirstChild("VehicleSeat") then
        VectorTween({Part = GetCloudYour.VehicleSeat, Place = NextTween().Position, Speed = 80})
    end
elseif game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.Sit == false then
    if GetCloudYour and GetCloudYour:FindFirstChild("VehicleSeat") then
        VectorTween({Place = GetCloudYour.VehicleSeat.Position, Speed = 80})
    end
end
end
elseif _G.CloudMastery == "Afk (200 Min)" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,2,35)
wait(0.3)
game:GetService("ReplicatedStorage").CloudAbility:FireServer()
fireclickdetector(workspace.Lobby.Diamond.ClickDetector)
wait(0.2)
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace.Lobby.Teleport1.CFrame)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
wait(0.3)
local GetCloudYour = couldfound()
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.Sit == false then
    if GetCloudYour and GetCloudYour:FindFirstChild("VehicleSeat") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetCloudYour.VehicleSeat.CFrame
    end
end
until game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.Sit == true
task.wait(1)
if GetCloudYour and GetCloudYour:FindFirstChild("VehicleSeat") then
    VectorTween({Part = GetCloudYour.VehicleSeat, Place = Vector3.new(CFrame.new(245, 129, -91)), Speed = 80})
end
wait(0.3)
game:GetService("ReplicatedStorage").Rockmode:FireServer()
Toggles["Anti Afk"]:SetValue(true)
end
elseif _G.CloudMastery == "Pickup Player (100 Player)" then
local GetCloudYour = couldfound()
local players = game.Players:GetChildren()
local RandomPlayer = players[math.random(1, #players)]
if _G.GetPlayerSit[RandomPlayer] then return end
if RandomPlayer ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character then
if RandomPlayer.Character:FindFirstChild("entered") and RandomPlayer.Character:FindFirstChild("HumanoidRootPart") and RandomPlayer.Character:FindFirstChild("Humanoid") and RandomPlayer.Character:FindFirstChild("stevebody") == nil and RandomPlayer.Character:FindFirstChild("rock") == nil and RandomPlayer.Character.Humanoid.Sit == false and RandomPlayer.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and RandomPlayer.Character.Ragdolled.Value == false and RandomPlayer.Character:FindFirstChild("Mirage") == nil then
repeat task.wait()
if GetCloudYour and GetCloudYour:FindFirstChild("Seat") then
    RandomPlayer.Character.HumanoidRootPart.CFrame = GetCloudYour.Seat.CFrame
end
until RandomPlayer.Character.Humanoid.Sit == true
if not _G.GetPlayerSit[RandomPlayer] then
_G.GetPlayerSit[RandomPlayer] = true
end
if RandomPlayer.Character.Humanoid.Sit == true then
slapglove(RandomPlayer.Character.HumanoidRootPart)
end
task.wait(0.5)
end 
end
end
task.wait()
end
elseif _G.AutoCloudMastery == true then
Notification("You don't have Cloud equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Cloud Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Wormhole Mastery", {
    Text = "Wormhole Mastery",
    Values = {"Place", "Teleport Time", "Ambush Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.WormholeMastery = Value
    end
})

Badge3Group:AddToggle("Auto Wormhole Mastery", {
    Text = "Auto Wormhole Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoWormholeMastery = Value
if CheckGlove() == "Wormhole" then
while _G.AutoWormholeMastery do
if _G.WormholeMastery == "Place" then
game:GetService("ReplicatedStorage").WormholePlace:FireServer()
elseif _G.WormholeMastery == "Teleport Time" then
game:GetService("ReplicatedStorage").WormholeTP:FireServer(CFrame.new(-57.48336410522461, -4.672852516174316, 67.94768524169922, 0.5769212245941162, 0.0005397791974246502, 0.8167997002601624, 1.468715993269143e-07, 0.9999997615814209, -0.0006609398988075554, -0.8167998790740967, 0.00038141835830174387, 0.5769210457801819))
elseif _G.WormholeMastery == "Ambush Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	game:GetService("ReplicatedStorage").WormholeTP:FireServer(CFrame.new(-57.48336410522461, -4.672852516174316, 67.94768524169922, 0.5769212245941162, 0.0005397791974246502, 0.8167997002601624, 1.468715993269143e-07, 0.9999997615814209, -0.0006609398988075554, -0.8167998790740967, 0.00038141835830174387, 0.5769210457801819))
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
					game:GetService("ReplicatedStorage").WormholeTP:FireServer(CFrame.new(-57.48336410522461, -4.672852516174316, 67.94768524169922, 0.5769212245941162, 0.0005397791974246502, 0.8167997002601624, 1.468715993269143e-07, 0.9999997615814209, -0.0006609398988075554, -0.8167998790740967, 0.00038141835830174387, 0.5769210457801819))
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoWormholeMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				if v:FindFirstChild("Body") then
					slapglove(v:FindFirstChild("Body"))
				end
			until v:FindFirstChild("Body") == nil or _G.AutoWormholeMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoWormholeMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
end
task.wait()
end
elseif _G.AutoWormholeMastery == true then
Notification("You don't have Wormhole equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Wormhole Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Run Mastery", {
    Text = "Run Mastery",
    Values = {"Esp Player", "Auto Kill Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.RunMastery = Value
    end
})

Badge3Group:AddToggle("Auto Run Mastery", {
    Text = "Auto Run Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoRunMastery = Value
if CheckGlove() == "Run" then
if _G.AutoRunMastery == false then
if _G.RunMastery == "Esp Player" then
for i,v in ipairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("InLabyrinth") then
if v.Character.HumanoidRootPart:FindFirstChild("RunEsp") then
v.Character.HumanoidRootPart.RunEsp:Destroy()
end
end
end
end
end
while _G.AutoRunMastery do
if _G.RunMastery == "Esp Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("InLabyrinth") then
for i,v in ipairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("InLabyrinth") then
if v.Character.HumanoidRootPart:FindFirstChild("RunEsp") == nil then
RunEsp = Instance.new("BillboardGui", v.Character.HumanoidRootPart)
RunEsp.Adornee = v.Character.HumanoidRootPart
RunEsp.Name = "RunEsp"
RunEsp.Size = UDim2.new(0, 100, 0, 150)
RunEsp.AlwaysOnTop = true
RunEspText = Instance.new("TextLabel", RunEsp)
RunEspText.BackgroundTransparency = 1
RunEspText.Font = Enum.Font.SourceSansBold
RunEspText.Size = UDim2.new(0, 100, 0, 100)
RunEspText.TextSize = 15
RunEspText.TextStrokeTransparency = 0.5
RunEspText.Text = "Target Player"
end
elseif v.Character and v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("InLabyrinth") == nil then
if v.Character.HumanoidRootPart:FindFirstChild("RunEsp") then
v.Character.HumanoidRootPart.RunEsp:Destroy()
end
end
end
end
elseif _G.RunMastery == "Auto Kill Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("InLabyrinth") then
for i,v in ipairs(game.Players:GetChildren()) do
if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("InLabyrinth") then
v.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
end
end
end
task.wait()
end
elseif _G.AutoRunMastery == true then
Notification("You don't have Run equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Run Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Glovel Mastery", {
    Text = "Glovel Mastery",
    Values = {"Dip (350 Time)", "Land Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.GlovelMastery = Value
    end
})

Badge3Group:AddToggle("Auto Glovel Mastery", {
    Text = "Auto Glovel Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoGlovelMastery = Value
if CheckGlove() == "Glovel" then
while _G.AutoGlovelMastery do
if _G.GlovelMastery == "Dip (350 Time)" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
wait(0.3)
for i = 1, 400 do
spawn(function()
	game:GetService("ReplicatedStorage").GlovelFunc:InvokeServer()
end)
task.wait(0.05)
end
wait(0.4)
game:GetService("ReplicatedStorage").GlovelCancel:FireServer()
wait(0.8)
elseif _G.GlovelMastery == "Land Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoGlovelMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				if v:FindFirstChild("Body") then
					slapglove(v:FindFirstChild("Body"))
				end
			until v:FindFirstChild("Body") == nil or _G.AutoGlovelMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoGlovelMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
end
task.wait()
end
elseif _G.AutoGlovelMastery == true then
Notification("You don't have Glovel equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Glovel Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddDropdown("Bomb Mastery", {
    Text = "Bomb Mastery",
    Values = {"Throw Bomb", "Snipe Bomb + Void", "Void Kill"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BombMastery = Value
    end
})

Badge3Group:AddToggle("Auto Bomb Mastery", {
    Text = "Auto Bomb Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoBombMastery = Value
if CheckGlove() == "Bomb" then
while _G.AutoBombMastery do
if _G.BombMastery == "Throw Bomb" then
for i = 1, 1000 do
spawn(function()
	game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
	game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
end)
end
elseif _G.BombMastery == "Snipe Bomb + Void" then
repeat task.wait() until game.Players.LocalPlayer.Character
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Backpack:FindFirstChild("Bomb") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Bomb)
end
task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
wait(0.4)
game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
task.delay(12.5, function()
	game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
end)
repeat task.wait() 
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
end
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
end
until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_bømb")
wait(0.5)
repeat task.wait() 
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_bømb") then
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_bømb").CFrame)
end
until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_bømb") == nil
task.wait(0.75)
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER2.CFrame)
until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
elseif _G.BombMastery == "Void Kill" then
repeat task.wait() until game.Players.LocalPlayer.Character
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
wait(0.3)
game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
repeat task.wait() 
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
end
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
end
until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_bømb")
task.wait(0.2)
game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
task.wait(0.75)
repeat task.wait() until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_bømb") == nil
repeat task.wait()
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER2.CFrame)
until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end
task.wait()
end
elseif _G.AutoBombMastery == true then
Notification("You don't have Bomb equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Bomb Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Stalker Mastery", {
    Text = "Auto Stalker Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoStalkerMastery = Value
if not _G.AutoStalkerMastery then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "Stalker" then
while _G.AutoStalkerMastery do
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
wait(0.5)
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.leaderstats.Slaps.Value >= 666 then
	fireclickdetector(workspace.Lobby.Ghost.ClickDetector)
	game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
	fireclickdetector(workspace.Lobby["Stalker"].ClickDetector)
	task.wait(1)
	for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = 0
		end
	end
end
wait(0.2)
repeat task.wait()
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
end
wait(0.35)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
if game.Players.LocalPlayer.Character:FindFirstChild("Stalker") then
game.Players.LocalPlayer.Character:FindFirstChild("Stalker").Parent = game.Players.LocalPlayer.Backpack
end
wait(0.3)
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
	repeat task.wait() until _G.AutoStalkerMastery == false or game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil or game.Players.LocalPlayer.Character:FindFirstChild("ReadyToBurst")
	local RandomPlayer = players[math.random(#players)]
	CreateFreezeBV()
	game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("Head").CFrame * CFrame.new(0, 7, 0))
	repeat task.wait() until _G.AutoStalkerMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
	wait(0.3)
	for i = 1, 3 do
		slapglove(RandomPlayer.Character:FindFirstChild("Head"))
		wait(0.2)
	end
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
	task.wait(3)
end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Stalker equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Stalker Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Rage Mastery", {
    Text = "Auto Rage Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoRageMastery = Value
if CheckGlove() == "Rage" then
while _G.AutoRageMastery do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	spawn(function()
		for _,v in ipairs(workspace:GetChildren()) do
			if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
				repeat task.wait()
					if v:FindFirstChild("HumanoidRootPart") then
						slapglove(v:FindFirstChild("HumanoidRootPart"))
					end
				until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoRageMastery == false
			end
			if v.Name == "Imp" and v:FindFirstChild("Body") then
				repeat task.wait()
					if v:FindFirstChild("Body") then
						slapglove(v:FindFirstChild("Body"))
					end
				until v:FindFirstChild("Body") == nil or _G.AutoRageMastery == false
			end
		end
	end)
	repeat task.wait() until game:GetService("Players").LocalPlayer.Character and (game:GetService("Players").LocalPlayer.Character:GetAttribute("rage_percent") or 0) >= 53
	game:GetService("ReplicatedStorage"):WaitForChild("GRRRRR"):FireServer("frenzy")
	repeat task.wait() until game:GetService("Players").LocalPlayer.Character and (game:GetService("Players").LocalPlayer.Character:GetAttribute("rage_percent") or 0) <= 49
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoRageMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
task.wait()
end
elseif _G.AutoRageMastery == true then
Notification("You don't have Rage equipped, or you have 19k+ slap", _G.TimeNotify)
wait(0.05)
Toggles["Auto Rage Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Stick Mastery", {
    Text = "Auto Stick Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoStickMastery = Value
if CheckGlove() == "Stick" then
while _G.AutoStickMastery do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
				end
			until v:FindFirstChild("HumanoidRootPart") == nil or _G.AutoGlovelMastery == false
		end
		if v.Name == "Imp" and v:FindFirstChild("Body") then
			repeat task.wait()
				if v:FindFirstChild("Body") then
					slapglove(v:FindFirstChild("Body"))
				end
			until v:FindFirstChild("Body") == nil or _G.AutoGlovelMastery == false
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoGlovelMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
task.wait()
end
elseif Value == true then
Notification("You don't have Stick equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Stick Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Dice Mastery", {
    Text = "Auto Dice Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoDiceMastery = Value
if CheckGlove() == "Dice" then
while _G.AutoDiceMastery do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local RandomPlayer = MasteryPlayers(CheckGlove(), true)
	if RandomPlayer then
		CreateFreezeBV()
		for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(RandomPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, -6, 5))
		repeat task.wait() until _G.AutoDiceMastery == false or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - RandomPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 8
		slapglove(RandomPlayer.Character.Head)
		wait(0.1)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
		task.wait(0.7)
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Dice equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Dice Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Booster Mastery", {
    Text = "Auto Booster Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoBoosterMastery = Value
if CheckGlove() == "Booster" then
while _G.AutoBoosterMastery do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	local Gloveold = CheckGlove()
	SpawnFarmMastery(true)
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	for _,v in ipairs(workspace:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Name:find("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
			for o = 1, 35 do
				if v:FindFirstChild("HumanoidRootPart") then
					slapglove(v:FindFirstChild("HumanoidRootPart"))
				end
				task.wait()
			end
		end
	end
	game:GetService("Players").LocalPlayer.Reset:FireServer()
	repeat task.wait() until not _G.AutoBoosterMastery or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	equipglove(Gloveold)
end
task.wait()
end
elseif _G.AutoBoosterMastery == true then
Notification("You don't have Booster equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Booster Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Killstreak Mastery", {
    Text = "Auto Killstreak Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoKillstreakMastery = Value
if Value == false then
	CreateFreezeBV({Remove = true})
end
if CheckGlove() == "Killstreak" then
while _G.AutoKillstreakMastery do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
	CreateFreezeBV()
	local target = players[math.random(#players)]
	repeat task.wait()
	if target.Character.Ragdolled.Value == false then
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, -10, 0))
		task.wait(0.25)
		game.ReplicatedStorage.KSHit:FireServer(target.Character:FindFirstChild("HumanoidRootPart"))
		game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
		task.wait(0.85)
	end
	until _G.AutoKillstreakMastery ~= true or (target.Character:FindFirstChild("HumanoidRootPart") and target.Character.HumanoidRootPart.Position.Y < -10) or (target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health <= 0)
end
task.wait()
end
elseif _G.AutoKillstreakMastery == true then
Notification("You don't have Killstreak equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Killstreak Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Spin Mastery", {
    Text = "Auto Spin Mastery",
    Default = false, 
    Callback = function(Value) 
_G.AutoSpinMastery = Value
if CheckGlove() == "spin" then
while _G.AutoSpinMastery do
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
end
until game.Players.LocalPlayer.Character:FindFirstChild("entered")
repeat task.wait()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace.Lobby.Teleport1, 1)
end
game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(workspace["SafeBox"].CFrame * CFrame.new(0,5,0))
until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0
end
task.wait()
end
elseif _G.AutoSpinMastery == true then
Notification("You don't have Spin equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Spin Mastery"]:SetValue(false)
end
    end
})

Badge3Group:AddToggle("Auto Brick Mastery", {
    Text = "Auto Big Brick",
    Default = false, 
    Callback = function(Value) 
_G.AutoBrickMastery = Value
if CheckGlove() == "Brick" then
while _G.AutoBrickMastery do
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == "Union" then
v.Size = Vector3.new(20, 1, 20)
                    end
                end
task.wait()
end
elseif _G.AutoBrickMastery == true then
Notification("You don't have Brick equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Brick Mastery"]:SetValue(false)
end
    end
})

local Badge4Group = TabBoxMastery:AddTab("Mastery Help")

table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
	pcall(function()
		Players1 = (_G.HelpPlayer1 and _G.HelpPlayer1.Character) or nil
		root1 = (Players1 and Players1:FindFirstChild("HumanoidRootPart")) or nil
		head1 = (Players1 and Players1:FindFirstChild("Head")) or nil
		torso1 = (Players1 and Players1:FindFirstChild("Torso")) or nil
		hum1 = (Players1 and Players1:FindFirstChild("Humanoid")) or nil
		
		Players2 = game.Players.LocalPlayer.Character or nil
		root = (Players2 and Players2:FindFirstChild("HumanoidRootPart")) or nil
		head = (Players2 and Players2:FindFirstChild("Head")) or nil
		hum = (Players2 and Players2:FindFirstChild("Humanoid")) or nil
		
		PlayersMain = (_G.HelpPlayer2 and _G.HelpPlayer2.Character) or nil
		rootmain = (PlayersMain and PlayersMain:FindFirstChild("HumanoidRootPart")) or nil
		headmain = (PlayersMain and PlayersMain:FindFirstChild("Head")) or nil
		hummain = (PlayersMain and PlayersMain:FindFirstChild("Humanoid")) or nil
	end)
end))

function HelpMasteryJoin(data)
	data = data or {}
	data.NoCF = data.NoCF or false
	data.CloneCF = data.CloneCF or CFrame.new(0,5,0)
	data.MainCF = data.MainCF or CFrame.new(0,5,-3)
	data.PlaceCF = data.PlaceCF or workspace["SafeBox"].S5
	
	if Players2 then
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if Players2 and game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()) then
			game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()).Parent = Players2
		end
		if not data.NoCF then
			if Players2 and Players2:FindFirstChild("entered") then
				root.CFrame = data.PlaceCF.CFrame * (_G.Players1CloneHelp and data.CloneCF or data.MainCF)
			end
		end
		if Players2 and Players2:FindFirstChild("entered") == nil then
			root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
		end
	end
end

Badge4Group:AddLabel("[<font color=\"rgb(73, 230, 133)\">How to use mastery help</font>] The main account inputs the clone account, and the clone account inputs the main account and clone accounts. Enable help enabled for both accounts, and the main account can choose to have the clone account help, Otherwise, both accounts need to have the correct settings enabled for cloning, and it will help you.", true)
CloneAccHelp = Badge4Group:AddInput("Players", {
    Text = "Clone Account",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.HelpPlayer1 = FoundPlr(Value, true)
    end
})

Badge4Group:AddInput("Players1", {
    Text = "Main Account",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.HelpPlayer2 = FoundPlr(Value, true)
    end
})

Badge4Group:AddToggle("Enabled Players 1 Help", {
    Text = "Enabled Account Clone Help",
    Default = false, 
    Callback = function(Value) 
_G.Players1CloneHelp = Value
if CloneAccHelp then
	CloneAccHelp:SetVisible(not _G.Players1CloneHelp)
end
    end
})

Badge4Group:AddDropdown("Acrobat Mastery", {
    Text = "Acrobat Mastery",
    Values = {"Roll + Slap", "Slap + Roll + Slap"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AcrobatMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Acrobat", {
    Text = "Auto Mastery Acrobat",
    Default = false, 
    Callback = function(Value) 
_G.AutoAcrobatMasteryHelp = Value
if not _G.AutoAcrobatMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Acrobat" then
spawn(function()
	while _G.AutoAcrobatMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if _G.AcrobatMasteryHelp == "Roll + Slap" then
					if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
						slapglove(root1)
					end
					game:GetService("ReplicatedStorage"):WaitForChild("Roll"):FireServer()
					wait(0.2)
					repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(1)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoAcrobatMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,5),
})
if not _G.Players1CloneHelp then
	if Players1 and Players1:FindFirstChild("entered") and root1 and root and (root.Position - root1.Position).Magnitude <= 150 then
		if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if _G.AcrobatMasteryHelp == "Slap + Roll + Slap" then
				slapglove(root1)
				wait(0.2)
				repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				game:GetService("ReplicatedStorage"):WaitForChild("Roll"):FireServer()
				wait(0.3)
				slapglove(root1)
				wait(1.7)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Acrobat equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Acrobat"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Tinkerer Mastery", {
    Text = "Tinkerer Mastery",
    Values = {"Bomb Clone", "Bomb + Slap Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.TinkeverMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Tinkerer", {
    Text = "Auto Mastery Tinkerer",
    Default = false, 
    Callback = function(Value) 
_G.AutoTinkeverMasteryHelp = Value
if not _G.AutoTinkeverMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Tinkerer" then
spawn(function()
	while _G.AutoTinkeverMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
					game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer("E_ABILITY")
					task.wait(3.7)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoTinkeverMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,-3),
	MainCF = CFrame.new(0,5,0),
	PlaceCF = workspace.SafeBoxSpace
})
if not _G.Players1CloneHelp then
	if Players1 and Players1:FindFirstChild("entered") and root1 and root and (root.Position - root1.Position).Magnitude <= 150 then
		if _G.TinkeverMasteryHelp == "Bomb + Slap Clone" then
			if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value then
				wait(0.5)
				repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				wait(0.3)
				for i = 1, 10 do
					slapglove(root1)
					task.wait(0.85)
				end
				repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.35)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Tinkerer equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Tinkerer"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Bubble Mastery", {
    Text = "Bubble Mastery",
    Values = {"Bubble + Slap Clone", "Bubble Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BubbleMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Bubble", {
    Text = "Auto Mastery Bubble",
    Default = false, 
    Callback = function(Value) 
_G.AutoBubbleMasteryHelp = Value
if not _G.AutoBubbleMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Bubble" then
function BubbleChild()
	for i,v in pairs(workspace:GetChildren()) do
        if v.Name == "BubbleObject" and (root.Position - v.Position).Magnitude <= 200 then
            return v
        end
	end
	return nil
end
spawn(function()
	while _G.AutoBubbleMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if _G.BubbleMasteryHelp == "Bubble Clone" then
				if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
					if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
						game:GetService("ReplicatedStorage").BubbleThrow:FireServer()
						wait(0.5)
						repeat task.wait() until not BubbleTo()
						task.wait(2)
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoBubbleMasteryHelp do
HelpMasteryJoin({NoCF = true})
if Players2 and Players2:FindFirstChild("entered") then
	if _G.Players1CloneHelp then
		if BubbleChild() then
			pcall(function() root.CFrame = BubbleChild().CFrame end)
		else
			root.CFrame = workspace.SafeBoxSpace.CFrame * CFrame.new(0,9,0)
		end
	else
		root.CFrame = workspace.SafeBoxSpace.CFrame * CFrame.new(0,9,5.9)
	end
end
if not _G.Players1CloneHelp then
	if _G.BubbleMasteryHelp == "Bubble + Slap Clone" then
		if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				slapglove(root1)
				wait(0.4)
				repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.35)
				game:GetService("ReplicatedStorage").BubbleThrow:FireServer()
				wait(0.5)
				repeat task.wait() until BubbleChild() ~= nil
				wait(0.4)
				repeat task.wait() until not BubbleChild()
				task.wait(5.5)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Bubble equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Bubble"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Engineer Mastery", {
    Text = "Engineer Mastery",
    Values = {"Kill Clone", "Slap Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.EngineerMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Engineer", {
    Text = "Auto Mastery Engineer",
    Default = false, 
    Callback = function(Value) 
_G.AutoEngineerMasteryHelp = Value
if not _G.AutoEngineerMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp and not PlayersMain and Value == true then
	Notification("You have input main account", _G.TimeNotify)
	wait(0.05)
	Toggles["Auto Mastery Engineer"]:SetValue(false)
end
if _G.Players1CloneHelp or CheckGlove() == "Engineer" then
function TurretSpawn()
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name:lower():find("turret") and v:FindFirstChild("Hitbox") and (root.Position - v.Hitbox.Position).Magnitude <= 200 then
			return v
		end
	end
	return nil
end
spawn(function()
	while _G.AutoEngineerMasteryHelp do
		Turret = TurretSpawn()
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if _G.Players1CloneHelp then
			if PlayersMain and Players2 and Players2:FindFirstChild("entered") and PlayersMain:FindFirstChild("entered") then
				if Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == false then
					repeat task.wait()
						if Turret then
							for i, v in pairs(Turret:GetChildren()) do
								local GloveFind = v:FindFirstChild("Glove", true)
								if GloveFind then
									Players2:SetPrimaryPartCFrame(GloveFind.CFrame)
								end
							end
						end
					until Players2.Ragdolled.Value == true
					if _G.EngineerMasteryHelp == "Kill Clone" then
						wait(0.5)
						repeat task.wait()
							Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
						until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
						repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						wait(0.3)
					end
				end
			end
		else
			if not TurretSpawn() and Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == false then
				game:GetService("ReplicatedStorage").Sentry:FireServer()
				wait(5.5)
			end
		end
		task.wait()
	end
end)
while _G.AutoEngineerMasteryHelp do
HelpMasteryJoin({NoCF = true})
if Players2 and Players2:FindFirstChild("entered") then
	local TurretFind = TurretSpawn()
	if _G.Players1CloneHelp then
		if not TurretFind then
			Players2:SetPrimaryPartCFrame(workspace.Safespot.DefendPart4.CFrame * CFrame.new(0,8,-7.5))
		end
	elseif not _G.Players1CloneHelp then
		Players2:SetPrimaryPartCFrame(workspace.Safespot.DefendPart4.CFrame * TurretFind and CFrame.new(0,8,9) or CFrame.new(0,8,0))
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Engineer equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Engineer"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Voodoo Mastery", {
    Text = "Voodoo Mastery",
    Values = {"Farm Voodoo Clone", "Voodoo Slap 20 Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.VoodooMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Voodoo", {
    Text = "Auto Mastery Voodoo",
    Default = false, 
    Callback = function(Value) 
_G.AutoVoodooMasteryHelp = Value
if not _G.AutoVoodooMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Voodoo" then
spawn(function()
	while _G.AutoVoodooMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
					if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
						game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
						task.wait(6.66)
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoVoodooMasteryHelp do
local function FoundDollPlr(object)
	local DollPlr
	for i, v in pairs(object:GetChildren()) do
		if v.Name:lower():find("doll") then
			DollPlr = v
		end
	end
	return DollPlr
end
if Players2 and Players2:FindFirstChild("entered") then
	if Players2 and FoundDollPlr(Players2) then
		TpGetDoll = CFrame.new(0,8,0)
	else
		TpGetDoll = CFrame.new(0,5,0)
	end
end
HelpMasteryJoin({
	CloneCF = TpGetDoll,
	MainCF = CFrame.new(0,5,0),
})
local function HasEnabledParticle()
	if Players2 and Players2:FindFirstChild(CheckGlove()) and Players2[CheckGlove()]:FindFirstChild("Glove") and Players2[CheckGlove()].Glove:FindFirstChild("ParticleAttachement") then
		for _, v in ipairs(Players2[CheckGlove()].Glove.ParticleAttachement:GetChildren()) do
			if v.Name:find("Particle") and v.Enabled then
				return true
			end
		end
	end
	return false
end
if not _G.Players1CloneHelp then
	if _G.VoodooMasteryHelp:match("Voodoo") then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				if HasEnabledParticle() then
					slapglove(root1)
					wait(0.3)
					repeat task.wait() until FoundDollPlr(Players1)
					wait(0.3)
					local DollPlrTo = FoundDollPlr(Players1)
					if DollPlrTo then
						slapglove(DollPlrTo)
					end
					task.wait(0.5)
				end
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Voodoo equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Voodoo"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Bus Mastery", {
    Text = "Bus Mastery",
    Values = {"Farm Slap Clone", "Bus Crash Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BusMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Bus", {
    Text = "Auto Mastery Bus",
    Default = false, 
    Callback = function(Value) 
_G.AutoBusMasteryHelp = Value
if not _G.AutoBusMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "bus" then
spawn(function()
	while _G.AutoBusMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
					if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
						if _G.BusMasteryHelp == "Bus Crash Clone" then
							game:GetService("ReplicatedStorage").busmoment:FireServer()
							task.wait(6.1)
						end
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoBusMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,6.5),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if _G.BusMasteryHelp == "Farm Slap Clone" then
				for i = 1, 10 do
					if root1 then
						slapglove(root1)
						task.wait(0.87)
					end
				end
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				wait(0.6)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have bus equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery bus"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Shard Mastery", {
    Text = "Shard Mastery",
    Values = {"Slap + Shard Clone", "150 Studs Clone", "Shard Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ShardMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Shard", {
    Text = "Auto Mastery Shard",
    Default = false, 
    Callback = function(Value) 
_G.AutoShardMasteryHelp = Value
if not _G.AutoShardMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Shard" then
spawn(function()
	while _G.AutoShardMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
					if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 200 then
						game:GetService("ReplicatedStorage").Shards:FireServer()
						task.wait(4.87)
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoShardMasteryHelp do
HelpMasteryJoin({
	CloneCF = (_G.ShardMasteryHelp:find("Shard Clone") and CFrame.new(0,5,0) or CFrame.new(0, 5, -200)),
	MainCF = CFrame.new(0,5,8)
})
if not _G.Players1CloneHelp then
	if _G.AutoShardMasteryHelp == "Slap + Shard Clone" then
		if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
			repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value
			wait(0.5)
			for i = 1, 5 do
				slapglove(root1)
				task.wait(0.9)
			end
			task.wait(0.8)
			repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
			task.wait(0.7)
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Shard equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Shard"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Bonk Mastery", {
    Text = "BONK Mastery",
    Values = {"BONK Clone", "BONK + Slap"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BonkMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery BONK", {
    Text = "Auto Mastery BONK",
    Default = false, 
    Callback = function(Value) 
_G.AutoBonkMasteryHelp = Value
if not _G.AutoBonkMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "BONK" then
spawn(function()
	while _G.AutoBonkMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 200 then
					game:GetService("ReplicatedStorage"):WaitForChild("BONK"):FireServer()
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoBonkMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,5),
})
if Players2 and Players2:FindFirstChild("entered") then
	if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
		if _G.BonkMasteryHelp == "BONK + Slap" then
			if torso1 and torso1.Size.Y < 1.7 then
				for i = 1, 9 do
					if torso1 and torso1.Size.Y < 1.7 then
						slapglove(root1)
						task.wait(0.9)
					end
				end
				task.wait(0.8)
				repeat task.wait() until Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.7)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have BONK equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery BONK"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Hexa Mastery", {
    Text = "Hexa Mastery",
    Values = {"Ability Clone", "Slap + Ability Clone", "Kill Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.HexaMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Hexa", {
    Text = "Auto Mastery Hexa",
    Default = false, 
    Callback = function(Value) 
_G.AutoHexaMasteryHelp = Value
if not _G.AutoBonkMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Hexa" then
spawn(function()
	while _G.AutoHexaMasteryHelp do
		if _G.Players1CloneHelp then
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if _G.HexaMasteryHelp == "Kill Clone" then
					repeat task.wait() until _G.AutoHexaMasteryHelp == false or Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
					wait(1)
					repeat task.wait()
						Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					repeat task.wait() until not _G.AutoHexaMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.5)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoHexaMasteryHelp do
pcall(function()
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,-7),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) <= 100 then
				if _G.HexaMasteryHelp == "Ability Clone" or _G.HexaMasteryHelp == "Kill Clone" then
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				elseif _G.HexaMasteryHelp == "Slap + Ability Clone" then
					slapglove(root1)
					task.wait(0.6)
					game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
				end
				task.wait(0.5)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.5)
			end
		end
	end
end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have BONK equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery BONK"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Thanos Mastery", {
    Text = "Thanos Mastery",
    Values = {"Ambush Clone", "Recover/Save Yourself", "Combo Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ThanosMasteryHelp = Value
if Value == "Recover/Save Yourself" then
	Notification("Clone account have choose Recover/Save Yourself", 5)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Thanos", {
    Text = "Auto Mastery Thanos",
    Default = false, 
    Callback = function(Value) 
_G.AutoThanosMasteryHelp = Value
if not _G.AutoThanosMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Thanos" then
if _G.Players1CloneHelp and not PlayersMain and Value == true then
	Notification("You have input main account", _G.TimeNotify)
	wait(0.05)
	Toggles["Auto Mastery Thanos"]:SetValue(false)
	return
end
spawn(function()
	while _G.AutoThanosMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if _G.Players1CloneHelp then
			if PlayersMain and Players2 and Players2:FindFirstChild("entered") and PlayersMain:FindFirstChild("entered") and PlayersMain:FindFirstChild("Ragdolled") and PlayersMain.Ragdolled.Value == false then
				if (root and rootmain and (root.Position - rootmain.Position).Magnitude or 9e9) < 200 then
					if _G.ThanosMasteryHelp == "Recover/Save Yourself" then
						slapglove(rootmain)
						task.wait(6.2)
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoThanosMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,5),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if _G.ThanosMasteryHelp == "Ambush Clone" then
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(2)
				task.wait(1.9)
				for i = 1, 9 do
					slapglove(root1)
					task.wait(0.8)
				end
			elseif _G.ThanosMasteryHelp == "Combo Clone" then
				slapglove(root1)
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(2)
				task.wait(1.9)
				slapglove(root1)
			else
				repeat task.wait() until Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == true
				wait(0.3)
				repeat task.wait() until Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == false
				wait(0.3)
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(2)
				task.wait(6.3)
			end
			wait(0.5)
			repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
			task.wait(0.5)
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Thanos equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Thanos"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Soul Mastery", {
    Text = "Soul Mastery",
    Values = {"Combo clone", "Kill clone for strongest", "Kill clone AOE blast"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.SoulMasteryHelp = Value
if Value:find("Kill") then
	Notification("Clone account have choose kill clone", 5)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Soul", {
    Text = "Auto Mastery Soul",
    Default = false, 
    Callback = function(Value) 
_G.AutoSoulMasteryHelp = Value
if not _G.AutoSoulMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Soul" then
spawn(function()
	while _G.AutoSoulMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if _G.Players1CloneHelp then
			if PlayersMain and Players2 and Players2:FindFirstChild("entered") and PlayersMain:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == true then
				if (root and rootmain and (root.Position - rootmain.Position).Magnitude or 9e9) < 200 then
					if tonumber(PlayersMain:GetAttribute("souls")) >= 50 then
						if _G.SoulMasteryHelp:find("Kill") and (not _G.SoulMasteryHelp == "Kill clone for strongest" or tonumber(PlayersMain:GetAttribute("charge")) >= 100) then
							repeat task.wait() until _G.AutoSoulMasteryHelp == false or Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
							wait(1)
							repeat task.wait()
								Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
							until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
							repeat task.wait() until not _G.AutoSoulMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						end
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoSoulMasteryHelp do
HelpMasteryJoin({NoCF = true})
if root and Players2 and Players2:FindFirstChild("entered") then
	root.CFrame = workspace["SafeBox"].S5.CFrame * (not _G.Players1CloneHelp and CFrame.new(0, 20, 0) or CFrame.new(0, 20, 10))
end
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if tonumber(Players2:GetAttribute("souls")) >= 50 and (not _G.SoulMasteryHelp == "Kill clone for strongest" or tonumber(Players2:GetAttribute("charge")) >= 100) then
				if _G.SoulMasteryHelp == "Combo clone" then
					slapglove(root1)
					wait(0.2)
					repeat task.wait() until _G.AutoSoulMasteryHelp == false or Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and not Players2.Ragdolled.Value
					wait(0.1)
					game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(false)
					wait(0.6)
				elseif _G.SoulMasteryHelp == "Kill clone for strongest" then
					if tonumber(Players2:GetAttribute("charge")) >= 100 then
						game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(false)
					end
				elseif _G.SoulMasteryHelp == "Kill clone AOE blast" then
					if tonumber(Players2:GetAttribute("souls")) >= 50 then
						game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(true)
					end
				end
			else
				if tonumber(Players2:GetAttribute("souls")) < 75 then
					for i = 1, 9 do
						slapglove(root1)
						task.wait(0.75)
					end
					wait(0.3)
				else
					if tonumber(Players2:GetAttribute("charge")) < 100 then
						game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("soul"):FireServer("charge")
					end
				end
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Soul equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Soul"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Eggler Mastery", {
    Text = "Eggler Mastery",
    Values = {"Kill Clone 5 Time", "Eggler Clone", "Unegg Slap Clone", "Deny Slap Eggler"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.EgglerMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Eggler", {
    Text = "Auto Mastery Eggler",
    Default = false, 
    Callback = function(Value) 
_G.AutoEgglerMasteryHelp = Value
if not _G.AutoEgglerMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Eggler" then
local function FoundEggVictim(target)
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name:lower() == "egg_victim" and v:GetAttribute("target") == target.Name then
			return v
		end
	end
	return nil
end
spawn(function()
	while _G.AutoEgglerMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 200 then
					if _G.EgglerMasteryHelp == "Eggler Clone" or _G.EgglerMasteryHelp == "Kill Clone 5 Time" then
						if not FoundEggVictim(Players2) then
							game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer()
						end
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoEgglerMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,7),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and not FoundEggVictim(Players1) and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if _G.EgglerMasteryHelp == "Unegg Slap Clone" then
				repeat task.wait()
					game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
				until Players2 and Players2:GetAttribute("isEgg")
				wait(0.3)
				repeat task.wait()
					game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
				until Players2 and not Players2:GetAttribute("isEgg")
				wait(0.3)
				for i = 1, 9 do
					slapglove(root1)
					task.wait(0.8)
				end
			elseif _G.EgglerMasteryHelp == "Deny Slap Eggler" then
				slapglove(root1)
				wait(0.3)
				game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
				wait(0.3)
				repeat task.wait()
					game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("EgglerRAbility"):FireServer()
				until Players2 and not Players2:GetAttribute("isEgg")
			end
			wait(0.67)
			repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
			task.wait(0.5)
		end
	end
elseif _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if FoundEggVictim(Players2) then
			wait(0.5)
			repeat task.wait()
				Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
			until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			wait(0.65)
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Eggler equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Eggler"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Phantom Mastery", {
    Text = "Phantom Mastery",
    Values = {"Jumpscare Clone", "Combo Slap Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PhantomMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Phantom", {
    Text = "Auto Mastery Phantom",
    Default = false, 
    Callback = function(Value) 
_G.AutoPhantomMasteryHelp = Value
if not _G.AutoPhantomMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Phantom" then
spawn(function()
	while _G.AutoPhantomMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 200 then
					if _G.PhantomMasteryHelp == "Jumpscare Clone" then
						local PhantomTool = ((Players2 and Players2:FindFirstChild(CheckGlove())) or game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove())) or nil
						if PhantomTool then
							game:GetService("ReplicatedStorage").PhantomDash:InvokeServer(PhantomTool) 
						end
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoPhantomMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,5),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if _G.PhantomMasteryHelp == "Jumpscare Clone" then
				if Players2:GetAttribute("phantom") then
					task.wait(0.2)
					repeat task.wait() until not _G.AutoPhantomMasteryHelp or not Players2 or not Players2:GetAttribute("phantom")
					task.wait(0.3)
					for i = 1, 4 do
						slapglove(root1)
						task.wait(0.9)
					end
					wait(0.3)
				end
			else
				slapglove(root1)
				wait(0.3)
				local PhantomTool = ((Players2 and Players2:FindFirstChild(CheckGlove())) or game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove())) or nil
				if PhantomTool then
					game:GetService("ReplicatedStorage").PhantomDash:InvokeServer(PhantomTool) 
				end
				wait(0.3)
				repeat task.wait() until not _G.AutoPhantomMasteryHelp or not Players2 or not Players2:GetAttribute("phantom")
				wait(0.2)
				slapglove(root1)
				wait(4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Phantom equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Phantom"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Rage Mastery", {
    Text = "Rage Mastery",
    Values = {"Max Rage", "50% Rage", "Murder Rage"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.RageMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Rage", {
    Text = "Auto Mastery Rage",
    Default = false, 
    Callback = function(Value) 
_G.AutoRageMasteryHelp = Value
if not _G.AutoRageMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp and not PlayersMain and Value == true then
	if _G.RageMasteryHelp == "Murder Rage" then
		Notification("You have input main account", _G.TimeNotify)
		wait(0.05)
		Toggles["Auto Mastery Rage"]:SetValue(false)
	end
end
if _G.Players1CloneHelp or CheckGlove() == "Rage" then
spawn(function()
	while _G.AutoRageMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if (Players2 and Players2:GetAttribute("rage_percent") or 0) > 55 then
					if Players2 and not Players2:GetAttribute("frenzy") then
						game:GetService("ReplicatedStorage"):WaitForChild("GRRRRR"):FireServer("frenzy")
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoRageMasteryHelp do
pcall(function()
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,7,0),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if (Players2 and Players2:GetAttribute("rage_percent") or 0) < (_G.RageMasteryHelp == "Max Rage" and 100 or 55) then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				for i = 1, 5 do
					slapglove(root1)
					task.wait(0.9)
				end
				task.wait(0.3)
			end
		end
	end
else
	if _G.RageMasteryHelp == "Murder Rage" then
		repeat task.wait() until PlayersMain and PlayersMain:GetAttribute("frenzy") and Players2 and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == false
		wait(0.5)
		repeat task.wait()
			Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
		until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
		repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		task.wait(0.6)
	end
end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Rage equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Rage"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Plank Mastery", {
    Text = "Plank Mastery",
    Values = {"Ambush Clone", "Plank Clone", "Plank Kill"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PlankMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Plank", {
    Text = "Auto Mastery Plank",
    Default = false, 
    Callback = function(Value) 
_G.AutoPlankMasteryHelp = Value
if not _G.AutoPlankMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Plank" then
spawn(function()
	while _G.AutoPlankMasteryHelp do
		if _G.Players1CloneHelp then
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if _G.PlankMasteryHelp == "Plank Kill" then
					repeat task.wait() until _G.AutoPlankMasteryHelp == false or Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
					wait(1)
					repeat task.wait()
						Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					repeat task.wait() until not _G.AutoPlankMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.5)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoPlankMasteryHelp do
pcall(function()
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = (_G.PlankMasteryHelp:find("Plank") and CFrame.new(0,5,5) or CFrame.new(0,-20,0)),
})
if not _G.Players1CloneHelp then
	if _G.PlankMasteryHelp == "Ambush Clone" then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				wait(0.32)
				if not workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank") or workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank"):GetAttribute("collect") then
					game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(0, 0, 0), Vector3.new(math.huge, 0, 0))
					wait(1.7)
				end
				if workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank") and not workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank"):GetAttribute("collect") then
					CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
					Players2:SetPrimaryPartCFrame(workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank").CFrame * CFrame.new(0, 0, 3) * CFrame.Angles(math.rad(60), math.rad(0), math.rad(0)))
					task.wait(1)
					Players2:SetPrimaryPartCFrame(workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Plank").CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(60), math.rad(0), math.rad(0)))
				end
				wait(0.8)
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				Players2:SetPrimaryPartCFrame(root1.CFrame * CFrame.new(0, 7, 0))
				repeat task.wait() until _G.AutoPlankMasteryHelp == false or (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 8
				wait(0.3)
				slapglove(root1)
				wait(0.2)
				root.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
				repeat task.wait() until _G.AutoPlankMasteryHelp == false or Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	elseif _G.PlankMasteryHelp:find("Plank") then
		if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 30 then
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(0, 0, 0), Vector3.new(math.huge, 0, 0))
			end
		end
	end
end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Plank equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Plank"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Obby Mastery", {
    Text = "Obby Mastery",
    Values = {"Kill Clone", "Slap Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ObbyMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Obby", {
    Text = "Auto Mastery Obby",
    Default = false, 
    Callback = function(Value) 
_G.AutoObbyMasteryHelp = Value
if not _G.AutoObbyMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Obby" then
if _G.Players1CloneHelp and not PlayersMain and Value == true then
	Notification("You have input main account", _G.TimeNotify)
	wait(0.05)
	Toggles["Auto Mastery Obby"]:SetValue(false)
	return
end
if not _G.Players1CloneHelp and _G.AutoObbyMasteryHelp and _G.ObbyMasteryHelp == "Kill Clone" then
	repeat task.wait()
		if Players2:FindFirstChild("HumanoidRootPart") and Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("entered") == nil then
			equipglove("Fort")
			repeat task.wait() until not _G.AutoObbyMasteryHelp or CheckGlove() == "Fort"
			wait(0.3)
			repeat task.wait()
				if Players2 and Players2:FindFirstChild("entered") == nil then
					root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
				end
			until Players2 and Players2:FindFirstChild("entered")
			task.wait(0.5)
			root.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
			task.wait(0.5)
			hum:MoveTo(root.Position + Vector3.new(0, 0, 20))
			task.wait(4)
			hum:MoveTo(root.Position)
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			root.CFrame = CFrame.new(209, -28006, 1)
			wait(0.7)
			for i = 1, 2 do
				game:GetService("ReplicatedStorage").Fortlol:FireServer()
				wait(3.6)
			end
			game:GetService("Players").LocalPlayer.Reset:FireServer()
			wait(0.3)
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			wait(0.5)
			equipglove("Obby")
			repeat task.wait() until not _G.AutoObbyMasteryHelp or CheckGlove() == "Obby"
			wait(0.4)
			repeat task.wait()
				if Players2 and Players2:FindFirstChild("entered") == nil then
					root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
				end
			until game.Players.LocalPlayer.Character:FindFirstChild("entered")
			wait(0.4)
			root.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
			task.wait(0.5)
			hum:MoveTo(root.Position + Vector3.new(0, 0, 20))
			task.wait(4)
			hum:MoveTo(root.Position)
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			root.CFrame = CFrame.new(209, -28006, 1) * CFrame.Angles(math.rad(0), -55, 0)
			wait(0.9)
			for i, v in pairs(workspace:GetChildren()) do
				if v.Name == "Part" and v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound") and (root.Position - v.Position).Magnitude <= 50 then
					FortWall = v
					break
				end
			end
			if FortWall then
				local WallSize = FortWall.Size
				local NEWY = FortWall.Position.Y + (WallSize.Y/2) + 0.4
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(FortWall.Position.X, NEWY, FortWall.Position.Z) * CFrame.Angles(math.rad(0), 55, 0), 1)
			end
			task.wait(4)
		end
	until not _G.AutoObbyMasteryHelp or workspace:FindFirstChild("ObbyItem"..game.Players.LocalPlayer.Name.."LavaBlock")
end
wait(0.3)
spawn(function()
	while _G.AutoObbyMasteryHelp do
		if _G.Players1CloneHelp then
			if PlayersMain and Players2 and Players2:FindFirstChild("entered") and PlayersMain:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if _G.ObbyMasteryHelp == "Kill Clone" then
					repeat task.wait()
						if workspace:FindFirstChild("ObbyItem".._G.HelpPlayer2.Name.."LavaBlock") then
							Players2:SetPrimaryPartCFrame(workspace:FindFirstChild("ObbyItem".._G.HelpPlayer2.Name.."LavaBlock").CFrame)
						end
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					repeat task.wait() until not _G.AutoObbyMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.5)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoObbyMasteryHelp do
pcall(function()
CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
HelpMasteryJoin({NoCF = true})
if Players2 and Players2:FindFirstChild("entered") then
	if _G.ObbyMasteryHelp == "Kill Clone" then
		root.CFrame = (not _G.Players1CloneHelp and CFrame.new(360, -28006, 1))
	else
		root.CFrame = workspace["SafeBox"].S5.CFrame * (_G.Players1CloneHelp and CFrame.new(0,5,0) or CFrame.new(0,5,8))
	end
end
if not _G.Players1CloneHelp then
	if _G.ObbyMasteryHelp == "Slap Clone" then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					for i = 1, 9 do
						slapglove(root1)
						task.wait(0.9)
					end
					wait(0.3)
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(0.6)
				end
			end
		end
	end
end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Obby equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Obby"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Tycoon Mastery", {
    Text = "Tycoon Mastery",
    Values = {"Defense Tycoon", "Kill Clone (Tycoon God)"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.TycoonMasteryHelp = Value
    end
})

function FoundTycoon(rootp)
	local TargetTycoon
	for i, v in pairs(game.Workspace:GetChildren()) do
		if v.Name:match("ÅTycoon") and v:FindFirstChild("End") and (rootp.Position - v.End.Position).Magnitude <= 100 then
			TargetTycoon = v
		end
	end
	return TargetTycoon
end
Badge4Group:AddToggle("Auto Mastery Tycoon", {
    Text = "Auto Mastery Tycoon",
    Default = false, 
    Callback = function(Value) 
_G.AutoTycoonMasteryHelp = Value
if not _G.AutoTycoonMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Tycoon" then
	repeat task.wait()
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if Players2 and Players2:FindFirstChild("entered") == nil then
			root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
		end
		if Players2:FindFirstChild("entered") then
			root.CFrame = CFrame.new(17894, 15, -3579)
		end
		if not _G.Players1CloneHelp and not game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and Players2:FindFirstChild("entered") then
			game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(17893.587890625, -26.257728576660156, -3571.69775390625, 0.9998365640640259, -6.031721255794764e-08, 0.01807994209229946, 6.185813816728114e-08, 1, -8.466933820727718e-08, -0.01807994209229946, 8.577389110087097e-08, 0.9998365640640259))
			task.wait(6.5)
		end
	until not _G.AutoTycoonMasteryHelp or game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name)
	wait(0.3)
	if not _G.Players1CloneHelp and _G.AutoTycoonMasteryHelp and _G.TycoonMasteryHelp == "Kill Clone (Tycoon God)" then
		if _G.TycoonMasteryHelp == "Kill Clone (Tycoon God)" then
			repeat task.wait()
				if Players2 and Players2:FindFirstChild("entered") == nil then
					root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
				end
				if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) then
					GuiTrackUpdate(true, {
						Text = "Tycoon Your Point\n"..game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):GetAttribute("LastCount").." / 5000",
						Size = game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name):GetAttribute("LastCount") / 5000
					})
				end
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				root.CFrame = CFrame.new(350, -28006, 1)
				for _, v in pairs(workspace:GetChildren()) do
				    local hasClick = v:FindFirstChild("Click")
				    if hasClick then
					    if v.Name:match(game.Players.LocalPlayer.Name) then
					        local cd = hasClick:FindFirstChildOfClass("ClickDetector")
					        if cd then
					            fireclickdetector(cd, 0)
					            fireclickdetector(cd, 1)
					        end
					    end
					end
				end
			until not _G.AutoTycoonMasteryHelp or _G.TycoonMasteryHelp ~= "Kill Clone (Tycoon God)" or (game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") >= 5000)
			GuiTrackUpdate(false)
		end
	end
wait(0.3)
spawn(function()
	while _G.AutoTycoonMasteryHelp do
		if _G.Players1CloneHelp then
			if Players2 and Players2:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if _G.TycoonMasteryHelp == "Kill Clone (Tycoon God)" then
					repeat task.wait() until Players2 and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
					wait(0.4)
					repeat task.wait()
						Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					wait(0.1)
					repeat task.wait() until not _G.AutoTycoonMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.5)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoTycoonMasteryHelp do
local TycoonF = FoundTycoon(root)
HelpMasteryJoin({NoCF = true})
if Players2 and Players2:FindFirstChild("entered") then
	if _G.TycoonMasteryHelp == "Kill Clone (Tycoon God)" then
		root.CFrame = (not _G.Players1CloneHelp and CFrame.new(360, -28006, 1) or CFrame.new(355, -28006, 1))
	else
		if TycoonF and TycoonF:FindFirstChild("End") then
			root.CFrame = TycoonF:FindFirstChild("End").CFrame * (_G.Players1CloneHelp and CFrame.new(0,20,0) or CFrame.new(0,25,0))
		else
			root.CFrame = CFrame.new(17894, 15, -3579)
		end
	end
end
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 100 then
				if _G.TycoonMasteryHelp == "Defense Tycoon" then
					for i = 1, 9 do
						slapglove(root1)
						task.wait(0.9)
					end
				elseif _G.TycoonMasteryHelp == "Kill Clone (Tycoon God)" then
					if game.Workspace:FindFirstChild("ÅTycoon"..game.Players.LocalPlayer.Name) and game.Workspace["ÅTycoon"..game.Players.LocalPlayer.Name]:GetAttribute("LastCount") >= 5000 then
						wait(0.5)
						slapglove(root1)
					end
				end
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.6)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Tycoon equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Tycoon"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Hive Mastery", {
    Text = "Hive Mastery",
    Values = {"Honey Clone", "Swarm Clone", "Kill Clone Honey"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.HiveMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Hive", {
    Text = "Auto Mastery Hive",
    Default = false, 
    Callback = function(Value) 
_G.AutoHiveMasteryHelp = Value
if not _G.AutoHiveMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Hive" then
spawn(function()
	while _G.AutoHiveMasteryHelp do
		if _G.Players1CloneHelp then
			if Players2 and Players2:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if _G.HiveMasteryHelp == "Kill Clone Honey" then
					repeat task.wait() until Players2 and Players2:GetAttribute("honey_mark")
					wait(0.4)
					repeat task.wait()
						Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					wait(0.1)
					repeat task.wait() until not _G.AutoHiveMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.8)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoHiveMasteryHelp do
pcall(function()
	HelpMasteryJoin({
		CloneCF = CFrame.new(0,5,0),
		MainCF = CFrame.new(0,7,0)
	})
	if not _G.Players1CloneHelp then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Humanoid") and Players1:FindFirstChild("Ragdolled") and Players1.Humanoid.Health > 0 and Players1.Ragdolled.Value == false then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					if _G.HiveMasteryHelp == "Honey Clone" then
						for i = 1, 9 do
							slapglove(root1)
							task.wait(0.9)
						end
					elseif _G.HiveMasteryHelp == "Swarm Clone" then
						repeat task.wait()
							game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer()
						until Players2 and Players2:GetAttribute("hiveability")
						wait(0.2)
						slapglove(root1)
						wait(0.3)
						repeat task.wait() until Players2 and not Players2:GetAttribute("glovebroken")
					else
						slapglove(root1)
						task.wait(0.9)
					end
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(0.6)
				end
			end
		end
	end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Hive equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Hive"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Dice Mastery", {
    Text = "Dice Mastery",
    Values = {"Slap Clone", "Kill Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.DiceMasteryHelp = Value
    end
})

function foundDice(rootD)
	local DiceMax, Dice = 0, nil
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name:lower():find("DicePart") and v:FindFirstChild("BillboardGui") and v.BillboardGui:FindFirstChild("ImageLabel") and v.BillboardGui.ImageLabel:FindFirstChild("TextLabel") then
			if v.BillboardGui.ImageLabel.BackgroundTransparency <= 0.5 then
				local Dice = (rootD.Position - v.Position).Magnitude
				if Dice and Dice >= 60 then
					DiceMax, Dice = math.max(DiceMax, tonumber(v.BillboardGui.ImageLabel.TextLabel)), v
				end
			end
		end
	end
	return DiceMax, Dice
end
Badge4Group:AddToggle("Auto Mastery Dice", {
    Text = "Auto Mastery Dice",
    Default = false, 
    Callback = function(Value) 
_G.AutoDiceMasteryHelp = Value
if not _G.AutoDiceMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Dice" then
spawn(function()
	while _G.AutoDiceMasteryHelp do
		pcall(function()
			if _G.Players1CloneHelp then
				if Players2 and Players2:FindFirstChild("entered") then
					CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
					if _G.DiceMasteryHelp == "Kill Clone" then
						local DiceMax, Dice = foundDice(root)
						if DiceMax and tonumber(DiceMax) >= 60 then
							repeat task.wait() until Players2 and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
							wait(0.4)
							repeat task.wait()
								Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
							until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
							wait(0.1)
							repeat task.wait() until not _G.DiceMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
							wait(0.5)
							if Dice then
								Dice:Destroy()
							end
						end
					end
				end
			end
		end)
		task.wait()
	end
end)
while _G.AutoDiceMasteryHelp do
pcall(function()
	HelpMasteryJoin({
		CloneCF = CFrame.new(0,5,0),
		MainCF = CFrame.new(0,7,0),
	})
	if not _G.Players1CloneHelp then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					if _G.DiceMasteryHelp == "Slap Clone" then
						for i = 1, 10 do
							slapglove(root1)
							task.wait(0.78)
						end
					else
						slapglove(root1)
						task.wait(0.4)
					end
					wait(0.4)
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(0.4)
				end
			end
		end
	end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Dice equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Dice"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Phase Mastery", {
    Text = "Phase Mastery",
    Values = {"Slap + Ability", "Ability + Slap (2 Sec)"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PhaseMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Phase", {
    Text = "Auto Mastery Phase",
    Default = false, 
    Callback = function(Value) 
_G.AutoPhaseMasteryHelp = Value
if not _G.AutoPhaseMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Phase" then
while _G.AutoPhaseMasteryHelp do
HelpMasteryJoin({CloneCF = CFrame.new(0,5,0), MainCF = CFrame.new(0,7,0)})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				if _G.PhaseMasteryHelp == "Slap + Ability" then
					slapglove(root1)
					game:GetService("ReplicatedStorage").PhaseA:FireServer()
					wait(0.2)
					repeat task.wait() until root and root:FindFirstChild("BlackheartREAL") == nil
					wait(0.15)
				elseif _G.PhaseMasteryHelp == "Ability + Slap (2 Sec)" then
					game:GetService("ReplicatedStorage").PhaseA:FireServer()
					task.wait(0.2)
					repeat task.wait() until root and root:FindFirstChild("BlackheartREAL") == nil
					task.wait(0.25)
					for i = 1, 5 do
						slapglove(root1)
						task.wait(0.73)
					end
				end
				wait(0.56)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.5)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Phase equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Phase"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Spring Mastery", {
    Text = "Spring Mastery",
    Values = {"Jump Over Clone", "Evade Clone", "Jump Land 2 Sec Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.SpringMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Spring", {
    Text = "Auto Mastery Spring",
    Default = false, 
    Callback = function(Value) 
_G.AutoSpringMasteryHelp = Value
if not _G.AutoSpringMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Spring" then
while _G.AutoSpringMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,6,0),
	MainCF = CFrame.new(0,6,3.8),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 100 then
				if _G.SpringMasteryHelp == "Jump Over Clone" or _G.SpringMasteryHelp == "Jump Land 2 Sec Clone" then
					repeat task.wait()
						game:GetService("ReplicatedStorage"):WaitForChild("SpringJump"):FireServer()
					until char and char:FindFirstChild("JumpSoundDB")
					if _G.SpringMasteryHelp == "Jump Land 2 Sec Clone" then task.wait(1.4) end
					wait(0.17)
					slapglove(root1)
					wait(0.3)
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(0.65)
				elseif _G.SpringMasteryHelp == "Evade Clone" then
					slapglove(root1)
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					wait(0.1)
					repeat task.wait()
						game:GetService("ReplicatedStorage"):WaitForChild("SpringJump"):FireServer()
					until char and char:FindFirstChild("JumpSoundDB")
					task.wait(1.5)
				end
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Spring equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Spring"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Gummy Mastery", {
    Text = "Gummy Mastery",
    Values = {"Slap Clone", "Kill Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.GummyMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Gummy", {
    Text = "Auto Mastery Gummy",
    Default = false, 
    Callback = function(Value) 
_G.AutoGummyMasteryHelp = Value
if not _G.AutoGummyMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Gummy" then
spawn(function()
	while _G.AutoGummyMasteryHelp do
		if _G.Players1CloneHelp then
			if Players2 and Players2:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if _G.GummyMasteryHelp == "Kill Clone" then
					repeat task.wait() until Players2 and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
					wait(0.4)
					repeat task.wait()
						Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					wait(0.1)
					repeat task.wait() until not _G.AutoGummyMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.5)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoGummyMasteryHelp do
pcall(function()
HelpMasteryJoin({
	CloneCF = CFrame.new(0,6,0),
	MainCF = CFrame.new(0,6,3.8),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 100 then
				if _G.GummyMasteryHelp == "Slap Clone" then
					slapglove(root1)
					task.wait(0.2)
				end
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.8)
			end
		end
	end
end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Gummy equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Gummy"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Mace Mastery", {
    Text = "Mace Mastery",
    Values = {"Kill Clone", "Slap Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.MaceMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Mace", {
    Text = "Auto Mastery Mace",
    Default = false, 
    Callback = function(Value) 
_G.AutoMaceMasteryHelp = Value
if not _G.AutoMaceMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Mace" then
spawn(function()
	while _G.AutoMaceMasteryHelp do
		if _G.Players1CloneHelp then
			if Players2 and Players2:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if _G.MaceMasteryHelp == "Kill Clone" then
					repeat task.wait() until Players2 and Players2:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value
					wait(0.4)
					repeat task.wait()
						Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
					until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					wait(0.1)
					repeat task.wait() until not _G.AutoMaceMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.8)
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoMaceMasteryHelp do
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 200 then
				slapglove(root1)
				task.wait(0.56)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.5)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Mace equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Mace"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Defense Mastery", {
    Text = "Defense Mastery",
    Values = {"Slap Clone 100 sec", "Kill Clone Box", "Protect Defence", "Slap clone Into Box"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.DefenseMasteryHelp = Value
    end
})

function FoundDefenseBox(rootp)
	local FoundBox
	for i,v in pairs(game.Workspace:GetChildren()) do
		if string.find(v.Name, "ÅBarrier") and (rootp.Position - v.Position).Magnitude <= 100 then
			FoundBox = v
		end
	end
	return FoundBox
end
Badge4Group:AddToggle("Auto Mastery Defense", {
    Text = "Auto Mastery Defense",
    Default = false, 
    Callback = function(Value) 
_G.AutoDefenseMasteryHelp = Value
if not _G.AutoDefenseMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Defense" then
spawn(function()
	while _G.AutoDefenseMasteryHelp and task.wait() do
		pcall(function()
			for i,v in pairs(game.Workspace:GetChildren()) do
				if string.find(v.Name, "ÅBarrier") then
					v.CanCollide = false
				end
			end
			if not _G.Players1CloneHelp then
				if root and Players2 and Players2:FindFirstChild("entered") then
					local FoundBox = FoundDefenseBox(root)
					if not FoundBox then
						game:GetService("ReplicatedStorage").Barrier:FireServer(1)
						task.wait(0.8)
					end
				end
			end
		end)
	end
end)
spawn(function()
	while _G.AutoDefenseMasteryHelp do
		if _G.Players1CloneHelp then
			if root and Players2 and Players2:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				local FoundBox = FoundDefenseBox(root)
				if _G.DefenseMasteryHelp == "Kill Clone Box" then
					if FoundBox and InsideBox(root, FoundBox) then
						if Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == true then
							wait(0.1)
							repeat task.wait()
								Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
							until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
							repeat task.wait() until not _G.AutoHiveMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
							wait(0.8)
						end
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoDefenseMasteryHelp do
CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
HelpMasteryJoin({NoCF = true})
local FoundBox = FoundDefenseBox(root)
if Players2 and Players2:FindFirstChild("entered") then
	if _G.Players1CloneHelp and FoundBox then
		if _G.DefenseMasteryHelp ~= "Slap clone Into Box" or (Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == true) then
			Players2:SetPrimaryPartCFrame(FoundBox.CFrame)
		elseif Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value == false then
			Players2:SetPrimaryPartCFrame(workspace["SafeBox"].S5.CFrame * CFrame.new(0, 20, 25))
		end
	else
		Players2:SetPrimaryPartCFrame(workspace["SafeBox"].S5.CFrame * (_G.DefenseMasteryHelp == "Slap clone Into Box" and FoundBox and CFrame.new(0, 20, 22) or CFrame.new(0, 20, 0)))
	end
end
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 100 then
				if _G.DefenseMasteryHelp == "Slap Clone 100 sec" then
					for i = 1, 10 do
						if _G.AutoDefenseMasteryHelp then
							slapglove(root1)
							task.wait(0.78)
						end
					end
				elseif _G.DefenseMasteryHelp == "Slap clone Into Box" then
					slapglove(root1)
					task.wait(0.9)
				end
				if FoundBox and InsideBox(root1, FoundBox) then
					if _G.DefenseMasteryHelp == "Kill Clone Box" then
						slapglove(root1)
						task.wait(0.9)
					elseif _G.DefenseMasteryHelp == "Protect Defence" then
						for i = 1, 9 do
							slapglove(root1)
							task.wait(0.9)
						end
					end
				end
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Spring equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Spring"]:SetValue(false)
end
    end
})

Badge4Group:AddDropdown("Moai Mastery", {
    Text = "Moai Mastery",
    Values = {"Ragdoll Clone", "Kill Clone", "Slap Clone"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.MoaiMasteryHelp = Value
    end
})

Badge4Group:AddToggle("Auto Mastery Moai", {
    Text = "Auto Mastery Moai",
    Default = false, 
    Callback = function(Value) 
_G.AutoMoaiMasteryHelp = Value
if not _G.AutoMoaiMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "🗿" then
if _G.Players1CloneHelp and not PlayersMain and Value == true then
	Notification("You have input main account", _G.TimeNotify)
	wait(0.05)
	Toggles["Auto Mastery Moai"]:SetValue(false)
	return
end
if not _G.Players1CloneHelp and _G.AutoMoaiMasteryHelp then
	repeat task.wait()
		if Players2:FindFirstChild("HumanoidRootPart") and Players2:FindFirstChild("entered") == nil then
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			equipglove("Fort")
			repeat task.wait() until not _G.AutoMoaiMasteryHelp or CheckGlove() == "Fort"
			wait(0.3)
			repeat task.wait()
				if Players2 and Players2:FindFirstChild("entered") == nil then
					root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
				end
			until Players2 and Players2:FindFirstChild("entered")
			task.wait(0.5)
			root.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
			task.wait(0.5)
			hum:MoveTo(root.Position + Vector3.new(0, 0, 20))
			task.wait(4)
			hum:MoveTo(root.Position)
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			root.CFrame = CFrame.new(209, -28006, 1)
			wait(0.5)
			for i = 1, 2 do
				game:GetService("ReplicatedStorage").Fortlol:FireServer()
				wait(3.6)
			end
			game:GetService("Players").LocalPlayer.Reset:FireServer()
			wait(0.3)
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			wait(0.5)
			equipglove("🗿")
			repeat task.wait() until not _G.AutoMoaiMasteryHelp or CheckGlove() == "🗿"
			wait(0.4)
			repeat task.wait()
				if Players2 and Players2:FindFirstChild("entered") == nil then
					root.CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
				end
			until game.Players.LocalPlayer.Character:FindFirstChild("entered")
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			task.wait(0.5)
			root.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
			task.wait(0.5)
			hum:MoveTo(root.Position + Vector3.new(0, 0, 20))
			task.wait(4)
			hum:MoveTo(root.Position)
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			root.CFrame = CFrame.new(209, -28006, 1)
			wait(0.56)
			for i, v in pairs(workspace:GetChildren()) do
				if v.Name == "Part" and v:FindFirstChild("brownsmoke") and v:FindFirstChild("Sound") and (root.Position - v.Position).Magnitude <= 50 then
					FortWall = v
					break
				end
			end
			if FortWall then
				local WallSize = FortWall.Size
				local NEWY = FortWall.Position.Y + (WallSize.Y/2) + 2.6
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(CFrame.new(FortWall.Position.X, NEWY, FortWall.Position.Z))
			end
			task.wait(4)
		end
	until not _G.AutoMoaiMasteryHelp or workspace:FindFirstChild("ÅMoyaiStatue"..game:GetService("Players").LocalPlayer.Name)
end
wait(0.3)
spawn(function()
	while _G.AutoMoaiMasteryHelp do
		if _G.Players1CloneHelp then
			if PlayersMain and Players2 and Players2:FindFirstChild("entered") and PlayersMain:FindFirstChild("entered") then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if _G.MoaiMasteryHelp == "Ragdoll Clone" or _G.MoaiMasteryHelp == "Kill Clone" then
					repeat task.wait()
						if workspace:FindFirstChild("ÅMoyaiStatue".._G.HelpPlayer2.Name) and workspace["ÅMoyaiStatue".._G.HelpPlayer2.Name]:FindFirstChild("Hitbox") then
							Players2:SetPrimaryPartCFrame(workspace:FindFirstChild("ÅMoyaiStatue".._G.HelpPlayer2.Name).Hitbox.CFrame * CFrame.new(0, 7, 0))
						end
					until not Players2 or Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
					if _G.MoaiMasteryHelp == "Ragdoll Clone" then
						game:GetService("Players").LocalPlayer.Reset:FireServer()
					elseif _G.MoaiMasteryHelp == "Kill Clone" then
						repeat task.wait()
							Players2:SetPrimaryPartCFrame(game.Workspace.DEATHBARRIER.CFrame)
						until not Players2 or Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health <= 0
					end
					wait(0.4)
					repeat task.wait() until not _G.AutoMoaiMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoMoaiMasteryHelp do
HelpMasteryJoin({NoCF = true})
if Players2 and Players2:FindFirstChild("entered") then
	if not _G.Players1CloneHelp then
		root.CFrame = CFrame.new(209, -28006, 1)
	end
end
if not _G.Players1CloneHelp then
	if _G.MoaiMasteryHelp == "Slap Clone" or _G.MoaiMasteryHelp == "Kill Clone" then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					slapglove(root1)
					task.wait(0.9)
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(0.6)
				end
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Moai equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Moai"]:SetValue(false)
end
    end
})

Badge4Group:AddDivider()

Badge4Group:AddToggle("Auto Mastery Wormhole", {
    Text = "Auto Mastery Wormhole",
    Default = false, 
    Callback = function(Value) 
_G.AutoWormholeMasteryHelp = Value
if not _G.AutoWormholeMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Wormhole" then
spawn(function()
	while _G.AutoWormholeMasteryHelp do
		if not _G.Players1CloneHelp then
			CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
			if Players2 and Players2:FindFirstChild("entered") and Players1 and Players1:FindFirstChild("entered") then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					game:GetService("ReplicatedStorage").WormholeTP:FireServer(CFrame.new(-57, -4, 67))
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoWormholeMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				slapglove(root1)
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Wormhole equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Wormhole"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Moon", {
    Text = "Auto Mastery Moon",
    Default = false, 
    Callback = function(Value) 
_G.AutoMoonMasteryHelp = Value
if not _G.AutoMoonMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Moon" then
while _G.AutoMoonMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				slapglove(root1)
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Moon equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Moon"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Brick", {
    Text = "Auto Mastery Brick",
    Default = false, 
    Callback = function(Value) 
_G.AutoBrickMasteryHelp = Value
if not _G.AutoTinkeverMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Brick" then
spawn(function()
	while _G.AutoBrickMasteryHelp do
		CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
		if not _G.Players1CloneHelp then
			if Players1 and Players2 and Players2:FindFirstChild("entered") and Players1:FindFirstChild("entered") then
				if Players1 and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
					if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
						game:GetService("ReplicatedStorage").lbrick:FireServer()
					end
				end
			end
		end
		task.wait()
	end
end)
while _G.AutoBrickMasteryHelp do
HelpMasteryJoin({CloneCF = CFrame.new(0,5,0), MainCF = CFrame.new(0,20,4)})
task.wait()
end
elseif Value == true then
Notification("You don't have Brick equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Brick"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Killstreak", {
    Text = "Auto Mastery Killstreak",
    Default = false, 
    Callback = function(Value) 
_G.AutoKillstreakMasteryHelp = Value
if not _G.AutoKillstreakMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Killstreak" then
spawn(function()
	while _G.AutoKillstreakMasteryHelp do
		pcall(function()
			if _G.Players1CloneHelp then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if Players2 and Players2:FindFirstChild("entered") then
					repeat task.wait() until _G.AutoKillstreakMasteryHelp == false or Players2 and Players2:FindFirstChild("entered") and Players2:FindFirstChild("Ragdolled") and Players2.Ragdolled.Value
					wait(1)
					if _G.AutoKillstreakMasteryHelp then
						game:GetService("Players").LocalPlayer.Reset:FireServer()
					end
					wait(0.25)
					repeat task.wait() until not _G.AutoKillstreakMasteryHelp or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					wait(0.8)
				end
			end
		end)
		task.wait()
	end
end)
while _G.AutoKillstreakMasteryHelp do
pcall(function()
	HelpMasteryJoin({
		CloneCF = CFrame.new(0,5,0),
		MainCF = CFrame.new(0,5,3),
	})
	if not _G.Players1CloneHelp then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					slapglove(root1)
					wait(0.3)
					repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
					task.wait(0.4)
				end
			end
		end
	end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have Killstreak equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Killstreak"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Space", {
    Text = "Auto Mastery Space",
    Default = false, 
    Callback = function(Value) 
_G.AutoSpaceMasteryHelp = Value
if not _G.AutoSpaceMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Space" then
while _G.AutoSpaceMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				repeat task.wait()
					game:GetService("ReplicatedStorage"):WaitForChild("ZeroGSound"):FireServer()
				until _G.AutoSpaceMasteryHelp == false or root and root:FindFirstChild("ZeroGSoundEffect")
				wait(0.65)
				for i = 1, 10 do
					if root1 and root and root:FindFirstChild("ZeroGSoundEffect") then
						slapglove(root1)
						task.wait(0.87)
					end
				end
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Space equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Space"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Pinwheel", {
    Text = "Auto Mastery Pinwheel",
    Default = false, 
    Callback = function(Value) 
_G.AutoPinwheelMasteryHelp = Value
if not _G.AutoSpaceMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.AutoPinwheelMasteryHelp or CheckGlove() == "Pinwheel" then
while _G.AutoSpaceMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				slapglove(root1)
				task.wait(0.5)
				game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer()
				task.wait(0.38)
				slapglove(root1)
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(2.86)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Pinwheel equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Pinwheel"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Run", {
    Text = "Auto Mastery Run",
    Default = false, 
    Callback = function(Value) 
_G.AutoRunMasteryHelp = Value
if not _G.AutoRunMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Run" then
if _G.Players1CloneHelp and not PlayersMain and Value == true then
	Notification("You have input main account", _G.TimeNotify)
	wait(0.05)
	Toggles["Auto Mastery Run"]:SetValue(false)
	return
end
spawn(function()
	while _G.AutoRunMasteryHelp do
		pcall(function()
			if not _G.Players1CloneHelp then
				CreateFreezeBV({Name = "HelpMasteryFreezeBv"})
				if Players2 and Players2:FindFirstChild("entered") and not Players2:FindFirstChild("InLabyrinth") then
					if Players1 and not Players1:FindFirstChild("InLabyrinth") and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
						if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 100 then
							game:GetService("ReplicatedStorage").GeneralAbility:FireServer(root.Position + Vector3.new(0, -3.75, 0))
							task.wait(3.75)
						end
					end
				end
			end
		end)
		task.wait()
	end
end)
while _G.AutoRunMasteryHelp do
HelpMasteryJoin({CloneCF = CFrame.new(0,5,0), MainCF = CFrame.new(0,5,3)})
if _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") and PlayersMain and PlayersMain:FindFirstChild("entered") then
		if (rootmain and root and (root.Position - rootmain.Position).Magnitude or 9e9) < 270 then
			if PlayersMain:FindFirstChild("InLabyrinth") and Players2:FindFirstChild("InLabyrinth") then
				repeat task.wait() 
					Players2:SetPrimaryPartCFrame(rootmain.CFrame)
				until not _G.AutoRunMasteryHelp or (hum and hum.Health <= 0) or not Players2:FindFirstChild("InLabyrinth")
				wait(0.5)
				repeat task.wait() until not _G.AutoRunMasteryHelp or not game.Players.LocalPlayer.Character:FindFirstChild("InLabyrinth") or game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				task.wait(0.8)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Run equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Run"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Glovel", {
    Text = "Auto Mastery Glovel",
    Default = false, 
    Callback = function(Value) 
_G.AutoGlovelMasteryHelp = Value
if not _G.AutoGlovelMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Glovel" then
while _G.AutoGlovelMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				for i = 1, 9 do
					slapglove(root1)
					task.wait(0.9)
				end
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Glovel equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Glovel"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Booster", {
    Text = "Auto Mastery Booster",
    Default = false, 
    Callback = function(Value) 
_G.AutoBoosterMasteryHelp = Value
if not _G.AutoBoosterMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Booster" then
while _G.AutoBoosterMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				slapglove(root1)
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(2.5)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Glovel equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Glovel"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Rob", {
    Text = "Auto Mastery Rob",
    Default = false, 
    Callback = function(Value) 
_G.AutoRobMasteryHelp = Value
if not _G.AutoRobMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "rob" then
while _G.AutoRobMasteryHelp do
pcall(function()
	HelpMasteryJoin({
		CloneCF = CFrame.new(0,5,0),
		MainCF = CFrame.new(0,5,3),
	})
	if not _G.Players1CloneHelp then
		if Players2 and Players2:FindFirstChild("entered") then
			if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
				if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
					game:GetService("ReplicatedStorage").rob:FireServer()
					for i, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
						if v.Name == "whiteframe" then
							v:Destroy()
						end
					end
					repeat task.wait() until _G.AutoRobMasteryHelp == false or Players2:FindFirstChild("entered") and Players2 and Players2:FindFirstChild("Humanoid") and Players2:FindFirstChild("Humanoid").Health > 0 and tonumber(Players2:FindFirstChild("Head").Transparency) < 1
					wait(0.3)
				end
			end
		end
	end
end)
task.wait()
end
elseif Value == true then
Notification("You don't have rob equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Rob"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Stalker", {
    Text = "Auto Mastery Stalker",
    Default = false, 
    Callback = function(Value) 
_G.AutoStalkerMasteryHelp = Value
if not _G.AutoStalkerMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Stalker" then
while _G.AutoStalkerMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				for i = 1, 9 do
					slapglove(root1)
					task.wait(0.9)
				end
				wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Stalker equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Stalker"]:SetValue(false)
end
    end
})

Badge4Group:AddToggle("Auto Mastery Stick", {
    Text = "Auto Mastery Stick",
    Default = false, 
    Callback = function(Value) 
_G.AutoStickMasteryHelp = Value
if not _G.AutoStickMasteryHelp then
	CreateFreezeBV({Remove = true, Name = "HelpMasteryFreezeBv"})
end
if _G.Players1CloneHelp or CheckGlove() == "Stick" then
while _G.AutoStickMasteryHelp do
HelpMasteryJoin({
	CloneCF = CFrame.new(0,5,0),
	MainCF = CFrame.new(0,5,3),
})
if not _G.Players1CloneHelp then
	if Players2 and Players2:FindFirstChild("entered") then
		if Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false then
			if (root and root1 and (root.Position - root1.Position).Magnitude or 9e9) < 50 then
				slapglove(root1)
				task.wait(0.3)
				repeat task.wait() until Players1 and Players1:FindFirstChild("entered") and Players1:FindFirstChild("Ragdolled") and Players1.Ragdolled.Value == false
				task.wait(0.4)
			end
		end
	end
end
task.wait()
end
elseif Value == true then
Notification("You don't have Stick equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Mastery Stick"]:SetValue(false)
end
    end
})

local Local1Group = Tabs.Tab4:AddLeftGroupbox("Speed")

Local1Group:AddSlider("WalkSpeed", {
    Text = "Speed",
    Default = 20,
    Min = 20,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
Walkspeed = Value
    end
})

Local1Group:AddInput("WalkSpeed1", {
    Default = "20",
    Numeric = false,
    Text = "Speed",
    Placeholder = "UserSpeed",
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
Walkspeed = Value
    end
})

Local1Group:AddToggle("SetSpeed", {
    Text = "Auto Set Speed",
    Default = false, 
    Callback = function(Value) 
KeepWalkspeed = Value
            while KeepWalkspeed do
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.WalkSpeed ~= Walkspeed then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Walkspeed
                end
task.wait()
            end
    end
})

local Local2Group = Tabs.Tab4:AddRightGroupbox("Jump")

Local2Group:AddSlider("JumpPower", {
    Text = "Jump",
    Default = 50,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
Jumppower = Value
    end
})

Local2Group:AddInput("JumpPower1", {
    Default = "50",
    Numeric = true,
    Text = "Jump",
    Placeholder = "UserJump",
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
Jumppower = Value
    end
})

Local2Group:AddToggle("SetJump", {
    Text = "Auto Set Jump",
    Default = false, 
    Callback = function(Value) 
KeepJumppower = Value
            while KeepJumppower do
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.JumpPower ~= Jumppower then
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Jumppower
                end
task.wait()
            end
    end
})

local Local3Group = Tabs.Tab4:AddLeftGroupbox("Remaining")

Local3Group:AddSlider("HipHeight", {
    Text = "Hip Height",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.HipHeight = Value
HipHeight = Value
    end
})

Local3Group:AddToggle("SetHipHeight", {
    Text = "Auto Set Hip Height",
    Default = false, 
    Callback = function(Value) 
KeepHipHeight = Value
           while KeepHipHeight do
              if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.HipHeight ~= HipHeight then
                  game.Players.LocalPlayer.Character.Humanoid.HipHeight  = HipHeight
              end
task.wait()
         end
    end
})

Local3Group:AddSlider("Gravity", {
    Text = "Gravity",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
game.Workspace.Gravity = Value
    end
})

local Misc2Group = Tabs.Tab5:AddRightGroupbox("Misc Default")

Misc2Group:AddDropdown("GodMobe", {
    Text = "Godmobe",
    Values = {"Godmode", "Godmode + Invisibility"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "Godmode" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1, 1)
end
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") or game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        v.Parent = game.LogService
                    end
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        v.Parent = game.LogService
                    end
game:GetService("Players").LocalPlayer.Reset:FireServer()
wait(3.82)
for i,v in pairs(game.LogService:GetChildren()) do
                        v.Parent = game.Players.LocalPlayer.Backpack
                end
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                end 
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
elseif Value == "Godmode + Invisibility" then
if game.Players.LocalPlayer.leaderstats.Slaps.Value >= 666 then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1, 0)
firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1, 1)
end
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool") or game.Players.LocalPlayer.Backpack:FindFirstChildWhichIsA("Tool")
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        v.Parent = game.LogService
                    end
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        v.Parent = game.LogService
                end
game:GetService("Players").LocalPlayer.Reset:FireServer()
wait(3.82)
OGlove = CheckGlove()
fireclickdetector(workspace.Lobby.Ghost.ClickDetector)
game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
fireclickdetector(workspace.Lobby[OGlove].ClickDetector)
for i,v in pairs(game.LogService:GetChildren()) do
                        v.Parent = game.Players.LocalPlayer.Backpack
                end
for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                end 
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
wait(0.5)
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v.Name ~= "Humanoid" then
v.Transparency = 0
end
end
else
Notification("You need 666+ slaps", _G.TimeNotify)
end
end
    end
})

Misc2Group:AddDropdown("Teleport Place", {
    Text = "Teleport",
    Values = {"Arena", "Lobby", "Hunter Room", "Tournament", "Brazil", "Island Slapple", "Plate", "Cannon Island", "Keypad", "Cube Of Death", "Moai Island", "Default Arena", "Island 1", "Island 2", "Island 3"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "Arena" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,-5,0)
elseif Value == "Lobby" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-800,328,-2.5)
elseif Value == "Hunter Room" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.BountyHunterRoom.BountyHunterBooth._bountyRoomWarpPart.CFrame
elseif Value == "Brazil" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Lobby.brazil.portal.CFrame
elseif Value == "Island Slapple" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Arena.island5.Union.CFrame * CFrame.new(0,3.25,0)
elseif Value == "Plate" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Arena.Plate.CFrame
elseif Value == "Tournament" then
if workspace:FindFirstChild("TournamentIsland") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.TournamentIsland.Spawns.Part.CFrame * CFrame.new(0,2,0)
else
Notification("Tournament Island don't not spawn.", _G.TimeNotify)
end
elseif Value == "Cannon Island" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,0,35)
elseif Value == "Keypad" then
if not workspace:FindFirstChild("Keypad") then
Notification("Server in don't have keypad.", _G.TimeNotify)
else
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Keypad.Buttons.Enter.CFrame
end
elseif Value == "Cube Of Death" then
if game.Workspace:FindFirstChild("the cube of death(i heard it kills)", 1) then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CFrame * CFrame.new(0,5,0)
end
elseif Value == "Moai Island" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(215, -15.5, 0.5)
elseif Value == "Default Arena" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(120,360,-3)
elseif Value == "Island 1" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-211.210846, -5.27827597, 4.13719559, -0.0225322824, 1.83683113e-08, -0.999746144, -1.83560154e-08, 1, 1.87866842e-08, 0.999746144, 1.87746618e-08, -0.0225322824)
elseif Value == "Island 2" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8.17191315, -5.14452887, -205.249741, -0.98216176, -3.48867246e-09, -0.188037917, -4.19987778e-09, 1, 3.38382322e-09, 0.188037917, 4.11319823e-09, -0.98216176)
elseif Value == "Island 3" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6.66747713, -5.06731462, 213.575378, 0.945777893, 2.52095178e-10, 0.324814111, -3.7823856e-08, 1, 1.09357536e-07, -0.324814111, -1.15713661e-07, 0.945777893)
end
    end
})

Misc2Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.PlayerPut = FoundPlr(Value, true)
    end
})

Misc2Group:AddButton("Teleport Player", function()
if _G.PlayerPut and _G.PlayerPut.Character and _G.PlayerPut.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut.Character.HumanoidRootPart.CFrame
end
end)

Misc2Group:AddToggle("Auto Teleport Player", {
    Text = "Auto Teleport Player",
    Default = false, 
    Callback = function(Value) 
_G.PlayerTele = Value
while _G.PlayerTele do
if _G.PlayerPut and _G.PlayerPut.Character and _G.PlayerPut.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut.Character.HumanoidRootPart.CFrame
end
task.wait()
end
    end
})

Misc2Group:AddToggle("Auto View Player", {
    Text = "Auto View Player",
    Default = false, 
    Callback = function(Value) 
_G.PlayerView = Value
if _G.PlayerView == false then
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
end
end
while _G.PlayerView do
if _G.PlayerPut and _G.PlayerPut.Character and _G.PlayerPut.Character:FindFirstChild("Humanoid") then
	game.Workspace.CurrentCamera.CameraSubject = _G.PlayerPut.Character:FindFirstChild("Humanoid")
else
	if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	end
end
task.wait()
end
    end
})

_G.SetSpeedFly = 50
Misc2Group:AddInput("FlySpeed", {
    Default = "50",
    Numeric = true,
    Text = "Fly Speed",
    Placeholder = "UserFlySpeed",
    Callback = function(Value)  
        _G.SetSpeedFly = Value  
    end  
})

Misc2Group:AddToggle("Start Fly", {
    Text = "Start Fly",
    Default = false, 
    Callback = function(Value) 
Fly(Value)
	end
}):AddKeyPicker("Fly", {
   Default = "R",
   Text = "Fly",
   Mode = "Toggle",
   SyncToggleState = true
})

TabBoxMisc1 = Tabs.Tab5:AddLeftTabbox()
local Misc1Basic = TabBoxMisc1:AddTab("Misc") 

 Misc1Basic:AddToggle("Autofarm Slapples", {
    Text = "Autofarm Slapples",
    Default = false, 
    Callback = function(Value) 
_G.SlappleFarm = Value
while _G.SlappleFarm do
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	for i, v in pairs(workspace.Arena.island5.Slapples:GetChildren()) do
        if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("entered") and (v.Name:lower() == "slapple" or v.Name:lower() == "goldenslapple") and v:FindFirstChild("Glove") and v.Glove:FindFirstChildWhichIsA("TouchTransmitter") then
            v.Glove.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end
task.wait()
end
    end
}):AddKeyPicker("AutofarmSlapples", {
   Default = "M",
   Text = "Autofarm Slapples",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Basic:AddToggle("Autofarm Candy", {
    Text = "Autofarm Candy",
    Default = false, 
    Callback = function(Value) 
_G.CandyCornsFarm = Value
while _G.CandyCornsFarm do
for i, v in pairs(game.Workspace.CandyCorns:GetChildren()) do
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
       v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end
task.wait()
end
    end
}):AddKeyPicker("AutofarmCandy", {
   Default = "C",
   Text = "Autofarm Candy",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Basic:AddDropdown("Notify Workspace", {
    Text = "Notify",
    Values = {"Orb", "Toolbox", "Gravestone", "Gift", "Keypad"},
    Default = "",
    Multi = true
})

Misc1Basic:AddToggle("Notify Real", {
    Text = "Notify Choose",
    Default = false, 
    Callback = function(Value) 
_G.NotifyThank = Value
if _G.NotifyThank then
local function WorkspaceChild(v)
	if Options["Notify Workspace"].Value["Orb"] and (v.Name == "JetOrb" or v.Name == "PhaseOrb" or v.Name == "SiphonOrb" or v.Name == "MATERIALIZEOrb") then
		Notification("[Notify]: "..v.Name:gsub("Orb", " Orb").." Spawn", _G.TimeNotify)
	end
	if Options["Notify Workspace"].Value["Toolbox"] and v.Name == "Toolbox" then
		Notification("[Notify]: Toolbox Spawn", _G.TimeNotify)
	end
	if Options["Notify Workspace"].Value["Gravestone"] and v.Name == "Gravestone" then
		Notification("[Notify]: Gravestone Spawn", _G.TimeNotify)
	end
	if Options["Notify Workspace"].Value["Gift"] and v.Name == "Gift" then
		Notification("[Notify]: Gift Spawn", _G.TimeNotify)
	end
	if Options["Notify Workspace"].Value["Keypad"] and v.Name == "Keypad" then
		Notification("[Notify]: Keypad Spawn", _G.TimeNotify)
	end
end
for i, v in pairs(workspace:GetChildren()) do
	WorkspaceChild(v)
end
Child = workspace.ChildAdded:Connect(function(child)
	WorkspaceChild(child)
end)
else
if Child then
Child:Disconnect()
Child = nil
end
end
    end
})

Misc1Basic:AddToggle("Fling", {
    Text = "Fling",
    Default = false,
    Callback = function(Value) 
_G.FlingThen = Value
if not _G.FlingThen then
	for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
end
while _G.FlingThen do
	pcall(function()
		local char = game.Players.LocalPlayer.Character or nil
		local root = (char and char:FindFirstChild("HumanoidRootPart")) or nil
		local ragdoll = (char and char:FindFirstChild("Ragdolled")) or nil
		if not (char and root) then return end
		for i, v in pairs(char:GetChildren()) do
			if v:IsA("BasePart") then
				if ragdoll and ragdoll.Value == true then
					v.CanCollide = true
				else
					v.CanCollide = false
				end
			end
		end
		if ragdoll and ragdoll.Value == true then return end
		local vel, movel = nil, 0.1
		vel = root.Velocity
		if root and (ragdoll and ragdoll.Value == false) then
			root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
		end
		game:GetService("RunService").RenderStepped:Wait()
		if root then
			root.Velocity = vel
		end
		game:GetService("RunService").Stepped:Wait()
		if root then
			root.Velocity = vel + Vector3.new(0, movel, 0)
			movel = movel * -1
		end
	end)
task.wait()
end
    end
})

Misc1Basic:AddButton({
    Text = "Auto Keypad",
    DoubleClick = true,
    Func = function()
if not workspace:FindFirstChild("Keypad") then
Notification("Server in don't have keypad, can have started serverhop", _G.TimeNotify)
task.wait(1.5)
for _, v in ipairs(game.HttpService:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
if v.playing < v.maxPlayers and v.JobId ~= game.JobId then
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
end
end
else
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace:FindFirstChild("SafeBoxSpace").CFrame * CFrame.new(0, 7, 0)
	wait(0.5)
end
game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
local digits = tostring((#game.Players:GetPlayers()) * 25 + 1100 - 7)
for i = 1, #digits do
wait(.5)
local digit = digits:sub(i,i)
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
end
wait(1)
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
end
    end
})

 Misc1Basic:AddToggle("Auto Code Pocket Keypad", {
    Text = "Auto Code Pocket Keypad",
    Default = false, 
    Callback = function(Value) 
_G.WriteCodeKeypad = Value
while _G.WriteCodeKeypad and task.wait() do
	for i, v in pairs(game.Workspace:FindFirstChild("RoomsFolder"):GetChildren()) do
		if string.find(v.Name, "'s Room") then
			local PockerKey = v:FindFirstChild("PocketKeypad", true)
			if PockerKey then
				if typeof(fireclickdetector) == "function" then
					if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
						game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
						repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
						wait(0.5)
						game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace:FindFirstChild("SafeBoxSpace").CFrame * CFrame.new(0, 7, 0)
						wait(0.8)
					end
					fireclickdetector(PockerKey.Buttons:FindFirstChild("Reset").ClickDetector)
					local digits = "4553293"
					for i = 1, #digits do
						wait(0.26)
						local CodeOPad = digits:sub(i,i)
						fireclickdetector(PockerKey.Buttons:FindFirstChild(CodeOPad).ClickDetector)
					end
					task.wait(0.15)
					fireclickdetector(PockerKey.Buttons:FindFirstChild("Enter").ClickDetector)
				end
			end
		end
	end
end
    end
})

 Misc1Basic:AddInput("Write Code Keypad", {
    Default = "",
    Numeric = true,
    Text = "Write Code Keypad",
    Placeholder = "UserCode",
    Callback = function(Value)
_G.writeCode = Value
    end
})

 Misc1Basic:AddDropdown("Enter Keypad", {
    Text = "Enter Keypad",
    Values = {"Not Enter","Enter"},
    Default = "Enter",
    Multi = false,
    Callback = function(Value)
_G.EnterKeypad = Value
    end
})

Misc1Basic:AddButton("Write Keypad", function()
if not workspace:FindFirstChild("Keypad") then
Notification("Server in don't have keypad.", _G.TimeNotify)
else
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace:FindFirstChild("SafeBoxSpace").CFrame * CFrame.new(0, 7, 0)
	wait(0.5)
end
game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
for i = 1,#_G.writeCode do
wait(.35)
local digit = _G.writeCode:sub(i,i)
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
end
if _G.EnterKeypad == "Enter" then
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
end
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
end
end
end)

 Misc1Basic:AddDropdown("Easter Egg Code", {
    Text = "Easter Egg Code",
    Values = {"911","8008","666","6969","1987"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.EggCodes = Value
    end
})

 Misc1Basic:AddButton("Easter Egg Keypad", function()
if not workspace:FindFirstChild("Keypad") then
Notification("Server in don't have keypad.", _G.TimeNotify)
else
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").CFrame
	repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.5)
	game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace:FindFirstChild("SafeBoxSpace").CFrame * CFrame.new(0, 7, 0)
	wait(0.5)
end
game.Workspace.CurrentCamera.CameraSubject = workspace.Keypad.Buttons.Enter
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Reset").ClickDetector)
for i = 1,#_G.EggCodes do
wait(.35)
local digit = _G.EggCodes:sub(i,i)
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild(digit).ClickDetector)
end
wait(1)
fireclickdetector(workspace:WaitForChild("Keypad").Buttons:FindFirstChild("Enter").ClickDetector)
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
end
end
end)

CloneAcc = Misc1Basic:AddInput("Players", {
    Text = "Clone Account",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.HelpPlayer1Slap = FoundPlr(Value, true)
    end
})

Misc1Basic:AddToggle("Clone Help Farm Slap", {
    Text = "Clone Help Farm Slap",
    Default = false, 
    Callback = function(Value) 
_G.CloneAccHelpFarm = Value
if CloneAcc then
	CloneAcc:SetVisible(not _G.CloneAccHelpFarm)
end
    end
})

Misc1Basic:AddSlider("Slap Cooldown", {
    Text = "Delay Slap (Clone)",
    Default = 0.75,
    Min = 0.7,
    Max = 1.75,
    Rounding = 2,
    Compact = true,
    Callback = function(Value)
_G.DelaySlapClone = Value
    end
})

Misc1Basic:AddDropdown("FarmSlap", {
    Text = "AutoFarm Slap",
    Values = {"Aimbot","Teleport", "Tween", "Clone Help"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AutoFarmSlapBattles = Value
    end
})

local LastPathTime = 0
local slapgloveclone = 0
local CurrentWaypointIndex = 1
local Waypoints = {}
local MissPart = {}
local PFS = game:GetService("PathfindingService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local pathFolder = workspace:FindFirstChild("PathFindPartsFolder") or Instance.new("Folder")
pathFolder.Name = "PathFindPartsFolder"
pathFolder.Parent = workspace

local function IsValidTarget(player)
    if player == LocalPlayer then return false end
    local char = player.Character
    local localChar = LocalPlayer.Character
    if not char or not localChar then return false end
    if not localChar:FindFirstChild("entered") or not char:FindFirstChild("entered") then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return false end
    if hrp.Position.Y < -10 then 
        return false 
    end
    if char:FindFirstChild("stevebody") or char:FindFirstChild("rock") or char:FindFirstChild("Mirage") then return false end
    if char.Head:FindFirstChild("UnoReverseCard") then return false end
    if player.leaderstats.Glove.Value:lower():find("spectator") then return false end
    if _G.AutoFarmSlapBattles ~= "Aimbot" then
        if hrp.BrickColor == BrickColor.new("New Yeller") or (char:FindFirstChild("Torso") and char.Torso.Transparency >= 1) then return false end
        if hrp:FindFirstChild("Digging") then return false end
    end
    local ragdolled = char:FindFirstChild("Ragdolled")
    if _G.AutoFarmSlapBattles == "Teleport" then
        if not ragdolled or ragdolled.Value == false then return false end
    else
        if ragdolled and ragdolled.Value == true then return false end
    end
    return true
end

local function IsNearMissPart(position, safeRadius)
    for _, v in ipairs(MissPart) do
        if v and v:IsA("BasePart") then
            local dist = (v.Position - position).Magnitude
            if dist <= safeRadius + math.max(v.Size.X, v.Size.Z) / 2 then
                return true, v
            end
        end
    end
    return false, nil
end

local function IsSafeGround(position)
	local localplr = game.Players.LocalPlayer
	if not localplr then return end
	local char = localplr.Character
	if not char then return end
    local rayOrigin = position + Vector3.new(0, 5, 0)
    local rayDirection = Vector3.new(0, -15, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {char}
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return result ~= nil
end

local function GetSafeDodgePosition(originPos, dangerousPart)
    local avoidDir = (originPos - dangerousPart.Position).Unit
    local dodgeDistance = 8
    local leftDir = Vector3.new(-avoidDir.Z, 0, avoidDir.X)
    local rightDir = Vector3.new(avoidDir.Z, 0, -avoidDir.X)
    local leftPos = originPos + leftDir * dodgeDistance
    local rightPos = originPos + rightDir * dodgeDistance
    local isLeftSafe = IsSafeGround(leftPos) and not IsNearMissPart(leftPos, 5)
    local isRightSafe = IsSafeGround(rightPos) and not IsNearMissPart(rightPos, 5)
    if isLeftSafe then
        return leftPos
    elseif isRightSafe then
        return rightPos
    else
        return originPos - (dangerousPart.Position - originPos).Unit * dodgeDistance
    end
end

local function EquipGlove()
    local char = LocalPlayer.Character
    if not char then return end
    if not char:FindFirstChildOfClass("Tool") then
        for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("Glove") then
                v.Parent = char
                break
            end
        end
    end
end

local function DrawVisualPath(wps)
    pathFolder:ClearAllChildren()
    for _, wp in ipairs(wps) do
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Position = wp.Position
        part.Shape = Enum.PartType.Ball
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromRGB(0, 255, 255)
        part.Anchored = true
        part.CanCollide = false
        part.Parent = pathFolder
    end
end

table.insert(_G.ConnectFun, RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if _G.AutoFarmSlap and _G.AutoFarmSlapBattles == "Clone Help (Duel)" then
		if char and humanoid and char:FindFirstChild("entered") == nil then
			humanoid:MoveTo(game.Workspace:FindFirstChild("Lobby"):FindFirstChild("Teleport1").Position)
		end
		if char:FindFirstChild("entered") and hrp then
			CreateFreezeBV({Name = "Helpfarmslap"})
			if (hrp.Position - workspace["SafeBox"].Position).Magnitude > 200 then
				hrp.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0, (_G.CloneAccHelpFarm and 55 or 50), 0)
				if hrp:FindFirstChild("Helpfarmslap") then
					hrp:FindFirstChild("Helpfarmslap").Velocity = Vector3.zero
				end
			else
				if hrp:FindFirstChild("Helpfarmslap") then
					local direction = (workspace["SafeBox"].Position + Vector3.new(0, (_G.CloneAccHelpFarm and 55 or 50), 0) - hrp.Position) 
					local distance = direction.Magnitude
					if distance > 5 then
						local speed = math.clamp(distance * 5, 50, 150)
						hrp:FindFirstChild("Helpfarmslap").Velocity = direction.Unit * speed
					else
						hrp:FindFirstChild("Helpfarmslap").Velocity = Vector3.zero
					end
				end
			end
			if not _G.CloneAccHelpFarm then
				if char and char:FindFirstChild("entered") then
					if _G.HelpPlayer1Slap and _G.HelpPlayer1Slap.Character and _G.HelpPlayer1Slap.Character:FindFirstChild("entered") and _G.HelpPlayer1Slap.Character:FindFirstChild("HumanoidRootPart") then
						if (hrp.Position - _G.HelpPlayer1Slap.Character.HumanoidRootPart.Position).Magnitude < 50 then
							if tick() - slapgloveclone >= (_G.DelaySlapClone or 0.75) then
								slapgloveclone = tick()
								slapglove(_G.HelpPlayer1Slap.Character.HumanoidRootPart)
							end
						end
					end
				end
			end
		end
	end
	if _G.AutoFarmSlap and _G.AutoFarmSlapBattles == "Aimbot" then
        if char and humanoid and hrp and char:FindFirstChild("entered") then
			local HugeTarget, Target = math.huge, nil
			for i, v in pairs(game.Players:GetPlayers()) do
				if IsValidTarget(v) then
					local targetHrp = v.Character.HumanoidRootPart
					local dist = (hrp.Position - targetHrp.Position).Magnitude
					if dist < HugeTarget then
						Target = v.Character
						HugeTarget = dist
					end
				end
			end
			if Target then
                local targetHrp = Target.HumanoidRootPart
                local targetHumanoid = Target:FindFirstChildOfClass("Humanoid")
                if char and char:FindFirstChild("Ragdolled") and not char.Ragdolled.Value then
	                hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(targetHrp.Position.X, hrp.Position.Y, targetHrp.Position.Z))
				end
                EquipGlove()
                if HugeTarget <= 10 then
                    humanoid:MoveTo(targetHrp.Position)
                    Waypoints = {}
                    if targetHrp.Position.Y - hrp.Position.Y > 2.5 and targetHumanoid and targetHumanoid.FloorMaterial == Enum.Material.Air then
                        if humanoid.FloorMaterial ~= Enum.Material.Air then
                            humanoid.Jump = true
                        end
                    end
                else
                    local Path = PFS:CreatePath({
						AgentRadius = 3,
						WaypointSpacing = 10,
						AgentHeight = 5,
						AgentCanJump = false,
						AgentJumpHeight = 10,
						AgentCanClimb = false,
						AgentMaxSlope = 45
					})
					Path:ComputeAsync(hrp.Position, targetHrp.Position)
					if Path and Path.Status == Enum.PathStatus.Success then
				        local waypoints = Path:GetWaypoints()
						DrawVisualPath(waypoints)
						local currentWaypointIndex = 2
						if currentWaypointIndex <= #waypoints then
					        local waypoint = waypoints[currentWaypointIndex] or waypoints[#waypoints]
					        local isDanger, dangerousPart = IsNearMissPart(waypoint.Position, 6)
					        if isDanger and dangerousPart then
					            local safeDodgePos = GetSafeDodgePosition(waypoint.Position, dangerousPart)
					            humanoid:MoveTo(safeDodgePos)
					        else
								local waypoint2D = waypoint.Position * Vector3.new(1, 0, 1)
				                local current2D = hrp.Position * Vector3.new(1, 0, 1)
				                if (waypoint2D - current2D).Magnitude <= 2 then
				                    currentWaypointIndex += 1
				                else
				                    humanoid:MoveTo(waypoint.Position)
				                end
					        end
						end
				    end
                end
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Glove") then
                    if (tool.Glove.Position - targetHrp.Position).Magnitude <= 5.5 then
                        VirtualUser:ClickButton1(Vector2.new(200, 200))
                    end
                end
            else
                pathFolder:ClearAllChildren()
                Waypoints = {}
			end
		end
	else
        pathFolder:ClearAllChildren()
        Waypoints = {}
	end
end))

Misc1Basic:AddToggle("Auto Farm Slap", {
    Text = "Auto Farm Slap",
    Default = false, 
    Callback = function(Value) 
_G.AutoFarmSlap = Value
while _G.AutoFarmSlap do
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if char and humanoid and hrp then
        local mode = _G.AutoFarmSlapBattles
        local entered = char:FindFirstChild("entered")
        if not entered then
            local lobby = workspace:FindFirstChild("Lobby")
            local teleport = lobby and lobby:FindFirstChild("Teleport1")
            if teleport then
                humanoid:MoveTo(teleport.Position)
            end
        else
            if mode == "Aimbot" then
                for _, v in ipairs(workspace:GetChildren()) do
                    if v.Name == "Union" and v.CanTouch and v.Transparency <= 0 then
                        MissPart[v] = true
                    end
                    if v.Name == "BearTrap" and v:FindFirstChild("Hitbox") and v.Hitbox.CanTouc then 
	                    MissPart[v.Hitbox] = true
                    end
                end
                for i, v in pairs(MissPart) do
	                if i and (not i:IsDescendantOf(workspace) or not i.Parent) then
						MissPart[i] = nil
					end
                end
            end
        end
        if entered and (not char:FindFirstChild("Ragdolled") or char.Ragdolled.Value == false) then
            local closestTarget = nil
            local shortestDistance = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if IsValidTarget(p) then
                    local targetHrp = p.Character.HumanoidRootPart
                    local distance = (hrp.Position - targetHrp.Position).Magnitude
                    if distance < shortestDistance then
                        closestTarget = p.Character
                        shortestDistance = distance
                    end
                end
            end
            if closestTarget and closestTarget:FindFirstChild("HumanoidRootPart") then
                local targetHrp = closestTarget.HumanoidRootPart
                if mode == "Teleport" then
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.1)
                    if typeof(slapglove) == "function" then slapglove(targetHrp) end
                    task.wait(0.5)
                elseif mode == "Tween" then
				    local targetHrp = closestTarget.HumanoidRootPart
				    local targetPos = targetHrp.Position + Vector3.new(0, 4, 0)
			        for _, v in ipairs(char:GetChildren()) do
			            if v:IsA("BasePart") then
			                v.CanCollide = false
			            end
			        end
			        if typeof(CreateFreezeBV) == "function" then
			            CreateFreezeBV({Name = "AutoFarmSlapTween"})
			            local bv = hrp:FindFirstChild("AutoFarmSlapTween")
			            if bv then
			                local direction = targetPos - hrp.Position
			                local distance = direction.Magnitude
			                if distance > 5 then
			                    bv.Velocity = direction.Unit * 80
			                else
			                    bv.Velocity = Vector3.zero
			                end
			            end
			            local checkDistance = (hrp.Position - targetPos).Magnitude
			            if checkDistance <= 6 and _G.AutoFarmSlap then
			                if typeof(slapglove) == "function" then 
			                    slapglove(targetHrp) 
			                end
			                task.wait(0.6)
			            end
			        end
                end
            else
	            if mode == "Tween" then
					local bv = hrp:FindFirstChild("AutoFarmSlapTween")
			        if bv then
			            bv.Velocity = Vector3.zero
			        end
			        for _, v in ipairs(char:GetChildren()) do
			            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			                v.CanCollide = true
			            end
			        end
				end
            end
        end
    end
    if _G.AutoFarmSlapBattles == "Aimbot" then
        task.wait()
    else
        task.wait(0.1)
    end
end
    end
})

Misc1Basic:AddToggle("Auto Spam Ability", {
    Text = "Auto Spam Ability",
    Default = false, 
    Callback = function(Value) 
_G.OnAbility = Value
while _G.OnAbility and CheckGlove() == "Fort" do
game:GetService("ReplicatedStorage").Fortlol:FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Home Run" do
game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
task.wait(4.1)
end
while _G.OnAbility and CheckGlove() == "🗿" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(CFrame.new(target.Character.HumanoidRootPart.CFrame.X, -5.6, target.Character.HumanoidRootPart.CFrame.Z + 5))
end
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Shukuchi" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
wait(0.09)
game:GetService("ReplicatedStorage").SM:FireServer(Target)
end
wait(0.8)
end
while _G.OnAbility and CheckGlove() == "Slicer" do
game:GetService("ReplicatedStorage").Slicer:FireServer("sword")
game:GetService("ReplicatedStorage").Slicer:FireServer("slash", game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, Vector3.new())
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Reverse" do
game:GetService("ReplicatedStorage"):WaitForChild("ReverseAbility"):FireServer()
task.wait(5.7)
end
while _G.OnAbility and CheckGlove() == "rob" do
game:GetService("ReplicatedStorage").rob:FireServer()
wait(3)
end
while _G.OnAbility and CheckGlove() == "bob" do
game:GetService("ReplicatedStorage").bob:FireServer()
wait(9)
end
while _G.OnAbility and (CheckGlove() == "Kraken" or CheckGlove() == "Sbeve") do
game:GetService("ReplicatedStorage").KrakenArm:FireServer()
wait(5)
end
while _G.OnAbility and CheckGlove() == "Psycho" do
game:GetService("ReplicatedStorage").Psychokinesis:InvokeServer({["grabEnabled"] = true})
game:GetService("ReplicatedStorage").Psychokinesis:InvokeServer({["throwbackAlpha"] = math.huge})
task.wait()
end
while _G.OnAbility and CheckGlove() == "Killstreak" do
game:GetService("ReplicatedStorage").KSABILI:FireServer()
wait(6.9)
end
while _G.OnAbility and CheckGlove() == "bus" do
game:GetService("ReplicatedStorage").busmoment:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Mitten" do
game.ReplicatedStorage.MittenA:FireServer(true)
wait(1.55)
game.ReplicatedStorage.MittenA:FireServer(false)
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Defense" do
game:GetService("ReplicatedStorage").Barrier:FireServer()
wait(0.25)
end
while _G.OnAbility and CheckGlove() == "Swashbuckler" do
game.ReplicatedStorage.Events.Swashbuckler_coins:FireServer()
game.ReplicatedStorage.Events.Swashbuckler:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Bomb" do
game:GetService("ReplicatedStorage").BombThrow:FireServer()
wait(2.5)
game:GetService("ReplicatedStorage").BombThrow:FireServer()
wait(4.1)
end
while _G.OnAbility and CheckGlove() == "Replica" do
game:GetService("ReplicatedStorage").Duplicate:FireServer(true)
wait(6)
end
while _G.OnAbility and CheckGlove() == "Pusher" do
game:GetService("ReplicatedStorage").PusherWall:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Jet" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		local Magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
		if Magnitude < 200 then
			table.insert(players, v)
		end
	end
end
if #players ~= 0 then
	local target = players[math.random(#players)]
	game.ReplicatedStorage.AirStrike:FireServer(target.Character)
end
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Tableflip" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Shield" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Rocky" do
game:GetService("ReplicatedStorage").RockyShoot:FireServer()
task.wait(7.5)
end
while _G.OnAbility and CheckGlove() == "God's Hand" do
game:GetService("ReplicatedStorage").TimestopJump:FireServer()
game:GetService("ReplicatedStorage").Timestopchoir:FireServer()
game:GetService("ReplicatedStorage").Timestop:FireServer()
wait(50.1)
end
while _G.OnAbility and CheckGlove() == "Za Hando" do
game:GetService("ReplicatedStorage").Erase:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Baller" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(4.1)
end
while _G.OnAbility and CheckGlove() == "Glitch" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(5.34)
end
while _G.OnAbility and CheckGlove() == "Stun" do
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Stun") then
game:GetService("ReplicatedStorage").StunR:FireServer(game:GetService("Players").LocalPlayer.Character.Stun)
wait(10.1)
end
end
while _G.OnAbility and CheckGlove() == "STOP" do
game:GetService("ReplicatedStorage").STOP:FireServer(true)
wait(4.1)
end
while _G.OnAbility and CheckGlove() == "Quake" do
game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["start"] = true})
game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["finished"] = true})
task.wait()
end
while _G.OnAbility and CheckGlove() == "Track" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		local Magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
		if Magnitude < 500 then
			table.insert(players, v)
		end
	end
end
if #players ~= 0 then
	local target = players[math.random(#players)]
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer(target.Character)
end
wait(10.1)
end
while _G.OnAbility and CheckGlove() == "Mail" do
game:GetService("ReplicatedStorage").MailSend:FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Shard" do
game:GetService("ReplicatedStorage").Shards:FireServer()
wait(4.1)
end
while _G.OnAbility and CheckGlove() == "fish" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(3.05)
end
while _G.OnAbility and CheckGlove() == "Null" do
game:GetService("ReplicatedStorage").NullAbility:FireServer()
wait(0.01)
end
while _G.OnAbility and CheckGlove() == "Counter" do
game:GetService("ReplicatedStorage").Counter:FireServer()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
task.wait(6.2)
end
while _G.OnAbility and CheckGlove() == "Voodoo" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait(6.27)
end
while _G.OnAbility and CheckGlove() == "Swapper" do
game:GetService("ReplicatedStorage").SLOC:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Gravity" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Bubble" do
game:GetService("ReplicatedStorage").BubbleThrow:FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Slapple" do
game:GetService("ReplicatedStorage").funnyTree:FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Detonator" do
game:GetService("ReplicatedStorage").Fart:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Berserk" do
game:GetService("ReplicatedStorage").BerserkCharge:FireServer(game:GetService("Players").LocalPlayer.Character.Berserk)
wait(2.1)
end
while _G.OnAbility and CheckGlove() == "Rojo" do
game:GetService("ReplicatedStorage"):WaitForChild("RojoAbility"):FireServer("Release", {game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame})
task.wait()
end
while _G.OnAbility and CheckGlove() == "Kinetic" do
OGL = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
for i = 1,100 do
game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
task.wait(0.05)
end
wait(2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OGL
if game.Players.LocalPlayer.Backpack:FindFirstChild("Kinetic") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Kinetic)
end
game:GetService("ReplicatedStorage").KineticExpl:FireServer(game.Players.LocalPlayer.Character.Kinetic, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
wait(2.2)
end
while _G.OnAbility and CheckGlove() == "Dominance" do
game:GetService("ReplicatedStorage").DominanceAc:FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "[REDACTED]" do
game:GetService("ReplicatedStorage").Well:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Duelist" do
game:GetService("ReplicatedStorage").DuelistAbility:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Engineer" do
game:GetService("ReplicatedStorage").Sentry:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Brick" do
game:GetService("ReplicatedStorage").lbrick:FireServer()
game:GetService("Players").LocalPlayer.PlayerGui.BRICKCOUNT.ImageLabel.TextLabel.Text = game:GetService("Players").LocalPlayer.PlayerGui.BRICKCOUNT.ImageLabel.TextLabel.Text + 1
wait(1.1)
end
while _G.OnAbility and CheckGlove() == "Trap" do
game:GetService("ReplicatedStorage").funnyhilariousbeartrap:FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "woah" do
game:GetService("ReplicatedStorage").VineThud:FireServer()
wait(5.1)
end
while _G.OnAbility and CheckGlove() == "Ping Pong" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Recall" do
game:GetService("ReplicatedStorage").Recall:InvokeServer(game:GetService("Players").LocalPlayer.Character.Recall)
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "ZZZZZZZ" do
game:GetService("ReplicatedStorage").ZZZZZZZSleep:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Adios" do
game:GetService("ReplicatedStorage").AdiosActivated:FireServer()
wait(8.3)
end
while _G.OnAbility and CheckGlove() == "Boogie" do
if game.Players.LocalPlayer.Backpack:FindFirstChild("Boogie") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Boogie)
elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Boogie") == nil then
game:GetService("ReplicatedStorage").BoogieBall:FireServer(game.Players.LocalPlayer.Character.Boogie, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Balloony" do
if game.Players.LocalPlayer.Backpack:FindFirstChild("Balloony") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Balloony)
elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Balloony") == nil then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game:GetService("Players").LocalPlayer.Character.Balloony)
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Phase" do
game:GetService("ReplicatedStorage").PhaseA:FireServer()
wait(5.475)
end
while _G.OnAbility and CheckGlove() == "Hallow Jack" do
game:GetService("ReplicatedStorage"):WaitForChild("Hallow"):FireServer()
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Phantom" do
game:GetService("ReplicatedStorage").PhantomDash:InvokeServer(workspace[game.Players.LocalPlayer.Name].Phantom) 
wait()
end
while _G.OnAbility and CheckGlove() == "Sparky" do
game:GetService("ReplicatedStorage").Sparky:FireServer(game:GetService("Players").LocalPlayer.Character.Sparky)
task.wait()
end
while _G.OnAbility and CheckGlove() == "Charge" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game:GetService("Players").LocalPlayer.Character.Charge)
wait(3.1)
end
while _G.OnAbility and CheckGlove() == "Coil" do
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Coil") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer(game:GetService("Players").LocalPlayer.Character.Coil)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 21
wait(3.1)
end
end
while _G.OnAbility and CheckGlove() == "Diamond" do
game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "MEGAROCK" do
game:GetService("ReplicatedStorage"):WaitForChild("Rockmode"):FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Excavator" do
game:GetService("ReplicatedStorage"):WaitForChild("Excavator"):InvokeServer()
game:GetService("ReplicatedStorage"):WaitForChild("ExcavatorCancel"):FireServer()
wait(7.3)
end
while _G.OnAbility and CheckGlove() == "Thor" do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game:GetService("ReplicatedStorage").ThorAbility:FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Meteor" do
game:GetService("ReplicatedStorage"):WaitForChild("GeneralAbility"):FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Sun" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Cast")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Whirlwind" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Guardian Angel" do
game.ReplicatedStorage.GeneralAbility:FireServer(game.Players.LocalPlayer)
task.wait()
end
while _G.OnAbility and CheckGlove() == "Parry" do
game.ReplicatedStorage.GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "MR" do
game:GetService("ReplicatedStorage").Spherify:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Druid" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait(3.21)
end
while _G.OnAbility and CheckGlove() == "Oven" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(target.Character.HumanoidRootPart.CFrame)
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Jester" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Ability1")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Ferryman" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
if game.Players.LocalPlayer.Character:FindFirstChild("FerrymanStaff") and game.Players.LocalPlayer.Character.FerrymanStaff:FindFirstChild("StaffConfig") and game.Players.LocalPlayer.Character.FerrymanStaff.StaffConfig:FindFirstChild("AbilityEvent") then
game.Players.LocalPlayer.Character.FerrymanStaff.StaffConfig.AbilityEvent:FireServer("Leap")
wait(1.85)
game.Players.LocalPlayer.Character.FerrymanStaff.StaffConfig.AbilityEvent:FireServer("FinishLeap",target.Character.HumanoidRootPart.Position)
end
end
task.wait(5)
end
while _G.OnAbility and CheckGlove() == "Scythe" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Blackhole" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Jebaited" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
task.wait()
end
while _G.OnAbility and CheckGlove() == "Blink" do
game:GetService("ReplicatedStorage").Blink:FireServer("OutOfBody", {["dir"] = Vector3.new(0, 0, 0),["ismoving"] = false,["mousebehavior"] = Enum.MouseBehavior.Default})
task.wait()
end
while _G.OnAbility and CheckGlove() == "Joust" do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Start")
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 40
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Slapstick" do
game:GetService("ReplicatedStorage").slapstick:FireServer("charge")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Firework" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Chicken" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Lamp" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "BONK" do
game:GetService("ReplicatedStorage").BONK:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Frostbite" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(3, 3)
task.wait()
end
while _G.OnAbility and CheckGlove() == "Golem" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("recall")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Grab" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Spoonful" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
game:GetService("ReplicatedStorage").GeneralAbility:FireServer({["state"] = "vfx",["origin"] = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(-3.141592502593994, 1.0475832223892212, 3.141592502593994),["vfx"] = "jumptween",["sendplr"] = game:GetService("Players").LocalPlayer})
game:GetService("ReplicatedStorage").GeneralAbility:FireServer({["state"] = "vfx",["cf"] = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(-2.1319260597229004, 0.651054859161377, 2.3744168281555176),["vfx"] = "crash"})
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "el gato" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "UFO" do
if game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s UFO VFX") == nil and game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s UFO") == nil then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
task.wait(0.3)
end
while _G.OnAbility and CheckGlove() == "Hive" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Siphon" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = target.Character.HumanoidRootPart.CFrame})
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Demolition" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("c4")
game:GetService("ReplicatedStorage").Events.c4:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Shotgun" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("buckshot")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Beachball" do
if workspace.Balls:FindFirstChild(game.Players.LocalPlayer.Name.."'s Ball") == nil then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
wait(0.2)
if workspace.Balls:FindFirstChild(game.Players.LocalPlayer.Name.."'s Ball") then
game:GetService("ReplicatedStorage").Events.BeachBall:FireServer(workspace.Balls:FindFirstChild(game.Players.LocalPlayer.Name.."'s Ball"), Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X, 0, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z).Unit * 0.2)
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Water" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("default")
task.wait()
end
while _G.OnAbility and CheckGlove() == "64" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game.Players.LocalPlayer.Character.Head.CFrame * CFrame.new(0, -2, 0) * CFrame.Angles(3.1415927410125732, -1.2705316543579102, 3.1415927410125732))
task.wait()
end
while _G.OnAbility and CheckGlove() == "Fan" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Shackle" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Bind" do
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
local target = players[math.random(#players)]
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("default", {["goal"] = target.Character.HumanoidRootPart.CFrame, ["origin"] = target.Character.Head.CFrame})
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Poltergeist" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("ability2")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Lawnmower" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("lawnmower")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Virus" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Baby" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait(8)
end
while _G.OnAbility and CheckGlove() == "Angler" do
if game.Players.LocalPlayer.Character:FindFirstChild("fishing_rod") then
game:GetService("ReplicatedStorage").Events.Fisherman:FireServer("cast")
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Jerry" do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(-3, 0, -3))
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Snowroller" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(0.3)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("release")
task.wait()
end
while _G.OnAbility and CheckGlove() == "Cherry" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Draw4" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Mouse" do
local function TrapItem(target, item)
	local trapCF = CFrame.new(target.Character.HumanoidRootPart.Position.X, -5.6, target.Character.HumanoidRootPart.Position.Z)
	return {
		cf = trapCF or CFrame.new(),
		data = {
			item = item,
			startcf = CFrame.new(),
			charge = math.huge,
			cf = trapCF or CFrame.new()
		}
	}
end
local players = {}
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true and notSlap(v.Character, BlackList) then
		table.insert(players, v)
	end
end
if #players ~= 0 then
	local target = players[math.random(#players)]
	local randomNum = math.random(1, 58)
	if randomNum >= 50 then
		game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("mousetrap"):FireServer(TrapItem(target, "mouse trap"))
	else
		game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("mousetrap"):FireServer(TrapItem(target, "cheese"))
	end
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Agger" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Debug" do
game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Debug"):FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Medusa" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(true)
task.wait()
end
while _G.OnAbility and CheckGlove() == "Swordfighter" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Hexa" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(true)
task.wait()
end
while _G.OnAbility and CheckGlove() == "Tank" do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait()
end
while _G.OnAbility and CheckGlove() == "Untitled Tag Glove" do
game:GetService("ReplicatedStorage").UTGGeneric:FireServer("enableRunMode")
for i,v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
		if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
			if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude <= 30 then
				game:GetService("ReplicatedStorage").UTGGeneric:FireServer("slideStun", v.Character)
			end
		end
	end
end
task.wait()
end
while _G.OnAbility and CheckGlove() == "Killstreak" and game.Players.LocalPlayer.Character:FindFirstChild("KS250Complete") do
if game.Players.LocalPlayer.Character:FindFirstChild("KS250Complete") then
	game:GetService("ReplicatedStorage").TheForce:FireServer()
	for i,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "Part" then
            v:Destroy()
        end
    end
end
task.wait()
end
    end
}):AddKeyPicker("SpamAbility", {
   Default = "B",
   Text = "Auto Spam Ability",
   Mode = "Toggle",
   SyncToggleState = true
})

if hookmetamethod and getnamecallmethod then
Misc1Basic:AddToggle("Method Glove", {
    Text = "Method Glove",
    Tooltip = "Method: Glovel, Charge, Golden, Psython, Stalker, Frostbite",
    Default = false, 
    Callback = function(Value) 
MethodGlove = Value
while MethodGlove do
if EquipGlove ~= CheckGlove() then
	EquipGlove = CheckGlove()
end
task.wait()
end
    end
})
end

Misc1Basic:AddToggle("Show Button Roll", {
    Text = "Show Button Roll (Custom)",
    Default = false, 
    Callback = function(Value)
ShowButtonU(Value)
    end
})

Misc1Basic:AddToggle("Show Gui Mastery", {
    Text = "Show Gui Mastery (Custom)",
    Default = false, 
    Callback = function(Value)
ShowMasteryGui(Value)
    end
})

local function ResetPreviousGlove()
    if getgenv().GloveHit and getgenv().GloveHitName and getgenv().GloveHit.Parent then
        getgenv().GloveHit.Name = getgenv().GloveHitName
    end
    gloveHits["Default"].Name = "b"
    getgenv().GloveHit = nil
    getgenv().GloveHitName = nil
end
Misc1Basic:AddToggle("Spy Default", {
    Text = "Spy Glove Default",
    Default = false, 
    Callback = function(Value) 
_G.SpyGloveDefault = Value
if not _G.SpyGloveDefault then
    ResetPreviousGlove()
end
if (game.Players.LocalPlayer.Backpack:FindFirstChild("Default") or (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Default"))) and CheckGlove() ~= "Default" then
while _G.SpyGloveDefault and task.wait() do
	if (game.Players.LocalPlayer.Backpack:FindFirstChild("Default") or (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Default"))) and CheckGlove() ~= "Default" then
		local current = CheckGlove()
	    local currentGloveHit = gloveHits[current] or gloveHits["All"]
	    if currentGloveHit then
	        if getgenv().GloveHit and getgenv().GloveHit ~= currentGloveHit then
	            ResetPreviousGlove()
	        end
	        if not getgenv().GloveHit then
	            getgenv().GloveHit = currentGloveHit
	            getgenv().GloveHitName = currentGloveHit.Name
	        end
	        if currentGloveHit.Name ~= "b" then
	            gloveHits["Default"].Name = currentGloveHit.Name
	            currentGloveHit.Name = "b"
	        end
	    else
	        ResetPreviousGlove()
	    end
	else
		ResetPreviousGlove()
	end
end
elseif Value == true then
Notification("You need enter arena default", _G.TimeNotify)
wait(0.05)
Toggles["Spy Default"]:SetValue(false)
end
    end
})

Misc1Basic:AddSlider("Delay Cooldown", {
    Text = "Delay No Cooldown",
    Default = 0.1,
    Min = 0.1,
    Max = 0.9,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.DelayCooldown = Value
    end
})

Misc1Basic:AddToggle("No Cooldown", {
    Text = "No Cooldown",
    Default = false, 
    Callback = function(Value) 
_G.NoCooldown = Value
while _G.NoCooldown do
local Tool = (game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")) or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
local CheckGlove = Tool and Tool:FindFirstChild("Glove")
local CheckLocalScript = CheckGlove and Tool and Tool:FindFirstChildOfClass("LocalScript")
if CheckLocalScript then
	local CloneLocalScript = CheckLocalScript:Clone()
	CheckLocalScript:Destroy()
	CloneLocalScript.Parent = Tool
end
task.wait(_G.DelayCooldown or 0.1)
end
    end
})

Misc1Basic:AddToggle("Infinite Rhythm", {
    Text = "Infinite Rhythm",
    Default = false, 
    Callback = function(Value) 
_G.RhythmNoteSpam = Value
if CheckGlove() == "Rhythm" then
while _G.RhythmNoteSpam do
game.Players.LocalPlayer.PlayerGui.Rhythm.LocalScript.Disabled = false
game.Players.LocalPlayer.PlayerGui.Rhythm.LocalScript.Disabled = true
game.Players.LocalPlayer.Character.Rhythm:Activate()
task.wait()
end
elseif Value == true then
Notification("You don't have Rhythm equipped", _G.TimeNotify)
wait(0.05)
Toggles["Infinite Rhythm"]:SetValue(false)
end
    end
})

Misc1Basic:AddToggle("Auto Fix Generator", {
    Text = "Auto Fix Generator (Shopkeeper)",
    Default = false, 
    Callback = function(Value) 
_G.AutoFixGenerator = Value
if CheckGlove() == "Shopkeeper" then
while _G.AutoFixGenerator do
local shopYouself = workspace:FindFirstChild(game.Players.LocalPlayer.Name.."_shop")
local shopModel = shopYouself and shopYouself:FindFirstChild("shop_model", true) 
local electric = shopModel and shopModel:FindFirstChild("FixTheGenerator", true)
local fixedGenerator = false
if electric and electric.Parent then
	for i, v in pairs(electric.Parent:GetChildren()) do
		if v.Name:lower():find("smoke") then
			fixedGenerator = true
		end
	end
	if fireproximityprompt and fixedGenerator then
		fireproximityprompt(electric, 0)
		fireproximityprompt(electric, 1)
	end
end
task.wait(0.54)
end
elseif Value == true then
Notification("You don't have Shopkeeper equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Fix Generator"]:SetValue(false)
end
    end
})

Misc1Basic:AddDropdown("Aimbot", {
    Text = "Aimbot Glove",
    Values = {"Shard", "Horse", "Retro (Rocket Launcher)", "Scythe", "Tableflip", "Slasher", "G-X"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AimbotGlove = Value
    end
}) 

Misc1Basic:AddDropdown("AimbotCharacter", {
    Text = "Aimbot Character",
    Values = {"Character", "Camera"},
    Default = "Character",
    Multi = false,
    Callback = function(Value)
_G.AimbotCharacter = Value
    end
}) 

Misc1Basic:AddToggle("Aimbot", {
    Text = "Aimbot",
    Default = false, 
    Callback = function(Value) 
_G.Aimbot = Value
    end
})

_G.SharpnessAimbot = 0
Misc1Basic:AddSlider("Sharpness", {
    Text = "Sharpness Aimbot",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.SharpnessAimbot = Value
    end
})

Misc1Basic:AddToggle("No Aimbot", {
    Text = "No Aimbot Friends",
    Default = false, 
    Callback = function(Value) 
_G.AimbotNoFriends = Value
    end
})
function Aimbot(target, prediction)
	local char = game.Players.LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local cam = workspace.CurrentCamera
	local velocity = target.AssemblyLinearVelocity
	local predictedPosition = target.Position + (velocity * prediction)
	if _G.AimbotCharacter == "Camera" then
		cam.CFrame = CFrame.lookAt(cam.CFrame.Position, predictedPosition)
	else
		root.CFrame = CFrame.lookAt(root.Position, Vector3.new(predictedPosition.X, root.Position.Y, predictedPosition.Z))
	end
end
function foundShardYourself()
	local foundShard
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name:lower():find(game.Players.LocalPlayer.Name:lower().." sky shård") then
			foundShard = v
		end
	end
	return foundShard
end
function aimbotTarget()
	local target, targetroot, distance = nil, nil, math.huge
	for i,v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
			if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character:FindFirstChild("Mirage") == nil then
				if v.Character.Head:FindFirstChild("UnoReverseCard") == nil and v:FindFirstChild("leaderstats"):FindFirstChild("Glove") and v.leaderstats.Glove.Value:lower() ~= "parry" then
					local distanceTarget = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
					if distanceTarget and distanceTarget <= distance then
						if not _G.AimbotNoFriends or not game.Players.LocalPlayer:IsFriendsWith(v.UserId) then
							target, targetroot, distance = v.Character, v.Character:FindFirstChild("HumanoidRootPart"), distanceTarget
						end
					end
				end
			end
		end
	end
	return target, targetroot, distance
end
spawn(function()
table.insert(_G.ConnectFun, game:GetService("RunService").Heartbeat:Connect(function()
	if not _G.Aimbot then return end
	local char = game.Players.LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	local AnimationTrack = hum and hum:FindFirstChildOfClass("Animator")
	local target, targetroot, distance = aimbotTarget()
	local AimbotEnable
	if root and targetroot then
		if char and not char:FindFirstChild("stevebody") and not char:FindFirstChild("rock") and char:FindFirstChild("Ragdolled") and not char.Ragdolled.Value then
			if _G.AimbotGlove == "Horse" and CheckGlove():lower():find("horse") then
				if (char:FindFirstChild("Horse") and char.Horse:FindFirstChild("RootPart")) or char:FindFirstChild("Lance") then
					AimbotEnable = true
				end
			end
			if _G.AimbotGlove == "Shard" and CheckGlove():lower():find("shard") then
				local foundShard = foundShardYourself()
				if foundShard then
					AimbotEnable = true
				end
			end
			if _G.AimbotGlove == "Retro (Rocket Launcher)" and CheckGlove():lower():find("retro") then
				if char:FindFirstChild("Rocket Launcher") then
					AimbotEnable = true
				end
			end
			if (_G.AimbotGlove == "Scythe" and CheckGlove():lower():find("scythe")) or (_G.AimbotGlove == "Slasher" and CheckGlove():lower():find("slasher")) or (_G.AimbotGlove == "G-X" and CheckGlove():lower():find("g-x")) then
				if AnimationTrack then
					for _, v in ipairs(AnimationTrack:GetPlayingAnimationTracks()) do
						local idAnim = v.Animation.AnimationId:match("%d+")
						if _G.AimbotGlove == "Scythe" and CheckGlove():lower():find("scythe") then
							if idAnim:find("15505686151") then
								AimbotEnable = true
							end
						end
						if _G.AimbotGlove == "G-X" and CheckGlove():lower():find("g-x") then
							if idAnim:find("102526718788106") then
								AimbotEnable = true
							end
						end
						if _G.AimbotGlove == "Slasher" and CheckGlove():lower():find("slasher") then
							if (idAnim:find("123476113915973") or idAnim:find("79720215321255")) and not idAnim:find("136125547655440") then
								AimbotEnable = true
							end
						end
					end
				end
			end
			if _G.AimbotGlove == "Tableflip" and CheckGlove():lower():find("tableflip") then
				for i, v in pairs(workspace:GetChildren()) do
					if v.Name:lower():find("tableobject") and v:FindFirstChild("TableOwner") and v.TableOwner.Value:find(game.Players.LocalPlayer.Name) then
						if (root.Position - v.Position).Magnitude <= 7 then
							AimbotEnable = true
							break
						end
					end
				end
			end
			if AimbotEnable and targetroot then
				if _G.AimbotCharacter ~= "Camera" then
					if not AutoRotate and hum then
				        AutoRotate = hum.AutoRotate
						hum.AutoRotate = false
				    end
				end
				Aimbot(targetroot, _G.SharpnessAimbot)
			else
				if AutoRotate and hum then
			        hum.AutoRotate = AutoRotate
					AutoRotate = nil
			    end
			end
		end
	end
end))
end)

Misc1Basic:AddSlider("Parry Range", {
    Text = "Range Parry (Distance)",
    Default = 15,
    Min = 10,
    Max = 35,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.RangeParry = Value
    end
})

Misc1Basic:AddToggle("Direction check", {
    Text = "Direction Check",
    Default = false, 
    Callback = function(Value) 
_G.DirectionCheck = Value
    end
})

local Players = game:GetService("Players")
Misc1Basic:AddToggle("Auto Parry", {
    Text = "Auto Parry (Block)",
    Default = false, 
    Callback = function(Value) 
if CheckGlove() == "Parry" then
_G.AutoParry = Value
if Value then
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer then
			SetupPlayer(v)
		end
	end
end
elseif Value == true then
Notification("You don't have Parry equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Parry"]:SetValue(false)
end
    end
})

Misc1Basic:AddToggle("Auto Counter", {
    Text = "Auto Counter",
    Default = false, 
    Callback = function(Value) 
if CheckGlove() == "Counter" then
_G.AutoCounter = Value
if Value then
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer then
			SetupPlayer(v)
		end
	end
end
elseif Value == true then
Notification("You don't have Counter equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Counter"]:SetValue(false)
end
    end
})
spawn(function()
local function SetupCharacter(plr, char)
	local humanoid = char:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")
	animator.AnimationPlayed:Connect(function(track)
		if not (_G.AutoParry or _G.AutoCounter) then return end
		if CheckGlove() ~= "Parry" and CheckGlove() ~= "Counter" then return end
		if char:FindFirstChild("entered") and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("stevebody") == nil and char:FindFirstChild("rock") == nil and char.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and char:FindFirstChild("Mirage") == nil then
			if char.Head:FindFirstChild("UnoReverseCard") == nil then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local root = game.Players.LocalPlayer.Character.HumanoidRootPart
				local direction = (hrp.Position - root.Position).Unit
				local dot = root.CFrame.LookVector:Dot(direction)
				if AnimationSlapHit[tostring(track.Animation.AnimationId):match("%d+")] and (not _G.DirectionCheck or dot > 0.3) then
				    if (root.Position - (hrp.Position + hrp.Velocity * 0.12)).Magnitude <= (_G.RangeParry or 18) then
						task.spawn(function()
							if CheckGlove() == "Parry" then
								game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
							end
							if CheckGlove() == "Counter" then
								game:GetService("ReplicatedStorage"):WaitForChild("Counter"):FireServer()
							end
							if game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()) then
								game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()))
							end
						end)
				    end
				end
			end
		end
	end)
end
function SetupPlayer(plr)
	plr.CharacterAdded:Connect(function(char)
		SetupCharacter(plr, char)
	end)
	if plr.Character then
		SetupCharacter(plr, plr.Character)
	end
end
for _, v in pairs(Players:GetPlayers()) do
	if v ~= Players.LocalPlayer then
		SetupPlayer(v)
	end
end
Players.PlayerAdded:Connect(function(plr)
	if plr ~= Players.LocalPlayer then
		SetupPlayer(plr)
	end
end)
table.insert(_G.ConnectFun, game:GetService("RunService").Heartbeat:Connect(function()
	if not _G.AutoParry or not _G.AutoCounter then return end
	if CheckGlove() ~= "Parry" or CheckGlove() ~= "Counter" then return end
	if not game.Players.LocalPlayer.Character or not game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	local dis
	for i,v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
			local hrp = v.Character:FindFirstChild("HumanoidRootPart")
			local root = game.Players.LocalPlayer.Character.HumanoidRootPart
			local direction = root and hrp and (hrp.Position - root.Position).Unit
			local dot = root and direction and root.CFrame.LookVector:Dot(direction)
			local glove = v.Character:FindFirstChild(v.leaderstats.Glove.Value) and v.Character[v.leaderstats.Glove.Value]:FindFirstChild("Glove")
			if glove and v.leaderstats.Glove.Value:lower() == "overkill" and dot and dot > 0.3 then
				if (root.Position - (hrp.Position + hrp.Velocity * 0.12)).Magnitude <= (_G.RangeParry or 18) then
					if CheckGlove() == "Parry" then
						game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
					end
					if CheckGlove() == "Counter" then
						game:GetService("ReplicatedStorage"):WaitForChild("Counter"):FireServer()
					end
					if game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()) then
						game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()))
					end
	            end
			end
			if root and hrp and v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and hrp.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
				if (v.Character:FindFirstChild("Horse") and v.Character.Horse:FindFirstChild("RootPart")) or v.Character:FindFirstChild("Lance") then
					if v.Character:FindFirstChild("Lance") then
						dis = (root.Position - v.Character:FindFirstChild("Lance").Position).Magnitude
					else
						dis = (root.Position - v.Character.Horse:FindFirstChild("RootPart").Position).Magnitude
					end
					if tonumber(dis) and dis <= (_G.RangeParry or 20) then
						if _G.AutoParry then
							if CheckGlove() == "Parry" then
								game:GetService("ReplicatedStorage"):WaitForChild("Counter"):FireServer()
							end
							if game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()) then
								game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()))
							end
                        end
					end
				end
			end
		end
	end
	for i, v in pairs(workspace:GetChildren()) do
		if v.Name:match("Slicer_Hitbox") then
			if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 18 then
				if game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()) then
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild(CheckGlove()))
				end
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
            end
		end
	end
end))
end)

Misc1Basic:AddToggle("Auto Play Rhythm", {
    Text = "Auto Play Rhythm",
    Default = false, 
    Callback = function(Value) 
if CheckGlove() ~= "Rhythm" and Value == true then
Notification("You don't have Rhythm equipped", _G.TimeNotify)
wait(0.05)
Toggles["Infinite Rhythm"]:SetValue(false)
end
    end
})
local bar = {}
table.insert(_G.ConnectFun, game:GetService("RunService").Heartbeat:Connect(function()
	if not Toggles["Auto Play Rhythm"] or not Toggles["Auto Play Rhythm"].Value then return end
	local rhythmGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Rhythm")
	local mainRhythm = (rhythmGui and rhythmGui:FindFirstChild("MainFrame"))
	if not mainRhythm then return end
	local pointer = mainRhythm:FindFirstChild("Pointer")
	local bars = mainRhythm:FindFirstChild("Bars")
	if not pointer or not bars then return end
	for _, v in ipairs(bars:GetChildren()) do
		if v:IsA("Frame") and v.Name ~= "BarHit" then
			local id = v:GetDebugId(5)
			local aPos, aSize = pointer.AbsolutePosition, pointer.AbsoluteSize
			local bPos, bSize = v.AbsolutePosition, v.AbsoluteSize
			local over = not (aPos.X + aSize.X < bPos.X or aPos.X > bPos.X + bSize.X or aPos.Y + aSize.Y < bPos.Y or aPos.Y > bPos.Y + bSize.Y)
			if over and not bar[id] then
				bar[id] = true
				if game.Players.LocalPlayer.Character:FindFirstChild("Rhythm") then
					game.Players.LocalPlayer.Character:FindFirstChild("Rhythm"):Activate()
				end
			elseif not over then
				bar[id] = false
			end
		end
	end
end))

Misc1Basic:AddButton("Get All Sword", function()
if CheckGlove() == "Swordfighter" then
for i,v in pairs({"Ice Dagger", "Darkheart", "Ghostwalker", "Venomshank", "Windforce", "Illumina", "Firebrand"}) do
game:GetService("ReplicatedStorage").Events.swordevent:FireServer("AddSword", v)
end
else
Notification("You don't have Swordfighter equipped", _G.TimeNotify)
end
end)

Misc1Basic:AddDropdown("ArenaEnter", {
    Text = "Enter",
    Values = {"Arena", "Arena Default"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AutoEnter = Value
    end
})

 Misc1Basic:AddToggle("Auto Enter", {
    Text = "Auto Enter",
    Default = false, 
    Callback = function(Value) 
_G.AutoEnterJoin = Value
while _G.AutoEnterJoin do
if _G.AutoEnter == "Arena" then
	EnterPo = workspace.Lobby:FindFirstChild("Teleport1")
elseif _G.AutoEnter == "Arena Default" then
	EnterPo = workspace.Lobby:FindFirstChild("Teleport2")
end
if EnterPo then
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		repeat task.wait()
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, EnterPo, 0)
				firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, EnterPo, 1)
			end
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	end
end
task.wait()
end
    end
})

_G.SlapAuraCharacter = "HumanoidRootPart"
_G.ReachSlapArua = 25
_G.DelaySlapArua = 0.35
_G.SlapAuraFriend = "Fight"
_G.SlapAuraChoose = "Normal"
_G.WidthHitbox = 15
_G.LengthHitbox = 10

Misc1Basic:AddSlider("Reach Aura", {
    Text = "Reach Slap Aura",
    Default = 25,
    Min = 10,
    Max = 50,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ReachSlapArua = Value
    end
})

Misc1Basic:AddSlider("Delay Aura", {
    Text = "Delay Slap Aura",
    Default = 0.75,
    Min = 0.35,
    Max = 1,
    Rounding = 2,
    Compact = true,
    Callback = function(Value)
_G.DelaySlapArua = Value
    end
})

 Misc1Basic:AddDropdown("Slap Friend", {
    Text = "Slap Aura Friend",
    Values = {"Fight", "Not Fight"},
    Default = "Fight",
    Multi = false,
    Callback = function(Value)
_G.SlapAuraFriend = Value
    end
})

 Misc1Basic:AddDropdown("ChooseCharacter", {
    Text = "Slap Aura Character",
    Values = {"HumanoidRootPart", "Head", "Left Arm", "Left Leg", "Right Arm", "Right Leg"},
    Default = "HumanoidRootPart",
    Multi = false,
    Callback = function(Value)
_G.SlapAuraCharacter = Value
    end
})

 Misc1Basic:AddDropdown("Slap Aura Mode", {
    Text = "Slap Aura Mode",
    Values = {"Normal", "Target", "Reverse", "Hitbox"},
    Default = "Normal",
    Multi = false,
    Callback = function(Value)
_G.SlapAuraChoose = Value
    end
})

local SlapAuraDependencyBox = Misc1Basic:AddDependencyBox()

SlapAuraDependencyBox:SetupDependencies({
	{Options["Slap Aura Mode"], "Hitbox"}
})

SlapAuraDependencyBox:AddDivider()

SlapAuraDependencyBox:AddSlider("Width Hitbox", {
    Text = "Width Hitbox",
    Default = 15,
    Min = 10,
    Max = 30,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.WidthHitbox = Value
    end
})

SlapAuraDependencyBox:AddSlider("Length Hitbox", {
    Text = "Length Hitbox",
    Default = 10,
    Min = 10,
    Max = 30,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.LengthHitbox = Value
    end
})

SlapAuraDependencyBox:AddDivider()

function checkRagdollBaseFake(char)
	for i, v in pairs(char:GetChildren()) do
		if v:IsA("BasePart") and v.Name:lower():find("fake") then
			return false
		end
	end
	return true
end
function SlapHitbox()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local ToolGlove = char:FindFirstChildOfClass("Tool") 
    local GlovePart = ToolGlove and ToolGlove:FindFirstChild("Glove")
    if not (ToolGlove and GlovePart) then return end
    local ToolPos = GlovePart.Position
    local FaceRotation = CFrame.new(root.Position, root.Position + root.CFrame.LookVector)
    local offsetZ = -(_G.LengthHitbox / 2) - 1
    local FinalCFrame = CFrame.new(ToolPos) * FaceRotation.Rotation * CFrame.new(0, 0, offsetZ)
    local CurrentHitbox = Create("Part", {
        Name = "SlapZone", 
        Size = Vector3.new(_G.WidthHitbox, 8, _G.LengthHitbox),
        Anchored = true,
        CanCollide = false,
        CanTouch = false,
        CanQuery = false,
        Material = Enum.Material.ForceField,
        Transparency = 0.5,
        Color = Color3.fromRGB(255,0,0),
        CFrame = FinalCFrame,
        Parent = workspace
    })
    local HitPlayer = false
    if workspace:FindFirstChild("cherry_storage") then
        for _, v in pairs(workspace.cherry_storage:GetChildren()) do
            if string.find(v.Name, "Cherry") and v:FindFirstChild("HumanoidRootPart") then
                if InsideBox(v.HumanoidRootPart, CurrentHitbox) then
                    HitPlayer = true
                    slapglove(v.HumanoidRootPart)
                end
            end
        end
    end
    for _, c in pairs(workspace:GetChildren()) do
        if string.find(c.Name, "Å") and c:FindFirstChild("HumanoidRootPart") then
            if InsideBox(c.HumanoidRootPart, CurrentHitbox) then
                HitPlayer = true
                slapglove(c.HumanoidRootPart)
            end
        end
        if c.Name == "Balls" then
            for _, z in pairs(c:GetChildren()) do
                if string.find(z.Name, "'s Ball") then
                    if InsideBox(z, CurrentHitbox) then
                        HitPlayer = true
                        slapglove(z)
                    end
                end
            end
        end
    end
    if not HitPlayer then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local targetChar = v.Character
                if targetChar:FindFirstChild("entered") and targetChar:FindFirstChild("Humanoid") and targetChar:FindFirstChild("Ragdolled") and notSlap(targetChar, BlackList) and targetChar.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and (targetChar.Ragdolled.Value == false or checkRagdollBaseFake(targetChar)) then
                    if targetChar.Head:FindFirstChild("UnoReverseCard") == nil or CheckGlove() == "Error" then
                        if targetChar.Humanoid.Health > 0 then
                            if InsideBox(targetChar.HumanoidRootPart, CurrentHitbox) then
                                HitPlayer = true
                                slapglove(targetChar.HumanoidRootPart)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    if HitPlayer then
        CurrentHitbox.Color = Color3.fromRGB(0,255,0)
    else
        CurrentHitbox.Color = Color3.fromRGB(255,0,0)
    end
    task.delay(0.45, function()
        if CurrentHitbox then
            CurrentHitbox:Destroy()
        end
    end)
    return HitPlayer
end
local Cooldown = false
local function IsSlapping(humanoid)
    local activeTracks = humanoid:GetPlayingAnimationTracks()
    for _, track in pairs(activeTracks) do
        local id = tostring(track.Animation.AnimationId):match("%d+")
        if AnimationSlapHit[id] and track.TimePosition < 0.75 then
            return true
        end
    end
    return false
end
table.insert(_G.ConnectFun, game:GetService("RunService").Heartbeat:Connect(function()
    if not (_G.SlapAura and _G.SlapAuraChoose == "Hitbox") then return end
    local player = game.Players.LocalPlayer
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local ragdoll = char and char:FindFirstChild("Ragdolled")
    if not char or not hum then return end
    local ToolGlove = char:FindFirstChildOfClass("Tool") 
    if ToolGlove and ToolGlove:FindFirstChild("Glove") then
        if ToolGlove:GetAttribute("CustomActivatedEnabled") then return end
        ToolGlove:SetAttribute("CustomActivatedEnabled", true)
        local UserInputService = game:GetService("UserInputService")
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if ToolGlove.Parent == char and not Cooldown then
                    task.wait(0.05) 
                    if IsSlapping(hum) then
                        Cooldown = true
                        task.spawn(function()
	                        for i = 1, 15 do
	                            if ToolGlove.Parent == char and IsSlapping(hum) and ragdoll and not ragdoll.Value and (_G.SlapAura and _G.SlapAuraChoose == "Hitbox") then
		                            local hasHit = SlapHitbox() 
							        if hasHit then 
							            break 
							        end
	                                task.wait()
	                            end
							end
                            Cooldown = false
                        end)
                    end
                end
            end
        end)
        ToolGlove.Unequipped:Connect(function()
            ToolGlove:SetAttribute("CustomActivatedEnabled", nil)
            if connection then connection:Disconnect() end
            Cooldown = false
        end)
    end
end))

Misc1Basic:AddToggle("Slap Aura", {
    Text = "Slap Aura",
    Default = false, 
    Callback = function(Value) 
_G.SlapAura = Value
task.spawn(function()
    while _G.SlapAura do
        local function PlayerTarget(slap)
			local Target
			for i,v in pairs(game.Players:GetChildren()) do
				if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
					if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and notSlap(v.Character, BlackList) and (tonumber(_G.DelaySlapArua) > 0.7 or (v.Character.Ragdolled.Value == false or checkRagdollBaseFake(v.Character))) then
						if v.Character.Head:FindFirstChild("UnoReverseCard") == nil or CheckGlove() == "Error" then
							if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude then
								if _G.SlapAuraFriend == "Fight" or (_G.SlapAuraFriend == "Not Fight" and not game.Players.LocalPlayer:IsFriendsWith(v.UserId)) then
									Target = v.Character:WaitForChild(_G.SlapAuraCharacter)
									if slap and Target then
										slapglove(Target)
									end
								end
							end
						end
					end
				end
			end
			return Target
		end
        if _G.SlapAuraChoose == "Target" then
            local target = PlayerTarget(false)
            if target then
                slapglove(target)
            end
        elseif _G.SlapAuraChoose == "Normal" then
            PlayerTarget(true)
        end
        task.wait(tonumber(_G.DelaySlapArua) or 0.05)
    end
end)
while _G.SlapAura do
if _G.SlapAuraChoose == "Normal" then
	if workspace:FindFirstChild("cherry_storage") then
		for i, v in pairs(workspace.cherry_storage:GetChildren()) do
			if string.find(v.Name, "Cherry") and v:FindFirstChild("HumanoidRootPart") then
				if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude then
					slapglove(v:WaitForChild(_G.SlapAuraCharacter))
				end
			end
		end
	end
	for i, c in pairs(workspace:GetChildren()) do
		if string.find(c.Name, "Å") and c:FindFirstChild("HumanoidRootPart") then
			if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - c.HumanoidRootPart.Position).Magnitude then
				slapglove(c:WaitForChild(_G.SlapAuraCharacter))
			end
		end
		if c.Name == "Balls" then
			for i, z in pairs(c:GetChildren()) do
				if string.find(z.Name, "'s Ball") then
					if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - z.Position).Magnitude then
						game:GetService("ReplicatedStorage").Events.BeachBall:FireServer(z, Vector3.new(game:GetService("Workspace").CurrentCamera.CFrame.LookVector.X, 0, game:GetService("Workspace").CurrentCamera.CFrame.LookVector.Z).Unit * 0.2)
					end
				end
			end
		end
	end
elseif _G.SlapAuraChoose == "Reverse" then
	if CheckGlove() == "Reverse" then
		for i,v in pairs(game.Players:GetChildren()) do
			if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
				if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and notSlap(targetChar, {"stevebody", "rock", "Counterd", "Mirage"}) then
					if v.Character.Head:FindFirstChild("UnoReverseCard") and game.Players.LocalPlayer.Character.Head:FindFirstChild("UnoReverseCard") then
						if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude then
							if _G.SlapAuraFriend == "Fight" or (_G.SlapAuraFriend == "Not Fight" and not game.Players.LocalPlayer:IsFriendsWith(v.UserId)) then
								slapglove(v.Character:WaitForChild(_G.SlapAuraCharacter))
							end
						end
					end
				end
			end
		end
	end
end
task.wait()
end
    end
}):AddKeyPicker("SlapAura", {
   Default = "H",
   Text = "Slap Aura",
   Mode = "Toggle",
   SyncToggleState = true
})

_G.ReachShukuchi = 50
_G.ShukuchiFriend = "Fight"

 Misc1Basic:AddSlider("Reach Shukuchi", {
    Text = "Reach Shukuchi",
    Default = 50,
    Min = 1,
    Max = 130,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ReachShukuchi = Value
    end
})

 Misc1Basic:AddDropdown("Shukuchi Friend", {
    Text = "Shukuchi Friend",
    Values = {"Fight", "Not Fight"},
    Default = "Fight",
    Multi = false,
    Callback = function(Value)
_G.ShukuchiFriend = Value
    end
})

 Misc1Basic:AddToggle("Auto Shukuchi Player", {
    Text = "Auto Shukuchi Player",
    Default = false, 
    Callback = function(Value) 
_G.AutoShukuchi = Value
if CheckGlove() == "Shukuchi" then
while _G.AutoShukuchi do
	for i,v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
			if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and notSlap(v.Character, BlackList) then
				if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude then
					if _G.ShukuchiFriend == "Fight" or (_G.ShukuchiFriend == "Not Fight" and not game.Players.LocalPlayer:IsFriendsWith(v.UserId)) then
						game:GetService("ReplicatedStorage").SM:FireServer(v)
					end
				end
			end
		end
	end
task.wait()
end
elseif _G.AutoShukuchi == true then
Notification("You don't have Shukuchi equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Shukuchi Player"]:SetValue(false)
end
    end
})

_G.ReachHitbox = 10
 Misc1Basic:AddSlider("Reach HitBox", {
    Text = "Reach Hitbox",
    Default = 10,
    Min = 4,
    Max = 30,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ReachHitbox = Value
    end
})

local function GetAllLeashedPlayers()
    local leashMap = {}
    for _, player in ipairs(game.Players:GetPlayers()) do
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local leash = hrp and hrp:FindFirstChild("LeashRope")
        if leash and leash.Attachment1 then
            local targetCharacter = leash.Attachment1:FindFirstAncestorOfClass("Model")
            local leashedPlayer = targetCharacter and game.Players:GetPlayerFromCharacter(targetCharacter)
            if leashedPlayer then
                leashMap[leashedPlayer] = player
            end
        end
    end
    return leashMap
end
Misc1Basic:AddToggle("Hitbox Player Mod", {
    Text = "Hitbox Player & Mod",
    Default = false, 
    Callback = function(Value) 
_G.HitboxPlayer = Value
while _G.HitboxPlayer do
local leashPlr = GetAllLeashedPlayers()
for i,v in pairs(game.Players:GetChildren()) do
    if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
	    local seat = (v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Sit and v.Character:FindFirstChild("Humanoid").SeatPart) or nil
        local amILeashingThem = (leashPlr[v] == game.Players.LocalPlayer)
	    if not v.Character:FindFirstChild("Horse") and notSlap(v.Character, BlackList) and not amILeashingThem and not seat then
		    v.Character.HumanoidRootPart.Size = Vector3.new(_G.ReachHitbox,_G.ReachHitbox,_G.ReachHitbox)
		    v.Character.HumanoidRootPart.Transparency = 0.75
		else
			v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
	        v.Character.HumanoidRootPart.Transparency = 1
		end
    end
end
for i, c in pairs(workspace:GetChildren()) do
	if string.find(c.Name, "Å") and c:FindFirstChild("HumanoidRootPart") then
		c.HumanoidRootPart.Size = Vector3.new(_G.ReachHitbox,_G.ReachHitbox,_G.ReachHitbox)
		c.HumanoidRootPart.Transparency = 0.75
	end
end
task.wait()
end
if _G.HitboxPlayer == false then
	for i,v in pairs(game.Players:GetChildren()) do
	    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
	        v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
	        v.Character.HumanoidRootPart.Transparency = 1
	    end
	end
	for i, c in pairs(workspace:GetChildren()) do
		if string.find(c.Name, "Å") and c:FindFirstChild("HumanoidRootPart") then
			c.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
			c.HumanoidRootPart.Transparency = 1
		end
	end
end
    end
}):AddKeyPicker("Hitbox", {
   Default = "Z",
   Text = "Hitbox Player & Mod",
   Mode = "Toggle",
   SyncToggleState = true
})

_G.GloveExtendReach = 5
Misc1Basic:AddSlider("Extend Glove", {
    Text = "Extend Glove",
    Default = 5,
    Min = 2,
    Max = 20,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.GloveExtendReach = Value
    end
})

 Misc1Basic:AddDropdown("Extend Option", {
    Text = "Extend Option",
    Values = {"Meat Stick","Pancake","Growth","North Korea Wall","Slight Extend"},
    Default = "",
    Multi = false,
    Callback = function(Value)
GloveExtendOption = Value
    end
})

 Misc1Basic:AddToggle("Extend Glove", {
    Text = "Extend Glove",
    Default = false, 
    Callback = function(Value) 
_G.GloveExtendGet = Value
if _G.GloveExtendGet == false then
	local function GloveOff(v)
		if v:IsA("Tool") and v:FindFirstChild("Glove") then
	        v:FindFirstChild("Glove").Size = Vector3.new(2.5, 2.5, 1.7)
	        v:FindFirstChild("Glove").Transparency = 0
	    end
	end
	for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		GloveOff(v)
	end
	for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		GloveOff(v)
	end
end
while _G.GloveExtendGet do
local function GloveReachOn(v)
	if v.ClassName == "Tool" and v:FindFirstChild("Glove") then
        if GloveExtendOption == "Meat Stick" then
	        GloveReachTo = Vector3.new(0, _G.GloveExtendReach, 2)
        elseif GloveExtendOption == "Pancake" then
	        GloveReachTo = Vector3.new(0, _G.GloveExtendReach, _G.GloveExtendReach)
        elseif GloveExtendOption == "Growth" then
	        GloveReachTo = Vector3.new(_G.GloveExtendReach,_G.GloveExtendReach,_G.GloveExtendReach)
        elseif GloveExtendOption == "North Korea Wall" then
	        GloveReachTo = Vector3.new(_G.GloveExtendReach,0,_G.GloveExtendReach)
        elseif GloveExtendOption == "Slight Extend" then
	        GloveReachTo = Vector3.new(_G.GloveExtendReach, _G.GloveExtendReach, tonumber(_G.GloveExtendReach..".7"))
		end
		if GloveReachTo then
			v:FindFirstChild("Glove").Size = GloveReachTo
		end
    end
end
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	GloveReachOn(v)
end
for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	GloveReachOn(v)
end
task.wait()
end
    end
}):AddKeyPicker("ExtendGlove", {
   Default = "C",
   Text = "Extend Glove",
   Mode = "Toggle",
   SyncToggleState = true
})

 Misc1Basic:AddInput("Auto Change Nametag", {
    Default = "Change Nametag...",
    Numeric = false,
    Text = "Change Name",
    Placeholder = "Change",
    Callback = function(Value)
_G.FakeName = Value
    end
})

 Misc1Basic:AddToggle("NameTag", {
    Text = "Auto Set NameTag",
    Default = false, 
    Callback = function(Value) 
_G.AutoSetNameTag = Value
while _G.AutoSetNameTag do
if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character.Head:FindFirstChild("Nametag") then
	if game.Players.LocalPlayer.Character.Head.Nametag:FindFirstChild("Labels") then
		for i, v in pairs(game.Players.LocalPlayer.Character.Head.Nametag.Labels:GetChildren()) do
			if v:IsA("TextLabel") then
				v.Text = _G.FakeName
			end
		end
	end
end
task.wait()
end
    end
})

Misc1Basic:AddInput("Auto Change Slap", {
    Default = "Change Slap...",
    Numeric = false,
    Text = "Change Slap / Random",
    Placeholder = "Change",
    Callback = function(Value)
_G.FakeSlap = Value
    end
})

Misc1Basic:AddToggle("SlapFake", {
    Text = "Auto Set Slap",
    Default = false, 
    Callback = function(Value) 
_G.AutoChangeSlapFake = Value
while _G.AutoChangeSlapFake do
if game.Players.LocalPlayer.leaderstats.Slaps.Value ~= _G.FakeSlap then
game.Players.LocalPlayer.leaderstats.Slaps.Value = _G.FakeSlap
end
task.wait()
end
    end
})

Misc1Basic:AddToggle("Auto Set Random Slap", {
    Text = "Auto Set Random Slap",
    Default = false, 
    Callback = function(Value) 
_G.AutoChangeSlapFake = Value
while _G.AutoChangeSlapFake do
if game.Players.LocalPlayer.leaderstats:FindFirstChild("Slaps") then
local random = math.random(0, (_G.FakeSlap or 9e9))
game.Players.LocalPlayer.leaderstats.Slaps.Value = random
end
task.wait()
end
    end
})

Misc1Basic:AddInput("Auto Change Glove", {
    Default = "Change Glove...",
    Numeric = false,
    Text = "Change Glove",
    Placeholder = "Change",
    Callback = function(Value)
_G.FakeGlove = Value
    end
})

 Misc1Basic:AddToggle("GloveFake", {
    Text = "Auto Set Glove",
    Default = false, 
    Callback = function(Value) 
_G.AutoChangeSlapFake = Value
while _G.AutoChangeSlapFake do
if game.Players.LocalPlayer.leaderstats.Glove.Value ~= _G.FakeGlove then
game.Players.LocalPlayer.leaderstats.Glove.Value = _G.FakeGlove
end
task.wait()
end
    end
})

Misc1Basic:AddDropdown("Tycoon", {
    Text = "Tycoon",
    Values = {"All","Your","Other"},
    Default = "All",
    Multi = false,
    Callback = function(Value)
_G.TycoonAuto = Value
    end
})

Misc1Basic:AddToggle("Bring Drop End", {
    Text = "Bring Drop End (Network Owner)",
    Default = false, 
    Callback = function(Value) 
_G.DropEndTycoon = Value
    end
})

Misc1Basic:AddToggle("Click Tycoon", {
    Text = "Auto Click Tycoon",
    Default = false, 
    Callback = function(Value) 
_G.AutoClickTycoon = Value
while _G.AutoClickTycoon do
local function BringDrop(drop)
	if _G.DropEndTycoon then
		if drop and drop:FindFirstChild("End") and drop.End:IsA("BasePart") then
			for i,x in pairs(drop:GetChildren()) do
				if x.Name:lower() == "tycoondrop" and IsNetworkOwner(x) then
					x.CFrame = drop.End.CFrame
				end
			end
		end
	end
end
for _, v in pairs(workspace:GetChildren()) do
    local hasClick = v:FindFirstChild("Click")
    if hasClick then
	    local isTycoon = v.Name:find("Tycoon")
	    local isYour = v.Name:match(game.Players.LocalPlayer.Name)
	    if (_G.TycoonAuto == "All" and isTycoon) or (_G.TycoonAuto == "Your" and isYour) or (_G.TycoonAuto == "Other" and isTycoon and not isYour) then
	        BringDrop(v)
	        local cd = hasClick:FindFirstChildOfClass("ClickDetector")
	        if cd then
	            fireclickdetector(cd, 0)
	            fireclickdetector(cd, 1)
	        end
	    end
	end
end
task.wait()
end
    end
})

Misc1Basic:AddToggle("Auto Destroy Tycoon", {
    Text = "Auto Destroy Tycoon",
    Default = false, 
    Callback = function(Value) 
_G.AutoDestroyTycoon = Value
while _G.AutoDestroyTycoon do
for _, v in pairs(workspace:GetChildren()) do
	if v:FindFirstChild("Destruct") then
		local isTycoon = v.Name:find("Tycoon")
		local isYourTycoon = v.Name:match(game.Players.LocalPlayer.Name)
		if (_G.TycoonAuto == "All" and isTycoon) or (_G.TycoonAuto == "Your" and isYourTycoon) or (_G.TycoonAuto == "Other" and isTycoon and not isYourTycoon) then
			fireclickdetector(v.Destruct.ClickDetector,0)
			fireclickdetector(v.Destruct.ClickDetector,1)
		end
	end
end
task.wait()
end
    end
})

local Misc2Esp = TabBoxMisc1:AddTab("Esp")

local Connected = {}
function EspAdd(object, name, color)
    if not Connected[object] then
        Connected[object] = true
        object.AncestryChanged:Connect(function(_, parent)
            if not parent then
                Connected[object] = nil
                ESPLibrary:RemoveESP(object)
            end
        end)
    end
    ESPLibrary:AddESP({
        Object = object,
        Text = name,
        Color = color
    })
end

function UpdateEsp(object, name, color)
	if object and object.Parent then
		ESPLibrary:UpdateObjectText(object, name)
		ESPLibrary:UpdateObjectColor(object, color)
		ESPLibrary:SetOutlineColor(color)
	end
end

Misc2Esp:AddToggle("Esp Glove", {
    Text = "Esp Glove",
    Default = false, 
    Callback = function(Value) 
_G.EspPlayer = Value
if not _G.EspPlayer then
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
			ESPLibrary:RemoveESP(v.Character)
		end
	end
end
while _G.EspPlayer do
local ColorESP0 = _G.ColorESP or Color3.new(255,255,255)
for i, v in ipairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		EspAdd(v.Character, v.leaderstats.Glove.Value, ColorESP0)
		UpdateEsp(v.Character, v.leaderstats.Glove.Value, ColorESP0)
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.ColorESP = Value
     end
})

Misc2Esp:AddDropdown("Esp Object", {
    Text = "Esp",
    Values = {"Orb", "Toolbox", "Gravestone", "Gift", "Keypad"},
    Default = {"Orb"},
    Multi = true,
    Callback = function(Value)
_G.EspObject = Value
    end
})

local espColor = {
	["orb"] = Color3.fromRGB(20, 107, 247),
	["toolbox"] = Color3.fromRGB(232, 210, 44),
	["gravestone"] = Color3.fromRGB(204, 40, 35),
	["gift"] = Color3.fromRGB(51, 189, 69),
	["keypad"] = Color3.fromRGB(32, 214, 190),
}

Misc2Esp:AddToggle("Esp", {
    Text = "Start Esp",
    Default = false, 
    Callback = function(Value) 
_G.EspObject = Value
for i, v in pairs(workspace:GetChildren()) do
	for _, j in pairs({"Orb", "Toolbox", "Gravestone", "Gift", "Keypad"}) do
		if v.Name:lower():find(j:lower()) then
			ESPLibrary:RemoveESP(v)
		end
	end
end
while _G.EspObject do
for _, v in pairs(workspace:GetChildren()) do
    for name, enabled in pairs(_G.EspObject or {}) do
        if enabled and v.Name:lower():find(name:lower()) then
            EspAdd(v, v.Name, espColor[v.Name:lower()])
            UpdateEsp(v, v.Name, espColor[v.Name:lower()])
        end
    end
end
task.wait()
end
    end
})

Misc2Esp:AddDivider()

local Font = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(Font, v.Name)
end
Misc2Esp:AddDropdown("Font", {
    Text = "Set Font",
    Values = Font,
    Default = "Code",
    Multi = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFont(Value)
end
    end
})

Misc2Esp:AddToggle("Show Distance", {
    Text = "Show Distance",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetShowDistance(Value)
end
    end
})

Misc2Esp:AddToggle("Show Rainbow", {
    Text = "Show Rainbow",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetRainbow(Value)
end
    end
})

Misc2Esp:AddToggle("Show Tracers", {
    Text = "Show Tracers",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracers(Value)
end
    end
})

Misc2Esp:AddDropdown("TracersOrigin", {
    Text = "Tracers Origin",
    Multi = false,
    Values = {"Bottom", "Top", "Center", "Mouse"},
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracerOrigin(Value)
end
    end
})

Misc2Esp:AddToggle("Show Arrows", {
    Text = "Show Arrows",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrows(Value)
end
    end
})

Misc2Esp:AddSlider("ArrowsSize", {
    Text = "Set Arrows Radius",
    Default = 300,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrowRadius(Value)
end
    end
})

Misc2Esp:AddSlider("SetTextSize", {
    Text = "Set TextSize",
    Default = 15,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTextSize(Value)
end
    end
})

Misc2Esp:AddSlider("SetFillTransparency", {
    Text = "Set Fill Transparency",
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFillTransparency(Value)
end
    end
})

Misc2Esp:AddSlider("SetOutlineTransparency", {
    Text = "Set OutLine Transparency",
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetOutlineTransparency(Value)
end
    end
})

local Misc3Group = Tabs.Tab5:AddRightGroupbox("Misc Help")

Misc3Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.PlayerPut1 = FoundPlr(Value, true)
    end
})

Misc3Group:AddDropdown("Retro", {
    Text = "Retro",
    Values = {"Get Retro","Teleport Button","Enter Retro"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.HelpPlayerGetHehe = Value
    end
})

Misc3Group:AddButton("Help Player Retro", function()
if _G.HelpPlayerGetHehe == "Get Retro" then
if CheckGlove() == "Grab" then
if game.Workspace:FindFirstChild("Retro") == nil then
game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
end
wait(1)
if game.Players.LocalPlayer.Backpack:FindFirstChild("Grab") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Grab").Parent = game.Players.LocalPlayer.Character
end
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
wait(0.2)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(0.6)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.FinishDoor_Retro.Part.CFrame
wait(1)
if game.Players.LocalPlayer.Character:FindFirstChild("Grab") then
game.Players.LocalPlayer.Character:FindFirstChild("Grab").Parent = game.Players.LocalPlayer.Backpack
end
else
Notification("You don't have Grab equipped", _G.TimeNotify)
end
elseif _G.HelpPlayerGetHehe == "Teleport Button" then
if CheckGlove() == "Grab" then
if game.Workspace:FindFirstChild("Retro") == nil then
game.ReplicatedStorage.Assets.Retro.Parent = game.Workspace
end
wait(1)
if game.Players.LocalPlayer.Backpack:FindFirstChild("Grab") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Grab").Parent = game.Players.LocalPlayer.Character
end
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
wait(0.2)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
wait(0.6)
if game.Workspace:FindFirstChild("Retro") and game.Workspace.Retro:FindFirstChild("Map") then
for i, v in pairs(workspace.Retro.Map.RetroObbyMap:GetChildren()) do
if v.Name == "Model" and v:FindFirstChild("StaffApp") and v.StaffApp:FindFirstChild("Button") and v.StaffApp.Button:FindFirstChild("ClickDetector") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.StaffApp.Button.CFrame
end
end
end
wait(1)
if game.Players.LocalPlayer.Character:FindFirstChild("Grab") then
game.Players.LocalPlayer.Character:FindFirstChild("Grab").Parent = game.Players.LocalPlayer.Backpack
end
else
Notification("You don't have Grab equipped", _G.TimeNotify)
end
elseif _G.HelpPlayerGetHehe == "Enter Retro" then
if CheckGlove() == "Glitch" and game.Players.LocalPlayer.leaderstats.Slaps.Value >= 50000 and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and _G.PlayerPut1.Character:FindFirstChild("entered") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame
wait(0.35)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
fireclickdetector(workspace.Lobby["Error"].ClickDetector)
task.wait(8.5)
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame
until 4.5 >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - _G.PlayerPut1.Character.HumanoidRootPart.Position).Magnitude or game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health <= 0 or _G.PlayerPut1.Character:FindFirstChild("Humanoid") and _G.PlayerPut1.Character.Humanoid.Health <= 0
wait(0.07)
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0 or _G.PlayerPut1.Character:FindFirstChild("Humanoid") and _G.PlayerPut1.Character.Humanoid.Health > 0 then
game.ReplicatedStorage.Errorhit:FireServer(_G.PlayerPut1.Character:WaitForChild("Head"))
end
else
Notification("You have in Lobby | Player [ ".._G.PlayerPut1.Name.." ] in arena, or You don't have Glitch equipped, or you have don't have 50K Slap", _G.TimeNotify)
end
end
end)

Misc3Group:AddButton("Help Player Quake", function()
if CheckGlove() == "Home Run" and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and _G.PlayerPut1.leaderstats.Glove.Value == "Berserk" then
game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
fireclickdetector(workspace.Lobby.woah.ClickDetector)
wait(4.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame
task.wait(.2)
game:GetService("ReplicatedStorage").VineThud:FireServer()
task.wait(1)
fireclickdetector(workspace.Lobby["Home Run"].ClickDetector)
wait(0.4)
spawn(function()
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.Character.HumanoidRootPart.CFrame
until 4.5 >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - _G.PlayerPut1.Character.Character.HumanoidRootPart.Position).Magnitude or game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health <= 0 or _G.PlayerPut1.Character:FindFirstChild("Humanoid") and _G.PlayerPut1.Character.Humanoid.Health <= 0
end)
wait(0.7)
game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
else
Notification("You don't have Home Run equipped, or you have to go lobby, or player don't have Berserk equipped.", _G.TimeNotify)
end
end)

Misc3Group:AddButton("Help Player Goofy", function()
if CheckGlove() == "Confusion" and game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and CheckBadge(2133016756) then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame
wait(0.2)
game:GetService("ReplicatedStorage").GeneralHit:FireServer(_G.PlayerPut1.Character:WaitForChild("HumanoidRootPart"))
fireclickdetector(workspace.Lobby.Goofy.ClickDetector)
wait(2)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.HumanoidRootPart.CFrame
wait(0.2)
game:GetService("ReplicatedStorage").GeneralHit:FireServer(_G.PlayerPut1.Character.Character:WaitForChild("HumanoidRootPart"))
else
Notification("You don't have Confusion equipped, or you have to go lobby.", _G.TimeNotify)
end
end)

Misc3Group:AddButton("Help Player Wheelchair", function()
local CheckGloveWheel = 0
local WhatGloveNo = {}
for i, v in pairs({"bull", "bomb", "brick", "slicer", "blasphemy", "tableflip", "l.o.l.b.o.m.b"}) do
    local FoundGlove = false
    for j, b in pairs(game.Players.LocalPlayer:FindFirstChild("_unlockedGloves"):GetChildren()) do
        if b.Value == true and string.find(b.Name:lower(), v) then
            CheckGloveWheel += 1
            FoundGlove = true
            break
        end
    end
    if not FoundGlove then
        table.insert(WhatGloveNo, v)
    end
end
if tonumber(CheckGloveWheel) == 7 then
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and _G.PlayerPut1.Character:FindFirstChild("entered") then
		spawn(function()
			repeat task.wait()
				CreateFreezeBV()
				if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
					game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
				end
			until StopFreezeBV
			wait(0.3)
			CreateFreezeBV({Remove = true})
		end)
		if _G.PlayerPut1.Character:FindFirstChild("HumanoidRootPart") then
			local charpl = _G.PlayerPut1.Character
			local rootpl = charpl and charpl:FindFirstChild("HumanoidRootPart")
			equipglove("Bull")
			spawn(function()
				repeat task.wait()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
				until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			end)
			wait(0.3)
			repeat task.wait()
				slapglove(rootpl)
				task.wait(0.3)
			until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			wait(0.1)
			repeat task.wait() until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == false
			wait(0.35)
			equipglove("Bomb")
			spawn(function()
				repeat task.wait()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
				until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			end)
			wait(0.5)
			game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
			game:GetService("ReplicatedStorage"):WaitForChild("BombThrow"):FireServer("Ebutton")
			wait(0.12)
			repeat task.wait() until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == false
			equipglove("Brick")
			task.wait(0.1)
			repeat task.wait() until game.Players.LocalPlayer.Character
			if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				repeat task.wait()
					firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
					firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
				until game.Players.LocalPlayer.Character:FindFirstChild("entered")
			end
			task.wait(0.3)
			repeat task.wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 0, 5)
				if game.Players.LocalPlayer.Backpack:FindFirstChild("Brick") then
					game.Players.LocalPlayer.Backpack.Brick.Parent = game.Players.LocalPlayer.Character
				else
					game:GetService("ReplicatedStorage").lbrick:FireServer()
				end
			until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			wait(0.3)
			repeat task.wait() until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == false
			game:GetService("Players").LocalPlayer.Reset:FireServer()
			wait(0.3)
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			task.wait(0.55)
			equipglove("Slicer")
			task.wait(0.1)
			repeat task.wait() until game.Players.LocalPlayer.Character
			if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				repeat task.wait()
					firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
					firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
				until game.Players.LocalPlayer.Character:FindFirstChild("entered")
			end
			task.wait(0.5)
			repeat task.wait()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
				if game.Players.LocalPlayer.Backpack:FindFirstChild("Slicer") then
					game.Players.LocalPlayer.Backpack.Slicer.Parent = game.Players.LocalPlayer.Character
				else
					game:GetService("ReplicatedStorage").Slicer:FireServer("slash", game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame, Vector3.new())
				end
			until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			wait(0.3)
			repeat task.wait() until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == false
			task.wait(0.1)
			game:GetService("Players").LocalPlayer.Reset:FireServer()
			wait(0.3)
			repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			task.wait(0.5)
			equipglove("Blasphemy")
			spawn(function()
				repeat task.wait()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
				until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			end)
			task.wait(0.36)
			repeat task.wait()
				slapglove(rootpl)
				task.wait(0.3)
			until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			wait(0.1)
			repeat task.wait() until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == false
			wait(0.1)
			equipglove("Tableflip")
			spawn(function()
				repeat task.wait()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), math.rad(0), math.rad(0))
				until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == true
			end)
			task.wait(0.37)
			game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
			wait(0.1)
			repeat task.wait() until charpl:FindFirstChild("Ragdolled") and charpl.Ragdolled.Value == false
			equipglove("L.O.L.B.O.M.B")
			repeat task.wait() until game.Players.LocalPlayer.Character
			if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				repeat task.wait()
					firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
					firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
				until game.Players.LocalPlayer.Character:FindFirstChild("entered")
			end
			wait(0.3)
			spawn(function()
				repeat task.wait()
					if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = rootpl.CFrame * CFrame.new(0, 3, 0)
					end
				until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health <= 0
			end)
			game:GetService("Players").LocalPlayer.Reset:FireServer()
			wait(0.7)
			StopFreezeBV = true
		end
	else
		Notification("You have to go lobby or, player have to go arena.", _G.TimeNotify)
	end
else
	Notification("You have owner ".."\"7 Glove\"".." ("..table.concat(", ", WhatGloveNo)..")", _G.TimeNotify)
end
end)

Misc3Group:AddSlider("Time Help Berserk", {
    Text = "Time Help Berserk",
    Default = 3,
    Min = 1,
    Max = 3,
    Rounding = 0,
    Callback = function(Value)
_G.TimeHelpGotIm = Value
    end
})

Misc3Group:AddButton("Help Player Berserk", function()
if CheckGlove() == "Kinetic" and game.Players.LocalPlayer.Character:FindFirstChild("entered") and _G.PlayerPut1.Character:FindFirstChild("entered") then
for o = 1, _G.TimeHelpGotIm do
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
repeat task.wait()
	game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = -99})
until game.Players.LocalPlayer.Character:WaitForChild("KineticSlappedBadgeCounter").Value >= 100
wait(2.8)
spawn(function()
	repeat task.wait()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = _G.PlayerPut1.Character.Head.CFrame * CFrame.new(0,5.80,0) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(0))
	until _G.PlayerPut1.Character:FindFirstChild("Ragdolled") and _G.PlayerPut1.Character.Ragdolled.Value == true
end)
wait(0.28)
if game.Players.LocalPlayer.Backpack:FindFirstChild("Kinetic") then
	game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Kinetic)
end
wait(0.19)
game:GetService("ReplicatedStorage").KineticExpl:FireServer(game.Players.LocalPlayer.Character.Kinetic, game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
wait(0.7)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["SafeBox"].CFrame * CFrame.new(0,5,0)
wait(3.8)
end
else
Notification("You don't have Kinetic equipped, or you have to go Arena, or player have go to arena.", _G.TimeNotify)
end
end)

local Glove1Group = Tabs.Tab6:AddLeftGroupbox("Glove")

Glove1Group:AddDropdown("Santa", {
    Text = "Santa Ability",
    Values = {"Bob Plush", "Snow Peep", "Milk"},
    Default = "",
    Multi = false,
    Callback = function(Value)
SantaAbility = Value
    end
})

Glove1Group:AddToggle("Spam Santa", {
    Text = "Auto Ability Santa",
    Default = false, 
    Callback = function(Value) 
SantaSpam = Value
if CheckGlove() == "Santa" then
while SantaSpam do
if SantaAbility == "Bob Plush" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("bobplush")
elseif SantaAbility == "Snow Peep" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("snowpeep")
elseif SantaAbility == "Milk" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("milk")
end
task.wait()
end
elseif SantaSpam == true then
Notification("You don't have Santa equipped", _G.TimeNotify)
wait(0.05)
Toggles["Spam Santa"]:SetValue(false)
end
    end
})

Glove1Group:AddDropdown("AdminAbility", {
    Text = "Admin Ability",
    Values = {"Fling", "Anvil", "Invisibility"},
    Default = "",
    Multi = false,
    Callback = function(Value)
AbilityAdmin = Value
    end
})

Glove1Group:AddToggle("Spam Admin", {
    Text = "Auto Ability Admin",
    Default = false, 
    Callback = function(Value) 
AdminSpam = Value
while AdminSpam do
game:GetService("ReplicatedStorage").AdminAbility:FireServer(AbilityAdmin)
task.wait()
end
    end
})

Glove1Group:AddDropdown("RetroAbility", {
    Text = "Retro Ability",
    Values = {"Rocket Launcher", "Ban Hammer", "Bomb"},
    Default = "",
    Multi = false,
    Callback = function(Value)
RetroAbility = Value
    end
})

Glove1Group:AddToggle("Spam Retro", {
    Text = "Auto Ability Retro",
    Default = false, 
    Callback = function(Value) 
RetroSpam = Value
while RetroSpam do
game:GetService("ReplicatedStorage").RetroAbility:FireServer(RetroAbility)
task.wait()
end
    end
})

Glove1Group:AddDropdown("SlapStickAbility", {
    Text = "SlapStick Ability",
    Values = {"runeffect", "fullcharged", "dash", "addarm","charge","cancelrun","discharge"},
    Default = "",
    Multi = false,
    Callback = function(Value)
SlapstickAbility = Value
    end
})

Glove1Group:AddToggle("Spam Slapstick", {
    Text = "Auto Ability Slapstick",
    Default = false, 
    Callback = function(Value) 
SlapstickSpam = Value
if CheckGlove():lower():find("slapstick") then
if SlapstickSpam == true then
game:GetService("ReplicatedStorage").slapstick:FireServer("addarm")
end
while SlapstickSpam do
game:GetService("ReplicatedStorage").slapstick:FireServer(SlapstickAbility)
task.wait()
end
elseif Value == true then
Notification("You don't have Slapstick equipped", 5)
wait(0.05)
Toggles["Spam Slapstick"]:SetValue(false)
end
    end
})

Glove1Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
if Value == "Me" or Value == "me" or Value == "Username" or Value == "" then
	SaveThePlayer = game.Players.LocalPlayer.Name
else
	SaveThePlayer = FoundPlr(Value, true).Name
end
    end
})

Glove1Group:AddToggle("Godmobe Player", {
    Text = "Auto Godmobe Player",
    Default = false, 
    Callback = function(Value) 
if SaveThePlayer == nil then
SaveThePlayer = game.Players.LocalPlayer.Name
end
GuardianAngelSpam = Value
if CheckGlove() == "Guardian Angel" then
while GuardianAngelSpam do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game.Players[SaveThePlayer])
task.wait()
end
elseif GuardianAngelSpam == true then
Notification("You don't have Guardian Angel equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Godmobe Player"]:SetValue(false)
end
    end
})

Glove1Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
if Value == "Me" or Value == "me" or Value == "Username" or Value == "" then
DivebombExplosion = game.Players.LocalPlayer.Name
else
DivebombExplosion = FoundPlr(Value, true).Name
end
    end
})

Glove1Group:AddSlider("ChargeExplosion", {
    Text = "Charge Explosion",
    Default = 20,
    Min = 20,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ChargeExplosion = Value
    end
})

Glove1Group:AddToggle("Ability Divebomb", {
    Text = "Auto Ability Divebomb",
    Default = false, 
    Callback = function(Value) 
if DivebombExplosion == nil then
DivebombExplosion = game.Players.LocalPlayer.Name
end
_G.DivebombSpam = Value
if CheckGlove() == "Divebomb" then
while _G.DivebombSpam do
game:GetService("ReplicatedStorage").RocketJump:InvokeServer({["chargeAlpha"] = 100,["rocketJump"] = true})
game:GetService("ReplicatedStorage").RocketJump:InvokeServer({["position"] = game.Players[DivebombExplosion].Character.HumanoidRootPart.Position,["explosion"] = true,["explosionAlpha"] = _G.ChargeExplosion})
task.wait()
end
elseif _G.DivebombSpam == true then
Notification("You don't have Divebomb equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Ability Divebomb"]:SetValue(false)
end
    end
})

Glove1Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.BarrelPlayer = FoundPlr(Value, true).Name
    end
})

Glove1Group:AddToggle("AbilityBarrelPlayer", {
    Text = "Auto Barrel Player",
    Default = false, 
    Callback = function(Value) 
_G.BarrelSpamPlayer = Value
if CheckGlove() == "Barrel" then
while _G.BarrelSpamPlayer do
game:GetService("ReplicatedStorage").GeneralAbility:FireServer({["cf"] = game.Players[_G.BarrelPlayer].Character.HumanoidRootPart.CFrame})
task.wait()
end
elseif _G.BarrelSpamPlayer == true then
Notification("You don't have Barrel equipped.", _G.TimeNotify)
wait(0.05)
Toggles.AbilityBarrelPlayer:SetValue(false)
end
    end
})

Glove1Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.BindPlayer = FoundPlr(Value, true)
    end
})

Glove1Group:AddDropdown("BindAbility", {
    Text = "Bind Ability",
    Values = {"Default", "Ultimate"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BindAbility = Value
    end
})

Glove1Group:AddToggle("AbilityBindPlayer", {
    Text = "Auto Bind Player",
    Default = false, 
    Callback = function(Value) 
_G.BindSpamPlayer = Value
if CheckGlove() == "Bind" then
while _G.BindSpamPlayer do
if _G.BindAbility == "Default" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("default", {["goal"] = game.Players[_G.BindPlayer].Character.HumanoidRootPart.CFrame, ["origin"] = game.Players[_G.BindPlayer].Character.Head.CFrame})
elseif _G.BindAbility == "Ultimate" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer("ultimate", {["goal"] = game.Players[_G.BindPlayer].Character.HumanoidRootPart.CFrame * CFrame.Angles(3.141592502593994, 1.0641214847564697, -3.141592502593994), ["origin"] = game.Players[_G.BindPlayer].Character.HumanoidRootPart.CFrame * CFrame.Angles(3.141592502593994, 1.0641214847564697, -3.141592502593994)})
end
task.wait()
end
elseif _G.BindSpamPlayer == true then
Notification("You don't have Bind equipped.", _G.TimeNotify)
wait(0.05)
Toggles.AbilityBindPlayer:SetValue(false)
end
    end
})

_G.PlayerChoose = "Username"
Glove1Group:AddDropdown("PlayerChoose", {
    Text = "Player Choose",
    Values = {"Username","Random"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PlayerChoose = Value
    end
})

Glove1Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.PlayerButton = FoundPlr(Value, true).Name
    end
})

Glove1Group:AddButton("Swapper Player Void", function()
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if game.Players.LocalPlayer.Character:FindFirstChild("Swapper") or game.Players.LocalPlayer.Backpack:FindFirstChild("Swapper") then
	OGL = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	CreateFreezeBV()
	repeat task.wait()
	if workspace[_G.PlayerButton]:FindFirstChild("HumanoidRootPart") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace[_G.PlayerButton].HumanoidRootPart.CFrame * CFrame.new(0, -70, 0)
	end
	until game.Players[_G.PlayerButton].Character and workspace[_G.PlayerButton]:FindFirstChild("HumanoidRootPart") and workspace[_G.PlayerButton]:FindFirstChild("entered") and workspace[_G.PlayerButton].Ragdolled.Value == false
	task.wait(0.6)
	game:GetService("ReplicatedStorage").SLOC:FireServer()
	wait(.25)
	CreateFreezeBV({Remove = true})
	task.wait(0.05)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OGL
else
	Notification("You don't have Swapper equipped, or you aren't in the arena.", _G.TimeNotify)
end
end)

Glove1Group:AddButton("Home Run Kill Player", function()
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if CheckGlove() == "Home Run" and game.Players[_G.PlayerButton].Character:FindFirstChild("entered") then
	CreateFreezeBV()
	OGL = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	game.Players[_G.PlayerButton].Character.HumanoidRootPart.Size = Vector3.new(50,50,50)
	game:GetService("ReplicatedStorage").HomeRun:FireServer({["start"] = true})
	wait(4.2)
	game:GetService("ReplicatedStorage").HomeRun:FireServer({["finished"] = true})
	task.wait(0.12)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[_G.PlayerButton].Character.HumanoidRootPart.CFrame
	task.wait(0.25)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OGL
	CreateFreezeBV({Remove = true})
else
	Notification("You don't have Home Run equipped", _G.TimeNotify)
end
end)

Glove1Group:AddButton("Hive Player", function()
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if CheckGlove() == "Hive" and game.Players[_G.PlayerButton].Character:FindFirstChild("entered") then
	CreateFreezeBV()
	OGL = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
	task.wait(4.2)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[_G.PlayerButton].Character.HumanoidRootPart.CFrame
	repeat task.wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game.Players[_G.PlayerButton].Character.HumanoidRootPart.Position).Magnitude <= 7
	task.wait(0.33)
	game:GetService("ReplicatedStorage"):WaitForChild("GeneralHit"):FireServer(game.Players[_G.PlayerButton].Character:WaitForChild("HumanoidRootPart"))
	wait(0.25)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OGL
	CreateFreezeBV({Remove = true})
else
	Notification("You don't have Hive equipped", _G.TimeNotify)
end
end)

Glove1Group:AddButton("Quake Player", function()
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if CheckGlove() == "Quake" and game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players[_G.PlayerButton].Character:FindFirstChild("entered") then
	CreateFreezeBV()
	OGL = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	repeat task.wait()
		if game.Players.LocalPlayer.Backpack:FindFirstChild("Quake") then
			game.Players.LocalPlayer.Backpack.Quake.Parent = game.Players.LocalPlayer.Character
		end
	until game.Players.LocalPlayer.Character:FindFirstChild("Quake")
	task.wait(0.3)
	game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["start"] = true})
	wait(3.45)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[_G.PlayerButton].Character:FindFirstChild("Head").CFrame * CFrame.new(0,4,0)
	repeat task.wait() until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - game.Players[_G.PlayerButton].Character.HumanoidRootPart.Position).Magnitude <= 7
	task.wait(0.35)
	game:GetService("ReplicatedStorage"):WaitForChild("QuakeQuake"):FireServer({["finished"] = true})
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OGL
	CreateFreezeBV({Remove = true})
else
	Notification("You don't have Quake equipped.", _G.TimeNotify)
end
end)

Glove1Group:AddButton("Cards Player", function()
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if CheckGlove() == "Jester" then
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Ability3", game.Players[_G.PlayerButton])
else
	Notification("You don't have Jester glove equipped", _G.TimeNotify)
end
end)

Glove1Group:AddButton("Grab Player Teleport", function()
if CheckGlove() == "Grab" and game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players[_G.PlayerButton].Character:FindFirstChild("entered") then
	CreateFreezeBV()
	if game.Players.LocalPlayer.Backpack:FindFirstChild("Grab") then
		game.Players.LocalPlayer.Backpack:FindFirstChild("Grab").Parent = game.Players.LocalPlayer.Character
	end
	wait(0.36)
	OLG = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[_G.PlayerButton].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
	wait(0.2)
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
	wait(0.15)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OLG
	wait(0.37)
	if game.Players.LocalPlayer.Character:FindFirstChild("Grab") then
		game.Players.LocalPlayer.Character:FindFirstChild("Grab").Parent = game.Players.LocalPlayer.Backpack
	end
	CreateFreezeBV({Remove = true})
else
	Notification("You don't have Grab equipped, or you have to go Arena, or player go to Arena", _G.TimeNotify)
end
end)

Glove1Group:AddToggle("Auto Oven Player", {
    Text = "Auto Oven Player",
    Default = false, 
    Callback = function(Value) 
_G.OvenPlayerAuto = Value
if CheckGlove() == "Oven" then
while _G.OvenPlayerAuto do
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Oven") then
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer(game.Players[_G.PlayerButton].Character.HumanoidRootPart.CFrame)
end
task.wait()
end
elseif _G.OvenPlayerAuto == true then
Notification("You don't have Oven equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Oven Player"]:SetValue(false)
end
    end
})

Glove1Group:AddToggle("Auto Cards Player", {
    Text = "Auto Cards Player",
    Default = false, 
    Callback = function(Value) 
_G.OvenPlayerAuto = Value
if CheckGlove() == "Jester" then
while _G.OvenPlayerAuto do
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if CheckGlove() == "Jester" then
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer("Ability3", game.Players[_G.PlayerButton])
end
task.wait()
end
elseif _G.OvenPlayerAuto == true then
Notification("You don't have Jester equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Cards Player"]:SetValue(false)
end
    end
})

Glove1Group:AddToggle("Auto Siphon Player", {
    Text = "Auto Siphon Player",
    Default = false, 
    Callback = function(Value) 
_G.AutoSiphonPlayer = Value
if CheckGlove() == "Siphon" then
while _G.AutoSiphonPlayer do
if _G.PlayerChoose == "Random" then
	local players = {}
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Ragdolled") and not v.Character.HumanoidRootPart:FindFirstChild("BlockedShield") and not v.Character:FindFirstChild("Counterd") and not v.Character:FindFirstChild("Mirage") and not v.Character:FindFirstChild("rock") and not v.Character:FindFirstChild("Reversed") and v.Character.Ragdolled.Value == false and v.Character.isInArena.Value == true then
			table.insert(players, v)
		end
	end
	if #players ~= 0 then
		_G.PlayerButton = players[math.random(#players)].Name
	end
end
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players[_G.PlayerButton].Character:FindFirstChild("entered") then
	game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = game.Players[_G.PlayerButton].Character.HumanoidRootPart.CFrame})
end
task.wait()
end
elseif _G.AutoSiphonPlayer == true then
Notification("You don't have Siphon equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Siphon Player"]:SetValue(false)
end
    end
})

Glove1Group:AddDropdown("Black Hole", {
    Text = "Black Hole",
    Values = {"Normal", "Teleport Cannon Island"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.BlackHoleCre = Value
    end
})

Glove1Group:AddButton("Auto Create Black Hole", function()
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and CheckBadge(2125950512) and CheckBadge(2147429609) then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.workspace.Origo.CFrame * CFrame.new(0,30,0)
	wait(0.1)
	game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
	wait(0.05)
	fireclickdetector(workspace.Lobby["rob"].ClickDetector)
	wait(0.3)
	game:GetService("ReplicatedStorage").rob:FireServer()
	repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 and game.Players.LocalPlayer.Character:FindFirstChild("RobTransformed") and game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character.Head.Transparency >= 1
	fireclickdetector(workspace.Lobby["bob"].ClickDetector)
	game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
	repeat task.wait() until CheckGlove() == "bob"
	game:GetService("ReplicatedStorage").bob:FireServer()
	wait(0.5)
	for i = 1,26 do
		for _, v in pairs(workspace:GetChildren()) do
			if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame
			end
		end
	end
	if _G.BlackHoleCre == "Teleport Cannon Island" then
		repeat task.wait() until game.Players.LocalPlayer.Character
		if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			repeat task.wait()
			firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
			firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
			until game.Players.LocalPlayer.Character:FindFirstChild("entered")
		end
		wait(0.27)
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
		wait(0.25)
		for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
		    if v.ClassName == "ProximityPrompt" then
		        fireproximityprompt(v)
		    end
		end
	end
else
	Notification("You have in lobby, or You don't have badge bob, or badge rob.", _G.TimeNotify)
end
end)

Glove1Group:AddButton("Auto Enter Map Null", function()
if game.Workspace:FindFirstChild("Blackhole_Particles") == nil then
Notification("When will someone create a black hole [ BOB + ROB ].", _G.TimeNotify)
return
end
if CheckGlove() ~= "Default" then
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
		game:GetService("Players").LocalPlayer.Reset:FireServer()
		wait(0.4)
		repeat task.wait() until game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health > 0
		wait(0.3)
	end
	if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil then
		equipglove("Default")
	end
end
if game.Players.LocalPlayer.Character:FindFirstChild("entered") ~= nil then
	repeat task.wait() until game.Players.LocalPlayer.Character
	if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		repeat task.wait()
			firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
			firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
		until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	end
end
wait(0.3)
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	repeat task.wait()
	if game.Workspace:FindFirstChild("Blackhole_Particles") and game.Workspace.Blackhole_Particles:FindFirstChild("BlackHole") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Blackhole_Particles.BlackHole.CFrame
	end
	until game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.Health == 0
end
end)

Glove1Group:AddButton("Auto Enter Cannon", function()
if not game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	repeat task.wait()
		firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 0)
		firetouchinterest(game.Players.LocalPlayer.Character:WaitForChild("Head"), workspace.Lobby.Teleport1.TouchInterest.Parent, 1)
	until game.Players.LocalPlayer.Character:FindFirstChild("entered")
	wait(0.26)
end
if game.Players.LocalPlayer.Character:FindFirstChild("entered") then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(227, 48, 169)
	wait(0.25)
	for i,v in ipairs(game.Workspace.Arena.CannonIsland:GetDescendants()) do
        if v.ClassName == "ProximityPrompt" then
            fireproximityprompt(v)
        end
    end
end
end)

local Glove2Group = Tabs.Tab6:AddRightGroupbox("Misc Glove")

Glove2Group:AddButton("Spawn Orb Siphon", function()
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and CheckGlove() == "Siphon" then
repeat task.wait()
game:GetService("ReplicatedStorage").Events.Siphon:FireServer({["cf"] = game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].Part.CFrame})
until game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("siphon_charge")
repeat task.wait()
if game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("siphon_charge") then
game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
until game.Workspace.Arena.CubeOfDeathArea["the cube of death(i heard it kills)"]:FindFirstChild("siphon_charge") == nil
else
Notification("You don't have Siphon equipped or you haven't in arena.", _G.TimeNotify)
end
end)

Glove2Group:AddButton("Ability Lure Safe", function()
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and CheckGlove() == "Lure" then
OldTP = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Arena.CannonIsland.Cannon.Base.CFrame * CFrame.new(0,0,35)
task.wait(0.2)
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
task.wait(0.15)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldTP
else
Notification("You don't have Lure equipped or you haven't in arena.", _G.TimeNotify)
end
end)

Glove2Group:AddToggle("Auto Collect Ingredients", {
    Text = "Auto Collect Ingredients",
    Default = false, 
    Callback = function(Value) 
_G.AutoPickupIngredients = Value
while _G.AutoPickupIngredients do
if CheckGlove() == "Alchemist" and game.Workspace:FindFirstChild("Alchemist_Ingredients_") then
for i,v in pairs(game.Workspace:FindFirstChild("Alchemist_Ingredients_"):GetChildren()) do
if v:IsA("Model") and v:FindFirstChild("Clickbox") and v.Clickbox:FindFirstChild("ClickDetector") then
v.Clickbox.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
end
end
task.wait()
end
    end
})

Glove2Group:AddToggle("Auto Collect Pillow", {
    Text = "Auto Collect Pillow",
    Default = false, 
    Callback = function(Value) 
_G.AutoCollectPillow = Value
while _G.AutoCollectPillow do
if CheckGlove() == "Pillow" and game.Workspace:FindFirstChild("pillows_") then
for i,v in pairs(game.Workspace:FindFirstChild("pillows_"):GetChildren()) do
if v.Name == "pillow_model" and v:FindFirstChild("Clickbox") and v.Clickbox:FindFirstChild("ClickDetector") then
v.Clickbox.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end
end
end
task.wait()
end
    end
})

Glove2Group:AddToggle("Infinity Pillow", {
    Text = "Infinity Pillow",
    Default = false, 
    Callback = function(Value) 
_G.InfinityPillow = Value
if CheckGlove() == "Pillow" then
while _G.InfinityPillow do
game:GetService("ReplicatedStorage").Events.PillowEvent:FireServer("AddPillow")
task.wait()
end
elseif _G.InfinityPillow == true then
Notification("You don't have Pillow equipped", _G.TimeNotify)
wait(0.05)
Toggles["Infinity Pillow"]:SetValue(false)
end
    end
})

Glove2Group:AddToggle("Infinite Ingredients", {
    Text = "Infinite Ingredients",
    Default = false, 
    Callback = function(Value) 
_G.InfiniteIngredients = Value
if CheckGlove() == "Alchemist" then
while _G.InfiniteIngredients do
if CheckGlove() == "Alchemist" then
	for i, v in ipairs({"Mushroom", "Glowing Mushroom", "Fire Flower", "Winter Rose", "Dark Root", "Dire Flower", "Autumn Sprout", "Elder Wood", "Hazel Lily", "Wild Vine", "Jade Stone", "Lamp Grass", "Blood Rose", "Plane Flower", "Blue Crystal", "Red Crystal", "Cake Mix"}) do
		game.ReplicatedStorage.AlchemistEvent:FireServer("AddItem", v)
	end
end
task.wait()
end
elseif _G.InfiniteIngredients == true then
Toggles["Infinite Ingredients"]:SetValue(false)
wait(0.05)
Notification("You don't have Alchemist equipped", _G.TimeNotify)
end
    end
})

local PotionNames = {}
for i, v in pairs(_G.GetPotion) do
    table.insert(PotionNames, i)
end
Glove2Group:AddDropdown("Potion", {
    Text = "Choose Craft Potion",
    Values = PotionNames,
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.MakePotion = Value
    end
})

Glove2Group:AddSlider("Potion1", {
    Text = "Number Potion",
    Default = 1,
    Min = 1,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.PotionNumber = Value
    end
})

Glove2Group:AddDropdown("Potion2", {
    Text = "Craft Potion",
    Values = {"Number","Normal"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.Potion2 = Value
    end
})

Glove2Group:AddButton("Get Potions", function()
if CheckGlove() == "Alchemist" then
if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron") then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
if _G.Potion2 == "Normal" then
for i = 1, #_G.GetPotion[_G.MakePotion] do
repeat task.wait()
if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron") then
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron")
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("AddItem", _G.GetPotion[_G.MakePotion][i])
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("MixItem", _G.GetPotion[_G.MakePotion][i])
task.wait()
end
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("BrewPotion")
elseif _G.Potion2 == "Number" then
for a = 1, _G.PotionNumber do
for i = 1, #_G.GetPotion[_G.MakePotion] do
repeat task.wait()
if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron") then
	game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron")
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("AddItem", _G.GetPotion[_G.MakePotion][i])
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("MixItem", _G.GetPotion[_G.MakePotion][i])
end
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("BrewPotion")
end
end
else
Notification("You don't have Alchemist equipped", _G.TimeNotify)
end
end)

Glove2Group:AddButton("Get All Potions", function()
if CheckGlove() == "Alchemist" then
if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron") then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
for i, v in pairs(_G.GetPotion) do
    for j, p in pairs(v) do
	    repeat task.wait(0.2)
			if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron") then
				game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
			end
		until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron")
        game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("AddItem", p)
        game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("MixItem", p)
        task.wait(0.07)
    end
    game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("BrewPotion")
end
else
Notification("You don't have Alchemist equipped", _G.TimeNotify)
end
end)

Glove2Group:AddToggle("Auto Get Potion", {
    Text = "Auto Get Potion",
    Default = false, 
    Callback = function(Value)
_G.AutoMakePotion = Value
if CheckGlove() == "Alchemist" then
while _G.AutoMakePotion do
if CheckGlove() == "Alchemist" then
if not game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name.."'s Cauldron") then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
end
for i = 1, #_G.GetPotion[_G.MakePotion] do
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("AddItem", _G.GetPotion[_G.MakePotion][i])
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("MixItem", _G.GetPotion[_G.MakePotion][i])
end
game:GetService("ReplicatedStorage").AlchemistEvent:FireServer("BrewPotion")
end
task.wait(0.01)
end
elseif _G.AutoMakePotion == true then
Toggles["Auto Get Potion"]:SetValue(false)
wait(0.05)
Notification("You don't have Alchemist equipped", _G.TimeNotify)
end
    end
})

Glove2Group:AddToggle("Auto PingPong", {
    Text = "Auto Slap Ping Pong",
    Default = false, 
    Callback = function(Value) 
_G.AutoPingPongReal = Value
while _G.AutoPingPongReal do
if CheckGlove() == "Ping Pong" then
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name:find("_PingPongBall") and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 48 then
				game:GetService("ReplicatedStorage"):WaitForChild("PingPongEvent"):FireServer()
			end
		end
	end
end
task.wait()
end
    end
})

Glove2Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.PlayerButton2 = FoundPlr(Value, true).Name
    end
})

Glove2Group:AddInput("SpeedOrbit", {
    Default = "20",
    Numeric = false,
    Text = "Speed Orbit",
    Placeholder = "UserSpeed",
    Callback = function(Value)
if Value == "inf" or Value == "Inf" or Value == "infinity" or Value == "Infinity" then
OrbitSpeed = 9e9
else
OrbitSpeed = Value
end
    end
})

Glove2Group:AddSlider("Extend", {
    Text = "Extend Ability",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ExtendPingPong = Value
    end
})

Glove2Group:AddDropdown("Clone", {
    Text = "Clone",
    Values = {"Orbit", "Orbit Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.Clone = Value
    end
})

Glove2Group:AddToggle("Auto Clone", {
    Text = "Auto Clone",
    Default = false, 
    Callback = function(Value) 
_G.CloneAuto = Value
if CheckGlove() == "Cherry" or CheckGlove() == "Replica" then
while _G.CloneAuto do
local OrbitTick = CFrame.new(math.cos(tick() * OrbitSpeed + (i - 1) * math.pi / 2) * _G.ExtendPingPong, 0, math.sin(tick() * OrbitSpeed + (i - 1) * math.pi / 2) * _G.ExtendPingPong)
if CheckGlove() == "Cherry" then
	if workspace:FindFirstChild("cherry_storage") then
		for i, v in pairs(workspace.cherry_storage:GetChildren()) do
			if v.Name == ("Cherry "..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("clone_remote") and IsNetworkOwner(v.HumanoidRootPart) then
				v.clone_remote:FireServer()
				if _G.Clone == "Orbit" then
					v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * OrbitTick
				elseif _G.Clone == "Orbit Player" then
					v.HumanoidRootPart.CFrame = game.Players[_G.PlayerButton2].Character.HumanoidRootPart.CFrame * OrbitTick
				end
			end
		end
	end
elseif CheckGlove() == "Replica" then
	for i,v in pairs(game.Workspace:GetChildren()) do
		if v.Name == ("Å"..game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") and IsNetworkOwner(v.HumanoidRootPart) then
			if _G.Clone == "Orbit" then
				v.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * OrbitTick
			elseif _G.Clone == "Orbit Player" then
				v.HumanoidRootPart.CFrame = game.Players[_G.PlayerButton2].Character.HumanoidRootPart.CFrame * OrbitTick
			end
		end
	end
end
task.wait()
end
elseif _G.CloneAuto == true then
Notification("You don't have Cherry or Replica equipped", _G.TimeNotify)
wait(0.05)
Toggles["Auto Clone"]:SetValue(false)
end
    end
})

Glove2Group:AddDropdown("Ping Pong Choose", {
    Text = "Ping Pong",
    Values = {"Fling", "Fling Player", "Orbit", "Orbit Player"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.PingPongServer = Value
    end
})

Glove2Group:AddToggle("PingPong", {
    Text = "Start Ping Pong",
    Default = false, 
    Callback = function(Value) 
_G.PingPongServerBr = Value
if CheckGlove() == "Ping Pong" then
PingPongBall = game.Players.LocalPlayer.Name.."_PingPongBall"
if _G.PingPongServer == "Orbit" then
Orbit = "0"
if OrbitSpeed == nil then
OrbitSpeed = 1
end
game.Players.LocalPlayer.Character.Torso.RadioPart.Rotation = game.Players.LocalPlayer.Character.HumanoidRootPart.Rotation
end
while _G.PingPongServerBr do
if _G.PingPongServer == "Orbit" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
Orbit = Orbit + OrbitSpeed
game.Players.LocalPlayer.Character.Torso.RadioPart.Rotation = Vector3.new(-180, Orbit, -180)
if game.Players.LocalPlayer.Character.Torso.RadioPart:GetChildren()[2] then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.ClassName == "Part" and v.Name == PingPongBall then
v.CFrame = game.Players.LocalPlayer.Character.Torso.RadioPart.CFrame * CFrame.new(0,0,-_G.ExtendPingPong) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0))
                    end
                end
for i,v in pairs(game.Players.LocalPlayer.Character.Torso.RadioPart:GetChildren()) do
                    if v.ClassName == "Part" and v.Name == PingPongBall then
                        v.CFrame = game.Players.LocalPlayer.Character.Torso.RadioPart.CFrame * CFrame.new(0,0,_G.ExtendPingPong) * CFrame.Angles(math.rad(0), math.rad(90), math.rad(0))
                    end
                end
elseif game.Players.LocalPlayer.Character.Torso.RadioPart:GetChildren()[1] or game.Players.LocalPlayer.Character.Torso.RadioPart:GetChildren()[2] then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.ClassName == "Part" and v.Name == PingPongBall then
v.Parent = game.Players.LocalPlayer.Character.Torso.RadioPart
break
                    end
                end
end
elseif _G.PingPongServer == "Orbit Player" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
if game.Players[_G.PlayerButton2].Character and game.Players[_G.PlayerButton2].Character:WaitForChild("Ragdolled").Value == false then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == (game.Players.LocalPlayer.Name.."_PingPongBall") then
v.CFrame = game.Players[_G.PlayerButton2].Character.HumanoidRootPart.CFrame * CFrame.new(math.cos(tick() * OrbitSpeed + (i - 1) * math.pi / 2) * _G.ExtendPingPong, 0, math.sin(tick() * OrbitSpeed + (i - 1) * math.pi / 2) * _G.ExtendPingPong)
                    end
                end
end
elseif _G.PingPongServer == "Fling" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
for i, v in pairs(game.Players:GetPlayers()) do
if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("stevebody") == nil and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false and v.Character:FindFirstChild("Mirage") == nil then
for i,a in pairs(game.Workspace:GetChildren()) do
                    if a.Name == (game.Players.LocalPlayer.Name.."_PingPongBall") then
a.CFrame = v.Character.HumanoidRootPart.CFrame
break
                    end
                end
end
end
end
elseif _G.PingPongServer == "Fling Player" then
game:GetService("ReplicatedStorage").GeneralAbility:FireServer()
if game.Players[_G.PlayerButton2].Character and game.Players[_G.PlayerButton2].Character:WaitForChild("Ragdolled").Value == false then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == (game.Players.LocalPlayer.Name.."_PingPongBall") then
v.CFrame = game.Players[_G.PlayerButton2].Character.HumanoidRootPart.CFrame
                    end
                end
end
end
task.wait(0.01)
end
elseif Value == true then
Notification("You don't have Ping Pong equipped.", _G.TimeNotify)
wait(0.05)
Toggles["PingPong"]:SetValue(false)
end
    end
})

Glove2Group:AddSlider("ExtendRob", {
    Text = "Extend HitBox Rob",
    Default = 16,
    Min = 16,
    Max = 400,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.ExtendHitboxRob = Value
    end
})

Glove2Group:AddDropdown("Hitbox Rob", {
    Text = "Hitbox Rob",
    Values = {"You","All"},
    Default = "All",
    Multi = false,
    Callback = function(Value)
_G.RobHitbox = Value
    end
})

Glove2Group:AddToggle("Hitbox Rob", {
    Text = "Hitbox All Rob & Color",
    Default = false, 
    Callback = function(Value)
_G.HitboxRob = Value
while _G.HitboxRob do
if _G.RobHitbox == "All" then
for i,v in pairs(game.Workspace:GetChildren()) do
    if v.Name == "Field" then
        v.Size = Vector3.new(_G.ExtendHitboxRob,_G.ExtendHitboxRob,_G.ExtendHitboxRob)
        v.BrickColor = BrickColor.new(_G.ColorHitboxRob)
    end
end
elseif _G.RobHitbox == "You" then
for i,v in pairs(game.Workspace:GetChildren()) do
         if v.Name == "Field" and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <= 1 then
              v.Size = Vector3.new(_G.ExtendHitboxRob,_G.ExtendHitboxRob,_G.ExtendHitboxRob)
              v.BrickColor = BrickColor.new(_G.ColorHitboxRob)
         end
     end
end
task.wait()
end
if _G.HitboxRob == false then
	for i,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "Field" then
            v.Size = Vector3.new(16,16,16)
            v.BrickColor = BrickColor.new(255,255,255)
        end
    end
end
    end
}):AddColorPicker("Color Hitbox Rob", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.ColorHitboxRob = Value
     end
})

_G.SetSpeedFlyCloud = 2
Glove2Group:AddInput("FlySpeed", {
    Default = "2",
    Numeric = true,
    Text = "Fly Speed Cloud",
    Placeholder = "UserFlySpeed",
    Callback = function(Value)
_G.SetSpeedFlyCloud = Value
    end
})

Glove2Group:AddToggle("Cloud Speed", {
    Text = "Cloud Speed",
    Default = false, 
    Callback = function(Value)
_G.CloudSpeed = Value
if CheckGlove() == "Cloud" then
while _G.CloudSpeed do
    for i,v in pairs(game.Workspace:GetChildren()) do
        if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("BodyVelocity") and v:FindFirstChild("VehicleSeat") then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if 3 >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude then
	                local VectorBV = v.BodyVelocity.Velocity
					if MobileOn then
				        local controlModule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector()
						if controlModule.X > 0 then
							VectorBV = VectorBV + game.Workspace.CurrentCamera.CFrame.RightVector * (controlModule.X * _G.SetSpeedFlyCloud)
						end
						if controlModule.X < 0 then
							VectorBV = VectorBV + game.Workspace.CurrentCamera.CFrame.RightVector * (controlModule.X * _G.SetSpeedFlyCloud)
						end
						if controlModule.Z > 0 then
							VectorBV = VectorBV - game.Workspace.CurrentCamera.CFrame.LookVector * (controlModule.Z * _G.SetSpeedFlyCloud)
						end
						if controlModule.Z < 0 then
							VectorBV = VectorBV - game.Workspace.CurrentCamera.CFrame.LookVector * (controlModule.Z * _G.SetSpeedFlyCloud)
						end
					else
					    VectorBV = VectorBV + (game.Workspace.CurrentCamera.CFrame.LookVector * (ctrlCould.f.f + ctrlCould.b)) + (game.Workspace.CurrentCamera.CFrame.RightVector * (ctrlCould.r + ctrlCould.l))
					end
			        v.BodyVelocity.Velocity = VectorBV
			    end
			end
		end
	end
    task.wait()
end
elseif _G.CloudSpeed == true then
Notification("You don't have Cloud equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Cloud Speed"]:SetValue(false)
end
    end
})

Glove2Group:AddInput("Players", {
    Default = "",
    Numeric = false,
    Text = "Player",
    Finished = true,
    Placeholder = "Username",
    Callback = function(Value)
_G.PlayerButton3 = FoundPlr(Value, true).Name
    end
}) 

Glove2Group:AddDropdown("Cloud Bring", {
    Text = "Cloud Seat",
    Values = {"Player","Your"},
    Default = "Player",
    Multi = false,
    Callback = function(Value)
_G.CloudBring = Value
    end
})

Glove2Group:AddToggle("Auto Bring Cloud", {
    Text = "Auto Seat Cloud",
    Default = false, 
    Callback = function(Value)
_G.BringCloud = Value
if CheckGlove() == "Cloud" then
while _G.BringCloud do
if _G.CloudBring == "Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players[_G.PlayerButton3].Character:FindFirstChild("entered") and game.Players[_G.PlayerButton3].Character.Humanoid.Sit == false then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("VehicleSeat") then
                        v.VehicleSeat.CFrame = game.Players[_G.PlayerButton3].Character.HumanoidRootPart.CFrame * CFrame.new(0,-2.32,0)
                    end
               end
          end
elseif _G.CloudBring == "Your" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.Sit == false then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("VehicleSeat") then
                        v.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-2.32,0)
                    end
               end
          end
end
task.wait()
end
elseif _G.BringCloud == true then
Notification("You don't have Cloud equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Bring Cloud"]:SetValue(false)
end
    end
})

Glove2Group:AddDropdown("Firework Bring", {
    Text = "Firework Seat",
    Values = {"Player","Your"},
    Default = "Player",
    Multi = false,
    Callback = function(Value)
_G.FireworkBring = Value
    end
})

Glove2Group:AddToggle("Auto Bring Firework", {
    Text = "Auto Seat Firework",
    Default = false, 
    Callback = function(Value)
_G.BringFirework = Value
if CheckGlove() == "Firework" then
while _G.BringFirework do
if _G.FireworkBring == "Player" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players[_G.PlayerButton3].Character:FindFirstChild("entered") and game.Players[_G.PlayerButton3].Character.Humanoid.Sit == false then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("VehicleSeat") then
                        v.VehicleSeat.CFrame = game.Players[_G.PlayerButton3].Character.HumanoidRootPart.CFrame
                    end
               end
          end
elseif _G.FireworkBring == "Your" then
if game.Players.LocalPlayer.Character:FindFirstChild("entered") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.Sit == false then
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("VehicleSeat") then
                        v.VehicleSeat.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    end
               end
          end
end
task.wait()
end
elseif _G.BringFirework == true then
Notification("You don't have Firework equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Bring Firework"]:SetValue(false)
end
    end
})

Glove2Group:AddToggle("Auto Full Kinetic", {
    Text = "Auto Full Kinetic",
    Default = false, 
    Callback = function(Value)
_G.FullKineticSpam = Value
if CheckGlove() == "Kinetic" and game.Players.LocalPlayer.Character:FindFirstChild("entered") then
while _G.FullKineticSpam do
game.ReplicatedStorage.SelfKnockback:FireServer({["Force"] = 0,["Direction"] = Vector3.new(0,0.01,0)})
task.wait()
end
elseif _G.FullKineticSpam == true then
Notification("You don't have Kinetic equipped.", _G.TimeNotify)
wait(0.05)
Toggles["Auto Full Kinetic"]:SetValue(false)
end
    end
})

Glove2Group:AddButton("Infinite Invisibility", function()
if game.Players.LocalPlayer.Character:FindFirstChild("entered") == nil and game.Players.LocalPlayer.leaderstats.Slaps.Value >= 666 then
local OGlove = CheckGlove()
fireclickdetector(workspace.Lobby.Ghost.ClickDetector)
game.ReplicatedStorage.Ghostinvisibilityactivated:FireServer()
fireclickdetector(workspace.Lobby[OGlove].ClickDetector)
task.wait(1)
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
v.Transparency = 0
end
end
else
Notification("You need to be in lobby and have 666+ slaps.", _G.TimeNotify)
end
end)
----// Set Toggle Anti \\-----
table.insert(_G.ConnectFun, game.Workspace.NoChanged.Changed:Connect(function()
	for i, v in pairs(_G.AntiToggles) do
		spawn(function()
			Toggles[i]:SetValue(game.Workspace.NoChanged.Value)
		end)
	end
end))
elseif game.PlaceId == 11828384869 then
Window:ChangeTitle("Maze Elude 👁️")
Tabs = {
    Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Badge1 = Tabs.Tab:AddLeftGroupbox("Misc")

Badge1:AddButton("Get Elude + Counter", function()
Time = 121
wait(0.4)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.CounterLever.Main.CFrame
game.Workspace.CounterLever.ClickDetector.MouseClick:Connect(function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0,100,0)
wait(0.2)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
for i = 1,Time do
Time = Time - 1
game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = "You wait time [ "..Time.." ] receive.",Icon = "rbxassetid://7733658504",Duration = 1})
wait(1)
end
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
for i, v in pairs(workspace.Maze:GetChildren()) do
if v.Name == "Part" and v:FindFirstChild("A0") and v:FindFirstChild("ClickDetector") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0,-20,0)
v.ClickDetector.MouseClick:Connect(function()
game.Workspace.Ruins.Elude.Glove.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end)
end
end
end)
pcall(function()
fireclickdetector(game.Workspace.CounterLever.ClickDetector)
repeat task.wait() until Time == 0
wait(2)
for i, v in pairs(workspace.Maze:GetChildren()) do
if v.Name == "Part" and v:FindFirstChild("A0") and v:FindFirstChild("ClickDetector") then
fireclickdetector(v.ClickDetector)
end
end
end)
end)

Badge1:AddButton("Teleport Alchemist Plushie", function()
if game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored == true then
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace._ugcQuestObjectEludeHat.Handle.CFrame
else
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace._ugcQuestObjectEludeHat.Handle.CFrame
end
end)
elseif game.PlaceId == 13833961666 then
Window:ChangeTitle("Boss Bob 💥")
if workspace:FindFirstChild("VoidPart") == nil then
local VoidPart = Instance.new("Part", workspace)
VoidPart.Name = "VoidPart"
VoidPart.Position = Vector3.new(-36, -3, 16)
VoidPart.Size = Vector3.new(2000, 1, 2000)
VoidPart.Anchored = true
VoidPart.Transparency = 1
VoidPart.CanCollide = false
end

Tabs = {
	Tab = Window:AddTab("Script", "rbxassetid://8997387937"),
    Tab1 = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Script1Group = Tabs.Tab:AddRightGroupbox("Script")

Script1Group:AddButton("Fly V3", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Fly_V3.lua"))()
end)

Script1Group:AddButton("Anti Lag", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/Anti-lag.lua"))()
end)

Script1Group:AddButton("Inf Yield", function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
end)

Script1Group:AddButton("Executor | Ui Library", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/SCRIPT/Executor.lua"))()
end)

Script1Group:AddButton("RemoteSpy", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Giangplay/Script/main/RemoteSpy-V2.lua", true))()
end)

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Info")

CanYouFps = Misc1Group:AddLabel("Your Fps [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]", true)
CanYouPing = Misc1Group:AddLabel("Your Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]", true)
TimeServer = Misc1Group:AddLabel("Server Time [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]", true)
TimeNow = Misc1Group:AddLabel("Now Time [ "..os.date("%X").." ]", true)
Health = Misc1Group:AddLabel("Health [ "..game.Players.LocalPlayer.Character.Humanoid.Health.." ]", true)
HealthBoss = Misc1Group:AddLabel("Health Boss [ Nah ]", true)
if tonumber(os.date("%H")) >= 5 and tonumber(os.date("%H")) < 12 then
AlarmTime = Misc1Group:AddLabel("Good Morning [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 12 and tonumber(os.date("%H")) < 17 then
AlarmTime = Misc1Group:AddLabel("Good Afternoon [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 17 and tonumber(os.date("%H")) < 21 then
AlarmTime = Misc1Group:AddLabel("Good Evening [ "..tonumber(os.date("%H")).." Hour ]", true)
else
AlarmTime = Misc1Group:AddLabel("Good Night [ "..tonumber(os.date("%H")).." Hour ]", true)
end
AgeAccYou = Misc1Group:AddLabel("You Account Age [ "..game.Players.LocalPlayer.AccountAge.." ]", true)

Misc1Group:AddToggle("Auto Set Info", {
    Text = "Auto Set Info",
    Default = false, 
    Callback = function(Value)
_G.InfoServerSet = Value
    end
})

table.insert(_G.ConnectFun, game.RunService.Heartbeat:Connect(function()
	if not _G.InfoServerSet then return end
	pcall(function()
		CanYouFps:SetText("Your Fps [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]", true)
		CanYouPing:SetText("Your Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]", true)
		TimeServer:SetText("Server Time [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]", true)
		TimeNow:SetText("Now Time [ "..os.date("%X").." ]", true)
		Health:SetText("Health [ "..game.Players.LocalPlayer.Character.Humanoid.Health.." ]", true)
		if game.Workspace:FindFirstChild("BossFolder") and game.Workspace.BossFolder:FindFirstChild("Health") then
			HealthBoss:SetText("Health Boss [ "..game.Workspace.BossFolder.Health.Value.." ]", true)
		else
			HealthBoss:SetText("Check Health Boss [ Not Started Yet ]", true)
		end
		if tonumber(os.date("%H")) >= 5 and tonumber(os.date("%H")) < 12 then
			AlarmTime:SetText("Good Morning [ "..tonumber(os.date("%H")).." Hour ]", true)
		elseif tonumber(os.date("%H")) >= 12 and tonumber(os.date("%H")) < 17 then
			AlarmTime:SetText("Good Afternoon [ "..tonumber(os.date("%H")).." Hour ]", true)
		elseif tonumber(os.date("%H")) >= 17 and tonumber(os.date("%H")) < 21 then
			AlarmTime:SetText("Good Evening [ "..tonumber(os.date("%H")).." Hour ]", true)
		else
			AlarmTime:SetText("Good Night [ "..tonumber(os.date("%H")).." Hour ]", true)
		end
		AgeAccYou:SetText("You Account Age [ "..game.Players.LocalPlayer.AccountAge.." ]", true)
	end)
end))

table.insert(_G.ConnectFun, game.RunService.Heartbeat:Connect(function()
	if _G.AntiRing then
		if game.Workspace:FindFirstChild("Ring") then
			game.Workspace:FindFirstChild("Ring"):Destroy()
		end
	end
	if _G.AntiRagdoll then
		if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") then
			if game.Players.LocalPlayer.Character:WaitForChild("Ragdolled").Value == true then
				game.Players.LocalPlayer.Character.Torso.Anchored = true
			else
				game.Players.LocalPlayer.Character.Torso.Anchored = false
			end
		end
	end
end))

local Misc2Group = Tabs.Tab1:AddLeftGroupbox("Combat")

Misc2Group:AddToggle("Damage Boss", {
    Text = "Damage Boss",
    Default = false, 
    Callback = function(Value)
_G.DameBossBob = Value
while _G.DameBossBob do
if game.Workspace:FindFirstChild("bobBoss") then
game.Workspace.bobBoss.DamageEvent:FireServer()
end
task.wait()
end
    end
})

Misc2Group:AddToggle("Auto Click Tycoon", {
    Text = "Auto Click Tycoon",
    Default = false, 
    Callback = function(Value)
_G.AutoTycoon = Value
while _G.AutoTycoon do
for _, v in pairs(workspace:GetChildren()) do
if string.find(v.Name, "ÅTycoon") and v:FindFirstChild("Click") then
fireclickdetector(v.Click.ClickDetector, 0)
fireclickdetector(v.Click.ClickDetector, 1)
end
end
task.wait()
end
    end
})

Misc2Group:AddDropdown("Glove", {
    Text = "Glove",
    Values = {"Killstreak", "Reaper", "God's Hand", "Tycoon"},
    Default = "Player",
    Multi = false,
    Callback = function(Value)
GloveSlap = Value
    end
})

Misc2Group:AddToggle("Slap Aura Bob Mini", {
    Text = "Slap Aura Bob Mini",
    Default = false, 
    Callback = function(Value)
_G.SlapBobClone = Value
while _G.SlapBobClone do
if game.Workspace:FindFirstChild("BobClone") then
for _, v in pairs(workspace:GetChildren()) do
if v.Name == "BobClone" then
if GloveSlap == "Killstreak" then
game:GetService("ReplicatedStorage").KSHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
elseif GloveSlap == "Reaper" then
game:GetService("ReplicatedStorage").ReaperHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
elseif GloveSlap == "God's Hand" then
game:GetService("ReplicatedStorage").Godshand:FireServer(v:FindFirstChild("HumanoidRootPart"))
elseif GloveSlap == "Tycoon" then
game:GetService("ReplicatedStorage").GeneralHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
end
end
end
end
task.wait()
end
    end
})

Misc2Group:AddButton("Slap Aura Bob Mini", function()
if game.Workspace:FindFirstChild("BobClone") then
for _, v in pairs(workspace:GetChildren()) do
if v.Name == "BobClone" then
if GloveSlap == "Killstreak" then
game:GetService("ReplicatedStorage").KSHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
elseif GloveSlap == "Reaper" then
game:GetService("ReplicatedStorage").ReaperHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
elseif GloveSlap == "God's Hand" then
game:GetService("ReplicatedStorage").Godshand:FireServer(v:FindFirstChild("HumanoidRootPart"))
elseif GloveSlap == "Tycoon" then
game:GetService("ReplicatedStorage").GeneralHit:FireServer(v:FindFirstChild("HumanoidRootPart"))
end
end
end
end
end)

Misc2Group:AddButton("Button Fight Rock", function()
if game.CoreGui:FindFirstChild("SlapRock") == nil then
local ScreenGui = Instance.new("ScreenGui")
local Button = Instance.new("ImageButton")
local Corner = Instance.new("UICorner")
local ParticleEmitter = Instance.new("ParticleEmitter")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SlapRock"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Button.Parent = ScreenGui
Button.Image = "http://www.roblox.com/asset/?id=85284641800085"
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.BorderSizePixel = 0
Button.Position = UDim2.new(0.120833337 - 0.1, 0, 0.0952890813 + 0.01, 0)
Button.Size = UDim2.new(0, 50, 0, 50)
Button.Draggable = true
Corner.Parent = Button
Corner.CornerRadius = UDim.new(0, 12)
ParticleEmitter.Parent = Button
ParticleEmitter.LightEmission = 1
ParticleEmitter.Size = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.1),
    NumberSequenceKeypoint.new(1, 0)
})
ParticleEmitter.Lifetime = NumberRange.new(0.5, 1)
ParticleEmitter.Rate = 0
ParticleEmitter.Speed = NumberRange.new(5, 10)
ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(255, 85, 255), Color3.fromRGB(85, 255, 255))
local ParticleEmitterAmin = game:GetService("TweenService"):Create(Button, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 360})
Button.MouseEnter:Connect(function()
	game:GetService("TweenService"):Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 65, 0, 65)}):Play()
end)
Button.MouseLeave:Connect(function()
	game:GetService("TweenService"):Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 50, 0, 50)}):Play()
end)
Button.MouseButton1Down:Connect(function()
	for i,v in pairs(workspace:GetChildren()) do
		if v.Name == "SpiritRock" and v:FindFirstChild("DamageEvent") then
			v.DamageEvent:FireServer()
		end
	end
    ParticleEmitter.Rate = 100
    task.delay(1, function()
        ParticleEmitter.Rate = 0
    end)
    ParticleEmitterAmin:Play()
    ParticleEmitterAmin.Completed:Connect(function()
        Button.Rotation = 0
    end)
end)
end
end)

local Misc3Group = Tabs.Tab1:AddRightGroupbox("Anti")

Misc3Group:AddButton("Remove Lag", function()
if game.Players.LocalPlayer.PlayerScripts:FindFirstChild("VFXListener") then
	game.Players.LocalPlayer.PlayerScripts.VFXListener:Destroy()
end
for i, v in pairs(game:GetDescendants()) do
	if v.Name:lower():find("screenshake") then
		v:Destroy()
	end
end
end)

Misc3Group:AddToggle("Anti Ring", {
    Text = "Anti Ring",
    Default = false, 
    Callback = function(Value)
_G.AntiRing = Value
    end
}):AddKeyPicker("AntiRing", {
   Default = "X",
   Text = "Anti Ring",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc3Group:AddToggle("Anti Void Damage", {
    Text = "Anti Void Damage",
    Default = false, 
    Callback = function(Value)
game.Workspace["VoidPart"].CanCollide = Value
if Value == true then
	game.Workspace["VoidPart"].Transparency = 0.5
else
	game.Workspace["VoidPart"].Transparency = 1
end
    end
}):AddKeyPicker("AntiVoidDamage", {
   Default = "X",
   Text = "Anti Void Damage",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc3Group:AddToggle("Anti Ragdoll", {
    Text = "Anti Ragdoll",
    Default = false, 
    Callback = function(Value)
_G.AntiRagdoll = Value
    end
}):AddKeyPicker("AntiRagdoll", {
   Default = "X",
   Text = "Anti Ragdoll",
   Mode = "Toggle",
   SyncToggleState = true
})
elseif game.PlaceId == 9431156611 then
if game.Workspace.Map.CodeBrick.SurfaceGui:FindFirstChild("IMGTemplate") then
Code = {}
for i,v in pairs(game.Workspace.Map.CodeBrick.SurfaceGui:GetChildren()) do
	if v.Name == "IMGTemplate" then
	    if v.Image == "http://www.roblox.com/asset/?id=9648769161" then
			    table.insert(Code, "4")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648765536" then
			    table.insert(Code, "2")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648762863" then
			    table.insert(Code, "3")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648759883" then
			    table.insert(Code, "9")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648755440" then
			    table.insert(Code, "8")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648752438" then
			    table.insert(Code, "2")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648749145" then
			    table.insert(Code, "8")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648745618" then
			    table.insert(Code, "3")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648742013" then
			    table.insert(Code, "7")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648738553" then
			    table.insert(Code, "8")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648734698" then
			    table.insert(Code, "2")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648730082" then
			    table.insert(Code, "6")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648723237" then
			    table.insert(Code, "3")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648718450" then
			    table.insert(Code, "6")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648715920" then
			    table.insert(Code, "6")
			elseif v.Image == "http://www.roblox.com/asset/?id=9648712563" then
			    table.insert(Code, "2")
			end
	    end
	end
end

function CheckFire(object)
	local fireObject = {"fire", "flame", "burn", "smoke", "ember"}
	for i, v in pairs(object:GetDescendants()) do
		if v:IsA("Fire") and v.Enabled then
			return true
		end
		local objectName = tostring(v.Name:lower())
		if v:IsA("ParticleEmitter") and v.Enabled then
			return string.find(objectName, fireObject)
		end
		if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			return v.Enabled and string.find(objectName, fireObject)
		end
	end
	return false
end

function canUsePlr(targetPlayer)
	local char = game.Player.LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local target = targetPlayer.Character
	local targetRoot = target and target:FindFirstChild("HumanoidRootPart")
	if not char or not root or not target or not targetRoot then
		return false
	end
	if target:FindFirstChild("Dead") then return false end
	if target:GetAttribute("inBus") or char:GetAttribute("inBus") then return false end
	if not target:GetAttribute("inMatch") or not char:GetAttribute("inMatch") then return false end
	if char:GetAttribute("Ragdolled") then return false end
	if (root.Position - targetRoot.Position).Magnitude > 20 then return false end
	return targetRoot
end

function Teleport(root, targetCFrame, lookAtPosition)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    if lookAtPosition then
        local flatLookAt = Vector3.new(lookAtPosition.X, targetCFrame.Position.Y, lookAtPosition.Z)
        Teleport = CFrame.lookAt(targetCFrame.Position, flatLookAt)
    else
        local _, yRotation, _ = root.CFrame:ToOrientation()
        Teleport = CFrame.new(targetCFrame.Position) * CFrame.Angles(0, yRotation, 0)
    end
    root.CFrame = Teleport
    task.wait()
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

function getCrate()
	local cratePart
	if workspace:FindFirstChild("Shipments") and workspace.Shipments:FindFirstChild("Crates") then
		for i,v in pairs(workspace.Shipments.Crates:GetChildren()) do
			if v.Name == "Crate" and not CheckFire(v) then
				cratePart = v:FindFirstChild("HumanoidRootPart")
			end
		end
	end
	return cratePart
end

Window:ChangeTitle("Slap Royale 🏆")

Tabs = {
	Tab = Window:AddTab("Combat", "rbxassetid://7733674079"),
    Tab1 = Window:AddTab("Anti / Misc", "rbxassetid://7734056608"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

TabBoxCombat1 = Tabs.Tab:AddLeftTabbox()
local Combat1Group = TabBoxCombat1:AddTab("Combat")

Combat1Group:AddToggle("Slap Aura", {
    Text = "Slap Aura",
    Default = false, 
    Callback = function(Value)
_G.SlapAura = Value
while _G.SlapAura do
	for i,v in pairs(game.Players:GetChildren()) do
		local targetRoot = canUsePlr(v)
		local toolchar = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Glove")
		if targetRoot and toolchar then
			game.ReplicatedStorage.Remotes.Slap:FireServer(targetRoot)
		end
	end
task.wait(0.45)
end
    end
})

Combat1Group:AddToggle("Slap Aura Crate", {
    Text = "Slap Aura Crate",
    Default = false, 
    Callback = function(Value)
_G.SlapAuraCrate = Value
while _G.SlapAuraCrate do
	local Crate = getCrate()
	if Crate then
		game.ReplicatedStorage.Remotes.Slap:FireServer(Crate)
	end
task.wait(0.05)
end
    end
})

_G.GloveExtendReach = 5
Combat1Group:AddSlider("Extend Glove", {
    Text = "Extend Glove",
    Default = 5,
    Min = 2,
    Max = 20,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.GloveExtendReach = Value
    end
})

 Combat1Group:AddDropdown("Extend Option", {
    Text = "Extend Option",
    Values = {"Meat Stick","Pancake","Growth","North Korea Wall","Slight Extend"},
    Default = "",
    Multi = false,
    Callback = function(Value)
GloveExtendOption = Value
    end
})

 Combat1Group:AddToggle("Extend Glove", {
    Text = "Extend Glove",
    Default = false, 
    Callback = function(Value) 
_G.GloveExtendGet = Value
if _G.GloveExtendGet == false then
	local function GloveOff(v)
		if v:IsA("Tool") and v:FindFirstChild("Glove") then
	        v:FindFirstChild("Glove").Size = Vector3.new(2.5, 2.5, 1.7)
	        v:FindFirstChild("Glove").Transparency = 0
	    end
	end
	for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		GloveOff(v)
	end
	for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
		GloveOff(v)
	end
end
while _G.GloveExtendGet do
local function GloveReachOn(v)
	if v.ClassName == "Tool" and v:FindFirstChild("Glove") then
        if GloveExtendOption == "Meat Stick" then
	        GloveReachTo = Vector3.new(0, _G.GloveExtendReach, 2)
        elseif GloveExtendOption == "Pancake" then
	        GloveReachTo = Vector3.new(0, _G.GloveExtendReach, _G.GloveExtendReach)
        elseif GloveExtendOption == "Growth" then
	        GloveReachTo = Vector3.new(_G.GloveExtendReach,_G.GloveExtendReach,_G.GloveExtendReach)
        elseif GloveExtendOption == "North Korea Wall" then
	        GloveReachTo = Vector3.new(_G.GloveExtendReach,0,_G.GloveExtendReach)
        elseif GloveExtendOption == "Slight Extend" then
	        GloveReachTo = Vector3.new(3, 3, 3.7)
		end
        v:FindFirstChild("Glove").Size = GloveReachTo or Vector3.new(2.5, 2.5, 1.7)
        v:FindFirstChild("Glove").Transparency = 0.5
    end
end
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	GloveReachOn(v)
end
for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
	GloveReachOn(v)
end
task.wait()
end
    end
})

_G.ReachHitbox = 10
Combat1Group:AddSlider("Reach HitBox", {
    Text = "Reach Hitbox",
    Default = 10,
    Min = 10,
    Max = 25,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ReachHitbox = Value
    end
})

Combat1Group:AddToggle("Hitbox Player", {
    Text = "Hitbox Player",
    Default = false, 
    Callback = function(Value) 
_G.HitboxPlayer = Value
while _G.HitboxPlayer do
for i,v in pairs(game.Players:GetChildren()) do
    if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        v.Character.HumanoidRootPart.Size = Vector3.new(_G.ReachHitbox,_G.ReachHitbox,_G.ReachHitbox)
        v.Character.HumanoidRootPart.Transparency = 0.75
    end
end
task.wait()
end
if _G.HitboxPlayer == false then
	for i,v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            v.Character.HumanoidRootPart.Transparency = 1
        end
    end
end
    end
})

Combat1Group:AddButton({
    Text = "Leave Bus Early",
    Tooltip = "People Vote You",
    Func = function()
game.ReplicatedStorage.Remotes.BusJumping:FireServer()
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("JumpPrompt")
game.Players.LocalPlayer.PlayerGui.JumpPrompt:Destroy()
    end
})

local Combat2Group = Tabs.Tab:AddRightGroupbox("Item")

Combat2Group:AddToggle("Auto Use Item Power", {
    Text = "Auto Use Item Power",
    Default = false,
    Callback = function(Value)
_G.AutoUseItemPower = Value
while _G.AutoUseItemPower do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
	for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	    if v.Name == "Bull's essence" or v.Name == "Potion of Strength" or v.Name == "Boba" or v.Name == "Speed Potion" or v.Name == "Frog Potion" or v.Name == "Strength Brew" or v.Name == "Frog Brew" or v.Name == "Speed Brew" then
			task.wait(0.4)
	        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
	        v:Activate()
	    end
	end
end
task.wait()
end
    end
})

Combat2Group:AddToggle("Auto Pickup Item", {
    Text = "Auto Pickup Item",
    Default = false,
    Callback = function(Value)
_G.AutoPickUpItem = Value
while _G.AutoPickUpItem do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	for i, v in ipairs(game.Workspace.Items:GetChildren()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") and typeof(v.Handle:GetAttribute("ItemId")) == "string" then
			if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Handle.Position).Magnitude <= 13 then
				game.ReplicatedStorage.Remotes.Item:FireServer(v:FindFirstChild("Handle"):GetAttribute("ItemId"))
			end
		end
	end
end
task.wait(0.3)
end
    end
})

Combat2Group:AddSlider("Health Throw Tomahawk", {
    Text = "Health Aimbot",
    Default = 25,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ThrowTomahawk = Value
    end
})

Combat2Group:AddToggle("Throw Aimbot Tomahawk", {
    Text = "Auto Throw Tomahawk",
    Default = false,
    Callback = function(Value)
_G.TomahawkAimbot = Value
while _G.TomahawkAimbot do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	if game.Players.LocalPlayer.Character:FindFirstChild("Tomahawk") then
		for i,v in pairs(game.Players:GetChildren()) do
			local targetRoot = canUsePlr(v)
			if targetRoot and targetRoot.Parent and targetRoot.Parent:FindFirstChildOfClass("Humanoid").Health <= _G.ThrowTomahawk or 50 then
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Throw"):FireServer(targetRoot.Position + Vector3.new(0, 3, 0))
			end
		end
	end
end
task.wait()
end
    end
})

Combat2Group:AddSlider("AutoHeal", {
    Text = "Auto Heal",
    Default = 25,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Compact = true
})

Combat2Group:AddToggle("Auto Heal", {
    Text = "Auto Heal",
    Default = false,
    Callback = function(Value)
_G.AutoHeal = Value
while _G.AutoHeal do
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
	for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		for x, n in pairs({"Apple", "Bandage", "Boba", "First Aid Kit", "Healing Brew", "Healing Potion"}) do
			if v.Name == n and game.Players.LocalPlayer.Character.Humanoid.Health < (Options["AutoHeal"].Value or 45) then
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
				wait(0.27)
				v:Activate()	
				break
			end
		end
	end
end
task.wait(0.3)
end
    end
})

local Esp1Group = TabBoxCombat1:AddTab("ESP") 

function findName(object, name)
	for i, v in pairs(object:GetChildren()) do
		if v.Name:lower():find(name:lower()) then
			return v
		end
	end
	return nil
end
function ShowPlr(targetPlayer)
	local target = targetPlayer.Character
	local targetHumanoid = target and target:FindFirstChild("Humanoid")
	local glove, power, kills = findName(targetPlayer, "glove"), findName(target, "power"), findName(target, "kill")
	local text = glove and glove.Value or "?"
	text = text.." | Health: "..math.floor((targetHumanoid.Health / targetHumanoid.MaxHealth) * 100).."%\nPower: "..power.Value.."| Kills: "..kills.Value
	return text
end

Esp1Group:AddToggle("Esp Glove", {
    Text = "Esp Glove",
    Default = false, 
    Callback = function(Value) 
_G.EspPlayer = Value
for i, v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
		ESPLibrary:RemoveESP(v.Character)
	end
end
while _G.EspPlayer do
local ColorGlove = _G.ColorESP or Color3.new(255,255,255)
for i,v in ipairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Dead") == nil and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		ESPLibrary:AddESP({Object = v.Character, Text = ShowPlr(v), Color = ColorGlove})
		ESPLibrary:UpdateObjectText(v.Character, ShowPlr(v))
		ESPLibrary:UpdateObjectColor(v.Character, ColorGlove)
		ESPLibrary:SetOutlineColor(ColorGlove)
	elseif v.Character:FindFirstChild("Dead") then
		ESPLibrary:RemoveESP(v.Character)
	end
end
task.wait()
end
    end
}):AddColorPicker("Color Esp", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.ColorESP = Value
     end
})

local ESPConnections = {}
local function HandleItemESP(tool, enable)
    local partItem = tool:FindFirstChild("Handle")
    if not partItem then
        return
    end    
    if enable then
        if tool:GetAttribute("HasESP") then
            return
       end
        local itemColor = _G.ColorESP1 or Color3.fromRGB(0,255,0)
        ESPLibrary:AddESP({
            Object = partItem,
            Text = tool.Name,
            Color = itemColor
        })
        ESPLibrary:UpdateObjectText(partItem, tool.Name)
        ESPLibrary:UpdateObjectColor(partItem, itemColor)
        ESPLibrary:SetOutlineColor(itemColor)
        tool:SetAttribute("HasESP", true)
    else
        ESPLibrary:RemoveESP(partItem)
        tool:SetAttribute("HasESP", nil)
    end
end

local function IsItemOnGround(tool)
    if not tool or not tool.Parent then
        return false
    end
    if tool.Parent:IsA("Backpack") then
        return false
    end
    local character = tool:FindFirstAncestorOfClass("Model")
    if character and character:FindFirstChildOfClass("Humanoid") then
        return false
    end
    return true
end

local function SetupTool(tool)
    if not tool:IsA("Tool") or not tool:FindFirstChild("Handle") or tool:FindFirstChild("Glove") then
        return
    end
    if IsItemOnGround(tool) then
        HandleItemESP(tool, true)
    end
    if ESPConnections[tool] then
        ESPConnections[tool]:Disconnect()
    end
    ESPConnections[tool] = tool.AncestryChanged:Connect(function()
        if not tool.Parent then
            HandleItemESP(tool, false)
            if ESPConnections[tool] then
                ESPConnections[tool]:Disconnect()
                ESPConnections[tool] = nil
            end
            return
        end
        if IsItemOnGround(tool) then
            HandleItemESP(tool, true)
        else
            HandleItemESP(tool, false)
        end
    end)
end

workspace.DescendantAdded:Connect(function(v)
    if _G.ItemESP and v:IsA("Tool") then
        task.wait()
        SetupTool(v)
    end
end)

Esp1Group:AddToggle("Esp1", {
    Text = "Item Esp",
    Default = false, 
    Callback = function(Value) 
_G.ItemESP = Value
task.spawn(function()
	for _, v in ipairs(workspace:GetDescendants()) do
	    if v:IsA("Tool") then
	        SetupTool(v)
	    end
	end
    while _G.ItemESP do
        task.wait(1)
    end
    for tool, connection in pairs(ESPConnections) do
        if connection then
            connection:Disconnect()
        end
        HandleItemESP(tool, false)
    end
    table.clear(ESPConnections)
end)
    end
}):AddColorPicker("Color Esp Item", {
     Default = Color3.new(9, 237, 32),
     Callback = function(Value)
_G.ColorESP1 = Value
     end
})

Esp1Group:AddDivider()

local Font = {}
for _, v in ipairs(Enum.Font:GetEnumItems()) do
    table.insert(Font, v.Name)
end
Esp1Group:AddDropdown("Font", {
    Text = "Set Font",
    Values = Font,
    Default = "Code",
    Multi = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFont(Value)
end
    end
})

Esp1Group:AddToggle("Show Distance", {
    Text = "Show Distance",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetShowDistance(Value)
end
    end
})

Esp1Group:AddToggle("Show Rainbow", {
    Text = "Show Rainbow",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetRainbow(Value)
end
    end
})

Esp1Group:AddToggle("Show Tracers", {
    Text = "Show Tracers",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracers(Value)
end
    end
})

Esp1Group:AddDropdown("TracersOrigin", {
    Text = "Tracers Origin",
    Multi = false,
    Values = {"Bottom", "Top", "Center", "Mouse"},
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTracerOrigin(Value)
end
    end
})

Esp1Group:AddToggle("Show Arrows", {
    Text = "Show Arrows",
    Default = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrows(Value)
end
    end
})

Esp1Group:AddSlider("ArrowsSize", {
    Text = "Set Arrows Radius",
    Default = 300,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetArrowRadius(Value)
end
    end
})

Esp1Group:AddSlider("SetTextSize", {
    Text = "Set TextSize",
    Default = 15,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetTextSize(Value)
end
    end
})

Esp1Group:AddSlider("SetFillTransparency", {
    Text = "Set Fill Transparency",
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetFillTransparency(Value)
end
    end
})

Esp1Group:AddSlider("SetOutlineTransparency", {
    Text = "Set OutLine Transparency",
    Default = 0.6,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
if ESPLibrary then
	ESPLibrary:SetOutlineTransparency(Value)
end
    end
})

local Anti1Group = Tabs.Tab1:AddLeftGroupbox("Anti")

Anti1Group:AddToggle("Anti Ice", {
    Text = "Anti Ice",
    Default = false, 
    Callback = function(Value)
_G.AntiIce = Value
while _G.AntiIce do
for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v.Name == "Icecube" then
        v:Destroy()
        if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
            game.Players.LocalPlayer.Character.Humanoid.AutoRotate = true
		end
    end
end
task.wait()
end
    end
})

Anti1Group:AddToggle("Anti Acid", {
    Text = "Anti Acid",
    Default = false, 
    Callback = function(Value)
for i, v in pairs(workspace.Map.AcidAbnormality:GetDescendants()) do
	if v.Name == "Acid" and v:IsA("BasePart") then
		v.CanTouch = not Value
		v.CanCollide = Value
	end
end
    end
})

Anti1Group:AddToggle("Anti Lava", {
    Text = "Anti Lava",
    Default = false, 
    Callback = function(Value)
local Lava = workspace.Map:FindFirstChild("DragonDepths", true):FindFirstChild("Lava", true)
if Lava then
	Lava.CanTouch = not Value
	Lava.CanCollide = Value
end
    end
})

Anti1Group:AddDropdown("Anti RagdollV", {
    Text = "Anti Ragdoll",
    Values = {"V0.5", "V1", "V2", "V3"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.AntiRagdolledV = Value
    end
})

Anti1Group:AddToggle("Anti Ragdoll", {
    Text = "Anti Ragdoll",
    Default = false,
    Callback = function(Value)
_G.AntiRagdoll = Value
if Value == false then
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiRagBV") then
		game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiRagBV"):Destroy()
	end
	if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
		game.Players.LocalPlayer.Character.Torso.Anchored = false
	end
end
    end
})

table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
if _G.AntiRagdoll then
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		if game.Players.LocalPlayer.Character:GetAttribute("Ragdolled") then
			for i, v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
				if v:IsA("BodyVelocity") or v:IsA("VectorForce") or v:IsA("LinearVelocity") or v:IsA("BodyGyro") or v:IsA("BodyAngularVelocity") then
					if not (v.Name == "AntiRagBV" or v.Name == "GyroHandler" or v.Name == "VelocityHandler" or v.Name == "FreezeBV") then
						v:Destroy()
					end
				end
			end
			if _G.AntiRagdolledV == "V2" then
				CreateFreezeBV({Name = "AntiRagBV"})
			end
			if _G.AntiRagdolledV == "V1" then
				if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
					game.Players.LocalPlayer.Character.Torso.Anchored = true
				end
			end
			if _G.AntiRagdolledV == "V3" then
				local MoveDarTo = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.MoveDirection
		        if MoveDarTo and MoveDarTo.Magnitude > 0 then
		            game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):Move(MoveDarTo, false)
		        end
				if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
					game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Running)
				end
				for i, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
		            if v:IsA("Motor6D") then
		                v.Enabled = true
		            elseif v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
		                v.Enabled = false
		            end
		        end
			end
		else
			CreateFreezeBV({Name = "AntiRagBV", Remove = true})
			if game.Players.LocalPlayer.Character:FindFirstChild("Torso") then
				game.Players.LocalPlayer.Character.Torso.Anchored = false
			end
		end
	end
end
end))

local Misc1Group = Tabs.Tab1:AddRightGroupbox("Misc")

CodeLab = Misc1Group:AddLabel("Code [ ???? ]")

Misc1Group:AddButton("Get Lab Code", function()
if Code and CodeLab then
	CodeLab:SetText("Code [ "..table.concat(Code).." ]")
end
end)

Misc1Group:AddButton("Get Chain", function()
if Code then
	for i, v in pairs(game.Workspace.Map.OriginOffice:GetChildren()) do
		if v.Name:lower():find("codedoor") and v:FindFirstChild("Door") and v.Door:FindFirstChild("Keypad") and v.Door.Keypad:FindFirstChild("Buttons") then
			fireclickdetector(v.Door.Keypad.Buttons.Reset.ClickDetector)
			wait(0.25)
			for i = 1, #Code do
				local CodeNah = Code[i]
				fireclickdetector(v.Door.Keypad.Buttons[CodeNah].ClickDetector)
				wait(0.25)
			end
			wait(0.25)
			fireclickdetector(v.Door.Keypad.Buttons.Enter.ClickDetector)
		end
	end
end
end)
elseif game.PlaceId == 14422118326 then
Window:ChangeTitle("Maze Null ☠️")

Tabs = {
    Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Misc")

Misc1Group:AddToggle("Anti Null", {
    Text = "Anti Null",
    Default = false, 
    Callback = function(Value) 
_G.AntiNull = Value
while _G.AntiNull do
for i,v in pairs(game.Workspace.Mobs:GetChildren()) do
if v.Name == "Imp" and v:FindFirstChild("Body") then
game:GetService("ReplicatedStorage").b:FireServer(v.Body)
end
end
task.wait()
end
    end
})

Misc1Group:AddInput("FlySpeed", {
    Default = "50",
    Numeric = true,
    Text = "Fly Speed",
    Placeholder = "UserFlySpeed",
    Callback = function(Value)  
        _G.SetSpeedFly = Value  
    end  
})

_G.SetSpeedFly = 50
Misc1Group:AddToggle("Start Fly", {
    Text = "Start Fly",
    Default = false, 
    Callback = function(Value) 
Fly(Value)
	end
}):AddKeyPicker("Fly", {
   Default = "R",
   Text = "Fly",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc1Group:AddButton("Teleport Rob Plushie", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4833.31, -214, 800.529)
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace._ugcQuestObjectBobPlushie.Handle.CFrame
end)

Misc1Group:AddDropdown("Badge", {
    Text = "Badge",
    Values = {"Tinkever", "Null"},
    Default = "",
    Multi = false,
    Callback = function(Value)
if Value == "Null" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5458, -184, 1822)
elseif Value == "Tinkever" then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4833.31, -214, 800.529)
end
    end
})
elseif game.PlaceId == 16034567693 then
Window:ChangeTitle("ADMIN ROOM 💻")
Tabs = {
    Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local InfoServer1Group = Tabs.Tab:AddLeftGroupbox("Info")

CanYouFps = InfoServer1Group:AddLabel("Your Fps [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]", true)
CanYouPing = InfoServer1Group:AddLabel("Your Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]", true)
ServerPlayer = InfoServer1Group:AddLabel("Player In Server [ "..#game.Players:GetPlayers().." / "..game.Players.MaxPlayers.." ]", true)
TimeServer = InfoServer1Group:AddLabel("Server Time [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]", true)
TimeNow = InfoServer1Group:AddLabel("Now Time [ "..os.date("%X").." ]", true)
if tonumber(os.date("%H")) >= 5 and tonumber(os.date("%H")) < 12 then
AlarmTime = InfoServer1Group:AddLabel("Good Morning [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 12 and tonumber(os.date("%H")) < 17 then
AlarmTime = InfoServer1Group:AddLabel("Good Afternoon [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 17 and tonumber(os.date("%H")) < 21 then
AlarmTime = InfoServer1Group:AddLabel("Good Evening [ "..tonumber(os.date("%H")).." Hour ]", true)
else
AlarmTime = InfoServer1Group:AddLabel("Good Night [ "..tonumber(os.date("%H")).." Hour ]", true)
end
AgeAccYou = InfoServer1Group:AddLabel("You Account Age [ "..game.Players.LocalPlayer.AccountAge.." ]", true)

InfoServer1Group:AddToggle("Toggle Set", {
    Text = "Toggle Return",
    Default = false,
    Callback = function(Value)
_G.AutoSetInfo = Value
if _G.AutoSetInfo == true then
AutoSetInfoServer = game:GetService("RunService").RenderStepped:Connect(function()
if _G.AutoSetInfo == true then
CanYouFps:SetText("Your Fps [ "..math.floor(workspace:GetRealPhysicsFPS()).." ]", true)
CanYouPing:SetText("Your Ping [ "..game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString().." ]", true)
ServerPlayer:SetText("Player In Server [ "..#game.Players:GetPlayers().." / "..game.Players.MaxPlayers.." ]", true)
TimeServer:SetText("Server Time [ "..math.floor(workspace.DistributedGameTime / 60 / 60).." Hour | "..math.floor(workspace.DistributedGameTime / 60) - (math.floor(workspace.DistributedGameTime / 60 / 60) * 60).." Minute | "..math.floor(workspace.DistributedGameTime) - (math.floor(workspace.DistributedGameTime / 60) * 60).." Second ]", true)
TimeNow:SetText("Now Time [ "..os.date("%X").." ]", true)
if tonumber(os.date("%H")) >= 5 and tonumber(os.date("%H")) < 12 then
AlarmTime:SetText("Good Morning [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 12 and tonumber(os.date("%H")) < 17 then
AlarmTime:SetText("Good Afternoon [ "..tonumber(os.date("%H")).." Hour ]", true)
elseif tonumber(os.date("%H")) >= 17 and tonumber(os.date("%H")) < 21 then
AlarmTime:SetText("Good Evening [ "..tonumber(os.date("%H")).." Hour ]", true)
else
AlarmTime:SetText("Good Night [ "..tonumber(os.date("%H")).." Hour ]", true)
end
AgeAccYou:SetText("You Account Age [ "..game.Players.LocalPlayer.AccountAge.." ]", true)
end
end)
end
if _G.AutoSetInfo == false then
if AutoSetInfoServer then
AutoSetInfoServer:Disconnect()
AutoSetInfoServer = nil
return AutoSetInfoServer
end
end
    end
})

local Misc2Group = Tabs.Tab:AddRightGroupbox("Misc")

Misc2Group:AddToggle("Anti Afk", {
    Text = "Anti Afk",
    Default = false, 
    Callback = function(Value)
_G.AntiAfk = Value
for i,v in next, getconnections(game.Players.LocalPlayer.Idled) do
if _G.AntiAfk then
v:Disable()
else
v:Enable()
end
end
    end
})

Misc2Group:AddButton("Teleport Room", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(502, 76, 59)
wait(4)
Toggles["Anti Afk"]:SetValue(true)
end)
elseif game.PlaceId == 17290438723 then
Window:ChangeTitle("Frostbite Map Obby 🎿")
Tabs = {
    Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Misc")

Misc1Group:AddButton("Teleport Badge", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-554, 177, 56)
wait(0.7)
for i,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
            if v.ClassName == "ProximityPrompt" then
                v.HoldDuration = 0
                fireproximityprompt(v)
            end
        end
end)
elseif game.PlaceId == 18550498098 then
Window:ChangeTitle("Boss Guide ⚔️")
if game.Workspace:FindFirstChild("VoidPart") == nil then
local VoidPart = Instance.new("Part", workspace)
VoidPart.Position = Vector3.new(538, 55, -231)
VoidPart.Name = "VoidPart"
VoidPart.Size = Vector3.new(2048, 11, 2048)
VoidPart.Anchored = true
VoidPart.Transparency = 1
VoidPart.CanCollide = false

local Safe = Instance.new("Part", VoidPart)
Safe.Position = Vector3.new(595, 120, -330)
Safe.Name = "Safe"
Safe.Size = Vector3.new(2000, 10, 2000)
Safe.Anchored = true
Safe.Transparency = 0.5 
Safe.CanCollide = true
end

Tabs = {
	Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
    Tab1 = Window:AddTab("Anti", "rbxassetid://7734056608"),
    Tab2 = Window:AddTab("Local", "rbxassetid://4335489011"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Prepare")

Misc1Group:AddButton("Start Enter + 1 HP", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3258, -68, 823)
wait(2.8)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace["the cube of life"].Part.CFrame
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace["Big Heart"].CFrame
wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.ShackLever.Base.CFrame
wait(0.5)
for i,v in pairs(game.Workspace:GetDescendants()) do
	if v.Name == "ShackLever" and v:FindFirstChild("ClickDetector") then
		fireclickdetector(v.ClickDetector, 0)
		fireclickdetector(v.ClickDetector, 1)
	end
end
end):AddButton("Start Enter", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3258, -68, 823)
wait(2)
for i,v in pairs(game.Workspace:GetDescendants()) do
	if v.Name == "ShackLever" and v:FindFirstChild("ClickDetector") then
		fireclickdetector(v.ClickDetector, 0)
		fireclickdetector(v.ClickDetector, 1)
	end
end
end)

Misc1Group:AddButton("Teleport Safe", function()
if game.Workspace.VoidPart:FindFirstChild("Safe") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.VoidPart.Safe.CFrame * CFrame.new(0,25,0)
end
end):AddButton("Guide", function()
if game.Workspace.VoidPart:FindFirstChild("Safe") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.VoidPart.Safe.CFrame * CFrame.new(0,-40,0)
end
end)

Misc1Group:AddButton("Lever Lobby", function()
for i,v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name == "Gate1Lever" and v:FindFirstChild("ClickDetector") then
fireclickdetector(v.ClickDetector, 0)
fireclickdetector(v.ClickDetector, 1)
                    end
                end
end)

Misc1Group:AddInput("FlySpeed", {
    Default = "50",
    Numeric = true,
    Text = "Fly Speed",
    Placeholder = "UserFlySpeed",
    Callback = function(Value)  
        _G.SetSpeedFly = Value  
    end  
})

_G.SetSpeedFly = 50
Misc1Group:AddToggle("Start Fly", {
    Text = "Start Fly",
    Default = false, 
    Callback = function(Value) 
Fly(Value)
	end
}):AddKeyPicker("Fly", {
   Default = "R",
   Text = "Fly",
   Mode = "Toggle",
   SyncToggleState = true
})

local Misc2Group = Tabs.Tab:AddRightGroupbox("Combat")

function slapglove(object)
	local player = game.Players.LocalPlayer
	if not player then return end
	local char = player.Character
	local backpack = player.Backpack
	if not char then return end
	local part = object
	if not part then return end
	if backpack:FindFirstChild("Lantern") then
		backpack:FindFirstChild("Lantern").Parent = game.Players.LocalPlayer.Character
	end
	if char:FindFirstChild("Lantern") and char.Lantern:FindFirstChild("Network") then
		char.Lantern:Activate()
		char.Lantern.Network:FireServer("Hit", part)
	end
end

Misc2Group:AddToggle("Fight Trask", {
    Text = "Auto Slap Trask",
    Default = false, 
    Callback = function(Value) 
_G.BringTrask = Value
while _G.BringTrask do
for i,v in pairs(game.Workspace:GetChildren()) do
	if v.Name:lower() == "trackglovemissile" then
		slapglove(v)
	end
end
task.wait()
end
    end
}):AddKeyPicker("FightTrask", {
   Default = "V",
   Text = "Fight Trask",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc2Group:AddToggle("Fight Boss Final", {
    Text = "Slap  Boss Final",
    Default = false, 
    Callback = function(Value) 
_G.FightBossFinal = Value
while _G.FightBossFinal do
if game.Workspace:FindFirstChild("GuideNPC") and game.Workspace.GuideNPC:FindFirstChild("HumanoidRootPart") then
	slapglove(game.Workspace.GuideNPC.HumanoidRootPart)
end
task.wait()
end
    end
}):AddKeyPicker("FightBossFinal", {
   Default = "V",
   Text = "Fight Boss Final",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc2Group:AddToggle("Fight Replica", {
    Text = "Fight Replica",
    Default = false, 
    Callback = function(Value) 
_G.FightReplica = Value
while _G.FightReplica do
for i,v in pairs(game.workspace:GetChildren()) do
	if v.Name:lower() == "replicanpc" and v:FindFirstChild("HumanoidRootPart") then
		slapglove(v.HumanoidRootPart)
	end
end
task.wait()
end
    end
}):AddKeyPicker("FightReplica", {
   Default = "V",
   Text = "Fight Replica",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc2Group:AddToggle("Fight Golem", {
    Text = "Fight Golem",
    Default = false, 
    Callback = function(Value) 
_G.FightGolem = Value
while _G.FightGolem do
for i,v in pairs(game.Workspace:GetChildren()) do
	if v.Name:lower() == "golem" or v.Name:lower() == "dungeongolem" then
		slapglove(v:FindFirstChild("Hitbox") or v:FindFirstChild("Cube.001"))
	end
end
task.wait()
end
    end
}):AddKeyPicker("FightGolem", {
   Default = "V",
   Text = "Fight Golem",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc2Group:AddToggle("Fight All", {
    Text = "Fight All",
    Default = false, 
    Callback = function(Value) 
_G.FightAll = Value
while _G.FightAll do
for i,v in pairs(game.Workspace:GetChildren()) do
	if v.Name:lower() == "trackglovemissile" or v.Name:lower() == "golem" or v.Name:lower() == "dungeongolem" or v.Name:lower() == "replicanpc" or v.Name:lower() == "guidenpc" then
		slapglove(v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Hitbox") or v:FindFirstChild("Cube.001") or v)
	end
end
task.wait()
end
    end
}):AddKeyPicker("FightAll", {
   Default = "O",
   Text = "Fight All",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc2Group:AddButton("Fight Potato", function()
if game.Workspace:FindFirstChild("PotatoLord") and game.Workspace.PotatoLord:FindFirstChild("HumanoidRootPart") then
	slapglove(game.Workspace.PotatoLord.HumanoidRootPart)
end
end)

local Anti1Group = Tabs.Tab1:AddLeftGroupbox("Anti")

Anti1Group:AddToggle("Anti Void", {
    Text = "Anti Void",
    Default = false, 
    Callback = function(Value) 
game.Workspace.VoidPart.CanCollide = Value
if Value == true then
game.Workspace.VoidPart.Transparency = 0.5
else
game.Workspace.VoidPart.Transparency = 1
end
    end
})

Anti1Group:AddToggle("Anti Sbeve", {
    Text = "Anti Sbeve",
    Default = false, 
    Callback = function(Value) 
_G.AntiSbeve = Value
while _G.AntiSbeve do
for i,v in pairs(game.Workspace.Sbeves:GetChildren()) do
                    if v.Name == "sbeveai" then
                        v.CanTouch = false
                    end
                end
task.wait()
end
    end
})

Anti1Group:AddToggle("Anti Wall", {
    Text = "Anti Wall",
    Default = false, 
    Callback = function(Value) 
_G.AntiWall = Value
while _G.AntiWall do
for i,v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == "PusherWall" then
                        v.CanCollide = false
                    end
                end
task.wait()
end
    end
})

local Local1Group = Tabs.Tab2:AddLeftGroupbox("Speed")

Local1Group:AddSlider("WalkSpeed", {
    Text = "Speed",
    Default = 20,
    Min = 20,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
Walkspeed = Value
    end
})

Local1Group:AddInput("WalkSpeed1", {
    Default = "20",
    Numeric = false,
    Text = "Speed",
    Placeholder = "UserSpeed",
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
Walkspeed = Value
    end
})

Local1Group:AddToggle("SetSpeed", {
    Text = "Auto Set Speed",
    Default = false, 
    Callback = function(Value) 
KeepWalkspeed = Value
            while KeepWalkspeed do
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.WalkSpeed ~= Walkspeed then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Walkspeed
                end
task.wait()
            end
    end
})

local Local2Group = Tabs.Tab2:AddRightGroupbox("Jump")

Local2Group:AddSlider("JumpPower", {
    Text = "Jump",
    Default = 50,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
Jumppower = Value
    end
})

Local2Group:AddInput("JumpPower1", {
    Default = "50",
    Numeric = true,
    Text = "Jump",
    Placeholder = "UserJump",
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
Jumppower = Value
    end
})

Local2Group:AddToggle("SetJump", {
    Text = "Auto Set Jump",
    Default = false, 
    Callback = function(Value) 
KeepJumppower = Value
            while KeepJumppower do
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil and game.Players.LocalPlayer.Character.Humanoid.JumpPower ~= Jumppower then
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Jumppower
                end
task.wait()
            end
    end
})
elseif game.PlaceId == 7234087065 then
spawn(function()
	while true do
		Dialogue = game.Workspace:FindFirstChild("DialoguePrompts")
		NPC = game.Workspace:FindFirstChild("NPCS")
		Buildings = game.Workspace:FindFirstChild("Buildings")
		task.wait()
	end
end)

Window:ChangeTitle("Lobby OOG 🐕")
Tabs = {
	Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Main")

Misc1Group:AddButton("Get Badge OOG", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.QuestStuff.Key.CFrame
	task.wait(0.5)
	game:GetService("ReplicatedStorage").RemoteEvents.SuitUpClown:FireServer()
	task.wait(0.25)
	game:GetService("ReplicatedStorage").RemoteEvents.KeyQuest:FireServer()
	task.wait(0.25)
	game:GetService("ReplicatedStorage").RemoteEvents.KeyAcquired:FireServer()
	task.wait(0.25)
	game:GetService("ReplicatedStorage").RemoteEvents.GOHOME:FireServer()
	task.wait(0.25)
	game:GetService("ReplicatedStorage").RemoteEvents.KeyBadgeReward:FireServer()
end
end)

Misc1Group:AddButton("Get Badge Riftshot", function()
if Dialogue and Dialogue:FindFirstChild("Sharpshooter Sam") then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Dialogue["Sharpshooter Sam"].CFrame
end
Notification("Bypass Success, Now bomb will bring you, your job is to shoot", 5)
wait(0.3)
for i,v in ipairs(game:GetService("Workspace"):GetDescendants()) do
    if v.Name:find("Sharpshooter Sam's") then
        SharpshooterTarget = v
    end
end
wait(0.3)
while true do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	if SharpshooterTarget then
		for i, v in pairs(SharpshooterTarget:GetChildren()) do
			if v.Name:find("bomb") and v:FindFirstChild("Handle") then
				v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -7)
			end
		end
	end
end
task.wait()
end
end)

Misc1Group:AddButton("Get Badge Boxer", function()
if game.Workspace:FindFirstChild("BoxingGloves") == nil then
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Buildings.house:FindFirstChild("TP").CFrame * CFrame.new(0,10,0)
end
repeat task.wait() until game.Workspace:FindFirstChild("BoxingGloves")
wait(0.6)
if game.Workspace:FindFirstChild("BoxingGloves"):FindFirstChild("ClickDetector") then
	fireclickdetector(game.Workspace.BoxingGloves.ClickDetector, 0)
	fireclickdetector(game.Workspace.BoxingGloves.ClickDetector, 1)
end
end)

Misc1Group:AddDivider()
Misc1Group:AddButton("Enter Event Area", function()
for i, v in ipairs(workspace.Signs:GetChildren()) do
	if v.Name == "Sign" and v:FindFirstChild("Text") and v.Text:FindFirstChild("ClickDetector") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Text.CFrame
		if fireclickdetector then
			fireclickdetector(v.Text.ClickDetector, 0)
			fireclickdetector(v.Text.ClickDetector, 1)
		end
	end
end
end)

Misc1Group:AddButton("Enter Designer Roblox", function()
repeat task.wait()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(249, 94, -62841)
until workspace.Buildings:FindFirstChild("wizard twoer 2")
wait(0.8)
for i, v in pairs(workspace.Buildings["wizard twoer 2"]:GetChildren()) do
	if v.Name == "Model" and v:FindFirstChild("Trigger") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChild("Trigger").CFrame
	end
end
end)

Misc1Group:AddDivider()
Misc1Group:AddToggle("Auto Tp Clock", {
    Text = "Auto Teleport Clock",
    Default = false, 
    Callback = function(Value) 
_G.AutoTPClock = Value
while _G.AutoTPClock do
for i,v in pairs(workspace.Buildings:GetChildren()) do
	if v.Name == "wizard twoer" and v:FindFirstChild("Cone") then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Cone.CFrame * CFrame.new(0,15,0)
	end
end
task.wait()
end
    end
})
elseif game.PlaceId == 74169485398268 then
Window:ChangeTitle("Maze Bind 👁️‍🗨️")
Tabs = {
	Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Get / Teleport")

Misc1Group:AddButton("Teleport Glove", function()
if fireclickdetector then
if game.Workspace:FindFirstChild("Orb") then
fireclickdetector(game.Workspace.Orb.ClickDetector, 0)
fireclickdetector(game.Workspace.Orb.ClickDetector, 1)
end
elseif not fireclickdetector then
if game.Workspace:FindFirstChild("Orb") and game.Workspace.Orb:FindFirstChild("Meshes/rock chain glove_defaultglove_cell.001") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Orb["Meshes/rock chain glove_defaultglove_cell.001"].CFrame
end
end
end)
elseif game.PlaceId == 102908326578005 then
Window:ChangeTitle("OOG Home Jorgis 🏠")
Tabs = {
	Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Misc")

Misc1Group:AddButton("Ball Teleport", function()
for i,v in ipairs(workspace.Furniture.jorgisBasketballs:GetChildren()) do
	if v.Name == "B-Ball" and v:FindFirstChild("ClickDetector") then
		v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		if fireclickdetector then
			fireclickdetector(v.ClickDetector, 0)
			fireclickdetector(v.ClickDetector, 1)
		end
	end
end
end)

Misc1Group:AddButton("Key Teleport", function()
for i,v in ipairs(workspace.Furniture.jorgisDresser:GetChildren()) do
	if v.Name == "Drawer" and v:FindFirstChild("Handle") and v.Handle:FindFirstChild("ClickDetector") then
		v.Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		if fireclickdetector then
			fireclickdetector(v.Handle.ClickDetector, 0)
			fireclickdetector(v.Handle.ClickDetector, 1)
		end
	end
end
end)

Misc1Group:AddButton("Teleport Door", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Furniture.finalDoor.Base.Base.CFrame
end)
elseif game.PlaceId == 115782629143468 then
Window:ChangeTitle("Obby TOH 🪜")
Tabs = {
	Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Misc")

Misc1Group:AddButton("Teleport Badge", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-31, 190, 0)
end)
elseif game.PlaceId == 92516899071319 then
Window:ChangeTitle("Map Dreams 💤")
Tabs = {
	Tab = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Misc")

Misc1Group:AddToggle("Auto Collect Pillow", {
    Text = "Auto Collect Pillow",
    Default = false, 
    Callback = function(Value) 
_G.AutoCollectPillow = Value
while _G.AutoCollectPillow do
for i,v in pairs(game.Workspace.map:GetChildren()) do
	if v.Name == "Meshes/pillow1" and v:FindFirstChild("ClickDetector") then
		fireclickdetector(v:FindFirstChild("ClickDetector"))
		end
	end
task.wait()
end
    end
})

Misc1Group:AddButton("Pick Up Unstable Artifact", function()
	workspace["Unstable Artifact"].Handle.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end)
elseif game.PlaceId == 118650724506449 then
Window:ChangeTitle("Bad Dreams 💤")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc2Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc2Group:AddButton("Teleport Badge", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.rooms["room exit"].EXIT.CFrame
end)
elseif game.PlaceId == 97220865182663 then
Window:ChangeTitle("Boss Mouse 🐀")
if workspace.Game:FindFirstChild("Buildings") and workspace.Game.Buildings:FindFirstChild("City") and workspace.Game.Buildings.City:FindFirstChild("City") == nil then
game:GetService("ReplicatedStorage").Remotes.PlaceBuilding:FireServer("City", Vector3.new(4.6566128730773926e-09, 43.496280670166016, -45), 0)
end

Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Glove 3000 Orb", function()
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UnlockGloveWithOrbs"):FireServer()
end)

Misc1Group:AddToggle("Auto Slap Rat", {
    Text = "Auto Slap Rat",
    Default = false, 
    Callback = function(Value) 
_G.AutoSlapMouse = Value
while _G.AutoSlapMouse do
if game.Workspace:FindFirstChild("Game") and game.Workspace.Game:FindFirstChild("Enemies") then
for i,v in pairs(workspace.Game.Enemies:GetChildren()) do
	if v.Name == "Rat" and v:FindFirstChild("Hitbox") then
	    v.Hitbox.Anchored = true
		game:GetService("ReplicatedStorage").Remotes.GloveHit:FireServer(v.Hitbox)
		end
	end
end
task.wait()
end
    end
})
elseif game.PlaceId == 98726100529621 then
Window:ChangeTitle("Map Obby Hexa 🔰")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Glove", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("Part I") then
workspace["Part I"].Obby["end"].CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
repeat task.wait() until workspace:FindFirstChild("Part 2")
wait(10.5)
end
if workspace:FindFirstChild("Part 2") then
local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
repeat task.wait(1)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(97, 14, 644)
wait(2.4)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
wait(0.8)
until workspace["Part 2"]:FindFirstChild("Portal")
task.wait(2.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Part 2"].Portal.CFrame
repeat task.wait() until workspace:FindFirstChild("Part 3")
wait(9.5)
end
if workspace:FindFirstChild("Part 3") then
workspace["Part 3"].TpToNext.HitBox.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if fireclickdetector then
fireclickdetector(workspace["Part 3"].TpToNext.HitBox:FindFirstChild("Click"))
end
repeat task.wait() until workspace:FindFirstChild("Part 4")
wait(7)
end
if workspace:FindFirstChild("Part 4") then
workspace["Part 4"].TPPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
repeat task.wait() until workspace:FindFirstChild("Part 5")
wait(7)
end
if workspace:FindFirstChild("Part 5") then
workspace["Part 5"].Glove.Hitbox.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
if fireclickdetector then
fireclickdetector(workspace["Part 5"].Glove.Hitbox:FindFirstChild("Click"))
end
repeat task.wait() until workspace:FindFirstChild("Finale") and workspace.Finale:FindFirstChild("Reward")
wait(7)
end
if workspace:FindFirstChild("Finale") and workspace.Finale:FindFirstChild("Reward") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Finale.Reward.Hitbox.CFrame
if fireclickdetector then
fireclickdetector(workspace.Finale.Reward.Hitbox:FindFirstChild("Click"))
end
end
end
end)
elseif game.PlaceId == 136005148166028 then
Window:ChangeTitle("Map Designer Roblox 🛠️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if fireclickdetector then
fireclickdetector(workspace.Kitchen.Fridge.HitBox:FindFirstChild("ClickDetector"))
end
repeat task.wait() until workspace.Kitchen.Fridge:FindFirstChild("GrantAward") or workspace.Kitchen.Fridge:FindFirstChild("GrantAward") == nil
wait(0.25)
if fireclickdetector then
if workspace.Kitchen.Fridge:FindFirstChild("GrantAward") then
fireclickdetector(workspace.Kitchen.Fridge.GrantAward:FindFirstChild("ClickDetector"))
end
end
repeat task.wait() until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Brewzucki") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Brewzucki")
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Brewzucki") then
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Brewzucki").Parent = game:GetService("Players").LocalPlayer.Backpack
end
wait(0.5)
local OldCF = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
if fireclickdetector then
	if workspace.Microwave:FindFirstChild("HitBox") then
		fireclickdetector(workspace.Microwave.HitBox:FindFirstChild("ClickDetector"))
	end
end
wait(0.8)
repeat task.wait()
if fireclickdetector then
	if workspace.Microwave:FindFirstChild("HitBox") then
		fireclickdetector(workspace.Microwave.HitBox:FindFirstChild("ClickDetector"))
	end
end
until game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Brewzucki") or game:GetService("Players").LocalPlayer.Character:FindFirstChild("Brewzucki")
wait(0.2)
if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Brewzucki") then
game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Brewzucki").Parent = game:GetService("Players").LocalPlayer.Character
end
wait(0.3)
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Brewzucki") then
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Brewzucki"):Activate()
end
wait(3.5)
if fireclickdetector then
	fireclickdetector(workspace.BasementTable.HitBox:FindFirstChild("ClickDetector"))
end
wait(1)
if fireproximityprompt then
	fireproximityprompt(workspace.BasementDoor.Door.Base:FindFirstChild("ProximityPrompt"))
end
wait(0.5)
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("RealComputerScreenGui") ~= nil then
if workspace.ComputerChair:FindFirstChild("Seat") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.ComputerChair.Seat.CFrame
end
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("RealComputerScreenGui") and game:GetService("Players").LocalPlayer.PlayerGui.RealComputerScreenGui.Enabled == true
wait(0.5)
if game:GetService("Players").LocalPlayer.PlayerGui.RealComputerScreenGui.ComputerScreen:FindFirstChild("SuggestionsQTE").Visible == true then
repeat task.wait()
for i, v in pairs(game.Players.LocalPlayer.PlayerGui.RealComputerScreenGui.ComputerScreen.SuggestionsQTE:GetChildren()) do
if v.Name:find("Popup_") then
v.Position = game:GetService("Players").LocalPlayer.PlayerGui.RealComputerScreenGui.ComputerScreen.SuggestionsQTE:FindFirstChild("RecyclingBin").Position
end
end
until game:GetService("Players").LocalPlayer.PlayerGui.RealComputerScreenGui.ComputerScreen:FindFirstChild("UpdateGameQTE").Visible == true
game:GetService("Players").LocalPlayer.PlayerGui.RealComputerScreenGui.ComputerScreen.UpdateGameQTE.MainFrame.PatchNotesTextBox.Text = "Articles - Hub, how do you feel, or are things in your life okay, you must be struggling, do you see you are tired or not?, Skibidi Toilet Dop Dop Yes Yes"
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("RealComputerScreenGui") == nil
wait(0.5)
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true then
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
end
end
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Stages.Stage4:FindFirstChild("CloseDavidsDoor").CFrame
wait(0.7)
GuiClick = game:GetService("Players").LocalPlayer.PlayerGui.DavidShrineQTE:FindFirstChild("DavidShrineQTE")
repeat task.wait()
if GuiClick.Mobile.SpawnArea:FindFirstChild("TapLabel") then
GuiClick.Mobile.SpawnArea:FindFirstChild("TapLabel").Size = UDim2.new(1001, 0, 1001, 0)
game:GetService("VirtualUser"):Button1Down(Vector2.new(1, 1))
game:GetService("VirtualUser"):Button1Up(Vector2.new(1, 1))
elseif GuiClick:FindFirstChild("PC").Visible == true and GuiClick.PC:FindFirstChild("QuickTimeLabel").Visible == true then
game:GetService("VirtualInputManager"):SendKeyEvent(true, GuiClick.PC.QuickTimeLabel.Text, false, x)
end
until game:GetService("Players").LocalPlayer.PlayerGui.DavidShrineQTE.DavidShrineQTE:FindFirstChild("ScoreLabel").Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.DavidShrineQTE.DavidShrineQTE:FindFirstChild("ScoreLabel").Text == "Score: 150"
end
end
end)
elseif game.PlaceId == 117232463555132 then
Window:ChangeTitle("Map Retro Boss ⚔️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace.Map.Components.NPCs.FinalBoss:FindFirstChild("FinalBoss") and workspace.Map.Components.NPCs.FinalBoss.FinalBoss:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Components.NPCs.FinalBoss.FinalBoss.HumanoidRootPart.CFrame * CFrame.new(0, 0, -7)
end
wait(0.36)
game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton").Position = UDim2.new(0, 0, 0, 0)
game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton").BackgroundTransparency = 0.77
game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton").Size = UDim2.new(1, 0, 1, 0)
if workspace.Map.Components.NPCs.FinalBoss:FindFirstChild("FinalBoss") and workspace.Map.Components.NPCs.FinalBoss.FinalBoss:FindFirstChild("Head") then
if fireproximityprompt then
fireproximityprompt(workspace.Map.Components.NPCs.FinalBoss.FinalBoss.Head:FindFirstChild("ProximityPrompt"))
end
end
repeat task.wait()
	if firesignal and game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton") then
		firesignal(game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton").Activated)
	end
until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("FinalBossHealthBar") and game:GetService("Players").LocalPlayer.PlayerGui.FinalBossHealthBar:FindFirstChild("FinalBossHealthBar").Visible == true
wait(0.5)
repeat task.wait()
if workspace.Map.Components.NPCs.FinalBoss:FindFirstChild("FinalBoss") and workspace.Map.Components.NPCs.FinalBoss.FinalBoss:FindFirstChild("HumanoidRootPart") then
if game.Players.LocalPlayer.Backpack:FindFirstChild("Default") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Default").Parent = game.Players.LocalPlayer.Character
end
workspace.Map.Components.NPCs.FinalBoss.FinalBoss.HumanoidRootPart.Size = Vector3.new(70, 70, 70)
workspace.Map.Components.NPCs.FinalBoss.FinalBoss.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
game:GetService("ReplicatedStorage").Remotes.ToolSwingEvent:FireServer()
end
until game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton").Visible == true or game:GetService("Players").LocalPlayer.PlayerGui.FinalBossHealthBar:FindFirstChild("FinalBossHealthBar").Visible == false or workspace.Map.Components.NPCs.FinalBoss:FindFirstChild("BridgeToGlove").Transparency == 0
wait(0.5)
workspace.Map.Components.NPCs.FinalBoss.FinalBoss.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
repeat task.wait()
	if firesignal and game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton") then
		firesignal(game:GetService("Players").LocalPlayer.PlayerGui.SkipButton:FindFirstChild("SkipDialogueButton").Activated)
	end
until workspace.Map.Components.NPCs.FinalBoss:FindFirstChild("BridgeToGlove") and workspace.Map.Components.NPCs.FinalBoss:FindFirstChild("BridgeToGlove").Transparency == 0
wait(1)
if workspace.Map.Components:FindFirstChild("GloveIsland") and workspace.Map.Components.GloveIsland:FindFirstChild("ClaimGlove") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Components.GloveIsland.ClaimGlove.CFrame
wait(1)
while true do
wait(0.3)
if fireproximityprompt then
fireproximityprompt(workspace.Map.Components.GloveIsland.ClaimGlove:FindFirstChild("ProximityPrompt"))
end
end
end
end
end)
elseif game.PlaceId == 132277598079047 then
Window:ChangeTitle("Nightmade Slender 🌑")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
for i, v in pairs(workspace:FindFirstChild("Pages"):GetChildren()) do
if v.Name == "Page" and v:FindFirstChild("Part") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Part.CFrame
wait(0.38)
if fireproximityprompt then
fireproximityprompt(v.Part:FindFirstChild("ProximityPrompt"))
end
end
end
end
end)
elseif game.PlaceId == 129665246576996 then
Window:ChangeTitle("Map Egger 🥚")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("Kenneth") and workspace.Kenneth:FindFirstChild("Head") and workspace.Kenneth.Head:FindFirstChild("ProximityPrompt") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Kenneth.Head.CFrame
wait(0.6)
if fireproximityprompt then
fireproximityprompt(workspace.Kenneth.Head.ProximityPrompt)
end
end
for i, v in pairs(workspace:FindFirstChild("TrialCompletedPoints"):GetChildren()) do
if v.Name:find("Trial") and v:FindFirstChild("root") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.root.CFrame
wait(0.8)
end
end 
wait(2.5)
if workspace:FindFirstChild("Kenneth") and workspace.Kenneth:FindFirstChild("Head") and workspace.Kenneth.Head:FindFirstChild("ProximityPrompt") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Kenneth.Head.CFrame
wait(0.6)
if fireproximityprompt then
fireproximityprompt(workspace.Kenneth.Head.ProximityPrompt)
end
end
end
end)
elseif game.PlaceId == 136690395520488 then
Window:ChangeTitle("Friday the 13th 🔪")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
end
local MapStuff = game.Workspace:FindFirstChild("Map") and game.Workspace.Map:FindFirstChild("PuzzleStuff")
wait(0.5)
if MapStuff:FindFirstChild("ButtonPlants") then
for i, v in pairs(MapStuff:FindFirstChild("ButtonPlants"):GetChildren()) do
if v.Name == "Plant" and v:FindFirstChild("Button") and v:FindFirstChild("Hitbox") and v.Hitbox:FindFirstChild("ClickDetector") then
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Button.CFrame
if fireclickdetector then
fireclickdetector(v.Hitbox:FindFirstChild("ClickDetector"))
end
until v.Button.Color ~= Color3.fromRGB(255, 0, 0)
end
end
end
wait(0.3)
repeat task.wait()
if MapStuff:FindFirstChild("Sledgehammer") and MapStuff.Sledgehammer:FindFirstChild("Hitbox") then
if fireclickdetector then
fireclickdetector(MapStuff.Sledgehammer.Hitbox:FindFirstChild("ClickDetector"))
end
end
until game.Players.LocalPlayer.Backpack:FindFirstChild("Sledgehammer") or game.Players.LocalPlayer.Character:FindFirstChild("Sledgehammer")
wait(0.2)
if game.Players.LocalPlayer.Backpack:FindFirstChild("Sledgehammer") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Sledgehammer").Parent = game.Players.LocalPlayer.Character
wait(0.2)
end
if MapStuff:FindFirstChild("Glass") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = MapStuff.Glass.CFrame
wait(0.3)
if MapStuff:FindFirstChild("Glass") and MapStuff.Glass:FindFirstChild("ClickDetector") then
if fireclickdetector then
fireclickdetector(MapStuff.Glass:FindFirstChild("ClickDetector"))
end
end
end
wait(0.5)
local count = {X = 0, V = 0, II = 0}
local function CalculatePanel(number)
	local str = tostring(number)
	local abc = tonumber(str:sub(1,3))
	local def = tonumber(str:sub(4,6))
	local needed = def - abc
	local result = {}
	if needed < 0 then
		return {}, ""
	end
	local countX = needed // 10
	needed = needed % 10
	local countV = needed // 5
	needed = needed % 5
	local countII = needed // 2
	needed = needed % 2
	for i = 1, countX do
		table.insert(result, "X")
	end
	for i = 1, countV do
		table.insert(result, "V")
	end
	for i = 1, countII do
		table.insert(result, "II")
	end
	return result, needed
end
local Numberchar = {
	["X"] = 10,
	["V"] = 5,
	["II"] = 2
}
repeat task.wait() 
	pcall(function()
		repeat task.wait() until MapStuff:FindFirstChild("AddAmountsPanel") and MapStuff.AddAmountsPanel:FindFirstChild("Screen") and MapStuff.AddAmountsPanel.Screen:FindFirstChild("SurfaceGui") and MapStuff.AddAmountsPanel.Screen.SurfaceGui:FindFirstChild("TextLabel") and (tonumber(MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text) or MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() == "unlocked" or MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() == "error")
		repeat task.wait() until MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() == "unlocked" or tonumber(MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text)
		wait(0.7)
		local count = {X = 0, V = 0, II = 0}
		local result, remainder
		if MapStuff:FindFirstChild("AddAmountsPanel") and MapStuff.AddAmountsPanel:FindFirstChild("Screen") and MapStuff.AddAmountsPanel.Screen:FindFirstChild("SurfaceGui") and MapStuff.AddAmountsPanel.Screen.SurfaceGui:FindFirstChild("TextLabel") and MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() ~= "unlocked" then
			result, remainder = CalculatePanel(MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text)
			local Amount1 = tonumber(MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:sub(1,3))
			local Amount2 = tonumber(MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:sub(4,6))
			if #result > 0 then
				for i, v in ipairs(result) do
					Amount1 += Numberchar[v]
				end
				local CheckAmount = Amount1..Amount2
				result, remainder = CalculatePanel(CheckAmount)
			end
			if #result < 0 then
				Notification("The second number is smaller than the first number, you have reset amounts now.", 5)
				for i = 1, 20 do
					for j, k in pairs(MapStuff.AddAmountsPanel:GetChildren()) do
						if k.Name == "Key" then
							if fireclickdetector then
								fireclickdetector(k.ClickDetector)
							end
						end
					end
				end
				repeat task.wait() until MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() == "unlocked" or MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() == "error"
			else
				result, remainder = CalculatePanel(MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text)
				if #result > 0 then
					for _, v in pairs(result) do
						if count[v] then
							count[v] += 1
						end
					end
					for _, k in pairs(MapStuff.AddAmountsPanel:GetChildren()) do
						if k.Name == "Key" then
							local amount = k:GetAttribute("AddAmount")
							local label = k:FindFirstChild("SurfaceGui") and k.SurfaceGui:FindFirstChild("TextLabel")
							for char, num in pairs(Numberchar) do
								if num == amount then
									if label then
										label.Text = char..": "..count[char]
									end
								end
							end
						end
					end
					for _, v in pairs(result) do
						for _, k in pairs(MapStuff.AddAmountsPanel:GetChildren()) do
							if k.Name == "Key" and k:GetAttribute("AddAmount") == Numberchar[v] then
								if fireclickdetector and k:FindFirstChild("ClickDetector") then
									fireclickdetector(k.ClickDetector)
								end
							end
						end
						wait(0.7)
					end
				end
			end
		end
	end)
until MapStuff:FindFirstChild("AddAmountsPanel") and MapStuff.AddAmountsPanel:FindFirstChild("Screen") and MapStuff.AddAmountsPanel.Screen:FindFirstChild("SurfaceGui") and MapStuff.AddAmountsPanel.Screen.SurfaceGui:FindFirstChild("TextLabel") and MapStuff.AddAmountsPanel.Screen.SurfaceGui.TextLabel.Text:lower() == "unlocked"
wait(0.8)
for i, v in pairs(MapStuff.RotatedPaintings:GetChildren()) do
	if v.Name == "Painting" and tonumber(v:GetAttribute("RotationIndex")) ~= 0 then
		repeat task.wait(0.85)
			if tonumber(v:GetAttribute("RotationIndex")) > 0 and fireclickdetector then
				fireclickdetector(v.ClickDetector)
			end
		until tonumber(v:GetAttribute("RotationIndex")) == 0
		wait(0.25)
		v.ClickDetector:Destroy()
	end
end
wait(0.3)
repeat task.wait()
if MapStuff:FindFirstChild("ShovelChest") and MapStuff.ShovelChest:FindFirstChild("Hitbox") then
if fireclickdetector then
fireclickdetector(MapStuff.ShovelChest.Hitbox:FindFirstChild("ClickDetector"))
end
end
until game.Players.LocalPlayer.Backpack:FindFirstChild("Shovel") or game.Players.LocalPlayer.Character:FindFirstChild("Shovel")
wait(0.5)
if game.Players.LocalPlayer.Backpack:FindFirstChild("Shovel") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Shovel").Parent = game.Players.LocalPlayer.Character
wait(0.3)
end
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = MapStuff:FindFirstChild("Grave"):FindFirstChild("Hitbox").CFrame * CFrame.new(0, 10, 0)
wait(0.5)
repeat task.wait()
	if fireclickdetector then
		fireclickdetector(MapStuff:FindFirstChild("Grave"):FindFirstChild("Hitbox"):FindFirstChild("ClickDetector"))
	end
until game.Workspace:FindFirstChild("Rig") and game.Workspace.Rig:FindFirstChild("Head") and game.Workspace.Rig.Head.Transparency <= 0
wait(0.3)
if MapStuff:FindFirstChild("Grave"):FindFirstChild("Hitbox") then
	ClickFreezeBV(function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = MapStuff:FindFirstChild("Grave"):FindFirstChild("Hitbox").CFrame * CFrame.new(0, 25, 0)
	end)
end
wait(2)
repeat task.wait(0.05)
if game.Workspace:FindFirstChild("Rig") and game.Workspace.Rig:FindFirstChild("HumanoidRootPart") then
if game.Players.LocalPlayer.Backpack:FindFirstChild("Lantern") then
game.Players.LocalPlayer.Backpack:FindFirstChild("Lantern").Parent = game.Players.LocalPlayer.Character
elseif game.Players.LocalPlayer.Character:FindFirstChild("Lantern") then
if game.Workspace:FindFirstChild("Rig") and game.Players.LocalPlayer.Character:FindFirstChild("Lantern") then
game.Players.LocalPlayer.Character:FindFirstChild("Lantern"):Activate()
if game.Players.LocalPlayer.Character:FindFirstChild("Lantern") and game.Players.LocalPlayer.Character.Lantern:FindFirstChild("Network") then
game:GetService("Players").LocalPlayer.Character.Lantern.Network:FireServer("Hit", game.Workspace.Rig:FindFirstChild("HumanoidRootPart"))
end
end
end
end
until (workspace:FindFirstChild("Slasher") and workspace.Slasher:FindFirstChild("Glove")) or (game.Workspace:FindFirstChild("Rig") and game.Workspace.Rig:FindFirstChild("Humanoid") and game.Workspace.Rig.Humanoid.Health <= 0)
wait(0.3)
repeat task.wait() until workspace:FindFirstChild("Slasher") and workspace.Slasher:FindFirstChild("Glove")
Unfreeze()
task.wait(0.3)
repeat task.wait()
if workspace:FindFirstChild("Slasher") and workspace.Slasher:FindFirstChild("Glove") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Slasher.Glove.CFrame * CFrame.new(0, 3, 0)
end
until workspace:FindFirstChild("Slasher") == nil
end
end)
elseif game.PlaceId == 89837553336708 then
Window:ChangeTitle("Map Plunger 🪠")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local Plunger = workspace:FindFirstChild("plunger glove")
Plunger:FindFirstChild("plungerglove").CFrame = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
if fireclickdetector then
fireclickdetector(Plunger:FindFirstChildOfClass("ClickDetector"))
end
end
end)
elseif game.PlaceId == 75803343514634 then
Window:ChangeTitle("Shattered Reality ⚔️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Badge")

Misc1Group:AddButton("Get Badge", function()
if GetBadge then return end
GetBadge = true
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
local Stage1 = workspace:FindFirstChild("Stage1")
if workspace:FindFirstChild("Stage1") then
repeat task.wait() 
if Stage1:FindFirstChild("Lobby") and Stage1.Lobby.Portals:FindFirstChild("normal") then
firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), Stage1.Lobby.Portals.normal.Teleport1, 0)
firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), Stage1.Lobby.Portals.normal.Teleport1, 1)
end
if Stage1:FindFirstChild("glove") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Stage1.glove:FindFirstChild("Touch").CFrame
end
until game:GetService("Players").LocalPlayer.Character:FindFirstChild("Evolg") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Evolg")
local GloveEvolg = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Evolg") or game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Evolg")
if GloveEvolg and GloveEvolg:FindFirstChild("Glove") and GloveEvolg.Glove:FindFirstChild("HitParticles") then
GloveEvolg.Glove:FindFirstChild("HitParticles"):Destroy()
end
repeat task.wait()
if game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Evolg") then
game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Evolg").Parent = game:GetService("Players").LocalPlayer.Character
end
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Evolg") and game:GetService("Players").LocalPlayer.Character.Evolg:FindFirstChild("Network") then
for i, v in pairs(workspace:GetChildren()) do
if v.Name:find("shadow") and v:FindFirstChild("HumanoidRootPart") then
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Evolg"):Activate()
game:GetService("Players").LocalPlayer.Character:WaitForChild("Evolg"):WaitForChild("Network"):FireServer("Hit",v.HumanoidRootPart)
end
end
end
until Stage1:FindFirstChild("Mirror") and Stage1.Mirror:FindFirstChild("Touch") and Stage1.Mirror.Touch:FindFirstChild("TouchInterest")
wait(0.5)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Stage1.Mirror:FindFirstChild("Touch").CFrame
end
repeat task.wait() until workspace:FindFirstChild("Stage2")
wait(4)
if workspace:FindFirstChild("Stage2") then
local Stage2 = workspace:FindFirstChild("Stage2")
if Stage2:FindFirstChild("Lobby") and Stage2.Lobby.Portals:FindFirstChild("normal") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Stage2.Lobby.Portals.normal.Teleport1.CFrame
end
wait(0.5)
repeat task.wait()
if Stage2:FindFirstChild("spinner") and Stage2.spinner:FindFirstChild("Part") and Stage2.spinner.Part.Transparency < 0.5 then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Stage2.spinner:FindFirstChild("Part").CFrame * CFrame.new(0, 60, 0)
wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
end
until Stage2:FindFirstChild("Mirror") and Stage2.Mirror:FindFirstChild("Touch") and Stage2.Mirror.Touch:FindFirstChild("TouchInterest")
wait(0.4)
game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Stage2.Mirror:FindFirstChild("Touch").CFrame
wait(4)
end
repeat task.wait() until workspace:FindFirstChild("Stage3")
wait(0.3)
if workspace:FindFirstChild("Stage3") then
wait(5)
local Stage3 = workspace:FindFirstChild("Stage3")
if Stage3:FindFirstChild("Lobby") and Stage3.Lobby.Portals:FindFirstChild("default") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Stage3.Lobby.Portals.default.Teleport2.CFrame
end
end
repeat task.wait() until workspace:FindFirstChild("BossArena")
if workspace:FindFirstChild("BossAttackDebris") then
workspace.BossAttackDebris:Destroy()
end
local Boss = workspace:FindFirstChild("BossArena")
if Boss:FindFirstChild("Arena") and Boss.Arena:FindFirstChild("startTrigger") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Boss.Arena:FindFirstChild("startTrigger").CFrame
end
repeat task.wait()
if Boss:FindFirstChild("Arena"):FindFirstChild("mirrors") then
	for i, v in pairs(Boss.Arena.mirrors:GetChildren()) do
		if v:IsA("Model") and v:FindFirstChild("Meshes/Mirror1_Plane.008") and v["Meshes/Mirror1_Plane.008"].Transparency < 0.5 then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChild("Meshes/Mirror1_Plane.008").CFrame
		end
	end
end
until workspace:FindFirstChild("Rig") and workspace.Rig:FindFirstChild("Humanoid").Health <= 0
Notification("Done, Get Badge (Glove, but Hitman kill)", 5)
end
end)
elseif game.PlaceId == 80420091630966 then
_G.GetOldBright = {
	["Old"] = {
		Brightness = game.Lighting.Brightness,
		ClockTime = game.Lighting.ClockTime,
		FogEnd = game.Lighting.FogEnd,
		FogStart = game.Lighting.FogStart,
		GlobalShadows = game.Lighting.GlobalShadows,
		OutdoorAmbient = game.Lighting.OutdoorAmbient
	},
	["New"] = {
		Brightness = 2,
		ClockTime = 14,
		FogEnd = 200000,
		FogStart = 100000,
		GlobalShadows = false,
		OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	}
}

for i, v in pairs(_G.GetOldBright.New) do
game.Lighting:GetPropertyChangedSignal(i):Connect(function()
	if _G.FullBright then
		game.Lighting[i] = v
	end
end)
end

Window:ChangeTitle("Boss Mortis ⚔️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	Tab1 = Window:AddTab("Boss", "rbxassetid://10734975486"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Misc1Group = Tabs.Tab:AddLeftGroupbox("Round 1")

Misc1Group:AddToggle("Auto Slap Mortis", {
    Text = "Auto Slap Snoob",
    Default = false, 
    Callback = function(Value) 
_G.AutoSlapMortis = Value
while _G.AutoSlapMortis do
if workspace:FindFirstChild("TheOutside") then
for i, v in pairs(workspace.TheOutside:GetChildren()) do
if v.Name == "evilSnoob" and v:FindFirstChild("hittable") then
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Lantern") and game:GetService("Players").LocalPlayer.Character.Lantern:FindFirstChild("Network") then
game:GetService("Players").LocalPlayer.Character:WaitForChild("Lantern"):WaitForChild("Network"):FireServer("Hit", v.hittable)
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Lantern"):Activate()
end
end
end
end
task.wait()
end
    end
})

Misc1Group:AddButton("Get Key", function()
for i, v in pairs(game.Workspace:GetChildren()) do
if v:IsA("Tool") and v.Name:find("Key") and v:FindFirstChild("Handle") and v:FindFirstChild("KeyClient") then
repeat task.wait()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Handle.CFrame
until not v:IsDescendantOf(workspace)
end
end
wait(0.1)
if workspace:FindFirstChild("GateMechanism"):FindFirstChild("Touchpad") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.GateMechanism.Touchpad.CFrame
end
end)

Misc1Group:AddButton("Teleport Portal", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("TheOutside"):FindFirstChild("TowerENT1") and workspace.TheOutside.TowerENT1:FindFirstChild("teleport") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.TheOutside.TowerENT1.teleport.CFrame
end
end
end)

local Misc2Group = Tabs.Tab:AddRightGroupbox("Round 2")

Misc2Group:AddButton("Fix Elevator", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if game.Players.LocalPlayer.Character:FindFirstChild("Screwdriver") == nil or game.Players.LocalPlayer.Backpack:FindFirstChild("Screwdriver") == nil then
repeat task.wait()
if workspace:FindFirstChild("Screwdriver") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Screwdriver.CFrame
end
until not workspace:FindFirstChild("Screwdriver")
end
wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Clickable.boltClick.CFrame
Notification("You have click, to fix", 5)
end
end)

Misc2Group:AddButton("Teleport Eli Vator", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("DialoguePrompts"):FindFirstChild("Eli Vator") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.DialoguePrompts["Eli Vator"].Camera.CFrame
wait(0.4)
fireproximityprompt(workspace.DialoguePrompts["Eli Vator"]:FindFirstChild("ProximityPrompt"))
end
end
end)

local Misc3Group = Tabs.Tab:AddRightGroupbox("Round 3")

Misc3Group:AddButton("Teleport Hammer Big", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("TheOffice"):FindFirstChild("HallwaySection3"):FindFirstChild("LargeHammerBox1"):FindFirstChild("Large Hammer") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.TheOffice.HallwaySection3.LargeHammerBox1["Large Hammer"].CFrame * CFrame.new(0, 0, 5)
wait(0.4)
fireproximityprompt(workspace.TheOffice.HallwaySection3.LargeHammerBox1["Large Hammer"]:FindFirstChild("ProximityPrompt"))
end
end
end)

Misc3Group:AddButton("Teleport Hook", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("TheOffice"):FindFirstChild("HallwaySection3") then
for i, v in pairs(workspace.TheOffice.HallwaySection3:GetChildren()) do
if v.Name == "GlassShowcase1" and v:FindFirstChild("Hook") then
for _, z in pairs(v:GetChildren()) do
if z.Name == "Hook" and z:FindFirstChild("ProximityPrompt") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = z.CFrame
wait(0.4)
fireproximityprompt(z:FindFirstChild("ProximityPrompt"))
end
end
end
end
end
end
end)

Misc3Group:AddButton("Teleport Glasses", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("TheOffice"):FindFirstChild("toIndoor") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.TheOffice.toIndoor.CFrame
end
end
end)

Misc3Group:AddButton("Grappler", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("TheOffice"):FindFirstChild("Scaffold"):FindFirstChild("Grappler"):FindFirstChild("GrapplingParts") then
for i, v in pairs(workspace:FindFirstChild("TheOffice"):FindFirstChild("Scaffold"):FindFirstChild("Grappler"):FindFirstChild("GrapplingParts"):GetChildren()) do
if v:IsA("BasePart") then
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TheOffice"):WaitForChild("GrapplerHook"):WaitForChild("onActivated"):FireServer(v)
end
end
end
end
end)

local Boss1Group = Tabs.Tab1:AddLeftGroupbox("Boss Dice")

Boss1Group:AddToggle("Tied", {
    Text = "Anti Glare Wire",
    Default = false, 
    Callback = function(Value) 
_G.AntiGlare = Value
while _G.AntiGlare do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("WeldConstraint") then
game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ProcessJump"):FireServer()
end
task.wait()
end
	end
})

Boss1Group:AddToggle("Tied", {
    Text = "Anti Touch Head",
    Default = false, 
    Callback = function(Value) 
_G.AntiHead = Value
while _G.AntiHead do
if workspace:FindFirstChild("bossStorage") and workspace.bossStorage:FindFirstChild("head") then
workspace.bossStorage.head.CanTouch = false
end
task.wait()
end
if workspace:FindFirstChild("bossStorage") and workspace.bossStorage:FindFirstChild("head") then
workspace.bossStorage.head.CanTouch = true
end
	end
})

Boss1Group:AddToggle("Handleft", {
    Text = "Auto Slap Left Hand",
    Default = false, 
    Callback = function(Value) 
_G.AutoSlap = Value
spawn(function()
while _G.AutoSlap do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Lantern") then
if workspace:FindFirstChild("bossStorage") and workspace.bossStorage:FindFirstChild("leftHand") and workspace.bossStorage.leftHand:FindFirstChild("PointerMimic") and workspace.bossStorage.leftHand.PointerMimic:FindFirstChild("TouchInterest") then
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Lantern"):Activate()
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.bossStorage.leftHand.PointerMimic.CFrame * CFrame.new(0, 0, 6.8)
end
end
end
task.wait()
end
end)
if NotificationUnSh then return end
NotificationUnSh = true
Notification("You have turn off Shiftlock and but you have to stand still for it to work but you have to dodge the attack hand", 10)
	end
})

CloneHead = false
Boss1Group:AddToggle("Nail", {
    Text = "Auto Slap Nail",
    Default = false, 
    Callback = function(Value) 
_G.NailSlap = Value
while _G.NailSlap do
_G.TeleportSafe = false
if workspace:FindFirstChild("bossStorage") and workspace.bossStorage:FindFirstChild("head") then
workspace.bossStorage.head.CanTouch = false
end
if workspace:FindFirstChild("BossfightCore") and workspace.BossfightCore:FindFirstChild("BossTargetArea") then
AreaBoss = workspace.BossfightCore.BossTargetArea
end
if workspace:FindFirstChild("bossStorage") then
for i, v in pairs(workspace:WaitForChild("bossStorage"):GetChildren()) do
if (v.Name:find("thicc") or v.Name == "nail") and v:FindFirstChild("object") then
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Lantern") and v:FindFirstChild("AnimationController") and v.AnimationController:FindFirstChild("Animator") and #v.AnimationController.Animator:GetPlayingAnimationTracks() == 0 then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v:FindFirstChild("object").CFrame * CFrame.new(0, -10, 0)
game:GetService("Players").LocalPlayer.Character:FindFirstChild("Lantern"):Activate()
end
else
_G.TeleportSafe = true
end
end
end
end
if _G.TeleportSafe and AreaBoss then
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = AreaBoss.CFrame * CFrame.new(0, 100, 0)
end
if _G.StartFly == false then
CreateFreezeBV()
end
elseif not _G.TeleportSafe then
CreateFreezeBV({Remove = true})
end
task.wait()
end
if workspace:FindFirstChild("bossStorage") and workspace.bossStorage:FindFirstChild("head") then
workspace.bossStorage.head.CanTouch = _G.AntiHead or false
end
CreateFreezeBV({Remove = true})
	end
})

Boss1Group:AddButton("PickUp C4", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
oldCF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
for i, v in pairs(workspace:GetChildren()) do
if v.Name == "C4" then
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v.CFrame
wait(0.4)
if fireproximityprompt then
fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
end
v.Destroying:Wait()
end
end
wait(0.4)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
end
end)

Boss1Group:AddButton("Install C4", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
oldCF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
for i, v in pairs(workspace.ExplosiveGhosts:GetChildren()) do
if v:IsA("BasePart") and v:FindFirstChild("SurfaceAppearance") == nil then
if game.Players.LocalPlayer.Backpack:FindFirstChild("C4") then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack:FindFirstChild("C4"))
end
wait(0.3)
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = v.CFrame
wait(0.4)
fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
wait(0.3)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCF
wait(0.5)
end
end
end
end)

Boss1Group:AddButton("Pickup Bomb", function()
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
if workspace:FindFirstChild("BombGlove") and workspace.BombGlove:FindFirstChild("Glove") then
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.BombGlove.Glove.CFrame
wait(0.4)
fireproximityprompt(workspace.BombGlove.Glove:FindFirstChildOfClass("ProximityPrompt"))
end
end
end)

local Misc4Group = Tabs.Tab1:AddRightGroupbox("Misc")

Misc4Group:AddToggle("No Cooldown Proximity", {
    Text = "No Cooldown Proximity",
    Default = false, 
    Callback = function(Value) 
_G.NoCooldownProximity = Value
if _G.NoCooldownProximity == true then
for i, v in pairs(workspace:GetDescendants()) do
if v.ClassName == "ProximityPrompt" then
v.HoldDuration = 0
end
end
else
if CooldownProximity then
CooldownProximity:Disconnect()
CooldownProximity = nil
end
end
CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
if _G.NoCooldownProximity == true then
if Cooldown:IsA("ProximityPrompt") then
Cooldown.HoldDuration = 0
end
end
end)
    end
})

Misc4Group:AddInput("FlySpeed", {
    Default = "50",
    Numeric = true,
    Text = "Fly Speed",
    Placeholder = "UserFlySpeed",
    Callback = function(Value)  
        _G.SetSpeedFly = Value  
    end  
})

_G.SetSpeedFly = 50
Misc4Group:AddToggle("Start Fly", {
    Text = "Start Fly",
    Default = false, 
    Callback = function(Value) 
Fly(Value)
	end
}):AddKeyPicker("Fly", {
   Default = "R",
   Text = "Fly",
   Mode = "Toggle",
   SyncToggleState = true
})

Misc4Group:AddToggle("Full Bright", {
    Text = "Full Bright",
    Default = false, 
    Callback = function(Value) 
_G.FullBright = Value
if not _G.FullBright then
for i, v in pairs(_G.GetOldBright.Old) do
game:GetService("Lighting")[i] = v
end
else
for i, v in pairs(_G.GetOldBright.New) do
game:GetService("Lighting")[i] = v
end
end
    end
})

Misc4Group:AddToggle("No Fog", {
    Text = "No Fog",
    Default = false, 
    Callback = function(Value) 
_G.Nofog = Value
while _G.Nofog do
for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
if v.ClassName == "Atmosphere" then
v.Density = 0
v.Haze = 0
end
end
task.wait()
end
for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
if v.ClassName == "Atmosphere" then
v.Density = 0.3
v.Haze = 1
end
end
    end
})
elseif game.PlaceId == 106620300132058 then
Window:ChangeTitle("Plate 🍽️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Badge")

MainGroup:AddButton("Get Badge", function()
if LoadingBadge then return end
LoadingBadge = true
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	if workspace:FindFirstChild("Obstacles") then workspace.Obstacles:Destroy() end
	Notification("Bypass plate obstacles", 5)
	Notification("Wait in until glove appear", 5)
	workspace:GetAttributeChangedSignal("Completed"):Connect(function()
		if workspace:GetAttribute("Completed") == true then
			Notification("Done Bro", 5)
			while task.wait() do
				if workspace:FindFirstChild("Glove Model"):FindFirstChild("Hand") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace["Glove Model"].Hand.CFrame
				end
			end
		end
	end)
end
end)
elseif game.PlaceId == 92483185275059 then
Window:ChangeTitle("Maze Pim 🕳️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Badge")

MainGroup:AddButton("Get Badge", function()
if LoadingBadge then return end
LoadingBadge = true
repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Transition") and game:GetService("Players").LocalPlayer.PlayerGui.Transition:FindFirstChild("Frame")
wait(0.5)
Transition = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Transition") and game:GetService("Players").LocalPlayer.PlayerGui.Transition:FindFirstChild("Frame")
ClickFreezeBV(function() end)
repeat task.wait(0.5)
local Maze = workspace:FindFirstChild("Maze")
local EndPrompt = Maze and Maze:FindFirstChild("EndPrompt", true)
local CylinderStart = workspace:FindFirstChild("Shed") and workspace.Shed:FindFirstChild("StartDoor") and workspace.Shed.StartDoor:FindFirstChild("Cylinder.025")
local StartEnter = CylinderStart and CylinderStart:FindFirstChild("Attachment") and CylinderStart.Attachment:FindFirstChildOfClass("ProximityPrompt")

if Transition and Transition.BackgroundTransparency == 1 then
	if EndPrompt then
		game.Players.LocalPlayer.Character:PivotTo(EndPrompt.Parent.Parent.CFrame)
		if fireproximityprompt then
			fireproximityprompt(EndPrompt)
		end
	elseif not Maze then
		if CylinderStart and StartEnter then
			game.Players.LocalPlayer.Character:PivotTo(CylinderStart.CFrame)
			if fireproximityprompt then
				fireproximityprompt(StartEnter)
			end
		end
	end
end
until workspace:FindFirstChild("Maze") and workspace.Maze:FindFirstChild("BarnMaze")
repeat task.wait() until Transition and Transition.BackgroundTransparency == 1
wait(0.7)
while true do
local Badge = workspace.Maze:FindFirstChild("ChaseOutroStart", true)
if Badge then
	game.Players.LocalPlayer.Character:PivotTo(Badge.CFrame)
else
	game.Players.LocalPlayer.Character:PivotTo(CFrame.new(-84, 39, 1421))
end
task.wait()
end
end)
elseif game.PlaceId == 103505724406848 then
Window:ChangeTitle("Battles Zombie 🧟‍♂️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Badge")

MainGroup:AddButton("Get Badge", function()
repeat task.wait() until workspace:FindFirstChild("BossAreaSpawn") and workspace:FindFirstChild("Enemies")
local Enemies = workspace:WaitForChild("Enemies")
repeat task.wait(1)
CreateFreezeBV()
if workspace:FindFirstChild("BossAreaSpawn") then
	game.Players.LocalPlayer.Character:PivotTo(workspace.BossAreaSpawn.CFrame * CFrame.new(0, 65, 0))
end
for i, v in pairs(Enemies:GetChildren()) do
	if v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
		game:GetService("ReplicatedStorage").Remotes.GeneralHit:FireServer(v.Head)
	end
end
until workspace.Enemies:FindFirstChild("Boss Zombie")
wait(0.6)
while true do
if workspace.Enemies:FindFirstChild("Boss Zombie") and workspace.Enemies["Boss Zombie"]:FindFirstChild("Head") then
	spawn(function()
		game:GetService("ReplicatedStorage").Remotes.GeneralHit:FireServer(v.Head)
	end)
end
task.wait()
end
end)
elseif game.PlaceId == 101113181694564 then
Window:ChangeTitle("Collect Conker 🍎")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Badge")

MainGroup:AddButton("Get Badge", function()
if LoadingBadge then return end
LoadingBadge = true
game:GetService("ReplicatedStorage").Remotes.Dialogue.FinishedNPCDialogue:FireServer()
repeat task.wait() until workspace:FindFirstChild("Map"):FindFirstChild("Props"):FindFirstChild("BasketCollection") and workspace.Map.Props.BasketCollection:FindFirstChild("Basket")
fireclickdetector(workspace.Map.Props.BasketCollection.Basket.ClickDetector)
repeat task.wait() until game.Players.LocalPlayer.Character:FindFirstChild("ConkerHoldVisual")
ClickFreezeBV(function() 
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.CoreAssets.Bowl["Sphere.002"].CFrame
end)
task.wait(2.8)
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.CoreAssets.Bowl["Sphere.002"].CFrame
spawn(function()
	workspace.NPCs.DescendantAdded:Connect(function(s)
	    if s.Name == "squirrel" then
		    local ok, err = pcall(function()
		        while task.wait() and s do
					if s:FindFirstChild("HumanoidRootPart") then
			            game:GetService("ReplicatedStorage").Remotes.tool.use:FireServer("slap")
			            game:GetService("ReplicatedStorage").Remotes.tool.hit:FireServer("slap", {Instance = s.HumanoidRootPart})
					end
				end
	        end)
	    end
	end)
	workspace.DescendantAdded:Connect(function(n)
	    if n.Name == "Conker" then
	        if n:FindFirstChildOfClass("TouchTransmitter") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = n.CFrame
				if firetouchinterest then
		            firetouchinterest(n, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
		            firetouchinterest(n, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
				end
	            task.delay(0.1, function()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.CoreAssets.Bowl["Sphere.002"].CFrame
					task.wait(0.5)
					workspace.Map.CoreAssets.Bowl.ProximityPrompt.HoldDuration = 0
					if fireproximityprompt then
						fireproximityprompt(workspace.Map.CoreAssets.Bowl.ProximityPrompt)
					end
					pcall(function()
						workspace.Map.CoreAssets.Bowl.ProximityPrompt:InputHoldBegin()
		                workspace.Map.CoreAssets.Bowl.ProximityPrompt:InputHoldEnd()
					end)
	            end)
	        end
	    end
	end)
end)
end)
elseif game.PlaceId == 95706409702231 then
if workspace:FindFirstChild("Attacks") then
	workspace:FindFirstChild("Attacks"):Destroy()
end
if workspace:FindFirstChild("Effects") then
	workspace:FindFirstChild("Effects"):Destroy()
end
Window:ChangeTitle("Boss Jerry ☃️")

Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Badge")

MainGroup:AddButton("Get Badge", function()
CreateFreezeBV()
game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.KillPart.CFrame * CFrame.new(0, 150, 0)
game:GetService("RunService").RenderStepped:Connect(function()
	if workspace:FindFirstChild("Boss") and workspace.Boss:FindFirstChildOfClass("Humanoid") then
		workspace.Boss:FindFirstChildOfClass("Humanoid").Health = -math.huge
		workspace.Boss:FindFirstChildOfClass("Humanoid").Sit = true
	end
end)
end)
elseif game.PlaceId == 94481828238038 then
local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local CoreGui = game:GetService("CoreGui")
if not CoreGui:FindFirstChild("ClickButton") then
	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "ClickButton"
	
	local TextButton = Instance.new("TextButton")
	TextButton.Name = "FlingYour"
	TextButton.Size = UDim2.new(0.12, 0, 0.12, 0)
	TextButton.Position = UDim2.new(0.42, 0, 0.7, 0)
	TextButton.BackgroundColor3 = Color3.new(255, 255, 255)
	TextButton.Text = "Fling Your"
	TextButton.TextScaled = true
	TextButton.BackgroundTransparency = 0 
	TextButton.TextColor3 = Color3.new(0, 0, 0)
	TextButton.Font = Enum.Font.Code
	TextButton.Draggable = true
	TextButton.Visible = false
	TextButton.Parent = gui
	Instance.new("UICorner").Parent = TextButton
	TextButton.MouseButton1Click:Connect(function()
		if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			for i, v in pairs(workspace.Interactables.Instances:GetChildren()) do
				if v.Name == "object" and v:FindFirstChild("Root"):IsA("MeshPart") and v.Root.MeshId:find("11351437058") then
					if firetouchinterest then
			            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Root, 0)
			            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Root, 1)
					end
					break
				end
			end
		end
	end)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.new(0, 0, 0)
	Stroke.Thickness = 2.2
	Stroke.ApplyStrokeMode = "Border"
	Stroke.Parent = TextButton
	
	if TextButton then
		local ButtonClone = TextButton:Clone()
		ButtonClone.Name = "ButtonTween"
		ButtonClone.Text = "Tween Hell"
		ButtonClone.Visible = false
		ButtonClone.Parent = gui
		ButtonClone.MouseButton1Click:Connect(function()
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil then
					local bv = Instance.new("BodyVelocity")
					bv.Name = "VelocityHandler"
					bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
					bv.MaxForce = Vector3.new(100000, 100000, 100000)
					bv.Velocity = Vector3.new(0, 0, 0)
				end
				local Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.zone.Position).Magnitude / 31, Enum.EasingStyle.Linear), {CFrame = workspace.zone.CFrame})
				Tween:Play()
				Tween.Completed:Wait()
				Tween:Cancel()
				if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
				end
			end
		end)
	end
end
Window:ChangeTitle("SnowBall ☃️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Combat")

MainGroup:AddSlider("Reach Aura", {
    Text = "Reach Slap Aura",
    Default = 25,
    Min = 10,
    Max = 50,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.ReachSlapArua = Value
    end
})

MainGroup:AddToggle("Slap Aura", {
    Text = "Slap Aura",
    Default = false, 
    Callback = function(Value) 
_G.SlapAura = Value
while _G.SlapAura do
Remote:WaitForChild("tool"):WaitForChild("use"):FireServer("slap")
for i,v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
		if v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Team ~= v.Team then
			if _G.ReachSlapArua >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude then
				Remote:WaitForChild("tool"):WaitForChild("hit"):FireServer("slap", {Instance = v.Character.HumanoidRootPart, Direction = v.Character.HumanoidRootPart.Position})
				break
			end
		end
	end
end
task.wait(0.2)
end
    end
})

MainGroup:AddSlider("Power Snowball (Shallow)", {
    Text = "Power Snowball (Shallow)",
    Default = 5,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = true,
    Callback = function(Value)
_G.PowerSnowball = Value
    end
})

MainGroup:AddToggle("Spam SnowBall", {
    Text = "Spam Throw Snowball",
    Default = false, 
    Callback = function(Value) 
_G.ThrowSnowBall = Value
while _G.ThrowSnowBall do
for i,v in pairs(game.Players:GetChildren()) do
	if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
		if v.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Team ~= v.Team then
			if 150 >= (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude then
				Remote:WaitForChild("SnowballThrow"):FireServer(v.Character.HumanoidRootPart.Position, tonumber(_G.PowerSnowball))
				break
			end
		end
	end
end
task.wait()
end
    end
})

local MainGroup1 = Tabs.Tab:AddRightGroupbox("Misc")

MainGroup1:AddToggle("Heal", {
    Text = "Collect Heal",
    Default = false, 
    Callback = function(Value) 
_G.CollectHeal = Value
while _G.CollectHeal do
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	for i, v in pairs(workspace.Interactables.Instances:GetChildren()) do
		if v.Name == "object" and v:FindFirstChild("Hot Cocoa") then
			local GetTouch = v:FindFirstChildWhichIsA("TouchTransmitter", true)
			if firetouchinterest then
	            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, GetTouch.Parent, 0)
	            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, GetTouch.Parent, 1)
			end
		end
	end
end
task.wait()
end
    end
})

MainGroup1:AddToggle("Button Fling", {
    Text = "Button Fling",
    Default = false, 
    Callback = function(Value) 
if CoreGui:FindFirstChild("ClickButton") and CoreGui.ClickButton:FindFirstChild("FlingYour") then
	CoreGui.ClickButton:FindFirstChild("FlingYour").Visible = Value
end
    end
})

MainGroup1:AddToggle("Button Tween Hell", {
    Text = "Button Tween Hell",
    Default = false, 
    Callback = function(Value) 
if CoreGui:FindFirstChild("ClickButton") and CoreGui.ClickButton:FindFirstChild("ButtonTween") then
	CoreGui.ClickButton:FindFirstChild("ButtonTween").Visible = Value
end
    end
})
elseif game.PlaceId == 122901288403496 then
function InTable(t, value)
	for _, v in ipairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

Window:ChangeTitle("JOB APPLICATION!!! 📦")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Clean Trash")

MainGroup:AddButton("Collect Mop / Broom", function()
	for i, v in pairs(workspace.Tools.Prompts:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
			wait(0.5)
			fireproximityprompt(v)
		end
	end
end)

local function Unequip()
	for _, v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = game.Players.LocalPlayer.Backpack
		end
	end
end
local function Equip(toolName)
	Unequip()
	local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(toolName)
	if tool and game.Players.LocalPlayer.Character then
		tool.Parent = game.Players.LocalPlayer.Character
	end
end
MainGroup:AddToggle("Auto Clean Trash", {
    Text = "Auto Clean Trash",
    Default = false, 
    Callback = function(Value) 
_G.AutoCleanTrash = Value
while _G.AutoCleanTrash do
for i, v in pairs(workspace.Trash.Instances:GetChildren()) do
	if (v.Name == "TrashPile" or v.Name == "TrashSpill") then
		local TrashObject = v:FindFirstChild("trash pile") or v:FindFirstChild("Slime")
		if TrashObject then
			local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			if TrashObject.Name:lower():find("trash pile") then
				Equip("Broom")
			else
				Equip("Mop")
			end
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = TrashObject.CFrame * CFrame.new(0, 5, 0)
			repeat task.wait()
				game:GetService("ReplicatedStorage").Remotes.CleanTrash:FireServer(v)
			until not (v and (v:FindFirstChild("trash pile") or v:FindFirstChild("Slime")))
			wait(0.3)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
		end
	end
end
task.wait()
end
    end
})

local MainGroup1 = Tabs.Tab:AddRightGroupbox("Misc")

MainGroup1:AddToggle("Auto Stock Shelf Glove", {
    Text = "Auto Stock Shelf Glove",
    Default = false, 
    Callback = function(Value) 
_G.AutoStockGlove = Value
while _G.AutoStockGlove do
if workspace:FindFirstChild("GloveShipment") then
for _, v in ipairs(workspace.GloveShipment:GetChildren()) do
    if v:IsA("Model") and v.Name:lower():find("stockbox_") and v:FindFirstChild("Box") then      
        local FoundGlove = v.Name:match("_(.+)")
        if not FoundGlove then continue end
        repeat task.wait()
            game:GetService("ReplicatedStorage").Remotes.PickupBox:FireServer(v)
        until workspace:FindFirstChild("HeldBox_" .. FoundGlove)
        for _, sh in ipairs(workspace.Shelves:GetChildren()) do
            if sh:IsA("Model") and sh:FindFirstChild("Base") and workspace:FindFirstChild("HeldBox_" .. FoundGlove) then
                local hasGlove = false
				function GloveSh()
	                for _, j in pairs(sh:GetDescendants()) do
	                    if j.Name:match("Glove") then
	                        return true
	                    end
	                end
					return false
				end
                if GloveSh() then continue end
                repeat task.wait()
                    game:GetService("ReplicatedStorage").Remotes.StockShelf:FireServer(sh)
                until not workspace:FindFirstChild("HeldBox_" .. FoundGlove) or GloveSh() 
                break
            end
        end
    end
end
end
task.wait()
end
    end
})

MainGroup1:AddButton("Teleport Sell Glove", function()
	if workspace.Counter:FindFirstChild("ItemPlacement") then
		if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Counter.ItemPlacement.CFrame * CFrame.new(-5, 0, 0)
		end
	end
end)

MainGroup1:AddToggle("Auto Sell Glove", {
    Text = "Auto Sell Glove",
    Default = false, 
    Callback = function(Value) 
_G.AutoSellGlove = Value
while _G.AutoSellGlove do
for i, v in ipairs(workspace:GetChildren()) do
	for _, n in pairs(v:GetChildren()) do
		if n.Name:find("Glove") then
			if not n.Parent.Name:lower():find("heldcheckoutitem_") then
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PickupCheckoutItem"):FireServer(n.Parent)
			else
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ScanCheckoutItem"):FireServer(n.Parent.Name:match("_(.+)"))
			end
		end
	end
end
task.wait()
end
    end
})

MainGroup1:AddButton("Find Glove Sell", function()
	local NoSellGlove = {"bob", "bubble", "lamp", "l.o.l.b.o.m.b", "overkill", "plague", "sbeve", "ufo"}
	local Found = {}
	local gui = game.Players.LocalPlayer.PlayerGui
	local list = gui.WholesaleOrdering.Canvas.Listings.ScrollingFrame
	for _, v in ipairs(list:GetChildren()) do
		if v.Name:lower():find("listing") and v:FindFirstChild("Topbar") then
			local glove = v.Topbar.ItemName.Text:lower():match("^(.-)%s*%[")
			if InTable(NoSellGlove, glove) and not gui.Displays.subBarHolder.day.Text:match("5") then continue end
			local profit = tonumber(v.ExpectedProfit.Text:sub(2))
			local cost = tonumber(v.Cost.Text:sub(2))
			if profit and cost then
				table.insert(Found, {v, profit, cost})
			end
		end
	end
	table.sort(Found, function(a, b)
		return a[2] > b[2]
	end)
	local Money = tonumber(gui.Displays.topBarHolder.cash.Text:sub(2)) or 0
	for _, v in ipairs(Found) do
		if Money >= v[3] then
			Money -= v[3]
			if firesignal then
				firesignal(v[1].Activated)
			end
			local FindItemName = v[1]:FindFirstChild("ItemName", true)
			if FindItemName then
				local ItemClone = FindItemName:Clone()
				ItemClone.Parent = v[1]
				ItemClone.Text = "Choose Here"
				local function CheckToClick()
					if ItemClone then
						if v[1].BackgroundColor3 == Color3.fromRGB(58, 158, 95) then
							ItemClone.Text = ""
						elseif v[1].BackgroundColor3 == Color3.fromRGB(111, 111, 111) then
							ItemClone.Text = "Choose Here"
						end
					end
				end
				CheckToClick()
				v[1].MouseButton1Click:Connect(CheckToClick)
			end
		end
	end
end)
elseif game.PlaceId == 86045914443715 then
Window:ChangeTitle("Car Key 🚗")

Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	Map = game:GetService("Workspace"):WaitForChild("Map")
	if Map and Map:FindFirstChild("Racetrack") then
		Map.Racetrack:Destroy()
	end
	if Map and Map:FindFirstChild("kill_bricks") then
		Map.kill_bricks:Destroy()
	end
	local align = Instance.new("AlignPosition", game:GetService("Players").LocalPlayer.Character.HumanoidRootPart)
	align.Attachment0 = Instance.new("Attachment", game:GetService("Players").LocalPlayer.Character.HumanoidRootPart)
	align.Mode = Enum.PositionAlignmentMode.OneAttachment
	align.MaxForce = math.huge
	for i = 1, #Map.Waypoints:GetChildren() do
	    align.Position = Map.Waypoints[tostring(i)].Position
	    repeat task.wait() until (game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position - Map.Waypoints[tostring(i)].Position).Magnitude <= 100
	end
	align.Position = Vector3.new(-1431, 425, -859)
end
end)
elseif game.PlaceId == 113228834069218 or game.PlaceId == 95356852680586 then
Window:ChangeTitle("Cosplay Penguins 🐧")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

if game.PlaceId == 113228834069218 then
	MainGroup:AddButton("Collect All Fish", function()
		if workspace:FindFirstChild("Fih") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			for i, v in pairs(workspace:FindFirstChild("Fih"):GetChildren()) do
				if v:IsA("Model") and v.Name:lower() == "spinningfish" and v:FindFirstChild("Fish") and v.Fish:FindFirstChild("TouchInterest") then
					if typeof(firetouchinterest) == "function" then
						firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), v.Fish, 0)
						firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), v.Fish, 1)
					end
					v.Fish.CFrame = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
				end
			end
		end
	end)
	
	MainGroup:AddButton("Teleport To Finish", function()
		if workspace:FindFirstChild("FinishPart") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if typeof(firetouchinterest) == "function" then
				firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), workspace.FinishPart.TouchInterest.Parent, 0)
				firetouchinterest(game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), workspace.FinishPart.TouchInterest.Parent, 1)
			end
			game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.FinishPart.CFrame * CFrame.new(0, -10, 0)
		end
	end)
elseif game.PlaceId == 95356852680586 then
	local ModelSnow = workspace:WaitForChild("Snowman"):WaitForChild("Models")
	MainGroup:AddButton("Pickup Item Cosplay", function()
		CosplayName = {}
		for _, v in pairs(ModelSnow.DisplaySnowman.Accessories:GetChildren()) do
			if v:IsA("Folder") then
				for j, h in pairs(v:GetDescendants()) do
					if h:IsA("Model") then
						local handle = h:FindFirstChild("Handle")
						if handle and handle.Transparency == 0 then
							table.insert(CosplayName, h.Name)
						end
					end
				end
			end
		end
		if #CosplayName > 0 then
			for i, v in pairs(CosplayName) do
				for j, k in pairs(workspace:FindFirstChild("Accessories"):GetChildren()) do
					if k.Name:lower() == v:lower() and k:FindFirstChild("Handle") and k:FindFirstChild("ProximityPrompt") then
						local handle = k:FindFirstChild("Handle", true)
						local prompt = k:FindFirstChild("ProximityPrompt", true)
						repeat task.wait()
							if typeof(fireproximityprompt) == "function" then
								fireproximityprompt(prompt)
							end
							game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = handle.CFrame * CFrame.new(0, 3, 0)
						until (game.Players.LocalPlayer.Character:FindFirstChild(k:GetAttribute("SnowmanPartType")) and game.Players.LocalPlayer.Character:FindFirstChild(k:GetAttribute("SnowmanPartType")):IsA("Tool")) or (game.Players.LocalPlayer.Backpack:FindFirstChild(k:GetAttribute("SnowmanPartType")) and game.Players.LocalPlayer.Backpack:FindFirstChild(k:GetAttribute("SnowmanPartType")):IsA("Tool"))
					end
				end
			end
		end
	end)
	
	MainGroup:AddButton("Put Snowman", function()
		if not (game.Players.LocalPlayer.Character:FindFirstChild("Snow") or game.Players.LocalPlayer.Backpack:FindFirstChild("Snow")) then
			repeat task.wait()
				if typeof(fireproximityprompt) == "function" then
					fireproximityprompt(workspace.Interactables.SnowObject.ProximityPrompt)
				end
				game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Interactables.SnowObject.CFrame * CFrame.new(0, 5, 0)
			until game.Players.LocalPlayer.Character:FindFirstChild("Snow") or game.Players.LocalPlayer.Backpack:FindFirstChild("Snow")
		end
		local function PlayerSnow()
			for i, v in pairs(ModelSnow.PlayerSnowman:GetChildren()) do
				if v:IsA("BasePart") and v.Transparency > 0 then
					return false
				end
			end
			return true
		end
		repeat task.wait()
			if ModelSnow.PlayerSnowman:FindFirstChildOfClass("ProximityPrompt") then
				if typeof(fireproximityprompt) == "function" then
					fireproximityprompt(ModelSnow.PlayerSnowman:FindFirstChildOfClass("ProximityPrompt"))
				end
				if game.Players.LocalPlayer.Backpack:FindFirstChild("Snow") then
					game.Players.LocalPlayer.Backpack:FindFirstChild("Snow").Parent = game.Players.LocalPlayer.Character
				end
				game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = ModelSnow.PlayerSnowman:FindFirstChild("Head").CFrame * CFrame.new(0, 3, 0)
			end
		until PlayerSnow() == true
		wait(0.5)
		for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
			if v:IsA("Tool") then
				game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = ModelSnow.PlayerSnowman:FindFirstChild("Head").CFrame * CFrame.new(0, 3, 0)
				wait(0.3)
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
				wait(0.3)
				if typeof(fireproximityprompt) == "function" then
					fireproximityprompt(ModelSnow.PlayerSnowman:FindFirstChildOfClass("ProximityPrompt"))
				end
				v.Destroying:Wait()
			end
		end
	end)
end
elseif game.PlaceId == 79885102123162 then
function CheckGloveHide(j)
	for i, v in pairs(workspace.Map.GloveLocation:GetDescendants()) do
		if v:IsA("Model") and v.Name:lower():find(j:lower()) then
			if v:GetAttribute("Visible") == true then
				return false
			end
		end
	end
	return true
end

function CheckGloveFind(j)
	for i, v in pairs(workspace.Map.GloveLocation:GetDescendants()) do
		if v:IsA("Model") and v.Name:lower():find(j:lower()) then
			if v:GetAttribute("Visible") == true then
				for _, k in pairs(v:GetDescendants()) do
					if k:IsA("BasePart") then
						return k.CFrame
					end
				end
			end
		end
	end
	return nil
end
			
Window:ChangeTitle("Find Glove 🔍")

Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Find Glove Touch", function()
if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
	for i, v in pairs(workspace.Map.GloveLocation:GetDescendants()) do
		if v:IsA("Model") then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v:GetPivot().Position)
			task.wait(0.3)
		end
		if v:IsA("TouchTransmitter") and v.Parent:IsA("BasePart") and not v.Parent:GetAttribute("__Hidden") then
			repeat task.wait()
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
			until v.Parent:GetAttribute("__Hidden") == true
			task.wait(0.3)
		end
	end
end
end)

for _, j in pairs({"Plate", "Scythe", "Brick", "Jerry", "Prop", "Pineapple"}) do
	MainGroup:AddButton("Find Glove "..j, function()
		if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			if j:lower():find("plate") then
				if workspace:WaitForChild("Map"):WaitForChild("obstacle/puzzles"):WaitForChild("RegularMap"):WaitForChild("Plate"):WaitForChild("Sign"):WaitForChild("hitbox") then
					game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace:WaitForChild("Map"):WaitForChild("obstacle/puzzles"):WaitForChild("RegularMap"):WaitForChild("Plate"):WaitForChild("Sign"):WaitForChild("hitbox").CFrame
					Notification("You have slap Sign to plate", 5)
					repeat task.wait() until not CheckGloveHide(j)
					wait(0.4)
					game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = (CheckGloveFind(j) or game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
				end
			elseif j:lower():find("scythe") then
				Notification("You have click Pumpkin", 5)
				for i, v in pairs(workspace.Map["obstacle/puzzles"].Halloween.Scythe:GetChildren()) do
					if v.Name:find("Pumpkin") then
						for _, k in pairs(v:GetChildren()) do
							if k:IsA("BasePart") and not k:GetAttribute("__Hidden") then
								game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = k.CFrame
								repeat task.wait() until k:GetAttribute("__Hidden") == true
								break
							end
						end
					end
				end
				repeat task.wait() until not CheckGloveHide(j)
				wait(0.4)
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = (CheckGloveFind(j) or game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
			elseif j:lower():find("brick") then
				Notification("You have click brick in collect glove", 5)
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.GloveLocation.CastleIsland.Brick.Brick.CFrame
			elseif j:lower():find("prop") then
				Notification("You have click prop in collect glove", 5)
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map["obstacle/puzzles"].RegularMap.Prop.Prop_Rock.CFrame
			elseif j:lower():find("pineapple") then
				Notification("You have click pineapple in collect glove", 5)
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map["obstacle/puzzles"].Barzil.Pineslapple.Pineapple.CFrame
			elseif j:lower():find("jerry") then
				Notification("You have click Snowpeeps 3 time for the glove to appear", 5)
				for i, v in pairs(workspace.Map["obstacle/puzzles"].Winter.Jerry_Snowpeeps:GetDescendants()) do
					if v:IsA("ClickDetector") then
						if fireclickdetector then
							fireclickdetector(v)
						end
						if v.Parent:IsA("BasePart") then
							game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Parent.CFrame
							repeat task.wait() until v.Parent:GetAttribute("__Hidden") == true
						end
					end
				end
				repeat task.wait() until not CheckGloveHide(j)
				wait(0.4)
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = (CheckGloveFind(j) or game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
			end
		end
	end)
end
elseif game.PlaceId == 15228348051 then
spawn(function()
	repeat task.wait()
		local success, gloves = pcall(function()
			return require(game.ReplicatedStorage.TowerDefenceAssets.TD_Dictionary)
		end)
		if success then
			_G.TDDefence = gloves
		end
	until _G.TDDefence
end)

local LocalPlayer = game.Players.LocalPlayer
local DefenceFile = game.Workspace.Maps:WaitForChild(LocalPlayer.Name.."'s Map"):WaitForChild("Defences")
local TD_Event = game:GetService("ReplicatedStorage"):WaitForChild("TowerDefenceAssets"):WaitForChild("TD_Event")

if LocalPlayer:GetAttribute("CurrentMap") and LocalPlayer:GetAttribute("CurrentMap"):lower() == "mapfarm" then
	SaveDefence = {
	    ["Scarecrow"] = {
	        CFrame.new(18.160, 9.250, -18.350),
	        CFrame.new(18.674, 9.250, -21.802),
	        CFrame.new(15.060, 9.250, -17.360),
	        CFrame.new(17.183, 9.250, -19.138),
	        CFrame.new(16.553, 9.250, -20.415),
	    },
	    ["Farmer2"] = {
	        CFrame.new(46.449, 9.900, -9.293),
	        CFrame.new(26.838, 9.900, 22.784),
	        CFrame.new(58.493, 9.900, 14.624),
	        CFrame.new(20.492, 9.900, 41.426),
	    },
	    ["Farmer1"] = {
	        CFrame.new(-2.882, 9.900, 7.012),
	        CFrame.new(-0.657, 9.900, 6.825),
	        CFrame.new(1.067, 9.900, 6.587),
	        CFrame.new(3.232, 9.900, 6.386),
	        CFrame.new(5.214, 9.900, 5.814),
	    },
	    ["Farmer Tencelll"] = {
	        CFrame.new(21.962, 9.150, -11.323),
	        CFrame.new(80.139, 9.150, -4.739),
	        CFrame.new(37.594, 9.150, 6.968),
	    }
	}
else
	SaveDefence = {
	    ["Defence2"] = {
	        CFrame.new(29.400, 9.667, 4.490),
	        CFrame.new(67.450, 9.667, 22.996),
	        CFrame.new(19.844, 9.667, 8.144),
	        CFrame.new(24.326, 9.667, 50.881),
	        CFrame.new(14.049, 9.667, 32.988),
	    },
	    ["Defence3"] = {
	        CFrame.new(22.585, 9.150, 23.971),
	        CFrame.new(58.277, 9.150, 21.029),
	        CFrame.new(55.227, 9.150, 22.113),
	        CFrame.new(22.134, 9.150, -13.296),
	        CFrame.new(30.495, 9.150, 18.987),
	        CFrame.new(48.039, 9.150, -15.423),
	    },
	    ["Defence1"] = {
	        CFrame.new(23.324, 9.667, -10.980),
	        CFrame.new(50.683, 9.667, -7.535),
	        CFrame.new(50.611, 9.667, 9.831),
	        CFrame.new(38.331, 9.667, -13.706),
	        CFrame.new(38.883, 9.667, 16.625),
	        CFrame.new(48.638, 9.667, -18.055),
	        CFrame.new(49.790, 9.667, 2.143),
	        CFrame.new(53.311, 9.667, 14.962),
	    }
	}
end

Window:ChangeTitle("Map Tower Defence 🌻")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
local function DeployDefences(targetName)
    local cframe = SaveDefence[targetName]
    if not cframe then return end
    for _, targetCF in ipairs(cframe) do
        repeat task.wait(0.7)
            local found = false
            for _, v in pairs(DefenceFile:GetChildren()) do
                if v.Name == targetName and v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - targetCF.Position).Magnitude < 1 then
                    found = true
                    break
                end
            end
            wait(0.5)
			if not found and _G.TDDefence and _G.TDDefence.Defences[targetName] then
                local cost = _G.TDDefence.Defences[targetName].Cost
                local currentGold = LocalPlayer:GetAttribute("Gold")
                if currentGold >= cost then
				    TD_Event:FireServer("PlaceDefence", {
                        ["cf"] = targetCF,
                        ["defencename"] = targetName
                    })
                    wait(0.5)
                end
			end
        until found == true
    end
end
if LocalPlayer:GetAttribute("CurrentMap"):lower() == "mapfarm" then
	DefenceList = {"Scarecrow", "Farmer1", "Farmer2", "Farmer Tencelll"}
else
	DefenceList = {"Defence1", "Defence2", "Defence3"}
end
for _, v in ipairs(DefenceList) do
    DeployDefences(v)
end
while task.wait() do
    if _G.TDDefence then
        for _, v in pairs(DefenceFile:GetChildren()) do
            local config = _G.TDDefence.Defences[v.Name]
            local level = v:GetAttribute("Level")
            if config and level and level < 3 then
                local baseCost = tonumber(config.Cost) or 0
                local upgradeCost = baseCost * 1.3 * level
                if LocalPlayer:GetAttribute("Gold") >= upgradeCost then
                    TD_Event:FireServer("Upgrade", {["defence"] = v})
                end
            end
        end
    end
end
end)
elseif game.PlaceId == 128229958211947 then
Window:ChangeTitle("Chicken Boss 🐣")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
if not game.Workspace:GetAttribute("Phase") then
	Notification("You have wait until fight", 5)
	repeat task.wait() until game.Workspace:GetAttribute("Phase")
end
CreateFreezeBV()
if game.Workspace:GetAttribute("Phase") == 1 then
	repeat task.wait()
		pcall(function()
			if workspace:FindFirstChild("EasterMap"):FindFirstChild("Phase1"):FindFirstChild("MapObjects") then
				for i, v in pairs(workspace.EasterMap.Phase1.MapObjects:GetChildren()) do
					if v.Name:lower() == "slapapult" and v:FindFirstChild("ShootButton") and v:FindFirstChild("HandleButton") and not v:GetAttribute("Broken") then
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.ShootButton.CFrame * CFrame.new(0, 5, 0)
						repeat task.wait()
							game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Egg"):WaitForChild("GloveSwing"):FireServer()
							game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Egg"):WaitForChild("GloveHit"):FireServer(v:FindFirstChild("HandleButton"))
						until (v:GetAttribute("Charge") or 0) >= 2
						wait(0.3)
						repeat task.wait()
							game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Egg"):WaitForChild("GloveSwing"):FireServer()
							game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Egg"):WaitForChild("GloveHit"):FireServer(v:FindFirstChild("ShootButton"))
						until v:GetAttribute("Broken")
					end
				end
			end
		end)
	until game.Workspace:GetAttribute("Phase") >= 2
end
if game.Workspace:GetAttribute("Phase") >= 2 then
	repeat task.wait()
		if workspace:FindFirstChild("ChickenBoss") then
			local cf, size = workspace.ChickenBoss:GetBoundingBox()
			local pos = cf.Position + Vector3.new(0, size.Y/2 + 18, 0)
			if pos then
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos, cf.Position)
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Egg"):WaitForChild("GloveSwing"):FireServer()
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Egg"):WaitForChild("GloveHit"):FireServer(workspace:WaitForChild("ChickenBoss"):WaitForChild("Body_model"))
			end
		end
	until workspace:FindFirstChild("RewardGlove")
end
CreateFreezeBV({Remove = true})
Notification("Ok, Very done", 5)
end)
elseif game.PlaceId == 93981091811742 then
Window:ChangeTitle("Map Cultivate Glove 🧘")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Lotus2Complete"):FireServer()
		if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Akari") then
			game:GetService("Players").LocalPlayer.PlayerGui.Akari:Destroy()
		end
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Minigames"):WaitForChild("Complete"):FireServer()
		wait(0.5)
		for i, v in pairs(workspace:GetChildren()) do
			if v:IsA("Folder") and v.Name:find("Lotus") and v:FindFirstChild("Lotus") and v.Lotus:FindFirstChild("Primary") and v.Lotus.Primary:FindFirstChild("ClickDetector") then
				for j, b in pairs(v.Lotus:GetChildren()) do
					if b:IsA("BasePart") and not b.Name:find("Primary") and b.Transparency < 1 then
						game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Lotus.Primary.CFrame * CFrame.new(0, 5, 0)
						if fireclickdetector then
							fireclickdetector(v.Lotus.Primary.ClickDetector)
						end
						repeat task.wait() until b.Transparency >= 1
						break
					end
				end
			end
		end
	end
end)
elseif game.PlaceId == 77283826005207 then
Window:ChangeTitle("Map Opera ⭕")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
	local map = workspace:FindFirstChild("Map")
	local lobby = map and map:FindFirstChild("Lobby")
	local function firetouch(part)
		if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 5, 0)
			if firetouchinterest then
				firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, part, 0)
				firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, part, 1)
			end
		end
	end
	local function fireclick(click, part)
		if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 5, 0)
		end
		if fireclickdetector then
			fireclickdetector(click)
		end
	end
	local function AutoComplete(number)
		if lobby and lobby:FindFirstChild("Portal"..number) and lobby["Portal"..number]:FindFirstChild("Part"):FindFirstChild("TouchInterest") then
			firetouch(lobby["Portal"..number].Part)
			repeat task.wait() until map and map:FindFirstChild("Challenge"..number)
			wait(0.5)
			if map:FindFirstChild("Challenge"..number) and map["Challenge"..number]:FindFirstChild("RedButton") then
				fireclick(map["Challenge"..number].RedButton.Button:FindFirstChild("ClickDetector"), map["Challenge"..number].RedButton.Button.Sphere)
			end
			repeat task.wait() until not map:FindFirstChild("Challenge"..number) and not lobby["Portal"..number].Part:FindFirstChild("TouchInterest")
		end
	end
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for i = 1, 3 do
			AutoComplete(i)
			wait(0.5)
		end
		if lobby and lobby:FindFirstChild("EndPortal") then
			local portal1 = not lobby["Portal1"].Part:FindFirstChild("TouchInterest")
			local portal2 = not lobby["Portal2"].Part:FindFirstChild("TouchInterest")
			local portal3 = not lobby["Portal3"].Part:FindFirstChild("TouchInterest")
			local getglove = lobby:FindFirstChild("EndPortal"):FindFirstChild("Portal")
			if portal1 and portal2 and portal3 and getglove then
				firetouch(getglove)
			end
		end
	end
end)
elseif game.PlaceId == 125845699717230 then
Window:ChangeTitle("Map Doors 🚪")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local OpenedDoors = {}
		while true and task.wait() do
			if workspace:FindFirstChild("Hallways") then
				for i, v in pairs(workspace.Hallways:GetChildren()) do
					local HallwayDoor = v:FindFirstChild("Doors")
					if HallwayDoor then
						for j, b in pairs(HallwayDoor:GetChildren()) do
							if b:IsA("Model") and tonumber(b.Name) then
								if OpenedDoors[b] then 
	                                continue 
	                            end
								local DoorHitbox = b:FindFirstChild("Hitbox")
								local Click = DoorHitbox and DoorHitbox:FindFirstChild("ClickDetector")
								if DoorHitbox then
									repeat task.wait()
										if fireclickdetector then
											fireclickdetector(Click)
										end
										game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = DoorHitbox.CFrame * CFrame.new(0, 0, -5)
									until b:GetAttribute("Open")
									OpenedDoors[b] = true
								end
							end
						end
					end
				end
			end
		end
	end
end)
elseif game.PlaceId == 77963332815593 then
function slapglove(object)
	local player = game.Players.LocalPlayer
	if not player then return end
	local char = player.Character
	if not char then return end
	local part = object
	if not part then return end
	if char:FindFirstChild("Lantern") then
		char.Lantern:Activate()
		game:GetService("ReplicatedStorage").Remotes.SlapPest:FireServer(part, Vector3.new(0,0,0))
	end
end

_G.GetOldBright = {
	["Old"] = {
		Brightness = game.Lighting.Brightness,
		ClockTime = game.Lighting.ClockTime,
		FogEnd = game.Lighting.FogEnd,
		FogStart = game.Lighting.FogStart,
		GlobalShadows = game.Lighting.GlobalShadows,
		OutdoorAmbient = game.Lighting.OutdoorAmbient
	},
	["New"] = {
		Brightness = 2,
		ClockTime = 14,
		FogEnd = 200000,
		FogStart = 100000,
		GlobalShadows = false,
		OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	}
}

for i, v in pairs(_G.GetOldBright.New) do
	game.Lighting:GetPropertyChangedSignal(i):Connect(function()
		if _G.FullBright then
			game.Lighting[i] = v
		end
	end)
end

table.insert(_G.ConnectFun, game:GetService("RunService").RenderStepped:Connect(function()
	for i, v in pairs(workspace:GetChildren()) do
		if _G.AntiRing and v.Name:lower():find("ring") then
			v:Destroy()
		end
		if _G.AntiDucks and v:IsA("Folder") and v.Name:lower():find("duck") then
			v:Destroy()
		end
	end
	if _G.AutoBlooming then
		local TargetLight
	    local StartCorridor = workspace:FindFirstChild("StartCorridor")
	    local FinalRing = StartCorridor and StartCorridor:FindFirstChild("FinalRing")
	    local LightPlatforms = FinalRing and FinalRing:FindFirstChild("LightPlatforms")
	    if LightPlatforms then
	        for _, v in pairs(LightPlatforms:GetChildren()) do
	            if v:IsA("Folder") and v.Name:lower():find("light") then
	                for _, j in pairs(v:GetChildren()) do
	                    if j:IsA("Model") and j.Name:lower():find("rotatingbloominglight") and j:FindFirstChild("RotatingModel") and j.RotatingModel:FindFirstChild("Housing") then
	                        local Housing = j.RotatingModel.Housing
	                        local checkLightBeam = j:FindFirstChild("LightBeam") 
	                        if not checkLightBeam then
	                            TargetLight = Housing
	                        end
	                    end
	                end
	            end
	        end
	    end
	    if TargetLight then
		    slapglove(TargetLight)
	        CreateFreezeBV({Name = "Skibidi_Light"})
	        local Character = game.Players.LocalPlayer.Character
	        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
	        local Camera = workspace.CurrentCamera
	        local OrbitOffset = CFrame.new(math.cos(tick() * 3) * 28, 0, math.sin(tick() * 3) * 28)
	        if Root then
	            Root.CFrame = TargetLight.CFrame * OrbitOffset
	        end
	        if Camera then
		        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, TargetLight.Position)
	        end
	    end
	end
end))

Window:ChangeTitle("Map Pim Fighter ⚔️")
Tabs = {
	Tab = Window:AddTab("Quest", "rbxassetid://4370318685"),
	Tab1 = Window:AddTab("Fighter", "rbxassetid://10734975486"),
	Tab2 = Window:AddTab("Misc", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Quest1Group = Tabs.Tab:AddLeftGroupbox("Quest 1")

Quest1Group:AddButton("Open All Chest", function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local OldCF = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame
		for i, v in pairs(workspace:GetChildren()) do
			if v.Name:lower():find("basicchest") and v:FindFirstChild("Base") and v.Base:FindFirstChild("ProximityPrompt") then
				local prompt = v.Base:FindFirstChildOfClass("ProximityPrompt")
				if prompt then
				    repeat task.wait()
				        if not prompt.Parent then
				            break
				        end
				        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.Base.CFrame * CFrame.new(0, 5, 0)
				        if fireproximityprompt then
				            fireproximityprompt(prompt)
				        end
				    until not prompt.Parent
				end
			end
		end
		if OldCF then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = OldCF
		end
	end
end)

Quest1Group:AddButton("Insert Key", function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for i, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
			if v:IsA("Tool") and v.Name:lower():find("key") then
				v.Parent = game:GetService("Players").LocalPlayer.Character
			end
		end
		for i, v in pairs(workspace.FinalRoom:GetChildren()) do
			if v:IsA("Model") and v.Name:lower():find("key") then
				game:GetService("ReplicatedStorage").Remotes.KeyLockAttempt:FireServer(v)
			end
		end
	end
end)

local Quest2Group = Tabs.Tab:AddRightGroupbox("Quest 2")

Quest2Group:AddButton("Show Light Orb", function()
	for _, v in game:GetService("CollectionService"):GetTagged("Revealable") do
		if v:IsA("BasePart") and v:GetAttribute("LightSpawner") then
			local revealID = v:GetAttribute("RevealID")
			if revealID then
				game:GetService("ReplicatedStorage").Remotes.RevealLightSpawner:FireServer(revealID)
			end
		end
	end
end)

Quest2Group:AddButton("Slap Light Orb", function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name:lower():find("lightorb") then
				game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
				wait(0.4)
				slapglove(v)
				task.wait(0.7)
			end
		end
	end
end)

Quest2Group:AddButton("Teleport Boss", function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		if workspace:FindFirstChild("StartCorridor"):FindFirstChild("FinalRing"):FindFirstChild("Trigger") then
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.StartCorridor.FinalRing.Trigger.CFrame
		end
	end
end)

local BossGroup = Tabs.Tab1:AddLeftGroupbox("Boss Phase 1")

BossGroup:AddToggle("Auto Light Part", {
    Text = "Auto Blooming Light",
    Default = false, 
    Callback = function(Value) 
_G.AutoBlooming = Value
if not _G.AutoBlooming then
	CreateFreezeBV({Name = "Skibidi_Light", Remove = true})
end
if guideLoad then return end
guideLoad = true
Notification("When only one flower remains unopened, you can activate the auto-blooming feature once, then deactivate it and fly to the fallen flower to tap it and make it bloom. If you don't deactivate the auto-teleport feature when you reach the boss in phase 2, it will teleport you back to your original location, cutting off your path to receive the badge, But while you're at it, you have to dodge the pims that are being ejected.", 13)
    end
})

local Boss1Group = Tabs.Tab1:AddRightGroupbox("Boss Phase 2")

Boss1Group:AddToggle("Auto Slap Eye", {
    Text = "Slap Aura Laser",
    Default = false, 
    Callback = function(Value) 
_G.AutoSlapEye = Value
while _G.AutoSlapEye and task.wait() do
	if workspace:FindFirstChild("LaserEye") and workspace.LaserEye:FindFirstChild("Base") and workspace.LaserEye:GetAttribute("Stunned") then
		slapglove(workspace.LaserEye.Base)
	end
end
    end
})

Boss1Group:AddToggle("Auto Slap Chomper", {
    Text = "Slap Aura Chomper",
    Default = false, 
    Callback = function(Value) 
_G.AutoSlapChomper = Value
while _G.AutoSlapChomper and task.wait() do
	if workspace:FindFirstChild("ChomperEye") and workspace.ChomperEye:FindFirstChild("Hitbox") and workspace.ChomperEye:GetAttribute("Stunned") then
		slapglove(workspace.ChomperEye.Hitbox)
	end
end
    end
})

Boss1Group:AddToggle("Auto Shout", {
    Text = "Auto Shout",
    Default = false, 
    Callback = function(Value) 
_G.AutoShout = Value
if Toggles and Toggles["Teleport Shout"] then
	Toggles["Teleport Shout"]:SetVisible(Value)
end
while _G.AutoShout and task.wait() do
	for i, v in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v.Name:lower():find("eye") and v:FindFirstChild("Base") and v:GetAttribute("Vulnerable") and not v:GetAttribute("Stunned") then
			local Character = game.Players.LocalPlayer.Character
	        local Root = Character and Character:FindFirstChild("HumanoidRootPart")
			if Root then
				if _G.TeleportShout then
					Root.CFrame = v.Base.CFrame
				end
				game:GetService("ReplicatedStorage").Remotes.ActivateAbility:FireServer("Shout", (v.Base.Position - Root.Position).Unit)
			end
		end
	end
end
    end
})

Boss1Group:AddToggle("Teleport Shout", {
    Text = "Teleport Shout",
    Default = false,
    Visible = false,
    Callback = function(Value) 
_G.TeleportShout = Value
    end
})

local MiscGroup = Tabs.Tab2:AddLeftGroupbox("Misc")

MiscGroup:AddToggle("No Cooldown Proximity", {
    Text = "No Cooldown Proximity",
    Default = false, 
    Callback = function(Value) 
_G.NoCooldownProximity = Value
if _G.NoCooldownProximity == true then
for i, v in pairs(workspace:GetDescendants()) do
if v.ClassName == "ProximityPrompt" then
v.HoldDuration = 0
end
end
else
if CooldownProximity then
CooldownProximity:Disconnect()
CooldownProximity = nil
end
end
CooldownProximity = workspace.DescendantAdded:Connect(function(Cooldown)
if _G.NoCooldownProximity == true then
if Cooldown:IsA("ProximityPrompt") then
Cooldown.HoldDuration = 0
end
end
end)
    end
})

MiscGroup:AddInput("FlySpeed", {
    Default = "50",
    Numeric = true,
    Text = "Fly Speed",
    Placeholder = "UserFlySpeed",
    Callback = function(Value)  
        _G.SetSpeedFly = Value  
    end  
})

_G.SetSpeedFly = 50
MiscGroup:AddToggle("Start Fly", {
    Text = "Start Fly",
    Default = false, 
    Callback = function(Value) 
Fly(Value)
	end
}):AddKeyPicker("Fly", {
   Default = "R",
   Text = "Fly",
   Mode = "Toggle",
   SyncToggleState = true
})

MiscGroup:AddToggle("Full Bright", {
    Text = "Full Bright",
    Default = false, 
    Callback = function(Value) 
_G.FullBright = Value
if not _G.FullBright then
	for i, v in pairs(_G.GetOldBright.Old) do
		game:GetService("Lighting")[i] = v
	end
else
	for i, v in pairs(_G.GetOldBright.New) do
		game:GetService("Lighting")[i] = v
	end
end
    end
})

MiscGroup:AddToggle("No Fog", {
    Text = "No Fog",
    Default = false, 
    Callback = function(Value) 
_G.Nofog = Value
while _G.Nofog do
for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
	if v.ClassName == "Atmosphere" then
		v.Density = 0
		v.Haze = 0
	end
end
task.wait()
end
for i, v in pairs(game:GetService("Lighting"):GetChildren()) do
	if v.ClassName == "Atmosphere" then
		v.Density = 0.3
		v.Haze = 1
	end
end
    end
})

MiscGroup:AddToggle("Inf Jump", {
    Text = "Inf Jump",
    Default = false, 
    Callback = function(Value) 
_G.InfJump = Value
    end
})

table.insert(_G.ConnectFun, game:GetService("UserInputService").JumpRequest:Connect(function()
	if _G.InfJump then
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end))

local Misc1Group = Tabs.Tab2:AddRightGroupbox("Other")

Misc1Group:AddToggle("Inf Mana", {
    Text = "Inf Mana",
    Default = false, 
    Callback = function(Value)
_G.InfMana = Value
while _G.InfMana and task.wait() do
	game:GetService("ReplicatedStorage").Remotes.ManaSpend:FireServer(-100)
end
    end
})

Misc1Group:AddButton("Give Inf Mana", function()
	game:GetService("ReplicatedStorage").Remotes.ManaSpend:FireServer(-math.huge)
end)

Misc1Group:AddToggle("Anti Ring", {
    Text = "Anti Ring",
    Default = false, 
    Callback = function(Value) 
_G.AntiRing = Value
    end
})

Misc1Group:AddToggle("Anti Ducks", {
    Text = "Anti Ducks",
    Default = false, 
    Callback = function(Value) 
_G.AntiDucks = Value
    end
})
elseif game.PlaceId == 122902713960550 then
Window:ChangeTitle("Map Summer ⛱️")
Tabs = {
	Tab = Window:AddTab("Main", "rbxassetid://4370318685"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local MainGroup = Tabs.Tab:AddLeftGroupbox("Main")

MainGroup:AddButton("Get Badge", function()
	if workspace:FindFirstChild("ObjectSpawner_Objects") then
		workspace.ObjectSpawner_Objects:Destroy()
	end
	local Dialogue
	for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
		if v:IsA("ScreenGui") and v:FindFirstChild("Dialogue") then
			Dialogue = v.Dialogue
		end
	end
	if Dialogue and Dialogue.Parent and (not Dialogue.Visible or not Dialogue.Parent.Enabled) then
		game:GetService("Players").LocalPlayer.Character:PivotTo(Workspace.Island["John Surfboard"].Head.CFrame * CFrame.new(0, 5, 0))
		task.wait(0.36)
		if fireproximityprompt then
			fireproximityprompt(workspace.Island["John Surfboard"].Head:FindFirstChildOfClass("ProximityPrompt"), 0)
			fireproximityprompt(workspace.Island["John Surfboard"].Head:FindFirstChildOfClass("ProximityPrompt"), 1)
		end
		repeat task.wait() until Dialogue.Visible or Dialogue.Parent.Enabled
		wait(0.6)
		repeat task.wait()
			game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Common"):WaitForChild("Dialogue"):WaitForChild("Remotes"):WaitForChild("ResondToDialogue"):FireServer(0)
		until not Dialogue.Visible or not Dialogue.Parent.Enabled
		workspace.Camera.CameraSubject = game:GetService("Players").LocalPlayer.Character
	end
end)
end
getgenv().LoadingScriptSlap = false
if MobileOn then
	Library:SetDPIScale(85)
end
local success, err = pcall(function()
	getgenv().WindowNah = Window
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/File-Script/CreditJoin.Lua"))()
end)

if Window and Tabs then
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu") 
local Info = Tabs["UI Settings"]:AddRightGroupbox("Info")

MenuGroup:AddDropdown("NotifySide", {
    Text = "Notification Side",
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
Library.NotifySide = Value
    end
})

_G.ChooseNotify = "Obsidian"
MenuGroup:AddDropdown("NotifyChoose", {
    Text = "Notification Choose",
    Values = {"Obsidian", "Roblox"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
})

_G.BackpackV2 = true
MenuGroup:AddToggle("Backpack v2", {
    Text = "Backpack v2",
    Default = true, 
    Callback = function(Value) 
_G.BackpackV2 = Value 
    end
})

_G.GloveDrop = false
MenuGroup:AddToggle("Glove Drop", {
    Text = "Glove Drop Unequipped",
    Default = false, 
    Callback = function(Value) 
_G.GloveDrop = Value 
    end
})

_G.NotificationSound = true
MenuGroup:AddToggle("NotifySound", {
    Text = "Notification Sound",
    Default = true, 
    Callback = function(Value) 
_G.NotificationSound = Value 
    end
})

MenuGroup:AddSlider("Volume Notification", {
    Text = "Volume Notification",
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})

MenuGroup:AddSlider("Time Notification", {
    Text = "Time Notification",
    Default = 5,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
_G.TimeNotify = Value
    end
})

MenuGroup:AddToggle("KeybindMenuOpen", {Default = false, Text = "Open Keybind Menu", Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddToggle("ExecuteOnTeleport", {Default = true, Text = "Execute On Teleport"})
MenuGroup:AddDropdown("DPIDropdown", {
    Values = {"50%", "75%", "80%", "85%", "100%", "115%", "125%", "150%", "175%", "200%"},
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local He = tonumber(Value)
        Library:SetDPIScale(He)
    end
})

MenuGroup:AddSlider("UICornerSlider", {
    Text = "Corner Radius",
    Default = Library.CornerRadius,
    Min = 0,
    Max = 20,
    Rounding = 0,
    Callback = function(value)
        Window:SetCornerRadius(value)
    end
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Info:AddLabel("Counter [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel("Executor [ "..((ExecutorSupport and ExecutorSupport.Name) or "Unknown").." ]", true)
Info:AddLabel("Support [ "..((ExecutorSupport and ExecutorSupport.Summary) or "Unknown").." ]", true)
Info:AddLabel("Job Id [ "..game.JobId.." ]", true)
Info:AddDivider()
Info:AddButton("Copy JobId", function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Library:Notify("Copied Success")
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Info:AddInput("Join Job", {
    Default = "Nah",
    Numeric = false,
    Text = "Join Job",
    Placeholder = "UserJobId",
    Callback = function(Value)
_G.JobIdJoin = Value
    end
})

Info:AddButton("Join JobId", function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdJoin, game.Players.LocalPlayer)
end)

Info:AddButton("Copy Join JobId", function()
    if setclipboard then
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, "'..game.JobId..'"'..", game.Players.LocalPlayer)")
        Library:Notify("Copied Success") 
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
end

Library:OnUnload(function()
	_G.BackpackV2 = false
	_G.BackpackV2Loop = false
	_G.GloveDropUnEquipped = false
	if _G.ConnectFun then
		for i, v in pairs(_G.ConnectFun) do
			v:Disconnect()
		end
	_G.ConnectFun = nil
	end
	local CoreGui = game.CoreGui
	if CoreGui:FindFirstChild("Gui Track") then
		CoreGui:FindFirstChild("Gui Track"):Destroy()
	end
	if CoreGui:FindFirstChild("Gui Button Script") then
		CoreGui:FindFirstChild("Gui Button Script"):Destroy()
	end
	if CoreGui:FindFirstChild("Keybind Script") then
		CoreGui:FindFirstChild("Keybind Script"):Destroy()
	end
	if CoreGui:FindFirstChild("ClickButton") then
		CoreGui:FindFirstChild("ClickButton"):Destroy()
	end
	if hookmetamethod and getgenv().HookFun then
		hookmetamethod(game, "__namecall", getgenv().HookFun)
		getgenv().HookFun = nil
	end
	if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Hotbar") then
		game:GetService("CoreGui").RobloxGui.Backpack.Hotbar.Position = _G.Backpack["Old"]["Hotbar"]
	end
	if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Inventory") then
		game:GetService("CoreGui").RobloxGui.Backpack.Inventory.Position = _G.Backpack["Old"]["Inventory"]
	end
	for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
		if v:IsA("TextButton") and v:FindFirstChild("Number") then
			v.Number.Position = _G.Backpack["Old"]["Backpack Number"][v.Name]
		end
	end
	if game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:FindFirstChild("UIListLayout") then
		game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:FindFirstChild("UIListLayout"):Destroy()
	end
	for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
		if v:IsA("TextButton") then
			if v:FindFirstChild("Equipped") then
				v.Equipped.Visible = true
			end
			if v:FindFirstChild("SelectionObjectClipper") then
				v.SelectionObjectClipper.Visible = false
			end
			if v:FindFirstChild("UICorner") then
				v:FindFirstChild("UICorner"):Destroy()
			end
		end
	end
	for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Inventory.ScrollingFrame.UIGridFrame:GetChildren()) do
		if v:IsA("TextButton") then
			if v:FindFirstChild("Equipped") then
				v.Equipped.Visible = true
			end
			if v:FindFirstChild("SelectionObjectClipper") then
				v.SelectionObjectClipper.Visible = false
			end
			if v:FindFirstChild("UICorner") then
				v:FindFirstChild("UICorner"):Destroy()
			end
		end
	end
	for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Inventory:GetChildren()) do
		if v.Name == "Search" then
			if v:FindFirstChild("UICorner") then
				v:FindFirstChild("UICorner"):Destroy()
			end
			if v:FindFirstChild("X") and v["X"]:FindFirstChild("UICorner") then
				v["X"]:FindFirstChild("UICorner"):Destroy()
			end
		end
	end
	if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Inventory") and game:GetService("CoreGui").RobloxGui.Backpack.Inventory:FindFirstChild("UICorner") then
		game:GetService("CoreGui").RobloxGui.Backpack.Inventory:FindFirstChild("UICorner"):Destroy()
	end
	_G.Backpack = nil
	gloveHits = nil
	if AutoSetInfoServer then
		AutoSetInfoServer:Disconnect()
		AutoSetInfoServer = nil
	end
end)

----========== Other Script ===========----

local tweenService = game:GetService("TweenService")
local function triggerUnequipEffect()
	if not savedHandle or not savedGlove then return end
	local modelTool = Create("Model", {Name = "GloveDrop", Parent = workspace})
	local fakeHandle = savedHandle:Clone()
	local fakeGlove = savedGlove:Clone()
	fakeHandle.Parent = modelTool
	fakeGlove.Parent = modelTool
	fakeHandle.CanCollide = true
	fakeGlove.CanCollide = true
	fakeHandle.Anchored = false
	fakeGlove.Anchored = false
	if fakeHandle then
		for _, v in pairs(fakeHandle:GetDescendants()) do
			if v:IsA("Weld") or v:IsA("ManualWeld") or v:IsA("WeldConstraint") then 
				v:Destroy()
			end
		end
	end
	if fakeGlove then
		for _, v in pairs(fakeGlove:GetDescendants()) do
			if v:IsA("Weld") or v:IsA("ManualWeld") or v:IsA("WeldConstraint") then 
				v:Destroy()
			end
			if v:IsA("Script") or v:IsA("LocalScript") then
				v:Destroy()
			end
			if v:IsA("BasePart") then
				v.CanCollide = true
			end
		end
		if fakeGlove:FindFirstChild("RopeConstraint") then
			if fakeHandle and fakeHandle:FindFirstChildOfClass("Attachment") then
				fakeGlove.RopeConstraint.Attachment1 = fakeHandle:FindFirstChildOfClass("Attachment")
			end
		end
	end
	local char = game.Players.LocalPlayer.Character
	local Arm = char and char:FindFirstChild("RightHand")
	local startCFrame = Arm and Arm.CFrame
	if startCFrame then
		fakeHandle.CFrame = startCFrame * CFrame.new(0, -2, 0)
		local offsetUp = Vector3.new(0, fakeHandle.Size.Y + (fakeHandle.Size.Y / 2), 0)
		fakeGlove.CFrame = fakeHandle.CFrame * CFrame.new(-offsetUp) * CFrame.Angles(0, 0, math.rad(50))
	end
	fakeHandle.Velocity = Vector3.new(0, 0, -5) 
	fakeHandle.RotVelocity = Vector3.new(0, 0, -12)
	task.delay(1, function()
		if fakeHandle and fakeGlove then
			local info = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
			tweenService:Create(fakeHandle, info, {Transparency = 1, Size = Vector3.new(0,0,0)}):Play()
			tweenService:Create(fakeGlove, info, {Transparency = 1, Size = Vector3.new(0,0,0)}):Play()
			for _, v in pairs(fakeGlove:GetDescendants()) do
				if v:IsA("BasePart") then
					tweenService:Create(v, info, {Transparency = 1, Size = Vector3.new(0,0,0)}):Play()
				end
			end
			if fakeGlove and fakeGlove:FindFirstChild("RopeConstraint") then
				tweenService:Create(fakeGlove.RopeConstraint, info, {Thickness = 0}):Play()
			end
		end
	end)
	task.delay(1.5, function()
		if modelTool then
			modelTool:Destroy()
		end
	end)
end

task.spawn(function()
	_G.GloveDropUnEquipped = true
	while _G.GloveDropUnEquipped and task.wait() do
		if _G.GloveDrop then
			local char = game.Players.LocalPlayer.Character
			if not char then continue end
			local foundTool = char:FindFirstChildOfClass("Tool")
			if foundTool and not isEquipped then
				local handle = foundTool:FindFirstChild("Handle")
				local glove = foundTool:FindFirstChild("Glove")
				if handle and glove then
					isEquipped = true
					savedHandle = handle
					savedGlove = glove
				end
			elseif not foundTool and isEquipped then
				isEquipped = false
				triggerUnequipEffect()
				savedHandle = nil
				savedGlove = nil
			end
		end
	end
end)

_G.BackpackV2Loop = true
if _G.Backpack == nil then
_G.Backpack = {
	["Old"] = {
		["Hotbar"] = game:GetService("CoreGui").RobloxGui.Backpack.Hotbar.Position,
		["Inventory"] = game:GetService("CoreGui").RobloxGui.Backpack.Inventory.Position,
		["Backpack Number"] = {}
	},
	["New"] = {
		["Hotbar"] = (game:GetService("CoreGui").RobloxGui.Backpack.Hotbar.Position + UDim2.new(0, 0, 0, -10)),
		["Inventory"] = (game:GetService("CoreGui").RobloxGui.Backpack.Inventory.Position + UDim2.new(0, 0, 0, -10)),
		["Backpack Number"] = {}
	}
}
wait()
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
if v:IsA("TextButton") then
_G.Backpack["Old"]["Backpack Number"][v.Name] = v.Position
_G.Backpack["New"]["Backpack Number"][v.Name] = UDim2.new(0, 3, 0, 3)
end
end
end
spawn(function()
while _G.BackpackV2Loop do
if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Hotbar") then
game:GetService("CoreGui").RobloxGui.Backpack.Hotbar.Position = (_G.BackpackV2 == true and (_G.Backpack["New"]["Hotbar"]) or (_G.Backpack["Old"]["Hotbar"]))
end
if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Inventory") then
game:GetService("CoreGui").RobloxGui.Backpack.Inventory.Position = (_G.BackpackV2 == true and (_G.Backpack["New"]["Inventory"]) or (_G.Backpack["Old"]["Inventory"]))
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
if v:IsA("TextButton") and v:FindFirstChild("Number") then
v.Number.Position = (_G.BackpackV2 == true and (_G.Backpack["New"]["Backpack Number"][v.Name]) or (_G.Backpack["Old"]["Backpack Number"][v.Name]))
end
end
if _G.BackpackV2 == true then
if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Inventory").Visible == false then
if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Hotbar"):FindFirstChild("UIListLayout") == nil then
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.Parent = game:GetService("CoreGui").RobloxGui.Backpack.Hotbar
end
else
if game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:FindFirstChild("UIListLayout") then
game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:FindFirstChild("UIListLayout"):Destroy()
end
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
if v:IsA("TextButton") then
if v:FindFirstChild("Equipped") then
v.Equipped.Visible = false
end
if v:FindFirstChild("Equipped") and v:FindFirstChild("SelectionObjectClipper") then
v.SelectionObjectClipper.Visible = true
else
v.SelectionObjectClipper.Visible = false
end
if v:FindFirstChild("UICorner") == nil then
local RobloxUi = Instance.new("UICorner", v)
RobloxUi.CornerRadius = UDim.new(0, 10)
end
end
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Inventory.ScrollingFrame.UIGridFrame:GetChildren()) do
if v:IsA("TextButton") then
if v:FindFirstChild("Equipped") then
v.Equipped.Visible = false
end
if v:FindFirstChild("Equipped") and v:FindFirstChild("SelectionObjectClipper") then
v.SelectionObjectClipper.Visible = true
else
v.SelectionObjectClipper.Visible = false
end
if v:FindFirstChild("UICorner") == nil then
local RobloxUi = Instance.new("UICorner", v)
RobloxUi.CornerRadius = UDim.new(0, 10)
end
end
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Inventory:GetChildren()) do
if v.Name == "Search" then
if v:FindFirstChild("UICorner") == nil then
local RobloxUi = Instance.new("UICorner", v)
RobloxUi.CornerRadius = UDim.new(0, 10)
end
if v:FindFirstChild("X") and v["X"]:FindFirstChild("UICorner") == nil then
local RobloxUi = Instance.new("UICorner", v["X"])
RobloxUi.CornerRadius = UDim.new(0, 10)
end
end
end
if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Inventory") and game:GetService("CoreGui").RobloxGui.Backpack.Inventory:FindFirstChild("UICorner") == nil then
local RobloxUi = Instance.new("UICorner", game:GetService("CoreGui").RobloxGui.Backpack.Inventory)
RobloxUi.CornerRadius = UDim.new(0, 10)
end
elseif _G.BackpackV2 == false then
if game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:FindFirstChild("UIListLayout") then
game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:FindFirstChild("UIListLayout"):Destroy()
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
if v:IsA("TextButton") then
if v:FindFirstChild("Equipped") then
v.Equipped.Visible = true
end
if v:FindFirstChild("SelectionObjectClipper") then
v.SelectionObjectClipper.Visible = false
end
if v:FindFirstChild("UICorner") then
v:FindFirstChild("UICorner"):Destroy()
end
end
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Inventory.ScrollingFrame.UIGridFrame:GetChildren()) do
if v:IsA("TextButton") then
if v:FindFirstChild("Equipped") then
v.Equipped.Visible = true
end
if v:FindFirstChild("SelectionObjectClipper") then
v.SelectionObjectClipper.Visible = false
end
if v:FindFirstChild("UICorner") then
v:FindFirstChild("UICorner"):Destroy()
end
end
end
for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Inventory:GetChildren()) do
if v.Name == "Search" then
if v:FindFirstChild("UICorner") then
v:FindFirstChild("UICorner"):Destroy()
end
if v:FindFirstChild("X") and v["X"]:FindFirstChild("UICorner") then
v["X"]:FindFirstChild("UICorner"):Destroy()
end
end
end
if game:GetService("CoreGui").RobloxGui.Backpack:FindFirstChild("Inventory") and game:GetService("CoreGui").RobloxGui.Backpack.Inventory:FindFirstChild("UICorner") then
game:GetService("CoreGui").RobloxGui.Backpack.Inventory:FindFirstChild("UICorner"):Destroy()
end
end
task.wait()
end
end)

local function BackpackV2(v)
v.MouseEnter:Connect(function()
if _G.BackpackV2 == true then
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://10066942189"
sound.Volume = 2
sound.PlaybackSpeed = 1
sound.PlayOnRemove = true
sound:Destroy()
game:GetService("TweenService"):Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 70, 0, 70)}):Play()
end
end)
v.MouseLeave:Connect(function()
if _G.BackpackV2 == true then
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://10066942189"
sound.Volume = 2
sound.PlaybackSpeed = 1
sound.PlayOnRemove = true
sound:Destroy()
game:GetService("TweenService"):Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end
end)
v.MouseButton1Click:Connect(function()
if _G.BackpackV2 == true then
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://10066936758"
sound.Volume = 2
sound.PlaybackSpeed = 1
sound.PlayOnRemove = true
sound:Destroy()
local TweenGui = game:GetService("TweenService"):Create(v, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 70, 0, 70)})
TweenGui:Play()
TweenGui.Completed:Connect(function()
game:GetService("TweenService"):Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)
end
end)
end

for i, v in pairs(game:GetService("CoreGui").RobloxGui.Backpack.Hotbar:GetChildren()) do
if v:IsA("TextButton") then
BackpackV2(v)
end
end
table.insert(_G.ConnectFun, game:GetService("CoreGui").RobloxGui.Backpack.Inventory.ScrollingFrame.UIGridFrame.ChildAdded:Connect(function(v)
if v:IsA("TextButton") then
BackpackV2(v)
end
end))
------------------------------------------------------------------------
function Unfreeze()
	if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FreezeBVButton") then
		game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FreezeBVButton"):Destroy()
	end
end
function ClickFreezeBV(call)
local success, err = pcall(call)
if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("AntiRagBV1") == nil then
	local bv = Instance.new("BodyVelocity")
	bv.Name = "FreezeBVButton"
	bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
	bv.MaxForce = Vector3.new(100000, 100000, 100000)
	bv.Velocity = Vector3.new(0, 0, 0)
end
local CoreGui = game:GetService("CoreGui")
if not CoreGui:FindFirstChild("ClickDestroyFreezeBV") then
	local gui = Instance.new("ScreenGui", CoreGui)
	gui.Name = "ClickDestroyFreezeBV"
	
	Freeze = true
	TextButton = Instance.new("TextButton")
	TextButton.Name = "Remote Freeze"
	TextButton.Size = UDim2.new(0.12, 0, 0.12, 0)
	TextButton.Position = UDim2.new(0.42, 0, 0.7, 0)
	TextButton.BackgroundColor3 = Color3.new(255, 255, 255)
	TextButton.Text = "Unfreeze"
	TextButton.TextScaled = true
	TextButton.BackgroundTransparency = 0 
	TextButton.TextColor3 = Color3.new(0, 0, 0)
	TextButton.Font = Enum.Font.Code
	TextButton.Draggable = true
	TextButton.Parent = gui
	Instance.new("UICorner").Parent = TextButton
	TextButton.MouseButton1Click:Connect(function()
		Freeze = not Freeze
		if not Freeze then
			if TextButton then
				TextButton.Text = "Freeze"
			end
			Unfreeze()
		else
			if TextButton then
				TextButton.Text = "Unfreeze"
			end
			if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FreezeBVButton") == nil then
				local bv = Instance.new("BodyVelocity")
				bv.Name = "FreezeBVButton"
				bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
				bv.MaxForce = Vector3.new(100000, 100000, 100000)
				bv.Velocity = Vector3.new(0, 0, 0)
			end
			pcall(call)
		end
	end)
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = Color3.new(0, 0, 0)
	Stroke.Thickness = 2.2
	Stroke.ApplyStrokeMode = "Border"
	Stroke.Parent = TextButton
end
end
------------------------------------------------------------------------
table.insert(_G.ConnectFun, game.Players.LocalPlayer.OnTeleport:Connect(function()
if not Toggles["ExecuteOnTeleport"].Value or getgenv().LoadingExe then return end
getgenv().LoadingExe = true
local ExecuteNowTP = queueonteleport or queue_on_teleport
if ExecuteNowTP then
ExecuteNowTP([[
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    repeat wait() until game.Players.LocalPlayer
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/File-Script/Slap_Battles.lua"))()
]])
end
end))
------------------------------------------------------------------------
local function safe(g)
	return game.ReplicatedStorage:FindFirstChild(g) or nil
end

gloveHits = {
	["All"] = safe("GeneralHit"),
	------------------------------------------------
	["Default"] = safe("b"),
	["Extended"] = safe("b"),
	["Ketchup Default"] = safe("b"),
	["Default but Bad"] = safe("dbb"),
	------------------------------------------------
	["ZZZZZZZ"] = safe("ZZZZZZZHit"),
	["Dual"] = safe("DualHit"),
	["Brick"] = safe("BrickHit"),
	["Snow"] = safe("SnowHit"),
	["Pull"] = safe("PullHit"),
	["Flash"] = safe("FlashHit"),
	["Spring"] = safe("springhit"),
	["Swapper"] = safe("HitSwapper"),
	["Bull"] = safe("BullHit"),
	["Dice"] = safe("DiceHit"),
	["Ghost"] = safe("GhostHit"),
	["Stun"] = safe("HtStun"),
	["Za Hando"] = safe("zhramt"),
	["Fort"] = safe("Fort"),
	["Magnet"] = safe("MagnetHIT"),
	["Pusher"] = safe("PusherHit"),
	["Anchor"] = safe("hitAnchor"),
	["Space"] = safe("HtSpace"),
	["Boomerang"] = safe("BoomerangH"),
	["Speedrun"] = safe("Speedrunhit"),
	["Mail"] = safe("MailHit"),
	["Golden"] = safe("GoldenHit"),
	["MR"] = safe("MisterHit"),
	["Reaper"] = safe("ReaperHit"),
	["Replica"] = safe("ReplicaHit"),
	["Defense"] = safe("DefenseHit"),
	["Killstreak"] = safe("KSHit"),
	["Reverse"] = safe("ReverseHit"),
	["Shukuchi"] = safe("ShukuchiHit"),
	["Duelist"] = safe("DuelistHit"),
	["woah"] = safe("woahHit"),
	["Ice"] = safe("IceHit"),
	["Adios"] = safe("hitAdios"),
	["Blocked"] = safe("BlockedHit"),
	["Engineer"] = safe("engiehit"),
	["Rocky"] = safe("RockyHit"),
	["Conveyor"] = safe("ConvHit"),
	["STOP"] = safe("STOP"),
	["Phantom"] = safe("PhantomHit"),
	["Wormhole"] = safe("WormHit"),
	["Acrobat"] = safe("AcHit"),
	["Plague"] = safe("PlagueHit"),
	["[REDACTED]"] = safe("ReHit"),
	["bus"] = safe("hitbus"),
	["Phase"] = safe("PhaseH"),
	["Warp"] = safe("WarpHt"),
	["Bomb"] = safe("BombHit"),
	["Bubble"] = safe("BubbleHit"),
	["Jet"] = safe("JetHit"),
	["Shard"] = safe("ShardHIT"),
	["potato"] = safe("potatohit"),
	["CULT"] = safe("CULTHit"),
	["bob"] = safe("bobhit"),
	["Buddies"] = safe("buddiesHIT"),
	["Spy"] = safe("SpyHit"),
	["Detonator"] = safe("DetonatorHit"),
	["Rage"] = safe("GRRRR"),
	["Trap"] = safe("traphi"),
	["Orbit"] = safe("Orbihit"),
	["Hybrid"] = safe("HybridCLAP"),
	["Slapple"] = safe("SlappleHit"),
	["Disarm"] = safe("DisarmH"),
	["Dominance"] = safe("DominanceHit"),
	["Link"] = safe("LinkHit"),
	["Rojo"] = safe("RojoHit"),
	["rob"] = safe("robhit"),
	["Rhythm"] = safe("rhythmhit"),
	["Nightmare"] = safe("nightmarehit"),
	["Hitman"] = safe("HitmanHit"),
	["Thor"] = safe("ThorHit"),
	["Retro"] = safe("RetroHit"),
	["Cloud"] = safe("CloudHit"),
	["Null"] = safe("NullHit"),
	["spin"] = safe("spinhit"),
	["Pylon"] = safe("PylonHit"),
	["Leafblower"] = safe("LeafblowerHit"),
	------------------------------------------------
	["Poltergeist"] = safe("UTGHit"),
	["Clock"] = safe("UTGHit"),
	["Untitled Tag Glove"] = safe("UTGHit"),
	------------------------------------------------
	["Kinetic"] = safe("HtStun"),
	["Recall"] = safe("HtStun"),
	["Balloony"] = safe("HtStun"),
	["Sparky"] = safe("HtStun"),
	["Boogie"] = safe("HtStun"),
	["Stun"] = safe("HtStun"),
	["Coil"] = safe("HtStun"),
	------------------------------------------------
	["Diamond"] = safe("DiamondHit"),
	["Megarock"] = safe("DiamondHit"),
	------------------------------------------------
	["Moon"] = safe("CelestialHit"),
	["Jupiter"] = safe("CelestialHit"),
	------------------------------------------------
	["Mitten"] = safe("MittenHit"),
	["Hallow Jack"] = safe("HallowHIT"),
	------------------------------------------------
	["OVERKILL"] = safe("Overkillhit"),
	["The Flex"] = safe("FlexHit"),
	["Custom"] = safe("CustomHit"),
	["God's Hand"] = safe("Godshand"),
	["Error"] = safe("Errorhit"),
}
