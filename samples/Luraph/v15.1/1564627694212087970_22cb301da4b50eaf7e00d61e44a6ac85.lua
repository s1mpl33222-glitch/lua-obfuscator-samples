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
local fresh=url.."?retry=bb7c4b855d50140c"
local retry=gsub(url,"/sha256/[a-f0-9]+/","/").."?retry=bb7c4b855d50140c"
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
local query="?p="..gsub('{"protocol":3,"loader_hash":"\50\50\99\98\51\48\49\100\97\52\98\53\48\101\97\102\55\101\48\48\100\54\49\101\52\52\97\54\97\99\56\53","\108\97\117\110\99\104\95\116\105\99\107\101\116":"\118\50\58\116\120\107\110\73\54\81\53\87\102\77\97\102\112\57\106\58\88\115\78\98\106\110\119\68\101\116\89\49\69\67\55\68\74\80\84\121\108\81\58\98\111\104\83\95\67\79\120\108\69\109\81\110\71\109\85\55\120\70\80\70\110\117\83\70\45\56\103\52\99\52\117\86\109\103\45\98\65\110\109\101\72\107\48\116\108\103\81\67\66\67\82\80\104\114\122\119\119\80\100\95\66\88\112\116\56\45\65\108\119\101\101\117\86\79\88\121\117\119\108\111\84\82\100\54\103\117\116\50\51\57\101\103\95\69\53\75\70\112\105\110\54\88\83\79\108\88\76\73\120\109\120\87\115\107\79\50\81\85\116\89\78\65\114\65\45\72\106\80\55\97\111\85\65\110\107\117\105\112\55\54\85\105\102\57\82\50\101\68\121\117\88\45\106\53\109\55\80\101\52\73\107\106\69\119\99\102\77\105\85\87\116\85\81\53\114\86\99\74\45\74\70\121\109\97\98\71\88\78\73\85\112\119\112\45\82\49\120\54\56","stage":"'..body,"[^%w]",function(c)return string.format("%%%02X",byte(c))end)
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
local handoff=alternate and {"\254\134\63\73\120\227\169\113\26\223\128\197\137\118\172\2\193\45\244\211\235\108\193\192\87\28\139\122\131\184\178\140\200\233\53\34\187\26\182\112\61\177\210\51\54\196\105\134\87\22\156\162\245\205\21\39\91\188\245\33\83\34\22\187\24\190\161\90\185\84\13\71\20\104\69\95\172\191\80\251\193\5\242\229\164\85\27\254\162\164\125\115\11\84\220\88\124\85\199\230\163\180\25\22\51\207\179\241\197\122\88\29\200\167\189\129\198\216\186\51\2\167\103\146\32\95\226\69\59\185\97\56\251\33\177\220\117\81\64\243\17\148\111\120\21\234\94\3\248\25\68\53\19\63\73\47\218\144\206\216\197\206\186\47\82\114\4\221\192\137\99\87\167\253\184\152\56\98\233\200\38\18\218\248\102\225\179\85\139\204\157\62\109\125\206\146\63\85\162\26\18\35\219\236\128\51\48\167\238\190\142\158\186\21\102\83\138\236\148\44\222\128\185\229\27\98\96\59\237\123\223\137\191\245\226\135\65\71\96\150\203\161\220\197\190\179\70\28\177\113\198\245\33\137\41\135\51\41\179\87\4\183\219\2\229\138\241\51\39\64\59\141\46\97\209\223\83\28\137\19\16\34\32\45\34\89\198\140\177\248\67\148\111\206\44\148\82\75\28\193\138\3\85\153\44\63\55",3136646362,624387164} or {"\239\70\184\128\130\214\213\165\198\133\254\67\56\65\69\243\24\44\85\67\12\239\71\4\219\242\250\125\6\156\135\141\179\120\134\10\152\102\62\222\114\17\21\34\41\10\39\98\196\208\86\13\51\34\192\54\185\88\86\85\246\195\171\228\119\241\26\195\198\81\200\225\118\111\117\135\37\208\198\47\247\190\76\184\115\178\53\130\174\178\7\220\48\189\162\53\170\132\45\147\202\21\36\201\33\165\217\102\89\23\78\92\75\147\156\167\70\22\9\218\70\164\202\174\16\78\1\249\220\186\207\149\21\77\48\123\228\130\225\132\68\116\20\63\216\139\163\234\242\129\128\62\9\37\15\179\175\152\37\166\197\29\191\159\152\21\196\211\1\222\226\218\15\158\138\50\24\211\180\61\132\14\123\45\37\131\83\47\181\157\253\2\208\22\43\224\167\127\238\54\167\221\220\37\14\57\1\131\30\205\251\161\35\158\178\61\36\253\132\109\37\119\48\6\79\30\133\2\168\54\207\81\163\57\244\162\178\216\193\52\22\255\205\90\78\135\178\175\222\11\52\244\19\55\168\149\254\54\159\189\109\157\17\134\65\212\135\156\210\254\121\87\24\147\178\170\133\221\155\168\59\249\0\134\19\242\238\145\165\184\104\191\30\214\3\95\52\105\216\18\236\38\131\115\189",450952418,314730091}
local function publish(target)
if type(target)=="table"then pcall(rawset,target,"_bsdata0",handoff)end
end
publish(environment)
publish(globals)
_bsdata0=handoff
pcall(function()publish(getfenv(runtime))end)
handoff=nil
return runtime(credential)
