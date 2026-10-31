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
 local quiet=nil
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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=57a2791ac07434bb"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=57a2791ac07434bb"
local expected=627508
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
if s2*65536.0+s1~=368677546 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\101\101\55\50\52\56\99\99\97\53\51\101\101\51\101\100\48\56\52\55\52\57\98\53\49\55\54\99\100\101\49\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\80\57\56\52\87\52\104\48\113\73\106\100\106\86\51\50\58\86\83\89\99\112\106\52\83\82\70\111\107\50\111\51\103\49\110\106\95\112\65\58\80\54\54\45\68\55\101\55\54\49\114\117\71\67\84\103\69\73\112\99\111\111\73\121\122\102\90\98\95\65\108\65\74\116\69\52\107\105\102\121\104\95\82\100\86\69\48\73\102\89\69\110\90\105\104\114\88\106\55\112\77\97\97\108\78\54\78\90\95\99\77\79\122\65\83\55\102\70\78\80\118\80\78\45\69\88\75\95\111\82\98\119\70\54\98\49\56\108\102\120\120\99\97\68\68\104\57\106\53\79\65\81\55\109\87\85\97\54\66\74\70\120\114\103\116\54\120\106\103\115\66\57\112\50\120\114\110\88\102\109\67\49\53\89\53\51\108\113\114\116\67\101\84\74\79\85\118\66\56\122\49\81\77\55\56\120\75\105\67\87\89\78\55\84\49\86\111\99\56\104\120\74\84\56\122\67\107\95\115\57\101\107\82\69\86\49\97\50\120\49","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\122\83\252\254\87\67\21\231\215\137\236\11\49\97\195\163\214\60\49\7\51\247\33\75\107\191\129\42\29\129\103\180\114\147\95\184\154\236\26\207\226\18\243\53\196\101\250\45\235\139\172\29\46\114\97\221\95\159\152\115\206\167\94\232\229\219\101\246\192\196\36\181\77\248\20\137\199\122\120\198\197\111\184\122\123\89\247\223\165\140\158\14\190\224\46\24\32\60\87\233\29\144\7\178\0\98\219\255\26\110\50\87\181\27\168\105\215\244\102\237\29\29\213\95\217\217\184\15\225\52\184\157\27\177\69\210\49\125\242\138\8\82\235\122\199\121\138\30\164\247\142\121\30\226\150\213\248\28\11\166\219\165\95\254\223\221\174\114\82\23\92\180\207\28\161\205\117\230\51\18\249\167\111\224\67\219\230\47\122\196\82\216\216\13\252\6\43\161\119\196\81\73\244\48\92\240\140\155\108\151\243\41\43\240\60\203\177\144\251\1\146\213\183\90\44\169\48\169\198\78\115\188\203\4\112\31\11\116\82\30\159\248\77\31\199\109\86\150\74\215\180\214\246\2\166\41\89\88\188\1\234\20\129\71\253\201\225\83\199\116\92\133\236\38\179\118\55\163\150\15\161\226\150\176\203\214\42\227\140\97\138\112\146\106\59\92\234\37\55\119\40\109\148\229\41\188\163",1464576618,952262996} or {"\119\146\11\31\47\141\152\220\153\129\130\176\205\17\158\137\244\54\232\12\219\202\48\152\4\166\136\234\19\245\85\75\128\25\105\6\165\154\248\59\147\212\181\57\212\66\188\133\4\49\24\211\190\128\222\169\110\225\187\254\94\194\23\213\99\126\28\114\148\98\142\137\63\62\5\179\68\34\235\24\110\204\29\199\163\157\171\118\153\170\175\163\243\237\36\200\36\147\63\152\124\14\149\65\66\218\168\91\116\102\202\128\179\203\133\163\74\35\229\53\207\24\169\132\16\27\237\59\218\233\73\2\251\162\195\154\176\201\73\3\29\86\248\103\118\84\207\240\67\190\121\217\104\159\242\142\42\168\144\156\129\207\121\82\62\68\85\141\202\187\14\9\240\9\108\210\46\6\165\241\189\36\77\29\177\174\21\156\215\98\59\152\15\87\143\177\50\11\2\164\46\45\17\119\28\170\221\58\120\159\254\185\57\213\197\30\214\92\227\255\131\64\202\13\160\141\170\124\66\242\27\38\127\74\178\144\190\150\197\65\168\147\30\135\128\86\244\166\197\13\28\179\239\138\43\227\227\121\55\98\23\4\238\64\157\165\73\135\191\146\204\229\252\232\48\77\241\114\70\43\8\81\102\169\165\0\238\141\190\151\203\58\241\185\167\76\132\206\229\253\97\15\253\13\165",249079850,643785571}
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
