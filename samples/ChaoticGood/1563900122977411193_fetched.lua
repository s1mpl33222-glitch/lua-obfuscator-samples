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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=196520e4aa8de266"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=196520e4aa8de266"
local expected=632423
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
if s2*65536.0+s1~=3646516830 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\117\109\87\100\50\65\108\113\81\54\55\88\70\69\86\84\58\68\49\122\89\95\108\90\84\77\87\76\119\114\57\82\53\67\81\120\67\97\119\58\87\50\51\90\52\51\67\97\104\45\69\106\78\98\106\103\52\119\53\111\84\70\55\116\56\114\90\111\82\52\113\90\53\51\112\110\57\89\48\103\105\57\74\50\88\56\49\106\114\51\80\100\70\48\50\101\118\65\56\104\81\103\103\116\86\56\67\68\85\68\87\116\108\111\103\101\114\89\97\89\49\51\102\65\106\67\56\105\72\108\86\120\75\90\82\113\55\45\53\81\56\81\72\49\68\74\122\67\106\99\67\74\82\84\77\111\86\121\56\105\53\110\53\121\57\107\102\66\48\97\81\80\118\83\52\54\56\66\112\84\50\80\77\97\81\105\49\98\72\101\117\121\107\109\55\90\115\95\85\80\72\68\48\77\69\120\121\76\54\88\55\104\104\53\100\75\75\57\57\84\98\81\121\109\65\110\81\103\66\50\89\118\77\106\97\107\119\119\77\97","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\105\194\45\34\2\145\221\126\47\104\166\2\59\43\197\200\187\28\175\105\15\252\74\11\95\135\43\31\121\114\53\208\158\113\68\65\74\233\0\179\124\119\119\247\87\95\154\189\60\230\119\252\97\45\28\186\50\179\18\66\211\121\67\132\194\129\33\13\196\115\224\132\229\189\37\122\198\229\68\60\105\71\178\33\108\234\59\118\62\24\166\214\101\128\187\111\234\113\125\103\49\246\193\210\83\2\222\69\105\1\11\11\37\16\27\135\155\64\238\218\126\68\3\12\56\17\253\220\9\129\114\210\100\161\251\71\13\108\60\182\140\187\235\170\72\193\70\2\125\218\72\182\13\169\110\226\89\225\184\172\143\145\18\155\25\215\211\39\105\128\184\174\57\62\220\208\15\143\123\85\207\230\131\26\113\204\127\91\6\249\239\129\114\30\237\19\57\109\199\144\209\55\207\226\35\30\136\184\131\10\58\198\61\5\75\163\140\70\65\62\87\47\243\145\8\160\104\106\115\215\4\226\185\52\16\149\172\44\38\50\238\222\81\174\198\201\203\205\8\182\227\135\102\27\106\150\47\206\147\35\212\85\155\182\251\250\175\67\14\80\232\40\181\194\195\126\187\81\199\225\171\177\41\224\148\234\214\237\68\181\181\229\132\57\15\204\204\54\159\207\7\236\240\252\255\17\194",3147331261,364928953} or {"\183\175\111\31\26\123\24\126\94\201\140\48\192\145\20\45\207\111\148\84\88\40\33\35\71\196\153\110\224\206\102\56\230\73\191\182\10\32\232\195\73\141\160\246\199\91\224\46\37\182\216\188\240\183\249\166\42\142\152\76\2\26\129\194\233\205\65\181\252\47\159\187\45\228\189\43\72\37\203\110\199\47\207\119\71\24\101\250\2\147\230\103\136\220\202\19\248\241\63\0\183\47\121\235\98\211\62\60\76\95\16\253\215\86\214\199\78\77\86\64\61\60\20\208\198\65\159\180\191\14\106\63\241\155\93\122\51\103\90\35\180\23\203\5\171\21\208\27\141\172\123\190\33\223\197\185\31\40\181\26\189\107\5\140\215\107\220\187\152\147\123\232\154\215\238\188\147\87\183\183\198\236\209\198\156\222\54\81\179\59\198\153\128\123\113\205\149\3\86\23\93\183\195\130\84\196\161\157\133\186\205\89\159\59\173\232\80\56\228\162\2\202\150\195\254\43\105\160\102\108\190\182\193\18\98\108\221\127\197\221\244\188\99\129\199\78\13\127\23\184\188\199\83\60\190\194\221\239\227\94\19\202\143\226\33\91\52\171\134\229\122\187\197\129\39\242\1\108\32\173\150\223\115\67\231\126\89\73\170\139\64\68\213\17\54\28\101\96\242\170\194\213\124\198\65",3545261555,64315848}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
