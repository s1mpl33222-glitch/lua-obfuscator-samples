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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=6ff2aab2d765d1b9"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6ff2aab2d765d1b9"
local expected=572639
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
if s2*65536.0+s1~=2292470616 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\100\48\50\98\51\98\57\48\52\53\54\99\52\97\101\52\51\53\51\55\54\101\52\97\51\100\49\57\55\97\56\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\121\115\85\67\80\78\45\89\118\72\113\67\116\81\51\80\58\57\100\122\74\122\85\85\111\72\103\86\103\105\68\55\106\90\101\75\113\118\103\58\109\54\52\98\119\85\49\51\104\74\104\52\51\109\121\105\74\55\80\106\85\85\53\103\81\112\98\112\79\52\120\71\67\52\49\86\72\104\83\76\66\45\52\75\55\115\102\56\118\78\67\119\86\108\95\111\122\101\65\117\50\115\104\82\112\54\66\83\102\77\76\116\89\95\107\103\113\51\122\83\73\56\114\65\66\113\78\99\78\69\115\74\119\71\120\106\81\88\85\122\120\81\89\67\75\80\81\76\82\97\97\52\97\45\50\53\76\107\56\82\76\78\119\66\65\89\49\99\75\82\77\122\53\88\53\66\112\86\118\66\86\52\86\78\77\51\76\53\117\65\74\52\89\99\103\99\90\45\86\88\101\68\84\116\108\104\74\81\122\100\106\104\100\113\121\56\79\68\87\85\103\53\84\120\50\118\119\70\77\119\113\108\49\109\81\98\108\67\115\83","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\112\103\174\216\40\140\142\65\164\236\228\9\131\187\213\28\58\133\30\108\22\33\129\184\44\82\147\239\29\207\36\29\33\74\183\103\3\150\164\12\19\212\224\160\116\105\96\115\170\65\201\201\13\98\249\247\12\167\140\17\201\128\197\22\70\222\52\11\116\230\7\174\74\244\183\56\145\214\49\164\119\166\5\65\178\27\80\92\255\183\236\111\24\54\106\63\41\190\115\149\30\248\58\213\243\44\139\67\243\8\213\117\71\0\170\150\20\58\58\76\214\119\195\80\139\107\9\132\192\175\40\78\72\168\176\32\127\56\128\6\12\169\201\156\240\145\57\205\220\91\60\93\252\111\189\58\124\190\151\80\148\50\120\166\12\49\226\56\119\138\97\91\83\56\192\120\242\218\15\23\22\85\201\98\73\248\173\253\171\85\223\140\165\87\246\72\43\7\112\9\135\246\0\233\136\224\151\171\2\139\99\6\45\77\71\176\225\92\181\78\135\222\225\255\235\178\251\238\218\179\235\119\154\18\164\65\145\255\252\215\139\69\170\133\246\31\27\91\234\190\18\94\76\77\110\235\139\141\159\192\148\68\86\59\149\198\39\122\128\69\128\171\238\236\96\76\244\38\45\56\66\60\230\227\209\3\173\48\20\82\167\158\203\168\244\35\114\51\23\204\122\93\152\145\125\130\200",2128583812,199647660} or {"\61\97\2\146\60\90\18\212\85\171\234\65\149\254\16\243\122\238\89\201\245\140\74\18\19\103\50\153\129\12\98\100\90\31\3\64\122\65\248\187\144\96\23\239\141\13\34\22\0\6\208\162\78\209\94\64\17\28\183\86\40\3\42\218\43\117\96\252\210\144\80\134\123\110\124\133\158\50\108\215\116\236\206\25\9\78\249\170\135\19\249\210\51\28\8\62\210\71\27\241\244\21\115\230\233\48\69\72\224\141\157\187\208\100\217\236\54\177\42\122\89\224\63\128\114\127\0\48\3\55\49\66\13\207\248\127\84\139\8\231\101\170\245\10\232\116\74\0\154\65\226\101\3\42\26\205\240\68\10\166\9\191\114\197\6\189\204\244\107\151\121\23\133\3\94\111\40\119\117\176\17\170\120\47\166\228\134\61\99\128\235\130\31\48\36\132\127\235\92\198\204\148\49\129\58\213\217\173\238\26\57\176\138\49\13\147\21\161\62\166\122\31\23\89\240\253\123\39\39\202\199\169\217\39\3\126\234\245\239\191\100\22\33\206\250\105\180\100\250\126\90\122\27\65\149\90\119\69\18\91\82\9\196\97\247\227\228\126\92\102\77\136\51\210\78\177\100\227\57\13\180\8\148\205\244\131\60\160\97\43\36\92\92\225\10\193\58\161\157\233\180\97\214\52\21",2868075632,4205863867}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
