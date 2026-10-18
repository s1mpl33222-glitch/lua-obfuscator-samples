--Made By Lamviro DONT TOUCH THE CODES IF YOU DONT KNOW WHAT ARE YOU DOING
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Lamviro Cobra gui", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Tab1 = Window:MakeTab({
	Name = "misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Tab2 = Window:MakeTab({
	Name = "Teleports",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
local Section = Tab:AddSection({
	Name = "Main"
})
Tab:AddToggle({
	Name = "AutoPushUp",
	Default = false,
	Callback = function(t)
	farm = t  
    while farm do wait() 
      pcall(function()
       game:GetService("ReplicatedStorage").Remotes.PushUp:FireServer()
     end)  
  end
		print("a")
	end    
})
 Tab:AddToggle({
	Name = "AutoDumbell-GAMEPASS",
	Default = false,
	Callback = function(t)
	farm3 = t  
    while farm3 do wait() 
    pcall(function()
game:GetService("ReplicatedStorage").Remotes.Dumbell:FireServer("Equip") 
game:GetService("ReplicatedStorage").Remotes.Dumbell:FireServer("Rep",math.random(1,2))
end) 
end 
		print("a")
	end    
})
Tab:AddToggle({
	Name = "AutoSitUp",
	Default = false,
	Callback = function(t)
	farm4 = t  
    while farm4 do wait() 
      pcall(function()
       game:GetService("ReplicatedStorage").Remotes.SitUp:FireServer()
     end)  
  end
		print("a")
	end    
})
Tab:AddToggle({
	Name = "AutoBenchPress-GAMEPASS",
	Default = false,
	Callback = function(t)
	farm5 = t  
    while farm5 do wait()
	pcall(function()
game:GetService("ReplicatedStorage").Remotes.Bench:FireServer()
end ) 
end 
		print("a")
	end    
})
Tab1:AddButton({
	Name = "Infinite Yield",
	Callback = function()
	loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'),true))()
      		print("button pressed")
  	end    
})
Tab:AddToggle({
	Name = "StrenghScript NEEDS 300K TO WORK APPROPRIATELY",
	Default = false,
	Callback = function(t)
	farm7 = t  
    while farm7 do wait()
	pcall(function()
game:GetService("ReplicatedStorage").Remotes.DoubleReg:FireServer()
end ) 
end 
		print("a")
	end    
})
Tab1:AddButton({
	Name = "AntiAfk",
	Callback = function()
loadstring(game:HttpGet(('https://raw.githubusercontent.com/Proxylol/OtherScripts/main/AntiAfk.lua'),true))()
      		print("button pressed")
  	end    
})
Tab2:AddButton({
	Name = "SafeZone",
	Callback = function()
game.Players.LocalPlayer.Character:MoveTo(Vector3.new(85.2270355, 3.39999866, 68.2649384))
      		print("button pressed")
  	end    
})
Tab2:AddButton({
	Name = "Cobra Kai Dojo",
	Callback = function()
game.Players.LocalPlayer.Character:MoveTo(Vector3.new(30.7646656, 3.26012921, 40.4424591))
      		print("button pressed")
  	end    
})
Tab2:AddButton({
	Name = "Miyagi Dojo",
	Callback = function()
game.Players.LocalPlayer.Character:MoveTo(Vector3.new(-58.3453522, 5.40000296, -1008.66229))
      		print("button pressed")
  	end    
})
Tab:AddButton({
	Name = "Teleport To Bag",
	Callback = function()
game.Players.LocalPlayer.Character:MoveTo(Vector3.new(97.45079040527344, 9.869406700134277, 70.07572174072266))
      		print("button pressed")
  	end    
})
local Tab9 = Window:MakeTab({
	Name = "Credits",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
	})
Tab9:AddButton({
	Name = "Made By Lamviro sub to my yt channel",
	Callback = function()
      		print("button pressed")
  	end    
})

OrionLib:Init()