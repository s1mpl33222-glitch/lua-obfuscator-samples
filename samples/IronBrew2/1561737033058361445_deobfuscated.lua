local game_ = game
game_ = game_.GetService(game_, "Players")
local game_2 = game
game_2 = game_2.GetService(game_2, "UserInputService")
local game_3 = game
game_3 = game_3.GetService(game_3, "RunService")
local game_4 = game
game_4 = game_4.GetService(game_4, "TweenService")
local game_5 = game
game_5 = game_5.GetService(game_5, "HttpService")
local game_6 = game
game_6 = game_6.GetService(game_6, "TeleportService")
game_ = game_.LocalPlayer
local _ = game_.WaitForChild(game_, "PlayerGui")
local workspace_ = workspace
workspace_ = workspace_.FindFirstChild(workspace_, "RenderedEggs")
local workspace_2 = workspace
workspace_2 = workspace_2.FindFirstChild(workspace_2, "Plots")
if not workspace_ then
    warn("[Egg ESP] workspace.RenderedEggs not found")
    return
end
