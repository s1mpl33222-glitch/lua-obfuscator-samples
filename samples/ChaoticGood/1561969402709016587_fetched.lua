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
local fresh=url.."?retry=187a939d0be2e7f6"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=187a939d0be2e7f6"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\48\57\102\97\49\55\56\102\48\99\56\50\56\56\52\48\98\98\57\49\54\49\57\54\98\98\49\49\49\56\54\49","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\110\77\88\56\45\111\65\79\77\54\122\75\115\120\49\85\58\88\89\66\53\107\90\100\90\98\70\53\101\114\97\65\52\56\50\119\108\65\119\58\111\95\71\76\122\50\116\85\79\81\82\80\45\48\106\72\55\50\50\117\65\100\115\107\121\76\57\111\103\95\74\97\65\73\81\89\106\67\77\52\77\84\95\87\101\48\75\67\79\98\84\107\121\102\55\111\102\82\65\79\84\72\71\104\118\68\71\76\97\55\98\95\53\55\114\55\81\104\114\105\69\85\109\117\76\45\78\83\84\51\119\99\57\86\104\117\105\57\45\78\69\120\52\72\119\89\83\88\117\110\76\55\53\70\88\48\106\103\71\65\75\119\111\122\75\111\65\84\52\98\86\82\119\106\70\56\53\104\85\119\104\111\122\104\114\110\116\51\53\82\65\103\80\86\121\74\109\70\78\106\73\67\103\104\100\75\103\81\84\65\56\57\84\101\87\116\84\109\103\99\54\106\98\50\72\118\88\55\50\106\79\54\45\101\103\104\115\54\114\72","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\214\77\16\89\51\108\120\68\173\164\44\36\198\133\65\18\66\43\134\208\121\68\171\15\235\17\179\162\148\144\207\121\124\222\135\212\231\42\22\96\27\127\34\34\191\32\129\204\45\117\113\197\91\26\239\61\81\248\177\65\42\194\148\57\171\94\199\236\55\141\49\147\249\62\101\179\216\221\164\57\118\240\62\6\166\47\169\26\138\55\73\141\75\42\205\11\98\233\107\32\166\81\11\185\239\160\170\45\52\237\255\11\103\118\208\111\99\193\127\161\204\152\89\231\191\15\132\59\27\177\216\168\115\5\235\179\96\153\97\148\254\44\65\88\227\50\162\15\168\191\97\157\99\156\37\241\61\61\130\146\211\77\121\187\110\34\246\136\231\156\132\16\249\116\137\88\154\240\12\6\125\217\200\236\18\234\7\85\5\43\148\136\21\238\35\247\187\0\158\227\28\151\198\42\249\95\229\201\27\88\146\206\13\3\83\185\207\25\161\183\187\49\209\114\113\13\77\3\62\184\227\198\240\228\38\247\240\64\245\211\62\61\95\119\126\59\1\140\225\187\222\247\195\214\60\200\93\47\176\87\237\245\5\107\106\113\57\98\218\41\126\135\211\20\37\145\69\105\69\44\83\47\208\210\179\85\191\109\119\186\157\137\122\198\67\125\145\187\155\219\139\37\30\190\9\19\33",1744702828,3640549420} or {"\203\15\186\237\16\169\78\91\80\28\167\49\37\106\184\150\212\26\148\150\105\132\239\249\37\2\230\123\101\38\147\42\39\218\70\180\89\111\48\34\68\254\53\67\228\116\33\181\254\215\143\36\172\119\7\238\16\173\178\255\221\0\44\6\181\139\125\206\233\74\133\226\119\196\109\23\4\65\75\255\175\219\11\45\25\95\10\42\37\100\167\17\110\180\213\108\167\106\18\177\236\209\134\161\231\245\130\173\107\105\188\109\139\184\24\221\93\36\135\0\120\168\156\154\35\238\76\97\114\158\46\80\135\224\97\16\120\6\1\170\83\25\180\247\123\47\25\142\237\31\27\201\85\222\45\135\120\93\142\52\124\17\71\53\84\213\159\120\119\17\26\117\70\178\201\102\205\166\221\46\150\177\226\143\218\169\20\90\182\226\139\232\110\169\96\146\139\224\26\150\135\19\172\208\86\39\103\245\198\8\145\255\67\166\174\79\5\45\14\191\92\111\249\57\71\254\125\102\59\102\180\169\219\46\145\16\168\171\202\12\84\205\144\226\169\223\25\86\203\74\54\46\111\216\210\228\148\136\133\0\29\86\241\18\108\93\62\0\60\162\140\130\72\255\149\97\58\147\210\181\248\15\122\114\155\98\169\199\162\179\190\3\19\102\159\145\252\11\80\190\116\115\225\151\195",4197061106,3364971067}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
