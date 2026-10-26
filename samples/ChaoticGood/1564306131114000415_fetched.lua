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
local fresh=url.."?retry=2d1e944073f7b291"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=2d1e944073f7b291"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\50\56\98\102\101\97\97\50\49\99\97\52\51\56\49\102\51\55\56\57\52\54\97\51\98\48\55\97\101\98\48","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\119\109\115\49\78\98\50\77\54\113\81\119\116\69\72\113\58\66\53\114\113\86\77\51\69\117\49\78\57\97\65\118\106\53\110\100\76\114\81\58\87\55\45\89\83\65\85\84\68\106\57\85\53\86\49\53\83\84\75\90\77\69\57\49\102\115\118\83\51\66\70\95\114\56\120\103\87\122\50\100\50\95\110\100\84\79\111\101\85\95\89\122\112\108\113\56\122\90\82\50\109\99\83\54\79\48\55\102\102\52\57\69\89\89\54\106\48\111\101\73\99\116\88\100\78\84\71\98\81\120\81\83\50\115\104\79\111\52\98\66\87\76\113\106\109\117\99\67\71\68\119\85\53\111\118\87\72\51\116\70\122\53\116\107\83\88\104\89\51\105\75\90\77\72\109\119\110\108\118\80\85\79\110\77\100\56\118\68\71\113\102\51\72\67\110\101\110\73\89\101\70\98\115\49\103\67\122\74\103\121\80\105\78\79\77\75\122\122\122\88\108\114\65\120\80\88\45\50\79\81\98\90\65\67\107\49\111\98\45\78","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\86\250\6\230\103\154\18\226\105\192\105\152\50\75\135\150\130\6\128\39\51\45\3\103\49\102\224\62\245\109\18\36\65\228\27\225\157\36\36\6\211\250\121\241\148\14\94\7\91\180\127\52\7\102\245\20\103\236\111\33\221\108\213\23\118\117\20\132\138\198\127\195\226\180\207\167\79\238\17\153\40\84\76\115\201\193\188\219\105\106\10\144\87\188\171\118\53\76\106\36\19\171\216\255\136\52\84\30\82\13\245\48\211\204\120\15\82\107\30\226\137\194\74\190\108\240\96\229\147\94\40\180\158\234\234\173\243\79\56\209\41\183\117\175\31\126\79\43\107\44\44\166\249\10\49\13\42\211\14\7\232\126\207\173\6\111\57\249\160\74\90\221\70\251\145\99\49\106\34\149\235\250\241\168\96\100\78\80\93\41\154\179\182\254\35\175\238\125\247\43\122\22\140\163\244\250\222\108\108\3\147\127\232\3\215\124\152\17\10\75\73\93\252\176\200\142\208\63\102\205\105\187\90\180\50\140\104\201\71\203\10\67\104\82\219\138\18\14\163\198\213\94\144\76\30\99\137\241\26\95\123\59\22\182\249\193\226\68\9\37\39\248\81\107\61\147\132\231\191\55\229\46\162\86\247\176\192\144\48\27\241\157\227\234\138\51\168\219\253\68\155\75\68\88\195\146\210",1444178266,2249417362} or {"\170\252\125\103\91\153\179\159\27\23\78\44\128\233\103\171\98\43\51\220\182\189\31\164\73\239\227\154\222\91\32\238\102\36\90\41\208\32\138\200\128\144\245\165\139\154\20\172\149\158\77\214\57\107\113\202\255\122\128\4\242\30\112\69\161\175\105\198\1\138\24\74\176\101\158\217\104\250\190\241\54\22\196\142\112\130\250\62\208\176\28\193\143\234\81\46\102\187\186\240\50\226\163\241\177\16\143\74\231\234\102\153\45\53\41\234\239\203\31\83\217\146\244\86\63\168\208\207\249\135\164\160\108\18\87\100\85\156\249\158\118\145\219\139\8\181\59\12\104\217\106\198\212\204\44\22\251\54\103\42\19\15\229\36\37\178\226\230\244\148\15\12\234\152\59\113\177\244\23\184\104\138\240\110\31\16\77\80\97\24\94\107\129\245\197\233\78\221\145\227\170\135\41\42\60\105\119\214\7\40\1\252\160\35\211\226\57\151\148\131\223\178\139\119\26\121\23\130\22\132\177\11\30\53\116\105\36\192\255\118\233\141\8\133\122\33\228\99\218\184\85\39\90\75\213\15\6\210\114\8\134\117\225\159\34\47\215\195\13\174\80\49\91\191\132\27\46\191\134\221\21\156\119\50\49\78\50\150\12\42\243\138\11\23\85\208\103\30\128\7\255\55\56\144\240",446772387,1938056353}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
