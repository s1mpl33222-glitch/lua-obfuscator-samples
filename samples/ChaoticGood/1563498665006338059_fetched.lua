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
local fresh=url.."?retry=347244ab49a20c16"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=347244ab49a20c16"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\101\50\98\98\57\51\52\50\50\97\100\52\56\99\56\56\48\57\98\97\55\57\97\99\100\48\97\56\51\55\52\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\120\65\99\69\77\100\107\72\88\54\122\106\80\98\107\114\58\120\116\86\69\118\120\76\66\110\84\87\97\84\100\98\102\57\108\68\52\110\81\58\74\86\116\114\103\72\80\55\103\65\110\72\101\45\74\89\56\71\108\100\97\109\114\82\109\49\65\84\89\84\48\68\117\115\87\87\116\80\95\71\66\95\85\106\71\48\114\122\45\122\119\90\111\108\75\101\67\108\51\69\66\106\112\116\112\56\107\88\55\108\53\45\113\76\66\73\107\90\101\69\54\100\85\107\89\65\116\119\117\83\53\102\111\65\77\73\69\57\86\81\102\50\90\77\81\70\73\50\113\71\122\56\57\121\72\112\116\105\88\108\95\115\75\67\72\95\115\56\49\97\50\118\54\49\52\86\108\100\73\110\79\83\56\97\68\106\73\54\88\113\111\81\112\117\95\101\103\119\66\101\74\76\87\88\65\100\102\83\49\70\72\67\117\83\106\70\80\120\118\122\84\49\120\122\90\77\106\114\105\70\67\107\65\57\56\119\73\76\99\77","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\87\103\2\65\9\43\185\60\13\63\234\234\125\190\180\29\112\184\59\248\143\155\151\33\31\18\88\191\31\46\217\91\34\248\76\11\140\219\102\45\89\12\23\96\54\69\209\23\177\163\46\96\24\23\235\227\67\219\149\168\77\214\42\108\16\245\32\208\28\124\2\213\113\47\46\85\33\139\179\142\183\6\2\173\34\201\71\97\211\7\146\81\49\140\236\16\91\71\157\247\70\91\30\108\207\203\154\147\127\86\97\255\60\197\6\231\125\12\37\144\250\35\123\185\225\212\59\219\83\199\114\250\57\4\9\227\63\195\212\139\124\241\21\138\138\62\150\89\116\153\26\213\222\213\130\189\118\34\145\69\12\173\117\115\255\169\189\21\86\42\68\67\112\77\118\64\79\165\146\173\185\143\36\131\1\208\143\173\45\230\173\248\17\151\186\158\19\58\206\107\88\1\110\161\53\10\172\39\36\216\137\165\26\172\106\71\74\208\20\144\69\188\71\154\106\30\235\104\84\16\11\165\176\251\226\159\161\76\50\142\134\197\157\249\201\58\102\78\200\119\242\43\58\221\213\141\63\153\147\121\6\152\162\64\83\248\212\216\210\199\210\102\43\38\137\255\158\2\224\141\170\150\61\93\60\88\255\187\105\85\6\221\31\134\21\79\19\156\83\148\112\239\214\170\94\53\110",2357956779,2126406475} or {"\149\35\36\50\18\225\200\66\40\170\208\193\140\18\253\181\91\224\90\41\76\47\135\253\37\143\78\164\93\192\108\69\122\172\125\164\108\28\79\152\157\162\108\4\86\231\242\65\18\163\45\52\214\148\95\42\60\246\201\136\154\49\170\209\188\97\14\244\209\55\145\138\179\207\239\80\79\82\22\231\236\247\35\73\222\123\221\132\135\214\29\106\145\247\99\205\99\46\40\245\91\222\106\109\166\23\131\51\62\205\112\86\61\244\242\9\190\248\115\208\252\248\242\95\198\117\212\132\24\33\170\227\220\73\8\46\71\43\100\179\238\164\123\123\113\191\4\94\11\114\18\237\172\44\248\153\148\71\149\175\219\50\57\239\5\31\219\234\151\107\208\213\25\105\253\37\192\238\10\119\133\238\123\111\98\39\92\10\86\86\108\44\71\144\126\47\123\193\179\172\203\93\39\229\27\195\237\53\132\226\23\186\217\22\102\110\158\163\29\127\12\241\224\101\155\236\95\254\41\255\127\171\211\134\3\157\44\214\8\33\103\1\112\13\238\143\167\2\197\178\41\213\140\217\233\91\96\185\139\84\129\93\239\72\6\30\2\6\220\157\229\231\46\147\213\88\107\181\213\238\50\195\63\248\24\223\194\60\78\198\164\30\162\25\153\226\154\36\45\93\253\25\249\203\51",482737087,1818977626}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
