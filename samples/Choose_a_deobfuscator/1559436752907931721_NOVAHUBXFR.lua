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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=cfedcecb5c81538a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=cfedcecb5c81538a"
local expected=898586
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
if s2*65536.0+s1~=1933677448 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\51\99\53\49\99\51\49\48\98\56\53\54\102\57\102\57\52\97\97\97\56\100\53\98\48\57\57\98\51\102\56\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\71\55\66\106\56\77\109\73\119\109\66\52\116\95\70\66\58\121\119\114\114\86\103\71\67\117\116\103\72\99\87\119\54\105\114\118\88\112\119\58\88\122\75\100\103\78\51\51\97\70\57\65\71\102\57\118\77\72\76\111\99\113\117\49\75\55\77\109\105\105\98\99\55\113\85\83\121\54\117\121\81\114\86\113\66\68\56\90\100\89\81\69\85\53\89\89\81\80\122\98\68\45\116\51\112\48\77\67\83\103\90\85\65\101\105\77\116\51\118\77\105\97\83\98\80\110\48\75\122\103\52\122\103\103\122\78\67\70\87\80\84\110\55\80\122\100\65\48\87\85\48\81\115\55\90\84\69\109\88\71\45\114\112\66\56\105\54\117\107\49\83\112\113\112\54\52\83\106\54\108\45\102\107\49\78\115\98\52\71\101\89\65\97\71\118\45\77\45\51\111\99\53\53\71\68\116\82\75\88\73\119\57\50\55\102\70\90\122\73\79\112\114\54\120\79\87\77\101\68\87\50\68\113\68\113\82\48\120\81\56","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\251\186\234\199\5\112\32\166\150\242\160\206\23\179\31\12\52\149\160\114\107\179\33\206\40\240\210\226\12\177\232\232\203\197\57\98\112\57\249\118\167\175\31\91\160\70\143\140\20\125\237\114\223\90\223\249\178\166\249\50\30\55\66\243\212\198\13\251\163\193\85\13\49\21\195\200\117\114\141\3\206\204\249\102\76\196\104\137\32\227\197\163\61\61\20\62\163\129\163\202\0\15\203\189\57\94\107\154\82\82\90\184\174\247\184\246\213\229\103\46\102\47\186\90\230\224\70\173\83\93\221\249\143\93\204\236\90\134\161\191\148\69\15\19\223\175\209\5\60\143\135\108\58\89\154\239\84\46\1\117\213\40\38\161\216\163\161\78\24\127\206\59\101\243\51\51\210\179\241\218\53\13\69\2\231\90\19\163\142\233\76\97\180\96\199\7\113\197\162\137\88\248\229\83\104\70\25\125\166\211\204\16\91\138\233\64\207\189\90\65\67\171\78\7\107\119\152\36\58\95\80\71\4\42\132\253\241\25\41\85\42\41\42\87\74\121\141\38\85\221\37\91\226\248\232\43\122\18\161\3\142\201\59\153\80\251\235\204\219\26\132\69\118\195\241\25\173\169\25\101\115\220\54\128\225\13\38\190\33\207\213\41\153\194\165\140\192\78\223\74\45\222\82\41\52\48\153",2753038271,71590280} or {"\210\133\88\126\96\87\156\180\213\217\97\36\65\130\188\153\160\138\96\13\238\197\4\205\233\200\66\64\188\218\56\196\16\65\3\109\241\226\189\233\175\42\73\127\186\166\98\167\201\105\196\242\67\139\67\104\186\106\44\233\218\81\61\230\228\111\28\9\115\165\22\186\188\144\119\237\38\97\170\30\196\137\107\249\83\209\242\167\34\199\233\73\0\4\16\131\21\183\69\238\218\41\99\19\227\169\56\128\110\106\246\109\222\70\217\138\46\135\105\30\233\186\40\227\253\210\117\53\243\211\247\138\34\151\1\28\22\87\205\228\102\43\248\211\6\109\231\10\53\30\78\215\69\188\151\133\157\113\75\192\22\9\182\163\116\49\252\116\111\75\167\198\113\77\79\219\27\7\71\101\31\108\96\31\174\138\80\174\138\70\141\194\101\77\34\19\233\228\234\69\151\128\129\219\138\77\10\80\250\71\196\79\12\138\98\228\159\45\89\109\188\155\191\136\86\87\249\31\15\124\165\113\39\200\193\203\57\108\149\140\98\52\181\175\58\189\190\40\67\135\1\108\8\90\36\70\135\24\243\100\123\233\80\140\176\136\192\158\193\127\163\25\127\254\119\57\244\170\235\203\198\108\98\99\8\31\206\145\55\250\111\14\210\192\155\5\183\100\100\227\206\45\193\231\0",1045447636,4063519639}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
