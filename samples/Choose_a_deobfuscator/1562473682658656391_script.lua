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
local fresh=url.."?retry=b31b75b423e698ee"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=b31b75b423e698ee"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\97\53\48\53\102\53\97\56\97\99\57\57\56\51\102\53\101\52\52\51\98\99\100\57\102\53\102\98\49\100\98\102","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\119\111\118\65\103\52\85\80\109\73\73\83\66\87\77\88\58\68\100\86\71\119\103\99\112\101\100\57\100\81\100\74\75\95\56\79\116\116\65\58\79\95\50\84\121\65\115\72\115\102\112\71\81\122\48\50\55\107\88\110\120\78\66\85\102\88\112\117\50\88\105\68\111\106\101\73\97\100\55\56\50\71\89\75\67\106\79\83\66\120\48\112\82\54\68\55\86\85\65\106\68\68\70\103\81\110\69\76\73\84\112\84\86\112\89\52\102\103\99\53\117\48\106\67\51\117\56\99\110\65\50\106\107\68\100\56\81\119\109\45\118\67\70\106\48\95\82\55\122\112\111\98\81\105\80\83\77\79\50\45\85\104\52\71\118\98\102\82\65\114\53\98\97\54\73\110\121\55\57\77\111\87\85\100\97\121\100\65\65\106\89\100\74\103\49\114\110\99\54\52\80\66\116\76\80\119\57\56\55\105\73\109\83\55\97\111\104\103\97\79\78\108\106\74\72\52\71\105\55\105\99\112\82\70\105\67\56\88\55\85","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\92\206\10\141\178\112\197\107\83\193\79\2\168\186\16\170\214\16\218\220\10\40\44\151\20\87\85\54\90\170\167\85\226\248\177\147\165\117\110\11\11\117\78\202\90\95\124\58\114\148\236\65\138\176\55\2\178\54\190\73\195\181\77\174\147\56\248\94\61\121\77\35\30\215\56\98\21\3\108\251\94\145\189\77\227\22\225\135\36\22\30\37\39\37\185\64\39\2\173\116\154\255\185\254\144\167\252\230\73\252\227\45\150\108\250\44\156\149\115\236\226\236\150\13\131\246\8\217\38\45\254\10\80\101\185\66\153\242\245\178\219\121\158\72\41\238\226\253\131\211\109\102\29\62\39\43\52\226\107\169\117\243\150\41\106\36\78\158\122\228\69\169\84\32\53\65\157\224\191\40\203\161\99\239\101\80\55\243\47\226\38\248\135\55\190\109\187\254\3\24\109\216\35\120\1\54\25\176\167\229\215\181\243\36\86\253\161\59\242\190\187\229\43\223\219\244\14\111\255\63\57\133\118\151\207\186\189\44\195\17\78\0\148\154\196\128\128\240\244\70\67\204\28\187\211\175\186\103\98\70\54\181\92\215\238\211\233\51\9\31\49\194\76\7\108\85\19\176\145\244\212\77\80\102\191\10\180\246\19\208\29\187\136\110\68\253\82\125\197\233\124\155\137\253\123\74\168",2828700947,1171546622} or {"\154\198\211\157\197\211\219\7\92\10\86\80\84\120\235\80\22\23\242\248\131\97\96\238\165\231\198\210\137\6\91\60\59\63\35\223\122\117\185\197\117\80\188\6\151\219\244\46\94\91\94\171\250\153\170\41\56\34\254\213\79\16\70\101\246\61\104\241\232\210\1\14\1\97\178\176\195\151\11\22\10\175\180\254\56\129\192\137\97\103\4\129\224\165\32\157\239\221\92\181\40\189\93\164\112\233\12\115\12\5\193\134\132\60\173\153\238\154\88\252\139\195\222\36\229\57\205\204\5\29\182\178\119\108\246\218\216\2\234\20\191\233\194\119\36\4\225\135\136\219\162\148\237\208\71\92\254\146\104\183\87\169\234\126\191\208\163\192\247\252\143\239\37\184\72\66\129\49\132\107\64\155\99\116\53\114\113\3\192\128\166\34\79\90\222\192\128\90\73\147\223\230\230\71\7\21\99\118\247\140\9\137\71\30\42\26\58\17\213\5\151\102\84\97\142\105\251\210\129\109\229\100\64\160\79\43\111\86\69\89\53\211\77\131\178\46\149\233\102\155\52\21\139\240\174\137\22\190\115\41\185\150\63\213\60\230\120\149\101\34\102\94\132\173\114\167\155\79\90\246\212\44\50\50\144\56\111\12\33\204\17\234\6\119\255\25\226\24\78\82\151\234\128\138\134",1446835117,844063757}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
