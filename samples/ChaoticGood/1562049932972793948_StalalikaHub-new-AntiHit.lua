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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=2d311064741547bd"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=2d311064741547bd"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\100\55\56\48\54\98\51\57\55\54\50\98\97\100\99\98\102\50\100\97\52\48\56\56\100\48\56\98\98\49\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\117\100\69\83\66\81\65\76\53\79\102\111\100\84\117\115\58\120\101\109\53\81\66\110\70\88\115\50\49\70\97\115\86\102\101\67\87\115\119\58\116\48\79\51\52\85\79\66\48\112\77\73\100\117\110\90\81\53\120\54\111\51\116\56\95\84\79\77\110\55\102\97\75\87\95\66\97\73\117\113\114\90\85\118\87\49\45\77\85\119\104\55\105\49\107\56\117\99\84\101\99\102\51\51\71\65\75\103\116\74\50\122\119\72\119\49\111\105\57\106\51\74\118\100\66\82\45\95\110\108\56\103\90\78\82\117\70\100\77\102\66\115\48\103\101\108\109\88\80\66\100\115\66\74\112\80\53\117\48\53\117\78\55\78\121\108\89\75\112\110\83\103\110\90\103\116\74\67\79\95\110\122\112\108\66\52\98\73\90\110\85\79\117\84\86\67\106\115\77\82\66\102\98\71\51\121\102\122\86\51\95\51\50\87\66\52\116\104\84\78\114\120\114\110\73\73\85\98\68\108\90\51\66\85\66\69\106\45\95\86","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\155\95\159\224\16\134\152\139\14\124\210\1\163\163\70\19\217\222\142\252\215\100\252\233\195\192\226\250\35\229\28\11\95\195\173\58\0\37\93\116\232\35\174\193\79\117\140\45\170\83\63\166\179\156\65\245\117\89\124\160\155\3\117\216\76\87\101\241\104\212\15\10\132\156\26\29\154\69\118\113\77\82\234\12\192\219\247\149\104\155\78\208\80\202\66\132\127\37\229\97\212\177\47\95\124\200\65\119\117\112\234\1\73\207\60\8\240\63\200\113\161\72\81\127\72\210\105\189\1\95\96\222\240\148\97\28\33\254\184\13\5\70\203\99\242\129\76\85\169\122\68\110\131\184\253\206\203\130\162\64\14\166\143\146\30\8\240\30\238\247\32\246\142\153\249\75\86\189\178\66\73\123\36\107\16\230\67\111\95\106\189\156\226\72\107\160\150\225\216\54\101\185\187\49\212\16\5\24\30\154\97\16\104\13\176\87\235\33\71\29\168\34\28\151\21\63\100\110\55\188\255\200\255\215\112\230\0\254\48\191\195\53\2\167\253\120\4\191\112\221\237\2\65\89\143\244\247\209\62\163\58\227\115\144\77\246\220\171\198\72\37\246\134\31\156\185\106\151\112\134\131\123\187\57\181\7\220\201\44\99\199\169\88\72\61\18\203\124\170\206\38\145\243\111\213\232\137",46887105,742482702} or {"\167\168\18\249\219\184\63\25\61\96\146\229\88\86\10\122\119\254\58\78\122\133\26\199\113\104\132\168\93\30\144\19\151\141\79\102\73\24\36\234\102\67\171\191\60\8\179\72\25\28\121\51\83\225\161\18\188\65\78\57\146\110\106\229\218\162\217\198\29\50\101\180\162\7\120\56\52\103\241\14\163\82\255\204\49\74\214\32\190\150\67\180\82\54\84\68\46\98\188\118\141\215\250\21\151\161\233\227\21\58\44\224\65\87\63\178\211\89\150\116\207\149\74\180\197\133\222\69\159\136\74\76\113\137\104\198\69\182\42\215\227\254\245\36\152\127\27\84\165\47\71\79\43\77\46\245\94\190\139\205\54\90\139\158\233\81\186\56\208\110\149\240\209\189\92\159\82\169\112\74\97\191\192\127\119\139\98\89\60\251\78\38\68\55\120\249\105\202\237\59\239\91\217\5\211\41\14\108\91\45\177\51\145\140\61\116\215\64\136\107\71\155\123\25\111\113\216\21\0\64\92\172\233\54\146\158\221\199\132\71\213\80\239\134\86\22\108\242\99\84\74\197\44\120\54\71\147\251\58\212\200\115\234\123\40\195\65\5\202\241\199\126\97\153\218\66\199\207\41\136\204\227\61\162\172\58\234\171\62\86\78\184\222\227\111\24\18\155\12\109\51\220\123\129\1",1561431368,429810973}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
