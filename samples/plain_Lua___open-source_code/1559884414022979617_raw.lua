--R4D Revamp (Mostly For R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "R4D Revamp By M1zz",
            Text = "Subscribe To M1ZZ001",
            Duration = 5
        })
        wait(1)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Important Note:",
            Text = "This script only works for R15 avatar",
            Duration = 5
        }) 
        wait(5)
  
  game.StarterGui:SetCore("SendNotification", {
            Title = "INFO",
            Text = "This is the only official script that has no Client-Sided and all of it made by M1zz.",
            Duration = 20
        })
        game.StarterGui:SetCore("SendNotification", {
            Title = "WARNING",
            Text = "The script was published at [1/6/26]. If you see another similar script, mean it's a copy version (Skid)",
            Duration = 20
        })
        wait(5)
        game.StarterGui:SetCore("SendNotification", {
            Title = "HOW TO USE",
            Text = "Please click RE or Spawn Here before changing to other animation to avoid bug!",
            Duration = 20
        }) 
        wait(9)
   
game.StarterGui:SetCore("SendNotification", {
            Title = "R4D Revamp Executed",
            Text = "Enjoy trolling the server!!",
            Duration = 5
        })     

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "BigMenuGUI"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Get screen size
local screenSize = workspace.CurrentCamera.ViewportSize
local referenceWidth = 400 -- mobile width reference, adjust as needed

-- Scale factor based on reference
local scaleFactor = screenSize.X / referenceWidth

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.55, 0, 0.78, 0)
frame.Position = UDim2.new(0.225, 0, 0.11, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
frame.BackgroundTransparency = 1

-- Background Image
local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://14492716941"
bg.ZIndex = 0
bg.Parent = frame

-- Make frame content appear above background
for _, child in ipairs(frame:GetChildren()) do
    if child ~= bg then
        if child:IsA("GuiObject") then
            child.ZIndex = 1
        end
    end
end

Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 12)
----------------------------------------------------------------------
-- TITLE
----------------------------------------------------------------------
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "R4D Revamp"
title.TextScaled = false
title.TextSize = 24 -- previously maybe 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextStrokeTransparency = 0.2
title.TextStrokeColor3 = Color3.new(0, 0, 0)
title.Parent = frame

----------------------------------------------------------------------
-- Close Button
----------------------------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.TextScaled = false
closeBtn.TextWrapped = true
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextStrokeTransparency = 0.2
closeBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

----------------------------------------------------------------------
-- Minimize Button (Improved)
----------------------------------------------------------------------
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 40, 0, 20)
minimizeBtn.Position = UDim2.new(1, -390, 0, 5) -- next to close button
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Text = "-"
minimizeBtn.TextScaled = false
minimizeBtn.TextWrapped = true
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextStrokeTransparency = 0.2
minimizeBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = frame
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 8)

-- Circle Button to restore GUI (initially hidden)
local restoreBtn = Instance.new("ImageButton")
restoreBtn.Size = UDim2.new(0, 60, 0, 60)
restoreBtn.Position = UDim2.new(0, 20, 1, -80)
restoreBtn.BackgroundTransparency = 1
restoreBtn.Image = "rbxassetid://15273265681"
restoreBtn.Visible = false
restoreBtn.Parent = gui
restoreBtn.Active = true
restoreBtn.Draggable = true

Instance.new("UICorner", restoreBtn).CornerRadius = UDim.new(1, 0)

-- Minimize Logic
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = true
    -- Hide frame contents except title and buttons
    frame.Visible = false
    restoreBtn.Visible = true
end)

-- Restore Logic
restoreBtn.MouseButton1Click:Connect(function()
    minimized = false
    frame.Visible = true
    restoreBtn.Visible = false
end)


----------------------------------------------------------------------
-- respawn Button (Improved)
----------------------------------------------------------------------
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(0, 40, 0, 20)
respawnBtn.Position = UDim2.new(1, -390, 0, 30) -- next to close button
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
respawnBtn.Text = "RE"
respawnBtn.TextScaled = false
respawnBtn.TextWrapped = true
respawnBtn.TextSize = 18
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.TextStrokeTransparency = 0.2
respawnBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.Parent = frame
Instance.new("UICorner", respawnBtn).CornerRadius = UDim.new(0, 8)

respawnBtn.MouseButton1Click:Connect(function()

game.Players.LocalPlayer.Character.Humanoid.Health = 0

end)

----------------------------------------------------------------------
-- StopAnim Button (Improved)
----------------------------------------------------------------------

local StopAnimBtn = Instance.new("TextButton")
StopAnimBtn.Size = UDim2.new(0, 60, 0, 45)
StopAnimBtn.Position = UDim2.new(1, -340, 0, 5) -- next to close button
StopAnimBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
StopAnimBtn.Text = "Spawn Here"
StopAnimBtn.TextScaled = false
StopAnimBtn.TextWrapped = true
StopAnimBtn.TextSize = 18
StopAnimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopAnimBtn.BackgroundTransparency = 0
StopAnimBtn.Font = Enum.Font.GothamBold
StopAnimBtn.TextStrokeTransparency = 0.2
StopAnimBtn.TextStrokeColor3 = Color3.new(0, 0, 0)
StopAnimBtn.Parent = frame
Instance.new("UICorner", StopAnimBtn).CornerRadius = UDim.new(0, 10)


StopAnimBtn.MouseButton1Click:Connect(function()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait for character
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local respawnPosition = hrp.Position

-- Flag to ensure it runs only once
local hasRespawned = false

-- Function to teleport character after respawn
local function onCharacterAdded(char)
	if hasRespawned then return end -- stop if already ran
	hasRespawned = true

	local hrpNew = char:WaitForChild("HumanoidRootPart")
	task.wait(0.1) -- small delay to ensure character loaded
	hrpNew.CFrame = CFrame.new(respawnPosition)
end

-- Connect to CharacterAdded (will only run once due to flag)
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

-- Teleport current character now (optional)
hrp.CFrame = CFrame.new(respawnPosition)

wait(0.3)

game.Players.LocalPlayer.Character.Humanoid.Health = 0

game.StarterGui:SetCore("SendNotification", {
            Title = "You're back to normal",
            Text = "Run this again to stop the animation script",
            Duration = 5
        })

end)


----------------------------------------------------------------------
-- BUTTON CREATOR FUNCTION (WITH OUTLINE)
----------------------------------------------------------------------
local function makeButton(holder, name, onClick)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextScaled = false
    b.TextWrapped = true
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.TextStrokeTransparency = 0.2
    b.TextStrokeColor3 = Color3.new(0, 0, 0)
    b.BackgroundTransparency = 0.5
    b.Parent = holder

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)

    b.MouseButton1Click:Connect(onClick)
end

----------------------------------------------------------------------
-- PAGE 1
----------------------------------------------------------------------
local page1 = Instance.new("Frame")
page1.Size = UDim2.new(1, -20, 1, -140)
page1.Position = UDim2.new(0, 10, 0, 70)
page1.BackgroundTransparency = 1
page1.Parent = frame

local grid1 = Instance.new("UIGridLayout")
grid1.Parent = page1
grid1.CellSize = UDim2.new(0.29, 0, 0.30, 0)
grid1.CellPadding = UDim2.new(0, 18, 0, 10)





----------------------------------------------------------------------
-- PAGE 2
----------------------------------------------------------------------
local page2 = Instance.new("Frame")
page2.Size = UDim2.new(1, -20, 1, -140)
page2.Position = UDim2.new(0, 10, 0, 70)
page2.BackgroundTransparency = 1
page2.Visible = false
page2.Parent = frame

local grid2 = Instance.new("UIGridLayout")
grid2.Parent = page2
grid2.CellSize = grid1.CellSize
grid2.CellPadding = grid1.CellPadding

----------------------------------------------------------------------
-- PAGE 1 BUTTONS
----------------------------------------------------------------------
makeButton(page1, "SkinWalker", function() 


--FE Skinwalker Animation (R15 only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Skinwalker Animation",
            Text = "By M1zz",
            Duration = 5
        })
        
local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://101313638439249"
character.idle.Animation2.AnimationId = "rbxassetid://74150244741613"
character.run.RunAnim.AnimationId = "rbxassetid://134411626334329"
character.fall.FallAnim.AnimationId = "rbxassetid://96065281687711"
character.jump.JumpAnim.AnimationId = "rbxassetid://100296272663282"
character.walk.WalkAnim.AnimationId = "rbxassetid://113771589189795"


 end)
makeButton(page1, "Dog Pet", function() 


--FE Dog Pet (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "Dog Pet By M1zz",
            Text = "Click Your Target Player To Be Their Pet",
            Duration = 5
        })
  wait(0.7)

 
      


local character = game.Players.LocalPlayer.Character.Animate
local anim = "rbxassetid://133747057485171"
character.idle.Animation1.AnimationId = anim
character.idle.Animation2.AnimationId = anim
character.run.RunAnim.AnimationId = anim
character.fall.FallAnim.AnimationId = anim
character.jump.JumpAnim.AnimationId = anim
character.walk.WalkAnim.AnimationId = anim




--anti seat
-- Get all seats in the workspace
local seats = workspace:GetDescendants()

-- Loop through each seat and disable sitting
for _, seat in ipairs(seats) do
    if seat:IsA("Seat") then
        seat.Disabled = true
    end
end



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Dog Poop"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://93131142784071"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Dog Pee"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://121179940665683"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)






local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local distance = 3 -- distance to the right side
local targetPlayer = nil -- the player we will follow

-- Function to get player from clicked part
local function getPlayerFromPart(part)
	for _, player in pairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

-- Detect mouse click
local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
	local clickedPart = mouse.Target
	if clickedPart then
		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
			
		end
	end
end)

-- Main loop
while true do
	task.wait(0)

	local char = LocalPlayer.Character
	if not char then break end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")

	-- Stop the entire script if health is 0
	if not humanoid or humanoid.Health <= 0 then
		
		break
	end

	if not targetPlayer then
		continue
	end

	local targetChar = targetPlayer.Character
	local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

	if hrp and targetHRP then
		-- Teleport to right side
		local rightSide = targetHRP.CFrame.RightVector * distance
		local newPosition = targetHRP.Position + rightSide

		-- Face same direction as target
		local lookVector = targetHRP.CFrame.LookVector
		hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
	end
end


end)
makeButton(page1, "Hand", function() 

--FE Hand Animation (R15 only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "Hand Animation",
            Text = "By M1zz",
            Duration = 5
        })
  wait(0.7)

local character = game.Players.LocalPlayer.Character.Animate

character.run.RunAnim.AnimationId = "rbxassetid://100507265690062"
character.fall.FallAnim.AnimationId = "rbxassetid://77423395801230"
character.jump.JumpAnim.AnimationId = "rbxassetid://77423395801230"
character.walk.WalkAnim.AnimationId = "rbxassetid://77423395801230"


--Tools
local Players = game:GetService("Players")

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- Create the tool
local tool = Instance.new("Tool")
tool.Name = "Wave"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "ComeHere"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Point"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Flick"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Countdown"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "PointMe"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Mog"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Think"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Gun"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Peace"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Stop"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Okay"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "TapTap"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "HoldHead"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "No"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Come"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Yes"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Crack"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "Dislike"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "L"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory


local tool = Instance.new("Tool")
tool.Name = "PewPew"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory















while wait() do
if game.Players.LocalPlayer.Character:FindFirstChild("Wave") then






local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://98597361490597"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end









game.Players.LocalPlayer.Character.Wave.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("ComeHere") then




local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://127772514180203"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end



game.Players.LocalPlayer.Character.ComeHere.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Point") then




local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://71439424797320"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end



game.Players.LocalPlayer.Character.Point.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Flick") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://101257641633204"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Flick.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Countdown") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://84575029867002"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Countdown.Parent = game.Players.LocalPlayer.Backpack
end



--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("PointMe") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://84761602683884"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.PointMe.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Mog") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://115287134215807"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Mog.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Think") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://121922614712085"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Think.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Gun") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://136067415498039"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Gun.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Peace") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://72361092556872"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Peace.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Stop") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://106930634237455"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Stop.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Okay") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://100188963456227"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Okay.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("TapTap") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://85296908224241"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.TapTap.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("HoldHead") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://77423395801230"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.HoldHead.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("No") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://88992279344579"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.No.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Come") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://113332847507078"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Come.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Yes") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://81100102810594"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Yes.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Crack") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://103472552102409"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Crack.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("Dislike") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://100051979566134"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.Dislike.Parent = game.Players.LocalPlayer.Backpack
end

--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("L") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://117914592030402"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.L.Parent = game.Players.LocalPlayer.Backpack
end


--other anim
if game.Players.LocalPlayer.Character:FindFirstChild("PewPew") then







local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- Create animation object
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://118281921224513"

    local animTrack = humanoid:LoadAnimation(animation)
    animTrack.Looped = false  -- not looping
    animTrack:Play()


end

-- Run for current character
if player.Character then
    setupCharacter(player.Character)
end










game.Players.LocalPlayer.Character.PewPew.Parent = game.Players.LocalPlayer.Backpack
end
















end






end)

makeButton(page1, "Skateboard", function() 


--FE Skateboard (R15 Only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "FE Skateboard",
            Text = "By M1zz",
            Duration = 5
        })
  wait(0.7)


local character = game.Players.LocalPlayer.Character.Animate
character.idle.Animation1.AnimationId = "rbxassetid://83956594100523"
character.idle.Animation2.AnimationId = "rbxassetid://83956594100523"
character.run.RunAnim.AnimationId = "rbxassetid://134477281157921"
character.fall.FallAnim.AnimationId = "rbxassetid://83956594100523"
character.jump.JumpAnim.AnimationId = "rbxassetid://118195543877197"
character.walk.WalkAnim.AnimationId = "rbxassetid://87539783248084"
while wait() do
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 28
end

end)
makeButton(page1, "Gun", function() 


--FE Gun (R15 Only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "FE Gun",
            Text = "By M1zz",
            Duration = 5
        })
      wait(0.7)
game.StarterGui:SetCore("SendNotification", {
            Title = "How To Use Crouch",
            Text = "Click the screen and walk to activate or deactive crouch",
            Duration = 5
        })  
        
  wait(0.7)
  




local character = game.Players.LocalPlayer.Character.Animate
character.walk.WalkAnim.AnimationId = "rbxassetid://76218502453864"
character.idle.Animation1.AnimationId = "rbxassetid://124945107987244"
character.idle.Animation2.AnimationId = "rbxassetid://124945107987244"


local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")


local tool = Instance.new("Tool")
tool.Name = "MachineGun"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

local toolA = Instance.new("Tool")
toolA.Name = "Crouch"          -- Name of the tool
toolA.RequiresHandle = false   -- Set true if you want to create a handle
toolA.Parent = backpack        -- Put the tool in the player's inventory

local tool = Instance.new("Tool")
tool.Name = "Pistol"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

local tool = Instance.new("Tool")
tool.Name = "Cannon"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

local tool = Instance.new("Tool")
tool.Name = "MiniGun"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

local tool = Instance.new("Tool")
tool.Name = "Pistol 1"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

while wait(0) do

if game.Players.LocalPlayer.Character:FindFirstChild("MachineGun") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://128215887189003"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character.MachineGun.Parent = game.Players.LocalPlayer.Backpack
end



if game.Players.LocalPlayer.Character:FindFirstChild("Crouch") then

  
-- Track clicks
local clickState = true  -- true = first click, false = second click

-- When the toolA is activated
toolA.Activated:Connect(function()
    if clickState then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 4
        
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    clickState = not clickState  -- Toggle for next click
end)


end


if game.Players.LocalPlayer.Character:FindFirstChild("Pistol") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://130630299166448"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character.Pistol.Parent = game.Players.LocalPlayer.Backpack
end



if game.Players.LocalPlayer.Character:FindFirstChild("Cannon") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://90413001543472"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character.Cannon.Parent = game.Players.LocalPlayer.Backpack
end


if game.Players.LocalPlayer.Character:FindFirstChild("MiniGun") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://93641407208157"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character.MiniGun.Parent = game.Players.LocalPlayer.Backpack
end



if game.Players.LocalPlayer.Character:FindFirstChild("Pistol 1") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://121573002971812"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character["Pistol 1"].Parent = game.Players.LocalPlayer.Backpack
end




end



end)

makeButton(page1, "Ability", function() 


--FE Ability (R15 Only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "FE Ability By M1zz",
            Text = "Click On Your Target To Explode Them",
            Duration = 5
        })
      wait(0.7)
      
      

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")


local tool = Instance.new("Tool")
tool.Name = "Ability"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

while wait() do
if game.Players.LocalPlayer.Character:FindFirstChild("Ability") then










local character = game.Players.LocalPlayer.Character.Animate
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 80
character.idle.Animation1.AnimationId = "rbxassetid://104661366039084"
character.idle.Animation2.AnimationId = "rbxassetid://104661366039084"
character.run.RunAnim.AnimationId = "rbxassetid://116700088132671"


-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")



mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if not target then return end

    -- Check if clicking a player's character part
    local targetPlayer = game.Players:GetPlayerFromCharacter(target.Parent)
    if not targetPlayer then return end

    

    local targetChar = targetPlayer.Character
    if not targetChar then return end

    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return end

    -- Get the target player’s position
    local destination = targetHRP.Position

    -- Move your character there
    humanoid:MoveTo(destination)

    -- Detect arrival
    humanoid.MoveToFinished:Wait()
    
    
    
    
    local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")


-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://128571804273400"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

playNonLoopAnimation()
   


--FE Spin Character or Any unanchored part
 
local Spin = Instance.new("BodyAngularVelocity")
        Spin.AngularVelocity = Vector3.new(0, 50, 0) -- Change the velocity as per your requirement. Change it to this ( 0, 10000, 0) to make it stronger 
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.P = 0
        Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        
  

 
    wait(0.5)
game.Players.LocalPlayer.Character.Humanoid.Health = 0  
    

end)







local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local movingSize = Vector3.new(1.8200000524520874, 6, 0.9599999785423279)
local stoppedSize = Vector3.new(1.8200000524520874, 1.9800000190734863, 0.9599999785423279)

local lastState = nil  -- "moving" or "stopped"

game:GetService("RunService").Heartbeat:Connect(function()
    if humanoid.MoveDirection.Magnitude > 0 then
        -- MOVING
        if lastState ~= "moving" then
        game.Players.LocalPlayer.Character.Humanoid.Jump = true    
            hrp.Size = movingSize       
       
            
            lastState = "moving"
        end
    else
        -- STOPPED
        if lastState ~= "stopped" then
            hrp.Size = stoppedSize
            lastState = "stopped"
        end
    end
end)




end
end



end)
makeButton(page1, "AmongUs", function() 


--FE AmongUs (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE AmongUs",
            Text = "By M1zz",
            Duration = 5
        })
        
local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://77417071930329"
character.idle.Animation2.AnimationId = "rbxassetid://77417071930329"
character.run.RunAnim.AnimationId = "rbxassetid://138144795738441"
character.fall.FallAnim.AnimationId = "rbxassetid://77417071930329"
character.jump.JumpAnim.AnimationId = "rbxassetid://77417071930329"
character.walk.WalkAnim.AnimationId = "rbxassetid://138144795738441"


