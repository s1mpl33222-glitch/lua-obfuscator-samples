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
local keyless=true
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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=033b230be1e9965d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=033b230be1e9965d"
local expected=622786
local runtime,reason,issue,pr=nil,nil,"request failed",0
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
if s2*65536.0+s1~=2050046860 then problem("runtime checksum mismatch",3);return end
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
local candidates={{fetch,"HttpGet",url}}
if fallback~=""then candidates[#candidates+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then candidates[#candidates+1]={candidate[1],candidate[2],fallback,true}end
candidates[#candidates+1]={candidate[1],candidate[2],pinned}
end
candidates[#candidates+1]={fetch,"HttpGet",retry}
local started,ni,ls=clock(),1,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=candidates[ni];ni=ni+1;ls=clock()
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
for poll=1,2000 do
if clock()-started>=40 then problem("HTTP download timed out after 40 seconds",4);break end
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
if runtime or reason or(active==0 and ni>#candidates)then break end
if ni<=#candidates and(active==0 or(active<2 and(completed or clock()-ls>=8)))then launch()
elseif not asynchronous or not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\57\98\99\56\100\49\97\100\102\98\48\54\100\53\54\102\48\51\97\98\55\54\54\57\99\49\50\49\55\52\49\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\77\115\73\67\90\84\107\107\111\83\100\119\117\77\82\72\58\95\50\97\114\115\50\85\110\122\57\90\117\76\107\69\81\118\105\117\88\48\81\58\109\98\103\100\101\98\53\108\57\101\54\52\104\117\65\102\74\115\104\110\105\88\54\111\50\114\107\116\54\122\101\57\48\103\69\72\82\111\98\75\88\97\45\114\80\54\76\86\74\70\71\54\80\82\71\79\80\98\45\118\107\89\113\121\54\83\49\119\95\122\65\110\79\120\76\87\67\118\101\86\66\81\78\88\83\102\67\110\73\57\106\103\118\121\49\50\100\104\83\72\117\116\101\113\115\117\103\89\81\53\72\72\50\57\107\117\89\108\82\49\90\114\81\88\116\118\117\120\88\105\55\99\67\55\71\72\90\52\65\116\80\104\83\108\112\51\75\114\70\75\87\50\95\85\83\81\78\76\115\68\90\103\90\82\122\75\104\109\102\69\90\49\65\116\81\69\117\112\95\78\73\55\57\122\48\79\108\113\65\119\87\71\102\75\85\53\115\57\104\56","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if fetch then pcall(fetch,host,target)elseif reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\209\108\3\177\33\216\7\4\57\85\182\195\87\69\182\146\171\193\19\79\166\82\79\249\15\158\106\85\220\223\200\6\240\52\166\69\157\111\8\248\37\172\47\10\221\29\168\1\178\132\226\136\129\40\85\247\119\133\8\218\151\82\83\69\197\248\27\51\132\221\160\146\38\189\200\174\191\128\24\212\234\5\105\69\226\3\176\59\23\103\11\170\210\240\2\116\129\207\76\19\0\102\181\48\76\137\140\184\253\120\189\84\142\75\23\187\7\21\154\178\126\50\174\182\219\104\242\212\163\135\234\12\123\76\205\196\58\38\236\48\255\204\205\47\91\100\214\16\31\196\195\161\220\244\177\69\218\15\218\31\239\107\39\19\25\76\246\90\94\25\250\219\45\136\92\68\249\18\111\203\61\35\31\217\44\78\58\133\243\183\119\248\255\162\64\236\49\195\232\34\15\92\223\158\214\145\191\118\219\87\74\189\71\96\225\63\124\88\113\187\160\174\17\66\17\222\35\143\40\191\216\130\239\143\7\213\16\15\185\195\176\183\85\216\198\78\157\0\246\76\8\54\177\31\147\210\132\222\133\62\224\198\38\192\173\207\90\194\73\73\248\251\48\118\86\127\96\156\187\157\124\19\92\192\11\222\111\114\199\145\125\91\15\242\112\118\96\242\36\142\247\94\147\232\138\203\101",1257727361,3285083029} or {"\112\29\241\124\0\143\70\156\39\90\173\142\64\117\113\24\15\169\233\120\52\181\230\162\194\62\60\246\181\35\1\58\130\249\123\72\32\222\98\75\166\236\9\89\148\238\53\31\184\93\74\112\152\114\191\94\163\182\140\18\76\117\179\164\200\45\119\132\121\124\204\42\11\48\186\44\235\188\63\22\42\183\14\75\117\115\200\3\68\153\239\242\182\51\36\211\246\57\83\53\42\208\236\85\44\155\199\29\187\103\133\178\84\105\102\0\58\84\118\49\91\215\46\66\250\1\108\166\193\64\36\49\86\149\107\39\253\176\30\87\207\245\74\74\182\135\33\32\241\100\221\224\181\249\148\20\180\137\97\222\88\221\61\252\228\180\45\229\105\120\40\248\236\160\166\210\47\215\110\31\48\145\179\219\115\185\249\93\129\253\56\205\100\204\251\11\67\133\107\176\42\166\107\155\93\75\164\249\47\31\255\13\33\193\224\183\7\44\143\33\22\173\242\115\195\66\250\140\74\64\87\31\131\201\109\153\49\54\105\195\9\254\225\80\14\254\115\45\242\133\147\34\77\88\47\201\30\231\205\19\86\79\179\5\61\246\234\136\194\165\226\237\94\143\60\87\112\116\52\249\50\48\216\248\158\37\70\70\192\133\55\107\191\5\124\85\96\43\223\202\139\239\202\12\64",240511376,2979095972}
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
