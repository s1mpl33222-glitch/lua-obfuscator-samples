local _o0 = "\050\048\050\054\049\048\050\056\046\049\055\053\050\050\055"
local RESPONSE_SECRET = "_YzqzMY8TOG0nWfDKH5yg6wEyeUcymwmrCakWa9-1BiqFQGarnlZKd1bc4mcv7iO"
local _o1 = false
local _o2 = "\047\097\112\105\047\118\049\047\054\083\109\057\115\057\110\097\076\082\116\071\109\065\081\053\086\113\108\105\115\104\049\121\108\052\106\113\121\053\077\115\049\072\114\068\116\052\049\111"
return function(runtime)
local crypto = runtime.crypto
local http = runtime.http
local api = runtime.api
local key = runtime.key or ""
local hwid = runtime.hwid or ""
local hwid_source = runtime.hwid_source or "\117\110\107\110\111\119\110"
local executor = runtime.executor or "\117\110\107\110\111\119\110"
local execute = runtime.execute
local game_service = runtime.game or game
local task_lib = runtime.task or task
local publish = runtime.publish
local state = {
authorized = false,
session = nil,
session_expires_at = 0,
license_expires_at = 0,
last_error = nil,
stop = false,
}
local env = {}
local function now_seconds()
return math.floor(os.time())
end
local function abort(message)
error("\091\084\115\118\072\117\098\093\032" .. tostring(message), 0)
end
if type(execute) ~= "\102\117\110\099\116\105\111\110" or type(publish) ~= "\102\117\110\099\116\105\111\110" then
abort("\084\104\105\115\032\108\111\097\100\101\114\032\101\110\118\105\114\111\110\109\101\110\116\032\105\115\032\110\111\116\032\115\117\112\112\111\114\116\101\100\046")
end
if type(api) ~= "\115\116\114\105\110\103" or type(crypto) ~= "\116\097\098\108\101" or type(http) ~= "\116\097\098\108\101" then
abort("\073\110\118\097\108\105\100\032\108\111\097\100\101\114\032\098\111\111\116\115\116\114\097\112\032\099\111\110\116\101\120\116\046")
end
local function notify(message)
message = tostring(message)
pcall(function()
warn("\091\084\115\118\072\117\098\093\032" .. message)
end)
pcall(function()
game_service:GetService("\083\116\097\114\116\101\114\071\117\105"):SetCore("\083\101\110\100\078\111\116\105\102\105\099\097\116\105\111\110", {
Title = "\084\115\118\072\117\098",
Text = message,
Duration = 8,
})
end)
end
local function header(headers, name)
if type(headers) ~= "\116\097\098\108\101" then
return nil
end
local wanted = name:lower()
for header_name, value in pairs(headers) do
if type(header_name) == "\115\116\114\105\110\103" and header_name:lower() == wanted then
return tostring(value)
end
if type(header_name) == "\110\117\109\098\101\114" and type(value) == "\115\116\114\105\110\103" then
local inline_name, inline_value = value:match("\094\040\091\094\058\093\043\041\058\037\115\042\040\046\043\041\036")
if inline_name and inline_name:lower() == wanted then
return inline_value
end
end
end
return nil
end
local function fetch_payload()
local request_headers = {}
if _o1 then
request_headers["\088\045\084\115\118\045\070\114\101\101"] = "\049"
else
request_headers["\088\045\084\115\118\045\067\108\105\101\110\116"] = _o0
end
local body, request_error, headers = http.request({
Url = api .. _o2,
Method = "\071\069\084",
Headers = request_headers,
})
if not body then
return nil, "\112\097\121\108\111\097\100\032\114\101\113\117\101\115\116\032\102\097\105\108\101\100\058\032" .. tostring(request_error)
end
local signature = header(headers, "\088\045\084\115\118\072\117\098\045\083\105\103\110\097\116\117\114\101")
if type(signature) == "\115\116\114\105\110\103" and signature ~= "" and type(RESPONSE_SECRET) == "\115\116\114\105\110\103" and #RESPONSE_SECRET >= 32 then
if not crypto.equals(crypto.hmac_hex(RESPONSE_SECRET, body), signature) then
return nil, "\112\114\111\116\101\099\116\101\100\032\112\097\121\108\111\097\100\032\102\097\105\108\101\100\032\115\105\103\110\097\116\117\114\101\032\118\101\114\105\102\105\099\097\116\105\111\110"
end
else
local digest = header(headers, "\088\045\084\115\118\072\117\098\045\083\104\097\050\053\054")
if type(digest) == "\115\116\114\105\110\103" and digest ~= "" then
if not crypto.equals(crypto.sha256_hex(body), digest) then
return nil, "\112\114\111\116\101\099\116\101\100\032\112\097\121\108\111\097\100\032\102\097\105\108\101\100\032\105\110\116\101\103\114\105\116\121\032\118\101\114\105\102\105\099\097\116\105\111\110"
end
end
end
return body
end
local source, payload_error = fetch_payload()
if not source then
abort(payload_error or "\099\111\117\108\100\032\110\111\116\032\100\111\119\110\108\111\097\100\032\116\104\101\032\112\114\111\116\101\099\116\101\100\032\099\111\114\101")
end
local compiled, factory = pcall(execute, source, "\061\084\115\118\072\117\098\046\067\111\114\101")
if not compiled or type(factory) ~= "\102\117\110\099\116\105\111\110" then
abort("\099\111\114\101\032\099\111\109\112\105\108\101\032\101\114\114\111\114\058\032" .. tostring(factory))
end
local built, core_module = pcall(factory)
if not built then
abort("\099\111\114\101\032\108\111\097\100\032\101\114\114\111\114\058\032" .. tostring(core_module))
end
local public = {
version = _o0,
hwid = hwid,
hwid_source = hwid_source,
executor = executor,
is_authorized = function()
return state.authorized
end,
get_session = function()
return state.session
end,
get_state = function()
return {
authorized = state.authorized,
session = state.session,
session_expires_at = state.session_expires_at,
license_expires_at = state.license_expires_at,
last_error = state.last_error,
}
end,
stop = function()
state.stop = true
end,
}
env.version = _o0
env.key = key
env.hwid = hwid
env.hwid_source = hwid_source
env.executor = executor
env.state = state
env.now = now_seconds
env.notify = notify
env.task = task_lib
env.stop = public.stop
if type(core_module) == "\102\117\110\099\116\105\111\110" then
local ok, failure = pcall(core_module, env)
if not ok then
abort("\099\111\114\101\032\102\097\105\108\101\100\032\116\111\032\115\116\097\114\116\058\032" .. tostring(failure))
end
elseif type(core_module) == "\116\097\098\108\101" and type(core_module.Init) == "\102\117\110\099\116\105\111\110" then
local ok, failure = pcall(core_module.Init, env)
if not ok then
abort("\099\111\114\101\032\102\097\105\108\101\100\032\116\111\032\115\116\097\114\116\058\032" .. tostring(failure))
end
else
abort("\112\114\111\116\101\099\116\101\100\032\099\111\114\101\032\100\111\101\115\032\110\111\116\032\101\120\112\111\115\101\032\073\110\105\116\040\101\110\118\041")
end
publish("\084\115\118\072\117\098", public)
return public
end
