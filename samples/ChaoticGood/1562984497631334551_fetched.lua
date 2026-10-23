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
local fresh=url.."?retry=ef776d3754822191"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ef776d3754822191"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\115\100\115\51\89\53\84\114\102\109\74\84\84\55\122\115\58\72\122\101\48\45\85\114\49\111\118\118\70\113\75\120\116\108\119\85\85\99\103\58\109\54\68\89\113\104\85\45\53\84\90\82\78\98\54\51\119\73\81\121\73\54\90\89\69\68\113\115\56\108\57\69\108\118\69\56\101\109\107\53\55\121\49\111\89\115\90\99\48\73\66\113\109\73\112\85\115\84\78\54\54\118\80\76\116\65\110\82\84\118\82\50\100\121\117\97\104\98\81\95\103\74\110\77\68\50\83\85\89\54\103\83\82\70\56\87\104\69\56\122\50\80\101\52\89\55\106\53\104\116\89\71\85\95\95\95\86\57\116\57\54\81\103\111\45\45\66\103\77\117\117\116\81\50\76\116\110\121\84\49\81\85\84\71\74\48\113\103\104\117\57\78\104\111\83\83\77\53\71\79\55\115\67\82\109\76\90\111\101\76\51\50\54\56\110\76\87\77\122\86\115\45\48\67\79\118\75\65\122\65\110\88\77\99\89\122\81\50\113\108","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\95\45\96\87\40\135\252\144\14\209\199\220\20\204\27\1\98\60\48\51\83\235\254\56\80\190\31\119\206\94\38\42\220\110\145\223\218\116\140\66\221\46\225\97\96\185\81\140\208\225\58\62\43\94\176\103\159\186\224\167\141\178\189\21\65\106\241\84\4\56\106\38\6\172\37\20\79\124\247\218\255\165\21\170\89\246\204\14\165\228\58\199\121\130\156\116\126\191\127\178\185\138\132\96\86\119\192\29\151\143\63\10\125\249\196\8\4\226\109\169\224\52\144\40\64\46\15\35\117\12\175\197\148\12\11\33\195\34\34\104\12\37\150\158\212\9\88\194\43\66\80\42\210\165\252\99\70\88\108\10\231\156\75\81\122\179\15\39\127\203\5\225\203\190\209\42\118\195\54\97\213\183\186\175\7\202\236\131\198\24\219\184\61\45\49\232\160\116\158\175\119\64\145\119\51\33\48\57\84\238\196\213\225\66\118\238\7\106\50\205\170\2\53\254\203\255\75\186\201\139\10\254\110\27\155\209\208\7\233\41\133\129\88\92\57\202\242\46\159\7\248\225\214\79\141\164\83\81\201\81\220\86\199\109\5\217\250\18\38\98\20\214\45\33\87\63\44\201\115\171\190\196\238\228\127\70\152\245\127\174\215\62\57\69\1\174\37\185\15\111\93\242\96\2\202\5\9",3071377779,4158480885} or {"\105\228\247\193\148\173\99\97\152\89\11\41\68\129\130\215\69\58\149\184\115\135\133\13\186\41\130\195\223\25\173\182\214\114\205\218\148\55\184\139\114\254\9\243\150\252\13\72\7\253\121\108\19\119\152\195\77\14\176\203\231\238\28\133\55\50\201\117\105\67\130\66\137\70\22\70\210\63\198\106\160\121\44\59\159\231\2\166\106\215\61\22\120\188\31\200\72\188\22\25\207\121\80\243\143\122\88\108\177\117\11\104\176\245\207\229\61\8\6\28\151\128\125\53\96\182\254\49\222\190\38\120\252\166\138\12\92\45\72\195\125\122\209\27\25\153\149\34\181\128\161\213\132\188\187\151\125\28\108\152\235\241\102\184\136\159\101\29\204\190\78\236\133\144\242\14\220\33\36\159\65\18\201\187\21\230\243\103\224\171\183\238\66\109\92\197\97\4\21\88\36\116\246\138\206\98\10\186\80\26\255\214\129\225\165\148\118\175\239\250\61\36\134\1\238\242\64\246\148\252\59\242\238\0\170\119\63\99\231\142\159\78\43\160\116\21\16\169\66\156\110\252\246\90\87\219\82\8\115\10\204\207\86\190\45\64\142\211\82\82\89\111\239\35\52\25\83\105\146\36\180\163\204\29\237\117\247\237\65\88\170\125\253\91\137\140\38\68\229\35\175\252\147\124\213",303147944,3856688132}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