end)
makeButton(page1, "Boxing", function() 


-- FE Boxing (R15 Only)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
	Title = "FE Boxing",
	Text = "By M1zz",
	Duration = 5
})
wait(0.7)
game.StarterGui:SetCore("SendNotification", {
	Title = "Note:",
	Text = "This Script Is Only Animation For Trolling",
	Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Apply custom animation IDs
local animate = LocalPlayer.Character:WaitForChild("Animate")

animate.idle.Animation1.AnimationId = "rbxassetid://80933111363555"
animate.idle.Animation2.AnimationId = "rbxassetid://80291024825993"
animate.run.RunAnim.AnimationId = "rbxassetid://137223234687220"
animate.fall.FallAnim.AnimationId = "rbxassetid://112472797825991"
animate.jump.JumpAnim.AnimationId = "rbxassetid://131814798893284"
animate.walk.WalkAnim.AnimationId = "rbxassetid://137223234687220"

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Dodge"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://126292183414189"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local tool = Instance.new("Tool")
tool.Name = "Combo1"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://70735660905476"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local tool = Instance.new("Tool")
tool.Name = "Combo2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://104962316700738"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local tool = Instance.new("Tool")
tool.Name = "Combo3"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://131281898392347"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local tool = Instance.new("Tool")
tool.Name = "KO"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://131954676419182"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)




end)
makeButton(page1, "Bike", function() 


-- FE Bike (R15 Only)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Bike By M1zz",
    Text = "Hold Jump To Wheelie",
    Duration = 5
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
humanoid.JumpHeight = 0.1
humanoid.JumpPower = 0.1
local RunService = game:GetService("RunService")

-- ===== Animation =====
local walkAnimId = "rbxassetid://104810105184118"
local walkAnimation = Instance.new("Animation")
walkAnimation.AnimationId = walkAnimId

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local walkTrack = animator:LoadAnimation(walkAnimation)
walkTrack.Looped = true

local moving = false

-- ===== Slippery Movement =====
local slideFactor = 0.99
local velocity = Vector3.new(0,0,0)

-- ===== Gyro =====
local gyro = nil

RunService.RenderStepped:Connect(function(deltaTime)
    -- ===== Animation =====
    local isMoving = humanoid.MoveDirection.Magnitude > 0

    if isMoving then
        if not moving then
            moving = true
            walkTrack:Play()
            walkTrack:AdjustSpeed(1)
        end
    else
        if moving then
            moving = false
            walkTrack:AdjustSpeed(0)
        end
    end

    -- ===== Slippery Movement =====
    local moveDir = humanoid.MoveDirection
    if humanoid.FloorMaterial == Enum.Material.Air then
        velocity = Vector3.new(0, velocity.Y, 0)
    else
        if moveDir.Magnitude > 0 then
            velocity = velocity + moveDir * 50 * deltaTime
        end
        velocity = velocity * slideFactor
    end

    -- ===== Apply velocity =====
    root.Velocity = Vector3.new(
        velocity.X,
        root.Velocity.Y,
        velocity.Z
    )

    -- ===== Gyro for looking up while jumping =====
    if humanoid.Jump then
        if not gyro then
            gyro = Instance.new("BodyGyro")
            gyro.P = 100000
            gyro.D = 1000
            gyro.MaxTorque = Vector3.new(400000, 400000, 400000)
            gyro.Parent = root
        end

        local lookVector = root.CFrame.LookVector
        local horizontalDir = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
        local targetCFrame = CFrame.new(root.Position, root.Position + horizontalDir + Vector3.new(0,1,0))
        gyro.CFrame = targetCFrame
    else
        if gyro then
            gyro:Destroy()
            gyro = nil
        end
    end
end)


end)
----------------------------------------------------------------------
-- PAGE 2 BUTTONS
----------------------------------------------------------------------
makeButton(page2, "R6", function() 


--FE R6 Animation (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE R6 Animation",
            Text = "By M1zz",
            Duration = 5
        })

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://117477745082587"
character.idle.Animation2.AnimationId = "rbxassetid://117477745082587"
character.run.RunAnim.AnimationId = "rbxassetid://80536599755423"
character.fall.FallAnim.AnimationId = "rbxassetid://117477745082587"
character.jump.JumpAnim.AnimationId = "rbxassetid://139390570947836"
character.walk.WalkAnim.AnimationId = "rbxassetid://80536599755423"
character.sit.SitAnim.AnimationId = "rbxassetid://120346453217498"
character.climb.ClimbAnim.AnimationId = "rbxassetid://121075390792786"


end)

makeButton(page2, "Mini", function() 


--FE Mini (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Mini",
            Text = "By M1zz",
            Duration = 5
        })

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://111913275466363"
character.idle.Animation2.AnimationId = "rbxassetid://111913275466363"
character.run.RunAnim.AnimationId = "rbxassetid://85887415033585"
character.fall.FallAnim.AnimationId = "rbxassetid://125514787503600"
character.jump.JumpAnim.AnimationId = "rbxassetid://125514787503600"
character.walk.WalkAnim.AnimationId = "rbxassetid://139646149622620"
character.sit.SitAnim.AnimationId = "rbxassetid://111913275466363"
character.climb.ClimbAnim.AnimationId = "rbxassetid://111913275466363"


local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")


local tool = Instance.new("Tool")
tool.Name = "Emote"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory
wait(0)

while wait() do

if game.Players.LocalPlayer.Character:FindFirstChild("Emote") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://84098043349665"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
	game.Players.LocalPlayer.Character.Humanoid.Jump = true
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character["Emote"].Parent = game.Players.LocalPlayer.Backpack
end
end





end)
makeButton(page2, "Typing Animation", function() 


--FE Typing Animation (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Typing Animation By M1zz",
            Text = "This script run typing and talking animation when you chat",
            Duration = 5
        })
        

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local currentTrack = nil
local afterTrack = nil  -- second animation

-- Play first animation (typing)
local function playTypingAnimation(character)
    local humanoid = character:WaitForChild("Humanoid")

    -- First animation
    local anim1 = Instance.new("Animation")
    anim1.AnimationId = "rbxassetid://121518911792575"

    currentTrack = humanoid:LoadAnimation(anim1)
    currentTrack.Looped = true
    currentTrack:Play()

    humanoid.HealthChanged:Connect(function(hp)
        if hp <= 0 then
            if currentTrack then currentTrack:Stop() end
            if afterTrack then afterTrack:Stop() end
        end
    end)
end

-- Play second animation after typing stops
local function playAfterAnimation(character)
    local humanoid = character:WaitForChild("Humanoid")

    local anim2 = Instance.new("Animation")
    anim2.AnimationId = "rbxassetid://102660197471249"

    afterTrack = humanoid:LoadAnimation(anim2)
    afterTrack.Looped = false
    afterTrack:Play()
end

-- When you start typing
UserInputService.TextBoxFocused:Connect(function(textBox)
    local character = player.Character or player.CharacterAdded:Wait()
    playTypingAnimation(character)
end)

-- When you stop typing
UserInputService.TextBoxFocusReleased:Connect(function(textBox)
    -- stop typing animation
    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end

    -- play the second animation
    local character = player.Character or player.CharacterAdded:Wait()
    playAfterAnimation(character)
end)


end)
makeButton(page2, "Creeper", function() 


--FE Creeper (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Creeper",
            Text = "By M1zz",
            Duration = 5
        })

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://78550920924133"
character.idle.Animation2.AnimationId = "rbxassetid://78550920924133"
character.run.RunAnim.AnimationId = "rbxassetid://114687548971893"
character.fall.FallAnim.AnimationId = "rbxassetid://78550920924133"
character.jump.JumpAnim.AnimationId = "rbxassetid://109631104232250"
character.walk.WalkAnim.AnimationId = "rbxassetid://114687548971893"
character.sit.SitAnim.AnimationId = "rbxassetid://78550920924133"
character.climb.ClimbAnim.AnimationId = "rbxassetid://109631104232250"

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local tool = Instance.new("Tool")
tool.Name = "Explode"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory



while wait(0) do

if game.Players.LocalPlayer.Character:FindFirstChild("Explode") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://128571804273400"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation() 

--FE Spin Character or Any unanchored part
 
local Spin = Instance.new("BodyAngularVelocity")
        Spin.AngularVelocity = Vector3.new(0, 45, 0) -- Change the velocity as per your requirement. Change it to this ( 0, 10000, 0) to make it stronger 
        Spin.MaxTorque = Vector3.new(0, math.huge, 0)
        Spin.P = 0
        Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
        
wait(0.2)
game.Players.LocalPlayer.Character.Humanoid.Health = 0


game.Players.LocalPlayer.Character.Explode.Parent = game.Players.LocalPlayer.Backpack
end
end







end)

makeButton(page2, "D1ck", function() 


--FE D1ck (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE D1ck By M1zz",
            Text = "Click Your Target Player To Annoy",
            Duration = 5
        })


local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://108716025720327"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = true                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()







local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local distance = 3 -- distance to the right side
local targetPlayer = nil -- the player we will follow

-- Function to get player from clicked part
local function getPlayerFromPart(part)
	for _, player in pairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

-- Detect mouse click
local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
	local clickedPart = mouse.Target
	if clickedPart then
		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
			
		end
	end
end)

-- Main loop
while true do
	task.wait(0.1)

	local char = LocalPlayer.Character
	if not char then break end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")

	-- Stop the entire script if health is 0
	if not humanoid or humanoid.Health <= 0 then
		
		break
	end

	if not targetPlayer then
		continue
	end

	local targetChar = targetPlayer.Character
	local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

	if hrp and targetHRP then
		-- Teleport to right side
		local rightSide = targetHRP.CFrame.RightVector * distance
		local newPosition = targetHRP.Position + rightSide

		-- Face same direction as target
		local lookVector = targetHRP.CFrame.LookVector
		hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
	end
end


end)
makeButton(page2, "Claw Machine", function() 


--FE Claw Machine (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Claw Machine By M1zz",
            Text = "You can ask friends how much round do they want!",
            Duration = 5
        })



local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local PlayerGui = player:WaitForChild("PlayerGui")

-- Stop all animations
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

-- Play a non-looping animation
local function playNonLoopAnimation(animId)
	stopAllAnimations()
	
	local anim = Instance.new("Animation")
	anim.AnimationId = animId
	
	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action
	track.Looped = false
	track:Play()
end

-- Animation IDs
local anim1 = "rbxassetid://107632385284907"  -- 40% chance
local anim2 = "rbxassetid://132977320303492"  -- 60% chance
local anim3 = "rbxassetid://92919618563502"   -- winner animation

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimationRepeaterGui"
screenGui.ResetOnSpawn = true
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0, 200, 0, 50)
textbox.Position = UDim2.new(0.5, -100, 0.5, -25)
textbox.PlaceholderText = "Enter Play Rounds"
textbox.ClearTextOnFocus = true
textbox.Text = ""
textbox.Parent = frame
textbox.TextScaled = false
textbox.TextColor3 = Color3.new(1,1,1)
textbox.BackgroundColor3 = Color3.fromRGB(30,30,30)

textbox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local repeatCount = tonumber(textbox.Text) or 3 -- default 3 if invalid
		
		-- Close GUI
		screenGui:Destroy()
		
		-- Run animation loop
		for i = 1, repeatCount do
			local chance = math.random()
			if chance <= 0.8 then
				playNonLoopAnimation(anim1)
			wait(4)	
				game.StarterGui:SetCore("SendNotification", {
            Title = "Better Luck Next Time",
            Text = "It Missed!",
            Duration = 5
        })
        
			else
				playNonLoopAnimation(anim2)
				wait(7)
				playNonLoopAnimation(anim3)
				
				game.StarterGui:SetCore("SendNotification", {
            Title = "Congratulations!!",
            Text = "It Scored!",
            Duration = 5
        })
        
        
			end
			wait(5.7)
		end
		wait(1.5)
		game.StarterGui:SetCore("SendNotification", {
            Title = "Round Ended",
            Text = "Run the script again to Play!",
            Duration = 5
        })
	end
end)


end)
makeButton(page2, "Sliding", function() 


--FE Sliding (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Sliding By M1zz",
            Text = "Jump To Slide ",
            Duration = 5
        })


local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local sliding = false
local slideForce = 80
local slideDuration = 0.35

-- LOWER JUMP HEIGHT
humanoid.JumpPower = 30  -- change if needed

-- Animation A (first jump)
local animA = Instance.new("Animation")
animA.AnimationId = "rbxassetid://104930844061263"
local slideAnimA = humanoid:LoadAnimation(animA)

-- Animation B (second jump)
local animB = Instance.new("Animation")
animB.AnimationId = "rbxassetid://120943636070660"
local slideAnimB = humanoid:LoadAnimation(animB)

local jumpCounter = 0  -- this determines which animation to play

-- SLIDE FUNCTION
local function DoSlide(useAnim)
	if sliding then return end
	sliding = true

	-- Play the correct animation
	useAnim.Looped = false
	useAnim:Play()

	-- Forward push
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5, 0, 1e5)
	bv.Velocity = hrp.CFrame.LookVector * slideForce
	bv.Parent = hrp

	task.wait(slideDuration)

	bv:Destroy()
	useAnim:Stop()

	sliding = false
end

-- TRIGGER SLIDE ON JUMP
humanoid.StateChanged:Connect(function(oldState, newState)
	if newState == Enum.HumanoidStateType.Jumping then
		jumpCounter += 1

		-- Alternate between animations
		if jumpCounter % 2 == 1 then
			-- Odd number jump → Animation A
			DoSlide(slideAnimA)
		else
			-- Even number jump → Animation B
			DoSlide(slideAnimB)
		end
	end
end)


end)
makeButton(page2, "S3x", function() 

--FE S3x (R15 Only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "FE S3x By M1zz",
            Text = "Equip the tool and click the target player",
            Duration = 5
        })


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Bang"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 110530163322341
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Blow"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 117394346715743
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 7, 2) 	
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 1, 2) 
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("Head")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Back"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 98060101392274
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
				
				
		




				
				
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
		
		
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Kiss"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 75952996363038
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Wide Open"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 107168210393534
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Rub It"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.3 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 86932939420438
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind + a little left of the target
local behindOffset = -targetHRP.CFrame.LookVector * distance
local leftOffset = -targetHRP.CFrame.RightVector * -1 -- adjust 0.7 for more/less left
local newPosition = targetHRP.Position + behindOffset + leftOffset

-- Look behind target
local lookVector = -targetHRP.CFrame.LookVector
hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Skill"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 0 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 88421489929073
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Rubbing Balloon"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1.8 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 105922316873728
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Bang 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 71181096783746
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Bang 3"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 80720157509285
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Bang 4"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 129714976763545
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Back 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 127440207831178
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Back 3"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 105422753069554
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Front"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 72271659135409
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Showing Off"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -3 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 128156281604243
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
				
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- ðŸ”¥ Stop teleport animation when tool is unequipped
	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		-- Stop script if health is 0
		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Rubbing"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 124575754112740
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local leftOffset = -targetHRP.CFrame.RightVector * -1.5 -- adjust amount if needed
local newPosition = targetHRP.Position + behindOffset + leftOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Blow 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 89973918892326
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	

	local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
	teleportTrack = humanoid:LoadAnimation(teleportAnim)

	-- Enable selecting target by clicking
	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		
		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 7, 2) 	
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
	

	-- Stop teleport animation
	if teleportTrack then
		teleportTrack:Stop()
		game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 1, 2) 
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")

		if not humanoid or humanoid.Health <= 0 then
			
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("Head")

		if hrp and targetHRP then

			-- Play teleport animation
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- ðŸ”¥ Make character look BEHIND (180Â° rotated)
			local lookVector = -targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Back 4"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 79023341358014
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local humanoid = nil

------------------------------------------------------
-- Stop all other animations
------------------------------------------------------
local function stopOtherAnimations(allowedTrack)
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	if not animator then return end

	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
		if track ~= allowedTrack then
			track:Stop(0)
		end
	end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	teleportTrack = humanoid:LoadAnimation(teleportAnim)
	teleportTrack.Priority = Enum.AnimationPriority.Action4
	teleportTrack.Looped = true

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end

		local clickedPart = mouse.Target
		if clickedPart then
			local player = getPlayerFromPart(clickedPart)
			if player and player ~= LocalPlayer then
				targetPlayer = player
			end
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil

	if teleportTrack then
		teleportTrack:Stop()
	end
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		RunService.Heartbeat:Wait()

		if not isEquipped then
			continue
		end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or humanoid.Health <= 0 then
			break
		end

		if not targetPlayer then
			continue
		end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

		if hrp and targetHRP then
			-- Play teleport animation and stop others
			if teleportTrack and not teleportTrack.IsPlaying then
				teleportTrack:Play()
				stopOtherAnimations(teleportTrack)
			end

			-- Position behind target
			local behindOffset = -targetHRP.CFrame.LookVector * distance
			local newPosition = targetHRP.Position + behindOffset

			-- Match direction
			local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
		end
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "With Head"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil
local loopConnection = nil

-- CONFIG (adjust if needed)
local START_PERCENT = 0.35  -- skip first 25%
local END_PERCENT = 0.55    -- stop at 75%

local function stopAnimation()
	if loopConnection then
		loopConnection:Disconnect()
		loopConnection = nil
	end

	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playMiddleAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://129855408889885"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play(0, 1, 1)

	-- Wait until animation length is known
	task.wait()

	local length = currentTrack.Length
	local startTime = length * START_PERCENT
	local endTime = length * END_PERCENT

	-- Jump to middle start
	currentTrack.TimePosition = startTime

	-- Loop ONLY the middle part
	loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if currentTrack and currentTrack.TimePosition >= endTime then
			currentTrack.TimePosition = startTime
		end
	end)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playMiddleAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Jerk"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil
local loopConnection = nil

-- CONFIG (adjust if needed)
local START_PERCENT = 0.35  -- skip first 25%
local END_PERCENT = 0.55    -- stop at 75%

local function stopAnimation()
	if loopConnection then
		loopConnection:Disconnect()
		loopConnection = nil
	end

	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playMiddleAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://119011837964923"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play(0, 1, 1)

	-- Wait until animation length is known
	task.wait()

	local length = currentTrack.Length
	local startTime = length * START_PERCENT
	local endTime = length * END_PERCENT

	-- Jump to middle start
	currentTrack.TimePosition = startTime

	-- Loop ONLY the middle part
	loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if currentTrack and currentTrack.TimePosition >= endTime then
			currentTrack.TimePosition = startTime
		end
	end)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playMiddleAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Head Sucking"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil
local loopConnection = nil

-- CONFIG (adjust if needed)
local START_PERCENT = 0.35  -- skip first 25%
local END_PERCENT = 0.55    -- stop at 75%

local function stopAnimation()
	if loopConnection then
		loopConnection:Disconnect()
		loopConnection = nil
	end

	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playMiddleAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://134495273550845"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play(0, 1, 1)

	-- Wait until animation length is known
	task.wait()

	local length = currentTrack.Length
	local startTime = length * START_PERCENT
	local endTime = length * END_PERCENT

	-- Jump to middle start
	currentTrack.TimePosition = startTime

	-- Loop ONLY the middle part
	loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if currentTrack and currentTrack.TimePosition >= endTime then
			currentTrack.TimePosition = startTime
		end
	end)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playMiddleAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)


    


end)
makeButton(page2, "Drift", function() 

--FE Drift (R15 Only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "FE Drift By M1zz",
            Text = "Hold Jump To Brake",
            Duration = 5
        })


-- Set jump height
game.Players.LocalPlayer.Character.Humanoid.JumpHeight = 1

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Animation IDs
local walkAnimId = "rbxassetid://90183548743095"
local idleAnimId = "rbxassetid://80088593607612"

-- Create animations
local walkAnimation = Instance.new("Animation")
walkAnimation.AnimationId = walkAnimId
local idleAnimation = Instance.new("Animation")
idleAnimation.AnimationId = idleAnimId

-- Ensure humanoid has an Animator
local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

-- Load animation tracks
local walkTrack = animator:LoadAnimation(walkAnimation)
walkTrack.Looped = true

local idleTrack = animator:LoadAnimation(idleAnimation)
idleTrack.Looped = true

-- Track animation state
local moving = false

-- Slippery movement variables
local slideFactor = 1 -- 1 = very slippery
local velocity = Vector3.new(0,0,0)

