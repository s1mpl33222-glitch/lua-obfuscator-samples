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
local fresh=url.."?retry=dd0fc1dd41255742"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=dd0fc1dd41255742"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\50\99\98\51\48\49\100\97\52\98\53\48\101\97\102\55\101\48\48\100\54\49\101\52\52\97\54\97\99\56\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\78\122\74\74\112\120\121\54\97\102\109\74\65\99\86\54\58\116\71\72\87\99\74\70\66\78\70\105\52\72\75\99\75\57\108\100\56\83\119\58\120\71\84\98\114\100\95\116\71\69\57\107\122\102\72\86\68\80\57\54\112\112\81\65\55\102\45\99\122\77\101\78\79\121\103\76\79\100\51\97\116\106\45\72\66\90\98\101\88\69\84\111\68\70\100\72\86\88\82\98\56\81\69\101\112\51\75\102\76\84\76\74\90\49\65\115\88\113\52\51\65\54\77\115\75\68\112\86\87\98\81\122\57\70\107\50\115\82\110\53\56\117\45\114\85\115\104\103\90\83\88\108\66\104\112\103\67\103\76\71\81\118\73\85\70\55\103\114\52\108\50\117\109\119\48\55\90\67\105\99\70\82\116\84\70\78\109\116\88\112\83\122\51\95\82\80\52\51\86\114\112\121\50\87\87\104\114\74\104\108\67\86\118\116\109\102\115\117\54\110\72\108\95\113\120\112\56\117\103\57\45\99\76\98\55\97\105\80\101\81","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\219\105\101\189\218\211\23\234\134\116\240\130\198\228\114\6\164\228\209\115\60\2\87\158\179\119\247\89\158\53\147\162\215\38\201\75\87\255\116\41\218\111\84\253\63\125\197\13\147\146\85\50\1\0\145\180\236\239\159\42\193\109\160\111\216\5\138\10\15\15\70\4\109\242\196\145\150\153\131\90\151\227\17\200\242\221\148\7\240\223\179\70\45\227\112\30\207\0\21\229\143\27\56\158\20\45\57\169\161\96\133\126\184\167\157\2\219\66\86\10\7\135\127\1\27\127\105\175\171\27\104\253\211\125\130\251\246\245\178\72\54\29\229\135\134\113\114\232\99\132\85\129\16\6\37\56\55\163\214\133\224\75\159\38\189\137\105\233\30\155\84\67\224\132\111\226\1\120\110\131\184\222\161\90\183\207\188\234\67\195\208\205\79\125\131\58\246\130\1\83\192\135\199\92\179\130\116\200\222\157\6\10\235\136\219\36\17\138\124\126\135\248\247\149\169\106\197\13\98\113\133\100\27\232\254\30\19\194\85\5\32\212\87\110\244\176\237\236\242\245\152\219\182\167\210\26\119\80\51\241\191\42\35\110\29\30\247\149\196\180\149\69\196\213\96\240\97\73\166\161\75\10\7\135\129\228\226\172\146\120\64\221\84\236\180\212\129\138\48\181\9\89\246\121\64\203\78",695774186,2974704384} or {"\11\224\226\75\193\180\100\161\40\152\65\248\240\60\84\178\127\71\143\223\82\49\56\28\76\87\128\120\197\127\255\1\6\250\254\213\212\67\211\239\123\63\178\18\186\233\76\45\193\195\67\177\141\78\24\147\193\189\5\70\46\150\46\205\77\54\92\81\207\167\29\175\81\184\196\151\154\148\49\214\215\198\117\143\205\106\213\232\245\236\134\132\199\2\18\210\247\225\251\156\107\203\107\167\219\249\72\126\79\138\28\62\42\42\239\108\89\167\142\235\140\8\122\66\94\9\141\164\8\133\173\200\100\75\178\137\253\193\137\36\205\33\188\3\57\203\90\179\24\37\123\48\49\241\186\187\47\218\198\188\190\40\94\39\188\45\151\116\165\182\145\193\238\228\115\116\4\24\123\178\213\168\28\123\160\232\249\23\179\61\134\225\18\78\165\133\255\3\134\78\63\250\200\199\234\93\210\9\30\46\35\123\48\152\66\183\193\187\35\240\152\147\207\43\100\120\122\38\4\215\233\248\64\199\189\198\230\188\73\59\246\188\218\234\221\195\96\80\173\32\11\1\240\213\98\251\134\141\28\246\23\158\220\92\200\254\170\242\132\100\200\120\209\94\142\109\188\108\170\137\171\29\214\47\36\120\184\255\76\108\0\18\157\83\2\24\219\23\176\213\157\212\87\199\156",1398190234,2665047311}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
