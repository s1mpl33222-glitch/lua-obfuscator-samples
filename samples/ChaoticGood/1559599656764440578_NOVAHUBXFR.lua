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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\54\51\52\97\98\56\102\52\53\99\102\52\56\51\100\54\53\48\100\50\55\57\52\100\53\51\52\99\97\53\49\55\49\56\53\57\53\57\53\99\57\54\53\98\49\51\49\48\48\49\54\57\97\49\99\99\100\53\48\54\57\102\99\52\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local pinned=url.."?retry=e5c250836024bccd"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=e5c250836024bccd"
local expected=898586
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
if s2*65536.0+s1~=1933677448 then problem("runtime checksum mismatch",3);return end
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\51\99\53\49\99\51\49\48\98\56\53\54\102\57\102\57\52\97\97\97\56\100\53\98\48\57\57\98\51\102\56\54","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\106\51\66\50\71\86\108\66\88\104\109\100\122\106\75\65\58\86\107\100\67\70\98\116\104\110\106\97\109\82\120\79\119\75\73\116\117\102\103\58\102\78\73\89\104\114\73\87\113\51\65\120\65\119\107\68\51\45\100\65\102\121\98\76\49\54\109\121\76\54\121\51\121\113\95\53\112\48\122\50\97\101\115\114\89\53\97\101\120\72\80\122\54\88\85\72\78\75\68\122\113\79\114\78\103\112\99\67\72\49\68\89\88\77\66\65\118\89\75\84\45\84\85\111\76\68\76\49\77\55\118\113\121\98\84\103\101\121\113\119\66\54\101\57\116\111\57\120\86\69\99\45\80\88\110\65\71\115\71\117\76\87\55\57\114\76\105\117\100\109\121\79\100\70\66\74\111\113\78\114\113\120\113\45\115\70\120\52\68\100\90\83\90\66\111\45\79\81\52\67\86\51\67\104\82\55\75\109\85\89\69\77\107\85\77\97\102\95\87\102\66\88\114\120\56\97\102\104\74\87\49\56\102\102\80\84\113\89\76\80","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\119\182\172\46\111\10\206\139\85\23\25\189\127\248\101\65\93\150\213\85\39\112\114\236\202\114\142\239\27\150\75\62\165\247\124\108\104\108\174\207\143\112\192\146\33\15\106\107\237\233\134\60\239\231\88\240\46\29\49\38\41\5\39\140\12\163\137\230\24\167\67\141\159\110\140\62\110\221\114\42\44\16\252\152\5\161\197\63\100\64\214\185\96\32\112\0\192\220\168\127\22\82\197\95\42\240\249\34\76\136\144\15\198\43\250\45\60\157\138\17\168\40\142\150\225\4\164\124\35\44\88\205\122\92\221\2\243\141\114\208\230\166\233\33\17\243\154\186\194\197\188\232\217\253\114\168\149\219\121\129\52\200\45\114\117\100\15\245\173\176\183\229\240\162\192\93\44\130\239\55\222\13\36\174\34\218\102\175\59\110\128\234\202\196\225\89\240\206\207\62\13\157\153\130\196\200\143\178\165\100\226\84\214\105\83\63\116\73\200\53\101\228\179\167\145\44\52\108\37\181\209\194\133\22\227\179\202\73\216\23\60\180\196\19\170\163\51\74\33\194\24\239\161\172\158\237\199\155\176\207\25\175\95\189\170\228\149\185\235\183\145\164\144\38\202\191\126\45\57\95\34\81\133\226\147\49\56\125\57\176\160\23\22\178\68\48\174\103\135\145\181\104\127\131\97\215\125",4155541653,2484167564} or {"\203\225\36\52\56\142\150\106\141\48\171\228\99\62\108\36\197\213\152\129\57\160\249\143\252\61\113\62\157\185\66\204\30\210\92\83\145\28\117\250\61\164\196\207\196\132\145\239\186\118\177\177\156\254\59\46\114\219\100\243\146\168\122\214\148\144\222\241\224\244\52\151\165\38\106\253\118\55\232\15\3\58\73\169\165\125\135\214\191\157\181\34\197\55\243\89\25\145\219\200\65\71\180\101\178\240\196\30\147\106\251\151\81\173\73\251\213\102\245\58\155\97\247\122\21\5\227\197\159\79\64\144\125\51\98\199\156\172\222\40\149\230\243\135\87\230\31\249\2\60\35\169\143\199\185\35\181\141\161\21\70\74\70\16\89\58\76\84\50\24\219\110\118\64\45\4\25\154\189\128\79\99\43\238\130\2\144\244\150\182\117\145\244\159\199\64\248\5\54\56\91\142\231\113\195\169\142\117\41\168\4\254\29\29\195\44\10\123\79\6\37\100\136\140\249\104\119\41\231\198\174\36\247\95\55\7\31\122\206\174\183\26\38\133\191\37\235\10\43\158\46\92\18\14\186\232\18\238\172\79\124\96\74\220\25\85\144\65\164\97\236\11\134\107\116\200\233\189\60\61\163\224\105\185\93\158\245\140\86\215\228\51\130\254\94\25\39\40\189\226\245\100\94\146\102",2178173864,2182112667}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
