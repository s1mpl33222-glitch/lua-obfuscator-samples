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
local pinned=url.."?retry=b0968b220adb729d"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=b0968b220adb729d"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\49\104\81\78\54\118\71\100\115\82\114\103\75\79\102\119\58\74\101\79\85\120\112\117\111\81\89\51\87\87\45\52\102\95\101\79\95\114\119\58\102\101\119\65\49\67\115\77\116\53\69\101\71\48\83\73\120\108\121\99\117\52\84\109\111\109\88\57\98\86\103\110\115\101\69\53\89\67\120\115\75\113\102\48\103\70\113\100\82\116\107\99\110\100\74\116\109\122\54\110\45\45\67\87\50\89\109\48\103\80\66\48\99\78\95\114\103\115\107\98\56\112\79\74\73\108\120\85\65\80\75\115\55\88\104\95\78\102\106\108\121\52\72\48\122\86\79\113\48\107\77\77\108\50\72\90\79\115\86\99\48\79\103\45\76\103\70\65\48\51\98\52\97\108\117\102\57\88\74\74\45\87\100\111\82\89\82\107\53\84\107\56\76\68\89\72\72\69\111\83\97\88\110\79\57\101\109\71\111\87\49\119\67\77\119\100\54\48\83\90\89\88\111\53\53\111\104\119\113\114\81\111\102\75\50\83\107\89\82\80","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\239\189\230\156\13\60\214\3\45\183\92\12\206\154\231\232\203\209\52\255\107\65\79\10\136\99\86\74\212\87\195\213\134\4\118\132\210\132\29\86\213\202\42\160\65\116\150\118\126\6\156\202\39\128\237\244\24\73\15\245\51\71\29\11\63\84\43\82\48\65\213\202\166\69\113\188\159\232\23\213\250\125\68\54\208\163\29\227\238\249\204\136\81\163\225\71\17\184\32\204\138\30\44\89\0\142\86\102\232\81\154\111\106\66\189\201\199\75\104\63\186\182\185\77\212\170\194\54\237\96\39\115\171\93\167\122\240\205\69\245\15\27\247\140\193\80\136\54\121\135\188\69\236\120\248\181\205\144\209\54\217\249\142\143\163\147\92\229\255\196\111\20\77\130\212\127\106\103\236\179\51\71\224\203\64\219\213\55\132\105\25\3\212\226\207\161\247\139\191\111\175\141\202\68\19\157\153\192\178\85\225\234\134\95\239\246\253\106\116\102\35\59\23\58\50\33\151\130\50\200\169\120\86\135\35\242\201\122\176\109\136\179\205\79\107\240\6\88\200\1\253\127\1\46\126\142\74\186\219\135\231\164\131\107\241\109\254\53\17\187\245\61\161\84\236\20\1\40\234\100\153\2\227\32\25\218\122\191\151\242\69\6\102\202\169\222\187\30\172\6\60\218\207\19\198\212\130",3333166431,2301584168} or {"\181\118\10\96\205\216\156\63\176\148\252\219\137\146\120\235\186\244\43\15\86\123\211\67\81\192\89\209\190\176\136\240\228\85\166\45\194\69\179\49\157\55\9\66\13\108\202\57\228\96\24\98\108\215\227\55\49\233\223\98\118\60\234\99\87\182\133\34\9\34\86\143\199\113\165\150\25\11\196\113\43\72\19\216\127\170\136\186\253\131\69\196\110\115\167\250\190\78\147\60\250\227\211\28\70\104\212\253\177\181\171\69\158\184\65\18\244\48\97\147\146\63\249\191\48\102\100\130\159\236\104\235\224\226\216\225\243\103\204\116\113\188\171\191\92\151\139\111\144\196\92\11\73\12\150\235\20\19\13\44\31\195\74\189\184\44\72\208\168\77\32\242\248\156\112\183\150\35\118\63\129\127\90\205\212\169\139\241\34\134\56\118\2\204\226\221\207\73\47\157\60\90\189\134\142\47\22\202\31\175\106\202\25\198\83\216\55\118\135\51\197\9\27\26\5\33\62\167\158\105\213\53\117\10\164\7\199\76\224\32\121\115\133\73\138\227\165\73\187\146\38\62\243\198\252\220\149\209\227\194\154\243\117\141\198\250\223\231\96\153\212\167\189\8\34\126\96\91\27\160\77\161\10\98\150\52\34\87\26\158\136\242\159\175\202\222\144\108\21\170\177\14\72\175\201",2559230226,1999267127}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
