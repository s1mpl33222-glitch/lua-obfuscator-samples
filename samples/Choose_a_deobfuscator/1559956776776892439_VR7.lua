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
local pinned=url.."?retry=24586b42bc11aaa5"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=24586b42bc11aaa5"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\53\100\57\53\54\57\102\98\54\48\52\54\50\98\49\100\98\100\48\48\54\48\99\56\52\56\57\98\102\97\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\83\51\70\65\101\99\87\54\65\89\97\104\50\104\80\85\58\67\52\82\105\53\90\83\52\51\45\75\53\88\90\107\53\67\120\73\109\106\65\58\81\112\105\119\76\78\56\53\55\122\45\45\69\116\109\73\100\95\69\117\82\66\56\122\99\56\95\119\120\77\89\118\79\73\105\111\113\72\56\89\77\108\102\80\118\101\103\87\97\54\57\100\120\102\99\65\65\103\90\98\75\66\86\99\78\99\104\114\103\105\50\89\89\102\72\99\100\84\104\113\65\107\75\98\48\106\119\86\98\103\54\116\109\98\84\104\57\73\100\115\70\121\74\68\103\57\55\72\120\89\90\53\69\111\121\120\109\121\68\53\111\56\112\100\50\82\51\122\88\75\65\73\48\111\105\71\55\78\66\98\88\118\122\48\111\105\80\99\101\108\86\116\100\112\85\53\79\67\50\119\76\80\48\108\112\86\56\84\57\66\113\68\102\99\66\109\69\100\122\48\90\102\69\103\107\97\84\113\115\71\76\106\67\87\67\69\68\56\50\76","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\86\2\213\36\170\27\193\152\80\209\119\235\13\75\250\155\166\110\119\101\119\10\109\157\80\249\198\63\156\138\136\66\64\181\118\82\177\236\221\160\81\177\212\107\79\214\255\146\76\161\185\128\13\40\117\30\226\152\158\147\202\120\45\59\209\24\77\27\202\52\68\234\107\254\46\160\125\208\168\91\100\89\120\136\236\21\177\161\130\174\102\194\42\104\69\10\226\112\231\198\197\107\199\4\235\66\68\0\127\75\92\145\164\45\72\61\172\154\185\77\1\235\61\114\221\87\236\168\128\176\46\124\77\241\211\233\26\236\254\30\213\60\241\145\203\93\252\38\238\107\205\3\145\7\250\131\90\96\24\26\239\77\249\36\112\3\155\43\28\33\94\151\248\68\54\54\180\14\255\33\36\36\19\55\79\251\98\175\218\158\176\64\180\8\253\103\120\112\79\36\109\215\80\6\51\183\61\119\109\84\152\205\171\187\98\172\176\180\152\178\146\126\24\39\22\45\238\88\207\43\131\186\189\160\220\23\16\239\27\30\188\140\119\16\210\44\78\150\118\44\127\105\25\233\134\218\11\37\14\94\66\83\132\151\47\20\230\151\235\215\78\10\162\65\17\0\77\70\75\122\172\81\234\69\16\184\232\180\243\186\53\20\161\213\126\175\65\111\106\111\135\232\107\91\117\200\65",1001305414,310272452} or {"\101\7\108\155\145\59\255\38\0\171\153\145\223\15\183\147\248\254\147\231\237\161\11\90\26\8\158\233\148\211\226\119\181\135\57\235\245\161\250\244\83\31\133\73\157\127\239\100\84\242\158\190\168\23\179\74\110\77\157\7\191\155\136\20\135\250\85\41\226\55\98\124\44\185\171\149\171\33\15\205\67\86\36\68\19\45\60\22\11\205\114\34\102\42\14\108\171\213\129\63\188\56\147\224\235\109\24\154\134\134\133\160\118\124\213\130\87\55\17\213\99\114\239\32\197\5\235\249\111\252\170\206\179\145\132\63\222\77\27\151\35\212\238\75\176\61\21\72\34\202\60\247\163\9\106\130\234\240\57\92\163\176\19\127\239\175\145\108\93\156\183\36\231\135\86\17\40\211\230\187\117\69\155\68\253\180\57\146\227\240\92\211\103\164\189\6\5\215\238\98\63\20\108\241\105\125\132\94\122\171\90\138\92\18\132\97\79\195\27\233\9\230\17\243\32\237\247\58\165\39\141\222\98\53\164\206\125\13\226\93\46\152\252\187\94\233\65\52\150\128\8\216\234\13\152\237\3\72\227\9\236\204\255\36\211\179\64\123\206\5\103\202\19\92\41\5\204\207\42\142\202\141\42\187\102\177\69\40\203\131\239\88\145\210\166\62\229\95\41\60\75\31\91\32\239",2962947640,9659347}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
