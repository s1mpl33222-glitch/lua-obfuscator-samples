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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\50\54\57\53\51\49\55\54\48\55\48\51\97\99\48\99\56\48\54\53\51\100\52\48\48\54\55\48\56\99\54\100\55\55\55\99\52\57\53\52\102\57\99\56\53\48\55\97\56\100\53\102\57\54\49\55\53\57\48\98\99\98\55\48\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=5c27ded2a0571ca3"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=5c27ded2a0571ca3"
local expected=617906
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
if s2*65536.0+s1~=2497301977 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\102\102\102\102\54\55\49\49\52\101\50\49\100\49\53\99\55\98\52\53\101\102\98\99\100\97\52\52\97\97\55\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\84\77\67\76\86\67\87\110\77\117\115\103\121\106\77\65\58\48\113\90\82\74\55\117\73\69\95\78\72\84\51\80\87\120\99\50\101\111\103\58\89\73\89\66\111\71\68\71\107\119\78\78\87\115\53\56\86\98\99\76\108\68\45\97\120\108\70\99\86\90\48\48\72\49\114\101\99\114\49\77\103\110\52\77\89\70\99\71\85\55\79\80\52\55\56\118\81\53\117\53\90\87\112\77\113\50\50\56\99\85\110\120\83\116\75\106\98\107\82\120\109\120\79\72\113\87\113\74\67\100\86\77\80\66\54\115\112\115\114\84\71\113\113\56\45\53\70\105\110\87\89\69\81\101\105\104\101\53\100\97\103\115\83\67\122\111\111\73\118\54\86\76\45\76\81\75\102\54\65\112\120\72\75\76\95\52\106\74\77\116\55\50\121\115\113\121\97\121\70\83\110\78\50\87\102\78\90\75\102\87\80\80\87\101\67\54\84\76\117\106\118\76\54\50\109\67\53\54\112\83\114\66\100\88\85\103\76\112\68\56","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\133\106\169\244\181\76\105\161\95\219\107\242\31\21\40\88\87\99\26\223\209\152\253\213\183\208\241\237\19\69\156\146\207\190\180\169\186\29\246\204\129\14\21\207\150\45\231\25\86\48\44\104\237\100\117\65\174\67\160\158\247\155\12\60\30\168\57\58\124\130\103\129\123\128\39\171\216\204\244\188\24\123\236\127\123\183\184\229\249\129\166\227\64\65\236\124\197\7\84\179\193\90\55\34\115\28\102\187\219\217\71\159\163\214\112\115\13\164\131\24\195\65\252\85\231\88\171\219\115\100\231\114\138\120\216\212\94\237\185\43\172\9\174\1\98\71\92\164\185\191\219\49\176\103\75\242\84\229\227\106\55\16\144\40\116\247\28\148\118\145\102\159\241\251\108\147\78\87\77\60\63\224\201\205\207\154\141\220\245\43\246\34\184\78\194\92\86\223\48\225\103\10\245\58\51\254\25\23\255\255\160\226\36\156\203\43\130\147\194\8\180\224\158\29\148\140\101\235\62\124\97\161\34\123\30\153\164\252\180\129\38\12\1\136\46\2\35\107\238\19\60\230\191\25\45\142\21\57\86\217\154\113\26\214\184\87\155\209\164\184\52\121\168\136\236\205\140\72\178\120\120\190\244\41\22\127\20\126\62\147\185\80\209\118\19\84\252\120\124\185\25\155\201\209\61\67\197",2688834717,536633985} or {"\159\42\91\216\103\94\5\165\25\212\16\22\180\92\134\213\135\83\141\250\188\155\112\141\233\216\125\203\185\181\76\115\121\141\154\99\106\2\118\137\116\61\128\47\71\218\243\1\105\108\221\77\94\70\149\250\253\99\88\166\137\208\192\203\18\176\250\35\26\54\191\1\112\195\186\29\12\19\243\135\161\19\182\53\125\155\227\167\59\97\203\140\114\39\34\107\92\133\229\208\149\64\119\220\139\61\234\238\164\106\146\71\118\188\32\193\245\250\70\220\226\147\4\6\233\158\240\180\222\123\84\231\212\128\68\158\206\171\44\207\25\181\30\145\90\255\74\207\128\131\61\206\115\7\137\17\46\223\192\174\168\229\251\2\252\101\169\70\182\13\15\28\186\208\137\38\220\33\25\35\59\221\172\29\153\84\99\44\37\144\245\206\27\60\167\71\224\239\119\162\99\209\168\157\174\165\124\117\192\16\86\101\191\103\65\83\85\177\113\75\99\26\55\200\15\34\106\148\114\42\183\51\215\234\62\18\16\79\176\245\17\224\110\174\197\41\138\202\113\70\169\148\162\233\234\21\149\7\36\50\163\41\123\30\194\3\217\150\160\13\37\191\142\253\158\62\38\206\104\179\115\53\127\2\21\217\208\66\167\185\3\233\247\5\60\15\43\152\15\227\130\165\228\82\133",2384927984,211117200}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
