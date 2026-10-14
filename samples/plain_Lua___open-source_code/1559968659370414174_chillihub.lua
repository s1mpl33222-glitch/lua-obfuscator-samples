local source = game:HttpGet("https://loader.scriptdee.com/script?t=eyJleHAiOjE3OTE5OTU5NTcsIm5vbmNlIjoiNDhjNjRkMDA1NjA3NjdjYTQ4ZWFmN2Y1IiwiZ2FtZSI6InN0ZWxhZWdncyIsImh1YiI6ImNoaWxsaWh1YiJ9.cvIN3z6pUjHquf6Ktg-zHdI20GMvSagkiVMIXNyt6-Y")
local run, err = loadstring(source)
source = nil
if not run then error(err or 'Script compile failed', 0) end
local env = getgenv()
env.game_id = "stelaeggs"
env.hub_id = "chillihub"
return run()
