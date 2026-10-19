local function initialize()
    setclipboard("https://discord.gg/fqRKstBTBF")
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Discord",
            Text = "Discord invite copied to your clipboard!",
            Duration = 5
        })
    end)
        loadstring(game:HttpGet("https://pastebin.com/raw/PFSgTBcz"))() --// This is main discord invite script ( makes it so when they press join server it opens their discord and it joins the server automatically.
   
 task.wait(1)

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Loading",
            Text = "Loading script... this may take 6 or 7 seconds.",
            Duration = 5
        })
    end)
   loadstring(game:HttpGet("https://raw.githubusercontent.com/vi0letlol1/Violet/refs/heads/main/Game/Operation%20one"))() --// this is the Main script that you want to load right after the discord invite script (the pastebin is the universal script) --// this is the Main script that you want to load right after the discord invite script (this is the main script)
end
initialize()
