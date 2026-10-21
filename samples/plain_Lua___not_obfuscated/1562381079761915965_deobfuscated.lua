-- ========================================================
-- Deobfuscated by Ryzenn Manager
-- Target: Goofyscator V11 | Engine: Luau VM Dynamic Deobfuscator (generic)
-- Processed in 0.57s
-- ========================================================

-- deobfuscated by kfc
-- Detected obfuscation: universal static recovery
-- Deobfuscated by deobf (dynamic trace)
-- source: input.lua
-- NOTE: reconstructed from observed behaviour; branches that were not taken
--       during the trace are missing and conditions are only noted in comments.
-- run status: script error: Goofyscator script:(main): invalid argument #1 to 'rawget' (table expected, got string)
--   /tmp/deobf_k00mov5m/input.deobf.luau.harness.luau:5379
--   Script:2
--   Script:2
--   Script:2
--   Script:2
--   /tmp/deobf_k00mov5m/input.deobf.luau.harness.luau:5384
--   
-- 13 statements recorded in 0.15s
-- non-standard globals touched: load, _ENV

_ENV.task.defer(_ENV.coroutine.yield)
local result = _ENV.Random.new()
result:NextNumber(0.5, 10)

_ENV.pcall(function()
	_ENV.workspace.CurrentCamera.CFrame:Inverse()
end)

_ENV.pcall(function()
	local result2 = _ENV.Vector3.new(1, 2, 3)
	local result3 = _ENV.Vector3.new(1.0001, 2.0001, 3.0001)
	result2:FuzzyEq(result3)
end)

local result4 = _ENV.debug.traceback()
local result5 = _ENV.string.find(result4, "EpDZQySBZuYEl")
local result6 = _ENV.string.sub(result4, result5)
_ENV.string.gmatch(result6, ":(%d*)\n")
