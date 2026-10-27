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
local fresh=url.."?retry=2d66555806f9cc90"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=2d66555806f9cc90"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\74\83\79\80\117\53\99\101\74\69\98\53\120\67\121\111\58\71\89\49\88\65\72\104\104\73\114\122\66\107\112\66\107\79\66\103\87\113\119\58\48\87\83\104\116\120\82\69\77\56\66\110\88\116\76\109\68\107\66\84\76\66\87\66\51\88\119\49\80\122\56\105\48\45\99\119\72\74\120\65\49\74\99\103\112\90\45\52\66\84\90\114\115\84\111\72\82\84\72\98\86\45\73\102\116\110\50\84\75\119\121\90\120\69\82\67\106\105\122\70\119\45\79\115\54\109\118\75\71\50\53\109\75\75\57\98\79\110\108\74\72\48\119\120\112\78\104\81\102\55\117\84\87\119\75\52\50\114\78\73\89\48\74\72\121\75\77\113\50\119\99\51\69\100\54\102\74\54\70\55\51\114\54\71\115\74\45\56\89\89\118\97\109\76\66\105\85\70\72\51\114\90\53\52\57\77\80\99\99\113\45\121\85\120\112\85\51\54\111\83\118\81\117\53\45\70\48\115\100\84\81\110\95\56\76\104\69\57\53\106","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\152\169\152\93\54\144\35\176\21\238\48\118\168\219\164\163\17\114\104\27\32\102\137\99\50\22\228\50\190\84\122\165\34\76\20\252\59\108\197\240\116\77\111\241\176\66\24\5\141\105\233\197\119\234\164\201\121\116\44\39\144\80\185\60\22\118\100\18\169\60\59\199\169\93\96\251\24\46\90\240\117\72\213\249\96\196\47\240\154\177\161\61\222\147\95\209\75\224\249\12\140\86\117\53\22\199\125\71\86\189\1\209\132\168\1\11\88\235\38\209\5\46\96\106\71\46\158\79\61\56\161\34\75\132\247\221\78\56\32\68\87\187\86\98\40\174\240\42\53\26\100\172\90\168\190\146\50\225\176\47\156\35\157\135\95\90\241\162\51\75\64\45\39\139\211\238\88\231\20\121\98\186\244\110\13\148\70\57\217\127\229\129\8\85\21\17\56\230\29\70\155\172\75\193\152\224\211\131\149\158\168\98\186\21\147\128\211\235\132\1\59\235\154\233\2\174\186\28\126\230\150\82\59\5\90\6\239\51\169\113\92\200\198\254\101\46\140\200\178\150\200\182\126\114\221\21\192\14\223\29\37\8\241\219\147\107\243\159\87\109\14\89\82\122\98\101\150\92\204\108\104\59\39\20\236\86\86\18\146\24\154\82\22\233\39\189\224\137\73\7\230\58\117\86\141\254\137",3598146611,1129799808} or {"\238\84\228\68\7\22\105\92\31\210\133\19\13\239\187\231\100\243\7\174\202\105\160\207\122\27\223\125\83\247\137\160\199\207\38\186\156\52\22\167\82\119\168\148\50\234\77\186\97\131\129\60\235\188\108\204\60\242\9\211\249\91\184\170\93\194\135\59\160\44\106\36\141\57\28\128\24\246\41\50\114\254\51\89\142\251\159\231\4\127\154\88\240\75\87\175\132\29\37\217\157\224\121\214\96\249\34\168\49\189\31\88\184\88\197\125\119\195\14\215\53\100\112\88\193\12\149\248\125\92\39\175\183\223\65\160\84\206\85\61\33\28\34\87\95\161\215\110\109\96\110\206\173\91\112\116\172\140\174\90\239\82\6\97\31\155\28\235\70\147\69\130\18\236\62\123\109\71\194\201\112\133\248\39\43\184\90\77\77\227\191\103\142\170\115\120\1\206\104\156\169\81\97\133\47\115\201\184\218\119\172\10\26\36\246\200\38\231\220\19\128\116\221\189\9\59\225\158\108\208\71\119\137\96\140\51\61\158\77\35\3\108\179\208\161\17\66\39\226\116\102\22\251\99\120\224\194\41\117\89\223\42\65\168\12\203\133\19\224\213\73\170\41\161\184\19\197\126\75\43\10\129\196\76\181\29\155\136\116\181\47\237\175\204\141\213\17\71\231\175\10\230\199\171\206",2457547093,827482767}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
