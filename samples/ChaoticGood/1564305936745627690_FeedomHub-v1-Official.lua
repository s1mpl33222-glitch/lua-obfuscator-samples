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
local fresh=url.."?retry=60dd1725be13cb84"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=60dd1725be13cb84"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\50\56\98\102\101\97\97\50\49\99\97\52\51\56\49\102\51\55\56\57\52\54\97\51\98\48\55\97\101\98\48","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\85\75\45\86\48\66\89\65\81\110\56\49\95\45\54\115\58\70\68\81\85\76\100\56\69\54\97\116\99\118\107\69\104\100\86\84\103\55\119\58\102\120\119\86\68\67\104\99\113\52\65\99\56\54\99\115\73\55\55\103\102\89\115\89\50\109\99\99\118\45\109\49\45\120\89\110\73\57\66\109\70\97\101\54\79\54\107\110\116\45\88\112\112\118\112\74\78\67\52\121\111\118\68\110\117\117\51\82\50\121\68\56\111\65\111\107\104\102\114\111\107\86\99\50\118\114\100\55\105\110\117\70\51\67\86\84\76\120\105\105\88\85\57\119\79\68\77\110\82\72\87\51\106\81\48\69\107\119\103\83\97\49\77\53\104\65\114\51\87\54\53\121\116\120\80\121\100\102\75\86\115\100\56\77\51\52\110\48\71\81\95\56\108\85\105\55\121\89\104\111\98\114\107\109\86\48\101\49\88\75\99\84\115\114\76\114\77\105\82\75\111\82\110\98\84\51\95\120\54\104\77\89\122\85\102\70\57\97\83\48","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\194\200\196\69\101\137\114\9\44\246\77\128\113\38\96\169\135\118\90\173\179\26\99\132\109\183\213\76\86\243\49\44\204\164\79\245\191\249\166\187\41\207\59\102\5\234\98\65\59\170\146\226\65\132\102\48\242\186\148\41\194\139\31\227\183\224\150\99\133\241\253\218\240\49\58\165\176\217\22\148\73\60\109\11\231\219\128\209\247\85\158\227\90\245\201\242\131\71\155\44\95\176\218\160\52\176\236\143\70\151\126\250\128\237\105\120\86\225\174\112\115\16\1\98\108\100\3\253\55\63\101\2\112\238\136\203\36\38\199\187\59\236\209\22\107\127\221\216\183\69\52\61\208\34\128\247\157\58\92\242\189\160\158\155\204\233\200\101\123\231\4\24\28\72\3\112\77\78\202\232\210\197\170\31\113\46\93\75\190\190\128\214\254\47\181\22\210\79\203\172\216\176\193\125\83\203\115\78\222\172\158\186\144\76\39\49\127\26\59\192\21\254\73\4\192\59\111\103\247\37\235\10\26\27\225\60\17\113\224\129\92\60\242\177\168\112\115\115\12\92\162\147\253\155\24\30\250\236\121\123\73\46\141\239\197\76\173\198\54\158\17\127\154\163\10\57\26\141\242\74\94\145\217\234\12\232\71\3\17\73\54\210\194\53\212\47\223\177\185\195\118\198\87\35\190\205\76",783325739,2899010259} or {"\89\122\198\200\190\212\180\210\108\148\117\73\171\129\51\192\150\88\146\122\156\69\219\141\146\156\198\193\46\29\94\21\136\90\237\24\220\176\224\3\134\157\92\18\212\153\24\198\55\132\240\1\204\136\252\251\202\198\252\17\230\136\45\0\40\168\140\195\124\180\160\209\71\106\91\59\100\254\237\214\88\215\152\175\111\109\84\105\162\142\238\98\147\179\104\119\112\200\152\108\163\105\225\56\35\6\234\180\121\153\200\64\6\137\188\163\125\162\75\84\13\28\11\165\192\0\210\199\111\145\250\214\74\145\202\95\43\64\42\221\49\3\89\253\80\60\62\64\21\160\5\242\67\137\171\136\163\88\113\13\229\138\78\221\167\150\162\136\148\230\190\187\210\113\170\71\182\207\94\104\138\221\58\235\138\131\100\108\235\138\145\93\227\55\169\68\117\141\233\87\232\68\199\81\210\1\158\58\178\120\44\120\22\169\75\122\173\111\32\10\1\221\232\25\4\154\24\163\243\172\45\131\225\161\203\114\225\1\1\178\101\143\119\160\83\65\48\90\139\108\233\8\58\209\251\51\72\252\244\212\30\31\56\190\97\78\221\106\221\119\34\154\35\34\95\26\245\35\85\243\42\42\38\96\140\5\108\253\84\235\229\33\69\115\74\90\16\180\156\162\129\65\114\236\160",1734551284,2587649250}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
