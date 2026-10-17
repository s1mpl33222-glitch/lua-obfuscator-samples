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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=bee3994b32c99d2e"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bee3994b32c99d2e"
local expected=622786
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
if s2*65536.0+s1~=2050046860 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\48\100\57\50\56\57\51\56\56\51\102\49\53\50\97\52\48\54\53\100\97\53\49\57\101\101\102\52\52\49\52","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\106\86\68\114\85\54\48\65\99\117\69\101\65\90\67\67\58\106\65\115\120\95\53\100\78\52\100\68\50\100\57\90\74\117\76\52\119\97\119\58\83\83\105\116\86\66\114\114\116\49\66\98\65\101\87\45\90\121\109\66\54\108\101\45\119\95\80\55\78\97\56\111\111\82\99\110\68\82\106\75\52\119\121\45\97\89\55\115\106\77\55\76\70\68\103\114\66\95\76\101\105\68\110\90\56\81\103\108\48\89\114\95\80\88\73\77\114\55\111\121\119\73\66\82\69\122\105\55\98\50\95\72\55\68\117\111\67\87\112\51\100\66\104\82\121\100\51\57\50\80\81\108\122\50\97\71\97\78\106\85\100\49\120\50\77\81\107\88\87\119\83\57\77\83\81\113\65\119\113\121\122\107\65\86\107\70\72\89\111\74\97\53\78\84\111\119\112\110\111\113\98\84\79\75\103\117\79\56\116\79\117\76\82\53\106\85\121\65\80\100\50\98\112\65\68\73\78\73\89\119\117\88\100\79\118\45\55\88\102\77","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\160\30\27\20\114\181\243\83\12\100\12\65\63\84\19\31\75\251\209\205\136\133\44\125\112\58\209\225\24\26\91\25\224\72\29\40\204\88\191\253\201\188\31\27\209\153\86\153\128\128\52\147\119\192\83\243\236\110\197\229\43\129\40\245\195\206\57\48\19\90\42\254\38\193\16\197\113\98\239\39\225\234\228\159\46\37\35\233\172\67\254\241\30\40\228\10\31\144\185\249\100\65\31\254\166\198\177\113\183\135\247\216\162\244\70\190\42\196\106\250\47\148\44\128\145\32\102\42\101\203\169\71\105\22\2\253\173\152\0\134\13\102\231\74\43\178\142\197\56\130\248\88\99\70\19\67\194\42\44\134\7\55\219\242\107\19\142\5\159\189\237\38\215\250\203\188\6\233\198\145\163\71\113\134\219\213\204\49\235\234\97\92\28\160\99\84\228\168\13\172\40\97\118\116\152\37\69\138\59\203\7\174\177\23\82\35\56\147\196\85\10\85\21\77\49\174\220\156\221\180\155\160\219\100\24\113\191\225\97\175\104\224\68\207\66\189\40\110\194\5\26\216\223\198\163\235\218\194\168\224\149\130\11\2\228\24\179\49\89\216\161\85\153\209\168\177\149\174\50\168\183\46\203\179\4\104\162\81\235\151\55\153\17\217\99\34\96\55\103\248\174\104\60\63\168\56\184",4258015388,3077202436} or {"\240\23\99\73\154\177\175\126\7\32\255\192\228\151\243\213\95\102\195\68\65\207\39\135\168\95\81\36\90\6\173\85\7\82\157\207\139\177\115\252\48\239\237\40\76\152\88\175\208\141\25\125\145\215\141\121\80\124\124\102\173\14\172\197\160\234\10\28\166\216\225\19\203\9\180\19\222\250\213\46\167\126\154\36\113\22\152\26\2\92\236\207\101\214\17\202\34\159\180\147\253\0\36\132\55\46\143\136\237\47\101\252\176\169\118\5\243\253\112\2\253\126\222\240\39\193\82\60\52\249\71\76\83\58\133\114\84\200\151\161\49\127\233\182\69\171\72\108\174\241\177\216\121\166\178\47\143\29\87\201\233\64\46\22\132\204\254\139\241\245\116\52\4\120\10\47\165\63\173\144\221\78\3\39\166\47\108\133\224\171\169\251\58\179\39\53\47\5\74\253\98\220\12\177\3\60\164\47\126\192\236\26\59\88\145\254\90\52\234\49\36\166\105\79\24\5\82\188\139\189\31\175\6\149\167\84\138\131\18\152\95\71\178\234\37\220\42\34\196\18\121\9\16\243\210\79\222\57\5\83\225\247\86\112\152\110\248\220\83\0\1\209\147\175\207\39\155\233\199\3\67\189\74\110\57\59\48\86\17\249\183\220\52\254\43\85\32\58\214\86\171\244\97\242\175",1202550055,2800182291}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
