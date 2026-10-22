local ok,err=pcall(function()
local HG=game.HttpGet
local LD=(loadstring or load)
if type(HG)~="function" or type(LD)~="function" then return error("no http/loadstring") end
-- 反 hook：被 hook 的函式會從 C closure 變成 Lua closure
if iscclosure then
  if not iscclosure(LD) then return error("loadstring hooked") end
  if not iscclosure(HG) then return error("httpget hooked") end
  local rq = request or http_request or (syn and syn.request)
  if type(rq)=="function" and not iscclosure(rq) then return error("request hooked") end
end
-- __namecall 側錄偵測
if getrawmetatable and rawget and iscclosure then
  local mt=getrawmetatable(game)
  if mt then local nc=rawget(mt,"__namecall")
    if type(nc)=="function" and not iscclosure(nc) then return error("namecall hooked") end end
end
-- 常見 dumper 的記憶體殘留
local env=(getgenv and getgenv()) or _G
for _,g in ipairs({"UltimateGodExtractor","God_Upload","God_Signatures","DetectedHashes_SuperUrlGod"}) do
  if env[g]~=nil or _G[g]~=nil then return error("dumper detected") end
end
local function pf(s) local h=5381 for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end return tostring(h) end
local nj=HG(game,"https://script-protector-iota.vercel.app/api/nonce")
local tok=type(nj)=="string" and nj:match('"n":"([^"]+)"')
if not tok then return error("no nonce") end
local p=pf("a4705c938583aaa9f732b4d0ec04996fab81635fe92b5de7:"..tok)
-- 抓取前最後一次確認沒被掉包
if iscclosure and (not iscclosure(HG) or not iscclosure(LD)) then return error("hooked before fetch") end
local body=HG(game,"https://script-protector-iota.vercel.app/api/payload?t="..tok.."&p="..p)
if type(body)~="string" or #body<1 then return error("empty payload") end
local fn=LD(body)
if fn then fn() else return error("script compile failed") end
end)
if not ok then warn("[loader] blocked: "..tostring(err)) end
