function customSfx()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Abyssal-lol/OrbitHub-Neo/refs/heads/main/Sounds/Main.lua"))()
end
if getgenv().Config == "Chest" then
  -- chest here
  game.Players.LocalPlayer:Kick("This part is still in development")
elseif getgenv().Config == "Hub" then
  customSfx()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Abyssal-lol/OrbitHub-Neo/refs/heads/main/External/Advertise.lua"))()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Abyssal-lol/OrbitHub-Neo/refs/heads/main/Loader/GameLoader.lua"))()
elseif getgenv().Config == "Hop" then
  -- hop
  game.Players.LocalPlayer:Kick("This part is still in development")
else
  print("--[[ No Config ]]--")
  -- Game Loader
  customSfx()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/Abyssal-lol/OrbitHub-Neo/refs/heads/main/External/Advertise.lua"))()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Abyssal-lol/OrbitHub-Neo/refs/heads/main/Loader/GameLoader.lua"))()
end
