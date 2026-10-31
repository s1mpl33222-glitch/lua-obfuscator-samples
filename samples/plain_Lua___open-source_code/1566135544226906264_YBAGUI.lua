-- Key System Script for Roblox
-- Replace the verification URL with your actual website URL

-- Create the key verification UI
local function createKeyUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local KeyInput = Instance.new("TextBox")
    local SubmitButton = Instance.new("TextButton")
    local GetKeyButton = Instance.new("TextButton")
    local StatusLabel = Instance.new("TextLabel")
    
    -- Configure ScreenGui
    ScreenGui.Name = "KeySystemUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Configure MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    
    -- Configure Title
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = "Script Key System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16.000
    
    -- Configure KeyInput
    KeyInput.Name = "KeyInput"
    KeyInput.Parent = MainFrame
    KeyInput.BackgroundColor3 = Color3.fromRGB(51, 65, 85)
    KeyInput.BorderSizePixel = 0
    KeyInput.Position = UDim2.new(0.5, -125, 0.3, 0)
    KeyInput.Size = UDim2.new(0, 250, 0, 30)
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.PlaceholderText = "Enter your key here..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14.000
    
    -- Configure SubmitButton
    SubmitButton.Name = "SubmitButton"
    SubmitButton.Parent = MainFrame
    SubmitButton.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    SubmitButton.BorderSizePixel = 0
    SubmitButton.Position = UDim2.new(0.5, -60, 0.55, 0)
    SubmitButton.Size = UDim2.new(0, 120, 0, 30)
    SubmitButton.Font = Enum.Font.GothamSemibold
    SubmitButton.Text = "Submit Key"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 14.000
    
    -- Configure GetKeyButton
    GetKeyButton.Name = "GetKeyButton"
    GetKeyButton.Parent = MainFrame
    GetKeyButton.BackgroundColor3 = Color3.fromRGB(51, 65, 85)
    GetKeyButton.BorderSizePixel = 0
    GetKeyButton.Position = UDim2.new(0.5, -60, 0.75, 0)
    GetKeyButton.Size = UDim2.new(0, 120, 0, 30)
    GetKeyButton.Font = Enum.Font.GothamSemibold
    GetKeyButton.Text = "Get Key"
    GetKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyButton.TextSize = 14.000
    
    -- Configure StatusLabel
    StatusLabel.Name = "StatusLabel"
    StatusLabel.Parent = MainFrame
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.new(0, 0, 0.9, 0)
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    StatusLabel.TextSize = 12.000
    
    return {
        ScreenGui = ScreenGui,
        KeyInput = KeyInput,
        SubmitButton = SubmitButton,
        GetKeyButton = GetKeyButton,
        StatusLabel = StatusLabel
    }
end

-- Verify key with server
local function verifyKey(key)
    -- Replace with your website URL
    local url = "https://luarmor.org/?verify=1&key=" .. key
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        if response == "valid" then
            return true, "valid"
        elseif response == "expired" then
            return false, "expired"
        elseif response == "used" then
            return false, "used"
        else
            return false, "invalid"
        end
    else
        return false, "error"
    end
end

-- Run the script after key verification
local function runMainScript()
    -- Your original script logic here
    local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/kolgie/YBA-GUI/main/yba-gui-obfuscated.lua"))()

    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            loadstring(game:HttpGet(Execute))()
        end
    end
end

-- Initialize key system and UI
local function initKeySystem()
    local ui = createKeyUI()
    
    -- Handle Get Key button
    ui.GetKeyButton.MouseButton1Click:Connect(function()
        -- Website URL to get key
        local keyWebsite = "https://luarmor.org/"
        
        -- Copy URL to clipboard
        setclipboard(keyWebsite)
        
        ui.StatusLabel.Text = "Key website URL copied to clipboard! Paste in your browser."
        ui.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    end)
    
    -- Handle Submit button
    ui.SubmitButton.MouseButton1Click:Connect(function()
        local key = ui.KeyInput.Text
        
        if key == "" then
            ui.StatusLabel.Text = "Please enter a key!"
            ui.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            return
        end
        
        ui.StatusLabel.Text = "Verifying key..."
        ui.StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        
        task.delay(1.5, function()
            local isValid, status = verifyKey(key)
            
            if isValid then
                ui.StatusLabel.Text = "Key verified successfully!"
                ui.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                
                task.delay(1, function()
                    ui.ScreenGui:Destroy()
                    runMainScript()
                end)
            else
                if status == "expired" then
                    ui.StatusLabel.Text = "This key has expired! Keys expire after 24 hours."
                    ui.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif status == "used" then
                    ui.StatusLabel.Text = "This key has already been used!"
                    ui.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                else
                    ui.StatusLabel.Text = "Invalid key! Please try again."
                    ui.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
    end)
    
    return ui
end

-- Start the key system
initKeySystem()
