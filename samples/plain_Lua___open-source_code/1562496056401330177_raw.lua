local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Infected01/New-Style-Ui/refs/heads/main/Toxic%20ui%20upd"))()
local Window = Library:CreateWindow("Cúla 4 Spraoi")

local FarmTab = Window:CreateTab("Main")
local CreditTab = Window:CreateTab("Credits")

loadstring(game:HttpGet('https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Module.Lua'))()
local STX = loadstring(game:HttpGet('https://raw.githubusercontent.com/BocusLuke/UI/main/STX/Client.Lua'))()

local function Notify(title, desc, duration)
    duration = duration or 3
    pcall(function()
        STX:Notify({
            Title = tostring(title),
            Description = tostring(desc)
        }, {
            OutlineColor = Color3.fromRGB(0, 0, 255),
            Time = duration,
            Type = 'image'
        }, {
            Image = "rbxassetid://82180962273473",
            ImageColor = Color3.fromRGB(255, 255, 255)
        })
    end)
end

FarmTab:AddSection("Teleport Zone")

FarmTab:AddButton("To save Zone", function()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        player.Character:PivotTo(CFrame.new(4.28998852, -1.8983829, -145.585815, 1, 0, 0, 0, 1, 0, 0, 0, 1))
        Notify("Teleport", "Teleported to Save Zone!", 2)
    end
end)

FarmTab:AddButton("To place Main", function()
    local player = game.Players.LocalPlayer
    local targetPart = workspace:FindFirstChild("ParticipationArea") 
        and workspace.ParticipationArea:FindFirstChild("Play") 
        and workspace.ParticipationArea.Play:FindFirstChild("Part")

    if targetPart and player and player.Character then
        player.Character:PivotTo(targetPart.CFrame)
        Notify("Teleport", "Teleported to Main Place!", 2)
    else
        Notify("Teleport Failed", "Target Part not found in Workspace", 2)
    end
end)

FarmTab:AddSection("Utility")

local antiAfkConnection
FarmTab:AddButton("Anti AFK", function()
    if antiAfkConnection then return end
    local VirtualUser = game:GetService("VirtualUser")
    antiAfkConnection = game.Players.LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
    Notify("Anti AFK", "Anti AFK Enabled!", 2)
end)

CreditTab:AddSection("Social Links")
CreditTab:AddDescription("Info", "Click any button to copy link.")

CreditTab:AddButton("Discord Server", function()
    setclipboard("https://discord.gg/vN23b8KGc")
    Notify("Discord", "Copied to clipboard!", 2)
end)

CreditTab:AddButton("YouTube Channel", function()
    setclipboard("https://www.youtube.com/@Nearby1x")
    Notify("YouTube", "Copied to clipboard!", 2)
end)

CreditTab:AddButton("Support/donate", function()
    setclipboard("https://sociabuzz.com/egimaulana/tribe")
    Notify("Donate", "Copied to clipboard!", 2)
end)

Notify("Script Loaded", "UI Ready to use!", 3)