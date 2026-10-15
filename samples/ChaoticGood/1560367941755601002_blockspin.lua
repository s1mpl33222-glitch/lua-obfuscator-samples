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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\50\53\102\52\48\102\54\102\52\101\48\102\49\51\97\99\49\55\57\50\97\50\56\53\51\102\57\57\57\51\98\52\55\53\101\48\56\98\101\52\57\102\50\57\101\49\48\54\97\48\98\57\100\100\48\48\53\98\98\102\55\48\102\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=63443c73aa474ddf"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=63443c73aa474ddf"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\56\65\122\86\74\69\106\111\77\101\83\77\65\106\88\51\58\51\48\103\67\101\77\122\74\109\50\65\80\120\81\84\56\87\85\109\86\114\65\58\97\108\70\52\88\55\95\83\45\54\108\118\73\90\68\119\108\57\111\67\86\105\117\105\55\69\67\70\68\113\105\106\90\68\117\67\72\80\49\76\119\114\65\115\95\116\76\90\87\56\106\57\83\119\80\51\114\100\101\77\78\72\74\80\56\114\68\87\115\109\107\84\53\79\56\90\101\72\111\110\95\86\49\84\52\122\81\52\83\108\89\77\112\114\72\100\55\100\114\71\98\113\75\70\72\101\86\52\86\72\103\70\48\107\80\110\122\107\110\118\70\88\104\102\116\88\78\73\87\109\55\121\103\90\78\68\101\113\115\68\45\65\118\90\51\122\102\111\110\112\102\76\110\98\111\69\51\110\104\99\80\102\103\104\102\55\78\102\112\52\120\79\75\112\108\51\112\84\65\84\65\88\71\83\89\122\85\95\57\45\83\116\119\100\52\111\98\98\119\121","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\80\208\126\249\162\166\203\184\127\46\234\6\107\240\121\210\139\59\0\158\153\171\147\188\47\121\56\96\10\200\228\134\190\143\15\214\201\160\200\214\134\110\31\203\38\233\198\58\19\158\174\164\137\185\170\218\70\94\113\85\154\136\190\229\57\199\15\192\239\235\29\134\200\217\142\155\13\136\79\68\244\123\85\155\132\89\115\231\197\15\216\11\55\95\98\135\242\31\72\144\63\246\48\249\248\98\132\138\181\31\181\194\58\5\129\117\2\66\119\209\147\188\46\0\156\91\96\153\76\44\152\167\198\23\222\49\229\212\161\38\240\221\45\188\167\110\237\116\218\60\36\48\60\174\101\230\21\13\14\56\197\148\108\176\201\37\11\71\243\118\98\202\217\81\52\164\199\139\26\123\170\86\232\53\254\22\94\41\79\59\228\125\109\234\79\119\165\62\37\138\132\238\225\116\246\218\56\237\163\12\124\108\64\84\20\16\61\163\156\15\101\152\211\219\60\238\72\31\119\63\38\140\23\240\110\229\33\95\178\117\239\60\122\186\63\235\47\203\190\224\48\114\254\105\21\28\69\194\204\45\159\94\41\35\35\57\133\148\49\103\160\201\220\148\132\100\141\227\48\163\9\232\199\4\21\70\252\249\57\250\202\232\102\91\124\26\167\176\178\151\1\63\252\104\229\113\233",1618686013,1584554820} or {"\239\147\65\20\92\72\254\37\221\152\192\37\250\45\10\53\5\162\184\6\93\81\127\17\115\182\214\164\71\129\113\173\145\224\65\30\202\126\161\250\110\205\206\1\104\121\96\59\119\54\197\175\230\93\158\224\136\67\132\220\175\186\119\22\36\250\89\61\232\41\49\55\121\35\17\29\188\232\203\107\201\143\253\121\174\67\175\249\113\201\126\140\232\79\57\9\57\158\166\74\127\191\156\9\222\23\50\38\107\70\32\14\74\241\196\225\128\209\126\118\52\130\173\83\81\246\216\101\23\250\0\96\72\142\200\141\167\85\12\40\108\134\244\113\81\120\246\236\130\176\165\43\195\149\107\202\137\105\182\231\39\168\166\220\238\159\79\91\59\181\141\158\98\171\215\176\255\163\225\240\152\254\62\6\191\224\24\189\86\173\100\167\98\94\172\247\69\244\7\105\218\48\105\40\175\249\56\96\35\206\187\136\38\25\137\54\243\75\47\167\101\213\231\129\235\181\140\9\233\53\159\105\196\218\37\156\17\198\192\232\112\56\204\89\169\95\110\24\215\105\156\233\230\76\197\109\242\71\13\88\80\244\40\176\240\82\125\107\173\130\65\90\58\220\103\24\246\53\81\92\136\69\229\244\20\26\214\240\147\46\204\55\103\115\199\166\6\40\90\75\86\10\82\40\217",3128391175,1282237779}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
