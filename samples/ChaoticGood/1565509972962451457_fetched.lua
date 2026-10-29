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
local fresh=url.."?retry=4e35e6a31a6895a5"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4e35e6a31a6895a5"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\48\100\55\51\98\57\97\50\53\54\53\56\51\56\56\48\98\52\49\54\98\52\54\50\99\53\52\56\54\49\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\108\85\56\49\105\69\107\120\121\95\67\70\55\67\89\112\58\57\89\95\52\119\119\50\56\48\71\53\68\102\79\102\99\50\56\84\109\66\103\58\117\71\97\70\85\70\109\75\95\54\121\118\95\81\66\81\81\112\106\78\45\111\75\49\53\78\45\70\76\77\118\74\117\104\45\102\111\52\103\87\116\95\122\120\120\116\114\112\113\81\100\112\121\72\101\116\66\67\86\68\56\73\82\109\113\107\57\105\75\45\106\67\55\118\108\53\109\87\107\110\68\103\118\77\72\83\69\72\48\105\73\84\107\75\90\104\50\53\57\66\74\106\73\118\52\87\77\97\73\81\68\82\100\81\68\112\72\83\55\106\86\49\97\105\51\55\108\121\90\48\110\55\57\104\54\105\103\101\57\104\52\90\106\57\100\71\107\108\122\95\48\56\67\89\73\103\105\111\57\98\86\99\113\56\89\56\120\50\70\101\110\114\78\119\110\98\55\75\112\106\116\83\56\99\67\108\81\80\109\79\115\68\103\112\49\71\102\101\45\70","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\48\87\26\113\163\167\219\198\114\248\120\249\235\50\246\7\129\238\118\230\157\202\222\57\50\189\245\110\223\198\234\158\171\67\155\20\227\34\45\220\200\145\188\56\186\205\136\59\183\18\151\150\199\197\55\15\100\163\223\191\28\145\91\60\200\165\23\216\182\211\126\211\42\214\58\159\28\200\16\27\36\194\125\15\199\127\183\135\230\33\89\238\113\55\36\33\43\99\136\173\154\95\101\206\97\68\126\195\247\91\72\70\40\216\243\193\6\40\36\197\52\105\152\157\182\157\48\245\223\232\166\169\105\19\100\53\2\75\235\131\118\243\51\254\52\217\139\62\77\170\113\130\61\226\21\161\205\99\41\97\201\210\159\231\119\220\189\182\160\230\85\133\188\116\47\81\178\219\92\13\232\182\25\36\101\127\64\194\105\99\37\173\19\140\139\75\148\184\227\65\151\75\195\5\158\45\28\9\61\57\190\83\235\4\209\233\109\253\31\153\223\243\187\254\130\129\231\246\0\250\86\24\229\40\222\192\7\73\176\8\122\116\25\96\23\242\202\202\102\187\175\73\35\120\187\112\207\69\79\123\229\157\79\44\57\229\186\129\127\245\228\77\214\199\139\165\238\228\22\86\207\154\81\105\158\152\195\36\27\21\90\120\108\229\72\88\162\91\71\207\70\28\2\102\121\15\222",2893221553,68116590} or {"\83\254\229\23\55\229\44\108\126\202\244\15\150\1\63\251\91\255\230\111\128\237\209\15\61\47\84\126\108\147\127\174\10\198\223\176\80\206\123\40\224\52\173\19\21\30\45\1\44\168\62\106\87\21\184\55\113\106\58\27\88\251\187\65\182\191\22\193\70\14\43\232\36\2\236\24\89\105\78\195\124\143\6\2\162\92\165\186\7\109\231\222\226\71\89\116\44\53\30\144\189\82\223\245\14\246\138\106\91\248\12\231\192\78\200\55\92\165\90\8\247\137\137\249\187\169\59\156\212\86\24\195\186\144\201\210\167\33\127\43\148\178\134\163\119\248\252\193\210\217\113\91\171\237\69\82\25\26\27\242\168\96\206\205\160\62\188\163\38\203\88\131\226\192\105\232\232\204\187\32\13\16\199\253\243\181\185\98\59\47\70\185\34\173\74\11\158\83\194\182\176\2\97\253\202\66\251\5\91\11\49\119\52\100\45\158\2\255\214\19\74\1\226\169\127\74\248\76\227\219\195\213\145\216\179\149\75\245\118\152\22\252\15\176\216\252\75\158\195\47\105\212\151\83\196\203\235\62\115\12\221\39\229\49\226\198\170\165\144\173\138\45\145\62\215\246\118\6\151\1\45\214\140\73\32\96\130\190\83\143\146\106\148\63\75\158\192\65\28\134\84\204\93\71\44",3985311226,4092813949}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
