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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\56\99\98\48\49\100\50\100\99\53\55\98\56\55\54\55\100\50\49\101\53\101\50\50\49\51\57\102\102\100\55\50\101\101\50\48\100\99\48\101\51\48\99\101\49\52\48\49\101\49\53\102\98\49\100\102\57\55\98\57\51\99\100\100\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=fb9661aa2bfecdff"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=fb9661aa2bfecdff"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\56\48\48\55\57\49\50\100\57\100\97\51\102\102\56\50\97\51\50\52\51\100\99\101\101\50\50\57\55\102\50\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\51\90\86\55\71\81\98\105\68\95\89\120\73\70\71\75\58\103\99\48\114\105\101\79\97\51\69\105\103\69\84\54\122\81\111\114\114\49\65\58\111\99\121\82\45\120\56\108\89\83\113\105\82\116\116\109\52\118\112\90\50\56\52\104\83\111\109\113\73\66\73\90\115\113\105\99\89\116\107\51\109\70\113\52\82\49\48\114\118\81\85\113\73\80\101\103\88\48\52\67\115\48\104\57\121\112\112\76\114\54\57\105\118\100\103\88\78\82\67\120\112\89\77\115\114\97\49\78\120\87\75\109\57\66\78\65\111\75\72\51\102\78\49\69\76\65\49\52\86\80\79\107\104\77\122\89\76\98\115\78\107\99\103\113\109\84\67\76\76\101\51\77\112\116\111\88\88\115\75\65\90\90\81\66\101\66\48\85\55\118\48\103\110\100\107\114\90\120\118\72\54\112\65\88\88\84\116\88\72\77\69\53\75\101\78\107\67\88\45\74\56\121\76\87\106\119\68\74\108\86\106\97\56\69\108\55\78\120\121\86","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\30\139\112\125\221\70\245\101\79\60\30\123\194\28\40\139\236\125\104\42\254\87\178\109\100\40\150\250\58\159\2\114\141\245\227\176\63\243\48\19\14\101\199\120\37\216\119\8\20\235\168\251\36\155\194\44\243\239\9\127\235\0\28\201\141\46\231\114\10\134\154\21\20\164\81\243\25\228\73\49\143\15\151\10\88\251\53\144\202\199\66\224\29\120\170\223\159\221\232\204\22\221\41\106\215\62\19\178\248\168\46\236\121\59\193\226\92\169\122\72\31\140\191\219\174\244\89\104\185\158\234\26\132\130\19\60\75\73\176\12\84\215\236\167\162\214\107\196\37\19\72\121\234\237\244\14\213\226\19\61\143\244\7\92\77\54\40\12\76\145\247\121\126\223\230\183\221\242\179\96\193\57\159\33\248\76\110\246\145\14\155\52\191\207\55\99\212\75\108\102\227\158\116\227\156\143\220\61\220\251\85\102\252\131\105\186\203\199\225\64\110\132\68\92\38\70\214\136\56\187\174\26\150\205\42\33\48\108\52\176\247\180\70\153\249\246\152\29\206\156\253\251\144\53\41\18\233\102\96\174\163\144\48\63\189\127\37\105\50\221\16\1\55\84\94\25\170\155\188\147\25\165\215\132\138\227\7\4\242\207\176\211\14\100\30\159\38\178\3\17\19\163\54\25\140\217\164",1779190584,4224344808} or {"\204\225\62\69\189\214\203\55\132\124\201\11\57\212\238\253\154\40\64\99\176\147\98\114\18\77\220\143\116\135\177\162\47\33\57\125\59\68\58\137\149\200\124\171\0\125\82\91\135\115\64\111\100\22\228\23\124\92\59\231\112\226\149\153\203\146\89\111\166\29\231\57\98\40\147\223\18\64\65\215\89\83\195\157\27\210\246\158\188\159\231\224\220\148\190\170\50\128\181\129\181\193\113\247\242\243\168\208\69\74\227\192\158\219\51\144\126\236\84\170\231\39\166\94\174\162\203\171\121\214\44\55\66\137\253\103\252\74\22\143\60\158\80\122\241\58\46\117\180\49\185\81\63\12\30\252\224\77\206\6\29\64\168\112\1\100\146\232\12\248\39\102\101\6\187\96\53\61\185\74\206\221\8\53\12\213\3\189\155\177\222\248\125\29\255\108\146\169\152\188\186\86\17\18\29\245\24\213\21\235\46\32\206\226\116\111\105\78\148\44\95\44\0\103\187\6\198\215\173\227\129\79\141\87\28\46\185\205\7\110\86\117\235\248\154\204\140\245\160\97\34\128\240\18\132\118\101\201\178\92\67\38\135\26\241\80\214\248\70\82\218\163\59\182\203\65\122\115\177\144\34\135\38\229\148\48\10\27\158\146\69\71\234\149\242\102\6\139\51\229\60\165\230\4\145",3685398449,3923600631}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
