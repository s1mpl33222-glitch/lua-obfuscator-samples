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
local pinned=url.."?retry=6ab0add7da9a0799"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6ab0add7da9a0799"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\51\102\101\98\49\100\57\98\51\52\97\56\50\52\52\49\53\50\101\50\99\55\53\98\101\101\53\97\50\55\57","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\54\122\80\45\107\99\66\48\111\73\83\79\67\89\97\113\58\81\114\102\122\70\55\105\87\55\70\73\70\50\86\65\105\119\57\104\65\95\65\58\68\102\81\89\53\121\99\116\103\110\57\66\85\102\120\52\116\87\111\55\81\97\84\82\72\51\105\66\121\75\53\116\56\97\80\121\86\73\56\86\106\80\68\106\114\111\106\52\114\76\89\100\48\122\89\65\108\104\109\115\73\54\98\45\69\74\75\82\68\122\108\77\45\110\45\79\97\121\65\54\82\55\113\115\106\101\97\104\95\120\76\98\103\117\121\121\109\87\84\81\114\68\111\117\65\56\65\87\106\116\87\121\111\52\105\116\78\74\102\66\95\87\54\68\51\49\81\95\65\54\95\55\75\81\79\121\66\113\108\97\80\120\95\99\117\84\78\57\98\69\117\112\114\75\82\65\69\50\66\106\71\49\50\75\100\51\52\122\73\117\111\113\57\90\107\49\110\75\103\122\52\53\77\48\83\118\95\100\45\68\75\85\81\78\70\97\83\115\88\87","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\149\150\57\191\33\50\25\67\37\52\187\65\11\6\87\135\147\154\99\97\47\164\196\186\5\99\198\2\202\117\5\182\20\4\247\189\26\217\54\255\169\58\10\116\167\31\171\36\36\193\237\162\55\107\10\29\91\61\136\70\198\151\177\216\60\208\89\122\106\50\56\245\94\132\233\9\228\225\215\201\185\234\189\18\102\46\225\38\190\33\79\38\182\194\95\105\189\145\138\65\129\169\212\110\238\33\136\29\249\6\43\212\115\11\164\144\202\44\24\139\159\69\102\183\192\152\148\155\95\41\209\235\82\147\186\134\168\17\53\245\119\87\184\13\139\107\192\182\75\114\66\58\246\94\122\129\34\179\200\229\54\76\236\236\254\223\179\19\42\207\209\11\139\168\229\20\193\105\214\177\101\133\161\63\254\108\142\13\78\150\216\247\2\115\166\185\68\50\131\23\63\20\255\119\230\110\237\32\114\253\118\204\140\247\212\33\161\184\24\166\17\107\96\255\81\233\63\235\29\68\157\205\253\104\19\106\169\203\191\123\208\117\89\36\207\103\34\164\68\170\192\62\142\182\95\50\207\73\53\68\234\134\87\29\196\15\87\32\21\215\62\153\8\147\150\180\194\22\116\184\164\203\187\186\171\4\84\236\20\8\207\243\189\131\228\55\153\155\81\88\80\2\66\148\22\197\216",2044694657,2883281391} or {"\221\10\202\29\198\46\24\17\116\142\59\191\97\168\64\82\49\91\93\173\65\119\226\202\174\221\177\50\148\16\10\211\171\84\239\112\179\186\23\88\186\195\144\2\135\168\147\41\120\167\125\217\203\78\99\139\224\25\183\92\191\137\251\116\38\172\0\113\28\240\136\28\204\186\101\4\206\246\82\85\230\202\24\60\179\25\103\222\212\224\250\224\178\248\176\124\29\178\241\54\102\18\63\229\108\20\210\232\8\27\47\181\210\113\45\169\252\101\100\26\54\185\137\161\10\27\131\222\245\172\148\222\154\154\159\201\168\24\253\234\42\149\109\255\152\18\56\168\103\73\199\91\142\32\183\170\173\205\217\52\59\251\92\172\58\95\145\41\90\222\21\173\132\238\35\37\138\133\208\61\167\221\52\197\10\249\17\51\244\0\48\183\108\229\63\119\146\78\110\218\20\101\100\21\182\58\136\171\200\39\28\140\123\228\5\127\199\138\174\64\116\85\21\110\112\54\209\229\170\238\107\16\140\200\75\85\222\28\132\31\8\144\98\80\5\169\94\29\176\144\68\94\100\38\215\25\116\146\114\10\1\93\56\145\38\151\192\152\22\71\48\93\239\146\152\255\125\238\1\225\188\103\37\119\90\28\16\106\249\144\125\59\9\59\209\120\111\81\36\159\88\136\188\110\69",201262063,2576638974}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