RunService.RenderStepped:Connect(function(deltaTime)
    -- --- Animation ---
    local isMoving = humanoid.MoveDirection.Magnitude > 0
    if isMoving and not moving then
        moving = true
        if idleTrack.IsPlaying then idleTrack:Stop() end
        walkTrack:Play()
    elseif not isMoving and moving then
        moving = false
        if walkTrack.IsPlaying then walkTrack:Stop() end
        idleTrack:Play()
    end

    -- --- Slippery Movement ---
    -- Stop horizontal movement if jumping
    if humanoid.FloorMaterial == Enum.Material.Air then
        velocity = Vector3.new(0, velocity.Y, 0)
    else
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            velocity = velocity + moveDir * 50 * deltaTime -- acceleration
        end
        velocity = velocity * slideFactor -- apply friction
    end

    -- Apply velocity while keeping vertical movement
    humanoidRootPart.Velocity = Vector3.new(velocity.X, humanoidRootPart.Velocity.Y, velocity.Z)
end)


end)

----------------------------------------------------------------------
-- PAGE 3
----------------------------------------------------------------------
local page3 = Instance.new("Frame")
page3.Size = UDim2.new(1, -20, 1, -140)
page3.Position = UDim2.new(0, 10, 0, 70)
page3.BackgroundTransparency = 1
page3.Visible = false
page3.Parent = frame

local grid3 = Instance.new("UIGridLayout")
grid3.Parent = page3
grid3.CellSize = grid1.CellSize
grid3.CellPadding = grid1.CellPadding

----------------------------------------------------------------------
-- PAGE 3 BUTTONS (8 buttons)
----------------------------------------------------------------------
makeButton(page3, "High Striker", function() 

--FE High Striker (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE High Striker By M1zz",
            Text = "You can ask friends how much round do they want!",
            Duration = 5
        })



local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local PlayerGui = player:WaitForChild("PlayerGui")

-- Stop all animations
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

-- Play a non-looping animation
local function playNonLoopAnimation(animId)
	stopAllAnimations()
	
	local anim = Instance.new("Animation")
	anim.AnimationId = animId
	
	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action
	track.Looped = false
	track:Play()
end

-- Animation IDs
local anim1 = "rbxassetid://128325478180369"  -- 40% chance
local anim2 = "rbxassetid://128325478180369"  -- 60% chance
local anim3 = "rbxassetid://93348991072403"   -- lose animation

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimationRepeaterGui"
screenGui.ResetOnSpawn = true
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0, 200, 0, 50)
textbox.Position = UDim2.new(0.5, -100, 0.5, -25)
textbox.PlaceholderText = "Enter Play Rounds"
textbox.ClearTextOnFocus = true
textbox.Text = ""
textbox.Parent = frame
textbox.TextScaled = false
textbox.TextColor3 = Color3.new(1,1,1)
textbox.BackgroundColor3 = Color3.fromRGB(30,30,30)

textbox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local repeatCount = tonumber(textbox.Text) or 3 -- default 3 if invalid
		
		-- Close GUI
		screenGui:Destroy()
		
		-- Run animation loop
		for i = 1, repeatCount do
			local chance = math.random()
			if chance <= 0.8 then
				playNonLoopAnimation(anim1)
			wait(2.8)
				playNonLoopAnimation(anim3)
				game.StarterGui:SetCore("SendNotification", {
            Title = "Lose",
            Text = "It Broken!",
            Duration = 5
        })
        
			else
				playNonLoopAnimation(anim2)
	
			wait(3)	
				game.StarterGui:SetCore("SendNotification", {
            Title = "Congratulations!!",
            Text = "It Scored!",
            Duration = 5
        })
        
        
			end
			wait(5.7)
		end
		wait(1.5)
		game.StarterGui:SetCore("SendNotification", {
            Title = "Round Ended",
            Text = "Run the script again to Play!",
            Duration = 5
        })
	end
end)


end)

makeButton(page3, "Give Sniper", function() 

-- FE Give Sniper (Only R15)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
Title = "FE Give Sniper By M1zz",
Text = "Equip the tool and click the target player",
Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Sniper"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1.8 -- distance to the left of target
local targetPlayer = nil
local isEquipped = false

-- Teleport Animation
local animationId = 140546808687799
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

-- Stop all animations (override Animate script)
local function stopAllAnimations()
local char = LocalPlayer.Character
if not char then return end

local animate = char:FindFirstChild("Animate")  
if animate then  
    originalAnimate = animate:Clone()  
    animate:Destroy()  
end  

local humanoid = char:FindFirstChild("Humanoid")  
if humanoid then  
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do  
        track:Stop()  
        track:Destroy()  
    end  
end

end

local function restoreAnimations()
local char = LocalPlayer.Character
if not char then return end

if originalAnimate then  
    originalAnimate.Parent = char  
    originalAnimate = nil  
end

end

local function playTeleportAnimation()
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid and teleportTrack then
stopAllAnimations()
teleportTrack:Play()
teleportTrack:AdjustSpeed(3)
end
end

-- Get Player From Clicked Part
local function getPlayerFromPart(part)
for _, player in ipairs(Players:GetPlayers()) do
local char = player.Character
if char and part:IsDescendantOf(char) then
return player
end
end
return nil
end

-- Tool Equipped
tool.Equipped:Connect(function()
isEquipped = true

local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")    
teleportTrack = humanoid:LoadAnimation(teleportAnim)    

-- Enable selecting target by clicking    
local mouse = LocalPlayer:GetMouse()    
mouse.Button1Down:Connect(function()    
    if not isEquipped then return end    
    local clickedPart = mouse.Target    
    if clickedPart then    
        local player = getPlayerFromPart(clickedPart)    
        if player and player ~= LocalPlayer then    
            targetPlayer = player    

            -- Teleport to the left of target and match target's look direction  
            local targetChar = targetPlayer.Character  
            if targetChar then  
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")  
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")  
                if targetHRP and hrp then  
                    local leftOffset = -targetHRP.CFrame.RightVector * distance  
                    local newPos = targetHRP.Position + leftOffset  
                    hrp.CFrame = CFrame.new(newPos, newPos + targetHRP.CFrame.LookVector)  
                end  
            end  

            wait(5)    
            pcall(function()  
                LocalPlayer.Character["Knife Grab"].Parent = LocalPlayer.Backpack  
            end)  
        end    
    end    
end)

end)

-- Tool Unequipped
tool.Unequipped:Connect(function()
    isEquipped = false

    local char = LocalPlayer.Character  
    if not char then return end  

    local humanoid = char:FindFirstChild("Humanoid")  
    local hrp = char:FindFirstChild("HumanoidRootPart")  
    if not humanoid or not hrp then return end  

    -- Disable Animate and stop other tracks
    local animateScript = char:FindFirstChild("Animate")  
    local animateBackup = nil  
    if animateScript then  
        animateBackup = animateScript:Clone()  
        animateScript:Destroy()  
    end  

    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do  
        track:Stop()  
    end  

    -- Load freeze animation
    local anim = Instance.new("Animation")  
    anim.AnimationId = "rbxassetid://140546808687799"  
    local track = humanoid:LoadAnimation(anim)  
    track:Play()  
    track:AdjustSpeed(5.2)
    task.wait(0.3)  
    track:AdjustSpeed(0) -- freeze pose  

    local freezeFrame = track.TimePosition  
    task.spawn(function()  
        while not isEquipped and track do  
            track.TimePosition = freezeFrame  
            task.wait()
        end  

        if isEquipped and animateBackup then  
            animateBackup.Parent = char  
            animateBackup = nil  
        end  
    end)  

    -- Loop: follow behind target and look to the LEFT of their view
    local unequipDistance = 1
    task.spawn(function()
        while not isEquipped do
            if targetPlayer and targetPlayer.Character then
                local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    -- Position slightly behind the target
                    local behindPos = targetHRP.Position - targetHRP.CFrame.LookVector * unequipDistance

                    -- Calculate left direction relative to target
                    local leftDir = -targetHRP.CFrame.RightVector

                    -- Set your CFrame to follow behind but look left relative to target
                    hrp.CFrame = CFrame.new(behindPos, behindPos + leftDir)
                end
            end
            task.wait(0)
        end
    end)
end)

-- Main Follow Loop
task.spawn(function()
while true do
task.wait(0)
if not isEquipped then continue end

local char = LocalPlayer.Character    
    if not char then break end    

    local hrp = char:FindFirstChild("HumanoidRootPart")    
    local humanoid = char:FindFirstChild("Humanoid")    
    if not humanoid or humanoid.Health <= 0 then break end    
    if not targetPlayer then continue end    

    local targetChar = targetPlayer.Character    
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")    
    if not hrp or not targetHRP then continue end    

    -- Play teleport animation once    
    if teleportTrack and not teleportTrack.IsPlaying then    
        playTeleportAnimation()    
        hrp.Size = Vector3.new(2, 2, 2)    
    end    

    -- Position LEFT of target and align forward to target's LookVector  
    local leftOffset = -targetHRP.CFrame.RightVector * distance  
    local newPosition = targetHRP.Position + leftOffset  
    hrp.CFrame = CFrame.new(newPosition, newPosition + targetHRP.CFrame.LookVector)  
end

end)




end)
makeButton(page3, "Give Hammer", function() 

--FE Give Hammer (Only R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Give Hammer By M1zz",
            Text = "Equip the tool and click the target player",
            Duration = 5
        })
        
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Hammer"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1.8 -- distance to the left of target
local targetPlayer = nil
local isEquipped = false


---

-- Load Animation

local animationId = 105791949134098
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil


---

-- Stop all animations (override Animate script)

local function stopAllAnimations()
local char = LocalPlayer.Character
if not char then return end

-- Disable Animate script temporarily  
local animate = char:FindFirstChild("Animate")  
if animate then  
    originalAnimate = animate:Clone()  
    animate:Destroy()  
end  

-- Stop all humanoid animation tracks  
local humanoid = char:FindFirstChild("Humanoid")  
if humanoid then  
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do  
        track:Stop()  
        track:Destroy()  
    end  
end

end

local function restoreAnimations()
local char = LocalPlayer.Character
if not char then return end

-- Restore Animate script  
if originalAnimate then  
    originalAnimate.Parent = char  
    originalAnimate = nil  
end

end

local function playTeleportAnimation()
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
stopAllAnimations()
if teleportTrack then
teleportTrack:Play()
end
end
end


---

-- Play animation with speed fix

local function playTeleportAnimation()
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid and teleportTrack then
stopAllAnimations()
teleportTrack:Play()         -- must play first
teleportTrack:AdjustSpeed(3) -- now speed works
end
end


---

-- Get Player From Clicked Part

local function getPlayerFromPart(part)
for _, player in ipairs(Players:GetPlayers()) do
local char = player.Character
if char and part:IsDescendantOf(char) then
return player
end
end
return nil
end


---

-- Tool Equipped

tool.Equipped:Connect(function()
isEquipped = true

local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")  
teleportTrack = humanoid:LoadAnimation(teleportAnim)  

-- Enable selecting target by clicking  
local mouse = LocalPlayer:GetMouse()  
mouse.Button1Down:Connect(function()  
    if not isEquipped then return end  
    local clickedPart = mouse.Target  
    if clickedPart then  
        local player = getPlayerFromPart(clickedPart)  
        if player and player ~= LocalPlayer then  
            targetPlayer = player  
       
        end  
    end  
end)

end)


---

-- Tool Unequipped

tool.Unequipped:Connect(function()
    isEquipped = false

    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    ---------------------------------------------------------
    -- Disable Animate and stop all other animation tracks
    ---------------------------------------------------------
    local animateScript = char:FindFirstChild("Animate")
    local animateBackup = nil
    if animateScript then
        animateBackup = animateScript:Clone()
        animateScript:Destroy()
    end

    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    ---------------------------------------------------------
    -- Load animation and freeze it
    ---------------------------------------------------------
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://105791949134098"

    local track = humanoid:LoadAnimation(anim)
    track:Play()
    track:AdjustSpeed(5.2)
    task.wait(0.3)   -- apply 1 frame
    track:AdjustSpeed(0)  -- freeze animation

    local freezeFrame = track.TimePosition
    task.spawn(function()
        while not isEquipped and track do
            track.TimePosition = freezeFrame
            task.wait()
        end

        -- Restore Animate when re-equipped
        if isEquipped and animateBackup then
            animateBackup.Parent = char
            animateBackup = nil
        end
    end)

    ---------------------------------------------------------
    -- LOOP TELEPORT BEHIND TARGET (closer distance)
    ---------------------------------------------------------
    local unequipDistance = 1  -- smaller distance than normal
    task.spawn(function()
        while not isEquipped do
            if targetPlayer and targetPlayer.Character then
                local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    -- Teleport a bit closer
                    local newPos = targetHRP.Position - targetHRP.CFrame.LookVector * unequipDistance
                    hrp.CFrame = CFrame.new(newPos, targetHRP.Position)
                end
            end
            task.wait(0)
        end
    end)
end)

---

-- Main Follow Loop

task.spawn(function()
while true do
task.wait(0)

if not isEquipped then continue end  

    local char = LocalPlayer.Character  
    if not char then break end  

    local hrp = char:FindFirstChild("HumanoidRootPart")  
    local humanoid = char:FindFirstChild("Humanoid")  
    if not humanoid or humanoid.Health <= 0 then break end  
    if not targetPlayer then continue end  

    local targetChar = targetPlayer.Character  
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")  
    if not hrp or not targetHRP then continue end  

    -- Play teleport animation once  
    if teleportTrack and not teleportTrack.IsPlaying then  
        playTeleportAnimation()  
        game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)  
    end  

    -- Position to the LEFT of the target
local leftOffset = -targetHRP.CFrame.RightVector * distance
local newPosition = targetHRP.Position + leftOffset

-- Make character face the target player
hrp.CFrame = CFrame.new(newPosition, targetHRP.Position)
end

end)




end)
makeButton(page3, "Give PickAxe", function() 

--FE Give Pick Axe (Only R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Give Pick Axe By M1zz",
            Text = "Equip the tool and click the target player",
            Duration = 5
        })
        
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pick Axe"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1.8 -- distance to the left of target
local targetPlayer = nil
local isEquipped = false


---

-- Load Animation

local animationId = 134926102137104
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil


---

-- Stop all animations (override Animate script)

local function stopAllAnimations()
local char = LocalPlayer.Character
if not char then return end

-- Disable Animate script temporarily  
local animate = char:FindFirstChild("Animate")  
if animate then  
    originalAnimate = animate:Clone()  
    animate:Destroy()  
end  

-- Stop all humanoid animation tracks  
local humanoid = char:FindFirstChild("Humanoid")  
if humanoid then  
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do  
        track:Stop()  
        track:Destroy()  
    end  
end

end

local function restoreAnimations()
local char = LocalPlayer.Character
if not char then return end

-- Restore Animate script  
if originalAnimate then  
    originalAnimate.Parent = char  
    originalAnimate = nil  
end

end

local function playTeleportAnimation()
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
stopAllAnimations()
if teleportTrack then
teleportTrack:Play()
end
end
end


---

-- Play animation with speed fix

local function playTeleportAnimation()
local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
if humanoid and teleportTrack then
stopAllAnimations()
teleportTrack:Play()         -- must play first
teleportTrack:AdjustSpeed(3) -- now speed works
end
end


---

-- Get Player From Clicked Part

local function getPlayerFromPart(part)
for _, player in ipairs(Players:GetPlayers()) do
local char = player.Character
if char and part:IsDescendantOf(char) then
return player
end
end
return nil
end


---

-- Tool Equipped

tool.Equipped:Connect(function()
isEquipped = true

local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")  
teleportTrack = humanoid:LoadAnimation(teleportAnim)  

-- Enable selecting target by clicking  
local mouse = LocalPlayer:GetMouse()  
mouse.Button1Down:Connect(function()  
    if not isEquipped then return end  
    local clickedPart = mouse.Target  
    if clickedPart then  
        local player = getPlayerFromPart(clickedPart)  
        if player and player ~= LocalPlayer then  
            targetPlayer = player  
            
        end  
    end  
end)

end)


---

-- Tool Unequipped

tool.Unequipped:Connect(function()
    isEquipped = false

    local char = LocalPlayer.Character
    if not char then return end

    local humanoid = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    ---------------------------------------------------------
    -- Disable Animate and stop all other animation tracks
    ---------------------------------------------------------
    local animateScript = char:FindFirstChild("Animate")
    local animateBackup = nil
    if animateScript then
        animateBackup = animateScript:Clone()
        animateScript:Destroy()
    end

    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    ---------------------------------------------------------
    -- Load animation and freeze it
    ---------------------------------------------------------
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://134926102137104"

    local track = humanoid:LoadAnimation(anim)
    track:Play()
    track:AdjustSpeed(5.2)
    task.wait(0.3)   -- apply 1 frame
    track:AdjustSpeed(0)  -- freeze animation

    local freezeFrame = track.TimePosition
    task.spawn(function()
        while not isEquipped and track do
            track.TimePosition = freezeFrame
            task.wait()
        end

        -- Restore Animate when re-equipped
        if isEquipped and animateBackup then
            animateBackup.Parent = char
            animateBackup = nil
        end
    end)

    ---------------------------------------------------------
    -- LOOP TELEPORT BEHIND TARGET (closer distance)
    ---------------------------------------------------------
    local unequipDistance = 1  -- smaller distance than normal
    task.spawn(function()
        while not isEquipped do
            if targetPlayer and targetPlayer.Character then
                local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetHRP then
                    -- Teleport a bit closer
                    local newPos = targetHRP.Position - targetHRP.CFrame.LookVector * unequipDistance
                    hrp.CFrame = CFrame.new(newPos, targetHRP.Position)
                end
            end
            task.wait(0)
        end
    end)
end)

---

-- Main Follow Loop

task.spawn(function()
while true do
task.wait(0)

if not isEquipped then continue end  

    local char = LocalPlayer.Character  
    if not char then break end  

    local hrp = char:FindFirstChild("HumanoidRootPart")  
    local humanoid = char:FindFirstChild("Humanoid")  
    if not humanoid or humanoid.Health <= 0 then break end  
    if not targetPlayer then continue end  

    local targetChar = targetPlayer.Character  
    local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")  
    if not hrp or not targetHRP then continue end  

    -- Play teleport animation once  
    if teleportTrack and not teleportTrack.IsPlaying then  
        playTeleportAnimation()  
        game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)  
    end  

    -- Position to the LEFT of the target
local leftOffset = -targetHRP.CFrame.RightVector * distance
local newPosition = targetHRP.Position + leftOffset

-- Make character face the target player
hrp.CFrame = CFrame.new(newPosition, targetHRP.Position)
end

end)



