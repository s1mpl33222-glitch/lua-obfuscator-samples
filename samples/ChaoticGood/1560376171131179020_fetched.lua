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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=5f0b94e4abacd7ab"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=5f0b94e4abacd7ab"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\48\113\70\82\72\56\113\105\77\79\101\54\75\56\51\95\58\99\109\120\54\104\55\122\66\53\108\82\49\66\70\65\77\101\121\103\82\113\103\58\48\118\82\112\51\90\51\90\78\119\73\108\102\50\110\48\82\79\117\105\117\87\49\90\48\102\52\97\49\110\76\52\83\90\110\118\75\86\101\77\68\89\104\106\118\65\70\83\86\86\95\49\100\69\117\102\75\81\88\101\117\72\85\88\51\78\106\101\55\104\107\89\71\121\72\54\69\114\67\97\54\50\106\71\56\74\85\104\122\113\95\69\86\103\66\65\90\108\69\115\101\118\56\97\68\65\54\100\90\57\116\57\105\76\52\55\104\118\52\77\78\78\72\117\66\112\70\103\78\67\105\45\50\45\109\55\104\77\52\120\48\83\114\72\75\56\101\86\79\73\114\90\84\54\69\107\114\57\77\87\88\69\90\111\122\110\108\111\71\90\66\111\86\70\72\117\90\115\80\117\67\75\87\88\80\50\104\72\105\76\50\65\74\78\88\75\105\49\66\95","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\224\233\105\56\120\156\198\27\145\59\116\50\226\3\72\81\15\84\118\139\2\38\138\18\137\131\130\120\23\186\193\164\190\224\157\149\123\64\137\117\182\110\60\35\236\233\49\201\159\5\250\43\57\9\134\150\73\113\158\241\45\157\127\156\60\160\189\225\101\184\70\235\79\14\54\135\141\102\29\149\184\69\104\70\108\250\160\192\77\253\177\150\198\60\11\132\51\125\71\243\48\31\241\62\3\199\237\188\253\114\70\241\148\161\161\141\21\71\36\67\223\207\53\14\15\89\4\196\34\161\60\32\211\109\226\160\65\69\78\78\104\134\73\13\167\10\12\65\9\188\239\163\247\12\171\14\65\105\62\254\108\252\125\44\74\34\159\231\172\182\198\62\74\99\184\237\87\125\56\96\142\70\89\159\87\189\215\180\240\135\121\112\212\229\216\228\219\253\173\190\24\192\199\57\134\172\228\237\56\90\31\40\156\203\121\75\246\148\13\167\163\107\254\96\205\3\141\71\71\184\27\215\92\111\83\140\194\93\139\82\88\199\207\210\60\4\29\41\243\6\122\160\60\255\75\229\218\151\44\58\229\128\177\250\86\31\186\189\142\233\251\176\86\0\128\53\49\187\15\167\110\227\68\38\117\181\72\198\109\74\129\15\201\230\62\59\79\15\66\79\184\217\158\236\148\200\209",1664135962,2686279687} or {"\253\245\41\75\34\107\224\79\62\229\215\223\187\130\37\32\36\112\244\236\203\141\237\117\99\190\80\168\197\121\154\219\228\177\149\79\152\156\87\64\126\134\225\163\114\77\16\2\53\198\28\166\126\93\36\209\134\144\184\146\89\127\1\44\29\191\167\53\35\224\159\3\246\128\179\72\139\43\199\197\113\92\140\250\55\171\62\219\117\112\64\255\182\158\45\143\201\104\182\148\232\2\120\175\25\197\112\116\253\61\23\139\114\24\90\195\128\116\168\135\226\127\217\225\171\51\157\253\212\136\201\133\223\118\184\21\212\68\23\69\176\156\126\7\139\30\195\140\119\0\228\161\28\254\120\10\124\228\249\30\44\243\100\158\236\67\42\31\150\126\137\208\145\169\29\132\177\219\90\157\235\249\250\48\88\38\89\156\4\159\50\114\156\87\11\60\13\30\184\189\244\144\242\138\164\239\174\5\122\213\55\114\123\130\4\58\179\186\184\80\242\114\97\27\45\236\52\239\233\152\5\193\116\83\88\136\36\224\75\140\195\226\4\25\114\71\177\20\185\30\184\145\226\223\101\48\70\132\20\61\13\168\111\29\41\6\157\184\30\167\148\71\116\197\24\184\211\25\164\69\182\45\40\242\150\100\247\11\84\145\243\32\135\237\243\167\226\50\69\128\196\1\166\245\50",258389234,2383962646}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
