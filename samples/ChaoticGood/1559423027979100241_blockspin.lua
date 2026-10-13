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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=66a54872edd07d9b"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=66a54872edd07d9b"
local expected=898586
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
if s2*65536.0+s1~=1933677448 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\73\103\69\100\116\50\103\101\104\88\115\56\67\80\120\114\58\111\57\111\111\115\112\89\65\70\118\51\86\72\68\113\80\113\72\86\109\116\103\58\78\73\52\65\115\71\77\101\90\109\118\90\107\111\80\81\90\53\99\53\72\66\101\73\118\73\83\105\120\85\77\111\114\86\51\104\55\112\71\68\49\74\120\85\122\55\109\105\108\68\49\48\86\116\54\100\114\112\122\103\84\106\73\52\114\112\67\70\79\53\113\86\95\72\105\51\112\75\51\55\55\118\67\112\82\86\74\120\49\80\72\73\65\74\53\111\50\108\107\72\86\55\83\78\122\114\107\111\87\54\112\74\84\113\122\53\86\53\113\102\45\122\48\52\102\95\105\99\101\45\87\117\90\109\53\78\75\77\73\120\120\114\48\69\74\82\71\105\109\69\73\71\83\78\104\115\122\87\106\106\100\118\104\55\97\50\56\99\86\87\80\101\110\89\88\95\119\110\85\71\67\106\71\71\67\119\99\78\77\48\104\65\88\105\103\87\90\65\68\73","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\24\80\212\29\249\165\218\74\226\206\89\137\48\50\165\60\33\224\194\143\124\182\57\229\45\135\201\78\173\190\198\36\197\139\220\153\34\250\238\127\31\213\148\95\244\53\54\151\68\63\78\156\128\42\32\29\71\0\81\160\220\154\83\143\97\211\200\0\44\233\161\79\229\136\25\119\157\121\0\89\112\15\92\147\215\109\160\10\38\126\164\34\234\213\38\194\75\124\243\121\110\222\0\142\217\8\121\224\113\175\175\81\61\65\83\122\193\86\232\121\131\166\133\39\65\165\61\94\34\141\178\242\2\103\8\47\87\219\189\146\129\94\107\171\184\154\166\203\29\146\11\234\19\168\8\27\42\77\15\66\4\244\225\223\89\78\151\139\185\46\123\245\92\143\30\237\186\252\202\168\133\155\169\120\242\27\162\22\85\173\146\145\146\251\241\210\96\15\37\179\143\70\4\96\32\21\196\156\135\53\53\146\193\202\31\157\58\162\104\40\75\238\168\19\79\210\238\72\9\180\134\49\232\0\132\30\112\126\95\115\30\44\235\197\26\195\149\117\36\13\170\108\184\238\204\14\8\27\218\213\217\0\199\88\132\251\184\75\189\170\99\11\225\189\70\122\225\78\99\47\11\202\33\51\38\103\107\228\24\251\179\130\96\19\72\212\167\201\25\43\212\50\210\142\99\127\141",3079507288,764830433} or {"\231\76\178\117\3\149\20\88\147\107\152\49\194\221\126\69\215\30\207\165\168\9\54\182\65\121\55\12\211\79\90\5\65\136\102\14\162\103\189\148\218\148\107\123\195\67\59\35\142\238\131\175\141\196\198\197\156\204\224\163\130\141\180\126\158\37\56\229\20\198\190\251\183\242\37\20\46\34\34\80\28\131\89\217\230\99\106\178\233\187\146\89\153\7\56\243\115\209\242\5\113\230\48\250\2\200\227\115\131\169\127\146\204\102\127\137\116\159\9\159\186\252\168\144\210\245\55\213\101\231\172\236\195\36\58\245\104\92\139\238\231\253\164\2\213\0\99\148\163\62\97\166\218\177\106\79\149\113\118\80\222\115\44\224\168\198\136\35\68\152\38\246\12\103\69\84\178\46\88\5\138\89\144\38\100\59\96\156\16\34\95\198\2\250\110\30\60\68\212\151\5\123\167\227\182\124\174\217\43\120\69\184\194\95\179\106\57\44\39\59\115\219\54\15\155\164\40\173\216\206\22\83\169\39\172\21\39\122\77\29\169\68\150\130\146\57\250\162\60\127\212\61\214\31\50\71\13\157\6\249\57\65\237\81\145\120\89\130\140\114\244\58\38\27\106\156\255\176\8\234\111\111\82\177\145\186\63\63\151\58\77\178\220\251\53\172\61\91\1\172\170\88\186\212\222",358129911,462513392}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
