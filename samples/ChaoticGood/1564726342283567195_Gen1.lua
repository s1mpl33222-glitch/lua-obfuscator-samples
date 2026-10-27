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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=da34a2b7ea802129"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=da34a2b7ea802129"
local expected=632423
local runtime,reason,issue,pr=nil,nil,"timed out",0
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
if s2*65536.0+s1~=3646516830 then problem("runtime checksum mismatch",3);return end
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
local cs={{fetch,"HttpGet",url}}
if fallback~=""then cs[#cs+1]={fetch,"HttpGet",fallback,true}end
for i=1,#reqs do
local candidate=reqs[i]
if fallback~=""then cs[#cs+1]={candidate[1],candidate[2],fallback,true}end
cs[#cs+1]={candidate[1],candidate[2],fresh}
end
cs[#cs+1]={fetch,"HttpGet",retry}
local started,ni,ls,idle=clock(),1,0,0
local js,shut,alternate={},false,false
local asynchronous=type(spawn)=="function"and type(wait)=="function"
local function launch()
local candidate=cs[ni];ni=ni+1;ls=clock()
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
for poll=1,4000 do
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
if runtime or reason or(active==0 and ni>#cs)then break end
local t=clock()
if t-started-idle>=40 then problem("HTTP download timed out after 40 seconds",4);break end
if ni<=#cs and(active==0 or(active<2 and(completed or t-ls>=8)))then launch()
elseif not pcall(wait,.03)then problem("HTTP download wait unavailable",4);break
else idle=idle+math.max(clock()-t-1,0)end
end
shut=true
for i=1,#js do js[i].response=nil end
local function send(base,path,body,delay)
local query="?p="..gsub('{"protocol":3,"loader_hash":"\100\54\102\51\49\53\97\51\101\57\56\97\99\101\102\51\57\48\99\57\53\102\50\48\52\52\52\57\101\99\53\56","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\102\122\87\83\86\85\103\80\103\113\77\101\114\88\75\49\58\98\121\89\109\111\53\72\103\82\79\56\86\77\105\107\88\72\106\80\95\66\81\58\89\51\72\75\112\77\113\109\68\88\74\90\88\103\89\97\117\75\83\112\48\66\111\122\90\119\74\73\73\67\78\78\110\103\76\119\48\100\118\53\69\79\45\111\55\75\107\71\98\87\99\113\104\48\50\122\100\78\99\68\51\107\87\45\114\100\75\90\86\104\121\114\115\107\107\97\121\85\117\84\86\116\57\100\119\83\72\55\74\117\118\65\45\82\67\75\88\100\122\76\112\77\105\49\53\113\98\99\114\104\77\99\119\101\103\87\72\82\53\65\77\112\100\117\115\105\81\119\99\85\102\75\45\55\48\106\104\85\108\109\105\83\65\108\57\78\114\70\76\74\45\108\67\95\49\105\95\113\118\56\97\48\95\120\113\77\116\53\89\119\108\56\87\117\53\57\115\50\78\104\72\84\68\83\119\88\70\86\98\48\88\76\110\101\106\71\119\98\108\104","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
pcall(spawn,function()
if delay then pcall(wait,delay)end
local target=gsub(base,"/assets/.*",path)..query
if not pcall(fetch,host,target)and reqs[1]then pcall(reqs[1][1],{Url=target,Method="GET"})end
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
local handoff=alternate and {"\45\193\7\22\144\51\66\2\179\47\243\206\97\210\190\124\121\123\76\83\36\172\206\139\18\232\81\214\33\220\119\85\81\15\209\210\131\227\22\177\221\164\10\146\218\48\138\133\58\238\234\59\165\188\224\172\122\220\191\6\25\13\68\66\226\25\90\177\14\111\249\226\154\206\164\120\228\71\175\43\173\52\188\38\160\157\172\208\164\5\249\173\217\21\82\192\129\236\35\228\4\91\45\14\234\154\59\155\91\23\4\199\141\172\69\215\251\176\62\247\80\245\206\179\192\175\33\42\255\75\68\21\116\57\239\96\0\205\125\80\154\69\177\12\2\171\197\87\242\112\14\60\252\182\234\91\212\4\155\105\141\53\26\69\200\234\54\52\244\62\54\238\150\186\52\112\16\130\237\189\87\218\251\208\151\187\68\175\163\55\248\17\154\75\167\232\198\208\38\186\149\84\48\55\111\81\240\252\191\196\24\83\231\252\14\18\230\173\183\176\212\142\83\94\49\142\69\252\33\86\128\2\25\66\123\42\217\254\34\96\55\127\132\119\158\58\147\238\164\138\112\59\127\159\133\156\200\52\229\223\120\174\101\13\87\183\218\54\127\20\223\26\223\83\207\236\126\27\159\49\118\197\67\54\146\168\75\62\193\130\20\4\220\221\170\85\222\55\44\27\120\151\216\78\31\99\32",1774886614,2726847542} or {"\255\206\158\155\78\137\254\37\14\188\147\75\41\147\58\30\84\207\149\26\139\100\75\215\159\155\87\1\211\226\198\195\9\122\30\218\1\159\148\106\231\241\204\202\102\93\24\28\201\49\176\148\229\51\202\125\59\218\0\210\132\126\61\239\159\64\3\131\195\56\109\129\133\102\250\54\35\56\164\143\62\78\124\43\119\94\221\243\88\94\138\174\97\158\143\160\234\59\223\234\35\79\51\58\130\62\183\147\56\28\244\26\245\99\172\77\166\250\205\68\237\56\91\20\240\56\160\107\181\34\210\104\245\166\255\207\77\58\148\176\92\194\128\85\0\204\139\87\137\55\239\145\238\62\31\108\61\150\23\40\75\132\106\98\236\187\113\75\180\64\173\114\224\241\204\118\103\124\255\122\49\156\192\51\227\248\40\38\98\52\77\143\186\192\156\181\45\239\84\193\2\24\51\255\89\125\80\40\200\232\163\219\73\227\203\207\78\235\191\52\221\244\180\12\219\217\82\74\41\240\58\167\252\70\73\33\249\16\143\201\52\206\163\132\165\40\159\114\103\175\7\64\178\55\150\183\240\193\215\165\41\40\53\124\48\91\252\252\37\126\25\34\222\236\75\157\213\156\183\210\37\156\178\243\95\125\85\132\237\167\215\35\5\168\112\70\80\251\62\131\74\225\122\14\204",4141150244,2424006213}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
