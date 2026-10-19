local U="https://hybrid-e3.com/api/scripts/78115e9b47734ea191284a739f018c69/loader?raw=1&mode=compat" local V="" local T=600
local D="hyb_cache" local F=D.."/78115e9b47734ea191284a739f018c69_nokey_compat.lua" local M=D.."/78115e9b47734ea191284a739f018c69_nokey_compat.meta"
local CE=true and type(readfile)=="function" and type(writefile)=="function"
local function rf(p) local ok,v=pcall(function() return readfile(p) end) if ok and type(v)=="string" and #v>0 then return v end end
local function wf(p,v) pcall(function() if isfolder and makefolder and not isfolder(D) then makefolder(D) end writefile(p,v) end) end
local function G()
local rq=(syn and syn.request)or(http and http.request)or http_request or request
if rq then local ok,r=pcall(rq,{Url=U,Method="GET",Headers={["Accept-Encoding"]="identity"}})
if ok and type(r)=="table" then local b=r.Body or r.body if b~=nil and #tostring(b)>0 then return tostring(b) end end end
local ok2,b2=pcall(function()return game:HttpGet(U,true)end)
if ok2 and type(b2)=="string" and #b2>0 then return b2 end
end
local c=CE and rf(F) or nil local m=CE and rf(M) or nil
if c and m and string.find(c,"__HYB_OK__",1,true) then
local mv,mt=string.match(m,"^(.-)|(%d+)$") mt=tonumber(mt) or 0
if (V~="" and mv==V) or (T>0 and (os.time()-mt)<T) then loadstring(c)() return end
end
local s for i=1,10 do local r=G()if r and string.find(r,"__HYB_END__",1,true)then s=r break end task.wait(math.min(0.35*i,2)+math.random()*0.6)end
if s then
if CE and string.find(s,"__HYB_OK__",1,true) then wf(F,s) wf(M,V.."|"..tostring(os.time())) end
loadstring(s)()
elseif c then warn("Hybrid-E3: เซิร์ฟเวอร์ไม่ตอบ ใช้สำเนาโค้ดในเครื่องแทน") loadstring(c)()
else warn("Hybrid-E3: โหลดสคริปต์ไม่สำเร็จ ลองรันใหม่อีกครั้ง (executor รับไฟล์ไม่ครบ)") end