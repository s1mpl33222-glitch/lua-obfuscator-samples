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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=e8bac992fc511b90"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e8bac992fc511b90"
local expected=617906
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
if s2*65536.0+s1~=2497301977 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\56\55\51\51\56\55\97\98\54\55\56\99\102\49\100\97\98\97\102\99\55\56\97\49\98\55\53\52\48\57\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\54\118\107\66\49\65\53\107\104\68\87\99\68\100\100\90\58\111\102\122\98\118\80\56\76\108\54\102\86\108\66\119\106\107\114\55\71\115\65\58\53\89\115\110\84\103\75\76\116\80\108\76\86\113\71\55\100\117\76\118\105\53\52\122\117\57\51\68\114\120\108\76\73\107\53\108\80\83\67\82\103\69\78\54\78\81\111\114\107\111\120\116\111\76\115\55\72\115\115\78\69\70\98\118\53\57\83\121\101\70\84\77\117\69\71\110\81\121\45\115\119\108\51\83\52\87\49\113\84\95\120\84\57\52\90\77\72\52\107\90\50\112\115\104\103\84\103\114\88\106\114\82\101\111\109\69\72\105\110\104\57\115\69\67\55\83\86\87\101\55\105\80\76\80\87\95\118\79\56\85\102\70\112\114\83\118\79\88\119\111\120\87\87\78\105\122\107\117\95\104\116\75\56\81\45\105\121\120\76\50\81\104\95\74\113\72\81\103\111\73\76\84\71\71\68\99\84\90\54\78\122\111\87\101\99\89\68\97\116\53","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\200\87\46\82\28\104\9\235\186\39\8\184\76\25\230\209\237\113\221\246\252\88\30\62\255\79\1\35\102\221\6\55\68\37\167\140\220\146\173\129\166\81\117\131\21\50\135\7\236\148\251\249\125\188\179\238\64\220\123\145\77\6\102\211\20\124\236\29\216\203\237\15\159\172\181\26\119\155\41\143\202\141\201\191\198\149\183\61\88\123\121\157\195\148\198\191\28\8\7\119\165\16\240\31\42\204\95\89\75\138\97\217\237\35\52\37\94\19\238\177\69\25\202\58\88\82\237\136\189\190\184\231\18\191\67\96\205\204\143\33\187\246\10\106\34\168\98\10\116\142\83\218\121\107\167\201\162\189\56\228\120\170\223\89\24\165\157\214\244\71\232\173\129\53\45\65\12\214\246\175\156\90\242\24\121\231\34\56\71\23\180\153\194\178\176\240\175\47\66\248\94\95\131\192\76\178\79\75\103\5\94\4\114\240\39\176\59\141\24\72\64\48\127\6\17\61\69\253\69\147\196\28\13\138\104\118\139\246\117\96\195\59\182\169\111\91\4\232\1\179\63\65\231\225\185\226\92\164\139\173\214\96\123\52\30\14\198\221\23\237\185\59\119\198\30\101\186\105\206\37\177\169\40\145\174\246\30\224\137\59\189\253\8\34\88\118\134\125\190\7\4\144\93\214\216\252\47",3493223765,2910151859} or {"\78\133\60\234\79\239\107\6\134\165\151\151\34\132\120\225\127\92\255\21\161\105\22\82\81\230\80\104\106\94\216\14\12\130\242\113\28\40\140\75\113\72\191\4\249\94\140\43\14\66\228\75\159\145\162\229\227\210\117\101\148\96\135\128\235\125\245\229\182\66\155\254\251\133\24\57\92\43\54\148\147\240\191\151\158\113\236\137\154\176\149\82\205\120\32\232\47\195\80\34\223\249\139\205\149\215\100\13\54\179\189\26\145\169\197\213\147\209\62\248\26\12\131\95\119\215\223\65\26\218\194\20\104\77\206\179\38\77\68\151\45\248\48\211\87\159\124\218\69\19\69\37\19\63\8\220\154\148\124\187\109\21\89\193\126\80\179\65\91\85\251\254\155\210\94\156\16\122\255\192\151\67\111\230\243\237\134\128\216\255\134\248\183\189\22\75\249\202\136\95\41\217\221\222\181\82\134\203\108\222\38\210\111\19\204\189\17\59\241\39\187\215\93\193\229\183\220\191\159\197\232\237\254\51\194\207\85\188\236\198\205\124\227\139\17\127\136\77\123\5\30\190\237\19\223\3\82\24\107\193\9\176\252\34\154\211\43\241\157\64\193\152\211\193\216\197\215\29\99\79\229\118\214\38\169\137\242\55\43\246\37\183\133\139\91\56\85\19\10\145\8\115\102\189\51",931905271,2607834818}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
