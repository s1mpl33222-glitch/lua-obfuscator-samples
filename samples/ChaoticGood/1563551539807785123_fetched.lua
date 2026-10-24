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
local fresh=url.."?retry=9ef44061aa6cf066"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=9ef44061aa6cf066"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\101\50\98\98\57\51\52\50\50\97\100\52\56\99\56\56\48\57\98\97\55\57\97\99\100\48\97\56\51\55\52\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\115\104\104\77\117\74\69\81\55\70\82\45\116\73\112\55\58\51\115\55\121\112\101\110\81\67\110\77\105\113\88\104\51\102\118\101\119\114\65\58\54\89\80\110\76\98\52\45\65\119\101\102\80\121\82\67\120\45\111\77\108\74\54\120\114\68\74\48\99\56\87\51\104\119\98\119\109\117\117\82\55\108\67\48\83\110\72\66\45\99\77\52\51\83\103\77\87\120\85\114\118\105\68\70\78\84\85\73\52\71\112\97\119\95\78\118\105\69\115\49\112\83\114\52\101\80\65\76\57\54\120\98\108\77\57\115\106\88\81\109\117\102\76\104\70\77\66\80\99\111\108\72\74\68\66\56\102\71\57\87\66\116\103\73\78\54\57\89\53\120\116\51\88\51\100\52\66\82\48\105\119\65\51\119\101\102\78\77\80\73\101\88\119\111\79\119\100\113\50\83\89\109\74\98\118\98\57\113\119\75\77\104\89\72\98\87\122\72\109\67\88\98\83\98\76\45\89\89\55\65\81\88\66\98\102\82\78\111\88\98","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\152\155\165\142\169\216\138\107\125\40\127\79\148\119\10\216\213\57\45\241\232\50\21\1\57\28\217\218\99\193\75\38\226\245\127\231\76\86\91\141\205\43\31\16\73\15\212\242\232\145\138\97\109\67\78\232\13\231\46\163\54\200\198\252\156\205\18\56\154\156\69\22\187\27\7\31\184\199\31\109\141\89\1\245\201\75\60\98\121\232\30\68\182\247\79\227\244\127\105\28\2\73\178\98\12\41\18\81\127\202\215\23\250\219\19\55\161\253\5\192\12\117\182\168\166\228\230\109\123\138\220\10\227\95\51\115\225\49\221\127\126\53\216\13\209\162\157\141\161\61\61\32\222\11\199\91\75\208\16\205\217\42\35\37\224\135\216\206\179\44\92\96\159\152\200\96\108\217\133\7\228\50\217\56\212\113\3\89\105\97\116\114\55\45\29\13\252\145\73\83\113\83\246\127\95\93\86\59\157\155\60\56\25\110\8\69\55\139\20\175\3\81\206\193\145\80\123\198\240\23\115\179\146\44\6\203\67\62\158\20\19\222\213\78\231\38\200\245\132\123\166\151\237\188\136\6\165\45\56\195\171\170\181\97\243\82\181\55\71\131\167\106\133\93\81\244\201\223\90\162\204\53\104\95\93\215\152\199\34\130\55\171\237\51\143\96\73\28\199\9\143\174\253\198\96\233\190",2862878334,77357717} or {"\232\149\62\234\219\168\22\231\14\254\255\117\93\217\253\98\201\221\94\160\90\158\88\24\80\10\224\78\44\241\36\125\77\32\78\40\183\26\97\207\61\249\114\183\140\25\125\244\68\150\37\242\100\76\21\109\38\137\138\56\212\154\82\33\85\162\197\178\156\106\69\17\212\245\41\116\115\49\220\19\133\170\201\130\75\13\43\233\19\4\194\144\192\74\129\84\175\80\100\248\30\40\147\23\233\189\241\219\186\138\141\222\166\94\183\109\132\152\170\43\160\120\33\54\233\46\51\33\45\191\2\39\108\247\2\69\9\153\110\197\74\61\67\96\74\198\3\190\192\112\161\192\31\177\117\59\102\25\103\51\64\18\35\163\80\238\129\1\120\60\7\108\90\1\192\194\24\190\178\74\110\110\85\153\142\83\216\40\127\19\206\64\209\71\59\145\174\187\188\33\54\96\18\46\79\52\40\101\60\124\189\234\32\105\76\19\162\32\143\186\212\172\113\227\78\18\163\160\0\103\122\66\75\80\124\51\183\244\215\65\229\51\105\220\97\121\123\74\194\228\170\246\209\136\55\179\9\71\228\211\56\177\163\220\38\160\52\132\182\106\19\56\14\107\38\212\6\171\87\90\54\19\179\205\25\170\227\177\28\194\92\67\122\126\177\56\253\252\190\253\35\204\153\1\135",2868530455,4063913124}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
