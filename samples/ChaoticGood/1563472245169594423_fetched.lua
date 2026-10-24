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
local fresh=url.."?retry=f86ae1d4f84bfe3e"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=f86ae1d4f84bfe3e"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\49\57\57\52\97\49\98\53\53\48\51\100\50\53\50\54\99\49\100\57\98\55\99\100\55\56\56\99\57\56\50\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\71\109\97\111\99\81\86\79\68\53\82\122\120\55\120\70\58\107\109\114\97\48\116\55\112\110\85\84\74\90\97\99\100\106\81\115\72\116\119\58\84\76\97\101\65\67\113\84\78\74\113\110\83\83\99\114\107\83\70\108\104\112\53\55\80\88\78\71\97\66\116\51\66\87\53\88\103\117\53\73\67\116\84\113\52\65\120\117\99\104\115\122\90\102\95\111\78\121\107\116\69\53\107\102\86\80\113\88\88\56\97\67\98\76\115\77\112\98\80\97\119\57\45\102\54\113\69\74\103\78\68\66\67\114\51\86\79\69\81\54\70\79\107\88\118\102\117\77\88\72\45\89\57\53\119\75\65\68\111\90\98\110\83\48\102\77\89\90\68\121\69\107\117\105\118\101\87\109\71\106\108\83\97\122\81\121\78\45\122\69\49\87\89\80\48\103\80\103\101\77\87\109\90\69\100\74\88\104\81\95\80\122\77\56\120\48\57\72\111\82\45\49\85\70\98\116\107\110\114\103\121\78\116\102\110\111\121\80\80\77","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\252\230\204\150\173\182\115\0\125\182\10\197\92\84\36\247\6\61\8\193\94\126\144\17\23\110\22\253\110\235\123\84\7\14\25\147\143\77\21\49\157\41\202\26\122\210\94\103\224\0\188\146\197\212\7\223\122\218\209\199\206\8\245\108\78\119\1\216\50\158\86\158\11\121\130\212\201\228\90\229\247\26\224\200\191\2\153\158\27\98\107\79\162\26\17\13\68\77\109\104\92\77\49\213\142\18\70\167\101\3\154\148\120\131\45\75\211\98\169\154\111\96\49\13\131\7\169\120\103\39\120\35\46\176\160\187\12\57\108\201\160\188\79\86\249\25\169\51\19\128\243\146\112\13\130\167\210\188\108\51\242\212\162\237\253\137\55\1\87\48\79\138\15\217\227\160\191\170\139\152\161\69\242\191\144\30\240\253\254\70\193\95\156\138\36\154\131\139\21\193\233\117\86\229\120\115\219\202\169\188\224\232\37\86\171\195\244\37\209\111\139\201\39\231\72\232\183\42\77\71\71\49\71\190\10\60\254\91\214\185\190\253\227\8\100\168\49\100\114\115\203\43\37\155\229\237\28\206\126\232\107\102\77\222\88\107\10\129\100\182\217\126\129\123\107\96\105\85\169\28\240\141\237\102\120\147\10\79\232\96\238\141\108\18\138\130\222\225\103\176\193\113\145\185\148\134\175",1836727622,1599628322} or {"\157\129\90\98\104\96\206\40\8\231\6\222\100\247\243\206\152\42\213\79\60\19\202\9\240\134\33\125\27\198\91\42\47\236\171\110\148\193\6\222\109\172\95\133\252\118\5\30\235\225\1\10\173\184\78\252\69\130\221\235\235\249\181\45\14\159\148\31\85\41\227\175\140\208\44\72\218\240\112\171\167\191\93\229\86\236\74\29\248\54\58\184\68\57\123\198\119\3\28\221\113\61\69\48\180\120\189\57\65\69\4\57\229\249\160\49\54\185\165\6\40\251\74\141\219\57\208\222\158\150\159\236\169\83\208\53\122\103\251\15\219\74\8\216\170\225\205\116\137\234\140\60\135\146\18\196\82\234\242\191\252\25\3\41\214\24\101\17\221\80\103\229\113\205\125\218\120\26\227\201\141\205\252\13\99\135\249\39\226\59\108\5\97\11\92\66\219\68\168\120\160\92\223\178\208\113\13\181\182\168\143\60\39\131\91\241\0\204\147\162\56\208\20\81\235\237\110\176\28\38\29\175\155\36\177\124\13\238\156\26\3\163\31\12\147\50\199\187\54\84\113\146\127\126\245\178\37\232\152\246\120\97\221\107\68\141\120\116\47\150\132\64\61\28\34\166\215\212\181\221\176\29\71\201\254\162\131\236\112\183\105\177\8\123\51\101\66\214\250\149\47\15\40\46\199",125306967,1310156337}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
