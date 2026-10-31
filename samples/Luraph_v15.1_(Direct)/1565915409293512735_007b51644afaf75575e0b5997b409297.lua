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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=cfb3376fd4049fcf"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=cfb3376fd4049fcf"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\48\55\98\53\49\54\52\52\97\102\97\102\55\53\53\55\53\101\48\98\53\57\57\55\98\52\48\57\50\57\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\107\122\69\86\45\54\107\117\100\115\97\89\75\106\106\105\58\69\110\56\67\101\52\119\103\106\113\52\76\120\75\73\102\86\83\88\114\83\119\58\71\88\72\57\87\81\76\56\118\81\117\115\72\77\88\104\107\57\57\79\103\88\89\108\122\84\48\122\108\72\67\56\110\106\90\116\100\83\112\118\122\104\81\68\73\104\78\50\80\71\81\100\52\78\101\121\50\65\118\105\48\120\111\102\55\76\76\109\57\77\106\88\45\65\99\101\74\111\84\107\86\83\50\51\74\48\77\54\120\78\95\103\55\52\74\82\106\112\57\89\80\108\57\120\101\79\72\113\65\97\67\87\57\110\65\71\109\122\51\56\119\95\95\104\119\116\95\102\120\117\110\84\114\98\83\52\90\95\117\105\66\110\108\77\50\79\121\70\86\95\114\82\122\82\120\117\88\112\107\57\51\119\74\111\111\103\121\120\120\116\119\67\82\77\77\90\97\120\65\50\107\71\85\50\114\100\84\98\45\115\76\80\112\83\45\52\83\110\86\73","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\62\128\172\207\173\128\252\132\158\225\80\182\112\245\100\67\125\224\238\240\108\115\14\73\182\21\34\81\168\165\43\64\208\92\142\220\232\53\116\44\20\204\106\216\250\181\182\7\243\209\254\59\61\239\20\143\159\212\235\108\167\46\34\215\102\219\99\40\253\43\7\130\79\63\193\32\41\66\247\123\147\191\232\152\56\89\252\72\15\148\121\172\169\84\75\73\79\221\38\144\87\3\45\56\29\175\72\174\143\177\58\89\232\19\33\110\103\218\103\174\156\32\251\7\76\83\188\87\8\204\49\127\43\108\255\254\48\168\242\137\152\237\21\111\171\196\38\235\39\85\26\0\75\184\175\32\143\216\185\52\36\143\58\181\68\45\47\71\152\196\252\182\211\146\15\0\176\188\51\164\255\168\138\50\187\78\203\31\54\127\45\58\173\246\84\64\127\41\173\5\44\192\125\226\163\135\217\104\172\13\47\237\90\152\203\179\168\43\157\74\74\190\36\115\49\205\59\49\25\159\102\109\154\128\117\158\175\126\6\121\48\199\184\31\223\131\177\212\206\128\206\244\210\225\183\171\183\187\226\185\42\72\67\186\186\180\190\79\39\1\129\113\255\224\236\99\109\75\191\12\62\202\112\61\36\101\210\94\133\41\169\199\53\136\227\2\229\218\81\78\146\113\64\7\135\110\218",3498343469,2868011925} or {"\46\192\88\235\220\66\197\184\122\133\126\126\27\13\167\28\100\130\112\251\98\231\21\56\74\56\87\168\69\147\15\242\108\92\214\7\247\55\207\206\65\151\51\213\11\59\9\91\151\216\29\249\252\55\234\62\37\32\98\62\76\183\148\149\244\216\217\99\234\116\75\151\232\146\238\212\177\249\112\105\151\225\76\32\91\25\35\168\99\62\79\162\23\242\225\129\176\113\85\78\65\27\219\67\142\193\37\14\119\163\19\207\243\193\160\45\114\175\175\37\73\184\247\175\116\8\0\44\162\193\248\251\201\251\60\220\57\146\153\0\67\115\94\163\89\242\95\56\2\253\43\18\110\64\213\17\163\199\48\35\197\246\149\120\135\30\216\102\11\183\249\234\184\23\138\144\194\43\117\201\242\209\154\226\76\159\254\49\146\241\170\52\3\7\40\94\186\69\65\120\192\155\225\166\159\76\196\174\138\137\252\233\193\42\188\215\247\51\238\151\193\105\78\162\147\218\25\4\162\64\227\79\39\121\236\171\187\167\230\238\249\239\189\136\176\4\85\4\148\92\185\158\121\23\81\122\99\149\217\143\78\24\228\135\27\189\246\50\172\247\134\141\14\249\130\158\197\100\131\23\54\1\210\69\69\230\217\40\34\19\143\209\241\169\152\99\178\0\92\145\134\230\203\103\106",1213357922,2590729636}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
