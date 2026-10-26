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
local fresh=url.."?retry=bbb8e3fd31803f1c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bbb8e3fd31803f1c"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\98\102\56\55\98\57\52\56\50\99\99\55\100\51\97\101\57\100\48\48\57\49\98\99\102\49\48\49\54\57\53\55","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\77\69\74\75\53\50\70\107\109\54\118\68\119\111\70\112\58\109\112\69\66\67\48\110\67\78\49\65\104\110\110\95\65\111\111\98\115\76\103\58\57\104\66\71\122\106\118\122\100\50\106\101\109\85\76\69\80\74\53\104\117\121\114\104\83\120\100\68\115\69\74\98\109\103\88\102\54\114\70\111\109\76\53\121\106\99\113\87\50\68\51\48\107\87\66\121\53\113\109\90\74\50\97\108\84\106\114\88\85\70\112\89\73\78\89\102\80\70\116\48\89\80\97\122\98\48\107\113\53\95\52\102\88\108\116\55\74\56\67\51\75\100\49\86\80\115\71\55\116\82\97\54\90\83\81\56\75\49\116\82\83\76\101\90\120\101\108\56\105\74\53\81\121\116\106\108\121\65\73\103\118\45\84\115\85\100\117\104\102\120\110\119\100\97\71\85\95\51\68\76\45\111\103\90\118\78\45\53\48\87\53\117\112\65\86\103\99\122\85\113\71\106\117\120\81\73\102\105\100\107\84\45\117\100\49\122\67\53\55\49","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\54\240\186\53\72\14\115\59\155\219\249\151\162\248\216\133\106\131\246\42\26\121\49\100\140\11\217\254\188\81\97\119\204\97\115\236\7\25\144\220\32\147\73\216\199\71\105\29\214\244\183\194\213\134\47\163\124\163\12\31\37\187\19\130\27\12\197\69\166\162\116\109\102\99\180\122\190\252\244\80\67\52\178\179\36\237\28\211\135\147\204\245\197\29\234\10\99\26\40\140\160\237\196\177\2\234\255\119\55\226\41\143\246\9\87\161\106\138\18\238\211\108\206\237\103\54\207\70\235\79\117\212\136\130\227\167\214\165\95\135\251\252\251\196\156\187\52\115\239\138\121\14\12\74\8\41\157\65\47\225\70\211\104\112\210\46\251\162\113\220\208\171\49\14\247\109\35\56\26\223\96\15\128\83\55\180\138\164\94\170\201\237\79\184\250\113\235\113\41\225\111\241\205\47\106\167\152\251\246\65\118\84\214\37\1\130\25\157\249\128\17\127\70\174\12\19\94\220\215\247\100\3\248\195\206\32\160\182\249\242\90\79\68\121\99\26\9\88\67\217\63\78\172\73\55\166\139\22\149\252\87\249\225\200\77\244\7\58\129\175\59\100\150\31\208\58\44\42\158\231\225\11\204\64\227\192\190\144\87\123\11\248\141\245\167\251\227\111\126\244\70\250\197\153\192\144\203",2105520100,1075602288} or {"\17\94\15\54\98\243\161\202\37\75\205\143\15\36\243\145\160\107\191\223\217\192\169\148\36\208\124\149\108\234\40\108\184\138\165\201\217\95\204\119\75\234\99\216\34\86\56\1\206\85\179\69\2\114\104\3\109\234\87\253\162\50\253\2\26\229\254\153\142\114\205\106\168\147\202\57\22\168\99\159\240\21\116\206\159\30\132\17\86\139\242\79\58\50\80\219\165\134\41\126\105\185\173\198\23\195\142\220\126\41\99\206\47\238\192\74\83\26\147\112\44\252\143\21\218\228\50\65\33\107\201\28\96\194\120\206\92\5\74\1\167\169\217\166\76\5\210\144\140\232\23\250\182\39\170\124\105\185\114\79\10\95\193\35\126\188\135\163\81\39\217\157\199\140\242\199\117\163\140\242\158\88\100\144\128\160\103\201\37\60\173\151\180\14\102\56\198\30\51\224\245\27\141\213\56\74\250\150\40\220\118\167\141\8\17\188\147\135\155\203\241\21\34\62\15\240\107\71\49\66\167\91\110\52\77\19\136\8\171\201\34\97\3\203\138\51\161\129\71\210\42\231\198\79\170\157\185\254\19\126\39\87\153\68\88\249\35\21\4\50\194\105\250\21\14\178\214\24\20\102\65\217\163\170\253\170\160\197\48\76\158\33\92\150\154\212\8\39\24\245\241\94\62\234\33",470443798,773809535}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
