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
local fresh=url.."?retry=0accb497daad76c7"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=0accb497daad76c7"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\57\101\98\55\101\98\52\54\98\50\101\53\50\49\49\56\49\57\97\102\57\53\49\53\50\54\51\53\101\55\49\97","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\56\104\78\110\70\65\50\116\70\120\70\98\83\81\69\115\58\109\102\104\109\56\56\98\55\69\72\113\101\83\84\69\99\79\89\85\67\55\65\58\106\95\68\84\67\70\119\56\73\104\75\48\68\111\77\121\119\67\115\115\116\101\75\111\99\86\107\97\100\82\84\98\69\108\105\56\105\68\106\45\73\55\84\49\84\67\118\72\69\100\109\73\104\118\45\68\95\99\118\68\77\118\56\45\72\110\114\85\112\68\114\113\113\78\49\102\84\49\102\75\86\108\119\81\117\95\76\79\101\56\50\102\120\87\48\50\51\121\52\68\78\95\65\114\83\75\76\88\85\77\116\54\70\73\121\56\72\87\79\83\69\88\79\122\75\84\121\45\99\70\82\84\111\99\112\89\45\55\97\77\109\104\106\114\70\53\103\105\49\57\70\104\55\45\57\114\82\74\102\45\100\88\86\113\107\48\65\82\122\68\115\68\111\80\105\95\118\80\73\107\98\55\53\120\83\105\69\84\70\120\122\121\51\67\83\111\117\50\113\68","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\91\244\134\27\172\139\136\26\66\34\158\143\11\30\228\224\196\119\218\232\135\161\70\51\55\6\62\229\54\170\146\109\246\98\46\205\204\156\161\140\155\188\35\228\76\8\229\197\216\158\11\67\6\194\22\197\239\74\144\71\15\104\58\188\165\116\100\56\57\120\124\230\195\189\130\241\69\57\67\92\9\207\177\71\102\244\125\68\136\155\207\29\210\178\169\111\159\32\36\140\149\13\81\64\107\168\111\33\37\229\6\160\14\187\190\192\92\249\158\218\88\77\99\109\107\224\193\58\176\229\162\212\194\134\211\141\27\120\156\126\54\151\52\187\243\8\104\224\35\173\201\41\126\56\20\122\92\212\201\93\128\8\239\236\20\187\254\196\120\161\181\213\52\23\79\227\119\234\223\167\206\143\50\217\57\17\238\191\112\140\80\175\221\202\237\204\210\45\149\98\222\187\229\218\91\91\97\116\236\164\140\95\106\101\25\83\211\190\1\126\240\164\26\203\173\54\132\143\194\149\196\7\251\231\236\140\67\4\47\25\222\62\250\225\248\0\37\50\188\17\245\33\7\121\36\185\97\208\89\198\182\107\1\129\80\39\188\71\106\203\48\110\196\125\20\43\123\56\101\140\163\62\226\211\162\14\27\158\70\82\95\238\196\192\59\216\39\181\117\177\185\84\55\222\233\67\38",3468694877,3255787777} or {"\203\243\127\1\48\229\27\188\43\119\97\12\152\115\91\97\68\88\147\171\83\255\190\4\111\122\26\125\34\47\248\235\49\69\148\106\127\150\5\237\252\9\222\126\253\228\6\186\240\167\226\174\41\203\14\66\251\197\89\164\165\255\181\121\232\183\55\130\159\0\46\62\89\179\245\92\123\239\150\151\94\127\165\179\245\150\49\124\20\70\66\67\168\181\111\231\38\224\177\169\57\221\186\252\172\142\160\21\205\96\12\70\157\238\15\31\168\169\159\236\112\62\53\232\62\15\50\48\255\128\29\11\30\74\14\146\218\211\163\178\226\44\34\180\132\244\26\223\21\17\40\174\114\175\48\189\156\175\107\117\220\110\6\34\49\70\195\189\129\68\212\65\72\89\12\228\98\122\58\51\123\215\5\107\220\93\141\172\140\207\126\161\83\50\127\56\208\83\92\67\178\59\62\76\169\151\139\232\21\158\215\237\136\39\16\165\172\203\7\34\184\45\185\67\99\42\194\69\134\104\106\25\69\11\140\195\154\182\144\137\44\50\190\209\91\200\93\102\19\234\205\101\178\214\246\110\145\193\30\232\245\185\203\214\250\24\67\184\102\53\32\62\33\79\45\251\222\208\20\88\246\10\227\8\234\108\94\82\226\130\253\90\104\82\162\186\255\213\182\198\23\246\161\131\115",3273691519,2967102224}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
