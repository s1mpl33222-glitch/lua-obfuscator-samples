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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=605bb8dcee7870d9"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=605bb8dcee7870d9"
local expected=618951
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
if s2*65536.0+s1~=733717851 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\57\99\97\101\97\49\53\50\56\53\99\102\50\54\97\101\97\51\55\54\98\51\102\99\50\102\100\98\57\54\50\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\68\78\77\75\70\49\68\110\118\105\106\88\100\65\78\90\58\75\97\113\53\71\85\102\119\65\110\113\99\81\121\89\49\56\53\53\115\74\65\58\118\97\103\120\107\97\54\54\100\112\56\79\68\119\83\116\81\52\50\76\78\51\76\55\48\83\76\79\51\115\88\117\86\105\98\75\97\114\76\83\122\89\122\80\107\110\82\49\88\117\77\105\116\78\112\103\48\95\79\110\77\80\75\74\68\95\55\110\118\104\57\111\55\74\119\102\117\121\114\71\101\109\52\51\107\77\86\57\66\99\87\51\86\87\117\68\102\72\56\99\45\82\89\101\70\85\55\122\76\56\86\83\97\73\85\66\97\87\97\69\122\76\65\117\69\49\99\79\77\53\81\73\99\53\119\45\73\81\88\112\53\117\55\106\73\116\86\106\83\78\116\67\80\78\76\118\118\97\115\50\77\73\83\100\49\51\72\77\52\57\78\66\69\69\65\73\88\110\82\104\119\45\77\65\109\45\109\84\67\73\65\104\56\120\75\85\73\85\109\56","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\157\60\45\71\107\122\192\6\21\201\44\207\154\143\103\181\218\176\9\215\39\108\41\245\231\235\238\79\110\54\44\12\3\164\235\177\152\41\148\246\47\192\50\28\205\79\118\33\15\180\26\134\104\164\166\71\9\120\31\119\81\8\246\19\153\133\237\34\73\103\232\239\63\107\34\161\211\110\181\215\123\100\6\232\166\119\144\30\18\141\222\62\14\232\137\244\51\54\164\208\168\229\51\32\169\63\252\194\164\233\60\68\30\32\175\101\167\224\138\119\135\44\70\32\168\185\226\6\195\148\12\236\178\241\83\220\31\169\194\111\235\48\123\109\50\68\16\184\3\153\225\19\180\179\103\250\199\138\220\28\95\53\243\126\203\199\242\159\173\99\78\33\199\27\239\43\38\60\28\216\72\198\119\227\224\20\150\28\25\56\254\14\30\232\165\103\138\127\24\101\31\97\183\48\243\62\63\36\5\126\231\8\95\73\113\196\198\246\22\23\15\29\93\136\241\242\14\92\63\191\125\121\28\168\117\141\202\170\40\150\76\58\141\173\23\242\121\70\6\187\25\199\38\15\187\197\90\204\163\74\151\71\233\59\96\202\168\33\243\146\251\26\24\48\166\87\206\136\94\27\185\229\47\112\7\84\166\153\106\135\143\104\251\125\35\65\104\117\133\17\10\215\164\0\33\254\60",1287045652,4002832611} or {"\251\155\153\26\184\235\221\237\107\154\63\228\101\59\183\67\75\185\54\98\176\159\152\221\240\119\149\150\246\231\235\203\234\195\218\156\133\8\229\203\102\73\30\238\3\1\80\243\183\213\99\24\190\130\72\143\110\14\226\243\108\179\125\39\22\9\129\250\206\23\168\184\212\242\207\152\125\105\134\46\97\165\226\160\144\220\41\150\182\42\73\247\234\185\167\96\48\115\127\96\186\31\65\139\248\14\135\121\146\72\229\245\98\186\204\218\121\133\240\236\152\239\42\34\234\79\94\190\29\231\111\202\240\101\69\89\194\198\67\38\177\207\109\54\37\184\188\2\133\212\28\21\250\187\149\200\180\79\154\46\187\69\3\16\106\16\134\207\117\144\186\215\179\245\247\118\45\92\28\44\143\156\187\106\240\251\139\61\144\75\44\187\81\148\72\81\70\211\205\126\167\9\155\69\252\132\193\239\252\17\100\46\224\112\109\164\53\218\35\201\163\229\46\172\36\128\47\182\20\189\253\251\231\219\246\128\134\183\105\8\25\235\59\231\2\211\33\247\68\57\95\8\99\45\233\80\184\175\125\4\249\47\98\155\130\133\245\6\171\237\241\214\140\12\82\201\212\178\147\0\230\95\148\134\155\22\117\29\152\194\115\40\159\89\189\224\14\15\100\14\55\195\239\52\69",865091037,3677053682}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
