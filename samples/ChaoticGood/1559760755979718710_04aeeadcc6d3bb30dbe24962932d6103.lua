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
local pinned=url.."?retry=d4a056a9e816472b"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=d4a056a9e816472b"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\52\97\101\101\97\100\99\99\54\100\51\98\98\51\48\100\98\101\50\52\57\54\50\57\51\50\100\54\49\48\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\81\68\51\45\101\87\51\75\116\120\118\113\48\98\113\84\58\104\57\68\66\55\112\68\90\116\88\48\85\104\55\76\85\115\48\54\77\56\81\58\75\119\45\52\77\53\54\72\121\85\68\113\66\70\97\66\101\119\108\50\54\54\51\115\81\65\118\82\106\119\89\104\51\104\100\74\86\110\52\56\45\76\69\116\107\103\97\118\109\122\81\74\88\102\87\115\108\75\110\111\53\89\71\67\104\71\102\99\68\67\117\74\89\73\87\112\86\73\95\110\74\65\86\68\118\88\71\75\113\45\85\108\121\50\105\69\99\72\49\97\51\87\68\111\99\87\82\71\112\122\80\86\73\115\119\72\95\88\54\114\52\97\101\76\117\81\65\112\50\48\88\81\65\107\65\71\119\79\105\67\78\57\89\55\76\88\67\68\79\114\105\78\71\103\114\77\81\75\103\48\120\48\117\56\73\78\71\78\77\98\72\106\117\111\89\107\57\122\100\95\102\50\45\106\53\84\67\82\83\95\109\50\89\78\52\80\100\78\79\50","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\170\144\107\183\167\39\9\55\126\19\232\129\102\159\161\91\158\201\152\169\185\140\241\50\81\42\33\199\84\58\239\7\181\26\163\95\236\184\192\245\88\241\150\167\207\199\113\129\60\98\176\98\21\127\174\163\63\19\14\183\98\185\197\168\212\237\114\234\63\13\182\24\43\149\227\142\124\215\92\87\194\156\40\85\25\85\171\209\184\83\164\63\166\112\92\38\94\27\193\51\174\247\105\73\164\227\113\61\203\51\131\161\155\67\227\155\181\164\50\248\255\12\83\95\76\156\91\197\138\24\212\167\77\78\24\185\93\38\208\65\73\112\89\176\58\138\220\146\232\120\135\81\133\77\202\35\31\181\158\171\102\148\137\44\138\151\125\49\72\69\54\54\77\11\229\245\174\46\175\169\243\1\17\81\228\165\143\204\224\208\32\159\221\49\50\160\134\238\30\91\34\177\86\232\110\237\207\107\98\95\195\151\1\23\12\203\47\196\172\224\140\139\113\79\209\28\169\26\41\146\122\221\192\234\224\57\218\60\87\210\200\254\187\169\185\238\81\10\95\44\64\4\253\51\190\147\31\10\234\42\59\146\27\34\170\145\117\166\198\188\66\42\186\89\102\252\136\59\66\224\231\24\243\47\58\220\165\145\248\199\142\194\26\176\218\65\80\65\24\149\248\251\105\195\154\71\116",2329290425,3706413119} or {"\210\27\67\130\86\7\129\199\187\153\70\48\200\217\54\241\173\69\221\197\247\114\3\192\102\176\22\194\188\206\192\172\231\61\156\0\141\6\145\11\50\80\87\179\237\60\173\20\56\120\198\62\120\107\63\124\73\73\127\78\122\10\13\178\106\218\59\107\90\3\47\117\185\128\169\94\48\21\178\230\105\244\53\47\76\134\71\162\207\97\60\229\8\197\105\102\158\20\93\171\40\151\205\198\18\112\120\154\74\102\224\71\94\42\144\176\191\193\167\11\61\166\35\93\140\37\238\212\228\114\135\135\237\139\115\246\70\185\154\220\143\170\214\78\121\93\119\242\36\178\192\65\160\197\175\62\150\11\80\214\221\139\147\67\114\31\143\51\191\86\106\21\83\61\57\196\150\231\58\194\25\171\108\210\226\94\36\142\228\71\123\254\10\245\177\11\14\243\89\229\237\145\103\174\12\65\230\243\182\140\228\204\143\216\200\203\199\66\213\84\12\42\38\189\14\130\43\32\69\146\4\39\16\4\37\245\232\13\246\8\133\230\28\249\213\135\34\46\38\80\29\31\222\234\79\178\136\142\16\88\118\164\210\211\10\41\255\153\78\214\132\39\55\249\186\57\242\69\7\31\56\7\23\110\156\85\109\144\123\247\207\247\227\71\52\174\241\109\252\164\171\129\235\109\183",1291877374,3395838542}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
