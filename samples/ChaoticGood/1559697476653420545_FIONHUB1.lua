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
local pinned=url.."?retry=5dc3b10d8c3aa9c6"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=5dc3b10d8c3aa9c6"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\53\48\53\102\53\97\56\97\99\57\57\56\51\102\53\101\52\52\51\98\99\100\57\102\53\102\98\49\100\98\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\102\121\81\74\77\76\80\118\114\75\80\77\74\81\118\109\58\81\74\65\107\84\65\99\120\105\90\113\77\115\49\77\107\57\104\95\112\116\65\58\54\75\104\86\82\99\88\68\99\87\68\72\81\103\86\97\54\117\118\75\109\53\120\71\110\72\106\68\49\118\89\99\122\122\97\105\98\53\112\121\120\82\104\54\110\102\95\84\103\73\75\81\89\101\89\80\100\69\101\119\104\73\65\112\89\78\109\112\84\115\69\86\101\119\49\68\122\121\53\79\80\45\104\116\67\113\51\66\74\97\87\48\65\95\57\56\117\52\104\81\105\106\54\89\78\73\121\89\69\57\69\52\90\77\74\97\104\70\111\97\50\45\81\66\82\95\56\114\108\82\48\75\109\80\54\108\49\90\57\99\55\83\51\53\51\77\100\83\122\78\78\115\98\113\71\111\98\54\56\118\95\106\69\110\97\107\80\115\115\65\97\79\104\110\73\100\50\57\103\56\113\97\75\65\100\119\89\54\70\122\54\116\68\109\66\78\73\65\120\55","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\245\165\128\19\228\62\247\23\38\254\39\191\26\112\41\173\47\80\110\2\25\218\231\239\127\34\39\240\23\127\107\177\179\57\198\77\100\173\218\154\237\10\105\194\119\196\107\69\108\111\135\203\243\204\107\9\23\41\12\23\24\201\28\133\126\150\92\164\38\53\248\176\111\13\148\106\132\79\151\121\248\185\209\97\180\246\206\60\222\174\194\140\43\51\158\20\12\33\172\67\125\108\47\122\11\223\38\168\97\45\234\51\133\190\251\33\44\8\245\45\27\37\90\64\200\145\25\48\85\142\243\33\42\128\118\150\246\92\247\4\144\61\184\137\151\173\8\43\244\169\43\200\114\111\55\58\89\113\198\24\144\141\234\160\147\41\159\231\90\239\144\6\231\127\149\78\26\229\118\150\96\18\31\28\227\131\187\108\80\158\1\167\122\71\135\154\164\160\221\84\193\103\72\206\78\184\192\230\44\33\186\147\134\78\183\181\101\169\212\11\86\236\142\4\49\159\235\136\239\208\83\18\185\69\70\74\239\23\131\181\20\72\173\149\168\54\112\178\180\223\47\215\66\25\35\51\163\221\204\43\87\249\150\167\144\194\6\165\221\198\98\242\20\130\34\26\252\133\145\91\18\130\215\61\12\132\153\135\163\62\210\43\36\44\138\123\78\138\43\234\208\63\135\56\243\88\74",994899455,618488627} or {"\76\124\218\168\194\152\37\62\93\121\7\123\206\161\208\79\204\239\124\131\193\249\185\192\228\69\205\152\190\197\247\52\147\222\116\25\140\8\148\43\87\196\181\198\116\103\135\169\160\17\28\153\233\171\86\160\245\246\70\64\103\25\238\42\8\254\25\246\142\195\172\117\145\207\63\100\161\252\225\242\205\161\74\224\93\204\21\6\145\234\136\117\50\229\94\208\135\205\166\81\41\75\174\121\71\169\93\69\192\92\72\176\182\68\107\212\128\173\40\221\198\23\243\169\143\183\95\75\180\43\50\22\56\144\178\53\176\48\16\176\83\61\192\191\34\141\169\132\52\124\77\128\224\155\87\137\62\191\12\9\229\159\155\55\135\161\35\235\254\112\169\172\238\200\64\145\173\107\31\28\156\225\127\5\164\17\87\113\164\184\36\227\91\211\93\74\249\105\197\112\180\38\24\243\161\46\235\84\57\153\124\222\5\102\255\189\147\179\35\72\1\30\99\164\104\231\87\235\33\133\242\241\5\104\13\86\133\97\180\252\108\107\124\31\39\162\9\74\249\202\105\103\223\225\147\211\118\96\148\117\220\103\37\172\85\239\114\178\232\60\232\230\243\158\172\199\114\174\123\66\116\179\160\19\190\15\208\53\143\121\104\168\194\186\213\86\179\16\129\132\108\86\79\30\23",2216493208,291005762}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
