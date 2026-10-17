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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=f756901af017d35a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=f756901af017d35a"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\54\55\55\50\52\56\51\54\56\101\52\100\48\48\98\99\54\98\49\54\52\97\102\48\101\48\50\99\49\102\97\57","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\75\51\115\56\110\116\106\56\108\89\122\85\79\113\106\58\98\100\86\103\115\80\81\87\111\101\107\117\97\78\117\116\84\55\81\69\90\81\58\81\83\49\69\74\70\52\105\49\90\112\71\57\119\106\111\83\75\90\52\107\113\77\48\75\48\50\72\53\68\86\74\121\68\113\85\84\88\57\118\113\109\68\85\87\112\98\86\95\51\108\86\108\114\75\113\99\86\81\88\68\83\80\114\121\73\105\51\57\87\103\50\66\68\80\115\65\85\109\98\57\71\107\80\87\104\119\108\74\73\51\115\83\100\89\122\68\52\98\83\113\76\112\118\84\118\45\84\108\108\115\89\75\87\53\45\72\77\104\52\52\57\51\87\72\73\81\48\85\76\108\121\102\75\99\109\45\55\109\51\57\68\115\110\99\79\85\82\53\88\118\107\55\109\108\85\121\86\121\76\65\48\77\45\95\57\122\111\89\104\101\70\101\88\116\56\104\49\80\80\67\108\78\84\75\114\83\81\90\97\112\66\105\117\78\51\89\48\95\45","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\0\93\52\239\48\51\53\12\53\228\174\90\198\85\134\129\162\90\5\42\96\61\167\119\152\32\37\255\158\47\59\249\154\104\50\228\215\216\0\188\11\174\99\238\17\153\195\251\40\217\185\25\26\221\110\69\180\191\198\61\213\46\67\92\159\3\172\114\113\43\162\246\160\119\167\66\31\41\43\194\58\205\173\41\221\228\28\39\0\203\7\40\206\92\102\70\203\63\184\10\101\28\218\36\89\141\160\233\146\238\40\67\4\37\247\87\39\98\25\118\114\60\240\18\198\70\213\20\110\69\13\220\236\10\166\133\51\249\233\116\66\238\89\214\202\56\150\52\135\152\219\189\90\138\131\67\151\255\246\19\48\93\178\196\105\180\229\4\91\3\48\8\162\205\71\113\212\103\48\177\207\76\212\161\27\121\11\237\237\197\250\236\158\105\118\201\96\223\253\194\242\253\211\32\43\15\130\55\47\102\95\81\98\97\73\86\146\175\246\35\73\38\82\120\100\2\211\178\177\209\7\125\41\235\247\43\238\132\153\84\199\162\24\8\163\64\60\74\131\62\82\128\154\166\245\6\97\182\63\31\65\107\10\138\223\110\249\144\139\128\186\122\244\246\104\126\122\143\141\197\81\161\158\204\237\74\26\215\251\51\173\222\91\54\22\138\137\98\125\218\15\218\194\96\96\177\35",666145168,1645699430} or {"\53\4\44\52\45\252\192\102\149\4\32\227\129\54\255\3\110\127\208\149\131\117\104\234\239\59\71\158\73\17\233\232\165\149\156\230\57\215\105\70\84\203\185\253\247\147\7\115\0\77\147\84\245\226\144\242\116\79\20\54\152\10\58\252\223\91\84\116\93\253\49\4\183\16\217\196\179\189\193\0\171\125\255\201\134\165\238\151\24\151\93\209\163\237\149\152\125\164\104\74\3\15\103\144\98\57\197\179\55\40\192\105\94\57\123\133\250\206\9\28\146\98\117\110\24\134\176\59\32\70\94\195\9\201\172\161\110\236\158\47\188\97\32\129\150\157\203\73\246\145\43\33\181\133\31\167\149\69\198\172\254\142\62\8\186\61\18\242\13\235\53\184\69\11\145\214\71\66\137\198\147\49\83\134\64\158\178\7\31\14\71\172\140\112\17\28\156\214\133\153\6\195\160\3\118\134\225\167\113\141\75\6\48\209\90\110\239\89\95\48\25\2\128\188\222\115\123\30\255\201\55\119\114\45\50\39\47\75\247\82\86\231\72\86\153\213\146\104\60\113\7\116\193\50\228\239\194\246\103\3\139\91\59\201\90\127\158\36\203\106\52\157\237\4\66\35\17\254\39\135\224\86\199\69\44\214\57\63\185\46\222\11\137\145\55\234\188\238\33\197\190\60\125\159\72",379048340,1352164213}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
