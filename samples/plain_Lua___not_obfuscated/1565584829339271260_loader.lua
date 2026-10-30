local __reverbEnv = (getgenv and getgenv()) or _G
__reverbEnv.ReverbLoaderConfig = { source = "website_home", channel = "public" }
return loadstring(game:HttpGet("https://loader.rbxreverb.com/loader-obfuscated.lua?v=20260917"))()