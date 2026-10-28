-- macro for mobile by khen
local function createGUI()
    -- Check if the GUI already exists to prevent duplicates
    if game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ScreenGui") then
        return -- Exit the function if the GUI already exists
    end

    -- Create the ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    local Button = Instance.new("TextButton")

    -- Set properties for the ScreenGui
    ScreenGui.Name = "ScreenGui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false  -- Prevents the GUI from resetting on death

    -- Set properties for the Button
    Button.Name = "Macro"
    Button.Parent = ScreenGui
    Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Button.Position = UDim2.new(0.5, -50, 0.5, -25)
    Button.Size = UDim2.new(0, 80, 0, 45)
    Button.Text = "Macro"
    Button.TextColor3 = Color3.fromRGB(255, 0, 255)
    Button.TextSize = 9

    -- Variables and services  
    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    local isFacingForward = false

    -- Function to update the player's orientation to face the camera direction
    local function faceForward()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local currentPosition = humanoidRootPart.Position

        -- Get the camera's look vector and ignore the Y component to prevent tilting
        local lookVector = camera.CFrame.LookVector
        local flatLookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit

        -- Update the orientation while preserving the vertical position
        local newCFrame = CFrame.new(currentPosition, currentPosition + flatLookVector)
        humanoidRootPart.CFrame = newCFrame
    end

    -- Function to handle the loop of facing forward, using RenderStepped for instant updates
    local function loopFaceForward()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if isFacingForward then
                faceForward() -- Face forward every frame
            else
                connection:Disconnect() -- Stop updating when not facing forward
            end
        end)
    end

    -- Button click event to toggle facing forward
    Button.MouseButton1Click:Connect(function()
        isFacingForward = not isFacingForward -- Toggle facing forward
        if isFacingForward then
            Button.Text = "Stop Macro"
            loopFaceForward() -- Start the instant face forward loop
        else
            Button.Text = "Macro"
        end
    end)

    -- Dragging functionality (for mobile and desktop)
    local dragging, dragInput, mousePos, framePos

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = Button.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Button.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Create the GUI initially (only once)
createGUI()

-- Prevent GUI recreation on respawn
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function()
    -- No need to recreate the GUI, it persists through respawn
    -- You can add any character-specific logic here if needed
end)
