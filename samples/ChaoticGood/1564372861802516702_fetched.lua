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
local fresh=url.."?retry=69b968c3b65462c3"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=69b968c3b65462c3"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\84\65\114\95\50\56\95\51\89\80\85\48\101\116\89\78\58\52\110\73\103\73\88\57\120\86\122\76\50\97\110\71\75\74\112\102\57\71\103\58\48\119\104\122\66\109\53\107\70\120\81\52\105\78\89\51\105\113\107\117\75\77\57\101\109\70\103\66\80\54\48\79\85\75\51\109\75\72\57\98\69\49\84\48\54\52\57\95\110\112\104\83\105\122\107\68\106\112\65\73\110\104\81\120\74\90\57\69\108\81\53\80\86\115\55\121\50\112\100\74\52\53\81\52\106\85\81\78\116\87\113\119\78\67\102\55\55\115\68\57\66\77\87\109\101\79\73\111\74\68\49\113\71\119\73\110\99\51\109\101\67\85\67\71\98\71\83\65\50\109\80\83\81\66\53\117\55\84\80\117\86\81\82\75\102\116\90\98\65\68\53\108\48\122\89\109\71\70\78\111\80\111\55\81\111\118\51\119\118\52\74\106\115\95\114\45\104\71\79\101\75\74\72\76\76\95\81\89\57\112\104\108\106\45\78\113\55\107\53\53","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\29\60\183\118\228\102\99\213\108\125\245\21\43\149\105\161\85\204\246\63\173\68\211\106\104\210\193\108\85\98\58\98\16\112\3\65\55\117\71\233\79\247\80\40\75\89\239\161\83\51\78\80\64\66\185\195\120\179\109\161\95\11\30\180\184\166\8\132\216\4\125\39\177\39\185\207\52\254\19\229\59\148\170\69\98\163\55\190\58\10\121\50\233\128\187\132\155\212\171\225\34\92\201\239\154\105\239\209\203\218\35\31\247\128\97\98\84\156\54\104\61\57\27\186\163\232\110\202\104\138\92\91\186\195\4\91\206\170\47\139\68\147\80\85\206\16\125\180\50\212\238\160\41\62\84\2\173\217\79\107\228\152\206\41\112\173\118\189\192\86\107\94\111\254\39\230\198\7\16\172\172\212\239\197\156\7\61\50\3\176\156\73\175\111\122\198\52\87\194\112\31\190\156\124\58\164\197\175\89\74\127\82\169\113\243\24\36\146\57\195\75\167\243\236\83\88\104\31\109\70\213\63\137\197\78\201\107\233\66\171\34\35\120\155\215\141\150\183\139\186\200\66\144\23\8\249\34\212\210\97\184\42\41\140\107\112\193\72\6\234\91\31\112\131\108\154\121\120\10\66\189\114\92\55\201\177\131\118\20\82\179\45\152\83\134\57\232\86\62\11\34\174\144\146\151\34\172",1622218805,2272878616} or {"\49\78\103\128\118\86\77\179\54\84\146\112\227\228\255\177\110\83\116\171\110\6\228\208\251\81\35\30\111\11\189\91\181\136\208\212\120\158\10\10\209\33\23\56\89\243\36\131\59\131\180\130\25\213\202\70\72\147\178\130\153\45\95\43\37\92\31\163\54\202\199\166\128\149\102\59\40\207\79\233\63\129\43\166\189\178\81\64\21\67\48\31\243\35\199\68\173\163\234\220\134\217\61\35\159\108\168\220\52\204\48\37\81\53\190\206\156\43\21\252\152\207\145\50\107\180\143\61\36\220\53\211\27\125\233\115\196\75\66\124\215\3\202\147\97\90\169\210\100\2\145\185\177\65\101\23\41\164\248\85\141\227\24\125\159\173\236\25\185\87\99\197\8\150\154\200\173\238\223\29\114\56\213\243\12\125\116\41\169\113\192\148\23\174\94\124\211\231\215\45\65\128\60\140\35\8\222\75\255\10\129\192\141\85\185\133\199\187\180\250\236\143\191\246\69\84\34\64\189\59\166\154\96\199\185\115\36\9\49\89\49\162\32\109\105\167\252\198\99\53\83\81\175\161\32\121\118\27\55\197\225\10\146\93\195\100\183\246\118\53\12\110\222\194\200\37\114\122\32\35\221\155\229\252\209\195\31\83\167\165\50\89\224\55\140\88\254\38\241\235\118\91\24\146\101",3388708080,1970561575}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
