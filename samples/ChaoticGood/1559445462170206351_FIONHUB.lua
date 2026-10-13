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
local pinned=url.."?retry=4fb11c6b7c4e8714"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=4fb11c6b7c4e8714"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\102\51\101\56\53\51\50\53\102\100\100\54\48\57\53\50\55\101\57\102\55\57\57\52\48\99\55\55\55\97\57","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\74\87\95\71\101\81\90\66\95\53\50\55\89\88\87\65\58\99\78\118\108\116\86\74\69\77\120\53\81\110\122\53\80\69\107\100\113\55\65\58\52\68\105\104\101\122\105\98\106\104\50\118\73\106\51\98\81\101\55\108\107\82\79\90\56\89\106\73\68\86\110\112\81\53\65\88\51\76\88\89\114\89\114\72\87\100\104\72\70\57\102\122\81\121\55\121\121\90\75\68\57\95\75\87\117\51\55\50\122\90\122\45\89\52\110\118\52\107\70\112\74\77\117\112\79\70\103\110\49\122\84\72\119\97\122\52\88\56\50\76\86\98\78\122\82\66\122\108\76\71\45\87\65\54\75\71\112\65\116\53\57\79\51\122\81\95\57\106\100\67\45\50\111\84\83\84\56\89\45\102\49\74\107\119\69\100\110\105\115\78\90\55\120\101\121\103\89\73\120\79\76\101\114\55\99\107\104\48\80\107\67\72\48\103\115\52\84\49\109\65\116\83\72\51\98\73\78\71\45\114\90\65\53\65\105\121\111\114\71\105","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\204\163\183\141\148\247\158\187\170\102\82\170\216\243\4\52\156\211\63\48\47\232\175\255\239\98\251\141\117\9\224\7\115\182\106\199\62\85\219\106\97\239\79\66\115\247\248\228\186\130\251\116\112\48\99\207\4\9\37\254\232\192\6\154\106\15\150\208\133\56\27\122\87\201\201\72\63\242\194\165\143\99\44\250\83\166\255\69\208\216\144\111\234\208\181\219\245\4\211\214\19\78\229\101\33\177\163\237\124\100\132\46\205\45\4\235\28\74\19\105\32\74\8\31\24\75\196\83\176\206\72\87\114\147\128\157\241\84\51\216\184\122\199\171\89\234\245\1\50\102\52\3\81\166\10\127\254\180\118\128\125\125\198\221\17\45\51\225\93\70\120\101\60\209\3\3\92\74\229\86\18\47\217\152\108\219\44\247\244\221\142\250\224\170\158\12\231\255\249\99\12\99\111\99\215\160\245\4\43\215\205\186\39\82\249\15\210\40\73\49\29\55\144\194\47\106\48\210\42\207\134\246\248\253\66\228\52\137\214\208\129\192\95\128\116\60\159\220\242\70\135\255\167\228\229\2\95\215\195\40\175\5\93\123\163\210\145\10\169\123\19\129\8\174\91\59\188\120\79\20\49\106\128\189\136\15\167\204\62\83\106\96\3\52\137\242\198\107\180\39\202\45\224\3\33\97\232",3102898890,3205849292} or {"\60\59\94\43\232\219\165\229\65\162\110\156\103\1\239\22\231\174\40\212\139\128\236\46\80\158\163\236\213\160\105\243\247\105\226\145\196\109\26\76\66\201\186\249\5\205\75\23\131\159\65\221\123\80\196\175\101\45\25\18\224\179\219\219\48\113\201\187\90\34\208\57\148\134\217\112\244\231\67\102\65\122\8\167\11\39\60\176\52\22\146\26\69\61\51\24\185\41\126\88\97\167\4\127\235\211\45\53\144\153\121\164\228\21\7\181\93\89\222\43\227\134\165\235\15\251\236\239\96\58\6\64\219\91\57\167\73\220\58\137\117\58\98\245\88\216\82\14\75\128\36\244\189\83\50\14\191\66\201\73\43\242\43\157\76\136\123\91\150\50\209\2\164\132\61\32\34\114\32\116\201\181\104\201\114\89\36\97\69\0\246\101\121\46\115\220\78\197\84\64\33\107\2\54\199\35\196\231\253\138\123\254\239\244\229\238\6\16\19\57\210\100\120\99\117\44\214\233\87\2\231\41\231\186\167\233\0\57\50\5\38\212\26\186\63\42\119\86\56\37\24\56\238\30\50\176\91\22\254\237\24\53\239\232\232\73\97\15\142\65\100\9\251\193\130\68\247\122\111\231\184\159\159\21\94\50\142\79\24\33\60\251\97\254\252\239\160\242\53\247\65\226\160\245\205",1345041585,2919391963}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
