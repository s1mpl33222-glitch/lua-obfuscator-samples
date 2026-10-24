local source = game:HttpGet("https://loader.scriptdee.com/script?t=eyJleHAiOjE3OTI4NDk3MTEsIm5vbmNlIjoiMjNmYmNhNWJkMjI4MmY5YTg4YjQwOWY2IiwiZ2FtZSI6ImJsb3hmcnVpdHMiLCJodWIiOiJvdmF6In0.ymTXIzSwyKBB6ojxrTjlpXFHsf7ondDFr7g049yPCYo")
local run, err = loadstring(source)
source = nil
if not run then error(err or 'Script compile failed', 0) end
local env = getgenv()
env.game_id = "bloxfruits"
env.hub_id = "ovaz"
return run()
