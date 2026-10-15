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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=4588e88d74e5691c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4588e88d74e5691c"
local expected=572639
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
if s2*65536.0+s1~=2292470616 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\98\98\48\57\102\51\51\102\98\99\56\102\98\55\102\99\49\52\102\56\51\52\56\102\97\50\54\52\56\52","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\114\82\65\118\50\105\74\90\57\100\121\50\56\104\77\48\58\50\48\106\54\48\65\88\70\117\103\84\114\106\110\50\67\115\71\67\78\56\65\58\54\52\122\111\114\53\102\73\89\45\67\90\49\102\52\53\95\115\48\116\78\86\85\81\121\79\119\81\78\122\105\87\102\68\65\81\116\111\65\79\105\112\88\88\111\120\84\76\55\65\77\81\83\74\84\107\105\111\48\84\98\48\53\74\67\82\102\117\98\72\72\74\107\71\77\117\70\89\89\109\79\74\101\66\102\103\54\117\69\89\121\119\88\56\86\102\72\101\119\53\69\77\80\68\111\48\122\74\106\81\87\56\88\121\114\100\86\53\113\57\83\112\54\113\79\116\97\100\81\73\86\76\86\55\72\101\70\74\102\105\118\119\48\83\52\104\82\103\90\105\121\69\102\52\99\82\56\120\115\81\121\116\50\108\105\83\77\112\69\48\97\52\110\114\111\71\108\120\118\79\48\50\80\72\117\68\45\116\54\48\119\100\84\79\77\109\68\71\78\109","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\11\75\87\240\247\165\73\29\109\79\57\199\22\149\108\214\24\94\173\127\1\183\67\68\23\248\90\31\136\229\228\129\180\230\19\147\185\162\182\98\174\213\214\190\177\103\121\113\198\61\142\243\15\126\70\150\147\27\86\119\226\139\126\122\145\152\216\84\75\222\7\215\75\14\102\81\210\178\95\238\58\27\2\124\107\131\222\164\147\74\63\89\248\220\62\0\203\179\20\156\212\43\250\104\66\244\139\178\164\147\8\71\47\157\48\76\109\28\6\6\20\28\76\15\219\51\94\105\33\31\9\7\178\229\22\67\93\125\69\217\232\113\214\163\15\170\114\236\135\149\119\203\5\159\124\122\101\130\243\178\87\27\20\181\248\229\61\50\173\38\238\174\173\251\90\14\33\67\178\215\142\55\74\180\200\197\222\37\49\212\15\146\191\64\218\105\9\104\24\22\195\236\3\227\103\192\50\67\138\155\165\118\9\94\122\2\27\89\33\184\200\197\112\53\23\56\150\226\50\174\210\105\234\245\10\76\220\42\10\170\52\212\171\199\212\164\14\92\235\150\157\117\196\148\210\75\73\243\102\9\158\6\91\221\50\51\8\224\170\104\3\244\60\142\133\14\105\45\14\218\57\127\35\13\86\58\190\112\193\5\196\98\202\29\193\224\47\54\240\3\118\178\240\208\195\126\222",1971427455,4197409171} or {"\127\253\71\132\165\241\252\110\112\243\193\81\100\64\188\249\159\145\0\183\175\117\60\112\244\219\91\61\113\213\143\167\240\5\47\143\232\92\229\228\46\189\7\171\85\8\14\171\127\61\120\132\41\15\252\235\65\12\208\143\110\185\171\63\137\124\68\81\121\232\227\0\138\209\24\216\129\161\176\35\135\240\12\57\114\172\200\242\112\144\49\98\74\140\252\122\42\239\169\25\177\13\225\230\196\34\111\225\241\237\130\16\203\132\27\197\171\91\168\79\140\104\192\102\50\154\13\202\179\56\7\223\134\222\192\90\54\220\149\198\197\156\28\255\22\28\108\9\236\244\150\42\246\220\85\14\144\123\86\116\83\161\3\218\173\54\247\5\232\61\76\50\213\23\78\108\201\128\226\106\4\164\93\146\21\227\243\3\206\120\169\8\44\17\208\39\158\170\40\241\7\135\15\151\238\141\135\13\7\77\116\109\160\228\127\198\59\214\13\203\39\143\201\6\61\205\213\194\213\44\87\238\139\190\82\145\88\233\160\210\5\71\177\3\176\90\249\244\6\232\141\227\237\16\112\140\234\115\2\124\35\145\57\214\42\235\126\151\231\102\127\31\74\143\182\54\207\131\184\107\67\170\155\251\116\2\8\142\71\170\211\187\48\85\22\87\150\79\138\30\229\195\146\104\70",2523281046,3889193890}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
