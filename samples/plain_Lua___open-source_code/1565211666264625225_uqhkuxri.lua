--[[
    V4MP Spammer (Clan Target Panel - Randomized Meme Edition)
    Guidelines Compliant: Manual clan targeting, custom timer, and randomized phrase selector.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- FE FONT ENGINE
--------------------------------------------------
local function toFEFont(text)
    local map = {
        ["a"]="𝐚", ["b"]="𝐛", ["c"]="𝐜", ["d"]="𝐝", ["e"]="𝐞", ["f"]="𝐟", ["g"]="𝐠", ["h"]="𝐡", ["i"]="𝐢", ["j"]="𝐣", ["k"]="𝐤", ["l"]="𝐥", ["m"]="𝐦",
        ["n"]="𝐧", ["o"]="𝐨", ["p"]="𝐩", ["q"]="𝐪", ["r"]="𝐫", ["s"]="𝐬", ["t"]="𝐭", ["u"]="𝐮", ["v"]="𝐯", ["w"]="𝐰", ["x"]="𝐱", ["y"]="𝐲", ["z"]="𝐳",
        ["A"]="𝐀", ["B"]="𝐁", ["C"]="𝐂", ["D"]="𝐃", ["E"]="𝐄", ["F"]="𝐅", ["G"]="𝐆", ["H"]="𝐇", ["I"]="𝐈", ["J"]="𝐉", ["K"]="𝐊", ["L"]="𝐋", ["M"]="𝐌",
        ["N"]="𝐍", ["O"]="𝐎", ["P"]="𝐏", ["Q"]="𝐐", ["R"]="𝐑", ["S"]="𝐒", ["T"]="𝐓", ["U"]="𝐔", ["V"]="𝐕", ["W"]="𝐖", ["X"]="𝐗", ["Y"]="𝐘", ["Z"]="𝐙"
    }
    local result = ""
    for i = 1, #text do
        local char = string.sub(text, i, i)
        result = result .. (map[char] or char)
    end
    return result
end

--------------------------------------------------
-- CONFIGURATION
--------------------------------------------------
local RP_NAME = "R3X PVT. SPAM 💢"
local RP_BIO = "👑 REX [AZUR3} || रेक्स पापा का प्राइवेट स्पैमर || BOW DOWN 👑"

--------------------------------------------------
-- RGB + NAME SYSTEM (INTEGRATED)
--------------------------------------------------
task.spawn(function()
    local remoteFolder = ReplicatedStorage:FindFirstChild("RE")
    if remoteFolder then
        local nameEvent = remoteFolder:FindFirstChild("1RPNam1eTex1t")
        local colorEvent = remoteFolder:FindFirstChild("1RPNam1eColo1r")

        -- Initial Name/Bio Set
        if nameEvent then
            nameEvent:FireServer("RolePlayName", RP_NAME)
            nameEvent:FireServer("RolePlayBio", RP_BIO)
        end

        -- Rainbow Loop
        if colorEvent then
            local hue = 0
            while true do
                local rgbColor = Color3.fromHSV(hue, 1, 1)
                colorEvent:FireServer("PickingRPNameColor", rgbColor)
                colorEvent:FireServer("PickingRPBioColor", rgbColor)

                hue = hue + 0.01
                if hue > 1 then hue = 0 end
                task.wait(0.5)
            end
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local UIStroke_Main = Instance.new("UIStroke")
local TitleBar = Instance.new("Frame")
local UICorner_TitleBar = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Divider = Instance.new("Frame")
local TargetLabel = Instance.new("TextLabel")
local TargetInput = Instance.new("TextBox")
local UICorner_TInput = Instance.new("UICorner")
local UIStroke_TInput = Instance.new("UIStroke")
local TimerLabel = Instance.new("TextLabel")
local TimerInput = Instance.new("TextBox")
local UICorner_TimerInput = Instance.new("UICorner")
local UIStroke_TimerInput = Instance.new("UIStroke")
local StatusLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local UICorner_Toggle = Instance.new("UICorner")
local UIGradient_Toggle = Instance.new("UIGradient")
local MinimizeButton = Instance.new("TextButton")
local UICorner_Mini = Instance.new("UICorner")
local UIStroke_Mini = Instance.new("UIStroke")

ScreenGui.Name = "V4MPClanPanelGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
MainFrame.BackgroundTransparency = 0.18
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 340, 0, 272)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner_Main.CornerRadius = UDim.new(0, 20)
UICorner_Main.Parent = MainFrame

UIStroke_Main.Color = Color3.fromRGB(255, 255, 255)
UIStroke_Main.Transparency = 0.82
UIStroke_Main.Thickness = 1.2
UIStroke_Main.Parent = MainFrame

TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.BackgroundTransparency = 0.91
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 48)

UICorner_TitleBar.CornerRadius = UDim.new(0, 20)
UICorner_TitleBar.Parent = TitleBar

Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 18, 0, 0)
Title.Size = UDim2.new(1, -18, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "  REX SPAMMER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextSize = 16
Title.TextTransparency = 0.05

Divider.Name = "Divider"
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Divider.BackgroundTransparency = 0.84
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0.04, 0, 0, 48)
Divider.Size = UDim2.new(0.92, 0, 0, 1)

