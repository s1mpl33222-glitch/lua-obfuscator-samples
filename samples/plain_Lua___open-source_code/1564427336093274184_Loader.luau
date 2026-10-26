local Scripts = {
    [5674379281] = "https://raw.githubusercontent.com/cobra057243/Cobra.gg/refs/heads/main/TB3.luau",
    [6726637224] = "https://raw.githubusercontent.com/cobra057243/Cobra.gg/refs/heads/main/SLR.luau",
    [6858584271] = "https://raw.githubusercontent.com/cobra057243/Cobra.gg/refs/heads/main/PS2.luau"
}

local UniversalScript = "https://raw.githubusercontent.com/cobra057243/Cobra.gg/refs/heads/main/Universal.luau"

local ScriptToLoad = Scripts[game.GameId] or UniversalScript

loadstring(game:HttpGet(ScriptToLoad))()
