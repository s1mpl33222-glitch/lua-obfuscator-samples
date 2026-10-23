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
local url="\104\116\116\112\115\58\47\47\102\108\111\119\97\117\116\104\46\110\101\116\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fallback="\104\116\116\112\115\58\47\47\51\55\46\49\56\55\46\49\51\54\46\49\56\55\47\97\115\115\101\116\115\47\102\108\111\119\97\117\116\104\47\115\104\97\50\53\54\47\100\99\54\53\97\102\55\56\54\57\56\50\56\55\98\99\50\49\53\49\98\97\102\100\98\100\54\55\49\53\52\48\54\100\53\51\53\102\102\53\100\52\98\102\51\54\53\55\50\50\100\56\102\54\54\102\102\48\97\102\51\101\55\98\47\118\52\95\98\111\111\116\115\116\114\97\112\112\101\114\95\109\97\114\98\101\103\46\108\117\97"
local fresh=url.."?retry=444e8d44fd817477"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=444e8d44fd817477"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\57\99\97\101\97\49\53\50\56\53\99\102\50\54\97\101\97\51\55\54\98\51\102\99\50\102\100\98\57\54\50\99","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\82\99\107\66\116\122\95\70\55\106\102\53\84\121\117\102\58\120\110\75\48\73\116\88\66\72\77\57\104\51\110\49\52\84\101\56\70\79\103\58\52\99\112\45\76\51\79\70\78\76\84\81\114\56\52\69\68\69\90\76\56\83\110\115\65\83\118\107\79\67\121\53\76\115\48\75\112\54\111\68\49\103\106\117\109\110\77\97\86\85\121\86\72\89\122\98\86\111\99\73\100\56\77\86\50\70\50\97\95\76\55\120\73\76\75\48\65\71\65\111\71\73\85\115\106\78\54\88\114\112\105\48\112\66\109\105\81\114\119\72\114\102\110\70\97\120\52\110\87\104\78\69\116\82\48\119\49\119\121\83\80\55\118\81\119\103\113\55\84\121\87\45\57\98\108\68\87\115\88\75\84\45\89\48\83\101\77\120\79\112\120\76\50\50\104\115\102\75\71\70\56\97\86\117\68\111\98\76\102\52\68\54\48\83\48\54\66\57\102\103\115\76\51\99\45\51\75\107\112\68\67\111\51\80\78\79\103\97\85\81","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\105\238\232\146\100\42\106\74\243\118\57\36\29\60\245\178\129\192\249\133\200\228\48\166\10\144\12\238\217\110\141\103\194\175\119\28\199\131\95\161\182\59\60\21\41\61\39\30\51\208\168\127\88\46\164\109\184\250\2\179\147\95\229\75\147\39\210\115\157\124\139\100\62\194\232\246\97\49\142\142\170\136\5\145\129\82\67\134\107\250\131\240\97\40\97\185\19\201\162\68\181\147\150\10\88\170\55\65\53\130\32\48\188\116\183\148\38\38\88\45\22\114\180\42\70\246\254\2\105\65\162\0\42\135\95\241\66\202\76\194\8\48\99\178\73\214\163\83\9\189\54\95\104\251\70\74\173\158\217\135\139\80\80\79\252\222\196\66\75\68\193\119\105\125\22\100\169\14\225\139\165\195\228\241\244\154\144\181\51\69\149\61\87\157\71\91\228\62\29\191\167\68\152\34\82\186\223\148\99\142\36\114\49\202\213\250\50\15\169\248\187\129\85\83\61\114\141\9\29\126\219\167\154\49\95\113\21\136\162\4\115\202\144\188\15\244\121\28\186\248\86\198\205\183\166\124\11\58\188\8\112\119\245\139\229\78\200\196\168\73\92\215\213\179\175\174\205\153\250\124\158\156\38\134\194\39\19\126\220\248\198\140\247\65\106\103\80\161\245\8\16\237\59\74\195\142\153",288989326,3535364421} or {"\13\80\19\201\237\34\244\148\227\142\93\22\23\105\221\78\211\251\94\63\226\19\203\119\156\111\151\231\96\201\37\158\239\62\138\72\212\217\192\54\236\251\159\48\171\137\83\211\6\78\98\180\117\85\194\53\36\24\212\175\165\18\152\238\141\52\2\238\137\20\222\197\202\55\20\229\57\80\65\142\148\62\96\75\178\250\175\9\90\72\88\60\98\195\180\80\235\87\65\90\237\194\59\21\138\190\250\135\57\180\210\22\249\204\246\177\129\1\204\136\173\196\41\101\149\4\164\207\145\39\50\236\211\164\94\41\152\48\84\40\43\204\128\161\23\149\10\98\121\79\15\87\202\190\44\52\9\105\198\9\118\240\17\210\21\100\200\153\48\137\166\149\5\184\156\239\123\138\188\50\82\69\24\96\166\4\100\49\58\241\75\63\35\139\110\229\18\197\138\140\186\180\216\186\132\14\62\215\169\17\149\205\130\41\80\111\107\157\34\126\240\124\51\85\18\10\218\235\17\236\144\59\200\90\238\124\114\211\122\167\227\71\30\225\61\38\98\10\186\223\117\65\187\21\35\215\231\70\29\75\242\11\101\164\164\159\135\73\80\155\183\10\64\255\2\42\227\209\195\72\242\148\177\152\229\13\34\12\4\196\198\93\144\19\15\228\120\146\149\137\106\16\186\158\216",986520908,3209585492}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
