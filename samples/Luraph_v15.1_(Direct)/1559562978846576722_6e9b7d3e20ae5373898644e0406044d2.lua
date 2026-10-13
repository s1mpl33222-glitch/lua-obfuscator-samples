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
local pinned=url.."?retry=b41878584a391d57"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=b41878584a391d57"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\54\101\57\98\55\100\51\101\50\48\97\101\53\51\55\51\56\57\56\54\52\52\101\48\52\48\54\48\52\52\100\50","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\83\81\97\80\86\77\112\120\122\90\103\82\98\85\85\108\58\78\81\83\101\87\75\49\101\107\84\118\87\107\117\89\89\78\74\113\54\55\81\58\95\110\116\101\122\113\105\101\120\57\57\82\84\111\67\103\53\121\67\101\119\65\57\110\112\71\52\53\48\48\73\55\78\112\112\52\72\113\113\107\78\77\118\118\118\101\75\56\114\81\53\121\76\109\56\51\86\120\110\101\82\67\117\52\111\77\113\49\75\53\105\121\117\57\69\95\45\95\112\50\114\84\55\65\117\84\99\112\77\53\87\105\112\68\117\76\108\51\50\54\68\75\100\50\67\89\100\116\49\112\75\89\82\77\121\115\100\122\109\75\74\73\100\90\50\101\114\120\73\109\118\107\86\119\119\122\90\81\82\56\80\78\85\53\120\75\122\45\116\45\112\68\102\107\54\52\56\88\70\101\74\89\77\75\117\109\57\78\84\74\85\50\113\52\107\76\80\50\75\97\68\67\57\88\122\114\112\78\54\113\73\89\68\79\88\79\82\109\51\108","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\88\225\15\12\201\251\219\180\145\43\37\15\2\165\129\188\211\130\147\10\55\181\222\255\164\165\167\28\237\54\124\241\55\228\8\7\118\249\205\132\81\52\205\188\133\244\134\39\103\51\68\85\79\35\237\107\42\39\170\188\27\26\255\67\94\22\122\2\237\145\106\218\84\211\198\129\16\91\184\39\24\174\56\224\126\91\226\65\157\40\66\255\146\237\129\25\58\110\56\43\200\14\26\201\96\83\217\215\217\210\204\110\157\96\15\67\85\136\87\62\165\116\70\147\48\238\90\253\65\79\188\172\246\181\48\2\252\201\9\228\245\22\141\124\82\130\192\100\89\118\106\104\38\20\77\224\228\152\67\17\3\220\107\130\14\169\32\119\103\242\242\25\196\179\193\219\235\186\140\252\125\74\44\232\222\32\3\198\97\108\130\204\124\110\3\205\83\141\239\84\78\251\172\208\193\167\70\114\142\27\73\197\120\60\203\241\40\180\217\7\228\237\228\142\231\108\180\236\39\141\211\122\8\86\105\9\28\56\232\200\80\104\112\95\92\153\19\144\11\119\165\114\206\223\10\237\214\115\134\232\18\8\169\129\218\238\165\207\144\38\8\42\245\130\30\214\14\138\148\234\62\141\184\110\90\222\138\252\99\107\154\210\124\107\99\75\231\163\255\162\119\162\142\176\203\45\151",2101517083,2333172211} or {"\82\213\190\81\85\48\178\130\31\133\121\95\174\80\156\216\106\159\133\38\58\222\17\60\177\156\216\95\99\125\202\82\194\244\133\44\48\1\217\196\19\113\187\159\211\82\37\156\118\140\123\187\33\174\188\166\102\36\195\45\173\204\123\85\115\135\193\169\254\232\16\213\45\215\13\134\155\163\65\240\65\195\243\168\231\134\199\88\0\152\187\89\212\196\80\8\187\116\147\71\161\175\83\216\16\31\91\96\53\41\145\121\215\32\222\225\107\238\171\199\207\9\203\135\235\52\229\168\188\59\85\253\210\218\241\51\98\202\135\161\160\243\50\49\137\116\32\166\229\31\62\22\73\168\212\224\73\244\94\24\218\46\26\109\183\65\10\175\28\1\109\36\203\126\224\152\209\183\48\31\86\134\60\239\79\119\195\69\14\111\104\168\169\4\68\40\210\163\166\40\58\148\73\69\246\99\8\64\36\31\103\237\28\91\33\101\252\111\5\237\153\71\158\242\6\242\135\153\134\155\11\139\70\209\54\191\142\151\226\65\133\154\180\166\144\1\210\3\117\240\91\49\111\145\208\170\116\193\170\224\48\131\217\157\176\22\10\196\20\164\251\130\141\17\0\61\16\196\7\222\4\15\103\204\249\193\240\76\104\171\16\243\206\28\243\91\73\104\252\87\159\130\4\195\159",2665388678,2056807426}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
