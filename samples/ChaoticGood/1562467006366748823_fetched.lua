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
local fresh=url.."?retry=96d4cfbc53357506"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=96d4cfbc53357506"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\51\49\102\51\54\51\50\55\102\57\56\57\99\56\54\54\53\52\56\57\50\97\98\57\56\57\51\53\99\57\100","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\66\86\102\104\48\115\115\51\99\83\53\50\66\117\71\80\58\66\109\108\66\87\107\79\71\57\111\67\80\97\103\98\105\87\56\90\52\56\119\58\113\111\110\100\86\101\74\83\50\72\90\116\87\57\117\115\73\80\98\110\82\119\95\101\83\79\97\108\102\89\100\89\114\99\71\53\104\98\99\107\87\115\102\114\78\50\111\117\111\120\50\53\72\103\109\72\55\68\76\115\108\114\53\74\100\110\110\105\88\76\83\52\88\100\85\57\51\112\72\104\70\105\84\73\100\89\80\118\120\82\115\70\115\105\89\82\103\114\95\114\87\113\111\113\112\111\119\53\49\106\72\103\78\69\106\119\116\83\114\108\103\74\120\90\78\99\55\121\105\55\71\99\71\74\120\111\107\113\67\122\121\121\100\86\67\122\82\115\114\69\121\55\104\74\110\90\115\50\112\52\84\86\113\83\69\101\56\82\45\106\117\114\90\112\49\67\86\45\81\98\108\88\52\121\65\51\119\66\106\103\77\87\112\84\79\85\66\108\120\106","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\136\81\147\241\63\80\248\242\146\26\63\227\4\17\195\171\123\164\166\105\11\249\4\245\98\189\110\246\105\248\50\250\166\28\101\229\101\101\118\106\200\149\36\7\60\213\83\153\227\167\8\117\13\188\180\159\60\98\101\210\56\183\21\134\204\102\35\87\60\55\53\224\117\164\92\76\178\136\15\94\149\73\218\220\190\111\39\174\113\106\62\185\73\47\29\69\236\169\3\177\1\144\64\40\20\29\241\42\193\153\150\220\13\28\98\222\212\253\110\188\42\11\107\199\200\98\74\185\66\88\107\241\195\148\121\59\80\103\162\231\48\163\93\96\115\216\102\108\236\252\91\71\144\17\178\84\91\132\227\208\172\207\110\244\135\219\17\116\159\39\167\124\199\129\22\71\87\166\36\121\125\74\237\17\125\177\102\222\111\108\194\208\64\224\154\24\191\183\212\48\169\72\232\124\236\161\153\33\109\44\197\202\8\76\73\138\93\64\39\193\246\83\21\231\69\127\37\211\46\41\55\235\129\79\174\115\58\224\171\228\22\224\49\49\145\192\225\139\246\94\245\151\20\84\25\29\210\5\18\234\5\40\202\153\204\253\233\85\25\102\194\133\79\55\77\247\199\81\164\15\154\64\142\194\159\96\213\112\192\15\86\241\79\3\67\63\47\205\93\223\64\85\159\138\230\253\68",2820384684,283665669} or {"\52\21\7\216\93\63\67\216\218\110\254\55\251\232\24\4\25\231\188\241\64\160\223\44\245\205\185\137\38\163\25\115\114\53\196\153\3\228\25\89\214\141\49\30\44\161\242\151\216\166\155\191\150\191\104\101\206\206\202\81\178\174\98\166\28\46\164\203\44\210\72\251\171\163\141\211\223\156\156\17\14\104\132\143\180\56\74\134\228\105\120\238\135\44\244\78\212\192\103\213\53\215\178\153\191\138\13\223\42\161\234\137\122\136\190\166\181\195\6\216\17\240\112\96\130\159\128\48\11\252\227\208\65\239\95\234\193\135\180\195\175\71\19\157\74\222\185\120\47\129\154\74\212\148\84\139\167\193\4\108\149\240\93\111\106\168\104\143\210\204\28\77\146\139\127\16\4\249\242\25\175\254\77\125\28\205\240\129\101\123\185\48\73\184\126\19\30\19\22\111\164\196\229\213\254\95\1\129\195\41\182\247\21\122\93\134\64\160\70\187\119\222\5\110\122\95\227\2\191\71\192\220\201\58\106\175\97\228\159\30\73\105\174\168\130\220\3\232\16\130\12\100\82\163\202\66\9\181\223\117\161\83\227\39\212\75\51\174\237\162\98\117\243\84\96\139\250\186\217\88\45\106\77\137\57\142\67\139\38\119\23\120\189\22\174\164\52\53\249\127\150\152\206\255\100",2187837896,9135892}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
