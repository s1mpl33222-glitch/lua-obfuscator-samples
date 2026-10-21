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
local fresh=url.."?retry=8a40e1f06581d2b1"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=8a40e1f06581d2b1"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\53\54\57\53\56\52\55\54\49\99\100\100\54\99\49\99\102\52\102\98\98\48\56\51\57\100\52\101\50\50\55\98","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\49\83\102\86\52\97\52\68\56\56\114\95\53\105\52\71\58\70\48\53\51\106\88\122\75\75\50\54\79\79\50\65\98\98\74\56\85\112\81\58\121\54\69\67\102\98\57\108\97\75\79\98\75\106\67\95\107\98\109\82\88\113\79\116\56\105\53\112\100\81\71\99\109\108\85\122\70\89\74\51\117\98\101\121\104\72\87\53\114\83\121\101\106\109\52\85\67\114\116\57\117\113\110\82\66\68\50\72\113\78\68\112\113\103\110\107\119\72\97\54\90\100\48\65\99\105\121\74\55\79\87\72\70\118\70\70\80\120\105\109\81\110\77\83\65\55\99\66\99\77\122\83\120\55\71\48\49\84\103\121\87\70\86\101\101\53\115\72\69\66\74\69\74\121\77\122\84\79\70\71\121\55\53\104\56\82\67\71\120\81\108\111\101\86\73\106\112\120\52\69\74\95\69\54\99\76\52\78\98\106\88\104\69\86\75\54\103\49\115\87\65\80\49\104\89\73\57\118\115\101\55\89\117\116\70\108\45\114\53\95","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\113\180\202\213\24\38\33\231\138\185\68\93\26\237\94\142\15\25\251\22\132\13\134\159\27\191\14\139\120\147\125\2\115\31\182\124\209\59\184\254\114\36\144\166\204\9\60\96\89\0\166\158\151\182\190\50\129\107\89\19\188\242\161\236\211\215\44\127\185\249\184\219\135\157\164\190\69\200\107\236\69\208\40\38\209\11\83\113\187\94\19\47\181\229\4\66\123\148\107\42\105\118\70\85\64\203\79\193\104\152\118\75\226\228\37\112\232\192\167\145\133\41\195\86\223\102\192\23\16\128\169\252\135\48\175\234\235\9\84\87\45\114\120\203\150\210\120\161\239\253\210\186\142\242\43\49\196\129\180\250\0\33\231\241\145\20\211\137\191\17\112\149\74\53\146\16\88\132\225\107\203\176\252\240\223\242\35\22\190\181\186\113\19\171\79\80\200\141\101\101\39\36\150\161\164\49\27\74\120\101\133\199\142\7\113\34\58\95\112\44\24\32\158\81\169\245\203\168\93\55\54\85\82\123\136\88\157\207\193\178\18\254\6\134\146\240\195\253\144\150\29\96\82\146\22\180\253\220\198\78\20\207\216\181\119\54\44\15\55\230\104\214\107\226\73\182\109\157\0\193\130\254\172\161\139\11\221\220\96\198\128\51\90\96\98\24\37\195\177\43\42\29\171\45\160\140\210",1260346174,3100532982} or {"\109\168\24\166\232\55\3\170\246\24\36\11\51\80\22\72\80\129\16\110\191\245\53\182\47\41\197\108\164\84\222\186\170\84\168\153\173\132\17\72\229\33\146\215\148\211\249\66\8\206\110\242\51\71\226\242\253\94\44\190\24\190\83\231\98\234\132\49\147\196\95\125\178\82\94\82\167\135\84\202\88\7\205\14\115\172\254\244\13\237\111\60\47\16\197\191\223\143\158\175\234\13\198\92\62\91\239\67\174\225\20\66\56\226\30\234\131\35\20\212\99\118\122\148\109\48\18\169\137\41\133\149\172\216\175\112\208\31\78\27\74\89\72\18\188\176\23\5\16\204\21\138\131\179\255\244\122\84\205\229\112\21\4\221\158\196\161\121\116\214\35\200\180\181\183\155\141\40\34\7\139\226\245\21\128\81\18\92\66\229\22\106\13\215\148\128\129\127\35\228\157\124\179\249\22\62\62\42\104\231\223\229\103\48\30\116\238\221\149\253\79\156\192\127\206\201\230\14\112\216\4\250\87\11\200\183\149\48\25\57\245\144\193\43\193\42\4\91\244\14\13\135\119\64\47\226\65\6\186\209\200\19\103\41\6\225\161\69\37\226\123\82\226\157\170\60\116\130\17\74\114\54\243\76\149\47\146\194\35\43\76\255\155\206\61\173\148\174\245\224\227\127\253\107\53",1303438193,2798215941}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
