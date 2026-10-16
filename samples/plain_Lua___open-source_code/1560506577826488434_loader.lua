-- CARNAGE VICTIM LOADER
-- forcesloader.com/s/loader

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski UI varsa sil
local old = PlayerGui:FindFirstChild("CarnageAuth")
if old then old:Destroy() end

-- UI oluştur
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CarnageAuth"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Blur = Instance.new("Frame")
Blur.Size = UDim2.new(1, 0, 1, 0)
Blur.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Blur.BackgroundTransparency = 0.5
Blur.BorderSizePixel = 0
Blur.Parent = ScreenGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 180)
Frame.Position = UDim2.new(0.5, -160, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
Frame.BorderSizePixel = 1
Frame.BorderColor3 = Color3.fromRGB(200, 40, 40)
Frame.Parent = ScreenGui

-- Üst çizgi
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 2)
TopLine.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
TopLine.BorderSizePixel = 0
TopLine.Parent = Frame

-- Başlık
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "CARNAGE VICTIM"
Title.TextColor3 = Color3.fromRGB(200, 40, 40)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Frame

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, 0, 0, 20)
Sub.Position = UDim2.new(0, 0, 0, 30)
Sub.BackgroundTransparency = 1
Sub.Text = "Enter your key to continue"
Sub.TextColor3 = Color3.fromRGB(120, 120, 120)
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 10
Sub.Parent = Frame

-- Input
local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -40, 0, 34)
Input.Position = UDim2.new(0, 20, 0, 70)
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.BorderSizePixel = 1
Input.BorderColor3 = Color3.fromRGB(50, 50, 50)
Input.PlaceholderText = "Key..."
Input.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
Input.Text = ""
Input.TextColor3 = Color3.fromRGB(220, 220, 220)
Input.Font = Enum.Font.GothamBold
Input.TextSize = 12
Input.ClearTextOnFocus = false
Input.Parent = Frame

-- Status label
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -40, 0, 20)
Status.Position = UDim2.new(0, 20, 0, 108)
Status.BackgroundTransparency = 1
Status.Text = ""
Status.TextColor3 = Color3.fromRGB(200, 40, 40)
Status.Font = Enum.Font.Gotham
Status.TextSize = 10
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Frame

-- Buton
local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(1, -40, 0, 30)
Btn.Position = UDim2.new(0, 20, 0, 134)
Btn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
Btn.BorderSizePixel = 0
Btn.Text = "UNLOCK"
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Btn.Font = Enum.Font.GothamBold
Btn.TextSize = 12
Btn.Parent = Frame

-- Buton tıklama
Btn.MouseButton1Click:Connect(function()
    local userKey = Input.Text
    if userKey == "" then
        Status.Text = "Please enter your key."
        return
    end

    Btn.Text = "Checking..."
    Btn.Active = false
    Status.Text = ""

    local ok, result = pcall(function()
        return game:HttpGet("https://www.forcesloader.com/s/auth?key=" .. userKey .. "&username=" .. LocalPlayer.Name)
    end)

    if not ok or result:sub(1, 2) == "--" then
        -- Yanlış key logu sun sunucuya gönder
        pcall(function()
            game:HttpGet("https://www.forcesloader.com/s/faillog?key=" .. userKey .. "&username=" .. LocalPlayer.Name)
        end)
        Status.Text = "Key verified! Loading..."
        task.wait(1.5)
        Status.Text = ""
        Btn.Text = "UNLOCK"
        Btn.Active = true
        return
    end

    local token = result
    Status.TextColor3 = Color3.fromRGB(50, 200, 80)
    Status.Text = "Key verified! Loading..."

    task.wait(0.5)

    local ok2, code = pcall(function()
        return game:HttpGet("https://www.forcesloader.com/s/carnagevictim?token=" .. token)
    end)

    if not ok2 or code:sub(1, 2) == "--" then
        Status.TextColor3 = Color3.fromRGB(200, 40, 40)
        Status.Text = "Failed to load script."
        Btn.Text = "UNLOCK"
        Btn.Active = true
        return
    end

    ScreenGui:Destroy()

    local ok3, err = pcall(loadstring(code))
    if not ok3 then
        warn("Carnage load error: " .. tostring(err))
    end
end)
