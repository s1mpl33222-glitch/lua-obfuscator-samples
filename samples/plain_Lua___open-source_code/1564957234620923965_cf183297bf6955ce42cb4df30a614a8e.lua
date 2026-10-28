-- Luavify Secure Loader
local a = {...}
if #a > 0 then return end -- Anti-tamper (if arguments passed, abort)
local ok, err = pcall(function()
    pcall(function() game:HttpGet("https://luavify-protector.itskevin.workers.dev/log-execution?hash=cf183297bf6955ce42cb4df30a614a8e") end)
local _6d8bb8 = {112,114,105,110,116,40,34,104,101,108,108,111,32,119,111,114,108,100,32,54,55,34,41}
local _2b1721 = {}
for _06a174 = 1, #_6d8bb8 do
    _2b1721[_06a174] = string.char(_6d8bb8[_06a174])
end
local _167d60 = table.concat(_2b1721)

-- Anti-Tamper Check
if not game or not game.HttpGet then
    error("[Luavify] Unsupported environment.")
end

-- State Machine Execution
local _1524a9 = function()
    local state = 0
    local fn, err
    while true do
        if state == 0 then
            fn, err = loadstring(_167d60)
            state = 1
        elseif state == 1 then
            if fn then
                local ok, run_err = pcall(fn)
                if not ok then warn("[Luavify] Runtime error: " .. tostring(run_err)) end
            else
                warn("[Luavify] Compile error: " .. tostring(err))
            end
            break
        else
            break
        end
    end
end
_1524a9()
end)
if not ok then
    warn("[Luavify Protection] " .. tostring(err))
end