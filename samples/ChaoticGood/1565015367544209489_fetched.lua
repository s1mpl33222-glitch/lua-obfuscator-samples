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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\55\56\48\53\97\101\54\51\57\52\53\52\56\55\48\100\52\48\55\98\98\57\102\101\57\54\51\48\97\50\51\97\52\52\49\50\48\97\100\50\98\52\56\52\52\98\57\49\55\56\98\53\56\48\53\99\101\102\101\97\54\100\51\54\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=e6dd23cc3299f808"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e6dd23cc3299f808"
local expected=618951
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
if s2*65536.0+s1~=733717851 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\99\49\101\56\54\50\98\99\53\57\50\56\54\50\51\97\102\49\102\54\54\56\102\97\52\55\49\48\98\102\54\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\50\48\120\117\87\102\50\85\77\80\54\56\103\119\71\84\58\66\121\110\80\56\116\110\57\97\83\72\67\50\81\50\70\67\74\50\53\115\65\58\84\73\87\98\108\80\52\54\100\72\90\102\57\82\49\49\81\121\56\113\118\107\54\105\117\106\95\78\121\109\68\116\76\112\90\114\52\98\45\103\52\51\87\116\98\115\45\73\68\105\88\120\106\81\89\112\84\45\81\48\108\101\72\78\55\48\87\109\48\77\121\118\70\100\109\105\86\52\81\45\55\97\90\80\109\103\56\82\81\86\57\71\118\74\69\67\117\68\45\75\100\98\88\109\118\85\69\87\117\87\78\85\85\54\122\48\111\75\65\115\95\66\85\110\120\99\57\110\114\56\51\73\112\81\106\80\87\52\77\56\52\84\66\66\74\55\83\76\85\53\122\116\101\106\83\111\99\109\67\70\54\51\121\112\81\79\101\117\108\48\52\115\79\45\112\70\77\112\45\49\71\65\72\65\103\84\110\101\67\80\57\101\65\51\66\75\49\56\107\74","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\59\248\205\5\15\193\73\16\110\255\205\188\55\14\253\152\31\165\32\118\37\60\80\171\52\77\30\110\218\250\39\129\96\142\9\169\73\117\104\144\168\135\79\177\158\164\163\113\145\51\218\105\169\53\23\4\19\224\150\54\251\215\198\215\108\176\39\167\190\161\112\45\106\30\87\20\203\146\202\144\120\244\175\199\134\207\56\167\69\181\12\47\42\160\59\83\195\113\232\130\198\126\22\135\146\84\187\243\170\109\196\154\36\120\148\47\85\43\186\237\0\48\188\139\168\165\203\227\50\254\226\159\151\234\195\253\116\34\32\12\52\201\52\203\5\80\119\180\156\115\75\101\255\42\38\144\162\21\25\163\60\253\139\206\16\17\186\252\69\22\140\142\215\254\100\222\2\94\10\18\172\253\188\89\12\232\219\0\76\170\124\236\110\202\142\147\227\248\211\40\59\142\92\21\40\149\60\174\116\240\153\87\52\214\193\127\27\89\219\142\194\39\130\155\47\159\79\68\209\138\170\119\186\196\41\201\199\211\149\132\53\121\21\41\145\151\53\59\161\116\27\53\99\143\197\114\23\53\94\162\126\168\53\142\225\210\129\80\106\40\41\75\243\125\72\193\172\166\179\250\145\218\202\200\226\137\103\183\109\213\243\138\183\116\216\156\125\239\176\57\127\204\19\250\115\141\137",1454109724,142106300} or {"\207\108\231\188\139\175\111\18\42\106\133\125\27\22\166\113\154\22\233\133\56\15\211\36\231\11\10\215\99\207\106\167\50\171\65\34\15\226\18\62\111\2\186\57\204\152\33\171\206\67\219\138\13\7\84\52\161\32\163\187\163\225\26\109\129\99\0\133\174\108\250\101\28\229\160\126\18\163\32\96\148\144\143\65\129\32\99\154\162\29\129\80\181\76\132\159\13\102\10\180\5\123\152\207\14\147\32\43\126\27\146\137\31\20\183\250\9\202\43\176\183\244\195\191\207\213\180\94\182\156\246\23\16\39\36\190\143\49\158\83\125\190\217\37\24\85\0\209\189\4\71\169\85\205\253\178\196\80\12\199\83\240\196\58\252\126\235\66\174\76\29\141\55\243\166\165\143\88\23\41\129\18\154\102\89\166\82\217\243\145\105\68\54\194\19\95\106\182\140\105\177\3\159\234\239\173\161\191\132\124\71\16\253\66\127\219\81\145\13\74\4\133\106\11\83\199\164\221\92\5\37\213\249\148\26\62\250\245\239\145\135\254\199\228\139\81\255\203\170\254\171\169\114\7\35\118\148\56\53\200\187\85\6\55\90\165\191\208\198\234\210\250\220\113\10\244\108\149\136\10\65\119\190\231\78\118\43\25\121\110\208\234\68\178\148\102\86\42\84\80\34\212\238\98\158",2897573442,4140589259}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
