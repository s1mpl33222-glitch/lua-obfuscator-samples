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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=89fef43eb78a1c9e"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=89fef43eb78a1c9e"
local expected=898586
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
if s2*65536.0+s1~=1933677448 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\104\54\78\113\104\117\87\67\70\99\49\102\99\52\106\101\58\118\70\118\81\118\118\73\52\65\80\122\55\72\66\45\73\88\67\113\90\109\65\58\76\79\49\52\111\72\53\78\112\100\115\82\67\69\87\80\102\98\55\104\84\57\74\103\89\80\67\119\84\97\104\49\112\83\108\77\109\95\53\52\113\108\81\105\122\72\95\112\89\78\102\102\82\116\72\102\81\106\70\53\113\98\86\83\106\76\70\112\114\70\87\99\69\56\120\100\82\104\78\67\54\57\85\65\80\97\74\48\99\57\106\65\81\118\109\68\69\48\55\73\95\118\114\49\87\66\66\66\122\99\83\98\98\118\81\74\78\80\120\52\86\121\98\85\66\48\120\104\70\119\80\111\81\73\51\121\87\75\104\104\45\73\120\52\108\109\53\81\81\48\65\107\108\81\54\97\54\97\56\98\117\122\72\75\100\54\75\53\76\82\122\67\115\67\104\118\53\121\116\119\109\78\95\86\81\97\117\106\114\66\117\99\110\65\110\106\98\117\109\88","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\205\153\206\248\151\249\125\112\116\116\35\38\173\146\72\110\170\58\138\254\229\54\2\84\42\165\96\60\147\110\154\184\72\192\76\93\128\10\208\21\35\170\109\155\172\5\19\254\91\212\119\16\211\12\255\25\41\8\18\134\55\173\135\216\202\98\118\208\56\210\201\7\58\144\74\154\42\178\242\171\212\10\141\55\15\158\253\107\154\74\165\99\30\104\200\13\243\147\111\11\128\110\184\49\135\30\182\13\87\156\212\171\179\62\98\48\243\79\90\126\79\10\32\129\230\37\132\239\252\140\160\239\155\10\52\25\9\5\119\132\138\121\88\216\147\189\204\13\170\86\38\244\117\48\238\56\7\176\181\206\242\246\5\30\226\89\248\73\89\118\70\119\52\92\58\100\224\163\210\155\107\241\66\53\135\253\44\204\16\219\107\214\23\250\98\69\69\221\150\154\51\122\132\94\1\62\164\69\230\22\162\99\125\207\66\61\254\180\219\220\107\148\166\178\96\92\13\201\219\172\33\253\131\15\0\160\158\243\108\98\192\219\229\144\111\237\16\134\100\145\122\184\251\217\227\110\33\138\211\70\241\167\155\150\227\52\163\30\171\249\202\73\203\49\203\110\3\6\39\187\139\111\42\118\246\39\211\123\142\176\35\107\114\66\89\217\83\205\159\219\195\189\216\127\221\13\132",730748082,1480090288} or {"\217\236\181\74\147\245\5\197\244\223\82\59\247\122\17\47\209\91\6\37\17\48\120\110\163\250\128\251\96\166\234\52\83\148\217\200\216\27\138\77\152\19\106\112\32\94\41\198\167\175\127\22\68\44\26\129\79\188\68\148\122\30\145\154\238\180\247\155\241\80\157\218\144\8\177\219\134\42\125\241\110\67\226\183\192\45\51\252\226\19\58\64\27\16\135\160\91\176\38\123\48\190\89\49\28\206\144\85\210\63\80\25\16\187\29\132\250\166\73\165\6\158\21\30\217\37\70\145\155\178\189\72\130\180\208\190\92\226\198\124\171\0\247\160\34\90\4\246\89\58\151\237\73\138\151\246\50\7\196\25\16\26\125\94\48\224\193\147\75\118\242\209\126\104\14\105\72\26\46\238\36\243\206\206\198\11\127\96\162\51\207\116\177\129\132\107\95\17\79\182\163\41\174\85\19\237\159\100\17\170\58\14\178\168\234\101\49\29\78\93\56\119\44\163\244\88\77\30\18\158\73\0\36\34\73\84\251\5\112\32\213\21\68\197\36\163\152\148\138\11\47\108\97\54\236\103\190\42\145\182\132\144\115\21\67\207\104\31\75\140\13\229\144\66\213\91\104\171\52\92\122\46\223\254\178\118\17\11\229\1\237\122\95\64\2\68\221\104\159\199\234\247\187\6\78",3768051130,1177773247}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
