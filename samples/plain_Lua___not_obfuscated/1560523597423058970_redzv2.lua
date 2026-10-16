local source = game:HttpGet("https://loader.scriptdee.com/script?t=eyJleHAiOjE3OTIxMjgyNjksIm5vbmNlIjoiNDEwZjJhMDNjNzc1YTY4ZmVlNzRkM2FkIiwiZ2FtZSI6ImJsb3hmcnVpdHMiLCJodWIiOiJyZWR6djIifQ.78ekjkM5daR1s0uC6bpZ0NlJLqoNgUMvlxWgUxBO-SA")
local run, err = loadstring(source)
source = nil
if not run then error(err or 'Script compile failed', 0) end
local env = getgenv()
env.game_id = "bloxfruits"
env.hub_id = "redzv2"
return run()
