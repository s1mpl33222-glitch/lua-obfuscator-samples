local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- SETTINGS
local PREFIX = "Badshah-"
local LOOTLABS_LINK = "https://lootdest.org/s?fcmmeJZf"
local LINKVERTISE_LINK = "https://link-center.net/6147628/ua2rfLp2u1ep"

-- NUMBER CONVERSION
local convert = {
    ["0"] = "X",
    ["1"] = "Z",
    ["2"] = "A",
    ["3"] = "G",
    ["4"] = "W",
    ["5"] = "Q",
    ["6"] = "M",
    ["7"] = "B",
    ["8"] = "O",
    ["9"] = "V"
}

-- GENERATE TODAY KEY
local function generateKey()
    local date = os.date("%d%m%Y")
    local result = ""

    for i = 1, #date do
        local char = date:sub(i, i)
        result = result .. (convert[char] or char)
    end

    return PREFIX .. result
end

local TODAY_KEY = generateKey()

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BadshahKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,700,0,420)
Main.Position = UDim2.new(0.5, -210, 0.5, -125)
Main.Size = UDim2.new(0,520,0,300)
Main.Position = UDim2.new(0.5,-260,0.5,-150)
Main.BackgroundColor3 = Color3.fromRGB(15,15,18)
Main.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = Main
MainCorner.CornerRadius = UDim.new(0,25)
MainCorner.CornerRadius = UDim.new(0,20)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-80,0,55)
Title.Position = UDim2.new(0,15,0,8)
Title.Text = "🔐 Badshah Scripts"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBlack
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,-70,0,50)
Title.Position = UDim2.new(0,10,0,0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
local CloseMain = Instance.new("TextButton")
CloseMain.Parent = Main
CloseMain.Size = UDim2.new(0,40,0,40)
CloseMain.Position = UDim2.new(1,-55,0,10)
CloseMain.Size = UDim2.new(0,35,0,35)
CloseMain.Position = UDim2.new(1,-45,0,10)
CloseMain.Text = "✕"
CloseMain.TextScaled = true
CloseMain.Font = Enum.Font.GothamBold
CloseMain.BackgroundColor3 = Color3.fromRGB(255,70,70)
CloseMain.BackgroundColor3 = Color3.fromRGB(25,25,25)
CloseMain.TextColor3 = Color3.fromRGB(255,255,255)

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseMain
CloseCorner.CornerRadius = UDim.new(1,0)

CloseMain.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
local CloseStroke = Instance.new("UIStroke")
CloseStroke.Parent = CloseMain
CloseStroke.Color = Color3.fromRGB(255,70,70)
CloseStroke.Thickness = 2

-- KEY BOX
local KeyBox = Instance.new("TextBox")
KeyBox.Parent = Main
KeyBox.Size = UDim2.new(0.8,0,0,45)
KeyBox.Position = UDim2.new(0.1,0,0.32,0)
KeyBox.Size = UDim2.new(0.82,0,0,55)
KeyBox.Position = UDim2.new(0.09,0,0.28,0)
KeyBox.PlaceholderText = "Enter Key"
KeyBox.Text = ""
KeyBox.TextScaled = true
KeyBox.Font = Enum.Font.Gotham
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)

local BoxCorner = Instance.new("UICorner")
BoxCorner.Parent = KeyBox
BoxCorner.CornerRadius = UDim.new(0,8)
local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyBox
KeyCorner.CornerRadius = UDim.new(0,12)

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Parent = KeyBox
KeyStroke.Color = Color3.fromRGB(60,60,60)
KeyStroke.Thickness = 1.5

-- GET KEY BUTTON
local GetKey = Instance.new("TextButton")
GetKey.Parent = Main
GetKey.Size = UDim2.new(0.35,0,0,45)
GetKey.Position = UDim2.new(0.1,0,0.62,0)
GetKey.Text = "Get Key"
GetKey.Size = UDim2.new(0.35,0,0,50)
GetKey.Position = UDim2.new(0.1,0,0.65,0)
GetKey.Text = "🔑 Get Key"
GetKey.TextScaled = true
GetKey.Font = Enum.Font.GothamBold
GetKey.BackgroundColor3 = Color3.fromRGB(0,170,255)
GetKey.BackgroundColor3 = Color3.fromRGB(0,140,255)
GetKey.TextColor3 = Color3.fromRGB(255,255,255)

local GetCorner = Instance.new("UICorner")
GetCorner.Parent = GetKey
GetCorner.CornerRadius = UDim.new(0,8)
GetCorner.CornerRadius = UDim.new(0,12)

-- SUBMIT BUTTON
local Submit = Instance.new("TextButton")
Submit.Parent = Main
Submit.Size = UDim2.new(0.35,0,0,45)
Submit.Position = UDim2.new(0.55,0,0.62,0)
Submit.Text = "Submit Key"
Submit.Size = UDim2.new(0.35,0,0,50)
Submit.Position = UDim2.new(0.55,0,0.65,0)
Submit.Text = "✈ Submit Key"
Submit.TextScaled = true
Submit.Font = Enum.Font.GothamBold
Submit.BackgroundColor3 = Color3.fromRGB(0,255,120)
Submit.TextColor3 = Color3.fromRGB(255,255,255)

