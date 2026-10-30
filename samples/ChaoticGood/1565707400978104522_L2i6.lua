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
local fresh=url.."?retry=62a8a971d8377782"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=62a8a971d8377782"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\56\101\99\52\51\56\50\99\50\57\48\100\54\55\100\102\54\53\55\52\53\48\53\54\53\99\56\98\99\57\53\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\120\108\111\84\107\57\45\99\90\90\113\118\90\84\52\109\58\72\54\95\114\76\85\99\118\97\55\104\66\107\105\105\57\116\50\83\111\76\119\58\115\120\120\83\73\113\78\90\116\122\84\107\79\65\110\65\65\106\104\53\88\112\72\122\74\56\98\74\85\100\95\97\86\111\104\118\86\69\107\107\95\72\54\83\105\119\98\107\76\55\97\90\74\116\85\109\66\100\72\121\56\74\85\45\102\67\121\112\84\55\71\69\110\105\73\104\107\57\113\66\72\95\115\100\99\106\120\120\111\68\100\118\100\90\69\110\74\113\89\70\119\116\102\87\78\55\80\112\104\75\110\108\75\115\103\114\118\78\100\87\106\118\114\57\98\56\73\115\119\74\108\89\57\53\98\107\83\100\77\104\49\52\54\75\55\78\70\48\45\115\73\97\76\89\50\80\99\66\107\121\112\102\101\115\111\119\117\97\115\82\106\56\75\79\56\117\101\99\118\110\71\122\114\90\121\51\116\90\82\77\70\105\115\54\104\81\115\116\112\116","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\178\143\84\142\112\35\231\120\25\180\152\32\142\239\155\47\152\131\184\84\138\95\105\70\88\69\172\49\154\63\73\113\135\184\191\29\225\230\55\5\115\97\158\227\189\182\126\67\182\98\183\249\73\95\217\207\224\217\206\59\198\117\79\202\164\109\117\220\209\77\193\183\148\195\203\66\147\122\134\104\105\171\223\131\91\147\1\149\116\241\184\227\35\68\44\124\34\174\135\160\225\172\190\238\236\253\84\154\111\89\161\189\119\11\53\197\110\4\110\91\173\120\185\84\187\187\58\2\135\13\122\221\135\81\3\96\155\86\0\160\158\222\249\88\91\61\40\99\89\191\5\179\116\187\53\19\61\225\161\195\243\229\4\47\172\39\86\171\178\184\19\47\188\220\4\80\199\23\27\187\100\86\235\107\13\122\128\102\81\137\177\138\150\139\68\187\63\144\99\227\22\11\172\163\234\133\197\235\164\147\213\0\142\73\53\61\233\148\53\233\120\150\105\40\111\183\21\14\142\10\125\29\233\244\106\239\247\231\70\216\106\6\196\23\124\63\106\216\111\214\107\141\176\216\171\134\176\193\148\57\250\225\234\103\25\75\42\199\121\98\157\202\130\250\223\193\98\121\132\22\101\203\124\33\105\0\153\203\200\110\73\234\227\77\176\149\84\204\231\52\106\233\12\144\192\22\93",1576133656,94201382} or {"\20\124\185\212\70\114\52\32\114\49\110\72\55\184\93\251\90\255\232\194\31\154\76\31\232\8\248\163\241\1\94\88\143\64\85\203\246\207\187\120\0\13\56\24\167\143\145\73\155\248\119\167\23\205\160\5\23\216\98\41\80\60\50\3\125\23\212\171\35\145\121\174\14\97\228\20\91\61\171\167\80\73\147\223\121\22\19\101\83\211\167\172\215\113\126\13\58\234\78\85\81\252\8\226\192\196\225\133\94\119\173\112\243\78\173\244\234\197\232\205\134\94\249\116\8\30\27\194\126\215\55\148\192\135\236\20\156\243\161\60\151\55\42\223\169\242\176\64\183\189\184\250\38\21\1\152\245\139\11\251\140\93\188\133\69\54\228\210\189\132\107\85\156\45\15\3\248\171\13\133\59\187\52\243\53\217\242\55\100\97\175\138\71\0\152\125\10\37\82\212\246\83\191\213\146\48\248\171\214\153\141\130\16\138\219\143\224\160\39\180\253\144\6\218\5\108\201\180\80\211\170\3\196\210\252\37\22\125\194\43\192\238\19\245\184\155\234\226\0\35\96\247\162\70\131\75\178\63\198\239\251\127\184\232\252\226\38\163\71\163\157\15\116\234\108\243\157\248\164\23\40\126\250\176\41\219\11\65\89\252\40\39\235\69\217\26\196\34\227\138\239\147\50\118\184",1603209079,4103825461}
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
