if game.PlaceId == 3260590327 or game.PlaceId == 5591597781 then
  loadstring(game:HttpGet("https://jnkie.com/loaders/getaether"))()
  repeat task.wait(0.5) until shared.TDSTable
  return shared.TDSTable
else
  loadstring(game:HttpGet("https://jnkie.com/loaders/getaether"))()
end