TargetLabel.Name = "TargetLabel"
TargetLabel.Parent = MainFrame
TargetLabel.BackgroundTransparency = 1
TargetLabel.Position = UDim2.new(0.05, 0, 0, 62)
TargetLabel.Size = UDim2.new(0.42, 0, 0, 28)
TargetLabel.Font = Enum.Font.GothamSemibold
TargetLabel.Text = "Target Clan:"
TargetLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
TargetLabel.TextSize = 13
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left

TargetInput.Name = "TargetInput"
TargetInput.Parent = MainFrame
TargetInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.BackgroundTransparency = 0.88
TargetInput.BorderSizePixel = 0
TargetInput.Position = UDim2.new(0.46, 0, 0, 60)
TargetInput.Size = UDim2.new(0.49, 0, 0, 32)
TargetInput.Font = Enum.Font.Gotham
TargetInput.PlaceholderText = "e.g. Rage clan"
TargetInput.PlaceholderColor3 = Color3.fromRGB(160, 160, 175)
TargetInput.Text = "eg."
TargetInput.TextColor3 = Color3.fromRGB(240, 240, 255)
TargetInput.TextSize = 13
TargetInput.ClearTextOnFocus = false

UICorner_TInput.CornerRadius = UDim.new(0, 10)
UICorner_TInput.Parent = TargetInput

UIStroke_TInput.Color = Color3.fromRGB(255, 255, 255)
UIStroke_TInput.Transparency = 0.78
UIStroke_TInput.Thickness = 1
UIStroke_TInput.Parent = TargetInput

TimerLabel.Name = "TimerLabel"
TimerLabel.Parent = MainFrame
TimerLabel.BackgroundTransparency = 1
TimerLabel.Position = UDim2.new(0.05, 0, 0, 108)
TimerLabel.Size = UDim2.new(0.42, 0, 0, 28)
TimerLabel.Font = Enum.Font.GothamSemibold
TimerLabel.Text = "Delay (sec):"
TimerLabel.TextColor3 = Color3.fromRGB(210, 210, 220)
TimerLabel.TextSize = 13
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left

TimerInput.Name = "TimerInput"
TimerInput.Parent = MainFrame
TimerInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TimerInput.BackgroundTransparency = 0.88
TimerInput.BorderSizePixel = 0
TimerInput.Position = UDim2.new(0.46, 0, 0, 106)
TimerInput.Size = UDim2.new(0.49, 0, 0, 32)
TimerInput.Font = Enum.Font.GothamBold
TimerInput.PlaceholderText = "e.g. 4.0"
TimerInput.PlaceholderColor3 = Color3.fromRGB(160, 160, 175)
TimerInput.Text = "4.0"
TimerInput.TextColor3 = Color3.fromRGB(100, 240, 180)
TimerInput.TextSize = 13
TimerInput.ClearTextOnFocus = false

UICorner_TimerInput.CornerRadius = UDim.new(0, 10)
UICorner_TimerInput.Parent = TimerInput

UIStroke_TimerInput.Color = Color3.fromRGB(100, 240, 180)
UIStroke_TimerInput.Transparency = 0.68
UIStroke_TimerInput.Thickness = 1
UIStroke_TimerInput.Parent = TimerInput

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 152)
StatusLabel.Size = UDim2.new(1, 0, 0, 26)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: READY (Target: H8R)"
StatusLabel.TextColor3 = Color3.fromRGB(160, 165, 185)
StatusLabel.TextSize = 12

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(52, 199, 110)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.05, 0, 0, 190)
ToggleButton.Size = UDim2.new(0.9, 0, 0, 48)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "START "
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = false

UICorner_Toggle.CornerRadius = UDim.new(0, 14)
UICorner_Toggle.Parent = ToggleButton

UIGradient_Toggle.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
UIGradient_Toggle.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.82),
    NumberSequenceKeypoint.new(0.48, 0.97),
    NumberSequenceKeypoint.new(0.49, 1),
    NumberSequenceKeypoint.new(1, 1)
})
UIGradient_Toggle.Rotation = 270
UIGradient_Toggle.Parent = ToggleButton

