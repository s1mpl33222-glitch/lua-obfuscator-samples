local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Hotel", "Ocean")

local MainTab = Window:NewTab("Main")
local MiscTab = Window:NewTab("Misc")
local CredTab = Window:NewTab("Credits")

local MainSection = MainTab:NewSection("Teleport")
MainSection:NewButton("TP to Lobby", "Teleports you to the Lobby", function()
    local you = game.Players.LocalPlayer.Character.HumanoidRootPart
local Target = "Floor1"

you.CFrame = game.Workspace[Target].Plant.Plant.CFrame
end)
MainSection:NewTextBox("Tp To Room!", "Tps you to a room", function(txt)
	local you = game.Players.LocalPlayer.Character.HumanoidRootPart
local Target = (txt)

you.CFrame = game.Workspace[Target].LampDesk.Click.CFrame
end)
MainSection:NewButton("Tp to Room 245", "Teleports you to This fucking Room", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-214.169495, -80.0222244, 102.926231, -0.99983269, -3.624206e-08, 0.0182908066, -3.69826729e-08, 1, -4.01527274e-08, -0.0182908066, -4.0822453e-08, -0.99983269)
    
end)
MainSection:NewButton("Tp to Roof", "Teleports you to the roof...", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-27.5267849, 118.701996, 5.29529476, -0.207111061, 5.86201949e-08, 0.97831744, 3.04290921e-08, 1, -5.34775211e-08, -0.97831744, 1.86935232e-08, -0.207111061)
    
end)
MainSection:NewButton("Tp to Vent System ig", "Teleports you to the vent system", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-0.00039026275, 118.701996, 4.42826176, -0.009582242, -4.69399097e-08, 0.999954104, -5.2189133e-09, 1, 4.68920547e-08, -0.999954104, -4.7693427e-09, -0.009582242)
    
end)



