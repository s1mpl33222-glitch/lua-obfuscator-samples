local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function d(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end
loadstring(d("LS0gUnVuQnVkZHkgRXhhbXBsZSBTY3JpcHQKbG9jYWwgU3RhcnRlckd1aSA9IGdhbWU6R2V0U2VydmljZSgiU3RhcnRlckd1aSIpCgpTdGFydGVyR3VpOlNldENvcmUoIlNlbmROb3RpZmljYXRpb24iLCB7CiAgICBUaXRsZSA9ICJSdW5CdWRkeSIsCiAgICBUZXh0ID0gIlNjcmlwdCBleGVjdXRlZCBzdWNjZXNzZnVsbHkhIiwKICAgIER1cmF0aW9uID0gNQp9KQoKcHJpbnQoIlJ1bkJ1ZGR5IGxvYWRlZCBzdWNjZXNzZnVsbHkhIik="))()