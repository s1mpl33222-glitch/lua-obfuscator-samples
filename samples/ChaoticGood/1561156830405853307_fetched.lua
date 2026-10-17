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
local pinned=url.."?retry=de9a6ea0d958e234"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=de9a6ea0d958e234"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\48\103\107\85\85\77\49\104\117\106\114\90\113\106\97\50\58\55\71\119\99\104\83\65\102\85\70\76\75\74\89\77\49\82\81\65\70\118\119\58\81\110\54\49\69\48\106\71\81\52\99\54\118\101\52\79\51\122\88\111\87\65\69\122\66\54\87\83\54\65\101\49\87\68\104\99\88\67\85\112\82\120\107\69\110\74\106\120\83\117\100\70\81\86\88\114\77\69\75\118\82\100\71\52\116\50\110\97\100\95\108\67\105\113\89\110\109\88\104\71\49\89\120\65\105\119\98\118\97\110\101\50\82\103\104\50\65\119\103\73\78\118\113\120\95\86\107\71\56\104\106\87\118\55\108\117\122\66\87\122\57\76\66\72\106\110\74\95\114\75\89\70\72\70\74\51\112\108\97\49\108\106\56\55\88\101\57\116\79\71\103\78\56\111\105\118\56\53\119\54\81\85\115\68\56\77\107\50\88\110\68\101\105\111\106\101\86\82\88\74\105\73\89\86\119\119\66\100\82\54\110\104\114\53\109\52\115\111\65\76","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\220\185\198\95\9\91\61\252\13\198\193\220\49\221\54\208\71\75\77\211\216\217\104\169\108\68\44\1\160\131\107\188\34\143\51\97\134\64\75\91\140\132\254\193\84\172\17\149\136\238\75\233\18\210\232\2\178\233\235\164\209\249\40\127\156\133\255\236\56\82\64\128\17\201\58\252\15\66\95\97\89\156\105\87\81\153\198\70\238\9\201\196\122\46\96\192\43\117\210\124\207\47\74\38\113\38\168\16\38\34\36\75\82\234\176\117\35\76\37\226\86\135\187\198\138\113\221\130\10\15\218\237\214\189\51\109\63\0\46\51\154\136\247\63\169\78\222\144\119\115\66\172\154\88\218\81\86\148\139\246\139\167\41\238\9\25\56\125\17\71\90\240\66\121\150\96\243\197\193\20\146\27\67\113\86\134\254\214\120\229\118\16\224\7\52\7\55\178\11\54\113\41\120\189\184\24\82\35\152\0\84\15\104\134\57\238\46\208\114\142\163\88\65\123\5\78\102\177\229\109\247\185\125\147\58\140\199\19\222\237\82\35\157\242\94\162\222\132\233\154\18\67\83\166\8\195\239\75\182\87\32\147\230\176\229\37\166\130\97\245\48\98\234\89\66\231\17\202\204\41\7\97\74\215\24\20\67\24\1\7\159\76\229\122\230\91\234\159\124\254\115\145\236\252\20\255\217",791930903,3200082735} or {"\147\29\224\119\178\248\49\27\187\12\75\125\117\24\43\79\89\213\39\39\31\147\224\87\226\70\116\101\254\206\225\147\164\92\141\70\94\206\95\75\226\110\192\83\177\97\144\68\230\224\176\80\13\108\96\56\68\17\120\71\230\101\177\218\69\177\41\157\106\116\154\43\81\145\231\0\166\109\151\141\152\87\111\247\146\135\61\13\16\100\200\185\195\53\139\130\148\221\42\209\187\120\223\212\9\92\190\97\66\155\145\187\112\104\185\55\194\50\186\144\30\137\10\134\129\215\114\207\39\141\187\135\170\190\27\31\155\0\21\178\220\155\153\20\120\30\105\210\73\98\140\8\85\19\72\101\58\240\55\9\93\142\225\167\112\155\243\17\13\188\83\75\130\221\195\110\185\20\66\140\79\186\159\140\223\105\183\43\180\95\127\166\245\186\81\161\62\219\126\229\239\178\165\36\81\232\139\173\116\8\35\59\118\20\41\12\84\87\108\90\123\197\215\211\93\20\220\118\60\98\135\65\242\4\113\129\206\76\119\73\187\136\140\144\113\160\239\150\118\148\144\44\70\223\67\82\161\183\172\93\71\59\24\230\247\109\29\86\193\253\146\215\136\201\0\72\245\184\222\128\2\206\135\30\88\102\88\109\121\181\109\77\207\70\229\158\170\142\74\19\90\141\27\6\146",192758572,2897765694}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