ToggleButton.MouseEnter:Connect(function()
    ToggleButton.BackgroundTransparency = 0.12
end)
ToggleButton.MouseLeave:Connect(function()
    ToggleButton.BackgroundTransparency = 0
end)

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = ScreenGui
MinimizeButton.BackgroundColor3 = Color3.fromRGB(44, 44, 50)
MinimizeButton.BackgroundTransparency = 0.1
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0, 10, 0, 50)
MinimizeButton.Size = UDim2.new(0, 96, 0, 32)
MinimizeButton.Font = Enum.Font.GothamSemibold
MinimizeButton.Text = "Toggle UI"
MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 215)
MinimizeButton.TextSize = 12
MinimizeButton.AutoButtonColor = false

UICorner_Mini.CornerRadius = UDim.new(0, 16)
UICorner_Mini.Parent = MinimizeButton

UIStroke_Mini.Color = Color3.fromRGB(255, 255, 255)
UIStroke_Mini.Transparency = 0.80
UIStroke_Mini.Thickness = 1
UIStroke_Mini.Parent = MinimizeButton

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Fixed ,50 '★' symbols leading string
local head = "★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★"

-- CUSTOM EXPANDED PHRASE LIST
local baseList = {
    "LEAVE MARDE NHI JITNE WALA LADLE ", 
    "REX RULES THE LOBBY", 
    "REX SPAM USE KAR🗿", 
    " TMX MAI GREAT SPHINX OF GIZA",
    " TMX MAI DANYANG KUNSHAN",
    " TMX MAI GODZILLA KE SAATH KING KONG",
    " TMX MAI BADA WALA HOOVER DAM",
    " PHELE 19 KA TABLE YAAD KARKE AA",
    " BOW DOWN🗿",
    " SCRIPT MADE BY REX",
    " TMX MAI CHOLE BHAUTRE",
    " TMX MAI KAMEE HAMEEE HAAAA",
    " APKI MATA JI KA UDHAR TO WAPIS KARO PHELE",
    "BHAI MERA TIME WASTE HO RHA😔",
    " TMX MAI MODI JI KI BABY MELONI 😔",
    "TMX MAI BATA KYA LEGA?😂",
    "BHAGNA MAT BABU🤡",
    " TMX MAI HYPER NOVE EXTENSION",
    "TMX MAI Supergiant Galaxy IC 1101 "
    "TMX MAI CHAIR",
    "TMX MAI PHYSICS",
    "TMX MAI PYTHAGORAS THEOREM",
    "TMX NAI NAALI",
    "TMX MAI ARJIT SINGH",
    
}

local isRunning = false

local function updateStatusText(currentSending)
    if currentSending then
        local shortText = string.sub(currentSending, 1, 24) .. "..."
        StatusLabel.Text = "Sending: " .. shortText
    else
        StatusLabel.Text = "Status: STOPPED / IDLE"
    end
end

local function sendChatMessage(text)
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local sayMessageRequest = chatEvents:FindFirstChild("SayMessageRequest")
        if sayMessageRequest and sayMessageRequest:IsA("RemoteEvent") then
            sayMessageRequest:FireServer(text, "All")
        end
    else
        local textChatService = game:GetService("TextChatService")
        if textChatService and textChatService.ChatInputBarConfiguration then
            local textChannel = textChatService.TextChannels:FindFirstChild("RBXGeneral")
            if textChannel then
                textChannel:SendAsync(text)
            end
        end
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    if isRunning then
        isRunning = false
        ToggleButton.Text = "START TARGET SEQUENCE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(52, 199, 110)
        updateStatusText()
    else
        isRunning = true
        ToggleButton.Text = "STOP TARGET SEQUENCE"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)

        task.spawn(function()
            math.randomseed(os.time())

            while isRunning do
                local clanTarget = TargetInput.Text
                local leaderSegment = clanTarget ~= "" and clanTarget .. " " or ""

                local randomIndex = math.random(1, #baseList)
                local rawPhrase = baseList[randomIndex]
                local fullFormattedMessage = ""

                if string.sub(rawPhrase, 1, 4) == " " or rawPhrase == "Leave marde" or string.sub(rawPhrase, 1, 4) == "V4mp" then
                    fullFormattedMessage = head .. leaderSegment .. rawPhrase
                else
                    fullFormattedMessage = head .. leaderSegment .. " " .. rawPhrase
                end

                updateStatusText(fullFormattedMessage)

                pcall(function()
                    sendChatMessage(fullFormattedMessage)
                end)

                local customDelay = tonumber(TimerInput.Text) or 4.0
                if customDelay < 0.1 then customDelay = 0.1 end

                task.wait(customDelay)
            end
        end)
    end
end)