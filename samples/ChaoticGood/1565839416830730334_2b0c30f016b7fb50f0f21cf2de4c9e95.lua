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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=afae82f229b9127c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=afae82f229b9127c"
local expected=627508
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
if s2*65536.0+s1~=368677546 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\98\48\99\51\48\102\48\49\54\98\55\102\98\53\48\102\48\102\50\49\99\102\50\100\101\52\99\57\101\57\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\103\74\98\111\65\77\71\101\108\83\88\52\101\83\70\78\58\110\49\85\85\72\83\101\110\56\97\81\109\97\111\102\98\76\78\86\77\54\65\58\87\66\90\80\86\85\107\75\72\104\49\109\105\105\106\69\89\107\69\114\66\77\119\82\65\84\106\54\78\113\110\52\122\104\122\77\53\107\119\85\71\116\121\75\77\109\75\106\98\69\109\113\45\120\118\70\121\76\89\87\70\49\98\109\110\67\121\99\120\95\50\75\100\109\107\88\49\53\75\84\66\110\71\120\56\112\103\101\88\72\95\122\83\114\83\119\101\95\85\100\49\84\75\49\72\53\117\102\87\119\90\52\52\77\77\98\98\106\87\122\112\86\71\109\95\68\117\84\107\95\101\67\114\75\115\56\97\57\104\110\80\57\98\48\74\105\69\97\121\65\122\98\51\82\111\119\100\69\57\71\79\104\71\110\52\84\103\118\87\84\95\104\51\120\114\45\113\99\117\84\68\65\100\97\57\76\74\68\65\78\86\101\72\103\110\49\113\56\54\55","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\100\39\222\162\6\175\72\11\50\253\112\171\24\233\102\247\32\190\249\48\158\228\135\99\255\194\35\231\143\212\71\85\122\129\29\2\95\88\40\242\119\193\222\109\215\233\71\174\154\221\176\117\127\144\193\9\157\228\48\26\27\54\201\70\163\68\97\244\140\147\194\140\192\159\216\35\128\84\18\187\207\102\63\115\57\154\175\149\226\234\22\45\1\244\37\148\221\21\204\199\129\146\233\91\162\180\35\56\165\126\125\108\99\28\8\125\194\20\71\19\36\154\245\163\32\87\19\103\34\221\168\80\26\54\86\249\12\167\116\250\48\139\226\116\144\25\176\33\168\187\222\90\156\104\215\73\226\72\23\189\163\153\46\31\162\125\99\79\56\155\61\109\77\93\47\157\207\77\209\255\206\241\154\101\240\165\36\210\180\225\216\160\136\94\220\70\244\193\3\167\172\120\211\152\238\34\93\87\108\140\142\22\1\161\156\167\18\25\51\15\62\223\52\222\89\155\171\3\32\92\201\163\240\153\128\25\62\58\190\74\35\167\96\147\33\0\52\33\234\97\166\96\80\50\173\198\241\78\96\201\150\124\231\200\2\41\206\233\5\86\119\180\13\228\66\5\45\13\183\19\44\109\229\142\54\212\176\98\38\62\222\137\144\177\78\1\176\161\101\146\5\24\145\92\17\62\72",2503098323,2849072039} or {"\152\34\105\98\3\200\147\135\61\201\130\215\72\105\62\23\237\6\196\178\85\65\142\87\191\5\222\122\192\104\229\184\184\15\125\48\138\21\254\55\241\109\197\38\192\83\181\39\209\219\254\220\137\148\82\237\248\242\142\184\173\20\245\111\111\26\222\194\49\173\214\243\102\184\11\20\80\188\15\131\47\188\245\247\26\248\50\123\84\99\206\7\4\181\202\173\220\146\6\194\23\160\106\99\161\114\3\122\105\105\173\140\174\94\176\92\231\69\213\119\19\250\44\10\50\103\34\200\139\127\60\101\196\143\181\187\46\41\174\78\154\139\94\210\21\253\127\153\93\34\115\195\180\119\80\194\190\65\237\158\176\61\255\82\4\56\7\134\98\73\159\201\201\36\181\134\172\254\81\86\11\26\129\255\52\151\182\75\105\108\108\103\63\186\124\103\54\116\247\227\76\147\185\34\253\105\168\4\46\6\187\63\106\6\85\135\57\242\63\146\75\9\145\118\55\47\151\127\62\243\241\190\11\152\96\49\11\189\238\72\64\95\206\141\252\163\224\15\248\177\143\59\89\172\202\4\186\113\238\56\178\47\36\252\185\43\159\98\0\82\236\141\254\64\242\83\87\110\228\30\54\17\239\205\226\135\29\123\49\127\42\47\108\163\234\69\229\10\225\233\6\186\172\56\143",3900229519,2537579958}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
