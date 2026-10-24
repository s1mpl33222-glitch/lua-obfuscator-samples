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
local fresh=url.."?retry=50572c75b6e68cb0"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=50572c75b6e68cb0"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\80\56\107\81\85\103\73\57\86\114\56\86\57\120\67\54\58\102\57\76\109\51\65\119\119\67\80\98\102\86\102\45\73\118\120\56\121\115\119\58\121\117\90\111\72\105\103\110\90\52\112\68\108\98\99\71\48\100\54\74\73\45\114\52\75\56\103\118\66\121\45\84\71\87\106\56\68\88\121\73\48\48\108\83\113\114\101\113\53\66\82\108\83\107\88\48\52\95\86\57\78\88\45\69\70\65\114\86\98\53\78\121\69\100\70\56\51\52\78\88\101\78\56\89\88\103\53\106\53\108\72\56\55\122\55\50\108\48\115\112\50\79\81\120\57\85\71\98\68\121\88\116\55\119\89\120\95\101\113\49\113\119\86\80\118\109\80\110\86\118\114\105\113\73\108\106\73\77\81\115\79\79\122\74\77\102\101\48\76\69\51\88\97\117\45\97\103\95\90\49\95\72\88\80\84\65\90\106\105\72\106\45\78\65\89\95\56\74\86\112\89\55\51\121\109\114\72\55\118\80\81\99\45\69\51\51\55\113\111\95","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\9\123\169\243\42\232\115\247\251\17\46\148\57\175\213\195\172\18\188\110\138\203\195\19\194\192\244\80\247\28\200\33\154\250\191\72\6\0\71\211\16\30\150\154\12\236\123\190\53\202\178\172\108\46\166\180\243\119\162\65\183\109\201\31\189\160\20\129\168\118\124\82\209\177\178\91\247\174\129\231\143\17\56\207\97\4\59\0\193\255\174\157\73\223\156\240\210\231\200\107\107\194\102\32\82\136\248\47\18\38\3\247\222\173\255\254\193\125\27\195\152\53\120\4\119\203\28\233\220\242\119\88\255\213\0\54\189\26\5\174\221\14\97\65\181\33\3\161\20\119\245\215\61\111\4\127\149\10\12\242\59\87\69\248\40\209\35\163\39\108\41\178\99\87\69\154\243\103\162\11\154\105\83\132\61\142\151\80\210\191\38\179\234\170\56\108\253\66\173\210\194\117\165\66\29\14\195\156\185\99\63\181\104\247\67\8\75\38\246\98\174\143\130\250\86\163\93\224\86\211\28\203\159\167\202\232\19\252\29\76\52\19\111\123\168\174\40\85\162\7\115\103\137\251\181\180\214\206\19\174\103\93\246\225\248\133\108\160\73\34\184\152\124\28\122\171\151\211\95\101\195\135\226\29\25\33\127\146\58\34\236\151\41\138\228\235\98\72\88\197\218\194\179\144\195\92\217",2712770045,3973079240} or {"\113\19\221\125\116\194\148\178\194\251\90\189\223\193\77\189\58\176\148\191\128\166\132\195\194\188\173\136\201\108\138\207\53\146\206\176\63\242\114\135\55\255\227\115\53\232\130\177\93\147\140\235\201\145\235\71\179\175\76\177\93\167\156\47\22\221\120\11\98\140\33\235\69\244\194\165\104\88\103\116\170\52\23\173\209\34\62\139\242\66\69\146\99\181\50\74\244\71\196\107\7\90\80\31\179\160\37\36\231\94\169\100\49\243\145\178\149\226\72\85\138\10\219\78\215\204\18\98\69\51\10\167\13\152\136\5\77\35\34\175\255\75\140\3\2\211\145\34\52\210\145\134\62\176\146\21\160\66\242\112\178\232\147\252\190\182\110\144\164\134\208\136\250\104\168\239\32\16\205\68\170\88\187\22\212\8\247\182\240\26\100\166\37\224\155\208\210\183\54\66\125\175\238\174\97\111\149\73\131\24\175\191\81\187\92\95\155\145\198\128\224\231\117\65\220\7\222\198\175\224\194\224\22\199\59\71\22\162\21\145\20\252\252\70\16\173\138\255\153\50\123\154\86\90\38\108\184\139\140\69\168\29\56\72\13\37\115\117\190\3\79\177\90\190\113\141\157\153\76\137\165\110\232\167\214\184\228\250\15\193\32\26\234\171\122\167\25\104\169\166\65\79\75\156\130",744517681,3672466135}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
