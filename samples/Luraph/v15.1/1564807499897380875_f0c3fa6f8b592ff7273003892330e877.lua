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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=0313bf4960f57d39"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=0313bf4960f57d39"
local expected=618951
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
if s2*65536.0+s1~=733717851 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\48\99\51\102\97\54\102\56\98\53\57\50\102\102\55\50\55\51\48\48\51\56\57\50\51\51\48\101\56\55\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\57\110\99\83\122\100\72\79\117\77\67\101\85\88\116\117\58\75\74\88\73\101\68\69\90\121\81\105\82\45\108\81\87\107\69\79\108\101\103\58\74\113\100\83\103\84\115\89\51\48\70\106\79\121\50\114\51\78\48\52\82\74\82\95\65\76\77\107\75\88\108\108\48\49\114\108\51\49\74\85\101\103\97\121\72\106\82\119\81\117\79\74\79\54\76\114\115\98\118\113\122\115\121\110\121\66\119\103\78\105\88\111\95\122\65\45\68\48\105\76\108\56\85\86\48\65\109\121\99\84\111\55\102\69\119\70\87\86\108\98\45\83\119\88\75\70\98\121\121\112\56\120\111\77\107\86\84\107\87\108\88\90\100\79\113\82\113\102\100\87\66\118\104\55\68\48\121\74\106\78\49\87\100\122\85\105\84\83\120\112\80\65\54\109\105\113\67\68\73\104\69\122\107\74\86\76\68\55\99\66\51\82\75\82\109\110\118\116\76\52\76\97\84\78\106\74\111\57\112\80\80\76\69\67\77\73\54\98\75\84","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\102\239\129\163\84\66\59\17\28\118\24\118\28\114\41\88\11\181\128\128\149\9\174\182\239\244\116\217\136\138\201\190\17\231\51\241\88\16\220\128\186\234\9\141\24\203\224\175\100\232\130\232\129\222\224\16\31\213\228\84\86\24\233\107\198\72\190\176\48\161\68\18\70\202\213\255\253\105\225\124\69\48\61\90\4\142\250\38\131\49\189\47\149\101\71\115\66\209\2\64\55\0\59\167\106\118\236\254\41\155\152\188\113\199\225\141\19\229\171\110\103\255\239\242\168\178\102\185\98\75\248\109\175\68\178\81\61\75\238\182\36\250\144\220\217\57\6\2\88\157\3\64\66\201\164\169\57\112\60\44\119\71\123\212\130\79\1\82\40\236\78\220\179\0\88\56\9\213\128\55\168\194\194\193\171\215\221\101\18\162\114\193\247\65\48\98\168\168\169\162\61\4\74\60\235\185\244\190\232\68\223\203\44\108\222\53\197\27\83\31\214\223\62\188\101\95\177\25\11\226\26\36\51\243\24\255\10\0\155\87\203\232\226\34\70\241\30\79\250\81\171\177\140\98\198\13\201\254\212\194\164\169\2\43\153\134\254\16\154\65\5\67\243\144\93\28\1\123\34\56\25\75\37\131\28\19\161\124\244\192\79\76\12\172\20\14\186\196\16\237\196\80\23\138\24\141\113",3542174409,4195377981} or {"\1\35\23\156\195\94\29\96\29\200\209\220\107\125\149\212\142\76\138\52\160\225\251\197\28\160\199\1\0\68\232\109\68\172\61\252\220\169\99\130\161\94\58\237\196\151\199\23\36\146\107\30\59\60\50\134\23\161\219\213\203\202\83\229\38\75\76\26\40\1\163\82\255\149\152\228\180\61\180\178\44\137\24\49\163\131\110\15\150\247\145\70\18\249\212\205\234\103\190\79\85\10\78\119\23\113\103\253\156\21\45\176\109\177\97\100\70\64\93\114\90\156\159\19\13\211\2\90\156\244\254\15\138\241\105\93\59\243\109\0\184\217\18\0\180\39\82\222\219\71\175\181\113\17\148\17\117\228\243\235\79\226\102\221\199\9\111\79\17\202\174\143\83\117\63\192\146\247\255\132\255\199\70\155\156\139\186\79\170\254\134\108\156\42\146\107\38\157\249\33\14\182\91\154\108\239\120\202\147\227\161\123\157\124\21\250\26\77\43\84\91\200\7\117\245\70\30\228\141\43\103\90\224\219\40\250\150\105\202\239\176\167\113\6\233\125\80\210\237\103\32\64\142\58\182\252\102\236\127\158\194\202\159\141\140\79\173\3\85\112\139\27\237\205\213\185\99\183\139\162\118\155\202\151\7\46\223\44\94\47\241\119\121\176\89\238\14\218\125\110\169\131\132\154\26",3347726147,3911673164}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
