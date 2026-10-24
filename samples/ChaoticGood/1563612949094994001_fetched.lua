-- FlowAuth isolated console
return (function(...)
 local kind,protect,raise=type,pcall,error
 local getEnvironment,setEnvironment,compile=getfenv,setfenv,loadstring
 if kind(getEnvironment)~="function" or kind(setEnvironment)~="function" then return nil,"Silent execution is unavailable in this executor" end
 local base=getEnvironment()
 local inherited=rawget(base,"__flowauth_console_scope")
 local shared=base
 if kind(getgenv)=="function" then local ok,value=protect(getgenv);if ok and kind(value)=="table" then shared=value end end
 if kind(inherited)=="table" and kind(inherited.base)=="table" and kind(inherited.compile)=="function" then base,shared,compile=inherited.base,inherited.shared,inherited.compile end
 local unpackValues=table.unpack or unpack
 local function pack(...)return {n=select("#",...),...}end
 local quiet=true
 local pending={}
 local authoredError
 local nativeProtectedRuntime=false
 local nativePrint,nativeWarn=base.print,base.warn
 local nativeRawGet,nativeRawSet=rawget,rawset
 local function output(fn,...)
  if quiet==nil then if #pending<32 then pending[#pending+1]={fn,pack(...)}end
  elseif not quiet and kind(fn)=="function" then fn(...)end
 end
 local function decide(value)
  if quiet~=nil then return end
  quiet=value
  if not quiet then for _,entry in ipairs(pending)do if kind(entry[1])=="function" then entry[1](unpackValues(entry[2],1,entry[2].n))end end end
  pending={}
 end
 local scope,sharedScope={},{}
 setmetatable(scope,{__index=base,__newindex=base})
 setmetatable(sharedScope,{__index=shared,__newindex=shared})
 local function mutedPrint(...)output(nativePrint,...)end
 local function mutedWarn(...)output(nativeWarn,...)end
 local function scopedCompile(text,name)
  -- Luraph STATIC_ENVIRONMENT forbids changing the compiled function's
  -- environment. Keep its native globals and compiler, including the
  -- customer chunks it compiles. Output isolation applies only to the
  -- plaintext launcher/init/UI paths that support environment rebinding.
  if name=="=FlowAuthRuntime" then
   nativeProtectedRuntime=true
   return compile(text,name)
  end
  if kind(text)=="string" then
   local prefix=string.sub(text,1,256)
   if string.find(prefix,"-- FlowAuth console: silent",1,true)then decide(true)
   elseif string.find(prefix,"-- FlowAuth console: normal",1,true)then decide(false)end
  end
  local chunk,reason=compile(text,name)
  if kind(chunk)=="function" then
   if name=="=FlowAuth" or name=="=FlowAuthInit" or name=="=FlowAuthUI" then
    setEnvironment(chunk,base)
    local function authored(fn)
     return function(...)
      local values=pack(protect(fn,...))
      if not values[1] then authoredError=values[2];raise(values[2],0)end
      if name=="=FlowAuthInit" and kind(values[2])=="function" then values[2]=authored(values[2])end
      return unpackValues(values,2,values.n)
     end
    end
    return authored(chunk)
   end
   setEnvironment(chunk,scope)
  end
  return chunk,reason
 end
 local function scopedRawGet(environment,key)
  if environment==scope or environment==sharedScope then
   local own=nativeRawGet(environment,key)
   if own~=nil then return own end
   return nativeRawGet(environment==scope and base or shared,key)
  end
  return nativeRawGet(environment,key)
 end
 local function scopedRawSet(environment,key,value)
  if environment==scope then nativeRawSet(base,key,value);return environment end
  if environment==sharedScope then nativeRawSet(shared,key,value);return environment end
  return nativeRawSet(environment,key,value)
 end
 for _,environment in ipairs({scope,sharedScope})do
  rawset(environment,"__flowauth_console_scope",{base=base,shared=shared,compile=compile})
  rawset(environment,"rawget",scopedRawGet);rawset(environment,"rawset",scopedRawSet)
  rawset(environment,"print",mutedPrint);rawset(environment,"warn",mutedWarn)
  rawset(environment,"loadstring",scopedCompile)
  rawset(environment,"getgenv",function()return sharedScope end)
  rawset(environment,"_G",sharedScope)
 end
 local function run(...)
local credential=...
local type,pcall,error,tostring,tonumber=type,pcall,error,tostring,tonumber
local rawset,getfenv=rawset,getfenv
local globals,host=_G,game
local byte,gsub,find=string.byte,string.gsub,string.find
local wait=type(task)=="table"and task.wait
local clock=os.clock
local compile=loadstring
local function member(value,key)
local ok,result=pcall(function()return value[key]end)
if ok then return result end
end
local keyless=false
if keyless then
credential=""
elseif type(credential)~="string"then
for lv=2,4 do
local f,sc=pcall(getfenv,lv)
local v=f and type(sc)=="table"and member(sc,"script_key")
if type(v)=="string"then credential=v;pcall(rawset,sc,"script_key",nil);break end
end
end
local spawn=member(task,"spawn")
local fetch=member(host,"HttpGet")
local ok,senv=pcall(function()return getfenv()end)
if not ok or type(senv)~="table"then senv=globals end
local ok,environment=pcall(function()return getgenv()end)
if not ok or type(environment)~="table"then environment=senv end
local function global(key)return member(environment,key)or member(senv,key)or member(globals,key)end
local sample=20
local platform="?"
pcall(function()
local input=host:GetService("UserInputService")
platform=input.TouchEnabled and not input.KeyboardEnabled and"m"or"d"
end)
local function ms(x)return math.floor(x*1000+.5)end
local reqs,seen={},{}
local function add(fn,name)
if type(fn)=="function"and not seen[fn]then seen[fn]=true;reqs[#reqs+1]={fn,name}end
end
add(global("request"),"request")
add(global("http_request"),"http_request")
add(global("httpRequest"),"httpRequest")
add(global("httprequest"),"httprequest")
add(member(global("http"),"request"),"http.request")
add(member(global("syn"),"request"),"syn.request")
local bt=member(global("buffer"),"tostring")
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=e95aa04f6503cc2f"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e95aa04f6503cc2f"
local expected=632423
local runtime,reason,issue,pr=nil,nil,"timed out",0
local transport,issueTransport="HttpGet","HttpGet"
local function problem(message,rank)
if rank>=pr then issue,pr,issueTransport=message,rank,transport end
end
local arrived,ck,cm=0,0,0
local function accept(value)
local began=clock()
if type(value)=="buffer"then local ok,text=pcall(bt,value);value=ok and text or nil end
if type(value)~="string"then problem("unsupported response body",1);return end
if #value~=expected then
if #value<1024 and find(value,"Failed to send HTTP request.",1,true)then
problem(find(value,"timed out",1,true)and"HTTP request timed out"or"HTTP request failed",2)
else problem("received "..#value.." bytes; expected "..expected,2)end
return
end
local s1,s2,i=1.0,0.0,1
while i+7<=#value do
local a,b,c,d,e,f,g,h=byte(value,i,i+7)
s2=(s2+8*s1+8*a+7*b+6*c+5*d+4*e+3*f+2*g+h)%65521
s1=(s1+a+b+c+d+e+f+g+h)%65521;i=i+8
end
while i<=#value do s1=(s1+byte(value,i))%65521;s2=(s2+s1)%65521;i=i+1 end
if s2*65536.0+s1~=3646516830 then problem("runtime checksum mismatch",3);return end
local t=clock();ck=t-began
local ok,compiled,detail=pcall(compile,value,"=FlowAuthRuntime")
local text=not(ok and type(compiled)=="function")and tostring(ok and detail or compiled)
if text and not(find(text,"FlowAuthRuntime:")or find(text,"xpected")or find(text,"syntax"))then
if wait then pcall(wait,1.5)end
ok,compiled,detail=pcall(compile,value,"=FlowAuthRuntime")
end
cm=clock()-t
if ok and type(compiled)=="function"then runtime=compiled;return true end
reason=(ok and detail or compiled)or"compiler returned no function";issueTransport=transport
return false
end
local cs={{fetch,"HttpGet",url}}
if fallback~=""then cs[#cs+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then cs[#cs+1]={candidate[1],candidate[2],fallback,true}end
cs[#cs+1]={candidate[1],candidate[2],fresh}
end
cs[#cs+1]={fetch,"HttpGet",retry}
local started,ni,ls,idle=clock(),1,0,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=cs[ni];ni=ni+1;ls=clock()
local job={name=candidate[2],alternate=candidate[4]};js[#js+1]=job
local function run()
if shut or job.started then return end
job.started=true
local ok,response
if job.name=="HttpGet"then ok,response=pcall(candidate[1],host,candidate[3])
else ok,response=pcall(candidate[1],{Url=candidate[3],Method="GET"})end
if not shut then job.ok,job.response,job.done=ok,response,true end
end
if asynchronous then
local ok,thread=pcall(spawn,run);job.thread=ok and thread or nil
if not job.started and type(job.thread)~="thread"then asynchronous=false;run()end
else run()end
end
launch()
for poll=1,4000 do
local active,completed=0,false
for i=1,#js do
local job=js[i]
if not job.done then active=active+1
elseif not job.read then
job.read=true;completed=true;transport=job.name;arrived=clock()-started
local response=job.response;job.response=nil
if not job.ok then problem("request failed",1)
elseif type(response)=="table"then
local status=tonumber(member(response,"StatusCode")or member(response,"status_code")or member(response,"Status")or member(response,"status"))or 0
local success=member(response,"Success");if success==nil then success=member(response,"success")end
if status==0 and success==true then status=200 end
if success==false and status<400 then status=500 end
if status>=200 and status<300 then accept(member(response,"Body")or member(response,"body")or member(response,"ResponseBody")or member(response,"response_body"))
else problem("HTTP "..status,2)end
else accept(response)end
if runtime or reason then alternate=job.alternate;break end
end
end
if runtime or reason or(active==0 and ni>#cs)then break end
local t=clock()
if t-started-idle>=40 then problem("HTTP download timed out after 40 seconds",4);break end
if ni<=#cs and(active==0 or(active<2 and(completed or t-ls>=8)))then launch()
elseif not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break
else idle=idle+math.max(clock()-t-1,0)end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\49\55\49\51\49\100\51\50\100\52\101\99\53\56\101\48\102\101\57\55\48\50\100\55\52\97\56\99\54\102\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\87\97\76\56\70\50\75\73\100\71\122\57\51\49\69\69\58\52\113\114\80\86\87\50\54\51\118\103\67\82\108\77\111\50\116\78\80\99\103\58\83\95\106\50\101\66\105\65\98\87\116\75\118\99\50\85\70\50\114\122\67\52\97\113\74\73\87\70\45\103\122\73\119\74\66\89\117\110\90\51\79\85\50\76\53\112\77\52\77\45\103\52\117\53\54\101\68\71\68\109\107\77\80\72\104\78\122\51\55\75\45\111\75\54\65\81\54\49\77\56\100\80\100\78\119\76\76\76\90\113\109\102\101\105\100\122\119\80\118\83\108\56\107\73\118\85\83\118\120\77\107\74\103\112\122\78\73\102\50\79\95\75\110\116\84\116\105\81\108\65\108\75\70\88\113\86\111\76\115\107\74\56\103\115\113\50\57\118\84\66\121\118\78\117\97\107\54\97\104\121\88\121\110\83\106\85\79\85\81\86\103\84\111\80\110\102\90\82\99\101\69\83\97\66\112\112\86\98\73\81\90\56\53\66\113\90\77\85\118\74","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if not pcall(fetch,host,target)and reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
end)
end
if not runtime then
pcall(function()
local text=gsub(issueTransport..": "..tostring(reason or issue),"[^%w .:;,()=/_-]","?")
local body=(reason and"launcher_load"or"launcher_download")..'","executor":"launcher","diag":["pf='..platform..'"],"error":"'..string.sub(text,1,160)..'"}'
for _,base in ipairs{url,fallback}do
if base~=""then send(base,"/v1/telemetry/executor",body)end
end
end)
if reason then error("FlowAuth runtime compilation failed: "..tostring(reason),0)end
error("FlowAuth runtime download failed ("..issueTransport.."): "..tostring(issue)..". Please run the loader again.",0)
end
if sample>0 and spawn and math.random(sample)==1 then
pcall(send,alternate and fallback or url,"/v1/telemetry/load",'load","pf":"'..platform..'","tp":"'..transport..'","fb":'..(alternate and 1 or 0)..',"tr":'..#js..',"dl":'..ms(arrived)..',"ck":'..ms(ck)..',"cm":'..ms(cm)..',"w":'..sample..'}',2)
end
if asynchronous then pcall(wait)end
local handoff=alternate and {"\55\174\134\89\4\115\252\131\194\138\236\160\25\144\230\121\87\251\130\249\157\223\131\152\33\238\231\58\61\216\3\172\36\56\131\171\48\6\111\72\48\216\131\153\128\165\175\50\198\66\19\213\124\1\242\25\191\81\195\106\61\54\68\155\138\39\201\140\255\27\143\177\188\175\196\90\104\77\181\189\90\233\25\86\202\137\250\151\170\59\160\248\217\144\24\137\101\88\236\58\1\78\85\173\190\69\87\79\216\138\182\178\177\139\150\47\10\47\153\72\6\135\114\7\144\212\240\220\23\175\167\0\10\254\131\94\231\235\26\116\121\240\84\130\87\174\59\209\27\95\123\144\167\158\19\1\37\65\163\105\249\148\210\54\136\130\133\174\48\158\81\76\176\119\76\175\115\175\196\66\228\205\48\39\254\60\34\190\68\244\160\104\63\15\63\208\74\255\217\18\172\237\67\110\24\111\189\59\242\97\44\142\226\231\174\131\31\91\20\87\197\146\183\28\14\228\248\9\56\91\32\37\117\177\249\63\76\117\190\202\167\16\218\17\101\127\70\127\87\223\244\6\0\230\121\156\105\255\78\114\134\237\137\149\73\248\218\125\177\51\54\15\5\230\110\13\86\134\97\54\116\219\254\174\246\77\84\143\37\97\95\47\6\163\104\106\138\62\131\147\159\133\18\176\191\105\34",689578539,2322293323} or {"\103\22\51\6\196\24\149\177\10\205\148\67\85\127\247\163\98\8\250\150\114\185\215\12\119\18\3\139\126\223\100\79\252\239\253\107\126\145\114\46\55\137\122\102\11\118\134\30\44\196\186\73\46\176\246\91\102\54\207\19\35\6\38\2\87\1\66\204\181\102\82\128\0\164\27\81\163\193\58\149\164\114\118\37\72\140\54\23\67\241\50\68\131\30\67\73\227\15\72\19\49\169\106\98\93\171\191\214\162\245\124\244\200\114\117\244\90\226\130\34\253\222\122\109\235\68\249\94\186\29\133\182\190\78\145\229\168\132\232\128\65\168\73\120\208\179\79\51\39\179\73\110\57\218\95\165\173\191\124\30\164\32\65\82\247\117\101\253\28\39\100\57\9\75\234\40\179\179\81\121\18\3\226\27\253\170\79\3\90\29\10\203\159\154\143\167\78\115\45\232\58\137\77\51\251\164\82\189\131\221\191\57\20\229\89\152\7\78\81\0\255\119\211\194\78\121\163\230\23\199\125\224\202\113\40\35\147\177\155\216\82\126\78\164\227\156\180\73\57\152\22\51\18\1\91\253\147\34\119\137\148\83\228\161\100\140\198\60\48\190\230\170\181\222\163\152\167\135\75\87\155\8\1\144\102\128\75\108\62\101\148\183\153\31\127\88\15\75\109\241\61\21\139\204\75",1560989611,2021680218}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)

 end
 setEnvironment(run,scope)
 local result=pack(protect(run,...))
 if not result[1] then
  if nativeProtectedRuntime or quiet==false or (authoredError~=nil and authoredError==result[2]) then raise(result[2],0)end
  return nil,result[2]
 end
 return unpackValues(result,2,result.n)
end)(...)
