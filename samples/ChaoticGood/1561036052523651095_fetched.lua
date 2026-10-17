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
local pinned=url.."?retry=4313c235758a20a8"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4313c235758a20a8"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\101\116\51\50\51\101\69\110\84\88\77\117\53\50\55\120\58\120\51\76\121\99\113\115\106\102\70\111\89\52\115\119\114\56\85\98\105\105\103\58\49\50\70\74\72\78\53\105\56\111\69\107\90\51\82\114\119\119\52\89\98\74\95\45\97\119\111\77\100\88\104\90\85\66\70\72\68\97\112\106\81\111\86\102\104\112\87\110\50\117\69\114\101\71\95\83\86\80\108\97\78\51\87\74\73\53\104\83\68\56\112\95\56\116\82\104\104\55\72\111\73\122\52\117\122\111\69\83\103\70\114\100\98\50\74\77\76\112\69\87\100\68\67\103\102\90\95\97\103\74\111\57\86\110\52\81\85\66\51\86\118\50\74\80\113\100\100\48\48\99\104\117\113\76\122\111\121\69\99\88\121\109\116\74\56\79\89\102\57\70\119\121\69\76\81\113\53\116\115\84\87\76\118\68\55\49\88\112\88\89\68\79\65\55\57\104\108\86\110\56\80\113\88\83\82\50\101\115\120\110\103\89\122\87\70\66\66\106\85\78","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\94\68\109\231\158\3\109\69\161\255\26\63\9\185\164\1\138\42\179\130\6\122\16\9\197\210\89\223\75\70\246\166\104\170\140\70\30\32\187\184\28\218\173\151\225\222\98\41\62\201\54\46\85\92\227\201\32\70\103\35\154\39\194\168\183\52\223\180\91\190\234\57\12\15\12\75\9\136\122\118\118\114\10\6\7\214\80\14\235\244\216\227\83\45\35\213\186\210\40\246\125\70\106\1\216\211\58\42\82\175\107\240\127\43\135\205\125\193\238\173\16\110\221\143\74\240\61\162\114\23\230\6\41\99\180\160\54\148\36\180\15\5\105\121\251\201\39\39\25\166\133\214\47\122\255\214\108\193\167\203\98\84\153\240\215\30\215\94\93\7\168\24\97\220\203\66\133\66\114\134\145\200\84\106\19\180\108\80\205\153\205\29\236\215\214\191\120\119\63\168\52\175\168\115\234\150\25\187\18\169\20\40\59\21\69\182\163\96\101\109\125\225\10\76\18\53\198\127\94\94\53\194\157\239\148\3\102\125\155\32\148\208\63\234\132\44\88\188\3\209\161\49\151\75\18\70\160\162\137\29\19\47\34\245\129\14\184\102\158\233\128\229\27\159\158\212\172\134\92\218\134\114\223\15\185\129\195\133\61\31\185\130\204\82\162\29\143\35\164\231\183\5\12\56\130\5\212",3556392669,4273759041} or {"\65\56\59\78\146\206\190\69\194\44\86\248\54\64\136\72\100\97\253\178\138\237\143\182\244\106\217\42\27\60\215\60\60\199\208\12\229\147\70\11\223\254\210\106\138\243\183\16\60\148\146\66\117\35\55\64\184\73\77\253\49\53\67\22\0\165\193\150\194\133\160\179\70\40\168\155\58\82\15\253\136\5\181\19\252\12\158\36\26\43\219\28\23\90\199\1\20\91\241\53\29\153\118\57\101\25\154\122\146\210\124\143\171\199\117\45\10\7\246\179\126\104\72\176\163\85\47\4\64\77\144\14\24\155\80\164\133\35\36\90\36\149\130\91\76\98\179\161\27\235\161\164\94\166\134\251\230\74\19\85\110\217\74\20\173\177\152\67\5\169\125\133\238\111\52\143\188\198\96\243\68\237\85\74\232\169\235\231\100\44\34\92\52\214\139\243\252\103\85\69\117\138\221\127\237\1\162\167\50\195\184\190\85\94\219\237\164\251\0\45\136\117\80\83\57\75\242\115\25\48\149\109\123\115\216\228\99\68\46\234\184\63\184\176\106\112\123\32\87\1\34\202\95\213\24\199\5\142\112\226\247\112\182\100\107\69\127\157\237\8\104\208\225\101\56\73\206\123\137\38\105\230\117\71\226\147\96\181\196\205\97\42\133\10\168\1\58\157\191\202\141\154\77\214\16",37643371,3973145936}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
