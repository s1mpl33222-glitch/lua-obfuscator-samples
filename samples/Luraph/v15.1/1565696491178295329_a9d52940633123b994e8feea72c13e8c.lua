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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=f774228362980c91"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=f774228362980c91"
local expected=627508
local runtime,reason,issue,pr=nil,nil,"timed out",0
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
if s2*65536.0+s1~=368677546 then problem("runtime checksum mismatch",3);return end
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
local cs={{fetch,"HttpGet",url}}
if fallback~=""then cs[#cs+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then cs[#cs+1]={candidate[1],candidate[2],fallback,true}end
cs[#cs+1]={candidate[1],candidate[2],fresh}
end
cs[#cs+1]={fetch,"HttpGet",retry}
local started,ni,ls,idle=clock(),1,0,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=cs[ni];ni=ni+1;ls=clock()
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
for poll=1,4000 do
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
if runtime or reason or(active==0 and ni>#cs)then break end
local t=clock()
if t-started-idle>=40 then problem("HTTP download timed out after 40 seconds",4);break end
if ni<=#cs and(active==0 or(active<2 and(completed or t-ls>=8)))then launch()
elseif not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break
else idle=idle+math.max(clock()-t-1,0)end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\57\100\53\50\57\52\48\54\51\51\49\50\51\98\57\57\52\101\56\102\101\101\97\55\50\99\49\51\101\56\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\48\49\120\116\69\87\79\121\88\109\116\95\99\103\72\49\58\106\79\100\49\107\114\55\87\79\48\45\111\66\45\95\89\119\90\54\113\54\65\58\80\122\56\56\117\66\71\55\122\121\95\90\114\98\68\98\53\82\45\115\71\110\109\114\122\53\67\72\54\56\100\86\103\108\53\67\113\49\84\55\84\72\68\73\81\85\76\120\49\49\97\102\101\101\81\118\105\80\89\110\81\81\69\70\90\87\118\101\98\90\76\95\54\48\79\88\104\49\77\53\95\106\88\69\112\72\120\78\90\95\72\108\100\114\77\53\87\54\86\71\72\69\72\49\73\95\86\116\55\48\113\105\45\86\97\81\76\98\98\68\117\88\73\84\49\81\109\102\83\76\51\117\56\56\106\75\103\53\68\76\95\51\117\122\119\106\54\112\104\57\83\82\84\53\87\69\100\57\74\121\71\87\121\102\85\85\69\105\90\50\71\98\82\84\54\115\85\109\110\104\111\45\73\98\113\53\52\113\105\100\122\121\79\87\117\57\55\78\85\51","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if not pcall(fetch,host,target)and reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\17\232\172\77\237\166\129\188\191\13\11\103\202\246\200\148\237\120\57\42\110\69\154\65\44\208\86\158\216\153\131\162\230\228\10\114\82\87\188\235\175\189\227\25\238\13\64\166\60\217\129\83\160\231\221\181\223\27\248\108\85\25\43\229\99\9\0\233\94\217\107\245\129\17\146\111\156\51\121\66\96\27\180\165\108\160\24\145\34\151\53\91\123\203\51\238\177\228\122\133\49\1\18\132\109\141\185\118\177\36\53\146\110\4\221\79\98\253\73\92\147\212\195\232\36\172\94\124\186\108\244\125\205\224\202\41\11\220\145\29\209\225\227\197\83\47\229\245\71\56\101\128\121\57\134\117\6\125\27\223\228\114\143\96\16\212\164\124\160\138\179\178\135\192\216\245\184\212\100\212\121\111\58\144\16\97\217\236\210\212\7\87\206\36\197\61\50\64\34\181\123\222\47\121\145\95\110\75\89\162\223\27\151\146\147\138\153\154\84\190\140\127\72\200\73\189\26\221\70\249\227\224\64\116\186\251\24\241\107\77\50\64\11\92\246\14\246\248\193\120\153\23\163\192\30\9\15\182\58\189\230\168\129\56\176\225\59\238\160\39\16\129\175\21\53\21\32\193\201\48\92\211\207\27\142\191\77\251\1\176\146\157\75\209\127\64\39\214\174\82\61\246\80\46\53\234\172",1423992676,1850302514} or {"\230\39\84\183\30\6\216\249\82\224\165\7\34\245\162\147\233\146\239\249\218\171\103\189\144\177\104\213\117\137\224\57\125\97\25\86\57\120\4\191\106\106\73\166\189\51\56\155\233\126\105\247\134\97\30\89\141\115\248\7\208\248\25\209\133\168\56\129\48\151\132\210\232\213\34\204\92\191\233\96\242\39\191\241\238\196\187\209\195\16\30\167\70\145\182\224\17\60\59\29\191\48\103\248\95\208\192\227\49\101\157\205\252\132\131\161\56\157\225\202\23\136\120\235\4\231\8\24\207\87\140\124\69\0\205\57\153\49\41\156\144\151\182\153\65\142\61\184\32\88\199\186\97\140\214\157\114\230\142\240\17\156\219\81\128\251\147\184\129\60\29\140\138\81\101\6\126\62\65\216\226\68\190\201\7\161\16\27\175\1\233\205\128\140\202\31\246\155\242\30\146\191\202\219\177\83\176\140\4\227\166\135\100\84\232\253\139\110\171\147\21\198\148\198\34\126\142\150\151\127\178\65\72\223\155\64\163\117\95\244\56\25\44\35\1\158\172\104\25\28\157\70\177\150\86\131\46\36\218\216\41\105\140\72\31\229\108\89\162\13\225\232\32\214\109\165\56\39\102\10\157\86\8\87\212\204\101\60\14\124\154\193\85\206\26\35\105\198\49\171\116\201\205\151\162",942894724,1554670145}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
