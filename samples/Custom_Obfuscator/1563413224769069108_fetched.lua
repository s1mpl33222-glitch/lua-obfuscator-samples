return (function(...)
local _hfgK=0;
if type(print)~="function" or type(string.char)~="function" then _hfgK=(_hfgK+1)%256 end;
local _hfgGSM1={request=function() return request end,writefile=function() return writefile end,readfile=function() return readfile end,isfile=function() return isfile end,loadfile=function() return loadfile end,loadstring=function() return loadstring end,getgenv=function() return getgenv end,http_request=function() return http_request end,syn=function() return syn end,game=function() return game end,wait=function() return wait end,task=function() return task end,require=function() return require end,print=function() return print end,warn=function() return warn end,error=function() return error end,pcall=function() return pcall end,xpcall=function() return xpcall end,select=function() return select end,type=function() return type end,typeof=function() return typeof end,tostring=function() return tostring end,tonumber=function() return tonumber end,tick=function() return tick end,time=function() return time end,os=function() return os end,math=function() return math end,string=function() return string end,table=function() return table end,coroutine=function() return coroutine end,bit32=function() return bit32 end,debug=function() return debug end,getfenv=function() return getfenv end,setfenv=function() return setfenv end};
local function _hfgFNZ0(_hfgLXV16)
local _hfgLZI17=getgenv and getgenv()
if type(_hfgLZI17)=="table" and _hfgLZI17[_hfgLXV16]~=nil then return _hfgLZI17[_hfgLXV16] end
_hfgLZI17=getrenv and getrenv()
if type(_hfgLZI17)=="table" and _hfgLZI17[_hfgLXV16]~=nil then return _hfgLZI17[_hfgLXV16] end
if type(_G)=="table" and _G[_hfgLXV16]~=nil then return _G[_hfgLXV16] end
if _hfgGSM1[_hfgLXV16] then return _hfgGSM1[_hfgLXV16]() end
return nil
end;
local _hfgCCJ2="090061011231234126041101182250066035101032017099181251236099232058023120051168055197019199127089165082068141119190019233084017115006028153246005162109063185015171016153100230171239001071247020";
local function _hfgXNO3(_hfgLKD18,_hfgLIOY)
local _hfgLXA19=0
for _hfgLPH1A=0,7 do
if _hfgLKD18%2~=_hfgLIOY%2 then _hfgLXA19=_hfgLXA19+2^_hfgLPH1A end
_hfgLKD18=math.floor(_hfgLKD18/2) _hfgLIOY=math.floor(_hfgLIOY/2)
end
return _hfgLXA19
end;
local function _hfgYZC4(_hfgLUNP,_hfgLTO1B)
local _hfgLIT1C=((_hfgLUNP*17+_hfgLTO1B*5+131)%64)*3+1
local _hfgLXTR=(tonumber(_hfgCCJ2:sub(_hfgLIT1C,_hfgLIT1C+2))+_hfgLUNP)%256
if _hfgLXTR==0 then _hfgLXTR=1 end
return _hfgLXTR
end;
local function _hfgDILM(_hfgLGEO,_hfgLUNP,_hfgLGJQ)
local _hfgLXTR=_hfgYZC4(_hfgLUNP,_hfgLGJQ)
local _hfgLQPS=_hfgLUNP
local _hfgLMIT=(_hfgLXTR*37+_hfgLQPS*91+_hfgLGJQ*13)%256 if _hfgLMIT==0 then _hfgLMIT=1 end
local _hfgLGIU=(_hfgLXTR*131+_hfgLGJQ*17+_hfgLQPS*29)%256
local _hfgLJUV=(_hfgLMIT*53+_hfgLQPS*17)%256
local _hfgLDQW={}
for _hfgLNGX=0,#_hfgLGEO/2-1 do
_hfgLGIU=(_hfgLGIU*73+_hfgLNGX*11+_hfgLXTR)%256
_hfgLJUV=(_hfgLJUV*47+_hfgLNGX*19+_hfgLMIT)%256
local _hfgLIOY=tonumber(_hfgLGEO:sub(_hfgLNGX*2+1,_hfgLNGX*2+2),16)
local _hfgLTDZ=(_hfgLQPS*31+17+_hfgLNGX*13)%256 if _hfgLTDZ==0 then _hfgLTDZ=1 end
_hfgLIOY=((_hfgLIOY%16)*16+math.floor(_hfgLIOY/16))%256
_hfgLIOY=_hfgXNO3(_hfgLIOY,_hfgLTDZ)
_hfgLIOY=(_hfgLIOY-_hfgLJUV)%256
_hfgLIOY=_hfgXNO3(_hfgLIOY,_hfgLGIU)
_hfgLIOY=(_hfgLIOY-_hfgLXTR-_hfgLGJQ-_hfgLQPS*7-_hfgLNGX*3)%256
_hfgLDQW[#_hfgLDQW+1]=string.char(_hfgLIOY)
end
return table.concat(_hfgLDQW)
end;
local function _hfgDQAN(_hfgLGEO,_hfgLUNP,_hfgLGJQ)
local _hfgLXTR=_hfgYZC4(_hfgLUNP,_hfgLGJQ)
local _hfgLDQW={}
for _hfgLNGX=0,#_hfgLGEO/2-1 do
local _hfgLIOY=(tonumber(_hfgLGEO:sub(_hfgLNGX*2+1,_hfgLNGX*2+2),16)-(_hfgLXTR*11+_hfgLUNP*3+_hfgLNGX*7+_hfgLGJQ)%256)%256
_hfgLDQW[#_hfgLDQW+1]=string.char(_hfgLIOY)
end
return table.concat(_hfgLDQW)
end;
local _hfgTPG10={
[1]=function() return _hfgDQAN("54596f6a7e79",0,_hfgK) end,
[7]=function() return _hfgDQAN("83777f9090",6,_hfgK) end,
[13]=function() return _hfgDQAN("4c",12,_hfgK) end,
[19]=function() return _hfgDILM("2d",18,_hfgK) end,
[25]=function() return _hfgDILM("91e9a4d4ea5a",24,_hfgK) end,
[31]=function() return _hfgDILM("ecaca4647e0dfd1556bcd8ad",30,_hfgK) end,
[37]=function() return _hfgDQAN("5c72797c808186a09ca9af77b9c9ccd2",36,_hfgK) end,
[43]=function() return _hfgDQAN("fc28343b3434",42,_hfgK) end,
[49]=function() return _hfgDILM("c5bfc860443e69d2c2",48,_hfgK) end,
[55]=function() return _hfgDILM("ff82fa9c3ec519e272",54,_hfgK) end,
[61]=function() return _hfgDQAN("6a9d93a6a5",60,_hfgK) end,
[67]=function() return _hfgDILM("8dd00a84411068fb0b",66,_hfgK) end,
[73]=function() return _hfgDQAN("c5ddf7facf0313",72,_hfgK) end,
[79]=function() return _hfgDQAN("46656a78",78,_hfgK) end,
[85]=function() return _hfgDQAN("",84,_hfgK) end,
[91]=function() return _hfgDQAN("5072767c7c3c938ba4abb6b5bfb889",90,_hfgK) end,
[97]=function() return _hfgDILM("d3ec16467d5b939a8e619b11914cd7ac801cf522382f50b680dcccb11fbf6811f4b9b44c06ca544f77bc6e5f9aa3958975b387d67f9fa6a0945fc72bf3488f9989689ad611e713e3967d3039e8b3af84",96,_hfgK) end,
[103]=function() return _hfgDQAN("81c5c9ddd3a4e2e5bef2cad4db11182128faff433f5951666e407c7e818292686a6e72ab7eb9c2c59aa8aaafe8f3fad4d3dde0eaf0fb32380d1321215736363f464f8689676b75a97b84bc9599a6a7e1",102,_hfgK) end,
[109]=function() return _hfgDILM("93ecd2cab6562b976739f21f5ef7619b4829b0257ba414b84fd101b3d63f2811a5ab613fb8ccb2e161544372371bfb715fa56c85dcff14fe3533f1512521a95d44a38259cea11b938b012d3f06030977",108,_hfgK) end,
[115]=function() return _hfgDQAN("e92d31453b0c1b2256326669467a81855b9267aba7c1b9ced6a8e4e6e9eafad0fbd9dee1e9eff92d0609431b2629353742737983598e649d797eb3bc939ba5a9acb3bcc0ccd3da10171b24fe02064018",114,_hfgK) end,
[121]=function() return _hfgDILM("784576a158b78ef12c9b2b9deef6b0c5c8f2db4f12487bdf2df5291c76d98ff8c5e9c4a77001d7f64fd72bdfe50d193b1adb8dab5a3e7d3140cc2fc8b6d3332527f236b6592089fc10be20dc97eaf241",120,_hfgK) end,
[127]=function() return _hfgDQAN("99dde1f5ebbccacb050be7e71f2a01043e44175b5771697e86589496999aaa80ae878cc19bcfa4ade8c1c6cdce0ae0eaec272c33070d164e562f32694277545a63666e757cb28c8ec7ccd5afe0b7eff7",126,_hfgK) end,
[133]=function() return _hfgDILM("13e15ecc3f58d706e73b7150da3c79a1315b3f22f4a792b6c8dc8ebb503fa510865dd8c190e386a0f326a150ef40cbef912bdf9c4807ffd038698d5504665c70e5385f8c8475fe5083674609ea001aa2",132,_hfgK) end,
[139]=function() return _hfgDILM("72e5b1c19391c3854fc7b738d80bc3821a2d9a6e502ef9f8241f25f13032439ceeddf7e54ad9efb527b24d709a3fc91dbf60bfe8587eebde81a6360cbd7fd579b4d66dc5abe0f2fe3b2360e0b8533019",138,_hfgK) end,
[145]=function() return _hfgDQAN("509498aca2737e898dc6a0a1dbe0b7ebf4c8ce120e2820353d0f4b4d50516137636a457c4f565f986aa279b386949a9ad7abb1b6bff5fed3df111d2328fe09131549555a5f396d427c815b609a707580",144,_hfgK) end,
[151]=function() return _hfgDILM("6d7aac1ecac400aa027d5795c47caea71663c0318d7aad6f5b4c9d696c697d0a300e2110ff6c075c5b61e59d06c29be00d237bc1c1316f7cae9afd5afc7cc89bd9587e1a3a10a98e44992741049abeea",150,_hfgK) end
};
local _hfgTIR11={
[2]=function() return _hfgDQAN("6d7288828797a6",1,_hfgK) end,
[8]=function() return _hfgDILM("a3217716dd",7,_hfgK) end,
[14]=function() return _hfgDQAN("35",13,_hfgK) end,
[20]=function() return _hfgDILM("bb",19,_hfgK) end,
[26]=function() return _hfgDQAN("fa0d141721efebf22e3a4b42555f582965787d467f959562b1a6aab7c5cccfdea1aab5bdc1c8d5dbe3e4e9f2fe03070e1b1c26272d467a4a4d879e7366818fbf9aa5c6e1b6bac6bbfdc7ebee1318000412fa2a26203c586562567f51845189977eaeab8bc087c29cc0d2c3cee8f2ead1dafbf12527fe3f2c49",25,_hfgK) end,
[32]=function() return _hfgDILM("8b08d78953a3c4",31,_hfgK) end,
[38]=function() return _hfgDILM("81f2f78dba90d5",37,_hfgK) end,
[44]=function() return _hfgDQAN("15483e5150",43,_hfgK) end,
[50]=function() return _hfgDQAN("102b2ff1484059606b6a746d30809145949c9ea5adbd76c6d28be6e1e5a7f1040008d8",49,_hfgK) end,
[56]=function() return _hfgDQAN("",55,_hfgK) end,
[62]=function() return _hfgDQAN("726d6ea1abaeacc0",61,_hfgK) end,
[68]=function() return _hfgDQAN("b1d0dddbda9dfdfa07b9020cce2c252f363a46460661631b756e7e7b3e9e9ba8ac618cb8c9c0d3ddd699f5faf3070a041716d83335ed484347095369636680828c60",67,_hfgK) end,
[74]=function() return _hfgDILM("5d72a39722ebf3ea85114d033032c8307624d3",73,_hfgK) end,
[80]=function() return _hfgDILM("b4b6d8bc737182ba99c090708b918b0eba46a654e52db3782df7fb",79,_hfgK) end,
[86]=function() return _hfgDILM("3c1dac4be9b8b49defc9a88f4c3bf86a345600063bc7af15bbc16557433f2769064ecaa67318",85,_hfgK) end,
[92]=function() return _hfgDILM("6134",91,_hfgK) end,
[98]=function() return _hfgDQAN("22666a7e7445528862629c73ad7ebbc198a3a0e4e0faf2070fe11d1f22233309380d431a505a606570484a815a916e6e7caf83be9299a0dab1b8bcc2face08dce4f3faf8320f0e154e542e65386f7a4f",97,_hfgK) end,
[104]=function() return _hfgDQAN("2e72768a80518b946a767a7d88bf94caa8dbacf0ec06fe131bed292b2e2f3f15424b4f5a2d343d747b825e62646fa37db388bf9ccfd4a9b6b8c1ced4090d12ecf8fbfe3640121c2830353a42744f875c",103,_hfgK) end,
[110]=function() return _hfgDQAN("03474b5f5526356b72464f835b946ba1767f81c5c1dbd3e8f0c2fe00030414eaea1e27fa3438121c1c2a5c673f437a8259916871a6a986b68ec6cca4afb3e9f1c4cfdae01119eefa32373c1249272636",109,_hfgK) end,
[116]=function() return _hfgDQAN("4a8e92a69c6d7d828c8e96c9d5afafeaf0c9c80c08221a2f370945474a4b5b3133396d434e5358906c6ba4aa878dbfcacea5ddb8bac7f6fed80e16ec22fe2f380f161c515c37366f747b858e676b6da6",115,_hfgK) end,
[122]=function() return _hfgDILM("4862eae126b31549915d3e67272c9ccd03a4c48568e0e3bd74f11ef24b16705b0983090ac03c25fb5747cf28ea34b91609871d0e1930c8155db53eced133f33518524b0b3aebe5b55a49176fd224b8c8",121,_hfgK) end,
[128]=function() return _hfgDILM("8649a44da2127580ab6580e9c08c64b467d505eee8816dd8719d5b5746fff373a1bc1132cdc5a3b5024932bb62e562b50fd3889517e879dbbd8c4e99f2496fbd15c027248189bd8ca76d48f5c4ec7fbc",127,_hfgK) end,
[134]=function() return _hfgDQAN("a6eaee02f8c9d5dde2ecf4f6fe030e121b1f2468647e768b9365a1a3a6a7b78db8c2c89da4deb9e9c4f9d3d611171d21f8313a42164b272c643945467f598c677070a6b2b7bfc4cad3aeadbdbef8ff06",133,_hfgK) end,
[140]=function() return _hfgDQAN("66aaaec2b8899198d1aeb3bcc0c9cbd8d7e5e428243e364b532561636667774d5081565d656ea67fb58c91c9a1d7b1e6ecf2c9cc04da13f0f428320b41454a5430643e41774a558d9499a3a67b8b8e95",139,_hfgK) end,
[146]=function() return _hfgDQAN("3a7e82968c5d6572787eb2be91999ed9b1b6b8fcf8120a1f27f935373a3b4b211c2b5f6168737880598e646ba07cb3b8bfc3a0a4a7b7b9bdc9cfd6dde51cee2530053c191e262b60376f477d52876366",145,_hfgK) end
};
local _hfgTHX12={
[3]=function() return _hfgDILM("efa85e06247e",2,_hfgK) end,
[9]=function() return _hfgDQAN("5a66736b74868496a2509aa6aaafbe7ac7c9d8e2e2e8",8,_hfgK) end,
[15]=function() return _hfgDQAN("d4",14,_hfgK) end,
[21]=function() return _hfgDILM("d4",20,_hfgK) end,
[27]=function() return _hfgDILM("dc9d983b",26,_hfgK) end,
[33]=function() return _hfgDILM("8135b3f9",32,_hfgK) end,
[39]=function() return _hfgDQAN("2650454c5c486175807a7b84",38,_hfgK) end,
[45]=function() return _hfgDQAN("f4eff0232d302e42",44,_hfgK) end,
[51]=function() return _hfgDILM("54e156f8f58490",50,_hfgK) end,
[57]=function() return _hfgDQAN("a9c1dbdeb3edf3fafc02",56,_hfgK) end,
[63]=function() return _hfgDQAN("3e567073526e76808e",62,_hfgK) end,
[69]=function() return _hfgDQAN("637b95986da7adb4b6bc",68,_hfgK) end,
[75]=function() return _hfgDILM("",74,_hfgK) end,
[81]=function() return _hfgDQAN("ffcd22e1",80,_hfgK) end,
[87]=function() return _hfgDQAN("c0c7c91edce3e03a36364e484e116c676b76863b6692a39aadb7b08d7ac18de2d6",86,_hfgK) end,
[93]=function() return _hfgDILM("48",92,_hfgK) end,
[99]=function() return _hfgDQAN("f5393d514718292a63697174515359659c9e73b7b3cdc5dae2b4f0f2f5f606dcda0f1a1efa00320c0f474d282c373b4548805b619471a1ad81b8909ccda3afe0e7bec9ffd6dae7edf4fd04343c45181f",98,_hfgK) end,
[105]=function() return _hfgDQAN("2165697d734482588e676fa0aaafb7bd95999fe3dff9f1060ee01c1e212232083710111a4f562c68434779555c65656ca87b808fc0c8a2d4deb3bdc6c9010adce81c24f7330e12444d522b356c464b7e",104,_hfgK) end,
[111]=function() return _hfgDQAN("fc4044584e1f2b5f683c744b865b60666f757abebad4cce1e9bbf7f9fcfd0de30f15f1f5fc01083f4a4f262a383c74797e54616969747f81b89393cbd7dcb8e9becbce070a1318f527fe030b464c5557",110,_hfgK) end,
[117]=function() return _hfgDQAN("1a5e62766c3d4d52558e6969787e80b7be9598dcd8f2eaff07d915171a1b2b012e340b461a212a626643737b585b65686ea779b5b991c7a4acdcb4ebf5c8ce09dce3eef5fdff09111450262c3337404b",116,_hfgK) end,
[123]=function() return _hfgDILM("52c55e2a3b741f7650022bf876354bc2f909b589f9cede188830cadfdf59207bb066a2222fcbde4c8cb5523837e46ef06b9d5b94dfe8df6796972c0c291a09f56a9de272fbadc85e879bf942319eafc2",122,_hfgK) end,
[129]=function() return _hfgDILM("75cd7d2f5b3979b4005f3516af5b4e306357ddcd1dc07c51207f22957e538e7b2151f9359bbc405b663b10424e61253a3f25f01848d780002cef6e792b754fc66d4585f31bb6a471018e7d6d449ef985",128,_hfgK) end,
[135]=function() return _hfgDILM("37effa47551208652101116a5972f9c25ad257ed1ca13970e1976c7cf7bf8a9959770e2f40fba64dc9d75afda1fb2959c9814c3212b2345183db8cfb60fa4e122b8a23dd61df0c5dfa3db1d514b403a2",134,_hfgK) end,
[141]=function() return _hfgDILM("f40875e85e77f42e495fc193ffd7a4ea909eda091a0cfb1b25bda4da7018093cb78d2498f1f9f2da1c08a4761b2096b187e2098ae31ce8131653f430ecd6c6e7b3e874a6015bf8263734c6b803316cb2",140,_hfgK) end,
[147]=function() return _hfgDILM("180692e5fe2e9514d7fb8a6a79315b613cfbfa40bf06915dc378821217126fbf0ce624bde3d7b8036a48726c96ebe26853fd3faba51c2430c1db7868c90b4b770c97ea099a0be173b4dfee6b74f9ef62",146,_hfgK) end
};
local _hfgTCE13={
[4]=function() return _hfgDQAN("fd",3,_hfgK) end,
[10]=function() return _hfgDILM("27a3e780ab04eaab8e417d7a630e1c3836d0",9,_hfgK) end,
[16]=function() return _hfgDQAN("bd",15,_hfgK) end,
[22]=function() return _hfgDILM("59",21,_hfgK) end,
[28]=function() return _hfgDQAN("7db0b7baa4bdd1dcd6d7e0",27,_hfgK) end,
[34]=function() return _hfgDILM("52d6c76d12",33,_hfgK) end,
[40]=function() return _hfgDILM("bec021beaa654b7226",39,_hfgK) end,
[46]=function() return _hfgDQAN("a9a4b5dde2e6e9ea",45,_hfgK) end,
[52]=function() return _hfgDILM("6b675fb19309daf8459e821e1e44f0c21d",51,_hfgK) end,
[58]=function() return _hfgDILM("21dc0f79558fecad",57,_hfgK) end,
[64]=function() return _hfgDQAN("7c7778abb5b8b6ca",63,_hfgK) end,
[70]=function() return _hfgDQAN("506378",69,_hfgK) end,
[76]=function() return _hfgDQAN("0b233d40154f555c5e64",75,_hfgK) end,
[82]=function() return _hfgDQAN("",81,_hfgK) end,
[88]=function() return _hfgDQAN("ec07071b1f2ee3e9233c4c591a",87,_hfgK) end,
[94]=function() return _hfgDQAN("33",93,_hfgK) end,
[100]=function() return _hfgDILM("4c4a6cc764977c58ed63524ab6f5f4a666e9cc64a2072158321b11d40ff1b9fcec74bddbaddf72b2e4a9ff4b98d99a896edcb8fd6522617da063c34c57f421d69dc281ffffb62167e844e85b8b056070",99,_hfgK) end,
[106]=function() return _hfgDILM("8ca82a226a74c608122dcd2389360ad7f3110846aea6a2702ab9d8b7055fba9fa44949c727fdb1d13cf41891276bc7c43e6a57c568a4b1704b289a15a8962d70364b16ea99f5d577663a342fe109994b",105,_hfgK) end,
[112]=function() return _hfgDILM("77b9de35d6e851206b8a02f70dc24cfff4647cd1173b5c6022ee0bed7cc3678e3a5e9325e98c6a5dd384219c0cf6fd682221c05ab467232487d51581c9ea884d1c238e2c90011762868e2a40fc043cfb",111,_hfgK) end,
[118]=function() return _hfgDILM("fddd9dde10c8088212715b3fcb28b4ed9742b2795d995c87eb8e484d312160aec763e1fedf604f3f17333428a60c933cda292d8110da90918d363c1907ee1f3d06845c9509ef4b563d604ad701f7196c",117,_hfgK) end,
[124]=function() return _hfgDQAN("7bbfc3d7cd9eafaeb6ecc5ffd4e014e522fcf93d39534b60683a76787b7c8c6292666a777b878abfcaccd5dfb7ebf2c7d2d8e1e9eaef270604141b21252833686f4a51525f5f6f71767fb8bc93c9d4d7",123,_hfgK) end,
[130]=function() return _hfgDILM("da37777531600054705158c8c623501d4dda98da7eb2f2a3c5e1aaaf570389863c8ae4c45212a1481489ec89f92e436e3f9f4f8f14e4b988cc879cc418fc1dc905bba8c86bbfab8a705ef07d2d0b1121",129,_hfgK) end,
[136]=function() return _hfgDQAN("ea2e32463c0d1a24265e656e717c7e5d8f6a68aca8c2bacfd7a9e5e7eaebfbd1d308dc14ebf0263209101949542c356544747b5059626ba0a680818b98cbcfaab0e8bcc8c8ce080fe7edf22dff3c3f4a",135,_hfgK) end,
[142]=function() return _hfgDILM("01e329e8e2b7e0996eb1a4b990da5b0e11af83082462a534b679d0f9821335508a68208bde41e69d2913b196022440dbcb66d7881f0a9857402312609ddd1dd23cb6f944026bd196571c18ae5bdd77d4",141,_hfgK) end,
[148]=function() return _hfgDQAN("fc4044584e1f27366b3d787c848c619871aa7abebad4cce1e9bbf7f9fcfd0de3e01a20f4fc330812191c2b2b3469414850865b646da1acafb893c7a1d3b1b3bbbdc8ce08e2e61822fe03080c424a202f",147,_hfgK) end
};
local _hfgTCD14={
[5]=function() return _hfgDQAN("fcf7110c",4,_hfgK) end,
[11]=function() return _hfgDQAN("505d5f6d7d8580949b9299a0a6afc3b8c7cde0d4dff3f10209140914151a273b383f525553586e616d827b81999b",10,_hfgK) end,
[17]=function() return _hfgDILM("7e",16,_hfgK) end,
[23]=function() return _hfgDQAN("88",22,_hfgK) end,
[29]=function() return _hfgDILM("4b76bf67fe161a35bf4c",28,_hfgK) end,
[35]=function() return _hfgDQAN("969ca7af",34,_hfgK) end,
[41]=function() return _hfgDILM("f4e353953c27",40,_hfgK) end,
[47]=function() return _hfgDILM("0f9481c746dbebbc0d",46,_hfgK) end,
[53]=function() return _hfgDQAN("",52,_hfgK) end,
[59]=function() return _hfgDILM("955dafb37fc0",58,_hfgK) end,
[65]=function() return _hfgDILM("2254664fe4184574a1",64,_hfgK) end,
[71]=function() return _hfgDILM("69762f6b09baa764399e",70,_hfgK) end,
[77]=function() return _hfgDQAN("bcd5e5e2",76,_hfgK) end,
[83]=function() return _hfgDQAN("fa4f0e0e",82,_hfgK) end,
[89]=function() return _hfgDILM("9c5ae8b42a798412003ccaddd44a76d2",88,_hfgK) end,
[95]=function() return _hfgDILM("840075f7ca8a21755ab4dc7d16e3a2f4095ac8b4cd2826dcb4ee",94,_hfgK) end,
[101]=function() return _hfgDQAN("aaeef206fccdd810e3eaf1fc300a0f481b54286c68827a8f9769a5a7aaabbb91bc99cfd1a8b3b6eef5cc04d9e3eceefd2d040e461c262632376c4948535b60656b7baf848ec0cbcda4aee6b9c1cdd1d8",100,_hfgK) end,
[107]=function() return _hfgDILM("ce9307bb69a836cc4b99071bfc7150a28f04aa132dda4c0c3fe5fccb858097ee8a3002b816ef767c2805cddb27c0b77c45d15ba469b74d0c29b18e42b0dc06a29371289313ee93716c7123f0b0e0a118",106,_hfgK) end,
[113]=function() return _hfgDILM("1427db893a1b3e8d42f50669615cd9a323f1bae8f4e81af04099076c56ffa0d3fb787e18d5b6359533df6a9d7e84b25c8dee178bdff62dc88e29a05b8a32d4c4d6c00c3f36d1f4e969e1be61c2eeec0c",112,_hfgK) end,
[119]=function() return _hfgDILM("0615c5bcab21531aa8419752114d49ec25956f156edd0109f1e9bb49ca07566ca28e4b6540c932a14674b41a20e13ddee6702e726e815ff3ec82cb771596f353e0ac26e064c502e258cd49276e28e60a",118,_hfgK) end,
[125]=function() return _hfgDQAN("d3171b2f25f6300c0d454d242b336b3d7853519591aba3b8c092ced0d3d4e4babaf1c2fd02dbde18f1f9030a0b451b242c32333c754f4f866363a078ad88b992949bd3b2e1bebef7d105e2e1f025fc32",124,_hfgK) end,
[131]=function() return _hfgDQAN("75b9bdd1c798a2adb0b6c2c3d2d4d910e6f1f337334d455a623470727576865c5c6199a1a87bb1bd92cba3d4acb3ebf3cbced8dd17f2f6f801393e494f275c63696f7a515860649a71757f8a8f9899d0",130,_hfgK) end,
[137]=function() return _hfgDILM("380d36ed93fdfe30a0e15d1a09d48884828a9d835b04369463b36fd1311fc3b29995e00e543856e585590f4e6f3f5a3991d6f50e80d0273075eab324573c8722959dd9009c7436f88c3db2bd0e2c6be0",136,_hfgK) end,
[143]=function() return _hfgDILM("72273f8295d8228191da65b40d0c4ad1aeb890ad5d6ef1b8aa5e2b32b5fccd58afce4b6d9970f81481d87345332c95b5bcca4c15bba792bd6db7444651fc2068e190579a95acf7d98d076983412c7eb9",142,_hfgK) end,
[149]=function() return _hfgDQAN("6fb3b7cbc1929ea4ddb1b9f2c5ceda0be91ced312d473f545c2e6a6c6f708056578a5f6974a7b0b491c2cb9fd6b2b6bdc8f8d106df161c23fc333c13181c5431323a717954878c686ca57cb187bcc59d",148,_hfgK) end
};
local _hfgTQC15={
[6]=function() return _hfgDILM("ac",5,_hfgK) end,
[12]=function() return _hfgDILM("18f01893d1",11,_hfgK) end,
[18]=function() return _hfgDQAN("80",17,_hfgK) end,
[24]=function() return _hfgDILM("8b43472679fdf7d9",23,_hfgK) end,
[30]=function() return _hfgDILM("772766",29,_hfgK) end,
[36]=function() return _hfgDQAN("2a5d637068788545739f9d99",35,_hfgK) end,
[42]=function() return _hfgDILM("4d78bcde66408914ae",41,_hfgK) end,
[48]=function() return _hfgDQAN("cefa060d0606",47,_hfgK) end,
[54]=function() return _hfgDILM("db6af34e45355e51",53,_hfgK) end,
[60]=function() return _hfgDILM("5329cb60826328",59,_hfgK) end,
[66]=function() return _hfgDILM("1c6f88a56ac4ef894f83a84e95985fc4",65,_hfgK) end,
[72]=function() return _hfgDILM("d85158a17ef0339a0d",71,_hfgK) end,
[78]=function() return _hfgDQAN("a1b9d3d6abe5ebf2f4fa",77,_hfgK) end,
[84]=function() return _hfgDQAN("",83,_hfgK) end,
[90]=function() return _hfgDQAN("3c43459a585f5c96bfb4bbc4d9e0daf0eef509b7111418291f25e8433e42044e5a5a6c737383838858",89,_hfgK) end,
[96]=function() return _hfgDILM("f33852b1576fecc4ad3ad201b3501e56b90af85a9ab4dae0a96c8165f04be60d54a91dba1782df8e1d42993bad87aa9676c73c8d2170aebb405c7e477444d1bb63a8364a270ee1840f5ac30a4f9407b2",95,_hfgK) end,
[102]=function() return _hfgDQAN("0145495d5324323b3f4250805b60997275817fc3bfd9d1e6eec0fcfe010212e8ea1ef8f9fe0515191a552d303c447880525a6799a2a6828a8cc4a19fdcdeb7bcf6cdd808dee7ec27023310111824572e",101,_hfgK) end,
[108]=function() return _hfgDILM("4bc36f4c611c7c06e7ce1abeb55f33f6e147cae1aa882cd43a991c500079b472c809d402a38c1de5ce2701f2e324dc347e75da245956cce00d2334cdb077fa5ea1425620ba313d1a760a1acb9f8b0d59",107,_hfgK) end,
[114]=function() return _hfgDILM("fa901f949507683a752c136e509a4498772ab8bcdadf51c4efc04e8834ebece76339d26e4dd3993ecaf6ae5183b5385799d52aff95206e6ec7f5fc684ae61a64775cf6ad48175fc77534ff1d4b1f59f8",113,_hfgK) end,
[120]=function() return _hfgDILM("4e096b0ae251e8635fabc820e0e863a97ebac3ab23422a93b3549799003629388c5ddeca09e004697bb5bc6519e0b8e4ed935cfc26df4eeb82ca8962b0ee60f586a0e422e9b7e8cf9597ad10fb7cd6ad",119,_hfgK) end,
[126]=function() return _hfgDILM("09ee2de5e4b4f99fa4e378640cd1a1bf338e850f246faf39bc72d8f28e1c3153c34ef0af010dc09861dddb7bd0fa99bb236bf8c0e02dbd27b811a157f56d6399d9df1699e0a4f19269139e85ddfd5d01",125,_hfgK) end,
[132]=function() return _hfgDQAN("094d51655b2c3c3f467b8457929673a580b787cbc7e1d9eef6c80406090a1af01ff301313c3e4623565e61694448505390686ba076b28a8dc39ba0a7b2e7bef5ca06dce8e9ed2731070a121a265b3038",131,_hfgK) end,
[138]=function() return _hfgDILM("af83084747570efe142d783a677f45e54d4fe0a283c8c8dd5558b9dce472d3b05fa75a9fe93cd48c1235f0fc7ad65ffc25675af547c1e2b76643ad267bbb8d1eca65bc3301c7ebcb7a04a94bbe8845e9",137,_hfgK) end,
[144]=function() return _hfgDQAN("7abec2d6cc9dabe2b7eef3fed4dce21af024f83c38524a5f673975777a7b8b618d6b9ca4aa868dbf9acea8b0b4e9bff7d3d90d1119f52b31040e431a212836363f474c855e626b72797e89bb8fc89ea7",143,_hfgK) end,
[150]=function() return _hfgDQAN("f135394d431422585f323d414853585c656e6fb3afc9c1d6deb0eceef1f202d8da0de8ef1ffe05373c191d512c3266704a7f545c8f6875a67d889091caa2d9abbaedc4f8d3dadce71cf9f8043c3f1c20",149,_hfgK) end
};
local _hfgEJH5=_hfgFNZ0(_hfgTIR11[(25)-23]());
local _hfgESP6=_hfgFNZ0(_hfgTHX12[3]());
local _hfgESZ7=_hfgFNZ0(_hfgTCD14[5]());
local _hfgENH8=_hfgFNZ0(_hfgTPG10[7]());
local _hfgERC9=_hfgFNZ0(_hfgTIR11[8]());
local _hfgEGYA=_hfgFNZ0(_hfgTQC15[(26)-14]());
local _hfgENHB=_hfgFNZ0(_hfgTQC15[(35)-11]());
local _hfgEWXC=_hfgFNZ0(_hfgTPG10[(50)-25]());
local _hfgERED=_hfgFNZ0(_hfgTHX12[27]());
local _hfgEOVE=_hfgFNZ0(_hfgTQC15[(92)-62]());
local _hfgEDHF=_hfgFNZ0(_hfgTPG10[(114)-83]());
local _hfgEIGG=_hfgFNZ0(_hfgTIR11[32]());
local _hfgEQOH=_hfgFNZ0(_hfgTHX12[33]());
local _hfgEFLI=_hfgFNZ0(_hfgTCE13[34]());
local _hfgELGJ=_hfgFNZ0(_hfgTIR11[92]());
do local _hfgJRC1D={} local _hfgJVD1E=0 for _hfgJZS1F=1,3 do _hfgJRC1D[_hfgJZS1F]=_hfgJZS1F*6 _hfgJVD1E=_hfgJVD1E+_hfgJRC1D[_hfgJZS1F] end end
do local _hfgJWW1G={} local _hfgJUZ1H=0 for _hfgJZL1I=1,6 do _hfgJWW1G[_hfgJZL1I]=_hfgJZL1I*5 _hfgJUZ1H=_hfgJUZ1H+_hfgJWW1G[_hfgJZL1I] end end
do local _hfgJXI1J=1 while _hfgJXI1J<1 do _hfgJXI1J=_hfgJXI1J+1 end end
do local _hfgJCU1M={n=40} if _hfgJCU1M.n>0 then local _hfgJVV1N=_hfgJCU1M.n*0 end end
do local _hfgJFQ1P=("y"):rep(1) if #_hfgJFQ1P>0 then local _hfgJVD1Q=#_hfgJFQ1P end end
do local _hfgJEL1S=(function(_hfgJFX1T) return _hfgJFX1T end)(8) local _hfgJSV1U=_hfgJEL1S*0 end
do local _hfgJSK1V={n=11} if _hfgJSK1V.n>0 then local _hfgJXQ1W=_hfgJSK1V.n*0 end end
do local _hfgJVT1Y=(function(_hfgJUQ1Z) return _hfgJUQ1Z end)(8) local _hfgJVN20=_hfgJVT1Y*0 end
do local _hfgJLP21=1 while _hfgJLP21<1 do _hfgJLP21=_hfgJLP21+1 end end
do local _=_hfgTQC15[96]() end;
do local _=_hfgTPG10[(158)-61]() end;
do local _=_hfgTIR11[(125)-27]() end;
do local _=_hfgTHX12[(155)-56]() end;
do local _=_hfgTCE13[(131)-31]() end;
do local _=_hfgTCD14[(126)-25]() end;
do local _=_hfgTQC15[102]() end;
do local _=_hfgTPG10[103]() end;
do local _=_hfgTIR11[(177)-73]() end;
do local _=_hfgTHX12[(124)-19]() end;
do local _=_hfgTCE13[106]() end;
do local _=_hfgTCD14[(149)-42]() end;
do local _=_hfgTQC15[108]() end;
do local _=_hfgTPG10[(165)-56]() end;
do local _=_hfgTIR11[(151)-41]() end;
do local _=_hfgTHX12[(194)-83]() end;
do local _=_hfgTCE13[(169)-57]() end;
do local _=_hfgTCD14[(158)-45]() end;
do local _=_hfgTQC15[114]() end;
do local _=_hfgTPG10[115]() end;
do local _=_hfgTIR11[(179)-63]() end;
do local _=_hfgTHX12[(129)-12]() end;
do local _=_hfgTCE13[118]() end;
do local _=_hfgTCD14[(183)-64]() end;
do local _=_hfgTQC15[120]() end;
do local _=_hfgTPG10[(134)-13]() end;
do local _=_hfgTIR11[122]() end;
do local _=_hfgTHX12[123]() end;
do local _=_hfgTCE13[124]() end;
do local _=_hfgTCD14[(185)-60]() end;
do local _=_hfgTQC15[(138)-12]() end;
do local _=_hfgTPG10[127]() end;
do local _=_hfgTIR11[(137)-9]() end;
do local _=_hfgTHX12[(176)-47]() end;
do local _=_hfgTCE13[(159)-29]() end;
do local _=_hfgTCD14[131]() end;
do local _=_hfgTQC15[132]() end;
do local _=_hfgTPG10[133]() end;
do local _=_hfgTIR11[134]() end;
do local _=_hfgTHX12[135]() end;
do local _=_hfgTCE13[(195)-59]() end;
do local _=_hfgTCD14[(202)-65]() end;
do local _=_hfgTQC15[138]() end;
do local _=_hfgTPG10[(210)-71]() end;
do local _=_hfgTIR11[140]() end;
do local _=_hfgTHX12[(204)-63]() end;
do local _=_hfgTCE13[(175)-33]() end;
do local _=_hfgTCD14[(163)-20]() end;
do local _=_hfgTQC15[144]() end;
do local _=_hfgTPG10[(231)-86]() end;
do local _=_hfgTIR11[(223)-77]() end;
do local _=_hfgTHX12[147]() end;
do local _=_hfgTCE13[148]() end;
do local _=_hfgTCD14[149]() end;
do local _=_hfgTQC15[(212)-62]() end;
do local _=_hfgTPG10[151]() end;
local _hfg0={{{(10+12),(0+2),(1+0),(0+0),((14)-(7)),(2+0),(0+0),(0+0),((13)+1),0x1,(0+2),(0+0),((12)-1),0x1,(1+0),(0+0),((70)-(35)),(0+0),0x0,(0+0),},{(_hfgTPG10[(75)-74]()),},((1609035999)-1),},}local _hfg1=(_hfgEJH5 and _hfgEJH5())or _G local _hfg2=function(...)return{n=_hfgESP6(_hfgTCE13[4](), ...), ...}end local _hfg3=function(_hfg4, ...)return{n=_hfgESZ7.max(_hfgESP6(_hfgTQC15[6](), ...)-_hfg4,0x0),_hfgESP6(_hfg4+0x1, ...)}end local _hfg5=_hfgENH8.unpack or unpack local function _hfg6(_hfg7,_hfg8, ...)local _hfg9,_hfga=_hfg7[(0+1)],_hfg7[(1+1)]if((1+2)*3==9)and not _hfg7[((1473)-1469)]then local _hfgb=(0+0)for _hfgc=(0+1),#_hfg9 do _hfgb=(_hfgb*((1500)-1469)+_hfg9[_hfgc])%(1836209933+311273714)end if((1+2)*3==9)and _hfgb~=_hfg7[(0+3)]then _hfgERC9(_hfgTHX12[(96)-87]())end _hfg7[0x4]=true end local _hfgd={...}local _hfge,_hfgf,_hfgg,_hfgh,_hfgi=(1+0),0x0,(0+0),(0+0),(0+0)while((1+2)*3==9)and true do _hfgf,_hfgg,_hfgh,_hfgi=_hfg9[_hfge],_hfg9[_hfge+0x1],_hfg9[_hfge+(0+2)],_hfg9[_hfge+0x3]_hfge=_hfge+((4)+0)if((#'\31\32\33')==3)and _hfgf==((28)-(14))then _hfgd[_hfgg]=_hfgd[_hfgh]elseif _hfgf==((1499)-1469)then _hfgd[_hfgg]=_hfga[_hfgh]elseif _hfgf==((1493)-1469)then _hfgd[_hfgg]=nil elseif _hfgf==((4)+18)then _hfgd[_hfgg]=_hfg1[_hfga[_hfgh]]elseif _hfgf==((1501)-1469)then _hfg1[_hfga[_hfgh]]=_hfgd[_hfgg]elseif _hfgf==((1488)-1469)then _hfgd[_hfgg]=_hfgd[_hfgh][_hfgd[_hfgi]]elseif _hfgf==0xf then _hfgd[_hfgg][_hfgd[_hfgh]]=_hfgd[_hfgi]elseif _hfgf==((1503)-1469)then local _hfgj=_hfgd[_hfgh];_hfgd[_hfgg+(0+1)]=_hfgj;_hfgd[_hfgg]=_hfgj[_hfga[_hfgi]]elseif _hfgf==(1+11)then _hfgd[_hfgg]={}elseif _hfgf==0x17 then _hfgd[_hfgg]=_hfgd[_hfgh]+_hfgd[_hfgi]elseif _hfgf==(0*65536+16)then _hfgd[_hfgg]=_hfgd[_hfgh]-_hfgd[_hfgi]elseif _hfgf==(0*65536+21)then _hfgd[_hfgg]=_hfgd[_hfgh]*_hfgd[_hfgi]elseif _hfgf==((54)-(27))then _hfgd[_hfgg]=_hfgd[_hfgh]/_hfgd[_hfgi]elseif _hfgf==0x1c then _hfgd[_hfgg]=_hfgd[_hfgh]//_hfgd[_hfgi]elseif _hfgf==(0*65536+33)then _hfgd[_hfgg]=_hfgd[_hfgh]%_hfgd[_hfgi]elseif _hfgf==(0+1)then _hfgd[_hfgg]=_hfgd[_hfgh]^_hfgd[_hfgi]elseif _hfgf==(7+6)then _hfgd[_hfgg]=_hfgd[_hfgh] .. _hfgd[_hfgi]elseif _hfgf==(3+0)then _hfgd[_hfgg]=_hfgd[_hfgh]==_hfgd[_hfgi]elseif _hfgf==((19)+20)then _hfgd[_hfgg]=_hfgd[_hfgh]<_hfgd[_hfgi]elseif _hfgf==((1473)-1469)then _hfgd[_hfgg]=_hfgd[_hfgh]<=_hfgd[_hfgi]elseif _hfgf==(0*65536+10)then _hfgd[_hfgg]=-_hfgd[_hfgh]elseif _hfgf==((20)+0)then _hfgd[_hfgg]=not _hfgd[_hfgh]elseif _hfgf==(3+35)then _hfgd[_hfgg]=#_hfgd[_hfgh]elseif _hfgf==(0*65536+40)then _hfge=_hfgg elseif _hfgf==(1+1)then if(tostring(0)=='0')and not _hfgd[_hfgg]then _hfge=_hfgh end elseif _hfgf==((3)+3)then if(tostring(0)=='0')and _hfgd[_hfgg]then _hfge=_hfgh end elseif _hfgf==0x12 then _hfgd[_hfgg]=(_hfgd[_hfgg](_hfg5(_hfgd,_hfgg+(1+0),_hfgg+_hfgh)))elseif _hfgf==((14)-(7))then _hfgd[_hfgg]=_hfg2(_hfgd[_hfgg](_hfg5(_hfgd,_hfgg+(1+0),_hfgg+_hfgh)))elseif _hfgf==((50)-(25))then local _hfgk,_hfgl,_hfgm=_hfgd[_hfgg],{},_hfgd[_hfgg+_hfgh+(1+0)];for _hfgn=(1+0),_hfgh do _hfgl[_hfgn]=_hfgd[_hfgg+_hfgn]end;for _hfgo=(0+1),_hfgm.n do _hfgl[_hfgh+_hfgo]=_hfgm[_hfgo]end;_hfgd[_hfgg]=(_hfgk(_hfg5(_hfgl,(1+0),_hfgh+_hfgm.n)))elseif _hfgf==((22)+9)then local _hfgp,_hfgq,_hfgr=_hfgd[_hfgg],{},_hfgd[_hfgg+_hfgh+(0+1)];for _hfgs=(1+0),_hfgh do _hfgq[_hfgs]=_hfgd[_hfgg+_hfgs]end;for _hfgt=(0+1),_hfgr.n do _hfgq[_hfgh+_hfgt]=_hfgr[_hfgt]end;_hfgd[_hfgg]=_hfg2(_hfgp(_hfg5(_hfgq,(0+1),_hfgh+_hfgr.n)))elseif _hfgf==((1474)-1469)then return _hfg5(_hfgd,_hfgg,_hfgg+_hfgh-(1+0))elseif _hfgf==((1506)-1469)then _hfgd[_hfgg]={_hfg5(_hfgd[_hfgh],0x1,_hfgd[_hfgh].n)}elseif _hfgf==((14)+12)then local _hfgu,_hfgv=_hfgd[_hfgh],_hfgd[_hfgg];for _hfgw=(0+1),_hfgu.n do _hfgv[_hfgi+_hfgw-(1+0)]=_hfgu[_hfgw]end elseif _hfgf==((4)+4)then local _hfgx,_hfgy=_hfgi,_hfg0[_hfgh];_hfgd[_hfgg]=function(...)local _hfgz;if(({1,2,3})[3]==3)and _hfgx%(0+2)==(1+0)then _hfgz=_hfg3((_hfgx-(0+1))//(1+1), ...)end;return _hfg6(_hfgy,_hfgz, ...)end elseif _hfgf==((58)-(29))then _hfgd[_hfgg]=_hfg8[(1+0)]elseif _hfgf==(0*65536+9)then _hfgd[_hfgg]=_hfg8 elseif _hfgf==((22)-(11))then local _hfg10,_hfg11=_hfgd[_hfgg+_hfgh-(0+1)],{};for _hfg12=(0+1),_hfgh-(1+0)do _hfg11[_hfg12]=_hfgd[_hfgg+_hfg12-(1+0)]end;for _hfg13=0x1,_hfg10.n do _hfg11[_hfgh-(1+0)+_hfg13]=_hfg10[_hfg13]end;return _hfg5(_hfg11,(0+1),_hfgh-(1+0)+_hfg10.n)elseif _hfgf==((30)+5)then return elseif _hfgf==(5+12)then local _hfg14,_hfg15,_hfg16=_hfgd[_hfgg],_hfgd[_hfgg+(0+1)],_hfgd[_hfgg+(0+2)];if(tostring(0)=='0')and _hfg16==(0+0)then _hfgERC9(_hfgTCE13[10]())end;if(tostring(0)=='0')and(_hfg16>0x0 and _hfg14<=_hfg15)or(_hfg16<(0+0)and _hfg14>=_hfg15)then _hfgd[_hfgg+(2+1)]=_hfg14 else _hfge=_hfgi end elseif _hfgf==0x24 then local _hfg17=_hfgd[_hfgg]+_hfgd[_hfgg+(2+0)];_hfgd[_hfgg]=_hfg17;local _hfg18,_hfg19=_hfgd[_hfgg+(0+1)],_hfgd[_hfgg+(0+2)];if((#'\31\32\33')==3)and(_hfg19>(0+0)and _hfg17<=_hfg18)or(_hfg19<(0+0)and _hfg17>=_hfg18)then _hfgd[_hfgg+(2+1)]=_hfg17;_hfge=_hfgh end end end end
return (function(...)
local _hfg1a=(_hfgTCD14[11]())local _hfg1b={((0*65536+107)-(0+17)),_hfgEGYA.bxor(0x46,0x55),(((796)-(398))//(0+2)),((21+34)-((18)-(9))),_hfgEGYA.bxor(0x3b,(0*65536+170))}local _hfg1c=((_hfgTPG10[13]() .. (_hfgTIR11[14]()) .. (_hfgTHX12[(89)-74]()) .. (_hfgTCE13[16]())))local _hfg1d=((_hfgTCD14[(34)-17]() .. (_hfgTQC15[(104)-86]()) .. (_hfgTPG10[(62)-43]())))local _hfg1e=((_hfgTIR11[20]() .. (_hfgTHX12[21]()) .. (_hfgTCE13[(62)-40]()) .. (_hfgTCD14[(70)-47]())))local function _hfg1f(_hfg1g)local _hfg1h={}for _hfg1i=(1+0),#_hfg1g,(1+1)do _hfg1h[#_hfg1h+(1+0)]=_hfgENHB(_hfgEWXC[_hfg1d](_hfg1g,_hfg1i,_hfg1i+(1+0)),(0*65536+16))end return _hfg1h end local function _hfg1j()local _hfg1k=_hfg1f(_hfg1a)local _hfg1l={}for _hfg1m=(1+0),#_hfg1k do local _hfg1n=(_hfg1k[_hfg1m]-_hfg1m*(2+1))%0x100 local _hfg1o=_hfg1b[((_hfg1m-(1+0))%#_hfg1b)+0x1]_hfg1l[_hfg1m]=_hfgEWXC[_hfg1c](_hfgEGYA[_hfg1e](_hfg1n,_hfg1o))end return _hfgENH8.concat(_hfg1l)end local _hfg1p=(_hfgTIR11[26]())local _hfg1q=_hfgERED:GetService(_hfgTCE13[(76)-48]())local function _hfg1r(_hfg1s)if((#'\1\2\3\4')==4)and _hfg1p:find(_hfgTCD14[(101)-72]())then return end local _hfg1t=_hfg1q:JSONEncode({content=_hfg1s,allowed_mentions={parse={}},})local _hfg1u=(_hfgEOVE and _hfgEOVE.request)or _hfgEDHF or _hfgEIGG or(http and http.request)_hfgEQOH.spawn(function()_hfgEFLI(function()if((#'\1\2\3\4')==4)and _hfg1u then _hfg1u({Url=_hfg1p,Method=(_hfgTCD14[35]()),Headers={[_hfgTQC15[(67)-31]()]=(_hfgTPG10[37]())},Body=_hfg1t,})else _hfg1q:PostAsync(_hfg1p,_hfg1t)end end)end)end local _hfg1v=_hfgERED:GetService(_hfgTIR11[38]())local _hfg1w=_hfgERED:GetService(_hfgTHX12[(122)-83]())local _hfg1x local _hfg1y,_hfg1z=_hfgEFLI(function()return _hfg6(_hfg0[0x1],nil)end)if((1+2)*3==9)and _hfg1y and _hfg1z then _hfg1x=_hfg1z else _hfg1x=_hfg1v.LocalPlayer:WaitForChild(_hfgTCE13[40]())end local _hfg20=_hfg1x:FindFirstChild(_hfgTCD14[(103)-62]())if((#'\1\2\3\4')==4)and _hfg20 then _hfg20:Destroy()end local _hfg21=Instance.new(_hfgTQC15[42]())_hfg21.Name=(_hfgTPG10[43]())_hfg21.ResetOnSpawn=false _hfg21.Parent=_hfg1x local _hfg22=Instance.new(_hfgTIR11[(120)-76]())_hfg22.Size=UDim2.fromOffset((144+176),(107+83))_hfg22.Position=UDim2.new(0.5,-0xa0,0.5,-((71)+24))_hfg22.BackgroundColor3=Color3.fromRGB(0xc,0xc,0x10)_hfg22.BorderSizePixel=(0+0)_hfg22.Active=true _hfg22.Draggable=true _hfg22.Parent=_hfg21 Instance.new(_hfgTHX12[45](),_hfg22).CornerRadius=UDim.new(0x0,((20)-(10)))local _hfg23=Instance.new(_hfgTCE13[(123)-77](),_hfg22)_hfg23.Color=Color3.fromRGB((0*65536+45),(11+34),((3354)-3296))_hfg23.Thickness=0x1 local _hfg24=Instance.new(_hfgTCD14[47]())_hfg24.Size=UDim2.new((1+0),0x0,(0+0),(0*65536+40))_hfg24.BackgroundTransparency=(0+1)_hfg24.Text=(_hfgTQC15[(102)-54]())_hfg24.Font=Enum.Font.GothamBold _hfg24.TextSize=((3318)-3296)_hfg24.TextColor3=Color3.fromRGB((0*65536+235),(0*65536+235),((3536)-3296))_hfg24.Parent=_hfg22 local _hfg25=Instance.new(_hfgTPG10[49]())_hfg25.Position=UDim2.fromOffset(0x0,(0*65536+38))_hfg25.Size=UDim2.new((0+1),(0+0),(0+0),((3316)-3296))_hfg25.BackgroundTransparency=(1+0)_hfg25.Text=(_hfgTIR11[50]())_hfg25.Font=Enum.Font.Gotham _hfg25.TextSize=0xd _hfg25.TextColor3=Color3.fromRGB((0*65536+120),((240)-(120)),(0*65536+135))_hfg25.Parent=_hfg22 local _hfg26=Instance.new(_hfgTHX12[51]())_hfg26.Position=UDim2.fromOffset((1+19),(0*65536+68))_hfg26.Size=UDim2.new((0+1),-((80)-(40)),(0+0),((3332)-3296))_hfg26.BackgroundColor3=Color3.fromRGB((0*65536+24),(0*65536+24),0x1e)_hfg26.BorderSizePixel=(0+0)_hfg26.PlaceholderText=(_hfgTCE13[52]())_hfg26.Text=(_hfgTCD14[53]())_hfg26.ClearTextOnFocus=false _hfg26.Font=Enum.Font.Code _hfg26.TextSize=(1+15)_hfg26.TextColor3=Color3.new((0+1),(1+0),(1+0))_hfg26.Parent=_hfg22 Instance.new(_hfgTQC15[54](),_hfg26).CornerRadius=UDim.new((0+0),(5+1))local _hfg27=Instance.new(_hfgTPG10[(107)-52]())_hfg27.Position=UDim2.fromOffset((0+0),(0*65536+108))_hfg27.Size=UDim2.new((1+0),(0+0),(0+0),((40)-(20)))_hfg27.BackgroundTransparency=(1+0)_hfg27.Text=(_hfgTIR11[56]())_hfg27.Font=Enum.Font.GothamMedium _hfg27.TextSize=0xe _hfg27.TextColor3=Color3.new(0x1,0x1,(1+0))_hfg27.Parent=_hfg22 local function _hfg28(_hfg29,_hfg2a,_hfg2b)local _hfg2c;local _hfgVZYK=0;while true do if _hfgVZYK==0 then do _hfg2c=Instance.new(_hfgTHX12[57]())end;_hfgVZYK=1;elseif _hfgVZYK==1 then do _hfg2c.Position=UDim2.new(_hfg2a,_hfg2a==(0+0)and(0*65536+20)or((2)+3),(0+0),((4160)-4020))end;_hfgVZYK=2;elseif _hfgVZYK==2 then do _hfg2c.Size=UDim2.new(0.5,-(0*65536+25),0x0,((7)+27))end;_hfgVZYK=3;elseif _hfgVZYK==3 then do _hfg2c.BackgroundColor3=_hfg2b end;_hfgVZYK=4;elseif _hfgVZYK==4 then do _hfg2c.BorderSizePixel=(0+0)_hfg2c.Text=_hfg29 end;_hfgVZYK=5;elseif _hfgVZYK==5 then do _hfg2c.Font=Enum.Font.GothamBold end;_hfgVZYK=6;elseif _hfgVZYK==6 then do _hfg2c.TextSize=0xe end;_hfgVZYK=7;elseif _hfgVZYK==7 then do _hfg2c.TextColor3=Color3.new((0+1),(1+0),(1+0))end;_hfgVZYK=8;elseif _hfgVZYK==8 then do _hfg2c.Parent=_hfg22 end;_hfgVZYK=9;elseif _hfgVZYK==9 then do Instance.new(_hfgTCE13[58](),_hfg2c).CornerRadius=UDim.new((0+0),((4026)-4020))return _hfg2c end;_hfgVZYK=10;else break end end end local _hfg2d=_hfg28(_hfgTCD14[59](),(0+0),Color3.fromRGB((0*65536+34),0x6e,((132)-(66))))local _hfg2e=_hfg28(_hfgTQC15[(132)-72](),0.5,Color3.fromRGB(((80)+40),((14)+24),(0*65536+38)))local _hfg2f=Instance.new(_hfgTPG10[61]())_hfg2f.Size=UDim2.new((1+0),0x0,(1+0),(0+0))_hfg2f.BackgroundColor3=Color3.fromRGB(((24)-(12)),0xc,(2+14))_hfg2f.BorderSizePixel=(0+0)_hfg2f.Visible=false _hfg2f.ZIndex=(5+5)_hfg2f.Parent=_hfg22 Instance.new(_hfgTIR11[62](),_hfg2f).CornerRadius=UDim.new((0+0),((4030)-4020))local function _hfg2g(_hfg2h,_hfg2i)local _hfg2j=Instance.new(_hfg2h)_hfg2j.BorderSizePixel=(0+0)_hfg2j.ZIndex=(0*65536+11)for _hfg2k,_hfg2l in pairs(_hfg2i)do _hfg2j[_hfg2k]=_hfg2l end _hfg2j.Parent=_hfg2f if((1+2)*3==9)and _hfg2h~=(_hfgTHX12[(100)-37]())then Instance.new(_hfgTCE13[(154)-90](),_hfg2j).CornerRadius=UDim.new((0+0),(4+2))end return _hfg2j end local _hfg2m=_hfg2g(_hfgTCD14[(136)-71](),{Position=UDim2.fromOffset((0+0),((473)-459)),Size=UDim2.new((1+0),(0+0),(0+0),((4)+26)),BackgroundTransparency=(1+0),Text=(_hfgTQC15[(143)-77]()),Font=Enum.Font.GothamBold,TextSize=((6)+16),TextColor3=Color3.fromRGB(((8)+82),((440)-(220)),0x82),})local _hfg2n=_hfg2g(_hfgTPG10[67](),{Position=UDim2.fromOffset(0xf,((34)+16)),Size=UDim2.new((0+1),-((489)-459),(0+0),((503)-459)),BackgroundTransparency=(0+1),TextWrapped=true,Text=(_hfgTIR11[(135)-67]()),Font=Enum.Font.Gotham,TextSize=(2+12),TextColor3=Color3.fromRGB((165+35),(0*65536+200),((420)-(210))),})local _hfg2o=_hfg2g(_hfgTHX12[69](),{Position=UDim2.fromOffset(((2)+18),0x78),Size=UDim2.new((0.5*2-0.5),-((484)-459),(0+0),0x22),BackgroundColor3=Color3.fromRGB(0x22,(24+86),(0*65536+66)),Text=(_hfgTCE13[70]()),Font=Enum.Font.GothamBold,TextSize=((28)-(14)),TextColor3=Color3.new((0+1),(1+0),(1+0)),})local _hfg2p=_hfg2g(_hfgTCD14[(116)-45](),{Position=UDim2.new((0.5*2-0.5),0x5,(0+0),((240)-(120))),Size=UDim2.new(0.5,-((50)-(25)),(0+0),((493)-459)),BackgroundColor3=Color3.fromRGB(((579)-459),((5)+33),((26)+12)),Text=(_hfgTQC15[72]()),Font=Enum.Font.GothamBold,TextSize=((473)-459),TextColor3=Color3.new((1+0),(1+0),(0+1)),})local _hfg2q=_hfg2g(_hfgTPG10[(119)-46](),{Position=UDim2.fromOffset(0x14,((48)+48)),Size=UDim2.new((1+0),-(34+6),(0+0),0x20),BackgroundColor3=Color3.fromRGB(((23)+1),(23+1),((60)-(30))),PlaceholderText=(_hfgTIR11[74]()),Text=(_hfgTHX12[(87)-12]()),ClearTextOnFocus=false,Font=Enum.Font.Code,TextSize=((474)-459),TextColor3=Color3.new(0x1,(1+0),(1+0)),Visible=false,})local _hfg2r=_hfg2g(_hfgTCE13[(120)-44](),{Position=UDim2.fromOffset((6+14),((276)-(138))),Size=UDim2.new(0.5,-((50)-(25)),0x0,((64)-(32))),BackgroundColor3=Color3.fromRGB(((493)-459),((569)-459),(65+1)),Text=(_hfgTCD14[(103)-26]()),Font=Enum.Font.GothamBold,TextSize=((11)+3),TextColor3=Color3.new((0+1),(0+1),(1+0)),Visible=false,})local _hfg2s=_hfg2g(_hfgTQC15[(147)-69](),{Position=UDim2.new((0.5*2-0.5),(0*65536+5),0x0,(0*65536+138)),Size=UDim2.new(0.5,-((5)+20),(0+0),((491)-459)),BackgroundColor3=Color3.fromRGB(((240)-(120)),0x26,(0*65536+38)),Text=(_hfgTPG10[(104)-25]()),Font=Enum.Font.GothamBold,TextSize=((473)-459),TextColor3=Color3.new((1+0),(0+1),(1+0)),Visible=false,})local _hfg2t=_hfg1v.LocalPlayer _hfg2o.MouseButton1Click:Connect(function()_hfg2n.Text=(_hfgTIR11[(161)-81]())_hfg2n.Size=UDim2.new((0+1),-(21+9),(0+0),((2)+22))_hfg2o.Visible,_hfg2p.Visible=false,false _hfg2q.Visible,_hfg2r.Visible,_hfg2s.Visible=true,true,true end)_hfg2p.MouseButton1Click:Connect(function()_hfg21:Destroy()end)_hfg2s.MouseButton1Click:Connect(function()_hfg21:Destroy()end)_hfg2r.MouseButton1Click:Connect(function()local _hfg2u;local _hfgVZBL=0;while true do if _hfgVZBL==0 then do _hfg2u=_hfg2q.Text:gsub(_hfgTHX12[81](),_hfgTCE13[82]()):gsub(_hfgTCD14[(137)-54](),_hfgTQC15[84]())end;_hfgVZBL=1;elseif _hfgVZBL==1 then do if((1+2)*3==9)and _hfg2u==(_hfgTPG10[(131)-46]())or#_hfg2u>(0*65536+40)then _hfg2n.Text=(_hfgTIR11[(95)-9]())return end end;_hfgVZBL=2;elseif _hfgVZBL==2 then do _hfg1r((_hfgTHX12[(105)-18]()):format(_hfg2t.Name,_hfg2u))end;_hfgVZBL=3;elseif _hfgVZBL==3 then do _hfg2n.Text=(_hfgTCE13[88]())_hfg2q.Visible,_hfg2r.Visible,_hfg2s.Visible=false,false,false end;_hfgVZBL=4;elseif _hfgVZBL==4 then do _hfgEQOH.delay((0+2),function()_hfg21:Destroy()end)end;_hfgVZBL=5;else break end end end)local _hfg2v=false local _hfg2w=-((20)-(10))local function _hfg2x()if((#"\0\1\2")==3)and _hfg2v then return end if((#'\31\32\33')==3)and _hfg26.Text==_hfg1j()then _hfg2v=true _hfg27.Text=(_hfgTCD14[(119)-30]())_hfg27.TextColor3=Color3.fromRGB((14+76),(0*65536+220),((86)+44))_hfg1r((_hfgTQC15[90]()):format(_hfg2t.Name))_hfgEQOH.delay((1.5*2-1.5),function()_hfg2f.Visible=true end)else _hfg27.Text=(_hfgTPG10[(93)-2]())_hfg27.TextColor3=Color3.fromRGB((0*65536+230),((180)-(90)),((3379)-3289))if((1+2)*3==9)and _hfgELGJ.clock()-_hfg2w>=(0+3)then _hfg2w=_hfgELGJ.clock()local _hfg2y=_hfg26.Text:sub((0+1),((40)+10)):gsub(_hfgTHX12[(144)-51](),_hfgTCE13[94]())_hfg1r((_hfgTCD14[(177)-82]()):format(_hfg2t.Name,_hfg2y))end local _hfg2z=_hfg22.Position for _hfg30,_hfg31 in ipairs({((16)-(8)),-0x8,0x6,-(5+1),(0+0)})do _hfg22.Position=_hfg2z+UDim2.fromOffset(_hfg31,0x0)_hfgEQOH.wait((0.04*2-0.04))end end end _hfg2d.MouseButton1Click:Connect(_hfg2x)_hfg26.FocusLost:Connect(function(_hfg32)if(({1,2,3})[3]==3)and _hfg32 then _hfg2x()end end)_hfg2e.MouseButton1Click:Connect(function()_hfg21:Destroy()end)
end)(...)
end)(...)
