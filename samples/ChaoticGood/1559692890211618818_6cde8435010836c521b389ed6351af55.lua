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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=66c3a073bb476458"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=66c3a073bb476458"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\54\99\100\101\56\52\51\53\48\49\48\56\51\54\99\53\50\49\98\51\56\57\101\100\54\51\53\49\97\102\53\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\109\109\118\75\65\113\71\82\111\87\103\79\53\67\115\84\58\102\75\57\76\107\109\90\77\90\103\113\82\120\100\100\81\113\90\70\65\75\103\58\104\74\56\90\111\119\109\79\89\111\68\78\80\65\76\77\50\103\114\102\48\52\89\67\49\69\53\75\118\69\57\118\66\97\99\72\107\119\105\116\69\49\121\45\103\117\117\84\65\103\99\70\71\100\118\69\95\78\49\67\67\54\69\103\105\108\68\53\107\81\83\86\90\118\116\79\83\65\102\89\121\56\107\75\99\113\74\110\79\112\115\84\49\109\57\81\73\54\67\70\89\112\97\95\45\74\103\116\80\86\101\100\76\66\67\69\121\52\72\70\111\99\84\105\70\86\73\107\114\54\111\50\110\86\78\48\50\112\76\113\55\112\112\78\90\53\73\119\70\57\105\114\45\100\112\80\105\110\95\50\87\122\83\65\89\70\53\122\97\45\119\65\73\97\87\117\82\88\121\117\107\115\88\77\110\75\87\51\77\53\76\68\52\67\45\72\78\65\73\108","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\96\15\26\176\150\71\226\149\85\223\131\59\204\131\176\92\82\81\85\10\56\67\222\57\86\115\187\245\164\89\104\82\251\133\213\92\46\225\49\48\178\67\178\207\164\186\216\156\34\99\109\194\41\209\56\14\172\183\74\248\33\90\121\147\212\236\150\234\82\4\84\221\123\186\63\7\37\227\24\176\153\25\121\236\80\143\171\85\240\220\182\13\116\196\160\45\137\143\181\252\57\186\195\125\103\64\18\211\106\243\182\233\31\45\31\23\56\110\129\198\6\215\204\55\98\112\152\197\46\228\71\232\95\159\219\81\132\100\173\226\17\129\237\28\144\44\31\234\185\155\98\68\114\181\106\194\37\227\6\112\138\70\43\132\224\44\231\244\196\31\5\161\1\64\165\252\120\112\28\123\83\249\115\200\188\233\92\27\170\118\141\107\134\238\30\56\139\226\44\157\236\246\106\187\123\71\187\202\237\54\16\250\123\99\147\2\82\194\122\63\88\5\92\251\224\63\216\6\45\36\102\68\94\36\13\76\35\148\38\184\174\197\241\138\246\11\15\160\204\99\154\207\211\50\16\223\126\146\57\226\207\134\36\89\223\181\77\135\145\20\120\251\15\142\248\52\105\198\217\127\236\45\149\124\130\105\162\170\168\189\155\79\231\224\244\185\214\238\34\134\109\173\193\114\245\21\122",259370061,609444131} or {"\173\29\21\80\180\219\247\178\39\114\4\224\142\35\225\101\32\6\103\96\249\109\179\189\207\65\74\183\145\50\62\24\6\166\58\169\29\239\44\171\240\67\134\254\224\71\73\129\84\136\79\218\248\134\212\84\49\196\241\147\20\193\132\148\243\27\235\54\176\187\207\120\206\187\253\226\52\229\217\175\192\42\196\159\120\47\73\61\91\96\48\74\23\201\203\93\197\140\238\86\140\5\75\80\201\154\214\125\202\107\215\222\158\246\40\211\31\193\93\42\170\144\99\112\107\88\243\140\188\41\63\238\103\42\131\24\49\97\139\246\149\100\22\105\192\181\56\243\110\173\251\216\5\230\5\155\56\86\187\82\196\188\130\22\22\149\101\137\192\149\34\178\57\179\28\218\187\251\143\179\134\70\57\49\59\124\65\106\199\141\24\49\199\208\149\109\244\99\47\62\42\131\68\120\20\114\119\117\75\59\79\159\119\21\212\207\79\156\108\187\13\182\104\202\217\188\82\132\251\46\147\211\168\37\242\121\171\44\80\152\96\99\159\168\209\155\30\248\235\111\221\56\39\45\106\174\249\79\143\159\149\203\105\76\215\229\68\77\20\38\121\250\228\120\99\233\135\144\155\184\77\136\71\103\68\154\68\9\85\69\72\58\73\126\187\79\137\38\39\151\47\44\155\134\184",35765924,327443250}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
