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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=cc7fde2b929923f0"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=cc7fde2b929923f0"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\57\102\52\102\52\98\57\50\52\97\102\102\52\54\55\54\53\50\56\49\52\52\53\54\50\56\54\98\98\48\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\120\82\66\51\110\103\67\117\110\83\98\48\77\118\120\113\58\82\55\66\79\103\80\52\70\85\68\83\86\53\118\66\111\52\112\55\53\86\81\58\88\49\106\52\83\78\103\69\80\70\57\70\66\108\55\120\90\71\45\52\103\72\48\99\72\67\69\54\50\120\90\68\72\68\100\84\70\102\112\97\85\112\72\80\89\54\87\45\95\75\101\116\66\80\88\86\76\65\56\107\90\72\86\48\50\53\48\102\66\85\116\53\120\79\86\112\106\66\83\45\84\70\73\50\57\108\116\98\90\50\69\100\55\95\119\89\81\103\112\68\70\108\111\105\57\87\102\118\119\120\104\98\101\110\97\70\97\55\52\68\83\110\77\81\119\80\48\110\48\85\95\122\51\85\112\116\79\50\116\113\107\81\53\112\88\119\66\85\108\122\100\78\98\55\69\99\52\112\49\77\81\76\89\112\45\81\83\80\68\69\99\79\66\97\122\102\115\72\51\86\50\101\79\76\50\99\77\119\56\89\53\71\49\85\50\106\122\51\74\120","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\105\43\87\8\165\230\195\139\171\165\129\124\55\52\203\60\201\143\179\232\158\5\219\247\26\20\105\125\254\22\197\19\128\254\170\102\5\91\133\48\15\135\205\152\8\241\135\121\193\241\94\208\120\70\239\7\134\145\255\32\23\149\170\195\20\219\120\62\22\166\127\77\113\200\56\187\255\28\17\47\200\61\170\42\112\115\196\188\17\21\14\21\136\245\45\16\59\6\59\245\138\46\122\147\17\157\237\207\156\51\115\239\120\237\84\157\50\195\214\123\135\95\197\229\227\39\122\50\228\121\156\228\127\229\92\180\159\11\225\237\244\122\19\37\53\34\29\117\26\44\157\10\201\29\9\184\139\229\16\62\227\157\90\64\213\63\249\142\237\83\236\42\176\134\82\188\207\159\254\107\96\19\34\126\168\219\247\88\68\186\114\227\219\61\157\48\117\172\71\110\204\222\9\3\45\18\11\136\196\63\4\81\109\82\51\159\98\106\164\159\99\215\3\43\208\92\73\94\159\152\52\188\244\10\168\159\76\106\153\94\249\226\241\99\157\245\107\140\183\185\207\201\78\31\252\185\89\93\137\110\138\119\255\128\158\1\232\203\68\83\187\191\106\183\19\106\7\56\99\156\50\72\233\147\55\169\212\10\35\150\229\25\212\94\184\187\210\81\41\169\149\41\253\82\83\104\212",3916859427,419913325} or {"\210\117\209\77\134\176\127\91\207\250\211\217\196\123\77\224\207\130\37\45\53\140\116\240\227\238\36\0\62\162\177\251\254\38\169\103\72\166\0\124\246\92\202\186\90\80\192\165\39\83\201\52\100\61\140\191\92\180\161\212\122\195\199\249\5\80\215\205\187\156\173\72\5\185\48\112\95\144\119\0\121\18\0\153\166\73\224\198\65\113\8\115\152\156\17\219\47\198\174\187\168\144\215\237\46\9\9\59\226\140\4\136\182\153\94\75\185\67\39\216\140\216\4\26\233\231\249\22\38\166\142\118\247\144\211\95\220\109\118\77\83\187\18\207\191\101\254\19\35\13\70\213\236\62\219\133\5\223\91\133\148\118\93\131\182\79\46\245\227\242\248\83\120\55\190\74\121\76\174\229\106\168\72\94\29\170\97\177\60\72\102\193\109\252\138\26\88\237\221\58\12\217\163\43\193\210\20\170\201\30\161\71\21\242\32\132\55\120\51\67\27\223\200\209\234\112\44\201\147\109\175\254\81\81\131\87\218\116\239\173\182\115\83\162\66\204\39\12\144\144\214\116\80\249\250\35\6\19\177\102\71\191\224\17\116\210\199\40\234\129\170\100\144\117\247\169\108\213\154\95\136\84\179\98\53\112\105\71\38\40\252\112\140\60\150\21\198\123\105\194\73\62\53\99\39",37589443,142368892}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
