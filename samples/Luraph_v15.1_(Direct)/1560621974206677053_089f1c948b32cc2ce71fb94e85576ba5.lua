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
local pinned=url.."?retry=cb3a9c75a8344098"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=cb3a9c75a8344098"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\56\57\102\49\99\57\52\56\98\51\50\99\99\50\99\101\55\49\102\98\57\52\101\56\53\53\55\54\98\97\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\54\48\45\77\52\49\118\98\110\67\72\56\82\82\99\73\58\87\68\49\77\102\100\112\68\49\79\57\122\73\49\112\51\120\53\70\71\57\119\58\51\110\52\111\50\56\45\95\108\74\85\111\67\70\57\51\101\95\115\115\90\71\55\45\102\108\77\76\113\78\82\50\118\75\68\86\51\86\69\72\98\72\69\103\114\107\66\108\103\82\90\117\110\109\57\89\80\68\52\83\101\116\100\52\86\118\84\99\87\48\104\101\101\105\89\76\83\49\84\122\74\72\83\75\81\110\109\110\98\115\99\79\105\49\114\69\106\86\72\45\122\84\107\100\84\109\84\82\75\98\65\51\112\74\66\115\104\79\65\100\51\90\112\77\73\102\116\88\71\67\66\88\84\68\48\72\118\56\109\95\80\49\70\113\72\85\73\68\66\49\97\116\105\120\108\112\122\70\65\109\99\76\74\71\107\85\99\48\85\55\80\106\81\77\118\68\88\112\104\110\67\57\57\81\113\67\77\85\105\98\98\69\73\74\53\84\48\95\113\80","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\95\190\25\80\189\150\254\142\206\62\69\120\243\119\49\34\73\199\63\146\22\0\131\167\46\126\117\127\73\21\248\15\157\22\227\74\101\109\255\7\78\124\111\161\218\234\151\206\132\238\32\137\20\105\81\168\222\206\111\135\165\165\194\230\84\223\24\30\179\101\194\109\146\229\254\177\98\182\39\37\100\197\235\157\15\140\249\245\83\28\117\20\137\221\47\97\44\5\249\120\105\122\175\118\84\213\13\45\190\152\50\190\27\61\4\93\31\161\141\156\126\135\100\11\70\52\236\158\99\131\73\176\195\201\56\127\138\56\250\229\129\227\57\38\95\208\82\177\239\37\136\1\94\207\227\174\177\26\102\208\182\182\126\199\9\147\178\87\190\177\89\32\57\59\33\237\35\223\121\131\218\152\34\182\165\193\8\50\3\28\227\66\70\242\78\169\141\93\199\200\30\214\27\104\141\176\114\208\179\211\1\21\148\140\210\115\51\73\253\162\17\88\118\79\3\233\238\146\31\132\232\177\67\46\72\237\229\190\111\226\59\42\7\143\232\180\47\12\42\233\92\153\210\240\195\124\166\39\200\95\38\153\216\103\15\224\25\145\81\189\167\36\43\40\76\41\81\158\123\13\239\131\151\127\85\70\58\133\235\158\250\139\74\121\248\164\199\165\218\251\216\225\103\68\156\96\123",2502833449,3952828364} or {"\110\83\221\77\129\175\177\226\10\142\252\215\138\208\92\70\111\253\134\111\90\39\109\123\239\60\81\103\165\113\249\108\79\173\244\133\151\178\165\112\25\185\124\38\110\182\101\51\97\118\189\97\250\157\115\173\122\70\160\76\51\214\91\94\253\78\126\53\242\24\157\138\167\211\174\17\168\74\117\65\212\168\136\82\147\143\244\80\235\118\208\176\253\62\75\239\152\222\117\16\8\79\196\45\64\64\2\58\97\65\250\115\61\142\48\206\230\213\185\49\140\121\149\179\191\160\19\194\203\128\230\218\62\57\93\21\191\254\42\134\229\3\203\243\169\101\180\129\218\165\118\24\157\115\134\174\37\80\231\199\90\136\142\191\61\125\151\173\62\251\57\245\74\127\64\184\22\197\156\157\207\221\116\168\177\54\179\33\124\9\112\184\31\230\177\70\247\18\228\34\188\45\207\152\144\106\243\18\69\166\183\34\213\150\161\112\68\241\248\128\169\122\18\89\93\19\188\88\9\2\154\87\63\0\52\96\220\83\82\63\143\27\182\49\2\246\105\26\53\179\110\130\210\31\255\97\171\164\210\223\139\132\217\133\181\72\209\66\154\67\130\237\75\3\201\128\30\143\36\114\19\162\112\244\101\109\176\151\177\253\3\48\43\44\49\120\50\113\79\7\80\61\34\254\21",2955278441,3650118107}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
