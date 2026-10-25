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
local fresh=url.."?retry=7b138999a5364ad8"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=7b138999a5364ad8"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\117\68\87\102\117\120\66\55\80\114\65\76\110\109\117\89\58\100\69\65\108\110\76\77\71\80\88\80\70\107\117\101\65\106\52\115\108\54\103\58\69\68\109\110\122\71\72\67\78\98\84\72\80\103\57\65\50\115\78\95\102\119\90\98\118\104\85\107\76\69\71\87\104\116\99\49\106\65\56\66\101\119\72\109\55\95\87\51\120\52\67\55\100\95\53\52\75\82\108\72\103\84\101\80\80\83\68\85\118\104\121\87\112\103\86\82\97\66\82\69\114\82\78\81\119\86\119\70\86\109\53\90\110\54\105\111\83\120\121\72\82\57\52\79\108\75\101\86\107\102\54\109\111\67\95\76\49\95\66\71\117\108\120\48\48\55\81\122\109\104\115\110\72\108\116\68\103\116\84\85\86\105\105\97\55\71\108\48\102\56\56\118\122\50\97\68\75\83\115\117\82\75\80\90\66\66\72\105\105\95\56\72\88\113\65\70\74\89\90\51\116\90\116\67\54\85\118\119\45\97\67\115\52\68\115\107\71\95\102\56","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\189\226\231\70\136\238\109\84\111\90\48\133\176\178\11\29\193\88\189\188\113\200\94\47\20\177\26\23\97\58\127\190\79\142\208\250\46\0\157\89\222\144\23\225\213\216\60\41\21\101\79\57\207\212\123\156\116\183\114\66\137\43\73\45\45\208\43\56\105\34\58\97\118\218\6\96\238\251\94\98\19\213\229\228\39\32\126\160\91\227\143\18\244\134\133\125\14\187\159\244\162\85\88\79\59\142\240\10\13\120\86\1\111\117\32\3\255\234\3\69\113\152\231\117\138\61\125\186\163\104\255\86\6\220\18\8\217\252\124\32\106\75\140\221\21\157\108\153\17\236\228\47\138\135\50\155\105\234\157\125\246\18\35\195\221\31\165\200\135\54\114\228\177\141\106\45\146\251\247\92\135\92\218\19\182\114\30\253\40\104\95\44\193\146\114\169\161\116\150\10\10\193\201\96\229\242\91\170\157\217\60\210\96\71\23\185\250\177\4\158\240\53\128\32\110\188\17\39\234\109\193\40\160\177\40\67\68\1\135\229\186\100\189\168\211\83\54\28\236\237\40\192\59\220\97\57\218\2\25\1\141\186\97\80\226\43\10\38\65\188\1\255\55\179\27\224\25\245\149\86\20\233\11\106\30\208\232\197\168\79\182\171\81\30\192\88\171\196\186\77\181\250\165\166\10\46\245",3000837222,892822263} or {"\124\46\48\26\112\64\216\77\135\165\212\121\92\18\160\37\137\109\42\242\119\170\168\114\9\180\213\93\239\51\145\105\223\132\239\197\152\205\88\47\4\108\25\202\227\152\83\252\165\127\185\155\13\91\197\61\218\218\215\116\136\125\58\229\33\56\194\237\191\156\185\179\53\253\10\247\68\108\51\209\12\133\175\119\208\215\73\2\170\209\253\252\88\31\178\151\132\128\195\251\138\123\71\45\126\175\228\69\93\115\51\143\213\232\208\1\201\149\40\188\221\39\255\135\235\171\55\192\174\224\70\69\90\28\205\96\34\146\244\154\125\170\182\126\157\75\20\191\227\250\142\177\217\137\47\181\4\167\166\86\194\229\130\25\76\119\133\132\39\103\124\107\91\71\153\219\45\86\17\78\193\141\118\14\192\104\201\28\156\72\229\18\50\203\182\187\53\71\62\128\134\225\220\50\21\52\44\160\67\135\42\162\167\153\225\233\65\10\136\95\156\153\132\36\70\31\110\228\216\171\168\245\227\177\139\72\21\106\188\80\144\141\134\159\188\150\18\253\154\90\194\168\73\181\213\64\58\204\161\127\237\229\249\52\191\49\218\243\238\145\74\183\2\134\156\226\144\211\208\97\61\28\20\136\229\180\92\246\148\41\35\58\162\203\65\242\0\191\9\185\132\209\201\136\54",751352158,591029510}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
