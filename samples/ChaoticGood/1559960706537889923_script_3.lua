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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=3e388147405187c6"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=3e388147405187c6"
local expected=572639
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
if s2*65536.0+s1~=2292470616 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\55\102\48\56\51\51\102\50\98\101\56\56\99\99\97\57\48\57\50\100\98\100\101\101\54\55\97\99\57\100\57\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\115\82\51\106\102\49\45\65\121\49\51\55\55\122\119\56\58\111\85\119\45\95\65\100\54\65\55\121\87\84\117\53\114\80\98\120\103\56\65\58\101\74\56\116\75\70\85\56\95\70\76\99\79\88\98\56\76\85\98\53\54\101\83\103\53\90\101\114\55\70\101\105\112\55\118\82\55\120\82\49\84\107\113\54\54\89\111\50\80\105\51\68\82\116\70\86\100\107\83\118\104\99\68\89\90\116\98\78\100\117\66\80\55\109\111\88\81\101\87\52\108\106\120\52\98\116\104\82\115\65\56\85\97\72\76\82\90\80\51\56\53\74\113\75\83\52\81\103\71\103\101\104\52\45\67\54\74\121\113\115\54\104\82\70\83\121\65\100\65\52\89\119\74\49\103\112\74\82\45\97\89\72\87\45\104\73\89\87\57\49\81\85\81\48\68\104\118\118\49\75\85\88\50\55\54\84\98\110\69\87\88\113\78\53\70\57\102\121\116\78\122\112\104\101\105\65\72\70\81\105\100\103\122\83\50\102\73\65\75\87","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\184\174\244\186\129\230\106\244\216\108\210\80\122\237\63\164\164\184\234\21\28\25\46\66\204\227\28\59\158\76\118\17\86\48\121\108\121\228\150\51\93\3\235\128\151\127\176\45\146\214\7\121\116\108\82\233\154\240\188\94\189\70\242\70\193\85\77\51\54\143\118\230\19\193\119\204\25\176\87\244\83\243\14\76\26\224\240\242\21\97\100\167\11\188\217\206\180\73\150\150\70\58\107\206\214\61\80\25\30\215\125\209\196\109\25\198\143\120\84\96\229\155\250\75\52\62\9\52\4\198\144\184\25\134\252\16\128\244\88\164\37\108\12\137\69\176\218\248\91\127\87\233\152\49\119\244\220\126\50\153\113\94\64\34\107\194\203\204\224\241\135\7\143\18\129\99\19\136\13\117\187\4\199\164\110\52\26\158\207\81\217\97\217\86\163\48\153\131\232\54\151\224\80\153\21\69\122\111\209\162\182\78\117\37\216\199\11\204\51\62\37\191\149\240\219\177\193\212\170\149\197\190\4\160\194\173\46\70\136\167\48\161\0\146\209\132\82\15\135\214\81\49\180\151\92\53\167\135\38\126\97\156\11\137\192\201\23\163\55\86\62\53\227\162\242\231\48\83\33\112\226\89\69\170\156\142\170\91\229\171\129\88\187\112\99\187\200\161\240\7\114\250\139\241\168\79\186",3382965002,266887295} or {"\226\119\99\59\67\213\139\215\34\212\67\11\92\182\188\252\74\29\7\100\27\147\30\175\111\126\244\206\40\61\189\74\58\204\37\200\134\114\74\138\27\81\121\55\186\122\120\40\111\72\223\137\175\59\113\23\127\64\222\62\71\253\25\139\200\163\73\72\154\254\251\54\72\251\134\149\154\80\142\96\93\25\33\146\37\125\36\104\73\157\32\100\93\193\194\83\196\140\53\38\85\141\215\227\157\172\136\214\220\61\115\60\37\234\183\178\46\82\6\195\11\102\131\118\48\72\108\145\6\222\143\152\31\133\66\49\34\3\171\77\235\100\186\173\143\198\69\90\33\82\212\65\141\253\247\39\195\104\120\210\153\253\25\183\4\48\228\11\123\82\94\5\195\190\103\226\115\117\184\69\199\115\249\185\196\66\119\99\221\215\44\79\160\210\242\241\166\72\105\117\38\59\149\107\221\52\123\52\164\182\82\24\14\212\94\169\97\139\214\209\167\178\111\119\133\45\187\154\142\139\17\114\142\208\10\70\11\22\60\104\25\11\193\35\232\80\159\3\226\215\202\252\154\187\70\8\4\235\51\127\165\75\239\114\184\221\181\233\176\29\65\64\51\138\84\68\93\47\136\175\243\188\171\5\5\160\138\96\143\237\253\99\119\4\66\117\242\56\253\139\102\217\241\42\232",1496432528,4239155854}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
