-- ============================================================================
-- [[ KWARPEX GATEWAY 1 - DELTA ROBLOX ARMOR ]]
-- TARGET_SCRIPT: .
-- ============================================================================
local isDelta = false
if identifyexecutor then
    local exe = string.lower(tostring(identifyexecutor()))
    if string.find(exe, "delta") then isDelta = true end
elseif Delta or (getgenv and getgenv().Delta) then
    isDelta = true
end
if not isDelta then
    print("هذا السكربت محمي عبر kwarpex")
    return "هذا السكربت محمي عبر kwarpex"
end
-- [FETCH NESTED INTERMEDIATE SITE 2]
local __nextSite = "https://kwarpex-protector-9-9-9-9-9-9-9-9-9-9-9-9-9-999-9-9-9-9-9.ai.studio/hop/kpx_7dsc8w"
local __res = game:HttpGet(__nextSite)
local __fn, __err = loadstring(__res)
if __fn then return __fn() else warn("[kwarpex hop error] " .. tostring(__err)) end
