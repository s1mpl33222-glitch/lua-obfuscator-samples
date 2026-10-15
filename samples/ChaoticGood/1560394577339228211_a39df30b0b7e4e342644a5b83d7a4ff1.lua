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
local pinned=url.."?retry=225aabe70284da4f"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=225aabe70284da4f"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\51\57\100\102\51\48\98\48\98\55\101\52\101\51\52\50\54\52\52\97\53\98\56\51\100\55\97\52\102\102\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\67\66\71\111\122\56\72\109\118\85\122\100\78\107\108\98\58\50\89\107\45\116\45\67\75\79\115\65\66\113\70\105\70\83\84\109\103\108\65\58\66\52\104\77\65\55\73\51\71\116\104\105\89\104\67\83\116\52\72\121\83\108\74\65\73\83\70\69\49\121\77\97\120\111\78\106\122\108\118\115\106\104\106\114\54\73\97\52\100\95\71\98\97\51\113\49\83\119\122\55\104\87\102\68\121\120\112\86\54\121\49\84\68\52\102\66\105\76\53\75\122\122\53\117\90\122\108\76\110\86\119\115\67\116\84\56\68\97\117\66\68\105\112\121\51\101\89\67\77\113\99\69\66\54\55\106\100\98\90\74\95\116\55\76\119\106\85\118\73\116\111\111\101\110\119\84\77\105\55\83\78\48\69\68\81\78\80\106\52\80\112\73\83\86\122\78\50\70\52\49\118\65\68\122\103\106\77\114\76\121\101\120\99\119\87\89\72\71\97\78\80\85\90\74\49\117\121\74\85\56\88\73\110\115\82\113\80\116\116\69","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\225\222\45\141\57\214\255\86\18\137\51\169\117\57\158\222\64\54\64\223\75\50\28\148\221\212\122\76\150\156\6\64\96\238\245\79\123\230\227\208\164\73\129\99\65\48\90\129\34\86\146\184\25\47\238\21\229\240\31\224\216\64\48\77\118\135\68\184\41\192\204\30\183\232\43\115\202\181\192\1\211\178\177\241\188\173\207\173\125\185\14\167\93\155\44\166\37\224\110\216\228\195\216\10\114\194\13\233\190\74\146\170\41\230\145\77\20\70\119\204\197\172\126\191\141\141\148\186\115\187\141\187\190\43\238\77\233\200\179\185\160\44\5\7\200\130\252\204\113\109\198\118\20\150\159\255\116\24\183\24\211\116\176\39\90\243\234\208\27\157\125\49\25\120\125\166\102\59\77\55\119\157\126\101\71\253\89\198\142\93\179\249\223\137\39\16\40\76\134\178\211\213\235\195\1\52\76\161\82\199\168\20\80\41\238\80\169\78\231\198\224\133\157\91\92\93\95\139\91\112\183\36\171\144\100\81\208\18\234\186\179\44\244\130\102\113\34\201\166\134\147\116\97\13\14\147\119\99\115\52\156\20\167\126\236\123\240\184\91\64\203\242\44\214\51\237\143\78\131\233\109\79\223\70\206\222\26\77\86\209\196\111\194\202\241\136\111\185\28\47\245\196\207\240\199\146\164",3368191883,1543005195} or {"\67\163\20\15\99\173\32\70\157\122\104\136\101\131\224\79\117\27\231\155\76\253\101\234\135\103\25\218\28\97\113\14\7\46\241\49\0\12\23\111\78\93\154\145\175\49\236\240\140\20\161\113\255\241\117\78\26\252\69\10\119\109\11\95\170\11\254\92\121\25\215\150\23\127\145\85\107\1\75\85\216\206\52\91\70\124\53\209\154\61\182\61\41\144\247\58\138\174\55\163\183\207\45\10\82\218\233\178\129\254\152\238\77\137\97\232\174\202\243\92\2\226\136\116\221\140\138\4\124\180\101\191\184\84\95\44\129\1\100\89\23\24\33\216\2\5\246\44\162\174\68\39\67\69\85\132\22\104\62\131\79\134\237\2\254\214\51\106\88\184\83\15\185\102\100\244\182\26\210\57\120\16\53\184\166\213\179\133\69\93\205\78\235\56\251\195\183\133\207\225\114\63\167\13\40\123\62\189\149\12\151\36\87\186\34\214\215\33\106\139\249\197\96\212\228\100\64\200\30\188\49\21\3\250\208\19\88\118\122\112\109\178\93\66\103\211\185\70\187\85\206\156\24\155\228\244\11\211\251\22\6\33\48\143\176\47\115\216\245\105\19\120\236\26\70\92\164\133\158\37\41\9\96\93\166\77\104\41\1\70\149\123\116\203\150\190\211\236\80\210\83\200\251\23\8",3849489417,1236887066}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
