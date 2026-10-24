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
local fresh=url.."?retry=d13191e8661af056"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=d13191e8661af056"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\98\51\53\101\97\50\55\55\54\52\97\97\101\53\54\102\55\100\54\55\48\102\50\55\50\102\53\51\52\50\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\65\72\89\73\57\121\78\103\97\119\107\99\114\99\104\98\58\74\79\112\82\65\116\87\76\113\111\111\105\57\65\98\112\90\54\56\82\69\103\58\111\81\95\114\53\77\74\115\103\56\105\54\106\108\116\57\108\100\117\104\71\45\76\102\55\85\121\73\101\100\108\107\66\101\56\48\112\55\89\119\117\109\104\56\68\121\65\56\95\90\66\68\77\55\53\112\119\84\80\48\121\97\83\56\50\83\112\108\107\98\74\121\119\69\109\54\103\115\111\67\115\78\83\53\109\71\103\89\90\70\68\70\82\69\72\107\110\67\113\100\116\54\105\54\74\122\118\69\57\70\48\99\82\90\80\67\55\55\55\103\48\95\57\45\89\77\75\102\119\116\85\110\116\54\89\52\45\87\97\111\111\49\103\95\103\54\65\111\89\74\86\82\73\105\52\57\109\122\111\86\74\108\74\106\48\113\51\111\108\111\74\116\78\118\48\81\118\85\88\76\57\66\98\100\110\118\57\97\48\51\54\117\80\67\66\90\89\104\72\68","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\165\195\148\58\76\82\129\58\158\254\29\48\93\93\228\186\251\16\164\142\101\20\44\153\60\9\29\139\90\54\135\7\249\177\160\228\130\155\16\46\91\78\78\121\173\59\77\201\148\64\177\212\212\39\81\49\231\26\72\23\73\201\162\177\138\118\100\147\42\43\20\112\193\142\93\146\101\89\217\105\82\216\108\47\175\14\10\216\96\40\3\0\253\210\116\223\246\153\183\187\231\36\39\202\114\43\137\146\19\173\41\92\158\243\228\176\196\70\116\232\187\65\109\235\203\108\165\171\169\212\215\24\228\144\29\47\33\35\46\136\104\251\205\6\236\204\197\18\191\194\174\110\235\154\66\101\36\144\81\122\27\52\163\107\233\180\68\96\199\153\60\188\219\218\16\189\65\118\102\245\21\76\79\77\250\59\99\144\146\69\242\28\175\27\29\140\103\46\41\88\173\38\140\108\2\121\223\252\43\112\47\190\7\128\179\202\211\164\131\2\114\146\135\227\146\163\183\210\142\135\66\223\204\76\195\58\137\214\102\75\144\16\189\38\235\250\226\185\140\110\122\63\195\239\208\232\92\80\214\80\104\178\172\228\206\44\231\157\78\120\111\180\65\161\145\54\168\116\34\128\91\66\202\122\213\82\233\76\204\227\26\54\169\172\173\155\231\84\167\239\227\81\128\151\65\212\225",2094796501,3756351965} or {"\207\7\203\41\230\254\114\16\204\27\204\132\234\200\159\52\41\171\167\245\164\177\152\90\40\58\172\34\25\167\15\183\215\122\24\26\227\163\66\46\71\179\82\241\232\238\160\116\110\30\68\251\162\200\37\79\80\196\132\129\55\102\24\14\90\189\33\80\222\236\93\253\58\190\227\115\176\32\202\188\84\158\175\104\236\54\141\69\181\227\200\48\230\217\118\194\26\191\198\149\127\132\4\58\231\194\51\228\13\189\123\40\139\95\249\107\38\244\207\204\196\68\110\54\110\132\238\105\211\179\248\153\119\232\146\230\7\70\72\31\77\102\53\26\152\103\12\206\53\189\162\235\155\122\96\87\194\31\82\210\87\16\108\156\252\183\94\45\235\131\242\38\54\105\64\28\123\252\93\167\74\108\32\142\189\169\135\211\77\37\197\154\170\64\125\203\102\1\141\123\0\117\193\127\186\186\25\125\31\232\242\220\212\150\44\211\121\165\186\113\161\208\11\43\194\208\151\244\168\148\190\148\58\241\156\255\212\20\50\230\13\139\8\206\199\139\170\218\171\91\175\51\142\235\38\120\35\63\13\162\206\126\94\84\10\177\185\43\119\214\232\64\211\131\220\141\174\184\238\119\20\177\252\40\49\79\77\129\151\249\72\163\122\50\73\31\149\180\248\108\37\91\68\42\97",268905893,3460981740}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
