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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=713f920abd14d241"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=713f920abd14d241"
local expected=622786
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
if s2*65536.0+s1~=2050046860 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\53\102\51\55\55\54\56\50\99\102\54\57\99\98\102\56\57\55\57\100\56\51\48\56\56\55\55\97\102\52\57","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\72\120\71\82\79\112\48\119\111\57\86\102\87\119\78\111\58\77\55\102\101\70\77\72\48\67\90\66\102\49\71\86\71\89\104\87\89\115\103\58\115\54\119\55\73\95\100\109\122\106\72\67\121\118\69\120\66\97\114\118\79\54\69\87\50\86\89\90\55\78\80\83\48\79\81\109\85\122\87\86\112\95\99\77\122\74\122\65\71\117\98\115\109\79\108\115\53\113\71\87\85\56\76\122\102\100\57\101\80\115\107\119\51\87\50\102\72\55\48\78\122\100\99\104\51\89\95\66\90\97\50\104\48\69\82\100\106\69\100\101\65\57\112\115\82\121\106\82\79\98\57\87\55\66\104\113\90\68\69\120\55\121\112\68\57\50\104\110\111\104\100\116\53\107\111\86\95\113\57\122\81\72\107\78\66\101\72\77\56\99\80\118\74\102\110\90\51\89\99\52\107\114\101\72\70\90\89\120\101\81\86\57\89\100\75\50\112\75\112\71\70\82\119\54\101\97\84\109\105\68\98\54\69\120\101\67\97\117\107\73","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\67\100\106\27\4\12\154\4\166\50\34\154\75\102\137\76\176\164\211\194\238\176\221\79\88\104\228\195\214\200\89\15\168\22\32\184\37\74\243\13\54\175\145\211\9\209\112\92\148\199\245\132\78\35\223\119\236\182\44\142\36\188\178\137\46\186\168\29\247\178\95\114\158\120\204\119\7\40\62\125\161\182\22\166\21\234\109\55\22\131\221\153\179\137\208\123\198\222\92\105\236\75\59\72\181\243\80\203\162\44\17\80\232\111\70\102\92\112\162\84\217\112\46\126\178\103\29\119\52\209\65\81\139\206\104\48\240\179\161\65\114\203\77\155\225\16\100\201\160\40\212\6\232\220\19\241\12\106\252\110\10\254\158\14\229\116\190\24\55\151\229\227\151\250\181\101\184\220\190\38\103\0\161\158\221\192\230\144\131\159\155\143\162\248\95\206\76\210\203\63\149\227\129\159\224\118\33\91\105\25\19\91\185\208\125\9\102\84\237\186\61\244\93\16\137\126\99\169\112\82\58\192\31\25\179\172\44\41\108\91\138\173\123\229\235\179\240\28\186\140\71\207\37\203\66\6\146\205\205\43\48\108\194\183\201\166\216\29\203\51\204\60\244\6\111\134\208\204\210\138\168\204\153\160\113\221\10\188\176\82\90\223\144\30\206\110\92\116\44\3\234\205\233\77\72\154\32",2505832359,2660459265} or {"\54\133\18\248\226\10\26\116\75\23\196\11\8\176\104\9\101\201\226\8\91\184\25\244\234\84\30\102\158\97\114\205\247\115\148\17\243\72\162\43\170\98\75\11\86\131\206\137\191\170\184\148\203\125\47\61\238\231\203\140\175\84\170\188\113\206\46\120\98\73\134\194\174\246\48\132\99\246\235\19\166\33\103\226\101\86\10\85\123\179\57\104\231\47\251\5\103\45\103\173\231\89\13\223\23\216\197\17\249\11\214\170\194\69\169\180\200\116\198\134\159\184\196\166\237\1\25\197\114\123\186\23\7\100\25\79\229\57\92\131\145\59\32\129\249\119\203\171\43\123\142\84\210\113\200\9\220\164\146\175\184\246\20\113\101\210\127\139\253\253\166\178\5\133\159\82\17\14\48\119\60\165\184\233\36\186\211\166\55\137\132\134\40\217\247\46\126\132\237\195\51\86\42\116\170\191\9\220\245\50\223\105\105\141\76\247\40\0\85\64\247\87\192\201\38\18\84\63\12\42\185\156\10\216\97\210\158\22\176\166\221\134\144\195\134\157\175\232\46\233\221\227\41\12\18\230\244\28\101\112\64\92\154\168\222\37\253\240\187\167\209\170\70\24\204\161\151\104\81\159\59\204\52\2\143\111\58\169\201\122\215\96\22\106\116\2\155\60\174\72\110\24\217\248\173",3615315279,2372166928}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
