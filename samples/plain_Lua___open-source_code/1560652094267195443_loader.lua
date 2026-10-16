-- dogeom remote loader / license verified server-side
local E=getgenv()
local licenseKey=E.SCRIPT_KEY
assert(type(licenseKey)=="string", "Set getgenv().SCRIPT_KEY before loading")
local send=request or http_request or (syn and syn.request)
assert(type(send)=="function", "A POST-capable request function is required")
local hwid=nil
local identify=gethwid or E.gethwid
if type(identify)=="function" then local ok,value=pcall(identify) if ok and type(value)=="string" then hwid=value end end
local H=game:GetService("HttpService")
local response=send({Url="https://dogeom-loader.hog55657.chatgpt.site/api/v1/scripts/c2382442-b09c-4972-ac39-793f51c950b7/redeem",Method="POST",Headers={["Content-Type"]="application/json"},Body=H:JSONEncode({key=licenseKey,hwid=hwid})})
assert(type(response)=="table", "Invalid dogeom transport response")
if response.StatusCode~=200 then local ok,detail=pcall(H.JSONDecode,H,response.Body) error("dogeom: "..tostring(ok and type(detail)=="table" and detail.error or "license verification failed")) end
local payload=H:JSONDecode(response.Body)
assert(type(payload.module)=="string" and type(payload.executionKey)=="string", "Invalid dogeom response")
local factory,problem=loadstring(payload.module,"@dogeom")
assert(factory,problem)
local start=factory()
assert(type(start)=="function", "Invalid dogeom module")
return start(payload.executionKey)
