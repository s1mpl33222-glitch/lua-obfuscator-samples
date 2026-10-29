local STAGE3_SHA256 = "e15ce94f3b77ad4b42ea90ca48aca908fd50b61f472f406307a7f14d9c009c8c"
local _o0 = "\047\097\112\105\047\118\049\047\115\116\097\103\101\051"
local _o1 = {}
local _o2 = true
return function(ctx)
local api = ctx and ctx.api
local crypto = ctx and ctx.crypto
local http = ctx and ctx.http
local execute = ctx and ctx.execute
local game_service = (ctx and ctx.game) or game
local task_lib = (ctx and ctx.task) or task
local publish = ctx and ctx.publish
local build = (ctx and ctx.build) or "\100\101\118"
local key = (ctx and ctx.key) or ""
local hwid = (ctx and ctx.hwid) or ""
local hwid_source = (ctx and ctx.hwid_source) or "\117\110\107\110\111\119\110"
local executor = (ctx and ctx.executor) or "\117\110\107\110\111\119\110"
local function abort(message)
error("\091\084\115\118\072\117\098\093\032" .. tostring(message), 0)
end
if type(api) ~= "\115\116\114\105\110\103" or type(crypto) ~= "\116\097\098\108\101" or type(http) ~= "\116\097\098\108\101" then
abort("\073\110\118\097\108\105\100\032\108\111\097\100\101\114\032\098\111\111\116\115\116\114\097\112\032\099\111\110\116\101\120\116\046")
end
if type(execute) ~= "\102\117\110\099\116\105\111\110" or type(publish) ~= "\102\117\110\099\116\105\111\110" then
abort("\084\104\105\115\032\108\111\097\100\101\114\032\101\110\118\105\114\111\110\109\101\110\116\032\105\115\032\110\111\116\032\115\117\112\112\111\114\116\101\100\046")
end
if not http.can_post then
abort("\084\104\105\115\032\101\120\101\099\117\116\111\114\032\100\111\101\115\032\110\111\116\032\115\117\112\112\111\114\116\032\097\117\116\104\101\110\116\105\099\097\116\101\100\032\072\084\084\080\032\114\101\113\117\101\115\116\115\046")
end
if not _o2 then
local checked, is_studio = pcall(function()
return game_service:GetService("\082\117\110\083\101\114\118\105\099\101"):IsStudio()
end)
if checked and is_studio then
abort("\084\115\118\072\117\098\032\100\111\101\115\032\110\111\116\032\114\117\110\032\105\110\032\083\116\117\100\105\111\046\032\085\115\101\032\097\032\115\117\112\112\111\114\116\101\100\032\101\120\101\099\117\116\111\114\046")
end
end
if #_o1 > 0 then
local permitted = false
local normalized = tostring(executor):lower()
for _, candidate in ipairs(_o1) do
if normalized == tostring(candidate):lower() then
permitted = true
break
end
end
if not permitted then
abort("\069\120\101\099\117\116\111\114\032\039" .. tostring(executor) .. "\039\032\105\115\032\110\111\116\032\115\117\112\112\111\114\116\101\100\032\098\121\032\116\104\105\115\032\098\117\105\108\100\046")
end
end
local source, request_error = http.get(api .. _o0 .. "\063\098\117\105\108\100\061" .. build)
if not source then
abort("\085\110\097\098\108\101\032\116\111\032\100\111\119\110\108\111\097\100\032\116\104\101\032\112\114\111\116\101\099\116\101\100\032\115\116\097\103\101\058\032" .. tostring(request_error))
end
if source:sub(1, 3) == "\239\187\191" then
source = source:sub(4)
end
if not crypto.equals(crypto.sha256_hex(source), STAGE3_SHA256) then
abort("\083\116\097\103\101\032\051\032\105\110\116\101\103\114\105\116\121\032\099\104\101\099\107\032\102\097\105\108\101\100\046\032\067\111\112\121\032\097\032\102\114\101\115\104\032\108\111\097\100\101\114\032\108\105\110\101\032\102\114\111\109\032\116\104\101\032\112\097\110\101\108\046")
end
local compiled, factory = pcall(execute, source, "\061\084\115\118\072\117\098\046\083\116\097\103\101\051")
if not compiled or type(factory) ~= "\102\117\110\099\116\105\111\110" then
abort("\083\116\097\103\101\032\051\032\099\111\109\112\105\108\101\032\101\114\114\111\114\058\032" .. tostring(factory))
end
local built, stage3 = pcall(factory)
if not built or type(stage3) ~= "\102\117\110\099\116\105\111\110" then
abort("\083\116\097\103\101\032\051\032\098\111\111\116\115\116\114\097\112\032\102\097\105\108\101\100\058\032" .. tostring(stage3))
end
local ok, failure = pcall(stage3, {
api = api,
build = build,
key = key,
hwid = hwid,
hwid_source = hwid_source,
executor = executor,
crypto = crypto,
http = http,
execute = execute,
game = game_service,
task = task_lib,
publish = publish,
})
if not ok then
local message = tostring(failure)
if message:sub(1, 9) ~= "\091\084\115\118\072\117\098\093\032" then
message = "\091\084\115\118\072\117\098\093\032" .. message
end
pcall(function()
warn(message)
end)
pcall(function()
game_service:GetService("\083\116\097\114\116\101\114\071\117\105"):SetCore("\083\101\110\100\078\111\116\105\102\105\099\097\116\105\111\110", {
Title = "\084\115\118\072\117\098",
Text = message,
Duration = 8,
})
end)
end
end
