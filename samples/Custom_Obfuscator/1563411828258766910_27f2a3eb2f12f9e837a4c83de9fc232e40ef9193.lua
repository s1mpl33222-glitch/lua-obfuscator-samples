return (function(...)
local _zkgK=0;
if type(print)~="function" or type(string.char)~="function" then _zkgK=(_zkgK+1)%256 end;
local _zkgGMV1={request=function() return request end,writefile=function() return writefile end,readfile=function() return readfile end,isfile=function() return isfile end,loadfile=function() return loadfile end,loadstring=function() return loadstring end,getgenv=function() return getgenv end,http_request=function() return http_request end,syn=function() return syn end,game=function() return game end,wait=function() return wait end,task=function() return task end,require=function() return require end,print=function() return print end,warn=function() return warn end,error=function() return error end,pcall=function() return pcall end,xpcall=function() return xpcall end,select=function() return select end,type=function() return type end,typeof=function() return typeof end,tostring=function() return tostring end,tonumber=function() return tonumber end,tick=function() return tick end,time=function() return time end,os=function() return os end,math=function() return math end,string=function() return string end,table=function() return table end,coroutine=function() return coroutine end,bit32=function() return bit32 end,debug=function() return debug end,getfenv=function() return getfenv end,setfenv=function() return setfenv end};
local function _zkgFLG0(_zkgLTB17)
local _zkgLKJ18=getgenv and getgenv()
if type(_zkgLKJ18)=="table" and _zkgLKJ18[_zkgLTB17]~=nil then return _zkgLKJ18[_zkgLTB17] end
_zkgLKJ18=getrenv and getrenv()
if type(_zkgLKJ18)=="table" and _zkgLKJ18[_zkgLTB17]~=nil then return _zkgLKJ18[_zkgLTB17] end
if type(_G)=="table" and _G[_zkgLTB17]~=nil then return _G[_zkgLTB17] end
if _zkgGMV1[_zkgLTB17] then return _zkgGMV1[_zkgLTB17]() end
return nil
end;
local _zkgCJS2="090045004135184153136228159141082126001139151203092004212163121187245023015040093130023230174174194168100241053073139147145228051016248016106217119166217194019198085052114219242204197233119023";
local function _zkgXBA3(_zkgLAL19,_zkgLPQZ)
local _zkgLDZ1A=0
for _zkgLWE1B=0,7 do
if _zkgLAL19%2~=_zkgLPQZ%2 then _zkgLDZ1A=_zkgLDZ1A+2^_zkgLWE1B end
_zkgLAL19=math.floor(_zkgLAL19/2) _zkgLPQZ=math.floor(_zkgLPQZ/2)
end
return _zkgLDZ1A
end;
local function _zkgYRH4(_zkgLQKQ,_zkgLBZ1C)
local _zkgLKQ1D=((_zkgLQKQ*17+_zkgLBZ1C*5+131)%64)*3+1
local _zkgLCNS=(tonumber(_zkgCJS2:sub(_zkgLKQ1D,_zkgLKQ1D+2))+_zkgLQKQ)%256
if _zkgLCNS==0 then _zkgLCNS=1 end
return _zkgLCNS
end;
local function _zkgDQXN(_zkgLBKP,_zkgLQKQ,_zkgLQOR)
local _zkgLCNS=_zkgYRH4(_zkgLQKQ,_zkgLQOR)
local _zkgLHTT=_zkgLQKQ
local _zkgLGMU=(_zkgLCNS*37+_zkgLHTT*91+_zkgLQOR*13)%256 if _zkgLGMU==0 then _zkgLGMU=1 end
local _zkgLGFV=(_zkgLCNS*131+_zkgLQOR*17+_zkgLHTT*29)%256
local _zkgLZZW=(_zkgLGMU*53+_zkgLHTT*17)%256
local _zkgLWDX={}
for _zkgLNCY=0,#_zkgLBKP/2-1 do
_zkgLGFV=(_zkgLGFV*73+_zkgLNCY*11+_zkgLCNS)%256
_zkgLZZW=(_zkgLZZW*47+_zkgLNCY*19+_zkgLGMU)%256
local _zkgLPQZ=tonumber(_zkgLBKP:sub(_zkgLNCY*2+1,_zkgLNCY*2+2),16)
local _zkgLAV10=(_zkgLHTT*31+17+_zkgLNCY*13)%256 if _zkgLAV10==0 then _zkgLAV10=1 end
_zkgLPQZ=((_zkgLPQZ%16)*16+math.floor(_zkgLPQZ/16))%256
_zkgLPQZ=_zkgXBA3(_zkgLPQZ,_zkgLAV10)
_zkgLPQZ=(_zkgLPQZ-_zkgLZZW)%256
_zkgLPQZ=_zkgXBA3(_zkgLPQZ,_zkgLGFV)
_zkgLPQZ=(_zkgLPQZ-_zkgLCNS-_zkgLQOR-_zkgLHTT*7-_zkgLNCY*3)%256
_zkgLWDX[#_zkgLWDX+1]=string.char(_zkgLPQZ)
end
return table.concat(_zkgLWDX)
end;
local function _zkgDQBO(_zkgLBKP,_zkgLQKQ,_zkgLQOR)
local _zkgLCNS=_zkgYRH4(_zkgLQKQ,_zkgLQOR)
local _zkgLWDX={}
for _zkgLNCY=0,#_zkgLBKP/2-1 do
local _zkgLPQZ=(tonumber(_zkgLBKP:sub(_zkgLNCY*2+1,_zkgLNCY*2+2),16)-(_zkgLCNS*11+_zkgLQKQ*3+_zkgLNCY*7+_zkgLQOR)%256)%256
_zkgLWDX[#_zkgLWDX+1]=string.char(_zkgLPQZ)
end
return table.concat(_zkgLWDX)
end;
local _zkgTQW11={
[1]=function() return _zkgDQBO("34394f4a5e59",0,_zkgK) end,
[7]=function() return _zkgDQBO("948890a1a1",6,_zkgK) end,
[13]=function() return _zkgDQBO("c4",12,_zkgK) end,
[19]=function() return _zkgDQBO("e0",18,_zkgK) end,
[25]=function() return _zkgDQBO("596166647070",24,_zkgK) end,
[31]=function() return _zkgDQBO("fb0e15180e28223540374c54",30,_zkgK) end,
[37]=function() return _zkgDQXN("164f6d0d153b32cb1ab2c7d207345a65",36,_zkgK) end,
[43]=function() return _zkgDQXN("849de72c8615",42,_zkgK) end,
[49]=function() return _zkgDQBO("4a627c7f5e7a828c9a",48,_zkgK) end,
[55]=function() return _zkgDQXN("f78af29436cd11ea7a",54,_zkgK) end,
[61]=function() return _zkgDQXN("0228bb3093",60,_zkgK) end,
[67]=function() return _zkgDQBO("132b454827434b5563",66,_zkgK) end,
[73]=function() return _zkgDQXN("b266fbbbd24737",72,_zkgK) end,
[79]=function() return _zkgDQXN("a58c2df3",78,_zkgK) end,
[85]=function() return _zkgDQXN("",84,_zkgK) end,
[91]=function() return _zkgDQBO("46686c72723289819aa1acabb5ae7f",90,_zkgK) end,
[97]=function() return _zkgDQXN("95ac5906bf970440c85bfbad5c2bdebd50473b607b6f9e7bc61181ffd67c20536d5f8c05741a99460bead31cb1097d4b47674dd24905c511e69528e849613a1f3140c10a0756cc680fabf071a36f9d99",96,_zkgK) end,
[103]=function() return _zkgDQBO("d2161a2e24f505070c481e282f37376d4a4a509490aaa2b7bf91cdcfd2d3e3b9b8bfc2fdd4da0e18f1fb0236103f4a2324323a40704e535d8e966e747aafbbc09acbd5dce1bbbeccfcd7e0e3e7f2fe02",102,_zkgK) end,
[109]=function() return _zkgDQXN("5c2d190dff191d9b9139c56146bd06b03fbef1e7b6605afc8e99c6779b71e7d744746c290f8dfcedab6898fce6ce2eb006466479cd65faac9f24c96fdf7093c4705882be1b6b45cfa062056aedb99a12",108,_zkgK) end,
[115]=function() return _zkgDQBO("74b8bcd0c697a8d8aeb6bdf8cb02dddfeef3f236324c445961336f717475855b8a62676a75ab86ba92c8a3a7dbb2bbc7ccd5d9de131bf5fc013a0e1319265c603b3d487c5a5f936e7478b1848a9897a6",114,_zkgK) end,
[121]=function() return _zkgDQBO("83c7cbdfd5a6e3bcbccafe03d8e2e9f1f4fe0145415b536870427e808384946a669c7b7cb6898e96d1a8dbb7bfc2f9cfd5e2ea1c222cff360e1a4b2730633b41454c855a699b6f77b2b5bb94cca8aae1",120,_zkgK) end,
[127]=function() return _zkgDQBO("4b8f93a79d6e797e8d93c49cd6aadfb6eec7c90d09231b30380a46484b4c5c325d373e437b84575d6b72a4ae838c96c9d0a8afb8eec1f9ffd8e1ebf2f5fb060b12174b2a2a363d71447d838a679c72a8",126,_zkgK) end
};
local _zkgTQK12={
[2]=function() return _zkgDQBO("a8adc3bdc2d2e1",1,_zkgK) end,
[8]=function() return _zkgDQBO("2d41484c56",7,_zkgK) end,
[14]=function() return _zkgDQXN("6c",13,_zkgK) end,
[20]=function() return _zkgDQXN("0a",19,_zkgK) end,
[26]=function() return _zkgDQBO("6e81888b95635f66a2aebfb6c9d3cc9dd9ecf1baf30909d6251a1e2b39404352151e2931353c494f57585d6672777b828f909a9ba1baeebec1fb12e7daf503330e193a552a2e3a2f713b5f62878c7478866e9e9a94b0ccd9d6caf3c5f8c5fd0bf2221fff34fb3610344637425c665e454e6f65999b72b3a0bd",25,_zkgK) end,
[32]=function() return _zkgDQXN("018d5a04d62843",31,_zkgK) end,
[38]=function() return _zkgDQBO("3c5f5b7a6d8189",37,_zkgK) end,
[44]=function() return _zkgDQBO("1a4d435655",43,_zkgK) end,
[50]=function() return _zkgDQXN("5ff7b0110ecdd5a6d4e1425a8cc351dd8f00a1553f9fa8466bf0a8113b7451e842c58c",49,_zkgK) end,
[56]=function() return _zkgDQBO("",55,_zkgK) end,
[62]=function() return _zkgDQBO("9f9a9bced8dbd9ed",61,_zkgK) end,
[68]=function() return _zkgDQBO("a8c7d4d2d194f4f1feb0f903c5231c262d313d3dfd585a126c6575723595929fa35883afc0b7cad4cd90ecf1eafe01fb0e0dcf2a2ce43f3a3e004a605a5d77798357",67,_zkgK) end,
[74]=function() return _zkgDQBO("3f6b7c738690894ca8ada6babdb7cac999a0a7",73,_zkgK) end,
[80]=function() return _zkgDQBO("d2fefcf8ba1a172428dd0834453c4f59521571766f83868093926e",79,_zkgK) end,
[86]=function() return _zkgDQBO("2656635b6f246c328f819397995cb8bdb6cacdc7dad99baaf6f10fbed9dcd31d29294149061e",85,_zkgK) end,
[92]=function() return _zkgDQBO("e6f1",91,_zkgK) end,
[98]=function() return _zkgDQXN("27848644cd5350cfdacd336e0435f8c6dbfd67ae09cf4bd9d15a3eda6f7c53b2cff51f3dcbd77072e7f58d410c0bee35ed6dc146c01174779d15d8e4d03f89fc4939c63536f012ae42393fedc598c00d",97,_zkgK) end,
[104]=function() return _zkgDQBO("d014182c22f3fc33104219532e323c3a457c4e928ea8a0b5bd8fcbcdd0d1e1b7e5b8c5f9fedae4e41df80001383d441e2129646871487c548f62996fa68385bb969ca0d9b4b9bdf7ced8dc1319f52801",103,_zkgK) end,
[110]=function() return _zkgDQBO("03474b5f5526303a44497f865b689a9e7c8281c5c1dbd3e8f0c2fe00030414eaedf1f4fa040a161e4f2560343c704b4e5d8d969a72a980b6bf9a9da8abb2ecbdc6d3d30d12192127000b131a19262a61",109,_zkgK) end,
[116]=function() return _zkgDQBO("72b6bacec495ced9b2b6b9c7cdffd512e6eef034304a42575f316d6f727383595563979c76aa838bbe999ed1abe3e7c3c7fdda0be019f3fc31060a1417542b2d373a434980895d986b767e89bb959ad2",115,_zkgK) end,
[122]=function() return _zkgDQXN("8da8252c6174ad3a6ef6287da0120d1fae6a0348adaaa97e35bbd3bb0859bd9733479bfe75cac35b61fc221ba54a034fa662e5dc773ce2c14fffe687a526f56d51618538c91ca1274af3fc2b2e0b254b",121,_zkgK) end,
[128]=function() return _zkgDQXN("af6389a88aba87f1b5f74157089d56a8b1cce88bc5ee8af79470b93ea9589453b504524aa4f7441d5ee2a1950315351b549cf8cebfd237fbf21085a5f16c32cfb6fe21ea86d44f33f43c4cbc60272ae9",127,_zkgK) end
};
local _zkgTRE13={
[3]=function() return _zkgDQBO("b2abb9b9bed6",2,_zkgK) end,
[9]=function() return _zkgDQBO("434f5c545d6f6d7f8b39838f9398a763b0b2c1cbcbd1",8,_zkgK) end,
[15]=function() return _zkgDQBO("47",14,_zkgK) end,
[21]=function() return _zkgDQXN("a2",20,_zkgK) end,
[27]=function() return _zkgDQBO("d6d7eae9",26,_zkgK) end,
[33]=function() return _zkgDQBO("8f839c9b",32,_zkgK) end,
[39]=function() return _zkgDQBO("77a1969dad99b2c6d1cbccd5",38,_zkgK) end,
[45]=function() return _zkgDQXN("3af3b7fda5055e00",44,_zkgK) end,
[51]=function() return _zkgDQBO("19314b4e235767",50,_zkgK) end,
[57]=function() return _zkgDQBO("28405a5d326c72797b81",56,_zkgK) end,
[63]=function() return _zkgDQBO("f00822250420283240",62,_zkgK) end,
[69]=function() return _zkgDQXN("51c99e923d465b9e6dfc",68,_zkgK) end,
[75]=function() return _zkgDQBO("",74,_zkgK) end,
[81]=function() return _zkgDQXN("8d935796",80,_zkgK) end,
[87]=function() return _zkgDQXN("6f2392d2e7ec8350c8d0aa7a414045473f53a10f4a5b7e5e582648a38b495fd141",86,_zkgK) end,
[93]=function() return _zkgDQXN("3a",92,_zkgK) end,
[99]=function() return _zkgDQBO("1e62667a704150545d676a7574ac858d98c89ce0dcf6ee030bdd191b1e1f2f05350d141a21265e3537734a51845f656a70ac83b8c0959bd6ddb1b8c1c4ffd7e0e01beef6fe0a0a441a1e28356741454f",98,_zkgK) end,
[105]=function() return _zkgDQXN("6096aeb08d6d104fc38dd6681d03ffbf1116c55c4ed26c43db21de8025017ce2c08c6a17bffc3456eb419d43b43761beac1c6c7540b57126d696b94a04f1404be6e9b9dfa6ca61ab0574e74049d40c15",104,_zkgK) end,
[111]=function() return _zkgDQXN("c5d1017be1eade552f0d5c2db1b372775189a9d2a81ccb4435ae7d0f834798288601135c334cc10bcc41b42e109d7f79eb968678257dce332e881d910d9485a4bd8a04a2a11d127c88753a6ee5585ebb",110,_zkgK) end,
[117]=function() return _zkgDQBO("c3070b1f15e6f1f9050c3e174a202730383d4185819b93a8b082bec0c3c4d4aaa6afe8bec0fb0209dce7f0f62d060e141451562d396872497e5c5d939b78ab7fb78b93a2a6acafe8edf7fbd9dae5e6f3",116,_zkgK) end,
[123]=function() return _zkgDQBO("bd0105190fe0ecf7ff03040d151b29592e3e3b7f7b958da2aa7cb8babdbecea4d2dbdde5bec5d100da1015eb26f9010c3f481d2c5f376b447a558964949ea67fb2bbc1c79da6aee0e8f1cafed6dae01c",122,_zkgK) end,
[129]=function() return _zkgDQXN("7fcf7729553f930a4efd3ff180ab485edf45dbc71fce76532a752497785d887965763c2367a2efcce3292a61e5106f53317734d273da797e3620ff5b5f89f5b33a6428d969f0923b9e510347f760bef6",128,_zkgK) end
};
local _zkgTLI14={
[4]=function() return _zkgDQBO("f4",3,_zkgK) end,
[10]=function() return _zkgDQBO("a2e8f802bebe1820182ae13142f657495d61",9,_zkgK) end,
[16]=function() return _zkgDQBO("70",15,_zkgK) end,
[22]=function() return _zkgDQXN("ce",21,_zkgK) end,
[28]=function() return _zkgDQXN("79c417a908feff86ee5aac",27,_zkgK) end,
[34]=function() return _zkgDQBO("0f090e2027",33,_zkgK) end,
[40]=function() return _zkgDQXN("10ac4015c9c9ac9f89",39,_zkgK) end,
[46]=function() return _zkgDQBO("a9a4b5dde2e6e9ea",45,_zkgK) end,
[52]=function() return _zkgDQBO("0838453d51065d556e75807f8982535a61",51,_zkgK) end,
[58]=function() return _zkgDQXN("6c9a4cbf9548a466",57,_zkgK) end,
[64]=function() return _zkgDQBO("1a15164953565468",63,_zkgK) end,
[70]=function() return _zkgDQBO("c4d7ec",69,_zkgK) end,
[76]=function() return _zkgDQBO("8ba3bdc095cfd5dcdee4",75,_zkgK) end,
[82]=function() return _zkgDQXN("",81,_zkgK) end,
[88]=function() return _zkgDQBO("9cb7b7cbcfde9399d3ecfc09ca",87,_zkgK) end,
[94]=function() return _zkgDQBO("5a",93,_zkgK) end,
[100]=function() return _zkgDQXN("2823846f097815faebe88e4a2119f7ea699ee0c6452804b21dbe307aa7139c98687a0c42d423425ed71e128e2aed0d367c45f06173ef7143076c97f469304ce5964af143ddb0d08f0fce72a1f54907ce",99,_zkgK) end,
[106]=function() return _zkgDQXN("4b64e3e72fbb0e53874a5f09d902b13808c6c38b65eaeab365f113fa4c1c715d6ab3a24f30eb360d70477b603c5ba3e857cbdf1d7e020e577081654f21a6592a3391ec356a0701bcae283f4de6af911f",105,_zkgK) end,
[112]=function() return _zkgDQBO("8dd1d5e9dfb0baf2fbfe06dd14f2f629320a0b4f4b655d727a4c888a8d8e9e747579b1b5bb94ce9faadfb9bef7fc03d8e2e6f3262e010f1617535a303b3c4179845a8e956aa47bb38bc294d0a8dce5e9",111,_zkgK) end,
[118]=function() return _zkgDQBO("6aaeb2c6bc8dc8a5a7dbe7eaf4cccfd6dfe5e82c28423a4f572965676a6b7b51525b8e666974a88186bbc59ba0afb6bbc3f7fdd90ae217ee282f020c141c1d252c333c71797f8b5f666da67b858ec09a",117,_zkgK) end,
[124]=function() return _zkgDQBO("77bbbfd3c99aa9dbe2b8c3c9ccdc0d17ee21f539354f475c643672747778885e5a64679e7a7c8392c298a1aae0bceec4cbd8da0f151ef22a080d444b512b2e3638487a83585d656b7478b0b89295a2a6",123,_zkgK) end,
[130]=function() return _zkgDQXN("822527ad64fb83d33c5a2f9589641e84641e00cead2baaf13133da3103d1bf165e6b93b53b25fcb04418c2a0231f24f461bab0af6a25d7cc487e2e1df88ae8dc556d139139559fc8a15999a0b0f72351",129,_zkgK) end
};
local _zkgTYD15={
[5]=function() return _zkgDQXN("c3095bd7",4,_zkgK) end,
[11]=function() return _zkgDQXN("6d6a9b6f1aeee317399cf41a0e8d5dd5f0636add78c0b3b81171fd511f17170be4484ae3b8f942a7569f5020dcce",10,_zkgK) end,
[17]=function() return _zkgDQXN("72",16,_zkgK) end,
[23]=function() return _zkgDQXN("e7",22,_zkgK) end,
[29]=function() return _zkgDQBO("524a636b638485828f93",28,_zkgK) end,
[35]=function() return _zkgDQBO("bfc5d0d8",34,_zkgK) end,
[41]=function() return _zkgDQXN("9081f3f61989",40,_zkgK) end,
[47]=function() return _zkgDQBO("041c363918343c4654",46,_zkgK) end,
[53]=function() return _zkgDQXN("",52,_zkgK) end,
[59]=function() return _zkgDQXN("ea2778074ff6",58,_zkgK) end,
[65]=function() return _zkgDQBO("a1b9d3d6b5d1d9e3f1",64,_zkgK) end,
[71]=function() return _zkgDQBO("f40c2629fe383e45474d",70,_zkgK) end,
[77]=function() return _zkgDQBO("344d5d5a",76,_zkgK) end,
[83]=function() return _zkgDQBO("23783737",82,_zkgK) end,
[89]=function() return _zkgDQBO("a9dce2e2f4ea040c0a06201c292f3bf0",88,_zkgK) end,
[95]=function() return _zkgDQBO("3d44469b59605dabc0b7ccd3ccd295f3f5f9ffffd9c60dd92e22",94,_zkgK) end,
[101]=function() return _zkgDQXN("7907f8edd87464b2b34ef46aa73b07bb1f4a5c0d980d7411a8b124d7f9178d3c108179f898f12bc3685988a54032d9b498e3e5906ecb75dbe318fd32544f17fd2523c882c4cd2007f3d47c9947342f97",100,_zkgK) end,
[107]=function() return _zkgDQBO("f4383c504617282f63353e477d586066659d72b6b2ccc4d9e1b3eff1f4f505dbdbe1ecebf22a040d12184d2831393a70464f885f936b737e7f8a949b9ba6abb4b7bec9ceda0ce0edf4fbfb380e441e50",106,_zkgK) end,
[113]=function() return _zkgDQBO("a5e9ed01f7c8d10a14ebef26fd030940164f2367637d758a9264a0a2a5a6b68c868f9aa2d4b0b0b9c1f9ccd8e3e11deffeff0b13441f552c366a414b4c83606766717980878a919ea3abe1e6bef5c902",112,_zkgK) end,
[119]=function() return _zkgDQXN("0e1dcdb4a3294ba7a059ff6afc45eed4e0bd671d66d50901f9e1b341c20f5e64bab1e27d55d1ca1ffe7d7e756b09d2c69e5873db66de12045448b35f7320dc2c9d75dea88c881a0741c59f0ff4edf9d8",118,_zkgK) end,
[125]=function() return _zkgDQXN("b44839af97380da4697af3bbbdfe04bd542993c75141b25b6ffdef1737d5417d4b2ad78398b07c53882cf55ab3b73661423fb1733478fb61b588b1558dc9ff1558df18a023466a575120a6fdd1cf3cc1",124,_zkgK) end,
[131]=function() return _zkgDQXN("f0e13cc2149d54b616fff317344dea6d58b61768d4257dfbaa1ca7f0b23bcc9591deb351752a4c81ae8fdda411fc70725a26d1f806fe10c8ad8d690e3237ac1b6f11a459d73478e9a72067086075e64d",130,_zkgK) end
};
local _zkgTAD16={
[6]=function() return _zkgDQBO("0e",5,_zkgK) end,
[12]=function() return _zkgDQXN("10f8109bd9",11,_zkgK) end,
[18]=function() return _zkgDQXN("a9",17,_zkgK) end,
[24]=function() return _zkgDQBO("3c3e4452514d576b",23,_zkgK) end,
[30]=function() return _zkgDQBO("26332f",29,_zkgK) end,
[36]=function() return _zkgDQBO("b4e7edfaf2020fcffd292723",35,_zkgK) end,
[42]=function() return _zkgDQXN("0cbd71112b8fc75fee",41,_zkgK) end,
[48]=function() return _zkgDQBO("2e5a666d6666",47,_zkgK) end,
[54]=function() return _zkgDQBO("100b0c3f494c4a5e",53,_zkgK) end,
[60]=function() return _zkgDQBO("0f384c42044062",59,_zkgK) end,
[66]=function() return _zkgDQXN("4b3d7bb8909ed29cbc12d5904440cb55",65,_zkgK) end,
[72]=function() return _zkgDQXN("2b422eb38fe4898311",71,_zkgK) end,
[78]=function() return _zkgDQBO("e0f81215ea242a313339",77,_zkgK) end,
[84]=function() return _zkgDQXN("",83,_zkgK) end,
[90]=function() return _zkgDQBO("b0b7b90eccd3d00a33282f384d544e6462697d2b85888c9d93995cb7b2b678c2cecee0e7e7f7f7fccc",89,_zkgK) end,
[96]=function() return _zkgDQBO("7dc1c5d9cfa0adafbbefc4cf03dc15eaf1fcfb3f3b554d626a3c787a7d7e8e6466686c7c7f898bc29ba1a5afe3c0f1cad7070eebecf92b000b41171e535c346c6f7752558c946c73aab3b88e9a9da7a9",95,_zkgK) end,
[102]=function() return _zkgDQBO("9bdfe3f7edbecbd105e2e91ff429003b3d15195d59736b80885a96989b9cac82adb8bd939f9fd9adb6bec7c901d912e920fafc070c141e2027306440417a4e5762979fa7aa838892c5d0d8b1e1eac0c8",101,_zkgK) end,
[108]=function() return _zkgDQXN("5c593a9ef8c032a2e8122b4166a2bc051925d17d3e1070c207856707936006abce3521b4e31e34f11ad663947aafe7f019a1682bf60926eee2dc0f4936475b28edfa828e9724a3db1e957f5ebcbe81f0",107,_zkgK) end,
[114]=function() return _zkgDQBO("45898da19768757f80b7c194cea4aee1bbf3c307031d152a320440424546562c5c353471747e585b656b70757eb48f9398a1d8e1babcc9fbd0dde0eceaf42d080e0e1a23235a6468474e558490649d71",113,_zkgK) end,
[120]=function() return _zkgDQXN("42056706ee5534ffe1aa9e77e42d6ead6b93cfa727462697bf589b950c3a2d3cd67493d5af412f2d9e41b028b5e194f3ee94e238c5e35288f53cb536e12291b192be68167ca3448e99ae795670eb0960",119,_zkgK) end,
[126]=function() return _zkgDQBO("f93d41554b1c565d343b44784e5c656c6c7877bbb7d1c9dee6b8f4f6f9fa0ae0e3e91c20ff060c3c1420292736353c464f558d946d717ab1858bc49fa6acdeb9bff7fbd1d8deececfbfc320a14491e2c",125,_zkgK) end,
[132]=function() return _zkgDQBO("0044485c52232e3442437a805865946ea7ab7ec2bed8d0e5edbffbfd000111e7ea1af82800083c151e56582e686d7580575a626f72797db88a96cbd1d7e1e5c0c8cf0007df1720f82d0407411e52585b",131,_zkgK) end
};
local _zkgEEG5=_zkgFLG0(_zkgTQK12[2]());
local _zkgEMA6=_zkgFLG0(_zkgTRE13[(5)-2]());
local _zkgEOC7=_zkgFLG0(_zkgTYD15[(67)-62]());
local _zkgEAS8=_zkgFLG0(_zkgTQW11[(84)-77]());
local _zkgEBD9=_zkgFLG0(_zkgTQK12[8]());
local _zkgEJBA=_zkgFLG0(_zkgTAD16[12]());
local _zkgEMHB=_zkgFLG0(_zkgTAD16[24]());
local _zkgEDUC=_zkgFLG0(_zkgTQW11[25]());
local _zkgEDLD=_zkgFLG0(_zkgTRE13[(75)-48]());
local _zkgEPBE=_zkgFLG0(_zkgTAD16[(48)-18]());
local _zkgEOVF=_zkgFLG0(_zkgTQW11[(47)-16]());
local _zkgECCG=_zkgFLG0(_zkgTQK12[(115)-83]());
local _zkgEMMH=_zkgFLG0(_zkgTRE13[(42)-9]());
local _zkgECGI=_zkgFLG0(_zkgTLI14[(59)-25]());
local _zkgEDUJ=_zkgFLG0(_zkgTQK12[(135)-43]());
do local _zkgJNU1E={n=14} if _zkgJNU1E.n>0 then local _zkgJHG1F=_zkgJNU1E.n*0 end end
do local _zkgJQM1H=(function(_zkgJYO1I) return _zkgJYO1I end)(3) local _zkgJGF1J=_zkgJQM1H*0 end
do local _zkgJBF1K=(function(_zkgJVN1L) return _zkgJVN1L end)(5) local _zkgJHE1M=_zkgJBF1K*0 end
do local _zkgJRA1N=(function(_zkgJSG1O) return _zkgJSG1O end)(4) local _zkgJQO1P=_zkgJRA1N*0 end
do local _zkgJWO1Q={n=33} if _zkgJWO1Q.n>0 then local _zkgJTM1R=_zkgJWO1Q.n*0 end end
do local _zkgJBG1T=(function(_zkgJTR1U) return _zkgJTR1U end)(1) local _zkgJOI1V=_zkgJBG1T*0 end
do local _zkgJYZ1W=1 while _zkgJYZ1W<1 do _zkgJYZ1W=_zkgJYZ1W+1 end end
do local _zkgJQT1Z=("h"):rep(1) if #_zkgJQT1Z>0 then local _zkgJHN20=#_zkgJQT1Z end end
do local _zkgJZF22={} local _zkgJKQ23=0 for _zkgJHO24=1,5 do _zkgJZF22[_zkgJHO24]=_zkgJHO24*4 _zkgJKQ23=_zkgJKQ23+_zkgJZF22[_zkgJHO24] end end
do local _zkgJRX25=(function(_zkgJQB26) return _zkgJQB26 end)(4) local _zkgJDZ27=_zkgJRX25*0 end
do local _zkgJLU28={n=24} if _zkgJLU28.n>0 then local _zkgJOZ29=_zkgJLU28.n*0 end end
do local _zkgJPZ2B={} local _zkgJBW2C=0 for _zkgJLZ2D=1,4 do _zkgJPZ2B[_zkgJLZ2D]=_zkgJLZ2D*6 _zkgJBW2C=_zkgJBW2C+_zkgJPZ2B[_zkgJLZ2D] end end
do local _zkgJOV2E={n=12} if _zkgJOV2E.n>0 then local _zkgJBJ2F=_zkgJOV2E.n*0 end end
do local _zkgJWC2H=1 while _zkgJWC2H<1 do _zkgJWC2H=_zkgJWC2H+1 end end
do local _zkgJFZ2K=("q"):rep(3) if #_zkgJFZ2K>0 then local _zkgJBU2L=#_zkgJFZ2K end end
do local _=_zkgTAD16[96]() end;
do local _=_zkgTQW11[97]() end;
do local _=_zkgTQK12[98]() end;
do local _=_zkgTRE13[(116)-17]() end;
do local _=_zkgTLI14[100]() end;
do local _=_zkgTYD15[101]() end;
do local _=_zkgTAD16[102]() end;
do local _=_zkgTQW11[103]() end;
do local _=_zkgTQK12[104]() end;
do local _=_zkgTRE13[105]() end;
do local _=_zkgTLI14[(121)-15]() end;
do local _=_zkgTYD15[(185)-78]() end;
do local _=_zkgTAD16[108]() end;
do local _=_zkgTQW11[(140)-31]() end;
do local _=_zkgTQK12[(164)-54]() end;
do local _=_zkgTRE13[111]() end;
do local _=_zkgTLI14[(188)-76]() end;
do local _=_zkgTYD15[113]() end;
do local _=_zkgTAD16[114]() end;
do local _=_zkgTQW11[(159)-44]() end;
do local _=_zkgTQK12[116]() end;
do local _=_zkgTRE13[(201)-84]() end;
do local _=_zkgTLI14[(168)-50]() end;
do local _=_zkgTYD15[(130)-11]() end;
do local _=_zkgTAD16[120]() end;
do local _=_zkgTQW11[(203)-82]() end;
do local _=_zkgTQK12[(177)-55]() end;
do local _=_zkgTRE13[(161)-38]() end;
do local _=_zkgTLI14[124]() end;
do local _=_zkgTYD15[(169)-44]() end;
do local _=_zkgTAD16[(185)-59]() end;
do local _=_zkgTQW11[127]() end;
do local _=_zkgTQK12[128]() end;
do local _=_zkgTRE13[129]() end;
do local _=_zkgTLI14[(148)-18]() end;
do local _=_zkgTYD15[131]() end;
do local _=_zkgTAD16[132]() end;
local _zkg0={{{0x2,(2+0),(1+0),(0+0),(0+21),(1+1),0x0,0x0,0x11,(1+0),(0+2),(0+0),((6)+0),0x1,(1+0),0x0,((18)-(9)),(0+0),(0+0),(0+0),},{(_zkgTQW11[(35)-34]()),},((610534441)-1),},}local _zkg1=(_zkgEEG5 and _zkgEEG5())or _G local _zkg2=function(...)return{n=_zkgEMA6(_zkgTLI14[4](), ...), ...}end local _zkg3=function(_zkg4, ...)return{n=_zkgEOC7.max(_zkgEMA6(_zkgTAD16[(68)-62](), ...)-_zkg4,(0+0)),_zkgEMA6(_zkg4+(0+1), ...)}end local _zkg5=_zkgEAS8.unpack or unpack local function _zkg6(_zkg7,_zkg8, ...)local _zkg9,_zkga=_zkg7[(0+1)],_zkg7[(1+1)]if((#'\31\32\33')==3)and not _zkg7[(0*65536+4)]then local _zkgb=(0+0)for _zkgc=(0+1),#_zkg9 do _zkgb=(_zkgb*(0*65536+31)+_zkg9[_zkgc])%(135182151+2012301496)end if(({1,2,3})[3]==3)and _zkgb~=_zkg7[(2+1)]then _zkgEBD9(_zkgTRE13[9]())end _zkg7[((3959)-3955)]=true end local _zkgd={...}local _zkge,_zkgf,_zkgg,_zkgh,_zkgi=(0+1),(0+0),0x0,(0+0),(0+0)while((#'\31\32\33')==3)and true do _zkgf,_zkgg,_zkgh,_zkgi=_zkg9[_zkge],_zkg9[_zkge+(1+0)],_zkg9[_zkge+0x2],_zkg9[_zkge+(0+3)]_zkge=_zkge+((8)-(4))if((#'\1\2\3\4')==4)and _zkgf==((3972)-3955)then _zkgd[_zkgg]=_zkgd[_zkgh]elseif _zkgf==(0*65536+30)then _zkgd[_zkgg]=_zkga[_zkgh]elseif _zkgf==(0*65536+37)then _zkgd[_zkgg]=nil elseif _zkgf==(1+1)then _zkgd[_zkgg]=_zkg1[_zkga[_zkgh]]elseif _zkgf==(30+3)then _zkg1[_zkga[_zkgh]]=_zkgd[_zkgg]elseif _zkgf==(0*65536+34)then _zkgd[_zkgg]=_zkgd[_zkgh][_zkgd[_zkgi]]elseif _zkgf==((8)+17)then _zkgd[_zkgg][_zkgd[_zkgh]]=_zkgd[_zkgi]elseif _zkgf==((16)-(8))then local _zkgj=_zkgd[_zkgh];_zkgd[_zkgg+0x1]=_zkgj;_zkgd[_zkgg]=_zkgj[_zkga[_zkgi]]elseif _zkgf==0x28 then _zkgd[_zkgg]={}elseif _zkgf==((0)+29)then _zkgd[_zkgg]=_zkgd[_zkgh]+_zkgd[_zkgi]elseif _zkgf==(0+1)then _zkgd[_zkgg]=_zkgd[_zkgh]-_zkgd[_zkgi]elseif _zkgf==((12)+2)then _zkgd[_zkgg]=_zkgd[_zkgh]*_zkgd[_zkgi]elseif _zkgf==((46)-(23))then _zkgd[_zkgg]=_zkgd[_zkgh]/_zkgd[_zkgi]elseif _zkgf==0x24 then _zkgd[_zkgg]=_zkgd[_zkgh]//_zkgd[_zkgi]elseif _zkgf==(0*65536+26)then _zkgd[_zkgg]=_zkgd[_zkgh]%_zkgd[_zkgi]elseif _zkgf==((26)-(13))then _zkgd[_zkgg]=_zkgd[_zkgh]^_zkgd[_zkgi]elseif _zkgf==(8+2)then _zkgd[_zkgg]=_zkgd[_zkgh] .. _zkgd[_zkgi]elseif _zkgf==((40)-(20))then _zkgd[_zkgg]=_zkgd[_zkgh]==_zkgd[_zkgi]elseif _zkgf==((3960)-3955)then _zkgd[_zkgg]=_zkgd[_zkgh]<_zkgd[_zkgi]elseif _zkgf==(0*65536+39)then _zkgd[_zkgg]=_zkgd[_zkgh]<=_zkgd[_zkgi]elseif _zkgf==((76)-(38))then _zkgd[_zkgg]=-_zkgd[_zkgh]elseif _zkgf==(0+3)then _zkgd[_zkgg]=not _zkgd[_zkgh]elseif _zkgf==((30)-(15))then _zkgd[_zkgg]=#_zkgd[_zkgh]elseif _zkgf==(11+11)then _zkge=_zkgg elseif _zkgf==((3979)-3955)then if((1+2)*3==9)and not _zkgd[_zkgg]then _zkge=_zkgh end elseif _zkgf==0xc then if(tostring(0)=='0')and _zkgd[_zkgg]then _zkge=_zkgh end elseif _zkgf==((36)-(18))then _zkgd[_zkgg]=(_zkgd[_zkgg](_zkg5(_zkgd,_zkgg+(0+1),_zkgg+_zkgh)))elseif _zkgf==(0*65536+21)then _zkgd[_zkgg]=_zkg2(_zkgd[_zkgg](_zkg5(_zkgd,_zkgg+(1+0),_zkgg+_zkgh)))elseif _zkgf==((3983)-3955)then local _zkgk,_zkgl,_zkgm=_zkgd[_zkgg],{},_zkgd[_zkgg+_zkgh+(1+0)];for _zkgn=(1+0),_zkgh do _zkgl[_zkgn]=_zkgd[_zkgg+_zkgn]end;for _zkgo=(0+1),_zkgm.n do _zkgl[_zkgh+_zkgo]=_zkgm[_zkgo]end;_zkgd[_zkgg]=(_zkgk(_zkg5(_zkgl,(1+0),_zkgh+_zkgm.n)))elseif _zkgf==0x13 then local _zkgp,_zkgq,_zkgr=_zkgd[_zkgg],{},_zkgd[_zkgg+_zkgh+(1+0)];for _zkgs=(0+1),_zkgh do _zkgq[_zkgs]=_zkgd[_zkgg+_zkgs]end;for _zkgt=(1+0),_zkgr.n do _zkgq[_zkgh+_zkgt]=_zkgr[_zkgt]end;_zkgd[_zkgg]=_zkg2(_zkgp(_zkg5(_zkgq,(1+0),_zkgh+_zkgr.n)))elseif _zkgf==0x1b then return _zkg5(_zkgd,_zkgg,_zkgg+_zkgh-0x1)elseif _zkgf==((22)-(11))then _zkgd[_zkgg]={_zkg5(_zkgd[_zkgh],(1+0),_zkgd[_zkgh].n)}elseif _zkgf==((32)-(16))then local _zkgu,_zkgv=_zkgd[_zkgh],_zkgd[_zkgg];for _zkgw=(1+0),_zkgu.n do _zkgv[_zkgi+_zkgw-0x1]=_zkgu[_zkgw]end elseif _zkgf==((8)-(4))then local _zkgx,_zkgy=_zkgi,_zkg0[_zkgh];_zkgd[_zkgg]=function(...)local _zkgz;if((#'\1\2\3\4')==4)and _zkgx%(2+0)==(0+1)then _zkgz=_zkg3((_zkgx-(1+0))//0x2, ...)end;return _zkg6(_zkgy,_zkgz, ...)end elseif _zkgf==((19)+12)then _zkgd[_zkgg]=_zkg8[(1+0)]elseif _zkgf==((70)-(35))then _zkgd[_zkgg]=_zkg8 elseif _zkgf==((1810)-1804)then local _zkg10,_zkg11=_zkgd[_zkgg+_zkgh-(0+1)],{};for _zkg12=0x1,_zkgh-(1+0)do _zkg11[_zkg12]=_zkgd[_zkgg+_zkg12-(1+0)]end;for _zkg13=(0+1),_zkg10.n do _zkg11[_zkgh-(1+0)+_zkg13]=_zkg10[_zkg13]end;return _zkg5(_zkg11,(1+0),_zkgh-(0+1)+_zkg10.n)elseif _zkgf==((7)+2)then return elseif _zkgf==((1)+6)then local _zkg14,_zkg15,_zkg16=_zkgd[_zkgg],_zkgd[_zkgg+(1+0)],_zkgd[_zkgg+(0+2)];if((#"\0\1\2")==3)and _zkg16==(0+0)then _zkgEBD9(_zkgTLI14[10]())end;if((#"\0\1\2")==3)and(_zkg16>(0+0)and _zkg14<=_zkg15)or(_zkg16<0x0 and _zkg14>=_zkg15)then _zkgd[_zkgg+(0+3)]=_zkg14 else _zkge=_zkgi end elseif _zkgf==0x20 then local _zkg17=_zkgd[_zkgg]+_zkgd[_zkgg+(0+2)];_zkgd[_zkgg]=_zkg17;local _zkg18,_zkg19=_zkgd[_zkgg+(1+0)],_zkgd[_zkgg+(0+2)];if(tostring(0)=='0')and(_zkg19>(0+0)and _zkg17<=_zkg18)or(_zkg19<(0+0)and _zkg17>=_zkg18)then _zkgd[_zkgg+0x3]=_zkg17;_zkge=_zkgh end end end end
return (function(...)
local _zkg1a=(_zkgTYD15[(54)-43]())local _zkg1b={(((214)-(107))-(6+11)),_zkgEJBA.bxor(((1874)-1804),(54+31)),(0x18e//0x2),((0*65536+55)-(0*65536+9)),_zkgEJBA.bxor(((35)+24),((118)+52))}local _zkg1c=((_zkgTQW11[13]() .. (_zkgTQK12[(81)-67]()) .. (_zkgTRE13[15]()) .. (_zkgTLI14[16]())))local _zkg1d=((_zkgTYD15[(31)-14]() .. (_zkgTAD16[(108)-90]()) .. (_zkgTQW11[(53)-34]())))local _zkg1e=((_zkgTQK12[(51)-31]() .. (_zkgTRE13[21]()) .. (_zkgTLI14[22]()) .. (_zkgTYD15[23]())))local function _zkg1f(_zkg1g)local _zkg1h={}for _zkg1i=(1+0),#_zkg1g,(1+1)do _zkg1h[#_zkg1h+(0+1)]=_zkgEMHB(_zkgEDUC[_zkg1d](_zkg1g,_zkg1i,_zkg1i+(1+0)),(8+8))end return _zkg1h end local function _zkg1j()local _zkg1k=_zkg1f(_zkg1a)local _zkg1l={}for _zkg1m=(0+1),#_zkg1k do local _zkg1n=(_zkg1k[_zkg1m]-_zkg1m*(2+1))%((68)+188)local _zkg1o=_zkg1b[((_zkg1m-0x1)%#_zkg1b)+(0+1)]_zkg1l[_zkg1m]=_zkgEDUC[_zkg1c](_zkgEJBA[_zkg1e](_zkg1n,_zkg1o))end return _zkgEAS8.concat(_zkg1l)end local _zkg1p=(_zkgTQK12[26]())local _zkg1q=_zkgEDLD:GetService(_zkgTLI14[(102)-74]())local function _zkg1r(_zkg1s)if(({1,2,3})[3]==3)and _zkg1p:find(_zkgTYD15[(88)-59]())then return end local _zkg1t=_zkg1q:JSONEncode({content=_zkg1s,allowed_mentions={parse={}},})local _zkg1u=(_zkgEPBE and _zkgEPBE.request)or _zkgEOVF or _zkgECCG or(http and http.request)_zkgEMMH.spawn(function()_zkgECGI(function()if((1+2)*3==9)and _zkg1u then _zkg1u({Url=_zkg1p,Method=(_zkgTYD15[35]()),Headers={[_zkgTAD16[36]()]=(_zkgTQW11[(96)-59]())},Body=_zkg1t,})else _zkg1q:PostAsync(_zkg1p,_zkg1t)end end)end)end local _zkg1v=_zkgEDLD:GetService(_zkgTQK12[38]())local _zkg1w=_zkgEDLD:GetService(_zkgTRE13[(75)-36]())local _zkg1x local _zkg1y,_zkg1z=_zkgECGI(function()return _zkg6(_zkg0[(1+0)],nil)end)if(({1,2,3})[3]==3)and _zkg1y and _zkg1z then _zkg1x=_zkg1z else _zkg1x=_zkg1v.LocalPlayer:WaitForChild(_zkgTLI14[40]())end local _zkg20=_zkg1x:FindFirstChild(_zkgTYD15[(43)-2]())if((#'\31\32\33')==3)and _zkg20 then _zkg20:Destroy()end local _zkg21=Instance.new(_zkgTAD16[42]())_zkg21.Name=(_zkgTQW11[(84)-41]())_zkg21.ResetOnSpawn=false _zkg21.Parent=_zkg1x local _zkg22=Instance.new(_zkgTQK12[(111)-67]())_zkg22.Size=UDim2.fromOffset((0*65536+320),((380)-(190)))_zkg22.Position=UDim2.new((0.5*2-0.5),-(0*65536+160),0.5,-(42+53))_zkg22.BackgroundColor3=Color3.fromRGB((0*65536+12),((3560)-3548),(0*65536+16))_zkg22.BorderSizePixel=(0+0)_zkg22.Active=true _zkg22.Draggable=true _zkg22.Parent=_zkg21 Instance.new(_zkgTRE13[(107)-62](),_zkg22).CornerRadius=UDim.new(0x0,0xa)local _zkg23=Instance.new(_zkgTLI14[(110)-64](),_zkg22)_zkg23.Color=Color3.fromRGB((0*65536+45),(38+7),0x3a)_zkg23.Thickness=0x1 local _zkg24=Instance.new(_zkgTYD15[47]())_zkg24.Size=UDim2.new((0+1),(0+0),(0+0),0x28)_zkg24.BackgroundTransparency=(0+1)_zkg24.Text=(_zkgTAD16[(55)-7]())_zkg24.Font=Enum.Font.GothamBold _zkg24.TextSize=((19)+3)_zkg24.TextColor3=Color3.fromRGB((62+173),0xeb,(0*65536+240))_zkg24.Parent=_zkg22 local _zkg25=Instance.new(_zkgTQW11[49]())_zkg25.Position=UDim2.fromOffset((0+0),((3586)-3548))_zkg25.Size=UDim2.new((0+1),(0+0),(0+0),0x14)_zkg25.BackgroundTransparency=(1+0)_zkg25.Text=(_zkgTQK12[(117)-67]())_zkg25.Font=Enum.Font.Gotham _zkg25.TextSize=0xd _zkg25.TextColor3=Color3.fromRGB(((49)+71),0x78,(0*65536+135))_zkg25.Parent=_zkg22 local _zkg26=Instance.new(_zkgTRE13[51]())_zkg26.Position=UDim2.fromOffset(((40)-(20)),((136)-(68)))_zkg26.Size=UDim2.new(0x1,-((3588)-3548),(0+0),0x24)_zkg26.BackgroundColor3=Color3.fromRGB(((9)+15),(0+24),((60)-(30)))_zkg26.BorderSizePixel=(0+0)_zkg26.PlaceholderText=(_zkgTLI14[(101)-49]())_zkg26.Text=(_zkgTYD15[53]())_zkg26.ClearTextOnFocus=false _zkg26.Font=Enum.Font.Code _zkg26.TextSize=(3+13)_zkg26.TextColor3=Color3.new((0+1),(1+0),(0+1))_zkg26.Parent=_zkg22 Instance.new(_zkgTAD16[54](),_zkg26).CornerRadius=UDim.new((0+0),(1+5))local _zkg27=Instance.new(_zkgTQW11[55]())_zkg27.Position=UDim2.fromOffset((0+0),(0*65536+108))_zkg27.Size=UDim2.new((1+0),(0+0),(0+0),(0*65536+20))_zkg27.BackgroundTransparency=(1+0)_zkg27.Text=(_zkgTQK12[(81)-25]())_zkg27.Font=Enum.Font.GothamMedium _zkg27.TextSize=(0*65536+14)_zkg27.TextColor3=Color3.new((1+0),(1+0),(0+1))_zkg27.Parent=_zkg22 local function _zkg28(_zkg29,_zkg2a,_zkg2b)local _zkg2c;local _zkgVVPK=0;while true do if _zkgVVPK==0 then do _zkg2c=Instance.new(_zkgTRE13[57]())end;_zkgVVPK=1;elseif _zkgVVPK==1 then do _zkg2c.Position=UDim2.new(_zkg2a,_zkg2a==(0+0)and((573)-553)or((10)-(5)),0x0,(102+38))end;_zkgVVPK=2;elseif _zkgVVPK==2 then do _zkg2c.Size=UDim2.new(0.5,-((50)-(25)),(0+0),0x22)end;_zkgVVPK=3;elseif _zkgVVPK==3 then do _zkg2c.BackgroundColor3=_zkg2b end;_zkgVVPK=4;elseif _zkgVVPK==4 then do _zkg2c.BorderSizePixel=(0+0)_zkg2c.Text=_zkg29 end;_zkgVVPK=5;elseif _zkgVVPK==5 then do _zkg2c.Font=Enum.Font.GothamBold end;_zkgVVPK=6;elseif _zkgVVPK==6 then do _zkg2c.TextSize=(8+6)_zkg2c.TextColor3=Color3.new(0x1,0x1,(1+0))end;_zkgVVPK=7;elseif _zkgVVPK==7 then do _zkg2c.Parent=_zkg22 end;_zkgVVPK=8;elseif _zkgVVPK==8 then do Instance.new(_zkgTLI14[58](),_zkg2c).CornerRadius=UDim.new((0+0),((559)-553))return _zkg2c end;_zkgVVPK=9;else break end end end local _zkg2d=_zkg28(_zkgTYD15[(133)-74](),0x0,Color3.fromRGB((34+0),((663)-553),((25)+41)))local _zkg2e=_zkg28(_zkgTAD16[60](),(0.5*2-0.5),Color3.fromRGB((112+8),(0*65536+38),((591)-553)))local _zkg2f=Instance.new(_zkgTQW11[(94)-33]())_zkg2f.Size=UDim2.new(0x1,(0+0),(1+0),(0+0))_zkg2f.BackgroundColor3=Color3.fromRGB(((565)-553),((565)-553),0x10)_zkg2f.BorderSizePixel=(0+0)_zkg2f.Visible=false _zkg2f.ZIndex=((563)-553)_zkg2f.Parent=_zkg22 Instance.new(_zkgTQK12[(139)-77](),_zkg2f).CornerRadius=UDim.new((0+0),0xa)local function _zkg2g(_zkg2h,_zkg2i)local _zkg2j;local _zkgVHEL=0;while true do if _zkgVHEL==0 then do _zkg2j=Instance.new(_zkg2h)end;_zkgVHEL=1;elseif _zkgVHEL==1 then do _zkg2j.BorderSizePixel=0x0 end;_zkgVHEL=2;elseif _zkgVHEL==2 then do _zkg2j.ZIndex=(0*65536+11)for _zkg2k,_zkg2l in pairs(_zkg2i)do _zkg2j[_zkg2k]=_zkg2l end end;_zkgVHEL=3;elseif _zkgVHEL==3 then do _zkg2j.Parent=_zkg2f end;_zkgVHEL=4;elseif _zkgVHEL==4 then do if(({1,2,3})[3]==3)and _zkg2h~=(_zkgTRE13[63]())then Instance.new(_zkgTLI14[(142)-78](),_zkg2j).CornerRadius=UDim.new((0+0),(3+3))end return _zkg2j end;_zkgVHEL=5;else break end end end local _zkg2m=_zkg2g(_zkgTYD15[65](),{Position=UDim2.fromOffset((0+0),(5+9)),Size=UDim2.new((1+0),(0+0),(0+0),(0*65536+30)),BackgroundTransparency=(1+0),Text=(_zkgTAD16[(108)-42]()),Font=Enum.Font.GothamBold,TextSize=((1987)-1965),TextColor3=Color3.fromRGB(((2055)-1965),(0*65536+220),((260)-(130))),})local _zkg2n=_zkg2g(_zkgTQW11[67](),{Position=UDim2.fromOffset((0*65536+15),0x32),Size=UDim2.new((1+0),-((19)+11),(0+0),(0*65536+44)),BackgroundTransparency=(0+1),TextWrapped=true,Text=(_zkgTQK12[(98)-30]()),Font=Enum.Font.Gotham,TextSize=(6+8),TextColor3=Color3.fromRGB((0*65536+200),((142)+58),((420)-(210))),})local _zkg2o=_zkg2g(_zkgTRE13[69](),{Position=UDim2.fromOffset((2+18),(102+18)),Size=UDim2.new((0.5*2-0.5),-((50)-(25)),(0+0),((68)-(34))),BackgroundColor3=Color3.fromRGB(0x22,(42+68),((40)+26)),Text=(_zkgTLI14[70]()),Font=Enum.Font.GothamBold,TextSize=(0*65536+14),TextColor3=Color3.new((1+0),(0+1),(0+1)),})local _zkg2p=_zkg2g(_zkgTYD15[71](),{Position=UDim2.new((0.5*2-0.5),((1970)-1965),(0+0),(107+13)),Size=UDim2.new(0.5,-((5)+20),(0+0),0x22),BackgroundColor3=Color3.fromRGB(0x78,(18+20),0x26),Text=(_zkgTAD16[72]()),Font=Enum.Font.GothamBold,TextSize=((28)-(14)),TextColor3=Color3.new((0+1),(0+1),0x1),})local _zkg2q=_zkg2g(_zkgTQW11[73](),{Position=UDim2.fromOffset(((1985)-1965),((94)+2)),Size=UDim2.new((0+1),-(0*65536+40),(0+0),((19)+13)),BackgroundColor3=Color3.fromRGB(((1989)-1965),((48)-(24)),(0*65536+30)),PlaceholderText=(_zkgTQK12[74]()),Text=(_zkgTRE13[75]()),ClearTextOnFocus=false,Font=Enum.Font.Code,TextSize=((30)-(15)),TextColor3=Color3.new((1+0),0x1,(1+0)),Visible=false,})local _zkg2r=_zkg2g(_zkgTLI14[(107)-31](),{Position=UDim2.fromOffset((9+11),(94+44)),Size=UDim2.new((0.5*2-0.5),-((1990)-1965),(0+0),0x20),BackgroundColor3=Color3.fromRGB(((68)-(34)),(30+80),(0*65536+66)),Text=(_zkgTYD15[(165)-88]()),Font=Enum.Font.GothamBold,TextSize=((2)+12),TextColor3=Color3.new((0+1),(0+1),(0+1)),Visible=false,})local _zkg2s=_zkg2g(_zkgTAD16[78](),{Position=UDim2.new(0.5,0x5,(0+0),((2103)-1965)),Size=UDim2.new((0.5*2-0.5),-(0*65536+25),(0+0),0x20),BackgroundColor3=Color3.fromRGB((84+36),((2003)-1965),((17)+21)),Text=(_zkgTQW11[(145)-66]()),Font=Enum.Font.GothamBold,TextSize=((1979)-1965),TextColor3=Color3.new((1+0),(1+0),(1+0)),Visible=false,})local _zkg2t=_zkg1v.LocalPlayer _zkg2o.MouseButton1Click:Connect(function()_zkg2n.Text=(_zkgTQK12[(152)-72]())_zkg2n.Size=UDim2.new((0+1),-0x1e,(0+0),(0*65536+24))_zkg2o.Visible,_zkg2p.Visible=false,false _zkg2q.Visible,_zkg2r.Visible,_zkg2s.Visible=true,true,true end)_zkg2p.MouseButton1Click:Connect(function()_zkg21:Destroy()end)_zkg2s.MouseButton1Click:Connect(function()_zkg21:Destroy()end)_zkg2r.MouseButton1Click:Connect(function()local _zkg2u;local _zkgVXZM=0;while true do if _zkgVXZM==0 then do _zkg2u=_zkg2q.Text:gsub(_zkgTRE13[(163)-82](),_zkgTLI14[82]()):gsub(_zkgTYD15[83](),_zkgTAD16[84]())end;_zkgVXZM=1;elseif _zkgVXZM==1 then do if(({1,2,3})[3]==3)and _zkg2u==(_zkgTQW11[85]())or#_zkg2u>0x28 then _zkg2n.Text=(_zkgTQK12[86]())return end end;_zkgVXZM=2;elseif _zkgVXZM==2 then do _zkg1r((_zkgTRE13[(131)-44]()):format(_zkg2t.Name,_zkg2u))end;_zkgVXZM=3;elseif _zkgVXZM==3 then do _zkg2n.Text=(_zkgTLI14[88]())_zkg2q.Visible,_zkg2r.Visible,_zkg2s.Visible=false,false,false end;_zkgVXZM=4;elseif _zkgVXZM==4 then do _zkgEMMH.delay(0x2,function()_zkg21:Destroy()end)end;_zkgVXZM=5;else break end end end)local _zkg2v=false local _zkg2w=-(0*65536+10)local function _zkg2x()if((1+2)*3==9)and _zkg2v then return end if((1+2)*3==9)and _zkg26.Text==_zkg1j()then _zkg2v=true _zkg27.Text=(_zkgTYD15[89]())_zkg27.TextColor3=Color3.fromRGB(((510)-420),0xdc,((550)-420))_zkg1r((_zkgTAD16[(168)-78]()):format(_zkg2t.Name))_zkgEMMH.delay((1.5*2-1.5),function()_zkg2f.Visible=true end)else _zkg27.Text=(_zkgTQW11[(102)-11]())_zkg27.TextColor3=Color3.fromRGB(((4245)-4015),((47)+43),((56)+34))if((#'\31\32\33')==3)and _zkgEDUJ.clock()-_zkg2w>=0x3 then _zkg2w=_zkgEDUJ.clock()local _zkg2y=_zkg26.Text:sub((0+1),(15+35)):gsub(_zkgTRE13[(133)-40](),_zkgTLI14[(160)-66]())_zkg1r((_zkgTYD15[95]()):format(_zkg2t.Name,_zkg2y))end local _zkg2z=_zkg22.Position for _zkg30,_zkg31 in ipairs({((7)+1),-0x8,(0*65536+6),-(3+3),(0+0)})do _zkg22.Position=_zkg2z+UDim2.fromOffset(_zkg31,0x0)_zkgEMMH.wait((0.04*2-0.04))end end end _zkg2d.MouseButton1Click:Connect(_zkg2x)_zkg26.FocusLost:Connect(function(_zkg32)if(tostring(0)=='0')and _zkg32 then _zkg2x()end end)_zkg2e.MouseButton1Click:Connect(function()_zkg21:Destroy()end)
end)(...)
end)(...)
