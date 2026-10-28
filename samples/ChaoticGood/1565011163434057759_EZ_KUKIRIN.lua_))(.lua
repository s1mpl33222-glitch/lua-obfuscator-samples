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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=ce5c751b1cf7338a"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ce5c751b1cf7338a"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\56\100\56\53\48\55\101\101\101\52\98\57\99\101\50\98\97\57\49\101\100\98\48\53\101\57\101\102\54\48\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\76\118\120\76\52\120\121\108\70\120\98\71\86\120\73\117\58\111\73\81\103\121\79\83\87\89\111\87\122\98\95\97\103\76\83\50\121\51\103\58\86\109\56\89\88\109\98\119\98\119\115\52\82\81\53\114\81\74\88\114\105\101\55\105\69\108\106\115\74\48\84\69\115\106\51\101\88\99\70\111\50\51\115\80\112\52\67\83\119\117\50\119\106\99\55\104\112\85\77\105\97\67\50\71\122\55\86\57\74\80\99\90\113\79\54\54\70\48\100\57\73\115\89\121\55\95\78\112\100\113\57\88\65\100\114\76\111\116\53\98\75\95\87\88\98\66\75\65\112\78\104\104\67\115\83\55\90\105\88\89\97\56\98\99\90\105\68\65\81\50\87\78\76\112\87\104\79\95\112\48\105\54\51\117\102\107\71\51\86\70\117\72\120\117\115\68\78\72\67\98\57\48\114\45\108\48\99\108\56\68\107\115\80\87\101\119\78\67\67\52\115\104\78\105\53\77\67\50\57\119\50\72\99\57\57\110\57\90\54\114","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\3\80\195\229\43\33\150\165\64\194\237\120\55\145\213\201\208\10\24\216\227\208\182\25\255\221\1\47\38\19\184\205\142\117\4\14\170\3\124\208\218\39\211\227\52\7\27\121\105\235\67\233\153\82\217\110\128\47\248\21\128\116\151\137\64\225\10\85\162\27\211\150\152\89\34\255\43\44\13\41\145\143\244\193\239\210\152\209\87\48\237\221\27\216\178\155\121\94\184\0\87\40\73\9\158\5\76\130\185\75\149\127\233\243\68\186\255\73\35\241\247\102\231\29\133\62\130\151\68\221\2\150\226\141\198\3\87\167\113\254\205\162\166\136\150\90\59\5\127\244\123\76\8\231\8\72\228\182\44\128\163\6\235\95\21\75\160\141\57\111\178\60\227\182\40\227\64\17\176\216\116\77\88\177\153\169\96\51\238\153\50\74\194\178\221\42\225\94\28\146\87\7\117\2\133\15\29\169\50\59\46\153\181\55\249\26\45\117\159\34\214\239\154\77\50\127\9\139\246\64\61\87\9\142\82\181\37\124\100\168\115\226\53\164\130\14\134\210\141\229\143\198\24\153\133\223\231\8\111\178\43\51\198\231\155\113\198\170\99\19\116\74\226\206\9\202\218\249\94\211\59\59\217\196\1\112\137\39\48\124\33\152\79\151\92\200\245\68\236\243\9\132\128\226\19\231\127",499923266,2322555708} or {"\149\77\171\197\182\191\203\21\102\205\125\103\25\142\95\188\186\255\18\230\167\17\106\255\229\102\112\16\181\137\149\59\241\58\75\85\212\152\246\116\69\193\91\42\238\242\189\99\66\63\151\235\180\32\6\198\21\206\138\131\56\229\124\55\174\132\137\169\55\241\205\39\47\7\69\183\187\45\104\162\157\214\134\71\244\236\85\202\36\117\15\131\10\254\194\241\223\42\168\202\159\120\213\191\109\36\216\185\4\169\164\114\3\122\253\110\36\15\235\33\60\231\234\146\186\113\247\28\88\97\204\227\6\248\80\180\97\233\237\244\49\0\105\134\100\10\230\247\93\48\180\6\253\200\210\121\76\36\202\183\77\100\41\193\6\228\66\135\178\46\57\197\66\2\38\4\73\21\156\245\178\28\104\137\100\146\109\2\8\169\31\99\187\41\180\27\8\75\137\44\111\213\245\202\160\156\227\216\85\67\218\96\130\232\169\18\90\218\196\5\63\177\34\107\63\126\224\117\120\122\162\253\249\253\243\153\135\208\19\127\136\201\132\252\38\71\115\253\151\44\105\134\125\144\227\6\235\253\130\13\88\120\255\200\181\164\170\153\228\177\223\87\115\182\242\80\104\148\181\189\113\86\242\204\93\162\102\233\231\58\201\178\4\190\26\20\90\42\7\113\18\119\157\221\245",2643447158,1995466059}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
