local root=getfenv()
local env=type(root.getgenv)=='function' and root.getgenv() or root
local key=env.key
if type(key)~='string' or not key:match('^ihk_[A-Za-z0-9_-]+$') or #key~=47 then warn('Ione Hub: set getgenv().key to your dashboard key first.');return end
local fetch=env.request or root.request or env.http_request or root.http_request
for _,e in ipairs({env,root}) do
    if not fetch and type(e.syn)=='table' then fetch=e.syn.request end
    if not fetch and type(e.http)=='table' then fetch=e.http.request end
end
if type(fetch)~='function' then warn('Ione Hub: this loader needs executor HTTP request support. Use the farm download from your signed-in dashboard if HTTP is unavailable.');return end
local ok,result=pcall(fetch,{Url="https://api.ionehub.workers.dev/api/script",Method='GET',Headers={Authorization='Bearer '..key},Timeout=15})
local code=ok and type(result)=='table' and tonumber(result.StatusCode or result.status_code or result.Status)
if code~=200 then warn(code==401 and 'Ione Hub: invalid dashboard key.' or code==403 and 'Ione Hub: access is disabled.' or 'Ione Hub: script service unavailable. Try again later; avoid repeated execution.');return end
local source=result.Body or result.body
if type(source)~='string' then warn('Ione Hub: empty script response.');return end
local run=loadstring(source)
if not run then warn('Ione Hub: script could not be loaded.');return end
run()
