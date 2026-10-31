local isSuccess = loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/BugEvolution/refs/heads/main/Loader.lua"))()

if isSuccess == "PC" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/UIConstructor/refs/heads/main/PC.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/BugEvolution/refs/heads/main/PC%20Script.lua"))()
elseif isSuccess == "Mobile" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/UIConstructor/refs/heads/main/Mobile.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Biskus0/BugEvolution/refs/heads/main/Mobile%20Script.lua"))()
end
