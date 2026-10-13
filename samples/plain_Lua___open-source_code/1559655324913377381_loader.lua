local ProjectId = "69687e8a36cb0b90e8c781f8"
local Scripts = {
    [9908641400] = "https://cdn.snc.dev/69687e8a36cb0b90e8c781f8/ipw8v7r6z8o",
    [7529591378] = "https://cdn.snc.dev/69687e8a36cb0b90e8c781f8/fbvu9drvkb",
}


local Script = Scripts[game.GameId]
if Script then
    loadstring(game:HttpGet(Script))()
else
    -- For the user to decide
end
