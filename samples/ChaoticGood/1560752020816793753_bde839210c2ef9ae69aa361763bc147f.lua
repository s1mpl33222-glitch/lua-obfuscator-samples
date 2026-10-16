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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\99\57\53\99\49\98\55\54\56\49\51\50\98\52\51\51\57\50\101\101\97\100\48\48\102\57\100\50\49\48\52\57\54\98\98\101\52\98\52\51\54\101\53\52\100\102\102\49\52\50\53\48\98\50\48\57\49\57\54\52\55\53\97\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\99\57\53\99\49\98\55\54\56\49\51\50\98\52\51\51\57\50\101\101\97\100\48\48\102\57\100\50\49\48\52\57\54\98\98\101\52\98\52\51\54\101\53\52\100\102\102\49\52\50\53\48\98\50\48\57\49\57\54\52\55\53\97\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=8559c4995bd72b23"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=8559c4995bd72b23"
local expected=581307
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
if s2*65536.0+s1~=2921955113 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\100\101\56\51\57\50\49\48\99\50\101\102\57\97\101\54\57\97\97\51\54\49\55\54\51\98\99\49\52\55\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\69\66\80\100\87\121\90\66\107\77\118\100\81\119\90\66\58\107\74\67\116\117\98\52\68\104\119\54\50\74\107\77\89\54\48\81\57\106\65\58\75\105\104\67\79\65\99\50\69\121\105\108\114\73\66\95\118\121\65\98\53\86\76\116\82\73\113\117\89\95\121\116\72\88\56\45\104\107\88\119\97\121\100\88\84\66\98\82\114\75\70\117\81\55\90\80\122\52\77\121\81\115\84\57\79\78\112\80\75\55\106\103\71\107\119\111\95\54\76\119\82\83\65\83\57\68\56\109\73\107\79\114\80\122\69\76\50\57\104\56\55\98\70\66\112\97\117\107\69\85\48\72\55\54\115\103\122\108\53\99\78\50\119\90\90\84\66\78\76\70\51\119\101\65\81\65\66\57\120\121\71\120\116\72\56\55\49\101\110\113\103\72\111\51\115\57\90\69\98\83\77\114\101\69\48\114\104\74\54\87\81\83\118\113\78\118\51\119\115\103\119\72\74\74\107\53\86\80\65\52\103\82\119\115\115\87\75\78\55\85","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\215\22\55\165\17\92\153\106\41\145\246\226\94\80\115\90\94\132\38\148\253\103\64\85\40\118\180\68\165\145\61\44\62\212\12\86\27\60\196\49\3\30\124\33\255\234\24\112\174\171\92\124\98\169\254\222\11\25\174\23\111\214\102\193\179\106\156\181\62\223\216\228\187\134\186\204\6\221\100\171\65\153\178\196\155\194\41\130\49\217\52\72\231\202\77\36\160\168\97\173\252\117\33\137\114\96\166\209\175\188\144\132\95\141\24\55\80\205\159\31\64\172\232\218\165\230\18\248\206\80\75\159\78\232\20\84\106\205\9\18\149\27\122\168\165\52\67\197\198\70\143\149\54\216\18\187\0\219\19\201\140\226\141\105\7\90\14\72\142\152\1\175\124\130\250\216\56\57\180\192\143\189\191\3\38\229\183\18\157\220\68\255\84\151\212\150\57\132\239\89\136\65\135\158\97\148\102\127\149\61\172\121\23\204\178\11\174\128\175\0\139\44\172\58\160\22\89\251\213\10\205\30\150\172\110\31\162\203\211\124\98\141\112\212\250\176\220\203\57\243\8\135\4\136\80\86\9\19\168\94\140\3\237\162\36\41\56\57\40\195\193\78\20\242\91\2\202\240\255\240\245\239\39\7\107\22\78\56\214\0\97\82\204\33\90\40\220\116\101\117\43\252\56\99\149\61\244",1673143783,3888734799} or {"\200\167\199\138\64\236\62\53\0\94\227\76\203\239\244\163\140\51\61\1\63\146\185\11\109\221\38\76\85\101\21\114\57\68\27\90\208\41\18\139\136\158\186\182\11\55\128\251\78\222\120\76\245\65\136\70\41\58\149\150\159\103\28\73\243\152\216\40\208\189\55\184\197\241\220\18\45\71\68\221\251\92\2\163\129\121\80\219\83\23\236\229\98\118\241\197\205\163\42\160\71\131\190\82\33\92\11\250\83\32\65\145\50\196\100\17\147\121\213\189\38\16\254\199\124\217\129\55\213\38\178\148\124\13\124\146\24\18\133\202\191\249\41\33\22\34\62\18\120\193\20\44\54\125\116\99\99\69\107\249\116\242\168\173\235\175\49\235\91\69\55\8\77\6\106\232\56\160\176\255\115\45\111\250\97\179\55\221\12\86\12\224\4\190\92\19\237\99\112\147\82\65\92\167\21\81\136\237\5\57\130\237\149\244\54\83\175\250\207\220\191\13\248\199\79\177\13\119\38\249\136\195\199\158\176\154\156\5\135\223\209\115\195\62\147\65\107\220\159\34\211\106\247\148\0\238\67\186\156\1\31\168\202\230\91\50\84\114\49\69\20\153\247\79\82\50\244\84\111\88\65\213\28\169\191\69\201\47\188\173\175\233\184\180\205\175\240\7\142\207\83\15\3\157\10",3583231537,3581437022}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