local SubmitCorner = Instance.new("UICorner")
SubmitCorner.Parent = Submit
SubmitCorner.CornerRadius = UDim.new(0,8)
SubmitCorner.CornerRadius = UDim.new(0,12)

-- CLOSE FUNCTION
CloseMain.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- NOTIFICATION
local function notify(text)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Badshah Script",
            Text = text,
            Duration = 5
        })
    end)
end

-- POPUP CHECK
local PopupOpened = false

-- GET KEY POPUP
GetKey.MouseButton1Click:Connect(function()

    if PopupOpened then
        return
    end

    PopupOpened = true

    local Popup = Instance.new("Frame")
    Popup.Parent = Main
    Popup.Size = UDim2.new(0.8,0,0,120)
    Popup.Position = UDim2.new(0.1,0,0.15,0)
    Popup.BackgroundColor3 = Color3.fromRGB(35,35,35)

    local PopCorner = Instance.new("UICorner")
    PopCorner.Parent = Popup
    PopCorner.CornerRadius = UDim.new(0,10)

    -- POPUP TITLE
    local PopTitle = Instance.new("TextLabel")
    PopTitle.Parent = Popup
    PopTitle.Size = UDim2.new(1,0,0,30)
    PopTitle.BackgroundTransparency = 1
    PopTitle.Text = "Select Key Provider"
    PopTitle.TextScaled = true
    PopTitle.Font = Enum.Font.GothamBold
    PopTitle.TextColor3 = Color3.fromRGB(255,255,255)

    -- CLOSE POPUP
    local ClosePopup = Instance.new("TextButton")
    ClosePopup.Parent = Popup
    ClosePopup.Size = UDim2.new(0,25,0,25)
    ClosePopup.Position = UDim2.new(1,-30,0,5)
    ClosePopup.Text = "✕"
    ClosePopup.TextScaled = true
    ClosePopup.Font = Enum.Font.GothamBold
    ClosePopup.BackgroundColor3 = Color3.fromRGB(255,70,70)
    ClosePopup.TextColor3 = Color3.fromRGB(255,255,255)

    local ClosePopCorner = Instance.new("UICorner")
    ClosePopCorner.Parent = ClosePopup
    ClosePopCorner.CornerRadius = UDim.new(1,0)

    ClosePopup.MouseButton1Click:Connect(function()
        PopupOpened = false
        Popup:Destroy()
    end)

    -- LOOTLABS BUTTON
    local Lootlabs = Instance.new("TextButton")
    Lootlabs.Parent = Popup
    Lootlabs.Size = UDim2.new(0.4,0,0,45)
    Lootlabs.Position = UDim2.new(0.05,0,0.5,0)
    Lootlabs.Text = "🟣 LootLabs"
    Lootlabs.TextScaled = true
    Lootlabs.Font = Enum.Font.GothamBold
    Lootlabs.BackgroundColor3 = Color3.fromRGB(145,70,255)
    Lootlabs.TextColor3 = Color3.fromRGB(255,255,255)

    local LootCorner = Instance.new("UICorner")
    LootCorner.Parent = Lootlabs
    LootCorner.CornerRadius = UDim.new(0,8)

    -- LINKVERTISE BUTTON
    local Linkvertise = Instance.new("TextButton")
    Linkvertise.Parent = Popup
    Linkvertise.Size = UDim2.new(0.4,0,0,45)
    Linkvertise.Position = UDim2.new(0.55,0,0.5,0)
    Linkvertise.Text = "🟠 Linkvertise"
    Linkvertise.TextScaled = true
    Linkvertise.Font = Enum.Font.GothamBold
    Linkvertise.BackgroundColor3 = Color3.fromRGB(255,120,40)
    Linkvertise.TextColor3 = Color3.fromRGB(255,255,255)

    local LinkCorner = Instance.new("UICorner")
    LinkCorner.Parent = Linkvertise
    LinkCorner.CornerRadius = UDim.new(0,8)

    -- BUTTON ACTIONS
    Lootlabs.MouseButton1Click:Connect(function()
        setclipboard(LOOTLABS_LINK)
        notify("LootLabs link copied to clipboard")
    end)

    Linkvertise.MouseButton1Click:Connect(function()
        setclipboard(LINKVERTISE_LINK)
        notify("Linkvertise link copied to clipboard")
    end)

end)

-- SUBMIT KEY
Submit.MouseButton1Click:Connect(function()

    if KeyBox.Text == TODAY_KEY then

        notify("Key Verified Successfully")

        wait(1)

        ScreenGui:Destroy()
 	
             loadstring(game:HttpGet("https://raw.githubusercontent.com/VearyTry/DeluxedHub/main/dandysworld.lua", true))()

    else

        notify("Invalid Key")

    end
end)