end)
makeButton(page3, "Sword Animation", function() 

--FE Sword Animation (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Sword Animation By M1zz",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local animate = character:WaitForChild("Animate")
local humanoid = character:WaitForChild("Humanoid")

-- Animation IDs
animate.idle.Animation1.AnimationId = "rbxassetid://99816605173868"
animate.idle.Animation2.AnimationId = "rbxassetid://99816605173868"
animate.run.RunAnim.AnimationId    = "rbxassetid://78119527629027"
animate.fall.FallAnim.AnimationId  = "rbxassetid://120943636070660"
animate.jump.JumpAnim.AnimationId  = "rbxassetid://75618972775460"
animate.walk.WalkAnim.AnimationId  = "rbxassetid://78119527629027"
animate.sit.SitAnim.AnimationId    = "rbxassetid://78550920924133"
animate.climb.ClimbAnim.AnimationId= "rbxassetid://109631104232250"

-------------------------------------------------------------------
-- Run/walk animation: play only a small middle part
-------------------------------------------------------------------

local RUNWALK_ID = "78119527629027"
local startSkip = 0.4  -- skip first 40% of animation
local endSkip   = 0.4  -- skip last 40% of animation

local function monitorTrack(track)
	task.spawn(function()
		while true do
			if track.IsPlaying then
				local animLength = track.Length or 1
				local currentPos = track.TimePosition

				local startTime = animLength * startSkip
				local endTime   = animLength * (1 - endSkip)

				-- Jump to middle if before it
				if currentPos < startTime then
					track.TimePosition = startTime
				end

				-- Loop back to middle if past end
				if currentPos >= endTime then
					track.TimePosition = startTime
				end
			end
			task.wait()
		end
	end)
end

humanoid.AnimationPlayed:Connect(function(track)
	local animId = track.Animation.AnimationId
	if animId and animId:find(RUNWALK_ID) then
		local animLength = track.Length or 1
		local startTime = animLength * startSkip

		-- start from middle
		task.wait(0.03)
		pcall(function()
			track.TimePosition = startTime
		end)

		-- monitor and loop middle portion
		monitorTrack(track)
	end
end)

local JUMPWALK_ID = "75618972775460"
local startSkip = 0.4  -- skip first 40% of animation
local endSkip   = 0.4  -- skip last 40% of animation

local function monitorTrack(track)
	task.spawn(function()
		while true do
			if track.IsPlaying then
				local animLength = track.Length or 1
				local currentPos = track.TimePosition

				local startTime = animLength * startSkip
				local endTime   = animLength * (1 - endSkip)

				-- Jump to middle if before it
				if currentPos < startTime then
					track.TimePosition = startTime
				end

				-- Loop back to middle if past end
				if currentPos >= endTime then
					track.TimePosition = startTime
				end
			end
			task.wait()
		end
	end)
end

humanoid.AnimationPlayed:Connect(function(track)
	local animId = track.Animation.AnimationId
	if animId and animId:find(JUMPWALK_ID) then
		local animLength = track.Length or 1
		local startTime = animLength * startSkip

		-- start from middle
		task.wait(0.03)
		pcall(function()
			track.TimePosition = startTime
		end)

		-- monitor and loop middle portion
		monitorTrack(track)
	end
end)




local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")


local tool = Instance.new("Tool")
tool.Name = "Slash"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

local tool = Instance.new("Tool")
tool.Name = "Slash 2"          -- Name of the tool
tool.RequiresHandle = false   -- Set true if you want to create a handle
tool.Parent = backpack        -- Put the tool in the player's inventory

while wait() do

if game.Players.LocalPlayer.Character:FindFirstChild("Slash") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://90719054119873"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character["Slash"].Parent = game.Players.LocalPlayer.Backpack
end

if game.Players.LocalPlayer.Character:FindFirstChild("Slash 2") then

local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://83509299779732"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = false                             -- NO LOOP
	track:Play()
end

wait(0)
playNonLoopAnimation()




game.Players.LocalPlayer.Character["Slash 2"].Parent = game.Players.LocalPlayer.Backpack
end

end


end)

makeButton(page3, "Headless", function() 

-- FE Headless (R15 Only)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Headless",
    Text = "By M1zz",
    Duration = 5
})

local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local ANIM_ID = "rbxassetid://100199766676370"

-- Do NOT stop other animations
-- Just start your animation once
local anim = Instance.new("Animation")
anim.AnimationId = ANIM_ID

local track = humanoid:LoadAnimation(anim)
track.Priority = Enum.AnimationPriority.Idle -- low priority so walking/jump overwrite it
track.Looped = true
track:Play()

-- Keep your animation alive forever
RunService.RenderStepped:Connect(function()
    if not track.IsPlaying then
        track:Play()
    end
    track.Looped = true
end)


end)
makeButton(page3, "Headless & Korblox", function() 

-- FE Headless & Korblox (R15 Only)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Headless & Korblox",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Animation IDs
local anim1Id = 100199766676370  -- headless animation
local anim2Id = 97069996546256  -- korblox animation

-- Create Animation objects
local anim1 = Instance.new("Animation")
anim1.AnimationId = "rbxassetid://" .. anim1Id

local anim2 = Instance.new("Animation")
anim2.AnimationId = "rbxassetid://" .. anim2Id

-- Load animations
local track1 = humanoid:LoadAnimation(anim1)
local track2 = humanoid:LoadAnimation(anim2)

-- Allow other animations to overwrite these (Idle priority)
track1.Priority = Enum.AnimationPriority.Idle
track2.Priority = Enum.AnimationPriority.Idle

track1.Looped = true
track2.Looped = true

-- Play both animations
track1:Play()
track2:Play()

-- Keep both animations running forever
RunService.RenderStepped:Connect(function()
    if not track1.IsPlaying then
        track1:Play()
    end
    if not track2.IsPlaying then
        track2:Play()
    end

    -- Re-enable loop every frame just in case
    track1.Looped = true
    track2.Looped = true
end)


end)
makeButton(page3, "Jumpstyle", function() 

--FE JumpStyle (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE JumpStyle By M1zz",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "JumpStyle 1"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 86272822145078
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Orbit Loop
------------------------------------------------------
task.spawn(function()
    local orbitAngle = 0
    local orbitSpeed = 2       -- orbit rotation speed
    local orbitRadius = 7      -- how far you orbit around target

    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play animation if not playing already
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        ------------------------------------------------------
        -- ORBIT AROUND TARGET
        ------------------------------------------------------

        orbitAngle += orbitSpeed * task.wait()

        -- Circle math
        local x = math.cos(orbitAngle) * orbitRadius
        local z = math.sin(orbitAngle) * orbitRadius

        local orbitPosition = targetHRP.Position + Vector3.new(x, 0, z)

        -- Make your character face the target while orbiting
        hrp.CFrame = CFrame.new(orbitPosition, targetHRP.Position)
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "JumpStyle 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 134967713571529
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Orbit Loop
------------------------------------------------------
task.spawn(function()
    local orbitAngle = 0
    local orbitSpeed = 2       -- orbit rotation speed
    local orbitRadius = 7      -- how far you orbit around target

    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play animation if not playing already
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        ------------------------------------------------------
        -- ORBIT AROUND TARGET
        ------------------------------------------------------

        orbitAngle += orbitSpeed * task.wait()

        -- Circle math
        local x = math.cos(orbitAngle) * orbitRadius
        local z = math.sin(orbitAngle) * orbitRadius

        local orbitPosition = targetHRP.Position + Vector3.new(x, 0, z)

        -- Make your character face the target while orbiting
        hrp.CFrame = CFrame.new(orbitPosition, targetHRP.Position)
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "JumpStyle 3"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 126588201825176
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Orbit Loop
------------------------------------------------------
task.spawn(function()
    local orbitAngle = 0
    local orbitSpeed = 3      -- orbit rotation speed
    local orbitRadius = 7      -- how far you orbit around target

    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play animation if not playing already
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        ------------------------------------------------------
        -- ORBIT AROUND TARGET
        ------------------------------------------------------

        orbitAngle += orbitSpeed * task.wait()

        -- Circle math
        local x = math.cos(orbitAngle) * orbitRadius
        local z = math.sin(orbitAngle) * orbitRadius

        local orbitPosition = targetHRP.Position + Vector3.new(x, 0, z)

        -- Make your character face the target while orbiting
        hrp.CFrame = CFrame.new(orbitPosition, targetHRP.Position)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "JumpStyle 4"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 137205932883902
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Orbit Loop
------------------------------------------------------
task.spawn(function()
    local orbitAngle = 0
    local orbitSpeed = 3      -- orbit rotation speed
    local orbitRadius = 7      -- how far you orbit around target

    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play animation if not playing already
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        ------------------------------------------------------
        -- ORBIT AROUND TARGET
        ------------------------------------------------------

        orbitAngle += orbitSpeed * task.wait()

        -- Circle math
        local x = math.cos(orbitAngle) * orbitRadius
        local z = math.sin(orbitAngle) * orbitRadius

        local orbitPosition = targetHRP.Position + Vector3.new(x, 0, z)

        -- Make your character face the target while orbiting
        hrp.CFrame = CFrame.new(orbitPosition, targetHRP.Position)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "JumpStyle 5"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 126945924155124
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Orbit Loop
------------------------------------------------------
task.spawn(function()
    local orbitAngle = 0
    local orbitSpeed = 2      -- orbit rotation speed
    local orbitRadius = 7      -- how far you orbit around target

    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play animation if not playing already
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        ------------------------------------------------------
        -- ORBIT AROUND TARGET
        ------------------------------------------------------

        orbitAngle += orbitSpeed * task.wait()

        -- Circle math
        local x = math.cos(orbitAngle) * orbitRadius
        local z = math.sin(orbitAngle) * orbitRadius

        local orbitPosition = targetHRP.Position + Vector3.new(x, 0, z)

        -- Make your character face the target while orbiting
        hrp.CFrame = CFrame.new(orbitPosition, targetHRP.Position)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "JumpStyle 6"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 117760015982719
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Orbit Loop
------------------------------------------------------
task.spawn(function()
    local orbitAngle = 0
    local orbitSpeed = 2      -- orbit rotation speed
    local orbitRadius = 7      -- how far you orbit around target

    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play animation if not playing already
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        ------------------------------------------------------
        -- ORBIT AROUND TARGET
        ------------------------------------------------------

        orbitAngle += orbitSpeed * task.wait()

        -- Circle math
        local x = math.cos(orbitAngle) * orbitRadius
        local z = math.sin(orbitAngle) * orbitRadius

        local orbitPosition = targetHRP.Position + Vector3.new(x, 0, z)

        -- Make your character face the target while orbiting
        hrp.CFrame = CFrame.new(orbitPosition, targetHRP.Position)
    end
end)



end)
makeButton(page3, "Minecraft Animation", function() 

--FE Minecraft Animation (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Minecraft",
    Text = "By M1zz",
    Duration = 5
})



local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://117477745082587"
character.idle.Animation2.AnimationId = "rbxassetid://117477745082587"
character.run.RunAnim.AnimationId = "rbxassetid://80536599755423"
character.fall.FallAnim.AnimationId = "rbxassetid://117477745082587"
character.jump.JumpAnim.AnimationId = "rbxassetid://117477745082587"
character.walk.WalkAnim.AnimationId = "rbxassetid://80536599755423"
character.sit.SitAnim.AnimationId = "rbxassetid://120346453217498"
character.climb.ClimbAnim.AnimationId = "rbxassetid://121075390792786"



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Crouch"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 129443147411141
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. animationId

local animTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation (loop first 1 second)
------------------------------------------------------
local function playAnim()
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()

        if animTrack then
            animTrack:Play()
            animTrack.TimePosition = 0
        end
    end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    animTrack = humanoid:LoadAnimation(anim)

    playAnim()
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    if animTrack then animTrack:Stop() end
    restoreAnimations()
end)

------------------------------------------------------
-- Animation Loop (no movement, no clicking)
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait()

        if not isEquipped then continue end
        if not animTrack then continue end

        -- Loop first 1 second
        if animTrack.TimePosition >= 1 then
            animTrack.TimePosition = 0
        end
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local tool = Instance.new("Tool")
tool.Name = "Hit"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 129443147411141
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. animationId

local animTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Disable all default animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, t in pairs(humanoid:GetPlayingAnimationTracks()) do
            t:Stop()
            t:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation
------------------------------------------------------
local function playAnim()
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if animTrack then
            animTrack:Play()
        end
    end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    animTrack = humanoid:LoadAnimation(anim)

    playAnim()
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    if animTrack then animTrack:Stop() end
    restoreAnimations()
end)

------------------------------------------------------
-- Loop ONLY the ending part, but skip the very end
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait()

        if not isEquipped or not animTrack then continue end
        local length = animTrack.Length
        if length == 0 then continue end

        ------------------------------------------------------
        -- Parameters:
        -- last 1 second = ending section
        -- cut off 0.15 seconds from the end (no ugly final frame)
        ------------------------------------------------------
        local loopStart = math.max(0, length - 1)
        local loopEnd = length - 0.15   -- trims the end

        -- If below loopStart, jump into ending
        if animTrack.TimePosition < loopStart then
            animTrack.TimePosition = loopStart
        end

        -- If reaching the trimmed end, restart the ending loop
        if animTrack.TimePosition >= loopEnd then
            animTrack.TimePosition = loopStart
        end
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Mining"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 84320634768361
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. animationId

local animTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation (loop first 1 second)
------------------------------------------------------
local function playAnim()
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()

        if animTrack then
            animTrack:Play()
            animTrack.TimePosition = 0
        end
    end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    animTrack = humanoid:LoadAnimation(anim)

    playAnim()
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    if animTrack then animTrack:Stop() end
    restoreAnimations()
end)

------------------------------------------------------
-- Animation Loop (no movement, no clicking)
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait()

        if not isEquipped then continue end
        if not animTrack then continue end

        -- Loop first 1 second
        if animTrack.TimePosition >= 1 then
            animTrack.TimePosition = 0
        end
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local tool = Instance.new("Tool")
tool.Name = "Dead"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 140190312220540
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. animationId

local animTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Disable all default animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, t in pairs(humanoid:GetPlayingAnimationTracks()) do
            t:Stop()
            t:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation normally
------------------------------------------------------
local function playAnim()
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if animTrack then
            animTrack:Play()
        end
    end
end

------------------------------------------------------
-- Tool equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    animTrack = humanoid:LoadAnimation(anim)

    playAnim()
end)

------------------------------------------------------
-- Tool unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    if animTrack then animTrack:Stop() end
    restoreAnimations()
end)

------------------------------------------------------
-- Loop the entire animation (0 → length)
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait()

        if not isEquipped or not animTrack then continue end
        local length = animTrack.Length
        if length == 0 then continue end

        -- If animation reaches the real end, restart
        if animTrack.TimePosition >= length - 0.02 then
            animTrack.TimePosition = 0
        end
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local tool = Instance.new("Tool")
tool.Name = "Peace"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 102987898148762
local anim = Instance.new("Animation")
anim.AnimationId = "rbxassetid://" .. animationId

local animTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Disable all default animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, t in pairs(humanoid:GetPlayingAnimationTracks()) do
            t:Stop()
            t:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation normally
------------------------------------------------------
local function playAnim()
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if animTrack then
            animTrack:Play()
        end
    end
end

------------------------------------------------------
-- Tool equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    animTrack = humanoid:LoadAnimation(anim)

    playAnim()
end)

------------------------------------------------------
-- Tool unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    if animTrack then animTrack:Stop() end
    restoreAnimations()
end)

------------------------------------------------------
-- Loop the entire animation (0 → length)
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait()

        if not isEquipped or not animTrack then continue end
        local length = animTrack.Length
        if length == 0 then continue end

        -- If animation reaches the real end, restart
        if animTrack.TimePosition >= length - 0.02 then
            animTrack.TimePosition = 0
        end
    end
end)




end)

----------------------------------------------------------------------
-- PAGE 4
----------------------------------------------------------------------
local page4 = Instance.new("Frame")
page4.Size = page1.Size
page4.Position = page1.Position
page4.BackgroundTransparency = 1
page4.Visible = false
page4.Parent = frame

local grid4 = Instance.new("UIGridLayout")
grid4.Parent = page4
grid4.CellPadding = grid1.CellPadding
grid4.CellSize = grid1.CellSize

makeButton(page4, "G0re", function()

--FE G0re (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE G0re",
    Text = "By M1zz",
    Duration = 5
})



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Vecna Kill"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://81601303728682"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(4)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Table Hit"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://101851536058836"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(2)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Get Shot"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://128432384065644"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(0.9)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Slip"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://105261801412262"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(0.8)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pull Head"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://132688367148542"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(2.6)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Torso Off"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://72143069974256"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(1)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Plank Walk"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://111770892012825"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(7)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Headshot"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://124711202093413"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(1)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)





