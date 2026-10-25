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
local fresh=url.."?retry=78e0fca5c430bda0"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=78e0fca5c430bda0"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\99\49\101\56\54\50\98\99\53\57\50\56\54\50\51\97\102\49\102\54\54\56\102\97\52\55\49\48\98\102\54\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\108\84\90\48\84\87\103\84\101\56\48\117\71\111\77\78\58\51\73\76\57\53\120\68\101\53\82\104\73\109\115\52\118\69\111\57\112\100\119\58\53\89\88\118\85\51\122\104\45\53\56\100\119\115\101\98\72\85\121\121\90\69\65\111\81\95\45\77\48\75\75\108\78\69\75\120\102\66\80\67\120\109\89\48\114\73\105\52\73\82\70\100\84\100\106\83\48\119\88\102\65\45\106\119\122\51\48\75\107\79\56\101\68\117\85\109\73\85\98\106\54\48\102\85\95\86\87\86\68\116\56\101\79\69\71\54\55\108\105\90\99\89\55\100\65\76\57\67\90\45\55\104\82\79\115\53\112\109\118\68\99\118\117\95\79\54\77\99\76\75\115\113\89\71\95\101\85\48\86\112\108\100\83\66\45\84\99\99\73\53\99\77\55\116\80\99\111\101\111\120\115\120\69\70\79\68\52\98\87\115\81\103\112\120\57\86\111\114\88\116\113\70\106\97\119\50\79\82\86\103\102\73\68\113\102\84\102\74\56\76","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\144\52\44\233\200\38\253\104\241\230\48\35\172\177\126\135\249\188\164\24\180\90\173\82\101\112\75\172\30\169\81\70\254\222\138\248\40\76\173\21\148\219\178\118\92\114\4\1\220\144\74\9\245\10\110\84\86\169\104\234\80\188\46\38\140\79\155\10\122\61\95\243\225\232\143\138\129\150\77\201\170\217\249\21\97\208\140\149\65\95\247\211\228\213\164\129\6\170\21\214\40\46\80\106\102\134\188\177\250\225\29\35\97\150\80\81\19\16\122\77\136\192\106\104\252\139\84\223\13\116\32\166\27\171\179\40\60\107\73\22\249\131\20\157\76\199\14\33\62\91\242\28\101\12\111\240\137\26\23\90\183\16\14\80\45\94\75\47\13\168\15\241\170\136\7\95\128\11\107\187\187\126\89\11\35\132\178\131\127\239\10\64\53\224\48\167\210\246\191\251\33\127\221\154\160\18\18\43\94\213\152\164\170\100\225\48\20\193\118\149\112\187\123\236\172\209\152\32\3\68\198\81\232\242\71\233\131\223\39\127\186\214\129\31\72\118\203\143\105\150\14\74\175\252\222\98\221\104\212\99\151\124\76\163\182\14\182\180\181\104\234\171\88\252\119\78\104\131\180\145\168\20\123\251\132\63\58\231\165\141\218\121\35\232\56\24\231\161\162\250\121\132\180\9\148\32\133",1989282075,3703005657} or {"\29\9\108\40\181\186\4\253\214\55\92\206\161\226\134\127\75\102\227\242\235\28\89\194\4\58\70\35\131\192\231\182\53\16\255\100\204\50\129\231\201\132\144\32\248\27\142\80\104\247\101\214\223\168\246\190\60\234\116\222\219\238\49\4\236\21\126\145\179\47\133\92\135\247\31\66\192\254\184\182\30\7\241\13\71\147\228\162\1\129\125\135\124\192\142\99\148\78\77\147\162\3\191\246\236\226\112\126\212\219\212\243\218\245\177\216\114\254\193\146\82\39\36\1\147\240\23\133\142\179\247\18\134\31\133\113\230\72\207\138\225\21\84\199\43\190\141\236\61\215\204\106\231\77\219\152\30\152\65\152\192\229\161\35\245\217\198\145\78\31\12\69\157\203\248\72\40\36\190\191\92\140\190\141\0\95\201\88\97\129\17\46\57\86\217\193\138\48\215\143\152\6\29\102\216\38\138\183\67\119\157\85\187\68\50\231\133\227\36\67\170\219\230\28\182\43\46\28\180\128\151\126\57\245\200\79\151\195\105\108\80\244\89\232\199\185\197\14\132\42\26\158\199\16\106\220\174\221\254\246\174\200\92\81\24\26\81\216\31\240\231\250\189\198\227\33\66\75\43\164\25\242\102\150\213\192\108\133\208\54\171\71\206\146\66\249\130\65\62\162\248\57\207\228\16",3243504225,3407504360}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
