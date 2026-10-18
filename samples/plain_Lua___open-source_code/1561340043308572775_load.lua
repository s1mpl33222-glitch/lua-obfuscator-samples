-- Aster permanent public entry point. Keep this URL and bootstrap stable across releases.
local ORIGIN='https://aster-tools-ryzeno-18a3b0ea8f5c.herokuapp.com'
local downloadR2=(function()
-- Resolve only the explicit private-object protocol returned by the trusted Aster API.
return function(deps, response, kind, expectedRelease)
    local function cancelled()return deps.cancelled and deps.cancelled()end
    local function sha(value)return type(value)=='string' and #value==64 and string.match(value,'^[a-f0-9]+$')~=nil end
    if cancelled() then return nil,'Cancelled' end
    if type(response)~='table' or response.StatusCode~=200 or type(response.Body)~='string' or #response.Body>8192 or not sha(expectedRelease) then return nil,'The download metadata is unavailable. Try again.' end
    local ok,data=pcall(deps.decode,response.Body)
    local folder=kind=='loader' and 'loaders' or 'objects'
    if kind~='loader' and kind~='game' and kind~='ui' then return nil,'The download kind is invalid. Try again.' end
    if not ok or type(data)~='table' or data.transport~='r2-v1' or data.kind~=kind or data.release~=expectedRelease or not sha(data.release) or data.key~=folder..'/'..data.release..'.luau' then return nil,'The download metadata is invalid. Try again.' end
    if type(data.bytes)~='number' or data.bytes<1 or data.bytes>33554432 or data.bytes%1~=0 or type(data.serverNow)~='number' or type(data.expiresAt)~='number' or data.serverNow~=data.serverNow or data.expiresAt~=data.expiresAt or math.abs(data.serverNow)>9007199254740991 or math.abs(data.expiresAt)>9007199254740991 or data.expiresAt<=data.serverNow or data.expiresAt-data.serverNow>120000 or (kind=='ui' and data.apiVersion~=1) then return nil,'The download metadata is incompatible. Try again.' end
    if type(data.url)~='string' or #data.url>4096 or string.find(data.url,'[%c%s]') then return nil,'The download URL is invalid. Try again.' end
    local host,bucket,release,query=string.match(data.url,'^https://([^/]+)/([a-z0-9%.%-]+)/'..folder..'/([a-f0-9]+)%.luau%?([^#]+)$')
    local account,jurisdiction
    if host then
        account=string.match(host,'^([a-f0-9]+)%.r2%.cloudflarestorage%.com$')
        if not account then account,jurisdiction=string.match(host,'^([a-f0-9]+)%.([a-z]+)%.r2%.cloudflarestorage%.com$') end
    end
    if not account or #account~=32 or (jurisdiction and jurisdiction~='eu' and jurisdiction~='us' and jurisdiction~='fedramp') or not bucket or #bucket<3 or #bucket>63 or release~=data.release or not query or not string.find(query,'X-Amz-Signature=',1,true) or not string.find(query,'X-Amz-Algorithm=AWS4-HMAC-SHA256',1,true) then return nil,'The download URL is untrusted. Try again.' end
    -- The access bearer never leaves the Aster origin. R2 authenticates the query.
    local fetched,object=pcall(deps.request,{Url=data.url,Method='GET',Headers={Accept='text/plain',['Cache-Control']='no-cache, no-store'},Timeout=15})
    if cancelled() then return nil,'Cancelled' end
    if not fetched or type(object)~='table' or object.StatusCode~=200 or type(object.Body)~='string' or #object.Body~=data.bytes or string.sub(object.Body,1,9)~='-- Aster ' then return nil,'The private release could not be downloaded. Try again.' end
    if kind=='loader' then
        local discord=string.match(object.Body,'^%-%- Aster [^\n]+| public Discord access loader\n')~=nil
        local keys=string.sub(object.Body,1,#'-- Aster prepared key access loader | served only after explicit owner activation\n')=='-- Aster prepared key access loader | served only after explicit owner activation\n'
        if not discord and not keys then return nil,'The public loader release is incompatible. Try again.' end
    end
    if type(deps.hash)=='function' then
        local hashed,value=pcall(deps.hash,object.Body)
        if not hashed or value~=data.release then return nil,'The private release integrity check failed. Try again.' end
    end
    return object.Body
end

end)()
local http = game:GetService('HttpService')
local crypto=crypt or (syn and syn.crypt)
local hash=type(crypto)=='table' and type(crypto.hash)=='function' and function(value)return string.lower(crypto.hash(value,'sha256'))end or nil
for attempt = 1, 3 do
    local url = ORIGIN .. '/v1/bootstrap?download=r2-v1&request=' .. http:GenerateGUID(false)
    local ok, source = pcall(function() return game:HttpGet(url) end)
    if ok and type(source)=='string' and string.sub(source,1,9)~='-- Aster ' then
        local decoded,data=pcall(function()return http:JSONDecode(source)end)
        if decoded and type(data)=='table' then
            source=downloadR2({decode=function()return data end,hash=hash,request=function(options)
                return {StatusCode=200,Body=game:HttpGet(options.Url)}
            end},{StatusCode=200,Body=source},'loader',data.release)
        else source=nil end
    end
    if ok and type(source) == 'string' and string.sub(source, 1, 9) == '-- Aster ' then
        local chunk, problem = loadstring(source, 'AsterAccess')
        assert(type(chunk) == 'function', problem or 'Aster update could not be loaded.')
        return chunk(...)
    end
    if attempt < 3 then task.wait(2) end
end
error('Aster could not download the latest version. Please try again.', 0)
