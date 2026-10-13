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
local pinned=url.."?retry=76adba0c11d9d01c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=76adba0c11d9d01c"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\51\99\53\49\99\51\49\48\98\56\53\54\102\57\102\57\52\97\97\97\56\100\53\98\48\57\57\98\51\102\56\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\57\51\97\53\90\55\106\89\72\76\45\122\108\87\56\80\58\79\49\118\103\121\50\79\112\73\65\53\55\101\85\111\109\106\80\54\99\54\81\58\90\82\80\74\88\72\101\89\105\101\78\105\103\105\120\104\100\88\82\112\50\95\79\79\121\95\112\111\107\48\108\118\83\113\65\79\97\52\76\56\76\119\54\71\55\65\98\101\77\115\57\51\104\72\84\104\50\55\73\74\104\115\90\100\80\73\65\78\77\79\52\57\111\56\121\106\116\52\107\83\122\71\78\75\104\88\99\104\112\114\110\86\108\52\86\82\84\86\113\95\112\51\90\49\97\83\53\103\89\98\119\95\120\107\97\79\122\54\87\118\68\45\50\83\70\71\77\98\53\56\85\115\100\87\49\107\104\68\101\74\70\73\85\51\56\115\102\112\45\101\55\55\100\77\80\49\45\69\69\74\100\116\112\79\65\82\80\57\65\71\75\80\77\55\89\113\90\56\86\115\50\65\105\49\112\115\86\65\78\111\112\116\107\116\101\52\115\50\50\57","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\71\168\219\106\95\19\176\49\57\66\189\179\152\230\102\42\169\196\34\38\176\118\39\195\134\223\188\12\179\102\242\34\145\40\87\152\251\53\210\84\236\234\28\15\88\25\161\164\142\231\236\240\34\30\80\255\87\154\204\199\205\154\253\113\70\13\206\140\231\142\87\137\191\156\167\28\224\206\121\83\255\176\61\96\120\112\157\197\83\155\103\184\248\177\155\219\52\122\2\114\31\103\112\131\116\114\126\98\254\42\125\43\255\172\83\207\8\128\96\164\237\111\197\180\143\95\60\89\233\6\233\199\47\119\120\184\246\154\157\62\177\237\128\142\156\78\148\176\81\181\224\41\24\136\209\93\165\22\165\125\200\48\47\81\217\136\222\90\118\99\2\189\74\80\149\239\70\150\210\0\250\13\164\36\153\166\190\221\95\65\158\158\156\4\43\229\229\39\175\206\70\83\161\9\15\189\130\51\117\134\99\8\192\238\226\242\24\57\194\148\31\80\216\148\63\146\143\31\127\134\22\1\96\43\90\193\29\161\83\28\34\61\220\196\46\183\121\140\24\81\192\225\83\14\57\140\184\16\137\215\182\169\36\85\209\92\135\124\100\78\209\151\208\3\32\171\162\108\192\150\135\203\31\111\45\16\99\153\186\14\177\185\198\33\242\81\231\213\46\42\96\166\185\4\229\188\158",2613797972,3867828295} or {"\168\208\104\211\150\226\209\55\185\111\193\6\197\18\234\49\9\114\196\227\192\213\229\120\94\199\55\24\68\224\7\86\227\163\168\115\129\122\194\207\217\66\33\109\33\142\91\121\156\18\49\101\72\189\98\12\40\252\236\34\138\191\117\204\195\72\22\163\9\105\0\174\254\231\239\77\201\110\153\96\3\59\242\31\62\1\114\80\94\252\227\98\159\237\182\122\36\198\179\100\170\198\178\23\78\73\190\152\109\51\254\210\14\148\197\187\188\16\219\206\184\242\111\163\66\188\82\70\152\221\195\91\20\229\176\97\161\70\48\111\128\101\144\96\169\44\214\240\93\226\157\225\32\148\23\145\1\116\66\40\106\19\245\172\5\23\12\169\19\230\51\242\112\94\36\213\237\254\14\124\29\158\109\192\227\22\17\55\209\154\84\110\22\26\91\123\135\193\81\184\6\101\49\9\117\224\201\230\251\91\90\38\203\139\68\200\150\213\183\195\104\21\233\143\68\147\44\33\64\247\111\48\244\46\15\183\113\167\217\194\74\67\39\75\46\6\23\116\168\61\93\177\134\141\161\166\9\28\71\210\58\117\254\85\172\62\6\203\36\202\144\217\181\170\84\250\125\242\56\27\142\217\6\253\185\68\50\231\126\80\45\61\159\252\15\244\92\76\173\171\130\235\247\122\189",2409796716,3565773398}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
