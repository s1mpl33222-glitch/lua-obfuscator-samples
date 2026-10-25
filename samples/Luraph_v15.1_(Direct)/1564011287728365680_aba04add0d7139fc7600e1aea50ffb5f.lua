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
local fresh=url.."?retry=64c9098716a4d68e"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=64c9098716a4d68e"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\98\97\48\52\97\100\100\48\100\55\49\51\57\102\99\55\54\48\48\101\49\97\101\97\53\48\102\102\98\53\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\118\66\52\50\107\81\83\52\105\57\51\87\50\109\88\66\58\111\51\76\109\70\80\95\104\101\89\70\100\97\79\83\114\78\104\97\82\105\119\58\49\78\118\54\112\68\113\100\97\48\108\73\100\86\86\120\68\49\95\99\106\101\48\72\52\69\111\71\87\111\88\87\72\66\49\119\49\52\51\120\102\101\90\70\107\99\110\73\78\76\84\121\102\55\84\119\86\81\45\87\107\54\101\119\79\72\55\77\106\108\120\115\55\116\98\54\73\51\52\74\74\116\95\80\102\65\101\108\103\68\66\113\104\100\71\68\54\88\78\95\81\81\88\51\84\75\57\73\117\78\75\49\51\106\53\102\116\116\52\51\113\95\75\69\119\50\76\110\75\118\84\75\77\52\52\50\80\102\80\99\110\107\105\112\50\116\88\119\79\52\113\89\90\74\95\88\75\105\106\102\119\90\112\98\56\102\84\87\81\78\109\120\76\78\70\49\109\45\71\72\108\104\115\67\54\105\121\120\76\109\86\48\69\57\102\119\79\119\52\120","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\31\204\145\96\205\228\167\108\170\131\1\160\227\96\202\158\126\145\226\109\204\108\229\110\125\139\215\78\171\208\95\30\226\180\4\17\80\190\67\16\100\38\189\64\72\100\127\113\49\11\81\67\74\253\112\103\91\97\51\90\154\135\94\141\14\182\217\248\67\170\130\63\8\30\24\175\8\79\19\131\205\181\58\243\176\172\37\22\212\186\200\249\158\227\126\15\13\58\249\213\91\159\20\169\38\101\132\198\110\32\232\79\174\237\205\69\235\133\189\127\42\40\25\100\31\222\7\17\172\158\213\53\49\194\71\96\29\49\181\158\154\92\70\241\160\34\5\189\67\76\38\98\10\3\105\239\127\211\8\155\225\141\73\186\119\215\243\101\85\149\71\13\126\206\199\216\174\193\83\64\228\103\171\152\21\192\118\225\75\135\88\205\128\173\166\43\103\53\80\191\252\170\252\16\174\169\87\188\67\149\121\208\77\203\40\246\60\22\39\192\171\32\119\200\107\55\10\197\210\75\194\205\225\215\229\139\121\236\63\56\180\72\225\17\155\135\75\108\81\80\243\105\130\159\253\127\242\38\206\239\152\253\86\27\72\12\255\193\101\176\91\140\72\3\239\16\110\140\222\180\65\64\66\16\245\254\139\134\36\233\228\165\173\17\195\106\21\103\250\245\23\188\255\73\210\109\198",3484354315,3386532387} or {"\232\149\176\85\62\115\203\33\248\152\117\253\160\240\207\208\225\45\108\225\79\49\238\73\19\60\97\129\88\132\83\63\73\210\119\210\239\61\123\87\202\102\70\2\21\220\112\207\150\92\104\51\211\46\154\86\119\46\17\74\209\17\72\13\36\199\44\165\230\68\23\127\245\85\77\40\250\111\66\62\225\105\165\66\164\205\106\11\11\62\150\16\110\93\122\79\222\129\68\154\242\86\79\185\13\30\169\244\23\126\79\212\58\94\20\210\103\224\118\199\73\160\166\97\225\207\82\211\109\5\62\162\71\185\138\156\143\255\93\7\58\166\230\19\95\36\88\223\76\122\78\127\27\15\66\252\71\58\227\19\19\53\3\16\89\207\1\166\134\182\191\147\66\5\232\245\13\187\215\6\89\28\85\218\145\155\230\131\95\195\128\198\190\88\103\207\247\247\65\237\0\241\171\80\194\67\30\250\16\71\25\77\44\201\89\155\62\161\88\37\247\117\162\98\2\126\124\204\226\192\158\82\145\199\79\189\165\32\146\207\175\222\48\86\231\204\22\223\203\193\180\22\129\122\96\99\237\31\135\52\218\114\134\107\196\66\123\145\116\236\116\2\90\253\34\17\239\69\58\230\66\242\194\81\187\163\154\26\75\242\112\200\46\186\233\21\162\174\52\99\101\56\99\23\201",3384613848,3057345586}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
