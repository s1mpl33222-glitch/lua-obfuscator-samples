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
local pinned=url.."?retry=6d8090cba9185053"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6d8090cba9185053"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\101\57\100\100\53\100\55\97\99\57\57\102\98\97\57\97\51\57\54\102\101\98\99\57\48\49\100\49\102\57\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\71\114\105\86\76\106\107\76\79\45\86\118\98\54\65\58\77\112\85\77\90\75\116\75\75\84\70\102\84\86\81\77\97\118\50\49\70\103\58\48\57\119\67\70\68\114\50\79\122\98\69\119\110\52\118\76\116\66\50\113\109\97\117\77\119\116\57\75\76\107\119\104\113\79\77\103\104\120\122\113\105\116\82\69\69\75\70\107\118\65\100\98\66\113\66\102\109\111\115\68\101\107\117\117\106\84\68\122\49\111\81\112\97\76\88\69\106\73\114\85\101\78\52\88\116\65\106\116\56\75\97\90\111\116\55\109\51\106\100\71\122\48\107\97\55\113\121\73\81\118\109\53\100\77\109\107\54\84\83\99\95\89\74\105\48\57\117\69\120\55\81\103\112\73\102\109\122\69\67\71\107\75\100\105\56\72\89\115\113\76\116\103\104\71\56\113\104\111\56\99\51\83\55\50\97\107\90\82\120\57\56\122\122\97\57\71\65\116\103\70\115\66\104\90\106\114\55\85\117\119\76\78\95\120\97\65\56\109\82","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\24\215\91\8\105\207\47\217\22\89\103\147\55\15\203\144\81\82\230\90\175\248\175\248\57\32\163\249\152\196\113\28\181\212\226\139\100\178\92\34\142\238\144\83\150\4\229\188\165\32\64\156\97\47\73\101\110\237\80\117\165\35\118\158\193\146\49\142\161\124\219\229\46\251\23\25\91\255\107\196\34\145\10\250\69\206\157\204\128\59\139\171\74\92\78\37\213\62\181\206\255\196\164\210\145\74\206\134\109\10\51\128\212\180\112\252\223\82\184\183\231\204\88\140\252\31\15\88\67\209\189\18\237\116\247\159\211\141\208\132\110\118\173\235\84\148\48\213\75\184\114\21\208\148\198\182\248\136\131\17\196\34\19\109\113\95\135\224\67\115\14\93\38\170\109\18\67\36\241\221\14\184\96\191\226\254\154\37\95\196\133\177\130\121\248\17\165\173\119\35\118\79\52\32\175\79\184\204\107\236\140\230\102\242\252\207\243\241\151\39\219\24\167\120\212\187\14\233\33\36\210\80\175\130\228\41\233\52\121\246\129\84\20\93\171\254\137\219\153\99\149\26\12\213\121\214\60\137\58\102\241\226\14\167\151\82\237\123\121\174\153\9\65\182\252\214\13\190\134\224\202\95\124\130\198\66\91\64\173\241\110\49\212\127\22\238\210\240\253\208\213\172\151\249\207\72\174",4128677956,2597086628} or {"\184\19\203\210\30\28\197\143\251\148\163\54\95\69\227\131\145\134\81\211\210\233\116\242\181\5\79\226\190\137\246\94\143\216\26\166\200\140\245\76\247\26\1\2\17\42\37\238\86\192\117\142\70\163\88\29\120\220\72\45\34\214\252\125\68\49\92\240\114\152\49\20\47\202\107\4\243\38\69\136\95\132\7\203\103\105\22\115\238\82\74\246\230\138\161\135\20\108\110\219\127\142\46\191\101\250\241\231\135\172\50\224\44\100\131\83\162\9\180\123\52\12\82\90\65\36\76\214\12\123\191\75\119\117\152\172\184\253\60\188\188\28\159\84\217\174\217\36\70\119\8\215\161\159\238\11\131\201\208\51\184\222\66\75\27\96\23\45\41\11\17\102\220\12\9\142\100\38\98\188\70\142\227\33\82\73\4\211\93\182\87\187\53\138\222\200\225\38\25\154\131\225\114\108\94\34\141\179\117\116\207\60\81\222\38\224\156\128\204\86\195\203\25\98\157\210\19\46\105\140\33\21\202\71\34\200\113\167\69\68\239\82\155\170\61\106\118\127\113\69\179\200\181\5\4\19\243\100\71\163\178\84\1\228\25\72\6\125\8\237\148\152\175\7\33\86\189\17\225\198\104\191\107\112\227\83\130\32\38\162\87\13\159\254\30\37\182\119\95\24\114\242\232\28\238",2762799885,2268686259}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
