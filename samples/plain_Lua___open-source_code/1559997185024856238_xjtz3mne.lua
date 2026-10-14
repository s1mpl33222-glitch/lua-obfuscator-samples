local CORRECT_KEY = "@/ 404 on top"

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "17th Society"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")
 
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 150)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui


local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame


local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(40, 40, 40)
UIStroke.Thickness = 1
UIStroke.Parent = MainFrame


local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "@/ 404 Copy Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame


local InputBox = Instance.new("TextBox")
InputBox.Name = "KeyInput"
InputBox.Size = UDim2.new(0.9, 0, 0, 35)
InputBox.Position = UDim2.new(0.05, 0, 0.35, 0)
InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InputBox.BorderSizePixel = 0
InputBox.Text = ""
InputBox.PlaceholderText = "lagay mo key"
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
InputBox.TextScaled = true
InputBox.Font = Enum.Font.Gotham
InputBox.Parent = MainFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 4)
InputCorner.Parent = InputBox


local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "Submit"
SubmitButton.Size = UDim2.new(0.9, 0, 0, 35)
SubmitButton.Position = UDim2.new(0.05, 0, 0.65, 0)
SubmitButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SubmitButton.BorderSizePixel = 0
SubmitButton.Text = "SUBMIT"
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextScaled = true
SubmitButton.Font = Enum.Font.GothamBold
SubmitButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = SubmitButton


SubmitButton.MouseEnter:Connect(function()
    SubmitButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
end)
SubmitButton.MouseLeave:Connect(function()
    SubmitButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
end)


local function runMapCopy()
    local success, err = pcall(function()
        local Params = {
            RepoURL = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/",
            SSI = "saveinstance",
        }
        local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
        synsaveinstance({ SafeMode = true })
    end)

    if not success then
        warn("USSI failed: " .. tostring(err))
    end
end


local function checkKey()
    if InputBox.Text == CORRECT_KEY then
        
        ScreenGui:Destroy()
        runMapCopy()
    else
        
        InputBox.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
        InputBox.Text = ""
        InputBox.PlaceholderText = "mali key mo tanga"
        task.wait(1)
        InputBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        InputBox.PlaceholderText = " enter mo key tanga"
    end
end

SubmitButton.MouseButton1Click:Connect(checkKey)


InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)
