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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=a30ea94245f224da"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=a30ea94245f224da"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\100\55\56\48\54\98\51\57\55\54\50\98\97\100\99\98\102\50\100\97\52\48\56\56\100\48\56\98\98\49\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\110\89\88\114\106\55\71\117\106\100\77\102\81\53\89\111\58\110\106\57\72\95\107\71\68\112\108\67\89\71\57\116\81\122\78\56\117\114\81\58\103\72\86\83\98\90\97\112\106\113\82\50\57\69\106\75\77\45\106\79\83\65\109\107\49\102\77\55\100\57\95\112\98\122\109\66\66\104\110\78\108\54\86\51\66\71\56\77\71\78\79\87\87\118\86\78\52\50\103\109\113\83\54\120\56\75\101\108\67\110\106\69\45\81\119\76\72\54\90\108\99\67\114\52\72\101\110\79\110\89\66\52\79\82\81\111\85\49\118\99\70\114\107\95\77\108\117\101\71\108\102\77\99\119\75\77\52\107\48\89\95\112\109\51\95\50\55\78\70\74\71\113\76\88\103\115\87\48\57\89\50\79\51\119\89\45\86\122\85\117\84\80\80\68\55\117\102\90\76\87\66\111\50\72\69\118\54\114\112\89\69\66\103\102\79\95\99\101\97\95\106\65\75\65\52\65\114\52\81\45\87\102\117\95\116\79\85\98\81\82","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\38\12\51\116\78\70\46\255\245\225\170\158\36\34\68\103\210\83\164\59\114\69\57\45\139\234\229\194\156\242\183\230\91\79\161\222\8\126\5\140\32\80\174\177\37\179\202\228\63\23\250\79\174\217\182\128\21\56\115\217\155\41\182\198\220\252\51\44\113\220\143\76\151\111\208\98\225\127\206\206\248\206\41\242\36\117\70\144\198\163\228\140\166\104\52\133\67\130\181\4\162\189\104\32\59\47\122\164\239\24\76\251\143\186\163\161\201\13\141\81\1\214\34\98\140\84\211\202\201\207\213\193\216\87\104\85\6\2\99\5\6\72\239\184\243\16\230\83\129\235\55\179\35\45\87\175\168\223\149\166\72\46\141\168\20\161\204\34\219\234\19\226\53\195\25\13\16\46\169\192\83\151\9\235\175\186\185\255\182\150\46\29\186\184\13\101\204\142\212\164\181\87\44\125\168\21\179\90\32\35\230\148\48\36\184\224\165\220\179\157\210\154\181\223\187\176\96\132\253\43\143\223\249\118\108\137\169\1\119\222\215\216\129\20\81\172\230\234\203\94\246\119\248\154\57\147\54\145\141\115\7\149\210\150\148\196\226\96\139\173\80\114\116\237\57\235\56\121\46\0\87\243\142\160\49\82\234\47\84\31\100\140\66\71\229\167\226\53\147\2\92\31\175\54\191\22\3",148195418,4168770033} or {"\205\113\224\178\117\192\118\191\76\117\9\198\104\213\28\114\234\62\96\51\124\177\144\244\205\191\66\228\59\90\200\184\106\99\68\165\62\58\181\107\7\123\38\103\76\189\194\120\89\115\70\62\116\177\62\87\14\55\179\157\83\129\44\243\229\241\217\31\15\88\125\85\63\169\141\73\179\10\53\228\134\90\155\64\39\96\215\255\17\125\215\215\19\255\23\147\22\0\61\246\115\163\129\114\223\148\186\220\40\254\64\211\225\96\175\175\194\61\231\10\160\218\131\20\89\162\148\58\124\231\30\116\139\63\59\109\231\148\131\86\129\210\210\43\24\76\82\196\215\192\210\135\242\113\56\174\185\136\187\131\226\63\78\220\111\8\16\37\207\132\55\95\190\24\11\98\31\66\92\214\228\120\189\51\54\242\247\228\154\210\161\122\42\231\70\213\164\253\211\191\183\13\15\47\8\44\146\163\236\165\155\232\54\243\118\79\11\73\193\56\48\14\41\166\168\234\252\68\118\115\119\122\5\142\214\91\54\179\242\129\93\206\254\224\132\204\153\252\62\253\40\91\35\109\193\141\205\30\203\181\78\9\183\68\251\249\232\90\177\208\168\14\84\211\51\189\50\236\148\166\49\104\138\137\255\165\133\125\166\112\151\245\122\145\113\87\207\183\22\81\206\5\142\59\228",4108047619,3856098304}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
