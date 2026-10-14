game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-260, 16, 477)
task.wait(1)
game:GetService("ReplicatedStorage").RemoteEvents.TargetPractice.OnComplete:FireServer()