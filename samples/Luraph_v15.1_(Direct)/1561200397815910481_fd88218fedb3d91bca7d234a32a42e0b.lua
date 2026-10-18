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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\97\100\49\49\54\50\57\51\52\49\50\49\53\56\99\48\100\52\54\48\97\48\97\54\49\99\99\100\50\51\54\56\102\52\53\50\49\54\53\56\49\101\52\54\49\56\99\51\48\56\56\99\97\102\49\54\53\53\50\53\54\53\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=c26fd1127c6dee98"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=c26fd1127c6dee98"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\100\56\56\50\49\56\102\101\100\98\51\100\57\49\98\99\97\55\100\50\51\52\97\51\50\97\52\50\101\48\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\120\98\50\70\76\107\51\48\57\49\77\118\70\74\88\73\58\98\117\108\88\115\97\117\104\57\84\52\74\66\78\121\99\121\120\86\73\48\81\58\86\80\65\109\68\100\70\105\87\90\87\90\98\105\112\83\105\45\53\49\99\118\120\102\77\108\106\104\115\68\55\74\87\66\98\89\89\115\113\101\50\90\78\74\116\90\71\115\105\68\56\45\95\72\100\50\88\45\79\78\48\71\68\112\82\88\89\99\105\89\53\57\102\113\87\103\95\51\68\102\88\101\69\95\45\48\100\121\118\78\67\69\90\108\48\67\75\111\118\116\81\107\57\49\52\67\74\107\99\99\55\54\97\114\122\86\76\79\72\87\89\66\98\82\109\56\108\102\106\52\90\100\75\119\106\87\76\82\99\75\101\105\110\70\66\90\53\77\71\121\122\57\50\49\66\98\121\102\73\98\73\69\109\106\97\52\71\77\116\104\99\69\107\110\83\114\108\98\55\106\57\45\105\97\71\101\52\105\67\72\71\104\108\121\95\70\87\85\95\102","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\120\180\18\32\62\230\82\186\56\188\6\98\215\44\234\165\29\244\174\132\10\8\152\102\41\188\70\89\188\229\234\150\98\56\190\172\104\171\175\4\6\46\88\75\211\55\54\158\133\106\105\12\174\206\40\61\181\120\147\153\239\105\16\122\10\109\65\186\92\5\119\97\155\163\20\238\123\61\162\81\63\30\217\84\230\163\93\173\209\211\46\159\219\7\228\32\182\231\238\153\239\41\33\216\57\220\233\85\68\11\35\2\43\237\42\127\136\123\225\86\87\103\215\230\127\83\113\8\78\180\70\137\130\174\165\0\15\202\71\153\139\153\190\213\185\58\51\108\66\130\228\171\90\53\42\167\32\236\199\54\188\226\237\16\242\190\40\145\132\113\102\35\185\214\127\45\243\186\114\93\179\15\218\71\164\247\50\112\186\25\180\114\170\236\53\134\161\243\92\188\213\145\255\61\27\98\192\44\16\197\135\190\98\149\61\178\99\214\207\225\193\53\18\32\154\8\160\79\128\36\245\70\42\22\158\216\162\235\196\84\182\197\234\57\134\176\79\123\246\224\62\155\114\131\126\28\174\252\104\88\170\196\229\109\208\28\16\87\147\52\175\70\183\163\3\72\191\169\180\76\97\83\39\97\45\111\107\12\65\179\8\192\180\14\114\174\70\29\132\91\169\98\9\101\204\142\6",4059359557,3121963553} or {"\117\46\177\202\151\85\72\248\75\29\107\45\187\20\32\49\220\234\173\66\8\77\197\122\231\139\41\0\80\101\161\208\22\7\62\94\174\142\217\132\141\219\243\85\9\231\164\236\206\150\10\112\198\213\104\207\248\191\244\136\156\195\205\11\145\57\5\44\242\149\254\210\234\210\43\3\109\209\103\157\178\175\197\241\4\23\74\160\85\51\81\115\96\76\168\235\213\218\191\91\128\244\169\202\230\201\116\112\141\129\231\38\136\117\165\22\69\112\7\137\141\165\126\225\238\209\233\152\190\23\95\175\118\244\60\190\134\5\18\59\156\118\239\154\108\149\128\209\170\201\140\121\40\76\80\62\185\207\170\119\8\247\15\142\65\143\30\120\92\160\19\185\39\219\122\51\206\200\119\13\228\56\155\7\186\34\103\126\51\251\20\243\219\79\172\79\197\176\79\117\240\129\29\104\150\140\208\131\26\73\57\98\39\250\10\62\8\112\135\85\212\100\47\168\231\40\198\202\249\252\106\88\18\71\111\11\214\191\46\121\227\217\12\5\88\212\63\221\110\98\179\14\79\67\202\216\179\71\144\209\2\145\94\2\203\213\232\238\15\211\164\215\81\17\178\161\39\74\64\192\138\196\243\227\196\211\147\171\113\45\171\231\194\100\64\22\32\110\182\202\113\187\213\142\123",4250558505,2803917872}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
