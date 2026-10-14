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
local pinned=url.."?retry=384e1a6d342eef49"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=384e1a6d342eef49"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\52\97\101\101\97\100\99\99\54\100\51\98\98\51\48\100\98\101\50\52\57\54\50\57\51\50\100\54\49\48\51","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\48\86\45\102\52\110\113\110\95\81\87\49\77\106\80\108\58\53\86\119\103\90\89\87\55\80\100\88\100\84\84\115\65\45\112\109\98\52\65\58\113\67\74\78\112\109\87\53\80\66\73\83\53\112\50\86\103\90\49\107\68\114\113\55\120\65\104\76\79\67\99\73\70\103\74\71\114\68\82\99\114\98\113\71\76\65\79\95\111\74\88\65\51\99\116\88\103\83\84\106\57\67\50\113\50\111\50\109\45\72\112\45\112\101\80\103\49\45\109\75\120\80\85\90\66\117\119\121\101\101\117\100\74\95\74\72\70\68\53\119\85\90\118\81\121\99\69\72\45\98\97\84\101\66\78\107\110\79\45\51\99\74\90\112\88\80\78\86\54\52\95\45\82\73\65\69\84\118\116\101\114\76\54\69\80\53\79\73\86\70\114\48\68\100\49\103\52\80\119\102\114\87\119\78\81\66\116\49\107\108\113\77\95\85\84\68\69\102\52\57\66\50\101\87\82\106\114\78\82\83\68\88\82\45\79\57\53\121\99\57","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\125\74\80\231\157\210\192\79\123\198\190\169\185\136\163\200\68\113\0\219\134\120\38\199\195\91\232\35\112\208\103\140\118\81\76\94\72\34\181\137\87\35\162\190\48\209\154\212\216\11\224\217\169\162\100\159\113\90\150\233\59\162\79\145\237\31\42\71\108\21\190\72\164\124\5\112\130\182\83\99\63\224\82\231\182\34\127\115\139\43\131\179\125\54\120\59\242\9\85\92\181\48\88\8\109\150\254\109\92\117\91\209\131\8\63\119\237\9\205\233\172\231\63\79\243\71\164\27\31\145\111\137\4\139\188\203\89\78\42\52\24\8\133\151\158\117\51\89\219\66\43\193\199\237\245\108\209\168\17\42\34\209\213\94\186\250\138\108\61\51\230\181\135\143\185\100\67\59\215\198\86\189\244\196\175\225\169\98\152\52\166\221\145\83\67\62\111\135\248\233\5\34\188\249\129\230\242\69\144\84\111\8\77\230\174\143\50\105\7\132\167\209\159\134\42\160\188\16\151\130\252\168\41\198\198\221\181\100\162\19\5\106\40\202\61\113\241\117\80\158\110\193\110\129\255\116\127\187\9\185\195\84\108\119\153\81\0\66\174\209\14\226\105\101\86\181\196\200\152\129\81\36\216\125\88\107\4\1\108\108\105\24\114\242\16\30\117\148\152\118\216\243\14\98\108\159\245",1930552928,874078286} or {"\212\192\95\124\29\215\13\114\48\154\161\145\56\176\115\72\42\74\168\111\68\84\114\34\119\121\80\158\212\234\98\14\215\177\142\96\250\38\225\173\255\152\85\93\204\20\153\165\174\20\163\231\40\117\156\18\141\138\14\57\155\235\128\247\249\229\184\178\36\154\215\114\1\150\117\68\200\56\110\110\154\59\205\144\5\100\251\72\84\49\51\83\63\76\152\154\180\149\79\228\246\185\123\85\253\187\40\197\33\65\110\243\4\211\18\132\17\255\197\222\102\167\17\32\117\18\228\252\68\230\197\107\115\117\9\188\133\32\66\175\72\70\70\153\32\96\109\36\154\39\215\147\111\76\204\26\141\81\238\239\48\241\6\239\44\179\112\124\174\155\181\109\72\233\110\89\121\218\236\71\49\185\157\212\208\70\194\14\249\170\88\109\110\234\142\45\134\198\107\99\174\194\95\81\221\138\233\64\238\28\153\62\36\13\49\40\254\220\105\168\80\129\177\6\185\201\212\79\254\54\35\145\220\122\31\43\138\19\139\201\4\234\185\127\66\144\169\57\226\114\159\7\41\118\188\34\112\55\223\54\202\5\161\168\250\137\17\184\159\244\55\65\78\177\202\222\36\170\45\196\66\71\23\84\26\201\87\141\18\31\252\81\16\130\95\250\56\112\250\32\164\23\8\168\199",803853263,563503709}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