end)
makeButton(page4, "Invisible", function()

--FE Invisible (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Invisible",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Invisible"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://125400561730716"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

local function playDodgeAnimationB()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://74886472181216"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

--Noclip By M1zz

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local used = false

local function enableNoclip(character)
	if used then return end
	used = true

	RunService.Stepped:Connect(function()
		if not character.Parent then return end
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end

if player.Character then
	enableNoclip(player.Character)
end

player.CharacterAdded:Connect(function()
	-- Do nothing on respawn (collision stays normal)
end)


end)
makeButton(page4, "Magician", function()

--FE Magician (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Magician",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end


local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://131414686544529"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end


local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
wait(5)


local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://120549639903300"
character.idle.Animation2.AnimationId = "rbxassetid://116112994357057"
character.run.RunAnim.AnimationId = "rbxassetid://102564681911993"
character.fall.FallAnim.AnimationId = "rbxassetid://120549639903300"
character.jump.JumpAnim.AnimationId = "rbxassetid://120549639903300"
character.walk.WalkAnim.AnimationId = "rbxassetid://120549639903300"
character.sit.SitAnim.AnimationId = "rbxassetid://116112994357057"
character.climb.ClimbAnim.AnimationId = "rbxassetid://120549639903300"


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 1"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://90896862783217"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://97522116539411"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 3"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://134926431639612"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 4"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://117632291849644"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 5"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://88624658640795"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 6"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://88090356120560"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 7"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://90186847323105"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 8"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://85845811098946"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 9"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://115865246863463"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Magic Trick 10"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://81479349553743"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)



 end)

makeButton(page4, "Headless Guy", function()

--FE Headless Guy (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Headless Guy",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://137156801508869"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()

	-- stop after 1 second
	task.delay(2, function()
		if currentTrack then
			stopAnimation()
		end
	end)
end

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
humanoid = char:WaitForChild("Humanoid")

playDodgeAnimation()

wait(1)

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://123097403881274"
character.idle.Animation2.AnimationId = "rbxassetid://85845811098946"
character.run.RunAnim.AnimationId = "rbxassetid://117717630701015"
character.fall.FallAnim.AnimationId = "rbxassetid://113923411401265"
character.jump.JumpAnim.AnimationId = "rbxassetid://113923411401265"
character.walk.WalkAnim.AnimationId = "rbxassetid://117717630701015"
character.sit.SitAnim.AnimationId = "rbxassetid://84831776907733"
character.climb.ClimbAnim.AnimationId = "rbxassetid://123097403881274"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Possessed Head"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://136862868323608"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Head Bounce"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://73218831447895"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Head Orbit"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://136642332796314"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Head Rolling"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://86758017198034"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Basketball Head"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://134739656250397"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	
end)



 end)
makeButton(page4, "Mysterious Guy", function()

--FE Mysterious Guy (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Mysterious Guy By M1zz",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end


local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://118405846300584"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end


local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
wait(1)


local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://120527173641109"
character.idle.Animation2.AnimationId = "rbxassetid://72404656977507"
character.run.RunAnim.AnimationId = "rbxassetid://90805593420505"
character.fall.FallAnim.AnimationId = "rbxassetid://112472797825991"
character.jump.JumpAnim.AnimationId = "rbxassetid://131814798893284"
character.walk.WalkAnim.AnimationId = "rbxassetid://103228046360208"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Knife Swing"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 122366279755346
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(2)
				game.Players.LocalPlayer.Character["Knife Swing"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Knife Stab"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1.5 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 103788740211648
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(2)
				game.Players.LocalPlayer.Character["Knife Stab"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Rage Stab"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1.5 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 136617081872352
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(3)
				game.Players.LocalPlayer.Character["Rage Stab"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pistol"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://121573002971812"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(2)
	game.Players.LocalPlayer.Character["Pistol"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Arm Swing"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -3 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 84651196530165
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(5)
				game.Players.LocalPlayer.Character["Arm Swing"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


 end)
makeButton(page4, "Cowboy", function()

--FE Cowboy (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Cowboy",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://76767062741041"
character.idle.Animation2.AnimationId = "rbxassetid://116375792748810"
character.run.RunAnim.AnimationId = "rbxassetid://126769395026240"
character.walk.WalkAnim.AnimationId = "rbxassetid://131520975704727"
character.sit.SitAnim.AnimationId = "rbxassetid://104503321950458"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Ride Horse"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(0.2)
	local character = game.Players.LocalPlayer.Character.Animate
	character.run.RunAnim.AnimationId = "rbxassetid://72721521123147"
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
end

tool.Equipped:Connect(function()

game.StarterGui:SetCore("SendNotification", {
    Title = "Ride Horse By M1zz",
    Text = "Move to ride your horse",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(0.2)
	local character = game.Players.LocalPlayer.Character.Animate
	character.run.RunAnim.AnimationId = "rbxassetid://126769395026240"
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pistol"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://121573002971812"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(2)
	game.Players.LocalPlayer.Character["Pistol"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Whistle"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://97250484107029"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
	
	local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

    -- Build the message using the leaving player's name
    local msg = "Whistle*"

    -- Send it to chat as the local player
    TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(2)
	game.Players.LocalPlayer.Character["Whistle"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)


 end)
makeButton(page4, "Police Officer", function()

--FE Police Officer (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Police Officer By M1zz",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://127804806503841"
character.idle.Animation2.AnimationId = "rbxassetid://83026903211659"
character.run.RunAnim.AnimationId = "rbxassetid://124247546756708"
character.fall.FallAnim.AnimationId = "rbxassetid://112472797825991"
character.jump.JumpAnim.AnimationId = "rbxassetid://131814798893284"
character.walk.WalkAnim.AnimationId = "rbxassetid://76218502453864"


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Handcuff"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 2
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 86877830863560
local SECOND_ANIM_ID = 85708740111289

local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID

local secondAnim = Instance.new("Animation")
secondAnim.AnimationId = "rbxassetid://" .. SECOND_ANIM_ID

local firstTrack = nil
local secondTrack = nil
local originalAnimate = nil
local humanoid = nil
local switched = false

------------------------------------------------------
-- Reset animation state (IMPORTANT FIX)
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end

	if secondTrack then
		secondTrack:Stop()
		secondTrack:Destroy()
		secondTrack = nil
	end

	switched = false
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations
------------------------------------------------------
local function playFirstAnimation()
	stopAllAnimations()
	resetAnimationState()

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

    -- Build the message using the leaving player's name
    local msg = "Handcuffing*"

    -- Send it to chat as the local player
    TextChatService.TextChannels.RBXGeneral:SendAsync(msg)


	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = false
	firstTrack:Play()

	-- Switch after 3 seconds
	task.delay(2.3, function()
		if not isEquipped or switched or not firstTrack then return end
		switched = true

		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil

		secondTrack = humanoid:LoadAnimation(secondAnim)
		secondTrack.Priority = Enum.AnimationPriority.Action4
		secondTrack.Looped = true
		secondTrack:Play()
	end)
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	resetAnimationState()

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end

		local clickedPart = mouse.Target
		if not clickedPart then return end

		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
			resetAnimationState() -- ðŸ”¥ allow replay every time
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil

	resetAnimationState()
	restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then continue end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or humanoid.Health <= 0 then break end
		if not targetPlayer then continue end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		if not hrp or not targetHRP then continue end

		-- Play animation every time (FIXED)
		if not firstTrack and not secondTrack then
			playFirstAnimation()
		end

		-- Position offset
		local behindOffset = -targetHRP.CFrame.LookVector * distance
		local leftOffset = -targetHRP.CFrame.RightVector * 1
		local newPosition = targetHRP.Position + behindOffset + leftOffset

		-- Face same direction as target
		local lookVector = targetHRP.CFrame.LookVector
		hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
	end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Checking"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 106282200155338
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
            local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

    -- Build the message using the leaving player's name
    local msg = "Checking*"

    -- Send it to chat as the local player
    TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(6)
				game.Players.LocalPlayer.Character["Checking"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180Â° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

local LocalPlayer = Players.LocalPlayer
local player = LocalPlayer
local enabled = false

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Radio On/Off"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://112837485853055"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

-- Chat modifier (runs once, controlled by `enabled`)
TextChatService.OnIncomingMessage = function(message)
	if not enabled then
		return
	end

	if message.TextSource and message.TextSource.UserId == player.UserId then
		if message.Text:sub(1, 6) ~= "Radio*" then
			local props = Instance.new("TextChatMessageProperties")
			props.Text = "Radio* " .. message.Text
			return props
		end
	end
end

tool.Equipped:Connect(function()

game.StarterGui:SetCore("SendNotification", {
    Title = "Radio On",
    Text = "Type in chat to use it",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	enabled = true -- ðŸ”¥ RADIO ON
	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()

game.StarterGui:SetCore("SendNotification", {
    Title = "Radio Off",
    Text = "You turned off the radio",
    Duration = 5
})

	enabled = false -- ðŸ”¥ RADIO OFF
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pistol"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://121573002971812"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(2)
	game.Players.LocalPlayer.Character["Pistol"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)


 end)
makeButton(page4, "Drone", function()

--FE Drone (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Drone By M1zz",
    Text = "Hold jump if you wanna go higher",
    Duration = 5
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Disable default Roblox rotation
humanoid.AutoRotate = false

-- Strong BodyGyro for control
local gyro = Instance.new("BodyGyro")
gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
gyro.P = 200000  -- very strong
gyro.D = 5000
gyro.Parent = hrp

------------------------------------------------------
-- TUNING: EASIER TILT
------------------------------------------------------
local MAX_BANK  = math.rad(60)  -- left/right tilt while strafing
local PITCH_DOWN = math.rad(80) -- easier downward tilt (was 100)
local SMOOTHNESS = 20           -- snappy, smooth feel

local currentCFrame = hrp.CFrame

------------------------------------------------------
-- FULL VERTICAL DRONE ROTATION (adjusted tilt)
------------------------------------------------------
RunService.RenderStepped:Connect(function(dt)
	local moveDir = humanoid.MoveDirection

	if moveDir.Magnitude > 0 then
		-- Horizontal yaw based on movement
		local yawDir = Vector3.new(moveDir.X, 0, moveDir.Z)
		if yawDir.Magnitude == 0 then
			yawDir = hrp.CFrame.LookVector
		end
		yawDir = yawDir.Unit

		local yawCF = CFrame.new(hrp.Position, hrp.Position + yawDir)

		-- Local space for tilt
		local localDir = yawCF:VectorToObjectSpace(moveDir.Unit)

		-- Pitch + Roll
		local pitch = -PITCH_DOWN           -- easier downward tilt
		local roll  = localDir.X * MAX_BANK  -- strafing bank

		local targetCF = yawCF * CFrame.Angles(pitch, 0, roll)

		-- Smooth interpolation for drone feel
		currentCFrame = currentCFrame:Lerp(targetCF, math.clamp(dt * SMOOTHNESS, 0, 1))
		gyro.CFrame = currentCFrame
	else
		-- Keep vertical when idle
		local targetCF = hrp.CFrame
		currentCFrame = currentCFrame:Lerp(targetCF, dt * SMOOTHNESS)
		gyro.CFrame = currentCFrame
	end
end)

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://121049172692579"
character.idle.Animation2.AnimationId = "rbxassetid://121049172692579"
character.run.RunAnim.AnimationId = "rbxassetid://121049172692579"
character.fall.FallAnim.AnimationId = "rbxassetid://121049172692579"
character.jump.JumpAnim.AnimationId = "rbxassetid://121049172692579"
character.walk.WalkAnim.AnimationId = "rbxassetid://121049172692579"
character.sit.SitAnim.AnimationId = "rbxassetid://121049172692579"
character.climb.ClimbAnim.AnimationId = "rbxassetid://121049172692579"

game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2,6,1)

wait(0)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Drone Follow"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 121049172692579
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true
    
    game.StarterGui:SetCore("SendNotification", {
    Title = "Drone Follow",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
               
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("Head")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
		local leftOffset = -targetHRP.CFrame.RightVector * 4
		local newPosition = targetHRP.Position + behindOffset + leftOffset

		-- Face same direction as target
		local lookVector = targetHRP.CFrame.LookVector
		hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)






---Bypassed Tower Of hell
---Double Jump
---By M1zz

-- Define the workspace, player, and jump block variables
local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local jumpBlock = nil
 
-- Create a function to spawn the jump block
function SpawnJumpBlock()
    -- Check if a jump block already exists on the player
    if jumpBlock ~= nil then
        jumpBlock:Destroy()
    end
 
    -- Create a new jump block and parent it to the player's character
    jumpBlock = Instance.new("Part", player.Character)
    jumpBlock.Name = "JumpBlock"
    jumpBlock.Size = Vector3.new(20, 0.3, 20)
    jumpBlock.Color = Color3.fromRGB(255, 255, 0)
    jumpBlock.Transparency = 1
    jumpBlock.CanCollide = true
    jumpBlock.Anchored = true
    jumpBlock.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -6, 0)
end
 
-- Connect the spawn jump block function to the player's jump event
player.Character.Humanoid.Jumping:Connect(function()
    SpawnJumpBlock()
end)
 
-- Create a loop to update the jump block position
while true do
    if jumpBlock ~= nil then
        -- Update the jump block's position according to the player's current position
        jumpBlock.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -7, 0)
        wait(0.1)
        game.Players.LocalPlayer.Character.JumpBlock.CanCollide = true
    end
    
    
    
    
    
    wait(0.1)
end

 end)

makeButton(page4, "Bomb", function()

--FE Bomb (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Bomb",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Throw Grenade"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 135931094841392
local SECOND_ANIM_ID = 135373056067761

local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID

local secondAnim = Instance.new("Animation")
secondAnim.AnimationId = "rbxassetid://" .. SECOND_ANIM_ID

local firstTrack = nil
local secondTrack = nil
local originalAnimate = nil
local humanoid = nil
local switched = false

------------------------------------------------------
-- Reset animation state
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end

	if secondTrack then
		secondTrack:Stop()
		secondTrack:Destroy()
		secondTrack = nil
	end

	switched = false
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations sequence
------------------------------------------------------
local function playSequence()
	if not isEquipped or switched then return end
	switched = true

	stopAllAnimations()
	resetAnimationState()

	-- First animation
	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = false
	firstTrack:Play()

	-- Switch to second animation
	task.delay(2.3, function()
		if not isEquipped or not humanoid or humanoid.Health <= 0 then return end

		if firstTrack then
			firstTrack:Stop()
			firstTrack:Destroy()
			firstTrack = nil
		end

		secondTrack = humanoid:LoadAnimation(secondAnim)
		secondTrack.Priority = Enum.AnimationPriority.Action4
		secondTrack.Looped = true
		secondTrack:Play()

		-- FE Spin
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local Spin = Instance.new("BodyAngularVelocity")
			Spin.AngularVelocity = Vector3.new(0, 45, 0)
			Spin.MaxTorque = Vector3.new(0, math.huge, 0)
			Spin.P = 0
			Spin.Parent = hrp
		end

		-- Kill after short delay
		task.delay(0.5, function()
			if humanoid then
				humanoid.Health = 0
			end
		end)
	end)
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	resetAnimationState()
	playSequence()
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	resetAnimationState()
	restoreAnimations()
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "TNT"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://133553452194125"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false

	-- ▶️ Start slow
	currentTrack:Play()
	currentTrack:AdjustSpeed(0.3) -- slow speed

	-- ⚡ Speed up after 3 seconds
	task.delay(1.7, function()
		if currentTrack and currentTrack.IsPlaying then
			currentTrack:AdjustSpeed(2) -- fast speed
			wait(0.1)
			currentTrack:AdjustSpeed(0) -- fast speed
			
			-- FE Spin
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local Spin = Instance.new("BodyAngularVelocity")
			Spin.AngularVelocity = Vector3.new(0, 56, 0)
			Spin.MaxTorque = Vector3.new(0, math.huge, 0)
			Spin.P = 0
			Spin.Parent = hrp
		end
		wait(0.6)
		game.Players.LocalPlayer.Character.Humanoid.Health = 0
		end
	end)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
end)

tool.Unequipped:Connect(function()
	stopAnimation()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Stressed"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 83940178849662
local SECOND_ANIM_ID = 135373056067761

local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID

local secondAnim = Instance.new("Animation")
secondAnim.AnimationId = "rbxassetid://" .. SECOND_ANIM_ID

local firstTrack = nil
local secondTrack = nil
local originalAnimate = nil
local humanoid = nil
local switched = false

------------------------------------------------------
-- Reset animation state
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end

	if secondTrack then
		secondTrack:Stop()
		secondTrack:Destroy()
		secondTrack = nil
	end

	switched = false
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations sequence
------------------------------------------------------
local function playSequence()
	if not isEquipped or switched then return end
	switched = true

	stopAllAnimations()
	resetAnimationState()

	-- First animation
	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = false
	firstTrack:Play()

	-- Switch to second animation
	task.delay(2.3, function()
		if not isEquipped or not humanoid or humanoid.Health <= 0 then return end

		if firstTrack then
			firstTrack:Stop()
			firstTrack:Destroy()
			firstTrack = nil
		end

		secondTrack = humanoid:LoadAnimation(secondAnim)
		secondTrack.Priority = Enum.AnimationPriority.Action4
		secondTrack.Looped = true
		secondTrack:Play()

		-- FE Spin
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local Spin = Instance.new("BodyAngularVelocity")
			Spin.AngularVelocity = Vector3.new(0, 45, 0)
			Spin.MaxTorque = Vector3.new(0, math.huge, 0)
			Spin.P = 0
			Spin.Parent = hrp
		end

		-- Kill after short delay
		task.delay(0.5, function()
			if humanoid then
				humanoid.Health = 0
			end
		end)
	end)
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	resetAnimationState()
	playSequence()
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	resetAnimationState()
	restoreAnimations()
end)

 end)

----------------------------------------------------------------------
-- PAGE 5
----------------------------------------------------------------------
local page5 = Instance.new("Frame")
page5.Size = page1.Size
page5.Position = page1.Position
page5.BackgroundTransparency = 1
page5.Visible = false
page5.Parent = frame

local grid5 = Instance.new("UIGridLayout")
grid5.Parent = page5
grid5.CellPadding = grid1.CellPadding
grid5.CellSize = grid1.CellSize

makeButton(page5, "SCP096", function() 

--FE Scp096 (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Scp096",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://103920001363489"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()

	-- Stop after 3 seconds
	task.delay(3.7, function()
		stopAnimation()
	end)
end

-- Get character & humanoid
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
humanoid = char:WaitForChild("Humanoid")

-- Play animation
playDodgeAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(4)
local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://132065685005919"
character.idle.Animation2.AnimationId = "rbxassetid://103920001363489"
character.run.RunAnim.AnimationId = "rbxassetid://134411626334329"
character.fall.FallAnim.AnimationId = "rbxassetid://96065281687711"
character.jump.JumpAnim.AnimationId = "rbxassetid://100296272663282"
character.walk.WalkAnim.AnimationId = "rbxassetid://113771589189795"

game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Cry"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://136012762295317"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true 
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(1)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Follow Player"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 2
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 134411626334329
local followAnim = Instance.new("Animation")
followAnim.AnimationId = "rbxassetid://" .. animationId

local followTrack = nil
local originalAnimate = nil
local humanoid = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

local function playFollowAnimation()
	stopAllAnimations()
	if followTrack then
		followTrack:Play()
	end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	game.StarterGui:SetCore("SendNotification", {
    Title = "Scp096 Follow",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	followTrack = humanoid:LoadAnimation(followAnim)
	followTrack.Priority = Enum.AnimationPriority.Action4
	followTrack.Looped = true

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end

		local clickedPart = mouse.Target
		if not clickedPart then return end

		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil

	if followTrack then
		followTrack:Stop()
	end

	restoreAnimations()
end)

------------------------------------------------------
-- FOLLOW LOOP (WALKING)
------------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not isEquipped or not targetPlayer then return end
	if not humanoid or humanoid.Health <= 0 then return end

	local targetChar = targetPlayer.Character
	local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	-- Play animation once
	if followTrack and not followTrack.IsPlaying then
		playFollowAnimation()
	end

	-- Walk behind target
	local behindOffset = -targetHRP.CFrame.LookVector * distance
	local destination = targetHRP.Position + behindOffset

	-- Move normally (no teleport)
	humanoid:MoveTo(destination)
end)



end)
makeButton(page5, "Creepy Creature", function()

--FE Creepy Creature (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Creepy Creature",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://73260798029032"
character.idle.Animation2.AnimationId = "rbxassetid://74583851935792"
character.run.RunAnim.AnimationId = "rbxassetid://88508412373927"
character.fall.FallAnim.AnimationId = "rbxassetid://73260798029032"
character.jump.JumpAnim.AnimationId = "rbxassetid://73260798029032"
character.walk.WalkAnim.AnimationId = "rbxassetid://88508412373927"
character.sit.SitAnim.AnimationId = "rbxassetid://73260798029032"
character.climb.ClimbAnim.AnimationId = "rbxassetid://88508412373927"

game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Follow Player"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 2
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 88508412373927
local followAnim = Instance.new("Animation")
followAnim.AnimationId = "rbxassetid://" .. animationId

local followTrack = nil
local originalAnimate = nil
local humanoid = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

local function playFollowAnimation()
	stopAllAnimations()
	if followTrack then
		followTrack:Play()
	end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	
	game.StarterGui:SetCore("SendNotification", {
    Title = "Creepy Follow",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	followTrack = humanoid:LoadAnimation(followAnim)
	followTrack.Priority = Enum.AnimationPriority.Action4
	followTrack.Looped = true

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end

		local clickedPart = mouse.Target
		if not clickedPart then return end

		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 40
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
	if followTrack then
		followTrack:Stop()
	end

	restoreAnimations()
end)

------------------------------------------------------
-- FOLLOW LOOP (WALKING)
------------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not isEquipped or not targetPlayer then return end
	if not humanoid or humanoid.Health <= 0 then return end

	local targetChar = targetPlayer.Character
	local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	-- Play animation once
	if followTrack and not followTrack.IsPlaying then
		playFollowAnimation()
	end

	-- Walk behind target
	local behindOffset = -targetHRP.CFrame.LookVector * distance
	local destination = targetHRP.Position + behindOffset

	-- Move normally (no teleport)
	humanoid:MoveTo(destination)
end)



 end)

makeButton(page5, "FnaF", function()

--FE FnaF (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE FnaF",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://108512414751758"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()

	-- Stop after 3 seconds
	task.delay(3.7, function()
		stopAnimation()
	end)
end

-- Get character & humanoid
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
humanoid = char:WaitForChild("Humanoid")

-- Play animation
playDodgeAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(4)

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://94724080864694"
character.idle.Animation2.AnimationId = "rbxassetid://104747612227015"
character.run.RunAnim.AnimationId = "rbxassetid://128047975332475"
character.fall.FallAnim.AnimationId = "rbxassetid://94724080864694"
character.jump.JumpAnim.AnimationId = "rbxassetid://94724080864694"
character.walk.WalkAnim.AnimationId = "rbxassetid://128047975332475"
character.sit.SitAnim.AnimationId = "rbxassetid://73062309642674"
character.climb.ClimbAnim.AnimationId = "rbxassetid://94724080864694"


game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Jumpscare 1"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 73647342168830
local SECOND_ANIM_ID = 99475704936201

local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID

local secondAnim = Instance.new("Animation")
secondAnim.AnimationId = "rbxassetid://" .. SECOND_ANIM_ID

local firstTrack = nil
local secondTrack = nil
local originalAnimate = nil
local humanoid = nil
local switched = false

------------------------------------------------------
-- Reset animation state
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end

	if secondTrack then
		secondTrack:Stop()
		secondTrack:Destroy()
		secondTrack = nil
	end

	switched = false
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations sequence
------------------------------------------------------
local function playSequence()
	if not isEquipped or switched then return end
	switched = true

	stopAllAnimations()
	resetAnimationState()

	-- First animation
	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = false
	firstTrack:Play()

	-- Switch to second animation
	task.delay(2.3, function()
		if not isEquipped or not humanoid or humanoid.Health <= 0 then return end

		if firstTrack then
			firstTrack:Stop()
			firstTrack:Destroy()
			firstTrack = nil
		end

		secondTrack = humanoid:LoadAnimation(secondAnim)
		secondTrack.Priority = Enum.AnimationPriority.Action4
		secondTrack.Looped = true
		secondTrack:Play()

		
	end)
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	resetAnimationState()
	playSequence()
	
	wait(4)
	game.Players.LocalPlayer.Character["Jumpscare 1"].Parent = game.Players.LocalPlayer.Backpack
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	resetAnimationState()
	restoreAnimations()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Jumpscare 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 132838142020534
local SECOND_ANIM_ID = 107050614591332

local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID

local secondAnim = Instance.new("Animation")
secondAnim.AnimationId = "rbxassetid://" .. SECOND_ANIM_ID

local firstTrack = nil
local secondTrack = nil
local originalAnimate = nil
local humanoid = nil
local switched = false

------------------------------------------------------
-- Reset animation state
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end

	if secondTrack then
		secondTrack:Stop()
		secondTrack:Destroy()
		secondTrack = nil
	end

	switched = false
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations sequence
------------------------------------------------------
local function playSequence()
	if not isEquipped or switched then return end
	switched = true

	stopAllAnimations()
	resetAnimationState()

	-- First animation
	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = false
	firstTrack:Play()

	-- Switch to second animation
	task.delay(2.3, function()
		if not isEquipped or not humanoid or humanoid.Health <= 0 then return end

		if firstTrack then
			firstTrack:Stop()
			firstTrack:Destroy()
			firstTrack = nil
		end

		secondTrack = humanoid:LoadAnimation(secondAnim)
		secondTrack.Priority = Enum.AnimationPriority.Action4
		secondTrack.Looped = true
		secondTrack:Play()

		
	end)
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	resetAnimationState()
	playSequence()
	
	wait(4)
	game.Players.LocalPlayer.Character["Jumpscare 2"].Parent = game.Players.LocalPlayer.Backpack
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	resetAnimationState()
	restoreAnimations()
end)



 end)
makeButton(page5, "Snail", function()

--FE Snail (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Snail",
    Text = "By M1zz",
    Duration = 5
})

game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 9

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--------------------------------------------------
-- PERMANENTLY DISABLE DEFAULT ANIMATIONS
--------------------------------------------------
local animate = character:FindFirstChild("Animate")
if animate then
	animate:Destroy()
end

--------------------------------------------------
-- STOP ALL OTHER ANIMATIONS
--------------------------------------------------
for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
	track:Stop(0)
	track:Destroy()
end

--------------------------------------------------
-- PLAY TARGET ANIMATION
--------------------------------------------------
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://91057228826597"

local track = humanoid:LoadAnimation(animation)
track.Priority = Enum.AnimationPriority.Action4
track.Looped = true 
track:Play()

--------------------------------------------------
-- FREEZE FOREVER ON LAST FRAME
--------------------------------------------------
task.spawn(function()
	-- Wait until animation length is known
	while track.Length == 0 do
		task.wait()
	end

	task.wait(track.Length)

	-- Lock final pose permanently
	track.TimePosition = track.Length - 0.01
	track:AdjustSpeed(0)
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

------------------------------------------------------
-- TOOL
------------------------------------------------------
local tool = Instance.new("Tool")
tool.Name = "Follow Player"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

------------------------------------------------------
-- VARIABLES
------------------------------------------------------
local distance = 2
local targetPlayer = nil
local isEquipped = false
local humanoid = nil
local mouseConn = nil
local DEFAULT_SPEED = 9
local FOLLOW_SPEED = 10

------------------------------------------------------
-- CHARACTER SETUP
------------------------------------------------------
local function setupCharacter()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")
end

setupCharacter()
LocalPlayer.CharacterAdded:Connect(setupCharacter)

------------------------------------------------------
-- GET PLAYER FROM CLICKED PART
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- TOOL EQUIPPED
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	targetPlayer = nil

	if humanoid then
		humanoid.WalkSpeed = FOLLOW_SPEED
	end

	game.StarterGui:SetCore("SendNotification", {
		Title = "Snail Follow",
		Text = "Equip the tool and click a player",
		Duration = 5
	})

	local mouse = LocalPlayer:GetMouse()

	-- Prevent multiple connections
	if mouseConn then
		mouseConn:Disconnect()
	end

	mouseConn = mouse.Button1Down:Connect(function()
		if not isEquipped then return end
		if not mouse.Target then return end

		local player = getPlayerFromPart(mouse.Target)
		if player and player ~= LocalPlayer then
			targetPlayer = player
		end
	end)
end)

------------------------------------------------------
-- TOOL UNEQUIPPED
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil

	if humanoid then
		humanoid.WalkSpeed = DEFAULT_SPEED
	end

	if mouseConn then
		mouseConn:Disconnect()
		mouseConn = nil
	end
end)

------------------------------------------------------
-- FOLLOW LOOP (WALKING)
------------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not isEquipped then return end
	if not targetPlayer then return end
	if not humanoid or humanoid.Health <= 0 then return end

	local targetChar = targetPlayer.Character
	local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	-- Walk behind target
	local behindOffset = -targetHRP.CFrame.LookVector * distance
	local destination = targetHRP.Position + behindOffset

	-- Normal walking (no teleport)
	humanoid:MoveTo(destination)
end)

 end)
makeButton(page5, "Geometry Dash", function()

--FE Geometry Dash (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Geometry Dash",
    Text = "By M1zz",
    Duration = 5
})


local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://120193279893133"
character.idle.Animation2.AnimationId = "rbxassetid://120193279893133"
character.run.RunAnim.AnimationId = "rbxassetid://120193279893133"
character.fall.FallAnim.AnimationId = "rbxassetid://120193279893133"
character.jump.JumpAnim.AnimationId = "rbxassetid://120193279893133"
character.walk.WalkAnim.AnimationId = "rbxassetid://120193279893133"
character.sit.SitAnim.AnimationId = "rbxassetid://120193279893133"
character.climb.ClimbAnim.AnimationId = "rbxassetid://120193279893133"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--------------------------------------------------
-- ANIMATION SETUP
--------------------------------------------------
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://128820510766911"

local track = humanoid:LoadAnimation(animation)
track.Priority = Enum.AnimationPriority.Action
track.Looped = false

-- ðŸ”§ TWEAK THESE VALUES
local START_OFFSET = 0.4   -- seconds to SKIP (first duration)
local PLAY_LENGTH = 0.8    -- middle duration length
local SPEED = 1.40         -- ðŸ”¥ slightly faster (1 = normal)

--------------------------------------------------
-- JUMP DETECTION
--------------------------------------------------
humanoid.StateChanged:Connect(function(_, newState)
	if newState == Enum.HumanoidStateType.Jumping then
		-- Restart animation cleanly
		track:Stop()
		track:Play()

		-- Speed up animation
		track:AdjustSpeed(SPEED)

		-- Skip the first part
		track.TimePosition = START_OFFSET

		-- Stop after middle section
		task.delay(PLAY_LENGTH / SPEED, function()
			if track.IsPlaying then
				track:Stop()
			end
		end)
	end
end)

 end)
makeButton(page5, "Monkey", function()

--FE Monkey (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Monkey",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://90572783402125"
character.idle.Animation2.AnimationId = "rbxassetid://90572783402125"
character.run.RunAnim.AnimationId = "rbxassetid://75938544245074"
character.fall.FallAnim.AnimationId = "rbxassetid://112472797825991"
character.jump.JumpAnim.AnimationId = "rbxassetid://75938544245074"
character.walk.WalkAnim.AnimationId = "rbxassetid://75938544245074"
character.sit.SitAnim.AnimationId = "rbxassetid://90572783402125"
character.climb.ClimbAnim.AnimationId = "rbxassetid://135338706802231"



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Swing"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://135338706802231"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Monkey Grab"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 2
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 119747296248729


local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID


local firstTrack = nil
local originalAnimate = nil
local humanoid = nil


------------------------------------------------------
-- Reset animation state (IMPORTANT FIX)
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations
------------------------------------------------------
local function playFirstAnimation()
	stopAllAnimations()
	resetAnimationState()


	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = true
	firstTrack:Play()
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	resetAnimationState()

game.StarterGui:SetCore("SendNotification", {
    Title = "Monkey Grab",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end

		local clickedPart = mouse.Target
		if not clickedPart then return end

		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
			resetAnimationState() -- ðŸ”¥ allow replay every time
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil

	resetAnimationState()
	restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then continue end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or humanoid.Health <= 0 then break end
		if not targetPlayer then continue end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
		if not hrp or not targetHRP then continue end

		-- Play animation every time (FIXED)
		if not firstTrack and not secondTrack then
			playFirstAnimation()
		end

		-- Position offset
		local behindOffset = -targetHRP.CFrame.LookVector * distance
		local leftOffset = -targetHRP.CFrame.RightVector * -2
		local newPosition = targetHRP.Position + behindOffset + leftOffset

		-- Face same direction as target
		local lookVector = targetHRP.CFrame.LookVector
		hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
	end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Eat Banana"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://132219536519906"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(3)
	game.Players.LocalPlayer.Character["Eat Banana"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

 end)

makeButton(page5, "Rat", function()
--FE Rat (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Rat",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://112100973569061"
character.idle.Animation2.AnimationId = "rbxassetid://112100973569061"
character.run.RunAnim.AnimationId = "rbxassetid://129753151316362"
character.fall.FallAnim.AnimationId = "rbxassetid://112100973569061"
character.jump.JumpAnim.AnimationId = "rbxassetid://112100973569061"
character.walk.WalkAnim.AnimationId = "rbxassetid://129753151316362"
character.sit.SitAnim.AnimationId = "rbxassetid://112100973569061"
character.climb.ClimbAnim.AnimationId = "rbxassetid://112100973569061"

 end)
makeButton(page5, "Head Pet", function()
--FE Head Pet (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Head Pet",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://108673614398298"
character.idle.Animation2.AnimationId = "rbxassetid://89108856008515"
character.run.RunAnim.AnimationId = "rbxassetid://75720083024849"
character.fall.FallAnim.AnimationId = "rbxassetid://75720083024849"
character.jump.JumpAnim.AnimationId = "rbxassetid://76351203710538"
character.walk.WalkAnim.AnimationId = "rbxassetid://75720083024849"
character.sit.SitAnim.AnimationId = "rbxassetid://89108856008515"
character.climb.ClimbAnim.AnimationId = "rbxassetid://75720083024849"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Head Pet"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://102621581524417"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pet Move 1"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://101915709153186"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Pet Move 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://113584047839931"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

 end)
makeButton(page5, "67", function()
--FE 67 (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE 67",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Six Seven"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://131474719009753"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Ultimate 67"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://131474719009753"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	currentTrack:AdjustSpeed(70)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "6 & 7"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://129357672382896"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "67"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://109455121862186"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Spam 67"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://71829078003951"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	for i = 1, 10 do

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

    -- Build the message using the leaving player's name
    local msg = "67"

    -- Send it to chat as the local player
    TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Spam SixSeven"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://113464694272159"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	for i = 1, 10 do

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")

    -- Build the message using the leaving player's name
    local msg = "Six Seven"

    -- Send it to chat as the local player
    TextChatService.TextChannels.RBXGeneral:SendAsync(msg)
    end
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

 end)

----------------------------------------------------------------------
-- PAGE 6
----------------------------------------------------------------------
local page6 = Instance.new("Frame")
page6.Size = page1.Size
page6.Position = page1.Position
page6.BackgroundTransparency = 1
page6.Visible = false
page6.Parent = frame

local grid6 = Instance.new("UIGridLayout")
grid6.Parent = page6
grid6.CellPadding = grid1.CellPadding
grid6.CellSize = grid1.CellSize

makeButton(page6, "Little Guy", function()
--FE Little Guy (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Little Guy",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://117066566681195"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()

	-- Stop after 3 seconds
	task.delay(3.7, function()
		stopAnimation()
	end)
end

-- Get character & humanoid
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
humanoid = char:WaitForChild("Humanoid")

-- Play animation
playDodgeAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(4)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16


local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://91433068525096"
character.idle.Animation2.AnimationId = "rbxassetid://91433068525096"
character.run.RunAnim.AnimationId = "rbxassetid://91433068525096"
character.fall.FallAnim.AnimationId = "rbxassetid://91433068525096"
character.jump.JumpAnim.AnimationId = "rbxassetid://91433068525096"
character.walk.WalkAnim.AnimationId = "rbxassetid://91433068525096"
character.sit.SitAnim.AnimationId = "rbxassetid://91433068525096"
character.climb.ClimbAnim.AnimationId = "rbxassetid://91433068525096"


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--------------------------------------------------
-- FREEZE DEFAULT MOVEMENT / IDLE ANIMATIONS
--------------------------------------------------
local function freezeDefaultAnimations()
	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		-- Core = Idle
		-- Movement = Walk / Run / Jump / Fall / Climb
		if track.Priority == Enum.AnimationPriority.Core
		or track.Priority == Enum.AnimationPriority.Movement then
			
			track.TimePosition = 0
			track:AdjustSpeed(0)
		end
	end
end

--------------------------------------------------
-- KEEP THEM FROZEN FOREVER
--------------------------------------------------
RunService.Heartbeat:Connect(function()
	freezeDefaultAnimations()
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Run Around"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://91433068525096"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(4)
	game.Players.LocalPlayer.Character["Run Around"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Run Around 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://118979452794479"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	wait(8)
	game.Players.LocalPlayer.Character["Run Around 2"].Parent = game.Players.LocalPlayer.Backpack
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)



 end)
makeButton(page6, "Arrow", function()
--FE Arrow (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Arrow",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://99741334982165"
character.idle.Animation2.AnimationId = "rbxassetid://134947274496123"
character.run.RunAnim.AnimationId = "rbxassetid://126769395026240"
character.fall.FallAnim.AnimationId = "rbxassetid://120291620861734"
character.jump.JumpAnim.AnimationId = "rbxassetid://120291620861734"
character.walk.WalkAnim.AnimationId = "rbxassetid://126769395026240"
character.sit.SitAnim.AnimationId = "rbxassetid://131479267717506"
character.climb.ClimbAnim.AnimationId = "rbxassetid://126769395026240"


-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Bow"
tool.RequiresHandle = false
tool.Parent = player:WaitForChild("Backpack")

-- Animation
local ANIMATION_ID = "rbxassetid://103189458470950"
local animation = Instance.new("Animation")
animation.AnimationId = ANIMATION_ID

local track
local mouse
local spawnedPart
local CUT_FRACTION = 0.8 -- cut animation at 50%

-- Equip
tool.Equipped:Connect(function(m)
game.StarterGui:SetCore("SendNotification", {
    Title = "Bow Equipped",
    Text = "Click your direction to go",
    Duration = 5
})
	mouse = m
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	track = humanoid:LoadAnimation(animation)
	track.Looped = false
end)

-- Click / Tap
tool.Activated:Connect(function()
	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")
	if not hrp or not humanoid then return end
	if not mouse then return end

	local hit = mouse.Hit
	if not hit then return end

	-- Create part once
	if not spawnedPart or not spawnedPart.Parent then
		spawnedPart = Instance.new("Part")
		spawnedPart.Size = Vector3.new(0.5, 0.5, 0.5)
		spawnedPart.Anchored = true
		spawnedPart.CanCollide = false
		spawnedPart.Material = Enum.Material.Neon
		spawnedPart.Color = Color3.fromRGB(255, 0, 0)
		spawnedPart.Parent = workspace
	end

	-- Move part
	spawnedPart.CFrame = hit

	-- Face character toward part
	local targetPos = Vector3.new(
		spawnedPart.Position.X,
		hrp.Position.Y,
		spawnedPart.Position.Z
	)
	hrp.CFrame = CFrame.lookAt(hrp.Position, targetPos)

	-- Play animation
	if track then
		track:Stop()
		track:Play()

		-- Wait a fraction of the animation, then cut it
		task.spawn(function()
			-- Wait for the fraction of the animation
			local waitTime = track.Length * CUT_FRACTION
			if waitTime > 0 then
				task.wait(waitTime)
			end

			-- Stop the animation
			if track then
				track:Stop()
			end

			-- Walk to the part
			if humanoid and spawnedPart then
			
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
	local character = game.Players.LocalPlayer.Character.Animate
	character.run.RunAnim.AnimationId = "rbxassetid://90609191023514"
	character.fall.FallAnim.AnimationId = "rbxassetid://90609191023514"
character.jump.JumpAnim.AnimationId = "rbxassetid://90609191023514"
character.walk.WalkAnim.AnimationId = "rbxassetid://90609191023514"
				humanoid:MoveTo(spawnedPart.Position)
			end
			-- Unequip the tool after walking
				local conn
				conn = humanoid.MoveToFinished:Connect(function(reached)
					if conn then conn:Disconnect() end
					-- Unequip all tools
					player.Character.Humanoid:UnequipTools()
				end)
		end)
	end
end)

-- Unequip
tool.Unequipped:Connect(function()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
local character = game.Players.LocalPlayer.Character.Animate
character.run.RunAnim.AnimationId = "rbxassetid://126769395026240"
character.fall.FallAnim.AnimationId = "rbxassetid://120291620861734"
character.jump.JumpAnim.AnimationId = "rbxassetid://120291620861734"
character.walk.WalkAnim.AnimationId = "rbxassetid://126769395026240"

	if track then
		track:Stop()
		track:Destroy()
		track = nil
	end

	if spawnedPart and spawnedPart.Parent then
		spawnedPart:Destroy()
	end

	spawnedPart = nil
	mouse = nil
end)
 end)
makeButton(page6, "Baby", function()
--FE Baby (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Baby",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://114453371616620"
character.idle.Animation2.AnimationId = "rbxassetid://114453371616620"
character.run.RunAnim.AnimationId = "rbxassetid://114453371616620"
character.fall.FallAnim.AnimationId = "rbxassetid://114453371616620"
character.jump.JumpAnim.AnimationId = "rbxassetid://114453371616620"
character.walk.WalkAnim.AnimationId = "rbxassetid://114453371616620"
character.sit.SitAnim.AnimationId = "rbxassetid://114453371616620"
character.climb.ClimbAnim.AnimationId = "rbxassetid://114453371616620"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Lay"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://110936244967206"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 3
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Cart"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -1.5 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 77122264773140
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Baby By M1zz",
    Text = "Click target player to give cart",
    Duration = 5
})

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Sleep"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -3 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 108914039395502
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Baby By M1zz",
    Text = "Click target player to give baby sleeping bed",
    Duration = 5
})

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)
 end)
makeButton(page6, "Glitcher", function()
-- FE Glitcher (R15)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Glitcher By M1zz",
    Text = "Your character movement will be laggy/glitching",
    Duration = 5
})

local player = game.Players.LocalPlayer
local animate = player.Character or player.CharacterAdded:Wait()
animate = animate:WaitForChild("Animate")

animate.idle.Animation1.AnimationId = "rbxassetid://76588130602535"
animate.idle.Animation2.AnimationId = "rbxassetid://74638736874764"
animate.run.RunAnim.AnimationId = "rbxassetid://129121433763494"
animate.fall.FallAnim.AnimationId = "rbxassetid://106937243227681"
animate.jump.JumpAnim.AnimationId = "rbxassetid://106937243227681"
animate.walk.WalkAnim.AnimationId = "rbxassetid://129121433763494"
animate.sit.SitAnim.AnimationId = "rbxassetid://129121433763494"
animate.climb.ClimbAnim.AnimationId = "rbxassetid://129121433763494"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Stop"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://0"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
	wait(0.8)
	game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)





while true do
	task.wait(3)

	local character = player.Character
	if not character then continue end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not hrp then continue end
	if humanoid.Health <= 0 then break end

	-- ✅ ONLY anchor if player is moving
	if humanoid.MoveDirection.Magnitude > 0 then
		hrp.Anchored = true
		task.wait(2)

		if humanoid.Health <= 0 then break end
		hrp.Anchored = false
	end
end
 end)
makeButton(page6, "Cat", function()
--FE Cat (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Cat",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://116846460685489"
character.idle.Animation2.AnimationId = "rbxassetid://116846460685489"
character.run.RunAnim.AnimationId = "rbxassetid://82862771383701"
character.fall.FallAnim.AnimationId = "rbxassetid://116846460685489"
character.jump.JumpAnim.AnimationId = "rbxassetid://116846460685489"
character.walk.WalkAnim.AnimationId = "rbxassetid://82862771383701"
character.sit.SitAnim.AnimationId = "rbxassetid://116846460685489"
character.climb.ClimbAnim.AnimationId = "rbxassetid://82862771383701"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Spinning Cat"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://104179739818152"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 3
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)
 end)

makeButton(page6, "Fish", function()
--FE Fish (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Fish",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://101586104960320"
character.idle.Animation2.AnimationId = "rbxassetid://80652731365494"
character.run.RunAnim.AnimationId = "rbxassetid://102957953130055"
character.fall.FallAnim.AnimationId = "rbxassetid://102957953130055"
character.jump.JumpAnim.AnimationId = "rbxassetid://102957953130055"
character.walk.WalkAnim.AnimationId = "rbxassetid://102957953130055"
character.sit.SitAnim.AnimationId = "rbxassetid://101586104960320"
character.climb.ClimbAnim.AnimationId = "rbxassetid://102957953130055"
character.swim.Swim.AnimationId = "rbxassetid://102957953130055"



 end)
makeButton(page6, "Crazy Dance", function()
--FE Crazy Dance (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Crazy Dance",
    Text = "By M1zz",
    Duration = 5
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Crazy Dance"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://100400724934213"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 3
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Crazy Dance Speed"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://100400724934213"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	currentTrack:AdjustSpeed(4)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 3
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Crazy Dance Ultra"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://100400724934213"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	currentTrack:AdjustSpeed(7)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 3
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)
 end)
makeButton(page6, "Grabber", function()
--FE Grabber (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Grabber",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://97896811186046"
character.idle.Animation2.AnimationId = "rbxassetid://97896811186046"
character.run.RunAnim.AnimationId = "rbxassetid://102564681911993"
character.fall.FallAnim.AnimationId = "rbxassetid://97896811186046"
character.jump.JumpAnim.AnimationId = "rbxassetid://97896811186046"
character.walk.WalkAnim.AnimationId = "rbxassetid://102564681911993"
character.sit.SitAnim.AnimationId = "rbxassetid://97896811186046"
character.climb.ClimbAnim.AnimationId = "rbxassetid://97896811186046"
character.swim.Swim.AnimationId = "rbxassetid://97896811186046"



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Go Down"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://89457070942443"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	currentTrack:AdjustSpeed(7)
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Grab Head"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Animation IDs
------------------------------------------------------
local FIRST_ANIM_ID = 109592705993278


local firstAnim = Instance.new("Animation")
firstAnim.AnimationId = "rbxassetid://" .. FIRST_ANIM_ID


local firstTrack = nil
local originalAnimate = nil
local humanoid = nil


------------------------------------------------------
-- Reset animation state (IMPORTANT FIX)
------------------------------------------------------
local function resetAnimationState()
	if firstTrack then
		firstTrack:Stop()
		firstTrack:Destroy()
		firstTrack = nil
	end
end

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
	local char = LocalPlayer.Character
	if not char then return end

	local animate = char:FindFirstChild("Animate")
	if animate then
		originalAnimate = animate:Clone()
		animate:Destroy()
	end

	for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end
end

local function restoreAnimations()
	local char = LocalPlayer.Character
	if char and originalAnimate then
		originalAnimate.Parent = char
		originalAnimate = nil
	end
end

------------------------------------------------------
-- Play animations
------------------------------------------------------
local function playFirstAnimation()
	stopAllAnimations()
	resetAnimationState()


	firstTrack = humanoid:LoadAnimation(firstAnim)
	firstTrack.Priority = Enum.AnimationPriority.Action4
	firstTrack.Looped = true
	firstTrack:Play()
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
	for _, player in ipairs(Players:GetPlayers()) do
		local char = player.Character
		if char and part:IsDescendantOf(char) then
			return player
		end
	end
	return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true
	resetAnimationState()

game.StarterGui:SetCore("SendNotification", {
    Title = "Grab Head",
    Text = "Click target player to grab",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	local mouse = LocalPlayer:GetMouse()
	mouse.Button1Down:Connect(function()
		if not isEquipped then return end

		local clickedPart = mouse.Target
		if not clickedPart then return end

		local player = getPlayerFromPart(clickedPart)
		if player and player ~= LocalPlayer then
			targetPlayer = player
			resetAnimationState() -- ðŸ”¥ allow replay every time
		end
	end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	targetPlayer = nil

	resetAnimationState()
	restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
	while true do
		task.wait(0)

		if not isEquipped then continue end

		local char = LocalPlayer.Character
		if not char then break end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or humanoid.Health <= 0 then break end
		if not targetPlayer then continue end

		local targetChar = targetPlayer.Character
		local targetHRP = targetChar and targetChar:FindFirstChild("Head")
		if not hrp or not targetHRP then continue end

		-- Play animation every time (FIXED)
		if not firstTrack and not secondTrack then
			playFirstAnimation()
		end

		-- Position offset
		local behindOffset = -targetHRP.CFrame.LookVector * distance
		local leftOffset = -targetHRP.CFrame.RightVector * -1
		local newPosition = targetHRP.Position + behindOffset + leftOffset

		--- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
	end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local used = false

local function enableNoclip(character)
	if used then return end
	used = true

	RunService.Stepped:Connect(function()
		if not character.Parent then return end
		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end)
end

if player.Character then
	enableNoclip(player.Character)
end

player.CharacterAdded:Connect(function()
	-- Do nothing on respawn (collision stays normal)
end)
 end)

makeButton(page6, "Car", function()
-- FE Car (R15 Only)
-- By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Car",
    Text = "By M1zz",
    Duration = 5
})

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
humanoid.JumpHeight = 0.1

local RunService = game:GetService("RunService")

-- ===== Disable default Animate script =====
local animate = character:FindFirstChild("Animate")
if animate then
    animate.Disabled = true
end

-- ===== Animation =====
local walkAnimId = "rbxassetid://116772752010894"
local walkAnimation = Instance.new("Animation")
walkAnimation.AnimationId = walkAnimId

local animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    animator = Instance.new("Animator")
    animator.Parent = humanoid
end

local walkTrack = animator:LoadAnimation(walkAnimation)
walkTrack.Looped = true
walkTrack:Play()
walkTrack:AdjustSpeed(0)

local moving = false

-- ===== Slippery Movement =====
local slideFactor = 0.99
local velocity = Vector3.new(0,0,0)

RunService.RenderStepped:Connect(function(deltaTime)

    -- ===== Stop all other animations =====
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if track ~= walkTrack then
            track:Stop()
        end
    end

    -- ===== Animation control =====
    local isMoving = humanoid.MoveDirection.Magnitude > 0

    if isMoving then
        if not moving then
            moving = true
            walkTrack.TimePosition = 0
            walkTrack:AdjustSpeed(1)
        end
    else
        if moving then
            moving = false
            walkTrack.TimePosition = 0
            walkTrack:AdjustSpeed(0)
        end
    end

    -- ===== Slippery Movement =====
    local moveDir = humanoid.MoveDirection
    if humanoid.FloorMaterial == Enum.Material.Air then
        velocity = Vector3.new(0, velocity.Y, 0)
    else
        if moveDir.Magnitude > 0 then
            velocity = velocity + moveDir * 50 * deltaTime
        end
        velocity = velocity * slideFactor
    end

    -- ===== Apply velocity =====
    root.Velocity = Vector3.new(
        velocity.X,
        root.Velocity.Y,
        velocity.Z
    )
end)
 end)

----------------------------------------------------------------------
-- PAGE 7
----------------------------------------------------------------------
local page7 = Instance.new("Frame")
page7.Size = page1.Size
page7.Position = page1.Position
page7.BackgroundTransparency = 1
page7.Visible = false
page7.Parent = frame

local grid7 = Instance.new("UIGridLayout")
grid7.Parent = page7
grid7.CellPadding = grid1.CellPadding
grid7.CellSize = grid1.CellSize

makeButton(page7, "Spiderman", function()
--FE Spiderman Animation (R15 only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Spiderman Animation",
            Text = "By M1zz",
            Duration = 5
        })

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://98236535896101"
character.idle.Animation2.AnimationId = "rbxassetid://121356238330544"
character.run.RunAnim.AnimationId = "rbxassetid://115615920299613"
character.fall.FallAnim.AnimationId = "rbxassetid://74087960856949"
character.jump.JumpAnim.AnimationId = "rbxassetid://122547678279475"
character.walk.WalkAnim.AnimationId = "rbxassetid://115615920299613"

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local movingSize = Vector3.new(1.8200000524520874, 15, 0.9599999785423279)
local stoppedSize = Vector3.new(1.8200000524520874, 1.9800000190734863, 0.9599999785423279)

local lastState = nil  -- "moving" or "stopped"

game:GetService("RunService").Heartbeat:Connect(function()
    if humanoid.MoveDirection.Magnitude > 0 then
        -- MOVING
        if lastState ~= "moving" then
        game.Players.LocalPlayer.Character.Humanoid.Jump = true    
            hrp.Size = movingSize       
       
            
            lastState = "moving"
        end
    else
        -- STOPPED
        if lastState ~= "stopped" then
            hrp.Size = stoppedSize
            lastState = "stopped"
        end
    end
end)



while wait() do
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
game.Players.LocalPlayer.Character.Humanoid.JumpHeight = 14
end





 end)
makeButton(page7, "Wheel", function()
--FE Wheel (R15 Only)
--By M1zz


game.StarterGui:SetCore("SendNotification", {
            Title = "FE Wheel",
            Text = "By M1zz",
            Duration = 5
        })
  wait(0.7)


local character = game.Players.LocalPlayer.Character.Animate
character.idle.Animation1.AnimationId = "rbxassetid://123297186701468"
character.idle.Animation2.AnimationId = "rbxassetid://123297186701468"
character.run.RunAnim.AnimationId = "rbxassetid://116700088132671"
character.fall.FallAnim.AnimationId = "rbxassetid://131492945521680"
character.jump.JumpAnim.AnimationId = "rbxassetid://131492945521680"
character.walk.WalkAnim.AnimationId = "rbxassetid://116700088132671"
while wait() do
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30
end
 end)
makeButton(page7, "Wings", function()
--FE Wings (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Wings",
            Text = "By M1zz",
            Duration = 5
        })
        

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://131419570855161"
character.idle.Animation2.AnimationId = "rbxassetid://131419570855161"
character.run.RunAnim.AnimationId = "rbxassetid://84729512076467"
character.fall.FallAnim.AnimationId = "rbxassetid://84729512076467"
character.jump.JumpAnim.AnimationId = "rbxassetid://84729512076467"
character.walk.WalkAnim.AnimationId = "rbxassetid://84729512076467"
character.sit.SitAnim.AnimationId = "rbxassetid://131419570855161"
character.climb.ClimbAnim.AnimationId = "rbxassetid://131419570855161"

workspace.Gravity = 20
game.Players.LocalPlayer.Character.Humanoid.JumpHeight = 20
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 30 


---Bypassed Tower Of hell
---Double Jump
---By M1zz

-- Define the workspace, player, and jump block variables
local workspace = game:GetService("Workspace")
local player = game:GetService("Players").LocalPlayer
local jumpBlock = nil
 
-- Create a function to spawn the jump block
function SpawnJumpBlock()
    -- Check if a jump block already exists on the player
    if jumpBlock ~= nil then
        jumpBlock:Destroy()
    end
 
    -- Create a new jump block and parent it to the player's character
    jumpBlock = Instance.new("Part", player.Character)
    jumpBlock.Name = "JumpBlock"
    jumpBlock.Size = Vector3.new(20, 0.3, 20)
    jumpBlock.Color = Color3.fromRGB(255, 255, 0)
    jumpBlock.Transparency = 1
    jumpBlock.CanCollide = true
    jumpBlock.Anchored = true
    jumpBlock.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -2, 0)
end
 
-- Connect the spawn jump block function to the player's jump event
player.Character.Humanoid.Jumping:Connect(function()
    SpawnJumpBlock()
end)
 
-- Create a loop to update the jump block position
while true do
    if jumpBlock ~= nil then
        -- Update the jump block's position according to the player's current position
        jumpBlock.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, -4.8, 0)
        wait(0.1)
        game.Players.LocalPlayer.Character.JumpBlock.CanCollide = true
    end
    
    if game.Players.LocalPlayer.Character.Humanoid.Health == 0 then 
    
    game.workspace.Gravity = 196.1999969482422
    
    end
    
    
    
    wait(0.1)
end

---By M1zz


 end)
makeButton(page7, "Zombie", function()
--FE Zombie Animation (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Zombie Animation [BETA]",
            Text = "By M1zz",
            Duration = 5
        })
        
        
local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://81136296690989"
character.idle.Animation2.AnimationId = "rbxassetid://81136296690989"
character.run.RunAnim.AnimationId = "rbxassetid://140703855480494"
character.fall.FallAnim.AnimationId = "rbxassetid://81136296690989"
character.jump.JumpAnim.AnimationId = "rbxassetid://81136296690989"
character.walk.WalkAnim.AnimationId = "rbxassetid://140703855480494"
character.sit.SitAnim.AnimationId = "rbxassetid://120346453217498"
character.climb.ClimbAnim.AnimationId = "rbxassetid://121075390792786"
 end)
makeButton(page7, "Tank", function()
--FE Tank (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
            Title = "FE Tank",
            Text = "By M1zz",
            Duration = 5
        })

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://88512404217469"
character.idle.Animation2.AnimationId = "rbxassetid://99668342820452"
character.run.RunAnim.AnimationId = "rbxassetid://115951523870527"
character.fall.FallAnim.AnimationId = "rbxassetid://88512404217469"
character.jump.JumpAnim.AnimationId = "rbxassetid://88512404217469"
character.walk.WalkAnim.AnimationId = "rbxassetid://121401114867007"
character.sit.SitAnim.AnimationId = "rbxassetid://121401114867007"
character.climb.ClimbAnim.AnimationId = "rbxassetid://115951523870527"

 end)
makeButton(page7, "Torture", function()
--FE Torture (R15 Only)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Torture By M1zz",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Choke"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 75952996363038
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Knife Grab"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 1.5 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 125813965667273
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(5)
				game.Players.LocalPlayer.Character["Knife Grab"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Slap"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 108225134235478
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(2) -- now speed works
    end
end

------------------------------------------------------
-- Detect clicked player
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                task.wait(0.5)
                LocalPlayer.Character["Slap"].Parent = LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
    end

    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- play animation (with speed 7)
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- position behind the target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- face backwards relative to target
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)




local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Sword"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 135301652666265
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Mad Punch"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 78558658989043
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(2) -- now speed works
    end
end

------------------------------------------------------
-- Detect clicked player
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
               
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
    end

    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- play animation (with speed 7)
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- position behind the target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- face backwards relative to target
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Kick"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 88326768023770
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(1.7) -- now speed works
    end
end

------------------------------------------------------
-- Detect clicked player
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
               
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
    end

    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- play animation (with speed 7)
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- position behind the target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- face backwards relative to target
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Bite"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 2.5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 130482871897578
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(1.5) -- now speed works
    end
end

------------------------------------------------------
-- Detect clicked player
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
               
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
    end

    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- play animation (with speed 7)
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- position behind the target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- face backwards relative to target
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Push"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 92874140796301
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(1.5) -- now speed works
    end
end

------------------------------------------------------
-- Detect clicked player
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
               wait(0.5)
               
               
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local pushSpeed = 150 -- constant backward speed

local function pushBack()
	character = player.Character or player.CharacterAdded:Wait()
	hrp = character:WaitForChild("HumanoidRootPart")

	-- Reset ALL motion fully
	hrp.AssemblyLinearVelocity = Vector3.zero
	hrp.AssemblyAngularVelocity = Vector3.zero
	task.wait() -- wait 1 physics frame

	-- Apply constant backward velocity (NO stacking possible)
	hrp.AssemblyLinearVelocity = -hrp.CFrame.LookVector * pushSpeed
end

-- Test push

pushBack()
               
     LocalPlayer.Character["Push"].Parent = LocalPlayer.Backpack          
               
               
               
               
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
    end

    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- play animation (with speed 7)
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- position behind the target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- face backwards relative to target
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Strongest Punch"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5
local targetPlayer = nil
local isEquipped = false
local isPushing = false -- NEW FLAG


---------------------------
-- Load Animation
---------------------------

local animationId = 113281566861349
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil


---------------------------
-- Stop all animations
---------------------------

local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end


---------------------------
-- Play animation with speed
---------------------------

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()
        teleportTrack:AdjustSpeed(1.5)
    end
end


---------------------------
-- Clicked Target Player
---------------------------

local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

---------------------------
-- Tool Equipped
---------------------------

tool.Equipped:Connect(function()
    isEquipped = true
    isPushing = false

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        if isPushing then return end

        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player



                task.wait(4)

                -- Start pushing
                isPushing = true

                local character = LocalPlayer.Character
                local hrp = character:WaitForChild("HumanoidRootPart")
                local pushSpeed = 320

                local function pushBack()
                    if not isEquipped then return end   -- CANCEL push if unequipped
                    if not isPushing then return end    -- CANCEL if push flag removed

                    character = LocalPlayer.Character
                    hrp = character:WaitForChild("HumanoidRootPart")

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                    task.wait()

                    if isEquipped then
                        hrp.AssemblyLinearVelocity = -hrp.CFrame.LookVector * pushSpeed
                    end
                end





                pushBack()


local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local player = game.Players.LocalPlayer
local humanoid = char:WaitForChild("Humanoid")

-- Stop all animations first
local function stopAllAnimations()
	for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
		track:Destroy()
	end
end

local function playNonLoopAnimation()
	stopAllAnimations()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://120943636070660"

	local track = humanoid:LoadAnimation(anim)
	track.Priority = Enum.AnimationPriority.Action   -- overrides movement animations
	track.Looped = true                             -- NO LOOP
	track:Play()
end






    
while wait() do

if game.Players.LocalPlayer.Character.Humanoid.Health == 20 then
wait(0)
playNonLoopAnimation()
break 
else

end 
end 


                -- Move tool back to backpack after push
                if LocalPlayer.Character:FindFirstChild("Strongest Punch") then
                    LocalPlayer.Character["Strongest Punch"].Parent = LocalPlayer.Backpack
                end

            end
        end
    end)
end)


---------------------------
-- Tool Unequipped (CANCEL PUSH)
---------------------------

tool.Unequipped:Connect(function()
    isEquipped = false
    isPushing = false       -- << STOP push instantly
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
        wait(1)
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
    end

    restoreAnimations()
end)


---------------------------
-- Follow Behind Loop
---------------------------

task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")

        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
            game.Players.LocalPlayer.Character.Humanoid.Health = 20
        end

        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Hammer"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 3 -- distance to the left of target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 105791949134098
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(3) -- now speed works
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(5)
                game.Players.LocalPlayer.Character["Knife Grab"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 4, 2)
        end

        -- Position to the LEFT of the target
        local leftOffset = -targetHRP.CFrame.RightVector * distance
        local newPosition = targetHRP.Position + leftOffset

        -- Make character look in the same direction as the target
        hrp.CFrame = CFrame.new(newPosition, newPosition + targetHRP.CFrame.LookVector)
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Drill"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = 2.3 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 108920477944768
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(5)
				game.Players.LocalPlayer.Character["Knife Grab"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Poop"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.8 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 88916292000392
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(5)
				game.Players.LocalPlayer.Character["Knife Grab"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "L"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -5
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 117914592030402
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

------------------------------------------------------
-- Play animation with speed fix
------------------------------------------------------
local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and teleportTrack then
        stopAllAnimations()
        teleportTrack:Play()         -- must play first
        teleportTrack:AdjustSpeed(2) -- now speed works
    end
end

------------------------------------------------------
-- Detect clicked player
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                task.wait(0.5)
                LocalPlayer.Character["Slap"].Parent = LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then
        teleportTrack:Stop()
    end

    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- play animation (with speed 7)
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- position behind the target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- face backwards relative to target
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Machine Gun"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 129863972412706
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
               
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = targetHRP.CFrame.LookVector
			hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tool setup
local tool = Instance.new("Tool")
tool.Name = "Sus Stick"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -3
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 116732690818367
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId
local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop animations
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get player from clicked part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and part:IsDescendantOf(p.Character) then
            return p
        end
    end
    return nil
end

------------------------------------------------------
-- Apply Tilt-Down + Follow Target Direction
------------------------------------------------------
local function applyTiltDown()
    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- Remove old gyro if exists
    if root:FindFirstChild("TiltGyro") then
        root.TiltGyro:Destroy()
    end

    local run = game:GetService("RunService")
    local gyro = Instance.new("BodyGyro")
    gyro.Name = "TiltGyro"
    gyro.P = 90000
    gyro.MaxTorque = Vector3.new(400000,400000,400000)
    gyro.Parent = root

    local tiltAngle = -90 -- degrees downward
    local conn

    conn = run.RenderStepped:Connect(function()
        if not isEquipped or not targetPlayer then
            gyro:Destroy()
            conn:Disconnect()
            return
        end

        local currentPos = root.Position

        -- Get target horizontal facing (X/Z plane)
        local targetHRP = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP then return end

        local look = targetHRP.CFrame.LookVector
        local horizontalLook = Vector3.new(look.X, 0, look.Z).Unit

        -- Combine horizontal look with downward tilt
        local targetPos = currentPos + horizontalLook
        local downTilt = CFrame.Angles(math.rad(tiltAngle), 0, 0)

        gyro.CFrame = CFrame.new(currentPos, targetPos) * downTilt
    end)
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if not clickedPart then return end

        local foundPlayer = getPlayerFromPart(clickedPart)
        if foundPlayer then
            targetPlayer = foundPlayer
            applyTiltDown()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)  
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    if teleportTrack then teleportTrack:Stop() end
    restoreAnimations()

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and root:FindFirstChild("TiltGyro") then
        root.TiltGyro:Destroy()
        game.Players.LocalPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 2)  
    end
end)

------------------------------------------------------
-- Follow behind target (position only)
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped or not targetPlayer then continue end

        local char = LocalPlayer.Character
        if not char then continue end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP then continue end

        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Teleport behind target, keep current tilt (rotation is controlled by BodyGyro)
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset
        hrp.CFrame = CFrame.new(newPosition) * hrp.CFrame.Rotation
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Hold"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -2.5 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 132445272966466
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local newPosition = targetHRP.Position + behindOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Kick Behind"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

tool.Equipped:Connect(function()
    local distance = 3
    local targetPlayer = nil
    local isEquipped = true

    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid")

    -- Animation (created here, not top-level)
    local animationId = 136004485570200
    local teleportAnim = Instance.new("Animation")
    teleportAnim.AnimationId = "rbxassetid://" .. animationId
    local teleportTrack = humanoid:LoadAnimation(teleportAnim)
    teleportTrack.Looped = true 

    -- Helper function
    local function getPlayerFromPart(part)
        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if c and part:IsDescendantOf(c) then
                return p
            end
        end
        return nil
    end

    -- Mouse click: select target and teleport
    local mouse = LocalPlayer:GetMouse()
    local mouseConn
    mouseConn = mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player

                -- Play teleport animation when actually teleporting
                teleportTrack:Stop()
                teleportTrack:Play()

                -- Stop all other humanoid animations temporarily
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    if track ~= teleportTrack then
                        track:Stop()
                    end
                end
            end
        end
    end)

    -- Follow loop: position behind target
    task.spawn(function()
        while isEquipped do
            task.wait(0.03)
            if not targetPlayer then continue end
            local targetChar = targetPlayer.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then break end
            local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if not targetHRP then continue end

            -- Move behind target
            local behindOffset = -targetHRP.CFrame.LookVector * distance
            local newPosition = targetHRP.Position + behindOffset
            hrp.CFrame = CFrame.new(newPosition, newPosition + targetHRP.CFrame.LookVector)
        end
    end)

    -- Unequip cleanup
    tool.Unequipped:Connect(function()
        isEquipped = false
        targetPlayer = nil
        if teleportTrack then teleportTrack:Stop() end
        if mouseConn then mouseConn:Disconnect() end
    end)
end)


 end)
makeButton(page7, "Swearing", function()
--FE Swearing (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Swearing",
    Text = "By M1zz",
    Duration = 5
})


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "N Word"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local humanoid
local isEquipped = false
local currentTrack

-- Animation IDs in order
local animationSequence = {
	135804735171094,
	114137878243453,
	71035736575796,
	140165407607929
}

------------------------------------------------------
-- Stop current animation
------------------------------------------------------
local function stopCurrent()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

------------------------------------------------------
-- Play sequence
------------------------------------------------------
local function playSequence()
	for _, animId in ipairs(animationSequence) do
		if not isEquipped or not humanoid or humanoid.Health <= 0 then
			stopCurrent()
			return
		end

		stopCurrent()

		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. animId

		currentTrack = humanoid:LoadAnimation(anim)
		currentTrack.Priority = Enum.AnimationPriority.Action4
		currentTrack.Looped = true
		currentTrack:Play()

		task.wait(2) -- ⏱️ wait 2 seconds before next animation
	end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	task.spawn(playSequence)
	wait(9)
	game.Players.LocalPlayer.Character["N Word"].Parent = game.Players.LocalPlayer.Backpack
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	stopCurrent()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "F Word"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local humanoid
local isEquipped = false
local currentTrack

-- Animation IDs in order
local animationSequence = {
	135227259060683,
	135824595429758,
	102706636381416,
	120953677535193
}

------------------------------------------------------
-- Stop current animation
------------------------------------------------------
local function stopCurrent()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

------------------------------------------------------
-- Play sequence
------------------------------------------------------
local function playSequence()
	for _, animId in ipairs(animationSequence) do
		if not isEquipped or not humanoid or humanoid.Health <= 0 then
			stopCurrent()
			return
		end

		stopCurrent()

		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. animId

		currentTrack = humanoid:LoadAnimation(anim)
		currentTrack.Priority = Enum.AnimationPriority.Action4
		currentTrack.Looped = true
		currentTrack:Play()

		task.wait(2) -- ⏱️ wait 2 seconds before next animation
	end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	task.spawn(playSequence)
	wait(9)
	game.Players.LocalPlayer.Character["F Word"].Parent = game.Players.LocalPlayer.Backpack
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	stopCurrent()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "B Word"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local humanoid
local isEquipped = false
local currentTrack

-- Animation IDs in order
local animationSequence = {
	139140056900110,
	114137878243453,
	105838262954463,
	102706636381416,
	128894072580927
}

------------------------------------------------------
-- Stop current animation
------------------------------------------------------
local function stopCurrent()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

------------------------------------------------------
-- Play sequence
------------------------------------------------------
local function playSequence()
	for _, animId in ipairs(animationSequence) do
		if not isEquipped or not humanoid or humanoid.Health <= 0 then
			stopCurrent()
			return
		end

		stopCurrent()

		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. animId

		currentTrack = humanoid:LoadAnimation(anim)
		currentTrack.Priority = Enum.AnimationPriority.Action4
		currentTrack.Looped = true
		currentTrack:Play()

		task.wait(2) -- ⏱️ wait 2 seconds before next animation
	end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	task.spawn(playSequence)
	wait(9)
	game.Players.LocalPlayer.Character["B Word"].Parent = game.Players.LocalPlayer.Backpack
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	stopCurrent()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "S Word"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local humanoid
local isEquipped = false
local currentTrack

-- Animation IDs in order
local animationSequence = {
	122443734972375,
	128894072580927,
	114137878243453,
	105838262954463
	
}

------------------------------------------------------
-- Stop current animation
------------------------------------------------------
local function stopCurrent()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

------------------------------------------------------
-- Play sequence
------------------------------------------------------
local function playSequence()
	for _, animId in ipairs(animationSequence) do
		if not isEquipped or not humanoid or humanoid.Health <= 0 then
			stopCurrent()
			return
		end

		stopCurrent()

		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. animId

		currentTrack = humanoid:LoadAnimation(anim)
		currentTrack.Priority = Enum.AnimationPriority.Action4
		currentTrack.Looped = true
		currentTrack:Play()

		task.wait(2) -- ⏱️ wait 2 seconds before next animation
	end
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
	isEquipped = true

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	task.spawn(playSequence)
	wait(9)
	game.Players.LocalPlayer.Character["S Word"].Parent = game.Players.LocalPlayer.Backpack
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
	isEquipped = false
	stopCurrent()
end)


 end)
makeButton(page7, "Telekinesis", function()
--FE Telekinesis (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Telekinesis",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end


local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://132936908352435"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end


local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
wait(4)


local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://104501345407118"
character.idle.Animation2.AnimationId = "rbxassetid://104501345407118"
character.run.RunAnim.AnimationId = "rbxassetid://99498309796580"
character.fall.FallAnim.AnimationId = "rbxassetid://119974104034237"
character.jump.JumpAnim.AnimationId = "rbxassetid://119974104034237"
character.walk.WalkAnim.AnimationId = "rbxassetid://136382802509224"


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Telekinesis"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://125711035474080"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Telekinesis 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://96600036545801"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Telekinesis 3"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://84144620994353"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Telekinesis 4"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://97370703355297"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Telekinesis Failed"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://77090824959158"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	playDodgeAnimationB()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Telekinesis Choking"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local distance = -3 -- distance behind target
local targetPlayer = nil
local isEquipped = false

------------------------------------------------------
-- Load Animation
------------------------------------------------------
local animationId = 132272973188243
local teleportAnim = Instance.new("Animation")
teleportAnim.AnimationId = "rbxassetid://" .. animationId

local teleportTrack = nil
local originalAnimate = nil

------------------------------------------------------
-- Stop all animations (override Animate script)
------------------------------------------------------
local function stopAllAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Disable Animate script temporarily
    local animate = char:FindFirstChild("Animate")
    if animate then
        originalAnimate = animate:Clone()
        animate:Destroy()
    end

    -- Stop all humanoid animation tracks
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
            track:Destroy()
        end
    end
end

local function restoreAnimations()
    local char = LocalPlayer.Character
    if not char then return end

    -- Restore Animate script
    if originalAnimate then
        originalAnimate.Parent = char
        originalAnimate = nil
    end
end

local function playTeleportAnimation()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        stopAllAnimations()
        if teleportTrack then
            teleportTrack:Play()
        end
    end
end

------------------------------------------------------
-- Get Player From Clicked Part
------------------------------------------------------
local function getPlayerFromPart(part)
    for _, player in ipairs(Players:GetPlayers()) do
        local char = player.Character
        if char and part:IsDescendantOf(char) then
            return player
        end
    end
    return nil
end

------------------------------------------------------
-- Tool Equipped
------------------------------------------------------
tool.Equipped:Connect(function()
    isEquipped = true
    
    game.StarterGui:SetCore("SendNotification", {
    Title = "Telekinesis Choking",
    Text = "Equip the tool and click the target player",
    Duration = 5
})

    local humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
    teleportTrack = humanoid:LoadAnimation(teleportAnim)

    -- Enable selecting target by clicking
    local mouse = LocalPlayer:GetMouse()
    mouse.Button1Down:Connect(function()
        if not isEquipped then return end
        local clickedPart = mouse.Target
        if clickedPart then
            local player = getPlayerFromPart(clickedPart)
            if player and player ~= LocalPlayer then
                targetPlayer = player
                wait(8.6)
				game.Players.LocalPlayer.Character["Telekinesis Choking"].Parent = game.Players.LocalPlayer.Backpack
            end
        end
    end)
end)

------------------------------------------------------
-- Tool Unequipped
------------------------------------------------------
tool.Unequipped:Connect(function()
    isEquipped = false
    targetPlayer = nil

    -- Stop teleport animation and restore original animations
    if teleportTrack then
        teleportTrack:Stop()
    end
    restoreAnimations()
end)

------------------------------------------------------
-- Main Follow Loop
------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0)

        if not isEquipped then continue end

        local char = LocalPlayer.Character
        if not char then break end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then break end
        if not targetPlayer then continue end

        local targetChar = targetPlayer.Character
        local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        if not hrp or not targetHRP then continue end

        -- Play teleport animation once
        if teleportTrack and not teleportTrack.IsPlaying then
            playTeleportAnimation()
        end

        -- Position behind target
        local behindOffset = -targetHRP.CFrame.LookVector * distance
        local leftOffset = -targetHRP.CFrame.RightVector * -1.2 -- adjust amount if needed
local newPosition = targetHRP.Position + behindOffset + leftOffset

        -- Make character look BEHIND target (180° rotated)
        local lookVector = -targetHRP.CFrame.LookVector
        hrp.CFrame = CFrame.new(newPosition, newPosition + lookVector)
    end
end)


 end)
makeButton(page7, "Sonic", function()
--FE Sonic (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Sonic",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://112109141479594"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = false
	currentTrack:Play()

	-- Stop after 3 seconds
	task.delay(3.7, function()
		stopAnimation()
	end)
end

-- Get character & humanoid
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
humanoid = char:WaitForChild("Humanoid")

-- Play animation
playDodgeAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(4)

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://75752382380063"
character.idle.Animation2.AnimationId = "rbxassetid://104340881915453"
character.run.RunAnim.AnimationId = "rbxassetid://76931637880681"
character.fall.FallAnim.AnimationId = "rbxassetid://93025862679737"
character.jump.JumpAnim.AnimationId = "rbxassetid://82083900175742"
character.walk.WalkAnim.AnimationId = "rbxassetid://76931637880681"


game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60



local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Sonic Hedgehog Roll"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(0.2)
	local character = game.Players.LocalPlayer.Character.Animate
	character.run.RunAnim.AnimationId = "rbxassetid://119889021060156"
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end

tool.Equipped:Connect(function()

game.StarterGui:SetCore("SendNotification", {
    Title = "Sonic Hedgehog Roll By M1zz",
    Text = "Move to roll",
    Duration = 5
})

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
wait(0.2)
	local character = game.Players.LocalPlayer.Character.Animate
	character.run.RunAnim.AnimationId = "rbxassetid://76931637880681"
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 60
end)
 end)

----------------------------------------------------------------------
-- PAGE 8
----------------------------------------------------------------------

local page8 = Instance.new("Frame")
page8.Size = page1.Size
page8.Position = page1.Position
page8.BackgroundTransparency = 1
page8.Visible = false
page8.Parent = frame

local grid8 = Instance.new("UIGridLayout")
grid8.Parent = page8
grid8.CellPadding = grid1.CellPadding
grid8.CellSize = grid1.CellSize

makeButton(page8, "Spider", function()
--FE Spider (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Spider",
    Text = "By M1zz",
    Duration = 5
})

local character = game.Players.LocalPlayer.Character.Animate

character.idle.Animation1.AnimationId = "rbxassetid://119066565340795"
character.idle.Animation2.AnimationId = "rbxassetid://119066565340795"
character.run.RunAnim.AnimationId = "rbxassetid://74291392988236"
character.fall.FallAnim.AnimationId = "rbxassetid://119066565340795"
character.jump.JumpAnim.AnimationId = "rbxassetid://140296101132217"
character.walk.WalkAnim.AnimationId = "rbxassetid://78248345283040"
character.sit.SitAnim.AnimationId = "rbxassetid://119066565340795"
character.climb.ClimbAnim.AnimationId = "rbxassetid://78248345283040"


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Spider Triggered"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://101232536501625"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Spider Dance 1"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://129800992392153"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Spider Dance 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://137091464819361"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
end)

tool.Unequipped:Connect(function()
	stopAnimation()

end)

 end)
makeButton(page8, "Mm2 Set", function()
--FE Mm2 Set (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Mm2 Set",
    Text = "By M1zz",
    Duration = 5
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Fake Dead"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://125450209491075"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)


local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Fake Dead 2"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://118790173254253"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Sit"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://139730882634852"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Dual Knife Swing"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://103788740211648"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Single Knife Swing"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://122366279755346"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create Tool
local tool = Instance.new("Tool")
tool.Name = "Knife Throw"
tool.RequiresHandle = false
tool.Parent = LocalPlayer:WaitForChild("Backpack")

local currentTrack = nil
local humanoid = nil

local function stopAnimation()
	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end
end

local function playDodgeAnimation()
	stopAnimation()

	local anim = Instance.new("Animation")
	anim.AnimationId = "rbxassetid://124517257468309"

	currentTrack = humanoid:LoadAnimation(anim)
	currentTrack.Priority = Enum.AnimationPriority.Action
	currentTrack.Looped = true
	currentTrack:Play()
	
end

tool.Equipped:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	humanoid = char:WaitForChild("Humanoid")

	playDodgeAnimation()
	
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = 0
end)

tool.Unequipped:Connect(function()
	stopAnimation()
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

 end)
makeButton(page8, "Worm", function()
--FE Worm (R15)
--By M1zz

game.StarterGui:SetCore("SendNotification", {
    Title = "FE Worm",
    Text = "By M1zz",
    Duration = 5
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 10

-- Load animation
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://111474356297237"

local track = humanoid:LoadAnimation(animation)
track.Looped = true
track:Play()
track:AdjustSpeed(0) -- freeze at first frame initially

RunService.RenderStepped:Connect(function()
    if humanoid.MoveDirection.Magnitude > 0 then
        -- Moving: play animation
        if track.Speed == 0 then
            track.TimePosition = 0
            track:AdjustSpeed(1)
        end
    else
        -- Idle: freeze animation at first frame
        track:AdjustSpeed(0)
        track.TimePosition = 0
    end
end)
 end)
makeButton(page8, "-", function()

 end)
makeButton(page8, "-", function()

 end)
makeButton(page8, "-", function()

 end)
makeButton(page8, "-", function()

 end)
makeButton(page8, "-", function()

 end)
makeButton(page8, "-", function()

 end)
----------------------------------------------------------------------
-- NEXT PAGE BUTTON
----------------------------------------------------------------------
local nextPage = Instance.new("TextButton")
nextPage.Size = UDim2.new(0, 50, 0, 40)
nextPage.Position = UDim2.new(1, -60, 1, -55)
nextPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
nextPage.Text = "Next"
nextPage.TextScaled = false
nextPage.TextWrapped = true
nextPage.TextSize = 18
nextPage.TextColor3 = Color3.fromRGB(0, 0, 0)
nextPage.BackgroundTransparency = 0.3
nextPage.Font = Enum.Font.GothamBold
nextPage.TextStrokeTransparency = 0.2
nextPage.TextStrokeColor3 = Color3.new(0, 0, 0)
nextPage.Parent = frame
Instance.new("UICorner", nextPage).CornerRadius = UDim.new(0, 10)

----------------------------------------------------------------------
-- PREVIOUS / BACK BUTTON
----------------------------------------------------------------------
local prevPage = Instance.new("TextButton")
prevPage.Size = UDim2.new(0, 50, 0, 40)
prevPage.Position = UDim2.new(1, -120, 1, -55)
prevPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
prevPage.Text = "Back"
prevPage.TextScaled = false
prevPage.TextWrapped = true
prevPage.TextSize = 18
prevPage.TextColor3 = Color3.fromRGB(0, 0, 0)
prevPage.BackgroundTransparency = 0.3
prevPage.Font = Enum.Font.GothamBold
prevPage.TextStrokeTransparency = 0.2
prevPage.TextStrokeColor3 = Color3.new(0, 0, 0)
prevPage.Parent = frame
Instance.new("UICorner", prevPage).CornerRadius = UDim.new(0, 10)

local page = 1
local pages = {page1, page2, page3, page4, page5, page6, page7, page8}

-- Next button
nextPage.MouseButton1Click:Connect(function()
    pages[page].Visible = false
    page += 1
    if page > #pages then
        page = #pages -- stop at last page instead of looping
    end
    pages[page].Visible = true
end)

-- Previous / Back button
prevPage.MouseButton1Click:Connect(function()
    pages[page].Visible = false
    page -= 1
    if page < 1 then
        page = 1 -- stop at first page
    end
    pages[page].Visible = true
end)