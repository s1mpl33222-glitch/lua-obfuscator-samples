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
local fresh=url.."?retry=6d5500cfdb5c8632"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=6d5500cfdb5c8632"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\57\52\97\99\57\101\57\102\99\98\54\56\97\55\51\57\99\100\49\55\54\101\99\102\51\99\98\52\57\97\57\52","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\97\82\118\77\117\122\78\109\100\51\78\77\68\119\106\95\58\65\102\76\52\54\95\56\117\112\121\95\98\113\109\85\74\99\100\66\116\65\65\58\79\122\71\106\75\111\101\85\121\116\76\111\51\95\82\55\79\110\88\84\89\70\120\55\122\113\87\75\82\113\81\82\52\86\109\50\99\117\70\77\67\70\77\45\115\74\68\87\100\72\66\114\65\110\51\122\65\71\104\118\57\109\80\76\97\100\120\86\72\88\95\82\50\111\54\122\102\118\48\51\50\81\50\119\50\99\86\52\77\72\52\56\116\106\77\79\116\113\107\109\50\104\101\80\69\83\72\88\49\81\83\112\111\117\110\112\116\107\75\97\50\75\119\97\45\109\88\107\107\74\51\82\55\57\90\111\113\107\81\86\74\90\76\84\45\120\118\54\90\111\69\107\98\115\56\114\113\66\102\52\90\95\55\82\95\75\66\112\102\95\119\78\54\89\98\103\52\111\107\68\67\98\115\51\77\73\104\121\50\81\118\45\84\95\77\119\73\122\105\107","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\192\203\115\27\106\48\192\234\126\33\217\135\167\15\225\186\100\234\145\14\14\87\150\39\234\193\182\167\40\161\139\216\59\76\217\143\212\28\161\40\177\246\157\147\210\153\135\224\197\203\76\187\247\31\160\168\116\190\205\155\49\209\67\10\245\85\220\137\226\53\75\70\204\96\59\177\140\10\130\40\90\179\23\203\104\55\55\45\24\52\179\3\70\7\118\72\97\148\207\150\14\73\78\138\93\224\200\209\181\185\88\205\174\30\194\24\140\78\103\123\175\4\214\186\115\62\21\58\56\206\78\110\2\72\14\54\93\119\10\185\148\129\13\230\127\205\78\199\96\239\140\100\177\132\207\180\49\2\137\226\65\148\149\240\40\114\148\178\242\150\16\87\223\39\20\150\231\30\95\196\229\13\204\110\240\100\34\119\138\195\87\134\255\187\117\68\136\91\128\207\98\136\115\238\188\78\10\121\171\74\74\52\208\45\254\37\146\104\103\249\195\163\15\225\4\130\123\145\214\74\212\124\94\158\26\143\248\183\83\234\93\32\97\41\167\131\66\166\174\56\116\214\58\55\38\192\157\73\6\211\231\44\1\31\94\163\139\39\223\95\200\67\149\179\163\232\254\16\119\149\67\35\206\157\87\111\40\240\202\206\194\221\241\220\168\215\193\149\211\218\165\56\20\140\211\53\182",2530634094,3914097624} or {"\107\29\3\214\252\24\237\58\96\68\27\129\40\252\118\192\119\122\57\143\126\128\81\173\169\55\116\96\190\74\184\46\43\168\89\57\119\110\228\46\107\195\7\233\253\204\246\238\98\19\235\54\28\68\192\150\71\25\61\88\232\101\244\213\180\50\139\130\33\31\54\207\26\96\203\156\189\220\228\167\204\167\103\165\141\40\58\249\64\1\146\115\213\209\80\182\104\10\165\208\17\25\175\181\76\142\23\161\124\221\118\2\72\228\205\165\77\35\244\211\254\182\170\14\150\7\247\197\164\16\86\193\185\213\255\245\125\220\57\10\180\241\166\173\160\255\80\162\78\98\128\72\155\67\5\202\227\153\222\172\128\167\34\66\188\230\222\239\97\136\12\54\249\176\97\152\193\67\18\216\212\15\250\63\61\53\239\45\158\243\71\37\79\240\6\30\18\168\209\61\39\139\13\71\39\129\9\168\48\164\238\238\109\67\6\12\122\133\116\80\197\210\187\241\79\37\41\241\5\198\150\180\77\77\87\119\29\207\70\32\164\202\197\99\220\62\56\157\70\68\39\121\222\81\22\211\68\53\124\157\211\142\136\108\191\161\195\87\11\136\200\95\252\212\175\137\117\28\157\119\18\180\186\105\215\78\19\206\30\198\173\152\147\26\249\120\143\26\20\142\68\187\70\15\50",703826704,3591071207}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
