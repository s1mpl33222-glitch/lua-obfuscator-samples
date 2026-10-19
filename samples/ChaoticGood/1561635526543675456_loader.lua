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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=ea32b7c8343d40e5"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=ea32b7c8343d40e5"
local expected=617906
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
if s2*65536.0+s1~=2497301977 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\57\57\52\97\49\98\53\53\48\51\100\50\53\50\54\99\49\100\57\98\55\99\100\55\56\56\99\57\56\50\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\51\104\66\119\107\108\118\95\109\51\74\114\88\121\121\89\58\49\112\82\107\117\86\81\54\50\100\55\118\108\78\65\109\103\71\97\97\81\65\58\121\53\109\83\74\82\68\119\117\85\51\78\101\55\95\89\90\71\73\103\117\86\116\66\98\111\55\100\108\83\53\80\82\69\52\117\87\45\54\112\113\51\70\81\115\52\95\50\48\45\99\80\84\49\82\57\76\65\111\70\122\72\75\78\87\51\54\82\48\98\109\117\118\78\112\73\117\56\118\80\88\57\95\118\81\69\90\70\88\111\108\118\89\117\76\65\84\99\45\72\67\52\103\88\53\56\69\73\100\114\76\86\68\72\57\81\119\83\51\122\95\98\110\114\118\56\105\106\53\79\65\84\87\109\51\78\53\72\121\72\115\71\111\54\99\65\83\80\74\82\51\73\77\102\48\113\116\119\90\51\51\99\112\45\122\100\95\81\53\83\87\76\53\81\120\86\120\75\69\55\122\52\53\86\105\118\100\69\121\68\83\69\48\55\74\121\54\85\72\97","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\63\140\210\148\232\72\43\46\153\24\93\203\251\64\129\174\23\169\190\51\127\183\138\254\185\142\12\15\71\55\255\190\246\227\135\9\191\106\18\70\64\176\89\49\228\25\50\41\155\110\183\96\53\102\66\95\185\101\184\238\26\192\193\199\214\181\9\16\173\15\103\78\207\174\94\133\165\176\23\114\249\26\33\187\77\165\201\15\255\170\226\215\219\9\121\156\120\140\13\199\252\64\36\189\33\189\141\245\67\187\112\183\169\49\29\26\3\218\33\251\207\17\42\44\88\11\184\192\234\14\93\235\62\146\56\183\146\191\132\75\91\56\38\39\133\153\168\152\171\198\61\114\187\45\23\170\109\15\81\116\254\186\101\220\233\68\47\235\249\117\177\236\160\63\127\97\82\47\116\211\15\219\156\205\70\171\248\149\77\237\83\88\173\38\64\223\240\83\73\61\184\98\175\155\53\83\70\218\125\202\2\117\101\72\231\18\41\48\2\92\41\131\192\95\218\241\82\132\133\38\207\140\101\175\208\201\74\114\58\236\209\252\47\55\156\167\39\27\190\170\180\125\147\177\65\238\211\176\188\15\142\133\176\194\229\106\144\151\16\160\222\72\174\116\189\238\48\90\27\156\217\159\115\54\46\63\63\111\247\85\63\183\70\138\6\238\99\224\212\223\10\234\94\215\59\19\60",4004197351,3274137594} or {"\20\161\212\61\136\203\12\188\206\62\142\112\252\232\34\107\50\92\186\193\48\126\110\251\100\79\30\102\11\246\77\95\63\251\40\202\100\163\19\95\151\203\246\244\22\175\95\180\237\159\68\53\226\44\217\246\200\119\121\28\147\46\73\14\67\78\152\229\198\89\113\129\214\246\69\124\90\16\149\129\133\141\91\254\6\160\56\246\239\75\247\197\34\211\2\182\102\131\191\66\239\184\4\22\172\212\85\1\68\242\22\152\105\167\185\32\71\179\160\209\107\33\192\108\147\67\161\5\247\206\84\66\75\80\119\154\82\228\0\142\83\30\10\183\245\23\60\215\164\87\209\39\246\27\173\122\80\229\213\251\145\164\252\107\173\77\20\159\147\31\104\224\122\164\41\75\254\208\140\22\30\5\100\76\105\20\135\12\165\196\141\24\178\77\211\20\149\111\162\224\240\152\63\192\193\186\51\147\77\103\167\10\193\78\10\179\196\45\105\154\244\2\199\23\70\81\175\41\178\48\182\167\50\57\113\98\29\208\81\230\248\35\85\167\76\195\191\17\161\154\75\157\173\200\176\213\127\95\156\156\147\21\5\186\133\71\238\255\175\50\201\93\37\32\142\194\167\58\17\227\31\174\243\147\213\56\53\35\112\140\126\128\97\184\56\211\136\134\165\196\209\67\17\68\120",2937606064,2984665609}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
