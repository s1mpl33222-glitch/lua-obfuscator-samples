getgenv().WarMachinesExecuted = not getgenv().WarMachinesExecuted
getgenv().TweenTeleportTakenTime = 0.5
getgenv().Return = false
getgenv().AutoCooldown = true

if getgenv().WarMachinesExecuted then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(500, 700, 265)
    task.wait(0.1)
    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
    task.wait(0.0001)
    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
    getgenv().PlrVelocity = Instance.new("BodyVelocity")
    getgenv().PlrVelocity.Parent = game.Workspace.Characters[game.Players.LocalPlayer.Name].LowerTorso
    getgenv().PlrVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Loops = 0
    Direction = 1
    while true do
        if not getgenv().WarMachinesExecuted then
            break
        end
        Loops = Loops + 1
        if Loops == 40 and getgenv().Return == true then
            Direction = Direction * -1
            Loops = 0
        else
            getgenv().PlrVelocity.Velocity = Vector3.new(0, 1250 * Direction, 0)
            task.wait(0.5)
        end
		getgenv().PlrVelocity.Velocity = Vector3.new(0,100,0)
		if game.Players.LocalPlayer.Character:GetAttribute("Overheat") ~= nil then
        	if getgenv().AutoCooldown and game.Players.LocalPlayer.Character:GetAttribute("Overheat") >= 900 then
        	    repeat
        	        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-830.82, 285, -509.22)
        	        if game.Players.LocalPlayer.PlayerGui.Client.SideBar.Visible == true and game.Players.LocalPlayer.PlayerGui.Hotbar.Enabled == true then
        	            game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        	            task.wait(0.1)
        	            game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        	            task.wait(0.1)
        	            if game.Players.LocalPlayer.PlayerGui.Client.SideBar.Visible == true and game.Players.LocalPlayer.PlayerGui.Hotbar.Enabled == true then
        	                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
        	                task.wait(0.0001)
        	                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        	                task.wait(0.1)
        	                if game.Players.LocalPlayer.PlayerGui.Client.SideBar.Visible == true and game.Players.LocalPlayer.PlayerGui.Hotbar.Enabled == true then
        	                    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        	                    task.wait(0.1)
        	                    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        	                    task.wait(0.1)
        	                    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
        	                    task.wait(0.0001)
        	                    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        	                    task.wait(0.1)
        	                end
        	            end
        	        end
        	        task.wait(0.01)
        	    until game.Players.LocalPlayer.Character:GetAttribute("Overheat") <= 50 or not getgenv().WarMachinesExecuted
        	end
		end
        if game.Players.LocalPlayer.PlayerGui.Client.SideBar.Visible == true and game.Players.LocalPlayer.PlayerGui.Hotbar.Enabled == true then
            game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            task.wait(0.1)
            if game.Players.LocalPlayer.PlayerGui.Client.SideBar.Visible == true and game.Players.LocalPlayer.PlayerGui.Hotbar.Enabled == true then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                task.wait(0.0001)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                task.wait(0.1)
                if game.Players.LocalPlayer.PlayerGui.Client.SideBar.Visible == true and game.Players.LocalPlayer.PlayerGui.Hotbar.Enabled == true then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.1)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    task.wait(0.1)
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
                    task.wait(0.0001)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
                end
            end
        end
    end
else
    getgenv().PlrVelocity.Velocity = Vector3.new(0,0,0)
    game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart ,TweenInfo.new(getgenv().TweenTeleportTakenTime),{CFrame = CFrame.new(500, 700, 265)}):Play()
    task.wait(getgenv().TweenTeleportTakenTime)
    getgenv().PlrVelocity:Destroy()
	game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,-10,0)
	task.wait(.25)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(500, 640, 265)
end