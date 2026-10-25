local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local FD = RS:WaitForChild("Remotes"):WaitForChild("FoodDelivery")

local pickup = Vector3.new(1430.30, 61.18, -606.11)

local running = false
local closed = false
local loopActive = false

-- Choose a GUI parent compatible with common executors
local guiParent

pcall(function()
if typeof(gethui) == "function" then
guiParent = gethui()
end
end)

if not guiParent then
guiParent = game:GetService("CoreGui")
end

pcall(function()
local old = guiParent:FindFirstChild("DeliveryHub")
if old then
old:Destroy()
end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DeliveryHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(310, 190)
main.Position = UDim2.new(0.5, -155, 0.5, -95)
main.BackgroundColor3 = Color3.fromRGB(24, 20, 38)
main.BorderSizePixel = 0
main.Active = true
main.Visible = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(145, 85, 255)
outline.Thickness = 1.5
outline.Parent = main

local top = Instance.new("Frame")
top.Name = "TitleBar"
top.Size = UDim2.new(1, 0, 0, 42)
top.BackgroundColor3 = Color3.fromRGB(43, 29, 68)
top.BorderSizePixel = 0
top.Active = true
top.Parent = main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = top

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -105, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "KUKIRIN LIFE"
title.TextColor3 = Color3.fromRGB(245, 235, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30, 27)
minimize.Position = UDim2.new(1, -69, 0, 7)
minimize.BackgroundColor3 = Color3.fromRGB(72, 53, 102)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 16
minimize.Font = Enum.Font.GothamBold
minimize.BorderSizePixel = 0
minimize.Parent = top

Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 7)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 27)
close.Position = UDim2.new(1, -35, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(135, 48, 77)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 13
close.Font = Enum.Font.GothamBold
close.BorderSizePixel = 0
close.Parent = top

Instance.new("UICorner", close).CornerRadius = UDim.new(0, 7)

-- Content container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -42)
content.Position = UDim2.fromOffset(0, 42)
content.BackgroundTransparency = 1
content.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -26, 0, 24)
subtitle.Position = UDim2.fromOffset(13, 3)
subtitle.BackgroundTransparency = 1
subtitle.Text = "DELIVERY HUB"
subtitle.TextColor3 = Color3.fromRGB(169, 137, 220)
subtitle.TextSize = 11
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = content

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -26, 0, 42)
toggle.Position = UDim2.fromOffset(13, 32)
toggle.BackgroundColor3 = Color3.fromRGB(102, 58, 177)
toggle.Text = "ENABLE DELIVERY"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 14
toggle.Font = Enum.Font.GothamBold
toggle.BorderSizePixel = 0
toggle.Parent = content

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 9)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -26, 0, 43)
status.Position = UDim2.fromOffset(13, 80)
status.BackgroundTransparency = 1
status.Text = "Status: OFF"
status.TextColor3 = Color3.fromRGB(190, 180, 210)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.TextWrapped = true
status.Parent = content

local function setStatus(message, color)
if not closed and status.Parent then
status.Text = "Status: " .. message
status.TextColor3 = color or Color3.fromRGB(190, 180, 210)
end
end

-- Drag window using mouse or touch
local dragging = false
local dragStart
local startPos
local dragInput

top.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch then

    dragging = true
    dragStart = input.Position
    startPos = main.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end

end)

top.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if dragging and input == dragInput and not closed then
local delta = input.Position - dragStart

    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

end)

-- Minimize content while keeping title bar usable
local minimized = false

minimize.Activated:Connect(function()
minimized = not minimized
content.Visible = not minimized

main.Size = minimized
    and UDim2.fromOffset(310, 42)
    or UDim2.fromOffset(310, 190)

minimize.Text = minimized and "+" or "—"

end)

-- Delivery helpers
local function getRoot()
local char = player.Character or player.CharacterAdded:Wait()
return char:WaitForChild("HumanoidRootPart")
end

local function teleport(pos)
if not running or closed then
return false
end

local ok, err = pcall(function()
    getRoot().CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
end)

if not ok then
    warn("Teleport error:", err)
    return false
end

-- Original teleport delay
task.wait(2)

return running and not closed

end

local function invoke(name)
if not running or closed then
return false
end

local ok, result = pcall(function()
    return FD:WaitForChild(name):InvokeServer()
end)

print(name, ok, result)

return ok and result == true

end

local function readCustomerPosition()
local customer = workspace:FindFirstChild("DeliveryCustomer")

if not customer then
    return nil
end

if customer:IsA("Model") then
    return customer:GetPivot().Position
elseif customer:IsA("BasePart") then
    return customer.Position
end

return nil

end

local function waitForCustomer()
local deadline = os.clock() + 30

repeat
    if not running or closed then
        return nil
    end

    local pos = readCustomerPosition()

    if pos then
        return pos
    end

    task.wait(0.25)
until os.clock() >= deadline

return nil

end

-- Main loop
local function startLoop()
if loopActive then
return
end

loopActive = true

task.spawn(function()
    while running and not closed do
        setStatus("Going to pickup...")

        if not teleport(pickup) then
            break
        end

        if not invoke("Start") then
            setStatus("Pickup failed; retrying")
            task.wait(3)
            continue
        end

        setStatus("Waiting for customer...")

        local customerPos = waitForCustomer()

        if not running or closed then
            break
        end

        if not customerPos then
            setStatus("Customer not found; retrying")
            task.wait(3)
            continue
        end

        setStatus("Travelling to customer...")

        if not teleport(customerPos) then
            break
        end

        setStatus("Delivering...")

        while running and not closed do
            if invoke("Deliver") then
                setStatus("Delivery complete!")
                print("Delivery complete!")
                break
            end

            -- Refresh customer position without waiting for timeout
            local updatedPos = readCustomerPosition()

            if updatedPos then
                local ok, root = pcall(getRoot)

                if ok and (root.Position - updatedPos).Magnitude > 10 then
                    setStatus("Following customer...")

                    if not teleport(updatedPos) then
                        break
                    end
                end
            end

            -- Original delivery retry interval
            task.wait(3)
        end

        if running and not closed then
            task.wait(0.25)
        end
    end

    loopActive = false

    if not closed then
        running = false
        toggle.Text = "ENABLE DELIVERY"
        toggle.BackgroundColor3 = Color3.fromRGB(102, 58, 177)
        setStatus("OFF")
    end
end)

end

toggle.Activated:Connect(function()
if closed then
return
end

running = not running

if running then
    toggle.Text = "DISABLE DELIVERY"
    toggle.BackgroundColor3 = Color3.fromRGB(54, 145, 103)
    setStatus("Starting...")
    startLoop()
else
    setStatus("Stopping...")
    toggle.Text = "ENABLE DELIVERY"
    toggle.BackgroundColor3 = Color3.fromRGB(102, 58, 177)
end

end)

close.Activated:Connect(function()
running = false
closed = true
gui:Destroy()
end)

print("Delivery Hub loaded")